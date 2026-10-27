local ScreenGui = Instance.new("ScreenGui")
local Menu = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local LeftCotent = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local FolderOpenRivalsModded = Instance.new("TextButton")
local ifopened = Instance.new("TextLabel")
local UICorner_2 = Instance.new("UICorner")
local Folder_RivalsModded = Instance.new("Frame")
local UIListLayout_2 = Instance.new("UIListLayout")
local TrevModded = Instance.new("TextButton")
local P2WModded = Instance.new("TextButton")
local Q4yjsModded = Instance.new("TextButton")
local UICorner_3 = Instance.new("UICorner")
local UICorner_5 = Instance.new("UICorner")
local UICorner_6 = Instance.new("UICorner")
local RightContent = Instance.new("Frame")
local Icon = Instance.new("ImageLabel")
local Loadbutton = Instance.new("TextButton")
local UICorner_4 = Instance.new("UICorner")
local Seletected = Instance.new("TextLabel")
local X = Instance.new("TextButton")

--Properties:

ScreenGui.Parent = game:GetService("CoreGui")

Menu.Name = "Menu"
Menu.Parent = ScreenGui
Menu.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
Menu.BorderColor3 = Color3.fromRGB(0, 0, 0)
Menu.BorderSizePixel = 0
Menu.Position = UDim2.new(0.199835524, 0, 0.151324078, 0)
Menu.Size = UDim2.new(0, 710, 0, 517)

local UserInputService = game:GetService("UserInputService")

local dragging = false
local dragStart
local startPos

Menu.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = Menu.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart

        Menu.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UICorner.CornerRadius = UDim.new(0, 18)
UICorner.Parent = Menu

LeftCotent.Name = "LeftCotent"
LeftCotent.Parent = Menu
LeftCotent.Active = true
LeftCotent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LeftCotent.BackgroundTransparency = 1.000
LeftCotent.BorderColor3 = Color3.fromRGB(0, 0, 0)
LeftCotent.BorderSizePixel = 0
LeftCotent.Position = UDim2.new(0.0169014093, 0, 0.0270793028, 0)
LeftCotent.Size = UDim2.new(0, 230, 0, 486)
LeftCotent.CanvasSize = UDim2.new(0, 0, 0, 0)
LeftCotent.ScrollBarThickness = 8
LeftCotent.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left

UIListLayout.Parent = LeftCotent
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

FolderOpenRivalsModded.Name = "FolderOpenRivalsModded"
FolderOpenRivalsModded.Parent = LeftCotent
FolderOpenRivalsModded.BackgroundColor3 = Color3.fromRGB(91, 91, 91)
FolderOpenRivalsModded.BorderColor3 = Color3.fromRGB(0, 0, 0)
FolderOpenRivalsModded.BorderSizePixel = 0
FolderOpenRivalsModded.Size = UDim2.new(0, 230, 0, 50)
FolderOpenRivalsModded.AutoButtonColor = false
FolderOpenRivalsModded.Font = Enum.Font.SourceSans
FolderOpenRivalsModded.Text = "Rivals Modded"
FolderOpenRivalsModded.TextColor3 = Color3.fromRGB(255, 255, 255)
FolderOpenRivalsModded.TextSize = 24.000

ifopened.Name = "ifopened"
ifopened.Parent = FolderOpenRivalsModded
ifopened.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ifopened.BackgroundTransparency = 1.000
ifopened.BorderColor3 = Color3.fromRGB(0, 0, 0)
ifopened.BorderSizePixel = 0
ifopened.Rotation = 90.000
ifopened.Size = UDim2.new(0, 54, 0, 50)
ifopened.Font = Enum.Font.SourceSans
ifopened.Text = "<"
ifopened.TextColor3 = Color3.fromRGB(255, 255, 255)
ifopened.TextSize = 40.000
ifopened.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)

UICorner_2.CornerRadius = UDim.new(0, 16)
UICorner_2.Parent = FolderOpenRivalsModded

Folder_RivalsModded.Name = "Folder_RivalsModded"
Folder_RivalsModded.Parent = LeftCotent
Folder_RivalsModded.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Folder_RivalsModded.BackgroundTransparency = 1.000
Folder_RivalsModded.BorderColor3 = Color3.fromRGB(0, 0, 0)
Folder_RivalsModded.BorderSizePixel = 0
Folder_RivalsModded.Position = UDim2.new(0.0695652142, 0, 0.102880657, 0)
Folder_RivalsModded.Size = UDim2.new(0, 214, 0, 200)
Folder_RivalsModded.Visible = false

FolderOpenRivalsModded.MouseButton1Click:Connect(function()
	Folder_RivalsModded.Visible = not Folder_RivalsModded.Visible
	ifopened.Text = Folder_RivalsModded.Visible and ">" or "<"
end)

UIListLayout_2.Parent = Folder_RivalsModded
UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Right
UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

TrevModded.Name = "Trev Modded"
TrevModded.Parent = Folder_RivalsModded
TrevModded.BackgroundColor3 = Color3.fromRGB(59, 59, 59)
TrevModded.BorderColor3 = Color3.fromRGB(0, 0, 0)
TrevModded.BorderSizePixel = 0
TrevModded.Position = UDim2.new(0, 0, 0.735294104, 0)
TrevModded.Size = UDim2.new(0, 214, 0, 50)
TrevModded.AutoButtonColor = false
TrevModded.Font = Enum.Font.SourceSans
TrevModded.Text = "Trev Modded"
TrevModded.TextColor3 = Color3.fromRGB(255, 255, 255)
TrevModded.TextSize = 30.000
TrevModded.TextWrapped = true

Q4yjsModded.Parent = Folder_RivalsModded
Q4yjsModded.BackgroundColor3 = Color3.fromRGB(59, 59, 59)
Q4yjsModded.BorderColor3 = Color3.fromRGB(0, 0, 0)
Q4yjsModded.BorderSizePixel = 0
Q4yjsModded.Position = UDim2.new(0, 0, 0.735294104, 0)
Q4yjsModded.Size = UDim2.new(0, 214, 0, 50)
Q4yjsModded.AutoButtonColor = false
Q4yjsModded.Font = Enum.Font.SourceSans
Q4yjsModded.Text = "Q4yjs Modded"
Q4yjsModded.TextColor3 = Color3.fromRGB(255, 255, 255)
Q4yjsModded.TextSize = 30.000
Q4yjsModded.TextWrapped = true

P2WModded.Parent = Folder_RivalsModded
P2WModded.BackgroundColor3 = Color3.fromRGB(59, 59, 59)
P2WModded.BorderColor3 = Color3.fromRGB(0, 0, 0)
P2WModded.BorderSizePixel = 0
P2WModded.Position = UDim2.new(0, 0, 0.735294104, 0)
P2WModded.Size = UDim2.new(0, 214, 0, 50)
P2WModded.AutoButtonColor = false
P2WModded.Font = Enum.Font.SourceSans
P2WModded.Text = "P2W Modded"
P2WModded.TextColor3 = Color3.fromRGB(255, 255, 255)
P2WModded.TextSize = 30.000
P2WModded.TextWrapped = true

UICorner_3.CornerRadius = UDim.new(0, 16)
UICorner_3.Parent = TrevModded

UICorner_5.CornerRadius = UDim.new(0, 16)
UICorner_5.Parent = P2WModded

UICorner_6.CornerRadius = UDim.new(0, 16)
UICorner_6.Parent = Q4yjsModded

RightContent.Name = "RightContent"
RightContent.Parent = Menu
RightContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RightContent.BackgroundTransparency = 1.000
RightContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
RightContent.BorderSizePixel = 0
RightContent.Position = UDim2.new(0.340845078, 0, 0.0270793028, 0)
RightContent.Size = UDim2.new(0, 451, 0, 486)

Icon.Name = "Icon"
Icon.Parent = RightContent
Icon.AnchorPoint = Vector2.new(0.5, 0.5)
Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Icon.BackgroundTransparency = 1.000
Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
Icon.BorderSizePixel = 0
Icon.Position = UDim2.new(0.5, 0, 0.150000006, 0)
Icon.Size = UDim2.new(0, 150, 0, 150)
Icon.Image = "rbxassetid://94871403025987"

Loadbutton.Name = "Loadbutton"
Loadbutton.Parent = RightContent
Loadbutton.BackgroundColor3 = Color3.fromRGB(74, 74, 74)
Loadbutton.BorderColor3 = Color3.fromRGB(0, 0, 0)
Loadbutton.BorderSizePixel = 0
Loadbutton.Position = UDim2.new(0.210643008, 0, 0.757201672, 0)
Loadbutton.Size = UDim2.new(0, 261, 0, 50)
Loadbutton.Font = Enum.Font.SourceSans
Loadbutton.Text = "Load"
Loadbutton.TextColor3 = Color3.fromRGB(255, 255, 255)
Loadbutton.TextSize = 28.000

UICorner_4.CornerRadius = UDim.new(1, 0)
UICorner_4.Parent = Loadbutton

local Seletectedscript = "None"

Seletected.Name = "Seletected"
Seletected.Parent = RightContent
Seletected.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Seletected.BackgroundTransparency = 1.000
Seletected.BorderColor3 = Color3.fromRGB(0, 0, 0)
Seletected.BorderSizePixel = 0
Seletected.Position = UDim2.new(0.104212858, 0, 0.450617284, 0)
Seletected.Size = UDim2.new(0, 357, 0, 50)
Seletected.Font = Enum.Font.SourceSans
Seletected.Text = "Seleceted Scripted: None"
Seletected.TextColor3 = Color3.fromRGB(255, 255, 255)
Seletected.TextSize = 20.000

TrevModded.MouseButton1Click:Connect(function()
	Seletectedscript = TrevModded.Text
	Seletected.Text = "Seleceted Scripted: "..Seletectedscript
end)
Q4yjsModded.MouseButton1Click:Connect(function()
	Seletectedscript = Q4yjsModded.Text
	Seletected.Text = "Seleceted Scripted: "..Seletectedscript
end)
P2WModded.MouseButton1Click:Connect(function()
	Seletectedscript = P2WModded.Text
	Seletected.Text = "Seleceted Scripted: "..Seletectedscript
end)

X.Name = "X"
X.Parent = Menu
X.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
X.BackgroundTransparency = 1.000
X.BorderColor3 = Color3.fromRGB(0, 0, 0)
X.BorderSizePixel = 0
X.Position = UDim2.new(0.946478844, 0, 0, 0)
X.Size = UDim2.new(0, 29, 0, 38)
X.AutoButtonColor = false
X.Font = Enum.Font.FredokaOne
X.Text = "X"
X.TextColor3 = Color3.fromRGB(208, 208, 208)
X.TextSize = 40.000
X.TextWrapped = true
X.TextXAlignment = Enum.TextXAlignment.Right
X.TextYAlignment = Enum.TextYAlignment.Top
X.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

local database = {
	["Trev Modded"] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/men-cofing-roblox/MenHubPrem/main/Scripts/TrevModded.luau'))()",
	["Q4yjs Modded"] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/men-cofing-roblox/MenHubPrem/main/Scripts/Q4yjsModded.luau'))()",
	["P2W Modded"] = "game:GetService('Players').LocalPlayer:Kick('Soon')"
}

Loadbutton.MouseButton1Click:Connect(function()
	if Seletectedscript == "None" then return end
	task.spawn(function() loadstring(database[Seletectedscript])() end)
	ScreenGui:Destroy()
end)
