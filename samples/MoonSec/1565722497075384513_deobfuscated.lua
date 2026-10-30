local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Frame2 = Instance.new("Frame")
local UICorner2 = Instance.new("UICorner")
local TextButton = Instance.new("TextButton")
local TextButton2 = Instance.new("TextButton")
local Frame3 = Instance.new("Frame")
local UICorner3 = Instance.new("UICorner")
local TextLabel = Instance.new("TextLabel")
local TextButton3 = Instance.new("TextButton")
local UICorner4 = Instance.new("UICorner")
local ImageLabel = Instance.new("ImageLabel")
local TextButton4 = Instance.new("TextButton")
local UICorner5 = Instance.new("UICorner")
local ImageLabel2 = Instance.new("ImageLabel")
local Frame4 = Instance.new("Frame")
local UICorner6 = Instance.new("UICorner")
local TextLabel2 = Instance.new("TextLabel")
local TextButton5 = Instance.new("TextButton")
local UICorner7 = Instance.new("UICorner")

Instance.new("TextButton")
Instance.new("UICorner")

local TextLabel3 = Instance.new("TextLabel")

ScreenGui.Name = "ScriptCentral Hub"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local function v23()
	return game:GetService("UserInputService").TouchEnabled
end

local v24 = v23() and "Mobile" or "PC"
local v25 = ({
	PC = {
		width = 500,
		height = 500,
		titleSize = 34,
		textSize = 24,
		flagSize = 0.25
	},
	Mobile = {
		width = 320,
		height = 250,
		titleSize = 22,
		textSize = 14,
		flagSize = 0.25
	}
})[v24]

Frame.Name = "MainFrame"
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.5, -v25.width / 2, 0.5, -v25.height / 2)
Frame.Size = UDim2.new(0, v25.width, 0, v25.height)
Frame.Draggable = true
Frame.Active = true
Frame.Selectable = true
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame
Frame2.Name = "TabBar"
Frame2.Parent = Frame
Frame2.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Frame2.BorderSizePixel = 0
Frame2.Size = UDim2.new(1, 0, 0, 32)
UICorner2.CornerRadius = UDim.new(0, 8)
UICorner2.Parent = Frame2
TextButton.Name = "CloseButton"
TextButton.Parent = Frame2
TextButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
TextButton.BackgroundTransparency = 0.8
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.92, 0, 0.15, 0)
TextButton.Size = UDim2.new(0, 22, 0, 22)
TextButton.Font = Enum.Font.GothamBold
TextButton.Text = "×"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextSize = 18
TextButton.MouseButton1Down:Connect(function()
	ScreenGui:Destroy()
end)
TextButton2.Name = "MinimizeButton"
TextButton2.Parent = Frame2
TextButton2.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
TextButton2.BackgroundTransparency = 0.8
TextButton2.BorderSizePixel = 0
TextButton2.Position = UDim2.new(0.85, 0, 0.15, 0)
TextButton2.Size = UDim2.new(0, 22, 0, 22)
TextButton2.Font = Enum.Font.GothamBold
TextButton2.Text = "-"
TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton2.TextSize = 18

local u26 = false

TextButton2.MouseButton1Down:Connect(function()
	u26 = not u26
	Frame3.Visible = not u26
	Frame.Size = u26 and UDim2.new(0, v25.width, 0, 32) or UDim2.new(0, v25.width, 0, v25.height)
end)
Frame3.Name = "ContentFrame"
Frame3.Parent = Frame
Frame3.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
Frame3.BorderSizePixel = 0
Frame3.Position = UDim2.new(0, 0, 0.114, 0)
Frame3.Size = UDim2.new(1, 0, 0.886, 0)
UICorner3.CornerRadius = UDim.new(0, 8)
UICorner3.Parent = Frame3
TextLabel.Name = "Title"
TextLabel.Parent = Frame3
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0.1, 0, 0.02, 0)
TextLabel.Size = UDim2.new(0.8, 0, 0.08, 0)
TextLabel.Font = Enum.Font.GothamMedium
TextLabel.Text = "Universal Languages"
TextLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
TextLabel.TextSize = v25.titleSize
TextLabel.TextWrapped = true
TextButton3.Name = "PortugueseButton"
TextButton3.Parent = Frame3
TextButton3.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
TextButton3.BorderSizePixel = 0
TextButton3.Position = UDim2.new(0.1, 0, 0.15, 0)
TextButton3.Size = UDim2.new(0.8, 0, 0.12, 0)
TextButton3.Font = Enum.Font.Gotham
TextButton3.Text = v24 == "PC" and "Executar Português" or "Português"
TextButton3.TextColor3 = Color3.fromRGB(240, 240, 240)
TextButton3.TextSize = v25.textSize
TextButton3.TextWrapped = true
TextButton3.MouseButton1Down:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/ScriptCentral-br/ScriptCentral/refs/heads/main/README.md", true))()
end)
UICorner4.CornerRadius = UDim.new(0, 6)
UICorner4.Parent = TextButton3
ImageLabel.Name = "PortugueseFlag"
ImageLabel.Parent = TextButton3
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Position = UDim2.new(0.02, 0, 0.15, 0)
ImageLabel.Size = UDim2.new(v25.flagSize, 0, 0.7, 0)
ImageLabel.Image = "rbxassetid://74283357140722"
ImageLabel.ScaleType = Enum.ScaleType.Fit
TextButton4.Name = "EnglishButton"
TextButton4.Parent = Frame3
TextButton4.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
TextButton4.BorderSizePixel = 0
TextButton4.Position = UDim2.new(0.1, 0, 0.32, 0)
TextButton4.Size = UDim2.new(0.8, 0, 0.12, 0)
TextButton4.Font = Enum.Font.Gotham
TextButton4.Text = v24 == "PC" and "Execute English" or "English"
TextButton4.TextColor3 = Color3.fromRGB(240, 240, 240)
TextButton4.TextSize = v25.textSize
TextButton4.TextWrapped = true
TextButton4.MouseButton1Down:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/ScriptCentral-br/ScriptCentralKeyUs/refs/heads/main/SystemKey.md", true))()
end)
UICorner5.CornerRadius = UDim.new(0, 6)
UICorner5.Parent = TextButton4
ImageLabel2.Name = "EnglishFlag"
ImageLabel2.Parent = TextButton4
ImageLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel2.BackgroundTransparency = 1
ImageLabel2.Position = UDim2.new(0.02, 0, 0.15, 0)
ImageLabel2.Size = UDim2.new(v25.flagSize, 0, 0.7, 0)
ImageLabel2.Image = "rbxassetid://85306941087226"
ImageLabel2.ScaleType = Enum.ScaleType.Fit
Frame4.Name = "KeySection"
Frame4.Parent = Frame3
Frame4.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
Frame4.BorderSizePixel = 0
Frame4.Position = UDim2.new(0.05, 0, 0.5, 0)
Frame4.Size = UDim2.new(0.9, 0, 0.35, 0)
UICorner6.CornerRadius = UDim.new(0, 6)
UICorner6.Parent = Frame4
TextLabel2.Name = "GetKeyLabel"
TextLabel2.Parent = Frame4
TextLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Position = UDim2.new(0.1, 0, 0.05, 0)
TextLabel2.Size = UDim2.new(0.8, 0, 0.15, 0)
TextLabel2.Font = Enum.Font.GothamMedium
TextLabel2.Text = "Discord"
TextLabel2.TextColor3 = Color3.fromRGB(200, 200, 200)
TextLabel2.TextSize = v25.textSize
TextLabel2.TextWrapped = true
TextButton5.Name = "DiscordButton"
TextButton5.Parent = Frame4
TextButton5.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
TextButton5.BorderSizePixel = 0
TextButton5.Position = UDim2.new(0.1, 0, 0.25, 0)
TextButton5.Size = UDim2.new(0.8, 0, 0.25, 0)
TextButton5.Font = Enum.Font.Gotham
TextButton5.Text = "DISCORD"
TextButton5.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton5.TextSize = v25.textSize
TextButton5.TextWrapped = true
TextButton5.MouseButton1Down:Connect(function()
	setclipboard("https://discord.gg/NyhbVzG8qz")
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "COPIADO!",
		Text = "Discord link copiado",
		Duration = 3
	})
end)
UICorner7.CornerRadius = UDim.new(0, 6)
UICorner7.Parent = TextButton5
TextLabel3.Name = "Footer"
TextLabel3.Parent = Frame3
TextLabel3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel3.BackgroundTransparency = 1
TextLabel3.Position = UDim2.new(0.1, 0, 0.88, 0)
TextLabel3.Size = UDim2.new(0.8, 0, 0.05, 0)
TextLabel3.Font = Enum.Font.Gotham
TextLabel3.Text = "Discord: blazito_yt"
TextLabel3.TextColor3 = Color3.fromRGB(180, 180, 180)
TextLabel3.TextSize = v25.textSize - 2
TextLabel3.TextWrapped = true
(function()
	local VirtualUser = game:GetService("VirtualUser")

	game:GetService("Players").LocalPlayer.Idled:Connect(function()
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end)

	if not v23() then
		return
	end

	spawn(function()
		while task.wait(30) do
			pcall(function()
				local v28 = math.random(50, 100)
				local v29 = math.random(50, 100)

				game:GetService("VirtualInputManager"):SendMouseButtonEvent(v28, v29, 0, true, game, 1)
				task.wait(0.1)
				game:GetService("VirtualInputManager"):SendMouseButtonEvent(v28, v29, 0, false, game, 1)
			end)
		end
	end)
end)()
print("100%")
