-- This file was generated at discord.gg/syncrypt

local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local u2 = false
local connection = nil
local u4 = true
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "AutoClickerGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")

Frame.Size = UDim2.new(0, 230, 0, 180)
Frame.Position = UDim2.new(0.5, -115, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

local TextLabel = Instance.new("TextLabel")

TextLabel.Size = UDim2.new(1, -40, 0, 30)
TextLabel.Position = UDim2.new(0, 10, 0, 5)
TextLabel.Text = "Auto jjs"
TextLabel.BackgroundTransparency = 1
TextLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 16
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = Frame

local TextButton = Instance.new("TextButton")

TextButton.Size = UDim2.new(0, 25, 0, 25)
TextButton.Position = UDim2.new(1, -30, 0, 5)
TextButton.Text = "👍"
TextButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.Font = Enum.Font.GothamBold
TextButton.TextSize = 16
TextButton.Parent = Frame
Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 8)

local TextBox = Instance.new("TextBox")

TextBox.Size = UDim2.new(0, 90, 0, 30)
TextBox.Position = UDim2.new(0, 20, 0, 50)
TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.Font = Enum.Font.Gotham
TextBox.TextSize = 14
TextBox.PlaceholderText = "Min: 0.1"
TextBox.Text = "0.2"
TextBox.Parent = Frame
Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)

local TextBox2 = Instance.new("TextBox")

TextBox2.Size = UDim2.new(0, 90, 0, 30)
TextBox2.Position = UDim2.new(1, -110, 0, 50)
TextBox2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TextBox2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox2.Font = Enum.Font.Gotham
TextBox2.TextSize = 14
TextBox2.PlaceholderText = "Max: 0.5"
TextBox2.Text = "0.6"
TextBox2.Parent = Frame
Instance.new("UICorner", TextBox2).CornerRadius = UDim.new(0, 6)

local TextButton2 = Instance.new("TextButton")

TextButton2.Size = UDim2.new(0, 160, 0, 40)
TextButton2.Position = UDim2.new(0.5, -80, 0, 100)
TextButton2.Text = "OFF"
TextButton2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TextButton2.TextColor3 = Color3.fromRGB(255, 80, 80)
TextButton2.Font = Enum.Font.GothamBold
TextButton2.TextSize = 16
TextButton2.Parent = Frame
Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 10)

local TextLabel2 = Instance.new("TextLabel")

TextLabel2.Size = UDim2.new(1, 0, 0, 20)
TextLabel2.Position = UDim2.new(0, 0, 1, -22)
TextLabel2.Text = "by CoiledTom"
TextLabel2.BackgroundTransparency = 1
TextLabel2.TextColor3 = Color3.fromRGB(120, 120, 120)
TextLabel2.Font = Enum.Font.Gotham
TextLabel2.TextSize = 12

local function v13(p1)
	if getconnections then
		pcall(function()
			local v14, v15, v16 = pairs(getconnections(p1.MouseButton1Click))

			while true do
				local v17

				v16, v17 = v14(v15, v16)

				if not v16 then
					break
				end

				v17:Function()
			end

			for _, v in pairs(getconnections(p1.MouseButton1Down)) do
				v:Function()
			end
		end)
	end

	pcall(function()
		p1:Activate()
	end)
end

TextLabel2.Parent = Frame

local function v20()
	local v21 = PlayerGui

	for _, descendant in ipairs(v21.GetDescendants(v21)) do
		if descendant.Name == "BlueOutline" then
			descendant:Destroy()
		end
	end
end

local v24 = nil

local function v25(p2)
	if p2:FindFirstChild("BlueOutline") then
		return
	end

	local Frame2 = Instance.new("Frame")

	Frame2.Name = "BlueOutline"
	Frame2.BackgroundTransparency = 1
	Frame2.Size = UDim2.new(1, 0, 1, 0)
	Frame2.ZIndex = p2.ZIndex + 1
	Frame2.Parent = p2

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = Color3.fromRGB(0, 170, 255)
	UIStroke.Thickness = 2
	UIStroke.Parent = Frame2
	task.spawn(function()
		task.wait(v24())

		while true do
			local Parent = u2

			if Parent then
				Parent = p2.Parent

				if Parent then
					Parent = p2:FindFirstChild("BlueOutline")
				end
			end

			if not Parent then
				return
			end

			if p2.Visible then
				v13(p2)
			end

			task.wait(v24())
		end
	end)
end

v24 = function()
	local Text = TextBox.Text
	local v30 = tonumber(Text) or 0.1
	local v31 = tonumber(TextBox2.Text) or 0.5

	if not (v31 < v30) then
		return math.random(v30 * 1000, v31 * 1000) / 1000
	end

	local v32 = v31

	v31 = v30
	v30 = v32

	return math.random(v30 * 1000, v31 * 1000) / 1000
end
TextButton2.MouseButton1Click:Connect(function()
	u2 = not u2

	if u2 then
		TextButton2.Text = "ON"
		TextButton2.TextColor3 = Color3.fromRGB(0, 255, 150)
		TextButton2.BackgroundColor3 = Color3.fromRGB(20, 60, 40)

		local v33 = nil
		local s1 = "Auto jjs ativo🟢"

		local function v35()
			local t1 = {
				Title = s1,
				Text = v33,
				Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150",
				Duration = 5
			}

			game:GetService("StarterGui"):SetCore("SendNotification", t1)
		end

		v33 = "criado pelo CoiledTom"
		pcall(v35)
		connection = PlayerGui.DescendantAdded:Connect(function(descendant)
			task.wait(0.1)

			local isTextButton = descendant:IsA("TextButton") or descendant:IsA("ImageButton")

			if isTextButton then
				isTextButton = descendant.Name == "InputTemplate"
			end

			if not isTextButton then
				return
			end

			v25(descendant)
		end)

		return
	end

	TextButton2.Text = "OFF"
	TextButton2.TextColor3 = Color3.fromRGB(255, 80, 80)
	TextButton2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

	local v38 = nil
	local s2 = "Auto jjs desativado🔴"

	local function v40()
		local t2 = {
			Title = s2,
			Text = v38,
			Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150",
			Duration = 5
		}

		game:GetService("StarterGui"):SetCore("SendNotification", t2)
	end

	v38 = "criado pelo CoiledTom se inscreve lá"
	pcall(v40)

	if not connection then
		v20()

		return
	end

	connection:Disconnect()
	v20()
end)
TextButton.MouseButton1Click:Connect(function()
	u4 = not u4

	if u4 then
		Frame.Size = UDim2.new(0, 230, 0, 180)
		TextButton2.Visible = true
		TextLabel2.Visible = true
		TextBox.Visible = true
		TextBox2.Visible = true
	else
		Frame.Size = UDim2.new(0, 230, 0, 35)
		TextButton2.Visible = false
		TextLabel2.Visible = false
		TextBox.Visible = false
		TextBox2.Visible = false
	end
end)
