do
    local _Players = game:GetService("Players")
    local _TweenService = game:GetService("TweenService")
    local _ReplicatedStorage = game:GetService("ReplicatedStorage")
    local _player = _Players.LocalPlayer
    local _playerGui = _player:WaitForChild("PlayerGui")
    local _Net = require(_ReplicatedStorage.Modules.Core.Net)

    local FONT = Enum.Font.GothamBold

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "zhXUI"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = _playerGui

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0,320,0,120)
    main.Position = UDim2.fromScale(0.5,0.5)
    main.AnchorPoint = Vector2.new(0.5,0.5)
    main.BackgroundColor3 = Color3.fromRGB(120,0,255)
    main.BackgroundTransparency = 0.2
    main.BorderSizePixel = 0
    main.Parent = screenGui
    Instance.new("UICorner",main).CornerRadius = UDim.new(0,14)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(155,55,255)
    stroke.Thickness = 2
    stroke.Transparency = 0
    stroke.Parent = main

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,34)
    title.Position = UDim2.new(0,0,0,4)
    title.BackgroundTransparency = 1
    title.Text = "Ez tset god mode"
    title.Font = FONT
    title.TextSize = 22
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Parent = main

    local function makeButton(txt,x)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0,130,0,38)
        btn.Position = UDim2.new(0,x,0,62)
        btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
        btn.BackgroundTransparency = 0.35
        btn.Text = txt
        btn.Font = FONT
        btn.TextSize = 16
        btn.TextColor3 = Color3.fromRGB(30,30,30)
        btn.AutoButtonColor = false
        btn.Parent = main
        Instance.new("UICorner",btn).CornerRadius = UDim.new(0,10)
        return btn
    end

    local normalBtn = makeButton("Normal mode", 20)
    local godBtn = makeButton("God mode", 170)

    local Done = false

    local function destroyUI()
        local tw = _TweenService:Create(main, TweenInfo.new(0.22), {
            Size = UDim2.new(0,0,0,0),
            BackgroundTransparency = 1
        })
        tw:Play()
        tw.Completed:Wait()
        screenGui:Destroy()
    end

    local function pressButton(guiObject)
        if not guiObject then return end
        pcall(function() firesignal(guiObject.MouseButton1Click) end)
        pcall(function() firesignal(guiObject.Activated) end)
    end

    normalBtn.MouseButton1Click:Connect(function()
        destroyUI()
        task.spawn(function()
            task.wait(0.5)
            local splashGui = _playerGui:FindFirstChild("SplashScreenGui")
            if splashGui then
                local frame = splashGui:FindFirstChild("Frame")
                local playButton = frame and frame:FindFirstChild("PlayButton")
                pressButton(playButton)
            end
            Done = true
            local characterCreator = _playerGui:FindFirstChild("CharacterCreator")
            if characterCreator then
                local menuFrame = characterCreator:FindFirstChild("MenuFrame")
                local skipButton = menuFrame and menuFrame:FindFirstChild("AvatarMenuSkipButton")
                pressButton(skipButton)
            end
        end)
    end)

    godBtn.MouseButton1Click:Connect(function()
        destroyUI()
        task.spawn(function()
            pcall(function()
                if not _G.Bypass then
                    local func = getupvalue(_Net.get, 2)
                    if func then
                        setconstant(func, 3, "KUYIENGOKUYIENGO")
                        setconstant(func, 4, "KUYIENGOKUYIENGO")
                    end
                    _G.Bypass = true
                end
            end)

            pcall(function()
                local old
                old = hookfunction(_Net.send, function(...)
                    local d = {...}
                    if d[1] == "leave_character_creator" or d[1] == "player_created_outfit" then
                        return nil
                    end
                    return old(...)
                end)
            end)

            task.wait(0.5)
            local splashGui = _playerGui:FindFirstChild("SplashScreenGui")
            if splashGui then
                local frame = splashGui:FindFirstChild("Frame")
                local playButton = frame and frame:FindFirstChild("PlayButton")
                pressButton(playButton)
            end

            task.wait(0.5)
            local characterCreator = _playerGui:FindFirstChild("CharacterCreator")
            if characterCreator then
                local menuFrame = characterCreator:FindFirstChild("MenuFrame")
                local skipButton = menuFrame and menuFrame:FindFirstChild("AvatarMenuSkipButton")
                pressButton(skipButton)
            end

            task.wait(2.5)
            pcall(function()
                replicatesignal(game.Players.LocalPlayer.Kill)
            end)
            task.wait(7)
            pcall(function()
                _Net.send("death_screen_request_respawn")
            end)
            Done = true
        end)
    end)

    repeat task.wait() until Done
end

local Players             = game:GetService("Players")
local RunService          = game:GetService("RunService")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local UserInputService    = game:GetService("UserInputService")
local TweenService        = game:GetService("TweenService")
local Debris              = game:GetService("Debris")
local Workspace           = game:GetService("Workspace")
local ContextActionService = game:GetService("ContextActionService")

local Remotes, Util, BuyPromptUI, EmotesUI, EmotesList, CoreUI, CharModule, Items, MeleeItems
pcall(function() Remotes = ReplicatedStorage:WaitForChild("Remotes", 5) end)
pcall(function() Util = require(ReplicatedStorage.Modules.Core.Util) end)
pcall(function() BuyPromptUI = require(ReplicatedStorage.Modules.Game.UI.BuyPromptUI) end)
pcall(function() EmotesUI = require(ReplicatedStorage.Modules.Game.Emotes.EmotesUI) end)
pcall(function() EmotesList = require(ReplicatedStorage.Modules.Game.Emotes.EmotesList) end)
pcall(function() CoreUI = require(ReplicatedStorage.Modules.Core.UI) end)
pcall(function() CharModule = require(ReplicatedStorage.Modules.Core.Char) end)
pcall(function()
    Items = ReplicatedStorage:WaitForChild("Items", 5)
    MeleeItems = Items and Items:WaitForChild("melee", 5)
end)

local LocalPlayer  = Players.LocalPlayer
local Character    = LocalPlayer.Character
local Humanoid     = Character and Character:FindFirstChild("Humanoid")
local HRP          = Character and Character:FindFirstChild("HumanoidRootPart")
local Camera       = Workspace.CurrentCamera or Workspace:WaitForChild("Camera")

task.spawn(function()
    if not Character then
        Character = LocalPlayer.CharacterAdded:Wait()
    end
    Humanoid = Character:WaitForChild("Humanoid")
    HRP = Character:WaitForChild("HumanoidRootPart")
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HRP = char:WaitForChild("HumanoidRootPart")
end)

local isMobile        = false
local DroppedItems    = Workspace:WaitForChild("DroppedItems")
local itemDrawings    = {}
local espData         = {}
local WeaponRegistry  = {}
local PlayerBillboards = {}
local highlightTable  = {}
local excludedPlayers = {}
local itemPickupTrack = {}
local originalAttribs = {}

local silentAimEnabled    = false
local redLineLockEnabled  = false
local fovRadius           = 9999
local aimTarget           = nil
local shotMultiplier      = 1
local autoShootEnabled    = false
local autoReloadEnabled   = false
local autoShootInterval   = 0.02
local autoShootBurst      = 3
local nameESPEnabled      = false
local distanceESPEnabled  = false
local healthESPEnabled    = false
local inventoryESPEnabled = false
local highlightEnabled    = false
local walkSpeedEnabled    = false
local speedMultiplier     = 0.05
local jumpPowerEnabled    = false
local infiniteStaminaEnabled = false
local antiLockEnabled     = false
local rapidFireEnabled    = false
local rapidFireRate       = 0.01
local _rapidFireRunning   = false
local antiKillEnabled     = false
local autoPickupEnabled   = false
local antiRagdollEnabled  = false
local autoRespawnEnabled  = false
local autoFinishEnabled   = false
local meleeAuraEnabled    = false
local autoAttackEnabled   = false
local skipCrateEnabled    = false
local _snap = { enabled = false, active = false, y = nil, originY = nil, depth = 10, pos = nil, flickering = false }


function isInCameraView(camera, object)
    if object:IsA("BasePart") then
        local objectPosition = object.Position
        local screenPosition, isOnScreen = camera:WorldToViewportPoint(objectPosition)
        return isOnScreen
    end
    return false
end

function loadVisibleObjects(camera, objects)
    for _, object in pairs(objects) do
        if isInCameraView(camera, object) then
            object.Transparency = 0
        else
            object.Transparency = 1
        end
    end
end

local Objects = workspace:GetDescendants()

local function IsAlive(model)
    if not model then return false end
    local Humanoids = model:FindFirstChildOfClass('Humanoid')
    if not Humanoids then return false end
    local RootParts = model:FindFirstChild('HumanoidRootPart')
    if not RootParts then return false end
    return Humanoids.Health > 0
end

local sendEventCounter = 0
local sendFuncCounter  = 0
local smoothTarget    = Vector3.new()
local smoothFactor    = 0.75
local fovCircle       = nil
local redLine         = Drawing.new("Line")
redLine.Thickness     = 1
redLine.Color         = Color3.fromRGB(255, 50, 50)
redLine.Transparency  = 1
redLine.Visible       = false

local getEnv = (type(getgenv) == "function" and getgenv) or function() return _G end

getEnv().Sky        = false
getEnv().SkyAmount  = 1500

local RarityColors = {
    Common    = Color3.fromRGB(255, 255, 255),
    Uncommon  = Color3.fromRGB(99,  255, 52),
    Rare      = Color3.fromRGB(51,  170, 255),
    Epic      = Color3.fromRGB(237, 44,  255),
    Legendary = Color3.fromRGB(255, 150, 0),
    Omega     = Color3.fromRGB(255, 20,  51),
}

local Counter
pcall(function()
    for _, v in ipairs(getgc(true)) do
        if typeof(v) == "table" and rawget(v, "event") and rawget(v, "func") then
            Counter = v
            break
        end
    end
end)

local WindUI
pcall(function()
    WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

local Icons
pcall(function()
    Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/main/Main.lua"))()
    if Icons then
        Icons.SetIconsType("lucide")
    end
end)

local Window
if WindUI then
    Window = WindUI:CreateWindow({
        Title      = "SUPER HUB |  Block Spin",
        Icon = "",
        Author     = "Block spin | Paid",
        Folder     = "superhub",
        Size       = UDim2.fromOffset(650, 400),
        Theme      = "Light",
        Transparent = true,
        Resizable  = true,
        KeyCode    = Enum.KeyCode.G,
    })

    Window:Tag({
        Title  = "v1.0",
        Color  = Color3.fromHex("#30ff6a"),
        Radius = 12,
    })
else
    local tabStub = {
        Section  = function() end,
        Toggle   = function() return { OnChanged = function() end } end,
        Slider   = function() return { OnChanged = function() end } end,
        Button   = function() end,
        Input    = function() return {} end,
        Divider  = function() end,
        Dropdown = function() return { Refresh = function() end } end,
    }
    Window = {
        Tab = function()
            return tabStub
        end,
        ConfigManager = {
            Init = function() end,
            CreateConfig = function()
                return {
                    Register = function() end,
                    Load = function() end,
                    Save = function() end,
                    Delete = function() end,
                }
            end
        }
    }
end

local ConfigManager = Window.ConfigManager
pcall(function()
    if ConfigManager and ConfigManager.Init then
        ConfigManager:Init(Window)
    end
end)
local Config        = ConfigManager:CreateConfig("CathubConfig")

local _CombatTab, _WeaponTab, _ESPTab, _CharTab, _PlayerTab, _BuyTab, _MiscTab
pcall(function()
    _CombatTab = Window:Tab({ Title = "COMBAT:", Icon = "crosshair" })
    _WeaponTab = Window:Tab({ Title = "WEAPON:", Icon = "layers" })
    _ESPTab    = Window:Tab({ Title = "ESP:", Icon = "eye" })
    _CharTab   = Window:Tab({ Title = "CHARACTER:", Icon = "user" })
    _PlayerTab = Window:Tab({ Title = "PLAYER:", Icon = "person-standing" })
    _BuyTab    = Window:Tab({ Title = "BUY:", Icon = "landmark" })
    _MiscTab   = Window:Tab({ Title = "MISC:", Icon = "warehouse" })
end)

local SendRemote
pcall(function()
    SendRemote = ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("Send", 5)
end)

local oldFire
pcall(function()
    if SendRemote and SendRemote.FireServer then
        oldFire = hookfunction(SendRemote.FireServer, function(self, ...)
            if self ~= SendRemote then
                return oldFire(self, ...)
            end
            return oldFire(self, ...)
        end)
    end
end)


local function getPing()
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gui then return 0.2 end
    local stats = gui:FindFirstChild("NetworkStats")
    if not stats then return 0.2 end
    local label = stats:FindFirstChild("PingLabel")
    if not label then return 0.2 end
    local num = tonumber(tostring(label.Text):match("%d+"))
    if not num then return 0.2 end
    local ping = num / 1000
    return (ping < 0 or ping > 2) and 0.2 or ping
end

local function isPlayerExcluded(name)
    for _, entry in ipairs(excludedPlayers) do
        if entry ~= "" and string.find(string.lower(name), string.lower(entry)) then
            return true
        end
    end
    return false
end

local function safeCall(fn, ...)
    local ok, result = pcall(fn, ...)
    return ok, result
end

local unpackTable = table.unpack or unpack

local function callRemote(remote, ...)
    if not remote then return end
    local args = { ... }

    if remote.ClassName == "RemoteEvent" then
        if Counter and type(Counter.event) == "number" then
            Counter.event = Counter.event + 1
            safeCall(function(...) remote:FireServer(Counter.event, ...) end, unpackTable(args))
        else
            sendEventCounter = sendEventCounter + 1
            safeCall(function(...) remote:FireServer(sendEventCounter, ...) end, unpackTable(args))
        end
    elseif remote.ClassName == "RemoteFunction" then
        if Counter and type(Counter.func) == "number" then
            Counter.func = Counter.func + 1
            safeCall(function(...) remote:InvokeServer(Counter.func, ...) end, unpackTable(args))
        else
            sendFuncCounter = sendFuncCounter + 1
            safeCall(function(...) remote:InvokeServer(sendFuncCounter, ...) end, unpackTable(args))
        end
    else
        safeCall(function(...)
            if remote.FireServer   then remote:FireServer(...)   end
            if remote.InvokeServer then remote:InvokeServer(...) end
        end, unpackTable(args))
    end
end

local function netGet(...)
    if not Counter or not Counter.func then return end
    local args = { ... }
    for i, v in ipairs(args) do
        if typeof(v) == "Instance" then
            if v:IsA("Model") and #v:GetChildren() == 0 then
                local dropped = Workspace:FindFirstChild("DroppedItems")
                if dropped then
                    local model = dropped:FindFirstChildWhichIsA("Model")
                    if model then args[i] = model else return end
                else return end
            end
        end
    end
    Counter.func = (Counter.func or 0) + 1
    local ok, result = pcall(function()
        local get = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Get")
        return get:InvokeServer(Counter.func, unpackTable(args))
    end)
    if not ok then warn("[NetGet Error]", result) end
    return result
end

local Send = {}
function Send.send(...)
    local args = { ... }
    Counter.event = Counter.event + 1
    pcall(function()
        Remotes.Send:FireServer(Counter.event, unpackTable(args))
    end)
end


local Network = require(game.ReplicatedStorage.Modules.Core.Net)

local SA_TargetHistory = {}
local SA_AimPart = "Head"
local SA_ShowFOV = false

local fovCircle = Drawing.new("Circle")
fovCircle.Radius = fovRadius
fovCircle.Thickness = 1
fovCircle.Filled = false
fovCircle.Color = Color3.fromRGB(255,255,255)
fovCircle.Visible = SA_ShowFOV

local SA_tracer = Drawing.new("Line")
SA_tracer.Thickness = 2
SA_tracer.Color = Color3.fromRGB(255,0,0)
SA_tracer.Visible = false

local function SA_CreateTracer(startPos,endPos)
	local dist = (endPos - startPos).Magnitude
	local part = Instance.new("Part")
	part.Size = Vector3.new(0.05,0.05,dist)
	part.CFrame = CFrame.new(startPos,endPos) * CFrame.new(0,0,-dist/2)
	part.Anchored = true
	part.CanCollide = false
	part.Material = Enum.Material.Neon
	part.Color = Color3.fromRGB(255,0,0)
	part.Transparency = 0
	part.Parent = workspace
	Debris:AddItem(part,0.15)
end

local function SA_WorldToViewPoint(pos)
	local vp,onScreen = Camera:WorldToViewportPoint(pos)
	return vp,onScreen
end

local function SA_IsAlive(model)
	local hum = model:FindFirstChildOfClass("Humanoid")
	local root = model:FindFirstChild("HumanoidRootPart")
	return hum and root
end

local function SA_IsBehindWall(startPos,endPos,ignore)
	local ray = Ray.new(startPos,endPos-startPos)
	local hit = workspace:FindPartOnRayWithIgnoreList(ray,ignore or {})
	return hit ~= nil
end

local function SA_GetClosestTarget()
	local closest = nil
	local dist = math.huge
	for _,v in pairs(Players:GetPlayers()) do
		if v ~= LocalPlayer and v.Character and SA_IsAlive(v.Character) then
			if not v:GetAttribute("SilentAimIgnore") then
				local root = v.Character:FindFirstChild("HumanoidRootPart")
				if root then
					local pos,onScreen = SA_WorldToViewPoint(root.Position)
					if onScreen then
						local d = (Vector2.new(pos.X,pos.Y) - Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)).Magnitude
						if d < fovRadius and d < dist then
							closest = v.Character
							dist = d
						end
					end
				end
			end
		end
	end
	return closest
end

local function SA_GetVelocity(target,pos)
	local t = tick()
	SA_TargetHistory[target] = SA_TargetHistory[target] or {}
	local hist = SA_TargetHistory[target]
	if #hist >= 3 then table.remove(hist,1) end
	table.insert(hist,{ pos = pos, time = t })
	if #hist < 2 then return Vector3.zero end
	local p1 = hist[#hist - 1]
	local p2 = hist[#hist]
	local dt = math.max(p2.time - p1.time,0.000001)
	return (p2.pos - p1.pos) / dt
end

Players.PlayerRemoving:Connect(function(player)
	SA_TargetHistory[player] = nil
end)

RunService.RenderStepped:Connect(function()
	fovCircle.Position = Vector2.new(
		Camera.ViewportSize.X/2,
		Camera.ViewportSize.Y/2
	)
	fovCircle.Radius = fovRadius
	fovCircle.Visible = SA_ShowFOV

	local target = SA_GetClosestTarget()
	if target then
		local part = target:FindFirstChild(
			SA_AimPart == "Body" and "HumanoidRootPart" or "Head"
		)
		if part then
			local pos,onScreen = SA_WorldToViewPoint(part.Position)
			if onScreen then
				SA_tracer.From = Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
				SA_tracer.To = Vector2.new(pos.X,pos.Y)
				SA_tracer.Visible = redLineLockEnabled
			else
				SA_tracer.Visible = false
			end
		else
			SA_tracer.Visible = false
		end
	else
		SA_tracer.Visible = false
	end
end)

local OldSend

OldSend = hookfunction(Network.send,function(...)
	local args = {...}

	if args[1] == "shoot_gun" and silentAimEnabled then
		local target = SA_GetClosestTarget()

		if target then
			local part = target:FindFirstChild(
				SA_AimPart == "Body" and "HumanoidRootPart" or "Head"
			)

			if part then
				local char = LocalPlayer.Character
				if not char then return OldSend(...) end
				local root = char:FindFirstChild("HumanoidRootPart")
				if not root then return OldSend(...) end

				local myPos = root.Position
				local targetPos = part.Position

				local vel = SA_GetVelocity(target,targetPos)
				local speed = vel.Magnitude
				local predictedPos = targetPos

				if speed <= 250 then
					if speed >= 2 then
						local moveDir = vel.Unit
						predictedPos = targetPos + (moveDir * (speed * 0.15))
					end
				end

				local ignore = {
					LocalPlayer.Character,
					target
				}

				local behind = SA_IsBehindWall(
					myPos,
					predictedPos,
					ignore
				)

				if behind then
					args[3] = CFrame.new(
						math.huge,
						math.huge,
						math.huge
					)
				else
					args[3] = CFrame.new(
						myPos,
						predictedPos
					)
				end

				for _,v in pairs(args[4] or {}) do
					for _,x in pairs(v) do
						x.Position = predictedPos
						x.Instance = part
					end
				end

				SA_CreateTracer(
					myPos,
					predictedPos
				)
			end
		end
	end

	if args[1] == "shoot_gun" and rapidFireEnabled then
		return OldSend(table.unpack(args))
	end

	if args[1] == "shoot_gun" and shotMultiplier > 1 then
		local ok, result = pcall(OldSend, table.unpack(args))
		for _i = 1, shotMultiplier - 1 do
			pcall(OldSend, table.unpack(args))
		end
		if ok then return result end
		return
	end

	return OldSend(table.unpack(args))
end)

_G._autoShootTargets = _G._autoShootTargets or {}
_G._killAllEnabled   = _G._killAllEnabled or false

local function findGunTool(char)
    if not char then return nil end
    for _, v in ipairs(char:GetChildren()) do
        if v:IsA("Tool") and v.Name ~= "Fists" then
            local items = ReplicatedStorage:FindFirstChild("Items")
            if items then
                local gunFolder = items:FindFirstChild("gun")
                if gunFolder and gunFolder:FindFirstChild(v.Name) then
                    return v
                end
            end
        end
    end
    return nil
end

local cachedClosest = nil

local function isShotgunTool(char)
    if not char then return false end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local ammoType = tool:GetAttribute("AmmoType")
            if ammoType == "shotgun" or ammoType == "shootgun" then
                return true
            end
        end
    end
    return false
end

local function getAnyTarget()
    local closest = nil
    local dist = math.huge
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and not isPlayerExcluded(v.Name) and v.Character then
            local hum = v.Character:FindFirstChildOfClass("Humanoid")
            local root = v.Character:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 then
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if myRoot then
                    local d = (root.Position - myRoot.Position).Magnitude
                    if d < dist then
                        closest = v
                        dist = d
                    end
                end
            end
        end
    end
    return closest
end

local _velCache = {}

local function getPlayerVelocity(player)
    local char = player and player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then _velCache[player] = nil; return Vector3.zero end
    local now = tick()
    local curPos = root.Position
    local cached = _velCache[player]
    _velCache[player] = {pos = curPos, t = now}
    if not cached then return Vector3.zero end
    local dt = now - cached.t
    if dt < 0.001 then return Vector3.zero end
    return (curPos - cached.pos) / dt
end

local function fireAtPlayer(player, gunTool, myHead)
    if not player or not player.Character then return end
    local tChar = player.Character
    local hum = tChar:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local head = tChar:FindFirstChild("Head")
    if not head then return end

    local vel      = getPlayerVelocity(player)
    local rawDist  = (head.Position - myHead.Position).Magnitude
    local travelT  = rawDist / 400
    local velMag = vel.Magnitude
    if velMag > 50 then vel = vel.Unit * 50 end
    local aimPos = head.Position + vel * travelT

    local shootCFrame = CFrame.new(math.huge, math.huge, math.huge)

    local hitData = {
        [1] = {
            [1] = {
                Instance = head,
                Normal   = Vector3.new(0, 1, 0),
                Position = aimPos,
            }
        }
    }

    pcall(function()
        if Counter and type(Counter.event) == "number" then
            Counter.event = Counter.event + 1
        else
            sendEventCounter = sendEventCounter + 1
        end
        local ctr = (Counter and Counter.event) or sendEventCounter
        if oldFire and SendRemote then
            oldFire(SendRemote, ctr, "shoot_gun", gunTool, shootCFrame, hitData)
        elseif SendRemote then
            SendRemote:FireServer(ctr, "shoot_gun", gunTool, shootCFrame, hitData)
        elseif Remotes and Remotes.Send then
            Remotes.Send:FireServer(ctr, "shoot_gun", gunTool, shootCFrame, hitData)
        end
    end)
end

local function getGunAmmo(gunTool)
    if not gunTool then return 1, 1 end
    local cur = gunTool:GetAttribute("current_ammo")
    local mx  = gunTool:GetAttribute("max_ammo")
    if cur ~= nil then return cur, (mx or 30) end
    local attrs = gunTool:GetAttributes()
    local keys = {}
    for k in pairs(attrs) do table.insert(keys, k) end
    table.sort(keys)
    for _, k in ipairs(keys) do
        local v = attrs[k]
        if type(v) == "number" and v >= 0 and v <= 500 then
            return v, 30
        end
    end
    return 1, 1 
end

local function doReload(gunTool)
    if Counter and type(Counter.event) == "number" then
        Counter.event = Counter.event + 1
    else
        sendEventCounter = sendEventCounter + 1
    end
    local ctr = (Counter and Counter.event) or sendEventCounter
    if oldFire and SendRemote then
        pcall(function() oldFire(SendRemote, ctr, "reload_gun", gunTool) end)
    elseif SendRemote then
        pcall(function() SendRemote:FireServer(ctr, "reload_gun", gunTool) end)
    elseif Remotes and Remotes.Send then
        pcall(function() Remotes.Send:FireServer(ctr, "reload_gun", gunTool) end)
    end
end

task.spawn(function()
    while true do
        task.wait(autoShootInterval)
        if (autoShootEnabled or _G._killAllEnabled) then
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                local myHead = char:FindFirstChild("Head")
                if not myHead then return end
                local gunTool = findGunTool(char)
                if not gunTool then return end

                local ammo = getGunAmmo(gunTool)
                if ammo <= 0 then
                    doReload(gunTool)
                    return 
                end

                if _G._killAllEnabled then
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and not isPlayerExcluded(player.Name) and player.Character then
                            local hum = player.Character:FindFirstChildOfClass("Humanoid")
                            if hum then
                                fireAtPlayer(player, gunTool, myHead)
                            end
                        end
                    end
                elseif #_G._autoShootTargets > 0 then
                    for _, targetName in ipairs(_G._autoShootTargets) do
                        local player = Players:FindFirstChild(targetName)
                        if player and player ~= LocalPlayer and player.Character then
                            fireAtPlayer(player, gunTool, myHead)
                        end
                    end
                else
                    local targetChar = SA_GetClosestTarget()
                    if targetChar then
                        local targetPlayer = Players:GetPlayerFromCharacter(targetChar)
                        if targetPlayer and targetPlayer ~= LocalPlayer then
                            fireAtPlayer(targetPlayer, gunTool, myHead)
                        end
                    end
                end
            end)
        end
    end
end)

local _rapidFireConn = nil

local function startRapidFire()
    if _rapidFireConn then pcall(function() _rapidFireConn:Disconnect() end) end
    _rapidFireConn = RunService.Heartbeat:Connect(function()
        if not rapidFireEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and isGunTool(tool) then
                pcall(function()
                    tool:SetAttribute(FindFireRateAttribute(tool), 9999)
                    tool:SetAttribute("automatic", true)
                end)
            end
        end
    end)
end
startRapidFire()

task.spawn(function()
    while true do
        task.wait(0.15)
        if autoReloadEnabled then
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                local gunTool = findGunTool(char)
                if not gunTool then return end
                local ok, parent = pcall(function() return gunTool.Parent end)
                if not ok or parent ~= char then return end
                if Counter and type(Counter.event) == "number" then
                    Counter.event = Counter.event + 1
                else
                    sendEventCounter = sendEventCounter + 1
                end
                local ctr = (Counter and Counter.event) or sendEventCounter
                if oldFire and SendRemote then
                    oldFire(SendRemote, ctr, "reload_gun", gunTool)
                elseif Remotes and Remotes.Send then
                    Remotes.Send:FireServer(ctr, "reload_gun", gunTool)
                end
            end)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    pcall(function()

        local closestPlayer = cachedClosest
        aimTarget = (silentAimEnabled or redLineLockEnabled) and closestPlayer or nil

        if fovCircle then
            if silentAimEnabled then
                if isMobile then
                    fovCircle.Visible = true
                    fovCircle.Position = UDim2.fromScale(0.5, 0.5)
                    fovCircle.Size = UDim2.fromOffset(fovRadius * 2, fovRadius * 2)
                else
                    local Center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local t = tick()

                    for i = 1, fovCircle._segments do
                        local angle1 = math.rad((i - 1) * (360 / fovCircle._segments))
                        local angle2 = math.rad(i * (360 / fovCircle._segments))

                        fovCircle._lines[i].From = Center + Vector2.new(math.cos(angle1) * fovRadius, math.sin(angle1) * fovRadius)
                        fovCircle._lines[i].To   = Center + Vector2.new(math.cos(angle2) * fovRadius, math.sin(angle2) * fovRadius)

                        fovCircle._lines[i].Color = Color3.fromHSV(((i / fovCircle._segments) + t * 0.5) % 1, 1, 1)
                        fovCircle._lines[i].Visible = true
                    end
                end
            elseif not isMobile then
                for i = 1, fovCircle._segments do
                    fovCircle._lines[i].Visible = false
                end
            elseif isMobile then
                fovCircle.Visible = false
            end
        end

        if closestPlayer and closestPlayer.Character and (silentAimEnabled or redLineLockEnabled) then
            local head = getAimPart(closestPlayer.Character)
            if head then
                local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                local targetPos = head.Position

                if smoothTarget.Magnitude < 1 then
                    smoothTarget = targetPos
                else
                    smoothTarget = smoothTarget:Lerp(targetPos, smoothFactor)
                end

                local screenPos, visible = Camera:WorldToViewportPoint(smoothTarget)
                if visible then
                    redLine.Visible = true
                    redLine.From = center
                    redLine.To = Vector2.new(screenPos.X, screenPos.Y)
                    redLine.Color = Color3.fromRGB(255, 50, 50)
                    redLine.Thickness = 1.3
                else
                    redLine.Visible = false
                    smoothTarget = Vector3.new()
                end
            else
                redLine.Visible = false
                smoothTarget = Vector3.new()
            end
        else
            redLine.Visible = false
            smoothTarget = Vector3.new()
        end

    end)
end)

local jumpConn
local function setupCharacter(char)
    Character = char
    Humanoid  = char:WaitForChild("Humanoid")
    HRP       = char:WaitForChild("HumanoidRootPart")
    if jumpConn then pcall(function() jumpConn:Disconnect() end) end
    jumpConn = RunService.RenderStepped:Connect(function()
        if walkSpeedEnabled and Humanoid and HRP then
            if Humanoid.MoveDirection.Magnitude > 0 then
                HRP.CFrame = HRP.CFrame + (Humanoid.MoveDirection.Unit * speedMultiplier)
            end
        end
    end)
end

local function isDowned()
    local hum = CharModule.get_hum()
    if not hum or hum.Health <= 0 then return false end
    return hum:GetAttribute("HasBeenDowned") or hum:GetAttribute("IsDead")
end

local function getHRP()
    local char = CharModule.current_char.get()
    if not char then return end
    return char:FindFirstChild("HumanoidRootPart")
end

local function teleportUnderground()
    local root = getHRP()
    if not root then return end
    _snap.pos = root.CFrame + Vector3.new(0, -40, 0)
    root.CFrame = _snap.pos
end

local function flickerAndMove()
    if _snap.flickering then return end
    _snap.flickering = true
    task.spawn(function()
        while _snap.flickering and antiKillEnabled and isDowned() do
            local hum = CharModule.get_hum()
            if hum and hum.Health <= 0 then break end
            local root = getHRP()
            if root and _snap.pos then
                local angle = math.random() * math.pi * 2
                local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * 10
                root.CFrame = CFrame.new(_snap.pos.Position + offset)
                task.wait(0.05)
                root.CFrame = _snap.pos
            end
            task.wait(0.1)
        end
        _snap.flickering = false
    end)
end

RunService.Heartbeat:Connect(function()
    if not antiKillEnabled then return end
    if isDowned() then
        local root = getHRP()
        if root and not _snap.pos then
            teleportUnderground()
        end
        flickerAndMove()
    else
        if _snap.pos then
            local root = getHRP()
            if root then root.CFrame = _snap.pos + Vector3.new(0, 40, 0) end
        end
        _snap.pos = nil
        _snap.flickering = false
    end
end)

local _antiLockConn = nil

local function stopAntiLock()
    if _antiLockConn then
        pcall(function() _antiLockConn:Disconnect() end)
        _antiLockConn = nil
    end
    local char = LocalPlayer.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root.Velocity = Vector3.new(0, 0, 0)
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = 50
        end
    end
end

local function startAntiLock()
    stopAntiLock()
    _antiLockConn = RunService.Heartbeat:Connect(function()
        if not antiLockEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local prevVel = root.Velocity
        local angle   = math.rad(tick() * 1500 % 360)
        local amount  = getEnv().SkyAmount
        root.Velocity = Vector3.new(math.cos(angle) * amount, math.random(280, 480), math.sin(angle) * amount)
        RunService.RenderStepped:Wait()
        if not antiLockEnabled then
            root.Velocity = Vector3.new(0, 0, 0)
            return
        end
        root.Velocity = prevVel
    end)
end


local function checkAndPickup()
    if not autoPickupEnabled then return end
    local dropped = Workspace:FindFirstChild("DroppedItems")
    if not dropped then return end
    local now  = tick()
    local toPickup = {}
    for _, model in ipairs(dropped:GetChildren()) do
        if model:IsA("Model") then
            local part = model:FindFirstChildWhichIsA("BasePart")
            if part then
                local dist = (HRP.Position - part.Position).Magnitude
                if dist <= 20 and (now - (itemPickupTrack[model] or 0)) >= 0 then
                    table.insert(toPickup, model)
                    itemPickupTrack[model] = now
                end
            end
        end
    end
    for _, model in ipairs(toPickup) do
        spawn(function() netGet("pickup_dropped_item", model) end)
    end
end

RunService.Heartbeat:Connect(function()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        HRP = Character:WaitForChild("HumanoidRootPart")
    end
    pcall(checkAndPickup)
end)

local function getPlayersInRange(range)
    local result = {}
    local myChar = LocalPlayer.Character
    if not myChar or not myChar.PrimaryPart then return result end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character.PrimaryPart then
            local ok, dist = pcall(function()
                return (player.Character.PrimaryPart.Position - myChar.PrimaryPart.Position).Magnitude
            end)
            if ok and dist and dist <= 20 then
                table.insert(result, player)
            end
        end
    end
    return result
end

local function getActiveTool()
    local char = LocalPlayer.Character
    if char then
        for _, v in ipairs(char:GetChildren()) do
            if pcall(function() return v:IsA("Tool") end) and v:IsA("Tool") then
                return v
            end
        end
    end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, v in ipairs(backpack:GetChildren()) do
            if pcall(function() return v:IsA("Tool") end) and v:IsA("Tool") then
                return v
            end
        end
    end
    return nil
end

local function isMeleeToolCheck(tool)
    if not tool then return false end
    if tool.Name == "Fists" then return true end
    local itemsFolder = ReplicatedStorage:FindFirstChild("Items")
    if not itemsFolder then return false end
    local meleeFolder    = itemsFolder:FindFirstChild("melee")
    local throwableFolder = itemsFolder:FindFirstChild("throwable")
    if not meleeFolder or not throwableFolder then return false end
    return meleeFolder:FindFirstChild(tool.Name) and not throwableFolder:FindFirstChild(tool.Name)
end

local function attackNearby()
    if not SendRemote then return end
    local myChar = LocalPlayer.Character
    if not myChar or not myChar.PrimaryPart then return end
    local tool = getActiveTool()
    if not tool or not isMeleeToolCheck(tool) then return end
    local ok, parent = pcall(function() return tool.Parent end)
    if not ok or parent ~= LocalPlayer.Character then return end
    local nearby = getPlayersInRange(20)
    if #nearby == 0 then return end
    local ok2, myPos = pcall(function() return myChar.PrimaryPart.Position end)
    if not ok2 or not myPos then return end
    local targets, positions = {}, {}
    for _, player in pairs(nearby) do
        if player and player.Character and player.Character.PrimaryPart then
            local head = player.Character:FindFirstChild("Head")
            local root = player.Character.PrimaryPart
            if head and root then
                local aimPos = sirenAimPos(head, player.Character)
                table.insert(targets, player)
                table.insert(positions, aimPos)
            end
        end
    end
    if #targets == 0 then return end
    local lookAt = CFrame.lookAt(myPos, positions[1])
    pcall(function()
        callRemote(SendRemote, unpackTable({ "melee_attack", tool, targets, lookAt, 0.75 }))
    end)
end

local autoAttackRunning = false
local function startAutoAttack()
    if autoAttackRunning then return end
    autoAttackRunning = true
    task.spawn(function()
        while autoAttackRunning do
            task.wait(0.4)
            if autoAttackEnabled and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
                pcall(attackNearby)
            end
        end
    end)
end

local function performTeleport()
    if not HRP then return end
    local pos = HRP.Position
    if not _snap.originY then
        _snap.originY = pos.Y
    end
    local destY = _snap.originY - _snap.depth
    local dest = Vector3.new(pos.X, destY, pos.Z)
    HRP.CFrame = CFrame.new(dest)
    _snap.y = destY
    local sound = Instance.new("Sound")
    sound.SoundId     = "rbxassetid://95298029662868"
    sound.Volume      = 1
    sound.PlayOnRemove = true
    sound.Parent      = HRP
    sound:Destroy()
end

local function toggleSnap()
    if not _snap.enabled then return end
    _snap.active = not _snap.active
    if _snap.active then
        performTeleport()
    else
        _snap.y = nil
    end
end

local snapConn
local function lockYPosition()
    if snapConn then pcall(function() snapConn:Disconnect() end) end
    snapConn = RunService.Heartbeat:Connect(function()
        if _snap.active and _snap.y and HRP then
            local pos = HRP.Position
				if math.abs(pos.Y - _snap.y) > 0.1 then
                HRP.CFrame = CFrame.new(pos.X, _snap.y, pos.Z)
            end
        end
    end)
end

local function setFinishPrompt(prompt)
    if prompt and prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = 1
        prompt.MaxActivationDistance = 20
    end
end

local function tryHoldPrompt(prompt, duration)
    if not prompt or prompt:GetAttribute("__AutoFinishBusy") then return end
    prompt:SetAttribute("__AutoFinishBusy", true)
    pcall(function() if prompt.InputHoldBegin then prompt:InputHoldBegin() end end)
    pcall(function() if prompt.HoldBegin      then prompt:HoldBegin()      end end)
    pcall(function() if prompt.Trigger        then prompt:Trigger()        end end)
    task.wait(duration)
    pcall(function() if prompt.InputHoldEnd then prompt:InputHoldEnd() end end)
    pcall(function() if prompt.HoldEnd      then prompt:HoldEnd()      end end)
    prompt:SetAttribute("__AutoFinishBusy", nil)
end

local function findFinishPrompts()
    local result = {}
    for _, child in pairs(Workspace:GetChildren()) do
        local player = Players:GetPlayerFromCharacter(child)
        if player and not isPlayerExcluded(player.Name) then
            local root = child:FindFirstChild("HumanoidRootPart")
            if root then
                local prompt = root:FindFirstChild("FinishPrompt")
                if prompt then
                    setFinishPrompt(prompt)
                    table.insert(result, prompt)
                end
            end
        end
    end
    return result
end

local function applyToAll()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local prompt = root:FindFirstChild("FinishPrompt")
                if prompt then setFinishPrompt(prompt) end
            end
        end
    end
end

local function setupFastFinishForPlayer(player)
    if player == LocalPlayer then return end
    player.CharacterAdded:Connect(function(char)
        char.DescendantAdded:Connect(function(inst)
            if autoFinishEnabled and inst.Name == "FinishPrompt"
                and inst:IsA("ProximityPrompt")
                and inst.Parent and inst.Parent.Name == "HumanoidRootPart" then
                setFinishPrompt(inst)
            end
        end)
        local root = char:WaitForChild("HumanoidRootPart", 5)
        if root and autoFinishEnabled then
            local prompt = root:FindFirstChild("FinishPrompt")
            if prompt then setFinishPrompt(prompt) end
        end
    end)
end

for _, player in ipairs(Players:GetPlayers()) do setupFastFinishForPlayer(player) end
Players.PlayerAdded:Connect(setupFastFinishForPlayer)

task.spawn(function()
    while true do
        task.wait(0.4)
        if autoFinishEnabled then
            for _, prompt in ipairs(findFinishPrompts()) do
                task.spawn(function() tryHoldPrompt(prompt, 1) end)
            end
        end
    end
end)

local CrateController
pcall(function() CrateController = require(ReplicatedStorage.Modules.Game.CrateSystem.Crate) end)
task.spawn(function()
    while true do
        if skipCrateEnabled and CrateController then
            pcall(function()
                for _, crate in pairs(CrateController.class.objects) do
                    crate.states.open.set(true)
                    CrateController.skipping.set(true)
                end
            end)
        end
        task.wait(0.05)
    end
end)

local ActivePlayerESPs = {}

local MeshDB = {}
local MeshDBLoaded = false
local function LoadMeshDB()
    if MeshDBLoaded then return end
    MeshDBLoaded = true
    if not Items then return end
    local function scan(folder)
        for _, item in ipairs(folder:GetChildren()) do
            if item:IsA("Tool") then
                local handle = item:FindFirstChild("Handle")
                local dName = item:GetAttribute("DisplayName") or item:GetAttribute("ItemName") or item.Name
                if tonumber(dName) then
                    for _, cd in ipairs(item:GetChildren()) do
                        if cd:IsA("StringValue") and (cd.Name == "ItemName" or cd.Name == "WeaponName" or cd.Name == "DisplayName") then
                            dName = cd.Value; break
                        end
                    end
                end
                if handle then
                    local mesh = handle:FindFirstChildOfClass("SpecialMesh")
                    if mesh and mesh.MeshId ~= "" then
                        MeshDB[mesh.MeshId] = dName
                        if mesh.TextureId ~= "" then MeshDB[mesh.MeshId .. mesh.TextureId] = dName end
                    elseif handle:IsA("MeshPart") and handle.MeshId ~= "" then
                        MeshDB[handle.MeshId] = dName
                        if handle.TextureID ~= "" then MeshDB[handle.MeshId .. handle.TextureID] = dName end
                    end
                end
            elseif item:IsA("Folder") then
                scan(item)
            end
        end
    end
    pcall(function() scan(Items) end)
end

local ItemNameCache = setmetatable({}, {__mode = "k"})
local function GetItemRealName(tool)
    if ItemNameCache[tool] then return ItemNameCache[tool] end
    local name = tostring(tool.Name)
    local attr = tool:GetAttribute("ItemName") or tool:GetAttribute("DisplayName")
    if attr then name = tostring(attr) end
    if tonumber(name) and tool:IsA("Tool") and tool.ToolTip and tool.ToolTip ~= "" then
        name = tool.ToolTip
    end
    if tonumber(name) then
        LoadMeshDB()
        local handle = tool:FindFirstChild("Handle") or tool
        if handle then
            local mesh = handle:FindFirstChildOfClass("SpecialMesh")
            if mesh and mesh.MeshId ~= "" then
                local res = MeshDB[mesh.MeshId .. (mesh.TextureId or "")] or MeshDB[mesh.MeshId]
                if res then name = res end
            elseif handle:IsA("MeshPart") and handle.MeshId ~= "" then
                local res = MeshDB[handle.MeshId .. (handle.TextureID or "")] or MeshDB[handle.MeshId]
                if res then name = res end
            end
        end
    end
    if tonumber(name) then
        for _, child in ipairs(tool:GetChildren()) do
            if child:IsA("StringValue") and (child.Name == "ItemName" or child.Name == "WeaponName" or child.Name == "DisplayName") then
                name = child.Value; break
            end
        end
    end
    local cleaned = string.gsub(tostring(name), "[Ii][Tt][Ee][Mm]", "")
    cleaned = string.match(cleaned, "^%s*(.-)%s*$")
    local finalName = (cleaned ~= "" and cleaned) or name
    ItemNameCache[tool] = finalName
    return finalName
end

local RarityColorsESP = {
    ["Common"]    = Color3.fromRGB(200, 200, 200),
    ["Uncommon"]  = Color3.fromRGB(99, 255, 52),
    ["Rare"]      = Color3.fromRGB(51, 170, 255),
    ["Epic"]      = Color3.fromRGB(237, 44, 255),
    ["Legendary"] = Color3.fromRGB(255, 150, 0),
    ["Omega"]     = Color3.fromRGB(255, 20, 51),
}

local function CreateESPText(color)
    local t = Drawing.new("Text")
    t.Size = 13
    t.Center = true
    t.Outline = true
    t.OutlineColor = Color3.new(0, 0, 0)
    t.Color = color or Color3.new(1, 1, 1)
    t.Font = 2
    t.Visible = false
    return t
end

local function DestroyESPData(data)
    if not data then return end
    pcall(function() if data.text then data.text:Remove() end end)
    pcall(function() if data.highlight then data.highlight:Destroy() end end)
    if data.invTexts then
        for _, d in ipairs(data.invTexts) do pcall(function() d:Remove() end) end
    end
end

local function TrimInvDraw(data, keepCount)
    if not data.invTexts then return end
    for i = #data.invTexts, keepCount + 1, -1 do
        pcall(function() data.invTexts[i]:Remove() end)
        data.invTexts[i] = nil
    end
end

local function GetPlayerTools(player)
    local out = {}
    local bp = player:FindFirstChild("Backpack")
    if bp then
        for _, item in ipairs(bp:GetChildren()) do
            if item:IsA("Tool") and item.Name ~= "Fists" then out[#out + 1] = item end
        end
    end
    local char = player.Character
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and item.Name ~= "Fists" then out[#out + 1] = item end
        end
    end
    return out
end

Players.PlayerRemoving:Connect(function(player)
    if ActivePlayerESPs[player] then
        DestroyESPData(ActivePlayerESPs[player])
        ActivePlayerESPs[player] = nil
    end
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        local anyESP = nameESPEnabled or distanceESPEnabled or healthESPEnabled or inventoryESPEnabled or highlightEnabled
        if not anyESP then
            for _, data in pairs(ActivePlayerESPs) do
                if data.text then data.text.Visible = false end
                if data.invTexts then for _, d in ipairs(data.invTexts) do d.Visible = false end end
                if data.highlight then data.highlight.Enabled = false end
            end
        else
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    pcall(function()
                        local char = p.Character
                        local hum = char and char:FindFirstChildOfClass("Humanoid")
                        local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head"))

                        if char and hum and root and hum.Health > 0 then
                            if not ActivePlayerESPs[p] then
                                local nameText = CreateESPText(Color3.new(1, 1, 1))
                                local hl = nil
                                pcall(function()
                                    hl = Instance.new("Highlight")
                                    hl.FillTransparency = 0.5
                                    hl.OutlineTransparency = 0
                                    hl.Enabled = false
                                    hl.Parent = game.CoreGui
                                end)
                                ActivePlayerESPs[p] = {text = nameText, invTexts = {}, lastStr = "", rootPart = nil, highlight = hl}
                            end

                            local data = ActivePlayerESPs[p]
                            data.rootPart = root

                            if data.highlight then
                                if highlightEnabled then
                                    data.highlight.Enabled = true
                                    data.highlight.Adornee = char
                                    local hpPct = hum.Health / math.max(hum.MaxHealth, 1)
                                    data.highlight.FillColor = Color3.fromRGB(255 * (1 - hpPct), 255 * hpPct, 0)
                                else
                                    data.highlight.Enabled = false
                                end
                            end

                            local dist = 0
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude)
                            end
                            local health = math.floor(hum.Health)
                            local maxHealth = math.floor(hum.MaxHealth)

                            local espColor = Color3.new(1, 1, 1)
                            local inSafe = p:GetAttribute("IsInSafeZone") or (char and char:GetAttribute("IsInSafeZone"))
                            local inSplash = p:GetAttribute("InSplashScreen") or (char and char:GetAttribute("InSplashScreen"))
                            if inSplash then espColor = Color3.fromRGB(0, 200, 255)
                            elseif inSafe then espColor = Color3.fromRGB(0, 255, 0)
                            elseif isPlayerExcluded(p.Name) then espColor = Color3.fromRGB(0, 255, 0)
                            elseif aimTarget == p then espColor = Color3.fromRGB(255, 0, 0) end

                            local parts = {}
                            if distanceESPEnabled then table.insert(parts, string.format("[%dm]", dist)) end
                            if nameESPEnabled then table.insert(parts, p.Name) end
                            if healthESPEnabled then table.insert(parts, string.format("[%d/%d]", health, maxHealth)) end

                            local newStr = table.concat(parts, " ")
                            if newStr ~= data.lastStr then
                                data.text.Text = newStr
                                data.lastStr = newStr
                            end
                            data.text.Color = espColor
                            data.showText = (#parts > 0)

                            if inventoryESPEnabled then
                                local tools = GetPlayerTools(p)
                                for i = 1, #tools do
                                    if not data.invTexts[i] then
                                        local draw = CreateESPText(Color3.fromRGB(200, 200, 200))
                                        draw.Size = 11
                                        data.invTexts[i] = draw
                                    end
                                    local invDraw = data.invTexts[i]
                                    local rarity = tools[i]:GetAttribute("RarityName") or "Common"
                                    local color = RarityColorsESP[rarity] or Color3.fromRGB(200, 200, 200)
                                    local equipped = tools[i].Parent == char and " [E]" or ""
                                    local itemText = "[" .. GetItemRealName(tools[i]) .. equipped .. "]"
                                    if invDraw.Text ~= itemText then invDraw.Text = itemText end
                                    invDraw.Color = color
                                end
                                TrimInvDraw(data, #tools)
                            else
                                if data.invTexts then
                                    for _, d in ipairs(data.invTexts) do d.Visible = false end
                                end
                            end
                        elseif ActivePlayerESPs[p] then
                            ActivePlayerESPs[p].text.Visible = false
                            if ActivePlayerESPs[p].invTexts then
                                for _, d in ipairs(ActivePlayerESPs[p].invTexts) do d.Visible = false end
                            end
                            if ActivePlayerESPs[p].highlight then ActivePlayerESPs[p].highlight.Enabled = false end
                        end
                    end)
                end
            end
        end

        for pl, _ in pairs(ActivePlayerESPs) do
            if not pl or not pl.Parent then
                DestroyESPData(ActivePlayerESPs[pl])
                ActivePlayerESPs[pl] = nil
            end
        end
    end
end)

local _espFrame = 0
RunService.RenderStepped:Connect(function()
    _espFrame = _espFrame + 1
    if _espFrame % 2 ~= 0 then return end
    local anyESP = nameESPEnabled or distanceESPEnabled or healthESPEnabled or inventoryESPEnabled or highlightEnabled
    if not anyESP then return end

    for _, data in pairs(ActivePlayerESPs) do
        if data.text and data.rootPart and data.rootPart.Parent then
            local anchor = data.rootPart.Position + (data.rootPart.Name == "Head" and Vector3.new(0, 1.5, 0) or Vector3.new(0, 3, 0))
            local pos, onScreen = Camera:WorldToViewportPoint(anchor)
            if data.showText then
                data.text.Visible = onScreen
            else
                data.text.Visible = false
            end
            if onScreen then
                data.text.Position = Vector2.new(pos.X, pos.Y)
                if data.invTexts and inventoryESPEnabled then
                    for i, invDraw in ipairs(data.invTexts) do
                        invDraw.Visible = true
                        invDraw.Position = Vector2.new(pos.X, pos.Y + 14 + ((i - 1) * 13))
                    end
                elseif data.invTexts then
                    for _, invDraw in ipairs(data.invTexts) do invDraw.Visible = false end
                end
            else
                if data.invTexts then
                    for _, invDraw in ipairs(data.invTexts) do invDraw.Visible = false end
                end
            end
        end
    end
end)

local ItemCamera
repeat task.wait() until Workspace.CurrentCamera
ItemCamera = Workspace.CurrentCamera

local function getRarityColor(model)
    if model.Name == "Money" then
        return Color3.fromRGB(0, 255, 0)
    end

    for _, folder in ipairs(Items:GetChildren()) do
        if folder:IsA("Folder") then
            local item = folder:FindFirstChild(model.Name)

            if item and item:GetAttribute("RarityName") then
                return RarityColors[item:GetAttribute("RarityName")] or Color3.fromRGB(255,255,255)
            end
        end
    end

    return Color3.fromRGB(255,255,255)
end

local function cleanupItemDrawings()
    for model, data in pairs(itemDrawings) do
        if not model or not model.Parent then
            pcall(function() data.name:Remove() end)
            pcall(function() data.amount:Remove() end)
            pcall(function() data.highlight:Remove() end)

            itemDrawings[model] = nil
        end
    end
end

RunService.RenderStepped:Connect(function()
    cleanupItemDrawings()

    if not DroppedItems then return end

    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    for _, data in pairs(itemDrawings) do
        data.name.Visible = false
        data.amount.Visible = false
        data.highlight.Enabled = false
    end

    local visible = {}

    for _, model in ipairs(DroppedItems:GetChildren()) do
        if model:IsA("Model")
        and model:FindFirstChild("PickUpZone")
        and not model:GetAttribute("Locked") then

            local ok, zonePos = pcall(function()
                return model.PickUpZone.Position
            end)

            if ok and zonePos then
                table.insert(visible, {
                    item = model,
                    dist = (zonePos - myRoot.Position).Magnitude
                })
            end
        end
    end

    table.sort(visible, function(a, b)
        return a.dist < b.dist
    end)

    for i = 1, math.min(20, #visible) do
        local model = visible[i].item
        local data = itemDrawings[model]

        if not data then
            local hl = Instance.new("Highlight")
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.FillTransparency = 0.6
            hl.OutlineTransparency = 0
            hl.Adornee = model
            hl.Parent = model

            data = {
                name      = Drawing.new("Text"),
                amount    = Drawing.new("Text"),
                highlight = hl
            }

            data.name.Outline      = true
            data.name.OutlineColor = Color3.fromRGB(0, 0, 0)
            data.name.Center       = true
            data.name.Size         = 13
            data.name.Font         = 2

            data.amount.Outline      = true
            data.amount.OutlineColor = Color3.fromRGB(0, 0, 0)
            data.amount.Center       = true
            data.amount.Size         = 11
            data.amount.Font         = 2
            data.amount.Color        = Color3.fromRGB(200, 200, 200)

            itemDrawings[model] = data
        end

        local pos, vis = ItemCamera:WorldToViewportPoint(model.PickUpZone.Position)

        if vis then
            local color = getRarityColor(model)

            data.highlight.OutlineColor = color
            data.highlight.FillColor    = color
            data.highlight.Enabled      = true

            data.name.Color    = color
            data.name.Position = Vector2.new(pos.X, pos.Y)
            data.name.Text     = model.Name
            data.name.Visible  = true

            local amt = model:GetAttribute("Amount") or 1
            data.amount.Position = Vector2.new(pos.X, pos.Y + 15)
            data.amount.Text     = amt > 1 and "["..tostring(amt).."]" or ""
            data.amount.Visible  = amt > 1
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        for _, data in pairs(itemDrawings) do
            pcall(function() data.name:Remove() end)
            pcall(function() data.amount:Remove() end)
            pcall(function() data.highlight:Remove() end)
        end

        itemDrawings = {}
    end
end)

local GunItems = Items and Items:FindFirstChild("gun")
if not GunItems then
    GunItems = Items and Items:WaitForChild("gun", 5)
end

getEnv().FireRateValue  = 1000
getEnv().AccuracyValue  = 1
getEnv().RecoilValue    = 0
getEnv().Durability     = 999999999
getEnv().AutoValue      = true
getEnv().GunModsAutoApply = false

local function isGunTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    return (GunItems and GunItems:FindFirstChild(tool.Name) ~= nil) or tool.Name:match("Gun") or tool:FindFirstChild("Handle")
end

local function forceSetAttr(tool, attr, val)
    if tool and tool.SetAttribute then
        pcall(function() tool:SetAttribute(attr, val) end)
    end
end

local function FindFireRateAttribute(gun)
    if not gun then return "fire_rate" end
    if gun:GetAttribute("fire_rate") ~= nil then return "fire_rate" end
    for attrName in pairs(gun:GetAttributes()) do
        if type(attrName) == "string" and attrName:sub(-3) == "486" then
            return attrName
        end
    end
    return "fire_rate"
end

local function applyGodGun(tool)
    if not tool or not isGunTool(tool) then return end
    pcall(function()
        tool:SetAttribute(FindFireRateAttribute(tool), getEnv().FireRateValue)
        tool:SetAttribute("accuracy",   getEnv().AccuracyValue)
        tool:SetAttribute("Recoil",     getEnv().RecoilValue)
        tool:SetAttribute("Durability", getEnv().Durability)
        tool:SetAttribute("automatic",  getEnv().AutoValue)
    end)
    task.spawn(function()
        for _ = 1, 20 do
            local attrs = tool:GetAttributes()
            local keys = {}
            for k in pairs(attrs) do table.insert(keys, k) end
            table.sort(keys)
            if #keys >= 11 then
                local targetKey = keys[11]
                for _ = 1, 5 do forceSetAttr(tool, targetKey, true); task.wait(0.01) end
            end
            task.wait(0.1)
        end
    end)
end

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    if getEnv().GunModsAutoApply then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and isGunTool(tool) then pcall(applyGodGun, tool) end
        end
    end
    if rapidFireEnabled then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and isGunTool(tool) then
                pcall(function()
                    tool:SetAttribute(FindFireRateAttribute(tool), 9999)
                    tool:SetAttribute("automatic", true)
                end)
            end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    repeat
        task.wait(0.1)
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and isGunTool(tool) then task.spawn(applyGodGun, tool) end
        end
    until not getEnv().GunModsAutoApply
end)

if LocalPlayer.Character then
    LocalPlayer.Character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and getEnv().GunModsAutoApply then
            task.wait(0.2)
            applyGodGun(child)
        end
    end)
end
LocalPlayer.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and getEnv().GunModsAutoApply then
            task.wait(0.2)
            applyGodGun(child)
        end
    end)
end)

local meleeNames = {}
if MeleeItems then
    for _, tool in ipairs(MeleeItems:GetChildren()) do table.insert(meleeNames, tool.Name) end
end

local function isMeleeByName(tool)
    if not tool:IsA("Tool") then return false end
    if tool.Name == "Fists" then return true end
    for _, name in ipairs(meleeNames) do
        if tool.Name == name then return true end
    end
    return false
end

local function modifyFists(tool, enable)
    if not tool then return end
    local attrs = tool:GetAttributes()
    local keys  = {}
    for k in pairs(attrs) do table.insert(keys, k) end
    table.sort(keys)
    if #keys >= 7 then
        local rangeKey = keys[6]
        local dmgKey   = keys[7]
        if enable then
            if originalAttribs[rangeKey] == nil then originalAttribs[rangeKey] = tool:GetAttribute(rangeKey) end
            if originalAttribs[dmgKey]   == nil then originalAttribs[dmgKey]   = tool:GetAttribute(dmgKey)   end
            tool:SetAttribute(rangeKey, 360)
            tool:SetAttribute(dmgKey,   20)
        else
            if originalAttribs[rangeKey] then tool:SetAttribute(rangeKey, originalAttribs[rangeKey]) end
            if originalAttribs[dmgKey]   then tool:SetAttribute(dmgKey,   originalAttribs[dmgKey])   end
        end
    end
end

local function checkAndModifyFists()
    local char    = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not char or not backpack then return end
    for _, tool in ipairs(char:GetChildren()) do
        if isMeleeByName(tool) then modifyFists(tool, meleeAuraEnabled) end
    end
    for _, tool in ipairs(backpack:GetChildren()) do
        if isMeleeByName(tool) then modifyFists(tool, meleeAuraEnabled) end
    end
end

RunService.Heartbeat:Connect(function()
    if meleeAuraEnabled then checkAndModifyFists() end
end)
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if meleeAuraEnabled then checkAndModifyFists() end
end)

local _jumpHolding = false
local _jumpFlySpeed = 40
local _jumpConns = {}

local function stopHighJump()
    for _, c in ipairs(_jumpConns) do
        pcall(function() c:Disconnect() end)
    end
    _jumpConns = {}
    _jumpHolding = false
    pcall(function() ContextActionService:UnbindAction("_HJ_FlyUp") end)
    local char = LocalPlayer.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
        end
    end
end

local function setupHighJump(char)
    if not jumpPowerEnabled then return end
    stopHighJump()
    local humanoid = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")

    ContextActionService:BindAction("_HJ_FlyUp", function(_, inputState, inputObj)
        if not jumpPowerEnabled then return Enum.ContextActionResult.Pass end
        local isJumpKey = false
        if inputObj.UserInputType == Enum.UserInputType.Keyboard and inputObj.KeyCode == Enum.KeyCode.Space then
            isJumpKey = true
        end
        if inputObj.UserInputType == Enum.UserInputType.Touch then
            isJumpKey = true
        end
        if isJumpKey then
            if inputState == Enum.UserInputState.Begin then
                _jumpHolding = true
                humanoid.Jump = true
                return Enum.ContextActionResult.Sink
            elseif inputState == Enum.UserInputState.End then
                _jumpHolding = false
                return Enum.ContextActionResult.Sink
            end
        end
        return Enum.ContextActionResult.Pass
    end, false, Enum.KeyCode.Space)

    _jumpConns[1] = RunService.RenderStepped:Connect(function()
        if jumpPowerEnabled and _jumpHolding and hrp then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, _jumpFlySpeed, hrp.Velocity.Z)
        end
    end)

    _jumpConns[2] = humanoid:GetPropertyChangedSignal("Jumping"):Connect(function()
        if jumpPowerEnabled and humanoid.Jumping then
            _jumpHolding = true
        else
            _jumpHolding = false
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    if jumpPowerEnabled then setupHighJump(char) end
end)

local function lockTool(tool)
    if tool and tool:IsA("Tool") then
        pcall(function() tool:SetAttribute("Locked", true) end)
    end
end

local function setupBackpack(backpack)
    if not backpack then return end
    for _, tool in ipairs(backpack:GetChildren()) do lockTool(tool) end
    backpack.ChildAdded:Connect(lockTool)
end

local function initBackpack()
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if backpack then
        setupBackpack(backpack)
    else
        LocalPlayer.ChildAdded:Connect(function(child)
            if child:IsA("Backpack") then setupBackpack(child) end
        end)
    end
end

initBackpack()
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    initBackpack()
end)

task.wait(2)
print("Bypass hotbar inf")

local ok, sellBtn = pcall(function() return BuyPromptUI.get("SellPromptSellButton") end)
if ok and sellBtn then
    local holdStroke = sellBtn:FindFirstChild("HoldStroke", true)
    if holdStroke then
        holdStroke.Enabled = false
        local grad = holdStroke:FindFirstChildOfClass("UIGradient")
        if grad then grad.Enabled = false end
    end
    for _, v in pairs(sellBtn:GetDescendants()) do
        if v:IsA("NumberValue") then v.Value = 1 end
    end
end

task.wait(2)
print("Bypass")

if Util and Util.tween then
    local origTween = Util.tween
    Util.tween = function(obj, info, target)
        if obj and obj:IsA("NumberValue") and target and target.Value ~= nil then
            obj.Value = target.Value
            return { Cancel = function() end }
        end
        return origTween(obj, info, target)
    end
end

local function hookButton(btn)
    if not btn then return end
    if btn:FindFirstChild("UnlocksAtText") then btn.UnlocksAtText.Visible = false end
    if btn:FindFirstChild("EmoteName")     then btn.EmoteName.Visible = true      end
    CoreUI.on_click(btn, function()
        local hum = CharModule.get_hum()
        if not hum or hum.Health <= 0 then return end
        if EmotesUI.current_emote_playing.get() == btn then
            EmotesUI.current_emote_playing.set(nil)
        else
            EmotesUI.current_emote_playing.set(btn)
        end
        task.wait(0.12)
        EmotesUI.enabled.set(false)
    end)
    EmotesUI.current_emote_playing.hook(function(current)
        if btn:FindFirstChild("EmoteEquipped") then
            btn.EmoteEquipped.Visible = (current == btn)
        end
    end)
end

local function hookAllEmotes()
    if not EmotesList or not CoreUI then return end
    pcall(function()
        for _, emote in pairs(EmotesList) do
            local template = CoreUI.get("EmoteTemplate")
            if template and template.Parent then
                local btn = template.Parent:FindFirstChild(emote.name)
                hookButton(btn)
            end
        end
    end)
end

pcall(hookAllEmotes)
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    hookAllEmotes()
end)

LocalPlayer.CharacterAdded:Connect(setupCharacter)
if LocalPlayer.Character then setupCharacter(LocalPlayer.Character) end

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HRP = char:WaitForChild("HumanoidRootPart")
    _snap.y   = nil
    _snap.active = false
    lockYPosition()
end)
lockYPosition()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    autoAttackRunning = false
    task.wait(0.1)
    startAutoAttack()
end)
startAutoAttack()

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HRP = char:WaitForChild("HumanoidRootPart")
end)

LocalPlayer.CharacterAdded:Connect(function(char) Character = char end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G and WindUI and Window then
        if Window.Toggle then Window:Toggle()
        elseif Window.SetVisible then Window:SetVisible(not Window.Visible) end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Z and _snap.enabled then
        toggleSnap()
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if inventoryESPEnabled then
            wait(0.2)
            pcall(function() createBillboardForPlayer(player) end)
        end
        if espData[player] and espData[player].drawings then
            local nameDraw = espData[player].drawings[1]
            nameDraw.Color = isPlayerExcluded(player.Name)
                and Color3.fromRGB(0, 255, 0)
                or  Color3.fromRGB(255, 255, 255)
        end
    end)
end)


task.spawn(function()

do
    local CombatTab = _CombatTab
    CombatTab:Section({ Title = "GUN:" })

    local SilentAimToggle = CombatTab:Toggle({
        Title   = "Silent Aim",
        Default = false,
        Callback = function(v)
            silentAimEnabled = v
            aimTarget = nil
        end,
    })
    Config:Register("SilentAim", SilentAimToggle)

    local RedLineToggle = CombatTab:Toggle({
        Title   = "Red Line Lock",
        Default = false,
        Callback = function(v)
            redLineLockEnabled = v
            aimTarget = nil
        end,
    })
    Config:Register("SilentAimAttach", RedLineToggle)

    local FOVSlider = CombatTab:Slider({
        Title = "FOV: ",
        Step  = 1,
        Value = { Min = 20, Max = 800, Default = fovRadius },
        Callback = function(v)
            fovRadius = tonumber(v) or 120
            SA_FOV = fovRadius
            fovCircle.Radius = fovRadius
        end,
    })
    Config:Register("FOVRadius", FOVSlider)

    CombatTab:Toggle({
        Title = "Show FOV",
        Default = false,
        Callback = function(v)
            SA_ShowFOV = v
            fovCircle.Visible = v
        end,
    })

    CombatTab:Dropdown({
        Title = "Aim Part",
        Values = {"Head","Body"},
        Multi = false,
        Default = "Head",
        Callback = function(v)
            SA_AimPart = v
        end
    })

    CombatTab:Dropdown({
        Title = "Save Friend",
        Values = (function()
            local t = {}
            for _,plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then table.insert(t,plr.Name) end
            end
            return t
        end)(),
        Multi = true,
        Default = {},
        Callback = function(selected)
            for _,plr in pairs(Players:GetPlayers()) do
                plr:SetAttribute("SilentAimIgnore",false)
            end
            for _,name in pairs(selected) do
                local plr = Players:FindFirstChild(name)
                if plr then plr:SetAttribute("SilentAimIgnore",true) end
            end
        end
    })

    local MultiplierSlider = CombatTab:Slider({
        Title = "Multiplier Shot",
        Step  = 1,
        Value = { Min = 1, Max = 5, Default = 1 },
        Callback = function(v)
            shotMultiplier = tonumber(v) or 1
        end,
    })
    Config:Register("MultiplierShot", MultiplierSlider)

    CombatTab:Section({ Title = "RAPID FIRE:" })

    local RapidFireToggle = CombatTab:Toggle({
        Title   = "Rapid Fire (No Limit)",
        Desc    = "เธขเธดเธเธฃเธฑเธง",
        Default = false,
        Callback = function(v)
            rapidFireEnabled = v
            if v then
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        for _, tool in ipairs(char:GetChildren()) do
                            if tool:IsA("Tool") and isGunTool(tool) then
                                pcall(function()
                                    tool:SetAttribute(FindFireRateAttribute(tool), 9999)
                                    tool:SetAttribute("automatic", true)
                                end)
                            end
                        end
                    end
                end)
                if WindUI then WindUI:Notify({ Title = "open", Duration = 3 }) end
            else
                if WindUI then WindUI:Notify({ Title = "off", Duration = 2 }) end
            end
        end,
    })
    Config:Register("RapidFire", RapidFireToggle)

    CombatTab:Section({ Title = "AUTO:" })

    local AutoShootToggle = CombatTab:Toggle({
        Title   = "Auto Shoot",
        Desc    = "เธขเธดเธเธเธทเธเธญเธฑเธ•เนเธเธกเธฑเธ•เธดเนเธชเนเน€เธเนเธฒเธซเธกเธฒเธขเธ—เธตเนเนเธเธฅเนเธชเธธเธ”",
        Default = false,
        Callback = function(v)
            autoShootEnabled = v
        end,
    })
    Config:Register("AutoShoot", AutoShootToggle)

    local AutoShootSpeedSlider = CombatTab:Slider({
        Title = "Auto Shoot Speed",
        Step  = 0.01,
        Value = { Min = 0.03, Max = 0.5, Default = 0.08 },
        Callback = function(v)
            autoShootInterval = tonumber(v) or 0.08
        end,
    })
    Config:Register("AutoShootSpeed", AutoShootSpeedSlider)

    local TargetDropdown = CombatTab:Dropdown({
        Title  = "Auto Shoot Targets",
        Desc   = "เน€เธฅเธทเธญเธเธเธเธขเธดเธ (เน€เธฅเธทเธญเธเธซเธฅเธฒเธขเธเธเนเธ”เน) เธ–เนเธฒเนเธกเนเน€เธฅเธทเธญเธ = เธขเธดเธเธเธเนเธเธฅเนเธชเธธเธ”",
        Values = (function()
            local n = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then table.insert(n, p.Name) end
            end
            return n
        end)(),
        Multi    = true,
        Callback = function(selected)
            _G._autoShootTargets = {}
            if type(selected) == "table" then
                for name, on in pairs(selected) do
                    if on then table.insert(_G._autoShootTargets, name) end
                end
            end
        end,
    })
    Config:Register("AutoShootTargets", TargetDropdown)

    local KillAllToggle = CombatTab:Toggle({
        Title   = "Kill All",
        Desc    = "เธขเธดเธเธ—เธธเธเธเธเนเธเน€เธเธดเธฃเนเธเธญเธฑเธ•เนเธเธกเธฑเธ•เธดเธเธเธ•เธฒเธขเธซเธกเธ”",
        Default = false,
        Callback = function(v)
            _G._killAllEnabled = v
            if v then
                autoShootEnabled = true
                if WindUI then WindUI:Notify({ Title = "เธขเธดเธเธ—เธธเธเธเธ! Kill All ON", Duration = 3 }) end
            else
                autoShootEnabled = false
                if WindUI then WindUI:Notify({ Title = "Kill All OFF", Duration = 2 }) end
            end
        end,
    })
    Config:Register("KillAll", KillAllToggle)

    local AutoReloadToggle = CombatTab:Toggle({
        Title   = "Auto Reload",
        Desc    = "เธเธฑเธเนเธกเนเธเธญเธฑเธ•เนเธเธกเธฑเธ•เธด (เน€เธฃเนเธงเธกเธฒเธ)",
        Default = false,
        Callback = function(v)
            autoReloadEnabled = v
        end,
    })
    Config:Register("AutoReload", AutoReloadToggle)

    local function getPlayerNames()
        local names = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(names, player.Name)
            end
        end
        return names
    end

    local FriendDropdown = CombatTab:Dropdown({
        Title    = "Safe Friend",
        Desc     = "Select players to whitelist",
        Values   = getPlayerNames(),
        Default  = {},
        Multi    = true,
        Callback = function(v)
            excludedPlayers = {}
            if type(v) == "table" then
                for name, selected in pairs(v) do
                    if type(name) == "string" and selected == true then
                        table.insert(excludedPlayers, name)
                    end
                end
                if #excludedPlayers == 0 then
                    for _, name in ipairs(v) do
                        if type(name) == "string" then
                            table.insert(excludedPlayers, name)
                        end
                    end
                end
            end
            for _, player in pairs(Players:GetPlayers()) do
                if espData[player] and espData[player].drawings then
                    espData[player].drawings[1].Color =
                        isPlayerExcluded(player.Name) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
                end
            end
        end,
    })
    Config:Register("FriendsList", FriendDropdown)

    Players.PlayerAdded:Connect(function()
        pcall(function() FriendDropdown:Refresh(getPlayerNames(), true) end)
    end)
    Players.PlayerRemoving:Connect(function()
        pcall(function() FriendDropdown:Refresh(getPlayerNames(), true) end)
    end)

    pcall(function() CombatTab:Divider() end)
end

do
    local WeaponTab = _WeaponTab
    WeaponTab:Section({ Title = "MODS:" })

    WeaponTab:Slider({
        Title = "Fire Rate",
        Step  = 10,
        Value = { Min = 100, Max = 3000, Default = 1000 },
        Callback = function(v) getEnv().FireRateValue = v end,
    })

    WeaponTab:Slider({
        Title = "Accuracy",
        Step  = 0.01,
        Value = { Min = 0, Max = 1, Default = 1 },
        Callback = function(v) getEnv().AccuracyValue = v end,
    })

    WeaponTab:Slider({
        Title = "Recoil",
        Step  = 0.1,
        Value = { Min = 0, Max = 10, Default = 0 },
        Callback = function(v) getEnv().RecoilValue = v end,
    })

    WeaponTab:Slider({
        Title = "Reload Time",
        Step  = 0.1,
        Value = { Min = 0.1, Max = 10, Default = 0.1 },
        Callback = function(v) getEnv().ReloadValue = v end,
    })

    WeaponTab:Toggle({
        Title = "Automatic",
        Icon  = "check",
        Type  = "Checkbox",
        Value = false,
        Callback = function(v)
            getEnv().automatic         = v
            getEnv().GunModsAutoApply  = v
            if v and WindUI then WindUI:Notify({ Title = "โ… Auto Modify", Duration = 2 }) end
        end,
    })

    WeaponTab:Section({ Title = "COMBAT" })

    Config:Register("Fists Modifier", WeaponTab:Toggle({
        Title   = "Melee Aura",
        Desc    = "WideFists",
        Default = false,
        Callback = function(v)
            meleeAuraEnabled = v
            checkAndModifyFists()
        end,
    }))

    local AutoAttackToggle = WeaponTab:Toggle({
        Title   = "Auto Attack",
        Default = false,
        Callback = function(v) autoAttackEnabled = v end,
    })
    Config:Register("AutoAttack_Enabled", AutoAttackToggle)
end

do
    local ESPTab = _ESPTab
    ESPTab:Section({ Title = "Visual:" })

    local InventoryESPToggle = ESPTab:Toggle({
        Title   = "Inventory Viewer",
        Default = false,
        Callback = function(v)
            inventoryESPEnabled = v
            if v then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        pcall(function() createBillboardForPlayer(player) end)
                    end
                end
                _G.inventoryConn = RunService.Heartbeat:Connect(function()
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            pcall(function() createBillboardForPlayer(player) end)
                        end
                    end
                end)
                if WindUI then WindUI:Notify({ Title = "โ… ESP Items Enabled", Duration = 3 }) end
            else
                if _G.inventoryConn then _G.inventoryConn:Disconnect(); _G.inventoryConn = nil end
                for _, gui in pairs(PlayerBillboards) do gui:Destroy() end
                PlayerBillboards = {}
                if WindUI then WindUI:Notify({ Title = "โ ESP Items Disabled", Duration = 3 }) end
            end
        end,
    })
    Config:Register("ItemsESP", InventoryESPToggle)

    local NameESPToggle = ESPTab:Toggle({
        Title   = "Name",
        Default = false,
        Callback = function(v) nameESPEnabled = v end,
    })
    Config:Register("NameESP", NameESPToggle)

    local HealthESPToggle = ESPTab:Toggle({
        Title   = "Health",
        Default = false,
        Callback = function(v) healthESPEnabled = v end,
    })
    Config:Register("HealthESP", HealthESPToggle)

    local DistanceESPToggle = ESPTab:Toggle({
        Title   = "Distance",
        Default = false,
        Callback = function(v) distanceESPEnabled = v end,
    })
    Config:Register("DistanceESP", DistanceESPToggle)

    local HighlightESPToggle = ESPTab:Toggle({
        Title   = "Highlight",
        Default = false,
        Callback = function(v)
            highlightEnabled = v
            for _, player in pairs(Players:GetPlayers()) do
                pcall(function() updateHighlight(player) end)
            end
        end,
    })
    Config:Register("HighlightESP", HighlightESPToggle)
end

do
    local CharTab = _CharTab
    CharTab:Section({ Title = "CHARACTER:" })

    local WalkSpeedToggle = CharTab:Toggle({
        Title   = "Walk Speed",
        Default = false,
        Callback = function(v) walkSpeedEnabled = v end,
    })
    Config:Register("WalkSpeed", WalkSpeedToggle)

    local SpeedSlider = CharTab:Slider({
        Title = "Speed Multiplier",
        Step  = 0.5,
        Value = { Min = 1, Max = 5, Default = 2 },
        Callback = function(v) speedMultiplier = v * 0.05 end,
    })
    Config:Register("SpeedMultiplier", SpeedSlider)

    local JumpToggle = CharTab:Toggle({
        Title   = "High Jump",
        Default = false,
        Callback = function(v)
            jumpPowerEnabled = v
            if v then
                if LocalPlayer.Character then setupHighJump(LocalPlayer.Character) end
            else
                stopHighJump()
            end
        end,
    })
    Config:Register("JumpPower", JumpToggle)

    local AutoSprintToggle = CharTab:Toggle({
        Title   = "Infinite Stamina",
        Default = false,
        Callback = function(v)
            infiniteStaminaEnabled = v
            if v then
                local ok, SprintModule = pcall(function() return require(ReplicatedStorage.Modules.Game.Sprint) end)
                if ok and SprintModule then
                    local sprintBar = getupvalue(SprintModule.consume_stamina, 2).sprint_bar
                    if sprintBar then
                        local origUpdate = sprintBar.update
                        sprintBar.update = function(...) return origUpdate(function() return 1 end) end
                        getEnv().OriginalSprintUpdate = origUpdate
                        getEnv().AutoSprintLoop = task.spawn(function()
                            while infiniteStaminaEnabled do
                                pcall(function()
                                    Send.send("set_sprinting_1", true)
                                    task.wait(0.5)
                                    Send.send("set_sprinting_1", false)
                                end)
                                task.wait(0.1)
                            end
                            pcall(function() Send.send("set_sprinting_1", false) end)
                        end)
                        if WindUI then WindUI:Notify({ Title = "โ… INF STAMINA", Duration = 3 }) end
                    else
                        infiniteStaminaEnabled = false
                        AutoSprintToggle:Set(false)
                    end
                else
                    infiniteStaminaEnabled = false
                    AutoSprintToggle:Set(false)
                end
            else
                if getEnv().AutoSprintLoop then
                    task.cancel(getEnv().AutoSprintLoop)
                    getEnv().AutoSprintLoop = nil
                end
                pcall(function() Send.send("set_sprinting_1", false) end)
                local ok, SprintModule = pcall(function() return require(ReplicatedStorage.Modules.Game.Sprint) end)
                if ok and SprintModule then
                    local sprintBar = getupvalue(SprintModule.consume_stamina, 2).sprint_bar
                    if sprintBar and getEnv().OriginalSprintUpdate then
                        sprintBar.update = getEnv().OriginalSprintUpdate
                        getEnv().OriginalSprintUpdate = nil
                    end
                end
                if WindUI then WindUI:Notify({ Title = "โ Auto Sprint Disabled", Duration = 3 }) end
            end
        end,
    })
    Config:Register("AutoSprint", AutoSprintToggle)

    local AntiLockToggle = CharTab:Toggle({
        Title   = "Anti Lock",
        Default = false,
        Callback = function(v)
            antiLockEnabled = v
            getEnv().Sky = v
            if v then
                getEnv().SkyAmount = 1500
                startAntiLock()
            else
                stopAntiLock()
                if jumpPowerEnabled and LocalPlayer.Character then
                    setupHighJump(LocalPlayer.Character)
                end
            end
        end,
    })
    Config:Register("AntiLock", AntiLockToggle)



    local AntiKillToggle = CharTab:Toggle({
        Title   = "Anti Kill",
        Default = false,
        Callback = function(v)
            antiKillEnabled = v
            if WindUI then
                WindUI:Notify({ Title = v and " Anti Kill Enabled" or "โ Anti Kill Disabled", Duration = 3 })
            end
        end,
    })
    Config:Register("AntiKill", AntiKillToggle)

    pcall(function() if CharTab and typeof(CharTab.Divider) == "function" then CharTab:Divider() end end)
    pcall(function() if CharTab and typeof(CharTab.Section) == "function" then CharTab:Section({ Title = "Att:" }) end end)

    local PickupToggle = CharTab:Toggle({
        Title   = "Pickup items",
        Default = false,
        Callback = function(v) autoPickupEnabled = v end,
    })
    Config:Register("PickupItems", PickupToggle)

    local AntiRagdollToggle = CharTab:Toggle({
        Title   = "Anti Ragdoll",
        Default = false,
        Callback = function(enabled)
            if not enabled then return end
            pcall(function()
                local rs = game:GetService("ReplicatedStorage")
                local pl = game:GetService("Players").LocalPlayer
                local function findCounter2()
                    for _, v in ipairs(getgc and getgc(true) or {}) do
                        if typeof(v) == "table" and rawget(v, "event") and rawget(v, "func") then return v end
                    end
                end
                local ctr = findCounter2()
                if not ctr then return end
                local function sendAction(action)
                    ctr.event = (ctr.event or 0) + 1
                    rs:WaitForChild("Remotes"):WaitForChild("Send"):FireServer(ctr.event, action)
                end
                task.spawn(function()
                    while enabled do
                        sendAction("end_ragdoll_early")
                        task.wait(0.3)
                        if not enabled then break end
                        sendAction("clear_ragdoll")
                        task.wait(0.3)
                    end
                end)
            end)
        end,
    })
    Config:Register("AntiRagdoll", AntiRagdollToggle)

    local HideNameToggle = CharTab:Toggle({
        Title   = "Hide Name",
        Default = false,
        Callback = function(v)
            pcall(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local root = char:WaitForChild("HumanoidRootPart")
                local billboard = root:FindFirstChild("CharacterBillboardGui")
                if billboard then
                    local nameLabel = billboard:FindFirstChild("PlayerName")
                    if nameLabel and nameLabel:IsA("TextLabel") then
                        nameLabel.Visible = not v
                    end
                end
            end)
        end,
    })
    Config:Register("HideName", HideNameToggle)

    local AutoRespawnToggle = CharTab:Toggle({
        Title   = "Auto Respawn",
        Default = false,
        Callback = function(enabled)
            if not enabled then return end
            pcall(function()
                local rs = game:GetService("ReplicatedStorage")
                local pl = game:GetService("Players").LocalPlayer
                local function findCounter2()
                    for _, v in ipairs(getgc and getgc(true) or {}) do
                        if typeof(v) == "table" and rawget(v, "event") and rawget(v, "func") then return v end
                    end
                end
                local ctr = findCounter2()
                if not ctr then return end
                local function sendAction(action)
                    ctr.event = (ctr.event or 0) + 1
                    rs:WaitForChild("Remotes"):WaitForChild("Send"):FireServer(ctr.event, action)
                end
                task.spawn(function()
                    while enabled do
                        local char = pl.Character
                        local hum  = char and char:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health <= 0 then
                            task.wait(6)
                            if enabled then sendAction("death_screen_request_respawn") end
                        end
                        task.wait(0.5)
                    end
                end)
            end)
        end,
    })
    Config:Register("AutoRespawn", AutoRespawnToggle)

    CharTab:Divider()
    CharTab:Section({ Title = "PC HOLD (Z)" })

    local SnapToggle = CharTab:Toggle({
        Title   = "Snap Under Map",
        Default = false,
        Callback = function(v)
            _snap.enabled = v
            if v then
                _snap.originY = HRP and HRP.Position.Y or nil
                _snap.y = HRP and HRP.Position.Y or nil
                _snap.active = true
                performTeleport()
            else
                _snap.active = false
                _snap.y = nil
                _snap.originY = nil
            end
        end,
    })
    Config:Register("SnapUnderMap", SnapToggle)

    local SnapSlider = CharTab:Slider({
        Title = "Snap:",
        Step  = 1,
        Value = { Min = 1, Max = 100, Default = 10 },
        Callback = function(v)
            _snap.depth = v
            if _snap.active and HRP and _snap.originY then
                local destY = _snap.originY - v
                local newPos = Vector3.new(HRP.Position.X, destY, HRP.Position.Z)
                HRP.CFrame = CFrame.new(newPos)
                _snap.y = destY
            end
        end,
    })
    Config:Register("SnapHeight", SnapSlider)
end

do
    local PlayerTab = _PlayerTab
    PlayerTab:Section({ Title = "PLAYER:" })

    local AutoFinishToggle = PlayerTab:Toggle({
        Title   = "Auto Finish",
        Default = false,
        Callback = function(v)
            autoFinishEnabled = v
            if v then
                applyToAll()
                if WindUI then WindUI:Notify({ Title = "โ… Auto Finish Enabled", Description = "โ… Auto Enabled", Duration = 3 }) end
            else
                if WindUI then WindUI:Notify({ Title = "โ Auto Disabled", Description = "โ Auto Disabled", Duration = 3 }) end
            end
        end,
    })
    Config:Register("AutoFinnish", AutoFinishToggle)
    PlayerTab:Divider()
end

do
    local BuyTab = _BuyTab
    BuyTab:Section({ Title = "BUY:" })

    local Client = Players.LocalPlayer
    local PlayerGui = Client:WaitForChild("PlayerGui")

    local BankBalance =
        BuyTab:Button(
        {
            Title = "๐ฆ Bank Balance",
            Desc = "N/A"
        }
    )
    local HandBalance =
        BuyTab:Button(
        {
            Title = "๐’ธ Hand Balance",
            Desc = "N/A"
        }
    )

    local function HandMoney()
        return tonumber(PlayerGui.TopRightHud.Holder.Frame.MoneyTextLabel.Text:match("%$(%d+)"))
    end

    local function ATMMoney()
        for _, v in ipairs(PlayerGui:GetDescendants()) do
            if v:IsA("TextLabel") and string.find(v.Text, "Bank Balance") then
                return tonumber(v.Text:match("%$(%d+)"))
            end
        end
        return 0
    end

    task.spawn(
        function()
            while task.wait(0.2) do
                BankBalance:SetDesc('<b><font color="#FFFFFF">$' .. (ATMMoney() or 0) .. "</font></b>")
                HandBalance:SetDesc('<b><font color="#FFFFFF">$' .. (HandMoney() or 0) .. "</font></b>")
            end
        end
    )

    pcall(function()
        local SkipCrateToggle = BuyTab:Toggle({
            Title   = "Skip Crate Spin",
            Desc    = "เธเนเธฒเธกเธเธฒเธฃเธซเธกเธธเธเธเธฅเนเธญเธเธญเธฑเธ•เนเธเธกเธฑเธ•เธด",
            Icon    = "check",
            Type    = "Checkbox",
            Default = false,
            Callback = function(v)
                skipCrateEnabled = v
            end,
        })
        Config:Register("SkipCrate",       SkipCrateToggle)
        Config:Register("SkipCrateBackup", SkipCrateToggle)
    end)

    local function getCrateOptions()
        local map = workspace:FindFirstChild("Map")
        if not map then return nil end
        local tiles = map:FindFirstChild("Tiles")
        if not tiles then return nil end
        local gunShopTile = tiles:FindFirstChild("GunShopTile")
        if not gunShopTile then return nil end
        local patriotWeapons = gunShopTile:FindFirstChild("PatriotWeapons")
        if not patriotWeapons then return nil end
        local interior = patriotWeapons:FindFirstChild("Interior")
        if not interior then return nil end
        local crates = interior:FindFirstChild("Crates")
        if not crates then return nil end
        local ammoCrate = crates:FindFirstChild("Ammo Crate")
        if not ammoCrate then return nil end
        return ammoCrate:FindFirstChild("CrateOptions")
    end

    local function openCrateWithType(bulletType)
        local crateOptions = getCrateOptions()
        if not crateOptions then
            warn("โ เนเธกเนเธเธ CrateOptions (เธญเธฒเธเธญเธขเธนเนเธเธญเธเนเธเธเธ—เธตเนเธซเธฃเธทเธญเธขเธฑเธเนเธกเนเนเธซเธฅเธ”)")
            if WindUI then WindUI:Notify({Title = "โ เนเธกเนเธเธ Ammo Crate", Duration = 2}) end
            return
        end

        local targetItem = crateOptions:FindFirstChild(bulletType)
        if not targetItem then
            warn("โ เนเธกเนเธเธเธเธฃเธฐเน€เธ เธ— " .. bulletType .. " เนเธ CrateOptions")
            if WindUI then WindUI:Notify({Title = "โ เนเธกเนเธกเธต " .. bulletType .. " เนเธ crate", Duration = 2}) end
            return
        end

        local result = netGet("open_crate", targetItem, "money")
        if result then
            print("โ… เน€เธเธดเธ” crate เธชเธณเน€เธฃเนเธ เธเธฃเธฐเน€เธ เธ—:", bulletType)
            if WindUI then WindUI:Notify({Title = "๐”ซ เน€เธเธดเธ” " .. bulletType .. " เธชเธณเน€เธฃเนเธ", Duration = 2}) end
        else
            warn("โ เน€เธเธดเธ” crate เธฅเนเธกเน€เธซเธฅเธง")
            if WindUI then WindUI:Notify({Title = "โ เน€เธเธดเธ” crate เนเธกเนเธชเธณเน€เธฃเนเธ", Duration = 2}) end
        end
    end

    local selectedBulletType = "Pistol"

    local bulletDropdown = BuyTab:Dropdown({
        Title = "เน€เธฅเธทเธญเธเธเธฃเธฐเน€เธ เธ—เธเธฃเธฐเธชเธธเธ",
        Values = {"Pistol", "Rifle", "Shotgun", "Random"},
        Value = "Pistol",
        Multi = false,
        Callback = function(selected)
            selectedBulletType = selected
            if selected == "Random" then
                print("๐ฒ เนเธซเธกเธ”เธชเธธเนเธก: เธเธฐเธชเธธเนเธก Pistol / Rifle / Shotgun เน€เธกเธทเนเธญเธเธ”เน€เธเธดเธ”")
            else
                print("๐”ซ เน€เธฅเธทเธญเธเธเธฃเธฐเน€เธ เธ—: " .. selected)
            end
        end
    })

    BuyTab:Button({
        Title = "เน€เธเธดเธ” Ammo Crate",
        Desc = "เนเธเนเธเธฃเธฐเน€เธ เธ—เธเธฃเธฐเธชเธธเธเธ—เธตเนเน€เธฅเธทเธญเธเธเธฒเธ dropdown",
        Callback = function()
            local useType = selectedBulletType
            if useType == "Random" then
                local options = {"Pistol", "Rifle", "Shotgun"}
                useType = options[math.random(1, #options)]

                if WindUI then WindUI:Notify({Title = "เธชเธธเนเธกเนเธ”เน " .. useType, Duration = 1}) end
            end
            openCrateWithType(useType)
        end
    })
end

do
    local MiscTab = _MiscTab
    local placeId = game.PlaceId

    MiscTab:Input({
        Title       = "Server Hop by ID",
        Value       = "",
        InputIcon   = "send",
        Type        = "Input",
        Placeholder = "id sever here!",
        Callback = function(v)
            if not v or v == "" then return end
            local ids = {}
            for id in string.gmatch(v, "[%w%-]+") do table.insert(ids, id) end
            for _, id in ipairs(ids) do
                print("เธเธณเธฅเธฑเธเธงเธฒเธฃเนเธเนเธเน€เธเธดเธฃเนเธ:", id)
                task.wait(0.5)
                pcall(function()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(placeId, id, LocalPlayer)
                end)
            end
        end,
    })

    MiscTab:Button({
        Title = "Server Rejoin",
        Desc  = "Come back old sever",
        Callback = function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(
                game.PlaceId, game.JobId, LocalPlayer
            )
        end,
    })

    MiscTab:Button({
        Title = "Copy JobID",
        Icon  = "copy",
        Desc  = "เธเธฑเธ”เธฅเธญเธ JobID เน€เธเธดเธฃเนเธเธเธฑเธเธเธธเธเธฑเธ",
        Callback = function()
            local jobId = game.JobId
            if setclipboard then
                setclipboard(jobId)
            elseif toclipboard then
                toclipboard(jobId)
            end
            if WindUI then WindUI:Notify({ Title = "๐“ Copied JobID", Content = jobId, Duration = 3 }) end
        end,
    })

    MiscTab:Input({
        Title       = "Join JobID",
        Value       = "",
        InputIcon   = "log-in",
        Type        = "Input",
        Placeholder = "เธงเธฒเธ JobID เธ—เธตเนเธ•เนเธญเธเธเธฒเธฃเน€เธเนเธฒ",
        Callback = function(v)
            if not v or v == "" then return end
            pcall(function()
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v, LocalPlayer)
            end)
        end,
    })

    MiscTab:Button({
        Title = 'Hop Server',
        Icon = 'shuffle',
        Callback = function()
            local HttpService = game:GetService('HttpService')
            local TeleportService = game:GetService('TeleportService')
            local servers = {}
            local req = game:HttpGet(
                string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", game.PlaceId)
            )
            local data = HttpService:JSONDecode(req)
            if data and data.data then
                for _, v in pairs(data.data) do
                    if v.playing < v.maxPlayers then
                        table.insert(servers, v.id)
                    end
                end
            end
            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], game.Players.LocalPlayer)
            end
        end
    })

    MiscTab:Button({
        Title = 'Hop Server',
        Icon = 'shuffle',
        Callback = function()
            local HttpService = game:GetService('HttpService')
            local TeleportService = game:GetService('TeleportService')
            local servers = {}
            local req = game:HttpGet(
                string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100", game.PlaceId)
            )
            local data = HttpService:JSONDecode(req)
            if data and data.data then
                for _, v in pairs(data.data) do
                    if v.playing >= math.floor(v.maxPlayers * 0.4) and v.playing <= math.floor(v.maxPlayers * 0.8) then
                        table.insert(servers, v.id)
                    end
                end
            end
            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], game.Players.LocalPlayer)
            end
        end
    })

    MiscTab:Divider()

    MiscTab:Button({
        Title    = "Claim All Quest",
        Callback = function()
            task.spawn(function()
                local ok, err = pcall(function()
                    local rs = game:GetService("ReplicatedStorage")
                    local pl = game:GetService("Players").LocalPlayer
                    local function findCounter2()
                        for _, v in ipairs(getgc and getgc(true) or {}) do
                            if typeof(v) == "table" and rawget(v, "event") and rawget(v, "func") then return v end
                        end
                        return nil
                    end
                    local ctr = findCounter2()
                    if not ctr then return end
                    local remote = {}
                    function remote.get(...)
                        local args = { ... }
                        ctr.func = (ctr.func or 0) + 1
                        local get = rs:WaitForChild("Remotes"):WaitForChild("Get")
                        return get:InvokeServer(ctr.func, table.unpack(args))
                    end
                    local questFrame = pl:WaitForChild("PlayerGui")
                        :WaitForChild("Quests")
                        :WaitForChild("QuestsHolder")
                        :WaitForChild("QuestsScrollingFrame")
                    for _, child in ipairs(questFrame:GetChildren()) do
                        if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("ImageButton") then
                            remote.get("claim_quest", child.Name)
                            task.wait(0.2)
                        end
                    end
                end)
                if ok then print("Claim All Quests Completed") else warn(err) end
            end)
        end,
    })
    Config:Register("ClaimAllQuest", MiscTab)

    MiscTab:Section({ Title = "Config Management" })

    local SaveBtn = MiscTab:Button({
        Title    = "Save Config",
        Callback = function()
            if Config.Save then Config.Save(Config) end
        end,
    })
    Config:Register("SaveConfig", SaveBtn)

    local DeleteBtn = MiscTab:Button({
        Title    = "Delete Config",
        Callback = function()
            if Config.Delete then Config.Delete(Config) end
        end,
    })
    Config:Register("DeleteConfig", DeleteBtn)


    local Lighting = game:GetService("Lighting")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Terrain = workspace:FindFirstChildOfClass("Terrain")

    local function Bootsfps()
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("Sky")
            or v:IsA("Atmosphere")
            or v:IsA("BloomEffect")
            or v:IsA("SunRaysEffect")
            or v:IsA("ColorCorrectionEffect")
            or v:IsA("DepthOfFieldEffect") then
                v:Destroy()
            end
        end

        Lighting.GlobalShadows = false
        Lighting.Brightness = 0
        Lighting.FogEnd = 9e9
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.Ambient = Color3.fromRGB(120, 120, 120)
        Lighting.OutdoorAmbient = Color3.fromRGB(120, 120, 120)

        local sky = Instance.new("Sky")
        sky.SkyboxBk = "rbxassetid://6444884337"
        sky.SkyboxDn = "rbxassetid://6444884337"
        sky.SkyboxFt = "rbxassetid://6444884337"
        sky.SkyboxLf = "rbxassetid://6444884337"
        sky.SkyboxRt = "rbxassetid://6444884337"
        sky.SkyboxUp = "rbxassetid://6444884337"
        sky.Parent = Lighting

        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1
        end

        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("MeshPart") or v:IsA("SpecialMesh") then
                local name = v.Name:lower()
                if name:find("leaf") or name:find("leave") or name:find("palm") or name:find("tree") then
                    v:Destroy()
                end
            end
        end

        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
                v.CastShadow = false
                v.Color = Color3.fromRGB(120,120,120)

            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1

            elseif v:IsA("ParticleEmitter")
            or v:IsA("Trail")
            or v:IsA("Beam") then
                v.Enabled = false
            end
        end
    end


    MiscTab:Button({
        Title = "Bootsfps",
        Icon = "zap",
        Callback = function()
            Bootsfps()
        end
    })


    local Lighting = game:GetService("Lighting")
    local Terrain = workspace:FindFirstChildOfClass("Terrain")

    local function RTX_ON()
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("Atmosphere")
            or v:IsA("BloomEffect")
            or v:IsA("SunRaysEffect")
            or v:IsA("ColorCorrectionEffect")
            or v:IsA("DepthOfFieldEffect")
            or v:IsA("Sky") then
                v:Destroy()
            end
        end

        local Sky = Instance.new("Sky")
        Sky.SkyboxBk = "rbxassetid://159454299"
        Sky.SkyboxDn = "rbxassetid://159454296"
        Sky.SkyboxFt = "rbxassetid://159454293"
        Sky.SkyboxLf = "rbxassetid://159454286"
        Sky.SkyboxRt = "rbxassetid://159454300"
        Sky.SkyboxUp = "rbxassetid://159454288"
        Sky.SunAngularSize = 21
        Sky.Parent = Lighting

        Lighting.Technology = Enum.Technology.Future
        Lighting.GlobalShadows = true
        Lighting.ShadowSoftness = 1
        Lighting.Brightness = 3
        Lighting.ExposureCompensation = 0.25
        Lighting.EnvironmentDiffuseScale = 1
        Lighting.EnvironmentSpecularScale = 1
        Lighting.ClockTime = 14

        local Atmosphere = Instance.new("Atmosphere")
        Atmosphere.Density = 0.35
        Atmosphere.Offset = 0.25
        Atmosphere.Color = Color3.fromRGB(190, 210, 255)
        Atmosphere.Decay = Color3.fromRGB(120, 150, 200)
        Atmosphere.Glare = 0.35
        Atmosphere.Haze = 1.2
        Atmosphere.Parent = Lighting

        local Bloom = Instance.new("BloomEffect")
        Bloom.Intensity = 1.2
        Bloom.Size = 56
        Bloom.Threshold = 0.85
        Bloom.Parent = Lighting

        local SunRays = Instance.new("SunRaysEffect")
        SunRays.Intensity = 0.25
        SunRays.Spread = 0.85
        SunRays.Parent = Lighting

        local CC = Instance.new("ColorCorrectionEffect")
        CC.Brightness = 0.05
        CC.Contrast = 0.25
        CC.Saturation = 0.35
        CC.TintColor = Color3.fromRGB(255, 245, 235)
        CC.Parent = Lighting

        local DOF = Instance.new("DepthOfFieldEffect")
        DOF.FarIntensity = 0.25
        DOF.NearIntensity = 0.05
        DOF.FocusDistance = 60
        DOF.InFocusRadius = 40
        DOF.Parent = Lighting

        if Terrain then
            Terrain.WaterWaveSize = 1
            Terrain.WaterWaveSpeed = 15
            Terrain.WaterReflectance = 1
            Terrain.WaterTransparency = 0.05
        end

        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CastShadow = true
                if v.Material == Enum.Material.Plastic then
                    v.Material = Enum.Material.SmoothPlastic
                end
            end
        end
    end


    MiscTab:Button({
        Title = "RTX ON",
        Icon = "sparkles",
        Callback = function()
            RTX_ON()
        end
    })

    MiscTab:Button({
        Title = "Frustum Culling",
        Icon = "eye",
        Callback = function()
            Objects = workspace:GetDescendants()
            game:GetService("RunService").RenderStepped:Connect(function()
                loadVisibleObjects(Camera, Objects)
            end)
        end
    })
end

if Config.Load then Config.Load(Config) end

local CollectionService = game:GetService("CollectionService")

for _, tag in pairs(CollectionService:GetAllTags()) do
    if tag:lower():find("door") then
        for _, obj in pairs(CollectionService:GetTagged(tag)) do
            pcall(function()
                obj:Destroy()
            end)
        end
    end
end

for _, obj in pairs(workspace:GetDescendants()) do
    if obj.Name:lower():find("door") then
        pcall(function()
            obj:Destroy()
        end)
    end
end

print("เธฅเธ Door เธ—เธฑเนเธเธซเธกเธ”เนเธฅเนเธง")
end)
-- ==========================================
-- Additional English Descriptions / Labels
-- นำไปต่อท้ายสคริปต์ของคุณ
-- ==========================================

local AdditionalLabels = {
    AutoShootDesc = "Automatically targets and fires at enemies within range.",
    AutoShootSpeedDesc = "Adjusts the delay and speed between each shot.",
    AutoShootTargetsDesc = "Selects the specific hit part or target priority for shooting.",
    KillAllDesc = "Eliminates all active targets instantly across the map."
}

print("[System] English text extensions loaded successfully.")