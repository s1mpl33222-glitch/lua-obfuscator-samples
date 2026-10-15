if (getgenv().SLC_LOADED) then
	return
end
getgenv().SLC_LOADED = true

getgenv().script_key = "trial"

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Player = Players.LocalPlayer
local placeId = game.PlaceId

local Accent = Color3.fromRGB(158, 188, 242)

local Colors = {
	Background = Color3.fromRGB(17, 17, 17),
	Outer = Color3.fromRGB(58, 58, 58),
	Inner = Color3.fromRGB(38, 38, 38),
	Line = Color3.fromRGB(44, 44, 44),
	Card = Color3.fromRGB(33, 33, 33),
	CardTop = Color3.fromRGB(36, 36, 36),
	Field = Color3.fromRGB(33, 33, 33),
	FieldBorder = Color3.fromRGB(12, 12, 12),
	Button = Color3.fromRGB(27, 27, 27),
	ButtonBorder = Color3.fromRGB(42, 42, 42),
	ButtonHover = Color3.fromRGB(36, 36, 36),
	ButtonDown = Color3.fromRGB(22, 22, 22),
	Title = Color3.fromRGB(215, 215, 215),
	Text = Color3.fromRGB(175, 175, 175),
}

local RegularFont = Enum.Font.Gotham
local BoldFont = Enum.Font.GothamBold

local DAHOOD_BLOCKED = {2788229376, 16033173781, 7213786345}
local PRISONLIFE_BLOCKED = {155615604, 135564683255158}


local Games = {
	{
		Name = "universal",
		Description = "released 2026/10/01 02:00",
		Icon = "rbxassetid://126591499864857",
		Load = function()
		    for _, blockedId in ipairs(PRISONLIFE_BLOCKED) do
    			if placeId == blockedId then
    				LocalPlayer:Kick("[solitude.club] Wrong loader folks.")
    				return
    			end
    		end
    	    for _, blockedId in ipairs(DAHOOD_BLOCKED) do
    			if placeId == blockedId then
    				LocalPlayer:Kick("[solitude.club] Wrong loader folks.")
    				return
    			end
    		end
            loadstring(game:HttpGet("https://api.polsec.net/loader/55646c593e9f5876/69c53274fcb3f6b0"))()
		end,
	},
	{
		Name = "da hood copies",
		Description = "uses reformation.gg old loader",
		Icon = "rbxassetid://89122179205544",
		Load = function()
			for _, blockedId in ipairs(DAHOOD_BLOCKED) do
    			if placeId == blockedId then
    				LocalPlayer:Kick("[solitude.club] This script does not support the official Da Hood game. Only Da Hood copies are currently supported. Join our Discord for more information.")
    				return
    			end
    		end
    		for _, blockedId in ipairs(PRISONLIFE_BLOCKED) do
    			if placeId == blockedId then
    				LocalPlayer:Kick("[solitude.club] Wrong loader folks.")
    				return
    			end
    		end
    		loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua", true))()
    		loadstring(game:HttpGet("https://api.polsec.net/loader/55646c593e9f5876/7191705ceb5d4cc9"))()
		end,
	},
	{
		Name = "prison life",
		Description = "released 2026/10/14 05:42",
		Icon = "rbxassetid://109100556780679",
		Load = function()
			local allowed = false
            for _, yesId in ipairs(PRISONLIFE_BLOCKED) do
                if placeId == yesId then
                    allowed = true
                    break
                end
            end
            if not allowed then
                LocalPlayer:Kick("[solitude.club] Wrong loader folks.")
                return
            end
            loadstring(game:HttpGet("https://api.polsec.net/loader/55646c593e9f5876/3f5c0927aad40780"))()
			return
		end,
	},
	{
		Name = "rivals",
		Description = "release estimated time: unknown",
		Icon = "rbxassetid://80523481507824",
		Load = function()
			LocalPlayer:Kick("[solitude.club] Coming soon.")
		end,
	},
}

local DesignWidth = 520
local DesignHeight = 400
local ScreenFill = 0.92
local GameRowHeight = 41

local function Create(ClassName, Properties, Parent)
	local Object = Instance.new(ClassName)
	for Key, Value in pairs(Properties) do
		Object[Key] = Value
	end
	Object.Parent = Parent
	return Object
end

local function AddStroke(Parent, Color, Thickness)
	return Create("UIStroke", {
		Color = Color,
		Thickness = Thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, Parent)
end

local function CreateLabel(Parent, Text, X, Y, Width, Height, Options)
	Options = Options or {}
	return Create("TextLabel", {
		BackgroundTransparency = 1,
		Text = Text,
		Font = Options.Font or RegularFont,
		TextSize = Options.Size or 12,
		TextColor3 = Options.Color or Colors.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		Position = UDim2.fromOffset(X, Y),
		Size = UDim2.fromOffset(Width, Height),
	}, Parent)
end

local function CreateGroupBox(Parent, Title, X, Y, Width, Height)
	local Box = Create("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(X, Y),
		Size = UDim2.fromOffset(Width, Height),
	}, Parent)
	AddStroke(Box, Colors.Line)

	local TitleLabel = Create("TextLabel", {
		BackgroundColor3 = Colors.Background,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(8, -7),
		Size = UDim2.fromOffset(0, 14),
		AutomaticSize = Enum.AutomaticSize.X,
		Text = Title,
		Font = BoldFont,
		TextSize = 11,
		TextColor3 = Colors.Title,
	}, Box)
	Create("UIPadding", {
		PaddingLeft = UDim.new(0, 4),
		PaddingRight = UDim.new(0, 4),
	}, TitleLabel)

	return Box
end

local function CreateButton(Parent, Text, X, Y, Width, Height, OnClick)
	local Button = Create("TextButton", {
		BackgroundColor3 = Colors.Button,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Position = UDim2.fromOffset(X, Y),
		Size = UDim2.fromOffset(Width, Height),
		Text = Text,
		Font = BoldFont,
		TextSize = 12,
		TextColor3 = Colors.Title,
	}, Parent)
	AddStroke(Button, Colors.ButtonBorder)

	Button.MouseEnter:Connect(function()
		Button.BackgroundColor3 = Colors.ButtonHover
	end)
	Button.MouseLeave:Connect(function()
		Button.BackgroundColor3 = Colors.Button
	end)
	Button.MouseButton1Down:Connect(function()
		Button.BackgroundColor3 = Colors.ButtonDown
	end)
	Button.MouseButton1Up:Connect(function()
		Button.BackgroundColor3 = Colors.ButtonHover
	end)
	Button.MouseButton1Click:Connect(OnClick)

	return Button
end

local Gui = Create("ScreenGui", {
	Name = "LoaderUI",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
}, Player:WaitForChild("PlayerGui"))

local Window = Create("Frame", {
	Name = "Window",
	BackgroundColor3 = Colors.Background,
	BorderSizePixel = 0,
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(DesignWidth, DesignHeight),
}, Gui)
AddStroke(Window, Colors.Outer, 2)

local WindowScale = Create("UIScale", {}, Window)

local function UpdateScale()
	local Camera = Workspace.CurrentCamera
	if not Camera then
		return
	end
	local Viewport = Camera.ViewportSize
	WindowScale.Scale = math.min(
		1,
		Viewport.X * ScreenFill / DesignWidth,
		Viewport.Y * ScreenFill / DesignHeight
	)
end

UpdateScale()

local Camera = Workspace.CurrentCamera
if Camera then
	Camera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)
end

local InnerFrame = Create("Frame", {
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(6, 6),
	Size = UDim2.new(1, -12, 1, -12),
}, Window)
AddStroke(InnerFrame, Colors.Inner)

Create("Frame", {
	BackgroundColor3 = Accent,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(9, 8),
	Size = UDim2.new(1, -18, 0, 2),
}, Window)

local GamesBox = Create("Frame", {
	BackgroundColor3 = Colors.Card,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(26, 35),
	Size = UDim2.fromOffset(275, 124),
}, Window)
AddStroke(GamesBox, Colors.Line)

local GameList = Create("ScrollingFrame", {
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Active = true,
	Size = UDim2.new(1, 0, 1, -1),
	CanvasSize = UDim2.new(0, 0, 0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	ScrollingDirection = Enum.ScrollingDirection.Y,
	ScrollBarThickness = 3,
	ScrollBarImageColor3 = Colors.Outer,
}, GamesBox)

Create("UIListLayout", {
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 0),
}, GameList)

local SelectedGame = Games[1]
local RefreshFunctions = {}

local function CreateGameRow(Game, Order)
	local Row = Create("TextButton", {
		BackgroundColor3 = Colors.CardTop,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
		LayoutOrder = Order,
		Size = UDim2.new(1, 0, 0, GameRowHeight),
	}, GameList)

	Create("ImageLabel", {
		BackgroundTransparency = 1,
		Image = Game.Icon,
		ImageColor3 = Color3.new(1, 1, 1),
		Position = UDim2.new(0, 13, 0.5, -16),
		Size = UDim2.fromOffset(32, 32),
		ScaleType = Enum.ScaleType.Fit,
	}, Row)

	local TitleLabel = CreateLabel(Row, Game.Name, 58, 5, 200, 17)
	CreateLabel(Row, Game.Description, 58, 22, 200, 15)

	local function Refresh()
		local Selected = SelectedGame == Game
		Row.BackgroundTransparency = Selected and 0 or 1
		TitleLabel.Font = Selected and BoldFont or RegularFont
		TitleLabel.TextColor3 = Selected and Colors.Title or Colors.Text
	end

	table.insert(RefreshFunctions, Refresh)

	Row.MouseButton1Click:Connect(function()
		if SelectedGame == Game then
			return
		end
		SelectedGame = Game
		for _, RefreshRow in ipairs(RefreshFunctions) do
			RefreshRow()
		end
	end)

	Refresh()
end

for Index, Game in ipairs(Games) do
	CreateGameRow(Game, Index)
end

local OptionsBox = CreateGroupBox(Window, "options", 316, 35, 180, 124)

CreateButton(OptionsBox, "load", 22, 26, 136, 23, function()
	local Game = SelectedGame
	Gui:Destroy()
	Game.Load()
end)

CreateButton(OptionsBox, "exit", 22, 66, 136, 23, function()
	Gui:Destroy()
end)

local StatusBox = CreateGroupBox(Window, "status", 26, 176, 470, 198)

local StatusField = Create("Frame", {
	BackgroundColor3 = Colors.Field,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(19, 22),
	Size = UDim2.fromOffset(432, 158),
}, StatusBox)
AddStroke(StatusField, Colors.FieldBorder)

local LineHeight = 22

local function CreateStatusLine(Index, Text, Options)
	return CreateLabel(StatusField, Text, 8, 2 + (Index - 1) * LineHeight, 410, LineHeight, Options)
end

local SelectedStatus = nil
local StatusRefreshFunctions = {}

local function CreateStatusToggle(Index, Text)
	local Row = Create("TextButton", {
		BackgroundColor3 = Colors.CardTop,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Position = UDim2.fromOffset(2, 2 + (Index - 1) * LineHeight),
		Size = UDim2.fromOffset(428, LineHeight),
		Text = Text,
		Font = RegularFont,
		TextSize = 12,
		TextColor3 = Colors.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, StatusField)
	Create("UIPadding", {
		PaddingLeft = UDim.new(0, 6),
	}, Row)

	local function Refresh()
		local Selected = SelectedStatus == Row
		Row.BackgroundTransparency = Selected and 0 or 1
		Row.Font = Selected and BoldFont or RegularFont
		Row.TextColor3 = Selected and Colors.Title or Colors.Text
	end

	table.insert(StatusRefreshFunctions, Refresh)

	Row.MouseButton1Click:Connect(function()
		if SelectedStatus == Row then
			SelectedStatus = nil
		else
			SelectedStatus = Row
		end
		for _, RefreshRow in ipairs(StatusRefreshFunctions) do
			RefreshRow()
		end
	end)

	return Row
end

CreateStatusToggle(1, "connected")
CreateStatusToggle(2, string.format("welcome back, %s (@%s)", Player.DisplayName, Player.Name))
CreateStatusToggle(3, "build date: sep 23 2026")
local TimeSessionLabel = CreateStatusToggle(4, "time session: 00m 00s")
CreateStatusLine(5, "waiting for user", { Font = BoldFont, Color = Colors.Title })

local StartTime = os.clock()

task.spawn(function()
	while Gui.Parent do
		local Elapsed = math.floor(os.clock() - StartTime)
		TimeSessionLabel.Text = string.format("time session: %02dm %02ds", Elapsed // 60, Elapsed % 60)
		task.wait(1)
	end
end)

local Dragging = false
local DragStart
local StartPosition

Window.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1
		or Input.UserInputType == Enum.UserInputType.Touch then
		Dragging = true
		DragStart = Input.Position
		StartPosition = Window.Position
	end
end)

UserInputService.InputChanged:Connect(function(Input)
	if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement
		or Input.UserInputType == Enum.UserInputType.Touch) then
		local Delta = Input.Position - DragStart
		Window.Position = UDim2.new(
			StartPosition.X.Scale, StartPosition.X.Offset + Delta.X,
			StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1
		or Input.UserInputType == Enum.UserInputType.Touch then
		Dragging = false
	end
end)
