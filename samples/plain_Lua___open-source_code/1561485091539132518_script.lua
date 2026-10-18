local CONFIG = {
	TrashExecutorSupported = true,
	DefaultScript = "2ef8fd6bd9548054ae8c4412307980ab",
	TesterScript = "3226832bad9b1dcfc4cbc973827fee8a",
	GetKeyLink = "https://zenithhub.cloud/get-key",
	PurchaseLink = "https://zenithhub.cloud/purchase",
	PlaceScripts = {
		[2753915549] = "ae225a50bc5c5afd3cba10b375de4378",
		[4442272183] = "ae225a50bc5c5afd3cba10b375de4378",
		[7449423635] = "ae225a50bc5c5afd3cba10b375de4378",
		[72907489978215] = "ecf0b62b27dfef6e72a3649dd8c1efb5",
		[131716211654599] = "ecf0b62b27dfef6e72a3649dd8c1efb5",
		[16732694052] = "ecf0b62b27dfef6e72a3649dd8c1efb5",
		[85896571713843] = "79d15dd7daecbde9a451298621057f9c",
		[126884695634066] = "b4154c552fa0dc9919cbb76bbaf1df92",
		[99519129453387] = "870b60ec96a7e1780c4a4e5681d20b0a",
		[121864768012064] = "ca2a56e457d5e90ae0697000e0a08c0a",
		[13772394625] = "bebe82ff30ee19066d901e38df564e72",
		[94101948530988] = "d9576cf6d588be8b661ff1a9ea63639b",
		[76558904092080] = "4be077018e077bd50674642ef3bc38d9",
		[129009554587176] = "4be077018e077bd50674642ef3bc38d9",
		[131884594917121] = "4be077018e077bd50674642ef3bc38d9",
		[79546208627805] = "3f8a81859b16cd9642d832053b439b53",
		[126509999114328] = "3f8a81859b16cd9642d832053b439b53",
		[131623223084840] = "ca7121c0f77ceae60782aa509544156d",
	},
	CreatorScripts = {
		[7381705] = "ecf0b62b27dfef6e72a3649dd8c1efb5",
		[34898222] = "c6cc4567dd55aecc2279a286c2eb2b98",
		[35489258] = "4be077018e077bd50674642ef3bc38d9",
		[460048752] = "e1aee8ab578a48b2a57d1a2ac51d2082",
	}
}

local cloneref = cloneref or function(o) return o end

local function GetService(Name)
	local Success, Service = pcall(function()
		return cloneref(game:GetService(Name))
	end)
	return Success and Service or nil
end

local ExecutorName = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "Unknown"
local ExecutorLower = string.lower(ExecutorName)

if getgenv().TrashExecutor == nil then
	getgenv().TrashExecutor = ExecutorLower:find("xeno") or ExecutorLower:find("solara") or false
end

local UserInputService = GetService("UserInputService")
local TweenService = GetService("TweenService")
local Players = GetService("Players")
local CoreGui = GetService("CoreGui")
local HttpService = GetService("HttpService")
local PlaceId = game.PlaceId

local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end
local GetHui = gethui or function() return CoreGui end

local function ParentUiSafe(Inst, Parent)
	local Success = pcall(function()
		local Dest = typeof(Parent) == "function" and Parent() or (Parent or CoreGui)
		Inst.Parent = Dest
	end)
	if not (Success and Inst.Parent) then
		pcall(function()
			Inst.Parent = CoreGui
		end)
		if not Inst.Parent then
			warn("[Zenith] UI Parenting failed entirely. Change that slop executor!")
		end
	end
end

local function ParentUi(Ui, SkipHiddenUi)
	if SkipHiddenUi then
		ParentUiSafe(Ui, CoreGui)
		return
	end
	pcall(ProtectGui, Ui)
	ParentUiSafe(Ui, GetHui)
end

local function MakeDraggable(Handle, Frame)
	local Dragging, DragInput, DragStart, StartPos = false, nil, nil, nil

	local function Update(Input)
		local Delta = Input.Position - DragStart
		local Pos = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
		TweenService:Create(Frame, TweenInfo.new(0.2), {Position = Pos}):Play()
	end

	Handle.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = Input.Position
			StartPos = Frame.Position
			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	Handle.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
			DragInput = Input
		end
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if Input == DragInput and Dragging then
			Update(Input)
		end
	end)
end

local function HoverEffect(Btn, HoverColor, NormalColor)
	HoverColor = HoverColor or ThemeHoverColor
	NormalColor = NormalColor or ThemeColor
	Btn.MouseEnter:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = HoverColor}):Play()
	end)
	Btn.MouseLeave:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = NormalColor}):Play()
	end)
end

local function UiUpdate(Element, Property, Value)
	if Element and Element.Parent then
		pcall(function() Element[Property] = Value end)
		return true
	end
	return false
end

local function CreateCopyButton(Btn, DefaultText, CopiedText, Clipboard)
	local Copying = false
	Btn.MouseButton1Click:Connect(function()
		if Copying then return end
		Copying = true
		pcall(setclipboard, Clipboard)
		pcall(function() Btn.Text = CopiedText end)
		task.wait(1)
		pcall(function() Btn.Text = DefaultText end)
		Copying = false
	end)
end

local Api = nil
do
	local Success, ApiData = pcall(function()
		return loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua", true))()
	end)
	if Success and ApiData then
		Api = ApiData
	else
		local FallbackSuccess, FallbackData = pcall(function()
			return loadstring(game:HttpGet("https://zenithhub.cloud/panel/library.lua", true))()
		end)
		if FallbackSuccess and FallbackData then
			Api = FallbackData
		end
	end
end

if Api then
	if getgenv().TesterScript == true then
		TargetScriptId = CONFIG.TesterScript
		Api.script_id = TargetScriptId
	else
		local ScriptId = CONFIG.PlaceScripts[PlaceId]

		if not ScriptId then
			local MarketplaceService = GetService("MarketplaceService")
			local Success, ProductInfo = pcall(function()
				return MarketplaceService:GetProductInfo(PlaceId)
			end)
			if Success and ProductInfo and ProductInfo.Creator then
				ScriptId = CONFIG.CreatorScripts[ProductInfo.Creator.CreatorTargetId]
			end
		end

		TargetScriptId = ScriptId or CONFIG.DefaultScript
		Api.script_id = TargetScriptId
	end
else
	warn("[Zenith]", "Luarmor API could not be loaded")
end

local ZenithAssets = {
	Assets = {
		LockIcon = {Path = "ZenithUI/assets/Lock.png"},
		ZenithLogoShape = {RobloxId = 95474178623916},
		ZenithLogoZ = {RobloxId = 78056884165305},
		CheckIcon = {RobloxId = 112315656061835},
		LogoMain = {RobloxId = 138929814993200},
		LogoMainNew = {RobloxId = 98085346035268},
		Chat = {RobloxId = 138368006212972},
		StatusClock = {RobloxId = 6031280882},
		StatusGift = {RobloxId = 6031229344},
		StatusScript = {RobloxId = 6031229338},
		StatusStar = {RobloxId = 6031229352},
		StatusWeather = {RobloxId = 6031229350},
		StatusBolt = {RobloxId = 6031229330},
		StatusLuck = {RobloxId = 6031229342},
		DiscordIcon = {RobloxId = 90282608590015},
		SpinIcon = {RobloxId = 6034684949},
		ScriptRunIcon = {RobloxId = 10734940376},
		AccessTimeIcon = {RobloxId = 10734984606},
		PremiumStarIcon = {RobloxId = 10734966248},
	},
}

do
	local Bindings = {}

	local function EnsureFolders(Path, IsFile)
		if not isfolder or not makefolder then return end
		local Segments = Path:split("/")
		if IsFile then table.remove(Segments, #Segments) end
		
		local Built = ""
		for _, Seg in ipairs(Segments) do
			local Full = Built .. Seg
			Built = Full .. "/"
			
			local CheckSuccess, Exists = pcall(isfolder, Full)
			if not (CheckSuccess and Exists) then
				local MakeSuccess = pcall(makefolder, Full)
				if not MakeSuccess then
					local RetrySuccess, RetryExists = pcall(isfolder, Full)
					if not (RetrySuccess and RetryExists) then return end
				end
			end
		end
	end

	local _hasGCA = getcustomasset ~= nil
	local _hasIsFile = isfile ~= nil
	local _hasWriteFile = writefile ~= nil
	local Fetching = {}

	local function Fetch(Path)
		if Fetching[Path] then return end
		Fetching[Path] = true
		task.spawn(function()
			ZenithAssets.DownloadAsset(Path)
			for Name, Data in pairs(ZenithAssets.Assets) do
				if Data.Path == Path then ZenithAssets.RefreshAsset(Name) end
			end
		end)
	end

	function ZenithAssets.GetAsset(Name)
		local Data = ZenithAssets.Assets[Name]
		if not Data then
			if type(Name) ~= "string" or Name == "" then return "" end
			Data = {Path = "ZenithUI/assets/" .. (Name:find("%.") and Name or Name .. ".png")}
			ZenithAssets.Assets[Name] = Data
		end
		if Data.Id and Data.Id ~= "" then return Data.Id end

		if Data.Path then
			if _hasGCA and _hasIsFile then
				local CheckSuccess, FileExists = pcall(isfile, Data.Path)
				if CheckSuccess and FileExists then
					local CustomAssetSuccess, CustomAssetId = pcall(getcustomasset, Data.Path)
					if CustomAssetSuccess and CustomAssetId then
						Data.Id = CustomAssetId
						return CustomAssetId
					end
				end
			end
			Fetch(Data.Path)
			return ""
		end

		local Id = "rbxassetid://" .. Data.RobloxId
		Data.Id = Id
		return Id
	end

	function ZenithAssets.BindAsset(Element, Property, AssetName)
		if not Bindings[AssetName] then Bindings[AssetName] = {} end
		table.insert(Bindings[AssetName], {Element, Property})
		local Id = ZenithAssets.GetAsset(AssetName)
		if Id and Id ~= "" then pcall(function() Element[Property] = Id end) end
	end

	function ZenithAssets.RefreshAsset(AssetName)
		local List = Bindings[AssetName]
		if not List then return end
		local Id = ZenithAssets.GetAsset(AssetName)
		if Id and Id ~= "" then
			for _, B in ipairs(List) do
				pcall(function() B[1][B[2]] = Id end)
			end
		end
	end

	function ZenithAssets.RefreshAll()
		for Name in pairs(Bindings) do
			ZenithAssets.RefreshAsset(Name)
		end
	end

	function ZenithAssets.DownloadAsset(AssetPath)
		pcall(function()
			if not _hasGCA or not _hasWriteFile or not _hasIsFile then return end
			EnsureFolders(AssetPath, true)

			local CheckSuccess, FileExists = pcall(isfile, AssetPath)
			if CheckSuccess and FileExists then return end

			local UrlPath = AssetPath:gsub("ZenithUI/", "")
			local FetchSuccess, FileContent = pcall(function()
				return game:HttpGet("https://zenithhub.cloud/panel/" .. UrlPath, true)
			end)
			if not FetchSuccess or type(FileContent) ~= "string" then return end
			local Head = FileContent:sub(1, 4)
			if Head == "\137PNG" or Head:sub(1, 2) == "\255\216" or Head == "GIF8" or Head == "RIFF" then
				pcall(writefile, AssetPath, FileContent)
			end
		end)
	end

	getgenv().ZenithAssets = ZenithAssets
end

if getgenv().ZenithNotification == nil then
	local Ok, Result = pcall(function()
		return loadstring(game:HttpGet("https://zenithhub.cloud/panel/zenithnotification", true))()
	end)
	if Ok and Result then
		getgenv().ZenithNotification = Result
	end
end

local function Create(className, properties)
	local inst = Instance.new(className)
	for k, v in pairs(properties) do
		if type(k) == "string" and k ~= "Parent" then
			inst[k] = v
		end
	end
	if properties.Parent then
		inst.Parent = properties.Parent
	end
	return inst
end

local ThemeColor = Color3.fromRGB(255, 85, 85)
local ThemeHoverColor = Color3.fromRGB(255, 100, 100)
local ThemeDarkColor = Color3.fromRGB(200, 70, 70)
local ThemeTextColor = Color3.fromRGB(255, 255, 255)

local Success, Err = pcall(function()
	local loadedTheme = "Red (Default)"
	
	if isfile and isfile("eKitten Voice Recordings/Selected Config.json") then
		local confJson = readfile("eKitten Voice Recordings/Selected Config.json")
		if HttpService then
			local confData = HttpService:JSONDecode(confJson)
			if confData and confData.SelectedConfig and confData.SelectedConfig ~= "None" then
				local profileFile = "eKitten Voice Recordings/Configs/" .. confData.SelectedConfig .. ".json"
				if isfile(profileFile) then
					local settingsData = HttpService:JSONDecode(readfile(profileFile))
					if settingsData and settingsData.SelectedUITheme then
						loadedTheme = settingsData.SelectedUITheme
					end
				end
			end
		end
	end
	
	loadedTheme = loadedTheme:gsub("[\n\r]", "")
	
	local colorMap = {
		["Red (Default)"] = Color3.fromRGB(255,75,95), ["Valentine 💕"] = Color3.fromRGB(255,105,140),
		["Blue"] = Color3.fromRGB(75,165,255), ["Green"] = Color3.fromRGB(75,255,95),
		["Purple"] = Color3.fromRGB(175,75,255), ["Orange"] = Color3.fromRGB(255,160,75),
		["Pink"] = Color3.fromRGB(255,75,190), ["Cyan"] = Color3.fromRGB(75,255,255),
		["Yellow"] = Color3.fromRGB(255,235,75), ["White"] = Color3.fromRGB(245,245,250),
		["Dark Purple"] = Color3.fromRGB(120,45,195), ["Lime"] = Color3.fromRGB(180,255,75),
		["Magenta"] = Color3.fromRGB(255,75,245), ["Gold"] = Color3.fromRGB(255,200,45),
		["Sky Blue"] = Color3.fromRGB(125,195,245), ["Crimson"] = Color3.fromRGB(210,35,70),
		["Mint"] = Color3.fromRGB(140,255,145)
	}
	
	if colorMap[loadedTheme] then
		ThemeColor = colorMap[loadedTheme]
	end
	
	local h, s, v = Color3.toHSV(ThemeColor)
	ThemeHoverColor = Color3.fromHSV(h, s, math.clamp(v + 0.1, 0, 1))
	ThemeDarkColor = Color3.fromHSV(h, s, math.clamp(v - 0.2, 0, 1))
	
	local lum = (0.299 * ThemeColor.R) + (0.587 * ThemeColor.G) + (0.114 * ThemeColor.B)
	if lum > 0.65 then
		ThemeTextColor = Color3.fromRGB(20, 20, 25)
	else
		ThemeTextColor = Color3.fromRGB(255, 255, 255)
	end
end)

local function CreateExecutorWarningUi()
	local UiParent = (GetHui and GetHui()) or CoreGui
	local OldUi = UiParent:FindFirstChild("ExecutorWarning")
	if OldUi then OldUi:Destroy() end

	local WarningUi = Create("ScreenGui", {Name = "ExecutorWarning", ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
	ParentUi(WarningUi)
	local MainFrame = Create("ImageLabel", {
		Parent = WarningUi, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 410, 0, 285), BackgroundColor3 = Color3.fromRGB(12, 12, 14), BackgroundTransparency = 0.03,
		BorderSizePixel = 0, ImageColor3 = ThemeColor, ImageTransparency = 0.8,
	})
	ZenithAssets.BindAsset(MainFrame, "Image", "GlowTop")
	Create("UICorner", {Parent = MainFrame, CornerRadius = UDim.new(0, 12)})
	Create("UIStroke", {Parent = MainFrame, Color = ThemeColor, Transparency = 0.45, Thickness = 1})

	local Logo = Create("ImageLabel", {
		Parent = MainFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 24, 0, 20), Size = UDim2.new(0, 40, 0, 40),
		Image = ZenithAssets.GetAsset("LogoMainNew"), ImageColor3 = Color3.fromRGB(255, 255, 255), ScaleType = Enum.ScaleType.Fit,
	})
	ZenithAssets.BindAsset(Logo, "Image", "LogoMainNew")
	Create("TextLabel", {
		Parent = MainFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 74, 0, 20), Size = UDim2.new(1, -98, 0, 22),
		Font = Enum.Font.GothamBold, Text = "Compatibility Notice", TextColor3 = Color3.fromRGB(245, 245, 248), TextSize = 19,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	Create("TextLabel", {
		Parent = MainFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 74, 0, 43), Size = UDim2.new(1, -98, 0, 18),
		Font = Enum.Font.Gotham, Text = ExecutorName .. " may be temporarily unsupported", TextColor3 = ThemeColor, TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	local DiscordBtn = Create("TextButton", {
		Parent = MainFrame, BackgroundTransparency = 1, Position = UDim2.new(1, -88, 0, 24), Size = UDim2.new(0, 64, 0, 28),
		Font = Enum.Font.GothamBold, Text = "Discord", TextColor3 = Color3.fromRGB(145, 145, 154), TextSize = 11, AutoButtonColor = false,
	})
	Create("UICorner", {Parent = DiscordBtn, CornerRadius = UDim.new(0, 8)})
	Create("UIStroke", {Parent = DiscordBtn, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = Color3.fromRGB(90, 90, 98), Transparency = 0.55, Thickness = 1})
	HoverEffect(DiscordBtn, Color3.fromRGB(38, 38, 44), Color3.fromRGB(12, 12, 14))
	DiscordBtn.MouseButton1Click:Connect(function()
		pcall(setclipboard, "discord.gg/zenithstudios")
		DiscordBtn.Text = "Copied!"
		task.delay(1.5, function() UiUpdate(DiscordBtn, "Text", "Discord") end)
	end)
	local Notice = Create("Frame", {
		Parent = MainFrame, BackgroundColor3 = Color3.fromRGB(20, 20, 23), BorderSizePixel = 0,
		Position = UDim2.new(0, 24, 0, 80), Size = UDim2.new(1, -48, 0, 120),
	})
	Create("UICorner", {Parent = Notice, CornerRadius = UDim.new(0, 8)})
	Create("UIStroke", {Parent = Notice, Color = Color3.fromRGB(255, 255, 255), Transparency = 0.92, Thickness = 1})
	Create("Frame", {Parent = Notice, BackgroundColor3 = ThemeColor, BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, 12), Size = UDim2.new(0, 3, 1, -24)})
	Create("TextLabel", {
		Parent = Notice, BackgroundTransparency = 1, Position = UDim2.new(0, 18, 0, 12), Size = UDim2.new(1, -34, 1, -24),
		Font = Enum.Font.Gotham, Text = "Due to recent Luraph changes, the script may not work on your executor. You can switch executors or continue and give it a try.\n\nUpdates will be shared in Discord #sub-announcements.\n\nRecommended: Potassium if you want a paid executor; Madium or Velocity for a free option.",
				TextColor3 = Color3.fromRGB(190, 190, 198), TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
	})
	local SwitchBtn = Create("TextButton", {
		Parent = MainFrame, BackgroundColor3 = ThemeColor, BackgroundTransparency = 0.8, BorderSizePixel = 0,
		Position = UDim2.new(0, 24, 1, -61), Size = UDim2.new(0.5, -29, 0, 40), Font = Enum.Font.GothamBold,
		Text = "Switch Executor  →", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 13, AutoButtonColor = false,
	})
	local ContinueBtn = Create("TextButton", {
		Parent = MainFrame, BackgroundColor3 = Color3.fromRGB(27, 27, 31), BorderSizePixel = 0, Position = UDim2.new(0.5, 5, 1, -61),
		Size = UDim2.new(0.5, -29, 0, 40), Font = Enum.Font.GothamBold, Text = "Continue Anyway", TextColor3 = Color3.fromRGB(235, 235, 240), TextSize = 13, AutoButtonColor = false,
	})
	Create("UICorner", {Parent = SwitchBtn, CornerRadius = UDim.new(0, 12)})
	Create("UIStroke", {Parent = SwitchBtn, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = ThemeColor, Transparency = 0.5, Thickness = 1})
	Create("UICorner", {Parent = ContinueBtn, CornerRadius = UDim.new(0, 12)})
	Create("UIStroke", {Parent = ContinueBtn, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = Color3.fromRGB(90, 90, 98), Transparency = 0.55, Thickness = 1})
	SwitchBtn.MouseEnter:Connect(function()
		TweenService:Create(SwitchBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
	end)
	SwitchBtn.MouseLeave:Connect(function()
		TweenService:Create(SwitchBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.8}):Play()
	end)
	HoverEffect(ContinueBtn, Color3.fromRGB(38, 38, 44), Color3.fromRGB(27, 27, 31))
	SwitchBtn.MouseButton1Click:Connect(function()
		pcall(setclipboard, "https://weao.xyz")
		SwitchBtn.Text = "Copied Link!"
		task.delay(1.5, function() UiUpdate(SwitchBtn, "Text", "Switch Executor  →") end)
	end)
	local ContinueEvent = Instance.new("BindableEvent")
	ContinueBtn.MouseButton1Click:Connect(function() ContinueEvent:Fire() end)
	MakeDraggable(MainFrame, MainFrame)
	ContinueEvent.Event:Wait()
	ContinueEvent:Destroy()
	WarningUi:Destroy()
end

local function CreateKeySystemUi()
	local UiParent = (GetHui and GetHui()) or CoreGui

	local OldKeySystem = UiParent:FindFirstChild("KeySystem")
	if OldKeySystem then OldKeySystem:Destroy() end
	local OldScreenGui = UiParent:FindFirstChild("ScreenGui")
	if OldScreenGui then OldScreenGui:Destroy() end

	local KeySystem = Create("ScreenGui", {
		Name = "KeySystem",
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	})
	ParentUi(KeySystem)

	local MainFrame = Create("ImageLabel", {
		Name = "Main",
		Parent = KeySystem,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(12, 12, 14),
		BackgroundTransparency = 0.05,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 380, 0, 285),
		ImageTransparency = 0.75,
		ImageColor3 = ThemeColor,
	})
	
	if ZenithAssets then
		ZenithAssets.BindAsset(MainFrame, "Image", "GlowTop")
	end

	local LogoBottom = Create("ImageLabel", {
		Parent = MainFrame,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 14, 0, 15),
		Size = UDim2.new(0, 42, 0, 40),
		ImageColor3 = ThemeColor,
		ZIndex = 1,
		Image = ZenithAssets.GetAsset("ZenithLogoBottom"),
	})
	ZenithAssets.BindAsset(LogoBottom, "Image", "ZenithLogoBottom")

	local ShimmerColors = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.4, Color3.fromRGB(200, 200, 200)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.6, Color3.fromRGB(200, 200, 200)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
	})

	local LogoGradient = Create("UIGradient", {
		Parent = LogoBottom,
		Rotation = 0,
		Color = ShimmerColors,
		Offset = Vector2.new(-1, 0),
	})

	task.spawn(function()
		task.wait(1)
		pcall(function()
			local ShimmerTween = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			while LogoBottom and LogoBottom.Parent do
				local T1 = TweenService:Create(LogoGradient, ShimmerTween, {Offset = Vector2.new(1, 0)})
				T1:Play(); T1.Completed:Wait()
				local T2 = TweenService:Create(LogoGradient, ShimmerTween, {Offset = Vector2.new(-1, 0)})
				T2:Play(); T2.Completed:Wait()
			end
		end)
	end)

	local LogoTop = Create("ImageLabel", {
		Parent = MainFrame,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 14, 0, 15),
		Size = UDim2.new(0, 42, 0, 40),
		ImageColor3 = Color3.fromRGB(255, 255, 255),
		ZIndex = 2,
		Image = ZenithAssets.GetAsset("ZenithLogoTop"),
	})
	ZenithAssets.BindAsset(LogoTop, "Image", "ZenithLogoTop")

	Create("UICorner", {
		CornerRadius = UDim.new(0, 12),
		Parent = MainFrame,
	})

	local MainStroke = Create("UIStroke", {
		Parent = MainFrame,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = Color3.fromRGB(255, 255, 255),
		Transparency = 0.5,
		Thickness = 1,
	})

	local StrokeGradient = Create("UIGradient", {
		Parent = MainStroke,
		Rotation = 0,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, ThemeColor),
			ColorSequenceKeypoint.new(0.3, Color3.fromRGB(50, 50, 55)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 45)),
		}),
	})

	task.spawn(function()
		pcall(function()
			local RotTween = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
			while MainStroke and MainStroke.Parent do
				StrokeGradient.Rotation = 0
				local T = TweenService:Create(StrokeGradient, RotTween, {Rotation = 360})
				T:Play(); T.Completed:Wait()
			end
		end)
	end)

	local Header = Create("Frame", {
		Name = "Header",
		Parent = MainFrame,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 100),
	})

	local Title = Create("TextLabel", {
		Name = "Title",
		Parent = Header,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 30, 0, 20),
		Size = UDim2.new(1, -60, 0, 30),
		Font = Enum.Font.GothamBold,
		Text = "     Welcome to The,",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 22,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	local Subtitle = Create("TextLabel", {
		Name = "Subtitle",
		Parent = Header,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 30, 0, 50),
		Size = UDim2.new(1, -60, 0, 30),
		Font = Enum.Font.GothamBold,
		Text = "Zenith Hub",
		TextColor3 = ThemeColor,
		TextSize = 22,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	local KeyInput = Create("TextBox", {
		Name = "KeyInput",
		Parent = MainFrame,
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
		BorderSizePixel = 0,
		Position = UDim2.new(0, 30, 0, 100),
		Size = UDim2.new(1, -60, 0, 45),
		Font = Enum.Font.Gotham,
		PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
		PlaceholderText = "Insert your key here",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 14,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextWrapped = true,
		ClearTextOnFocus = false,
	})

	local SavedKey = ""
	pcall(function()
		if isfile and isfile("Zenith Key.txt") then
			SavedKey = readfile("Zenith Key.txt") or ""
		end
	end)
	KeyInput.Text = SavedKey

	local Stroke = Create("UIStroke", {
		Parent = KeyInput,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = Color3.fromRGB(240, 240, 240),
		Transparency = 0.90,
		LineJoinMode = Enum.LineJoinMode.Round,
		Thickness = 1,
	})

	Create("UICorner", {
		CornerRadius = UDim.new(0, 8),
		Parent = KeyInput,
	})

	local FocusConn = nil

	KeyInput.Focused:Connect(function()
		TweenService:Create(Stroke, TweenInfo.new(0.2), {
			Color = ThemeColor,
			Transparency = 0
		}):Play()
		TweenService:Create(KeyInput, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(1, -52, 0, 45),
			Position = UDim2.new(0, 26, 0, 100)
		}):Play()
		if FocusConn then pcall(function() FocusConn:Disconnect() end) end
		FocusConn = UserInputService.InputBegan:Connect(function(Input)
			if Input.KeyCode == Enum.KeyCode.Return then
				KeyInput.Text = KeyInput.Text:gsub("\n", "")
				KeyInput:ReleaseFocus()
			end
		end)
	end)

	KeyInput.FocusLost:Connect(function()
		TweenService:Create(Stroke, TweenInfo.new(0.2), {
			Color = Color3.fromRGB(240, 240, 240),
			Transparency = 0.90
		}):Play()
		TweenService:Create(KeyInput, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(1, -60, 0, 45),
			Position = UDim2.new(0, 30, 0, 100)
		}):Play()
		if FocusConn then pcall(function() FocusConn:Disconnect() end); FocusConn = nil end
	end)

	local SubmitBtn = Create("TextButton", {
		Name = "SubmitBtn",
		Parent = MainFrame,
		BackgroundColor3 = ThemeColor,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 30, 0, 155),
		Size = UDim2.new(1, -60, 0, 45),
		Font = Enum.Font.GothamBold,
		Text = "Submit Key >",
		TextColor3 = ThemeTextColor,
		TextSize = 16,
		ClipsDescendants = true,
		AutoButtonColor = false,
	})

	Create("UICorner", {
		CornerRadius = UDim.new(0, 8),
		Parent = SubmitBtn,
	})

	SubmitBtn.MouseButton1Click:Connect(function()
		SubmitBtn.TextSize = 12
		TweenService:Create(SubmitBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back), {TextSize = 16}):Play()
		local Ripple = Create("Frame", {
			Parent = SubmitBtn,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0.7,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 0, 0, 0),
			ZIndex = SubmitBtn.ZIndex + 1,
		})
		Create("UICorner", {
			CornerRadius = UDim.new(1, 0),
			Parent = Ripple,
		})
		TweenService:Create(Ripple, TweenInfo.new(0.45, Enum.EasingStyle.Quad), {Size = UDim2.new(1.5, 0, 3, 0), BackgroundTransparency = 1}):Play()
		task.delay(0.45, function() pcall(function() Ripple:Destroy() end) end)
	end)

	local SupportText = Create("TextLabel", {
		Name = "SupportText",
		Parent = MainFrame,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, -80, 0, 255),
		Size = UDim2.new(0, 85, 0, 20),
		Font = Enum.Font.Gotham,
		Text = "Need support?",
		TextColor3 = Color3.fromRGB(150, 150, 150),
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Right,
	})

	local DiscordLink = Create("TextButton", {
		Name = "DiscordLink",
		Parent = MainFrame,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 8, 0, 255),
		Size = UDim2.new(0, 120, 0, 20),
		Font = Enum.Font.GothamBold,
		Text = "Join the Discord",
		TextColor3 = ThemeColor,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	local ButtonsFrame = Create("Frame", {
		Name = "ButtonsFrame",
		Parent = MainFrame,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 30, 0, 280),
		Size = UDim2.new(1, -60, 0, 35),
	})

	local GetKeyBtn = Create("TextButton", {
		Name = "GetKeyBtn",
		Parent = ButtonsFrame,
		BackgroundColor3 = ThemeColor,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, -70),
		Size = UDim2.new(0.6, -5, 1, 0),
		Font = Enum.Font.GothamBold,
		Text = "Get Key",
		TextColor3 = ThemeTextColor,
		TextSize = 13,
		ClipsDescendants = true,
		AutoButtonColor = false,
	})

	Create("UICorner", {
		CornerRadius = UDim.new(0, 6),
		Parent = GetKeyBtn,
	})

	local SkipKeyBtn = Create("TextButton", {
		Name = "SkipKeyBtn",
		Parent = ButtonsFrame,
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
		BorderSizePixel = 0,
		Position = UDim2.new(0.6, 0, 0, -70),
		Size = UDim2.new(0.4, 0, 1, 0),
		Font = Enum.Font.Gotham,
		Text = "Skip Key System",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 13,
		ClipsDescendants = true,
		AutoButtonColor = false,
	})

	Create("UICorner", {
		CornerRadius = UDim.new(0, 6),
		Parent = SkipKeyBtn,
	})

	Create("UIStroke", {
		Parent = SkipKeyBtn,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = Color3.fromRGB(240, 240, 240),
		Transparency = 0.90,
		Thickness = 1,
	})

	local function AddRipple(Btn)
		Btn.MouseButton1Click:Connect(function()
			Btn.TextSize = 10
			TweenService:Create(Btn, TweenInfo.new(0.4, Enum.EasingStyle.Back), {TextSize = 13}):Play()
			local Ripple = Create("Frame", {
				Parent = Btn,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 0.7,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0, 0, 0, 0),
				ZIndex = Btn.ZIndex + 1,
			})
			Create("UICorner", {
				CornerRadius = UDim.new(1, 0),
				Parent = Ripple,
			})
			TweenService:Create(Ripple, TweenInfo.new(0.45, Enum.EasingStyle.Quad), {Size = UDim2.new(1.5, 0, 3, 0), BackgroundTransparency = 1}):Play()
			task.delay(0.45, function() pcall(function() Ripple:Destroy() end) end)
		end)
	end

	AddRipple(GetKeyBtn)
	AddRipple(SkipKeyBtn)

	HoverEffect(SubmitBtn, ThemeHoverColor, ThemeColor)
	HoverEffect(GetKeyBtn)

	DiscordLink.MouseEnter:Connect(function()
		TweenService:Create(DiscordLink, TweenInfo.new(0.2), {TextColor3 = ThemeDarkColor}):Play()
	end)
	DiscordLink.MouseLeave:Connect(function()
		TweenService:Create(DiscordLink, TweenInfo.new(0.2), {TextColor3 = ThemeColor}):Play()
	end)

	CreateCopyButton(GetKeyBtn, "Get Key", "Copied!", CONFIG.GetKeyLink)
	CreateCopyButton(SkipKeyBtn, "Skip Key System", "Copied!", CONFIG.PurchaseLink)
	CreateCopyButton(DiscordLink, "Join the Discord", "Copied!", "discord.gg/zenithstudios")

	MakeDraggable(MainFrame, MainFrame)

	return {
		KeySystem = KeySystem,
		Main = MainFrame,
		KeyInput = KeyInput,
		SubmitBtn = SubmitBtn,
	}
end

if getgenv().TrashExecutor and not CONFIG.TrashExecutorSupported then
	CreateExecutorWarningUi()
end

if not Api then
	warn("[Zenith]", "Loader failed to initialize")
	return
end

script_key = "KEY HERE"
getgenv().script_key = "KEY HERE"

local KeyValidator = {Processing = false, Authenticated = false}

local function TrimWhitespace(Str)
	return Str and Str:gsub("%s", "") or ""
end

local function LoadScript()
	Api.script_id = TargetScriptId
	Api.load_script()
	return true, nil
end

local function SendNotification(Title, Text, Duration)
	local Notify = getgenv().ZenithNotification
	if not Notify then return end
	pcall(function()
		if type(Notify) == "function" then
			Notify({Title = Title, Text = Text, Duration = Duration})
		elseif type(Notify) == "table" then
			local Fn = Notify.send or Notify.Send or Notify.Notify
			if Fn then Fn(Notify, {Title = Title, Text = Text, Duration = Duration}) end
		end
	end)
end

local function AttemptAutoAuth()
	local Result = {Success = false, Error = nil}
	local AuthSuccess, AuthError = pcall(function()
		local HasFile = isfile and isfile("Zenith Key.txt")
		if not HasFile then return end
		local Saved = TrimWhitespace(readfile("Zenith Key.txt"))
		if #Saved == 0 then return end

		local Status
		local ApiSuccess = pcall(function() Status = Api.check_key(Saved) end)

		if not ApiSuccess or not Status then
			Result.Error = "Auto-Auth: API Error"
			return
		end
		if Status.code ~= "KEY_VALID" then
			Result.Error = "Auto-Auth: " .. tostring(Status.code)
			return
		end

		Result.Success = true
		script_key = Saved
		getgenv().script_key = Saved
		task.wait(0.1)
		KeyValidator.Authenticated = true
		getgenv().Authenticated = true
		local LoadSuccess, LoadError = pcall(LoadScript)
		if not LoadSuccess then
			warn("[Zenith]", "Auto-Auth load error:", LoadError)
			Result.Success = false
			Result.Error = "Auto-Auth: Script load crashed"
		end
	end)

	if not AuthSuccess then
		Result.Error = "Auto-Auth: " .. tostring(AuthError)
		warn("[Zenith]", "Auto-Auth error:", AuthError)
	end
	return Result
end

local Auth = AttemptAutoAuth()

if Auth.Success then return end

local Ui = CreateKeySystemUi()
local KeyInput, SubmitBtn = Ui.KeyInput, Ui.SubmitBtn

local function SetSubmitText(Text, RevertDelay)
	UiUpdate(SubmitBtn, "Text", Text)
	if RevertDelay then
		task.delay(RevertDelay, function()
			UiUpdate(SubmitBtn, "Text", "Submit Key >")
		end)
	end
end

local function ResetState(Authenticated)
	KeyValidator.Processing = false
	KeyValidator.Authenticated = Authenticated or false
	getgenv().Authenticated = Authenticated or false
end

local function ExecuteScript(Key)
	task.spawn(function()
		task.wait(0.5)
		ResetState(true)
		if Ui.KeySystem then pcall(Ui.KeySystem.Destroy, Ui.KeySystem) end
		script_key = Key
                getgenv().script_key = Key
		task.wait(0.2)
		local LoadSuccess, LoadError
		local ExecuteSuccess, ExecuteError = pcall(function()
			LoadSuccess, LoadError = LoadScript()
		end)
		if not ExecuteSuccess then
			warn("[Zenith]", "Script load crashed:", ExecuteError)
			SendNotification("Script Error", "Executor crash during load. Try another executor.", 7)
		elseif not LoadSuccess then
			warn("[Zenith]", "Script load error:", LoadError)
			SendNotification("Script Error", "Failed to load script.", 5)
		end
	end)
end

local function HandleKeyResponse(Status, Key)
	if not Status or not Status.code then
		ResetState(false)
		SetSubmitText("Unknown Error!", 2)
		return
	end

	if Status.code == "KEY_VALID" then
		pcall(writefile, "Zenith Key.txt", Key)
		SetSubmitText("Valid Key!")
		ExecuteScript(Key)
	elseif Status.code == "KEY_HWID_LOCKED" then
		UiUpdate(KeyInput, "Text", "Key linked to different HWID!")
		ResetState(false)
		task.wait(2)
		UiUpdate(KeyInput, "Text", Key)
		SetSubmitText("Submit Key >")
	elseif Status.code == "KEY_INVALID" then
		ResetState(false)
		SetSubmitText("Invalid Key!", 1.5)
	else
		ResetState(false)
		SetSubmitText("Error: " .. tostring(Status.code), 2)
	end
end

local function ValidateKey()
	KeyValidator.Processing = true

	local Resolved = false

	local ValidationSuccess, ValidationError = pcall(function()
		if not SubmitBtn or not SubmitBtn.Parent then
			KeyValidator.Processing = false
			return
		end

		SetSubmitText("Checking Key..")
		local Key = TrimWhitespace(KeyInput.Text)

		if #Key == 0 then
			ResetState(false)
			SetSubmitText("Please enter a key!", 2)
			return
		end

		if Key:find("[\128-\255]") then
			ResetState(false)
			SetSubmitText("Invalid key format!", 2)
			return
		end

		script_key = Key
                getgenv().script_key = Key

		local Timeout = task.delay(15, function()
			if Resolved then return end
			Resolved = true
			ResetState(false)
			SetSubmitText("Timeout! Try again", 2)
		end)

		local Status
		local ApiSuccess = pcall(function() Status = Api.check_key(Key) end)

		Resolved = true
		pcall(task.cancel, Timeout)

		if not ApiSuccess or not Status then
			ResetState(false)
			SetSubmitText("API Error! Try again", 2)
			return
		end

		HandleKeyResponse(Status, Key)
	end)

	if not ValidationSuccess then
		Resolved = true
		ResetState(false)
		warn("[Zenith]", "Key validation error:", ValidationError)
		SetSubmitText("Error! Try again", 2)
	end
end

SubmitBtn.MouseButton1Click:Connect(function()
	pcall(ValidateKey)
end)

if Auth.Error and SubmitBtn then
	SetSubmitText(Auth.Error, 3)
end