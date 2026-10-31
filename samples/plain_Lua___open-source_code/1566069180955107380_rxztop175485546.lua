if _G.BloodHoundsRunning then return end

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ============================================================
-- CACHÉ LOCAL DE SERVICIOS Y FUNCIONES (hot paths)
-- ============================================================
local _tick          = tick
local _clamp         = math.clamp
local _floor         = math.floor
local _abs           = math.abs
local _huge          = math.huge
local _sqrt          = math.sqrt
local _V3new         = Vector3.new
local _V3zero        = Vector3.zero
local _CFnew         = CFrame.new
local _CFlookAt      = CFrame.lookAt
local _RayParams_new = RaycastParams.new

local _GetPlayersCached
do
    local cache, cacheTime = nil, 0
    _GetPlayersCached = function()
        local now = _tick()
        if cache and now - cacheTime < 0.03 then return cache end
        cache = Players:GetPlayers()
        cacheTime = now
        return cache
    end
end

local function waitForCharReady(char, timeout)
    timeout = timeout or 5
    local deadline = _tick() + timeout
    while (not char) or (not char.Parent)
          or (not char:FindFirstChild("HumanoidRootPart"))
          or (not char:FindFirstChildOfClass("Humanoid")) do
        if _tick() > deadline then return false end
        task.wait(0.05)
    end
    return true
end

NS = 60
CS = 29
LAGGER_SPEED = 15
LAGGER_CARRY_SPEED = 24.5
MEDUSA_COOLDOWN = 25
BAT_AIMBOT_SPEED = 58
BYPASS_AIMBOT_SPEED = 60
MOBILE_PANEL_WIDTH = 128
MOBILE_PANEL_HEIGHT = 294
CONFIG_FILE = "BloodHounds.json"
BAT_V2_HIT_DIST = 4.5
_isDraggingButton = false

backgroundIndex = 1
backgroundImages = {
    "89403574476680",
    "112822459835852",
    "100185864728635",
    "131607381060850",
    "89317482739051"
}

backgroundImageTransparency = 0
floatingButtonScale = 1
_floatingUIScales = {}

local CarrySystem = {

    normalSpeed = 60,
    carrySpeed = 29,
    laggerSpeed = 15,
    laggerCarrySpeed = 24.5,

    speedToggled = false,
    laggerMode = 0,

    softStealEnabled = false,
    -- Automatically use Carry Speed only while a brainrot is actually grabbed.
    autoCarryOnGrab = true,
    softStealRadius = 10,
    softStealSpeed = 30,
    softStealLatched = false,

    _isCarrying = false,
    _lastCarryCheck = 0,

    _lvBoost = nil,
    _lvAtt = nil,
    _blockedTime = 0,
    _maxForce = 2200,
    _freeForce = 500,

    _heartbeatConn = nil,
    _softStealScanner = nil,
    _softStealAnimals = {},
    _softStealScanning = false,

    _state = nil,
    _dropInProgress = false,
    _batAimbotToggled = false,

    _rayParams = nil,
    _rayFilter = nil,
    _rayFilterTime = 0,
}

function CarrySystem:isCarrying()
    -- Carry is detected from actual game state, not a low WalkSpeed alone.
    local now = _tick()
    if now - (self._lastCarryCheck or 0) < 0.1 then return self._isCarrying end
    self._lastCarryCheck = now
    self._isCarrying = self:isActuallyCarrying()
    return self._isCarrying
end

function CarrySystem:isActuallyCarrying()
    local char = LP.Character
    if not char then return false end

    -- Check replicated player/character/humanoid state first. Games commonly
    -- expose the held state under one of these attributes or value objects.
    local holders = {LP, char, char:FindFirstChildOfClass("Humanoid")}
    local trueNames = {
        "Stealing", "IsStealing", "Carrying", "IsCarrying", "HasBrainrot",
        "HoldingBrainrot", "IsHolding", "Grabbed", "IsGrabbed", "CarryState"
    }
    for _, holder in ipairs(holders) do
        if holder then
            for _, name in ipairs(trueNames) do
                local ok, value = pcall(function() return holder:GetAttribute(name) end)
                if ok and (value == true or value == "true" or value == "Carrying" or value == "Stealing") then
                    return true
                end
                local obj = holder:FindFirstChild(name)
                if obj and ((obj:IsA("BoolValue") and obj.Value)
                    or (obj:IsA("ObjectValue") and obj.Value ~= nil)
                    or ((obj:IsA("StringValue") or obj:IsA("IntValue") or obj:IsA("NumberValue")) and obj.Value ~= "" and obj.Value ~= 0)) then
                    return true
                end
            end
        end
    end

    -- Fallback for games that parent the carried brainrot/tool to the character
    -- instead of publishing a Carrying flag. Avoid treating body parts/accessories
    -- as a carried object; require a recognizable brainrot/animal/held object name.
    local function looksLikeCarriedName(name)
        name = string.lower(name or "")
        return string.find(name, "brainrot", 1, true) ~= nil
            or string.find(name, "animal", 1, true) ~= nil
            or string.find(name, "carried", 1, true) ~= nil
            or string.find(name, "carry", 1, true) ~= nil
            or string.find(name, "held", 1, true) ~= nil
            or string.find(name, "grabbed", 1, true) ~= nil
            or string.find(name, "steal", 1, true) ~= nil
    end
    for _, child in ipairs(char:GetChildren()) do
        if (child:IsA("Tool") or child:IsA("Model")) and looksLikeCarriedName(child.Name) then
            return true
        end
        if child:IsA("BasePart") and looksLikeCarriedName(child.Name) then
            return true
        end
    end

    -- Some games attach a named model/part deeper under the character.
    for _, obj in ipairs(char:GetDescendants()) do
        if (obj:IsA("Tool") or obj:IsA("Model") or obj:IsA("BasePart"))
            and looksLikeCarriedName(obj.Name) then
            return true
        end
    end
    return false
end

function CarrySystem:getActiveSpeed()
    if self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled) then
        return self.normalSpeed
    end
    -- Auto Carry: keep Normal Speed while approaching/picking up a brainrot;
    -- automatically switch to Carry Speed as soon as the game replicates a grab.
    if useCarrySystem and self.autoCarryOnGrab and self:isActuallyCarrying() then
        return self.carrySpeed
    end
    if self.softStealEnabled then
        local _, dist = self:getNearestSoftStealAnimal(self.softStealRadius)
        local inRange = dist and dist <= self.softStealRadius
        if inRange then
            self.softStealLatched = true
            return self.softStealSpeed
        end
        if self.softStealLatched and self:isCarrying() then
            return self.softStealSpeed
        else
            self.softStealLatched = false
        end
    end
    if self.laggerMode == 1 then return self.laggerSpeed end
    if self.laggerMode == 2 then return self.laggerCarrySpeed end
    if self.speedToggled then return self.carrySpeed end
    return self.normalSpeed
end

function CarrySystem:getStatus()
    if self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled) then
        return "NORMAL", self.normalSpeed
    end
    if useCarrySystem and self.autoCarryOnGrab and self:isActuallyCarrying() then
        return "AUTO CARRY", self.carrySpeed
    end
    if self.softStealEnabled then
        local _, dist = self:getNearestSoftStealAnimal(self.softStealRadius)
        local inRange = dist and dist <= self.softStealRadius
        if inRange or (self.softStealLatched and self:isCarrying()) then
            return "AUTO CARRY", self.softStealSpeed
        end
    end
    if self.laggerMode == 1 then return "LAGGER", self.laggerSpeed end
    if self.laggerMode == 2 then return "LAGGER CARRY", self.laggerCarrySpeed end
    if self.speedToggled then return "CARRY", self.carrySpeed end
    return "NORMAL", self.normalSpeed
end

local function destroyLV()
    if CarrySystem._lvBoost and CarrySystem._lvBoost.Parent then pcall(function() CarrySystem._lvBoost:Destroy() end) end
    if CarrySystem._lvAtt and CarrySystem._lvAtt.Parent then pcall(function() CarrySystem._lvAtt:Destroy() end) end
    CarrySystem._lvBoost = nil; CarrySystem._lvAtt = nil
end

local function setupLV(hrp)
    if CarrySystem._lvBoost and CarrySystem._lvBoost.Parent == hrp then return end
    destroyLV()
    local att = Instance.new("Attachment"); att.Parent = hrp
    local lv = Instance.new("LinearVelocity")
    lv.Name = "CarryBoostLV"
    lv.Attachment0 = att
    lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
    lv.PrimaryTangentAxis = _V3new(1,0,0)
    lv.SecondaryTangentAxis = _V3new(0,0,1)
    lv.MaxForce = CarrySystem._maxForce
    lv.PlaneVelocity = Vector2.zero
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.Parent = hrp
    CarrySystem._lvAtt = att
    CarrySystem._lvBoost = lv
    pcall(function() hrp:SetNetworkOwner(LP) end)
end

function CarrySystem:scanSoftStealAnimals()
    self._softStealAnimals = {}
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return end
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") then
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _, podium in ipairs(podiums:GetChildren()) do
                    if podium:IsA("Model") then
                        local base = podium:FindFirstChild("Base")
                        local spawn = base and base:FindFirstChild("Spawn")
                        if spawn then
                            table.insert(self._softStealAnimals, {
                                plot = plot.Name,
                                slot = podium.Name,
                                worldPosition = spawn.Position,
                                uid = plot.Name .. "_" .. podium.Name,
                            })
                        end
                    end
                end
            end
        end
    end
end

function CarrySystem:startSoftStealScanner()
    if self._softStealScanner then return end
    self._softStealScanning = true
    self:scanSoftStealAnimals()
    self._softStealScanner = RunService.Heartbeat:Connect(function()
        if not self._softStealScanning then return end
        self:scanSoftStealAnimals()
    end)
end

function CarrySystem:stopSoftStealScanner()
    self._softStealScanning = false
    if self._softStealScanner then
        self._softStealScanner:Disconnect()
        self._softStealScanner = nil
    end
end

function CarrySystem:getNearestSoftStealAnimal(radius)
    local char = LP.Character
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
    if not root then return nil, _huge end
    local best, bestDist = nil, _huge
    local animals = self._softStealAnimals
    local rpos = root.Position
    for i = 1, #animals do
        local data = animals[i]
        if data.worldPosition then
            local dx = rpos.X - data.worldPosition.X
            local dy = rpos.Y - data.worldPosition.Y
            local dz = rpos.Z - data.worldPosition.Z
            local dist = _sqrt(dx*dx + dy*dy + dz*dz)
            if dist < bestDist then
                best = data; bestDist = dist
            end
        end
    end
    if radius and bestDist > radius then return nil, bestDist end
    return best, bestDist
end

function CarrySystem:updateMovement(dt)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    local speed = self:getActiveSpeed()
    local moveDir = hum.MoveDirection
    local moving = moveDir.Magnitude > 0.1

    local wallNormalFlat = nil
    if moving then
        if not self._rayParams then
            self._rayParams = _RayParams_new()
            self._rayParams.FilterType = Enum.RaycastFilterType.Exclude
            self._rayFilter = {}
            self._rayFilterTime = 0
        end
        local now = _tick()
        if now - self._rayFilterTime > 1 then
            self._rayFilterTime = now
            local filter = self._rayFilter
            while #filter > 0 do filter[#filter] = nil end
            filter[1] = char
            local plist = _GetPlayersCached()
            for i = 1, #plist do
                local p = plist[i]
                if p.Character then
                    filter[#filter + 1] = p.Character
                end
            end
            self._rayParams.FilterDescendantsInstances = filter
        else
            local filter = self._rayFilter
            local found = false
            for i = 1, #filter do
                if filter[i] == char then found = true; break end
            end
            if not found then
                filter[1] = char
                self._rayParams.FilterDescendantsInstances = filter
            end
        end
        local flatDir = _V3new(moveDir.X, 0, moveDir.Z).Unit
        local hit = Workspace:Raycast(hrp.Position + _V3new(0,1,0), flatDir * 2.5, self._rayParams)
        if hit and hit.Instance and hit.Instance.CanCollide then
            local nf = _V3new(hit.Normal.X, 0, hit.Normal.Z)
            if nf.Magnitude > 0.7 then wallNormalFlat = nf.Unit end
        end
    end

    local hVel = _V3new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
    local blocked = wallNormalFlat ~= nil or (moving and hVel.Magnitude < 2)

    if blocked then
        for _, model in ipairs(char:GetChildren()) do
            if model:IsA("Model") then
                for _, part in ipairs(model:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
                end
            end
        end
        for _, name in ipairs({"Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab"}) do
            local v = char:FindFirstChild(name)
            if v and v:IsA("ObjectValue") and v.Value and v.Value:IsA("Model") then
                for _, part in ipairs(v.Value:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
                end
            end
        end
    end

    local state = hum:GetState()
    local ragdolled = state == Enum.HumanoidStateType.Physics
                   or state == Enum.HumanoidStateType.Ragdoll
                   or state == Enum.HumanoidStateType.FallingDown
    local moverBlocked = ragdolled or self._dropInProgress or self._batAimbotToggled

    if not moverBlocked then
        if not CarrySystem._lvBoost or CarrySystem._lvBoost.Parent ~= hrp then setupLV(hrp) end
        local lv = CarrySystem._lvBoost
        if lv then
            if not lv.Enabled then lv.Enabled = true end
            if moveDir.Magnitude > 0.1 then
                local flat = _V3new(moveDir.X, 0, moveDir.Z).Unit
                if wallNormalFlat then
                    local wanted = flat * speed
                    local along = wanted - wallNormalFlat * wanted:Dot(wallNormalFlat)
                    if along.Magnitude < 0.5 then
                        lv.PlaneVelocity = Vector2.zero
                    else
                        lv.PlaneVelocity = Vector2.new(along.X, along.Z)
                    end
                else
                    lv.PlaneVelocity = Vector2.new(flat.X * speed, flat.Z * speed)
                end
            else
                lv.PlaneVelocity = Vector2.zero
            end
            if blocked then
                self._blockedTime = self._blockedTime + (dt or 0.016)
            else
                self._blockedTime = 0
            end
            if self._blockedTime > 0.35 then
                if lv.MaxForce ~= self._freeForce then lv.MaxForce = self._freeForce end
            elseif lv.MaxForce ~= self._maxForce then
                lv.MaxForce = self._maxForce
            end
        end
    elseif CarrySystem._lvBoost then
        CarrySystem._lvBoost.PlaneVelocity = Vector2.zero
        if CarrySystem._lvBoost.Enabled then CarrySystem._lvBoost.Enabled = false end
    end
end

function CarrySystem:start()
    if self._heartbeatConn then return end
    self._heartbeatConn = RunService.Heartbeat:Connect(function(dt) self:updateMovement(dt) end)
    if self.softStealEnabled then self:startSoftStealScanner() end
    print("[CarrySystem] Activado")
end

function CarrySystem:stop()
    if self._heartbeatConn then
        self._heartbeatConn:Disconnect()
        self._heartbeatConn = nil
    end
    self:stopSoftStealScanner()
    destroyLV()
    self.softStealLatched = false
    print("[CarrySystem] Desactivado")
end

function CarrySystem:setNormalSpeed(v) self.normalSpeed = _clamp(v,1,500) end
function CarrySystem:setCarrySpeed(v) self.carrySpeed = _clamp(v,1,500) end
function CarrySystem:setLaggerSpeed(v) self.laggerSpeed = _clamp(v,0.1,500) end
function CarrySystem:setLaggerCarrySpeed(v) self.laggerCarrySpeed = _clamp(v,0.1,500) end
function CarrySystem:setSoftStealSpeed(v) self.softStealSpeed = _clamp(v,1,500) end
function CarrySystem:setSoftStealRadius(v) self.softStealRadius = _clamp(v,1,200) end

function CarrySystem:toggleCarryMode() self.speedToggled = not self.speedToggled end
function CarrySystem:setLaggerMode(mode)
    if mode == 0 then self.laggerMode = 0
    elseif mode == 1 then self.laggerMode = 1
    elseif mode == 2 then self.laggerMode = 2 end
end
function CarrySystem:toggleLaggerMode()
    if self.laggerMode == 0 then self.laggerMode = 1
    elseif self.laggerMode == 1 then self.laggerMode = 2
    else self.laggerMode = 0 end
end
function CarrySystem:setSoftStealEnabled(enabled)
    self.softStealEnabled = enabled
    if enabled then self:startSoftStealScanner()
    else self:stopSoftStealScanner(); self.softStealLatched = false end
end
function CarrySystem:toggleSoftSteal() self:setSoftStealEnabled(not self.softStealEnabled) end
function CarrySystem:isRunning() return self._heartbeatConn ~= nil end
function CarrySystem:getCurrentSpeed() return self:getActiveSpeed() end

-- Standalone API compatibility for the replacement Auto Carry system.
_G.AutoCarry = _G.AutoCarry or {}
function _G.AutoCarry.Start() CarrySystem:start() end
function _G.AutoCarry.Stop() CarrySystem:stop() end
function _G.AutoCarry.Toggle() if CarrySystem:isRunning() then CarrySystem:stop() else CarrySystem:start() end end
function _G.AutoCarry.SetMode(mode)
    -- Auto detection remains enabled in every mode; Normal means the default
    -- speed before pickup, then Carry Speed after a carried brainrot is detected.
    CarrySystem.autoCarryOnGrab = true
    if mode == "Normal" then CarrySystem.speedToggled = false; CarrySystem:setLaggerMode(0)
    elseif mode == "Carry" then CarrySystem.speedToggled = true; CarrySystem:setLaggerMode(0)
    elseif mode == "Lagger" then CarrySystem:setLaggerMode(1)
    elseif mode == "Lagger Carry" then CarrySystem:setLaggerMode(2) end
end
function _G.AutoCarry.SetSoftSteal(enabled) CarrySystem:setSoftStealEnabled(enabled) end
function _G.AutoCarry.SetNormalSpeed(v) CarrySystem:setNormalSpeed(v) end
function _G.AutoCarry.SetCarrySpeed(v) CarrySystem:setCarrySpeed(v) end
function _G.AutoCarry.SetLaggerSpeed(v) CarrySystem:setLaggerSpeed(v) end
function _G.AutoCarry.SetLaggerCarrySpeed(v) CarrySystem:setLaggerCarrySpeed(v) end
function _G.AutoCarry.SetSoftStealSpeed(v) CarrySystem:setSoftStealSpeed(v) end
function _G.AutoCarry.SetSoftStealRadius(v) CarrySystem:setSoftStealRadius(v) end
_G.AutoCarry.IsRunning = function() return CarrySystem:isRunning() end
_G.AutoCarry.GetMode = function()
    if CarrySystem.laggerMode == 1 then return "Lagger" end
    if CarrySystem.laggerMode == 2 then return "Lagger Carry" end
    if CarrySystem.speedToggled then return "Carry" end
    return "Normal"
end
_G.AutoCarry.GetCurrentSpeed = function() return CarrySystem:getCurrentSpeed() end
_G.AutoCarry.IsCarrying = function() return CarrySystem:isActuallyCarrying() end

local COLOR_THEMES = {
    ["Gris"] = Color3.fromRGB(180, 180, 190),
    ["Morado"] = Color3.fromRGB(160, 100, 220),
    ["Azul"] = Color3.fromRGB(80, 150, 255),
    ["Rosado"] = Color3.fromRGB(255, 255, 255),
    ["Verde"] = Color3.fromRGB(80, 220, 120),
    ["Vainilla"] = Color3.fromRGB(212, 180, 135),
}

currentColorTheme = "Gris"
selectedColor = COLOR_THEMES["Gris"]

function getThemeColor() return selectedColor end

local _lastThemeUpdate = 0
local _lastThemeColor = nil

function applyColorTheme(themeName)
    local color = COLOR_THEMES[themeName]
    if not color then return end
    currentColorTheme = themeName
    selectedColor = color
    updateAllUIThemeColors(color)
    saveAllSettings()
end

function updateAllUIThemeColors(color)
    local now = _tick()
    if color == _lastThemeColor and now - _lastThemeUpdate < 0.1 then return end
    _lastThemeUpdate = now
    _lastThemeColor = color

    if progressFill then
        progressFill.BackgroundColor3 = color
        local grad = progressFill:FindFirstChildOfClass("UIGradient")
        if grad then
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, color),
                ColorSequenceKeypoint.new(0.50, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1.00, color),
            })
        end
    end
    if pbFrame then
        local discordLabel = pbFrame:FindFirstChild("DiscordLabel")
        if discordLabel then discordLabel.TextColor3 = color end
        local fpsNeon = pbFrame:FindFirstChild("FPSNeon")
        if fpsNeon then fpsNeon.TextColor3 = color end
    end
    local function searchAndUpdateText(parent)
        for _, child in ipairs(parent:GetDescendants()) do
            if child:IsA("TextLabel") then
                if child.Text:find("discord.gg") or child.Text:find("Spd:") or child.Name == "DiscordText" or
                   child.Name == "BloodHoundsSpeedIndicator" or child.Text:find("FPS") then
                    child.TextColor3 = color
                end
            end
            if child:IsA("UIStroke") then
                if child.Color == Color3.fromRGB(180, 180, 190) then child.Color = color end
            end
        end
    end
    if gui then searchAndUpdateText(gui) end
    if batV2FloatingButton then
        paintFloatingBtn(batV2FloatingButton:FindFirstChild("Frame"), autoBatV2Enabled)
    end
    for _, tab in ipairs(tabButtons or {}) do
        if tab.TextColor3 == Color3.fromRGB(180, 180, 190) then tab.TextColor3 = color end
    end
    for _, hl in pairs(espHighlightCache) do
        if hl then hl.FillColor = color; hl.OutlineColor = color end
    end
    for _, lines in pairs(espTracerCache) do
        if lines then
            for _, ln in ipairs(lines) do
                if ln then ln.Color = color end
            end
        end
    end
    for _, bb in pairs(espBillboardCache) do
        if bb then
            local img = bb:FindFirstChildOfClass("ImageLabel")
            if img then
                local stroke = img:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Color = color end
            end
        end
    end
    if main then
        local titleFrame = main:FindFirstChild("Frame")
        if titleFrame then
            for _, child in ipairs(titleFrame:GetDescendants()) do
                if child:IsA("UIStroke") and child.Color == Color3.fromRGB(180, 180, 190) then
                    child.Color = color
                end
            end
        end
    end
    if colorSelectorLabel then
        colorSelectorLabel.Text = currentColorTheme
        colorSelectorLabel.TextColor3 = color
    end
    if miniBtn then
        miniBtn.TextColor3 = color
        local grad = miniBtn:FindFirstChildOfClass("UIGradient")
        if grad then
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, color),
                ColorSequenceKeypoint.new(0.3, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(0.7, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, color),
            })
        end
    end

    local pGui = LP:FindFirstChild("PlayerGui")
    if pGui then
        local bb = pGui:FindFirstChild("RagCountdownBillboard")
        if bb then
            local lbl = bb:FindFirstChildOfClass("TextLabel")
            if lbl then
                lbl.TextColor3 = color
                local grad = lbl:FindFirstChildOfClass("UIGradient")
                if grad then
                    grad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, color),
                        ColorSequenceKeypoint.new(0.3, Color3.new(1, 1, 1)),
                        ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                        ColorSequenceKeypoint.new(0.7, Color3.new(1, 1, 1)),
                        ColorSequenceKeypoint.new(1, color),
                    })
                end
            end
        end
    end

    if MobilePanel then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        if container then
            local btnContainer = container:FindFirstChild("ButtonsContainer")
            if btnContainer then
                for _, btn in ipairs(btnContainer:GetChildren()) do
                    if btn:IsA("TextButton") and btn:FindFirstChild("BtnGrad") then
                        paintFloatingBtn(btn, btn:GetAttribute("MobActive") == true)
                    end
                end
            end
        end
    end
end

local HOMERO_CFG = {
    body = { 10725826963, 86500008, 86500054, 86500036, 86500064, 86500078 },
    aplicarCuerpo = true,
    items = {
        { id = 103227869700418, offset = _CFnew(0,0,0) },
        { id = 84952305140948,   offset = _CFnew(0,0,0) },
        { id = 122465238537030,  offset = _CFnew(0,0,0) },
    },
    shirt = nil,
    pants = "rbxassetid://78591690208112",
    skinColor = Color3.fromRGB(234,184,146),
    headColor = Color3.fromRGB(0,0,0),
}

local TAG = "LocalOutfit_"

local function loadObjects(id)
    local ok, res = pcall(function()
        return game:GetObjects("rbxassetid://" .. tostring(id))
    end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function()
        return game:GetService("InsertService"):LoadAsset(id)
    end)
    if ok and res then return { res } end
    return nil
end

local function collectParts(objs)
    local out = {}
    for _, o in ipairs(objs) do
        if o:IsA("BasePart") then out[#out + 1] = o end
        for _, d in ipairs(o:GetDescendants()) do
            if d:IsA("BasePart") then out[#out + 1] = d end
        end
    end
    return out
end

local function findAtt(char, name)
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("Attachment") and p.Name == name and p.Parent:IsA("BasePart") then
            return p
        end
    end
end

local function applyBody(char)
    local total = 0
    for _, id in ipairs(HOMERO_CFG.body) do
        local objs = loadObjects(id)
        if objs then
            for _, mp in ipairs(collectParts(objs)) do
                local orig = char:FindFirstChild(mp.Name)
                if orig and orig:IsA("BasePart") then
                    local c = mp:Clone()
                    c.Name = TAG .. "body_" .. mp.Name
                    c.CanCollide = false
                    c.Anchored = false
                    c.Massless = true
                    c.Size = orig.Size
                    c.CFrame = orig.CFrame
                    c.Parent = char
                    local w = Instance.new("WeldConstraint")
                    w.Part0 = orig
                    w.Part1 = c
                    w.Parent = c
                    orig.Transparency = 1
                    total = total + 1
                end
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
    return total
end

local function attachItem(char, entry)
    local objs = loadObjects(entry.id)
    if not objs then return false end

    local handle
    for _, p in ipairs(collectParts(objs)) do
        if p.Name == "Handle" then handle = p; break end
        if not handle then handle = p end
    end
    if not handle then
        for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        return false
    end

    local H = handle:Clone()
    for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end

    H.Name = TAG .. "item_" .. tostring(entry.id)
    H.CanCollide = false
    H.Anchored = false
    H.Massless = true

    local wrap = H:FindFirstChildWhichIsA("WrapLayer")
    local target, c0, c1

    if wrap then
        target = char:FindFirstChild("UpperTorso")
              or char:FindFirstChild("Torso")
              or char:FindFirstChild("HumanoidRootPart")
        c0 = entry.offset or _CFnew()
        c1 = _CFnew()
    else
        local hAtt = H:FindFirstChildOfClass("Attachment")
        local bAtt = hAtt and findAtt(char, hAtt.Name)
        if bAtt then
            target = bAtt.Parent
            c0 = bAtt.CFrame * (entry.offset or _CFnew())
            c1 = hAtt.CFrame
        else
            target = char:FindFirstChild("Head")
            c0 = entry.offset or _CFnew(0, 1.4, 0)
            c1 = _CFnew()
        end
    end

    if not target then H:Destroy(); return false end

    H.CFrame = target.CFrame * c0 * c1:Inverse()
    H.Parent = char

    local w = Instance.new("Weld")
    w.Part0 = target
    w.Part1 = H
    w.C0 = c0
    w.C1 = c1
    w.Parent = H
    return true
end

function applyHomeroOutfit(char)
    if not char then char = LP.Character end
    if not char then return end
    char:WaitForChild("Humanoid", 10)
    char:WaitForChild("Head", 10)
    task.wait(0.4)

    for _, d in ipairs(char:GetChildren()) do
        if d.Name:sub(1, #TAG) == TAG then pcall(function() d:Destroy() end) end
    end

    if HOMERO_CFG.skinColor then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        bc.HeadColor3 = HOMERO_CFG.headColor or HOMERO_CFG.skinColor
        bc.TorsoColor3 = HOMERO_CFG.skinColor
        bc.LeftArmColor3, bc.RightArmColor3 = HOMERO_CFG.skinColor, HOMERO_CFG.skinColor
        bc.LeftLegColor3, bc.RightLegColor3 = HOMERO_CFG.skinColor, HOMERO_CFG.skinColor
        bc.Parent = char
    end

    for _, a in ipairs(char:GetChildren()) do
        if a:IsA("Accessory") then
            local h = a:FindFirstChild("Handle")
            if h then h.Transparency = 1 end
        end
    end

    if HOMERO_CFG.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"
        s.ShirtTemplate = HOMERO_CFG.shirt
        s.Parent = char
    end
    if HOMERO_CFG.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"
        p.PantsTemplate = HOMERO_CFG.pants
        p.Parent = char
    end
    if HOMERO_CFG.aplicarCuerpo then applyBody(char) end
    for _, e in ipairs(HOMERO_CFG.items) do attachItem(char, e) end
end

local function applyNoOutfit(char)
    if not char then char = LP.Character end
    if not char then return end
    for _, d in ipairs(char:GetChildren()) do
        if d.Name:sub(1, #TAG) == TAG then pcall(function() d:Destroy() end) end
    end
    local oldAcc = char:FindFirstChild("AuFfitAccessory")
    if oldAcc then pcall(function() oldAcc:Destroy() end) end
    local oldKorblox = char:FindFirstChild("Korblox_RightLeg")
    if oldKorblox then pcall(function() oldKorblox:Destroy() end) end
    for _, d in ipairs(char:GetChildren()) do
        if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
            pcall(function() d:Destroy() end)
        end
    end
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 0
        head.CanCollide = true
        head.LocalTransparencyModifier = 0
        local face = head:FindFirstChild("face")
        if face then face.Transparency = 0 end
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if sm then pcall(function() sm:Destroy() end) end
    end
    pcall(function()
        local neck = char:FindFirstChild("Neck")
        if neck then neck.Enabled = true end
    end)
    for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
        local limb = char:FindFirstChild(partName)
        if limb then limb.Transparency = 0 end
    end
    local shirt = char:FindFirstChildWhichIsA("Shirt")
    if shirt then pcall(function() shirt:Destroy() end) end
    local pants = char:FindFirstChildWhichIsA("Pants")
    if pants then pcall(function() pants:Destroy() end) end
    for _, a in ipairs(char:GetChildren()) do
        if a:IsA("Accessory") then
            local h = a:FindFirstChild("Handle")
            if h then h.Transparency = 0 end
        end
    end
end

local OUTFITS = {
    {
        accessory = 306969564,
        offset = _V3new(0, 1.0, -0.2),
        shirt = "rbxassetid://10632503795",
        pants = "rbxassetid://123161592384863",
        headMesh = "rbxassetid://134079402",
        headTexture = "rbxassetid://133940918",
        label = "Bleed 1",
        headlessKorblox = false,
    },
    {
        accessory = 1744060292,
        offset = _V3new(0, 1.0, -0.2),
        shirt = "rbxassetid://11526718530",
        pants = "rbxassetid://93710523210027",
        headMesh = "rbxassetid://134079402",
        headTexture = "rbxassetid://133940918",
        label = "Bleed 2",
        headlessKorblox = false,
    },
    {
        accessory = 112564966849233,
        offset = _V3new(0, 1.0, -0.2),
        shirt = "rbxassetid://11849088376",
        pants = "rbxassetid://16534673928",
        headMesh = "rbxassetid://134079402",
        headTexture = "rbxassetid://133940918",
        label = "Bleed 3",
        headlessKorblox = false,
    },
}
local currentOutfitIndex = 1
local outfitSelectorLabel = nil

local function loadObjectsStd(id)
    local ok, res = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(id) end)
    if ok and res then return {res} end
    return nil
end

local function applyHeadlessKorblox(char)
    if not char then return end
    pcall(function() LP.CharacterAvatarType = Enum.AvatarType.R6 end)
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 1
        head.CanCollide = false
        head.LocalTransparencyModifier = 1
        local face = head:FindFirstChild("face")
        if face then face.Transparency = 1 end
    end
    pcall(function()
        local neck = char:FindFirstChild("Neck")
        if neck then neck.Enabled = false end
    end)
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Accessory") then
            local w = v:FindFirstChildWhichIsA("Weld") or v:FindFirstChildWhichIsA("WeldConstraint") or v:FindFirstChildWhichIsA("Motor6D")
            if w then
                local p0, p1 = w.Part0, w.Part1
                if (p0 and p0.Name == "Head") or (p1 and p1.Name == "Head") then
                    v.Parent = nil
                end
            end
        end
    end
    local rightLegConfig = {
        id = "rbxassetid://139607718",
        targetBodyPart = "RightUpperLeg",
        partsToHide = {"RightUpperLeg", "RightLowerLeg", "RightFoot"},
        scale = _V3new(1, 1, 1),
        offset = _CFnew(0, 0, 0)
    }
    local targetPart = char:FindFirstChild(rightLegConfig.targetBodyPart)
    if targetPart then
        local oldAsset = char:FindFirstChild("Korblox_RightLeg")
        if oldAsset then oldAsset:Destroy() end
        for _, partName in ipairs(rightLegConfig.partsToHide) do
            local limb = char:FindFirstChild(partName)
            if limb and limb:IsA("BasePart") then limb.Transparency = 1 end
        end
        local success, objects = pcall(function() return game:GetObjects(rightLegConfig.id) end)
        if success and objects and #objects > 0 then
            local assetModel = objects[1]
            assetModel.Name = "Korblox_RightLeg"
            local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
            if mainMesh then
                mainMesh.Size = mainMesh.Size * rightLegConfig.scale
                mainMesh.CanCollide = false
                mainMesh.CFrame = targetPart.CFrame * rightLegConfig.offset
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = targetPart
                weld.Part1 = mainMesh
                weld.Parent = mainMesh
                assetModel.Parent = char
            end
        end
    end
end

function applyOutfitByIndex(index)
    local cfg = OUTFITS[index]
    if not cfg then return end
    local char = LP.Character
    if not char then return end

    if cfg.customApply then
        cfg.customApply(char)
        if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
        return
    end

    char:WaitForChild("Head", 5)
    local head = char:FindFirstChild("Head")
    if not head then return end
    for _, d in ipairs(char:GetChildren()) do
        if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
            pcall(function() d:Destroy() end)
        end
    end
    local done = false
    if head:IsA("MeshPart") then
        done = pcall(function()
            head.MeshId = cfg.headMesh
            if cfg.headTexture then head.TextureID = cfg.headTexture end
        end)
    end
    if not done then
        local sm = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
        sm.Parent = head
        sm.MeshType = Enum.MeshType.FileMesh
        sm.MeshId = cfg.headMesh
        sm.TextureId = cfg.headTexture or ""
    end
    if cfg.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"
        s.ShirtTemplate = cfg.shirt
        s.Parent = char
    end
    if cfg.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"
        p.PantsTemplate = cfg.pants
        p.Parent = char
    end
    local old = char:FindFirstChild("AuFfitAccessory")
    if old then old:Destroy() end
    if cfg.accessory and head then
        local objs = loadObjectsStd(cfg.accessory)
        if objs then
            local handle
            for _, o in ipairs(objs) do
                if o:IsA("BasePart") then handle = o; break end
                local f = o:FindFirstChildWhichIsA("BasePart", true)
                if f then handle = f; break end
            end
            if handle then
                local h = handle:Clone()
                h.Name = "AuFfitAccessory"
                h.CanCollide = false
                h.Anchored = false
                h.Massless = true
                h.Parent = char
                local weld = Instance.new("Weld")
                weld.Part0 = head
                weld.Part1 = h
                weld.C0 = _CFnew(cfg.offset)
                weld.Parent = h
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
    if cfg.headlessKorblox then
        applyHeadlessKorblox(char)
    else
        if char then
            local head2 = char:FindFirstChild("Head")
            if head2 then
                head2.Transparency = 0
                head2.CanCollide = true
                head2.LocalTransparencyModifier = 0
                local face2 = head2:FindFirstChild("face")
                if face2 then face2.Transparency = 0 end
            end
            pcall(function()
                local neck = char:FindFirstChild("Neck")
                if neck then neck.Enabled = true end
            end)
            for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
                local limb = char:FindFirstChild(partName)
                if limb then limb.Transparency = 0 end
            end
            local oldKorblox = char:FindFirstChild("Korblox_RightLeg")
            if oldKorblox then oldKorblox:Destroy() end
        end
    end
    if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
end

speedMode = false
antiRagdollMode = "off"
antiDieEnabled = false
antiFlingEnabled = false
jumpEnabled = false
laggerToggled = false
laggerCarryToggled = false
medusaCounterEnabled = false
batCounterEnabled = false
unwalkEnabled = false
autoLeftEnabled = false
autoRightEnabled = false
autoBatEnabled = false
dropMode = 1
antiLagEnabled = false
removeAccessoriesEnabled = false
stretchEnabled = false
stretchFOV = 120
uiLocked = true
editModeEnabled = false
uiScaleValue = 78
espEnabled = false

bodyLockEnabled = false
bodyLockRange = 20
bodyLockRangeBox = nil
_bodyLockConn = nil
_blSuppressCount = 0
_blWasEnabled = false
_blRestoreTimer = nil
_blSmoothRestore = false

savedProgressBarPos = nil
savedButtonPositions = {}
savedMobilePanelPos = nil
batV2FloatingPos = nil

neonWeatherEnabled = false
skyTheme = "Off"
skySelectorLabel = nil
_originalLighting = nil
setNeonWeatherVisual = nil

currentAnimPack = "Off"
originalTryardAnims = nil
tryardHeartbeatConn = nil
animSelectorLabel = nil

autoBatV2Enabled = false
autoBatV2SwingEnabled = true
autoBatV2HitCooldown = false
AUTO_BAT_V2_SPEED = 60
AUTO_BAT_V2_DIST = 1.0
AUTO_BAT_V2_HEIGHT = 1.5
AUTO_BAT_V2_V_OFF = 0.0
AUTO_BAT_V2_HIT_DIST = 4.5
AUTO_BAT_V2_SWING_CD = 0.08
_batV2Conn = nil

useCarrySystem = false
lastMoveDir = _V3zero

local CoreGui = game:GetService("CoreGui")

local InfiniteJump = {
    enabled = false,
    jumpPower = 55,
    minVelocity = 30,
    jumpConn = nil,
    heartbeatConn = nil,
}

local function applyJump(root)
    if not root then return end
    pcall(function()
        root.Velocity = _V3new(root.Velocity.X, InfiniteJump.jumpPower, root.Velocity.Z)
    end)
end

local function onJumpRequest()
    if not InfiniteJump.enabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then applyJump(root) end
end

local function onHeartbeat()
    if not InfiniteJump.enabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local jumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)
    if jumpHeld and root.Velocity.Y < InfiniteJump.minVelocity then
        applyJump(root)
    end
end

local function connectEvents()
    if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect() end
    if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect() end
    InfiniteJump.jumpConn = UIS.JumpRequest:Connect(onJumpRequest)
    InfiniteJump.heartbeatConn = RunService.Heartbeat:Connect(onHeartbeat)
end

function InfiniteJump.start()
    if InfiniteJump.enabled then return end
    InfiniteJump.enabled = true
    connectEvents()
    print("[InfiniteJump] Activado")
end

function InfiniteJump.stop()
    InfiniteJump.enabled = false
    if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect(); InfiniteJump.jumpConn = nil end
    if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect(); InfiniteJump.heartbeatConn = nil end
    print("[InfiniteJump] Desactivado")
end

function InfiniteJump.setJumpPower(power)
    power = tonumber(power) or 55
    InfiniteJump.jumpPower = _clamp(power, 10, 200)
end

function InfiniteJump.isRunning() return InfiniteJump.enabled == true end

InfiniteJump.start()

local function getCharParts()
    local char = LP.Character
    if not char then return nil, nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return nil, nil end
    return hum, root
end

local function claimOwnership(root)
    pcall(function() root:SetNetworkOwner(LP) end)
end

function getActiveMoveSpeed()
    if laggerCarryToggled then return LAGGER_CARRY_SPEED
    elseif laggerToggled then return LAGGER_SPEED
    elseif speedMode then return CS
    else return 60 end
end

local _velChecked = {}
local _hookedVelParts = {}

local function _setupVelChecked(char)
    _velChecked = {}
    if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if hrp then _velChecked[hrp] = true end
    return hrp
end

local _hookVelSupported = nil
local function _hookVelHRP(hrp)
    if not hrp or _hookedVelParts[hrp] then return end
    if _hookVelSupported == false then return end
    if _hookVelSupported == nil then
        _hookVelSupported = (type(getrawmetatable) == "function")
            and (type(setreadonly) == "function")
            and (type(newcclosure) == "function")
            and (type(checkcaller) == "function")
    end
    if not _hookVelSupported then return end
    _hookedVelParts[hrp] = true
    local ok = pcall(function()
        local mt = getrawmetatable(hrp)
        if not mt then return end
        setreadonly(mt, false)
        local originalVelIndex = rawget(mt, "__index")
        mt.__index = newcclosure(function(self, key)
            if not checkcaller() and _velChecked[self]
               and (key == "AssemblyLinearVelocity" or key == "Velocity") then
                local real
                if type(originalVelIndex) == "function" then
                    real = originalVelIndex(self, key)
                elseif type(originalVelIndex) == "table" then
                    real = originalVelIndex[key]
                end
                if real and real.Magnitude > 20 then return real.Unit * 20 end
                return real
            end
            if type(originalVelIndex) == "function" then
                return originalVelIndex(self, key)
            elseif type(originalVelIndex) == "table" then
                return originalVelIndex[key]
            end
        end)
        setreadonly(mt, true)
    end)
    if not ok then _hookVelSupported = false end
end

if LP.Character then
    local _hrp0 = _setupVelChecked(LP.Character)
    _hookVelHRP(_hrp0)
end

local function _isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand
        or st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown
end

local function _applyVelocitySpeed(dir, speed, hrp)
    if not hrp or not hrp.Parent then return end
    if autoBatV2Enabled or autoBatEnabled then return end
    if dir and dir.Magnitude > 0.05 then
        pcall(function()
            if hrp.SetNetworkOwner then hrp:SetNetworkOwner(LP) end
        end)
        local unit = dir.Unit
        local vy = hrp.AssemblyLinearVelocity.Y
        hrp.AssemblyLinearVelocity = _V3new(unit.X * speed, vy, unit.Z * speed)
    else
        local vy = hrp.AssemblyLinearVelocity.Y
        hrp.AssemblyLinearVelocity = _V3new(0, vy, 0)
    end
end

function getAutoPathSpeed()
    if laggerCarryToggled or laggerToggled then return LAGGER_SPEED end
    return NS
end

ANIM_PACKS = {
    ["Zombie"] = { idle1="rbxassetid://616158929", idle2="rbxassetid://616160636", walk="rbxassetid://616168032", run="rbxassetid://616163682", jump="rbxassetid://616161997", fall="rbxassetid://616157476", climb="rbxassetid://616156119", swim="rbxassetid://616165109", swimidle="rbxassetid://616166655" },
    ["Ninja"] = { idle1="rbxassetid://656117400", idle2="rbxassetid://656117400", walk="rbxassetid://656121766", run="rbxassetid://656118852", jump="rbxassetid://656117878", fall="rbxassetid://656115606", climb="rbxassetid://656114359", swim="rbxassetid://656117400", swimidle="rbxassetid://656117400" },
    ["Knight"] = { idle1="rbxassetid://657595757", idle2="rbxassetid://657595757", walk="rbxassetid://657552124", run="rbxassetid://657564596", jump="rbxassetid://658409194", fall="rbxassetid://657600338", climb="rbxassetid://658360781", swim="rbxassetid://657595757", swimidle="rbxassetid://657595757" },
    ["Elder"] = { idle1="rbxassetid://845397899", idle2="rbxassetid://845397899", walk="rbxassetid://845403856", run="rbxassetid://845386501", jump="rbxassetid://845398858", fall="rbxassetid://845397673", climb="rbxassetid://845392038", swim="rbxassetid://845397899", swimidle="rbxassetid://845397899" },
    ["Levitate"] = { idle1="rbxassetid://616006778", idle2="rbxassetid://616006778", walk="rbxassetid://616013216", run="rbxassetid://616013216", jump="rbxassetid://616008936", fall="rbxassetid://616005863", climb="rbxassetid://616003713", swim="rbxassetid://616006778", swimidle="rbxassetid://616006778" },
    ["Astronaut"] = { idle1="rbxassetid://891621366", idle2="rbxassetid://891621366", walk="rbxassetid://891636393", run="rbxassetid://891636393", jump="rbxassetid://891627522", fall="rbxassetid://891617961", climb="rbxassetid://891609353", swim="rbxassetid://891621366", swimidle="rbxassetid://891621366" },
    ["Pirate"] = { idle1="rbxassetid://750781874", idle2="rbxassetid://750781874", walk="rbxassetid://750785693", run="rbxassetid://750783738", jump="rbxassetid://750782230", fall="rbxassetid://750780242", climb="rbxassetid://750779899", swim="rbxassetid://750781874", swimidle="rbxassetid://750781874" },
    ["Toy"] = { idle1="rbxassetid://782841498", idle2="rbxassetid://782841498", walk="rbxassetid://782843345", run="rbxassetid://782842708", jump="rbxassetid://782847020", fall="rbxassetid://782846423", climb="rbxassetid://782843869", swim="rbxassetid://782841498", swimidle="rbxassetid://782841498" },
    ["Vampire"] = { idle1="rbxassetid://1083445855", idle2="rbxassetid://1083445855", walk="rbxassetid://1083473930", run="rbxassetid://1083462077", jump="rbxassetid://1083455352", fall="rbxassetid://1083443587", climb="rbxassetid://1083439238", swim="rbxassetid://1083445855", swimidle="rbxassetid://1083445855" },
    ["Werewolf"] = { idle1="rbxassetid://1083195517", idle2="rbxassetid://1083195517", walk="rbxassetid://1083178339", run="rbxassetid://1083216690", jump="rbxassetid://1083218792", fall="rbxassetid://1083189019", climb="rbxassetid://1083182000", swim="rbxassetid://1083195517", swimidle="rbxassetid://1083195517" },
    ["Rthro"] = { idle1="rbxassetid://2510196951", idle2="rbxassetid://2510196951", walk="rbxassetid://2510202577", run="rbxassetid://2510198475", jump="rbxassetid://2510197830", fall="rbxassetid://2510195892", climb="rbxassetid://2510192778", swim="rbxassetid://2510196951", swimidle="rbxassetid://2510196951" },
    ["Stylish"] = { idle1="rbxassetid://616136790", idle2="rbxassetid://616136790", walk="rbxassetid://616146177", run="rbxassetid://616140816", jump="rbxassetid://616139451", fall="rbxassetid://616134815", climb="rbxassetid://616133594", swim="rbxassetid://616136790", swimidle="rbxassetid://616136790" },
}

ANIM_PACK_ORDER = {{"Off", "Off"}, {"Zombie", "Zombie"}, {"Ninja", "Ninja"}, {"Knight", "Knight"}, {"Elder", "Elder"}, {"Levitate", "Levitate"}, {"Astronaut", "Astronaut"}, {"Pirate", "Pirate"}, {"Toy", "Toy"}, {"Vampire", "Vampire"}, {"Werewolf", "Werewolf"}, {"Rthro", "Rthro"}, {"Stylish", "Stylish"}}

local function isPackAnim(id)
    for _, pack in pairs(ANIM_PACKS) do
        for _, v in pairs(pack) do
            if v == id then return true end
        end
    end
    return false
end

local function saveOriginalAnims(char)
    local animate = char:FindFirstChild("Animate")
    if not animate then return end
    local function g(obj) return obj and obj.AnimationId or nil end
    local ids = {
        idle1 = g(animate.idle and animate.idle.Animation1),
        idle2 = g(animate.idle and animate.idle.Animation2),
        walk  = g(animate.walk and animate.walk.WalkAnim),
        run   = g(animate.run  and animate.run.RunAnim),
        jump  = g(animate.jump and animate.jump.JumpAnim),
        fall  = g(animate.fall and animate.fall.FallAnim),
        climb = g(animate.climb and animate.climb.ClimbAnim),
        swim  = g(animate.swim and animate.swim.Swim),
        swimidle = g(animate.swimidle and animate.swimidle.SwimIdle),
    }
    if not isPackAnim(ids.walk) then originalTryardAnims = ids end
end

local function applyAnimPack(packName)
    currentAnimPack = packName
    if animSelectorLabel then animSelectorLabel.Text = packName end
    if packName == "Off" then
        if originalTryardAnims and LP.Character then
            local animate = LP.Character:FindFirstChild("Animate")
            if animate then
                local function s(obj,id) if obj then obj.AnimationId = id end end
                s(animate.idle and animate.idle.Animation1, originalTryardAnims.idle1)
                s(animate.idle and animate.idle.Animation2, originalTryardAnims.idle2)
                s(animate.walk and animate.walk.WalkAnim, originalTryardAnims.walk)
                s(animate.run  and animate.run.RunAnim,   originalTryardAnims.run)
                s(animate.jump and animate.jump.JumpAnim, originalTryardAnims.jump)
                s(animate.fall and animate.fall.FallAnim, originalTryardAnims.fall)
                s(animate.climb and animate.climb.ClimbAnim, originalTryardAnims.climb)
                s(animate.swim and animate.swim.Swim, originalTryardAnims.swim)
                s(animate.swimidle and animate.swimidle.SwimIdle, originalTryardAnims.swimidle)
            end
        end
        if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect(); tryardHeartbeatConn = nil end
        return
    end
    local pack = ANIM_PACKS[packName]
    if not pack then return end
    if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect() end
    tryardHeartbeatConn = RunService.Heartbeat:Connect(function()
        local c = LP.Character
        if not c then return end
        local animate = c:FindFirstChild("Animate")
        if not animate then return end
        local function s(obj,id) if obj then obj.AnimationId = id end end
        s(animate.idle and animate.idle.Animation1, pack.idle1)
        s(animate.idle and animate.idle.Animation2, pack.idle2)
        s(animate.walk and animate.walk.WalkAnim, pack.walk)
        s(animate.run  and animate.run.RunAnim,   pack.run)
        s(animate.jump and animate.jump.JumpAnim, pack.jump)
        s(animate.fall and animate.fall.FallAnim, pack.fall)
        s(animate.climb and animate.climb.ClimbAnim, pack.climb)
        s(animate.swim and animate.swim.Swim, pack.swim)
        s(animate.swimidle and animate.swimidle.SwimIdle, pack.swimidle)
    end)
end

local function startAnimPack(packName)
    local char = LP.Character
    if char then
        saveOriginalAnims(char)
        applyAnimPack(packName)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, track in ipairs(hum:GetPlayingAnimationTracks()) do track:Stop(0) end
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    else
        applyAnimPack(packName)
    end
    currentAnimPack = packName
end

local function stopAnimPack()
    currentAnimPack = "Off"
    if animSelectorLabel then animSelectorLabel.Text = "Off" end
    applyAnimPack("Off")
end

DEFAULT_KB = {
    DropBrainrot = {kb = Enum.KeyCode.X, gp = nil},
    AutoLeft     = {kb = Enum.KeyCode.Z, gp = nil},
    AutoRight    = {kb = Enum.KeyCode.C, gp = nil},
    AutoBat      = {kb = Enum.KeyCode.E, gp = nil},
    TPFloor      = {kb = Enum.KeyCode.F, gp = nil},
    GuiHide      = {kb = Enum.KeyCode.LeftControl, gp = nil},
    CarryToggle  = {kb = Enum.KeyCode.Q, gp = nil},
    AutoCarry    = {kb = Enum.KeyCode.G, gp = nil},
    LaggerMode   = {kb = Enum.KeyCode.R, gp = nil},
    BatV2        = {kb = Enum.KeyCode.N, gp = nil},
    BatBypass    = {kb = Enum.KeyCode.B, gp = nil},
}

KB = {
    DropBrainrot = {kb = DEFAULT_KB.DropBrainrot.kb, gp = DEFAULT_KB.DropBrainrot.gp},
    AutoLeft     = {kb = DEFAULT_KB.AutoLeft.kb, gp = DEFAULT_KB.AutoLeft.gp},
    AutoRight    = {kb = DEFAULT_KB.AutoRight.kb, gp = DEFAULT_KB.AutoRight.gp},
    AutoBat      = {kb = DEFAULT_KB.AutoBat.kb, gp = DEFAULT_KB.AutoBat.gp},
    TPFloor      = {kb = DEFAULT_KB.TPFloor.kb, gp = DEFAULT_KB.TPFloor.gp},
    GuiHide      = {kb = DEFAULT_KB.GuiHide.kb, gp = DEFAULT_KB.GuiHide.gp},
    CarryToggle  = {kb = DEFAULT_KB.CarryToggle.kb, gp = DEFAULT_KB.CarryToggle.gp},
    AutoCarry    = {kb = DEFAULT_KB.AutoCarry.kb, gp = DEFAULT_KB.AutoCarry.gp},
    LaggerMode   = {kb = DEFAULT_KB.LaggerMode.kb, gp = DEFAULT_KB.LaggerMode.gp},
    BatV2        = {kb = DEFAULT_KB.BatV2.kb, gp = DEFAULT_KB.BatV2.gp},
    BatBypass    = {kb = DEFAULT_KB.BatBypass.kb, gp = DEFAULT_KB.BatBypass.gp},
}

_isResetting = false
_lastSavedJSON = nil
_isLoading = false

CONFIG = {
    AUTO_STEAL_ENABLED = false,
    STEAL_RANGE = 61,
}

-- Optional game-specific folder: do not block the entire script in games without Plots.
local plots = workspace:FindFirstChild("Plots")
local stealConnection = nil

local Steal = {
    AutoStealEnabled = false,
    StealRadius = CONFIG.STEAL_RANGE,
    StealDuration = 1.3,
    StealDelay = 0.25,
    Data = {}
}

local isStealing = false
local autoGrabSetDelayRadius = 9
local autoGrabStopTime = 0.96
local autoGrabStopEnabled = true

local _plotsCache = nil
local _plotsCacheTime = 0
local function getPlotsRoot()
    local now = _tick()
    if _plotsCache and now - _plotsCacheTime < 2 and _plotsCache.Parent then
        return _plotsCache
    end
    _plotsCache = workspace:FindFirstChild("Plots")
    _plotsCacheTime = now
    return _plotsCache
end

local function isMyPlotByName(plotName)
    local plotsRoot = getPlotsRoot()
    if not plotsRoot then return false end
    local plot = plotsRoot:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then
            return yb.Enabled == true
        end
    end
    return false
end

local function findNearestPrompt()
    local char = LP.Character
    if not char then return nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil end
    local plotsRoot = getPlotsRoot()
    if not plotsRoot then return nil, nil end
    local nearestPrompt, nearestDist, nearestName = nil, _huge, nil
    local rpos = root.Position
    for _, plot in ipairs(plotsRoot:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then continue end
        for _, pod in ipairs(pods:GetChildren()) do
            pcall(function()
                local base = pod:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                if spawn then
                    local sp = spawn.Position
                    local dx = sp.X - rpos.X
                    local dy = sp.Y - rpos.Y
                    local dz = sp.Z - rpos.Z
                    local dist = _sqrt(dx*dx + dy*dy + dz*dz)
                    if dist < nearestDist and dist <= Steal.StealRadius then
                        local att = spawn:FindFirstChild("PromptAttachment")
                        if att then
                            for _, child in ipairs(att:GetChildren()) do
                                if child:IsA("ProximityPrompt") and child.ActionText and child.ActionText:find("Steal") then
                                    nearestPrompt = child
                                    nearestDist = dist
                                    nearestName = pod.Name
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
    return nearestPrompt, nearestName
end

local function executeSteal(prompt, podName)
    if isStealing then return end

    if math.random(30) == 1 then
        for p in pairs(Steal.Data) do
            if not p.Parent then Steal.Data[p] = nil end
        end
    end

    if not Steal.Data[prompt] then
        Steal.Data[prompt] = { hold = {}, trigger = {}, ready = true }
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(Steal.Data[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(Steal.Data[prompt].trigger, c.Function) end
                end
            end
        end)
    end

    local data = Steal.Data[prompt]
    if not data.ready then return end
    data.ready = false
    isStealing = true

    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
    if progressPct then progressPct.Text = "0%" end

    task.spawn(function()
        for _, f in ipairs(data.hold) do task.spawn(f) end

        local startTime = _tick()
        local duration = Steal.StealDuration
        local promptFired = false

        if autoGrabStopEnabled then
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = _tick() - startTime
                if elapsed >= autoGrabStopTime then break end
                local progress = _clamp(elapsed / duration, 0, 1)
                if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
                if progressPct then progressPct.Text = _floor(progress * 100) .. "%" end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then
                    break
                end
                task.wait()
            end

            local stopProgress = _clamp(autoGrabStopTime / duration, 0, 1)
            if progressFill then progressFill.Size = UDim2.new(stopProgress, 0, 1, 0) end
            if progressPct then progressPct.Text = _floor(stopProgress * 100) .. "%" end

            local phase2Timeout = math.max(2.99 - autoGrabStopTime - math.max(duration - autoGrabStopTime, 0), 0.05)
            local phase2Start = _tick()

            while isStealing and Steal.AutoStealEnabled do
                if _tick() - phase2Start >= phase2Timeout then
                    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                    if progressPct then progressPct.Text = "0%" end
                    data.ready = true
                    isStealing = false
                    task.wait()
                    local newPrompt, newName = findNearestPrompt()
                    if newPrompt then executeSteal(newPrompt, newName) end
                    return
                end
                if not prompt.Parent or not prompt.Parent.Parent then
                    isStealing = false
                    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                    if progressPct then progressPct.Text = "0%" end
                    data.ready = true
                    return
                end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - prompt.Parent.Parent.Position).Magnitude
                    if dist <= autoGrabSetDelayRadius then
                        break
                    elseif dist > Steal.StealRadius then
                        isStealing = false
                        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                        if progressPct then progressPct.Text = "0%" end
                        data.ready = true
                        return
                    end
                end
                task.wait()
            end

            if isStealing and Steal.AutoStealEnabled then
                local fillStart = _tick()
                local fillDuration = math.max(duration - autoGrabStopTime, 0.05)
                while true do
                    local fp = _clamp((_tick() - fillStart) / fillDuration, 0, 1)
                    local totalProgress = stopProgress + fp * (1 - stopProgress)
                    if progressFill then progressFill.Size = UDim2.new(totalProgress, 0, 1, 0) end
                    if progressPct then progressPct.Text = _floor(totalProgress * 100) .. "%" end
                    if fp >= 1 and not promptFired then
                        promptFired = true
                        pcall(function()
                            for _, f in ipairs(data.trigger) do task.spawn(f) end
                            local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                            if remote and podName then remote:FireServer(podName) end
                            if prompt then prompt:Fire() end
                        end)
                        break
                    end
                    task.wait()
                end
            end
        else
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = _tick() - startTime
                local progress = _clamp(elapsed / duration, 0, 1)
                if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
                if progressPct then progressPct.Text = _floor(progress * 100) .. "%" end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then break end
                if elapsed >= duration and not promptFired then
                    promptFired = true
                    pcall(function()
                        for _, f in ipairs(data.trigger) do task.spawn(f) end
                        local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                        if remote and podName then remote:FireServer(podName) end
                        if prompt then prompt:Fire() end
                    end)
                    break
                end
                task.wait()
            end
        end

        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
        if progressPct then progressPct.Text = "0%" end
        data.ready = true
        isStealing = false
    end)
end

function startAutoSteal()
    if stealConnection then
        local connected = false
        pcall(function() connected = stealConnection.Connected == true end)
        if connected then
            Steal.StealRadius = CONFIG.STEAL_RANGE
            Steal.AutoStealEnabled = true
            CONFIG.AUTO_STEAL_ENABLED = true
            return true
        end
        pcall(function() stealConnection:Disconnect() end)
        stealConnection = nil
    end
    Steal.StealRadius = CONFIG.STEAL_RANGE
    Steal.AutoStealEnabled = true
    CONFIG.AUTO_STEAL_ENABLED = true
    stealConnection = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        local p, n = findNearestPrompt()
        if p then executeSteal(p, n) end
    end)
    return true
end

function stopAutoSteal()
    if stealConnection then
        stealConnection:Disconnect()
        stealConnection = nil
    end
    isStealing = false
    Steal.AutoStealEnabled = false
    CONFIG.AUTO_STEAL_ENABLED = false
    if progressFill then
        TS:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
    end
    if progressPct then progressPct.Text = "0%" end
end

medusaDebounce = false
medusaLastUsed = 0
dropActive = false
lastDropTime = 0
lastMoveDir = _V3new(0,0,0)
origFOV = nil
fovEnabled = false
fovValue = 70
customFovConn = nil
setFovVisual = nil
fovSliderSet = nil

_anyKeyListening = false
_aimbotConn = nil
_prevAutoRotate = nil
batV2FloatingButton = nil

enemySpeedConn = nil
movementLoop = nil
steppedConn = nil
alConn = nil
arConn = nil
infJumpConn = nil
stretchConn = nil
stretchFovConn = nil
antiLagDescConn = nil
medusaResetConns = {}
dropConnections = {}
enemySpeedLabels = {}
Conns = {autoSteal = nil, batCounter = nil, anchor = {}, progress = nil, autoLeft = nil, autoRight = nil}
keyButtonRefs = {}
progressFill = nil
progressPct = nil
progressRadLbl = nil
pbFpsLbl = nil
pbRadiusLbl = nil
pbPingLbl = nil
pbFrame = nil
speedLabel = nil
modeValLbl = nil
normalBox, carryBox, laggerBox, lagger2Box, radInput, batSpeedBox, uiScaleBox = nil, nil, nil, nil, nil, nil, nil
modeSelectBtn, dropModeBtnRef = nil, nil
setJumpToggleState = nil
autoBatSetVisual, batBypassSetVisual, autoLeftSetVisual, autoRightSetVisual, setBatCounterVisual, setMedusaVisual = nil, nil, nil, nil, nil, nil
setAntiRagVisual, setJumpVisual, setUnwalkVisual, setAntiLagVisual, setLockUIVisual, setInstaGrab = nil, nil, nil, nil, nil, nil
setAntiDieVisual = nil
setEditModeVisual = nil
setESPVIsual = nil
mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight, mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2, mobSetBatBypass = nil, nil, nil, nil, nil, nil, nil, nil, nil
autoBatV2SetVisual = nil
miniBtn, main, gui = nil, nil, nil
MobilePanel = nil
showGui = nil
hideGui = nil
mainUIScale = nil
animSelectorLabel = nil
pbScale = nil
tabButtons = nil
colorSelectorLabel = nil

carrySystemToggleSetter = nil
carrySysNormalBox = nil
carrySysCarryBox = nil
carrySysLaggerBox = nil
carrySysLaggerCarryBox = nil
carrySysSoftStealSpeedBox = nil
carrySysSoftStealRadiusBox = nil

GAMEPAD_KEYS = {
    [Enum.KeyCode.ButtonA] = true, [Enum.KeyCode.ButtonB] = true,
    [Enum.KeyCode.ButtonX] = true, [Enum.KeyCode.ButtonY] = true,
    [Enum.KeyCode.ButtonL1] = true, [Enum.KeyCode.ButtonR1] = true,
    [Enum.KeyCode.ButtonL2] = true, [Enum.KeyCode.ButtonR2] = true,
    [Enum.KeyCode.ButtonL3] = true, [Enum.KeyCode.ButtonR3] = true,
    [Enum.KeyCode.ButtonStart] = true, [Enum.KeyCode.ButtonSelect] = true,
    [Enum.KeyCode.DPadUp] = true, [Enum.KeyCode.DPadDown] = true,
    [Enum.KeyCode.DPadLeft] = true, [Enum.KeyCode.DPadRight] = true,
}

MOVE_KEYS = {
    [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true,
    [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true,
}

BAT_COUNTER_SLAP_LIST = {
    "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap",
    "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap",
    "Nuclear Slap", "Galaxy Slap", "Glitched Slap"
}

AP = {
    L1 = _V3new(-476.48, -6.28, 92.73),
    L2 = _V3new(-483.12, -4.95, 94.80),
    L_FACE = _V3new(-482.25, -4.96, 92.09),
    R1 = _V3new(-476.16, -6.52, 25.62),
    R2 = _V3new(-483.06, -5.03, 25.48),
    R_FACE = _V3new(-482.06, -6.93, 35.47),
}

function isGamepadInput(inp)
    return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil
end

function isBindableInput(inp)
    if not inp or inp.KeyCode == Enum.KeyCode.Unknown then return false end
    if inp.UserInputType == Enum.UserInputType.Keyboard then return true end
    return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode] == true
end

function kbMatch(entry, kc)
    return kc and (kc == entry.kb or (entry.gp and kc == entry.gp))
end

function resetProgressBar()
    if progressPct then progressPct.Text = "0%" end
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
end

local function doTpDown()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        root.CFrame = _CFnew(root.Position.X, -7, root.Position.Z) * CFrame.Angles(0, select(2, root.CFrame:ToEulerAnglesYXZ()), 0)
        root.Velocity = _V3zero
    end)
end

local AntiRagdollV1 = {}
AntiRagdollV1.__index = AntiRagdollV1

local BOOST_SPEED = 400
local AR_DEFAULT_SPEED = 16

local stateV1 = {
    active = false,
    isBoosting = false,
    cachedChar = nil,
    ragdollConnections = {},
}

local function disconnectAllV1()
    for _, conn in ipairs(stateV1.ragdollConnections) do
        pcall(function() conn:Disconnect() end)
    end
    stateV1.ragdollConnections = {}
end

local function cacheCharacterV1()
    local char = LP.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end
    stateV1.cachedChar = { character = char, humanoid = hum, root = root }
    return true
end

local function isRagdolledV1()
    if not stateV1.cachedChar or not stateV1.cachedChar.humanoid then return false end
    local hum = stateV1.cachedChar.humanoid
    local st = hum:GetState()
    local ragdollStates = {
        [Enum.HumanoidStateType.Physics] = true,
        [Enum.HumanoidStateType.Ragdoll] = true,
        [Enum.HumanoidStateType.FallingDown] = true,
    }
    return ragdollStates[st] or false
end

local function forceExitRagdollV1()
    if not stateV1.cachedChar or not stateV1.cachedChar.humanoid or not stateV1.cachedChar.root then return end
    local hum = stateV1.cachedChar.humanoid
    local root = stateV1.cachedChar.root
    pcall(function()
        LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
    end)
    for _, descendant in ipairs(stateV1.cachedChar.character:GetDescendants()) do
        if descendant:IsA("BallSocketConstraint") or
           (descendant:IsA("Attachment") and descendant.Name:find("RagdollAttachment")) then
            descendant:Destroy()
        end
    end
    if not stateV1.isBoosting then
        stateV1.isBoosting = true
        hum.WalkSpeed = BOOST_SPEED
    end
    if hum.Health > 0 then
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
    root.Anchored = false
end

local function heartbeatLoopV1()
    while stateV1.active do
        task.wait()
        if isRagdolledV1() then
            forceExitRagdollV1()
        elseif stateV1.isBoosting and not isRagdolledV1() then
            stateV1.isBoosting = false
            if stateV1.cachedChar and stateV1.cachedChar.humanoid then
                stateV1.cachedChar.humanoid.WalkSpeed = AR_DEFAULT_SPEED
            end
        end
    end
end

function AntiRagdollV1.start()
    if stateV1.active then return end
    AntiRagdollV1.stop()
    if not cacheCharacterV1() then
        warn("[AntiRagdollV1] No se pudo cachear el personaje")
        return
    end
    stateV1.active = true
    stateV1.isBoosting = false
    local camConn = RunService.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        if cam and stateV1.cachedChar and stateV1.cachedChar.humanoid then
            cam.CameraSubject = stateV1.cachedChar.humanoid
        end
    end)
    table.insert(stateV1.ragdollConnections, camConn)
    local respawnConn = LP.CharacterAdded:Connect(function()
        stateV1.isBoosting = false
        task.wait(0.5)
        cacheCharacterV1()
    end)
    table.insert(stateV1.ragdollConnections, respawnConn)
    task.spawn(heartbeatLoopV1)
    print("[AntiRagdollV1] Activado")
end

function AntiRagdollV1.stop()
    stateV1.active = false
    if stateV1.isBoosting and stateV1.cachedChar and stateV1.cachedChar.humanoid then
        stateV1.cachedChar.humanoid.WalkSpeed = AR_DEFAULT_SPEED
    end
    stateV1.isBoosting = false
    disconnectAllV1()
    stateV1.cachedChar = nil
    print("[AntiRagdollV1] Desactivado")
end

function AntiRagdollV1.isRunning() return stateV1.active end

local AntiRagdollV2 = {
    Enabled = false,
    Connection = nil,
    ResetCooldown = 0,
}

local function startAntiRagdollV2()
    if AntiRagdollV2.Connection then return end
    AntiRagdollV2.Enabled = true
    AntiRagdollV2.Connection = RunService.Heartbeat:Connect(function()
        if not AntiRagdollV2.Enabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end
        local state = hum:GetState()
        local now = _tick()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown then
            if now - AntiRagdollV2.ResetCooldown > 0.15 then
                AntiRagdollV2.ResetCooldown = now
                pcall(function()
                    if hum:GetState() == Enum.HumanoidStateType.GettingUp then return end
                    if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    root.Velocity = _V3zero
                    root.RotVelocity = _V3zero
                    root.AssemblyLinearVelocity = _V3zero
                    root.AssemblyAngularVelocity = _V3zero
                    for _, obj in ipairs(char:GetDescendants()) do
                        if obj:IsA("Motor6D") then obj.Enabled = true end
                        if obj:IsA("Constraint") then obj.Enabled = true end
                    end
                    workspace.CurrentCamera.CameraSubject = hum
                    local PM = LP.PlayerScripts:FindFirstChild("PlayerModule")
                    if PM then
                        local CM = require(PM:FindFirstChild("ControlModule"))
                        if CM then CM:Enable() end
                    end
                    hum.AutoRotate = true
                    hum.PlatformStand = false
                    hum.Sit = false
                end)
            end
        end
    end)
end

local function stopAntiRagdollV2()
    AntiRagdollV2.Enabled = false
    if AntiRagdollV2.Connection then
        AntiRagdollV2.Connection:Disconnect()
        AntiRagdollV2.Connection = nil
    end
    AntiRagdollV2.ResetCooldown = 0
end

function setAntiRagdollMode(mode)
    if AntiRagdollV1.isRunning() then AntiRagdollV1.stop() end
    if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
    antiRagdollMode = mode
    if mode == "v1" then AntiRagdollV1.start()
    elseif mode == "v2" then startAntiRagdollV2() end
    if _G.updateAntiRagdollUI then _G.updateAntiRagdollUI(mode) end
    saveAllSettings()
end

local AntiDieModule = {
    enabled = false,
    healthConn = nil,
    diedConn = nil,
    charConn = nil,
    humanoid = nil,
    _reviving = false,
}

local function disconnectHumanoid()
    if AntiDieModule.healthConn then AntiDieModule.healthConn:Disconnect(); AntiDieModule.healthConn = nil end
    if AntiDieModule.diedConn then AntiDieModule.diedConn:Disconnect(); AntiDieModule.diedConn = nil end
    AntiDieModule.humanoid = nil
end

local function activateOnCharacter(char)
    if not AntiDieModule.enabled then return end
    char = char or LP.Character or LP.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 3)
    if not hum or not AntiDieModule.enabled then return end
    disconnectHumanoid()
    AntiDieModule.humanoid = hum

    pcall(function()
        hum.BreakJointsOnDeath = false
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Dying, false)
    end)

    AntiDieModule.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not AntiDieModule.enabled or not hum.Parent then return end
        if hum.Health <= 0 and not AntiDieModule._reviving then
            AntiDieModule._reviving = true
            pcall(function()
                hum.Health = hum.MaxHealth
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                if hum.Health > 0 then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
            task.delay(0.2, function() AntiDieModule._reviving = false end)
        end
    end)

    AntiDieModule.diedConn = hum.Died:Connect(function()
        if not AntiDieModule.enabled or not char.Parent then return end
        if AntiDieModule._reviving then return end
        AntiDieModule._reviving = true
        task.defer(function()
            if not AntiDieModule.enabled or not char.Parent or not hum.Parent then
                AntiDieModule._reviving = false
                return
            end
            pcall(function()
                hum.Health = hum.MaxHealth
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
            AntiDieModule._reviving = false
        end)
    end)
end

function AntiDieModule.start()
    AntiDieModule.enabled = true
    if AntiDieModule.charConn then AntiDieModule.charConn:Disconnect() end
    AntiDieModule.charConn = LP.CharacterAdded:Connect(function(char)
        if AntiDieModule.enabled then task.defer(function() activateOnCharacter(char) end) end
    end)
    task.defer(function() activateOnCharacter(LP.Character) end)
    print("[AntiDie] Activado (interno)")
end

function AntiDieModule.stop()
    AntiDieModule.enabled = false
    if AntiDieModule.charConn then AntiDieModule.charConn:Disconnect(); AntiDieModule.charConn = nil end
    local hum = AntiDieModule.humanoid
    disconnectHumanoid()
    if hum and hum.Parent then
        pcall(function()
            hum.BreakJointsOnDeath = true
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end)
    end
    print("[AntiDie] Desactivado (interno)")
end

_G.AntiDie = AntiDieModule

local AntiFlingShieldModule = {
    enabled = false,
    loop = nil,
    velocityThreshold = 80,
}

local function stabilizeRoot(root)
    if not root or not root.Parent then return end
    local velocity
    local ok = pcall(function() velocity = root.AssemblyLinearVelocity end)
    if not ok or typeof(velocity) ~= "Vector3" then
        local legacyOk
        legacyOk, velocity = pcall(function() return root.Velocity end)
        if not legacyOk or typeof(velocity) ~= "Vector3" then return end
    end
    if velocity.Magnitude <= AntiFlingShieldModule.velocityThreshold then return end
    local stabilized = _V3new(0, velocity.Y, 0)
    pcall(function() root.AssemblyLinearVelocity = stabilized end)
    pcall(function() root.AssemblyAngularVelocity = _V3zero end)
    pcall(function() root.Velocity = stabilized end)
    pcall(function() root.RotVelocity = _V3zero end)
end

function AntiFlingShieldModule.start()
    AntiFlingShieldModule.enabled = true
    if AntiFlingShieldModule.loop then AntiFlingShieldModule.loop:Disconnect() end
    AntiFlingShieldModule.loop = RunService.Heartbeat:Connect(function()
        if not AntiFlingShieldModule.enabled then return end
        local char = LP.Character
        stabilizeRoot(char and char:FindFirstChild("HumanoidRootPart"))
    end)
    print("[AntiFlingShield] Activado (interno)")
end

function AntiFlingShieldModule.stop()
    AntiFlingShieldModule.enabled = false
    if AntiFlingShieldModule.loop then
        AntiFlingShieldModule.loop:Disconnect()
        AntiFlingShieldModule.loop = nil
    end
    print("[AntiFlingShield] Desactivado (interno)")
end

_G.AntiFlingShield = AntiFlingShieldModule

do
    local _ragCountdownRunning = false
    local function _getRagBillboard()
        local char = LP.Character
        if not char then return nil, nil end
        local head = char:FindFirstChild("Head")
        if not head then return nil, nil end
        local pGui = LP.PlayerGui
        local existing = pGui:FindFirstChild("RagCountdownBillboard")
        if existing then existing:Destroy() end
        local bb = Instance.new("BillboardGui")
        bb.Name = "RagCountdownBillboard"
        bb.Size = UDim2.new(0, 84, 0, 42)
        bb.StudsOffset = _V3new(0, 4.5, 0)
        bb.AlwaysOnTop = true
        bb.Adornee = head
        bb.Parent = pGui
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.AnchorPoint = Vector2.new(0.5, 0.5)
        lbl.Position = UDim2.new(0.5, 0, 0.5, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextScaled = true
        lbl.TextColor3 = selectedColor
        lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        lbl.TextStrokeTransparency = 0
        lbl.Text = ""
        lbl.Parent = bb
        local grad = Instance.new("UIGradient", lbl)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, selectedColor),
            ColorSequenceKeypoint.new(0.3, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.7, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, selectedColor),
        })
        grad.Rotation = 45
        grad.Offset = Vector2.new(0,0)
        return bb, lbl
    end

    local function _ragPunch(lbl, text)
        if not (lbl and lbl.Parent) then return end
        lbl.Text = text
    end

    local function _startRagCountdown()
        if _ragCountdownRunning then return end
        _ragCountdownRunning = true
        task.spawn(function()
            local bb, lbl = _getRagBillboard()
            if not bb then _ragCountdownRunning = false; return end
            local timeLeft = 2.5
            local step = 0.1
            while timeLeft > 0 and bb.Parent do
                _ragPunch(lbl, string.format("%.1f", timeLeft))
                task.wait(step)
                timeLeft = timeLeft - step
            end
            if bb and bb.Parent then
                _ragPunch(lbl, "READY!")
                task.wait(0.5)
                if bb and bb.Parent then bb:Destroy() end
            end
            _ragCountdownRunning = false
        end)
    end

    local _wasRagdolled = false
    RunService.Heartbeat:Connect(function()
        local char = LP.Character
        if not char then _wasRagdolled = false; return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then _wasRagdolled = false; return end
        local st = hum:GetState()
        local inRag = st == Enum.HumanoidStateType.Physics
                   or st == Enum.HumanoidStateType.Ragdoll
                   or st == Enum.HumanoidStateType.FallingDown
        if inRag and not _wasRagdolled then
            _wasRagdolled = true
            _startRagCountdown()
        elseif not inRag then
            _wasRagdolled = false
        end
    end)
end

local espHighlightCache = {}
local espBillboardCache = {}
local espTracerCache = {}
local espConn = nil
local _espLastRun = 0
profileImageCache = {}

local function clearESP()
    for plr in pairs(espHighlightCache) do
        pcall(function() espHighlightCache[plr]:Destroy() end)
    end
    for plr in pairs(espBillboardCache) do
        pcall(function() espBillboardCache[plr]:Destroy() end)
    end
    for plr in pairs(espTracerCache) do
        for _, ln in ipairs(espTracerCache[plr]) do
            pcall(function() ln.Visible = false; ln:Remove() end)
        end
    end
    espHighlightCache = {}
    espBillboardCache = {}
    espTracerCache = {}
end

local function makeESPTracers()
    if not (Drawing and type(Drawing.new) == "function") then return nil end
    local color = getThemeColor()
    local outer = Drawing.new("Line")
    outer.Color = color
    outer.Thickness = 2.2
    outer.Transparency = 0.90
    outer.Visible = false
    local mid = Drawing.new("Line")
    mid.Color = color
    mid.Thickness = 1.2
    mid.Transparency = 0.74
    mid.Visible = false
    local core = Drawing.new("Line")
    core.Color = color
    core.Thickness = 0.6
    core.Transparency = 0.10
    core.Visible = false
    return {outer, mid, core}
end

local function updateESP()
    local now = _tick()
    if now - _espLastRun < 0.05 then return end
    _espLastRun = now
    if not espEnabled then clearESP(); return end
    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local myPos = myRoot.Position
    local myScreenPos, myOnScreen = camera:WorldToViewportPoint(myPos)
    local myVec = Vector2.new(myScreenPos.X, myScreenPos.Y)
    local currentPlayers = _GetPlayersCached()
    local plrSet = {}
    for _, p in ipairs(currentPlayers) do plrSet[p] = true end
    for plr in pairs(espHighlightCache) do
        if not plrSet[plr] then
            pcall(function() espHighlightCache[plr]:Destroy() end)
            espHighlightCache[plr] = nil
        end
    end
    for plr in pairs(espBillboardCache) do
        if not plrSet[plr] then
            pcall(function() espBillboardCache[plr]:Destroy() end)
            espBillboardCache[plr] = nil
        end
    end
    for plr in pairs(espTracerCache) do
        if not plrSet[plr] then
            for _, ln in ipairs(espTracerCache[plr]) do
                pcall(function() ln.Visible = false; ln:Remove() end)
            end
            espTracerCache[plr] = nil
        end
    end
    local color = getThemeColor()
    for _, plr in ipairs(currentPlayers) do
        if plr == LP then continue end
        local char = plr.Character
        if not char then
            if espHighlightCache[plr] then
                pcall(function() espHighlightCache[plr]:Destroy() end)
                espHighlightCache[plr] = nil
            end
            if espBillboardCache[plr] then
                pcall(function() espBillboardCache[plr]:Destroy() end)
                espBillboardCache[plr] = nil
            end
            if espTracerCache[plr] then
                for _, ln in ipairs(espTracerCache[plr]) do
                    pcall(function() ln.Visible = false end)
                end
            end
            continue
        end
        local tRoot = char:FindFirstChild("HumanoidRootPart")
        local tHead = char:FindFirstChild("Head")
        local tHum = char:FindFirstChildOfClass("Humanoid")
        local alive = tRoot and tHead and tHum and tHum.Health > 0
        if alive then
            local hl = espHighlightCache[plr]
            if not hl or not hl.Parent or hl.Parent ~= char then
                if hl then pcall(function() hl:Destroy() end) end
                hl = Instance.new("Highlight")
                hl.Name = "BloodHoundsESP"
                hl.FillColor = color
                hl.FillTransparency = 0.72
                hl.OutlineColor = color
                hl.OutlineTransparency = 0.05
                hl.Adornee = char
                hl.Parent = char
                espHighlightCache[plr] = hl
            end
            local bb = espBillboardCache[plr]
            if not bb or not bb.Parent then
                if bb then pcall(function() bb:Destroy() end) end
                bb = Instance.new("BillboardGui")
                bb.Name = "ProfilePic"
                bb.Size = UDim2.new(0, 56, 0, 56)
                bb.StudsOffset = _V3new(0, 3.8, 0)
                bb.Adornee = tHead
                bb.AlwaysOnTop = true
                bb.Parent = tHead
                local img = Instance.new("ImageLabel", bb)
                img.Size = UDim2.new(1, -6, 1, -6)
                img.Position = UDim2.new(0, 3, 0, 3)
                img.BackgroundTransparency = 1
                img.Image = "rbxassetid://0"
                img.ScaleType = Enum.ScaleType.Fit
                local circle = Instance.new("UICorner", img)
                circle.CornerRadius = UDim.new(1, 0)
                local stroke = Instance.new("UIStroke", img)
                stroke.Color = color
                stroke.Thickness = 1.5
                espBillboardCache[plr] = bb
                task.spawn(function()
                    local userId = plr.UserId
                    local url = profileImageCache[userId]
                    if not url then
                        local success, u = pcall(function()
                            return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
                        end)
                        if success and u and u ~= "" then
                            url = u
                            profileImageCache[userId] = url
                        else
                            url = "rbxassetid://0"
                        end
                    end
                    if img then img.Image = url end
                end)
            else
                if bb.Adornee ~= tHead then bb.Adornee = tHead end
                bb.Enabled = true
            end
            local lines = espTracerCache[plr]
            if not lines then
                lines = makeESPTracers()
                espTracerCache[plr] = lines or {}
            end
            if lines and #lines > 0 then
                local destPos = tRoot.Position
                local pos, onScreen = camera:WorldToViewportPoint(destPos)
                if onScreen and pos.Z > 0 and myOnScreen then
                    local tVec = Vector2.new(pos.X, pos.Y)
                    for _, ln in ipairs(lines) do
                        ln.From = myVec
                        ln.To = tVec
                        ln.Visible = true
                    end
                else
                    for _, ln in ipairs(lines) do ln.Visible = false end
                end
            end
        else
            if espHighlightCache[plr] then
                pcall(function() espHighlightCache[plr]:Destroy() end)
                espHighlightCache[plr] = nil
            end
            if espBillboardCache[plr] then
                pcall(function() espBillboardCache[plr]:Destroy() end)
                espBillboardCache[plr] = nil
            end
            if espTracerCache[plr] then
                for _, ln in ipairs(espTracerCache[plr]) do
                    pcall(function() ln.Visible = false end)
                end
            end
        end
    end
end

local function startESPLoop()
    if espConn then espConn:Disconnect() end
    espConn = RunService.RenderStepped:Connect(updateESP)
end

local function stopESPLoop()
    if espConn then espConn:Disconnect(); espConn = nil end
    clearESP()
end

function toggleESP(on)
    espEnabled = on
    if on then startESPLoop() else stopESPLoop() end
    if setESPVIsual then setESPVIsual(on) end
end

local _enemySpeedAcc = 0
function updateEnemySpeedLabels()
    _enemySpeedAcc = _enemySpeedAcc + 1
    if _enemySpeedAcc < 6 then return end
    _enemySpeedAcc = 0

    local color = getThemeColor()
    local players = _GetPlayersCached()
    for i = 1, #players do
        local player = players[i]
        if player ~= LP then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local v = hrp.AssemblyLinearVelocity
                local speed = _sqrt(v.X*v.X + v.Z*v.Z)
                local label = enemySpeedLabels[player]
                if not label then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local bb = Instance.new("BillboardGui")
                        bb.Size = UDim2.new(0, 100, 0, 25)
                        bb.StudsOffset = _V3new(0, 5.5, 0)
                        bb.AlwaysOnTop = true
                        bb.Name = "EnemySpeedGui"
                        bb.Parent = head
                        local tl = Instance.new("TextLabel", bb)
                        tl.Size = UDim2.new(1, 0, 1, 0)
                        tl.BackgroundTransparency = 1
                        tl.TextColor3 = color
                        tl.Font = Enum.Font.GothamBold
                        tl.TextScaled = true
                        tl.TextStrokeTransparency = 0
                        tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        enemySpeedLabels[player] = tl
                        label = tl
                    end
                elseif label.Parent and label.Parent.Parent ~= char then
                    local head = char:FindFirstChild("Head")
                    if head then label.Parent.Parent = head end
                end
                if label then
                    label.Text = string.format("%.1f", speed)
                    if label.TextColor3 ~= color then label.TextColor3 = color end
                end
            else
                local label = enemySpeedLabels[player]
                if label and label.Parent and label.Parent.Parent then label.Parent.Parent = nil end
                enemySpeedLabels[player] = nil
            end
        end
    end
end

function startEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect() end
    enemySpeedConn = RunService.Heartbeat:Connect(updateEnemySpeedLabels)
end

function stopEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect(); enemySpeedConn = nil end
end

local function getClosestTargetBody()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local rpos = root.Position
    local closest, minDist = nil, _huge
    local plist = _GetPlayersCached()
    for i = 1, #plist do
        local plr = plist[i]
        if plr ~= LP then
            local c = plr.Character
            if c then
                local tRoot = c:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local dx = tRoot.Position.X - rpos.X
                        local dy = tRoot.Position.Y - rpos.Y
                        local dz = tRoot.Position.Z - rpos.Z
                        local d = dx*dx + dy*dy + dz*dz
                        if d < minDist then minDist = d; closest = tRoot end
                    end
                end
            end
        end
    end
    return closest
end

local function _bodyLockTick()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local target = getClosestTargetBody()
    if not target then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    local dist = (target.Position - root.Position).Magnitude
    if dist > bodyLockRange then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    if hum.AutoRotate then hum.AutoRotate = false end
    local targetVel = target.AssemblyLinearVelocity
    local speed3 = targetVel.Magnitude
    local predictTime = _clamp(speed3 / 80, 0.08, 0.35)
    local predictedPos = target.Position + targetVel * predictTime
    local targetHead = target.Parent and target.Parent:FindFirstChild("Head")
    local targetHeight = targetHead and targetHead.Position.Y or target.Position.Y
    local myHeight = root.Position.Y + (hum.HipHeight or 0)
    local heightDiff = targetHeight - myHeight
    local verticalCorrection = _clamp(heightDiff * 0.15, -1.5, 1.5)
    local flatTarget = _V3new(predictedPos.X, root.Position.Y + verticalCorrection, predictedPos.Z)
    local toPredict = flatTarget - root.Position
    if toPredict.Magnitude > 0.1 then
        local goalCF = _CFlookAt(root.Position, flatTarget)
        local diffCF = root.CFrame:Inverse() * goalCF
        local _, ry, _ = diffCF:ToEulerAnglesXYZ()
        ry = _clamp(ry, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(_V3new(0, ry * 42, 0))
    end
end

function startBodyLock()
    if _bodyLockConn then _bodyLockConn:Disconnect() end
    local acc = 0
    _bodyLockConn = RunService.Heartbeat:Connect(function(dt)
        if not bodyLockEnabled then return end
        if _blSuppressCount > 0 then return end
        acc = acc + dt
        if acc < 0.033 then return end
        acc = 0
        _bodyLockTick()
    end)
end

function stopBodyLock()
    if _bodyLockConn then
        _bodyLockConn:Disconnect()
        _bodyLockConn = nil
    end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyAngularVelocity = _V3zero
        root.AssemblyLinearVelocity = _V3new(root.AssemblyLinearVelocity.X, -0.1, root.AssemblyLinearVelocity.Z)
    end
    local hum2 = c and c:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate = true end
end

function _suppressBodyLock()
    _blSuppressCount = _blSuppressCount + 1
    if _blSuppressCount == 1 and bodyLockEnabled then
        _blWasEnabled = true
        stopBodyLock()
        if bodyLockSetVisual then bodyLockSetVisual(false) end
        if _blRestoreTimer then
            task.cancel(_blRestoreTimer)
            _blRestoreTimer = nil
        end
        _blSmoothRestore = false
    end
end

function _unsuppressBodyLock(delayed)
    if _blSuppressCount > 0 then
        _blSuppressCount = _blSuppressCount - 1
    end
    if _blSuppressCount == 0 and _blWasEnabled then
        _blWasEnabled = false
        if _blRestoreTimer then
            pcall(task.cancel, _blRestoreTimer)
            _blRestoreTimer = nil
        end
        local function restore()
            _blRestoreTimer = nil
            if bodyLockEnabled then
                _blSmoothRestore = true
                startBodyLock()
                if bodyLockSetVisual then bodyLockSetVisual(true) end
                task.delay(0.5, function() _blSmoothRestore = false end)
            end
        end
        if delayed then
            _blRestoreTimer = task.delay(1, restore)
        else
            restore()
        end
    end
end

function setupSpeedIndicator(char)
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    local oldBB = head:FindFirstChild("BloodHoundsSpeedIndicator")
    if oldBB then oldBB:Destroy() end
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "BloodHoundsSpeedIndicator"
    bb.Size = UDim2.new(0, 120, 0, 32)
    bb.StudsOffset = _V3new(0, 3.2, 0)
    bb.AlwaysOnTop = true
    speedLabel = Instance.new("TextLabel", bb)
    speedLabel.Size = UDim2.new(1, 0, 1, 0)
    speedLabel.Position = UDim2.new(0, 0, 0, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Spd: 0.0"
    speedLabel.TextColor3 = getThemeColor()
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextScaled = true
    speedLabel.TextStrokeTransparency = 0
    speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    applyShimmerToText(speedLabel, 0.9)
    local discordBB = head:FindFirstChild("DiscordText")
    if discordBB then discordBB:Destroy() end
    discordBB = Instance.new("BillboardGui", head)
    discordBB.Name = "DiscordText"
    discordBB.Size = UDim2.new(0, 200, 0, 28)
    discordBB.StudsOffset = _V3new(0, 5.2, 0)
    discordBB.AlwaysOnTop = true
    local discordLabel = Instance.new("TextLabel", discordBB)
    discordLabel.Size = UDim2.new(1, 0, 1, 0)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Text = "discord.gg/SZ3AM4Z6M4"
    discordLabel.TextColor3 = getThemeColor()
    discordLabel.Font = Enum.Font.GothamBold
    discordLabel.TextScaled = true
    discordLabel.TextStrokeTransparency = 0
    discordLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    applyShimmerToText(discordLabel, 0.9)
end

local unwalkSavedAnimate = nil

function startUnwalk()
    local c = LP.Character
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop() end) end
    end
    local anim = c:FindFirstChild("Animate")
    if anim then
        unwalkSavedAnimate = anim:Clone()
        anim:Destroy()
    end
end

function stopUnwalk()
    local c = LP.Character
    if c then
        local existing = c:FindFirstChild("Animate")
        if not existing then
            local src = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")
            local starterAnim = src and src:FindFirstChild("Animate")
            if starterAnim then
                starterAnim:Clone().Parent = c
            elseif unwalkSavedAnimate then
                unwalkSavedAnimate:Clone().Parent = c
            end
        end
    end
    unwalkSavedAnimate = nil
end

function refreshSpeedModeLabel()
    -- Carry OFF always means Normal Speed (60 by default).
    -- Keep the movement core synchronized with the UI toggle.
    if not speedMode and not laggerToggled and not laggerCarryToggled then
        NS = 60
    end
    if CarrySystem then
        CarrySystem.speedToggled = speedMode
        if not laggerToggled and not laggerCarryToggled then
            CarrySystem.normalSpeed = NS
        end
    end
    if modeValLbl then
        if laggerCarryToggled then modeValLbl.Text = "Lagger Carry"
        elseif laggerToggled then modeValLbl.Text = "Lagger"
        elseif speedMode then modeValLbl.Text = "Carry"
        else modeValLbl.Text = "Normal" end
    end
    if setCarryModeVisual then setCarryModeVisual(speedMode) end
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
end

function resetMovementState()
    refreshSpeedModeLabel()
    if mobSetCarry then mobSetCarry(speedMode) end
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
end

function toggleCarryMode()
    if laggerToggled or laggerCarryToggled then
        laggerToggled = false; laggerCarryToggled = false; speedMode = true
    else speedMode = not speedMode end
    resetMovementState()
end

function toggleLaggerMode()
    if laggerCarryToggled then laggerCarryToggled = false end
    speedMode = false; laggerToggled = not laggerToggled
    resetMovementState()
end
function toggleLaggerCarryMode()
    if laggerToggled then laggerToggled = false end
    speedMode = false; laggerCarryToggled = not laggerCarryToggled
    resetMovementState()
end

function toggleLaggerCycle()
    if speedMode then
        speedMode = false
        laggerToggled = true
        laggerCarryToggled = false
    elseif laggerToggled then
        speedMode = false
        laggerToggled = false
        laggerCarryToggled = true
    else
        speedMode = true
        laggerToggled = false
        laggerCarryToggled = false
    end
    resetMovementState()
end

function stopAutoLeft()
    if alConn then alConn:Disconnect(); alConn = nil end
    alPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(_V3zero, false) end
    end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobSetAutoLeft then mobSetAutoLeft(false) end
    _unsuppressBodyLock(true)
end

function startAutoLeft()
    if autoRightEnabled then
        autoRightEnabled = false
        stopAutoRight()
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
    end
    disableAllAimbots()
    _suppressBodyLock()
    if alConn then alConn:Disconnect() end
    alPhase = 1
    alConn = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if alPhase == 1 then
            local tgt = _V3new(AP.L1.X, root.Position.Y, AP.L1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                alPhase = 2
                local d = AP.L2 - root.Position
                local mv = _V3new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.L1 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif alPhase == 2 then
            local tgt = _V3new(AP.L2.X, root.Position.Y, AP.L2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(_V3zero, false)
                root.AssemblyLinearVelocity = _V3zero
                autoLeftEnabled = false
                if alConn then alConn:Disconnect(); alConn = nil end
                alPhase = 1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobSetAutoLeft then mobSetAutoLeft(false) end
                _unsuppressBodyLock(true)
                local facePos = _V3new(AP.L_FACE.X, root.Position.Y, AP.L_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = _CFnew(root.Position, facePos)
                end
                return
            end
            local d = AP.L2 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

function stopAutoRight()
    if arConn then arConn:Disconnect(); arConn = nil end
    arPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(_V3zero, false) end
    end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobSetAutoRight then mobSetAutoRight(false) end
    _unsuppressBodyLock(true)
end

function startAutoRight()
    if autoLeftEnabled then
        autoLeftEnabled = false
        stopAutoLeft()
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
    end
    disableAllAimbots()
    _suppressBodyLock()
    if arConn then arConn:Disconnect() end
    arPhase = 1
    arConn = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if arPhase == 1 then
            local tgt = _V3new(AP.R1.X, root.Position.Y, AP.R1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                arPhase = 2
                local d = AP.R2 - root.Position
                local mv = _V3new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.R1 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif arPhase == 2 then
            local tgt = _V3new(AP.R2.X, root.Position.Y, AP.R2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(_V3zero, false)
                root.AssemblyLinearVelocity = _V3zero
                autoRightEnabled = false
                if arConn then arConn:Disconnect(); arConn = nil end
                arPhase = 1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobSetAutoRight then mobSetAutoRight(false) end
                _unsuppressBodyLock(true)
                local facePos = _V3new(AP.R_FACE.X, root.Position.Y, AP.R_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = _CFnew(root.Position, facePos)
                end
                return
            end
            local d = AP.R2 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

function getClosestTarget()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local rpos = root.Position
    local closest, minDist = nil, _huge
    local plist = _GetPlayersCached()
    for i = 1, #plist do
        local plr = plist[i]
        if plr ~= LP then
            local c = plr.Character
            if c then
                local tRoot = c:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local dx = tRoot.Position.X - rpos.X
                        local dy = tRoot.Position.Y - rpos.Y
                        local dz = tRoot.Position.Z - rpos.Z
                        local d = dx*dx + dy*dy + dz*dz
                        if d < minDist then minDist = d; closest = tRoot end
                    end
                end
            end
        end
    end
    return closest
end

function trySwing()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not isBatTool(currentTool) then return end
        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)
        end
    end)
end

-- ============================================================
-- BAT AIMBOT — REPLACEMENT STANDALONE IMPLEMENTATION
-- Public API: _G.BatAimbot.Start(), Stop(), Toggle()
-- ============================================================
do
    if _G.BatAimbotLoaded then pcall(function() if _G.BatAimbot then _G.BatAimbot.Stop() end end) end
    _G.BatAimbotLoaded = true
    local BAPlayers = game:GetService("Players")
    local BARunService = game:GetService("RunService")
    local BAStats = game:GetService("Stats")
    local BALP = BAPlayers.LocalPlayer
    local BACONFIG = { SPEED=58, VERT_SPEED=52, FOLLOW_DIST=-2, HEIGHT_OFFSET=1.6, VERT_OFFSET=1,
        TURN_SPEED=285, MAX_TURN_RATE=40, MIN_FOLLOW_DIST=1, SWING_DIST=6, SWING_COOLDOWN=0.08, TARGET_SCAN=0.1 }
    local BAState = {running=false, conn=nil, charConn=nil, target=nil, lastScan=0, swingCooldown=false, origAutoRotate=nil}
    local function baFindBat()
        local char = BALP.Character
        local function isBat(tool)
            if not tool or not tool:IsA("Tool") then return false end
            local n=tool.Name:lower(); return n:find("bat",1,true) or n:find("slap",1,true)
        end
        if char then for _,v in ipairs(char:GetChildren()) do if isBat(v) then return v end end end
        local bp=BALP:FindFirstChildOfClass("Backpack")
        if bp then for _,v in ipairs(bp:GetChildren()) do if isBat(v) then return v end end end
        return nil
    end
    local function baTarget()
        local root=BALP.Character and BALP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local now=tick()
        if now-BAState.lastScan <= BACONFIG.TARGET_SCAN and BAState.target and BAState.target.Parent then
            local h=BAState.target.Parent:FindFirstChildOfClass("Humanoid")
            if h and h.Health>0 then return BAState.target end
        end
        BAState.lastScan=now; BAState.target=nil
        local best,dist=nil,math.huge
        for _,plr in ipairs(BAPlayers:GetPlayers()) do
            if plr~=BALP and plr.Character then
                local tr=plr.Character:FindFirstChild("HumanoidRootPart")
                local h=plr.Character:FindFirstChildOfClass("Humanoid")
                if tr and h and h.Health>0 then local d=(tr.Position-root.Position).Magnitude; if d<dist then best,dist=tr,d end end
            end
        end
        BAState.target=best; return best
    end
    local function baSwing(char)
        if BAState.swingCooldown then return end
        BAState.swingCooldown=true
        task.spawn(function()
            local hum=char:FindFirstChildOfClass("Humanoid"); local bat=baFindBat()
            if bat then
                if bat.Parent~=char and hum then pcall(function() hum:EquipTool(bat) end); task.wait(0.05) end
                local remote
                for _,d in ipairs(bat:GetDescendants()) do if d:IsA("RemoteEvent") then remote=d; break end end
                if remote then pcall(function() remote:FireServer() end) else pcall(function() bat:Activate() end) end
            end
            task.delay(BACONFIG.SWING_COOLDOWN,function() BAState.swingCooldown=false end)
        end)
    end
    local BA={}
    function BA.Start()
        if BAState.conn then return true end
        local char=BALP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hum then warn("[BatAimbot] No character / humanoid."); return false end
        BAState.running=true; BAState.origAutoRotate=hum.AutoRotate; hum.AutoRotate=false; BAState.target=nil; BAState.lastScan=0
        local bat=baFindBat(); if bat and bat.Parent~=char then pcall(function() hum:EquipTool(bat) end) end
        if BAState.charConn then BAState.charConn:Disconnect() end
        BAState.charConn=BALP.CharacterAdded:Connect(function(newChar)
            task.wait(0.2)
            if BAState.running then BAState.target=nil; local h=newChar:FindFirstChildOfClass("Humanoid"); if h then BAState.origAutoRotate=h.AutoRotate; h.AutoRotate=false end end
        end)
        BAState.conn=BARunService.RenderStepped:Connect(function()
            if not BAState.running then return end
            local c=BALP.Character; local root=c and c:FindFirstChild("HumanoidRootPart"); local h=c and c:FindFirstChildOfClass("Humanoid")
            if not root or not h or h.Health<=0 then return end
            if not c:FindFirstChildOfClass("Tool") then local b=baFindBat(); if b then pcall(function() h:EquipTool(b) end) end end
            local target=baTarget()
            if not target then h.AutoRotate=true; root.AssemblyAngularVelocity=Vector3.zero; return end
            local myPos,targetPos=root.Position,target.Position
            h.AutoRotate=false
            local tv=target.AssemblyLinearVelocity
            local aimPos=targetPos+tv*math.clamp(tv.Magnitude/130,0.05,0.15)+Vector3.new(0,BACONFIG.VERT_OFFSET,0)
            local look=aimPos-myPos; local flat=Vector3.new(look.X,0,look.Z)
            if look.Magnitude>0.01 and flat.Magnitude>0.01 then
                local yaw=math.deg(math.atan2(-flat.X,-flat.Z)); local yd=(yaw-root.Orientation.Y+180)%360-180
                local pitch=math.deg(math.atan2(look.Y,flat.Magnitude)); local pd=(pitch-root.Orientation.X+180)%360-180
                local yr=math.clamp(math.rad(yd)*BACONFIG.TURN_SPEED,-BACONFIG.MAX_TURN_RATE,BACONFIG.MAX_TURN_RATE)
                local pr=math.clamp(math.rad(pd)*BACONFIG.TURN_SPEED,-BACONFIG.MAX_TURN_RATE,BACONFIG.MAX_TURN_RATE)
                local yRad=math.rad(root.Orientation.Y); local right=Vector3.new(math.cos(yRad),0,-math.sin(yRad))
                root.AssemblyAngularVelocity=Vector3.new(0,yr,0)+(right*pr)
            else root.AssemblyAngularVelocity=Vector3.zero end
            local follow=math.max(math.abs(BACONFIG.FOLLOW_DIST),BACONFIG.MIN_FOLLOW_DIST)
            local dir=look.Magnitude>0.01 and look.Unit or Vector3.new(1,0,0)
            local stand=aimPos-dir*follow+Vector3.new(0,BACONFIG.HEIGHT_OFFSET,0)
            local move=stand-root.Position; local flatMove=Vector3.new(move.X,0,move.Z)
            local hv=flatMove.Magnitude>0.1 and flatMove.Unit*BACONFIG.SPEED or Vector3.zero
            local vv=math.abs(move.Y)>0.1 and Vector3.new(0,math.sign(move.Y)*BACONFIG.VERT_SPEED,0) or Vector3.new(0,-2,0)
            root.AssemblyLinearVelocity=hv+vv
            if flatMove.Magnitude>0.5 then h:Move(flatMove.Unit,false) end
            if (targetPos-myPos).Magnitude<BACONFIG.SWING_DIST then baSwing(c) end
        end)
        print("[BatAimbot] STARTED"); return true
    end
    function BA.Stop()
        BAState.running=false
        if BAState.conn then BAState.conn:Disconnect(); BAState.conn=nil end
        if BAState.charConn then BAState.charConn:Disconnect(); BAState.charConn=nil end
        BAState.target=nil; BAState.lastScan=0; BAState.swingCooldown=false
        local c=BALP.Character; local root=c and c:FindFirstChild("HumanoidRootPart"); local h=c and c:FindFirstChildOfClass("Humanoid")
        if root then root.AssemblyLinearVelocity=Vector3.zero; root.AssemblyAngularVelocity=Vector3.zero end
        if h then h.AutoRotate=BAState.origAutoRotate~=false end
        BAState.origAutoRotate=nil; print("[BatAimbot] STOPPED")
    end
    function BA.Toggle() if BAState.running then BA.Stop() else BA.Start() end end
    BA.IsRunning=function() return BAState.running end
    _G.BatAimbot=BA
end

function stopAimbotAdapt()
    if _G.BatAimbot and type(_G.BatAimbot.Stop)=="function" then pcall(_G.BatAimbot.Stop) end
    _aimbotConn=nil
    _unsuppressBodyLock(true)
end
function startAimbotAdapt()
    if _G.BatAimbot and type(_G.BatAimbot.Start)=="function" then
        _suppressBodyLock()
        local ok,started=pcall(_G.BatAimbot.Start)
        if not ok or started==false then warn("[LURK HUB] Bat Aimbot failed to start.") end
    end
end

function disableAutoBat()
    autoBatEnabled = false
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    stopAimbotAdapt()
end

function enableAutoBat()
    if autoLeftEnabled then
        autoLeftEnabled = false
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        stopAutoLeft()
    end
    if autoRightEnabled then
        autoRightEnabled = false
        if autoRightSetVisual then autoRightSetVisual(false) end
        stopAutoRight()
    end
    if autoBatV2Enabled then disableBatV2() end
    autoBatEnabled = true
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
    startAimbotAdapt()
end

local function findAnyToolV2()
    local c = LP.Character
    if c then
        for _, v in ipairs(c:GetChildren()) do
            if v:IsA("Tool") then return v end
        end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, v in ipairs(bp:GetChildren()) do
            if v:IsA("Tool") then return v end
        end
    end
    return nil
end

local function getClosestPlayerV2()
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, _huge end
    local hpos = hrp.Position
    local closest, bestDist = nil, _huge
    local plist = _GetPlayersCached()
    for i = 1, #plist do
        local p = plist[i]
        if p ~= LP then
            local c = p.Character
            if c then
                local tr = c:FindFirstChild("HumanoidRootPart")
                local ph = c:FindFirstChildOfClass("Humanoid")
                if tr and ph and ph.Health > 0 then
                    local dx = hpos.X - tr.Position.X
                    local dy = hpos.Y - tr.Position.Y
                    local dz = hpos.Z - tr.Position.Z
                    local d = _sqrt(dx*dx + dy*dy + dz*dz)
                    if d < bestDist then bestDist = d; closest = p end
                end
            end
        end
    end
    return closest, bestDist
end

local function tryHitBatV2()
    if autoBatV2HitCooldown or not autoBatV2SwingEnabled then return end
    autoBatV2HitCooldown = true
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local tool = findAnyToolV2()
        if tool then
            if tool.Parent ~= char and hum then
                pcall(function() hum:EquipTool(tool) end)
            end
            local remote = tool:FindFirstChildOfClass("RemoteEvent")
            if remote then
                pcall(function() remote:FireServer() end)
            else
                pcall(function() tool:Activate() end)
            end
        end
    end
    task.delay(AUTO_BAT_V2_SWING_CD, function()
        autoBatV2HitCooldown = false
    end)
end

local function startBatV2Aimbot()
    if _batV2Conn then return end
    _batV2Conn = RunService.Heartbeat:Connect(function()
        if not autoBatV2Enabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local target, dist = getClosestPlayerV2()
        if target and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local targetVel = targetRoot.AssemblyLinearVelocity or targetRoot.Velocity
                local moveDir = targetVel.Magnitude > 0.1 and targetVel.Unit or targetRoot.CFrame.LookVector
                local offset = moveDir * AUTO_BAT_V2_DIST + _V3new(0, AUTO_BAT_V2_HEIGHT + AUTO_BAT_V2_V_OFF, 0)
                local desiredPos = targetRoot.Position + offset
                local toTarget = desiredPos - root.Position
                if toTarget.Magnitude > 0.5 then
                    local moveVec = toTarget.Unit * AUTO_BAT_V2_SPEED
                    root.AssemblyLinearVelocity = _V3new(moveVec.X, moveVec.Y, moveVec.Z)
                else
                    root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.95
                    if root.AssemblyLinearVelocity.Magnitude < 1 then
                        root.AssemblyLinearVelocity = _V3zero
                    end
                end
                local distToTarget = (root.Position - targetRoot.Position).Magnitude
                if distToTarget <= AUTO_BAT_V2_HIT_DIST then
                    tryHitBatV2()
                end
            end
        else
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.9
            if root.AssemblyLinearVelocity.Magnitude < 1 then
                root.AssemblyLinearVelocity = _V3zero
            end
        end
    end)
end

local function stopBatV2Aimbot()
    if _batV2Conn then
        _batV2Conn:Disconnect()
        _batV2Conn = nil
    end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity = _V3zero
    end
    autoBatV2HitCooldown = false
end

function enableBatV2()
    if autoBatV2Enabled then return end
    if autoBatEnabled then disableAutoBat() end
    if autoLeftEnabled then
        autoLeftEnabled = false
        stopAutoLeft()
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
    end
    if autoRightEnabled then
        autoRightEnabled = false
        stopAutoRight()
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
    end
    autoBatV2Enabled = true
    startBatV2Aimbot()
    if autoBatV2SetVisual then autoBatV2SetVisual(true) end
    if batV2FloatingButton then
        local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
        if btnFrame then paintFloatingBtn(btnFrame, true) end
    end
end

function disableBatV2()
    if not autoBatV2Enabled then return end
    autoBatV2Enabled = false
    stopBatV2Aimbot()
    if autoBatV2SetVisual then autoBatV2SetVisual(false) end
    if batV2FloatingButton then
        local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
        if btnFrame then paintFloatingBtn(btnFrame, false) end
    end
end

function toggleBatV2()
    if autoBatV2Enabled then disableBatV2()
    else enableBatV2() end
end

function findBat()
    local char = LP.Character
    if not char then return nil end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t = char:FindFirstChild(name)
        if t and t:IsA("Tool") then return t end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
            local t = bp:FindFirstChild(name)
            if t and t:IsA("Tool") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(t) end) end
                return t
            end
        end
    end
    for _, ch in ipairs(char:GetChildren()) do
        if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then
            return ch
        end
    end
    return nil
end

function isBatTool(tool)
    if not tool then return false end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        if tool.Name == name then return true end
    end
    return tool.Name:lower():find("bat") or tool.Name:lower():find("slap")
end

function findBatForCounter()
    local char = LP.Character
    if not char then return nil end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local tool = char:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name))
        if tool then return tool end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
            return child
        end
    end
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
                return child
            end
        end
    end
    return nil
end

function swingBatForCounter(bat, character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= character and humanoid then
        pcall(function() humanoid:EquipTool(bat) end)
        task.wait(0.05)
    end
    local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end)
        task.wait(0.1)
        pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end)
        task.wait(0.1)
        pcall(function() bat:Activate() end)
    end
end

batCounterDebounce = false

function stopBatCounter()
    if Conns.batCounter then
        Conns.batCounter:Disconnect()
        Conns.batCounter = nil
    end
    batCounterDebounce = false
end

function startBatCounter()
    if Conns.batCounter then return end
    Conns.batCounter = RunService.Heartbeat:Connect(function()
        if not batCounterEnabled then return end
        if batCounterDebounce then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
            batCounterDebounce = true
            _suppressBodyLock()
            task.spawn(function()
                task.wait(0.15)
                local bat = findBatForCounter()
                if bat then swingBatForCounter(bat, character) end
                task.wait(0.3)
                batCounterDebounce = false
                _unsuppressBodyLock(true)
            end)
        end
    end)
end

function findMedusa()
    local c = LP.Character
    if not c then return nil end
    for _, t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") then
            local n = t.Name:lower()
            if n:find("medusa") or n:find("head") or n:find("stone") then return t end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("medusa") or n:find("head") or n:find("stone") then return t end
            end
        end
    end
    return nil
end

function useMedusaCounter()
    if medusaDebounce then return end
    if _tick() - medusaLastUsed < MEDUSA_COOLDOWN then return end
    local c = LP.Character
    if not c then return end
    medusaDebounce = true
    local med = findMedusa()
    if not med then medusaDebounce = false; return end
    if med.Parent ~= c then
        local hum2 = c:FindFirstChildOfClass("Humanoid")
        if hum2 then hum2:EquipTool(med) end
    end
    pcall(function() med:Activate() end)
    medusaLastUsed = _tick()
    medusaDebounce = false
end

function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then useMedusaCounter() end
    end)
end

function setupMedusaCounter(char)
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
    if not char or not medusaCounterEnabled then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(Conns.anchor, onAnchorChanged(part))
        end
    end
    table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(Conns.anchor, onAnchorChanged(part))
        end
    end))
end

function stopMedusaCounter()
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
end

local DROP_ASCEND_DURATION = 0.22
local DROP_ASCEND_SPEED = 160
local _dropConn = nil

function stopDropBrainrot()
    dropActive = false
    if _dropConn then
        _dropConn:Disconnect()
        _dropConn = nil
    end
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end
    end
    dropConnections = {}
    local c = LP.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyLinearVelocity = _V3zero end
    end
    if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
    if mobSetDropBR then mobSetDropBR(false) end
end

function runDropBrainrot()
    if dropActive then return end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    if dropMode == 1 then
        local speedH = 0
        if root then
            local vel = root.AssemblyLinearVelocity
            speedH = _V3new(vel.X, 0, vel.Z).Magnitude
        end
        local cooldown = (speedH > 5) and 0.6 or 0.25
        if _tick() - lastDropTime < cooldown then return end
        lastDropTime = _tick()
        dropActive = true
        if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
        if mobSetDropBR then mobSetDropBR(true) end
        local wasAutoBat = false
        if autoBatEnabled then
            wasAutoBat = true
            disableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(false) end
            if mobSetAutoBat then mobSetAutoBat(false) end
        end
        local function finishDrop(threadRef)
            if threadRef and dropConnections then
                for i = #dropConnections, 1, -1 do
                    if dropConnections[i] == threadRef then
                        table.remove(dropConnections, i)
                        break
                    end
                end
            end
            dropActive = false
            local c = LP.Character
            if c then
                local r = c:FindFirstChild("HumanoidRootPart")
                local h = c:FindFirstChildOfClass("Humanoid")
                if r then
                    r.AssemblyLinearVelocity = _V3zero
                    r.AssemblyAngularVelocity = _V3zero
                    if r.Position.Y < -100 then
                        r.CFrame = _CFnew(r.Position.X, 5, r.Position.Z)
                    end
                    local rp = RaycastParams.new()
                    rp.FilterDescendantsInstances = {c}
                    rp.FilterType = Enum.RaycastFilterType.Exclude
                    local rr = workspace:Raycast(r.Position, _V3new(0, -2000, 0), rp)
                    if rr then
                        local off = (h and h.HipHeight or 2) + (r.Size.Y / 2)
                        r.CFrame = _CFnew(r.Position.X, rr.Position.Y + off, r.Position.Z)
                    end
                    if h and h.Health > 0 then h:ChangeState(Enum.HumanoidStateType.Running) end
                end
            end
            if wasAutoBat then
                enableAutoBat()
                if autoBatSetVisual then autoBatSetVisual(true) end
                if mobSetAutoBat then mobSetAutoBat(true) end
            end
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
        end
        local flingThread = nil
        flingThread = task.spawn(function()
            local startTime = _tick()
            while dropActive and (_tick() - startTime) < 0.25 do
                RunService.Heartbeat:Wait()
                local c = LP.Character
                local r = c and c:FindFirstChild("HumanoidRootPart")
                if not r then break end
                local vel = r.AssemblyLinearVelocity
                vel = _V3new(0, vel.Y, 0)
                r.AssemblyLinearVelocity = vel * 10000 + _V3new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if r and r.Parent then r.AssemblyLinearVelocity = vel end
                RunService.Stepped:Wait()
                if r and r.Parent then r.AssemblyLinearVelocity = vel + _V3new(0, 0.1, 0) end
            end
            finishDrop(flingThread)
        end)
        table.insert(dropConnections, flingThread)
        task.delay(0.35, function()
            if dropActive then finishDrop(flingThread) end
        end)
        return
    end
    dropActive = true
    if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
    if mobSetDropBR then mobSetDropBR(true) end
    local t0 = _tick()
    if _dropConn then _dropConn:Disconnect() end
    _dropConn = RunService.Heartbeat:Connect(function()
        local c = LP.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if not r then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            dropActive = false
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        if not dropActive then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        if _tick() - t0 >= DROP_ASCEND_DURATION then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            pcall(function()
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {c}
                rp.FilterType = Enum.RaycastFilterType.Exclude
                local rr = workspace:Raycast(r.Position, _V3new(0, -3000, 0), rp)
                if rr then
                    local hum2 = c:FindFirstChildOfClass("Humanoid")
                    local off = ((hum2 and hum2.HipHeight) or 2) + (r.Size.Y / 2)
                    r.CFrame = _CFnew(r.Position.X, rr.Position.Y + off, r.Position.Z)
                    r.AssemblyLinearVelocity = _V3zero
                    r.AssemblyAngularVelocity = _V3zero
                end
                if hum2 and hum2.Health > 0 then hum2:ChangeState(Enum.HumanoidStateType.Running) end
            end)
            dropActive = false
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        local lv = r.AssemblyLinearVelocity
        r.AssemblyLinearVelocity = _V3new(lv.X, DROP_ASCEND_SPEED, lv.Z)
    end)
end

function executeDropWithToggle(setVisual)
    if dropActive then return end
    task.spawn(function()
        if setVisual then setVisual(true) end
        runDropBrainrot()
        while dropActive do task.wait() end
        task.wait(0.1)
        if setVisual then setVisual(false) end
    end)
end

function applyAntiLagDerender(obj)
    pcall(function()
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
            for _, t in ipairs(obj:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end
        end
    end)
end

function enableAntiLag()
    antiLagEnabled = true
    task.spawn(function()
        local descs = workspace:GetDescendants()
        local i = 0
        local total = #descs
        while i < total and antiLagEnabled do
            for _ = 1, 200 do
                i = i + 1
                if i > total then break end
                applyAntiLagDerender(descs[i])
            end
            task.wait()
        end
    end)
    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if antiLagEnabled then applyAntiLagDerender(obj) end
    end)
end

function disableAntiLag()
    antiLagEnabled = false
    if antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn = nil end
end

CUSTOM_FOV_BIND = "LURK_HUBCustomFOV"

function enableCustomFov()
    local cam = workspace.CurrentCamera
    if cam and origFOV == nil then origFOV = cam.FieldOfView end
    fovEnabled = true
    if cam then
        pcall(function() cam.FieldOfViewMode = Enum.FieldOfViewMode.Diagonal end)
        pcall(function() cam.FieldOfView = fovValue end)
    end
    if customFovConn then customFovConn:Disconnect(); customFovConn = nil end
    pcall(function() RunService:UnbindFromRenderStep(CUSTOM_FOV_BIND) end)
    local prio = 200
    pcall(function() prio = Enum.RenderPriority.Camera.Value + 10 end)
    local ok = pcall(function()
        RunService:BindToRenderStep(CUSTOM_FOV_BIND, prio, function()
            if not fovEnabled then return end
            local c = workspace.CurrentCamera
            if c and c.FieldOfView ~= fovValue then
                c.FieldOfView = fovValue
            end
        end)
    end)
    if not ok then
        customFovConn = RunService.RenderStepped:Connect(function()
            if not fovEnabled then
                if customFovConn then customFovConn:Disconnect(); customFovConn = nil end
                return
            end
            local c = workspace.CurrentCamera
            if c then c.FieldOfView = fovValue end
        end)
    end
end

function disableCustomFov()
    fovEnabled = false
    pcall(function() RunService:UnbindFromRenderStep(CUSTOM_FOV_BIND) end)
    if customFovConn then customFovConn:Disconnect(); customFovConn = nil end
    local cam = workspace.CurrentCamera
    if cam then
        pcall(function() cam.FieldOfViewMode = Enum.FieldOfViewMode.Vertical end)
        pcall(function() cam.FieldOfView = origFOV or 70 end)
    end
end

function applyStretchFOV(val)
    local cam = workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView = val end) end
end

function enableStretch()
    if stretchConn then return end
    stretchEnabled = true
    local cam = workspace.CurrentCamera
    if not cam then return end
    origFOV = cam.FieldOfView or 70
    applyStretchFOV(stretchFOV)
    stretchConn = RunService.RenderStepped:Connect(function()
        if not stretchEnabled then
            stretchConn:Disconnect()
            stretchConn = nil
            return
        end
        local c = workspace.CurrentCamera
        if c then c.CFrame = c.CFrame * _CFnew(0,0,0,1,0,0,0,0.7,0,0,0,1) end
    end)
    if stretchFovConn then stretchFovConn:Disconnect() end
    stretchFovConn = RunService.RenderStepped:Connect(function()
        if stretchEnabled then applyStretchFOV(stretchFOV)
        else stretchFovConn:Disconnect(); stretchFovConn = nil end
    end)
end

function disableStretch()
    stretchEnabled = false
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end
    local cam = workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView = origFOV or 70 end) end
end

local function saveLightingState()
    if _originalLighting then return end
    _originalLighting = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart,
        FogColor = Lighting.FogColor,
        Ambient = Lighting.Ambient,
        ColorCorrection = nil,
        Bloom = nil,
    }
    for _, e in ipairs(Lighting:GetChildren()) do
        if e:IsA("ColorCorrectionEffect") then
            _originalLighting.ColorCorrection = {
                Enabled = e.Enabled,
                Brightness = e.Brightness,
                Contrast = e.Contrast,
                Saturation = e.Saturation,
                TintColor = e.TintColor,
            }
        elseif e:IsA("BloomEffect") then
            _originalLighting.Bloom = {
                Enabled = e.Enabled,
                Intensity = e.Intensity,
                Size = e.Size,
                Threshold = e.Threshold,
            }
        end
    end
end

local function restoreLightingState()
    if not _originalLighting then return end
    local old = _originalLighting
    Lighting.Brightness = old.Brightness
    Lighting.ClockTime = old.ClockTime
    Lighting.OutdoorAmbient = old.OutdoorAmbient
    Lighting.GlobalShadows = old.GlobalShadows
    Lighting.FogEnd = old.FogEnd
    Lighting.FogStart = old.FogStart
    Lighting.FogColor = old.FogColor
    Lighting.Ambient = old.Ambient
    if old.ColorCorrection then
        local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
        if cc then
            cc.Enabled = old.ColorCorrection.Enabled
            cc.Brightness = old.ColorCorrection.Brightness
            cc.Contrast = old.ColorCorrection.Contrast
            cc.Saturation = old.ColorCorrection.Saturation
            cc.TintColor = old.ColorCorrection.TintColor
        end
    end
    if old.Bloom then
        local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
        if bloom then
            bloom.Enabled = old.Bloom.Enabled
            bloom.Intensity = old.Bloom.Intensity
            bloom.Size = old.Bloom.Size
            bloom.Threshold = old.Bloom.Threshold
        end
    end
end

SKY_PRESETS_LIST = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}

SKY_PRESETS = {
    ["Off"]={kind="off"},
    ["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.55,dens=0.55,color={200,150,255}}},
    ["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
    ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
    ["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
    ["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
    ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}

local function _vC3(t) return Color3.fromRGB(t[1], t[2], t[3]) end

function _v4mpClearSky()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute("_AdaptDuelsSky") then
            pcall(function() child:Destroy() end)
        end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:GetAttribute("_AdaptDuelsSky") then
                pcall(function() child:Destroy() end)
            end
        end
    end
end

function applyCustomSky(mode)
    _v4mpClearSky()
    local preset = SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
        Lighting.Ambient = Color3.fromRGB(127,127,127)
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        skyTheme = "Off"
        return
    end
    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
    Lighting.FogColor = Color3.fromRGB(200,200,200)
    Lighting.ColorShift_Top = Color3.fromRGB(0,0,0)
    Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
    Lighting.GlobalShadows = true
    Lighting.ClockTime = preset.clock or 14
    Lighting.Brightness = preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient = _vC3(preset.outAmb) end
    if preset.ambient then Lighting.Ambient = _vC3(preset.ambient) end
    if preset.sky then
        local skyInst = Instance.new("Sky")
        skyInst:SetAttribute("_AdaptDuelsSky", true)
        if preset.sky.stars then skyInst.StarCount = preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId = "rbxasset://sky/moon.jpg" end
        skyInst.Parent = Lighting
    end
    if preset.atm then
        local atm = Instance.new("Atmosphere")
        atm:SetAttribute("_AdaptDuelsSky", true)
        atm.Density = preset.atm.dens or 0.3
        atm.Color = _vC3(preset.atm.color)
        atm.Decay = _vC3(preset.atm.decay)
        atm.Glare = preset.atm.glare or 1
        atm.Haze = preset.atm.haze or 1
        atm.Parent = Lighting
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if preset.clouds and terrain then
        local clouds = Instance.new("Clouds")
        clouds:SetAttribute("_AdaptDuelsSky", true)
        clouds.Cover = preset.clouds.cover or 0.5
        clouds.Density = preset.clouds.dens or 0.5
        clouds.Color = _vC3(preset.clouds.color)
        clouds.Parent = terrain
    end
    skyTheme = mode
end

local function applyNeonWeather()
    if not neonWeatherEnabled then
        restoreLightingState()
        return
    end
    if not _originalLighting then saveLightingState() end
    Lighting.Brightness = 3.5
    Lighting.ClockTime = 20
    Lighting.OutdoorAmbient = Color3.fromRGB(20, 40, 80)
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 300
    Lighting.FogStart = 0
    Lighting.FogColor = Color3.fromRGB(0, 80, 200)
    Lighting.Ambient = Color3.fromRGB(30, 60, 120)
    local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
    if not cc then
        cc = Instance.new("ColorCorrectionEffect")
        cc.Parent = Lighting
    end
    cc.Enabled = true
    cc.Brightness = 0.2
    cc.Contrast = 0.15
    cc.Saturation = 0.15
    cc.TintColor = Color3.fromRGB(180, 180, 190)
    local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
    if not bloom then
        bloom = Instance.new("BloomEffect")
        bloom.Parent = Lighting
    end
    bloom.Enabled = true
    bloom.Intensity = 0.6
    bloom.Size = 25
    bloom.Threshold = 0.8
end

function toggleNeonWeather(state)
    if state == nil then
        neonWeatherEnabled = not neonWeatherEnabled
    else
        neonWeatherEnabled = state
    end
    applyNeonWeather()
    if setNeonWeatherVisual then setNeonWeatherVisual(neonWeatherEnabled) end
end

function paintFloatingBtn(btnFrame, active)
    if not btnFrame then return end
    local bg = btnFrame:FindFirstChild("BtnGrad")
    local label = btnFrame:FindFirstChild("TextLabel")
    local stroke = btnFrame:FindFirstChildOfClass("UIStroke")

    -- Pressed look from the reference image: solid white button + black text.
    local pressed = btnFrame:GetAttribute("LurkPressed") == true
    local pressBg = Color3.fromRGB(255, 255, 255)
    local normalBg = Color3.fromRGB(5, 5, 5)

    btnFrame.BackgroundColor3 = pressed and pressBg or normalBg
    if bg then
        if pressed then
            bg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, pressBg),
                ColorSequenceKeypoint.new(0.50, pressBg),
                ColorSequenceKeypoint.new(1.00, pressBg),
            })
        else
            bg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(5,5,5)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(8,8,8)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(3,3,3)),
            })
        end
    end
    if label then
        label.TextColor3 = pressed and Color3.fromRGB(0,0,0)
            or (active and Color3.fromRGB(245,245,245) or Color3.fromRGB(190,190,195))
    end
    if stroke and stroke.Name == "NormalStroke" then
        stroke.Transparency = 1
        stroke.Thickness = 0
    end
end

function applyFloatingButtonScale()
    for _, uiScale in ipairs(_floatingUIScales) do
        if uiScale and uiScale.Parent then
            uiScale.Scale = floatingButtonScale
        end
    end
end

local function drag(f)
    local dn, ds, sp, di = false, nil, nil, nil
    local endConn = nil
    local function stopDrag()
        dn = false
        di = nil
        if endConn then
            endConn:Disconnect()
            endConn = nil
        end
    end
    f.InputBegan:Connect(function(i)
        if uiLocked then return end
        if _isDraggingButton then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dn = true; ds = i.Position; sp = f.Position
            if endConn then endConn:Disconnect() end
            endConn = i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then stopDrag() end
            end)
        end
    end)
    f.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            stopDrag()
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            stopDrag()
        end
    end)
    f.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
    end)
    UIS.InputChanged:Connect(function(i)
        if i == di and dn then
            if uiLocked then stopDrag(); return end
            if _isDraggingButton then return end
            if not ds or not sp then return end
            local nX = sp.X.Offset + (i.Position.X - ds.X)
            local nY = sp.Y.Offset + (i.Position.Y - ds.Y)
            f.Position = UDim2.new(sp.X.Scale, nX, sp.Y.Scale, nY)
        end
    end)
end

function setupMovementAndIndicators(char)
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end

    local ccAcc = 0
    steppedConn = RunService.Heartbeat:Connect(function(dt)
        ccAcc = ccAcc + dt
        if ccAcc < 0.05 then return end
        ccAcc = 0
        local plist = _GetPlayersCached()
        for i = 1, #plist do
            local p = plist[i]
            if p ~= LP then
                local ch = p.Character
                if ch then
                    local parts = ch:GetChildren()
                    for j = 1, #parts do
                        local part = parts[j]
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end
    end)

    movementLoop = RunService.RenderStepped:Connect(function()
        local char2 = LP.Character
        if not char2 then return end
        local hum = char2:FindFirstChildOfClass("Humanoid")
        local hrp = char2:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end

        if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled
           and not autoBatV2Enabled then
            if _isRagdollState(hum) then
                lastMoveDir = _V3zero
            else
                local md = hum.MoveDirection
                local spd = getActiveMoveSpeed()
                local dir = nil
                if md.Magnitude > 0 then
                    lastMoveDir = md
                    dir = md
                elseif lastMoveDir.Magnitude > 0 then
                    for key in pairs(MOVE_KEYS) do
                        if UIS:IsKeyDown(key) then dir = lastMoveDir; break end
                    end
                end
                _applyVelocitySpeed(dir, spd, hrp)
            end
        end

        if speedLabel then
            local v = hrp.AssemblyLinearVelocity
            local s = _sqrt(v.X*v.X + v.Z*v.Z)
            if s < 0.05 then s = 0 end
            speedLabel.Text = "Speed: " .. string.format("%.1f", s)
        end
    end)
    setupSpeedIndicator(char)
    startEnemySpeed()
end

function toggleLockUI(state)
    if state == nil then uiLocked = not uiLocked else uiLocked = state end
    if uiLocked and editModeEnabled then
        editModeEnabled = false
        if setEditModeVisual then setEditModeVisual(false) end
    end
    if setLockUIVisual then setLockUIVisual(uiLocked) end
end

function toggleEditMode(state)
    if state == nil then state = not editModeEnabled end
    if state and uiLocked then state = false end
    editModeEnabled = state
    if setEditModeVisual then setEditModeVisual(editModeEnabled) end
end

function disableAllAimbots()
    if autoBatEnabled then
        disableAutoBat()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
    end
    if autoBatV2Enabled then
        disableBatV2()
        if autoBatV2SetVisual then autoBatV2SetVisual(false) end
        if batV2FloatingButton then
            local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
            if btnFrame then paintFloatingBtn(btnFrame, false) end
        end
    end
end

function stopAllBackgroundTasks()
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    stopEnemySpeed()
    if stretchEnabled then disableStretch() end
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end
    if AntiRagdollV1.isRunning() then AntiRagdollV1.stop() end
    if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
    if antiDieEnabled then AntiDieModule.stop() end
    if antiFlingEnabled then AntiFlingShieldModule.stop() end
    stopBatCounter()
    stopBatCounterV2()
    stopMedusaCounter()
    stopAutoSteal()
    disableAutoBat()
    if autoBatV2Enabled then disableBatV2() end
    stopAutoLeft()
    stopAutoRight()
    if unwalkEnabled then stopUnwalk() end
    if antiLagEnabled then disableAntiLag() end
    if espEnabled then toggleESP(false) end
    if dropActive then stopDropBrainrot() end
    if bodyLockEnabled then stopBodyLock() end
    _blSuppressCount = 0
    _blWasEnabled = false
    if _blRestoreTimer then
        pcall(task.cancel, _blRestoreTimer)
        _blRestoreTimer = nil
    end
    if _bodyLockConn then
        _bodyLockConn:Disconnect()
        _bodyLockConn = nil
    end
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end
    end
    dropConnections = {}
    dropActive = false
    alPhase = 1
    arPhase = 1
    lastDropTime = 0
    medusaDebounce = false
    medusaLastUsed = 0
end

function buildConfigTable()
    local config = {
        normalSpeed = NS,
        carrySpeed = CS,
        laggerSpeed1 = LAGGER_SPEED,
        laggerSpeed2 = LAGGER_CARRY_SPEED,
        stealRadius = CONFIG.STEAL_RANGE,
        antiRagdollMode = antiRagdollMode,
        antiDieEnabled = antiDieEnabled,
        autoSteal = CONFIG.AUTO_STEAL_ENABLED,
        medusaCounter = medusaCounterEnabled,
        batCounter = batCounterEnabled,
        batCounterV2 = batCounterV2Enabled,
        laggerToggled = laggerToggled,
        laggerCarryToggled = laggerCarryToggled,
        carryMode = speedMode,
        batAimbotSpeed = BAT_AIMBOT_SPEED,
        dropMode = dropMode,
        stretchEnabled = stretchEnabled,
        stretchFOV = stretchFOV,
        fovEnabled = fovEnabled,
        fovValue = fovValue,
        uiScale = uiScaleValue,
        animPack = currentAnimPack,
        espEnabled = espEnabled,
        antiLag = antiLagEnabled,
        neonWeather = neonWeatherEnabled,
        skyTheme = skyTheme,
        autoBatV2Enabled = autoBatV2Enabled,
        mobileButtonPositions = savedButtonPositions,
        dropBrainrotKey = {kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name, gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name},
        autoLeftKey = {kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name, gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name},
        autoRightKey = {kb = KB.AutoRight.kb and KB.AutoRight.kb.Name, gp = KB.AutoRight.gp and KB.AutoRight.gp.Name},
        autoBatKey = {kb = KB.AutoBat.kb and KB.AutoBat.kb.Name, gp = KB.AutoBat.gp and KB.AutoBat.gp.Name},
        tpFloorKey = {kb = KB.TPFloor.kb and KB.TPFloor.kb.Name, gp = KB.TPFloor.gp and KB.TPFloor.gp.Name},
        carryToggleKey = {kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name, gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name},
        autoCarryKey = {kb = KB.AutoCarry.kb and KB.AutoCarry.kb.Name, gp = KB.AutoCarry.gp and KB.AutoCarry.gp.Name},
        laggerModeKey = {kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name, gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name},
        batV2Key = {kb = KB.BatV2.kb and KB.BatV2.kb.Name, gp = KB.BatV2.gp and KB.BatV2.gp.Name},
        batV2FloatingPos = batV2FloatingPos,
        bodyLockEnabled = bodyLockEnabled,
        bodyLockRange = bodyLockRange,
        progressBarPos = savedProgressBarPos,
        lockUI = uiLocked,
        editMode = editModeEnabled,
        backgroundIndex = backgroundIndex,
        backgroundImageTransparency = backgroundImageTransparency,
        floatingButtonScale = floatingButtonScale,
        outfitIndex = currentOutfitIndex,
        themeColor = currentColorTheme,
        useCarrySystem = useCarrySystem,
        carrySysNormal = CarrySystem.normalSpeed,
        carrySysCarry = CarrySystem.carrySpeed,
        carrySysLagger = CarrySystem.laggerSpeed,
        carrySysLaggerCarry = CarrySystem.laggerCarrySpeed,
        carrySysSoftStealSpeed = CarrySystem.softStealSpeed,
        carrySysSoftStealRadius = CarrySystem.softStealRadius,
    }
    if pbFrame then
        config.progressBarPos = {
            XScale = pbFrame.Position.X.Scale,
            XOffset = pbFrame.Position.X.Offset,
            YScale = pbFrame.Position.Y.Scale,
            YOffset = pbFrame.Position.Y.Offset
        }
    end
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        config.mobilePanelPos = {
            XScale = container.Position.X.Scale,
            XOffset = container.Position.X.Offset,
            YScale = container.Position.Y.Scale,
            YOffset = container.Position.Y.Offset
        }
    end
    return config
end

function saveAllSettings()
    if _isResetting then return true end
    local config = buildConfigTable()
    local json = HS:JSONEncode(config)
    if json == _lastSavedJSON then return true end
    local success, err = pcall(function() writefile(CONFIG_FILE, json) end)
    if success then _lastSavedJSON = json end
    return success
end

function loadAllSettings()
    if not isfile or not isfile(CONFIG_FILE) then return false end
    local success, data = pcall(function() return HS:JSONDecode(readfile(CONFIG_FILE)) end)
    if not success or not data then return false end
    _isLoading = true
    NS = data.normalSpeed or NS
    CS = data.carrySpeed or CS
    LAGGER_SPEED = data.laggerSpeed1 or LAGGER_SPEED
    LAGGER_CARRY_SPEED = data.laggerSpeed2 or LAGGER_CARRY_SPEED
    CONFIG.STEAL_RANGE = data.stealRadius or CONFIG.STEAL_RANGE
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    uiLocked = data.lockUI or true
    editModeEnabled = data.editMode or false
    if data.antiRagdollMode then
        antiRagdollMode = data.antiRagdollMode
    else
        antiRagdollMode = data.antiRagdoll and "v2" or "off"
    end
    antiDieEnabled = data.antiDieEnabled or false
    antiFlingEnabled = data.antiFlingEnabled or false
    CONFIG.AUTO_STEAL_ENABLED = data.autoSteal or false
    medusaCounterEnabled = data.medusaCounter or false
    batCounterEnabled = data.batCounter or false
    batCounterV2Enabled = data.batCounterV2 or false
    unwalkEnabled = data.unwalk or false
    antiLagEnabled = data.antiLag or false
    laggerToggled = data.laggerToggled or false
    speedMode = data.carryMode or false
    laggerCarryToggled = data.laggerCarryToggled or false

    uiScaleValue = 78
    if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
    if pbScale then pbScale.Scale = uiScaleValue / 100 end
    espEnabled = data.espEnabled or false
    if espEnabled then toggleESP(true) else toggleESP(false) end
    if data.themeColor and COLOR_THEMES[data.themeColor] then
        currentColorTheme = data.themeColor
        selectedColor = COLOR_THEMES[data.themeColor]
        task.defer(function()
            updateAllUIThemeColors(selectedColor)
            if colorSelectorLabel then
                colorSelectorLabel.Text = currentColorTheme
                colorSelectorLabel.TextColor3 = selectedColor
            end
        end)
    end
    autoBatV2Enabled = false
    if autoBatV2Enabled then
        task.defer(function()
            enableBatV2()
            if autoBatV2SetVisual then autoBatV2SetVisual(true) end
        end)
    else
        if autoBatV2SetVisual then autoBatV2SetVisual(false) end
    end
    skyTheme = data.skyTheme or "Off"
    if skyTheme ~= "Off" then pcall(applyCustomSky, skyTheme) end
    if skySelectorLabel then skySelectorLabel.Text = skyTheme end
    neonWeatherEnabled = data.neonWeather or false
    if neonWeatherEnabled then
        task.defer(function() toggleNeonWeather(true) end)
    else
        toggleNeonWeather(false)
        skyTheme = "Off"
        pcall(applyCustomSky, "Off")
        if skySelectorLabel then skySelectorLabel.Text = "Off" end
    end
    if data.animPack and ANIM_PACKS[data.animPack] then
        startAnimPack(data.animPack)
    else
        currentAnimPack = "Off"
        stopAnimPack()
    end
    local function lk(e, d)
        if not d then return end
        if d.kb and Enum.KeyCode[d.kb] then e.kb = Enum.KeyCode[d.kb] end
        if d.gp and Enum.KeyCode[d.gp] then e.gp = Enum.KeyCode[d.gp] end
    end
    lk(KB.DropBrainrot, data.dropBrainrotKey)
    lk(KB.AutoLeft, data.autoLeftKey)
    lk(KB.AutoRight, data.autoRightKey)
    lk(KB.AutoBat, data.autoBatKey)
    lk(KB.TPFloor, data.tpFloorKey)
    lk(KB.CarryToggle, data.carryToggleKey)
    lk(KB.AutoCarry, data.autoCarryKey)
    lk(KB.LaggerMode, data.laggerModeKey)
    lk(KB.BatV2, data.batV2Key)
    if data.mobileButtonPositions then savedButtonPositions = data.mobileButtonPositions end
    if data.mobilePanelPos then savedMobilePanelPos = data.mobilePanelPos end
    if data.batV2FloatingPos then batV2FloatingPos = data.batV2FloatingPos end
    if data.progressBarPos then savedProgressBarPos = data.progressBarPos end
    if data.bodyLockEnabled ~= nil then
        bodyLockEnabled = data.bodyLockEnabled
        if bodyLockEnabled then
            task.defer(function()
                if bodyLockSetVisual then bodyLockSetVisual(true) end
                startBodyLock()
            end)
        end
    end
    if data.bodyLockRange then
        bodyLockRange = data.bodyLockRange
        if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    end
    dropMode = data.dropMode or 1
    stretchEnabled = data.stretchEnabled or false
    fovValue = data.fovValue or 70
    fovEnabled = data.fovEnabled or false
    if fovSliderSet then fovSliderSet(fovValue) end
    if fovEnabled then enableCustomFov() end
    if setFovVisual then setFovVisual(fovEnabled) end
    stretchFOV = data.stretchFOV or 120
    BAT_AIMBOT_SPEED = data.batAimbotSpeed or BAT_AIMBOT_SPEED
    backgroundIndex = math.clamp(tonumber(data.backgroundIndex) or 1, 1, #backgroundImages)
    backgroundImageTransparency = data.backgroundImageTransparency or 0
    floatingButtonScale = data.floatingButtonScale or 1
    if data.outfitIndex and data.outfitIndex >= 1 and data.outfitIndex <= #OUTFITS then
        currentOutfitIndex = data.outfitIndex
        task.defer(function()
            pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
            if outfitSelectorLabel then
                outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
            end
        end)
    end

    useCarrySystem = data.useCarrySystem or false
    CarrySystem.normalSpeed = data.carrySysNormal or NS
    CarrySystem.carrySpeed = data.carrySysCarry or CS
    CarrySystem.laggerSpeed = data.carrySysLagger or LAGGER_SPEED
    CarrySystem.laggerCarrySpeed = data.carrySysLaggerCarry or LAGGER_CARRY_SPEED
    CarrySystem.softStealSpeed = data.carrySysSoftStealSpeed or 30
    CarrySystem.softStealRadius = data.carrySysSoftStealRadius or 10
    if useCarrySystem then
        CarrySystem:start()
        CarrySystem.speedToggled = speedMode
        if laggerToggled then
        else
            CarrySystem:setLaggerMode(0)
        end
    else
        CarrySystem:stop()
    end

    autoBatEnabled = false
    autoLeftEnabled = false
    autoRightEnabled = false
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    refreshSpeedModeLabel()
    _lastSavedJSON = HS:JSONEncode(buildConfigTable())
    _isLoading = false
    return true
end

function forceResetUI()
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_CARRY_SPEED) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    if carrySysNormalBox then carrySysNormalBox.Text = tostring(CarrySystem.normalSpeed) end
    if carrySysCarryBox then carrySysCarryBox.Text = tostring(CarrySystem.carrySpeed) end
    if carrySysLaggerBox then carrySysLaggerBox.Text = tostring(CarrySystem.laggerSpeed) end
    if carrySysLaggerCarryBox then carrySysLaggerCarryBox.Text = tostring(CarrySystem.laggerCarrySpeed) end
    if carrySysSoftStealSpeedBox then carrySysSoftStealSpeedBox.Text = tostring(CarrySystem.softStealSpeed) end
    if carrySysSoftStealRadiusBox then carrySysSoftStealRadiusBox.Text = tostring(CarrySystem.softStealRadius) end
    if carrySystemToggleSetter then carrySystemToggleSetter(useCarrySystem) end
    local function safeSet(fn, val) if fn then fn(val) end end
    safeSet(autoBatSetVisual, false)
    safeSet(autoLeftSetVisual, false)
    safeSet(autoRightSetVisual, false)
    safeSet(setBatCounterVisual, false)
    safeSet(setBatCounterV2Visual, false)
    safeSet(setMedusaVisual, false)
    safeSet(setUnwalkVisual, false)
    safeSet(setAntiLagVisual, false)
    safeSet(setLockUIVisual, false)
    safeSet(setEditModeVisual, false)
    safeSet(setInstaGrab, false)
    safeSet(setESPVIsual, false)
    safeSet(bodyLockSetVisual, false)
    safeSet(setNeonWeatherVisual, false)
    safeSet(autoBatV2SetVisual, false)
    safeSet(setAntiDieVisual, false)
    if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    safeSet(mobSetAutoBat, false)
    safeSet(mobSetAutoLeft, false)
    safeSet(mobSetAutoRight, false)
    safeSet(mobSetDropBR, false)
    safeSet(mobSetTpDown, false)
    safeSet(mobSetCarry, false)
    safeSet(mobSetLagger1, false)
    safeSet(mobSetLagger2, false)
    refreshSpeedModeLabel()
    updateProgressBarVisibility()
    disableAntiLag()
    toggleNeonWeather(false)
    skyTheme = "Off"
    pcall(applyCustomSky, "Off")
    if skySelectorLabel then skySelectorLabel.Text = "Off" end
    disableBatV2()
    if antiDieEnabled then
        AntiDieModule.stop()
        antiDieEnabled = false
    end
    if antiFlingEnabled then
        AntiFlingShieldModule.stop()
        antiFlingEnabled = false
    end
    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end
    currentColorTheme = "Gris"
    selectedColor = COLOR_THEMES["Gris"]
    if colorSelectorLabel then
        colorSelectorLabel.Text = "Gris"
        colorSelectorLabel.TextColor3 = selectedColor
    end
    updateAllUIThemeColors(selectedColor)
    if miniBtn then miniBtn.TextColor3 = selectedColor end
    local pGui = LP:FindFirstChild("PlayerGui")
    if pGui then
        local bb = pGui:FindFirstChild("RagCountdownBillboard")
        if bb then
            local lbl = bb:FindFirstChildOfClass("TextLabel")
            if lbl then lbl.TextColor3 = selectedColor end
        end
    end
    if MobilePanel then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        if container then
            local btnContainer = container:FindFirstChild("ButtonsContainer")
            if btnContainer then
                for _, btn in ipairs(btnContainer:GetChildren()) do
                    if btn:IsA("TextButton") then
                        local label = btn:FindFirstChildOfClass("TextLabel")
                        if label then
                            local isActive = btn.BackgroundColor3 == selectedColor
                            if not isActive then label.TextColor3 = selectedColor end
                        end
                    end
                end
            end
        end
    end
    saveAllSettings()
end

function resetFloatingPositions()
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        container.Position = UDim2.new(0, 10, 0, 0)
        savedButtonPositions = {}
        if container:FindFirstChild("ButtonsContainer") then
            for _, btn in ipairs(container.ButtonsContainer:GetChildren()) do
                if btn:IsA("TextButton") and btn.Name then
                    local defX, defY = getDefaultButtonPosition(btn.Name)
                    btn.Position = UDim2.new(0, defX, 0, defY)
                end
            end
        end
    end
    if batV2FloatingButton and batV2FloatingButton:FindFirstChild("Frame") then
        local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
        btnFrame.Position = UDim2.new(0.5, -50, 0, 10)
        batV2FloatingPos = nil
    end
    if pbFrame then
        pbFrame.Position = UDim2.new(0.5, -200, 1, -60)
        savedProgressBarPos = nil
    end
    savedMobilePanelPos = nil
        batV2FloatingPos = nil
end

function resetToFactoryDefaults()
    _isResetting = true
    local ok, err = pcall(function()
        stopAllBackgroundTasks()
        stopAutoSteal()
        stopBatCounter()
        stopBatCounterV2()
        stopMedusaCounter()
        if AntiRagdollV1.isRunning() then AntiRagdollV1.stop() end
        if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
        if antiDieEnabled then AntiDieModule.stop() end
        if antiFlingEnabled then AntiFlingShieldModule.stop() end
        stopUnwalk()
        disableAutoBat()
        disableBatV2()
        stopBodyLock()
        if espEnabled then toggleESP(false) end
        if stretchEnabled then disableStretch() end
        if antiLagEnabled then disableAntiLag() end
        if dropActive then stopDropBrainrot() end
        toggleNeonWeather(false)
        skyTheme = "Off"
        pcall(applyCustomSky, "Off")
        if skySelectorLabel then skySelectorLabel.Text = "Off" end
        if antiDieEnabled then
            AntiDieModule.stop()
            antiDieEnabled = false
        end
        if antiFlingEnabled then
            AntiFlingShieldModule.stop()
            antiFlingEnabled = false
        end
        NS = 60
        CS = 29
        LAGGER_SPEED = 15
        LAGGER_CARRY_SPEED = 24.5
        CONFIG.STEAL_RANGE = 61
        speedMode = false
        laggerToggled = false
        laggerCarryToggled = false
        antiRagdollMode = "off"
        antiDieEnabled = false
        antiFlingEnabled = false
        medusaCounterEnabled = false
        batCounterEnabled = false
        batCounterV2Enabled = false
        autoBatEnabled = false
        autoLeftEnabled = false
        autoRightEnabled = false
        unwalkEnabled = false
        antiLagEnabled = false
        uiLocked = true
        editModeEnabled = false
        CONFIG.AUTO_STEAL_ENABLED = false
        BAT_AIMBOT_SPEED = 58
        dropMode = 1
        stretchEnabled = false
        stretchFOV = 120
        fovValue = 70
        disableCustomFov()
        if fovSliderSet then fovSliderSet(70) end
        if setFovVisual then setFovVisual(false) end
        uiScaleValue = 78
        if mainUIScale then mainUIScale.Scale = 1 end
        if pbScale then pbScale.Scale = 1 end
        espEnabled = false
        bodyLockEnabled = false
        bodyLockRange = 20
        autoBatV2Enabled = false
        backgroundIndex = 1
        backgroundImageTransparency = 0
        floatingButtonScale = 1
        currentAnimPack = "Off"
        stopAnimPack()
        currentOutfitIndex = 1
        currentColorTheme = "Gris"
        selectedColor = COLOR_THEMES["Gris"]
        for key, val in pairs(DEFAULT_KB) do
            if KB[key] then
                KB[key].kb = val.kb
                KB[key].gp = val.gp
            end
        end
        useCarrySystem = false
        CarrySystem:stop()
        CarrySystem.normalSpeed = NS
        CarrySystem.carrySpeed = CS
        CarrySystem.laggerSpeed = LAGGER_SPEED
        CarrySystem.laggerCarrySpeed = LAGGER_CARRY_SPEED
        CarrySystem.softStealSpeed = 30
        CarrySystem.softStealRadius = 10
        CarrySystem.speedToggled = false
        CarrySystem.laggerMode = 0
        CarrySystem.softStealEnabled = false
        if isfile and isfile(CONFIG_FILE) then
            pcall(delfile, CONFIG_FILE)
        end
        resetFloatingPositions()
        forceResetUI()
        updateProgressBarVisibility()
        refreshSpeedModeLabel()
        _lastSavedJSON = nil
        saveAllSettings()
    end)
    _isResetting = false
    if not ok then warn("[resetToFactoryDefaults]", err) end
    return ok
end

function updateProgressBarVisibility()
    if pbFrame then pbFrame.Visible = CONFIG.AUTO_STEAL_ENABLED end
end

function applyShimmerToText(obj, speed)
    speed = speed or 0.8
    local color = getThemeColor()
    local grad = Instance.new("UIGradient", obj)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(200,200,200)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(200,200,200)),
        ColorSequenceKeypoint.new(1, color),
    })
    grad.Rotation = 45
    grad.Offset = Vector2.new(0,0)
    task.spawn(function()
        local t = 0
        while grad and grad.Parent do
            t = t + 0.02
            grad.Offset = Vector2.new(math.sin(t * speed) * 0.4, 0)
            task.wait(0.04)
        end
    end)
    return grad
end

function getDefaultButtonPosition(btnName)
    local BTN_W, BTN_H = 72, 54
    local GAP = 5
    local orderMap = {
        DropBR = 0, AutoLeft = 1, AutoBat = 2, AutoRight = 3,
        TpDown = 4, Carry = 5, Lagger1 = 6, Lagger2 = 7, BatBypass = 8
    }
    local order = orderMap[btnName] or 0
    local row = _floor(order / 3)
    local col = order % 3
    return col * (BTN_W + GAP), row * (BTN_H + GAP)
end

function buildGui()
    local SILVER = Color3.fromRGB(180, 180, 190)
    local SILVER_DARK = Color3.fromRGB(100, 100, 110)
    local SILVER_LIGHT = Color3.fromRGB(220, 220, 230)
    local BG = Color3.fromRGB(0,0,0)
    local BG2 = Color3.fromRGB(10,10,10)
    local ROW_BG = Color3.fromRGB(10,10,10)
    local ROW_BORDER = Color3.fromRGB(50,50,50)
    local WHITE = Color3.fromRGB(255,255,255)
    local GRAY = Color3.fromRGB(60,60,60)
    local INP = Color3.fromRGB(15,15,15)
    local OFF = Color3.fromRGB(25,25,30)
    local TAB_ACTIVE = SILVER
    local TAB_INACT = SILVER_DARK
    local SECT_LBL = SILVER
    local HOV = Color3.fromRGB(25,25,25)
    local DOT_ON = SILVER
    local ON_COLOR = SILVER
    local STROKE_COLOR = Color3.fromRGB(50,50,50)
    local GUI_W, GUI_H = 330, 480

    -- Remove old menu copies and any standalone CLEAN text above the LURK menu.
    -- Remove the CLEAN label/button itself so unrelated ScreenGuis are preserved.
    local function removeOldLurkMenu(container)
        if not container then return end

        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("ScreenGui") and
                (child.Name == "BloodHounds" or child.Name == "LURK HUB"
                    or child.Name == "Clean" or child.Name == "CLEAN") then
                pcall(function() child:Destroy() end)
            end
        end

        -- Sweep all remaining descendants, including labels parented outside a ScreenGui.
        local descendants = {}
        pcall(function() descendants = container:GetDescendants() end)
        for _, d in ipairs(descendants) do
            if d:IsA("TextLabel") or d:IsA("TextButton") then
                local txt = tostring(d.Text or ""):gsub("%s+", ""):upper()
                if txt == "CLEAN" then
                    pcall(function() d:Destroy() end)
                end
            end
        end
    end
    pcall(function() removeOldLurkMenu(game:GetService("CoreGui")) end)
    pcall(function() removeOldLurkMenu(LP:FindFirstChild("PlayerGui")) end)

    gui = Instance.new("ScreenGui")
    gui.Name = "LURK HUB"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local guiOk = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not guiOk then gui.Parent = LP:WaitForChild("PlayerGui") end

    -- Restore Roblox's normal mobile movement controls; do not reposition
    -- the default joystick or replace the game's touch controls.
    task.defer(function()
        pcall(function()
            local playerScripts = LP:WaitForChild("PlayerScripts", 10)
            local playerModule = playerScripts and playerScripts:FindFirstChild("PlayerModule")
            local controlModule = playerModule and playerModule:FindFirstChild("ControlModule")
            if controlModule then
                local controls = require(controlModule)
                if controls and controls.Enable then controls:Enable() end
            end
            local playerGui = LP:FindFirstChildOfClass("PlayerGui")
            local touchGui = playerGui and playerGui:FindFirstChild("TouchGui")
            if touchGui then
                touchGui.Enabled = true
                local touchFrame = touchGui:FindFirstChild("TouchControlFrame", true)
                if touchFrame then touchFrame.Visible = true end
                local thumbstick = touchGui:FindFirstChild("DynamicThumbstickFrame", true)
                if thumbstick then thumbstick.Visible = true end
            end
        end)
    end)

    main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, GUI_W, 0, GUI_H)
    main.Position = UDim2.new(0.5, -GUI_W / 2, 0.5, -GUI_H / 2 + 40)
    -- Keep a solid base behind the background image while dragging.
    -- Transparent parent frames can reveal the default white ScreenGui/canvas during movement.
    main.BackgroundColor3 = BG or Color3.fromRGB(0, 0, 0)
    main.BackgroundTransparency = 0
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)

    local bgImage = Instance.new("ImageLabel", main)
    bgImage.Name = "BackgroundImage"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.Position = UDim2.new(0, 0, 0, 0)
    bgImage.BackgroundTransparency = 1
    backgroundIndex = math.clamp(tonumber(backgroundIndex) or 1, 1, #backgroundImages)
    bgImage.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
    bgImage.ImageTransparency = backgroundImageTransparency
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 1
    bgImage.ClipsDescendants = true
    Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 18)

    mainUIScale = Instance.new("UIScale", main)
    mainUIScale.Scale = uiScaleValue / 100

    local titleBackdrop = Instance.new("Frame", main)
    titleBackdrop.Name = "TitleBackdrop"
    titleBackdrop.Size = UDim2.new(1, 0, 0, 170)
    titleBackdrop.Position = UDim2.new(0, 0, 0, 0)
    titleBackdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    titleBackdrop.BackgroundTransparency = 1
    titleBackdrop.BorderSizePixel = 0
    titleBackdrop.ZIndex = 2

    local titleFrame = Instance.new("Frame", main)
    titleFrame.Size = UDim2.new(1, -60, 0, 58)
    titleFrame.Position = UDim2.new(0, 30, 0, 4)
    titleFrame.BackgroundTransparency = 1
    titleFrame.ZIndex = 20

    local titleLabel = Instance.new("TextLabel", main)
    titleLabel.Name = "LURKTitle"
    titleLabel.ZIndex = 21
    titleLabel.Size = UDim2.new(1, -16, 0, 102)
    titleLabel.Position = UDim2.new(0, 8, 0, -14)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = ""
    titleLabel.Visible = false
    titleLabel.TextColor3 = WHITE
    titleLabel.Font = Enum.Font.Antique
    titleLabel.TextSize = 94
    titleLabel.TextScaled = false
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.TextYAlignment = Enum.TextYAlignment.Center
    -- Removed extra text/UI stroke beneath the LURK title.
    titleLabel.TextStrokeTransparency = 1
    -- Title is display-only; clicks pass through to the transparent drag handle.
    titleLabel.Active = false
    titleLabel.Selectable = false

    -- Allow dragging the menu from its background whenever Lock UI is OFF.
    drag(main)
    local closeBtn = Instance.new("TextButton", main)
    closeBtn.Size = UDim2.new(0, 22, 0, 16)
    closeBtn.Position = UDim2.new(1, -27, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(30,30,35)
    closeBtn.BackgroundTransparency = 0.6
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "CLOSE"
    closeBtn.TextColor3 = WHITE
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 7
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 200
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)

    closeBtn.MouseEnter:Connect(function()
        TS:Create(closeBtn, TweenInfo.new(0.12), {TextColor3 = WHITE, BackgroundColor3 = getThemeColor()}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TS:Create(closeBtn, TweenInfo.new(0.12), {TextColor3 = WHITE, BackgroundColor3 = Color3.fromRGB(30,30,35)}):Play()
    end)

    miniBtn = Instance.new("TextButton", gui)
    miniBtn.Size = UDim2.new(0, 118, 0, 30)
    miniBtn.Position = UDim2.new(0, 16, 0, 58)
    miniBtn.BackgroundColor3 = BG2
    miniBtn.BackgroundTransparency = 1
    miniBtn.BorderSizePixel = 0
    -- Background image for the menu toggle button.
    local miniBtnBg = Instance.new("ImageLabel")
    miniBtnBg.Name = "MenuToggleBackground"
    miniBtnBg.BackgroundTransparency = 1
    miniBtnBg.BorderSizePixel = 0
    miniBtnBg.Size = UDim2.new(1, 0, 1, 0)
    miniBtnBg.Position = UDim2.new(0, 0, 0, 0)
    miniBtnBg.Image = "rbxassetid://122925506389298"
    miniBtnBg.ScaleType = Enum.ScaleType.Crop
    miniBtnBg.ZIndex = miniBtn.ZIndex
    miniBtnBg.Parent = miniBtn
    Instance.new("UICorner", miniBtnBg).CornerRadius = UDim.new(0, 8)
    miniBtn.ZIndex = 21
    miniBtn.Text = "" -- Text removed; keep the image background only.
    miniBtn.TextColor3 = selectedColor
    miniBtn.Font = Enum.Font.GothamBold
    miniBtn.TextSize = 12
    miniBtn.ZIndex = 20
    miniBtn.Visible = false
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 8)

    local slideTween = nil
    local mainOriginalPos = main.Position

    showGui = function()
        if slideTween then slideTween:Cancel() end
        if not main then return end
        main.Visible = true
        miniBtn.Visible = false
        main.Position = UDim2.new(1, -GUI_W - 20, 0.5, -240)
        slideTween = TS:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = mainOriginalPos})
        slideTween:Play()
        slideTween.Completed:Connect(function() slideTween = nil end)
    end

    hideGui = function()
        if slideTween then slideTween:Cancel() end
        if not main or not main.Visible then return end
        local targetPos = UDim2.new(1, -GUI_W - 20, 0.5, -240)
        slideTween = TS:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos})
        slideTween:Play()
        slideTween.Completed:Connect(function()
            main.Visible = false
            miniBtn.Visible = true
            slideTween = nil
        end)
    end

    closeBtn.MouseButton1Click:Connect(hideGui)
    miniBtn.MouseButton1Click:Connect(showGui)

    -- TOP TAB BAR: all tabs fit in one row
    local tabBar = Instance.new("Frame", main)
    tabBar.Name = "TopTabBar"
    tabBar.Size = UDim2.new(1, -16, 0, 38)
    tabBar.Position = UDim2.new(0, 8, 0, 92)
    tabBar.BackgroundTransparency = 1
    tabBar.ZIndex = 10

    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Padding = UDim.new(0, 2)

    local tabContent = Instance.new("Frame", main)
    tabContent.Size = UDim2.new(1, 0, 1, -138)
    tabContent.Position = UDim2.new(0, 0, 0, 132)
    tabContent.BackgroundTransparency = 1
    tabContent.ClipsDescendants = true
    tabContent.ZIndex = 5

    local tabs = {"Speed", "Combat", "Visual", "Config", "Keybinds"}
    tabButtons = {}
    local contentPages = {}

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton", tabBar)
        btn.Size = UDim2.new(0.2, -2, 1, -6)
        btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
        btn.BackgroundTransparency = 0.5
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = TAB_INACT
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.AutoButtonColor = false
        btn.ZIndex = 11
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = ROW_BORDER
        stroke.Thickness = 1

        local page = Instance.new("ScrollingFrame", tabContent)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.Position = UDim2.new(0, 0, 0, 0)
        page.BackgroundColor3 = Color3.fromRGB(5,5,5)
        page.BackgroundTransparency = 0.82
        page.BorderSizePixel = 0
        page.ClipsDescendants = true
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = Color3.fromRGB(30,30,35)
        page.ScrollBarImageTransparency = 0.3
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.ZIndex = 6
        Instance.new("UICorner", page).CornerRadius = UDim.new(0, 16)
        page.Visible = (i == 1)

        local layout = Instance.new("UIListLayout", page)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 6)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local padding = Instance.new("UIPadding", page)
        padding.PaddingLeft = UDim.new(0, 8)
        padding.PaddingRight = UDim.new(0, 8)
        padding.PaddingTop = UDim.new(0, 6)
        padding.PaddingBottom = UDim.new(0, 20)

        contentPages[name] = page

        btn.MouseButton1Click:Connect(function()
            for _, pg in pairs(contentPages) do pg.Visible = false end
            page.Visible = true
            for _, b in ipairs(tabButtons) do
                b.TextColor3 = TAB_INACT
                b.BackgroundColor3 = Color3.fromRGB(0,0,0)
            end
            btn.TextColor3 = getThemeColor()
            btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
        end)

        table.insert(tabButtons, btn)
    end

    if tabButtons[1] then
        tabButtons[1].TextColor3 = getThemeColor()
        tabButtons[1].BackgroundColor3 = Color3.fromRGB(20,20,20)
    end

    local pageCounters = {}

    local function getNextOrder(page)
        if not pageCounters[page] then pageCounters[page] = 0 end
        pageCounters[page] = pageCounters[page] + 1
        return pageCounters[page]
    end

    local function mkSect(page, txt)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, 0, 0, 26)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1, -16, 1, 0)
        l.Position = UDim2.new(0, 8, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt:upper()
        l.TextColor3 = getThemeColor()
        l.Font = Enum.Font.GothamBlack
        l.TextSize = 13
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextStrokeColor3 = Color3.fromRGB(60,60,60)
        l.TextStrokeTransparency = 0.3
        l.ZIndex = 8
        local line = Instance.new("Frame", f)
        line.Size = UDim2.new(1, -24, 0, 1.5)
        line.Position = UDim2.new(0, 12, 1, -4)
        line.BackgroundColor3 = getThemeColor()
        line.BackgroundTransparency = 0.6
        line.BorderSizePixel = 0
        line.ZIndex = 8
        return f
    end

    local function mkRow(page, h)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, -4, 0, h or 38)
        f.BackgroundColor3 = ROW_BG
        f.BackgroundTransparency = 0.7
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        local rowStroke = Instance.new("UIStroke", f)
        rowStroke.Color = ROW_BORDER
        rowStroke.Thickness = 1
        rowStroke.Transparency = 0.5
        f.MouseEnter:Connect(function()
            TS:Create(f, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(28,28,28)}):Play()
        end)
        f.MouseLeave:Connect(function()
            TS:Create(f, TweenInfo.new(0.1), {BackgroundColor3 = ROW_BG}):Play()
        end)
        return f
    end

    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row)
        l.Size = UDim2.new(0.55, 0, 1, 0)
        l.Position = UDim2.new(0, 10, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = WHITE
        l.Font = Enum.Font.GothamBold
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        l.TextStrokeTransparency = 0.5
        l.ZIndex = 8
        return l
    end

    local function mkPill(row, offset)
        local pill = Instance.new("Frame", row)
        pill.Name = "Track"
        pill.Size = UDim2.new(0, 34, 0, 18)
        pill.AnchorPoint = Vector2.new(0.5, 0.5)
        pill.Position = UDim2.new(1, -(offset or 48), 0.5, 0)
        pill.BackgroundColor3 = Color3.fromRGB(255,255,255)
        pill.BackgroundTransparency = 0.2
        pill.BorderSizePixel = 0
        pill.ZIndex = 8
        Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 9)
        local stroke = Instance.new("UIStroke", pill)
        stroke.Color = ROW_BORDER
        stroke.Thickness = 1
        stroke.Transparency = 0.45
        stroke.Name = "PillStroke"

        local dot = Instance.new("Frame", pill)
        dot.Name = "Knob"
        dot.Size = UDim2.new(0, 13, 0, 13)
        dot.AnchorPoint = Vector2.new(0, 0)
        dot.Position = UDim2.new(0, 3, 0.5, -6)
        dot.BackgroundColor3 = Color3.fromRGB(18,18,22)
        dot.BorderSizePixel = 0
        dot.ZIndex = 9
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        local shine = Instance.new("Frame", dot)
        shine.Name = "Shine"
        shine.Size = UDim2.new(1, -4, 0, 4)
        shine.Position = UDim2.new(0, 2, 0, 2)
        shine.BackgroundColor3 = WHITE
        shine.BackgroundTransparency = 0.72
        shine.BorderSizePixel = 0
        shine.ZIndex = 10
        Instance.new("UICorner", shine).CornerRadius = UDim.new(0, 4)

        return pill, dot
    end

    local function animPill(pill, dot, on)
        local stroke = pill:FindFirstChildOfClass("UIStroke")
        local info = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TS:Create(dot, info, {
            Position = on and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
        }):Play()
        TS:Create(pill, info, {
            BackgroundColor3 = on and getThemeColor() or Color3.fromRGB(255,255,255),
            BackgroundTransparency = on and 0 or 0.2,
        }):Play()
        if stroke then
            TS:Create(stroke, info, {
                Color = on and getThemeColor() or ROW_BORDER,
                Transparency = on and 0.2 or 0.45,
                Thickness = 1,
            }):Play()
        end
    end

    local function mkSlider(row, minV, maxV, default, cb)
        local W = 118
        local track = Instance.new("Frame", row)
        track.Size = UDim2.new(0, W, 0, 4)
        track.Position = UDim2.new(1, -(W + 44), 0.5, -2)
        track.BackgroundColor3 = INP
        track.BackgroundTransparency = 0.3
        track.BorderSizePixel = 0
        track.ZIndex = 8
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame", track)
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BackgroundColor3 = getThemeColor()
        fill.BorderSizePixel = 0
        fill.ZIndex = 9
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame", track)
        knob.Size = UDim2.new(0, 13, 0, 13)
        knob.AnchorPoint = Vector2.new(0.5, 0.5)
        knob.Position = UDim2.new(0, 0, 0.5, 0)
        knob.BackgroundColor3 = WHITE
        knob.BorderSizePixel = 0
        knob.ZIndex = 11
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
        local kStroke = Instance.new("UIStroke", knob)
        kStroke.Color = getThemeColor()
        kStroke.Thickness = 2

        local valLabel = Instance.new("TextLabel", row)
        valLabel.Size = UDim2.new(0, 34, 0, 20)
        valLabel.Position = UDim2.new(1, -38, 0.5, -10)
        valLabel.BackgroundTransparency = 1
        valLabel.Text = tostring(default)
        valLabel.TextColor3 = WHITE
        valLabel.Font = Enum.Font.GothamBold
        valLabel.TextSize = 11
        valLabel.TextXAlignment = Enum.TextXAlignment.Right
        valLabel.ZIndex = 9

        local hit = Instance.new("TextButton", row)
        hit.Size = UDim2.new(0, W + 16, 0, 26)
        hit.Position = UDim2.new(1, -(W + 52), 0.5, -13)
        hit.BackgroundTransparency = 1
        hit.Text = ""
        hit.AutoButtonColor = false
        hit.ZIndex = 12

        local current = default

        local function render(a)
            a = _clamp(a, 0, 1)
            fill.Size = UDim2.new(a, 0, 1, 0)
            knob.Position = UDim2.new(a, 0, 0.5, 0)
            fill.BackgroundColor3 = getThemeColor()
            kStroke.Color = getThemeColor()
        end

        local function applyFromX(px)
            local left = track.AbsolutePosition.X
            local width = track.AbsoluteSize.X
            if width <= 0 then width = W end
            if left <= 0 then return end
            local a = (px - left) / width
            a = _clamp(a, 0, 1)
            local v = _floor(minV + (maxV - minV) * a + 0.5)
            current = v
            valLabel.Text = tostring(v)
            render(a)
            if cb then pcall(cb, v) end
        end

        local dragging = false

        hit.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                _isDraggingButton = true
                applyFromX(i.Position.X)
            end
        end)

        hit.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                _isDraggingButton = false
            end
        end)

        UIS.InputChanged:Connect(function(i)
            if not dragging then return end
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                applyFromX(i.Position.X)
            end
        end)

        UIS.InputEnded:Connect(function(i)
            if not dragging then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                _isDraggingButton = false
            end
        end)

        local function setValue(v)
            v = _clamp(tonumber(v) or minV, minV, maxV)
            current = v
            valLabel.Text = tostring(v)
            render((v - minV) / (maxV - minV))
        end

        setValue(default)
        return setValue
    end

    local function mkToggle(page, txt, cb)
        local row = mkRow(page, 38)
        mkLabel(row, txt)
        local pill, dot = mkPill(row, 48)
        local on = false
        local function sv(s) on = s; animPill(pill, dot, s) end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 10
        clk.MouseButton1Click:Connect(function()
            if editModeEnabled and not uiLocked then
                pcall(cb, not on)
            else
                on = not on
                sv(on)
                pcall(cb, on)
            end
        end)
        return sv
    end

    local function mkSelector(parent, default, options, cb)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        local leftStroke = Instance.new("UIStroke", leftBtn)
        leftStroke.Color = ROW_BORDER
        leftStroke.Thickness = 1
        local label = Instance.new("TextLabel", container)
        label.Size = UDim2.new(0, 80, 0, 26)
        label.Position = UDim2.new(0.5, -40, 0.5, -13)
        label.BackgroundTransparency = 1
        label.Text = default
        label.TextColor3 = WHITE
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local rightStroke = Instance.new("UIStroke", rightBtn)
        rightStroke.Color = ROW_BORDER
        rightStroke.Thickness = 1
        local function updateLabel(newText) label.Text = newText end
        leftBtn.MouseButton1Click:Connect(function()
            if cb then cb(-1, updateLabel) end
        end)
        rightBtn.MouseButton1Click:Connect(function()
            if cb then cb(1, updateLabel) end
        end)
        return label
    end

    local function mkBox(parent, default, w, xOff, cb)
        local tb = Instance.new("TextBox", parent)
        local bw = w or 50
        local xo = math.max(xOff or 56, bw + 12)
        tb.Size = UDim2.new(0, bw, 0, 24)
        tb.Position = UDim2.new(1, -xo, 0.5, -12)
        tb.BackgroundColor3 = INP
        tb.BackgroundTransparency = 0.7
        tb.BorderSizePixel = 0
        tb.Text = tostring(default)
        tb.TextColor3 = WHITE
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 11
        tb.ClearTextOnFocus = false
        tb.ZIndex = 8
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)
        local bs = Instance.new("UIStroke", tb)
        bs.Color = ROW_BORDER
        bs.Thickness = 1.2
        bs.Transparency = 0.25
        tb.Focused:Connect(function() TS:Create(bs, TweenInfo.new(0.12), {Color = getThemeColor(), Transparency = 0}):Play() end)
        tb.FocusLost:Connect(function()
            TS:Create(bs, TweenInfo.new(0.12), {Color = ROW_BORDER, Transparency = 0.25}):Play()
            if cb then local n = tonumber(tb.Text); if n then cb(n) else tb.Text = tostring(default) end end
        end)
        return tb
    end

    local function mkKeyButton(parent, kbEntry)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 80, 0, 24)
        btn.Position = UDim2.new(1, -88, 0.5, -12)
        btn.BackgroundColor3 = INP
        btn.BackgroundTransparency = 0.5
        btn.BorderSizePixel = 0
        local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end
        btn.Text = getLabel()
        btn.TextColor3 = WHITE
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 9
        btn.ZIndex = 8
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local bs = Instance.new("UIStroke", btn)
        bs.Color = ROW_BORDER
        bs.Thickness = 1
        local li = false; local lc; local pv = btn.Text; local listenStart = 0
        btn.Activated:Connect(function()
            if li then li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; btn.TextColor3 = WHITE; return end
            pv = btn.Text; li = true; _anyKeyListening = true; listenStart = _tick(); btn.Text = "..."; btn.TextColor3 = WHITE
            lc = UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode == Enum.KeyCode.Escape then li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; btn.TextColor3 = WHITE; return end
                local isGp = isGamepadInput(inp)
                if isGp and _tick()-listenStart < 0.15 then return end
                if not isBindableInput(inp) then return end
                btn.Text = inp.KeyCode.Name; pv = inp.KeyCode.Name; btn.TextColor3 = WHITE
                li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end
                if isGp then kbEntry.gp = inp.KeyCode; kbEntry.kb = nil else kbEntry.kb = inp.KeyCode; kbEntry.gp = nil end
            end)
        end)
        table.insert(keyButtonRefs, {btn = btn, entry = kbEntry})
        return btn
    end

    local function addKeybindRow(page, labelText, kbEntry)
        local row = mkRow(page, 36)
        mkLabel(row, labelText)
        mkKeyButton(row, kbEntry)
    end

    local speedPage = contentPages["Speed"]
    mkSect(speedPage, "Speed Settings")
    do local row = mkRow(speedPage, 38); mkLabel(row, "Normal Speed"); normalBox = mkBox(row, NS, 50, 56, function(v) if v > 0 and v <= 500 then NS = v end end) end
    do local row = mkRow(speedPage, 38); mkLabel(row, "Carry Speed"); carryBox = mkBox(row, CS, 50, 56, function(v) if v > 0 and v <= 500 then CS = v end end) end
    do local row = mkRow(speedPage, 38); mkLabel(row, "Lagger Carry Speed"); laggerBox = mkBox(row, LAGGER_SPEED, 50, 56, function(v) if v > 0 and v <= 500 then LAGGER_SPEED = v end end) end
    do local row = mkRow(speedPage, 38); mkLabel(row, "Lagger Normal Speed"); lagger2Box = mkBox(row, LAGGER_CARRY_SPEED, 50, 56, function(v) if v > 0 and v <= 500 then LAGGER_CARRY_SPEED = v end end) end
    do
        local row = mkRow(speedPage, 38)
        mkLabel(row, "Current Mode")
        modeValLbl = Instance.new("TextLabel", row)
        modeValLbl.Size = UDim2.new(0, 110, 1, 0)
        modeValLbl.Position = UDim2.new(1, -118, 0, 0)
        modeValLbl.BackgroundTransparency = 1
        modeValLbl.Text = "Normal"
        modeValLbl.TextColor3 = WHITE
        modeValLbl.Font = Enum.Font.GothamBlack
        modeValLbl.TextSize = 11
        modeValLbl.TextXAlignment = Enum.TextXAlignment.Right
        modeValLbl.ZIndex = 8
        local clk = Instance.new("TextButton", row)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 8
        clk.MouseButton1Click:Connect(function() toggleCarryMode() end)
    end

    mkSect(speedPage, "Auto Movement")
    autoLeftSetVisual = mkToggle(speedPage, "Auto Left", function(on)
        autoLeftEnabled = on
        if on then startAutoLeft() else stopAutoLeft() end
        if mobSetAutoLeft then mobSetAutoLeft(on) end
    end)
    autoRightSetVisual = mkToggle(speedPage, "Auto Right", function(on)
        autoRightEnabled = on
        if on then startAutoRight() else stopAutoRight() end
        if mobSetAutoRight then mobSetAutoRight(on) end
    end)

    mkSect(speedPage, "TP & Reset")
    do
        local row = mkRow(speedPage, 38)
        mkLabel(row, "TP Down")
        local clk = Instance.new("TextButton", row)
        clk.Size = UDim2.new(0.58, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 8
        clk.MouseButton1Click:Connect(function() doTpDown() end)
        local actLbl = Instance.new("TextLabel", row)
        actLbl.Size = UDim2.new(0, 70, 1, 0)
        actLbl.Position = UDim2.new(1, -78, 0, 0)
        actLbl.BackgroundTransparency = 1
        actLbl.Text = "ACTIVATE"
        actLbl.TextColor3 = getThemeColor()
        actLbl.Font = Enum.Font.GothamBold
        actLbl.TextSize = 9
        actLbl.TextXAlignment = Enum.TextXAlignment.Right
        actLbl.ZIndex = 8
    end

    -- Auto Carry system removed by request.

    local combatPage = contentPages["Combat"]

    mkSect(combatPage, "Anti Ragdoll")
    do
        local row = mkRow(combatPage, 38)
        mkLabel(row, "Anti Ragdoll")
        local selectorBtn = Instance.new("TextButton", row)
        selectorBtn.Size = UDim2.new(0, 100, 1, 0)
        selectorBtn.Position = UDim2.new(1, -108, 0, 0)
        selectorBtn.BackgroundColor3 = Color3.fromRGB(12,12,12)
        selectorBtn.BackgroundTransparency = 0.7
        selectorBtn.BorderSizePixel = 0
        selectorBtn.Text = "Off"
        selectorBtn.TextColor3 = Color3.fromRGB(255,255,255)
        selectorBtn.Font = Enum.Font.GothamBold
        selectorBtn.TextSize = 12
        selectorBtn.AutoButtonColor = false
        selectorBtn.ZIndex = 8
        Instance.new("UICorner", selectorBtn).CornerRadius = UDim.new(0, 6)
        local selStroke = Instance.new("UIStroke", selectorBtn)
        selStroke.Color = Color3.fromRGB(50,50,50)
        selStroke.Thickness = 1

        local dropdown = Instance.new("Frame", combatPage)
        dropdown.Size = UDim2.new(0, 100, 0, 90)
        dropdown.Position = UDim2.new(0, 0, 0, 0)
        dropdown.BackgroundColor3 = Color3.fromRGB(20,20,25)
        dropdown.BackgroundTransparency = 0.9
        dropdown.BorderSizePixel = 0
        dropdown.Visible = false
        dropdown.ZIndex = 20
        Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 8)
        local dropStroke = Instance.new("UIStroke", dropdown)
        dropStroke.Color = Color3.fromRGB(50,50,50)
        dropStroke.Thickness = 1

        local options = {"Off", "V1", "V2"}
        local optionButtons = {}
        for i, opt in ipairs(options) do
            local btn = Instance.new("TextButton", dropdown)
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Position = UDim2.new(0, 0, 0, (i-1)*30)
            btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
            btn.BackgroundTransparency = 0.5
            btn.BorderSizePixel = 0
            btn.Text = opt
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 12
            btn.ZIndex = 21
            btn.AutoButtonColor = false
            btn.MouseButton1Click:Connect(function()
                local mode = opt:lower()
                setAntiRagdollMode(mode)
                dropdown.Visible = false
            end)
            optionButtons[opt] = btn
        end

        selectorBtn.MouseButton1Click:Connect(function()
            if dropdown.Visible then
                dropdown.Visible = false
                return
            end
            local absPos = selectorBtn.AbsolutePosition
            local size = selectorBtn.AbsoluteSize
            dropdown.Position = UDim2.new(0, absPos.X, 0, absPos.Y + size.Y)
            dropdown.Visible = true
        end)

        UIS.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if dropdown.Visible then
                    local mousePos = input.Position
                    local absPos = dropdown.AbsolutePosition
                    local size = dropdown.AbsoluteSize
                    if not (mousePos.X >= absPos.X and mousePos.X <= absPos.X + size.X and
                            mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + size.Y) then
                        dropdown.Visible = false
                    end
                end
            end
        end)

        local function updateAntiRagdollUI(mode)
            local label = mode:gsub("^%l", string.upper)
            if mode == "off" then label = "Off" end
            selectorBtn.Text = label
            for opt, btn in pairs(optionButtons) do
                if opt:lower() == mode then
                    btn.BackgroundColor3 = getThemeColor()
                    btn.TextColor3 = Color3.fromRGB(0,0,0)
                else
                    btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
                    btn.TextColor3 = Color3.fromRGB(255,255,255)
                end
            end
        end

        _G.updateAntiRagdollUI = updateAntiRagdollUI
        updateAntiRagdollUI(antiRagdollMode)
    end

    setUnwalkVisual = mkToggle(combatPage, "Unwalk", function(on)
        unwalkEnabled = on
        if on then startUnwalk() else stopUnwalk() end
    end)

    setAntiDieVisual = mkToggle(combatPage, "Anti Die", function(on)
        antiDieEnabled = on
        if on then AntiDieModule.start() else AntiDieModule.stop() end
        saveAllSettings()
    end)
    if setAntiDieVisual then setAntiDieVisual(antiDieEnabled) end

    mkSect(combatPage, "Drop")
    dropBrainrotSetVisual = mkToggle(combatPage, "Drop Brainrot", function(on)
        if on then
            executeDropWithToggle(function(v)
                dropBrainrotSetVisual(v)
                if mobSetDropBR then mobSetDropBR(v) end
            end)
        end
    end)
    setDropVisual = dropBrainrotSetVisual

    do
        local row = mkRow(combatPage, 38)
        mkLabel(row, "Drop Mode")
        dropModeBtnRef = mkSelector(row, dropMode == 1 and "Fling" or "Jump Drop", {"Fling", "Jump Drop"}, function(dir, update)
            if dropActive then stopDropBrainrot() end
            dropMode = dropMode == 1 and 2 or 1
            update(dropMode == 1 and "Fling" or "Jump Drop")
        end)
    end

    mkSect(combatPage, "Counters")
    setBatCounterVisual = mkToggle(combatPage, "Bat Counter", function(on)
        batCounterEnabled = on
        if on then startBatCounter() else stopBatCounter() end
    end)

    setBatCounterV2Visual = mkToggle(combatPage, "Bat Counter V2", function(on)
        batCounterV2Enabled = on
        if on then startBatCounterV2() else stopBatCounterV2() end
    end)

    setMedusaVisual = mkToggle(combatPage, "Medusa Counter", function(on)
        medusaCounterEnabled = on
        if on then
            if LP.Character then setupMedusaCounter(LP.Character) else stopMedusaCounter() end
        else
            stopMedusaCounter()
        end
        if setMedusaVisual then setMedusaVisual(on) end
    end)

    mkSect(combatPage, "Defense")
    bodyLockSetVisual = mkToggle(combatPage, "Body Lock", function(on)
        bodyLockEnabled = on
        if on then
            if _blSuppressCount == 0 then startBodyLock() end
        else
            stopBodyLock()
        end
    end)
    do
        local row = mkRow(combatPage, 38)
        mkLabel(row, "Body Lock Range")
        bodyLockRangeBox = mkBox(row, bodyLockRange, 50, 56, function(v)
            if v and v > 0 then
                bodyLockRange = _clamp(_floor(v), 5, 200)
                if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
            end
        end)
    end

    mkSect(combatPage, "Aimbots")

    -- The mode selector is removed. Auto Bat and Bat Bypass now have
    -- independent controls, so the selected mode cannot block either button.
    selectedAimbotMode = "Bat Aimbot"
    _stableBatMode = "Bat Aimbot"

    function setStableBatMode(mode)
        -- Kept for compatibility with older saved configurations.
        selectedAimbotMode = "Bat Aimbot"
        _stableBatMode = "Bat Aimbot"
    end

    autoBatSetVisual = mkToggle(combatPage, "Enable Aimbot", function(on)
        if on then
            enableAutoBat()
            if mobSetAutoBat then mobSetAutoBat(true) end
        else
            disableAutoBat()
            if mobSetAutoBat then mobSetAutoBat(false) end
        end
    end)
    if autoBatSetVisual then autoBatSetVisual(autoBatEnabled == true) end

    -- Bat Bypass is controlled by the floating mobile button, not a menu button.
    batBypassSetVisual = function(state) end

    do
        local row = mkRow(combatPage, 38)
        mkLabel(row, "Bat Aimbot Speed")
        batSpeedBox = mkBox(row, BAT_AIMBOT_SPEED, 50, 56, function(v)
            if v and v > 0 and v <= 200 then BAT_AIMBOT_SPEED = v end
        end)
    end

    -- Bat Bypass Speed: kept as a separate, safe input under Bat Aimbot Speed.
    do
        local row = mkRow(combatPage, 38)
        mkLabel(row, "Bat Bypass Speed")
        batBypassSpeedBox = mkBox(row, tonumber(BYPASS_AIMBOT_SPEED) or 60, 50, 56, function(v)
            v = tonumber(v)
            if not v or v < 1 or v > 200 then return end
            BYPASS_AIMBOT_SPEED = v
            -- Update the running controller only when it exists; never let this UI callback error.
            pcall(function()
                if _G.AceAntiBypassAimbotOn and SnowVS and SnowVS.BatBypass and SnowVS.BatBypass.ZCFG then
                    SnowVS.BatBypass.ZCFG.FOLLOW_SPEED = v
                end
            end)
            if type(saveAllSettings) == "function" then pcall(saveAllSettings) end
        end)
    end

-- ============================================================
-- BAT BYPASS / BAT V2 — REPLACEMENT STANDALONE IMPLEMENTATION
-- Uses the supplied pursuit + ping prediction logic, adapted to this UI API.
-- Public API: _G.BatBypass.Start(), .Stop(), .Toggle()
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local LP = Players.LocalPlayer

local CONFIG = {
    FOLLOW_SPEED = 55,
    ACTIVATE_DISTANCE = 13,
    MIN_FOLLOW_DIST = 1,
    PREDICTION_TIME = 0.22,
    PREDICT_AHEAD = 3,
    MAX_VEL_CHANGE = 150,
    VEL_SMOOTHING = 0.2,
    MAX_H_VELOCITY = 80,
    SERVER_TICKRATE = 1 / 60,
    MIN_PING_COMP = 0.03,
    MAX_PING_COMP = 0.25,
    ACCEL_WEIGHT = 0.3,
    DIR_CHANGE_TIME = 0.12,
    QUICK_TURN_MULT = 1.5,
    GRAVITY = 196.2,
    AIR_CONTROL = 0.8,
    MIN_AIRBORNE_TIME = 0.08,
    SWING_COOLDOWN = 0.3,
}
BAT_V2_SPEED = 55
BAT_V2_HIT_DIST = CONFIG.ACTIVATE_DISTANCE
BAT_V2_LEAD_STUDS = CONFIG.PREDICT_AHEAD

local SnowVS = _G.SnowVS or {}
_G.SnowVS = SnowVS
local BB = {
    Enabled = false,
    Connection = nil,
    ZCFG = { FOLLOW_SPEED = 55, ACTIVATE_DISTANCE = 13, MIN_FOLLOW_DISTANCE = 1,
        PREDICTION_TIME = 0.22, PREDICT_AHEAD = 3, MAX_VELOCITY_CHANGE = 150,
        VELOCITY_SMOOTHING = 0.2, MAX_HORIZONTAL_VELOCITY = 80,
        SERVER_TICKRATE = 1 / 60, MIN_PING_COMPENSATION = 0.03,
        MAX_PING_COMPENSATION = 0.25, ACCELERATION_PREDICTION_WEIGHT = 0.3,
        DIRECTION_CHANGE_DETECTION_TIME = 0.12, QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
        GRAVITY = 196.2, AIR_CONTROL_FACTOR = 0.8, MIN_AIRBORNE_TIME = 0.08 },
}
SnowVS.BatBypass = BB
SnowVS.AimbotBypassV2 = BB
_G.BatBypass = BB

local STATE = { target = nil, lastTargetPos = nil, targetVel = Vector3.zero,
    smoothedVel = Vector3.zero, accelHistory = {}, aerialHistory = {}, prevDir = nil,
    lastDirChange = 0, airborneTime = 0, lastSwing = 0, currentPing = 0.1 }

local function avgVec(history)
    if #history == 0 then return Vector3.zero end
    local total = Vector3.zero
    for _, v in ipairs(history) do total += v end
    return total / #history
end
local function pushHistory(history, value, maximum)
    table.insert(history, value)
    if #history > maximum then table.remove(history, 1) end
end
local function samplePing()
    local ok, value = pcall(function()
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if ok and type(value) == "number" then
        STATE.currentPing = math.clamp(value / 1000, CONFIG.MIN_PING_COMP, CONFIG.MAX_PING_COMP)
    end
end
local function findBat()
    local char = LP.Character
    if not char then return nil end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        local n = tool.Name:lower()
        if n:find("bat", 1, true) or n:find("slap", 1, true) then return tool end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, item in ipairs(bp:GetChildren()) do
            if item:IsA("Tool") then
                local n = item.Name:lower()
                if n:find("bat", 1, true) or n:find("slap", 1, true) then return item end
            end
        end
    end
    return nil
end
local function nearestTarget(root)
    local nearest, nearestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tr = plr.Character:FindFirstChild("HumanoidRootPart")
            local th = plr.Character:FindFirstChildOfClass("Humanoid")
            if tr and th and th.Health > 0 then
                local d = (tr.Position - root.Position).Magnitude
                if d < nearestDist then nearest, nearestDist = plr, d end
            end
        end
    end
    return nearest
end
local function rotateRoot(root, direction)
    if direction.Magnitude < 0.01 then return end
    local axis = root.CFrame.LookVector:Cross(direction.Unit)
    local angle = math.asin(math.clamp(axis.Magnitude, -1, 1))
    root.AssemblyAngularVelocity = axis.Magnitude > 0.01 and axis.Unit * angle * 80 or Vector3.zero
end
local function resetTarget()
    STATE.target, STATE.lastTargetPos = nil, nil
    STATE.targetVel, STATE.smoothedVel = Vector3.zero, Vector3.zero
    STATE.accelHistory, STATE.aerialHistory = {}, {}
    STATE.prevDir, STATE.airborneTime = nil, 0
end

if not _G.BatBypassPingLoopStarted then
    _G.BatBypassPingLoopStarted = true
    task.spawn(function()
        while _G.BatBypassLoaded ~= false do
            pcall(samplePing)
            task.wait(0.5)
        end
        _G.BatBypassPingLoopStarted = false
    end)
end
_G.BatBypassLoaded = true

function BB.Start()
    if BB.Connection then return true end
    local char = LP.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root or humanoid.Health <= 0 then
        warn("[BatBypass] No character / humanoid / root.")
        return false
    end
    BB.Enabled = true
    humanoid.AutoRotate = false
    local bat = findBat()
    if bat and bat.Parent ~= char then pcall(function() humanoid:EquipTool(bat) end) end

    BB.Connection = RunService.RenderStepped:Connect(function(dt)
        if not BB.Enabled then BB.Stop(); return end
        local curChar = LP.Character
        local curRoot = curChar and curChar:FindFirstChild("HumanoidRootPart")
        local curHum = curChar and curChar:FindFirstChildOfClass("Humanoid")
        if not curRoot or not curHum or curHum.Health <= 0 then return end
        curHum.AutoRotate = false
        root, humanoid = curRoot, curHum
        bat = curChar:FindFirstChildOfClass("Tool") or findBat()
        if bat and bat.Parent ~= curChar then pcall(function() curHum:EquipTool(bat) end) end

        STATE.target = nearestTarget(root)
        local tChar = STATE.target and STATE.target.Character
        local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
        if not tRoot or not tHum or tHum.Health <= 0 then resetTarget(); curHum:Move(Vector3.zero, false); return end

        local targetPos = tRoot.Position
        local safeDt = math.max(dt, 1 / 240)
        if STATE.lastTargetPos then
            local rawVel = (targetPos - STATE.lastTargetPos) / safeDt
            local delta = rawVel - STATE.targetVel
            if delta.Magnitude > CONFIG.MAX_VEL_CHANGE then rawVel = STATE.targetVel + delta.Unit * CONFIG.MAX_VEL_CHANGE end
            local h = Vector3.new(rawVel.X, 0, rawVel.Z)
            if h.Magnitude > CONFIG.MAX_H_VELOCITY then h = h.Unit * CONFIG.MAX_H_VELOCITY; rawVel = Vector3.new(h.X, rawVel.Y, h.Z) end
            pushHistory(STATE.accelHistory, (rawVel - STATE.targetVel) / safeDt, 4)
            STATE.targetVel = rawVel
            STATE.smoothedVel = STATE.smoothedVel:Lerp(rawVel, CONFIG.VEL_SMOOTHING)
        end
        STATE.lastTargetPos = targetPos
        local airborne = tHum.FloorMaterial == Enum.Material.Air
        STATE.airborneTime = airborne and (STATE.airborneTime + safeDt) or 0
        if airborne and STATE.airborneTime >= CONFIG.MIN_AIRBORNE_TIME then
            pushHistory(STATE.aerialHistory, STATE.targetVel, 6)
        elseif not airborne then STATE.aerialHistory = {} end
        local predVel = STATE.smoothedVel
        if airborne and #STATE.aerialHistory > 0 then
            local aerial = avgVec(STATE.aerialHistory)
            predVel = Vector3.new(aerial.X, STATE.targetVel.Y, aerial.Z) * CONFIG.AIR_CONTROL
        end
        local quickTurn = false
        local hVel = Vector3.new(STATE.targetVel.X, 0, STATE.targetVel.Z)
        if hVel.Magnitude > 5 then
            local dir = hVel.Unit
            if STATE.prevDir and STATE.prevDir:Dot(dir) < 0.5 then
                quickTurn = tick() - STATE.lastDirChange < CONFIG.DIR_CHANGE_TIME
                STATE.lastDirChange = tick()
            end
            STATE.prevDir = dir
        end
        local serverDelay = STATE.currentPing + CONFIG.SERVER_TICKRATE
        if quickTurn then serverDelay *= CONFIG.QUICK_TURN_MULT end
        local predicted = targetPos + predVel * serverDelay
        predicted += avgVec(STATE.accelHistory) * CONFIG.ACCEL_WEIGHT * (serverDelay * serverDelay * 0.5)
        local predTime = CONFIG.PREDICTION_TIME * 1.1
        if airborne then
            predicted += predVel * predTime
            predicted += Vector3.new(0, -0.5 * CONFIG.GRAVITY * predTime * predTime, 0)
        else predicted += predVel * predTime end
        local flatPred = Vector3.new(predVel.X, 0, predVel.Z)
        if flatPred.Magnitude > 1 then predicted += flatPred.Unit * CONFIG.PREDICT_AHEAD end

        local toTarget = predicted - root.Position
        rotateRoot(root, toTarget)
        if (targetPos - root.Position).Magnitude <= CONFIG.ACTIVATE_DISTANCE
            and tick() - STATE.lastSwing >= CONFIG.SWING_COOLDOWN then
            if bat then pcall(function() bat:Activate() end) end
            STATE.lastSwing = tick()
        end

        -- Movement input plus velocity keeps the chase working with Humanoid controllers.
        local flatToTarget = Vector3.new(toTarget.X, 0, toTarget.Z)
        if flatToTarget.Magnitude > CONFIG.MIN_FOLLOW_DIST then
            local moveDir = flatToTarget.Unit
            curHum:Move(moveDir, false)
            root.AssemblyLinearVelocity = Vector3.new(moveDir.X * CONFIG.FOLLOW_SPEED,
                root.AssemblyLinearVelocity.Y, moveDir.Z * CONFIG.FOLLOW_SPEED)
        else
            curHum:Move(Vector3.zero, false)
            root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y * 0.5, 0)
        end
    end)
    print("[BatBypass] STARTED")
    return true
end

function BB.Stop()
    BB.Enabled = false
    if BB.Connection then BB.Connection:Disconnect(); BB.Connection = nil end
    local char = LP.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if humanoid then humanoid.AutoRotate = true; humanoid:Move(Vector3.zero, false) end
    if root then root.AssemblyAngularVelocity = Vector3.zero end
    resetTarget()
    STATE.lastSwing = 0
    print("[BatBypass] STOPPED")
end
function BB.Toggle()
    if BB.Enabled or BB.Connection then BB.Stop() else return BB.Start() end
end
BB.IsRunning = function() return BB.Enabled and BB.Connection ~= nil end
LP.CharacterAdded:Connect(function()
    if BB.Enabled then
        BB.Stop()
        task.wait(0.5)
        BB.Start()
    end
end)
print("[BatBypass] Loaded. Use _G.BatBypass.Toggle() / .Start() / .Stop()")

local function _aceSafeSave()
    if type(saveAllSettings) == "function" then pcall(saveAllSettings) end
end

local function _aceCurrentSpeedMode()
    if laggerCarryToggled then return "Lagger Carry" end
    if laggerToggled      then return "Lagger" end
    if speedMode          then return "Carry"  end
    return "Normal"
end

-- Bat Bypass speed is configurable from the menu.
_G.AceGetAntiBypassAimbotSpeed = function()
    local v = tonumber(BYPASS_AIMBOT_SPEED) or 60
    return math.clamp(v, 1, 200)
end

_G.AceRefreshAimbotVisual = function()
    if _G.AceAimbotSetVisual then
        _G.AceAimbotSetVisual(_G.AceAntiBypassAimbotOn == true)
    end
end

_G.AceStartAntiBypassAimbot = function()
    if _G.AceSafeModeTryStart and not _G.AceSafeModeTryStart() then
        return false
    end
    if _G.AceStopAutoTPForAction then _G.AceStopAutoTPForAction() end
    if _G.AceStopNormalAimbot    then _G.AceStopNormalAimbot()    end

    SnowVS.BatBypass.ZCFG.FOLLOW_SPEED = _G.AceGetAntiBypassAimbotSpeed()
    local started = SnowVS.BatBypass.Start()
    if started == false or not SnowVS.BatBypass.Connection then
        _G.AceAntiBypassAimbotOn = false
        if _G.AceRefreshAimbotVisual then _G.AceRefreshAimbotVisual() end
        return false
    end

    _G.AceAntiBypassAimbotOn = true
    if _G.AceRefreshAimbotVisual then _G.AceRefreshAimbotVisual() end
    _aceSafeSave()
    return true
end

_G.AceStopAntiBypassAimbot = function(keepVisual)
    SnowVS.BatBypass.Stop()
    _G.AceAntiBypassAimbotOn = false
    if keepVisual ~= false and _G.AceRefreshAimbotVisual then
        _G.AceRefreshAimbotVisual()
    end
    _aceSafeSave()
end

_G.AceToggleSelectedAimbot = function()
    if selectedAimbotMode == "Bat Bypass" then
        if _G.AceAntiBypassAimbotOn then
            _G.AceStopAntiBypassAimbot()
        else
            _G.AceStartAntiBypassAimbot()
        end
    elseif selectedAimbotMode == "Bat Aimbot" then
        if autoBatEnabled then
            disableAutoBat()
        else
            enableAutoBat()
        end
    else
        disableAutoBat()
        if _G.AceAntiBypassAimbotOn then
            _G.AceStopAntiBypassAimbot()
        end
    end
    if _G.AceRefreshAimbotVisual then _G.AceRefreshAimbotVisual() end
    _aceSafeSave()
end

_G.AceAntiBypassStart = _G.AceStartAntiBypassAimbot
_G.AceAntiBypassStop  = _G.AceStopAntiBypassAimbot

function enableBatBypass()
    local starter = _G.AceStartAntiBypassAimbot
    if type(starter) ~= "function" then
        if batBypassSetVisual then batBypassSetVisual(false) end
        if mobSetBatBypass then mobSetBatBypass(false) end
        return false
    end

    -- Keep this feature at the requested fixed speed before starting.
    if SnowVS.BatBypass and SnowVS.BatBypass.ZCFG then
        SnowVS.BatBypass.ZCFG.FOLLOW_SPEED = 55
    end
    local ok = starter()
    local enabled = ok ~= false
        and SnowVS.BatBypass ~= nil
        and SnowVS.BatBypass.Connection ~= nil
        and SnowVS.BatBypass.Enabled == true

    _G.AceAntiBypassAimbotOn = enabled
    if batBypassSetVisual then batBypassSetVisual(enabled) end
    if mobSetBatBypass then mobSetBatBypass(enabled) end
    return enabled
end

function disableBatBypass()
    local stopper = _G.AceStopAntiBypassAimbot
    if type(stopper) == "function" then
        stopper()
    elseif SnowVS.BatBypass and SnowVS.BatBypass.Stop then
        SnowVS.BatBypass.Stop()
    end
    _G.AceAntiBypassAimbotOn = false
    if batBypassSetVisual then batBypassSetVisual(false) end
    if mobSetBatBypass then mobSetBatBypass(false) end
    return true
end

function toggleBatBypass()
    local BBState = SnowVS and SnowVS.BatBypass
    local running = _G.AceAntiBypassAimbotOn == true
        or (BBState ~= nil and BBState.Enabled == true and BBState.Connection ~= nil)
    if running then
        return disableBatBypass()
    end
    return enableBatBypass()
end

_G.AceAntiBypassSaveToConfig = function(t)
    t = t or {}
    t.selectedAimbotMode              = _stableBatMode or selectedAimbotMode
    t.ANTI_BYPASS_AIMBOT_SPEED        = _G.AceAntiBypassAimbotSpeed
    t.ANTI_BYPASS_LAGGER_AIMBOT_SPEED = _G.AceAntiBypassLaggerAimbotSpeed
    t.antiBypassAimbotEnabled         = _G.AceAntiBypassAimbotOn == true
    return t
end

_G.AceAntiBypassLoadFromConfig = function(data)
    if type(data) ~= "table" then return end
    -- Legacy selector settings are ignored; the two buttons are independent.
    setStableBatMode("Bat Aimbot")
    _G.AceAntiBypassAimbotSpeed = 55

    if data.ANTI_BYPASS_LAGGER_AIMBOT_SPEED == nil
       or tonumber(data.ANTI_BYPASS_LAGGER_AIMBOT_SPEED) == 58 then
        _G.AceAntiBypassLaggerAimbotSpeed = 40
    else
        _G.AceAntiBypassLaggerAimbotSpeed =
            tonumber(data.ANTI_BYPASS_LAGGER_AIMBOT_SPEED) or 40
    end

    _G.AceAntiBypassAimbotOn = data.antiBypassAimbotEnabled == true
end

    local visualPage = contentPages["Visual"]

    -- Edit Button toggle removed from the Visual menu.
    editModeEnabled = false
    setEditModeVisual = nil

    setLockUIVisual = mkToggle(visualPage, "Lock UI", function(on)
        toggleLockUI(on)
        if on and editModeEnabled then
            editModeEnabled = false
            if setEditModeVisual then setEditModeVisual(false) end
        end
    end)

    do
        -- Background thumbnail picker: horizontal cards like the reference image.
        local row = mkRow(visualPage, 72)
        mkLabel(row, "Background")

        local picker = Instance.new("ScrollingFrame", row)
        picker.Name = "BackgroundThumbnailPicker"
        picker.Size = UDim2.new(0, 198, 1, -12)
        picker.Position = UDim2.new(1, -206, 0, 6)
        picker.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        picker.BackgroundTransparency = 0.35
        picker.BorderSizePixel = 0
        picker.ScrollBarThickness = 3
        picker.ScrollBarImageColor3 = WHITE
        picker.ScrollingDirection = Enum.ScrollingDirection.X
        picker.CanvasSize = UDim2.new(0, 0, 0, 0)
        picker.AutomaticCanvasSize = Enum.AutomaticSize.X
        picker.ZIndex = 8
        Instance.new("UICorner", picker).CornerRadius = UDim.new(0, 9)

        local pickerPadding = Instance.new("UIPadding", picker)
        pickerPadding.PaddingLeft = UDim.new(0, 4)
        pickerPadding.PaddingRight = UDim.new(0, 4)
        pickerPadding.PaddingTop = UDim.new(0, 4)
        pickerPadding.PaddingBottom = UDim.new(0, 4)

        local pickerLayout = Instance.new("UIListLayout", picker)
        pickerLayout.FillDirection = Enum.FillDirection.Horizontal
        pickerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        pickerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        pickerLayout.Padding = UDim.new(0, 4)

        local backgroundCards = {}

        local function refreshBackgroundCards()
            for i, card in ipairs(backgroundCards) do
                local stroke = card:FindFirstChild("SelectionStroke")
                if stroke then
                    stroke.Color = (i == backgroundIndex) and WHITE or Color3.fromRGB(45,45,45)
                    stroke.Thickness = (i == backgroundIndex) and 2 or 1
                    stroke.Transparency = (i == backgroundIndex) and 0 or 0.35
                end
            end
        end

        local function selectBackground(index)
            if not backgroundImages[index] then return end
            backgroundIndex = index

            local bgImg = main:FindFirstChild("BackgroundImage")
            if bgImg then
                bgImg.Image = "rbxassetid://" .. backgroundImages[index]
                bgImg.ImageTransparency = backgroundImageTransparency
            end

            refreshBackgroundCards()
            pcall(saveAllSettings)
        end

        for i, imageId in ipairs(backgroundImages) do
            local card = Instance.new("ImageButton", picker)
            card.Name = "Background" .. i
            card.Size = UDim2.new(0, 64, 0, 56)
            card.BackgroundColor3 = Color3.fromRGB(8,8,8)
            card.BackgroundTransparency = 0.05
            card.BorderSizePixel = 0
            card.Image = "rbxassetid://" .. imageId
            card.ScaleType = Enum.ScaleType.Crop
            card.AutoButtonColor = false
            card.Activated:Connect(function() selectBackground(i) end)
            card.ZIndex = 9
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 7)

            local stroke = Instance.new("UIStroke", card)
            stroke.Name = "SelectionStroke"
            stroke.Color = Color3.fromRGB(45,45,45)
            stroke.Thickness = 1
            stroke.Transparency = 0.35

            local shade = Instance.new("Frame", card)
            shade.Name = "LabelShade"
            shade.Size = UDim2.new(1, 0, 0, 17)
            shade.Position = UDim2.new(0, 0, 1, -17)
            shade.BackgroundColor3 = Color3.fromRGB(0,0,0)
            shade.BackgroundTransparency = 0.2
            shade.BorderSizePixel = 0
            shade.ZIndex = 10

            local label = Instance.new("TextLabel", shade)
            label.Size = UDim2.new(1, -4, 1, 0)
            label.Position = UDim2.new(0, 2, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = "BACKGROUND " .. i
            label.TextColor3 = WHITE
            label.Font = Enum.Font.GothamBold
            label.TextSize = 7
            label.TextScaled = false
            label.TextXAlignment = Enum.TextXAlignment.Center
            label.TextYAlignment = Enum.TextYAlignment.Center
            label.ZIndex = 11

            card.MouseButton1Click:Connect(function()
                selectBackground(i)
            end)

            backgroundCards[i] = card
        end

        refreshBackgroundCards()
    end

    do
        -- Avatar picker: use the exact user-supplied avatar pictures.
        -- The PNGs are embedded into this script and written locally at runtime,
        -- so the selector does not depend on Roblox image asset IDs.
        local row = mkRow(visualPage, 146)
        mkLabel(row, "Avatar")

        local scroll = Instance.new("ScrollingFrame", row)
        scroll.Name = "AvatarThumbnailPicker"
        scroll.Size = UDim2.new(1, -10, 0, 120)
        scroll.Position = UDim2.new(0, 5, 0, 22)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 3
        scroll.ScrollBarImageColor3 = WHITE
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.X
        scroll.ScrollingDirection = Enum.ScrollingDirection.X
        scroll.Active = true
        scroll.ZIndex = 8

        local layout = Instance.new("UIListLayout", scroll)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.Padding = UDim.new(0, 7)

        local pad = Instance.new("UIPadding", scroll)
        pad.PaddingLeft = UDim.new(0, 2)
        pad.PaddingRight = UDim.new(0, 2)

        local avatarCards = {}

        local avatarImageData = {
            ["Avatar1"] = "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",
            ["Avatar2"] = "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",
            ["Avatar3"] = "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",
        }

        local function getLocalAvatarAsset(key)
            local b64data = avatarImageData[key]
            if not b64data or b64data == "" then return nil end

            local fileName = "LURK_HUB_" .. key .. ".png"
            -- Decode the embedded PNG before writing it. Executors commonly
            -- expose one of these base64 decoders.
            local decoded = nil
            local okDecode = false
            if type(crypt) == "table" and type(crypt.base64decode) == "function" then
                okDecode, decoded = pcall(function() return crypt.base64decode(b64data) end)
            elseif type(syn) == "table" and type(syn.crypt) == "table" and type(syn.crypt.base64decode) == "function" then
                okDecode, decoded = pcall(function() return syn.crypt.base64decode(b64data) end)
            elseif type(base64decode) == "function" then
                okDecode, decoded = pcall(function() return base64decode(b64data) end)
            end

            if not okDecode or type(decoded) ~= "string" then
                return nil
            end

            local okWrite = pcall(function() writefile(fileName, decoded) end)
            if not okWrite then
                return nil
            end

            local getter = getcustomasset or getsynasset
            if type(getter) == "function" then
                local ok, asset = pcall(function() return getter(fileName) end)
                if ok and asset then return asset end
            end
            return nil
        end

        local avatarAssetCache = {}
        for i = 1, 3 do
            avatarAssetCache[i] = getLocalAvatarAsset("Avatar" .. tostring(i))
        end

        local function refreshAvatarCards()
            for i, card in ipairs(avatarCards) do
                local selected = (i == currentOutfitIndex)
                local stroke = card:FindFirstChild("SelectionStroke")
                if stroke then
                    stroke.Color = selected and WHITE or ROW_BORDER
                    stroke.Thickness = selected and 2 or 1
                    stroke.Transparency = selected and 0 or 0.35
                end
            end
        end

        for i, outfit in ipairs(OUTFITS) do
            local card = Instance.new("ImageButton", scroll)
            card.Name = "AvatarCard_" .. i
            card.Size = UDim2.new(0, 104, 0, 112)
            card.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            card.BackgroundTransparency = 0.02
            card.BorderSizePixel = 0
            card.AutoButtonColor = false
            card.Image = ""
            card.ZIndex = 9

            local corner = Instance.new("UICorner", card)
            corner.CornerRadius = UDim.new(0, 8)

            local stroke = Instance.new("UIStroke", card)
            stroke.Name = "SelectionStroke"
            stroke.Color = ROW_BORDER
            stroke.Thickness = 1
            stroke.Transparency = 0.35

            local avatarImage = Instance.new("ImageLabel", card)
            avatarImage.Name = "AvatarPicture"
            avatarImage.Size = UDim2.new(1, -8, 1, -30)
            avatarImage.Position = UDim2.new(0, 4, 0, 3)
            avatarImage.BackgroundTransparency = 1
            avatarImage.BorderSizePixel = 0
            avatarImage.ScaleType = Enum.ScaleType.Fit
            avatarImage.Image = avatarAssetCache[i] or ""
            avatarImage.ImageTransparency = avatarAssetCache[i] and 0 or 1
            avatarImage.ZIndex = 10

            local label = Instance.new("TextLabel", card)
            label.Size = UDim2.new(1, -6, 0, 20)
            label.Position = UDim2.new(0, 3, 1, -22)
            label.BackgroundTransparency = 1
            label.Text = "AVATAR " .. tostring(i)
            label.TextColor3 = WHITE
            label.Font = Enum.Font.GothamBold
            label.TextSize = 10
            label.TextXAlignment = Enum.TextXAlignment.Center
            label.ZIndex = 11

            avatarCards[i] = card

            card.MouseButton1Click:Connect(function()
                currentOutfitIndex = i
                pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
                if outfitSelectorLabel then
                    outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
                end
                refreshAvatarCards()
                saveAllSettings()
            end)
        end

        refreshAvatarCards()
    end


    do
        local row = mkRow(visualPage, 38)
        mkLabel(row, "Anim Pack")
        local currentIndex = 1
        for i, entry in ipairs(ANIM_PACK_ORDER) do
            if entry[2] == currentAnimPack then currentIndex = i; break end
        end
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        local leftStroke = Instance.new("UIStroke", leftBtn)
        leftStroke.Color = ROW_BORDER
        leftStroke.Thickness = 1
        animSelectorLabel = Instance.new("TextLabel", container)
        animSelectorLabel.Size = UDim2.new(0, 80, 0, 26)
        animSelectorLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
        animSelectorLabel.BackgroundTransparency = 1
        animSelectorLabel.Text = ANIM_PACK_ORDER[currentIndex][2]
        animSelectorLabel.TextColor3 = WHITE
        animSelectorLabel.Font = Enum.Font.GothamBold
        animSelectorLabel.TextSize = 12
        animSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        animSelectorLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local rightStroke = Instance.new("UIStroke", rightBtn)
        rightStroke.Color = ROW_BORDER
        rightStroke.Thickness = 1
        local function updateAnimSelector(direction)
            local idx = 1
            for i, entry in ipairs(ANIM_PACK_ORDER) do
                if entry[2] == currentAnimPack then idx = i; break end
            end
            local newIdx = idx + direction
            if newIdx < 1 then newIdx = #ANIM_PACK_ORDER end
            if newIdx > #ANIM_PACK_ORDER then newIdx = 1 end
            local packName = ANIM_PACK_ORDER[newIdx][2]
            if packName == "Off" then
                stopAnimPack()
            else
                startAnimPack(packName)
            end
        end
        leftBtn.MouseButton1Click:Connect(function() updateAnimSelector(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateAnimSelector(1) end)
    end

    setESPVIsual = mkToggle(visualPage, "Player ESP", function(on) toggleESP(on) end)

    do
        local row = mkRow(visualPage, 38)
        mkLabel(row, "Stretch Rez")
        local stretchPill, stretchDot = mkPill(row, 48)
        local stretchOn = false
        local function setStretch(s)
            stretchOn = s
            animPill(stretchPill, stretchDot, s)
            if s then enableStretch() else disableStretch() end
            stretchEnabled = s
        end
        local stretchClk = Instance.new("TextButton", stretchPill)
        stretchClk.Size = UDim2.new(1,0,1,0)
        stretchClk.BackgroundTransparency = 1
        stretchClk.Text = ""
        stretchClk.AutoButtonColor = false
        stretchClk.ZIndex = 10
        stretchClk.MouseButton1Click:Connect(function() setStretch(not stretchOn) end)
        _G.stretchToggleSetter = setStretch
    end

    setFovVisual = mkToggle(visualPage, "FOV", function(on)
        if on then enableCustomFov() else disableCustomFov() end
    end)
    if setFovVisual then setFovVisual(fovEnabled) end

    do
        local row = mkRow(visualPage, 38)
        mkLabel(row, "FOV Value")
        fovSliderSet = mkSlider(row, 20, 120, fovValue, function(v)
            fovValue = v
            if not fovEnabled then
                enableCustomFov()
                if setFovVisual then setFovVisual(true) end
            end
            local cam = workspace.CurrentCamera
            if cam then pcall(function() cam.FieldOfView = fovValue end) end
        end)
    end

    setAntiLagVisual = mkToggle(visualPage, "Anti Lag", function(on)
        if on then enableAntiLag() else disableAntiLag() end
    end)

    do
        local row = mkRow(visualPage, 38)
        mkLabel(row, "Sky Theme")
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        local leftStroke = Instance.new("UIStroke", leftBtn)
        leftStroke.Color = ROW_BORDER
        leftStroke.Thickness = 1
        skySelectorLabel = Instance.new("TextLabel", container)
        skySelectorLabel.Size = UDim2.new(0, 96, 0, 26)
        skySelectorLabel.Position = UDim2.new(0.5, -48, 0.5, -13)
        skySelectorLabel.BackgroundTransparency = 1
        skySelectorLabel.Text = skyTheme
        skySelectorLabel.TextColor3 = WHITE
        skySelectorLabel.Font = Enum.Font.GothamBold
        skySelectorLabel.TextSize = 11
        skySelectorLabel.TextScaled = false
        skySelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        skySelectorLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local rightStroke = Instance.new("UIStroke", rightBtn)
        rightStroke.Color = ROW_BORDER
        rightStroke.Thickness = 1
        local function updateSkySelector(direction)
            local idx = 1
            for i, name in ipairs(SKY_PRESETS_LIST) do
                if name == skyTheme then idx = i; break end
            end
            local newIdx = idx + direction
            if newIdx < 1 then newIdx = #SKY_PRESETS_LIST end
            if newIdx > #SKY_PRESETS_LIST then newIdx = 1 end
            local name = SKY_PRESETS_LIST[newIdx]
            skyTheme = name
            pcall(applyCustomSky, name)
            if skySelectorLabel then skySelectorLabel.Text = name end
            pcall(saveAllSettings)
        end
        leftBtn.MouseButton1Click:Connect(function() updateSkySelector(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateSkySelector(1) end)
    end


    do
        local row = mkRow(visualPage, 38)
        mkLabel(row, "Bg Opacity")
        local box = mkBox(row, _floor(backgroundImageTransparency * 100), 50, 56, function(v)
            local val = _clamp(v, 0, 100)
            backgroundImageTransparency = val / 100
            local bgImg = main:FindFirstChild("BackgroundImage")
            if bgImg then bgImg.ImageTransparency = backgroundImageTransparency end
            saveAllSettings()
        end)
    end

    local configPage = contentPages["Config"]

    mkSect(configPage, "Auto Steal")
    setInstaGrab = mkToggle(configPage, "Auto Steal", function(on)
        CONFIG.AUTO_STEAL_ENABLED = on
        if on then pcall(startAutoSteal) else stopAutoSteal() end
        updateProgressBarVisibility()
    end)

    do
        local row = mkRow(configPage, 38)
        mkLabel(row, "Steal Radius")
        radInput = mkBox(row, CONFIG.STEAL_RANGE, 50, 56, function(v)
            if v and v >= 5 and v <= 300 then
                CONFIG.STEAL_RANGE = _floor(v+0.5)
                Steal.StealRadius = CONFIG.STEAL_RANGE
                radInput.Text = tostring(CONFIG.STEAL_RANGE)
                saveAllSettings()
            end
        end)
    end

    mkSect(configPage, "UI Settings")
    do
        local row = mkRow(configPage, 38)
        mkLabel(row, "UI Scale")
        uiScaleBox = mkBox(row, uiScaleValue, 50, 56, function(v)
            local n = _clamp(_floor(v+0.5), 50, 150)
            uiScaleValue = n
            if mainUIScale then mainUIScale.Scale = n/100 end
            if pbScale then pbScale.Scale = n/100 end
        end)
    end

    do
        local row = mkRow(configPage, 38)
        mkLabel(row, "Float Scale")
        local box = mkBox(row, _floor(floatingButtonScale * 100), 50, 56, function(v)
            local val = _clamp(v, 50, 200)
            floatingButtonScale = val / 100
            applyFloatingButtonScale()
            saveAllSettings()
        end)
    end

    mkSect(configPage, "Config Management")
    do
        local row = mkRow(configPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local saveBtn = Instance.new("TextButton", row)
        saveBtn.Size = UDim2.new(1, -12, 0.8, 0)
        saveBtn.Position = UDim2.new(0, 6, 0.1, 0)
        saveBtn.BackgroundColor3 = Color3.fromRGB(30,30,35)
        saveBtn.BackgroundTransparency = 0.5
        saveBtn.BorderSizePixel = 0
        saveBtn.Text = "SAVE CONFIG"
        saveBtn.TextColor3 = WHITE
        saveBtn.Font = Enum.Font.GothamBold
        saveBtn.TextSize = 13
        saveBtn.TextStrokeColor3 = Color3.fromRGB(60,60,60)
        saveBtn.TextStrokeTransparency = 0
        saveBtn.AutoButtonColor = false
        saveBtn.ZIndex = 8
        Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 8)
        local saveStroke = Instance.new("UIStroke", saveBtn)
        saveStroke.Color = ROW_BORDER
        saveStroke.Thickness = 1.2
        saveStroke.Transparency = 0.5
        saveBtn.MouseButton1Click:Connect(function()
            local ok = saveAllSettings()
            saveBtn.Text = ok and "SAVED" or "ERROR"
            task.delay(1.2, function()
                if saveBtn and saveBtn.Parent then saveBtn.Text = "SAVE CONFIG" end
            end)
        end)
    end

    do
        local row = mkRow(configPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local resetPosBtn = Instance.new("TextButton", row)
        resetPosBtn.Size = UDim2.new(1, -12, 0.8, 0)
        resetPosBtn.Position = UDim2.new(0, 6, 0.1, 0)
        resetPosBtn.BackgroundColor3 = Color3.fromRGB(30,30,35)
        resetPosBtn.BackgroundTransparency = 0.5
        resetPosBtn.BorderSizePixel = 0
        resetPosBtn.Text = "RESET POSITIONS"
        resetPosBtn.TextColor3 = WHITE
        resetPosBtn.Font = Enum.Font.GothamBold
        resetPosBtn.TextSize = 13
        resetPosBtn.TextStrokeColor3 = Color3.fromRGB(60,60,60)
        resetPosBtn.TextStrokeTransparency = 0
        resetPosBtn.AutoButtonColor = false
        resetPosBtn.ZIndex = 8
        Instance.new("UICorner", resetPosBtn).CornerRadius = UDim.new(0, 8)
        local resetStroke = Instance.new("UIStroke", resetPosBtn)
        resetStroke.Color = ROW_BORDER
        resetStroke.Thickness = 1.2
        resetStroke.Transparency = 0.5
        local resetDebounce = false
        resetPosBtn.MouseButton1Click:Connect(function()
            if resetDebounce then return end
            resetDebounce = true
            resetFloatingPositions()
            resetPosBtn.Text = "RESET"
            task.delay(1.2, function()
                if resetPosBtn and resetPosBtn.Parent then
                    resetPosBtn.Text = "RESET POSITIONS"
                    resetDebounce = false
                end
            end)
        end)
    end

    do
        local row = mkRow(configPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local delBtn = Instance.new("TextButton", row)
        delBtn.Size = UDim2.new(1, -12, 0.8, 0)
        delBtn.Position = UDim2.new(0, 6, 0.1, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        delBtn.BackgroundTransparency = 0.5
        delBtn.BorderSizePixel = 0
        delBtn.Text = "DELETE SETTINGS"
        delBtn.TextColor3 = WHITE
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 13
        delBtn.TextStrokeColor3 = Color3.fromRGB(60,60,60)
        delBtn.TextStrokeTransparency = 0
        delBtn.AutoButtonColor = false
        delBtn.ZIndex = 8
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 8)
        local delStroke = Instance.new("UIStroke", delBtn)
        delStroke.Color = ROW_BORDER
        delStroke.Thickness = 1.2
        delStroke.Transparency = 0.5
        local deleteState = 0
        local originalDeleteText = "DELETE SETTINGS"
        local delDebounce = false
        delBtn.MouseButton1Click:Connect(function()
            if delDebounce then return end
            if deleteState == 0 then
                deleteState = 1
                delBtn.Text = "CONFIRM?"
                delBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                task.delay(2, function()
                    if delBtn and delBtn.Parent and deleteState == 1 then
                        deleteState = 0
                        delBtn.Text = originalDeleteText
                        delBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    end
                end)
            elseif deleteState == 1 then
                delDebounce = true
                local success = pcall(resetToFactoryDefaults)
                delBtn.Text = success and "DELETED" or "ERROR"
                delBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                deleteState = 0
                task.delay(1.5, function()
                    if delBtn and delBtn.Parent then
                        delBtn.Text = originalDeleteText
                        delBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        delDebounce = false
                    end
                end)
            end
        end)
    end

    local keyPage = contentPages["Keybinds"]
    mkSect(keyPage, "Keybinds")
    addKeybindRow(keyPage, "Carry Mode", KB.CarryToggle)
    addKeybindRow(keyPage, "Lagger Mode", KB.LaggerMode)
    addKeybindRow(keyPage, "Auto Left", KB.AutoLeft)
    addKeybindRow(keyPage, "Auto Right", KB.AutoRight)
    addKeybindRow(keyPage, "Auto Bat", KB.AutoBat)
    addKeybindRow(keyPage, "TP Down", KB.TPFloor)
    addKeybindRow(keyPage, "Drop Brainrot", KB.DropBrainrot)
    addKeybindRow(keyPage, "Hide GUI", KB.GuiHide)

    local spacer = Instance.new("Frame", keyPage)
    spacer.Size = UDim2.new(1, 0, 0, 16)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = getNextOrder(keyPage)
    spacer.ZIndex = 7

    -- ============================================================
    -- STEAL BAR — black rounded shell, white stats, green progress.
    -- ============================================================
    pbFrame = Instance.new("Frame", gui)
    pbFrame.Size = UDim2.new(0, 340, 0, 50)
    pbFrame.Position = UDim2.new(0.5, -170, 1, -60)
    pbFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    pbFrame.BackgroundTransparency = 0
    pbFrame.BorderSizePixel = 0
    pbFrame.Active = true
    pbFrame.ClipsDescendants = true
    pbFrame.Visible = CONFIG.AUTO_STEAL_ENABLED
    pbFrame.ZIndex = 10

    pbScale = Instance.new("UIScale", pbFrame)
    pbScale.Scale = uiScaleValue / 100
    if savedProgressBarPos then
        pbFrame.Position = UDim2.new(
            savedProgressBarPos.XScale or 0.5,
            savedProgressBarPos.XOffset or -170,
            savedProgressBarPos.YScale or 1,
            savedProgressBarPos.YOffset or -60
        )
    end

    Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 16)

    local function makePBLabel(parent, size, pos, txt, fontSize, align)
        local l = Instance.new("TextLabel", parent)
        l.Size = size
        l.Position = pos
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = Color3.fromRGB(235, 235, 235)
        l.Font = Enum.Font.GothamBold
        l.TextSize = fontSize
        l.TextXAlignment = align or Enum.TextXAlignment.Left
        l.TextYAlignment = Enum.TextYAlignment.Center
        l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        l.TextStrokeTransparency = 0.35
        l.ZIndex = 14
        return l
    end

    progressPct = makePBLabel(pbFrame, UDim2.new(0, 50, 0, 18), UDim2.new(0, 12, 0, 3),
        "0%", 14, Enum.TextXAlignment.Left)
    progressPct.Font = Enum.Font.GothamBlack

    pbFpsLbl = makePBLabel(pbFrame, UDim2.new(0, 70, 0, 15), UDim2.new(0, 13, 0, 17),
        "FPS: 60", 9, Enum.TextXAlignment.Left)
    pbRadiusLbl = makePBLabel(pbFrame, UDim2.new(0, 135, 0, 15), UDim2.new(0.5, -67, 0, 17),
        "SEMI 61 RADIUS", 10, Enum.TextXAlignment.Center)
    pbPingLbl = makePBLabel(pbFrame, UDim2.new(0, 85, 0, 15), UDim2.new(1, -98, 0, 17),
        "PING: 0ms", 9, Enum.TextXAlignment.Right)

    local fillRegion = Instance.new("Frame", pbFrame)
    fillRegion.Size = UDim2.new(1, -24, 0, 10)
    fillRegion.Position = UDim2.new(0, 12, 1, -16)
    fillRegion.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
    fillRegion.BackgroundTransparency = 0
    fillRegion.BorderSizePixel = 0
    fillRegion.ClipsDescendants = true
    fillRegion.ZIndex = 11
    Instance.new("UICorner", fillRegion).CornerRadius = UDim.new(1, 0)

    local fillRegStroke = Instance.new("UIStroke", fillRegion)
    fillRegStroke.Color = Color3.fromRGB(35, 35, 40)
    fillRegStroke.Thickness = 1
    fillRegStroke.Transparency = 0.2

    progressFill = Instance.new("Frame", fillRegion)
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.Position = UDim2.new(0, 0, 0, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(45, 235, 75)
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 12
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)

    local glow = Instance.new("Frame", progressFill)
    glow.Size = UDim2.new(1, 0, 1, 0)
    glow.Position = UDim2.new(0, 0, 0, 0)
    glow.BackgroundColor3 = Color3.fromRGB(120, 255, 140)
    glow.BackgroundTransparency = 0.72
    glow.BorderSizePixel = 0
    glow.ZIndex = 13
    Instance.new("UICorner", glow).CornerRadius = UDim.new(1, 0)

    -- Compatibility alias used by older progress logic.
    progressRadLbl = pbFpsLbl

    drag(pbFrame)
    task.spawn(function()
        local lastFrame = tick()
        local fpsSamples = {}
        local fpsAvg = 60
        RunService.RenderStepped:Connect(function()
            local now = tick()
            local dt = now - lastFrame
            lastFrame = now
            if dt > 0 then
                table.insert(fpsSamples, 1 / dt)
                if #fpsSamples > 30 then table.remove(fpsSamples, 1) end
                local sum = 0
                for _, v in ipairs(fpsSamples) do sum = sum + v end
                fpsAvg = sum / #fpsSamples
            end
        end)
        while pbFrame and pbFrame.Parent do
            local ping = 0
            pcall(function() ping = LP:GetNetworkPing() * 1000 end)
            if pbFpsLbl then pbFpsLbl.Text = string.format("FPS: %d", math.floor(fpsAvg + 0.5)) end
            if pbPingLbl then pbPingLbl.Text = string.format("PING: %dms", math.floor(ping + 0.5)) end
            if pbRadiusLbl then pbRadiusLbl.Text = string.format("SEMI %d RADIUS", math.floor(tonumber(CONFIG.STEAL_RANGE) or 61)) end
            task.wait(0.5)
        end
    end)
end

function createMobilePanel()
    -- Remove stale floating panels/buttons left behind by earlier script executions.
    -- The Bat Bypass control should exist only inside the main menu, not as a floating button.
    local cleanupRoots = {}
    pcall(function() table.insert(cleanupRoots, game:GetService("CoreGui")) end)
    pcall(function() table.insert(cleanupRoots, LP:FindFirstChildOfClass("PlayerGui")) end)
    local staleGuiNames = {
        BloodHoundsMobilePanel = true,
        BatV2FloatingButton = true,
        AntiBypassFloatingButton = true,
    }
    for _, root in ipairs(cleanupRoots) do
        if root then
            for _, child in ipairs(root:GetChildren()) do
                if child:IsA("ScreenGui") and staleGuiNames[child.Name] then
                    pcall(function() child:Destroy() end)
                end
            end
        end
    end

    local panel = Instance.new("ScreenGui")
    panel.Name = "BloodHoundsMobilePanel"
    panel.ResetOnSpawn = false
    -- Keep the floating panel below Roblox TouchGui so the native Jump button stays tappable.
    panel.DisplayOrder = 1
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end

    local BTN_W, BTN_H = 72, 54
    local GAP = 5
    local COLUMNS = 3
    local ROWS = 3
    local PANEL_W = BTN_W * COLUMNS + GAP * (COLUMNS - 1)
    local PANEL_H = BTN_H * ROWS + GAP * (ROWS - 1)

    local container = Instance.new("Frame", panel)
    container.Name = "FloatingPanel"
    container.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
    container.Position = UDim2.new(0, 10, 0, 0)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    -- Keep the transparent layout frame from intercepting taps meant for Roblox mobile controls (including Jump).
    container.Active = false
    container.Selectable = false
    -- Lock UI ON prevents movement; when OFF the panel can be dragged from its frame.
    drag(container)
    container.ClipsDescendants = false

    local containerScale = Instance.new("UIScale", container)
    containerScale.Scale = floatingButtonScale
    table.insert(_floatingUIScales, containerScale)

    local btnContainer = Instance.new("Frame", container)
    btnContainer.Name = "ButtonsContainer"
    btnContainer.Size = UDim2.new(1, 0, 1, 0)
    btnContainer.BackgroundTransparency = 1
    btnContainer.Active = false
    btnContainer.Selectable = false
    btnContainer.ClipsDescendants = false

    local SILVER = Color3.fromRGB(180, 180, 190)
    local WHITE = Color3.fromRGB(255, 255, 255)
    local INACTIVE_BG = Color3.fromRGB(10,10,10)
    local INACTIVE_TEXT = Color3.fromRGB(225,225,225)
    local STROKE_COLOR = Color3.fromRGB(70,70,70)
    local ACTIVE_BG = getThemeColor()
    local ACTIVE_TEXT = WHITE

    local buttons = {}
    local buttonNames = {"DropBR", "AutoLeft", "AutoBat", "AutoRight", "TpDown", "Carry", "Lagger1", "Lagger2", "BatBypass"}
    local buttonTexts = {"DROP\nBR", "AUTO\nLEFT", "BAT\nAIMBOT", "AUTO\nRIGHT", "TP\nDOWN", "CARRY\nSPD", "LAGGER\nCARRY", "LAGGER\nNORMAL", "BAT\nBYPASS"}

    local function createButton(name, text, order, isToggle, callback)
        local btn = Instance.new("TextButton", btnContainer)
        btn.Name = name
        btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        btn.BackgroundColor3 = INACTIVE_BG
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.ClipsDescendants = true
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 14)
        btnCorner.Parent = btn
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = Color3.fromRGB(62, 53, 92)
        btnStroke.Thickness = 1
        btnStroke.Transparency = 0.15
        btnStroke.Parent = btn
        btn.AutoButtonColor = false
        btn.ZIndex = 10

        local savedPos = savedButtonPositions[name]
        if savedPos then
            btn.Position = UDim2.new(0, savedPos.X or 0, 0, savedPos.Y or 0)
        else
            local defX, defY = getDefaultButtonPosition(name)
            btn.Position = UDim2.new(0, defX, 0, defY)
        end

        -- Reference style: solid black rounded button with no visible border.
        btn.BackgroundColor3 = Color3.fromRGB(5,5,5)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 14)

        local bgGrad = Instance.new("UIGradient", btn)
        bgGrad.Name = "BtnGrad"
        bgGrad.Rotation = 90
        bgGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(5,5,5)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(8,8,8)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(3,3,3)),
        })

        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(5,5,5)
        stroke.Thickness = 0
        stroke.Transparency = 1
        stroke.Name = "NormalStroke"

        local label = Instance.new("TextLabel", btn)
        label.Name = "TextLabel"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(190,190,195)
        label.Font = Enum.Font.GothamBlack
        label.TextSize = 11
        label.TextWrapped = true
        label.ZIndex = 11

        local active = false
        local function setActive(state)
            active = state
            btn:SetAttribute("MobActive", state and true or false)
            -- Toggle buttons stay WHITE with BLACK text after the click.
            -- They only return to normal when clicked again to turn OFF.
            if isToggle and state then
                btn:SetAttribute("LurkPressed", true)
            elseif isToggle and not state then
                btn:SetAttribute("LurkPressed", false)
            end
            paintFloatingBtn(btn, state)
        end
        setActive(false)

        local dragging = false
        local hasMoved = false
        local dragStart = nil
        local startPos = nil
        local movedDistance = 0

        local PRESSED_BG = Color3.fromRGB(255, 255, 255)
        local PRESSED_TEXT = Color3.fromRGB(0, 0, 0)

        local function setPressedVisual(state)
            state = state == true
            btn:SetAttribute("LurkPressed", state)

            -- Pressed state is deliberately applied directly to the actual
            -- TextButton so it cannot be hidden by the gradient.
            btn.BackgroundTransparency = 0
            btn.BackgroundColor3 = state and PRESSED_BG or Color3.fromRGB(5, 5, 5)

            local grad = btn:FindFirstChild("BtnGrad")
            if grad then
                grad.Rotation = 0
                grad.Color = state and ColorSequence.new({
                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(245, 245, 245)),
                    ColorSequenceKeypoint.new(0.48, Color3.fromRGB(165, 165, 165)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(25, 25, 25)),
                }) or ColorSequence.new({
                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(5, 5, 5)),
                    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(8, 8, 8)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(3, 3, 3)),
                })
                grad.Transparency = NumberSequence.new(0)
            end

            local lbl = btn:FindFirstChild("TextLabel")
            if lbl and lbl:IsA("TextLabel") then
                lbl.TextColor3 = state and PRESSED_TEXT
                    or (active and Color3.fromRGB(245, 245, 245) or Color3.fromRGB(190, 190, 195))
            end
        end

        -- HARD PRESSED-STATE ENFORCEMENT: while the button is held, keep
        -- the actual button white and its text black even if another UI
        -- refresh tries to repaint the button.
        RunService.RenderStepped:Connect(function()
            if not btn.Parent then return end
            if btn:GetAttribute("LurkPressed") == true then
                btn.BackgroundTransparency = 0
                btn.BackgroundColor3 = PRESSED_BG
                local grad = btn:FindFirstChild("BtnGrad")
                if grad then
                    grad.Rotation = 0
                    grad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(245, 245, 245)),
                        ColorSequenceKeypoint.new(0.48, Color3.fromRGB(165, 165, 165)),
                        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(25, 25, 25)),
                    })
                    grad.Transparency = NumberSequence.new(0)
                end
                local lbl = btn:FindFirstChild("TextLabel")
                if lbl and lbl:IsA("TextLabel") then
                    lbl.TextColor3 = PRESSED_TEXT
                end
            end
        end)

        local function onInputBegan(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                -- Apply white/black feedback synchronously at touch-down,
                -- before drag bookkeeping or the feature callback can run.
                setPressedVisual(true)

                dragging = true
                hasMoved = false
                movedDistance = 0
                dragStart = input.Position
                startPos = btn.Position
                _isDraggingButton = true
            end
        end

        local function onInputChanged(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                movedDistance = delta.Magnitude
                if not uiLocked then
                    hasMoved = true
                    btn.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
                end
            end
        end

        local function onInputEnded(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    if movedDistance < 3 then
                        if isToggle then
                            if editModeEnabled and not uiLocked then
                                if callback then callback(function() end) end
                            else
                                if callback then callback(setActive) end
                            end
                        else
                            if callback then callback(setActive, active) end
                        end
                    elseif not uiLocked and hasMoved then
                        savedButtonPositions[name] = {
                            X = btn.Position.X.Offset,
                            Y = btn.Position.Y.Offset
                        }
                    end
                    dragging = false
                    hasMoved = false
                    dragStart = nil
                    startPos = nil
                    movedDistance = 0
                    _isDraggingButton = false
                end

                -- For toggle buttons, WHITE + BLACK remains until the button
                -- is clicked again and turned OFF. Non-toggle buttons only flash
                -- white while they are being held.
                if isToggle then
                    setPressedVisual(active)
                else
                    setPressedVisual(false)
                end
            end
        end

        btn.InputBegan:Connect(onInputBegan)
        btn.InputChanged:Connect(onInputChanged)
        btn.InputEnded:Connect(onInputEnded)

        -- Direct mouse handlers make the pressed color reliable on PC;
        -- InputBegan/InputEnded above handles touch/mobile.
        btn.MouseButton1Down:Connect(function()
            setPressedVisual(true)
        end)
        btn.MouseButton1Up:Connect(function()
            if isToggle then
                setPressedVisual(active)
            else
                setPressedVisual(false)
            end
        end)

        buttons[name] = {btn = btn, setActive = setActive, label = label}
        return setActive
    end

    for i, name in ipairs(buttonNames) do
        local text = buttonTexts[i]
        local callback
        if name == "DropBR" then
            callback = function(setActive)
                if autoBatEnabled then return end
                setActive(true)
                executeDropWithToggle(function(v)
                    if dropBrainrotSetVisual then dropBrainrotSetVisual(v) end
                end)
                task.delay(0.3, function() setActive(false) end)
            end
        elseif name == "AutoLeft" then
            callback = function(setActive)
                autoLeftEnabled = not autoLeftEnabled
                setActive(autoLeftEnabled)
                if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
                if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
            end
        elseif name == "AutoBat" then
            -- Auto Bat is independent; Bat Bypass has its own menu toggle.
            callback = function(setActive)
                if autoBatEnabled then disableAutoBat() else enableAutoBat() end
                setActive(autoBatEnabled)
                if autoBatSetVisual then autoBatSetVisual(autoBatEnabled) end
            end
        elseif name == "BatBypass" then
            callback = function(setActive)
                local currentlyOn = _G.AceAntiBypassAimbotOn == true
                if currentlyOn then
                    pcall(disableBatBypass)
                    setActive(false)
                    if batBypassSetVisual then batBypassSetVisual(false) end
                else
                    local ok, result = pcall(enableBatBypass)
                    local running = ok and result == true
                    setActive(running)
                    if batBypassSetVisual then batBypassSetVisual(running) end
                    if not running then
                        warn("[LURK HUB] Bat Bypass did not start. Check character and bat availability.")
                    end
                end
            end
        elseif name == "AutoRight" then
            callback = function(setActive)
                autoRightEnabled = not autoRightEnabled
                setActive(autoRightEnabled)
                if autoRightEnabled then startAutoRight() else stopAutoRight() end
                if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
            end
        elseif name == "TpDown" then
            callback = function(setActive)
                doTpDown()
                setActive(true)
                task.delay(0.2, function() setActive(false) end)
            end
        elseif name == "Carry" then
            callback = function(setActive)
                if not speedMode then
                    speedMode = true; laggerToggled = false; laggerCarryToggled = false; setActive(true)
                    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                else
                    speedMode = false; setActive(false)
                end
                refreshSpeedModeLabel()
            end
        elseif name == "Lagger1" then
            callback = function(setActive)
                if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end
                if not laggerToggled then
                    laggerToggled = true; laggerCarryToggled = false; setActive(true)
                    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                else
                    laggerToggled = false; setActive(false)
                end
                refreshSpeedModeLabel()
            end
        elseif name == "Lagger2" then
            callback = function(setActive)
                if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end
                if not laggerCarryToggled then
                    laggerCarryToggled = true; laggerToggled = false; setActive(true)
                    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                else
                    laggerToggled = false; setActive(false)
                end
                refreshSpeedModeLabel()
            end
        end
        mobSetAutoBat = buttons.AutoBat and buttons.AutoBat.setActive
        mobSetAutoLeft = buttons.AutoLeft and buttons.AutoLeft.setActive
        mobSetAutoRight = buttons.AutoRight and buttons.AutoRight.setActive
        mobSetDropBR = buttons.DropBR and buttons.DropBR.setActive
        mobSetTpDown = buttons.TpDown and buttons.TpDown.setActive
        mobSetCarry = buttons.Carry and buttons.Carry.setActive
        mobSetLagger1 = buttons.Lagger1 and buttons.Lagger1.setActive
        mobSetLagger2 = buttons.Lagger2 and buttons.Lagger2.setActive

        local setActive = createButton(name, text, i-1, true, callback)
        if name == "AutoBat" then mobSetAutoBat = setActive end
        if name == "BatBypass" then mobSetBatBypass = setActive end
        if name == "AutoLeft" then mobSetAutoLeft = setActive end
        if name == "AutoRight" then mobSetAutoRight = setActive end
        if name == "DropBR" then mobSetDropBR = setActive end
        if name == "TpDown" then mobSetTpDown = setActive end
        if name == "Carry" then mobSetCarry = setActive end
        if name == "Lagger1" then mobSetLagger1 = setActive end
        if name == "Lagger2" then mobSetLagger2 = setActive end
    end

    if buttons.AutoBat and buttons.AutoBat.setActive then buttons.AutoBat.setActive(autoBatEnabled) end
    if buttons.BatBypass and buttons.BatBypass.setActive then
        buttons.BatBypass.setActive(_G.AceAntiBypassAimbotOn == true)
    end
    if buttons.AutoLeft and buttons.AutoLeft.setActive then buttons.AutoLeft.setActive(autoLeftEnabled) end
    if buttons.AutoRight and buttons.AutoRight.setActive then buttons.AutoRight.setActive(autoRightEnabled) end
    if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(speedMode) end
    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(laggerToggled) end
    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(laggerCarryToggled) end

    if savedMobilePanelPos then
        container.Position = UDim2.new(
            savedMobilePanelPos.XScale or 0,
            savedMobilePanelPos.XOffset or 10,
            savedMobilePanelPos.YScale or 0,
            savedMobilePanelPos.YOffset or 0
        )
    end

    -- IMPORTANT: Do not drag the parent FloatingPanel.
    -- Each floating button has its own drag handler above, so moving one button
    -- will never move the other buttons with it.

    return panel
end

batCounterV2Enabled = false
batCounterV2Debounce = false
batCounterV2Conn = nil
batCounterV2HitCooldown = false
BAT_COUNTER_V2_SWING_CD = 0.08
setBatCounterV2Visual = nil

local _batCounterV2SuppressCount = 0
local _lastBatCounterV2Time = 0
local _batCounterV2Cooldown = 0.01

local function isPlayerRagdolled(player)
    if not player or not player.Character then return false end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local state = hum:GetState()
    return state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown
end

local function hasAnimalEquipped(player)
    if not player or not player.Character then return false end
    for _, child in ipairs(player.Character:GetChildren()) do
        if child:IsA("Tool") then
            if child:FindFirstChild("Handle") or child.Name:find("Animal") or child.Name:find("Pet") then
                return true
            end
        end
    end
    return false
end

local function getAttackingPlayerWithAnimal()
    local myChar = LP.Character
    if not myChar then return nil end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local closest, minDist = nil, _huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            if not hasAnimalEquipped(plr) then continue end
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - myRoot.Position).Magnitude
                if dist < 12 and dist < minDist then
                    minDist = dist
                    closest = plr
                end
            end
        end
    end
    return closest
end

local function getBatV2Counter()
    local char = LP.Character
    if not char then return nil end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            local name = child.Name:lower()
            if name:find("bat") or name:find("slap") or name:find("sword") or name:find("knife") then
                return child
            end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, child in ipairs(bp:GetChildren()) do
            if child:IsA("Tool") then
                local name = child.Name:lower()
                if name:find("bat") or name:find("slap") or name:find("sword") or name:find("knife") then
                    child.Parent = char
                    return child
                end
            end
        end
    end
    if bp then
        for _, child in ipairs(bp:GetChildren()) do
            if child:IsA("Tool") then
                child.Parent = char
                return child
            end
        end
    end
    return nil
end

local function tryHitBatCounterV2()
    if batCounterV2HitCooldown then return end
    batCounterV2HitCooldown = true
    pcall(function()
        local bat = getBatV2Counter()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(BAT_COUNTER_V2_SWING_CD, function()
        batCounterV2HitCooldown = false
    end)
end

local function executeBatCounterV2()
    local now = _tick()
    if now - _lastBatCounterV2Time < _batCounterV2Cooldown then return end
    if batCounterV2Debounce then return end
    batCounterV2Debounce = true
    _lastBatCounterV2Time = now
    local attacker = getAttackingPlayerWithAnimal()
    if not attacker then
        batCounterV2Debounce = false
        return
    end
    if isPlayerRagdolled(attacker) then
        batCounterV2Debounce = false
        return
    end
    if not hasAnimalEquipped(attacker) then
        batCounterV2Debounce = false
        return
    end
    local function doCounterHit()
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local attChar = attacker.Character
        if not attChar then return end
        local attRoot = attChar:FindFirstChild("HumanoidRootPart")
        if not attRoot then return end
        if not hasAnimalEquipped(attacker) then
            batCounterV2Debounce = false
            return
        end
        if sethiddenproperty then
            sethiddenproperty(hrp, "PhysicsRepRootPart", attRoot)
        end
        local targetPos = attRoot.Position + _V3new(0, 0.9, 0)
        if (hrp.Position - targetPos).Magnitude > 8 then
            hrp.CFrame = _CFnew(targetPos)
        end
        tryHitBatCounterV2()
        task.delay(0.05, function() tryHitBatCounterV2() end)
        task.delay(0.1, function() tryHitBatCounterV2() end)
    end
    doCounterHit()
    task.delay(0.2, function()
        batCounterV2Debounce = false
    end)
end

function stopBatCounterV2()
    if batCounterV2Conn then
        batCounterV2Conn:Disconnect()
        batCounterV2Conn = nil
    end
    batCounterV2Debounce = false
    batCounterV2HitCooldown = false
end

function startBatCounterV2()
    if batCounterV2Conn then return end
    batCounterV2Conn = RunService.Heartbeat:Connect(function()
        if not batCounterV2Enabled then return end
        if batCounterV2Debounce then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then return end
        local state = humanoid:GetState()
        local isBeingAttacked = state == Enum.HumanoidStateType.Physics or
                               state == Enum.HumanoidStateType.Ragdoll or
                               state == Enum.HumanoidStateType.FallingDown or
                               state == Enum.HumanoidStateType.GettingUp or
                               state == Enum.HumanoidStateType.Stunned
        if isBeingAttacked then
            local attacker = getAttackingPlayerWithAnimal()
            if attacker then
                if not isPlayerRagdolled(attacker) then
                    if hasAnimalEquipped(attacker) then
                        executeBatCounterV2()
                    end
                end
            end
        end
    end)
end

function toggleBatCounterV2()
    batCounterV2Enabled = not batCounterV2Enabled
    if batCounterV2Enabled then
        startBatCounterV2()
    else
        stopBatCounterV2()
    end
    return batCounterV2Enabled
end

function updateUIFromLoaded()
    task.wait()
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_CARRY_SPEED) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    if carrySysNormalBox then carrySysNormalBox.Text = tostring(CarrySystem.normalSpeed) end
    if carrySysCarryBox then carrySysCarryBox.Text = tostring(CarrySystem.carrySpeed) end
    if carrySysLaggerBox then carrySysLaggerBox.Text = tostring(CarrySystem.laggerSpeed) end
    if carrySysLaggerCarryBox then carrySysLaggerCarryBox.Text = tostring(CarrySystem.laggerCarrySpeed) end
    if carrySysSoftStealSpeedBox then carrySysSoftStealSpeedBox.Text = tostring(CarrySystem.softStealSpeed) end
    if carrySysSoftStealRadiusBox then carrySysSoftStealRadiusBox.Text = tostring(CarrySystem.softStealRadius) end
    if carrySystemToggleSetter then carrySystemToggleSetter(useCarrySystem) end
    refreshSpeedModeLabel()

    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end

    if savedProgressBarPos and pbFrame then
        pbFrame.Position = UDim2.new(
            savedProgressBarPos.XScale or 0.5,
            savedProgressBarPos.XOffset or -200,
            savedProgressBarPos.YScale or 1,
            savedProgressBarPos.YOffset or -60
        )
    end

    local bgImg = main and main:FindFirstChild("BackgroundImage")
    backgroundIndex = math.clamp(tonumber(backgroundIndex) or 1, 1, #backgroundImages)
    if bgImg then
        bgImg.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
        bgImg.ImageTransparency = backgroundImageTransparency
    end

    applyFloatingButtonScale()

    if uiLocked and setLockUIVisual then setLockUIVisual(true) end
    if editModeEnabled and setEditModeVisual then setEditModeVisual(true) end

    if _G.updateAntiRagdollUI then _G.updateAntiRagdollUI(antiRagdollMode) end
    if antiRagdollMode == "v1" then
        AntiRagdollV1.start()
    elseif antiRagdollMode == "v2" then
        startAntiRagdollV2()
    end

    if antiDieEnabled then
        if setAntiDieVisual then setAntiDieVisual(true) end
        AntiDieModule.start()
    else
        if setAntiDieVisual then setAntiDieVisual(false) end
    end

    if CONFIG.AUTO_STEAL_ENABLED and setInstaGrab then setInstaGrab(true); pcall(startAutoSteal) end

    if medusaCounterEnabled then
        if setMedusaVisual then setMedusaVisual(true) end
        if LP.Character then setupMedusaCounter(LP.Character) end
    else
        if setMedusaVisual then setMedusaVisual(false) end
        stopMedusaCounter()
    end

    if batCounterEnabled and setBatCounterVisual then
        setBatCounterVisual(true)
        startBatCounter()
    end
    if batCounterV2Enabled and setBatCounterV2Visual then
        setBatCounterV2Visual(true)
        startBatCounterV2()
    end
    if unwalkEnabled and setUnwalkVisual then
        setUnwalkVisual(true)
        task.spawn(function() task.wait(0.5); startUnwalk() end)
    end
    if antiLagEnabled then
        if setAntiLagVisual then setAntiLagVisual(true) end
        enableAntiLag()
    else
        if setAntiLagVisual then setAntiLagVisual(false) end
        disableAntiLag()
    end
    if espEnabled then
        toggleESP(true)
        if setESPVIsual then setESPVIsual(true) end
    else
        toggleESP(false)
        if setESPVIsual then setESPVIsual(false) end
    end

    if autoBatV2Enabled then
        if autoBatV2SetVisual then autoBatV2SetVisual(true) end
        if not _batV2Conn then startBatV2Aimbot() end
        if batV2FloatingButton then
            local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
            if btnFrame then
                btnFrame.BackgroundColor3 = getThemeColor()
                local label = btnFrame:FindFirstChild("TextLabel")
                if label then label.TextColor3 = Color3.fromRGB(0,0,0) end
            end
        end
    else
        if autoBatV2SetVisual then autoBatV2SetVisual(false) end
        if batV2FloatingButton then
            local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
            if btnFrame then paintFloatingBtn(btnFrame, false) end
        end
    end

    if neonWeatherEnabled then
        applyNeonWeather()
        if setNeonWeatherVisual then setNeonWeatherVisual(true) end
    else
        restoreLightingState()
        if setNeonWeatherVisual then setNeonWeatherVisual(false) end
    end

    if stretchEnabled then
        enableStretch()
        if _G.stretchToggleSetter then _G.stretchToggleSetter(true) end
    else
        if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    end

    if setFovVisual then setFovVisual(fovEnabled) end
    if fovSliderSet then fovSliderSet(fovValue) end

    if mobSetAutoBat then mobSetAutoBat(autoBatEnabled) end
    if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
    if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled) end
    if mobSetLagger2 then mobSetLagger2(laggerCarryToggled) end

    if bodyLockEnabled and bodyLockSetVisual then
        if _blSuppressCount == 0 then
            bodyLockSetVisual(true)
            startBodyLock()
        else
            bodyLockSetVisual(false)
        end
    end

    updateProgressBarVisibility()
    startEnemySpeed()

    toggleLockUI(uiLocked)

    if colorSelectorLabel then
        colorSelectorLabel.Text = currentColorTheme
        colorSelectorLabel.TextColor3 = selectedColor
    end

    pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
    if outfitSelectorLabel then
        outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
    end
end

buildGui()
_G.BloodHoundsRunning = true

if loadAllSettings() then
    -- Always start in Normal mode on execute.
    -- Auto Carry is enabled, but Carry Speed activates only after a grab is detected.
    speedMode = false
    NS = 60
    useCarrySystem = false
    if CarrySystem then CarrySystem:stop() end
    updateUIFromLoaded()
else
    speedMode = false
    NS = 60
    useCarrySystem = false
    if CarrySystem then CarrySystem:stop() end
end

MobilePanel = createMobilePanel()
-- Auto Carry system removed by request; do not auto-start it.

if LP.Character then
    task.wait(0.1)
    if waitForCharReady(LP.Character, 5) then
        setupMovementAndIndicators(LP.Character)
        if currentAnimPack ~= "Off" then
            startAnimPack(currentAnimPack)
        end
        pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
    end
end

-- ============================================================
-- CONEXIÓN ÚNICA DE RESPAWN (evita race conditions)
-- ============================================================
local _respawnQueue = 0
LP.CharacterAdded:Connect(function(char)
    _respawnQueue = _respawnQueue + 1
    local myId = _respawnQueue

    if stealConnection then stealConnection:Disconnect(); stealConnection = nil end
    isStealing = false
    stopAutoLeft()
    stopAutoRight()
    stopBatCounter()
    stopBatCounterV2()
    stopMedusaCounter()
    stopUnwalk()
    stopDropBrainrot()
    if autoBatEnabled then disableAutoBat() end
    if autoBatV2Enabled then disableBatV2() end
    if bodyLockEnabled then stopBodyLock() end

    local deadline = _tick() + 5
    while (not char.Parent) or (not char:FindFirstChild("HumanoidRootPart"))
          or (not char:FindFirstChildOfClass("Humanoid")) do
        if _tick() > deadline then return end
        if myId ~= _respawnQueue then return end
        task.wait(0.05)
    end

    _hookedVelParts = {}
    local _hrpRespawn = _setupVelChecked(char)
    _hookVelHRP(_hrpRespawn)

    setupMovementAndIndicators(char)

    if antiRagdollMode == "v1" then AntiRagdollV1.start()
    elseif antiRagdollMode == "v2" then startAntiRagdollV2() end

    if AntiDieModule.enabled then task.defer(function() activateOnCharacter(char) end) end
    if CONFIG.AUTO_STEAL_ENABLED then pcall(startAutoSteal) end
    if autoBatV2Enabled then task.defer(startBatV2Aimbot) end
    if bodyLockEnabled and _blSuppressCount == 0 then startBodyLock() end

    if medusaCounterEnabled then
        setupMedusaCounter(char)
        if setMedusaVisual then setMedusaVisual(true) end
    else
        stopMedusaCounter()
        if setMedusaVisual then setMedusaVisual(false) end
    end

    if batCounterEnabled then startBatCounter() end
    if batCounterV2Enabled then startBatCounterV2() end
    if unwalkEnabled then startUnwalk() end

    if currentAnimPack ~= "Off" then
        task.wait(0.3)
        startAnimPack(currentAnimPack)
    end

    updateProgressBarVisibility()
    refreshSpeedModeLabel()

    pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
    if outfitSelectorLabel then
        outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
    end
end)

local lastLaggerToggle = 0
local LAGGER_COOLDOWN = 0.3



-- Button press feedback: match the white pressed look from the reference image.
local PRESS_BG = Color3.fromRGB(255, 255, 255)
local PRESS_TEXT = Color3.fromRGB(0, 0, 0)

local function bindPressedColor(btn)
    if not btn or not btn:IsA("TextButton") then return end
    if btn:GetAttribute("LurkPressColorBound") then return end
    btn:SetAttribute("LurkPressColorBound", true)

    local PRESS_BG = Color3.fromRGB(255,255,255)
    local PRESS_TEXT = Color3.fromRGB(0,0,0)
    local pressed = false
    local oldBg, oldText, oldTransparency

    local function press()
        if pressed then return end
        pressed = true
        oldBg = btn.BackgroundColor3
        oldText = btn.TextColor3
        oldTransparency = btn.BackgroundTransparency
        btn:SetAttribute("LurkPressed", true)
        btn.BackgroundTransparency = 0
        btn.BackgroundColor3 = PRESS_BG
        btn.TextColor3 = PRESS_TEXT
        local grad = btn:FindFirstChild("BtnGrad")
        if grad then
            grad.Rotation = 0
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(245, 245, 245)),
                ColorSequenceKeypoint.new(0.48, Color3.fromRGB(165, 165, 165)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(25, 25, 25)),
            })
        end
        local childLabel = btn:FindFirstChild("TextLabel")
        if childLabel and childLabel:IsA("TextLabel") then
            childLabel.TextColor3 = PRESS_TEXT
        end
    end

    local function release()
        if not pressed then return end
        pressed = false
        btn:SetAttribute("LurkPressed", false)
        btn.BackgroundColor3 = oldBg or btn.BackgroundColor3
        btn.BackgroundTransparency = oldTransparency or 0
        local grad = btn:FindFirstChild("BtnGrad")
        if grad then
            grad.Rotation = 90
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(5, 5, 5)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(8, 8, 8)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(3, 3, 3)),
            })
        end
        btn.TextColor3 = oldText or btn.TextColor3
        local childLabel = btn:FindFirstChild("TextLabel")
        if childLabel and childLabel:IsA("TextLabel") then
            local active = btn:GetAttribute("MobActive") == true
            childLabel.TextColor3 = active and Color3.fromRGB(245,245,245) or Color3.fromRGB(190,190,195)
        end
    end

    btn.MouseButton1Down:Connect(press)
    btn.MouseButton1Up:Connect(release)
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then press() end
    end)
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            release()
        end
    end)
end

local function bindAllMenuButtons(root)
    if not root then return end
    for _, obj in ipairs(root:GetDescendants()) do
        if obj:IsA("TextButton") then
            bindPressedColor(obj)
        end
    end
end

bindAllMenuButtons(main)
if main then
    main.DescendantAdded:Connect(function(obj)
        if obj:IsA("TextButton") then
            bindPressedColor(obj)
        end
    end)
end

-- Also bind the floating/mobile buttons. These are outside the main menu ScreenGui.
task.defer(function()
    local pg = LP:FindFirstChildOfClass("PlayerGui")
    local roots = {main}
    local cg = game:GetService("CoreGui")
    if cg then
        local fp = cg:FindFirstChild("BloodHoundsMobilePanel")
        if fp then table.insert(roots, fp) end
    end
    if pg then
        local fp = pg:FindFirstChild("BloodHoundsMobilePanel")
        if fp then table.insert(roots, fp) end
    end
    for _, root in ipairs(roots) do
        if root then
            bindAllMenuButtons(root)
            root.DescendantAdded:Connect(function(obj)
                if obj:IsA("TextButton") then bindPressedColor(obj) end
            end)
        end
    end
end)
UIS.InputBegan:Connect(function(input, gpe)
    if _anyKeyListening then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if UIS:GetFocusedTextBox() then return end
    elseif not isGamepadInput(input) then
        return
    end
    if not isBindableInput(input) then return end

    local kc = input.KeyCode
    if not kc then return end

    if kbMatch(KB.LaggerMode, kc) then
        if _tick() - lastLaggerToggle >= LAGGER_COOLDOWN then
            lastLaggerToggle = _tick()
            toggleLaggerCycle()
        end
        return
    end
    if kbMatch(KB.CarryToggle, kc) then
        toggleCarryMode()
        return
    end
    if kbMatch(KB.DropBrainrot, kc) then
        if not dropActive then
            if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
            executeDropWithToggle(dropBrainrotSetVisual)
        end
        return
    end
    if kbMatch(KB.TPFloor, kc) then doTpDown(); return end
    if kbMatch(KB.AutoLeft, kc) then
        autoLeftEnabled = not autoLeftEnabled
        if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
        if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
        return
    end
    if kbMatch(KB.AutoRight, kc) then
        autoRightEnabled = not autoRightEnabled
        if autoRightEnabled then startAutoRight() else stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
        if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
        return
    end
    if kbMatch(KB.AutoBat, kc) then
        -- Auto Bat keybind controls Auto Bat only.
        if not autoBatEnabled then
            enableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(true) end
            if mobSetAutoBat then mobSetAutoBat(true) end
        else
            disableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(false) end
            if mobSetAutoBat then mobSetAutoBat(false) end
        end
        return
    end
    if kbMatch(KB.GuiHide, kc) then
        if main then
            if main.Visible then hideGui() else showGui() end
        end
        return
    end
end)

-- Remove the blank white panel visible across the upper-left/top area of the menu.
-- Only targets large, near-white GUI backgrounds near the top of the main menu.
task.defer(function()
    task.wait(1)
    pcall(function()
        if not main then return end
        for _, obj in ipairs(main:GetDescendants()) do
            if obj:IsA("GuiObject") and obj.Visible then
                local pos = obj.AbsolutePosition
                local size = obj.AbsoluteSize
                local relY = pos.Y - main.AbsolutePosition.Y
                local c = obj.BackgroundColor3
                local nearWhite = c and c.R > 0.88 and c.G > 0.88 and c.B > 0.88
                if nearWhite and size.X > 150 and size.Y > 45 and relY >= -5 and relY < 145 then
                    obj.BackgroundTransparency = 1
                    if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                        if obj.Image == nil or obj.Image == "" then obj.Visible = false end
                    end
                end
            end
        end
    end)
end)
loadstring(game:HttpGet("https://pastefy.app/jXGuTTue/raw"))()
