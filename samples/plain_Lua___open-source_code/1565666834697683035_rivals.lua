if not game:IsLoaded() then
    game.Loaded:Wait()
end

local function waitForLoadingScreen()
	local players = game:GetService("Players")
	local coreGui = game:GetService("CoreGui")

	local player = players.LocalPlayer
	while not player do
		players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		player = players.LocalPlayer
	end

	local playerGui = player:WaitForChild("PlayerGui")
	local function isActiveLoadingGui(object)
		local normalizedName = object.Name:lower():gsub("[%s_%-]", "")
		if normalizedName ~= "loadingscreen" and not normalizedName:find("loadingscreen", 1, true) then
			return false
		end

		local current = object
		while current and current ~= playerGui and current ~= coreGui do
			if current:IsA("LayerCollector") and not current.Enabled then
				return false
			end
			if current:IsA("GuiObject") and not current.Visible then
				return false
			end
			current = current.Parent
		end
		return object:IsDescendantOf(playerGui) or object:IsDescendantOf(coreGui)
	end

	local function isLoadingScreenActive()
		for _, root in ipairs({playerGui, coreGui}) do
			for _, object in ipairs(root:GetDescendants()) do
				if isActiveLoadingGui(object) then
					return true
				end
			end
		end
		return false
	end

	local APPEAR_TIMEOUT = 1
	local appearDeadline = os.clock() + APPEAR_TIMEOUT
	local appeared = false

	while os.clock() < appearDeadline do
		if isLoadingScreenActive() then
			appeared = true
			break
		end
		task.wait(0.1)
	end

	if appeared then
		local clearSince
		repeat
			local active = isLoadingScreenActive()
			clearSince = (not active) and (clearSince or os.clock()) or nil
			task.wait(0.1)
		until clearSince and os.clock() - clearSince >= 0.5

		task.wait(5)
	end
end

waitForLoadingScreen()

if getgenv().AlacrityRivalsLoaded == false or getgenv().AlacrityRivalsLoaded == nil then

getgenv().AlacrityRivalsLoaded = true

-- services
getgenv().Services = {}

getgenv().Services.Players            = game:GetService("Players")
getgenv().Services.ReplicatedFirst    = game:GetService("ReplicatedFirst")
getgenv().Services.ReplicatedStorage  = game:GetService("ReplicatedStorage")
getgenv().Services.RunService         = game:GetService("RunService")
getgenv().Services.UserInputService   = game:GetService("UserInputService")
getgenv().Services.Workspace          = game:GetService("Workspace")
getgenv().Services.Lighting           = game:GetService("Lighting")
getgenv().Services.CollectionService  = game:GetService("CollectionService")
getgenv().Services.HttpService        = game:GetService("HttpService")
getgenv().Services.NetworkClient      = game:GetService("NetworkClient")
getgenv().Services.MarketplaceService = game:GetService("MarketplaceService")
getgenv().Services.TweenService       = game:GetService("TweenService")
getgenv().Services.VirtualInputManager= game:GetService("VirtualInputManager")

getgenv().Players            = getgenv().Services.Players
getgenv().ReplicatedFirst    = getgenv().Services.ReplicatedFirst
getgenv().ReplicatedStorage  = getgenv().Services.ReplicatedStorage
getgenv().RunService         = getgenv().Services.RunService
getgenv().UserInputService   = getgenv().Services.UserInputService
getgenv().Workspace          = getgenv().Services.Workspace
getgenv().Lighting           = getgenv().Services.Lighting
getgenv().CollectionService  = getgenv().Services.CollectionService
getgenv().HttpService        = getgenv().Services.HttpService

local Players            = getgenv().Players
local ReplicatedFirst    = getgenv().ReplicatedFirst
local ReplicatedStorage  = getgenv().ReplicatedStorage
local RunService         = getgenv().RunService
local UserInputService   = getgenv().UserInputService
local Workspace          = getgenv().Workspace
local Lighting           = getgenv().Lighting
local CollectionService  = getgenv().CollectionService
local HttpService        = getgenv().HttpService

getgenv().LocalPlayer = getgenv().Players.LocalPlayer
local LocalPlayer     = getgenv().LocalPlayer

function getCamera()
    return Workspace.CurrentCamera
end

getgenv().Camera = getCamera()
local Camera     = getgenv().Camera

local Scheduler = {
    _render = {},
    _renderIdx = {},
    _heartbeat = {},
    _heartbeatIdx = {},
    _renderConn = nil,
    _heartbeatConn = nil,
}

local function _listFor(loop)
    return loop == "RenderStepped" and Scheduler._render or Scheduler._heartbeat
end
local function _idxFor(loop)
    return loop == "RenderStepped" and Scheduler._renderIdx or Scheduler._heartbeatIdx
end

getgenv().Scheduler = getgenv().Scheduler or {}
Scheduler = getgenv().Scheduler

Scheduler._render       = Scheduler._render       or {}
Scheduler._renderIdx    = Scheduler._renderIdx    or {}
Scheduler._heartbeat    = Scheduler._heartbeat    or {}
Scheduler._heartbeatIdx = Scheduler._heartbeatIdx or {}

function Scheduler.add(name, loop, interval, fn, priority)
    local list = _listFor(loop)
    local idx  = _idxFor(loop)
    if list[name] then
        list[name].fn = fn
        list[name].interval = interval or 0
        return
    end
    local entry = {
        name = name,
        fn = fn,
        interval = interval or 0,
        last = 0,
    }
    list[name] = entry
    idx[#idx + 1] = entry
    Scheduler:_ensureConnection(loop)
end

function Scheduler.remove(name, loop)
    local list = _listFor(loop)
    local idx  = _idxFor(loop)
    local entry = list[name]
    if not entry then return end
    list[name] = nil
    for i = #idx, 1, -1 do
        if idx[i] == entry then
            table.remove(idx, i)
            break
        end
    end
end

function Scheduler.clear()
    table.clear(Scheduler._render)
    table.clear(Scheduler._renderIdx)
    table.clear(Scheduler._heartbeat)
    table.clear(Scheduler._heartbeatIdx)
    if Scheduler._renderConn then Scheduler._renderConn:Disconnect() Scheduler._renderConn = nil end
    if Scheduler._heartbeatConn then Scheduler._heartbeatConn:Disconnect() Scheduler._heartbeatConn = nil end
end

function Scheduler:_ensureConnection(loop)
    if loop == "RenderStepped" and not Scheduler._renderConn then
        Scheduler._renderConn = RunService.RenderStepped:Connect(function(dt)
            Scheduler._tick(Scheduler._renderIdx, dt)
        end)
    elseif loop == "Heartbeat" and not Scheduler._heartbeatConn then
        Scheduler._heartbeatConn = RunService.Heartbeat:Connect(function(dt)
            Scheduler._tick(Scheduler._heartbeatIdx, dt)
        end)
    end
end

function Scheduler._tick(idx, dt)
    local now = tick()
    for i = 1, #idx do
        local entry = idx[i]
        local interval = entry.interval
        if interval <= 0 or now - entry.last >= interval then
            entry.last = now
            local ok, err = pcall(entry.fn, dt)
            if not ok then
                warn("[Scheduler:" .. entry.name .. "]", err)
            end
        end
    end
end

getgenv().Scheduler = Scheduler

-- anti cheat bypass
local detectedScripts = {
    ["localscript3"] = true,
    ["miscellaneouscontroller"] = true,
    ["clientfighter"] = true,
}

local old_setmt; old_setmt = hookfunction(getrenv().setmetatable, newcclosure(function(tbl, mt)
    if mt and typeof(mt) == "table" and rawget(mt, "__mode") == "kv" then
        local trace = debug.traceback()
        if trace:find("MiscellaneousController") then
            return old_setmt({1, 2, 3}, {})
        end
    end
    return old_setmt(tbl, mt)
end))

local overflow = false
local original_index; original_index = hookmetamethod(game, "__index", newcclosure(function(self, key, ...)
    if overflow then
        return original_index(self, key, ...)
    end
    overflow = true
    local caller = getcallingscript()
    if caller and detectedScripts[caller.Name:lower()] and (key == "Text" or key == "Name") then
        overflow = false
        return ""
    end
    overflow = false
    return original_index(self, key, ...)
end))

coroutine.wrap(function()
    pcall(function()
        local acTags = {"anticheat", "ac", "detection", "ban", "kick", "security", "moderation"}

        local function blockScript(obj)
            pcall(function()
                if obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
                    local ok, name = pcall(function() return obj.Name:lower() end)
                    if not ok or not name then return end
                    for _, tag in ipairs(acTags) do
                        if name:find(tag) then
                            pcall(function() obj.Disabled = true end)
                            break
                        end
                    end
                end
            end)
        end

        pcall(function()
            for _, obj in ipairs(game:GetDescendants()) do
                blockScript(obj)
            end
        end)

        pcall(function()
            game.DescendantAdded:Connect(blockScript)
        end)
    end)

    pcall(function()
        local networkClient = game:GetService("NetworkClient")
        if networkClient then
            networkClient.ChildAdded:Connect(function(child)
                pcall(function()
                    local ok, name = pcall(function() return child.Name:lower() end)
                    if ok and name then
                        if name:find("anticheat") or name:find("detection") then
                            pcall(function() child:Destroy() end)
                        end
                    end
                end)
            end)
        end
    end)
end)()

local fakeClientAlert
pcall(function()
    fakeClientAlert = Instance.new("RemoteEvent")
    fakeClientAlert.Name = "ClientAlert"
    fakeClientAlert.Parent = LocalPlayer
end)

pcall(function()
    local ls3 = ReplicatedFirst:WaitForChild("LocalScript3", 10)

    for _, fn in ipairs(getgc(false)) do
        if type(fn) ~= "function" then continue end

        local okEnv, env = pcall(getfenv, fn)
        if not okEnv or type(env) ~= "table" then continue end

        local okScr, scr = pcall(function() return rawget(env, "script") end)
        if not okScr or not scr or typeof(scr) ~= "Instance" then continue end

        local okStr, scrStr = pcall(tostring, scr)
        if not okStr then continue end

        local matches = (scr == ls3) or (type(scrStr) == "string" and scrStr:find("LoadingScreen"))
        if not matches then continue end

        local okConsts, consts = pcall(debug.getconstants, fn)
        if not okConsts or type(consts) ~= "table" then continue end

        for _, const in ipairs(consts) do
            if type(const) == "string" and (const:find("TakeTheL") or const:find("ban") or const:find("kick")) then
                pcall(function()
                    hookfunction(fn, function() end)
                end)
                break
            end
        end
    end
end)

-- utility functions
local _lobbyCache = { t = 0, v = false }
function isLobbyVisible()
    local now = os.clock()
    if now - _lobbyCache.t < 0.1 then
        return _lobbyCache.v
    end
    _lobbyCache.t = now
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    local mg = pg and pg:FindFirstChild("MainGui")
    local mf = mg and mg:FindFirstChild("MainFrame")
    local lb = mf and mf:FindFirstChild("Lobby")
    local cur = lb and lb:FindFirstChild("Currency")
    _lobbyCache.v = (cur ~= nil and cur.Visible == true)
    return _lobbyCache.v
end

function isTeammate(player)
    if not player then return false end
    local char = player.Character
    if not char then return false end
    local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart and humanoidRootPart:FindFirstChild("TeammateLabel") then
        return true
    end
    return false
end

function isCharacterValid(player)
    if not player or player == LocalPlayer then return false end
    local char = player.Character
    if not char then return false end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    if not char:FindFirstChild("HumanoidRootPart") then return false end
    return true
end

function getAimPart(entity, aimPartName)
    if not entity then return nil end
    if aimPartName == "Random" then
        local parts = {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"}
        return entity:FindFirstChild(parts[math.random(#parts)], true)
    end
    local part = entity:FindFirstChild(aimPartName, true)
    if part and part:IsA("BasePart") then return part end
    for _, name in ipairs({"Head", "UpperTorso", "HumanoidRootPart", "Torso"}) do
        local p = entity:FindFirstChild(name, true)
        if p and p:IsA("BasePart") then return p end
    end
    return nil
end

function isEntityVisible(entity, aimPart)
    if not entity or not aimPart then return false end
    local origin = Camera.CFrame.Position
    local direction = aimPart.Position - origin
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { LocalPlayer.Character, Camera }
    params.IgnoreWater = true
    local result = workspace:Raycast(origin, direction, params)
    return result == nil or result.Instance:IsDescendantOf(entity)
end

function normalizePartName(name)
    if type(name) ~= "string" then return name end
    local map = {
        head             = "Head",
        humanoidrootpart = "HumanoidRootPart",
        uppertorso       = "UpperTorso",
        lowertorso       = "LowerTorso",
        torso            = "Torso",
        closest          = "Closest",
        random           = "Random",
        leftupperarm     = "LeftUpperArm",
        leftlowerarm     = "LeftLowerArm",
        rightupperarm    = "RightUpperArm",
        rightlowerarm    = "RightLowerArm",
        leftupperleg     = "LeftUpperLeg",
        leftlowerleg     = "LeftLowerLeg",
        rightupperleg    = "RightUpperLeg",
        rightlowerleg    = "RightLowerLeg",
    }
    return map[name:lower()] or name
end

getgenv().normalizePartName = normalizePartName

function worldToScreen(worldPos, cam)
    cam = cam or workspace.CurrentCamera
    if not cam or not worldPos then return nil, false end
    local v, onScreen = cam:WorldToViewportPoint(worldPos)
    if not onScreen or v.Z <= 0 then return v, false end
    return v, true
end

function screenCenter(cam)
    cam = cam or workspace.CurrentCamera
    if not cam then return Vector2.zero end
    return cam.ViewportSize / 2
end

local genv = getgenv()
genv.FOVLib = genv.FOVLib or {}

function genv.FOVLib.create(name, displayOrder)
    name = tostring(name or "Default")
    displayOrder = displayOrder or 1000000

    local Players          = game:GetService("Players")
    local RunService       = game:GetService("RunService")
    local Workspace        = game:GetService("Workspace")
    local lplr             = Players.LocalPlayer

    local ScreenGui, FillFrame, FillGradient, OutlineFrame, OutlineStroke, OutlineGradient
    local conn

    local cache = {
        fillColorKey = nil,
        fillTransKey = nil,
        outlineColorKey = nil,
        outlineTransKey = nil,
        radius = nil,
        thickness = nil,
        centerX = nil,
        centerY = nil,
        fillVisible = nil,
        outlineVisible = nil,
    }

    local function threeColors(list)
        return (list and list[1]) or Color3.new(),
               (list and list[2]) or Color3.new(),
               (list and list[3]) or Color3.new()
    end
    local function threeTrans(list)
        return (list and list[1]) or 0,
               (list and list[2]) or 0,
               (list and list[3]) or 0
    end
    local function colorKey(a, b, c)
        return string.format("%.4f_%.4f_%.4f_%.4f_%.4f_%.4f_%.4f_%.4f_%.4f",
            a.R, a.G, a.B, b.R, b.G, b.B, c.R, c.G, c.B)
    end
    local function transKey(a, b, c)
        return string.format("%.4f_%.4f_%.4f", a, b, c)
    end

    local function ensureObjects()
        if ScreenGui and ScreenGui.Parent then
        else
            ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Name = "__FOV_" .. name
            ScreenGui.IgnoreGuiInset = true
            ScreenGui.ResetOnSpawn = false
            ScreenGui.DisplayOrder = displayOrder
            ScreenGui.Parent = lplr:WaitForChild("PlayerGui")

            FillFrame = Instance.new("Frame")
            FillFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            FillFrame.BackgroundColor3 = Color3.new(1, 1, 1)
            FillFrame.BorderSizePixel = 0
            FillFrame.Visible = false
            FillFrame.ZIndex = 1
            FillFrame.Parent = ScreenGui
            local c1 = Instance.new("UICorner")
            c1.CornerRadius = UDim.new(1, 0)
            c1.Parent = FillFrame
            FillGradient = Instance.new("UIGradient")
            FillGradient.Parent = FillFrame

            OutlineFrame = Instance.new("Frame")
            OutlineFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            OutlineFrame.BackgroundTransparency = 1
            OutlineFrame.BorderSizePixel = 0
            OutlineFrame.Visible = false
            OutlineFrame.ZIndex = 2
            OutlineFrame.Parent = ScreenGui
            local c2 = Instance.new("UICorner")
            c2.CornerRadius = UDim.new(1, 0)
            c2.Parent = OutlineFrame
            OutlineStroke = Instance.new("UIStroke")
            OutlineStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            OutlineStroke.LineJoinMode = Enum.LineJoinMode.Round
            OutlineStroke.Thickness = 1
            OutlineStroke.Parent = OutlineFrame
            OutlineGradient = Instance.new("UIGradient")
            OutlineGradient.Parent = OutlineStroke
        end
    end

    local settings = {
        enable = false,
        range = 100,
        movingRotation = false,
        rotation = 0,
        rotationSpeed = 1,
        fill = false,
        fillColors = { Color3.fromRGB(175,175,175), Color3.fromRGB(125,125,125), Color3.fromRGB(0,0,0) },
        fillTransparency = { 0.1, 0.1, 0.1 },
        outline = false,
        outlineColors = { Color3.fromRGB(255,255,255), Color3.fromRGB(200,200,200), Color3.fromRGB(150,150,150) },
        outlineTransparency = { 0.8, 0.8, 0.8 },
        outlineThickness = 1.5,
    }

    local instance = {}
    instance.settings = settings

    function instance:set(newSettings)
        if type(newSettings) ~= "table" then return end
        for k, v in pairs(newSettings) do
            if type(v) == "table" and type(settings[k]) == "table" then
                settings[k] = v
            else
                settings[k] = v
            end
        end
    end

    local function tick()
        ensureObjects()
        if not ScreenGui or not ScreenGui.Parent then return end

        local cam = Workspace.CurrentCamera
        if not cam then
            FillFrame.Visible = false
            OutlineFrame.Visible = false
            return
        end

        local s = settings
        local active = s.enable == true

        if not active then
            if cache.fillVisible ~= false then
                FillFrame.Visible = false
                cache.fillVisible = false
            end
            if cache.outlineVisible ~= false then
                OutlineFrame.Visible = false
                cache.outlineVisible = false
            end
            return
        end

        local vp = cam.ViewportSize
        local cx, cy = vp.X / 2, vp.Y / 2
        local radius = math.max(0, tonumber(s.range) or 0)

        if cache.centerX ~= cx or cache.centerY ~= cy then
            FillFrame.Position = UDim2.fromOffset(cx, cy)
            OutlineFrame.Position = UDim2.fromOffset(cx, cy)
            cache.centerX = cx
            cache.centerY = cy
        end

        local rot = tonumber(s.rotation) or 0
        if s.movingRotation then
            rot = rot + os.clock() * 360 * (tonumber(s.rotationSpeed) or 1)
        end
        rot = rot % 360

        local fillOn = s.fill == true
        if fillOn ~= cache.fillVisible then
            FillFrame.Visible = fillOn
            cache.fillVisible = fillOn
        end
        if fillOn then
            local size = radius * 2
            if cache.radius ~= size then
                FillFrame.Size = UDim2.fromOffset(size, size)
                cache.radius = size
            end
            local a, b, c = threeColors(s.fillColors)
            local ck = colorKey(a, b, c)
            if ck ~= cache.fillColorKey then
                FillGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, a),
                    ColorSequenceKeypoint.new(0.5, b),
                    ColorSequenceKeypoint.new(1, c),
                })
                cache.fillColorKey = ck
            end
            local ta, tb, tc = threeTrans(s.fillTransparency)
            local tk = transKey(ta, tb, tc)
            if tk ~= cache.fillTransKey then
                FillGradient.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, ta),
                    NumberSequenceKeypoint.new(0.5, tb),
                    NumberSequenceKeypoint.new(1, tc),
                })
                cache.fillTransKey = tk
            end
            FillGradient.Rotation = rot
        end

        local outlineOn = s.outline == true
        if outlineOn ~= cache.outlineVisible then
            OutlineFrame.Visible = outlineOn
            cache.outlineVisible = outlineOn
        end
        if outlineOn then
            local thickness = tonumber(s.outlineThickness) or 1.5
            local innerSize = (radius - thickness) * 2
            if innerSize < 0 then innerSize = 0 end
            if cache.radius ~= innerSize or cache.thickness ~= thickness then
                OutlineFrame.Size = UDim2.fromOffset(innerSize, innerSize)
                OutlineStroke.Thickness = thickness
                cache.radius = innerSize
                cache.thickness = thickness
            end
            local a, b, c = threeColors(s.outlineColors)
            local ck = colorKey(a, b, c)
            if ck ~= cache.outlineColorKey then
                OutlineGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, a),
                    ColorSequenceKeypoint.new(0.5, b),
                    ColorSequenceKeypoint.new(1, c),
                })
                cache.outlineColorKey = ck
            end
            local ta, tb, tc = threeTrans(s.outlineTransparency)
            local tk = transKey(ta, tb, tc)
            if tk ~= cache.outlineTransKey then
                OutlineGradient.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, ta),
                    NumberSequenceKeypoint.new(0.5, tb),
                    NumberSequenceKeypoint.new(1, tc),
                })
                cache.outlineTransKey = tk
            end
            OutlineGradient.Rotation = rot
        end
    end

    conn = RunService.RenderStepped:Connect(function()
        local ok, err = pcall(tick)
        if not ok then
            warn("[FOVLib:" .. name .. "]", err)
        end
    end)

    function instance:destroy()
        if conn then conn:Disconnect() conn = nil end
        if ScreenGui then pcall(function() ScreenGui:Destroy() end) ScreenGui = nil end
        FillFrame, FillGradient = nil, nil
        OutlineFrame, OutlineStroke, OutlineGradient = nil, nil, nil
    end

    return instance
end

-- targeting
getgenv().Targeting = getgenv().Targeting or {
    IgnoreEnabled = false,
    IgnoreList = {},
    AntiKatana = false,
}

local antikatana = false
local katanausers = {}

local function detectkatana()
    local lp = Players.LocalPlayer
    if not lp:FindFirstChild("PlayerScripts") then
        lp.PlayerScriptsAdded:Wait()
    end
    task.spawn(function()
        local katana, attempts = nil, 0
        while attempts < 10 do
            pcall(function()
                local m = lp.PlayerScripts.Modules.Items:FindFirstChild("Katana", true)
                if m then katana = require(m) end
            end)
            if not katana then
                for _, m in pairs(lp.PlayerScripts:GetDescendants()) do
                    if m.Name == "Katana" and m:IsA("ModuleScript") then
                        local ok, res = pcall(require, m)
                        if ok then katana = res; break end
                    end
                end
            end
            if katana and type(katana) == "table" and katana.StartAiming then break end
            attempts += 1
            task.wait(1)
        end
        if katana and type(katana) == "table" and katana.StartAiming then
            local old = katana.StartAiming
            katana.StartAiming = function(self, force)
                local fighter = self.ClientFighter
                local player  = fighter and fighter.Player
                if player then
                    katanausers[player] = true
                    local dur = self.Info.DeflectDuration or 0.6
                    task.delay(dur, function() katanausers[player] = nil end)
                end
                return old(self, force)
            end
        end
    end)
end
detectkatana()

local function katanadeflect(player)
    return katanausers[player] == true
end
getgenv().katanadeflect = katanadeflect

function Targeting.isIgnored(player)
    if not player then return false end
    return Targeting.IgnoreList[player.UserId] == true
end

function Targeting.isProtected(player)
    if not player or not player.Character then return false end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if root and root:FindFirstChild("Attachment") then
        return true
    end
    return false
end

function Targeting.shouldSkip(player)
    if Targeting.isIgnored(player) then return true end
    if Targeting.isProtected(player) then return true end
    if Targeting.AntiKatana and katanadeflect(player) then return true end
    return false
end

-- aimbot
getgenv().Aimbot = {
    Enabled = false,
    AimPart = "Head",
    Sensitivity = 15,
    Deadzone = 5,
    Prediction = 0.12,
    WallCheck = false,
    PersistTarget = false,
    PersistTime = 0.35,
    AimRadius = 100,
    UseFOV = true,
}

getgenv().AimbotFOVSettings = getgenv().AimbotFOVSettings or {
    enable = false,
    range = 100,
    movingRotation = false,
    rotation = 0,
    rotationSpeed = 1,
    fill = false,
    fillColors = {
        Color3.fromRGB(200, 200, 200),
        Color3.fromRGB(125, 125, 125),
        Color3.fromRGB(0, 0, 0),
    },
    fillTransparency = { 0.6, 0.6, 0.6 },
    outline = false,
    outlineColors = {
        Color3.fromRGB(200, 200, 200),
        Color3.fromRGB(125, 125, 125),
        Color3.fromRGB(0, 0, 0),
    },
    outlineTransparency = { 0.4, 0.4, 0.4 },
    outlineThickness = 1.5,
}

getgenv().AimbotCurrentTarget = nil
getgenv().AimbotLastTargetTime = 0

if getgenv().AimbotFOVInstance then
    pcall(function() getgenv().AimbotFOVInstance:destroy() end)
    getgenv().AimbotFOVInstance = nil
end
getgenv().AimbotFOVInstance = getgenv().FOVLib.create("Aimbot", 1000000)

function IsAimbotTargetValid(player)
    local cfg = getgenv().Aimbot
    if not isCharacterValid(player) then return false end
    if getgenv().Targeting and getgenv().Targeting.shouldSkip(player) then return false end

    local char = player.Character
    local partName = normalizePartName(cfg.AimPart)
    local part = char:FindFirstChild(partName)

    if isTeammate(player) then return false end
    if not part then return false end

    if cfg.WallCheck then
        local origin = Camera.CFrame.Position
        local direction = (part.Position - origin)

        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist

        local result = Workspace:Raycast(origin, direction, rayParams)
        if result and not result.Instance:IsDescendantOf(char) then
            return false
        end
    end
    return true
end

function GetClosestAimbotTarget()
    local cfg = getgenv().Aimbot
    local closest = nil
    local shortest = math.huge
    local mouseLocation = UserInputService:GetMouseLocation()
    local partName = normalizePartName(cfg.AimPart)

    for _, player in pairs(Players:GetPlayers()) do
        if IsAimbotTargetValid(player) then
            local part = player.Character[partName]
            if part then
                local pos, visible = Camera:WorldToViewportPoint(part.Position)
                if visible and pos.Z > 0 then
                    local dist = (mouseLocation - Vector2.new(pos.X, pos.Y)).Magnitude
                    local inFOV = (not cfg.UseFOV) or (dist <= cfg.AimRadius)
                    if inFOV and dist < shortest then
                        shortest = dist
                        closest = player
                    end
                end
            end
        end
    end
    return closest
end

do
    local function aimbotRenderTick(dt)
        local cfg = getgenv().Aimbot

        do
            local fovS = getgenv().AimbotFOVSettings
            fovS.enable = (cfg.FovShow == true)
            fovS.range = cfg.AimRadius or 100
            fovS.outline = (cfg.FovOutlineShow == true)
            fovS.fill = (cfg.FovFilled == true)
            fovS.outlineThickness = cfg.FovOutlineThickness or 1.5
            getgenv().AimbotFOVInstance:set(fovS)
        end

        if isLobbyVisible() then
            getgenv().AimbotCurrentTarget = nil
            return
        end

        if not cfg.Enabled then
            getgenv().AimbotCurrentTarget = nil
            return
        end

        if cfg.PersistTarget then
            local cur = getgenv().AimbotCurrentTarget
            if cur and IsAimbotTargetValid(cur) then
                if tick() - getgenv().AimbotLastTargetTime >= cfg.PersistTime then
                    getgenv().AimbotCurrentTarget = GetClosestAimbotTarget()
                    getgenv().AimbotLastTargetTime = tick()
                end
            else
                getgenv().AimbotCurrentTarget = GetClosestAimbotTarget()
                getgenv().AimbotLastTargetTime = tick()
            end
        else
            getgenv().AimbotCurrentTarget = GetClosestAimbotTarget()
        end

        local tgt = getgenv().AimbotCurrentTarget
        if not tgt then return end

        local partName = normalizePartName(cfg.AimPart)
        local part = tgt.Character[partName]
        if not part then return end

        local vel = part.AssemblyLinearVelocity
        local predPos = part.Position + vel * cfg.Prediction
        local pos, visible = Camera:WorldToViewportPoint(predPos)
        if not visible then return end

        local mouseLoc = UserInputService:GetMouseLocation()
        local dx = pos.X - mouseLoc.X
        local dy = pos.Y - mouseLoc.Y
        if dx * dx + dy * dy <= (cfg.Deadzone or 5) ^ 2 then return end

        local mult = math.clamp(cfg.Sensitivity or 15, 1, 100) / 100
        if mousemoverel then
            mousemoverel(dx * mult, dy * mult)
        end
    end

    Scheduler.add("aimbot", "RenderStepped", 0, aimbotRenderTick)
end

-- triggerbot
getgenv().TriggerBot = {
    Enabled = false,
    FireRate = 0,
    WallCheck = true,
    BlacklistBody = {
        Head = false, UpperTorso = false, LowerTorso = false,
        LeftUpperArm = false, LeftLowerArm = false, RightUpperArm = false, RightLowerArm = false,
        LeftUpperLeg = false, LeftLowerLeg = false, RightUpperLeg = false, RightLowerLeg = false,
    },
    BodyPartsList = {
        "Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "LeftLowerArm",
        "RightUpperArm", "RightLowerArm", "LeftUpperLeg", "LeftLowerLeg", "RightUpperLeg", "RightLowerLeg"
    }
}

function ToggleBlacklistBody(partName)
    local cfg = getgenv().TriggerBot
    if cfg.BlacklistBody[partName] ~= nil then
        cfg.BlacklistBody[partName] = not cfg.BlacklistBody[partName]
        return cfg.BlacklistBody[partName]
    end
    return false
end

function GetBlacklistBodyStatus(partName)
    return getgenv().TriggerBot.BlacklistBody[partName] or false
end

function GetBlacklistedParts()
    local blacklisted = {}
    for partName, isBlacklisted in pairs(getgenv().TriggerBot.BlacklistBody) do
        if isBlacklisted then table.insert(blacklisted, partName) end
    end
    return blacklisted
end

getgenv().TriggerBotLastFire = 0

function IsValidTriggerTarget(player)
    local cfg = getgenv().TriggerBot
    if not isCharacterValid(player) then return false end
    if getgenv().Targeting and getgenv().Targeting.shouldSkip(player) then return false end

    local character = player.Character

    if isTeammate(player) then return false end

    local isR15 = character:FindFirstChild("UpperTorso") ~= nil
    local targetParts = {}

    if isR15 then
        for _, partName in ipairs(cfg.BodyPartsList) do
            if not cfg.BlacklistBody[partName] then
                local part = character:FindFirstChild(partName)
                if part then table.insert(targetParts, part) end
            end
        end
    else
        local head = character:FindFirstChild("Head")
        local torso = character:FindFirstChild("Torso")

        if head and not cfg.BlacklistBody["Head"] then table.insert(targetParts, head) end
        if torso and not cfg.BlacklistBody["UpperTorso"] then table.insert(targetParts, torso) end
    end

    if #targetParts == 0 then return false end

    if cfg.WallCheck then
        local origin = Camera.CFrame.Position
        local checkPart = targetParts[1]
        local direction = checkPart.Position - origin
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        rayParams.FilterDescendantsInstances = { LocalPlayer.Character }

        local result = Workspace:Raycast(origin, direction, rayParams)
        if result and not result.Instance:IsDescendantOf(character) then
            return false
        end
    end

    return true, targetParts
end

function GetMouseTargetPlayer()
    local cfg = getgenv().TriggerBot
    local Mouse = LocalPlayer:GetMouse()
    local target = Mouse.Target
    if not target then return nil end

    local character = target:FindFirstAncestorOfClass("Model")
    if not character then return nil end

    if character:IsA("Accessory") then character = character.Parent end

    local targetPlayer = Players:GetPlayerFromCharacter(character)
    if not targetPlayer then return nil end

    local actualPartName = target.Name
    if target.Parent and target.Parent:IsA("Accessory") then actualPartName = "Head" end

    if cfg.BlacklistBody[actualPartName] == true then return nil end

    local isValid = IsValidTriggerTarget(targetPlayer)
    if not isValid then return nil end

    return targetPlayer
end

function Fire()
    mouse1click()
end

getgenv().TriggerBotConnection = RunService.RenderStepped:Connect(function(deltaTime)
    local success, err = pcall(function()
        local cfg = getgenv().TriggerBot

        if isLobbyVisible() then return end
        if not cfg.Enabled then return end

        local now = tick()
        if now - getgenv().TriggerBotLastFire < cfg.FireRate then return end

        local targetPlayer = GetMouseTargetPlayer()

        if targetPlayer then
            getgenv().TriggerBotLastFire = now
            Fire()
        end
    end)
    if not success then warn("TriggerBot Error: " .. tostring(err)) end
end)

-- silent aim
local ok, err = pcall(function()

local Camera = getCamera()
local Utility = require(ReplicatedStorage.Modules.Utility)
local EnumLibrary = require(ReplicatedStorage.Modules.EnumLibrary)
local GameplayUtility = require(ReplicatedStorage.Modules.GameplayUtility)

getgenv().SilentAim = {
    Enabled = false,
    AimPart = "Head",
    Method = "FOV",
    AutoShoot = false,
    ClickInterval = 0.10,
    WallCheck = false,
    FOV = 100,

    RandomAimParts = {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"},
}

getgenv().SilentAimFOVSettings = getgenv().SilentAimFOVSettings or {
    enable = false,
    range = 100,
    movingRotation = false,
    rotation = 0,
    rotationSpeed = 1,
    fill = false,
    fillColors = {
        Color3.fromRGB(200, 200, 200),
        Color3.fromRGB(125, 125, 125),
        Color3.fromRGB(0, 0, 0),
    },
    fillTransparency = { 0.6, 0.6, 0.6 },
    outline = false,
    outlineColors = {
        Color3.fromRGB(200, 200, 200),
        Color3.fromRGB(125, 125, 125),
        Color3.fromRGB(0, 0, 0),
    },
    outlineTransparency = { 0.4, 0.4, 0.4 },
    outlineThickness = 1.5,
}

getgenv().SilentAimTargetEntity = nil
getgenv().SilentAimTargetPart = nil
getgenv().SilentAimAutoClickConnection = nil
getgenv().LastClickTime = 0

if getgenv().SilentAimFOVInstance then
    pcall(function() getgenv().SilentAimFOVInstance:destroy() end)
    getgenv().SilentAimFOVInstance = nil
end
getgenv().SilentAimFOVInstance = getgenv().FOVLib.create("SilentAim", 1000001)

local function updateFOV()
    local cfg = getgenv().SilentAim
    local fovS = getgenv().SilentAimFOVSettings
    fovS.enable = (cfg.ShowFOV == true)
    fovS.range = cfg.FOV or 150
    fovS.outline = (cfg.FovOutlineShow == true)
    fovS.fill = (cfg.FovFilled == true)
    fovS.outlineThickness = cfg.FovOutlineThickness or 1.5
    getgenv().SilentAimFOVInstance:set(fovS)
end

RunService.RenderStepped:Connect(function()
    pcall(updateFOV)
end)

function getBestSilentAimTarget()
    local cfg = getgenv().SilentAim
    if isLobbyVisible() then return nil, nil end

    local closestEntity, targetPart = nil, nil
    local shortestValue = math.huge

    local viewportSize = Camera.ViewportSize
    local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)

    local localChar = LocalPlayer.Character
    local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")

    local aimPartName = normalizePartName(cfg.AimPart)
    local method = tostring(cfg.Method or "FOV"):lower()

    for _, entity in ipairs(CollectionService:GetTagged("Entity")) do
        if entity == localChar then continue end
        if not entity:IsDescendantOf(workspace) then continue end

        local hum = entity:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end

        local aimPart = getAimPart(entity, aimPartName)
        if not aimPart then continue end

        local plr = Players:GetPlayerFromCharacter(entity)
        if plr and (isTeammate(plr) or (getgenv().Targeting and getgenv().Targeting.shouldSkip(plr))) then continue end

        if cfg.WallCheck and not isEntityVisible(entity, aimPart) then continue end

        if method == "fov" then
            local sp, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
            if onScreen and sp.Z > 0 then
                local d = (Vector2.new(sp.X, sp.Y) - screenCenter).Magnitude
                if d <= cfg.FOV and d < shortestValue then
                    shortestValue = d
                    closestEntity = entity
                    targetPart = aimPart
                end
            end
        elseif method == "distance" then
            if localHRP then
                local d = (aimPart.Position - localHRP.Position).Magnitude
                if d < shortestValue then
                    shortestValue = d
                    closestEntity = entity
                    targetPart = aimPart
                end
            end
        end
    end

    return closestEntity, targetPart
end

local function stopAutoClick()
    if getgenv().SilentAimAutoClickConnection then
        getgenv().SilentAimAutoClickConnection:Disconnect()
        getgenv().SilentAimAutoClickConnection = nil
    end
end

local function startAutoClick()
    if getgenv().SilentAimAutoClickConnection then return end
    getgenv().SilentAimAutoClickConnection = RunService.Heartbeat:Connect(function()
        local cfg = getgenv().SilentAim
        if not cfg.AutoShoot then stopAutoClick() return end
        if isLobbyVisible() then return end
        if not getgenv().SilentAimTargetEntity then return end

        local now = tick()
        if now - getgenv().LastClickTime >= cfg.ClickInterval then
            getgenv().LastClickTime = now
            mouse1click()
        end
    end)
end

local oldGetEntities = GameplayUtility.GetEntitiesFromRaycast
GameplayUtility.GetEntitiesFromRaycast = function(self, envID, params, origin, dir, maxDist, ...)
    if getgenv().SilentAim.Enabled and getgenv().SilentAimTargetPart then
        local t = getgenv().SilentAimTargetPart
        local dist = (t.Position - origin).Magnitude
        dir = (t.Position - origin).Unit
        maxDist = math.max(maxDist or 0, dist + 5)
    end
    return oldGetEntities(self, envID, params, origin, dir, maxDist, ...)
end

local function CFD(origin, part)
    local cf = part.CFrame
    return {
        [utf8.char(1)] = {
            [utf8.char(0)] = Utility:EncodeCFrame(CFrame.lookAt(origin, part.Position)),
            [utf8.char(1)] = Utility:EncodeCFrame(cf),
            [utf8.char(2)] = part,
            [utf8.char(3)] = Utility:EncodeCFrame(cf:ToObjectSpace(CFrame.new(part.Position))),
        }
    }
end

local startShootEnum = EnumLibrary:ToEnum("StartShooting")
local oldFireServer
oldFireServer = hookfunction(
    ReplicatedStorage.Remotes.Replication.Fighter.UseItem.FireServer,
    newcclosure(function(self, objID, enumVal, camdata, extra)
        if getgenv().SilentAim.Enabled and enumVal == startShootEnum and getgenv().SilentAimTargetPart then
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                camdata = CFD(root.Position, getgenv().SilentAimTargetPart)
            end
        end
        return oldFireServer(self, objID, enumVal, camdata, extra)
    end)
)

pcall(function()
    local gun = require(LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
    if gun then
        gun.IsFullyAiming = function() return true end
    end
end)

do
    local saAccum = 0
    local lastCamCFrame = Camera.CFrame

    local function silentAimTargetTick(dt)
        saAccum += dt
        local camMoved = (Camera.CFrame.Position - lastCamCFrame.Position).Magnitude > 0.5
            or Camera.CFrame.LookVector:Dot(lastCamCFrame.LookVector) < 0.999
        lastCamCFrame = Camera.CFrame

        local interval = camMoved and 0.03 or 0.15
        if saAccum < interval then return end
        saAccum = 0

        if getgenv().SilentAim.Enabled or getgenv().SilentAim.AutoShoot then
            getgenv().SilentAimTargetEntity, getgenv().SilentAimTargetPart = getBestSilentAimTarget()
        else
            getgenv().SilentAimTargetEntity, getgenv().SilentAimTargetPart = nil, nil
        end

        if getgenv().SilentAim.AutoShoot then
            if not getgenv().SilentAimAutoClickConnection then startAutoClick() end
        else
            stopAutoClick()
        end
    end

    Scheduler.add("silentaim_target", "Heartbeat", 0, silentAimTargetTick)
end
end)
if not ok then
    warn("SilentAim load error: " .. tostring(err))
end

-- Ragebot
getgenv().InstanceModuleCache = getgenv().InstanceModuleCache or {}

getgenv().shouldSuppressGameplayOverlays = getgenv().shouldSuppressGameplayOverlays or function()
    return false
end
local shouldSuppressGameplayOverlays = getgenv().shouldSuppressGameplayOverlays

local function instanceSafeRequire(moduleRef, timeoutSec)
    local cache = getgenv().InstanceModuleCache
    local key = typeof(moduleRef) == "Instance" and moduleRef:GetFullName() or tostring(moduleRef)
    if cache[key] ~= nil then return cache[key] end

    local deadline = timeoutSec and (os.clock() + timeoutSec) or math.huge
    local lastErr
    while os.clock() < deadline do
        if typeof(moduleRef) == "Instance" and not moduleRef.Parent then
            task.wait(0.1)
        else
            local ok, result = pcall(require, moduleRef)
            if ok then
                cache[key] = result
                return result
            end
            lastErr = result
            task.wait(0.1)
        end
    end
    error("[instance] module load failed: " .. key .. " (" .. tostring(lastErr) .. ")")
end

getgenv().InstanceRequire = instanceSafeRequire
getgenv().instanceSafeRequire = instanceSafeRequire

local Camera = getCamera()

getgenv().InstanceCombatLastShotAt = getgenv().InstanceCombatLastShotAt or 0
getgenv().InstanceUndergroundEnabled = getgenv().InstanceUndergroundEnabled or false

local function markCombatShot()
    getgenv().InstanceCombatLastShotAt = tick()
end
getgenv().InstanceMarkCombatShot = markCombatShot

getgenv().InstanceWorldToScreen = getgenv().InstanceWorldToScreen or worldToScreen
getgenv().InstanceScreenCenter = getgenv().InstanceScreenCenter or screenCenter

getgenv().ragebot = getgenv().ragebot or {}
local ragebot = getgenv().ragebot

do

local replicatedstorage = ReplicatedStorage
local players = Players
local runsvc = RunService
local userinput = UserInputService
local workspace = Workspace

local player = LocalPlayer
local camera = getCamera()

local modules = {
    enums = instanceSafeRequire(replicatedstorage.Modules.EnumLibrary),
    fighter = instanceSafeRequire(player.PlayerScripts.Controllers.FighterController),
    camcontrol = instanceSafeRequire(player.PlayerScripts.Controllers.CameraController),
    utility = instanceSafeRequire(replicatedstorage.Modules.Utility)
}

local MATCH_ID_ATTRS = {"MatchId", "DuelId", "RoundId", "GameId", "MatchUUID", "ArenaId", "InstanceId"}
local DUEL_STATE_ATTRS = {"InDuel", "InMatch", "InRound", "InGame", "InFight", "IsInMatch", "IsInDuel", "MatchActive", "Fighting"}
local SPAWN_SAFE_ATTRS = {"InSpawn", "InLobby", "IsSpectating", "InSafeZone", "InIntermission", "IsRespawning"}

local function inLive(targetPlr)
    if not targetPlr then return false end
    local live = workspace:FindFirstChild("Live")
    if not live then return false end
    if live:FindFirstChild(targetPlr.Name) then return true end
    if live:FindFirstChild(tostring(targetPlr.UserId)) then return true end
    for _, child in ipairs(live:GetChildren()) do
        if child.Name == targetPlr.Name or child.Name == tostring(targetPlr.UserId) then
            return true
        end
    end
    local char = targetPlr.Character
    if char and (char.Parent == live or char:IsDescendantOf(live)) then
        return true
    end
    local fc = modules.fighter
    if fc and type(fc.GetFighter) == "function" then
        local ok, fighter = pcall(fc.GetFighter, fc, targetPlr)
        if ok and fighter and fighter.Entity and fighter.Entity.Parent then
            if fighter.Entity.Parent == live or fighter.Entity:IsDescendantOf(live) then
                return true
            end
        end
    end
    return false
end

local function plrMid(targetPlr)
    if not targetPlr then return nil end
    for _, key in ipairs(MATCH_ID_ATTRS) do
        local v = targetPlr:GetAttribute(key)
        if v ~= nil and v ~= "" and v ~= 0 and v ~= false then
            return tostring(v)
        end
    end
    local char = targetPlr.Character
    if char then
        for _, key in ipairs(MATCH_ID_ATTRS) do
            local v = char:GetAttribute(key)
            if v ~= nil and v ~= "" and v ~= 0 and v ~= false then
                return tostring(v)
            end
        end
    end
    return nil
end

local function liveMatch()
    local lp = player
    if not lp then return false end
    for _, key in ipairs(SPAWN_SAFE_ATTRS) do
        local v = lp:GetAttribute(key)
        if v == true or v == 1 or v == "true" then
            return false
        end
    end
    local char = lp.Character
    if not char then return false end
    for _, key in ipairs(SPAWN_SAFE_ATTRS) do
        local cv = char:GetAttribute(key)
        if cv == true or cv == 1 or cv == "true" then
            return false
        end
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local myRoot = char:FindFirstChild("HumanoidRootPart")
    if not hum or hum.Health <= 0 or not myRoot then return false end
    for _, key in ipairs(DUEL_STATE_ATTRS) do
        local v = lp:GetAttribute(key)
        if v == true or v == 1 or v == "true" then
            return true
        end
        local cv = char:GetAttribute(key)
        if cv == true or cv == 1 or cv == "true" then
            return true
        end
    end
    if inLive(lp) then
        return true
    end
    local fc = modules.fighter
    if fc and fc.LocalFighter and fc.LocalFighter.Entity and fc.LocalFighter.Entity.Parent then
        return true
    end
    local myMatchId = plrMid(lp)
    if myMatchId then
        for _, plr in players:GetPlayers() do
            if plr ~= lp and plrMid(plr) == myMatchId then
                return true
            end
        end
    end
    if fc then
        for _, list in ipairs({ fc.Fighters, fc.AllFighters }) do
            if list then
                for _, f in pairs(list) do
                    if f and f.Player and f.Player ~= lp and (f.IsEnemy or f.Enemy) then
                        local fChar = f.Player.Character
                        local fHum = fChar and fChar:FindFirstChildOfClass("Humanoid")
                        if fHum and fHum.Health > 0 then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

local _instanceLobbyCache = { t = 0, v = true }
local function lobbyCache()
    local now = os.clock()
    if now - _instanceLobbyCache.t < 0.15 then
        return _instanceLobbyCache.v
    end
    _instanceLobbyCache.t = now
    _instanceLobbyCache.v = not liveMatch()
    return _instanceLobbyCache.v
end

getgenv().InstanceIsInActiveMatch = liveMatch
getgenv().InstanceIsInLobby = lobbyCache

local _rageHbTick = 0
local _rageImmuneCheckAt = 0
local _rageRoundPollAt = 0

getgenv().ragebot.config = {
    target = {
        enabled = false,
        character = nil,
        auto = false,
        autoshoot = true,
        shootAttempts = 1,
        hitpart = "head",
        lastchar = nil,
        lastplayer = nil,
        manualkey = false,
        immune = true,
        attackPosition = "default",
        attackCustomEnabled = false,
        weaponPick = "primary",
        forceWeapon = true,
        rageMasterOn = false,
        meleeFeetDrop = 3.5,
        underOffset = 4,
        customHeight = 2,
        customFront = 0,
        customSide = 0,
        customVertical = 0,
        customRadius = 0,
    },
    prediction = {
        enabled = false,
        multiplier = 1.2,
        velocity = Vector3.new(0, 0, 0),
        acceleration = Vector3.new(0, 0, 0),
        lastposition = nil,
        lasttime = 0,
        velbuffer = {},
        posbuffer = {},
        maxvelsamples = 15,
        maxpossamples = 5
    },
    orbit = {
        active = false,
        angle = 0,
        serverpos = nil,
        connection = nil,
        speed = 9000,
        height = 1,
        radius = 0,
        originalpos = nil
    },
    state = {
        reloading = false,
        outofammo = false,
        csyncactive = false,
        reloadStartedAt = 0,
    },
    voidhide = {
        enabled = false,
        originalPosition = nil,
        active = false,
        connection = nil,
        hopInterval = 0.01,
        radiusXZ = 5000,
        heightMin = -5000,
        heightMax = -5000,
    },
    voidspam = {
        enabled = false,
        shoot_min = 1,
        shoot_max = 1,
        hide_min = 1,
        hide_max = 1,
        phase = nil,
        lastswitch = 0,
        currentduration = 0
    },
    visualizer = {
        enabled = true,
        tracer = {
            color = Color3.fromRGB(0, 186, 255),
            thickness = 1,
            transparency = 1,
            start_point = "cursor",
            outline = true,
            outline_color = Color3.fromRGB(0, 0, 0),
            outline_thickness = 1
        },
        indicator = {
            display_options = {"name", "position", "hit reg"},
            color = Color3.fromRGB(255, 255, 255),
            accent_color = Color3.fromRGB(0, 186, 255)
        }
    },
    hitNotifications = {
        enabled = true,
        color = Color3.fromRGB(235, 235, 235),
        textSize = 14,
        maxVisible = 8,
        duration = 3,
        stackGap = 6,
        position = "Top Left",
        offsetX = 12,
        offsetY = 12,
        inAnimation = "fade bounce",
        outAnimation = "fade",
        animInDuration = 0.52,
        animOutDuration = 0.38,
    },
    ragestatus = {
        enabled = false,
        mode = "static",
        color = Color3.fromRGB(235, 235, 235),
        staticOffsetX = 0,
        staticOffsetY = 40,
        showAmmo = true,
        hideOnReload = true,
        textSize = 15,
        lineGap = 15,
        fontName = "gotham",
    },
}

getgenv().ragebot.ragePerf = {
    lastAttackTick = 0,
    hitPartByPlayer = {},
    lastHitAtByPlayer = {},
    targetHudAt = 0,
    rageStatusAt = 0,
    restoreVisualAt = 0,
    killStartAt = nil,
    rageStatusCacheAt = 0,
    cachedRageStatusLine = "",
    cachedRageStatusDetail = "",
    lastRageStatusText = "",
    lastRageDetailText = "",
    lastRageAmmoText = "",
    lastRageColor = nil,
}

getgenv().ragebot.vhState = {
    active = false,
    hrp = nil,
    mainConnection = nil,
    restoreConnection = nil,
    currentVoidPos = nil,
    lastTeleportTime = 0
}

local config = getgenv().ragebot.config
local ragePerf = getgenv().ragebot.ragePerf
local vhState = getgenv().ragebot.vhState

local function clampVs(v)
    return math.clamp(tonumber(v) or 1, 0.1, 2)
end

local function randVs(minT, maxT)
    local a = clampVs(minT)
    local b = clampVs(maxT)
    if b < a then a, b = b, a end
    if a == b then return a end
    return a + math.random() * (b - a)
end

local function voidHrp()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local ServerCFrameForger = {}
ServerCFrameForger.__index = ServerCFrameForger

function ServerCFrameForger.new(hrp)
    return setmetatable({
        _hrp = hrp,
        _serverCF = nil,
        _clientCF = nil,
        _lastClientLV = nil,
        _lastClientAV = nil,
    }, ServerCFrameForger)
end

function ServerCFrameForger:SetServerCFrame(cf)
    self._serverCF = cf
end

function ServerCFrameForger:ClearServerCFrame()
    self._serverCF = nil
    self._clientCF = nil
    self._lastClientLV = nil
    self._lastClientAV = nil
end

function ServerCFrameForger:Apply()
    if not self._serverCF or not self._hrp or not self._hrp.Parent then return end
    if not self._clientCF then
        self._clientCF = self._hrp.CFrame
        self._lastClientLV = self._hrp.AssemblyLinearVelocity
        self._lastClientAV = self._hrp.AssemblyAngularVelocity
    end
    self._hrp.CFrame = self._serverCF
end

function ServerCFrameForger:Restore()
    if self._clientCF and self._hrp and self._hrp.Parent then
        self._hrp.CFrame = self._clientCF
        self._hrp.AssemblyLinearVelocity = self._lastClientLV or Vector3.zero
        self._hrp.AssemblyAngularVelocity = self._lastClientAV or Vector3.zero
    end
    self._clientCF = nil
end

function ServerCFrameForger:GetServerPosition()
    return self._serverCF and self._serverCF.Position or nil
end

getgenv().ServerCFrameForger = ServerCFrameForger

local VFR_LIMIT = 2147483646
local VFR_DEAD  = 1147483646

local function rndSkip(mi, ma, dmi, dma)
    local v = math.random(mi, ma)
    local n = 0
    while v >= dmi and v <= dma and n < 16 do
        v = math.random(mi, ma); n += 1
    end
    return v
end

local serverForger = ServerCFrameForger.new(voidHrp())
getgenv().ragebot.serverForger = serverForger

local START_SHOOTING_ENUM = modules.enums:ToEnum("StartShooting")

local useItemRemote = replicatedstorage.Remotes.Replication.Fighter.UseItem
local _cachedObjId

local function getShootCache(equipped)
    local oid = equipped:Get("ObjectID")
    if oid ~= _cachedObjId then
        _cachedObjId = oid
    end
    return _cachedObjId, START_SHOOTING_ENUM
end

local vfrLim, vfrDead = 2147483646, 1147483646
local vfrSnap = { cf = nil, lv = nil, av = nil }

local function clrVoidSnap()
    vfrSnap.cf, vfrSnap.lv, vfrSnap.av = nil, nil, nil
end

local function snapVoid(hrp)
    if not hrp then return end
    if lobbyCache() then return end
    vfrSnap.cf = hrp.CFrame
    vfrSnap.lv = hrp.AssemblyLinearVelocity
    vfrSnap.av = hrp.AssemblyAngularVelocity
    local lim, dead = vfrLim, vfrDead
    pcall(function()
        local p = Vector3.new(
            rndSkip(-lim, lim, -dead, dead),
            rndSkip(-lim, lim, -dead, dead),
            rndSkip(-lim, lim, -dead, dead)
        )
        local v = Vector3.new(
            rndSkip(-lim, lim, -dead, dead),
            rndSkip(-lim, lim, -dead, dead),
            rndSkip(-lim, lim, -dead, dead)
        )
        hrp.CFrame = CFrame.new(p) * CFrame.Angles(math.pi, math.pi, math.pi)
        hrp.AssemblyLinearVelocity = v
        hrp.AssemblyAngularVelocity = v
    end)
    task.defer(function()
        if hrp and hrp.Parent and vfrSnap.cf then
            pcall(function()
                hrp.CFrame = vfrSnap.cf
                hrp.AssemblyLinearVelocity = vfrSnap.lv
                hrp.AssemblyAngularVelocity = vfrSnap.av
            end)
        end
    end)
end

local vfrCsyncDead = false
local vfrCsyncConn = runsvc:BindToRenderStep("vfr_csync", Enum.RenderPriority.First.Value, function()
    if vfrCsyncDead then return end
    if not vfrSnap.cf then return end
    if not player or not player.Parent then
        vfrCsyncDead = true
        pcall(function() runsvc:UnbindFromRenderStep("vfr_csync") end)
        return
    end
    local okHrp, hrp = pcall(voidHrp)
    if not okHrp or not hrp or not hrp.Parent or not hrp:IsDescendantOf(game) then return end
    pcall(function()
        hrp.CFrame = vfrSnap.cf
        hrp.AssemblyLinearVelocity = vfrSnap.lv
        hrp.AssemblyAngularVelocity = vfrSnap.av
    end)
end)
getgenv().vfrCsyncConn = vfrCsyncConn
getgenv().killVfrCsync = function()
    vfrCsyncDead = true
    pcall(function() runsvc:UnbindFromRenderStep("vfr_csync") end)
end

getgenv().ragebotSnapVoid = snapVoid
getgenv().snapVoid = snapVoid

local lastEvade = 0
local EVADE_INTERVAL = 0.15

local function maybeEvade()
    if not config.target.enhancedEvasion then return end
    local now = tick()
    if now - lastEvade < EVADE_INTERVAL then return end
    lastEvade = now
    local hrp = voidHrp()
    if not hrp then return end
    snapVoid(hrp)
end

local function rageOn()
    return config.target.rageMasterOn == true
end


LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    serverForger._hrp = voidHrp()
    serverForger:ClearServerCFrame()
end)

local function getServerOriginOffset(isCrouching)
    return Vector3.new(0, isCrouching, 0.25 or 1.75, 0)
end

local function getRealShootPos(character)
    if not character then return Vector3.new() end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return Vector3.new() end
    local hum = character:FindFirstChildOfClass("Humanoid")
    local crouching = false
    if hum then
        local ok, state = pcall(function() return hum:GetState() end)
        if ok and state then
            crouching = (state == Enum.HumanoidStateType.RunningNoPhysics)
                or (state == Enum.HumanoidStateType.Physics)
        end
        local attr = character:GetAttribute("IsCrouching")
        if attr == true then crouching = true end
    end
    return root.Position + getServerOriginOffset(crouching)
end

local function targetIsHiding(targetChar)
    if not targetChar then return true end
    local root = targetChar:FindFirstChild("HumanoidRootPart")
    if not root then return true end
    local pos = root.Position
    if math.abs(pos.X) > 1e6 or math.abs(pos.Z) > 1e6 or pos.Y < -1e5 then
        return true
    end
    return false
end

local function targetFacingMe(targetRoot, attackerPos)
    if not targetRoot then return 0 end
    local look = targetRoot.CFrame.LookVector
    local toMe = attackerPos - targetRoot.Position
    toMe = Vector3.new(toMe.X, 0, toMe.Z)
    if toMe.Magnitude < 0.01 then return 0 end
    toMe = toMe.Unit
    return look:Dot(toMe)
end

local function pickBestHitPart(character, attackerPos, targetRoot)
    if not character then return nil end
    local facingDot = targetFacingMe(targetRoot, attackerPos)
    local preferBack = facingDot > 0.6

        local candidates
    if preferBack then
        candidates = {
            "HitboxHeadSmall", "HitboxBodySmall",
            "UpperTorso", "LowerTorso", "HumanoidRootPart",
        }
    else
        candidates = {
            "HitboxHead", "HitboxBody",
            "Head", "UpperTorso",
        }
    end

    for _, name in ipairs(candidates) do
        local p = character:FindFirstChild(name, true)
        if p and p:IsA("BasePart") then
            return p
        end
    end
    return character:FindFirstChild("Head")
end

local function targetIsAttacking(character)
    if not character then return false end
    local lf = modules.fighter and modules.fighter.LocalFighter
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return false end
    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
        local name = track.Name:lower()
        if name:find("attack") or name:find("swing") or name:find("slash") then
            return true
        end
    end
    return false
end

local localfighter = modules.fighter.LocalFighter
local oldpos

local indicator = Drawing.new("Circle")
indicator.Thickness = 1.5
indicator.NumSides = 36
indicator.Filled = false
indicator.Transparency = 1
indicator.Visible = false
indicator.Radius = 12
indicator.Color = Color3.fromRGB(255, 50, 50)

local indicatoroutline = Drawing.new("Circle")
indicatoroutline.Thickness = 4
indicatoroutline.NumSides = 36
indicatoroutline.Filled = false
indicatoroutline.Transparency = 1
indicatoroutline.Visible = false
indicatoroutline.Radius = 12
indicatoroutline.Color = Color3.fromRGB(0, 0, 0)

local tracerline = Drawing.new("Line")
tracerline.Visible = false
tracerline.Thickness = 2
tracerline.Transparency = 1
tracerline.Color = Color3.fromRGB(0, 186, 255)

local traceroutline = Drawing.new("Line")
traceroutline.Visible = false
traceroutline.Thickness = 4
traceroutline.Transparency = 1
traceroutline.Color = Color3.fromRGB(0, 0, 0)

local lastdamagetime = {}

local function getweapon()
    local viewmodels = workspace:FindFirstChild("ViewModels")
    if not viewmodels then return nil end
    local firstperson = viewmodels:FindFirstChild("FirstPerson")
    if not firstperson then return nil end
    for _, child in ipairs(firstperson:GetChildren()) do
        local parts = {}
        for part in child.Name:gmatch("[^-]+") do
            table.insert(parts, part:match("^%s*(.-)%s*$"))
        end
        if #parts >= 2 then
            return parts[2]
        end
    end
    return nil
end

local function muzzlepos()
    local viewModels = workspace:FindFirstChild("ViewModels")
    if not viewModels then return nil end
    local firstPerson = viewModels:FindFirstChild("FirstPerson")
    if not firstPerson then return nil end
    for _, model in pairs(firstPerson:GetChildren()) do
        if model.Name:find(player.Name) then
            local itemVisual = model:FindFirstChild("ItemVisual")
            if itemVisual then
                local body = itemVisual:FindFirstChild("Body")
                if body then
                    local bodyPrimary = body:FindFirstChild("BodyPrimary")
                    if bodyPrimary then
                        local muzzle = bodyPrimary:FindFirstChild("_muzzle")
                        if muzzle then
                            return muzzle.WorldPosition
                        end
                    end
                end
            end
        end
    end
    return nil
end

local SLOTS = { primary = 1, secondary = 2, melee = 3 }
local MELEE_NMS = {
    ["Battle Axe"] = true, ["Chainsaw"] = true, ["Daggers"] = true, ["Fists"] = true,
    ["Gunblade"] = true, ["Katana"] = true, ["Knife"] = true,
    ["Scythe"] = true, ["Trowel"] = true,
}
local INFINITE_AMMO_WEAPONS = {
    ["Energy Rifle"] = true,
    ["Energy Pistols"] = true,
}

local function isInfiniteWeapon()
    local w = getweapon()
    if not w then return false end
    return INFINITE_AMMO_WEAPONS[w] == true
end

local function wantSlot()
    return SLOTS[config.target.weaponPick or "primary"] or 1
end

local function pickMelee()
    return (config.target.weaponPick or "primary") == "melee"
end

local function getammo()
    if isInfiniteWeapon() then return nil, nil, false end
    local success, controller = pcall(function()
        return instanceSafeRequire(player.PlayerScripts.Controllers.FighterController)
    end)
    if success and controller and controller.LocalFighter and controller.LocalFighter.EquippedItem then
        local item = controller.LocalFighter.EquippedItem
        local itemName, current, maxAmmo = "", 0, 0
        local isMelee = false
        local ok = pcall(function()
            itemName = tostring(item:Get("Name") or item.Name or "")
            current = item:Get("CurrentAmmo") or item:Get("Ammo") or 0
            maxAmmo = item:Get("MaxAmmo") or item:Get("MaxBullets") or current
            if type(itemName) == "string" and itemName:lower():find("melee", 1, true) then
                isMelee = true
            end
            if MELEE_NMS[itemName] then isMelee = true end
        end)
        if not ok then
            return 0, 0, pickMelee()
        end
        if pickMelee() then isMelee = true end
        return tonumber(current) or 0, tonumber(maxAmmo) or 0, isMelee
    end
    return 0, 0, pickMelee()
end

local function meleeNm(nm)
    if type(nm) ~= "string" or nm == "" then return false end
    if nm:lower():find("melee", 1, true) then return true end
    return MELEE_NMS[nm] == true
end

local function itemMelee(item)
    if not item then return false end
    local nm = item:Get("Name") or item.Name
    if meleeNm(nm) then return true end
    local t = item:Get("ItemType") or item:Get("Type") or item:Get("Category")
    return type(t) == "string" and t:lower():find("melee", 1, true) ~= nil
end

local function isSling(weapon)
    return weapon and weapon:lower():find("slingshot", 1, true) ~= nil
end

local function lfItems()
    local lf = modules.fighter and modules.fighter.LocalFighter
    if not lf then return nil end
    return lf.Items
end

local function slotItem(slotIdx)
    local items = lfItems()
    if not items then return nil end
    if items[slotIdx] then return items[slotIdx] end
    if items[tostring(slotIdx)] then return items[tostring(slotIdx)] end
    for key, it in pairs(items) do
        if it and typeof(it) == "table" then
            local s = tonumber(it:Get("Slot") or it:Get("Index") or it:Get("ItemSlot") or key)
            if s == slotIdx then return it end
            local t = it:Get("ItemType") or it:Get("Type")
            if slotIdx == 3 and (t == "Melee" or (type(t) == "string" and t:lower():find("melee", 1, true))) then
                return it
            end
            if slotIdx == 1 and (t == "Primary" or t == 1 or t == "1") then return it end
            if slotIdx == 2 and (t == "Secondary" or t == 2 or t == "2") then return it end
        end
    end
    local ordered = {}
    for _, it in pairs(items) do
        if it then ordered[#ordered + 1] = it end
    end
    table.sort(ordered, function(a, b)
        local sa = tonumber(a:Get("Slot") or a:Get("Index")) or 99
        local sb = tonumber(b:Get("Slot") or b:Get("Index")) or 99
        return sa < sb
    end)
    return ordered[slotIdx]
end

local function whichSlot(item)
    if not item then return nil end
    local items = lfItems()
    local oid = item:Get("ObjectID")
    if items and oid then
        for idx = 1, 3 do
            local it = items[idx] or items[tostring(idx)]
            if it and it:Get("ObjectID") == oid then return idx end
        end
        for key, it in pairs(items) do
            if it and it:Get("ObjectID") == oid then
                local n = tonumber(key)
                if n and n >= 1 and n <= 3 then return n end
            end
        end
    end
    if itemMelee(item) then return 3 end
    return nil
end

local rageLastSlotForce = 0

local function pressSlot(slotIdx)
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        local kc = ({ Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three })[slotIdx]
        if not kc then return end
        vim:SendKeyEvent(true, kc, false, game)
        task.wait(0.02)
        vim:SendKeyEvent(false, kc, false, game)
    end)
    if keypress then
        pcall(keypress, ({ 0x31, 0x32, 0x33 })[slotIdx])
        task.wait(0.02)
        if keyrelease then pcall(keyrelease, ({ 0x31, 0x32, 0x33 })[slotIdx]) end
    end
end

local function eqSlot()
    if not rageOn() then return end
    local want = wantSlot()
    local lf = modules.fighter and modules.fighter.LocalFighter
    if not lf then return end
    local eq = lf.EquippedItem
    if eq and whichSlot(eq) == want then return end
    local now = tick()
    if now - rageLastSlotForce < 0.08 then return end
    rageLastSlotForce = now
    local item = slotItem(want)
    local oid = item and item:Get("ObjectID")
    if oid then
        local rm = replicatedstorage.Remotes.Replication.Fighter.UseItem
            for _, en in ipairs({ "Equip", "Switch", "Select", "EquipItem", "ChangeItem", "SwitchSlot" }) do
            pcall(function()
                local ev = modules.enums:ToEnum(en)
                if ev then rm:FireServer(oid, ev, nil, nil) end
            end)
        end
    end
    pcall(function()
        if lf.EquipItem then lf:EquipItem(want) end
        if lf.Equip then lf:Equip(want) end
        if lf.SwitchToSlot then lf:SwitchToSlot(want) end
    end)
    pcall(function()
        local fc = modules.fighter
        if fc.EquipItem then fc:EquipItem(want) end
        if fc.SwitchItem then fc:SwitchItem(want) end
    end)
    pressSlot(want)
end

local function itemReload()
    if isInfiniteWeapon() then return false end
    local lf = modules.fighter and modules.fighter.LocalFighter
    if not lf or not lf.EquippedItem then return false end
    local result = false
    pcall(function()
        local item = lf.EquippedItem
        for _, key in ipairs({ "Reloading", "IsReloading", "IsReload" }) do
            local value = item:Get(key)
            if value == true or value == 1 or value == "true" then
                result = true
                return
            end
        end
    end)
    if result then return true end
    local started = config.state.reloadStartedAt or 0
    return started > 0 and (tick() - started) < 1.75
end

local function tickAmmo()
    if isInfiniteWeapon() then
        config.state.outofammo = false
        config.state.reloading = false
        config.state.reloadStartedAt = 0
        return
    end
    local current, maxAmmo, melee = getammo()
    local wasOutOfAmmo = config.state.outofammo
    if melee then
        config.state.outofammo = false
    else
        config.state.outofammo = (tonumber(current) or 0) <= 0
    end
    local reloading = itemReload()
    if reloading and not config.state.reloading then
        config.state.reloadStartedAt = tick()
    elseif not reloading then
        config.state.reloadStartedAt = 0
    end
    config.state.reloading = reloading
        if config.state.outofammo and not wasOutOfAmmo then
        if config.voidspam.enabled then
            config.voidspam.phase = "hide"
            config.voidspam.currentduration =
                randVs(config.voidspam.hide_min, config.voidspam.hide_max)
            config.voidspam.lastswitch = tick()
        elseif isSling(getweapon()) then
            config.voidspam.phase = "hide"
        end
    elseif not config.state.outofammo and wasOutOfAmmo then
        if config.voidspam.enabled then
            config.voidspam.phase = "shoot"
            config.voidspam.currentduration =
                randVs(config.voidspam.shoot_min, config.voidspam.shoot_max)
            config.voidspam.lastswitch = tick()
        else
            config.voidspam.phase = nil
        end
    end
end

local function reloadHide(sling)
    if not (config.state.reloading and config.ragestatus.hideOnReload) then
        return false
    end
    local hrp = voidHrp()
    if hrp and not sling then
        snapVoid(hrp)
        return true
    end
    local randomX = math.random(-10000, 10000)
    local randomZ = math.random(-10000, 10000)
    config.orbit.serverpos = Vector3.new(randomX, -99999999999, randomZ)
    if sling and localfighter and localfighter.Entity and localfighter.Entity.RootPart then
        pcall(function()
            localfighter.Entity.RootPart.CFrame = CFrame.new(config.orbit.serverpos)
        end)
    end
    return true
end

local function isteammate(targetplayer)
    if not targetplayer then return false end

    local char = targetplayer.Character
    if not char then return false end

    local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart and humanoidRootPart:FindFirstChild("TeammateLabel") then
        return true
    end

    return false
end

local function valid(char)
    if not char or not char.Parent then return false end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    if not char:FindFirstChild("HumanoidRootPart") then return false end
    local targetplayer = players:GetPlayerFromCharacter(char)
    if not targetplayer or isteammate(targetplayer) then return false end
    if getgenv().Targeting and getgenv().Targeting.shouldSkip(targetplayer) then return false end
    return true
end

local function nearest()
    local cursorpos = userinput:GetMouseLocation()
    local besttarget = nil
    local bestdistance = math.huge
    for _, targetplayer in players:GetPlayers() do
        if targetplayer ~= player and targetplayer.Character then
            local char = targetplayer.Character
            if valid(char) then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    local wts = getgenv().InstanceWorldToScreen or worldToScreen
                    local screenpos, onscreen = wts(root.Position, camera)
                    if onscreen and screenpos then
                        local distance = (Vector2.new(screenpos.X, screenpos.Y) - cursorpos).Magnitude
                        if distance < bestdistance then
                            besttarget = char
                            bestdistance = distance
                        end
                    end
                end
            end
        end
    end
    return besttarget
end

local function hitpartfromname(character, partname)
    if not character then return nil end
    partname = normalizePartName(partname)
    if partname == "Closest" then
        local mypos = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not mypos then return character:FindFirstChild("Head") end
        local closest, dist = nil, math.huge
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                local d = (part.Position - mypos.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = part
                end
            end
        end
        return closest or character:FindFirstChild("Head")
    elseif partname == "Random" then
        local parts = {"Head", "HumanoidRootPart", "UpperTorso"}
        return character:FindFirstChild(parts[math.random(#parts)]) or character:FindFirstChild("Head")
    else
        return character:FindFirstChild(partname) or character:FindFirstChild("Head")
    end
end

local function updatevel()
    if not config.target.character or not config.prediction.enabled then
        config.prediction.velocity = Vector3.new(0, 0, 0)
        config.prediction.lastposition = nil
        return
    end
    local root = config.target.character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local now = tick()
    local dt = now - config.prediction.lasttime
    if dt > 0 and dt < 0.1 then
        local currentpos = root.Position
        if config.prediction.lastposition then
            local instantvel = (currentpos - config.prediction.lastposition) / dt
            config.prediction.velocity = config.prediction.velocity:Lerp(instantvel, 0.6)
        end
        config.prediction.lastposition = currentpos
        config.prediction.lasttime = now
    end
end

local function predict(targetpart, origin, weaponSpeed)
    if not config.prediction.enabled or not targetpart then
        return targetpart and targetpart.Position or Vector3.zero
    end
    weaponSpeed = weaponSpeed or 3000

    local basepos  = targetpart.Position
    local distance = (basepos - origin).Magnitude
    local ping     = player:GetNetworkPing()

    local traveltime = distance / weaponSpeed
    local latency    = ping * 0.5 + 0.016
    local totaltime  = (traveltime + latency) * (config.prediction.multiplier or 1.2)

    local root = config.target.character and config.target.character:FindFirstChild("HumanoidRootPart")
    local v
    if root then
        v = root.AssemblyLinearVelocity
    else
        v = config.prediction.velocity or Vector3.zero
    end
    local acc = config.prediction.acceleration or Vector3.zero

    totaltime = math.min(totaltime, 0.5)

    local predicted = basepos + v * totaltime + 0.5 * acc * totaltime * totaltime

    local maxShift = math.max(400, v.Magnitude * totaltime * 1.5)
    if (predicted - basepos).Magnitude > maxShift then
        predicted = basepos + v * totaltime
    end
    return predicted
end

local function canuse()
    local char = player.Character
    if not char then return false end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    if isInfiniteWeapon() then return true end
    local current, _, melee = getammo()
    if current == nil then return true end
    return current > 0 or melee
end

local function clampVs(v)
    return math.clamp(tonumber(v) or 1, 0.1, 2)
end

local function randVs(minT, maxT)
    local a = clampVs(minT)
    local b = clampVs(maxT)
    if b < a then
        a, b = b, a
    end
    if a == b then
        return a
    end
    return a + math.random() * (b - a)
end

local function clrVoidSnap()
    if serverForger then
        serverForger:ClearServerCFrame()
    end
end

local function atkCfg()
    if pickMelee() and not config.target.attackCustomEnabled then
        local drop = tonumber(config.target.meleeFeetDrop) or 3.5
        return { height = 0, front = 0, side = 0, vertical = -drop, radius = 0 }
    end
    if config.target.attackCustomEnabled then
        return {
            height = config.target.customHeight or 2,
            front = config.target.customFront or 0,
            side = config.target.customSide or 0,
            vertical = config.target.customVertical or 0,
            radius = config.target.customRadius or 0,
        }
    end
    local mode = config.target.attackPosition or "default"
    local weapon = getweapon()

    if mode == "behind" then
        return { height = 2, front = -4, side = 0, vertical = 0, radius = 0 }
    end
    if mode == "under" then
        return { height = 0, front = 0, side = 0, vertical = -(config.target.underOffset or 4), radius = 0 }
    end
    return {
        height = (weapon and weapon:lower():find("sniper")) and 8 or 2,
        front = 0, side = 0, vertical = 0, radius = 0,
    }
end

local function setOrbH(weapon)
    local settings = atkCfg()
    config.orbit.height = settings.height
end

local function orbBase(root)
    if not root then return Vector3.zero end
    local settings = atkCfg()
    local pos = root.Position
    local look = root.CFrame.LookVector
    local right = root.CFrame.RightVector

    local targetRoot = config.target.character
        and config.target.character:FindFirstChild("HumanoidRootPart")
    if targetRoot then
        local facingDot = targetFacingMe(targetRoot, pos)
        if facingDot > 0.5 then
            local back = targetRoot.Position - targetRoot.CFrame.LookVector * 4
            pos = Vector3.new(back.X, pos.Y, back.Z)
        end
    end

    return pos
        + (look * settings.front)
        + (right * settings.side)
        + Vector3.new(0, settings.vertical, 0)
end

local function setOrbR()
    local settings = atkCfg()
    config.orbit.radius = settings.radius or 0
end

local function refreshAtk()
    setOrbH(getweapon())
    setOrbR()
end

local function stopsync()
    if not config.state.csyncactive then return end
    if config.orbit.connection then
        config.orbit.connection:Disconnect()
        config.orbit.connection = nil
    end
    config.state.csyncactive = false
    config.orbit.active = false
    clrVoidSnap()
    if serverForger then serverForger:ClearServerCFrame() end
    config.voidspam.phase = nil
    if config.orbit.savedpos and localfighter and localfighter.Entity and localfighter.Entity.RootPart and not getgenv().InstanceUndergroundEnabled then
        local ok, pos = pcall(function() return config.orbit.savedpos end)
        if ok and pos then
            local currentPos = localfighter.Entity.RootPart.CFrame
            local distance = (currentPos.Position - pos.Position).Magnitude
            pcall(function()
                localfighter.Entity.RootPart.CFrame = pos
            end)
        end
    end
    config.orbit.serverpos = nil
    config.orbit.savedpos = nil
    config.voidspam.phase = nil
    oldpos = nil
end

local function isHidingPhase()
    return config.voidspam.enabled and config.voidspam.phase == "hide"
end

local function tickVoidSpam()
    if not config.voidspam.enabled then return end
    local now = tick()
    local elapsed = now - config.voidspam.lastswitch
    if config.voidspam.phase == "shoot" then
        if elapsed >= config.voidspam.currentduration then
            config.voidspam.phase = "hide"
            config.voidspam.currentduration = randVs(config.voidspam.hide_min, config.voidspam.hide_max)
            config.voidspam.lastswitch = now
        end
    elseif config.voidspam.phase == "hide" then
        if elapsed >= config.voidspam.currentduration then
            config.voidspam.phase = "shoot"
            config.voidspam.currentduration = randVs(config.voidspam.shoot_min, config.voidspam.shoot_max)
            config.voidspam.lastswitch = now
        end
    else
        config.voidspam.phase = "shoot"
        config.voidspam.currentduration = randVs(config.voidspam.shoot_min, config.voidspam.shoot_max)
        config.voidspam.lastswitch = now
    end
end

local function voidOk(sling)
    if not sling then return false end
    return config.voidspam.enabled or config.state.outofammo
end

local function tickVoid(sling, root)
    if sling then
        clrVoidSnap()
        return false
    end
    if not voidOk(sling) then
        clrVoidSnap()
        return false
    end
    local isHiding = config.state.outofammo or (config.voidspam.enabled and config.voidspam.phase == "hide")
    if isHiding then
        if config.voidspam.enabled and config.voidspam.phase == "hide" and not config.state.outofammo then
            local elapsed = tick() - config.voidspam.lastswitch
            if elapsed >= config.voidspam.currentduration then
                config.voidspam.phase = "shoot"
                config.voidspam.currentduration = randVs(config.voidspam.shoot_min, config.voidspam.shoot_max)
                config.voidspam.lastswitch = tick()
                clrVoidSnap()
                return false
            end
        end
        clrVoidSnap()
        local hrp = voidHrp()
        if hrp then
            snapVoid(hrp)
        else
            if config.state.csyncactive then
                return true
            end
            local randomX = math.random(-10000, 10000)
            local randomZ = math.random(-10000, 10000)
            config.orbit.serverpos = Vector3.new(randomX, -99999999999, randomZ)
        end
        return true
    end
    if config.voidspam.enabled and config.voidspam.phase == "shoot" then
        local elapsed = tick() - config.voidspam.lastswitch
        if elapsed >= config.voidspam.currentduration then
            config.voidspam.phase = "hide"
            config.voidspam.currentduration = randVs(config.voidspam.hide_min, config.voidspam.hide_max)
            config.voidspam.lastswitch = tick()
        end
    end
    clrVoidSnap()
    return false
end

local function hideShot()
    if not config.voidspam.enabled then return end
    if isSling(getweapon()) then return end
end

local function voidhide()
    if vhState.active then return end
    vhState.active = true
    if not config.state.csyncactive then
        startsync()
    end
end

local stopvoid = function()
    vhState.active = false
    vhState.currentVoidPos = nil
    if vhState.mainConnection then
        vhState.mainConnection:Disconnect()
        vhState.mainConnection = nil
    end
end

local _desyncRestoreId = 0

local function bindDesyncRestore(myRoot, oldCFrame, oldVelocity, oldRotVelocity)
    _desyncRestoreId += 1
    local bindName = "kicia_desync_restore_" .. _desyncRestoreId

    runsvc:BindToRenderStep(bindName, Enum.RenderPriority.Camera.Value - 1, function()
        if myRoot and myRoot.Parent then
            myRoot.CFrame = oldCFrame
            myRoot.AssemblyLinearVelocity = oldVelocity
            myRoot.AssemblyAngularVelocity = oldRotVelocity
        end
        pcall(function() runsvc:UnbindFromRenderStep(bindName) end)
    end)
end

local _desyncRestoreCounter = 0
local function bindDesyncRestoreUnique(myRoot, oldCFrame, oldVelocity, oldRotVelocity)
    _desyncRestoreCounter += 1
    local bindName = "kicia_desync_restore_" .. _desyncRestoreCounter

    runsvc:BindToRenderStep(bindName, Enum.RenderPriority.Camera.Value - 1, function()
        if myRoot and myRoot.Parent then
            myRoot.CFrame = oldCFrame
            myRoot.AssemblyLinearVelocity = oldVelocity
            myRoot.AssemblyAngularVelocity = oldRotVelocity
        end
        pcall(function()
            runsvc:UnbindFromRenderStep(bindName)
        end)
    end)
end

local RAGE_CSYNC_BIND = "kicia_rage_csync_atomic"
local _pendingShot = nil

local function rageCsyncRenderStep()
    if not _pendingShot then return end
    local p = _pendingShot
    _pendingShot = nil
    local hrp = p.hrp
    if not hrp or not hrp.Parent then return end

    hrp.CFrame = p.serverCF
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    pcall(p.doFire)
    hrp.CFrame = p.oldCF
    hrp.AssemblyLinearVelocity = p.oldLV
    hrp.AssemblyAngularVelocity = p.oldAV
end

runsvc:BindToRenderStep(RAGE_CSYNC_BIND, Enum.RenderPriority.Camera.Value - 1, rageCsyncRenderStep)
getgenv().ragebotCsyncBind = RAGE_CSYNC_BIND

local function startsync()
    if config.state.csyncactive then return end
    if config.target.immune then return end
    if not config.target.character or not valid(config.target.character) then return end

    eqSlot()
    config.state.csyncactive = true
    config.orbit.active = true

    local weapon = getweapon()
    setOrbH(weapon)
    setOrbR()

    if not config.orbit.savedpos then
        if localfighter and localfighter.Entity and localfighter.Entity.RootPart then
            config.orbit.savedpos = localfighter.Entity.RootPart.CFrame
        end
    end

    config.orbit.connection = runsvc.Heartbeat:Connect(function(dt)
        if not config.state.csyncactive then return end
        if config.target.immune then stopsync() return end
        if not config.target.character or not valid(config.target.character) then stopsync() return end
        if not localfighter or not localfighter.Entity or not localfighter.Entity.RootPart then stopsync() return end

        setOrbR()

        local myRoot = localfighter.Entity.RootPart
        local oldCFrame = myRoot.CFrame
        local oldVelocity = myRoot.AssemblyLinearVelocity
        local oldRotVelocity = myRoot.AssemblyAngularVelocity
        oldpos = oldCFrame

        local function isQuickSwapActive()
            if pickMelee() then return false end
            local lf = modules.fighter and modules.fighter.LocalFighter
            if not lf or not lf.EquippedItem then return false end
            local name = tostring(lf.EquippedItem:Get("Name") or ""):lower()
            return name:find("fist", 1, true) or name:find("utility", 1, true)
        end

        local _weapon = getweapon()
        local checksling = isSling(_weapon)

        if isQuickSwapActive() then
            return
        end

        eqSlot()

        if reloadHide(checksling) then
            return
        end

        if not checksling and config.voidspam.enabled and not config.target.immune then
            tickVoidSpam()
            if config.voidspam.phase == "hide" then
                local randomX = math.random(-10000, 10000)
                local randomZ = math.random(-10000, 10000)
                config.orbit.serverpos = Vector3.new(randomX, -99999999999, randomZ)
                myRoot.CFrame = CFrame.new(config.orbit.serverpos)
                myRoot.AssemblyLinearVelocity = Vector3.zero
                myRoot.AssemblyAngularVelocity = Vector3.zero

                bindDesyncRestore(myRoot, oldCFrame, oldVelocity, oldRotVelocity)
                return
            end
        end

        if not config.target.character then stopsync() return end
        local root = config.target.character:FindFirstChild("HumanoidRootPart")
        if not root then stopsync() return end

        if not checksling and isHidingPhase() then
            local randomX = math.random(-10000, 10000)
            local randomZ = math.random(-10000, 10000)
            config.orbit.serverpos = Vector3.new(randomX, -99999999999, randomZ)
            myRoot.CFrame = CFrame.new(config.orbit.serverpos)
            myRoot.AssemblyLinearVelocity = Vector3.zero
            myRoot.AssemblyAngularVelocity = Vector3.zero

            runsvc:BindToRenderStep("kicia_desync_restore", Enum.RenderPriority.Camera.Value - 1, function()
                myRoot.CFrame = oldCFrame
                myRoot.AssemblyLinearVelocity = oldVelocity
                myRoot.AssemblyAngularVelocity = oldRotVelocity
                runsvc:UnbindFromRenderStep("kicia_desync_restore")
            end)
            return
        end

        if checksling then
            if vhState and vhState.active then
                local trg = config.target.character:FindFirstChild("HumanoidRootPart")
                if trg then
                    local flat = Vector3.new(trg.CFrame.LookVector.X, 0, trg.CFrame.LookVector.Z).Unit
                    config.orbit.serverpos = trg.Position + Vector3.new(0, 15, 0) + (flat * 5)
                end
            end
        end

        if config.state.outofammo and not checksling and _weapon and not isInfiniteWeapon() then
            local randomX = math.random(-10000, 10000)
            local randomZ = math.random(-10000, 10000)
            config.orbit.serverpos = Vector3.new(randomX, -99999999999, randomZ)
            myRoot.CFrame = CFrame.new(config.orbit.serverpos)
            myRoot.AssemblyLinearVelocity = Vector3.zero
            myRoot.AssemblyAngularVelocity = Vector3.zero

            bindDesyncRestoreUnique(myRoot, oldCFrame, oldVelocity, oldRotVelocity)
            return
        end

        local targetpos = orbBase(root)
        config.orbit.angle = config.orbit.angle + (config.orbit.speed * dt)
        local offset = Vector3.new(
            math.cos(config.orbit.angle) * config.orbit.radius,
            config.orbit.height,
            math.sin(config.orbit.angle) * config.orbit.radius
        )
        config.orbit.serverpos = targetpos + offset

        if not getgenv().InstanceUndergroundEnabled then
            myRoot.CFrame = CFrame.new(config.orbit.serverpos)
            myRoot.AssemblyLinearVelocity = Vector3.zero
            myRoot.AssemblyAngularVelocity = Vector3.zero
            config.orbit.savedpos = oldCFrame

            runsvc:BindToRenderStep("kicia_desync_restore", Enum.RenderPriority.Camera.Value - 1, function()
                myRoot.CFrame = oldCFrame
                myRoot.AssemblyLinearVelocity = oldVelocity
                myRoot.AssemblyAngularVelocity = oldRotVelocity
                runsvc:UnbindFromRenderStep("kicia_desync_restore")
            end)
        end
    end)
end

local ATTACK_OFFSET_NORMAL      = Vector3.new(0, -0.7, 0.05)
local ATTACK_OFFSET_LOOK_DOWN   = Vector3.new(0, -3.85, 0.05)

local function targetLookingDown(root)
    if not root then return false end
    return root.CFrame.LookVector.Y < -0.3
end

local function computeServerAttackCF(hitPart, targetRoot, predictedPos)
    if not hitPart or typeof(hitPart) ~= "Instance" or not hitPart:IsA("BasePart") then return nil end
    local down = targetLookingDown(targetRoot)
    local off = down and ATTACK_OFFSET_LOOK_DOWN or ATTACK_OFFSET_NORMAL
    local base = predictedPos or hitPart.Position
    return CFrame.new(base + off)
end

local function autoshoot()
    if not isSling(getweapon()) and config.voidspam.enabled and config.voidspam.phase == "hide" then return end
    if not config.target.enabled or not config.target.character or not config.target.autoshoot then return end
    if config.target.immune then return end
    if config.voidspam.enabled and config.voidspam.phase == "hide" then return end

    local targetChar = config.target.character
    if typeof(targetChar) ~= "Instance" or not targetChar:IsA("Model") then return end
    if not valid(targetChar) then return end

    local myChar = player.Character
    if not myChar or not myChar.Parent then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local myHum = myChar:FindFirstChildOfClass("Humanoid")
    if not myHum or myHum.Health <= 0 then return end

    if targetIsHiding(targetChar) then return end

    local weapon = getweapon()
    local checksling = isSling(weapon)
    eqSlot()

    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot or typeof(targetRoot) ~= "Instance" or not targetRoot:IsA("BasePart") then return end

    if serverForger and config.target.enabled then
local preHit = pickBestHitPart(targetChar, myRoot.Position, targetRoot)
if preHit then
    local prePos = predict(preHit, myRoot.Position)
    local srvCF = computeServerAttackCF(preHit, targetRoot, prePos)
    if srvCF then serverForger:SetServerCFrame(srvCF) end
end
    end

    local lf = modules.fighter and modules.fighter.LocalFighter
    if not lf or not lf.EquippedItem then return end

    if not isInfiniteWeapon() then
        if config.state.reloading or config.state.outofammo then return end
        if not canuse() then return end
    end

    local shootPos
    if vhState and vhState.active and checksling then
        shootPos = getRealShootPos(player.Character)
    elseif vhState and vhState.active then
        shootPos = getRealShootPos(player.Character)
    elseif config.state.csyncactive then
        local basePos
        if config.orbit.serverpos then
            basePos = config.orbit.serverpos
        elseif myRoot then
            basePos = myRoot.Position
        else
            basePos = Vector3.zero
        end
        shootPos = basePos + Vector3.new(0, 1.75, 0)
    else
        shootPos = getRealShootPos(player.Character)
    end

    local serverPos = serverForger:GetServerPosition()
    local effectiveOrigin = serverPos or shootPos
    if typeof(effectiveOrigin) ~= "Vector3" then return end

    local hitPart = pickBestHitPart(targetChar, effectiveOrigin, targetRoot)
    if not hitPart or typeof(hitPart) ~= "Instance" or not hitPart:IsA("BasePart") then return end
    local targetPos = predict(hitPart, effectiveOrigin)
    if not targetPos then return end
    local aimCFrame = CFrame.lookAt(effectiveOrigin, targetPos)

    local attacking = targetIsAttacking(targetChar)
    local targetCF = hitPart.CFrame

    local data = {
        [utf8.char(1)] = {
            [utf8.char(0)] = modules.utility:EncodeCFrame(aimCFrame),
            [utf8.char(1)] = modules.utility:EncodeCFrame(targetCF),
            [utf8.char(2)] = hitPart,
            [utf8.char(3)] = modules.utility:EncodeCFrame(CFrame.new(0, 0, 0)),
        },
    }

    local equipped = lf.EquippedItem
    if equipped and equipped:Get("ObjectID") then
        ragePerf.lastAttackTick = tick()

        if getgenv().BulletTracersEnabled then
            local origin = getgenv().GetRageTracerOrigin and getgenv().GetRageTracerOrigin()
            if origin then
                local endPos = hitPart and hitPart.Position
                    or (getgenv().GetRageTracerEnd and getgenv().GetRageTracerEnd(origin))
                if endPos then
                    getgenv().FireBulletTracers(
                        origin, endPos,
                        getgenv().BulletTracersLifetime,
                        getgenv().BulletTracersColor
                    )
                end
            end
        end

        local attempts = math.clamp(math.floor(tonumber(config.target.shootAttempts) or 1), 1, 5)
        local tgtRoot = config.target.character and config.target.character:FindFirstChild("HumanoidRootPart")
if tgtRoot and tgtRoot.AssemblyLinearVelocity.Magnitude > 800 then
    attempts = math.min(attempts + 2, 5)
end

        local shotList = {}
        for i = 1, attempts do
            local part = pickBestHitPart(targetChar, effectiveOrigin, targetRoot) or hitPart
            if not part or typeof(part) ~= "Instance" or not part:IsA("BasePart") then break end
            local pos = predict(part, effectiveOrigin)
            if not pos then break end
            local localPos = hitPart.CFrame:PointToObjectSpace(pos)
            table.insert(shotList, {
                [utf8.char(1)] = {
                    [utf8.char(0)] = modules.utility:EncodeCFrame(CFrame.lookAt(effectiveOrigin, pos)),
                    [utf8.char(1)] = modules.utility:EncodeCFrame(part.CFrame),
                    [utf8.char(2)] = part,
                    [utf8.char(3)] = modules.utility:EncodeCFrame(CFrame.new(localPos)),
                },
            })
        end

        if #shotList > 0 then
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local serverCF
        if serverForger and config.target.enabled then
            serverCF = serverForger:GetServerPosition()
        end
        if typeof(serverCF) == "Vector3" then
            serverCF = CFrame.new(serverCF)
        elseif typeof(serverCF) ~= "CFrame" then
            serverCF = hrp.CFrame
        end

        _pendingShot = {
            hrp = hrp,
            serverCF = CFrame.new(serverCF.Position),
            oldCF = hrp.CFrame,
            oldLV = hrp.AssemblyLinearVelocity,
            oldAV = hrp.AssemblyAngularVelocity,
            doFire = function()
                for _, partData in ipairs(shotList) do
                    replicatedstorage.Remotes.Replication.Fighter.UseItem:FireServer(
                        equipped:Get("ObjectID"),
                        modules.enums:ToEnum("StartShooting"),
                        partData,
                        nil
                    )
                end
            end,
        }
    end
end
        hideShot()
        if serverForger then
            serverForger:ClearServerCFrame()
        end
    end
end

local oldcamupdate = modules.camcontrol.Update
modules.camcontrol.Update = function(...)
    if getgenv().InstanceUndergroundEnabled then
        return oldcamupdate(...)
    elseif config.state.csyncactive and localfighter and localfighter.Entity and localfighter.Entity.RootPart then
        if serverForger then
            serverForger:Apply()
        end
        if oldpos then
            localfighter.Entity.RootPart.CFrame = oldpos
        end
    end
    return oldcamupdate(...)
end

local immuneList, onImmune, onVulnerable = {}, {}, {}
local function bindimmune(cb) onImmune[#onImmune + 1] = cb end
local function bindvulnerable(cb) onVulnerable[#onVulnerable + 1] = cb end

bindimmune(function(plr)
    if config.target.lastplayer == plr then
        config.target.immune = true
        config.voidspam.phase = nil
        clrVoidSnap()
        indicator.Color = Color3.fromRGB(180, 0, 255)
        stopsync()
    end
end)

bindvulnerable(function(plr)
    if config.target.lastplayer == plr then
        config.target.immune = false
        indicator.Color = Color3.fromRGB(255, 50, 50)
        if config.target.enabled and config.target.character and valid(config.target.character) then
            startsync()
        end
    end
end)

local function cleartarget()
    config.target.enabled = false
    stopsync()
    config.target.character = nil
    config.target.lastchar = nil
    config.target.lastplayer = nil
    config.target.manualkey = false
    config.target.immune = false
    indicator.Color = Color3.fromRGB(255, 50, 50)

    pcall(function()
        if config.stateHook and config.stateHook.ClearForced then
            config.stateHook:ClearForced("IsCrouching")
        end
    end)
    pcall(function()
        local fc = getgenv().ragebot
        local ic = fc and fc._innerContext
        if ic and ic.CharacterController then
            ic.CharacterController:SendViewAngles(20, nil)
            ic.CharacterController:SetServerCFrame(nil)
        end
    end)
end

local function settarget(char)
    if not char then return end
    local targetplr = players:GetPlayerFromCharacter(char)
    if not targetplr then return end

    if getgenv().Targeting and getgenv().Targeting.shouldSkip(targetplr) then
        cleartarget()
        return
    end
    if getgenv().Targeting and getgenv().Targeting.isProtected and getgenv().Targeting.isProtected(targetplr) then
        cleartarget()
        return
    end

    config.target.enabled = true
    config.target.character = char
    config.target.lastchar = char
    config.target.lastplayer = targetplr
    config.target.immune = false
    indicator.Color = Color3.fromRGB(255, 50, 50)
    local root = char:FindFirstChild("HumanoidRootPart")
    if root and root:FindFirstChild("Attachment") then
        config.target.immune = true
        indicator.Color = Color3.fromRGB(180, 0, 255)
        stopsync()
    else
        eqSlot()
        startsync()
    end
end

local sling = {
    enabled = false,
    connections = {}
}

local function checksling()
    return isSling(getweapon())
end

local function nearplr()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local found, best = nil, math.huge
    for _, p in ipairs(players:GetPlayers()) do
        if p == player or not p.Character then continue end
        local head = p.Character:FindFirstChild("HitboxHead") or p.Character:FindFirstChild("Head")
        if not head then continue end
        local d = (head.Position - root.Position).Magnitude
        if d < best then
            found = head
            best = d
        end
    end
    return found
end

local function slingshotTP()
    if sling.connections.touch then return end
    sling.connections.touch = workspace.DescendantAdded:Connect(function(d)
        if d:IsA("BasePart") or d:IsA("Model") then
            if d.Name == "Slingshot" or d.Name == "CoreProjectile" or d.Name == "OuterProjectile" then
                task.spawn(function()
                    task.wait(0.06)
                    local part = d:IsA("BasePart") and d or d:FindFirstChildWhichIsA("BasePart")
                    if not part then return end
                    part.CanTouch = true
                    for i = 1, 60 do
                        if not part.Parent or not part:IsDescendantOf(workspace) then break end
                        local target = nearplr()
                        if target and target:IsA("BasePart")
                            and target.Parent
                            and target:IsDescendantOf(workspace)
                        then
                            pcall(firetouchinterest, target, part, 0)
                            pcall(firetouchinterest, target, part, 1)
                        end
                        task.wait()
                    end
                end)
            end
        end
    end)
end

local function stopslingTP()
    if sling.connections.touch then
        sling.connections.touch:Disconnect()
        sling.connections.touch = nil
    end
end

local function targetpos()
    if not config.target.character then return nil end
    local root = config.target.character:FindFirstChild("HumanoidRootPart")
    return root and root.Position
end

local function updatesling()
    local slingon = checksling()
    local hastarget = config.target.enabled and config.target.character ~= nil
    if slingon then
        if not sling.enabled then
            sling.enabled = true
            slingshotTP()
        end
        if getgenv().InstanceSetUnderground then
            getgenv().InstanceSetUnderground(true)
        end
        vhState.active = hastarget
        if hastarget and not config.state.csyncactive then
            startsync()
        elseif not hastarget and config.state.csyncactive and not config.target.enabled then
            stopsync()
        end
    else
        if sling.enabled then
            sling.enabled = false
            stopslingTP()
        end
        vhState.active = false
    end
end

local function fflag()
    local hastarget = config.target.enabled and config.target.character and valid(config.target.character)
    local slingon = checksling()
    if hastarget and slingon then
        pcall(function()
            setfflag("TargetTimeDelayFacctorTenths", "999999")
        end)
    else
        pcall(function()
            setfflag("TargetTimeDelayFacctorTenths", "1")
        end)
    end
end

local targetHudAnimLast = tick()
runsvc.RenderStepped:Connect(function()
    if not rageOn() then
        tracerline.Visible = false
        traceroutline.Visible = false
        if ragebot.hideRageStatus then
            ragebot.hideRageStatus()
        end
        if ragebot.updateHitNotifications then
            ragebot.updateHitNotifications(0)
        end
        return
    end

    if isLobbyVisible() then
        tracerline.Visible = false
        traceroutline.Visible = false
        if ragebot.hideRageStatus then
            ragebot.hideRageStatus()
        end
        if ragebot.updateHitNotifications then
            ragebot.updateHitNotifications(0)
        end
        return
    end

    if shouldSuppressGameplayOverlays() then
        tracerline.Visible = false
        traceroutline.Visible = false
        if ragebot.hideRageStatus then
            ragebot.hideRageStatus()
        end
        if ragebot.updateHitNotifications then
            ragebot.updateHitNotifications(0)
        end
        return
    end

    local now = tick()
    local hudDt = math.clamp(now - targetHudAnimLast, 0, 0.05)
    targetHudAnimLast = now
    if config.ragestatus and config.ragestatus.enabled and ragebot.drawStatus then
        ragebot.drawStatus()
    elseif ragebot.hideRageStatus then
        ragebot.hideRageStatus()
    end
    if ragebot.updateHitNotifications then
        ragebot.updateHitNotifications(hudDt)
    end
    if config.target.enabled and config.target.character and config.prediction.enabled then
        updatevel()
    end
end)

runsvc.Heartbeat:Connect(function(dt)
    _rageHbTick = _rageHbTick + 1

    if rageOn() and not isLobbyVisible() then
        tickAmmo()
        if config.target.auto and not config.target.manualkey then
            local current, _, melee = getammo()
            local hasammo = current == nil or current > 0 or melee
            if hasammo and not config.state.reloading then
                if not config.target.enabled or not config.target.character or not valid(config.target.character) then
                    local newtarget = nearest()
                    if newtarget then
                        if config.target.enabled then stopsync() end
                        settarget(newtarget)
                    end
                end
            end
        end
        if config.target.enabled and config.target.character then
                    if config.target.enabled and config.target.character then
            local tp = players:GetPlayerFromCharacter(config.target.character)
            local skipTarget = (not valid(config.target.character))
                or (getgenv().Targeting and getgenv().Targeting.shouldSkip and getgenv().Targeting.shouldSkip(tp))
                or (getgenv().Targeting and getgenv().Targeting.isProtected and getgenv().Targeting.isProtected(tp))
            if skipTarget then
                cleartarget()
            else
                eqSlot()
                if config.target.autoshoot and not config.target.immune then
                    autoshoot()
                end
            end
            end
        end
    end

        if _rageHbTick % 4 == 0 then
        if rageOn() and not isLobbyVisible() then
            fflag()
            updatesling()
        end
    end

    if _rageHbTick % 12 == 0 and rageOn() and not isLobbyVisible() then
        local targetChar = config.target.character
        if targetChar then
            local root = targetChar:FindFirstChild("HumanoidRootPart")
            local isImmune = root and root:FindFirstChild("Attachment") ~= nil
            if isImmune and not config.target.immune then
                config.target.immune = true
                config.voidspam.phase = nil
                clrVoidSnap()
                stopsync()
                indicator.Color = Color3.fromRGB(180, 0, 255)
            elseif not isImmune and config.target.immune then
                config.target.immune = false
                indicator.Color = Color3.fromRGB(255, 50, 50)
                if config.target.enabled and valid(targetChar) then
                    startsync()
                end
            end
        end
    end

    if _rageHbTick % 12 == 0 then
        if player and player.Parent then
            local plrs = players:GetPlayers()
            for i = 1, #plrs do
                local plr = plrs[i]
                if plr ~= player then
                    local char = plr.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    local immune = root and root:FindFirstChild("Attachment") ~= nil
                    if immune and not immuneList[plr.Name] then
                        immuneList[plr.Name] = true
                        for _, cb in pairs(onImmune) do pcall(cb, plr) end
                    elseif not immune and immuneList[plr.Name] then
                        immuneList[plr.Name] = nil
                        for _, cb in pairs(onVulnerable) do pcall(cb, plr) end
                    end
                end
            end
        end
    end
end)

ragebot.config = config
ragebot.nearest = nearest
ragebot.settarget = settarget
ragebot.cleartarget = cleartarget
ragebot.stopvoid = stopvoid
ragebot.vhState = vhState
ragebot.ragePerf = ragePerf
ragebot.getammo = getammo
ragebot.muzzlepos = muzzlepos
ragebot.valid = valid
ragebot.player = player
ragebot.eqSlot = eqSlot
ragebot.refreshAtk = refreshAtk

-- ── Round auto-start ────────────────────────────────────────
do
    local _rageLp = players.LocalPlayer
    local _wasInMatch = false
    local _roundWatchConns = {}

    local function _onRoundTransition()
        if not rageOn() then return end

        local nowIn = liveMatch()
        if nowIn and not _wasInMatch then
            if rageOn() then
                task.defer(function()
                    task.wait(0.25)
                    if not rageOn() then return end
                    if liveMatch() and not isLobbyVisible() then
                        local t = nearest()
                        if t then settarget(t) end
                    end
                end)
            end
        elseif not nowIn and _wasInMatch then
            cleartarget()
        end
        _wasInMatch = nowIn
    end

    local function _watchAttrs(obj)
        if not obj then return end
        local WATCH = {"InDuel","InMatch","InRound","InGame","InFight","IsInMatch",
                       "IsInDuel","MatchActive","Fighting","InSpawn","InLobby",
                       "InIntermission","IsRespawning","MatchId","DuelId","RoundId"}
        for _, key in ipairs(WATCH) do
            local conn = obj:GetAttributeChangedSignal(key):Connect(_onRoundTransition)
            table.insert(_roundWatchConns, conn)
        end
    end

    _watchAttrs(_rageLp)
    _rageLp.CharacterAdded:Connect(function(char)
        _onRoundTransition()
        _watchAttrs(char)
    end)
    if _rageLp.Character then
        _watchAttrs(_rageLp.Character)
    end

    local _lastPollTime = 0
    runsvc.Heartbeat:Connect(function()
        if not rageOn() then return end

        local now = os.clock()
        if now - _lastPollTime < 0.5 then return end
        _lastPollTime = now
        _onRoundTransition()
    end)

    ragebot._roundWatchConns = _roundWatchConns
end

do
local config = ragebot.config
local ragePerf = ragebot.ragePerf
local getammo = ragebot.getammo
local muzzlepos = ragebot.muzzlepos
local valid = ragebot.valid
local player = ragebot.player
local vhState = ragebot.vhState
local camera = workspace.CurrentCamera

local FONT_MAP = {
    gotham        = Enum.Font.Gotham,
    gothammedium  = Enum.Font.GothamMedium,
    gothambold    = Enum.Font.GothamBold,
    arial         = Enum.Font.Arial,
    arialbold     = Enum.Font.ArialBold,
    code          = Enum.Font.Code,
}

local function resolveFont()
    local name = tostring(config.ragestatus.fontName or "gotham"):lower()
    local map = {
        gotham       = 17,
        gothammedium = 18,
        gothambold   = 19,
        arial        = 1,
        arialbold    = 2,
        code         = 11,
    }
    return map[name] or 17
end

local function mkStatusLbl()
    local label = Drawing.new("Text")
    label.Size = config.ragestatus.textSize or 15
    label.Font = resolveFont()
    label.Outline = true
    label.Center = true
    label.Visible = false
    label.Color = config.ragestatus.color
    pcall(function()
        label.OutlineColor = Color3.fromRGB(0, 0, 0)
    end)
    return label
end

local rageStatusLine1 = mkStatusLbl()
local rageStatusLine2 = mkStatusLbl()

local function styleStatusLbl(label)
    label.Size = config.ragestatus.textSize or 15
    label.Font = resolveFont()
    label.Outline = true
    label.Color = config.ragestatus.color
    pcall(function()
        label.OutlineColor = Color3.fromRGB(0, 0, 0)
    end)
end

local function statusAnchor()
    local mode = config.ragestatus.mode or "static"
    local cam = camera or workspace.CurrentCamera
    if not cam then return Vector2.zero end

    if mode == "muzzle" or mode == "follow" then
        local mp
        if mode == "follow" and config.target.character then
            local head = config.target.character:FindFirstChild("Head")
            if head then mp = head.Position end
        end
        if not mp then
            mp = muzzlepos and muzzlepos()
        end
        if mp then
            local wts = getgenv().InstanceWorldToScreen or worldToScreen
            local screenPos, onScreen = wts(mp, cam)
            if onScreen and screenPos then
                return Vector2.new(screenPos.X, screenPos.Y)
            end
        end
    elseif mode == "dynamic" then
        if config.target.character then
            local head = config.target.character:FindFirstChild("Head")
            if head then
                local wts = getgenv().InstanceWorldToScreen or worldToScreen
                local screenPos, onScreen = wts(head.Position, cam)
                if onScreen and screenPos then
                    return Vector2.new(screenPos.X, screenPos.Y)
                end
            end
        end
    end

    return (cam.ViewportSize / 2) + Vector2.new(
        config.ragestatus.staticOffsetX or 0,
        config.ragestatus.staticOffsetY or 0
    )
end

local function rageActive()
    return config.target.enabled or config.target.auto or config.voidspam.enabled
end

local function killNm()
    if config.target.lastplayer then
        return config.target.lastplayer.Name
    end
    if config.target.character then
        local tp = game:GetService("Players"):GetPlayerFromCharacter(config.target.character)
        if tp then
            return tp.Name
        end
    end
    return "target"
end

local function inVoid()
    if vhState.active then return true end
    if config.voidspam.enabled and config.voidspam.phase == "hide" and isSling(getweapon()) then
        return true
    end
    if config.state.reloading and config.ragestatus.hideOnReload ~= false then
        return true
    end
    return false
end

local function isKilling()
    if not rageActive() then
        return false
    end
    if config.state.reloading or inVoid() then
        return false
    end
    if config.target.immune then
        return false
    end
    if not config.target.enabled or not config.target.character or not valid(config.target.character) then
        return false
    end
    if config.state.csyncactive then
        return true
    end
    if config.voidspam.enabled and config.voidspam.phase == "shoot" and isSling(getweapon()) then
        return true
    end
    if tick() - (ragePerf.lastAttackTick or 0) < 0.45 then
        return true
    end
    return false
end

local function hudAmmo()
    if isInfiniteWeapon() then return "∞" end
    local cur, maxAmmo, melee = getammo()
    if cur == nil then return "∞" end
    if melee then return "melee" end
    return string.format("%d/%d", math.floor(cur or 0), math.max(math.floor(maxAmmo or 0), 0))
end

local function fmtVsTime(minT, maxT)
    local a = clampVs(minT)
    local b = clampVs(maxT)
    if b < a then
        a, b = b, a
    end
    if math.abs(a - b) < 0.05 then
        return string.format("%.1fs", a)
    end
    return string.format("%.1f-%.1fs", a, b)
end

local function vsDetail()
    if not config.voidspam.enabled then
        return ""
    end
    local vs = config.voidspam
    return string.format(
        "void %s atk · %s hide",
        fmtVsTime(vs.shoot_min, vs.shoot_max),
        fmtVsTime(vs.hide_min, vs.hide_max)
    )
end

local function rageLines()
    local now = tick()
    if isKilling() then
        if not ragePerf.killStartAt then
            ragePerf.killStartAt = now
        end
    else
        ragePerf.killStartAt = nil
    end
    if config.state.reloading then
        return "ragebot: void hide", "reloading"
    end
    if inVoid() then
        local det = vsDetail()
        return "ragebot: void hide", det ~= "" and det or ""
    end
    if isKilling() then
        local name = killNm()
        local elapsed = now - (ragePerf.killStartAt or now)
        local hum = config.target.character and config.target.character:FindFirstChildOfClass("Humanoid")
        local main = string.format("ragebot : attacking (%s) · %.1fs", name, elapsed)
        local detailParts = {}
        local hpBit = hum and string.format("%.0f hp", hum.Health) or "hp ?"
        detailParts[#detailParts + 1] = hpBit
        local voidDetail = vsDetail()
        if voidDetail ~= "" then
            detailParts[#detailParts + 1] = voidDetail
        end
        return main, table.concat(detailParts, " · ")
    end
    if rageActive() and config.target.enabled and config.target.character then
        local hum = config.target.character:FindFirstChildOfClass("Humanoid")
        local hpBit = hum and string.format("%.0f hp", hum.Health) or "locked"
        return "ragebot: ready", hpBit
    end
    return "ragebot: idle", ""
end

local function drawStatus()
    if not config.ragestatus.enabled or shouldSuppressGameplayOverlays() then
        rageStatusLine1.Visible = false
        rageStatusLine2.Visible = false
        return
    end

    styleStatusLbl(rageStatusLine1)
    styleStatusLbl(rageStatusLine2)

    local anchor = statusAnchor()
    local gap = config.ragestatus.lineGap or 14
    local showAmmo = config.ragestatus.showAmmo ~= false
    if ragePerf.lastRageColor ~= config.ragestatus.color then
        ragePerf.lastRageColor = config.ragestatus.color
        styleStatusLbl(rageStatusLine1)
        styleStatusLbl(rageStatusLine2)
    end
    local mainLine, detailLine = rageLines()
    local ammoLine = showAmmo and hudAmmo() or ""
    local line2Text = detailLine
    if line2Text ~= "" and ammoLine ~= "" then
        line2Text = line2Text .. " · " .. ammoLine
    elseif line2Text == "" then
        line2Text = ammoLine
    end
    local lineCount = 1 + (line2Text ~= "" and 1 or 0)
    local topOffset = -(lineCount - 1) * (gap / 2)
    if mainLine ~= ragePerf.lastRageStatusText then
        ragePerf.lastRageStatusText = mainLine
        rageStatusLine1.Text = mainLine
    end
    rageStatusLine1.Position = anchor + Vector2.new(0, topOffset)
    rageStatusLine1.Visible = config.ragestatus.enabled
    local nextY = topOffset + gap
    if line2Text ~= "" then
        if line2Text ~= ragePerf.lastRageDetailText then
            ragePerf.lastRageDetailText = line2Text
            rageStatusLine2.Text = line2Text
        end
        rageStatusLine2.Position = anchor + Vector2.new(0, nextY)
        rageStatusLine2.Visible = config.ragestatus.enabled
    else
        ragePerf.lastRageDetailText = ""
        rageStatusLine2.Visible = false
    end
end

ragebot.drawStatus = drawStatus
ragebot.hideRageStatus = function()
    rageStatusLine1.Visible = false
    rageStatusLine2.Visible = false
end
ragebot.clrVoidSnap = clrVoidSnap

end
end

-- weapon modify
getgenv().GunSystem = {
    CooldownEnabled = false,
    Cooldown = 0.0,
    SpreadEnabled = false,
    Spread = 0.0,
    RecoilEnabled = false,
    Recoil = 0.0,
    Backup = {}
}

task.spawn(function()
    local success, ItemLibrary = pcall(function()
        return require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("ItemLibrary"))
    end)

    if not success or not ItemLibrary then return end

    local function scanAndBackup(tbl)
        for k, v in pairs(tbl) do
            if typeof(v) == "table" then
                if v.ShootCooldown ~= nil or v.ShootSpread ~= nil or v.ShootRecoil ~= nil then
                    if not getgenv().GunSystem.Backup[v] then
                        getgenv().GunSystem.Backup[v] = {
                            ShootCooldown = v.ShootCooldown,
                            ShootSpread = v.ShootSpread,
                            ShootRecoil = v.ShootRecoil
                        }
                    end
                end
                scanAndBackup(v)
            end
        end
    end

    scanAndBackup(ItemLibrary)
end)

function UpdateGunStats()
    local sys = getgenv().GunSystem

    for configTable, originalValues in pairs(sys.Backup) do
        if sys.CooldownEnabled then
            if originalValues.ShootCooldown ~= nil then configTable.ShootCooldown = sys.Cooldown end
        else
            if originalValues.ShootCooldown ~= nil then configTable.ShootCooldown = originalValues.ShootCooldown end
        end

        if sys.SpreadEnabled then
            if originalValues.ShootSpread ~= nil then configTable.ShootSpread = sys.Spread end
        else
            if originalValues.ShootSpread ~= nil then configTable.ShootSpread = originalValues.ShootSpread end
        end

        if sys.RecoilEnabled then
            if originalValues.ShootRecoil ~= nil then configTable.ShootRecoil = sys.Recoil end
        else
            if originalValues.ShootRecoil ~= nil then configTable.ShootRecoil = originalValues.ShootRecoil end
        end
    end
end

getgenv().UpdateGunStats = UpdateGunStats

getgenv().ItemCooldownSystem = {
    MeleeCooldown = { Enabled = false, Percentage = 0.0 },
    DashCooldown  = { Enabled = false, Percentage = 0.0 },
    AimSpeed      = { Enabled = false, Percentage = 1.0 },
    FireCooldown  = { Enabled = false, Percentage = 0.0 },
    ShootRecoil   = { Enabled = false, Percentage = 0.0 },
    AutomaticWeapon = { Enabled = false },
    MaxDoubleJumps  = { Enabled = false, Count = 676767 },
    _backupByItem = {},
    _appliedByItem = {},
    _hooked = false,
}

local ICS = getgenv().ItemCooldownSystem

local ICS_HANDLERS = {
    MaxDoubleJumps = function(originalInfo, liveInfo, cfg)
        local base = originalInfo.MaxDoubleJumps
        if base == nil then return end
        if cfg == nil or cfg.Enabled ~= true then
            liveInfo.MaxDoubleJumps = base
        else
            liveInfo.MaxDoubleJumps = cfg.Count or 676767
        end
    end,
    MeleeCooldown = function(originalInfo, liveInfo, cfg)
        local base = originalInfo.AttackCooldown
        if base == nil then return end
        if cfg == nil or cfg.Enabled ~= true then
            liveInfo.AttackCooldown = base
        else
            liveInfo.AttackCooldown = base * (cfg.Percentage or 0.0)
        end
    end,
    DashCooldown = function(originalInfo, liveInfo, cfg)
        local base = originalInfo.DashCooldown
        if base == nil then return end
        if cfg == nil or cfg.Enabled ~= true then
            liveInfo.DashCooldown = base
        else
            liveInfo.DashCooldown = base * (cfg.Percentage or 0.0)
        end
    end,
    AimSpeed = function(originalInfo, liveInfo, cfg)
        local base = originalInfo.AimSpeed
        if base == nil then return end
        if cfg == nil or cfg.Enabled ~= true then
            liveInfo.AimSpeed = base
        else
            liveInfo.AimSpeed = base * (cfg.Percentage or 1.0)
        end
    end,
    FireCooldown = function(originalInfo, liveInfo, cfg)
        local base = originalInfo.ShootCooldown
        if base == nil then return end
        if cfg == nil or cfg.Enabled ~= true then
            liveInfo.ShootCooldown = base
        else
            liveInfo.ShootCooldown = base * (cfg.Percentage or 0.0)
        end
    end,
    ShootRecoil = function(originalInfo, liveInfo, cfg)
        local base = originalInfo.ShootRecoil
        if base == nil then return end
        if cfg == nil or cfg.Enabled ~= true then
            liveInfo.ShootRecoil = base
        else
            liveInfo.ShootRecoil = base * (cfg.Percentage or 0.0)
        end
    end,
    AutomaticWeapon = function(originalInfo, liveInfo, cfg)
        local base = originalInfo.InputSpammingEnabled
        if base == nil then return end
        if cfg == nil or cfg.Enabled ~= true then
            liveInfo.InputSpammingEnabled = base
        else
            local cloned = table.clone(base)
            cloned.StartShooting = 0
            cloned.StartReloading = 0
            liveInfo.InputSpammingEnabled = cloned
        end
    end,
}

local ICS_BACKUP_FIELDS = {
    "MaxDoubleJumps", "AttackCooldown", "DashCooldown", "AimSpeed",
    "ShootCooldown", "ShootRecoil", "InputSpammingEnabled",
}

function ICS.SnapshotAll()
    local fc = getgenv().ragebot and getgenv().ragebot.player
        and require(game:GetService("Players").LocalPlayer.PlayerScripts.Controllers.FighterController)
    local lf = fc and fc.LocalFighter
    if not lf then return end
    local items = lf.Items
    if type(items) ~= "table" then return end
    for _, item in pairs(items) do
        if item and not ICS._backupByItem[item] then
            ics_backup(item)
        end
    end
    if lf.EquippedItem and not ICS._backupByItem[lf.EquippedItem] then
        ics_backup(lf.EquippedItem)
    end
end

local function ics_getInfo(item)
    if not item then return nil end
    local ok, info = pcall(function() return item:Get("Info") end)
    if not ok or type(info) ~= "table" then
        ok, info = pcall(function() return item.Info end)
    end
    if type(info) ~= "table" then return nil end
    return info
end

local function ics_backup(item)
    if ICS._backupByItem[item] then return ICS._backupByItem[item] end
    local info = ics_getInfo(item)
    if not info then return nil end
    local backup = {}
    for _, field in ipairs(ICS_BACKUP_FIELDS) do
        local v = info[field]
        if v ~= nil then
            if type(v) == "table" then
                backup[field] = table.clone(v)
            else
                backup[field] = v
            end
        end
    end
    ICS._backupByItem[item] = backup
    return backup
end

local function ics_apply(item)
    local backup = ICS._backupByItem[item] or ics_backup(item)
    if not backup then return end
    local info = ics_getInfo(item)
    if not info then return end

    for handlerName, handler in pairs(ICS_HANDLERS) do
        local cfg = ICS[handlerName]
        local ok, err = pcall(handler, backup, info, cfg)
        if not ok then
            warn("[ItemCooldown] handler " .. handlerName .. " error: " .. tostring(err))
        end
    end
    ICS._appliedByItem[item] = true
end

local function ics_restore(item)
    local backup = ICS._backupByItem[item]
    if not backup then return end
    local info = ics_getInfo(item)
    if not info then return end
    for _, field in ipairs(ICS_BACKUP_FIELDS) do
        if backup[field] ~= nil then
            if type(backup[field]) == "table" then
                info[field] = table.clone(backup[field])
            else
                info[field] = backup[field]
            end
        end
    end
    ICS._appliedByItem[item] = nil
end

local function ics_applyAll()
    local fc = getgenv().ragebot and getgenv().ragebot.player
        and require(game:GetService("Players").LocalPlayer.PlayerScripts.Controllers.FighterController)
    local lf = fc and fc.LocalFighter
    if not lf then return end
    local items = lf.Items
    if type(items) ~= "table" then return end
    for _, item in pairs(items) do
        if item then ics_apply(item) end
    end
    if lf.EquippedItem then ics_apply(lf.EquippedItem) end
end

local function ics_restoreAll()
    for item in pairs(ICS._backupByItem) do
        ics_restore(item)
    end
end

function ICS.Refresh()
    ics_applyAll()
    if getgenv().UpdateGunStats then getgenv().UpdateGunStats() end
end

function ICS.RestoreAll()
    ics_restoreAll()
    if getgenv().UpdateGunStats then getgenv().UpdateGunStats() end
end

local function ics_restoreField(item, field)
    local backup = ICS._backupByItem[item]
    if not backup or backup[field] == nil then return end
    local info = ics_getInfo(item)
    if not info then return end
    if type(backup[field]) == "table" then
        info[field] = table.clone(backup[field])
    else
        info[field] = backup[field]
    end
end

function ICS.RestoreField(fieldName)
    local fc = getgenv().ragebot and getgenv().ragebot.player
        and require(game:GetService("Players").LocalPlayer.PlayerScripts.Controllers.FighterController)
    local lf = fc and fc.LocalFighter
    if not lf then return end
    local items = lf.Items
    if type(items) == "table" then
        for _, item in pairs(items) do
            if item then ics_restoreField(item, fieldName) end
        end
    end
    if lf.EquippedItem then ics_restoreField(lf.EquippedItem, fieldName) end
end

task.spawn(function()
    local FC
    local deadline = os.clock() + 10
    while os.clock() < deadline do
        local ok, mod = pcall(function()
            return require(game:GetService("Players").LocalPlayer.PlayerScripts.Controllers.FighterController)
        end)
        if ok and mod then FC = mod break end
        task.wait(0.2)
    end
    if not FC then
        warn("[ItemCooldown] FighterController not found")
        return
    end

    if ICS._hooked then return end
    ICS._hooked = true

    local function onItemAdded(item)
        if not item then return end
        ics_backup(item)
        ics_apply(item)
    end

    local signals = {"ItemAdded", "ItemAddedSignal", "OnItemAdded", "ItemChanged"}
    for _, sigName in ipairs(signals) do
        local sig = FC[sigName]
        if sig and type(sig.Connect) == "function" then
            pcall(function()
                sig:Connect(onItemAdded)
            end)
        end
    end

    local lf = FC.LocalFighter
    if lf then
        for _, sigName in ipairs(signals) do
            local sig = lf[sigName]
            if sig and type(sig.Connect) == "function" then
                pcall(function()
                    sig:Connect(onItemAdded)
                end)
            end
        end
    end

    task.delay(0.5, function()
        ics_applyAll()
    end)

    game:GetService("RunService").Heartbeat:Connect(function()
        local lf2 = FC.LocalFighter
        if not lf2 then return end
        local eq = lf2.EquippedItem
        if eq and not ICS._appliedByItem[eq] then
            ics_backup(eq)
            ics_apply(eq)
        end
    end)
end)

-- esp
if getgenv().DualESP and getgenv().DualESP.Unload then
    getgenv().DualESP.Unload()
end

if not LPH_OBFUSCATED then
    LPH_NO_VIRTUALIZE = function(Func) return Func end
end

task.spawn(function()
local game = game
local GetService = game.GetService
local Service = function(Name)
    return cloneref(GetService(game, Name))
end

local Players = Service("Players")
local RunService = Service("RunService")
local HttpService = Service("HttpService")
local Workspace = Service("Workspace")

local Instance_new = Instance.new
local Color3_fromRGB, Color3_new, Color3_fromHSV, Color3_fromHex = Color3.fromRGB, Color3.new, Color3.fromHSV, Color3.fromHex
local table_clear, table_insert, table_remove, table_unpack, table_find, table_sort, table_concat = table.clear, table.insert, table.remove, table.unpack, table.find, table.sort, table.concat
local string_find, string_match, string_format, string_gsub, string_lower, string_upper, string_sub = string.find, string.match, string.format, string.gsub, string.lower, string.upper, string.sub
local task_wait, task_spawn, task_delay, task_defer = task.wait, task.spawn, task.delay, task.defer
local coroutine_wrap, coroutine_close, coroutine_create, coroutine_resume = coroutine.wrap, coroutine.close, coroutine.create, coroutine.resume
local os_clock, os_date = os.clock, os.date
local Vector2_new, Vector3_new, Vector3_one, Vector3_zero = Vector2.new, Vector3.new, Vector3.one, Vector3.zero
local UDim2_new, UDim2_fromScale, UDim2_fromOffset, UDim_new = UDim2.new, UDim2.fromScale, UDim2.fromOffset, UDim.new
local CFrame_Angles, CFrame_new = CFrame.Angles, CFrame.new
local math_clamp, math_round, math_floor, math_huge, math_sin, math_cos, math_pi, math_min, math_deg, math_max, math_random = math.clamp, math.round, math.floor, math.huge, math.sin, math.cos, math.pi, math.min, math.deg, math.max, math.random
local Drawing_new, Rect_new, Font_new, ColorSequence_new, ColorSequenceKeypoint_new, TweenInfo_new, NumberSequence_new, NumberSequenceKeypoint_new = Drawing.new, Rect.new, Font.new, ColorSequence.new, ColorSequenceKeypoint.new, TweenInfo.new, NumberSequence.new, NumberSequenceKeypoint.new
local FindFirstChild, GetChildren, GetDescendants, WaitForChild, FindFirstChildWhichIsA, IsA = game.FindFirstChild, game.GetChildren, game.GetDescendants, game.WaitForChild, game.FindFirstChildWhichIsA, game.IsA

getgenv().DualESP = {
    Settings = {
        Players = {
            Enabled = false,
            LocalPlayer = false,

            Font = "Tahoma",
            FontSize = 12,
            FontType = "lowercase",

            MaxDistance = math.huge,
            RefreshRate = 60,

            BoundingBox = {
                Enabled = false,
                DynamicBox = true,
                IncludeAccessories = false,
                Type = "2D",

                Rotation = 90,
                Color = {Color3_fromRGB(255, 255, 255), Color3_fromRGB(255, 255, 255)},
                Transparency = {0, 0},

                Glow = {
                    Enabled = false,
                    Rotation = 90,
                    Color = {Color3_fromRGB(255, 255, 255), Color3_fromRGB(255, 255, 255)},
                    Transparency = {0.75, 0.75},
                },

                Fill = {
                    Enabled = false,
                    Rotation = 90,
                    Color = {Color3_fromRGB(255, 255, 255), Color3_fromRGB(255, 255, 255)},
                    Transparency = {1, 0.5},
                },
            },

            Bars = {
                HealthBar = {
                    Enabled = false,
                    Position = "Left",
                    Color = {Color3_fromRGB(131, 245, 78), Color3_fromRGB(255, 255, 0), Color3_fromRGB(252, 71, 77)},

                    Type = function(Player, CharacterObjects)
                        if not IsA(Player, "Player") then return end
                        local Humanoid = CharacterObjects.Humanoid
                        if not Humanoid then return end
                        return Humanoid.Health / Humanoid.MaxHealth
                    end,

                    Text = {
                        Enabled = true,
                        FollowBar = true,
                        Ending = "",
                        Position = "Left",
                        Color = Color3_fromRGB(255, 255, 255),
                        Transparency = 0,

                        Type = function(Player, CharacterObjects)
                            if not IsA(Player, "Player") then return end
                            local Humanoid = CharacterObjects.Humanoid
                            if not Humanoid then return end
                            return Humanoid.Health, Humanoid.Health ~= Humanoid.MaxHealth
                        end,
                    },
                },

                ArmorBar = {
                    Enabled = false,
                    Position = "Bottom",
                    Color = {Color3_fromRGB(52, 131, 235), Color3_fromRGB(52, 131, 235), Color3_fromRGB(52, 131, 235)},

                    Type = function(Player, CharacterObjects)
                        if not IsA(Player, "Player") then return end
                        local Humanoid = CharacterObjects.Humanoid
                        if not Humanoid then return end
                        return Humanoid.Health / Humanoid.MaxHealth
                    end,

                    Text = {
                        Enabled = false,
                        FollowBar = true,
                        Ending = "%",
                        Position = "Left",
                        Color = Color3_fromRGB(255, 255, 255),
                        Transparency = 0,

                        Type = function(Player, CharacterObjects)
                            if not IsA(Player, "Player") then return end
                            local Humanoid = CharacterObjects.Humanoid
                            if not Humanoid then return end
                            return Humanoid.Health, Humanoid.Health ~= Humanoid.MaxHealth
                        end,
                    },
                },
            },

            Chams = {
                Enabled = false,
                DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
                Fill = {Color3_fromRGB(255, 255, 255), 0.5},
                Outline = {Color3_fromRGB(0, 0, 0), 0.5},
            },

            Name = {
                Enabled = false,
                UseDisplay = true,
                Position = "Top",
                Color = Color3_fromRGB(255, 255, 255),
                Transparency = 0,
            },

            Distance = {
                Enabled = false,
                Ending = "st",
                Position = "Bottom",
                Color = Color3_fromRGB(255, 255, 255),
                Transparency = 0,
            },

            Weapon = {
                Enabled = false,
                Position = "Bottom",
                Color = Color3_fromRGB(255, 255, 255),
                Transparency = 0,
            },

            Flags = {
                Enabled = false,
                Position = "Right",
                Color = Color3_fromRGB(255, 255, 255),
                Transparency = 0,

                Type = function(Player, CharacterObjects)
                    local Flags = {}
                    if not IsA(Player, "Player") then return Flags end
                    local Humanoid = CharacterObjects.Humanoid
                    if not Humanoid then return end
                    if Humanoid.MoveDirection.Magnitude > 0 then
                        table_insert(Flags, "moving")
                    end
                    if Humanoid.Jump then
                        table_insert(Flags, "jumping")
                    end
                    return Flags
                end
            },

            Extras = {
                TeamCheck = {
                    Enabled = false,
                },
                Tracer = {
                    Enabled = false,
                    FromCursor = false,
                    Thickness = 2,
                    Color = Color3_fromRGB(255, 255, 255),
                    Transparency = 0,
                },
                Skeleton = {
                    Enabled = false,
                    Thickness = 2,
                    Color = Color3_fromRGB(255, 255, 255),
                    Transparency = 0,
                    MaxDistance = 150,
                },
            },
        },
    },

    Connections = {},
    Errors = {},
    Objects = {},
    Targets = {},
    Folder = "ESP",
    Font = nil,
    Holder = nil,
}

function DualESP.SetDirty()
    for Type, targets in DualESP.Targets do
        for _, info in targets do
            info.LastTick = 0
        end
    end
end
getgenv().DualESP.SetDirty = DualESP.SetDirty

local Client = Players.LocalPlayer
local Camera = FindFirstChildWhichIsA(Workspace, "Camera")
local Viewport = Camera.ViewportSize
local ConnectionsTable = DualESP.Connections
local ObjectsTable = DualESP.Objects
local DrawingsTable = DualESP.Drawings
local FolderLocation = DualESP.Folder
local ESPErrors = DualESP.Errors
local ESPSettings = DualESP.Settings
local WorldToViewportPoint = Camera.WorldToViewportPoint
local ExecutorName = getexecutorname()

local function P(p)
    return p:gsub("\\", "/")
end

do
    local baseFolder = P(FolderLocation)
    local fontsFolder = P(FolderLocation .. "/Fonts")
    if not isfolder(baseFolder) then makefolder(baseFolder) end
    if not isfolder(fontsFolder) then makefolder(fontsFolder) end
end

local FontsToDownload = {
    ["Tahoma"] = {Link = "https://github.com/LuckyHub1/LuckyHub/raw/main/zekton_rg.ttf"},
    ["Minecraftia"] = {Link = "https://github.com/LuckyHub1/LuckyHub/raw/refs/heads/main/Minecraftia.ttf"},
    ["Silkscreen"] = {Link = "https://github.com/LuckyHub1/LuckyHub/raw/refs/heads/main/Silkscreen.ttf"},
}

do
    local fontsFolder = P(FolderLocation .. "/Fonts")

    for Name, Table in FontsToDownload do
        local ttfPath  = P(fontsFolder .. "/" .. Name .. ".ttf")
        local fontPath = P(fontsFolder .. "/" .. Name .. ".font")

        if not isfile(ttfPath) then
            pcall(writefile, ttfPath, game:HttpGet(Table.Link))
        end

        if not isfile(fontPath) or ExecutorName == "Potassium" then
            local Config = {
                name = Name,
                faces = {{
                    name = "Regular",
                    weight = 9e9,
                    style = "normal",
                    assetId = getcustomasset(ttfPath)
                }}
            }
            pcall(writefile, fontPath, HttpService:JSONEncode(Config))
        end
    end

    if not getgenv().Fonts then
        getgenv().Fonts = { Loaded = {} }

        for _, FontPath in listfiles(fontsFolder) do
            FontPath = P(FontPath)
            local Name = string_match(FontPath, fontsFolder .. "/(.+)%.font")
            if Name then
                local ok, asset = pcall(getcustomasset, FontPath)
                if ok then
                    Fonts.Loaded[Name] = Font_new(asset, Enum.FontWeight.Regular)
                else
                    Fonts.Loaded[Name] = Font_new(Enum.Font.SourceSans, Enum.FontWeight.Regular)
                end
            end
        end
    end
end

local Utility = {}; do
    function Utility.AddConnection(Signal, Function)
        local Connection = Signal:Connect(function(...)
            local Args = {...}
            local Success, Message = pcall(function() coroutine_wrap(Function)(table_unpack(Args)) end)
            if not Success and not ESPErrors[Message] then
                local ErrorMessage = string_format("[ERROR] | An error has occured:\n%s", Message)
                warn(ErrorMessage)
                ESPErrors[Message] = Message
                if ConnectionsTable[Connection] then
                    ConnectionsTable[Connection] = nil
                end
                return Connection and Connection:Disconnect()
            end
        end)
        if Connection and ConnectionsTable then
            table_insert(ConnectionsTable, Connection)
        end
        return Connection
    end

    function Utility.CreateObject(Type, Properties, Hidden)
        local Hidden = Hidden or false
        local Object = Instance_new(Type)
        for Index, Value in Properties do
            Object[Index] = Value
        end
        table_insert(ObjectsTable, Object)
        return Object
    end

    function Utility.CalculateBox(ESPSettings, Target, RootPart, Parts)
        local MinX, MinY, MaxX, MaxY = 9000, 9000, -9000, -9000
        local BoxWidth, BoxHeight = 0, 0
        local Position, OnScreen = WorldToViewportPoint(Camera, RootPart.Position)

        if ESPSettings.BoundingBox.DynamicBox then
            for _, Part in Parts do
                if IsA(Part, "BasePart") and Part.Name ~= "HumanoidRootPart" and Part.Transparency ~= 1 then
                    local PartCFrame = Part.CFrame
                    local PartSize = Part.Size
                    local Corners = {
                        PartCFrame * Vector3_new(PartSize.X / 2, PartSize.Y / 2, PartSize.Z / 2),
                        PartCFrame * Vector3_new(-PartSize.X / 2, PartSize.Y / 2, PartSize.Z / 2),
                        PartCFrame * Vector3_new(PartSize.X / 2, -PartSize.Y / 2, PartSize.Z / 2),
                        PartCFrame * Vector3_new(-PartSize.X / 2, -PartSize.Y / 2, PartSize.Z / 2),
                        PartCFrame * Vector3_new(PartSize.X / 2, PartSize.Y / 2, -PartSize.Z / 2),
                        PartCFrame * Vector3_new(-PartSize.X / 2, PartSize.Y / 2, -PartSize.Z / 2),
                        PartCFrame * Vector3_new(PartSize.X / 2, -PartSize.Y / 2, -PartSize.Z / 2),
                        PartCFrame * Vector3_new(-PartSize.X / 2, -PartSize.Y / 2, -PartSize.Z / 2),
                    }
                    for _, Corner in Corners do
                        local ScreenPosition, OnScreen = WorldToViewportPoint(Camera, Corner)
                        MinX = math_min(MinX, ScreenPosition.X)
                        MinY = math_min(MinY, ScreenPosition.Y)
                        MaxX = math_max(MaxX, ScreenPosition.X)
                        MaxY = math_max(MaxY, ScreenPosition.Y)
                    end
                end
            end
            BoxWidth, BoxHeight = MaxX - MinX, MaxY - MinY
        else
            local Scale = (RootPart.Size.Y * Camera.ViewportSize.Y) / (Position.Z * 2)
            BoxWidth, BoxHeight = 3 * Scale, 4.5 * Scale
            MinX, MinY = Position.X - (BoxWidth / 2), Position.Y - (BoxHeight / 2)
        end
        return BoxWidth, BoxHeight, MinX, MinY, OnScreen
    end

    function Utility.GetFontType(ESPSettings, Text)
        local FontType = string_lower(ESPSettings.FontType)
        if FontType == "uppercase" then
            return string_upper(Text)
        elseif FontType == "lowercase" then
            return string_lower(Text)
        else
            return Text
        end
    end
end

local PlayerHelper = {}; do
    function PlayerHelper.GetCharacter(Player)
        if not Player then return nil end
        return Player.Character
    end
    function PlayerHelper.GetChildren(Character)
        if not Character then return {} end
        return Character:GetChildren()
    end
    function PlayerHelper.GetDescendants(Character)
        if not Character then return {} end
        return Character:GetDescendants()
    end
    function PlayerHelper.GetTool(Player)
        if not Player then return nil end
        return nil
    end
end

local BonesR15_Extras = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}
local BonesR6_Extras = {
    {"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},
    {"Torso","Left Leg"},{"Torso","Right Leg"},
}

local function isSameTeam_Extras(player)
    local extras = ESPSettings.Players.Extras
    if not extras or not extras.TeamCheck.Enabled then return false end
    if not player or player == Client then return false end
    local character = player.Character
    if not character then return false end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    if humanoidRootPart:FindFirstChild("TeammateLabel") then return true end
    return false
end

local function newLine_Extras()
    local ln = Drawing_new("Line")
    ln.Thickness = 2
    ln.Transparency = 1
    ln.Visible = false
    return ln
end

local function createExtrasForTarget(player, isR6)
    local extras = ESPSettings.Players.Extras
    local esp = {
        Tracer = extras.Tracer.Enabled and newLine_Extras() or nil,
        Skeleton = {},
        IsR6 = isR6,
        Player = player,
    }
    if extras.Skeleton.Enabled then
        local bones = isR6 and BonesR6_Extras or BonesR15_Extras
        for i = 1, #bones do
            esp.Skeleton[i] = newLine_Extras()
        end
    end
    return esp
end

local function destroyExtras(esp)
    if not esp then return end
    if esp.Tracer then pcall(function() esp.Tracer.Visible = false; esp.Tracer:Remove() end) end
    for _, l in ipairs(esp.Skeleton) do
        if l then pcall(function() l.Visible = false; l:Remove() end) end
    end
end

local function updateExtrasForTarget(player, char, humanoid, root, head, distance, charObjects)
    local extras = ESPSettings.Players.Extras
    local esp = charObjects.Extras
    if not esp then
        local isR6 = humanoid and humanoid.RigType == Enum.HumanoidRigType.R6
        esp = createExtrasForTarget(player, isR6)
        charObjects.Extras = esp
    end

    if extras.Tracer.Enabled then
        if not esp.Tracer then esp.Tracer = newLine_Extras() end
        local rootPos = Camera:WorldToViewportPoint(root.Position)
        if rootPos.Z > 0 then
            local screenCenter = Camera.ViewportSize * 0.5
            local from
            if extras.Tracer.FromCursor then
                from = UserInputService and UserInputService:GetMouseLocation() or screenCenter
            else
                from = Vector2_new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            end
            esp.Tracer.From = from
            esp.Tracer.To = Vector2_new(rootPos.X, rootPos.Y)
            esp.Tracer.Color = extras.Tracer.Color
            esp.Tracer.Thickness = extras.Tracer.Thickness
            esp.Tracer.Transparency = 1 - extras.Tracer.Transparency
            esp.Tracer.Visible = true
        else
            esp.Tracer.Visible = false
        end
    elseif esp.Tracer then
        esp.Tracer.Visible = false
    end

    if extras.Skeleton.Enabled and distance < extras.Skeleton.MaxDistance then
        if #esp.Skeleton == 0 then
            local isR6 = humanoid and humanoid.RigType == Enum.HumanoidRigType.R6
            local bones = isR6 and BonesR6_Extras or BonesR15_Extras
            for i = 1, #bones do esp.Skeleton[i] = newLine_Extras() end
        end
        local bones = esp.IsR6 and BonesR6_Extras or BonesR15_Extras
        for i, b in ipairs(bones) do
            local p1 = char:FindFirstChild(b[1])
            local p2 = char:FindFirstChild(b[2])
            local line = esp.Skeleton[i]
            if p1 and p2 and line then
                local v1, o1 = Camera:WorldToViewportPoint(p1.Position)
                local v2, o2 = Camera:WorldToViewportPoint(p2.Position)
                if o1 and o2 then
                    line.From = Vector2_new(v1.X, v1.Y)
                    line.To = Vector2_new(v2.X, v2.Y)
                    line.Color = extras.Skeleton.Color
                    line.Thickness = extras.Skeleton.Thickness
                    line.Transparency = 1 - extras.Skeleton.Transparency
                    line.Visible = true
                else
                    line.Visible = false
                end
            elseif line then
                line.Visible = false
            end
        end
    else
        for _, l in ipairs(esp.Skeleton) do
            if l then l.Visible = false end
        end
    end
end

do
    local TextAlignments = {
        ["Left"] = "Right",
        ["Right"] = "Left",
        ["Top"] = "Center",
        ["Bottom"] = "Center",
    }

    local Layout = {
        {UDim2_new(0, -1, 0, -1), UDim2_new(0.3, 0, 0, 1), Vector2_new(0, 0), 0},
        {UDim2_new(0, -1, 0, -1), UDim2_new(0, 1, 0.3, 0), Vector2_new(0, 0), 180},
        {UDim2_new(1, 1, 0, -1), UDim2_new(0.3, 0, 0, 1), Vector2_new(1, 0), 0},
        {UDim2_new(1, 1, 0, -1), UDim2_new(0, 1, 0.3, 0), Vector2_new(1, 0), 180},
        {UDim2_new(0, -1, 1, 1), UDim2_new(0.3, 0, 0, 1), Vector2_new(0, 1), 0},
        {UDim2_new(0, -1, 1, 1), UDim2_new(0, 1, 0.3, 0), Vector2_new(0, 1), -180},
        {UDim2_new(1, 1, 1, 1), UDim2_new(0.3, 0, 0, 1), Vector2_new(1, 1), 0},
        {UDim2_new(1, 1, 1, 1), UDim2_new(0, 1, 0.3, 0), Vector2_new(1, 1), -180},
    }

    DualESP.Holder = Utility.CreateObject("ScreenGui", {
        Name = "\n",
        ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false,
        DisplayOrder = 10000,
        IgnoreGuiInset = true,
        Parent = gethui()
    })

    function DualESP.AddTarget(Target, Type)
        if Target == nil then return end
        if not DualESP.Targets[Type] then DualESP.Targets[Type] = {} end
        if DualESP.Targets[Type][Target] then return end

        local TargetInfo = {
            Objects = {},
            CharacterObjects = {},
            CharacterConnection = nil,
            ToolConnection = {Added = nil, Removed = nil},
            CurrentTool = "none",
            LastTick = os_clock()
        }

        local IsPlayer = IsA(Target, "Player")
        local IsBasePart = IsA(Target, "BasePart")
        local Objects = TargetInfo.Objects
        local LastTick = TargetInfo.LastTick
        local ToolConnection = TargetInfo.ToolConnection
        local CharacterObjects = TargetInfo.CharacterObjects
        local ESPSettings = ESPSettings[Type]
        local ESPFont = Fonts.Loaded[ESPSettings.Font]
        local ESPFontSize = ESPSettings.FontSize
        local ESPHolder = DualESP.Holder

        CharacterObjects.Character = if IsPlayer then (PlayerHelper.GetCharacter(Target)) else Target
        CharacterObjects.Children = PlayerHelper.GetChildren(CharacterObjects.Character)
        CharacterObjects.Descendants = PlayerHelper.GetDescendants(CharacterObjects.Character)

        if IsPlayer and CharacterObjects.Character then
            CharacterObjects.HumanoidRootPart = CharacterObjects.Character:FindFirstChild("HumanoidRootPart")
            CharacterObjects.Humanoid = CharacterObjects.Character:FindFirstChildWhichIsA("Humanoid")
        end

        do
            function TargetInfo.Init()
                if #Objects > 0 then return end

                if IsPlayer then
                    TargetInfo.CharacterConnection = Utility.AddConnection(Target.CharacterAdded, function(Character)
                        CharacterObjects.Character = Character
                        CharacterObjects.HumanoidRootPart = WaitForChild(Character, "HumanoidRootPart", 10)
                        CharacterObjects.Humanoid = WaitForChild(Character, "Humanoid", 10)
                        CharacterObjects.Children = PlayerHelper.GetChildren(Character)
                        CharacterObjects.Descendants = PlayerHelper.GetDescendants(Character)

                        local Highlight = Objects["Highlight"]; do
                            Highlight.Adornee = CharacterObjects.Character
                        end
                    end)

                    if CharacterObjects.Character then
                        ToolConnection.Added = Utility.AddConnection(CharacterObjects.Character.ChildAdded, function(Child)
                            if IsA(Child, "Tool") then TargetInfo.CurrentTool = Child.Name end
                        end)
                        ToolConnection.Removed = Utility.AddConnection(CharacterObjects.Character.ChildRemoved, function(Child)
                            if IsA(Child, "Tool") then TargetInfo.CurrentTool = "none" end
                        end)
                    end
                end

                Objects["Highlight"] = Utility.CreateObject("Highlight", {Parent = CharacterObjects.Character, Adornee = CharacterObjects.Character})
                Objects["TargetHolder"] = Utility.CreateObject("Frame", {Parent = ESPHolder, Visible = true, BackgroundTransparency = 1, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(0, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
                Objects["TopHolder"] = Utility.CreateObject("Frame", {Parent = Objects["TargetHolder"], AutomaticSize = Enum.AutomaticSize.Y, Visible = true, BackgroundTransparency = 1, AnchorPoint = Vector2_new(0, 1), Position = UDim2_new(0, -2, 0, -5), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(1, 4, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
                Objects["BottomHolder"] = Utility.CreateObject("Frame", {Parent = Objects["TargetHolder"], AutomaticSize = Enum.AutomaticSize.Y, Visible = true, BackgroundTransparency = 1, Position = UDim2_new(0, -2, 1, 3), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(1, 4, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
                Objects["LeftHolder"] = Utility.CreateObject("Frame", {Parent = Objects["TargetHolder"], AutomaticSize = Enum.AutomaticSize.X, Visible = true, BackgroundTransparency = 1, AnchorPoint = Vector2_new(1, 0), Position = UDim2_new(0, -4, 0, -2), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(0, 0, 1, 4), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
                Objects["RightHolder"] = Utility.CreateObject("Frame", {Parent = Objects["TargetHolder"], AutomaticSize = Enum.AutomaticSize.X, Visible = true, BackgroundTransparency = 1, Position = UDim2_new(1, 8, 0, -2), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(0, 0, 1, 4), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})

                do
                    Objects["TopTextHolder"] = Utility.CreateObject("Frame", {Parent = Objects["TopHolder"], AutomaticSize = Enum.AutomaticSize.Y, Visible = true, BackgroundTransparency = 1, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(1, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
                    Utility.CreateObject("UIListLayout", {Parent = Objects["TopTextHolder"], VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim_new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder})
                    Utility.CreateObject("UIPadding", {Parent = Objects["TopTextHolder"], PaddingBottom = UDim_new(0, 2)})

                    Objects["BottomTextHolder"] = Utility.CreateObject("Frame", {Parent = Objects["BottomHolder"], LayoutOrder = 2, AutomaticSize = Enum.AutomaticSize.Y, Visible = true, BackgroundTransparency = 1, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(1, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
                    Utility.CreateObject("UIListLayout", {Parent = Objects["BottomTextHolder"], HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim_new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder})
                    Utility.CreateObject("UIPadding", {Parent = Objects["BottomTextHolder"], PaddingTop = UDim_new(0, 2)})

                    Objects["LeftTextHolder"] = Utility.CreateObject("Frame", {Parent = Objects["LeftHolder"], AutomaticSize = Enum.AutomaticSize.XY, Visible = true, BackgroundTransparency = 1, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(1, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
                    Utility.CreateObject("UIListLayout", {Parent = Objects["LeftTextHolder"], HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim_new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder})
                    Utility.CreateObject("UIPadding", {Parent = Objects["LeftTextHolder"], PaddingTop = UDim_new(0, -3)})

                    Objects["RightTextHolder"] = Utility.CreateObject("Frame", {Parent = Objects["RightHolder"], LayoutOrder = 2, AutomaticSize = Enum.AutomaticSize.XY, Visible = true, BackgroundTransparency = 1, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(0, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
                    Utility.CreateObject("UIListLayout", {Parent = Objects["RightTextHolder"], HorizontalAlignment = Enum.HorizontalAlignment.Left, Padding = UDim_new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder})
                    Utility.CreateObject("UIPadding", {Parent = Objects["RightTextHolder"], PaddingTop = UDim_new(0, -3)})
                end

                do
                    Objects["TopBarHolder"] = Utility.CreateObject("Frame", {Visible = false, Parent = Objects["TopHolder"], AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(1, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
                    Utility.CreateObject("UIListLayout", {Parent = Objects["TopBarHolder"], HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim_new(0, 1), VerticalAlignment = Enum.VerticalAlignment.Bottom, SortOrder = Enum.SortOrder.LayoutOrder})

                    Objects["BottomBarHolder"] = Utility.CreateObject("Frame", {Visible = false, Parent = Objects["BottomHolder"], AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(1, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
                    Utility.CreateObject("UIListLayout", {Parent = Objects["BottomBarHolder"], HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim_new(0, 1), VerticalAlignment = Enum.VerticalAlignment.Bottom, SortOrder = Enum.SortOrder.LayoutOrder})
                    Utility.CreateObject("UIPadding", {Parent = Objects["BottomBarHolder"], PaddingTop = UDim_new(0, 2)})

                    Objects["LeftBarHolder"] = Utility.CreateObject("Frame", {Visible = false, Parent = Objects["LeftHolder"], AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(0, 0, 1, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
                    Utility.CreateObject("UIListLayout", {Parent = Objects["LeftBarHolder"], FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim_new(0, 1), SortOrder = Enum.SortOrder.LayoutOrder})
                    Utility.CreateObject("UIPadding", {Parent = Objects["LeftBarHolder"], PaddingRight = UDim_new(0, 1)})

                    Objects["RightBarHolder"] = Utility.CreateObject("Frame", {Visible = false, Parent = Objects["RightHolder"], AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(0, 0, 1, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
                    Utility.CreateObject("UIListLayout", {Parent = Objects["LeftBarHolder"], FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim_new(0, 1), SortOrder = Enum.SortOrder.LayoutOrder})
                    Utility.CreateObject("UIPadding", {Parent = Objects["RightBarHolder"], PaddingLeft = UDim_new(0, -3)})
                end

                do
                    Utility.CreateObject("UIListLayout", {Parent = Objects["TopHolder"], VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim_new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder})
                    Utility.CreateObject("UIListLayout", {Parent = Objects["BottomHolder"], Padding = UDim_new(0, 1), SortOrder = Enum.SortOrder.LayoutOrder})
                    Utility.CreateObject("UIPadding", {Parent = Objects["LeftHolder"], PaddingRight = UDim_new(0, 1)})
                    Utility.CreateObject("UIListLayout", {Parent = Objects["LeftHolder"], FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Left, Padding = UDim_new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder})
                    Utility.CreateObject("UIListLayout", {Parent = Objects["RightHolder"], FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Left, Padding = UDim_new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder})
                end

                do
                    Objects["BoxGlow"] = Utility.CreateObject("ImageLabel", {Parent = Objects["TargetHolder"], Image = "rbxassetid://110204605000367", ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect_new(Vector2_new(21, 21), Vector2_new(79, 79)), AutomaticSize = Enum.AutomaticSize.XY, ImageTransparency = 0.65, ResampleMode = Enum.ResamplerMode.Pixelated, Visible = true, BackgroundTransparency = 1, Position = UDim2_new(0, -21, 0, -21), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(0, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
                    Objects["BoxGlowGradient"] = Utility.CreateObject("UIGradient", {Parent = Objects["BoxGlow"], Rotation = 90, Color = ColorSequence_new{ColorSequenceKeypoint_new(0, Color3_fromRGB(0, 0, 0)), ColorSequenceKeypoint_new(1, Color3_fromRGB(0, 0, 0))}, Transparency = NumberSequence_new{NumberSequenceKeypoint_new(0, 0), NumberSequenceKeypoint_new(1, 0)}})
                    Utility.CreateObject("UIPadding", {Parent = Objects["BoxGlow"], PaddingTop = UDim_new(0, 21), PaddingBottom = UDim_new(0, 20), PaddingLeft = UDim_new(0, 21), PaddingRight = UDim_new(0, 20)})

                    Objects["BoxOutlineHolder"] = Utility.CreateObject("Frame", {Parent = Objects["BoxGlow"], Visible = false, BackgroundTransparency = 1, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(0, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
                    Objects["BoxOutline"] = Utility.CreateObject("UIStroke", {Parent = Objects["BoxOutlineHolder"], Thickness = 3, LineJoinMode = Enum.LineJoinMode.Miter})
                    Objects["BoxOutlineGradient"] = Utility.CreateObject("UIGradient", {Parent = Objects["BoxOutline"], Rotation = 90, Color = ColorSequence_new{ColorSequenceKeypoint_new(0, Color3_fromRGB(0, 0, 0)), ColorSequenceKeypoint_new(1, Color3_fromRGB(0, 0, 0))}, Transparency = NumberSequence_new{NumberSequenceKeypoint_new(0, 0), NumberSequenceKeypoint_new(1, 0)}})

                    Objects["BoxInlineHolder"] = Utility.CreateObject("Frame", {Parent = Objects["BoxGlow"], Visible = false, BackgroundTransparency = 1, Position = UDim2_new(0, -1, 0, -1), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(0, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
                    Objects["BoxInline"] = Utility.CreateObject("UIStroke", {Parent = Objects["BoxInlineHolder"], Color = Color3_fromRGB(255, 255, 255), LineJoinMode = Enum.LineJoinMode.Miter})
                    Objects["BoxInlineGradient"] = Utility.CreateObject("UIGradient", {Parent = Objects["BoxInline"], Rotation = 90, Color = ColorSequence_new{ColorSequenceKeypoint_new(0, Color3_fromRGB(0, 0, 0)), ColorSequenceKeypoint_new(1, Color3_fromRGB(255, 255, 255))}, Transparency = NumberSequence_new{NumberSequenceKeypoint_new(0, 0), NumberSequenceKeypoint_new(1, 0)}})

                    Objects["BoxFill"] = Utility.CreateObject("Frame", {Parent = Objects["BoxGlow"], Visible = false, BackgroundTransparency = 0, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(0, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
                    Objects["BoxFillGradient"] = Utility.CreateObject("UIGradient", {Parent = Objects["BoxFill"], Rotation = 90, Color = ColorSequence_new{ColorSequenceKeypoint_new(0, Color3_fromRGB(0, 0, 0)), ColorSequenceKeypoint_new(1, Color3_fromRGB(255, 255, 255))}, Transparency = NumberSequence_new{NumberSequenceKeypoint_new(0, 1), NumberSequenceKeypoint_new(1, 1)}})
                end

                do
                    Objects["CornerHolder"] = Utility.CreateObject("Frame", {Parent = Objects["BoxGlow"], Visible = false, BackgroundTransparency = 1, Position = UDim2_new(0, -1, 0, -1), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(0, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})

                    for i = 1, 8 do
                        Objects["Line_" .. i] = Utility.CreateObject("Frame", {Parent = Objects["CornerHolder"], Visible = false, BackgroundTransparency = 0, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(0, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
                        Utility.CreateObject("UIStroke", {Parent = Objects["Line_" .. i], Thickness = 1, LineJoinMode = Enum.LineJoinMode.Miter})
                    end
                end

                do
                    for BarName, Bar in ESPSettings.Bars do
                        Objects[BarName .. "Outline"] = Utility.CreateObject("Frame", {Parent = Objects[Bar.Position .. "BarHolder"], ZIndex = 5, LayoutOrder = 0, Visible = true, BackgroundTransparency = 0, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(1, 0, 0, 1), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(0, 0, 0)})
                        Utility.CreateObject("UIStroke", {Parent = Objects[BarName .. "Outline"], Thickness = 1, LineJoinMode = Enum.LineJoinMode.Miter})

                        Objects[BarName] = Utility.CreateObject("Frame", {Parent = Objects[BarName .. "Outline"], ZIndex = 6, LayoutOrder = 0, Visible = true, BackgroundTransparency = 0, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(1, 0, 0, 1), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
                        Objects[BarName .. "Gradient"] = Utility.CreateObject("UIGradient", {Parent = Objects[BarName], Rotation = 90, Color = ColorSequence_new{ColorSequenceKeypoint_new(0, Color3_fromRGB(0, 0, 0)), ColorSequenceKeypoint_new(0, Color3_fromRGB(0, 0, 0)), ColorSequenceKeypoint_new(1, Color3_fromRGB(255, 255, 255))}, Transparency = NumberSequence_new{NumberSequenceKeypoint_new(0, 0), NumberSequenceKeypoint_new(1, 0)}})

                        Objects[BarName .. "Text"] = Utility.CreateObject("TextLabel", {
                            Parent = Objects[Bar.Position .. "TextHolder"],
                            FontFace = ESPFont,
                            TextSize = ESPFontSize,
                            LayoutOrder = 2,
                            TextColor3 = Color3_fromRGB(255, 255, 255),
                            Text = "",
                            AnchorPoint = Vector2_new(0, 1),
                            BorderSizePixel = 0,
                            Visible = false,
                            BackgroundTransparency = 1,
                            ZIndex = 5,
                            AutomaticSize = Enum.AutomaticSize.Y,
                            Size = UDim2_new(1, 0, 0, 0)
                        }); Utility.CreateObject("UIStroke", {Parent = Objects[BarName .. "Text"], Color = Color3_fromRGB(0, 0, 0), LineJoinMode = Enum.LineJoinMode.Miter})
                    end
                end

                do
                    Objects["TargetName"] = Utility.CreateObject("TextLabel", {
                        Parent = Objects["TopTextHolder"],
                        FontFace = ESPFont,
                        TextSize = ESPFontSize,
                        LayoutOrder = 2,
                        TextColor3 = Color3_fromRGB(255, 255, 255),
                        Text = "",
                        AnchorPoint = Vector2_new(0, 1),
                        BorderSizePixel = 0,
                        Visible = false,
                        BackgroundTransparency = 1,
                        ZIndex = 5,
                        AutomaticSize = Enum.AutomaticSize.Y,
                        Size = UDim2_new(1, 0, 0, 0)
                    }); Utility.CreateObject("UIStroke", {Parent = Objects["TargetName"], Color = Color3_fromRGB(0, 0, 0), LineJoinMode = Enum.LineJoinMode.Miter})

                    Objects["Distance"] = Utility.CreateObject("TextLabel", {
                        Parent = Objects["BottomTextHolder"],
                        FontFace = ESPFont,
                        TextSize = ESPFontSize,
                        LayoutOrder = 2,
                        TextColor3 = Color3_fromRGB(255, 255, 255),
                        Text = "",
                        AnchorPoint = Vector2_new(0, 1),
                        BorderSizePixel = 0,
                        Visible = false,
                        BackgroundTransparency = 1,
                        ZIndex = 5,
                        AutomaticSize = Enum.AutomaticSize.Y,
                        Size = UDim2_new(1, 0, 0, 0)
                    }); Utility.CreateObject("UIStroke", {Parent = Objects["Distance"], Color = Color3_fromRGB(0, 0, 0), LineJoinMode = Enum.LineJoinMode.Miter})

                    Objects["Flags"] = Utility.CreateObject("TextLabel", {
                        Parent = Objects["RightTextHolder"],
                        FontFace = ESPFont,
                        TextSize = ESPFontSize,
                        LayoutOrder = 2,
                        TextColor3 = Color3_fromRGB(255, 255, 255),
                        Text = "",
                        AnchorPoint = Vector2_new(0, 1),
                        BorderSizePixel = 0,
                        Visible = false,
                        BackgroundTransparency = 1,
                        ZIndex = 5,
                        AutomaticSize = Enum.AutomaticSize.Y,
                        Size = UDim2_new(1, 0, 0, 0)
                    }); Utility.CreateObject("UIStroke", {Parent = Objects["Flags"], Color = Color3_fromRGB(0, 0, 0), LineJoinMode = Enum.LineJoinMode.Miter})

                    Objects["Weapon"] = Utility.CreateObject("TextLabel", {
                        Parent = Objects["BottomTextHolder"],
                        FontFace = ESPFont,
                        TextSize = ESPFontSize,
                        LayoutOrder = 2,
                        TextColor3 = Color3_fromRGB(255, 255, 255),
                        Text = "none",
                        AnchorPoint = Vector2_new(0, 1),
                        BorderSizePixel = 0,
                        Visible = false,
                        BackgroundTransparency = 1,
                        ZIndex = 5,
                        AutomaticSize = Enum.AutomaticSize.Y,
                        Size = UDim2_new(1, 0, 0, 0)
                    }); Utility.CreateObject("UIStroke", {Parent = Objects["Weapon"], Color = Color3_fromRGB(0, 0, 0), LineJoinMode = Enum.LineJoinMode.Miter})
                end

                DualESP.Targets[Type][Target] = TargetInfo
            end

            function TargetInfo.Update()
                if (os_clock() - LastTick) < (1 / ESPSettings.RefreshRate) then return end
                if not CharacterObjects.Children then return end
                if not CharacterObjects.Descendants then return end

                local CurrentChildren = PlayerHelper.GetChildren(CharacterObjects.Character)
                local CurrentDescendants = PlayerHelper.GetDescendants(CharacterObjects.Character)

                if #CharacterObjects.Children ~= #CurrentChildren then
                    CharacterObjects.Children = CurrentChildren
                    return
                end
                if #CharacterObjects.Descendants ~= #CurrentDescendants then
                    CharacterObjects.Descendants = CurrentDescendants
                    return
                end

                LastTick = os_clock()
                Objects["TargetHolder"].Visible = false
                Objects["Highlight"].Enabled = false

                if (not ESPSettings.LocalPlayer) and Target == Client then return end
                if not CharacterObjects.Character then return end

                if IsPlayer and isSameTeam_Extras(Target) then
                    local extras = CharacterObjects.Extras
                    if extras then
                        if extras.Tracer then extras.Tracer.Visible = false end
                        for _, l in ipairs(extras.Skeleton) do
                            if l then l.Visible = false end
                        end
                    end
                    return
                end

                if IsPlayer then
                    if not CharacterObjects.HumanoidRootPart then
                        if CharacterObjects.Character then
                            CharacterObjects.HumanoidRootPart = FindFirstChild(CharacterObjects.Character, "HumanoidRootPart")
                        end
                        return
                    end
                    if not CharacterObjects.Humanoid then
                        if CharacterObjects.Character then
                            CharacterObjects.Humanoid = FindFirstChildWhichIsA(CharacterObjects.Character, "Humanoid")
                        end
                        return
                    end
                else
                    if not CharacterObjects.HumanoidRootPart then
                        if IsA(Target, "BasePart") then
                            CharacterObjects.HumanoidRootPart = Target
                        elseif CharacterObjects.Character and CharacterObjects.Character.PrimaryPart then
                            CharacterObjects.HumanoidRootPart = CharacterObjects.Character.PrimaryPart
                        end
                        return
                    end
                end

                local Distance = (Camera.CFrame.Position - CharacterObjects.HumanoidRootPart.Position).Magnitude
                if Distance > ESPSettings.MaxDistance then return end

                local BodyParts = if ESPSettings.BoundingBox.IncludeAccessories then CharacterObjects.Descendants else CharacterObjects.Children
                local BoxWidth, BoxHeight, BoxPositionX, BoxPositionY, OnScreen = Utility.CalculateBox(ESPSettings, Target, CharacterObjects.HumanoidRootPart, (if IsBasePart then {Target} else BodyParts))

                if not OnScreen then
                    Objects["TargetHolder"].Visible = false
                    Objects["Highlight"].Enabled = false
                    return
                end

                if not ESPSettings.Enabled then
    local extras = CharacterObjects.Extras
    if extras then
        if extras.Tracer then extras.Tracer.Visible = false end
        for _, l in ipairs(extras.Skeleton) do if l then l.Visible = false end end
    end
    return
end

                local BoxSize, BoxPosition = UDim2_fromOffset(math_floor(BoxWidth), math_floor(BoxHeight)), UDim2_fromOffset(math_floor(BoxPositionX), math_floor(BoxPositionY))
                local TargetHolder = Objects["TargetHolder"]; do
                    TargetHolder.Visible = true
                    if TargetHolder.Position ~= BoxPosition then TargetHolder.Position = BoxPosition end
                    if TargetHolder.Size ~= BoxSize then TargetHolder.Size = BoxSize end
                end

                local BoxOutline, BoxInline, BoxFill, BoxGlow = Objects["BoxOutline"], Objects["BoxInline"], Objects["BoxFill"], Objects["BoxGlow"]; do
                    local BoxEnabled, BoxColor, BoxTransparency, BoxRotation, BoxType = ESPSettings.BoundingBox.Enabled, ESPSettings.BoundingBox.Color, ESPSettings.BoundingBox.Transparency, ESPSettings.BoundingBox.Rotation, ESPSettings.BoundingBox.Type

                    if BoxEnabled then
                        local BoxGlowGradient = Objects["BoxGlowGradient"]; do
                            local BoxGlowEnabled, BoxGlowColor, BoxGlowTransparency, BoxGlowRotation = ESPSettings.BoundingBox.Glow.Enabled, ESPSettings.BoundingBox.Glow.Color, ESPSettings.BoundingBox.Glow.Transparency, ESPSettings.BoundingBox.Glow.Rotation
                            if BoxGlowEnabled then
                                BoxGlow.ImageTransparency = 0
                                BoxGlowGradient.Rotation = BoxGlowRotation
                                BoxGlowGradient.Color = ColorSequence_new{ColorSequenceKeypoint_new(0, BoxGlowColor[1]), ColorSequenceKeypoint_new(1, BoxGlowColor[2])}
                                BoxGlowGradient.Transparency = NumberSequence_new{NumberSequenceKeypoint_new(0, BoxGlowTransparency[1]), NumberSequenceKeypoint_new(1, BoxGlowTransparency[2])}
                            else
                                BoxGlow.ImageTransparency = 1
                            end
                        end

                        if BoxType == "2D" then
                            BoxOutline.Parent.Visible = true
                            BoxOutline.Parent.Size = UDim2_fromOffset(BoxWidth, BoxHeight)
                            BoxInline.Parent.Visible = true
                            BoxInline.Parent.Size = UDim2_fromOffset(BoxWidth + 2, BoxHeight + 2)

                            local BoxInlineGradient, BoxOutlineGradient = Objects["BoxInlineGradient"], Objects["BoxOutlineGradient"]; do
                                BoxInlineGradient.Color = ColorSequence_new{ColorSequenceKeypoint_new(0, BoxColor[1]), ColorSequenceKeypoint_new(1, BoxColor[2])}
                                BoxInlineGradient.Transparency = NumberSequence_new{NumberSequenceKeypoint_new(0, BoxTransparency[1]), NumberSequenceKeypoint_new(1, BoxTransparency[2])}
                                BoxInlineGradient.Rotation = BoxRotation
                                BoxOutlineGradient.Transparency = NumberSequence_new{NumberSequenceKeypoint_new(0, BoxTransparency[1]), NumberSequenceKeypoint_new(1, BoxTransparency[2])}
                                BoxOutlineGradient.Rotation = BoxRotation
                            end

                            local BoxFillGradient = Objects["BoxFillGradient"]; do
                                local BoxFillColor, BoxFillTransparency, BoxFillRotation = ESPSettings.BoundingBox.Fill.Color, ESPSettings.BoundingBox.Fill.Transparency, ESPSettings.BoundingBox.Fill.Rotation
                                BoxFill.Visible = ESPSettings.BoundingBox.Fill.Enabled
                                BoxFill.Size = UDim2_fromOffset(BoxWidth, BoxHeight)
                                BoxFillGradient.Rotation = BoxFillRotation
                                BoxFillGradient.Color = ColorSequence_new{ColorSequenceKeypoint_new(0, BoxFillColor[1]), ColorSequenceKeypoint_new(1, BoxFillColor[2])}
                                BoxFillGradient.Transparency = NumberSequence_new{NumberSequenceKeypoint_new(0, BoxFillTransparency[1]), NumberSequenceKeypoint_new(1, BoxFillTransparency[2])}
                            end
                        else
                            local CornerHolder = Objects["CornerHolder"]; do
                                CornerHolder.Visible = true
                                CornerHolder.Size = UDim2_fromOffset(BoxWidth + 2, BoxHeight + 2)
                            end
                            for i = 1, 8 do
                                local Line = Objects["Line_" .. i]
                                local Stroke = Line.UIStroke
                                local LayoutPosition = Layout[i]
                                local Position, Size, AnchorPoint, Rotation = LayoutPosition[1], LayoutPosition[2], LayoutPosition[3], LayoutPosition[4]
                                Stroke.Transparency = BoxTransparency[1]
                                Line.Position = Position
                                Line.Rotation = Rotation
                                Line.BackgroundColor3 = BoxColor[1]
                                Line.BackgroundTransparency = BoxTransparency[1]
                                Line.Size = Size
                                Line.AnchorPoint = AnchorPoint
                                Line.Visible = true
                            end
                        end
                    else
                        BoxGlow.ImageTransparency = 1
                        BoxOutline.Parent.Visible = false
                        BoxInline.Parent.Visible = false
                        BoxFill.Visible = false
                        for i = 1, 8 do
                            local Line = Objects["Line_" .. i]
                            Line.Visible = false
                        end
                    end
                end

                for BarName, BarInfo in ESPSettings.Bars do
                    local Bar, BarOutline, BarGradient = Objects[BarName], Objects[BarName .. "Outline"], Objects[BarName .. "Gradient"]; do
                        local BarEnabled, BarColor, BarTransparency = BarInfo.Enabled, BarInfo.Color, BarInfo.Transparency
                        local NewParent = Objects[`{BarInfo.Position}BarHolder`]
                        if BarEnabled and IsPlayer then
                            local BarValue = BarInfo.Type(Target, CharacterObjects)
                            local BarSizes = {
                                ["Top"] = UDim2_new(BarValue, 0, 0, 1),
                                ["Bottom"] = UDim2_new(BarValue, 0, 0, 1),
                                ["Left"] = UDim2_new(0, 1, BarValue, 0),
                                ["Right"] = UDim2_new(0, 1, BarValue, 0),
                            }
                            local OutlineSizes = {
                                ["Top"] = UDim2_new(1, 0, 0, 1),
                                ["Bottom"] = UDim2_new(1, 0, 0, 1),
                                ["Left"] = UDim2_new(0, 1, 1, 0),
                                ["Right"] = UDim2_new(0, 1, 1, 0),
                            }
                            local GradientRotations = {
                                ["Top"] = {-180, Vector2_new(1 - BarValue, 0)},
                                ["Bottom"] = {-180, Vector2_new(1 - BarValue, 0)},
                                ["Left"] = {90, Vector2_new(0, BarValue - 1)},
                                ["Right"] = {90, Vector2_new(0, BarValue - 1)},
                            }
                            local BarPositions = {
                                ["Top"] = {Vector2_new(0, 0), UDim2_new(0, 0, 0, 0)},
                                ["Bottom"] = {Vector2_new(0, 0), UDim2_new(0, 0, 0, 0)},
                                ["Left"] = {Vector2_new(0, 1), UDim2_new(0, 0, 1, 0)},
                                ["Right"] = {Vector2_new(0, 1), UDim2_new(0, 0, 1, 0)},
                            }
                            NewParent.Visible = true
                            Bar.AnchorPoint = BarPositions[BarInfo.Position][1]
                            Bar.Position = BarPositions[BarInfo.Position][2]
                            Bar.Size = BarSizes[BarInfo.Position]
                            BarOutline.Parent = NewParent
                            BarOutline.Size = OutlineSizes[BarInfo.Position]
                            BarGradient.Rotation = GradientRotations[BarInfo.Position][1]
                            BarGradient.Offset = GradientRotations[BarInfo.Position][2]
                            BarGradient.Color = ColorSequence_new{ColorSequenceKeypoint_new(0, BarColor[1]), ColorSequenceKeypoint_new(0, BarColor[2]), ColorSequenceKeypoint_new(1, BarColor[3])}
                        else
                            NewParent.Visible = false
                        end
                    end

                    local BarText = Objects[BarName .. "Text"]; do
                        local BarTextEnabled, BarTextColor, BarTextTransparency = BarInfo.Text.Enabled, BarInfo.Text.Color, BarInfo.Text.Transparency
                        local AnchorPoints = {
                            ["Top"] = Vector2_new(0, 0.5),
                            ["Bottom"] = Vector2_new(0, 0.5),
                            ["Left"] = Vector2_new(0.5, 0),
                            ["Right"] = Vector2_new(0.5, 0),
                        }
                        local Alignments = {
                            ["Top"] = Enum.TextXAlignment.Right,
                            ["Bottom"] = Enum.TextXAlignment.Right,
                            ["Left"] = Enum.TextXAlignment.Center,
                            ["Right"] = Enum.TextXAlignment.Center,
                        }
                        if BarTextEnabled and IsPlayer then
                            local TextValue, TextVisible = BarInfo.Text.Type(Target, CharacterObjects)
                            BarText.Text = `{tostring(math_floor(TextValue))}{BarInfo.Text.Ending}`
                            BarText.TextColor3 = BarTextColor
                            BarText.TextTransparency = BarTextTransparency
                            BarText.UIStroke.Transparency = BarTextTransparency
                            if BarInfo.Text.FollowBar then
                                BarText.Visible = TextVisible
                                BarText.Parent = Bar
                                BarText.ZIndex = 10
                                BarText.TextXAlignment = Alignments[BarInfo.Position]
                                BarText.AnchorPoint = AnchorPoints[BarInfo.Position]
                            else
                                BarText.Visible = true
                                BarText.Parent = Objects[`{BarInfo.Text.Position}TextHolder`]
                                BarText.TextXAlignment = TextAlignments[BarInfo.Text.Position]
                                BarText.AnchorPoint = Vector2_new(0, 0)
                            end
                        else
                            BarText.Visible = false
                        end
                    end
                end

                local Chams = Objects["Highlight"]; do
                    local ChamsEnabled, ChamsFill, ChamsOutline = ESPSettings.Chams.Enabled, ESPSettings.Chams.Fill, ESPSettings.Chams.Outline
                    if ChamsEnabled then
                        Chams.Enabled = true
                        Chams.DepthMode = ESPSettings.Chams.DepthMode
                        Chams.FillColor = ChamsFill[1]
                        Chams.FillTransparency = ChamsFill[2]
                        Chams.OutlineColor = ChamsOutline[1]
                        Chams.OutlineTransparency = ChamsOutline[2]
                    else
                        Chams.Enabled = false
                    end
                end

                local NameText = Objects["TargetName"]; do
                    local NameEnabled, NameColor, NameTransparency = ESPSettings.Name.Enabled, ESPSettings.Name.Color, ESPSettings.Name.Transparency
                    if NameEnabled then
                        local TargetName = if ESPSettings.Name.UseDisplay then (IsPlayer and Target.DisplayName or Target.Name) else Target.Name
                        NameText.Visible = true
                        NameText.Text = Utility.GetFontType(ESPSettings, TargetName)
                        NameText.TextXAlignment = TextAlignments[ESPSettings.Name.Position]
                        NameText.Parent = Objects[`{ESPSettings.Name.Position}TextHolder`]
                        NameText.TextColor3 = NameColor
                        NameText.TextTransparency = NameTransparency
                        NameText.UIStroke.Transparency = NameTransparency
                    else
                        NameText.Visible = false
                    end
                end

                local DistanceText = Objects["Distance"]; do
                    local DistanceEnabled, DistanceColor, DistanceTransparency = ESPSettings.Distance.Enabled, ESPSettings.Distance.Color, ESPSettings.Distance.Transparency
                    if DistanceEnabled then
                        DistanceText.Visible = true
                        DistanceText.TextXAlignment = TextAlignments[ESPSettings.Distance.Position]
                        DistanceText.Parent = Objects[`{ESPSettings.Distance.Position}TextHolder`]
                        DistanceText.TextColor3 = DistanceColor
                        DistanceText.TextTransparency = DistanceTransparency
                        DistanceText.UIStroke.Transparency = DistanceTransparency
                        DistanceText.Text = Utility.GetFontType(ESPSettings, `{tostring(math_floor(Distance))}{ESPSettings.Distance.Ending}`)
                    else
                        DistanceText.Visible = false
                    end
                end

                local WeaponText = Objects["Weapon"]; do
                    local WeaponEnabled, WeaponColor, WeaponTransparency = ESPSettings.Weapon.Enabled, ESPSettings.Weapon.Color, ESPSettings.Weapon.Transparency
                    if IsPlayer and WeaponEnabled then
                        local Tool = PlayerHelper.GetTool(Target) or TargetInfo.CurrentTool
                        WeaponText.Visible = true
                        WeaponText.TextXAlignment = TextAlignments[ESPSettings.Weapon.Position]
                        WeaponText.Parent = Objects[`{ESPSettings.Weapon.Position}TextHolder`]
                        WeaponText.TextColor3 = WeaponColor
                        WeaponText.TextTransparency = WeaponTransparency
                        WeaponText.UIStroke.Transparency = WeaponTransparency
                        WeaponText.Text = Utility.GetFontType(ESPSettings, Tool)
                    else
                        WeaponText.Visible = false
                    end
                end

                local FlagsText = Objects["Flags"]; do
                    local FlagsEnabled, FlagsColor, FlagsTransparency = ESPSettings.Flags.Enabled, ESPSettings.Flags.Color, ESPSettings.Flags.Transparency
                    if FlagsEnabled then
                        local Flags = ESPSettings.Flags.Type(Target, CharacterObjects)
                        FlagsText.Visible = true
                        FlagsText.TextXAlignment = TextAlignments[ESPSettings.Flags.Position]
                        FlagsText.Parent = Objects[`{ESPSettings.Flags.Position}TextHolder`]
                        FlagsText.TextColor3 = FlagsColor
                        FlagsText.TextTransparency = FlagsTransparency
                        FlagsText.UIStroke.Transparency = FlagsTransparency
                        FlagsText.Text = table_concat(Flags, "\n")
                    else
                        FlagsText.Visible = false
                    end
                end

                if IsPlayer and CharacterObjects.Character then
                    local root = CharacterObjects.HumanoidRootPart
                    local head = CharacterObjects.Character:FindFirstChild("Head")
                    local hum = CharacterObjects.Humanoid
                    if root and head and hum then
                        updateExtrasForTarget(Target, CharacterObjects.Character, hum, root, head, Distance, CharacterObjects)
                    end
                end
            end

            function TargetInfo.Remove()
                for _, Object in Objects do
                    Object:Destroy()
                end
                if TargetInfo.CharacterConnection then
                    TargetInfo.CharacterConnection:Disconnect()
                    TargetInfo.CharacterConnection = nil
                end
                if ToolConnection.Added then ToolConnection.Added:Disconnect() ToolConnection.Added = nil end
                if ToolConnection.Removed then ToolConnection.Removed:Disconnect() ToolConnection.Removed = nil end
                destroyExtras(CharacterObjects.Extras)
                DualESP.Targets[Type][Target] = nil
            end
        end

        TargetInfo.Init()
    end

    function DualESP.RemoveTarget(NewTarget, Type)
        for Type, _ in DualESP.Settings do
            for Target, TargetInfo in DualESP.Targets[Type] do
                if Target == NewTarget then
                    TargetInfo.Remove()
                end
            end
        end
    end

    function DualESP.Init()
        for Type, _ in ESPSettings do
            if not DualESP.Targets[Type] then DualESP.Targets[Type] = {} end
        end
    end

    function DualESP.Unload()
        for _, Connection in ConnectionsTable do
            Connection:Disconnect()
        end
        for _, Object in ObjectsTable do
            Object:Destroy()
        end
        for _, targets in DualESP.Targets do
            for _, info in targets do
                destroyExtras(info.CharacterObjects and info.CharacterObjects.Extras)
            end
        end
        getgenv().Fonts = nil
    end
end

do
    DualESP.Init()

    for _, Player in Players:GetPlayers() do
        DualESP.AddTarget(Player, "Players")
    end

    Utility.AddConnection(Players.PlayerAdded, LPH_NO_VIRTUALIZE(function(Player)
        Player.CharacterAdded:Wait()
        DualESP.AddTarget(Player, "Players")
        DualESP.SetDirty()
    end))

    Utility.AddConnection(Players.PlayerRemoving, LPH_NO_VIRTUALIZE(function(Player)
        DualESP.RemoveTarget(Player, "Players")
    end))

    Utility.AddConnection(RunService.PreRender, LPH_NO_VIRTUALIZE(function()
        for Type, _ in DualESP.Settings do
            for _, Target in DualESP.Targets[Type] do
                Target.Update()
            end
        end
    end))
end
end)

-- x-ray
getgenv().Xray = getgenv().Xray or {
    Enabled = false,
    Transparency = 0.5,
    Cache = {},
}

local Xray = getgenv().Xray

local function isCharacterPart(part)
    local model = part:FindFirstAncestorOfClass("Model")
    return model and model:FindFirstChildOfClass("Humanoid") ~= nil
end

local function shouldIgnore(part)
    if not part then return true end
    if isCharacterPart(part) then return true end
    if part:FindFirstAncestorWhichIsA("Tool") then return true end
    if part:FindFirstAncestorWhichIsA("Accessory") then return true end
    local cur = part
    while cur do
        local n = cur.Name
        if n == "ViewModels" or n == "FirstPerson" or n == "ItemVisual" or n == "Live" then
            return true
        end
        cur = cur.Parent
    end
    if part:IsA("Terrain") then return true end
    return false
end

local function cachePart(part)
    if not (part and part:IsA("BasePart")) then return end
    if shouldIgnore(part) then return end
    if Xray.Cache[part] == nil then
        Xray.Cache[part] = part.LocalTransparencyModifier
    end
end

local function applyToPart(part)
    if not (part and part:IsA("BasePart") and part.Parent) then return end
    if shouldIgnore(part) then return end
    cachePart(part)
    local t = Xray.Transparency or 0.5
    if part.LocalTransparencyModifier ~= t then
        part.LocalTransparencyModifier = t
    end
end

local function restorePart(part)
    local orig = Xray.Cache[part]
    if orig == nil then return end
    if part and part.Parent then
        part.LocalTransparencyModifier = orig
    end
    Xray.Cache[part] = nil
end

local function applyMapXrayAsync()
    local parts = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not shouldIgnore(obj) then
            table.insert(parts, obj)
        end
    end
    local i = 1
    local total = #parts
    local function step()
        local batch = 0
        while i <= total and batch < 200 do
            applyToPart(parts[i])
            i += 1
            batch += 1
        end
        if i <= total then
            task.defer(step)
        end
    end
    step()
end

local function restoreMapXrayAsync()
    local parts = {}
    for part in pairs(Xray.Cache) do
        table.insert(parts, part)
    end
    local i = 1
    local total = #parts
    local function step()
        local batch = 0
        while i <= total and batch < 200 do
            restorePart(parts[i])
            i += 1
            batch += 1
        end
        if i <= total then
            task.defer(step)
        end
    end
    step()
end

function SetMapXray(state)
    state = state == true
    if Xray.Enabled == state then return end
    Xray.Enabled = state

    if state then
        applyMapXrayAsync()
    else
        restoreMapXrayAsync()
    end
end
getgenv().SetMapXray = SetMapXray

Workspace.DescendantAdded:Connect(function(obj)
    if not Xray.Enabled then return end
    if not obj:IsA("BasePart") then return end
    if shouldIgnore(obj) then return end
    applyToPart(obj)
end)

local xrayScanAccum = 0
RunService.Heartbeat:Connect(function(dt)
    if not Xray.Enabled then return end
    xrayScanAccum += dt
    if xrayScanAccum < 0.5 then return end
    xrayScanAccum = 0

    local t = Xray.Transparency or 0.5
    for part, orig in pairs(Xray.Cache) do
        if not part.Parent then
            Xray.Cache[part] = nil
        elseif part.LocalTransparencyModifier ~= t then
            part.LocalTransparencyModifier = t
        end
    end
end)

function RefreshXrayTransparency()
    if not Xray.Enabled then return end
    local t = Xray.Transparency or 0.5
    for part in pairs(Xray.Cache) do
        if part and part.Parent then
            part.LocalTransparencyModifier = t
        end
    end
end

-- utility esp
Camera = getCamera()

getgenv().ItemESP = getgenv().ItemESP or {
    Highlight = false,
    Name = false,
}

getgenv().TrackNames = getgenv().TrackNames or {
    ["Slingshot"] = {Enabled = false},
    ["Daggers"] = {Enabled = false},
    ["Paintball Gun"] = {Enabled = false},
    ["Grenade Launcher"] = {Enabled = false},
    ["Flare Gun"] = {Enabled = false},
    ["Molotov"] = {Enabled = false},
    ["Freeze Ray"] = {Enabled = false},
    ["Flashbang"] = {Enabled = false},
    ["Warpstone"] = {Enabled = false},
    ["Satchel"] = {Enabled = false},
    ["Subspace Tripmine"] = {Enabled = false},
    ["Smoke Grenade"] = {Enabled = false},
    ["Grenade"] = {Enabled = false},
    ["Bow"] = {Enabled = false},
    ["RPG"] = {Enabled = false}
}

getgenv().TrackColors = getgenv().TrackColors or {
    ["Slingshot"] = Color3.fromRGB(255, 0, 0),
    ["Daggers"] = Color3.fromRGB(20, 20, 20),
    ["Paintball Gun"] = Color3.fromRGB(0, 255, 0),
    ["Grenade Launcher"] = Color3.fromRGB(255, 120, 0),
    ["Flare Gun"] = Color3.fromRGB(255, 80, 80),
    ["Molotov"] = Color3.fromRGB(255, 100, 0),
    ["Freeze Ray"] = Color3.fromRGB(0, 255, 255),
    ["Flashbang"] = Color3.fromRGB(255, 255, 200),
    ["Warpstone"] = Color3.fromRGB(180, 0, 255),
    ["Satchel"] = Color3.fromRGB(200, 150, 100),
    ["Subspace Tripmine"] = Color3.fromRGB(255, 0, 255),
    ["Smoke Grenade"] = Color3.fromRGB(150, 150, 150),
    ["Grenade"] = Color3.fromRGB(0, 255, 0),
    ["Bow"] = Color3.fromRGB(255, 100, 100),
    ["RPG"] = Color3.fromRGB(255, 255, 0),
}

getgenv().TrackedObjects = getgenv().TrackedObjects or {}
getgenv().ObjectESP = getgenv().ObjectESP or setmetatable({}, {__mode = "k"})

local TrackNames     = getgenv().TrackNames
local TrackColors    = getgenv().TrackColors
local TrackedObjects = getgenv().TrackedObjects
local ObjectESP      = getgenv().ObjectESP

function createObjectESP(obj)
    if ObjectESP[obj] then
        return ObjectESP[obj]
    end

    local esp = {
        Highlight = nil,
        Name = Drawing.new("Text")
    }

    esp.Name.Size = 14
    esp.Name.Center = true
    esp.Name.Outline = true
    esp.Name.Color = Color3.fromRGB(255, 255, 255)
    esp.Name.Visible = false

    ObjectESP[obj] = esp

    obj.AncestryChanged:Connect(function(_, parent)
        if parent then
            return
        end

        local data = ObjectESP[obj]
        if not data then
            return
        end

        if data.Highlight then
            data.Highlight:Destroy()
        end

        if data.Name then
            data.Name:Remove()
        end

        ObjectESP[obj] = nil
        TrackedObjects[obj] = nil
    end)

    return esp
end

function getObjectPosition(obj)
    if obj:IsA("BasePart") then
        return obj.Position
    elseif obj:IsA("Model") then
        local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
        if part then
            return part.Position
        end
    end
end

function updateESP(obj, objectType)
    if not obj or not obj.Parent then
        return
    end

    local esp = createObjectESP(obj)
    local color = TrackColors[objectType] or Color3.fromRGB(255, 255, 255)

    local config = TrackNames[objectType]
    if not config or not config.Enabled then
        esp.Name.Visible = false
        if esp.Highlight then
            esp.Highlight:Destroy()
            esp.Highlight = nil
        end
        return
    end

    local pos = getObjectPosition(obj)
    if not pos then
        if esp.Highlight then
            esp.Highlight:Destroy()
            esp.Highlight = nil
        end
        esp.Name.Visible = false
        return
    end

    local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
    local cfg = getgenv().ItemESP

    if cfg.Highlight then
        if not esp.Highlight then
            local h = Instance.new("Highlight")
            h.Name = "ItemESP"
            h.FillTransparency = 0.5
            h.OutlineTransparency = 1
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            h.Parent = obj
            esp.Highlight = h
        end

        esp.Highlight.FillColor = color
    elseif esp.Highlight then
        esp.Highlight:Destroy()
        esp.Highlight = nil
    end

    if cfg.Name and onScreen then
        esp.Name.Text = objectType
        esp.Name.Position = Vector2.new(screenPos.X, screenPos.Y)
        esp.Name.Color = color
        esp.Name.Visible = true
    else
        esp.Name.Visible = false
    end
end

function tryTrack(obj)
    if not (obj:IsA("BasePart") or obj:IsA("Model")) then
        return
    end

    local config = TrackNames[obj.Name]
    if config and config.Enabled then
        TrackedObjects[obj] = obj.Name
        createObjectESP(obj)
    end
end

function untrack(obj)
    local esp = ObjectESP[obj]

    if esp then
        if esp.Highlight then
            esp.Highlight:Destroy()
        end

        if esp.Name then
            esp.Name:Remove()
        end

        ObjectESP[obj] = nil
    end

    TrackedObjects[obj] = nil
end

for _, obj in ipairs(workspace:GetDescendants()) do
    tryTrack(obj)
end

workspace.DescendantAdded:Connect(tryTrack)
workspace.DescendantRemoving:Connect(untrack)

RunService.RenderStepped:Connect(function()
    local cfg = getgenv().ItemESP
    if not cfg.Highlight and not cfg.Name then
        for obj, esp in pairs(ObjectESP) do
            if esp.Highlight then
                esp.Highlight:Destroy()
                esp.Highlight = nil
            end

            if esp.Name then
                esp.Name.Visible = false
            end
        end
        return
    end

    for obj, objectType in pairs(TrackedObjects) do
        if obj and obj.Parent then
            updateESP(obj, objectType)
        end
    end
end)

do
-- unlocker
local _plrs = Players
local _rs   = ReplicatedStorage
local _http = HttpService
local _run  = RunService
local _ws   = Workspace
local _lp   = LocalPlayer

local _pscripts = _lp.PlayerScripts
local _ctrl    = _pscripts.Controllers
local _mods    = _rs:WaitForChild("Modules", 10)

getgenv().UnlockerSettings = getgenv().UnlockerSettings or {
    Skin = false,
    Wrap = false,
    Charm = false,
    Dance = false,
    Emote = false
}

local _enumLib = require(_mods:WaitForChild("EnumLibrary", 10))
if _enumLib then pcall(function() _enumLib:WaitForEnumBuilder() end) end

local _cosLib  = require(_mods:WaitForChild("CosmeticLibrary", 10))
local _itmLib  = require(_mods:WaitForChild("ItemLibrary", 10))
local _datCtrl = require(_ctrl:WaitForChild("PlayerDataController", 10))

getgenv().UnlockerEq    = getgenv().UnlockerEq    or {}
getgenv().UnlockerFavs  = getgenv().UnlockerFavs  or {}
getgenv().UnlockerBuildWep = getgenv().UnlockerBuildWep or nil

local _eq        = getgenv().UnlockerEq
local _favs      = getgenv().UnlockerFavs
local _buildingWep = getgenv().UnlockerBuildWep
local _viewProf  = nil
local _lastWep   = nil
local _fakeInv   = {}

local function _mkCosmetic(nm, ctype, opts)
    local _base = _cosLib.Cosmetics[nm]
    if not _base then return nil end
    local _d = {}
    for k, v in pairs(_base) do _d[k] = v end
    _d.Name = nm
    _d.Type = _d.Type or ctype
    _d.Seed = _d.Seed or math.random(1, 1000000)
    if _enumLib then
        local _s, _eid = pcall(_enumLib.ToEnum, _enumLib, nm)
        if _s and _eid then
            _d.Enum = _eid
            _d.ObjectID = _d.ObjectID or _eid
        end
    end
    if opts then
        if opts.inverted ~= nil then _d.Inverted = opts.inverted end
        if opts.favoritesOnly ~= nil then _d.OnlyUseFavorites = opts.favoritesOnly end
    end
    return _d
end

local _cfgFile = "Alacrity/unlocker_config.json"
local _saveLock = false

local function _stripForSave()
    local _out = {}
    for wn, cos in pairs(_eq) do
        _out[wn] = {}
        for ct, cd in pairs(cos) do
            if cd and cd.Name then
                _out[wn][ct] = {
                    Name = cd.Name,
                    Inverted = cd.Inverted,
                    OnlyUseFavorites = cd.OnlyUseFavorites
                }
            end
        end
    end
    return { equipped = _out, favorites = _favs }
end

local function _loadCfg()
    if not isfile or not readfile then return end
    local _ok1, _ex = pcall(isfile, _cfgFile)
    if not _ok1 or not _ex then return end
    local _ok2, _raw = pcall(readfile, _cfgFile)
    if not _ok2 or not _raw or _raw == "" then return end
    local _ok3, _dec = pcall(_http.JSONDecode, _http, _raw)
    if not _ok3 or not _dec then return end
    if _dec.favorites then
        _favs = _dec.favorites
        getgenv().UnlockerFavs = _favs
    end
    if _dec.equipped then
        _eq = {}
        getgenv().UnlockerEq = _eq
        local _cnt = 0
        for wn, cos in pairs(_dec.equipped) do
            _eq[wn] = {}
            for ct, sd in pairs(cos) do
                if sd and sd.Name then
                    if _cosLib.Cosmetics[sd.Name] then
                        local _cloned = _mkCosmetic(sd.Name, ct, {
                            inverted = sd.Inverted,
                            favoritesOnly = sd.OnlyUseFavorites
                        })
                        if _cloned then
                            _eq[wn][ct] = _cloned
                            _cnt += 1
                        end
                    end
                end
            end
            if not next(_eq[wn]) then _eq[wn] = nil end
        end
    end
end

local function _saveCfg()
    if not writefile or _saveLock then return end
    _saveLock = true
    task.spawn(function()
        task.wait(1)
        local _payload = _stripForSave()
        local _ok, _enc = pcall(_http.JSONEncode, _http, _payload)
        if _ok then
            pcall(writefile, _cfgFile, _enc)
        end
        _saveLock = false
    end)
end

getgenv().SaveUnlockerConfig = _saveCfg

_loadCfg()

local function _isCosTypeAllowed(cosObj)
    if not cosObj or not cosObj.Type then return false end
    return getgenv().UnlockerSettings[cosObj.Type] == true
end

local _origOwnsNormally = _cosLib.OwnsCosmeticNormally

_cosLib.OwnsCosmeticNormally = function(self, inv, nm, wep)
    local c = _cosLib.Cosmetics[nm]
    if c and c.Type == "Skin" and getgenv().UnlockerSettings.Skin then 
        return true 
    end
    if _origOwnsNormally then
        return _origOwnsNormally(self, inv, nm, wep)
    end
    return false
end
_cosLib.OwnsCosmeticUniversally = function(self, inv, nm, wep)
    local c = _cosLib.Cosmetics[nm]
    if c and c.Type == "Skin" and getgenv().UnlockerSettings.Skin then return true end
    return false
end
_cosLib.OwnsCosmeticForWeapon = function(self, inv, nm, wep)
    local c = _cosLib.Cosmetics[nm]
    if c and c.Type == "Skin" and getgenv().UnlockerSettings.Skin then return true end
    return false
end

local _origOwns = _cosLib.OwnsCosmetic
_cosLib.OwnsCosmetic = function(self, inv, nm, wep)
    if nm:find("MISSING_") or nm == "Bubble Gun" then
        return _origOwns(self, inv, nm, wep)
    end
    local c = _cosLib.Cosmetics[nm]
    if c and _isCosTypeAllowed(c) then return true end
    return _origOwns(self, inv, nm, wep)
end

local _origGet = _datCtrl.Get
_datCtrl.Get = function(self, key)
    local _val = _origGet(self, key)
    if key == "CosmeticInventory" then
        local _prx = {}
        if _val then
            for k, v in pairs(_val) do
                local c = _cosLib.Cosmetics[k]
                if c and _isCosTypeAllowed(c) then _prx[k] = v end
            end
        end
        return setmetatable(_prx, {
            __index = function(t, k)
                local c = _cosLib.Cosmetics[k]
                if c and _isCosTypeAllowed(c) then return true end
                return nil
            end
        })
    end
    if key == "FavoritedCosmetics" then
        local _res = _val and table.clone(_val) or {}
        for wep, fv in pairs(_favs) do
            _res[wep] = _res[wep] or {}
            for nm, isFav in pairs(fv) do
                local c = _cosLib.Cosmetics[nm]
                if c and _isCosTypeAllowed(c) then
                    _res[wep][nm] = isFav
                end
            end
        end
        return _res
    end
    return _val
end

local _origGetWep = _datCtrl.GetWeaponData
_datCtrl.GetWeaponData = function(self, wn)
    local _d = _origGetWep(self, wn)
    if not _d then return nil end
    local _m = {}
    for k, v in pairs(_d) do _m[k] = v end
    _m.Name = wn
    if _eq[wn] then
        for ct, cd in pairs(_eq[wn]) do
            _m[ct] = cd
        end
    end
    return _m
end

local _fightCtrl
pcall(function()
    _fightCtrl = require(_ctrl:WaitForChild("FighterController", 10))
end)

if hookmetamethod then
    local _remotes   = _rs:FindFirstChild("Remotes")
    local _dataRem   = _remotes and _remotes:FindFirstChild("Data")
    local _equipRem  = _dataRem and _dataRem:FindFirstChild("EquipCosmetic")
    local _favRem    = _dataRem and _dataRem:FindFirstChild("FavoriteCosmetic")
    local _repRem    = _remotes and _remotes:FindFirstChild("Replication")
    local _fightRem  = _repRem and _repRem:FindFirstChild("Fighter")
    local _useItmRem = _fightRem and _fightRem:FindFirstChild("UseItem")

    if _equipRem then
        local _onc
        _onc = hookmetamethod(game, "__namecall", function(self, ...)
            if getnamecallmethod() ~= "FireServer" then
                return _onc(self, ...)
            end
            local _a = {...}

            if _useItmRem and self == _useItmRem then
                local _oid = _a[1]
                if _fightCtrl then
                    pcall(function()
                        local _f = _fightCtrl:GetFighter(_lp)
                        if _f and _f.Items then
                            for _, itm in pairs(_f.Items) do
                                if itm:Get("ObjectID") == _oid then
                                    _lastWep = itm.Name
                                    break
                                end
                            end
                        end
                    end)
                end
            end

            if self == _equipRem then
                local _wn   = _a[1]
                local _ct   = _a[2]
                local _cn   = _a[3]
                local _opts = _a[4] or {}
                if _cn and _cn ~= "None" and _cn ~= "" then
                    local _inv = _datCtrl:Get("CosmeticInventory")
                    if _inv and rawget(_inv, _cn) then
                        return _onc(self, ...)
                    end
                end
                _eq[_wn] = _eq[_wn] or {}
                if not _cn or _cn == "None" or _cn == "" then
                    _eq[_wn][_ct] = nil
                    if not next(_eq[_wn]) then _eq[_wn] = nil end
                else
                    local _cloned = _mkCosmetic(_cn, _ct, {
                        inverted = _opts.IsInverted,
                        favoritesOnly = _opts.OnlyUseFavorites
                    })
                    if _cloned then _eq[_wn][_ct] = _cloned end
                end
                task.defer(function()
                    pcall(function() _datCtrl.CurrentData:Replicate("WeaponInventory") end)
                end)
                _saveCfg()
                return
            end

            if self == _favRem then
                local _cos = _cosLib.Cosmetics[_a[2]]
                if _cos then
                    _favs[_a[1]] = _favs[_a[1]] or {}
                    _favs[_a[1]][_a[2]] = _a[3] or nil
                    task.spawn(function()
                        pcall(function() _datCtrl.CurrentData:Replicate("FavoritedCosmetics") end)
                    end)
                    _saveCfg()
                end
                return
            end

            return _onc(self, ...)
        end)
    end
end

local _cliItem
pcall(function()
    _cliItem = require(_lp.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem)
end)

local _replicatedClass
pcall(function()
    _replicatedClass = require(_rs.Modules.ReplicatedClass)
end)

local _clientViewModelClass
do
    local vmMod = _lp.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
    if vmMod then
        local ok, mod = pcall(require, vmMod)
        if ok then _clientViewModelClass = mod end
    end
end

local _virtualViewModelClassOverrides = {
    [ "Knife (Custom Skin)" ]       = "Knife",
    [ "reaver" ]                     = "Knife",
    [ "Jett" ]                       = "Keynais",
    [ "Chamber" ]                    = "Keyper",
    [ "Operator" ]                   = "Sniper",
    [ "RPG Raze" ]                   = "Nuke Launcher",
    [ "Agent" ]                      = "Fists",
    [ "Sova" ]                       = "Frostbite Bow",
    [ "Vandal" ]                     = "AK-47",
    [ "Grenade (Custom Skin)" ]     = "Elixir",
    [ "Grenade Raze" ]               = "Glorious Grenade",
    [ "sky" ]                        = "Shining Star",
    [ "Molotov (Custom Skin)" ]     = "Elixir",
    [ "Satchel (Custom Skin)" ]     = "Elixir",
    [ "Smoke Grenade (Custom Skin)" ]= "Elixir",
    [ "Warpstone (Custom Skin)" ]   = "Elixir",
    [ "Raze" ]                       = "BaseSatchel",
    [ "Subspace Tripmine (Custom Skin)" ] = "SubspaceTripmine",
    [ "Spike" ]                      = "SubspaceTripmine",
}

local function _resolveViewModelName(weapon, cosmetics)
    local skin = cosmetics and cosmetics.Skin
    local skinName = skin and (skin.ViewModelName or skin.Name)
    return skinName or weapon
end

local function _resolveViewModelClass(name)
    if not _clientViewModelClass then return nil end
    local targetClass = _clientViewModelClass
    local vmFolder = _lp.PlayerScripts.Modules:FindFirstChild("ViewModels")
    if vmFolder then
        local normalized = tostring(name or ""):gsub("[%W_]+", ""):lower()
        for _, module in pairs(vmFolder:GetDescendants()) do
            if module:IsA("ModuleScript")
                and tostring(module.Name or ""):gsub("[%W_]+", ""):lower() == normalized then
                local ok, cls = pcall(require, module)
                if ok and type(cls) == "table" and type(cls.new) == "function" then
                    targetClass = cls
                end
                break
            end
        end
    end
    return targetClass
end

local function _isValidViewModel(vm)
    return type(vm) == "table"
        and vm._destroyed ~= true
        and typeof(vm.Model) == "Instance"
        and typeof(vm.ItemModel) == "Instance"
end

local function _refreshHotbarForItem(fighter, item)
    if not fighter or not item then return end
    local hotbar = fighter.FighterInterface and fighter.FighterInterface.Hotbar
    if not hotbar then return end
    for _, slot in pairs(hotbar._hotbar_slots or {}) do
        if slot.ClientItem == item then
            if slot._Setup then pcall(slot._Setup, slot) end
            if slot.UpdateVisuals then pcall(slot.UpdateVisuals, slot) end
            break
        end
    end
end

function _forceCosmeticUpdate(weapon, ctype)
    task.spawn(function()
        pcall(function()
            if _datCtrl.CurrentData then
                _datCtrl.CurrentData:Replicate("CosmeticInventory")
                _datCtrl.CurrentData:Replicate("WeaponInventory")
            end
        end)

        if not _fightCtrl then return end
        local fighter = _fightCtrl.LocalFighter or (_fightCtrl.GetFighter and _fightCtrl:GetFighter(_lp))
        if not fighter then return end

        local item
        for _, fighterItem in fighter.Items or {} do
            if fighterItem.Name == weapon then
                item = fighterItem
                break
            end
        end
        if not item then return end

        local wasEquipped = fighter.EquippedItem == item or item.IsEquipped == true
        local selected = _eq[weapon] and _eq[weapon][ctype]

        pcall(function()
            if item.Set then item:Set(ctype, selected) end
        end)
        pcall(function()
            if item.Data then item.Data[ctype] = selected end
        end)

        local oldViewModel = item.ViewModel
        if not (oldViewModel and oldViewModel._serial and _replicatedClass and _clientViewModelClass) then
            return
        end

        local serial = table.clone(oldViewModel._serial)
        local dataKey = _replicatedClass:ToEnum("Data")
        local data = table.clone(serial.Data or serial[dataKey] or {})
        serial[dataKey] = data
        serial.Data = nil

        local cosmetics = _eq[weapon] or {}
        for _, cosmeticType in ipairs({ "Skin", "Wrap", "Charm" }) do
            local cosmetic = cosmetics[cosmeticType]
            data[_replicatedClass:ToEnum(cosmeticType)] = cosmetic
            data[cosmeticType] = nil
            if oldViewModel.Data then
                oldViewModel.Data[cosmeticType] = cosmetic
            end
        end

        local resolvedName = _resolveViewModelName(weapon, cosmetics)
        data[_replicatedClass:ToEnum("Name")] = resolvedName
        data.Name = nil

        local className = _virtualViewModelClassOverrides[resolvedName] or resolvedName
        local targetClass = _resolveViewModelClass(className) or _clientViewModelClass

        local identity = getthreadidentity and getthreadidentity() or 8
        local ok, newViewModel = pcall(function()
            if setthreadidentity then pcall(setthreadidentity, 2) end
            return targetClass.new(serial, item)
        end)
        if setthreadidentity then pcall(setthreadidentity, identity) end

        if (not ok or not _isValidViewModel(newViewModel)) and resolvedName ~= weapon then
            if newViewModel and type(newViewModel) == "table" and newViewModel.Destroy then
                pcall(newViewModel.Destroy, newViewModel)
            end
            data[_replicatedClass:ToEnum("Name")] = weapon
            data.Name = nil
            ok, newViewModel = pcall(function()
                if setthreadidentity then pcall(setthreadidentity, 2) end
                return _clientViewModelClass.new(serial, item)
            end)
            if setthreadidentity then pcall(setthreadidentity, identity) end
        end

        if ok and _isValidViewModel(newViewModel) then
            if wasEquipped and oldViewModel.Unequip then
                pcall(oldViewModel.Unequip, oldViewModel)
            end
            item.ViewModel = newViewModel
            if wasEquipped and newViewModel.Equip then
                pcall(newViewModel.Equip, newViewModel, true)
            end
            if oldViewModel ~= newViewModel and oldViewModel.Destroy then
                pcall(oldViewModel.Destroy, oldViewModel)
            end
            _refreshHotbarForItem(fighter, item)
        elseif newViewModel and type(newViewModel) == "table" and newViewModel.Destroy then
            pcall(newViewModel.Destroy, newViewModel)
        end

        local vm = item.ViewModel
        for _, obj in ipairs({ item, vm }) do
            if obj then
                for _, method in ipairs({
                    "_UpdateWrap", "UpdateWrap",
                    "_UpdateCharm", "UpdateCharm",
                    "_UpdateCosmetics", "UpdateCosmetics",
                    "_RefreshViewModel", "RefreshViewModel",
                    "UpdateViewModel",
                }) do
                    if obj[method] then
                        pcall(obj[method], obj)
                    end
                end
            end
        end

        task.wait(0.1)
        pcall(function()
            if _datCtrl.CurrentData then
                _datCtrl.CurrentData:Replicate("WeaponInventory")
            end
        end)
        _refreshHotbarForItem(fighter, item)

local vm = item.ViewModel
for _, obj in ipairs({ item, vm }) do
    if obj then
        for _, method in ipairs({
            "_UpdateWrap", "UpdateWrap",
            "_UpdateCharm", "UpdateCharm",
            "_UpdateCosmetics", "UpdateCosmetics",
            "_RefreshViewModel", "RefreshViewModel",
            "UpdateViewModel",
        }) do
            if obj[method] then
                pcall(obj[method], obj)
            end
        end
    end
end

pcall(function()
    if vm and vm.UpdateWrapVisuals then
        vm:UpdateWrapVisuals()
    end
    if vm and vm._UpdateWrapVisuals then
        vm:_UpdateWrapVisuals()
    end
    local ok, wrapController = pcall(function()
        return require(LocalPlayer.PlayerScripts.Controllers.WrapController)
    end)
    if ok and wrapController and vm and vm.Model then
        local targets = {}
        for _, d in ipairs(vm.Model:GetDescendants()) do
            if d:IsA("BasePart") and d:GetAttribute("Wrappable") then
                table.insert(targets, d)
            end
        end
        for _, name in ipairs({"LeftItem", "RightItem", "LeftArm", "RightArm", "LeftHand", "RightHand"}) do
            local p = vm.Model:FindFirstChild(name, true)
            if p and p:IsA("BasePart") then
                table.insert(targets, p)
            end
        end
        if #targets > 0 then
            local wrap = (item.GetWrap and item:GetWrap()) or (getgenv().UnlockerEq[weapon] and getgenv().UnlockerEq[weapon].Wrap)
            if wrap then
                local orig = wrapController:RecordOriginalWrapProperties(targets)
                wrapController:ApplyWrap(orig, wrap, true)
            else
                for _, part in ipairs(targets) do
                    if part.Name == "LeftItem" or part.Name == "RightItem"
                        or part.Name:find("Arm") or part.Name:find("Hand") then
                        part.Color = Color3.fromRGB(255, 255, 255)
                        part.Material = Enum.Material.SmoothPlastic
                    end
                end
            end
        end
    end
end)
    end)
end

getgenv().ForceCosmeticUpdate = _forceCosmeticUpdate

local function refreshLiveViewModel(weaponName)
    if not weaponName or weaponName == "" then return end

    local viewModels = workspace:FindFirstChild("ViewModels")
    if not viewModels then return end
    local firstPerson = viewModels:FindFirstChild("FirstPerson")
    if not firstPerson then return end

    for _, model in ipairs(firstPerson:GetChildren()) do
        if string.find(model.Name, LocalPlayer.Name, 1, true)
            and string.find(model.Name, weaponName, 1, true) then

            local itemVisual = model:FindFirstChild("ItemVisual")
            if itemVisual then
                local body = itemVisual:FindFirstChild("Body")
                if body then
                    local bodyPrimary = body:FindFirstChild("BodyPrimary")
                    if bodyPrimary then
                        local mesh = bodyPrimary:FindFirstChildOfClass("SpecialMesh")
                            or bodyPrimary:FindFirstChildOfClass("MeshPart")
                        if mesh then
                            local equip = getgenv().UnlockerEq
                                and getgenv().UnlockerEq[weaponName]
                            if equip and equip.Skin then
                                local skinData = equip.Skin
                                if skinData.MeshId then
                                    pcall(function() mesh.MeshId = skinData.MeshId end)
                                end
                                if skinData.TextureId and mesh:IsA("SpecialMesh") then
                                    pcall(function() mesh.TextureId = skinData.TextureId end)
                                elseif skinData.TextureId and mesh:IsA("MeshPart") then
                                    pcall(function() mesh.TextureID = skinData.TextureId end)
                                end
                            end
                        end
                    end
                end
            end
            break
        end
    end
end

getgenv().RefreshLiveViewModel = refreshLiveViewModel

if _cliItem and _cliItem._CreateViewModel then
    local _origCVM = _cliItem._CreateViewModel
    _cliItem._CreateViewModel = function(self, vmRef)
        local _wn  = self.Name
        local _wp  = self.ClientFighter and self.ClientFighter.Player
        _buildingWep = (_wp == _lp) and _wn or nil
        getgenv().UnlockerBuildWep = _buildingWep
        if _wp == _lp and _eq[_wn] then
            local _dk = self:ToEnum("Data")
            if vmRef[_dk] then
                if _eq[_wn].Skin then
                    vmRef[_dk][self:ToEnum("Skin")] = _eq[_wn].Skin
                    vmRef[_dk][self:ToEnum("Name")] = _eq[_wn].Skin.Name
                end
                if _eq[_wn].Charm then vmRef[_dk][self:ToEnum("Charm")] = _eq[_wn].Charm end
                if _eq[_wn].Wrap  then vmRef[_dk][self:ToEnum("Wrap")]  = _eq[_wn].Wrap  end
            elseif vmRef.Data then
                if _eq[_wn].Skin then vmRef.Data.Skin  = _eq[_wn].Skin; vmRef.Data.Name = _eq[_wn].Skin.Name end
                if _eq[_wn].Charm then vmRef.Data.Charm = _eq[_wn].Charm end
                if _eq[_wn].Wrap  then vmRef.Data.Wrap  = _eq[_wn].Wrap  end
            end
        end
        local _r = _origCVM(self, vmRef)
        _buildingWep = nil
        getgenv().UnlockerBuildWep = nil
        return _r
    end
end

local _vmMod = _lp.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
if _vmMod then
    local _CVM = require(_vmMod)
    local _origNew = _CVM.new
    _CVM.new = function(repData, cliItm)
        local _wp  = cliItm.ClientFighter and cliItm.ClientFighter.Player
        local _wn  = getgenv().UnlockerBuildWep or cliItm.Name
        if _wp == _lp and _eq[_wn] then
            local _RC  = require(_rs.Modules.ReplicatedClass)
            local _dk  = _RC:ToEnum("Data")
            repData[_dk] = repData[_dk] or {}
            local _cos = _eq[_wn]
            if _cos.Skin  then repData[_dk][_RC:ToEnum("Skin")]  = _cos.Skin  end
            if _cos.Charm then repData[_dk][_RC:ToEnum("Charm")] = _cos.Charm end
            if _cos.Wrap  then repData[_dk][_RC:ToEnum("Wrap")]  = _cos.Wrap  end
        end
        return _origNew(repData, cliItm)
    end
end

-- cosmetic changer
task.spawn(function()
    while not (getgenv().UnlockerEq and getgenv().UnlockerSettings) do
        task.wait(0.1)
    end

    local Players        = Services.Players
    local ReplicatedStorage = Services.ReplicatedStorage
    local HttpService    = Services.HttpService
    local CollectionService = Services.CollectionService
    local RunService     = Services.RunService
    local TweenService   = Services.TweenService
    local LocalPlayer    = getgenv().LocalPlayer

    local ctrl   = LocalPlayer.PlayerScripts.Controllers
    local mods   = ReplicatedStorage:WaitForChild("Modules", 10)
    if not mods then return end

    local enumLib  = require(mods:WaitForChild("EnumLibrary", 10))
    local cosLib   = require(mods:WaitForChild("CosmeticLibrary", 10))
    local itmLib   = require(mods:WaitForChild("ItemLibrary", 10))
    local consts   = require(mods:WaitForChild("CONSTANTS", 10))
    local datCtrl  = require(ctrl:WaitForChild("PlayerDataController", 10))
    local coss     = cosLib.Cosmetics

    local KNIFE_CUSTOM_SKIN         = "Knife (Custom Skin)"
    local REAVER_KNIFE_CUSTOM_SKIN  = "reaver"
    local DAGGERS_CUSTOM_SKIN       = "Jett"
    local SATCHEL_CUSTOM_SKIN       = "Raze"
    local SNIPER_CUSTOM_SKIN        = "Chamber"
    local RPG_CUSTOM_SKIN           = "RPG Raze"
    local FISTS_CUSTOM_SKIN         = "Agent"
    local BOW_CUSTOM_SKIN           = "Sova"
    local ASSAULT_RIFLE_CUSTOM_SKIN = "Vandal"
    local DICE_TRIPMINE_SKIN        = "Subspace Tripmine (Custom Skin)"
    local SPIKE_TRIPMINE_SKIN       = "Spike"

    local DICE_TRIPMINE_OUTER_MESH_ID   = "rbxassetid://5555691474"
    local DICE_TRIPMINE_INNER_MESH_ID   = "rbxassetid://5555691356"
    local DICE_TRIPMINE_IMAGE_ID        = "rbxassetid://98372867049331"
    local DICE_TRIPMINE_IMAGE_HIGH_RES_ID = "rbxassetid://75601061529918"
    local DICE_TRIPMINE_MESH_SCALE      = 3.35
    local DICE_TRIPMINE_WORLD_MESH_SCALE= 3.25
    local SPIKE_TRIPMINE_MESH_ID        = "rbxassetid://97754746098028"
    local TRIPMINE_STAR_REMOVE_MESH_ID  = "rbxassetid://13792525075"
    local SPIKE_TRIPMINE_MESH_SCALE     = 85
    local SPIKE_TRIPMINE_WORLD_MESH_SCALE = 50

    local SNIPER_CUSTOM_REPLACEMENT_MESH_ID    = "rbxassetid://98786413608787"
    local SNIPER_CUSTOM_REPLACEMENT_TEXTURE_ID = "rbxassetid://131686603013672"
    local SNIPER_CUSTOM_REPLACEMENT_SIZE       = Vector3.new(0.025, 0.025, 0.025)
    local SNIPER_CUSTOM_REPLACEMENT_OFFSET     = Vector3.new(0, -0.25, 0)

    local DAGGERS_CUSTOM_SOURCE_MESH_ID      = "rbxassetid://94772705561955"
    local DAGGERS_CUSTOM_REPLACEMENT_MESH_ID = "rbxassetid://128075492497238"
    local DAGGERS_CUSTOM_REPLACEMENT_TEXTURE_ID = "rbxassetid://79246900644201"
    local DAGGERS_CUSTOM_REPLACEMENT_SIZE    = Vector3.new(0.03, 0.03, 0.03)
    local DAGGERS_CUSTOM_REPLACEMENT_ROTATION= Vector3.new(0, 90, -90)

    local SATCHEL_CUSTOM_REPLACEMENT_MESH_ID    = "rbxassetid://129982008330139"
    local SATCHEL_CUSTOM_REPLACEMENT_TEXTURE_ID = "rbxassetid://121713947189258"
    local SATCHEL_CUSTOM_REPLACEMENT_SIZE       = Vector3.new(0.5, 0.5, 0.5)
    local SATCHEL_CUSTOM_WORLD_REPLACEMENT_SIZE = Vector3.new(0.6, 0.6, 0.6)
    local SATCHEL_CUSTOM_REPLACEMENT_ROTATION   = Vector3.new(0, -90, 0)

    local RPG_CUSTOM_BODY_REPLACEMENT_MESH_ID    = "rbxassetid://81554047161707"
    local RPG_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID = "rbxassetid://133257377819985"
    local RPG_CUSTOM_REPLACEMENT_SCALE           = 0.5
    local RPG_CUSTOM_REPLACEMENT_ROTATION        = Vector3.new(0, 90, 0)
    local RPG_CUSTOM_REPLACEMENT_OFFSET          = Vector3.new(0.04, 0, 0)

    local FISTS_CUSTOM_LEFT_MESH_ID     = "rbxassetid://120273083766829"
    local FISTS_CUSTOM_LEFT_TEXTURE_ID  = "rbxassetid://124608382264962"
    local FISTS_CUSTOM_RIGHT_MESH_ID    = "rbxassetid://129220833982000"
    local FISTS_CUSTOM_RIGHT_TEXTURE_ID = "rbxassetid://118482605175566"
    local FISTS_CUSTOM_MESH_SCALE       = Vector3.new(0.1, 0.1, 0.1)
    local FISTS_CUSTOM_LEFT_ROTATION    = Vector3.new(45, 0, 0)
    local FISTS_CUSTOM_RIGHT_ROTATION   = Vector3.new(-45, 0, 0)

    local BOW_CUSTOM_BODY_REPLACEMENT_MESH_ID    = "rbxassetid://80147707463344"
    local BOW_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID = "rbxassetid://87690225474067"
    local BOW_CUSTOM_ARROW_REPLACEMENT_MESH_ID   = "rbxassetid://97839236861642"
    local BOW_CUSTOM_ARROW_REPLACEMENT_TEXTURE_ID= "rbxassetid://82458179247269"
    local BOW_CUSTOM_REPLACEMENT_SIZE            = Vector3.new(0.25, 0.25, 0.25)

    local CUSTOM_SKIN_IMAGE_OVERRIDES = {
        [REAVER_KNIFE_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
        ["sky"]                    = { Image = "", ImageHighResolution = "" },
        ["Camera"]                 = { Image = "", ImageHighResolution = "" },
        ["Grenade Raze"]           = { Image = "", ImageHighResolution = "" },
        [DAGGERS_CUSTOM_SKIN]      = { Image = "", ImageHighResolution = "" },
        [SATCHEL_CUSTOM_SKIN]      = { Image = "", ImageHighResolution = "" },
        [SNIPER_CUSTOM_SKIN]       = { Image = "", ImageHighResolution = "" },
        ["Operator"]               = { Image = "", ImageHighResolution = "" },
        [RPG_CUSTOM_SKIN]          = { Image = "", ImageHighResolution = "" },
        [FISTS_CUSTOM_SKIN]        = { Image = "", ImageHighResolution = "" },
        [BOW_CUSTOM_SKIN]          = { Image = "", ImageHighResolution = "" },
        [ASSAULT_RIFLE_CUSTOM_SKIN]= { Image = "", ImageHighResolution = "" },
        [DICE_TRIPMINE_SKIN]       = { Image = DICE_TRIPMINE_IMAGE_ID, ImageHighResolution = DICE_TRIPMINE_IMAGE_HIGH_RES_ID },
        [SPIKE_TRIPMINE_SKIN]      = { Image = "", ImageHighResolution = "" },
    }

    local SNIPER_MESH_SKIN_OVERRIDES = {
        [SNIPER_CUSTOM_SKIN] = {
            Skin = SNIPER_CUSTOM_SKIN,
            BodyMeshIds = {
                "rbxassetid://95497877882755",
                "rbxassetid://118920880889483",
                "rbxassetid://80662423119419"
            },
            RemoveMeshIds = {
                "rbxassetid://100168191352015",
                "rbxassetid://82935541182957",
                "rbxassetid://95388370230390",
                "rbxassetid://84918196407550"
            },
            ReplacementMeshId = SNIPER_CUSTOM_REPLACEMENT_MESH_ID,
            ReplacementTextureId = SNIPER_CUSTOM_REPLACEMENT_TEXTURE_ID,
            ReplacementSize = SNIPER_CUSTOM_REPLACEMENT_SIZE,
            ReplacementOffset = SNIPER_CUSTOM_REPLACEMENT_OFFSET
        },
        ["Operator"] = {
            Skin = "Operator",
            BodyMeshIds = {
                "rbxassetid://13188893115",
                "rbxassetid://13188892761",
                "rbxassetid://14778413014",
                "rbxassetid://13188893017",
                "rbxassetid://14774727092"
            },
            RemoveMeshIds = {
                "rbxassetid://13188893310",
                "rbxassetid://13188892855"
            },
            BulletMeshIds = { "rbxassetid://14002915797" },
            MagazineMeshIds = {
                "rbxassetid://13188892532",
                "rbxassetid://13188892651"
            },
            BodyReplacementMeshId = "rbxassetid://132995629661821",
            BodyReplacementTextureId = "rbxassetid://80634410259243",
            ScopeReplacementMeshId = "rbxassetid://103988563532751",
            ScopeReplacementTextureId = "rbxassetid://136789986141252",
            MagazineReplacementMeshId = "rbxassetid://80074307887476",
            MagazineReplacementTextureId = "rbxassetid://80634410259243",
            ReplacementSize = Vector3.new(0.3, 0.3, 0.3),
            ReplacementOffset = Vector3.new(0, -0.25, 0),
            ScopeOffset = Vector3.new(0.175, 0.5, 0.005),
            MagazineOffset = Vector3.new(0.7, 0, 0.05),
            BulletOffset = Vector3.new(-1.25, 0, 0),
            ReplacementVersion = 9
        }
    }

    local DAGGERS_MESH_SKIN_OVERRIDES = {
        [DAGGERS_CUSTOM_SKIN] = {
            Skin = DAGGERS_CUSTOM_SKIN,
            SourceMeshIds = { DAGGERS_CUSTOM_SOURCE_MESH_ID },
            ReplacementMeshId = DAGGERS_CUSTOM_REPLACEMENT_MESH_ID,
            ReplacementTextureId = DAGGERS_CUSTOM_REPLACEMENT_TEXTURE_ID,
            ReplacementSize = DAGGERS_CUSTOM_REPLACEMENT_SIZE,
            ReplacementRotation = DAGGERS_CUSTOM_REPLACEMENT_ROTATION,
            ReplacementVersion = 6,
            FallbackBodyNames = { "LeftBody", "RightBody" }
        }
    }

    local SATCHEL_MESH_SKIN_OVERRIDES = {
        [SATCHEL_CUSTOM_SKIN] = {
            Skin = SATCHEL_CUSTOM_SKIN,
            SourceMeshIds = {
                "rbxassetid://138805549853994",
                "rbxassetid://125258747465100",
                "rbxassetid://111319295872696",
                "rbxassetid://129504437671598",
                "rbxassetid://104440368867933"
            },
            ReplacementMeshId = SATCHEL_CUSTOM_REPLACEMENT_MESH_ID,
            ReplacementTextureId = SATCHEL_CUSTOM_REPLACEMENT_TEXTURE_ID,
            ReplacementSize = SATCHEL_CUSTOM_REPLACEMENT_SIZE,
            WorldReplacementSize = SATCHEL_CUSTOM_WORLD_REPLACEMENT_SIZE,
            ReplacementRotation = SATCHEL_CUSTOM_REPLACEMENT_ROTATION,
            ReplacementVersion = 5
        },
        [REAVER_KNIFE_CUSTOM_SKIN] = {
            Skin = REAVER_KNIFE_CUSTOM_SKIN,
            SourceMeshIds = {
                "rbxassetid://85166039303292",
                "rbxassetid://125674590013235",
                "rbxassetid://97042702941502",
                "rbxassetid://116723276788898",
                "rbxassetid://99266754879173"
            },
            ReplacementMeshId = "rbxassetid://76054449109492",
            ReplacementTextureId = "rbxassetid://117578984602503",
            ReplacementSize = Vector3.new(0.3, 0.3, 0.3),
            ReplacementRotation = Vector3.new(0, 90, 0),
            ReplacementOffset = Vector3.new(0, 0.5, 0),
            ReplacementVersion = 3
        },
        ["sky"] = {
            Skin = "sky",
            SourceMeshIds = { "rbxassetid://140203670599306" },
            ReplacementMeshId = "rbxassetid://78577370691269",
            ReplacementTextureId = "rbxassetid://130284287910497",
            ReplacementSize = Vector3.new(0.6, 0.6, 0.6),
            ReplacementRotation = Vector3.new(0, 90, 0),
            WorldSourceMeshIds = { "rbxassetid://140203670599306" },
            WorldReplacementMeshId = "rbxassetid://111122607123480",
            WorldReplacementTextureId = "rbxassetid://86629139856581",
            WorldReplacementSize = Vector3.new(0.3, 0.3, 0.3),
            WorldReplacementRotation = Vector3.zero,
            ReplacementVersion = 2
        },
        ["Grenade Raze"] = {
            Skin = "Grenade Raze",
            SourceMeshIds = {
                "rbxassetid://87132852844264",
                "rbxassetid://96681677373844",
                "rbxassetid://121396126155803",
                "rbxassetid://121842208464560"
            },
            ReplacementMeshId = "rbxassetid://80612596590820",
            ReplacementTextureId = "rbxassetid://123233413518598",
            ReplacementSize = Vector3.new(0.8, 0.8, 0.8),
            ReplacementVersion = 2
        },
        ["Camera"] = {
            Skin = "Camera",
            SourceMeshIds = {
                "rbxassetid://17835823024",
                "rbxassetid://17835823121",
                "rbxassetid://17835823211"
            },
            ReplacementMeshId = "rbxassetid://112849634500139",
            ReplacementTextureId = "rbxassetid://126465878813440",
            ReplacementSize = Vector3.new(0.5, 0.5, 0.5),
            ReplacementRotation = Vector3.new(0, 0, -90),
            WorldSourceMeshIds = {
                "rbxassetid://17835823024",
                "rbxassetid://17835823121",
                "rbxassetid://17835823211"
            },
            WorldReplacementSize = Vector3.new(2, 2, 2),
            WorldReplacementRotation = Vector3.new(0, 90, -90),
            ReplacementVersion = 2
        }
    }

    local RPG_MESH_SKIN_OVERRIDES = {
        [RPG_CUSTOM_SKIN] = {
            Skin = RPG_CUSTOM_SKIN,
            BodyMeshIds = {
                "rbxassetid://17638908187",
                "rbxassetid://17638908626"
            },
            JuggleMeshIds = {
                "rbxassetid://17638908803",
                "rbxassetid://17638907818"
            },
            RocketMeshIds = {
                "rbxassetid://17638908803",
                "rbxassetid://17638907818"
            },
            BodyReplacementMeshId = RPG_CUSTOM_BODY_REPLACEMENT_MESH_ID,
            BodyReplacementTextureId = RPG_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID,
            ReplacementScale = RPG_CUSTOM_REPLACEMENT_SCALE,
            ReplacementRotation = RPG_CUSTOM_REPLACEMENT_ROTATION,
            ReplacementOffset = RPG_CUSTOM_REPLACEMENT_OFFSET,
            ReplacementVersion = 3
        }
    }

    local FISTS_MESH_SKIN_OVERRIDES = {
        [FISTS_CUSTOM_SKIN] = {
            Skin = FISTS_CUSTOM_SKIN,
            LeftPartName = "LeftItem",
            RightPartName = "RightItem",
            LeftMeshId = FISTS_CUSTOM_LEFT_MESH_ID,
            LeftTextureId = FISTS_CUSTOM_LEFT_TEXTURE_ID,
            RightMeshId = FISTS_CUSTOM_RIGHT_MESH_ID,
            RightTextureId = FISTS_CUSTOM_RIGHT_TEXTURE_ID,
            MeshScale = FISTS_CUSTOM_MESH_SCALE,
            LeftRotation = FISTS_CUSTOM_LEFT_ROTATION,
            RightRotation = FISTS_CUSTOM_RIGHT_ROTATION,
            ReplacementVersion = 1
        }
    }

    local BOW_MESH_SKIN_OVERRIDES = {
        [BOW_CUSTOM_SKIN] = {
            Skin = BOW_CUSTOM_SKIN,
            BodyMeshIds = {
                "rbxassetid://116947825701555",
                "rbxassetid://80510746199823"
            },
            ArrowMeshIds = {
                "rbxassetid://108027163190911",
                "rbxassetid://114261802270550"
            },
            BodyReplacementMeshId = BOW_CUSTOM_BODY_REPLACEMENT_MESH_ID,
            BodyReplacementTextureId = BOW_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID,
            ArrowReplacementMeshId = BOW_CUSTOM_ARROW_REPLACEMENT_MESH_ID,
            ArrowReplacementTextureId = BOW_CUSTOM_ARROW_REPLACEMENT_TEXTURE_ID,
            ReplacementSize = BOW_CUSTOM_REPLACEMENT_SIZE,
            ReplacementVersion = 2
        }
    }

    local ASSAULT_RIFLE_MESH_SKIN_OVERRIDES = {
        [ASSAULT_RIFLE_CUSTOM_SKIN] = {
            Skin = ASSAULT_RIFLE_CUSTOM_SKIN,
            BodyMeshIds = {
                "rbxassetid://17661950733",
                "rbxassetid://17661950585",
                "rbxassetid://17662005180",
                "rbxassetid://17662016762"
            },
            BoltMeshIds = { "rbxassetid://17661950452" },
            MagazineMeshIds = {
                "rbxassetid://17662005301",
                "rbxassetid://17662005453"
            },
            ReloadMagazineMeshIds = {
                "rbxassetid://17662005453",
                "rbxassetid://17662005301"
            },
            BodyReplacementMeshId = "rbxassetid://138100951261312",
            BodyReplacementTextureId = "rbxassetid://84167100219585",
            MagazineReplacementMeshId = "rbxassetid://92935167277909",
            MagazineReplacementTextureId = "rbxassetid://84167100219585",
            ReloadMagazineReplacementMeshId = "rbxassetid://92935167277909",
            ReloadMagazineReplacementTextureId = "rbxassetid://84167100219585",
            ReplacementSize = Vector3.new(0.35, 0.35, 0.35),
            ReplacementOffset = Vector3.new(0.1, -0.25, 0.04),
            MagazineOffset = Vector3.new(-0.135, -0.2, -0.03),
            ReplacementVersion = 6
        }
    }

    local TRIPMINE_MESH_SKIN_OVERRIDES = {
        [DICE_TRIPMINE_SKIN] = {
            Skin = DICE_TRIPMINE_SKIN,
            MeshIds = { DICE_TRIPMINE_OUTER_MESH_ID, DICE_TRIPMINE_INNER_MESH_ID },
            RemoveMeshId = TRIPMINE_STAR_REMOVE_MESH_ID,
            Scale = DICE_TRIPMINE_MESH_SCALE,
            WorldScale = DICE_TRIPMINE_WORLD_MESH_SCALE,
            WorldGroundOffset = 0.5,
            ExtraMeshScale = 1.15,
            WorldExtraMeshScale = 1,
            Color = Color3.fromRGB(255, 255, 255),
            Material = Enum.Material.SmoothPlastic,
            Reflectance = 0,
            ClearTexture = true
        },
        [SPIKE_TRIPMINE_SKIN] = {
            Skin = SPIKE_TRIPMINE_SKIN,
            MeshId = SPIKE_TRIPMINE_MESH_ID,
            RemoveMeshId = TRIPMINE_STAR_REMOVE_MESH_ID,
            Scale = SPIKE_TRIPMINE_MESH_SCALE,
            WorldScale = SPIKE_TRIPMINE_WORLD_MESH_SCALE,
            WorldGroundOffset = 0.5,
            Color = Color3.fromRGB(163, 162, 165),
            ClearTexture = true
        }
    }

    local function normalizeAssetId(assetId)
	return tostring(assetId or ""):match("%d+") or ""
end

local function getTripmineMeshIds(profile)
	local ids = {}
	if type(profile and profile.MeshIds) == "table" then
		for _, meshId in ipairs(profile.MeshIds) do
			if normalizeAssetId(meshId) ~= "" then
				table.insert(ids, meshId)
			end
		end
	elseif profile and normalizeAssetId(profile.MeshId) ~= "" then
		table.insert(ids, profile.MeshId)
	end
	return ids
end

local function getTripmineExtraMeshScale(profile, worldVisual)
	if worldVisual then
		return profile and profile.WorldExtraMeshScale or 1
	end
	return profile and profile.ExtraMeshScale or 1
end

local function getTripmineMeshSignature(profile, worldVisual)
	local normalized = {}
	for _, meshId in ipairs(getTripmineMeshIds(profile)) do
		table.insert(normalized, normalizeAssetId(meshId))
	end
	return table.concat(normalized, ",") .. "|" .. tostring(getTripmineExtraMeshScale(profile, worldVisual))
end

local function scaleTripmineMeshVector(scale, multiplier)
	multiplier = multiplier or 1
	if typeof(scale) == "Vector3" then
		return scale * multiplier
	end
	return Vector3.new(scale, scale, scale) * multiplier
end

local function meshMatchesAssetId(inst, assetId)
	local id = normalizeAssetId(assetId)
	if id == "" or typeof(inst) ~= "Instance" then return false end
	if inst:IsA("SpecialMesh") then
		return normalizeAssetId(inst.MeshId) == id or normalizeAssetId(inst.TextureId) == id
	elseif inst:IsA("MeshPart") then
		return normalizeAssetId(inst.MeshId) == id or normalizeAssetId(inst.TextureID) == id
	end
	return false
end

local function isCustomTripmineMeshIgnored(inst)
	local current = inst
	while current do
		if current:GetAttribute("__LionHiddenTripmineMesh") then
			return true
		end
		local compactName = tostring(current.Name or ""):lower():gsub("[%s_%-%p]", "")
		if compactName:find("arm", 1, true)
			or compactName:find("hand", 1, true)
			or compactName:find("fake", 1, true)
			or compactName:find("charm", 1, true)
			or compactName:find("hitbox", 1, true) then
			return true
		end
		current = current.Parent
	end
	return false
end

local function scoreCustomTripmineMeshTarget(root, meshLike, removedMeshId)
	if removedMeshId and meshMatchesAssetId(meshLike, removedMeshId) then return nil end
	local part = meshLike:IsA("SpecialMesh") and meshLike.Parent or meshLike
	if not (part and part:IsA("BasePart")) or isCustomTripmineMeshIgnored(part) then return nil end
	local score = part.Size.Magnitude
	local name = tostring(part.Name or ""):lower()
	if root:IsA("Model") and part == root.PrimaryPart then score += 1000 end
	if name:find("mesh", 1, true) then score += 500 end
	if name:find("body", 1, true) then score += 250 end
	if name:find("mine", 1, true) or name:find("trip", 1, true) then score += 250 end
	return score
end

local function findCustomTripmineMeshTarget(root, profile)
	if typeof(root) ~= "Instance" then return nil end
	local best, bestScore = nil, -math.huge
	local removedMeshId = profile and (profile.RemoveMeshId or profile.HideMeshId)
	local function consider(obj)
		if obj:IsA("SpecialMesh") or obj:IsA("MeshPart") then
			local score = scoreCustomTripmineMeshTarget(root, obj, removedMeshId)
			if score and score > bestScore then
				best = obj
				bestScore = score
			end
		end
	end
	consider(root)
	for _, descendant in ipairs(root:GetDescendants()) do
		consider(descendant)
	end
	return best
end

local function removeTripmineMeshAsset(root, assetId)
	if typeof(root) ~= "Instance" or not assetId then return end
	local remove = {}
	local function queueIfMatch(obj)
		if meshMatchesAssetId(obj, assetId) then
			local part = obj:IsA("SpecialMesh") and obj.Parent or obj
			if part and part:IsA("BasePart") then
				table.insert(remove, part)
			elseif obj:IsA("SpecialMesh") then
				table.insert(remove, obj)
			end
		end
	end
	queueIfMatch(root)
	for _, obj in ipairs(root:GetDescendants()) do
		queueIfMatch(obj)
	end
	for _, obj in ipairs(remove) do
		if obj and obj.Parent then
			obj:SetAttribute("__LionRemovedTripmineMesh", true)
			obj:Destroy()
		end
	end
end

local function removeCustomTripmineExtraMeshes(root)
	if typeof(root) ~= "Instance" then return end
	for _, obj in ipairs(root:GetDescendants()) do
		if obj:GetAttribute("__LionCustomTripmineExtraMesh") then
			obj:Destroy()
		end
	end
end

local function getMeshLikePart(obj)
	if typeof(obj) ~= "Instance" then return nil end
	if obj:IsA("SpecialMesh") then
		return obj.Parent and obj.Parent:IsA("BasePart") and obj.Parent or nil
	end
	return obj:IsA("BasePart") and obj or nil
end

local function meshMatchesAnyAssetId(inst, assetIds)
	for _, assetId in ipairs(assetIds or {}) do
		if meshMatchesAssetId(inst, assetId) then
			return true
		end
	end
	return false
end

local function rotationCFrameFromDegrees(rotation)
	if typeof(rotation) ~= "Vector3" then return CFrame.identity end
	return CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z))
end

local function namePathContains(inst, needle)
	needle = tostring(needle or ""):lower()
	if needle == "" then return false end
	local current = inst
	while current and current ~= game do
		if tostring(current.Name or ""):lower():find(needle, 1, true) then
			return true
		end
		current = current.Parent
	end
	return false
end

local function hideDaggerMeshAnchor(part)
	if not (part and part:IsA("BasePart")) then return end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__LionDaggerHiddenAnchor", true)
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.TextureId = "" end)
		end
	end
end

local function addReplacementSpecialMesh(part, profile, defaultScale)
	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.FileMesh
	mesh.MeshId = profile.ReplacementMeshId
	pcall(function() mesh.TextureId = profile.ReplacementTextureId or "" end)
	mesh.Scale = profile.ReplacementMeshScale or profile.ReplacementSize or defaultScale or Vector3.new(1, 1, 1)
	pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
	mesh.Parent = part
	return mesh
end

local function createDaggerReplacementMeshPart(anchor, profile)
	if not (anchor and anchor:IsA("BasePart")) then return false end
	if anchor:GetAttribute("__LionDaggerReplacementMeshPart") then return true end

	local parent = anchor.Parent
	if not parent then return false end
	local originalName = anchor.Name
	anchor.Name = "__LionDaggerAnchor_" .. originalName

	local replacement = Instance.new("Part")
	replacement.Name = originalName
	replacement.Size = Vector3.new(1, 1, 1)
	replacement.CFrame = anchor.CFrame * rotationCFrameFromDegrees(profile.ReplacementRotation)
	replacement.Anchored = anchor.Anchored
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Color = Color3.fromRGB(255, 255, 255)
	pcall(function() replacement.Material = anchor.Material end)
	pcall(function() replacement.CastShadow = false end)
	replacement:SetAttribute("__LionCustomDaggerMesh", true)
	replacement:SetAttribute("__LionDaggerReplacementMeshPart", true)
	replacement:SetAttribute("IgnoreTransparency", true)
	addReplacementSpecialMesh(replacement, profile)
	local wrapGroup = anchor:GetAttribute("WrapGroup")
	if wrapGroup ~= nil then
		replacement:SetAttribute("WrapGroup", wrapGroup)
	end
	pcall(function()
		if collectionService:HasTag(anchor, "Wrappable") then
			collectionService:AddTag(replacement, "Wrappable")
		end
	end)
	replacement.Parent = parent

	local weld = Instance.new("WeldConstraint")
	weld.Name = "__LionDaggerReplacementWeld"
	weld.Part0 = anchor
	weld.Part1 = replacement
	weld.Parent = replacement

	hideDaggerMeshAnchor(anchor)
	return true
end

local function applyMeshReplacementToObject(obj, profile)
	if typeof(obj) ~= "Instance" then return false end
	if obj:GetAttribute("__LionDaggerReplacementMeshPart") or obj:GetAttribute("__LionDaggerHiddenAnchor") then
		return false
	end
	local part = getMeshLikePart(obj)
	if obj:IsA("MeshPart") then
		return createDaggerReplacementMeshPart(obj, profile)
	elseif obj:IsA("SpecialMesh") then
		if part then
			part.Transparency = 0
			part.LocalTransparencyModifier = 0
			part.Color = Color3.fromRGB(255, 255, 255)
			pcall(function() part.CastShadow = false end)
			if profile.ReplacementRotation then
				part.CFrame = part.CFrame * rotationCFrameFromDegrees(profile.ReplacementRotation)
			end
		end
		pcall(function() obj.MeshId = profile.ReplacementMeshId end)
		pcall(function() obj.TextureId = profile.ReplacementTextureId or "" end)
		if profile.ReplacementSize then
			pcall(function() obj.Scale = profile.ReplacementSize end)
		end
		obj:SetAttribute("__LionCustomDaggerMesh", true)
		return true
	end
	return false
end

local function getDaggerMeshSignature(profile)
	local size = profile.ReplacementSize or Vector3.zero
	local rotation = profile.ReplacementRotation or Vector3.zero
	return table.concat({
		table.concat(profile.SourceMeshIds or {}, ","),
		tostring(profile.ReplacementMeshId or ""),
		tostring(profile.ReplacementTextureId or ""),
		tostring(size.X),
		tostring(size.Y),
		tostring(size.Z),
		tostring(rotation.X),
		tostring(rotation.Y),
		tostring(rotation.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applyDaggerMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getDaggerMeshSignature(profile)
	if root:GetAttribute("__LionDaggerMeshSkin") == profile.Skin
		and root:GetAttribute("__LionDaggerMeshSignature") == signature then
		return true
	end

	local replaced, seen = 0, {}
	local function replaceIfTarget(obj)
		if seen[obj] or not meshMatchesAnyAssetId(obj, profile.SourceMeshIds) then return end
		seen[obj] = true
		if applyMeshReplacementToObject(obj, profile) then
			replaced += 1
		end
	end

	replaceIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		replaceIfTarget(obj)
	end

	for _, bodyName in ipairs(profile.FallbackBodyNames or {}) do
		for _, obj in ipairs(root:GetDescendants()) do
			if obj.Name == bodyName then
				local target = obj:FindFirstChild("MeshPart")
				if target and not seen[target] and target:IsA("MeshPart") then
					seen[target] = true
					if applyMeshReplacementToObject(target, profile) then
						replaced += 1
					end
				end
			end
		end
	end

	root:SetAttribute("__LionDaggerMeshSkin", profile.Skin)
	root:SetAttribute("__LionDaggerMeshSignature", signature)
	root:SetAttribute("__LionDaggerMeshCount", replaced)
	return replaced > 0
end

local function hideSatchelMeshAnchor(part)
	if not (part and part:IsA("BasePart")) then return end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__LionSatchelHiddenAnchor", true)
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
		pcall(function() part.MeshId = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.MeshId = "" end)
			pcall(function() child.TextureId = "" end)
		end
	end
end

local function getReplacementAverageCFrame(parts)
	local first = parts and parts[1]
	if not first then return CFrame.identity end
	local position = Vector3.zero
	for _, part in ipairs(parts) do
		position += part.Position
	end
	position /= #parts
	return CFrame.new(position) * (first.CFrame - first.CFrame.Position)
end

local function createSatchelReplacementMeshPart(root, profile, anchors)
	local anchor = anchors and anchors[1]
	if not (anchor and anchor:IsA("BasePart")) then return false end
	local parent = anchor.Parent
	if not parent then return false end

	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:GetAttribute("__LionSatchelReplacementMeshPart") then
			descendant:Destroy()
		end
	end

	local replacement = Instance.new("Part")
	replacement.Name = "__LionCustomSatchelReplacement"
	replacement.Size = Vector3.new(1, 1, 1)
	replacement.CFrame = getReplacementAverageCFrame(anchors)
		* CFrame.new(profile.ReplacementOffset or Vector3.zero)
		* rotationCFrameFromDegrees(profile.ReplacementRotation)
	replacement.Anchored = anchor.Anchored
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Color = Color3.fromRGB(255, 255, 255)
	pcall(function() replacement.Material = anchor.Material end)
	pcall(function() replacement.CastShadow = false end)
	replacement:SetAttribute("__LionCustomSatchelMesh", true)
	replacement:SetAttribute("__LionSatchelReplacementMeshPart", true)
	replacement:SetAttribute("IgnoreTransparency", true)
	addReplacementSpecialMesh(replacement, profile, Vector3.new(1, 1, 1))
	local wrapGroup = anchor:GetAttribute("WrapGroup")
	if wrapGroup ~= nil then
		replacement:SetAttribute("WrapGroup", wrapGroup)
	end
	pcall(function()
		if collectionService:HasTag(anchor, "Wrappable") then
			collectionService:AddTag(replacement, "Wrappable")
		end
	end)
	replacement.Parent = parent

	local weld = Instance.new("WeldConstraint")
	weld.Name = "__LionSatchelReplacementWeld"
	weld.Part0 = anchor
	weld.Part1 = replacement
	weld.Parent = replacement

	for _, part in ipairs(anchors) do
		if part and part.Parent then
			if not part.Name:find("__LionSatchelAnchor_", 1, true) then
				part.Name = "__LionSatchelAnchor_" .. part.Name
			end
			hideSatchelMeshAnchor(part)
		end
	end
	return true
end

local function applySatchelReplacementToObject(obj, profile)
	if typeof(obj) ~= "Instance" then return false end
	if obj:GetAttribute("__LionSatchelReplacementMeshPart") then return false end
	local part = getMeshLikePart(obj)
	if part and part:GetAttribute("__LionSatchelHiddenAnchor") then return false end
	return part and createSatchelReplacementMeshPart(part.Parent or part, profile, { part }) or false
end

local function getSatchelMeshSignature(profile)
	local rotation = profile.ReplacementRotation or Vector3.zero
	local offset = profile.ReplacementOffset or Vector3.zero
	local size = profile.ReplacementSize or Vector3.zero
	return table.concat({
		table.concat(profile.SourceMeshIds or {}, ","),
		tostring(profile.ReplacementMeshId or ""),
		tostring(profile.ReplacementTextureId or ""),
		tostring(size.X),
		tostring(size.Y),
		tostring(size.Z),
		tostring(offset.X),
		tostring(offset.Y),
		tostring(offset.Z),
		tostring(rotation.X),
		tostring(rotation.Y),
		tostring(rotation.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applySatchelMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getSatchelMeshSignature(profile)
	if root:GetAttribute("__LionSatchelMeshSkin") == profile.Skin
		and root:GetAttribute("__LionSatchelMeshSignature") == signature then
		return true
	end

	local bodyParts, seenObjects, seenParts = {}, {}, {}
	local function replaceIfTarget(obj)
		if seenObjects[obj] or not meshMatchesAnyAssetId(obj, profile.SourceMeshIds) then return end
		seenObjects[obj] = true
		local part = getMeshLikePart(obj)
		if part and not seenParts[part] then
			seenParts[part] = true
			table.insert(bodyParts, part)
		end
	end

	replaceIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		replaceIfTarget(obj)
	end

	local replaced = createSatchelReplacementMeshPart(root, profile, bodyParts) and 1 or 0

	root:SetAttribute("__LionSatchelMeshSkin", profile.Skin)
	root:SetAttribute("__LionSatchelMeshSignature", signature)
	root:SetAttribute("__LionSatchelMeshCount", replaced)
	return replaced > 0
end

local function getSatchelMeshProfileForAsset(cosmeticName, worldAsset)
	local profile = SATCHEL_MESH_SKIN_OVERRIDES[cosmeticName]
	if profile and worldAsset and (
		profile.WorldSourceMeshIds
		or profile.WorldReplacementMeshId
		or profile.WorldReplacementTextureId
		or profile.WorldReplacementSize
		or profile.WorldReplacementRotation
		or profile.WorldReplacementOffset
	) then
		local worldProfile = table.clone(profile)
		worldProfile.SourceMeshIds = profile.WorldSourceMeshIds or profile.SourceMeshIds
		worldProfile.ReplacementMeshId = profile.WorldReplacementMeshId or profile.ReplacementMeshId
		worldProfile.ReplacementTextureId = profile.WorldReplacementTextureId or profile.ReplacementTextureId
		worldProfile.ReplacementSize = profile.WorldReplacementSize or profile.ReplacementSize
		worldProfile.ReplacementRotation = profile.WorldReplacementRotation or profile.ReplacementRotation
		worldProfile.ReplacementOffset = profile.WorldReplacementOffset or profile.ReplacementOffset
		return worldProfile
	end
	return profile
end

local function hideRpgMeshPart(part)
	if not (part and part:IsA("BasePart")) then return false end
	if part:GetAttribute("__LionRpgHiddenPart") then return true end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__LionRpgHiddenPart", true)
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	part:SetAttribute("WrapGroup", 0)
	pcall(function() part:RemoveTag("Wrappable") end)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
		pcall(function() part.MeshId = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.MeshId = "" end)
			pcall(function() child.TextureId = "" end)
		elseif child:IsA("Highlight") then
			child.Enabled = false
		end
	end
	return true
end

local function applyRpgMeshReplacement(obj, meshId, textureId, profile)
	local part = getMeshLikePart(obj)
	if not part or part:GetAttribute("__LionRpgHiddenPart") then return false end
	part.Transparency = 0
	part.LocalTransparencyModifier = 0
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	part:SetAttribute("__LionCustomRpgMesh", true)
	part:SetAttribute("IgnoreTransparency", true)
	if not part:GetAttribute("__LionRpgReplacementAdjusted") then
		local scale = tonumber(profile and profile.ReplacementScale) or 1
		if scale ~= 1 then
			pcall(function()
				part.Size = part.Size * scale
			end)
		end
		if profile and profile.ReplacementOffset then
			pcall(function()
				part.CFrame = part.CFrame * CFrame.new(profile.ReplacementOffset)
			end)
		end
		if profile and profile.ReplacementRotation then
			pcall(function()
				part.CFrame = part.CFrame * rotationCFrameFromDegrees(profile.ReplacementRotation)
			end)
		end
		part:SetAttribute("__LionRpgReplacementAdjusted", true)
	end
	if obj:IsA("MeshPart") then
		pcall(function() obj.MeshId = meshId end)
		pcall(function() obj.TextureID = textureId or "" end)
		return true
	elseif obj:IsA("SpecialMesh") then
		pcall(function() obj.MeshType = Enum.MeshType.FileMesh end)
		pcall(function() obj.MeshId = meshId end)
		pcall(function() obj.TextureId = textureId or "" end)
		pcall(function() obj.VertexColor = Vector3.new(1, 1, 1) end)
		return true
	end
	return false
end

local function getRpgMeshSignature(profile)
	local rotation = profile.ReplacementRotation or Vector3.zero
	local offset = profile.ReplacementOffset or Vector3.zero
	return table.concat({
		table.concat(profile.BodyMeshIds or {}, ","),
		table.concat(profile.JuggleMeshIds or {}, ","),
		table.concat(profile.RocketMeshIds or {}, ","),
		tostring(profile.BodyReplacementMeshId or ""),
		tostring(profile.BodyReplacementTextureId or ""),
		tostring(profile.ReplacementScale or 1),
		tostring(rotation.X),
		tostring(rotation.Y),
		tostring(rotation.Z),
		tostring(offset.X),
		tostring(offset.Y),
		tostring(offset.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applyRpgMeshProfile(root, profile, options)
	if typeof(root) ~= "Instance" or not profile then return false end
	options = options or {}
	local signature = getRpgMeshSignature(profile)
	if root:GetAttribute("__LionRpgMeshSkin") == profile.Skin
		and root:GetAttribute("__LionRpgMeshSignature") == signature
		and root:GetAttribute("__LionRpgRocketVisible") == false then
		return true
	end

	local changed, removed, seen = 0, 0, {}
	local function applyIfTarget(obj)
		if seen[obj] then return end
		if not (meshMatchesAnyAssetId(obj, profile.BodyMeshIds)
			or meshMatchesAnyAssetId(obj, profile.JuggleMeshIds)
			or meshMatchesAnyAssetId(obj, profile.RocketMeshIds)) then
			return
		end
		seen[obj] = true
		local part = getMeshLikePart(obj)
		if not part then return end
		if (namePathContains(obj, "rocket") and meshMatchesAnyAssetId(obj, profile.RocketMeshIds))
			or (namePathContains(obj, "juggle") and meshMatchesAnyAssetId(obj, profile.JuggleMeshIds)) then
			if hideRpgMeshPart(part) then removed += 1 end
		elseif meshMatchesAnyAssetId(obj, profile.BodyMeshIds) then
			if applyRpgMeshReplacement(obj, profile.BodyReplacementMeshId, profile.BodyReplacementTextureId, profile) then
				changed += 1
			end
		end
	end

	applyIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		applyIfTarget(obj)
	end

	root:SetAttribute("__LionRpgMeshSkin", profile.Skin)
	root:SetAttribute("__LionRpgMeshSignature", signature)
	root:SetAttribute("__LionRpgRocketVisible", false)
	root:SetAttribute("__LionRpgMeshCount", changed)
	root:SetAttribute("__LionRpgHiddenCount", removed)
	return changed > 0 or removed > 0
end

local function createFistsReplacementPart(part, meshId, textureId, meshScale, rotation)
	if not (part and part:IsA("BasePart")) then return false end
	for _, child in ipairs(part:GetChildren()) do
		child:Destroy()
	end

	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	part:SetAttribute("__LionFistsHiddenAnchor", true)
	part:SetAttribute("IgnoreTransparency", true)

	local replacement = Instance.new("Part")
	replacement.Name = "__LionCustomFistsMesh"
	replacement.Size = part.Size
	replacement.CFrame = part.CFrame * rotationCFrameFromDegrees(rotation)
	replacement.Anchored = false
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Transparency = 0
	replacement.LocalTransparencyModifier = 0
	replacement:SetAttribute("__LionCustomFistsMesh", true)
	replacement:SetAttribute("IgnoreTransparency", true)
	replacement.Parent = part

	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.FileMesh
	mesh.MeshId = meshId
	pcall(function() mesh.TextureId = textureId or "" end)
	mesh.Scale = meshScale or Vector3.new(0.1, 0.1, 0.1)
	pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
	mesh.Parent = replacement

	local weld = Instance.new("WeldConstraint")
	weld.Name = "__LionCustomFistsMeshWeld"
	weld.Part0 = part
	weld.Part1 = replacement
	weld.Parent = replacement
	return true
end

local function getFistsMeshSignature(profile)
	local scale = profile.MeshScale or Vector3.zero
	local leftRotation = profile.LeftRotation or Vector3.zero
	local rightRotation = profile.RightRotation or Vector3.zero
	return table.concat({
		tostring(profile.LeftMeshId or ""),
		tostring(profile.LeftTextureId or ""),
		tostring(profile.RightMeshId or ""),
		tostring(profile.RightTextureId or ""),
		tostring(scale.X),
		tostring(scale.Y),
		tostring(scale.Z),
		tostring(leftRotation.X),
		tostring(leftRotation.Y),
		tostring(leftRotation.Z),
		tostring(rightRotation.X),
		tostring(rightRotation.Y),
		tostring(rightRotation.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applyFistsMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getFistsMeshSignature(profile)
	if root:GetAttribute("__LionFistsMeshSkin") == profile.Skin
		and root:GetAttribute("__LionFistsMeshSignature") == signature
		and (root:GetAttribute("__LionFistsMeshCount") or 0) > 0 then
		return true
	end

	local left = findDescendantByName(root, profile.LeftPartName or "LeftItem")
	local right = findDescendantByName(root, profile.RightPartName or "RightItem")
	local applied = 0
	if createFistsReplacementPart(left, profile.LeftMeshId, profile.LeftTextureId, profile.MeshScale, profile.LeftRotation) then
		applied += 1
	end
	if createFistsReplacementPart(right, profile.RightMeshId, profile.RightTextureId, profile.MeshScale, profile.RightRotation) then
		applied += 1
	end

	root:SetAttribute("__LionFistsMeshSkin", profile.Skin)
	root:SetAttribute("__LionFistsMeshSignature", signature)
	root:SetAttribute("__LionFistsMeshCount", applied)
	return applied > 0
end

local function hideBowMeshAnchor(part)
	if not (part and part:IsA("BasePart")) then return false end
	if part:GetAttribute("__LionBowHiddenAnchor") then return true end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__LionBowHiddenAnchor", true)
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	pcall(function() part:RemoveTag("Wrappable") end)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
		pcall(function() part.MeshId = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.MeshId = "" end)
			pcall(function() child.TextureId = "" end)
		elseif child:IsA("Highlight") then
			child.Enabled = false
		end
	end
	return true
end

local function createBowReplacementMeshPart(root, anchors, replacementName, meshId, textureId, profile)
	local anchor = anchors and anchors[1]
	if not (anchor and anchor:IsA("BasePart")) then return false end
	local parent = anchor.Parent or root
	if not parent then return false end

	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:GetAttribute("__LionBowReplacementMeshPart") and descendant.Name == replacementName then
			descendant:Destroy()
		end
	end

	local replacement = Instance.new("Part")
	replacement.Name = replacementName
	replacement.Size = Vector3.new(1, 1, 1)
	replacement.CFrame = getReplacementAverageCFrame(anchors)
	replacement.Anchored = anchor.Anchored
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Transparency = 0
	replacement.LocalTransparencyModifier = 0
	replacement:SetAttribute("__LionCustomBowMesh", true)
	replacement:SetAttribute("__LionBowReplacementMeshPart", true)
	replacement:SetAttribute("IgnoreTransparency", true)

	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.FileMesh
	mesh.MeshId = meshId
	pcall(function() mesh.TextureId = textureId or "" end)
	mesh.Scale = profile.ReplacementSize or Vector3.new(0.5, 0.5, 0.5)
	pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
	mesh.Parent = replacement

	local wrapGroup = anchor:GetAttribute("WrapGroup")
	if wrapGroup ~= nil then
		replacement:SetAttribute("WrapGroup", wrapGroup)
	end
	pcall(function()
		if collectionService:HasTag(anchor, "Wrappable") then
			collectionService:AddTag(replacement, "Wrappable")
		end
	end)
	replacement.Parent = parent

	if not replacement.Anchored then
		local weld = Instance.new("WeldConstraint")
		weld.Name = "__LionBowReplacementWeld"
		weld.Part0 = anchor
		weld.Part1 = replacement
		weld.Parent = replacement
	end

	for _, part in ipairs(anchors) do
		hideBowMeshAnchor(part)
	end
	return true
end

local function getBowMeshSignature(profile)
	local size = profile.ReplacementSize or Vector3.zero
	return table.concat({
		table.concat(profile.BodyMeshIds or {}, ","),
		table.concat(profile.ArrowMeshIds or {}, ","),
		tostring(profile.BodyReplacementMeshId or ""),
		tostring(profile.BodyReplacementTextureId or ""),
		tostring(profile.ArrowReplacementMeshId or ""),
		tostring(profile.ArrowReplacementTextureId or ""),
		tostring(size.X),
		tostring(size.Y),
		tostring(size.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applyBowMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getBowMeshSignature(profile)
	if root:GetAttribute("__LionBowMeshSkin") == profile.Skin
		and root:GetAttribute("__LionBowMeshSignature") == signature
		and (root:GetAttribute("__LionBowMeshCount") or 0) > 0 then
		return true
	end

	local bodyParts, arrowParts, seenParts = {}, {}, {}
	local function collectIfTarget(obj)
		local part = getMeshLikePart(obj)
		if not part or seenParts[part] then return end
		if meshMatchesAnyAssetId(obj, profile.BodyMeshIds) then
			seenParts[part] = true
			table.insert(bodyParts, part)
		elseif meshMatchesAnyAssetId(obj, profile.ArrowMeshIds) then
			seenParts[part] = true
			table.insert(arrowParts, part)
		end
	end

	collectIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		collectIfTarget(obj)
	end

	local applied = 0
	if createBowReplacementMeshPart(root, bodyParts, "__LionCustomBowBody", profile.BodyReplacementMeshId, profile.BodyReplacementTextureId, profile) then
		applied += 1
	end
	if createBowReplacementMeshPart(root, arrowParts, "__LionCustomBowArrow", profile.ArrowReplacementMeshId, profile.ArrowReplacementTextureId, profile) then
		applied += 1
	end

	root:SetAttribute("__LionBowMeshSkin", profile.Skin)
	root:SetAttribute("__LionBowMeshSignature", signature)
	root:SetAttribute("__LionBowMeshCount", applied)
	return applied > 0
end

local function hideAssaultRifleMeshAnchor(part, anchorType)
	if not (part and part:IsA("BasePart")) then return false end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__LionAssaultRifleHiddenAnchor", true)
	part:SetAttribute("__LionAssaultRifleAnchorType", anchorType or "Part")
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	pcall(function() part:RemoveTag("Wrappable") end)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
		pcall(function() part.MeshId = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.MeshId = "" end)
			pcall(function() child.TextureId = "" end)
		elseif child:IsA("Highlight") then
			child.Enabled = false
		end
	end
	return true
end

local function createAssaultRifleReplacementMeshPart(root, anchor, replacementName, meshId, textureId, cframe, profile)
	if not (anchor and anchor:IsA("BasePart")) then return false end
	local parent = anchor.Parent or root
	if not parent then return false end

	local replacement = Instance.new("MeshPart")
	replacement.Name = replacementName
	replacement.Size = profile.ReplacementSize or Vector3.new(0.35, 0.35, 0.35)
	replacement.CFrame = cframe or anchor.CFrame
	replacement.Anchored = anchor.Anchored
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Transparency = 0
	replacement.LocalTransparencyModifier = 0
	replacement.Color = Color3.fromRGB(255, 255, 255)
	pcall(function() replacement.MeshId = meshId end)
	pcall(function() replacement.TextureID = textureId or "" end)
	pcall(function() replacement.Material = anchor.Material end)
	pcall(function() replacement.CastShadow = false end)
	replacement:SetAttribute("__LionCustomAssaultRifleMesh", true)
	replacement:SetAttribute("__LionAssaultRifleReplacementMeshPart", true)
	replacement:SetAttribute("IgnoreTransparency", true)

	local wrapGroup = anchor:GetAttribute("WrapGroup")
	if wrapGroup ~= nil then
		replacement:SetAttribute("WrapGroup", wrapGroup)
	end
	pcall(function()
		if collectionService:HasTag(anchor, "Wrappable") then
			collectionService:AddTag(replacement, "Wrappable")
		end
	end)
	replacement.Parent = parent

	if not replacement.Anchored then
		local weld = Instance.new("WeldConstraint")
		weld.Name = "__LionAssaultRifleReplacementWeld"
		weld.Part0 = anchor
		weld.Part1 = replacement
		weld.Parent = replacement
	end

	return true
end

local function getAssaultRifleMeshSignature(profile)
	local size = profile.ReplacementSize or Vector3.zero
	local replacementOffset = profile.ReplacementOffset or Vector3.zero
	local magazineOffset = profile.MagazineOffset or Vector3.zero
	return table.concat({
		table.concat(profile.BodyMeshIds or {}, ","),
		table.concat(profile.BoltMeshIds or {}, ","),
		table.concat(profile.MagazineMeshIds or {}, ","),
		table.concat(profile.ReloadMagazineMeshIds or {}, ","),
		tostring(profile.BodyReplacementMeshId or ""),
		tostring(profile.BodyReplacementTextureId or ""),
		tostring(profile.MagazineReplacementMeshId or ""),
		tostring(profile.MagazineReplacementTextureId or ""),
		tostring(profile.ReloadMagazineReplacementMeshId or ""),
		tostring(profile.ReloadMagazineReplacementTextureId or ""),
		tostring(size.X),
		tostring(size.Y),
		tostring(size.Z),
		tostring(replacementOffset.X),
		tostring(replacementOffset.Y),
		tostring(replacementOffset.Z),
		tostring(magazineOffset.X),
		tostring(magazineOffset.Y),
		tostring(magazineOffset.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applyAssaultRifleMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getAssaultRifleMeshSignature(profile)
	if root:GetAttribute("__LionAssaultRifleMeshSkin") == profile.Skin
		and root:GetAttribute("__LionAssaultRifleMeshSignature") == signature
		and (root:GetAttribute("__LionAssaultRifleMeshCount") or 0) > 0 then
		return true
	end

	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:GetAttribute("__LionAssaultRifleReplacementMeshPart") then
			descendant:Destroy()
		end
	end

	local bodyParts, magazineParts, reloadMagazineParts, boltParts, seenParts = {}, {}, {}, {}, {}
	local function collectIfTarget(obj)
		local part = getMeshLikePart(obj)
		if not part or seenParts[part] then return end
		local previousType = part:GetAttribute("__LionAssaultRifleAnchorType")
		local isReloadMagazine = previousType == "ReloadMagazine"
			or (meshMatchesAnyAssetId(obj, profile.ReloadMagazineMeshIds) and namePathContains(obj, "reload"))
		if previousType == "Body" or meshMatchesAnyAssetId(obj, profile.BodyMeshIds) then
			seenParts[part] = true
			table.insert(bodyParts, part)
		elseif isReloadMagazine then
			seenParts[part] = true
			table.insert(reloadMagazineParts, part)
		elseif previousType == "Magazine" or meshMatchesAnyAssetId(obj, profile.MagazineMeshIds) or meshMatchesAnyAssetId(obj, profile.ReloadMagazineMeshIds) then
			seenParts[part] = true
			table.insert(magazineParts, part)
		elseif previousType == "Bolt" or meshMatchesAnyAssetId(obj, profile.BoltMeshIds) then
			seenParts[part] = true
			table.insert(boltParts, part)
		end
	end

	collectIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		collectIfTarget(obj)
	end

	local bodyAnchor = bodyParts[1] or magazineParts[1] or boltParts[1]
	local magazineAnchor = magazineParts[1] or bodyAnchor
	local reloadMagazineAnchor = reloadMagazineParts[1] or magazineAnchor
	local bodyCFrame = bodyParts[1] and getReplacementAverageCFrame(bodyParts) or (bodyAnchor and bodyAnchor.CFrame) or CFrame.identity
	local reloadMagazineCFrame = reloadMagazineParts[1] and getReplacementAverageCFrame(reloadMagazineParts) or bodyCFrame
	local replacementOffset = profile.ReplacementOffset or Vector3.zero
	local magazineOffset = profile.MagazineOffset or Vector3.zero
	bodyCFrame = bodyCFrame * CFrame.new(replacementOffset)
	reloadMagazineCFrame = reloadMagazineCFrame * CFrame.new(replacementOffset)
	local applied = 0
	if createAssaultRifleReplacementMeshPart(root, bodyAnchor, "__LionCustomAssaultRifleBody", profile.BodyReplacementMeshId, profile.BodyReplacementTextureId, bodyCFrame, profile) then
		applied += 1
	end
	if createAssaultRifleReplacementMeshPart(root, magazineAnchor, "__LionCustomAssaultRifleMagazine", profile.MagazineReplacementMeshId, profile.MagazineReplacementTextureId, bodyCFrame * CFrame.new(magazineOffset), profile) then
		applied += 1
	end
	if reloadMagazineParts[1] and createAssaultRifleReplacementMeshPart(root, reloadMagazineAnchor, "__LionCustomAssaultRifleReloadMagazine", profile.ReloadMagazineReplacementMeshId or profile.MagazineReplacementMeshId, profile.ReloadMagazineReplacementTextureId or profile.MagazineReplacementTextureId, reloadMagazineCFrame, profile) then
		applied += 1
	end

	for _, part in ipairs(bodyParts) do
		hideAssaultRifleMeshAnchor(part, "Body")
	end
	for _, part in ipairs(magazineParts) do
		hideAssaultRifleMeshAnchor(part, "Magazine")
	end
	for _, part in ipairs(reloadMagazineParts) do
		hideAssaultRifleMeshAnchor(part, "ReloadMagazine")
	end
	for _, part in ipairs(boltParts) do
		hideAssaultRifleMeshAnchor(part, "Bolt")
	end

	root:SetAttribute("__LionAssaultRifleMeshSkin", profile.Skin)
	root:SetAttribute("__LionAssaultRifleMeshSignature", signature)
	root:SetAttribute("__LionAssaultRifleMeshCount", applied)
	return applied > 0
end

function __LionHideSniperMeshAnchor(part, anchorType)
	if not (part and part:IsA("BasePart")) then return false end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Material = Enum.Material.SmoothPlastic end)
	pcall(function() part.Reflectance = 0 end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__LionHiddenSniperMesh", true)
	part:SetAttribute("__LionCustomSniperHiddenPart", true)
	part:SetAttribute("__LionSniperAnchorType", anchorType or "Part")
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	part:SetAttribute("WrapGroup", 0)
	pcall(function() part:RemoveTag("Wrappable") end)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
		pcall(function() part.MeshId = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.MeshId = "" end)
			pcall(function() child.TextureId = "" end)
		elseif child:IsA("Highlight") then
			child.Enabled = false
		end
	end
	return true
end

function __LionOffsetSniperVisibleAnchor(part, anchorType, offset)
	if not (part and part:IsA("BasePart")) then return false end
	local originalCFrame = part:GetAttribute("__LionSniperOriginalCFrame")
	if typeof(originalCFrame) ~= "CFrame" then
		originalCFrame = part.CFrame
		part:SetAttribute("__LionSniperOriginalCFrame", originalCFrame)
	end
	part.CFrame = originalCFrame * CFrame.new(offset or Vector3.zero)
	part:SetAttribute("__LionSniperAnchorType", anchorType or "Part")
	part:SetAttribute("__LionSniperVisibleOffset", true)
	return true
end

local function hideSniperMeshId(root, assetId)
	local parts = {}
	if typeof(root) ~= "Instance" or not assetId then return parts end
	local seen = {}

	local function hideIfMatch(obj)
		if not meshMatchesAssetId(obj, assetId) then return end
		local part = getMeshLikePart(obj)
		if part and not seen[part] then
			seen[part] = true
			if __LionHideSniperMeshAnchor(part) then
				table.insert(parts, part)
			end
		elseif obj:IsA("SpecialMesh") then
			obj.Scale = Vector3.zero
		end
	end

	hideIfMatch(root)
	for _, obj in ipairs(root:GetDescendants()) do
		hideIfMatch(obj)
	end
	return parts
end

local function getAverageCFrame(parts)
	local first = parts[1]
	if not first then return CFrame.identity end
	local position = Vector3.zero
	for _, part in ipairs(parts) do
		position += part.Position
	end
	position /= #parts
	return CFrame.new(position) * (first.CFrame - first.CFrame.Position)
end

function __LionCreateSniperReplacementMeshPart(root, anchor, replacementName, meshId, textureId, cframe, profile)
	if not (anchor and anchor:IsA("BasePart")) then return false end
	local parent = anchor.Parent or root
	if not parent then return false end

	local replacement = Instance.new("MeshPart")
	replacement.Name = replacementName
	pcall(function() replacement.MeshId = meshId end)
	pcall(function() replacement.TextureID = textureId or "" end)
	replacement.Size = profile.ReplacementSize or Vector3.new(0.05, 0.05, 0.05)
	replacement.CFrame = cframe or anchor.CFrame
	replacement.Anchored = anchor.Anchored
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Transparency = 0
	replacement.LocalTransparencyModifier = 0
	replacement.Color = Color3.fromRGB(255, 255, 255)
	pcall(function() replacement.Material = anchor.Material end)
	pcall(function() replacement.CastShadow = false end)
	replacement:SetAttribute("__LionCustomSniperReplacement", true)
	replacement:SetAttribute("WrapGroup", 1)
	replacement:SetAttribute("IgnoreTransparency", true)
	pcall(function() replacement:AddTag("Wrappable") end)
	pcall(function() collectionService:AddTag(replacement, "Wrappable") end)
	replacement.Parent = parent

	if not replacement.Anchored then
		local weld = Instance.new("WeldConstraint")
		weld.Name = "__LionCustomSniperReplacementWeld"
		weld.Part0 = anchor
		weld.Part1 = replacement
		weld.Parent = replacement
	end
	return true
end

local function setupSniperReplacementPart(root, profile, bodyParts)
	local anchor = bodyParts[1]
	if not anchor then return false end
	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:GetAttribute("__LionCustomSniperReplacement") then
			descendant:Destroy()
		end
	end

	return __LionCreateSniperReplacementMeshPart(
		root,
		anchor,
		"__LionCustomSniperReplacement",
		profile.ReplacementMeshId,
		profile.ReplacementTextureId,
		getAverageCFrame(bodyParts) * CFrame.new(profile.ReplacementOffset or Vector3.zero),
		profile
	)
end

local function getSniperMeshSignature(profile)
	local body = table.concat(profile.BodyMeshIds or {}, ",")
	local remove = table.concat(profile.RemoveMeshIds or {}, ",")
	local magazine = table.concat(profile.MagazineMeshIds or {}, ",")
	local bullet = table.concat(profile.BulletMeshIds or {}, ",")
	local size = profile.ReplacementSize or Vector3.zero
	local offset = profile.ReplacementOffset or Vector3.zero
	local bulletOffset = profile.BulletOffset or Vector3.zero
	return table.concat({
		body,
		remove,
		magazine,
		bullet,
		tostring(profile.ReplacementMeshId or ""),
		tostring(profile.ReplacementTextureId or ""),
		tostring(profile.BodyReplacementMeshId or ""),
		tostring(profile.BodyReplacementTextureId or ""),
		tostring(profile.ScopeReplacementMeshId or ""),
		tostring(profile.ScopeReplacementTextureId or ""),
		tostring(profile.MagazineReplacementMeshId or ""),
		tostring(profile.MagazineReplacementTextureId or ""),
		tostring(size.X),
		tostring(size.Y),
		tostring(size.Z),
		tostring(offset.X),
		tostring(offset.Y),
		tostring(offset.Z),
		tostring((profile.ScopeOffset or Vector3.zero).X),
		tostring((profile.ScopeOffset or Vector3.zero).Y),
		tostring((profile.ScopeOffset or Vector3.zero).Z),
		tostring((profile.MagazineOffset or Vector3.zero).X),
		tostring((profile.MagazineOffset or Vector3.zero).Y),
		tostring((profile.MagazineOffset or Vector3.zero).Z),
		tostring(bulletOffset.X),
		tostring(bulletOffset.Y),
		tostring(bulletOffset.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

function __LionApplySniperMultiMeshProfile(root, profile)
	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:GetAttribute("__LionCustomSniperReplacement") then
			descendant:Destroy()
		end
	end

	local bodyParts, magazineParts, bulletParts, removeParts, seenParts = {}, {}, {}, {}, {}
	local function collectIfTarget(obj)
		local part = getMeshLikePart(obj)
		if not part or seenParts[part] then return end
		local previousType = part:GetAttribute("__LionSniperAnchorType")
		if previousType == "Body" or meshMatchesAnyAssetId(obj, profile.BodyMeshIds) then
			seenParts[part] = true
			table.insert(bodyParts, part)
		elseif previousType == "Magazine" or meshMatchesAnyAssetId(obj, profile.MagazineMeshIds) then
			seenParts[part] = true
			table.insert(magazineParts, part)
		elseif previousType == "Bullet" or meshMatchesAnyAssetId(obj, profile.BulletMeshIds) then
			seenParts[part] = true
			table.insert(bulletParts, part)
		elseif previousType == "Remove" or meshMatchesAnyAssetId(obj, profile.RemoveMeshIds) then
			seenParts[part] = true
			table.insert(removeParts, part)
		end
	end

	collectIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		collectIfTarget(obj)
	end

	local bodyAnchor = bodyParts[1] or magazineParts[1]
	local magazineAnchor = magazineParts[1] or bodyAnchor
	if not bodyAnchor then return false end

	local offset = profile.ReplacementOffset or Vector3.zero
	local bodyCFrame = (bodyParts[1] and getReplacementAverageCFrame(bodyParts) or bodyAnchor.CFrame) * CFrame.new(offset)
	local scopeCFrame = bodyCFrame * CFrame.new(profile.ScopeOffset or Vector3.zero)
	local magazineCFrame = bodyCFrame * CFrame.new(profile.MagazineOffset or Vector3.zero)
	local applied = 0
	if __LionCreateSniperReplacementMeshPart(root, bodyAnchor, "__LionCustomSniperReplacement", profile.BodyReplacementMeshId, profile.BodyReplacementTextureId, bodyCFrame, profile) then
		applied += 1
	end
	if __LionCreateSniperReplacementMeshPart(root, bodyAnchor, "__LionCustomSniperScope", profile.ScopeReplacementMeshId, profile.ScopeReplacementTextureId, scopeCFrame, profile) then
		applied += 1
	end
	if __LionCreateSniperReplacementMeshPart(root, magazineAnchor, "__LionCustomSniperMagazine", profile.MagazineReplacementMeshId, profile.MagazineReplacementTextureId, magazineCFrame, profile) then
		applied += 1
	end

	for _, part in ipairs(bodyParts) do
		__LionHideSniperMeshAnchor(part, "Body")
	end
	for _, part in ipairs(magazineParts) do
		__LionHideSniperMeshAnchor(part, "Magazine")
	end
	for _, part in ipairs(bulletParts) do
		__LionOffsetSniperVisibleAnchor(part, "Bullet", profile.BulletOffset or Vector3.zero)
	end
	for _, part in ipairs(removeParts) do
		__LionHideSniperMeshAnchor(part, "Remove")
	end
	return applied > 0
end

local function applySniperMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getSniperMeshSignature(profile)
	if root:GetAttribute("__LionSniperMeshSkin") == profile.Skin
		and root:GetAttribute("__LionSniperMeshSignature") == signature then
		return true
	end

	local applied
	if profile.BodyReplacementMeshId or profile.ScopeReplacementMeshId or profile.MagazineReplacementMeshId then
		applied = __LionApplySniperMultiMeshProfile(root, profile)
		if not applied then return false end
		root:SetAttribute("__LionSniperMeshSkin", profile.Skin)
		root:SetAttribute("__LionSniperMeshSignature", signature)
		return true
	end

	local bodyParts = {}
	for _, meshId in ipairs(profile.BodyMeshIds or {}) do
		for _, part in ipairs(hideSniperMeshId(root, meshId)) do
			table.insert(bodyParts, part)
		end
	end
	for _, meshId in ipairs(profile.RemoveMeshIds or {}) do
		hideSniperMeshId(root, meshId)
	end

	if not setupSniperReplacementPart(root, profile, bodyParts) then
		return false
	end
	root:SetAttribute("__LionSniperMeshSkin", profile.Skin)
	root:SetAttribute("__LionSniperMeshSignature", signature)
	return true
end

local function applyTripminePartVisual(part, profile)
	if not (part and part:IsA("BasePart")) then return end
	local color = profile.Color
	if color then
		part.Color = color
		part.BrickColor = BrickColor.new(color)
	end
	part.Material = profile.Material or Enum.Material.SmoothPlastic
	if profile.Reflectance then
		part.Reflectance = profile.Reflectance
	end
	part.Transparency = 0
	part.LocalTransparencyModifier = 0
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	if part:GetAttribute("WrapGroup") == nil then
		part:SetAttribute("WrapGroup", 1)
	end
	part:SetAttribute("IgnoreTransparency", true)
	pcall(function() part:AddTag("Wrappable") end)
	pcall(function() collectionService:AddTag(part, "Wrappable") end)
end

local function addTripmineExtraMeshPart(basePart, meshId, meshScale, profile, index)
	if not (basePart and basePart:IsA("BasePart") and basePart.Parent) then return nil end
	local overlay = Instance.new("Part")
	overlay.Name = "__LionCustomTripmineMeshExtra" .. tostring(index or "")
	overlay.Anchored = basePart.Anchored
	overlay.CFrame = basePart.CFrame
	overlay.Size = basePart.Size
	overlay:SetAttribute("__LionCustomTripmineMeshPart", true)
	overlay:SetAttribute("__LionCustomTripmineExtraMesh", true)
	applyTripminePartVisual(overlay, profile)

	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.FileMesh
	mesh.MeshId = meshId
	if profile.ClearTexture then
		pcall(function() mesh.TextureId = "" end)
	elseif profile.TextureId then
		pcall(function() mesh.TextureId = profile.TextureId end)
	end
	mesh.Scale = meshScale
	pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
	mesh.Parent = overlay
	overlay.Parent = basePart.Parent

	local weld = Instance.new("WeldConstraint")
	weld.Name = "__LionCustomTripmineMeshExtraWeld"
	weld.Part0 = basePart
	weld.Part1 = overlay
	weld.Parent = overlay
	return overlay
end

local function applyTripmineMeshProfile(root, profile, worldVisual)
	if typeof(root) ~= "Instance" then return false end
	if not profile then return false end
	local meshIds = getTripmineMeshIds(profile)
	if #meshIds == 0 then return false end
	local extraMeshScale = getTripmineExtraMeshScale(profile, worldVisual)
	local meshSignature = getTripmineMeshSignature(profile, worldVisual)
	local meshScale = (worldVisual and profile.WorldScale) or profile.Scale or 1
	if root:GetAttribute("__LionTripmineMeshSkin") == profile.Skin
		and root:GetAttribute("__LionCustomTripmineMeshIds") == meshSignature
		and root:GetAttribute("__LionCustomTripmineMeshScale") == meshScale then
		return true
	end
	removeCustomTripmineExtraMeshes(root)
	removeTripmineMeshAsset(root, profile.RemoveMeshId or profile.HideMeshId)
	local target = findCustomTripmineMeshTarget(root, profile)
	if not target then return false end
	local customPart

	if target:IsA("SpecialMesh") then
		pcall(function() target.MeshType = Enum.MeshType.FileMesh end)
		target.MeshId = meshIds[1]
		if profile.TextureId then
			pcall(function() target.TextureId = profile.TextureId end)
		elseif profile.ClearTexture then
			pcall(function() target.TextureId = "" end)
		end
		target.Scale = target.Scale * meshScale
		pcall(function() target.VertexColor = Vector3.new(1, 1, 1) end)
		customPart = target.Parent
		applyTripminePartVisual(customPart, profile)
		for index = 2, #meshIds do
			addTripmineExtraMeshPart(customPart, meshIds[index], scaleTripmineMeshVector(target.Scale, extraMeshScale), profile, index)
		end
	elseif target:IsA("MeshPart") then
		local originalSize = target.Size
		local okMesh = pcall(function()
			target.MeshId = meshIds[1]
		end)
		if profile.TextureId then
			pcall(function() target.TextureID = profile.TextureId end)
		elseif profile.ClearTexture then
			pcall(function() target.TextureID = "" end)
		end
		applyTripminePartVisual(target, profile)
		if okMesh then
			pcall(function()
				target.Size = originalSize * meshScale
			end)
			customPart = target
			for index = 2, #meshIds do
				addTripmineExtraMeshPart(target, meshIds[index], scaleTripmineMeshVector(Vector3.new(1, 1, 1), extraMeshScale), profile, index)
			end
		elseif target.Parent then
			pcall(function()
				target.Transparency = 1
				target.LocalTransparencyModifier = 1
			end)
			local overlay = target.Parent:FindFirstChild("__LionCustomTripmineMesh")
			if not (overlay and overlay:IsA("BasePart")) then
				overlay = Instance.new("Part")
				overlay.Name = "__LionCustomTripmineMesh"
				overlay.Anchored = target.Anchored
				overlay.CanCollide = false
				overlay.CanTouch = false
				overlay.CanQuery = false
				overlay.Massless = true
				overlay.Parent = target.Parent
			end
			overlay.Size = originalSize
			overlay.CFrame = target.CFrame
			applyTripminePartVisual(overlay, profile)
			local mesh = overlay:FindFirstChildOfClass("SpecialMesh") or Instance.new("SpecialMesh")
			mesh.MeshType = Enum.MeshType.FileMesh
			mesh.MeshId = meshIds[1]
			if profile.TextureId then
				pcall(function() mesh.TextureId = profile.TextureId end)
			elseif profile.ClearTexture then
				pcall(function() mesh.TextureId = "" end)
			end
			mesh.Scale = Vector3.new(meshScale, meshScale, meshScale)
			pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
			mesh.Parent = overlay
			overlay:SetAttribute("__LionCustomTripmineMeshPart", true)
			customPart = overlay
			for index = 2, #meshIds do
				addTripmineExtraMeshPart(overlay, meshIds[index], scaleTripmineMeshVector(meshScale, extraMeshScale), profile, index)
			end
			if not overlay:FindFirstChild("__LionCustomTripmineMeshWeld") then
				local weld = Instance.new("WeldConstraint")
				weld.Name = "__LionCustomTripmineMeshWeld"
				weld.Part0 = target
				weld.Part1 = overlay
				weld.Parent = overlay
			end
		end
	end

	if customPart and customPart:IsA("BasePart") then
		customPart:SetAttribute("__LionCustomTripmineMeshPart", true)
	end
	root:SetAttribute("__LionTripmineMeshSkin", profile.Skin)
	root:SetAttribute("__LionCustomTripmineMeshId", meshIds[1])
	root:SetAttribute("__LionCustomTripmineMeshIds", meshSignature)
	root:SetAttribute("__LionCustomTripmineMeshScale", meshScale)
	return true
end

local function applyVirtualViewModelAssetOverrides(cosmeticName, asset, worldAsset)
	local profile = TRIPMINE_MESH_SKIN_OVERRIDES[cosmeticName]
	if profile then
		applyTripmineMeshProfile(asset, profile)
	end
	local daggerProfile = DAGGERS_MESH_SKIN_OVERRIDES[cosmeticName]
	if daggerProfile then
		applyDaggerMeshProfile(asset, daggerProfile)
	end
	local satchelProfile = getSatchelMeshProfileForAsset(cosmeticName, worldAsset)
	if satchelProfile then
		applySatchelMeshProfile(asset, satchelProfile)
	end
	local rpgProfile = RPG_MESH_SKIN_OVERRIDES[cosmeticName]
	if rpgProfile then
		applyRpgMeshProfile(asset, rpgProfile)
	end
	local fistsProfile = FISTS_MESH_SKIN_OVERRIDES[cosmeticName]
	if fistsProfile then
		applyFistsMeshProfile(asset, fistsProfile)
	end
	local bowProfile = BOW_MESH_SKIN_OVERRIDES[cosmeticName]
	if bowProfile then
		applyBowMeshProfile(asset, bowProfile)
	end
	local assaultRifleProfile = ASSAULT_RIFLE_MESH_SKIN_OVERRIDES[cosmeticName]
	if assaultRifleProfile then
		applyAssaultRifleMeshProfile(asset, assaultRifleProfile)
	end
	local sniperProfile = SNIPER_MESH_SKIN_OVERRIDES[cosmeticName]
	if sniperProfile then
		applySniperMeshProfile(asset, sniperProfile)
	end
end

    local function ensureVirtualViewModel(cosmeticName, itemName, viewModelName)
        local sourceInfo = itmLib.ViewModels and itmLib.ViewModels[viewModelName]
        if not sourceInfo then return nil end

        if cosmeticName ~= viewModelName then
            local usesSourceAnimations = SNIPER_MESH_SKIN_OVERRIDES[cosmeticName]
                or DAGGERS_MESH_SKIN_OVERRIDES[cosmeticName]
                or SATCHEL_MESH_SKIN_OVERRIDES[cosmeticName]
                or RPG_MESH_SKIN_OVERRIDES[cosmeticName]
                or FISTS_MESH_SKIN_OVERRIDES[cosmeticName]
                or BOW_MESH_SKIN_OVERRIDES[cosmeticName]
                or ASSAULT_RIFLE_MESH_SKIN_OVERRIDES[cosmeticName]
                or cosmeticName == KNIFE_CUSTOM_SKIN
                or cosmeticName == "Grenade (Custom Skin)"
                or cosmeticName == "Molotov (Custom Skin)"
                or cosmeticName == "Satchel (Custom Skin)"
                or cosmeticName == "Smoke Grenade (Custom Skin)"
                or cosmeticName == "Warpstone (Custom Skin)"
                or cosmeticName == "sky"

            local animationInfo = usesSourceAnimations and sourceInfo or itmLib.ViewModels[itemName]
            local baseInfo = animationInfo or sourceInfo
            local virtualInfo = table.clone(sourceInfo)
            if type(baseInfo.Animations) == "table" then
                virtualInfo.Animations = table.clone(baseInfo.Animations)
            end
            itmLib.ViewModels[cosmeticName] = virtualInfo

            pcall(function()
                local viewModelAssets = LocalPlayer.PlayerScripts.Assets and LocalPlayer.PlayerScripts.Assets:FindFirstChild("ViewModels")
                if not viewModelAssets then return end
                local existingAsset = findDescendantByName(viewModelAssets, cosmeticName)
                if existingAsset then
                    if shouldRebuildVirtualViewModelAsset(cosmeticName, existingAsset, false) then
                        existingAsset:Destroy()
                    else
                        applyVirtualViewModelAssetOverrides(cosmeticName, existingAsset, false)
                        return
                    end
                end
                local sourceAsset = findDescendantByName(viewModelAssets, viewModelName)
                if sourceAsset then
                    local clonedAsset = sourceAsset:Clone()
                    clonedAsset.Name = cosmeticName
                    applyVirtualViewModelAssetOverrides(cosmeticName, clonedAsset, false)
                    clonedAsset.Parent = viewModelAssets
                end
            end)

            pcall(function()
                local throwables = LocalPlayer.PlayerScripts.Assets and LocalPlayer.PlayerScripts.Assets:FindFirstChild("Throwables")
                if not throwables then return end
                local existingThrowable = throwables:FindFirstChild(cosmeticName)
                if existingThrowable then
                    if shouldRebuildVirtualViewModelAsset(cosmeticName, existingThrowable, true) then
                        existingThrowable:Destroy()
                    else
                        applyVirtualViewModelAssetOverrides(cosmeticName, existingThrowable, true)
                        return
                    end
                end
                local sourceThrowable = findDescendantByName(throwables, viewModelName)
                if sourceThrowable then
                    local clonedThrowable = sourceThrowable:Clone()
                    clonedThrowable.Name = cosmeticName
                    applyVirtualViewModelAssetOverrides(cosmeticName, clonedThrowable, true)
                    clonedThrowable.Parent = throwables
                end
            end)
        end

        return sourceInfo
    end

    local function registerVirtualWeaponSkin(cosmeticName, itemName, viewModelName, rarity, displayName, worldViewModelName)
        local viewModelInfo = ensureVirtualViewModel(cosmeticName, itemName, viewModelName)
        if not viewModelInfo then return end
        local imageInfo = cosmeticName == DICE_TRIPMINE_SKIN and itmLib.ViewModels and itmLib.ViewModels["RNG Dice"] or viewModelInfo
        local image = imageInfo.Image or ""
        local imageHighResolution = imageInfo.ImageHighResolution or imageInfo.Image or ""
        local imageOverride = CUSTOM_SKIN_IMAGE_OVERRIDES[cosmeticName]
        if imageOverride then
            image = imageOverride.Image or ""
            imageHighResolution = imageOverride.ImageHighResolution or imageOverride.Image or ""
        end
        if itmLib.ViewModels and itmLib.ViewModels[cosmeticName] then
            itmLib.ViewModels[cosmeticName].Image = image
            itmLib.ViewModels[cosmeticName].ImageHighResolution = imageHighResolution
        end

        coss[cosmeticName] = {
            Rarity = rarity or "Contraband",
            Type = "Skin",
            DisplayName = displayName or cosmeticName,
            ViewModelName = cosmeticName,
            SourceViewModelName = viewModelName,
            WorldViewModelName = worldViewModelName or viewModelName,
            Image = image,
            ImageHighResolution = imageHighResolution,
            ImageScale = 3,
            ItemName = itemName,
            Owned = true,
            Unlocked = true,
            Locked = false
        }
    end

    local function registerVirtualWeaponSkins()
        coss["Flashbang (Custom Skin)"] = nil
        if itmLib.ViewModels then
            itmLib.ViewModels["Flashbang (Custom Skin)"] = nil
        end
        registerVirtualWeaponSkin(KNIFE_CUSTOM_SKIN,        "Knife",   "Glast Shard", "Contraband")
        registerVirtualWeaponSkin(REAVER_KNIFE_CUSTOM_SKIN, "Knife",   "Pencil",      "Contraband", "reaver")
        registerVirtualWeaponSkin(DAGGERS_CUSTOM_SKIN,      "Daggers", "Keynais",     "Contraband")
        registerVirtualWeaponSkin("Grenade (Custom Skin)",  "Grenade", "Elixir",      "Contraband")
        registerVirtualWeaponSkin("Grenade Raze",           "Grenade", "Glorious Grenade", "Contraband", "Raze")
        registerVirtualWeaponSkin("sky",                    "Flashbang", "Shining Star", "Contraband")
        registerVirtualWeaponSkin("Molotov (Custom Skin)",  "Molotov", "Elixir",      "Contraband", "Elixir")
        registerVirtualWeaponSkin("Satchel (Custom Skin)",  "Satchel", "Elixir",      "Contraband")
        registerVirtualWeaponSkin(SATCHEL_CUSTOM_SKIN,      "Satchel", "Satchel",     "Contraband", "Raze", SATCHEL_CUSTOM_SKIN)
        registerVirtualWeaponSkin("Smoke Grenade (Custom Skin)", "Smoke Grenade", "Elixir", "Contraband")
        registerVirtualWeaponSkin("Warpstone (Custom Skin)", "Warpstone", "Elixir",    "Contraband")
        registerVirtualWeaponSkin("Scythe (Custom Skin)",   "Scythe",  "Scepter",     "Contraband")
        registerVirtualWeaponSkin("Katana (Custom Skin)",   "Katana",  "Scepter",     "Contraband")
        registerVirtualWeaponSkin("Spear (Custom Skin)",    "Spear",   "Scepter",     "Contraband")
        registerVirtualWeaponSkin("Handgun (Custom Skin)",  "Handgun", "Glass Cannon","Contraband")
        registerVirtualWeaponSkin(SNIPER_CUSTOM_SKIN,       "Sniper",  "Keyper",      "Contraband")
        registerVirtualWeaponSkin("Operator",               "Sniper",  "Sniper",      "Contraband")
        registerVirtualWeaponSkin("Medkit (Custom Skin)",   "Medkit",  "RNG Dice",    "Contraband")
        registerVirtualWeaponSkin(RPG_CUSTOM_SKIN,          "RPG",     "Nuke Launcher","Contraband", "Raze", RPG_CUSTOM_SKIN)
        registerVirtualWeaponSkin(FISTS_CUSTOM_SKIN,        "Fists",   "Fists",       "Contraband", "Agent")
        registerVirtualWeaponSkin(BOW_CUSTOM_SKIN,          "Bow",     "Frostbite Bow","Contraband")
        registerVirtualWeaponSkin(ASSAULT_RIFLE_CUSTOM_SKIN,"Assault Rifle", "AK-47","Contraband")
        registerVirtualWeaponSkin("Camera",                 "Jump Pad","Jump Pad",    "Contraband", "Camera", "Camera")
        registerVirtualWeaponSkin(DICE_TRIPMINE_SKIN,       "Subspace Tripmine", "Subspace Tripmine", "Contraband", nil, DICE_TRIPMINE_SKIN)
        registerVirtualWeaponSkin(SPIKE_TRIPMINE_SKIN,      "Subspace Tripmine", "Subspace Tripmine", "Contraband", "Spike", SPIKE_TRIPMINE_SKIN)
    end

    registerVirtualWeaponSkins()

    local UnlockerEq   = getgenv().UnlockerEq
    local UnlockerFavs = getgenv().UnlockerFavs

    local function isBanned(n)
        if type(n) ~= "string" then return true end
        return n:find("MISSING_") or n:find("Bubblegum") or n:find("Ragdoll")
            or n:find("Fall Apart") or n:find("Every Finisher Ever")
    end

    local function toenum(n)
        if not enumLib then return nil end
        local ok, id = pcall(enumLib.ToEnum, enumLib, n)
        return ok and id or nil
    end

    local function clonecos(name, ctype, inv, favonly)
        if isBanned(name) then return nil end
        local base = coss[name]
        if not base then return nil end
        local d = table.clone(base)
        d.Name = name
        d.Type = d.Type or ctype
        d.Seed = d.Seed or math.random(1, 1000000)
        d.Owned = true
        d.Unlocked = true
        d.Locked = false
        d.Amount = math.max(1, tonumber(d.Amount) or 1)
        d.Count = math.max(1, tonumber(d.Count) or 1)
        local eid = toenum(name)
        if eid then d.Enum = eid d.ObjectID = d.ObjectID or eid end
        if inv ~= nil then d.Inverted = inv end
        if favonly ~= nil then d.OnlyUseFavorites = favonly end
        return d
    end

    local guiState = {
        Wanted = false,
        Gui = nil,
        WeaponSearch = "",
        CosmeticSearch = "",
        Mode = "Skin",
        SelectedWeapon = nil,
        SelectedCosmetic = nil,
        Weapons = {},
        Cosmetics = {},
        Columns = 6,
        TileW = 130,
        TileH = 124
    }

    local function displayName(name, data)
        return tostring((data and (data.DisplayName or data.Name)) or name or "")
    end

    local function iconFrom(data, fallback, name)
        if not data then return fallback or "" end
        local cosmeticImage = name and consts and consts.COSMETIC_IMAGES and consts.COSMETIC_IMAGES[name]
        local typeInfo = data.Type and cosLib.Types and cosLib.Types[data.Type]
        return cosmeticImage
            or data.ImageHighResolution
            or data.Image
            or data.Icon
            or data.Texture
            or fallback
            or (typeInfo and typeInfo.Image)
            or ""
    end

    local function sortByName(list)
        table.sort(list, function(a, b)
            return tostring(a.Name):lower() < tostring(b.Name):lower()
        end)
        return list
    end

    local function cosmeticMatchesWeapon(data, weapon)
        if not data then return false end
        local itemName = data.ItemName or data.WeaponName or data.Weapon or data.Item
        if itemName then
            return tostring(itemName):lower() == tostring(weapon or ""):lower()
        end
        return data.Type ~= "Skin"
    end

    local function rebuildLists()
        table.clear(guiState.Weapons)
        table.clear(guiState.Cosmetics)

        for name, data in pairs(coss) do
            if not isBanned(name) and data.Type == "Weapon" then
                local dispName = displayName(name, data)
                local dispImg = iconFrom(data, itmLib.Items and itmLib.Items[name] and itmLib.Items[name].Image, name)
                if UnlockerEq[name] and UnlockerEq[name].Skin then
                    local skinData = UnlockerEq[name].Skin
                    dispName = displayName(skinData.Name, skinData)
                    dispImg = iconFrom(skinData, nil, skinData.Name)
                end
                table.insert(guiState.Weapons, {
                    Name = name, Display = dispName, Image = dispImg, Data = data
                })
            end
        end

        if #guiState.Weapons == 0 and itmLib.ItemsAlphabetized then
            for _, name in ipairs(itmLib.ItemsAlphabetized) do
                local data = itmLib.Items and itmLib.Items[name]
                if data and not isBanned(name) then
                    local dispName = displayName(name, data)
                    local dispImg = iconFrom(data, nil, name)
                    if UnlockerEq[name] and UnlockerEq[name].Skin then
                        local skinData = UnlockerEq[name].Skin
                        dispName = displayName(skinData.Name, skinData)
                        dispImg = iconFrom(skinData, nil, skinData.Name)
                    end
                    table.insert(guiState.Weapons, {
                        Name = name, Display = dispName, Image = dispImg, Data = data
                    })
                end
            end
        end

        sortByName(guiState.Weapons)
        if not guiState.SelectedWeapon and guiState.Weapons[1] then
            guiState.SelectedWeapon = guiState.Weapons[1].Name
        end

        local mode = guiState.Mode
        for name, data in pairs(coss) do
            if not isBanned(name) and data.Type == mode and cosmeticMatchesWeapon(data, guiState.SelectedWeapon) then
                table.insert(guiState.Cosmetics, {
                    Name = name, Display = displayName(name, data),
                    Image = iconFrom(data, nil, name), Data = data
                })
            end
        end
        sortByName(guiState.Cosmetics)
    end

    local function makeDraggable(obj)
        local dragging, dragInput, dragStart, startPos
        obj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = obj.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        obj.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                         startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

        local function applyCosmeticToWeapon(weapon, cosmeticName, ctype, skipRebuild)
    if not weapon or weapon == "" then return end
    ctype = ctype or guiState.Mode
    UnlockerEq[weapon] = UnlockerEq[weapon] or {}

    if not cosmeticName or cosmeticName == "" or cosmeticName == "None" then
        UnlockerEq[weapon][ctype] = nil
    else
        if cosmeticName == "__random" then
            local pool = guiState.Cosmetics
            local pick = pool[math.random(1, math.max(1, #pool))]
            cosmeticName = pick and pick.Name or nil
        end
        local cloned = cosmeticName and clonecos(cosmeticName, ctype)
        if cloned then UnlockerEq[weapon][ctype] = cloned end
    end

    if UnlockerEq[weapon] and not next(UnlockerEq[weapon]) then
        UnlockerEq[weapon] = nil
    end

    if getgenv().ForceCosmeticUpdate then
        pcall(getgenv().ForceCosmeticUpdate, weapon, ctype)
    end

    if not skipRebuild then
        pcall(function()
            if datCtrl.CurrentData then
                datCtrl.CurrentData:Replicate("WeaponInventory")
                datCtrl.CurrentData:Replicate("CosmeticInventory")
            end
        end)
    end

    if getgenv().SaveUnlockerConfig then
        pcall(getgenv().SaveUnlockerConfig)
    end
end

    local function makeCosmeticChanger()
        if guiState.Gui then return guiState.Gui end
        rebuildLists()

        local gui = Instance.new("Frame")
        gui.Name = "AlacrityCosmeticChanger"
        gui.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        gui.BorderColor3 = Color3.fromRGB(45, 45, 45)
        gui.BorderSizePixel = 1
        gui.Position = UDim2.new(0.5, -410, 0.5, -420)
        gui.Size = UDim2.fromOffset(820, 840)
        gui.Visible = false
        gui.ZIndex = 900
        gui.Parent = Library.ScreenGui or (LocalPlayer:WaitForChild("PlayerGui"))
        guiState.Gui = gui

        makeDraggable(gui)

        local title = Instance.new("TextLabel")
        title.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        title.BorderSizePixel = 0
        title.Font = Enum.Font.Code
        title.Text = "Cosmetic Changer"
        title.TextColor3 = Color3.fromRGB(235, 235, 235)
        title.TextSize = 16
        title.Size = UDim2.new(1, 0, 0, 32)
        title.ZIndex = 901
        title.Parent = gui

        local body = Instance.new("Frame")
        body.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        body.BorderColor3 = Color3.fromRGB(38, 38, 38)
        body.Position = UDim2.fromOffset(12, 42)
        body.Size = UDim2.new(1, -24, 1, -54)
        body.ZIndex = 901
        body.Parent = gui

        local function mkText(parent, text, pos, size, fontSize)
            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Code
            label.Text = text
            label.TextColor3 = Color3.fromRGB(235, 235, 235)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextSize = fontSize or 14
            label.Position = pos
            label.Size = size
            label.ZIndex = 902
            label.Parent = parent
            return label
        end

        local function mkBox(parent, placeholder, pos, size)
            local box = Instance.new("TextBox")
            box.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
            box.BorderColor3 = Color3.fromRGB(42, 42, 42)
            box.ClearTextOnFocus = false
            box.Font = Enum.Font.Code
            box.PlaceholderText = placeholder
            box.PlaceholderColor3 = Color3.fromRGB(155, 155, 155)
            box.Text = ""
            box.TextColor3 = Color3.fromRGB(220, 220, 220)
            box.TextSize = 14
            box.TextXAlignment = Enum.TextXAlignment.Left
            box.Position = pos
            box.Size = size
            box.ZIndex = 902
            box.Parent = parent
            return box
        end

        local function mkButton(parent, text, pos, size)
            local btn = Instance.new("TextButton")
            btn.AutoButtonColor = false
            btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            btn.BorderColor3 = Color3.fromRGB(45, 45, 45)
            btn.Font = Enum.Font.Code
            btn.Text = text
            btn.TextColor3 = Color3.fromRGB(235, 235, 235)
            btn.TextSize = 14
            btn.Position = pos
            btn.Size = size
            btn.ZIndex = 902
            btn.Parent = parent
            return btn
        end

        local weaponGrid = Instance.new("ScrollingFrame")
        weaponGrid.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
        weaponGrid.BorderColor3 = Color3.fromRGB(35, 35, 35)
        weaponGrid.CanvasSize = UDim2.new()
        weaponGrid.ScrollBarThickness = 6
        weaponGrid.Position = UDim2.fromOffset(10, 54)
        weaponGrid.Size = UDim2.new(1, -20, 0, 264)
        weaponGrid.ZIndex = 902
        weaponGrid.Parent = body

        local cosmeticGrid = Instance.new("ScrollingFrame")
        cosmeticGrid.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
        cosmeticGrid.BorderColor3 = Color3.fromRGB(35, 35, 35)
        cosmeticGrid.CanvasSize = UDim2.new()
        cosmeticGrid.ScrollBarThickness = 6
        cosmeticGrid.Position = UDim2.fromOffset(10, 374)
        cosmeticGrid.Size = UDim2.new(1, -20, 0, 276)
        cosmeticGrid.ZIndex = 902
        cosmeticGrid.Parent = body

        mkText(body, "weapon filter", UDim2.fromOffset(10, 6), UDim2.new(1, -20, 0, 18))
        local weaponSearch = mkBox(body, "grenade launcher...", UDim2.fromOffset(10, 28), UDim2.new(1, -20, 0, 24))
        mkText(body, "cosmetic filter", UDim2.fromOffset(10, 326), UDim2.new(1, -20, 0, 18))
        local cosmeticSearch = mkBox(body, "red...", UDim2.fromOffset(10, 348), UDim2.new(1, -20, 0, 24))

local modeRow = Instance.new("Frame")
modeRow.BackgroundTransparency = 1
modeRow.Position = UDim2.fromOffset(10, 658)
modeRow.Size = UDim2.new(1, -20, 0, 26)
modeRow.ZIndex = 903
modeRow.Parent = body

local modes = {"Skin", "Wrap", "Charm", "Finisher"}
local modeButtons = {}

local function setMode(mode)
    guiState.Mode = mode

    if guiState.SelectedWeapon then
        local currentEquip = UnlockerEq[guiState.SelectedWeapon]
        guiState.SelectedCosmetic = (currentEquip and currentEquip[mode])
            and currentEquip[mode].Name or nil
    else
        guiState.SelectedCosmetic = nil
    end

    for m, btn in pairs(modeButtons) do
        if m == mode then
            btn.BackgroundColor3 = Color3.fromRGB(28, 44, 35)
            btn.BorderColor3 = Color3.fromRGB(70, 140, 95)
            btn.TextColor3 = Color3.fromRGB(235, 255, 235)
        else
            btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            btn.BorderColor3 = Color3.fromRGB(45, 45, 45)
            btn.TextColor3 = Color3.fromRGB(235, 235, 235)
        end
    end

    rebuildLists()
    if guiState.Refresh then guiState.Refresh() end
end

local btnWidth = 1 / #modes
for i, mode in ipairs(modes) do
    local btn = mkButton(modeRow, mode:lower(),
                         UDim2.fromScale((i - 1) * btnWidth, 0),
                         UDim2.fromScale(btnWidth, 1))
    btn.ZIndex = 904
    btn.TextXAlignment = Enum.TextXAlignment.Center
    modeButtons[mode] = btn
    btn.MouseButton1Click:Connect(function()
        setMode(mode)
    end)
end
        local reset    = mkButton(body, "reset to defaults", UDim2.fromOffset(10, 690), UDim2.new(0.5, -12, 0, 26))
        mkText(body, "click a weapon to toggle the skin changer for it.",
               UDim2.fromOffset(10, 750), UDim2.new(1, -20, 0, 18), 12).TextColor3 = Color3.fromRGB(125, 125, 125)

        local function passes(entry, query)
            query = tostring(query or ""):lower()
            return query == "" or entry.Name:lower():find(query, 1, true) or entry.Display:lower():find(query, 1, true)
        end

        local function clearChildren(frame)
            for _, child in ipairs(frame:GetChildren()) do
                if child:IsA("GuiObject") then child:Destroy() end
            end
        end

        local function makeTile(parent, entry, index, selected, callback, rightCallback, largeWeaponPreview)
            local col = (index - 1) % guiState.Columns
            local row = math.floor((index - 1) / guiState.Columns)
            local tile = Instance.new("TextButton")
            tile.AutoButtonColor = false
            tile.BackgroundColor3 = selected and Color3.fromRGB(28, 44, 35) or Color3.fromRGB(20, 20, 20)
            tile.BorderColor3 = selected and Color3.fromRGB(70, 140, 95) or Color3.fromRGB(28, 28, 28)
            tile.Position = UDim2.fromOffset(col * guiState.TileW, row * guiState.TileH)
            tile.Size = UDim2.fromOffset(guiState.TileW, guiState.TileH)
            tile.ClipsDescendants = true
            tile.Text = ""
            tile.ZIndex = 903
            tile.Parent = parent

            local img = Instance.new("ImageLabel")
            img.BackgroundTransparency = 1
            img.Image = entry.Image or ""
            img.ScaleType = Enum.ScaleType.Fit
            img.Position = largeWeaponPreview and UDim2.fromOffset(-61, -43) or UDim2.fromOffset(14, 9)
            img.Size = largeWeaponPreview and UDim2.fromOffset(252, 176) or UDim2.fromOffset(102, 76)
            img.ZIndex = 904
            img.Parent = tile

            local name = Instance.new("TextLabel")
            name.BackgroundTransparency = 1
            name.Font = Enum.Font.SourceSansBold
            name.Text = entry.Display
            name.TextColor3 = Color3.fromRGB(245, 245, 245)
            name.TextScaled = true
            name.TextWrapped = true
            name.Position = UDim2.fromOffset(6, 86)
            name.Size = UDim2.fromOffset(118, 32)
            name.ZIndex = 904
            name.Parent = tile

            tile.MouseButton1Click:Connect(function() callback(entry) end)
            tile.MouseButton2Click:Connect(function() if rightCallback then rightCallback(entry) end end)
        end
local refreshQueued = false
        local function refresh()
        if refreshQueued then return end
    refreshQueued = true
    task.defer(function()
        refreshQueued = false
            clearChildren(weaponGrid)
            clearChildren(cosmeticGrid)

            local wcount = 0
            for _, entry in ipairs(guiState.Weapons) do
                if passes(entry, guiState.WeaponSearch) then
                    wcount += 1
                    makeTile(weaponGrid, entry, wcount, guiState.SelectedWeapon == entry.Name, function(chosen)
                        guiState.SelectedWeapon = chosen.Name
                        local currentEquip = UnlockerEq[chosen.Name]
                        if currentEquip and currentEquip[guiState.Mode] then
                            guiState.SelectedCosmetic = currentEquip[guiState.Mode].Name
                        else
                            guiState.SelectedCosmetic = nil
                        end
                        rebuildLists()
                        refresh()
                    end, function(chosen)
                        guiState.SelectedWeapon = chosen.Name
                        applyCosmeticToWeapon(chosen.Name, guiState.SelectedCosmetic, guiState.Mode)
                        rebuildLists()
                        refresh()
                    end, true)
                end
            end
            weaponGrid.CanvasSize = UDim2.fromOffset(0, math.max(264, math.ceil(wcount / guiState.Columns) * guiState.TileH))

            local randomEntry = {Name = "__random", Display = "Random", Image = "rbxassetid://132973552546079"}
            makeTile(cosmeticGrid, randomEntry, 1, guiState.SelectedCosmetic == "__random", function()
                guiState.SelectedCosmetic = "__random"
                if guiState.SelectedWeapon then applyCosmeticToWeapon(guiState.SelectedWeapon, "__random", guiState.Mode) end
                rebuildLists()
                refresh()
            end)

            local ccount = 1
            for _, entry in ipairs(guiState.Cosmetics) do
                if passes(entry, guiState.CosmeticSearch) then
                    ccount += 1
                    makeTile(cosmeticGrid, entry, ccount, guiState.SelectedCosmetic == entry.Name, function(chosen)
                        guiState.SelectedCosmetic = chosen.Name
                        if guiState.SelectedWeapon then
                            applyCosmeticToWeapon(guiState.SelectedWeapon, chosen.Name, guiState.Mode)
                        end
                        rebuildLists()
                        refresh()
                    end, nil, guiState.Mode == "Skin")
                end
            end
            cosmeticGrid.CanvasSize = UDim2.fromOffset(0, math.max(276, math.ceil(ccount / guiState.Columns) * guiState.TileH))
        end)
        end

        guiState.Refresh = refresh

        weaponSearch:GetPropertyChangedSignal("Text"):Connect(function()
    guiState.WeaponSearch = weaponSearch.Text
    refresh()
end)
cosmeticSearch:GetPropertyChangedSignal("Text"):Connect(function()
    guiState.CosmeticSearch = cosmeticSearch.Text
    refresh()
end)
        
        reset.MouseButton1Click:Connect(function()
            table.clear(UnlockerEq)
            table.clear(UnlockerFavs)
            rebuildLists()
            refresh()
        end)

        refresh()
        return gui
    end

    shared.AlacrityCosmeticChanger = {
        SetVisible = function(visible)
            guiState.Wanted = visible == true
            if not guiState.Gui then
                makeCosmeticChanger()
            end
            if guiState.Wanted then
                rebuildLists()
                if guiState.Refresh then guiState.Refresh() end
            end
        end,

        Toggle = function()
            guiState.Wanted = not guiState.Wanted
            if not guiState.Gui then
                makeCosmeticChanger()
            end
            rebuildLists()
            if guiState.Refresh then guiState.Refresh() end
        end,

        IsOpen = function()
            return guiState.Gui and guiState.Gui.Visible == true
        end,

        Refresh = function()
            rebuildLists()
            if guiState.Refresh then guiState.Refresh() end
        end,

        GetEquipData = function()
            local export = {}
            for w, cats in pairs(UnlockerEq) do
                export[w] = {}
                for cat, data in pairs(cats) do
                    export[w][cat] = data and data.Name or nil
                end
            end
            return export
        end,

        LoadEquipData = function(data)
            if type(data) ~= "table" then return end
            for w, cats in pairs(data) do
                if type(cats) == "table" then
                    for cat, name in pairs(cats) do
                        applyCosmeticToWeapon(w, name, cat, true)
                    end
                end
            end
            pcall(function()
                if datCtrl.CurrentData then
                    datCtrl.CurrentData:Replicate("CosmeticInventory")
                    datCtrl.CurrentData:Replicate("WeaponInventory")
                end
            end)
            rebuildLists()
            if guiState.Refresh then guiState.Refresh() end
        end,

        Apply = applyCosmeticToWeapon,
        State = guiState
    }
    getgenv().AlacrityCosmeticChanger = shared.AlacrityCosmeticChanger

    local function isLinoriaOpen()
        if typeof(Library) ~= "table" then return false end
        if rawget(Library, "Toggled") == true then return true end
        local holder = Library.Window and Library.Window.Holder
        if holder and typeof(holder) == "Instance" then
            return holder.Visible == true
        end
        if guiState.ContainerGui then
            return true
        end
        return false
    end

    local nextSyncCheck = 0
    RunService.Heartbeat:Connect(function()
        local now = os.clock()
        if now < nextSyncCheck then return end
        nextSyncCheck = now + 0.05

        if not guiState.Gui then return end
        local shouldShow = guiState.Wanted == true and isLinoriaOpen() == true

        if guiState.Gui.Visible ~= shouldShow then
            guiState.Gui.Visible = shouldShow
        end
    end)
end)
end

-- shaders
getgenv().Player = LocalPlayer
Player = getgenv().Player
Camera = getCamera()

getgenv().Effects = getgenv().Effects or {
    DOF = false,
    Bloom = false,
    ColorCorrection = false,
    Atmosphere = false,
    SunRays = false,
    DynamicExposure = false,
    SpecularBoost = false,
}
local Effects = getgenv().Effects

function remove(name)
    local obj = Lighting:FindFirstChild(name)
    if obj then obj:Destroy() end
end

remove("ProDOF")
remove("ProBloom")
remove("ProColor")
remove("ProAtmos")
remove("ProSun")

DOF = Instance.new("DepthOfFieldEffect")
DOF.Name = "ProDOF"
DOF.Enabled = Effects.DOF
DOF.InFocusRadius = 3
DOF.NearIntensity = 1
DOF.FarIntensity = 1
DOF.FocusDistance = 15
DOF.Parent = Lighting

Bloom = Instance.new("BloomEffect")
Bloom.Name = "ProBloom"
Bloom.Enabled = Effects.Bloom
Bloom.Intensity = 0.35
Bloom.Size = 32
Bloom.Threshold = 1
Bloom.Parent = Lighting

Color = Instance.new("ColorCorrectionEffect")
Color.Name = "ProColor"
Color.Enabled = Effects.ColorCorrection
Color.Brightness = 0
Color.Contrast = 0.2
Color.Saturation = 0.1
Color.Parent = Lighting

Atmos = Instance.new("Atmosphere")
Atmos.Name = "ProAtmos"
Atmos.Density = 0.35
Atmos.Offset = 0.1
Atmos.Color = Color3.fromRGB(200,220,255)
Atmos.Decay = Color3.fromRGB(120,120,140)
Atmos.Glare = 0.3
Atmos.Haze = 1
Atmos.Parent = Lighting

Atmos.Parent = Effects.Atmosphere and Lighting or nil

Sun = Instance.new("SunRaysEffect")
Sun.Name = "ProSun"
Sun.Enabled = Effects.SunRays
Sun.Intensity = 0.2
Sun.Spread = 0.6
Sun.Parent = Lighting

function applySpecular(state)
    if state then
        Lighting.EnvironmentSpecularScale = 1
        Lighting.EnvironmentDiffuseScale = 0.4
        Lighting.GlobalShadows = true
    else
        Lighting.EnvironmentSpecularScale = 0
        Lighting.EnvironmentDiffuseScale = 1
    end
end

applySpecular(Effects.SpecularBoost)

targetExposure = 0
currentExposure = 0
exposureSpeed = 2

focus = 15
targetFocus = 15

function getBrightness()
    local sunDir = Lighting:GetSunDirection()
    return Camera.CFrame.LookVector:Dot(sunDir)
end

function isFirstPerson()
    local char = Player.Character
    if not char then return false end
    local head = char:FindFirstChild("Head")
    if not head then return false end
    return (Camera.CFrame.Position - head.Position).Magnitude < 1
end

local _shaderLast = {
    DOF = nil, Bloom = nil, Color = nil, Sun = nil, Atmos = nil, Spec = nil
}
local _shaderAccum = 0

RunService.RenderStepped:Connect(function(dt)
    if _shaderLast.DOF ~= Effects.DOF then
        DOF.Enabled = Effects.DOF; _shaderLast.DOF = Effects.DOF
    end
    if _shaderLast.Bloom ~= Effects.Bloom then
        Bloom.Enabled = Effects.Bloom; _shaderLast.Bloom = Effects.Bloom
    end
    if _shaderLast.Color ~= Effects.ColorCorrection then
        Color.Enabled = Effects.ColorCorrection; _shaderLast.Color = Effects.ColorCorrection
    end
    if _shaderLast.Sun ~= Effects.SunRays then
        Sun.Enabled = Effects.SunRays; _shaderLast.Sun = Effects.SunRays
    end

    if _shaderLast.Atmos ~= Effects.Atmosphere then
        Atmos.Parent = Effects.Atmosphere and Lighting or nil
        _shaderLast.Atmos = Effects.Atmosphere
    end

    if _shaderLast.Spec ~= Effects.SpecularBoost then
        applySpecular(Effects.SpecularBoost)
        _shaderLast.Spec = Effects.SpecularBoost
    end

    if Effects.DynamicExposure and Effects.ColorCorrection then
        local brightness = getBrightness()
        targetExposure = math.clamp(brightness * 0.5, -0.1, 0.2)
        currentExposure = currentExposure + (targetExposure - currentExposure) * dt * exposureSpeed
        Color.Brightness = currentExposure
    end

    if Effects.DOF and Player.Character then
        local head = Player.Character:FindFirstChild("Head")
        if head then
            local dist = (head.Position - Camera.CFrame.Position).Magnitude
            if isFirstPerson() then
                DOF.InFocusRadius = 8
                DOF.NearIntensity = 0.2
                DOF.FarIntensity = 0.4
                targetFocus = 50
            else
                DOF.InFocusRadius = 3
                DOF.NearIntensity = 1
                DOF.FarIntensity = 1
                targetFocus = dist
            end
        end
        focus = focus + (targetFocus - focus) * math.clamp(dt * 8, 0, 1)
        DOF.FocusDistance = focus
    end

    if Effects.Bloom then
        _shaderAccum += dt
        if _shaderAccum >= 1/30 then
            _shaderAccum = 0
            local look = Camera.CFrame.LookVector.Y
            Bloom.Intensity = 0.3 + math.abs(look) * 0.2
        end
    end
end)

getgenv().ProLighting = Effects

getgenv().Skybox = getgenv().Skybox or {
    Enabled = false,
    Type = "Afternoon",
}

getgenv().OriginalLighting = getgenv().OriginalLighting or {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    FogColor = Lighting.FogColor,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
}
local OriginalLighting = getgenv().OriginalLighting

getgenv().Skyboxes = getgenv().Skyboxes or {
    ["Afternoon"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://162001926",
        SkyboxDn = "rbxassetid://161998893",
        SkyboxFt = "rbxassetid://162001897",
        SkyboxBk = "rbxassetid://162001887",
        SkyboxLf = "rbxassetid://162001904",
        SkyboxRt = "rbxassetid://162001919",
    },
    ["Blue Space"] = {
        StarCount = 0, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://367149078",
        SkyboxDn = "rbxassetid://367147970",
        SkyboxFt = "rbxassetid://366731193",
        SkyboxBk = "rbxassetid://366731024",
        SkyboxLf = "rbxassetid://366731613",
        SkyboxRt = "rbxassetid://366731514",
    },
    ["Classic Roblox"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://11138465883",
        SkyboxDn = "rbxassetid://11138453351",
        SkyboxFt = "rbxassetid://11138458027",
        SkyboxBk = "rbxassetid://11138450201",
        SkyboxLf = "rbxassetid://11138460736",
        SkyboxRt = "rbxassetid://11138463127",
        SunTextureId = "rbxassetid://11138537872",
    },
    ["Cloudy"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://246480504",
        SkyboxDn = "rbxassetid://246480523",
        SkyboxFt = "rbxassetid://246480105",
        SkyboxBk = "rbxassetid://246480323",
        SkyboxLf = "rbxassetid://246480549",
        SkyboxRt = "rbxassetid://246480565",
    },
    ["Dusk"] = {
        StarCount = 3000, SunAngularSize = 0, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://9778106496",
        SkyboxDn = "rbxassetid://9778110864",
        SkyboxFt = "rbxassetid://9778101192",
        SkyboxBk = "rbxassetid://9778108979",
        SkyboxLf = "rbxassetid://9778103329",
        SkyboxRt = "rbxassetid://9778104889",
    },
    ["Dawn"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://323478865",
        SkyboxDn = "rbxassetid://323481190",
        SkyboxFt = "rbxassetid://323480314",
        SkyboxBk = "rbxassetid://323479840",
        SkyboxLf = "rbxassetid://323480786",
        SkyboxRt = "rbxassetid://323480131",
    },
    ["Dark Skies"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://149397702",
        SkyboxDn = "rbxassetid://149397686",
        SkyboxFt = "rbxassetid://149397697",
        SkyboxBk = "rbxassetid://149397692",
        SkyboxLf = "rbxassetid://149397684",
        SkyboxRt = "rbxassetid://149397688",
    },
    ["Earth"] = {
        StarCount = 3000, SunAngularSize = 0, MoonAngularSize = 0,
        SkyboxUp = "rbxassetid://15753304473",
        SkyboxDn = "rbxassetid://15753362674",
        SkyboxFt = "rbxassetid://15753305823",
        SkyboxBk = "rbxassetid://15753305495",
        SkyboxLf = "rbxassetid://15753310707",
        SkyboxRt = "rbxassetid://15753304774",
    },
    ["Ethereal"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://16823395515",
        SkyboxDn = "rbxassetid://16823388586",
        SkyboxFt = "rbxassetid://16823390254",
        SkyboxBk = "rbxassetid://16823386986",
        SkyboxLf = "rbxassetid://16823392344",
        SkyboxRt = "rbxassetid://16823394120",
    },
    ["Galaxy"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://2049518578",
        SkyboxDn = "rbxassetid://2049519279",
        SkyboxFt = "rbxassetid://2049519882",
        SkyboxBk = "rbxassetid://2049520382",
        SkyboxLf = "rbxassetid://2049522478",
        SkyboxRt = "rbxassetid://2049521207",
    },
    ["Heaven"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://7951703855",
        SkyboxDn = "rbxassetid://7951706908",
        SkyboxFt = "rbxassetid://7951694757",
        SkyboxBk = "rbxassetid://7951826533",
        SkyboxLf = "rbxassetid://7951697216",
        SkyboxRt = "rbxassetid://7951700251",
    },
    ["Horizontal Milky Way"] = {
        StarCount = 0, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://714276621",
        SkyboxDn = "rbxassetid://714276541",
        SkyboxFt = "rbxassetid://714276657",
        SkyboxBk = "rbxassetid://714276643",
        SkyboxLf = "rbxassetid://714276648",
        SkyboxRt = "rbxassetid://714276638",
    },
    ["Jungle"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://525546479",
        SkyboxDn = "rbxassetid://525544628",
        SkyboxFt = "rbxassetid://525548536",
        SkyboxBk = "rbxassetid://525546178",
        SkyboxLf = "rbxassetid://525550171",
        SkyboxRt = "rbxassetid://525545319",
    },
    ["Mountains"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://48015387",
        SkyboxDn = "rbxassetid://48015300",
        SkyboxFt = "rbxassetid://368388290",
        SkyboxBk = "rbxassetid://368385273",
        SkyboxLf = "rbxassetid://368390615",
        SkyboxRt = "rbxassetid://368385190",
    },
    ["Nebula"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://171448889",
        SkyboxDn = "rbxassetid://171448902",
        SkyboxFt = "rbxassetid://171448848",
        SkyboxBk = "rbxassetid://171448875",
        SkyboxLf = "rbxassetid://171448933",
        SkyboxRt = "rbxassetid://171448925",
    },
    ["Night"] = {
        StarCount = 0, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://12064131",
        SkyboxDn = "rbxassetid://12064152",
        SkyboxFt = "rbxassetid://12064121",
        SkyboxBk = "rbxassetid://12064107",
        SkyboxLf = "rbxassetid://12063984",
        SkyboxRt = "rbxassetid://12064115",
    },
    ["Night Light"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://171447068",
        SkyboxDn = "rbxassetid://171447094",
        SkyboxFt = "rbxassetid://171447041",
        SkyboxBk = "rbxassetid://171447054",
        SkyboxLf = "rbxassetid://171447128",
        SkyboxRt = "rbxassetid://171447111",
    },
    ["Ocean Sky"] = {
        StarCount = 3000, SunAngularSize = 1, MoonAngularSize = 0,
        SkyboxUp = "rbxassetid://11854708161",
        SkyboxDn = "rbxassetid://11854687121",
        SkyboxFt = "rbxassetid://11854693863",
        SkyboxBk = "rbxassetid://11854686548",
        SkyboxLf = "rbxassetid://11854696162",
        SkyboxRt = "rbxassetid://11854698541",
        SunTextureId = "rbxassetid://4774583925",
        MoonTextureId = "rbxassetid://4774580371",
    },
    ["Pink Clouds"] = {
        StarCount = 1334, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://271077958",
        SkyboxDn = "rbxassetid://271077243",
        SkyboxFt = "rbxassetid://271042556",
        SkyboxBk = "rbxassetid://271042516",
        SkyboxLf = "rbxassetid://271042310",
        SkyboxRt = "rbxassetid://271042467",
    },
    ["Red Dusk"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://136208328681929",
        SkyboxDn = "rbxassetid://123407860042117",
        SkyboxFt = "rbxassetid://132624761762466",
        SkyboxBk = "rbxassetid://85146619291315",
        SkyboxLf = "rbxassetid://102069641249982",
        SkyboxRt = "rbxassetid://136526747107728",
    },
    ["Redshift"] = {
        StarCount = 0, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://401664936",
        SkyboxDn = "rbxassetid://401664862",
        SkyboxFt = "rbxassetid://401664960",
        SkyboxBk = "rbxassetid://401664839",
        SkyboxLf = "rbxassetid://401664881",
        SkyboxRt = "rbxassetid://401664901",
    },
    ["Saturn"] = {
        StarCount = 3000, SunAngularSize = 10, MoonAngularSize = 0,
        SkyboxUp = "rbxassetid://1898736761",
        SkyboxDn = "rbxassetid://1898727189",
        SkyboxFt = "rbxassetid://1898722814",
        SkyboxBk = "rbxassetid://1898724755",
        SkyboxLf = "rbxassetid://1898729298",
        SkyboxRt = "rbxassetid://1898741025",
        MoonTextureId = "rbxassetid://0",
    },
    ["SFOTH"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://1014449",
        SkyboxDn = "rbxassetid://1012891",
        SkyboxFt = "rbxassetid://1012887",
        SkyboxBk = "rbxassetid://1012890",
        SkyboxLf = "rbxassetid://1012889",
        SkyboxRt = "rbxassetid://1012888",
    },
    ["Smoke"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://171410742",
        SkyboxDn = "rbxassetid://171410748",
        SkyboxFt = "rbxassetid://171410730",
        SkyboxBk = "rbxassetid://171410736",
        SkyboxLf = "rbxassetid://171410766",
        SkyboxRt = "rbxassetid://171410755",
    },
    ["Solid Black"] = {
        StarCount = 0, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://2013298",
        SkyboxDn = "rbxassetid://2013298",
        SkyboxFt = "rbxassetid://2013298",
        SkyboxBk = "rbxassetid://2013298",
        SkyboxLf = "rbxassetid://2013298",
        SkyboxRt = "rbxassetid://2013298",
    },
    ["Space"] = {
        StarCount = 0, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://155441905",
        SkyboxDn = "rbxassetid://155441905",
        SkyboxFt = "rbxassetid://155441905",
        SkyboxBk = "rbxassetid://155441905",
        SkyboxLf = "rbxassetid://155441905",
        SkyboxRt = "rbxassetid://155441905",
    },
    ["Storm"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://171410789",
        SkyboxDn = "rbxassetid://171410792",
        SkyboxFt = "rbxassetid://171410775",
        SkyboxBk = "rbxassetid://171410784",
        SkyboxLf = "rbxassetid://171410807",
        SkyboxRt = "rbxassetid://171410798",
    },
    ["Sunset"] = {
        StarCount = 5000, SunAngularSize = 18, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://264907379",
        SkyboxDn = "rbxassetid://264907909",
        SkyboxFt = "rbxassetid://264909420",
        SkyboxBk = "rbxassetid://264908339",
        SkyboxLf = "rbxassetid://264909758",
        SkyboxRt = "rbxassetid://264908886",
    },
    ["Underworld"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://171561009",
        SkyboxDn = "rbxassetid://171561019",
        SkyboxFt = "rbxassetid://171560968",
        SkyboxBk = "rbxassetid://171560994",
        SkyboxLf = "rbxassetid://171561065",
        SkyboxRt = "rbxassetid://171561026",
    },
    ["Vertical Milky Way"] = {
        StarCount = 3000, SunAngularSize = 1.440000057220459, MoonAngularSize = 0.5699999928474426,
        SkyboxUp = "rbxassetid://5559302033",
        SkyboxDn = "rbxassetid://5559290893",
        SkyboxFt = "rbxassetid://5559300879",
        SkyboxBk = "rbxassetid://5559289158",
        SkyboxLf = "rbxassetid://5559292825",
        SkyboxRt = "rbxassetid://5559302989",
    },
    ["White"] = {
        StarCount = 0, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://321136141",
        SkyboxDn = "rbxassetid://321136141",
        SkyboxFt = "rbxassetid://321136141",
        SkyboxBk = "rbxassetid://321136141",
        SkyboxLf = "rbxassetid://321136141",
        SkyboxRt = "rbxassetid://321136141",
    },
}
local Skyboxes = getgenv().Skyboxes

local function getOrCreateSky()
    local sky = Lighting:FindFirstChild("CustomSky")
    if sky and sky:IsA("Sky") then
        return sky
    end

    sky = Instance.new("Sky")
    sky.Name = "CustomSky"
    sky.Parent = Lighting
    return sky
end

local function removeOtherSkies()
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Sky") and obj.Name ~= "CustomSky" then
            obj:Destroy()
        end
    end
end

local SkyBackup = { skies = nil, lighting = nil }

local function backupSkyState()
    if SkyBackup.skies then return end
    SkyBackup.skies = {}
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Sky") and obj.Name ~= "CustomSky" then
            table.insert(SkyBackup.skies, obj:Clone())
        end
    end
    SkyBackup.lighting = {
        Brightness = Lighting.Brightness,
        ClockTime  = Lighting.ClockTime,
        FogEnd     = Lighting.FogEnd,
        FogStart   = Lighting.FogStart,
        FogColor   = Lighting.FogColor,
        Ambient    = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
    }
end

local function restoreSkyState()
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Sky") then obj:Destroy() end
    end
    if SkyBackup.skies then
        for _, s in ipairs(SkyBackup.skies) do
            s:Clone().Parent = Lighting
        end
    end
    local L = SkyBackup.lighting
    if L then
        Lighting.Brightness     = L.Brightness
        Lighting.ClockTime      = L.ClockTime
        Lighting.FogEnd         = L.FogEnd
        Lighting.FogStart       = L.FogStart
        Lighting.FogColor       = L.FogColor
        Lighting.Ambient        = L.Ambient
        Lighting.OutdoorAmbient = L.OutdoorAmbient
    end
    SkyBackup.skies = nil
    SkyBackup.lighting = nil
end

local function removeSky()
    local sky = Lighting:FindFirstChild("CustomSky")
    if sky then sky:Destroy() end
end

local function applySky()
    local cfg = getgenv().Skybox
    if not cfg.Enabled then
        removeSky()
        return
    end
    local data = Skyboxes[cfg.Type]
    if not data then return end

    backupSkyState()
    removeOtherSkies()

    local sky = getOrCreateSky()
    for prop, asset in pairs(data) do
        sky[prop] = asset
    end
    if Lighting:FindFirstChild("CustomSky") ~= sky then
        sky.Parent = Lighting
    end
end

-- weather
getgenv().Weather = getgenv().Weather or {
    Enabled = false,
    Type = "sunny",
    Intensity = 150,
    Speed = 1,
    Size = 1,
    Spread = 1,
    Glow = 0,
    Color = Color3.fromRGB(255, 255, 255),
}

getgenv().WeatherLightning = getgenv().WeatherLightning or {
    Enabled = false,
    Color = ColorSequence.new(Color3.fromRGB(214, 230, 255)),
    Interval = 2,
    Distance = 80,
    Height = 220,
    Thickness = 4,
    Branches = 12,
    Flash = 8,
    Sparks = {
        Enabled = true,
        Color = ColorSequence.new(Color3.fromRGB(238, 246, 255)),
        Count = 18,
        Thickness = 2.2,
        Distance = 22,
        Speed = 22,
        Jaggedness = 4,
    },
    Explosion = {
        Enabled = true,
        Size = 0.45,
        Bolts = 14,
        Color = ColorSequence.new(Color3.fromRGB(150, 200, 255)),
    },
    Sound = {
        Enabled = false,
        Volume = 1,
        Delay = true,
        SoundId = "",
    },
}

local Weather         = getgenv().Weather
local WeatherLightning = getgenv().WeatherLightning

local LCFG = {
    RadiusMin           = 20,
    GroundDrop          = 40,
    RayLength           = 1000,
    Jitter              = 30,
    ThunderSpeed        = 340,
    ThunderVolumeFloor  = 0.20,
    ThunderFalloff      = 600,
    ThunderPitchMin     = 0.85,
    ThunderPitchMax     = 1.10,
    FadeDuration        = 0.35,
    CleanupBuffer       = 0.05,
    FlickerMin          = 2,
    FlickerMax          = 3,
    FlickerOnMin        = 0.02,
    FlickerOnMax        = 0.045,
    FlickerOffMin       = 0.02,
    FlickerOffMax       = 0.05,
    FlickerDim          = 0.15,
}

local WeatherFolder
local WeatherAnchor
local WeatherEmitters = {}
local weatherKindActive

local function ensureWeatherFolder()
    if WeatherFolder and WeatherFolder.Parent then
        return WeatherFolder, WeatherAnchor
    end

    local f = Instance.new("Folder")
    f.Name = "AlacrityWeather"

    local anchor = Instance.new("Part")
    anchor.Name = "EmitterAnchor"
    anchor.Size = Vector3.new(220, 1, 220)
    anchor.Transparency = 1
    anchor.Anchored = true
    anchor.CanCollide = false
    anchor.CanQuery = false
    anchor.CanTouch = false
    anchor.Parent = f

    f.Parent = workspace

    WeatherFolder = f
    WeatherAnchor = anchor
    return f, anchor
end

local RAIN_REMOTE_URL = "https://alacrity.eu.cc/assets/rain.png"
local RAIN_LOCAL_DIR  = "Alacrity/assets"
local RAIN_LOCAL_PATH = RAIN_LOCAL_DIR .. "/rain.png"

local function ensureRainTexture()
    if isfolder and makefolder then
        if not isfolder("Alacrity") then makefolder("Alacrity") end
        if not isfolder(RAIN_LOCAL_DIR) then makefolder(RAIN_LOCAL_DIR) end
    end

    if isfile and writefile then
        if not isfile(RAIN_LOCAL_PATH) then
            local ok, data = pcall(function()
                return game:HttpGet(RAIN_REMOTE_URL, true)
            end)
            if ok and type(data) == "string" and #data > 128 then
                pcall(writefile, RAIN_LOCAL_PATH, data)
            else
                warn("[Weather] rain.png download failed")
                return nil
            end
        end
    end

    local assetFn = getsynasset or getcustomasset
    if not assetFn then
        warn("[Weather] executor has no getcustomasset/getsynasset")
        return nil
    end
    local ok, asset = pcall(assetFn, RAIN_LOCAL_PATH)
    if ok and asset then
        return asset
    end
    warn("[Weather] getcustomasset failed: " .. tostring(asset))
    return nil
end

local RAIN_TEXTURE = ensureRainTexture()

local RAIN_TEX = RAIN_TEXTURE or "rbxasset://textures/particles/smoke_main.dds"

local WEATHER_SPECS = {
    rain = {
    {
        Texture = RAIN_TEX,
        TransparencyMax = 0.65,
        LifetimeMin = 0.7, LifetimeMax = 1.1,
        BaseRate = 45,
        SpeedMin = 160, SpeedMax = 200,
        SizeStart = 45, SizeEnd = 45,
        BaseSpread = 0.0,
        BaseAccelerationY = -120,
        RotationMin = 0, RotationMax = 0,
        RotationSpeedMin = 0, RotationSpeedMax = 0,
    },
},
heavyRain = {
    {
        Texture = RAIN_TEX,
        TransparencyMax = 0.75,
        LifetimeMin = 0.5, LifetimeMax = 0.8,
        BaseRate = 90,
        SpeedMin = 240, SpeedMax = 300,
        SizeStart = 55, SizeEnd = 55,
        BaseSpread = 0.0,
        BaseAccelerationY = -220,
        RotationMin = 0, RotationMax = 0,
        RotationSpeedMin = 0, RotationSpeedMax = 0,
    },
},
    snow = {
        {
            Texture = "rbxasset://textures/particles/smoke_main.dds",
            TransparencyMax = 0.15,
            LifetimeMin = 6, LifetimeMax = 9,
            BaseRate = 220,
            SpeedMin = 6, SpeedMax = 10,
            SizeStart = 0.35, SizeEnd = 0.25,
            BaseSpread = 0.4,
            BaseAccelerationY = -1,
        },
        {
            Texture = "rbxasset://textures/particles/sparkles_main.dds",
            TransparencyMax = 0.35,
            LifetimeMin = 6, LifetimeMax = 9,
            BaseRate = 60,
            SpeedMin = 5, SpeedMax = 8,
            SizeStart = 0.20, SizeEnd = 0.15,
            BaseSpread = 0.6,
            BaseAccelerationY = -0.5,
        },
    },
}

local function transparencyCurve(tMax)
    return NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.15, tMax),
        NumberSequenceKeypoint.new(0.85, tMax),
        NumberSequenceKeypoint.new(1, 1),
    })
end

local function makeEmitter(spec, parent)
    local p = Instance.new("ParticleEmitter")
    p.Shape = Enum.ParticleEmitterShape.Box
    p.EmissionDirection = Enum.NormalId.Bottom
    p.Texture = spec.Texture
    p.Transparency = transparencyCurve(spec.TransparencyMax or 0.35)
    p.Lifetime = NumberRange.new(spec.LifetimeMin, spec.LifetimeMax)
    p.Rotation = NumberRange.new(spec.RotationMin or 0, spec.RotationMax or 0)
    p.RotSpeed = NumberRange.new(spec.RotationSpeedMin or 0, spec.RotationSpeedMax or 0)
    p.LightInfluence = 0
    if spec.Orientation then p.Orientation = spec.Orientation end
    p.Enabled = false
    p.Parent = parent
    return p
end

local function rebuildWeatherEmitters(kind)
    local folder, anchor = ensureWeatherFolder()
    if not folder or not anchor then return end

    for _, e in ipairs(WeatherEmitters) do
        e.Emitter:Destroy()
    end
    WeatherEmitters = {}
    weatherKindActive = kind

    local specs = WEATHER_SPECS[kind]
    if not specs then return end

    for _, spec in ipairs(specs) do
        local emitter = makeEmitter(spec, anchor)
        table.insert(WeatherEmitters, { Emitter = emitter, Spec = spec })
    end
end

local function reconcileWeather()
    local cfg = Weather

    if not cfg.Enabled then
    for _, e in ipairs(WeatherEmitters) do
        e.Emitter.Enabled = false
    end

    if WeatherFolder and WeatherFolder.Parent then
        cleanupWeather()
    end
    return
end

    local kind = string.lower(cfg.Type or "sunny")
    local map = {
        ["rain"] = "rain",
        ["heavy rain"] = "heavyRain",
        ["snow"] = "snow",
    }

    local wanted = map[kind]
    if not wanted then
        for _, e in ipairs(WeatherEmitters) do
            e.Emitter.Enabled = false
        end
        return
    end

    if weatherKindActive ~= wanted or #WeatherEmitters == 0 then
        rebuildWeatherEmitters(wanted)
    end

    local intensity = tonumber(cfg.Intensity) or 150
    local speed = tonumber(cfg.Speed) or 1
    local size = tonumber(cfg.Size) or 1
    local spread = tonumber(cfg.Spread) or 1
    local glow = tonumber(cfg.Glow) or 0
    local color = ColorSequence.new(cfg.Color or Color3.fromRGB(255, 255, 255))

    for _, entry in ipairs(WeatherEmitters) do
        local e, spec = entry.Emitter, entry.Spec
        e.Enabled = true
        e.Rate = spec.BaseRate * (intensity / 150)
        e.Speed = NumberRange.new(spec.SpeedMin * speed, spec.SpeedMax * speed)
        e.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, spec.SizeStart * size),
            NumberSequenceKeypoint.new(1, spec.SizeEnd * size),
        })
        e.LightEmission = glow
        local s = spec.BaseSpread * 60 * spread
        e.SpreadAngle = Vector2.new(s, s)
        e.Color = color
        e.Acceleration = Vector3.new(0, spec.BaseAccelerationY, 0)
    end
end

local function updateWeatherAnchor()
    if not WeatherFolder or not WeatherFolder.Parent then return end
    if not WeatherAnchor or not WeatherAnchor.Parent then
        ensureWeatherFolder()
        return
    end
    local cam = workspace.CurrentCamera
    if cam then
        WeatherAnchor.CFrame = cam.CFrame * CFrame.new(0, 80, 0)
    end
end

local function cleanupWeather()
    for _, e in ipairs(WeatherEmitters) do
        if e.Emitter then e.Emitter:Destroy() end
    end
    WeatherEmitters = {}
    weatherKindActive = nil

    if WeatherFolder and WeatherFolder.Parent then
        WeatherFolder:Destroy()
    end
    WeatherFolder = nil
    WeatherAnchor = nil
end

local LightningFolder
local LightningPartsActive = {}
local lastLightningAt = 0

local function ensureLightningFolder()
    if LightningFolder and LightningFolder.Parent then
        return LightningFolder
    end
    local f = Instance.new("Folder")
    f.Name = "AlacrityLightning"
    f.Parent = workspace
    LightningFolder = f
    return f
end

local function makeBoltPart(parent, a, b, color, thickness)
    local dist = (b - a).Magnitude
    if dist <= 0.01 then return nil end
    local p = Instance.new("Part")
    p.Anchored = true
    p.CanCollide = false
    p.CanQuery = false
    p.CanTouch = false
    p.Material = Enum.Material.Neon
    p.Color = color
    p.Size = Vector3.new(thickness, thickness, dist)
    p.CFrame = CFrame.lookAt(a, b) * CFrame.new(0, 0, -dist / 2)
    p.Transparency = 0
    p.Parent = parent
    return p
end

local function jitterPoint(base, factor)
    local j = LCFG.Jitter * factor
    return base + Vector3.new(
        (math.random() - 0.5) * j,
        (math.random() - 0.5) * j,
        (math.random() - 0.5) * j
    )
end

local function spawnLightningBolt(fromWorld, toWorld, cfg)
    local folder = ensureLightningFolder()
    local color = cfg.Color.Keypoints[1].Value
    local thickness = cfg.Thickness
    local branches = cfg.Branches or 0

    local segments = 24
    local points = { fromWorld }
    for i = 1, segments do
        local t = i / segments
        local base = fromWorld:Lerp(toWorld, t)
        local factor = 0.3 + 0.7 * (1 - math.sin(t * math.pi))
        table.insert(points, jitterPoint(base, factor))
    end
    points[#points] = toWorld

    local created = {}
    local prev = points[1]
    for i = 2, #points do
        local cur = points[i]
        local p = makeBoltPart(folder, prev, cur, color, thickness)
        if p then table.insert(created, p) end
        prev = cur
    end

    for _ = 1, branches do
        local t0 = 0.15 + math.random() * 0.65
        local idx = math.clamp(math.floor(t0 * #points), 1, #points)
        local a = points[idx]
        local dir = (toWorld - fromWorld).Unit
        local base = (dir + Vector3.new(
            (math.random() - 0.5) * 1.2,
            (math.random() - 0.5) * 1.2,
            (math.random() - 0.5) * 1.2
        )).Unit
        local branchEnd = a + base * (20 + math.random() * 40)
        local bseg = 6
        local bprev = a
        for i = 1, bseg do
            local bt = i / bseg
            local bcur = jitterPoint(a:Lerp(branchEnd, bt), 0.6)
            local p = makeBoltPart(folder, bprev, bcur, color, thickness * 0.6)
            if p then table.insert(created, p) end
            bprev = bcur
        end
    end

    return created
end

local function playThunder(distance, sound)
    if not sound or not sound.Enabled then return end
    local sid = sound.SoundId
    if not sid or sid == "" then return end
    local delay = (sound.Delay ~= false) and (distance / LCFG.ThunderSpeed) or 0
    local vol = (sound.Volume or 1) * math.max(LCFG.ThunderVolumeFloor, 1 - distance / LCFG.ThunderFalloff)
    local pitch = LCFG.ThunderPitchMin
        + math.random() * (LCFG.ThunderPitchMax - LCFG.ThunderPitchMin)

    task.delay(delay, function()
        local s = Instance.new("Sound")
        s.SoundId = sid
        s.Volume = vol
        s.PlaybackSpeed = pitch
        s.PlayOnRemove = true
        s.Parent = SoundService
        s:Destroy()
    end)
end

local function fireLightningStrike()
    if not WeatherLightning.Enabled then return end
    local cam = workspace.CurrentCamera
    if not cam then return end

    local camPos = cam.CFrame.Position
    local angle = math.random() * math.tau
    local rmin = math.min(LCFG.RadiusMin, WeatherLightning.Distance)
    local r = rmin + math.random() * (WeatherLightning.Distance - rmin)
    local wx = camPos.X + math.cos(angle) * r
    local wz = camPos.Z + math.sin(angle) * r

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local char = LocalPlayer and LocalPlayer.Character
    if char then
        rayParams.FilterDescendantsInstances = { char }
    end

    local height = WeatherLightning.Height
    local groundY = camPos.Y - LCFG.GroundDrop
    local hit = workspace:Raycast(
        Vector3.new(wx, camPos.Y + height, wz),
        Vector3.new(0, -LCFG.RayLength, 0),
        rayParams
    )
    if hit then groundY = hit.Position.Y end

    local top = Vector3.new(wx, groundY + height, wz)
    local bottom = Vector3.new(wx, groundY, wz)
    local parts = spawnLightningBolt(top, bottom, WeatherLightning)
    local now = os.clock()
    for _, p in ipairs(parts) do
        LightningPartsActive[p] = now
    end

    if WeatherLightning.Flash and WeatherLightning.Flash > 0 then
        local flashPart = Instance.new("Part")
        flashPart.Anchored = true
        flashPart.CanCollide = false
        flashPart.CanQuery = false
        flashPart.CanTouch = false
        flashPart.Transparency = 1
        flashPart.Size = Vector3.one
        flashPart.CFrame = CFrame.new(bottom)
        flashPart.Parent = ensureLightningFolder()

        local light = Instance.new("PointLight")
        light.Color = WeatherLightning.Color.Keypoints[1].Value
        light.Brightness = WeatherLightning.Flash
        light.Range = 70
        light.Parent = flashPart

        task.spawn(function()
            for _ = 1, math.random(LCFG.FlickerMin, LCFG.FlickerMax) do
                light.Brightness = WeatherLightning.Flash * (0.6 + math.random() * 0.4)
                task.wait(LCFG.FlickerOnMin + math.random() * (LCFG.FlickerOnMax - LCFG.FlickerOnMin))
                light.Brightness = WeatherLightning.Flash * LCFG.FlickerDim
                task.wait(LCFG.FlickerOffMin + math.random() * (LCFG.FlickerOffMax - LCFG.FlickerOffMin))
            end
            local tw = TweenService:Create(light, TweenInfo.new(0.35), { Brightness = 0 })
            tw:Play()
            task.delay(0.5, function()
                if flashPart and flashPart.Parent then flashPart:Destroy() end
            end)
        end)
    end

    task.delay(0.12, function()
        for _, p in ipairs(parts) do
            if p and p.Parent then
                local tw = TweenService:Create(p, TweenInfo.new(LCFG.FadeDuration), { Transparency = 1 })
                tw:Play()
                task.delay(LCFG.FadeDuration + LCFG.CleanupBuffer, function()
                    if p and p.Parent then p:Destroy() end
                    LightningPartsActive[p] = nil
                end)
            end
        end
    end)

    local dist = math.sqrt((wx - camPos.X)^2 + (wz - camPos.Z)^2)
    playThunder(dist, WeatherLightning.Sound)
end

local function tickLightning()
    if not WeatherLightning.Enabled then return end
    if not Weather.Enabled then return end
    if not (Weather.Type == "rain" or Weather.Type == "heavy rain") then
        return
    end
    if os.clock() - lastLightningAt < WeatherLightning.Interval then return end
    lastLightningAt = os.clock()
    fireLightningStrike()
end

local function sweepLightning()
    for p, t in pairs(LightningPartsActive) do
        if not p or not p.Parent or os.clock() - t > 2.5 then
            if p and p.Parent then p:Destroy() end
            LightningPartsActive[p] = nil
        end
    end
end

RunService.RenderStepped:Connect(function()
    if Weather.Enabled then
        pcall(reconcileWeather)
        pcall(updateWeatherAnchor)
        pcall(tickLightning)
        pcall(sweepLightning)
    elseif WeatherFolder and WeatherFolder.Parent then
        pcall(cleanupWeather)
    end
    if Skybox.Enabled then pcall(applySky) end
end)

getgenv().CustomFog = getgenv().CustomFog or {
    Enabled = false,
    Start = 0,
    End = 150,
    Color = Color3.fromRGB(180, 180, 180),
    Density = 0.5,
    ColorEnabled = true,
}

local function getOrCreateAtmosphere()
    local atmos = Lighting:FindFirstChild("CustomFogAtmosphere")
    if not atmos then
        local oldAtmos = Lighting:FindFirstChildOfClass("Atmosphere")
        if oldAtmos and oldAtmos.Name ~= "CustomFogAtmosphere" then oldAtmos:Destroy() end

        atmos = Instance.new("Atmosphere")
        atmos.Name = "CustomFogAtmosphere"
        atmos.Parent = Lighting
    end
    return atmos
end

local function removeAtmosphere()
    local atmos = Lighting:FindFirstChild("CustomFogAtmosphere")
    if atmos then atmos:Destroy() end
end

local function updateFogSystem()
    local cfg = getgenv().CustomFog
    if not cfg.Enabled then
        removeAtmosphere()
        return
    end

    local atmos = getOrCreateAtmosphere()
    local targetColor = cfg.Color or Color3.fromRGB(180, 180, 180)

    atmos.Color = targetColor
    atmos.Decay = targetColor
    atmos.Density = cfg.Density or 0.5

    local startVal = cfg.Start or 0
    local endVal = cfg.End or 150
    atmos.Haze = math.clamp((1000 / (endVal - startVal)), 0, 10)
end

RunService.RenderStepped:Connect(function()
    pcall(updateFogSystem)
end)

-- monitor color
getgenv().ColorCorrection = Lighting:FindFirstChild("monitorcolor")
if not getgenv().ColorCorrection then
    getgenv().ColorCorrection = Instance.new("ColorCorrectionEffect")
    getgenv().ColorCorrection.Name = "monitorcolor"
    getgenv().ColorCorrection.Parent = Lighting
end
local ColorCorrection = getgenv().ColorCorrection

getgenv().EyeProtection = getgenv().EyeProtection or {
    Enabled = false,
    Color = Color3.fromRGB(110, 90, 235),
    Brightness = -0.05,
    Contrast = -0.1,
    Saturation = -0.2,
}

do
    local eyeProt = getgenv().EyeProtection

    if not ColorCorrection.Enabled then
        ColorCorrection.Enabled = false
    end

    local last = {
        Enabled = nil, Color = nil,
        Brightness = nil, Contrast = nil, Saturation = nil,
    }

    local function syncEyeProtection()
        local cfg = getgenv().EyeProtection
        if last.Enabled ~= cfg.Enabled then
            ColorCorrection.Enabled = cfg.Enabled
            last.Enabled = cfg.Enabled
        end
        if not cfg.Enabled then return end

        if last.Color ~= cfg.Color then
            ColorCorrection.TintColor = cfg.Color
            last.Color = cfg.Color
        end
        if last.Brightness ~= cfg.Brightness then
            ColorCorrection.Brightness = cfg.Brightness
            last.Brightness = cfg.Brightness
        end
        if last.Contrast ~= cfg.Contrast then
            ColorCorrection.Contrast = cfg.Contrast
            last.Contrast = cfg.Contrast
        end
        if last.Saturation ~= cfg.Saturation then
            ColorCorrection.Saturation = cfg.Saturation
            last.Saturation = cfg.Saturation
        end
    end

    getgenv().SyncEyeProtection = syncEyeProtection

    RunService.RenderStepped:Connect(function()
        pcall(syncEyeProtection)
    end)
end

-- thirdperson
local local_player = LocalPlayer

getgenv().CameraController = require(
    local_player:WaitForChild("PlayerScripts")
        :WaitForChild("Controllers")
        :WaitForChild("CameraController")
)
local CameraController = getgenv().CameraController

getgenv().ThirdPerson = getgenv().ThirdPerson or {
    Enable = false,
}

getgenv().originalPOV = getgenv().originalPOV or nil
task.spawn(function()
    local state = CameraController.CameraState
    getgenv().originalPOV = state:GetPublicState()
end)

function ThirdPersonSetEnabled(v)
    getgenv().ThirdPerson.Enable = v

    if CameraController.SetThirdPersonOverride then
        CameraController:SetThirdPersonOverride(v)
    end

    if not v then
        local state = CameraController.CameraState
        if state:GetPublicState() ~= state.States.FirstPerson then
            if getgenv().originalPOV ~= nil and state.SetPublicState then
                pcall(function()
                    state:SetPublicState(getgenv().originalPOV)
                end)
            else
                pcall(function()
                    state:TogglePOV()
                end)
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if not getgenv().ThirdPerson.Enable then return end

    local state = CameraController.CameraState
    if state:GetPublicState() ~= state.States.ThirdPerson then
        pcall(function()
            state:TogglePOV()
        end)
    end
end)

-- fly
getgenv().Player = LocalPlayer
Player = getgenv().Player
UIS = UserInputService

getgenv().Fly = getgenv().Fly or {
    flying = false,
    flyspeed = 50,
    keys = {
        W=false, A=false, S=false, D=false,
        E=false, Q=false,
        Space=false, LeftShift=false
    }
}
local Fly = getgenv().Fly
keys = Fly.keys

Character = nil
HRP = nil
Humanoid = nil

function CleanupForCharacter(char)
    if not char then return end

    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BodyVelocity") then
            v:Destroy()
        end
    end
end

getgenv().bv = getgenv().bv or nil

function BindCharacter(char)
    CleanupForCharacter(char)
    Character = char
    HRP = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")

    if Fly.flying then
        if getgenv().bv then getgenv().bv:Destroy() end
        getgenv().bv = Instance.new("BodyVelocity")
        getgenv().bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        getgenv().bv.Velocity = Vector3.zero
        getgenv().bv.Parent = HRP
    end
end

function EnableFlying()
    Fly.flying = true
    if HRP then
        if getgenv().bv then getgenv().bv:Destroy() end
        getgenv().bv = Instance.new("BodyVelocity")
        getgenv().bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        getgenv().bv.Velocity = Vector3.new(0,0,0)
        getgenv().bv.Parent = HRP
    end
end

function DisableFlying()
    Fly.flying = false
    if getgenv().bv then
        getgenv().bv:Destroy()
        getgenv().bv = nil
    end
end

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local key = input.KeyCode.Name
        if keys[key] ~= nil then keys[key] = true end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local key = input.KeyCode.Name
        if keys[key] ~= nil then keys[key] = false end
    end
end)

RunService.RenderStepped:Connect(function()
    if Fly.flying and HRP and getgenv().bv then
        local moveDir = Vector3.new(
            (keys.D and 1 or 0) - (keys.A and 1 or 0),
            (keys.Space and 1 or 0) - (keys.LeftShift  and 1 or 0),
            (keys.S and 1 or 0) - (keys.W and 1 or 0)
        )

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit
            local cam = Workspace.CurrentCamera
            local worldDir = cam.CFrame:VectorToWorldSpace(Vector3.new(moveDir.X, 0, moveDir.Z))
            getgenv().bv.Velocity = worldDir * Fly.flyspeed + Vector3.new(0, moveDir.Y * Fly.flyspeed, 0)
        else
            getgenv().bv.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)

if Player.Character then
    BindCharacter(Player.Character)
end
Player.CharacterAdded:Connect(BindCharacter)

-- infinite jump
local player = LocalPlayer

local player = Players.LocalPlayer

getgenv().InfiniteJump = getgenv().InfiniteJump or false

getgenv().jumpConnection = getgenv().jumpConnection or nil

local function setupInfiniteJump(character)
    local humanoid = character:WaitForChild("Humanoid")

    if getgenv().jumpConnection then
        getgenv().jumpConnection:Disconnect()
        getgenv().jumpConnection = nil
    end

    getgenv().jumpConnection = UserInputService.JumpRequest:Connect(function()
        if getgenv().InfiniteJump and humanoid and humanoid.Parent then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

if player.Character then
    setupInfiniteJump(player.Character)
end

player.CharacterAdded:Connect(function(character)
    setupInfiniteJump(character)
end)

-- velocity
lp = LocalPlayer

getgenv().WalkSpeed = getgenv().WalkSpeed or {
    Enabled = false,
    Speed = 1,
}

getgenv().WalkSpeedCharacter = getgenv().WalkSpeedCharacter or nil
getgenv().WalkSpeedHumanoid = getgenv().WalkSpeedHumanoid or nil
getgenv().WalkSpeedHRP = getgenv().WalkSpeedHRP or nil
getgenv().WalkSpeedRenderConn = getgenv().WalkSpeedRenderConn or nil

function bindCharacter(char)
    getgenv().WalkSpeedCharacter = char
    getgenv().WalkSpeedHumanoid = char:WaitForChild("Humanoid")
    getgenv().WalkSpeedHRP = char:WaitForChild("HumanoidRootPart")

    getgenv().WalkSpeedHumanoid.WalkSpeed = 16
    getgenv().WalkSpeedHumanoid.AutoRotate = true
end

function enableCustomMove()
    if getgenv().WalkSpeedRenderConn then return end

    getgenv().WalkSpeedRenderConn = RunService.RenderStepped:Connect(function(dt)

        local cfg = getgenv().WalkSpeed
        if not cfg.Enabled then return end
        if not getgenv().WalkSpeedCharacter or not getgenv().WalkSpeedHumanoid or not getgenv().WalkSpeedHRP then return end
        if getgenv().WalkSpeedHumanoid.Health <= 0 then return end

        getgenv().WalkSpeedHumanoid.WalkSpeed = 0
        getgenv().WalkSpeedHumanoid.AutoRotate = false

        local moveDirection = getgenv().WalkSpeedHumanoid.MoveDirection

        if moveDirection.Magnitude > 0 then
            local hrp = getgenv().WalkSpeedHRP
            hrp.AssemblyLinearVelocity = Vector3.new(
                moveDirection.Unit.X * cfg.Speed,
                hrp.AssemblyLinearVelocity.Y,
                moveDirection.Unit.Z * cfg.Speed
            )
        else
            local hrp = getgenv().WalkSpeedHRP
            hrp.AssemblyLinearVelocity = Vector3.new(
                0,
                hrp.AssemblyLinearVelocity.Y,
                0
            )
        end
    end)
end

function disableCustomMove()
    if getgenv().WalkSpeedRenderConn then
        getgenv().WalkSpeedRenderConn:Disconnect()
        getgenv().WalkSpeedRenderConn = nil
    end

    if getgenv().WalkSpeedHumanoid then
        getgenv().WalkSpeedHumanoid.WalkSpeed = 16
        getgenv().WalkSpeedHumanoid.AutoRotate = true
    end
end

if lp.Character then
    bindCharacter(lp.Character)
end

lp.CharacterAdded:Connect(bindCharacter)

RunService.RenderStepped:Connect(function()
    if getgenv().WalkSpeed.Enabled then
        enableCustomMove()
    else
        disableCustomMove()
    end
end)

-- spin
player = LocalPlayer

player = Players.LocalPlayer
getgenv().Spin = getgenv().Spin or {
    Enabled = false,
    Speed = 1,
}

getgenv().spinConn = getgenv().spinConn or nil

function setup(char)
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    if getgenv().spinConn then
        getgenv().spinConn:Disconnect()
        getgenv().spinConn = nil
    end

    getgenv().spinConn = RunService.RenderStepped:Connect(function()
        if not hrp or not hrp.Parent then
            return
        end

        local cfg = getgenv().Spin
        if cfg.Enabled then
            if hum then
                hum.AutoRotate = false
            end

            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(cfg.Speed), 0)
        else
            if hum then
                hum.AutoRotate = true
            end
        end
    end)
end

if player.Character then
    setup(player.Character)
end

player.CharacterAdded:Connect(setup)

-- noclip
local lp = LocalPlayer

getgenv().Noclip = getgenv().Noclip or false

getgenv().NoclipCharacter = getgenv().NoclipCharacter or nil

getgenv().targetParts = getgenv().targetParts or {
    ["HumanoidRootPart"] = true,
    ["PhysicalHitboxHead"] = true
}
local targetParts = getgenv().targetParts

local function bindCharacter(char)
    getgenv().NoclipCharacter = char
end

if lp.Character then
    bindCharacter(lp.Character)
end

lp.CharacterAdded:Connect(bindCharacter)

RunService.Heartbeat:Connect(function()
    if not getgenv().NoclipCharacter then
        return
    end

    for _, v in ipairs(getgenv().NoclipCharacter:GetDescendants()) do
        if v:IsA("BasePart") and targetParts[v.Name] then
            v.CanCollide = not getgenv().Noclip
        end
    end
end)

-- slideboost
getgenv().SlideBoost = getgenv().SlideBoost or {
    Enabled = false,
    Speed   = 100,
}

getgenv().mech = getgenv().mech or require(game:GetService("Players").LocalPlayer.PlayerScripts.Controllers.MechanicsController)
local mech = getgenv().mech

game:GetService("RunService").RenderStepped:Connect(function()
    local cfg = getgenv().SlideBoost
    if not cfg or not cfg.Enabled then return end

    if mech.IsSliding then
        mech._sliding_velocity.Velocity = mech._sliding_velocity.Velocity.Unit * cfg.Speed
    end
end)

-- animation
getgenv().Config = getgenv().Config or {
    Animation = "Agree",

    KnownAnimations = {
        ["Agree"] = { ID = 85429197687197, SOUNDS = {78663178795648}, LOOPSOUNDS = false },
        ["Coo Coo"] = { ID = 125921589993721, SOUNDS = {134218301690577, 71288358864209}, LOOPSOUNDS = false },
        ["Cream Cheese Honey"] = { ID = 71250144811352, SOUNDS = {120250934207816}, LOOPSOUNDS = true },
        ["Criss Cross"] = { ID = 95986480266032, SOUNDS = {120250934207816}, LOOPSOUNDS = true },
        ["Denial"] = { ID = 81555757574094, SOUNDS = {75485128790168, 13158735106, 13158735106, 13158735106}, LOOPSOUNDS = false },
        ["Facepalm"] = { ID = 103862270973168, SOUNDS = {88377109323880, 13160326139}, LOOPSOUNDS = false },
        ["Kneel"] = { ID = 84754316528381, SOUNDS = {134140996504107}, LOOPSOUNDS = false },
        ["Off of You"] = { ID = 105875604689697, SOUNDS = {137662451042014}, LOOPSOUNDS = true },
        ["ROFL"] = { ID = 73786487009083, SOUNDS = {122605533507524, 126514820442685}, LOOPSOUNDS = false },
        ["Round & Round"] = { ID = 104273989039620, SOUNDS = {129000171133220}, LOOPSOUNDS = true },
        ["Shivering"] = { ID = 102458102253574, SOUNDS = {121062822157622}, LOOPSOUNDS = true },
        ["Shoulder Brush"] = { ID = 119282539520778, SOUNDS = {79768694812211, 79768694812211, 79768694812211, 79768694812211}, LOOPSOUNDS = false },
        ["Side To Side"] = { ID = 77255514751814, SOUNDS = {88051081362116}, LOOPSOUNDS = true },
        ["Smile"] = { ID = 98020061651338, SOUNDS = {98020061651338, 100664444144490}, LOOPSOUNDS = true },
        ["Snow Angels"] = { ID = 93924392025280, SOUNDS = {}, LOOPSOUNDS = false },
        ["Superhero"] = { ID = 115000869501227, SOUNDS = {80133530921906, 98970356172671}, LOOPSOUNDS = true },
        ["Take The L"] = { ID = 104639476409829, SOUNDS = {116605809326430}, LOOPSOUNDS = true },
        ["Think"] = { ID = 133733650708343, SOUNDS = {13160326139, 13160326139}, LOOPSOUNDS = false },
        ["Vegetable"] = { ID = 95292230449040, SOUNDS = {120797927157164}, LOOPSOUNDS = true }
    }
}
local Config = getgenv().Config

getgenv().AnimationSystem = getgenv().AnimationSystem or {
    CurrentTrack = nil,
    CurrentSounds = {},
    Connections = {},
    Enabled = false,
}
local AnimationSystem = getgenv().AnimationSystem

function AnimationSystem:StopAll()
    if self.CurrentTrack then
        pcall(function()
            self.CurrentTrack:Stop()
            self.CurrentTrack:Destroy()
        end)
        self.CurrentTrack = nil
    end

    for _, sound in ipairs(self.CurrentSounds) do
        pcall(function()
            sound:Stop()
            sound:Destroy()
        end)
    end
    table.clear(self.CurrentSounds)

    for name, conn in pairs(self.Connections) do
        if conn then
            conn:Disconnect()
            self.Connections[name] = nil
        end
    end

    local animFolder = LocalPlayer:FindFirstChild("Animations")
    if animFolder then animFolder:Destroy() end

    local soundFolder = LocalPlayer:FindFirstChild("Sounds")
    if soundFolder then soundFolder:Destroy() end
end

function AnimationSystem:PlaySound(id, looped)
    local folder = LocalPlayer:FindFirstChild("Sounds") or Instance.new("Folder")
    folder.Name = "Sounds"
    folder.Parent = LocalPlayer

    local sound = Instance.new("Sound")
    sound.SoundId = id
    sound.Looped = looped
    sound.Volume = 1
    sound.Parent = folder
    sound:Play()

    table.insert(self.CurrentSounds, sound)

    if not looped then
        sound.Ended:Connect(function()
            for i, s in ipairs(self.CurrentSounds) do
                if s == sound then
                    table.remove(self.CurrentSounds, i)
                    break
                end
            end
            pcall(function() sound:Destroy() end)
        end)
    end
end

function AnimationSystem:StartOverrideLoop()
    if self.Connections.Override then
        self.Connections.Override:Disconnect()
        self.Connections.Override = nil
    end

    self.Connections.Override = RunService.Heartbeat:Connect(function()
        if not self.Enabled then return end
        if not self.CurrentTrack then return end

        if not self.CurrentTrack.IsPlaying then
            self.CurrentTrack:Play()
        end
    end)
end

function AnimationSystem:PlayCurrent()
    local selected = Config and Config.KnownAnimations and Config.KnownAnimations[Config.Animation]
    if not selected then return end

    self:StopAll()

    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid

    local folder = Instance.new("Folder")
    folder.Name = "Animations"
    folder.Parent = LocalPlayer

    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. tostring(selected.ID)
    animation.Parent = folder

    local track = animator:LoadAnimation(animation)
    track.Looped = true
    track.Priority = Enum.AnimationPriority.Action4
    track:Play()
    self.CurrentTrack = track

    self.Connections.Died = humanoid.Died:Connect(function()
        self:StopAll()
    end)

    self:StartOverrideLoop()
end

function AnimationSystem:SetEnabled(v)
    self.Enabled = v
    if v then
        self:PlayCurrent()
    else
        self:StopAll()
    end
end

function AnimationSystem:InitCharacterListener()
    if self.CharacterConn then
        self.CharacterConn:Disconnect()
    end

    self.CharacterConn = LocalPlayer.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid", 10)
        if not humanoid then return end
        humanoid:WaitForChild("Animator", 5)

        task.wait(0.1)

        if self.Enabled then
            self:PlayCurrent()
        end
    end)
end

AnimationSystem:InitCharacterListener()

-- autoqueue
getgenv().autoqueue = getgenv().autoqueue or {
    QueueGonnaUse = "1v1",
    AutoMatch = false
}

Services.RunService.Heartbeat:Connect(function()
    if getgenv().autoqueue.AutoMatch == true then
        if isLobbyVisible() then
            pcall(function()
              ReplicatedStorage.Remotes.Matchmaking.JoinQueue:InvokeServer(getgenv().autoqueue.QueueGonnaUse)
          end)
        end
    end
end)

-- anti aim
getgenv().AntiAim = {
    Enabled = false,
    Yaw = "none",
    Pitch = "none",
    Angle = "none",
    CustomAngle = 0,
    MinSpeed = 10,
    MaxSpeed = 20,
    MinAngle = 30,
    MaxAngle = 60,
    RandomAngle = false,
    Underground = false,
}

AntiAimState = {
    FrameCounter = 0,
    SmoothYaw = 0,
    SmoothPitch = 0,
    SmoothRoll = 0,
    UndergroundOldPos = nil,
}

function isAntiAimActive()
    local cfg = getgenv().AntiAim
    if not cfg.Enabled then return false end
    if cfg.Yaw == "none" and cfg.Pitch == "none" and cfg.Angle == "none" then
        return false
    end
    return true
end

local function curweap2()
    local viewModels = Workspace:FindFirstChild("ViewModels")
    if not viewModels then return nil end
    local firstPerson = viewModels:FindFirstChild("FirstPerson")
    if not firstPerson then return nil end
    for _, child in ipairs(firstPerson:GetChildren()) do
        local childName = child.Name
        local parts = {}
        for part in childName:gmatch("[^-]+") do
            table.insert(parts, part:match("^%s*(.-)%s*$"))
        end
        if #parts >= 2 then
            return parts[2]
        end
    end
    return nil
end

local fighter_controller = require(
    LocalPlayer.PlayerScripts.Controllers.FighterController
)
local local_fighter = fighter_controller.LocalFighter
local camera_controller = require(
    LocalPlayer.PlayerScripts.Controllers.CameraController
)

local function getFloorBelowPosition(pos)
    local rayOrigin = pos
    local rayDirection = Vector3.new(0, -500, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    if local_fighter and local_fighter.Entity and local_fighter.Entity.RootPart then
        raycastParams.FilterDescendantsInstances = { local_fighter.Entity.RootPart.Parent }
    end
    local result = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    if result then
        return CFrame.new(Vector3.new(pos.X, result.Position.Y - 2, pos.Z))
    end
    return nil
end

local old_underground_camera_controller = camera_controller.Update
camera_controller.Update = function(...)
    local arguments = { ... }
    if getgenv().AntiAim.Underground
        and local_fighter and local_fighter.Entity and local_fighter.Entity.RootPart
        and AntiAimState.UndergroundOldPos then
        local_fighter.Entity.RootPart.CFrame = AntiAimState.UndergroundOldPos
    end
    return old_underground_camera_controller(table.unpack(arguments))
end

local function calculateYaw(deltaTime)
    local cfg = getgenv().AntiAim
    local yaw = 0
    local currentTime = tick()

    if cfg.Yaw == "jitter" then
        local minA = math.rad(cfg.MinAngle)
        local maxA = math.rad(cfg.MaxAngle)
        if cfg.RandomAngle then
            yaw = minA + math.random() * (maxA - minA)
            if math.random() > 0.5 then yaw = -yaw end
        else
            yaw = math.random() > 0.5 and minA or -minA
        end

    elseif cfg.Yaw == "spinbot" then
        local speed = cfg.MinSpeed / 10
            + math.random() * (cfg.MaxSpeed / 10 - cfg.MinSpeed / 10)
        yaw = (currentTime * speed) % (2 * math.pi)

    elseif cfg.Yaw == "random" then
        if AntiAimState.FrameCounter % 30 == 0 then
            yaw = math.rad(cfg.MaxAngle) * (math.random() * 2 - 1)
        else
            yaw = AntiAimState.SmoothYaw
        end
    end

    return yaw
end

local function calculatePitch()
    local cfg = getgenv().AntiAim
    local pitch = 0

    if cfg.Pitch == "jitter" then
        local minA = math.rad(cfg.MinAngle)
        local maxA = math.rad(cfg.MaxAngle)
        if cfg.RandomAngle then
            pitch = minA + math.random() * (maxA - minA)
            if math.random() > 0.5 then pitch = -pitch end
        else
            pitch = math.random() > 0.5 and minA or -minA
        end

    elseif cfg.Pitch == "spinbot" then
        pitch = math.sin(tick() * (cfg.MaxSpeed / 10)) * math.rad(cfg.MaxAngle)

    elseif cfg.Pitch == "random" then
        if AntiAimState.FrameCounter % 20 == 0 then
            pitch = math.rad(math.random(-89, 89))
        else
            pitch = AntiAimState.SmoothPitch
        end
    end

    return pitch
end

local function calculateRoll()
    local cfg = getgenv().AntiAim
    local roll = 0

    if cfg.Angle == "tilt 45" then
        roll = math.rad(45)
    elseif cfg.Angle == "tilt 90" then
        roll = math.rad(90)
    elseif cfg.Angle == "upside down" then
        roll = math.rad(180)
    elseif cfg.Angle == "custom" then
        roll = math.rad(cfg.CustomAngle)
    end

    return roll
end

local function flushAntiAimMovementState()
    AntiAimState.UndergroundOldPos = nil
    AntiAimState.FrameCounter = 0
    AntiAimState.SmoothYaw = 0
    AntiAimState.SmoothPitch = 0
    AntiAimState.SmoothRoll = 0

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        pcall(function()
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
    end
end

getgenv().InstanceFlushMovementState = function()
    flushAntiAimMovementState()
end

local _aaUGRayAccum = 0
RunService.Heartbeat:Connect(function(deltaTime)
    if getgenv().InstanceConfigLoading then return end

    local cfg = getgenv().AntiAim

    if cfg.Underground then
        _aaUGRayAccum += deltaTime
        if _aaUGRayAccum >= 0.1 then
            _aaUGRayAccum = 0
            local curweap = curweap2()
            if not curweap then
                AntiAimState.UndergroundOldPos = nil
            elseif local_fighter and local_fighter.Entity and local_fighter.Entity.RootPart then
                AntiAimState.UndergroundOldPos = local_fighter.Entity.RootPart.CFrame
                local floorCFrame = getFloorBelowPosition(local_fighter.Entity.RootPart.Position)
                if floorCFrame then
                    local_fighter.Entity.RootPart.CFrame = floorCFrame
                end
            end
        end
    else
        AntiAimState.UndergroundOldPos = nil
    end

    if not isAntiAimActive() then return end

    local curweap = curweap2()
    if not curweap then return end

    local character = LocalPlayer.Character
    if not character then return end

    local rootpart = character:FindFirstChild("HumanoidRootPart")
    if not rootpart then return end

    AntiAimState.FrameCounter = AntiAimState.FrameCounter + 1

    local calculatedYaw = calculateYaw(deltaTime)
    local calculatedPitch = calculatePitch()
    local calculatedRoll = calculateRoll()

    local rotationCFrame = CFrame.Angles(calculatedPitch, calculatedYaw, calculatedRoll)
    rootpart.CFrame = rootpart.CFrame * rotationCFrame
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.defer(flushAntiAimMovementState)
end)

do
    local Players        = Services.Players
    local RunService     = Services.RunService
    local UserInputService = Services.UserInputService
    local Lighting       = Services.Lighting
    local LocalPlayer    = getgenv().LocalPlayer

    local VMState = {
        Connections = {},
        ViewmodelDirty = true,
        ViewmodelAppliedAt = nil,
        ViewmodelSig = nil,
        ViewmodelWasEnabled = false,
        OriginalPivots = setmetatable({}, {__mode = "k"}),
        OriginalViewmodelVisuals = setmetatable({}, {__mode = "k"}),
        HiddenSurfaceAppearances = {},
        PrimitiveWireframes = setmetatable({}, {__mode = "k"}),
        MeshWireframes = setmetatable({}, {__mode = "k"}),
        WireframePool = {},
        WireframePoolCount = {},
        WireframeMeshLines = {},
        WireframeWasEnabled = false,
        CachedViewmodels = nil,
        CachedViewmodelsAt = 0,
        CachedFighter = nil,
        CachedFighterAt = 0,
        ViewmodelDescendantCache = setmetatable({}, {__mode = "k"}),
        ActiveWireframeKey = nil,
        LastFpsCap = nil,
    }

    local MAX_WIREFRAME_POOL = 96

    local function addConn(conn)
        table.insert(VMState.Connections, conn)
    end

    local function disconnectAll()
        for _, c in ipairs(VMState.Connections) do
            pcall(function() c:Disconnect() end)
        end
        table.clear(VMState.Connections)
    end

    VMDisabled, VMOverrideFps, VMFps = nil, nil, nil
    VMChams, VMChamFill, VMChamsColor = nil, nil, nil
    VMDisableArms = nil

    viewmodelDisableList = {
        "sway", "tilt", "bobbing", "muzzle flash", "idle animation", "jump animation",
        "slide animation", "equip animation", "shoot animation", "aiming animation", "sprint animation",
        "reload animation"
    }

    local function buildMaterialList()
        local list = {}
        for _, mat in ipairs(Enum.Material:GetEnumItems()) do
            local name = mat.Name
            if name ~= "Air" then
                table.insert(list, name)
            end
        end
        table.sort(list)
        return list
    end
    materialList = buildMaterialList()

    local function multiHas(value, key)
        if type(value) ~= "table" then return false end
        if value[key] == true then return true end
        for _, item in pairs(value) do
            if item == key then return true end
        end
        return false
    end

    local function getMaterial(name)
        local ok, mat = pcall(function()
            return Enum.Material[name or "ForceField"]
        end)
        return ok and mat or Enum.Material.ForceField
    end

local ARM_EXACT = {
    ["left arm"] = true, ["right arm"] = true,
    leftarm = true, rightarm = true,
    leftupperarm = true, leftlowerarm = true, lefthand = true,
    rightupperarm = true, rightlowerarm = true, righthand = true,
    ["_left_arm"] = true, ["_right_arm"] = true,
    leftitem = true, rightitem = true,
}

    local function isWeaponViewmodelInstance(obj)
        local current = obj
        while current do
            if current.Name == "ItemVisual" then return true end
            current = current.Parent
        end
        return false
    end

local function isArmInstance(obj)
    if isWeaponViewmodelInstance(obj) then
        local n = obj.Name:lower():gsub("[%s_%-]", "")
        if n == "leftitem" or n == "rightitem" then
            local cur = obj.Parent
            while cur do
                if cur.Name == "ItemVisual" then return false end
                cur = cur.Parent
            end
            return true
        end
        return false
    end

    local current = obj
    while current do
        local raw = current.Name:lower()
        local norm = raw:gsub("[%s_%-]", "")
        if ARM_EXACT[raw] or ARM_EXACT[norm] then
            return true
        end
        current = current.Parent
    end
    return false
end

    local function getWireframeColor(obj)
        local part = obj
        if obj and obj:IsA("SpecialMesh") then part = obj.Parent end
        if part and part:IsA("BasePart") then return part.Color end
        return Color3.fromRGB(0, 0, 0)
    end

    local function getOriginalVisual(obj)
        local original = VMState.OriginalViewmodelVisuals[obj]
        if not original then
            original = {}
            pcall(function()
                if obj:IsA("BasePart") then
                    original.Color = obj.Color
                    original.Material = obj.Material
                    original.Transparency = obj.Transparency
                    original.TextureID = obj:IsA("MeshPart") and obj.TextureID or nil
                    original.MaterialVariant = obj.MaterialVariant
                elseif obj:IsA("Texture") or obj:IsA("Decal") then
                    original.Transparency = obj.Transparency
                elseif obj:IsA("SpecialMesh") then
                    original.TextureId = obj.TextureId
                    original.VertexColor = obj.VertexColor
                elseif obj:IsA("SurfaceAppearance") then
                    original.Parent = obj.Parent
                end
            end)
            VMState.OriginalViewmodelVisuals[obj] = original
        end
        return original
    end

    local function restoreVisual(obj)
        local original = VMState.OriginalViewmodelVisuals[obj]
        if not original then return end
        pcall(function()
            if obj:IsA("BasePart") then
                if original.Color then obj.Color = original.Color end
                if original.Material then obj.Material = original.Material end
                if original.Transparency ~= nil then obj.Transparency = original.Transparency end
                if obj:IsA("MeshPart") and original.TextureID ~= nil then obj.TextureID = original.TextureID end
                if original.MaterialVariant ~= nil then obj.MaterialVariant = original.MaterialVariant end
            elseif obj:IsA("Texture") or obj:IsA("Decal") then
                if original.Transparency ~= nil then obj.Transparency = original.Transparency end
            elseif obj:IsA("SpecialMesh") then
                if original.TextureId ~= nil then obj.TextureId = original.TextureId end
                if original.VertexColor ~= nil then obj.VertexColor = original.VertexColor end
            end
        end)
    end

    local function hideSurfaceAppearance(obj)
        local original = getOriginalVisual(obj)
        if not original.Parent then return end
        VMState.HiddenSurfaceAppearances[obj] = original.Parent
        obj.Parent = nil
    end

    local function restoreHiddenSurfaceAppearances()
        local hidden = VMState.HiddenSurfaceAppearances
        for obj, parent in pairs(hidden) do
            if obj and parent and obj.Parent == nil then
                pcall(function() obj.Parent = parent end)
            end
            hidden[obj] = nil
        end
    end

    local function getLocalFighter()
        local now = os.clock()
        if VMState.CachedFighterAt and now - VMState.CachedFighterAt < 0.25 then
            return VMState.CachedFighter
        end
        local ok, controller = pcall(function()
            return require(LocalPlayer.PlayerScripts.Controllers.FighterController)
        end)
        local fighter = ok and controller and (controller.LocalFighter or controller:GetFighter(LocalPlayer)) or nil
        VMState.CachedFighter = fighter
        VMState.CachedFighterAt = now
        return fighter
    end

    local function getLocalViewmodels(forceRefresh)
    local now = tick()
    if not forceRefresh
        and VMState.CachedViewmodels
        and VMState.CachedViewmodelsAt
        and now - VMState.CachedViewmodelsAt < 0.1 then
        return VMState.CachedViewmodels
    end

    local out = {}
    local folder = workspace:FindFirstChild("ViewModels")
    if not folder then
        VMState.CachedViewmodels = out
        VMState.CachedViewmodelsAt = now
        return out
    end
    local prefix = LocalPlayer.Name .. " - "
    for _, model in ipairs(folder:GetDescendants()) do
        if model:IsA("Model") and model.Name:sub(1, #prefix) == prefix then
            table.insert(out, model)
        end
    end
    VMState.CachedViewmodels = out
    VMState.CachedViewmodelsAt = now
    return out
end

local markViewmodelDirty
local installViewmodelHooks
local installAimingHooks
local disableSelected

markViewmodelDirty = function()
    VMState.ViewmodelDirty = true
    VMState.ViewmodelAppliedAt = nil

    VMState.ViewmodelSig = nil
    if not ViewmodelHooked and installViewmodelHooks then
        installViewmodelHooks()
    end
    if not AimingHooked and disableSelected and disableSelected("aiming animation") then
        installAimingHooks()
    end
end

getgenv().markViewmodelDirty = markViewmodelDirty
getgenv().markViewmodelDirty = markViewmodelDirty
getgenv().installViewmodelHooks = installViewmodelHooks
getgenv().installAimingHooks = installAimingHooks
getgenv().viewmodelDisableSelected = disableSelected

    local function getViewmodelDescendants(model)
        local cache = VMState.ViewmodelDescendantCache[model]
        if not cache then
            cache = {Dirty = true, Objects = {}}
            VMState.ViewmodelDescendantCache[model] = cache
            cache.Added = model.DescendantAdded:Connect(function()
                cache.Dirty = true
                markViewmodelDirty()
            end)
            cache.Removing = model.DescendantRemoving:Connect(function()
                cache.Dirty = true
                markViewmodelDirty()
            end)
            addConn(cache.Added)
            addConn(cache.Removing)
        end
        if cache.Dirty then
            cache.Objects = model:GetDescendants()
            cache.Dirty = false
        end
        return cache.Objects
    end

    function disableSelected(name)
        return multiHas(VMDisabled and VMDisabled.Value or {}, name)
    end

    function shouldBlockAnimationKey(key)
        local lower = tostring(key or ""):lower()
        if lower == "" then return false end
        if disableSelected("idle animation") and lower:find("idle", 1, true) then return true end
        if disableSelected("jump animation") and lower:find("jump", 1, true) then return true end
        if disableSelected("slide animation") and lower:find("slide", 1, true) then return true end
        if disableSelected("equip animation") and lower:find("equip", 1, true) then return true end
        if disableSelected("reload animation") and lower:find("reload", 1, true) then return true end
        if disableSelected("shoot animation") and (lower:find("shoot", 1, true) or lower:find("fire", 1, true) or lower:find("attack", 1, true)) then return true end
        if disableSelected("sprint animation") and (lower:find("sprint", 1, true) or lower:find("run", 1, true)) then return true end
        return false
    end

   function zeroSpring(spring, value)
    if not spring then return end
    pcall(function()
        local current = spring.Value
        
        if current == nil then
            spring.Value = value
            spring.Target = value
            return
        end
        
        local currentType = typeof(current)
        local valueType = typeof(value)
        
        if currentType == "Vector2" and valueType ~= "Vector2" then
            value = Vector2.zero
        elseif currentType == "Vector3" and valueType ~= "Vector3" then
            value = Vector3.zero
        elseif currentType == "CFrame" and valueType ~= "CFrame" then
            value = CFrame.identity
        elseif currentType == "number" and valueType == "Vector2" then
            value = 0
        elseif currentType == "number" and valueType == "Vector3" then
            value = 0
        end
        
        spring.Value = value
        spring.Target = value
    end)
end

    function forceViewmodelAimValue(vm, enabled)
        if not vm then return end
        local value = enabled and 1 or 0
        vm.IsAiming = enabled == true
        vm.Aiming = enabled == true
        vm._is_aiming = enabled == true
        if vm.CurrentAimValue ~= nil then
            vm.CurrentAimValue = value
        end
    end

    function applyViewmodelDisableToObject(vm)
        if not vm then return end
        if disableSelected("sway") then zeroSpring(vm._sway_spring, Vector2.zero) end
        if disableSelected("tilt") then
            zeroSpring(vm._tilt_spring, Vector2.zero)
            zeroSpring(vm._raycast_tilt_spring, Vector2.zero)
        end
        if disableSelected("bobbing") then
            zeroSpring(vm._bobbing_speed_spring, Vector2.zero)
            zeroSpring(vm._bobbing_value_spring, Vector2.zero)
            vm._bobbing_tick = 0
        end
        if disableSelected("jump animation") then
            zeroSpring(vm._jump_spring, Vector2.zero)
            vm.CurrentJumpValue = 0
        end
        if disableSelected("sprint animation") then
            zeroSpring(vm._sprinting_spring, Vector2.zero)
        end
        if disableSelected("aiming animation") then
            local item = vm.ClientItem
            local isAiming = vm.IsAiming == true or vm.Aiming == true or vm._is_aiming == true
            pcall(function()
                if item and item.Get then
                    isAiming = isAiming or item:Get("IsAiming") == true
                end
            end)
            if isAiming and vm.CurrentAimValue ~= nil then
                forceViewmodelAimValue(vm, true)
            end
        end
        if VMRecoil then
    local scale = math.clamp((VMRecoil.Value or 100) / 100, 0, 1)
    if typeof(vm.CurrentRecoilValue) == "Vector3" then
        vm.CurrentRecoilValue = vm.CurrentRecoilValue * scale
    elseif typeof(vm.CurrentRecoilValue) == "Vector2" then
        vm.CurrentRecoilValue = vm.CurrentRecoilValue * scale
    end
end
    end

    ViewmodelHooked = false
    local OriginalViewmodelUpdate, OriginalViewmodelMuzzleFlash, OriginalViewmodelSetAiming, OriginalViewmodelPlayAnimation
    local OriginalAnimatorPlayAnimation
    local OriginalGunStartAiming, OriginalGunGetAimSpeed

    function installViewmodelHooks()
        if ViewmodelHooked then return end
        local ok, viewmodelModule = pcall(function()
            return require(LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem.ClientViewModel)
        end)
        if ok and type(viewmodelModule) == "table" then
            if type(viewmodelModule.Update) == "function" then
                OriginalViewmodelUpdate = viewmodelModule.Update
                viewmodelModule.Update = function(self, ...)
                    applyViewmodelDisableToObject(self)
                    local result = {OriginalViewmodelUpdate(self, ...)}
                    applyViewmodelDisableToObject(self)
                    return unpack(result)
                end
            end
            if type(viewmodelModule.MuzzleFlash) == "function" then
                OriginalViewmodelMuzzleFlash = viewmodelModule.MuzzleFlash
                viewmodelModule.MuzzleFlash = function(self, ...)
                    if disableSelected("muzzle flash") then return end
                    return OriginalViewmodelMuzzleFlash(self, ...)
                end
            end
            if type(viewmodelModule.SetAiming) == "function" then
                OriginalViewmodelSetAiming = viewmodelModule.SetAiming
                viewmodelModule.SetAiming = function(self, enabled, ...)
                    local result = {OriginalViewmodelSetAiming(self, enabled, ...)}
                    if disableSelected("aiming animation") then
                        forceViewmodelAimValue(self, enabled == true)
                    end
                    return unpack(result)
                end
            end
            if type(viewmodelModule.PlayAnimation) == "function" then
                OriginalViewmodelPlayAnimation = viewmodelModule.PlayAnimation
                viewmodelModule.PlayAnimation = function(self, key, ...)
                    if shouldBlockAnimationKey(key) then return nil end
                    return OriginalViewmodelPlayAnimation(self, key, ...)
                end
            end
        end
        pcall(function()
            local animatorModule = require(LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem.ClientViewModel.ViewModelAnimator)
            if type(animatorModule) == "table" and type(animatorModule.PlayAnimation) == "function" then
                OriginalAnimatorPlayAnimation = animatorModule.PlayAnimation
                animatorModule.PlayAnimation = function(self, key, ...)
                    if shouldBlockAnimationKey(key) then return nil end
                    return OriginalAnimatorPlayAnimation(self, key, ...)
                end
            end
        end)
        ViewmodelHooked = true
    end

    AimingHooked = false
    function installAimingHooks()
        if AimingHooked then return end
        local success, gunModule = pcall(function()
            return require(LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
        end)
        if not success or not gunModule then return end
        if gunModule.StartAiming then
            OriginalGunStartAiming = gunModule.StartAiming
            gunModule.StartAiming = function(self, ...)
                if not disableSelected("aiming animation") then
                    return OriginalGunStartAiming(self, ...)
                end
                self:SetReplicate("IsAiming", true)
                self.StopSprinting:Fire()
                self.ViewModel:SetAiming(true)
                self:SetReplicate("FOVOffset", self.Info.AimFOVOffset)
                if self.ViewModel and self.ViewModel.CurrentAimValue ~= nil then
                    self.ViewModel.CurrentAimValue = 1
                end
                return true, "StartAiming"
            end
        end
        if gunModule.GetAimSpeed then
            OriginalGunGetAimSpeed = gunModule.GetAimSpeed
            gunModule.GetAimSpeed = function(self)
                if disableSelected("aiming animation") then return 999 end
                return OriginalGunGetAimSpeed(self)
            end
        end
        AimingHooked = true
    end

local function currentChamColor()
    return (VMChamsColor and VMChamsColor.Value)
        or (Options and Options.VM_ChamsColor and Options.VM_ChamsColor.Value)
        or Color3.fromRGB(255, 255, 255)
end

local function currentChamFill()
    return (VMChamFill and VMChamFill.Value) or 50
end

function applyViewmodelOptions()
    local disable = VMDisabled and VMDisabled.Value or {}
    local now = tick()
    local vmChamsEnabled = VMChams and VMChams.Value == true
    local fpsEnabled = VMOverrideFps and VMOverrideFps.Value == true

    if fpsEnabled and setfpscap then
        local fps = VMFps and VMFps.Value or 60
        if VMState.LastFpsCap ~= fps then
            VMState.LastFpsCap = fps
            pcall(setfpscap, fps)
        end
    end

    local disableSig = ""
    if type(disable) == "table" then
        for _, name in ipairs(viewmodelDisableList) do
            if multiHas(disable, name) then
                disableSig ..= name .. ";"
            end
        end
    end

    local chamColor = currentChamColor()
    local chamFill  = currentChamFill()
    local viewmodelSig = table.concat({
        disableSig,
        tostring(VMDisableArms and VMDisableArms.Value or false),
        tostring(fpsEnabled and (VMFps and VMFps.Value or 60) or ""),
        tostring(vmChamsEnabled),
        tostring(chamFill),
        tostring(chamColor.R), tostring(chamColor.G), tostring(chamColor.B),
    }, "|")

    local viewmodelActive = disableSig ~= "" or vmChamsEnabled

    if not VMState.ViewmodelDirty
        and VMState.ViewmodelSig == viewmodelSig
        and VMState.ViewmodelAppliedAt
        and ((not viewmodelActive) or now - VMState.ViewmodelAppliedAt < 0.05) then
        return
    end
    VMState.ViewmodelSig = viewmodelSig
    VMState.ViewmodelAppliedAt = now
    VMState.ViewmodelDirty = false

    pcall(function()
    local cam = require(LocalPlayer.PlayerScripts.Controllers.CameraController)
    if multiHas(disable, "sway") and cam._sway_spring then
        zeroSpring(cam._sway_spring, Vector2.zero)
    end
    if multiHas(disable, "bobbing") then
        if cam._bobbing_speed_spring then
            zeroSpring(cam._bobbing_speed_spring, Vector2.zero)
        end
        if cam._bobbing_value_spring then
            zeroSpring(cam._bobbing_value_spring, Vector2.zero)
        end
    end
    if multiHas(disable, "tilt") then
        if cam._tilt_spring then
            zeroSpring(cam._tilt_spring, Vector2.zero)
        end
        if cam._raycast_tilt_spring then
            zeroSpring(cam._raycast_tilt_spring, Vector2.zero)
        end
    end
end)

    restoreHiddenSurfaceAppearances()

    for _, model in ipairs(getLocalViewmodels()) do
        for _, obj in ipairs(getViewmodelDescendants(model)) do
            if obj:IsA("BasePart") then
    local isWeapon = isWeaponViewmodelInstance(obj)
    local isArm = isArmInstance(obj)

        if VMDisableArms and VMDisableArms.Value and isArm then
        obj.Transparency = 1
        obj.LocalTransparencyModifier = 1
        obj.CastShadow = false
        for _, child in ipairs(obj:GetDescendants()) do
            if child:IsA("Texture")
                or child:IsA("Decal")
                or child:IsA("SurfaceAppearance")
                or child:IsA("WrapLayer")
                or child:IsA("WrapTarget") then
                pcall(function() child.Transparency = 1 end)
                if child:IsA("WrapLayer") or child:IsA("WrapTarget") then
                    pcall(function() child.Enabled = false end)
                end
            elseif child:IsA("Highlight") then
                pcall(function() child.Enabled = false end)
            elseif child:IsA("MeshPart") then
                pcall(function() child.TextureID = "" end)
            end
        end
        local armNameNorm = obj.Name:lower():gsub("[%s_%-]", "")
        local char = obj:FindFirstAncestorOfClass("Model")
        if char then
            for _, d in ipairs(char:GetDescendants()) do
                local dNameNorm = d.Name:lower():gsub("[%s_%-]", "")
                if dNameNorm == armNameNorm and d ~= obj then
                    if d:IsA("BasePart") then
                        pcall(function()
                            d.Transparency = 1
                            d.LocalTransparencyModifier = 1
                            d.CastShadow = false
                        end)
                        for _, c in ipairs(d:GetDescendants()) do
                            if c:IsA("Texture") or c:IsA("Decal") or c:IsA("SurfaceAppearance") then
                                pcall(function() c.Transparency = 1 end)
                            elseif c:IsA("WrapLayer") or c:IsA("WrapTarget") then
                                pcall(function() c.Enabled = false end)
                            elseif c:IsA("MeshPart") then
                                pcall(function() c.TextureID = "" end)
                            end
                        end
                    elseif d:IsA("Clothing") or d:IsA("Shirt") or d:IsA("Pants") then
                        pcall(function() d:Destroy() end)
                    end
                end
            end
        end
    elseif not vmChamsEnabled or not isWeapon then
        local orig = getOriginalVisual(obj)
        if orig and orig.Transparency ~= nil then
            obj.Transparency = orig.Transparency
            obj.LocalTransparencyModifier = 0
        end
        for _, child in ipairs(obj:GetDescendants()) do
            if child:IsA("Texture") or child:IsA("Decal") or child:IsA("SurfaceAppearance") then
                local o = getOriginalVisual(child)
                if o and o.Transparency ~= nil then child.Transparency = o.Transparency end
            end
        end
    end

    if isWeapon then
        restoreVisual(obj)
    end

    if vmChamsEnabled and isWeapon then
        local orig = getOriginalVisual(obj)
        
        local origTrans = orig and orig.Transparency or obj.Transparency
        if origTrans < 0.95 then
            obj.Material = Enum.Material.Neon
            obj.Color = chamColor
            obj.Transparency = math.clamp(1 - (chamFill / 100), 0, 1)
        end
    end
            elseif obj:IsA("SurfaceAppearance") then
                if vmChamsEnabled and isWeaponViewmodelInstance(obj) then
                    hideSurfaceAppearance(obj)
                end
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
                if multiHas(disable, "muzzle flash") then
                    obj.Enabled = false
                end
            end
        end
    end
end

local viewModelsFolderConn = nil
local function watchViewModelsFolder()
    if viewModelsFolderConn then
        pcall(function() viewModelsFolderConn:Disconnect() end)
        viewModelsFolderConn = nil
    end
    local folder = workspace:FindFirstChild("ViewModels")
    if not folder then
        task.delay(1, watchViewModelsFolder)
        return
    end
    viewModelsFolderConn = folder.DescendantAdded:Connect(function(obj)
        if obj:IsA("Model") or obj:IsA("BasePart") or obj:IsA("ItemVisual") then
            VMState.CachedViewmodels = nil
            VMState.CachedViewmodelsAt = 0
            markViewmodelDirty()
        end
    end)
    addConn(viewModelsFolderConn)
end
task.spawn(function()
    local deadline = os.clock() + 30
    while os.clock() < deadline do
        if workspace:FindFirstChild("ViewModels") then break end
        task.wait(0.25)
    end
    watchViewModelsFolder()
end)

local workspaceChildConn = workspace.ChildAdded:Connect(function(child)
    if child.Name == "ViewModels" then
        VMState.CachedViewmodels = nil
        VMState.CachedViewmodelsAt = 0
        markViewmodelDirty()
        watchViewModelsFolder()
    end
end)
addConn(workspaceChildConn)

local nextHeartbeatApply = 0
addConn(RunService.Heartbeat:Connect(function()
    local now = os.clock()
    if now < nextHeartbeatApply then return end
    nextHeartbeatApply = now + 0.05

    if VMChams and VMChams.Value then
        if not VMState.CachedViewmodels or #VMState.CachedViewmodels == 0 then
            VMState.CachedViewmodelsAt = 0
        end
    end

    local models = getLocalViewmodels(true)
    local lastCount = VMState._lastModelCount and #VMState._lastModelCount or 0
    if #models ~= lastCount then
        VMState._lastModelCount = models
        markViewmodelDirty()
    elseif VMState.ViewmodelDirty then
        -- nothing
    end
    if VMState.ViewmodelDirty then
        applyViewmodelOptions()
    end
end))

    task.spawn(function()
        installViewmodelHooks()
        if VMDisabled and disableSelected("aiming animation") then installAimingHooks() end
    end)
end

getgenv().autoload = getgenv().autoload or {}
getgenv().autoload.enable = getgenv().autoload.enable or false
getgenv().autoload.silent = getgenv().autoload.silent or false

-- UI Library
local function clampVs(v)
    return math.clamp(tonumber(v) or 1, 0.1, 2)
end

local function randVs(minT, maxT)
    local a = clampVs(minT)
    local b = clampVs(maxT)
    if b < a then
        a, b = b, a
    end
    if a == b then
        return a
    end
    return a + math.random() * (b - a)
end

getgenv().InstanceSetUnderground = getgenv().InstanceSetUnderground or function(val)
    getgenv().InstanceUndergroundEnabled = val == true
end

if not getgenv().shouldSuppressGameplayOverlays then
    getgenv().shouldSuppressGameplayOverlays = function()
        if getgenv().InstanceIsMenuOpen then
            return getgenv().InstanceIsMenuOpen()
        end
        return false
    end
end

shouldSuppressGameplayOverlays = getgenv().shouldSuppressGameplayOverlays

local repo = "https://raw.githubusercontent.com/rtyuyuwyuw1/LinoriaLib-UE-edition/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor = true
Library.NotifySide = "Left"

getgenv().showui = not (getgenv().autoload and getgenv().autoload.silent == true)

getgenv().Window = Library:CreateWindow({
	Title = "Alacrity.rip ・ discord.gg/3PwAy6Zy2D",
	Center = true,
	AutoShow = getgenv().showui,
	Resizable = false,
	ShowCustomCursor = true,
	UnlockMouseWhileOpen = true,
	NotifySide = "Left",
	TabPadding = 8,
	MenuFadeTime = 0
})

local Window = getgenv().Window

getgenv().Tabs = {
	Main = Window:AddTab("main"),
    World = Window:AddTab("world"),
	esp = Window:AddTab("esp"),
    Visual = Window:AddTab("visuals"),
	Movement = Window:AddTab("character"),
	Misc = Window:AddTab("misc"),
	["UI Settings"] = Window:AddTab("settings"),
}
local Tabs = getgenv().Tabs

do
-- Aimbot UI
local AimbotBox = Tabs.Main:AddLeftTabbox()
local AimbotTab = AimbotBox:AddTab("aimbot")

AimbotTab:AddToggle("AimbotEnableToggle", {
    Text = "enable",
    Tooltip = "enables aimbot",
    Default = false,
    Callback = function(Value)
        getgenv().Aimbot.Enabled = Value
    end
}):AddKeyPicker("aimbotkey", {
        Text = "aimbot",
        Default = "None",
        Mode = "Toggle",
        SyncToggleState = true,
})

AimbotTab:AddToggle("Aimbot Sticky Aim", {
    Text = "sticky aim",
    Tooltip = "enables sticky aim",
    Default = false,
    Callback = function(Value)
        getgenv().Aimbot.PersistTarget = Value
    end
})

AimbotTab:AddDropdown("Aim Part", {
    Values = { "head", "humanoidrootpart" },
    Default = 1,
    Multi = false,
    Text = "aim part",
    Tooltip = "aiming part",
    Searchable = false,
    Callback = function(Value)
        getgenv().Aimbot.AimPart = Value
    end,
})

AimbotTab:AddSlider("Aimbot Sensitivity", {
    Text = "sensitivity",
    Default = 15,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
        getgenv().Aimbot.Sensitivity = Value
    end,
    Tooltip = "sensitivity of the aimbot",
})

AimbotTab:AddSlider("Aimbot Deadzone", {
    Text = "dead zone",
    Default = 5,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
        getgenv().Aimbot.Deadzone = Value
    end,
    Tooltip = "deadzone of the aimbot",
})

AimbotTab:AddSlider("Aimbot Prediction", {
    Text = "prediction",
    Default = 0.12,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = false,
    Callback = function(Value)
        getgenv().Aimbot.Prediction = Value
    end,
    Tooltip = "prediction of the aimbot",
})

local AimbotFOV = AimbotBox:AddTab("fov")

AimbotFOV:AddToggle("AimbotFOVMaster", {
    Text = "show fov",
    Tooltip = "show or hide the fov",
    Default = getgenv().AimbotFOVSettings.enable,
    Callback = function(Value)
        getgenv().Aimbot.FovShow = Value
        getgenv().AimbotFOVSettings.enable = Value
    end,
})

AimbotFOV:AddSlider("AimbotFOVSize", {
    Text = "size",
    Default = getgenv().AimbotFOVSettings.range,
    Min = 1,
    Max = 999,
    Rounding = 0,
    Compact = false,
    Tooltip = "radius of the fov",
    Callback = function(Value)
        getgenv().Aimbot.AimRadius = Value
        getgenv().AimbotFOVSettings.range = Value
    end,
})

AimbotFOV:AddDivider()

AimbotFOV:AddToggle("AimbotFOVFill", {
    Text = "fill",
    Tooltip = "show the filled circle",
    Default = getgenv().AimbotFOVSettings.fill,
    Callback = function(Value)
        getgenv().Aimbot.FovFilled = Value
        getgenv().AimbotFOVSettings.fill = Value
    end,
})

AimbotFOV:AddLabel("fill color 1"):AddColorPicker("AimbotFOVFillColor1", {
    Default = getgenv().AimbotFOVSettings.fillColors[1],
    Callback = function(v) getgenv().AimbotFOVSettings.fillColors[1] = v end,
})
AimbotFOV:AddLabel("fill color 2"):AddColorPicker("AimbotFOVFillColor2", {
    Default = getgenv().AimbotFOVSettings.fillColors[2],
    Callback = function(v) getgenv().AimbotFOVSettings.fillColors[2] = v end,
})
AimbotFOV:AddLabel("fill color 3"):AddColorPicker("AimbotFOVFillColor3", {
    Default = getgenv().AimbotFOVSettings.fillColors[3],
    Callback = function(v) getgenv().AimbotFOVSettings.fillColors[3] = v end,
})

AimbotFOV:AddSlider("AimbotFOVFillTrans1", {
    Text = "fill transparency 1",
    Default = getgenv().AimbotFOVSettings.fillTransparency[1], Min = 0, Max = 1, Rounding = 2, Compact = true,
    Callback = function(v) getgenv().AimbotFOVSettings.fillTransparency[1] = v end,
})
AimbotFOV:AddSlider("AimbotFOVFillTrans2", {
    Text = "fill transparency 2",
    Default = getgenv().AimbotFOVSettings.fillTransparency[2], Min = 0, Max = 1, Rounding = 2, Compact = true,
    Callback = function(v) getgenv().AimbotFOVSettings.fillTransparency[2] = v end,
})
AimbotFOV:AddSlider("AimbotFOVFillTrans3", {
    Text = "fill transparency 3",
    Default = getgenv().AimbotFOVSettings.fillTransparency[3], Min = 0, Max = 1, Rounding = 2, Compact = true,
    Callback = function(v) getgenv().AimbotFOVSettings.fillTransparency[3] = v end,
})

AimbotFOV:AddDivider()

AimbotFOV:AddToggle("AimbotFOVOutline", {
    Text = "outline",
    Tooltip = "show the outline",
    Default = getgenv().AimbotFOVSettings.outline,
    Callback = function(Value)
        getgenv().Aimbot.FovOutlineShow = Value
        getgenv().AimbotFOVSettings.outline = Value
    end,
})

AimbotFOV:AddLabel("outline color 1"):AddColorPicker("AimbotFOVOutlineColor1", {
    Default = getgenv().AimbotFOVSettings.outlineColors[1],
    Callback = function(v) getgenv().AimbotFOVSettings.outlineColors[1] = v end,
})
AimbotFOV:AddLabel("outline color 2"):AddColorPicker("AimbotFOVOutlineColor2", {
    Default = getgenv().AimbotFOVSettings.outlineColors[2],
    Callback = function(v) getgenv().AimbotFOVSettings.outlineColors[2] = v end,
})
AimbotFOV:AddLabel("outline color 3"):AddColorPicker("AimbotFOVOutlineColor3", {
    Default = getgenv().AimbotFOVSettings.outlineColors[3],
    Callback = function(v) getgenv().AimbotFOVSettings.outlineColors[3] = v end,
})

AimbotFOV:AddSlider("AimbotFOVOutlineTrans1", {
    Text = "outline transparency 1",
    Default = getgenv().AimbotFOVSettings.outlineTransparency[1], Min = 0, Max = 1, Rounding = 2, Compact = true,
    Callback = function(v) getgenv().AimbotFOVSettings.outlineTransparency[1] = v end,
})
AimbotFOV:AddSlider("AimbotFOVOutlineTrans2", {
    Text = "outline transparency 2",
    Default = getgenv().AimbotFOVSettings.outlineTransparency[2], Min = 0, Max = 1, Rounding = 2, Compact = true,
    Callback = function(v) getgenv().AimbotFOVSettings.outlineTransparency[2] = v end,
})
AimbotFOV:AddSlider("AimbotFOVOutlineTrans3", {
    Text = "outline transparency 3",
    Default = getgenv().AimbotFOVSettings.outlineTransparency[3], Min = 0, Max = 1, Rounding = 2, Compact = true,
    Callback = function(v) getgenv().AimbotFOVSettings.outlineTransparency[3] = v end,
})

AimbotFOV:AddSlider("AimbotFOVOutlineThickness", {
    Text = "outline thickness",
    Default = getgenv().AimbotFOVSettings.outlineThickness, Min = 0.5, Max = 5, Rounding = 1, Compact = true,
    Callback = function(v)
        getgenv().Aimbot.FovOutlineThickness = v
        getgenv().AimbotFOVSettings.outlineThickness = v
    end,
})

AimbotFOV:AddDivider()

AimbotFOV:AddToggle("AimbotFOVRotating", {
    Text = "rotating",
    Tooltip = "rotate the gradient",
    Default = getgenv().AimbotFOVSettings.movingRotation,
    Callback = function(v) getgenv().AimbotFOVSettings.movingRotation = v end,
})
AimbotFOV:AddSlider("AimbotFOVRotation", {
    Text = "rotation",
    Default = getgenv().AimbotFOVSettings.rotation, Min = 0, Max = 360, Rounding = 0, Suffix = "°", Compact = true,
    Callback = function(v) getgenv().AimbotFOVSettings.rotation = v end,
})
AimbotFOV:AddSlider("AimbotFOVRotationSpeed", {
    Text = "rotation speed",
    Default = getgenv().AimbotFOVSettings.rotationSpeed, Min = 0, Max = 5, Rounding = 2, Suffix = "x", Compact = true,
    Callback = function(v) getgenv().AimbotFOVSettings.rotationSpeed = v end,
})

-- TriggerBot UI
local TriggerBotBox = Tabs.Main:AddRightTabbox()
local TriggerBotTab = TriggerBotBox:AddTab("trigger bot")

TriggerBotTab:AddToggle("TriggerBotEnable", {
    Text = "enable",
    Tooltip = "enables trigger bot",
    Default = false,
    Callback = function(Value)
        getgenv().TriggerBot.Enabled = Value
    end
}):AddKeyPicker("triggerbotkey", {
        Text = "trigger bot",
        Default = "None",
        Mode = "Toggle",
        SyncToggleState = true,
})

TriggerBotTab:AddDropdown("TriggerBotBlacklistBody", {
    Text = "blacklist",
    Tooltip = "select which body parts to not shoot at",
    Values = {
        "head", "uppertorso", "lowertorso",
        "leftupperarm", "leftlowerarm", "rightupperarm", "rightlowerarm",
        "leftupperleg", "leftlowerleg", "rightupperleg", "rightlowerleg"
    },
    Default = {},
    Multi = true,
    Searchable = true,
    Callback = function(Value)
        for partName in pairs(getgenv().TriggerBot.BlacklistBody) do
            getgenv().TriggerBot.BlacklistBody[partName] = false
        end

        if type(Value) == "table" then
            for _, partName in ipairs(Value) do
                local proper = getgenv().normalizePartName and getgenv().normalizePartName(partName) or partName
                if getgenv().TriggerBot.BlacklistBody[proper] ~= nil then
                    getgenv().TriggerBot.BlacklistBody[proper] = true
                end
            end
        end
    end
})

-- Silent Aim UI
local SilentAimBox = Tabs.Main:AddLeftTabbox()
local SilentAimTab = SilentAimBox:AddTab("silent aim")

SilentAimTab:AddToggle("Silent Aim Enable", {
    Text = "enable",
    Tooltip = "enable silent aim",
    Default = false,
    Callback = function(Value)
        getgenv().SilentAim.Enabled = Value
    end
}):AddKeyPicker("silentaimkey", {
        Text = "silent aim",
        Default = "None",
        Mode = "Toggle",
        SyncToggleState = true,
})

SilentAimTab:AddToggle("Silent Aim Auto Shoot", {
    Text = "auto shoot",
    Tooltip = "enable silent aim auto shoot",
    Default = false,
    Callback = function(Value)
        getgenv().SilentAim.AutoShoot = Value
    end
})

SilentAimTab:AddDropdown("Silent Aim Part", {
    Values = { "head", "humanoidrootpart", "uppertorso", "lowertorso", "torso" },
    Default = 1,
    Multi = false,
    Text = "aim part",
    Tooltip = "choose the part to aim for the silent aim",
    Searchable = false,
    Callback = function(Value)
        getgenv().SilentAim.AimPart = Value
    end
})

SilentAimTab:AddDropdown("Silent Aim Method", {
    Values = { "fov", "distance"},
    Default = 1,
    Multi = false,
    Text = "method",
    Tooltip = "choose the method to aim for the silent aim",
    Searchable = false,
    Callback = function(Value)
        getgenv().SilentAim.Method = Value
    end
})

local SilentAimFOVTab = SilentAimBox:AddTab("fov")

SilentAimFOVTab:AddToggle("SilentAimFOVMaster", {
    Text = "show fov",
    Tooltip = "show or hide the fov",
    Default = getgenv().SilentAimFOVSettings.enable,
    Callback = function(Value)
        getgenv().SilentAim.ShowFOV = Value
        getgenv().SilentAimFOVSettings.enable = Value
    end,
})

SilentAimFOVTab:AddSlider("SilentAimFOVSize", {
    Text = "size",
    Default = 100,
    Min = 1,
    Max = 999,
    Rounding = 0,
    Compact = false,
    Tooltip = "radius of the fov",
    Callback = function(Value)
        getgenv().SilentAim.FOV = Value
        getgenv().SilentAimFOVSettings.range = Value
    end,
})

SilentAimFOVTab:AddDivider()

SilentAimFOVTab:AddToggle("SilentAimFOVFill", {
    Text = "fill",
    Tooltip = "show the filled circle",
    Default = getgenv().SilentAimFOVSettings.fill,
    Callback = function(Value)
        getgenv().SilentAim.FovFilled = Value
        getgenv().SilentAimFOVSettings.fill = Value
    end,
})

SilentAimFOVTab:AddLabel("fill color 1"):AddColorPicker("SilentAimFOVFillColor1", {
    Default = getgenv().SilentAimFOVSettings.fillColors[1],
    Callback = function(v) getgenv().SilentAimFOVSettings.fillColors[1] = v end,
})
SilentAimFOVTab:AddLabel("fill color 2"):AddColorPicker("SilentAimFOVFillColor2", {
    Default = getgenv().SilentAimFOVSettings.fillColors[2],
    Callback = function(v) getgenv().SilentAimFOVSettings.fillColors[2] = v end,
})
SilentAimFOVTab:AddLabel("fill color 3"):AddColorPicker("SilentAimFOVFillColor3", {
    Default = getgenv().SilentAimFOVSettings.fillColors[3],
    Callback = function(v) getgenv().SilentAimFOVSettings.fillColors[3] = v end,
})

SilentAimFOVTab:AddSlider("SilentAimFOVFillTrans1", {
    Text = "fill transparency 1",
    Default = getgenv().SilentAimFOVSettings.fillTransparency[1], Min = 0, Max = 1, Rounding = 2, Compact = true,
    Callback = function(v) getgenv().SilentAimFOVSettings.fillTransparency[1] = v end,
})
SilentAimFOVTab:AddSlider("SilentAimFOVFillTrans2", {
    Text = "fill transparency 2",
    Default = getgenv().SilentAimFOVSettings.fillTransparency[2], Min = 0, Max = 1, Rounding = 2, Compact = true,
    Callback = function(v) getgenv().SilentAimFOVSettings.fillTransparency[2] = v end,
})
SilentAimFOVTab:AddSlider("SilentAimFOVFillTrans3", {
    Text = "fill transparency 3",
    Default = getgenv().SilentAimFOVSettings.fillTransparency[3], Min = 0, Max = 1, Rounding = 2, Compact = true,
    Callback = function(v) getgenv().SilentAimFOVSettings.fillTransparency[3] = v end,
})

SilentAimFOVTab:AddDivider()

SilentAimFOVTab:AddToggle("SilentAimFOVOutline", {
    Text = "outline",
    Tooltip = "show the outline",
    Default = getgenv().SilentAimFOVSettings.outline,
    Callback = function(Value)
        getgenv().SilentAim.FovOutlineShow = Value
        getgenv().SilentAimFOVSettings.outline = Value
    end,
})

SilentAimFOVTab:AddLabel("outline color 1"):AddColorPicker("SilentAimFOVOutlineColor1", {
    Default = getgenv().SilentAimFOVSettings.outlineColors[1],
    Callback = function(v) getgenv().SilentAimFOVSettings.outlineColors[1] = v end,
})
SilentAimFOVTab:AddLabel("outline color 2"):AddColorPicker("SilentAimFOVOutlineColor2", {
    Default = getgenv().SilentAimFOVSettings.outlineColors[2],
    Callback = function(v) getgenv().SilentAimFOVSettings.outlineColors[2] = v end,
})
SilentAimFOVTab:AddLabel("outline color 3"):AddColorPicker("SilentAimFOVOutlineColor3", {
    Default = getgenv().SilentAimFOVSettings.outlineColors[3],
    Callback = function(v) getgenv().SilentAimFOVSettings.outlineColors[3] = v end,
})

SilentAimFOVTab:AddSlider("SilentAimFOVOutlineTrans1", {
    Text = "outline transparency 1",
    Default = getgenv().SilentAimFOVSettings.outlineTransparency[1], Min = 0, Max = 1, Rounding = 2, Compact = true,
    Callback = function(v) getgenv().SilentAimFOVSettings.outlineTransparency[1] = v end,
})
SilentAimFOVTab:AddSlider("SilentAimFOVOutlineTrans2", {
    Text = "outline transparency 2",
    Default = getgenv().SilentAimFOVSettings.outlineTransparency[2], Min = 0, Max = 1, Rounding = 2, Compact = true,
    Callback = function(v) getgenv().SilentAimFOVSettings.outlineTransparency[2] = v end,
})
SilentAimFOVTab:AddSlider("SilentAimFOVOutlineTrans3", {
    Text = "outline transparency 3",
    Default = getgenv().SilentAimFOVSettings.outlineTransparency[3], Min = 0, Max = 1, Rounding = 2, Compact = true,
    Callback = function(v) getgenv().SilentAimFOVSettings.outlineTransparency[3] = v end,
})

SilentAimFOVTab:AddSlider("SilentAimFOVOutlineThickness", {
    Text = "outline thickness",
    Default = getgenv().SilentAimFOVSettings.outlineThickness, Min = 0.5, Max = 5, Rounding = 1, Compact = true,
    Callback = function(v)
        getgenv().SilentAim.FovOutlineThickness = v
        getgenv().SilentAimFOVSettings.outlineThickness = v
    end,
})

SilentAimFOVTab:AddDivider()

SilentAimFOVTab:AddToggle("SilentAimFOVRotating", {
    Text = "rotating",
    Tooltip = "rotate the gradient",
    Default = getgenv().SilentAimFOVSettings.movingRotation,
    Callback = function(v) getgenv().SilentAimFOVSettings.movingRotation = v end,
})
SilentAimFOVTab:AddSlider("SilentAimFOVRotation", {
    Text = "rotation",
    Default = getgenv().SilentAimFOVSettings.rotation, Min = 0, Max = 360, Rounding = 0, Suffix = "°", Compact = true,
    Callback = function(v) getgenv().SilentAimFOVSettings.rotation = v end,
})
SilentAimFOVTab:AddSlider("SilentAimFOVRotationSpeed", {
    Text = "rotation speed",
    Default = getgenv().SilentAimFOVSettings.rotationSpeed, Min = 0, Max = 5, Rounding = 2, Suffix = "x", Compact = true,
    Callback = function(v) getgenv().SilentAimFOVSettings.rotationSpeed = v end,
})

-- Ragebot UI
local rbCfg = ragebot.config

rbCfg.orbit.active = rbCfg.orbit.active or false

local RagebotBox = Tabs.Main:AddRightTabbox()
local RagebotTab = RagebotBox:AddTab("rage bot")
local RagebotMiscTab = RagebotBox:AddTab("misc")
local RagebotStatusTab = RagebotBox:AddTab("status")

RagebotTab:AddToggle("RageEnable", {
    Text = "enable",
    Default = rbCfg.target.rageMasterOn,
    Callback = function(Value)
        rbCfg.target.rageMasterOn = Value
        rbCfg.target.auto = Value
        if Toggles and Toggles.TargetOn then
            Toggles.TargetOn:SetValue(Value)
        end
    end
}):AddKeyPicker("ragebotKey", {
    Text = "ragebot",
    Default = "None",
    Mode = "Toggle",
    SyncToggleState = true
})

RagebotTab:AddToggle("AutoShoot", {
    Text = "autoshoot",
    Default = rbCfg.target.autoshoot,
    Callback = function(val)
        rbCfg.target.autoshoot = val
    end,
})

RagebotTab:AddToggle("ForceWeapon", {
    Text = "force weapon",
    Default = rbCfg.target.forceWeapon,
    Tooltip = "auto-equip the selected weapon slot",
    Callback = function(val)
        rbCfg.target.forceWeapon = val
        if val and ragebot.eqSlot then
            ragebot.eqSlot()
        end
    end,
})

RagebotTab:AddDropdown("RageWeaponPick", {
    Text = "weapon",
    Default = rbCfg.target.weaponPick or "primary",
    Values = { "primary", "secondary", "melee" },
    Callback = function(val)
        rbCfg.target.weaponPick = val
        if rbCfg.target.forceWeapon and ragebot.eqSlot then
            ragebot.eqSlot()
        end
        if ragebot.refreshAtk then ragebot.refreshAtk() end
    end,
})

RagebotTab:AddDropdown("TargetPart", {
    Text = "hit part",
    Default = rbCfg.target.hitpart or "head",
    Values = { "head", "humanoidrootpart", "torso", "uppertorso", "closest", "random" },
    Callback = function(val)
        rbCfg.target.hitpart = val
    end,
})

RagebotTab:AddSlider("ShootAttempts", {
    Text = "shoot attempts",
    Default = rbCfg.target.shootAttempts or 1,
    Min = 1,
    Max = 3,
    Rounding = 0,
    Suffix = "x",
    Callback = function(val)
        rbCfg.target.shootAttempts = math.clamp(math.floor(tonumber(val) or 1), 1, 3)
    end,
})

RagebotTab:AddToggle("PredictT", {
    Text = "prediction",
    Default = rbCfg.prediction.enabled,
    Callback = function(val)
        rbCfg.prediction.enabled = val
    end,
})

RagebotTab:AddSlider("PredictMul", {
    Text = "prediction mult",
    Default = rbCfg.prediction.multiplier or 1.2,
    Min = 0.1,
    Max = 3.0,
    Rounding = 1,
    Callback = function(val)
        rbCfg.prediction.multiplier = val
    end,
})

RagebotTab:AddDropdown("AttackPosition", {
    Text = "attack position",
    Default = rbCfg.target.attackPosition or "default",
    Values = { "default", "behind", "under" },
    Callback = function(val)
        rbCfg.target.attackPosition = val
        if ragebot.refreshAtk then ragebot.refreshAtk() end
    end,
})

RagebotTab:AddToggle("AttackCustomEnabled", {
    Text = "custom attack offset",
    Default = rbCfg.target.attackCustomEnabled,
    Callback = function(val)
        rbCfg.target.attackCustomEnabled = val
        if ragebot.refreshAtk then ragebot.refreshAtk() end
    end,
})

RagebotTab:AddSlider("CustomFront", {
    Text = "custom front",
    Default = rbCfg.target.customFront or 0,
    Min = -20,
    Max = 20,
    Rounding = 1,
    Callback = function(val)
        rbCfg.target.customFront = val
    end,
})

RagebotTab:AddSlider("CustomSide", {
    Text = "custom side",
    Default = rbCfg.target.customSide or 0,
    Min = -20,
    Max = 20,
    Rounding = 1,
    Callback = function(val)
        rbCfg.target.customSide = val
    end,
})

RagebotTab:AddSlider("CustomVertical", {
    Text = "custom vertical",
    Default = rbCfg.target.customVertical or 0,
    Min = -20,
    Max = 20,
    Rounding = 1,
    Callback = function(val)
        rbCfg.target.customVertical = val
    end,
})

RagebotTab:AddSlider("CustomRadius", {
    Text = "custom radius",
    Default = rbCfg.target.customRadius or 0,
    Min = 0,
    Max = 20,
    Rounding = 1,
    Callback = function(val)
        rbCfg.target.customRadius = val
    end,
})

-- Misc
RagebotMiscTab:AddToggle("Orbit", {
    Text = "orbit",
    Default = rbCfg.orbit.active,
    Callback = function(Value)
        rbCfg.orbit.active = Value
    end,
})

RagebotMiscTab:AddSlider("OrbitRadius", {
    Text = "orbit radius",
    Default = rbCfg.orbit.radius or 0,
    Min = 0,
    Max = 30,
    Rounding = 0,
    Callback = function(Value)
        rbCfg.orbit.radius = Value
    end,
})

RagebotMiscTab:AddSlider("OrbitSpeed", {
    Text = "orbit speed",
    Default = rbCfg.orbit.speed or 9000,
    Min = 1,
    Max = 9000,
    Rounding = 0,
    Callback = function(Value)
        rbCfg.orbit.speed = Value
    end,
})

RagebotMiscTab:AddSlider("OrbitHeightOffset", {
    Text = "orbit height offset",
    Default = rbCfg.orbit.height or 1,
    Min = -20,
    Max = 20,
    Rounding = 0,
    Callback = function(Value)
        rbCfg.orbit.height = Value
    end,
})

RagebotMiscTab:AddToggle("VoidSpam", {
    Text = "voidspam",
    Default = rbCfg.voidspam.enabled,
    Callback = function(val)
        rbCfg.voidspam.enabled = val
        if val then
            if rbCfg.target.immune then
                rbCfg.voidspam.phase = nil
                return
            end
            rbCfg.voidspam.lastswitch = tick()
            rbCfg.voidspam.phase = "shoot"
            rbCfg.voidspam.currentduration = randVs(rbCfg.voidspam.shoot_min, rbCfg.voidspam.shoot_max)
        else
            rbCfg.voidspam.phase = nil
        end
    end,
})

RagebotMiscTab:AddSlider("VoidShootTime", {
    Text = "attack time",
    Default = rbCfg.voidspam.shoot_min or 1,
    Min = 0.1,
    Max = 2,
    Rounding = 1,
    Compact = true,
    Suffix = "s",
    Callback = function(val)
        rbCfg.voidspam.shoot_min = val
        rbCfg.voidspam.shoot_max = val
    end,
})

RagebotMiscTab:AddSlider("VoidHideTime", {
    Text = "hide time",
    Default = rbCfg.voidspam.hide_min or 1,
    Min = 0.1,
    Max = 2,
    Rounding = 1,
    Compact = true,
    Suffix = "s",
    Callback = function(val)
        rbCfg.voidspam.hide_min = val
        rbCfg.voidspam.hide_max = val
    end,
})

-- Status
RagebotStatusTab:AddToggle("RageStatus", {
    Text = "rage status",
    Default = rbCfg.ragestatus.enabled,
    Callback = function(val)
        rbCfg.ragestatus.enabled = val
    end,
})

RagebotStatusTab:AddDropdown("RageStatusMode", {
    Text = "mode",
    Default = rbCfg.ragestatus.mode or "static",
    Values = { "static", "dynamic", "follow" },
    Callback = function(val)
        rbCfg.ragestatus.mode = val
    end,
})

RagebotStatusTab:AddLabel("Color"):AddColorPicker("RageStatusColor", {
    Text = "color",
    Default = rbCfg.ragestatus.color,
    Callback = function(val)
        rbCfg.ragestatus.color = val
    end,
})

RagebotStatusTab:AddSlider("RageStatusOffsetX", {
    Text = "static offset x",
    Default = rbCfg.ragestatus.staticOffsetX or 0,
    Min = -500,
    Max = 500,
    Rounding = 0,
    Callback = function(val)
        rbCfg.ragestatus.staticOffsetX = val
    end,
})

RagebotStatusTab:AddSlider("RageStatusOffsetY", {
    Text = "static offset y",
    Default = rbCfg.ragestatus.staticOffsetY or 40,
    Min = -500,
    Max = 500,
    Rounding = 0,
    Callback = function(val)
        rbCfg.ragestatus.staticOffsetY = val
    end,
})

RagebotStatusTab:AddToggle("RageStatusAmmo", {
    Text = "show ammo",
    Default = rbCfg.ragestatus.showAmmo,
    Callback = function(val)
        rbCfg.ragestatus.showAmmo = val
    end,
})

RagebotStatusTab:AddToggle("RageStatusHideReload", {
    Text = "hide on reload",
    Default = rbCfg.ragestatus.hideOnReload,
    Callback = function(val)
        rbCfg.ragestatus.hideOnReload = val
    end,
})

RagebotStatusTab:AddSlider("RageStatusTextSize", {
    Text = "text size",
    Default = rbCfg.ragestatus.textSize or 15,
    Min = 8,
    Max = 30,
    Rounding = 0,
    Callback = function(val)
        rbCfg.ragestatus.textSize = val
    end,
})

RagebotStatusTab:AddSlider("RageStatusLineGap", {
    Text = "line gap",
    Default = rbCfg.ragestatus.lineGap or 15,
    Min = 0,
    Max = 50,
    Rounding = 0,
    Callback = function(val)
        rbCfg.ragestatus.lineGap = val
    end,
})

RagebotStatusTab:AddDropdown("RageStatusFont", {
    Text = "font",
    Default = rbCfg.ragestatus.fontName or "gotham",
    Values = { "gotham", "gothammedium", "gothambold", "arial", "arialbold", "code" },
    Callback = function(val)
        rbCfg.ragestatus.fontName = val
    end,
})

-- Weapon UI
local GunModBox = Tabs.Main:AddLeftTabbox()
local GunModTab = GunModBox:AddTab("weapon")

GunModTab:AddToggle("NoCooldownEnable", {
    Text = "no cooldown",
    Default = false,
    Tooltip = "enable custom shoot cooldown modifier (fixed to 0)",
    Callback = function(Value)
        getgenv().GunSystem.CooldownEnabled = Value
        getgenv().GunSystem.Cooldown = 0.0
        if getgenv().UpdateGunStats then
            getgenv().UpdateGunStats()
        end
    end
})

GunModTab:AddToggle("NoSpreadEnable", {
    Text = "no spread",
    Default = false,
    Tooltip = "enable custom spread modifier (fixed to 0)",
    Callback = function(Value)
        getgenv().GunSystem.SpreadEnabled = Value
        getgenv().GunSystem.Spread = 0.0
        if getgenv().UpdateGunStats then
            getgenv().UpdateGunStats()
        end
    end
})

GunModTab:AddToggle("NoRecoilEnable", {
    Text = "no recoil",
    Default = false,
    Tooltip = "enable custom recoil modifier (fixed to 0)",
    Callback = function(Value)
        getgenv().GunSystem.RecoilEnabled = Value
        getgenv().GunSystem.Recoil = 0.0
        if getgenv().UpdateGunStats then
            getgenv().UpdateGunStats()
        end
    end
})

GunModTab:AddToggle("NoMeleeCooldown", {
    Text = "no melee cooldown",
    Tooltip = "sets AttackCooldown to 0 for melee weapons",
    Default = false,
    Callback = function(Value)
        getgenv().ItemCooldownSystem.MeleeCooldown.Enabled = Value
        getgenv().ItemCooldownSystem.MeleeCooldown.Percentage = 0.0
        getgenv().ItemCooldownSystem.Refresh()
    end
})

GunModTab:AddToggle("NoDashCooldown", {
    Text = "no dash cooldown",
    Tooltip = "no cooldown on dash",
    Default = false,
    Callback = function(Value)
        getgenv().ItemCooldownSystem.DashCooldown.Enabled = Value
        getgenv().ItemCooldownSystem.DashCooldown.Percentage = 0.0
        getgenv().ItemCooldownSystem.Refresh()
    end
})

GunModTab:AddToggle("InstantAim", {
    Text = "instant aim",
    Tooltip = "aims instantly",
    Default = false,
   Callback = function(Value)
    local ICS = getgenv().ItemCooldownSystem
    if Value then
        ICS.SnapshotAll()
        ICS.AimSpeed.Enabled = true
        ICS.AimSpeed.Percentage = 5.0
        ICS.Refresh()
    else
        ICS.AimSpeed.Enabled = false
        ICS.RestoreField("AimSpeed")
        if getgenv().UpdateGunStats then getgenv().UpdateGunStats() end
    end
end
})

GunModTab:AddToggle("AutomaticWeapon", {
    Text = "automatic weapon",
    Tooltip = "removes shoot/reload input spam cooldown (semi-auto becomes auto)",
    Default = false,
    Callback = function(Value)
        getgenv().ItemCooldownSystem.AutomaticWeapon.Enabled = Value
        getgenv().ItemCooldownSystem.Refresh()
    end
})

GunModTab:AddToggle("InfiniteDoubleJump", {
    Text = "infinite double jumps",
    Tooltip = "infinite jumps with some weapons",
    Default = false,
    Callback = function(Value)
        getgenv().ItemCooldownSystem.MaxDoubleJumps.Enabled = Value
        getgenv().ItemCooldownSystem.MaxDoubleJumps.Count = 676767
        getgenv().ItemCooldownSystem.Refresh()
    end
})

local TargetingBox = Tabs.Main:AddLeftTabbox()
local TargetingTab = TargetingBox:AddTab("targeting")

TargetingTab:AddToggle("Aimbot Visible Only", {
    Text = "visible only",
    Tooltip = "checks enemies through wall",
    Default = false,
    Callback = function(Value)
        getgenv().Aimbot.WallCheck = Value
        getgenv().SilentAim.WallCheck = Value
    end
})

TargetingTab:AddToggle("AntiKatanaTargeting", {
    Text = "anti katana",
    Tooltip = "skip targets that are deflecting with katana",
    Default = false,
    Callback = function(Value)
        Targeting.AntiKatana = Value
    end,
})

TargetingTab:AddToggle("IgnoreProtectedToggle", {
    Text = "ignore protected",
    Tooltip = "enable player ignore list",
    Default = false,
    Callback = function(Value)
        Targeting.IgnoreEnabled = Value
        if not Value then
            table.clear(Targeting.IgnoreList)
        end
    end,
})

local function buildIgnorePlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(names, p.Name)
        end
    end
    table.sort(names)
    return names
end

TargetingTab:AddDropdown("IgnorePlayerList", {
    Text = "protected list",
    Tooltip = "players to ignore in all targeting",
    Values = buildIgnorePlayerNames(),
    Default = {},
    Multi = true,
    Searchable = true,
    Callback = function(selected)
        table.clear(Targeting.IgnoreList)

        local names = {}
        if type(selected) == "table" then
            for _, v in ipairs(selected) do
                if type(v) == "string" then names[v] = true end
            end
            for k, v in pairs(selected) do
                if type(k) == "string" and (v == true or v == 1) then
                    names[k] = true
                elseif type(v) == "string" then
                    names[v] = true
                end
            end
        elseif type(selected) == "string" then
            names[selected] = true
        end

        local matched = 0
        for name in pairs(names) do
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and (p.Name == name or p.DisplayName == name) then
                    Targeting.IgnoreList[p.UserId] = true
                    matched = matched + 1
                    break
                end
            end
        end
    end
})
end
do
-- ESP UI
local VisualPlayerBox = Tabs.esp:AddLeftTabbox()
local VisualPlayerTab = VisualPlayerBox:AddTab("players")

local DS = getgenv().DualESP.Settings.Players

VisualPlayerTab:AddToggle("Visual Main", {
    Text = "enable",
    Tooltip = "enable for esp players",
    Default = DS.Enabled,
    Callback = function(Value)
        DS.Enabled = Value
        getgenv().DualESP.SetDirty()
    end
}):AddKeyPicker("espKey", {
    Text = "esp",
    Default = "None",
    Mode = "Toggle",
    SyncToggleState = true
})

VisualPlayerTab:AddDropdown("Visual Box Type", {
    Text = "box type",
    Values = {"2D", "Corner"},
    Default = DS.BoundingBox.Type,
    Callback = function(Value)
        DS.BoundingBox.Type = Value
        getgenv().DualESP.SetDirty()
    end
})

-- ═══ Box ═══
VisualPlayerTab:AddToggle("Visual Box ESP", {
    Text = "box",
    Default = DS.BoundingBox.Enabled,
    Callback = function(Value)
        DS.BoundingBox.Enabled = Value
        getgenv().DualESP.SetDirty()
    end
}):AddColorPicker("BoxColor1", {
    Default = DS.BoundingBox.Color[1],
    Title = "color 1",
    Callback = function(v)
        DS.BoundingBox.Color[1] = v
        getgenv().DualESP.SetDirty()
    end,
}):AddColorPicker("BoxColor2", {
    Default = DS.BoundingBox.Color[2],
    Title = "color 2",
    Callback = function(v)
        DS.BoundingBox.Color[2] = v
        getgenv().DualESP.SetDirty()
    end,
})

VisualPlayerTab:AddSlider("BoxTrans1", {
    Text = "transparency 1",
    Min = 0, Max = 1, Default = DS.BoundingBox.Transparency[1], Rounding = 2,
    Callback = function(v)
        DS.BoundingBox.Transparency[1] = v
        getgenv().DualESP.SetDirty()
    end,
})
VisualPlayerTab:AddSlider("BoxTrans2", {
    Text = "transparency 2",
    Min = 0, Max = 1, Default = DS.BoundingBox.Transparency[2], Rounding = 2,
    Callback = function(v)
        DS.BoundingBox.Transparency[2] = v
        getgenv().DualESP.SetDirty()
    end,
})

VisualPlayerTab:AddSlider("Visual Box Rotation", {
    Text = "rotation",
    Min = 0, Max = 360, Default = DS.BoundingBox.Rotation, Rounding = 0, Suffix = "°",
    Callback = function(Value)
        DS.BoundingBox.Rotation = Value
        getgenv().DualESP.SetDirty()
    end
})

-- ═══ Box Fill ═══
VisualPlayerTab:AddToggle("Visual Box Filled", {
    Text = "fill",
    Default = DS.BoundingBox.Fill.Enabled,
    Callback = function(Value)
        DS.BoundingBox.Fill.Enabled = Value
        getgenv().DualESP.SetDirty()
    end
}):AddColorPicker("BoxFillColor1", {
    Default = DS.BoundingBox.Fill.Color[1],
    Title = "color 1",
    Callback = function(v)
        DS.BoundingBox.Fill.Color[1] = v
        getgenv().DualESP.SetDirty()
    end,
}):AddColorPicker("BoxFillColor2", {
    Default = DS.BoundingBox.Fill.Color[2],
    Title = "color 2",
    Callback = function(v)
        DS.BoundingBox.Fill.Color[2] = v
        getgenv().DualESP.SetDirty()
    end,
})

VisualPlayerTab:AddSlider("BoxFillTrans1", {
    Text = "transparency 1",
    Min = 0, Max = 1, Default = DS.BoundingBox.Fill.Transparency[1], Rounding = 2,
    Callback = function(v)
        DS.BoundingBox.Fill.Transparency[1] = v
        getgenv().DualESP.SetDirty()
    end,
})
VisualPlayerTab:AddSlider("BoxFillTrans2", {
    Text = "transparency 2",
    Min = 0, Max = 1, Default = DS.BoundingBox.Fill.Transparency[2], Rounding = 2,
    Callback = function(v)
        DS.BoundingBox.Fill.Transparency[2] = v
        getgenv().DualESP.SetDirty()
    end,
})

-- ═══ Box Glow ═══
VisualPlayerTab:AddToggle("Visual Box Glow", {
    Text = "glow",
    Default = DS.BoundingBox.Glow.Enabled,
    Callback = function(Value)
        DS.BoundingBox.Glow.Enabled = Value
        getgenv().DualESP.SetDirty()
    end
}):AddColorPicker("BoxGlowColor1", {
    Default = DS.BoundingBox.Glow.Color[1],
    Title = "color 1",
    Callback = function(v)
        DS.BoundingBox.Glow.Color[1] = v
        getgenv().DualESP.SetDirty()
    end,
}):AddColorPicker("BoxGlowColor2", {
    Default = DS.BoundingBox.Glow.Color[2],
    Title = "color 2",
    Callback = function(v)
        DS.BoundingBox.Glow.Color[2] = v
        getgenv().DualESP.SetDirty()
    end,
})

VisualPlayerTab:AddSlider("BoxGlowTrans1", {
    Text = "transparency 1",
    Min = 0, Max = 1, Default = DS.BoundingBox.Glow.Transparency[1], Rounding = 2,
    Callback = function(v)
        DS.BoundingBox.Glow.Transparency[1] = v
        getgenv().DualESP.SetDirty()
    end,
})
VisualPlayerTab:AddSlider("BoxGlowTrans2", {
    Text = "transparency 2",
    Min = 0, Max = 1, Default = DS.BoundingBox.Glow.Transparency[2], Rounding = 2,
    Callback = function(v)
        DS.BoundingBox.Glow.Transparency[2] = v
        getgenv().DualESP.SetDirty()
    end,
})

-- ═══ Chams ═══
VisualPlayerTab:AddToggle("Highlight ESP", {
    Text = "chams",
    Default = DS.Chams.Enabled,
    Callback = function(Value)
        DS.Chams.Enabled = Value
        getgenv().DualESP.SetDirty()
    end
}):AddColorPicker("ChamFillColor", {
    Default = DS.Chams.Fill[1],
    Title = "fill color",
    Callback = function(v)
        DS.Chams.Fill[1] = v
        getgenv().DualESP.SetDirty()
    end,
}):AddColorPicker("ChamOutlineColor", {
    Default = DS.Chams.Outline[1],
    Title = "outline color",
    Callback = function(v)
        DS.Chams.Outline[1] = v
        getgenv().DualESP.SetDirty()
    end,
})

VisualPlayerTab:AddSlider("ChamFillTrans", {
    Text = "fill transparency",
    Min = 0, Max = 1, Default = DS.Chams.Fill[2], Rounding = 2,
    Callback = function(v)
        DS.Chams.Fill[2] = v
        getgenv().DualESP.SetDirty()
    end,
})
VisualPlayerTab:AddSlider("ChamOutlineTrans", {
    Text = "outline transparency",
    Min = 0, Max = 1, Default = DS.Chams.Outline[2], Rounding = 2,
    Callback = function(v)
        DS.Chams.Outline[2] = v
        getgenv().DualESP.SetDirty()
    end,
})

-- ═══ Health Bar ═══
VisualPlayerTab:AddToggle("Health ESP", {
    Text = "health bar",
    Default = DS.Bars.HealthBar.Enabled,
    Callback = function(Value)
        DS.Bars.HealthBar.Enabled = Value
        getgenv().DualESP.SetDirty()
    end
}):AddColorPicker("HealthColorLow", {
    Default = DS.Bars.HealthBar.Color[1],
    Title = "low color",
    Callback = function(v)
        DS.Bars.HealthBar.Color[1] = v
        getgenv().DualESP.SetDirty()
    end,
}):AddColorPicker("HealthColorMid", {
    Default = DS.Bars.HealthBar.Color[2],
    Title = "mid color",
    Callback = function(v)
        DS.Bars.HealthBar.Color[2] = v
        getgenv().DualESP.SetDirty()
    end,
}):AddColorPicker("HealthColorHigh", {
    Default = DS.Bars.HealthBar.Color[3],
    Title = "high color",
    Callback = function(v)
        DS.Bars.HealthBar.Color[3] = v
        getgenv().DualESP.SetDirty()
    end,
})

VisualPlayerTab:AddDropdown("HealthBarPos", {
    Text = "position",
    Values = {"Top", "Bottom", "Left", "Right"},
    Default = DS.Bars.HealthBar.Position,
    Callback = function(v)
        DS.Bars.HealthBar.Position = v
        getgenv().DualESP.SetDirty()
    end,
})

-- ═══ Name ═══
VisualPlayerTab:AddToggle("Name ESP", {
    Text = "name",
    Default = DS.Name.Enabled,
    Callback = function(Value)
        DS.Name.Enabled = Value
        getgenv().DualESP.SetDirty()
    end
}):AddColorPicker("NameColor", {
    Default = DS.Name.Color,
    Title = "color",
    Callback = function(v)
        DS.Name.Color = v
        getgenv().DualESP.SetDirty()
    end,
})

VisualPlayerTab:AddToggle("NameUseDisplay", {
    Text = "use display name",
    Default = DS.Name.UseDisplay,
    Callback = function(v)
        DS.Name.UseDisplay = v
        getgenv().DualESP.SetDirty()
    end,
})
VisualPlayerTab:AddDropdown("NamePos", {
    Text = "position",
    Values = {"Top", "Bottom", "Left", "Right"},
    Default = DS.Name.Position,
    Callback = function(v)
        DS.Name.Position = v
        getgenv().DualESP.SetDirty()
    end,
})
VisualPlayerTab:AddSlider("NameTrans", {
    Text = "transparency",
    Min = 0, Max = 1, Default = DS.Name.Transparency, Rounding = 2,
    Callback = function(v)
        DS.Name.Transparency = v
        getgenv().DualESP.SetDirty()
    end,
})

-- ═══ Distance ═══
VisualPlayerTab:AddToggle("Distance ESP", {
    Text = "distance",
    Default = DS.Distance.Enabled,
    Callback = function(Value)
        DS.Distance.Enabled = Value
        getgenv().DualESP.SetDirty()
    end
}):AddColorPicker("DistanceColor", {
    Default = DS.Distance.Color,
    Title = "color",
    Callback = function(v)
        DS.Distance.Color = v
        getgenv().DualESP.SetDirty()
    end,
})

VisualPlayerTab:AddDropdown("DistancePos", {
    Text = "position",
    Values = {"Top", "Bottom", "Left", "Right"},
    Default = DS.Distance.Position,
    Callback = function(v)
        DS.Distance.Position = v
        getgenv().DualESP.SetDirty()
    end,
})
VisualPlayerTab:AddSlider("DistanceTrans", {
    Text = "transparency",
    Min = 0, Max = 1, Default = DS.Distance.Transparency, Rounding = 2,
    Callback = function(v)
        DS.Distance.Transparency = v
        getgenv().DualESP.SetDirty()
    end,
})

-- ═══ Weapon ═══
VisualPlayerTab:AddToggle("Tool ESP", {
    Text = "weapon",
    Default = DS.Weapon.Enabled,
    Callback = function(Value)
        DS.Weapon.Enabled = Value
        getgenv().DualESP.SetDirty()
    end
}):AddColorPicker("WeaponColor", {
    Default = DS.Weapon.Color,
    Title = "color",
    Callback = function(v)
        DS.Weapon.Color = v
        getgenv().DualESP.SetDirty()
    end,
})

VisualPlayerTab:AddDropdown("WeaponPos", {
    Text = "position",
    Values = {"Top", "Bottom", "Left", "Right"},
    Default = DS.Weapon.Position,
    Callback = function(v)
        DS.Weapon.Position = v
        getgenv().DualESP.SetDirty()
    end,
})
VisualPlayerTab:AddSlider("WeaponTrans", {
    Text = "transparency",
    Min = 0, Max = 1, Default = DS.Weapon.Transparency, Rounding = 2,
    Callback = function(v)
        DS.Weapon.Transparency = v
        getgenv().DualESP.SetDirty()
    end,
})

-- ═══ Flags ═══
VisualPlayerTab:AddToggle("Flags ESP", {
    Text = "flags",
    Default = DS.Flags.Enabled,
    Callback = function(Value)
        DS.Flags.Enabled = Value
        getgenv().DualESP.SetDirty()
    end
}):AddColorPicker("FlagsColor", {
    Default = DS.Flags.Color,
    Title = "color",
    Callback = function(v)
        DS.Flags.Color = v
        getgenv().DualESP.SetDirty()
    end,
})

VisualPlayerTab:AddDropdown("FlagsPos", {
    Text = "position",
    Values = {"Top", "Bottom", "Left", "Right"},
    Default = DS.Flags.Position,
    Callback = function(v)
        DS.Flags.Position = v
        getgenv().DualESP.SetDirty()
    end,
})
VisualPlayerTab:AddSlider("FlagsTrans", {
    Text = "transparency",
    Min = 0, Max = 1, Default = DS.Flags.Transparency, Rounding = 2,
    Callback = function(v)
        DS.Flags.Transparency = v
        getgenv().DualESP.SetDirty()
    end,
})

-- ═══ Extras ═══
VisualPlayerTab:AddDivider()
VisualPlayerTab:AddLabel("extras")

VisualPlayerTab:AddToggle("Tracer ESP", {
    Text = "tracer",
    Default = DS.Extras.Tracer.Enabled,
    Callback = function(Value)
        DS.Extras.Tracer.Enabled = Value
        getgenv().DualESP.SetDirty()
    end
}):AddColorPicker("TracerColor", {
    Default = DS.Extras.Tracer.Color,
    Title = "color",
    Callback = function(v)
        DS.Extras.Tracer.Color = v
        getgenv().DualESP.SetDirty()
    end,
})

VisualPlayerTab:AddToggle("Tracer From Cursor", {
    Text = "tracer from cursor",
    Default = DS.Extras.Tracer.FromCursor,
    Callback = function(v)
        DS.Extras.Tracer.FromCursor = v
        getgenv().DualESP.SetDirty()
    end,
})
VisualPlayerTab:AddSlider("TracerThickness", {
    Text = "tracer thickness",
    Min = 1, Max = 10, Default = DS.Extras.Tracer.Thickness, Rounding = 0,
    Callback = function(v)
        DS.Extras.Tracer.Thickness = v
        getgenv().DualESP.SetDirty()
    end,
})
VisualPlayerTab:AddSlider("TracerTrans", {
    Text = "tracer transparency",
    Min = 0, Max = 1, Default = DS.Extras.Tracer.Transparency, Rounding = 2,
    Callback = function(v)
        DS.Extras.Tracer.Transparency = v
        getgenv().DualESP.SetDirty()
    end,
})

VisualPlayerTab:AddToggle("Skeleton ESP", {
    Text = "skeleton",
    Default = DS.Extras.Skeleton.Enabled,
    Callback = function(Value)
        DS.Extras.Skeleton.Enabled = Value
        getgenv().DualESP.SetDirty()
    end
}):AddColorPicker("SkeletonColor", {
    Default = DS.Extras.Skeleton.Color,
    Title = "color",
    Callback = function(v)
        DS.Extras.Skeleton.Color = v
        getgenv().DualESP.SetDirty()
    end,
})

VisualPlayerTab:AddSlider("SkeletonThickness", {
    Text = "skeleton thickness",
    Min = 1, Max = 10, Default = DS.Extras.Skeleton.Thickness, Rounding = 0,
    Callback = function(v)
        DS.Extras.Skeleton.Thickness = v
        getgenv().DualESP.SetDirty()
    end,
})
VisualPlayerTab:AddSlider("SkeletonTrans", {
    Text = "skeleton transparency",
    Min = 0, Max = 1, Default = DS.Extras.Skeleton.Transparency, Rounding = 2,
    Callback = function(v)
        DS.Extras.Skeleton.Transparency = v
        getgenv().DualESP.SetDirty()
    end,
})
VisualPlayerTab:AddSlider("SkeletonMaxDist", {
    Text = "skeleton max distance",
    Min = 10, Max = 1000, Default = DS.Extras.Skeleton.MaxDistance, Rounding = 0,
    Callback = function(v)
        DS.Extras.Skeleton.MaxDistance = v
        getgenv().DualESP.SetDirty()
    end,
})

-- ═══ Misc ═══
VisualPlayerTab:AddDivider()

VisualPlayerTab:AddToggle("Visual LocalPlayer", {
    Text = "show local player",
    Default = DS.LocalPlayer,
    Callback = function(Value)
        DS.LocalPlayer = Value
        getgenv().DualESP.SetDirty()
    end
})

VisualPlayerTab:AddToggle("Visual Team Check", {
    Text = "enemies only",
    Tooltip = "hide teammates from all ESP elements",
    Default = DS.Extras.TeamCheck.Enabled,
    Callback = function(Value)
        DS.Extras.TeamCheck.Enabled = Value
        getgenv().DualESP.SetDirty()
    end
})

local VisualThrowingobjectsBox = Tabs.esp:AddRightTabbox()
local VisualThrowingobjectsTab = VisualThrowingobjectsBox:AddTab("utility")

VisualThrowingobjectsTab:AddToggle("Throwing objects Highlight", {
	Text = "cham",
	Tooltip = "enable for highlight throwing objects",
	Default = false,
	Callback = function(Value)
		getgenv().ItemESP.Highlight = Value
	end
})

VisualThrowingobjectsTab:AddToggle("Throwing objects Text", {
	Text = "name",
	Tooltip = "enable for showing the text of throwing objects",
	Default = false,
	Callback = function(Value)
		getgenv().ItemESP.Name = Value
	end
})

VisualThrowingobjectsTab:AddDivider()

VisualThrowingobjectsTab:AddToggle("Throwing objects Slingshot", {
	Text = "slingshot",
	Tooltip = "enable for showing the slingshot",
	Default = false,
	Callback = function(Value)
		TrackNames["Slingshot"].Enabled = Value
	end
})

VisualThrowingobjectsTab:AddToggle("Throwing objects Daggers", {
	Text = "daggers",
	Tooltip = "enable for showing the daggers",
	Default = false,
	Callback = function(Value)
		TrackNames["Daggers"].Enabled = Value
	end
})

VisualThrowingobjectsTab:AddToggle("Throwing objects Paintball Gun", {
	Text = "paintball gun",
	Tooltip = "enable for showing the paintball gun",
	Default = false,
	Callback = function(Value)
		TrackNames["Paintball Gun"].Enabled = Value
	end
})

VisualThrowingobjectsTab:AddToggle("Throwing objects Grenade Launcher", {
	Text = "grenade launcher",
	Tooltip = "enable for showing the grenade launcher",
	Default = false,
	Callback = function(Value)
		TrackNames["Grenade Launcher"].Enabled = Value
	end
})

VisualThrowingobjectsTab:AddToggle("Throwing objects Flare Gun", {
	Text = "flare gun",
	Tooltip = "enable for showing the flare gun",
	Default = false,
	Callback = function(Value)
		TrackNames["Flare Gun"].Enabled = Value
	end
})

VisualThrowingobjectsTab:AddToggle("Throwing objects Molotov", {
	Text = "molotov",
	Tooltip = "enable for showing the molotov",
	Default = false,
	Callback = function(Value)
		TrackNames["Molotov"].Enabled = Value
	end
})

VisualThrowingobjectsTab:AddToggle("Throwing objects Freeze Ray", {
	Text = "freeze ray",
	Tooltip = "enable for showing the freeze ray",
	Default = false,
	Callback = function(Value)
		TrackNames["Freeze Ray"].Enabled = Value
	end
})

VisualThrowingobjectsTab:AddToggle("Throwing objects Flashbang", {
	Text = "flashbang",
	Tooltip = "enable for showing the flashbang",
	Default = false,
	Callback = function(Value)
		TrackNames["Flashbang"].Enabled = Value
	end
})

VisualThrowingobjectsTab:AddToggle("Throwing objects Warpstone", {
	Text = "warpstone",
	Tooltip = "enable for showing the warpstone",
	Default = false,
	Callback = function(Value)
		TrackNames["Warpstone"].Enabled = Value
	end
})

VisualThrowingobjectsTab:AddToggle("Throwing objects Satchel", {
	Text = "satchel",
	Tooltip = "enable for showing the satchel",
	Default = false,
	Callback = function(Value)
		TrackNames["Satchel"].Enabled = Value
	end
})

VisualThrowingobjectsTab:AddToggle("Throwing objects Smoke Grenade", {
	Text = "smoke grenade",
	Tooltip = "enable for showing the smoke grenade",
	Default = false,
	Callback = function(Value)
		TrackNames["Smoke Grenade"].Enabled = Value
	end
})

VisualThrowingobjectsTab:AddToggle("Throwing objects Grenade", {
	Text = "grenade",
	Tooltip = "enable for showing the grenade",
	Default = false,
	Callback = function(Value)
		TrackNames["Grenade"].Enabled = Value
	end
})

VisualThrowingobjectsTab:AddToggle("Throwing objects Bow", {
	Text = "bow",
	Tooltip = "enable for showing the bow",
	Default = false,
	Callback = function(Value)
		TrackNames["Bow"].Enabled = Value
	end
})

VisualThrowingobjectsTab:AddToggle("Throwing objects RPG", {
	Text = "rpg",
	Tooltip = "enable for showing the rpg",
	Default = false,
	Callback = function(Value)
		TrackNames["RPG"].Enabled = Value
	end
})
end
do
-- World UI
local FogBox = Tabs.World:AddLeftTabbox()
local FogTab = FogBox:AddTab("fog")

FogTab:AddToggle("CustomFogEnable", {
    Text = "enable",
    Tooltip = "enable or disable the independent fog system",
    Default = false,
    Callback = function(Value)
        getgenv().CustomFog.Enabled = Value
    end
})

FogTab:AddSlider("CustomFogStart", {
    Text = "fog start distance",
    Default = 0,
    Min = 0,
    Max = 1000,
    Rounding = 0,
    Compact = false,
    Tooltip = "the distance where the fog starts to appear",
    Callback = function(Value)
        getgenv().CustomFog.Start = Value
    end
})

FogTab:AddSlider("CustomFogEnd", {
    Text = "fog end distance",
    Default = 150,
    Min = 5,
    Max = 5000,
    Rounding = 0,
    Compact = false,
    Tooltip = "the distance where everything becomes completely foggy",
    Callback = function(Value)
        getgenv().CustomFog.End = Value
    end
})

FogTab:AddSlider("CustomFogDensity", {
    Text = "fog density (transparency)",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = false,
    Tooltip = "adjust fog density / visibility multiplier (0 = transparent, 1 = thick)",
    Callback = function(Value)
        getgenv().CustomFog.Density = Value
    end
})

FogTab:AddDivider()

FogTab:AddToggle("CustomFogColorToggle", {
    Text = "enable custom color",
    Tooltip = "toggle custom fog color overlay",
    Default = true,
}):AddColorPicker("CustomFogColorPicker", {
    Default = Color3.fromRGB(180, 180, 180),
    Title = "fog color",
    Callback = function(Value)
        getgenv().CustomFog.Color = Value
    end
})

local ShadersTab = FogBox:AddTab("shaders")

ShadersTab:AddToggle("DOF", {
	Text = "dof",
	Tooltip = "enable dof of the shader",
	Default = false,
	Callback = function(Value)
		Effects.DOF = Value
	end
})

ShadersTab:AddToggle("Bloom", {
	Text = "bloom",
	Tooltip = "enable bloom of the shader",
	Default = false,
	Callback = function(Value)
		Effects.Bloom = Value
	end
})

ShadersTab:AddToggle("ColorCorrection", {
	Text = "colorcorrection",
	Tooltip = "enable colorcorrection of the shader",
	Default = false,
	Callback = function(Value)
		Effects.ColorCorrection = Value
	end
})

ShadersTab:AddToggle("Atmosphere", {
	Text = "atmosphere",
	Tooltip = "enable atmosphere of the shader",
	Default = false,
	Callback = function(Value)
		Effects.Atmosphere = Value
	end
})

ShadersTab:AddToggle("SunRays", {
	Text = "sunrays",
	Tooltip = "enable sunrays of the shader",
	Default = false,
	Callback = function(Value)
		Effects.SunRays = Value
	end
})

ShadersTab:AddToggle("DynamicExposure", {
	Text = "dynamicexposure",
	Tooltip = "enable dynamicexposure of the shader",
	Default = false,
	Callback = function(Value)
		Effects.DynamicExposure = Value
	end
})

ShadersTab:AddToggle("SpecularBoost", {
	Text = "specularboost",
	Tooltip = "enable specularboost of the shader",
	Default = false,
	Callback = function(Value)
		Effects.SpecularBoost = Value
	end
})

local Weatherbox = Tabs.World:AddRightTabbox()
local WeatherTab = Weatherbox:AddTab("weather")
local SkyboxTab = Weatherbox:AddTab("sky")

WeatherTab:AddToggle("CustomWeather", {
	Text = "enable",
	Tooltip = "enable custom weather",
	Default = false,
	Callback = function(Value)
		getgenv().Weather.Enabled = Value
	end
})

WeatherTab:AddDropdown("WeatherType", {
    Values = { "sunny", "rain", "heavy rain", "night", "snow" },
	Default = 1,
	Multi = false,
	Text = "weather type",
	Tooltip = "type of custom weather",
	Callback = function(Value)
		getgenv().Weather.Type = Value
	end
})

WeatherTab:AddSlider("WeatherIntensity", {
	Text = "weather intensity",
	Default = 500,
	Min = 1,
	Max = 1000,
	Rounding = 1,
	Compact = true,
	Callback = function(Value)
		getgenv().Weather.Intensity = Value
	end,
	Tooltip = "intensity of the custom weather",
})

WeatherTab:AddSlider("WeatherSpeed", {
    Text = "speed",
    Default = 1,
    Min = 0.2, Max = 3, Rounding = 2,
    Tooltip = "particle speed multiplier",
    Callback = function(v) Weather.Speed = v end,
})

WeatherTab:AddSlider("WeatherSize", {
    Text = "size",
    Default = 1,
    Min = 0.2, Max = 3, Rounding = 2,
    Tooltip = "particle size multiplier",
    Callback = function(v) Weather.Size = v end,
})

WeatherTab:AddSlider("WeatherSpread", {
    Text = "spread",
    Default = 1,
    Min = 0, Max = 3, Rounding = 2,
    Tooltip = "particle spread multiplier",
    Callback = function(v) Weather.Spread = v end,
})

WeatherTab:AddSlider("WeatherGlow", {
    Text = "glow",
    Default = 0,
    Min = 0, Max = 1, Rounding = 2,
    Tooltip = "particle light emission",
    Callback = function(v) Weather.Glow = v end,
})

WeatherTab:AddLabel("Color"):AddColorPicker("WeatherColor", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "weather color",
    Callback = function(v) Weather.Color = v end,
})

SkyboxTab:AddToggle("CustomSkybox", {
    Text = "enable",
    Default = false,
    Callback = function(Value)
        getgenv().Skybox.Enabled = Value
        if not Value then
            pcall(function()
                if restoreSkyState then restoreSkyState() end
                local sky = Lighting:FindFirstChild("CustomSky")
                if sky then sky:Destroy() end
            end)
        else
            pcall(applySky)
        end
    end
})

SkyboxTab:AddDropdown("SkyboxType", {
    Values = {"Afternoon","Blue Space","Classic Roblox","Cloudy","Dusk","Dawn","Dark Skies","Earth","Ethereal","Galaxy","Heaven","Horizontal Milky Way","Jungle","Mountains","Nebula","Night","Night Light","Ocean Sky","Pink Clouds","Red Dusk","Redshift","Saturn","SFOTH","Smoke","Solid Black","Space","Storm","Sunset","Underworld","Vertical Milky Way","White"},
	Default = 1,
	Multi = false,
	Text = "skybox type",
	Tooltip = "type of custom skybox",
	Callback = function(Value)
		getgenv().Skybox.Type = Value
	end
})

local MonitorColorGroup = Tabs.World:AddLeftTabbox()
local MonitorColorTab = MonitorColorGroup:AddTab("monitor color")

MonitorColorTab:AddToggle("MonitorColorToggle", {
    Text = "enable",
    Default = false,
    Callback = function(Value)
        getgenv().EyeProtection.Enabled = Value
    end
})
:AddColorPicker("MonitorColorColorPicker", {
    Default = Color3.fromRGB(110, 90, 235),
    Title = "filter color",
    Callback = function(Value)
        getgenv().EyeProtection.Color = Value
    end
})

MonitorColorTab:AddSlider("MonitorColorSlider", {
    Text = "brightness",
    Default = -0.05,
    Min = -1,
    Max = 1,
    Rounding = 2,
    Callback = function(Value)
        getgenv().EyeProtection.Brightness = Value
    end
})

MonitorColorTab:AddSlider("MonitorColorSlider", {
    Text = "contrast",
    Default = -0.1,
    Min = -1,
    Max = 1,
    Rounding = 2,
    Callback = function(Value)
        getgenv().EyeProtection.Contrast = Value
    end
})

MonitorColorTab:AddSlider("MonitorColorSlider", {
    Text = "saturation",
    Default = -0.2,
    Min = -1,
    Max = 1,
    Rounding = 2,
    Callback = function(Value)
        getgenv().EyeProtection.Saturation = Value
    end
})

local Xraybox = Tabs.World:AddRightTabbox()
local XrayTab = Xraybox:AddTab("x-ray")

XrayTab:AddToggle("EnableXray", {
	Text = "enable",
	Tooltip = "enable x-ray",
	Default = false,
	Callback = function(Value)
		SetMapXray(Value)
	end
})

XrayTab:AddSlider("XrayTransparency", {
    Text = "transparency",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        getgenv().Xray.Transparency = Value
        if getgenv().Xray.Enabled and RefreshXrayTransparency then
            RefreshXrayTransparency()
        end
    end,
    Tooltip = "transparency of the x-ray",
})
end
do
-- Visual UI
local Viewmodelbox = Tabs.Visual:AddLeftTabbox()
local ViewmodelTab = Viewmodelbox:AddTab("viewmodel")

local CosmeticChangerToggle = ViewmodelTab:AddToggle("CosmeticChangerOpen", {
    Text = "show cosmetic changer",
    Tooltip = "skin changer",
    Default = false,
    Callback = function(Value)
        shared.AlacrityCosmeticChanger.SetVisible(Value)
    end
}):AddKeyPicker("cosmeticchangerkey", {
    Text = "show cosmetic changer",
    Default = "None",
    Mode = "Toggle",
    SyncToggleState = true,
})

VMDisabled = ViewmodelTab:AddDropdown("VM_Disable", {
    Text = "disable",
    Tooltip = "disable viewmodel animations",
    Values = viewmodelDisableList,
    Default = 0,
    Multi = true,
    Callback = function()
        if getgenv().installViewmodelHooks then
            getgenv().installViewmodelHooks()
        end
        if getgenv().viewmodelDisableSelected and getgenv().viewmodelDisableSelected("aiming animation")
            and getgenv().installAimingHooks then
            getgenv().installAimingHooks()
        end
        if getgenv().markViewmodelDirty then
            getgenv().markViewmodelDirty()
        end
    end
})

VMOverrideFps = ViewmodelTab:AddToggle("VM_OverrideFps", {
    Text = "override fps",
    Tooltip = "override fps cap",
    Default = false,
    Callback = function()
        if getgenv().markViewmodelDirty then
            getgenv().markViewmodelDirty()
        end
    end
})

VMFps = ViewmodelTab:AddSlider("VM_Fps", {
    Text = "fps",
    Default = 60, Min = 1, Max = 240,
    Rounding = 0,
    Callback = function()
        if getgenv().markViewmodelDirty then
            getgenv().markViewmodelDirty()
        end
    end
})

VMChams = ViewmodelTab:AddToggle("VM_Chams", {
    Text = "chams",
    Default = false,
    Callback = function()
        if getgenv().markViewmodelDirty then
            getgenv().markViewmodelDirty()
        end
    end
})

VMDisableArms = ViewmodelTab:AddToggle("VM_DisableArms", {
    Text = "disable arms",
    Default = false,
    Callback = function()
        if getgenv().markViewmodelDirty then
            getgenv().markViewmodelDirty()
        end
    end
})

VMChamsColor = ViewmodelTab:AddLabel("cham color"):AddColorPicker("VM_ChamsColor", {
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function()
        if getgenv().markViewmodelDirty then
            getgenv().markViewmodelDirty()
        end
    end
})

VMChamFill = ViewmodelTab:AddSlider("VM_ChamFill", {
    Text = "fill transparency",
    Default = 50, Min = 0, Max = 100,
    Rounding = 0,
    Callback = function()
        if getgenv().markViewmodelDirty then
            getgenv().markViewmodelDirty()
        end
    end
})

getgenv().ViewportOffset = getgenv().ViewportOffset or {
    Enabled = false,
    X = 0, Y = 0, Z = 0,
}

local viewportLoop

local function startViewportLoop()
    if viewportLoop then viewportLoop:Disconnect() end
    viewportLoop = RunService.RenderStepped:Connect(function()
        local cfg = getgenv().ViewportOffset
        if not cfg.Enabled then return end
        if getgenv().InstanceIsMenuOpen and getgenv().InstanceIsMenuOpen() then return end

        local vm = Workspace:FindFirstChild("ViewModels")
        if not vm then return end
        local fp = vm:FindFirstChild("FirstPerson")
        if not fp then return end

        local camera = workspace.CurrentCamera
        if not camera then return end

        local offset = camera.CFrame * CFrame.new(cfg.X, cfg.Y, cfg.Z)
        for _, model in ipairs(fp:GetChildren()) do
            if model:IsA("Model") and model.PrimaryPart then
                pcall(function()
                    model:SetPrimaryPartCFrame(offset)
                end)
            end
        end
    end)
end

local function stopViewportLoop()
    if viewportLoop then
        viewportLoop:Disconnect()
        viewportLoop = nil
    end
end

ViewmodelTab:AddToggle("ViewportOffsetEnabled", {
    Text = "viewport offset",
    Default = false,
    Callback = function(v)
        getgenv().ViewportOffset.Enabled = v
        if v then startViewportLoop() else stopViewportLoop() end
    end
})

ViewmodelTab:AddSlider("ViewportOffsetX", {
    Text = "offset x",
    Default = 0, Min = -10, Max = 10, Rounding = 1, Compact = true,
    Callback = function(v) getgenv().ViewportOffset.X = v end
})

ViewmodelTab:AddSlider("ViewportOffsetY", {
    Text = "offset y",
    Default = 0, Min = -10, Max = 10, Rounding = 1, Compact = true,
    Callback = function(v) getgenv().ViewportOffset.Y = v end
})

ViewmodelTab:AddSlider("ViewportOffsetZ", {
    Text = "offset z",
    Default = 0, Min = -10, Max = 10, Rounding = 1, Compact = true,
    Callback = function(v) getgenv().ViewportOffset.Z = v end
})

shared.AlacrityCosmeticChangerToggle = CosmeticChangerToggle

shared.AlacrityCosmeticChangerToggle = CosmeticChangerToggle

local Unlockbox = Tabs.Visual:AddLeftTabbox()
local UnlockTab = Unlockbox:AddTab("unlock")

UnlockTab:AddToggle("Unlock Skins", {
	Text = "skins",
	Tooltip = "unlock skins",
	Default = false,
	Callback = function(Value)
		getgenv().UnlockerSettings.Skin = Value
	end
})

UnlockTab:AddToggle("Unlock Wraps", {
	Text = "wraps",
	Tooltip = "unlock wraps",
	Default = false,
	Callback = function(Value)
		getgenv().UnlockerSettings.Wrap = Value
	end
})

UnlockTab:AddToggle("Unlock Charms", {
	Text = "charms",
	Tooltip = "unlock charms",
	Default = false,
	Callback = function(Value)
		getgenv().UnlockerSettings.Charm = Value
	end
})

UnlockTab:AddToggle("Unlock Dances", {
	Text = "dances",
	Tooltip = "unlock dances",
	Default = false,
	Callback = function(Value)
		getgenv().UnlockerSettings.Dance = Value
	end
})

UnlockTab:AddToggle("Unlock Emotes", {
	Text = "emotes",
	Tooltip = "unlock emotes",
	Default = false,
	Callback = function(Value)
		getgenv().UnlockerSettings.Emote = Value
	end
})

-- Bullet Tracers
local MarketplaceService = Services.MarketplaceService
local TweenService = Services.TweenService

local cache = {}

getgenv().BulletTracersEnabled = getgenv().BulletTracersEnabled or false
getgenv().BulletTracersColor = getgenv().BulletTracersColor or Color3.fromRGB(255, 255, 255)
getgenv().BulletTracersLifetime = getgenv().BulletTracersLifetime or 1

local function getAnimName(id)
    local animId = tonumber(id and id:match("%d+"))
    if not animId then return "Unknown" end
    if cache[animId] then return cache[animId] end
    local ok, res = pcall(function()
        return MarketplaceService:GetProductInfo(animId)
    end)
    if ok and res and res.Name then
        cache[animId] = res.Name
        return res.Name
    end
    return "Unknown"
end

local function isShoot(name)
    name = string.lower(name)
    return string.find(name, "shoot")
        or string.find(name, "fire")
        or string.find(name, "disparo")
        or string.find(name, "tir")
        or string.find(name, "射")
        or string.find(name, "撃")
        or string.find(name, "발사")
end

local TRACER_STYLES = {
    Line = {
        texture = "",
        width = 0.08,
        textureLength = 1,
        textureSpeed = 0,
        lightEmission = 0.4,
        lightInfluence = 0.6,
        fadeMode = "fade",
    },
    Beam = {
        texture = "rbxassetid://12781852245",
        width = 0.55,
        textureLength = 6,
        textureSpeed = 1.5,
        lightEmission = 0.7,
        lightInfluence = 0.3,
        fadeMode = "fade",
    },
    Lightning = {
        texture = "rbxassetid://446111271",
        width = 0.85,
        textureLength = 10,
        textureSpeed = 3,
        lightEmission = 1,
        lightInfluence = 0,
        fadeMode = "flicker",
    },
    Heartrate = {
        texture = "rbxassetid://5830549480",
        width = 0.75,
        textureLength = 8,
        textureSpeed = 2,
        lightEmission = 0.9,
        lightInfluence = 0.1,
        fadeMode = "fade",
    },
    Chain = {
        texture = "rbxassetid://9632168658",
        width = 0.9,
        textureLength = 5,
        textureSpeed = 1.2,
        lightEmission = 0.6,
        lightInfluence = 0.4,
        fadeMode = "fade",
    },
    Glitch = {
        texture = "rbxassetid://8089467613",
        width = 1.1,
        textureLength = 4,
        textureSpeed = 4,
        lightEmission = 1,
        lightInfluence = 0,
        fadeMode = "flicker",
    },
    Swirl = {
        texture = "rbxassetid://5638168605",
        width = 1.0,
        textureLength = 7,
        textureSpeed = 2.5,
        lightEmission = 0.85,
        lightInfluence = 0.15,
        fadeMode = "fade",
    },
    Neon = {
        texture = "rbxassetid://6361963422",
        width = 0.9,
        textureLength = 6,
        textureSpeed = 1.5,
        lightEmission = 1,
        lightInfluence = 0,
        fadeMode = "fade",
    },
    Plasma = {
        texture = "rbxassetid://8993645509",
        width = 1.2,
        textureLength = 9,
        textureSpeed = 2,
        lightEmission = 1,
        lightInfluence = 0,
        fadeMode = "fade",
    },
    Laser = {
        texture = "rbxassetid://14549123968",
        width = 0.35,
        textureLength = 12,
        textureSpeed = 6,
        lightEmission = 1,
        lightInfluence = 0,
        fadeMode = "fade",
    },
}

getgenv().BulletTracersStyle  = getgenv().BulletTracersStyle  or "Neon"
getgenv().BulletTracersGlow   = getgenv().BulletTracersGlow   or 1.0
getgenv().BulletTracersSizeMult = getgenv().BulletTracersSizeMult or 1.5

local activeTracers = {}

local function createBeamTracer(origin, endPos, color, styleCfg, lifetime)
    local a0 = Instance.new("Attachment")
    a0.Parent = workspace.Terrain
    local a1 = Instance.new("Attachment")
    a1.Parent = workspace.Terrain

    local beam = Instance.new("Beam")
    beam.Attachment0 = a0
    beam.Attachment1 = a1
    beam.Color = ColorSequence.new(color)
    beam.Width0 = styleCfg.width * (getgenv().BulletTracersSizeMult or 1.5)
    beam.Width1 = styleCfg.width * (getgenv().BulletTracersSizeMult or 1.5)
    beam.FaceCamera = true
    beam.LightEmission = styleCfg.lightEmission * (getgenv().BulletTracersGlow or 1.0)
    beam.LightInfluence = styleCfg.lightInfluence
    beam.Segments = 1
    beam.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 0),
    })
    beam.ZOffset = 0

    if styleCfg.texture ~= "" then
        beam.Texture = styleCfg.texture
        beam.TextureMode = Enum.TextureMode.Wrap
        beam.TextureLength = styleCfg.textureLength
        beam.TextureSpeed = styleCfg.textureSpeed
    else
        beam.Texture = ""
        beam.TextureLength = 1
        beam.TextureSpeed = 0
    end

    beam.Parent = workspace.Terrain
    a0.WorldPosition = origin
    a1.WorldPosition = endPos

    local light = Instance.new("PointLight")
    light.Brightness = 1.5 * (getgenv().BulletTracersGlow or 1.0)
    light.Range = 12 * (getgenv().BulletTracersSizeMult or 1.5)
    light.Color = color
    light.Parent = a1

    return {
        Beam = beam,
        Attachment0 = a0,
        Attachment1 = a1,
        Light = light,
        Lifetime = lifetime,
        CreatedAt = tick(),
        FadeMode = styleCfg.fadeMode or "fade",
        BaseWidth = beam.Width0,
        BaseLightEmission = beam.LightEmission,
        BaseBrightness = light.Brightness,
    }
end

local function FireBulletTracers(origin, endPos, lifetime, Color)
    if not origin or not endPos then return end
    local distance = (origin - endPos).Magnitude
    if distance <= 0.01 then return end

    local styleName = getgenv().BulletTracersStyle or "Neon"
    local styleCfg  = TRACER_STYLES[styleName] or TRACER_STYLES.Neon

    local tracer = createBeamTracer(
        origin, endPos,
        Color or Color3.fromRGB(255, 255, 255),
        styleCfg,
        lifetime or 1
    )
    table.insert(activeTracers, tracer)
end

RunService.Heartbeat:Connect(function()
    local now = tick()
    for i = #activeTracers, 1, -1 do
        local t = activeTracers[i]
        if not t or not t.Beam or not t.Beam.Parent then
            table.remove(activeTracers, i)
            continue
        end

        local age   = now - t.CreatedAt
        local life  = t.Lifetime or 1
        local fade  = 0.35
        local startFade = math.max(0, life - fade)

        if age >= life then
            if t.Attachment0 then t.Attachment0:Destroy() end
            if t.Attachment1 then t.Attachment1:Destroy() end
            if t.Light then t.Light:Destroy() end
            if t.Beam then t.Beam:Destroy() end
            table.remove(activeTracers, i)
        else
            local fadeAlpha = 0
            if age >= startFade then
                fadeAlpha = math.clamp((age - startFade) / fade, 0, 1)
            end

            local trans = fadeAlpha
            if t.FadeMode == "flicker" then
                trans = math.clamp(fadeAlpha + (math.random() * 0.15 - 0.075), 0, 1)
            end
            t.Beam.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, trans),
                NumberSequenceKeypoint.new(1, trans),
            })

            local widthScale = 1 - fadeAlpha * 0.5
            t.Beam.Width0 = t.BaseWidth * widthScale
            t.Beam.Width1 = t.BaseWidth * widthScale

            t.Beam.LightEmission = t.BaseLightEmission * (1 - fadeAlpha)
            if t.Light then
                t.Light.Brightness = t.BaseBrightness * (1 - fadeAlpha)
            end
        end
    end
end)

local MELEE_NMS_UI = {
    ["Battle Axe"] = true, ["Chainsaw"] = true, ["Daggers"] = true, ["Fists"] = true,
    ["Gunblade"] = true, ["Katana"] = true, ["Knife"] = true,
    ["Scythe"] = true, ["Trowel"] = true,
}

local function getWeapon()
    local viewModels = workspace:FindFirstChild("ViewModels")
    if not viewModels then return nil end
    local firstPerson = viewModels:FindFirstChild("FirstPerson")
    if not firstPerson then return nil end

    for _, model in ipairs(firstPerson:GetChildren()) do
        if string.find(model.Name, LocalPlayer.Name, 1, true) then
            local parts = {}
            for part in model.Name:gmatch("[^-]+") do
                table.insert(parts, part:match("^%s*(.-)%s*$"))
            end
            if #parts >= 2 then
                return parts[2]
            end
        end
    end
    return nil
end

local function isGunEquipped()
    local weapon = getWeapon()
    if not weapon then return false end
    return MELEE_NMS_UI[weapon] ~= true
end

local function getViewmodelMuzzle()
    local viewModels = workspace:FindFirstChild("ViewModels")
    if not viewModels then return nil end
    local firstPerson = viewModels:FindFirstChild("FirstPerson")
    if not firstPerson then return nil end

    for _, model in ipairs(firstPerson:GetChildren()) do
        if string.find(model.Name, LocalPlayer.Name, 1, true) then
            local itemVisual = model:FindFirstChild("ItemVisual")
            if itemVisual then
                local body = itemVisual:FindFirstChild("Body")
                if body then
                    local bodyPrimary = body:FindFirstChild("BodyPrimary")
                    if bodyPrimary then
                        local muzzle = bodyPrimary:FindFirstChild("_muzzle")
                        if muzzle then
                            if muzzle:IsA("Attachment") then
                                return muzzle.WorldPosition
                            elseif muzzle:IsA("BasePart") then
                                return muzzle.Position
                            end
                        end
                    end
                end
            end
        end
    end
    return nil
end

local function getTracerEndPos(origin)
    local cam = workspace.CurrentCamera
    if not cam then return origin + Vector3.new(0, 0, -1000) end

    local targetPart = getgenv().SilentAimTargetPart
    if getgenv().SilentAim and getgenv().SilentAim.Enabled and targetPart then
        return targetPart.Position
    end

    return cam.CFrame.Position + cam.CFrame.LookVector * 1000
end

-- HitNotify
task.spawn(function()
local HitNotify = {}
HitNotify.__index = HitNotify

local _notifyQueue = {}

task.spawn(function()
    while true do
        local text = table.remove(_notifyQueue, 1)
        if text then
            pcall(function()
                Library:Notify(text)
            end)
        else
            task.wait(0.03)
        end
    end
end)

local DEFAULT_CONFIG = {
    enabled = true,
}

function HitNotify.new(library, config)
    local self = setmetatable({}, HitNotify)

    assert(library and type(library.Notify) == "function",
        "HitNotify.new need Notify's Library")

    self.library = library

    self.config = {}
    for k, v in pairs(DEFAULT_CONFIG) do self.config[k] = v end
    for k, v in pairs(config or {}) do self.config[k] = v end

    self.Enabled = self.config.enabled

    self.formatter = nil
    self.filter    = nil

    self._myObjectId      = nil
    self._objectIdDirty   = true

    self._objectHookInstalled = false
    self._objectHookFailed    = false

    self:_tryInstallObjectHook()

    self._charAddedConn = LocalPlayer.CharacterAdded:Connect(function()
        self._objectIdDirty = true
        self._myObjectId    = nil
    end)

    return self
end

function HitNotify:SetFormatter(fn)
    self.formatter = fn
end

function HitNotify:SetFilter(fn)
    self.filter = fn
end

function HitNotify:MarkShot() end

function HitNotify:NotifyProjectileImpact(hitPart) end

function HitNotify:NotifyManual(targetName, damage, bodyPart)
    if not self.Enabled then return end
    self:_send(targetName, damage, bodyPart or "Body")
end

function HitNotify:_resolveObjectId()
    if not self._objectIdDirty and self._myObjectId ~= nil then
        return self._myObjectId
    end
    self._objectIdDirty = false
    self._myObjectId    = nil

    local ok, fcMod = pcall(function()
        return require(LocalPlayer.PlayerScripts.Controllers.FighterController)
    end)
    if not ok or type(fcMod) ~= "table" then return nil end

    local map = rawget(fcMod, "_player_to_fighter")
    if type(map) ~= "table" then return nil end

    local fighter = map[LocalPlayer]
    if not fighter then return nil end

    local data = rawget(fighter, "Data")
    if type(data) ~= "table" then return nil end

    local oid = rawget(data, "ObjectID")
    if oid == nil then return nil end

    self._myObjectId = oid
    return oid
end

function HitNotify:_tryInstallObjectHook()
    if self._objectHookInstalled or self._objectHookFailed then return end

    local ok, rcMod = pcall(function()
        return require(LocalPlayer.PlayerScripts.Modules.ReplicatedController)
    end)
    if not ok or type(rcMod) ~= "table" then
        self._objectHookFailed = true
        warn("[HitNotify] failed to get ReplicatedController")
        return
    end

    if rawget(rcMod, "__AlacrityHitNotifyHooked") then
        self._objectHookInstalled = true
        self._rcMod = rcMod
        return
    end
    rawset(rcMod, "__AlacrityHitNotifyHooked", true)
    self._rcMod = rcMod

    local original = rawget(rcMod, "_ObjectChanged")
    if type(original) ~= "function" then
        self._objectHookFailed = true
        warn("[HitNotify] _ObjectChanged is not a function")
        return
    end

    local enumOk, enumMod = pcall(function()
        return require(ReplicatedStorage.Modules.EnumLibrary)
    end)
    if not enumOk or type(enumMod) ~= "table" then
        self._objectHookFailed = true
        warn("[HitNotify] failed to get EnumLibrary")
        return
    end

    local fromEnum = rawget(enumMod, "_from_enum")
    if type(fromEnum) ~= "table" then
        self._objectHookFailed = true
        warn("[HitNotify] _from_enum is not a table")
        return
    end

    local HN = self

    rawset(rcMod, "_ObjectChanged", function(self_, objectId, enumByte, ...)
    local enumName = fromEnum[enumByte]
    if enumName == "DamageNumberEffect" then
        local args = table.pack(...)
        local mine = HN:_resolveObjectId()
        if mine ~= nil and tostring(objectId) == tostring(mine) then
            local victimPart  = args[1]
            local damage      = args[2]
            local isHead      = args[3] == true
            local victimModel = victimPart and victimPart.Parent or nil

            if victimModel ~= nil
                and type(damage) == "number"
                and damage > 0 then
                local plr = Players:GetPlayerFromCharacter(victimModel)
                if plr
                    and plr ~= LocalPlayer
                    and not isTeammate(plr) then

                    if HN.Enabled and HN:_shouldNotify(plr) then
                        local part = isHead and "Head" or "Body"
                        HN:_send(plr, damage, part)
                    end

                    if getgenv().HitEffectInstance
                        and getgenv().HitEffectInstance.config.enabled then
                        local part = isHead and "Head" or "Body"
                        getgenv().HitEffectInstance:ShowOnPlayer(plr, damage, part)
                    end
                end
            end
        end
    end
    return original(self_, objectId, enumByte, ...)
end)

    self._objectHookInstalled = true
end

function HitNotify:_shouldNotify(plr)
    if not self.Enabled or plr == LocalPlayer then return false end
    if isTeammate(plr) then return false end
    if self.filter then
        local ok, res = pcall(self.filter, plr)
        if ok and res == false then return false end
    end
    return true
end

function HitNotify:_send(nameOrPlayer, dmg, part)
    local plr = nil
    if typeof(nameOrPlayer) == "Instance" and nameOrPlayer:IsA("Player") then
        plr = nameOrPlayer
    else
        plr = Players:FindFirstChild(tostring(nameOrPlayer))
    end

    if plr then
        if plr == LocalPlayer then return end
        if isTeammate(plr) then return end
    end

    local name = plr and plr.Name or tostring(nameOrPlayer)

    local text
    if self.formatter then
        local ok, res = pcall(self.formatter, name, dmg, part)
        if ok and type(res) == "string" and res ~= "" then
            text = res
        end
    end
    if not text then
        text = string.format("hit %s for %d in the %s",
            name, math.floor(dmg + 0.5), part or "Body")
    end
    
    table.insert(_notifyQueue, text)
end

function HitNotify:Destroy()
    if self._charAddedConn then
        self._charAddedConn:Disconnect()
        self._charAddedConn = nil
    end
end

HN = HitNotify.new(Library)
HN.Enabled = false
getgenv().HitNotifyInstance = HN

HN:SetFormatter(function(name, dmg, part)
    return string.format("hit %s for %d", name, math.floor(dmg + 0.5))
end)

end)
local ok2, err2 = pcall(function()
    local EnumLibrary = require(ReplicatedStorage.Modules.EnumLibrary)
    local startShootEnum = EnumLibrary:ToEnum("StartShooting")

    local oldFireServer
    oldFireServer = hookfunction(
        ReplicatedStorage.Remotes.Replication.Fighter.UseItem.FireServer,
        newcclosure(function(self, objID, enumVal, camdata, extra)
            if enumVal == startShootEnum then
                if getgenv().BulletTracersEnabled and isGunEquipped() then
                    local origin = getViewmodelMuzzle()
                    if origin then
                        local endPos = getTracerEndPos(origin)
                        if endPos then
                            FireBulletTracers(
                                origin,
                                endPos,
                                getgenv().BulletTracersLifetime,
                                getgenv().BulletTracersColor
                            )
                        end
                    end
                end
            end
            return oldFireServer(self, objID, enumVal, camdata, extra)
        end)
    )
end)

if not ok2 then
    warn("BulletTracer hook error: " .. tostring(err2))
end

getgenv().FireBulletTracers = FireBulletTracers
getgenv().GetRageTracerOrigin = function()
    local m = getViewmodelMuzzle()
    if m then return m end
    local rb = getgenv().ragebot
    if rb and rb.config and rb.config.orbit and rb.config.orbit.serverpos then
        return rb.config.orbit.serverpos
    end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    return hrp and (hrp.Position + Vector3.new(0, 2, 0)) or nil
end
getgenv().GetRageTracerEnd = function(origin)
    local rb = getgenv().ragebot
    if rb and rb.config and rb.config.target and rb.config.target.character then
        local head = rb.config.target.character:FindFirstChild("Head")
        if head then return head.Position end
    end
    local cam = workspace.CurrentCamera
    return cam and (cam.CFrame.Position + cam.CFrame.LookVector * 1000) or nil
end

-- Hit Effect
local HitEffect = {}
HitEffect.__index = HitEffect

local DEFAULT_HIT_EFFECT_CONFIG = {
    enabled = false,
    color = Color3.fromRGB(255, 80, 80),
    outlineColor = Color3.fromRGB(0, 0, 0),
    font = Enum.Font.GothamBold,
    textSize = 24,
    lifetime = 0.8,
    riseDistance = 3,
    spread = 0.5,
}

function HitEffect.new(config)
    local self = setmetatable({}, HitEffect)
    self.config = {}
    for k, v in pairs(DEFAULT_HIT_EFFECT_CONFIG) do self.config[k] = v end
    for k, v in pairs(config or {}) do self.config[k] = v end
    self.active = {}
    return self
end

function HitEffect:SetColor(color) self.config.color = color end
function HitEffect:SetOutlineColor(color) self.config.outlineColor = color end
function HitEffect:SetFont(font) self.config.font = font end
function HitEffect:SetTextSize(size) self.config.textSize = size end
function HitEffect:SetLifetime(t) self.config.lifetime = t end
function HitEffect:SetRiseDistance(d) self.config.riseDistance = d end
function HitEffect:SetSpread(s) self.config.spread = s end
function HitEffect:SetEnabled(v) self.config.enabled = v end

function HitEffect:_spawn(worldPosition, amount)
    if not worldPosition then return end
    if not self.config.enabled then return end

    local anchor = Instance.new("Part")
    anchor.Name = "HitEffect_Anchor"
    anchor.Anchored = true
    anchor.CanCollide = false
    anchor.CanQuery = false
    anchor.CanTouch = false
    anchor.Transparency = 1
    anchor.Size = Vector3.new(0.1, 0.1, 0.1)
    anchor.CFrame = CFrame.new(worldPosition)
    anchor.Parent = workspace

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "HitEffect_DamageNumber"
    billboard.Adornee = anchor
    billboard.Size = UDim2.new(0, 120, 0, 40)
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.MaxDistance = 500
    billboard.Parent = anchor

    local angle = math.random() * math.pi * 2
    local spreadDir = Vector3.new(math.cos(angle), 0, math.sin(angle))

    local startOffset = Vector3.new(
        (math.random() - 0.5) * self.config.spread * 0.5,
        math.random(0, 1) * 0.5,
        (math.random() - 0.5) * self.config.spread * 0.5
    )
    billboard.StudsOffsetWorldSpace = startOffset

    local label = Instance.new("TextLabel")
    label.Name = "DamageLabel"
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = self.config.font
    label.Text = tostring(math.floor(amount + 0.5))
    label.TextColor3 = self.config.color
    label.TextStrokeColor3 = self.config.outlineColor
    label.TextStrokeTransparency = 0
    label.TextScaled = false
    label.TextSize = self.config.textSize
    label.TextWrapped = false
    label.Parent = billboard

    local endOffset = startOffset
        + Vector3.new(0, self.config.riseDistance, 0)
        + spreadDir * self.config.spread

    local tweenService = TweenService
    local lifetime = self.config.lifetime

    local riseTime = lifetime * 0.6

    local fadeTime = lifetime - riseTime

    local offsetTween = tweenService:Create(
        billboard,
        TweenInfo.new(riseTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { StudsOffsetWorldSpace = endOffset }
    )
    offsetTween:Play()

    local sizeTween = tweenService:Create(
        label,
        TweenInfo.new(riseTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { TextSize = self.config.textSize * 1.25 }
    )
    sizeTween:Play()

    task.delay(riseTime, function()
        if not label or not label.Parent then return end

        local textTween = tweenService:Create(
            label,
            TweenInfo.new(fadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { TextTransparency = 1, TextStrokeTransparency = 1 }
        )
        textTween:Play()
    end)

    table.insert(self.active, anchor)

    task.delay(lifetime, function()
        if anchor and anchor.Parent then
            anchor:Destroy()
        end
        for i, v in ipairs(self.active) do
            if v == anchor then
                table.remove(self.active, i)
                break
            end
        end
    end)
end

function HitEffect:ShowOnPlayer(plr, amount, bodyPart)
    if not self.config.enabled then return end
    if not plr or not plr.Character then return end
    if plr == LocalPlayer then return end

    if isTeammate(plr) then return end

    local char = plr.Character
    local targetPart = nil

    if bodyPart and bodyPart ~= "Body" then
        local normalized = normalizePartName(bodyPart)
        targetPart = char:FindFirstChild(normalized, true)
            or char:FindFirstChild(bodyPart, true)
    end

    if not targetPart and bodyPart then
        local lower = tostring(bodyPart):lower()
        if lower:find("head", 1, true) then
            targetPart = char:FindFirstChild("Head")
        elseif lower:find("torso", 1, true) or lower:find("body", 1, true) then
            targetPart = char:FindFirstChild("UpperTorso")
                or char:FindFirstChild("Torso")
                or char:FindFirstChild("HumanoidRootPart")
        elseif lower:find("arm", 1, true) then
            targetPart = char:FindFirstChild("LeftUpperArm")
                or char:FindFirstChild("RightUpperArm")
                or char:FindFirstChild("Torso")
        elseif lower:find("leg", 1, true) then
            targetPart = char:FindFirstChild("LeftUpperLeg")
                or char:FindFirstChild("RightUpperLeg")
                or char:FindFirstChild("Torso")
        end
    end

    if not targetPart then
        targetPart = char:FindFirstChild("Head")
            or char:FindFirstChild("UpperTorso")
            or char:FindFirstChild("Torso")
            or char:FindFirstChild("HumanoidRootPart")
    end

    if targetPart and targetPart:IsA("BasePart") then
        self:_spawn(targetPart.Position, amount)
    end
end

function HitEffect:ClearAll()
    for _, gui in ipairs(self.active) do
        if gui and gui.Parent then
            gui:Destroy()
        end
    end
    self.active = {}
end

local HE = HitEffect.new()
getgenv().HitEffectInstance = HE

local originalSend = HN._send
HN._send = function(self, nameOrPlayer, dmg, part)
    originalSend(self, nameOrPlayer, dmg, part)

    local plr
    if typeof(nameOrPlayer) == "Instance" and nameOrPlayer:IsA("Player") then
        plr = nameOrPlayer
    else
        plr = Players:FindFirstChild(tostring(nameOrPlayer))
    end

    if plr
        and plr ~= LocalPlayer
        and plr.Character
        and not isTeammate(plr) then
        HE:ShowOnPlayer(plr, dmg, part)
    end
end

-- Hit Sounds
local HitSoundsBox = Tabs.Visual:AddRightTabbox()
local HitEffectTab = HitSoundsBox:AddTab("hit effects")
local HitSoundsTab = HitSoundsBox:AddTab("hit sounds")

HitEffectTab:AddToggle("HitEffectEnabled", {
    Text = "enable",
    Default = false,
    Tooltip = "show damage numbers when you hit someone",
    Callback = function(Value)
        HE:SetEnabled(Value)
        if not Value then
            HE:ClearAll()
        end
    end,
}):AddColorPicker("HitEffectColor", {
    Default = Color3.fromRGB(255, 80, 80),
    Title = "damage number color",
    Callback = function(Value)
        HE:SetColor(Value)
    end,
}):AddColorPicker("HitEffectOutlineColor", {
    Default = Color3.fromRGB(0, 0, 0),
    Title = "outline color",
    Callback = function(Value)
        HE:SetOutlineColor(Value)
    end,
})

HitEffectTab:AddDropdown("HitEffectFont", {
    Text = "font",
    Default = "GothamBold",
    Values = {
        "GothamBold", "Gotham", "GothamBlack", "Arial", "ArialBold",
        "SourceSansBold", "SourceSans", "Cartoon", "Code", "Fantasy",
        "SciFi", "Arcade", "Bodoni", "Garamond", "Highway",
        "IndieFlower", "Jura", "Kalam", "LuckiestGuy", "Merriweather",
        "Michroma", "Nunito", "Oswald", "PatrickHand", "PermanentMarker",
        "Roboto", "RobotoCondensed", "RobotoMono", "Sarpanch", "SpecialElite", "Ubuntu",
    },
    Callback = function(Value)
        local ok, font = pcall(function()
            return Enum.Font[Value]
        end)
        if ok and font then
            HE:SetFont(font)
        end
    end,
})

HitEffectTab:AddSlider("HitEffectTextSize", {
    Text = "text size",
    Default = 24,
    Min = 10,
    Max = 60,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        HE:SetTextSize(Value)
    end,
})

HitEffectTab:AddSlider("HitEffectLifetime", {
    Text = "lifetime",
    Default = 0.8,
    Min = 0.2,
    Max = 10,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        HE:SetLifetime(Value)
    end,
})

HitEffectTab:AddSlider("HitEffectSpread", {
    Text = "spread",
    Default = 0,
    Min = 0,
    Max = 20,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        HE:SetSpread(Value)
    end,
})

HitEffectTab:AddSlider("HitEffectRise", {
    Text = "rise distance",
    Default = 3,
    Min = 0.5,
    Max = 20,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        HE:SetRiseDistance(Value)
    end,
})

VisualState = VisualState or {}
VisualState.DamageIndicatorHooked = VisualState.DamageIndicatorHooked or false
VisualState.Hooked = VisualState.Hooked or false
VisualState.DamageNumberHooked = VisualState.DamageNumberHooked or false
VisualState.LastHitTime = VisualState.LastHitTime or 0
VisualState.LastIndicatorHitTime = VisualState.LastIndicatorHitTime or 0

function safeTableGet(tab, key)
    if typeof(tab) ~= "table" then return nil end
    local ok, v = pcall(rawget, tab, key)
    return ok and v or nil
end

local function getHookTarget(module, methodName, seen)
    if type(module) ~= "table" then return nil, nil end
    seen = seen or {}
    if seen[module] then return nil, nil end
    seen[module] = true

    if type(rawget(module, methodName)) == "function" then
        return module, rawget(module, methodName)
    end

    local mt = getmetatable(module)
    if type(mt) == "table" and not seen[mt] then
        if type(rawget(mt, methodName)) == "function" then
            return mt, rawget(mt, methodName)
        end
        local index = rawget(mt, "__index")
        if type(index) == "table" and not seen[index] then
            if type(rawget(index, methodName)) == "function" then
                return index, rawget(index, methodName)
            end
            local target, func = getHookTarget(index, methodName, seen)
            if target then return target, func end
        end
    end

    return nil, nil
end

local installDamageIndicatorHook
local installHitHook

DisableHitMarker = HitEffectTab:AddToggle("DisableHitMarker", {
    Text = "disable hit marker",
    Default = false,
    Callback = function(Value)
        if Value and type(installHitHook) == "function" then
            pcall(installHitHook)
        end
    end,
})

DisableDamageNumbers = HitEffectTab:AddToggle("DisableDamageNumbers", {
    Text = "disable damage numbers",
    Default = false,
    Callback = function(Value)
        if Value and type(installDamageIndicatorHook) == "function" then
            pcall(installDamageIndicatorHook)
        end
        if Value and type(installHitHook) == "function" then
            pcall(installHitHook)
        end
    end,
})

installDamageIndicatorHook = function()
    if VisualState.DamageIndicatorHooked then return end
    local ok, damageIndicators = pcall(function()
        return require(LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.FighterInterface.DamageIndicators)
    end)
    if not ok or type(damageIndicators) ~= "table" then return end

    local target, oldFunc = getHookTarget(damageIndicators, "Create")
    if not target or type(oldFunc) ~= "function" then
        if type(damageIndicators.Create) == "function" then
            target = damageIndicators
            oldFunc = damageIndicators.Create
        else
            return
        end
    end

    VisualState.OriginalDamageIndicatorCreate = VisualState.OriginalDamageIndicatorCreate or oldFunc
    local original = VisualState.OriginalDamageIndicatorCreate

    target.Create = function(self, ...)
        if DisableDamageNumbers and DisableDamageNumbers.Value then
            return
        end
        return original(self, ...)
    end
    VisualState.DamageIndicatorHooked = true
end

installHitHook = function()
    if VisualState.HitHooked_v2 then return end
    VisualState.HitHooked_v2 = true

    pcall(function()
        local fighterController = require(LocalPlayer.PlayerScripts.Controllers.FighterController)
        local fighter = fighterController.LocalFighter or fighterController:GetFighter(LocalPlayer)
        local fighterClass = fighter and getmetatable(fighter)
        fighterClass = fighterClass and fighterClass.__index
        if type(fighterClass) ~= "table" or type(fighterClass._DamageNumberEffect) ~= "function" then return end

        VisualState.OriginalDamageNumberEffect = VisualState.OriginalDamageNumberEffect or fighterClass._DamageNumberEffect
        local original = VisualState.OriginalDamageNumberEffect

        fighterClass._DamageNumberEffect = function(a, b, c, d, e)
            if DisableDamageNumbers and DisableDamageNumbers.Value then
                return
            end
            return original(a, b, c, d, e)
        end
        VisualState.DamageNumberHooked = true
    end)

    pcall(function()
        local DI = require(LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.FighterInterface.DamageIndicators)
        local old = DI.Create
        if type(old) ~= "function" then return end

        VisualState.OriginalDamageIndicatorCreate = VisualState.OriginalDamageIndicatorCreate or old
        local original = VisualState.OriginalDamageIndicatorCreate

        DI.Create = function(self, ...)
            if DisableHitMarker and DisableHitMarker.Value then
                return
            end
            return original(self, ...)
        end
        VisualState.DamageIndicatorHooked = true
    end)
end

getgenv().installDamageIndicatorHook = installDamageIndicatorHook
getgenv().installHitHook = installHitHook

local Sounds = {
    ["Rust HS"]           = "rbxassetid://5043539486",
    ["Neverlose"]         = "rbxassetid://97643101798871",
    ["Minecraft Bow"]     = "rbxassetid://3442683707",
    ["Minecraft Hit"]     = "rbxassetid://8766809464",
    ["CSGO"]              = "rbxassetid://5764885315",
    ["Bubble"]            = "rbxassetid://6534947588",
    ["Lazer"]             = "rbxassetid://130791043",
    ["Pick"]              = "rbxassetid://1347140027",
    ["Pop"]               = "rbxassetid://198598793",
    ["Rust"]              = "rbxassetid://1255040462",
    ["Sans"]              = "rbxassetid://3188795283",
    ["Fart"]              = "rbxassetid://130833677",
    ["Big"]               = "rbxassetid://5332005053",
    ["Vine"]              = "rbxassetid://5332680810",
    ["UwU"]               = "rbxassetid://8679659744",
    ["Bruh"]              = "rbxassetid://4578740568",
    ["Skeet"]             = "rbxassetid://5633695679",
    ["Fatality"]          = "rbxassetid://6534947869",
    ["Bonk"]              = "rbxassetid://5766898159",
    ["Minecraft"]         = "rbxassetid://5869422451",
    ["Gamesense"]         = "rbxassetid://4817809188",
    ["RIFK7"]             = "rbxassetid://9102080552",
    ["Bamboo"]            = "rbxassetid://3769434519",
    ["Crowbar"]           = "rbxassetid://546410481",
    ["Weeb"]              = "rbxassetid://6442965016",
    ["Beep"]              = "rbxassetid://8177256015",
    ["Bambi"]             = "rbxassetid://8437203821",
    ["Stone"]             = "rbxassetid://3581383408",
    ["Old Fatality"]      = "rbxassetid://6607142036",
    ["Click"]             = "rbxassetid://8053704437",
    ["Ding"]              = "rbxassetid://7149516994",
    ["Snow"]              = "rbxassetid://6455527632",
    ["Laser"]             = "rbxassetid://7837461331",
    ["Mario"]             = "rbxassetid://2815207981",
    ["Steve"]             = "rbxassetid://4965083997",
    ["Call of Duty"]      = "rbxassetid://5952120301",
    ["Bat"]               = "rbxassetid://3333907347",
    ["TF2 Critical"]      = "rbxassetid://296102734",
    ["Saber"]             = "rbxassetid://8415678813",
    ["Baimware"]          = "rbxassetid://3124331820",
    ["Osu"]               = "rbxassetid://7149255551",
    ["TF2"]               = "rbxassetid://2868331684",
    ["Slime"]             = "rbxassetid://6916371803",
    ["Among Us"]          = "rbxassetid://5700183626",
    ["One"]               = "rbxassetid://7380502345",
    ["Soft Bell"]         = "rbxassetid://9114487369",
    ["Minecraft Bow Hit"] = "rbxassetid://1053296915",
    ["Star"]              = "https://www.myinstants.com/media/sounds/starshitsound.mp3",
    ["Minecraft XP"]      = "rbxassetid://6647877129",
    ["Windows Error"]     = "rbxassetid://9066167010",
    ["pan"]               = "rbxassetid://7109756845",
    ["slap"]              = "rbxassetid://8907573127",
    ["oof"]               = "rbxassetid://79348298352567",
    ["quack"]             = "rbxassetid://2101511513",
    ["get out"]           = "rbxassetid://17573042535",
    ["E"]                 = "rbxassetid://2168246346",
    ["Undertale slash"]   = "rbxassetid://623904185",
}

local SOUND_FOLDER = "Alacrity"
local SOUND_DIR    = SOUND_FOLDER .. "/sounds"

local function isExternal(id)
    return type(id) == "string" and id:match("^https?://") ~= nil
end

local function safeFileName(name)
    return (name:gsub("[^%w%-_ ]", ""):gsub("%s+", "_")) .. ".mp3"
end

if isfolder and makefolder then
    if not isfolder(SOUND_FOLDER) then makefolder(SOUND_FOLDER) end
    if not isfolder(SOUND_DIR)    then makefolder(SOUND_DIR)    end
end

local assetCache = {}

local function resolveSoundId(name)
    local raw = Sounds[name]
    if not raw then return nil end

    if not isExternal(raw) then
        return raw
    end

    if assetCache[name] then
        return assetCache[name]
    end

    if not (isfile and writefile and (getsynasset or getcustomasset)) then
        warn("[HitSounds] ur executor doesn't support writefile / getcustomasset")
        return nil
    end

    local path = SOUND_DIR .. "/" .. safeFileName(name)

    if not isfile(path) then
        local ok, data = pcall(function()
            return game:HttpGet(raw, true)
        end)
        if not ok or type(data) ~= "string" or #data < 128 then
            warn("[HitSounds] download failed: " .. name)
            return nil
        end
        writefile(path, data)
    end

    local assetFn = getsynasset or getcustomasset
    local ok2, asset = pcall(assetFn, path)
    if not ok2 or not asset then
        warn("[HitSounds] getcustomasset failed: " .. name)
        return nil
    end

    assetCache[name] = asset
    return asset
end

task.spawn(function()
    for name, id in pairs(Sounds) do
        if isExternal(id) then
            pcall(resolveSoundId, name)
            task.wait(0.4)
        end
    end
end)

local soundNames = {}
for name in pairs(Sounds) do
    table.insert(soundNames, name)
end
table.sort(soundNames)

local soundtochange = "Rust"

getgenv().Volume          = getgenv().Volume or 5
getgenv().HitSoundActive  = getgenv().HitSoundActive or false
getgenv().HitSoundConnection = getgenv().HitSoundConnection or nil

HitSoundsTab:AddToggle("HitSoundsToggle", {
    Text = "enable",
    Default = false,
    Tooltip = "changes the hit sound dynamically",
    Callback = function(Value)
        getgenv().HitSoundActive = Value

        if getgenv().HitSoundConnection then
            getgenv().HitSoundConnection:Disconnect()
            getgenv().HitSoundConnection = nil
        end

                       if Value then
            getgenv().HitSound = resolveSoundId(soundtochange)

            local ok, viewModel = pcall(function()
                return game:GetService("Players").LocalPlayer.PlayerScripts
                    .Modules.ClientReplicatedClasses.ClientFighter.ClientItem.ClientViewModel
            end)

            if not ok or not viewModel then
                warn("[HitSounds] ClientViewModel not found")
                return
            end

            getgenv().HitSoundConnection = viewModel.ChildAdded:Connect(function(v)
                if not getgenv().HitSoundActive then return end
                if not v:IsA("Sound") then return end
                if v.SoundId == "rbxassetid://16537449730" then return end

                local id = resolveSoundId(soundtochange)
                if not id then return end

                v.SoundId = id
                v.Pitch   = 1
                v.Volume  = getgenv().Volume
            end)
        end
    end,
})

HitSoundsTab:AddDropdown("SoundsType", {
    Values = soundNames,
    Default = "Rust",
    Multi = false,
    Text = "sounds",
    Tooltip = "type of sound you want to use on guns",
    Callback = function(Value)
        soundtochange = Value
        getgenv().HitSound = resolveSoundId(Value)
    end,
})

HitSoundsTab:AddSlider("Hit Sounds Volume", {
    Text = "volume",
    Default = 5,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Compact = true,
    Tooltip = "volume of the hit sound",
    Callback = function(Value)
        getgenv().Volume = Value
    end,
})

local BulletTracersBox = Tabs.Visual:AddRightTabbox()
local BulletTracersTab = BulletTracersBox:AddTab("bullet tracers")
local CrosshairTab = BulletTracersBox:AddTab("crosshair")

local BulletTracersEnable = BulletTracersTab:AddToggle("Enable_BulletTracers", {
    Text = "enable",
    Default = false,
    Callback = function(Value)
        getgenv().BulletTracersEnabled = Value
    end,
})

local BulletTracersLifeTimeSlider = BulletTracersTab:AddSlider("BulletTracers_Lifetime", {
    Text = "tracer lifetime",
    Default = 1,
    Min = 0.1,
    Max = 5,
    Rounding = 1,
    Compact = false,
    Tooltip = "how long the bullet tracers stay visible",
    Callback = function(Value)
        getgenv().BulletTracersLifetime = Value
    end
})

BulletTracersTab:AddDropdown("BulletTracersStyle", {
    Text = "tracer style",
    Values = {"Line", "Beam", "Lightning", "Heartrate", "Chain", "Glitch", "Swirl", "Neon", "Plasma", "Laser"},
    Default = "Neon",
    Callback = function(v)
        getgenv().BulletTracersStyle = v
    end,
})

BulletTracersTab:AddSlider("BulletTracersGlow", {
    Text = "glow",
    Default = 0.8, Min = 0, Max = 1, Rounding = 2, Compact = true,
    Callback = function(v) getgenv().BulletTracersGlow = v end,
})

BulletTracersEnable:AddColorPicker("TracersColorPicker", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "tracer color",
    Callback = function(Value)
        getgenv().BulletTracersColor = Value
    end
})

local CrosshairDrawings = {}
local CrosshairState = {
    Enabled = false,
    Outline = false,
    DisableGameCrosshair = false,
    Position = "-",
    Color = Color3.fromRGB(255, 255, 255),
    OutlineColor = Color3.fromRGB(0, 0, 0),
    Rotation = 0,
    Speed = 0,
    Bounce = 0,
    SpeedMult = 1,
    Offset = 5,
    Length = 20,
    Thickness = 2,
    GameCrosshairDisabled = false,
    OriginalCrosshairEnabled = nil,
}

local HAS_DRAWING = (typeof(Drawing) == "table" and type(Drawing.new) == "function")
if not HAS_DRAWING then
    warn("[Crosshair] Drawing library not available in this executor - crosshair disabled")
end

local function makeLine(key)
    if not HAS_DRAWING then return nil end
    local line = CrosshairDrawings[key]
    if not line then
        local ok, obj = pcall(function() return Drawing.new("Line") end)
        if ok and obj then
            CrosshairDrawings[key] = obj
            line = obj
        end
    end
    return line
end

local function hideAllLines()
    for _, obj in pairs(CrosshairDrawings) do
        pcall(function() obj.Visible = false end)
    end
end

local function getClosestTargetPart()
    local cam = workspace.CurrentCamera
    if not cam then return nil end
    local center = cam.ViewportSize / 2
    local best, bestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            local hum  = plr.Character:FindFirstChildOfClass("Humanoid")
            if head and hum and hum.Health > 0 then
                local pos, onScreen = cam:WorldToViewportPoint(head.Position)
                if onScreen == true and pos.Z > 0 then
                    local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if d < bestDist then best, bestDist = head, d end
                end
            end
        end
    end
    return best
end

local function getMuzzleWorld()
    local vm = workspace:FindFirstChild("ViewModels")
    local fp = vm and vm:FindFirstChild("FirstPerson")
    if not fp then return nil end
    for _, model in ipairs(fp:GetChildren()) do
        if model.Name:find(LocalPlayer.Name, 1, true) then
            local part = model:FindFirstChild("_muzzle", true) or model:FindFirstChild("Muzzle", true)
            if part and part:IsA("Attachment") then return part.WorldPosition end
            if part and part:IsA("BasePart")    then return part.Position     end
        end
    end
    return nil
end

CrosshairTab:AddToggle("ch_enabled", {
    Text = "enabled",
    Default = false,
    Callback = function(v)
        CrosshairState.Enabled = v
        if not v then hideAllLines() end
    end,
})

CrosshairTab:AddToggle("ch_outline", {
    Text = "outline",
    Default = false,
    Callback = function(v) CrosshairState.Outline = v end,
})

CrosshairTab:AddLabel("color"):AddColorPicker("ch_color", {
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(v) CrosshairState.Color = v end,
})

CrosshairTab:AddLabel("outline color"):AddColorPicker("ch_outline_color", {
    Default = Color3.fromRGB(0, 0, 0),
    Callback = function(v) CrosshairState.OutlineColor = v end,
})

CrosshairTab:AddSlider("ch_rotation", {
    Text = "rotation", Min = 0, Max = 360, Default = 0, Rounding = 0, Suffix = "deg",
    Callback = function(v) CrosshairState.Rotation = v end,
})
CrosshairTab:AddSlider("ch_speed", {
    Text = "speed", Min = 0, Max = 5, Default = 0, Rounding = 2, Suffix = "rps",
    Callback = function(v) CrosshairState.Speed = v end,
})
CrosshairTab:AddSlider("ch_bounce", {
    Text = "bounce", Min = 0, Max = 50, Default = 0, Rounding = 0, Suffix = "px",
    Callback = function(v) CrosshairState.Bounce = v end,
})
CrosshairTab:AddSlider("ch_speedmult", {
    Text = "speed", Min = 0.1, Max = 5, Default = 1, Rounding = 2, Suffix = "x",
    Callback = function(v) CrosshairState.SpeedMult = v end,
})
CrosshairTab:AddSlider("ch_offset", {
    Text = "offset", Min = 0, Max = 50, Default = 5, Rounding = 0, Suffix = "px",
    Callback = function(v) CrosshairState.Offset = v end,
})
CrosshairTab:AddSlider("ch_length", {
    Text = "length", Min = 1, Max = 80, Default = 20, Rounding = 0, Suffix = "px",
    Callback = function(v) CrosshairState.Length = v end,
})
CrosshairTab:AddSlider("ch_thickness", {
    Text = "thickness", Min = 1, Max = 10, Default = 2, Rounding = 0, Suffix = "px",
    Callback = function(v) CrosshairState.Thickness = v end,
})
CrosshairTab:AddDropdown("ch_position", {
    Text = "position",
    Values = {"-", "position on target", "position on barrel"},
    Default = 1,
    Callback = function(v)
        if type(v) == "table" then
            CrosshairState.Position = v[1] or "-"
        else
            CrosshairState.Position = v or "-"
        end
    end,
})
task.defer(function()
local GameCrosshair = {
    Disabled = false,
    Tracked = {},
    TrackedList = {},
    ScanConn = nil,
    LastScan = 0,
    ScanInterval = 2.0,
    PlayerGuiConn = nil,
    CoreGuiConn = nil,
    PlayerGui = nil,
}

local CROSSHAIR_KEYWORDS = { "crosshair", "reticle", "hitmarker" }
local function nameLooksLikeCrosshair(n)
    if type(n) ~= "string" or n == "" then return false end
    local lower = n:lower()
    for _, kw in ipairs(CROSSHAIR_KEYWORDS) do
        if lower:find(kw, 1, true) then return true end
    end
    return false
end

local function isCrosshairLeaf(obj)
    if not obj or not obj.Parent then return false end
    if not obj:IsA("GuiObject") then return false end
    if not nameLooksLikeCrosshair(obj.Name) then return false end
    local sz = obj.AbsoluteSize
    if sz.X > 200 or sz.Y > 200 then return false end
    local childCount = 0
    for _, c in ipairs(obj:GetChildren()) do
        if c:IsA("GuiObject") then
            childCount = childCount + 1
            if childCount > 3 then return false end
        end
    end
    return true
end

local function trackObject(obj)
    if GameCrosshair.Tracked[obj] then return end
    local entry = { Visible = obj.Visible, Conn = nil }
    entry.Conn = obj:GetPropertyChangedSignal("Visible"):Connect(function()
        if GameCrosshair.Disabled and obj.Visible then
            obj.Visible = false
        end
    end)
    GameCrosshair.Tracked[obj] = entry
    table.insert(GameCrosshair.TrackedList, obj)
end

local function forceDisableOne(obj)
    if obj and obj.Parent and obj.Visible then
        pcall(function() obj.Visible = false end)
    end
end

local function restoreOne(obj)
    local entry = GameCrosshair.Tracked[obj]
    if not entry or not obj or not obj.Parent then return end
    if entry.Conn then
        pcall(function() entry.Conn:Disconnect() end)
        entry.Conn = nil
    end
    if entry.Visible ~= nil then
        pcall(function() obj.Visible = entry.Visible end)
    end
end

local function getScanRoots()
    local roots = {}
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then table.insert(roots, pg) end
    pcall(function()
        local cg = game:GetService("CoreGui")
        if cg then table.insert(roots, cg) end
    end)
    pcall(function()
        local hui = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui())
        if hui then table.insert(roots, hui) end
    end)
    return roots
end

local function fullScan()
    for _, root in ipairs(getScanRoots()) do
        local ok, desc = pcall(function() return root:GetDescendants() end)
        if ok and desc then
            for _, obj in ipairs(desc) do
                if isCrosshairLeaf(obj) then
                    trackObject(obj)
                    if GameCrosshair.Disabled then
                        forceDisableOne(obj)
                    end
                end
            end
        end
    end
end

local function startScanLoop()
    if GameCrosshair.ScanConn then return end
    GameCrosshair.ScanConn = RunService.Heartbeat:Connect(function()
        if not GameCrosshair.Disabled then return end
        local now = os.clock()
        if now - GameCrosshair.LastScan < GameCrosshair.ScanInterval then return end
        GameCrosshair.LastScan = now
        fullScan()
    end)
end

local function ensureListener()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg and (GameCrosshair.PlayerGui ~= pg or not GameCrosshair.PlayerGuiConn) then
        if GameCrosshair.PlayerGuiConn then
            pcall(function() GameCrosshair.PlayerGuiConn:Disconnect() end)
        end
        GameCrosshair.PlayerGui = pg
        GameCrosshair.PlayerGuiConn = pg.DescendantAdded:Connect(function(obj)
            if not GameCrosshair.Disabled then return end
            if isCrosshairLeaf(obj) then
                trackObject(obj)
                forceDisableOne(obj)
            end
        end)
    end
    pcall(function()
        local cg = game:GetService("CoreGui")
        if cg and not GameCrosshair.CoreGuiConn then
            GameCrosshair.CoreGuiConn = cg.DescendantAdded:Connect(function(obj)
                if not GameCrosshair.Disabled then return end
                if isCrosshairLeaf(obj) then
                    trackObject(obj)
                    forceDisableOne(obj)
                end
            end)
        end
    end)
end

local function setGameCrosshairDisabled(disabled)
    GameCrosshair.Disabled = disabled == true
    ensureListener()

    if GameCrosshair.Disabled then
        startScanLoop()
        fullScan()
        for _, obj in ipairs(GameCrosshair.TrackedList) do
            forceDisableOne(obj)
        end
    else
        if GameCrosshair.ScanConn then
            GameCrosshair.ScanConn:Disconnect()
            GameCrosshair.ScanConn = nil
        end
        for _, obj in ipairs(GameCrosshair.TrackedList) do
            restoreOne(obj)
        end
        GameCrosshair.Tracked = {}
        GameCrosshair.TrackedList = {}
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.defer(function()
        task.wait(0.6)
        ensureListener()
        if GameCrosshair.Disabled then
            fullScan()
            for _, obj in ipairs(GameCrosshair.TrackedList) do
                forceDisableOne(obj)
            end
        end
    end)
end)

CrosshairTab:AddToggle("ch_disable_game", {
    Text = "disable game crosshair",
    Default = false,
    Callback = function(v)
        CrosshairState.DisableGameCrosshair = v
        setGameCrosshairDisabled(v)
    end,
})

local function updateCrosshair()
    if not HAS_DRAWING then return end

    if not CrosshairState.Enabled then
        hideAllLines()
        return
    end

    local cam = workspace.CurrentCamera
    if not cam then
        hideAllLines()
        return
    end

    local center = cam.ViewportSize / 2

    if CrosshairState.Position == "position on target" then
        local part = getClosestTargetPart()
        if part then
            local pos, onScreen = cam:WorldToViewportPoint(part.Position)
            if onScreen == true and pos.Z > 0 then
                center = Vector2.new(pos.X, pos.Y)
            end
        end
    elseif CrosshairState.Position == "position on barrel" then
        local m = getMuzzleWorld()
        if m then
            local pos, onScreen = cam:WorldToViewportPoint(m)
            if onScreen == true and pos.Z > 0 then
                center = Vector2.new(pos.X, pos.Y)
            end
        end
    end

    local length    = CrosshairState.Length
    local gap       = CrosshairState.Offset
    local thickness = CrosshairState.Thickness
    local baseRot   = CrosshairState.Rotation
    local spd       = CrosshairState.Speed
    local bounce    = CrosshairState.Bounce
    local mult      = CrosshairState.SpeedMult

    local rot = math.rad(baseRot) + (tick() * math.pi * 2 * spd) % (math.pi * 2)

    if bounce > 0 then
        gap = gap + math.sin(tick() * 8 * mult) * bounce
    end
    if gap < 0 then gap = 0 end

    local dirs = {
        Vector2.new(0, -1),
        Vector2.new(1, 0),
        Vector2.new(0, 1),
        Vector2.new(-1, 0),
    }

    for i, dir in ipairs(dirs) do
        local rdir = Vector2.new(
            dir.X * math.cos(rot) - dir.Y * math.sin(rot),
            dir.X * math.sin(rot) + dir.Y * math.cos(rot)
        )
        local from = center + rdir * gap
        local to   = center + rdir * (gap + length)

        local outline = makeLine("outline" .. i)
        if outline then
            if CrosshairState.Outline then
                outline.From         = from
                outline.To           = to
                outline.Color        = CrosshairState.OutlineColor
                outline.Thickness    = thickness + 2
                outline.Transparency = 1
                outline.Visible      = true
            else
                outline.Visible = false
            end
        end

        local line = makeLine("line" .. i)
        if line then
            line.From         = from
            line.To           = to
            line.Color        = CrosshairState.Color
            line.Thickness    = thickness
            line.Transparency = 1
            line.Visible      = true
        end
    end
end

RunService.RenderStepped:Connect(function()
    pcall(updateCrosshair)
end)
end)
end
do
-- Movement UI
local MovementBox = Tabs.Movement:AddLeftTabbox()
local MovementSpeed = MovementBox:AddTab("movement")

MovementSpeed:AddToggle("WalkSpeed", {
    Text = "velocity",
    Tooltip = "enable speed",
    Default = false,
    Callback = function(Value)
        getgenv().WalkSpeed.Enabled = Value
    end
}):AddKeyPicker("velocityKey", {
    Text = "velocity",
    Default = "None",
    Mode = "Toggle",
    SyncToggleState = true
})

MovementSpeed:AddSlider("Speed of WalkSpeed", {
    Text = "value",
    Tooltip = "speed of the walkspeed",
    Default = 1,
    Min = 1,
    Max = 1000,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
        getgenv().WalkSpeed.Speed = Value
    end
})

MovementSpeed:AddToggle("SlideBoost", {
    Text = "slide boost",
    Tooltip = "enable slide boost",
    Default = false,
    Callback = function(Value)
        getgenv().SlideBoost.Enabled = Value
    end
}):AddKeyPicker("slideboostKey", {
    Text = "slide boost",
    Default = "None",
    Mode = "Toggle",
    SyncToggleState = true
})

MovementSpeed:AddSlider("Speed of SlideBoost", {
    Text = "value",
    Tooltip = "speed of the slideboost",
    Default = 100,
    Min = 1,
    Max = 500,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
        getgenv().SlideBoost.Speed = Value
    end
})

MovementSpeed:AddToggle("Inf Jump", {
    Text = "infinite jump",
    Tooltip = "enable infinite jump",
    Default = false,
    Callback = function(Value)
        getgenv().InfiniteJump = Value
    end
}):AddKeyPicker("infjumpKey", {
    Text = "infinite jump",
    Default = "None",
    Mode = "Toggle",
    SyncToggleState = true
})

local CharacterBox = Tabs.Movement:AddRightTabbox()
local MovementCharacter = CharacterBox:AddTab("character")

MovementCharacter:AddToggle("No Clip", {
    Text = "noclip",
    Tooltip = "enable no clip",
    Default = false,
    Callback = function(Value)
        getgenv().Noclip = Value
    end
}):AddKeyPicker("noclipKey", {
    Text = "noclip",
    Default = "None",
    Mode = "Toggle",
    SyncToggleState = true
})

MovementCharacter:AddToggle("Fly", {
    Text = "fly",
    Tooltip = "enable fly",
    Default = false,
    Callback = function(Value)
        Fly.flying = Value
        if Fly.flying then
            EnableFlying()
        else
            DisableFlying()
        end
    end
}):AddKeyPicker("flyKey", {
    Text = "fly",
    Default = "None",
    Mode = "Toggle",
    SyncToggleState = true
})

MovementCharacter:AddSlider("Speed of Fly", {
    Text = "value",
    Tooltip = "speed of the fly",
    Default = 100,
    Min = 1,
    Max = 1000,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
        Fly.flyspeed = Value
    end
})

MovementCharacter:AddToggle("Spin", {
    Text = "spin bot",
    Tooltip = "enable spin",
    Default = false,
    Callback = function(Value)
        getgenv().Spin.Enabled = Value
    end
}):AddKeyPicker("spinKey", {
    Text = "spin bot",
    Default = "None",
    Mode = "Toggle",
    SyncToggleState = true
})

MovementCharacter:AddSlider("Speed of Spin", {
    Text = "value",
    Tooltip = "speed of the spin",
    Default = 5,
    Min = 1,
    Max = 50,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
        getgenv().Spin.Speed = Value
    end
})

local ThirdBox = Tabs.Movement:AddRightTabbox()
local ThirdTab = ThirdBox:AddTab("third person")

ThirdTab:AddToggle("ThirdEnable", {
    Text = "enable",
    Tooltip = "enable or disable the third person",
    Default = false,
    Callback = function(Value)
        ThirdPersonSetEnabled(Value)
    end
}):AddKeyPicker("thirdpersonKey", {
    Text = "third person",
    Default = "None",
    Mode = "Toggle",
    SyncToggleState = true
})

local AnimationBox = Tabs.Movement:AddRightTabbox()
local AnimationTab = AnimationBox:AddTab("animation")

AnimationTab:AddToggle("PlayAnimation", {
    Text = "enable",
    Tooltip = "loop selected animation",
    Default = false,
    Callback = function(Value)
        AnimationSystem:SetEnabled(Value)
    end
}):AddKeyPicker("animationKey", {
    Text = "animation",
    Default = "None",
    Mode = "Toggle",
    SyncToggleState = true
})

AnimationTab:AddDropdown("AnimationsType", {
    Text = "animations",
    Tooltip = "type of animations you want to play",
    Values = {
        "Agree", "Coo Coo", "Cream Cheese Honey", "Criss Cross", "Denial",
        "Facepalm", "Kneel", "Off of You", "ROFL", "Round & Round",
        "Shivering", "Shoulder Brush", "Side To Side", "Smile",
        "Snow Angels", "Superhero", "Take The L", "Think", "Vegetable"
    },
    Default = 1,
    Callback = function(Value)
        Config.Animation = Value
        if AnimationSystem.Enabled then
            AnimationSystem:PlayCurrent()
        end
    end
})

local antiaimbox = Tabs.Movement:AddLeftGroupbox('anti aim')

antiaimbox:AddToggle("AntiAimEnable", {
    Text = "enable",
    Default = false,
    Callback = function(Value)
        getgenv().AntiAim.Enabled = Value
        if not Value then
            flushAntiAimMovementState()
        end
    end
}):AddKeyPicker("antiaimKey", {
    Text = "anti aim",
    Default = "None",
    Mode = "Toggle",
    SyncToggleState = true
})

antiaimbox:AddDropdown("AntiAimYaw", {
    Values = {"none", "jitter", "spinbot", "random"},
    Default = "none",
    Text = "yaw",
    Callback = function(Value)
        getgenv().AntiAim.Yaw = Value
    end
})

antiaimbox:AddDropdown("AntiAimPitch", {
    Values = {"none", "jitter", "spinbot", "random"},
    Default = "none",
    Text = "pitch",
    Callback = function(Value)
        getgenv().AntiAim.Pitch = Value
    end
})

antiaimbox:AddDropdown("AntiAimAngle", {
    Values = {"none", "tilt 45", "tilt 90", "upside down", "custom"},
    Default = "none",
    Text = "angle",
    Callback = function(Value)
        getgenv().AntiAim.Angle = Value
    end
})

antiaimbox:AddSlider("AntiAimCustomAngle", {
    Text = "custom angle",
    Default = 0,
    Min = 0,
    Max = 360,
    Rounding = 1,
    Suffix = "°",
    Callback = function(Value)
        getgenv().AntiAim.CustomAngle = Value
    end
})

antiaimbox:AddSlider("AntiAimMinSpeed", {
    Text = "min speed",
    Default = 10,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Compact = true,
    Suffix = "",
    Callback = function(Value)
        getgenv().AntiAim.MinSpeed = Value
    end
})

antiaimbox:AddSlider("AntiAimMaxSpeed", {
    Text = "max speed",
    Default = 20,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Compact = true,
    Suffix = "",
    Callback = function(Value)
        getgenv().AntiAim.MaxSpeed = Value
    end
})

antiaimbox:AddSlider("AntiAimMinAngle", {
    Text = "min angle",
    Default = 30,
    Min = 1,
    Max = 180,
    Rounding = 1,
    Compact = true,
    Suffix = "°",
    Callback = function(Value)
        getgenv().AntiAim.MinAngle = Value
    end
})

antiaimbox:AddSlider("AntiAimMaxAngle", {
    Text = "max angle",
    Default = 60,
    Min = 1,
    Max = 180,
    Rounding = 1,
    Compact = true,
    Suffix = "°",
    Callback = function(Value)
        getgenv().AntiAim.MaxAngle = Value
    end
})

antiaimbox:AddToggle("AntiAimRandomAngle", {
    Text = "random angle",
    Default = false,
    Callback = function(Value)
        getgenv().AntiAim.RandomAngle = Value
    end
})

antiaimbox:AddToggle("AntiAimUnderground", {
    Text = "underground",
    Default = false,
    Callback = function(Value)
        getgenv().AntiAim.Underground = Value
        getgenv().InstanceUndergroundEnabled = Value
        if not Value then
            AntiAimState.UndergroundOldPos = nil
        end
    end
}):AddKeyPicker("undergroundKey", {
    Text = "underground",
    Default = "None",
    Mode = "Toggle",
    SyncToggleState = true
})
end
do

local HitNotifyBox = Tabs.Misc:AddRightTabbox()
local HitNotifyTab = HitNotifyBox:AddTab("notify hit")

HitNotifyTab:AddToggle("HitNotifyEnabled", {
    Text = "enable",
    Default = false,
    Tooltip = "show a notification when you hit someone",
    Callback = function(Value)
        HN.Enabled = Value
    end,
})

getgenv().ModDetector = getgenv().ModDetector or {
    Enabled = false,
    Connection = nil,
    Checking = false,
}

local function stopModDetector()
    if getgenv().ModDetector.Connection then
        getgenv().ModDetector.Connection:Disconnect()
        getgenv().ModDetector.Connection = nil
    end
    getgenv().ModDetector.Checking = false
end

local function startModDetector()
    if getgenv().ModDetector.Checking then return end
    getgenv().ModDetector.Checking = true

    task.spawn(function()
        repeat task.wait() until game:IsLoaded()

        if game.CreatorType ~= Enum.CreatorType.Group then
            getgenv().ModDetector.Checking = false
            return
        end

        local groupId = game.CreatorId
        local function kickPlayer()
            LocalPlayer:Kick("mod has been detected!")
            task.wait(0.5)
            if LocalPlayer.Parent then
                game:Shutdown()
            end
        end

        local function checkStaffRole(roleName)
            if not roleName or typeof(roleName) ~= "string" then return false end
            local lower = string.lower(roleName)
            return string.find(lower, "mod") or string.find(lower, "staff")
                or string.find(lower, "admin") or string.find(lower, "owner")
                or string.find(lower, "contributor") or string.find(lower, "builder")
        end

        local function checkPlayer(plr)
            if plr == LocalPlayer then return false end
            local ok, role = pcall(function() return plr:GetRoleInGroup(groupId) end)
            return ok and checkStaffRole(role)
        end

        local function checkAll()
            for _, p in ipairs(Players:GetPlayers()) do
                if checkPlayer(p) then return true end
            end
            return false
        end

        if checkAll() then
            kickPlayer()
            getgenv().ModDetector.Checking = false
            return
        end

        getgenv().ModDetector.Connection = Players.PlayerAdded:Connect(function(p)
            task.wait(1)
            if getgenv().ModDetector.Enabled and checkPlayer(p) then
                kickPlayer()
            end
        end)

        while getgenv().ModDetector.Enabled and task.wait(15) do
            if checkAll() then
                kickPlayer()
                break
            end
        end
        getgenv().ModDetector.Checking = false
    end)
end

local ModdtcBox = Tabs.Misc:AddRightTabbox()
local ModdtcTab = ModdtcBox:AddTab("mod detector")

ModdtcTab:AddToggle('moddetector', {
    Text = 'enable',
    Default = getgenv().ModDetector.Enabled,
    Callback = function(Value)
        getgenv().ModDetector.Enabled = Value
        if Value then
            startModDetector()
        else
            stopModDetector()
        end
    end
})

if getgenv().ModDetector.Enabled then
    startModDetector()
end

-- Spoofers
task.spawn(function()
local SpoofBox = Tabs.Misc:AddRightTabbox()
local LocalTab = SpoofBox:AddTab("local")
local OtherTab = SpoofBox:AddTab("other")

local deviceSpoofs = {
    Computer = "MouseKeyboard",
    Mobile   = "Touch",
    Console  = "Gamepad",
    VR       = "VR",
}

function spoofDevice(deviceType)
    local targetDevice = deviceSpoofs[deviceType]
    if targetDevice then
        game:GetService("ReplicatedStorage")
            :WaitForChild("Remotes")
            :WaitForChild("Replication")
            :WaitForChild("Fighter")
            :WaitForChild("SetControls")
            :FireServer(targetDevice)
    end
end

getgenv().ChooseDevice = ""

LocalTab:AddDropdown("DevicesType", {
    Values = {"Computer","Mobile","Console","VR"},
    Default = 1,
    Multi = false,
    Text = "devices",
    Tooltip = "type of device you want to spoof",
    Callback = function(Value)
        getgenv().ChooseDevice = Value
    end
})

LocalTab:AddToggle("DeviceSpoofToggle", {
    Text = "device spoof",
    Default = false,
    Tooltip = "enable or disable device spoofing",
    Callback = function(Value)
        getgenv().DeviceSpoofActive = Value

        if Value then
            task.spawn(function()
                while getgenv().DeviceSpoofActive do
                    if typeof(spoofDevice) == "function" then
                        spoofDevice(getgenv().ChooseDevice)
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

local Players     = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

getgenv().avatarspoof = getgenv().avatarspoof or {
    enable = false,
    userid = 2547899153,
}

local appearanceCache    = {}
local userDataCache      = {}
local originalAppearance = nil
local currentChar        = nil
local currentCharConn    = nil

local ACCESSORY_ATTACH_NAMES = {
    "HairAttachment", "HatAttachment", "FaceFrontAttachment",
    "FaceCenterAttachment", "FaceBackAttachment",
    "NeckAttachment", "BodyFrontAttachment", "BodyBackAttachment",
    "LeftCollarAttachment", "RightCollarAttachment",
    "WaistFrontAttachment", "WaistCenterAttachment", "WaistBackAttachment",
    "RightGripAttachment", "LeftGripAttachment",
}

local function attachAccessory(char, humanoid, accessoryClone)
    if not accessoryClone then return false end

    local handle = accessoryClone:FindFirstChild("Handle")
    if not handle or not handle:IsA("BasePart") then
        accessoryClone.Parent = char
        return false
    end

    if humanoid then
        local ok = pcall(function() humanoid:AddAccessory(accessoryClone) end)
        if ok and accessoryClone.Parent then
            local existingWeld = handle:FindFirstChildOfClass("Weld")
                or handle:FindFirstChildOfClass("WeldConstraint")
            if existingWeld then
                return true
            end
        end
    end

    local head = char:FindFirstChild("Head")
    if not head then
        warn("Head missing, accessory attach failed")
        accessoryClone.Parent = char
        return false
    end

    if not accessoryClone.Parent then
        accessoryClone.Parent = char
    end

    for _, w in ipairs(handle:GetChildren()) do
        if w:IsA("Weld") or w:IsA("WeldConstraint") then
            w:Destroy()
        end
    end

    local headAtt, handleAtt
    for _, name in ipairs(ACCESSORY_ATTACH_NAMES) do
        local h = head:FindFirstChild(name)
        local g = handle:FindFirstChild(name)
        if h and g then
            headAtt, handleAtt = h, g
            break
        end
    end
    if not headAtt then
        headAtt = head:FindFirstChildOfClass("Attachment")
    end
    if not handleAtt then
        handleAtt = handle:FindFirstChildOfClass("Attachment")
    end

    local weld = Instance.new("Weld")
    weld.Name = "AccessoryWeld"
    weld.Part0 = head
    weld.Part1 = handle
    if headAtt and handleAtt then
        weld.C0 = headAtt.CFrame
        weld.C1 = handleAtt.CFrame
    end
    weld.Parent = handle
    return true
end

local function clearAppearance(char)
    if not char then return end

    for _, v in ipairs(char:GetChildren()) do
        if v:IsA("Accessory")
            or v:IsA("Shirt")
            or v:IsA("Pants")
            or v:IsA("ShirtGraphic")
            or v:IsA("BodyColors")
            or v:IsA("CharacterMesh") then
            v:Destroy()
        end
    end

    local head = char:FindFirstChild("Head")
    if head then
        for _, v in ipairs(head:GetChildren()) do
            if v:IsA("Accessory")
                or v:IsA("Weld")
                or v:IsA("WeldConstraint") then
                v:Destroy()
            elseif v:IsA("BasePart") and v.Name:lower():find("hair", 1, true) then
                v:Destroy()
            elseif v:IsA("Motor6D") and v.Name:lower():find("hair", 1, true) then
                v:Destroy()
            end
        end
        for _, v in ipairs(head:GetChildren()) do
            if v:IsA("SpecialMesh")
                or v:IsA("MeshPart")
                or v:IsA("Decal")
                or v:IsA("FileMesh") then
                v:Destroy()
            end
        end
        head.Transparency = 0
        head.Color        = Color3.fromRGB(234, 184, 146)
        head.Material     = Enum.Material.Plastic
        head.Reflectance  = 0
        head.Size         = Vector3.new(2, 1, 1)
    else
        warn("[AvatarSpoof] Head missing during clearAppearance")
    end

    for _, partName in ipairs({
        "UpperTorso","LowerTorso","LeftUpperArm","LeftLowerArm",
        "RightUpperArm","RightLowerArm","LeftUpperLeg","LeftLowerLeg",
        "RightUpperLeg","RightLowerLeg","Torso"
    }) do
        local p = char:FindFirstChild(partName)
        if p then
            for _, v in ipairs(p:GetChildren()) do
                if v:IsA("SpecialMesh") or v:IsA("MeshPart") or v:IsA("Decal") then
                    v:Destroy()
                end
            end
        end
    end
end

local function saveOriginalAppearance(char)
    if not char then
        warn("saveOriginalAppearance: char missing")
        return
    end
    if originalAppearance and originalAppearance.char == char then
        return
    end

    local items = {}
    for _, v in ipairs(char:GetChildren()) do
        if v:IsA("Accessory")
            or v:IsA("Shirt")
            or v:IsA("Pants")
            or v:IsA("ShirtGraphic")
            or v:IsA("BodyColors")
            or v:IsA("CharacterMesh") then
            table.insert(items, v:Clone())
        end
    end

    local head = char:FindFirstChild("Head")
    local headProps = nil
    if head then
        headProps = {
            Size         = head.Size,
            Transparency = head.Transparency,
            Color        = head.Color,
            Material     = head.Material,
            Reflectance  = head.Reflectance,
            Children     = {},
        }
        for _, v in ipairs(head:GetChildren()) do
            if v:IsA("SpecialMesh") or v:IsA("MeshPart")
                or v:IsA("Decal") or v:IsA("FileMesh") then
                table.insert(headProps.Children, v:Clone())
            end
        end
    end

    local humanoid = char:FindFirstChildOfClass("Humanoid")

    originalAppearance = {
        char        = char,
        items       = items,
        headProps   = headProps,
        name        = char.Name,
        displayName = humanoid and humanoid.DisplayName or char.Name,
    }
end

local function restoreOriginalAppearance(char)
    if not char then
        warn("restoreOriginalAppearance: char missing")
        return
    end
    if not originalAppearance or originalAppearance.char ~= char then
        warn("originalAppearance missing, nothing to restore")
        return
    end
    local saved = originalAppearance

    clearAppearance(char)

    local humanoid = char:FindFirstChildOfClass("Humanoid")

    for _, v in ipairs(saved.items) do
        if v:IsA("BodyColors") then
            v:Clone().Parent = char
        end
    end
    for _, v in ipairs(saved.items) do
        if v:IsA("Shirt") then
            local s = Instance.new("Shirt")
            s.ShirtTemplate = v.ShirtTemplate
            s.Parent = char
        elseif v:IsA("Pants") then
            local p = Instance.new("Pants")
            p.PantsTemplate = v.PantsTemplate
            p.Parent = char
        elseif v:IsA("ShirtGraphic") then
            local g = Instance.new("ShirtGraphic")
            g.Graphic = v.Graphic
            g.Color3  = v.Color3
            g.Parent  = char
        elseif v:IsA("CharacterMesh") then
            v:Clone().Parent = char
        end
    end
    for _, v in ipairs(saved.items) do
        if v:IsA("Accessory") then
            attachAccessory(char, humanoid, v:Clone())
            task.wait()
        end
    end

    local head = char:FindFirstChild("Head")
    if head and saved.headProps then
        head.Size         = saved.headProps.Size
        head.Transparency = saved.headProps.Transparency
        head.Color        = saved.headProps.Color
        head.Material     = saved.headProps.Material
        head.Reflectance  = saved.headProps.Reflectance
        for _, v in ipairs(head:GetChildren()) do
            if v:IsA("SpecialMesh") or v:IsA("MeshPart")
                or v:IsA("Decal") or v:IsA("FileMesh") then
                v:Destroy()
            end
        end
        for _, v in ipairs(saved.headProps.Children) do
            v:Clone().Parent = head
        end
    end

    if humanoid then
        pcall(function() humanoid.DisplayName = saved.displayName end)
    end
    pcall(function() char.Name = saved.name end)

    originalAppearance = nil
end

local function getAppearance(userId)
    if appearanceCache[userId] then
        return appearanceCache[userId]
    end
    local ok, app = pcall(function()
        return Players:GetCharacterAppearanceAsync(userId)
    end)
    if ok and app then
        appearanceCache[userId] = app
        return app
    end
    warn("GetCharacterAppearanceAsync failed for userid " .. tostring(userId))
    return nil
end

local function fetchUserData(userId)
    if type(userId) ~= "number" then
        warn("userid is not a number")
        return nil
    end
    if userDataCache[userId] then
        return userDataCache[userId]
    end
    local ok, data = pcall(function()
        return HttpService:JSONDecode(
            game:HttpGet("https://users.roblox.com/v1/users/" .. userId, true)
        )
    end)
    if not ok or type(data) ~= "table" or not data.name then
        warn("user data fetch failed for userid " .. tostring(userId))
        return nil
    end
    userDataCache[userId] = data
    return data
end

local function applyAppearance(char)
    if not char or not char.Parent then
        warn("applyAppearance: char missing or not parented")
        return
    end
    if not getgenv().avatarspoof.enable then return end

    local userId = getgenv().avatarspoof.userid
    if type(userId) ~= "number" then
        warn("applyAppearance: userid is not a number")
        return
    end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        warn("Humanoid missing on char")
        return
    end

    saveOriginalAppearance(char)
    clearAppearance(char)

    local appearance = getAppearance(userId)
    if not appearance then
        warn("appearance missing for userid " .. tostring(userId))
        return
    end

    local decodedData = fetchUserData(userId)
    if not decodedData then
        warn("user data missing for userid " .. tostring(userId))
        return
    end

    local waited = 0
    while #appearance:GetChildren() == 0 and waited < 30 do
        task.wait(0.1)
        waited += 1
    end
    if #appearance:GetChildren() == 0 then
        warn("appearance empty for userid " .. tostring(userId))
        return
    end

    for _, v in ipairs(appearance:GetChildren()) do
        if v:IsA("BodyColors") then
            v:Clone().Parent = char
        end
    end

    for _, v in ipairs(appearance:GetChildren()) do
        if v:IsA("Shirt") then
            local s = Instance.new("Shirt")
            s.ShirtTemplate = v.ShirtTemplate
            s.Parent = char
        elseif v:IsA("Pants") then
            local p = Instance.new("Pants")
            p.PantsTemplate = v.PantsTemplate
            p.Parent = char
        elseif v:IsA("ShirtGraphic") then
            local g = Instance.new("ShirtGraphic")
            g.Graphic = v.Graphic
            g.Color3  = v.Color3
            g.Parent  = char
        end
    end

    for _, v in ipairs(appearance:GetChildren()) do
        if v:IsA("Accessory") then
            attachAccessory(char, humanoid, v:Clone())
            task.wait()
        end
    end

    for _, v in ipairs(appearance:GetChildren()) do
        if v:IsA("Face") then
            local newFace = v:Clone()
            newFace.Parent = char:FindFirstChild("Head") or char
        end
    end

    local appHead = appearance:FindFirstChild("Head")
    local myHead  = char:FindFirstChild("Head")
    if appHead and myHead then
        myHead.Size         = appHead.Size
        myHead.Transparency = appHead.Transparency
        myHead.Color        = appHead.Color
        myHead.Material     = appHead.Material
        myHead.Reflectance  = appHead.Reflectance

        for _, v in ipairs(myHead:GetChildren()) do
            if v:IsA("SpecialMesh") or v:IsA("MeshPart") then
                v:Destroy()
            end
        end

        local appMesh = appHead:FindFirstChildOfClass("SpecialMesh")
        if appMesh then
            appMesh:Clone().Parent = myHead
        end
        if appHead:IsA("MeshPart") then
            pcall(function()
                myHead.MeshId    = appHead.MeshId
                myHead.TextureID = appHead.TextureID
            end)
        end
    else
        warn("Head missing (appHead or myHead)")
    end

    pcall(function()
        char.Name = decodedData.name
        humanoid.DisplayName = decodedData.displayName or decodedData.name
    end)
end

local function bindCharacter(char)
    if not char then
        warn("bindCharacter: char missing")
        return
    end
    currentChar = char

    local timeout = 0
    while not char:FindFirstChildOfClass("Humanoid") and timeout < 50 do
        task.wait(0.1)
        timeout += 1
    end
    if not char.Parent then
        warn("bindCharacter: char unparented before humanoid ready")
        return
    end
    if not char:FindFirstChildOfClass("Humanoid") then
        warn("Humanoid missing after wait")
        return
    end

    if getgenv().avatarspoof.enable then
        task.wait(0.2)
        if char.Parent and getgenv().avatarspoof.enable then
            applyAppearance(char)
        end
    end
end

local function bindSelf()
    if currentCharConn then
        currentCharConn:Disconnect()
        currentCharConn = nil
    end
    if LocalPlayer.Character then
        bindCharacter(LocalPlayer.Character)
    end
    currentCharConn = LocalPlayer.CharacterAdded:Connect(function(char)
        originalAppearance = nil
        currentChar = char
        bindCharacter(char)
    end)
end

bindSelf()

local lastEnable = getgenv().avatarspoof.enable
local lastUserId = getgenv().avatarspoof.userid

task.spawn(function()
    while true do
        task.wait(0.1)
        local cfg = getgenv().avatarspoof
        if not cfg then continue end

        local curEnable = cfg.enable
        local curUserId = cfg.userid

        if curUserId ~= lastUserId then
            lastUserId = curUserId
            if curEnable then
                local char = currentChar or LocalPlayer.Character
                if char then
                    task.spawn(function() applyAppearance(char) end)
                else
                    warn("userid changed but char missing")
                end
            end
        end

        if curEnable ~= lastEnable then
            lastEnable = curEnable
            local char = currentChar or LocalPlayer.Character
            if char then
                if curEnable then
                    task.spawn(function() applyAppearance(char) end)
                else
                    task.spawn(function() restoreOriginalAppearance(char) end)
                end
            else
                warn("enable changed but char missing")
            end
        end
    end
end)

LocalTab:AddInput("ASValue", {
    Default = "2547899153",
    Numeric = false,
    Finished = false,
    ClearTextOnFocus = false,
    Text = "id",
    Tooltip = "spoof your avatar",
    Placeholder = "user id",
    Callback = function(v)
        local n = tonumber(v)
        if n then
            getgenv().avatarspoof.userid = n
        end
    end,
})

LocalTab:AddToggle("ASEnabled", {
    Text = "avatar spoof",
    Default = false,
    Tooltip = "apply spoofed avatar",
    Callback = function(v)
        getgenv().avatarspoof.enable = v
        local char = currentChar or LocalPlayer.Character
        if not char then
            warn("toggle changed but char missing")
            return
        end
        if v then
            task.spawn(function() applyAppearance(char) end)
        else
            task.spawn(function() restoreOriginalAppearance(char) end)
        end
    end,
})

do
    if getgenv().__AvatarThumbSpoofInstalled then
        return
    end
    getgenv().__AvatarThumbSpoofInstalled = true

    local Players     = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local function getSpoofUserIdForPlayer(player)
        if player ~= LocalPlayer then
            return nil
        end
        local cfg = getgenv().avatarspoof
        if cfg and cfg.enable == true and type(cfg.userid) == "number" then
            return cfg.userid
        end
        return nil
    end

    local function replaceThumbId(str, fromId, toId)
        if type(str) ~= "string" or not fromId or not toId then
            return str
        end

        local changed = false

        local out = str:gsub("id=(%d+)", function(digits)
            if tonumber(digits) == fromId then
                changed = true
                return "id=" .. tostring(toId)
            end
            return "id=" .. digits
        end)

        out = out:gsub("userId=(%d+)", function(digits)
            if tonumber(digits) == fromId then
                changed = true
                return "userId=" .. tostring(toId)
            end
            return "userId=" .. digits
        end)

        if not changed then
            return str
        end
        return out
    end

    local watchEntryByImageObject = {}

    local function resolvePlayerFromImage(imageObj)
        return LocalPlayer
    end

    local function computeSpoofedImage(imageObj, currentImage)
        if type(currentImage) ~= "string" then
            return currentImage
        end
        if currentImage:sub(1, 10) ~= "rbxthumb:/"
            and currentImage:find("roblox.com", 1, true) == nil
        then
            return currentImage
        end

        local player  = resolvePlayerFromImage(imageObj)
        local spoofId = getSpoofUserIdForPlayer(player)
        if not spoofId then
            return currentImage
        end

        return replaceThumbId(currentImage, player.UserId, spoofId)
    end

    local function watchImage(imageObj)
        if watchEntryByImageObject[imageObj] ~= nil then
            return
        end
        if not (imageObj:IsA("ImageLabel") or imageObj:IsA("ImageButton")) then
            return
        end

        local entry = {
            OriginalImage = nil,
            SpoofedImage  = nil,
            Player        = resolvePlayerFromImage(imageObj),
        }
        watchEntryByImageObject[imageObj] = entry

        local function onImageChanged()
            local current = imageObj.Image
            if type(current) ~= "string" then
                return
            end

            if entry.SpoofedImage ~= nil and current == entry.SpoofedImage then
                return
            end

            if entry.OriginalImage == nil
                or current ~= entry.OriginalImage
            then
                entry.OriginalImage = current
            end

            local spoofed = computeSpoofedImage(imageObj, entry.OriginalImage)
            if spoofed ~= entry.OriginalImage then
                entry.SpoofedImage = spoofed
                imageObj.Image    = spoofed
            else
                entry.SpoofedImage = nil
            end
        end

        onImageChanged()

        entry.ImageChangedConnection =
            imageObj:GetPropertyChangedSignal("Image"):Connect(onImageChanged)

        entry.DestroyingConnection =
            imageObj.Destroying:Connect(function()
                if entry.ImageChangedConnection then
                    entry.ImageChangedConnection:Disconnect()
                    entry.ImageChangedConnection = nil
                end
                if entry.DestroyingConnection then
                    entry.DestroyingConnection:Disconnect()
                    entry.DestroyingConnection = nil
                end
                watchEntryByImageObject[imageObj] = nil
            end)
    end

    local scannedRootSet = {}

    local function scanRoot(root)
        if not root or scannedRootSet[root] then
            return
        end
        scannedRootSet[root] = true

        local ok, descendants = pcall(function()
            return root:GetDescendants()
        end)
        if ok and descendants then
            for _, obj in ipairs(descendants) do
                if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                    watchImage(obj)
                end
            end
        end

        pcall(function()
            root.DescendantAdded:Connect(function(obj)
                if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                    watchImage(obj)
                end
            end)
        end)
    end

    local function collectRoots()
        local roots = {}

        pcall(function()
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            if pg then table.insert(roots, pg) end
        end)

        pcall(function()
            local cg = game:GetService("CoreGui")
            if cg then table.insert(roots, cg) end
        end)

        pcall(function()
            local hui = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui())
            if hui then table.insert(roots, hui) end
        end)

        return roots
    end

    for _, root in ipairs(collectRoots()) do
        scanRoot(root)
    end

    task.spawn(function()
        local pg = LocalPlayer:WaitForChild("PlayerGui", 15)
        if pg then
            scanRoot(pg)
        end
    end)

    local function refreshAllThumbnails()
        for imageObj, entry in pairs(watchEntryByImageObject) do
            if imageObj and imageObj.Parent then
                local current = imageObj.Image
                if type(current) == "string" then
                    if entry.OriginalImage ~= nil then
                        imageObj.Image = entry.OriginalImage
                    else
                        imageObj.Image = current
                    end
                end
            end
        end
    end

    local function restoreAllThumbnails()
        for imageObj, entry in pairs(watchEntryByImageObject) do
            if imageObj and imageObj.Parent
                and entry.OriginalImage ~= nil
                and entry.SpoofedImage ~= nil
                and imageObj.Image == entry.SpoofedImage
            then
                imageObj.Image    = entry.OriginalImage
                entry.SpoofedImage = nil
            end
        end
    end

    getgenv().__AvatarThumbSpoof = {
        replaceThumbId      = replaceThumbId,
        refresh             = refreshAllThumbnails,
        restore             = restoreAllThumbnails,
        watchImage          = watchImage,
    }
    getgenv().RefreshAllThumbnails = refreshAllThumbnails

    local lastEnable = nil
    local lastUserId = nil

    task.spawn(function()
        while true do
            task.wait(0.2)
            local cfg = getgenv().avatarspoof
            if cfg then
                local curEnable = cfg.enable == true
                local curUserId = cfg.userid

                if curEnable ~= lastEnable or curUserId ~= lastUserId then
                    lastEnable = curEnable
                    lastUserId = curUserId

                    if curEnable then
                        refreshAllThumbnails()
                    else
                        restoreAllThumbnails()
                    end
                end
            end
        end
    end)
end

local NSConfig = {
    enabled  = false,
    value    = "hi",
    verified = false,
    premium  = false,
}

local function escape(str)
    return (tostring(str):gsub("([^%w])", "%%%1"))
end

local function clearbadges(str)
    if typeof(str) ~= "string" then return "" end
    return (str:gsub(utf8.char(0xE000), ""):gsub(utf8.char(0xE001), ""))
end

local function buildBadgeSuffix()
    local badges = ""
    if NSConfig.premium  then badges = badges .. utf8.char(0xE001) end
    if NSConfig.verified then badges = badges .. utf8.char(0xE000) end
    return badges
end

local function buildSpoofName()
    return clearbadges(NSConfig.value or "hi")
end

local function buildDisplayBase()
    if NSConfig.enabled then
        return clearbadges(NSConfig.value or "hi")
    end
    return clearbadges(LocalPlayer.Name)
end

local function buildBadgedName()
    return buildDisplayBase() .. buildBadgeSuffix()
end

local SP = getgenv().AlcritySpoofer
if not SP then
    SP = {}
    getgenv().AlcritySpoofer = SP
end
SP._identity = SP._identity or setmetatable({}, {__mode = "k"})
SP._otherNameActive = SP._otherNameActive or false
SP._otherNameValue  = SP._otherNameValue  or "Alcrity"

local function getIdentity(p)
    local id = SP._identity[p]
    if not id then
        id = {
            Name        = clearbadges(p.Name),
            DisplayName = clearbadges(p.DisplayName),
        }
        SP._identity[p] = id
    end
    return id
end

getIdentity(LocalPlayer)
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then getIdentity(p) end
end

local function NS_applyChar(c)
    if not NSConfig.enabled and not (NSConfig.verified or NSConfig.premium) then return end
    if c then
        local h = c:WaitForChild("Humanoid", 5)
        if h then
            h.DisplayName = buildBadgedName()
            local old = h.DisplayDistanceType
            h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            h.DisplayDistanceType = old
        end
    end
end

local function NS_applyLocal()
    if not NSConfig.enabled and not (NSConfig.verified or NSConfig.premium) then return end
    local spoof = buildSpoofName()

    if NSConfig.enabled then
        pcall(function() LocalPlayer.Name        = spoof end)
        pcall(function() LocalPlayer.DisplayName = spoof end)
    end

    local char = LocalPlayer.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then
            h.DisplayName = buildBadgedName()
            local old = h.DisplayDistanceType
            h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            h.DisplayDistanceType = old
        end
    end
end

local function NS_restore()
    local id = SP._identity[LocalPlayer]
    if not id then return end

    pcall(function()
        LocalPlayer.Name        = id.Name
        LocalPlayer.DisplayName = id.DisplayName
    end)

    local char = LocalPlayer.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then
            h.DisplayName = id.DisplayName
            local old = h.DisplayDistanceType
            h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            h.DisplayDistanceType = old
        end
    end
end

task.spawn(function()
    while task.wait(1) do
        if NSConfig.enabled then
            NS_applyLocal()
        elseif NSConfig.verified or NSConfig.premium then
            local p = LocalPlayer
            local char = p.Character
            if char then
                local h = char:FindFirstChildOfClass("Humanoid")
                if h then
                    local base = clearbadges(p.DisplayName)
                    h.DisplayName = base .. buildBadgeSuffix()
                    local old = h.DisplayDistanceType
                    h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    h.DisplayDistanceType = old
                end
            end
        end
    end
end)

local function setLocalPresented(name)
    local id = getIdentity(LocalPlayer)
    id.Presented = (name ~= "" and clearbadges(name)) or nil
end

local function setLocalPresentedDisplay(display)
    local id = getIdentity(LocalPlayer)
    if display == "" then
        id.PresentedDisplay = nil
    else
        id.PresentedDisplay = clearbadges(display) .. buildBadgeSuffix()
    end
end

local function setOtherPresented(name)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local id = getIdentity(p)
            if name == "" then
                id.OtherPresented = nil
                id.OtherPresentedDisplay = nil
            else
                local clean = clearbadges(name)
                id.OtherPresented = clean
                id.OtherPresentedDisplay = clean .. buildBadgeSuffix()
            end
        end
    end
end

local function replaceNames(text)
    if type(text) ~= "string" then return text end
    local clean = clearbadges(text)

    local meId = getIdentity(LocalPlayer)
    local target = meId.PresentedDisplay
    if target and target ~= "" then
        if meId.Name ~= "" and meId.Name ~= target then
            clean = clean:gsub(escape(meId.Name), target)
        end
        if meId.DisplayName ~= "" and meId.DisplayName ~= meId.Name and meId.DisplayName ~= target then
            clean = clean:gsub(escape(meId.DisplayName), target)
        end
        if meId.Presented and meId.Presented ~= "" and meId.Presented ~= target then
            clean = clean:gsub(escape(meId.Presented), target)
        end
    end

    if SP._otherNameActive then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local id = getIdentity(p)
                local ot = id.OtherPresentedDisplay
                if ot and ot ~= "" then
                    if id.Name ~= "" and id.Name ~= ot then
                        clean = clean:gsub(escape(id.Name), ot)
                    end
                    if id.DisplayName ~= "" and id.DisplayName ~= id.Name and id.DisplayName ~= ot then
                        clean = clean:gsub(escape(id.DisplayName), ot)
                    end
                    if id.OtherPresented and id.OtherPresented ~= "" and id.OtherPresented ~= ot then
                        clean = clean:gsub(escape(id.OtherPresented), ot)
                    end
                end
            end
        end
    end

    return clean
end

local SP_IGNORE_ROOTS = {}

local function registerIgnoreRoot(root)
    if root and typeof(root) == "Instance" then
        SP_IGNORE_ROOTS[root] = true
    end
end

if Library and Library.ScreenGui then
    registerIgnoreRoot(Library.ScreenGui)
end

local function registerConsoleIgnoreRoots()
    pcall(function()
        local cg = game:GetService("CoreGui")
        for _, child in ipairs(cg:GetChildren()) do
            local n = child.Name
            if n == "DeveloperConsole"
                or n == "DevConsole"
                or n == "RobloxConsole"
                or n == "Console"
            then
                registerIgnoreRoot(child)
            end
        end
    end)
    pcall(function()
        local hui = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui())
        if hui then
            for _, child in ipairs(hui:GetChildren()) do
                local n = child.Name
                if n == "DeveloperConsole"
                    or n == "DevConsole"
                    or n == "RobloxConsole"
                    or n == "Console"
                then
                    registerIgnoreRoot(child)
                end
            end
        end
    end)
end
registerConsoleIgnoreRoots()

pcall(function()
    if Library and Library.Window then
        local holder = Library.Window.Holder
        if holder and holder.Parent then
            registerIgnoreRoot(holder.Parent)
        end
    end
end)

local SP_INPUT_OBJECTS = setmetatable({}, {__mode = "k"})

local function isSpoofIgnored(obj)
    if not obj then return false end
    if SP_INPUT_OBJECTS[obj] then return true end
    local current = obj
    while current do
        if SP_IGNORE_ROOTS[current] then
            return true
        end
        current = current.Parent
    end
    return false
end

local watched = setmetatable({}, {__mode = "k"})
local function watchLabel(label)
    if watched[label] then return end
    if isSpoofIgnored(label) then return end
    watched[label] = true
    local writing = false

    local function apply()
        if writing then return end
        if not label.Parent then return end
        if isSpoofIgnored(label) then return end

        local raw = label:GetAttribute("__spoof_raw")
        if raw == nil then
            raw = clearbadges(label.Text or "")
            label:SetAttribute("__spoof_raw", raw)
        end

        local new = replaceNames(raw)
        if new ~= label.Text then
            writing = true
            label.Text = new
            writing = false
        end
    end

    label:GetPropertyChangedSignal("Text"):Connect(function()
        if writing then return end
        if isSpoofIgnored(label) then return end
        label:SetAttribute("__spoof_raw", clearbadges(label.Text or ""))
        apply()
    end)
    apply()
end

local function scanGui(root)
    if not root then return end
    local function consider(d)
        if isSpoofIgnored(d) then return end
        if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
            watchLabel(d)
        end
    end
    for _, d in ipairs(root:GetDescendants()) do consider(d) end
    root.DescendantAdded:Connect(consider)
end

pcall(function()
    local rg = CoreGui:FindFirstChild("RobloxGui")
    if rg then scanGui(rg) end
end)
pcall(function()
    local pg = LocalPlayer:WaitForChild("PlayerGui", 10)
    if pg then scanGui(pg) end
end)
pcall(function()
    local hui = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui())
    if hui then
        local rg = hui:FindFirstChild("RobloxGui")
        if rg then scanGui(rg) end
        scanGui(hui)
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if Library and Library.ScreenGui then
            registerIgnoreRoot(Library.ScreenGui)
            break
        end
    end
end)

local function refreshAll()
    for label in pairs(watched) do
        if label and label.Parent and not isSpoofIgnored(label) then
            local raw = label:GetAttribute("__spoof_raw")
            if raw ~= nil then
                local new = replaceNames(raw)
                if new ~= label.Text then
                    local oldRaw = label:GetAttribute("__spoof_raw")
                    label.Text = new
                    label:SetAttribute("__spoof_raw", oldRaw)
                end
            end
        end
    end
end

local function clearAllGuiSpoof()
    for label in pairs(watched) do
        if label and label.Parent and not isSpoofIgnored(label) then
            local raw = label:GetAttribute("__spoof_raw")
            if raw ~= nil and label.Text ~= raw then
                label.Text = raw
            end
        end
    end
end

local function applyLocalCfg()
    local p = LocalPlayer
    local nameOn    = NSConfig.enabled
    local displayOn = NSConfig.enabled
    local badgeOn   = NSConfig.verified or NSConfig.premium

    local spoofName = ""
    if displayOn and NSConfig.value ~= "" then
        spoofName = clearbadges(NSConfig.value)
    end

    local displayBase = ""
    if displayOn and NSConfig.value ~= "" then
        displayBase = clearbadges(NSConfig.value)
    elseif badgeOn then
        displayBase = clearbadges(p.DisplayName)
    end

    setLocalPresented(spoofName)
    setLocalPresentedDisplay(displayBase)

    if spoofName ~= "" then
        NS_applyLocal()
    end
    if displayBase ~= "" then
        local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
        if h then
            h.DisplayName = displayBase .. buildBadgeSuffix()
        end
    end

    refreshAll()
end

local function applyOtherCfg()
    setOtherPresented(SP._otherNameActive and (SP._otherNameValue or "Alcrity") or "")
    refreshAll()
end

Players.PlayerAdded:Connect(function(p)
    getIdentity(p)
    if p ~= LocalPlayer and SP._otherNameActive then
        setOtherPresented(SP._otherNameValue or "Alcrity")
    end
    p.CharacterAdded:Connect(function(char)
        task.defer(function()
            local h = char:WaitForChild("Humanoid", 5)
            if not h then return end
            if p == LocalPlayer then
                if NSConfig.enabled or NSConfig.verified or NSConfig.premium then
                    h.DisplayName = buildBadgedName()
                end
            elseif SP._otherNameActive then
                h.DisplayName = clearbadges(SP._otherNameValue or "Alcrity") .. buildBadgeSuffix()
            end
        end)
    end)
    refreshAll()
end)

LocalPlayer.CharacterAdded:Connect(function(c)
    NS_applyChar(c)
    NS_applyLocal()
    task.defer(refreshAll)
end)

if LocalPlayer.Character then
    task.defer(function()
        NS_applyChar(LocalPlayer.Character)
        NS_applyLocal()
        refreshAll()
    end)
end

game.DescendantAdded:Connect(function(d)
    if isSpoofIgnored(d) then return end
    if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
        watchLabel(d)
    end
end)
pcall(function()
    game:GetService("CoreGui").DescendantAdded:Connect(function(d)
        if isSpoofIgnored(d) then return end
        if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
            watchLabel(d)
        end
    end)
end)

getgenv().InstanceNameSpoof = {
    config = NSConfig,
    setEnabled = function(v)
        NSConfig.enabled = v
        if v then
            NS_applyLocal()
        else
            NS_restore()
            clearAllGuiSpoof()
        end
        applyLocalCfg()
    end,
    setName = function(n)
        NSConfig.value = clearbadges(n or "hi")
        if NSConfig.enabled then NS_applyLocal() end
        applyLocalCfg()
    end,
    setVerified = function(v)
        NSConfig.verified = v
        if NSConfig.enabled then NS_applyLocal() end
        applyLocalCfg()
    end,
    setPremium = function(v)
        NSConfig.premium = v
        if NSConfig.enabled then NS_applyLocal() end
        applyLocalCfg()
    end,
    apply = function()
        NS_applyLocal()
        applyLocalCfg()
    end,
    getSpoofName = buildSpoofName,
    getBadgedName = buildBadgedName,
    applyOther = applyOtherCfg,
    refreshAll = refreshAll,
}

LocalTab:AddInput("NSValue", {
    Default = "hi",
    Numeric = false,
    Finished = false,
    ClearTextOnFocus = false,
    Text = "name",
    Tooltip = "spoof display name",
    Placeholder = "hi",
    Callback = function(v)
        NSConfig.value = clearbadges(v or "hi")
        if NSConfig.enabled then
            NS_applyLocal()
            setLocalPresented(NSConfig.value)
            setLocalPresentedDisplay(NSConfig.value)
            refreshAll()
        end
    end,
})

LocalTab:AddToggle("NSEnabled", {
    Text = "name spoof",
    Default = false,
    Tooltip = "apply spoofed display name",
    Callback = function(v)
        NSConfig.enabled = v
        if v then
            NS_applyChar(LocalPlayer.Character)
            NS_applyLocal()
            applyLocalCfg()
        else
            NS_restore()
            clearAllGuiSpoof()
            applyLocalCfg()
        end
    end,
})

task.defer(function()
    task.wait(0.3)
    local function markInputBoxes(root)
        if not root then return end
        for _, d in ipairs(root:GetDescendants()) do
            if d:IsA("TextBox") and d.Text == "hi" then
                SP_INPUT_OBJECTS[d] = true
            end
        end
    end
    pcall(function()
        if Library and Library.ScreenGui then
            markInputBoxes(Library.ScreenGui)
        end
    end)
    pcall(function()
        local hui = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui())
        if hui then markInputBoxes(hui) end
    end)
    pcall(function()
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if pg then markInputBoxes(pg) end
    end)
end)

LocalTab:AddToggle("NSVerified", {
    Text = "verified",
    Default = false,
    Callback = function(v)
        NSConfig.verified = v
        NS_applyChar(LocalPlayer.Character)
        if v or NSConfig.enabled then
            NS_applyLocal()
        end
        applyLocalCfg()
    end,
})

LocalTab:AddToggle("NSPremium", {
    Text = "premium",
    Default = false,
    Callback = function(v)
        NSConfig.premium = v
        NS_applyChar(LocalPlayer.Character)
        if v or NSConfig.enabled then
            NS_applyLocal()
        end
        applyLocalCfg()
    end,
})

getgenv().WinStreak = 0

LocalTab:AddInput("Win Streak Input", {
    Default = "",
    Numeric = true,
    Finished = false,
    ClearTextOnFocus = true,
    Text = "win streaks",
    Tooltip = "win streaks you want to spoof",
    Placeholder = "",
    Callback = function(Value)
        getgenv().WinStreak = tonumber(Value) or 0
    end
})

LocalTab:AddToggle("WinStreakToggle", {
    Text = "spoof win streak",
    Default = false,
    Tooltip = "spoof your current win streak",
    Callback = function(Value)
        getgenv().WinStreakActive = Value

        if Value then
            task.spawn(function()
                local player = game:GetService("Players").LocalPlayer
                while getgenv().WinStreakActive do
                    local value = tonumber(getgenv().WinStreak)
                    if value then
                        player:SetAttribute("StatisticDuelsWinStreak", value)
                    else
                        break
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

getgenv().Level = 0

LocalTab:AddInput("Levels", {
    Default = "",
    Numeric = true,
    Finished = false,
    ClearTextOnFocus = true,
    Text = "levels",
    Tooltip = "levels you want to spoof",
    Placeholder = "",
    Callback = function(Value)
        getgenv().Level = tonumber(Value) or 0
    end
})

LocalTab:AddToggle("LevelToggle", {
    Text = "spoof level",
    Default = false,
    Tooltip = "spoof your current player level",
    Callback = function(Value)
        getgenv().LevelActive = Value

        if Value then
            task.spawn(function()
                local player = game:GetService("Players").LocalPlayer
                while getgenv().LevelActive do
                    local value = tonumber(getgenv().Level)
                    if value then
                        player:SetAttribute("Level", value)
                    else
                        break
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

local Players_L = game:GetService("Players")

local OriginalNames = {}

local function SaveOriginalNames()
    for _, player in ipairs(Players_L:GetPlayers()) do
        if player ~= Players_L.LocalPlayer then
            if not OriginalNames[player.Name] then
                OriginalNames[player.Name] = {
                    Name = player.Name,
                    DisplayName = player.DisplayName
                }
            end
        end
    end
end

SaveOriginalNames()

Players_L.PlayerAdded:Connect(function(player)
    if player ~= Players_L.LocalPlayer then
        OriginalNames[player.Name] = {
            Name = player.Name,
            DisplayName = player.DisplayName
        }
    end
end)

OtherTab:AddInput("Other Name", {
    Default = "Alacrity",
    Numeric = false,
    Finished = false,
    ClearTextOnFocus = false,
    Text = "name",
    Tooltip = "name for all players",
    Placeholder = "enter name",
    Callback = function(Value)
        SP._otherNameValue = tostring(Value or "Alacrity")
        if SP._otherNameActive then
            applyOtherCfg()
        end
    end,
})

OtherTab:AddToggle("OtherName", {
    Text = "name spoof",
    Default = false,
    Tooltip = "spoof all players' name",
    Callback = function(Value)
        SP._otherNameActive = Value
        applyOtherCfg()
    end,
})

getgenv().OtherLevel = 0

OtherTab:AddInput("Other Level", {
    Default = "",
    Numeric = true,
    Finished = false,
    ClearTextOnFocus = true,
    Text = "level",
    Tooltip = "level for all players",
    Placeholder = "enter level",
    Callback = function(Value)
        getgenv().OtherLevel = tonumber(Value) or 0
    end
})

OtherTab:AddToggle("OtherLevel", {
    Text = "level spoof",
    Default = false,
    Tooltip = "spoof all players' level",
    Callback = function(Value)
        getgenv().OtherLevelActive = Value

        if Value then
            task.spawn(function()
                while getgenv().OtherLevelActive do
                    for _, player in ipairs(Players_L:GetPlayers()) do
                        if player ~= Players_L.LocalPlayer and player.Parent then
                            pcall(function()
                                player:SetAttribute("Level", getgenv().OtherLevel)
                            end)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

getgenv().OtherWins = 0

OtherTab:AddInput("Other Wins", {
    Default = "",
    Numeric = true,
    Finished = false,
    ClearTextOnFocus = true,
    Text = "wins",
    Tooltip = "wins for all players",
    Placeholder = "enter wins",
    Callback = function(Value)
        getgenv().OtherWins = tonumber(Value) or 0
    end
})

OtherTab:AddToggle("OtherWins", {
    Text = "wins spoof",
    Default = false,
    Tooltip = "spoof all players' wins",
    Callback = function(Value)
        getgenv().OtherWinsActive = Value

        if Value then
            task.spawn(function()
                while getgenv().OtherWinsActive do
                    for _, player in ipairs(Players_L:GetPlayers()) do
                        if player ~= Players_L.LocalPlayer and player.Parent then
                            pcall(function()
                                player:SetAttribute("StatisticDuelsWinStreak", getgenv().OtherWins)
                            end)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

OtherTab:AddButton("reset all", function()
    getgenv().OtherNameSpoofActive = false
    getgenv().OtherLevelActive = false
    getgenv().OtherWinsActive = false

    for _, player in ipairs(Players_L:GetPlayers()) do
        if player ~= Players_L.LocalPlayer and player.Parent then
            pcall(function()
                if OriginalNames[player.Name] then
                    player.Name = OriginalNames[player.Name].Name
                    player.DisplayName = OriginalNames[player.Name].DisplayName
                end

                player:SetAttribute("Level", 0)
                player:SetAttribute("StatisticDuelsWinStreak", 0)
            end)
        end
    end
end)
end)

local AutoloadTab = Tabs.Misc:AddLeftTabbox():AddTab("auto load")

local function queueOnTeleport(code)
    if type(queue_on_teleport) == "function" then
        pcall(queue_on_teleport, code)
        return true
    elseif type(queueonteleport) == "function" then
        pcall(queueonteleport, code)
        return true
    elseif syn and type(syn.queue_on_teleport) == "function" then
        pcall(syn.queue_on_teleport, code)
        return true
    elseif fluxus and type(fluxus.queue_on_teleport) == "function" then
        pcall(fluxus.queue_on_teleport, code)
        return true
    end
    return false
end

local AUTOLOAD_QUEUE_CODE = ([[
    local function readFlag()
        if isfile and readfile then
            local ok = pcall(isfile, "Alacrity/autoload.json")
            if ok and isfile("Alacrity/autoload.json") then
                local ok2, raw = pcall(readfile, "Alacrity/autoload.json")
                if ok2 and raw and raw ~= "" then
                    local ok3, dec = pcall(function()
                        return game:GetService("HttpService"):JSONDecode(raw)
                    end)
                    if ok3 and type(dec) == "table" then
                        return dec
                    end
                end
            end
        end
        return nil
    end

    getgenv().autoload = getgenv().autoload or {}

    local flag = readFlag()
    if flag then
        if flag.enable ~= nil then
            getgenv().autoload.enable = flag.enable == true
        end
        if flag.silent ~= nil then
            getgenv().autoload.silent = flag.silent == true
        end
    end

    if getgenv().autoload.enable == true then
        loadstring(game:HttpGet("https://alacrity.rip/loader.lua", true))()
    end
]])

local _queuedCode = getgenv().AlacrityQueuedCode
local function ensureQueueRegistered()
    if _queuedCode == AUTOLOAD_QUEUE_CODE then return end
    _queuedCode = AUTOLOAD_QUEUE_CODE
    getgenv().AlacrityQueuedCode = AUTOLOAD_QUEUE_CODE
    queueOnTeleport(AUTOLOAD_QUEUE_CODE)
end

local AUTOLOAD_FILE = "Alacrity/autoload.json"

local function readAutoloadFlag()
    if not (isfile and readfile) then return nil end
    local ok = pcall(isfile, AUTOLOAD_FILE)
    if not ok or not isfile(AUTOLOAD_FILE) then return nil end
    local ok2, raw = pcall(readfile, AUTOLOAD_FILE)
    if not ok2 or not raw or raw == "" then return nil end
    local ok3, dec = pcall(function()
        return game:GetService("HttpService"):JSONDecode(raw)
    end)
    if not ok3 or type(dec) ~= "table" then return nil end
    return dec.enable == true
end

local function writeAutoloadFlag(enable, silent)
    if not (isfile and writefile) then return end
    local ok, enc = pcall(function()
        return game:GetService("HttpService"):JSONEncode({
            enable = enable == true,
            silent = silent == true,
        })
    end)
    if ok then pcall(writefile, AUTOLOAD_FILE, enc) end
end

if getgenv().autoload.enable == nil then
    local flag = readAutoloadFlag()
    if flag ~= nil then getgenv().autoload.enable = flag end
end

AutoloadTab:AddToggle("autoload_enable", {
    Text = "auto load",
    Default = getgenv().autoload.enable,
    Callback = function(Value)
        getgenv().autoload.enable = Value
        writeAutoloadFlag(Value, getgenv().autoload.silent)
        ensureQueueRegistered()
    end
})

AutoloadTab:AddToggle("autoload_silent", {
    Text = "silent mode",
    Default = getgenv().autoload.silent,
    Callback = function(Value)
        getgenv().autoload.silent = Value
        getgenv().showui = not Value
        writeAutoloadFlag(getgenv().autoload.enable, Value)
        ensureQueueRegistered()
    end
})

if getgenv().autoload.enable then
    ensureQueueRegistered()
end

-- Auto Queue/Ban
local AutoQueueandBan = Tabs.Misc:AddLeftTabbox()
local AutoQueueTab = AutoQueueandBan:AddTab("auto queue")

AutoQueueTab:AddToggle("Enable_autoqueue", {
    Text = "enable",
    Default = false,
    Callback = function(Value)
      getgenv().autoqueue.AutoMatch = Value
    end
})

local QueueList = {"1v1", "2v2", "3v3", "4v4", "5v5"}

AutoQueueDropdown = AutoQueueTab:AddDropdown("AutoQueueDropdown", {
    Text = "mode",
    Values = QueueList,
    Default = 1,
    Multi = false,
    Callback = function(Value)
      getgenv().autoqueue.QueueGonnaUse = Value
    end
})

-- Auto Ban / Auto Pick
local AutoBanWeaponConnection = nil
local AutoPickWeaponConnection = nil
local hasVoted = false
local hasPicked = false

local AutoBanTab = AutoQueueandBan:AddTab("auto ban")

AutoBanTab:AddToggle("Enable_AutoBanWeapon", {
    Text = "enable",
    Default = false,
    Callback = function(Value)
        if AutoBanWeaponConnection then
            AutoBanWeaponConnection:Disconnect()
            AutoBanWeaponConnection = nil
        end
        hasVoted = false

        if Value then
            local remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
            local duels = remotes and remotes:WaitForChild("Duels", 5)
            local voteRemote = duels and duels:WaitForChild("Vote", 5)

            if not voteRemote then
                warn("Can not find vote remote!")
                return
            end

            AutoBanWeaponConnection = RunService.RenderStepped:Connect(function()
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                local mainGui = playerGui and playerGui:FindFirstChild("MainGui")
                local mainFrame = mainGui and mainGui:FindFirstChild("MainFrame")

                local duelInterface = mainFrame and mainFrame:FindFirstChild("DuelInterfaces") and mainFrame.DuelInterfaces:FindFirstChild("DuelInterface")

                if duelInterface and duelInterface:FindFirstChild("Voting") then
                    local voting = duelInterface.Voting
                    local weapons = voting:FindFirstChild("Weapons")
                    local container1 = weapons and weapons:FindFirstChild("Container")
                    local list = container1 and container1:FindFirstChild("List")
                    local container2 = list and list:FindFirstChild("Container")

                    if container2 and container2:FindFirstChild("WeaponSlot") then
                        if not hasVoted then
                            hasVoted = true
                            if AutoBanWeaponDropdown1 and AutoBanWeaponDropdown1.Value then
                                voteRemote:FireServer(AutoBanWeaponDropdown1.Value)
                            end
                            if AutoBanWeaponDropdown2 and AutoBanWeaponDropdown2.Value then
                                voteRemote:FireServer(AutoBanWeaponDropdown2.Value)
                            end
                        end
                    end
                else
                    if hasVoted then
                        hasVoted = false
                    end
                end
            end)
        end
    end,
})

AutoBanTab:AddDivider()

local weaponList = {"Assault Rifle", "Distortion", "Permafrost", "Energy Rifle", "Flamethrower", "Grenade Launcher", "Minigun", "Paintball Gun", "Bow", "Burst Rifle", "Crossbow", "Gunblade", "RPG", "Shotgun", "Sniper","Wildcat", "Handgun", "Energy Pistols", "Exogun", "Slingshot", "Daggers", "Flare Gun", "Revolver", "Shorty", "Spray", "Uzi", "Fists", "Katana", "Knife", "Chainsaw", "Riot Shield", "Scythe", "Maul", "Spear", "Trowel", "Battle Axe", "Grenade", "Freeze Ray", "Flashbang", "Jump Pad", "Molotov", "Satchel", "Smoke Grenade", "War Horn", "Grappler", "Medkit", "Subspace Tripmine", "Warpstone"}

AutoBanWeaponDropdown1 = AutoBanTab:AddDropdown("AutoBanWeapon1", {
    Text = "slot 1",
    Values = weaponList,
    Default = 28,
    Multi = false,
})

AutoBanWeaponDropdown2 = AutoBanTab:AddDropdown("AutoBanWeapon2", {
    Text = "slot 2",
    Values = weaponList,
    Default = 31,
    Multi = false,
})

local AutoPick = Tabs.Misc:AddLeftTabbox()
local AutoPickTab = AutoPick:AddTab("auto loadout")

AutoPickTab:AddToggle("Enable_AutoPickWeapon", {
    Text = "enable",
    Default = false,
    Callback = function(Value)
        if AutoPickWeaponConnection then
            AutoPickWeaponConnection:Disconnect()
            AutoPickWeaponConnection = nil
        end
        hasPicked = false

        if Value then
            local weaponPickRemote = ReplicatedStorage:WaitForChild("Remotes", 5)
                and ReplicatedStorage.Remotes:WaitForChild("Replication", 5)
                and ReplicatedStorage.Remotes.Replication:WaitForChild("Fighter", 5)
                and ReplicatedStorage.Remotes.Replication.Fighter:WaitForChild("PickWeapons", 5)

            local prePickRemote = ReplicatedStorage:WaitForChild("Remotes", 5)
                and ReplicatedStorage.Remotes:WaitForChild("Duels", 5)
                and ReplicatedStorage.Remotes.Duels:WaitForChild("PickWeaponsAheadOfTime", 5)

            if not weaponPickRemote then
                warn("Can not find weapon pick remotes!")
                return
            end

            AutoPickWeaponConnection = RunService.RenderStepped:Connect(function()
                local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                local selectionInterface = playerGui and playerGui:FindFirstChild("PickWeapons", true)

                if selectionInterface and selectionInterface.Visible then
                    if not hasPicked then
                        hasPicked = true

                        local payload = {
                            [1] = AutoPickWeaponDropdown1.Value,
                            [2] = AutoPickWeaponDropdown2.Value,
                            [3] = AutoPickWeaponDropdown3.Value,
                            [4] = AutoPickWeaponDropdown4.Value,
                        }

                        pcall(function()
                            weaponPickRemote:FireServer(payload)
                        end)
                        if prePickRemote then
                            pcall(function()
                                prePickRemote:FireServer(payload)
                            end)
                        end
                    end
                else
                    if hasPicked then
                        hasPicked = false
                    end
                end
            end)
        end
    end,
})

AutoPickTab:AddDivider()

AutoPickWeaponDropdown1 = AutoPickTab:AddDropdown("AutoPickWeapon1", {
    Text = "slot 1",
    Values = weaponList,
    Default = 1,
    Multi = false,
})

AutoPickWeaponDropdown2 = AutoPickTab:AddDropdown("AutoPickWeapon2", {
    Text = "slot 2",
    Values = weaponList,
    Default = 17,
    Multi = false,
})

AutoPickWeaponDropdown3 = AutoPickTab:AddDropdown("AutoPickWeapon3", {
    Text = "slot 3 ",
    Values = weaponList,
    Default = 27,
    Multi = false,
})

AutoPickWeaponDropdown4 = AutoPickTab:AddDropdown("AutoPickWeapon4", {
    Text = "slot 4",
    Values = weaponList,
    Default = 37,
    Multi = false,
})

-- Arcade Servers
do
    getgenv().arcade_servers = getgenv().arcade_servers or {
        auto_respawn = false,
        auto_grab_drops = false,
    }

    local AS_Players  = Services.Players
    local AS_Workspace = Services.Workspace
    local AS_RS       = Services.ReplicatedStorage
    local AS_LP       = getgenv().LocalPlayer

    local AS_visitedDrops = {}

    local AS_character, AS_hrp
    local function AS_bindChar(char)
        AS_character = char
        AS_hrp = char:WaitForChild("HumanoidRootPart")
    end
    if AS_LP.Character then AS_bindChar(AS_LP.Character) end
    AS_LP.CharacterAdded:Connect(AS_bindChar)

    local function AS_forceRemoteRespawn()
        pcall(function()
            local remotesFolder = AS_RS:FindFirstChild("Remotes")
            if remotesFolder then
                local duelsFolder = remotesFolder:FindFirstChild("Duels")
                if duelsFolder then
                    local respawnRemote = duelsFolder:FindFirstChild("RespawnNow")
                    if respawnRemote and respawnRemote:IsA("RemoteEvent") then
                        respawnRemote:FireServer()
                    end
                end
            end
        end)
    end

    AS_LP.CharacterAdded:Connect(function(newCharacter)
        local humanoid = newCharacter:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            if not getgenv().arcade_servers.auto_respawn then return end
            task.spawn(function()
                while getgenv().arcade_servers.auto_respawn do
                    local char = AS_LP.Character
                    if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                        break
                    end
                    AS_forceRemoteRespawn()
                    task.wait(0.1)
                end
            end)
        end)
    end)

    local function AS_handleNewDrop(object)
        if not (object:IsA("BasePart") and object.Name == "_drop") then return end
        if AS_visitedDrops[object] then return end
        AS_visitedDrops[object] = true

        if not getgenv().arcade_servers.auto_grab_drops then return end

        task.wait()

        pcall(function()
            if object:IsDescendantOf(AS_Workspace) and AS_hrp and AS_hrp.Parent then
                object.CFrame = AS_hrp.CFrame + Vector3.new(0, 3, 0)
                object.Anchored = true
                object.CanCollide = false
                object.Transparency = 1

                for _, child in pairs(object:GetDescendants()) do
                    if child:IsA("BasePart") or child:IsA("UnionOperation") or child:IsA("MeshPart") then
                        pcall(function()
                            child.Transparency = 1
                            child.CanCollide = false
                        end)
                    elseif child:IsA("BillboardGui") or child:IsA("SurfaceGui") or child:IsA("ParticleEmitter") or child:IsA("SelectionBox") then
                        pcall(function()
                            child.Enabled = false
                        end)
                    end
                end
            end
        end)
    end

    for _, object in ipairs(AS_Workspace:GetDescendants()) do
        if object:IsA("BasePart") and object.Name == "_drop" then
            AS_visitedDrops[object] = true
        end
    end

    AS_Workspace.DescendantAdded:Connect(AS_handleNewDrop)

    local ArcadeTab = Tabs.Misc:AddLeftTabbox():AddTab("arcade servers")

    ArcadeTab:AddToggle("ArcadeAutoRespawn", {
        Text = "auto respawn",
        Tooltip = "auto respawns in some gamemodes",
        Default = false,
        Callback = function(Value)
            getgenv().arcade_servers.auto_respawn = Value
        end
    })

    ArcadeTab:AddToggle("ArcadeAutoGrabDrops", {
        Text = "auto grab drops",
        Tooltip = "auto grabs drops in some gamemodes",
        Default = false,
        Callback = function(Value)
            getgenv().arcade_servers.auto_grab_drops = Value
        end
    })
end
end

-- UI Settings
local MenuGroup = Tabs["UI Settings"]:AddLeftTabbox()

local MenuTab  = MenuGroup:AddTab("Menu")
local NotifTab = MenuGroup:AddTab("Notification")

MenuTab:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift",
    NoUI    = true,
    Text    = "Menu keybind",
})

MenuTab:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible,
    Text    = "Keybind Menu",
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end,
})

MenuTab:AddSlider("KeybindTransparency", {
    Text     = "Keybind Menu Transparency",
    Default  = 0,
    Min      = 0,
    Max      = 1,
    Rounding = 2,
    Callback = function(Value)
        if Library.SetKeybindTransparency then
            Library:SetKeybindTransparency(Value)
        end
    end,
})

NotifTab:AddDropdown("NotifyBarSide", {
    Text = "Notification bar side",
    Values = {"Left", "Right", "Top", "Bottom"},
    Default = Library.NotifyConfig.BarSide or "Left",
    Callback = function(Value)
        Library.NotifyConfig.BarSide = Value
        if Library.UpdateNotifAlignment then
            Library.UpdateNotifAlignment()
        end
    end
})

NotifTab:AddSlider("NotifyTransparency", {
    Text     = "Notification Transparency",
    Default  = 0,
    Min      = 0,
    Max      = 1,
    Rounding = 2,
    Callback = function(Value)
        if Library.SetNotifyTransparency then
            Library:SetNotifyTransparency(Value)
        end
    end,
})

getgenv().NotifyCustomPosition = false

Library.NotifyConfig.AlignX = Library.NotifyConfig.AlignX or (Library.NotifyConfig.Alignment or "Left")
Library.NotifyConfig.AlignY = Library.NotifyConfig.AlignY or "Top"

local AREA_WIDTH = 300

local xSliderObj
local ySliderObj

local function SyncSliders()
    if xSliderObj and xSliderObj.SetValue then
        xSliderObj:SetValue(Library.NotifyConfig.PositionX or 0)
    end
    if ySliderObj and ySliderObj.SetValue then
        ySliderObj:SetValue(Library.NotifyConfig.PositionY or 0)
    end
end

local function CalcPosX()
    local vx = workspace.CurrentCamera.ViewportSize.X
    local ax = Library.NotifyConfig.AlignX or "Left"
    if ax == "Left"   then return 0 end
    if ax == "Center" then return (vx - AREA_WIDTH) / 2 end
    if ax == "Right"  then return vx - AREA_WIDTH end
    return 0
end

local function CalcPosY()
    local vy = workspace.CurrentCamera.ViewportSize.Y
    local ay = Library.NotifyConfig.AlignY or "Top"
    if ay == "Top"    then return 0 end
    if ay == "Center" then return vy / 2 end
    if ay == "Bottom" then return vy end
    return 0
end

local function ApplyFullNotif()
    if getgenv().NotifyCustomPosition then
        if Library.UpdateNotifAlignment then
            Library.UpdateNotifAlignment()
        end
        return
    end

    Library.NotifyConfig.PositionX = CalcPosX()
    Library.NotifyConfig.PositionY = CalcPosY()
    SyncSliders()

    if Library.UpdateNotifAlignment then
        Library.UpdateNotifAlignment()
    end

    local ay = Library.NotifyConfig.AlignY or "Top"
    local area = Library.NotificationArea
    if area then
        if ay == "Center" then
            area.Position = UDim2.new(0, area.Position.X.Offset, 0.5, 0)
        elseif ay == "Bottom" then
            area.Position = UDim2.new(0, area.Position.X.Offset, 1, 0)
        end
    end
end

getgenv().ApplyFullNotif = ApplyFullNotif

NotifTab:AddToggle("NotifyCustomPosition", {
    Text = "Custom position",
    Default = false,
    Callback = function(Value)
        getgenv().NotifyCustomPosition = Value
        if not Value then
            ApplyFullNotif()
        end
    end
})

NotifTab:AddDropdown("NotifyAlignment", {
    Text = "Alignment X",
    Values = {"Left", "Center", "Right"},
    Default = Library.NotifyConfig.AlignX,
    Callback = function(Value)
        Library.NotifyConfig.AlignX = Value
        Library.NotifyConfig.Alignment = Value
        ApplyFullNotif()
    end
})

NotifTab:AddDropdown("NotifyAlignY", {
    Text = "Alignment Y",
    Values = {"Top", "Center", "Bottom"},
    Default = Library.NotifyConfig.AlignY,
    Callback = function(Value)
        Library.NotifyConfig.AlignY = Value
        ApplyFullNotif()
    end
})

xSliderObj = NotifTab:AddSlider("NotifyPosX", {
    Text = "Notification position X",
    Min = -200,
    Max = 2000,
    Default = Library.NotifyConfig.PositionX or 0,
    Rounding = 0,
    Callback = function(Value)
        Library.NotifyConfig.PositionX = Value
        if Library.NotificationArea then
            Library.NotificationArea.Position = UDim2.new(
                0, Library.NotifyConfig.PositionX,
                0, Library.NotifyConfig.PositionY or 40
            )
        end
    end
})

ySliderObj = NotifTab:AddSlider("NotifyPosY", {
    Text = "Notifyotification position Y",
    Min = 0,
    Max = 2000,
    Default = Library.NotifyConfig.PositionY or 40,
    Rounding = 0,
    Callback = function(Value)
        Library.NotifyConfig.PositionY = Value
        if Library.NotificationArea then
            Library.NotificationArea.Position = UDim2.new(
                0, Library.NotifyConfig.PositionX or 0,
                0, Library.NotifyConfig.PositionY
            )
        end
    end
})

local _origNotify = Library.Notify
Library.Notify = function(self, ...)
    ApplyFullNotif()
    return _origNotify(self, ...)
end

task.defer(function()
    task.wait(0.1)
    ApplyFullNotif()
end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("Alacrity/Rivals")
SaveManager:SetFolder("Alacrity/Rivals")

local SaveManagerGroup = Tabs["UI Settings"]:AddRightTabbox()
local SaveManagerTab = SaveManagerGroup:AddTab("Configuration")

SaveManager:BuildConfigSectionTab(SaveManagerTab)

local ThemeGroup = Tabs["UI Settings"]:AddLeftTabbox()
local ThemeTab = ThemeGroup:AddTab("Themes")

ThemeManager:ApplyToGroupbox(ThemeTab)

SaveManager:LoadAutoloadConfig()

else
    return
end