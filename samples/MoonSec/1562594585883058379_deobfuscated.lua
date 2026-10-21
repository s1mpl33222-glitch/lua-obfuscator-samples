local LocalPlayer = game.Players.LocalPlayer

LocalPlayer = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
LocalPlayer.Name = "AccelGui"
LocalPlayer.ResetOnSpawn = false

local Frame = Instance.new("Frame", LocalPlayer)

Frame.Size = UDim2.new(0, 250, 0, 120)
Frame.Position = UDim2.new(0.5, -125, 0.5, -60)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Active = true
Frame.Draggable = true
Frame.BorderSizePixel = 0

local TextLabel = Instance.new("TextLabel", Frame)

TextLabel.Size = UDim2.new(1, -50, 0, 25)
TextLabel.Position = UDim2.new(0, 0, 0, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Acceleration Changer"
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.TextSize = 18
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel = Instance.new("TextButton", Frame)
TextLabel.Size = UDim2.new(0, 25, 0, 25)
TextLabel.Position = UDim2.new(1, -50, 0, 0)
TextLabel.Text = "-"
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.TextSize = 18
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
TextLabel.BorderSizePixel = 0

local TextButton = Instance.new("TextButton", Frame)

TextButton.Size = UDim2.new(0, 25, 0, 25)
TextButton.Position = UDim2.new(1, -25, 0, 0)
TextButton.Text = "X"
TextButton.Font = Enum.Font.SourceSansBold
TextButton.TextSize = 18
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
TextButton.BorderSizePixel = 0

local TextBox = Instance.new("TextBox", Frame)

TextBox.Size = UDim2.new(0.8, 0, 0, 30)
TextBox.Position = UDim2.new(0.1, 0, 0.4, 0)
TextBox.PlaceholderText = "Enter Acceleration"
TextBox.Text = ""
TextBox.Font = Enum.Font.SourceSans
TextBox.TextSize = 18
TextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.Name = "InputBox"

local TextButton2 = Instance.new("TextButton", Frame)

TextButton2.Size = UDim2.new(0.8, 0, 0, 30)
TextButton2.Position = UDim2.new(0.1, 0, 0.75, 0)
TextButton2.Text = "Submit"
TextButton2.Font = Enum.Font.SourceSansBold
TextButton2.TextSize = 18
TextButton2.BackgroundColor3 = Color3.fromRGB(20, 120, 80)
TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton2.Name = "SubmitButton"

local TextButton3 = Instance.new("TextButton", LocalPlayer)

TextButton3.Size = UDim2.new(0, 80, 0, 30)
TextButton3.Position = UDim2.new(0, 10, 0.5, -15)
TextButton3.Text = "Toggle"
TextButton3.Font = Enum.Font.SourceSansBold
TextButton3.TextSize = 16
TextButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton3.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
TextButton3.Visible = false
TextButton3.Active = true
TextButton3.Draggable = true

local function v8(p1)
	local v9, v10, v11 = pairs(getgc(true))
	local n1 = 999

	while true do
		local v13

		v11, v13 = v9(v10, v11)

		if v11 == nil then
			break
		end

		if type(v13) == "table" and rawget(v13, "GearSpeeds") ~= nil then
			task.wait()

			for i = 1, 5 do
				v13.GearSpeeds[i] = n1
				v13.GearAccels[i] = p1
			end
		end
	end
end

TextButton2.MouseButton1Click:Connect(function()
	local v15 = tonumber(TextBox.Text)

	if v15 then
		v8(v15)
	else
		TextBox.Text = "Enter a number!"
	end
end)

local u16 = false

TextLabel.MouseButton1Click:Connect(function()
	u16 = not u16
	TextBox.Visible = not u16
	TextButton2.Visible = not u16
	Frame.Size = u16 and UDim2.new(0, 250, 0, 25) or UDim2.new(0, 250, 0, 120)
end)
TextButton.MouseButton1Click:Connect(function()
	Frame.Visible = false
	TextButton3.Visible = true
end)
TextButton3.MouseButton1Click:Connect(function()
	Frame.Visible = true
	TextButton3.Visible = false
end)
