local screenGui = Instance.new("ScreenGui")
local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local vim = game:GetService("VirtualInputManager")

screenGui.Parent = playerGui

local select_key_button = Instance.new("TextButton")
select_key_button.Size = UDim2.fromScale(0.050, 0.050)
select_key_button.Position = UDim2.fromScale(0.020, 0.020)
select_key_button.BackgroundColor3 = Color3.fromRGB(24, 26, 31)
select_key_button.TextColor3 = Color3.fromRGB(237, 237, 237)
select_key_button.Text = "Select key"
select_key_button.TextScaled = true
select_key_button.Parent = screenGui

local keys = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}
local button_x_pos = 0
local button_y_pos = 0
local button_count = 0
local selected_key

select_key_button.MouseButton1Click:Connect(function()
    local frame = Instance.new("Frame")
	frame.Size = UDim2.fromScale(0.35, 0.35)
	frame.Position = UDim2.fromScale(0.5, 0.5)
	frame.BackgroundColor3 = Color3.fromRGB(24, 26, 31)
	frame.BackgroundTransparency = 0.05
	frame.Active = true
	frame.Selectable = true
	frame.Draggable = true
	frame.Parent = screenGui

	for _, key in keys do
		local button = Instance.new("TextButton")
		button.Size = UDim2.fromScale(0.1, 0.1)
		button.Position = UDim2.fromScale(button_x_pos, button_y_pos)
		button.BackgroundColor3 = Color3.fromRGB(24, 26, 31)
		button.TextColor3 = Color3.fromRGB(237, 237, 237)
		button.Text = key
		button.TextScaled = true
		button.Parent = frame

		button_count += 1
		button_x_pos += 0.1

		if button_count == 10 or button_count == 20 or button_count == 30 then
			button_y_pos += 0.1
			button_x_pos = 0
		end

		button.MouseButton1Click:Connect(function()
			selected_key = Enum.KeyCode[string.upper(key)]
			frame:Destroy()
		end)
	end
end)

local toggle = false

local toggle_button = Instance.new("TextButton")
toggle_button.Size = UDim2.fromScale(0.050, 0.050)
toggle_button.Position = UDim2.fromScale(0.020, 0.070)
toggle_button.BackgroundColor3 = Color3.fromRGB(24, 26, 31)
toggle_button.TextColor3 = Color3.fromRGB(237, 237, 237)
toggle_button.Text = "Enable"
toggle_button.TextScaled = true
toggle_button.Parent = screenGui

toggle_button.MouseButton1Click:Connect(function()
    toggle = not toggle

	if toggle then
		toggle_button.Text = "Disable"
	else
		toggle_button.Text = "Enable"
	end

	task.spawn(function()
		while toggle do
			vim:SendKeyEvent(true, selected_key, false, game)
			task.wait(0.3)
			vim:SendKeyEvent(false, selected_key, false, game)
		end
	end)
end)
