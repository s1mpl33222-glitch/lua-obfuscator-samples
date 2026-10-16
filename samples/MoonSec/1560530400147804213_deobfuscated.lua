local LocalPlayer = game.Players.LocalPlayer

game:GetService("TweenService")

local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))

ScreenGui.Name = "BuffMayManGUI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)

Frame.Size = UDim2.new(0, 320, 0, 160)
Frame.Position = UDim2.new(0.35, 0, 0.35, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
Frame.Active = true
Frame.Draggable = true

local UIStroke = Instance.new("UIStroke", Frame)

UIStroke.Color = Color3.fromRGB(255, 0, 0)
UIStroke.Thickness = 3

local TextLabel = Instance.new("TextLabel", Frame)

TextLabel.Size = UDim2.new(1, 0, 0.3, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Font = Enum.Font.GothamBlack
TextLabel.TextScaled = true
TextLabel.Text = "BUFF MAY MẮN"
TextLabel.TextStrokeTransparency = 0
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

local TextButton = Instance.new("TextButton", Frame)

TextButton.Size = UDim2.new(0.8, 0, 0.3, 0)
TextButton.Position = UDim2.new(0.1, 0, 0.4, 0)
TextButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TextButton.Font = Enum.Font.GothamBold
TextButton.TextScaled = true
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextStrokeTransparency = 0
TextButton.Text = "BẬT BUFF MAY MẮN"

local UIStroke2 = Instance.new("UIStroke", TextButton)

UIStroke2.Color = Color3.fromRGB(255, 0, 0)
UIStroke2.Thickness = 2

local TextLabel2 = Instance.new("TextLabel", Frame)

TextLabel2.Position = UDim2.new(0, 0, 0.82, 0)
TextLabel2.Size = UDim2.new(1, 0, 0.15, 0)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Font = Enum.Font.Gotham
TextLabel2.TextColor3 = Color3.fromRGB(200, 200, 200)
TextLabel2.TextStrokeTransparency = 0.7
TextLabel2.TextSize = 14
TextLabel2.Text = "Qbao Script | RandomFruitsLucky X5"

local u9 = false

TextButton.MouseButton1Click:Connect(function()
	-- upvalues: u9 (ref), TextButton (ref)
	u9 = not u9

	if not u9 then
		TextButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		TextButton.Text = "BUFF: ĐÃ TẮT"
	else
		TextButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
		TextButton.Text = "BUFF: ĐANG HOẠT ĐỘNG"
		game.StarterGui:SetCore("SendNotification", {
			Title = "Qbao Buff",
			Text = "Đang kích hoạt buff may mắn khi random ra trái xịn!",
			Duration = 5
		})
	end
end)
