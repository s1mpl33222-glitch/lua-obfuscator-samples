-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local REAdminPanelServiceExecuteCommand = game:GetService("ReplicatedStorage").Packages.Net:FindFirstChild("RE/AdminPanelService/ExecuteCommand")
local t1 = {
	"rocket",
	"balloon",
	"inverse",
	"tiny",
	"morph",
	"jumpscare"
}
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "YoshiHubNew"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 220, 0, 320)
Frame.Position = UDim2.new(0.5, -110, 0.5, -160)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Visible = true
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

local TextLabel = Instance.new("TextLabel")

TextLabel.Parent = Frame
TextLabel.Size = UDim2.new(1, 0, 0, 32)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Yoshi Hub Spam"
TextLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 18

local ScrollingFrame = Instance.new("ScrollingFrame")

ScrollingFrame.Parent = Frame
ScrollingFrame.Position = UDim2.new(0, 10, 0, 40)
ScrollingFrame.Size = UDim2.new(1, -20, 1, -90)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 5
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", ScrollingFrame).CornerRadius = UDim.new(0, 10)

local UIListLayout = Instance.new("UIListLayout")

UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

local function v10(p1)
	local TextButton = Instance.new("TextButton")

	TextButton.Parent = ScrollingFrame
	TextButton.Size = UDim2.new(1, -4, 0, 45)
	TextButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	TextButton.BorderSizePixel = 0
	TextButton.Text = ""
	TextButton.AutoButtonColor = false
	Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 10)

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Parent = TextButton
	ImageLabel.Size = UDim2.new(0, 35, 0, 35)
	ImageLabel.Position = UDim2.new(0, 5, 0.5, -17)
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Image = "rbxthumb://type=AvatarHeadShot&id=" .. p1.UserId .. "&w=180&h=180"

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Parent = TextButton
	TextLabel2.Size = UDim2.new(1, -50, 1, 0)
	TextLabel2.Position = UDim2.new(0, 45, 0, 0)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = p1.Name
	TextLabel2.TextColor3 = Color3.fromRGB(0, 255, 120)
	TextLabel2.Font = Enum.Font.GothamBold
	TextLabel2.TextSize = 16
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left

	local function v14()
		task.spawn(function()
			for _, v in ipairs(t1) do
				task.spawn(function()
					REAdminPanelServiceExecuteCommand:FireServer(p1, v)
				end)
			end
		end)
		task.wait(0.01)
	end

	TextButton.MouseButton1Click:Connect(v14)
end
local function v17()
	local v18 = ScrollingFrame
	local v19, v20, v21 = ipairs(v18.GetChildren(v18))

	while true do
		local v22

		v21, v22 = v19(v20, v21)

		if not v21 then
			break
		end

		if v22:IsA("TextButton") then
			v22:Destroy()
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			v10(player)
		end
	end

	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end

v17()
Players.PlayerAdded:Connect(function()
	task.wait(0.2)
	v17()
end)
Players.PlayerRemoving:Connect(function()
	task.wait(0.2)
	v17()
end)

local TextLabel2 = Instance.new("TextLabel")

TextLabel2.Parent = Frame
TextLabel2.Size = UDim2.new(1, 0, 0, 35)
TextLabel2.Position = UDim2.new(0, 0, 1, -35)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Text = "Discord: discord.gg/GzeXGjJPKz"
TextLabel2.TextColor3 = Color3.fromRGB(0, 255, 120)
TextLabel2.Font = Enum.Font.GothamSemibold
TextLabel2.TextSize = 14
TextLabel2.TextWrapped = true
TextLabel2.TextYAlignment = Enum.TextYAlignment.Center
TextLabel2.TextXAlignment = Enum.TextXAlignment.Center
