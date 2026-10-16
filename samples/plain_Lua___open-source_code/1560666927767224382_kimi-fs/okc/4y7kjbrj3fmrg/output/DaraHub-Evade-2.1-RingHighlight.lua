function FireClient(path, ...)
	if getconnections then
		for _, c in getconnections(path.OnClientEvent) do
			c.Function(...)
		end
	else
		warn("Your Executor failed to run 'getconnections'")
	end
end
if getgenv().DaraHubExecuted then
	FireClient(game:GetService("ReplicatedStorage").Events.SharedUISetType, "Notification", "Message", "Script Is Already Loaded, rejoin if you want to re-execute", "Error")
	return
end
getgenv().DaraHubExecuted = true
local BaseURL = "https://darahub.pages.dev"
loadstring(game:HttpGet(BaseURL .. "/Module/Library/GUI/LoadAll.lua"))() -- load lib stuff
WindUI = loadstring(game:HttpGet(BaseURL .. "/Module/Library/GUI/WindUI-Moded/main.lua"))()
Window = WindUI:CreateWindow({
	NewElements = true,
	Title = "Dara Hub | Evade 2.1",
	Icon = BaseURL .. "/icon.png",
	Author = "Made by: Pnsdg And Yomka",
	Folder = "DaraHub/Games/Evade",
	Size = UDim2.fromOffset(580, 490),
	Theme = "Dark",
	HidePanelBackground = false,
	Acrylic = false,
	HideSearchBar = false,
	SideBarWidth = 200,
	OpenButton = {
		ShowIconOnly = true
	}
})
WindUI.TransparencyValue = 0.7
Window:ToggleTransparency(true)
Window:DisableTopbarButtons({
	"Fullscreen"
})
Window:SetIconSize(48)
executor = identifyexecutor()
if type(executor) == "table" then
	for key, value in pairs(executor) do
		print(key .. ": " .. tostring(value))
	end
elseif type(executor) == "string" then
	Window:Tag({
		Title = "" .. executor
	})
else
	print("The injector does not support identifyexecutor()")
end
Window:Tag({
	Title = "v1.1.5",
	Color = Color3.fromHex("#30ff6a")
})
Tabs = {
	Main = Window:Tab({
		Title = "Main",
		Icon = "layout-grid"
	}),
	Player = Window:Tab({
		Title = "Player",
		Icon = "user"
	}),
	Combat = Window:Tab({
		Title = "Combat",
		Icon = "sword"
	}),
	Auto = Window:Tab({
		Title = "Auto",
		Icon = "repeat-2"
	}),
	Visuals = Window:Tab({
		Title = "Visuals",
		Icon = "camera"
	}),
	ESP = Window:Tab({
		Title = "Esp",
		Icon = "eye"
	}),
	Misc = Window:Tab({
		Title = "Misc",
		Icon = "star"
	}),
	Utility = Window:Tab({
		Title = "Utility",
		Icon = "wrench"
	}),
	Teleport = Window:Tab({
		Title = "Teleport",
		Icon = "navigation"
	}),
	Shop = Window:Tab({
		Title = "Shop",
		Icon = "shopping-cart"
	}),
	Settings = Window:Tab({
		Title = "Settings",
		Icon = "settings"
	}),
	info = Window:Tab({
		Title = "info",
		Icon = "info"
	}),
	Others = Window:Tab({
		Title = "Others",
		Icon = "https://em-content.zobj.net/source/apple/419/pile-of-poo_1f4a9.png"
	})
}
socialsModule = loadstring(game:HttpGet(BaseURL .. "/Module/info.lua"))()
socialsModule(Tabs)
function mouseUnlock(enabled)
	local success, err = pcall(function()
		local uiService = game:GetService("ReplicatedStorage"):FindFirstChild("Services"):FindFirstChild("UI"):FindFirstChild("SharedUIService")
		uiService.SetMouseActive:Fire("WindUI", enabled)
	end)
	if not success then
		warn("Failed to set mouse active state: " .. tostring(err))
	end
end
mouseUnlock(true)
Window:OnOpen(function()
	mouseUnlock(true)
end)
Window:OnClose(function()
	mouseUnlock(false)
end)
local stopRampBooster
Window:OnDestroy(function()
	ButtonLib:DestroyScreengui()
	mouseUnlock(false)
	if cleanupTracerESP then
		cleanupTracerESP()
	end
	if cleanupRingHighlights then
		cleanupRingHighlights()
	end
	if stopRampBooster then
		stopRampBooster()
	end
end)
-- Services & Variable
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local PathfindingService = game:GetService("PathfindingService")

-- require
local PlayerModule = LocalPlayer.PlayerScripts.PlayerModule
local ControlModule = require(PlayerModule.ControlModule)
local ClientItemService = require(ReplicatedStorage.Services.Items.ClientItemService)
local ServerStateRegistryService = require(ReplicatedStorage.Services.Data.ServerStateRegistryService)
local CharacterService = require(ReplicatedStorage.Services.Asset.CharacterService)
local InteractionTypes = require(ReplicatedStorage.Services.Asset.InteractionService.InteractionTypes)
local DefaultKeybinds = require(ReplicatedStorage.Services.Client.KeybindService.DefaultKeybinds)
local Movement = require(ReplicatedStorage.Objects.Game.Character.Client.Movement)
for _, n in {
	"LookBack",
	"ADS"
} do
	require(ReplicatedStorage.Objects.Game.Actions.ActionTypes[n]).Requirements.Mobile = nil
end
local Portal = require(ReplicatedStorage.Objects.Game.Tool.Tasks.Types.Portal)
local BuildModule = require(ReplicatedStorage.Objects.Game.Tool.Tasks.Types.Build)
local useCurrency = require(ReplicatedStorage.Shared.UserData.ClientHooks.useCurrency)
local useProgression = require(ReplicatedStorage.Shared.UserData.ClientHooks.useProgression)
local useEvent = require(ReplicatedStorage.Shared.UserData.ClientHooks.useEvent)
local DeathFeed = require(ReplicatedStorage.Services.UI.GameUIService.Types.DeathFeed)
local EmoteClass = require(ReplicatedStorage.Objects.Items.Emote)
local ColaModule = require(ReplicatedStorage.Tools.Cola)
local UseInventory = require(ReplicatedStorage.Shared.UserData.ClientHooks.useInventory)
local RagdollModule = require(ReplicatedStorage.Objects.Game.Character.Rig.Ragdoll)
local JumpPadModule = require(ReplicatedStorage.Items.BaseItems.Loadout.Deployables.JumpPad.Modules.Client)
local Currency = require(ReplicatedStorage.Shared.UserData.ClientHooks.useCurrency)
local Config = require(ReplicatedStorage.Shared.UserData.Battlepass.Config)
local Character
local Humanoid
local HumanoidRootPart
local CharacterTag
function GetCharacterTag(Character)
	if not Character then
		return nil
	end
	return Character:GetAttribute("Tag")
end
function setupCharacter(character)
	Character = character
	Humanoid = character:FindFirstChildOfClass("Humanoid")
	HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	CharacterTag = GetCharacterTag(character)
end
if LocalPlayer.Character then
	setupCharacter(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(function(character)
	setupCharacter(character)
end)
local Interact = ReplicatedStorage.Events.Interact
local ToolAction = ReplicatedStorage.Events.ToolAction
UniverseServerTools = loadstring(game:HttpGet(BaseURL .. "/Module/UniverseServerTools.lua"))()
UniverseServerTools(Tabs)
Tabs.Main:Space()
function CanBeCarried(value)
	for _, interaction in ipairs(InteractionTypes.Revive.Interactions) do
		if interaction.Name == "Carry" then
			interaction.Requirements.CanBeCarried = value
		end
	end
end
Tabs.Main:Toggle({
	Title = "Force Enable Everyone's Carry",
	Desc = [[Are you tired of those cornballs always turning off carry for their dada/Eboy?
This toggle is for you. No matter how they try to disable carry, you will still be able to carry them, but they will still be able to uncarry when they turn off their carry.]],
	Callback = function(s)
		if s then
			CanBeCarried(nil)
		else
			CanBeCarried(true)
		end
	end
})
Tabs.Main:Space()
FEBoombox = Tabs.Main:Button({
	Title = "Get Free FE Boombox Sound Player",
	Callback = function()
		FEBoombox:Destroy()
		loadstring(game:HttpGet(BaseURL .. "/api/script/obfuscated/Fe/Boomboxs/EvadeOverhaul-RelicsXYZ.lua"))()
	end
})
--macro command gui
local success, err = pcall(function()
	if LocalPlayer:GetAttribute("VIPCommandsAccess") == true then
		loadstring(game:HttpGet(BaseURL .. "/api/script/Tools/EvadeCMDMacroGUI.lua"))()
	end
end)
if not success then
	warn("Error loading EvadeCMDMacroGUI: " .. tostring(err))
end
-- Top bar buttons
function SendKeybindEvent(key, bool)
	ReplicatedStorage.Services.Client.KeybindService.SendKeybindEvent:Fire({
		Key = key,
		Down = bool
	})
end
if game:GetService("UserInputService").TouchEnabled then
	local isButtonLocked, currentMouseHold, activeKeybinds, createdButtons = {}, {}, {}, {}
	function UpdateAllButtons()
		for key, _ in pairs(currentMouseHold) do
			if currentMouseHold[key] then
				SendKeybindEvent(key, false)
			end
			currentMouseHold[key] = nil
		end
		for key, buttonData in pairs(createdButtons) do
			if buttonData and buttonData.updateVisualState then
				pcall(buttonData.updateVisualState)
			end
		end
	end
	local LocalPlayer, starterGui, PlayerGui = game.Players.LocalPlayer, game:GetService("StarterGui"), game.Players.LocalPlayer:WaitForChild("PlayerGui")
	local topbarStandard, targetParent = PlayerGui:FindFirstChild("TopbarStandard"), nil
	if topbarStandard then
		local main = topbarStandard:FindFirstChild("Main")
		if main then
			local holders = main:FindFirstChild("Holders")
			if holders then
				targetParent = holders:FindFirstChild("Left")
				if targetParent then
					for _, child in ipairs(targetParent:GetChildren()) do
						if child.Name == "TopbarStandard" then
							child:Destroy()
						end
					end
				end
			end
		end
	end
	if not targetParent then
		if PlayerGui:FindFirstChild("TopbarStandard") then
			PlayerGui:FindFirstChild("TopbarStandard"):Destroy()
		end
		starterGui:SetCore("TopbarEnabled", false)
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name, screenGui.IgnoreGuiInset, screenGui.ScreenInsets, screenGui.DisplayOrder, screenGui.ResetOnSpawn, screenGui.Parent = "TopbarStandard", false, Enum.ScreenInsets.TopbarSafeInsets, 100, false, PlayerGui
		local holders = Instance.new("Frame")
		holders.Name, holders.BackgroundTransparency, holders.BorderSizePixel, holders.Position, holders.Size, holders.Parent = "Holders", 1, 0, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, - 2), screenGui
		local frame = Instance.new("Frame")
		frame.Name, frame.BackgroundTransparency, frame.BorderSizePixel, frame.Position, frame.Size, frame.Parent = "Main", 1, 0, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0), holders
		local scrollingFrame = Instance.new("ScrollingFrame")
		scrollingFrame.Name, scrollingFrame.Parent, scrollingFrame.BackgroundTransparency, scrollingFrame.BorderSizePixel, scrollingFrame.Position, scrollingFrame.Size, scrollingFrame.CanvasSize, scrollingFrame.AutomaticCanvasSize, scrollingFrame.ScrollBarThickness, scrollingFrame.ScrollingDirection, scrollingFrame.ScrollingEnabled = "Right", frame, 1, 0, UDim2.new(0, 12, 0, 0), UDim2.new(1, - 24, 1, 0), UDim2.new(0, 0, 0, 0), Enum.AutomaticSize.X, 0, Enum.ScrollingDirection.X, false
		local uiListLayout = Instance.new("UIListLayout")
		uiListLayout.Parent, uiListLayout.Padding, uiListLayout.SortOrder, uiListLayout.FillDirection, uiListLayout.HorizontalAlignment, uiListLayout.VerticalAlignment = scrollingFrame, UDim.new(0, 12), Enum.SortOrder.LayoutOrder, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Bottom
		targetParent = scrollingFrame
	else
		starterGui:SetCore("TopbarEnabled", true)
	end
	local keybindButtonsConfig = {
		{
			name = "SecondaryButton",
			layoutOrder = 999,
			icon = "rbxassetid://126943351764139",
			label = "Zoom",
			key = "Secondary",
			enablesLockValue = false
		},
		{
			name = "ReloadButton",
			layoutOrder = 997,
			icon = "rbxassetid://78648212535999",
			label = "Front View/Reload",
			key = "Reload",
			enablesLockValue = false
		},
		{
			name = "LeaderboardButton",
			layoutOrder = 998,
			icon = "rbxassetid://5107166345",
			label = "Leaderboard",
			key = "Leaderboard",
			enablesLockValue = false
		}
	}
	function createKeybindButton(config, parent)
		local Button = Instance.new("Frame")
		Button.Name, Button.Parent, Button.BackgroundTransparency, Button.ClipsDescendants, Button.LayoutOrder, Button.Size, Button.ZIndex = config.name, parent, 1, true, config.layoutOrder, UDim2.new(0, 44, 0, 44), 20
		local IconButton = Instance.new("Frame")
		IconButton.Name, IconButton.Parent, IconButton.BackgroundColor3, IconButton.BackgroundTransparency, IconButton.BorderSizePixel, IconButton.ClipsDescendants, IconButton.Size, IconButton.ZIndex = "IconButton", Button, Color3.fromRGB(0, 0, 0), 0.3, 0, true, UDim2.new(1, 0, 1, 0), 2
		local UICorner = Instance.new("UICorner")
		UICorner.CornerRadius, UICorner.Parent = UDim.new(1, 0), IconButton
		local IconImage = Instance.new("ImageLabel")
		IconImage.Parent, IconImage.AnchorPoint, IconImage.BackgroundTransparency, IconImage.Position, IconImage.Size, IconImage.ZIndex, IconImage.Image = IconButton, Vector2.new(0.5, 0.5), 1, UDim2.new(0.5, 0, 0.5, 0), UDim2.new(0.5, 0, 0.5, 0), 15, config.icon
		local IconImageRatio = Instance.new("UIAspectRatioConstraint")
		IconImageRatio.Parent, IconImageRatio.DominantAxis = IconImage, Enum.DominantAxis.Height
		local ClickRegion = Instance.new("TextButton")
		ClickRegion.Parent, ClickRegion.BackgroundTransparency, ClickRegion.Size, ClickRegion.ZIndex, ClickRegion.Text = IconButton, 1, UDim2.new(1, 0, 1, 0), 20, ""
		local IconOverlay = Instance.new("Frame")
		IconOverlay.Parent, IconOverlay.BackgroundColor3, IconOverlay.BackgroundTransparency, IconOverlay.Size, IconOverlay.Visible, IconOverlay.ZIndex = IconButton, Color3.fromRGB(255, 255, 255), 0.925, UDim2.new(1, 0, 1, 0), false, 6
		local UICorner_Overlay = Instance.new("UICorner")
		UICorner_Overlay.CornerRadius, UICorner_Overlay.Parent = UDim.new(1, 0), IconOverlay
		function getIsActive()
			return currentMouseHold[config.key] or false
		end
		function updateVisualState()
			IconOverlay.Visible = getIsActive()
		end
		ClickRegion.MouseButton1Down:Connect(function()
			currentMouseHold[config.key] = true
			SendKeybindEvent(config.key, true)
			updateVisualState()
		end)
		ClickRegion.MouseButton1Up:Connect(function()
			if currentMouseHold[config.key] then
				currentMouseHold[config.key] = false
				SendKeybindEvent(config.key, false)
				updateVisualState()
			end
		end)
		createdButtons[config.key] = {
			Button = Button,
			updateVisualState = updateVisualState
		}
	end
	for _, config in ipairs(keybindButtonsConfig) do
		createKeybindButton(config, targetParent)
	end
end

--Force Enable Lookback and zoom on mobile
local UpdateCharacterDataRegistry = ReplicatedStorage.Events.UpdateCharacterDataRegistry
local camera = workspace.CurrentCamera
local AutoWhistle = false
local TPWALK = false
local AutoCarry = false
local NoFog = false
local TpwalkValue = 1
local Character, humanoid, rootPart
local bodyVelocity, bodyGyro
local ToggleTpwalk = false
local TpwalkConnection
if not AntiNPCDistance then
	AntiNPCDistance = 50
end
local AntiAFKConnection
local originalBrightness = Lighting.Brightness
local originalFogEnd = Lighting.FogEnd
local originalOutdoorAmbient = Lighting.OutdoorAmbient
local originalAmbient = Lighting.Ambient
local originalAtmospheres = {}
for _, v in pairs(Lighting:GetDescendants()) do
	if v:IsA("Atmosphere") then
		table.insert(originalAtmospheres, v)
	end
end
function startNoFog()
	originalFogEnd = Lighting.FogEnd
	Lighting.FogEnd = 1000000
	for _, v in pairs(Lighting:GetDescendants()) do
		if v:IsA("Atmosphere") then
			v:Destroy()
		end
	end
end
function isPlayerGrounded()
	if not Character or not humanoid or not rootPart then
		return false
	end
	local rayOrigin = rootPart.Position
	local rayDirection = Vector3.new(0, - 3, 0)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {
		Character
	}
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	return raycastResult ~= nil
end
-----------------------------------------Modification Stuffs-----------------------------------------------------
local defaultMovementValues = {
	SprintAcceleration = 1,
	SprintCap = 2,
	RunAccel = 1,
	Friction = 5,
	RunDeaccel = 700,
	AirStrafeAcceleration = 182,
	AirAcceleration = 1,
	Speed = 1500,
	JumpHeight = 3,
	JumpCap = 1,
	WalkSpeedMultiplier = 1,
	JumpSpeedMultiplier = 1.45,
	BhopEnabled = false,
	GroundedDistCheck = 2.9
}
local infiniteSlide = false
local slideFriction = - 8
local emoteSpeedEnabled = false
local emoteSpeedType = "Blatant"
local emoteSpeedValue = 1000
local emoteAccelerationValue = - 2
local applyUnwalkableEmoteSpeed = false
local activeMovement = nil
local AutowallHop = false
local autoJumpEnabled = false
local autoJumpType = "Simulation"
local bhopHoldEnabled = false
local accelerationMethod = "Acceleration"
local accelerationValue = - 0.2
local autoAccelerationEnabled = false
local maxAcceleration = 3
local minAcceleration = - 1
local maxAutoAccelSpeed = 70
function getCurrentSpeed(character)
	if not character then
		return 0
	end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return 0
	end
	for _, child in ipairs(hrp:GetChildren()) do
		if child:IsA("LinearVelocity") and child.Name:find("LinearVelocity") then
			local pv = child.PlaneVelocity
			return (pv.X * pv.X + pv.Y * pv.Y) ^ 0.5
		end
	end
	local velocity = hrp.AssemblyLinearVelocity
	return (velocity.X * velocity.X + velocity.Z * velocity.Z) ^ 0.5
end
function MovementValueSet(MovementType, value)
	if not CharacterTag then
		CharacterTag = GetCharacterTag(LocalPlayer.Character)
	end
	if CharacterTag then
		FireClient(ReplicatedStorage.Events.CharacterTask, CharacterTag, "ModifyMovement", {
			MovementType,
			value
		})
	else
		task.spawn(error, "Failed to Overwrite Movement Data! Or maybe your executor dose not support getconnections", 0)
	end
end
local originalRegistry = Movement.RegistryTermUpdated
Movement.RegistryTermUpdated = function(self, term)
	if term == "Emote" then
		activeMovement = self
		local id = self.DataRegistry:Get("Emote")
		if id and id ~= 0 then
			local item = ClientItemService:GetItemFromID(id)
			local mult = item and (require(item).EmoteInfo or {}).SpeedMult or 1
			if emoteSpeedEnabled and emoteSpeedType == "Blatant" then
				if applyUnwalkableEmoteSpeed and mult <= 0 then
					mult = 1
				end
				self.MoveStats:SpeedChange("Emote", mult * (emoteSpeedValue / 1000))
			else
				self.MoveStats:SpeedChange("Emote", mult)
			end
		else
			self.MoveStats:SpeedChange("Emote", nil)
		end
		return
	end
	originalRegistry(self, term)
end
local originalMovementUpdate = Movement.Update
local lastFriction = nil
Movement.Update = function(self, ...)
	originalMovementUpdate(self, ...)
	local humanoid = self.Character and self.Character:FindFirstChild("Humanoid")
	if not humanoid then
		return
	end
	if self.Character == game:GetService("Players").LocalPlayer.Character then
		activeMovement = self
	end
	local LocalPlayer = game:GetService("Players").LocalPlayer
	local LocalPlayerData = CharacterService:GetCharacterFromPlayer(LocalPlayer)
	local movementData = LocalPlayerData and LocalPlayerData.Movement
	local state = movementData and movementData.State
	if not state then
		state = self.State
	end
	local grounded = self.DataRegistry:Get("Grounded")
	local desiredFriction = nil
	local isInfSlide = (state == "Slide" or state == "EmotingSlide" or state == "CarrySlide")
	local isEmoteSlideAccel = (state == "EmotingSlide")
	if isInfSlide then
		if infiniteSlide then
			desiredFriction = slideFriction
		end
	end
	if isEmoteSlideAccel then
		if emoteSpeedEnabled and emoteSpeedType == "Legit" then
			desiredFriction = emoteAccelerationValue
		end
	end
	if desiredFriction == nil and accelerationMethod == "Acceleration" then
		local isBhopActive = autoJumpEnabled or (bhopHoldEnabled and humanoid.Jump == true)
		if isBhopActive and not grounded then
			local currentSpeed = getCurrentSpeed(self.Character)
			if autoAccelerationEnabled then
				if currentSpeed > maxAutoAccelSpeed then
					desiredFriction = maxAcceleration
				elseif currentSpeed < maxAutoAccelSpeed then
					desiredFriction = minAcceleration
				else
					desiredFriction = accelerationValue
				end
			else
				desiredFriction = accelerationValue
			end
		end
	end
	if desiredFriction ~= lastFriction then
		if desiredFriction ~= nil then
			MovementValueSet("Friction", desiredFriction)
		else
			MovementValueSet("Friction", defaultMovementValues.Friction)
		end
		lastFriction = desiredFriction
	end
	if (state == "WallrunRight" or state == "WallrunLeft") and AutowallHop then
		self:AttemptJump()
	end
	if autoJumpEnabled and grounded then
		if autoJumpType == "Realistic" then
			self:AttemptJump()
		else
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
	if bhopHoldEnabled and grounded and humanoid.Jump == true then
		self:AttemptJump()
	end
end
function updateBhopEnabled()
	local shouldEnable = (autoJumpEnabled or bhopHoldEnabled) and accelerationMethod == "Acceleration"
	MovementValueSet("BhopEnabled", shouldEnable)
end
function ToggleInfiniteSlide(state)
	infiniteSlide = state
end
function RefreshEmoteSpeed()
	if activeMovement then
		Movement.RegistryTermUpdated(activeMovement, "Emote")
	end
end
function ToggleBhop(state)
	autoJumpEnabled = state
	updateBhopEnabled()
end
function ToggleBhopHold(state)
	bhopHoldEnabled = state
	updateBhopEnabled()
end
function SetAccelerationMethod(method)
	accelerationMethod = method
	updateBhopEnabled()
	if not (autoJumpEnabled or bhopHoldEnabled) then
		MovementValueSet("Friction", defaultMovementValues.Friction)
		lastFriction = nil
	end
end
---------------------------------------------------------------------------------------------------------------------------
function getDistanceFromPlayer(targetPosition)
	if not Character or not rootPart then
		return 0
	end
	return (targetPosition - rootPart.Position).Magnitude
end
function GetStatus(player)
	local character = player.Character
	if not character then
		return "DEAD"
	end
	local charData = CharacterService:GetCharacterFromPlayer(player)
	if charData and charData.DataRegistry:Get("Downed") then
		return "DOWNED"
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.Health > 0 then
		return "ALIVE"
	end
	return "DEAD"
end
function isPlayerDowned(player)
	return GetStatus(player) == "DOWNED"
end
function isModelDowned(model)
	if not model then
		return false
	end
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.Health <= 0 then
		return true
	end
	if model:GetAttribute("Downed") == true then
		return true
	end
	return false
end
function isPlayerRagdolled(player)
	if not player or not player.Character then
		return false
	end
	local char = player.Character
	if char:FindFirstChild("RagdollConstraints") then
		return true
	end
	local charData = CharacterService:GetCharacterFromPlayer(player)
	if charData and charData.DataRegistry and charData.DataRegistry:Get("Ragdolling") then
		return true
	end
	if char.PrimaryPart and char.PrimaryPart.Anchored then
		return true
	end
	return false
end
function startAntiAFK()
	AntiAFKConnection = LocalPlayer.Idled:Connect(function()
		VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
		task.wait(1)
		VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
	end)
end
function stopAntiAFK()
	if AntiAFKConnection then
		AntiAFKConnection:Disconnect()
		AntiAFKConnection = nil
	end
end
function stopNoFog()
	Lighting.FogEnd = originalFogEnd
	for _, atmosphere in pairs(originalAtmospheres) do
		if not atmosphere.Parent then
			local newAtmosphere = Instance.new("Atmosphere")
			for _, prop in pairs({
				"Density",
				"Offset",
				"Color",
				"Decay",
				"Glare",
				"Haze"
			}) do
				if atmosphere[prop] then
					newAtmosphere[prop] = atmosphere[prop]
				end
			end
			newAtmosphere.Parent = Lighting
		end
	end
end
if not workspace:FindFirstChild("SecurityPart") then
	SecurityPart = Instance.new("Part")
	SecurityPart.Name = "SecurityPart"
	SecurityPart.Size = Vector3.new(10, 1, 10)
	SecurityPart.Position = Vector3.new(50000, 50000, 50000)
	SecurityPart.Anchored = true
	SecurityPart.CanCollide = true
	SecurityPart.Parent = workspace
end
-- Player Tabs
Tabs.Player:Section({
	Title = "Player",
	TextSize = 40
})
Tabs.Player:Divider()
Tabs.Player:Section({
	Title = "Modify Bounce",
	TextSize = 20
})
local bounceConnection = nil
local BounceSpeed = 0
Tabs.Player:Toggle({
	Title = "Modify Multiplier",
	Flag = "BounceEnabled",
	Value = false,
	Callback = function(state)
		if bounceConnection then
			bounceConnection:Disconnect()
			bounceConnection = nil
		end
		if state then
			bounceConnection = game:GetService("RunService").RenderStepped:Connect(function()
				local char = LocalPlayer.Character
				if not char then
					return
				end
				local humanoid = char:FindFirstChild("Humanoid")
				if not humanoid then
					return
				end
				if humanoid.Health <= 0 then
					return
				end
				humanoid.WalkSpeed = BounceSpeed
			end)
		else
			local char = LocalPlayer.Character
			if char then
				local humanoid = char:FindFirstChild("Humanoid")
				if humanoid then
					humanoid.WalkSpeed = 0
				end
			end
		end
	end
})
Tabs.Player:Input({
	Title = "Multiplier value",
	Flag = "VelocityMultiplier",
	Placeholder = "80",
	NumbersOnly = true,
	Callback = function(value)
		BounceSpeed = tonumber(value) or 0
	end
})
Tabs.Player:Section({
	Title = "Supper Bounce",
	TextSize = 20
})
Tabs.Player:Divider()
BounceHeight = 190
BounceInput = Tabs.Player:Input({
	Title = "Bounce Height",
	Placeholder = "190",
	Callback = function(value)
		BounceHeight = tonumber(value) or 50
	end
})
function triggerSuperBounce()
	if not LocalPlayer.Character then
		return
	end
	local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
	local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if humanoid and rootPart then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		rootPart.Velocity = Vector3.new(rootPart.Velocity.X, BounceHeight, rootPart.Velocity.Z)
	end
end
SuperBounceToggle = Tabs.Player:Toggle({
	Title = "Supper Bounce",
	Flag = "SuperBounceToggle",
	Value = false,
	Callback = function(state)
		SuperBounceEnabled = state
		if SuperBounceButton then
			SuperBounceButton:SetVisible(state)
		end
	end
})
SuperBounceButton = ButtonLib.Create:Button({
	Text = "Supper Bounce",
	Flag = "SuperBounce",
	Position = UDim2.new(0.5, - 125, 0.2, 0),
	Visible = false,
	Callback = function()
		triggerSuperBounce()
	end
})
if ButtonLib.SuperBounce then
	ButtonLib.SuperBounce:SetText("Supper Bounce")
end
Tabs.Player:Space()
BounceMultiplier = 5
FallSpeedThreshold = 69
EdgeTrimpEnabled = false
LastFloorMaterial = Enum.Material.Air
LastPosition = Vector3.new()
WasFalling = false
EdgeDetected = false
Character = nil
Humanoid = nil
RootPart = nil
edgeTrimpConnection = nil
charAddedConnection = nil
function handleCharacterAdded(NewCharacter)
	Character = NewCharacter
	Humanoid = Character:WaitForChild("Humanoid")
	RootPart = Character:WaitForChild("HumanoidRootPart")
	LastPosition = RootPart.Position
	WasFalling = false
	EdgeDetected = false
end
Tabs.Player:Space()
EdgeTrimpToggle = Tabs.Player:Toggle({
	Title = "Modify Edge Trimp",
	Flag = "ModifyEdgeTrimp",
	Value = false,
	Callback = function(State)
		EdgeTrimpEnabled = State
		if State then
			if LocalPlayer.Character then
				handleCharacterAdded(LocalPlayer.Character)
			end
			charAddedConnection = LocalPlayer.CharacterAdded:Connect(handleCharacterAdded)
			edgeTrimpConnection = RunService.Heartbeat:Connect(function()
				if not (Character and Humanoid and RootPart) then
					return
				end
				local CurrentPosition = RootPart.Position
				local Velocity = (CurrentPosition - LastPosition) / RunService.Heartbeat:Wait()
				LastPosition = CurrentPosition
				local CurrentFloorMaterial = Humanoid.FloorMaterial
				local IsFalling = Humanoid:GetState() == Enum.HumanoidStateType.Freefall or Humanoid:GetState() == Enum.HumanoidStateType.Jumping
				if CurrentFloorMaterial ~= LastFloorMaterial and CurrentFloorMaterial == Enum.Material.Air and not IsFalling then
					EdgeDetected = true
				else
					EdgeDetected = false
				end
				if EdgeDetected and Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
					local FallVelocity = Velocity.Y
					if FallVelocity < - FallSpeedThreshold then
						local BounceVelocity = math.abs(FallVelocity) * BounceMultiplier
						RootPart.Velocity = Vector3.new(RootPart.Velocity.X, BounceVelocity, RootPart.Velocity.Z)
					end
				end
				LastFloorMaterial = CurrentFloorMaterial
				WasFalling = IsFalling
			end)
		else
			if edgeTrimpConnection then
				edgeTrimpConnection:Disconnect()
				edgeTrimpConnection = nil
			end
			if charAddedConnection then
				charAddedConnection:Disconnect()
				charAddedConnection = nil
			end
		end
	end
})
BounceMultiplierInput = Tabs.Player:Input({
	Title = "Bounce Height Multiplier",
	Flag = "EdgeHeightMultiplier",
	Placeholder = "5",
	Value = tostring(BounceMultiplier),
	NumbersOnly = true,
	Callback = function(Value)
		local Num = tonumber(Value)
		if Num and Num > 0 then
			BounceMultiplier = Num
		end
	end
})
FallSpeedThresholdInput = Tabs.Player:Input({
	Title = "Falling Threshold",
	Flag = "EdgeFallThreshold",
	Placeholder = "69",
	Value = tostring(FallSpeedThreshold),
	NumbersOnly = true,
	Callback = function(Value)
		local Num = tonumber(Value)
		if Num and Num > 0 then
			FallSpeedThreshold = Num
		end
	end
})
do
	local fly_speed = 150
	local originalUpdate = Movement.Update
	local freezeY = nil
	local flying = false
	function getFlyDirection()
		local camCF = Workspace.CurrentCamera.CFrame
		local moveVector = ControlModule:GetMoveVector()
		if moveVector.Magnitude < 0.01 then
			return Vector3.new(0, 0, 0)
		end
		local forward = camCF.LookVector
		local right = camCF.RightVector
		return (forward * - moveVector.Z + right * moveVector.X).Unit * fly_speed
	end
	function flyUpdate(self, dt)
		originalUpdate(self, dt)
		local hrp = self.Character and self.Character:FindFirstChild("HumanoidRootPart")
		if not hrp then
			return
		end
		local flyDir = getFlyDirection()
		if flyDir.Magnitude > 0.1 then
			freezeY = nil
		elseif not freezeY then
			freezeY = hrp.Position.Y
		end
		local newVel = flyDir
		self.DataRegistry:Set("Velocity", newVel * 90)
		hrp.AssemblyLinearVelocity = newVel
		if freezeY and flyDir.Magnitude <= 0.1 then
			local pos = hrp.Position
			hrp.CFrame = CFrame.new(pos.X, freezeY, pos.Z) * (hrp.CFrame - hrp.CFrame.Position)
		end
	end
	function StartFly()
		if flying then
			return
		end
		flying = true
		freezeY = nil
		Movement.Update = flyUpdate
	end
	function StopFly()
		if not flying then
			return
		end
		flying = false
		freezeY = nil
		Movement.Update = originalUpdate
	end
	Tabs.Player:Space()
	FlyToggle = Tabs.Player:Toggle({
		Title = "Fly",
		Flag = "FlyToggle",
		Value = false,
		Callback = function(state)
			if state then
				StartFly()
			else
				StopFly()
			end
		end
	})
	ShowFlyButtonToggle = Tabs.Player:Toggle({
		Title = "Fly Button",
		Flag = "ShowFlyButton",
		Value = false,
		Callback = function(state)
			if ButtonLib and ButtonLib.Flight then
				ButtonLib.Flight:SetVisible(state)
			end
		end
	})
	FlightButton = ButtonLib.Create:Toggle({
		Text = "Flight",
		Flag = "Flight",
		Default = false,
		Visible = false,
		Callback = function(s)
			if FlyToggle then
				FlyToggle:Set(s)
			end
		end
	})
	if ButtonLib.Flight then
		ButtonLib.Flight:SetText("Flight")
	end
	FlightButton.Position = UDim2.new(0.5, - 125, 0.4, 0)
	FlySpeedInput = Tabs.Player:Input({
		Title = "Fly Speed",
		Flag = "FlySpeedInput",
		Placeholder = "Enter speed value",
		Value = "150",
		NumbersOnly = true,
		Callback = function(value)
			local speed = tonumber(value)
			if speed and speed > 0 then
				fly_speed = speed
			end
		end
	})
end
Tabs.Player:Space()
InfiniteSlideToggle = Tabs.Player:Toggle({
	Title = "Infinite Slide",
	Flag = "InfiniteSlideToggle",
	Value = false,
	Callback = function(v)
		ToggleInfiniteSlide(v)
	end
})
Tabs.Player:Toggle({
	Title = "Show Inf Slide Button",
	Callback = function(b)
		InfButton:SetVisible(b)
	end
})
InfButton = ButtonLib.Create:Toggle({
	Text = "Inf Slide",
	Flag = "InfSlide",
	Default = false,
	Visible = false,
	Callback = function(s)
		InfiniteSlideToggle:Set(s)
	end
})
SlideFrictionInput = Tabs.Player:Input({
	Title = "Slide Friction (Negative Only)",
	Flag = "SlideFrictionInput",
	Placeholder = "-8",
	NumbersOnly = false,
	Value = "-8",
	Callback = function(v)
		local n = tonumber(v)
		if n then
			slideFriction = n
		end
	end
})
do
	local noclipConnection = nil
	local noclipEnabled = false
	local wallHelpers, originalWallImpact = nil, nil
	local function hookWallImpact()
		if originalWallImpact then
			return true
		end
		local ok, mod = pcall(function()
			return require(game:GetService("ReplicatedStorage").Objects.Game.Character.Client.Movement.MoveFunction.Functions.Helpers)
		end)
		if not ok or type(mod) ~= "table" or type(mod.WallImpact) ~= "function" then
			return false
		end
		if setreadonly then
			pcall(setreadonly, mod, false)
		end
		wallHelpers, originalWallImpact = mod, mod.WallImpact
		mod.WallImpact = function(_, _, _, _, _, _, velocity)
			return velocity
		end
		return true
	end
	local function unhookWallImpact()
		if wallHelpers and originalWallImpact then
			wallHelpers.WallImpact = originalWallImpact
		end
		wallHelpers, originalWallImpact = nil, nil
	end
	local function setCharacterCollide(char, state)
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = state
			end
		end
	end
	Tabs.Player:Space()
	noclipCFrame = Tabs.Player:Toggle({
		Title = "Noclip",
		Desc = "Walk through walls (disables the game's wall check)",
		Flag = "noclipCFrame",
		Value = false,
		Callback = function(state)
			noclipEnabled = state
			if state then
				if not LocalPlayer.Character then
					WindUI:Notify({
						Title = "Noclip",
						Content = "Wait for character to load",
						Duration = 3
					})
					return
				end
				if noclipConnection then
					noclipConnection:Disconnect()
					noclipConnection = nil
				end
				local hooked = hookWallImpact()
				if not hooked then
					WindUI:Notify({
						Title = "Noclip",
						Content = "Wall check module not found, using CFrame fallback",
						Duration = 3
					})
				end
				noclipConnection = RunService.RenderStepped:Connect(function()
					local char = LocalPlayer.Character
					if not char then
						return
					end
					local hrp = char:FindFirstChild("HumanoidRootPart")
					local humanoid = char:FindFirstChild("Humanoid")
					if not hrp or not humanoid then
						return
					end
					if humanoid.Health <= 0 then
						return
					end
					setCharacterCollide(char, false)
					if not hooked then
						local moveDir = humanoid.MoveDirection
						if moveDir.Magnitude > 0 then
							hrp.CFrame = hrp.CFrame + (moveDir * 0.1)
						end
					end
				end)
			else
				if noclipConnection then
					noclipConnection:Disconnect()
					noclipConnection = nil
				end
				unhookWallImpact()
				local char = LocalPlayer.Character
				if char then
					setCharacterCollide(char, true)
				end
			end
		end
	})
	LocalPlayer.CharacterAdded:Connect(function(char)
		if noclipEnabled then
			task.wait(0.5)
			setCharacterCollide(char, false)
		end
	end)
end
Tabs.Player:Space()
do
	local rampBoostMultiplier = 2
	local rampBoostConnection = nil
	stopRampBooster = function()
		if rampBoostConnection then
			rampBoostConnection:Disconnect()
			rampBoostConnection = nil
		end
	end
	local function startRampBooster()
		stopRampBooster()
		local armed = true
		rampBoostConnection = RunService.Heartbeat:Connect(function(dt)
			local character = LocalPlayer.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			local root = humanoid and (humanoid.RootPart or character.PrimaryPart)
			if not root then
				return
			end
			local velocity = root.AssemblyLinearVelocity
			local vy = velocity.Y
			local gravity = workspace.Gravity
			local jumpSpeed = humanoid.UseJumpPower and humanoid.JumpPower or math.sqrt(2 * gravity * humanoid.JumpHeight)
			local limit = jumpSpeed + gravity * dt
			if not armed and vy <= 0 then
				armed = true
			end
			if armed and vy > limit then
				armed = false
				root.AssemblyLinearVelocity = Vector3.new(velocity.X, vy * rampBoostMultiplier, velocity.Z)
			end
		end)
	end
	Tabs.Player:Toggle({
		Title = "Ramp Booster",
		Desc = "Multiplies your upward speed when a ramp launches you",
		Flag = "RampBoosterToggle",
		Value = false,
		Callback = function(state)
			if state then
				startRampBooster()
			else
				stopRampBooster()
			end
		end
	})
	Tabs.Player:Input({
		Title = "Ramp Booster Multiplier",
		Flag = "RampBoosterMultiplierInput",
		Placeholder = "2",
		NumbersOnly = false,
		Value = "2",
		Callback = function(v)
			local n = tonumber(v)
			if n and n > 0 then
				rampBoostMultiplier = n
			end
		end
	})
end
Tabs.Player:Space()
WalkOnWaterToggle = Tabs.Player:Toggle({
	Title = "Walk On Water",
	Flag = "WalkOnWater",
	Value = false,
	Callback = function(state)
		local partsFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Parts")
		if not partsFolder then
			return
		end
		local waterFolder = partsFolder:FindFirstChild("Water")
		if not waterFolder then
			return
		end
		local fakeWaterFolder = partsFolder:FindFirstChild("FakeWater")
		if not fakeWaterFolder then
			fakeWaterFolder = Instance.new("Folder")
			fakeWaterFolder.Name = "FakeWater"
			fakeWaterFolder.Parent = partsFolder
		end
		if state then
			if waterRenderConnection then
				waterRenderConnection:Disconnect()
			end
			waterRenderConnection = game:GetService("RunService").RenderStepped:Connect(function()
				for _, part in ipairs(waterFolder:GetChildren()) do
					if part:IsA("BasePart") and part.Parent ~= fakeWaterFolder then
						part.CanCollide = true
						part.Parent = fakeWaterFolder
					end
				end
			end)
		else
			if waterRenderConnection then
				waterRenderConnection:Disconnect()
				waterRenderConnection = nil
			end
			for _, part in ipairs(fakeWaterFolder:GetChildren()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
					part.Parent = waterFolder
				end
			end
		end
	end
})
Tabs.Player:Space()
local tpwalkConnection = nil
local tpwalkEnabled = false
function startTpwalk()
	if tpwalkConnection then
		tpwalkConnection:Disconnect()
		tpwalkConnection = nil
	end
	tpwalkEnabled = true
	tpwalkConnection = RunService.RenderStepped:Connect(function()
		local v282 = 10
		if not tpwalkEnabled then
			return
		end
		local char = LocalPlayer.Character
		if not char then
			return
		end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local humanoid = char:FindFirstChild("Humanoid")
		if not hrp or not humanoid then
			return
		end
		local moveDir = humanoid.MoveDirection
		if moveDir.Magnitude > 0 then
			local speed = TpwalkValue
			hrp.AssemblyLinearVelocity = Vector3.new(
moveDir.X * v282 * speed, hrp.AssemblyLinearVelocity.Y, moveDir.Z * v282 * speed)
		end
	end)
end
function stopTpwalk()
	tpwalkEnabled = false
	if tpwalkConnection then
		tpwalkConnection:Disconnect()
		tpwalkConnection = nil
	end
	local char = LocalPlayer.Character
	if char then
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
		end
	end
end
TPWALKToggle = Tabs.Player:Toggle({
	Title = "Teleport Walk",
	Flag = "TPWALKToggle",
	Value = false,
	Callback = function(state)
		if state then
			startTpwalk()
		else
			stopTpwalk()
		end
	end
})
TPWALKSlider = Tabs.Player:Slider({
	Title = "Teleport Walk Value",
	Flag = "TPWALKSlider",
	Desc = "Adjust Teleport Walk speed",
	Value = {
		Min = 1,
		Max = 200,
		Default = 1,
		Step = 1
	},
	Callback = function(value)
		TpwalkValue = value
	end
})
LocalPlayer.CharacterAdded:Connect(function()
	if tpwalkEnabled then
		task.wait(0.5)
		startTpwalk()
	end
end)
Tabs.Player:Section({
	Title = "Modification"
})
BaseSpeedInput = Tabs.Player:Input({
	Title = "Speed",
	Placeholder = tostring(defaultMovementValues.Speed),
	NumbersOnly = true,
	Value = tostring(defaultMovementValues.Speed)
})
BaseSpeedInput.Callback = function(value)
	MovementValueSet("Speed", tonumber(value))
end
Tabs.Player:Space()
JumpHeightInput = Tabs.Player:Input({
	Title = "Jump height",
	Placeholder = tostring(defaultMovementValues.JumpHeight),
	NumbersOnly = true,
	Value = tostring(defaultMovementValues.JumpHeight)
})
JumpHeightInput.Callback = function(value)
	MovementValueSet("JumpHeight", tonumber(value))
end
JumpCapInput = Tabs.Player:Input({
	Title = "Jump Cap",
	Placeholder = tostring(defaultMovementValues.JumpCap),
	NumbersOnly = true,
	Value = tostring(defaultMovementValues.JumpCap)
})
JumpCapInput.Callback = function(value)
	MovementValueSet("JumpCap", tonumber(value))
end
JumpSpeedMultiplierInput = Tabs.Player:Input({
	Title = "Jump Speed Multiplier",
	Placeholder = tostring(defaultMovementValues.JumpSpeedMultiplier),
	NumbersOnly = true,
	Value = tostring(defaultMovementValues.JumpSpeedMultiplier)
})
JumpSpeedMultiplierInput.Callback = function(value)
	MovementValueSet("JumpSpeedMultiplier", tonumber(value))
end
Tabs.Player:Space()
AirStrafeAccelerationInput = Tabs.Player:Input({
	Title = "Air Strafe Acceleration",
	Placeholder = tostring(defaultMovementValues.AirStrafeAcceleration),
	NumbersOnly = true,
	Value = tostring(defaultMovementValues.AirStrafeAcceleration)
})
AirStrafeAccelerationInput.Callback = function(value)
	MovementValueSet("AirStrafeAcceleration", tonumber(value))
end
AirAccelerationInput = Tabs.Player:Input({
	Title = "Air Acceleration",
	Placeholder = tostring(defaultMovementValues.AirAcceleration),
	NumbersOnly = true,
	Value = tostring(defaultMovementValues.AirAcceleration)
})
AirAccelerationInput.Callback = function(value)
	MovementValueSet("AirAcceleration", tonumber(value))
end
Tabs.Player:Space()
SprintCapInput = Tabs.Player:Input({
	Title = "Sprint Cap",
	Placeholder = tostring(defaultMovementValues.SprintCap),
	NumbersOnly = true,
	Value = tostring(defaultMovementValues.SprintCap)
})
SprintCapInput.Callback = function(value)
	MovementValueSet("SprintCap", tonumber(value))
end
SprintAccelerationInput = Tabs.Player:Input({
	Title = "Sprint Acceleration",
	Placeholder = tostring(defaultMovementValues.SprintAcceleration),
	NumbersOnly = true,
	Value = tostring(defaultMovementValues.SprintAcceleration)
})
SprintAccelerationInput.Callback = function(value)
	MovementValueSet("SprintAcceleration", tonumber(value))
end
Tabs.Player:Space()
RunAccelInput = Tabs.Player:Input({
	Title = "Run Acceleration",
	Placeholder = tostring(defaultMovementValues.RunAccel),
	NumbersOnly = true,
	Value = tostring(defaultMovementValues.RunAccel)
})
RunAccelInput.Callback = function(value)
	MovementValueSet("RunAccel", tonumber(value))
end
RunDeaccelInput = Tabs.Player:Input({
	Title = "Run Deacceleration",
	Placeholder = tostring(defaultMovementValues.RunDeaccel),
	NumbersOnly = true,
	Value = tostring(defaultMovementValues.RunDeaccel)
})
RunDeaccelInput.Callback = function(value)
	MovementValueSet("RunDeaccel", tonumber(value))
end
FrictionInput = Tabs.Player:Input({
	Title = "Friction",
	Placeholder = tostring(defaultMovementValues.Friction),
	NumbersOnly = true,
	Value = tostring(defaultMovementValues.Friction)
})
FrictionInput.Callback = function(value)
	MovementValueSet("Friction", tonumber(value))
end
Tabs.Player:Space()
WalkSpeedMultiplierInput = Tabs.Player:Input({
	Title = "Walk Speed Multiplier",
	Placeholder = tostring(defaultMovementValues.WalkSpeedMultiplier),
	NumbersOnly = true,
	Value = tostring(defaultMovementValues.WalkSpeedMultiplier)
})
WalkSpeedMultiplierInput.Callback = function(value)
	MovementValueSet("WalkSpeedMultiplier", tonumber(value))
end
GroundedDistCheckInput = Tabs.Player:Input({
	Title = "Grounded Distance Check",
	Placeholder = tostring(defaultMovementValues.GroundedDistCheck),
	NumbersOnly = true,
	Value = tostring(defaultMovementValues.GroundedDistCheck)
})
GroundedDistCheckInput.Callback = function(value)
	MovementValueSet("GroundedDistCheck", tonumber(value))
end
Tabs.Player:Section({
	Title = "Emote Speed"
})
EmoteSpeedToggle = Tabs.Player:Toggle({
	Title = "Enable Emote Speed",
	Flag = "EmoteSpeedToggle",
	Value = false,
	Callback = function(v)
		emoteSpeedEnabled = v
		RefreshEmoteSpeed()
	end
})
EmoteSpeedType = Tabs.Player:Dropdown({
	Title = "Emote Speed Type",
	Flag = "EmoteSpeedType",
	Values = {
		"Blatant",
		"Legit"
	},
	Value = "Blatant",
	Callback = function(value)
		emoteSpeedType = value
		RefreshEmoteSpeed()
	end
})
EmoteSpeedInput = Tabs.Player:Input({
	Title = "Emote Speed Value",
	Flag = "EmoteSpeedInput",
	Placeholder = "1000",
	NumbersOnly = true,
	Value = "1000",
	Callback = function(v)
		emoteSpeedValue = tonumber(v) or 1000
		RefreshEmoteSpeed()
	end
})
ApplyUnwalkableEmoteSpeedToggle = Tabs.Player:Toggle({
	Title = "Apply Unwalkable Emote Speed",
	Flag = "ApplyUnwalkableEmoteSpeed",
	Type = "Checkbox",
	Value = false,
	Callback = function(v)
		applyUnwalkableEmoteSpeed = v
		RefreshEmoteSpeed()
	end
})
EmoteAccelerationInput = Tabs.Player:Input({
	Title = "Emote Acceleration (Negative Only)",
	Flag = "EmoteAccelerationInput",
	Desc = "Negative Only",
	Placeholder = "-2",
	NumbersOnly = true,
	Value = "-2",
	Callback = function(v)
		emoteAccelerationValue = tonumber(v) or - 2
	end
})
ResetEmoteSpeedButton = Tabs.Player:Button({
	Title = "Reset Emote Speed",
	Desc = "Having Trouble? reset the speed or rejoin",
	Callback = function()
		emoteSpeedValue = 1000
		emoteAccelerationValue = - 2
		emoteSpeedType = "Blatant"
		if EmoteSpeedInput then
			EmoteSpeedInput:Set("1000")
		end
		if EmoteAccelerationInput then
			EmoteAccelerationInput:Set("-2")
		end
		if EmoteSpeedType then
			EmoteSpeedType:Select("Blatant")
		end
		RefreshEmoteSpeed()
	end
})
Tabs.Combat:Button({
	Title = "Visual Infinite Ammo",
	Callback = function()
		local ReplicatedStorage = ReplicatedStorage
		for _, tool in ipairs(ReplicatedStorage.Tools:GetChildren()) do
			if tool:IsA("ModuleScript") then
				local success, module = pcall(require, tool)
				if success and module and module.Tasks then
					for _, task in ipairs(module.Tasks) do
						if task.ResourceInfo and task.ResourceInfo.Type == "Clip" then
							task.ResourceInfo.Reserve = 9999999999
							task.ResourceInfo.Cap = 9999999999
						end
					end
				end
			end
		end
	end
})
Tabs.Combat:Space()
Tabs.Combat:Button({
	Title = "Visual No Tool Delay",
	Callback = function()
		function setFastShoot(data)
			if type(data) ~= "table" then
				return
			end
			for key, value in pairs(data) do
				if key == "Cooldown" and type(value) == "number" then
					data[key] = 1 / 65536
				elseif type(value) == "table" then
					setFastShoot(value)
				end
			end
		end
		for _, tool in pairs(ReplicatedStorage.Tools:GetChildren()) do
			if tool:IsA("ModuleScript") then
				local success, toolData = pcall(require, tool)
				if success and type(toolData) == "table" and toolData.Tasks then
					for _, task in ipairs(toolData.Tasks) do
						for _, func in ipairs(task.Functions or {}) do
							for _, activation in ipairs(func.Activations or {}) do
								for _, method in ipairs(activation.Methods or {}) do
									if method.Info then
										setFastShoot(method.Info)
									end
								end
							end
						end
						for _, autoFunc in ipairs(task.AutomaticFunctions or {}) do
							for _, method in ipairs(autoFunc.Methods or {}) do
								if method.Info then
									setFastShoot(method.Info)
								end
							end
						end
					end
				end
			end
		end
	end
})
Tabs.Combat:Space()
Tabs.Combat:Button({
	Title = "Disable Weapon Spread",
	Callback = function()
		local ReplicatedStorage = ReplicatedStorage
		for _, tool in ipairs(ReplicatedStorage.Tools:GetChildren()) do
			if tool:IsA("ModuleScript") then
				local success, module = pcall(require, tool)
				if success and module and module.Tasks then
					for _, task in ipairs(module.Tasks) do
						if task.MethodReferences and task.MethodReferences.Projectile and task.MethodReferences.Projectile.Info and task.MethodReferences.Projectile.Info.SpreadInfo then
							task.MethodReferences.Projectile.Info.SpreadInfo.MaxSpread = 0
							task.MethodReferences.Projectile.Info.SpreadInfo.MinSpread = 0
						end
					end
				end
			end
		end
	end
})
Tabs.Combat:Space()
local defibrillator = {
	Equipped = false,
	AuraEnabled = false,
	AuraRange = 20,
	Connection = nil,
	EquipDelay = 0,
	ReviveDelay = 0
}
function StopReviveAura()
	defibrillator.AuraEnabled = false
	if defibrillator.Connection then
		defibrillator.Connection:Disconnect()
		defibrillator.Connection = nil
	end
	if defibrillator.Equipped then
		UpdateCharacterDataRegistry:FireServer({
			buffer.fromstring("\8\0"),
			buffer.fromstring("\1")
		})
		defibrillator.Equipped = false
	end
end
function StartReviveAura()
	if defibrillator.Connection then
		StopReviveAura()
	end
	defibrillator.AuraEnabled = true
	defibrillator.Connection = RunService.RenderStepped:Connect(function()
		if not defibrillator.AuraEnabled then
			return
		end
		local found = false
		local localChar = LocalPlayer.Character
		local localPos = localChar and localChar:FindFirstChild("HumanoidRootPart")
		if not localPos then
			return
		end
		for _, player in pairs(Players:GetPlayers()) do
			if isPlayerDowned(player) then
				local character = player.Character
				local targetHRP = character:FindFirstChild("HumanoidRootPart")
				if targetHRP then
					local distance = (localPos.Position - targetHRP.Position).Magnitude
					local range = defibrillator.AuraRange
					if range == "inf" or (type(range) == "number" and distance <= range) then
						found = true
						local tag = character:GetAttribute("Tag")
						if tag then
							if not defibrillator.Equipped then
								if defibrillator.EquipDelay > 0 then
									task.wait(defibrillator.EquipDelay)
								end
								UpdateCharacterDataRegistry:FireServer({
									buffer.fromstring("\008\000"),
									buffer.fromstring("\003")
								})
								defibrillator.Equipped = true
							end
							if defibrillator.ReviveDelay > 0 then
								task.wait(defibrillator.ReviveDelay)
							end
							ToolAction:FireServer(buffer.fromstring("\001\001\001\001"), tag)
						end
					end
				end
			end
		end
		if not found and defibrillator.Equipped then
			UpdateCharacterDataRegistry:FireServer({
				buffer.fromstring("\8\0"),
				buffer.fromstring("\1")
			})
			defibrillator.Equipped = false
		end
	end)
end
Tabs.Combat:Toggle({
	Title = "Defibrillator Aura",
	Desc = "Auto Token Bug closest downed player",
	Value = false,
	Callback = function(state)
		if state then
			StartReviveAura()
		else
			StopReviveAura()
		end
	end
})
Tabs.Combat:Input({
	Title = "Aura Range",
	Placeholder = "20 or inf",
	Value = "20",
	Callback = function(value)
		if value == "inf" then
			defibrillator.AuraRange = "inf"
		else
			local num = tonumber(value)
			if num then
				defibrillator.AuraRange = num
			end
		end
	end
})
Tabs.Combat:Input({
	Title = "Equip Delay (seconds)",
	Value = "0",
	Callback = function(value)
		defibrillator.EquipDelay = tonumber(value) or 0
	end
})
Tabs.Combat:Input({
	Title = "Revive Delay (seconds)",
	Value = "0",
	Callback = function(value)
		defibrillator.ReviveDelay = tonumber(value) or 0
	end
})
Tabs.Combat:Space()
Tabs.Combat:Button({
	Title = "Infinite Range",
	Callback = function()
		function setInfiniteRange(data)
			if type(data) ~= "table" then
				return
			end
			for key, value in pairs(data) do
				if (key == "Range" or key == "LungeRange" or key == "HearingRange") and type(value) == "number" then
					data[key] = math.huge
				elseif key == "DamageDistanceInterval" and type(value) == "table" and # value >= 2 then
					value[2] = math.huge
				elseif type(value) == "table" then
					setInfiniteRange(value)
				end
			end
		end
		for _, tool in pairs(ReplicatedStorage.Tools:GetChildren()) do
			if tool:IsA("ModuleScript") then
				local success, toolData = pcall(require, tool)
				if success and type(toolData) == "table" and toolData.Tasks then
					for _, task in ipairs(toolData.Tasks) do
						for _, func in ipairs(task.Functions or {}) do
							for _, activation in ipairs(func.Activations or {}) do
								for _, method in ipairs(activation.Methods or {}) do
									if method.Info then
										setInfiniteRange(method.Info)
									end
								end
							end
						end
						for _, autoFunc in ipairs(task.AutomaticFunctions or {}) do
							for _, method in ipairs(autoFunc.Methods or {}) do
								if method.Info then
									setInfiniteRange(method.Info)
								end
							end
						end
					end
				end
			end
		end
	end
})
Tabs.Combat:Space()
Tabs.Combat:Button({
	Title = "Portal bypass",
	Callback = function()
		Portal.IsPortalPossible = function(...)
			return true
		end
	end
})
Tabs.Combat:Space()
Tabs.Combat:Button({
	Title = "Build Offset Multiplier",
	Value = false,
	Callback = function(state)
		local oldGetClientPosition = BuildModule.GetClientPosition
		BuildModule.GetClientPosition = function(self, ...)
			local valid, cframe = oldGetClientPosition(self, ...)
			if cframe then
				cframe = cframe * CFrame.new(getgenv().BuildOffsetX, getgenv().BuildOffsetY, getgenv().BuildOffsetZ)
			end
			return valid, cframe
		end
	end
})
Tabs.Combat:Input({
	Title = "Offset X",
	Value = "0",
	Placeholder = "0",
	NumbersOnly = true,
	Callback = function(v)
		getgenv().BuildOffsetX = tonumber(v) or 0
	end
})
Tabs.Combat:Input({
	Title = "Offset Y",
	Value = "0",
	Placeholder = "0",
	NumbersOnly = true,
	Callback = function(v)
		getgenv().BuildOffsetY = tonumber(v) or 0
	end
})
Tabs.Combat:Input({
	Title = "Offset Z",
	Value = "0",
	Placeholder = "0",
	NumbersOnly = true,
	Callback = function(v)
		getgenv().BuildOffsetZ = tonumber(v) or 0
	end
})
Tabs.Combat:Space()
Tabs.Combat:Button({
	Title = "Bypass \\\"TooMany\\\" Consumables item limit",
	Callback = function()
		for i = 1, 4 do
			local a = PlayerGui:FindFirstChild("Shared")
			if a then
				a = a:FindFirstChild("HUD")
			end
			if a then
				a = a:FindFirstChild("Interactors")
			end
			if a then
				a = a:FindFirstChild("Popups")
			end
			if a then
				a = a:FindFirstChild("Usables")
			end
			if a then
				a = a:FindFirstChild("Wheel")
			end
			if a then
				local b = a:FindFirstChild("Item" .. i)
				if b then
					b = b:FindFirstChild("Icon")
				end
				if b then
					b = b:FindFirstChild("TooMany")
				end
				if b then
					b:Destroy()
				end
			end
		end
		for i = 1, 4 do
			local a = ReplicatedStorage:FindFirstChild("Misc")
			if a then
				a = a:FindFirstChild("UI")
			end
			if a then
				a = a:FindFirstChild("Shared")
			end
			if a then
				a = a:FindFirstChild("HUD")
			end
			if a then
				a = a:FindFirstChild("Interactors")
			end
			if a then
				a = a:FindFirstChild("Popups")
			end
			if a then
				a = a:FindFirstChild("Usables")
			end
			if a then
				a = a:FindFirstChild("Wheel")
			end
			if a then
				local b = a:FindFirstChild("Item" .. i)
				if b then
					b = b:FindFirstChild("Icon")
				end
				if b then
					b = b:FindFirstChild("TooMany")
				end
				if b then
					b:Destroy()
				end
			end
		end
	end
})
Tabs.Combat:Space()
-- Auto Tab
Tabs.Auto:Section({
	Title = "Auto",
	TextSize = 40
})
local changePlayerMode = ReplicatedStorage.Events.SetPlayerMode
local isRejoiningRespawn = false
local autoJoinEnabled = false
local connection = nil
local RejoinRepsawnConnection = nil
local lastFireTime = 0
function checkAndFire()
	if not autoJoinEnabled then
		return
	end
	local isDead = false
	local deathGui = PlayerGui:FindFirstChild("Shared")
	if deathGui then
		local respawn = deathGui:FindFirstChild("Respawn")
		if respawn then
			local types = respawn:FindFirstChild("Types")
			if types then
				local death = types:FindFirstChild("Death")
				if death and death.Visible then
					isDead = true
				end
			end
		end
	end
	local menu = PlayerGui:FindFirstChild("Menu")
	if menu then
		isDead = true
	end
	if isDead then
		if not isRejoiningRespawn then
			isRejoiningRespawn = true
		end
		if isRejoiningRespawn then
			local currentTime = tick()
			if currentTime - lastFireTime >= 10 then
				changePlayerMode:FireServer(true)
				lastFireTime = currentTime
			end
		end
	else
		isRejoiningRespawn = false
	end
end
toggleAutoJoin = Tabs.Auto:Toggle({
	Title = "Auto Join",
	Value = false,
	Callback = function(state)
		autoJoinEnabled = state
		if state then
			if not connection then
				connection = RunService.RenderStepped:Connect(checkAndFire)
			end
			if not RejoinRepsawnConnection then
				RejoinRepsawnConnection = LocalPlayer.CharacterAdded:Connect(function()
					isRejoiningRespawn = false
					lastFireTime = 0
				end)
			end
		else
			if connection then
				connection:Disconnect()
				connection = nil
			end
			if RejoinRepsawnConnection then
				RejoinRepsawnConnection:Disconnect()
				RejoinRepsawnConnection = nil
			end
			isRejoiningRespawn = false
			lastFireTime = 0
		end
	end
})
Tabs.Auto:Space()
local KeybindType = {
	HasSeen = {},
	KeyList = {},
}
local SpamKeybind = {
	Enabled = false,
	Connection = nil,
	Delay = 0.6,
	LastTick = os.clock(),
	KeybindTarget = "None",
}
for bindName, data in pairs(DefaultKeybinds) do
	if type(data) == "table" and data.Type then
		local t = tostring(data.Type)
		if not KeybindType.HasSeen[t] then
			KeybindType.HasSeen[t] = true
			table.insert(KeybindType.KeyList, t)
		end
	end
end
function StartSpamKeybind()
	local isDown = false
	SpamKeybind.Connection = RunService.RenderStepped:Connect(function()
		if os.clock() - SpamKeybind.LastTick >= SpamKeybind.Delay and SpamKeybind.Enabled then
			SpamKeybind.LastTick = os.clock()
			SendKeybindEvent(SpamKeybind.KeybindTarget, isDown)
			isDown = not isDown
		end
	end)
end
function StopSpamKeybind()
	if SpamKeybind.Connection then
		SpamKeybind.Connection:Disconnect()
		SpamKeybind.Connection = nil
	end
end
Tabs.Auto:Space()
SpamKeybindToggle = Tabs.Auto:Toggle({
	Title = "Enable Spam Keybind",
	Value = false,
	Callback = function(value)
		SpamKeybind.Enabled = value
		if value then
			StartSpamKeybind()
		else
			StopSpamKeybind()
		end
	end
})
ButtonLib.Create:Toggle({
	Text = "Smash Keybinds",
	Flag = "SpamKeybindButton",
	Default = false,
	Visible = false,
	Callback = function(value)
		SpamKeybindToggle:Set(not SpamKeybindToggle.Value)
	end
})
Tabs.Auto:Toggle({
	Title = "Show Keybinds Spam button",
	Value = false,
	Callback = function(value)
		ButtonLib.SpamKeybindButton:SetVisible(value)
	end
})
Tabs.Auto:Input({
	Title = "Keybind Delay",
	Value = SpamKeybind.Delay,
	Callback = function(value)
		SpamKeybind.Delay = tonumber(value) or SpamKeybind.Delay
	end
})
Tabs.Auto:Dropdown({
	Title = "Keybind Type",
	Values = KeybindType.KeyList,
	Value = "None",
	Callback = function(value)
		SpamKeybind.KeybindTarget = value
	end
})
Tabs.Auto:Section({
	Title = "Bhop"
})
BhopToggle = Tabs.Auto:Toggle({
	Title = "Bhop",
	Flag = "BhopToggle",
	Value = false,
	Callback = function(state)
		ToggleBhop(state)
	end
})
BhopHoldToggle = Tabs.Auto:Toggle({
	Title = "Bhop Hold Jump",
	Flag = "BhopHoldToggle",
	Value = false,
	Callback = function(state)
		ToggleBhopHold(state)
	end
})
AccelerationDropdown = Tabs.Auto:Dropdown({
	Title = "Bhop Mode",
	Flag = "AccelerationDropdown",
	Values = {
		"No Acceleration",
		"Acceleration"
	},
	Value = "Acceleration",
	Callback = function(value)
		SetAccelerationMethod(value)
	end
})
AccelerationInput = Tabs.Auto:Input({
	Title = "Bhop Acceleration (Negative Only)",
	Flag = "AccelerationInput",
	Placeholder = "-0.2",
	Numeric = true,
	Value = "-0.2",
	Callback = function(value)
		local n = tonumber(value)
		if n then
			accelerationValue = n
		end
	end
})
AutoJumpTypeDropdown = Tabs.Auto:Dropdown({
	Title = "Auto Jump Mode",
	Flag = "AutoJumpTypeDropdown",
	Values = {
		"Simulation",
		"Realistic"
	},
	Value = "Simulation",
	Callback = function(value)
		autoJumpType = value
		if autoJumpEnabled or bhopHoldEnabled then
			unloadBhop()
			loadBhop()
		end
	end
})
AutoWallHop = Tabs.Auto:Toggle({
	Title = "Auto Wall Hop",
	Flag = "AutoWallHop",
	Value = false,
	Type = "Checkbox",
	Callback = function(state)
		AutowallHop = state
	end
})
ShowBunnyHopButtonToggle = Tabs.Auto:Toggle({
	Title = "Show Bhop Button",
	Flag = "ShowBunnyHopButton",
	Value = false,
	Callback = function(state)
		if ButtonLib and ButtonLib.BunnyHopToggle then
			ButtonLib.BunnyHopToggle:SetVisible(state)
		end
	end
})
ButtonLib.Create:Toggle({
	Text = "Bunny Hop",
	Flag = "BunnyHopToggle",
	Default = false,
	Visible = false,
	Callback = function(s)
		if BhopToggle then
			BhopToggle:Set(s)
		end
	end
}).Position = UDim2.new(0.5, - 125, 0.4, 0)
Tabs.Auto:Section({
	Title = "Auto Acceleration"
})
AutoAccelerationToggle = Tabs.Auto:Toggle({
	Title = "Auto Acceleration (Legit)",
	Flag = "AutoAccelerationToggle",
	Value = false,
	Callback = function(state)
		autoAccelerationEnabled = state
	end
})
MaxAccelerationInput = Tabs.Auto:Input({
	Title = "Max Acceleration",
	Flag = "MaxAccelerationInput",
	Placeholder = "3",
	Numeric = true,
	Value = "3",
	Callback = function(value)
		n = tonumber(value)
		if n then
			maxAcceleration = n
		end
	end
})
MinAccelerationInput = Tabs.Auto:Input({
	Title = "Min Acceleration",
	Flag = "MinAccelerationInput",
	Placeholder = "-1",
	Numeric = true,
	Value = "-1",
	Callback = function(value)
		n = tonumber(value)
		if n then
			minAcceleration = n
		end
	end
})
MaxSpeedInput = Tabs.Auto:Input({
	Title = "Max Speed",
	Flag = "MaxSpeedInput",
	Placeholder = "70",
	Numeric = true,
	Value = "70",
	Callback = function(value)
		n = tonumber(value)
		if n and n > 0 then
			maxAutoAccelSpeed = n
		end
	end
})
local oldGetMoveVector = nil
local ControlModule = nil
local jumpConnection = nil
function preserveJumpVelocity()
	if jumpConnection then
		jumpConnection:Disconnect()
	end
	jumpConnection = RunService.Heartbeat:Connect(function()
		local char = LocalPlayer.Character
		if not char then
			return
		end
		local humanoid = char:FindFirstChild("Humanoid")
		local rootPart = char:FindFirstChild("HumanoidRootPart")
		if not humanoid or not rootPart then
			return
		end
		local state = humanoid:GetState()
		if state == Enum.HumanoidStateType.Jumping then
			if lastVelocity.Magnitude > 0 then
				local currentVel = rootPart.AssemblyLinearVelocity
				if currentVel.Magnitude < lastVelocity.Magnitude then
					rootPart.AssemblyLinearVelocity = Vector3.new(
lastVelocity.X, currentVel.Y, lastVelocity.Z)
				end
			end
			lastVelocity = rootPart.AssemblyLinearVelocity
		elseif state == Enum.HumanoidStateType.Landed then
			lastVelocity = Vector3.new()
		end
	end)
end
Tabs.Auto:Section({
	Title = "Auto Walk",
	TextSize = 20
})
Tabs.Auto:Divider()
AutoWalkToggle = Tabs.Auto:Toggle({
	Title = "Auto Walk",
	Flag = "AutoWalkToggle",
	Value = false,
	Callback = function(state)
		if state then
			if success and mod then
				ControlModule = mod
				oldGetMoveVector = ControlModule.GetMoveVector
				ControlModule.GetMoveVector = function(...)
					local input = oldGetMoveVector(...)
					return input.Magnitude > 0.1 and input or MOVE_DIRECTION
				end
			end
			preserveJumpVelocity()
		else
			if ControlModule and oldGetMoveVector then
				ControlModule.GetMoveVector = oldGetMoveVector
				oldGetMoveVector = nil
				ControlModule = nil
			end
			if jumpConnection then
				jumpConnection:Disconnect()
				jumpConnection = nil
			end
		end
	end
})
ShowAutoWalkButtonToggle = Tabs.Auto:Toggle({
	Title = "Show Auto Walk Button",
	Flag = "ShowAutoWalkButton",
	Value = false,
	Callback = function(state)
		if ButtonLib and ButtonLib.AutoWalkToggle then
			ButtonLib.AutoWalkToggle:SetVisible(state)
		end
	end
})
AutoWalkDirectionInput = Tabs.Auto:Input({
	Title = "Move Direction",
	Flag = "AutoWalkDirectionInput",
	Placeholder = "X Y Z",
	Value = "0 0 1",
	Callback = function(value)
		local x, y, z = value:match("([%d.-]+)%s+([%d.-]+)%s+([%d.-]+)")
		if x and y and z then
			MOVE_DIRECTION = Vector3.new(tonumber(x), tonumber(y), tonumber(z))
		end
	end
})
ButtonLib.Create:Toggle({
	Text = "Auto Walk",
	Flag = "AutoWalkToggle",
	Default = false,
	Visible = false,
	Callback = function(s)
		if AutoWalkToggle then
			AutoWalkToggle:Set(s)
		end
	end
}).Position = UDim2.new(0.5, - 125, 0.4, 0)
Tabs.Auto:Space()
local crouchConnection = nil
local CrouchDelay = 0
local arg_v784 = 0
local arg_v785 = false
function StartAutoCrouch()
	if crouchConnection then
		return
	end
	crouchConnection = RunService.RenderStepped:Connect(function()
		local autoOn = AutoCrouch
		local mode = AutoCrouchMode
		if not autoOn then
			SendKeybindEvent("Crouching", false)
			return
		end
		local character = Players.LocalPlayer.Character
		if not character or not character:FindFirstChild("Humanoid") then
			return
		end
		local humanoid = character.Humanoid
		local isAir = (humanoid.FloorMaterial == Enum.Material.Air) and (humanoid:GetState() ~= Enum.HumanoidStateType.Seated)
		if mode == "Spam" then
			local currentTime = tick()
			if currentTime - arg_v784 >= CrouchDelay then
				arg_v785 = not arg_v785
				SendKeybindEvent("Crouching", arg_v785)
				arg_v784 = currentTime
			end
		elseif mode == "Normal" then
			SendKeybindEvent("Crouching", true)
		elseif mode == "Air" and isAir then
			SendKeybindEvent("Crouching", true)
		elseif mode == "Ground" and not isAir then
			SendKeybindEvent("Crouching", true)
		else
			SendKeybindEvent("Crouching", false)
		end
	end)
end
function StopAutoCrouch()
	if crouchConnection then
		crouchConnection:Disconnect()
		crouchConnection = nil
	end
	arg_v784 = 0
	arg_v785 = false
	SendKeybindEvent("Crouching", false)
end
Tabs.Auto:Space()
AutoCrouchToggle = Tabs.Auto:Toggle({
	Title = "Auto Crouch",
	Flag = "AutoCrouchToggle",
	Value = false,
	Callback = function(state)
		AutoCrouch = state
		if state then
			StartAutoCrouch()
		else
			StopAutoCrouch()
		end
	end
})
Tabs.Auto:Input({
	Title = "Spam Delay (seconds)",
	Value = "0",
	Callback = function(delay)
		CrouchDelay = tonumber(delay) or 0
	end
})
ButtonLib.Create:Toggle({
	Text = "Auto Crouch",
	Flag = "AutoCrouchToggle",
	Default = false,
	Visible = false,
	Callback = function(s)
		if AutoCrouchToggle then
			AutoCrouchToggle:Set(s)
		end
	end
}).Position = UDim2.new(0.5, - 125, 0.4, 0)
ShowAutoCrouchButtonToggle = Tabs.Auto:Toggle({
	Title = "Show Auto Crouch Button",
	Flag = "ShowAutoCrouchButton",
	Value = false,
	Callback = function(state)
		ShowAutoCrouchButton = state
		ButtonLib.AutoCrouchToggle:SetVisible(state)
	end
})
AutoCrouchModeDropdown = Tabs.Auto:Dropdown({
	Title = "Auto Crouch Mode",
	Flag = "AutoCrouchModeDropdown",
	Values = {
		"Air",
		"Spam",
		"Ground",
		"Normal"
	},
	Value = "Air",
	Callback = function(value)
		AutoCrouchMode = value
		arg_v784 = 0
		arg_v785 = false
		if value ~= "Spam" then
			SendKeybindEvent("Crouching", false)
		end
	end
})
Tabs.Auto:Space()
AutoCarryConnection = nil
local lastCarryAttempt = 0
local carryCooldown = 0.5
function startAutoCarry()
	AutoCarryConnection = RunService.Heartbeat:Connect(function()
		if not AutoCarry then
			return
		end
		local char = LocalPlayer.Character
		if not char then
			return
		end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then
			return
		end
		local charData = CharacterService:GetCharacterFromPlayer(LocalPlayer)
		if not charData then
			return
		end
		local movement = charData.Movement
		if not movement then
			return
		end
		local state = movement.State
		local carryStates = {
			"Carry",
			"CarrySlide",
			"CarrySlideAir",
			"CarryAir",
			"Carried",
			"CarryMove",
			"CarryIdle"
		}
		local isCarrying = false
		for _, s in ipairs(carryStates) do
			if state == s then
				isCarrying = true
				break
			end
		end
		if isCarrying then
			return
		end
		local now = tick()
		if now - lastCarryAttempt < carryCooldown then
			return
		end
		for _, other in ipairs(Players:GetPlayers()) do
			if other == LocalPlayer then
				continue
			end
			local otherChar = other.Character
			if not otherChar then
				continue
			end
			if isPlayerDowned(other) then
				if isPlayerRagdolled(other) then
					continue
				end
				local otherHRP = otherChar:FindFirstChild("HumanoidRootPart")
				if not otherHRP then
					continue
				end
				local dist = (hrp.Position - otherHRP.Position).Magnitude
				local targetTag = otherChar:GetAttribute("Tag")
				if targetTag then
					pcall(function()
						Interact:FireServer("Carry", targetTag)
					end)
					lastCarryAttempt = now
					break
				end
			end
		end
	end)
end
function stopAutoCarry()
	if AutoCarryConnection then
		AutoCarryConnection:Disconnect()
		AutoCarryConnection = nil
	end
end
AutoCarryToggle = Tabs.Auto:Toggle({
	Title = "Auto Carry",
	Flag = "AutoCarryToggle",
	Value = false,
	Callback = function(state)
		AutoCarry = state
		if state then
			startAutoCarry()
		else
			stopAutoCarry()
		end
	end
})
ButtonLib.Create:Toggle({
	Text = "AUTO CARRY",
	Flag = "CarryToggle",
	Default = false,
	Visible = false,
	Callback = function(s)
		if AutoCarryToggle then
			AutoCarryToggle:Set(s)
		end
	end
}).Position = UDim2.new(0.5, - 125, 0.4, 0)
ShowCarryButtonToggle = Tabs.Auto:Toggle({
	Title = "Show Carry Button",
	Flag = "ShowCarryButton",
	Value = false,
	Callback = function(state)
		ShowCarryButton = state
		if ButtonLib and ButtonLib.CarryToggle then
			ButtonLib.CarryToggle:SetVisible(state)
		end
	end
})
Tabs.Auto:Space()
local AutoVote = {
	Enabled = false,
	Map = 1,
	Mode = 1,
	Connections = {
		Map = nil,
		Mode = nil
	}
}
function getVotePopup()
	if ServerStateRegistryService.Registry.Voting == false then
		return nil
	end
	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	if not playerGui then
		return nil
	end
	local shared = playerGui:FindFirstChild("Shared")
	if shared then
		local popups = shared:FindFirstChild("Popups")
		if popups then
			local voteActive = popups:FindFirstChild("VoteActive")
			if voteActive and voteActive.Visible then
				return voteActive
			end
			local vote = popups:FindFirstChild("Vote")
			if vote and vote.Visible then
				return vote
			end
		end
	end
	return nil
end
function fireVoteServer(mapNumber)
	local votePopup = getVotePopup()
	if not votePopup then
		return
	end
	local voteEvent = ReplicatedStorage:FindFirstChild("Events")
	if voteEvent then
		voteEvent = voteEvent:FindFirstChild("Vote")
		if voteEvent and voteEvent:IsA("RemoteEvent") then
			voteEvent:FireServer(mapNumber)
		end
	end
end
function fireVoteMode(modeNumber)
	local votePopup = getVotePopup()
	if not votePopup then
		return
	end
	local voteEvent = ReplicatedStorage:FindFirstChild("Events")
	if voteEvent then
		voteEvent = voteEvent:FindFirstChild("Vote")
		if voteEvent and voteEvent:IsA("RemoteEvent") then
			voteEvent:FireServer(modeNumber, true)
		end
	end
end
function StartAutoVoteMap()
	StopAutoVoteMap()
	AutoVote.Enabled = true
	AutoVote.Connections.Map = RunService.Heartbeat:Connect(function()
		fireVoteServer(AutoVote.Map)
	end)
end
function StopAutoVoteMap()
	AutoVote.Enabled = false
	if AutoVote.Connections.Map then
		AutoVote.Connections.Map:Disconnect()
		AutoVote.Connections.Map = nil
	end
end
function StartAutoVoteMode()
	StopAutoVoteMode()
	AutoVote.Enabled = true
	AutoVote.Connections.Mode = RunService.Heartbeat:Connect(function()
		fireVoteMode(AutoVote.Mode)
	end)
end
function StopAutoVoteMode()
	if AutoVote.Connections.Mode then
		AutoVote.Connections.Mode:Disconnect()
		AutoVote.Connections.Mode = nil
	end
end
local mapDropdownValues = {}
for i = 1, 4 do
	table.insert(mapDropdownValues, "Map " .. i)
end
AutoVoteDropdown = Tabs.Auto:Dropdown({
	Title = "Auto Vote Map",
	Flag = "AutoVoteDropdown",
	Values = mapDropdownValues,
	Value = "Map 1",
	Callback = function(value)
		AutoVote.Map = tonumber(value:match("%d+"))
	end
})
AutoVoteToggle = Tabs.Auto:Toggle({
	Title = "Auto Vote Map",
	Flag = "AutoVoteToggle",
	Value = false,
	Callback = function(state)
		if state then
			StartAutoVoteMap()
		else
			StopAutoVoteMap()
		end
	end
})
Tabs.Auto:Space()
local modeDropdownValues = {}
for i = 1, 4 do
	table.insert(modeDropdownValues, "Mode " .. i)
end
AutoVoteModeDropdown = Tabs.Auto:Dropdown({
	Title = "Auto Vote Mode",
	Flag = "AutoVoteModeDropdown",
	Values = modeDropdownValues,
	Value = "Mode 1",
	Callback = function(value)
		AutoVote.Mode = tonumber(value:match("%d+"))
	end
})
AutoVoteModeToggle = Tabs.Auto:Toggle({
	Title = "Auto Vote Game Mode",
	Flag = "AutoVoteModeToggle",
	Value = false,
	Callback = function(state)
		if state then
			StartAutoVoteMode()
		else
			StopAutoVoteMode()
		end
	end
})
SelfRevive = {
	Method = "Spawnpoint",
	Enabled = false,
	HasRevived = false,
	LastSavedPosition = nil,
	IsProcessing = false,
	LastRespawnTime = 0,
	Connections = {
		Heartbeat = nil,
		Character = nil,
	}
}
function SelfRevive:Respawn()
	local now = tick()
	if now - SelfRevive.LastRespawnTime < 0.5 then
		return
	end
	SelfRevive.LastRespawnTime = now
	if SelfRevive.IsProcessing then
		return
	end
	local char = LocalPlayer.Character
	if not char then
		return
	end
	local charData = CharacterService:GetCharacterFromPlayer(LocalPlayer)
	local isDowned = charData and charData.DataRegistry:Get("Downed")
	if not isDowned then
		return
	end
	SelfRevive.IsProcessing = true
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if SelfRevive.Method == "Spawnpoint" then
		if not SelfRevive.HasRevived then
			self.HasRevived = true
			pcall(function()
				changePlayerMode:FireServer(true)
			end)
			SelfRevive.IsProcessing = false
			task.delay(10, function()
				self.HasRevived = false
			end)
		else
			SelfRevive.IsProcessing = false
		end
	elseif self.Method == "Fake Revive" then
		local savedPos = nil
		if hrp then
			savedPos = hrp.CFrame.Position
		end
		task.spawn(function()
			pcall(function()
				changePlayerMode:FireServer(true)
			end)
			local newCharacter
			repeat
				newCharacter = LocalPlayer.Character
				task.wait()
			until newCharacter and newCharacter:FindFirstChild("HumanoidRootPart") and newCharacter ~= char
			if newCharacter then
				local newHRP = newCharacter:FindFirstChild("HumanoidRootPart")
				if savedPos and newHRP then
					task.wait(0.1)
					newHRP.CFrame = CFrame.new(savedPos + Vector3.new(0, 0, 0))
				end
			end
			SelfRevive.IsProcessing = false
		end)
	else
		SelfRevive.IsProcessing = false
	end
end
function SelfRevive:Start()
	if SelfRevive.Connections.Heartbeat then
		return
	end
	SelfRevive.Enabled = true
	SelfRevive.Connections.Heartbeat = RunService.Heartbeat:Connect(function()
		if not SelfRevive.Enabled then
			return
		end
		local char = LocalPlayer.Character
		if not char then
			return
		end
		local charData = CharacterService:GetCharacterFromPlayer(LocalPlayer)
		if charData and charData.DataRegistry:Get("Downed") then
			self:Respawn()
		end
	end)
	SelfRevive.Connections.Character = LocalPlayer.CharacterAdded:Connect(function(newChar)
		SelfRevive.HasRevived = false
		SelfRevive.IsProcessing = false
		SelfRevive.LastSavedPosition = nil
	end)
end
function SelfRevive:Stop()
	SelfRevive.Enabled = false
	SelfRevive.HasRevived = false
	SelfRevive.IsProcessing = false
	SelfRevive.LastSavedPosition = nil
	for name, conn in pairs(SelfRevive.Connections) do
		if conn then
			conn:Disconnect()
			SelfRevive.Connections[name] = nil
		end
	end
end
Tabs.Auto:Space()
AutoSelfReviveToggle = Tabs.Auto:Toggle({
	Title = "Auto Self Revive",
	Flag = "AutoSelfReviveToggle",
	Value = false,
	Callback = function(state)
		if state then
			SelfRevive:Start()
		else
			SelfRevive:Stop()
		end
	end
})
SelfReviveMethodDropdown = Tabs.Auto:Dropdown({
	Title = "Self Revive Method",
	Flag = "SelfReviveMethodDropdown",
	Values = {
		"Spawnpoint",
		"Fake Revive"
	},
	Value = "Spawnpoint",
	Callback = function(value)
		SelfRevive.Method = value
	end
})
Tabs.Auto:Button({
	Title = "Manual Revive",
	Desc = "Manually revive yourself",
	Icon = "heart",
	Callback = function()
		SelfRevive:Respawn()
	end
})
Tabs.Auto:Button({
	Title = "Force Respawn",
	Icon = "heart",
	Callback = function()
		changePlayerMode:FireServer(true)
	end
})
Tabs.Auto:Space()
AutoWhistleToggle = Tabs.Auto:Toggle({
	Title = "Auto Whistle",
	Flag = "AutoWhistleToggle",
	Value = false,
	Callback = function(state)
		AutoWhistle = state
		if state then
			startAutoWhistle()
		else
			stopAutoWhistle()
		end
	end
})
local autoWhistleConnection = nil
local lastWhistle = 0
function startAutoWhistle()
	if autoWhistleConnection then
		return
	end
	lastWhistle = tick()
	autoWhistleConnection = RunService.Heartbeat:Connect(function()
		if not AutoWhistle then
			return
		end
		local now = tick()
		if now - lastWhistle >= 1 then
			lastWhistle = now
			pcall(function()
				ReplicatedStorage
:WaitForChild("Services")
:WaitForChild("Client")
:WaitForChild("KeybindService")
:WaitForChild("SendKeybindEvent")
:Fire({
					["Down"] = true,
					["Key"] = "Whistle"
				})
			end)
		end
	end)
end
function stopAutoWhistle()
	AutoWhistle = false
	if autoWhistleConnection then
		autoWhistleConnection:Disconnect()
		autoWhistleConnection = nil
	end
end
Tabs.Auto:Space()
function isNPCModel(model)
	if not model or not model:IsA("Model") then
		return false
	end
	if model:GetAttribute("AI") == true then
		return true
	end
	if model:FindFirstChild("HumanoidRootPart") and model:FindFirstChild("Humanoid") then
		local parent = model.Parent
		if parent and parent.Name == "Players" then
			if model:GetAttribute("AI") == true then
				return true
			end
		end
	end
	return false
end
function isModelDowned(model)
	if not model or not model:IsA("Model") then
		return false
	end
	local humanoid = model:FindFirstChild("Humanoid")
	if humanoid and humanoid.Health <= 0 then
		return true
	end
	return false
end
function getCurrentHRP()
	local char = LocalPlayer.Character
	if char then
		return char:FindFirstChild("HumanoidRootPart")
	end
	return nil
end
function getPlayersWithHRP()
	local result = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			table.insert(result, plr)
		end
	end
	return result
end
function getDownedPlayers()
	local downed = {}
	function scanFolder(folder)
		if not folder then
			return
		end
		for _, model in ipairs(folder:GetChildren()) do
			if model:IsA("Model") and isModelDowned(model) and model.Name ~= LocalPlayer.Name then
				local hrp = model:FindFirstChild("HumanoidRootPart")
				if hrp then
					table.insert(downed, model)
				end
			end
		end
	end
	scanFolder(workspace:FindFirstChild("Players"))
	local gameFolder = workspace:FindFirstChild("Game")
	if gameFolder then
		scanFolder(gameFolder:FindFirstChild("Players"))
	end
	return downed
end
function getNPCs()
	local bots = {}
	function scanFolder(folder)
		if not folder then
			return
		end
		for _, model in ipairs(folder:GetChildren()) do
			if model:IsA("Model") and isNPCModel(model) then
				local hrp = model:FindFirstChild("HumanoidRootPart")
				if hrp then
					table.insert(bots, model)
				end
			end
		end
	end
	scanFolder(workspace:FindFirstChild("Players"))
	local gameFolder = workspace:FindFirstChild("Game")
	if gameFolder then
		scanFolder(gameFolder:FindFirstChild("Players"))
	end
	return bots
end
function getSpawns()
	local spawnsFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Parts") and workspace.Map.Parts:FindFirstChild("Spawns")
	if not spawnsFolder then
		spawnsFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Parts") and workspace.Map.Parts:FindFirstChild("Spawns")
	end
	if spawnsFolder then
		return spawnsFolder:GetChildren()
	end
	return {}
end
function getTickets()
	local tickets = workspace:FindFirstChild("Effects") and workspace.Effects:FindFirstChild("Tickets")
	if not tickets then
		tickets = workspace:FindFirstChild("Effects") and workspace.Effects:FindFirstChild("Tickets")
	end
	if tickets then
		return tickets:GetChildren()
	end
	return {}
end
function getObjectives()
	local objectives = {}
	local gameFolder = workspace:FindFirstChild("Game")
	if not gameFolder then
		return objectives
	end
	local mapFolder = gameFolder:FindFirstChild("Map")
	if not mapFolder then
		return objectives
	end
	local partsFolder = mapFolder:FindFirstChild("Parts")
	if not partsFolder then
		return objectives
	end
	local objectivesFolder = partsFolder:FindFirstChild("Objectives")
	if not objectivesFolder then
		return objectives
	end
	for _, obj in pairs(objectivesFolder:GetChildren()) do
		if obj:IsA("Model") then
			local primaryPart = obj.PrimaryPart
			if not primaryPart then
				for _, part in pairs(obj:GetChildren()) do
					if part:IsA("BasePart") then
						primaryPart = part
						break
					end
				end
			end
			if primaryPart then
				table.insert(objectives, {
					Name = obj.Name,
					Part = primaryPart,
					Position = primaryPart.Position,
					Size = primaryPart.Size
				})
			end
		end
	end
	return objectives
end
function teleportToCFrame(cframeOffset)
	local hrp = getCurrentHRP()
	if hrp then
		hrp.CFrame = cframeOffset
	end
end
function teleportToPart(part, offset)
	if part then
		teleportToCFrame(part.CFrame + offset)
	end
end
function teleportToRandomFromList(list, offset)
	if # list > 0 then
		local target = list[math.random(1, # list)]
		local hrp = target:FindFirstChild("HumanoidRootPart")
		if hrp then
			teleportToCFrame(hrp.CFrame + offset)
		end
	end
end
function teleportToRandomPlayer(offset)
	local players = getPlayersWithHRP()
	if # players > 0 then
		local target = players[math.random(1, # players)]
		teleportToCFrame(target.Character.HumanoidRootPart.CFrame + offset)
	end
end
function teleportToRandomDowned(offset)
	local downed = getDownedPlayers()
	teleportToRandomFromList(downed, offset)
end
function teleportToRandomNPC(offset)
	local bots = getNPCs()
	teleportToRandomFromList(bots, offset)
end
function teleportToRandomSpawn(offset)
	local spawns = getSpawns()
	if # spawns > 0 then
		local target = spawns[math.random(1, # spawns)]
		teleportToCFrame(target.CFrame + offset)
	end
end
function teleportToRandomTicket(offset)
	local tickets = getTickets()
	if # tickets > 0 then
		local target = tickets[math.random(1, # tickets)]
		local part = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChildWhichIsA("BasePart")
		if part then
			teleportToCFrame(part.CFrame + offset)
		end
	end
end
function teleportToSelectedPlayer(plr, offset)
	if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
		teleportToCFrame(plr.Character.HumanoidRootPart.CFrame + offset)
	end
end
function teleportToObjective(objectiveName, offset)
	local objectives = getObjectives()
	for _, obj in ipairs(objectives) do
		if obj.Name == objectiveName then
			local teleportPosition = obj.Position + offset
			local raycastParams = RaycastParams.new()
			local char = LocalPlayer.Character
			if char then
				raycastParams.FilterDescendantsInstances = {
					char
				}
			end
			raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
			local ray = workspace:Raycast(teleportPosition, Vector3.new(0, - 10, 0), raycastParams)
			if ray then
				teleportPosition = ray.Position + Vector3.new(0, 3, 0)
			end
			teleportToCFrame(CFrame.new(teleportPosition))
			return
		end
	end
end
function teleportToSecurityPart(offset)
	local existingPart = SecurityPart or workspace:FindFirstChild("SecurityPart")
	if existingPart then
		local character = game.Players.LocalPlayer.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			character.HumanoidRootPart.CFrame = CFrame.new(existingPart.Position + offset)
		end
	else
		print("SecurityPart not found")
	end
end
AutoFarmType = {
	"Auto Ticket",
	"Token Farm"
}
local TicketsFolder = workspace:FindFirstChild("Effects") and workspace.Effects:FindFirstChild("Tickets")
local AutoFarm = {
	Enabled = false,
	Modes = {},
	Connection = nil,
	WarningShown = false,
	ReviveTarget = nil,
	FireCount = 0,
	LastReviveFire = 0,
	LastTokenFire = 0,
	TokenDelay = 2,
	TokenOffset = Vector3.new(0, - 11, 0),
}
local AutoObjective = {
	Enabled = false,
	Thread = nil,
	Delay = 0.2,
}
function isTokenFarmLocalPlayerModel(model)
	if not model then
		return true
	end
	if model == LocalPlayer.Character then
		return true
	end
	if model.Name == LocalPlayer.Name then
		return true
	end
	if model.Name == tostring(LocalPlayer.UserId) then
		return true
	end
	local attrName = model:GetAttribute("Name")
	if attrName == LocalPlayer.Name or attrName == LocalPlayer.DisplayName then
		return true
	end
	local attrTag = model:GetAttribute("Tag")
	if attrTag == LocalPlayer.Name or attrTag == LocalPlayer.DisplayName then
		return true
	end
	local userId = model:GetAttribute("UserId") or model:GetAttribute("PlayerUserId")
	if typeof(userId) == "number" and userId == LocalPlayer.UserId then
		return true
	end
	return false
end
function isValidTokenFarmTarget(model)
	if not model or not model.Parent or not model:IsA("Model") then
		return false
	end
	if model.Parent.Name ~= "Players" then
		return false
	end
	if isTokenFarmLocalPlayerModel(model) then
		return false
	end
	if not model:FindFirstChild("HumanoidRootPart") then
		return false
	end
	if model:GetAttribute("Tag") == nil then
		return false
	end
	return true
end
function pickRandomTokenFarmTarget()
	local playersFolder = workspace:FindFirstChild("Players")
	if not playersFolder then
		return nil
	end
	local valid = {}
	for _, model in ipairs(playersFolder:GetChildren()) do
		if isValidTokenFarmTarget(model) then
			table.insert(valid, model)
		end
	end
	if # valid == 0 then
		return nil
	end
	return valid[math.random(1, # valid)]
end
function StartAutoObjective()
	if AutoObjective.Enabled then
		return
	end
	AutoObjective.Enabled = true
	AutoObjective.Thread = task.spawn(function()
		while AutoObjective.Enabled do
			local objectivesContainer = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Parts") and workspace.Map.Parts:FindFirstChild("Objectives")
			if objectivesContainer then
				local anyCompleted = false
				for _, obj in pairs(objectivesContainer:GetChildren()) do
					if obj:GetAttribute("Completed") == true then
						anyCompleted = true
						break
					end
				end
				if not anyCompleted then
					for _, objective in pairs(objectivesContainer:GetChildren()) do
						if not AutoObjective.Enabled then
							break
						end
						if objective:FindFirstChild("WhenActivated") then
							local tagValue = objective:GetAttribute("Tag")
							if tagValue then
								pcall(function()
									Interact:FireServer("Dynamic", tagValue)
								end)
								task.wait(AutoObjective.Delay)
							end
						end
					end
				end
			end
			task.wait(0.2)
		end
	end)
end
function StopAutoObjective()
	AutoObjective.Enabled = false
	if AutoObjective.Thread then
		pcall(task.cancel, AutoObjective.Thread)
		AutoObjective.Thread = nil
	end
end
function StartAutoFarm()
	if AutoFarm.Connection then
		AutoFarm.Connection:Disconnect()
		AutoFarm.Connection = nil
	end
	AutoFarm.Enabled = true
	AutoFarm.Connection = game:GetService("RunService").Heartbeat:Connect(function()
		local char = game.Players.LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then
			return
		end
		local hasTicket = table.find(AutoFarm.Modes, AutoFarmType[1])
		local hasTokenFarm = table.find(AutoFarm.Modes, AutoFarmType[2])
		if not hasTokenFarm then
			teleportToSecurityPart(Vector3.new(0, 3, 0))
		end
		if hasTicket then
			local ticket = TicketsFolder and TicketsFolder:GetChildren()[1]
			if ticket then
				local target = ticket:FindFirstChild("HumanoidRootPart") or ticket:FindFirstChildWhichIsA("BasePart")
				if target then
					hrp.CFrame = target.CFrame + Vector3.new(0, 3, 0)
				end
			end
		end
		if hasTokenFarm then
			if not isValidTokenFarmTarget(AutoFarm.ReviveTarget) then
				AutoFarm.ReviveTarget = pickRandomTokenFarmTarget()
			end
			local target = AutoFarm.ReviveTarget
			if target then
				local targetHrp = target:FindFirstChild("HumanoidRootPart")
				if targetHrp then
					hrp.CFrame = targetHrp.CFrame + AutoFarm.TokenOffset
					local tag = target:GetAttribute("Tag")
					if tag then
						local now = tick()
						if now - AutoFarm.LastTokenFire >= AutoFarm.TokenDelay then
							AutoFarm.LastTokenFire = now
							pcall(function()
								Interact:FireServer("Revive", tag)
								Interact:FireServer("Revive", tag, true)
							end)
						end
					end
				end
			else
				teleportToSecurityPart(Vector3.new(0, 3, 0))
			end
		end
	end)
end
function StopAutoFarm()
	AutoFarm.Enabled = false
	if AutoFarm.Connection then
		AutoFarm.Connection:Disconnect()
		AutoFarm.Connection = nil
	end
	AutoFarm.ReviveTarget = nil
	AutoFarm.FireCount = 0
	AutoFarm.LastReviveFire = 0
	AutoFarm.LastTokenFire = 0
end
Tabs.Auto:Dropdown({
	Title = "Auto Farm Mode",
	Flag = "AutoFarmDropdown",
	Values = AutoFarmType,
	Multi = true,
	AllowNone = true,
	Value = {},
	Callback = function(selected)
		AutoFarm.Modes = selected
	end
})
TokenFarmOffsetInput = Tabs.Auto:Input({
	Title = "Token Farm Offset",
	Flag = "TokenFarmOffsetInput",
	Placeholder = "X Y Z",
	Value = "0 -11 0",
	Callback = function(value)
		local x, y, z = value:match("^%s*([%-%d%.]+)%s+([%-%d%.]+)%s+([%-%d%.]+)%s*$")
		if x and y and z then
			AutoFarm.TokenOffset = Vector3.new(tonumber(x), tonumber(y), tonumber(z))
		end
	end
})
TokenFarmDelaySlider = Tabs.Auto:Slider({
	Title = "Token Farm Delay",
	Flag = "TokenFarmDelaySlider",
	Desc = "Revive fire delay in seconds",
	Step = 0.01,
	Value = {
		Min = 0.4,
		Max = 4,
		Default = 2
	},
	Callback = function(value)
		AutoFarm.TokenDelay = value
	end
})
AutoFarmToggle = Tabs.Auto:Toggle({
	Title = "Auto Farm",
	Flag = "AutoFarmToggle",
	Value = false,
	Callback = function(state)
		if state then
			AntiAfkToggle:Set(true)
			AutoSelfReviveToggle:Set(true)
			local isVIP = game.Players.LocalPlayer:GetAttribute("VIPCommandsAccess") == true
			if isVIP or AutoFarm.WarningShown then
				StartAutoFarm()
			else
				WindUI:Popup({
					Title = "<b><font color='#FF5555'>WARNING! BAN WAVE!</font></b>",
					Icon = "shield-x",
					Content = [[<b><font color='#FFAA00'>⚠️DO NOT USE AUTO FARM ON PUBLIC SERVER OR UNTRUSTED PRIVATE SERVER! IF YOU DON'T WANNA GET BAN!</font></b>
<font color='#4fe000'> • Be Sure Use It On Your Own Private Server To Avoid BAN!</font>
<b><font color='#FF5555'> • IF YOU KEEP CONTINUE DOING THIS YOU WILL GET BAN ANYTIME SOON!</font></b>
<b><font color='#FF5555'> 🚫 WHEN YOU GET BANNED, THERE'S NO UNBAN APPEAL!</font></b>
<font color='#FF5555'> Remember: Staff will not giving you second chance!</font>]],
					Buttons = {
						{
							Title = "Cancel",
							Callback = function()
								AutoFarmToggle:Set(false)
							end,
							Variant = "Destructive"
						},
						{
							Title = "Continue Anyway",
							Icon = "shield-check",
							Callback = function()
								AutoFarm.WarningShown = true
								StartAutoFarm()
							end,
							Variant = "Primary"
						}
					}
				})
			end
		else
			StopAutoFarm()
		end
	end
})
AutoCompleteObjectiveToggle = Tabs.Auto:Toggle({
	Title = "Auto Complete Objective",
	Flag = "AutoCompleteObjectiveToggle",
	Value = false,
	Callback = function(state)
		if state then
			StartAutoObjective()
		else
			StopAutoObjective()
		end
	end
})
Tabs.Auto:Space()
Tabs.Auto:Paragraph({
	Title = "Token Farm has been pathched you no longer be able to use goe mode"
})
-- Visuals Tab
Tabs.Visuals:Section({
	Title = "Visual",
	TextSize = 20
})
Tabs.Visuals:Divider()
local cameraStretchConnection
function setupCameraStretch()
	cameraStretchConnection = nil
	local stretchHorizontal = 0.80
	local stretchVertical = 0.80
	CameraStretchToggle = Tabs.Visuals:Toggle({
		Title = "Camera Stretch",
		Flag = "CameraStretchToggle",
		Value = false,
		Callback = function(state)
			if state then
				if cameraStretchConnection then
					cameraStretchConnection:Disconnect()
				end
				cameraStretchConnection = game:GetService("RunService").RenderStepped:Connect(function()
					local Camera = workspace.CurrentCamera
					Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, stretchHorizontal, 0, 0, 0, stretchVertical, 0, 0, 0, 1)
				end)
			else
				if cameraStretchConnection then
					cameraStretchConnection:Disconnect()
					cameraStretchConnection = nil
				end
			end
		end
	})
	CameraStretchHorizontalInput = Tabs.Visuals:Input({
		Title = "Camera Stretch Horizontal",
		Flag = "CameraStretchHorizontalInput",
		Placeholder = "0.80",
		Numeric = true,
		Value = tostring(stretchHorizontal),
		Callback = function(value)
			local num = tonumber(value)
			if num then
				stretchHorizontal = num
				if cameraStretchConnection then
					cameraStretchConnection:Disconnect()
					cameraStretchConnection = game:GetService("RunService").RenderStepped:Connect(function()
						local Camera = workspace.CurrentCamera
						Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, stretchHorizontal, 0, 0, 0, stretchVertical, 0, 0, 0, 1)
					end)
				end
			end
		end
	})
	CameraStretchVerticalInput = Tabs.Visuals:Input({
		Title = "Camera Stretch Vertical",
		Flag = "CameraStretchVerticalInput",
		Placeholder = "0.80",
		Numeric = true,
		Value = tostring(stretchVertical),
		Callback = function(value)
			local num = tonumber(value)
			if num then
				stretchVertical = num
				if cameraStretchConnection then
					cameraStretchConnection:Disconnect()
					cameraStretchConnection = game:GetService("RunService").RenderStepped:Connect(function()
						local Camera = workspace.CurrentCamera
						Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, stretchHorizontal, 0, 0, 0, stretchVertical, 0, 0, 0, 1)
					end)
				end
			end
		end
	})
end
setupCameraStretch()
Tabs.Visuals:Space()
local fadeConnection = nil
local fadeEnabled = false
DisableFadeeffectToggle = Tabs.Visuals:Toggle({
	Title = "Disable Fade effect",
	Flag = "DisableFadeeffectToggle",
	Value = false,
	Callback = function(state)
		fadeEnabled = state
		if fadeConnection then
			fadeConnection:Disconnect()
			fadeConnection = nil
		end
		local coverScreen = PlayerGui:FindFirstChild("Shared")
		if coverScreen then
			coverScreen = coverScreen:FindFirstChild("Popups")
			if coverScreen then
				coverScreen = coverScreen:FindFirstChild("CoverScreen")
			end
		end
		if not coverScreen then
			return
		end
		if state then
			coverScreen.Visible = false
			fadeConnection = coverScreen:GetPropertyChangedSignal("Visible"):Connect(function()
				if fadeEnabled and coverScreen.Visible == true then
					coverScreen.Visible = false
				end
			end)
		else
			coverScreen.Visible = true
		end
	end
})
Tabs.Visuals:Space()
FullBrightToggle = Tabs.Visuals:Toggle({
	Title = "Full Bright",
	Flag = "FullBrightToggle",
	Desc = "Ya Like drinking Night Vision while mining in da cave and sceard of creeper blow you up dawg?",
	Value = false,
	Callback = function(state)
		FullBright = state
		if state then
			originalBrightness = Lighting.Brightness
			originalAmbient = Lighting.Ambient
			originalOutdoorAmbient = Lighting.OutdoorAmbient
			originalColorShiftBottom = Lighting.ColorShift_Bottom
			originalColorShiftTop = Lighting.ColorShift_Top
			function applyFullBright()
				if Lighting.Brightness ~= 1 then
					Lighting.Brightness = 1
				end
				if Lighting.Ambient ~= Color3.new(1, 1, 1) then
					Lighting.Ambient = Color3.new(1, 1, 1)
				end
				if Lighting.OutdoorAmbient ~= Color3.new(1, 1, 1) then
					Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
				end
				if Lighting.ColorShift_Bottom ~= Color3.new(1, 1, 1) then
					Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
				end
				if Lighting.ColorShift_Top ~= Color3.new(1, 1, 1) then
					Lighting.ColorShift_Top = Color3.new(1, 1, 1)
				end
			end
			applyFullBright()
			if fullBrightConnection then
				fullBrightConnection:Disconnect()
			end
			fullBrightConnection = RunService.Heartbeat:Connect(function()
				if FullBright then
					applyFullBright()
				end
			end)
			fullBrightCharConnection = game.Players.LocalPlayer.CharacterAdded:Connect(function()
				task.wait(1)
				if FullBright then
					applyFullBright()
				end
			end)
		else
			if fullBrightConnection then
				fullBrightConnection:Disconnect()
				fullBrightConnection = nil
			end
			if fullBrightCharConnection then
				fullBrightCharConnection:Disconnect()
				fullBrightCharConnection = nil
			end
			if originalBrightness then
				Lighting.Brightness = originalBrightness
				Lighting.Ambient = originalAmbient
				Lighting.OutdoorAmbient = originalOutdoorAmbient
				Lighting.ColorShift_Bottom = originalColorShiftBottom
				Lighting.ColorShift_Top = originalColorShiftTop
			end
		end
	end
})
Tabs.Visuals:Space()
NoFogToggle = Tabs.Visuals:Toggle({
	Title = "Remove Fog",
	Flag = "NoFogToggle",
	Value = false,
	Callback = function(state)
		NoFog = state
		if state then
			startNoFog()
		else
			stopNoFog()
		end
	end
})
local TimerGUI = nil
local TimerEnabled = false
local SpecialRoundEnabled = false
local CurrentSpecialRoundName = ""
local OriginalTimerVisible = false
local CheckingGameTimer = false
local _attributeConnection = nil
local _attributeConnection2 = nil
local _attributeConnection3 = nil
function createTimerGUI()
	local RoundTimerTemplate = ReplicatedStorage.Assets.UI.Game.HUD.Overlay.RoundOverlay.RoundTimer.RoundTimer
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "TimerGUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = PlayerGui
	local Timer = Instance.new("Frame")
	Timer.Name = "Timer"
	Timer.BackgroundTransparency = 1
	Timer.Size = UDim2.new(1, 0, 1, 0)
	Timer.Parent = ScreenGui
	local Top = Instance.new("Frame")
	Top.Name = "Top"
	Top.AnchorPoint = Vector2.new(0.5, 0)
	Top.BackgroundTransparency = 1
	Top.Position = UDim2.new(0.5, 0, 0, 0)
	Top.Size = UDim2.new(1, 0, 1, 0)
	Top.Parent = Timer
	local AspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	AspectRatioConstraint.Parent = Top
	local SizeConstraint = Instance.new("UISizeConstraint")
	SizeConstraint.MaxSize = Vector2.new(900, 900)
	SizeConstraint.Parent = Top
	local MainTimer = RoundTimerTemplate:Clone()
	MainTimer.Name = "MainTimer"
	MainTimer.AnchorPoint = Vector2.new(0.5, 0)
	MainTimer.Position = UDim2.new(0.5, 0, 0.04, 0)
	MainTimer.Size = UDim2.new(0.25, 0, 0.1, 0)
	MainTimer.Parent = Top
	MainTimer.Visible = false
	local TimeDisplay = MainTimer:FindFirstChild("Timer")
	if not TimeDisplay then
		TimeDisplay = Instance.new("TextLabel")
		TimeDisplay.Name = "Timer"
		TimeDisplay.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
		TimeDisplay.Text = "0:00"
		TimeDisplay.TextColor3 = Color3.fromRGB(165, 194, 255)
		TimeDisplay.TextScaled = true
		TimeDisplay.TextSize = 14
		TimeDisplay.TextStrokeTransparency = 0.95
		TimeDisplay.TextWrapped = true
		TimeDisplay.AnchorPoint = Vector2.new(0.5, 0.5)
		TimeDisplay.BackgroundTransparency = 1
		TimeDisplay.Position = UDim2.new(0.5, 0, 0.65, 0)
		TimeDisplay.Size = UDim2.new(0.5, 0, 0.5, 0)
		TimeDisplay.ZIndex = 3
		TimeDisplay.Parent = MainTimer
		local TimeStroke = Instance.new("UIStroke")
		TimeStroke.Thickness = 3
		TimeStroke.Transparency = 0.7
		TimeStroke.Parent = TimeDisplay
		local TimeGradient = Instance.new("UIGradient")
		TimeGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(194, 194, 194))
		})
		TimeGradient.Rotation = 90
		TimeGradient.Parent = TimeDisplay
	end
	local StatusLabel = MainTimer:FindFirstChild("About")
	if not StatusLabel then
		StatusLabel = Instance.new("TextLabel")
		StatusLabel.Name = "About"
		StatusLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
		StatusLabel.Text = "ROUND ACTIVE"
		StatusLabel.TextColor3 = Color3.fromRGB(165, 194, 255)
		StatusLabel.TextScaled = true
		StatusLabel.TextSize = 14
		StatusLabel.TextStrokeTransparency = 0.95
		StatusLabel.TextWrapped = true
		StatusLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		StatusLabel.BackgroundTransparency = 1
		StatusLabel.Position = UDim2.new(0.5, 0, 0.25, 0)
		StatusLabel.Size = UDim2.new(0.8, 0, 0.25, 0)
		StatusLabel.ZIndex = 3
		StatusLabel.Parent = MainTimer
		local StatusStroke = Instance.new("UIStroke")
		StatusStroke.Thickness = 2
		StatusStroke.Transparency = 0.7
		StatusStroke.Parent = StatusLabel
		local StatusGradient = Instance.new("UIGradient")
		StatusGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(194, 194, 194))
		})
		StatusGradient.Rotation = 90
		StatusGradient.Parent = StatusLabel
	end
	local MainTimerStroke = MainTimer:FindFirstChildOfClass("UIStroke")
	if not MainTimerStroke then
		MainTimerStroke = Instance.new("UIStroke")
		MainTimerStroke.Transparency = 0.8
		MainTimerStroke.Parent = MainTimer
	end
	local MainTimerImage = MainTimer:FindFirstChildOfClass("ImageLabel")
	if not MainTimerImage then
		MainTimerImage = Instance.new("ImageLabel")
		MainTimerImage.Name = "Background"
		MainTimerImage.Image = "rbxassetid://196969716"
		MainTimerImage.ImageColor3 = Color3.fromRGB(21, 21, 21)
		MainTimerImage.ImageTransparency = 0.7
		MainTimerImage.AnchorPoint = Vector2.new(0.5, 0.5)
		MainTimerImage.BackgroundTransparency = 1
		MainTimerImage.Position = UDim2.new(0.5, 0, 0.5, 0)
		MainTimerImage.Size = UDim2.new(1, 0, 1, 0)
		MainTimerImage.ZIndex = 0
		MainTimerImage.Parent = MainTimer
		local MainTimerImageCorner = Instance.new("UICorner")
		MainTimerImageCorner.CornerRadius = UDim.new(0, 4)
		MainTimerImageCorner.Parent = MainTimerImage
	end
	local SpecialRound = Instance.new("Frame")
	SpecialRound.Name = "SpecialRound"
	SpecialRound.AnchorPoint = Vector2.new(0.5, 0)
	SpecialRound.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	SpecialRound.BackgroundTransparency = 0.6
	SpecialRound.BorderSizePixel = 0
	SpecialRound.Position = UDim2.new(0.5, 0, 0.15, 0)
	SpecialRound.Size = UDim2.new(0.23, 0, 0.05, 0)
	SpecialRound.Parent = Top
	SpecialRound.Visible = false
	local SpecialRoundLabel = Instance.new("TextLabel")
	SpecialRoundLabel.Name = "Label"
	SpecialRoundLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	SpecialRoundLabel.Text = "No Data"
	SpecialRoundLabel.TextColor3 = Color3.fromRGB(255, 208, 115)
	SpecialRoundLabel.TextScaled = true
	SpecialRoundLabel.TextSize = 14
	SpecialRoundLabel.TextStrokeTransparency = 0.95
	SpecialRoundLabel.TextWrapped = true
	SpecialRoundLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	SpecialRoundLabel.BackgroundTransparency = 1
	SpecialRoundLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	SpecialRoundLabel.Size = UDim2.new(0.9, 0, 0.6, 0)
	SpecialRoundLabel.ZIndex = 3
	SpecialRoundLabel.Parent = SpecialRound
	local SpecialRoundStroke = Instance.new("UIStroke")
	SpecialRoundStroke.Thickness = 2
	SpecialRoundStroke.Transparency = 0.7
	SpecialRoundStroke.Parent = SpecialRoundLabel
	local SpecialRoundEmptyFrame = Instance.new("Frame")
	SpecialRoundEmptyFrame.AnchorPoint = Vector2.new(0, 0.5)
	SpecialRoundEmptyFrame.BackgroundTransparency = 1
	SpecialRoundEmptyFrame.Position = UDim2.new(0.775, 0, 0.6, 0)
	SpecialRoundEmptyFrame.Size = UDim2.new(0.225, 0, 0.45, 0)
	SpecialRoundEmptyFrame.Parent = SpecialRound
	local SpecialRoundListLayout = Instance.new("UIListLayout")
	SpecialRoundListLayout.FillDirection = Enum.FillDirection.Horizontal
	SpecialRoundListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	SpecialRoundListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SpecialRoundListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	SpecialRoundListLayout.Parent = SpecialRoundEmptyFrame
	local SpecialRoundCorner = Instance.new("UICorner")
	SpecialRoundCorner.CornerRadius = UDim.new(0, 4)
	SpecialRoundCorner.Parent = SpecialRound
	local SpecialRoundBackground = Instance.new("ImageLabel")
	SpecialRoundBackground.Name = "Background"
	SpecialRoundBackground.Image = "rbxassetid://196969716"
	SpecialRoundBackground.ImageColor3 = Color3.fromRGB(21, 21, 21)
	SpecialRoundBackground.ImageTransparency = 0.7
	SpecialRoundBackground.AnchorPoint = Vector2.new(0.5, 0.5)
	SpecialRoundBackground.BackgroundTransparency = 1
	SpecialRoundBackground.Position = UDim2.new(0.5, 0, 0.5, 0)
	SpecialRoundBackground.Size = UDim2.new(1, 0, 1, 0)
	SpecialRoundBackground.ZIndex = 0
	SpecialRoundBackground.Parent = SpecialRound
	local SpecialRoundBackgroundCorner = Instance.new("UICorner")
	SpecialRoundBackgroundCorner.CornerRadius = UDim.new(0, 4)
	SpecialRoundBackgroundCorner.Parent = SpecialRoundBackground
	local SpecialRoundUIStroke = Instance.new("UIStroke")
	SpecialRoundUIStroke.Transparency = 0.8
	SpecialRoundUIStroke.Parent = SpecialRound
	return {
		ScreenGui = ScreenGui,
		TimeDisplay = TimeDisplay,
		SpecialRoundLabel = SpecialRoundLabel,
		StatusLabel = StatusLabel,
		MainTimer = MainTimer,
		SpecialRound = SpecialRound,
		MainTimerStroke = MainTimerStroke,
		MainTimerImage = MainTimerImage
	}
end
function destroyTimerGUI()
	if TimerGUI then
		StopGameTimerCheck()
		StopAttributeMonitor()
		TimerGUI.ScreenGui:Destroy()
		TimerGUI = nil
	end
	TimerEnabled = false
	SpecialRoundEnabled = false
end
function ensureTimerGUI()
	if not TimerGUI then
		TimerGUI = createTimerGUI()
	end
end
function GetRoundTitle(roundName)
	if not roundName or roundName == "" then
		return ""
	end
	local specialRoundsFolder = ReplicatedStorage:FindFirstChild("Info")
	if not specialRoundsFolder then
		return roundName
	end
	specialRoundsFolder = specialRoundsFolder:FindFirstChild("SpecialRounds")
	if not specialRoundsFolder then
		return roundName
	end
	local roundModule = specialRoundsFolder:FindFirstChild(roundName)
	if not roundModule then
		return roundName
	end
	local success, moduleData = pcall(function()
		return require(roundModule)
	end)
	if success and moduleData and moduleData.Title then
		return moduleData.Title
	end
	return roundName
end
function SetTime(seconds)
	if not TimerGUI then
		return
	end
	if type(seconds) == "number" then
		local minutes = math.floor(seconds / 60)
		local remainingSeconds = math.floor(seconds % 60)
		TimerGUI.TimeDisplay.Text = string.format("%d:%02d", minutes, remainingSeconds)
		if seconds <= 5 then
			TimerGUI.TimeDisplay.TextColor3 = Color3.fromRGB(215, 100, 100)
			TimerGUI.StatusLabel.TextColor3 = Color3.fromRGB(215, 100, 100)
			if TimerGUI.MainTimerStroke then
				TimerGUI.MainTimerStroke.Color = Color3.fromRGB(255, 138, 138)
			end
			if TimerGUI.MainTimerImage then
				TimerGUI.MainTimerImage.ImageColor3 = Color3.fromRGB(255, 138, 138)
			end
		else
			TimerGUI.TimeDisplay.TextColor3 = Color3.fromRGB(165, 194, 255)
			TimerGUI.StatusLabel.TextColor3 = Color3.fromRGB(165, 194, 255)
			if TimerGUI.MainTimerStroke then
				TimerGUI.MainTimerStroke.Color = Color3.fromRGB(165, 194, 255)
			end
			if TimerGUI.MainTimerImage then
				TimerGUI.MainTimerImage.ImageColor3 = Color3.fromRGB(21, 21, 21)
			end
		end
	else
		TimerGUI.TimeDisplay.Text = tostring(seconds)
	end
end
function SetSpecialRound(roundName)
	if not TimerGUI then
		return
	end
	if roundName and roundName ~= "" then
		CurrentSpecialRoundName = roundName
		local roundTitle = GetRoundTitle(roundName)
		TimerGUI.SpecialRoundLabel.Text = roundTitle
		TimerGUI.SpecialRound.Visible = SpecialRoundEnabled
	else
		CurrentSpecialRoundName = ""
		TimerGUI.SpecialRound.Visible = false
	end
end
function SetStatus(text)
	if not TimerGUI then
		return
	end
	TimerGUI.StatusLabel.Text = text:upper()
end
function SetTimerVisible(visible)
	TimerEnabled = visible
	OriginalTimerVisible = visible
	if CheckingGameTimer then
		CheckGameTimerVisibility()
	else
		if TimerGUI then
			TimerGUI.MainTimer.Visible = visible
		end
	end
end
function SetSpecialRoundVisible(visible)
	SpecialRoundEnabled = visible
	if TimerGUI and visible and CurrentSpecialRoundName ~= "" then
		TimerGUI.SpecialRound.Visible = true
	elseif TimerGUI then
		TimerGUI.SpecialRound.Visible = false
	end
end
function CheckGameTimerVisibility()
	if not TimerEnabled or not TimerGUI then
		if TimerGUI then
			TimerGUI.MainTimer.Visible = false
		end
		return
	end
	local hud = PlayerGui:FindFirstChild("Shared")
	if not hud then
		TimerGUI.MainTimer.Visible = OriginalTimerVisible
		return
	end
	hud = hud:FindFirstChild("HUD")
	if not hud then
		TimerGUI.MainTimer.Visible = OriginalTimerVisible
		return
	end
	hud = hud:FindFirstChild("Overlay")
	if not hud then
		TimerGUI.MainTimer.Visible = OriginalTimerVisible
		return
	end
	hud = hud:FindFirstChild("Default")
	if not hud then
		TimerGUI.MainTimer.Visible = OriginalTimerVisible
		return
	end
	hud = hud:FindFirstChild("RoundOverlay")
	if not hud then
		TimerGUI.MainTimer.Visible = OriginalTimerVisible
		return
	end
	hud = hud:FindFirstChild("Round")
	if not hud then
		TimerGUI.MainTimer.Visible = OriginalTimerVisible
		return
	end
	local roundTimer = hud:FindFirstChild("RoundTimer")
	if not roundTimer then
		TimerGUI.MainTimer.Visible = OriginalTimerVisible
		return
	end
	if roundTimer.Visible then
		TimerGUI.MainTimer.Visible = false
	else
		TimerGUI.MainTimer.Visible = OriginalTimerVisible
	end
end
function StartGameTimerCheck()
	if CheckingGameTimer then
		return
	end
	CheckingGameTimer = true
	spawn(function()
		while CheckingGameTimer do
			CheckGameTimerVisibility()
			wait(0.1)
		end
	end)
end
function StopGameTimerCheck()
	CheckingGameTimer = false
	if TimerGUI then
		TimerGUI.MainTimer.Visible = OriginalTimerVisible
	end
end
function UpdateFromAttributes()
	local timerValue = ServerStateRegistryService.Registry.Time
	local specialRoundValue = ServerStateRegistryService.Registry.SpecialRound
	local roundStatus = ServerStateRegistryService.Registry.RoundStatus
	if timerValue and timerValue ~= - 1 then
		SetTime(timerValue)
	end
	if roundStatus == 2 then
		SetStatus("Round Active")
	elseif roundStatus == 1 or 0 then
		SetStatus("Intermission")
	else
		SetStatus("nil")
	end
	if specialRoundValue and specialRoundValue ~= false then
		SetSpecialRound(tostring(specialRoundValue))
	else
		SetSpecialRound("")
	end
end
function StartAttributeMonitor()
	StopAttributeMonitor()
	local lastTimer = ServerStateRegistryService.Registry.Time
	local lastRoundStatus = ServerStateRegistryService.Registry.RoundStatus
	local lastSpecialRound = ServerStateRegistryService.Registry.SpecialRound
	_attributeConnection = RunService.Heartbeat:Connect(function()
		local currentTimer = ServerStateRegistryService.Registry.Time
		local currentRoundStatus = ServerStateRegistryService.Registry.RoundStatus
		local currentSpecialRound = ServerStateRegistryService.Registry.SpecialRound
		if currentTimer ~= lastTimer or currentRoundStatus ~= lastRoundStatus or currentSpecialRound ~= lastSpecialRound then
			lastTimer = currentTimer
			lastRoundStatus = currentRoundStatus
			lastSpecialRound = currentSpecialRound
			UpdateFromAttributes()
		end
	end)
	UpdateFromAttributes()
end
function StopAttributeMonitor()
	if _attributeConnection then
		_attributeConnection:Disconnect()
		_attributeConnection = nil
	end
	if _attributeConnection2 then
		_attributeConnection2:Disconnect()
		_attributeConnection2 = nil
	end
	if _attributeConnection3 then
		_attributeConnection3:Disconnect()
		_attributeConnection3 = nil
	end
end
function handleTimerToggles()
	local timerOn = TimerEnabled
	local specialOn = SpecialRoundEnabled
	if not timerOn and not specialOn then
		destroyTimerGUI()
	else
		ensureTimerGUI()
		if timerOn then
			SetTimerVisible(true)
			StartAttributeMonitor()
			StartGameTimerCheck()
		end
		if specialOn then
			SetSpecialRoundVisible(true)
		end
	end
end
Tabs.Visuals:Space()
TimerDisplayToggle = Tabs.Visuals:Toggle({
	Title = "Timer Display",
	Flag = "TimerDisplayToggle",
	Value = false,
	Callback = function(state)
		TimerEnabled = state
		handleTimerToggles()
	end
})
Tabs.Visuals:Space()
SpecialRoundToggle = Tabs.Visuals:Toggle({
	Title = "Special Round Display",
	Flag = "SpecialRoundToggle",
	Value = false,
	Callback = function(state)
		SpecialRoundEnabled = state
		handleTimerToggles()
	end
})
Tabs.Visuals:Space()
local PlayerStatsEnabled = false
local PlayerStats = nil
local textLabels = {}
local frontFrames = {}
local observeConnections = {}
function formatNumber(num)
	local str = tostring(math.floor(num))
	local formatted = ""
	local length = # str
	for i = 1, length do
		formatted = formatted .. str:sub(i, i)
		if (length - i) % 3 == 0 and i ~= length then
			formatted = formatted .. ","
		end
	end
	return formatted
end
function updateFrontFrameXSize(frame, textLabel)
	if not frame or not textLabel then
		return
	end
	local textBounds = textLabel.TextBounds
	frame.Size = UDim2.new(0, textBounds.X + 20, 1, 0)
end
function createResourceRow(name, defaultValue, textColor, iconAssetId, iconColor, layoutOrder, leftColumn)
	local container = Instance.new("Frame")
	container.Name = name
	container.BackgroundTransparency = 1
	container.Size = UDim2.fromScale(1, 1)
	container.LayoutOrder = layoutOrder
	container.Parent = leftColumn
	local background = Instance.new("ImageLabel")
	background.Name = "Background"
	background.BackgroundTransparency = 1
	background.Image = "rbxassetid://196969716"
	background.ImageColor3 = Color3.fromRGB(21, 21, 21)
	background.ImageTransparency = 0.4
	background.AnchorPoint = Vector2.new(0.5, 0.5)
	background.Position = UDim2.fromScale(0.5, 0.5)
	background.Size = UDim2.fromScale(1.25, 1.25)
	background.ZIndex = 1
	background.Parent = container
	local bgCorner = Instance.new("UICorner")
	bgCorner.CornerRadius = UDim.new(0, 4)
	bgCorner.Parent = background
	local icon = Instance.new("ImageLabel")
	icon.BackgroundTransparency = 1
	icon.Image = "rbxassetid://" .. iconAssetId
	if iconColor then
		icon.ImageColor3 = iconColor
	end
	icon.AnchorPoint = Vector2.new(0.5, 0.5)
	icon.Position = UDim2.fromScale(0.5, 0.5)
	icon.Size = UDim2.fromScale(0.8, 0.8)
	icon.ZIndex = 3
	icon.Parent = container
	local iconAspect = Instance.new("UIAspectRatioConstraint")
	iconAspect.Parent = icon
	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "Value"
	textLabel.BackgroundTransparency = 1
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Text = tostring(defaultValue)
	textLabel.TextColor3 = textColor
	textLabel.TextScaled = true
	textLabel.TextSize = 14
	textLabel.TextStrokeTransparency = 0.9
	textLabel.TextWrapped = true
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.AnchorPoint = Vector2.new(0, 0.5)
	textLabel.Position = UDim2.new(1.3, 0, 0.5, 0)
	textLabel.Size = UDim2.new(6, 0, 0.8, 0)
	textLabel.ZIndex = 3
	textLabel.Parent = container
	textLabels[name] = textLabel
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 2
	stroke.Transparency = 0.5
	stroke.Parent = textLabel
	local clipLeft = Instance.new("Frame")
	clipLeft.BackgroundTransparency = 1
	clipLeft.ClipsDescendants = true
	clipLeft.Size = UDim2.fromScale(1, 1)
	clipLeft.ZIndex = 2
	clipLeft.Parent = container
	local leftEffect = Instance.new("Frame")
	leftEffect.BackgroundColor3 = Color3.new(0, 0, 0)
	leftEffect.BackgroundTransparency = 0.45
	leftEffect.Size = UDim2.new(2, 0, 1, 0)
	leftEffect.ZIndex = 2
	leftEffect.Parent = clipLeft
	local leftCorner = Instance.new("UICorner")
	leftCorner.CornerRadius = UDim.new(0, 4)
	leftCorner.Parent = leftEffect
	local clipFront = Instance.new("Frame")
	clipFront.Name = "Front"
	clipFront.BackgroundTransparency = 1
	clipFront.ClipsDescendants = true
	clipFront.Position = UDim2.new(1, 0, 0, 0)
	clipFront.Size = UDim2.new(0.5, 33, 1, 0)
	clipFront.ZIndex = 2
	clipFront.Parent = container
	local frontEffect = Instance.new("Frame")
	frontEffect.BackgroundColor3 = Color3.new(0, 0, 0)
	frontEffect.BackgroundTransparency = 0.9
	frontEffect.Position = UDim2.new(- 1, 0, 0, 0)
	frontEffect.Size = UDim2.new(2, 0, 1, 0)
	frontEffect.ZIndex = 2
	frontEffect.Parent = clipFront
	local frontCorner = Instance.new("UICorner")
	frontCorner.CornerRadius = UDim.new(0, 4)
	frontCorner.Parent = frontEffect
	frontFrames[name] = {
		frame = clipFront,
		effect = frontEffect,
		textLabel = textLabel
	}
	task.spawn(function()
		task.wait()
		updateFrontFrameXSize(clipFront, textLabel)
	end)
	return textLabel
end
RegistryStats = {
	Survivals = {
		"Survivals",
		"Survival"
	},
	Streak = {
		"Streak"
	}
}
function getRegistryStat(names)
	local character = CharacterService:GetCharacterFromPlayer(LocalPlayer)
	if not character then
		return nil
	end
	for _, term in ipairs(names) do
		local ok, value = pcall(function()
			return character.DataRegistry:Get(term)
		end)
		if ok and value ~= nil then
			return value
		end
	end
	return 0
end
function updateRegistryStatsUI()
	for rowName, terms in pairs(RegistryStats) do
		local value = getRegistryStat(terms)
		local label = textLabels[rowName]
		if value and label and label.Text ~= formatNumber(value) then
			label.Text = formatNumber(value)
			local data = frontFrames[rowName]
			if data and data.frame and data.textLabel then
				updateFrontFrameXSize(data.frame, data.textLabel)
			end
		end
	end
end
function updateCurrencyUI()
	local allCurrencies = useCurrency.All()
	if textLabels["Tokens"] and allCurrencies["Tokens"] then
		textLabels["Tokens"].Text = formatNumber(allCurrencies["Tokens"])
	end
	if textLabels["Points"] and allCurrencies["Points"] then
		textLabels["Points"].Text = formatNumber(allCurrencies["Points"])
	end
	for _, data in pairs(frontFrames) do
		if data.frame and data.textLabel then
			updateFrontFrameXSize(data.frame, data.textLabel)
		end
	end
end
function updateProgressionUI()
	if not PlayerStats then
		return
	end
	local level = useProgression.Level()
	local xp = useProgression.XP()
	local requiredXP = useProgression.RequiredXP() or (level * 100)
	local progress = useProgression.Progress() or 0
	PlayerStats.levelText.Text = "LEVEL " .. tostring(level)
	PlayerStats.expText.Text = formatNumber(xp) .. "/" .. formatNumber(requiredXP)
	PlayerStats.fill.Size = UDim2.new(math.clamp(progress, 0, 1), 0, 1, 0)
end
function updateEventUI()
	if textLabels["Tickets"] then
		textLabels["Tickets"].Text = formatNumber(useEvent.Balance())
		local data = frontFrames["Tickets"]
		if data and data.frame and data.textLabel then
			updateFrontFrameXSize(data.frame, data.textLabel)
		end
	end
end
function DisableScanData()
	PlayerStatsEnabled = false
	for _, disconnect in pairs(observeConnections) do
		if type(disconnect) == "function" then
			disconnect()
		end
	end
	observeConnections = {}
	if PlayerStats then
		PlayerStats.ScreenGui:Destroy()
		PlayerStats = nil
	end
	textLabels = {}
	frontFrames = {}
end
function EnableScanData()
	if PlayerStats then
		DisableScanData()
	end
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "PlayerStats"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.DisplayOrder = 333
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	local views = Instance.new("Frame")
	views.Name = "Views"
	views.BackgroundTransparency = 1
	views.Size = UDim2.fromScale(1, 1)
	views.Position = UDim2.fromScale(0.5, 0.5)
	views.AnchorPoint = Vector2.new(0.5, 0.5)
	views.Parent = ScreenGui
	local defaultView = Instance.new("Frame")
	defaultView.Name = "Default"
	defaultView.BackgroundTransparency = 1
	defaultView.Size = UDim2.fromScale(1, 1)
	defaultView.Parent = views
	local bottom = Instance.new("Frame")
	bottom.Name = "Bottom"
	bottom.BackgroundTransparency = 1
	bottom.Position = UDim2.fromScale(0.01, 0.01)
	bottom.Size = UDim2.fromScale(0.98, 0.98)
	bottom.Parent = defaultView
	local aspectRatio = Instance.new("UIAspectRatioConstraint")
	aspectRatio.Parent = bottom
	local sizeConstraint = Instance.new("UISizeConstraint")
	sizeConstraint.MinSize = Vector2.new(450, 450)
	sizeConstraint.MaxSize = Vector2.new(700, 700)
	sizeConstraint.Parent = bottom
	local leftColumn = Instance.new("Frame")
	leftColumn.Name = "Left"
	leftColumn.BackgroundTransparency = 1
	leftColumn.Position = UDim2.new(0.004, 0, 0.06, 0)
	leftColumn.Size = UDim2.new(0.05, 0, 0.05, 0)
	leftColumn.Parent = bottom
	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0.175, 0)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = leftColumn
	createResourceRow("Tokens", "0", Color3.fromRGB(163, 255, 87), "7149239101", Color3.fromRGB(163, 255, 87), 1, leftColumn)
	createResourceRow("Points", "0", Color3.new(1, 1, 1), "4648327306", nil, 2, leftColumn)
	createResourceRow("Survivals", "0", Color3.fromRGB(255, 188, 110), "88681516628510", Color3.fromRGB(255, 201, 162), 3, leftColumn)
	createResourceRow("Tickets", "0", Color3.fromRGB(255, 121, 121), "14478137255", Color3.fromRGB(255, 115, 115), 4, leftColumn)
	createResourceRow("Streak", "0", Color3.fromRGB(255, 217, 78), "13518130183", Color3.fromRGB(255, 217, 78), 5, leftColumn)
	local levelBar = Instance.new("Frame")
	levelBar.Name = "Level"
	levelBar.BackgroundColor3 = Color3.fromRGB(105, 138, 255)
	levelBar.BackgroundTransparency = 0.9
	levelBar.Position = UDim2.new(0, 4, 0, 4)
	levelBar.Size = UDim2.new(0.7, 0, 0.016, 0)
	levelBar.Parent = bottom
	local levelCorner = Instance.new("UICorner")
	levelCorner.CornerRadius = UDim.new(0.5, 0)
	levelCorner.Parent = levelBar
	local levelStroke = Instance.new("UIStroke")
	levelStroke.Thickness = 2
	levelStroke.Transparency = 0.5
	levelStroke.Parent = levelBar
	local barContainer = Instance.new("Frame")
	barContainer.Name = "Bar"
	barContainer.BackgroundTransparency = 1
	barContainer.ClipsDescendants = true
	barContainer.Size = UDim2.new(1, 0, 1, 0)
	barContainer.Parent = levelBar
	local fill = Instance.new("Frame")
	fill.BackgroundColor3 = Color3.fromRGB(105, 138, 255)
	fill.BackgroundTransparency = 0.2
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.ZIndex = 2
	fill.Parent = barContainer
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0.5, 0)
	fillCorner.Parent = fill
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
		ColorSequenceKeypoint.new(0.3149, Color3.fromRGB(241, 246, 249)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(168, 201, 222))
	})
	gradient.Rotation = 90
	gradient.Parent = fill
	local levelText = Instance.new("TextLabel")
	levelText.Name = "Level"
	levelText.BackgroundTransparency = 1
	levelText.Font = Enum.Font.GothamBold
	levelText.Text = "LEVEL 1"
	levelText.TextColor3 = Color3.fromRGB(105, 138, 255)
	levelText.TextScaled = true
	levelText.TextWrapped = true
	levelText.TextXAlignment = Enum.TextXAlignment.Left
	levelText.TextYAlignment = Enum.TextYAlignment.Bottom
	levelText.Position = UDim2.new(0, 0, 1.25, 0)
	levelText.Size = UDim2.new(0.5, 0, 1.5, 0)
	levelText.Parent = levelBar
	local levelTextStroke = Instance.new("UIStroke")
	levelTextStroke.Thickness = 2
	levelTextStroke.Transparency = 0.5
	levelTextStroke.Parent = levelText
	local expText = Instance.new("TextLabel")
	expText.Name = "Experience"
	expText.BackgroundTransparency = 1
	expText.Font = Enum.Font.GothamBold
	expText.Text = "0/100"
	expText.TextColor3 = Color3.fromRGB(105, 138, 255)
	expText.TextScaled = true
	expText.TextWrapped = true
	expText.TextXAlignment = Enum.TextXAlignment.Right
	expText.TextYAlignment = Enum.TextYAlignment.Bottom
	expText.AnchorPoint = Vector2.new(1, 0)
	expText.Position = UDim2.new(1, 0, 1.25, 0)
	expText.Size = UDim2.new(0.5, 0, 1.25, 0)
	expText.Parent = levelBar
	local expTextStroke = Instance.new("UIStroke")
	expTextStroke.Thickness = 2
	expTextStroke.Transparency = 0.5
	expTextStroke.Parent = expText
	PlayerStats = {
		ScreenGui = ScreenGui,
		levelText = levelText,
		expText = expText,
		fill = fill
	}
	PlayerStatsEnabled = true
	local currencyDisconnect = useCurrency.Observe(updateCurrencyUI)
	table.insert(observeConnections, currencyDisconnect)
	local progressionDisconnect = useProgression.Observe(updateProgressionUI)
	table.insert(observeConnections, progressionDisconnect)
	local eventDisconnect = useEvent.Observe(updateEventUI)
	table.insert(observeConnections, eventDisconnect)
	updateCurrencyUI()
	updateProgressionUI()
	updateEventUI()
	task.spawn(function()
		while PlayerStats and PlayerStats.ScreenGui == ScreenGui do
			updateRegistryStatsUI()
			task.wait(0.5)
		end
	end)
	for name, data in pairs(frontFrames) do
		if data.textLabel then
			local conn = data.textLabel:GetPropertyChangedSignal("Text"):Connect(function()
				if PlayerStatsEnabled then
					updateFrontFrameXSize(data.frame, data.textLabel)
				end
			end)
			table.insert(observeConnections, function()
				conn:Disconnect()
			end)
		end
	end
end
PlayerStatsToggle = Tabs.Visuals:Toggle({
	Title = "Show Player Stats",
	Flag = "PlayerStatsToggle",
	Value = false,
	Callback = function(state)
		if state then
			EnableScanData()
		else
			DisableScanData()
		end
	end
})
do
	Tabs.Visuals:Space()
	local _originals = {
		Set = nil,
		CharacterDiedSimple = nil
	}
	function ForceDeathFeed()
		if _originals.Set then
			return
		end
		_originals.Set = DeathFeed.Set
		_originals.CharacterDiedSimple = DeathFeed.CharacterDiedSimple
		DeathFeed.Set = function(self, eventType, data)
			if eventType == "Death" then
				self:CharacterDied(data)
			else
				_originals.Set(self, eventType, data)
			end
		end
		DeathFeed.CharacterDiedSimple = function(self, data)
			return self:CharacterDied(data)
		end
	end
	function RestoreOldDeathFeed()
		if not _originals.Set then
			return
		end
		DeathFeed.Set = _originals.Set
		DeathFeed.CharacterDiedSimple = _originals.CharacterDiedSimple
		_originals.Set = nil
		_originals.CharacterDiedSimple = nil
	end
	Tabs.Visuals:Toggle({
		Title = "Always Show Death Feed",
		Callback = function(s)
			if s then
				ForceDeathFeed()
			else
				RestoreOldDeathFeed()
			end
		end
	})
end
function scanDescendantsAsync(root, matchFolderName, targetName, callback)
	local stack = {}
	for _, child in ipairs(root:GetChildren()) do
		table.insert(stack, child)
	end
	local iterations = 0
	local found = nil
	function step()
		while # stack > 0 do
			local node = table.remove(stack)
			if node:IsA("Folder") or node:IsA("Model") then
				if matchFolderName and node.Name == matchFolderName then
					function findInFolder(folder, name)
						for _, child in ipairs(folder:GetChildren()) do
							if child.Name == name then
								return child
							end
							local result = findInFolder(child, name)
							if result then
								return result
							end
						end
						return nil
					end
					local innerResult = findInFolder(node, targetName)
					if innerResult then
						found = innerResult
						break
					end
				elseif not matchFolderName and node.Name == targetName then
					found = node
					break
				else
					for _, child in ipairs(node:GetChildren()) do
						table.insert(stack, child)
					end
				end
			end
			iterations = iterations + 1
			if iterations % 100 == 0 then
				task.wait()
			end
		end
	end
	coroutine.wrap(function()
		step()
		callback(found)
	end)()
end
do
	Tabs.Visuals:Section({
		Title = "Cosmetics Changer",
		TextSize = 20
	})
	Tabs.Visuals:Divider()
	local cosSwaps = {}
	local curCos = ""
	local newCos = ""
	function swapCosmetics(current, target, onComplete)
		if current == "" or target == "" or current == target then
			onComplete(false)
			return
		end
		local key = current .. "_" .. target
		if cosSwaps[key] then
			local old = cosSwaps[key]
			swapCosmetics(old.target, old.current, function()
			end)
			cosSwaps[key] = nil
		end
		local items = ReplicatedStorage:FindFirstChild("Items")
		if not items then
			onComplete(false)
			return
		end
		local curFound, tarFound = nil, nil
		function checkDone()
			if curFound and tarFound then
				local cur = curFound
				local tar = tarFound
				local temp = Instance.new("Folder")
				temp.Name = "__temp_cos_swap_" .. tostring(tick())
				temp.Parent = ReplicatedStorage or workspace
				local curChildren = {}
				local tarChildren = {}
				for _, child in ipairs(cur:GetChildren()) do
					table.insert(curChildren, child)
				end
				for _, child in ipairs(tar:GetChildren()) do
					table.insert(tarChildren, child)
				end
				for _, child in ipairs(curChildren) do
					child.Parent = temp
				end
				for _, child in ipairs(tarChildren) do
					child.Parent = cur
				end
				for _, child in ipairs(temp:GetChildren()) do
					child.Parent = tar
				end
				temp:Destroy()
				cosSwaps[key] = {
					current = current,
					target = target
				}
				onComplete(true)
			end
		end
		scanDescendantsAsync(items, "Cosmetics", current, function(result)
			curFound = result
			checkDone()
		end)
		scanDescendantsAsync(items, "Cosmetics", target, function(result)
			tarFound = result
			checkDone()
		end)
	end
	function resetAllCosmetics(onComplete)
		local list = {}
		for k, v in pairs(cosSwaps) do
			table.insert(list, v)
		end
		local count = # list
		if count == 0 then
			onComplete()
			return
		end
		local done = 0
		for _, v in ipairs(list) do
			swapCosmetics(v.target, v.current, function()
				done = done + 1
				if done == count then
					cosSwaps = {}
					onComplete()
				end
			end)
		end
	end
	Tabs.Visuals:Input({
		Title = "Current Cosmetic Name",
		Placeholder = "",
		Callback = function(v)
			curCos = v
		end
	})
	Tabs.Visuals:Input({
		Title = "New Cosmetic Name",
		Placeholder = "",
		Callback = function(v)
			newCos = v
		end
	})
	Tabs.Visuals:Button({
		Title = "Swap Cosmetics",
		Icon = "refresh-cw",
		Callback = function()
			task.spawn(function()
				swapCosmetics(curCos, newCos, function(success)
					if success then
						WindUI:Notify({
							Title = "Swap Cosmetics",
							Content = '<font color="#00ff88"><font family="rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json" weight="Regular">circle-check</font> Swapped \'' .. curCos .. '\' with \'' .. newCos .. '\'</font>',
							Duration = 3
						})
					else
						WindUI:Notify({
							Title = "Swap Skin",
							Content = '<font color="#ff3030"><font family="rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json" weight="Regular">circle-x</font> Check names – case‑sensitive</font>',
							Duration = 3
						})
					end
				end)
			end)
		end
	})
	Tabs.Visuals:Button({
		Title = "Reset Cosmetics",
		Icon = "trash-2",
		Color = Color3.fromHex("#FF3030"),
		Callback = function()
			task.spawn(function()
				resetAllCosmetics(function()
					WindUI:Notify({
						Title = "Reset Cosmetics",
						Content = '<font color="#ff3030"><font family="rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json" weight="Regular">trash-can</font>Your Cosmetics Have been Reset To deafult Parent</font>',
						Duration = 3
					})
				end)
			end)
		end
	})
end
do
	Tabs.Visuals:Section({
		Title = "Nametag Changer",
		TextSize = 20
	})
	local nametagEnabled = false
	local nametagId = nil
	local nametagName = ""
	local nametagIdByName = {}
	local nametagOriginal = {}
	local nametagLoop = 0
	local function collectNametags()
		nametagIdByName = {}
		local names = {}
		local ok, registry = pcall(require, ReplicatedStorage.Items.Registry)
		if not ok then
			return names
		end
		for _, category in ipairs(registry.GetCategories()) do
			local lower = category:lower()
			if lower:find("nametag") or lower == "tag" or lower == "tags" then
				for id, entry in pairs(registry.GetByCategory(category)) do
					local name = entry.Module.Name
					if nametagIdByName[name] then
						name = name .. " (" .. id .. ")"
					end
					nametagIdByName[name] = id
					table.insert(names, name)
				end
			end
		end
		table.sort(names)
		return names
	end
	local function nametagValues()
		local names = collectNametags()
		if # names == 0 then
			return {
				"No nametags found"
			}
		end
		return names
	end
	local function applyNametag()
		local character = CharacterService:GetCharacterFromPlayer(LocalPlayer)
		local model = LocalPlayer.Character
		if not character or not model then
			return
		end
		local registry = character.DataRegistry
		if nametagOriginal.registry ~= registry or nametagOriginal.model ~= model then
			nametagOriginal = {
				registry = registry,
				model = model,
				tag = registry:Get("Nametag"),
				name = model:GetAttribute("DisplayName")
			}
		end
		if nametagId and registry:Get("Nametag") ~= nametagId then
			registry:Set("Nametag", nametagId)
		end
		if nametagName ~= "" and model:GetAttribute("DisplayName") ~= nametagName then
			model:SetAttribute("DisplayName", nametagName)
		end
	end
	local function restoreDisplayName()
		local original = nametagOriginal
		if original.model then
			pcall(function()
				original.model:SetAttribute("DisplayName", original.name)
			end)
		end
	end
	local function restoreNametag()
		local original = nametagOriginal
		nametagOriginal = {}
		if not original.registry then
			return
		end
		pcall(function()
			original.registry:Set("Nametag", original.tag)
		end)
		pcall(function()
			original.model:SetAttribute("DisplayName", original.name)
		end)
	end
	NametagChangerToggle = Tabs.Visuals:Toggle({
		Title = "Enable Nametag Changer",
		Flag = "NametagChangerToggle",
		Value = false,
		Callback = function(state)
			nametagEnabled = state
			nametagLoop = nametagLoop + 1
			if state then
				local token = nametagLoop
				task.spawn(function()
					while nametagEnabled and token == nametagLoop do
						pcall(applyNametag)
						task.wait(0.25)
					end
				end)
			else
				restoreNametag()
			end
		end
	})
	NametagDropdown = Tabs.Visuals:Dropdown({
		Title = "Nametag",
		Flag = "NametagChangerSelect",
		Values = nametagValues(),
		Callback = function(value)
			nametagId = nametagIdByName[value]
		end
	})
	Tabs.Visuals:Button({
		Title = "Refresh Nametag List",
		Icon = "refresh-cw",
		Callback = function()
			NametagDropdown:Refresh(nametagValues())
		end
	})
	Tabs.Visuals:Input({
		Title = "Nametag ID",
		Placeholder = "Item ID (optional)",
		NumbersOnly = true,
		Callback = function(v)
			local id = tonumber(v)
			if id then
				nametagId = id
			end
		end
	})
	Tabs.Visuals:Input({
		Title = "Custom Name",
		Placeholder = "Leave empty to keep your name",
		Callback = function(v)
			nametagName = v
			if v == "" then
				restoreDisplayName()
			end
		end
	})
end
local ItemRegistry = ReplicatedStorage.Items.Registry
do
	Tabs.Visuals:Section({
		Title = "Emote Changer",
		TextSize = 20
	})
	Tabs.Visuals:Divider()
	local currentEmotes = {}
	local selectEmotes = {}
	local emoteReplacements = {}
	local hookActive = false
	local lastEmoteName = nil
	function setEmote(emoteID)
		if not emoteID then
			return
		end
		local character = LocalPlayer.Character
		if not character then
			return
		end
		local tagValue = character:GetAttribute("Tag")
		if not tagValue then
			return
		end
		local tagBuf = buffer.create(2)
		buffer.writeu16(tagBuf, 0, tagValue)
		FireClient(UpdateCharacterDataRegistry, {
			buffer.fromstring("\24\1"),
			emoteID,
			tagBuf
		})
	end
	for i = 1, 12 do
		currentEmotes[i] = ""
		selectEmotes[i] = ""
	end
	for i = 1, 12 do
		Tabs.Visuals:Input({
			Title = "Current Emote" .. " " .. i,
			Placeholder = "Enter emote name or ID",
			Callback = function(v)
				currentEmotes[i] = v:gsub("%s+", "")
			end
		})
	end
	Tabs.Visuals:Divider()
	for i = 1, 12 do
		Tabs.Visuals:Input({
			Title = "Select Emote" .. " " .. i,
			Placeholder = "Enter emote name or ID",
			Callback = function(v)
				selectEmotes[i] = v:gsub("%s+", "")
			end
		})
	end
	function getAllEmotes()
		local itemsFolder = ReplicatedStorage:FindFirstChild("Items")
		if not itemsFolder then
			return {}
		end
		local allEmotes = {}
		function findEmotesFolders(parent)
			for _, child in ipairs(parent:GetChildren()) do
				if child:IsA("Folder") then
					if child.Name == "Emotes" then
						for _, emote in ipairs(child:GetChildren()) do
							if emote:IsA("ModuleScript") and emote:GetAttribute("ID") then
								table.insert(allEmotes, {
									Name = emote.Name,
									ID = emote:GetAttribute("ID")
								})
							end
						end
					else
						findEmotesFolders(child)
					end
				end
			end
		end
		findEmotesFolders(itemsFolder)
		return allEmotes
	end
	function findEmoteInfo(emoteInput)
		if emoteInput == "" then
			return nil
		end
		local id = tonumber(emoteInput)
		if id then
			local config = ItemRegistry.GetConfig(id)
			if config then
				local allEmotes = getAllEmotes()
				for _, e in ipairs(allEmotes) do
					if e.ID == id then
						return {
							Name = e.Name,
							ID = id
						}
					end
				end
				return {
					Name = tostring(id),
					ID = id
				}
			else
				return nil
			end
		end
		local allEmotes = getAllEmotes()
		for _, emote in ipairs(allEmotes) do
			if emote.Name:lower() == emoteInput:lower() then
				return {
					Name = emote.Name,
					ID = emote.ID
				}
			end
		end
		return nil
	end
	function buildEmoteMapping()
		emoteReplacements = {}
		for i = 1, 12 do
			local currentInput = currentEmotes[i] or ""
			local selectInput = selectEmotes[i] or ""
			if currentInput ~= "" and selectInput ~= "" then
				local currentInfo = findEmoteInfo(currentInput)
				local selectInfo = findEmoteInfo(selectInput)
				if currentInfo and selectInfo then
					emoteReplacements[currentInfo.Name] = {
						select = selectInfo.Name,
						selectID = selectInfo.ID,
						slot = i
					}
				end
			end
		end
	end
	local origActivate = EmoteClass.Activate
	local origDeactivate = EmoteClass.Deactivate
	function startEmoteWatcher()
		if hookActive then
			return
		end
		hookActive = true
		EmoteClass.Activate = function(self, p2, p3)
			origActivate(self, p2, p3)
			local anim = self.Animations and self.Animations.Animation
			if anim and anim.IsPlaying and anim.Speed > 0 then
				local module = self.EmoteModule
				local currentEmote = module and module.Name or "Unknown"
				if currentEmote ~= lastEmoteName then
					if emoteReplacements[currentEmote] then
						local replacement = emoteReplacements[currentEmote]
						local selectID = replacement.selectID
						if selectID then
							lastEmoteName = currentEmote
							RunService.Heartbeat:Wait()
							setEmote(selectID)
						end
					end
					lastEmoteName = currentEmote
				end
			end
		end
		EmoteClass.Deactivate = function(self, ...)
			origDeactivate(self, ...)
			lastEmoteName = nil
		end
	end
	function stopEmoteWatcher()
		hookActive = false
		EmoteClass.Activate = origActivate
		EmoteClass.Deactivate = origDeactivate
		lastEmoteName = nil
	end
	VisualsEmoteApply = Tabs.Visuals:Button({
		Title = "Apply Emote Mappings",
		Icon = "refresh-cw",
		Callback = function()
			local hasAnyEmote = false
			local incompleteSlots = {}
			local emptySlots = true
			for i = 1, 12 do
				local current = currentEmotes[i] or ""
				local select = selectEmotes[i] or ""
				if current ~= "" or select ~= "" then
					emptySlots = false
					if current ~= "" and select == "" then
						table.insert(incompleteSlots, string.format("Slot %d: Current set, Select missing", i))
					elseif current == "" and select ~= "" then
						table.insert(incompleteSlots, string.format("Slot %d: Select set, Current missing", i))
					else
						hasAnyEmote = true
					end
				end
			end
			if emptySlots then
				WindUI:Notify({
					Title = "Emote Changer",
					Content = '<font color="#ffaa00"><font family="rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json" weight="Regular">triangle-exclamation</font> No emote fields are filled. Please enter at least one Current and Select pair.</font>',
					Duration = 5
				})
				return
			end
			if # incompleteSlots > 0 then
				local msg = '<font color="#ff3030"><font family="rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json" weight="Regular">circle-x</font> Failed to Apply Emote:</font>'
				for _, err in ipairs(incompleteSlots) do
					msg = msg .. '\n<font color="#ffaa00">' .. err .. '</font>'
				end
				WindUI:Notify({
					Title = "Emote Changer",
					Content = msg,
					Duration = 8
				})
				return
			end
			local allEmotes = getAllEmotes()
			buildEmoteMapping()
			local validMappings = 0
			local messages = {}
			for i = 1, 12 do
				local currentInput = currentEmotes[i] or ""
				local selectInput = selectEmotes[i] or ""
				if currentInput ~= "" and selectInput ~= "" then
					local currentInfo = findEmoteInfo(currentInput)
					local selectInfo = findEmoteInfo(selectInput)
					if currentInfo and selectInfo then
						validMappings = validMappings + 1
						table.insert(messages, string.format('<font color="#00ff88"><font family="rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json" weight="Regular">circle-check</font> Slot %d:</font> <b>%s</b> <font color="#88ccff">→</font> <b>%s</b>', i, currentInfo.Name, selectInfo.Name))
					else
						local errors = {}
						if not currentInfo then
							errors[# errors + 1] = string.format('<font color="#ff6666">Current "%s" not found</font>', currentInput)
						end
						if not selectInfo then
							errors[# errors + 1] = string.format('<font color="#ff6666">Select "%s" not found</font>', selectInput)
						end
						table.insert(messages, string.format('<font color="#ff3030"><font family="rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json" weight="Regular">circle-x</font> Slot %d:</font> %s', i, table.concat(errors, ", ")))
					end
				end
			end
			if validMappings == 0 then
				table.insert(messages, 1, '<font color="#ffaa00"><font family="rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json" weight="Regular">triangle-exclamation</font> No valid emote mappings found.</font>')
				WindUI:Notify({
					Title = "Emote Changer",
					Content = table.concat(messages, "\n"),
					Duration = 8
				})
				return
			end
			stopEmoteWatcher()
			task.wait(0.1)
			startEmoteWatcher()
			table.insert(messages, 1, string.format('<font color="#00ff88"><font family="rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json" weight="Regular">circle-check</font> %d emote mapping%s applied.</font>', validMappings, validMappings > 1 and "s" or ""))
			WindUI:Notify({
				Title = "Emote Changer",
				Content = table.concat(messages, "\n"),
				Duration = 8
			})
		end
	})
	VisualsEmoteReset = Tabs.Visuals:Button({
		Title = "Reset Emote Mappings",
		Icon = "trash-2",
		Color = Color3.fromHex("#FF3030"),
		Callback = function()
			stopEmoteWatcher()
			emoteReplacements = {}
			for i = 1, 12 do
				currentEmotes[i] = ""
				selectEmotes[i] = ""
			end
			WindUI:Notify({
				Title = "Emote Changer",
				Content = '<font color="#ff3030"><font family="rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json" weight="Regular">trash-can</font> All emote mappings have been reset.</font>',
				Duration = 3
			})
		end
	})
end
do
	Tabs.Visuals:Section({
		Title = "Deployment Skin Changer",
		TextSize = 20
	})
	Tabs.Visuals:Divider()
	local swaps = {}
	local curName = ""
	local newName = ""
	local deployType = ""
	function findDeployment(type, name, callback)
		local packs = ReplicatedStorage:FindFirstChild("Items")
		if packs then
			packs = packs:FindFirstChild("ItemPacks")
		end
		if not packs then
			callback(nil)
			return
		end
		scanDescendantsAsync(packs, "Skins", nil, function(skinsFolder)
			if not skinsFolder then
				callback(nil)
				return
			end
			local deployables = skinsFolder:FindFirstChild("Deployables")
			if deployables then
				local typeFolder = deployables:FindFirstChild(type)
				if typeFolder then
					local folder = typeFolder:FindFirstChild(name)
					callback(folder)
					return
				end
			end
			callback(nil)
		end)
	end
	function swap(type, current, target, onComplete)
		if type == "" or current == "" or target == "" or current == target then
			onComplete(false)
			return
		end
		local key = type .. "_" .. current
		if swaps[key] then
			local old = swaps[key]
			swap(type, old.target, old.current, function()
			end)
			swaps[key] = nil
		end
		local curFound, tarFound = nil, nil
		function checkDone()
			if curFound and tarFound then
				local cur = curFound
				local tar = tarFound
				local temp = Instance.new("Folder")
				temp.Name = "__temp_swap_" .. tostring(tick())
				temp.Parent = ReplicatedStorage or workspace
				local curChildren = {}
				local tarChildren = {}
				for _, child in ipairs(cur:GetChildren()) do
					table.insert(curChildren, child)
				end
				for _, child in ipairs(tar:GetChildren()) do
					table.insert(tarChildren, child)
				end
				for _, child in ipairs(curChildren) do
					child.Parent = temp
				end
				for _, child in ipairs(tarChildren) do
					child.Parent = cur
				end
				for _, child in ipairs(temp:GetChildren()) do
					child.Parent = tar
				end
				temp:Destroy()
				swaps[key] = {
					type = type,
					current = current,
					target = target
				}
				onComplete(true)
			end
		end
		findDeployment(type, current, function(result)
			curFound = result
			checkDone()
		end)
		findDeployment(type, target, function(result)
			tarFound = result
			checkDone()
		end)
	end
	function revertAll(onComplete)
		local list = {}
		for k, v in pairs(swaps) do
			table.insert(list, v)
		end
		local count = # list
		if count == 0 then
			onComplete()
			return
		end
		local done = 0
		for _, v in ipairs(list) do
			swap(v.type, v.target, v.current, function()
				done = done + 1
				if done == count then
					swaps = {}
					onComplete()
				end
			end)
		end
	end
	Tabs.Visuals:Input({
		Title = "Deployment Type",
		Placeholder = "",
		Value = "",
		Callback = function(v)
			if v ~= "" then
				deployType = v
			end
		end
	})
	Tabs.Visuals:Input({
		Title = "Current Deployment",
		Placeholder = "",
		Callback = function(v)
			curName = v
		end
	})
	Tabs.Visuals:Input({
		Title = "New Deployment",
		Placeholder = "",
		Callback = function(v)
			newName = v
		end
	})
	Tabs.Visuals:Button({
		Title = "Swap Skin",
		Icon = "refresh-cw",
		Callback = function()
			task.spawn(function()
				swap(deployType, curName, newName, function(success)
					if success then
						WindUI:Notify({
							Title = "Full Swap",
							Content = '<font color="#00ff88"><font family="rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json" weight="Regular">circle-check</font> Swapped \'' .. curName .. '\' with \'' .. newName .. '\'</font>',
							Duration = 3
						})
					else
						WindUI:Notify({
							Title = "Swap Skin",
							Content = '<font color="#ff3030"><font family="rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json" weight="Regular">circle-x</font> Check names and type</font>',
							Duration = 3
						})
					end
				end)
			end)
		end
	})
	Tabs.Visuals:Button({
		Title = "Reset",
		Icon = "trash-2",
		Color = Color3.fromHex("#FF3030"),
		Callback = function()
			task.spawn(function()
				revertAll(function()
					WindUI:Notify({
						Title = "Reset",
						Content = '<font color="#ff3030"><font family="rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json" weight="Regular">trash-can</font>All Deployment Skin Have been Reset</font>',
						Duration = 3
					})
				end)
			end)
		end
	})
end
do
	Tabs.Visuals:Section({
		Title = "Tools Skin Changer",
		TextSize = 20
	})
	Tabs.Visuals:Divider()
	local ToolSkinSawps = {}
	local activeToolsSwaps = {}
	local currentToolInput = ""
	local currentSkinInput = ""
	local selectedSkinInput = ""
	function normalizeString(str)
		return str:gsub("%s+", ""):lower()
	end
	function isValidTool(toolName)
		local tools = ReplicatedStorage:FindFirstChild("Tools")
		if not tools then
			return false
		end
		local tool = tools:FindFirstChild(toolName)
		if not tool then
			return false
		end
		local variants = tool:FindFirstChild("Variants")
		if not variants then
			return false
		end
		return true, tool, variants
	end
	function isValidSkin(toolName, skinName)
		local toolValid, tool, variants = isValidTool(toolName)
		if not toolValid then
			return false
		end
		local skin = variants:FindFirstChild(skinName)
		if not skin then
			return false
		end
		return true, tool, variants, skin
	end
	function revertSkinSwap(toolName, currentSkinName, selectedSkinName)
		local key = toolName .. "_" .. currentSkinName
		if not activeToolsSwaps[key] then
			return false
		end
		local currentValid, currentTool, currentVariants, currentSkin = isValidSkin(toolName, currentSkinName)
		local selectedValid, selectedTool, selectedVariants, selectedSkin = isValidSkin(toolName, selectedSkinName)
		if currentValid and selectedValid then
			pcall(function()
				local tempRoot = Instance.new("Folder")
				tempRoot.Name = "__temp_skin_revert_" .. tostring(tick()):gsub("%.", "_")
				tempRoot.Parent = currentVariants
				local tempCurrent = Instance.new("Folder")
				tempCurrent.Name = "tempCurrent"
				tempCurrent.Parent = tempRoot
				local tempSelected = Instance.new("Folder")
				tempSelected.Name = "tempSelected"
				tempSelected.Parent = tempRoot
				for _, child in ipairs(currentSkin:GetChildren()) do
					child.Parent = tempCurrent
				end
				for _, child in ipairs(selectedSkin:GetChildren()) do
					child.Parent = tempSelected
				end
				for _, child in ipairs(tempCurrent:GetChildren()) do
					child.Parent = selectedSkin
				end
				for _, child in ipairs(tempSelected:GetChildren()) do
					child.Parent = currentSkin
				end
				tempRoot:Destroy()
			end)
		end
		activeToolsSwaps[key] = nil
		return true
	end
	function revertAllToolSkinSawps()
		local swapsToRevert = {}
		for key, swapData in pairs(activeToolsSwaps) do
			table.insert(swapsToRevert, swapData)
		end
		for _, swapData in ipairs(swapsToRevert) do
			revertSkinSwap(swapData.toolName, swapData.currentSkin, swapData.selectedSkin)
		end
		ToolSkinSawps = {}
		activeToolsSwaps = {}
	end
	function swapSkins(toolName, currentSkinName, selectedSkinName)
		local currentNorm = normalizeString(currentSkinName)
		local selectedNorm = normalizeString(selectedSkinName)
		if toolName == "" or currentNorm == "" or selectedNorm == "" then
			WindUI:Notify({
				Title = "Skin Changer",
				Content = '<font color="#ffaa00"><font family="rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json" weight="Regular">triangle-exclamation</font> All fields must be filled</font>',
				Duration = 3
			})
			return false
		end
		if currentNorm == selectedNorm then
			WindUI:Notify({
				Title = "Skin Changer",
				Content = '<font color="#ffaa00"><font family="rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json" weight="Regular">triangle-exclamation</font> Skin names cannot be the same</font>',
				Duration = 3
			})
			return false
		end
		local currentValid, currentTool, currentVariants, currentSkin = isValidSkin(toolName, currentSkinName)
		local selectedValid, selectedTool, selectedVariants, selectedSkin = isValidSkin(toolName, selectedSkinName)
		if not currentValid then
			WindUI:Notify({
				Title = "Skin Changer",
				Content = '<font color="#ff3030"><font family="rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json" weight="Regular">circle-x</font> Current skin not found: ' .. currentSkinName .. '</font>',
				Duration = 3
			})
			return false
		end
		if not selectedValid then
			WindUI:Notify({
				Title = "Skin Changer",
				Content = '<font color="#ff3030"><font family="rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json" weight="Regular">circle-x</font> Selected skin not found: ' .. selectedSkinName .. '</font>',
				Duration = 3
			})
			return false
		end
		local key = toolName .. "_" .. currentSkinName
		if activeToolsSwaps[key] then
			revertSkinSwap(toolName, currentSkinName, activeToolsSwaps[key].selectedSkin)
		end
		pcall(function()
			local tempRoot = Instance.new("Folder")
			tempRoot.Name = "__temp_skin_swap_" .. tostring(tick()):gsub("%.", "_")
			tempRoot.Parent = currentVariants
			local tempCurrent = Instance.new("Folder")
			tempCurrent.Name = "tempCurrent"
			tempCurrent.Parent = tempRoot
			local tempSelected = Instance.new("Folder")
			tempSelected.Name = "tempSelected"
			tempSelected.Parent = tempRoot
			for _, child in ipairs(currentSkin:GetChildren()) do
				child.Parent = tempCurrent
			end
			for _, child in ipairs(selectedSkin:GetChildren()) do
				child.Parent = tempSelected
			end
			for _, child in ipairs(tempCurrent:GetChildren()) do
				child.Parent = selectedSkin
			end
			for _, child in ipairs(tempSelected:GetChildren()) do
				child.Parent = currentSkin
			end
			tempRoot:Destroy()
			local swapData = {
				toolName = toolName,
				currentSkin = currentSkinName,
				selectedSkin = selectedSkinName
			}
			activeToolsSwaps[key] = swapData
			local found = false
			for i, swap in ipairs(ToolSkinSawps) do
				if swap.toolName == toolName and swap.currentSkin == currentSkinName then
					ToolSkinSawps[i] = swapData
					found = true
					break
				end
			end
			if not found then
				table.insert(ToolSkinSawps, swapData)
			end
			WindUI:Notify({
				Title = "Skin Changer",
				Content = '<font color="#00ff88"><font family="rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json" weight="Regular">circle-check</font> Successfully swapped ' .. currentSkinName .. ' with ' .. selectedSkinName .. ' for ' .. toolName .. '</font>',
				Duration = 3
			})
		end)
		return true
	end
	Tabs.Visuals:Input({
		Title = "Tool Name",
		Placeholder = "Enter tool name",
		Callback = function(value)
			currentToolInput = value
		end
	})
	Tabs.Visuals:Input({
		Title = "Current Skin",
		Placeholder = "Enter current skin name",
		Callback = function(value)
			currentSkinInput = value
		end
	})
	Tabs.Visuals:Input({
		Title = "New Skin",
		Placeholder = "Enter new skin name",
		Callback = function(value)
			selectedSkinInput = value
		end
	})
	Tabs.Visuals:Button({
		Title = "Replace Skin Swap",
		Icon = "refresh-cw",
		Callback = function()
			swapSkins(currentToolInput, currentSkinInput, selectedSkinInput)
		end
	})
	Tabs.Visuals:Button({
		Title = "Reset All Skins",
		Icon = "trash-2",
		Color = Color3.fromHex("#FF3030"),
		Desc = "Revert all skin swaps",
		Callback = function()
			revertAllToolSkinSawps()
			WindUI:Notify({
				Title = "Skin Changer",
				Content = '<font color="#ff3030"><font family="rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json" weight="Regular">trash-can</font> All skins have been reset to original</font>',
				Duration = 3
			})
		end
	})
end
Tabs.Visuals:Space()
do
	if hookfunction then
		local info = ColaModule.Tasks[1].AutomaticFunctions[2].Methods[1].Info
		local endlessColaEnabled = false
		local modifyColaEnabled = false
		local customDuration = tonumber(info.Duration) or 10
		local customSpeedBoost = tonumber(info.SpeedBoost) or 15
		function ColaVignette()
			local duration = modifyColaEnabled and customDuration or info.Duration
			FireClient(ReplicatedStorage.Events.SharedUISetType, "Vignette", info.Color, duration, true)
		end
		function ColaSpeedBoost(Type)
			local character = LocalPlayer.Character
			if character then
				local tag = character:GetAttribute("Tag")
				if tag then
					local speed = modifyColaEnabled and customSpeedBoost or info.SpeedBoost
					local duration = modifyColaEnabled and customDuration or info.Duration
					FireClient(ReplicatedStorage.Events.CharacterTask, tag, "Movement", {
						SpeedChange = {
							Value = speed,
							Type = Type or "Cola",
							Length = duration
						}
					})
				end
			end
		end
		local gmt = getrawmetatable(game)
		local oldNamecall = gmt.__namecall
		local isColaHooked = false
		function applyColaHook()
			if isColaHooked then
				return
			end
			setreadonly(gmt, false)
			gmt.__namecall = newcclosure(function(self, ...)
				local method = getnamecallmethod()
				local args = {
					...
				}
				if self == ToolAction and (method == "FireServer" or method == "fireServer") then
					for i, v in ipairs(args) do
						if typeof(v) == "buffer" then
							local content = buffer.tostring(v)
							if content == "\1\1\1" and endlessColaEnabled then
								return
							end
							if content == "\1\2\1" then
								if endlessColaEnabled then
									ColaSpeedBoost()
									task.wait()
									ColaVignette()
									return
								elseif modifyColaEnabled then
									task.spawn(function()
										ColaSpeedBoost("FakeCola")
										ColaVignette()
									end)
									return
								end
							end
						end
					end
				end
				return oldNamecall(self, ...)
			end)
			setreadonly(gmt, true)
			isColaHooked = true
		end
		function removeColaHook()
			if not isColaHooked then
				return
			end
			setreadonly(gmt, false)
			gmt.__namecall = oldNamecall
			setreadonly(gmt, true)
			isColaHooked = false
		end
		function checkColaHookStatus()
			if endlessColaEnabled or modifyColaEnabled then
				applyColaHook()
			else
				removeColaHook()
			end
		end
		Tabs.Visuals:Toggle({
			Title = "Visuals Endless Cola",
			Desc = "Gives you unlimited cola client-side while blocking server animation",
			Callback = function(state)
				endlessColaEnabled = state
				checkColaHookStatus()
			end
		})
		Tabs.Visuals:Toggle({
			Title = "Cola Booster",
			Callback = function(state)
				modifyColaEnabled = state
				checkColaHookStatus()
			end
		})
		Tabs.Visuals:Input({
			Title = "Cola Duration Boost",
			Value = tostring(customDuration),
			Callback = function(v)
				local num = tonumber(v)
				if num then
					customDuration = num
				end
			end
		})
		Tabs.Visuals:Input({
			Title = "Cola Speed Boost",
			Value = tostring(customSpeedBoost),
			Callback = function(v)
				local num = tonumber(v)
				if num then
					customSpeedBoost = num
				end
			end
		})
	else
		Tabs.Visuals:Paragraph({
			Title = "hookfunction Not Available"
		})
	end
end
Tabs.Visuals:Space()
--// Ring Highlight System
--// Matches Workspace.Players children to Workspace.Rigs by the "Tag" attribute, then highlights the matched rig
RingHighlightManager = {
	PlayerEnabled = false,
	DownedEnabled = false,
	NPCEnabled = false,
	PlayerHighlights = {},
	DownedHighlights = {},
	NPCHighlights = {},
	Connection = nil,
	TagToRig = {},
}

function RingHighlightManager:IsLocalPlayerModel(model)
	if not model then
		return false
	end
	if model == LocalPlayer.Character then
		return true
	end
	if model.Name == LocalPlayer.Name or model.Name == tostring(LocalPlayer.UserId) then
		return true
	end
	local attrName = model:GetAttribute("Name")
	if attrName == LocalPlayer.Name or attrName == LocalPlayer.DisplayName then
		return true
	end
	local attrTag = model:GetAttribute("Tag")
	if attrTag == LocalPlayer.Name or attrTag == LocalPlayer.DisplayName then
		return true
	end
	local userId = model:GetAttribute("UserId") or model:GetAttribute("PlayerUserId")
	if typeof(userId) == "number" and userId == LocalPlayer.UserId then
		return true
	end
	return false
end

function RingHighlightManager:BuildRigIndex()
	self.TagToRig = {}
	local rigsFolder = workspace:FindFirstChild("Rigs")
	if not rigsFolder then
		return
	end
	for _, rig in ipairs(rigsFolder:GetChildren()) do
		if rig:IsA("Model") then
			local tag = rig:GetAttribute("Tag")
			if tag ~= nil then
				self.TagToRig[tag] = rig
			end
		end
	end
end

function RingHighlightManager:ApplyHighlight(storage, rig, color)
	if not rig then
		return
	end
	local highlight = storage[rig]
	if not highlight or not highlight.Parent then
		highlight = Instance.new("Highlight")
		highlight.Name = "Ring_ESP_Highlight"
		highlight.FillTransparency = 0.5
		highlight.OutlineTransparency = 0.2
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Parent = rig
		storage[rig] = highlight
	end
	highlight.FillColor = color
	highlight.OutlineColor = color
end

function RingHighlightManager:SweepStorage(storage, seen)
	for rig, highlight in pairs(storage) do
		if not seen[rig] then
			if highlight and highlight.Parent then
				highlight:Destroy()
			end
			storage[rig] = nil
		end
	end
end

function RingHighlightManager:ClearAll()
	self:SweepStorage(self.PlayerHighlights, {})
	self:SweepStorage(self.DownedHighlights, {})
	self:SweepStorage(self.NPCHighlights, {})
end

function RingHighlightManager:Update()
	if not (self.PlayerEnabled or self.DownedEnabled or self.NPCEnabled) then
		self:ClearAll()
		return
	end
	self:BuildRigIndex()
	local playersFolder = workspace:FindFirstChild("Players")
	if not playersFolder then
		self:ClearAll()
		return
	end
	local seenPlayer = {}
	local seenDowned = {}
	local seenNPC = {}
	for _, model in ipairs(playersFolder:GetChildren()) do
		if model:IsA("Model") and not self:IsLocalPlayerModel(model) then
			local tag = model:GetAttribute("Tag")
			local rig = nil
			if tag ~= nil then
				rig = self.TagToRig[tag]
			end
			if rig then
				if model:GetAttribute("AI") == true then
					--// NPC
					if self.NPCEnabled then
						seenNPC[rig] = true
						self:ApplyHighlight(self.NPCHighlights, rig, Color3.fromRGB(255, 0, 0))
					end
				else
					--// Real Player (alive or downed)
					if isModelDowned(model) then
						if self.DownedEnabled then
							seenDowned[rig] = true
							self:ApplyHighlight(self.DownedHighlights, rig, Color3.fromRGB(255, 255, 0))
						end
					elseif self.PlayerEnabled then
						seenPlayer[rig] = true
						self:ApplyHighlight(self.PlayerHighlights, rig, Color3.fromRGB(0, 255, 0))
					end
				end
			end
		end
	end
	self:SweepStorage(self.PlayerHighlights, seenPlayer)
	self:SweepStorage(self.DownedHighlights, seenDowned)
	self:SweepStorage(self.NPCHighlights, seenNPC)
end

function RingHighlightManager:EnsureConnection()
	if self.PlayerEnabled or self.DownedEnabled or self.NPCEnabled then
		if not self.Connection then
			self.Connection = RunService.RenderStepped:Connect(function()
				self:Update()
			end)
		end
		self:Update()
	else
		if self.Connection then
			self.Connection:Disconnect()
			self.Connection = nil
		end
		self:ClearAll()
	end
end

function cleanupRingHighlights()
	if not RingHighlightManager then
		return
	end
	RingHighlightManager.PlayerEnabled = false
	RingHighlightManager.DownedEnabled = false
	RingHighlightManager.NPCEnabled = false
	if RingHighlightManager.Connection then
		RingHighlightManager.Connection:Disconnect()
		RingHighlightManager.Connection = nil
	end
	RingHighlightManager:ClearAll()
end

-- Esp Tabs
local ESPManager = {
	Enabled = false,
	AliveElements = {},
	DownedElements = {},
	NPCElements = {},
	TicketElements = {},
	VehicleElements = {},
	Settings = {
		Boxes = false,
		BoxType = "2D",
		Names = false,
		Distance = false,
		Highlights = false,
	},
	DownedSettings = {
		Boxes = false,
		BoxType = "2D",
		Names = false,
		Distance = false,
		Highlights = false,
	},
	NPCSettings = {
		Boxes = false,
		BoxType = "2D",
		Names = false,
		Distance = false,
		Highlights = false,
	},
	TicketSettings = {
		Boxes = false,
		BoxType = "2D",
		Names = false,
		Distance = false,
		Highlights = false,
	},
	VehicleSettings = {
		Boxes = false,
		BoxType = "2D",
		Names = false,
		Distance = false,
		Highlights = false,
	},
	Connections = {
		Render = nil,
		RenderCheck = nil,
		RigAdded = nil,
		RigRemoved = nil,
		PlayerAdded = nil,
		PlayerRemoving = nil,
	},
	Rendering = true,
	WindowFocused = true,
	LastRenderTime = tick(),
	HighlightCache = {},
	RigOwner = {},
	PlayerRigs = {},
	RigCache = {},
	LastRigUpdate = 0
}

-- Tracer ESP Core
tracerGui = nil
tracerEntries = {}
function getTracerGui()
	if tracerGui and tracerGui.Parent then
		return tracerGui
	end
	local parentGui = PlayerGui
	if not parentGui then
		local lp = Players.LocalPlayer
		parentGui = lp and lp:FindFirstChild("PlayerGui")
	end
	if not parentGui then
		return nil
	end
	local gui = Instance.new("ScreenGui")
	gui.Name = "Tracer GUI"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = - 2147483648
	gui.Parent = parentGui
	tracerGui = gui
	return gui
end
function cleanupTracerESP()
	for _, data in pairs(tracerEntries) do
		if data.pivot then
			data.pivot:Destroy()
		end
	end
	tracerEntries = {}
	if tracerGui then
		tracerGui:Destroy()
		tracerGui = nil
	end
end
function ensureTracer(key, color)
	local data = tracerEntries[key]
	if data and data.pivot and data.pivot.Parent then
		if data.line then
			data.line.BackgroundColor3 = color
		end
		return data
	end
	local gui = getTracerGui()
	if not gui then
		return nil
	end
	local pivot = Instance.new("Frame")
	pivot.Name = "Tracer_" .. tostring(key)
	pivot.AnchorPoint = Vector2.new(0.5, 0.5)
	pivot.Position = UDim2.fromScale(0.5, 1)
	pivot.Size = UDim2.fromOffset(1, 1)
	pivot.BackgroundTransparency = 1
	pivot.Visible = false
	pivot.ZIndex = - 2147483648
	pivot.Parent = gui
	local line = Instance.new("Frame")
	line.Name = "Line"
	line.AnchorPoint = Vector2.new(0.5, 1)
	line.Position = UDim2.fromScale(0.5, 0.5)
	line.Size = UDim2.fromOffset(2, 0)
	line.BackgroundColor3 = color
	line.BorderSizePixel = 0
	line.ZIndex = - 2147483648
	line.Parent = pivot
	data = {
		pivot = pivot,
		line = line,
		lastPos = data and data.lastPos or nil
	}
	tracerEntries[key] = data
	return data
end
function drawTracer(data, worldPos, color)
	if not data or not data.pivot or not data.line then
		return
	end
	local camera = workspace.CurrentCamera
	if not camera or not worldPos then
		data.pivot.Visible = false
		return
	end
	data.line.BackgroundColor3 = color
	local screenPos = camera:WorldToViewportPoint(worldPos)
	local viewport = camera.ViewportSize
	local dirX = screenPos.X - (viewport.X * 0.5)
	local dirY = screenPos.Y - viewport.Y
	if screenPos.Z < 0 then
		dirX = - dirX
		dirY = - dirY
	end
	if dirX ~= dirX or dirY ~= dirY then
		data.pivot.Visible = false
		return
	end
	data.pivot.Visible = true
	data.pivot.Rotation = math.deg(math.atan2(dirX, - dirY))
	data.line.Size = UDim2.fromOffset(2, math.sqrt(dirX * dirX + dirY * dirY))
end
function tracerAnyEnabled()
	return playerTracersEnabled or npcTracersEnabled or toolTracersEnabled or downedTracersEnabled or enemyTracersEnabled or fruitTracersEnabled or gunTracersEnabled or ticketTracersEnabled or vehicleTracersEnabled or botTracersEnabled
end
function sweepDeadTracers(alive)
	for key, data in pairs(tracerEntries) do
		if not alive[key] then
			if data.pivot then
				data.pivot:Destroy()
			end
			tracerEntries[key] = nil
		end
	end
end
function getPartPos(inst)
	if not inst then
		return nil
	end
	if inst:IsA("BasePart") then
		return inst.Position
	end
	local hrp = inst:FindFirstChild("HumanoidRootPart")
	if hrp then
		return hrp.Position
	end
	local handle = inst:FindFirstChild("Handle")
	if handle then
		return handle.Position
	end
	if inst.PrimaryPart then
		return inst.PrimaryPart.Position
	end
	for _, child in ipairs(inst:GetChildren()) do
		if child:IsA("BasePart") then
			return child.Position
		end
	end
	return nil
end
function trackTracer(key, inst, color)
	local data = ensureTracer(key, color)
	if not data then
		return
	end
	local pos = getPartPos(inst)
	if pos then
		data.lastPos = pos
	end
	if data.lastPos then
		drawTracer(data, data.lastPos, color)
	else
		data.pivot.Visible = false
	end
end
playerTracersEnabled = false
npcTracersEnabled = false
toolTracersEnabled = false
downedTracersEnabled = false
enemyTracersEnabled = false
fruitTracersEnabled = false
gunTracersEnabled = false
ticketTracersEnabled = false
vehicleTracersEnabled = false
botTracersEnabled = false
function updateTracerESP()
	if not tracerAnyEnabled() then
		cleanupTracerESP()
		return
	end
	local alive = {}
	if playerTracersEnabled or downedTracersEnabled then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and plr.Character then
				local downed = false
				pcall(function()
					downed = isPlayerDowned(plr)
				end)
				if downed and downedTracersEnabled then
					local key = "downed_" .. plr.UserId
					alive[key] = true
					trackTracer(key, plr.Character, Color3.fromRGB(255, 255, 0))
				elseif (not downed) and playerTracersEnabled then
					local key = "player_" .. plr.UserId
					alive[key] = true
					trackTracer(key, plr.Character, Color3.fromRGB(0, 255, 0))
				end
			end
		end
	end
	if botTracersEnabled then
		local playersFolder = workspace:FindFirstChild("Players")
		if playersFolder then
			for index, model in ipairs(playersFolder:GetChildren()) do
				if model:IsA("Model") and model:GetAttribute("AI") == true then
					local key = "bot_" .. index
					alive[key] = true
					trackTracer(key, model, Color3.fromRGB(255, 0, 0))
				end
			end
		end
	end
	if ticketTracersEnabled then
		local effects = workspace:FindFirstChild("Effects")
		local ticketsFolder = effects and effects:FindFirstChild("Tickets")
		if ticketsFolder then
			for index, model in ipairs(ticketsFolder:GetChildren()) do
				if model:IsA("Model") then
					local key = "ticket_" .. index
					alive[key] = true
					trackTracer(key, model, Color3.fromRGB(0, 150, 255))
				end
			end
		end
	end
	if vehicleTracersEnabled then
		local vehiclesFolder = workspace:FindFirstChild("Vehicles")
		if vehiclesFolder then
			for index, model in ipairs(vehiclesFolder:GetChildren()) do
				if model:IsA("Model") then
					local key = "veh_" .. index
					alive[key] = true
					trackTracer(key, model, Color3.fromRGB(255, 105, 180))
				end
			end
		end
	end
	sweepDeadTracers(alive)
end
if not tracerRenderConnection then
	tracerRenderConnection = RunService.RenderStepped:Connect(function()
		if tracerAnyEnabled() then
			updateTracerESP()
		end
	end)
end
function getDistanceFromCamera(targetPosition)
	local camera = workspace.CurrentCamera
	if not camera then
		return 0
	end
	return (targetPosition - camera.CFrame.Position).Magnitude
end
function calculateBoxScale(distance)
	if distance <= 17 then
		return 1
	else
		local scale = 17 / distance
		return math.max(scale, 0.013)
	end
end
function getPlayerColor(player, isDowned)
	return isDowned and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(0, 255, 0)
end
function getRootPart(model)
	if not model then
		return nil
	end
	local root = model:FindFirstChild("HumanoidRootPart")
	if root then
		return root
	end
	root = model.PrimaryPart
	if root then
		return root
	end
	return model:FindFirstChildWhichIsA("BasePart")
end
function createBillboardForModel(model, name, color)
	local existing = model:FindFirstChild("ESP_Billboard")
	if existing then
		existing:Destroy()
	end
	local rootPart = getRootPart(model)
	if not rootPart then
		return nil
	end
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ESP_Billboard"
	billboard.Adornee = rootPart
	billboard.Parent = rootPart
	billboard.AlwaysOnTop = true
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.ClipsDescendants = false
	billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	billboard.Active = true
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(1, 0, 1, 0)
	mainFrame.BackgroundTransparency = 1
	mainFrame.Parent = billboard
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "NameLabel"
	nameLabel.Size = UDim2.new(1, 0, 0, 20)
	nameLabel.Position = UDim2.new(0, 0, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = name
	nameLabel.TextColor3 = color
	nameLabel.TextSize = 14
	nameLabel.Font = Enum.Font.GothamSemibold
	nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	nameLabel.TextStrokeTransparency = 0.3
	nameLabel.TextXAlignment = Enum.TextXAlignment.Center
	nameLabel.TextYAlignment = Enum.TextYAlignment.Bottom
	nameLabel.Parent = mainFrame
	local distanceLabel = Instance.new("TextLabel")
	distanceLabel.Name = "DistanceLabel"
	distanceLabel.Size = UDim2.new(1, 0, 0, 16)
	distanceLabel.Position = UDim2.new(0, 0, 0, 20)
	distanceLabel.BackgroundTransparency = 1
	distanceLabel.Text = ""
	distanceLabel.TextColor3 = color
	distanceLabel.TextSize = 12
	distanceLabel.Font = Enum.Font.Gotham
	distanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	distanceLabel.TextStrokeTransparency = 0.3
	distanceLabel.TextXAlignment = Enum.TextXAlignment.Center
	distanceLabel.TextYAlignment = Enum.TextYAlignment.Top
	distanceLabel.Parent = mainFrame
	return {
		billboard = billboard,
		nameLabel = nameLabel,
		distanceLabel = distanceLabel
	}
end
function updateBillboard(billboardData, name, distance, color)
	if not billboardData then
		return
	end
	if name then
		billboardData.nameLabel.Text = name
		billboardData.nameLabel.TextColor3 = color
	end
	if distance then
		billboardData.distanceLabel.Text = string.format("%.1f studs", distance)
		billboardData.distanceLabel.TextColor3 = color
	end
	billboardData.nameLabel.Visible = name ~= nil
	billboardData.distanceLabel.Visible = distance ~= nil
end
function create2DBoxForModel(model, color, scale)
	local rootPart = getRootPart(model)
	if not rootPart then
		return nil
	end
	local existing = model:FindFirstChild("ESP_2DBox")
	if existing then
		existing:Destroy()
	end
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ESP_2DBox"
	billboard.Adornee = rootPart
	billboard.Parent = rootPart
	billboard.AlwaysOnTop = true
	billboard.Size = UDim2.new(0, 80 * scale, 0, 100 * scale)
	billboard.StudsOffset = Vector3.new(0, 0, 0)
	billboard.ClipsDescendants = false
	local boxFrame = Instance.new("Frame")
	boxFrame.Name = "BoxFrame"
	boxFrame.Size = UDim2.new(1, 0, 1, 0)
	boxFrame.BackgroundTransparency = 1
	boxFrame.BorderSizePixel = 0
	boxFrame.Parent = billboard
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Thickness = math.max(1.5 * scale, 1)
	uiStroke.Transparency = 0
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uiStroke.Color = color
	uiStroke.Parent = boxFrame
	return {
		billboard = billboard,
		boxFrame = boxFrame,
		stroke = uiStroke,
		scale = scale
	}
end
function update2DBox(boxData, color, scale)
	if boxData then
		if boxData.stroke then
			boxData.stroke.Color = color
		end
		if boxData.billboard then
			boxData.billboard.Size = UDim2.new(0, 80 * scale, 0, 100 * scale)
		end
		if boxData.stroke then
			boxData.stroke.Thickness = math.max(1.5 * scale, 1)
		end
		boxData.scale = scale
	end
end
function remove2DBox(model)
	local rootPart = getRootPart(model)
	if rootPart then
		local box = rootPart:FindFirstChild("ESP_2DBox")
		if box then
			box:Destroy()
		end
	end
end
function create3DBoxForModel(model, color, size)
	local rootPart = getRootPart(model)
	if not rootPart then
		return nil
	end
	local folderName = "ESP_3DBox"
	local folder = model:FindFirstChild(folderName)
	if folder then
		folder:Destroy()
	end
	folder = Instance.new("Folder")
	folder.Name = folderName
	folder.Parent = model
	size = size or Vector3.new(4, 5, 3)
	local offsetX = size.X / 2
	local offsetY = size.Y / 2
	local offsetZ = size.Z / 2
	local edges = {
		{
			Vector3.new(0, offsetY, offsetZ),
			Vector3.new(size.X, 0.1, 0.1),
			"TopFront"
		},
		{
			Vector3.new(0, offsetY, - offsetZ),
			Vector3.new(size.X, 0.1, 0.1),
			"TopBack"
		},
		{
			Vector3.new(- offsetX, offsetY, 0),
			Vector3.new(0.1, 0.1, size.Z),
			"TopLeft"
		},
		{
			Vector3.new(offsetX, offsetY, 0),
			Vector3.new(0.1, 0.1, size.Z),
			"TopRight"
		},
		{
			Vector3.new(0, - offsetY, offsetZ),
			Vector3.new(size.X, 0.1, 0.1),
			"BottomFront"
		},
		{
			Vector3.new(0, - offsetY, - offsetZ),
			Vector3.new(size.X, 0.1, 0.1),
			"BottomBack"
		},
		{
			Vector3.new(- offsetX, - offsetY, 0),
			Vector3.new(0.1, 0.1, size.Z),
			"BottomLeft"
		},
		{
			Vector3.new(offsetX, - offsetY, 0),
			Vector3.new(0.1, 0.1, size.Z),
			"BottomRight"
		},
		{
			Vector3.new(- offsetX, 0, offsetZ),
			Vector3.new(0.1, size.Y, 0.1),
			"FrontLeft"
		},
		{
			Vector3.new(offsetX, 0, offsetZ),
			Vector3.new(0.1, size.Y, 0.1),
			"FrontRight"
		},
		{
			Vector3.new(- offsetX, 0, - offsetZ),
			Vector3.new(0.1, size.Y, 0.1),
			"BackLeft"
		},
		{
			Vector3.new(offsetX, 0, - offsetZ),
			Vector3.new(0.1, size.Y, 0.1),
			"BackRight"
		}
	}
	for _, edge in ipairs(edges) do
		local position = edge[1]
		local boxSize = edge[2]
		local name = edge[3]
		local adornment = Instance.new("BoxHandleAdornment")
		adornment.Name = name
		adornment.Adornee = rootPart
		adornment.Size = boxSize
		adornment.CFrame = CFrame.new(position)
		adornment.Color3 = color
		adornment.Transparency = 0.2
		adornment.ZIndex = 10
		adornment.AlwaysOnTop = true
		adornment.Visible = true
		adornment.Parent = folder
	end
	return folder
end
function update3DBoxColor(model, color)
	local folder = model:FindFirstChild("ESP_3DBox")
	if folder then
		for _, adornment in ipairs(folder:GetChildren()) do
			if adornment:IsA("BoxHandleAdornment") then
				adornment.Color3 = color
			end
		end
	end
end
function remove3DBox(model)
	local folder = model:FindFirstChild("ESP_3DBox")
	if folder then
		folder:Destroy()
	end
end
function scanRigs()
	local rigs = {}
	local allDescendants = workspace:GetDescendants()
	for _, object in ipairs(allDescendants) do
		if string.find(object.Name, "Rigs") then
			if object:IsA("Model") then
				table.insert(rigs, object)
			elseif object:IsA("Folder") then
				for _, child in ipairs(object:GetChildren()) do
					if child:IsA("Model") then
						table.insert(rigs, child)
					end
				end
			end
		end
	end
	return rigs
end
function updateRigCache()
	ESPManager.RigOwner = {}
	ESPManager.PlayerRigs = {}
	ESPManager.RigCache = scanRigs()
	local players = Players:GetPlayers()
	for _, rig in ipairs(ESPManager.RigCache) do
		for _, player in ipairs(players) do
			if player.Name == rig.Name then
				ESPManager.RigOwner[rig] = player
				if not ESPManager.PlayerRigs[player] then
					ESPManager.PlayerRigs[player] = {}
				end
				table.insert(ESPManager.PlayerRigs[player], rig)
				break
			end
		end
	end
end
function createHighlightForModel(model, color)
	if not model then
		return nil
	end
	local existing = model:FindFirstChild("ESP_Highlight")
	if existing then
		existing.FillColor = color
		existing.OutlineColor = color
		return existing
	end
	local highlight = Instance.new("Highlight")
	highlight.Name = "ESP_Highlight"
	highlight.Parent = model
	highlight.FillColor = color
	highlight.OutlineColor = color
	highlight.FillTransparency = 0.5
	highlight.OutlineTransparency = 0.3
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	return highlight
end
function addHighlightForModel(model, color)
	if not model then
		return
	end
	if not ESPManager.HighlightCache[model] then
		ESPManager.HighlightCache[model] = createHighlightForModel(model, color)
	else
		local highlight = ESPManager.HighlightCache[model]
		highlight.FillColor = color
		highlight.OutlineColor = color
	end
end
function removeHighlightForModel(model)
	if not model then
		return
	end
	local highlight = ESPManager.HighlightCache[model]
	if highlight then
		highlight:Destroy()
		ESPManager.HighlightCache[model] = nil
	end
end
function removeAllHighlights()
	for model, highlight in pairs(ESPManager.HighlightCache) do
		highlight:Destroy()
	end
	ESPManager.HighlightCache = {}
end
function cleanupElements(elementsTable)
	for model, esp in pairs(elementsTable) do
		if esp.box2D then
			remove2DBox(model)
		end
		if esp.box3D then
			remove3DBox(model)
		end
		if esp.billboard then
			local rootPart = getRootPart(model)
			if rootPart then
				local bill = rootPart:FindFirstChild("ESP_Billboard")
				if bill then
					bill:Destroy()
				end
			end
		end
		removeHighlightForModel(model)
	end
	table.clear(elementsTable)
end
function cleanupESP()
	cleanupElements(ESPManager.AliveElements)
	cleanupElements(ESPManager.DownedElements)
	cleanupElements(ESPManager.NPCElements)
	cleanupElements(ESPManager.TicketElements)
	cleanupElements(ESPManager.VehicleElements)
	removeAllHighlights()
end
function updateGenericESP(targets, color, settings, elementsTable, skipHighlights)
	local currentTargets = {}
	for _, target in ipairs(targets) do
		local model = target.model
		if not model or not model.Parent then
			continue
		end
		local rootPart = getRootPart(model)
		if not rootPart then
			continue
		end
		currentTargets[model] = true
		if not elementsTable[model] then
			elementsTable[model] = {}
		end
		local esp = elementsTable[model]
		local dist = getDistanceFromCamera(rootPart.Position)
		local scale = calculateBoxScale(dist)
		if settings.Boxes then
			if settings.BoxType == "3D" then
				if not esp.box3D then
					esp.box3D = create3DBoxForModel(model, color)
				else
					update3DBoxColor(model, color)
				end
				if esp.box2D then
					remove2DBox(model)
					esp.box2D = nil
				end
			else
				if not esp.box2D then
					esp.box2D = create2DBoxForModel(model, color, scale)
				else
					update2DBox(esp.box2D, color, scale)
				end
				if esp.box3D then
					remove3DBox(model)
					esp.box3D = nil
				end
			end
		else
			if esp.box2D then
				remove2DBox(model);
				esp.box2D = nil
			end
			if esp.box3D then
				remove3DBox(model);
				esp.box3D = nil
			end
		end
		if settings.Names or settings.Distance then
			if not esp.billboard then
				esp.billboard = createBillboardForModel(model, target.name, color)
			end
			local showDist = settings.Distance and dist or nil
			updateBillboard(esp.billboard, settings.Names and target.name or nil, showDist, color)
		else
			if esp.billboard then
				local rootPart = getRootPart(model)
				if rootPart then
					local bill = rootPart:FindFirstChild("ESP_Billboard")
					if bill then
						bill:Destroy()
					end
				end
				esp.billboard = nil
			end
		end
		if not skipHighlights and settings.Highlights then
			addHighlightForModel(model, color)
		else
			removeHighlightForModel(model)
		end
	end
	for model, esp in pairs(elementsTable) do
		if not currentTargets[model] then
			if esp.box2D then
				remove2DBox(model)
			end
			if esp.box3D then
				remove3DBox(model)
			end
			if esp.billboard then
				local rootPart = getRootPart(model)
				if rootPart then
					local bill = rootPart:FindFirstChild("ESP_Billboard")
					if bill then
						bill:Destroy()
					end
				end
			end
			removeHighlightForModel(model)
			elementsTable[model] = nil
		end
	end
end
function UpdateNPCHighlights()
	if not ESPManager.NPCSettings.Highlights then
		for model in pairs(ESPManager.HighlightCache) do
			local highlight = model:FindFirstChild("ESP_Highlight")
			if highlight then
				highlight:Destroy()
				ESPManager.HighlightCache[model] = nil
			end
		end
		return
	end
	local color = Color3.fromRGB(255, 0, 0)
	local rigs = workspace:FindFirstChild("Rigs")
	local playersFolder = workspace:FindFirstChild("Players")
	if rigs then
		for _, rig in ipairs(rigs:GetChildren()) do
			if rig:IsA("Model") then
				local team = playersFolder and playersFolder:FindFirstChild(rig.Name) and playersFolder[rig.Name]:GetAttribute("Team")
				if team ~= "PlayerTeam" then
					addHighlightForModel(rig, color)
				else
					removeHighlightForModel(rig)
				end
			end
		end
	end
	if playersFolder then
		for _, model in ipairs(playersFolder:GetChildren()) do
			if model:IsA("Model") and model:GetAttribute("AI") == true then
				addHighlightForModel(model, color)
			else
				removeHighlightForModel(model)
			end
		end
	end
end
function updateESP()
	if not ESPManager.Rendering or not ESPManager.WindowFocused then
		return
	end
	if not workspace.CurrentCamera then
		return
	end
	if tick() - ESPManager.LastRigUpdate > 5 then
		updateRigCache()
		ESPManager.LastRigUpdate = tick()
	end
	local aliveTargets = {}
	local downedTargets = {}
	for _, player in ipairs(Players:GetPlayers()) do
		if player == Players.LocalPlayer then
			continue
		end
		local char = player.Character
		if not char then
			continue
		end
		local hum = char:FindFirstChild("Humanoid")
		if not hum then
			continue
		end
		if isPlayerDowned(player) then
			table.insert(downedTargets, {
				model = char,
				name = player.Name
			})
		elseif hum.Health > 0 then
			table.insert(aliveTargets, {
				model = char,
				name = player.Name
			})
		end
	end
	updateGenericESP(
aliveTargets, Color3.fromRGB(0, 255, 0), ESPManager.Settings, ESPManager.AliveElements, false)
	updateGenericESP(
downedTargets, Color3.fromRGB(255, 255, 0), ESPManager.DownedSettings, ESPManager.DownedElements, false)
	local NPCTargets = {}
	local playersFolder = workspace:FindFirstChild("Players")
	if playersFolder then
		for _, model in ipairs(playersFolder:GetChildren()) do
			if model:IsA("Model") and model:GetAttribute("AI") == true then
				table.insert(NPCTargets, {
					model = model,
					name = model.Name
				})
			end
		end
	end
	for _, rig in ipairs(ESPManager.RigCache) do
		if rig:GetAttribute("AI") == true then
			table.insert(NPCTargets, {
				model = rig,
				name = rig.Name
			})
		end
	end
	updateGenericESP(
NPCTargets, Color3.fromRGB(255, 0, 0), ESPManager.NPCSettings, ESPManager.NPCElements, true)
	UpdateNPCHighlights()
	local ticketTargets = {}
	local effects = workspace:FindFirstChild("Effects")
	if effects then
		local ticketsFolder = effects:FindFirstChild("Tickets")
		if ticketsFolder then
			for _, model in ipairs(ticketsFolder:GetChildren()) do
				if model:IsA("Model") then
					table.insert(ticketTargets, {
						model = model,
						name = model.Name
					})
				end
			end
		end
	end
	updateGenericESP(
ticketTargets, Color3.fromRGB(0, 150, 255), ESPManager.TicketSettings, ESPManager.TicketElements, false)
	local vehicleTargets = {}
	local vehiclesFolder = workspace:FindFirstChild("Vehicles")
	if vehiclesFolder then
		for _, model in ipairs(vehiclesFolder:GetChildren()) do
			if model:IsA("Model") then
				table.insert(vehicleTargets, {
					model = model,
					name = model.Name
				})
			end
		end
	end
	updateGenericESP(
vehicleTargets, Color3.fromRGB(255, 105, 180), ESPManager.VehicleSettings, ESPManager.VehicleElements, false)
	if not ESPManager.Settings.Highlights and not ESPManager.DownedSettings.Highlights and not ESPManager.TicketSettings.Highlights and not ESPManager.VehicleSettings.Highlights and not ESPManager.NPCSettings.Highlights then
		if next(ESPManager.HighlightCache) ~= nil then
			removeAllHighlights()
		end
	end
end
function onRenderStepped()
	ESPManager.LastRenderTime = tick()
	ESPManager.Rendering = true
	updateESP()
end
function StartESP()
	StopESP()
	ESPManager.Enabled = true
	ESPManager.Connections.Render = RunService.RenderStepped:Connect(onRenderStepped)
end
function StopESP()
	ESPManager.Enabled = false
	if ESPManager.Connections.Render then
		ESPManager.Connections.Render:Disconnect()
		ESPManager.Connections.Render = nil
	end
	cleanupESP()
end
function setupWatchers()
	ESPManager.Connections.RigAdded = workspace.DescendantAdded:Connect(function(desc)
		if desc:IsA("Model") and string.find(desc.Name, "Rigs") then
			ESPManager.LastRigUpdate = 0
		end
	end)
	ESPManager.Connections.RigRemoved = workspace.DescendantRemoving:Connect(function(desc)
		if desc:IsA("Model") and string.find(desc.Name, "Rigs") then
			local highlight = ESPManager.HighlightCache[desc]
			if highlight then
				highlight:Destroy()
				ESPManager.HighlightCache[desc] = nil
			end
			local owner = ESPManager.RigOwner[desc]
			if owner then
				ESPManager.RigOwner[desc] = nil
				if ESPManager.PlayerRigs[owner] then
					for i, rig in ipairs(ESPManager.PlayerRigs[owner]) do
						if rig == desc then
							table.remove(ESPManager.PlayerRigs[owner], i)
							break
						end
					end
				end
			end
			for i, rig in ipairs(ESPManager.RigCache) do
				if rig == desc then
					table.remove(ESPManager.RigCache, i)
					break
				end
			end
		end
	end)
	ESPManager.Connections.PlayerAdded = Players.PlayerAdded:Connect(function()
		ESPManager.LastRigUpdate = 0
	end)
	ESPManager.Connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
		removeHighlightForModel(player.Character)
		ESPManager.PlayerRigs[player] = nil
	end)
end
setupWatchers()
RunService.RenderStepped:Connect(function()
	ESPManager.LastRenderTime = tick()
	ESPManager.Rendering = true
end)
ESPManager.Connections.RenderCheck = RunService.Heartbeat:Connect(function()
	local currentTime = tick()
	if currentTime - ESPManager.LastRenderTime > 1 then
		ESPManager.Rendering = false
		cleanupESP()
	end
end)
UserInputService.WindowFocusReleased:Connect(function()
	ESPManager.WindowFocused = false
	ESPManager.Rendering = false
	cleanupESP()
end)
UserInputService.WindowFocused:Connect(function()
	ESPManager.WindowFocused = true
	ESPManager.Rendering = true
end)
game:GetService("GuiService"):GetPropertyChangedSignal("MenuIsOpen"):Connect(function()
	if game:GetService("GuiService").MenuIsOpen then
		ESPManager.Rendering = false
		cleanupESP()
	else
		ESPManager.Rendering = true
	end
end)
Players.PlayerRemoving:Connect(function(leavingPlayer)
	if leavingPlayer == Players.LocalPlayer then
		cleanupESP()
		StopESP()
		cleanupRingHighlights()
	end
end)
Tabs.ESP:Section({
	Title = "Player ESP",
	TextSize = 20
})
Tabs.ESP:Divider()
Tabs.ESP:Toggle({
	Title = "Player Names",
	Flag = "PlayerNames",
	Value = false,
	Callback = function(state)
		ESPManager.Settings.Names = state
		if state then
			StartESP()
		else
			updateESP()
		end
	end
})
Tabs.ESP:Toggle({
	Title = "Player Boxes",
	Flag = "PlayerBoxes",
	Value = false,
	Callback = function(state)
		ESPManager.Settings.Boxes = state
		if state then
			StartESP()
		else
			updateESP()
		end
	end
})
Tabs.ESP:Dropdown({
	Title = "Player Box Type",
	Flag = "PlayerBoxType",
	Values = {
		"2D",
		"3D"
	},
	Value = "2D",
	Callback = function(value)
		ESPManager.Settings.BoxType = value
		if ESPManager.Settings.Boxes then
			updateESP()
		end
	end
})
Tabs.ESP:Toggle({
	Title = "Player Distance",
	Flag = "PlayerDistance",
	Value = false,
	Callback = function(state)
		ESPManager.Settings.Distance = state
		if state then
			StartESP()
		else
			updateESP()
		end
	end
})
Tabs.ESP:Toggle({
	Title = "Player Highlights",
	Flag = "PlayerHighlights",
	Value = false,
	Callback = function(state)
		ESPManager.Settings.Highlights = state
		if state then
			StartESP()
		else
			updateESP()
		end
	end
})
PlayerRingHighlightToggle = Tabs.ESP:Toggle({
	Title = "Player Ring Highlight",
	Flag = "PlayerRingHighlight",
	Desc = "Highlight the rig in Workspace.Rigs whose Tag matches each alive player",
	Value = false,
	Callback = function(state)
		RingHighlightManager.PlayerEnabled = state
		RingHighlightManager:EnsureConnection()
	end
})
Tabs.ESP:Toggle({
	Title = "Tracer ESP",
	Flag = "PlayerTracerESP",
	Desc = "Warning: Enable this may lack of performance! This features will make your game unplayable or lagging.",
	Value = false,
	Callback = function(state)
		playerTracersEnabled = state
		if not tracerAnyEnabled() then
			cleanupTracerESP()
		end
	end
})
Tabs.ESP:Divider()
Tabs.ESP:Section({
	Title = "Downed Player ESP",
	TextSize = 20
})
Tabs.ESP:Divider()
Tabs.ESP:Toggle({
	Title = "Downed Names",
	Flag = "DownedNames",
	Value = false,
	Callback = function(state)
		ESPManager.DownedSettings.Names = state
		if state then
			StartESP()
		else
			updateESP()
		end
	end
})
Tabs.ESP:Toggle({
	Title = "Downed Boxes",
	Flag = "DownedBoxes",
	Value = false,
	Callback = function(state)
		ESPManager.DownedSettings.Boxes = state
		if state then
			StartESP()
		else
			updateESP()
		end
	end
})
Tabs.ESP:Dropdown({
	Title = "Downed Box Type",
	Flag = "DownedBoxType",
	Values = {
		"2D",
		"3D"
	},
	Value = "2D",
	Callback = function(value)
		ESPManager.DownedSettings.BoxType = value
		if ESPManager.DownedSettings.Boxes then
			updateESP()
		end
	end
})
Tabs.ESP:Toggle({
	Title = "Downed Distance",
	Flag = "DownedDistance",
	Value = false,
	Callback = function(state)
		ESPManager.DownedSettings.Distance = state
		if state then
			StartESP()
		else
			updateESP()
		end
	end
})
Tabs.ESP:Toggle({
	Title = "Downed Highlights",
	Flag = "DownedHighlights",
	Value = false,
	Callback = function(state)
		ESPManager.DownedSettings.Highlights = state
		if state then
			StartESP()
		else
			updateESP()
		end
	end
})
DownedRingHighlightToggle = Tabs.ESP:Toggle({
	Title = "Downed Ring Highlight",
	Flag = "DownedRingHighlight",
	Desc = "Highlight the rig in Workspace.Rigs whose Tag matches each downed player",
	Value = false,
	Callback = function(state)
		RingHighlightManager.DownedEnabled = state
		RingHighlightManager:EnsureConnection()
	end
})
Tabs.ESP:Toggle({
	Title = "Tracer ESP",
	Flag = "DownedTracerESP",
	Desc = "Warning: Enable this may lack of performance! This features will make your game unplayable or lagging.",
	Value = false,
	Callback = function(state)
		downedTracersEnabled = state
		if not tracerAnyEnabled() then
			cleanupTracerESP()
		end
	end
})
Tabs.ESP:Divider()
Tabs.ESP:Section({
	Title = "NPC ESP",
	TextSize = 20
})
Tabs.ESP:Divider()
Tabs.ESP:Toggle({
	Title = "NPC Names",
	Flag = "NPCNames",
	Value = false,
	Callback = function(state)
		ESPManager.NPCSettings.Names = state
		if state then
			StartESP()
		else
			updateESP()
		end
	end
})
Tabs.ESP:Toggle({
	Title = "NPC Boxes",
	Flag = "NPCBoxes",
	Value = false,
	Callback = function(state)
		ESPManager.NPCSettings.Boxes = state
		if state then
			StartESP()
		else
			updateESP()
		end
	end
})
Tabs.ESP:Dropdown({
	Title = "NPC Box Type",
	Flag = "NPCBoxType",
	Values = {
		"2D",
		"3D"
	},
	Value = "2D",
	Callback = function(value)
		ESPManager.NPCSettings.BoxType = value
		if ESPManager.NPCSettings.Boxes then
			updateESP()
		end
	end
})
Tabs.ESP:Toggle({
	Title = "NPC Distance",
	Flag = "NPCDistance",
	Value = false,
	Callback = function(state)
		ESPManager.NPCSettings.Distance = state
		if state then
			StartESP()
		else
			updateESP()
		end
	end
})
Tabs.ESP:Toggle({
	Title = "NPC Highlights",
	Flag = "NPCHighlights",
	Value = false,
	Callback = function(state)
		ESPManager.NPCSettings.Highlights = state
		if state then
			StartESP()
		else
			updateESP()
		end
	end
})
NPCRingHighlightToggle = Tabs.ESP:Toggle({
	Title = "NPC Ring Highlight",
	Flag = "NPCRingHighlight",
	Desc = "Highlight the rig in Workspace.Rigs whose Tag matches each NPC",
	Value = false,
	Callback = function(state)
		RingHighlightManager.NPCEnabled = state
		RingHighlightManager:EnsureConnection()
	end
})
Tabs.ESP:Toggle({
	Title = "Tracer ESP",
	Flag = "NPCTracerESP",
	Desc = "Warning: Enable this may lack of performance! This features will make your game unplayable or lagging.",
	Value = false,
	Callback = function(state)
		botTracersEnabled = state
		if not tracerAnyEnabled() then
			cleanupTracerESP()
		end
	end
})
Tabs.ESP:Divider()
Tabs.ESP:Section({
	Title = "Ticket ESP",
	TextSize = 20
})
Tabs.ESP:Divider()
Tabs.ESP:Toggle({
	Title = "Ticket Boxes",
	Flag = "TicketBoxes",
	Value = false,
	Callback = function(state)
		ESPManager.TicketSettings.Boxes = state
		if state then
			StartESP()
		else
			updateESP()
		end
	end
})
Tabs.ESP:Dropdown({
	Title = "Ticket Box Type",
	Flag = "TicketBoxType",
	Values = {
		"2D",
		"3D"
	},
	Value = "2D",
	Callback = function(value)
		ESPManager.TicketSettings.BoxType = value
		if ESPManager.TicketSettings.Boxes then
			updateESP()
		end
	end
})
Tabs.ESP:Toggle({
	Title = "Ticket Names",
	Flag = "TicketNames",
	Value = false,
	Callback = function(state)
		ESPManager.TicketSettings.Names = state
		if state then
			StartESP()
		else
			updateESP()
		end
	end
})
Tabs.ESP:Toggle({
	Title = "Ticket Distance",
	Flag = "TicketDistance",
	Value = false,
	Callback = function(state)
		ESPManager.TicketSettings.Distance = state
		if state then
			StartESP()
		else
			updateESP()
		end
	end
})
Tabs.ESP:Toggle({
	Title = "Ticket Highlights",
	Flag = "TicketHighlights",
	Value = false,
	Callback = function(state)
		ESPManager.TicketSettings.Highlights = state
		if state then
			StartESP()
		else
			updateESP()
		end
	end
})
Tabs.ESP:Toggle({
	Title = "Tracer ESP",
	Flag = "TicketTracerESP",
	Desc = "Warning: Enable this may lack of performance! This features will make your game unplayable or lagging.",
	Value = false,
	Callback = function(state)
		ticketTracersEnabled = state
		if not tracerAnyEnabled() then
			cleanupTracerESP()
		end
	end
})
Tabs.ESP:Divider()
Tabs.ESP:Section({
	Title = "Vehicle ESP",
	TextSize = 20
})
Tabs.ESP:Divider()
Tabs.ESP:Toggle({
	Title = "Vehicle Names",
	Flag = "VehicleNames",
	Value = false,
	Callback = function(state)
		ESPManager.VehicleSettings.Names = state
		if state then
			StartESP()
		else
			updateESP()
		end
	end
})
Tabs.ESP:Toggle({
	Title = "Vehicle Boxes",
	Flag = "VehicleBoxes",
	Value = false,
	Callback = function(state)
		ESPManager.VehicleSettings.Boxes = state
		if state then
			StartESP()
		else
			updateESP()
		end
	end
})
Tabs.ESP:Dropdown({
	Title = "Vehicle Box Type",
	Flag = "VehicleBoxType",
	Values = {
		"2D",
		"3D"
	},
	Value = "2D",
	Callback = function(value)
		ESPManager.VehicleSettings.BoxType = value
		if ESPManager.VehicleSettings.Boxes then
			updateESP()
		end
	end
})
Tabs.ESP:Toggle({
	Title = "Vehicle Distance",
	Flag = "VehicleDistance",
	Value = false,
	Callback = function(state)
		ESPManager.VehicleSettings.Distance = state
		if state then
			StartESP()
		else
			updateESP()
		end
	end
})
Tabs.ESP:Toggle({
	Title = "Vehicle Highlights",
	Flag = "VehicleHighlights",
	Value = false,
	Callback = function(state)
		ESPManager.VehicleSettings.Highlights = state
		if state then
			StartESP()
		else
			updateESP()
		end
	end
})
Tabs.ESP:Toggle({
	Title = "Tracer ESP",
	Flag = "VehicleTracerESP",
	Desc = "Warning: Enable this may lack of performance! This features will make your game unplayable or lagging.",
	Value = false,
	Callback = function(state)
		vehicleTracersEnabled = state
		if not tracerAnyEnabled() then
			cleanupTracerESP()
		end
	end
})


-- Misc Tab
Tabs.Misc:Section({
	Title = "Misc",
	TextSize = 20
})
Tabs.Misc:Divider()
Tabs.Misc:Button({
	Title = "Hop in Random Vehicle",
	Callback = function()
		Interact:FireServer("Vehicle", workspace.Vehicles:GetChildren()[math.random(1, # workspace.Vehicles:GetChildren())]:GetAttribute("Tag"))
	end
})
Tabs.Misc:Space()
AntiAfkToggle = Tabs.Misc:Toggle({
	Title = "Anti AFK",
	Flag = "AntiAfkToggle",
	Value = false,
	Callback = function(s)
		if s then
			startAntiAFK()
		else
			stopAntiAFK()
		end
	end
})
Tabs.Misc:Space()
Tabs.Misc:Button({
	Title = "Redeem All code",
	Callback = function()
		local RemoteEvent = ReplicatedStorage.Shared.UserData.Events.Requests.RedeemCode
		local URL = "https://web-wacker.netlify.app/api/raw?url=https%3A%2F%2Fevade-nextbot.fandom.com%2Fwiki%2FCodes"
		function getContent(url)
			local success, content = pcall(function()
				return game:HttpGet(url, true)
			end)
			return success and content or nil
		end
		function extractTRData(htmlContent)
			if not htmlContent then
				return {}
			end
			local tableRows = {}
			local trPattern = "<tr>(.-)</tr>"
			for trContent in htmlContent:gmatch(trPattern) do
				local rowData = {}
				local codePattern = "<td[^>]*>%s*<code[^>]*>(.-)</code>"
				local code = trContent:match(codePattern)
				if code then
					code = code:gsub("&lt;", "<")
					code = code:gsub("&gt;", ">")
					code = code:gsub("&amp;", "&")
					code = code:gsub("&quot;", '"')
					code = code:match("^%s*(.-)%s*$") or code
					rowData.code = code
				end
				local tdPattern = "<td[^>]*>(.-)</td>"
				local tdCount = 0
				local tds = {}
				for tdContent in trContent:gmatch(tdPattern) do
					tdCount = tdCount + 1
					local cleanContent = tdContent
:gsub("<[^>]+>", "")
:gsub("&lt;", "<")
:gsub("&gt;", ">")
:gsub("&amp;", "&")
:gsub("&quot;", '"')
:gsub("%s+", " ")
:match("^%s*(.-)%s*$") or tdContent
					table.insert(tds, cleanContent)
				end
				if tdCount >= 2 and not rowData.code then
					rowData.code = tds[1]
					rowData.description = tdCount >= 2 and tds[2] or ""
					rowData.status = tdCount >= 3 and tds[3] or ""
					rowData.date = tdCount >= 4 and tds[4] or ""
				elseif rowData.code then
					rowData.description = tdCount >= 2 and tds[1] or ""
					rowData.status = tdCount >= 3 and tds[2] or ""
					rowData.date = tdCount >= 4 and tds[3] or ""
				end
				local statusPattern = "<b[^>]*>%s*<span[^>]*>([^<]+)</span>%s*</b>"
				local statusValue = trContent:match(statusPattern)
				if statusValue then
					statusValue = statusValue:lower():gsub("%s+", "")
					if statusValue == "true" or statusValue == "false" then
						rowData.spanStatus = statusValue
					end
				end
				if not rowData.spanStatus then
					local truePos = trContent:lower():find("true")
					local falsePos = trContent:lower():find("false")
					if truePos then
						rowData.spanStatus = "true"
					elseif falsePos then
						rowData.spanStatus = "false"
					end
				end
				if rowData.code and # rowData.code > 0 then
					table.insert(tableRows, rowData)
				end
			end
			return tableRows
		end
		function useCodeWithFeedback(code)
			local success, err = pcall(function()
				RemoteEvent:FireServer(code)
			end)
			if not success then
				local errMsg = tostring(err)
				warn("FireServer error:", errMsg)
				FireClient(
ReplicatedStorage.Events.SharedUISetType, "Notification", "Message", "Error firing code: " .. errMsg, "Error")
			else
				FireClient(
ReplicatedStorage.Events.SharedUISetType, "Notification", "Message", "Code sent: " .. code, "Info")
			end
		end
		function run()
			FireClient(
ReplicatedStorage.Events.SharedUISetType, "Notification", "Message", "Starting code extraction...", "Info")
			local htmlContent = getContent(URL)
			if not htmlContent then
				FireClient(
ReplicatedStorage.Events.SharedUISetType, "Notification", "Message", "Failed to fetch our Wikipedia content", "Error")
				return
			end
			local tableRows = extractTRData(htmlContent)
			if # tableRows == 0 then
				FireClient(
ReplicatedStorage.Events.SharedUISetType, "Notification", "Message", "No table rows found", "Error")
				return
			end
			FireClient(
ReplicatedStorage.Events.SharedUISetType, "Notification", "Message", "Found " .. # tableRows .. " table rows", "Info")
			local trueCodes = {}
			local falseCodes = {}
			local unknownCodes = {}
			for _, row in ipairs(tableRows) do
				local status = row.spanStatus or "unknown"
				if status == "true" then
					table.insert(trueCodes, row.code)
				elseif status == "false" then
					table.insert(falseCodes, row.code)
				else
					table.insert(unknownCodes, row.code)
				end
			end
			FireClient(
ReplicatedStorage.Events.SharedUISetType, "Notification", "Message", "True codes: " .. # trueCodes, "Success")
			FireClient(
ReplicatedStorage.Events.SharedUISetType, "Notification", "Message", "False codes: " .. # falseCodes, "Error")
			FireClient(
ReplicatedStorage.Events.SharedUISetType, "Notification", "Message", "Unknown codes: " .. # unknownCodes, "ing")
			FireClient(
ReplicatedStorage.Events.SharedUISetType, "Notification", "Message", "Code Will be redeem in 5 Second", "Message")
			wait(5)
			local validCodes = {}
			for _, code in ipairs(trueCodes) do
				table.insert(validCodes, code)
			end
			for _, code in ipairs(unknownCodes) do
				table.insert(validCodes, code)
			end
			if # validCodes == 0 then
				FireClient(
ReplicatedStorage.Events.SharedUISetType, "Notification", "Message", "No valid codes to try", "Error")
				return
			end
			for i, code in ipairs(validCodes) do
				FireClient(
ReplicatedStorage.Events.SharedUISetType, "Notification", "Message", "Processing [" .. i .. "/" .. # validCodes .. "]: " .. code, "Info")
				useCodeWithFeedback(code)
				if i < # validCodes then
					wait(4)
				end
			end
		end
		run()
	end
})
Tabs.Misc:Space()
local AntiNPCTeleportType = "Safe Part"
local AntiNPCDistance = 50
local DistanceTeleport = 100
local AntiNPCEnabled = false
local AntiNewNPCSpawnEnabled = false
local AntiNewNPCSpawnTeleportType = "Safe Part"
local AntiNewNPCSpawnDistance = 50
local AntiNewNPCSpawnTeleport = 100
local innocentBots = {}
local antiNPCConnection = nil
local antiNewSpawnConnection = nil
function getSafeCFrame(typ, root, tdist, NPCPos)
	if typ == "Safe Part" then
		return teleportToSecurityPart(Vector3.new(0, 3, 0))
	elseif typ == "Spawn" then
		return teleportToRandomSpawn(Vector3.new(0, 3, 0))
	elseif typ == "Distance" then
		return teleportToDistance(root, tdist, NPCPos)
	elseif typ == "Players" then
		return teleportToRandomPlayer(Vector3.new(0, 3, 0))
	end
	return root and root.CFrame or CFrame.new(0, 100, 0)
end
function stopAntiNPC()
	if antiNPCConnection then
		antiNPCConnection:Disconnect()
		antiNPCConnection = nil
	end
end
function startAntiNPC()
	if AntiNPCEnabled then
		antiNPCConnection = RunService.Heartbeat:Connect(function()
			local char = Players.LocalPlayer.Character
			if not char or not char:FindFirstChild("HumanoidRootPart") then
				return
			end
			local root = char.HumanoidRootPart
			local playersFolder = Workspace:FindFirstChild("Players")
			if playersFolder then
				for _, v in pairs(playersFolder:GetChildren()) do
					if v:IsA("Model") and v:GetAttribute("AI") == true and v:FindFirstChild("HumanoidRootPart") then
						if table.find(innocentBots, v.Name) then
							continue
						end
						if (root.Position - v.HumanoidRootPart.Position).Magnitude < AntiNPCDistance then
							local target = getSafeCFrame(AntiNPCTeleportType, root)
							if target then
								root.CFrame = target
							end
							break
						end
					end
				end
			end
			local gameFolder = Workspace:FindFirstChild("Game")
			if gameFolder then
				local gamePlayers = gameFolder:FindFirstChild("Players")
				if gamePlayers then
					for _, v in pairs(gamePlayers:GetChildren()) do
						if v:IsA("Model") and v:GetAttribute("AI") == true and v:FindFirstChild("HumanoidRootPart") then
							if table.find(innocentBots, v.Name) then
								continue
							end
							if (root.Position - v.HumanoidRootPart.Position).Magnitude < AntiNPCDistance then
								local target = getSafeCFrame(AntiNPCTeleportType, root)
								if target then
									root.CFrame = target
								end
								break
							end
						end
					end
				end
			end
		end)
	end
end
function stopAntiBotSpawnPoint()
	if antiNewSpawnConnection then
		antiNewSpawnConnection:Disconnect()
		antiNewSpawnConnection = nil
	end
end
function startAntiBotSpawnPoint()
	if AntiNewNPCSpawnEnabled then
		antiNewSpawnConnection = RunService.Heartbeat:Connect(function()
			local char = Players.LocalPlayer.Character
			if not char or not char:FindFirstChild("HumanoidRootPart") then
				return
			end
			local root = char.HumanoidRootPart
			local att = nil
			local terrain = Workspace:FindFirstChild("Terrain")
			if terrain then
				att = terrain:FindFirstChild("NextbotSpawnAttachment")
			end
			if not att then
				att = Workspace:FindFirstChild("NextbotSpawnAttachment")
			end
			if not att then
				local gameFolder = Workspace:FindFirstChild("Game")
				if gameFolder then
					att = gameFolder:FindFirstChild("NextbotSpawnAttachment")
				end
			end
			if not att then
				return
			end
			local spawnPos = att.WorldCFrame.Position
			if (root.Position - spawnPos).Magnitude >= AntiNewNPCSpawnDistance then
				return
			end
			local target = getSafeCFrame(AntiNewNPCSpawnTeleportType, root, AntiNewNPCSpawnTeleport, spawnPos)
			if target then
				root.CFrame = target
			end
		end)
	end
end
AntiNPCToggle = Tabs.Misc:Toggle({
	Title = "Anti NPC",
	Flag = "AntiNPCToggle",
	Value = false,
	Callback = function(state)
		AntiNPCEnabled = state
		if state then
			startAntiNPC()
		else
			stopAntiNPC()
		end
	end
})
AntiNPCTeleportTypeDropdown = Tabs.Misc:Dropdown({
	Title = "Anti-NPC Teleport Type",
	Flag = "AntiNPCTeleportTypeDropdown",
	Desc = "Choose how to teleport when avoiding NPCs",
	Values = {
		"Players",
		"Spawn",
		"Distance",
		"Safe Part"
	},
	Value = AntiNPCTeleportType,
	Callback = function(v)
		AntiNPCTeleportType = v
	end
})
AntiNPCDistanceInput = Tabs.Misc:Input({
	Title = "Anti-NPC Distance",
	Flag = "AntiNPCDistanceInput",
	Desc = "Distance threshold for NPC detection",
	Placeholder = tostring(AntiNPCDistance),
	NumbersOnly = true,
	Value = tostring(AntiNPCDistance),
	Callback = function(v)
		n = tonumber(v)
		if n and n > 0 then
			AntiNPCDistance = n
		end
	end
})
DistanceTeleportInput = Tabs.Misc:Input({
	Title = "Distance Teleport",
	Flag = "DistanceTeleportInput",
	Desc = "How far to teleport when using Distance mode",
	Placeholder = tostring(DistanceTeleport),
	NumbersOnly = true,
	Callback = function(v)
		n = tonumber(v)
		if n and n > 0 then
			DistanceTeleport = n
		end
	end
})
Tabs.Misc:Space()
AntiNewNPCSpawnToggle = Tabs.Misc:Toggle({
	Title = "Anti New NPC Spawn",
	Flag = "AntiNewNPCSpawnToggle",
	Value = false,
	Callback = function(state)
		AntiNewNPCSpawnEnabled = state
		if state then
			startAntiBotSpawnPoint()
		else
			stopAntiBotSpawnPoint()
		end
	end
})
AntiNewNPCSpawnTeleportTypeDropdown = Tabs.Misc:Dropdown({
	Title = "Anti New Spawn Teleport Type",
	Flag = "AntiNewNPCSpawnTeleportTypeDropdown",
	Desc = "Choose teleport method for spawn avoidance",
	Values = {
		"Players",
		"Spawn",
		"Distance",
		"Safe Part"
	},
	Value = AntiNewNPCSpawnTeleportType,
	Callback = function(v)
		AntiNewNPCSpawnTeleportType = v
	end
})
AntiNewNPCSpawnDistanceInput = Tabs.Misc:Input({
	Title = "New Spawn Distance",
	Flag = "AntiNewNPCSpawnDistanceInput",
	Desc = "Distance threshold for spawn detection",
	Placeholder = tostring(AntiNewNPCSpawnDistance),
	NumbersOnly = true,
	Value = tostring(AntiNewNPCSpawnDistance),
	Callback = function(v)
		n = tonumber(v)
		if n and n > 0 then
			AntiNewNPCSpawnDistance = n
		end
	end
})
AntiNewNPCSpawnTeleportInput = Tabs.Misc:Input({
	Title = "New Spawn Teleport Distance",
	Flag = "AntiNewNPCSpawnTeleportInput",
	Desc = "How far to teleport in Distance mode for spawn",
	Placeholder = tostring(AntiNewNPCSpawnTeleport),
	NumbersOnly = true,
	Callback = function(v)
		n = tonumber(v)
		if n and n > 0 then
			AntiNewNPCSpawnTeleport = n
		end
	end
})
Tabs.Misc:Section({
	Title = "Emote Crouch",
	TextSize = 20
})
Tabs.Misc:Divider()
math.randomseed(tick())
local emoteInputs = {}
local EmoteFireServer = {}
function getEmoteIDByName(name)
	local ownedIds = UseInventory.OwnedIds()
	for _, id in ipairs(ownedIds) do
		local config = ItemRegistry.GetConfig(id)
		if config and config.EquipInfo and config.EquipInfo.SlotType == "Emote" then
			local itemData = ItemRegistry.GetById(id)
			local itemName = nil
			if itemData then
				local module = itemData.Module
				if type(module) == "string" then
					itemName = module
				elseif typeof(module) == "Instance" then
					itemName = module.Name
				end
			end
			if itemName and itemName:lower() == name:lower() then
				return id
			end
		end
	end
	return nil
end
function isEmoteOwned(emoteId)
	local ownedIds = UseInventory.OwnedIds()
	for _, id in ipairs(ownedIds) do
		if id == emoteId then
			return true
		end
	end
	return false
end
for i = 1, 12 do
	emoteInputs[i] = Tabs.Misc:Input({
		Title = "Emote" .. i,
		Placeholder = "Emote Name or ID",
		Callback = function(value)
			EmoteFireServer["Emote" .. i] = value
		end
	})
end
function triggerRandomEmote()
	local validEmotes = {}
	for i = 1, 12 do
		local emoteValue = EmoteFireServer["Emote" .. i]
		if emoteValue and emoteValue ~= "" then
			table.insert(validEmotes, emoteValue)
		end
	end
	if # validEmotes > 0 then
		math.randomseed(tick() + # validEmotes)
		SendKeybindEvent("Crouching", true)
		local randomIndex = math.random(1, # validEmotes)
		local randomEmote = validEmotes[randomIndex]
		local emoteID = tonumber(randomEmote)
		if not emoteID then
			emoteID = getEmoteIDByName(randomEmote)
		end
		if emoteID and isEmoteOwned(emoteID) then
			pcall(function()
				ReplicatedStorage.Events.CharacterTask:FireServer("Emote", emoteID)
			end)
		else
			WindUI:Notify({
				Title = "Emote Error",
				Content = "Invalid Emote Or You do not own this emote. Attempt To fire server: \"" .. tostring(emoteID or randomEmote) .. "\"",
				Duration = 4
			})
		end
	end
end
ButtonLib.Create:Button({
	Text = "Emote Crouch",
	Flag = "EmoteCrouch",
	Visible = false,
	Callback = function()
		triggerRandomEmote()
	end
}).Position = UDim2.new(0.5, - 125, 0.2, 0)
EmoteCrouchToggle = Tabs.Misc:Toggle({
	Title = "Emote Crouch",
	Flag = "EmoteCrouchToggle",
	Desc = "Type emote name or ID - must be in your emote slot",
	Value = false,
	Callback = function(state)
		EmoteCrouchEnabled = state
		if ButtonLib and ButtonLib.EmoteCrouch then
			ButtonLib.EmoteCrouch:SetVisible(state)
		end
	end
})
Tabs.Misc:Space()
if game:GetService("UserInputService").TouchEnabled then
	local MOVE_DIRECTION = Vector3.new(0, 0, 0)
	local activeDirections = {
		left = false,
		right = false,
		up = false,
		down = false
	}
	local activeTouches = {}
	local isMovementEnabled = false
	local childAddedConnection = nil
	local childRemovedConnection = nil
	function applyMovement()
		if not isMovementEnabled then
			setMovementVector(Vector3.new(0, 0, 0))
			return
		end
		local x = 0
		local z = 0
		if activeDirections.left then
			x = x - 1
		end
		if activeDirections.right then
			x = x + 1
		end
		if activeDirections.up then
			z = z - 1
		end
		if activeDirections.down then
			z = z + 1
		end
		if x ~= 0 or z ~= 0 then
			local magnitude = math.sqrt(x * x + z * z)
			if magnitude > 1 then
				x = x / magnitude
				z = z / magnitude
			end
			setMovementVector(Vector3.new(x, 0, z))
		else
			setMovementVector(Vector3.new(0, 0, 0))
		end
	end
	function setMovementVector(direction)
		MOVE_DIRECTION = direction
		if success and ControlModule then
			local originalGetMove = ControlModule.GetMoveVector
			ControlModule.GetMoveVector = function(...)
				local input = originalGetMove(...)
				if input.Magnitude > 0.1 then
					return input
				end
				return MOVE_DIRECTION
			end
		end
	end
	function resetAllDirections()
		activeDirections.left = false
		activeDirections.right = false
		activeDirections.up = false
		activeDirections.down = false
		activeTouches = {}
		applyMovement()
	end
	function createTouchButton(config)
		local button = Instance.new("ImageButton")
		button.Name = config.Name
		button.ImageRectOffset = Vector2.new(1, 146)
		button.ImageRectSize = Vector2.new(144, 144)
		button.AutoButtonColor = false
		button.AnchorPoint = config.AnchorPoint or Vector2.new(0, 0.5)
		button.BackgroundColor3 = Color3.new(0, 0, 0)
		button.BackgroundTransparency = 0.5
		button.Position = config.Position
		button.Size = config.Size
		button.Parent = config.Parent
		button.Visible = config.Visible ~= nil and config.Visible or false

-- Main button corner (Scale = 1)
		local corner = Instance.new("UICorner")
		corner.BottomLeftRadius = UDim.new(1, 0)
		corner.BottomRightRadius = UDim.new(1, 0)
		corner.TopLeftRadius = UDim.new(1, 0)
		corner.TopRightRadius = UDim.new(1, 0)
		corner.Parent = button
		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.new(1, 1, 1)
		stroke.Thickness = 3
		stroke.Transparency = 0.8
		stroke.Parent = button
		local innerFrame = Instance.new("Frame")
		innerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		innerFrame.BackgroundTransparency = 1
		innerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		innerFrame.Size = UDim2.new(1, 6, 1, 6)
		innerFrame.Parent = button
		local innerStroke = Instance.new("UIStroke")
		innerStroke.Thickness = 2
		innerStroke.Transparency = 0.6
		innerStroke.Parent = innerFrame

-- Inner corner (Scale = 1)
		local innerCorner = Instance.new("UICorner")
		innerCorner.BottomLeftRadius = UDim.new(1, 0)
		innerCorner.BottomRightRadius = UDim.new(1, 0)
		innerCorner.TopLeftRadius = UDim.new(1, 0)
		innerCorner.TopRightRadius = UDim.new(1, 0)
		innerCorner.Parent = innerFrame
		local textLabel = Instance.new("TextLabel")
		textLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
		textLabel.Text = config.Text
		textLabel.TextColor3 = Color3.new(1, 1, 1)
		textLabel.TextScaled = true
		textLabel.TextTransparency = 0.4
		textLabel.TextWrapped = true
		textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		textLabel.BackgroundTransparency = 1
		textLabel.Position = UDim2.new(0.51, 0, 0.5, - 4)
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.Parent = button
		function handlePress()
			if isMovementEnabled and config.Callback then
				config.Callback(true)
			end
		end
		function handleRelease()
			if isMovementEnabled and config.Callback then
				config.Callback(false)
			end
		end
		button.MouseButton1Down:Connect(handlePress)
		button.MouseButton1Up:Connect(handleRelease)
		button.MouseLeave:Connect(handleRelease)
		function onTouchStart(input, processed)
			if processed then
				return
			end
			if input.UserInputType == Enum.UserInputType.Touch then
				local touchPos = input.Position
				local buttonSize = button.AbsoluteSize
				local buttonPos = button.AbsolutePosition
				if touchPos.X >= buttonPos.X and touchPos.X <= buttonPos.X + buttonSize.X and touchPos.Y >= buttonPos.Y and touchPos.Y <= buttonPos.Y + buttonSize.Y then
					if not activeTouches[input] then
						activeTouches[input] = true
						handlePress()
					end
				end
			end
		end
		function onTouchEnd(input, processed)
			if input.UserInputType == Enum.UserInputType.Touch and activeTouches[input] then
				activeTouches[input] = nil
				handleRelease()
			end
		end
		UserInputService.InputBegan:Connect(onTouchStart)
		UserInputService.InputEnded:Connect(onTouchEnd)
		return button
	end
	local movementButtons = {}
	local visibilityConnection = nil

-- Updated path to ExitVehicle
	function getLeaveButtonState()
		local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
		if not PlayerGui then
			return {
				exists = false,
				visible = false
			}
		end
		local gameGUI = PlayerGui:FindFirstChild("Game")
		if not gameGUI then
			return {
				exists = false,
				visible = false
			}
		end
		local hud = gameGUI:FindFirstChild("HUD")
		if not hud then
			return {
				exists = false,
				visible = false
			}
		end
		local mobile = hud:FindFirstChild("Mobile")
		if not mobile then
			return {
				exists = false,
				visible = false
			}
		end
		local center = mobile:FindFirstChild("Center")
		if not center then
			return {
				exists = false,
				visible = false
			}
		end
		local interact1 = center:FindFirstChild("Interact")
		if not interact1 then
			return {
				exists = false,
				visible = false
			}
		end
		local interact2 = interact1:FindFirstChild("Interact")
		if not interact2 then
			return {
				exists = false,
				visible = false
			}
		end
		local exitVehicle = interact2:FindFirstChild("ExitVehicle")
		if not exitVehicle then
			return {
				exists = false,
				visible = false
			}
		end
		return {
			exists = true,
			visible = exitVehicle.Visible
		}
	end
	function updateMovementSystem()
		local buttonState = getLeaveButtonState()
		local shouldBeActive = buttonState.exists and buttonState.visible
		isMovementEnabled = shouldBeActive
		if not isMovementEnabled then
			resetAllDirections()
		end
		for name, button in pairs(movementButtons) do
			if button and button.Parent then
				button.Visible = shouldBeActive
			end
		end
	end

-- Updated to monitor the new parent (second Interact) and child name "ExitVehicle"
	function monitorLeaveButton(exitVehicleParent)
		updateMovementSystem()
		local onChildAdded = exitVehicleParent.ChildAdded:Connect(function(child)
			if child.Name == "ExitVehicle" then
				if visibilityConnection then
					visibilityConnection:Disconnect()
					visibilityConnection = nil
				end
				visibilityConnection = child:GetPropertyChangedSignal("Visible"):Connect(updateMovementSystem)
				updateMovementSystem()
				task.defer(updateMovementSystem)
			end
		end)
		local onChildRemoved = exitVehicleParent.ChildRemoved:Connect(function(child)
			if child.Name == "ExitVehicle" then
				if visibilityConnection then
					visibilityConnection:Disconnect()
					visibilityConnection = nil
				end
				updateMovementSystem()
			end
		end)
		local existingExitVehicle = exitVehicleParent:FindFirstChild("ExitVehicle")
		if existingExitVehicle then
			if visibilityConnection then
				visibilityConnection:Disconnect()
			end
			visibilityConnection = existingExitVehicle:GetPropertyChangedSignal("Visible"):Connect(updateMovementSystem)
			updateMovementSystem()
			task.defer(updateMovementSystem)
		end
		return onChildAdded, onChildRemoved
	end
	function CreateHUDButtons()
		local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
		if not PlayerGui then
			return
		end
		local gameGUI = PlayerGui:FindFirstChild("Game")
		if not gameGUI then
			return
		end
		local hud = gameGUI:FindFirstChild("HUD")
		if not hud then
			return
		end
		local mobile = hud:FindFirstChild("Mobile")
		if not mobile then
			return
		end
		local rightPanel = mobile:FindFirstChild("Right")
		if not rightPanel then
			return
		end
		local leftPanel = mobile:FindFirstChild("Left")
		if not leftPanel then
			return
		end
		local leftMobileFrame = leftPanel:FindFirstChild("Mobile")
		if not leftMobileFrame then
			return
		end

-- Get the container for ExitVehicle (Center.Interact.Interact)
		local center = mobile:FindFirstChild("Center")
		if not center then
			return
		end
		local interact1 = center:FindFirstChild("Interact")
		if not interact1 then
			return
		end
		local exitVehicleParent = interact1:FindFirstChild("Interact")
		if not exitVehicleParent then
			return
		end

-- VUp
		if not rightPanel:FindFirstChild("VUp") then
			movementButtons.VUp = createTouchButton({
				Name = "VUp",
				Parent = rightPanel,
				Text = "↑",
				Visible = false,
				Position = UDim2.new(- 1.5, 0, - 0.7, 0),
				Size = UDim2.new(1.39, 0, 1.39, 0),
				Callback = function(isPressed)
					if isPressed then
						activeDirections.up = true
					else
						activeDirections.up = false
					end
					applyMovement()
				end
			})
		else
			movementButtons.VUp = rightPanel.VUp
		end

-- VDown
		if not rightPanel:FindFirstChild("VDown") then
			movementButtons.VDown = createTouchButton({
				Name = "VDown",
				Parent = rightPanel,
				Text = "↓",
				Visible = false,
				Position = UDim2.new(- 3.2, 0, - 0.7, 0),
				Size = UDim2.new(1.39, 0, 1.39, 0),
				Callback = function(isPressed)
					if isPressed then
						activeDirections.down = true
					else
						activeDirections.down = false
					end
					applyMovement()
				end
			})
		else
			movementButtons.VDown = rightPanel.VDown
		end

-- VLeft
		if not leftMobileFrame:FindFirstChild("VLeft") then
			movementButtons.VLeft = createTouchButton({
				Name = "VLeft",
				Parent = leftMobileFrame,
				Text = "←",
				Visible = false,
				Position = UDim2.new(0.4, 0, 0.66, 0),
				Size = UDim2.new(0.3, 0, 0.3, 0),
				Callback = function(isPressed)
					if isPressed then
						activeDirections.left = true
					else
						activeDirections.left = false
					end
					applyMovement()
				end
			})
		else
			movementButtons.VLeft = leftMobileFrame.VLeft
		end

-- VRight
		if not leftMobileFrame:FindFirstChild("VRight") then
			movementButtons.VRight = createTouchButton({
				Name = "VRight",
				Parent = leftMobileFrame,
				Text = "→",
				Visible = false,
				Position = UDim2.new(0.8, 0, 0.66, 0),
				Size = UDim2.new(0.3, 0, 0.3, 0),
				Callback = function(isPressed)
					if isPressed then
						activeDirections.right = true
					else
						activeDirections.right = false
					end
					applyMovement()
				end
			})
		else
			movementButtons.VRight = leftMobileFrame.VRight
		end

-- Pass the correct parent (second Interact) to monitor
		local leaveButtonMonitors = monitorLeaveButton(exitVehicleParent)
		childAddedConnection = leaveButtonMonitors
		childRemovedConnection = select(2, leaveButtonMonitors)
	end
	function RemoveVehicleHUD()
		for name, button in pairs(movementButtons) do
			if button and button.Parent then
				button:Destroy()
			end
		end
		movementButtons = {}
		if visibilityConnection then
			visibilityConnection:Disconnect()
			visibilityConnection = nil
		end
		if childAddedConnection then
			childAddedConnection:Disconnect()
			childAddedConnection = nil
		end
		if childRemovedConnection then
			childRemovedConnection:Disconnect()
			childRemovedConnection = nil
		end
		isMovementEnabled = false
		resetAllDirections()
	end
	function AddVehicleHUD()
		local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
		function checkGameExists()
			if PlayerGui:FindFirstChild("Game") then
				CreateHUDButtons()
			else
				PlayerGui.ChildAdded:Connect(function(child)
					if child.Name == "Game" then
						CreateHUDButtons()
					end
				end)
			end
		end
		checkGameExists()
	end
	Tabs.Misc:Toggle({
		Title = "Cars touch HUD",
		Callback = function(c)
			if c then
				AddVehicleHUD()
			else
				RemoveVehicleHUD()
			end
		end
	})
end
do
	Tabs.Misc:Space()
	local OriginalRagdollFunctions = {}
	function StartAntiRagdoll()
		if OriginalRagdollFunctions.Ragdoll then
			return
		end
		OriginalRagdollFunctions.Ragdoll = RagdollModule.Ragdoll
		OriginalRagdollFunctions.StartRagdoll = RagdollModule.StartRagdoll
		RagdollModule.Ragdoll = function(self, isPermanent, impulseData, ragdollConfig)
			if ragdollConfig and ragdollConfig.Model then
				self:EndRagdoll(ragdollConfig.Model)
			end
		end
		RagdollModule.StartRagdoll = function()
		end
	end
	function StopAntiRagdoll()
		if not OriginalRagdollFunctions.Ragdoll then
			return
		end
		RagdollModule.Ragdoll = OriginalRagdollFunctions.Ragdoll
		RagdollModule.StartRagdoll = OriginalRagdollFunctions.StartRagdoll
		OriginalRagdollFunctions = {}
	end
	Tabs.Misc:Toggle({
		Title = "Anti Ragdoll",
		Callback = function(s)
			if s then
				StartAntiRagdoll()
			else
				StopAntiRagdoll()
			end
		end
	})
end
Tabs.Misc:Section({
	Title = "TAS",
	TextSize = 20
})
Tabs.Misc:Divider()
Running = false
Frames = {}
TimeStart = tick()
getChar = function()
	if Character then
		return Character
	else
		LocalPlayer.CharacterAdded:Wait()
		return getChar()
	end
end
StartRecord = function()
	Frames = {}
	Running = true
	TimeStart = tick()
	while Running == true do
		game:GetService("RunService").Heartbeat:wait()
		Character = getChar()
		table.insert(Frames, {
			Character.HumanoidRootPart.CFrame,
			Character.Humanoid:GetState().Value,
			tick() - TimeStart
		})
	end
end
StopRecord = function()
	Running = false
end
PlayTAS = function()
	Character = getChar()
	TimePlay = tick()
	FrameCount = # Frames
	OldFrame = 1
	TASLoop = game:GetService("RunService").Heartbeat:Connect(function()
		CurrentTime = tick()
		if (CurrentTime - TimePlay) >= Frames[FrameCount][3] then
			TASLoop:Disconnect()
			return
		end
		for i = OldFrame, math.min(OldFrame + 60, FrameCount) do
			Frame = Frames[i]
			if Frame and Frame[3] <= (CurrentTime - TimePlay) then
				OldFrame = i
				Character.HumanoidRootPart.CFrame = Frame[1]
				Character.Humanoid:ChangeState(Frame[2])
			end
		end
	end)
end
Tabs.Misc:Button({
	Title = "Start recording",
	Color = Color3.fromHex("#30FF6A"),
	Callback = StartRecord
})
Tabs.Misc:Button({
	Title = "Stop recording",
	Color = Color3.fromHex("#ff4830"),
	Callback = StopRecord
})
Tabs.Misc:Button({
	Title = "Play",
	Color = Color3.fromHex("#30FF6A"),
	Callback = PlayTAS
})
-- Utility Tab
do
	local hiddenfling = false
	local movel = 0.1
	local flingPower = 1e35
	local flingCoroutine = nil
	local flingRespawn = nil
	local targetEnabled = false
	local targetName = ""
	local teamAttribute = ""
	local targetHeartbeat = nil
	local flingActive = false
	local currentTargetHRP = nil
	local targetChangeTime = 0
	function fling2()
		local chr = LocalPlayer.Character
		if not chr then
			return
		end
		local hrp = chr:FindFirstChild("HumanoidRootPart")
		if not hrp then
			return
		end
		while flingActive and chr and hrp and hrp.Parent do
			local vel = hrp.Velocity
			hrp.Velocity = vel * flingPower + Vector3.new(0, flingPower, 0)
			RunService.RenderStepped:Wait()
			hrp.Velocity = vel
			RunService.Stepped:Wait()
			hrp.Velocity = vel + Vector3.new(0, movel, 0)
			movel = - movel
			RunService.Heartbeat:Wait()
		end
	end
	function startFling2()
		if flingCoroutine then
			coroutine.close(flingCoroutine)
			flingCoroutine = nil
		end
		flingActive = true
		flingCoroutine = coroutine.create(fling2)
		coroutine.resume(flingCoroutine)
	end
	function stopFling2()
		if flingCoroutine then
			coroutine.close(flingCoroutine)
			flingCoroutine = nil
		end
		flingActive = false
		local chr = LocalPlayer.Character
		if chr then
			local hrp = chr:FindFirstChild("HumanoidRootPart")
			if hrp then
				hrp.Velocity = Vector3.new(0, 0, 0)
				hrp.RotVelocity = Vector3.new(0, 0, 0)
			end
		end
	end
	function updateFlingState()
		if (hiddenfling or targetEnabled) and not flingCoroutine then
			startFling2()
		elseif not (hiddenfling or targetEnabled) and flingCoroutine then
			stopFling2()
		end
	end
	function findRandomTarget()
		local playersFolder = Workspace:FindFirstChild("Players")
		if not playersFolder then
			return nil
		end
		local models = playersFolder:GetChildren()
		local filtered = {}
		local count = 0
		for i = 1, # models do
			local model = models[i]
			if model:IsA("Model") and model ~= LocalPlayer.Character then
				local modelName = model.Name
				local attrName = model:GetAttribute("Name")
				local attrTeam = model:GetAttribute("Team")
				local include = true
				if teamAttribute and teamAttribute ~= "" then
					if attrTeam ~= teamAttribute then
						include = false
					end
				end
				if include and targetName and targetName ~= "" then
					local tn = targetName
					if tn:sub(1, 1) == "!" then
						local excludePattern = tn:sub(2)
						local haystack = (modelName or "") .. " " .. (attrName or "") .. " " .. (attrTeam or "")
						if haystack:lower():find(excludePattern:lower(), 1, true) then
							include = false
						end
					elseif tn:sub(1, 2) == "==" then
						local exact = tn:sub(3)
						local lowerExact = exact:lower()
						if not (modelName:lower() == lowerExact or (attrName and attrName:lower() == lowerExact) or (attrTeam and attrTeam:lower() == lowerExact)) then
							include = false
						end
					else
						local pattern = tn:lower()
						local haystack = (modelName or "") .. " " .. (attrName or "") .. " " .. (attrTeam or "")
						if not haystack:lower():find(pattern, 1, true) then
							include = false
						end
					end
				end
				if include then
					local hrp = model:FindFirstChild("HumanoidRootPart")
					if hrp then
						count = count + 1
						filtered[count] = hrp
					end
				end
			end
		end
		if count == 0 then
			return nil
		end
		return filtered[math.random(count)]
	end
	function selectNewTarget()
		currentTargetHRP = findRandomTarget()
		targetChangeTime = tick()
	end
	function updateTargetHeartbeat()
		if targetEnabled then
			if not targetHeartbeat then
				currentTargetHRP = nil
				targetChangeTime = 0
				targetHeartbeat = RunService.Heartbeat:Connect(function()
					local chr = LocalPlayer.Character
					if not chr then
						return
					end
					local hrp = chr:FindFirstChild("HumanoidRootPart")
					if not hrp then
						return
					end
					if not currentTargetHRP or not currentTargetHRP.Parent or (tick() - targetChangeTime >= 10) then
						selectNewTarget()
					end
					if currentTargetHRP then
						local offset = Vector3.new(0, math.random(- 5, 5), 0)
						local targetCFrame = currentTargetHRP.CFrame + offset
						teleportToCFrame(targetCFrame)
					end
				end)
			end
		else
			if targetHeartbeat then
				targetHeartbeat:Disconnect()
				targetHeartbeat = nil
			end
			currentTargetHRP = nil
			targetChangeTime = 0
		end
	end
	function onCharacterAdded(character)
		if hiddenfling or targetEnabled then
			task.wait(1)
			updateFlingState()
			updateTargetHeartbeat()
		else
			task.wait(0.5)
			local hrp = character:FindFirstChild("HumanoidRootPart")
			if hrp then
				hrp.Velocity = Vector3.new(0, 0, 0)
				hrp.RotVelocity = Vector3.new(0, 0, 0)
			end
		end
	end
	Tabs.Utility:Space()
	TouchFlingToggle = Tabs.Utility:Toggle({
		Title = "Touch Fling",
		Desc = "You need to get in a vehicle to fling Bots or your stupid friend",
		Flag = "TouchFlingToggle",
		Value = false,
		Callback = function(state)
			hiddenfling = state
			if state then
				if not flingRespawn then
					flingRespawn = LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
				end
			else
				if flingRespawn then
					flingRespawn:Disconnect()
					flingRespawn = nil
				end
			end
			updateFlingState()
			updateTargetHeartbeat()
		end
	})
	FlingTargetToggle = Tabs.Utility:Toggle({
		Title = "Fling Target",
		Flag = "FlingTargetToggle",
		Value = false,
		Callback = function(state)
			targetEnabled = state
			updateFlingState()
			updateTargetHeartbeat()
		end
	})
	Tabs.Utility:Input({
		Title = "Target name",
		Placeholder = "Enter target name (use ! to skip, == for exact)",
		Callback = function(value)
			targetName = value or ""
		end
	})
	Tabs.Utility:Input({
		Title = "Attribute Team",
		Placeholder = "Enter team attribute (optional)",
		Callback = function(value)
			teamAttribute = value or ""
		end
	})
	Tabs.Utility:Input({
		Title = "Fling Power",
		Placeholder = "Enter fling power (default: 1e35)",
		Callback = function(value)
			if value and value ~= "" then
				flingPower = tonumber(value) or 1e35
			end
		end
	})
end
Tabs.Utility:Space()
Tabs.Utility:Toggle({
	Title = "Invis Walls Collide",
	Value = true,
	Callback = function(state)
		local invisPartsFolder = workspace:FindFirstChild("Map")
		if invisPartsFolder then
			invisPartsFolder = invisPartsFolder:FindFirstChild("InvisParts")
		end
		if not invisPartsFolder then
			invisPartsFolder = workspace:FindFirstChild("Game")
			if invisPartsFolder then
				invisPartsFolder = invisPartsFolder:FindFirstChild("Map")
				if invisPartsFolder then
					invisPartsFolder = invisPartsFolder:FindFirstChild("InvisParts")
				end
			end
		end
		if invisPartsFolder then
			for _, obj in ipairs(invisPartsFolder:GetDescendants()) do
				if obj:IsA("BasePart") then
					obj.CanCollide = state
				end
			end
		else
			WindUI:Notify({
				Title = "Error",
				Content = "InvisParts folder not found",
				Duration = 3
			})
			warn("InvisParts folder not found")
		end
	end
})
Tabs.Utility:Space()
TimeChangerInput = Tabs.Utility:Input({
	Title = "Set Time",
	Value = "12:00",
	Flag = "TimeChangerInput",
	Placeholder = "HH:MM"
})
TimeChangerInput.Callback = function(value)
	value = value:gsub("^%s*(.-)%s*$", "%1")
	local h_str, m_str = value:match("(%d+):(%d+)")
	if h_str and m_str then
		local h = tonumber(h_str)
		local m = tonumber(m_str)
		if h and m and h >= 0 and h <= 23 and m >= 0 and m <= 59 and # h_str <= 2 and # m_str <= 2 then
			local totalHours = h + (m / 60)
			game:GetService("Lighting").ClockTime = totalHours
			WindUI:Notify({
				Title = "Time Updated",
				Content = "In-game time set to " .. string.format("%02d:%02d", h, m),
				Duration = 3
			})
		else
			WindUI:Notify({
				Title = "Invalid Time",
				Content = "Please enter a valid time between 00:00 and 23:59.",
				Duration = 3
			})
		end
	else
		WindUI:Notify({
			Title = "Invalid Format",
			Content = "Please use the HH:MM format (e.g., 14:30).",
			Duration = 3
		})
	end
end
lagSwitchEnabled = false
lagDuration = 0.5
lagMethod = "CPU Cycle"
local isLagActive = false
local lagSystemLoaded = false
function lag()
	local duration = lagDuration or 0.5
	local method = lagMethod or "CPU Cycle"
	if method == "CPU Cycle" then
		pcall(function()
			setfflag("MaxMissedWorldStepsRemembered", "1")
		end)
		local start = tick()
		while tick() - start < duration do
			local a = math.random(1, 1000000) * math.random(1, 1000000)
			a = a / math.random(1, 10000)
		end
	elseif method == "OS.ClockFFlag" then
		pcall(function()
			setfflag("MaxMissedWorldStepsRemembered", "10000001000000")
		end)
		local start = os.clock()
		while os.clock() - start < duration do
		end
	end
end
function loadLagSystem()
	if lagSystemLoaded then
		return
	end
	lagSystemLoaded = true
end
function unloadLagSystem()
	if not lagSystemLoaded then
		return
	end
	lagSystemLoaded = false
	isLagActive = false
end
function checkLagState()
	local shouldLoad = lagSwitchEnabled
	if shouldLoad and not lagSystemLoaded then
		loadLagSystem()
	elseif not shouldLoad and lagSystemLoaded then
		unloadLagSystem()
	end
end
Tabs.Utility:Space()
ButtonLib.Create:Button({
	Text = "Lag Switch",
	Flag = "LagSwitch",
	Visible = false,
	Callback = function()
		isLagActive = task.spawn(lag)
	end
}).Position = UDim2.new(0.5, - 125, 0.2, 0)
LagSwitchToggle = Tabs.Utility:Toggle({
	Title = "Lag Switch",
	Flag = "LagSwitchToggle",
	Icon = "zap",
	Value = false,
	Callback = function(state)
		lagSwitchEnabled = state
		if ButtonLib and ButtonLib.LagSwitch then
			ButtonLib.LagSwitch:SetVisible(state)
		end
		checkLagState()
	end
})
LagMethodDropdown = Tabs.Utility:Dropdown({
	Title = "Lag Method",
	Flag = "LagMethodDropdown",
	Values = {
		"CPU Cycle",
		"OS.ClockFFlag"
	},
	Value = "CPU Cycle",
	Callback = function(value)
		lagMethod = value
	end
})
LagDurationInput = Tabs.Utility:Input({
	Title = "Lag Duration (seconds)",
	Flag = "LagDurationInput",
	Placeholder = "0.5",
	Value = tostring(lagDuration),
	NumbersOnly = true,
	Callback = function(text)
		local n = tonumber(text)
		if n and n > 0 then
			lagDuration = n
		end
	end
})
Players.PlayerRemoving:Connect(function(leavingPlayer)
	if leavingPlayer == Players then
		unloadLagSystem()
	end
end)
checkLagState()
Tabs.Utility:Space()
local originalGameGravity = workspace.Gravity
local CustomGravity = false
local GravityValue = workspace.Gravity
GravityToggle = Tabs.Utility:Toggle({
	Title = "Custom Gravity",
	Flag = "GravityToggle",
	Value = false,
	Callback = function(state)
		CustomGravity = state
		if state then
			workspace.Gravity = GravityValue
		else
			workspace.Gravity = originalGameGravity
		end
	end
})
ButtonLib.Create:Toggle({
	Text = "Gravity",
	Flag = "GravityToggle",
	Default = false,
	Visible = false,
	Callback = function(s)
		if GravityToggle then
			GravityToggle:Set(s)
		end
	end
}).Position = UDim2.new(0.5, - 125, 0.4, 0)
ShowGravityButtonToggle = Tabs.Utility:Toggle({
	Title = "Show Gravity Button",
	Flag = "ShowGravityButton",
	Value = false,
	Callback = function(state)
		ShowGravityButton = state
		if ButtonLib and ButtonLib.GravityToggle then
			ButtonLib.GravityToggle:SetVisible(state)
		end
	end
})
GravityInput = Tabs.Utility:Input({
	Title = "Gravity Value",
	Flag = "GravityInput",
	Placeholder = tostring(originalGameGravity),
	Value = tostring(GravityValue),
	Callback = function(text)
		local num = tonumber(text)
		if num then
			GravityValue = num
			if CustomGravity then
				workspace.Gravity = num
			end
		end
	end
})
if CustomGravity then
	workspace.Gravity = GravityValue
else
	workspace.Gravity = originalGameGravity
end
NoRender = false
NoRenderColor = Color3.fromRGB(0, 0, 0)
Tabs.Utility:Space()
local JumpPadValue = 360
local originalUse = JumpPadModule.Use
JumpPadToggle = Tabs.Utility:Toggle({
	Title = "Jump Pad Bounce Modifier",
	Flag = "JumpPadToggle",
	Value = false,
	Callback = function(state)
		if state then
			function JumpPadModule.Use(p1, p2)
				if p2 == nil or (p2 ~= Players.LocalPlayer.Character or p2:GetAttribute("JumpPadInEffect") == true) then
					return originalUse(p1, p2)
				end
				p1.Model.AnimationController:LoadAnimation(p1.Model.Animations.Use):Play(0.1)
				p1.Model.BoundingBox.Launch:Play()
				Players.LocalPlayer.Character.HumanoidRootPart:ApplyImpulse(Vector3.new(0, JumpPadValue, 0))
				p2:SetAttribute("JumpPadInEffect", true)
				task.spawn(function()
					task.wait(1.5)
					p2:SetAttribute("JumpPadInEffect", nil)
				end)
			end
		else
			JumpPadModule.Use = originalUse
		end
	end
})
JumpPadValueInput = Tabs.Utility:Input({
	Title = "Jump Value",
	Flag = "JumpPadValueInput",
	Placeholder = "0",
	Value = "360",
	NumbersOnly = true,
	Callback = function(text)
		local num = tonumber(text)
		if num then
			JumpPadValue = num
		end
	end
})
Tabs.Utility:Space()
NoRenderToggle = Tabs.Utility:Toggle({
	Title = "No Render",
	Flag = "NoRenderToggle",
	Desc = "Disable 3D rendering for performance",
	Value = false,
	Callback = function(state)
		NoRender = state
		game:GetService("RunService"):Set3dRenderingEnabled(not state)
		if state then
			local gui = Instance.new("ScreenGui")
			gui.Name = "NoRenderBackground"
			gui.DisplayOrder = - 99999
			gui.IgnoreGuiInset = true
			gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			gui.ResetOnSpawn = false
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1, 0, 1, 0)
			frame.BackgroundColor3 = NoRenderColor
			frame.BorderSizePixel = 0
			frame.Parent = gui
			gui.Parent = PlayerGui
		else
			local gui = PlayerGui:FindFirstChild("NoRenderBackground")
			if gui then
				gui:Destroy()
			end
		end
	end
})
NoRenderColorPicker = Tabs.Utility:Colorpicker({
	Title = "No Render Color",
	Flag = "NoRenderColorPicker",
	Desc = "Choose background color when No Render is enabled",
	Default = Color3.fromRGB(0, 0, 0),
	Transparency = 0,
	Callback = function(color)
		NoRenderColor = color
		if NoRender then
			local gui = PlayerGui:FindFirstChild("NoRenderBackground")
			if gui then
				local frame = gui:FindFirstChildOfClass("Frame")
				if frame then
					frame.BackgroundColor3 = color
				end
			end
		end
	end
})
RemoveTextures = false
Tabs.Utility:Space()
RemoveTexturesButton = Tabs.Utility:Button({
	Title = "Remove Textures",
	Callback = function()
		for _, part in ipairs(workspace:GetDescendants()) do
			if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") or part:IsA("WedgePart") or part:IsA("CornerWedgePart") then
				part.Material = Enum.Material.SmoothPlastic
				if part:IsA("MeshPart") and part.TextureID ~= "" then
					part.TextureID = ""
				end
				for _, texture in ipairs(part:GetChildren()) do
					if texture:IsA("Texture") then
						texture.Texture = "rbxassetid://0"
					elseif texture:IsA("Decal") then
						texture.Texture = "rbxassetid://0"
					end
				end
			end
		end
		WindUI:Notify({
			Title = "Textures Removed",
			Content = "All textures and materials have been removed",
			Duration = 3
		})
	end
})
Tabs.Utility:Button({
	Title = "Clear MaterialService",
	Desc = "Remove All Clear MaterialService Texture",
	Callback = function()
		local materialService = game:GetService("MaterialService")
		for _, child in ipairs(materialService:GetChildren()) do
			child:Destroy()
		end
		WindUI:Notify({
			Title = "MaterialService Cleared",
			Content = "All materials have been removed from MaterialService",
			Duration = 3
		})
	end
})
Tabs.Utility:Space()
LowQualityButton = Tabs.Utility:Button({
	Title = "Low Quality",
	Desc = "Disable textures, effects, and optimize graphics",
	Callback = function()
		local ToDisable = {
			Textures = true,
			VisualEffects = true,
			Parts = true,
			Particles = true,
			Sky = true
		}
		local ToEnable = {
			FullBright = false
		}
		local Stuff = {}
		for _, v in next, game:GetDescendants() do
			if ToDisable.Parts then
				if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("BasePart") then
					v.Material = Enum.Material.SmoothPlastic
					table.insert(Stuff, 1, v)
				end
			end
			if ToDisable.Particles then
				if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Explosion") or v:IsA("Sparkles") or v:IsA("Fire") then
					v.Enabled = false
					table.insert(Stuff, 1, v)
				end
			end
			if ToDisable.VisualEffects then
				if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then
					v.Enabled = false
					table.insert(Stuff, 1, v)
				end
			end
			if ToDisable.Textures then
				if v:IsA("Decal") or v:IsA("Texture") then
					v.Texture = ""
					table.insert(Stuff, 1, v)
				end
			end
			if ToDisable.Sky then
				if v:IsA("Sky") then
					v.Parent = nil
					table.insert(Stuff, 1, v)
				end
			end
		end
		if ToEnable.FullBright then
			Lighting.FogColor = Color3.fromRGB(255, 255, 255)
			Lighting.FogEnd = math.huge
			Lighting.FogStart = math.huge
			Lighting.Ambient = Color3.fromRGB(255, 255, 255)
			Lighting.Brightness = 5
			Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
			Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
			Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
			Lighting.Outlines = true
		end
	end
})
if not (LocalPlayer:GetAttribute("VIPCommandsAccess") == true) then
else
	Tabs.Utility:Section({
		Title = "VIP COMMAND",
		TextSize = 20
	})
	Tabs.Utility:Divider()
	Tabs.Utility:Button({
		Title = "VIP CMD Macro",
		Icon = "rbxassetid://107814281854748",
		Callback = function()
			EvadeMacroVIPCmdGUI()
		end
	})
	function isValidMap(mapName)
		local mapsFolder = ReplicatedStorage:FindFirstChild("Info")
		if mapsFolder then
			mapsFolder = mapsFolder:FindFirstChild("Maps")
			if mapsFolder then
				for _, map in ipairs(mapsFolder:GetChildren()) do
					if map.Name == mapName then
						return true
					end
				end
			end
		end
		return false
	end
	Tabs.Utility:Space()
	mapSettingsInput = Tabs.Utility:Input({
		Title = "Set Map Settings",
		Flag = "MapSettingsInput",
		Placeholder = "Enter map name (e.g., BrickMaze)",
		Value = "BrickMaze",
		Callback = function(value)
			SelectedMapSetting = value
		end
	})
	Tabs.Utility:Button({
		Title = "Add Map",
		Desc = "Add the specified map to rotation",
		Icon = "plus",
		Callback = function()
			local mapName = SelectedMapSetting or "BrickMaze"
			if mapName and mapName ~= "" then
				if isValidMap(mapName) then
					pcall(function()
						ReplicatedStorage.Events.Admin.VIPCommand:FireServer("AddMap", mapName)
						WindUI:Notify({
							Title = "Custom Server",
							Content = "Added map: " .. mapName,
							Duration = 3
						})
					end)
				else
					WindUI:Notify({
						Title = "Custom Server",
						Content = "Invalid map name: " .. mapName,
						Duration = 3
					})
				end
			end
		end
	})
	Tabs.Utility:Button({
		Title = "Remove Map",
		Desc = "Remove the specified map from rotation",
		Icon = "minus",
		Callback = function()
			local mapName = SelectedMapSetting or "BrickMaze"
			if mapName and mapName ~= "" then
				if isValidMap(mapName) then
					pcall(function()
						ReplicatedStorage.Events.Admin.VIPCommand:FireServer("RemoveMap", mapName)
						WindUI:Notify({
							Title = "Custom Server",
							Content = "Removed map: " .. mapName,
							Duration = 3
						})
					end)
				else
					WindUI:Notify({
						Title = "Custom Server",
						Content = "Invalid map name: " .. mapName,
						Duration = 3
					})
				end
			end
		end
	})
	Tabs.Utility:Space()
	Tabs.Utility:Button({
		Title = "Unlock VIP Commands",
		Desc = "Restore access to VIP commands if accidentally locked",
		Icon = "unlock",
		Callback = function()
			pcall(function()
				VIPMenu = PlayerGui.Shared.Popups.VIPMenu.Create.Frame
				VIPMenu.Commands.Visible = true
				VIPMenu.Locked.Visible = false
			end)
		end
	})
end
Tabs.Utility:Space()




-- teleports tab
Tabs.Teleport:Section({
	Title = "Teleports",
	TextSize = 20
})
Tabs.Teleport:Divider()
Tabs.Teleport:Space()
Tabs.Teleport:Button({
	Title = "Teleport to Spawn",
	Desc = "Teleport to a random spawn location",
	Icon = "home",
	Callback = function()
		teleportToRandomSpawn(Vector3.new(0, 3, 0))
	end
})
Tabs.Teleport:Space()
Tabs.Teleport:Button({
	Title = "Teleport to Random Player",
	Desc = "Teleport to a random online Players",
	Icon = "users",
	Callback = function()
		teleportToRandomPlayer(Vector3.new(0, 3, 0))
	end
})
Tabs.Teleport:Space()
Tabs.Teleport:Button({
	Title = "Teleport to Downed Player",
	Desc = "Teleport to a random Downed Players",
	Icon = "heart",
	Callback = function()
		teleportToRandomDowned(Vector3.new(0, 3, 0))
	end
})
local playerList = {}
Tabs.Teleport:Space()
PlayerDropdown = Tabs.Teleport:Dropdown({
	Title = "Select Player or NPC",
	Flag = "PlayerDropdown",
	Values = {
		{
			Title = "No players found",
			Desc = "",
			Icon = "user"
		}
	},
	Value = "No players found",
	Callback = function(selectedOption)
	end
})
function getNPCIcon(model)
	local hrp = model:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return nil
	end
	local billboard = hrp:FindFirstChild("BillboardGui")
	if not billboard then
		return nil
	end
	local icon = billboard:FindFirstChild("Icon")
	if not icon then
		return nil
	end
	if icon:IsA("ImageLabel") or icon:IsA("ImageButton") then
		return icon.Image
	end
	return nil
end
function findWorkspaceCharacterForPlayer(plr)
	local playersFolder = workspace:FindFirstChild("Players")
	if not playersFolder then
		return nil
	end
	local byName = playersFolder:FindFirstChild(plr.Name)
	if byName and byName:IsA("Model") then
		return byName
	end
	for _, model in ipairs(playersFolder:GetChildren()) do
		if model:IsA("Model") then
			local attrName = model:GetAttribute("Name")
			local attrTag = model:GetAttribute("Tag")
			local userId = model:GetAttribute("UserId") or model:GetAttribute("PlayerUserId")
			if attrName == plr.Name or attrName == plr.DisplayName then
				return model
			end
			if attrTag == plr.Name or attrTag == plr.DisplayName then
				return model
			end
			if typeof(userId) == "number" and userId == plr.UserId then
				return model
			end
			if model.Name == tostring(plr.UserId) then
				return model
			end
		end
	end
	if plr.Character and plr.Character.Parent == playersFolder then
		return plr.Character
	end
	return nil
end
function getModelChildIndex(model)
	local parent = model and model.Parent
	if not parent then
		return 0
	end
	for i, child in ipairs(parent:GetChildren()) do
		if child == model then
			return i
		end
	end
	return 0
end
function updatePlayerList()
	playerList = {}
	local dropdownValues = {}
	local listedModels = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local model = findWorkspaceCharacterForPlayer(plr)
			local childIndex = model and getModelChildIndex(model) or 0
			local entry = {
				player = plr,
				model = model,
				kind = "player",
				childIndex = childIndex
			}
			table.insert(playerList, entry)
			local title = plr.DisplayName
			if model and childIndex > 0 then
				title = title .. " [ChildIndex:" .. tostring(childIndex) .. "]"
			end
			local desc
			local iconUrl = "user"
			local ok, thumb = pcall(function()
				return Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
			end)
			if ok and thumb then
				iconUrl = thumb
			end
			if not model then
				desc = "No Character Found | @" .. plr.Name
			else
				local team = model:GetAttribute("Team") or "Unknown"
				desc = "Team: " .. tostring(team) .. " | @" .. plr.Name .. " | Index:" .. tostring(childIndex)
				listedModels[model] = true
			end
			table.insert(dropdownValues, {
				Title = title,
				Desc = desc,
				Icon = iconUrl
			})
		end
	end
	local playersFolder = workspace:FindFirstChild("Players")
	if playersFolder then
		local myChar = LocalPlayer.Character
		local myModel = findWorkspaceCharacterForPlayer(LocalPlayer)
		if myModel then
			listedModels[myModel] = true
		end
		if myChar then
			listedModels[myChar] = true
		end
		for index, model in ipairs(playersFolder:GetChildren()) do
			if model:IsA("Model") and not listedModels[model] then
				local attrName = model:GetAttribute("Name")
				local attrTag = model:GetAttribute("Tag")
				local userId = model:GetAttribute("UserId") or model:GetAttribute("PlayerUserId")
				local isMe = (model.Name == LocalPlayer.Name) or (attrName == LocalPlayer.Name) or (attrName == LocalPlayer.DisplayName) or (attrTag == LocalPlayer.Name) or (typeof(userId) == "number" and userId == LocalPlayer.UserId) or (model.Name == tostring(LocalPlayer.UserId)) or (model == myChar) or (model == myModel)
				if not isMe then
					local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
					if hrp then
						local team = model:GetAttribute("Team") or "Unknown"
						local displayName = model:GetAttribute("Name") or model.Name
						local childIndex = index
						local iconUrl = "user"
						if tostring(team) == "NPC" then
							local nbIcon = getNPCIcon(model)
							if nbIcon and nbIcon ~= "" then
								iconUrl = nbIcon
							end
						else
							if typeof(userId) == "number" then
								local ok, thumb = pcall(function()
									return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
								end)
								if ok and thumb then
									iconUrl = thumb
								end
							end
							if iconUrl == "user" then
								local nbIcon = getNPCIcon(model)
								if nbIcon and nbIcon ~= "" then
									iconUrl = nbIcon
								end
							end
						end
						table.insert(playerList, {
							player = nil,
							model = model,
							kind = "character",
							childIndex = childIndex
						})
						table.insert(dropdownValues, {
							Title = tostring(displayName) .. " [ChildIndex:" .. tostring(childIndex) .. "]",
							Desc = "Team: " .. tostring(team) .. " | " .. model.Name .. " | Index:" .. tostring(childIndex),
							Icon = iconUrl
						})
						listedModels[model] = true
					end
				end
			end
		end
	end
	if # dropdownValues == 0 then
		dropdownValues = {
			{
				Title = "No players found",
				Desc = "",
				Icon = "user"
			}
		}
	end
	PlayerDropdown:Refresh(dropdownValues, true)
end
Tabs.Teleport:Button({
	Title = "Refresh Player List",
	Desc = "Refresh Player and NPC list",
	Icon = "refresh-cw",
	Callback = function()
		updatePlayerList()
	end
})
Tabs.Teleport:Space()
Tabs.Teleport:Button({
	Title = "Teleport to Selected",
	Desc = "Teleport to selected player or NPC",
	Icon = "user",
	Callback = function()
		local selectedOption = PlayerDropdown.Value
		if not selectedOption or selectedOption.Title == "No players found" then
			return
		end
		if selectedOption.Desc and string.find(selectedOption.Desc, "No Character Found", 1, true) then
			return
		end
		local selectedIndex = nil
		local indexMatch = string.match(selectedOption.Title or "", "%[ChildIndex:(%d+)%]")
		if indexMatch then
			selectedIndex = tonumber(indexMatch)
		end
		for _, entry in ipairs(playerList) do
			local title
			if entry.player then
				title = entry.player.DisplayName
				if entry.model and entry.childIndex and entry.childIndex > 0 then
					title = title .. " [ChildIndex:" .. tostring(entry.childIndex) .. "]"
				end
			elseif entry.model then
				local displayName = entry.model:GetAttribute("Name") or entry.model.Name
				title = tostring(displayName) .. " [ChildIndex:" .. tostring(entry.childIndex or 0) .. "]"
			end
			local titleMatch = tostring(title) == selectedOption.Title
			local indexMatchOk = selectedIndex and entry.childIndex == selectedIndex
			if titleMatch or (indexMatchOk and entry.model) then
				local model = entry.model
				if model and (not selectedIndex or entry.childIndex == selectedIndex) then
					local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
					if hrp then
						teleportToCFrame(hrp.CFrame + Vector3.new(0, 3, 0))
					end
					return
				elseif entry.player and entry.player.Character then
					local hrp = entry.player.Character:FindFirstChild("HumanoidRootPart")
					if hrp then
						teleportToCFrame(hrp.CFrame + Vector3.new(0, 3, 0))
					end
					return
				end
			end
		end
		if selectedIndex then
			local playersFolder = workspace:FindFirstChild("Players")
			if playersFolder then
				local children = playersFolder:GetChildren()
				local model = children[selectedIndex]
				if model and model:IsA("Model") then
					local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
					if hrp then
						teleportToCFrame(hrp.CFrame + Vector3.new(0, 3, 0))
					end
				end
			end
		end
	end
})
Tabs.Teleport:Space()
Tabs.Teleport:Button({
	Title = "Teleport to Ticket",
	Desc = "Teleport to a random ticket",
	Icon = "ticket",
	Callback = function()
		teleportToRandomTicket(Vector3.new(0, 3, 0))
	end
})
Tabs.Teleport:Space()
Tabs.Teleport:Button({
	Title = "Teleport to NPC",
	Desc = "Teleport to a random NPC",
	Icon = "ghost",
	Callback = function()
		teleportToRandomNPC(Vector3.new(0, 10, 0))
	end
})
Tabs.Teleport:Space()
Tabs.Teleport:Button({
	Title = "Teleport to SecurityPart",
	Icon = "shield",
	Callback = function()
		teleportToSecurityPart(Vector3.new(0, 3, 0))
	end
})
local objectives = {}
local objectiveDropdown
local refreshButton
local lastUpdateTime = 0
local updateCooldown = 1
function updateObjectiveDropdown()
	if tick() - lastUpdateTime < updateCooldown then
		return
	end
	lastUpdateTime = tick()
	objectives = getObjectives()
	if not objectiveDropdown then
		return
	end
	if # objectives > 0 then
		local objectiveNames = {}
		for _, obj in ipairs(objectives) do
			if obj and obj.Name then
				table.insert(objectiveNames, obj.Name)
			end
		end
		if # objectiveNames > 0 then
			objectiveDropdown:Refresh(objectiveNames, objectiveNames[1])
		else
			objectiveDropdown:Refresh({
				"No valid objectives"
			}, "No valid objectives")
		end
	else
		objectiveDropdown:Refresh({
			"No objectives found"
		}, "No objectives found")
	end
end
Tabs.Teleport:Space()
objectiveDropdown = Tabs.Teleport:Dropdown({
	Title = "Select Objective",
	Flag = "objectiveDropdown",
	Values = {
		""
	},
	Value = "",
	Enabled = true,
	Callback = function(value)
	end
})
teleportButton = Tabs.Teleport:Button({
	Title = "Teleport to Objective",
	Icon = "navigation",
	Enabled = false,
	Callback = function()
		local selectedName = objectiveDropdown.Value
		if selectedName == "No objectives found" or selectedName == "" then
			return
		end
		teleportToObjective(selectedName, Vector3.new(0, 5, 0))
	end
})
refreshButton = Tabs.Teleport:Button({
	Title = "Refresh Objectives",
	Icon = "refresh-cw",
	Callback = function()
		updateObjectiveDropdown()
	end
})
local loopupdateObjectiveDropdown
local lastRoundStatusObj = ServerStateRegistryService.Registry.RoundStatus
loopupdateObjectiveDropdown = RunService.Heartbeat:Connect(function()
	if not objectiveDropdown or not Tabs.Teleport then
		if loopupdateObjectiveDropdown then
			loopupdateObjectiveDropdown:Disconnect()
			loopupdateObjectiveDropdown = nil
		end
		print("UI Not found: Successfully stopped heartbeat loop.")
		return
	end
	local success, err = pcall(function()
		local currentRoundStatus = ServerStateRegistryService.Registry.RoundStatus
		if currentRoundStatus ~= lastRoundStatusObj then
			lastRoundStatusObj = currentRoundStatus
			task.wait(1)
			updateObjectiveDropdown()
		end
	end)
	if not success then
		task.spawn(function()
			error("⚠ Error 404: Can not Auto Update Objective Dropdown Because You closed wind ui. Auto disconnecting...")
		end)
		if loopupdateObjectiveDropdown then
			loopupdateObjectiveDropdown:Disconnect()
			loopupdateObjectiveDropdown = nil
			print("Successfully Stopped loop")
		end
	end
end)
Tabs.Teleport:Section({
	Title = "Teleport to Coordinates",
	TextSize = 20
})
local teleInputValue = ""
Tabs.Teleport:Input({
	Title = "Target Coordinates",
	Flag = "CoordTeleInput",
	Placeholder = "X Y Z",
	Value = "",
	Callback = function(value)
		teleInputValue = value
	end
})
Tabs.Teleport:Button({
	Title = "Teleport NOW!!! >:(",
	Icon = "target",
	Callback = function()
		function parseCoordinate(token, current)
			if not token or token == "" then
				return nil
			end
			token = token:gsub("%s+", "")
			local num = tonumber(token)
			if num then
				return num
			end
			if token:sub(1, 1) == "~" then
				local rest = token:sub(2)
				if rest == "" then
					return current
				end
				local op = rest:sub(1, 1)
				local valuePart = rest:sub(2)
				if op == "+" or op == "-" or op == "*" then
					local val = tonumber(valuePart)
					if val then
						if op == "+" then
							return current + val
						elseif op == "-" then
							return current - val
						elseif op == "*" then
							return current * val
						end
					end
				else
					local val = tonumber(rest)
					if val then
						return current + val
					end
				end
			end
			return nil
		end
		local tokens = {}
		for token in string.gmatch(teleInputValue, "%S+") do
			table.insert(tokens, token)
		end
		if # tokens < 3 then
			WindUI:Notify({
				Title = "Invalid Input",
				Content = "Please enter three values for X, Y, Z separated by spaces",
				Duration = 3
			})
			return
		end
		local character = LocalPlayer.Character
		if not character then
			WindUI:Notify({
				Title = "Error",
				Content = "Character not found",
				Duration = 3
			})
			return
		end
		local root = character:FindFirstChild("HumanoidRootPart")
		if not root then
			WindUI:Notify({
				Title = "Error",
				Content = "HumanoidRootPart not found",
				Duration = 3
			})
			return
		end
		local currentPos = root.Position
		local x = parseCoordinate(tokens[1], currentPos.X)
		local y = parseCoordinate(tokens[2], currentPos.Y)
		local z = parseCoordinate(tokens[3], currentPos.Z)
		if x == nil or y == nil or z == nil then
			WindUI:Notify({
				Title = "Invalid Expression",
				Content = "One or more coordinates could not be parsed",
				Duration = 3
			})
			return
		end
		root.CFrame = CFrame.new(x, y, z)
	end
})
LoadAutoShop = Tabs.Shop:Button({
	Title = "Load Shop Automation",
	Callback = function()
		local success, err = pcall(function()
			LoadAutoShop:Destroy()
			local Purchase = ReplicatedStorage.Shared.UserData.Events.Requests.Purchase
			local PurchaseBattlepassItem = ReplicatedStorage.Shared.UserData.Events.Requests.PurchaseBattlepassItem
			local GetDailyShop = ReplicatedStorage.Shared.UserData.Events.Functions.GetDailyShop
			function safeCall(fn, ...)
				local ok, result = pcall(fn, ...)
				if not ok then
					if not string.find(result, "cannot access 'Instance'") then
						warn("Error in safeCall:", result)
					end
					return nil
				end
				return result
			end
			function getOwnershipType(itemId)
				local config = safeCall(ItemRegistry.GetConfig, ItemRegistry, itemId)
				if config and config.PurchaseInfo and config.PurchaseInfo.OwnershipType then
					return config.PurchaseInfo.OwnershipType
				end
				return "Single"
			end
			function checkOwnership(itemId)
				local ownershipType = getOwnershipType(itemId)
				if ownershipType == "Multiple" then
					return "multiple"
				end
				local ownedIds = safeCall(UseInventory.OwnedIds, UseInventory) or {}
				for _, ownedId in ipairs(ownedIds) do
					if ownedId == itemId then
						return "owned"
					end
				end
				return "notowned"
			end
			function getBattlepassItemPrice(itemId)
				for seasonId, seasonData in pairs(Config) do
					if seasonData.Tiers then
						for tierIndex, tierData in pairs(seasonData.Tiers) do
							if tierData.items then
								for _, item in ipairs(tierData.items) do
									local id = item.itemId or item.id
									if id == itemId then
										return item.price or item.cost or 0
									end
								end
							end
						end
					end
				end
				return 0
			end
			function getBattlepassItemTierInfo(itemId)
				for seasonId, seasonData in pairs(Config) do
					if seasonData.Tiers then
						for tierIndex, tierData in pairs(seasonData.Tiers) do
							if tierData.items then
								for _, item in ipairs(tierData.items) do
									local id = item.itemId or item.id
									if id == itemId then
										return tierIndex, tierData.unlocked, tierData.timeOpen
									end
								end
							end
						end
					end
				end
				return nil, nil, nil
			end
			local loops = {}
			function startLoop(key, purchaseFunc)
				if loops[key] then
					loops[key]()
					loops[key] = nil
				end
				local running = true
				loops[key] = function()
					running = false
				end
				task.spawn(function()
					while running do
						local ok, err = pcall(purchaseFunc)
						if not ok then
							if not string.find(err, "cannot access 'Instance'") then
								warn("Error in loop " .. key .. ":", err)
							end
						end
						task.wait(0.4)
					end
				end)
			end
			function stopLoop(key)
				if loops[key] then
					loops[key]()
					loops[key] = nil
				end
			end
			local ShopTab = Tabs.Shop
			local DailyShopSection = ShopTab:Section({
				Title = "Daily Shop",
				Side = "Left"
			})
			local dailySlotData = {}
			local selectedDailyItemIds = {}
			local dailyItemsCache = {}
			function fetchDailyShopItems()
				if not GetDailyShop or not GetDailyShop:IsA("RemoteFunction") then
					warn("GetDailyShop is not available")
					return {}
				end
				local result = safeCall(function()
					return GetDailyShop:InvokeServer()
				end)
				if not result or not result.slots then
					warn("Daily shop fetch returned no data")
					dailySlotData = {}
					return {}
				end
				dailySlotData = {}
				local itemIds = {}
				for slotNum, slotData in pairs(result.slots) do
					local itemId = slotData.itemId
					if itemId then
						dailySlotData[itemId] = {
							slot = slotNum,
							endsAt = slotData.endsAt,
							remaining = slotData.endsAt and (slotData.endsAt - os.time()) or 0
						}
						if not table.find(itemIds, itemId) then
							table.insert(itemIds, itemId)
						end
					end
				end
				dailyItemsCache = itemIds
				return itemIds
			end
			function getDailyShopItems()
				return dailyItemsCache
			end
			function buildDailyItemOptions()
				local items = getDailyShopItems()
				if # items == 0 then
					return {
						{
							Title = "No daily items available",
							Desc = "Check back later or refresh",
							Value = "none"
						}
					}
				end
				local options = {}
				for _, itemId in ipairs(items) do
					local config = ItemRegistry.GetConfig(itemId)
					if not config then
						warn("Daily shop item not found in registry:", itemId)
						table.insert(options, {
							Title = "Unknown Item " .. tostring(itemId),
							Desc = "Missing config",
							Value = tostring(itemId)
						})
						continue
					end
					local name = "Unknown"
					if config.AppearanceInfo and config.AppearanceInfo.Name then
						name = config.AppearanceInfo.Name
					elseif config.Name then
						name = config.Name
					end
					local price = "?"
					local currencyType = ""
					if config.PurchaseInfo then
						price = config.PurchaseInfo.Price or "?"
						currencyType = config.PurchaseInfo.Currency or ""
					end
					local desc = "No description"
					if config.AppearanceInfo and config.AppearanceInfo.Desc then
						desc = config.AppearanceInfo.Desc
					end
					local ownershipType = "Single"
					if config and config.PurchaseInfo and config.PurchaseInfo.OwnershipType then
						ownershipType = config.PurchaseInfo.OwnershipType
					end
					local statusText
					if ownershipType == "Multiple" then
						statusText = "MULTIPLE"
					else
						local status = checkOwnership(itemId)
						statusText = status == "owned" and "OWNED" or (status == "multiple" and "MULTIPLE" or "NOT OWNED")
					end
					local slotInfo = dailySlotData[itemId]
					local timeStr = ""
					if slotInfo and slotInfo.remaining and slotInfo.remaining > 0 then
						local h = math.floor(slotInfo.remaining / 3600)
						local m = math.floor((slotInfo.remaining % 3600) / 60)
						local s = slotInfo.remaining % 60
						timeStr = string.format(" | %02dh %02dm %02ds", h, m, s)
					else
						timeStr = " | REFRESHED"
					end
					table.insert(options, {
						Title = name,
						Desc = string.format("Price: %s %s | Status: %s | %s%s", price, currencyType, statusText, desc, timeStr),
						Value = tostring(itemId)
					})
				end
				return options
			end
			local DailyItemDropdown
			local RefreshDailyBtn
			local DailyAutoBuyAll
			local DailyAutoBuySelected
			function buildDailyUI()
				DailyItemDropdown = DailyShopSection:Dropdown({
					Title = "Select Daily Items",
					SearchBarEnabled = true,
					Values = buildDailyItemOptions(),
					Multi = true,
					AllowNone = true,
					Callback = function(selected)
						selectedDailyItemIds = {}
						if selected then
							for _, v in ipairs(selected) do
								if v.Value and v.Value ~= "none" then
									table.insert(selectedDailyItemIds, v.Value)
								end
							end
						end
					end
				})
				RefreshDailyBtn = DailyShopSection:Button({
					Title = "Refresh Daily Shop",
					Callback = function()
						fetchDailyShopItems()
						refreshDailyDropdown()
					end
				})
				DailyAutoBuyAll = DailyShopSection:Toggle({
					Title = "Auto Buy All Daily Items",
					Value = false,
					Callback = function(state)
						if state then
							startLoop("daily_all", function()
								local items = getDailyShopItems()
								for _, id in ipairs(items) do
									local config = ItemRegistry.GetConfig(id)
									if config and config.PurchaseInfo then
										local price = config.PurchaseInfo.Price
										local currencyType = config.PurchaseInfo.Currency
										if currencyType and price then
											local allCurrencies = Currency.All()
											local balance = allCurrencies and allCurrencies[currencyType]
											if balance and balance >= price then
												local ownership = checkOwnership(id)
												if ownership ~= "owned" or getOwnershipType(id) == "Multiple" then
													safeCall(Purchase.FireServer, Purchase, id, 1)
												end
											end
										end
									end
								end
							end)
						else
							stopLoop("daily_all")
						end
					end
				})
				DailyAutoBuySelected = DailyShopSection:Toggle({
					Title = "Auto Buy Selected",
					Value = false,
					Callback = function(state)
						if state then
							startLoop("daily_selected", function()
								for _, id in ipairs(selectedDailyItemIds) do
									local numId = tonumber(id)
									if numId then
										local config = ItemRegistry.GetConfig(numId)
										if config and config.PurchaseInfo then
											local price = config.PurchaseInfo.Price
											local currencyType = config.PurchaseInfo.Currency
											if currencyType and price then
												local allCurrencies = Currency.All()
												local balance = allCurrencies and allCurrencies[currencyType]
												if balance and balance >= price then
													local ownership = checkOwnership(numId)
													if ownership ~= "owned" or getOwnershipType(numId) == "Multiple" then
														safeCall(Purchase.FireServer, Purchase, numId, 1)
													end
												end
											end
										end
									end
								end
							end)
						else
							stopLoop("daily_selected")
						end
					end
				})
			end
			local uiOk, uiErr = pcall(buildDailyUI)
			if not uiOk then
				warn("Failed to create Daily Shop UI:", uiErr)
				DailyShopSection:Label({
					Title = "Error loading Daily Shop UI",
					Desc = "Check console for details"
				})
			end
			function refreshDailyDropdown()
				local newOptions = buildDailyItemOptions()
				local validSelected = {}
				local valueSet = {}
				for _, opt in ipairs(newOptions) do
					valueSet[opt.Value] = true
				end
				for _, val in ipairs(selectedDailyItemIds) do
					if valueSet[val] then
						table.insert(validSelected, val)
					end
				end
				if DailyItemDropdown then
					safeCall(DailyItemDropdown.Refresh, DailyItemDropdown, newOptions, validSelected)
				end
			end
			local TokenShopSection = ShopTab:Section({
				Title = "Token Shop",
				Side = "Right"
			})
			local tokenSections = {}
			local multipleSections = {}
			function buildTokenShopData()
				local byType = {}
				local multiByType = {}
				local allIds = ItemRegistry.GetAll()
				for id, _ in pairs(allIds) do
					local config = ItemRegistry.GetConfig(id)
					if config and config.PurchaseInfo then
						local purchase = config.PurchaseInfo
						if purchase.Currency == "Tokens" and purchase.AppearsIn == "Shop" then
							local slotType = "Misc"
							if config.EquipInfo and config.EquipInfo.SlotType then
								slotType = config.EquipInfo.SlotType
							end
							local ownership = purchase.OwnershipType or "Single"
							if ownership == "Multiple" then
								if not multiByType[slotType] then
									multiByType[slotType] = {}
								end
								table.insert(multiByType[slotType], id)
							else
								if not byType[slotType] then
									byType[slotType] = {}
								end
								table.insert(byType[slotType], id)
							end
						end
					end
				end
				return byType, multiByType
			end
			function buildTokenItemOptions(items, amount)
				amount = amount or 1
				if # items == 0 then
					return {
						{
							Title = "No token items",
							Desc = "No items available in this category",
							Value = "none"
						}
					}
				end
				local opts = {}
				for _, itemId in ipairs(items) do
					local config = ItemRegistry.GetConfig(itemId)
					local name = "Unknown"
					if config and config.AppearanceInfo and config.AppearanceInfo.Name then
						name = config.AppearanceInfo.Name
					elseif config and config.Name then
						name = config.Name
					end
					local price = 0
					local currencyType = ""
					if config and config.PurchaseInfo then
						price = config.PurchaseInfo.Price or 0
						currencyType = config.PurchaseInfo.Currency or ""
					end
					local desc = "No description"
					if config and config.AppearanceInfo and config.AppearanceInfo.Desc then
						desc = config.AppearanceInfo.Desc
					end
					local ownershipType = "Single"
					if config and config.PurchaseInfo and config.PurchaseInfo.OwnershipType then
						ownershipType = config.PurchaseInfo.OwnershipType
					end
					local statusText
					if ownershipType == "Multiple" then
						statusText = "MULTIPLE"
					else
						local status = checkOwnership(itemId)
						statusText = status == "owned" and "OWNED" or (status == "multiple" and "MULTIPLE" or "NOT OWNED")
					end
					local displayPrice = price and (price * amount) or "?"
					local displayCurrency = currencyType or ""
					table.insert(opts, {
						Title = name,
						Desc = string.format("Price: %s %s | Status: %s | %s", displayPrice, displayCurrency, statusText, desc),
						Value = tostring(itemId)
					})
				end
				return opts
			end
			function createTokenDropdown(section, items, selectedStorage, amount)
				amount = amount or 1
				local dropdown = section:Dropdown({
					Title = "Select Item",
					SearchBarEnabled = true,
					Values = buildTokenItemOptions(items, amount),
					Multi = true,
					AllowNone = true,
					Callback = function(selected)
						for i = # selectedStorage, 1, - 1 do
							selectedStorage[i] = nil
						end
						if selected then
							for _, v in ipairs(selected) do
								if v.Value and v.Value ~= "none" then
									table.insert(selectedStorage, v.Value)
								end
							end
						end
					end
				})
				return dropdown
			end
			function refreshTokenDropdown(dropdown, items, selectedValues, amount)
				amount = amount or 1
				local newOptions = buildTokenItemOptions(items, amount)
				local validSelected = {}
				local valueSet = {}
				for _, opt in ipairs(newOptions) do
					valueSet[opt.Value] = true
				end
				for _, val in ipairs(selectedValues) do
					if valueSet[val] then
						table.insert(validSelected, val)
					end
				end
				safeCall(dropdown.Refresh, dropdown, newOptions, validSelected)
			end
			local normalTypes, multiTypes = buildTokenShopData()
			for typeName, itemIds in pairs(normalTypes) do
				local section = TokenShopSection:Section({
					Title = typeName .. " (" .. # itemIds .. " items)",
					Side = "Left",
					TextSize = 16
				})
				local selectedItems = {}
				local itemDropdown = createTokenDropdown(section, itemIds, selectedItems)
				local autoBuySelected = section:Toggle({
					Title = "Auto Buy Selected Item",
					Value = false,
					Callback = function(state)
						if state then
							startLoop("token_" .. typeName .. "_selected", function()
								for _, id in ipairs(selectedItems) do
									local numId = tonumber(id)
									if numId then
										local config = ItemRegistry.GetConfig(numId)
										if config and config.PurchaseInfo then
											local price = config.PurchaseInfo.Price
											local currencyType = config.PurchaseInfo.Currency
											if currencyType and price then
												local allCurrencies = Currency.All()
												local balance = allCurrencies and allCurrencies[currencyType]
												if balance and balance >= price then
													local ownership = checkOwnership(numId)
													if ownership ~= "owned" or getOwnershipType(numId) == "Multiple" then
														safeCall(Purchase.FireServer, Purchase, numId, 1)
													end
												end
											end
										end
									end
								end
							end)
						else
							stopLoop("token_" .. typeName .. "_selected")
						end
					end
				})
				local autoBuyAll = section:Toggle({
					Title = "Auto Buy All Items",
					Value = false,
					Callback = function(state)
						if state then
							startLoop("token_" .. typeName .. "_all", function()
								for _, id in ipairs(itemIds) do
									local config = ItemRegistry.GetConfig(id)
									if config and config.PurchaseInfo then
										local price = config.PurchaseInfo.Price
										local currencyType = config.PurchaseInfo.Currency
										if currencyType and price then
											local allCurrencies = Currency.All()
											local balance = allCurrencies and allCurrencies[currencyType]
											if balance and balance >= price then
												local ownership = checkOwnership(id)
												if ownership ~= "owned" or getOwnershipType(id) == "Multiple" then
													safeCall(Purchase.FireServer, Purchase, id, 1)
												end
											end
										end
									end
								end
							end)
						else
							stopLoop("token_" .. typeName .. "_all")
						end
					end
				})
				tokenSections[typeName] = {
					dropdown = itemDropdown,
					autoBuySelected = autoBuySelected,
					autoBuyAll = autoBuyAll,
					items = itemIds,
					selected = selectedItems
				}
			end
			if next(multiTypes) then
				local MultiSection = TokenShopSection:Section({
					Title = "Multiple Type Items",
					Side = "Right",
					TextSize = 16
				})
				for typeName, itemIds in pairs(multiTypes) do
					local typeSec = MultiSection:Section({
						Title = typeName .. " (" .. # itemIds .. " items)",
						Side = "Left",
						TextSize = 14
					})
					local selectedItems = {}
					local currentAmount = 1
					local itemDropdown = createTokenDropdown(typeSec, itemIds, selectedItems, currentAmount)
					local amountInput = typeSec:Input({
						Title = "Auto Buy Amount",
						Desc = "Number of times to buy",
						Placeholder = "1",
						Value = "1",
						Callback = function(text)
							local newAmount = tonumber(text) or 1
							if newAmount < 1 then
								newAmount = 1
							end
							currentAmount = newAmount
							refreshTokenDropdown(itemDropdown, itemIds, selectedItems, currentAmount)
						end
					})
					local autoBuySelected = typeSec:Toggle({
						Title = "Auto Buy Selected Item",
						Value = false,
						Callback = function(state)
							if state then
								startLoop("multi_" .. typeName .. "_selected", function()
									for _, id in ipairs(selectedItems) do
										local numId = tonumber(id)
										local lookupId = numId or id
										local config = ItemRegistry.GetConfig(lookupId)
										if config and config.PurchaseInfo then
											local price = config.PurchaseInfo.Price
											local currencyType = config.PurchaseInfo.Currency
											if currencyType and price then
												local totalCost = price * currentAmount
												local allCurrencies = Currency.All()
												local balance = allCurrencies and allCurrencies[currencyType]
												if balance and balance >= totalCost then
													safeCall(Purchase.FireServer, Purchase, lookupId, currentAmount)
												end
											end
										end
									end
								end)
							else
								stopLoop("multi_" .. typeName .. "_selected")
							end
						end
					})
					local autoBuyAll = typeSec:Toggle({
						Title = "Auto Buy All Items",
						Value = false,
						Callback = function(state)
							if state then
								startLoop("multi_" .. typeName .. "_all", function()
									for _, id in ipairs(itemIds) do
										local config = ItemRegistry.GetConfig(id)
										if config and config.PurchaseInfo then
											local price = config.PurchaseInfo.Price
											local currencyType = config.PurchaseInfo.Currency
											if currencyType and price then
												local totalCost = price * currentAmount
												local allCurrencies = Currency.All()
												local balance = allCurrencies and allCurrencies[currencyType]
												if balance and balance >= totalCost then
													safeCall(Purchase.FireServer, Purchase, id, currentAmount)
												end
											end
										end
									end
								end)
							else
								stopLoop("multi_" .. typeName .. "_all")
							end
						end
					})
					multipleSections[typeName] = {
						dropdown = itemDropdown,
						amountInput = amountInput,
						autoBuySelected = autoBuySelected,
						autoBuyAll = autoBuyAll,
						items = itemIds,
						selected = selectedItems,
						getAmount = function()
							return currentAmount
						end
					}
				end
			end
			local EventShopSection = ShopTab:Section({
				Title = "Event Shop",
				Side = "Left"
			})
			local selectedEventItemIds = {}
			function buildEventItemOptions()
				local options = {}
				local tiers = safeCall(useEvent.GetTiers, useEvent) or {}
				for _, tier in ipairs(tiers) do
					if tier.items then
						for _, item in ipairs(tier.items) do
							local itemId
							if type(item) == "table" then
								itemId = item.itemId or item.id
							else
								itemId = item
							end
							if itemId then
								local config = ItemRegistry.GetConfig(itemId)
								local name = "Unknown"
								if config and config.AppearanceInfo and config.AppearanceInfo.Name then
									name = config.AppearanceInfo.Name
								elseif config and config.Name then
									name = config.Name
								end
								local desc = "No description"
								if config and config.AppearanceInfo and config.AppearanceInfo.Desc then
									desc = config.AppearanceInfo.Desc
								end
								local status = checkOwnership(itemId)
								local statusText = status == "owned" and "OWNED" or (status == "multiple" and "MULTIPLE" or "NOT OWNED")
								local tierInfo = "Tier " .. tier.index
								local opens = tier.timeOpen and "Open" or "Locked"
								local price = getBattlepassItemPrice(itemId)
								local priceText = price > 0 and ("Tickets: " .. price) or "Free"
								table.insert(options, {
									Title = name,
									Desc = string.format("%s | %s | Status: %s | %s", tierInfo, priceText, statusText, opens),
									Value = tostring(itemId)
								})
							end
						end
					end
				end
				return options
			end
			local EventItemDropdown = EventShopSection:Dropdown({
				Title = "Select Battle Pass Item",
				Values = buildEventItemOptions(),
				SearchBarEnabled = true,
				Multi = true,
				AllowNone = true,
				Callback = function(selected)
					selectedEventItemIds = {}
					if selected then
						for _, v in ipairs(selected) do
							if v.Value then
								table.insert(selectedEventItemIds, v.Value)
							end
						end
					end
				end
			})
			local EventAutoBuySelected = EventShopSection:Toggle({
				Title = "Auto Buy Selected Item",
				Value = false,
				Callback = function(state)
					if state then
						startLoop("event_selected", function()
							for _, id in ipairs(selectedEventItemIds) do
								local numId = tonumber(id)
								if numId then
									local price = getBattlepassItemPrice(numId)
									local balance = safeCall(Currency.Balance, Currency, "Tickets")
									if balance and balance >= price then
										local ownership = checkOwnership(numId)
										if ownership ~= "owned" or getOwnershipType(numId) == "Multiple" then
											local tierIndex, unlocked, timeOpen = getBattlepassItemTierInfo(numId)
											if unlocked and timeOpen then
												safeCall(PurchaseBattlepassItem.FireServer, PurchaseBattlepassItem, numId)
											end
										end
									end
								end
							end
						end)
					else
						stopLoop("event_selected")
					end
				end
			})
			local EventAutoBuyAll = EventShopSection:Toggle({
				Title = "Auto Buy All Items",
				Value = false,
				Callback = function(state)
					if state then
						startLoop("event_all", function()
							local allIds = {}
							local tiers = safeCall(useEvent.GetTiers, useEvent) or {}
							for _, tier in ipairs(tiers) do
								if tier.items then
									for _, item in ipairs(tier.items) do
										local itemId
										if type(item) == "table" then
											itemId = item.itemId or item.id
										else
											itemId = item
										end
										if itemId then
											table.insert(allIds, itemId)
										end
									end
								end
							end
							for _, id in ipairs(allIds) do
								local price = getBattlepassItemPrice(id)
								local balance = safeCall(Currency.Balance, Currency, "Tickets")
								if balance and balance >= price then
									local ownership = checkOwnership(id)
									if ownership ~= "owned" or getOwnershipType(id) == "Multiple" then
										local tierIndex, unlocked, timeOpen = getBattlepassItemTierInfo(id)
										if unlocked and timeOpen then
											safeCall(PurchaseBattlepassItem.FireServer, PurchaseBattlepassItem, id)
										end
									end
								end
							end
						end)
					else
						stopLoop("event_all")
					end
				end
			})
			function refreshTokenDropdowns()
				for typeName, data in pairs(tokenSections) do
					local newOptions = buildTokenItemOptions(data.items)
					local validSelected = {}
					local valueSet = {}
					for _, opt in ipairs(newOptions) do
						valueSet[opt.Value] = true
					end
					for _, val in ipairs(data.selected) do
						if valueSet[val] then
							table.insert(validSelected, val)
						end
					end
					safeCall(data.dropdown.Refresh, data.dropdown, newOptions, validSelected)
				end
				for typeName, data in pairs(multipleSections) do
					local amt = data.getAmount()
					local newOptions = buildTokenItemOptions(data.items, amt)
					local validSelected = {}
					local valueSet = {}
					for _, opt in ipairs(newOptions) do
						valueSet[opt.Value] = true
					end
					for _, val in ipairs(data.selected) do
						if valueSet[val] then
							table.insert(validSelected, val)
						end
					end
					safeCall(data.dropdown.Refresh, data.dropdown, newOptions, validSelected)
				end
			end
			function refreshEventDropdown()
				local newOptions = buildEventItemOptions()
				local validSelected = {}
				local valueSet = {}
				for _, opt in ipairs(newOptions) do
					valueSet[opt.Value] = true
				end
				for _, val in ipairs(selectedEventItemIds) do
					if valueSet[val] then
						table.insert(validSelected, val)
					end
				end
				safeCall(EventItemDropdown.Refresh, EventItemDropdown, newOptions, validSelected)
			end
			function refreshAll()
				task.spawn(function()
					safeCall(refreshDailyDropdown)
					safeCall(refreshTokenDropdowns)
					safeCall(refreshEventDropdown)
				end)
			end
			fetchDailyShopItems()
			UseInventory.Observe(function()
				refreshAll()
			end)
			useEvent.Changed:Connect(function()
				refreshAll()
			end)
			Currency.Changed:Connect(function()
				refreshAll()
			end)
		end)
		if not success then
			warn("LoadAutoShop callback error:", err)
		end
	end
})
-- Settings Tab
Tabs.Settings:Section({
	Title = "Settings",
	TextSize = 40
})
Tabs.Settings:Section({
	Title = "Config Manager",
	TextSize = 20
})
Tabs.Settings:Divider()

-- Services
local ConfigManager = Window.ConfigManager
local CurrentConfigName = "default"
local AutoLoadConfig = "default"
local AutoLoadEnabled = false
local AutoSaveEnabled = false
local ConfigListDropdown = nil
local AutoSaveConnection = nil
function FileExists(path)
	if isfile then
		return pcall(readfile, path)
	end
	return false
end
function WriteFile(path, content)
	if writefile then
		return pcall(writefile, path, content)
	end
	return false
end
function ReadFile(path)
	if readfile then
		local success, content = pcall(readfile, path)
		if success then
			return content
		end
	end
	return ""
end
function loadAutoLoadSettings()
	local autoLoadFile = "Darahub/AutoLoad/Game/Evade/AutoLoad.json"
	if FileExists(autoLoadFile) then
		local content = ReadFile(autoLoadFile)
		if content ~= "" then
			local success, data = pcall(function()
				return HttpService:JSONDecode(content)
			end)
			if success and data then
				AutoLoadConfig = data.configName or "default"
				AutoLoadEnabled = data.enabled or false
				return true
			end
		end
	end
	AutoLoadConfig = "default"
	AutoLoadEnabled = false
	return false
end
function saveAutoLoadSettings()
	local autoLoadFile = "Darahub/AutoLoad/Game/Evade/AutoLoad.json"
	local success = WriteFile(autoLoadFile, "")
	if not success then
		if makefolder then
			pcall(function()
				makefolder("Darahub")
			end)
			pcall(function()
				makefolder("Darahub/AutoLoad")
			end)
			pcall(function()
				makefolder("Darahub/AutoLoad/Game")
			end)
			pcall(function()
				makefolder("Darahub/AutoLoad/Game/Evade")
			end)
		end
	end
	local data = {
		enabled = AutoLoadEnabled,
		configName = AutoLoadConfig
	}
	local success, json = pcall(function()
		return HttpService:JSONEncode(data)
	end)
	if success then
		WriteFile(autoLoadFile, json)
	end
end
loadAutoLoadSettings()
ConfigNameInput = Tabs.Settings:Input({
	Title = "Config Name",
	Flag = "ConfigNameInput",
	Desc = "Name for your config file",
	Icon = "file-cog",
	Placeholder = "default",
	Value = CurrentConfigName,
	Callback = function(value)
		if value ~= "" then
			CurrentConfigName = value
		end
	end
})
Tabs.Settings:Space()
AutoLoadToggle = Tabs.Settings:Toggle({
	Title = "Auto Load",
	Flag = "AutoLoadToggle",
	Desc = "Automatically load this config when script starts",
	Value = AutoLoadEnabled,
	Callback = function(state)
		AutoLoadEnabled = state
		if state then
			AutoLoadConfig = CurrentConfigName
			WindUI:Notify({
				Title = "Auto-Load",
				Content = "Config '" .. CurrentConfigName .. "' will load automatically on startup",
				Duration = 3
			})
		end
		saveAutoLoadSettings()
	end
})
AutoSaveToggle = Tabs.Settings:Toggle({
	Title = "Auto Save",
	Flag = "AutoSaveToggle",
	Desc = "Automatically save changes to config every second",
	Value = AutoSaveEnabled,
	Callback = function(state)
		AutoSaveEnabled = state
		if AutoSaveConnection then
			AutoSaveConnection:Disconnect()
			AutoSaveConnection = nil
		end
		if state then
			WindUI:Notify({
				Title = "Auto-Save",
				Content = "Config will save automatically every second",
				Duration = 2
			})
			AutoSaveConnection = game:GetService("RunService").Heartbeat:Connect(function()
				if AutoSaveEnabled and CurrentConfigName ~= "" then
					task.spawn(function()
						Window.CurrentConfig = ConfigManager:Config(CurrentConfigName)
						Window.CurrentConfig:Save()
					end)
				end
				task.wait(1)
			end)
		else
			WindUI:Notify({
				Title = "Auto-Save",
				Content = "Auto-save disabled",
				Duration = 2
			})
		end
	end
})
Tabs.Settings:Space()
function refreshConfigList()
	local allConfigs = ConfigManager:AllConfigs() or {}
	if not table.find(allConfigs, "default") then
		local defaultConfig = ConfigManager:Config("default")
		if defaultConfig and defaultConfig.Save then
			defaultConfig:Save()
		end
		table.insert(allConfigs, 1, "default")
	end
	table.sort(allConfigs, function(a, b)
		return a:lower() < b:lower()
	end)
	local defaultValue = table.find(allConfigs, CurrentConfigName) and CurrentConfigName or "default"
	if ConfigListDropdown and ConfigListDropdown.Refresh then
		ConfigListDropdown:Refresh(allConfigs, defaultValue)
	end
end
ConfigListDropdown = Tabs.Settings:Dropdown({
	Title = "Existing Configs",
	Flag = "ConfigListDropdown",
	Desc = "Select from saved configs",
	Values = {
		"default"
	},
	Value = "default",
	Callback = function(value)
		CurrentConfigName = value
		ConfigNameInput:Set(value)
		if AutoLoadEnabled then
			AutoLoadConfig = value
			saveAutoLoadSettings()
		end
		local config = ConfigManager:GetConfig(value)
		if config then
			WindUI:Notify({
				Title = "Config Selected",
				Content = "Config '" .. value .. "' selected",
				Duration = 2
			})
		end
	end
})
Tabs.Settings:Space()
SaveConfigButton = Tabs.Settings:Button({
	Title = "Save Config",
	Desc = "Save current settings to config",
	Icon = "save",
	Callback = function()
		if CurrentConfigName == "" then
			WindUI:Notify({
				Title = "Error",
				Content = "Please enter a config name",
				Duration = 3
			})
			return
		end
		Window.CurrentConfig = ConfigManager:Config(CurrentConfigName)
		local success = Window.CurrentConfig:Save()
		if success then
			WindUI:Notify({
				Title = "Config Saved",
				Content = "Config '" .. CurrentConfigName .. "' saved successfully",
				Duration = 3
			})
			if AutoLoadEnabled then
				AutoLoadConfig = CurrentConfigName
				saveAutoLoadSettings()
			end
			task.wait(0.5)
			refreshConfigList()
		else
			WindUI:Notify({
				Title = "Error",
				Content = "Failed to save config",
				Duration = 3
			})
		end
	end
})
Tabs.Settings:Space()
LoadConfigButton = Tabs.Settings:Button({
	Title = "Load Config",
	Desc = "Load settings from selected config",
	Icon = "folder-open",
	Callback = function()
		if CurrentConfigName == "" then
			WindUI:Notify({
				Title = "Error",
				Content = "Please enter a config name",
				Duration = 3
			})
			return
		end
		Window.CurrentConfig = ConfigManager:CreateConfig(CurrentConfigName)
		local success = Window.CurrentConfig:Load()
		if success then
			WindUI:Notify({
				Title = "Config Loaded",
				Content = "Config '" .. CurrentConfigName .. "' loaded successfully",
				Duration = 3
			})
			if AutoLoadEnabled then
				AutoLoadConfig = CurrentConfigName
				saveAutoLoadSettings()
			end
		else
			WindUI:Notify({
				Title = "Error",
				Content = "Config '" .. CurrentConfigName .. "' not found or empty",
				Duration = 3
			})
		end
	end
})
Tabs.Settings:Space()
DeleteConfigButton = Tabs.Settings:Button({
	Title = "Delete Config",
	Desc = "Delete selected config",
	Icon = "trash-2",
	Color = Color3.fromHex("#ff4830"),
	Callback = function()
		if CurrentConfigName == "default" then
			WindUI:Notify({
				Title = "Error",
				Content = "Cannot delete default config",
				Duration = 3
			})
			return
		end
		local success = ConfigManager:DeleteConfig(CurrentConfigName)
		if success then
			WindUI:Notify({
				Title = "Config Deleted",
				Content = "Config '" .. CurrentConfigName .. "' deleted",
				Duration = 3
			})
			CurrentConfigName = "default"
			ConfigNameInput:Set("default")
			if AutoLoadEnabled then
				AutoLoadConfig = "default"
				saveAutoLoadSettings()
			end
			task.wait(0.5)
			refreshConfigList()
		else
			WindUI:Notify({
				Title = "Error",
				Content = "Failed to delete config or config doesn't exist",
				Duration = 3
			})
		end
	end
})
Tabs.Settings:Space()
RefreshConfigButton = Tabs.Settings:Button({
	Title = "Refresh Config List",
	Desc = "Update the list of available configs",
	Icon = "refresh-cw",
	Callback = function()
		refreshConfigList()
		WindUI:Notify({
			Title = "Config List Refreshed",
			Content = "Config list updated",
			Duration = 2
		})
	end
})
task.spawn(function()
	task.wait(0.5)
	refreshConfigList()
	ConfigNameInput:Set("default")
	if AutoLoadEnabled then
		CurrentConfigName = AutoLoadConfig
		ConfigNameInput:Set(CurrentConfigName)
		task.wait(1)
		Window.CurrentConfig = ConfigManager:Config(CurrentConfigName)
		if Window.CurrentConfig:Load() then
			WindUI:Notify({
				Title = "Auto-Loaded",
				Content = "Config '" .. CurrentConfigName .. "' loaded automatically",
				Duration = 3
			})
		end
	end
end)
if AutoSaveEnabled then
	task.spawn(function()
		task.wait(1)
		if AutoSaveEnabled then
			AutoSaveConnection = game:GetService("RunService").Heartbeat:Connect(function()
				if AutoSaveEnabled and CurrentConfigName ~= "" then
					task.spawn(function()
						Window.CurrentConfig = ConfigManager:Config(CurrentConfigName)
						Window.CurrentConfig:Save()
					end)
				end
				task.wait(1)
			end)
		end
	end)
end
Tabs.Settings:Section({
	Title = "Personalize",
	TextSize = 20
})
Tabs.Settings:Divider()
themes = {}
availableThemes = WindUI:GetThemes()
for themeName, _ in pairs(availableThemes) do
	table.insert(themes, themeName)
end
table.sort(themes)
ThemeDropdown = Tabs.Settings:Dropdown({
	Title = "Select Theme",
	Flag = "ThemeDropdown",
	Values = themes,
	SearchBarEnabled = true,
	MenuWidth = 280,
	Value = themes[1],
	Callback = function(theme)
		WindUI:SetTheme(theme)
	end
})
TransparencySlider = Tabs.Settings:Slider({
	Title = "Window Transparency",
	Step = 0.01,
	Flag = "TransparencySlider",
	Value = {
		Min = 0,
		Max = 1,
		Default = WindUI.TransparencyValue
	},
	Callback = function(value)
		WindUI.TransparencyValue = tonumber(value)
		Window:ToggleTransparency(tonumber(value) > 0)
	end
})
Tabs.Settings:Section({
	Title = "Keybinds"
})
Tabs.Settings:Keybind({
	Flag = "WinKeybind",
	Title = "Windows Keybind",
	Desc = "Keybind to open ui",
	Value = "RightControl",
	Callback = function(RightControl)
		Window:SetToggleKey(Enum.KeyCode[RightControl])
	end
})
Tabs.Settings:Section({
	Title = "Main Tabs Keybinds"
})
Tabs.Settings:Keybind({
	Flag = "StartRecord",
	Title = "Start Recording",
	Value = "",
	Callback = StartRecord
})
Tabs.Settings:Keybind({
	Flag = "StopRecord",
	Title = "Stop Recording",
	Value = "",
	Callback = StopRecord
})
Tabs.Settings:Keybind({
	Flag = "PlayTAS",
	Title = "Play TAS",
	Value = "",
	Callback = PlayTAS
})
Tabs.Settings:Space()
EmoteCrouchKeybind = Tabs.Settings:Keybind({
	Title = "Trigger Random Emote",
	Desc = "Keybind to trigger random emote with crouch",
	Value = "J",
	Flag = "EmoteCrouchKeybind",
	Callback = function(v)
		if EmoteCrouchEnabled then
			triggerRandomEmote()
		end
	end
})
SuperBounceKeybind = Tabs.Settings:Keybind({
	Title = "Trigger Super Bounce",
	Desc = "Keybind to trigger super bounce",
	Value = "N",
	Flag = "SuperBounceKeybind",
	Callback = function(v)
		if SuperBounceEnabled then
			triggerSuperBounce()
		end
	end
})
Tabs.Settings:Section({
	Title = "Player Tabs Keybinds"
})
Tabs.Settings:Space()
FlyTogglekeybind = Tabs.Settings:Keybind({
	Title = "Fly Toggle",
	Desc = "Keybind to toggle Fly",
	Value = "",
	Flag = "FlyTogglekeybind",
	Callback = function(v)
		FlyToggle:Set(not FlyToggle.Value)
	end
})
Tabs.Settings:Space()
InfSlidekeybind = Tabs.Settings:Keybind({
	Title = "InfSlide Toggle",
	Desc = "Keybind to toggle Slide",
	Value = "",
	Flag = "InfSlidekeybind",
	Callback = function(v)
		InfiniteSlideToggle:Set(not InfiniteSlideToggle.Value)
	end
})
Tabs.Settings:Section({
	Title = "Auto Tabs Keybinds"
})
Tabs.Settings:Keybind({
	Title = "Toggle Auto Spam Keybind",
	Value = "",
	Callback = function(value)
		SpamKeybindToggle:Set(not SpamKeybindToggle.Value)
	end
})
Tabs.Settings:Space()
BhopKeybind = Tabs.Settings:Keybind({
	Title = "Bhop Toggle Key",
	Desc = "Keybind to toggle Bhop",
	Value = "B",
	Flag = "BhopKeybind",
	Callback = function(v)
		BhopToggle:Set(not BhopToggle.Value)
	end
})
BhopHoldKeybind = Tabs.Settings:Keybind({
	Title = "Bhop Hold JUMP",
	Desc = "Keybind to toggle Bhop Hold",
	Value = "",
	Flag = "BhopHoldKeybind",
	Callback = function(v)
		BhopHoldToggle:Set(not BhopHoldToggle.Value)
	end
})
Tabs.Settings:Space()
Tabs.Settings:Keybind({
	Title = "Toggle Auto Walk",
	Desc = "Keybind to toggle Auto Walk",
	Value = "",
	Flag = "AutoWalkKeybind",
	Callback = function(v)
		toggleAutoWalk()
	end
})
Tabs.Settings:Space()
AutoCrouchKeybind = Tabs.Settings:Keybind({
	Title = "Auto Crouch Toggle",
	Desc = "Keybind to toggle Auto Crouch",
	Value = "C",
	Flag = "AutoCrouchKeybind",
	Callback = function(v)
		AutoCrouchToggle:Set(not AutoCrouchToggle.Value)
	end
})
Tabs.Settings:Space()
AutoCarryKeybind = Tabs.Settings:Keybind({
	Title = "Auto Carry Toggle",
	Desc = "Keybind to toggle Auto Carry",
	Value = "X",
	Flag = "AutoCarryKeybind",
	Callback = function(v)
		AutoCarryToggle:Set(not AutoCarryToggle.Value)
	end
})
Tabs.Settings:Section({
	Title = "Utility Tabs Keybinds"
})
LagSwitchKeybind = Tabs.Settings:Keybind({
	Title = "Trigger Lag Switch",
	Desc = "Keybind to trigger lag switch",
	Value = "L",
	Flag = "LagSwitchKeybind",
	Callback = function(v)
		if lagSwitchEnabled and not isLagActive then
			isLagActive = true
			task.spawn(function()
				lag()
				isLagActive = false
			end)
		end
	end
})
Tabs.Settings:Space()
GravityKeybind = Tabs.Settings:Keybind({
	Title = "Toggle Gravity",
	Desc = "Keybind to toggle custom gravity",
	Value = "J",
	Flag = "GravityKeybind",
	Callback = function(v)
		GravityToggle:Set(not GravityToggle.Value)
	end
})
DarahubFolder = CoreGui:FindFirstChild("Darahub")
if DarahubFolder and Tabs and Tabs.Settings then
	Tabs.Settings:Section({
		Title = "GUI Size"
	})
	defaultScales = {}
	for _, Element in pairs(DarahubFolder:GetChildren()) do
		if Element:IsA("Frame") and Element:FindFirstChild("UIScale") then
			defaultScales[Element.Name] = Element.UIScale.Scale
		end
	end
	Tabs.Settings:Button({
		Title = "Reset All Scales",
		Description = "Reverts all buttons to their startup scale values",
		Callback = function()
			for _, Element in pairs(DarahubFolder:GetChildren()) do
				if Element:IsA("Frame") and Element:FindFirstChild("UIScale") then
					local original = defaultScales[Element.Name] or 1
					Element.UIScale.Scale = original
				end
			end
		end
	})
	for _, Element in pairs(DarahubFolder:GetChildren()) do
		if Element:IsA("Frame") and Element:FindFirstChild("UIScale") then
			local currentScale = tonumber(Element.UIScale.Scale) or 1
			Tabs.Settings:Slider({
				Title = Element.Name .. " Scale",
				Desc = "Adjust GUI scale",
				Flag = "Scale_Slider_" .. Element.Name,
				Step = 0.01,
				Value = {
					Min = 0.01,
					Max = 4,
					Default = currentScale
				},
				Callback = function(val)
					if Element and Element:FindFirstChild("UIScale") then
						Element.UIScale.Scale = tonumber(val)
					end
				end
			})
		end
	end
end
Tabs.Settings:Section({
	Title = "UI Visibility",
	TextSize = 20
})
Tabs.Settings:Divider()
function getButtonNames()
	local buttonNames = {}
	if not PlayerGui then
		return buttonNames
	end
	local topbarStandard = PlayerGui:FindFirstChild("TopbarStandard")
	if not topbarStandard then
		return buttonNames
	end
	local descendants = topbarStandard:GetDescendants()
	for _, descendant in ipairs(descendants) do
		if descendant:IsA("Frame") and descendant.Name ~= "Main" and descendant.Name ~= "Holders" and descendant.Name ~= "IconButton" and descendant.Name ~= "IconOverlay" then
			if descendant:FindFirstChild("IconButton") then
				table.insert(buttonNames, descendant.Name)
			end
		end
	end
	return buttonNames
end
local buttonList = getButtonNames()
TopGuiButtonDropdown = Tabs.Settings:Dropdown({
	Title = "Top UI Visibility",
	Flag = "TopGuiButtonDropdown",
	Desc = "Show/hide buttons in Custom Top Gui",
	Values = buttonList,
	Multi = true,
	AllowNone = true,
	Value = buttonList,
	Callback = function(values)
		if not PlayerGui then
			return
		end
		local topbarStandard = PlayerGui:FindFirstChild("TopbarStandard")
		if not topbarStandard then
			return
		end
		local buttonContainer = nil
		local descendants = topbarStandard:GetDescendants()
		for _, descendant in ipairs(descendants) do
			if (descendant:IsA("Frame") or descendant:IsA("ScrollingFrame")) and descendant:FindFirstChild("IconButton") then
				buttonContainer = descendant.Parent
				break
			end
		end
		if not buttonContainer then
			return
		end
		local allButtons = {}
		for _, child in ipairs(buttonContainer:GetChildren()) do
			if child:IsA("Frame") and child:FindFirstChild("IconButton") then
				table.insert(allButtons, child.Name)
			end
		end
		for _, buttonName in ipairs(allButtons) do
			local btn = buttonContainer:FindFirstChild(buttonName)
			if btn then
				local visible = false
				for _, selectedName in ipairs(values) do
					if selectedName == buttonName then
						visible = true
						break
					end
				end
				btn.Visible = visible
			end
		end
	end
})
local FPSCounter = CoreGui:FindFirstChild("FPSCounter")
if FPSCounter then
	FPSCounterToggle = Tabs.Settings:Toggle({
		Title = "Show FPS Counter",
		Flag = "FPSCounterToggle",
		Value = true,
		Callback = function(state)
			if FPSCounter then
				FPSCounter.Enabled = state
			else
				warn("Could Not Find \"FPSCounter\" in CoreGUI! Please Reload the script And try again.")
			end
		end
	})
else
	warn("No \"FPSCounter\" Found in CoreGUI")
end
Tabs.Settings:Section({
	Title = "Sensitivity Controls",
	TextSize = 20
})
Tabs.Settings:Divider()
MouseSensitivityEnabled = false
MouseSensitivityValue = 1.0
default_sensitivity = 1.0
cameraInputModule = nil
mouseHookActive = false
touchHookActive = false
function setupSensitivityHook()
	if cameraInputModule then
		return true
	end
	success = false
	pcall(function()
		cameraModule = PlayerModule:FindFirstChild("CameraModule")
		if cameraModule then
			cameraInput = cameraModule:FindFirstChild("CameraInput")
			if cameraInput then
				cameraInputModule = require(cameraInput)
				if cameraInputModule and cameraInputModule.getRotation then
					originalGetRotation = cameraInputModule.getRotation
					cameraInputModule.getRotation = function(disableRotation)
						rotation = originalGetRotation(disableRotation)
						if MouseSensitivityEnabled and UserInputService.MouseEnabled then
							return rotation * MouseSensitivityValue
						elseif TouchSensitivityEnabled and UserInputService.TouchEnabled then
							return rotation * TouchSensitivityValue
						end
						return rotation
					end
					success = true
				end
			end
		end
	end)
	return success
end
MouseSensitivityToggle = Tabs.Settings:Toggle({
	Title = "Mouse Sensitivity",
	Flag = "MouseSensitivityToggle",
	Desc = "Adjust mouse sensitivity",
	Value = false,
	Callback = function(state)
		MouseSensitivityEnabled = state
		if state then
			if not setupSensitivityHook() then
				WindUI:Notify({
					Title = "Mouse Sensitivity",
					Content = "Failed to hook system. Try rejoining.",
					Duration = 3
				})
				MouseSensitivityToggle:Set(false)
				MouseSensitivityEnabled = false
			end
		end
	end
})
MouseSensitivitySlider = Tabs.Settings:Slider({
	Title = "Mouse Sensitivity Value",
	Flag = "MouseSensitivitySlider",
	Desc = "Lower = slower, Higher = faster (Max: 20)",
	Value = {
		Min = 0.1,
		Max = 20,
		Default = 1.0
	},
	Step = 0.1,
	Callback = function(value)
		MouseSensitivityValue = value
	end
})
Tabs.Settings:Space()
TouchSensitivityToggle = Tabs.Settings:Toggle({
	Title = "Touch Sensitivity",
	Flag = "TouchSensitivityToggle",
	Desc = "Adjust touch/mobile sensitivity",
	Value = false,
	Callback = function(state)
		TouchSensitivityEnabled = state
		if state then
			if not setupSensitivityHook() then
				WindUI:Notify({
					Title = "Touch Sensitivity",
					Content = "Failed to hook system. Try rejoining.",
					Duration = 3
				})
				TouchSensitivityToggle:Set(false)
				TouchSensitivityEnabled = false
			end
		end
	end
})
TouchSensitivitySlider = Tabs.Settings:Slider({
	Title = "Touch Sensitivity Value",
	Flag = "TouchSensitivitySlider",
	Desc = "Lower = slower, Higher = faster (Max: 20)",
	Value = {
		Min = 0.1,
		Max = 20,
		Default = 1.0
	},
	Step = 0.1,
	Callback = function(value)
		TouchSensitivityValue = value
	end
})
Tabs.Settings:Space()
Tabs.Settings:Section({
	Title = "Reset Controls",
	TextSize = 20
})
Tabs.Settings:Divider()
Tabs.Settings:Button({
	Title = "Reset Sensitivity Settings",
	Desc = "Reset both mouse and touch sensitivity to defaults",
	Icon = "refresh-cw",
	Color = Color3.fromHex("#FF3030"),
	Callback = function()
		MouseSensitivityEnabled = false
		MouseSensitivityValue = default_sensitivity
		TouchSensitivityEnabled = false
		TouchSensitivityValue = default_sensitivity
		cameraInputModule = nil
		mouseHookActive = false
		touchHookActive = false
		if MouseSensitivityToggle then
			MouseSensitivityToggle:Set(false)
		end
		if MouseSensitivitySlider then
			MouseSensitivitySlider:Set(1.0)
		end
		if TouchSensitivityToggle then
			TouchSensitivityToggle:Set(false)
		end
		if TouchSensitivitySlider then
			TouchSensitivitySlider:Set(1.0)
		end
		WindUI:Notify({
			Title = "Sensitivity Reset",
			Content = "All sensitivity settings reset to default",
			Duration = 3
		})
	end
})
Window:SelectTab(1)
UniverseScriptsStuff = loadstring(game:HttpGet(BaseURL .. "/Module/More-Scripts.Lua"))()
UniverseScriptsStuff(Tabs)
Instance.new("Sound", game).SoundId = "rbxassetid://115778296381875"
game.Sound:Play()
game.Sound.Ended:Connect(function()
	game.Sound:Destroy()
end)