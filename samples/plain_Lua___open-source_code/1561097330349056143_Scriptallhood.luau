
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "DiscordNoticeGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.new(0, 520, 0, 260)
main.Position = UDim2.new(0.5, -260, 0.5, -130)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(60, 60, 60)
stroke.Thickness = 1.5
stroke.Transparency = 0.3

local title = Instance.new("TextLabel")
title.Parent = main
title.Size = UDim2.new(1, 0, 0, 70)
title.BackgroundTransparency = 1
title.Text = "Free Version Required"
title.Font = Enum.Font.GothamBold
title.TextSize = 32
title.TextColor3 = Color3.fromRGB(255, 255, 255)

local line = Instance.new("Frame")
line.Parent = main
line.Size = UDim2.new(1, -40, 0, 1)
line.Position = UDim2.new(0, 20, 0, 70)
line.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
line.BorderSizePixel = 0
line.BackgroundTransparency = 0.4

local desc = Instance.new("TextLabel")
desc.Parent = main
desc.Size = UDim2.new(1, -60, 0, 90)
desc.Position = UDim2.new(0, 30, 0, 90)
desc.BackgroundTransparency = 1
desc.TextWrapped = true
desc.Text = "To get the free version of this script, join our Discord server."
desc.Font = Enum.Font.Gotham
desc.TextSize = 18
desc.TextColor3 = Color3.fromRGB(210, 210, 210)

local button = Instance.new("TextButton")
button.Parent = main
button.Size = UDim2.new(0, 320, 0, 55)
button.Position = UDim2.new(0.5, -160, 1, -75)
button.BackgroundColor3 = Color3.fromRGB(70, 110, 255)
button.BorderSizePixel = 0
button.Text = "Copy Discord Link"
button.Font = Enum.Font.GothamBold
button.TextSize = 22
button.TextColor3 = Color3.fromRGB(255, 255, 255)

Instance.new("UICorner", button).CornerRadius = UDim.new(0, 12)

local shadow = Instance.new("ImageLabel")
shadow.Parent = main
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.7
shadow.BackgroundTransparency = 1
shadow.ZIndex = -1

local discordLink = "https://discord.gg/28vaW3A6KZ"

button.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(discordLink)
		button.Text = "Link Copied!"
	end
end)
