-- This file was generated at discord.gg/syncrypt

game:GetService("HttpService")

local LocalPlayer = game:GetService("Players").LocalPlayer
local t1 = {
	the_j = {
		AccessLevel = "Access",
		Expires = nil
	}
}
local t2 = {
	ValidKeys = t1,
	WhitelistedUsers = {},
	SaveKeyEnabled = false,
	DiscordInvite = "https://discord.gg/wZkYuPMkdb",
	DiscordInviteCode = "wZkYuPMkdb"
}

local function v4(p1)
	if table.find(t2.WhitelistedUsers, LocalPlayer.UserId) then
		return true, "Whitelisted User", "Access"
	end

	local v5 = string.lower(p1)

	if not t2.ValidKeys[v5] then
		return false, "Invalid Key!", nil
	end

	local v6 = t2.ValidKeys[v5]
	local Expires = v6.Expires

	if Expires then
	elseif Expires then
		return false, "Key has expired!", nil
	else
		return true, "Valid Key", v6.AccessLevel
	end

	Expires = v6.Expires < os.time()

	if Expires then
		return false, "Key has expired!", nil
	else
		return true, "Valid Key", v6.AccessLevel
	end
end

function LoadMainScript(_)
	print("Access Granted")
	print("Loading Script...")
	loadstring(game:HttpGet("https://pastebin.com/raw/xbYLu9w4"))()
end

(function()
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "ScriptOfJKey"
	ScreenGui.Parent = game:GetService("CoreGui")
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local Frame = Instance.new("Frame")

	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BackgroundTransparency = 0.6
	Frame.Parent = ScreenGui

	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.new(0, 450, 0, 450)
	Frame2.Position = UDim2.new(0.5, -225, 0.5, -225)
	Frame2.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	Frame2.BorderSizePixel = 0
	Frame2.Parent = ScreenGui

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, 15)
	UICorner.Parent = Frame2

	local UIGradient = Instance.new("UIGradient")

	UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 100, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 30, 100)) })
	UIGradient.Rotation = 45
	UIGradient.Parent = Frame2

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, 0, 0, 60)
	TextLabel.Position = UDim2.new(0, 0, 0, 30)
	TextLabel.Text = "🔷 Script Of J"
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.Font = Enum.Font.GothamBlack
	TextLabel.TextSize = 28
	TextLabel.BackgroundTransparency = 1
	TextLabel.Parent = Frame2

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, 0, 0, 30)
	TextLabel2.Position = UDim2.new(0, 0, 0, 90)
	TextLabel2.Text = "Script Of J Key System"
	TextLabel2.TextColor3 = Color3.fromRGB(100, 150, 255)
	TextLabel2.Font = Enum.Font.Gotham
	TextLabel2.TextSize = 18
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Parent = Frame2

	local TextBox = Instance.new("TextBox")

	TextBox.Size = UDim2.new(1, -60, 0, 50)
	TextBox.Position = UDim2.new(0, 30, 0, 140)
	TextBox.PlaceholderText = "Enter your key..."
	TextBox.Text = ""
	TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	TextBox.Font = Enum.Font.Gotham
	TextBox.TextSize = 16
	TextBox.Parent = Frame2

	local UICorner2 = Instance.new("UICorner")

	UICorner2.CornerRadius = UDim.new(0, 8)
	UICorner2.Parent = TextBox

	local TextButton = Instance.new("TextButton")

	TextButton.Size = UDim2.new(1, -60, 0, 50)
	TextButton.Position = UDim2.new(0, 30, 0, 200)
	TextButton.Text = "✓ Activate"
	TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton.BackgroundColor3 = Color3.fromRGB(30, 60, 150)
	TextButton.Font = Enum.Font.GothamBold
	TextButton.TextSize = 18
	TextButton.Parent = Frame2

	local UICorner3 = Instance.new("UICorner")

	UICorner3.CornerRadius = UDim.new(0, 8)
	UICorner3.Parent = TextButton
	TextButton.MouseEnter:Connect(function()
		TextButton.BackgroundColor3 = Color3.fromRGB(40, 80, 180)
	end)
	TextButton.MouseLeave:Connect(function()
		TextButton.BackgroundColor3 = Color3.fromRGB(30, 60, 150)
	end)

	local TextButton2 = Instance.new("TextButton")

	TextButton2.Size = UDim2.new(1, -60, 0, 50)
	TextButton2.Position = UDim2.new(0, 30, 0, 260)
	TextButton2.Text = "📱 Join the Discord for the Key"
	TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton2.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
	TextButton2.Font = Enum.Font.GothamBold
	TextButton2.TextSize = 16
	TextButton2.Parent = Frame2
	TextButton2.AutoButtonColor = false

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(0, 8)
	UICorner4.Parent = TextButton2
	TextButton2.MouseEnter:Connect(function()
		TextButton2.BackgroundColor3 = Color3.fromRGB(98, 111, 252)
	end)
	TextButton2.MouseLeave:Connect(function()
		TextButton2.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
	end)

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Size = UDim2.new(1, -60, 0, 40)
	TextLabel3.Position = UDim2.new(0, 30, 0, 320)
	TextLabel3.Text = ""
	TextLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel3.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	TextLabel3.Font = Enum.Font.Gotham
	TextLabel3.TextSize = 14
	TextLabel3.Visible = false
	TextLabel3.Parent = Frame2
	TextLabel3.TextWrapped = true

	local UICorner5 = Instance.new("UICorner")

	UICorner5.CornerRadius = UDim.new(0, 5)
	UICorner5.Parent = TextLabel3
	TextButton2.MouseButton1Click:Connect(function()
		local DiscordInvite = t2.DiscordInvite

		if setclipboard then
			setclipboard(DiscordInvite)
			StatusLabel.Text = "Discord link copied to clipboard!"
			StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
		else
			StatusLabel.Text = "Join: discord.gg/" .. t2.DiscordInviteCode
			StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
		end

		TextLabel3.Text = DiscordInvite
		TextLabel3.Visible = true
		TextLabel3.TextColor3 = Color3.fromRGB(100, 255, 100)
		TextButton2.Text = "✓ Link Copied!"
		TextButton2.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
		wait(2)
		TextButton2.Text = "📱 Join the Discord for the Key"
		TextButton2.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
	end)

	local TextLabel4 = Instance.new("TextLabel")

	TextLabel4.Size = UDim2.new(1, 0, 0, 30)
	TextLabel4.Position = UDim2.new(0, 0, 0, 370)
	TextLabel4.Text = ""
	TextLabel4.TextColor3 = Color3.fromRGB(255, 100, 100)
	TextLabel4.Font = Enum.Font.Gotham
	TextLabel4.TextSize = 14
	TextLabel4.BackgroundTransparency = 1
	TextLabel4.Parent = Frame2

	local TextLabel5 = Instance.new("TextLabel")

	TextLabel5.Size = UDim2.new(1, 0, 0, 20)
	TextLabel5.Position = UDim2.new(0, 0, 0, 420)
	TextLabel5.Text = "v1.0 | Script Of J"
	TextLabel5.TextColor3 = Color3.fromRGB(100, 100, 100)
	TextLabel5.Font = Enum.Font.Gotham
	TextLabel5.TextSize = 12
	TextLabel5.BackgroundTransparency = 1
	TextLabel5.Parent = Frame2

	local function v26(p2)
		if p2 == "" then
			TextLabel4.Text = "Please enter a key!"
			TextLabel4.TextColor3 = Color3.fromRGB(255, 150, 50)
		else
			local v27, v28, v29 = v4(p2)

			if v27 then
				TextLabel4.Text = "✓ " .. v28 .. " - Access Granted"
				TextLabel4.TextColor3 = Color3.fromRGB(100, 255, 100)
				TextButton.Text = "✓ Activated!"
				TextButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
				wait(0.5)
				ScreenGui:Destroy()
				LoadMainScript(v29)

				return
			else
				TextLabel4.Text = "✗ " .. v28
				TextLabel4.TextColor3 = Color3.fromRGB(255, 100, 100)
				TextButton.Text = "✗ Failed"
				TextButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
				wait(0.5)
				TextButton.Text = "✓ Activate"
				TextButton.BackgroundColor3 = Color3.fromRGB(30, 60, 150)

				return
			end
		end
	end

	TextButton.MouseButton1Click:Connect(function()
		v26(TextBox.Text)
	end)
	TextBox.FocusLost:Connect(function(enterPressed)
		if not enterPressed then
			return
		end

		v26(TextBox.Text)
	end)
end)()
