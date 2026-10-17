local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")

local OrionLib = {
	Elements = {},
	ThemeObjects = {},
	Connections = {},
	Flags = {},
	_configLoaded = false,
	Themes = {
		Default = {
			Main = Color3.fromRGB(17, 17, 19),
			Second = Color3.fromRGB(24, 24, 26),
			Stroke = Color3.fromRGB(60, 60, 65),
			Divider = Color3.fromRGB(60, 60, 60),
			Text = Color3.fromRGB(255, 255, 255),
			TextDark = Color3.fromRGB(150, 150, 150),
			TextGold = Color3.fromRGB(255, 239, 149)
		}
	},
	SelectedTheme = "Default",
	Folder = nil,
	SaveCfg = false
}

local Icons = {}

local function GetIcon(IconName)
	if Icons[IconName] ~= nil then
		return Icons[IconName]
	else
		return nil
	end
end

local function ResolveGuiParent()
	local parent
	if typeof(gethui) == "function" then
		pcall(function() parent = gethui() end)
	end
	if not parent then
		pcall(function() parent = game:GetService("CoreGui") end)
	end
	if not parent then
		pcall(function() parent = LocalPlayer:FindFirstChildOfClass("PlayerGui") end)
	end
	return parent
end

local guiParent = ResolveGuiParent()

pcall(function()
	for _, Interface in ipairs(guiParent:GetChildren()) do
		if Interface.Name == "Orion" then
			Interface:Destroy()
		end
	end
end)

local Orion = Instance.new("ScreenGui")
Orion.Name = "Orion"
pcall(function() Orion.ResetOnSpawn = false end)
pcall(function() Orion.AutoLocalize = false end)
if typeof(syn) == "table" and syn.protect_gui then
	pcall(syn.protect_gui, Orion)
end
if guiParent then
	pcall(function() Orion.Parent = guiParent end)
end
if not Orion.Parent then
	pcall(function() Orion.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui") end)
end

function OrionLib:IsRunning()
	return Orion ~= nil and Orion.Parent ~= nil
end

local function AddConnection(Signal, Function)
	if (not OrionLib:IsRunning()) then
		return
	end
	local SignalConnect = Signal:Connect(Function)
	table.insert(OrionLib.Connections, SignalConnect)
	return SignalConnect
end

local _OrionInstance = Orion

task.spawn(function()
	while _OrionInstance and _OrionInstance.Parent ~= nil do
		task.wait()
	end
	for _, Connection in next, OrionLib.Connections do
		pcall(function() Connection:Disconnect() end)
	end
end)

local function AddDraggingFunctionality(DragPoint, Main)
	pcall(function()
		local Dragging, DragInput, MousePos, FramePos = false
		DragPoint.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				Dragging = true
				MousePos = Input.Position
				FramePos = Main.Position
				Input.Changed:Connect(function()
					if Input.UserInputState == Enum.UserInputState.End then
						Dragging = false
					end
				end)
			end
		end)
		DragPoint.InputChanged:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement then
				DragInput = Input
			end
		end)
		UserInputService.InputChanged:Connect(function(Input)
			if Input == DragInput and Dragging then
				local Delta = Input.Position - MousePos
				TweenService:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)}):Play()
			end
		end)
	end)
end   

local Clock = (typeof(os) == "table" and typeof(os.clock) == "function") and os.clock or tick

local BREATH_BUDGET = 0.008
local BREATH_HARD_LIMIT = 400
local _lastBreath = Clock()
local _sinceBreath = 0
local function Breathe()
	_sinceBreath = _sinceBreath + 1
	if _sinceBreath >= BREATH_HARD_LIMIT or Clock() - _lastBreath >= BREATH_BUDGET then
		task.wait()
		_lastBreath = Clock()
		_sinceBreath = 0
	end
end

OrionLib.Breathe = Breathe

local function SetFast(Object, Property, Value)
	if Object and Object.Parent then
		Object[Property] = Value
	end
end

local function Create(Name, Properties, Children)
	Breathe()
	local Object = Instance.new(Name)
	for i, v in next, Properties or {} do
		Object[i] = v
	end
	for i, v in next, Children or {} do
		v.Parent = Object
	end
	return Object
end

local function CreateElement(ElementName, ElementFunction)
	OrionLib.Elements[ElementName] = function(...)
		return ElementFunction(...)
	end
end

local function MakeElement(ElementName, ...)
	Breathe()
	local NewElement = OrionLib.Elements[ElementName](...)
	return NewElement
end

local function SetProps(Element, Props)
	for Property, Value in pairs(Props) do
		Element[Property] = Value
	end
	return Element
end

local function SetChildren(Element, Children)
	for _, Child in pairs(Children) do
		Child.Parent = Element
	end
	return Element
end

local function Round(Number, Factor)
	local Result = math.floor(Number/Factor + (math.sign(Number) * 0.5)) * Factor
	if Result < 0 then Result = Result + Factor end
	return Result
end

local function ReturnProperty(Object)
	if Object:IsA("Frame") or Object:IsA("TextButton") then
		return "BackgroundColor3"
	end 
	if Object:IsA("ScrollingFrame") then
		return "ScrollBarImageColor3"
	end 
	if Object:IsA("UIStroke") then
		return "Color"
	end 
	if Object:IsA("TextLabel") or Object:IsA("TextBox") then
		return "TextColor3"
	end   
	if Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
		return "ImageColor3"
	end   
end

local function AddThemeObject(Object, Type)
	if not OrionLib.ThemeObjects[Type] then
		OrionLib.ThemeObjects[Type] = {}
	end    
	table.insert(OrionLib.ThemeObjects[Type], Object)
	Object[ReturnProperty(Object)] = OrionLib.Themes[OrionLib.SelectedTheme][Type]
	return Object
end    

local function SetTheme()
	for Name, Type in pairs(OrionLib.ThemeObjects) do
		for _, Object in pairs(Type) do
			Object[ReturnProperty(Object)] = OrionLib.Themes[OrionLib.SelectedTheme][Name]
		end    
	end    
end

local function PackColor(Color)
	return {R = Color.R * 255, G = Color.G * 255, B = Color.B * 255}
end    

local function UnpackColor(Color)
	return Color3.fromRGB(Color.R, Color.G, Color.B)
end

local function LoadCfg(Config)
	local Data = HttpService:JSONDecode(Config)
	for a, b in pairs(Data) do
		if OrionLib.Flags[a] then
			task.spawn(function()
				if OrionLib.Flags[a].Type == "Colorpicker" then
					OrionLib.Flags[a]:Set(UnpackColor(b))
				else
					OrionLib.Flags[a]:Set(b)
				end
			end)
		end
	end
end

local function SaveCfg(Name)
	local Data = {}
	for i, v in pairs(OrionLib.Flags) do
		if v.Save then
			if v.Type == "Colorpicker" then
				Data[i] = PackColor(v.Value)
			else
				Data[i] = v.Value
			end
		end	
	end
	writefile(OrionLib.Folder .. "/" .. Name .. ".txt", tostring(HttpService:JSONEncode(Data)))
end

local WhitelistedMouse = {Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3}
local BlacklistedKeys = {Enum.KeyCode.Unknown, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.Up, Enum.KeyCode.Left, Enum.KeyCode.Down, Enum.KeyCode.Right, Enum.KeyCode.Slash, Enum.KeyCode.Tab, Enum.KeyCode.Backspace, Enum.KeyCode.Escape}

local function CheckKey(Table, Key)
	for _, v in next, Table do
		if v == Key then
			return true
		end
	end
end

CreateElement("Corner", function(Scale, Offset)
	local Corner = Create("UICorner", {
		CornerRadius = UDim.new(Scale or 0, Offset or 10)
	})
	return Corner
end)

CreateElement("Stroke", function(Color, Thickness)
	local Stroke = Create("UIStroke", {
		Color = Color or Color3.fromRGB(255, 255, 255),
		Thickness = Thickness or 1
	})
	return Stroke
end)

CreateElement("List", function(Scale, Offset)
	local List = Create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(Scale or 0, Offset or 0)
	})
	return List
end)

CreateElement("Padding", function(Bottom, Left, Right, Top)
	local Padding = Create("UIPadding", {
		PaddingBottom = UDim.new(0, Bottom or 4),
		PaddingLeft = UDim.new(0, Left or 4),
		PaddingRight = UDim.new(0, Right or 4),
		PaddingTop = UDim.new(0, Top or 4)
	})
	return Padding
end)

CreateElement("TFrame", function()
	local TFrame = Create("Frame", {
		BackgroundTransparency = 1
	})
	return TFrame
end)

CreateElement("Frame", function(Color)
	local Frame = Create("Frame", {
		BackgroundColor3 = Color or Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0
	})
	return Frame
end)

CreateElement("RoundFrame", function(Color, Scale, Offset)
	local Frame = Create("Frame", {
		BackgroundColor3 = Color or Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0
	}, {
		Create("UICorner", {
			CornerRadius = UDim.new(Scale, Offset)
		})
	})
	return Frame
end)

CreateElement("Button", function()
	local Button = Create("TextButton", {
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	})
	return Button
end)

CreateElement("ScrollFrame", function(Color, Width)
	local ScrollFrame = Create("ScrollingFrame", {
		BackgroundTransparency = 1,
		MidImage = "rbxassetid://7445543667",
		BottomImage = "rbxassetid://7445543667",
		TopImage = "rbxassetid://7445543667",
		ScrollBarImageColor3 = Color,
		BorderSizePixel = 0,
		ScrollBarThickness = Width,
		CanvasSize = UDim2.new(0, 0, 0, 0)
	})
	return ScrollFrame
end)

CreateElement("Image", function(ImageID)
	local ImageNew = Create("ImageLabel", {
		Image = ImageID,
		BackgroundTransparency = 1
	})
	if GetIcon(ImageID) ~= nil then
		ImageNew.Image = GetIcon(ImageID)
	end	
	return ImageNew
end)

CreateElement("ImageButton", function(ImageID)
	local Image = Create("ImageButton", {
		Image = ImageID,
		BackgroundTransparency = 1
	})
	return Image
end)

CreateElement("Label", function(Text, TextSize, Transparency)
	local Label = Create("TextLabel", {
		Text = Text or "",
		TextColor3 = Color3.fromRGB(240, 240, 240),
		TextTransparency = Transparency or 0,
		TextSize = TextSize or 15,
		Font = Enum.Font.Gotham,
		RichText = true,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	return Label
end)

local GuiService = game:GetService("GuiService")

local function AddHelpQuestion(ElementFrame, HelpText)
	if not HelpText or HelpText == "" then
		return
	end

	local NameLabel = ElementFrame:FindFirstChild("Content", true)

	local Badge = Create("TextLabel", {
		Name = "HelpBadge",
		Text = "?",
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextColor3 = Color3.fromRGB(150, 150, 150),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 14, 0, 14),
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 40, 0.5, 0),
		Visible = false,
		ZIndex = 3
	})

	if NameLabel then
		Badge.Parent = NameLabel
		local function Reposition()
			Badge.Position = UDim2.new(0, NameLabel.TextBounds.X + 8, 0.5, 0)
		end
		Reposition()
		AddConnection(NameLabel:GetPropertyChangedSignal("TextBounds"), Reposition)
	else
		Badge.Position = UDim2.new(0, 12, 0.5, 0)
		Badge.Parent = ElementFrame
	end

	local Tooltip = Create("Frame", {
		Name = "HelpTooltip",
		BackgroundColor3 = Color3.fromRGB(25, 25, 27),
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 230, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Visible = false,
		ZIndex = 5000,
		Parent = Orion
	}, {
		Create("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		Create("UIStroke", {
			Color = Color3.fromRGB(60, 60, 65),
			Thickness = 1
		}),
		Create("UIPadding", {
			PaddingTop = UDim.new(0, 8),
			PaddingBottom = UDim.new(0, 8),
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10)
		}),
		Create("TextLabel", {
			Text = HelpText,
			Font = Enum.Font.GothamSemibold,
			TextSize = 13,
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			ZIndex = 5001
		})
	})

	local TooltipText = Tooltip:FindFirstChildOfClass("TextLabel")
	local TooltipTween = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

	local function GetTooltipPosition(Lifted)
		local BadgePos = Badge.AbsolutePosition
		local BadgeSize = Badge.AbsoluteSize
		local Offset = Lifted and 0 or 6
		return UDim2.fromOffset(BadgePos.X + BadgeSize.X + 6, BadgePos.Y + BadgeSize.Y + Offset)
	end

	local function ShowTooltip()
		Tooltip.AnchorPoint = Vector2.new(0, 1)
		Tooltip.Position = GetTooltipPosition(false)
		Tooltip.BackgroundTransparency = 1
		TooltipText.TextTransparency = 1
		Tooltip.Visible = true
		TweenService:Create(Tooltip, TooltipTween, {BackgroundTransparency = 0.05, Position = GetTooltipPosition(true)}):Play()
		TweenService:Create(TooltipText, TooltipTween, {TextTransparency = 0}):Play()
	end

	local function HideTooltip()
		if not Tooltip.Visible then return end
		TweenService:Create(Tooltip, TooltipTween, {BackgroundTransparency = 1}):Play()
		TweenService:Create(TooltipText, TooltipTween, {TextTransparency = 1}):Play()
		task.delay(0.2, function()
			if Tooltip.BackgroundTransparency >= 0.95 then
				Tooltip.Visible = false
			end
		end)
	end

	AddConnection(ElementFrame.MouseEnter, function()
		Badge.TextTransparency = 1
		Badge.Visible = true
		TweenService:Create(Badge, TooltipTween, {TextTransparency = 0}):Play()
	end)
	AddConnection(ElementFrame.MouseLeave, function()
		Badge.Visible = false
		Badge.TextTransparency = 1
		HideTooltip()
	end)
	AddConnection(Badge.MouseEnter, function()
		TweenService:Create(Badge, TooltipTween, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		ShowTooltip()
	end)
	AddConnection(Badge.MouseLeave, function()
		TweenService:Create(Badge, TooltipTween, {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
		HideTooltip()
	end)

	return Badge
end

local NotificationHolder = SetProps(SetChildren(MakeElement("TFrame"), {
	SetProps(MakeElement("List"), {
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		Padding = UDim.new(0, 5)
	})
}), {
	Position = UDim2.new(1, -25, 1, -25),
	Size = UDim2.new(0, 300, 1, -25),
	AnchorPoint = Vector2.new(1, 1),
	Parent = Orion
})

function OrionLib:MakeNotification(NotificationConfig)
	spawn(function()
		NotificationConfig.Name = NotificationConfig.Name or "Notification"
		NotificationConfig.Content = NotificationConfig.Content or "Test"
		NotificationConfig.Image = NotificationConfig.Image or "rbxassetid://4384403532"
		NotificationConfig.Time = NotificationConfig.Time or 15

		local NotificationParent = SetProps(MakeElement("TFrame"), {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = NotificationHolder
		})

		local NotificationFrame = SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(25, 25, 25), 0, 10), {
			Parent = NotificationParent, 
			Size = UDim2.new(1, 0, 0, 0),
			Position = UDim2.new(1, -55, 0, 0),
			BackgroundTransparency = 0,
			AutomaticSize = Enum.AutomaticSize.Y
		}), {
			MakeElement("Stroke", Color3.fromRGB(93, 93, 93), 1.2),
			MakeElement("Padding", 12, 12, 12, 12),
			SetProps(MakeElement("Image", NotificationConfig.Image), {
				Size = UDim2.new(0, 20, 0, 20),
				ImageColor3 = Color3.fromRGB(240, 240, 240),
				Name = "Icon"
			}),
			SetProps(MakeElement("Label", NotificationConfig.Name, 15), {
				Size = UDim2.new(1, -30, 0, 20),
				Position = UDim2.new(0, 30, 0, 0),
				Font = Enum.Font.GothamBold,
				Name = "Title"
			}),
			SetProps(MakeElement("Label", NotificationConfig.Content, 14), {
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0, 0, 0, 25),
				Font = Enum.Font.GothamSemibold,
				Name = "Content",
				AutomaticSize = Enum.AutomaticSize.Y,
				TextColor3 = Color3.fromRGB(200, 200, 200),
				TextWrapped = true
			})
		})

		TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 0, 0, 0)}):Play()
		task.wait(NotificationConfig.Time - 0.88)
		TweenService:Create(NotificationFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {BackgroundTransparency = 0.6}):Play()
		task.wait(0.35)
		TweenService:Create(NotificationFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {Position = UDim2.new(1, 20, 0, 0)}):Play()
		task.wait(1.35)
		NotificationFrame:Destroy()
	end)
end    

local CM = {
	CurrentConfig = "Main.lua (Default)",
	ConfigButtons = {},
	ActiveConfigLabel = nil,
	RebuildUI = nil,
}

local function CMGetFolder()
	return (OrionLib.Folder or "Beanzz") .. "/configs"
end

local function CMGetConfigPath(name)
	return CMGetFolder() .. "/" .. name .. ".txt"
end

local function CMEnsureFolder()
	local base = OrionLib.Folder or "Beanzz"
	pcall(function()
		if not isfolder(base) then makefolder(base) end
		if not isfolder(CMGetFolder()) then makefolder(CMGetFolder()) end
	end)
end

local function CMGetAllConfigs()
	local configs = {"Main.lua (Default)"}
	pcall(function()
		CMEnsureFolder()
		local files = listfiles(CMGetFolder())
		for _, f in ipairs(files) do
			local name = f:match("([^/\\]+)%.txt$")
			if name and name ~= "Default" then
				table.insert(configs, name)
			end
		end
	end)
	return configs
end

local function CMSaveFlagsToFile(configName)
	if not OrionLib._configLoaded then 
		return 
	end
	pcall(function()
		CMEnsureFolder()
		local Data = {}
		for i, v in pairs(OrionLib.Flags) do
			if v.Save then
				if v.Type == "Colorpicker" then
					Data[i] = PackColor(v.Value)
				else
					Data[i] = v.Value
				end
			end
		end
		writefile(CMGetConfigPath(configName), HttpService:JSONEncode(Data))
	end)
end

local function CMLoadFlagsFromFile(configName)
	local ok = false
	pcall(function()
		local path = CMGetConfigPath(configName)
		if isfile(path) then
			local raw = readfile(path)
			if raw == nil or raw == "" then return end
			local data = HttpService:JSONDecode(raw)
			for i, v in pairs(data) do
				if OrionLib.Flags[i] then
					local flag = OrionLib.Flags[i]
					local val = v
					pcall(function()
						if flag.Type == "Colorpicker" then
							flag:Set(UnpackColor(val))
						else
							flag:Set(val)
						end
					end)
				end
			end
			ok = true
		end
	end)
	return ok
end

local skippedFlags = {
	CarRimColor = true,
	CarBodyColor = true,
}

local function CMResetAllFlags()
	for flagName, v in pairs(OrionLib.Flags) do
		if skippedFlags[flagName] then continue end
		pcall(function()
			local resetValue
			if v.Default ~= nil then
				resetValue = v.Default
			elseif v.Type == "Colorpicker" then
				resetValue = Color3.fromRGB(255, 255, 255)
			elseif v.Type == "Dropdown" then
				if v.Default ~= nil and v.Default ~= "" then
					resetValue = v.Default
				else
					resetValue = ""
				end
			elseif v.Type == "DropdownAll" then
				resetValue = {}
			elseif type(v.Value) == "boolean" then
				resetValue = false
			elseif type(v.Value) == "number" then
				resetValue = 0
			elseif type(v.Value) == "string" then
				resetValue = ""
			end
			if resetValue ~= nil then
				v:Set(resetValue)
			end
		end)
	end
end

local function CMSwitchConfig(newConfig, onDone)
	CMSaveFlagsToFile(CM.CurrentConfig)
	OrionLib._configLoaded = false
	CMResetAllFlags()
	task.wait(0.2)
	CM.CurrentConfig = newConfig
	local loaded = CMLoadFlagsFromFile(newConfig)
	if not loaded then
		CMSaveFlagsToFile(newConfig)
	end
	task.wait(0.1)
	OrionLib._configLoaded = true
	if onDone then onDone() end
end

function OrionLib:SaveConfig()
	if OrionLib.SaveCfg and OrionLib.Folder then
		pcall(function()
			CMSaveFlagsToFile(CM.CurrentConfig)
		end)
	end
end

function OrionLib:Init()
	if OrionLib._initDone then return end
	OrionLib._initDone = true

	if not OrionLib.SaveCfg then
		OrionLib._configLoaded = true
		return
	end

	OrionLib._configLoaded = false
	local loaded = CMLoadFlagsFromFile(CM.CurrentConfig)
	OrionLib._configLoaded = true

	if loaded then
		OrionLib:MakeNotification({
			Name = "Configuration",
			Content = "Auto-loaded: " .. CM.CurrentConfig,
			Time = 5
		})
	else
		CMSaveFlagsToFile(CM.CurrentConfig)
	end
end

local TabSectionLayoutPath = nil

local function GetTabSectionLayoutPath()
	return (OrionLib.Folder or "Beanzz") .. "/tab_sections.txt"
end

local function SaveTabSectionLayout(layoutData)
	pcall(function()
		local base = OrionLib.Folder or "Beanzz"
		if not isfolder(base) then makefolder(base) end
		writefile(GetTabSectionLayoutPath(), HttpService:JSONEncode(layoutData))
	end)
end

local function LoadTabSectionLayout()
	local result = nil
	pcall(function()
		local path = GetTabSectionLayoutPath()
		if isfile(path) then
			local raw = readfile(path)
			if raw and raw ~= "" then
				result = HttpService:JSONDecode(raw)
			end
		end
	end)
	return result
end

function OrionLib:MakeWindow(WindowConfig)
	local FirstTab = true
	local Minimized = false
	local Loaded = false
	local UIHidden = false

	WindowConfig = WindowConfig or {}
	WindowConfig.Name = WindowConfig.Name or "Orion Library"
	WindowConfig.ConfigFolder = WindowConfig.ConfigFolder or WindowConfig.Name
	WindowConfig.SaveConfig = WindowConfig.SaveConfig or false
	WindowConfig.HidePremium = WindowConfig.HidePremium or false
	if WindowConfig.IntroEnabled == nil then
		WindowConfig.IntroEnabled = true
	end
	WindowConfig.IntroText = WindowConfig.IntroText or "Starting Beanzz Autorob"
	WindowConfig.CloseCallback = WindowConfig.CloseCallback or function() end
	WindowConfig.ShowIcon = WindowConfig.ShowIcon or false
	WindowConfig.Icon = WindowConfig.Icon or "rbxassetid://114924858399533"
	WindowConfig.IntroIcon = WindowConfig.IntroIcon or "rbxassetid://114924858399533"
	OrionLib.Folder = WindowConfig.ConfigFolder
	OrionLib.SaveCfg = WindowConfig.SaveConfig

	if WindowConfig.SaveConfig then
		pcall(function()
			if not isfolder(WindowConfig.ConfigFolder) then
				makefolder(WindowConfig.ConfigFolder)
			end
			CMEnsureFolder()
			if not isfile(CMGetConfigPath("Main.lua (Default)")) then
				writefile(CMGetConfigPath("Main.lua (Default)"), "{}")
			end
		end)
	end

	local TabHolder = AddThemeObject(SetChildren(SetProps(MakeElement("ScrollFrame", Color3.fromRGB(255, 255, 255), 4), {
		Size = UDim2.new(1, 0, 1, -50)
	}), {
		MakeElement("List"),
		MakeElement("Padding", 8, 0, 0, 8)
	}), "Divider")

	AddConnection(TabHolder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		TabHolder.CanvasSize = UDim2.new(0, 0, 0, TabHolder.UIListLayout.AbsoluteContentSize.Y + 16)
	end)

	local CloseBtn = SetChildren(SetProps(MakeElement("Button"), {
		Size = UDim2.new(0, 36, 1, 0),
		Position = UDim2.new(1, -36, 0, 0),
		BackgroundTransparency = 1
	}), {
		AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072725342"), {
			Position = UDim2.new(0, 9, 0, 6),
			Size = UDim2.new(0, 18, 0, 18)
		}), "Text")
	})

	local MinimizeBtn = SetChildren(SetProps(MakeElement("Button"), {
		Size = UDim2.new(0, 36, 1, 0),
		Position = UDim2.new(0, 36, 0, 0),
		BackgroundTransparency = 1
	}), {
		AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072719338"), {
			Position = UDim2.new(0, 9, 0, 6),
			Size = UDim2.new(0, 18, 0, 18),
			Name = "Ico"
		}), "Text")
	})

	local ConfigTopBtn = SetChildren(SetProps(MakeElement("Button"), {
		Size = UDim2.new(0, 36, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1
	}), {
		AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://12392896984"), {
			Position = UDim2.new(0, 9, 0, 6),
			Size = UDim2.new(0, 18, 0, 18),
			Name = "Ico"
		}), "Text")
	})

	local DragPoint = SetProps(MakeElement("TFrame"), {
		Size = UDim2.new(1, 0, 0, 50)
	})

	local WindowStuff = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 10), {
		Size = UDim2.new(0, 150, 1, -50),
		Position = UDim2.new(0, 0, 0, 50)
	}), {
		AddThemeObject(SetProps(MakeElement("Frame"), {
			Size = UDim2.new(1, 0, 0, 10),
			Position = UDim2.new(0, 0, 0, 0)
		}), "Second"), 
		AddThemeObject(SetProps(MakeElement("Frame"), {
			Size = UDim2.new(0, 10, 1, 0),
			Position = UDim2.new(1, -10, 0, 0)
		}), "Second"), 
		AddThemeObject(SetProps(MakeElement("Frame"), {
			Size = UDim2.new(0, 1, 1, 0),
			Position = UDim2.new(1, -1, 0, 0)
		}), "Stroke"), 
		TabHolder,
		SetChildren(SetProps(MakeElement("TFrame"), {
			Size = UDim2.new(1, 0, 0, 50),
			Position = UDim2.new(0, 0, 1, -50)
		}), {
			AddThemeObject(SetProps(MakeElement("Frame"), {
				Size = UDim2.new(1, 0, 0, 1)
			}), "Stroke"), 
			AddThemeObject(SetChildren(SetProps(MakeElement("Frame"), {
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.new(0, 32, 0, 32),
				Position = UDim2.new(0, 10, 0.5, 0),
				ClipsDescendants = true
			}), {
				SetChildren(SetProps(MakeElement("Image", "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"), {
					Size = UDim2.new(1, 0, 1, 0)
				}), {
					Create("UICorner", {CornerRadius = UDim.new(1, 0)})
				}),
				Create("UICorner", {CornerRadius = UDim.new(1, 0)})
			}), "Divider"),
			SetChildren(SetProps(MakeElement("TFrame"), {
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.new(0, 32, 0, 32),
				Position = UDim2.new(0, 10, 0.5, 0)
			}), {
				AddThemeObject(MakeElement("Stroke"), "Stroke"),
				Create("UICorner", {CornerRadius = UDim.new(1, 0)})
			}),
			AddThemeObject(SetProps(MakeElement("Label", "Beanzz", WindowConfig.HidePremium and 14 or 13), {
				Size = UDim2.new(1, -60, 0, 13),
				Position = WindowConfig.HidePremium and UDim2.new(0, 50, 0, 19) or UDim2.new(0, 50, 0, 12),
				Font = Enum.Font.GothamBold,
				ClipsDescendants = true
			}), "Text"),
			AddThemeObject(SetProps(MakeElement("Label", ".gg/beanzhub", 12), {
				Size = UDim2.new(1, -60, 0, 12),
				Position = UDim2.new(0, 50, 1, -25),
				Visible = not WindowConfig.HidePremium,
			}), "TextGold")
		}),
	}), "Second")

	local WindowName = AddThemeObject(SetProps(MakeElement("Label", WindowConfig.Name, 14), {
		Size = UDim2.new(1, -30, 2, 0),
		Position = UDim2.new(0, 25, 0, -24),
		Font = Enum.Font.GothamBlack,
		TextSize = 20
	}), "Text")

	local WindowTopBarLine = AddThemeObject(SetProps(MakeElement("Frame"), {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 1, -1)
	}), "Stroke")

	local TopBarBtnGroup = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 7), {
		Size = UDim2.new(0, 108, 0, 30),
		Position = UDim2.new(1, -118, 0, 10)
	}), {
		AddThemeObject(MakeElement("Stroke"), "Stroke"),
		AddThemeObject(SetProps(MakeElement("Frame"), {
			Size = UDim2.new(0, 1, 1, 0),
			Position = UDim2.new(0, 36, 0, 0),
			Name = "Div1"
		}), "Stroke"),
		AddThemeObject(SetProps(MakeElement("Frame"), {
			Size = UDim2.new(0, 1, 1, 0),
			Position = UDim2.new(0, 72, 0, 0),
			Name = "Div2"
		}), "Stroke"),
		ConfigTopBtn,
		MinimizeBtn,
		CloseBtn
	}), "Second")

	local MainWindow = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 10), {
		Parent = Orion,
		Position = UDim2.new(0.5, -307, 0.5, -172),
		Size = UDim2.new(0, 615, 0, 344),
		BackgroundTransparency = 0.03,
		ClipsDescendants = true
	}), {
		SetChildren(SetProps(MakeElement("TFrame"), {
			Size = UDim2.new(1, 0, 0, 50),
			Name = "TopBar"
		}), {
			WindowName,
			WindowTopBarLine,
			TopBarBtnGroup
		}),
		DragPoint,
		WindowStuff
	}), "Main")

	if WindowConfig.ShowIcon then
		WindowName.Position = UDim2.new(0, 48, 0, -24)
		local WindowIcon = SetProps(MakeElement("Image", WindowConfig.Icon), {
			Size = UDim2.new(0, 30, 0, 30),
			Position = UDim2.new(0, 12, 0, 11)
		})
		WindowIcon.Parent = MainWindow.TopBar
	end	

	AddDraggingFunctionality(DragPoint, MainWindow)

	local MobileReopenButton = SetChildren(SetProps(MakeElement("Button"), {
		Parent = Orion,
		Size = UDim2.new(0, 40, 0, 40),
		Position = UDim2.new(0.5, -20, 0, 20),
		BackgroundTransparency = 0.2,
		BackgroundColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Main,
		Visible = false
	}), {
		AddThemeObject(SetProps(MakeElement("Image", WindowConfig.IntroIcon), {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0.7, 0, 0.7, 0),
		}), "Text"),
		MakeElement("Corner", 1)
	})

	AddConnection(CloseBtn.MouseButton1Up, function()
		MainWindow.Visible = false
		if UserInputService.TouchEnabled then
			MobileReopenButton.Visible = true
		end
		UIHidden = true
		pcall(function()
			if OrionLib.SaveCfg then
				CMSaveFlagsToFile(CM.CurrentConfig)
			end
		end)
		OrionLib:MakeNotification({
			Name = "Interface Hidden",
			Content = UserInputService.TouchEnabled and "Tap the button or RightShift to reopen the interface" or "Tap RightShift to reopen the interface",
			Time = 5
		})
		WindowConfig.CloseCallback()
	end)

	AddConnection(UserInputService.InputBegan, function(Input)
		if Input.KeyCode == Enum.KeyCode.RightShift and UIHidden == true then
			MainWindow.Visible = true
			MobileReopenButton.Visible = false
		end
	end)

	AddConnection(MobileReopenButton.Activated, function()
		MainWindow.Visible = true
		MobileReopenButton.Visible = false
	end)

	AddConnection(MinimizeBtn.MouseButton1Up, function()
		if Minimized then
			TweenService:Create(MainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 615, 0, 344)}):Play()
			MinimizeBtn.Ico.Image = "rbxassetid://7072719338"
			task.wait(.02)
			MainWindow.ClipsDescendants = false
			WindowStuff.Visible = true
			WindowTopBarLine.Visible = true
		else
			MainWindow.ClipsDescendants = true
			WindowTopBarLine.Visible = false
			MinimizeBtn.Ico.Image = "rbxassetid://7072720870"
			TweenService:Create(MainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, WindowName.TextBounds.X + 140, 0, 50)}):Play()
			task.wait(0.1)
			WindowStuff.Visible = false	
		end
		Minimized = not Minimized    
	end)

	local function LoadSequence()
		MainWindow.Visible = false
		local LoadSequenceLogo = SetProps(MakeElement("Image", WindowConfig.IntroIcon), {
			Parent = Orion,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.4, 0),
			Size = UDim2.new(0, 28, 0, 28),
			ImageColor3 = Color3.fromRGB(255, 255, 255),
			ImageTransparency = 1
		})
		local LoadSequenceText = SetProps(MakeElement("Label", WindowConfig.IntroText, 14), {
			Parent = Orion,
			Size = UDim2.new(1, 0, 1, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 19, 0.5, 0),
			TextXAlignment = Enum.TextXAlignment.Center,
			Font = Enum.Font.GothamBold,
			TextTransparency = 1
		})
		TweenService:Create(LoadSequenceLogo, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0, Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
		task.wait(0.8)
		TweenService:Create(LoadSequenceLogo, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -(LoadSequenceText.TextBounds.X/2), 0.5, 0)}):Play()
		task.wait(0.3)
		TweenService:Create(LoadSequenceText, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
		task.wait(2)
		TweenService:Create(LoadSequenceText, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
		MainWindow.Visible = true
		LoadSequenceLogo:Destroy()
		LoadSequenceText:Destroy()
	end 

	if WindowConfig.IntroEnabled then
		LoadSequence()
	end

	local ActiveTabFrame = nil
	local ActiveTabContainer = nil
	local CMOpen = false

	local AllRegisteredTabs = {}
	local DefaultSectionLayout = {}
	local CurrentSectionLayout = {}

	local GOLD = Color3.fromRGB(255, 239, 149)
	local GREEN_OK = Color3.fromRGB(100, 220, 120)
	local RED_DELETE = Color3.fromRGB(220, 80, 80)
	local WHITE = Color3.fromRGB(255, 255, 255)
	local RENAME_ICON = "rbxassetid://98359085392262"
	local DELETE_ICON = "rbxassetid://14002617467"
	local CONFIG_ICON = "rbxassetid://12392896984"

	local TWEEN_FAST = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local TWEEN_MED = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local TWEEN_SLOW = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local TWEEN_SPRING = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	local State = {
		isOpen = false,
		activeModal = nil,
		modalCallback = nil,
		pendingRename = nil,
	}

	local function Tween(obj, info, props)
		if obj and obj.Parent then
			TweenService:Create(obj, info, props):Play()
		end
	end

	local function GetTheme()
		return OrionLib.Themes[OrionLib.SelectedTheme]
	end

	local function BrightenColor(color, amount)
		local r = math.clamp(color.R * 255 + amount, 0, 255)
		local g = math.clamp(color.G * 255 + amount, 0, 255)
		local b = math.clamp(color.B * 255 + amount, 0, 255)
		return Color3.fromRGB(r, g, b)
	end

	local function CreateAnimatedButton(config)
		Breathe()
		local radius = config.CornerRadius or 6
		local btnBase = GetTheme().Second

local Frame = Instance.new("Frame")
		Frame.Size = config.Size
		Frame.Position = config.Position or UDim2.new(0, 0, 0, 0)
		Frame.AnchorPoint = config.AnchorPoint or Vector2.new(0, 0)
		Frame.BackgroundColor3 = btnBase
		Frame.BorderSizePixel = 0
		Frame.ZIndex = (config.BaseZIndex or 0) + 1
		Frame.Parent = config.Parent

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, radius)
		corner.Parent = Frame

		local Stroke = Instance.new("UIStroke")
		Stroke.Color = GetTheme().Stroke
		Stroke.Thickness = 1
		Stroke.Parent = Frame

local Click = Instance.new("TextButton")
		Click.Size = UDim2.new(1, 0, 1, 0)
		Click.BackgroundTransparency = 1
		Click.Text = ""
		Click.AutoButtonColor = false
		Click.ZIndex = (config.BaseZIndex or 0) + 2
		Click.Parent = Frame

		if config.IconId then
			local Ico = Instance.new("ImageLabel")
			Ico.Size = UDim2.new(0, 13, 0, 13)
			Ico.AnchorPoint = Vector2.new(0.5, 0.5)
			Ico.Position = UDim2.new(0.5, 0, 0.5, 0)
			Ico.BackgroundTransparency = 1
			Ico.Image = config.IconId
			Ico.ImageColor3 = config.IconColor or WHITE
			Ico.ZIndex = 3
			Ico.Name = "Icon"
			Ico.Parent = Frame
		end

local Lbl = nil
		if config.Label then
			Lbl = Instance.new("TextLabel")
			Lbl.Size = UDim2.new(1, 0, 1, 0)
			Lbl.BackgroundTransparency = 1
			Lbl.Text = config.Label
			Lbl.TextColor3 = config.LabelColor or GOLD
			Lbl.Font = Enum.Font.GothamBold
			Lbl.TextSize = config.FontSize or 11
			Lbl.TextXAlignment = Enum.TextXAlignment.Center
			Lbl.ZIndex = (config.BaseZIndex or 0) + 3
			Lbl.Name = "Lbl"
			Lbl.Parent = Frame
		end

		AddConnection(Click.MouseEnter, function()
			Tween(Frame, TWEEN_FAST, {BackgroundColor3 = BrightenColor(btnBase, 8)})
			Tween(Stroke, TWEEN_FAST, {Color = BrightenColor(GetTheme().Stroke, 20)})
		end)
		AddConnection(Click.MouseLeave, function()
			Tween(Frame, TWEEN_FAST, {BackgroundColor3 = btnBase})
			Tween(Stroke, TWEEN_FAST, {Color = GetTheme().Stroke})
		end)
		AddConnection(Click.MouseButton1Down, function()
			Tween(Frame, TWEEN_FAST, {BackgroundColor3 = BrightenColor(btnBase, 14)})
		end)
		AddConnection(Click.MouseButton1Up, function()
			Tween(Frame, TWEEN_FAST, {BackgroundColor3 = BrightenColor(btnBase, 8)})
		end)

		local API = {}

		function API:SetLabel(text, color)
			if Lbl then
				Lbl.Text = text
				if color then Lbl.TextColor3 = color end
			end
		end

		function API:SetIconColor(color)
			local ico = Frame:FindFirstChild("Icon")
			if ico then ico.ImageColor3 = color end
		end

		function API:OnClick(fn)
			AddConnection(Click.MouseButton1Up, fn)
		end

		return Frame, Click, API
	end

	local function CreateSectionLabel(parent, text)
		Breathe()
		local wrap = Instance.new("Frame")
		wrap.Size = UDim2.new(1, 0, 0, 22)
		wrap.BackgroundTransparency = 1
		wrap.Parent = parent

		local bar = Instance.new("Frame")
		bar.Size = UDim2.new(0, 2, 0, 12)
		bar.AnchorPoint = Vector2.new(0, 0.5)
		bar.Position = UDim2.new(0, 0, 0.5, 0)
		bar.BackgroundColor3 = GOLD
		bar.BorderSizePixel = 0
		bar.Parent = wrap
		local bc = Instance.new("UICorner")
		bc.CornerRadius = UDim.new(0, 2)
		bc.Parent = bar

		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(1, -12, 1, 0)
		lbl.Position = UDim2.new(0, 10, 0, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text = text
		lbl.TextColor3 = GOLD
		lbl.TextTransparency = 0
		lbl.Font = Enum.Font.GothamBold
		lbl.TextSize = 10
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.Parent = wrap

		return wrap
	end

	local ModalDim = nil
	local ModalFrame = nil
	local ModalOpen = false

	local function DestroyModal()
		if not ModalDim then return end
		ModalDim.Visible = false
		local dimRef = ModalDim
		local frameRef = ModalFrame
		ModalDim = nil
		ModalFrame = nil
		ModalOpen = false
		State.activeModal = nil
		State.modalCallback = nil
		State.pendingRename = nil
		if frameRef and frameRef.Parent then
			Tween(frameRef, TWEEN_MED, {
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0.6, 0),
			})
		end
		task.delay(0.3, function()
			if dimRef and dimRef.Parent then dimRef:Destroy() end
			if frameRef and frameRef.Parent then frameRef:Destroy() end
		end)
	end

	local function CreateModalBase(titleText, height)
		Breathe()
		if ModalDim then ModalDim:Destroy(); ModalDim = nil end
		if ModalFrame then ModalFrame:Destroy(); ModalFrame = nil end

		ModalDim = Instance.new("Frame")
		ModalDim.Size = UDim2.new(1, 0, 1, 0)
		ModalDim.Position = UDim2.new(0, 0, 0, 0)
		ModalDim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		ModalDim.BackgroundTransparency = 1
		ModalDim.ZIndex = 20
		ModalDim.Parent = MainWindow

		local dimBtn = Instance.new("TextButton")
		dimBtn.Size = UDim2.new(1, 0, 1, 0)
		dimBtn.BackgroundTransparency = 1
		dimBtn.Text = ""
		dimBtn.AutoButtonColor = false
		dimBtn.ZIndex = 20
		dimBtn.Parent = ModalDim
		AddConnection(dimBtn.MouseButton1Up, function() DestroyModal() end)

		ModalFrame = Instance.new("Frame")
		ModalFrame.Size = UDim2.new(0, 260, 0, height)
		ModalFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		ModalFrame.Position = UDim2.new(0.5, 0, 0.54, 0)
		ModalFrame.BackgroundColor3 = GetTheme().Second
		ModalFrame.BackgroundTransparency = 1
		ModalFrame.BorderSizePixel = 0
		ModalFrame.ZIndex = 21
		ModalFrame.Parent = ModalDim

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 10)
		corner.Parent = ModalFrame

		local stroke = Instance.new("UIStroke")
		stroke.Color = GetTheme().Stroke
		stroke.Thickness = 1
		stroke.Parent = ModalFrame

		local topBar = Instance.new("Frame")
		topBar.Size = UDim2.new(1, 0, 0, 3)
		topBar.Position = UDim2.new(0, 0, 0, 0)
		topBar.BackgroundColor3 = GOLD
		topBar.BorderSizePixel = 0
		topBar.ZIndex = 22
		topBar.Parent = ModalFrame
		local topC = Instance.new("UICorner")
		topC.CornerRadius = UDim.new(0, 10)
		topC.Parent = topBar

		local title = Instance.new("TextLabel")
		title.Size = UDim2.new(1, -20, 0, 18)
		title.Position = UDim2.new(0, 14, 0, 16)
		title.BackgroundTransparency = 1
		title.Text = titleText
		title.TextColor3 = WHITE
		title.Font = Enum.Font.GothamBold
		title.TextSize = 13
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.ZIndex = 22
		title.Parent = ModalFrame

		Tween(ModalDim, TWEEN_MED, {BackgroundTransparency = 0.55})
		Tween(ModalFrame, TWEEN_SPRING, {
			BackgroundTransparency = 0,
			Position = UDim2.new(0.5, 0, 0.44, 0),
		})

		ModalOpen = true
		return ModalFrame
	end

	local function ShowConfirmModal(message, onConfirm)
		State.activeModal = "confirm"
		State.modalCallback = onConfirm

		local card = CreateModalBase("Confirm Action", 115)

		local msg = Instance.new("TextLabel")
		msg.Size = UDim2.new(1, -28, 0, 28)
		msg.Position = UDim2.new(0, 14, 0, 40)
		msg.BackgroundTransparency = 1
		msg.Text = message
		msg.TextColor3 = Color3.fromRGB(200, 200, 205)
		msg.Font = Enum.Font.GothamSemibold
		msg.TextSize = 12
		msg.TextWrapped = true
		msg.TextXAlignment = Enum.TextXAlignment.Left
		msg.ZIndex = 22
		msg.Parent = card

		local btnRow = Instance.new("Frame")
		btnRow.Size = UDim2.new(1, -28, 0, 30)
		btnRow.Position = UDim2.new(0, 14, 0, 74)
		btnRow.BackgroundTransparency = 1
		btnRow.ZIndex = 22
		btnRow.Parent = card

local confirmFrame, confirmClick, confirmAPI = CreateAnimatedButton({
			Parent = btnRow,
			Size = UDim2.new(0.47, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			Label = "Confirm",
			FontSize = 12,
			LabelColor = GOLD,
			CornerRadius = 6,
			BaseZIndex = 21,
		})
		confirmFrame.ZIndex = 22
		confirmClick.ZIndex = 23
		local cLbl = confirmFrame:FindFirstChild("Lbl")
		if cLbl then cLbl.ZIndex = 24 end
		local cStroke = confirmFrame:FindFirstChildOfClass("UIStroke")
		if cStroke then cStroke.Color = Color3.fromRGB(100, 90, 40) end

local cancelFrame, cancelClick, cancelAPI = CreateAnimatedButton({
			Parent = btnRow,
			Size = UDim2.new(0.47, 0, 1, 0),
			Position = UDim2.new(0.53, 0, 0, 0),
			Label = "Cancel",
			FontSize = 12,
			LabelColor = Color3.fromRGB(150, 150, 160),
			CornerRadius = 6,
			BaseZIndex = 21,
		})
		cancelFrame.ZIndex = 22
		cancelClick.ZIndex = 23
		local xLbl = cancelFrame:FindFirstChild("Lbl")
		if xLbl then xLbl.ZIndex = 24 end

		AddConnection(confirmClick.MouseButton1Up, function()
			local cb = State.modalCallback
			DestroyModal()
			if cb then task.spawn(cb) end
		end)
		AddConnection(cancelClick.MouseButton1Up, function()
			DestroyModal()
		end)
	end

	local function ShowRenameModal(oldName, onRename)
		State.activeModal = "rename"
		State.pendingRename = oldName

		local card = CreateModalBase("Rename Config", 130)

		local sub = Instance.new("TextLabel")
		sub.Size = UDim2.new(1, -28, 0, 14)
		sub.Position = UDim2.new(0, 14, 0, 40)
		sub.BackgroundTransparency = 1
		sub.Text = 'Renaming: "' .. oldName .. '"'
		sub.TextColor3 = Color3.fromRGB(150, 150, 160)
		sub.Font = Enum.Font.Gotham
		sub.TextSize = 11
		sub.TextXAlignment = Enum.TextXAlignment.Left
		sub.ZIndex = 22
		sub.Parent = card

		local inputBg = Instance.new("Frame")
		inputBg.Size = UDim2.new(1, -28, 0, 30)
		inputBg.Position = UDim2.new(0, 14, 0, 60)
		inputBg.BackgroundColor3 = GetTheme().Main
		inputBg.BorderSizePixel = 0
		inputBg.ZIndex = 22
		inputBg.Parent = card
		local ibCorner = Instance.new("UICorner")
		ibCorner.CornerRadius = UDim.new(0, 6)
		ibCorner.Parent = inputBg
		local ibStroke = Instance.new("UIStroke")
		ibStroke.Color = GetTheme().Stroke
		ibStroke.Thickness = 1
		ibStroke.Parent = inputBg

		local inputBox = Instance.new("TextBox")
		inputBox.Size = UDim2.new(1, -14, 1, 0)
		inputBox.Position = UDim2.new(0, 10, 0, 0)
		inputBox.BackgroundTransparency = 1
		inputBox.Text = oldName
		inputBox.TextColor3 = WHITE
		inputBox.PlaceholderText = "New name..."
		inputBox.PlaceholderColor3 = Color3.fromRGB(110, 110, 125)
		inputBox.Font = Enum.Font.Gotham
		inputBox.TextSize = 12
		inputBox.TextXAlignment = Enum.TextXAlignment.Left
		inputBox.ClearTextOnFocus = false
		inputBox.ZIndex = 23
		inputBox.Parent = inputBg

		AddConnection(inputBox.Focused, function()
			Tween(ibStroke, TWEEN_FAST, {Color = GOLD})
		end)
		AddConnection(inputBox.FocusLost, function()
			Tween(ibStroke, TWEEN_FAST, {Color = GetTheme().Stroke})
		end)

		local btnRow = Instance.new("Frame")
		btnRow.Size = UDim2.new(1, -28, 0, 30)
		btnRow.Position = UDim2.new(0, 14, 0, 96)
		btnRow.BackgroundTransparency = 1
		btnRow.ZIndex = 22
		btnRow.Parent = card

local renameFrame, renameClick, renameAPI = CreateAnimatedButton({
			Parent = btnRow,
			Size = UDim2.new(0.47, 0, 1, 0),
			Label = "Rename",
			FontSize = 12,
			LabelColor = GOLD,
			CornerRadius = 6,
			BaseZIndex = 21,
		})
		renameFrame.ZIndex = 22
		renameClick.ZIndex = 23
		local rLbl = renameFrame:FindFirstChild("Lbl")
		if rLbl then rLbl.ZIndex = 24 end

local cancelFrame, cancelClick = CreateAnimatedButton({
			Parent = btnRow,
			Size = UDim2.new(0.47, 0, 1, 0),
			Position = UDim2.new(0.53, 0, 0, 0),
			Label = "Cancel",
			FontSize = 12,
			LabelColor = Color3.fromRGB(150, 150, 160),
			CornerRadius = 6,
			BaseZIndex = 21,
		})
		cancelFrame.ZIndex = 22
		cancelClick.ZIndex = 23
		local xLbl = cancelFrame:FindFirstChild("Lbl")
		if xLbl then xLbl.ZIndex = 24 end

		task.delay(0.2, function()
			if inputBox and inputBox.Parent then
				inputBox:CaptureFocus()
				inputBox.CursorPosition = #inputBox.Text + 1
			end
		end)

		AddConnection(renameClick.MouseButton1Up, function()
			local newName = inputBox.Text:match("^%s*(.-)%s*$")
			local pending = State.pendingRename
			DestroyModal()
			if newName ~= "" and newName ~= "Default" and onRename then
				onRename(pending, newName)
			end
		end)
		AddConnection(cancelClick.MouseButton1Up, function()
			DestroyModal()
		end)
		AddConnection(inputBox.FocusLost, function(enterPressed)
			if enterPressed then
				local newName = inputBox.Text:match("^%s*(.-)%s*$")
				local pending = State.pendingRename
				DestroyModal()
				if newName ~= "" and newName ~= "Default" and onRename then
					onRename(pending, newName)
				end
			end
		end)
	end

	local function CreateConfigRow(parent, configName, callbacks)
		Breathe()
		local isDefault = (configName == "Main.lua (Default)")
		local isActive = (configName == CM.CurrentConfig)
		local theme = GetTheme()

		local RowFrame = Instance.new("Frame")
		RowFrame.Size = UDim2.new(1, 0, 0, 38)
		RowFrame.BackgroundColor3 = theme.Second
		RowFrame.BorderSizePixel = 0
		RowFrame.Name = "CMRow_" .. configName
		RowFrame.BackgroundTransparency = 1
		RowFrame.Parent = parent

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 7)
		corner.Parent = RowFrame

		local stroke = Instance.new("UIStroke")
		stroke.Color = theme.Stroke
		stroke.Thickness = 1
		stroke.Parent = RowFrame

		Tween(RowFrame, TWEEN_MED, {BackgroundTransparency = 0})

		local rowBtn = Instance.new("TextButton")
		rowBtn.Size = UDim2.new(1, 0, 1, 0)
		rowBtn.BackgroundTransparency = 1
		rowBtn.Text = ""
		rowBtn.AutoButtonColor = false
		rowBtn.ZIndex = 1
		rowBtn.Parent = RowFrame

		local ActiveBar = Instance.new("Frame")
		ActiveBar.Name = "ActiveBar"
		ActiveBar.Size = UDim2.new(0, 3, 0, isActive and 22 or 0)
		ActiveBar.Position = UDim2.new(0, 0, 0.5, 0)
		ActiveBar.AnchorPoint = Vector2.new(0, 0.5)
		ActiveBar.BackgroundColor3 = GOLD
		ActiveBar.BorderSizePixel = 0
		ActiveBar.ZIndex = 2
		ActiveBar.Parent = RowFrame
		local abCorner = Instance.new("UICorner")
		abCorner.CornerRadius = UDim.new(0, 2)
		abCorner.Parent = ActiveBar

		local nameRightPad = isDefault and -68 or -118
		local NameLabel = Instance.new("TextLabel")
		NameLabel.Name = "NameLabel"
		NameLabel.Size = UDim2.new(1, nameRightPad, 1, 0)
		NameLabel.Position = UDim2.new(0, 14, 0, 0)
		NameLabel.BackgroundTransparency = 1
		NameLabel.Text = configName
		NameLabel.TextColor3 = isActive and GOLD or theme.Text
		NameLabel.Font = isActive and Enum.Font.GothamBold or Enum.Font.GothamSemibold
		NameLabel.TextSize = 13
		NameLabel.TextXAlignment = Enum.TextXAlignment.Left
		NameLabel.ClipsDescendants = false
		NameLabel.ZIndex = 2
		NameLabel.Parent = RowFrame

		local loadFrame, loadClick, loadAPI = CreateAnimatedButton({
			Parent = RowFrame,
			Size = UDim2.new(0, 48, 0, 24),
			Position = UDim2.new(1, -58, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Label = "Load",
			FontSize = 11,
			LabelColor = GOLD,
			CornerRadius = 5,
		})
		loadFrame.ZIndex = 5
		loadClick.ZIndex = 6
		local loadLbl = loadFrame:FindFirstChild("Lbl")
		if loadLbl then loadLbl.ZIndex = 7 end

		if not isDefault then
			local renameFrame, renameClick, renameAPI = CreateAnimatedButton({
				Parent = RowFrame,
				Size = UDim2.new(0, 24, 0, 24),
				Position = UDim2.new(1, -112, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				IconId = RENAME_ICON,
				IconColor = Color3.fromRGB(160, 160, 175),
				CornerRadius = 5,
			})
			renameFrame.ZIndex = 5
			renameClick.ZIndex = 6
			local rnIco = renameFrame:FindFirstChild("Icon")
			if rnIco then rnIco.ZIndex = 7 end

			local deleteFrame, deleteClick, deleteAPI = CreateAnimatedButton({
				Parent = RowFrame,
				Size = UDim2.new(0, 24, 0, 24),
				Position = UDim2.new(1, -84, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				IconId = DELETE_ICON,
				IconColor = RED_DELETE,
				CornerRadius = 5,
			})
			deleteFrame.ZIndex = 5
			deleteClick.ZIndex = 6
			local dlIco = deleteFrame:FindFirstChild("Icon")
			if dlIco then dlIco.ZIndex = 7 end

			AddConnection(renameClick.MouseButton1Up, function()
				if callbacks.onRename then callbacks.onRename(configName) end
			end)
			AddConnection(deleteClick.MouseButton1Up, function()
				if callbacks.onDelete then callbacks.onDelete(configName) end
			end)
		end

		AddConnection(rowBtn.MouseEnter, function()
			Tween(RowFrame, TWEEN_FAST, {BackgroundColor3 = BrightenColor(GetTheme().Second, 5)})
		end)
		AddConnection(rowBtn.MouseLeave, function()
			Tween(RowFrame, TWEEN_FAST, {BackgroundColor3 = GetTheme().Second})
		end)
		AddConnection(loadClick.MouseButton1Up, function()
			if callbacks.onLoad then callbacks.onLoad(configName) end
		end)

		local RowAPI = {}

		function RowAPI:SetActive(active)
			Tween(ActiveBar, TWEEN_MED, {Size = UDim2.new(0, 3, 0, active and 22 or 0)})
			Tween(NameLabel, TWEEN_FAST, {TextColor3 = active and GOLD or GetTheme().Text})
			NameLabel.Font = active and Enum.Font.GothamBold or Enum.Font.GothamSemibold
		end

		function RowAPI:GetFrame()
			return RowFrame
		end

		function RowAPI:Rename(newName)
			NameLabel.Text = newName
			RowFrame.Name = "CMRow_" .. newName
		end

		function RowAPI:Destroy()
			Tween(RowFrame, TWEEN_FAST, {BackgroundTransparency = 1})
			task.delay(0.2, function()
				if RowFrame and RowFrame.Parent then RowFrame:Destroy() end
			end)
		end

		return RowAPI
	end

	local function CreateActiveConfigBanner(parent)
		Breathe()
		local theme = GetTheme()

		local Banner = Instance.new("Frame")
		Banner.Size = UDim2.new(1, 0, 0, 44)
		Banner.BackgroundColor3 = theme.Second
		Banner.BorderSizePixel = 0
		Banner.Parent = parent

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = Banner

		local stroke = Instance.new("UIStroke")
		stroke.Color = theme.Stroke
		stroke.Thickness = 1
		stroke.Parent = Banner

		local accentBar = Instance.new("Frame")
		accentBar.Size = UDim2.new(0, 3, 0, 24)
		accentBar.AnchorPoint = Vector2.new(0, 0.5)
		accentBar.Position = UDim2.new(0, 0, 0.5, 0)
		accentBar.BackgroundColor3 = GOLD
		accentBar.BorderSizePixel = 0
		accentBar.Parent = Banner
		local ac = Instance.new("UICorner")
		ac.CornerRadius = UDim.new(0, 2)
		ac.Parent = accentBar

		local ico = Instance.new("ImageLabel")
		ico.Size = UDim2.new(0, 15, 0, 15)
		ico.AnchorPoint = Vector2.new(0, 0.5)
		ico.Position = UDim2.new(0, 14, 0.5, 0)
		ico.BackgroundTransparency = 1
		ico.Image = CONFIG_ICON
		ico.ImageColor3 = GOLD
		ico.ImageTransparency = 0.1
		ico.Parent = Banner

		local prefix = Instance.new("TextLabel")
		prefix.Size = UDim2.new(0, 42, 1, 0)
		prefix.Position = UDim2.new(0, 34, 0, 0)
		prefix.BackgroundTransparency = 1
		prefix.Text = "Active:"
		prefix.TextColor3 = theme.TextDark
		prefix.TextTransparency = 0.4
		prefix.Font = Enum.Font.GothamSemibold
		prefix.TextSize = 12
		prefix.TextXAlignment = Enum.TextXAlignment.Left
		prefix.Parent = Banner

		local NameLbl = Instance.new("TextLabel")
		NameLbl.Name = "ActiveName"
		NameLbl.Size = UDim2.new(1, -148, 1, 0)
		NameLbl.Position = UDim2.new(0, 84, 0, 0)
		NameLbl.BackgroundTransparency = 1
		NameLbl.Text = CM.CurrentConfig
		NameLbl.TextColor3 = GOLD
		NameLbl.Font = Enum.Font.GothamBold
		NameLbl.TextSize = 13
		NameLbl.TextXAlignment = Enum.TextXAlignment.Left
		NameLbl.ClipsDescendants = true
		NameLbl.Parent = Banner

		local saveFrame, saveClick, saveAPI = CreateAnimatedButton({
			Parent = Banner,
			Size = UDim2.new(0, 62, 0, 26),
			Position = UDim2.new(1, -70, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Label = "Save",
			FontSize = 11,
			LabelColor = GOLD,
			CornerRadius = 6,
		})
		local saveSt = saveFrame:FindFirstChildOfClass("UIStroke")
		if saveSt then
			saveSt.Color = Color3.fromRGB(90, 80, 30)
			saveSt.Transparency = 0.4
		end
		local saveLbl = saveFrame:FindFirstChild("Lbl")
		if saveLbl then saveLbl.ZIndex = 7 end

		local saving = false
		AddConnection(saveClick.MouseButton1Up, function()
			if saving then return end
			saving = true
			pcall(function() CMSaveFlagsToFile(CM.CurrentConfig) end)
			saveAPI:SetLabel("✓  Saved", GREEN_OK)
			task.delay(1.5, function()
				saveAPI:SetLabel("Save", GOLD)
				saving = false
			end)
		end)

		CM.ActiveConfigLabel = NameLbl

		local BannerAPI = {}
		function BannerAPI:UpdateName(name)
			if NameLbl and NameLbl.Parent then
				NameLbl.Text = name
			end
		end

		return Banner, BannerAPI
	end

	local function CreateNewConfigRow(parent, onCreate)
		Breathe()
		local theme = GetTheme()

		local Wrap = Instance.new("Frame")
		Wrap.Size = UDim2.new(1, 0, 0, 38)
		Wrap.BackgroundColor3 = theme.Second
		Wrap.BorderSizePixel = 0
		Wrap.Parent = parent

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 7)
		corner.Parent = Wrap

		local stroke = Instance.new("UIStroke")
		stroke.Color = theme.Stroke
		stroke.Thickness = 1
		stroke.Parent = Wrap

		local pad = Instance.new("UIPadding")
		pad.PaddingLeft = UDim.new(0, 8)
		pad.PaddingRight = UDim.new(0, 8)
		pad.PaddingTop = UDim.new(0, 0)
		pad.PaddingBottom = UDim.new(0, 0)
		pad.Parent = Wrap

		local inputBg = Instance.new("Frame")
		inputBg.Size = UDim2.new(1, -96, 0, 26)
		inputBg.AnchorPoint = Vector2.new(0, 0.5)
		inputBg.Position = UDim2.new(0, 0, 0.5, 0)
		inputBg.BackgroundColor3 = theme.Main
		inputBg.BorderSizePixel = 0
		inputBg.Parent = Wrap
		local ibC = Instance.new("UICorner")
		ibC.CornerRadius = UDim.new(0, 5)
		ibC.Parent = inputBg
		local ibSt = Instance.new("UIStroke")
		ibSt.Color = theme.Stroke
		ibSt.Thickness = 1
		ibSt.Parent = inputBg

		local inputBox = Instance.new("TextBox")
		inputBox.Size = UDim2.new(1, -10, 1, 0)
		inputBox.Position = UDim2.new(0, 8, 0, 0)
		inputBox.BackgroundTransparency = 1
		inputBox.Text = ""
		inputBox.TextColor3 = WHITE
		inputBox.PlaceholderText = "discord.gg/beanzhub..."
		inputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 115)
		inputBox.Font = Enum.Font.Gotham
		inputBox.TextSize = 12
		inputBox.TextXAlignment = Enum.TextXAlignment.Left
		inputBox.ClearTextOnFocus = false
		inputBox.Parent = inputBg

		AddConnection(inputBox.Focused, function()
			Tween(ibSt, TWEEN_FAST, {Color = GOLD})
		end)
		AddConnection(inputBox.FocusLost, function()
			Tween(ibSt, TWEEN_FAST, {Color = theme.Stroke})
		end)

		local createFrame, createClick, createAPI = CreateAnimatedButton({
			Parent = Wrap,
			Size = UDim2.new(0, 84, 0, 26),
			Position = UDim2.new(1, -84, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Label = "+ Create",
			FontSize = 11,
			LabelColor = GOLD,
			CornerRadius = 5,
		})
		local crLbl = createFrame:FindFirstChild("Lbl")
		if crLbl then crLbl.ZIndex = 7 end

		local function TryCreate()
			local name = inputBox.Text:match("^%s*(.-)%s*$")
			if name == "" or CM.ConfigButtons[name] then return end
			inputBox.Text = ""
			if onCreate then onCreate(name) end
		end

		AddConnection(createClick.MouseButton1Up, TryCreate)
		AddConnection(inputBox.FocusLost, function(enter)
			if enter then TryCreate() end
		end)

		return Wrap
	end

	local function CreateEmptyState(parent)
		Breathe()
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, 56)
		frame.BackgroundTransparency = 1
		frame.Name = "EmptyState"
		frame.Parent = parent

		local icon = Instance.new("TextLabel")
		icon.Size = UDim2.new(1, 0, 0, 24)
		icon.Position = UDim2.new(0, 0, 0, 4)
		icon.BackgroundTransparency = 1
		icon.Text = "📂"
		icon.TextSize = 18
		icon.Font = Enum.Font.Gotham
		icon.TextXAlignment = Enum.TextXAlignment.Center
		icon.Parent = frame

		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(1, 0, 0, 14)
		lbl.Position = UDim2.new(0, 0, 0, 32)
		lbl.BackgroundTransparency = 1
		lbl.Text = "No saved configs yet"
		lbl.TextColor3 = Color3.fromRGB(120, 120, 130)
		lbl.TextTransparency = 0.3
		lbl.Font = Enum.Font.GothamSemibold
		lbl.TextSize = 12
		lbl.TextXAlignment = Enum.TextXAlignment.Center
		lbl.Parent = frame

		return frame
	end

	local function CMOpenPanel()
		for _, child in ipairs(MainWindow:GetChildren()) do
			if child.Name == "ItemContainer" then
				child.Visible = false
			end
		end
		for _, tab in ipairs(TabHolder:GetChildren()) do
			if tab:IsA("TextButton") then
				if tab:FindFirstChild("Title") then
					tab.Title.Font = Enum.Font.GothamSemibold
					tab.Title.TextColor3 = GetTheme().Text
					tab.Title.TextTransparency = 0.4
				end
				if tab:FindFirstChild("Ico") then
					tab.Ico.ImageColor3 = GetTheme().Text
					tab.Ico.ImageTransparency = 0.4
				end
			end
		end
		local ico = ConfigTopBtn:FindFirstChild("Ico")
		if ico then
			ico.ImageColor3 = GOLD
			ico.ImageTransparency = 0
		end
	end

	local function CMClosePanel()
		local ico = ConfigTopBtn:FindFirstChild("Ico")
		if ico then
			ico.ImageColor3 = GetTheme().Text
		end
		if ActiveTabFrame then
			if ActiveTabFrame:FindFirstChild("Title") then
				ActiveTabFrame.Title.Font = Enum.Font.GothamBlack
				ActiveTabFrame.Title.TextColor3 = GOLD
				ActiveTabFrame.Title.TextTransparency = 0
			end
			if ActiveTabFrame:FindFirstChild("Ico") then
				ActiveTabFrame.Ico.ImageColor3 = GOLD
				ActiveTabFrame.Ico.ImageTransparency = 0
			end
		end
	end

	local CMContainer = Instance.new("ScrollingFrame")
	CMContainer.Size = UDim2.new(1, -150, 1, -50)
	CMContainer.Position = UDim2.new(0, 150, 0, 50)
	CMContainer.BackgroundTransparency = 1
	CMContainer.ScrollBarThickness = 3
	CMContainer.ScrollBarImageColor3 = GetTheme().Divider
	CMContainer.BorderSizePixel = 0
	CMContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
	CMContainer.Visible = false
	CMContainer.Name = "ItemContainer"
	CMContainer.Parent = MainWindow

	local CMMinimizedState = false
	AddConnection(MinimizeBtn.MouseButton1Up, function()
		CMMinimizedState = not CMMinimizedState
		if CMMinimizedState then
			CMContainer.Visible = false
			ConfigTopBtn.Visible = false
			TopBarBtnGroup.Div2.Visible = false
			MinimizeBtn.Position = UDim2.new(0, 0, 0, 0)
			TopBarBtnGroup.Size = UDim2.new(0, 72, 0, 30)
			TopBarBtnGroup.Position = UDim2.new(1, -82, 0, 10)
		else
			CMContainer.Visible = CMOpen
			ConfigTopBtn.Visible = true
			TopBarBtnGroup.Div2.Visible = true
			MinimizeBtn.Position = UDim2.new(0, 36, 0, 0)
			TopBarBtnGroup.Size = UDim2.new(0, 108, 0, 30)
			TopBarBtnGroup.Position = UDim2.new(1, -118, 0, 10)
		end
	end)

	local topGrad = Instance.new("UIGradient")
	topGrad.Rotation = 90
	topGrad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.7),
		NumberSequenceKeypoint.new(0.06, 0),
		NumberSequenceKeypoint.new(1, 0),
	})
	topGrad.Parent = CMContainer

	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 6)
	listLayout.Parent = CMContainer

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	padding.PaddingTop = UDim.new(0, 14)
	padding.PaddingBottom = UDim.new(0, 14)
	padding.Parent = CMContainer

	AddConnection(listLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		CMContainer.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 28)
	end)

	local activeConfigLabel = CreateSectionLabel(CMContainer, "ACTIVE CONFIG")
	activeConfigLabel.LayoutOrder = 0
	local activeBanner, BannerAPI = CreateActiveConfigBanner(CMContainer)
	activeBanner.LayoutOrder = 1

	local newConfigSectionLabel = CreateSectionLabel(CMContainer, "NEW CONFIG")
	newConfigSectionLabel.LayoutOrder = 2

	local ConfigList = Instance.new("Frame")
	ConfigList.Size = UDim2.new(1, 0, 0, 0)
	ConfigList.BackgroundTransparency = 1
	ConfigList.Name = "ConfigList"
	ConfigList.LayoutOrder = 5
	ConfigList.Parent = CMContainer

	local configListLayout = Instance.new("UIListLayout")
	configListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	configListLayout.Padding = UDim.new(0, 6)
	configListLayout.Parent = ConfigList

	AddConnection(configListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		ConfigList.Size = UDim2.new(1, 0, 0, configListLayout.AbsoluteContentSize.Y)
	end)

	local RowAPIs = {}
	local EmptyFrame = nil

	local function RefreshEmptyState()
		local count = 0
		for k, _ in pairs(CM.ConfigButtons) do
			if k ~= "Default" then count = count + 1 end
		end
		if count == 0 then
			if not EmptyFrame or not EmptyFrame.Parent then
				EmptyFrame = CreateEmptyState(ConfigList)
			end
		else
			if EmptyFrame and EmptyFrame.Parent then
				EmptyFrame:Destroy()
				EmptyFrame = nil
			end
		end
	end

	local function UpdateAllActiveIndicators()
		for name, api in pairs(RowAPIs) do
			api:SetActive(name == CM.CurrentConfig)
		end
		BannerAPI:UpdateName(CM.CurrentConfig)
		if CM.ActiveConfigLabel then
			CM.ActiveConfigLabel.Text = CM.CurrentConfig
		end
	end

	local function RemoveConfigRow(name)
		if RowAPIs[name] then
			RowAPIs[name]:Destroy()
			RowAPIs[name] = nil
		end
		CM.ConfigButtons[name] = nil
		task.delay(0.25, RefreshEmptyState)
	end

	local function AddConfigRow(configName)
		Breathe()
		if CM.ConfigButtons[configName] then return end

		local nameRef = {current = configName}

		local api = CreateConfigRow(ConfigList, configName, {
			onLoad = function(_name)
				local liveName = nameRef.current
				if liveName == CM.CurrentConfig then return end
				ShowConfirmModal('Load config "' .. liveName .. '"?', function()
					CMSwitchConfig(liveName, function()
						UpdateAllActiveIndicators()
					end)
				end)
			end,
			onRename = (configName ~= "Main.lua (Default)") and function(_name)
				local oldName = nameRef.current
				ShowRenameModal(oldName, function(_, newName)
					if CM.ConfigButtons[newName] then return end
					pcall(function()
						local op = CMGetConfigPath(oldName)
						local np = CMGetConfigPath(newName)
						if isfile(op) then
							writefile(np, readfile(op))
							delfile(op)
						end
					end)
					local rowAPI = RowAPIs[oldName]
					if rowAPI then
						rowAPI:Rename(newName)
						RowAPIs[newName] = rowAPI
						RowAPIs[oldName] = nil
					end
					CM.ConfigButtons[newName] = CM.ConfigButtons[oldName]
					CM.ConfigButtons[oldName] = nil
					if CM.CurrentConfig == oldName then
						CM.CurrentConfig = newName
					end
					nameRef.current = newName
					UpdateAllActiveIndicators()
				end)
			end or nil,
			onDelete = (configName ~= "Main.lua (Default)") and function(_name)
				local liveName = nameRef.current
				ShowConfirmModal('Delete config "' .. liveName .. '"?', function()
					if CM.CurrentConfig == liveName then
						CMResetAllFlags()
						CM.CurrentConfig = "Main.lua (Default)"
						local loaded = CMLoadFlagsFromFile("Main.lua (Default)")
						if not loaded then
							CMSaveFlagsToFile("Main.lua (Default)")
						end
						UpdateAllActiveIndicators()
					end
					pcall(function()
						local path = CMGetConfigPath(liveName)
						if isfile(path) then delfile(path) end
					end)
					RemoveConfigRow(liveName)
				end)
			end or nil,
		})

		CM.ConfigButtons[configName] = api:GetFrame()
		RowAPIs[configName] = api

		RefreshEmptyState()
	end

	local newConfigRowFrame = CreateNewConfigRow(CMContainer, function(name)
		CMEnsureFolder()
		pcall(function()
			writefile(CMGetConfigPath(name), "{}")
		end)
		AddConfigRow(name)
		local row = CM.ConfigButtons[name]
		if row then
			row.Size = UDim2.new(1, 0, 0, 0)
			Tween(row, TWEEN_SPRING, {Size = UDim2.new(1, 0, 0, 38)})
		end
	end)
	newConfigRowFrame.LayoutOrder = 3

	local configsSectionLabel = CreateSectionLabel(CMContainer, "CONFIGS")
	configsSectionLabel.LayoutOrder = 4

	local existingConfigs = CMGetAllConfigs()
	for i, name in ipairs(existingConfigs) do
		task.delay(i * 0.04, function()
			AddConfigRow(name)
		end)
	end

	task.delay(#existingConfigs * 0.04 + 0.05, function()
		UpdateAllActiveIndicators()
	end)

	local tabSectionsMgrLabel = CreateSectionLabel(CMContainer, "TAB SECTIONS")
	tabSectionsMgrLabel.LayoutOrder = 6

	local TabSectionMgrFrame = Instance.new("Frame")
	TabSectionMgrFrame.Size = UDim2.new(1, 0, 0, 0)
	TabSectionMgrFrame.BackgroundTransparency = 1
	TabSectionMgrFrame.Name = "TabSectionMgr"
	TabSectionMgrFrame.LayoutOrder = 7
	TabSectionMgrFrame.AutomaticSize = Enum.AutomaticSize.Y
	TabSectionMgrFrame.Parent = CMContainer

	local tabSectionMgrLayout = Instance.new("UIListLayout")
	tabSectionMgrLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabSectionMgrLayout.Padding = UDim.new(0, 6)
	tabSectionMgrLayout.Parent = TabSectionMgrFrame

	local TabSectionRows = {}
	local TabSectionData = {}

	local function SaveTabSections()
		pcall(function()
			local toSave = {}
			for _, entry in ipairs(TabSectionData) do
				table.insert(toSave, {
					sectionName = entry.sectionName,
					tabs = entry.tabs
				})
			end
			SaveTabSectionLayout(toSave)
		end)
	end

	local function RebuildTabHolderFromSections()
		Breathe()
		for _, child in ipairs(TabHolder:GetChildren()) do
			if child:IsA("Frame") and child.Name == "SectionLabel" then
				child:Destroy()
			end
		end

		local orderIndex = 1
		for _, entry in ipairs(TabSectionData) do
			local labelFrame = Instance.new("Frame")
			labelFrame.Name = "SectionLabel"
			labelFrame.Size = UDim2.new(1, 0, 0, 22)
			labelFrame.BackgroundTransparency = 1
			labelFrame.LayoutOrder = orderIndex
			labelFrame.Parent = TabHolder
			orderIndex += 1

			local bar = Instance.new("Frame")
			bar.Size = UDim2.new(0, 2, 0, 12)
			bar.AnchorPoint = Vector2.new(0, 0.5)
			bar.Position = UDim2.new(0, 10, 0.5, 0)
			bar.BackgroundColor3 = GOLD
			bar.BorderSizePixel = 0
			bar.Parent = labelFrame
			local bc = Instance.new("UICorner")
			bc.CornerRadius = UDim.new(0, 2)
			bc.Parent = bar

			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, -20, 1, 0)
			lbl.Position = UDim2.new(0, 18, 0, 0)
			lbl.BackgroundTransparency = 1
			lbl.Text = entry.sectionName
			lbl.TextColor3 = GOLD
			lbl.TextTransparency = 0
			lbl.Font = Enum.Font.GothamBold
			lbl.TextSize = 10
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = labelFrame

			for _, tabName in ipairs(entry.tabs) do
				for _, tabData in ipairs(AllRegisteredTabs) do
					if tabData.name == tabName and tabData.frame then
						tabData.frame.LayoutOrder = orderIndex
						orderIndex += 1
					end
				end
			end
		end

		local assignedTabs = {}
		for _, entry in ipairs(TabSectionData) do
			for _, tabName in ipairs(entry.tabs) do
				assignedTabs[tabName] = true
			end
		end
		for _, tabData in ipairs(AllRegisteredTabs) do
			if not assignedTabs[tabData.name] then
				tabData.frame.LayoutOrder = orderIndex
				orderIndex += 1
			end
		end
	end

	local function BuildTabSectionMgrUI()
		Breathe()
		for _, child in ipairs(TabSectionMgrFrame:GetChildren()) do
			if not child:IsA("UIListLayout") then
				child:Destroy()
			end
		end
		TabSectionRows = {}

		for sIdx, entry in ipairs(TabSectionData) do
			local sectionIdx = sIdx

			local SectionRow = Instance.new("Frame")
			SectionRow.Size = UDim2.new(1, 0, 0, 0)
			SectionRow.BackgroundColor3 = GetTheme().Second
			SectionRow.BorderSizePixel = 0
			SectionRow.AutomaticSize = Enum.AutomaticSize.Y
			SectionRow.LayoutOrder = sectionIdx
			SectionRow.Parent = TabSectionMgrFrame

			local sRowCorner = Instance.new("UICorner")
			sRowCorner.CornerRadius = UDim.new(0, 7)
			sRowCorner.Parent = SectionRow

			local sRowStroke = Instance.new("UIStroke")
			sRowStroke.Color = GetTheme().Stroke
			sRowStroke.Thickness = 1
			sRowStroke.Parent = SectionRow

			local sRowPad = Instance.new("UIPadding")
			sRowPad.PaddingLeft = UDim.new(0, 8)
			sRowPad.PaddingRight = UDim.new(0, 8)
			sRowPad.PaddingTop = UDim.new(0, 8)
			sRowPad.PaddingBottom = UDim.new(0, 8)
			sRowPad.Parent = SectionRow

			local sRowLayout = Instance.new("UIListLayout")
			sRowLayout.SortOrder = Enum.SortOrder.LayoutOrder
			sRowLayout.Padding = UDim.new(0, 5)
			sRowLayout.Parent = SectionRow

			local HeaderRow = Instance.new("Frame")
			HeaderRow.Size = UDim2.new(1, 0, 0, 26)
			HeaderRow.BackgroundTransparency = 1
			HeaderRow.LayoutOrder = 0
			HeaderRow.Parent = SectionRow

			local accentBar2 = Instance.new("Frame")
			accentBar2.Size = UDim2.new(0, 2, 0, 14)
			accentBar2.AnchorPoint = Vector2.new(0, 0.5)
			accentBar2.Position = UDim2.new(0, 0, 0.5, 0)
			accentBar2.BackgroundColor3 = GOLD
			accentBar2.BorderSizePixel = 0
			accentBar2.Parent = HeaderRow
			local ac2 = Instance.new("UICorner")
			ac2.CornerRadius = UDim.new(0, 2)
			ac2.Parent = accentBar2

			local sNameLabel = Instance.new("TextLabel")
			sNameLabel.Size = UDim2.new(1, -60, 1, 0)
			sNameLabel.Position = UDim2.new(0, 10, 0, 0)
			sNameLabel.BackgroundTransparency = 1
			sNameLabel.Text = entry.sectionName
			sNameLabel.TextColor3 = GOLD
			sNameLabel.Font = Enum.Font.GothamBold
			sNameLabel.TextSize = 12
			sNameLabel.TextXAlignment = Enum.TextXAlignment.Left
			sNameLabel.Parent = HeaderRow

			local renameSBtn, renameSClick = CreateAnimatedButton({
				Parent = HeaderRow,
				Size = UDim2.new(0, 22, 0, 22),
				Position = UDim2.new(1, -46, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				IconId = RENAME_ICON,
				IconColor = Color3.fromRGB(160, 160, 175),
				CornerRadius = 5,
			})
			renameSBtn.ZIndex = 3
			renameSClick.ZIndex = 4

			local deleteSBtn, deleteSClick = CreateAnimatedButton({
				Parent = HeaderRow,
				Size = UDim2.new(0, 22, 0, 22),
				Position = UDim2.new(1, -22, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				IconId = DELETE_ICON,
				IconColor = RED_DELETE,
				CornerRadius = 5,
			})
			deleteSBtn.ZIndex = 3
			deleteSClick.ZIndex = 4

			AddConnection(renameSClick.MouseButton1Up, function()
				local oldSName = TabSectionData[sectionIdx] and TabSectionData[sectionIdx].sectionName or ""
				State.activeModal = "renameSection"
				State.pendingRename = oldSName

				local card = CreateModalBase("Rename Section", 130)

				local sub2 = Instance.new("TextLabel")
				sub2.Size = UDim2.new(1, -28, 0, 14)
				sub2.Position = UDim2.new(0, 14, 0, 40)
				sub2.BackgroundTransparency = 1
				sub2.Text = 'Renaming: "' .. oldSName .. '"'
				sub2.TextColor3 = Color3.fromRGB(150, 150, 160)
				sub2.Font = Enum.Font.Gotham
				sub2.TextSize = 11
				sub2.TextXAlignment = Enum.TextXAlignment.Left
				sub2.ZIndex = 22
				sub2.Parent = card

				local inputBg2 = Instance.new("Frame")
				inputBg2.Size = UDim2.new(1, -28, 0, 30)
				inputBg2.Position = UDim2.new(0, 14, 0, 60)
				inputBg2.BackgroundColor3 = GetTheme().Main
				inputBg2.BorderSizePixel = 0
				inputBg2.ZIndex = 22
				inputBg2.Parent = card
				local ib2Corner = Instance.new("UICorner")
				ib2Corner.CornerRadius = UDim.new(0, 6)
				ib2Corner.Parent = inputBg2
				local ib2Stroke = Instance.new("UIStroke")
				ib2Stroke.Color = GetTheme().Stroke
				ib2Stroke.Thickness = 1
				ib2Stroke.Parent = inputBg2

				local inputBox2 = Instance.new("TextBox")
				inputBox2.Size = UDim2.new(1, -14, 1, 0)
				inputBox2.Position = UDim2.new(0, 10, 0, 0)
				inputBox2.BackgroundTransparency = 1
				inputBox2.Text = oldSName
				inputBox2.TextColor3 = WHITE
				inputBox2.PlaceholderText = "New section name..."
				inputBox2.PlaceholderColor3 = Color3.fromRGB(110, 110, 125)
				inputBox2.Font = Enum.Font.Gotham
				inputBox2.TextSize = 12
				inputBox2.TextXAlignment = Enum.TextXAlignment.Left
				inputBox2.ClearTextOnFocus = false
				inputBox2.ZIndex = 23
				inputBox2.Parent = inputBg2

				AddConnection(inputBox2.Focused, function()
					Tween(ib2Stroke, TWEEN_FAST, {Color = GOLD})
				end)
				AddConnection(inputBox2.FocusLost, function()
					Tween(ib2Stroke, TWEEN_FAST, {Color = GetTheme().Stroke})
				end)

				local btnRow2 = Instance.new("Frame")
				btnRow2.Size = UDim2.new(1, -28, 0, 30)
				btnRow2.Position = UDim2.new(0, 14, 0, 96)
				btnRow2.BackgroundTransparency = 1
				btnRow2.ZIndex = 22
				btnRow2.Parent = card

local rSFrame, rSClick = CreateAnimatedButton({
					Parent = btnRow2,
					Size = UDim2.new(0.47, 0, 1, 0),
					Label = "Rename",
					FontSize = 12,
					LabelColor = GOLD,
					CornerRadius = 6,
					BaseZIndex = 21,
				})

				local cSFrame, cSClick = CreateAnimatedButton({
					Parent = btnRow2,
					Size = UDim2.new(0.47, 0, 1, 0),
					Position = UDim2.new(0.53, 0, 0, 0),
					Label = "Cancel",
					FontSize = 12,
					LabelColor = Color3.fromRGB(150, 150, 160),
					CornerRadius = 6,
					BaseZIndex = 21,
				})

				task.delay(0.2, function()
					if inputBox2 and inputBox2.Parent then
						inputBox2:CaptureFocus()
						inputBox2.CursorPosition = #inputBox2.Text + 1
					end
				end)

				local function DoRename()
					local newSName = inputBox2.Text:match("^%s*(.-)%s*$")
					DestroyModal()
					if newSName ~= "" and TabSectionData[sectionIdx] then
						TabSectionData[sectionIdx].sectionName = newSName
						sNameLabel.Text = newSName
						SaveTabSections()
						RebuildTabHolderFromSections()
					end
				end

				AddConnection(rSClick.MouseButton1Up, DoRename)
				AddConnection(cSClick.MouseButton1Up, function() DestroyModal() end)
				AddConnection(inputBox2.FocusLost, function(enter)
					if enter then DoRename() end
				end)
			end)

			AddConnection(deleteSClick.MouseButton1Up, function()
				local sName = TabSectionData[sectionIdx] and TabSectionData[sectionIdx].sectionName or "this section"
				ShowConfirmModal('Delete section "' .. sName .. '"?', function()
					table.remove(TabSectionData, sectionIdx)
					SaveTabSections()
					RebuildTabHolderFromSections()
					BuildTabSectionMgrUI()
				end)
			end)

			local TabsInSection = Instance.new("Frame")
			TabsInSection.Size = UDim2.new(1, 0, 0, 0)
			TabsInSection.BackgroundTransparency = 1
			TabsInSection.AutomaticSize = Enum.AutomaticSize.Y
			TabsInSection.LayoutOrder = 1
			TabsInSection.Parent = SectionRow

			local tabsLayout = Instance.new("UIListLayout")
			tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
			tabsLayout.Padding = UDim.new(0, 4)
			tabsLayout.Parent = TabsInSection

			local function RefreshTabsInSectionUI()
				for _, c in ipairs(TabsInSection:GetChildren()) do
					if not c:IsA("UIListLayout") then c:Destroy() end
				end

				for tIdx, tabName in ipairs(entry.tabs) do
					local tabIdx = tIdx

					local TabRow = Instance.new("Frame")
					TabRow.Size = UDim2.new(1, 0, 0, 28)
					TabRow.BackgroundColor3 = GetTheme().Main
					TabRow.BorderSizePixel = 0
					TabRow.LayoutOrder = tabIdx
					TabRow.Parent = TabsInSection

					local tRowCorner = Instance.new("UICorner")
					tRowCorner.CornerRadius = UDim.new(0, 5)
					tRowCorner.Parent = TabRow

					local tRowStroke = Instance.new("UIStroke")
					tRowStroke.Color = GetTheme().Stroke
					tRowStroke.Thickness = 1
					tRowStroke.Parent = TabRow

					local dot = Instance.new("Frame")
					dot.Size = UDim2.new(0, 4, 0, 4)
					dot.AnchorPoint = Vector2.new(0, 0.5)
					dot.Position = UDim2.new(0, 8, 0.5, 0)
					dot.BackgroundColor3 = GOLD
					dot.BorderSizePixel = 0
					dot.Parent = TabRow
					local dotC = Instance.new("UICorner")
					dotC.CornerRadius = UDim.new(1, 0)
					dotC.Parent = dot

					local tNameLbl = Instance.new("TextLabel")
					tNameLbl.Size = UDim2.new(1, -50, 1, 0)
					tNameLbl.Position = UDim2.new(0, 18, 0, 0)
					tNameLbl.BackgroundTransparency = 1
					tNameLbl.Text = tabName
					tNameLbl.TextColor3 = WHITE
					tNameLbl.Font = Enum.Font.GothamSemibold
					tNameLbl.TextSize = 12
					tNameLbl.TextXAlignment = Enum.TextXAlignment.Left
					tNameLbl.Parent = TabRow

					local removeTBtn, removeTClick = CreateAnimatedButton({
						Parent = TabRow,
						Size = UDim2.new(0, 20, 0, 20),
						Position = UDim2.new(1, -24, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						IconId = DELETE_ICON,
						IconColor = RED_DELETE,
						CornerRadius = 4,
					})
					removeTBtn.ZIndex = 3
					removeTClick.ZIndex = 4

					AddConnection(removeTClick.MouseButton1Up, function()
						table.remove(entry.tabs, tabIdx)
						SaveTabSections()
						RebuildTabHolderFromSections()
						RefreshTabsInSectionUI()
					end)
				end
			end

			RefreshTabsInSectionUI()

			local DropdownToggled = false
			local MaxDropElements = 4

			local DropdownFrame = Instance.new("Frame")
			DropdownFrame.Size = UDim2.new(1, 0, 0, 28)
			DropdownFrame.BackgroundColor3 = GetTheme().Second
			DropdownFrame.BorderSizePixel = 0
			DropdownFrame.LayoutOrder = 2
			DropdownFrame.ClipsDescendants = true
			DropdownFrame.Parent = SectionRow

			local dfCorner = Instance.new("UICorner")
			dfCorner.CornerRadius = UDim.new(0, 5)
			dfCorner.Parent = DropdownFrame

			local dfStroke = Instance.new("UIStroke")
			dfStroke.Color = GetTheme().Stroke
			dfStroke.Thickness = 1
			dfStroke.Parent = DropdownFrame

			local dfHeader = Instance.new("Frame")
			dfHeader.Size = UDim2.new(1, 0, 0, 28)
			dfHeader.BackgroundTransparency = 1
			dfHeader.Name = "F"
			dfHeader.ClipsDescendants = true
			dfHeader.Parent = DropdownFrame

			local dfLabel = Instance.new("TextLabel")
			dfLabel.Size = UDim2.new(1, -40, 1, 0)
			dfLabel.Position = UDim2.new(0, 10, 0, 0)
			dfLabel.BackgroundTransparency = 1
			dfLabel.Text = "+ Add tab to section"
			dfLabel.TextColor3 = Color3.fromRGB(130, 130, 145)
			dfLabel.Font = Enum.Font.GothamSemibold
			dfLabel.TextSize = 12
			dfLabel.TextXAlignment = Enum.TextXAlignment.Left
			dfLabel.Parent = dfHeader

			local dfArrow = Instance.new("ImageLabel")
			dfArrow.Size = UDim2.new(0, 14, 0, 14)
			dfArrow.AnchorPoint = Vector2.new(0, 0.5)
			dfArrow.Position = UDim2.new(1, -22, 0.5, 0)
			dfArrow.BackgroundTransparency = 1
			dfArrow.Image = "rbxassetid://7072706796"
			dfArrow.ImageColor3 = Color3.fromRGB(150, 150, 160)
			dfArrow.Name = "Ico"
			dfArrow.Parent = dfHeader

			local dfLine = Instance.new("Frame")
			dfLine.Size = UDim2.new(1, 0, 0, 1)
			dfLine.Position = UDim2.new(0, 0, 1, -1)
			dfLine.BackgroundColor3 = GetTheme().Stroke
			dfLine.BorderSizePixel = 0
			dfLine.Name = "Line"
			dfLine.Visible = false
			dfLine.Parent = dfHeader

			local dfClick = Instance.new("TextButton")
			dfClick.Size = UDim2.new(1, 0, 0, 28)
			dfClick.BackgroundTransparency = 1
			dfClick.Text = ""
			dfClick.AutoButtonColor = false
			dfClick.ZIndex = 2
			dfClick.Parent = dfHeader

			local dfListLayout = Instance.new("UIListLayout")
			dfListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			dfListLayout.Padding = UDim.new(0, 0)

			local dfContainer = Instance.new("ScrollingFrame")
			dfContainer.Size = UDim2.new(1, 0, 1, -28)
			dfContainer.Position = UDim2.new(0, 0, 0, 28)
			dfContainer.BackgroundTransparency = 1
			dfContainer.ScrollBarThickness = 4
			dfContainer.ScrollBarImageColor3 = GetTheme().Divider
			dfContainer.BorderSizePixel = 0
			dfContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
			dfContainer.Parent = DropdownFrame

			dfListLayout.Parent = dfContainer

			AddConnection(dfListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
				dfContainer.CanvasSize = UDim2.new(0, 0, 0, dfListLayout.AbsoluteContentSize.Y)
			end)

			local DropOptionButtons = {}

local function PopulateDropdown()
	Breathe()
				for _, c in ipairs(dfContainer:GetChildren()) do
					if not c:IsA("UIListLayout") then c:Destroy() end
				end
				table.clear(DropOptionButtons)

				local alreadyIn = {}
				for _, sEntry in ipairs(TabSectionData) do
					for _, t in ipairs(sEntry.tabs) do alreadyIn[t] = true end
				end

				for _, tabData in ipairs(AllRegisteredTabs) do
					if not alreadyIn[tabData.name] then
						local optBtn = Instance.new("TextButton")
						optBtn.Size = UDim2.new(1, 0, 0, 28)
						optBtn.BackgroundColor3 = GetTheme().Second
						optBtn.BorderSizePixel = 0
						optBtn.Text = ""
						optBtn.AutoButtonColor = false
						optBtn.ZIndex = 1
						optBtn.Parent = dfContainer

						local optLabel = Instance.new("TextLabel")
						optLabel.Size = UDim2.new(1, -16, 1, 0)
						optLabel.Position = UDim2.new(0, 8, 0, 0)
						optLabel.BackgroundTransparency = 1
						optLabel.Text = tabData.name
						optLabel.TextColor3 = GetTheme().Text
						optLabel.TextTransparency = 0.4
						optLabel.Font = Enum.Font.GothamSemibold
						optLabel.TextSize = 13
						optLabel.TextXAlignment = Enum.TextXAlignment.Left
						optLabel.ZIndex = 2
						optLabel.Name = "Title"
						optLabel.Parent = optBtn

						AddConnection(optBtn.MouseButton1Click, function()
							table.insert(entry.tabs, tabData.name)
							DropdownToggled = false
							dfHeader.Line.Visible = false
							TweenService:Create(dfArrow, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}):Play()
							TweenService:Create(DropdownFrame, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 28)}):Play()
							SaveTabSections()
							RebuildTabHolderFromSections()
							RefreshTabsInSectionUI()
						end)

						AddConnection(optBtn.MouseEnter, function()
							TweenService:Create(optBtn, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = BrightenColor(GetTheme().Second, 5)}):Play()
							TweenService:Create(optLabel, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
						end)
						AddConnection(optBtn.MouseLeave, function()
							TweenService:Create(optBtn, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = GetTheme().Second}):Play()
							TweenService:Create(optLabel, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0.4}):Play()
						end)

						table.insert(DropOptionButtons, optBtn)
					end
				end
			end

			AddConnection(dfClick.MouseButton1Click, function()
				DropdownToggled = not DropdownToggled
				dfHeader.Line.Visible = DropdownToggled
				TweenService:Create(dfArrow, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = DropdownToggled and 180 or 0}):Play()
if DropdownToggled then
					PopulateDropdown()
					local count = 0
					local alreadyIn = {}
					for _, sEntry in ipairs(TabSectionData) do
						for _, t in ipairs(sEntry.tabs) do alreadyIn[t] = true end
					end
					for _, tabData in ipairs(AllRegisteredTabs) do
						if not alreadyIn[tabData.name] then count = count + 1 end
					end
					local listH = math.min(count, MaxDropElements) * 28
					TweenService:Create(DropdownFrame, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 28 + listH)}):Play()
				else
					TweenService:Create(DropdownFrame, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 28)}):Play()
				end
			end)

			TabSectionRows[sectionIdx] = SectionRow
		end

		local NewSectionRow = Instance.new("Frame")
		NewSectionRow.Size = UDim2.new(1, 0, 0, 38)
		NewSectionRow.BackgroundColor3 = GetTheme().Second
		NewSectionRow.BorderSizePixel = 0
		NewSectionRow.LayoutOrder = #TabSectionData + 10
		NewSectionRow.Parent = TabSectionMgrFrame

		local nsCorner = Instance.new("UICorner")
		nsCorner.CornerRadius = UDim.new(0, 7)
		nsCorner.Parent = NewSectionRow

		local nsStroke = Instance.new("UIStroke")
		nsStroke.Color = GetTheme().Stroke
		nsStroke.Thickness = 1
		nsStroke.Parent = NewSectionRow

		local nsPad = Instance.new("UIPadding")
		nsPad.PaddingLeft = UDim.new(0, 8)
		nsPad.PaddingRight = UDim.new(0, 8)
		nsPad.PaddingTop = UDim.new(0, 0)
		nsPad.PaddingBottom = UDim.new(0, 0)
		nsPad.Parent = NewSectionRow

		local nsInputBg = Instance.new("Frame")
		nsInputBg.Size = UDim2.new(1, -100, 0, 26)
		nsInputBg.AnchorPoint = Vector2.new(0, 0.5)
		nsInputBg.Position = UDim2.new(0, 0, 0.5, 0)
		nsInputBg.BackgroundColor3 = GetTheme().Main
		nsInputBg.BorderSizePixel = 0
		nsInputBg.Parent = NewSectionRow

		local nsIbCorner = Instance.new("UICorner")
		nsIbCorner.CornerRadius = UDim.new(0, 5)
		nsIbCorner.Parent = nsInputBg

		local nsIbStroke = Instance.new("UIStroke")
		nsIbStroke.Color = GetTheme().Stroke
		nsIbStroke.Thickness = 1
		nsIbStroke.Parent = nsInputBg

		local nsInputBox = Instance.new("TextBox")
		nsInputBox.Size = UDim2.new(1, -10, 1, 0)
		nsInputBox.Position = UDim2.new(0, 8, 0, 0)
		nsInputBox.BackgroundTransparency = 1
		nsInputBox.Text = ""
		nsInputBox.TextColor3 = WHITE
		nsInputBox.PlaceholderText = "Section name..."
		nsInputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 115)
		nsInputBox.Font = Enum.Font.Gotham
		nsInputBox.TextSize = 12
		nsInputBox.TextXAlignment = Enum.TextXAlignment.Left
		nsInputBox.ClearTextOnFocus = false
		nsInputBox.Parent = nsInputBg

		AddConnection(nsInputBox.Focused, function()
			Tween(nsIbStroke, TWEEN_FAST, {Color = GOLD})
		end)
		AddConnection(nsInputBox.FocusLost, function()
			Tween(nsIbStroke, TWEEN_FAST, {Color = GetTheme().Stroke})
		end)

		local nsCreateFrame, nsCreateClick, nsCreateAPI = CreateAnimatedButton({
			Parent = NewSectionRow,
			Size = UDim2.new(0, 90, 0, 26),
			Position = UDim2.new(1, -90, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Label = "+ Section",
			FontSize = 11,
			LabelColor = GOLD,
			CornerRadius = 5,
		})

		local function TryCreateSection()
			local name = nsInputBox.Text:match("^%s*(.-)%s*$")
			if name == "" then return end
			nsInputBox.Text = ""
			table.insert(TabSectionData, {sectionName = name, tabs = {}})
			SaveTabSections()
			RebuildTabHolderFromSections()
			BuildTabSectionMgrUI()
		end

		AddConnection(nsCreateClick.MouseButton1Up, TryCreateSection)
		AddConnection(nsInputBox.FocusLost, function(enter)
			if enter then TryCreateSection() end
		end)
	end

local TabSectionMgrBuilt = false

AddConnection(ConfigTopBtn.MouseButton1Up, function()
		CMOpen = not CMOpen
		if CMOpen then
			if not TabSectionMgrBuilt then
				TabSectionMgrBuilt = true
				local saved = LoadTabSectionLayout()
				if saved and #saved > 0 then
					TabSectionData = saved
					for _, sEntry in ipairs(TabSectionData) do
						local validTabs = {}
						for _, tabName in ipairs(sEntry.tabs) do
							for _, tabData in ipairs(AllRegisteredTabs) do
								if tabData.name == tabName then
									table.insert(validTabs, tabName)
									break
								end
							end
						end
						sEntry.tabs = validTabs
					end
				end
				BuildTabSectionMgrUI()
				RebuildTabHolderFromSections()
			end
			CMOpenPanel()
			CMContainer.Visible = true
		else
			DestroyModal()
			CMContainer.Visible = false
			if ActiveTabContainer then
				ActiveTabContainer.Visible = true
			end
			CMClosePanel()
		end
	end)

	CM.RebuildUI = function()
		for name, api in pairs(RowAPIs) do
			if api then api:Destroy() end
		end
		RowAPIs = {}
		CM.ConfigButtons = {}

		if EmptyFrame and EmptyFrame.Parent then
			EmptyFrame:Destroy()
			EmptyFrame = nil
		end

		local configs = CMGetAllConfigs()
		for i, name in ipairs(configs) do
			task.delay(i * 0.04, function()
				AddConfigRow(name)
			end)
		end
		task.delay(#configs * 0.04 + 0.1, function()
			UpdateAllActiveIndicators()
		end)
	end

	CM.UpdateActiveIndicators = UpdateAllActiveIndicators

	local function ClearAllTabHighlights()
		for _, Tab in next, TabHolder:GetChildren() do
			if Tab:IsA("TextButton") then
				Tab.Title.Font = Enum.Font.GothamSemibold
				Tab.Title.TextColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Text
				Tab.Title.TextTransparency = 0.4
				Tab.Ico.ImageColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Text
				Tab.Ico.ImageTransparency = 0.4
			end
		end
		local ico = ConfigTopBtn:FindFirstChild("Ico")
		if ico then
			ico.ImageColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Text
			ico.ImageTransparency = 0
		end
		CMOpen = false
		for _, child in ipairs(MainWindow:GetChildren()) do
			if child.Name == "ItemContainer" and child:IsA("ScrollingFrame") then
				if not child:FindFirstChildOfClass("UIListLayout") then
					child.Visible = false
				end
			end
		end
	end

	local TabFunction = {}

function TabFunction:MakeTabSection(SectionName)
		SectionName = SectionName:upper()
		table.insert(DefaultSectionLayout, {type = "section", name = SectionName})

		local alreadyExists = false
		for _, entry in ipairs(TabSectionData) do
			if entry.sectionName == SectionName then
				alreadyExists = true
				break
			end
		end
		if not alreadyExists then
			table.insert(TabSectionData, {sectionName = SectionName, tabs = {}})
		end

		local labelFrame = Instance.new("Frame")
		labelFrame.Name = "SectionLabel"
		labelFrame.Size = UDim2.new(1, 0, 0, 22)
		labelFrame.BackgroundTransparency = 1
		labelFrame.Parent = TabHolder

		local bar = Instance.new("Frame")
		bar.Size = UDim2.new(0, 2, 0, 12)
		bar.AnchorPoint = Vector2.new(0, 0.5)
		bar.Position = UDim2.new(0, 10, 0.5, 0)
		bar.BackgroundColor3 = GOLD
		bar.BorderSizePixel = 0
		bar.Parent = labelFrame
		local bc = Instance.new("UICorner")
		bc.CornerRadius = UDim.new(0, 2)
		bc.Parent = bar

		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(1, -20, 1, 0)
		lbl.Position = UDim2.new(0, 18, 0, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text = SectionName
		lbl.TextColor3 = GOLD
		lbl.TextTransparency = 0
		lbl.Font = Enum.Font.GothamBold
		lbl.TextSize = 10
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.Parent = labelFrame
	end

	function TabFunction:MakeTab(TabConfig)
		Breathe()
		TabConfig = TabConfig or {}
		TabConfig.Name = TabConfig.Name or "Tab"
		TabConfig.Icon = TabConfig.Icon or ""
		TabConfig.PremiumOnly = TabConfig.PremiumOnly or false

		local TabFrame = SetChildren(SetProps(MakeElement("Button"), {
			Size = UDim2.new(1, 0, 0, 30),
			Parent = TabHolder
		}), {
			AddThemeObject(SetProps(MakeElement("Image", TabConfig.Icon), {
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.new(0, 18, 0, 18),
				Position = UDim2.new(0, 10, 0.5, 0),
				ImageTransparency = 0.4,
				Name = "Ico"
			}), "Text"),
			AddThemeObject(SetProps(MakeElement("Label", TabConfig.Name, 14), {
				Size = UDim2.new(1, -35, 1, 0),
				Position = UDim2.new(0, 35, 0, 0),
				Font = Enum.Font.GothamSemibold,
				TextTransparency = 0.4,
				Name = "Title"
			}), "Text")
		})

		if GetIcon(TabConfig.Icon) ~= nil then
			TabFrame.Ico.Image = GetIcon(TabConfig.Icon)
		end

table.insert(AllRegisteredTabs, {name = TabConfig.Name, frame = TabFrame})
		table.insert(DefaultSectionLayout, {type = "tab", name = TabConfig.Name})

		if #TabSectionData > 0 then
			local lastSection = TabSectionData[#TabSectionData]
			local alreadyInSection = false
			for _, sEntry in ipairs(TabSectionData) do
				for _, t in ipairs(sEntry.tabs) do
					if t == TabConfig.Name then alreadyInSection = true; break end
				end
				if alreadyInSection then break end
			end
			if not alreadyInSection then
				table.insert(lastSection.tabs, TabConfig.Name)
			end
		end

		local Container = AddThemeObject(SetChildren(SetProps(MakeElement("ScrollFrame", Color3.fromRGB(255, 255, 255), 5), {
			Size = UDim2.new(1, -150, 1, -50),
			Position = UDim2.new(0, 150, 0, 50),
			Parent = MainWindow,
			Visible = false,
			Name = "ItemContainer"
		}), {
			MakeElement("List", 0, 6),
			MakeElement("Padding", 15, 10, 10, 15)
		}), "Divider")

		AddConnection(Container.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			Container.CanvasSize = UDim2.new(0, 0, 0, Container.UIListLayout.AbsoluteContentSize.Y + 30)
		end)

		if FirstTab then
			FirstTab = false
			TabFrame.Ico.ImageTransparency = 0
			TabFrame.Title.TextTransparency = 0
			TabFrame.Title.Font = Enum.Font.GothamBlack
			Container.Visible = true
			TabFrame.Title.TextColor3 = Color3.fromRGB(255, 239, 149)
			TabFrame.Ico.ImageColor3 = Color3.fromRGB(255, 239, 149)
			ActiveTabFrame = TabFrame
			ActiveTabContainer = Container
		end    

		AddConnection(TabFrame.MouseButton1Click, function()
			ClearAllTabHighlights()
			for _, ItemContainer in next, MainWindow:GetChildren() do
				if ItemContainer.Name == "ItemContainer" then
					ItemContainer.Visible = false
				end
			end
			TabFrame.Title.TextColor3 = Color3.fromRGB(255, 239, 149)
			TabFrame.Ico.ImageColor3 = Color3.fromRGB(255, 239, 149)
			TweenService:Create(TabFrame.Ico, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
			TweenService:Create(TabFrame.Title, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
			TabFrame.Title.Font = Enum.Font.GothamBlack
			Container.Visible = true
			ActiveTabFrame = TabFrame
			ActiveTabContainer = Container
		end)

		local function GetElements(ItemParent)
			local ElementFunction = {}
			function ElementFunction:AddLabel(Text)
				Breathe()
				local LabelFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 8), {
					Size = UDim2.new(1, 0, 0, 30),
					BackgroundTransparency = 0.7,
					Parent = ItemParent
				}), {
					AddThemeObject(SetProps(MakeElement("Label", Text, 15), {
						Size = UDim2.new(1, -12, 1, 0),
						Position = UDim2.new(0, 12, 0, 0),
						Font = Enum.Font.GothamBold,
						Name = "Content"
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke")
				}), "Second")
				local LabelFunction = {}
				function LabelFunction:Set(ToChange)
					LabelFrame.Content.Text = ToChange
				end
				return LabelFunction
			end
			function ElementFunction:AddParagraph(Text, Content)
				Breathe()
				Text = Text or "Text"
				Content = Content or "Content"
				local ParagraphFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 8), {
					Size = UDim2.new(1, 0, 0, 30),
					BackgroundTransparency = 0.7,
					Parent = ItemParent
				}), {
					AddThemeObject(SetProps(MakeElement("Label", Text, 15), {
						Size = UDim2.new(1, -12, 0, 14),
						Position = UDim2.new(0, 12, 0, 10),
						Font = Enum.Font.GothamBold,
						Name = "Title"
					}), "Text"),
					AddThemeObject(SetProps(MakeElement("Label", "", 13), {
						Size = UDim2.new(1, -24, 0, 0),
						Position = UDim2.new(0, 12, 0, 26),
						Font = Enum.Font.GothamSemibold,
						Name = "Content",
						TextWrapped = true
					}), "TextDark"),
					AddThemeObject(MakeElement("Stroke"), "Stroke")
				}), "Second")
				AddConnection(ParagraphFrame.Content:GetPropertyChangedSignal("Text"), function()
					ParagraphFrame.Content.Size = UDim2.new(1, -24, 0, ParagraphFrame.Content.TextBounds.Y)
					ParagraphFrame.Size = UDim2.new(1, 0, 0, ParagraphFrame.Content.TextBounds.Y + 35)
				end)
				ParagraphFrame.Content.Text = Content
				local ParagraphFunction = {}
				function ParagraphFunction:Set(ToChange)
					ParagraphFrame.Content.Text = ToChange
				end
				return ParagraphFunction
			end    
			function ElementFunction:AddButton(ButtonConfig)
				Breathe()
				ButtonConfig = ButtonConfig or {}
				ButtonConfig.Name = ButtonConfig.Name or "Button"
				ButtonConfig.Callback = ButtonConfig.Callback or function() end
				ButtonConfig.Icon = ButtonConfig.Icon or "rbxassetid://3944703587"
				local Button = {}
				local Click = SetProps(MakeElement("Button"), {
					Size = UDim2.new(1, 0, 1, 0)
				})
				local ButtonFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 8), {
					Size = UDim2.new(1, 0, 0, 33),
					Parent = ItemParent
				}), {
					AddThemeObject(SetProps(MakeElement("Label", ButtonConfig.Name, 15), {
						Size = UDim2.new(1, -12, 1, 0),
						Position = UDim2.new(0, 12, 0, 0),
						Font = Enum.Font.GothamBold,
						Name = "Content"
					}), "Text"),
					AddThemeObject(SetProps(MakeElement("Image", ButtonConfig.Icon), {
						Size = UDim2.new(0, 20, 0, 20),
						Position = UDim2.new(1, -30, 0, 7),
					}), "TextDark"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					Click
				}), "Second")
				AddConnection(Click.MouseEnter, function()
					TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Second.R * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Second.G * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Second.B * 255 + 3)}):Play()
				end)
				AddConnection(Click.MouseLeave, function()
					TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Second}):Play()
				end)
				AddConnection(Click.MouseButton1Up, function()
					TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Second.R * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Second.G * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Second.B * 255 + 3)}):Play()
					spawn(function()
						ButtonConfig.Callback()
					end)
				end)
				AddConnection(Click.MouseButton1Down, function()
					TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Second.R * 255 + 6, OrionLib.Themes[OrionLib.SelectedTheme].Second.G * 255 + 6, OrionLib.Themes[OrionLib.SelectedTheme].Second.B * 255 + 6)}):Play()
				end)
				function Button:Set(ButtonText)
					ButtonFrame.Content.Text = ButtonText
				end	
				AddHelpQuestion(ButtonFrame, ButtonConfig.HelpQuestion)
				return Button
			end    
			function ElementFunction:AddToggle(ToggleConfig)
				Breathe()
				ToggleConfig = ToggleConfig or {}
				ToggleConfig.Name = ToggleConfig.Name or "Toggle"
				ToggleConfig.Default = ToggleConfig.Default or false
				ToggleConfig.Callback = ToggleConfig.Callback or function() end
				ToggleConfig.Color = ToggleConfig.Color or Color3.fromRGB(206, 182, 52)
				ToggleConfig.Flag = ToggleConfig.Flag or nil
				ToggleConfig.Save = ToggleConfig.Save or false
				local Toggle = {Value = ToggleConfig.Default, Default = ToggleConfig.Default, Save = ToggleConfig.Save}
				local Click = SetProps(MakeElement("Button"), {
					Size = UDim2.new(1, 0, 1, 0)
				})
				local ToggleBox = SetChildren(SetProps(MakeElement("RoundFrame", ToggleConfig.Color, 0, 4), {
					Size = UDim2.new(0, 24, 0, 24),
					Position = UDim2.new(1, -12, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5)
				}), {
					SetProps(MakeElement("Stroke"), {
						Color = ToggleConfig.Color,
						Name = "Stroke",
						Transparency = 0.5
					}),
					SetProps(MakeElement("Image", "rbxassetid://3944680095"), {
						Size = UDim2.new(0, 20, 0, 20),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						ImageColor3 = Color3.fromRGB(255, 255, 255),
						Name = "Ico"
					}),
				})
				local ToggleFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 8), {
					Size = UDim2.new(1, 0, 0, 38),
					Parent = ItemParent
				}), {
					AddThemeObject(SetProps(MakeElement("Label", ToggleConfig.Name, 15), {
						Size = UDim2.new(1, -12, 1, 0),
						Position = UDim2.new(0, 12, 0, 0),
						Font = Enum.Font.GothamBold,
						Name = "Content"
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					ToggleBox,
					Click
				}), "Second")
				function Toggle:Set(Value)
					Toggle.Value = Value
					TweenService:Create(ToggleBox, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Toggle.Value and ToggleConfig.Color or OrionLib.Themes.Default.Divider}):Play()
					TweenService:Create(ToggleBox.Stroke, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Color = Toggle.Value and ToggleConfig.Color or OrionLib.Themes.Default.Stroke}):Play()
					TweenService:Create(ToggleBox.Ico, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = Toggle.Value and 0 or 1, Size = Toggle.Value and UDim2.new(0, 20, 0, 20) or UDim2.new(0, 8, 0, 8)}):Play()
					ToggleConfig.Callback(Toggle.Value)
				end    
				Toggle:Set(Toggle.Value)
				AddConnection(Click.MouseEnter, function()
					TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Second.R * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Second.G * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Second.B * 255 + 3)}):Play()
				end)
				AddConnection(Click.MouseLeave, function()
					TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Second}):Play()
				end)
				AddConnection(Click.MouseButton1Up, function()
					TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Second.R * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Second.G * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Second.B * 255 + 3)}):Play()
					Toggle:Set(not Toggle.Value)
					if OrionLib._configLoaded then
						CMSaveFlagsToFile(CM.CurrentConfig)
					end
				end)
				AddConnection(Click.MouseButton1Down, function()
					TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Second.R * 255 + 6, OrionLib.Themes[OrionLib.SelectedTheme].Second.G * 255 + 6, OrionLib.Themes[OrionLib.SelectedTheme].Second.B * 255 + 6)}):Play()
				end)
				if ToggleConfig.Colorpicker then
					local CPConfig = ToggleConfig.Colorpicker
					CPConfig.Default = CPConfig.Default or Color3.fromRGB(255, 255, 255)
					CPConfig.Callback = CPConfig.Callback or function() end
					CPConfig.Save = CPConfig.Save or false

					local Colorpicker = {Value = CPConfig.Default, Default = CPConfig.Default, Toggled = false, Type = "Colorpicker", Save = CPConfig.Save}
					local ColorH, ColorS, ColorV = Color3.toHSV(CPConfig.Default)

					Click.Size = UDim2.new(1, 0, 0, 38)
					ToggleFrame.ClipsDescendants = true
					ToggleFrame.Content.Size = UDim2.new(1, -12, 0, 38)
					ToggleBox.Position = UDim2.new(1, -12, 0, 19)

					local ColorSelection = Create("ImageLabel", {
						Size = UDim2.new(0, 18, 0, 18),
						Position = UDim2.new(ColorS, 0, 1 - ColorV, 0),
						ScaleType = Enum.ScaleType.Fit,
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Image = "http://www.roblox.com/asset/?id=4805639000",
						ZIndex = 4
					})
					local HueSelection = Create("ImageLabel", {
						Size = UDim2.new(0, 18, 0, 18),
						Position = UDim2.new(0.5, 0, 1 - ColorH, 0),
						ScaleType = Enum.ScaleType.Fit,
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Image = "http://www.roblox.com/asset/?id=4805639000",
						ZIndex = 4
					})
					local Color = Create("ImageLabel", {
						Size = UDim2.new(1, -25, 1, 0),
						Visible = false,
						BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1),
						Image = "rbxassetid://4155801252",
						ZIndex = 3
					}, {
						Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
						ColorSelection
					})
					local Hue = Create("Frame", {
						Size = UDim2.new(0, 20, 1, 0),
						Position = UDim2.new(1, -20, 0, 0),
						Visible = false,
						ZIndex = 3
					}, {
						Create("UIGradient", {Rotation = 270, Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(234, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(21, 255, 0)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0, 17, 255)), ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 251)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))}}),
						Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
						HueSelection
					})
					local ColorpickerContainer = Create("Frame", {
						Position = UDim2.new(0, 0, 0, 38),
						Size = UDim2.new(1, 0, 1, -38),
						BackgroundTransparency = 1,
						ClipsDescendants = true,
						ZIndex = 3,
						Parent = ToggleFrame
					}, {
						Hue,
						Color,
						Create("UIPadding", {
							PaddingLeft = UDim.new(0, 35),
							PaddingRight = UDim.new(0, 35),
							PaddingBottom = UDim.new(0, 12),
							PaddingTop = UDim.new(0, 10)
						})
					})

					local ColorBox = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", CPConfig.Default, 0, 4), {
						Size = UDim2.new(0, 24, 0, 24),
						Position = UDim2.new(1, -54, 0, 19),
						AnchorPoint = Vector2.new(0.5, 0.5),
						ZIndex = 3,
						Parent = ToggleFrame
					}), {
						AddThemeObject(MakeElement("Stroke"), "Stroke")
					}), "Main")
					ColorBox.BackgroundColor3 = CPConfig.Default

					local ColorClick = SetProps(MakeElement("Button"), {
						Size = UDim2.new(1, 0, 1, 0),
						ZIndex = 4,
						Parent = ColorBox
					})

					AddConnection(ColorClick.MouseButton1Click, function()
						Colorpicker.Toggled = not Colorpicker.Toggled
						TweenService:Create(ToggleFrame, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Colorpicker.Toggled and UDim2.new(1, 0, 0, 148) or UDim2.new(1, 0, 0, 38)}):Play()
						Color.Visible = Colorpicker.Toggled
						Hue.Visible = Colorpicker.Toggled
					end)

					local function UpdateColorPicker()
						local NewColor = Color3.fromHSV(ColorH, ColorS, ColorV)
						ColorBox.BackgroundColor3 = NewColor
						Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
						Colorpicker.Value = NewColor
						CPConfig.Callback(NewColor)
						if OrionLib._configLoaded then
							CMSaveFlagsToFile(CM.CurrentConfig)
						end
					end

					local CPColorInput, CPHueInput
					AddConnection(Color.InputBegan, function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							if CPColorInput then CPColorInput:Disconnect() end
							CPColorInput = AddConnection(RunService.RenderStepped, function()
								local ColorX = (math.clamp(Mouse.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
								local ColorY = (math.clamp(Mouse.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)
								ColorSelection.Position = UDim2.new(ColorX, 0, ColorY, 0)
								ColorS = ColorX
								ColorV = 1 - ColorY
								UpdateColorPicker()
							end)
						end
					end)
					AddConnection(Color.InputEnded, function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							if CPColorInput then CPColorInput:Disconnect() end
						end
					end)
					AddConnection(Hue.InputBegan, function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							if CPHueInput then CPHueInput:Disconnect() end
							CPHueInput = AddConnection(RunService.RenderStepped, function()
								local HueY = (math.clamp(Mouse.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
								HueSelection.Position = UDim2.new(0.5, 0, HueY, 0)
								ColorH = 1 - HueY
								UpdateColorPicker()
							end)
						end
					end)
					AddConnection(Hue.InputEnded, function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							if CPHueInput then CPHueInput:Disconnect() end
						end
					end)

					function Colorpicker:Set(Value)
						if typeof(Value) ~= "Color3" then return end
						Colorpicker.Value = Value
						ColorH, ColorS, ColorV = Color3.toHSV(Value)
						ColorBox.BackgroundColor3 = Value
						Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
						ColorSelection.Position = UDim2.new(ColorS, 0, 1 - ColorV, 0)
						HueSelection.Position = UDim2.new(0.5, 0, 1 - ColorH, 0)
						CPConfig.Callback(Value)
					end
					Colorpicker:Set(Colorpicker.Value)

					Toggle.Colorpicker = Colorpicker
					if CPConfig.Flag then
						OrionLib.Flags[CPConfig.Flag] = Colorpicker
					end
				end
				if ToggleConfig.Flag then
					OrionLib.Flags[ToggleConfig.Flag] = Toggle
				end
				AddHelpQuestion(ToggleFrame, ToggleConfig.HelpQuestion)
				return Toggle
			end
			function ElementFunction:AddSlider(SliderConfig)
				Breathe()
				SliderConfig = SliderConfig or {}
				SliderConfig.Name = SliderConfig.Name or "Slider"
				SliderConfig.Min = SliderConfig.Min or 0
				SliderConfig.Max = SliderConfig.Max or 100
				SliderConfig.Increment = SliderConfig.Increment or 1
				SliderConfig.Default = SliderConfig.Default or 50
				SliderConfig.Callback = SliderConfig.Callback or function() end
				SliderConfig.ValueName = SliderConfig.ValueName or ""
				SliderConfig.Color = SliderConfig.Color or Color3.fromRGB(9, 149, 98)
				SliderConfig.Flag = SliderConfig.Flag or nil
				SliderConfig.Save = SliderConfig.Save or false
				local Slider = {Value = SliderConfig.Default, Default = SliderConfig.Default, Save = SliderConfig.Save}
				local Dragging = false
				local SliderDrag = SetChildren(SetProps(MakeElement("RoundFrame", SliderConfig.Color, 0, 5), {
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundTransparency = 0.3,
					ClipsDescendants = true
				}), {
					AddThemeObject(SetProps(MakeElement("Label", "value", 13), {
						Size = UDim2.new(1, -12, 0, 14),
						Position = UDim2.new(0, 12, 0, 6),
						Font = Enum.Font.GothamBold,
						Name = "Value",
						TextTransparency = 0
					}), "Text")
				})
				local SliderBar = SetChildren(SetProps(MakeElement("RoundFrame", SliderConfig.Color, 0, 5), {
					Size = UDim2.new(1, -24, 0, 26),
					Position = UDim2.new(0, 12, 0, 30),
					BackgroundTransparency = 0.9
				}), {
					SetProps(MakeElement("Stroke"), {
						Color = SliderConfig.Color
					}),
					AddThemeObject(SetProps(MakeElement("Label", "value", 13), {
						Size = UDim2.new(1, -12, 0, 14),
						Position = UDim2.new(0, 12, 0, 6),
						Font = Enum.Font.GothamBold,
						Name = "Value",
						TextTransparency = 0.8
					}), "Text"),
					SliderDrag
				})
				local SliderFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 8), {
					Size = UDim2.new(1, 0, 0, 65),
					Parent = ItemParent
				}), {
					AddThemeObject(SetProps(MakeElement("Label", SliderConfig.Name, 15), {
						Size = UDim2.new(1, -12, 0, 14),
						Position = UDim2.new(0, 12, 0, 10),
						Font = Enum.Font.GothamBold,
						Name = "Content"
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					SliderBar
				}), "Second")
				local function BeginDrag(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						Dragging = true
					end
				end
				local function EndDrag(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						Dragging = false
					end
				end
				local function UpdateDrag(Input)
					if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
						local SizeScale = math.clamp((Input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
						Slider:Set(SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * SizeScale))
						if OrionLib._configLoaded then
							CMSaveFlagsToFile(CM.CurrentConfig)
						end
					end
				end
				function Slider:Set(Value)
					self.Value = math.clamp(Round(Value, SliderConfig.Increment), SliderConfig.Min, SliderConfig.Max)
					TweenService:Create(SliderDrag, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale((self.Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 1)}):Play()
					SliderBar.Value.Text = tostring(self.Value) .. " " .. SliderConfig.ValueName
					SliderDrag.Value.Text = tostring(self.Value) .. " " .. SliderConfig.ValueName
					SliderConfig.Callback(self.Value)
				end      
				SliderBar.InputBegan:Connect(BeginDrag)
				SliderBar.InputEnded:Connect(EndDrag)
				UserInputService.InputChanged:Connect(UpdateDrag)
				Slider:Set(Slider.Value)
				if SliderConfig.Flag then				
					OrionLib.Flags[SliderConfig.Flag] = Slider
				end
				AddHelpQuestion(SliderFrame, SliderConfig.HelpQuestion)
				return Slider
			end  
			function ElementFunction:AddDropdown(DropdownConfig)
				Breathe()
				DropdownConfig = DropdownConfig or {}
				DropdownConfig.Name = DropdownConfig.Name or "Dropdown"
				DropdownConfig.Options = DropdownConfig.Options or {}
				DropdownConfig.Default = DropdownConfig.Default or ""
				DropdownConfig.Callback = DropdownConfig.Callback or function() end
				DropdownConfig.Flag = DropdownConfig.Flag or nil
				DropdownConfig.Save = DropdownConfig.Save or false
				local Dropdown = {Value = DropdownConfig.Default, Default = DropdownConfig.Default, Options = DropdownConfig.Options, Buttons = {}, Toggled = false, Type = "Dropdown", Save = DropdownConfig.Save}
				local MaxElements = 5
				if not table.find(Dropdown.Options, Dropdown.Value) then
					Dropdown.Value = "..."
				end
				local DropdownList = MakeElement("List")
				local DropdownContainer = AddThemeObject(SetProps(SetChildren(MakeElement("ScrollFrame", Color3.fromRGB(40, 40, 40), 4), {
					DropdownList
				}), {
					Parent = ItemParent,
					Position = UDim2.new(0, 0, 0, 38),
					Size = UDim2.new(1, 0, 1, -38),
					ClipsDescendants = true
				}), "Divider")
				local Click = SetProps(MakeElement("Button"), {
					Size = UDim2.new(1, 0, 1, 0)
				})
				local DropdownFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 8), {
					Size = UDim2.new(1, 0, 0, 38),
					Parent = ItemParent,
					ClipsDescendants = true
				}), {
					DropdownContainer,
					SetProps(SetChildren(MakeElement("TFrame"), {
						AddThemeObject(SetProps(MakeElement("Label", DropdownConfig.Name, 15), {
							Size = UDim2.new(1, -12, 1, 0),
							Position = UDim2.new(0, 12, 0, 0),
							Font = Enum.Font.GothamBold,
							Name = "Content"
						}), "Text"),
						AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072706796"), {
							Size = UDim2.new(0, 20, 0, 20),
							AnchorPoint = Vector2.new(0, 0.5),
							Position = UDim2.new(1, -30, 0.5, 0),
							ImageColor3 = Color3.fromRGB(240, 240, 240),
							Name = "Ico"
						}), "TextDark"),
						AddThemeObject(SetProps(MakeElement("Label", "Selected", 13), {
							Size = UDim2.new(1, -40, 1, 0),
							Font = Enum.Font.GothamSemibold,
							Name = "Selected",
							TextXAlignment = Enum.TextXAlignment.Right
						}), "TextDark"),
						AddThemeObject(SetProps(MakeElement("Frame"), {
							Size = UDim2.new(1, 0, 0, 1),
							Position = UDim2.new(0, 0, 1, -1),
							Name = "Line",
							Visible = false
						}), "Stroke"), 
						Click
					}), {
						Size = UDim2.new(1, 0, 0, 38),
						ClipsDescendants = true,
						Name = "F"
					}),
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					MakeElement("Corner")
				}), "Second")
				AddConnection(DropdownList:GetPropertyChangedSignal("AbsoluteContentSize"), function()
					DropdownContainer.CanvasSize = UDim2.new(0, 0, 0, DropdownList.AbsoluteContentSize.Y)
				end)  
			local function AddOptions(Options)
				Breathe()
					for _, Option in pairs(Options) do
						local OptionBtn = SetProps(SetChildren(MakeElement("Button"), {
							AddThemeObject(SetProps(MakeElement("Label", Option, 13, 0.4), {
								Position = UDim2.new(0, 10, 0, 0),
								Font = Enum.Font.GothamSemibold,
								Size = UDim2.new(1, -10, 1, 0),
								Name = "Title"
							}), "Text")
						}), {
							Parent = DropdownContainer,
							Size = UDim2.new(1, 0, 0, 28),
							BackgroundTransparency = 1,
							ClipsDescendants = true
						})
						AddConnection(OptionBtn.MouseEnter, function()
							if Dropdown.Value ~= Option then
								TweenService:Create(OptionBtn.Title, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
							end
						end)
						AddConnection(OptionBtn.MouseLeave, function()
							if Dropdown.Value ~= Option then
								TweenService:Create(OptionBtn.Title, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0.4}):Play()
							end
						end)
						AddConnection(OptionBtn.MouseButton1Click, function()
							Dropdown:Set(Option)
							if OrionLib._configLoaded then
								CMSaveFlagsToFile(CM.CurrentConfig)
							end
						end)
						Dropdown.Buttons[Option] = OptionBtn
					end
				end
				function Dropdown:Refresh(Options, Delete)
					if Delete then
						for _, v in pairs(Dropdown.Buttons) do
							Breathe()
							v:Destroy()
						end
						table.clear(Dropdown.Options)
						table.clear(Dropdown.Buttons)
					end
					Dropdown.Options = Options
					AddOptions(Dropdown.Options)
				end  
				function Dropdown:Set(Value)
					if not table.find(Dropdown.Options, Value) then
						Dropdown.Value = "..."
						DropdownFrame.F.Selected.Text = Dropdown.Value
						for _, v in pairs(Dropdown.Buttons) do
							SetFast(v, "BackgroundTransparency", 1)
							SetFast(v.Title, "TextTransparency", 0.4)
						end
						return
					end
					Dropdown.Value = Value
					DropdownFrame.F.Selected.Text = Dropdown.Value
					for _, v in pairs(Dropdown.Buttons) do
						SetFast(v.Title, "TextTransparency", 0.4)
					end
					local SelectedBtn = Dropdown.Buttons[Value]
					if SelectedBtn then
						SetFast(SelectedBtn.Title, "TextTransparency", 0)
						SetFast(SelectedBtn.Title, "TextColor3", Color3.fromRGB(255, 255, 255))
					end
				return DropdownConfig.Callback(Dropdown.Value)
				end
				AddConnection(Click.MouseButton1Click, function()
					Dropdown.Toggled = not Dropdown.Toggled
					DropdownFrame.F.Line.Visible = Dropdown.Toggled
					TweenService:Create(DropdownFrame.F.Ico, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = Dropdown.Toggled and 180 or 0}):Play()
					if #Dropdown.Options > MaxElements then
						TweenService:Create(DropdownFrame, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Dropdown.Toggled and UDim2.new(1, 0, 0, 38 + (MaxElements * 28)) or UDim2.new(1, 0, 0, 38)}):Play()
					else
						TweenService:Create(DropdownFrame, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Dropdown.Toggled and UDim2.new(1, 0, 0, DropdownList.AbsoluteContentSize.Y + 38) or UDim2.new(1, 0, 0, 38)}):Play()
					end
				end)
				Dropdown:Refresh(Dropdown.Options, false)
				Dropdown:Set(Dropdown.Value)
				if DropdownConfig.Flag then				
					OrionLib.Flags[DropdownConfig.Flag] = Dropdown
				end
				AddHelpQuestion(DropdownFrame, DropdownConfig.HelpQuestion)
				return Dropdown
			end
			function ElementFunction:AddDropdownAll(DropdownConfig)
				Breathe()
				DropdownConfig = DropdownConfig or {}
				DropdownConfig.Name = DropdownConfig.Name or "Dropdown"
				DropdownConfig.Options = DropdownConfig.Options or {}
				DropdownConfig.Default = DropdownConfig.Default or {}
				DropdownConfig.Callback = DropdownConfig.Callback or function() end
				DropdownConfig.Flag = DropdownConfig.Flag or nil
				DropdownConfig.Save = DropdownConfig.Save or false
				local Dropdown = {Value = {}, Options = DropdownConfig.Options, Buttons = {}, Toggled = false, Type = "DropdownAll", Save = DropdownConfig.Save}
				local MaxElements = 5
				if type(DropdownConfig.Default) == "table" then
					for _, v in pairs(DropdownConfig.Default) do
						table.insert(Dropdown.Value, v)
					end
				end
				local DropdownList = MakeElement("List")
				local DropdownContainer = AddThemeObject(SetProps(SetChildren(MakeElement("ScrollFrame", Color3.fromRGB(40, 40, 40), 4), {
					DropdownList
				}), {
					Parent = ItemParent,
					Position = UDim2.new(0, 0, 0, 38),
					Size = UDim2.new(1, 0, 1, -38),
					ClipsDescendants = true
				}), "Divider")
				local Click = SetProps(MakeElement("Button"), {
					Size = UDim2.new(1, 0, 1, 0)
				})
				local DropdownFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 8), {
					Size = UDim2.new(1, 0, 0, 38),
					Parent = ItemParent,
					ClipsDescendants = true
				}), {
					DropdownContainer,
					SetProps(SetChildren(MakeElement("TFrame"), {
						AddThemeObject(SetProps(MakeElement("Label", DropdownConfig.Name, 15), {
							Size = UDim2.new(1, -12, 1, 0),
							Position = UDim2.new(0, 12, 0, 0),
							Font = Enum.Font.GothamBold,
							Name = "Content"
						}), "Text"),
						AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072706796"), {
							Size = UDim2.new(0, 20, 0, 20),
							AnchorPoint = Vector2.new(0, 0.5),
							Position = UDim2.new(1, -30, 0.5, 0),
							ImageColor3 = Color3.fromRGB(240, 240, 240),
							Name = "Ico"
						}), "TextDark"),
						AddThemeObject(SetProps(MakeElement("Label", "None", 13), {
							Size = UDim2.new(1, -40, 1, 0),
							Font = Enum.Font.GothamSemibold,
							Name = "Selected",
							TextXAlignment = Enum.TextXAlignment.Right
						}), "TextDark"),
						AddThemeObject(SetProps(MakeElement("Frame"), {
							Size = UDim2.new(1, 0, 0, 1),
							Position = UDim2.new(0, 0, 1, -1),
							Name = "Line",
							Visible = false
						}), "Stroke"), 
						Click
					}), {
						Size = UDim2.new(1, 0, 0, 38),
						ClipsDescendants = true,
						Name = "F"
					}),
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					MakeElement("Corner")
				}), "Second")
				AddConnection(DropdownList:GetPropertyChangedSignal("AbsoluteContentSize"), function()
					DropdownContainer.CanvasSize = UDim2.new(0, 0, 0, DropdownList.AbsoluteContentSize.Y)
				end)
				local function UpdateSelectedText()
					if #Dropdown.Value == 0 then
						DropdownFrame.F.Selected.Text = "None"
					elseif #Dropdown.Value == 1 then
						DropdownFrame.F.Selected.Text = Dropdown.Value[1]
					else
						DropdownFrame.F.Selected.Text = #Dropdown.Value .. " Selected"
					end
				end
				local function IsSelected(Option)
					for _, v in pairs(Dropdown.Value) do
						if v == Option then return true end
					end
					return false
				end
				local function RemoveFromValue(Option)
					for i, v in pairs(Dropdown.Value) do
						if v == Option then
							table.remove(Dropdown.Value, i)
							return
						end
					end
				end
				local function AddOptions(Options)
					Breathe()
					for _, Option in pairs(Options) do
						local OptionBtn = SetProps(SetChildren(MakeElement("Button"), {
							AddThemeObject(SetProps(MakeElement("Label", Option, 13, 0.4), {
								Position = UDim2.new(0, 10, 0, 0),
								Font = Enum.Font.GothamSemibold,
								Size = UDim2.new(1, -10, 1, 0),
								Name = "Title"
							}), "Text")
						}), {
							Parent = DropdownContainer,
							Size = UDim2.new(1, 0, 0, 28),
							BackgroundTransparency = 1,
							ClipsDescendants = true
						})
						AddConnection(OptionBtn.MouseEnter, function()
							if not IsSelected(Option) then
								TweenService:Create(OptionBtn.Title, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
							end
						end)
						AddConnection(OptionBtn.MouseLeave, function()
							if not IsSelected(Option) then
								TweenService:Create(OptionBtn.Title, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0.4}):Play()
							end
						end)
						AddConnection(OptionBtn.MouseButton1Click, function()
							if IsSelected(Option) then
								RemoveFromValue(Option)
								TweenService:Create(OptionBtn.Title, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0.4}):Play()
							else
								table.insert(Dropdown.Value, Option)
								TweenService:Create(OptionBtn.Title, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
							end
							UpdateSelectedText()
							DropdownConfig.Callback(Dropdown.Value)
							if OrionLib._configLoaded then
								CMSaveFlagsToFile(CM.CurrentConfig)
							end
						end)
						Dropdown.Buttons[Option] = OptionBtn
					end
				end
				function Dropdown:Refresh(Options, Delete)
					if Delete then
						for _, v in pairs(Dropdown.Buttons) do Breathe() v:Destroy() end
						table.clear(Dropdown.Options)
						table.clear(Dropdown.Buttons)
						table.clear(Dropdown.Value)
					end
					Dropdown.Options = Options
					AddOptions(Dropdown.Options)
				end
				function Dropdown:Set(Values)
					if type(Values) ~= "table" then Values = {} end
					Dropdown.Value = {}
					for _, v in pairs(Dropdown.Buttons) do
						SetFast(v.Title, "TextTransparency", 0.4)
					end
					for _, Value in pairs(Values) do
						if table.find(Dropdown.Options, Value) then
							table.insert(Dropdown.Value, Value)
							local btn = Dropdown.Buttons[Value]
							if btn then
								SetFast(btn.Title, "TextTransparency", 0)
							end
						end
					end
					UpdateSelectedText()
					DropdownConfig.Callback(Dropdown.Value)
				end
				AddConnection(Click.MouseButton1Click, function()
					Dropdown.Toggled = not Dropdown.Toggled
					DropdownFrame.F.Line.Visible = Dropdown.Toggled
					TweenService:Create(DropdownFrame.F.Ico, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = Dropdown.Toggled and 180 or 0}):Play()
					if #Dropdown.Options > MaxElements then
						TweenService:Create(DropdownFrame, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Dropdown.Toggled and UDim2.new(1, 0, 0, 38 + (MaxElements * 28)) or UDim2.new(1, 0, 0, 38)}):Play()
					else
						TweenService:Create(DropdownFrame, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Dropdown.Toggled and UDim2.new(1, 0, 0, DropdownList.AbsoluteContentSize.Y + 38) or UDim2.new(1, 0, 0, 38)}):Play()
					end
				end)
				Dropdown:Refresh(Dropdown.Options, false)
				Dropdown:Set(DropdownConfig.Default)
				if DropdownConfig.Flag then
					OrionLib.Flags[DropdownConfig.Flag] = Dropdown
				end
				AddHelpQuestion(DropdownFrame, DropdownConfig.HelpQuestion)
				return Dropdown
			end
			function ElementFunction:AddDropdownAllSearch(DropdownConfig)
				Breathe()
				DropdownConfig = DropdownConfig or {}
				DropdownConfig.Name = DropdownConfig.Name or "Dropdown"
				DropdownConfig.Options = DropdownConfig.Options or {}
				DropdownConfig.Default = DropdownConfig.Default or {}
				DropdownConfig.Callback = DropdownConfig.Callback or function() end
				DropdownConfig.Flag = DropdownConfig.Flag or nil
				DropdownConfig.Save = DropdownConfig.Save or false
				local Dropdown = {Value = {}, Options = DropdownConfig.Options, Buttons = {}, Toggled = false, Type = "DropdownAll", Save = DropdownConfig.Save}
				local MaxElements = 5
				local CurrentFilter = ""
				if type(DropdownConfig.Default) == "table" then
					for _, v in pairs(DropdownConfig.Default) do
						table.insert(Dropdown.Value, v)
					end
				end
				local DropdownList = MakeElement("List")
				local DropdownContainer = AddThemeObject(SetProps(SetChildren(MakeElement("ScrollFrame", Color3.fromRGB(40, 40, 40), 4), {
					DropdownList
				}), {
					Parent = ItemParent,
					Position = UDim2.new(0, 0, 0, 70),
					Size = UDim2.new(1, 0, 1, -70),
					ClipsDescendants = true
				}), "Divider")
				local Click = SetProps(MakeElement("Button"), {
					Size = UDim2.new(1, 0, 0, 38)
				})
				local SearchBarFrame = Create("Frame", {
					Size = UDim2.new(1, 0, 0, 32),
					Position = UDim2.new(0, 0, 0, 38),
					BackgroundTransparency = 1,
					Visible = false,
					ZIndex = 5
				})
				local DividerLineTop = Create("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 0, 0),
					BackgroundColor3 = Color3.fromRGB(60, 60, 65),
					BorderSizePixel = 0,
					Parent = SearchBarFrame
				})
				local SearchIcon = Create("ImageLabel", {
					Size = UDim2.new(0, 14, 0, 14),
					Position = UDim2.new(0, 10, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = 1,
					Image = "rbxassetid://98908450631624",
					ImageColor3 = Color3.fromRGB(150, 150, 150),
					Parent = SearchBarFrame
				})
				local SearchBox = Create("TextBox", {
					Size = UDim2.new(1, -32, 1, -2),
					Position = UDim2.new(0, 30, 0, 1),
					BackgroundTransparency = 1,
					TextColor3 = Color3.fromRGB(240, 240, 240),
					PlaceholderColor3 = Color3.fromRGB(110, 110, 110),
					PlaceholderText = "Search players...",
					Font = Enum.Font.Gotham,
					TextSize = 13,
					ClearTextOnFocus = false,
					BorderSizePixel = 0,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 6,
					Parent = SearchBarFrame
				})
				local DividerLineBottom = Create("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 1, -1),
					BackgroundColor3 = Color3.fromRGB(60, 60, 65),
					BorderSizePixel = 0,
					Parent = SearchBarFrame
				})
				local DropdownFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 8), {
					Size = UDim2.new(1, 0, 0, 38),
					Parent = ItemParent,
					ClipsDescendants = true
				}), {
					DropdownContainer,
					SearchBarFrame,
					SetProps(SetChildren(MakeElement("TFrame"), {
						AddThemeObject(SetProps(MakeElement("Label", DropdownConfig.Name, 15), {
							Size = UDim2.new(1, -12, 1, 0),
							Position = UDim2.new(0, 12, 0, 0),
							Font = Enum.Font.GothamBold,
							Name = "Content"
						}), "Text"),
						AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072706796"), {
							Size = UDim2.new(0, 20, 0, 20),
							AnchorPoint = Vector2.new(0, 0.5),
							Position = UDim2.new(1, -30, 0.5, 0),
							ImageColor3 = Color3.fromRGB(240, 240, 240),
							Name = "Ico"
						}), "TextDark"),
						AddThemeObject(SetProps(MakeElement("Label", "None", 13), {
							Size = UDim2.new(1, -40, 1, 0),
							Font = Enum.Font.GothamSemibold,
							Name = "Selected",
							TextXAlignment = Enum.TextXAlignment.Right
						}), "TextDark"),
						AddThemeObject(SetProps(MakeElement("Frame"), {
							Size = UDim2.new(1, 0, 0, 1),
							Position = UDim2.new(0, 0, 1, -1),
							Name = "Line",
							Visible = false
						}), "Stroke"),
						Click
					}), {
						Size = UDim2.new(1, 0, 0, 38),
						ClipsDescendants = true,
						Name = "F"
					}),
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					MakeElement("Corner")
				}), "Second")
				AddConnection(DropdownList:GetPropertyChangedSignal("AbsoluteContentSize"), function()
					DropdownContainer.CanvasSize = UDim2.new(0, 0, 0, DropdownList.AbsoluteContentSize.Y)
				end)
				local function UpdateSelectedText()
					if #Dropdown.Value == 0 then
						DropdownFrame.F.Selected.Text = "None"
					elseif #Dropdown.Value == 1 then
						DropdownFrame.F.Selected.Text = Dropdown.Value[1]
					else
						DropdownFrame.F.Selected.Text = #Dropdown.Value .. " Selected"
					end
				end
				local function IsSelected(Option)
					for _, v in pairs(Dropdown.Value) do
						if v == Option then return true end
					end
					return false
				end
				local function RemoveFromValue(Option)
					for i, v in pairs(Dropdown.Value) do
						if v == Option then
							table.remove(Dropdown.Value, i)
							return
						end
					end
				end
				local function GetVisibleCount()
					local count = 0
					for _, btn in pairs(Dropdown.Buttons) do
						if btn.Visible then count = count + 1 end
					end
					return count
				end
				local function ApplyFilter(filter)
					filter = filter:lower()
					for Option, btn in pairs(Dropdown.Buttons) do
						local match = filter == "" or Option:lower():find(filter, 1, true)
						btn.Visible = match ~= nil and match ~= false
					end
					if Dropdown.Toggled then
						local visible = GetVisibleCount()
						local listHeight = math.min(visible, MaxElements) * 28
						TweenService:Create(DropdownFrame, TweenInfo.new(.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Size = UDim2.new(1, 0, 0, 70 + listHeight)
						}):Play()
					end
				end
				AddConnection(SearchBox:GetPropertyChangedSignal("Text"), function()
					CurrentFilter = SearchBox.Text
					ApplyFilter(CurrentFilter)
				end)
				local function AddOptions(Options)
					Breathe()
					for _, Option in pairs(Options) do
						if Dropdown.Buttons[Option] then continue end
						local OptionBtn = SetProps(SetChildren(MakeElement("Button"), {
							AddThemeObject(SetProps(MakeElement("Label", Option, 13, 0.4), {
								Position = UDim2.new(0, 10, 0, 0),
								Font = Enum.Font.GothamSemibold,
								Size = UDim2.new(1, -10, 1, 0),
								Name = "Title"
							}), "Text")
						}), {
							Parent = DropdownContainer,
							Size = UDim2.new(1, 0, 0, 28),
							BackgroundTransparency = 1,
							ClipsDescendants = true
						})
						AddConnection(OptionBtn.MouseEnter, function()
							if not IsSelected(Option) then
								TweenService:Create(OptionBtn.Title, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
							end
						end)
						AddConnection(OptionBtn.MouseLeave, function()
							if not IsSelected(Option) then
								TweenService:Create(OptionBtn.Title, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0.4}):Play()
							end
						end)
						AddConnection(OptionBtn.MouseButton1Click, function()
							if IsSelected(Option) then
								RemoveFromValue(Option)
								TweenService:Create(OptionBtn.Title, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0.4}):Play()
							else
								table.insert(Dropdown.Value, Option)
								TweenService:Create(OptionBtn.Title, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
							end
							UpdateSelectedText()
							DropdownConfig.Callback(Dropdown.Value)
							if OrionLib._configLoaded then
								CMSaveFlagsToFile(CM.CurrentConfig)
							end
						end)
						Dropdown.Buttons[Option] = OptionBtn
					end
					if CurrentFilter ~= "" then ApplyFilter(CurrentFilter) end
				end
				function Dropdown:Refresh(Options, Delete)
					local previousValues = {}
					for _, v in ipairs(Dropdown.Value) do
						previousValues[v] = true
					end
					if Delete then
						for _, v in pairs(Dropdown.Buttons) do Breathe() v:Destroy() end
						table.clear(Dropdown.Options)
						table.clear(Dropdown.Buttons)
						table.clear(Dropdown.Value)
					else
						for _, v in pairs(Dropdown.Buttons) do Breathe() v:Destroy() end
						table.clear(Dropdown.Buttons)
					end
					Dropdown.Options = Options
					AddOptions(Dropdown.Options)
					for _, v in ipairs(Dropdown.Value) do
						previousValues[v] = true
					end
					for option, btn in pairs(Dropdown.Buttons) do
						if previousValues[option] then
							SetFast(btn.Title, "TextTransparency", 0)
						end
					end
					UpdateSelectedText()
					if CurrentFilter ~= "" then ApplyFilter(CurrentFilter) end
				end
				function Dropdown:Set(Values)
					if type(Values) ~= "table" then Values = {} end
					Dropdown.Value = {}
					for _, v in pairs(Dropdown.Buttons) do
						SetFast(v.Title, "TextTransparency", 0.4)
					end
					for _, Value in pairs(Values) do
						if table.find(Dropdown.Options, Value) then
							table.insert(Dropdown.Value, Value)
							local btn = Dropdown.Buttons[Value]
							if btn then
								SetFast(btn.Title, "TextTransparency", 0)
							end
						end
					end
					UpdateSelectedText()
					DropdownConfig.Callback(Dropdown.Value)
				end
				AddConnection(Click.MouseButton1Click, function()
					Dropdown.Toggled = not Dropdown.Toggled
					DropdownFrame.F.Line.Visible = Dropdown.Toggled
					SearchBarFrame.Visible = Dropdown.Toggled
					TweenService:Create(DropdownFrame.F.Ico, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = Dropdown.Toggled and 180 or 0}):Play()
					if Dropdown.Toggled then
						SearchBox.Text = ""
						CurrentFilter = ""
						local count = math.min(#Dropdown.Options, MaxElements)
						TweenService:Create(DropdownFrame, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Size = UDim2.new(1, 0, 0, 70 + count * 28)
						}):Play()
						task.wait(0.15)
						SearchBox:CaptureFocus()
					else
						SearchBox.Text = ""
						CurrentFilter = ""
						ApplyFilter("")
						TweenService:Create(DropdownFrame, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Size = UDim2.new(1, 0, 0, 38)
						}):Play()
					end
				end)
				Dropdown:Refresh(Dropdown.Options, false)
				Dropdown:Set(DropdownConfig.Default)
				if DropdownConfig.Flag then
					OrionLib.Flags[DropdownConfig.Flag] = Dropdown
				end
				AddHelpQuestion(DropdownFrame, DropdownConfig.HelpQuestion)
				return Dropdown
			end
			function ElementFunction:AddBind(BindConfig)
				Breathe()
				BindConfig.Name = BindConfig.Name or "Bind"
				BindConfig.Default = BindConfig.Default or Enum.KeyCode.Unknown
				BindConfig.Hold = BindConfig.Hold or false
				BindConfig.Callback = BindConfig.Callback or function() end
				BindConfig.Flag = BindConfig.Flag or nil
				BindConfig.Save = BindConfig.Save or false
				local Bind = {Value, Default = BindConfig.Default, Binding = false, Type = "Bind", Save = BindConfig.Save}
				local Holding = false
				local Click = SetProps(MakeElement("Button"), {
					Size = UDim2.new(1, 0, 1, 0)
				})
				local BindBox = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4), {
					Size = UDim2.new(0, 24, 0, 24),
					Position = UDim2.new(1, -12, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5)
				}), {
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					AddThemeObject(SetProps(MakeElement("Label", BindConfig.Name, 14), {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(0, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.XY,
						Font = Enum.Font.GothamBold,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextYAlignment = Enum.TextYAlignment.Center,
						Name = "Value"
					}), "Text")
				}), "Main")
				local BindFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 8), {
					Size = UDim2.new(1, 0, 0, 38),
					Parent = ItemParent
				}), {
					AddThemeObject(SetProps(MakeElement("Label", BindConfig.Name, 15), {
						Size = UDim2.new(1, -12, 1, 0),
						Position = UDim2.new(0, 12, 0, 0),
						Font = Enum.Font.GothamBold,
						Name = "Content"
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					BindBox,
					Click
				}), "Second")
				AddConnection(BindBox.Value:GetPropertyChangedSignal("Text"), function()
					TweenService:Create(BindBox, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, math.max(math.ceil(BindBox.Value.TextBounds.X) + 18, 26), 0, 24)}):Play()
				end)
				local RemoveBind = Create("TextButton", {
					Text = "",
					BackgroundTransparency = 1,
					AutoButtonColor = false,
					BorderSizePixel = 0,
					Size = UDim2.new(0, 20, 0, 20),
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -38, 0.5, 0),
					ZIndex = 3,
					Parent = BindFrame
				})
				local RemoveBindLabel = Create("TextLabel", {
					Text = "X",
					Font = Enum.Font.GothamBold,
					TextSize = 13,
					BackgroundTransparency = 1,
					TextColor3 = Color3.fromRGB(220, 80, 80),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					ZIndex = 3,
					Parent = RemoveBind
				})
				local function UpdateRemoveBindPosition()
					RemoveBind.Position = UDim2.new(1, -12 - BindBox.AbsoluteSize.X - 6, 0.5, 0)
				end
				AddConnection(BindBox:GetPropertyChangedSignal("AbsoluteSize"), UpdateRemoveBindPosition)
				AddConnection(RemoveBind.MouseEnter, function()
					RemoveBindLabel.TextColor3 = Color3.fromRGB(255, 110, 110)
				end)
				AddConnection(RemoveBind.MouseLeave, function()
					RemoveBindLabel.TextColor3 = Color3.fromRGB(220, 80, 80)
				end)
				local LastUnbind = 0
				AddConnection(RemoveBind.MouseButton1Click, function()
					LastUnbind = tick()
					Bind.Binding = false
					Bind:Set(Enum.KeyCode.Unknown)
					if OrionLib._configLoaded then
						CMSaveFlagsToFile(CM.CurrentConfig)
					end
					task.defer(function()
						Bind.Binding = false
						Bind:Set(Enum.KeyCode.Unknown)
					end)
				end)
				AddConnection(Click.InputEnded, function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						if tick() - LastUnbind < 0.35 then return end
						if Bind.Binding then return end
						Bind.Binding = true
						BindBox.Value.Text = ""
					end
				end)
				AddConnection(UserInputService.InputBegan, function(Input)
					if UserInputService:GetFocusedTextBox() then return end
					if Bind.Value ~= "None" and (Input.KeyCode.Name == Bind.Value or Input.UserInputType.Name == Bind.Value) and not Bind.Binding then
						if BindConfig.Hold then
							Holding = true
							BindConfig.Callback(Holding)
						else
							BindConfig.Callback()
						end
					elseif Bind.Binding then
						if tick() - LastUnbind < 0.35 then
							Bind.Binding = false
							BindBox.Value.Text = Bind.Value
							return
						end
						local Key
						pcall(function()
							if not CheckKey(BlacklistedKeys, Input.KeyCode) then
								Key = Input.KeyCode
							end
						end)
						pcall(function()
							if CheckKey(WhitelistedMouse, Input.UserInputType) and not Key then
								Key = Input.UserInputType
							end
						end)
						Key = Key or Bind.Value
						Bind:Set(Key)
						if OrionLib._configLoaded then
							CMSaveFlagsToFile(CM.CurrentConfig)
						end
					end
				end)
				AddConnection(UserInputService.InputEnded, function(Input)
					if Bind.Value ~= "None" and (Input.KeyCode.Name == Bind.Value or Input.UserInputType.Name == Bind.Value) then
						if BindConfig.Hold and Holding then
							Holding = false
							BindConfig.Callback(Holding)
						end
					end
				end)
				AddConnection(Click.MouseEnter, function()
					TweenService:Create(BindFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Second.R * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Second.G * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Second.B * 255 + 3)}):Play()
				end)
				AddConnection(Click.MouseLeave, function()
					TweenService:Create(BindFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Second}):Play()
				end)
				AddConnection(Click.MouseButton1Up, function()
					TweenService:Create(BindFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Second.R * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Second.G * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Second.B * 255 + 3)}):Play()
				end)
				AddConnection(Click.MouseButton1Down, function()
					TweenService:Create(BindFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Second.R * 255 + 6, OrionLib.Themes[OrionLib.SelectedTheme].Second.G * 255 + 6, OrionLib.Themes[OrionLib.SelectedTheme].Second.B * 255 + 6)}):Play()
				end)
				function Bind:Set(Key)
					Bind.Binding = false
					Bind.Value = Key or Bind.Value
					Bind.Value = Bind.Value.Name or Bind.Value
					if Bind.Value == "Unknown" or Bind.Value == "" then
						Bind.Value = "None"
					end
					BindBox.Value.Text = Bind.Value
				end
				Bind:Set(BindConfig.Default)
				if BindConfig.Flag then				
					OrionLib.Flags[BindConfig.Flag] = Bind
				end
				AddHelpQuestion(BindFrame, BindConfig.HelpQuestion)
				return Bind
			end  
			function ElementFunction:AddTextbox(TextboxConfig)
				Breathe()
				TextboxConfig = TextboxConfig or {}
				TextboxConfig.Name = TextboxConfig.Name or "Textbox"
				TextboxConfig.Default = TextboxConfig.Default or ""
				TextboxConfig.TextDisappear = TextboxConfig.TextDisappear or false
				TextboxConfig.Callback = TextboxConfig.Callback or function() end
				local Click = SetProps(MakeElement("Button"), {
					Size = UDim2.new(1, 0, 1, 0)
				})
				local TextboxActual = AddThemeObject(Create("TextBox", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					PlaceholderColor3 = Color3.fromRGB(210, 210, 210),
					PlaceholderText = "Input",
					Font = Enum.Font.GothamSemibold,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextSize = 14,
					ClearTextOnFocus = false
				}), "Text")
				local TextContainer = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4), {
					Size = UDim2.new(0, 24, 0, 24),
					Position = UDim2.new(1, -12, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5)
				}), {
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					TextboxActual
				}), "Main")
				local TextboxFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 8), {
					Size = UDim2.new(1, 0, 0, 38),
					Parent = ItemParent
				}), {
					AddThemeObject(SetProps(MakeElement("Label", TextboxConfig.Name, 15), {
						Size = UDim2.new(1, -12, 1, 0),
						Position = UDim2.new(0, 12, 0, 0),
						Font = Enum.Font.GothamBold,
						Name = "Content"
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					TextContainer,
					Click
				}), "Second")
				local function UpdateTextContainerSize()
					local MaxWidth = math.max(60, TextboxFrame.AbsoluteSize.X - 24)
					local TargetWidth = math.clamp(TextboxActual.TextBounds.X + 16, 24, MaxWidth)
					TweenService:Create(TextContainer, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, TargetWidth, 0, 24)}):Play()
				end
				AddConnection(TextboxActual:GetPropertyChangedSignal("Text"), UpdateTextContainerSize)
				AddConnection(TextboxFrame:GetPropertyChangedSignal("AbsoluteSize"), UpdateTextContainerSize)
				AddConnection(TextboxActual.FocusLost, function()
					TextboxConfig.Callback(TextboxActual.Text)
					if TextboxConfig.TextDisappear then
						TextboxActual.Text = ""
					end	
				end)
				TextboxActual.Text = TextboxConfig.Default
				AddConnection(Click.MouseEnter, function()
					TweenService:Create(TextboxFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Second.R * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Second.G * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Second.B * 255 + 3)}):Play()
				end)
				AddConnection(Click.MouseLeave, function()
					TweenService:Create(TextboxFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Second}):Play()
				end)
				AddConnection(Click.MouseButton1Up, function()
					TweenService:Create(TextboxFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Second.R * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Second.G * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Second.B * 255 + 3)}):Play()
					TextboxActual:CaptureFocus()
				end)
				AddConnection(Click.MouseButton1Down, function()
					TweenService:Create(TextboxFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Second.R * 255 + 6, OrionLib.Themes[OrionLib.SelectedTheme].Second.G * 255 + 6, OrionLib.Themes[OrionLib.SelectedTheme].Second.B * 255 + 6)}):Play()
				end)
				AddHelpQuestion(TextboxFrame, TextboxConfig.HelpQuestion)
			end
			function ElementFunction:AddColorpicker(ColorpickerConfig)
				Breathe()
				ColorpickerConfig = ColorpickerConfig or {}
				ColorpickerConfig.Name = ColorpickerConfig.Name or "Colorpicker"
				ColorpickerConfig.Default = ColorpickerConfig.Default or Color3.fromRGB(255, 255, 255)
				ColorpickerConfig.Callback = ColorpickerConfig.Callback or function() end
				ColorpickerConfig.Flag = ColorpickerConfig.Flag or nil
				ColorpickerConfig.Save = ColorpickerConfig.Save or false
				local ColorH, ColorS, ColorV = 1, 1, 1
				local Colorpicker = {Value = ColorpickerConfig.Default, Toggled = false, Type = "Colorpicker", Save = ColorpickerConfig.Save}
				local ColorSelection = Create("ImageLabel", {
					Size = UDim2.new(0, 18, 0, 18),
					Position = UDim2.new(select(3, Color3.toHSV(Colorpicker.Value))),
					ScaleType = Enum.ScaleType.Fit,
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Image = "http://www.roblox.com/asset/?id=4805639000"
				})
				local HueSelection = Create("ImageLabel", {
					Size = UDim2.new(0, 18, 0, 18),
					Position = UDim2.new(0.5, 0, 1 - select(1, Color3.toHSV(Colorpicker.Value))),
					ScaleType = Enum.ScaleType.Fit,
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Image = "http://www.roblox.com/asset/?id=4805639000"
				})
				local Color = Create("ImageLabel", {
					Size = UDim2.new(1, -25, 1, 0),
					Visible = false,
					Image = "rbxassetid://4155801252"
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
					ColorSelection
				})
				local Hue = Create("Frame", {
					Size = UDim2.new(0, 20, 1, 0),
					Position = UDim2.new(1, -20, 0, 0),
					Visible = false
				}, {
					Create("UIGradient", {Rotation = 270, Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(234, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(21, 255, 0)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0, 17, 255)), ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 251)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))}}),
					Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
					HueSelection
				})
				local ColorpickerContainer = Create("Frame", {
					Position = UDim2.new(0, 0, 0, 32),
					Size = UDim2.new(1, 0, 1, -32),
					BackgroundTransparency = 1,
					ClipsDescendants = true
				}, {
					Hue,
					Color,
					Create("UIPadding", {
						PaddingLeft = UDim.new(0, 35),
						PaddingRight = UDim.new(0, 35),
						PaddingBottom = UDim.new(0, 10),
						PaddingTop = UDim.new(0, 17)
					})
				})
				local Click = SetProps(MakeElement("Button"), {
					Size = UDim2.new(1, 0, 1, 0)
				})
				local ColorpickerBox = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4), {
					Size = UDim2.new(0, 24, 0, 24),
					Position = UDim2.new(1, -12, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5)
				}), {
					AddThemeObject(MakeElement("Stroke"), "Stroke")
				}), "Main")
				local ColorpickerFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 8), {
					Size = UDim2.new(1, 0, 0, 38),
					Parent = ItemParent
				}), {
					SetProps(SetChildren(MakeElement("TFrame"), {
						AddThemeObject(SetProps(MakeElement("Label", ColorpickerConfig.Name, 15), {
							Size = UDim2.new(1, -12, 1, 0),
							Position = UDim2.new(0, 12, 0, 0),
							Font = Enum.Font.GothamBold,
							Name = "Content"
						}), "Text"),
						ColorpickerBox,
						Click,
						AddThemeObject(SetProps(MakeElement("Frame"), {
							Size = UDim2.new(1, 0, 0, 1),
							Position = UDim2.new(0, 0, 1, -1),
							Name = "Line",
							Visible = false
						}), "Stroke"), 
					}), {
						Size = UDim2.new(1, 0, 0, 38),
						ClipsDescendants = true,
						Name = "F"
					}),
					ColorpickerContainer,
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
				}), "Second")
				AddConnection(Click.MouseButton1Click, function()
					Colorpicker.Toggled = not Colorpicker.Toggled
					TweenService:Create(ColorpickerFrame, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Colorpicker.Toggled and UDim2.new(1, 0, 0, 148) or UDim2.new(1, 0, 0, 38)}):Play()
					Color.Visible = Colorpicker.Toggled
					Hue.Visible = Colorpicker.Toggled
					ColorpickerFrame.F.Line.Visible = Colorpicker.Toggled
				end)
				local function UpdateColorPicker()
					ColorpickerBox.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
					Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
					Colorpicker:Set(ColorpickerBox.BackgroundColor3)
					ColorpickerConfig.Callback(ColorpickerBox.BackgroundColor3)
					if OrionLib._configLoaded then
						CMSaveFlagsToFile(CM.CurrentConfig)
					end
				end
				ColorH = 1 - (math.clamp(HueSelection.AbsolutePosition.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
				ColorS = (math.clamp(ColorSelection.AbsolutePosition.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
				ColorV = 1 - (math.clamp(ColorSelection.AbsolutePosition.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)
				AddConnection(Color.InputBegan, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if ColorInput then ColorInput:Disconnect() end
						ColorInput = AddConnection(RunService.RenderStepped, function()
							local ColorX = (math.clamp(Mouse.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
							local ColorY = (math.clamp(Mouse.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)
							ColorSelection.Position = UDim2.new(ColorX, 0, ColorY, 0)
							ColorS = ColorX
							ColorV = 1 - ColorY
							UpdateColorPicker()
						end)
					end
				end)
				AddConnection(Color.InputEnded, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if ColorInput then ColorInput:Disconnect() end
					end
				end)
				AddConnection(Hue.InputBegan, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if HueInput then HueInput:Disconnect() end
						HueInput = AddConnection(RunService.RenderStepped, function()
							local HueY = (math.clamp(Mouse.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
							HueSelection.Position = UDim2.new(0.5, 0, HueY, 0)
							ColorH = 1 - HueY
							UpdateColorPicker()
						end)
					end
				end)
				AddConnection(Hue.InputEnded, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if HueInput then HueInput:Disconnect() end
					end
				end)
				function Colorpicker:Set(Value)
					Colorpicker.Value = Value
					ColorpickerBox.BackgroundColor3 = Colorpicker.Value
					ColorpickerConfig.Callback(Colorpicker.Value)
				end
				Colorpicker:Set(Colorpicker.Value)
				if ColorpickerConfig.Flag then				
					OrionLib.Flags[ColorpickerConfig.Flag] = Colorpicker
				end
				AddHelpQuestion(ColorpickerFrame, ColorpickerConfig.HelpQuestion)
				return Colorpicker
			end  
			return ElementFunction   
		end	

		local ElementFunction = {}

		function ElementFunction:AddSection(SectionConfig)
			Breathe()
			SectionConfig.Name = SectionConfig.Name or "Section"
			local SectionFrame = SetChildren(SetProps(MakeElement("TFrame"), {
				Size = UDim2.new(1, 0, 0, 26),
				Parent = Container
			}), {
				Create("Frame", {
					Size = UDim2.new(0, 2, 0, 12),
					Position = UDim2.new(0, 0, 0, 5),
					BackgroundColor3 = Color3.fromRGB(255, 239, 149),
					BorderSizePixel = 0,
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 2)})
				}),
				AddThemeObject(SetProps(MakeElement("Label", SectionConfig.Name, 14), {
					Size = UDim2.new(1, -12, 0, 16),
					Position = UDim2.new(0, 10, 0, 3), 
					Font = Enum.Font.GothamBold,
					TextTransparency = 0.35 
				}), "TextDark"),
				SetChildren(SetProps(MakeElement("TFrame"), {
					AnchorPoint = Vector2.new(0, 0),
					Size = UDim2.new(1, 0, 1, -24),
					Position = UDim2.new(0, 0, 0, 23),
					Name = "Holder"
				}), {
					MakeElement("List", 0, 6)
				}),
			})
			AddConnection(SectionFrame.Holder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
				SectionFrame.Size = UDim2.new(1, 0, 0, SectionFrame.Holder.UIListLayout.AbsoluteContentSize.Y + 31)
				SectionFrame.Holder.Size = UDim2.new(1, 0, 0, SectionFrame.Holder.UIListLayout.AbsoluteContentSize.Y)
			end)
			local SectionFunction = {}
			for i, v in next, GetElements(SectionFrame.Holder) do
				SectionFunction[i] = v 
			end
			return SectionFunction
		end	

		for i, v in next, GetElements(Container) do
			ElementFunction[i] = v 
		end

		if TabConfig.PremiumOnly then
			for i, v in next, ElementFunction do
				ElementFunction[i] = function() end
			end    
			Container:FindFirstChild("UIListLayout"):Destroy()
			Container:FindFirstChild("UIPadding"):Destroy()
			SetChildren(SetProps(MakeElement("TFrame"), {
				Size = UDim2.new(1, 0, 1, 0),
				Parent = ItemParent
			}), {
				AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://3610239960"), {
					Size = UDim2.new(0, 18, 0, 18),
					Position = UDim2.new(0, 15, 0, 15),
					ImageTransparency = 0.4
				}), "Text"),
				AddThemeObject(SetProps(MakeElement("Label", "Unauthorised Access", 14), {
					Size = UDim2.new(1, -38, 0, 14),
					Position = UDim2.new(0, 38, 0, 18),
					TextTransparency = 0.4
				}), "Text"),
				AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://4483345875"), {
					Size = UDim2.new(0, 56, 0, 56),
					Position = UDim2.new(0, 84, 0, 110),
				}), "Text"),
				AddThemeObject(SetProps(MakeElement("Label", "Premium Features", 14), {
					Size = UDim2.new(1, -150, 0, 14),
					Position = UDim2.new(0, 150, 0, 112),
					Font = Enum.Font.GothamBold
				}), "Text"),
				AddThemeObject(SetProps(MakeElement("Label", "This part of the script is locked to Sirius Premium users. Purchase Premium in the Discord server (discord.gg/sirius)", 12), {
					Size = UDim2.new(1, -200, 0, 14),
					Position = UDim2.new(0, 150, 0, 138),
					TextWrapped = true,
					TextTransparency = 0.4
				}), "Text")
			})
		end
		return ElementFunction   
	end 

	return TabFunction
end   

function OrionLib:Destroy()
	Orion:Destroy()
end

return OrionLib
