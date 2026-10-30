-- This file was generated at discord.gg/syncrypt

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function v4(p1, p2)
	local t1 = {}

	for i = 1, #p1 do
		local v7 = (p1[i] - p2[(i - 1) % #p2 + 1] + 256) % 256

		t1[i] = string.char(v7)
	end

	return table.concat(t1)
end
local function v8(p3, p4, p5)
	if type(p5) ~= "table" and true or #p5 < 3 then
		return ""
	else
		local t2 = {}

		for i = 1, #p3 do
			local v11 = (p3[i] - p4[(i - 1) % #p4 + 1] - p5[(i - 1) % #p5 + 1] + 512) % 256

			t2[i] = string.char(v11)
		end

		return table.concat(t2)
	end
end
local function v12(p6)
	if type(p6) == "string" then
		local v13, v14, v15 = string.match(p6, "%-([0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f])%-([0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f])%-([0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f])$")

		if v13 and (v14 and v15) then
			local v16 = tonumber(string.sub(v13, 1, 2), 16)
			local v17 = string.sub(v13, 3, 4)
			local v18 = tonumber(v17, 16)
			local v19 = tonumber(string.sub(v14, 1, 2), 16)
			local v20 = string.sub(v14, 3, 4)
			local v21 = tonumber(v20, 16)
			local v22 = string.sub(v15, 1, 2)
			local v23 = tonumber(v22, 16)
			local v24 = tonumber(string.sub(v15, 3, 4), 16)

			return (v16 and (v18 and (v19 and (v21 and (v23 and v24)))) and true or false) and { (v21 - v16 - v18 + 512) % 256, (v23 - v18 - v19 + 512) % 256, (v24 - v19 - v16 + 512) % 256 } or nil
		else
			return nil
		end
	else
		return nil
	end
end

if not (function()
	local ok, result = pcall(function()
		return game.PlaceId
	end)

	if not ok or (type(result) ~= "number" and true or result <= 0) then
		return false
	end

	local ok2, result2 = pcall(function()
		return game:GetService("Players").LocalPlayer
	end)

	if not ok2 or result2 == nil then
		return false
	end

	local ok3, result3 = pcall(function()
		return result2.Name
	end)

	if not ok3 or (type(result3) ~= "string" and true or #result3 == 0) then
		return false
	end

	local ok4, result4 = pcall(function()
		return result2.UserId
	end)

	if not ok4 or (type(result4) ~= "number" and true or result4 <= 0) then
		return false
	end

	local ok5, result5 = pcall(function()
		return result2.Character
	end)

	if not ok5 or result5 == nil then
		return false
	end

	local ok6, result6 = pcall(function()
		return result5:FindFirstChildOfClass("Humanoid")
	end)

	return ok6 and result6 ~= nil and true or false
end)() then
	return
end

local function v37()
	local LocalPlayer = game:GetService("Players").LocalPlayer
	local ScreenGui = Instance.new("ScreenGui")
	local random = math.random

	ScreenGui.Name = "Interface_" .. tostring(random(100000, 999999))
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	pcall(function()
		local syn_ = syn

		if syn_ then
			syn_ = syn.protect_gui
		end

		if syn_ then
			syn.protect_gui(ScreenGui)

			return
		end

		if not protectgui then
			return
		end

		protectgui(ScreenGui)
	end)

	if not pcall(function()
		if gethui then
			ScreenGui.Parent = gethui()
		else
			ScreenGui.Parent = game:GetService("CoreGui")
		end
	end) and LocalPlayer then
		if not LocalPlayer:FindFirstChild("PlayerGui") then
			LocalPlayer.WaitForChild(LocalPlayer, "PlayerGui", 10)
		end

		ScreenGui.Parent = LocalPlayer.PlayerGui
	end

	local Frame = Instance.new("Frame")

	Frame.Name = "Backdrop"
	Frame.Parent = ScreenGui
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	pcall(function()
		TweenService:Create(Frame, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0.5
		}):Play()
	end)

	local Frame2 = Instance.new("Frame")

	Frame2.Name = "Toasts"
	Frame2.Parent = ScreenGui
	Frame2.AnchorPoint = Vector2.new(1, 1)
	Frame2.Position = UDim2.new(1, -20, 1, -20)
	Frame2.Size = UDim2.new(0, 270, 1, -40)
	Frame2.BackgroundTransparency = 1

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.Parent = Frame2
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout.Padding = UDim.new(0, 8)

	local function v45(p7, p8, p9)
		local v46 = p9 or 3
		local Frame3 = Instance.new("Frame")

		Frame3.Parent = Frame2
		Frame3.Size = UDim2.new(1, 0, 0, 56)
		Frame3.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
		Frame3.BackgroundTransparency = 0.04
		Frame3.BorderSizePixel = 0
		Frame3.ClipsDescendants = true

		local UICorner = Instance.new("UICorner")

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = Frame3
		pcall(function()
			local UIStroke = Instance.new("UIStroke")

			UIStroke.Color = Color3.fromRGB(45, 45, 50)
			UIStroke.Thickness = 1
			UIStroke.Parent = Frame3
		end)

		local TextLabel = Instance.new("TextLabel")

		TextLabel.Parent = Frame3
		TextLabel.Position = UDim2.new(0, 14, 0, 9)
		TextLabel.Size = UDim2.new(1, -28, 0, 16)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = p7
		TextLabel.TextColor3 = Color3.fromRGB(250, 250, 250)
		TextLabel.TextSize = 12
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left

		local TextLabel2 = Instance.new("TextLabel")

		TextLabel2.Parent = Frame3
		TextLabel2.Position = UDim2.new(0, 14, 0, 27)
		TextLabel2.Size = UDim2.new(1, -28, 0, 18)
		TextLabel2.BackgroundTransparency = 1
		TextLabel2.Text = p8
		TextLabel2.TextColor3 = Color3.fromRGB(161, 161, 170)
		TextLabel2.TextSize = 11
		TextLabel2.Font = Enum.Font.Gotham
		TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel2.TextTruncate = Enum.TextTruncate.AtEnd

		local Frame4 = Instance.new("Frame")

		Frame4.Parent = Frame3
		Frame4.Position = UDim2.new(0, 0, 1, -2)
		Frame4.Size = UDim2.new(1, 0, 0, 2)
		Frame4.BackgroundColor3 = Color3.fromRGB(228, 228, 231)
		Frame4.BorderSizePixel = 0

		local function v53()
			local Parent = Frame3

			if Parent then
				Parent = Frame3.Parent
			end

			if not Parent then
				return
			end

			local function v55()
				local tween = TweenService:Create(Frame3, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0)
				})

				tween:Play()

				local function v57()
					Frame3:Destroy()
				end

				tween.Completed:Connect(v57)
			end

			pcall(v55)
		end

		pcall(function()
			TweenService:Create(Frame4, TweenInfo.new(v46, Enum.EasingStyle.Linear), {
				Size = UDim2.new(0, 0, 0, 2)
			}):Play()
		end)
		task.delay(v46, v53)
	end

	local Frame3 = Instance.new("Frame")

	Frame3.Name = "Modal"
	Frame3.Parent = ScreenGui
	Frame3.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame3.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame3.Size = UDim2.new(0, 380, 0, 186)
	Frame3.BackgroundColor3 = Color3.fromRGB(11, 11, 13)
	Frame3.BackgroundTransparency = 0.03
	Frame3.BorderSizePixel = 0
	Frame3.Active = true
	Frame3.ClipsDescendants = true

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, 14)
	UICorner.Parent = Frame3
	pcall(function()
		local UIStroke = Instance.new("UIStroke")

		UIStroke.Color = Color3.fromRGB(38, 38, 44)
		UIStroke.Thickness = 1
		UIStroke.Parent = Frame3
	end)

	local u61 = nil
	local u62 = nil
	local Position = nil
	local Position2 = nil

	Frame3.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u61 = true
		Position = input.Position
		Position2 = Frame3.Position
		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			u61 = false
		end)
	end)
	Frame3.InputChanged:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u62 = input
	end)
	UserInputService.InputChanged:Connect(function(input)
		local v65

		if input == u62 then
			v65 = u61
		else
			v65 = false
		end

		if not v65 then
			return
		end

		local v66 = input.Position - Position

		Frame3.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v66.X, Position2.Y.Scale, Position2.Y.Offset + v66.Y)
	end)

	local Frame4 = Instance.new("Frame")

	Frame4.Parent = Frame3
	Frame4.Position = UDim2.new(0, 20, 0, 16)
	Frame4.Size = UDim2.new(1, -36, 0, 24)
	Frame4.BackgroundTransparency = 1

	local Frame5 = Instance.new("Frame")

	Frame5.Parent = Frame4
	Frame5.AnchorPoint = Vector2.new(0, 0.5)
	Frame5.Position = UDim2.new(0, 0, 0.5, 0)
	Frame5.Size = UDim2.new(0, 6, 0, 6)
	Frame5.BackgroundColor3 = Color3.fromRGB(228, 228, 231)
	Frame5.BorderSizePixel = 0

	local UICorner2 = Instance.new("UICorner")

	UICorner2.CornerRadius = UDim.new(1, 0)
	UICorner2.Parent = Frame5

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Parent = Frame4
	TextLabel.Position = UDim2.new(0, 14, 0, 0)
	TextLabel.Size = UDim2.new(1, -46, 1, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "Enter key to continue"
	TextLabel.TextColor3 = Color3.fromRGB(161, 161, 170)
	TextLabel.TextSize = 12
	TextLabel.Font = Enum.Font.GothamMedium
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.TextTruncate = Enum.TextTruncate.AtEnd

	local TextButton = Instance.new("TextButton")

	TextButton.Parent = Frame4
	TextButton.AnchorPoint = Vector2.new(1, 0.5)
	TextButton.Position = UDim2.new(1, 0, 0.5, 0)
	TextButton.Size = UDim2.new(0, 24, 0, 24)
	TextButton.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
	TextButton.BorderSizePixel = 0
	TextButton.Text = "X"
	TextButton.TextColor3 = Color3.fromRGB(140, 140, 150)
	TextButton.TextSize = 11
	TextButton.Font = Enum.Font.GothamBold
	TextButton.AutoButtonColor = false

	local UICorner3 = Instance.new("UICorner")

	UICorner3.CornerRadius = UDim.new(0, 7)
	UICorner3.Parent = TextButton

	local function v73()
		pcall(function()
			TweenService:Create(Frame, TweenInfo.new(0.18), {
				BackgroundTransparency = 1
			}):Play()

			local tween = TweenService:Create(Frame3, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 340, 0, 160),
				BackgroundTransparency = 1
			})

			local function v75()
				ScreenGui:Destroy()
			end

			tween:Play()
			tween.Completed:Connect(v75)
		end)
	end

	TextButton.MouseButton1Click:Connect(v73)
	TextButton.MouseEnter:Connect(function()
		pcall(function()
			local v76 = TweenService
			local v77 = TextButton
			local tweenInfo = TweenInfo.new(0.12)
			local t3 = {
				BackgroundColor3 = Color3.fromRGB(38, 38, 44),
				TextColor3 = Color3.fromRGB(250, 250, 250)
			}

			v76.Create(v76, v77, tweenInfo, t3):Play()
		end)
	end)
	TextButton.MouseLeave:Connect(function()
		local function v80()
			local v81 = TweenService
			local v82 = TextButton
			local TweenInfo_ = TweenInfo

			v81.Create(v81, v82, TweenInfo_.new(0.12), {
				BackgroundColor3 = Color3.fromRGB(22, 22, 26),
				TextColor3 = Color3.fromRGB(140, 140, 150)
			}):Play()
		end

		pcall(v80)
	end)

	local Frame6 = Instance.new("Frame")

	Frame6.Parent = Frame3
	Frame6.Position = UDim2.new(0, 20, 0, 54)
	Frame6.Size = UDim2.new(1, -40, 0, 46)
	Frame6.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
	Frame6.BorderSizePixel = 0

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(0, 10)
	UICorner4.Parent = Frame6

	local UIStroke = nil

	local function v87()
		UIStroke = Instance.new("UIStroke")
		UIStroke.Color = Color3.fromRGB(38, 38, 45)
		UIStroke.Thickness = 1
		UIStroke.Parent = Frame6
	end

	UIStroke = nil
	pcall(v87)

	local TextBox = Instance.new("TextBox")

	TextBox.Parent = Frame6
	TextBox.Position = UDim2.new(0, 14, 0, 0)
	TextBox.Size = UDim2.new(1, -78, 1, 0)
	TextBox.BackgroundTransparency = 1
	TextBox.Text = ""
	TextBox.PlaceholderText = "Paste key here..."
	TextBox.TextColor3 = Color3.fromRGB(250, 250, 250)
	TextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
	TextBox.TextSize = 13
	TextBox.Font = Enum.Font.GothamMedium
	TextBox.TextXAlignment = Enum.TextXAlignment.Left
	TextBox.ClearTextOnFocus = false
	TextBox.ClipsDescendants = true

	local TextButton2 = Instance.new("TextButton")

	TextButton2.Parent = Frame6
	TextButton2.AnchorPoint = Vector2.new(1, 0.5)
	TextButton2.Position = UDim2.new(1, -8, 0.5, 0)
	TextButton2.Size = UDim2.new(0, 52, 0, 28)
	TextButton2.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
	TextButton2.BorderSizePixel = 0
	TextButton2.Text = "Clear"
	TextButton2.TextColor3 = Color3.fromRGB(161, 161, 170)
	TextButton2.TextSize = 11
	TextButton2.Font = Enum.Font.GothamBold
	TextButton2.AutoButtonColor = false

	local UICorner5 = Instance.new("UICorner")

	UICorner5.CornerRadius = UDim.new(0, 7)
	UICorner5.Parent = TextButton2
	TextButton2.MouseButton1Click:Connect(function()
		TextBox.Text = ""
		pcall(function()
			local delfile_ = delfile

			if delfile_ then
				delfile_ = isfile

				if delfile_ then
					delfile_ = isfile("key_session_cache.txt")
				end
			end

			if not delfile_ then
				return
			end

			delfile("key_session_cache.txt")
		end)
		TextLabel.Text = "Input cleared"
		TextLabel.TextColor3 = Color3.fromRGB(161, 161, 170)
	end)
	TextBox.Focused:Connect(function()
		local function v92()
			if not UIStroke then
				v103 = TweenService
				v104 = Frame6
				v105 = TweenInfo.new(0.15)
				v106 = Color3.fromRGB
				v103.Create(v103, v104, v105, {
					BackgroundColor3 = v106(22, 22, 27)
				}):Play()

				return
			end

			TweenService:Create(UIStroke, TweenInfo.new(0.15), {
				Color = Color3.fromRGB(212, 212, 216),
				Thickness = 1.2
			}):Play()

			local v93 = TweenService
			local v94 = Frame6
			local tweenInfo = TweenInfo.new(0.15)
			local color3 = Color3.fromRGB

			v93.Create(v93, v94, tweenInfo, {
				BackgroundColor3 = color3(22, 22, 27)
			}):Play()
		end

		pcall(v92)
	end)
	TextBox.FocusLost:Connect(function()
		pcall(function()
			if not UIStroke then
				v112 = TweenService
				v113 = Frame6
				v114 = TweenInfo.new(0.15)
				v115 = Color3
				v112.Create(v112, v113, v114, {
					BackgroundColor3 = v115.fromRGB(18, 18, 22)
				}):Play()

				return
			end

			local v97 = TweenService
			local v98 = UIStroke
			local tweenInfo = TweenInfo.new(0.15)
			local color3 = Color3.fromRGB

			v97.Create(v97, v98, tweenInfo, {
				Color = color3(38, 38, 45),
				Thickness = 1
			}):Play()

			local v101 = TweenService
			local v102 = Frame6
			local tweenInfo2 = TweenInfo.new(0.15)
			local Color3_ = Color3

			v101.Create(v101, v102, tweenInfo2, {
				BackgroundColor3 = Color3_.fromRGB(18, 18, 22)
			}):Play()
		end)
	end)

	local Frame7 = Instance.new("Frame")

	Frame7.Parent = Frame3
	Frame7.Position = UDim2.new(0, 20, 0, 118)
	Frame7.Size = UDim2.new(1, -40, 0, 44)
	Frame7.BackgroundTransparency = 1

	local TextButton3 = Instance.new("TextButton")

	TextButton3.Parent = Frame7
	TextButton3.Position = UDim2.new(0, 0, 0, 0)
	TextButton3.Size = UDim2.new(0.47, 0, 1, 0)
	TextButton3.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
	TextButton3.BorderSizePixel = 0
	TextButton3.Text = "Get Key"
	TextButton3.TextColor3 = Color3.fromRGB(228, 228, 231)
	TextButton3.TextSize = 13
	TextButton3.Font = Enum.Font.GothamBold
	TextButton3.AutoButtonColor = false

	local UICorner6 = Instance.new("UICorner")

	UICorner6.CornerRadius = UDim.new(0, 10)
	UICorner6.Parent = TextButton3
	pcall(function()
		local UIStroke2 = Instance.new("UIStroke")

		UIStroke2.Color = Color3.fromRGB(42, 42, 48)
		UIStroke2.Thickness = 1
		UIStroke2.Parent = TextButton3
	end)
	TextButton3.MouseEnter:Connect(function()
		pcall(function()
			local v109 = TweenService
			local v110 = TextButton3
			local tweenInfo = TweenInfo.new(0.14)
			local Color3_ = Color3

			v109.Create(v109, v110, tweenInfo, {
				BackgroundColor3 = Color3_.fromRGB(30, 30, 36)
			}):Play()
		end)
	end)
	TextButton3.MouseLeave:Connect(function()
		local function v116()
			TweenService:Create(TextButton3, TweenInfo.new(0.14), {
				BackgroundColor3 = Color3.fromRGB(20, 20, 24)
			}):Play()
		end

		pcall(v116)
	end)

	local TextButton4 = Instance.new("TextButton")

	TextButton4.Parent = Frame7
	TextButton4.AnchorPoint = Vector2.new(1, 0)
	TextButton4.Position = UDim2.new(1, 0, 0, 0)
	TextButton4.Size = UDim2.new(0.5, 0, 1, 0)
	TextButton4.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
	TextButton4.BorderSizePixel = 0
	TextButton4.Text = "Continue"
	TextButton4.TextColor3 = Color3.fromRGB(10, 10, 12)
	TextButton4.TextSize = 13
	TextButton4.Font = Enum.Font.GothamBold
	TextButton4.AutoButtonColor = false

	local UICorner7 = Instance.new("UICorner")

	UICorner7.CornerRadius = UDim.new(0, 10)
	UICorner7.Parent = TextButton4
	TextButton4.MouseEnter:Connect(function()
		if not TextButton4.Active then
			return
		end

		local function v117()
			local v118 = TweenService
			local v119 = TextButton4
			local tweenInfo = TweenInfo.new(0.14)
			local t4 = {
				BackgroundColor3 = Color3.fromRGB(212, 212, 216)
			}

			v118.Create(v118, v119, tweenInfo, t4):Play()
		end

		pcall(v117)
	end)
	TextButton4.MouseLeave:Connect(function()
		if not TextButton4.Active then
			return
		end

		local function v121()
			TweenService:Create(TextButton4, TweenInfo.new(0.14), {
				BackgroundColor3 = Color3.fromRGB(250, 250, 250)
			}):Play()
		end

		pcall(v121)
	end)

	local function v122()
		Frame3.Size = UDim2.new(0, 345, 0, 168)
		TweenService:Create(Frame3, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 380, 0, 186)
		}):Play()
	end

	pcall(v122)

	return {
		ScreenGui = ScreenGui,
		MainFrame = Frame3,
		KeyInput = TextBox,
		SubmitBtn = TextButton4,
		GetKeyBtn = TextButton3,
		StatusLabel = TextLabel,
		StatusDot = Frame5,
		notify = v45,
		closeWindow = v73
	}
end
local function v123(p10, p11, p12)
	if not (p10 and (p10.StatusLabel and p10.StatusLabel.Parent)) then
		return
	end

	pcall(function()
		p10.StatusLabel.Text = p11

		if not p12 then
			return
		end

		p10.StatusLabel.TextColor3 = p12

		if not p10.StatusDot then
			return
		end

		p10.StatusDot.BackgroundColor3 = p12
	end)
end
local function v124(p13, p14)
	v123(p14, "Verifying key...", Color3.fromRGB(212, 212, 216))

	local v125 = string.gsub(p13, "%s+", "")
	local v126 = string.gsub(v125, "\'", "")
	local v127 = string.gsub(v126, "\"", "")
	local v128 = v12(v127)

	if not v128 then
		return false, "invalid"
	end

	local v129 = v8({
		126,
		211,
		207,
		71,
		228,
		158,
		117,
		187,
		67,
		3,
		66,
		214,
		63,
		112,
		70,
		128,
		84,
		47,
		178,
		15,
		66,
		167,
		120,
		23,
		17,
		212,
		154,
		122,
		245,
		201,
		34,
		15,
		174,
		251,
		106,
		98,
		16,
		104,
		220,
		44,
		160,
		45,
		112,
		137,
		48,
		173,
		227,
		175,
		127,
		197,
		212,
		20,
		162,
		138,
		177,
		241,
		73,
		221
	}, {
		156,
		32,
		191,
		93,
		50,
		200,
		204,
		77,
		52,
		38,
		145,
		209,
		85,
		189,
		63,
		161
	}, v128)

	if string.sub(v129, 1, 8) ~= "https://" then
		return false, "invalid"
	end

	local v130 = v8({
		101,
		95,
		148,
		151,
		134,
		79,
		202,
		209,
		45,
		242,
		200,
		35,
		156,
		50,
		109,
		8,
		49,
		124,
		112,
		30,
		176,
		234,
		79,
		82,
		219,
		230,
		27,
		211,
		97,
		143,
		71,
		194,
		151,
		138,
		11,
		173,
		140,
		184,
		175,
		2,
		156,
		21,
		49,
		198,
		131,
		155,
		74,
		87,
		160,
		96,
		160,
		151,
		90,
		77,
		197,
		9,
		52,
		28,
		255,
		227,
		175,
		58
	}, {
		197,
		173,
		149,
		171,
		222,
		67,
		220,
		85,
		43,
		65,
		82,
		33,
		193,
		190,
		153,
		86
	}, v128)
	local tick_ = tick
	local v132 = tostring(tick_())
	local v133 = v129 .. HttpService:UrlEncode(v127) .. v130 .. v132
	local ok, result = pcall(function()
		return game:HttpGet(v133, true)
	end)

	if ok then
		local v136 = string.gsub(result, "^%s*(.-)%s*$", "%1")
		local v137 = string.gsub(v136, "\r", "")
		local v138 = string.gsub(v137, "\n", "")
		local v139 = string.lower(v138)

		if v139 == "valid" then
			return true, "valid"
		elseif v139 == "expired" then
			return false, "expired"
		elseif v139 == "invalid" then
			return false, "invalid"
		else
			return false, "error"
		end
	else
		return false, "connection_error"
	end
end
local function v140(p15)
	pcall(function()
		local v141 = v12(p15)

		if not v141 then
			return
		end

		local v142 = v8({
			129,
			55,
			181,
			12,
			217,
			147,
			64,
			25,
			202,
			32,
			49,
			222,
			163,
			211,
			47,
			58,
			87,
			147,
			152,
			212,
			55,
			156,
			67,
			117,
			152,
			241,
			137,
			130,
			89,
			44,
			11,
			201,
			177,
			95,
			80,
			39,
			5,
			93,
			167,
			138,
			39,
			74,
			95,
			145,
			148,
			13,
			202,
			105,
			130,
			51,
			181,
			217,
			204,
			144,
			72,
			80,
			184,
			242,
			247,
			173,
			96,
			146,
			37,
			9,
			20,
			77,
			83,
			194,
			249,
			157,
			3,
			127,
			150,
			183,
			80,
			128,
			46,
			31,
			217,
			0,
			111,
			52,
			27,
			241,
			211,
			52,
			152,
			139,
			32,
			66,
			108,
			125,
			182,
			14,
			214,
			105,
			86,
			49,
			176,
			17,
			211,
			186,
			127
		}, {
			159,
			132,
			165,
			34,
			39,
			189,
			151,
			171,
			187,
			67,
			128,
			217,
			185,
			32,
			40,
			91
		}, v141)

		if string.sub(v142, 1, 8) ~= "https://" then
			return
		end

		local v143 = p15

		if not v143 then
			if v143 then
				v142 = v142 .. "&key=" .. HttpService:UrlEncode(p15)
			else
				if not p15 then
					v161 = v142 .. (string.find(v142, "?") and "&" or "?") .. "t=" .. tostring(tick())
					loadstring(game:HttpGet(v161, true))()

					return
				end

				v142 = v142 .. "?key=" .. HttpService:UrlEncode(p15)
			end

			v161 = v142 .. (string.find(v142, "?") and "&" or "?") .. "t=" .. tostring(tick())
			loadstring(game:HttpGet(v161, true))()

			return
		end

		v143 = string.find(v142, "?")

		if v143 then
			v142 = v142 .. "&key=" .. HttpService:UrlEncode(p15)
		else
			if not p15 then
				v161 = v142 .. (string.find(v142, "?") and "&" or "?") .. "t=" .. tostring(tick())
				loadstring(game:HttpGet(v161, true))()

				return
			end

			v142 = v142 .. "?key=" .. HttpService:UrlEncode(p15)
		end

		local v144 = v142 .. (string.find(v142, "?") and "&" or "?") .. "t=" .. tostring(tick())

		loadstring(game:HttpGet(v144, true))()
	end)
end

(function()
	local v145 = v37()
	local u146 = nil
	local now = tick()

	local function v148()
		v145.KeyInput.Focused:Connect(function()
			u146 = true
		end)
		v145.KeyInput.FocusLost:Connect(function()
			u146 = true
		end)
	end

	u146 = false
	pcall(v148)

	local function v149(p16, p17)
		local v150 = string.gsub(p16 or "", "%s+", "")

		if v150 == "" then
			v123(v145, "Please enter a key first", Color3.fromRGB(244, 244, 245))
			v145.notify("Key Required", "Paste your key into the field to continue.", 2.5)

			return
		end

		v145.SubmitBtn.Text = "Checking..."
		v145.SubmitBtn.Active = false
		task.spawn(function()
			local t5 = { v124(v150, v145) }
			local v152 = t5[2]

			if t5[1] then
				pcall(function()
					local delfile_ = delfile

					if delfile_ then
						delfile_ = isfile

						if delfile_ then
							delfile_ = isfile("key_session_cache.txt")
						end
					end

					if not delfile_ then
						return
					end

					delfile("key_session_cache.txt")
				end)
				v123(v145, "Verified - loading...", Color3.fromRGB(250, 250, 250))
				v145.SubmitBtn.Text = "Verified"
				v145.notify("Verified", "Loading script...", 2)
				task.wait(0.6)
				v145.closeWindow()
				v140(v150)

				return
			end

			v145.SubmitBtn.Text = "Continue"
			v145.SubmitBtn.Active = true

			if not p17 then
				if v152 == "expired" then
					v123(v145, "Key already used or expired - click Get Key", Color3.fromRGB(161, 161, 170))
					v145.notify("Key Expired / Used", "Each key is one-time use. Click Get Key for a new key.", 3.5)
				elseif v152 == "invalid" then
					v123(v145, "Invalid key entered", Color3.fromRGB(161, 161, 170))
					v145.notify("Invalid Key", "The key entered is not valid.", 3)

					return
				else
					v123(v145, "Connection error - try again", Color3.fromRGB(161, 161, 170))
					v145.notify("Error", "Could not connect to verification server.", 3)

					return
				end

				return
			end

			pcall(function()
				local delfile_ = delfile

				if delfile_ then
					delfile_ = isfile

					if delfile_ then
						delfile_ = isfile("key_session_cache.txt")
					end
				end

				if not delfile_ then
					return
				end

				delfile("key_session_cache.txt")
			end)

			if v152 == "expired" then
				v123(v145, "Key already used or expired - click Get Key", Color3.fromRGB(161, 161, 170))
				v145.notify("Key Expired / Used", "Each key is one-time use. Click Get Key for a new key.", 3.5)
			elseif v152 == "invalid" then
				v123(v145, "Invalid key entered", Color3.fromRGB(161, 161, 170))
				v145.notify("Invalid Key", "The key entered is not valid.", 3)

				return
			else
				v123(v145, "Connection error - try again", Color3.fromRGB(161, 161, 170))
				v145.notify("Error", "Could not connect to verification server.", 3)

				return
			end
		end)
	end

	v145.GetKeyBtn.MouseButton1Click:Connect(function()
		local v155 = v4({
			2,
			211,
			170,
			166,
			48,
			26,
			252,
			105,
			222,
			196,
			234,
			153,
			159,
			206,
			154,
			73,
			5,
			141,
			153,
			165,
			42,
			15,
			64,
			121,
			183,
			173,
			193,
			90,
			235,
			147,
			132,
			37
		}, {
			154,
			95,
			54,
			54,
			189,
			224,
			205,
			58,
			114,
			85,
			123,
			37,
			114,
			98,
			49,
			219
		})
		local setclipboard_ = setclipboard

		if not setclipboard_ then
			setclipboard_ = toclipboard

			if not setclipboard_ then
				setclipboard_ = Clipboard

				if setclipboard_ then
					setclipboard_ = Clipboard.set
				end
			end
		end

		if setclipboard_ then
			pcall(function()
				setclipboard_(v155)
			end)
			v123(v145, "Key link copied to clipboard", Color3.fromRGB(250, 250, 250))
			v145.notify("Copied", "Key link copied to your clipboard.", 3)
		else
			v123(v145, "Clipboard not supported", Color3.fromRGB(161, 161, 170))
			v145.notify("Notice", "Clipboard is not supported by your executor.", 3)
		end
	end)
	v145.SubmitBtn.MouseButton1Click:Connect(function()
		local v157 = not u146

		if not v157 then
			if not v157 then
				v149(v145.KeyInput.Text, false)
			end

			return
		end

		v157 = tick() - now < 0.35

		if not v157 then
			v149(v145.KeyInput.Text, false)
		end
	end)
	pcall(function()
		local delfile_ = delfile

		if delfile_ then
			delfile_ = isfile

			if delfile_ then
				delfile_ = isfile("key_session_cache.txt")
			end
		end

		if not delfile_ then
			return
		end

		delfile("key_session_cache.txt")
	end)
end)()
