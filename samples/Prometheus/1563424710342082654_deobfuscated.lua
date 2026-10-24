-- This file was generated at discord.gg/syncrypt

local ScreenGui = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))

ScreenGui.Name = "NeonKeyHub"

local t1 = {
	[94590879393563] = "https://pastebin.com/raw/ELN0FhTg",
	[116793284465110] = "https://pastebin.com/raw/ug9aGaLR"
}
local Frame = Instance.new("Frame", ScreenGui)

Frame.Size = UDim2.new(0, 320, 0, 180)
Frame.Position = UDim2.new(0.5, -160, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Name = "MainFrame"
Instance.new("UICorner", Frame)

local TextLabel = Instance.new("TextLabel", Frame)

TextLabel.Text = "🔐 Neon Hub Access"
TextLabel.Size = UDim2.new(1, 0, 0, 30)
TextLabel.Position = UDim2.new(0, 0, 0, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 18

local TextButton = Instance.new("TextButton", Frame)

TextButton.Text = "📎 Get Key "
TextButton.Size = UDim2.new(0.8, 0, 0, 30)
TextButton.Position = UDim2.new(0.1, 0, 0, 40)
TextButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TextButton.Font = Enum.Font.Gotham
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextSize = 14
Instance.new("UICorner", TextButton)

local TextBox = Instance.new("TextBox", Frame)

TextBox.PlaceholderText = "Enter your key here..."
TextBox.Size = UDim2.new(0.8, 0, 0, 30)
TextBox.Position = UDim2.new(0.1, 0, 0, 80)
TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.Font = Enum.Font.Gotham
TextBox.TextSize = 14
Instance.new("UICorner", TextBox)

local TextButton2 = Instance.new("TextButton", Frame)

TextButton2.Text = "✅ Verify Key"
TextButton2.Size = UDim2.new(0.8, 0, 0, 30)
TextButton2.Position = UDim2.new(0.1, 0, 0, 120)
TextButton2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton2.Font = Enum.Font.Gotham
TextButton2.TextSize = 14
Instance.new("UICorner", TextButton2)
TextButton.MouseButton1Click:Connect(function()
	setclipboard("https://keygen.atwebpages.com/")
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Copied Link",
		Text = "Key URL copied to clipboard!",
		Duration = 4
	})
end)

local function v8(p1)
	local ok, result = pcall(function()
		return game:HttpGet("https://keygen.atwebpages.com/keys.txt")
	end)

	if not ok then
		return false
	end

	for match in string.gmatch(result, "[^\r\n]+") do
		if match == p1 then
			return true
		end
	end

	return false
end

TextButton2.MouseButton1Click:Connect(function()
	if v8(TextBox.Text) then
		TextButton2.Text = "✅ Verified!"
		wait(1)
		ScreenGui:Destroy()

		local default = t1[game.PlaceId] or t1.default

		if default then
			loadstring(game:HttpGet(default))()

			return
		else
			warn("No script found for this game")

			return
		end
	else
		TextButton2.Text = "❌ Invalid Key"
		wait(1.5)
		TextButton2.Text = "✅ Verify Key"
	end
end)
Frame.Active = true
Frame.Draggable = true
