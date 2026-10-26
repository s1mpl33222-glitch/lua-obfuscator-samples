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
			local v16 = string.sub(v13, 1, 2)
			local v17 = tonumber(v16, 16)
			local v18 = tonumber(string.sub(v13, 3, 4), 16)
			local v19 = tonumber(string.sub(v14, 1, 2), 16)
			local v20 = string.sub(v14, 3, 4)
			local v21 = tonumber(v20, 16)
			local v22 = string.sub(v15, 1, 2)
			local v23 = tonumber(v22, 16)
			local v24 = tonumber(string.sub(v15, 3, 4), 16)

			return (v17 and (v18 and (v19 and (v21 and (v23 and v24)))) and true or false) and { (v21 - v17 - v18 + 512) % 256, (v23 - v18 - v19 + 512) % 256, (v24 - v19 - v17 + 512) % 256 } or nil
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

				local function v57()
					Frame3:Destroy()
				end

				tween.Play(tween)
				tween.Completed:Connect(v57)
			end

			pcall(v55)
		end
		local function v58()
			TweenService:Create(Frame4, TweenInfo.new(v46, Enum.EasingStyle.Linear), {
				Size = UDim2.new(0, 0, 0, 2)
			}):Play()
		end

		pcall(v58)
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

	local u62 = nil
	local u63 = nil
	local Position = nil
	local Position2 = nil

	Frame3.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u62 = true
		Position = input.Position
		Position2 = Frame3.Position
		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			u62 = false
		end)
	end)
	Frame3.InputChanged:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u63 = input
	end)
	UserInputService.InputChanged:Connect(function(input)
		local v66

		if input == u63 then
			v66 = u62
		else
			v66 = false
		end

		if not v66 then
			return
		end

		local v67 = input.Position - Position

		Frame3.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v67.X, Position2.Y.Scale, Position2.Y.Offset + v67.Y)
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

	local function v74()
		pcall(function()
			TweenService:Create(Frame, TweenInfo.new(0.18), {
				BackgroundTransparency = 1
			}):Play()

			local v75 = TweenService
			local v76 = Frame3
			local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			local UDim2_ = UDim2
			local v79 = v75.Create(v75, v76, tweenInfo, {
				Size = UDim2_.new(0, 340, 0, 160),
				BackgroundTransparency = 1
			})

			local function v80()
				ScreenGui:Destroy()
			end

			v79:Play()
			v79.Completed:Connect(v80)
		end)
	end

	TextButton.MouseButton1Click:Connect(v74)
	TextButton.MouseEnter:Connect(function()
		local function v81()
			local v82 = TweenService
			local v83 = TextButton
			local tweenInfo = TweenInfo.new(0.12)
			local Color3_ = Color3

			v82.Create(v82, v83, tweenInfo, {
				BackgroundColor3 = Color3_.fromRGB(38, 38, 44),
				TextColor3 = Color3.fromRGB(250, 250, 250)
			}):Play()
		end

		pcall(v81)
	end)
	TextButton.MouseLeave:Connect(function()
		local function v86()
			TweenService:Create(TextButton, TweenInfo.new(0.12), {
				BackgroundColor3 = Color3.fromRGB(22, 22, 26),
				TextColor3 = Color3.fromRGB(140, 140, 150)
			}):Play()
		end

		pcall(v86)
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

	local function v90()
		UIStroke = Instance.new("UIStroke")
		UIStroke.Color = Color3.fromRGB(38, 38, 45)
		UIStroke.Thickness = 1
		UIStroke.Parent = Frame6
	end

	pcall(v90)

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
		local function v95()
			if not UIStroke then
				v110 = TweenService
				v111 = Frame6
				v112 = TweenInfo.new
				v110.Create(v110, v111, v112(0.15), {
					BackgroundColor3 = Color3.fromRGB(22, 22, 27)
				}):Play()

				return
			end

			local v96 = TweenService
			local v97 = UIStroke
			local tweenInfo = TweenInfo.new(0.15)
			local Color3_ = Color3

			v96.Create(v96, v97, tweenInfo, {
				Color = Color3_.fromRGB(212, 212, 216),
				Thickness = 1.2
			}):Play()

			local v100 = TweenService
			local v101 = Frame6
			local tweenInfoNew = TweenInfo.new

			v100.Create(v100, v101, tweenInfoNew(0.15), {
				BackgroundColor3 = Color3.fromRGB(22, 22, 27)
			}):Play()
		end

		pcall(v95)
	end)
	TextBox.FocusLost:Connect(function()
		pcall(function()
			if not UIStroke then
				v114 = TweenService
				v115 = Frame6
				v116 = TweenInfo.new(0.15)
				v117 = Color3.fromRGB
				v114.Create(v114, v115, v116, {
					BackgroundColor3 = v117(18, 18, 22)
				}):Play()

				return
			end

			TweenService:Create(UIStroke, TweenInfo.new(0.15), {
				Color = Color3.fromRGB(38, 38, 45),
				Thickness = 1
			}):Play()

			local v103 = TweenService
			local v104 = Frame6
			local tweenInfo = TweenInfo.new(0.15)
			local color3 = Color3.fromRGB

			v103.Create(v103, v104, tweenInfo, {
				BackgroundColor3 = color3(18, 18, 22)
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
		local function v113()
			local v118 = TweenService
			local v119 = TextButton3
			local tweenInfo = TweenInfo.new(0.14)
			local Color3_ = Color3

			v118.Create(v118, v119, tweenInfo, {
				BackgroundColor3 = Color3_.fromRGB(30, 30, 36)
			}):Play()
		end

		pcall(v113)
	end)
	TextButton3.MouseLeave:Connect(function()
		pcall(function()
			TweenService:Create(TextButton3, TweenInfo.new(0.14), {
				BackgroundColor3 = Color3.fromRGB(20, 20, 24)
			}):Play()
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

		local function v120()
			TweenService:Create(TextButton4, TweenInfo.new(0.14), {
				BackgroundColor3 = Color3.fromRGB(212, 212, 216)
			}):Play()
		end

		pcall(v120)
	end)
	TextButton4.MouseLeave:Connect(function()
		if not TextButton4.Active then
			return
		end

		local function v121()
			local v122 = TweenService
			local v123 = TextButton4
			local tweenInfo = TweenInfo.new(0.14)
			local t3 = {
				BackgroundColor3 = Color3.fromRGB(250, 250, 250)
			}

			v122.Create(v122, v123, tweenInfo, t3):Play()
		end

		pcall(v121)
	end)

	local function v124()
		Frame3.Size = UDim2.new(0, 345, 0, 168)

		local v125 = TweenService
		local v126 = Frame3
		local tweenInfoNew = TweenInfo.new
		local Back = Enum.EasingStyle.Back
		local Out = Enum.EasingDirection.Out

		v125.Create(v125, v126, tweenInfoNew(0.28, Back, Out), {
			Size = UDim2.new(0, 380, 0, 186)
		}):Play()
	end

	pcall(v124)

	return {
		ScreenGui = ScreenGui,
		MainFrame = Frame3,
		KeyInput = TextBox,
		SubmitBtn = TextButton4,
		GetKeyBtn = TextButton3,
		StatusLabel = TextLabel,
		StatusDot = Frame5,
		notify = v45,
		closeWindow = v74
	}
end
local function v130(p10, p11)
	local color3 = Color3.fromRGB(212, 212, 216)

	if p11 and (p11.StatusLabel and p11.StatusLabel.Parent) then
		local text = "Verifying key..."

		pcall(function()
			p11.StatusLabel.Text = text

			if not color3 then
				return
			end

			p11.StatusLabel.TextColor3 = color3

			if not p11.StatusDot then
				return
			end

			p11.StatusDot.BackgroundColor3 = color3
		end)
	end

	local v133 = string.gsub(p10, "%s+", "")
	local v134 = string.gsub(v133, "\'", "")
	local v135 = string.gsub(v134, "\"", "")
	local v136 = v12(v135)

	if not v136 then
		return false, "invalid"
	end

	local v137 = v8({
		175,
		248,
		139,
		31,
		17,
		78,
		100,
		171,
		106,
		187,
		14,
		72,
		156,
		42,
		95,
		34,
		133,
		84,
		110,
		231,
		111,
		87,
		103,
		7,
		56,
		140,
		102,
		236,
		82,
		131,
		59,
		177,
		223,
		32,
		38,
		58,
		61,
		24,
		203,
		28,
		199,
		229,
		60,
		251,
		141,
		103,
		252,
		81,
		176,
		234,
		144,
		236,
		207,
		58,
		160,
		225,
		112,
		149
	}, {
		205,
		69,
		123,
		53,
		95,
		120,
		187,
		61,
		91,
		222,
		93,
		67,
		178,
		119,
		88,
		67
	}, v136)

	if string.sub(v137, 1, 8) ~= "https://" then
		return false, "invalid"
	end

	local v138 = v8({
		3,
		73,
		118,
		151,
		110,
		112,
		25,
		244,
		165,
		8,
		106,
		57,
		134,
		71,
		141,
		21,
		207,
		102,
		40,
		34,
		199,
		11,
		158,
		120,
		177,
		252,
		147,
		238,
		77,
		169,
		104,
		211,
		97,
		74,
		230,
		126,
		114,
		214,
		40,
		36,
		75,
		36,
		117,
		171,
		157,
		179,
		108,
		104,
		62,
		74,
		130,
		151,
		66,
		122,
		6,
		32,
		224,
		50,
		118,
		66,
		182,
		121,
		125,
		85,
		223
	}, {
		99,
		151,
		119,
		171,
		198,
		100,
		43,
		120,
		214,
		87,
		202,
		60,
		219,
		214,
		187,
		103
	}, v136)
	local tick_ = tick
	local v140 = tostring(tick_())
	local v141 = v137 .. HttpService:UrlEncode(v135) .. v138 .. v140
	local ok, result = pcall(function()
		return game:HttpGet(v141, true)
	end)

	if ok then
		local v144 = string.gsub(result, "^%s*(.-)%s*$", "%1")
		local v145 = string.gsub(v144, "\r", "")
		local v146 = string.gsub(v145, "\n", "")
		local v147 = string.lower(v146)

		if v147 == "valid" then
			return true, "valid"
		elseif v147 == "expired" then
			return false, "expired"
		elseif v147 == "invalid" then
			return false, "invalid"
		else
			return false, "error"
		end
	else
		return false, "connection_error"
	end
end
local function v148(p12)
	pcall(function()
		local v149 = v12(p12)

		if not v149 then
			return
		end

		local v150 = v8({
			30,
			110,
			166,
			17,
			254,
			250,
			9,
			176,
			118,
			252,
			8,
			71,
			46,
			90,
			144,
			73,
			244,
			202,
			137,
			217,
			92,
			3,
			12,
			12,
			68,
			205,
			96,
			235,
			228,
			179,
			108,
			216,
			78,
			150,
			65,
			44,
			42,
			196,
			112,
			33,
			211,
			38,
			54,
			250,
			31,
			148,
			43,
			120,
			31,
			106,
			166,
			222,
			190,
			247,
			59,
			226,
			52,
			203,
			204,
			18,
			235,
			25,
			92,
			28,
			224,
			132,
			68,
			202,
			73,
			4,
			204,
			22,
			20,
			149,
			38,
			233,
			229,
			124,
			51,
			224,
			10,
			104,
			54,
			245,
			252,
			148,
			45,
			236,
			204,
			30,
			67,
			230,
			65,
			149,
			55,
			120,
			243,
			116,
			147,
			10,
			249,
			33,
			71,
			235,
			100,
			253
		}, {
			60,
			187,
			150,
			39,
			76,
			36,
			96,
			66,
			103,
			31,
			87,
			66,
			68,
			167,
			137,
			106
		}, v149)

		if string.sub(v150, 1, 8) ~= "https://" then
			return
		end

		local v151 = p12

		if not v151 then
			if v151 then
				v150 = v150 .. "&key=" .. HttpService:UrlEncode(p12)
			else
				if not p12 then
					v166 = v150 .. (string.find(v150, "?") and "&" or "?") .. "t=" .. tostring(tick())
					loadstring(game:HttpGet(v166, true))()

					return
				end

				v150 = v150 .. "?key=" .. HttpService:UrlEncode(p12)
			end

			v166 = v150 .. (string.find(v150, "?") and "&" or "?") .. "t=" .. tostring(tick())
			loadstring(game:HttpGet(v166, true))()

			return
		end

		v151 = string.find(v150, "?")

		if v151 then
			v150 = v150 .. "&key=" .. HttpService:UrlEncode(p12)
		else
			if not p12 then
				v166 = v150 .. (string.find(v150, "?") and "&" or "?") .. "t=" .. tostring(tick())
				loadstring(game:HttpGet(v166, true))()

				return
			end

			v150 = v150 .. "?key=" .. HttpService:UrlEncode(p12)
		end

		local v152 = v150 .. (string.find(v150, "?") and "&" or "?") .. "t=" .. tostring(tick())

		loadstring(game:HttpGet(v152, true))()
	end)
end

(function()
	local v153 = v37()
	local now = tick()
	local u155 = false

	pcall(function()
		v153.KeyInput.Focused:Connect(function()
			u155 = true
		end)
		v153.KeyInput.FocusLost:Connect(function()
			u155 = true
		end)
	end)

	local function v156(p13, p14)
		local v157 = string.gsub(p13 or "", "%s+", "")

		if v157 ~= "" then
			v153.SubmitBtn.Text = "Checking..."
			v153.SubmitBtn.Active = false
			task.spawn(function()
				local v158, v159 = v130(v157, v153)

				if v158 then
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

					local v161 = v153
					local color3 = Color3.fromRGB(250, 250, 250)

					if not (v161 and (v161.StatusLabel and v161.StatusLabel.Parent)) then
						v153.SubmitBtn.Text = "Verified"
						v153.notify("Verified", "Loading script...", 2)
						task.wait(0.6)
						v153.closeWindow()
						v148(v157)

						return
					end

					local text = "Verified - loading..."

					pcall(function()
						v161.StatusLabel.Text = text

						if not color3 then
							return
						end

						v161.StatusLabel.TextColor3 = color3

						if not v161.StatusDot then
							return
						end

						v161.StatusDot.BackgroundColor3 = color3
					end)
					v153.SubmitBtn.Text = "Verified"
					v153.notify("Verified", "Loading script...", 2)
					task.wait(0.6)
					v153.closeWindow()
					v148(v157)
				else
					v153.SubmitBtn.Text = "Continue"
					v153.SubmitBtn.Active = true

					if p14 then
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
					end

					if v159 == "expired" then
						local v165 = v153
						local color3 = Color3.fromRGB(161, 161, 170)

						if not (v165 and (v165.StatusLabel and v165.StatusLabel.Parent)) then
							v153.notify("Key Expired / Used", "Each key is one-time use. Click Get Key for a new key.", 3.5)

							return
						end

						local text = "Key already used or expired - click Get Key"

						pcall(function()
							v165.StatusLabel.Text = text

							if not color3 then
								return
							end

							v165.StatusLabel.TextColor3 = color3

							if not v165.StatusDot then
								return
							end

							v165.StatusDot.BackgroundColor3 = color3
						end)
						v153.notify("Key Expired / Used", "Each key is one-time use. Click Get Key for a new key.", 3.5)
					elseif v159 == "invalid" then
						local v168 = v153
						local color3 = Color3.fromRGB(161, 161, 170)

						if not (v168 and (v168.StatusLabel and v168.StatusLabel.Parent)) then
							v153.notify("Invalid Key", "The key entered is not valid.", 3)

							return
						end

						local text = "Invalid key entered"

						pcall(function()
							v168.StatusLabel.Text = text

							if not color3 then
								return
							end

							v168.StatusLabel.TextColor3 = color3

							if not v168.StatusDot then
								return
							end

							v168.StatusDot.BackgroundColor3 = color3
						end)
						v153.notify("Invalid Key", "The key entered is not valid.", 3)
					else
						local v171 = v153
						local color3 = Color3.fromRGB(161, 161, 170)

						if not (v171 and (v171.StatusLabel and v171.StatusLabel.Parent)) then
							v153.notify("Error", "Could not connect to verification server.", 3)

							return
						end

						local text = "Connection error - try again"

						pcall(function()
							v171.StatusLabel.Text = text

							if not color3 then
								return
							end

							v171.StatusLabel.TextColor3 = color3

							if not v171.StatusDot then
								return
							end

							v171.StatusDot.BackgroundColor3 = color3
						end)
						v153.notify("Error", "Could not connect to verification server.", 3)
					end
				end
			end)

			return
		end

		local v174 = v153
		local color3 = Color3.fromRGB(244, 244, 245)

		if not (v174 and (v174.StatusLabel and v174.StatusLabel.Parent)) then
			v153.notify("Key Required", "Paste your key into the field to continue.", 2.5)

			return
		end

		local text = "Please enter a key first"

		pcall(function()
			v174.StatusLabel.Text = text

			if not color3 then
				return
			end

			v174.StatusLabel.TextColor3 = color3

			if not v174.StatusDot then
				return
			end

			v174.StatusDot.BackgroundColor3 = color3
		end)
		v153.notify("Key Required", "Paste your key into the field to continue.", 2.5)
	end

	v153.GetKeyBtn.MouseButton1Click:Connect(function()
		local v177 = v4({
			77,
			150,
			79,
			174,
			77,
			111,
			255,
			217,
			19,
			49,
			84,
			184,
			62,
			248,
			40,
			1,
			19,
			145,
			77,
			165,
			9,
			168,
			15,
			242,
			11,
			48,
			47,
			170,
			35,
			254,
			39
		}, {
			229,
			34,
			219,
			62,
			218,
			53,
			208,
			170,
			167,
			194,
			229,
			68,
			218,
			147,
			181,
			141
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

		local notify

		if setclipboard_ then
			pcall(function()
				setclipboard_(v177)
			end)

			local v180 = v153
			local color3 = Color3.fromRGB(250, 250, 250)

			if v180 and (v180.StatusLabel and v180.StatusLabel.Parent) then
				local text = "Key link copied to clipboard"

				pcall(function()
					v180.StatusLabel.Text = text

					if not color3 then
						return
					end

					v180.StatusLabel.TextColor3 = color3

					if not v180.StatusDot then
						return
					end

					v180.StatusDot.BackgroundColor3 = color3
				end)
			end

			notify = v153.notify
			notify("Copied", "Key link copied to your clipboard.", 3)
		else
			local v183 = v153
			local color3 = Color3.fromRGB(161, 161, 170)

			if v183 and (v183.StatusLabel and v183.StatusLabel.Parent) then
				local text = "Clipboard not supported"

				pcall(function()
					v183.StatusLabel.Text = text

					if not color3 then
						return
					end

					v183.StatusLabel.TextColor3 = color3

					if not v183.StatusDot then
						return
					end

					v183.StatusDot.BackgroundColor3 = color3
				end)
			end

			notify = v153.notify
			notify("Notice", "Clipboard is not supported by your executor.", 3)
		end

		local _ = notify
	end)
	v153.SubmitBtn.MouseButton1Click:Connect(function()
		local v187 = not u155

		if not v187 then
			if not v187 then
				v156(v153.KeyInput.Text, false)
			end

			return
		end

		v187 = tick() - now < 0.35

		if not v187 then
			v156(v153.KeyInput.Text, false)
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
