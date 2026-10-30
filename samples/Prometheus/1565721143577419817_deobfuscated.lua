-- This file was generated at discord.gg/syncrypt

local color3 = Color3.fromRGB(255, 255, 0);

(function()
	local CoreGui = game:GetService("CoreGui")
	local ScreenGui = Instance.new("ScreenGui", CoreGui)
	local Frame = Instance.new("Frame", ScreenGui)

	Frame.Size = UDim2.new(0, 250, 0, 200)
	Frame.Position = UDim2.new(0.5, -125, 0.5, -100)
	Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	Frame.Active = true
	Frame.Draggable = true
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 15)
	Instance.new("UIStroke", Frame).Color = color3

	local TextLabel = Instance.new("TextLabel", Frame)

	TextLabel.Size = UDim2.new(1, 0, 0, 30)
	TextLabel.Position = UDim2.new(0, 0, 0, 5)
	TextLabel.Text = "MADE BY NAOUI"
	TextLabel.TextColor3 = color3
	TextLabel.BackgroundTransparency = 1
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 14

	local TextBox = Instance.new("TextBox", Frame)

	TextBox.Size = UDim2.new(0, 200, 0, 35)
	TextBox.Position = UDim2.new(0.5, -100, 0.35, 0)
	TextBox.PlaceholderText = "Enter Key..."
	TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
	TextBox.TextColor3 = Color3.new(1, 1, 1)
	Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 8)

	local TextButton = Instance.new("TextButton", Frame)

	TextButton.Size = UDim2.new(0, 200, 0, 35)
	TextButton.Position = UDim2.new(0.5, -100, 0.6, 0)
	TextButton.Text = "VERIFY"
	TextButton.BackgroundColor3 = color3
	TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextButton.Font = Enum.Font.GothamBold
	TextButton.Parent = Frame

	local TextButton2 = Instance.new("TextButton", Frame)

	TextButton2.Size = UDim2.new(0, 200, 0, 25)
	TextButton2.Position = UDim2.new(0.5, -100, 0.85, 0)
	TextButton2.Text = "GET KEY LINK"
	TextButton2.BackgroundTransparency = 1
	TextButton2.TextColor3 = Color3.fromRGB(150, 150, 150)
	TextButton2.Parent = Frame
	TextButton2.MouseButton1Click:Connect(function()
		setclipboard("https://lootdest.org/s?7CZnqWEX")
		TextButton2.Text = "COPIED!"
	end)
	TextButton.MouseButton1Click:Connect(function()
		local ok, result = pcall(function()
			return game:HttpGet("https://script.google.com/macros/s/AKfycbxZbPWXaHNaIhNdPLHKGlptQUKmdhh9tQJCrvqdHu6Ia5IWlmMm68vc91QfFzSRj_2i/exec")
		end)

		if not ok then
			if ok then
				ScreenGui:Destroy()
				loadstring(game:HttpGet("https://pasteblox.com/raw/3ywtqjgd2p"))()
			else
				TextBox.Text = ""
				TextBox.PlaceholderText = "WRONG KEY!"
			end

			return
		end

		ok = result:gsub("%s+", "") == TextBox.Text

		if ok then
			ScreenGui:Destroy()
			loadstring(game:HttpGet("https://pasteblox.com/raw/3ywtqjgd2p"))()
		else
			TextBox.Text = ""
			TextBox.PlaceholderText = "WRONG KEY!"
		end
	end)
end)()
