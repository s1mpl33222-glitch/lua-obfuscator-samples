pcall(function()
	if setthreadidentity then setthreadidentity(8) end
end)

local localPlayer = game:GetService("Players").LocalPlayer

if not game:IsLoaded() then game.Loaded:Wait() end

local tbl

tbl = {
	SelectedPetData = nil,
	AllAnimalsCache = nil,
	ListNeedsRedraw = true,
	MobileScaleObjects = {},
	RefreshMobileScale = nil,
}

do
	local UserInputService = game:GetService("UserInputService")
	local GuiService = game:GetService("GuiService")

	local function fn()
		local flag = false
		local slicedflag2 = false
		local slicedflag3 = false
		local slicedflag4 = false
		pcall(function()
			flag = UserInputService.TouchEnabled
			slicedflag2 = UserInputService.KeyboardEnabled
			slicedflag3 = UserInputService.MouseEnabled
			slicedflag4 = UserInputService.GamepadEnabled
		end)
		local slicedflag5 = false
		pcall(function()
			slicedflag5 = GuiService:IsTenFootInterface()
		end)
		if slicedflag5 or slicedflag4 and not flag and not slicedflag2 then return "console" end
		if slicedflag2 and slicedflag3 then return "pc" end
		if flag then
			local currentCamera = workspace.CurrentCamera
			local viewportSize = currentCamera and currentCamera.ViewportSize or Vector2.new(390, 760)
			return math.min(viewportSize.X, viewportSize.Y) >= 600 and "tablet" or "phone"
		end
		return "pc"
	end

	local function slicedfn2()
		_G.YesDevice = fn()
		_G.YesIsTouch = _G.YesDevice == "phone" or _G.YesDevice == "tablet"
		_G.YesIsPhone = _G.YesDevice == "phone"
		_G.YesIsTablet = _G.YesDevice == "tablet"
		_G.YesIsConsole = _G.YesDevice == "console"
	end
	slicedfn2()
	local currentCamera = workspace.CurrentCamera
	if currentCamera then
		currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			slicedfn2()
		end)
	end
end

do
	local slicedtbl2 = { AUTO_STEAL = false, RADIUS = 12 }
	local slicedtbl3 = {
		{
			min = Vector3.new(-337.4483, -3.898971, -122.39776),
			max = Vector3.new(-328.00458, -3.898971, 242.62563),
		},
		{
			min = Vector3.new(-327.25766, -3.899109, -122.22862),
			max = Vector3.new(-320.6009, -3.899109, 242.61226),
		},
		{
			min = Vector3.new(-319.7834, -3.89897, -122.22709),
			max = Vector3.new(-312.90833, -3.89897, 242.58562),
		},
		{
			min = Vector3.new(-312.44565, -3.899108, -122.38983),
			max = Vector3.new(-305.4899, -3.899108, 242.45682),
		},
		{
			min = Vector3.new(-305.03705, -3.89897, -122.23074),
			max = Vector3.new(-293.9575, -3.89897, 242.60687),
		},
		{
			min = Vector3.new(-491.4486, -3.898972, -122.25326),
			max = Vector3.new(-481.81174, -3.898972, 242.615),
		},
		{
			min = Vector3.new(-498.97107, -3.89897, -122.38277),
			max = Vector3.new(-491.74884, -3.89897, 242.61206),
		},
		{
			min = Vector3.new(-506.43674, -3.898972, -122.411476),
			max = Vector3.new(-499.31854, -3.898972, 242.61598),
		},
		{
			min = Vector3.new(-513.78357, -3.898972, -122.2233),
			max = Vector3.new(-506.80185, -3.898972, 242.62709),
		},
		{
			min = Vector3.new(-525.23694, -3.898972, -122.40981),
			max = Vector3.new(-514.265, -3.898972, 242.60893),
		},
	}
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local localPlayer2 = Players.LocalPlayer
	local connection = nil

	local function fn()
		localPlayer2.DevEnableMouseLock = true
		localPlayer2.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
		if connection then connection:Disconnect() end
		connection = RunService.RenderStepped:Connect(function()
			local currentCamera = workspace.CurrentCamera
			if currentCamera and currentCamera.CameraSubject and currentCamera.CameraType == Enum.CameraType.Custom then
				currentCamera.CFrame = currentCamera.CFrame
			end
		end)
	end
	fn()
	localPlayer2.CharacterAdded:Connect(function()
		task.wait(0.5)
		fn()
	end)
	local slicedtbl4 = {}
	local slicedtbl5 = {}
	local n = 0

	_G.getSafePollRate = function()
		if os.clock() < n then return 0.27 end
		return 0.1
	end
	_G.triggerSafePollBoost = function() n = os.clock() + 3 end
	local slicedtbl6 = {}

	local function slicedfn2()
		local character = localPlayer2.Character
		return character and character:FindFirstChild("HumanoidRootPart")
	end

	local function slicedfn3(arg)
		for i, v in ipairs(slicedtbl3) do
			if arg.X >= math.min(v.min.X, v.max.X) and arg.X <= math.max(v.min.X, v.max.X) and arg.Z >= math.min(v.min.Z, v.max.Z) and arg.Z <= math.max(v.min.Z, v.max.Z) then
				return i
			end
		end
	end

	local function slicedfn4(arg)
		local parent = arg.Parent
		if not parent then return end
		if parent:IsA("Attachment") and parent.Parent then parent = parent.Parent end
		if parent:IsA("BasePart") then return parent.Position end
		if parent:IsA("Model") then return parent:GetPivot().Position end
	end

	local function slicedfn5(arg)
		if not tbl then return false end
		local selectedPetData = tbl.SelectedPetData
		if not selectedPetData then return false end
		local model = arg:FindFirstAncestorOfClass("Model")
		if not model then return false end
		if selectedPetData.plot then if not arg:FindFirstAncestor(selectedPetData.plot) then return false end end
		if selectedPetData.slot then
			if arg:FindFirstAncestor(selectedPetData.slot) then return true end
			if model.Name == selectedPetData.slot then return true end
			if model.Parent and model.Parent.Name == selectedPetData.slot then return true end
		end
		if selectedPetData.name then
			local v = string.lower(selectedPetData.name)
			while model do
				if model.Name and string.lower(model.Name) == v then return true end
				model = model.Parent
			end
		end
		return false
	end

	local function slicedfn6(arg, slicedarg2)
		if not arg or not arg.Parent then return false end
		if not arg.Enabled then return false end
		local v = slicedfn4(arg)
		if not v then return false end
		if arg:FindFirstAncestorOfClass("Model") then
			local plots = workspace:FindFirstChild("Plots")
			if plots then
				local model = arg:FindFirstAncestorWhichIsA("Model")
				while model and model.Parent ~= plots do model = model.Parent end
				if model then
					local plotSign = model:FindFirstChild("PlotSign")
					if plotSign then
						local surfaceGui = plotSign:FindFirstChildWhichIsA("SurfaceGui", true)
						surfaceGui = surfaceGui and surfaceGui:FindFirstChildWhichIsA("TextLabel", true)
						if surfaceGui then
							local str = surfaceGui.Text:lower()
							if str:find(game.Players.LocalPlayer.Name:lower(), 1, true) or str:find(game.Players.LocalPlayer.DisplayName:lower(), 1, true) then
								return false
							end
						end
					end
				end
			end
		end
		if _G.NEAREST_INSTANT_MODE == true then
			local slicedv2 = slicedfn3(slicedarg2)
			local slicedv3 = slicedfn3(v)
			if not slicedv2 or slicedv2 ~= slicedv3 then return false end
		end
		if _G.NEAREST_INSTANT_MODE ~= true then if not slicedfn5(arg) then return false end end
		return (v - slicedarg2).Magnitude <= math.min(slicedtbl2.RADIUS, typeof(arg.MaxActivationDistance) == "number" and arg.MaxActivationDistance > 0 and arg.MaxActivationDistance or slicedtbl2.RADIUS)
	end

	local function slicedfn7(arg, slicedarg2)
		local now = os.clock()
		local v = slicedtbl5[arg]
		if v and now - v < slicedarg2 then return false end
		slicedtbl5[arg] = now
		return true
	end

	local function slicedfn8(arg, slicedarg2, slicedarg3)
		if not arg or not arg.Parent then return end
		if not arg.Enabled then return end
		if not slicedfn7(arg, slicedarg3) then return end
		for i = 1, slicedarg2 do
			pcall(function()
				fireproximityprompt(arg, 0)
			end)
		end
	end

	local function slicedfn9(arg)
		if slicedtbl4[arg] then return end
		slicedtbl4[arg] = true

		local function slicedfn10()
			local v = slicedfn2()
			if not v then return end
			if slicedfn6(arg, v.Position) then
				slicedtbl2.AUTO_STEAL = true
				local now = os.clock()
				local slicedv2 = slicedtbl6[arg]
				if not slicedv2 or now - slicedv2 >= 0.08 then
					slicedtbl6[arg] = now
					slicedfn8(arg, 25, 0)
				end
			end
		end
		task.defer(function()
			slicedfn10()
		end)
		pcall(function()
			arg:GetPropertyChangedSignal("Enabled"):Connect(function()
				if arg.Enabled then slicedfn10() end
			end)
		end)
		arg.AncestryChanged:Connect(function()
			if not arg:IsDescendantOf(workspace) then
				slicedtbl4[arg] = nil
				slicedtbl5[arg] = nil
				slicedtbl6[arg] = nil
			end
		end)
	end

	local function slicedfn10()
		local plots = workspace:FindFirstChild("Plots")
		if not plots then return end
		for _, child in ipairs(plots:GetChildren()) do
			local animalPodiums = child:FindFirstChild("AnimalPodiums")
			if animalPodiums then
				for _, descendant in ipairs(animalPodiums:GetDescendants()) do if descendant:IsA("ProximityPrompt") then slicedfn9(descendant) end end
			end
		end
	end
	slicedfn10()
	workspace.DescendantAdded:Connect(function(descendant)
		if descendant:IsA("ProximityPrompt") and descendant:FindFirstAncestor("AnimalPodiums") then slicedfn9(descendant) end
	end)
	task.spawn(function()
		while task.wait(_G.getSafePollRate()) do
			local v = slicedfn2()
			if not v then
				slicedtbl2.AUTO_STEAL = false
			else
				local position = v.Position
				local autoSteal = false
				for k in pairs(slicedtbl4) do
					if slicedfn6(k, position) then
						autoSteal = true
						if slicedtbl2.AUTO_STEAL then
							slicedfn8(k, 3, 0.12)
							autoSteal = true
						end
					end
				end
				slicedtbl2.AUTO_STEAL = autoSteal
			end
		end
	end)
end

local players, runService, replicatedStorage, tweenService, workspace_, localPlayer2, playerGui, v, scale, slicedv2
local fn

do
	local slicedtbl2 = {
		Players = game:GetService("Players"),
		RunService = game:GetService("RunService"),
		UserInputService = game:GetService("UserInputService"),
		ReplicatedStorage = game:GetService("ReplicatedStorage"),
		TweenService = game:GetService("TweenService"),
		HttpService = game:GetService("HttpService"),
		Workspace = game:GetService("Workspace"),
		Lighting = game:GetService("Lighting"),
		GuiService = game:GetService("GuiService"),
		TeleportService = game:GetService("TeleportService"),
	}
	players = slicedtbl2.Players
	runService = slicedtbl2.RunService
	local userInputService = slicedtbl2.UserInputService
	replicatedStorage = slicedtbl2.ReplicatedStorage
	tweenService = slicedtbl2.TweenService
	local httpService = slicedtbl2.HttpService
	workspace_ = slicedtbl2.Workspace
	localPlayer2 = players.LocalPlayer
	playerGui = localPlayer2:WaitForChild("PlayerGui")
	local obj = nil
	obj = setmetatable({}, { __index = function(arg, slicedarg2)
		local net = replicatedStorage.Packages.Net
		if slicedarg2:sub(1, 3) == "RE/" then
			slicedarg2:sub(4)
		else
			if slicedarg2:sub(1, 3) ~= "RF/" then return nil end
			slicedarg2:sub(4)
		end
		local slicedv3 = nil
		for k, slicedv4 in net:GetChildren() do
			if slicedv4.Name == slicedarg2 then
				slicedv3 = net:GetChildren()[k + 1]
				break
			else
				slicedv3 = nil
			end
		end
		if slicedv3 and not rawget(obj, slicedarg2) then rawset(obj, slicedarg2, slicedv3) end
		return rawget(obj, slicedarg2)
	end })
	local slicedtbl3 = { LarpNet = function(arg, slicedarg2)
		return obj[slicedarg2]
	end }
	localPlayer2:GetMouse()
	local function slicedfn2() return userInputService.TouchEnabled and not userInputService.KeyboardEnabled and not userInputService.MouseEnabled end
	v = slicedfn2()
	scale = 0.79
	local slicedtbl4 = {
		Positions = {
			AutoSteal = { X = 0, Y = 0, OffsetX = 14, OffsetY = 80 },
			TargetControls = { X = 0, Y = 0, OffsetX = 14 + 320 * scale + 10, OffsetY = 80 },
		},
		MenuKey = "LeftControl",
		MobileGuiScale = 0.5,
		StealNearest = false,
		StealHighest = true,
		StealPriority = false,
		DefaultToNearest = false,
		DefaultToHighest = false,
		DefaultToPriority = false,
		UILocked = false,
		HideAutoSteal = false,
		CompactAutoSteal = false,
		InstantSteal = false,
		nextBaseEnabled = false,
		XRay = false,
		PlayerESP = false,
		podiumESP = false,
		TurretESP = false,
		TrapESP = false,
		BrainrotESP = false,
		BrainrotESPMinGen = 10000000,
		AntiRagdoll = true,
		AntiBeeDisco = true,
		AntiDie = true,
		AutoTurret = false,
		AntiLag = false,
		CarpetSpeed = false,
		CarpetSpeedValue = 140,
		CarpetSpeedKey = "Q",
		InfJump = true,
		AutoKickOnSteal = false,
		FOV = 80,
		ResetCooldown = 2.5,
		ResetFlingTime = 5,
		PriorityList = {
			"Strawberry Elephant",
			"Meowl",
			"Skibidi Toilet",
			"Headless Horseman",
			"Dragon Gingerini",
			"Dragon Cannelloni",
			"Ketupat Bros",
			"Hydra Dragon Cannelloni",
			"La Supreme Combinasion",
			"Love Love Bear",
			"Ginger Gerat",
			"Cerberus",
			"Capitano Moby",
			"La Casa Boo",
			"Burguro and Fryuro",
			"Spooky and Pumpky",
			"Cooki and Milki",
			"Rosey and Teddy",
			"Popcuru and Fizzuru",
			"Reinito Sleighito",
			"Fragrama and Chocrama",
			"Garama and Madundung",
			"Ketchuru and Musturu",
			"La Secret Combinasion",
			"Tralaledon",
			"Tictac Sahur",
			"Ketupat Kepat",
			"Tang Tang Keletang",
			"Orcaledon",
			"La Ginger Sekolah",
			"Los Spaghettis",
			"Lavadorito Spinito",
			"Swaggy Bros",
			"La Taco Combinasion",
			"Los Primos",
			"Chillin Chili",
			"Tuff Toucan",
			"W or L",
			"Chillin Chili",
			"Chipso and Queso",
		},
	}

	DeepCopy = function(arg)
		if type(arg) ~= "table" then return arg end
		local slicedtbl5 = {}
		for k, slicedv3 in pairs(arg) do slicedtbl5[k] = DeepCopy(slicedv3) end
		return slicedtbl5
	end

	MergeDefaults = function(arg, slicedarg2)
		for k, slicedv3 in pairs(slicedarg2) do
			if type(slicedv3) == "table" then
				if type(arg[k]) ~= "table" then
					arg[k] = DeepCopy(slicedv3)
				else
					MergeDefaults(arg[k], slicedv3)
				end
			elseif arg[k] == nil then
				arg[k] = slicedv3
			end
		end
	end
	slicedv2 = DeepCopy(slicedtbl4)

	NormalizeKeyName = function(arg, slicedarg2)
		if type(arg) ~= "string" or arg == "" then return slicedarg2 end
		local slicedv3 = ({
			ALT = "LeftAlt",
			LALT = "LeftAlt",
			RALT = "RightAlt",
			CTRL = "LeftControl",
			CONTROL = "LeftControl",
			LCTRL = "LeftControl",
			RCTRL = "RightControl",
			SHIFT = "LeftShift",
			LSHIFT = "LeftShift",
			RSHIFT = "RightShift",
			WIN = "LeftSuper",
			CMD = "LeftSuper",
			META = "LeftSuper",
		})[string.upper(arg)] or arg
		return Enum.KeyCode[slicedv3] and slicedv3 or arg
	end

	PrettyKeyName = function(arg)
		local slicedv3 = ({
			LeftAlt = "ALT",
			RightAlt = "RALT",
			LeftControl = "CTRL",
			RightControl = "RCTRL",
			LeftShift = "SHIFT",
			RightShift = "RSHIFT",
			LeftSuper = "WIN",
			RightSuper = "RWIN",
		})[arg]
		local str
		if slicedv3 then
			str = slicedv3
		else
			str = tostring(arg or "")
		end
		return str
	end
	if isfile and isfile("SlicedzHub.json") then
		pcall(function()
			local json = readfile("SlicedzHub.json")
			if not json or json == "" then return end
			local data = httpService:JSONDecode(json)
			if type(data) ~= "table" then return end
			local slicedv3 = nil
			if type(data.PriorityList) == "table" then slicedv3 = DeepCopy(data.PriorityList) end
			MergeDefaults(data, slicedtbl4)
			if slicedv3 ~= nil then data.PriorityList = slicedv3 end
			slicedv2 = data
		end)
	end
	if slicedv2.Positions then slicedv2.Positions.Settings = { X = 0.5, Y = 0.5, OffsetX = 0, OffsetY = 0 } end
	if slicedv2.LayoutRev ~= 4 then
		slicedv2.Positions = slicedv2.Positions or {}
		slicedv2.Positions.AutoSteal = DeepCopy(slicedtbl4.Positions.AutoSteal)
		slicedv2.Positions.TargetControls = DeepCopy(slicedtbl4.Positions.TargetControls)
		slicedv2.LayoutRev = 4
		slicedv2.FixedLayout = nil
		_needMigrationSave = true
	end

	EnsureSavedKeybinds = function()
		slicedv2.SavedKeybinds = slicedv2.SavedKeybinds or {}
		slicedv2.SavedKeybinds.MenuKey = NormalizeKeyName(slicedv2.SavedKeybinds.MenuKey or slicedv2.MenuKey, slicedtbl4.MenuKey or "LeftControl")
	end

	ApplySavedKeybindsToConfig = function()
		EnsureSavedKeybinds()
		slicedv2.MenuKey = slicedv2.SavedKeybinds.MenuKey
	end

	NormalizeAllKeybinds = function()
		EnsureSavedKeybinds()
		ApplySavedKeybindsToConfig()
	end
	NormalizeAllKeybinds()

	fn = function()
		if writefile then
			pcall(function()
				NormalizeAllKeybinds()
				local slicedv3 = DeepCopy(slicedv2)
				slicedv3.MenuKey = slicedv2.SavedKeybinds.MenuKey
				writefile("SlicedzHub.json", httpService:JSONEncode(slicedv3))
			end)
		end
	end
	if _needMigrationSave then fn() end
	_G.StickyCarpetSpeed = slicedv2.CarpetSpeed == true
	_G.StickyCarpetSpeedValue = math.clamp(tonumber(slicedv2.CarpetSpeedValue) or 140, 20, 400)
	_G.StickyCarpetSpeedKeyName = type(slicedv2.CarpetSpeedKey) == "string" and slicedv2.CarpetSpeedKey or "Q"
	_G.StickyInfJump = slicedv2.InfJump ~= false
	_G.StickyAutoKickOnSteal = slicedv2.AutoKickOnSteal == true
	_G.StickyFOV = tonumber(slicedv2.FOV) or 80
	_G.StickyResetCooldown = tonumber(slicedv2.ResetCooldown) or 2.5
	_G.StickyResetFlingTime = tonumber(slicedv2.ResetFlingTime) or 5
	_G.StickyAntiBee = slicedv2.AntiBeeDisco ~= false
	_G.StickyAntiDieDisabled = slicedv2.AntiDie == false

	local function slicedfn3()
		slicedv2.CarpetSpeedValue = math.clamp(tonumber(_G.StickyCarpetSpeedValue) or 140, 20, 400)
		slicedv2.FOV = tonumber(_G.StickyFOV) or slicedv2.FOV
		slicedv2.ResetCooldown = tonumber(_G.StickyResetCooldown) or slicedv2.ResetCooldown
		slicedv2.ResetFlingTime = tonumber(_G.StickyResetFlingTime) or slicedv2.ResetFlingTime
		slicedv2.AntiBeeDisco = _G.StickyAntiBee ~= false
		slicedv2.AntiDie = _G.StickyAntiDieDisabled ~= true
		if type(_G.StickyCarpetSpeedKeyName) == "string" then slicedv2.CarpetSpeedKey = _G.StickyCarpetSpeedKeyName end
		if _G.StickyInfJump ~= nil then slicedv2.InfJump = _G.StickyInfJump == true end
		if _G.StickyCarpetSpeed ~= nil then slicedv2.CarpetSpeed = _G.StickyCarpetSpeed == true end
		if _G.StickyAutoKickOnSteal ~= nil then slicedv2.AutoKickOnSteal = _G.StickyAutoKickOnSteal == true end
	end
	local slicedv3 = nil

	_G.StickySaveConfigNow = function()
		pcall(function()
			slicedfn3()
			local json = httpService:JSONEncode(slicedv2)
			if json ~= slicedv3 then
				slicedv3 = json
				fn()
			end
		end)
	end
end

task.spawn(function()
	task.wait(5)
	while true do
		_G.StickySaveConfigNow()
		task.wait(5)
	end
end)

do
	local flag = false
	local slicedtbl2 = {}

	_G.StickyOnBoot = function(arg)
		if type(arg) ~= "function" then return end
		if flag then
			task.spawn(arg)
			return
		end
		slicedtbl2[#slicedtbl2 + 1] = arg
	end
	task.spawn(function()
		local n = os.clock() + 30
		while not workspace:FindFirstChild("Plots") and os.clock() < n do task.wait(0.25) end
		local slicedn2 = os.clock() + 15
		while os.clock() < slicedn2 do
			local character = localPlayer2.Character
			if not (character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChildOfClass("Humanoid")) then
				task.wait(0.25)
				continue
			end
			break
		end
		task.wait(1.5)
		flag = true
		for _, slicedv3 in ipairs(slicedtbl2) do task.spawn(slicedv3) end
		slicedtbl2 = {}
	end)
end

game:GetService("Workspace")

do
	local Players = game:GetService("Players")
	local localPlayer3 = Players.LocalPlayer
	local slicedv3 = slicedv2
	local slicedv4 = fn

	local function slicedfn2(arg, slicedarg2)
		local slicedzSyncToggleUI = _G.SlicedzSyncToggleUI
		if type(slicedzSyncToggleUI) == "function" then pcall(slicedzSyncToggleUI, arg, slicedarg2) end
	end
	if _G.StickyXray == nil then _G.StickyXray = true end
	if _G.StickyXrayAlpha == nil then _G.StickyXrayAlpha = 0.9 end

	local function slicedfn3()
		local slicedtbl2 = { "Base", "PlotSign", "FriendPanel", "Cash", "Laser", "Decorations", "Skin", "Unlock", "Purchases" }
		local obj = setmetatable({}, { __mode = "k" })
		local slicedtbl3 = {}
		local n = 0

		local function slicedfn4(arg, slicedarg2)
			if not arg:IsA("BasePart") then return end
			if obj[arg] == nil then obj[arg] = arg.Transparency == slicedarg2 and 0 or arg.Transparency end
			local slicedv5 = obj[arg]
			if slicedv5 >= 1 then return end
			local transparency = slicedv5 + (1 - slicedv5) * slicedarg2
			if math.abs(arg.Transparency - transparency) > 0.01 then arg.Transparency = transparency end
		end
		local function slicedfn5() while _G.StickyStealHold do task.wait(0.15) end end

		local function slicedfn6(arg, slicedarg2, slicedarg3)
			if not arg or slicedarg3 ~= n then return end
			slicedfn4(arg, slicedarg2)
			local slicedn2 = 0
			for _, descendant in ipairs(arg:GetDescendants()) do
				if slicedarg3 ~= n then return end
				slicedfn4(descendant, slicedarg2)
				slicedn2 += 1
				if slicedn2 % 250 == 0 then task.wait() end
			end
			slicedtbl3[#slicedtbl3 + 1] = arg.DescendantAdded:Connect(function(descendant)
				if slicedarg3 == n then slicedfn4(descendant, slicedarg2) end
			end)
		end

		local function slicedfn7(arg, slicedarg2, slicedarg3)
			if not arg or slicedarg3 ~= n then return end
			for _, slicedv5 in ipairs(slicedtbl2) do
				if slicedarg3 ~= n then return end
				slicedfn6(arg:FindFirstChild(slicedv5), slicedarg2, slicedarg3)
			end
			if slicedarg3 ~= n then return end
			slicedtbl3[#slicedtbl3 + 1] = arg.ChildAdded:Connect(function(child)
				if slicedarg3 ~= n then return end
				for _, slicedv5 in ipairs(slicedtbl2) do
					if child.Name == slicedv5 then
						slicedfn6(child, slicedarg2, slicedarg3)
						break
					end
				end
			end)
			local animalPodiums = arg:FindFirstChild("AnimalPodiums")
			if not animalPodiums then return end
			local function slicedfn8(slicedarg4)
				for _, child in ipairs(slicedarg4:GetChildren()) do
					if child.Name == "Claim" then
						slicedfn6(child, slicedarg2, slicedarg3)
					elseif child.Name == "Base" then
						slicedfn6(child:FindFirstChild("Decorations"), slicedarg2, slicedarg3)
					end
				end
			end
			for _, child in ipairs(animalPodiums:GetChildren()) do slicedfn8(child) end
			slicedtbl3[#slicedtbl3 + 1] = animalPodiums.ChildAdded:Connect(function(child)
				if slicedarg3 ~= n then return end
				task.wait(0.1)
				if slicedarg3 == n then slicedfn8(child) end
			end)
		end

		local function slicedfn8()
			for _, slicedv5 in ipairs(slicedtbl3) do
				pcall(function()
					slicedv5:Disconnect()
				end)
			end
			local slicedn2 = n + 1
			slicedtbl3 = {}
			n = slicedn2
		end

		_G.StickyEnableXray = function()
			slicedv3.XRay = true
			slicedv4()
			slicedfn2("XRay", true)
			slicedfn2("X-Ray", true)
			slicedfn8()
			local slicedv5 = n
			local slicedn2 = math.clamp(tonumber(_G.StickyXrayAlpha) or 0.9, 0, 1)
			task.spawn(function()
				while slicedv5 == n and not workspace:FindFirstChild("Plots") do task.wait(0.5) end
				local plots = workspace:FindFirstChild("Plots")
				if slicedv5 ~= n or not plots then return end
				slicedfn5()
				for _, child in ipairs(plots:GetChildren()) do
					if slicedv5 ~= n then return end
					pcall(slicedfn7, child, slicedn2, slicedv5)
					task.wait()
					slicedfn5()
				end
				slicedtbl3[#slicedtbl3 + 1] = plots.ChildAdded:Connect(function(child)
					if slicedv5 ~= n then return end
					task.wait(0.2)
					pcall(slicedfn7, child, slicedn2, slicedv5)
				end)
			end)
		end

		_G.StickyDisableXray = function()
			slicedv3.XRay = false
			slicedv4()
			slicedfn2("XRay", false)
			slicedfn2("X-Ray", false)
			slicedfn8()
			local slicedv5 = obj
			obj = setmetatable({}, { __mode = "k" })
			for k, slicedv6 in pairs(slicedv5) do
				pcall(function()
					if k:IsA("BasePart") then k.Transparency = slicedv6 end
				end)
			end
		end

		setXRay = function(arg)
			if arg then
				_G.StickyEnableXray()
			else
				_G.StickyDisableXray()
			end
		end
		_G.setXRay = setXRay
	end
	slicedfn3()
	if _G.StickyAutoKickOnSteal == nil then _G.StickyAutoKickOnSteal = slicedv2.AutoKickOnSteal == true end
	if _G.StickyKickToPS == nil then _G.StickyKickToPS = false end

	local function slicedfn4()
		local function slicedfn5(arg)
			local match = tostring(arg or ""):match("^%s*(.-)%s*$")
			if match == "" then return nil end
			if not match:find("://", 1, true) then return match end
			return match:match("[?&]privateServerLinkCode=([^&]+)") or match:match("[?&]linkCode=([^&]+)") or match:match("[?&]code=([^&]+)")
		end

		local function stickyKickOut()
			if _G.StickyKickToPS == true then
				local slicedv5 = slicedfn5(_G.StickyPrivateServerLink)
				if slicedv5 and slicedv5 ~= "" then
					if pcall(function()
						game:GetService("ExperienceService"):LaunchExperience({ placeId = tonumber(_G.StickyPrivateServerPlaceId) or game.PlaceId, linkCode = slicedv5 })
					end) then
						return
					end
				end
			end
			if pcall(function()
				game:Shutdown()
			end) then
				return
			end
			pcall(function()
				localPlayer2:Kick("")
			end)
		end
		_G.StickyKickOut = stickyKickOut
		task.spawn(function()
			local playerGui2 = localPlayer2:FindFirstChildOfClass("PlayerGui") or localPlayer2:WaitForChild("PlayerGui", 10)
			if not playerGui2 then return end
			local obj = setmetatable({}, { __mode = "k" })
			local function slicedfn6(arg) return type(arg) == "string" and arg:lower():find("you stole", 1, true) ~= nil end
			local function slicedfn7(arg) return arg:IsA("TextLabel") or arg:IsA("TextButton") or arg:IsA("TextBox") end
			local function slicedfn8(arg)
				if obj[arg] then return end
				obj[arg] = true
				if _G.StickyAutoKickOnSteal == true and slicedfn6(arg.Text) then
					stickyKickOut()
					return
				end
				arg:GetPropertyChangedSignal("Text"):Connect(function()
					if _G.StickyAutoKickOnSteal == true and slicedfn6(arg.Text) then stickyKickOut() end
				end)
			end
			local function slicedfn9(child)
				child.DescendantAdded:Connect(function(descendant)
					if slicedfn7(descendant) then slicedfn8(descendant) end
				end)
				local n = 0
				for _, descendant in ipairs(child:GetDescendants()) do
					n += 1
					if n % 200 == 0 then task.wait() end
					if slicedfn7(descendant) then slicedfn8(descendant) end
				end
			end
			while _G.StickyAutoKickOnSteal ~= true do task.wait(1) end
			playerGui2.ChildAdded:Connect(slicedfn9)
			for _, child in ipairs(playerGui2:GetChildren()) do slicedfn9(child) end
		end)
	end
	slicedfn4()
	if _G.StickyInfJump == nil then _G.StickyInfJump = slicedv2.InfJump ~= false end

	local function slicedfn5()
		local UserInputService = game:GetService("UserInputService")
		local RunService = game:GetService("RunService")
		local flag = false

		local function slicedfn6()
			local character = localPlayer2.Character
			local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
			character = character and character:FindFirstChildOfClass("Humanoid")
			if not humanoidRootPart or not character or character.Health <= 0 then return end
			humanoidRootPart.Velocity = Vector3.new(humanoidRootPart.Velocity.X, character.JumpPower or 50, humanoidRootPart.Velocity.Z)
		end
		local function slicedfn7() return _G.StickyInfJump ~= false end
		UserInputService.JumpRequest:Connect(function()
			if slicedfn7() then slicedfn6() end
		end)
		UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if not gameProcessed and input.KeyCode == Enum.KeyCode.Space then flag = true end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.Space then flag = false end
		end)
		RunService.Heartbeat:Connect(function()
			if flag and slicedfn7() then slicedfn6() end
		end)
	end
	slicedfn5()
	if _G.StickyCarpetSpeed == nil then _G.StickyCarpetSpeed = slicedv2.CarpetSpeed == true end
	if _G.StickyCarpetSpeedValue == nil then _G.StickyCarpetSpeedValue = tonumber(slicedv2.CarpetSpeedValue) or 140 end
	if _G.StickyCarpetSpeedKeyName == nil then _G.StickyCarpetSpeedKeyName = slicedv2.CarpetSpeedKey or "Q" end

	local function slicedfn6()
		local UserInputService = game:GetService("UserInputService")
		local RunService = game:GetService("RunService")
		local connection = nil

		_G.StickySetCarpetSpeed = function(arg)
			_G.StickyCarpetSpeed = arg and true or false
			_G.StickyCarpetSpeedActive = _G.StickyCarpetSpeed
			if connection then
				connection:Disconnect()
				connection = nil
			end
			if not _G.StickyCarpetSpeed then return end
			if _G.StickyEquipCarpet then
				task.spawn(function()
					pcall(_G.StickyEquipCarpet)
				end)
			end
			connection = RunService.Heartbeat:Connect(function()
				if localPlayer2:GetAttribute("Stealing") == true then
					_G.StickySetCarpetSpeed(false)
					return
				end
				local character = localPlayer2.Character
				local humanoid = character and character:FindFirstChildOfClass("Humanoid")
				local upperTorso = character and (character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart"))
				if not humanoid or not upperTorso then return end
				if not (_G.StickyCarpetEngaging and _G.StickyCarpetEngaging()) and _G.StickyEquipCarpet then pcall(_G.StickyEquipCarpet) end
				local n = math.clamp(tonumber(_G.StickyCarpetSpeedValue) or 140, 20, 400)
				local moveDirection = humanoid.MoveDirection
				local y = upperTorso.Velocity.Y
				if moveDirection.Magnitude > 0 then
					upperTorso.Velocity = Vector3.new(moveDirection.X * n, y, moveDirection.Z * n)
				else
					upperTorso.Velocity = Vector3.new(0, y, 0)
				end
			end)
		end
		UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
			if input.KeyCode.Name ~= (_G.StickyCarpetSpeedKeyName or "Q") then return end
			if localPlayer2:GetAttribute("Stealing") == true then return end
			local flag = not (_G.StickyCarpetSpeed == true)
			_G.StickySetCarpetSpeed(flag)
			if flag and _G.StickyEquipCarpet then
				task.spawn(function()
					pcall(_G.StickyEquipCarpet)
				end)
			end
			if _G.StickySaveConfigNow then task.spawn(_G.StickySaveConfigNow) end
		end)
		_G.StickyOnBoot(function()
			if slicedv2.CarpetSpeed == true then pcall(_G.StickySetCarpetSpeed, true) end
		end)
	end
	slicedfn6()
	local playerESP = slicedv3.PlayerESP == true
	local slicedtbl2 = {}
	local slicedtbl3 = {
		["Boogie Bomb"] = true,
		["Medusa's Head"] = true,
		["Body Swap Potion"] = true,
		["Laser Cape"] = true,
		["Rainbowrath Sword"] = true,
		["Gummy Bear"] = true,
	}

	local function slicedfn7(arg)
		local character = arg.Character
		if not character then return nil end
		for _, child in ipairs(character:GetChildren()) do if child:IsA("Tool") then return child.Name end end
		return nil
	end

	local function slicedfn8(arg)
		local billboardGui = Instance.new("BillboardGui")
		billboardGui.Name = "PlayerESP_" .. tostring(arg.UserId)
		billboardGui.Size = UDim2.new(0, 170, 0, 34)
		billboardGui.StudsOffsetWorldSpace = Vector3.new(0, 2.8, 0)
		billboardGui.AlwaysOnTop = true
		billboardGui.LightInfluence = 0
		billboardGui.ResetOnSpawn = false
		local textLabel = Instance.new("TextLabel", billboardGui)
		textLabel.Size = UDim2.new(1, 0, 0, 18)
		textLabel.BackgroundTransparency = 1
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextSize = 14
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel.TextStrokeTransparency = 0.4
		textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		textLabel.Text = arg.Name
		local textLabel2 = Instance.new("TextLabel", billboardGui)
		textLabel2.Name = "ToolLabel"
		textLabel2.Size = UDim2.new(1, 0, 0, 13)
		textLabel2.Position = UDim2.new(0, 0, 0, 18)
		textLabel2.BackgroundTransparency = 1
		textLabel2.Font = Enum.Font.GothamMedium
		textLabel2.TextSize = 11
		textLabel2.TextColor3 = Color3.fromRGB(190, 100, 255)
		textLabel2.TextStrokeTransparency = 0.4
		textLabel2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		textLabel2.Text = slicedfn7(arg) or ""
		return billboardGui, textLabel
	end

	local function slicedfn9(arg)
		if arg == localPlayer3 then return end
		local humanoidRootPart = arg.Character and arg.Character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then return end
		local humanoid = arg.Character:FindFirstChild("Humanoid")
		if humanoid then humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
		local userId = arg.UserId
		local slicedv5 = slicedtbl2[userId]
		if not slicedv5 or not slicedv5.bb or not slicedv5.bb.Parent then
			if slicedv5 and slicedv5.bb then
				pcall(function()
					slicedv5.bb:Destroy()
				end)
			end
			local slicedv6, slicedv7 = slicedfn8(arg)
			slicedv6.Adornee = humanoidRootPart
			slicedv6.Parent = humanoidRootPart
			slicedtbl2[userId] = { bb = slicedv6, nameLbl = slicedv7, player = arg }
		elseif slicedv5.bb.Adornee ~= humanoidRootPart then
			slicedv5.bb.Adornee = humanoidRootPart
			slicedv5.bb.Parent = humanoidRootPart
		end
	end

	local function slicedfn10()
		for k, slicedv5 in pairs(slicedtbl2) do
			if slicedv5.bb then pcall(slicedv5.bb.Destroy, slicedv5.bb) end
			slicedtbl2[k] = nil
		end
	end
	_G.StickyOnBoot(function()
		while true do
			task.wait(0.5)
			if playerESP then
				for _, player in ipairs(Players:GetPlayers()) do
					if player == localPlayer3 then continue end
					pcall(slicedfn9, player)
				end
				for _, slicedv5 in pairs(slicedtbl2) do
					if slicedv5.bb and slicedv5.bb.Parent then
						pcall(function()
							local toolLabel = slicedv5.bb:FindFirstChild("ToolLabel")
							if toolLabel then
								local slicedv6 = slicedfn7(slicedv5.player)
								toolLabel.Text = slicedv6 or ""
								if slicedv5.nameLbl then slicedv5.nameLbl.TextColor3 = slicedv6 and slicedtbl3[slicedv6] and Color3.fromRGB(174, 60, 255) or Color3.fromRGB(255, 255, 255) end
							end
						end)
					end
				end
			else
				slicedfn10()
			end
		end
	end)

	_G.setPlayerESP = function(arg)
		playerESP = arg and true or false
		slicedv3.PlayerESP = playerESP
		slicedv4()
		slicedfn2("PlayerESP", playerESP)
		slicedfn2("Player ESP", playerESP)
		if not playerESP then pcall(slicedfn10) end
	end
	_G.StickyOnBoot(function()
		if slicedv3.XRay == true then pcall(setXRay, true) end
		slicedfn2("PlayerESP", playerESP)
	end)
end

local slicedv3 = slicedv2
local slicedv4 = fn
local slicedfn2

slicedfn2 = function(arg, slicedarg2)
	local slicedzSyncToggleUI = _G.SlicedzSyncToggleUI
	if type(slicedzSyncToggleUI) == "function" then pcall(slicedzSyncToggleUI, arg, slicedarg2) end
end

do
	local function slicedfn3()
		if _G.__NextBaseCleanup then pcall(_G.__NextBaseCleanup) end
		local CoreGui = game:GetService("CoreGui")
		local plots = workspace:WaitForChild("Plots")
		local slicedtbl2 = {
			Vector3.new(-342.439, 10.399, 113.107),
			Vector3.new(-342.439, 10.465, 6.107),
			Vector3.new(-476.752, 10.465, 114.107),
			Vector3.new(-476.752, 10.465, 7.107),
			Vector3.new(-342.44, 10.464, 220.107),
			Vector3.new(-476.752, 10.465, 221.107),
			Vector3.new(-342.439, 10.465, -100.893),
			Vector3.new(-476.752, 10.465, -99.893),
		}
		local n = 6
		local str = "Empty Base"
		local slicedv5 = utf8.char(11015)

		local function slicedfn4(arg)
			local ok, result = pcall(function()
				return (arg:GetBoundingBox())
			end)
			if not ok then return nil end
			local position = result.Position
			local slicedv6 = nil
			local slicedv7 = nil
			for i, slicedv8 in ipairs(slicedtbl2) do
				local slicedn2 = position.X - slicedv8.X
				local slicedn3 = position.Z - slicedv8.Z
				local slicedv9 = math.sqrt(slicedn2 * slicedn2 + slicedn3 * slicedn3)
				if not slicedv6 or slicedv9 < slicedv6 then
					slicedv6 = slicedv9
					slicedv7 = i
				end
			end
			return slicedv6 and slicedv6 <= n and slicedv7 or nil
		end
		local slicedtbl3 = {}
		local slicedtbl4 = {}
		local slicedtbl5 = {}
		local part = Instance.new("Part")
		part.Name = "__NextBaseAnchor"
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.Transparency = 1
		part.Size = Vector3.one
		part.Parent = CoreGui
		local billboardGui = Instance.new("BillboardGui")
		billboardGui.Name = "NextBaseBillboard"
		billboardGui.Adornee = part
		billboardGui.Size = UDim2.fromScale(32, 13)
		billboardGui.StudsOffset = Vector3.new(0, 10, 0)
		billboardGui.MaxDistance = math.huge
		billboardGui.AlwaysOnTop = true
		billboardGui.LightInfluence = 0
		billboardGui.Enabled = false
		billboardGui.Parent = part
		local textLabel = Instance.new("TextLabel", billboardGui)
		textLabel.BackgroundTransparency = 1
		textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		textLabel.Position = UDim2.fromScale(0.5, 0.3)
		textLabel.Size = UDim2.fromScale(0.95, 0.5)
		textLabel.Font = Enum.Font.GothamBlack
		textLabel.Text = slicedv5 .. "  NEXT  " .. slicedv5
		textLabel.TextScaled = true
		textLabel.TextColor3 = Color3.fromRGB(174, 60, 255)
		textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		textLabel.TextStrokeTransparency = 0
		local textLabel2 = Instance.new("TextLabel", billboardGui)
		textLabel2.BackgroundTransparency = 1
		textLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
		textLabel2.Position = UDim2.fromScale(0.5, 0.72)
		textLabel2.Size = UDim2.fromScale(0.95, 0.42)
		textLabel2.Font = Enum.Font.GothamBlack
		textLabel2.Text = "EMPTY BASE"
		textLabel2.TextScaled = true
		textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		textLabel2.TextStrokeTransparency = 0
		local function slicedfn5(arg) return arg.Text:gsub("^%s+", ""):gsub("%s+$", "") == str end

		local function slicedfn6()
			local slicedv6 = nil
			for i = 1, #slicedtbl2 do
				local slicedv7 = slicedtbl3[i]
				if slicedv7 and slicedv7.label and slicedfn5(slicedv7.label) then
					slicedv6 = i
					break
				else
					slicedv6 = nil
				end
			end
			if slicedv6 then
				part.CFrame = slicedtbl3[slicedv6].cf
				billboardGui.Enabled = true
			else
				billboardGui.Enabled = false
			end
		end

		local function slicedfn7(arg)
			if slicedtbl4[arg] then return end
			slicedtbl4[arg] = true
			table.insert(slicedtbl5, arg:GetPropertyChangedSignal("Text"):Connect(slicedfn6))
		end

		local function slicedfn8()
			for _, child in ipairs(plots:GetChildren()) do
				local plotSign = child:FindFirstChild("PlotSign")
				local model = plotSign and plotSign:FindFirstChild("Model")
				plotSign = plotSign and plotSign:FindFirstChild("SurfaceGui")
				plotSign = plotSign and plotSign:FindFirstChild("Frame")
				plotSign = plotSign and plotSign:FindFirstChild("TextLabel")
				if model and plotSign then
					local slicedv6 = slicedfn4(model)
					if slicedv6 then
						slicedtbl3[slicedv6] = { label = plotSign, cf = select(1, model:GetBoundingBox()) }
						slicedfn7(plotSign)
					end
				end
			end
			slicedfn6()
		end
		slicedfn8()
		table.insert(slicedtbl5, plots.DescendantAdded:Connect(function(descendant)
			if descendant:IsA("TextLabel") then task.defer(slicedfn8) end
		end))
		table.insert(slicedtbl5, plots.ChildAdded:Connect(function()
			task.defer(slicedfn8)
		end))

		_G.__NextBaseCleanup = function()
			for _, slicedv6 in ipairs(slicedtbl5) do
				pcall(function()
					slicedv6:Disconnect()
				end)
			end
			if part then part:Destroy() end
			_G.__NextBaseCleanup = nil
		end
	end

	local function setNextBase(arg)
		local nextBaseEnabled = arg and true or false
		slicedv3.nextBaseEnabled = nextBaseEnabled
		slicedv4()
		slicedfn2("NextBase", nextBaseEnabled)
		slicedfn2("Next Base", nextBaseEnabled)
		slicedfn2("Base Pointer", nextBaseEnabled)
		if nextBaseEnabled then
			task.spawn(function()
				pcall(slicedfn3)
			end)
		elseif _G.__NextBaseCleanup then
			pcall(_G.__NextBaseCleanup)
		end
	end
	_G.setNextBase = setNextBase
	_G.StickyOnBoot(function()
		if slicedv3.nextBaseEnabled then pcall(setNextBase, true) end
	end)
end

do
	local function slicedfn3()
		if _G.__PodiumESPCleanup then pcall(_G.__PodiumESPCleanup) end
		local RunService = game:GetService("RunService")
		local hui = gethui and gethui() or game:GetService("CoreGui")
		local plots = workspace:FindFirstChild("Plots")
		if not plots then return end
		local function slicedfn4() return workspace.CurrentCamera end
		if not slicedfn4() then return end
		local color = Color3.fromRGB(174, 60, 255)
		local color2 = Color3.fromRGB(255, 255, 255)
		local flag = true
		local slicedflag2 = true
		local n = 0.05
		local slicedn2 = 2
		local slicedn3 = 0.12
		local slicedtbl2 = {
			{ 18.5, 1.531, -14.476, 90 },
			{ 18.5, 1.531, -6.976, 90 },
			{ 18.5, 1.531, 0.524, 90 },
			{ 18.5, 1.531, 8.024, 90 },
			{ 18.5, 1.531, 15.524, 90 },
			{ -18.536, 1.531, 15.524, -90 },
			{ -18.536, 1.531, 8.024, -90 },
			{ -18.536, 1.531, 0.524, -90 },
			{ -18.536, 1.531, -6.976, -90 },
			{ -18.536, 1.531, -14.476, -90 },
			{ 18.5, 19.531, -14.476, 90 },
			{ 18.5, 19.531, -6.976, 90 },
			{ 18.5, 19.531, 0.524, 90 },
			{ 18.5, 19.531, 8.024, 90 },
			{ 18.5, 19.531, 15.524, 90 },
			{ -18.38, 19.531, -14.452, -90 },
			{ -18.38, 19.531, -6.952, -90 },
			{ -18.38, 19.531, 0.548, -90 },
			{ 18.5, 36.531, -12.476, 90 },
			{ 18.5, 36.531, -4.976, 90 },
			{ 18.5, 36.531, 2.524, 90 },
			{ 18.5, 36.531, 10.024, 90 },
			{ 18.5, 36.531, 17.524, 90 },
			{ -18.472, 36.531, -12.501, -90 },
			{ -18.471, 36.531, -5.001, -90 },
			{ -18.471, 36.531, 2.499, -90 },
			{ -18.471, 36.531, 9.999, -90 },
			{ -18.471, 36.531, 17.499, -90 },
		}
		local slicedv5 = Random.new(os.clock() * 1000000)
		local slicedtbl3 = {
			"Part",
			"Mesh",
			"MeshPart",
			"Union",
			"Wedge",
			"Cylinder",
			"Model",
			"Frame",
			"Handle",
			"Body",
			"Root",
		}
		local function slicedfn5() return slicedtbl3[slicedv5:NextInteger(1, #slicedtbl3)] end
		local slicedtbl4 = {}
		local slicedtbl5 = {}
		local slicedtbl6 = {}
		local slicedtbl7 = {}
		local slicedtbl8 = {}
		local slicedtbl9 = {}
		local slicedv6 = nil
		local slicedflag3 = true
		local slicedflag4 = false

		local function slicedfn6(arg)
			slicedtbl4[#slicedtbl4 + 1] = arg
			arg.Parent = hui
			return arg
		end

		local function slicedfn7()
			for _, slicedv7 in ipairs(slicedtbl4) do
				pcall(function()
					slicedv7:Destroy()
				end)
			end
			table.clear(slicedtbl4)
			table.clear(slicedtbl5)
			for _, slicedv7 in ipairs(slicedtbl7) do
				pcall(function()
					slicedv7:Destroy()
				end)
			end
			table.clear(slicedtbl7)
			for _, slicedv7 in ipairs(slicedtbl8) do
				pcall(function()
					slicedv7:Destroy()
				end)
			end
			table.clear(slicedtbl8)
			table.clear(slicedtbl9)
			slicedv6 = nil
		end

		local function createBoxHandleAdornment(adornee, cFrame, size, color3, transparency, arg)
			local boxHandleAdornment = Instance.new("BoxHandleAdornment")
			boxHandleAdornment.Adornee = adornee
			boxHandleAdornment.Size = size
			boxHandleAdornment.CFrame = cFrame
			boxHandleAdornment.Color3 = color3
			boxHandleAdornment.Transparency = transparency
			boxHandleAdornment.AlwaysOnTop = true
			boxHandleAdornment.ZIndex = 0
			slicedfn6(boxHandleAdornment)
			if arg then slicedtbl5[#slicedtbl5 + 1] = { a = boxHandleAdornment, base = transparency } end
			return boxHandleAdornment
		end

		local function slicedfn8(arg, slicedarg2, slicedarg3, slicedarg4)
			local slicedn4 = n * 1.6
			local slicedn5 = slicedarg3.X * 0.5
			local slicedn6 = slicedarg3.Z * 0.5
			local slicedn7 = slicedarg3.Y * 0.5
			createBoxHandleAdornment(arg, slicedarg2 * CFrame.new(0, slicedn7, slicedn6), Vector3.new(slicedarg3.X, slicedn4, slicedn4), slicedarg4, 0)
			createBoxHandleAdornment(arg, slicedarg2 * CFrame.new(0, slicedn7, -slicedn6), Vector3.new(slicedarg3.X, slicedn4, slicedn4), slicedarg4, 0)
			createBoxHandleAdornment(arg, slicedarg2 * CFrame.new(slicedn5, slicedn7, 0), Vector3.new(slicedn4, slicedn4, slicedarg3.Z), slicedarg4, 0)
			createBoxHandleAdornment(arg, slicedarg2 * CFrame.new(-slicedn5, slicedn7, 0), Vector3.new(slicedn4, slicedn4, slicedarg3.Z), slicedarg4, 0)
		end

		local function createPart(cFrame, arg)
			local slicedv7 = slicedfn4()
			if not slicedv7 then return nil end
			local part = Instance.new("Part")
			part.Name = slicedfn5()
			part.Anchored = true
			part.CanCollide = arg and true or false
			part.CanQuery = false
			part.CanTouch = false
			part.CastShadow = false
			part.Massless = true
			part.Transparency = 1
			part.Size = arg and Vector3.new(6, 0.25, 6) or Vector3.new(0.1, 0.1, 0.1)
			part.CFrame = cFrame
			part.Parent = slicedv7
			if arg then
				slicedtbl7[#slicedtbl7 + 1] = part
			else
				slicedtbl8[#slicedtbl8 + 1] = part
			end
			return part
		end

		local function slicedfn9(arg, adornee, slicedarg2, color3)
			if not flag then return end
			local billboardGui = Instance.new("BillboardGui")
			billboardGui.Adornee = adornee
			billboardGui.Size = UDim2.new(2.2, 20, 1.35, 12)
			billboardGui.StudsOffset = Vector3.new(0, 3.2, 0)
			billboardGui.AlwaysOnTop = true
			billboardGui.LightInfluence = 0
			billboardGui.MaxDistance = 400
			billboardGui.Enabled = false
			local frame = Instance.new("Frame", billboardGui)
			frame.Size = UDim2.fromScale(1, 1)
			frame.BackgroundColor3 = Color3.fromRGB(10, 8, 12)
			frame.BackgroundTransparency = 0.55
			frame.BorderSizePixel = 0
			Instance.new("UICorner", frame).CornerRadius = UDim.new(0.3, 0)
			local uiStroke = Instance.new("UIStroke", frame)
			uiStroke.Color = color3
			uiStroke.Thickness = 4
			uiStroke.Transparency = 0.7
			uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			local textLabel = Instance.new("TextLabel", frame)
			textLabel.Size = UDim2.fromScale(1, 1)
			textLabel.BackgroundTransparency = 1
			textLabel.Text = tostring(slicedarg2)
			textLabel.Font = Enum.Font.GothamBlack
			textLabel.TextScaled = true
			textLabel.TextColor3 = color2
			local uiPadding = Instance.new("UIPadding", textLabel)
			uiPadding.PaddingLeft = UDim.new(0.1, 0)
			uiPadding.PaddingRight = UDim.new(0.1, 0)
			uiPadding.PaddingTop = UDim.new(0.08, 0)
			uiPadding.PaddingBottom = UDim.new(0.08, 0)
			local uiTextSizeConstraint = Instance.new("UITextSizeConstraint", textLabel)
			uiTextSizeConstraint.MaxTextSize = 500
			uiTextSizeConstraint.MinTextSize = 6
			local uiStroke2 = Instance.new("UIStroke", textLabel)
			uiStroke2.Color = color3
			uiStroke2.Thickness = 2
			uiStroke2.LineJoinMode = Enum.LineJoinMode.Round
			slicedfn6(billboardGui)
			slicedtbl9[arg] = slicedtbl9[arg] or {}
			table.insert(slicedtbl9[arg], billboardGui)
		end

		local function slicedfn10()
			if not slicedflag3 then return end
			slicedfn7()
			for _, child in ipairs(plots:GetChildren()) do
				local mainRoot = child:FindFirstChild("MainRoot")
				if mainRoot then
					for i = 1, #slicedtbl2 do
						local slicedv7 = slicedtbl2[i]
						local cframe = CFrame.Angles
						local slicedn4 = mainRoot.CFrame * (CFrame.new(slicedv7[1], slicedv7[2], slicedv7[3]) * cframe(0, math.rad(slicedv7[4]), 0))
						local slicedv8 = createPart(slicedn4, false)
						if slicedv8 then
							createBoxHandleAdornment(slicedv8, CFrame.new(), Vector3.new(6, 0.25, 6), color, 0.55, true)
							createBoxHandleAdornment(slicedv8, CFrame.new(0, 0.25, 0), Vector3.new(4, 0.25, 4), color, 0.42, true)
							slicedfn8(slicedv8, CFrame.new(), Vector3.new(6, 0.25, 6), color)
							if slicedflag2 then createPart(slicedn4, true) end
							slicedfn9(child, slicedv8, i, color)
						end
					end
				end
			end
		end

		local function slicedfn11()
			local character = localPlayer2.Character
			local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
			if not humanoidRootPart then return nil end
			local position = humanoidRootPart.Position
			local huge = math.huge
			local slicedv7 = nil
			for _, child in ipairs(plots:GetChildren()) do
				local mainRoot = child:FindFirstChild("MainRoot")
				if mainRoot then
					local magnitude = (mainRoot.Position - position).Magnitude
					if magnitude < huge then
						huge = magnitude
						slicedv7 = child
					end
				end
			end
			if huge > 100 then return nil end
			return slicedv7
		end

		local function slicedfn12()
			local slicedv7 = slicedfn11()
			if slicedv7 == slicedv6 then return end
			slicedv6 = slicedv7
			for k, slicedv8 in pairs(slicedtbl9) do
				local enabled = k == slicedv6
				for _, slicedv9 in ipairs(slicedv8) do if slicedv9 and slicedv9.Parent then slicedv9.Enabled = enabled end end
			end
		end

		local function slicedfn13()
			local slicedv7 = slicedflag4
			local slicedflag5
			if slicedflag4 then
				slicedflag5 = slicedv7
			else
				slicedflag5 = not slicedflag3
			end
			if slicedflag5 then return end
			slicedflag4 = true
			task.delay(0.4, function()
				slicedflag4 = false
				if not slicedflag3 then return end
				pcall(slicedfn10)
				pcall(slicedfn12)
			end)
		end
		slicedfn10()
		slicedfn12()
		local function slicedfn14(arg) if not arg:FindFirstChild("MainRoot") then if arg:WaitForChild("MainRoot", 30) and slicedflag3 then slicedfn13() end end end
		for _, child in ipairs(plots:GetChildren()) do task.spawn(slicedfn14, child) end
		table.insert(slicedtbl6, plots.ChildAdded:Connect(function(child)
			task.spawn(slicedfn14, child)
			slicedfn13()
		end))
		table.insert(slicedtbl6, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
			if slicedflag3 then slicedfn13() end
		end))
		local slicedn4 = 0
		local slicedn5 = 0
		table.insert(slicedtbl6, RunService.Heartbeat:Connect(function(deltaTime)
			local slicedn6 = slicedn5 + deltaTime
			slicedn4 += deltaTime
			slicedn5 = slicedn6
			if slicedn4 >= 0.05 then
				slicedn4 = 0
				local slicedn7 = math.sin(os.clock() * slicedn2) * slicedn3
				for _, slicedv7 in ipairs(slicedtbl5) do if slicedv7.a.Parent then slicedv7.a.Transparency = math.clamp(slicedv7.base + slicedn7, 0, 1) end end
			end
			if slicedn5 >= 0.5 then
				slicedn5 = 0
				slicedfn12()
			end
		end))

		_G.__PodiumESPCleanup = function()
			slicedflag3 = false
			for _, slicedv7 in ipairs(slicedtbl6) do
				pcall(function()
					slicedv7:Disconnect()
				end)
			end
			table.clear(slicedtbl6)
			slicedfn7()
			_G.__PodiumESPCleanup = nil
		end
	end

	local function setPodiumESP(arg)
		local podiumESP = arg and true or false
		slicedv3.podiumESP = podiumESP
		slicedv4()
		slicedfn2("PodiumESP", podiumESP)
		slicedfn2("Podium ESP", podiumESP)
		if podiumESP then
			task.spawn(function()
				pcall(slicedfn3)
			end)
		elseif _G.__PodiumESPCleanup then
			pcall(_G.__PodiumESPCleanup)
		end
	end
	_G.setPodiumESP = setPodiumESP
	_G.StickyOnBoot(function()
		if slicedv3.podiumESP then pcall(setPodiumESP, true) end
	end)
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local slicedv5

do
	local Workspace = game:GetService("Workspace")
	slicedv5 = localPlayer2

	local function slicedfn3(arg, ...)
		local slicedv6 = table.pack(...)
		for i = 1, select("#", ...), 2 do arg[select(i, table.unpack(slicedv6, 1, slicedv6.n))] = select(i + 1, table.unpack(slicedv6, 1, slicedv6.n)) end
		return arg
	end
	local slicedtbl2 = {
		new = function(arg, parent, ...)
			local instance = Instance.new(arg)
			slicedfn3(instance, ...)
			if parent then instance.Parent = parent end
			return instance
		end,
		corner = function(arg, slicedarg2)
			Instance.new("UICorner", arg).CornerRadius = UDim.new(0, slicedarg2 or 4)
			return arg
		end,
		stroke = function(arg, color, thickness, transparency)
			local uiStroke = Instance.new("UIStroke", arg)
			uiStroke.Color = color
			uiStroke.Thickness = thickness or 1
			uiStroke.Transparency = transparency or 0
			return uiStroke
		end,
	}
	local slicedtbl3 = {}
	local flag = false
	local find = string.find
	local slicedtbl4 = { "trap", "mine", "hive" }
	local slicedtbl5 = {
		turret = { color = Color3.fromRGB(255, 40, 40), text = "TURRET" },
		trap = { color = Color3.fromRGB(255, 150, 20), text = "TRAP" },
		mine = { color = Color3.fromRGB(167, 142, 255), text = "SUBSPACE MINE" },
	}

	local function slicedfn4(arg)
		local str = arg:lower()
		if find(str, "sentrybullet", 1, true) then return nil end
		if find(str, "tripmine", 1, true) then return "mine" end
		if find(str, "sentry", 1, true) then return "turret" end
		for _, slicedv6 in ipairs(slicedtbl4) do if find(str, slicedv6, 1, true) then return "trap" end end
		return nil
	end

	local function slicedfn5(parent, arg)
		local slicedv6 = slicedtbl5[arg]
		local str = "! " .. slicedv6.text .. " !"
		if arg == "mine" then
			local match = parent.Name:match("SubspaceTripmine(.+)")
			if match then
				local slicedv7 = Players:FindFirstChild(match)
				str = "! " .. (slicedv7 and slicedv7.DisplayName or match) .. "'s MINE !"
			end
		end
		local highlight
		if parent:IsA("Model") then
			highlight = Instance.new("Highlight")
			slicedfn3(highlight, "Name", "Sticky_HazardESP_HL", "Adornee", parent, "FillColor", slicedv6.color, "FillTransparency", 0.25, "OutlineColor", Color3.fromRGB(255, 255, 255), "OutlineTransparency", 0)
			highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			highlight.Parent = parent
		else
			highlight = Instance.new("SelectionBox")
			slicedfn3(highlight, "Name", "Sticky_HazardESP_HL", "Adornee", parent, "Color3", slicedv6.color, "LineThickness", 0.12, "SurfaceColor3", slicedv6.color, "SurfaceTransparency", 0.6, "Parent", parent)
		end
		local isBasePart = parent:IsA("BasePart") and parent or parent:FindFirstChildWhichIsA("BasePart", true) or parent
		local billboardGui = Instance.new("BillboardGui")
		slicedfn3(billboardGui, "Name", "Sticky_HazardESP_Label", "Adornee", isBasePart, "Size", UDim2.new(0, 200, 0, 44), "StudsOffset", Vector3.new(0, 6, 0), "AlwaysOnTop", true, "Parent", parent)
		local color = slicedv6.color
		local gothamBold = Enum.Font.GothamBold
		slicedtbl2.new("TextLabel", billboardGui, "Size", UDim2.new(1, 0, 1, 0), "BackgroundTransparency", 1, "Text", str, "TextColor3", color, "TextStrokeColor3", Color3.fromRGB(0, 0, 0), "TextStrokeTransparency", 0, "Font", gothamBold, "TextScaled", true)
		return { hl = highlight, bb = billboardGui, kind = arg }
	end

	local function slicedfn6(arg, slicedarg2)
		if slicedarg2.hl and slicedarg2.hl.Parent then
			pcall(function()
				slicedarg2.hl:Destroy()
			end)
		end
		if slicedarg2.bb and slicedarg2.bb.Parent then
			pcall(function()
				slicedarg2.bb:Destroy()
			end)
		end
		slicedtbl3[arg] = nil
	end

	local function slicedfn7()
		local slicedtbl6 = { turret = slicedv3.TurretESP == true, trap = slicedv3.TrapESP == true, mine = slicedv3.TrapESP == true }
		local slicedtbl7 = {}
		if slicedtbl6.turret or slicedtbl6.trap or slicedtbl6.mine then
			local descendants = workspace:GetDescendants()
			for i = 1, #descendants do
				local slicedv6 = descendants[i]
				if slicedv6.ClassName == "Model" or slicedv6:IsA("BasePart") then
					local slicedv7 = slicedfn4(slicedv6.Name)
					if slicedv7 and slicedtbl6[slicedv7] then
						local slicedflag2 = false
						local parent
						if slicedv6:FindFirstChildWhichIsA("Humanoid", true) then
							slicedflag2 = true
							parent = slicedv6
						else
							parent = slicedv6
						end
						while true do
							if not slicedflag2 and parent and parent ~= workspace then
								if Players:GetPlayerFromCharacter(parent) or parent.ClassName == "Model" and parent:FindFirstChildOfClass("Humanoid") then
									slicedflag2 = true
									break
								elseif parent ~= slicedv6 and slicedfn4(parent.Name) then
									slicedflag2 = true
									break
								else
									parent = parent.Parent
									continue
								end
							end
							break
						end
						if not slicedflag2 then
							slicedtbl7[slicedv6] = true
							local slicedv8 = slicedtbl3[slicedv6]
							local slicedv9
							if slicedv8 and slicedv8.kind ~= slicedv7 then
								slicedfn6(slicedv6, slicedv8)
								slicedv9 = nil
							else
								slicedv9 = slicedv8
							end
							if not slicedv9 then
								local ok, result = pcall(slicedfn5, slicedv6, slicedv7)
								if ok then slicedtbl3[slicedv6] = result end
							end
						end
					end
				end
			end
		end
		for k, slicedv6 in pairs(slicedtbl3) do if not slicedtbl7[k] or not k.Parent then slicedfn6(k, slicedv6) end end
	end

	local function slicedfn8()
		if flag then return end
		flag = true
		task.spawn(function()
			while true do
				task.wait(tonumber(_G.StickyHazardESPEvery) or 1.5)
				if slicedv3.TurretESP == true or slicedv3.TrapESP == true then
					pcall(slicedfn7)
					continue
				end
				if next(slicedtbl3) == nil then continue end
				pcall(slicedfn7)
			end
		end)
	end

	local function setTurretESP(arg)
		local turretESP = arg and true or false
		slicedv3.TurretESP = turretESP
		slicedv4()
		slicedfn2("TurretESP", turretESP)
		slicedfn2("Turret ESP", turretESP)
		if turretESP then slicedfn8() end
		task.spawn(function()
			pcall(slicedfn7)
		end)
	end

	local function setTrapESP(arg)
		local trapESP = arg and true or false
		slicedv3.TrapESP = trapESP
		slicedv4()
		slicedfn2("TrapESP", trapESP)
		slicedfn2("Trap ESP", trapESP)
		if trapESP then slicedfn8() end
		task.spawn(function()
			pcall(slicedfn7)
		end)
	end
	_G.setTurretESP = setTurretESP
	_G.setTrapESP = setTrapESP
	_G.StickyOnBoot(function()
		if slicedv3.TurretESP == true or slicedv3.TrapESP == true then slicedfn8() end
	end)
	local slicedtbl6 = {}
	local slicedflag2 = false
	local color = Color3.fromRGB(0, 0, 0)
	local color2 = Color3.fromRGB(255, 255, 255)
	local slicedtbl7 = {}
	local color3 = Color3.fromRGB(255, 215, 0)
	local color4 = Color3.fromRGB(149, 0, 255)
	local color5 = Color3.fromRGB
	slicedtbl7[1] = color3
	slicedtbl7[2] = color4
	do
		local values = table.pack(color5(170, 90, 255))
		table.move(values, 1, values.n, 3, slicedtbl7)
	end
	local color6 = Color3.fromRGB(175, 175, 175)

	local function slicedfn9(arg, slicedarg2)
		local BillboardGui = slicedtbl2.new("BillboardGui", nil, "Name", "BrainrotESP_" .. tostring(arg.uid), "Size", UDim2.new(0, 160, 0, 38), "StudsOffset", Vector3.new(0, 1.8, 0), "AlwaysOnTop", true, "LightInfluence", 0, "MaxDistance", 3000)
		local slicedflag3 = arg.mutation and arg.mutation ~= "None" and arg.mutation ~= "N/A"
		local slicedv6 = slicedarg2 or color2
		local Frame = slicedtbl2.new("Frame", BillboardGui, "Name", "Box", "Size", UDim2.new(1, 0, 1, 0), "BackgroundColor3", color, "BackgroundTransparency", 0.5, "BorderSizePixel", 0)
		slicedtbl2.corner(Frame, 4)
		slicedtbl2.stroke(Frame, slicedv6, 1.5, 0.2)
		slicedtbl2.new("TextLabel", Frame, "Name", "Nm", "Size", UDim2.new(1, -6, 0, 18), "Position", UDim2.new(0, 3, 0, 2), "BackgroundTransparency", 1, "Font", Enum.Font.GothamBlack, "TextSize", 13, "TextColor3", slicedv6, "TextStrokeTransparency", 0, "TextStrokeColor3", color, "Text", arg.name or arg.petName or "???", "TextXAlignment", Enum.TextXAlignment.Center)
		slicedtbl2.new("TextLabel", Frame, "Size", UDim2.new(1, -6, 0, 14), "Position", UDim2.new(0, 3, 0, 20), "BackgroundTransparency", 1, "Font", Enum.Font.GothamBold, "TextSize", 11, "TextColor3", color2, "TextStrokeTransparency", 0, "TextStrokeColor3", color, "Text", arg.genText or "", "TextXAlignment", Enum.TextXAlignment.Center)
		if slicedflag3 then
			slicedtbl2.corner(slicedtbl2.new("TextLabel", BillboardGui, "Name", "Badge", "Size", UDim2.new(0, 60, 0, 14), "Position", UDim2.new(0.5, -30, 0, -16), "BackgroundColor3", slicedv6, "BackgroundTransparency", 0.3, "Font", Enum.Font.GothamBlack, "TextSize", 9, "TextColor3", color2, "TextStrokeTransparency", 0, "TextStrokeColor3", color, "Text", tostring(arg.mutation):upper()), 3)
		end
		return BillboardGui
	end

	local function slicedfn10(arg)
		local bb = arg.bb
		if not bb then return end
		local box = bb:FindFirstChild("Box")
		if box then
			arg.st = box:FindFirstChildOfClass("UIStroke")
			arg.nm = box:FindFirstChild("Nm")
		end
		arg.badge = bb:FindFirstChild("Badge")
	end

	local function slicedfn11(arg, color7)
		if arg.color == color7 then return end
		arg.color = color7
		if arg.st then arg.st.Color = color7 end
		if arg.nm then arg.nm.TextColor3 = color7 end
		if arg.badge then arg.badge.BackgroundColor3 = color7 end
	end

	local function slicedfn12()
		for k, slicedv6 in pairs(slicedtbl6) do
			if slicedv6.bb then
				pcall(function()
					slicedv6.bb:Destroy()
				end)
			end
			slicedtbl6[k] = nil
		end
	end

	local function slicedfn13()
		if slicedv3.BrainrotESP ~= true then return end
		local allAnimalsCache = tbl.AllAnimalsCache
		if not allAnimalsCache or #allAnimalsCache == 0 then return end
		local n = tonumber(slicedv3.BrainrotESPMinGen) or 10000000
		local slicedtbl8 = {}
		local slicedv6, slicedv7, slicedv8 = ipairs(allAnimalsCache)
		local slicedn2 = 0
		for _, slicedv9 in slicedv6, slicedv7, slicedv8 do
			if slicedv9 and slicedv9.uid and slicedv9.genValue and not slicedv9.isWalking and slicedv9.genValue >= n then
				slicedn2 += 1
				slicedtbl8[slicedv9.uid] = slicedn2
				if not (slicedn2 >= 3) then continue end
			else
				continue
			end
			break
		end
		local character = slicedv5.Character
		character = character and character:FindFirstChild("HumanoidRootPart")
		character = character and character.Position
		local slicedtbl9 = {}
		local stickyFindAdornee = _G.StickyFindAdornee
		for _, slicedv9 in ipairs(allAnimalsCache) do
			if slicedv9.genValue ~= nil and not slicedv9.isWalking and slicedv9.genValue >= n then
				slicedtbl9[slicedv9.uid] = true
				local slicedv10 = slicedtbl7[slicedtbl8[slicedv9.uid]] or color6
				local slicedv11 = slicedtbl6[slicedv9.uid]
				if slicedv11 then
					if slicedv11.bb then slicedfn11(slicedv11, slicedv10) end
				else
					local slicedv12 = stickyFindAdornee and stickyFindAdornee(slicedv9)
					if slicedv12 and slicedv12:IsA("BasePart") and (not character or (slicedv12.Position - character).Magnitude <= 3000) then
						local slicedtbl10 = {
							bb = slicedfn3(slicedfn9(slicedv9, slicedv10), "Adornee", slicedv12, "StudsOffset", Vector3.new(0, 1.8, 0), "Parent", slicedv12),
							color = slicedv10,
						}
						slicedfn10(slicedtbl10)
						slicedtbl6[slicedv9.uid] = slicedtbl10
					end
				end
			end
		end
		for k, slicedv9 in pairs(slicedtbl6) do
			if not slicedtbl9[k] then
				if slicedv9.bb then
					pcall(function()
						slicedv9.bb:Destroy()
					end)
				end
				slicedtbl6[k] = nil
			end
		end
	end

	local function slicedfn14()
		if slicedflag2 then return end
		slicedflag2 = true
		task.spawn(function()
			while true do
				task.wait(0.3)
				if slicedv3.BrainrotESP == true then
					local allAnimalsCache = tbl.AllAnimalsCache
					if allAnimalsCache and #allAnimalsCache > 0 then pcall(slicedfn13) end
				end
			end
		end)
	end

	_G.setBrainrotESP = function(arg)
		local brainrotESP = arg and true or false
		slicedv3.BrainrotESP = brainrotESP
		slicedv4()
		slicedfn2("BrainrotESP", brainrotESP)
		slicedfn2("Brainrot ESP", brainrotESP)
		if brainrotESP then
			slicedfn14()
			task.spawn(function()
				pcall(slicedfn13)
			end)
		else
			pcall(slicedfn12)
		end
	end
	_G.StickyOnBoot(function()
		if slicedv3.BrainrotESP == true then slicedfn14() end
	end)
	local slicedtbl8 = { conns = {}, charConn = nil, beat = nil, acs = nil, acsChar = nil, rootAC = nil }
	local slicedflag3 = false

	local function slicedfn15(acsChar)
		if slicedtbl8.acsChar ~= acsChar or not slicedtbl8.acs then
			slicedtbl8.acsChar = acsChar
			slicedtbl8.acs = {}
			slicedtbl8.rootAC = nil
			for _, descendant in ipairs(acsChar:GetDescendants()) do
				if descendant:IsA("AnimationConstraint") then
					table.insert(slicedtbl8.acs, descendant)
					if descendant.Name == "Root" then slicedtbl8.rootAC = descendant end
				end
			end
		end
		for _, slicedv6 in ipairs(slicedtbl8.acs) do if not slicedv6.Enabled and slicedv6.Parent then return true end end
		return false
	end
	local slicedtbl9 = {
		BodyVelocity = true,
		BodyForce = true,
		BodyThrust = true,
		BodyGyro = true,
		BodyAngularVelocity = true,
		VectorForce = true,
		AngularVelocity = true,
		RocketPropulsion = true,
	}
	local slicedtbl10 = {
		SpeedForce = true,
		InvisSpeedForce = true,
		JumpForce = true,
		FlightPower = true,
		FlightSpin = true,
		FlightHold = true,
	}

	local function slicedfn16(arg)
		if _G.StickyCarpetFlightAware == false then return false end
		arg = arg and arg:FindFirstChild("HumanoidRootPart")
		if not arg then return false end
		return arg:FindFirstChild("FlightPower") ~= nil or arg:FindFirstChild("FlightSpin") ~= nil or arg:FindFirstChild("FlightHold") ~= nil
	end

	local function slicedfn17(arg)
		if slicedtbl10[arg.Name] then return false end
		local className = arg.ClassName
		local slicedflag4 = slicedtbl9[className]
		if not slicedflag4 and className == "LinearVelocity" then slicedflag4 = true end
		local slicedflag5 = not slicedflag4
		if slicedflag5 then slicedflag5 = className:find("Force") or className:find("Velocity") or className:find("Body") or className:find("Propulsion") end
		if slicedflag5 then slicedflag5 = arg.Name:find("Impulse") or arg.Name:find("Knockback") or arg.Name:find("Launch") end
		if slicedflag5 then slicedflag4 = true end
		if slicedflag4 then
			pcall(function()
				arg:Destroy()
			end)
			return true
		end
		return false
	end

	local function slicedfn18(arg)
		local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
		local slicedflag4 = false
		if humanoidRootPart then for _, child in ipairs(humanoidRootPart:GetChildren()) do slicedflag4 = slicedfn17(child) or slicedflag4 end end
		for _, child in ipairs(arg:GetChildren()) do slicedflag4 = slicedfn17(child) or slicedflag4 end
		return slicedflag4
	end
	local slicedflag4 = true

	local function slicedfn19(arg)
		if slicedflag4 == arg then return end
		slicedflag4 = arg
		pcall(function()
			local playerScripts = slicedv5:FindFirstChild("PlayerScripts")
			playerScripts = playerScripts and playerScripts:FindFirstChild("PlayerModule")
			if playerScripts then
				local controls = require(playerScripts):GetControls()
				if arg then
					controls:Enable()
				else
					controls:Disable()
				end
			end
		end)
	end

	local function stickyUnRagdoll(arg)
		local character = arg or slicedv5.Character
		if not character then return end
		pcall(function()
			local attribute = slicedv5:GetAttribute("RagdollEndTime")
			if attribute and attribute - Workspace:GetServerTimeNow() > 0 then _G.StickyRagdollUntil = attribute end
			slicedv5:SetAttribute("RagdollEndTime", 0)
		end)
		local slicedv6 = nil
		for _, descendant in ipairs(character:GetDescendants()) do
			if descendant:IsA("BallSocketConstraint") or descendant:IsA("HingeConstraint") or descendant:IsA("NoCollisionConstraint") then
				pcall(function()
					descendant:Destroy()
				end)
			elseif descendant:IsA("Motor6D") and not descendant.Enabled then
				pcall(function()
					descendant.Enabled = true
				end)
			elseif descendant:IsA("AnimationConstraint") then
				if not descendant.Enabled then
					pcall(function()
						descendant.Enabled = true
					end)
				end
				if slicedv6 == nil and descendant.Name == "Root" then slicedv6 = descendant end
			end
		end
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		local rootRigAttachment = humanoidRootPart and humanoidRootPart:FindFirstChild("RootRigAttachment")
		if rootRigAttachment and slicedv6 then
			if slicedv6.Attachment0 == nil or slicedv6.Attachment0.Parent == nil then
				pcall(function()
					slicedv6.Attachment0 = rootRigAttachment
				end)
			end
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			pcall(function()
				if humanoid.PlatformStand then humanoid.PlatformStand = false end
			end)
			local state = humanoid:GetState()
			if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.PlatformStanding then
				pcall(function()
					humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
				end)
			end
			pcall(function()
				Workspace.CurrentCamera.CameraSubject = humanoid
			end)
		end
		slicedfn19(true)
	end
	_G.StickyUnRagdoll = stickyUnRagdoll

	local function slicedfn20()
		if typeof(getconnections) ~= "function" then return end
		pcall(function()
			local packages = ReplicatedStorage:FindFirstChild("Packages")
			local net = packages and packages:FindFirstChild("Net")
			local reRagdoll = nil
			if net then reRagdoll = net:FindFirstChild("RE/Ragdoll") end
			if not reRagdoll then
				reRagdoll = packages and packages:FindFirstChild("Ragdoll")
				reRagdoll = reRagdoll and reRagdoll:FindFirstChild("Ragdoll")
			end
			if reRagdoll and reRagdoll:IsA("RemoteEvent") then
				for _, slicedv6 in ipairs(getconnections(reRagdoll.OnClientEvent)) do
					if not pcall(function()
						slicedv6:Disable()
					end) then
						pcall(function()
							slicedv6:Disconnect()
						end)
					end
				end
			end
		end)
	end

	local function slicedfn21()
		for _, conn in ipairs(slicedtbl8.conns) do
			pcall(function()
				conn:Disconnect()
			end)
		end
		slicedtbl8.conns = {}
	end

	local function slicedfn22(arg)
		if not slicedflag3 or not arg then return end
		slicedfn21()
		slicedfn20()
		stickyUnRagdoll(arg)
		local connection = slicedv5:GetAttributeChangedSignal("RagdollEndTime"):Connect(function()
			if not slicedflag3 then return end
			local attribute = slicedv5:GetAttribute("RagdollEndTime")
			if attribute and attribute - Workspace:GetServerTimeNow() > 0 then stickyUnRagdoll(slicedv5.Character) end
		end)
		table.insert(slicedtbl8.conns, connection)
		local humanoid = arg:FindFirstChildOfClass("Humanoid")
		if humanoid then
			local connection2 = humanoid.StateChanged:Connect(function(old, new)
				if not slicedflag3 then return end
				if new == Enum.HumanoidStateType.Physics or new == Enum.HumanoidStateType.Ragdoll or new == Enum.HumanoidStateType.PlatformStanding then
					stickyUnRagdoll(slicedv5.Character)
				end
			end)
			table.insert(slicedtbl8.conns, connection2)
		end
		local slicedflag5 = false
		local connection2 = arg.DescendantAdded:Connect(function(descendant)
			if not slicedflag3 then return end
			if descendant:IsA("BallSocketConstraint") or descendant:IsA("HingeConstraint") or descendant:IsA("NoCollisionConstraint") then
				if slicedflag5 then return end
				slicedflag5 = true
				task.defer(function()
					slicedflag5 = false
					stickyUnRagdoll(slicedv5.Character)
				end)
			end
		end)
		table.insert(slicedtbl8.conns, connection2)
	end

	local function slicedfn23()
		slicedflag3 = false
		slicedfn21()
		if slicedtbl8.charConn then
			pcall(function()
				slicedtbl8.charConn:Disconnect()
			end)
			slicedtbl8.charConn = nil
		end
		if slicedtbl8.beat then
			pcall(function()
				slicedtbl8.beat:Disconnect()
			end)
			slicedtbl8.beat = nil
		end
	end

	local function slicedfn24(arg)
		slicedfn23()
		slicedflag3 = arg and true or false
		if not slicedflag3 then return end
		if slicedv5.Character then
			task.spawn(function()
				slicedfn22(slicedv5.Character)
			end)
		end
		slicedtbl8.charConn = slicedv5.CharacterAdded:Connect(function(character)
			if not slicedflag3 then return end
			pcall(function()
				character:WaitForChild("Humanoid", 10)
			end)
			slicedfn22(character)
			task.spawn(function()
				for i = 1, 12 do
					task.wait(0.25)
					if slicedflag3 then
						slicedfn20()
						continue
					end
					break
				end
			end)
		end)
		local n = 0
		local vector = Vector3.zero
		slicedtbl8.beat = RunService.Heartbeat:Connect(function()
			if not slicedflag3 then return end
			local character = slicedv5.Character
			if not character then return end
			local attribute = slicedv5:GetAttribute("RagdollEndTime")
			local slicedflag5 = attribute ~= nil and attribute - Workspace:GetServerTimeNow() > 0
			local slicedv6 = slicedfn16(character)
			if not slicedflag5 and not slicedv6 then
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					local state = humanoid:GetState()
					slicedflag5 = state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.PlatformStanding or humanoid.PlatformStand == true
				end
			end
			slicedflag5 = slicedflag5 or slicedfn15(character)
			if not _G.invisibleStealEnabled then
				local rootAC = slicedtbl8.rootAC
				if rootAC and rootAC.Parent and (rootAC.Attachment0 == nil or rootAC.Attachment0.Parent == nil) then
					local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
					local rootRigAttachment = humanoidRootPart and humanoidRootPart:FindFirstChild("RootRigAttachment")
					if rootRigAttachment then
						pcall(function()
							rootAC.Attachment0 = rootRigAttachment
						end)
					end
				end
			end
			local slicedflag6
			if not slicedflag5 then
				local now = tick()
				local slicedn2 = now - n
				if not ((tonumber(_G.StickyRagScanInterval) or 0.2) < slicedn2) then
					slicedflag6 = slicedflag5
				else
					n = now
					slicedflag6 = character:FindFirstChildWhichIsA("BallSocketConstraint", true) ~= nil or character:FindFirstChildWhichIsA("HingeConstraint", true) ~= nil
				end
			else
				slicedflag6 = slicedflag5
			end
			if slicedflag6 then _G.StickyRagdollPhysLastT = tick() end
			local stickyTpActive = _G.StickyAntiLaunch ~= false and (slicedflag6 or _G.StickyTpActive)
			local slicedflag7 = false
			if stickyTpActive then slicedflag7 = slicedfn18(character) end
			if slicedflag6 then stickyUnRagdoll(character) end
			if slicedflag6 or slicedflag7 then
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				if humanoidRootPart then
					humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
					if _G.StickyRagdollStayPut ~= false and not _G.StickyTpActive and not _G.StickyDropFlingActive then
						humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
					end
				end
			end
			if slicedv3.AntiRagdoll ~= false and not _G.StickyTpActive and not _G.StickyCarpetSpeedActive and not slicedv6 and not _G.StickyCarpetBuyFlying and not _G.StickyDropFlingActive then
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				if humanoidRootPart then
					local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
					local magnitude = (assemblyLinearVelocity - vector).Magnitude
					if (tonumber(_G.StickyLaunchSpikeThreshold) or 110) < magnitude then
						humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
						humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
						assemblyLinearVelocity = Vector3.zero
					end
					vector = assemblyLinearVelocity
				end
			else
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				vector = humanoidRootPart and humanoidRootPart.AssemblyLinearVelocity or Vector3.zero
			end
		end)
	end

	_G.setAntiRagdoll = function(arg)
		local antiRagdoll = arg and true or false
		slicedv3.AntiRagdoll = antiRagdoll
		slicedv4()
		slicedfn2("AntiRagdoll", antiRagdoll)
		slicedfn2("Anti Ragdoll", antiRagdoll)
		slicedfn24(antiRagdoll)
	end
	_G.StickyOnBoot(function()
		if slicedv3.AntiRagdoll ~= false then pcall(slicedfn24, true) end
	end)
end

do
	local Lighting = game:GetService("Lighting")
	local slicedv6 = slicedv5
	local slicedv7 = ReplicatedStorage
	if _G.StickyAntiBee == nil then _G.StickyAntiBee = slicedv3.AntiBeeDisco ~= false end

	local function slicedfn3()
		local slicedtbl2 = { Blue = true, DiscoEffect = true, BeeBlur = true, Flashbang = true, ColorCorrection = true }
		local function slicedfn4() return _G.StickyAntiBee ~= false end

		local function slicedfn5(descendant)
			if slicedfn4() and descendant and descendant.Parent and slicedtbl2[descendant.Name] then
				pcall(function()
					descendant:Destroy()
				end)
			end
		end
		local slicedv8 = nil

		local function slicedfn6()
			if not slicedfn4() then return end
			pcall(function()
				if not (slicedv8 and slicedv8.Parent) then
					local controllers = slicedv7:FindFirstChild("Controllers")
					local itemController = controllers and controllers:FindFirstChild("ItemController")
					itemController = itemController and itemController:FindFirstChild("BeeLauncherController")
					local buzzing = itemController and itemController:FindFirstChild("Buzzing")
					if buzzing and buzzing:IsA("Sound") then slicedv8 = buzzing end
				end
				if slicedv8 then
					slicedv8.Volume = 0
					if slicedv8.IsPlaying then slicedv8:Stop() end
				end
			end)
		end
		local slicedtbl3 = {}

		local function slicedfn7(arg, slicedarg2)
			if not arg or slicedtbl3[arg] then return end
			local moveFunction = slicedarg2 or arg.moveFunction
			if not moveFunction then return end
			local function moveFunction2(slicedarg3, slicedarg4, slicedarg5) return moveFunction(slicedarg3, slicedarg4, slicedarg5) end
			slicedtbl3[arg] = moveFunction2
			arg.moveFunction = moveFunction2
			RunService.Heartbeat:Connect(function()
				if not slicedfn4() then return end
				if arg.moveFunction ~= moveFunction2 then arg.moveFunction = moveFunction2 end
			end)
		end

		local function slicedfn8()
			pcall(function()
				local controllers = slicedv7:FindFirstChild("Controllers")
				controllers = controllers and controllers:FindFirstChild("CharacterController")
				local module = controllers and require(controllers)
				if type(module) == "table" then slicedfn7(module.Controls, module.originalMoveFunction) end
			end)
			pcall(function()
				local playerScripts = slicedv6:WaitForChild("PlayerScripts", 5)
				playerScripts = playerScripts and playerScripts:FindFirstChild("PlayerModule")
				if playerScripts then slicedfn7(require(playerScripts):GetControls()) end
			end)
		end
		_G.StickyOnBoot(function()
			slicedv6:WaitForChild("PlayerScripts", 8)
			Lighting.DescendantAdded:Connect(slicedfn5)
			local n = 0
			for _, descendant in ipairs(Lighting:GetDescendants()) do
				n += 1
				if n % 150 == 0 then task.wait() end
				slicedfn5(descendant)
			end
			slicedfn8()
			local slicedn2 = 1
			RunService.Heartbeat:Connect(function(deltaTime)
				if not slicedfn4() then return end
				local currentCamera = workspace.CurrentCamera
				if currentCamera and math.abs(currentCamera.FieldOfView - 20) < 0.01 then currentCamera.FieldOfView = tonumber(_G.StickyFOV) or 70 end
				slicedn2 += deltaTime
				if slicedn2 < 0.5 then return end
				slicedn2 = 0
				slicedfn6()
			end)
		end)
		slicedv6.CharacterAdded:Connect(function()
			task.delay(1, slicedfn8)
		end)
	end
	slicedfn3()

	_G.setAntiBeeDisco = function(arg)
		local antiBeeDisco = arg and true or false
		slicedv3.AntiBeeDisco = antiBeeDisco
		_G.StickyAntiBee = antiBeeDisco
		slicedv4()
		slicedfn2("AntiBeeDisco", antiBeeDisco)
		slicedfn2("Anti Bee/Disco", antiBeeDisco)
	end
	if _G.StickyAntiDieDisabled == nil then _G.StickyAntiDieDisabled = slicedv3.AntiDie == false end
	task.spawn(function()
		while not Players.LocalPlayer do task.wait() end
		pcall(function()
			local connection = nil
			local connection2 = nil
			local connection3 = nil
			local function slicedfn4(arg)
				pcall(function()
					arg.BreakJointsOnDeath = false
				end)
				pcall(function()
					arg.RequiresNeck = false
				end)
				pcall(function()
					arg:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
				end)
				pcall(function()
					arg:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
				end)
				pcall(function()
					arg:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
				end)
				pcall(function()
					arg:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
				end)
			end
			local function slicedfn5(arg)
				pcall(function()
					arg.Health = arg.MaxHealth
				end)
				pcall(function()
					arg:ChangeState(Enum.HumanoidStateType.Running)
				end)
			end
			local function slicedfn6()
				local character = slicedv6.Character
				local humanoid = character and character:FindFirstChildOfClass("Humanoid")
				if not humanoid then return end
				slicedfn4(humanoid)
				if connection then
					pcall(function()
						connection:Disconnect()
					end)
				end
				if connection2 then
					pcall(function()
						connection2:Disconnect()
					end)
				end
				if connection3 then
					pcall(function()
						connection3:Disconnect()
					end)
				end
				connection = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
					if _G.StickyAntiDieDisabled then return end
					if humanoid.Health <= 0 then slicedfn5(humanoid) end
				end)
				connection2 = humanoid.Died:Connect(function()
					if _G.StickyAntiDieDisabled then return end
					slicedfn5(humanoid)
				end)
				local n = 0
				connection3 = RunService.Heartbeat:Connect(function()
					if _G.StickyAntiDieDisabled or not humanoid or not humanoid.Parent then return end
					local now = os.clock()
					if now - n >= 0.5 then
						n = now
						slicedfn4(humanoid)
					end
					if humanoid.Health <= 0 then slicedfn5(humanoid) end
					if _G.StickyStealHold and humanoid.Health < humanoid.MaxHealth then
						pcall(function()
							humanoid.Health = humanoid.MaxHealth
						end)
					end
					local parent = humanoid.Parent
					local humanoidRootPart = parent and parent:FindFirstChild("HumanoidRootPart")
					if parent and humanoidRootPart then
						local state = humanoid:GetState()
						local flag = state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
						if not flag then
							local num = tonumber(slicedv6:GetAttribute("RagdollEndTime"))
							if num and num - workspace:GetServerTimeNow() > 0 then flag = true end
						end
						if flag then
							pcall(function()
								slicedv6:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
							end)
							pcall(function()
								humanoid:ChangeState(Enum.HumanoidStateType.Running)
							end)
							if not _G.__stickyResetBusy and slicedv6:GetAttribute("Stealing") ~= true then
								pcall(function()
									humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
								end)
							end
							local currentCamera = workspace.CurrentCamera
							if currentCamera and currentCamera.CameraSubject ~= humanoid then
								pcall(function()
									currentCamera.CameraSubject = humanoid
								end)
							end
							for _, descendant in ipairs(parent:GetDescendants()) do
								if descendant:IsA("BallSocketConstraint") or descendant.Name and descendant.Name:find("RagdollAttachment") then
									pcall(function()
										descendant:Destroy()
									end)
								end
							end
						end
					end
					local dead = Enum.HumanoidStateType.Dead
					if humanoid:GetState() == dead then
						pcall(function()
							humanoid:ChangeState(Enum.HumanoidStateType.Running)
						end)
					end
				end)
			end
			slicedfn6()
			slicedv6.CharacterAdded:Connect(function(character)
				local humanoid = character:WaitForChild("Humanoid", 5)
				if humanoid then slicedfn4(humanoid) end
				task.wait(0.1)
				slicedfn6()
			end)
		end)
	end)

	_G.setAntiDie = function(arg)
		local antiDie = arg and true or false
		slicedv3.AntiDie = antiDie
		_G.StickyAntiDieDisabled = not antiDie
		slicedv4()
		slicedfn2("AntiDie", antiDie)
		slicedfn2("Anti Die", antiDie)
	end
	local slicedtbl2 = { "Flying Carpet", "Waverider", "Santa's Sleigh", "Witch's Broom", "Cupid's Wings" }
	local slicedv8 = nil

	local function slicedfn4(arg)
		local character = slicedv6.Character
		local backpack = slicedv6:FindFirstChild("Backpack")
		return character and character:FindFirstChild(arg) or backpack and backpack:FindFirstChild(arg)
	end

	_G.StickyEquipCarpet = function()
		local character = slicedv6.Character
		if not character then return nil end
		if slicedv8 then
			local slicedv9 = character:FindFirstChild(slicedv8)
			if slicedv9 and slicedv9.Parent == character then return slicedv8 end
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid then return nil end
		for _, slicedv9 in ipairs(slicedtbl2) do
			local slicedv10 = slicedfn4(slicedv9)
			if slicedv10 and slicedv10:IsA("Tool") then
				if slicedv10.Parent ~= character then
					pcall(function()
						humanoid:EquipTool(slicedv10)
					end)
				end
				slicedv8 = slicedv9
				return slicedv9
			end
		end
		return nil
	end

	_G.StickyCarpetEngaging = function()
		local character = slicedv6.Character
		if not character then return false end
		for _, slicedv9 in ipairs(slicedtbl2) do
			local slicedv10 = character:FindFirstChild(slicedv9)
			if slicedv10 and slicedv10:IsA("Tool") then return true end
		end
		return false
	end
	local slicedtbl3 = {}
	local flag = false

	local function stickyStopWalkFling()
		flag = false
		for _, slicedv9 in ipairs(slicedtbl3) do
			if typeof(slicedv9) == "RBXScriptConnection" then
				pcall(function()
					slicedv9:Disconnect()
				end)
			end
		end
		slicedtbl3 = {}
	end

	local function slicedfn5()
		flag = true
		local character = slicedv6.Character
		if not character then return end
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		local currentCamera = workspace.CurrentCamera
		if currentCamera then
			for _, child in pairs(currentCamera:GetChildren()) do
				if child.Name == "HumanoidRootPart" then
					humanoidRootPart = child
					break
				end
			end
		end
		if not humanoidRootPart then return end
		table.insert(slicedtbl3, RunService.Stepped:Connect(function()
			if not flag then return end
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= slicedv6 and player.Character then
					for _, child in ipairs(player.Character:GetChildren()) do if child:IsA("BasePart") then child.CanCollide = false end end
				end
			end
		end))
		task.spawn(function()
			if _G.invisibleStealEnabled then humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 3, 0) end
			while flag do
				RunService.Heartbeat:Wait()
				if not (not humanoidRootPart or not humanoidRootPart.Parent) then
					local velocity = humanoidRootPart.Velocity
					humanoidRootPart.Velocity = velocity * 10000 + Vector3.new(0, 10000, 0)
					RunService.RenderStepped:Wait()
					if humanoidRootPart and humanoidRootPart.Parent then humanoidRootPart.Velocity = velocity end
					RunService.Stepped:Wait()
					if humanoidRootPart and humanoidRootPart.Parent then humanoidRootPart.Velocity = velocity + Vector3.new(0, 0.1, 0) end
					continue
				end
				break
			end
		end)
	end

	_G.StickyDropBrainrot = function()
		if flag then return end
		slicedfn5()
		task.delay(0.4, stickyStopWalkFling)
	end
	_G.StickyStopWalkFling = stickyStopWalkFling
	local slicedv9 = nil
	local slicedv10 = nil
	local slicedflag2 = false
	local slicedflag3 = false

	local function slicedfn6()
		if slicedv9 or slicedflag3 then return end
		if not hookfunction or _G.StickyResetCapture == false then return end
		slicedflag3 = true
		pcall(function()
			local slicedfn7 = newcclosure or function(arg)
				return arg
			end
			local now = os.clock()
			local slicedflag4 = false
			local function slicedfn8(stickyResetCaptureWhy)
				if slicedflag4 then return end
				slicedflag4 = true
				pcall(function()
					hookfunction(Instance.new("RemoteEvent").FireServer, slicedv10)
				end)
				_G.StickyResetCaptureMs = (os.clock() - now) * 1000
				_G.StickyResetCaptureWhy = stickyResetCaptureWhy
				slicedflag3 = false
			end
			local str = tostring(_G.StickyResetCaller or "ToolActivationController")
			local getcallingscript = getcallingscript
			if not getcallingscript then
				slicedfn8("no-getcallingscript")
				return
			end
			local slicedtbl4 = {}
			local function slicedfn9(stickyResetRemote)
				local name = stickyResetRemote.Name
				if name:sub(1, 3) ~= "RE/" then return end
				if not name:match("^RE/%x%x%x%x%x%x%x%x") then return end
				local slicedv12 = getcallingscript()
				if not slicedv12 or slicedv12.Name ~= str then return end
				local n = (slicedtbl4[stickyResetRemote] or 0) + 1
				slicedtbl4[stickyResetRemote] = n
				if (tonumber(_G.StickyResetMinFires) or 2) <= n then
					slicedv9 = stickyResetRemote
					_G.StickyResetRemote = stickyResetRemote
					_G.StickyResetRemoteName = name
					task.defer(slicedfn8, "captured")
				end
			end
			slicedv10 = hookfunction(Instance.new("RemoteEvent").FireServer, slicedfn7(function(arg, ...)
				local slicedv12 = table.pack(...)
				if not slicedv9 then
					local slicedv13 = ...
					if type(slicedv13) == "string" then pcall(slicedfn9, arg) end
					return slicedv10(arg, table.unpack(slicedv12, 1, slicedv12.n))
				end
				return slicedv10(arg, ...)
			end))
			task.delay(tonumber(_G.StickyResetCaptureMax) or 8, function()
				slicedfn8("timeout")
			end)
		end)
	end
	_G.StickyResetArm = function() slicedfn6() end
	task.spawn(function()
		local function slicedfn7(character)
			if not character then return end
			for _, child in ipairs(character:GetChildren()) do
				if child:IsA("Tool") and not slicedv9 then
					slicedfn6()
					break
				end
			end
			character.ChildAdded:Connect(function(child)
				if not slicedv9 and child:IsA("Tool") then slicedfn6() end
			end)
		end
		if slicedv6.Character then slicedfn7(slicedv6.Character) end
		slicedv6.CharacterAdded:Connect(slicedfn7)
	end)

	local function slicedfn7()
		local slicedflag4 = false
		pcall(function()
			local character = slicedv6.Character
			if not character then return end
			for _, child in ipairs(character:GetChildren()) do
				if child:IsA("Tool") then
					slicedflag4 = true
					break
				end
			end
			if not slicedflag4 then return end
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				pcall(function()
					humanoid:UnequipTools()
				end)
			end
			for _, child in ipairs(character:GetChildren()) do
				if child:IsA("Tool") then
					pcall(function()
						child.Parent = slicedv6:FindFirstChild("Backpack")
					end)
				end
			end
		end)
		return slicedflag4
	end

	_G.StickyInstantReset = function(arg)
		if _G.StickyResetJunkFire == true then
			if slicedflag2 then return true end
			slicedflag2 = true
			task.spawn(function()
				if _G.StickyResetStowTools ~= false then
					_G.StickyResetStowActive = true
					slicedfn7()
					RunService.Heartbeat:Wait()
				end
				local stickyAntiDieDisabled = _G.StickyAntiDieDisabled
				_G.StickyAntiDieDisabled = true
				local slicedflag4 = false
				local function slicedfn8()
					if slicedflag4 then return end
					slicedflag4 = true
					_G.StickyAntiDieDisabled = stickyAntiDieDisabled
					_G.StickyResetStowActive = false
					slicedflag2 = false
				end
				local connection = nil
				connection = slicedv6.CharacterAdded:Connect(function()
					if connection then
						connection:Disconnect()
						connection = nil
					end
					slicedfn8()
				end)
				task.delay(tonumber(_G.StickyResetRestoreMax) or 8, function()
					if connection then
						connection:Disconnect()
						connection = nil
					end
					slicedfn8()
				end)
				pcall(function()
					local character = slicedv6.Character
					local humanoid = character and character:FindFirstChildOfClass("Humanoid")
					if humanoid then
						pcall(function()
							humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
						end)
						pcall(function()
							humanoid.BreakJointsOnDeath = true
						end)
						humanoid:ChangeState(Enum.HumanoidStateType.Dead)
					end
				end)
			end)
			return true
		end
		local slicedv11 = slicedv9
		local stickyResetRemote
		if slicedv9 then
			stickyResetRemote = slicedv11
		else
			stickyResetRemote = _G.StickyResetRemote
		end
		if not stickyResetRemote then
			slicedfn6()
			local n = tonumber(_G.StickyResetArmWait) or 0
			if n > 0 then
				local now = os.clock()
				while not slicedv9 and os.clock() - now < n do task.wait(0.1) end
			end
			local slicedv12 = slicedv9
			if slicedv9 then
				stickyResetRemote = slicedv12
			else
				stickyResetRemote = _G.StickyResetRemote
			end
		end
		if not stickyResetRemote then return false end
		if not stickyResetRemote.Parent then
			_G.StickyResetRemoteDead = true
			return false
		end
		_G.StickyResetRemoteDead = false
		if slicedflag2 then return true end
		slicedflag2 = true
		local slicedflag4 = false
		if _G.StickyResetStowTools ~= false then
			_G.StickyResetStowActive = true
			slicedflag4 = slicedfn7()
		end
		local slicedfn8 = _G.StickyResetUseRawFS == true and slicedv10 or function(slicedarg2, slicedarg3)
			return slicedarg2:FireServer(slicedarg3)
		end
		local n = math.clamp(tonumber(arg) or tonumber(_G.StickyResetBurst) or 50, 1, 50)
		task.spawn(function()
			local stickyResetLastOk = false
			local connection = nil
			pcall(function()
				connection = slicedv6.CharacterRemoving:Connect(function()
					stickyResetLastOk = true
				end)
			end)
			if _G.StickyResetStowTools ~= false then
				local slicedn2 = math.clamp(tonumber(_G.StickyResetStowWait) or 0.1, 0, 1)
				local slicedn3 = math.clamp(tonumber(_G.StickyResetStowCap) or 0.5, slicedn2, 3)
				local now = os.clock()
				local slicedn4 = slicedflag4 and now or now - slicedn2
				while true do
					if not stickyResetLastOk and os.clock() - now < slicedn3 then
						if slicedfn7() then slicedn4 = os.clock() end
						if not (os.clock() - slicedn4 >= slicedn2) then
							RunService.Heartbeat:Wait()
							continue
						end
					end
					break
				end
			end
			local character = slicedv6.Character
			local now = os.clock()
			local slicedn2 = tonumber(_G.StickyResetMaxTime) or 3
			local stickyResetLastFires = 0
			for i = 1, n do
				if not (stickyResetLastOk or slicedv6.Character ~= character) then
					if not (slicedn2 <= os.clock() - now) then
						pcall(slicedfn8, stickyResetRemote, "randomstring")
						stickyResetLastFires += 1
						RunService.Heartbeat:Wait()
						continue
					end
				end
				break
			end
			_G.StickyResetLastFires = stickyResetLastFires
			_G.StickyResetLastMs = (os.clock() - now) * 1000
			_G.StickyResetLastOk = stickyResetLastOk or slicedv6.Character ~= character
			if connection then
				pcall(function()
					connection:Disconnect()
				end)
			end
			_G.StickyResetStowActive = false
			slicedflag2 = false
		end)
		return true
	end

	local function slicedfn8(arg)
		if not arg then return end
		local backpack = slicedv6:FindFirstChild("Backpack")
		if not backpack then return end
		for _, child in ipairs(arg:GetChildren()) do
			if child:IsA("Tool") then
				pcall(function()
					child.Parent = backpack
				end)
			end
		end
	end

	_G.StickyExecuteReset = function()
		if _G.StickyInstantReset and _G.StickyInstantReset(50) then return end
		pcall(function()
			Players.RespawnTime = 0
		end)
		local stickyAntiDieDisabled = _G.StickyAntiDieDisabled
		_G.StickyAntiDieDisabled = true
		_G.__stickyResetBusy = true
		local connection = nil

		local function slicedfn9()
			_G.StickyAntiDieDisabled = stickyAntiDieDisabled
			_G.__stickyResetBusy = false
		end
		connection = slicedv6.CharacterAdded:Connect(function(character)
			if connection then
				connection:Disconnect()
				connection = nil
			end
			task.defer(function()
				pcall(function()
					character:WaitForChild("Humanoid", 12)
				end)
				RunService.Heartbeat:Wait()
				slicedfn9()
			end)
		end)
		task.delay(10, function()
			if connection then
				connection:Disconnect()
				connection = nil
			end
			slicedfn9()
		end)
		local character = slicedv6.Character
		if not character then
			pcall(function()
				slicedv6:LoadCharacter()
			end)
			return
		end
		pcall(function()
			local function slicedfn10()
				local findFirstChild = character.FindFirstChild
				return character:FindFirstChildOfClass("Humanoid"), findFirstChild(character, "HumanoidRootPart")
			end
			local slicedv11, slicedv12 = slicedfn10()
			if not (slicedv12 and slicedv11) then return end
			pcall(function()
				slicedv11:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
				slicedv11:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
				slicedv11:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
				slicedv11.BreakJointsOnDeath = true
			end)
			slicedfn8(character)
			slicedv12.CFrame = CFrame.new(0, 15000, 0)
			RunService.Heartbeat:Wait()
			slicedfn8(character)
			RunService.Heartbeat:Wait()
			local slicedv13
			slicedv11, slicedv13 = slicedfn10()
			if not (slicedv11 and slicedv13) then return end
			pcall(function()
				slicedv11.Health = 0
			end)
			pcall(function()
				slicedv11:ChangeState(Enum.HumanoidStateType.Dead)
			end)
			if slicedv11.Health > 0 then
				pcall(function()
					slicedv11:TakeDamage(slicedv11.MaxHealth * 99)
				end)
			end
			if slicedv11.Health > 0 then
				pcall(function()
					character:BreakJoints()
				end)
			end
			local slicedv14
			slicedv11, slicedv14 = slicedfn10()
			if slicedv11 and slicedv14 and slicedv11.Health > 0 then
				pcall(function()
					slicedv14.AssemblyLinearVelocity = Vector3.zero
					slicedv14.CFrame = CFrame.new(slicedv14.Position.X, workspace.FallenPartsDestroyHeight - 500, slicedv14.Position.Z)
				end)
			end
		end)
		task.spawn(function()
			local character2 = slicedv6.Character
			for i = 1, 8 do
				pcall(function()
					slicedv6:LoadCharacter()
				end)
				task.wait(0.05)
				if not (slicedv6.Character and slicedv6.Character ~= character2) then continue end
				break
			end
		end)
	end
	_G.StickyInstaReset = _G.StickyExecuteReset
	if _G.StickyResetCaptureAtLoad ~= false then
		_G.StickyOnBoot(function()
			slicedfn6()
		end)
	end
end

do
	local flag = false

	local function slicedfn3()
		local character = slicedv5.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		return character ~= nil and humanoid ~= nil and humanoid.Health > 0
	end

	local function slicedfn4()
		local character = slicedv5.Character
		return character, character and character:FindFirstChild("HumanoidRootPart"), character and character:FindFirstChildOfClass("Humanoid")
	end
	local obj = setmetatable({}, { __mode = "k" })

	local function slicedfn5(arg)
		local slicedflag2 = _G.StickyTurretDeployStrict ~= false
		local slicedtbl2 = {}
		local slicedflag3 = false
		local static = nil
		for _, descendant in ipairs(arg:GetDescendants()) do
			if descendant:IsA("TextLabel") then
				local text = descendant.Text
				if text ~= "" then
					local slicedflag4
					if text:lower():find("ready", 1, true) then
						slicedflag4 = true
						if not slicedflag3 then
							slicedflag3 = true
							static = "ready-label"
						end
					elseif not slicedflag2 then
						local pos = text:find("!", 1, true) or text:match("^%s*%d+%.?%d*%s*[sS]?%s*$")
						slicedflag4 = false
						if pos then
							slicedflag4 = true
							if not slicedflag3 then
								slicedflag3 = true
								static = "loose"
							end
						end
					else
						local match = text:match("^%s*(%d+%.?%d*)%s*[sS]?%s*!*%s*$")
						local slicedflag5
						if match then
							slicedflag5 = (tonumber(match) or 99) <= 10
						else
							slicedflag5 = match
						end
						slicedflag4 = false
						if slicedflag5 then
							slicedflag4 = true
							if not slicedflag3 then
								static = "countdown=" .. match
								slicedflag3 = true
							end
						end
					end
					if slicedflag4 then slicedtbl2[#slicedtbl2 + 1] = text end
				end
			end
		end
		if not slicedflag3 then
			obj[arg] = nil
			return false, nil
		end
		local str = table.concat(slicedtbl2, "\1")
		local now = tick()
		local slicedv6 = obj[arg]
		if not slicedv6 or slicedv6.key ~= str then
			obj[arg] = { key = str, at = now, why = static }
			return true, static
		end
		slicedv6.why = static
		local slicedflag4 = _G.StickyTurretStaticRelease ~= false
		if slicedflag4 then slicedflag4 = now - slicedv6.at >= (tonumber(_G.StickyTurretStaticPin) or 1.2) end
		if slicedflag4 then return false, "static:" .. static end
		return true, static
	end
	local obj2 = setmetatable({}, { __mode = "k" })
	local obj3 = setmetatable({}, { __mode = "k" })
	local obj4 = setmetatable({}, { __mode = "k" })
	local obj5 = setmetatable({}, { __mode = "k" })
	local slicedtbl2 = { tp = 0, speed = 0, buykick = 0, steal = 0, join = 0, noweapon = 0 }

	local function slicedfn6()
		local slicedtbl3 = {}
		for _, slicedv6 in ipairs({ "tp", "speed", "buykick", "steal", "join", "noweapon" }) do
			if slicedtbl2[slicedv6] > 0.05 then slicedtbl3[#slicedtbl3 + 1] = string.format("%s %.2fs", slicedv6, slicedtbl2[slicedv6]) end
		end
		return #slicedtbl3 > 0 and table.concat(slicedtbl3, ", ") or "none"
	end

	local function slicedfn7(arg)
		if _G.StickyTurretSkipPlayers == false then return false end
		while arg and arg ~= workspace do
			if Players:GetPlayerFromCharacter(arg) or arg.ClassName == "Model" and arg:FindFirstChildOfClass("Humanoid") then return true end
			arg = arg.Parent
		end
		return false
	end

	local function slicedfn8(arg)
		if slicedfn7(arg) then return false end
		if _G.StickyTurretWaitReady == false then return true end
		if obj3[arg] then return true end
		local now = tick()
		local slicedv6 = obj2[arg]
		if not slicedv6 then
			obj2[arg] = now
			slicedv6 = now
		end
		local slicedtbl3 = obj4[arg]
		if not slicedtbl3 then
			slicedtbl3 = { seen = now }
			obj4[arg] = slicedtbl3
		end
		local n = now - slicedv6
		if (tonumber(_G.StickyTurretDeploySpan) or 12) <= n then
			obj3[arg] = true
			if slicedtbl3.pinwhy and not slicedtbl3.pinrel then slicedtbl3.pinrel = "age-cap" end
			return true
		end
		local slicedv7, slicedv8 = slicedfn5(arg)
		if slicedv8 and slicedv7 then slicedtbl3.pinwhy = slicedv8 end
		if slicedv7 then return false end
		if slicedtbl3.pinwhy and not slicedtbl3.pinrel then slicedtbl3.pinrel = slicedv8 and "static" or "deploy-done" end
		if _G.StickyTurretArmLatch ~= false then obj3[arg] = true end
		return true
	end

	local function slicedfn9(arg)
		for _, descendant in ipairs(arg:GetDescendants()) do
			if descendant:IsA("BasePart") and descendant ~= arg then
				descendant.Transparency = 0.5
				descendant.CanCollide = false
				descendant.CanTouch = false
				descendant.CanQuery = false
			elseif descendant:IsA("BillboardGui") and descendant.Name == "SentryLabel" then
				pcall(function()
					descendant:Destroy()
				end)
			elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
				descendant.Transparency = 0.5
			end
		end
		if arg:IsA("BasePart") and arg.Name == "ProxyVisual" then
			arg.Transparency = 1
			arg.CanCollide = false
		end
	end

	local function slicedfn10()
		local character = slicedv5.Character
		if not character then return nil end
		local backpack = slicedv5:FindFirstChild("Backpack")
		return backpack and backpack:FindFirstChild("Bat") or character:FindFirstChild("Bat") or backpack and backpack:FindFirstChild("Gummy Bear") or character:FindFirstChild("Gummy Bear")
	end

	local function slicedfn11()
		if _G.StickyResetStowActive then return end
		local slicedv6, slicedv7, slicedv8 = slicedfn4()
		if not slicedv6 or not slicedv8 then return end
		local slicedv9 = slicedfn10()
		if slicedv9 and slicedv9.Parent ~= slicedv6 then slicedv8:EquipTool(slicedv9) end
	end
	local n = 0

	local function slicedfn12(arg)
		local slicedv6
		slicedv6, slicedv6 = slicedfn4()
		if not slicedv6 then return nil end
		local slicedv7 = nil
		local huge = math.huge
		local find = string.find
		local now = tick()
		local position = slicedv6.Position

		local function slicedfn13(slicedarg2)
			for i = 1, #slicedarg2 do
				local slicedv8 = slicedarg2[i]
				local name = slicedv8.Name
				local isBasePart = find(name, "Sentry", 1, true) and name ~= "SentryBullet" and (slicedv8.ClassName == "Model" or slicedv8:IsA("BasePart"))
				if isBasePart then
					isBasePart = arg
					if not arg then isBasePart = not (obj5[slicedv8] and now < obj5[slicedv8]) end
				end
				if isBasePart and slicedfn8(slicedv8) then
					local isBasePart2 = slicedv8:IsA("BasePart") and slicedv8 or slicedv8:FindFirstChildWhichIsA("BasePart", true)
					if isBasePart2 then
						local magnitude = (position - isBasePart2.Position).Magnitude
						if magnitude < huge then
							huge = magnitude
							slicedv7 = slicedv8
						end
					end
				end
			end
		end
		slicedfn13(workspace:GetChildren())
		local slicedflag2 = not slicedv7
		local slicedflag3
		if slicedflag2 then
			slicedflag3 = now - n > (tonumber(_G.StickyTurretDeepEvery) or 3)
		else
			slicedflag3 = slicedflag2
		end
		if slicedflag3 then
			n = now
			slicedfn13(workspace:GetDescendants())
		end
		return slicedv7
	end
	_G.StickyAutoTurretActive = function() return flag == true end

	_G.StickyToggleAutoTurret = function()
		flag = not flag
		if flag then n = 0 end
		return flag
	end
	local slicedflag2 = false

	local function slicedfn13(arg)
		if slicedflag2 then return end
		slicedflag2 = true
		local slicedv6 = obj4[arg]
		if slicedv6 and not slicedv6.engage then slicedv6.engage = tick() end
		local slicedflag3 = _G.invisibleStealEnabled == true
		if slicedflag3 then _G.StickyInvisSurface = true end
		local now = tick()
		while true do
			local slicedflag4 = arg and arg.Parent and slicedv5:GetAttribute("Stealing") ~= true
			if slicedflag4 then slicedflag4 = tick() - now < (tonumber(_G.StickyTurretCycleCap) or 6) end
			if slicedflag4 then
				local slicedv7, slicedv8, slicedv9 = slicedfn4()
				if not (not slicedv7 or not slicedv8 or not slicedv9) then
					if slicedfn3() then
						if not _G.StickyTpActive then
							if not (_G.StickyTurretYieldToSpeed ~= false and _G.StickyCarpetSpeedActive) then
								local slicedv10, cframe
								if _G.StickyTurretYieldToBuyKick == false then
									slicedv10 = slicedfn10()
									slicedfn9(arg)
									cframe = CFrame.new(slicedv8.Position + slicedv8.CFrame.LookVector * 4, slicedv8.Position)
									if arg:IsA("Model") then
										arg:PivotTo(cframe)
									elseif arg:IsA("BasePart") then
										arg.CFrame = cframe
									end
									if slicedv10 then
										if slicedv10.Parent ~= slicedv7 then slicedv9:EquipTool(slicedv10) end
										slicedv10:Activate()
										task.wait(0.1)
										continue
									end
								elseif not (_G.StickyAutoBuyActive and _G.StickyAutoBuyActive()) then
									slicedv10 = slicedfn10()
									slicedfn9(arg)
									cframe = CFrame.new(slicedv8.Position + slicedv8.CFrame.LookVector * 4, slicedv8.Position)
									if arg:IsA("Model") then
										arg:PivotTo(cframe)
									elseif arg:IsA("BasePart") then
										arg.CFrame = cframe
									end
									if slicedv10 then
										if slicedv10.Parent ~= slicedv7 then slicedv9:EquipTool(slicedv10) end
										slicedv10:Activate()
										task.wait(0.1)
										continue
									end
								end
							end
						end
					end
				end
			end
			break
		end
		local parent = arg and arg.Parent
		if parent then parent = tick() - now >= (tonumber(_G.StickyTurretCycleCap) or 6) end
		if parent then obj5[arg] = tick() + (tonumber(_G.StickyTurretCooldown) or 2.5) end
		if slicedflag3 then _G.StickyInvisSurface = false end
		if slicedv6 then
			local now2 = tick()
			local seen = slicedv6.seen or now2
			local armed = slicedv6.armed or seen
			local engage = slicedv6.engage or now2
			local slicedflag4 = not (arg and arg.Parent)
			local pinwhy = slicedv6.pinwhy
			local str
			if pinwhy then
				str = string.format(": %s -> %s", slicedv6.pinwhy, slicedv6.pinrel or "?")
			else
				str = pinwhy
			end
			_G.StickyTurretLastReport = string.format("[Turret] %s | total %.2fs | seen->armed %.2fs (ready-wait%s) | armed->engage %.2fs (ours) | swinging %.2fs | blocked by: %s", slicedflag4 and "DESTROYED" or "SURVIVED", now2 - seen, armed - seen, str or "", engage - armed, now2 - engage, slicedfn6())
		end
		for k in pairs(slicedtbl2) do slicedtbl2[k] = 0 end
		slicedflag2 = false
	end

	_G.StickyDestroyTurretIfThreat = function()
		if not (flag and slicedfn3()) then return false end
		if _G.StickyTurretYieldToBuyKick ~= false then if _G.StickyAutoBuyActive and _G.StickyAutoBuyActive() then return false end end
		local slicedv6, slicedv7 = slicedfn4()
		if not slicedv7 then return false end
		local slicedv8 = slicedfn12(true)
		if not slicedv8 then return false end
		local isBasePart = slicedv8:IsA("BasePart") and slicedv8 or slicedv8:FindFirstChildWhichIsA("BasePart", true)
		if not isBasePart then return false end
		local magnitude = (slicedv7.Position - isBasePart.Position).Magnitude
		if (tonumber(_G.StickyTurretHitRange) or 45) < magnitude then return false end
		if not slicedfn10() then return false end
		slicedfn11()
		slicedfn13(slicedv8)
		return true
	end

	_G.StickyTurretThreatNearby = function()
		if not (flag and slicedfn3()) then return false end
		local slicedv6, slicedv7 = slicedfn4()
		if not slicedv7 then return false end
		local slicedv8 = slicedfn12(true)
		if not slicedv8 then return false end
		local isBasePart = slicedv8:IsA("BasePart") and slicedv8 or slicedv8:FindFirstChildWhichIsA("BasePart", true)
		if not isBasePart then return false end
		return (slicedv7.Position - isBasePart.Position).Magnitude <= (tonumber(_G.StickyTurretHitRange) or 45)
	end
	local now = tick()
	local slicedn2 = 0
	local slicedn3 = 0
	local slicedn4 = 0
	local slicedflag3 = false
	local slicedflag4 = false
	local slicedn5 = 0
	local slicedtbl3 = {}

	local function slicedfn14(stickyTurretWhy)
		if _G.StickyTurretWhy ~= stickyTurretWhy then
			_G.StickyTurretWhy = stickyTurretWhy
			slicedtbl3[#slicedtbl3 + 1] = string.format("%.1f %s", tick() - now, stickyTurretWhy)
			if #slicedtbl3 > 24 then table.remove(slicedtbl3, 1) end
			_G.StickyTurretWhyLog = table.concat(slicedtbl3, " | ")
		end
	end
	task.spawn(function()
		local now2 = tick()
		local slicedn6 = 0
		local function slicedfn15(arg) if slicedn5 > 0 then slicedtbl2[arg] = (slicedtbl2[arg] or 0) + slicedn6 end end
		while true do
			task.wait(0.1)
			local now3 = tick()
			slicedn6 = now3 - now2
			if not slicedfn3() then
				slicedfn14("not-in-game")
				now2 = now3
			else
				if _G.StickyTurretObserve ~= false then
					local children = workspace:GetChildren()
					local slicedn7 = 0
					for i = 1, #children do
						local slicedv6 = children[i]
						local name = slicedv6.Name
						if string.find(name, "Sentry", 1, true) and name ~= "SentryBullet" and (slicedv6.ClassName == "Model" or slicedv6:IsA("BasePart")) and not slicedfn7(slicedv6) then
							slicedn7 += 1
							local slicedtbl4 = obj4[slicedv6]
							if not slicedtbl4 then
								slicedtbl4 = { seen = now3 }
								obj4[slicedv6] = slicedtbl4
							end
							if flag and slicedfn8(slicedv6) and not slicedtbl4.armed then slicedtbl4.armed = now3 end
						end
					end
					slicedn5 = slicedn7
				else
					slicedn5 = 0
				end
				if not flag then
					slicedfn14("off")
					now2 = now3
					continue
				end
				if now3 - now < (tonumber(_G.StickyTurretJoinGrace) or 8) then
					slicedfn14("join-grace")
					slicedfn15("join")
					now2 = now3
					continue
				end
				if _G.StickyTpActive then
					slicedfn14("gate:tp")
					slicedfn15("tp")
					now2 = now3
					continue
				end
				if _G.StickyTurretYieldToSpeed ~= false and _G.StickyCarpetSpeedActive then
					slicedfn14("gate:speed")
					slicedfn15("speed")
					now2 = now3
					continue
				end
				if _G.StickyTurretYieldToBuyKick ~= false then
					if _G.StickyAutoBuyActive and _G.StickyAutoBuyActive() then
						slicedfn14("gate:buykick")
						slicedfn15("buykick")
						now2 = now3
						continue
					end
				end
				if slicedv5:GetAttribute("Stealing") == true then
					slicedfn14("gate:steal")
					slicedfn15("steal")
					now2 = now3
					continue
				end
				local slicedflag5 = slicedn5 == 0 and not slicedflag3
				if slicedflag5 then slicedflag5 = now3 - slicedn4 < (tonumber(_G.StickyTurretIdleScanDt) or 0.3) end
				if slicedflag5 then
					slicedfn14("idle:no-sentry")
					now2 = now3
					continue
				end
				slicedn4 = now3
				local slicedv6 = slicedfn12()
				slicedflag3 = slicedv6 ~= nil
				if not slicedv6 then
					slicedfn14(slicedn5 > 0 and "sentry-known-not-ready" or "idle:no-sentry")
					local slicedflag6 = _G.StickyTurretStreamSweep ~= false and not slicedflag4
					if slicedflag6 then slicedflag6 = now3 - slicedn3 > (tonumber(_G.StickyTurretSweepEvery) or 1) end
					if slicedflag6 then
						slicedn3 = now3
						local plots = workspace:FindFirstChild("Plots")
						if plots then
							local children = plots:GetChildren()
							if not (#children > 0) then
								now2 = now3
								continue
							end
							slicedn2 = slicedn2 % #children + 1
							local mainRoot = children[slicedn2]:FindFirstChild("MainRoot")
							if mainRoot and workspace.StreamingEnabled then
								slicedflag4 = true
								local position = mainRoot.Position
								task.spawn(function()
									pcall(function()
										workspace:RequestStreamAroundAsync(position, 1)
									end)
									slicedflag4 = false
								end)
								now2 = now3
								continue
							end
							now2 = now3
							continue
						end
						now2 = now3
						continue
					end
					now2 = now3
					continue
				end
				if not slicedfn10() then
					slicedfn14("no-weapon")
					slicedfn15("noweapon")
					now2 = now3
					continue
				end
				slicedfn14("engaging")
				slicedfn11()
				slicedfn13(slicedv6)
				now2 = now3
			end
		end
	end)

	_G.setAutoTurret = function(arg)
		local autoTurret = arg and true or false
		slicedv3.AutoTurret = autoTurret
		slicedv4()
		slicedfn2("AutoTurret", autoTurret)
		slicedfn2("Auto Turret", autoTurret)
		flag = autoTurret
		if autoTurret then n = 0 end
	end
	_G.StickyOnBoot(function()
		if slicedv3.AutoTurret == true then flag = true end
	end)
end

do
	local Lighting = game:GetService("Lighting")
	local flag = false
	local slicedflag2 = false
	local connection = nil
	local slicedtbl2 = nil

	local function slicedfn3(arg)
		pcall(function()
			if arg:IsA("Accessory") or arg:IsA("Hat") then
				arg:Destroy()
				return
			end
			if arg:IsA("BasePart") then
				arg.Material = Enum.Material.Plastic
				arg.Reflectance = 0
				arg.CastShadow = false
				return
			end
			if arg:IsA("Decal") or arg:IsA("Texture") then
				arg.Transparency = 1
				return
			end
			if arg:IsA("ParticleEmitter") or arg:IsA("Trail") or arg:IsA("Beam") or arg:IsA("Fire") or arg:IsA("Smoke") or arg:IsA("Sparkles") then
				arg.Enabled = false
			end
		end)
	end

	local function slicedfn4()
		slicedflag2 = true
		flag = true
		if slicedtbl2 == nil then
			slicedtbl2 = {
				Brightness = Lighting.Brightness,
				ClockTime = Lighting.ClockTime,
				OutdoorAmbient = Lighting.OutdoorAmbient,
				GlobalShadows = Lighting.GlobalShadows,
				FogEnd = Lighting.FogEnd,
				EnvDiffuse = Lighting.EnvironmentDiffuseScale,
				EnvSpecular = Lighting.EnvironmentSpecularScale,
				effects = {},
			}
			for _, child in ipairs(Lighting:GetChildren()) do if child:IsA("PostEffect") then slicedtbl2.effects[child] = child.Enabled end end
		end
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 1e10
		Lighting.Brightness = 1
		Lighting.EnvironmentDiffuseScale = 0
		Lighting.EnvironmentSpecularScale = 0
		for _, child in ipairs(Lighting:GetChildren()) do
			pcall(function()
				if child:IsA("BlurEffect") or child:IsA("SunRaysEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("BloomEffect") or child:IsA("DepthOfFieldEffect") then
					child.Enabled = false
				end
			end)
		end
		for _, descendant in ipairs(workspace:GetDescendants()) do slicedfn3(descendant) end
		if connection then connection:Disconnect() end
		connection = workspace.DescendantAdded:Connect(function(descendant)
			if slicedflag2 then slicedfn3(descendant) end
		end)
	end

	local function slicedfn5()
		slicedflag2 = false
		flag = false
		if connection then
			connection:Disconnect()
			connection = nil
		end
		pcall(function()
			if slicedtbl2 then
				Lighting.Brightness = slicedtbl2.Brightness
				Lighting.ClockTime = slicedtbl2.ClockTime
				Lighting.OutdoorAmbient = slicedtbl2.OutdoorAmbient
				Lighting.GlobalShadows = slicedtbl2.GlobalShadows
				Lighting.FogEnd = slicedtbl2.FogEnd
				Lighting.EnvironmentDiffuseScale = slicedtbl2.EnvDiffuse
				Lighting.EnvironmentSpecularScale = slicedtbl2.EnvSpecular
				for k, effect in pairs(slicedtbl2.effects) do
					if k and k.Parent then
						pcall(function()
							k.Enabled = effect
						end)
					end
				end
			end
			Lighting.ExposureCompensation = 0
		end)
	end

	_G.StickyToggleAntiLag = function(arg)
		if arg == nil then arg = not flag end
		if arg then
			slicedfn4()
		else
			slicedfn5()
		end
	end
end

local function setAntiLag(arg)
	local antiLag = arg and true or false
	slicedv3.AntiLag = antiLag
	slicedv4()
	slicedfn2("AntiLag", antiLag)
	slicedfn2("Anti Lag", antiLag)
	task.spawn(function()
		pcall(_G.StickyToggleAntiLag, antiLag)
	end)
end

_G.setAntiLag = setAntiLag

_G.StickyOnBoot(function()
	if slicedv3.AntiLag == true then pcall(setAntiLag, true) end
end)

do
	local slicedtbl2 = { 80, 120, 180 }
	local connection = nil

	local function slicedfn3()
		if connection then
			connection:Disconnect()
			connection = nil
		end
		local fieldOfView = tonumber(_G.StickyFOV)
		if not fieldOfView then return end
		connection = RunService.RenderStepped:Connect(function()
			local currentCamera = workspace.CurrentCamera
			if currentCamera and currentCamera.FieldOfView ~= fieldOfView then currentCamera.FieldOfView = fieldOfView end
		end)
	end

	local function stickySetFOV(arg)
		_G.StickyFOV = tonumber(arg) or 80
		slicedv3.FOV = _G.StickyFOV
		slicedv4()
		slicedfn3()
		return _G.StickyFOV
	end
	_G.StickySetFOV = stickySetFOV

	_G.StickyCycleFOV = function()
		local num = tonumber(_G.StickyFOV) or slicedtbl2[1]
		local n = 1
		for i, slicedv6 in ipairs(slicedtbl2) do
			if slicedv6 == num then
				n = i
				break
			end
		end
		return stickySetFOV(slicedtbl2[n % #slicedtbl2 + 1])
	end
	_G.StickyOnBoot(function()
		_G.StickyFOV = tonumber(slicedv3.FOV) or 80
		slicedfn3()
	end)
end

local function slicedfn3() return require(localPlayer2:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls() end

slicedfn3()

do
	local slicedtbl2 = {
		Background = Color3.fromRGB(14, 8, 18),
		Surface = Color3.fromRGB(20, 10, 28),
		SurfaceHighlight = Color3.fromRGB(35, 16, 48),
		Accent1 = Color3.fromRGB(153, 60, 220),
		Accent2 = Color3.fromRGB(112, 30, 170),
		TextPrimary = Color3.fromRGB(240, 240, 240),
		TextSecondary = Color3.fromRGB(140, 140, 150),
		Success = Color3.fromRGB(30, 150, 90),
		Error = Color3.fromRGB(174, 60, 255),
	}
	local slicedtbl3 = {}

	local function slicedfn4()
		for i = #slicedtbl3, 1, -1 do slicedtbl3[i] = nil end
		local ipairs = ipairs
		local priorityList = slicedv2.PriorityList or {}
		for k, slicedv7 in ipairs(priorityList) do slicedtbl3[k] = slicedv7 end
	end

	local function slicedfn5()
		slicedv2.PriorityList = {}
		for i, slicedv6 in ipairs(slicedtbl3) do slicedv2.PriorityList[i] = slicedv6 end
	end
	slicedfn4()

	local function stickyFindAdornee(arg)
		if not arg then return nil end
		local plots = workspace_:FindFirstChild("Plots") and workspace_.Plots:FindFirstChild(arg.plot)
		if plots then
			local animalPodiums = plots:FindFirstChild("AnimalPodiums")
			if animalPodiums then
				local slicedv6 = animalPodiums:FindFirstChild(arg.slot)
				if slicedv6 then
					local base = slicedv6:FindFirstChild("Base")
					if base then
						local spawn = base:FindFirstChild("Spawn")
						if spawn then return spawn end
						return base:FindFirstChildWhichIsA("BasePart") or base
					end
				end
			end
		end
		return nil
	end
	_G.StickyFindAdornee = stickyFindAdornee

	local function slicedfn6(parent)
		if not parent then return end
		local uiScale = parent:FindFirstChildOfClass("UIScale")
		if uiScale then uiScale:Destroy() end
		local uiScale2 = Instance.new("UIScale")
		uiScale2.Parent = parent
		tbl.MobileScaleObjects[parent] = uiScale2
		if tbl.RefreshMobileScale then
			tbl.RefreshMobileScale()
		else
			uiScale2.Scale = scale
		end
	end

	tbl.RefreshMobileScale = function()
		local slicedv6 = scale
		for k, mobileScaleObject in pairs(tbl.MobileScaleObjects) do
			if k and k.Parent and mobileScaleObject and mobileScaleObject.Parent == k then
				mobileScaleObject.Scale = slicedv6
			else
				tbl.MobileScaleObjects[k] = nil
			end
		end
	end
	local UserInputService = game:GetService("UserInputService")

	local function slicedfn7(arg, slicedarg2, slicedarg3)
		local flag = nil
		local slicedv6 = nil
		local position = nil
		local position2 = nil
		arg.InputBegan:Connect(function(input)
			if slicedv2.UILocked then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				flag = true
				position = input.Position
				position2 = slicedarg2.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						flag = false
						if slicedarg3 then
							slicedv2.Positions[slicedarg3] = {
								X = slicedarg2.Position.X.Scale,
								Y = slicedarg2.Position.Y.Scale,
								OffsetX = slicedarg2.Position.X.Offset,
								OffsetY = slicedarg2.Position.Y.Offset,
							}
							fn()
						end
					end
				end)
			end
		end)
		arg.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then slicedv6 = input end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if input == slicedv6 and flag then
				local n = input.Position - position
				slicedarg2.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n.X, position2.Y.Scale, position2.Y.Offset + n.Y)
			end
		end)
	end

	local function createTextButton(arg, slicedarg2, slicedarg3, slicedarg4, slicedarg5)
		local textButton = Instance.new("TextButton", arg)
		textButton.Name = "ResizeGrip"
		textButton.AnchorPoint = Vector2.new(1, 1)
		textButton.Position = UDim2.new(1, -2, 1, -2)
		textButton.Size = UDim2.fromOffset(22, 22)
		textButton.BackgroundTransparency = 1
		textButton.Text = "â¢"
		textButton.TextColor3 = Color3.fromRGB(166, 90, 220)
		textButton.TextSize = 15
		textButton.Font = Enum.Font.GothamBold
		textButton.TextTransparency = 0.45
		textButton.TextXAlignment = Enum.TextXAlignment.Right
		textButton.TextYAlignment = Enum.TextYAlignment.Bottom
		textButton.AutoButtonColor = false
		textButton.Active = true
		textButton.ZIndex = 400
		local flag = false
		local position = nil
		local n = 0
		local slicedn2 = 0

		local function slicedfn8()
			local scale2 = tbl.MobileScaleObjects[arg]
			scale2 = scale2 and scale2.Scale or 1
			if scale2 <= 0 then scale2 = 1 end
			return scale2
		end

		local function slicedfn9()
			local slicedv6, slicedv7 = slicedarg4()
			slicedv2.PanelSize = slicedv2.PanelSize or {}
			slicedv2.PanelSize[slicedarg2] = slicedv2.PanelSize[slicedarg2] or {}
			slicedv2.PanelSize[slicedarg2].W = slicedv6
			slicedv2.PanelSize[slicedarg2].H = slicedv7
			if _G.StickySaveConfigNow then
				task.spawn(_G.StickySaveConfigNow)
			else
				fn()
			end
		end
		textButton.MouseEnter:Connect(function()
			if not flag then textButton.TextTransparency = 0.1 end
		end)
		textButton.MouseLeave:Connect(function()
			if not flag then textButton.TextTransparency = 0.45 end
		end)
		textButton.InputBegan:Connect(function(input)
			if slicedv2.UILocked then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				flag = true
				position = input.Position
				local slicedv6, slicedv7 = slicedarg4()
				n = slicedv6
				slicedn2 = slicedv7
				textButton.TextTransparency = 0
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End and flag then
						flag = false
						textButton.TextTransparency = 0.45
						slicedfn9()
					end
				end)
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if not flag then return end
			if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
			local slicedv6 = slicedfn8()
			local slicedn3 = (input.Position.X - position.X) / slicedv6
			local slicedn4 = (input.Position.Y - position.Y) / slicedv6
			local slicedn5 = math.clamp(n + slicedn3, slicedarg3.minW, slicedarg3.maxW)
			local slicedn6 = math.clamp(slicedn2 + slicedn4, slicedarg3.minH, slicedarg3.maxH)
			local floor = math.floor
			slicedarg5(math.floor(slicedn5 + 0.5), floor(slicedn6 + 0.5))
		end)
		textButton.Visible = false
		textButton.Active = false
		textButton.Selectable = false
		return textButton
	end
	task.spawn(function()
		local slicedfn8, slicedfn9, Animals, slicedfn10, slicedfn11
		do
			local packages = replicatedStorage:WaitForChild("Packages")
			local datas = replicatedStorage:WaitForChild("Datas")
			replicatedStorage:WaitForChild("Shared")
			replicatedStorage:WaitForChild("Utils")
			local Synchronizer = require(packages:WaitForChild("Synchronizer"))
			slicedfn8 = function(arg)
				if not arg then return false end
				if typeof(arg) == "Instance" then return arg == localPlayer2 end
				if type(arg) == "string" then return arg == localPlayer2.Name end
				return false
			end
			slicedfn9 = function(arg)
				local ok, result = pcall(function()
					local slicedv6 = getthreadidentity and getthreadidentity() or nil
					if setthreadidentity then setthreadidentity(8) end
					local tableFromChannel = Synchronizer:GetTableFromChannel(arg)
					if slicedv6 and setthreadidentity then pcall(setthreadidentity, slicedv6) end
					return tableFromChannel
				end)
				if ok and type(result) == "table" then return result end
				return nil
			end
			Animals = require(datas:WaitForChild("Animals"))
			local Mutations = require(datas:WaitForChild("Mutations"))
			local Traits = require(datas:WaitForChild("Traits"))
			local slicedtbl4 = {
				"",
				"K",
				"M",
				"B",
				"T",
				"Qa",
				"Qi",
				"Sx",
				"Sp",
				"Oc",
				"No",
				"Dc",
				"Ud",
				"Dd",
				"Td",
				"Qad",
				"Qid",
				"Sxd",
				"Spd",
				"Ocd",
				"Nod",
				"Vg",
				"Uvg",
				"Dvg",
				"Tvg",
			}
			slicedfn10 = function(arg, slicedarg2)
				local n = slicedarg2 or 1
				local slicedn2 = math.abs(arg)
				local slicedn3 = math.floor(math.log(math.max(1, slicedn2), 1000))
				local str = slicedtbl4[slicedn3 + 1] or "e+" .. slicedn3
				return ("%." .. n .. "f"):format(math.floor(arg * (10 ^ n / 1000 ^ slicedn3)) / 10 ^ n):gsub("%.?0+$", "") .. str
			end
			slicedfn11 = function(arg, slicedarg2, slicedarg3)
				local slicedv6 = Animals[arg]
				if not slicedv6 then return 0 end
				local generation = slicedv6.Generation or slicedv6.Price * 0.1
				local flag = slicedarg2 and slicedarg2 ~= "None"
				local n = 1
				if flag then
					local slicedv7 = Mutations[slicedarg2]
					if slicedv7 and slicedv7.Modifier then n = 1 + slicedv7.Modifier end
				end
				local slicedflag2 = false
				if type(slicedarg3) == "table" then
					for _, slicedv7 in ipairs(slicedarg3) do
						if slicedv7 == "Sleepy" then
							slicedflag2 = true
						else
							local slicedv8 = Traits[slicedv7]
							if slicedv8 and slicedv8.MultiplierModifier then n += slicedv8.MultiplierModifier end
						end
					end
				end
				local slicedv7 = math.round(generation * n)
				if slicedflag2 then slicedv7 = math.round(slicedv7 * 0.5) end
				return slicedv7
			end
		end
		local flag = true
		if slicedv2.DefaultToPriority and slicedv2.DefaultToHighest then slicedv2.DefaultToHighest = false end
		if slicedv2.DefaultToPriority and slicedv2.DefaultToNearest then slicedv2.DefaultToNearest = false end
		if slicedv2.DefaultToHighest and slicedv2.DefaultToNearest then slicedv2.DefaultToNearest = false end
		if not slicedv2.DefaultToPriority and not slicedv2.DefaultToHighest and not slicedv2.DefaultToNearest then slicedv2.DefaultToHighest = true end
		local stealNearest = false
		local stealHighest = false
		local stealPriority = false
		if slicedv2.DefaultToNearest then
			stealNearest = true
			slicedv2.StealNearest = true
			slicedv2.StealHighest = false
			slicedv2.StealPriority = false
		elseif slicedv2.DefaultToHighest then
			stealHighest = true
			slicedv2.StealHighest = true
			slicedv2.StealNearest = false
			slicedv2.StealPriority = false
		elseif slicedv2.DefaultToPriority then
			stealPriority = true
			slicedv2.StealPriority = true
			slicedv2.StealNearest = false
			slicedv2.StealHighest = false
		else
			stealNearest = slicedv2.StealNearest
			stealHighest = slicedv2.StealHighest
			stealPriority = slicedv2.StealPriority
			if slicedv2.InstantSteal == nil then slicedv2.InstantSteal = false end
		end
		local instantSteal = slicedv2.InstantSteal == true
		_G.NEAREST_INSTANT_MODE = slicedv2.StealNearest == true and slicedv2.InstantSteal == true
		local slicedflag2 = false
		local slicedflag3 = false
		local n = 1
		local uid = nil
		local uid2 = nil
		local allAnimalsCache = {}
		local slicedfn12 = function() flag = stealNearest == true or stealHighest == true or stealPriority == true end
		slicedfn12()
		local slicedtbl4 = {}
		local slicedtbl5 = {}
		local tween = nil
		local slicedv6 = nil
		local slicedtbl6 = {}
		local slicedfn13

		slicedfn13 = function(arg)
			if not arg or not arg.plot then return false end
			local plots = workspace_:FindFirstChild("Plots")
			if not plots then return false end
			local slicedv7 = plots:FindFirstChild(arg.plot)
			if not slicedv7 then return false end
			local slicedv8 = slicedfn9(slicedv7.Name)
			if slicedv8 then return slicedfn8(slicedv8.Owner) end
			return false
		end
		local slicedfn14, slicedfn15, slicedfn16

		local function slicedfn17(arg)
			if not arg or arg == "None" then return "" end
			local str
			if arg == "Cursed" then
				str = "<font color='rgb(200,0,0)'>Cur</font><font color='rgb(0,0,0)'>sed</font>"
			elseif arg == "Gold" then
				str = "<font color='rgb(255,215,0)'>Gold</font>"
			elseif arg == "Diamond" then
				str = "<font color='rgb(0,255,255)'>Diamond</font>"
			elseif arg == "YinYang" then
				str = "<font color='rgb(255,255,255)'>Yin</font><font color='rgb(0,0,0)'>Yang</font>"
			elseif arg == "Candy" then
				str = "<font color='rgb(255,105,180)'>Candy</font>"
			elseif arg == "Divine" then
				str = "<font color='rgb(255,255,255)'>Divine</font>"
			elseif arg == "Rainbow" then
				local slicedtbl7 = {
					"rgb(255,0,0)",
					"rgb(255,127,0)",
					"rgb(255,255,0)",
					"rgb(0,255,0)",
					"rgb(0,0,255)",
					"rgb(75,0,130)",
					"rgb(148,0,211)",
				}
				str = ""
				for i = 1, #arg do str ..= "<font color='" .. slicedtbl7[(i - 1) % #slicedtbl7 + 1] .. "'>" .. arg:sub(i, i) .. "</font>" end
			elseif arg == "Radioactive" then
				str = "<font color='rgb(132,255,0)'>Radioactive</font>"
			elseif arg ~= "Galaxy" then
				str = arg
			else
				str = "<font color='rgb(170,85,255)'>Galaxy</font>"
			end
			return "<font weight='800'>" .. str .. " </font>"
		end

		slicedfn14 = function(arg)
			if arg == "Gold" then return Color3.fromRGB(255, 215, 0) end
			if arg == "Diamond" then return Color3.fromRGB(149, 0, 255) end
			if arg == "Cursed" then return Color3.fromRGB(200, 0, 0) end
			if arg == "YinYang" then return Color3.fromRGB(255, 255, 255) end
			if arg == "Candy" then return Color3.fromRGB(255, 105, 180) end
			if arg == "Divine" then return Color3.fromRGB(255, 255, 255) end
			if arg == "Rainbow" then return Color3.fromRGB(148, 0, 211) end
			if arg == "Radioactive" then return Color3.fromRGB(132, 255, 0) end
			if arg == "Galaxy" then return Color3.fromRGB(170, 85, 255) end
			return Color3.fromRGB(255, 70, 120)
		end
		slicedfn15 = function(arg) return arg and arg.petName or "Unknown" end

		slicedfn16 = function(arg)
			arg = arg and arg.mutation
			if arg and arg ~= "None" and arg ~= "" then return slicedfn17(arg), true end
			return "", false
		end
		local slicedfn18

		slicedfn18 = function()
			local slicedtbl7 = {}
			for _, slicedv7 in ipairs(allAnimalsCache) do
				if slicedv7.genValue >= 1 and not slicedfn13(slicedv7) then
					table.insert(slicedtbl7, {
						petName = slicedv7.name,
						mpsText = slicedv7.genText,
						mpsValue = slicedv7.genValue,
						owner = slicedv7.owner,
						plot = slicedv7.plot,
						slot = slicedv7.slot,
						uid = slicedv7.uid,
						mutation = slicedv7.mutation,
						animalData = slicedv7,
					})
				end
			end
			return slicedtbl7
		end
		local hui = gethui and gethui() or game:GetService("CoreGui")
		local slicedn2, slicedtbl7, scrollingFrame
		do
			local screenGui = Instance.new("ScreenGui")
			screenGui.Name = "cJPcVLFpwxgI"
			screenGui.ResetOnSpawn = false
			screenGui.Parent = hui
			local frame = Instance.new("Frame")
			slicedn2 = v and 0.6 or 1
			slicedtbl7 = {
				BG = Color3.fromRGB(23, 8, 34),
				SURF = Color3.fromRGB(40, 14, 58),
				SURF2 = Color3.fromRGB(58, 22, 84),
				TEXT = Color3.fromRGB(235, 250, 255),
				DIM = Color3.fromRGB(184, 120, 230),
				AQUA = Color3.fromRGB(186, 90, 255),
				AQUA2 = Color3.fromRGB(139, 40, 210),
				AQUA_STROKE = Color3.fromRGB(199, 120, 255),
			}
			local autoSteal = slicedv2.PanelSize and slicedv2.PanelSize.AutoSteal
			frame.Size = UDim2.fromOffset(tonumber(autoSteal and autoSteal.W) or 320, tonumber(autoSteal and autoSteal.H) or 580)
			if autoSteal and autoSteal.W and autoSteal.H then tbl.AutoStealCustomSize = true end
			frame.Position = UDim2.new(slicedv2.Positions.AutoSteal.X, slicedv2.Positions.AutoSteal.OffsetX or 0, slicedv2.Positions.AutoSteal.Y, slicedv2.Positions.AutoSteal.OffsetY or 0)
			tbl.AutoStealFrame = frame
			frame.BackgroundColor3 = slicedtbl7.BG
			frame.BackgroundTransparency = 0
			frame.BorderSizePixel = 0
			frame.ClipsDescendants = true
			frame.Parent = screenGui
			slicedfn6(frame)
			Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
			local uiStroke = Instance.new("UIStroke", frame)
			uiStroke.Color = slicedtbl7.AQUA_STROKE
			uiStroke.Thickness = 1.3
			uiStroke.Transparency = 0.25
			local frame2 = Instance.new("Frame", frame)
			frame2.Size = UDim2.new(1, 0, 0, 60)
			frame2.BackgroundTransparency = 1
			slicedfn7(frame2, frame, "AutoSteal")
			createTextButton(frame, "AutoSteal", { minW = 220, minH = 200, maxW = 640, maxH = 900 }, function()
				return frame.Size.X.Offset, frame.Size.Y.Offset
			end, function(arg, slicedarg2)
				tbl.AutoStealCustomSize = true
				frame.Size = UDim2.fromOffset(arg, slicedarg2)
			end)
			local textLabel = Instance.new("TextLabel", frame2)
			textLabel.Size = UDim2.new(1, -32, 0, 35)
			textLabel.Position = UDim2.new(0, 16, 0, 12)
			textLabel.BackgroundTransparency = 1
			textLabel.Text = "STEAL TARGET"
			textLabel.Font = Enum.Font.GothamBlack
			textLabel.TextSize = 28
			textLabel.TextColor3 = slicedtbl7.TEXT
			textLabel.TextXAlignment = Enum.TextXAlignment.Center
			local frame3 = Instance.new("Frame", frame)
			frame3.AnchorPoint = Vector2.new(0.5, 0)
			frame3.Position = UDim2.new(0.5, 0, 0, 54)
			frame3.Size = UDim2.new(0, 120, 0, 2)
			frame3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			frame3.BackgroundTransparency = 0.15
			frame3.BorderSizePixel = 0
			scrollingFrame = Instance.new("ScrollingFrame", frame)
		end
		scrollingFrame.Size = UDim2.new(1, -20, 1, -92)
		scrollingFrame.Position = UDim2.new(0, 10, 0, 80)
		scrollingFrame.BackgroundTransparency = 1
		scrollingFrame.BorderSizePixel = 0
		scrollingFrame.ClipsDescendants = true
		scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
		scrollingFrame.ScrollingEnabled = true
		scrollingFrame.Active = true
		scrollingFrame.Selectable = false
		scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
		scrollingFrame.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
		scrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
		scrollingFrame.ScrollBarImageColor3 = slicedtbl7.AQUA_STROKE
		scrollingFrame.ScrollBarImageTransparency = 0.15
		scrollingFrame.ScrollBarThickness = 6
		scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		local frame = Instance.new("Frame", scrollingFrame)
		frame.Name = "Holder"
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.Position = UDim2.new(0, 0, 0, 0)
		frame.Size = UDim2.new(1, 0, 0, 0)
		frame.ClipsDescendants = false
		local uiListLayout = Instance.new("UIListLayout", frame)
		uiListLayout.Padding = UDim.new(0, 4)
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		for _, slicedv7 in ipairs({ playerGui, hui }) do
			local brXgmsaEVfze = slicedv7 and slicedv7:FindFirstChild("bRXgmsaEVfze")
			if brXgmsaEVfze then
				pcall(function()
					brXgmsaEVfze:Destroy()
				end)
			end
		end
		local textLabel, frame2, textLabel2
		do
			local screenGui = Instance.new("ScreenGui")
			screenGui.Name = "bRXgmsaEVfze"
			screenGui.ResetOnSpawn = false
			screenGui.IgnoreGuiInset = true
			screenGui.DisplayOrder = 2147483646
			screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			screenGui.Parent = hui
			local slicedtbl8 = {
				PANEL = Color3.fromRGB(40, 14, 58),
				PANEL2 = Color3.fromRGB(58, 22, 84),
				TEXT = Color3.fromRGB(235, 250, 255),
				STROKE = Color3.fromRGB(199, 120, 255),
				GLOW = Color3.fromRGB(186, 90, 255),
				TRACK = Color3.fromRGB(50, 20, 72),
				TRACK2 = Color3.fromRGB(66, 30, 92),
				FILL1 = Color3.fromRGB(186, 90, 255),
				FILL2 = Color3.fromRGB(200, 240, 255),
			}
			local frame3 = Instance.new("Frame", screenGui)
			frame3.Name = "CurrentTargetHUD"
			frame3.AnchorPoint = Vector2.new(0.5, 1)
			frame3.Size = UDim2.new(0, 180 * slicedn2, 0, 48 * slicedn2)
			frame3.Position = UDim2.new(0.5, 0, 1, _G.YesIsPhone and -116 or -145)
			frame3.BackgroundColor3 = slicedtbl8.PANEL
			frame3.BackgroundTransparency = 0.02
			frame3.BorderSizePixel = 0
			frame3.ZIndex = 70
			if not _G.YesIsPhone then Instance.new("UIScale", frame3).Scale = 1.25 end
			Instance.new("UICorner", frame3).CornerRadius = UDim.new(0, math.floor(10 * slicedn2))
			local uiStroke = Instance.new("UIStroke", frame3)
			uiStroke.Color = slicedtbl8.STROKE
			uiStroke.Thickness = 1
			uiStroke.Transparency = 0.35
			local uiStroke2 = Instance.new("UIStroke", frame3)
			uiStroke2.Color = slicedtbl8.GLOW
			uiStroke2.Thickness = 3
			uiStroke2.Transparency = 0.84
			uiStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			textLabel = Instance.new("TextLabel", frame3)
			textLabel.Name = "TargetName"
			textLabel.Size = UDim2.new(1, -10, 0, 16 * slicedn2)
			textLabel.Position = UDim2.fromOffset(5 * slicedn2, 4 * slicedn2)
			textLabel.BackgroundTransparency = 1
			textLabel.Font = Enum.Font.GothamBold
			textLabel.TextSize = 10 * slicedn2
			textLabel.TextColor3 = slicedtbl8.TEXT
			textLabel.TextXAlignment = Enum.TextXAlignment.Center
			textLabel.TextTruncate = Enum.TextTruncate.AtEnd
			textLabel.ZIndex = 72
			textLabel.Text = "No target"
			local frame4 = Instance.new("Frame", frame3)
			frame4.Name = "ProgressBg"
			frame4.Size = UDim2.new(1, -8 * slicedn2, 0, 16 * slicedn2)
			frame4.Position = UDim2.fromOffset(4 * slicedn2, 22 * slicedn2)
			frame4.BackgroundColor3 = slicedtbl8.TRACK
			frame4.BorderSizePixel = 0
			frame4.ZIndex = 72
			Instance.new("UICorner", frame4).CornerRadius = UDim.new(0, math.floor(6 * slicedn2))
			local uiStroke3 = Instance.new("UIStroke", frame4)
			uiStroke3.Color = slicedtbl8.STROKE
			uiStroke3.Thickness = 1
			uiStroke3.Transparency = 0.55
			local frame5 = Instance.new("Frame", frame4)
			frame5.Name = "InnerTrack"
			frame5.Size = UDim2.new(1, -2, 1, -2)
			frame5.Position = UDim2.fromOffset(1, 1)
			frame5.BackgroundColor3 = slicedtbl8.TRACK2
			frame5.BackgroundTransparency = 0.15
			frame5.BorderSizePixel = 0
			frame5.ZIndex = 72
			Instance.new("UICorner", frame5).CornerRadius = UDim.new(0, math.floor(5 * slicedn2))
			frame2 = Instance.new("Frame", frame4)
			frame2.Name = "ProgressFill"
			frame2.Size = UDim2.new(0, 0, 1, 0)
			frame2.BackgroundColor3 = slicedtbl8.FILL1
			frame2.BorderSizePixel = 0
			frame2.ZIndex = 73
			Instance.new("UICorner", frame2).CornerRadius = UDim.new(0, math.floor(6 * slicedn2))
			local colorSequence = ColorSequence.new
			local new = ColorSequenceKeypoint.new
			local fILL2 = slicedtbl8.FILL2
			Instance.new("UIGradient", frame2).Color = colorSequence({ ColorSequenceKeypoint.new(0, slicedtbl8.FILL1), new(1, fILL2) })
			local uiStroke4 = Instance.new("UIStroke", frame2)
			uiStroke4.Color = Color3.fromRGB(200, 240, 255)
			uiStroke4.Thickness = 1
			uiStroke4.Transparency = 0.45
			textLabel2 = Instance.new("TextLabel", frame4)
			textLabel2.Name = "Percent"
			textLabel2.Size = UDim2.new(1, 0, 1, 0)
			textLabel2.BackgroundTransparency = 1
			textLabel2.Font = Enum.Font.GothamBold
			textLabel2.TextSize = 10 * slicedn2
			textLabel2.TextColor3 = slicedtbl8.TEXT
		end
		textLabel2.TextStrokeTransparency = 0.7
		textLabel2.TextXAlignment = Enum.TextXAlignment.Center
		textLabel2.ZIndex = 74
		textLabel2.Text = "0%"
		local slicedv7 = frame2
		for _, slicedv8 in ipairs({ playerGui, hui }) do
			local sxTopLayer = slicedv8 and slicedv8:FindFirstChild("SxTopLayer")
			if sxTopLayer then
				pcall(function()
					sxTopLayer:Destroy()
				end)
			end
		end
		do
			local screenGui = Instance.new("ScreenGui")
			screenGui.Name = "SxTopLayer"
			screenGui.ResetOnSpawn = false
			screenGui.IgnoreGuiInset = true
			screenGui.DisplayOrder = 2147483647
			screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			screenGui.Parent = hui
			local frame3 = Instance.new("Frame", screenGui)
			frame3.Name = "StickyBar"
			frame3.AnchorPoint = Vector2.new(0.5, 1)
			frame3.AutomaticSize = Enum.AutomaticSize.None
			frame3.Size = UDim2.new(0, 500 * slicedn2, 0, 42 * slicedn2)
			frame3.Position = UDim2.new(0.5, 0, 1, _G.YesIsPhone and -68 or -70)
			frame3.BackgroundColor3 = Color3.fromRGB(23, 8, 34)
			frame3.BackgroundTransparency = 0.02
			frame3.BorderSizePixel = 0
			frame3.ClipsDescendants = false
			frame3.ZIndex = 70
			Instance.new("UICorner", frame3).CornerRadius = UDim.new(0, math.floor(8 * slicedn2))
			local uiStroke = Instance.new("UIStroke", frame3)
			uiStroke.Color = Color3.fromRGB(199, 120, 255)
			uiStroke.Thickness = 1
			uiStroke.Transparency = 0.35
			local uiPadding = Instance.new("UIPadding", frame3)
			uiPadding.PaddingLeft = UDim.new(0, math.floor(10 * slicedn2))
			uiPadding.PaddingRight = UDim.new(0, math.floor(10 * slicedn2))
			local uiListLayout2 = Instance.new("UIListLayout", frame3)
			uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
			uiListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
			uiListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
			uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
			uiListLayout2.Padding = UDim.new(0, math.floor(14 * slicedn2))
			local frame4 = Instance.new("Frame", frame3)
			frame4.LayoutOrder = 1
			local floor = math.floor
			frame4.Size = UDim2.fromOffset(math.floor(7 * slicedn2), floor(7 * slicedn2))
			frame4.BackgroundColor3 = Color3.fromRGB(186, 90, 255)
			frame4.BorderSizePixel = 0
			frame4.ZIndex = 72
			Instance.new("UICorner", frame4).CornerRadius = UDim.new(1, 0)
			local textLabel3 = Instance.new("TextLabel", frame3)
			textLabel3.LayoutOrder = 2
			textLabel3.AutomaticSize = Enum.AutomaticSize.X
			textLabel3.Size = UDim2.new(0, 0, 1, 0)
			textLabel3.BackgroundTransparency = 1
			textLabel3.Font = Enum.Font.GothamBlack
			textLabel3.TextSize = math.floor(14 * slicedn2)
			textLabel3.TextColor3 = Color3.new(1, 1, 1)
			local uiGradient = Instance.new("UIGradient", textLabel3)
			local colorSequence = ColorSequence.new
			local slicedtbl8 = {}
			local slicedv8 = ColorSequenceKeypoint.new(0, Color3.fromRGB(149, 0, 255))
			local slicedv9 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(149, 0, 255))
			local new = ColorSequenceKeypoint.new
			local color = Color3.fromRGB
			slicedtbl8[1] = slicedv8
			slicedtbl8[2] = slicedv9
			do
				local values = table.pack(new(1, color(255, 255, 255)))
				table.move(values, 1, values.n, 3, slicedtbl8)
			end
			uiGradient.Color = colorSequence(slicedtbl8)
			textLabel3.TextXAlignment = Enum.TextXAlignment.Left
			textLabel3.TextTruncate = Enum.TextTruncate.None
			textLabel3.TextWrapped = false
			textLabel3.ClipsDescendants = false
			textLabel3.ZIndex = 72
			textLabel3.Text = "NINJA HUB"
			local frame5 = Instance.new("Frame", frame3)
			frame5.LayoutOrder = 3
			frame5.Size = UDim2.new(0, 1, 0.6, 0)
			frame5.BackgroundColor3 = Color3.fromRGB(199, 120, 255)
			frame5.BackgroundTransparency = 0.35
			frame5.BorderSizePixel = 0
			frame5.ZIndex = 72
			local textLabel4 = Instance.new("TextLabel", frame3)
			textLabel4.LayoutOrder = 4
			textLabel4.AutomaticSize = Enum.AutomaticSize.X
			textLabel4.Size = UDim2.new(0, 0, 1, 0)
			textLabel4.BackgroundTransparency = 1
			textLabel4.Font = Enum.Font.GothamBlack
			textLabel4.TextSize = math.floor(14 * slicedn2)
			textLabel4.TextColor3 = Color3.new(1, 1, 1)
			local uiGradient2 = Instance.new("UIGradient", textLabel4)
			local colorSequence2 = ColorSequence.new
			local slicedtbl9 = {}
			local slicedv10 = ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 100, 255))
			local slicedv11 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(215, 160, 255))
			local new2 = ColorSequenceKeypoint.new
			local color2 = Color3.fromRGB
			slicedtbl9[1] = slicedv10
			slicedtbl9[2] = slicedv11
			do
				local values = table.pack(new2(1, color2(200, 220, 255)))
				table.move(values, 1, values.n, 3, slicedtbl9)
			end
			uiGradient2.Color = colorSequence2(slicedtbl9)
			textLabel4.TextXAlignment = Enum.TextXAlignment.Left
			textLabel4.TextTruncate = Enum.TextTruncate.None
			textLabel4.TextWrapped = false
			textLabel4.ClipsDescendants = false
			textLabel4.ZIndex = 72
			textLabel4.Text = "Ninja Hub"
			local frame6 = Instance.new("Frame", frame3)
			frame6.LayoutOrder = 5
			frame6.Size = UDim2.new(0, 1, 0.65, 0)
			frame6.BackgroundColor3 = Color3.fromRGB(199, 120, 255)
			frame6.BackgroundTransparency = 0.4
			frame6.BorderSizePixel = 0
			frame6.ZIndex = 72
			local frame7 = Instance.new("Frame", frame3)
			frame7.LayoutOrder = 6
			frame7.Size = UDim2.new(0, math.floor(38 * slicedn2), 1, 0)
			frame7.BackgroundTransparency = 1
			frame7.ZIndex = 72
			local textLabel5 = Instance.new("TextLabel", frame7)
			textLabel5.Size = UDim2.new(1, 0, 0.42, 0)
			textLabel5.Position = UDim2.new(0, 0, 0, 0)
			textLabel5.BackgroundTransparency = 1
			textLabel5.Font = Enum.Font.GothamBlack
			textLabel5.TextSize = math.floor(8 * slicedn2)
			textLabel5.TextColor3 = Color3.fromRGB(224, 180, 255)
			textLabel5.TextXAlignment = Enum.TextXAlignment.Center
			textLabel5.TextYAlignment = Enum.TextYAlignment.Bottom
			textLabel5.Text = "FPS"
			textLabel5.ZIndex = 72
			local textLabel6 = Instance.new("TextLabel", frame7)
			textLabel6.Size = UDim2.new(1, 0, 0.58, 0)
			textLabel6.Position = UDim2.new(0, 0, 0.42, 0)
			textLabel6.BackgroundTransparency = 1
			textLabel6.Font = Enum.Font.GothamBlack
			textLabel6.TextSize = math.floor(13 * slicedn2)
			textLabel6.TextColor3 = Color3.fromRGB(120, 230, 140)
			textLabel6.TextXAlignment = Enum.TextXAlignment.Center
			textLabel6.TextYAlignment = Enum.TextYAlignment.Top
			textLabel6.Text = "0"
			textLabel6.ZIndex = 72
			local frame8 = Instance.new("Frame", frame3)
			frame8.LayoutOrder = 7
			frame8.Size = UDim2.new(0, 1, 0.65, 0)
			frame8.BackgroundColor3 = Color3.fromRGB(199, 120, 255)
			frame8.BackgroundTransparency = 0.4
			frame8.BorderSizePixel = 0
			frame8.ZIndex = 72
			local frame9 = Instance.new("Frame", frame3)
			frame9.LayoutOrder = 8
			frame9.Size = UDim2.new(0, math.floor(44 * slicedn2), 1, 0)
			frame9.BackgroundTransparency = 1
			frame9.ZIndex = 72
			local textLabel7 = Instance.new("TextLabel", frame9)
			textLabel7.Size = UDim2.new(1, 0, 0.42, 0)
			textLabel7.Position = UDim2.new(0, 0, 0, 0)
			textLabel7.BackgroundTransparency = 1
			textLabel7.Font = Enum.Font.GothamBlack
			textLabel7.TextSize = math.floor(8 * slicedn2)
			textLabel7.TextColor3 = Color3.fromRGB(224, 180, 255)
			textLabel7.TextXAlignment = Enum.TextXAlignment.Center
			textLabel7.TextYAlignment = Enum.TextYAlignment.Bottom
			textLabel7.Text = "PING"
			textLabel7.ZIndex = 72
			local textLabel8 = Instance.new("TextLabel", frame9)
			textLabel8.Size = UDim2.new(1, 0, 0.58, 0)
			textLabel8.Position = UDim2.new(0, 0, 0.42, 0)
			textLabel8.BackgroundTransparency = 1
			textLabel8.Font = Enum.Font.GothamBlack
			textLabel8.TextSize = math.floor(13 * slicedn2)
			textLabel8.TextColor3 = Color3.fromRGB(120, 230, 140)
			textLabel8.TextXAlignment = Enum.TextXAlignment.Center
			textLabel8.TextYAlignment = Enum.TextYAlignment.Top
			textLabel8.Text = "0ms"
			textLabel8.ZIndex = 72
			task.spawn(function()
				local RunService2 = game:GetService("RunService")
				local Stats = game:GetService("Stats")
				local slicedn3 = 0
				local slicedn4 = 0
				RunService2.RenderStepped:Connect(function(deltaTime)
					slicedn3 += deltaTime
					slicedn4 += 1
					if slicedn3 >= 0.5 then
						textLabel6.Text = tostring(math.floor(slicedn4 / slicedn3 + 0.5))
						slicedn3 = 0
						slicedn4 = 0
					end
				end)
				while task.wait(1) do
					local ok, result = pcall(function()
						return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
					end)
					if ok and result then textLabel8.Text = tostring(result) .. "ms" end
				end
			end)
		end
		local kzBUJxAKwhtf = playerGui:FindFirstChild("kzBUJxAKwhtf")
		if kzBUJxAKwhtf then kzBUJxAKwhtf:Destroy() end
		local slicedtbl8, createUICorner, createUIStroke, slicedfn19, textButton, textButton2, slicedfn20, nearest, highest, priority
		local instantSteal2
		do
			local screenGui = Instance.new("ScreenGui")
			screenGui.Name = "kzBUJxAKwhtf"
			screenGui.ResetOnSpawn = false
			screenGui.IgnoreGuiInset = true
			screenGui.DisplayOrder = 999
			screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			screenGui.Parent = hui
			local frame3 = Instance.new("Frame", screenGui)
			frame3.Name = "TargetControlsFrame"
			tbl.TargetControlsFrame = frame3
			frame3.AutomaticSize = Enum.AutomaticSize.Y
			frame3.Size = UDim2.new(0, 320, 0, 0)
			local x = slicedv2.Positions.TargetControls and slicedv2.Positions.TargetControls.X
			local y = slicedv2.Positions.TargetControls and slicedv2.Positions.TargetControls.Y
			local offsetX = slicedv2.Positions.TargetControls and slicedv2.Positions.TargetControls.OffsetX
			local offsetY = slicedv2.Positions.TargetControls and slicedv2.Positions.TargetControls.OffsetY
			if x == nil or y == nil then
				x = slicedv2.Positions.AutoSteal.X + 0.28
				y = slicedv2.Positions.AutoSteal.Y
				if x > 0.78 then x = math.max(0.02, slicedv2.Positions.AutoSteal.X - 0.28) end
				if y > 0.72 then y = 0.72 end
				slicedv2.Positions.TargetControls = { X = x, Y = y }
			end
			frame3.Position = UDim2.new(x or 0.26, offsetX or 10, y or 0.35, offsetY or 0)
			frame3.BackgroundColor3 = Color3.fromRGB(23, 8, 34)
			frame3.BackgroundTransparency = 0
			frame3.BorderSizePixel = 0
			frame3.ClipsDescendants = false
			frame3.ZIndex = 100
			slicedfn6(frame3)
			slicedtbl8 = {
				BG = Color3.fromRGB(23, 8, 34),
				SURF = Color3.fromRGB(40, 14, 58),
				SURF2 = Color3.fromRGB(58, 22, 84),
				TEXT = Color3.fromRGB(235, 250, 255),
				DIM = Color3.fromRGB(184, 120, 230),
				AQUA = Color3.fromRGB(186, 90, 255),
				AQUA2 = Color3.fromRGB(139, 40, 210),
				AQUA_STROKE = Color3.fromRGB(199, 120, 255),
				GREEN1 = Color3.fromRGB(139, 40, 210),
				GREEN2 = Color3.fromRGB(186, 90, 255),
				GREEN_STROKE = Color3.fromRGB(199, 120, 255),
				OFF_BG = Color3.fromRGB(64, 24, 92),
				OFF_TEXT = Color3.fromRGB(197, 150, 230),
			}
			createUICorner = function(parent, arg)
				local uiCorner = Instance.new("UICorner")
				uiCorner.CornerRadius = UDim.new(0, arg)
				uiCorner.Parent = parent
				return uiCorner
			end
			createUIStroke = function(parent, color, thickness, transparency)
				local uiStroke = Instance.new("UIStroke")
				uiStroke.Color = color
				uiStroke.Thickness = thickness or 1
				uiStroke.Transparency = transparency or 0
				uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				uiStroke.Parent = parent
				return uiStroke
			end
			slicedfn19 = function(arg, slicedarg2, slicedarg3, slicedarg4, slicedarg5)
				tweenService:Create(arg, TweenInfo.new(slicedarg2 or 0.2, slicedarg4 or Enum.EasingStyle.Quint, slicedarg5 or Enum.EasingDirection.Out), slicedarg3):Play()
			end
			local function createUIGradient(parent, arg, slicedarg2, rotation)
				local uiGradient = Instance.new("UIGradient")
				uiGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, arg), ColorSequenceKeypoint.new(1, slicedarg2) })
				uiGradient.Rotation = rotation or 0
				uiGradient.Parent = parent
				return uiGradient
			end
			createUICorner(frame3, 16)
			createUIStroke(frame3, slicedtbl8.AQUA_STROKE, 1.2, 0.4)
			local frame4 = Instance.new("Frame", frame3)
			frame4.Size = UDim2.new(1, 0, 0, 50)
			frame4.BackgroundTransparency = 1
			frame4.ZIndex = 101
			slicedfn7(frame4, frame3, "TargetControls")
			local textLabel3 = Instance.new("TextLabel", frame4)
			textLabel3.Size = UDim2.new(1, -24, 0, 30)
			textLabel3.Position = UDim2.new(0, 12, 0, 10)
			textLabel3.ZIndex = 102
			textLabel3.BackgroundTransparency = 1
			textLabel3.Text = "TARGET CONTROLS"
			textLabel3.Font = Enum.Font.GothamBlack
			textLabel3.TextSize = 22
			textLabel3.TextColor3 = slicedtbl8.TEXT
			textLabel3.TextXAlignment = Enum.TextXAlignment.Center
			local frame5 = Instance.new("Frame", frame3)
			frame5.AnchorPoint = Vector2.new(0.5, 0)
			frame5.Position = UDim2.new(0.5, 0, 0, 44)
			frame5.Size = UDim2.new(0, 120, 0, 2)
			frame5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			frame5.BackgroundTransparency = 0.15
			frame5.BorderSizePixel = 0
			frame5.ZIndex = 101
			local frame6 = Instance.new("Frame", frame3)
			frame6.Size = UDim2.new(1, -16, 0, 30)
			frame6.Position = UDim2.fromOffset(8, 50)
			frame6.BackgroundTransparency = 1
			frame6.BorderSizePixel = 0
			frame6.ZIndex = 110
			textButton = Instance.new("TextButton", frame6)
			textButton.Size = UDim2.new(0.5, -3, 1, 0)
			textButton.Position = UDim2.new(0, 0, 0, 0)
			textButton.BackgroundColor3 = slicedtbl8.GREEN1
			textButton.TextColor3 = Color3.fromRGB(232, 255, 240)
			textButton.Text = "Main"
			textButton.Font = Enum.Font.GothamBold
			textButton.TextSize = 12
			textButton.BorderSizePixel = 0
			textButton.AutoButtonColor = false
			textButton.ZIndex = 110
			createUICorner(textButton, 6)
			textButton2 = Instance.new("TextButton", frame6)
			textButton2.Size = UDim2.new(0.5, -3, 1, 0)
			textButton2.Position = UDim2.new(0.5, 3, 0, 0)
			textButton2.BackgroundColor3 = slicedtbl8.OFF_BG
			textButton2.TextColor3 = slicedtbl8.OFF_TEXT
			textButton2.Text = "Settings"
			textButton2.Font = Enum.Font.GothamBold
			textButton2.TextSize = 12
			textButton2.BorderSizePixel = 0
			textButton2.AutoButtonColor = false
			textButton2.ZIndex = 110
			createUICorner(textButton2, 6)
			local frame7 = Instance.new("Frame", frame3)
			frame7.Name = "TabContent"
			frame7.Size = UDim2.new(1, -16, 0, 280)
			frame7.Position = UDim2.fromOffset(8, 86)
			frame7.BackgroundTransparency = 1
			frame7.ClipsDescendants = true
			frame7.ZIndex = 101
			local scrollingFrame2 = Instance.new("ScrollingFrame", frame7)
			scrollingFrame2.Name = "MainPage"
			scrollingFrame2.Size = UDim2.fromScale(1, 1)
			scrollingFrame2.BackgroundColor3 = slicedtbl8.SURF
			scrollingFrame2.BorderSizePixel = 0
			scrollingFrame2.ZIndex = 101
			scrollingFrame2.ClipsDescendants = true
			scrollingFrame2.ScrollBarThickness = 4
			scrollingFrame2.ScrollBarImageColor3 = slicedtbl8.AQUA2
			scrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, 0)
			scrollingFrame2.AutomaticCanvasSize = Enum.AutomaticSize.Y
			createUICorner(scrollingFrame2, 14)
			createUIStroke(scrollingFrame2, slicedtbl8.AQUA_STROKE, 1, 0.48)
			local frame8 = Instance.new("Frame", scrollingFrame2)
			frame8.AutomaticSize = Enum.AutomaticSize.Y
			frame8.Size = UDim2.new(1, -8, 0, 0)
			frame8.Position = UDim2.fromOffset(4, 4)
			frame8.BackgroundTransparency = 1
			frame8.ZIndex = 102
			local uiListLayout2 = Instance.new("UIListLayout")
			uiListLayout2.Padding = UDim.new(0, 5)
			uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
			uiListLayout2.Parent = frame8
			local slicedn3 = 1
			Instance.new("UIPadding", frame8).PaddingBottom = UDim.new(0, 12)
			slicedfn20 = function(arg, text, slicedarg2)
				local frame9 = Instance.new("Frame", arg)
				frame9.Name = text:gsub("%s+", "") .. "Row"
				frame9.Size = UDim2.new(1, 0, 0, math.floor(38 * slicedn3))
				frame9.BackgroundColor3 = slicedtbl8.SURF2
				frame9.BackgroundTransparency = 0.02
				frame9.BorderSizePixel = 0
				frame9.LayoutOrder = math.floor((slicedarg2 or 0) / math.max(1, 42 * slicedn3)) + 1
				frame9.ZIndex = 103
				createUICorner(frame9, 10)
				local slicedv8 = createUIStroke(frame9, slicedtbl8.AQUA_STROKE, 1, 0.52)
				local textLabel4 = Instance.new("TextLabel", frame9)
				textLabel4.BackgroundTransparency = 1
				textLabel4.Position = UDim2.fromOffset(10, 0)
				textLabel4.Size = UDim2.new(1, -90, 1, 0)
				textLabel4.Font = Enum.Font.GothamBold
				textLabel4.Text = text
				textLabel4.TextColor3 = slicedtbl8.TEXT
				textLabel4.TextSize = 13 * slicedn3
				textLabel4.TextXAlignment = Enum.TextXAlignment.Left
				textLabel4.ZIndex = 104
				local textButton3 = Instance.new("TextButton", frame9)
				textButton3.Name = text:gsub("%s+", "") .. "Toggle"
				textButton3.AutoButtonColor = false
				local floor = math.floor
				local slicedn4 = 26 * slicedn3
				textButton3.Size = UDim2.fromOffset(math.floor(72 * slicedn3), floor(slicedn4))
				textButton3.Position = UDim2.new(1, -math.floor(80 * slicedn3), 0.5, -math.floor(13 * slicedn3))
				textButton3.BackgroundColor3 = slicedtbl8.OFF_BG
				textButton3.BorderSizePixel = 0
				textButton3.Text = ""
				textButton3.ZIndex = 104
				createUICorner(textButton3, 6)
				local slicedv9 = createUIStroke(textButton3, slicedtbl8.AQUA_STROKE, 1, 0.55)
				local frame10 = Instance.new("Frame", textButton3)
				frame10.Size = UDim2.new(1, 0, 1, 0)
				frame10.BackgroundTransparency = 1
				frame10.BorderSizePixel = 0
				frame10.ZIndex = 104
				createUICorner(frame10, 6)
				createUIGradient(frame10, slicedtbl8.GREEN1, slicedtbl8.GREEN2, 0)
				local textLabel5 = Instance.new("TextLabel", textButton3)
				textLabel5.BackgroundTransparency = 1
				textLabel5.Size = UDim2.fromScale(1, 1)
				textLabel5.Font = Enum.Font.GothamBold
				textLabel5.TextSize = 11 * slicedn3
				textLabel5.Text = "OFF"
				textLabel5.TextColor3 = slicedtbl8.OFF_TEXT
				textLabel5.ZIndex = 105
				frame9.MouseEnter:Connect(function()
					slicedfn19(frame9, 0.14, { BackgroundColor3 = Color3.fromRGB(58, 22, 84) })
					slicedfn19(slicedv8, 0.14, { Transparency = 0.38 })
				end)
				frame9.MouseLeave:Connect(function()
					slicedfn19(frame9, 0.14, { BackgroundColor3 = slicedtbl8.SURF2 })
					slicedfn19(slicedv8, 0.14, { Transparency = 0.52 })
				end)
				return {
					row = frame9,
					label = textLabel4,
					button = textButton3,
					knob = frame10,
					stateLabel = textLabel5,
					stroke = slicedv9,
					rowStroke = slicedv8,
				}
			end
			nearest = slicedfn20(frame8, "Nearest", 0)
			highest = slicedfn20(frame8, "Highest", 42 * slicedn3)
			priority = slicedfn20(frame8, "Priority", 84 * slicedn3)
			local frame9 = Instance.new("Frame", frame8)
			frame9.Name = "PriorityListRow"
			frame9.Size = UDim2.new(1, 0, 0, math.floor(38 * slicedn3))
			frame9.BackgroundColor3 = slicedtbl8.SURF2
			frame9.BackgroundTransparency = 0.02
			frame9.BorderSizePixel = 0
			frame9.LayoutOrder = math.floor(126 * slicedn3 / math.max(1, 42 * slicedn3)) + 1
			frame9.ZIndex = 103
			createUICorner(frame9, 10)
			local slicedv8 = createUIStroke(frame9, slicedtbl8.AQUA_STROKE, 1, 0.52)
			local textLabel4 = Instance.new("TextLabel", frame9)
			textLabel4.BackgroundTransparency = 1
			textLabel4.Position = UDim2.fromOffset(10, 0)
			textLabel4.Size = UDim2.new(1, -90, 1, 0)
			textLabel4.Font = Enum.Font.GothamBold
			textLabel4.Text = "Priority List"
			textLabel4.TextColor3 = slicedtbl8.TEXT
			textLabel4.TextSize = 13 * slicedn3
			textLabel4.TextXAlignment = Enum.TextXAlignment.Left
			textLabel4.ZIndex = 104
			local textButton3 = Instance.new("TextButton", frame9)
			textButton3.Name = "PriorityListButton"
			textButton3.AutoButtonColor = false
			local floor = math.floor
			textButton3.Size = UDim2.fromOffset(math.floor(72 * slicedn3), floor(26 * slicedn3))
			textButton3.Position = UDim2.new(1, -math.floor(80 * slicedn3), 0.5, -math.floor(13 * slicedn3))
			textButton3.BackgroundColor3 = slicedtbl8.AQUA2
			textButton3.BorderSizePixel = 0
			textButton3.Text = "OPEN"
			textButton3.TextColor3 = slicedtbl8.TEXT
			textButton3.TextSize = 11 * slicedn3
			textButton3.Font = Enum.Font.GothamBold
			textButton3.ZIndex = 104
			createUICorner(textButton3, 6)
			createUIStroke(textButton3, slicedtbl8.AQUA_STROKE, 1, 0.55)
			frame9.MouseEnter:Connect(function()
				slicedfn19(frame9, 0.14, { BackgroundColor3 = Color3.fromRGB(58, 22, 84) })
				slicedfn19(slicedv8, 0.14, { Transparency = 0.38 })
			end)
			frame9.MouseLeave:Connect(function()
				slicedfn19(frame9, 0.14, { BackgroundColor3 = slicedtbl8.SURF2 })
				slicedfn19(slicedv8, 0.14, { Transparency = 0.52 })
			end)
			local slicedflag4 = false
			local slicedv9 = nil
			textButton3.MouseButton1Click:Connect(function()
				if slicedv9 then
					slicedv9:Destroy()
					slicedv9 = nil
					slicedflag4 = false
					textButton3.Text = "OPEN"
					return
				end
				local screenGui2 = Instance.new("ScreenGui")
				screenGui2.Name = "PriorityEditor"
				screenGui2.ResetOnSpawn = false
				screenGui2.Parent = gethui and gethui() or game:GetService("CoreGui")
				local frame10 = Instance.new("Frame")
				frame10.Size = UDim2.new(0, 340, 0, 500)
				frame10.AnchorPoint = Vector2.new(0.5, 0.5)
				frame10.Position = UDim2.new(0.5, 0, 0.5, 0)
				frame10.BackgroundColor3 = Color3.fromRGB(23, 8, 34)
				frame10.BorderSizePixel = 0
				frame10.Parent = screenGui2
				Instance.new("UICorner", frame10).CornerRadius = UDim.new(0, 12)
				local uiStroke = Instance.new("UIStroke", frame10)
				uiStroke.Color = slicedtbl8.AQUA_STROKE
				uiStroke.Thickness = 1.2
				uiStroke.Transparency = 0.3
				local textLabel5 = Instance.new("TextLabel", frame10)
				textLabel5.Size = UDim2.new(1, 0, 0, 50)
				textLabel5.BackgroundTransparency = 1
				textLabel5.Text = "PRIORITY LIST"
				textLabel5.Font = Enum.Font.GothamBlack
				textLabel5.TextSize = 22
				textLabel5.TextColor3 = slicedtbl8.TEXT
				textLabel5.TextXAlignment = Enum.TextXAlignment.Center
				local textButton4 = Instance.new("TextButton", frame10)
				textButton4.Size = UDim2.new(0, 36, 0, 36)
				textButton4.Position = UDim2.new(1, -44, 0, 7)
				textButton4.BackgroundColor3 = slicedtbl8.SURF2
				textButton4.Text = "X"
				textButton4.Font = Enum.Font.GothamBold
				textButton4.TextSize = 16
				textButton4.TextColor3 = slicedtbl8.TEXT
				textButton4.AutoButtonColor = false
				Instance.new("UICorner", textButton4).CornerRadius = UDim.new(0, 8)
				textButton4.MouseButton1Click:Connect(function()
					screenGui2:Destroy()
					slicedv9 = nil
					slicedflag4 = false
					textButton3.Text = "OPEN"
				end)
				local scrollingFrame3 = Instance.new("ScrollingFrame", frame10)
				scrollingFrame3.Size = UDim2.new(1, -16, 1, -80)
				scrollingFrame3.Position = UDim2.new(0, 8, 0, 60)
				scrollingFrame3.BackgroundTransparency = 1
				scrollingFrame3.BorderSizePixel = 0
				scrollingFrame3.ScrollBarThickness = 3
				scrollingFrame3.ScrollBarImageColor3 = slicedtbl8.AQUA_STROKE
				scrollingFrame3.CanvasSize = UDim2.new(0, 0, 0, 0)
				local uiListLayout3 = Instance.new("UIListLayout", scrollingFrame3)
				uiListLayout3.Padding = UDim.new(0, 4)
				uiListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
				uiListLayout3:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					scrollingFrame3.CanvasSize = UDim2.new(0, 0, 0, uiListLayout3.AbsoluteContentSize.Y + 10)
				end)
				local slicedfn21 = nil
				slicedfn21 = function()
					for _, child in ipairs(scrollingFrame3:GetChildren()) do if child:IsA("Frame") and child.Name == "Item" then child:Destroy() end end
					for i, slicedv10 in ipairs(slicedtbl3) do
						local frame11 = Instance.new("Frame", scrollingFrame3)
						frame11.Name = "Item"
						frame11.Size = UDim2.new(1, 0, 0, 40)
						frame11.BackgroundColor3 = slicedtbl8.SURF2
						frame11.BackgroundTransparency = 0.05
						frame11.BorderSizePixel = 0
						Instance.new("UICorner", frame11).CornerRadius = UDim.new(0, 6)
						local textLabel6 = Instance.new("TextLabel", frame11)
						textLabel6.Size = UDim2.new(1, -90, 1, 0)
						textLabel6.Position = UDim2.new(0, 10, 0, 0)
						textLabel6.BackgroundTransparency = 1
						textLabel6.Text = tostring(i) .. ". " .. slicedv10
						textLabel6.Font = Enum.Font.GothamBold
						textLabel6.TextSize = 13
						textLabel6.TextColor3 = slicedtbl8.TEXT
						textLabel6.TextXAlignment = Enum.TextXAlignment.Left
						local textButton5 = Instance.new("TextButton", frame11)
						textButton5.Size = UDim2.new(0, 30, 0, 30)
						textButton5.Position = UDim2.new(1, -70, 0.5, -15)
						textButton5.BackgroundColor3 = slicedtbl8.AQUA2
						textButton5.Text = "â²"
						textButton5.Font = Enum.Font.GothamBold
						textButton5.TextSize = 14
						textButton5.TextColor3 = slicedtbl8.TEXT
						textButton5.AutoButtonColor = false
						Instance.new("UICorner", textButton5).CornerRadius = UDim.new(0, 5)
						textButton5.MouseButton1Click:Connect(function()
							if i > 1 then
								local slicedv11 = slicedtbl3
								local slicedn4 = i - 1
								local slicedv12 = slicedtbl3[i]
								slicedtbl3[i] = slicedtbl3[i - 1]
								slicedv11[slicedn4] = slicedv12
								slicedfn5()
								fn()
								slicedfn21()
								tbl.ListNeedsRedraw = true
								if tbl.UpdateAutoStealUI then tbl.UpdateAutoStealUI() end
							end
						end)
						local textButton6 = Instance.new("TextButton", frame11)
						textButton6.Size = UDim2.new(0, 30, 0, 30)
						textButton6.Position = UDim2.new(1, -36, 0.5, -15)
						textButton6.BackgroundColor3 = slicedtbl8.AQUA2
						textButton6.Text = "â¼"
						textButton6.Font = Enum.Font.GothamBold
						textButton6.TextSize = 14
						textButton6.TextColor3 = slicedtbl8.TEXT
						textButton6.AutoButtonColor = false
						Instance.new("UICorner", textButton6).CornerRadius = UDim.new(0, 5)
						textButton6.MouseButton1Click:Connect(function()
							if i < #slicedtbl3 then
								local slicedv11 = slicedtbl3
								local slicedn4 = i + 1
								local slicedv12 = slicedtbl3[i]
								slicedtbl3[i] = slicedtbl3[i + 1]
								slicedv11[slicedn4] = slicedv12
								slicedfn5()
								fn()
								slicedfn21()
								tbl.ListNeedsRedraw = true
								if tbl.UpdateAutoStealUI then tbl.UpdateAutoStealUI() end
							end
						end)
					end
				end
				slicedfn21()
				slicedv9 = screenGui2
				slicedflag4 = true
				textButton3.Text = "CLOSE"
				slicedfn7(frame10, frame10)
			end)
			instantSteal2 = slicedfn20(frame8, "Instant Steal", 168 * slicedn3)
			local function slicedfn21(text, text2, arg, slicedarg2)
				local frame10 = Instance.new("Frame", frame8)
				frame10.Name = text:gsub("%s+", "") .. "Row"
				frame10.Size = UDim2.new(1, 0, 0, math.floor(38 * slicedn3))
				frame10.BackgroundColor3 = slicedtbl8.SURF2
				frame10.BackgroundTransparency = 0.02
				frame10.BorderSizePixel = 0
				frame10.LayoutOrder = math.floor(arg * slicedn3 / math.max(1, 42 * slicedn3)) + 1
				frame10.ZIndex = 103
				createUICorner(frame10, 10)
				local slicedv10 = createUIStroke(frame10, slicedtbl8.AQUA_STROKE, 1, 0.52)
				local textLabel5 = Instance.new("TextLabel", frame10)
				textLabel5.BackgroundTransparency = 1
				textLabel5.Position = UDim2.fromOffset(10, 0)
				textLabel5.Size = UDim2.new(1, -90, 1, 0)
				textLabel5.Font = Enum.Font.GothamBold
				textLabel5.Text = text
				textLabel5.TextColor3 = slicedtbl8.TEXT
				textLabel5.TextSize = 13 * slicedn3
				textLabel5.TextXAlignment = Enum.TextXAlignment.Left
				textLabel5.ZIndex = 104
				local textButton4 = Instance.new("TextButton", frame10)
				textButton4.Name = text:gsub("%s+", "") .. "Button"
				textButton4.AutoButtonColor = false
				local floor2 = math.floor
				local slicedn4 = 26 * slicedn3
				textButton4.Size = UDim2.fromOffset(math.floor(72 * slicedn3), floor2(slicedn4))
				textButton4.Position = UDim2.new(1, -math.floor(80 * slicedn3), 0.5, -math.floor(13 * slicedn3))
				textButton4.BackgroundColor3 = slicedtbl8.AQUA2
				textButton4.BorderSizePixel = 0
				textButton4.Text = text2
				textButton4.TextColor3 = slicedtbl8.TEXT
				textButton4.TextSize = 11 * slicedn3
				textButton4.Font = Enum.Font.GothamBold
				textButton4.ZIndex = 104
				createUICorner(textButton4, 6)
				createUIStroke(textButton4, slicedtbl8.AQUA_STROKE, 1, 0.55)
				frame10.MouseEnter:Connect(function()
					slicedfn19(frame10, 0.14, { BackgroundColor3 = Color3.fromRGB(58, 22, 84) })
					slicedfn19(slicedv10, 0.14, { Transparency = 0.38 })
				end)
				frame10.MouseLeave:Connect(function()
					slicedfn19(frame10, 0.14, { BackgroundColor3 = slicedtbl8.SURF2 })
					slicedfn19(slicedv10, 0.14, { Transparency = 0.52 })
				end)
				textButton4.MouseButton1Click:Connect(function()
					textButton4.Text = "..."
					task.spawn(function()
						pcall(slicedarg2)
						task.wait(0.35)
						textButton4.Text = text2
					end)
				end)
				return frame10, textButton4
			end
			slicedfn21("Drop Brainrot", "DROP", 210, function()
				if type(_G.StickyDropBrainrot) == "function" then _G.StickyDropBrainrot() end
			end)
			slicedfn21("Instant Reset", "RESET", 252, function()
				if type(_G.StickyInstaReset) == "function" then _G.StickyInstaReset() end
			end)
			local carpetSpd = slicedfn20(frame8, "Carpet Spd", 294 * slicedn3)
			local function slicedfn22(arg)
				if arg then
					carpetSpd.button.BackgroundColor3 = slicedtbl8.GREEN1
					carpetSpd.knob.BackgroundTransparency = 0
					carpetSpd.stateLabel.Text = "ON"
					carpetSpd.stateLabel.TextColor3 = Color3.fromRGB(232, 255, 240)
					carpetSpd.stroke.Color = slicedtbl8.GREEN_STROKE
					carpetSpd.stroke.Transparency = 0.22
				else
					carpetSpd.button.BackgroundColor3 = slicedtbl8.OFF_BG
					carpetSpd.knob.BackgroundTransparency = 1
					carpetSpd.stateLabel.Text = "OFF"
					carpetSpd.stateLabel.TextColor3 = slicedtbl8.OFF_TEXT
					carpetSpd.stroke.Color = slicedtbl8.AQUA_STROKE
					carpetSpd.stroke.Transparency = 0.55
				end
				if carpetSpd.rowStroke then carpetSpd.rowStroke.Transparency = arg and 0.38 or 0.52 end
			end
			slicedfn22(_G.StickyCarpetSpeed == true)
			carpetSpd.button.MouseButton1Click:Connect(function()
				local slicedflag5 = not (_G.StickyCarpetSpeed == true)
				if _G.StickySetCarpetSpeed then _G.StickySetCarpetSpeed(slicedflag5) end
				slicedfn22(slicedflag5)
				if _G.StickySaveConfigNow then task.spawn(_G.StickySaveConfigNow) end
			end)
			_G.StickyOnBoot(function()
				slicedfn22(_G.StickyCarpetSpeed == true)
			end)
		end
		do
			local plots = workspace:WaitForChild("Plots")
			local folder = Instance.new("Folder")
			folder.Name = "ChocolaPodiumESP"
			folder.Parent = workspace
			local slicedflag4 = false
			local slicedtbl9 = {}
			local function slicedfn21(arg)
				local slicedtbl10 = {}
				for _, child in ipairs(arg:GetChildren()) do
					local base = child:FindFirstChild("Base", true) or child
					local result
					if base:IsA("Model") then
						local ok
						ok, result = pcall(function()
							return base:GetBoundingBox()
						end)
						ok = ok and result
						local slicedv8 = nil
						if not ok then result = slicedv8 end
					else
						result = nil
						if base:IsA("BasePart") then result = base.CFrame end
					end
					if result then
						local slicedflag5 = false
						for _, slicedv8 in ipairs(slicedtbl10) do
							if math.abs(slicedv8.y - result.Position.Y) <= 8 then
								slicedv8.y = slicedv8.y + (result.Position.Y - slicedv8.y) / (slicedv8.count + 1)
								slicedv8.count = slicedv8.count + 1
								slicedflag5 = true
								break
							end
						end
						if not slicedflag5 then table.insert(slicedtbl10, { y = result.Position.Y, count = 1 }) end
					end
				end
				table.sort(slicedtbl10, function(slicedarg2, slicedarg3)
					return slicedarg2.y < slicedarg3.y
				end)
				return slicedtbl10
			end
			local function slicedfn22(arg)
				if #arg >= 2 then
					local slicedn3 = arg[2].y - arg[1].y
					if slicedn3 > 8 then return slicedn3 end
				end
				return 18
			end
			local slicedtbl10 = {}
			local function slicedfn23(arg)
				for _, slicedv8 in ipairs(slicedtbl10) do if (arg - slicedv8).Magnitude <= 1.5 and math.abs(arg.Y - slicedv8.Y) <= 2 then return true end end
				return false
			end
			local function slicedfn24(arg, slicedarg2, slicedarg3)
				local slicedn3 = slicedarg3 * (slicedarg2 - 1)
				if slicedarg2 == 3 then slicedn3 -= 0.85 end
				return arg.Position + Vector3.new(0, slicedn3, 0)
			end
			local color = Color3.fromRGB(186, 90, 255)
			local surfaceTransparency = 0.82
			local function slicedfn25(arg)
				local animalPodiums = arg:FindFirstChild("AnimalPodiums")
				if not animalPodiums then return end
				local slicedv8 = slicedfn21(animalPodiums)
				if #slicedv8 == 0 then return end
				local slicedv9 = slicedfn22(slicedv8)
				local y = slicedv8[1].y
				slicedtbl10 = {}
				for _, child in ipairs(animalPodiums:GetChildren()) do
					local base = child:FindFirstChild("Base", true) or child
					local cFrame, size
					if base:IsA("Model") then
						local ok
						ok, cFrame, size = pcall(function()
							return base:GetBoundingBox()
						end)
						local slicedv10 = nil
						local slicedv11 = nil
						if not ok then
							cFrame = slicedv10
							size = slicedv11
						end
					else
						cFrame = nil
						size = nil
						if base:IsA("BasePart") then
							cFrame = base.CFrame
							size = base.Size
						end
					end
					if cFrame and size then
						local position = cFrame.Position
						table.insert(slicedtbl10, position)
						local part = Instance.new("Part")
						part.Name = "ChocolaPodium"
						part.Anchored = true
						part.CanCollide = false
						part.CanQuery = false
						part.CanTouch = false
						part.CastShadow = false
						part.Transparency = 1
						part.Size = size
						part.CFrame = cFrame
						part.Parent = folder
						local selectionBox = Instance.new("SelectionBox")
						selectionBox.Name = "ChocolaPodium"
						selectionBox.Adornee = part
						selectionBox.Color3 = color
						selectionBox.SurfaceColor3 = color
						selectionBox.LineThickness = 0.06
						selectionBox.Transparency = 0
						selectionBox.SurfaceTransparency = surfaceTransparency
						selectionBox.Parent = part
						if math.abs(position.Y - y) <= 8 then
							for i = 2, 3 do
								local slicedv10 = slicedfn24(cFrame, i, slicedv9)
								if not slicedfn23(slicedv10) then
									local part2 = Instance.new("Part")
									part2.Name = "ChocolaPodium"
									part2.Anchored = true
									part2.CanCollide = false
									part2.CanQuery = false
									part2.CanTouch = false
									part2.CastShadow = false
									part2.Transparency = 1
									part2.Size = Vector3.new(size.X, 0.5, size.Z)
									part2.CFrame = CFrame.new(slicedv10) * CFrame.new(0, -(size.Y - 0.5) / 2, 0)
									part2.Parent = folder
									local selectionBox2 = Instance.new("SelectionBox")
									selectionBox2.Name = "ChocolaPodium"
									selectionBox2.Adornee = part2
									selectionBox2.Color3 = color
									selectionBox2.SurfaceColor3 = color
									selectionBox2.LineThickness = 0.06
									selectionBox2.Transparency = 0
									selectionBox2.SurfaceTransparency = surfaceTransparency
									selectionBox2.Parent = part2
									table.insert(slicedtbl10, slicedv10)
								end
							end
						end
					end
				end
			end
			local function slicedfn26()
				folder:ClearAllChildren()
				if not slicedflag4 then return end
				for _, child in ipairs(plots:GetChildren()) do slicedfn25(child) end
			end
			local function slicedfn27()
				for _, slicedv8 in ipairs(slicedtbl9) do slicedv8:Disconnect() end
				slicedtbl9 = {}
				table.insert(slicedtbl9, plots.ChildAdded:Connect(slicedfn26))
				table.insert(slicedtbl9, plots.ChildRemoved:Connect(slicedfn26))
				for _, child in ipairs(plots:GetChildren()) do
					local animalPodiums = child:FindFirstChild("AnimalPodiums")
					if animalPodiums then
						table.insert(slicedtbl9, animalPodiums.ChildAdded:Connect(slicedfn26))
						table.insert(slicedtbl9, animalPodiums.ChildRemoved:Connect(slicedfn26))
						table.insert(slicedtbl9, animalPodiums.DescendantAdded:Connect(slicedfn26))
						table.insert(slicedtbl9, animalPodiums.DescendantRemoving:Connect(slicedfn26))
					end
				end
			end
			_G.setChocolaPodiumESP = function(arg)
				slicedflag4 = arg and true or false
				if slicedflag4 then
					slicedfn27()
					slicedfn26()
				else
					for _, slicedv8 in ipairs(slicedtbl9) do slicedv8:Disconnect() end
					slicedtbl9 = {}
					folder:ClearAllChildren()
				end
			end
			_G.getChocolaPodiumESP = function() return slicedflag4 end
		end
		do
			local targetControlsFrame = tbl.TargetControlsFrame
			local tabContent = targetControlsFrame:FindFirstChild("TabContent")
			local mainPage = tabContent and tabContent:FindFirstChild("MainPage")
			local scrollingFrame2 = Instance.new("ScrollingFrame", tabContent)
			scrollingFrame2.Name = "SettingsPage"
			scrollingFrame2.Size = UDim2.fromScale(1, 1)
			scrollingFrame2.BackgroundColor3 = slicedtbl8.SURF
			scrollingFrame2.BorderSizePixel = 0
			scrollingFrame2.ZIndex = 101
			scrollingFrame2.Visible = false
			scrollingFrame2.ClipsDescendants = true
			scrollingFrame2.ScrollBarThickness = 4
			scrollingFrame2.ScrollBarImageColor3 = slicedtbl8.AQUA2
			scrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, 0)
			scrollingFrame2.AutomaticCanvasSize = Enum.AutomaticSize.Y
			createUICorner(scrollingFrame2, 14)
			createUIStroke(scrollingFrame2, slicedtbl8.AQUA_STROKE, 1, 0.48)
			local frame3 = Instance.new("Frame", scrollingFrame2)
			frame3.AutomaticSize = Enum.AutomaticSize.Y
			frame3.Size = UDim2.new(1, -8, 0, 0)
			frame3.Position = UDim2.fromOffset(4, 4)
			frame3.BackgroundTransparency = 1
			frame3.ZIndex = 102
			local uiListLayout2 = Instance.new("UIListLayout", frame3)
			uiListLayout2.Padding = UDim.new(0, 5)
			uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
			local function slicedfn21(arg, slicedarg2)
				if not arg then return end
				if slicedarg2 then
					arg.button.BackgroundColor3 = slicedtbl8.GREEN1
					arg.knob.BackgroundTransparency = 0
					arg.stateLabel.Text = "ON"
					arg.stateLabel.TextColor3 = Color3.fromRGB(232, 255, 240)
					arg.stroke.Color = slicedtbl8.GREEN_STROKE
					arg.stroke.Transparency = 0.22
				else
					arg.button.BackgroundColor3 = slicedtbl8.OFF_BG
					arg.knob.BackgroundTransparency = 1
					arg.stateLabel.Text = "OFF"
					arg.stateLabel.TextColor3 = slicedtbl8.OFF_TEXT
					arg.stroke.Color = slicedtbl8.AQUA_STROKE
					arg.stroke.Transparency = 0.55
				end
				if arg.rowStroke then arg.rowStroke.Transparency = slicedarg2 and 0.38 or 0.52 end
			end
			_G.SlicedzSyncToggleUI = function()
			end
			local slicedv8 = slicedfn20(frame3, "X-Ray", 0)
			local playerEsp = slicedfn20(frame3, "Player ESP", 42)
			local nextBase = slicedfn20(frame3, "Next Base", 84)
			local autoKick = slicedfn20(frame3, "Auto Kick", 126)
			local infJump = slicedfn20(frame3, "Inf Jump", 168)
			local podiumEsp = slicedfn20(frame3, "Podium ESP", 252)
			local turretEsp = slicedfn20(frame3, "Turret ESP", 294)
			local trapEsp = slicedfn20(frame3, "Trap ESP", 336)
			local antiRagdoll = slicedfn20(frame3, "Anti Ragdoll", 378)
			local slicedv9 = slicedfn20(frame3, "Anti Bee/Disco", 420)
			local antiDie = slicedfn20(frame3, "Anti Die", 462)
			local autoTurret = slicedfn20(frame3, "Auto Turret", 504)
			local antiLag = slicedfn20(frame3, "Anti Lag", 546)
			local brainrotEsp = slicedfn20(frame3, "Brainrot ESP", 630)
			local podium = slicedfn20(frame3, "Podium", 672)
			slicedfn21(slicedv8, slicedv2.XRay == true)
			slicedfn21(playerEsp, slicedv2.PlayerESP == true)
			slicedfn21(nextBase, slicedv2.nextBaseEnabled == true)
			slicedfn21(autoKick, _G.StickyAutoKickOnSteal == true)
			slicedfn21(infJump, _G.StickyInfJump == true)
			slicedfn21(podiumEsp, slicedv2.podiumESP == true)
			slicedfn21(turretEsp, slicedv2.TurretESP == true)
			slicedfn21(trapEsp, slicedv2.TrapESP == true)
			slicedfn21(brainrotEsp, slicedv2.BrainrotESP == true)
			slicedfn21(antiRagdoll, slicedv2.AntiRagdoll ~= false)
			slicedfn21(slicedv9, slicedv2.AntiBeeDisco ~= false)
			slicedfn21(antiDie, slicedv2.AntiDie ~= false)
			slicedfn21(autoTurret, slicedv2.AutoTurret == true)
			slicedfn21(antiLag, slicedv2.AntiLag == true)
			slicedv8.button.MouseButton1Click:Connect(function()
				local xRay = not (slicedv2.XRay == true)
				slicedfn21(slicedv8, xRay)
				if type(_G.setXRay) == "function" then
					task.spawn(_G.setXRay, xRay)
				else
					slicedv2.XRay = xRay
					fn()
				end
			end)
			playerEsp.button.MouseButton1Click:Connect(function()
				local playerESP = not (slicedv2.PlayerESP == true)
				slicedfn21(playerEsp, playerESP)
				if type(_G.setPlayerESP) == "function" then
					task.spawn(_G.setPlayerESP, playerESP)
				else
					slicedv2.PlayerESP = playerESP
					fn()
				end
			end)
			nextBase.button.MouseButton1Click:Connect(function()
				local nextBaseEnabled = not (slicedv2.nextBaseEnabled == true)
				slicedfn21(nextBase, nextBaseEnabled)
				if type(_G.setNextBase) == "function" then
					task.spawn(_G.setNextBase, nextBaseEnabled)
				else
					slicedv2.nextBaseEnabled = nextBaseEnabled
					fn()
				end
			end)
			autoKick.button.MouseButton1Click:Connect(function()
				local stickyAutoKickOnSteal = not (_G.StickyAutoKickOnSteal == true)
				_G.StickyAutoKickOnSteal = stickyAutoKickOnSteal
				slicedfn21(autoKick, stickyAutoKickOnSteal)
				if _G.StickySaveConfigNow then task.spawn(_G.StickySaveConfigNow) end
			end)
			infJump.button.MouseButton1Click:Connect(function()
				local stickyInfJump = not (_G.StickyInfJump == true)
				_G.StickyInfJump = stickyInfJump
				slicedfn21(infJump, stickyInfJump)
				if _G.StickySaveConfigNow then task.spawn(_G.StickySaveConfigNow) end
			end)
			podiumEsp.button.MouseButton1Click:Connect(function()
				local podiumESP = not (slicedv2.podiumESP == true)
				slicedfn21(podiumEsp, podiumESP)
				if type(_G.setPodiumESP) == "function" then
					task.spawn(_G.setPodiumESP, podiumESP)
				else
					slicedv2.podiumESP = podiumESP
					fn()
				end
			end)
			turretEsp.button.MouseButton1Click:Connect(function()
				local turretESP = not (slicedv2.TurretESP == true)
				slicedfn21(turretEsp, turretESP)
				if type(_G.setTurretESP) == "function" then
					task.spawn(_G.setTurretESP, turretESP)
				else
					slicedv2.TurretESP = turretESP
					fn()
				end
			end)
			trapEsp.button.MouseButton1Click:Connect(function()
				local trapESP = not (slicedv2.TrapESP == true)
				slicedfn21(trapEsp, trapESP)
				if type(_G.setTrapESP) == "function" then
					task.spawn(_G.setTrapESP, trapESP)
				else
					slicedv2.TrapESP = trapESP
					fn()
				end
			end)
			brainrotEsp.button.MouseButton1Click:Connect(function()
				local brainrotESP = not (slicedv2.BrainrotESP == true)
				slicedfn21(brainrotEsp, brainrotESP)
				if type(_G.setBrainrotESP) == "function" then
					task.spawn(_G.setBrainrotESP, brainrotESP)
				else
					slicedv2.BrainrotESP = brainrotESP
					fn()
				end
			end)
			antiRagdoll.button.MouseButton1Click:Connect(function()
				local antiRagdoll2 = not (slicedv2.AntiRagdoll ~= false)
				slicedfn21(antiRagdoll, antiRagdoll2)
				if type(_G.setAntiRagdoll) == "function" then
					task.spawn(_G.setAntiRagdoll, antiRagdoll2)
				else
					slicedv2.AntiRagdoll = antiRagdoll2
					fn()
				end
			end)
			slicedv9.button.MouseButton1Click:Connect(function()
				local antiBeeDisco = not (slicedv2.AntiBeeDisco ~= false)
				slicedfn21(slicedv9, antiBeeDisco)
				if type(_G.setAntiBeeDisco) == "function" then
					task.spawn(_G.setAntiBeeDisco, antiBeeDisco)
				else
					slicedv2.AntiBeeDisco = antiBeeDisco
					fn()
				end
			end)
			antiDie.button.MouseButton1Click:Connect(function()
				local antiDie2 = not (slicedv2.AntiDie ~= false)
				slicedfn21(antiDie, antiDie2)
				if type(_G.setAntiDie) == "function" then
					task.spawn(_G.setAntiDie, antiDie2)
				else
					slicedv2.AntiDie = antiDie2
					fn()
				end
			end)
			autoTurret.button.MouseButton1Click:Connect(function()
				local autoTurret2 = not (slicedv2.AutoTurret == true)
				slicedfn21(autoTurret, autoTurret2)
				if type(_G.setAutoTurret) == "function" then
					task.spawn(_G.setAutoTurret, autoTurret2)
				else
					slicedv2.AutoTurret = autoTurret2
					fn()
				end
			end)
			antiLag.button.MouseButton1Click:Connect(function()
				local antiLag2 = not (slicedv2.AntiLag == true)
				slicedfn21(antiLag, antiLag2)
				if type(_G.setAntiLag) == "function" then
					task.spawn(_G.setAntiLag, antiLag2)
				else
					slicedv2.AntiLag = antiLag2
					fn()
				end
			end)
			podium.button.MouseButton1Click:Connect(function()
				local slicedflag4 = not _G.getChocolaPodiumESP()
				slicedfn21(podium, slicedflag4)
				if type(_G.setChocolaPodiumESP) == "function" then task.spawn(_G.setChocolaPodiumESP, slicedflag4) end
			end)
			local function slicedfn22(arg, text, slicedarg2, slicedarg3, slicedarg4)
				local frame4 = Instance.new("Frame", arg)
				frame4.Size = UDim2.new(1, 0, 0, 38)
				frame4.BackgroundColor3 = slicedtbl8.SURF2
				frame4.BackgroundTransparency = 0.02
				frame4.BorderSizePixel = 0
				frame4.LayoutOrder = math.floor(slicedarg2 / 42) + 1
				frame4.ZIndex = 103
				createUICorner(frame4, 10)
				createUIStroke(frame4, slicedtbl8.AQUA_STROKE, 1, 0.52)
				local textLabel3 = Instance.new("TextLabel", frame4)
				textLabel3.BackgroundTransparency = 1
				textLabel3.Position = UDim2.fromOffset(10, 0)
				textLabel3.Size = UDim2.new(0, 120, 1, 0)
				textLabel3.Font = Enum.Font.GothamBold
				textLabel3.Text = text
				textLabel3.TextColor3 = slicedtbl8.TEXT
				textLabel3.TextSize = 11
				textLabel3.TextXAlignment = Enum.TextXAlignment.Left
				textLabel3.ZIndex = 104
				local textBox = Instance.new("TextBox", frame4)
				textBox.Size = UDim2.new(0, 60, 0, 24)
				textBox.Position = UDim2.new(1, -74, 0.5, -12)
				textBox.BackgroundColor3 = slicedtbl8.BG
				textBox.BorderSizePixel = 0
				textBox.Text = tostring(slicedarg3)
				textBox.Font = Enum.Font.Gotham
				textBox.TextSize = 11
				textBox.TextColor3 = slicedtbl8.TEXT
				textBox.PlaceholderColor3 = slicedtbl8.DIM
				textBox.ZIndex = 104
				createUICorner(textBox, 6)
				textBox.FocusLost:Connect(function()
					slicedarg4(textBox)
				end)
				return frame4, textBox
			end
			slicedfn22(frame3, "Carpet Spd Val", 210, _G.StickyCarpetSpeedValue or 140, function(arg)
				local num = tonumber(arg.Text)
				if num then
					_G.StickyCarpetSpeedValue = math.clamp(num, 20, 400)
					arg.Text = tostring(_G.StickyCarpetSpeedValue)
				else
					arg.Text = tostring(_G.StickyCarpetSpeedValue or 140)
				end
				if _G.StickySaveConfigNow then task.spawn(_G.StickySaveConfigNow) end
			end)
			local function slicedfn23(arg, text, slicedarg2, slicedarg3, slicedarg4)
				local frame4 = Instance.new("Frame", arg)
				frame4.Size = UDim2.new(1, 0, 0, 38)
				frame4.BackgroundColor3 = slicedtbl8.SURF2
				frame4.BackgroundTransparency = 0.02
				frame4.BorderSizePixel = 0
				frame4.LayoutOrder = math.floor(slicedarg2 / 42) + 1
				frame4.ZIndex = 103
				createUICorner(frame4, 10)
				createUIStroke(frame4, slicedtbl8.AQUA_STROKE, 1, 0.52)
				local textLabel3 = Instance.new("TextLabel", frame4)
				textLabel3.BackgroundTransparency = 1
				textLabel3.Position = UDim2.fromOffset(10, 0)
				textLabel3.Size = UDim2.new(0, 120, 1, 0)
				textLabel3.Font = Enum.Font.GothamBold
				textLabel3.Text = text
				textLabel3.TextColor3 = slicedtbl8.TEXT
				textLabel3.TextSize = 11
				textLabel3.TextXAlignment = Enum.TextXAlignment.Left
				textLabel3.ZIndex = 104
				local textButton3 = Instance.new("TextButton", frame4)
				textButton3.Size = UDim2.new(0, 60, 0, 24)
				textButton3.Position = UDim2.new(1, -74, 0.5, -12)
				textButton3.BackgroundColor3 = slicedtbl8.AQUA2
				textButton3.BorderSizePixel = 0
				textButton3.AutoButtonColor = false
				textButton3.Text = tostring(slicedarg3)
				textButton3.Font = Enum.Font.GothamBold
				textButton3.TextSize = 11
				textButton3.TextColor3 = slicedtbl8.TEXT
				textButton3.ZIndex = 104
				createUICorner(textButton3, 6)
				createUIStroke(textButton3, slicedtbl8.AQUA_STROKE, 1, 0.55)
				textButton3.MouseButton1Click:Connect(function()
					local ok, result = pcall(slicedarg4)
					if ok and result ~= nil then textButton3.Text = tostring(result) end
				end)
				return frame4, textButton3
			end
			slicedfn23(frame3, "FOV", 588, math.floor(tonumber(slicedv2.FOV) or 80), function()
				if type(_G.StickyCycleFOV) == "function" then return math.floor(_G.StickyCycleFOV()) end
				return math.floor(tonumber(slicedv2.FOV) or 80)
			end)
			slicedfn22(frame3, "Brainrot Min M/s", 672, math.floor((tonumber(slicedv2.BrainrotESPMinGen) or 10000000) / 1000000), function(arg)
				local num = tonumber(arg.Text)
				if num then
					slicedv2.BrainrotESPMinGen = math.clamp(num, 0, 100000) * 1000000
					fn()
				end
				arg.Text = tostring(math.floor((tonumber(slicedv2.BrainrotESPMinGen) or 10000000) / 1000000))
			end)
			local slicedtbl9 = {}
			if mainPage then slicedtbl9.main = mainPage end
			slicedtbl9.settings = scrollingFrame2
			local targetControls = slicedv2.PanelSize and slicedv2.PanelSize.TargetControls
			local mainH = tonumber(targetControls and targetControls.MainH) or 338
			local settingsH = tonumber(targetControls and targetControls.SettingsH) or 380
			local str = "main"
			local function slicedfn24() return str == "settings" and settingsH or mainH end
			if targetControls and tonumber(targetControls.W) then targetControlsFrame.Size = UDim2.new(0, math.floor(tonumber(targetControls.W)), 0, 0) end
			local function slicedfn25(arg)
				str = arg
				for k, slicedv10 in pairs(slicedtbl9) do slicedv10.Visible = k == arg end
				if tabContent then tabContent.Size = UDim2.new(1, -16, 0, slicedfn24()) end
				if arg == "main" then
					textButton.BackgroundColor3 = slicedtbl8.GREEN1
					textButton.TextColor3 = Color3.fromRGB(232, 255, 240)
					textButton2.BackgroundColor3 = slicedtbl8.OFF_BG
					textButton2.TextColor3 = slicedtbl8.OFF_TEXT
				else
					textButton.BackgroundColor3 = slicedtbl8.OFF_BG
					textButton.TextColor3 = slicedtbl8.OFF_TEXT
					textButton2.BackgroundColor3 = slicedtbl8.GREEN1
					textButton2.TextColor3 = Color3.fromRGB(232, 255, 240)
				end
			end
			textButton.MouseButton1Click:Connect(function()
				slicedfn25("main")
			end)
			textButton2.MouseButton1Click:Connect(function()
				slicedfn25("settings")
			end)
			task.defer(function()
				task.wait()
				slicedfn25("main")
			end)
			local targetControlsFrame2 = tbl.TargetControlsFrame
			local autoStealFrame = tbl.AutoStealFrame
			if targetControlsFrame2 and autoStealFrame then
				local function slicedfn26()
					if not (targetControlsFrame2.Parent and autoStealFrame.Parent) then return end
					if tbl.AutoStealCustomSize then return end
					local slicedn3 = _G.YesIsPhone and 296 or 86 + mainH
					local slicedn4 = _G.YesIsPhone and 240 or 260
					if not (slicedn3 < slicedn4) then slicedn4 = slicedn3 end
					autoStealFrame.Size = UDim2.new(0, targetControlsFrame2.Size.X.Offset, 0, math.floor(slicedn4 + 0.5))
				end
				createTextButton(targetControlsFrame2, "TargetControls", { minW = 240, minH = 200, maxW = 640, maxH = 900 }, function()
					return targetControlsFrame2.Size.X.Offset, 86 + slicedfn24()
				end, function(arg, slicedarg2)
					local slicedn3 = math.max(110, slicedarg2 - 86)
					if str == "settings" then
						settingsH = slicedn3
					else
						mainH = slicedn3
					end
					targetControlsFrame2.Size = UDim2.new(0, arg, 0, 0)
					if tabContent then tabContent.Size = UDim2.new(1, -16, 0, slicedn3) end
					slicedv2.PanelSize = slicedv2.PanelSize or {}
					slicedv2.PanelSize.TargetControls = slicedv2.PanelSize.TargetControls or {}
					slicedv2.PanelSize.TargetControls.MainH = mainH
					slicedv2.PanelSize.TargetControls.SettingsH = settingsH
				end)
				local function slicedfn27()
					local currentCamera = workspace.CurrentCamera
					currentCamera = currentCamera and currentCamera.ViewportSize
					if not currentCamera or currentCamera.X < 1 or currentCamera.Y < 1 then return end
					local slicedtbl10 = { [autoStealFrame] = "AutoSteal", [targetControlsFrame2] = "TargetControls" }
					local slicedflag4 = false
					for _, slicedv10 in ipairs({ autoStealFrame, targetControlsFrame2 }) do
						if slicedv10.Parent then
							local absoluteSize = slicedv10.AbsoluteSize
							if absoluteSize.X > 1 and absoluteSize.Y > 1 then
								local position = slicedv10.Position
								local slicedn3 = position.X.Scale * currentCamera.X + position.X.Offset
								local slicedn4 = position.Y.Scale * currentCamera.Y + position.Y.Offset
								local slicedn5 = math.clamp(slicedn3, 6, math.max(6, currentCamera.X - absoluteSize.X - 6))
								local slicedn6 = math.clamp(slicedn4, 6, math.max(6, currentCamera.Y - absoluteSize.Y - 6))
								if math.abs(slicedn5 - slicedn3) > 1 or math.abs(slicedn6 - slicedn4) > 1 then
									local floor = math.floor
									slicedv10.Position = UDim2.fromOffset(math.floor(slicedn5), floor(slicedn6))
									local slicedv11 = slicedtbl10[slicedv10]
									if slicedv11 and slicedv2.Positions then
										slicedv2.Positions[slicedv11] = { X = 0, Y = 0, OffsetX = math.floor(slicedn5), OffsetY = math.floor(slicedn6) }
										slicedflag4 = true
									end
								end
							end
						end
					end
					if slicedflag4 and _G.StickySaveConfigNow then task.spawn(_G.StickySaveConfigNow) end
				end
				targetControlsFrame2:GetPropertyChangedSignal("AbsoluteSize"):Connect(slicedfn26)
				task.defer(slicedfn26)
				if _G.StickyOnBoot then
					_G.StickyOnBoot(function()
						slicedfn26()
						slicedfn27()
					end)
				else
					task.delay(1, slicedfn27)
				end
			end
		end
		do
			local slicedfn21 = nil
			slicedfn21 = function(arg, selectedPetData)
				slicedfn12()
				local function slicedfn22(slicedarg2, slicedarg3, slicedarg4)
					if not slicedarg4 then
					end
					if slicedarg3 then
						slicedarg2.button.BackgroundColor3 = slicedtbl8.GREEN1
						slicedarg2.knob.BackgroundTransparency = 0
						slicedarg2.stateLabel.Text = "ON"
						slicedarg2.stateLabel.TextColor3 = Color3.fromRGB(232, 255, 240)
						slicedarg2.stroke.Color = slicedtbl8.GREEN_STROKE
						slicedarg2.stroke.Transparency = 0.22
					else
						slicedarg2.button.BackgroundColor3 = slicedtbl8.OFF_BG
						slicedarg2.knob.BackgroundTransparency = 1
						slicedarg2.stateLabel.Text = "OFF"
						slicedarg2.stateLabel.TextColor3 = slicedtbl8.OFF_TEXT
						slicedarg2.stroke.Color = slicedtbl8.AQUA_STROKE
						slicedarg2.stroke.Transparency = 0.55
					end
					if slicedarg2.rowStroke then slicedarg2.rowStroke.Transparency = slicedarg3 and 0.38 or 0.52 end
					if slicedarg2.label then slicedarg2.label.TextColor3 = slicedarg3 and slicedtbl8.TEXT or slicedtbl8.TEXT end
				end
				slicedfn22(nearest, stealNearest, slicedtbl2.Accent1)
				slicedfn22(highest, stealHighest, slicedtbl2.Accent1)
				slicedfn22(priority, stealPriority, slicedtbl2.Accent2)
				if instantSteal2 then
					if instantSteal then
						instantSteal2.stateLabel.Text = "ON"
						instantSteal2.stateLabel.TextColor3 = Color3.fromRGB(232, 255, 240)
						instantSteal2.button.BackgroundColor3 = slicedtbl8.GREEN1
						instantSteal2.knob.BackgroundTransparency = 0
						instantSteal2.stroke.Color = slicedtbl8.GREEN_STROKE
						instantSteal2.stroke.Transparency = 0.22
					else
						instantSteal2.stateLabel.Text = "OFF"
						instantSteal2.stateLabel.TextColor3 = slicedtbl8.OFF_TEXT
						instantSteal2.button.BackgroundColor3 = slicedtbl8.OFF_BG
						instantSteal2.knob.BackgroundTransparency = 1
						instantSteal2.stroke.Color = slicedtbl8.AQUA_STROKE
						instantSteal2.stroke.Transparency = 0.55
					end
					if instantSteal2.rowStroke then instantSteal2.rowStroke.Transparency = instantSteal and 0.38 or 0.52 end
				end
				if uid and selectedPetData then
					for i, slicedv8 in ipairs(selectedPetData) do
						if slicedv8.uid == uid then
							n = i
							break
						end
					end
				end
				if tbl.ListNeedsRedraw then
					for _, child in ipairs(frame:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
					slicedtbl6 = {}
					if selectedPetData and #selectedPetData > 0 then
						for i = 1, #selectedPetData do
							local slicedv8 = selectedPetData[i]
							local textButton3 = Instance.new("TextButton")
							textButton3.Size = UDim2.new(1, 0, 0, 38)
							textButton3.BackgroundColor3 = slicedtbl7.SURF2
							textButton3.BorderSizePixel = 0
							textButton3.Text = ""
							textButton3.AutoButtonColor = false
							textButton3.Parent = frame
							textButton3.Position = UDim2.new(0, 0, 0, 0)
							textButton3.ClipsDescendants = true
							textButton3.ZIndex = 1
							Instance.new("UICorner", textButton3).CornerRadius = UDim.new(0, 8)
							local frame3 = Instance.new("Frame", textButton3)
							frame3.Name = "SelectedOverlay"
							frame3.Size = UDim2.new(1, 0, 1, 0)
							frame3.Position = UDim2.new(0, 0, 0, 0)
							frame3.BackgroundColor3 = Color3.fromRGB(10, 8, 12)
							frame3.BackgroundTransparency = 0.82
							frame3.BorderSizePixel = 0
							frame3.Visible = false
							frame3.ZIndex = 2
							Instance.new("UICorner", frame3).CornerRadius = UDim.new(0, 8)
							local uiGradient = Instance.new("UIGradient", frame3)
							uiGradient.Rotation = 90
							local colorSequence = ColorSequence.new
							local slicedtbl9 = {}
							local slicedv9 = ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0))
							local slicedv10 = ColorSequenceKeypoint.new(0.45, Color3.fromRGB(18, 22, 18))
							local new = ColorSequenceKeypoint.new
							local color = Color3.fromRGB
							slicedtbl9[1] = slicedv9
							slicedtbl9[2] = slicedv10
							do
								local values = table.pack(new(1, color(0, 0, 0)))
								table.move(values, 1, values.n, 3, slicedtbl9)
							end
							uiGradient.Color = colorSequence(slicedtbl9)
							local numberSequence = NumberSequence.new
							local slicedtbl10 = {}
							local slicedv11 = NumberSequenceKeypoint.new(0, 0.12)
							local slicedv12 = NumberSequenceKeypoint.new(0.18, 0.3)
							local slicedv13 = NumberSequenceKeypoint.new(0.55, 0.52)
							local new2 = NumberSequenceKeypoint.new
							slicedtbl10[1] = slicedv11
							slicedtbl10[2] = slicedv12
							slicedtbl10[3] = slicedv13
							do
								local values = table.pack(new2(1, 0.18))
								table.move(values, 1, values.n, 4, slicedtbl10)
							end
							uiGradient.Transparency = numberSequence(slicedtbl10)
							local frame4 = Instance.new("Frame", textButton3)
							frame4.Size = UDim2.fromOffset(24, 24)
							frame4.Position = UDim2.fromOffset(8, 7)
							frame4.BackgroundColor3 = slicedtbl7.SURF
							frame4.ZIndex = 3
							frame4.BorderSizePixel = 0
							Instance.new("UICorner", frame4).CornerRadius = UDim.new(0, 4)
							local uiStroke = Instance.new("UIStroke", frame4)
							uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
							uiStroke.Color = slicedtbl7.AQUA_STROKE
							uiStroke.Thickness = 1
							uiStroke.Transparency = 0.45
							local textLabel3 = Instance.new("TextLabel", frame4)
							textLabel3.Size = UDim2.new(1, 0, 1, 0)
							textLabel3.BackgroundTransparency = 1
							textLabel3.Text = "#" .. i
							textLabel3.Font = Enum.Font.GothamBold
							textLabel3.TextSize = 11
							textLabel3.TextColor3 = slicedtbl7.TEXT
							textLabel3.TextXAlignment = Enum.TextXAlignment.Center
							textLabel3.ZIndex = 4
							local petName = slicedv8 and slicedv8.petName or "Unknown"
							local mpsText = slicedv8 and slicedv8.mpsText or "$0/s"
							local textLabel4 = Instance.new("TextLabel", textButton3)
							textLabel4.Size = UDim2.new(1, -140, 0, 16)
							textLabel4.Position = UDim2.fromOffset(40, 2)
							textLabel4.BackgroundTransparency = 1
							textLabel4.RichText = false
							textLabel4.Text = petName
							textLabel4.Font = Enum.Font.GothamBold
							textLabel4.TextSize = 12
							textLabel4.TextColor3 = slicedtbl7.TEXT
							textLabel4.TextXAlignment = Enum.TextXAlignment.Left
							textLabel4.TextTruncate = Enum.TextTruncate.None
							textLabel4.ClipsDescendants = false
							textLabel4.ZIndex = 4
							local uiTextSizeConstraint = Instance.new("UITextSizeConstraint", textLabel4)
							uiTextSizeConstraint.MinTextSize = 8
							uiTextSizeConstraint.MaxTextSize = 12
							local textLabel5 = Instance.new("TextLabel", textButton3)
							textLabel5.Size = UDim2.new(0, 90, 0, 16)
							textLabel5.Position = UDim2.new(1, -98, 0, 2)
							textLabel5.BackgroundTransparency = 1
							textLabel5.RichText = false
							textLabel5.Text = mpsText
							textLabel5.Font = Enum.Font.GothamBold
							textLabel5.TextSize = 12
							textLabel5.TextColor3 = Color3.fromRGB(199, 120, 255)
							textLabel5.TextXAlignment = Enum.TextXAlignment.Right
							textLabel5.TextTruncate = Enum.TextTruncate.AtEnd
							textLabel5.ZIndex = 4
							local textLabel6 = Instance.new("TextLabel", textButton3)
							textLabel6.Size = UDim2.new(1, -140, 0, 16)
							textLabel6.Position = UDim2.fromOffset(40, 20)
							textLabel6.BackgroundTransparency = 1
							local slicedv14, slicedv15 = slicedfn16(slicedv8)
							textLabel6.RichText = slicedv15
							textLabel6.Text = slicedv14
							textLabel6.Font = Enum.Font.GothamBold
							textLabel6.TextSize = 12
							textLabel6.TextColor3 = slicedfn14(slicedv8.mutation)
							textLabel6.TextXAlignment = Enum.TextXAlignment.Left
							textLabel6.TextTruncate = Enum.TextTruncate.None
							textLabel6.ClipsDescendants = false
							textLabel6.ZIndex = 4
							local uiTextSizeConstraint2 = Instance.new("UITextSizeConstraint", textLabel6)
							uiTextSizeConstraint2.MinTextSize = 8
							uiTextSizeConstraint2.MaxTextSize = 12
							textLabel6.Visible = slicedv14 ~= ""
							slicedtbl6[i] = {
								button = textButton3,
								selectedOverlay = frame3,
								rankBox = frame4,
								rankBoxStroke = uiStroke,
								rank = textLabel3,
								info = textLabel4,
								rate = textLabel5,
								mutation = textLabel6,
								petData = slicedv8,
							}
							textButton3.MouseButton1Click:Connect(function()
								if uid2 == slicedv8.uid then
									uid2 = nil
									uid = nil
									_G.NEAREST_INSTANT_MODE = stealNearest and instantSteal
								else
									n = i
									uid = slicedv8.uid
									uid2 = slicedv8.uid
									flag = true
									_G.NEAREST_INSTANT_MODE = false
								end
								tbl.ListNeedsRedraw = true
								slicedfn21(flag, slicedfn18())
							end)
						end
					end
					tbl.ListNeedsRedraw = false
					local slicedn3 = #slicedtbl6
					local slicedn4 = 0
					if slicedn3 > 0 then slicedn4 = slicedn3 * 38 + (slicedn3 - 1) * 4 end
					frame.Size = UDim2.new(1, 0, 0, slicedn4)
					scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, slicedn4 + 8)
				end
				for _, slicedv8 in ipairs(slicedtbl6) do
					local visible = slicedv8.petData and uid2 and slicedv8.petData.uid == uid2
					slicedv8.button.ZIndex = 1
					slicedv8.button.BackgroundTransparency = 0
					slicedv8.button.BackgroundColor3 = visible and Color3.fromRGB(139, 40, 210) or slicedtbl7.SURF2
					if slicedv8.selectedOverlay then
						slicedv8.selectedOverlay.Visible = visible
						slicedv8.selectedOverlay.ZIndex = 2
						slicedv8.selectedOverlay.BackgroundColor3 = Color3.fromRGB(10, 8, 12)
						slicedv8.selectedOverlay.BackgroundTransparency = visible and 0.9 or 1
					end
					if slicedv8.rankBox then
						slicedv8.rankBox.BackgroundColor3 = visible and Color3.fromRGB(100, 30, 150) or slicedtbl7.SURF
						slicedv8.rankBox.ZIndex = 3
					end
					if slicedv8.rankBoxStroke then
						slicedv8.rankBoxStroke.Color = visible and Color3.fromRGB(100, 30, 150) or slicedtbl7.AQUA_STROKE
						slicedv8.rankBoxStroke.Thickness = 1
						slicedv8.rankBoxStroke.Transparency = visible and 1 or 0.45
					end
					if slicedv8.rank then
						slicedv8.rank.ZIndex = 4
						slicedv8.rank.TextColor3 = visible and Color3.fromRGB(240, 255, 240) or slicedtbl7.TEXT
					end
					if slicedv8.info then
						slicedv8.info.ZIndex = 4
						slicedv8.info.RichText = false
						if slicedv8.petData then slicedv8.info.Text = slicedfn15(slicedv8.petData) end
						slicedv8.info.TextColor3 = visible and Color3.fromRGB(0, 0, 0) or slicedtbl7.TEXT
					end
					if slicedv8.mutation then
						slicedv8.mutation.ZIndex = 4
						if slicedv8.petData then
							local slicedv9, slicedv10 = slicedfn16(slicedv8.petData)
							slicedv8.mutation.RichText = slicedv10
							slicedv8.mutation.Text = slicedv9
							slicedv8.mutation.Visible = slicedv9 ~= ""
						end
						local mutation = slicedv8.mutation
						local color = visible and Color3.fromRGB(0, 0, 0)
						if not color then color = slicedfn14(slicedv8.petData and slicedv8.petData.mutation) end
						mutation.TextColor3 = color
					end
					if slicedv8.rate then
						slicedv8.rate.ZIndex = 4
						if slicedv8.petData and slicedv8.petData.mpsText then slicedv8.rate.Text = slicedv8.petData.mpsText end
						slicedv8.rate.TextColor3 = visible and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(199, 120, 255)
					end
				end
				selectedPetData = selectedPetData and selectedPetData[n]
				tbl.SelectedPetData = selectedPetData
				if arg then
					if not stealNearest then
						if selectedPetData then
							textLabel.Text = string.format("%s - %s", selectedPetData.petName or "Unknown", selectedPetData.mpsText or "")
						else
							textLabel.Text = "Searching..."
						end
					end
				else
					textLabel.Text = "Disabled"
					if tween then
						tween:Cancel()
						tween = nil
					end
					slicedv7.Size = UDim2.new(0, 0, 1, 0)
				end
				textLabel2.Text = string.format("%d%%", math.clamp(math.floor(slicedv7.Size.X.Scale * 100 + 0.5), 0, 100))
				frame.Size = UDim2.new(1, 0, 0, math.max(0, uiListLayout.AbsoluteContentSize.Y))
				scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(0, uiListLayout.AbsoluteContentSize.Y) + 8)
			end
			uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				frame.Size = UDim2.new(1, 0, 0, math.max(0, uiListLayout.AbsoluteContentSize.Y))
				scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(0, uiListLayout.AbsoluteContentSize.Y) + 8)
			end)
			tbl.UpdateAutoStealUI = function() slicedfn21(flag, slicedfn18()) end
			task.spawn(function()
				while frame2 and frame2.Parent do
					local slicedn3 = math.clamp(math.floor(slicedv7.Size.X.Scale * 100 + 0.5), 0, 100)
					textLabel2.Text = tostring(slicedn3) .. "%"
					task.wait(0.05)
				end
			end)
			nearest.button.MouseButton1Click:Connect(function()
				stealNearest = not stealNearest
				if stealNearest then
					stealHighest = false
					stealPriority = false
					uid2 = nil
				end
				slicedv2.StealNearest = stealNearest
				slicedv2.StealHighest = stealHighest
				slicedv2.StealPriority = stealPriority
				slicedfn12()
				_G.NEAREST_INSTANT_MODE = stealNearest and instantSteal
				fn()
				tbl.ListNeedsRedraw = false
				slicedfn21(flag, slicedfn18())
			end)
			highest.button.MouseButton1Click:Connect(function()
				stealHighest = not stealHighest
				if stealHighest then
					stealNearest = false
					stealPriority = false
					uid2 = nil
				end
				slicedv2.StealNearest = stealNearest
				slicedv2.StealHighest = stealHighest
				slicedv2.StealPriority = stealPriority
				slicedfn12()
				_G.NEAREST_INSTANT_MODE = stealNearest and instantSteal
				fn()
				tbl.ListNeedsRedraw = false
				slicedfn21(flag, slicedfn18())
			end)
			priority.button.MouseButton1Click:Connect(function()
				stealPriority = not stealPriority
				if stealPriority then
					stealNearest = false
					stealHighest = false
					uid2 = nil
				end
				slicedv2.StealNearest = stealNearest
				slicedv2.StealHighest = stealHighest
				slicedv2.StealPriority = stealPriority
				slicedfn12()
				_G.NEAREST_INSTANT_MODE = stealNearest and instantSteal
				fn()
				tbl.ListNeedsRedraw = false
				slicedfn21(flag, slicedfn18())
			end)
			instantSteal2.button.MouseButton1Click:Connect(function()
				instantSteal = not instantSteal
				if instantSteal then
					slicedflag2 = false
					slicedflag3 = false
				else
					slicedflag2 = false
					slicedflag3 = false
				end
				slicedv2.InstantSteal = instantSteal
				_G.NEAREST_INSTANT_MODE = stealNearest and instantSteal
				fn()
				tbl.ListNeedsRedraw = false
				slicedfn21(flag, slicedfn18())
			end)
			task.spawn(function()
				while true do
					task.wait(1.5)
					if instantSteal then
						instantSteal = false
						slicedflag2 = false
						slicedflag3 = false
						slicedv2.InstantSteal = false
						_G.NEAREST_INSTANT_MODE = false
						task.wait(0.05)
						instantSteal = true
						slicedv2.InstantSteal = true
						_G.NEAREST_INSTANT_MODE = stealNearest and true
					end
				end
			end)
			local function slicedfn22(arg)
				if not arg then return nil end
				local slicedv8 = slicedtbl5[arg.uid]
				if slicedv8 and slicedv8.Parent then return slicedv8 end
				local slicedv9 = workspace_.Plots:FindFirstChild(arg.plot)
				if not slicedv9 then return nil end
				local animalPodiums = slicedv9:FindFirstChild("AnimalPodiums")
				if not animalPodiums then return nil end
				local animalList = slicedfn9(slicedv9.Name)
				animalList = animalList and animalList.AnimalList
				if not animalList then
					local slicedv10 = animalPodiums:FindFirstChild(arg.slot)
					if slicedv10 then
						local base = slicedv10:FindFirstChild("Base")
						local spawn = base and base:FindFirstChild("Spawn")
						if spawn then
							local promptAttachment = spawn:FindFirstChild("PromptAttachment")
							if promptAttachment then
								for _, child in ipairs(promptAttachment:GetChildren()) do
									if child:IsA("ProximityPrompt") then
										slicedtbl5[arg.uid] = child
										return child
									end
								end
							end
						end
					end
					return nil
				end
				local str = arg.name and arg.name:lower() or ""
				local slot = arg.slot
				local slicedv10 = nil
				for k, slicedv11 in pairs(animalList) do
					if type(slicedv11) == "table" and tostring(k) == slot then
						local index = slicedv11.Index
						local slicedflag4 = Animals[slicedv11.Index]
						if slicedflag4 then slicedflag4 = (slicedflag4.DisplayName or index):lower() == str end
						if slicedflag4 then
							slicedv10 = animalPodiums:FindFirstChild(tostring(k))
							break
						else
							slicedv10 = nil
						end
					else
						slicedv10 = nil
					end
				end
				slicedv10 = slicedv10 or animalPodiums:FindFirstChild(arg.slot)
				if slicedv10 then
					local base = slicedv10:FindFirstChild("Base")
					base = base and base:FindFirstChild("Spawn")
					if base then
						local promptAttachment = base:FindFirstChild("PromptAttachment")
						if promptAttachment then
							for _, child in ipairs(promptAttachment:GetChildren()) do
								if child:IsA("ProximityPrompt") and child.Enabled and child.ActionText == "Steal" then
									slicedtbl5[arg.uid] = child
									return child
								end
							end
						end
						local position = base.Position
						local x = position.X
						local z = position.Z
						local huge = math.huge
						local slicedv11 = nil
						for _, descendant in pairs(slicedv9:GetDescendants()) do
							if descendant:IsA("ProximityPrompt") and descendant.Enabled and descendant.ActionText == "Steal" then
								local parent = descendant.Parent
								local position2
								if parent and parent:IsA("BasePart") then
									position2 = parent.Position
								else
									local isBasePart = parent and parent:IsA("Attachment") and parent.Parent and parent.Parent:IsA("BasePart")
									position2 = nil
									if isBasePart then position2 = parent.Parent.Position end
								end
								if position2 then
									local y = position.Y
									if str:find("la secret combinasion") then y = position.Y - 5 end
									if math.sqrt((position2.X - x) ^ 2 + (position2.Z - z) ^ 2) < 5 and position2.Y > y then
										local slicedn3 = position2.Y - y
										if slicedn3 < huge then
											huge = slicedn3
											slicedv11 = descendant
										end
									end
								end
							end
						end
						if slicedv11 then
							slicedtbl5[arg.uid] = slicedv11
							return slicedv11
						end
					end
				end
				return nil
			end
			local function slicedfn23(arg)
				if slicedtbl4[arg] then return end
				local slicedtbl9 = { holdCallbacks = {}, triggerCallbacks = {}, holdEndCallbacks = {}, ready = true }
				local ok, result = pcall(getconnections, arg.PromptButtonHoldBegan)
				if ok and type(result) == "table" then
					for _, slicedv8 in ipairs(result) do if type(slicedv8.Function) == "function" then table.insert(slicedtbl9.holdCallbacks, slicedv8.Function) end end
				end
				local ok2, result2 = pcall(getconnections, arg.Triggered)
				if ok2 and type(result2) == "table" then
					for _, slicedv8 in ipairs(result2) do if type(slicedv8.Function) == "function" then table.insert(slicedtbl9.triggerCallbacks, slicedv8.Function) end end
				end
				local ok3, result3 = pcall(getconnections, arg.PromptButtonHoldEnded)
				if ok3 and type(result3) == "table" then
					for _, slicedv8 in ipairs(result3) do if type(slicedv8.Function) == "function" then table.insert(slicedtbl9.holdEndCallbacks, slicedv8.Function) end end
				end
				if #slicedtbl9.holdCallbacks > 0 or #slicedtbl9.triggerCallbacks > 0 or #slicedtbl9.holdEndCallbacks > 0 then slicedtbl4[arg] = slicedtbl9 end
			end
			local function slicedfn24(arg) for _, slicedv8 in ipairs(arg) do task.spawn(slicedv8) end end
			local function slicedfn25(arg)
				local slicedv8 = slicedfn9(arg)
				if slicedv8 then return slicedfn8(slicedv8.Owner) end
				return false
			end
			local function slicedfn26()
				local humanoidRootPart = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart then return nil, math.huge, nil end
				local plots = workspace:FindFirstChild("Plots")
				if not plots then return nil, math.huge, nil end
				local huge = math.huge
				local slicedv8 = nil
				local name = nil
				for _, child in ipairs(plots:GetChildren()) do
					if not slicedfn25(child.Name) then
						local huge2 = math.huge
						pcall(function()
							local position = humanoidRootPart.Position
							huge2 = (child:GetPivot().Position - position).Magnitude
						end)
						if huge2 > 100 then
						else
							local animalPodiums = child:FindFirstChild("AnimalPodiums")
							if not animalPodiums then
							else
								for _, child2 in ipairs(animalPodiums:GetChildren()) do
									local base = child2:FindFirstChild("Base")
									base = base and base:FindFirstChild("Spawn")
									if base then
										local magnitude = (base.Position - humanoidRootPart.Position).Magnitude
										if not (magnitude > 60 or magnitude >= huge) then
											local promptAttachment = base:FindFirstChild("PromptAttachment")
											if promptAttachment then
												local proximityPrompt = promptAttachment:FindFirstChildOfClass("ProximityPrompt")
												if proximityPrompt and proximityPrompt.Parent and proximityPrompt.Enabled then
													name = child2.Name
													huge = magnitude
													slicedv8 = proximityPrompt
												end
											end
										end
									end
								end
							end
						end
					end
				end
				return slicedv8, huge, name
			end
			local function slicedfn27(arg, slicedarg2)
				local slicedv8 = slicedtbl4[arg]
				if not slicedv8 or not slicedv8.ready then return false end
				slicedv8.ready = false
				task.spawn(function()
					if slicedv6 ~= slicedarg2 then
						if tween then tween:Cancel() end
						slicedv7.Size = UDim2.new(0, 0, 1, 0)
						slicedv6 = slicedarg2
					end
					if #slicedv8.holdCallbacks > 0 then slicedfn24(slicedv8.holdCallbacks) end
					slicedv7.Size = UDim2.new(0, 0, 1, 0)
					slicedv7.BackgroundTransparency = 0
					tween = tweenService:Create(slicedv7, TweenInfo.new(1.2, Enum.EasingStyle.Linear), { Size = UDim2.new(1, 0, 1, 0) })
					tween:Play()
					tween.Completed:Wait()
					if slicedv6 == slicedarg2 and #slicedv8.triggerCallbacks > 0 then slicedfn24(slicedv8.triggerCallbacks) end
					slicedv8.ready = true
				end)
				return true
			end
			local function slicedfn28(arg, slicedarg2)
				if not arg or not arg.Parent then return false end
				slicedfn23(arg)
				if not slicedtbl4[arg] then return false end
				if slicedv6 ~= slicedarg2 then
					if tween then
						tween:Cancel()
						tween = nil
					end
					slicedv7.Size = UDim2.new(0, 0, 1, 0)
				end
				return slicedfn27(arg, slicedarg2)
			end
			local function slicedfn29() for _, slicedv8 in pairs(slicedtbl5) do if slicedv8 and slicedv8.Parent then slicedfn23(slicedv8) end end end
			task.spawn(function()
				while task.wait(2) do if flag then slicedfn29() end end
			end)
			local slicedtbl9 = {}
			local function slicedfn30(arg)
				if not arg then return "" end
				local str = ""
				for k, slicedv8 in pairs(arg) do if type(slicedv8) == "table" then str ..= tostring(k) .. tostring(slicedv8.Index) .. tostring(slicedv8.Mutation) end end
				return str
			end
			local function slicedfn31(arg)
				local slicedflag4 = false
				pcall(function()
					local slicedv8 = slicedfn9(arg.Name)
					if not slicedv8 then return end
					local animalList = slicedv8.AnimalList
					local owner = slicedv8.Owner
					if not owner or slicedfn8(owner) or typeof(owner) == "Instance" and not players:FindFirstChild(owner.Name) or type(owner) == "string" and not players:FindFirstChild(owner) then
						slicedtbl9[arg.Name] = nil
						for i = #allAnimalsCache, 1, -1 do
							if allAnimalsCache[i].plot == arg.Name then
								table.remove(allAnimalsCache, i)
								slicedflag4 = true
							end
						end
						return
					end
					if not animalList then
						slicedtbl9[arg.Name] = nil
						for i = #allAnimalsCache, 1, -1 do
							if allAnimalsCache[i].plot == arg.Name then
								table.remove(allAnimalsCache, i)
								slicedflag4 = true
							end
						end
						return
					end
					local name = typeof(owner) == "Instance" and owner.Name or tostring(owner)
					local slicedv9 = slicedfn30(animalList, name)
					if slicedtbl9[arg.Name] == slicedv9 then return end
					for i = #allAnimalsCache, 1, -1 do if allAnimalsCache[i].plot == arg.Name then table.remove(allAnimalsCache, i) end end
					for k, slicedv10 in pairs(animalList) do
						if type(slicedv10) == "table" then
							local index = slicedv10.Index
							local slicedv11 = Animals[slicedv10.Index]
							if slicedv11 then
								local mutation = slicedv10.Mutation or "None"
								if mutation == "Yin Yang" then mutation = "YinYang" end
								local str = slicedv10.Traits and #slicedv10.Traits > 0 and table.concat(slicedv10.Traits, ", ") or "None"
								local slicedv12 = slicedfn11(index, slicedv10.Mutation, slicedv10.Traits)
								table.insert(allAnimalsCache, {
									name = slicedv11.DisplayName or index,
									genText = "$" .. slicedfn10(slicedv12) .. "/s",
									genValue = slicedv12,
									mutation = mutation,
									traits = str,
									owner = name,
									plot = arg.Name,
									slot = tostring(k),
									uid = arg.Name .. "_" .. tostring(k),
								})
							end
						end
					end
					slicedtbl9[arg.Name] = slicedv9
					slicedflag4 = true
				end)
				if slicedflag4 then
					table.sort(allAnimalsCache, function(slicedarg2, slicedarg3)
						return slicedarg2.genValue > slicedarg3.genValue
					end)
					tbl.AllAnimalsCache = allAnimalsCache
					tbl.ListNeedsRedraw = true
					if tbl.UpdateAutoStealUI then tbl.UpdateAutoStealUI() end
				end
			end
			local function slicedfn32(arg)
				local slicedv8 = nil
				local slicedn3 = 0
				while not slicedv8 and slicedn3 < 40 do
					slicedv8 = slicedfn9(arg.Name)
					if not slicedv8 then
						slicedn3 += 1
						task.wait(0.07)
					end
				end
				if not slicedv8 then return end
				slicedfn31(arg)
				local function slicedfn33(slicedarg2)
					if not slicedarg2 then return end
					slicedarg2.ChildAdded:Connect(function()
						task.wait(0.15)
						slicedfn31(arg)
					end)
					slicedarg2.ChildRemoved:Connect(function()
						for i = #allAnimalsCache, 1, -1 do if allAnimalsCache[i].plot == arg.Name then table.remove(allAnimalsCache, i) end end
						slicedtbl9[arg.Name] = nil
						_getPetsCache = nil
						for k in pairs(slicedtbl5) do
							local name = arg.Name
							if k:sub(1, #arg.Name) == name then slicedtbl5[k] = nil end
						end
						tbl.ListNeedsRedraw = true
						if tbl.UpdateAutoStealUI then tbl.UpdateAutoStealUI() end
						task.wait(0.15)
						slicedfn31(arg)
					end)
				end
				local animalPodiums = arg:FindFirstChild("AnimalPodiums")
				slicedfn33(animalPodiums)
				arg.ChildAdded:Connect(function(child)
					if child.Name == "AnimalPodiums" then
						slicedfn33(child)
						slicedfn31(arg)
					end
				end)
				arg.ChildRemoved:Connect(function(child)
					if child.Name == "AnimalPodiums" then
						for i = #allAnimalsCache, 1, -1 do if allAnimalsCache[i].plot == arg.Name then table.remove(allAnimalsCache, i) end end
						slicedtbl9[arg.Name] = nil
						_getPetsCache = nil
						tbl.ListNeedsRedraw = true
						if tbl.UpdateAutoStealUI then tbl.UpdateAutoStealUI() end
					end
				end)
				task.spawn(function()
					while arg.Parent do
						task.wait(10)
						slicedfn31(arg)
					end
				end)
			end
			local plots = workspace_:WaitForChild("Plots", 8)
			if plots then
				for _, child in ipairs(plots:GetChildren()) do slicedfn32(child) end
				plots.ChildAdded:Connect(function(child)
					task.wait(0.5)
					slicedfn32(child)
				end)
				plots.ChildRemoved:Connect(function(child)
					slicedtbl9[child.Name] = nil
					_getPetsCache = nil
					for i = #allAnimalsCache, 1, -1 do if allAnimalsCache[i].plot == child.Name then table.remove(allAnimalsCache, i) end end
					for k in pairs(slicedtbl5) do
						local name = child.Name
						if k:sub(1, #child.Name) == name then slicedtbl5[k] = nil end
					end
					tbl.ListNeedsRedraw = true
					if tbl.UpdateAutoStealUI then tbl.UpdateAutoStealUI() end
				end)
			end
			local function slicedfn33(arg)
				if #arg == 0 then return end
				if uid2 then
					for i, slicedv8 in ipairs(arg) do
						if slicedv8.uid == uid2 then
							if n ~= i then
								n = i
								uid = slicedv8.uid
							end
							textLabel.Text = string.format("%s - %s", slicedv8.petName or "Unknown", slicedv8.mpsText or "")
							return
						end
					end
					uid2 = nil
				end
				if stealPriority then
					for _, slicedv8 in ipairs(slicedtbl3) do
						local str = slicedv8:lower()
						for i, slicedv9 in ipairs(arg) do
							if slicedv9.petName and slicedv9.petName:lower() == str then
								if n ~= i then
									n = i
									uid = slicedv9.uid
								end
								return
							end
						end
					end
					if n ~= 1 then
						n = 1
						uid = arg[1] and arg[1].uid
					end
				elseif stealNearest then
					local character = localPlayer2.Character
					character = character and character:FindFirstChild("HumanoidRootPart")
					if character then
						local slicedv8, slicedv9, slicedv10 = ipairs(arg)
						local huge = math.huge
						local slicedn3 = 1
						for k, slicedv11 in slicedv8, slicedv9, slicedv10 do
							local animalData = slicedv11.animalData and stickyFindAdornee(slicedv11.animalData)
							if animalData and animalData:IsA("BasePart") then
								local magnitude = (character.Position - animalData.Position).Magnitude
								if magnitude < huge then
									huge = magnitude
									slicedn3 = k
								end
							end
						end
						if arg[slicedn3] then
							local slicedv11 = arg[slicedn3]
							textLabel.Text = string.format("%s - %s", slicedv11.petName or "Unknown", slicedv11.mpsText or "")
						end
						if not instantSteal and n ~= slicedn3 then
							n = slicedn3
							uid = arg[slicedn3] and arg[slicedn3].uid
						end
					end
				elseif stealHighest then
					if n ~= 1 then
						n = 1
						uid = arg[1] and arg[1].uid
					end
				end
			end
			runService.Heartbeat:Connect(function()
				if not flag then return end
				slicedfn33(slicedfn18())
			end)
			task.spawn(function()
				while true do
					task.wait(0.5)
					if flag then
						local slicedv8 = slicedfn18()
						if not (#slicedv8 > 0) then continue end
						tbl.ListNeedsRedraw = false
						slicedfn21(flag, slicedv8)
					end
				end
			end)
			runService.Heartbeat:Connect(function()
				if not flag then return end
				if instantSteal then
					if tween then
						tween:Cancel()
						tween = nil
					end
					slicedv7.Size = UDim2.new(1, 0, 1, 0)
					slicedv7.BackgroundTransparency = 0
					if not slicedflag3 then
						slicedflag3 = true
						task.spawn(function()
							if not game:IsLoaded() then game.Loaded:Wait() end
							task.wait(0.5)
							slicedflag2 = true
						end)
					end
					if slicedflag2 then
						if stealNearest and not uid2 then
							local slicedv8, slicedv9 = slicedfn26()
							if slicedv8 then
							end
						else
							local slicedv8 = slicedfn18()
							if #slicedv8 > 0 then
								if #slicedv8 < n then n = #slicedv8 end
								if n < 1 then n = 1 end
								local slicedv9 = slicedv8[n]
								if slicedv9 and not slicedfn13(slicedv9.animalData) then
									local slicedv10 = slicedtbl5[slicedv9.uid]
									if not slicedv10 or not slicedv10.Parent then slicedfn22(slicedv9.animalData) end
								end
							end
						end
					end
					return
				end
				local slicedv8 = slicedfn18()
				if #slicedv8 == 0 then return end
				if n > #slicedv8 then n = #slicedv8 end
				if n < 1 then n = 1 end
				local slicedv9 = slicedv8[n]
				if not slicedv9 or slicedfn13(slicedv9.animalData) then return end
				local slicedv10 = slicedtbl5[slicedv9.uid]
				if not slicedv10 or not slicedv10.Parent then slicedv10 = slicedfn22(slicedv9.animalData) end
				if slicedv10 then slicedfn28(slicedv10, slicedv9.uid) end
			end)
			task.spawn(function()
				while task.wait(0.5) do slicedfn21(flag, slicedfn18()) end
			end)
			task.spawn(function()
				task.wait(1)
				tbl.ListNeedsRedraw = true
				slicedfn21(flag, slicedfn18())
			end)
		end
		task.spawn(function()
			while true do
				tbl.AllAnimalsCache = allAnimalsCache
				task.wait(0.5)
			end
		end)
	end)
end

local UserInputService, color, color2, color3, color4, color5, color6, color7, color8, color9
local color10, color11, color12, str, slicedfn4, slicedfn5, slicedv6, visible, visible2, revealed
local slicedfn6, frame, textLabel, textLabel2, textButton, textButton2

do
	local Players2 = game:GetService("Players")
	UserInputService = game:GetService("UserInputService")
	local HttpService = game:GetService("HttpService")
	local localPlayer3 = Players2.LocalPlayer
	local jobIdGui = localPlayer3:FindFirstChild("JobIdGui")
	if jobIdGui then jobIdGui:Destroy() end
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "JobIdGui"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = localPlayer3:WaitForChild("PlayerGui")
	color = Color3.fromRGB(46, 204, 113)
	color2 = Color3.fromRGB(245, 255, 250)
	local color13 = Color3.fromRGB(31, 10, 46)
	local color14 = Color3.fromRGB(157, 70, 220)
	local color15 = Color3.fromRGB(125, 55, 175)
	color3 = Color3.fromRGB(42, 15, 62)
	color4 = Color3.fromRGB(211, 150, 255)
	color5 = Color3.fromRGB(117, 30, 180)
	color6 = Color3.fromRGB(220, 240, 255)
	color7 = Color3.fromRGB(46, 204, 113)
	color8 = Color3.fromRGB(245, 255, 250)
	color9 = Color3.fromRGB(255, 255, 255)
	color10 = Color3.fromRGB(73, 35, 100)
	color11 = Color3.fromRGB(200, 220, 245)
	color12 = Color3.fromRGB(255, 255, 255)
	local color16 = Color3.fromRGB(245, 250, 255)
	str = string.rep(". ", 30)

	slicedfn4 = function(arg)
		arg.AutoButtonColor = false
		arg.Selectable = false
		arg.SelectionImageObject = nil
		arg.TextStrokeTransparency = 1
		arg.Active = false
	end
	local flag = type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
	if flag and type(makefolder) == "function" and type(isfolder) == "function" then if not isfolder("JobIdGui") then pcall(makefolder, "JobIdGui") end end

	local function slicedfn7()
		if not flag then return {} end
		if not isfile("JobIdGui/config.json") then return {} end
		local ok, result = pcall(function()
			return HttpService:JSONDecode(readfile("JobIdGui/config.json"))
		end)
		if ok and type(result) == "table" then return result end
		return {}
	end

	slicedfn5 = function(arg)
		if not flag then return end
		pcall(function()
			writefile("JobIdGui/config.json", HttpService:JSONEncode(arg))
		end)
	end
	slicedv6 = slicedfn7()
	visible = slicedv6.namesVisible ~= false
	visible2 = slicedv6.numbersVisible == true
	revealed = slicedv6.revealed ~= false
	local slicedtbl2 = {}

	local function slicedfn8(arg, slicedarg2)
		local character = arg.Character
		if not character then return end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then humanoid.DisplayDistanceType = slicedarg2 and Enum.HumanoidDisplayDistanceType.Viewer or Enum.HumanoidDisplayDistanceType.None end
	end

	local function slicedfn9(arg)
		if slicedtbl2[arg] then
			slicedtbl2[arg]:Destroy()
			slicedtbl2[arg] = nil
		end
		local character = arg.Character
		if not character then return end
		local head = character:FindFirstChild("Head")
		if not head then return end
		slicedfn8(arg, visible)
		local billboardGui = Instance.new("BillboardGui")
		billboardGui.Name = "JobIdTag"
		billboardGui.Size = UDim2.new(0, 140, 0, 44)
		billboardGui.StudsOffset = Vector3.new(0, 2.4, 0)
		billboardGui.AlwaysOnTop = true
		billboardGui.Adornee = head
		billboardGui.Parent = head
		local textLabel3 = Instance.new("TextLabel")
		textLabel3.Name = "NameLabel"
		textLabel3.Size = UDim2.new(1, 0, 0, 20)
		textLabel3.BackgroundTransparency = 1
		textLabel3.Text = arg.DisplayName
		textLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel3.TextStrokeTransparency = 0.3
		textLabel3.TextScaled = true
		textLabel3.Font = Enum.Font.GothamBold
		textLabel3.Visible = visible
		textLabel3.Parent = billboardGui
		local textLabel4 = Instance.new("TextLabel")
		textLabel4.Name = "NumLabel"
		textLabel4.Size = UDim2.new(1, 0, 0, 18)
		textLabel4.Position = UDim2.new(0, 0, 0, 21)
		textLabel4.BackgroundTransparency = 1
		textLabel4.Text = "#" .. tostring(arg.UserId)
		textLabel4.TextColor3 = color
		textLabel4.TextStrokeTransparency = 0.3
		textLabel4.TextScaled = true
		textLabel4.Font = Enum.Font.GothamBlack
		textLabel4.Visible = visible2
		textLabel4.Parent = billboardGui
		slicedtbl2[arg] = billboardGui
	end

	slicedfn6 = function()
		for k, slicedv7 in pairs(slicedtbl2) do
			if slicedv7 and slicedv7.Parent then
				local nameLabel = slicedv7:FindFirstChild("NameLabel")
				local numLabel = slicedv7:FindFirstChild("NumLabel")
				if nameLabel then nameLabel.Visible = visible end
				if numLabel then numLabel.Visible = visible2 end
			end
			slicedfn8(k, visible)
		end
		slicedfn8(localPlayer3, visible)
	end

	local function slicedfn10(player)
		if player == localPlayer3 then return end
		player.CharacterAdded:Connect(function()
			task.wait(0.5)
			slicedfn9(player)
		end)
		if player.Character then slicedfn9(player) end
	end
	for _, player in ipairs(Players2:GetPlayers()) do slicedfn10(player) end
	Players2.PlayerAdded:Connect(slicedfn10)
	Players2.PlayerRemoving:Connect(function(player)
		if slicedtbl2[player] then
			slicedtbl2[player]:Destroy()
			slicedtbl2[player] = nil
		end
	end)
	frame = Instance.new("Frame")
	frame.Name = "MainPanel"
	frame.Size = UDim2.new(0, 240, 0, 104)
	frame.Position = UDim2.new(0, 650, 0, 10)
	frame.BackgroundColor3 = color13
	frame.BorderSizePixel = 0
	frame.Active = true
	frame.ZIndex = 10
	frame.Parent = screenGui
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 10)
	uiCorner.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = color14
	uiStroke.Thickness = 1.3
	uiStroke.Transparency = 0.1
	uiStroke.Parent = frame
	textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 0, 14)
	textLabel.Position = UDim2.new(0, 0, 0, 4)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "SERVER JOB ID"
	textLabel.TextColor3 = color16
	textLabel.TextScaled = true
	textLabel.Font = Enum.Font.GothamBlack
	textLabel.TextStrokeTransparency = 1
	textLabel.ZIndex = 11
	textLabel.Parent = frame
	local frame2 = Instance.new("Frame")
	frame2.Size = UDim2.new(0.42, 0, 0, 1)
	frame2.Position = UDim2.new(0.29, 0, 0, 20)
	frame2.BackgroundColor3 = Color3.fromRGB(212, 160, 250)
	frame2.BorderSizePixel = 0
	frame2.ZIndex = 11
	frame2.Parent = frame
	local frame3 = Instance.new("Frame")
	frame3.Size = UDim2.new(0.92, 0, 0, 44)
	frame3.Position = UDim2.new(0.04, 0, 0, 26)
	frame3.BackgroundColor3 = Color3.fromRGB(35, 12, 52)
	frame3.BackgroundTransparency = 0.35
	frame3.BorderSizePixel = 0
	frame3.ZIndex = 11
	frame3.Parent = frame
	local uiCorner2 = Instance.new("UICorner")
	uiCorner2.CornerRadius = UDim.new(0, 8)
	uiCorner2.Parent = frame3
	local uiStroke2 = Instance.new("UIStroke")
	uiStroke2.Color = color15
	uiStroke2.Thickness = 1
	uiStroke2.Transparency = 0.15
	uiStroke2.Parent = frame3
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingTop = UDim.new(0, 4)
	uiPadding.PaddingBottom = UDim.new(0, 4)
	uiPadding.PaddingLeft = UDim.new(0, 4)
	uiPadding.PaddingRight = UDim.new(0, 4)
	uiPadding.Parent = frame3
	textLabel2 = Instance.new("TextLabel")
	textLabel2.Size = UDim2.new(1, 0, 0, 15)
	textLabel2.Position = UDim2.new(0, 0, 0, 0)
	textLabel2.BackgroundColor3 = color3
	textLabel2.TextColor3 = color4
	textLabel2.Text = game.JobId ~= "" and game.JobId or str
	textLabel2.TextScaled = true
	textLabel2.Font = Enum.Font.Code
	textLabel2.TextStrokeTransparency = 1
	textLabel2.ZIndex = 12
	textLabel2.Parent = frame3
	local uiCorner3 = Instance.new("UICorner")
	uiCorner3.CornerRadius = UDim.new(0, 4)
	uiCorner3.Parent = textLabel2
	textButton = Instance.new("TextButton")
	textButton.Size = UDim2.new(0.48, 0, 0, 17)
	textButton.Position = UDim2.new(0, 0, 0, 19)
	textButton.BackgroundColor3 = color5
	textButton.TextColor3 = color6
	textButton.Text = "COPY"
	textButton.TextSize = 10
	textButton.TextScaled = false
	textButton.Font = Enum.Font.GothamBlack
	textButton.ZIndex = 12
	textButton.Parent = frame3
	slicedfn4(textButton)
	local uiCorner4 = Instance.new("UICorner")
	uiCorner4.CornerRadius = UDim.new(0, 4)
	uiCorner4.Parent = textButton
	textButton2 = Instance.new("TextButton")
	textButton2.Size = UDim2.new(0.48, 0, 0, 17)
	textButton2.Position = UDim2.new(0.52, 0, 0, 19)
	textButton2.BackgroundColor3 = color
	textButton2.TextColor3 = color2
	textButton2.Text = "SHOW"
	textButton2.TextSize = 10
	textButton2.TextScaled = false
	textButton2.Font = Enum.Font.GothamBlack
	textButton2.ZIndex = 12
	textButton2.Parent = frame3
end

slicedfn4(textButton2)
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 4)
uiCorner.Parent = textButton2

do
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = UDim2.new(0, 10, 0, 10)
	imageLabel.Position = UDim2.new(0, 4, 0.5, -5)
	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = "rbxassetid://3926305904"
	imageLabel.ImageRectOffset = Vector2.new(724, 364)
	imageLabel.ImageRectSize = Vector2.new(36, 36)
	imageLabel.ImageColor3 = color2
	imageLabel.ZIndex = 13
	imageLabel.Parent = textButton2
	local textButton3 = Instance.new("TextButton")
	textButton3.Size = UDim2.new(0.45, 0, 0, 13)
	textButton3.Position = UDim2.new(0.04, 0, 0, 78)
	textButton3.TextSize = 9
	textButton3.TextScaled = false
	textButton3.Font = Enum.Font.GothamBlack
	textButton3.TextXAlignment = Enum.TextXAlignment.Center
	textButton3.ZIndex = 12
	textButton3.Parent = frame
	slicedfn4(textButton3)
	local uiCorner2 = Instance.new("UICorner")
	uiCorner2.CornerRadius = UDim.new(1, 0)
	uiCorner2.Parent = textButton3
	local frame2 = Instance.new("Frame")
	frame2.Size = UDim2.new(0, 4, 0, 4)
	frame2.Position = UDim2.new(0, 5, 0.5, -2)
	frame2.BorderSizePixel = 0
	frame2.ZIndex = 13
	frame2.Parent = textButton3
	local uiCorner3 = Instance.new("UICorner")
	uiCorner3.CornerRadius = UDim.new(1, 0)
	uiCorner3.Parent = frame2
	local textButton4 = Instance.new("TextButton")
	textButton4.Size = UDim2.new(0.45, 0, 0, 13)
	textButton4.Position = UDim2.new(0.51, 0, 0, 78)
	textButton4.TextSize = 9
	textButton4.TextScaled = false
	textButton4.Font = Enum.Font.GothamBlack
	textButton4.TextXAlignment = Enum.TextXAlignment.Center
	textButton4.ZIndex = 12
	textButton4.Parent = frame
	slicedfn4(textButton4)
	local uiCorner4 = Instance.new("UICorner")
	uiCorner4.CornerRadius = UDim.new(1, 0)
	uiCorner4.Parent = textButton4
	local frame3 = Instance.new("Frame")
	frame3.Size = UDim2.new(0, 4, 0, 4)
	frame3.Position = UDim2.new(0, 5, 0.5, -2)
	frame3.BorderSizePixel = 0
	frame3.ZIndex = 13
	frame3.Parent = textButton4
	local uiCorner5 = Instance.new("UICorner")
	uiCorner5.CornerRadius = UDim.new(1, 0)
	uiCorner5.Parent = frame3

	local function slicedfn7()
		if visible then
			textButton3.Text = "HIDE NAMES ON"
			textButton3.BackgroundColor3 = color7
			textButton3.TextColor3 = color8
			frame2.BackgroundColor3 = color9
		else
			textButton3.Text = "HIDE NAMES OFF"
			textButton3.BackgroundColor3 = color10
			textButton3.TextColor3 = color11
			frame2.BackgroundColor3 = color12
		end
	end

	local function slicedfn8()
		if visible2 then
			textButton4.Text = "SHOW # ON"
			textButton4.BackgroundColor3 = color7
			textButton4.TextColor3 = color8
			frame3.BackgroundColor3 = color9
		else
			textButton4.Text = "SHOW # OFF"
			textButton4.BackgroundColor3 = color10
			textButton4.TextColor3 = color11
			frame3.BackgroundColor3 = color12
		end
	end

	local function slicedfn9()
		textLabel2.Text = revealed and (game.JobId ~= "" and game.JobId or str) or str
		textButton2.Text = revealed and "SHOW" or "HIDE"
		imageLabel.ImageRectOffset = revealed and Vector2.new(724, 364) or Vector2.new(760, 364)
	end
	slicedfn7()
	slicedfn8()
	slicedfn9()
	slicedfn6()
	local flag = nil
	local position = nil
	local position2 = nil

	local function slicedfn10(arg)
		flag = true
		position = arg.Position
		position2 = frame.Position
		arg.Changed:Connect(function()
			if arg.UserInputState == Enum.UserInputState.End then flag = false end
		end)
	end
	for _, slicedv7 in ipairs({ textLabel, frame }) do
		slicedv7.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then slicedfn10(input) end
		end)
	end
	UserInputService.InputChanged:Connect(function(input)
		if flag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local n = input.Position - position
			frame.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n.X, position2.Y.Scale, position2.Y.Offset + n.Y)
		end
	end)
	textButton.MouseButton1Click:Connect(function()
		local jobId = game.JobId
		if setclipboard then
			setclipboard(jobId)
		elseif toclipboard then
			toclipboard(jobId)
		end
		print("Job ID: " .. jobId)
		textButton.Text = "COPIED"
		task.wait(1.1)
		textButton.Text = "COPY"
	end)
	textButton2.MouseButton1Click:Connect(function()
		revealed = not revealed
		slicedfn9()
		slicedv6.revealed = revealed
		slicedfn5(slicedv6)
	end)
	textButton3.MouseButton1Click:Connect(function()
		visible = not visible
		slicedfn7()
		slicedfn6()
		slicedv6.namesVisible = visible
		slicedfn5(slicedv6)
	end)
	textButton4.MouseButton1Click:Connect(function()
		visible2 = not visible2
		slicedfn8()
		slicedfn6()
		slicedv6.numbersVisible = visible2
		slicedfn5(slicedv6)
	end)
end
