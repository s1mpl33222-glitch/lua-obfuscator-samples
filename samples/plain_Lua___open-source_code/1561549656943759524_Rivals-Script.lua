--- @thelastcoowner (PhynnCheats) on Discord

-- Also Known as LV Deobfuscation 
-- Powered by: Luraph v15
-- Local names are inferred from use (the original names are not in the bytecode)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
game:GetService("TweenService")
game:GetService("VirtualInputManager")
local localPlayer = Players.LocalPlayer
local currentCamera = workspace.CurrentCamera
localPlayer:GetMouse()

local tbl = {
	ESPEnabled = false,
	ESPLoaded = false,
	CharmsEnabled = false,
	CharmsLoaded = false,
	CharmsConnectionsSetup = false,
	infJumpEnabled = false,
	infJumpConn = nil,
	NoSmokeEnabled = false,
	NoSmokeConnection = nil,
	noclipEnabled = false,
	noclipConnection = nil,
	BunnyHopEnabled = false,
	FastMeleeEnabled = false,
	AntiKatanaEnabled = false,
	AntiKatanaLoaded = false,
	SilentAimEnabled = false,
	SilentAimLoaded = false,
	FOVCircleEnabled = false,
	ShowFOV = true,
	Filled = false,
	FOVRadius = 130,
	HitPart = "Head",
	AimPart = "HumanoidRootPart",
	WallCheck = false,
	MaxDistance = 1000,
	ESPColorR = 255,
	ESPColorG = 255,
	ESPColorB = 255,
	BoxESPColorR = 255,
	BoxESPColorG = 0,
	BoxESPColorB = 170,
	DeviceSpooferEnabled = false,
	DeviceType = "PC",
	Speed = 1,
	FireRate = "Normal",
	ScaleEditing = false,
	CurrentTheme = "None",
	AimAssistEnabled = false,
	AimFOV = 150,
	AimSmooth = 5,
	AimTargetPart = "Head",
	CamRemoteEnabled = false,
	ClearBlockers = false,
	LockOnEnabled = false,
	LockSpeed = 10,
	LockTargetPart = "Head",
}

local tbl2 = { level_spoof = false, spoofed_level = 1, winstreak_spoof = false, spoofed_winstreak = 1 }
local tbl3 = { "Community Staff", "Tester", "Moderator", "Contributor", "Scripter", "Builder" }
local color = Color3.fromRGB(59, 130, 246)
local color2 = Color3.fromRGB(14, 14, 18)
local color3 = Color3.fromRGB(30, 30, 35)
local color4 = Color3.fromRGB(38, 38, 45)
local color5 = Color3.fromRGB(255, 255, 255)
local color6 = Color3.fromRGB(175, 175, 185)

local tbl4 = {
	discord = "https://discord.gg/firehub",
	youtube = "https://www.youtube.com/@Firehub_yt",
	skinChanger = "https://raw.githubusercontent.com/tiggy48/Skinchangerbyegg/refs/heads/main/Gulb",
	wrapperChanger = "",
	charmChanger = "",
	espScript = "https://pastebin.com/raw/KHuXUnd9",
	noLagScript = "https://pastebin.com/raw/8KaSvXik",
}

local function fn(arg, arg2, arg3)
	local n = arg3 or 6

	pcall(function()
		StarterGui:SetCore("SendNotification", { Title = arg, Text = arg2, Duration = n })
	end)
end

local function fn2(arg)
	pcall(function()
		if setclipboard then
			setclipboard(arg)
		end
	end)
end

local function fn3(arg, arg2, arg3)
	return Color3.fromRGB(arg, arg2, arg3)
end

if not table.find then
	table.find = function(arg, arg2)
		for i, v in ipairs(arg) do
			if v == arg2 then
				return i
			end
		end

		return nil
	end
end

if not math.clamp then
	math.clamp = function(arg, arg2, arg3)
		if arg < arg2 then
			return arg2
		end

		if arg3 < arg then
			return arg3
		end
		return arg
	end
end

if not task then
	task = {}
	task.wait = wait
	task.delay = delay
	task.spawn = spawn
end

if not Enum.AutomaticSize then
	Enum.AutomaticSize = { Y = 2, X = 1, XY = 3, None = 0 }
end

local tbl5 = {
	None = {
		bg = color2,
		tab = color3,
		button = color4,
		titleBar = fn3(22, 22, 28),
		profile = fn3(26, 26, 32),
		accent = color,
		text = color5,
		textGray = color6,
	},
	Purple = {
		bg = fn3(20, 10, 30),
		tab = fn3(40, 20, 60),
		button = fn3(50, 25, 75),
		titleBar = fn3(30, 15, 45),
		profile = fn3(35, 18, 55),
		accent = fn3(180, 100, 255),
		text = fn3(255, 255, 255),
		textGray = fn3(200, 180, 220),
	},
	Green = {
		bg = fn3(10, 20, 15),
		tab = fn3(20, 40, 30),
		button = fn3(25, 50, 38),
		titleBar = fn3(15, 30, 22),
		profile = fn3(18, 35, 26),
		accent = fn3(100, 255, 150),
		text = fn3(255, 255, 255),
		textGray = fn3(180, 220, 195),
	},
	Red = {
		bg = fn3(30, 10, 10),
		tab = fn3(60, 20, 20),
		button = fn3(75, 25, 25),
		titleBar = fn3(45, 15, 15),
		profile = fn3(55, 18, 18),
		accent = fn3(255, 80, 80),
		text = fn3(255, 255, 255),
		textGray = fn3(220, 180, 180),
	},
	Gold = {
		bg = fn3(25, 20, 5),
		tab = fn3(50, 40, 10),
		button = fn3(60, 50, 12),
		titleBar = fn3(35, 28, 8),
		profile = fn3(40, 32, 10),
		accent = fn3(255, 200, 60),
		text = fn3(255, 255, 255),
		textGray = fn3(220, 210, 180),
	},
}

local tbl6 = {
	Default = { image = "", enabled = false },
	Earth = { image = "rbxassetid://138773479333969", enabled = false },
	Flower = { image = "rbxassetid://83871986054823", enabled = false },
	["Leaf Water-drop"] = { image = "rbxassetid://87736766990771", enabled = false },
}

local str = "None"
local str2 = "Default"
local ImageLabel = nil

local function fn4(currentTheme, arg)
	local v = tbl5[currentTheme]
	if not v then
		return
	end
	local main = arg:FindFirstChild("Main")
	if not main then
		return
	end

	if ImageLabel then
		ImageLabel.Visible = false
	end

	str2 = "Default"
	main.BackgroundColor3 = v.bg
	local titleBar = main:FindFirstChild("TitleBar")

	if titleBar then
		titleBar.BackgroundColor3 = v.titleBar
	end

	local tabs = main:FindFirstChild("Tabs")

	if tabs then
		for _, child in ipairs(tabs:GetChildren()) do
			if child:IsA("TextButton") then
				if child.TextColor3 == color5 or child:GetAttribute("IsActiveTab") == true then
					child.BackgroundColor3 = v.accent
					child.TextColor3 = v.text
				else
					child.BackgroundColor3 = v.tab
					child.TextColor3 = v.textGray
				end
			end
		end
	end

	local separator = main:FindFirstChild("Separator")

	if separator then
		separator.BackgroundColor3 = fn3(60, 60, 70)
	end

	local v2 = ipairs
	local content = main:FindFirstChild("Content")

	for _, child in v2(content:GetChildren()) do
		if child:IsA("ScrollingFrame") then
			for _, child2 in ipairs(child:GetChildren()) do
				if child2:IsA("TextButton") and child2.Name ~= "Save Scale" and child2:GetAttribute("FixedColor") ~= true then
					local text = child2.Text

					if text:match("%[ON%]") then
						child2.BackgroundColor3 = v.accent
						child2.TextColor3 = v.text
					elseif text:match("%[OFF%]") then
						child2.BackgroundColor3 = v.button
						child2.TextColor3 = v.textGray
					else
						child2.BackgroundColor3 = v.button
						child2.TextColor3 = v.text
					end
				elseif child2:IsA("TextBox") then
					child2.BackgroundColor3 = v.button
					child2.TextColor3 = v.text
				elseif child2:IsA("TextLabel") then
					child2.TextColor3 = v.text
				end
			end
		end
	end

	tabs = tabs and tabs:FindFirstChild("ProfileCard")

	if tabs then
		tabs.BackgroundColor3 = v.profile
	end

	str = currentTheme
	tbl.CurrentTheme = currentTheme
end

local function fn5(arg, arg2)
	local v = tbl6[arg]
	if not v then
		return
	end
	local main = arg2:FindFirstChild("Main")
	if not main then
		return
	end
	fn4("None", arg2)
	str = "None"

	if arg == "Default" then
		main.BackgroundColor3 = tbl5.None.bg

		if ImageLabel then
			ImageLabel.Visible = false
		end
	else
		main.BackgroundColor3 = fn3(40, 40, 50)

		if ImageLabel then
			ImageLabel.Image = v.image
			ImageLabel.Visible = true
		end
	end

	str2 = arg
end

local function fn6(arg, arg2)
	local instance = Instance.new(arg)
	local v = pairs
	local tbl7 = arg2 or {}

	for k, v2 in v(tbl7) do
		instance[k] = v2
	end

	local isGuiObject = instance:IsA("GuiObject")

	if isGuiObject then
		isGuiObject = not (arg2 or {}).ZIndex
	end

	if isGuiObject then
		instance.ZIndex = 12
	end

	return instance
end

local function fn7(arg, parent)
	local UICorner = fn6("UICorner", { CornerRadius = UDim.new(0, arg or 8) })
	UICorner.Parent = parent
	return UICorner
end

local function fn8(parent, arg, arg2)
	local UIListLayout = fn6("UIListLayout", {
		SortOrder = arg2 or Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, arg or 5),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
	})

	UIListLayout.Parent = parent
	return UIListLayout
end

local function fn9(arg, arg2, arg3, arg4, arg5)
	local color7, v, n = Color3.toHSV(arg2)
	local flag = false
	local flag2 = false

	local Frame = fn6("Frame", {
		Name = arg5:gsub("%s+", ""),
		Size = UDim2.new(1, -6, 0, 30),
		BackgroundTransparency = 1,
		LayoutOrder = arg4 or 0,
		ClipsDescendants = true,
		Parent = arg,
	})

	fn7(8, Frame)

	local TextButton = fn6("TextButton", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = color4,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "  " .. arg5 .. "  v",
		TextColor3 = color6,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.GothamBold,
		Parent = Frame,
	})

	fn7(8, TextButton)

	local Frame2 = fn6("Frame", {
		Size = UDim2.new(1, -8, 0, 190),
		Position = UDim2.new(0, 4, 0, 36),
		BackgroundColor3 = fn3(20, 20, 25),
		BorderSizePixel = 0,
		Visible = false,
		Parent = Frame,
	})

	fn7(8, Frame2)

	local Frame3 = fn6("Frame", {
		Size = UDim2.new(1, -8, 0, 130),
		Position = UDim2.new(0, 4, 0, 4),
		BackgroundColor3 = Color3.fromHSV(color7, 1, 1),
		BorderSizePixel = 0,
		Active = true,
		Parent = Frame2,
	})

	fn7(6, Frame3)
	local Frame4 = fn6("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = Frame3 })
	local color8 = Color3.new

	fn6("UIGradient", {
		Color = ColorSequence.new(Color3.new(1, 1, 1), color8(1, 1, 1)),
		Transparency = NumberSequence.new(0, 1),
		Parent = Frame4,
	})

	local Frame5 = fn6("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = Frame3 })
	local color9 = Color3.new

	fn6("UIGradient", {
		Color = ColorSequence.new(Color3.new(0, 0, 0), color9(0, 0, 0)),
		Transparency = NumberSequence.new(1, 0),
		Rotation = -90,
		Parent = Frame5,
	})

	local Frame6 = fn6("Frame", {
		Size = UDim2.new(0, 14, 0, 14),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		ZIndex = 15,
		Parent = Frame3,
	})

	fn7(7, Frame6)

	local Frame7 = fn6("Frame", {
		Size = UDim2.new(0, 8, 0, 8),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundColor3 = arg2,
		BorderSizePixel = 0,
		ZIndex = 16,
		Parent = Frame6,
	})

	fn7(4, Frame7)

	local Frame8 = fn6("Frame", {
		Size = UDim2.new(1, -8, 0, 10),
		Position = UDim2.new(0, 4, 0, 142),
		BackgroundColor3 = color5,
		BorderSizePixel = 0,
		Active = true,
		Parent = Frame2,
	})

	fn7(5, Frame8)
	local v2 = fn6
	local tbl7 = {}
	local colorSequence = ColorSequence.new
	local tbl8 = {}
	local v3 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0))
	local v4 = ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0))
	local v5 = ColorSequenceKeypoint.new(0.34, Color3.fromRGB(0, 255, 0))
	local v6 = ColorSequenceKeypoint.new(0.51, Color3.fromRGB(0, 255, 255))
	local v7 = ColorSequenceKeypoint.new(0.68, Color3.fromRGB(0, 0, 255))
	local v8 = ColorSequenceKeypoint.new(0.85, Color3.fromRGB(255, 0, 255))
	tbl8[1] = v3
	tbl8[2] = v4
	tbl8[3] = v5
	tbl8[4] = v6
	tbl8[5] = v7
	tbl8[6] = v8

	do
		local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)))
		table.move(values, 1, values.n, 7, tbl8)
	end

	tbl7.Color = colorSequence(tbl8)
	tbl7.Parent = Frame8
	v2("UIGradient", tbl7)

	local Frame9 = fn6("Frame", {
		Size = UDim2.new(0, 16, 0, 16),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromHSV(color7, 1, 1),
		BorderSizePixel = 0,
		ZIndex = 14,
		Parent = Frame8,
	})

	fn7(8, Frame9)

	local function fn10()
		local color10 = Color3.fromHSV(color7, v, n)
		Frame3.BackgroundColor3 = Color3.fromHSV(color7, 1, 1)
		Frame6.Position = UDim2.new(v, 0, 1 - n, 0)
		Frame7.BackgroundColor3 = color10
		Frame9.Position = UDim2.new(color7, 0, 0.5, 0)
		Frame9.BackgroundColor3 = Color3.fromHSV(color7, 1, 1)
		arg3(color10)
	end

	local function fn11(arg6)
		local position = arg6.Position
		local n2 = math.clamp((position.X - Frame3.AbsolutePosition.X) / Frame3.AbsoluteSize.X, 0, 1)
		local n3 = math.clamp((position.Y - Frame3.AbsolutePosition.Y) / Frame3.AbsoluteSize.Y, 0, 1)
		v = n2
		n = 1 - n3
		fn10()
	end

	local function fn12(arg6)
		color7 = math.clamp((arg6.Position.X - Frame8.AbsolutePosition.X) / Frame8.AbsoluteSize.X, 0, 1)
		fn10()
	end

	Frame3.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag = true
			fn11(input)
		end
	end)

	Frame8.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag2 = true
			fn12(input)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if flag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			fn11(input)
		elseif flag2 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			fn12(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag = false
			flag2 = false
		end
	end)

	TextButton.MouseButton1Click:Connect(function()
		Frame2.Visible = not Frame2.Visible
		Frame.Size = UDim2.new(1, -6, 0, Frame2.Visible and 232 or 30)
		TextButton.Text = "  " .. arg5 .. (Frame2.Visible and "  ^" or "  v")
	end)

	fn10()
	return Frame
end

local function fn10()
	local fireHubRivalsScript = game.CoreGui:FindFirstChild("FIRE_HUB_RIVALS_SCRIPT")

	if fireHubRivalsScript then
		fireHubRivalsScript:Destroy()
	end

	local ScreenGui = fn6("ScreenGui", {
		Name = "FIRE_HUB_RIVALS_SCRIPT",
		Parent = game.CoreGui,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		IgnoreGuiInset = true,
	})

	MainGui = ScreenGui

	local Frame = fn6("Frame", {
		Name = "Main",
		Size = UDim2.new(0, 420, 0, 300),
		Position = UDim2.new(0.5, -210, 0.5, -150),
		BackgroundColor3 = color2,
		BorderSizePixel = 0,
		Active = true,
		Draggable = false,
		ClipsDescendants = true,
		ZIndex = 10,
		Parent = ScreenGui,
	})

	fn7(16, Frame)

	ImageLabel = fn6("ImageLabel", {
		Name = "ThemeBackground",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = fn3(180, 40, 40),
		BackgroundTransparency = 0,
		Image = "",
		ImageColor3 = fn3(255, 255, 255),
		ImageTransparency = 0,
		ScaleType = Enum.ScaleType.Crop,
		ZIndex = 11,
		Visible = false,
		Parent = Frame,
	})

	fn7(16, ImageLabel)

	local TextButton = fn6("TextButton", {
		Name = "MinimizedBar",
		Size = UDim2.new(0, 120, 0, 28),
		Position = Frame.Position,
		BackgroundColor3 = color2,
		BorderSizePixel = 0,
		Text = "",
		Visible = false,
		AutoButtonColor = false,
		Active = true,
		Draggable = false,
		ZIndex = 10,
		Parent = ScreenGui,
	})

	fn7(8, TextButton)

	fn6("TextLabel", {
		Name = "MinText",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "FIRE HUB",
		TextColor3 = color5,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		ZIndex = 11,
		Parent = TextButton,
	})

	local flag = false
	local vector2 = Vector2.new(0, 0)
	local vector22 = Vector2.new(0, 0)

	TextButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag = true
			vector2 = Vector2.new(input.Position.X, input.Position.Y) - Vector2.new(TextButton.AbsolutePosition.X, TextButton.AbsolutePosition.Y)
			vector22 = Vector2.new(input.Position.X, input.Position.Y)
		end
	end)

	TextButton.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if flag then
				flag = false

				if (Vector2.new(input.Position.X, input.Position.Y) - vector22).Magnitude < 8 then
					tbl.IsMinimized = false
					TextButton.Visible = false
					Frame.Visible = true
					local attribute = Frame:GetAttribute("PreMinimizeWidth") or Frame:GetAttribute("SavedWidth") or 420
					local attribute2 = Frame:GetAttribute("PreMinimizeHeight") or Frame:GetAttribute("SavedHeight") or 300
					Frame.Position = UDim2.new(Frame.Position.X.Scale, Frame:GetAttribute("SavedPosX") or Frame.Position.X.Offset, Frame.Position.Y.Scale, Frame:GetAttribute("SavedPosY") or Frame.Position.Y.Offset)
					Frame.Size = UDim2.new(0, attribute, 0, attribute2)
				end
			end
		end
	end)

	RunService.RenderStepped:Connect(function()
		if flag then
			local mouseLocation = UserInputService:GetMouseLocation()
			TextButton.Position = UDim2.new(0, mouseLocation.X - vector2.X, 0, mouseLocation.Y - vector2.Y)
		end
	end)

	local Frame2 = fn6("Frame", {
		Name = "TitleBar",
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundColor3 = fn3(22, 22, 28),
		BorderSizePixel = 0,
		ZIndex = 11,
		Parent = Frame,
	})

	fn7(16, Frame2)
	local flag2 = false
	local vector23 = Vector2.new(0, 0)

	Frame2.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag2 = true
			vector23 = Vector2.new(input.Position.X, input.Position.Y) - Vector2.new(Frame.AbsolutePosition.X, Frame.AbsolutePosition.Y)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if flag2 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local mouseLocation = UserInputService:GetMouseLocation()
			Frame.Position = UDim2.new(0, mouseLocation.X - vector23.X, 0, mouseLocation.Y - vector23.Y)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag2 = false
		end
	end)

	local ImageLabel2 = fn6("ImageLabel", {
		Name = "Logo",
		Size = UDim2.new(0, 28, 0, 28),
		Position = UDim2.new(0, 10, 0, 5),
		BackgroundTransparency = 1,
		Image = "rbxassetid://0",
		ImageColor3 = color,
		ZIndex = 13,
		Parent = Frame2,
	})

	fn7(8, ImageLabel2)

	fn6("TextLabel", {
		Name = "Title",
		Size = UDim2.new(1, -110, 1, 0),
		Position = UDim2.new(0, 44, 0, 0),
		BackgroundTransparency = 1,
		Text = "Fire Hub Rivals Script",
		TextColor3 = color5,
		TextSize = 13,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 12,
		Parent = Frame2,
	})

	local TextButton2 = fn6("TextButton", {
		Name = "Minimize",
		Size = UDim2.new(0, 28, 0, 28),
		Position = UDim2.new(1, -60, 0, 5),
		BackgroundTransparency = 1,
		Text = "-",
		TextColor3 = fn3(255, 200, 60),
		TextSize = 18,
		Font = Enum.Font.GothamBold,
		Parent = Frame2,
	})

	tbl.IsMinimized = false
	local size = Frame.Size
	Frame:SetAttribute("SavedWidth", size.X.Offset)
	Frame:SetAttribute("SavedHeight", size.Y.Offset)

	TextButton2.MouseButton1Click:Connect(function()
		if tbl.ScaleEditing then
			fn("Fire Hub Rivals Script", "please save gui before clicking on other tabs nuub", 3)
			return
		end
		tbl.IsMinimized = not tbl.IsMinimized

		if tbl.IsMinimized then
			Frame:SetAttribute("PreMinimizeWidth", Frame.Size.X.Offset)
			Frame:SetAttribute("PreMinimizeHeight", Frame.Size.Y.Offset)
			Frame:SetAttribute("SavedPosX", Frame.Position.X.Offset)
			Frame:SetAttribute("SavedPosY", Frame.Position.Y.Offset)
			TextButton.Visible = true
			Frame.Visible = false

			if showScaleHandles then
				showScaleHandles(false)
			end

			if editScaleBtn then
				editScaleBtn.Text = "Edit Scale"
			end
		end
	end)

	fn6("TextButton", {
		Name = "Close",
		Size = UDim2.new(0, 28, 0, 28),
		Position = UDim2.new(1, -32, 0, 5),
		BackgroundTransparency = 1,
		Text = "X",
		TextColor3 = fn3(255, 80, 80),
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		Parent = Frame2,
	}).MouseButton1Click:Connect(function()
		if tbl.ScaleEditing then
			fn("Fire Hub Rivals Script", "please save gui before clicking on other tabs nuub", 3)
			return
		end
		ScreenGui:Destroy()
	end)

	local ScrollingFrame = fn6("ScrollingFrame", {
		Name = "Tabs",
		Size = UDim2.new(0, 120, 1, -46),
		Position = UDim2.new(0, 8, 0, 42),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		AutomaticCanvasSize = 2,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ZIndex = 11,
		Parent = Frame,
	})

	local center = Enum.HorizontalAlignment.Center
	fn8(ScrollingFrame, 4).HorizontalAlignment = center

	fn6("UIPadding", {
		PaddingTop = UDim.new(0, 2),
		PaddingBottom = UDim.new(0, 2),
		PaddingLeft = UDim.new(0, 0),
		PaddingRight = UDim.new(0, 0),
		Parent = ScrollingFrame,
	})

	local Frame3 = fn6("Frame", {
		Name = "Separator",
		Size = UDim2.new(0, 1, 1, -54),
		Position = UDim2.new(0, 132, 0, 46),
		BackgroundColor3 = fn3(60, 60, 70),
		BorderSizePixel = 0,
		ZIndex = 11,
		Parent = Frame,
	})

	fn7(1, Frame3)

	local Frame4 = fn6("Frame", {
		Name = "Content",
		Size = UDim2.new(1, -148, 1, -50),
		Position = UDim2.new(0, 140, 0, 46),
		BackgroundTransparency = 1,
		ZIndex = 11,
		Parent = Frame,
	})

	local tbl7 = {}

	local function fn11(arg)
		local ScrollingFrame2 = fn6("ScrollingFrame", {
			Name = arg,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			ScrollBarThickness = 0,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			AutomaticCanvasSize = 2,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			Visible = false,
			Parent = Frame4,
		})

		fn8(ScrollingFrame2, 5)
		tbl7[arg] = ScrollingFrame2
		return ScrollingFrame2
	end

	local Main = fn11("Main", 1)
	local Combat = fn11("Combat", 2)
	local Visual = fn11("Visual", 3)
	local Misc = fn11("Misc", 4)
	local Spoofer = fn11("Spoofer", 5)
	local Players2 = fn11("Players", 6)
	local Credits = fn11("Credits", 7)
	local Settings = fn11("Settings", 8)
	local tbl8 = {}

	for i, v in ipairs({ "Main", "Combat", "Visual", "Misc", "Spoofer", "Players", "Credits", "Settings" }) do
		local TextButton3 = fn6("TextButton", {
			Size = UDim2.new(1, -8, 0, 28),
			BackgroundColor3 = color3,
			BorderSizePixel = 0,
			Text = v,
			TextColor3 = color6,
			TextSize = 12,
			Font = Enum.Font.GothamBold,
			LayoutOrder = i,
			ZIndex = 12,
			Parent = ScrollingFrame,
		})

		fn7(10, TextButton3)
		tbl8[v] = TextButton3

		TextButton3.MouseButton1Click:Connect(function()
			if tbl.ScaleEditing then
				fn("Fire Hub Rivals Script", "please save gui before clicking on other tabs nuub", 3)
				return
			end

			for _, v2 in pairs(tbl7) do
				v2.Visible = false
			end

			tbl7[v].Visible = true

			for _, v2 in pairs(tbl8) do
				v2:SetAttribute("IsActiveTab", false)
				local none = tbl5[str] or tbl5.None
				v2.BackgroundColor3 = none.tab
				v2.TextColor3 = none.textGray
			end

			TextButton3:SetAttribute("IsActiveTab", true)
			local none = tbl5[str] or tbl5.None
			TextButton3.BackgroundColor3 = none.accent
			TextButton3.TextColor3 = none.text
		end)
	end

	local Frame5 = fn6("Frame", {
		Name = "ProfileCard",
		Size = UDim2.new(1, -8, 0, 52),
		BackgroundColor3 = fn3(26, 26, 32),
		BorderSizePixel = 0,
		LayoutOrder = 99,
		ZIndex = 12,
		Parent = ScrollingFrame,
	})

	fn7(10, Frame5)

	local ImageLabel3 = fn6("ImageLabel", {
		Name = "Avatar",
		Size = UDim2.new(0, 30, 0, 30),
		Position = UDim2.new(0, 6, 0, 5),
		BackgroundColor3 = fn3(40, 40, 50),
		BackgroundTransparency = 0,
		Image = "rbxthumb://type=AvatarHeadShot&id=" .. localPlayer.UserId .. "&w=150&h=150",
		ZIndex = 13,
		Parent = Frame5,
	})

	fn7(15, ImageLabel3)

	fn6("TextLabel", {
		Size = UDim2.new(1, -44, 0, 13),
		Position = UDim2.new(0, 42, 0, 5),
		BackgroundTransparency = 1,
		Text = localPlayer.Name,
		TextColor3 = color5,
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 13,
		Parent = Frame5,
	})

	fn6("TextLabel", {
		Size = UDim2.new(1, -44, 0, 11),
		Position = UDim2.new(0, 42, 0, 19),
		BackgroundTransparency = 1,
		Text = "@" .. localPlayer.DisplayName,
		TextColor3 = fn3(145, 155, 175),
		TextSize = 9,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 13,
		Parent = Frame5,
	})

	local TextLabel = fn6("TextLabel", {
		Size = UDim2.new(1, -12, 0, 11),
		Position = UDim2.new(0, 6, 0, 38),
		BackgroundTransparency = 1,
		Text = "FPS: ...",
		TextColor3 = fn3(120, 255, 180),
		TextSize = 9,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 13,
		Parent = Frame5,
	})

	local n = 0
	local now = os.clock()

	RunService.RenderStepped:Connect(function()
		if not TextLabel.Parent then
			return
		end
		n += 1
		local n2 = os.clock() - now

		if n2 >= 1 then
			TextLabel.Text = "FPS: " .. tostring(math.floor(n / n2))
			local now2 = os.clock()
			n = 0
			now = now2
		end
	end)

	tbl7.Main.Visible = true
	tbl8.Main.BackgroundColor3 = color
	tbl8.Main.TextColor3 = color5
	return ScreenGui, { Main, Combat, Visual, Misc, Spoofer, Players2, Credits, Settings, Frame }
end

local vector2 = Vector2.new(420, 300)

local function fn11(arg)
	for _, descendant in ipairs(arg:GetDescendants()) do
		if descendant:IsA("GuiObject") and descendant.Name ~= "Main" and descendant.Name ~= "EditOverlay" then
			if not descendant:GetAttribute("BaseSizeXOffset") then
				descendant:SetAttribute("BaseSizeXOffset", descendant.Size.X.Offset)
				descendant:SetAttribute("BaseSizeYOffset", descendant.Size.Y.Offset)
			end

			if not descendant:GetAttribute("BasePosXOffset") then
				descendant:SetAttribute("BasePosXOffset", descendant.Position.X.Offset)
				descendant:SetAttribute("BasePosYOffset", descendant.Position.Y.Offset)
			end
		end

		if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
			if not descendant:GetAttribute("BaseTextSize") then
				descendant:SetAttribute("BaseTextSize", descendant.TextSize)
			end
		end

		if descendant:IsA("UIListLayout") then
			if not descendant:GetAttribute("BasePadding") then
				descendant:SetAttribute("BasePadding", descendant.Padding.Offset)
			end
		end

		if descendant:IsA("UIPadding") then
			for k, v in pairs({
				PaddingTop = "BasePadTop",
				PaddingBottom = "BasePadBottom",
				PaddingLeft = "BasePadLeft",
				PaddingRight = "BasePadRight",
			}) do
				if not descendant:GetAttribute(v) then
					descendant:SetAttribute(v, descendant[k].Offset)
				end
			end
		end

		for _, child in ipairs(descendant:GetChildren()) do
			if child:IsA("UICorner") and not descendant:GetAttribute("BaseCornerRadius") then
				local cornerRadius = child.CornerRadius

				if cornerRadius.Scale == 0 then
					descendant:SetAttribute("BaseCornerRadius", cornerRadius.Offset)
				end
			end
		end
	end
end

local function fn12(arg, arg2)
	for _, descendant in ipairs(arg:GetDescendants()) do
		if descendant:IsA("GuiObject") and descendant.Name ~= "Main" and descendant.Name ~= "EditOverlay" then
			local attribute = descendant:GetAttribute("BaseSizeXOffset")
			local attribute2 = descendant:GetAttribute("BaseSizeYOffset")

			if attribute then
				local scale = descendant.Size.Y.Scale
				local floor = math.floor
				descendant.Size = UDim2.new(descendant.Size.X.Scale, math.floor(attribute * arg2 + 0.5), scale, floor(attribute2 * arg2 + 0.5))
			end

			local attribute3 = descendant:GetAttribute("BasePosXOffset")
			local attribute4 = descendant:GetAttribute("BasePosYOffset")

			if attribute3 then
				local scale = descendant.Position.Y.Scale
				local floor = math.floor
				descendant.Position = UDim2.new(descendant.Position.X.Scale, math.floor(attribute3 * arg2 + 0.5), scale, floor(attribute4 * arg2 + 0.5))
			end
		end

		if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
			local attribute = descendant:GetAttribute("BaseTextSize")

			if attribute then
				descendant.TextSize = math.max(1, math.floor(attribute * arg2 + 0.5))
			end
		end

		if descendant:IsA("UIListLayout") then
			local attribute = descendant:GetAttribute("BasePadding")

			if attribute then
				descendant.Padding = UDim.new(0, math.max(0, math.floor(attribute * arg2 + 0.5)))
			end
		end

		if descendant:IsA("UIPadding") then
			for k, v in pairs({
				PaddingTop = "BasePadTop",
				PaddingBottom = "BasePadBottom",
				PaddingLeft = "BasePadLeft",
				PaddingRight = "BasePadRight",
			}) do
				local attribute = descendant:GetAttribute(v)

				if attribute then
					descendant[k] = UDim.new(0, math.max(0, math.floor(attribute * arg2 + 0.5)))
				end
			end
		end

		local attribute = descendant:GetAttribute("BaseCornerRadius")

		if attribute then
			for _, child in ipairs(descendant:GetChildren()) do
				if child:IsA("UICorner") then
					child.CornerRadius = UDim.new(0, math.max(0, math.floor(attribute * arg2 + 0.5)))
				end
			end
		end
	end
end

local function fn13(arg)
	return (arg.Size.X.Offset / vector2.X + arg.Size.Y.Offset / vector2.Y) / 2
end

local function fn14(arg, arg2, arg3, arg4)
	local TextButton = fn6("TextButton", {
		Size = UDim2.new(1, -6, 0, 26),
		BackgroundColor3 = color4,
		BorderSizePixel = 0,
		Text = arg2 .. " [OFF]",
		TextColor3 = color6,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		LayoutOrder = arg4 or 0,
		Parent = arg,
	})

	fn7(8, TextButton)
	local flag = false

	TextButton.MouseButton1Click:Connect(function()
		flag = not flag
		local none = tbl5[str] or tbl5.None

		if flag then
			TextButton.Text = arg2 .. " [ON]"
			TextButton.BackgroundColor3 = none.accent
			TextButton.TextColor3 = none.text
		else
			TextButton.Text = arg2 .. " [OFF]"
			TextButton.BackgroundColor3 = none.button
			TextButton.TextColor3 = none.textGray
		end

		arg3(flag)
	end)

	return TextButton
end

local circle = nil
local raycast = nil

local function fn15(arg)
	if not currentCamera then
		return false
	end
	local position = currentCamera.CFrame.Position
	local n = arg.Position - position
	local raycastParams = RaycastParams.new()
	local filterDescendantsInstances = {}

	if localPlayer.Character then
		table.insert(filterDescendantsInstances, localPlayer.Character)
	end

	if arg.Parent then
		table.insert(filterDescendantsInstances, arg.Parent)
	end

	raycastParams.FilterDescendantsInstances = filterDescendantsInstances
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.IgnoreWater = true
	return workspace:Raycast(position, n, raycastParams) == nil
end

local function fn16()
	local vector22 = Vector2.new(currentCamera.ViewportSize.X / 2, currentCamera.ViewportSize.Y / 2)
	local fovRadius = tbl.FOVRadius
	local hitPart = tbl.HitPart

	if hitPart == "Torso" then
		hitPart = "HumanoidRootPart"
	end

	local v = nil

	for _, v2 in CollectionService:GetTagged("Entity") do
		if v2 ~= localPlayer.Character then
			local v3 = v2:FindFirstChild(hitPart, true)

			if not (not v3 or not v3:IsA("BasePart")) then
				if not (tbl.WallCheck and not fn15(v3)) then
					local v4, v5 = currentCamera:WorldToViewportPoint(v3.Position)

					if v5 then
						local magnitude = (vector22 - Vector2.new(v4.X, v4.Y)).Magnitude

						if magnitude < fovRadius then
							fovRadius = magnitude
							v = v3
						end
					end
				end
			end
		end
	end

	return v
end

local function fn17()
	if tbl.SilentAimLoaded then
		return
	end
	tbl.SilentAimLoaded = true
	circle = Drawing.new("Circle")
	circle.Visible = false
	circle.Filled = false
	circle.Radius = tbl.FOVRadius
	circle.Color = fn3(255, 0, 0)
	circle.Thickness = 1
	circle.NumSides = 64
	circle.Position = Vector2.new(currentCamera.ViewportSize.X / 2, currentCamera.ViewportSize.Y / 2)
	local modules = ReplicatedStorage:FindFirstChild("Modules")
	modules = modules and modules:FindFirstChild("Utility")

	if modules and modules:IsA("ModuleScript") then
		local ok, result = pcall(require, modules)

		if ok and result and result.Raycast then
			raycast = result.Raycast

			result.Raycast = function(arg, arg2, arg3, arg4, arg5, arg6, arg7)
				if not tbl.SilentAimEnabled then
					return raycast(arg, arg2, arg3, arg4, arg5, arg6, arg7)
				end
				local v = fn16()
				if not v then
					return raycast(arg, arg2, arg3, arg4, arg5, arg6, arg7)
				end
				local position = v.Position
				local unit = (position - arg2).Unit
				local magnitude = (position - arg2).Magnitude

				if not (arg4 < magnitude) then
					arg4 = magnitude
				else
					position = arg2 + unit * arg4
				end

				return { Position = position, Distance = arg4, Instance = v, Material = v.Material, Normal = -unit }
			end
		end
	end

	if not raycast then
		raycast = workspace.Raycast

		workspace.Raycast = function(arg, arg2, arg3, arg4)
			if not tbl.SilentAimEnabled then
				return raycast(arg, arg2, arg3, arg4)
			end
			local v = fn16()
			if not v then
				return raycast(arg, arg2, arg3, arg4)
			end
			local position = v.Position
			local unit = (position - arg2).Unit
			local magnitude = (position - arg2).Magnitude
			local magnitude2 = arg3.Magnitude

			if not (magnitude2 < magnitude) then
				magnitude2 = magnitude
			else
				position = arg2 + unit * magnitude2
			end

			return { Position = position, Distance = magnitude2, Instance = v, Material = v.Material, Normal = -unit }
		end
	end

	RunService.RenderStepped:Connect(function()
		if circle then
			circle.Position = Vector2.new(currentCamera.ViewportSize.X / 2, currentCamera.ViewportSize.Y / 2)
			circle.Visible = tbl.SilentAimEnabled
			circle.Radius = tbl.FOVRadius
			circle.Filled = tbl.Filled
		end
	end)
end

local function fn18(arg)
	if arg > 0.7 then
		return Color3.new(0, 1, 0)
	end

	if arg > 0.3 then
		return Color3.new(1, 1, 0)
	end
	return Color3.new(1, 0, 0)
end

local function createTextLabel(arg, parent)
	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Name = "HealthDisplay"
	billboardGui.Size = UDim2.new(4, 0, 1, 0)
	billboardGui.StudsOffset = Vector3.new(0, 3, 0)
	billboardGui.AlwaysOnTop = true
	billboardGui.Parent = parent
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextScaled = true
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.TextStrokeTransparency = 0
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.Parent = billboardGui
	return textLabel
end

local function createHighlight(parent)
	local highlight = Instance.new("Highlight")
	highlight.Name = "HealthHighlight"
	highlight.FillTransparency = 0.8
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Parent = parent
	return highlight
end

local function fn19()
	if tbl.ESPLoaded then
		return
	end
	tbl.ESPLoaded = true

	local function fn20(arg)
		if arg == localPlayer then
			return
		end
		local v = nil
		local v2 = nil
		local connection = nil
		local connection2 = nil
		local flag = true

		local function fn21()
			flag = false

			if connection then
				connection:Disconnect()
				connection = nil
			end

			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end

			if v and v.Parent then
				v.Parent:Destroy()
				v = nil
			end

			if v2 then
				v2:Destroy()
				v2 = nil
			end
		end

		local function fn22()
			local character = arg.Character

			if not character then
				if v then
					v.Text = "Dead"
					v.TextColor3 = Color3.new(1, 1, 1)
				end

				if v2 then
					v2:Destroy()
					v2 = nil
				end

				return
			end

			local humanoid = character:FindFirstChildOfClass("Humanoid")

			if not humanoid then
				if v then
					v.Text = "No Humanoid"
					v.TextColor3 = Color3.new(1, 1, 1)
				end

				if v2 then
					v2:Destroy()
					v2 = nil
				end

				return
			end

			local n = math.floor(humanoid.Health)
			local v3 = fn18(humanoid.Health / humanoid.MaxHealth)

			if v then
				v.Text = tostring(n)
				v.TextColor3 = v3
			end

			if v2 then
				v2.FillColor = v3
				v2.OutlineColor = v3
			end
		end

		task.spawn(function()
			while flag and arg.Parent do
				if tbl.ESPEnabled then
					fn22()
				end

				task.wait(1)
			end
		end)

		local function fn23(character)
			fn21()
			flag = true
			local head

			repeat
				task.wait(0.1)
				if not character or not character.Parent then
					return
				end
				head = character:FindFirstChild("Head")
			until head

			v = createTextLabel(arg, head)
			v2 = createHighlight(character)
			local humanoid = character:WaitForChild("Humanoid")

			connection = humanoid.HealthChanged:Connect(function()
				if tbl.ESPEnabled then
					fn22()
				end
			end)

			connection2 = humanoid.Died:Connect(function()
				if tbl.ESPEnabled then
					fn22()
				end
			end)

			if tbl.ESPEnabled then
				fn22()
			else
				if v and v.Parent then
					v.Parent.Enabled = false
				end

				if v2 then
					v2.Enabled = false
				end
			end
		end

		local connection3 = arg.CharacterAdded:Connect(fn23)

		if arg.Character then
			task.spawn(fn23, arg.Character)
		end

		arg.AncestryChanged:Connect(function(child, parent)
			if parent == nil then
				fn21()

				if connection3 then
					connection3:Disconnect()
				end
			end
		end)
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer then
			task.spawn(fn20, player)
		end
	end

	Players.PlayerAdded:Connect(function(player)
		if player ~= localPlayer then
			task.spawn(fn20, player)
		end
	end)
end

local function fn20(noclipEnabled)
	tbl.noclipEnabled = noclipEnabled

	if tbl.noclipConnection then
		tbl.noclipConnection:Disconnect()
		tbl.noclipConnection = nil
	end

	if noclipEnabled then
		tbl.noclipConnection = RunService.Stepped:Connect(function()
			local character = localPlayer.Character
			if not character then
				return
			end

			for _, descendant in ipairs(character:GetDescendants()) do
				if descendant:IsA("BasePart") then
					descendant.CanCollide = false
				end
			end
		end)

		fn("Fire Hub Rivals Script", "NoClip Enabled", 3)
	else
		fn("Fire Hub Rivals Script", "NoClip Disabled", 3)
	end
end

local function fn21(infJumpEnabled)
	tbl.infJumpEnabled = infJumpEnabled

	if tbl.infJumpConn then
		tbl.infJumpConn:Disconnect()
		tbl.infJumpConn = nil
	end

	if infJumpEnabled then
		tbl.infJumpConn = UserInputService.JumpRequest:Connect(function()
			local character = localPlayer.Character
			if not character then
				return
			end
			local humanoid = character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)

		fn("Fire Hub Rivals Script", "Infinite Jump Enabled", 3)
	else
		fn("Fire Hub Rivals Script", "Infinite Jump Disabled", 3)
	end
end

local connection = nil

local function fn22(arg)
	if connection then
		connection:Disconnect()
		connection = nil
	end

	if arg then
		connection = RunService.Heartbeat:Connect(function()
			local character = localPlayer.Character
			if not character then
				return
			end
			local humanoid = character:FindFirstChildWhichIsA("Humanoid")

			if humanoid then
				humanoid:TranslateBy(humanoid.MoveDirection * tbl.Speed)
			end
		end)

		fn("Fire Hub Rivals Script", "Speed Enabled", 3)
	else
		fn("Fire Hub Rivals Script", "Speed Disabled", 3)
	end
end

local function fn23(bunnyHopEnabled)
	tbl.BunnyHopEnabled = bunnyHopEnabled

	if bunnyHopEnabled then
		spawn(function()
			while tbl.BunnyHopEnabled do
				local character = localPlayer.Character

				if character then
					local humanoid = character:WaitForChild("Humanoid")

					if humanoid.FloorMaterial == Enum.Material.Air then
						humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
					end
				end

				wait(0.1)
			end
		end)

		fn("Fire Hub Rivals Script", "Bunny Hop Enabled", 3)
	else
		fn("Fire Hub Rivals Script", "Bunny Hop Disabled", 3)
	end
end

local function fn24(fastMeleeEnabled)
	tbl.FastMeleeEnabled = fastMeleeEnabled
	local modules = ReplicatedStorage:FindFirstChild("Modules")
	modules = modules and modules:FindFirstChild("ItemLibrary")

	if modules then
		local items = modules:FindFirstChild("Items")

		if items then
			for _, child in ipairs(items:GetChildren()) do
				local cooldown = child:FindFirstChild("Cooldown")

				if cooldown then
					local meleeCooldown = cooldown:FindFirstChild("MeleeCooldown")
					local swingCooldown = cooldown:FindFirstChild("SwingCooldown")
					local attackCooldown = cooldown:FindFirstChild("AttackCooldown")
					local recoveryTime = cooldown:FindFirstChild("RecoveryTime")
					local resetTime = cooldown:FindFirstChild("ResetTime")

					if fastMeleeEnabled then
						if meleeCooldown then
							meleeCooldown.Value = 0.001
						end

						if swingCooldown then
							swingCooldown.Value = 0.001
						end

						if attackCooldown then
							attackCooldown.Value = 0.001
						end

						if recoveryTime then
							recoveryTime.Value = 0.001
						end

						if resetTime then
							resetTime.Value = 0.001
						end
					end
				end
			end
		end
	end

	if fastMeleeEnabled then
		fn("Fire Hub Rivals Script", "Fast Melee Enabled", 3)
	else
		fn("Fire Hub Rivals Script", "Fast Melee Disabled", 3)
	end
end

local function fn25(antiKatanaEnabled)
	tbl.AntiKatanaEnabled = antiKatanaEnabled

	if not tbl.AntiKatanaLoaded then
		tbl.AntiKatanaLoaded = true
		local controllers = localPlayer:WaitForChild("PlayerScripts"):FindFirstChild("Controllers")

		if controllers then
			controllers:FindFirstChild("MechanicsController")
		end
	end

	if antiKatanaEnabled then
		fn("Fire Hub Rivals Script", "Anti Katana Enabled", 3)
	else
		fn("Fire Hub Rivals Script", "Anti Katana Disabled", 3)
	end
end

local function fn26(noSmokeEnabled)
	tbl.NoSmokeEnabled = noSmokeEnabled

	if tbl.NoSmokeConnection then
		tbl.NoSmokeConnection:Disconnect()
		tbl.NoSmokeConnection = nil
	end

	if noSmokeEnabled then
		local function fn27()
			for _, descendant in ipairs(workspace:GetDescendants()) do
				if descendant.Name == "Smoke" or descendant:IsA("Smoke") then
					descendant:Destroy()
				end
			end
		end

		fn27()

		tbl.NoSmokeConnection = workspace.DescendantAdded:Connect(function(descendant)
			if descendant.Name == "Smoke" or descendant:IsA("Smoke") then
				wait(0.1)
				descendant:Destroy()
			end
		end)

		fn("Fire Hub Rivals Script", "No Smoke Enabled", 3)
	else
		fn("Fire Hub Rivals Script", "No Smoke Disabled", 3)
	end
end

local function fn27()
	Lighting.Brightness = 3
	Lighting.ClockTime = 14
	Lighting.EnvironmentDiffuseScale = 1
	Lighting.EnvironmentSpecularScale = 1
	Lighting.GlobalShadows = true
	local terrain = workspace:FindFirstChildOfClass("Terrain")

	if terrain then
		terrain.WaterWaveSize = 0
		terrain.WaterTransparency = 1
		terrain.WaterReflectance = 1
	end

	local bloomEffect = Instance.new("BloomEffect")
	bloomEffect.Intensity = 2
	bloomEffect.Size = 24
	bloomEffect.Threshold = 2
	bloomEffect.Parent = Lighting
	fn("Fire Hub Rivals Script", "RTX Graphics Enabled", 5)
end

local function fn28()
	Lighting.GlobalShadows = false

	for _, descendant in ipairs(workspace:GetDescendants()) do
		if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Smoke") or descendant:IsA("Fire") or descendant:IsA("Sparkles") then
			descendant:Destroy()
		elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
			descendant:Destroy()
		end
	end

	for _, child in ipairs(Lighting:GetChildren()) do
		if child:IsA("BlurEffect") or child:IsA("SunRaysEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("DepthOfFieldEffect") or child:IsA("BloomEffect") or child:IsA("Atmosphere") then
			child:Destroy()
		end
	end

	local terrain = workspace:FindFirstChildOfClass("Terrain")

	if terrain then
		terrain.WaterWaveSize = 0
		terrain.WaterTransparency = 1
		terrain.WaterReflectance = 0
	end

	fn("Fire Hub Rivals Script", "Lag reduced successfully", 6)
end

local function fn29()
	local v = fn3(tbl.BoxESPColorR, tbl.BoxESPColorG, tbl.BoxESPColorB)

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character then
			local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
			humanoidRootPart = humanoidRootPart and humanoidRootPart:FindFirstChild("DeltaCharm")

			if humanoidRootPart and humanoidRootPart:IsA("BoxHandleAdornment") then
				humanoidRootPart.Color3 = v
			end
		end
	end
end

local function fn30(arg)
	if not arg then
		return
	end

	task.spawn(function()
		local humanoidRootPart = arg:WaitForChild("HumanoidRootPart", 3)
		if not humanoidRootPart then
			return
		end

		if humanoidRootPart:FindFirstChild("DeltaCharm") then
			return
		end
		local boxHandleAdornment = Instance.new("BoxHandleAdornment")
		boxHandleAdornment.Name = "DeltaCharm"
		boxHandleAdornment.Size = Vector3.new(5, 8, 5)
		boxHandleAdornment.Color3 = fn3(tbl.BoxESPColorR, tbl.BoxESPColorG, tbl.BoxESPColorB)
		boxHandleAdornment.Transparency = 0.5
		boxHandleAdornment.AlwaysOnTop = true
		boxHandleAdornment.ZIndex = 10
		boxHandleAdornment.Adornee = humanoidRootPart
		boxHandleAdornment.Parent = humanoidRootPart
	end)
end

local function fn31(arg)
	if not arg then
		return
	end
	local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart then
		local deltaCharm = humanoidRootPart:FindFirstChild("DeltaCharm")

		if deltaCharm then
			deltaCharm:Destroy()
		end
	end
end

local tbl7 = {}

local function fn32()
	if tbl.CharmsConnectionsSetup then
		return
	end
	tbl.CharmsConnectionsSetup = true

	local function fn33(player)
		if player == localPlayer then
			return
		end

		if tbl7[player] then
			return
		end

		tbl7[player] = player.CharacterAdded:Connect(function(character)
			if tbl.CharmsEnabled then
				fn30(character)
			end
		end)

		if player.Character and tbl.CharmsEnabled then
			fn30(player.Character)
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		fn33(player)
	end

	Players.PlayerAdded:Connect(fn33)

	Players.PlayerRemoving:Connect(function(player)
		if tbl7[player] then
			tbl7[player]:Disconnect()
			tbl7[player] = nil
		end
	end)
end

local function fn33(charmsEnabled)
	tbl.CharmsEnabled = charmsEnabled
	fn32()

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character then
			if charmsEnabled then
				fn30(player.Character)
			else
				fn31(player.Character)
			end
		end
	end

	if charmsEnabled then
		fn("Fire Hub Rivals Script", "Charms Enabled", 3)
	else
		fn("Fire Hub Rivals Script", "Charms Disabled", 3)
	end
end

local function fn34()
	for _, player in ipairs(Players:GetPlayers()) do
		local roleInGroup = player:GetRoleInGroup(3461453)

		for _, v in ipairs(tbl3) do
			if roleInGroup == v then
				fn("Fire Hub Rivals Script", "RIVALS ADMIN JOINED - PLAY LEGIT OR LEAVE", 10)
				return
			end
		end
	end
end

Players.PlayerAdded:Connect(function(player)
	local roleInGroup = player:GetRoleInGroup(3461453)

	for _, v in ipairs(tbl3) do
		if roleInGroup == v then
			fn("Fire Hub Rivals Script", "RIVALS ADMIN JOINED - PLAY LEGIT OR LEAVE", 10)
			break
		end
	end
end)

local function fn35()
	if not tbl2.level_spoof then
		return
	end
	local customLeaderstats = localPlayer:FindFirstChild("CustomLeaderstats")

	if not customLeaderstats then
		customLeaderstats = Instance.new("Folder")
		customLeaderstats.Name = "CustomLeaderstats"
		customLeaderstats.Parent = localPlayer
	end

	local level = customLeaderstats:FindFirstChild("Level")

	if not level then
		level = Instance.new("IntValue")
		level.Name = "Level"
		level.Parent = customLeaderstats
	end

	level.Value = tbl2.spoofed_level
	localPlayer:SetAttribute("Level", tbl2.spoofed_level)
	fn("Fire Hub Rivals Script", "Level Spoofed to: " .. tostring(tbl2.spoofed_level), 3)
end

local function fn36()
	if not tbl2.winstreak_spoof then
		return
	end
	local customLeaderstats = localPlayer:FindFirstChild("CustomLeaderstats")

	if not customLeaderstats then
		customLeaderstats = Instance.new("Folder")
		customLeaderstats.Name = "CustomLeaderstats"
		customLeaderstats.Parent = localPlayer
	end

	local winStreak = customLeaderstats:FindFirstChild("Win Streak")

	if not winStreak then
		winStreak = Instance.new("IntValue")
		winStreak.Name = "Win Streak"
		winStreak.Parent = customLeaderstats
	end

	winStreak.Value = tbl2.spoofed_winstreak
	localPlayer:SetAttribute("StatisticDuelsWinStreak", tbl2.spoofed_winstreak)
end

local function fn37()
	pcall(function()
		loadstring(game:HttpGet(tbl4.skinChanger))()
	end)
end

local tbl8 = {}

local function fn38(arg)
	if not tbl.TeamCheck then
		return true
	end

	if not arg.Team or not localPlayer.Team then
		return true
	end
	return arg.Team ~= localPlayer.Team
end

local function fn39(arg)
	if arg == localPlayer then
		return false
	end

	if not fn38(arg) then
		return false
	end

	if tbl8[arg] == nil then
		return true
	end
	return tbl8[arg]
end

local function fn40(arg)
	local flag = tbl8[arg]

	if flag == nil then
		flag = true
	end

	tbl8[arg] = not flag
	return tbl8[arg]
end

local updateCameraRotation = nil

pcall(function()
	updateCameraRotation = ReplicatedStorage:WaitForChild("Remotes", 3):WaitForChild("Replication", 3):WaitForChild("Fighter", 3):WaitForChild("UpdateCameraRotation", 3)
end)

local function fn41()
	local character = localPlayer.Character
	if not character then
		return nil
	end

	for _, descendant in ipairs(character:GetDescendants()) do
		if descendant:IsA("BasePart") or descendant:IsA("Attachment") then
			if descendant.Name == "AimPosition" or descendant.Name == "_aim_position" then
				return descendant
			end
		end
	end

	return nil
end

local tbl9 = {}

local function fn42()
	if not tbl.ClearBlockers then
		return
	end

	pcall(function()
		local lobby = workspace:FindFirstChild("Lobby")
		if not lobby then
			return
		end
		local hub = lobby:FindFirstChild("Hub")
		if not hub then
			return
		end
		local extra = hub:FindFirstChild("Extra")

		if extra then
			for _, descendant in ipairs(extra:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant.Name:find("CameraBlocker") then
					if not tbl9[descendant] then
						tbl9[descendant] = descendant.Parent
					end

					descendant:Destroy()
				end
			end
		end

		local important = hub:FindFirstChild("Important")

		if important then
			local displays = important:FindFirstChild("Displays")

			if displays then
				for _, child in ipairs(displays:GetChildren()) do
					local extra2 = child:FindFirstChild("Extra")

					if extra2 then
						for _, descendant in ipairs(extra2:GetDescendants()) do
							if descendant:IsA("BasePart") and descendant.Name:find("CameraBlocker") then
								if not tbl9[descendant] then
									tbl9[descendant] = descendant.Parent
								end

								descendant:Destroy()
							end
						end
					end
				end
			end
		end
	end)
end

local connection2 = nil
local v = nil

local function fn43(arg)
	return 0.04 + (arg - 1) / 9 * 0.96
end

local function fn44(arg)
	if tbl.LockTargetPart == "Head" then
		return arg:FindFirstChild("Head") or arg:FindFirstChild("HumanoidRootPart")
	end
	return arg:FindFirstChild("HumanoidRootPart") or arg:FindFirstChild("Torso")
end

local function fn45()
	local viewportSize = currentCamera.ViewportSize
	local vector22 = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
	local huge = math.huge
	local character = nil

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= localPlayer and fn38(player) and fn39(player) and player.Character then
			local v2 = fn44(player.Character)
			local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

			if v2 and humanoid and humanoid.Health > 0 then
				local v3, v4 = currentCamera:WorldToViewportPoint(v2.Position)
				local n = (currentCamera.CFrame.Position - v2.Position).Magnitude * 0.4 + (v4 and (Vector2.new(v3.X, v3.Y) - vector22).Magnitude or 9999) * 0.6

				if n < huge then
					character = player.Character
					huge = n
				end
			end
		end
	end

	return character
end

local function fn46(arg)
	local v2 = fn44(arg)
	if not v2 then
		return
	end
	local position = v2.Position
	local v3 = fn41()

	if v3 then
		position = v3.WorldPosition
	end

	local cFrame = currentCamera.CFrame
	local position2 = cFrame.Position
	local v4 = fn43(tbl.LockSpeed)
	currentCamera.CFrame = cFrame:Lerp(CFrame.new(position2, position), v4)

	if tbl.CamRemoteEnabled and updateCameraRotation then
		pcall(function()
			updateCameraRotation:FireServer(currentCamera.CFrame.LookVector)
		end)
	end

	local character = localPlayer.Character
	character = character and character:FindFirstChild("HumanoidRootPart")

	if character then
		character.CFrame = CFrame.new(character.Position, Vector3.new(position.X, character.Position.Y, position.Z))
	end
end

local function fn47(lockOnEnabled)
	tbl.LockOnEnabled = lockOnEnabled

	if lockOnEnabled then
		v = fn45()

		if connection2 then
			connection2:Disconnect()
		end

		connection2 = RunService.RenderStepped:Connect(function()
			if not tbl.LockOnEnabled then
				return
			end

			if v then
				local humanoid = v:FindFirstChildOfClass("Humanoid")

				if not v:IsDescendantOf(workspace) or not humanoid or humanoid.Health <= 0 then
					v = nil
				end
			end

			if not v then
				v = fn45()
			end

			if v then
				fn46(v)
			end
		end)

		fn("Fire Hub Rivals Script", "Lock On Active", 3)
	else
		v = nil

		if connection2 then
			connection2:Disconnect()
			connection2 = nil
		end

		fn("Fire Hub Rivals Script", "Lock On Off", 3)
	end
end

local circle2 = Drawing.new("Circle")
circle2.Visible = false
circle2.Thickness = 1.5
circle2.NumSides = 64
circle2.Radius = tbl.AimFOV
circle2.Filled = false
circle2.Color = fn3(165, 85, 255)
circle2.Transparency = 0.85
local circle3 = Drawing.new("Circle")
circle3.Visible = false
circle3.Thickness = 0
circle3.NumSides = 64
circle3.Radius = tbl.AimFOV
circle3.Filled = true
circle3.Color = fn3(55, 125, 255)
circle3.Transparency = 0.06
local circle4 = Drawing.new("Circle")
circle4.Visible = false
circle4.Radius = 4
circle4.Filled = true
circle4.Color = fn3(195, 120, 255)
circle4.Thickness = 0
circle4.Transparency = 1
local connection3 = nil

local function fn48(arg)
	if tbl.AimTargetPart == "Head" then
		return arg:FindFirstChild("Head") or arg:FindFirstChild("HumanoidRootPart")
	end
	return arg:FindFirstChild("HumanoidRootPart") or arg:FindFirstChild("Torso")
end

local function fn49()
	local mouseLocation = UserInputService:GetMouseLocation()
	local huge = math.huge
	local tbl10 = nil

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= localPlayer and fn38(player) and fn39(player) and player.Character then
			local v2 = fn48(player.Character)
			local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

			if v2 and humanoid and humanoid.Health > 0 then
				local v3, v4 = currentCamera:WorldToViewportPoint(v2.Position)

				if v4 and v3.Z > 0 then
					local vector22 = Vector2.new(v3.X, v3.Y)
					local magnitude = (vector22 - mouseLocation).Magnitude

					if magnitude <= tbl.AimFOV and magnitude < huge then
						tbl10 = { player = player, character = player.Character, part = v2, screenPos = vector22 }
						huge = magnitude
					end
				end
			end
		end
	end

	return tbl10
end

local function fn50(arg)
	local cFrame = currentCamera.CFrame
	local position = cFrame.Position
	local n = 0.04 + (math.clamp(tbl.AimSmooth, 1, 10) - 1) / 9 * 0.4
	currentCamera.CFrame = cFrame:Lerp(CFrame.new(position, arg), n)

	if tbl.CamRemoteEnabled and updateCameraRotation then
		pcall(function()
			updateCameraRotation:FireServer(currentCamera.CFrame.LookVector)
		end)
	end
end

local function fn51()
	if connection3 then
		connection3:Disconnect()
	end

	connection3 = RunService.RenderStepped:Connect(function()
		local mouseLocation = UserInputService:GetMouseLocation()
		circle2.Position = mouseLocation
		circle3.Position = mouseLocation
		circle2.Radius = tbl.AimFOV
		circle3.Radius = tbl.AimFOV

		if not tbl.AimAssistEnabled then
			circle2.Visible = false
			circle3.Visible = false
			circle4.Visible = false
			return
		end

		circle2.Visible = true
		circle3.Visible = true
		local v2 = fn49()

		if v2 then
			circle2.Color = fn3(195, 120, 255)
			circle3.Color = fn3(165, 85, 255)
			circle3.Transparency = 0.08
			circle4.Position = v2.screenPos
			circle4.Visible = true
			fn50(v2.part.Position)
		else
			circle2.Color = fn3(55, 125, 255)
			circle3.Color = fn3(55, 125, 255)
			circle3.Transparency = 0.04
			circle4.Visible = false
		end
	end)
end

fn51()

loadMainScript = function()
	local v2, v3 = fn10()
	local value, v4, v5, v6, v7, v8, v9, v10, v11 = unpack(v3)

	local Frame = fn6("Frame", {
		Name = "EditOverlay",
		Size = UDim2.new(1, 0, 1, -38),
		Position = UDim2.new(0, 0, 0, 38),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 25,
		Visible = false,
		Active = true,
		Parent = v11,
	})

	local tbl10 = {}

	local function fn52(scaleEditing)
		tbl.ScaleEditing = scaleEditing
		Frame.Visible = scaleEditing
		v11.ClipsDescendants = not scaleEditing

		for _, v12 in pairs(tbl10) do
			v12.Visible = scaleEditing
		end
	end

	local n = 20
	local n2 = 3
	local n3 = 8
	local tbl11 = {}

	local tbl12 = {
		name = "TopLeft",
		position = UDim2.new(0, -6, 0, -6),
		anchor = Vector2.new(0, 0),
		xSign = -1,
		ySign = -1,
		p0 = Vector2.new(0.5, 0),
		p1 = Vector2.new(0, 0),
		p2 = Vector2.new(0, 0.5),
	}

	local tbl13 = {
		name = "TopRight",
		position = UDim2.new(1, 6, 0, -6),
		anchor = Vector2.new(1, 0),
		xSign = 1,
		ySign = -1,
		p0 = Vector2.new(0.5, 0),
		p1 = Vector2.new(1, 0),
		p2 = Vector2.new(1, 0.5),
	}

	local tbl14 = {
		name = "BottomLeft",
		position = UDim2.new(0, -6, 1, 6),
		anchor = Vector2.new(0, 1),
		xSign = -1,
		ySign = 1,
		p0 = Vector2.new(0, 0.5),
		p1 = Vector2.new(0, 1),
		p2 = Vector2.new(0.5, 1),
	}

	local tbl15 = {
		name = "BottomRight",
		position = UDim2.new(1, 6, 1, 6),
		anchor = Vector2.new(1, 1),
		xSign = 1,
		ySign = 1,
		p0 = Vector2.new(1, 0.5),
		p1 = Vector2.new(1, 1),
		p2 = Vector2.new(0.5, 1),
	}

	tbl11[1] = tbl12
	tbl11[2] = tbl13
	tbl11[3] = tbl14
	tbl11[4] = tbl15

	local function fn53(arg, arg2, arg3, arg4)
		local n4 = 1 - arg
		return n4 * n4 * arg2 + 2 * n4 * arg * arg3 + arg * arg * arg4
	end

	pcall(function()
		for _, v12 in ipairs(tbl11) do
			local Frame2 = fn6("Frame", {
				Name = v12.name,
				Size = UDim2.new(0, 20, 0, 20),
				Position = v12.position,
				AnchorPoint = v12.anchor,
				BackgroundTransparency = 1,
				ClipsDescendants = false,
				Visible = false,
				Active = true,
				ZIndex = 30,
				Parent = v11,
			})

			for i = 0, n3 - 1 do
				local v13 = fn53(i / (n3 - 1), v12.p0, v12.p1, v12.p2)

				local Frame3 = fn6("Frame", {
					Name = "Dot_" .. i,
					Size = UDim2.new(0, 3, 0, 3),
					Position = UDim2.new(0, v13.X * n - n2 / 2, 0, v13.Y * n - n2 / 2),
					BackgroundColor3 = Color3.fromRGB(0, 200, 255),
					BorderSizePixel = 0,
					Active = false,
					ZIndex = 31,
					Parent = Frame2,
				})

				fn7(n2 / 2, Frame3)
			end

			Frame2.InputBegan:Connect(function(input)
				if not tbl.ScaleEditing then
					return
				end

				if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
					return
				end

				for _, child in ipairs(Frame2:GetChildren()) do
					if child:IsA("Frame") and child.Name:match("^Dot_") then
						child.BackgroundColor3 = Color3.fromRGB(180, 240, 255)
					end
				end

				local position = input.Position
				local size = v11.Size
				local position2 = v11.Position

				local connection4 = UserInputService.InputChanged:Connect(function(input2)
					if input2.UserInputType ~= Enum.UserInputType.MouseMovement and input2.UserInputType ~= Enum.UserInputType.Touch then
						return
					end
					local n4 = input2.Position - position
					local n5 = math.clamp(size.X.Offset + n4.X * v12.xSign, 200, 900)
					local n6 = math.clamp(size.Y.Offset + n4.Y * v12.ySign, 150, 700)
					v11.Size = UDim2.new(0, n5, 0, n6)
					local offset = position2.X.Offset
					local offset2 = position2.Y.Offset

					if v12.xSign < 0 then
						offset += size.X.Offset - n5
					end

					if v12.ySign < 0 then
						offset2 += size.Y.Offset - n6
					end

					v11.Position = UDim2.new(position2.X.Scale, offset, position2.Y.Scale, offset2)
					fn12(v11, fn13(v11))
				end)

				local connection5 = nil

				connection5 = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						for _, child in ipairs(Frame2:GetChildren()) do
							if child:IsA("Frame") and child.Name:match("^Dot_") then
								child.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
							end
						end

						if connection4 then
							connection4:Disconnect()
						end

						connection5:Disconnect()
					end
				end)
			end)

			tbl10[v12.name] = Frame2
		end
	end)

	fn14(value, "Silent Aim V1", function(silentAimEnabled)
		tbl.SilentAimEnabled = silentAimEnabled

		if silentAimEnabled then
			fn17()
		end
	end, 0)

	local TextButton = fn6("TextButton", {
		Size = UDim2.new(1, -6, 0, 26),
		BackgroundColor3 = color4,
		BorderSizePixel = 0,
		Text = "Silent Aim Part: Head",
		TextColor3 = color6,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		LayoutOrder = 1,
		Parent = value,
	})

	fn7(8, TextButton)

	TextButton.MouseButton1Click:Connect(function()
		local tbl16 = { "Head", "Torso" }
		tbl.HitPart = tbl16[(table.find(tbl16, tbl.HitPart) or 1) % #tbl16 + 1]
		TextButton.Text = "Silent Aim Part: " .. tbl.HitPart
	end)

	fn14(value, "ESP and Health ESP", function(espEnabled)
		tbl.ESPEnabled = espEnabled
		tbl.ShowHealthBar = espEnabled

		if espEnabled then
			fn19()
		end
	end, 4)

	fn14(value, "Box ESP", function(arg)
		fn33(arg)
	end, 5)

	fn9(value, fn3(tbl.BoxESPColorR, tbl.BoxESPColorG, tbl.BoxESPColorB), function(arg)
		tbl.BoxESPColorR = math.floor(arg.R * 255 + 0.5)
		tbl.BoxESPColorG = math.floor(arg.G * 255 + 0.5)
		tbl.BoxESPColorB = math.floor(arg.B * 255 + 0.5)
		fn29()
	end, 6, "Box ESP Color Chooser")

	fn14(value, "Staff Detector", function(arg)
		if arg then
			fn34()
		end
	end, 7)

	fn14(value, "Wall Bang", function(arg)
		tbl.WallCheck = not arg
	end, 8)

	fn6("TextLabel", {
		Size = UDim2.new(1, -6, 0, 18),
		BackgroundTransparency = 1,
		Text = "━━ AIM ASSIST ━━",
		TextColor3 = fn3(165, 85, 255),
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		LayoutOrder = 11,
		Parent = value,
	})

	fn14(value, "Aim Assist", function(aimAssistEnabled)
		tbl.AimAssistEnabled = aimAssistEnabled
	end, 12)

	local TextLabel = fn6("TextLabel", {
		Size = UDim2.new(1, -6, 0, 18),
		BackgroundTransparency = 1,
		Text = "Aim FOV: " .. tbl.AimFOV,
		TextColor3 = color6,
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		LayoutOrder = 13,
		Parent = value,
	})

	local Frame2 = fn6("Frame", {
		Size = UDim2.new(1, -6, 0, 6),
		BackgroundColor3 = fn3(50, 50, 55),
		BorderSizePixel = 0,
		LayoutOrder = 14,
		Parent = value,
	})

	fn7(3, Frame2)
	local Frame3 = fn6("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = color, BorderSizePixel = 0, Parent = Frame2 })
	fn7(3, Frame3)

	local Frame4 = fn6("Frame", {
		Size = UDim2.new(0, 14, 0, 14),
		Position = UDim2.new(0, 0, 0.5, -7),
		BackgroundColor3 = color5,
		BorderSizePixel = 0,
		Parent = Frame2,
	})

	fn7(7, Frame4)

	local function fn54()
		local n4 = (tbl.AimFOV - 40) / 310
		Frame3.Size = UDim2.new(n4, 0, 1, 0)
		Frame4.Position = UDim2.new(n4, -7, 0.5, -7)
	end

	fn54()
	local flag = false

	Frame2.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag = true
			tbl.AimFOV = math.floor(40 + math.clamp((input.Position.X - Frame2.AbsolutePosition.X) / Frame2.AbsoluteSize.X, 0, 1) * 310)
			fn54()
			TextLabel.Text = "Aim FOV: " .. tbl.AimFOV
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if flag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			tbl.AimFOV = math.floor(40 + math.clamp((input.Position.X - Frame2.AbsolutePosition.X) / Frame2.AbsoluteSize.X, 0, 1) * 310)
			fn54()
			TextLabel.Text = "Aim FOV: " .. tbl.AimFOV
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag = false
		end
	end)

	local TextLabel2 = fn6("TextLabel", {
		Size = UDim2.new(1, -6, 0, 18),
		BackgroundTransparency = 1,
		Text = "Smoothness: " .. tbl.AimSmooth,
		TextColor3 = color6,
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		LayoutOrder = 15,
		Parent = value,
	})

	local Frame5 = fn6("Frame", {
		Size = UDim2.new(1, -6, 0, 6),
		BackgroundColor3 = fn3(50, 50, 55),
		BorderSizePixel = 0,
		LayoutOrder = 16,
		Parent = value,
	})

	fn7(3, Frame5)
	local Frame6 = fn6("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = color, BorderSizePixel = 0, Parent = Frame5 })
	fn7(3, Frame6)

	local Frame7 = fn6("Frame", {
		Size = UDim2.new(0, 14, 0, 14),
		Position = UDim2.new(0, 0, 0.5, -7),
		BackgroundColor3 = color5,
		BorderSizePixel = 0,
		Parent = Frame5,
	})

	fn7(7, Frame7)

	local function fn55()
		local n4 = (tbl.AimSmooth - 1) / 9
		Frame6.Size = UDim2.new(n4, 0, 1, 0)
		Frame7.Position = UDim2.new(n4, -7, 0.5, -7)
	end

	fn55()
	local flag2 = false

	Frame5.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag2 = true
			tbl.AimSmooth = math.floor(1 + math.clamp((input.Position.X - Frame5.AbsolutePosition.X) / Frame5.AbsoluteSize.X, 0, 1) * 9)
			fn55()
			TextLabel2.Text = "Smoothness: " .. tbl.AimSmooth
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if flag2 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			tbl.AimSmooth = math.floor(1 + math.clamp((input.Position.X - Frame5.AbsolutePosition.X) / Frame5.AbsoluteSize.X, 0, 1) * 9)
			fn55()
			TextLabel2.Text = "Smoothness: " .. tbl.AimSmooth
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag2 = false
		end
	end)

	local TextButton2 = fn6("TextButton", {
		Size = UDim2.new(1, -6, 0, 26),
		BackgroundColor3 = color4,
		BorderSizePixel = 0,
		Text = "Aim Part: Head",
		TextColor3 = color6,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		LayoutOrder = 17,
		Parent = value,
	})

	fn7(8, TextButton2)

	TextButton2.MouseButton1Click:Connect(function()
		local tbl16 = { "Head", "Torso" }
		tbl.AimTargetPart = tbl16[(table.find(tbl16, tbl.AimTargetPart) or 1) % #tbl16 + 1]
		TextButton2.Text = "Aim Part: " .. tbl.AimTargetPart
	end)

	fn6("TextLabel", {
		Size = UDim2.new(1, -8, 0, 36),
		BackgroundTransparency = 1,
		Text = "GUI SCALE\nClick Edit Scale, drag any blue corner, then press Save Scale.",
		TextColor3 = fn3(170, 180, 200),
		TextSize = 11,
		Font = Enum.Font.Gotham,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = 1,
		Parent = v10,
	})

	local TextButton3 = fn6("TextButton", {
		Size = UDim2.new(1, -8, 0, 30),
		BackgroundColor3 = fn3(38, 42, 55),
		BorderSizePixel = 0,
		Text = "Edit Scale",
		TextColor3 = color5,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		LayoutOrder = 2,
		Parent = v10,
	})

	fn7(8, TextButton3)

	TextButton3.MouseButton1Click:Connect(function()
		if tbl.IsMinimized then
			fn("Fire Hub Rivals Script", "please expand gui before editing scale nuub", 3)
			return
		end
		fn52(not tbl.ScaleEditing)
		TextButton3.Text = tbl.ScaleEditing and "Editing Scale..." or "Edit Scale"
	end)

	local TextButton4 = fn6("TextButton", {
		Size = UDim2.new(1, -8, 0, 30),
		BackgroundColor3 = fn3(34, 197, 94),
		BorderSizePixel = 0,
		Text = "Save Scale",
		TextColor3 = color5,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		LayoutOrder = 3,
		ZIndex = 35,
		Parent = v10,
	})

	fn7(8, TextButton4)

	TextButton4.MouseButton1Click:Connect(function()
		if tbl.IsMinimized then
			fn("Fire Hub Rivals Script", "please expand gui before saving scale nuub", 3)
			return
		end
		v11:SetAttribute("SavedWidth", v11.Size.X.Offset)
		v11:SetAttribute("SavedHeight", v11.Size.Y.Offset)
		fn52(false)
		TextButton3.Text = "Edit Scale"
		TextButton4.Text = "Scale Saved"

		delay(2, function()
			if TextButton4.Parent then
				TextButton4.Text = "Save Scale"
			end
		end)
	end)

	fn6("TextLabel", {
		Size = UDim2.new(1, -8, 0, 20),
		BackgroundTransparency = 1,
		Text = "STYLED THEMES",
		TextColor3 = fn3(170, 180, 200),
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = 4,
		Parent = v10,
	})

	local ScrollingFrame = fn6("ScrollingFrame", {
		Name = "StyledScroll",
		Size = UDim2.new(1, -8, 0, 70),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.X,
		AutomaticCanvasSize = Enum.AutomaticSize.X,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		LayoutOrder = 5,
		Parent = v10,
	})

	fn6("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 8),
		Parent = ScrollingFrame,
	})

	local function fn56(arg)
		local canvasPosition = ScrollingFrame.CanvasPosition
		local n4 = math.max(0, ScrollingFrame.AbsoluteCanvasSize.X - ScrollingFrame.AbsoluteWindowSize.X)
		local y = canvasPosition.Y
		ScrollingFrame.CanvasPosition = Vector2.new(math.clamp(canvasPosition.X + arg * 90, 0, n4), y)
	end

	for i, v12 in ipairs({ "Default", "Earth", "Flower", "Leaf Water-drop" }) do
		local TextButton5 = fn6("TextButton", {
			Name = v12,
			Size = UDim2.new(0, 90, 0, 60),
			BackgroundColor3 = fn3(30, 30, 35),
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			LayoutOrder = i,
			Parent = ScrollingFrame,
		})

		fn7(10, TextButton5)
		local image = tbl6[v12].image

		if image and image ~= "" then
			fn6("ImageLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Image = image,
				ScaleType = Enum.ScaleType.Crop,
				Parent = TextButton5,
			})
		else
			fn6("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = fn3(30, 30, 35),
				BorderSizePixel = 0,
				Parent = TextButton5,
			})
		end

		fn6("Frame", {
			Size = UDim2.new(1, 0, 0, 18),
			Position = UDim2.new(0, 0, 1, -18),
			BackgroundColor3 = fn3(0, 0, 0),
			BackgroundTransparency = 0.4,
			BorderSizePixel = 0,
			Parent = TextButton5,
		})

		fn6("TextLabel", {
			Size = UDim2.new(1, 0, 0, 18),
			Position = UDim2.new(0, 0, 1, -18),
			BackgroundTransparency = 1,
			Text = v12,
			TextColor3 = color5,
			TextSize = 10,
			Font = Enum.Font.GothamBold,
			Parent = TextButton5,
		})

		TextButton5.MouseButton1Click:Connect(function()
			fn5(v12, v2)
			fn("Fire Hub Rivals Script", "Styled theme: " .. v12, 3)
		end)
	end

	local Frame8 = fn6("Frame", { Size = UDim2.new(1, -8, 0, 22), BackgroundTransparency = 1, LayoutOrder = 6, Parent = v10 })

	fn6("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 6),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Parent = Frame8,
	})

	local TextButton5 = fn6("TextButton", {
		Size = UDim2.new(0, 22, 0, 20),
		BackgroundColor3 = fn3(38, 38, 45),
		BorderSizePixel = 0,
		Text = "<",
		TextColor3 = color5,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		Parent = Frame8,
	})

	fn7(6, TextButton5)

	TextButton5.MouseButton1Click:Connect(function()
		fn56(-1)
	end)

	local TextButton6 = fn6("TextButton", {
		Size = UDim2.new(0, 22, 0, 20),
		BackgroundColor3 = fn3(38, 38, 45),
		BorderSizePixel = 0,
		Text = ">",
		TextColor3 = color5,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		Parent = Frame8,
	})

	fn7(6, TextButton6)

	TextButton6.MouseButton1Click:Connect(function()
		fn56(1)
	end)

	fn6("TextLabel", {
		Size = UDim2.new(1, -8, 0, 20),
		BackgroundTransparency = 1,
		Text = "COLOR THEMES",
		TextColor3 = fn3(170, 180, 200),
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = 7,
		Parent = v10,
	})

	local ScrollingFrame2 = fn6("ScrollingFrame", {
		Name = "ColorScroll",
		Size = UDim2.new(1, -8, 0, 70),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.X,
		AutomaticCanvasSize = Enum.AutomaticSize.X,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		LayoutOrder = 8,
		Parent = v10,
	})

	fn6("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 8),
		Parent = ScrollingFrame2,
	})

	local function fn57(arg)
		local canvasPosition = ScrollingFrame2.CanvasPosition
		local n4 = math.max(0, ScrollingFrame2.AbsoluteCanvasSize.X - ScrollingFrame2.AbsoluteWindowSize.X)
		local y = canvasPosition.Y
		ScrollingFrame2.CanvasPosition = Vector2.new(math.clamp(canvasPosition.X + arg * 90, 0, n4), y)
	end

	for i, v12 in ipairs({ "None", "Purple", "Green", "Red", "Gold" }) do
		local v13 = tbl5[v12]

		local TextButton7 = fn6("TextButton", {
			Name = v12,
			Size = UDim2.new(0, 90, 0, 60),
			BackgroundColor3 = v13.bg,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			LayoutOrder = i,
			Parent = ScrollingFrame2,
		})

		fn7(10, TextButton7)

		fn6("Frame", {
			Size = UDim2.new(1, -8, 0, 20),
			Position = UDim2.new(0, 4, 0, 4),
			BackgroundColor3 = v13.tab,
			BorderSizePixel = 0,
			Parent = TextButton7,
		})

		fn6("Frame", {
			Size = UDim2.new(1, -8, 0, 14),
			Position = UDim2.new(0, 4, 0, 28),
			BackgroundColor3 = v13.button,
			BorderSizePixel = 0,
			Parent = TextButton7,
		})

		fn6("TextLabel", {
			Size = UDim2.new(1, 0, 0, 14),
			Position = UDim2.new(0, 0, 1, -16),
			BackgroundTransparency = 1,
			Text = v12,
			TextColor3 = v13.text,
			TextSize = 10,
			Font = Enum.Font.GothamBold,
			Parent = TextButton7,
		})

		TextButton7.MouseButton1Click:Connect(function()
			fn4(v12, v2)
			fn("Fire Hub Rivals Script", "Color theme: " .. v12, 3)
		end)
	end

	local Frame9 = fn6("Frame", { Size = UDim2.new(1, -8, 0, 22), BackgroundTransparency = 1, LayoutOrder = 9, Parent = v10 })

	fn6("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 6),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Parent = Frame9,
	})

	local TextButton7 = fn6("TextButton", {
		Size = UDim2.new(0, 22, 0, 20),
		BackgroundColor3 = fn3(38, 38, 45),
		BorderSizePixel = 0,
		Text = "<",
		TextColor3 = color5,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		Parent = Frame9,
	})

	fn7(6, TextButton7)

	TextButton7.MouseButton1Click:Connect(function()
		fn57(-1)
	end)

	local TextButton8 = fn6("TextButton", {
		Size = UDim2.new(0, 22, 0, 20),
		BackgroundColor3 = fn3(38, 38, 45),
		BorderSizePixel = 0,
		Text = ">",
		TextColor3 = color5,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		Parent = Frame9,
	})

	fn7(6, TextButton8)

	TextButton8.MouseButton1Click:Connect(function()
		fn57(1)
	end)

	fn14(v4, "Lock On", function(arg)
		fn47(arg)
	end, 1)

	local TextLabel3 = fn6("TextLabel", {
		Size = UDim2.new(1, -6, 0, 18),
		BackgroundTransparency = 1,
		Text = "Lock Speed: " .. tbl.LockSpeed,
		TextColor3 = color6,
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		LayoutOrder = 2,
		Parent = v4,
	})

	local Frame10 = fn6("Frame", {
		Size = UDim2.new(1, -6, 0, 6),
		BackgroundColor3 = fn3(50, 50, 55),
		BorderSizePixel = 0,
		LayoutOrder = 3,
		Parent = v4,
	})

	fn7(3, Frame10)
	local Frame11 = fn6("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = color, BorderSizePixel = 0, Parent = Frame10 })
	fn7(3, Frame11)

	local Frame12 = fn6("Frame", {
		Size = UDim2.new(0, 14, 0, 14),
		Position = UDim2.new(0, 0, 0.5, -7),
		BackgroundColor3 = color5,
		BorderSizePixel = 0,
		Parent = Frame10,
	})

	fn7(7, Frame12)

	local function fn58()
		local n4 = (tbl.LockSpeed - 1) / 9
		Frame11.Size = UDim2.new(n4, 0, 1, 0)
		Frame12.Position = UDim2.new(n4, -7, 0.5, -7)
	end

	fn58()
	local flag3 = false

	Frame10.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag3 = true
			tbl.LockSpeed = math.floor(1 + math.clamp((input.Position.X - Frame10.AbsolutePosition.X) / Frame10.AbsoluteSize.X, 0, 1) * 9)
			fn58()
			TextLabel3.Text = "Lock Speed: " .. tbl.LockSpeed
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if flag3 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			tbl.LockSpeed = math.floor(1 + math.clamp((input.Position.X - Frame10.AbsolutePosition.X) / Frame10.AbsoluteSize.X, 0, 1) * 9)
			fn58()
			TextLabel3.Text = "Lock Speed: " .. tbl.LockSpeed
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag3 = false
		end
	end)

	local TextButton9 = fn6("TextButton", {
		Size = UDim2.new(1, -6, 0, 26),
		BackgroundColor3 = color4,
		BorderSizePixel = 0,
		Text = "Lock Part: Head",
		TextColor3 = color6,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		LayoutOrder = 4,
		Parent = v4,
	})

	fn7(8, TextButton9)

	TextButton9.MouseButton1Click:Connect(function()
		local tbl16 = { "Head", "Torso" }
		tbl.LockTargetPart = tbl16[(table.find(tbl16, tbl.LockTargetPart) or 1) % #tbl16 + 1]
		TextButton9.Text = "Lock Part: " .. tbl.LockTargetPart
	end)

	fn6("TextLabel", {
		Size = UDim2.new(1, -6, 0, 18),
		BackgroundTransparency = 1,
		Text = "━━ LEGACY ━━",
		TextColor3 = fn3(165, 85, 255),
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		LayoutOrder = 5,
		Parent = v4,
	})

	fn14(v4, "Fast Melee", function(arg)
		fn24(arg)
	end, 6)

	fn14(v4, "Anti Katana", function(arg)
		fn25(arg)
	end, 7)

	local TextButton10 = fn6("TextButton", {
		Size = UDim2.new(1, -6, 0, 26),
		BackgroundColor3 = color4,
		BorderSizePixel = 0,
		Text = "Auto Win Farm",
		TextColor3 = color6,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		LayoutOrder = 8,
		Parent = v4,
	})

	fn7(8, TextButton10)

	TextButton10.MouseButton1Click:Connect(function()
		TextButton10.Text = "Auto Win Farm [Loading...]"

		local ok, result = pcall(function()
			loadstring(game:HttpGet("https://pastebin.com/raw/8KaSvXik"))()
		end)

		if ok then
			TextButton10.Text = "Auto Win Farm [Loaded]"
			TextButton10.BackgroundColor3 = color
			TextButton10.TextColor3 = color5
			fn("Fire Hub Rivals Script", "Auto Win loaded successfully", 3)
		else
			TextButton10.Text = "Auto Win Farm [Failed]"
			TextButton10.BackgroundColor3 = fn3(200, 50, 50)
			TextButton10.TextColor3 = color5
			fn("Fire Hub Rivals Script", "Auto Win failed: " .. tostring(result), 5)

			delay(3, function()
				if TextButton10.Parent then
					TextButton10.Text = "Auto Win Farm"
					TextButton10.BackgroundColor3 = color4
					TextButton10.TextColor3 = color6
				end
			end)
		end
	end)

	local TextButton11 = fn6("TextButton", {
		Size = UDim2.new(1, -6, 0, 26),
		BackgroundColor3 = color4,
		BorderSizePixel = 0,
		Text = "Fire Rate: Normal",
		TextColor3 = color6,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		LayoutOrder = 5,
		Parent = v4,
	})

	fn7(8, TextButton11)

	TextButton11.MouseButton1Click:Connect(function()
		local tbl16 = { "Normal", "Fast", "Instant" }
		tbl.FireRate = tbl16[(table.find(tbl16, tbl.FireRate) or 1) % #tbl16 + 1]
		TextButton11.Text = "Fire Rate: " .. tbl.FireRate
	end)

	fn14(v5, "RTX Graphics", function(arg)
		if arg then
			fn27()
		end
	end, 1)

	local flag4 = false

	local TextButton12 = fn6("TextButton", {
		Size = UDim2.new(1, -6, 0, 26),
		BackgroundColor3 = color4,
		BorderSizePixel = 0,
		Text = "No Lag",
		TextColor3 = color6,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		LayoutOrder = 2,
		Parent = v5,
	})

	fn7(8, TextButton12)

	TextButton12.MouseButton1Click:Connect(function()
		if flag4 then
			fn("Fire Hub Rivals Script", "Lag reduction already applied", 3)
			return
		end
		flag4 = true
		TextButton12.Text = "No Lag [Applied]"
		TextButton12.BackgroundColor3 = color
		TextButton12.TextColor3 = color5
		fn28()
	end)

	fn14(v5, "No Smoke", function(arg)
		fn26(arg)
	end, 3)

	local flag5 = false

	local TextButton13 = fn6("TextButton", {
		Size = UDim2.new(1, -6, 0, 26),
		BackgroundColor3 = color4,
		BorderSizePixel = 0,
		Text = "Unlock Every Skin",
		TextColor3 = color6,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		LayoutOrder = 1,
		Parent = v6,
	})

	fn7(8, TextButton13)

	TextButton13.MouseButton1Click:Connect(function()
		if flag5 then
			fn("Fire Hub Rivals Script", "Skin changer already loaded", 3)
			return
		end
		flag5 = true
		TextButton13.Text = "Unlock Every Skin [Loaded]"
		TextButton13.BackgroundColor3 = color
		TextButton13.TextColor3 = color5
		fn37()
		fn("Fire Hub Rivals Script", "Skin changer loaded", 3)
	end)

	fn14(v6, "Infinite Jumps", function(arg)
		fn21(arg)
	end, 2)

	fn14(v6, "No Clip", function(arg)
		fn20(arg)
	end, 3)

	fn14(v6, "Speed", function(arg)
		fn22(arg)
	end, 4)

	fn14(v6, "Bunny Hop", function(arg)
		fn23(arg)
	end, 5)

	fn14(v6, "Camera Remote Sync", function(camRemoteEnabled)
		tbl.CamRemoteEnabled = camRemoteEnabled
		fn("Fire Hub Rivals Script", "Camera Remote " .. (camRemoteEnabled and "Active" or "Off"), 3)
	end, 6)

	fn14(v6, "Destroy Camera Blockers", function(clearBlockers)
		tbl.ClearBlockers = clearBlockers

		if clearBlockers then
			fn42()
		end

		fn("Fire Hub Rivals Script", "Blockers " .. (clearBlockers and "Purged" or "Off"), 3)
	end, 7)

	local TextBox = fn6("TextBox", {
		Size = UDim2.new(1, -6, 0, 26),
		BackgroundColor3 = color4,
		BorderSizePixel = 0,
		Text = "Speed : 1.0",
		TextColor3 = color6,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		LayoutOrder = 5,
		Parent = v6,
	})

	fn7(8, TextBox)

	TextBox.FocusLost:Connect(function()
		local num = tonumber(TextBox.Text:match("[%d%.]+"))

		if num then
			tbl.Speed = math.clamp(num, 0.1, 10)
			TextBox.Text = "Speed : " .. string.format("%.1f", tbl.Speed)
		end
	end)

	local deviceSpoofed = "PC"
	local deviceSpooferEnabled = false
	local tbl16 = { PC = "MouseKeyboard", Mobile = "Touch", VR = "VR", Gamepad = "Gamepad" }

	local function fn59(arg)
		local v12 = tbl16[arg]
		if not v12 then
			return
		end

		pcall(function()
			ReplicatedStorage.Remotes.Replication.Fighter.SetControls:FireServer(v12)
		end)
	end

	local TextButton14 = fn6("TextButton", {
		Size = UDim2.new(1, -6, 0, 26),
		BackgroundColor3 = color4,
		BorderSizePixel = 0,
		Text = "Device Spoofer [OFF]",
		TextColor3 = color6,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		LayoutOrder = 1,
		Parent = v7,
	})

	fn7(8, TextButton14)

	local TextButton15 = fn6("TextButton", {
		Size = UDim2.new(1, -6, 0, 26),
		BackgroundColor3 = fn3(45, 45, 52),
		BorderSizePixel = 0,
		Text = "Device: PC ▼",
		TextColor3 = color5,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		LayoutOrder = 2,
		Visible = false,
		Parent = v7,
	})

	fn7(8, TextButton15)
	local tbl17 = { "PC", "Mobile", "VR", "Gamepad" }
	local visible = false

	local Frame13 = fn6("Frame", {
		Size = UDim2.new(1, -6, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 3,
		Visible = false,
		ClipsDescendants = true,
		Parent = v7,
	})

	fn6("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = Frame13 })

	for i, v12 in ipairs(tbl17) do
		local TextButton16 = fn6("TextButton", {
			Size = UDim2.new(1, 0, 0, 24),
			BackgroundColor3 = fn3(50, 50, 58),
			BorderSizePixel = 0,
			Text = v12,
			TextColor3 = color5,
			TextSize = 11,
			Font = Enum.Font.GothamBold,
			LayoutOrder = i,
			Parent = Frame13,
		})

		fn7(6, TextButton16)

		TextButton16.MouseButton1Click:Connect(function()
			deviceSpoofed = v12
			TextButton15.Text = "Device: " .. v12 .. " ▼"
			visible = false
			Frame13.Visible = false
			Frame13.Size = UDim2.new(1, -6, 0, 0)

			if deviceSpooferEnabled then
				fn59(v12)
			end
		end)
	end

	TextButton14.MouseButton1Click:Connect(function()
		local none = tbl5[str] or tbl5.None
		deviceSpooferEnabled = not deviceSpooferEnabled
		tbl.DeviceSpooferEnabled = deviceSpooferEnabled

		if deviceSpooferEnabled then
			fn59(deviceSpoofed)
			TextButton14.Text = "Device Spoofer [ON]"
			TextButton14.BackgroundColor3 = none.accent
			TextButton14.TextColor3 = none.text
			TextButton15.Visible = true
			fn("Fire Hub Rivals Script", "Device spoofed: " .. deviceSpoofed, 3)
		else
			TextButton14.Text = "Device Spoofer [OFF]"
			TextButton14.BackgroundColor3 = none.button
			TextButton14.TextColor3 = none.textGray
			TextButton15.Visible = false
			Frame13.Visible = false
			Frame13.Size = UDim2.new(1, -6, 0, 0)
			visible = false
			fn("Fire Hub Rivals Script", "Device spoof disabled", 2)
		end
	end)

	TextButton15.MouseButton1Click:Connect(function()
		visible = not visible
		Frame13.Visible = visible

		if visible then
			Frame13.Size = UDim2.new(1, -6, 0, #tbl17 * 26 + (#tbl17 - 1) * 2)
			TextButton15.Text = "Device: " .. deviceSpoofed .. " ▲"
		else
			Frame13.Size = UDim2.new(1, -6, 0, 0)
			TextButton15.Text = "Device: " .. deviceSpoofed .. " ▼"
		end
	end)

	local TextButton16 = fn6("TextButton", {
		Size = UDim2.new(1, -6, 0, 26),
		BackgroundColor3 = color4,
		BorderSizePixel = 0,
		Text = "Level Spoof [OFF]",
		TextColor3 = color6,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		LayoutOrder = 4,
		Parent = v7,
	})

	fn7(8, TextButton16)

	local TextBox2 = fn6("TextBox", {
		Size = UDim2.new(1, -6, 0, 26),
		BackgroundColor3 = color4,
		BorderSizePixel = 0,
		Text = "",
		PlaceholderText = "Enter Level Value...",
		PlaceholderColor3 = fn3(120, 120, 120),
		TextColor3 = color5,
		TextSize = 12,
		Font = Enum.Font.Gotham,
		LayoutOrder = 5,
		Visible = false,
		Parent = v7,
	})

	fn7(8, TextBox2)

	TextButton16.MouseButton1Click:Connect(function()
		local none = tbl5[str] or tbl5.None
		tbl2.level_spoof = not tbl2.level_spoof

		if tbl2.level_spoof then
			TextButton16.Text = "Level Spoof [ON]"
			TextButton16.BackgroundColor3 = none.accent
			TextButton16.TextColor3 = none.text
			TextBox2.Visible = true
			fn35()
			fn("Fire Hub Rivals Script", "Level Spoof Enabled", 3)
		else
			TextButton16.Text = "Level Spoof [OFF]"
			TextButton16.BackgroundColor3 = none.button
			TextButton16.TextColor3 = none.textGray
			TextBox2.Visible = false
			fn("Fire Hub Rivals Script", "Level Spoof Disabled", 3)
		end
	end)

	TextBox2.FocusLost:Connect(function()
		local spoofedLevel = tonumber(TextBox2.Text)

		if spoofedLevel then
			tbl2.spoofed_level = spoofedLevel

			if tbl2.level_spoof then
				fn35()
			end
		end
	end)

	local TextButton17 = fn6("TextButton", {
		Size = UDim2.new(1, -6, 0, 26),
		BackgroundColor3 = color4,
		BorderSizePixel = 0,
		Text = "Win Streak Spoof [OFF]",
		TextColor3 = color6,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		LayoutOrder = 6,
		Parent = v7,
	})

	fn7(8, TextButton17)

	local TextBox3 = fn6("TextBox", {
		Size = UDim2.new(1, -6, 0, 26),
		BackgroundColor3 = color4,
		BorderSizePixel = 0,
		Text = "",
		PlaceholderText = "Enter Streak Value...",
		PlaceholderColor3 = fn3(120, 120, 120),
		TextColor3 = color5,
		TextSize = 12,
		Font = Enum.Font.Gotham,
		LayoutOrder = 7,
		Visible = false,
		Parent = v7,
	})

	fn7(8, TextBox3)

	TextButton17.MouseButton1Click:Connect(function()
		local none = tbl5[str] or tbl5.None
		tbl2.winstreak_spoof = not tbl2.winstreak_spoof

		if tbl2.winstreak_spoof then
			TextButton17.Text = "Win Streak Spoof [ON]"
			TextButton17.BackgroundColor3 = none.accent
			TextButton17.TextColor3 = none.text
			TextBox3.Visible = true
			fn36()
			fn("Fire Hub Rivals Script", "Win Streak Spoof Enabled", 3)
		else
			TextButton17.Text = "Win Streak Spoof [OFF]"
			TextButton17.BackgroundColor3 = none.button
			TextButton17.TextColor3 = none.textGray
			TextBox3.Visible = false
			fn("Fire Hub Rivals Script", "Win Streak Spoof Disabled", 3)
		end
	end)

	TextBox3.FocusLost:Connect(function()
		local spoofedWinstreak = tonumber(TextBox3.Text)

		if spoofedWinstreak then
			tbl2.spoofed_winstreak = spoofedWinstreak

			if tbl2.winstreak_spoof then
				fn36()
			end
		end
	end)

	local tbl18 = {}
	local str3 = ""

	local TextBox4 = fn6("TextBox", {
		Size = UDim2.new(1, -6, 0, 26),
		BackgroundColor3 = color4,
		BorderSizePixel = 0,
		Text = "",
		PlaceholderText = "Search players...",
		PlaceholderColor3 = fn3(120, 120, 120),
		TextColor3 = color5,
		TextSize = 12,
		Font = Enum.Font.Gotham,
		LayoutOrder = 1,
		Parent = v8,
	})

	fn7(8, TextBox4)

	local TextLabel4 = fn6("TextLabel", {
		Size = UDim2.new(1, -6, 0, 16),
		BackgroundTransparency = 1,
		Text = "0 Players",
		TextColor3 = color6,
		TextSize = 10,
		Font = Enum.Font.GothamBold,
		LayoutOrder = 2,
		Parent = v8,
	})

	local Frame14 = fn6("Frame", {
		Size = UDim2.new(1, -6, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 3,
		Parent = v8,
	})

	fn6("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Frame14 })

	local function fn60(arg)
		local str4 = arg:lower()
		local n4 = 0
		local n5 = 0

		for k, v12 in pairs(tbl18) do
			n4 += 1
			local visible2 = str4 == "" or k.Name:lower():find(str4, 1, true) ~= nil or k.DisplayName:lower():find(str4, 1, true) ~= nil
			v12.card.Visible = visible2

			if visible2 then
				n5 += 1
			end
		end

		if str4 == "" then
			TextLabel4.Text = n4 .. " Players in Match"
		else
			TextLabel4.Text = n5 .. "/" .. n4 .. " Matches"
		end
	end

	local function fn61(arg, arg2, arg3)
		if fn39(arg) then
			arg3.Text = "TARGET"
			arg3.BackgroundColor3 = color
			arg3.TextColor3 = color5
		else
			arg3.Text = "IGNORE"
			arg3.BackgroundColor3 = fn3(60, 60, 70)
			arg3.TextColor3 = color6
		end
	end

	local function fn62(arg)
		if tbl18[arg] then
			return
		end

		local Frame15 = fn6("Frame", {
			Size = UDim2.new(1, 0, 0, 36),
			BackgroundColor3 = color4,
			BorderSizePixel = 0,
			LayoutOrder = 0,
			Parent = Frame14,
		})

		fn7(8, Frame15)

		local ImageLabel2 = fn6("ImageLabel", {
			Size = UDim2.new(0, 26, 0, 26),
			Position = UDim2.new(0, 5, 0, 5),
			BackgroundColor3 = fn3(40, 40, 50),
			BackgroundTransparency = 0,
			Image = "rbxthumb://type=AvatarHeadShot&id=" .. arg.UserId .. "&w=100&h=100",
			Parent = Frame15,
		})

		fn7(6, ImageLabel2)

		fn6("TextLabel", {
			Size = UDim2.new(1, -130, 0, 14),
			Position = UDim2.new(0, 38, 0, 4),
			BackgroundTransparency = 1,
			Text = arg.DisplayName,
			TextColor3 = color5,
			TextSize = 10,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = Frame15,
		})

		fn6("TextLabel", {
			Size = UDim2.new(1, -130, 0, 12),
			Position = UDim2.new(0, 38, 0, 18),
			BackgroundTransparency = 1,
			Text = "@" .. arg.Name .. (arg.Team and " | " .. arg.Team.Name or ""),
			TextColor3 = fn3(145, 155, 175),
			TextSize = 8,
			Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = Frame15,
		})

		local TextButton18 = fn6("TextButton", {
			Size = UDim2.new(0, 60, 0, 22),
			Position = UDim2.new(1, -65, 0.5, -11),
			BackgroundColor3 = color,
			BorderSizePixel = 0,
			Text = "TARGET",
			TextColor3 = color5,
			TextSize = 9,
			Font = Enum.Font.GothamBold,
			Parent = Frame15,
		})

		fn7(6, TextButton18)

		TextButton18.MouseButton1Click:Connect(function()
			local v12 = fn40(arg)
			fn61(arg, Frame15, TextButton18)
			fn("Fire Hub Rivals Script", arg.Name .. " -> " .. (v12 and "TARGET" or "IGNORE"), 2)
		end)

		fn61(arg, Frame15, TextButton18)
		tbl18[arg] = { card = Frame15, statusBtn = TextButton18 }
	end

	TextBox4:GetPropertyChangedSignal("Text"):Connect(function()
		str3 = TextBox4.Text
		fn60(str3)
	end)

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer then
			fn62(player)
		end
	end

	fn60("")

	Players.PlayerAdded:Connect(function(player)
		if player == localPlayer then
			return
		end
		task.wait(0.4)
		fn62(player)
		fn60(str3)
	end)

	Players.PlayerRemoving:Connect(function(player)
		if tbl18[player] then
			tbl18[player].card:Destroy()
			tbl18[player] = nil
			tbl8[player] = nil
			fn60(str3)
		end
	end)

	fn6("TextLabel", {
		Size = UDim2.new(1, -6, 0, 30),
		BackgroundTransparency = 1,
		Text = "rivals script made by egg!",
		TextColor3 = color5,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		TextWrapped = true,
		LayoutOrder = 1,
		Parent = v9,
	})

	local TextButton18 = fn6("TextButton", {
		Size = UDim2.new(1, -6, 0, 36),
		BackgroundColor3 = fn3(220, 38, 38),
		BorderSizePixel = 0,
		Text = "YouTube",
		TextColor3 = color5,
		TextSize = 13,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Center,
		AutoButtonColor = false,
		LayoutOrder = 2,
		Parent = v9,
	})

	fn7(8, TextButton18)
	TextButton18:SetAttribute("FixedColor", true)

	TextButton18.MouseButton1Click:Connect(function()
		fn2(tbl4.youtube)
		fn("Fire Hub Rivals Script", "YouTube link copied!", 3)
	end)

	local TextButton19 = fn6("TextButton", {
		Size = UDim2.new(1, -6, 0, 36),
		BackgroundColor3 = fn3(88, 101, 242),
		BorderSizePixel = 0,
		Text = "Discord",
		TextColor3 = color5,
		TextSize = 13,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Center,
		AutoButtonColor = false,
		LayoutOrder = 3,
		Parent = v9,
	})

	fn7(8, TextButton19)
	TextButton19:SetAttribute("FixedColor", true)

	TextButton19.MouseButton1Click:Connect(function()
		fn2(tbl4.discord)
		fn("Fire Hub Rivals Script", "Discord link copied!", 3)
	end)

	fn6("TextLabel", {
		Size = UDim2.new(1, -6, 0, 140),
		BackgroundTransparency = 1,
		Text = "Join our discord we got many other script like steal a brainrot, murder mystery 2, and join for rivals updates and upcoming giveaway about skincases, money giveaways, AND many more…",
		TextColor3 = color6,
		TextSize = 13,
		Font = Enum.Font.GothamBold,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = 4,
		Parent = v9,
	})

	fn11(v2)
	fn12(v2, fn13(v11))
	fn("Fire Hub Rivals Script", "Fire Hub Rivals Script loaded", 10)
end

loadMainScript()
