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
			local v17 = tonumber(string.sub(v13, 3, 4), 16)
			local v18 = string.sub(v14, 1, 2)
			local v19 = tonumber(v18, 16)
			local v20 = string.sub(v14, 3, 4)
			local v21 = tonumber(v20, 16)
			local v22 = string.sub(v15, 1, 2)
			local v23 = tonumber(v22, 16)
			local v24 = tonumber(string.sub(v15, 3, 4), 16)

			return (v16 and (v17 and (v19 and (v21 and (v23 and v24)))) and true or false) and { (v21 - v16 - v17 + 512) % 256, (v23 - v17 - v19 + 512) % 256, (v24 - v19 - v16 + 512) % 256 } or nil
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

	local function v43()
		local v44 = TweenService
		local v45 = Frame
		local TweenInfo_ = TweenInfo

		v44.Create(v44, v45, TweenInfo_.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0.5
		}):Play()
	end

	pcall(v43)

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

	local function v49(p7, p8, p9)
		local v50 = p9 or 3
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

		local function v57()
			TweenService:Create(Frame4, TweenInfo.new(v50, Enum.EasingStyle.Linear), {
				Size = UDim2.new(0, 0, 0, 2)
			}):Play()
		end
		local function v58()
			local Parent = Frame3

			if Parent then
				Parent = Frame3.Parent
			end

			if not Parent then
				return
			end

			pcall(function()
				local tween = TweenService:Create(Frame3, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0)
				})

				local function v61()
					Frame3:Destroy()
				end

				tween.Play(tween)
				tween.Completed:Connect(v61)
			end)
		end

		pcall(v57)
		task.delay(v50, v58)
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

	local u65 = nil
	local u66 = nil
	local Position = nil
	local Position2 = nil

	Frame3.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u65 = true
		Position = input.Position
		Position2 = Frame3.Position
		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			u65 = false
		end)
	end)
	Frame3.InputChanged:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u66 = input
	end)
	UserInputService.InputChanged:Connect(function(input)
		local v69

		if input == u66 then
			v69 = u65
		else
			v69 = false
		end

		if not v69 then
			return
		end

		local v70 = input.Position - Position

		Frame3.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v70.X, Position2.Y.Scale, Position2.Y.Offset + v70.Y)
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

	local function v77()
		pcall(function()
			TweenService:Create(Frame, TweenInfo.new(0.18), {
				BackgroundTransparency = 1
			}):Play()

			local tween = TweenService:Create(Frame3, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 340, 0, 160),
				BackgroundTransparency = 1
			})

			local function v79()
				ScreenGui:Destroy()
			end

			tween.Play(tween)
			tween.Completed:Connect(v79)
		end)
	end

	TextButton.MouseButton1Click:Connect(v77)
	TextButton.MouseEnter:Connect(function()
		local function v80()
			TweenService:Create(TextButton, TweenInfo.new(0.12), {
				BackgroundColor3 = Color3.fromRGB(38, 38, 44),
				TextColor3 = Color3.fromRGB(250, 250, 250)
			}):Play()
		end

		pcall(v80)
	end)
	TextButton.MouseLeave:Connect(function()
		local function v81()
			TweenService:Create(TextButton, TweenInfo.new(0.12), {
				BackgroundColor3 = Color3.fromRGB(22, 22, 26),
				TextColor3 = Color3.fromRGB(140, 140, 150)
			}):Play()
		end

		pcall(v81)
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

	pcall(function()
		UIStroke = Instance.new("UIStroke")
		UIStroke.Color = Color3.fromRGB(38, 38, 45)
		UIStroke.Thickness = 1
		UIStroke.Parent = Frame6
	end)

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
		local function v89()
			if not UIStroke then
				v100 = TweenService
				v101 = Frame6
				v102 = TweenInfo.new(0.15)
				v103 = Color3
				v100.Create(v100, v101, v102, {
					BackgroundColor3 = v103.fromRGB(22, 22, 27)
				}):Play()

				return
			end

			TweenService:Create(UIStroke, TweenInfo.new(0.15), {
				Color = Color3.fromRGB(212, 212, 216),
				Thickness = 1.2
			}):Play()

			local v90 = TweenService
			local v91 = Frame6
			local tweenInfo = TweenInfo.new(0.15)
			local Color3_ = Color3

			v90.Create(v90, v91, tweenInfo, {
				BackgroundColor3 = Color3_.fromRGB(22, 22, 27)
			}):Play()
		end

		pcall(v89)
	end)
	TextBox.FocusLost:Connect(function()
		local function v94()
			if not UIStroke then
				v109 = TweenService
				v110 = Frame6
				v111 = TweenInfo.new
				v109.Create(v109, v110, v111(0.15), {
					BackgroundColor3 = Color3.fromRGB(18, 18, 22)
				}):Play()

				return
			end

			local v95 = TweenService
			local v96 = UIStroke
			local tweenInfo = TweenInfo.new(0.15)
			local Color3_ = Color3

			v95.Create(v95, v96, tweenInfo, {
				Color = Color3_.fromRGB(38, 38, 45),
				Thickness = 1
			}):Play()

			local v99 = TweenService
			local v104 = Frame6
			local tweenInfoNew = TweenInfo.new

			v99.Create(v99, v104, tweenInfoNew(0.15), {
				BackgroundColor3 = Color3.fromRGB(18, 18, 22)
			}):Play()
		end

		pcall(v94)
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
		local function v106()
			local v107 = TweenService
			local v108 = TextButton3
			local tweenInfo = TweenInfo.new(0.14)
			local t3 = {
				BackgroundColor3 = Color3.fromRGB(30, 30, 36)
			}

			v107.Create(v107, v108, tweenInfo, t3):Play()
		end

		pcall(v106)
	end)
	TextButton3.MouseLeave:Connect(function()
		pcall(function()
			local v112 = TweenService
			local v113 = TextButton3
			local tweenInfo = TweenInfo.new(0.14)
			local t4 = {
				BackgroundColor3 = Color3.fromRGB(20, 20, 24)
			}

			v112.Create(v112, v113, tweenInfo, t4):Play()
		end)
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
			local t5 = {
				BackgroundColor3 = Color3.fromRGB(212, 212, 216)
			}

			v118.Create(v118, v119, tweenInfo, t5):Play()
		end

		pcall(v117)
	end)
	TextButton4.MouseLeave:Connect(function()
		if not TextButton4.Active then
			return
		end

		local function v122()
			TweenService:Create(TextButton4, TweenInfo.new(0.14), {
				BackgroundColor3 = Color3.fromRGB(250, 250, 250)
			}):Play()
		end

		pcall(v122)
	end)

	local function v123()
		Frame3.Size = UDim2.new(0, 345, 0, 168)

		local v124 = TweenService
		local v125 = Frame3
		local tweenInfo = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		local UDim2_ = UDim2

		v124.Create(v124, v125, tweenInfo, {
			Size = UDim2_.new(0, 380, 0, 186)
		}):Play()
	end

	pcall(v123)

	return {
		ScreenGui = ScreenGui,
		MainFrame = Frame3,
		KeyInput = TextBox,
		SubmitBtn = TextButton4,
		GetKeyBtn = TextButton3,
		StatusLabel = TextLabel,
		StatusDot = Frame5,
		notify = v49,
		closeWindow = v77
	}
end
local function v128(p10, p11, p12)
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
local function v129(p13, p14)
	v128(p14, "Verifying key...", Color3.fromRGB(212, 212, 216))

	local v130 = string.gsub(p13, "%s+", "")
	local v131 = string.gsub(v130, "\'", "")
	local v132 = string.gsub(v131, "\"", "")
	local v133 = v12(v132)

	if not v133 then
		return false, "invalid"
	end

	local v134 = v8({
		2,
		22,
		187,
		196,
		64,
		145,
		254,
		254,
		77,
		21,
		97,
		181,
		78,
		143,
		228,
		1,
		216,
		114,
		158,
		140,
		158,
		154,
		1,
		90,
		27,
		230,
		185,
		89,
		4,
		232,
		192,
		144,
		50,
		62,
		86,
		223,
		108,
		91,
		101,
		111,
		170,
		63,
		143,
		104,
		63,
		204,
		129,
		48,
		3,
		8,
		192,
		145,
		254,
		125,
		58,
		52,
		83,
		239
	}, {
		32,
		99,
		171,
		218,
		142,
		187,
		85,
		144,
		62,
		56,
		176,
		176,
		100,
		220,
		221,
		34
	}, v133)

	if string.sub(v134, 1, 8) ~= "https://" then
		return false, "invalid"
	end

	local v135 = v8({
		132,
		139,
		58,
		81,
		77,
		180,
		207,
		45,
		104,
		40,
		104,
		103,
		28,
		214,
		103,
		217,
		80,
		168,
		236,
		220,
		166,
		79,
		84,
		177,
		116,
		28,
		145,
		28,
		227,
		56,
		66,
		151,
		226,
		140,
		170,
		56,
		81,
		26,
		222,
		93,
		14,
		68,
		115,
		217,
		51,
		66,
		70,
		44,
		191,
		140,
		70,
		81,
		33,
		178,
		202,
		101,
		162,
		82,
		117,
		44,
		95,
		225
	}, {
		228,
		217,
		59,
		101,
		165,
		168,
		225,
		177,
		153,
		119,
		200,
		106,
		113,
		101,
		149,
		43
	}, v133)
	local tick_ = tick
	local v137 = tostring(tick_())
	local v138 = v134 .. HttpService:UrlEncode(v132) .. v135 .. v137
	local ok, result = pcall(function()
		return game:HttpGet(v138, true)
	end)

	if ok then
		local v141 = string.gsub(result, "^%s*(.-)%s*$", "%1")
		local v142 = string.gsub(v141, "\r", "")
		local v143 = string.gsub(v142, "\n", "")
		local v144 = string.lower(v143)

		if v144 == "valid" then
			return true, "valid"
		elseif v144 == "expired" then
			return false, "expired"
		elseif v144 == "invalid" then
			return false, "invalid"
		else
			return false, "error"
		end
	else
		return false, "connection_error"
	end
end
local function v145(p15)
	pcall(function()
		local v146 = v12(p15)

		if not v146 then
			return
		end

		local v147 = v8({
			172,
			249,
			92,
			117,
			248,
			185,
			98,
			224,
			65,
			140,
			11,
			212,
			158,
			70,
			136,
			121,
			130,
			85,
			63,
			61,
			86,
			194,
			101,
			60,
			15,
			93,
			99,
			120,
			84,
			159,
			100,
			8,
			220,
			33,
			247,
			144,
			36,
			131,
			201,
			81,
			158,
			182,
			57,
			135,
			143,
			128,
			35,
			168,
			173,
			245,
			92,
			66,
			184,
			182,
			148,
			18,
			255,
			91,
			207,
			159,
			91,
			5,
			84,
			76,
			110,
			15,
			250,
			46,
			67,
			195,
			37,
			70,
			223,
			37,
			41,
			118,
			85,
			104,
			43,
			16,
			152,
			243,
			236,
			89,
			246,
			83,
			134,
			28,
			151,
			174,
			70,
			115,
			177,
			129,
			47,
			168,
			129,
			243,
			87,
			122,
			242,
			224,
			161
		}, {
			202,
			70,
			76,
			139,
			70,
			227,
			185,
			114,
			50,
			175,
			90,
			207,
			180,
			147,
			129,
			154
		}, v146)

		if string.sub(v147, 1, 8) ~= "https://" then
			return
		end

		local v148 = p15

		if not v148 then
			if v148 then
				v147 = v147 .. "&key=" .. HttpService:UrlEncode(p15)
			else
				if not p15 then
					v166 = v147 .. (string.find(v147, "?") and "&" or "?") .. "t=" .. tostring(tick())
					loadstring(game:HttpGet(v166, true))()

					return
				end

				v147 = v147 .. "?key=" .. HttpService:UrlEncode(p15)
			end

			v166 = v147 .. (string.find(v147, "?") and "&" or "?") .. "t=" .. tostring(tick())
			loadstring(game:HttpGet(v166, true))()

			return
		end

		v148 = string.find(v147, "?")

		if v148 then
			v147 = v147 .. "&key=" .. HttpService:UrlEncode(p15)
		else
			if not p15 then
				v166 = v147 .. (string.find(v147, "?") and "&" or "?") .. "t=" .. tostring(tick())
				loadstring(game:HttpGet(v166, true))()

				return
			end

			v147 = v147 .. "?key=" .. HttpService:UrlEncode(p15)
		end

		local v149 = v147 .. (string.find(v147, "?") and "&" or "?") .. "t=" .. tostring(tick())

		loadstring(game:HttpGet(v149, true))()
	end)
end

(function()
	local v150 = v37()
	local u151 = nil
	local now = tick()

	local function v153()
		v150.KeyInput.Focused:Connect(function()
			u151 = true
		end)
		v150.KeyInput.FocusLost:Connect(function()
			u151 = true
		end)
	end

	u151 = false
	pcall(v153)

	local function v154(p16, p17)
		local v155 = string.gsub(p16 or "", "%s+", "")

		if v155 == "" then
			v128(v150, "Please enter a key first", Color3.fromRGB(244, 244, 245))
			v150.notify("Key Required", "Paste your key into the field to continue.", 2.5)

			return
		end

		v150.SubmitBtn.Text = "Checking..."
		v150.SubmitBtn.Active = false
		task.spawn(function()
			local v156, v157 = v129(v155, v150)

			if v156 then
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
				v128(v150, "Verified - loading...", Color3.fromRGB(250, 250, 250))
				v150.SubmitBtn.Text = "Verified"
				v150.notify("Verified", "Loading script...", 2)
				task.wait(0.6)
				v150.closeWindow()
				v145(v155)

				return
			end

			v150.SubmitBtn.Text = "Continue"
			v150.SubmitBtn.Active = true

			if not p17 then
				if v157 == "expired" then
					v128(v150, "Key already used or expired - click Get Key", Color3.fromRGB(161, 161, 170))
					v150.notify("Key Expired / Used", "Each key is one-time use. Click Get Key for a new key.", 3.5)
				elseif v157 == "invalid" then
					v128(v150, "Invalid key entered", Color3.fromRGB(161, 161, 170))
					v150.notify("Invalid Key", "The key entered is not valid.", 3)

					return
				else
					v128(v150, "Connection error - try again", Color3.fromRGB(161, 161, 170))
					v150.notify("Error", "Could not connect to verification server.", 3)

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

			if v157 == "expired" then
				v128(v150, "Key already used or expired - click Get Key", Color3.fromRGB(161, 161, 170))
				v150.notify("Key Expired / Used", "Each key is one-time use. Click Get Key for a new key.", 3.5)
			elseif v157 == "invalid" then
				v128(v150, "Invalid key entered", Color3.fromRGB(161, 161, 170))
				v150.notify("Invalid Key", "The key entered is not valid.", 3)

				return
			else
				v128(v150, "Connection error - try again", Color3.fromRGB(161, 161, 170))
				v150.notify("Error", "Could not connect to verification server.", 3)

				return
			end
		end)
	end

	v150.GetKeyBtn.MouseButton1Click:Connect(function()
		local v160 = v4({
			6,
			81,
			240,
			174,
			0,
			128,
			235,
			208,
			217,
			186,
			233,
			89,
			115,
			231,
			72,
			17,
			9,
			11,
			223,
			173,
			250,
			117,
			47,
			224,
			178,
			163,
			192,
			26,
			191,
			172,
			50,
			237
		}, {
			158,
			221,
			124,
			62,
			141,
			70,
			188,
			161,
			109,
			75,
			122,
			229,
			70,
			123,
			223,
			163
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
				setclipboard_(v160)
			end)
			v128(v150, "Key link copied to clipboard", Color3.fromRGB(250, 250, 250))
			v150.notify("Copied", "Key link copied to your clipboard.", 3)
		else
			v128(v150, "Clipboard not supported", Color3.fromRGB(161, 161, 170))
			v150.notify("Notice", "Clipboard is not supported by your executor.", 3)
		end
	end)
	v150.SubmitBtn.MouseButton1Click:Connect(function()
		local v162 = not u151

		if not v162 then
			if not v162 then
				v154(v150.KeyInput.Text, false)
			end

			return
		end

		v162 = tick() - now < 0.35

		if not v162 then
			v154(v150.KeyInput.Text, false)
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
