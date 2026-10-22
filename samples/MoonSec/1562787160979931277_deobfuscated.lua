local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

Players = Players.LocalPlayer:WaitForChild("PlayerGui")

local s1 = "Hendar"
local text = "https://discord.gg/8pFr4nhzV"
local s2 = "https://pastefy.app/UzUU8gbI/raw"
local KeyInputGui = Players:FindFirstChild("KeyInputGui")

if KeyInputGui then
	KeyInputGui:Destroy()
end

KeyInputGui = Instance.new("ScreenGui")
KeyInputGui.Name = "KeyInputGui"
KeyInputGui.ResetOnSpawn = false
KeyInputGui.Parent = Players
KeyInputGui.IgnoreGuiInset = true

local Frame = Instance.new("Frame")

Frame.Name = "Main"
Frame.Size = UDim2.new(0, 440, 0, 170)
Frame.Position = UDim2.new(0.5, -220, 0.5, -85)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
Frame.BorderSizePixel = 0
Frame.Parent = KeyInputGui
Frame.ClipsDescendants = true
Frame.Active = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
Players = Instance.new("Frame")
Players.Name = "Header"
Players.Size = UDim2.new(1, 0, 0, 36)
Players.Position = UDim2.new(0, 0, 0, 0)
Players.BackgroundTransparency = 1
Players.Parent = Frame
KeyInputGui = Instance.new("TextLabel")
KeyInputGui.Name = "Title"
KeyInputGui.Size = UDim2.new(1, -16, 1, 0)
KeyInputGui.Position = UDim2.new(0, 8, 0, 0)
KeyInputGui.BackgroundTransparency = 1
KeyInputGui.Text = "Masukkan Key"
KeyInputGui.Font = Enum.Font.GothamBold
KeyInputGui.TextSize = 18
KeyInputGui.TextColor3 = Color3.fromRGB(230, 230, 230)
KeyInputGui.TextXAlignment = Enum.TextXAlignment.Left
KeyInputGui.Parent = Players
KeyInputGui = Instance.new("TextButton")
KeyInputGui.Name = "Close"
KeyInputGui.Size = UDim2.new(0, 28, 0, 28)
KeyInputGui.Position = UDim2.new(1, -36, 0, 4)
KeyInputGui.BackgroundTransparency = 0
KeyInputGui.Text = "X"
KeyInputGui.Font = Enum.Font.GothamBold
KeyInputGui.TextSize = 14
KeyInputGui.TextColor3 = Color3.fromRGB(200, 200, 200)
KeyInputGui.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
KeyInputGui.Parent = Players
Instance.new("UICorner", KeyInputGui).CornerRadius = UDim.new(0, 6)
KeyInputGui.MouseButton1Click:Connect(function()
	Frame.Visible = false
end)
Players = Instance.new("TextLabel")
Players.Name = "Subtitle"
Players.Size = UDim2.new(1, -20, 0, 20)
Players.Position = UDim2.new(0, 10, 0, 44)
Players.BackgroundTransparency = 1
Players.Text = "Tekan ENTER setelah mengetik key atau tekan Confirm."
Players.Font = Enum.Font.Gotham
Players.TextSize = 14
Players.TextColor3 = Color3.fromRGB(170, 170, 170)
Players.TextXAlignment = Enum.TextXAlignment.Left
Players.Parent = Frame

local TextBox = Instance.new("TextBox")

TextBox.Name = "KeyBox"
TextBox.Size = UDim2.new(1, -20, 0, 40)
TextBox.Position = UDim2.new(0, 10, 0, 70)
TextBox.PlaceholderText = "Masukkan key di sini..."
TextBox.Text = ""
TextBox.Font = Enum.Font.Gotham
TextBox.TextSize = 18
TextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
TextBox.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
TextBox.ClearTextOnFocus = false
TextBox.Parent = Frame
Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)
Players = Instance.new("Frame")
Players.Name = "Buttons"
Players.Size = UDim2.new(1, -20, 0, 42)
Players.Position = UDim2.new(0, 10, 0, 118)
Players.BackgroundTransparency = 1
Players.Parent = Frame
KeyInputGui = Instance.new("TextButton")
KeyInputGui.Name = "Confirm"
KeyInputGui.Size = UDim2.new(0.5, -6, 1, 0)
KeyInputGui.Position = UDim2.new(0, 0, 0, 0)
KeyInputGui.Text = "Confirm"
KeyInputGui.Font = Enum.Font.GothamBold
KeyInputGui.TextSize = 16
KeyInputGui.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInputGui.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
KeyInputGui.Parent = Players
Instance.new("UICorner", KeyInputGui).CornerRadius = UDim.new(0, 6)

local TextButton = Instance.new("TextButton")

TextButton.Name = "CopyDiscord"
TextButton.Size = UDim2.new(0.5, -6, 1, 0)
TextButton.Position = UDim2.new(0.5, 12, 0, 0)
TextButton.Text = "Copy Discord"
TextButton.Font = Enum.Font.GothamBold
TextButton.TextSize = 14
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BackgroundColor3 = Color3.fromRGB(85, 85, 85)
TextButton.Parent = Players
Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 6)

local TextLabel = Instance.new("TextLabel")

TextLabel.Name = "Feedback"
TextLabel.Size = UDim2.new(1, -20, 0, 18)
TextLabel.Position = UDim2.new(0, 10, 1, -22)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = ""
TextLabel.Font = Enum.Font.Gotham
TextLabel.TextSize = 14
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
TextLabel.Parent = Frame

local function v11(p1, p2)
	TextLabel.Text = p1 or ""

	if p2 then
		TextLabel.TextColor3 = Color3.fromRGB(120, 255, 140)
	else
		TextLabel.TextColor3 = Color3.fromRGB(255, 130, 130)
	end

	spawn(function()
		wait(3)

		if not TextLabel then
			return
		end

		TextLabel.Text = ""
	end)
end
local function v12()
	if tostring(TextBox.Text or "") ~= s1 then
		v11("Key salah \226\128\148 coba lagi.", false)
	else
		v11("Key benar. Menjalankan payload...", true)

		local ok, result = pcall(function()
			local response = game:HttpGet(s2)

			response = loadstring(response)

			if type(response) ~= "function" then
				return
			end

			response()
		end)

		if ok then
			return
		end

		v11("Gagal menjalankan payload: " .. tostring(result), false)
	end
end

KeyInputGui.MouseButton1Click:Connect(v12)
TextBox.FocusLost:Connect(function(enterPressed)
	if not enterPressed then
		return
	end

	v12()
end)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if input.UserInputType ~= Enum.UserInputType.Keyboard or input.KeyCode ~= Enum.KeyCode.Return or not TextBox:IsFocused() then
		return
	end

	v12()
end)
TextButton.MouseButton1Click:Connect(function()
	local ok = pcall(function()
		if setclipboard then
			setclipboard(text)
		elseif syn and syn.set_clipboard then
			syn.set_clipboard(text)
		else
			error("clipboard not available")
		end
	end)

	if ok then
		v11("Link Discord disalin ke clipboard.", true)
	else
		v11("Gagal menyalin otomatis \226\128\148 salin manual: " .. text, false)
		TextBox.Text = text
	end
end)

local u18 = false
local vector2 = nil
local Position = nil
local connection = nil

Players = function(input)
	if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	local mouseLocation = UserInputService:GetMouseLocation()
	local AbsolutePosition = Frame.AbsolutePosition
	local AbsoluteSize = Frame.AbsoluteSize

	if mouseLocation.Y < AbsolutePosition.Y or (mouseLocation.Y > AbsolutePosition.Y + 36 or (mouseLocation.X < AbsolutePosition.X or mouseLocation.X > AbsolutePosition.X + AbsoluteSize.X)) then
		return
	end

	u18 = true
	vector2 = Vector2.new(input.Position.X, input.Position.Y)
	Position = Frame.Position
	connection = UserInputService.InputChanged:Connect(function(input2)
		if not u18 then
			return
		end

		if not (input2.UserInputType == Enum.UserInputType.MouseMovement or input2.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		local v25 = input2.Position - vector2
		local v26 = Position.X.Offset + v25.X

		v25 = Position.Y.Offset + v25.Y

		local ViewportSize = workspace.CurrentCamera.ViewportSize
		local Offset = Frame.Size.X.Offset
		local Offset2 = Frame.Size.Y.Offset

		v26 = math.clamp(v26, 0 - Offset * 0.5, ViewportSize.X - Offset * 0.5)
		v25 = math.clamp(v25, 0, ViewportSize.Y - Offset2)
		Frame.Position = UDim2.new(0, v26, 0, v25)
	end)
end
s1 = function(input)
	if not ((input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and u18) then
		return
	end

	u18 = false

	if not connection then
		return
	end

	connection:Disconnect()
	connection = nil
end
Frame.InputBegan:Connect(Players)
UserInputService.InputEnded:Connect(s1)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if input.KeyCode ~= Enum.KeyCode.Escape then
		return
	end

	Frame.Visible = not Frame.Visible
end)
