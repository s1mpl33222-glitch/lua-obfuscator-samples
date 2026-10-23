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

local function v20()
	local ok, result = pcall(function()
		local isfile_ = isfile

		if isfile_ then
		elseif isfile_ then
			return readfile("key_session_cache.txt")
		else
			return nil
		end

		isfile_ = readfile

		if isfile_ then
		elseif isfile_ then
			return readfile("key_session_cache.txt")
		else
			return nil
		end

		isfile_ = isfile("key_session_cache.txt")

		if isfile_ then
			return readfile("key_session_cache.txt")
		else
			return nil
		end
	end)
	local v24

	if ok then
	elseif ok then
		v24 = string.gsub(result, "%s+", "")

		if #v24 >= 4 then
			return v24
		else
			return nil
		end
	else
		return nil
	end

	ok = type(result) == "string"

	if ok then
		v24 = string.gsub(result, "%s+", "")

		if #v24 >= 4 then
			return v24
		else
			return nil
		end
	else
		return nil
	end
end
local function v25()
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
			LocalPlayer:WaitForChild("PlayerGui", 10)
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

	local function v33(p3, p4, p5)
		local v34 = p5 or 3
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
		TextLabel.Text = p3
		TextLabel.TextColor3 = Color3.fromRGB(250, 250, 250)
		TextLabel.TextSize = 12
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left

		local TextLabel2 = Instance.new("TextLabel")

		TextLabel2.Parent = Frame3
		TextLabel2.Position = UDim2.new(0, 14, 0, 27)
		TextLabel2.Size = UDim2.new(1, -28, 0, 18)
		TextLabel2.BackgroundTransparency = 1
		TextLabel2.Text = p4
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

		local function v41()
			TweenService:Create(Frame4, TweenInfo.new(v34, Enum.EasingStyle.Linear), {
				Size = UDim2.new(0, 0, 0, 2)
			}):Play()
		end

		pcall(v41)
		task.delay(v34, function()
			local Parent = Frame3

			if Parent then
				Parent = Frame3.Parent
			end

			if not Parent then
				return
			end

			local function v43()
				local tween = TweenService:Create(Frame3, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0)
				})

				tween:Play()
				tween.Completed:Connect(function()
					Frame3:Destroy()
				end)
			end

			pcall(v43)
		end)
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

	local u48 = nil
	local u49 = nil
	local Position = nil
	local Position2 = nil

	Frame3.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u48 = true
		Position = input.Position
		Position2 = Frame3.Position
		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			u48 = false
		end)
	end)
	Frame3.InputChanged:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u49 = input
	end)
	UserInputService.InputChanged:Connect(function(input)
		local v52

		if input == u49 then
			v52 = u48
		else
			v52 = false
		end

		if not v52 then
			return
		end

		local v53 = input.Position - Position

		Frame3.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v53.X, Position2.Y.Scale, Position2.Y.Offset + v53.Y)
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

	local function v60()
		local function v61()
			TweenService:Create(Frame, TweenInfo.new(0.18), {
				BackgroundTransparency = 1
			}):Play()

			local v62 = TweenService
			local v63 = Frame3
			local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			local t2 = {
				Size = UDim2.new(0, 340, 0, 160),
				BackgroundTransparency = 1
			}
			local v66 = v62.Create(v62, v63, tweenInfo, t2)

			local function v67()
				ScreenGui:Destroy()
			end

			v66:Play()
			v66.Completed:Connect(v67)
		end

		pcall(v61)
	end

	TextButton.MouseButton1Click:Connect(v60)
	TextButton.MouseEnter:Connect(function()
		local function v68()
			TweenService:Create(TextButton, TweenInfo.new(0.12), {
				BackgroundColor3 = Color3.fromRGB(38, 38, 44),
				TextColor3 = Color3.fromRGB(250, 250, 250)
			}):Play()
		end

		pcall(v68)
	end)
	TextButton.MouseLeave:Connect(function()
		pcall(function()
			TweenService:Create(TextButton, TweenInfo.new(0.12), {
				BackgroundColor3 = Color3.fromRGB(22, 22, 26),
				TextColor3 = Color3.fromRGB(140, 140, 150)
			}):Play()
		end)
	end)

	local Frame6 = Instance.new("Frame")

	Frame6.Parent = Frame3
	Frame6.Position = UDim2.new(0, 20, 0, 54)
	Frame6.Size = UDim2.new(1, -40, 0, 46)
	Frame6.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
	Frame6.BorderSizePixel = 0

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(0, 10)

	local UIStroke = nil

	local function v72()
		UIStroke = Instance.new("UIStroke")
		UIStroke.Color = Color3.fromRGB(38, 38, 45)
		UIStroke.Thickness = 1
		UIStroke.Parent = Frame6
	end

	UICorner4.Parent = Frame6
	UIStroke = nil
	pcall(v72)

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
		local function v77()
			if not UIStroke then
				v84 = TweenService
				v85 = Frame6
				v86 = TweenInfo.new(0.15)
				v87 = Color3.fromRGB
				v84.Create(v84, v85, v86, {
					BackgroundColor3 = v87(22, 22, 27)
				}):Play()

				return
			end

			TweenService:Create(UIStroke, TweenInfo.new(0.15), {
				Color = Color3.fromRGB(212, 212, 216),
				Thickness = 1.2
			}):Play()

			local v78 = TweenService
			local v79 = Frame6
			local tweenInfo = TweenInfo.new(0.15)
			local color3 = Color3.fromRGB

			v78.Create(v78, v79, tweenInfo, {
				BackgroundColor3 = color3(22, 22, 27)
			}):Play()
		end

		pcall(v77)
	end)
	TextBox.FocusLost:Connect(function()
		pcall(function()
			if not UIStroke then
				v93 = TweenService
				v94 = Frame6
				v95 = TweenInfo.new(0.15)
				v96 = {
					BackgroundColor3 = Color3.fromRGB(18, 18, 22)
				}
				v93.Create(v93, v94, v95, v96):Play()

				return
			end

			local v82 = TweenService
			local v83 = UIStroke
			local tweenInfo = TweenInfo.new(0.15)
			local color3 = Color3.fromRGB

			v82.Create(v82, v83, tweenInfo, {
				Color = color3(38, 38, 45),
				Thickness = 1
			}):Play()

			local v88 = TweenService
			local v89 = Frame6
			local tweenInfo2 = TweenInfo.new(0.15)
			local t3 = {
				BackgroundColor3 = Color3.fromRGB(18, 18, 22)
			}

			v88.Create(v88, v89, tweenInfo2, t3):Play()
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
		local function v97()
			TweenService:Create(TextButton3, TweenInfo.new(0.14), {
				BackgroundColor3 = Color3.fromRGB(30, 30, 36)
			}):Play()
		end

		pcall(v97)
	end)
	TextButton3.MouseLeave:Connect(function()
		local function v98()
			TweenService:Create(TextButton3, TweenInfo.new(0.14), {
				BackgroundColor3 = Color3.fromRGB(20, 20, 24)
			}):Play()
		end

		pcall(v98)
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

		local function v99()
			local v100 = TweenService
			local v101 = TextButton4
			local tweenInfo = TweenInfo.new(0.14)
			local Color3_ = Color3

			v100.Create(v100, v101, tweenInfo, {
				BackgroundColor3 = Color3_.fromRGB(212, 212, 216)
			}):Play()
		end

		pcall(v99)
	end)
	TextButton4.MouseLeave:Connect(function()
		if not TextButton4.Active then
			return
		end

		local function v103()
			TweenService:Create(TextButton4, TweenInfo.new(0.14), {
				BackgroundColor3 = Color3.fromRGB(250, 250, 250)
			}):Play()
		end

		pcall(v103)
	end)

	local function v104()
		Frame3.Size = UDim2.new(0, 345, 0, 168)

		local v105 = TweenService
		local v106 = Frame3
		local tweenInfo = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		local UDim2_ = UDim2

		v105.Create(v105, v106, tweenInfo, {
			Size = UDim2_.new(0, 380, 0, 186)
		}):Play()
	end

	pcall(v104)

	return {
		ScreenGui = ScreenGui,
		MainFrame = Frame3,
		KeyInput = TextBox,
		SubmitBtn = TextButton4,
		GetKeyBtn = TextButton3,
		StatusLabel = TextLabel,
		StatusDot = Frame5,
		notify = v33,
		closeWindow = v60
	}
end
local function v109(p6, p7)
	local color3 = Color3.fromRGB(212, 212, 216)

	if p7 and (p7.StatusLabel and p7.StatusLabel.Parent) then
		local text = "Verifying key..."

		pcall(function()
			p7.StatusLabel.Text = text

			if not color3 then
				return
			end

			p7.StatusLabel.TextColor3 = color3

			if not p7.StatusDot then
				return
			end

			p7.StatusDot.BackgroundColor3 = color3
		end)
	end

	local v112 = string.gsub(p6, "%s+", "")
	local v113 = string.gsub(v112, "\'", "")
	local v114 = string.gsub(v113, "\"", "")
	local tick_ = tick
	local v116 = tostring(tick_())
	local v117 = v4({
		29,
		17,
		167,
		2,
		201,
		167,
		223,
		188,
		187,
		69,
		250,
		220,
		146,
		26,
		208,
		58,
		46,
		16,
		172,
		5,
		202,
		210,
		29,
		187,
		171,
		81,
		245,
		162,
		131,
		22,
		206,
		4,
		43,
		254,
		159,
		251,
		186,
		206,
		36,
		242,
		117,
		77,
		237,
		236,
		97,
		28,
		202,
		71,
		30,
		3,
		172,
		207,
		135,
		147,
		27,
		242,
		193,
		31
	}, {
		181,
		157,
		51,
		146,
		86,
		109,
		176,
		141,
		72,
		226,
		136,
		115,
		34,
		166,
		101,
		213
	}) .. HttpService:UrlEncode(v114) .. v4({
		219,
		16,
		150,
		4,
		191,
		221,
		36,
		202,
		171,
		26,
		184,
		213,
		134,
		220,
		151,
		58,
		226,
		214,
		108,
		198,
		187,
		154,
		228,
		243,
		126,
		20,
		181,
		171,
		85,
		222,
		151,
		2,
		27,
		1,
		99,
		200,
		184,
		157,
		18,
		238,
		170,
		71,
		189,
		169,
		72,
		9,
		215,
		58,
		22,
		17,
		162,
		4,
		147,
		224,
		37,
		243,
		193,
		67,
		246,
		153,
		150,
		227
	}, {
		181,
		157,
		51,
		146,
		86,
		109,
		176,
		141,
		72,
		226,
		136,
		115,
		34,
		166,
		101,
		213
	}) .. v116
	local ok, result = pcall(function()
		return game:HttpGet(v117, true)
	end)

	if ok then
		local v120 = string.gsub(result, "^%s*(.-)%s*$", "%1")
		local v121 = string.gsub(v120, "\r", "")
		local v122 = string.gsub(v121, "\n", "")
		local v123 = string.lower(v122)

		if v123 == "valid" then
			return true, "valid"
		elseif v123 == "expired" then
			return false, "expired"
		elseif v123 == "invalid" then
			return false, "invalid"
		else
			return false, "error"
		end
	else
		return false, "connection_error"
	end
end
local function v124(p8)
	local v125 = nil

	local function v126()
		local v127 = v4({
			29,
			17,
			167,
			2,
			201,
			167,
			223,
			188,
			187,
			69,
			250,
			220,
			146,
			26,
			208,
			58,
			46,
			16,
			172,
			5,
			202,
			210,
			29,
			187,
			171,
			81,
			245,
			162,
			131,
			22,
			206,
			4,
			43,
			254,
			159,
			251,
			186,
			206,
			36,
			242,
			117,
			77,
			237,
			236,
			97,
			25,
			200,
			71,
			30,
			13,
			167,
			207,
			185,
			165,
			224,
			239,
			172,
			24,
			186,
			216,
			79,
			223,
			158,
			9,
			26,
			202,
			103,
			248,
			140,
			159,
			221,
			197,
			123,
			26,
			186,
			160,
			136,
			10,
			149,
			11,
			23,
			205,
			149,
			243,
			184,
			210,
			229,
			195,
			110,
			69,
			250,
			216,
			131,
			26,
			212,
			71,
			242,
			16,
			168,
			248,
			207,
			206,
			30
		}, {
			181,
			157,
			51,
			146,
			86,
			109,
			176,
			141,
			72,
			226,
			136,
			115,
			34,
			166,
			101,
			213
		})
		local v128 = v125

		if not v128 then
			if v128 then
				v127 = v127 .. "&key=" .. HttpService:UrlEncode(v125)
			else
				if not v125 then
					v138 = string.find(v127, "?") and "&" or "?"
					v139 = tick
					v140 = v127 .. v138 .. "t=" .. tostring(v139())
					loadstring(game:HttpGet(v140, true))()

					return
				end

				v127 = v127 .. "?key=" .. HttpService:UrlEncode(v125)
			end

			v138 = string.find(v127, "?") and "&" or "?"
			v139 = tick
			v140 = v127 .. v138 .. "t=" .. tostring(v139())
			loadstring(game:HttpGet(v140, true))()

			return
		end

		v128 = string.find(v127, "?")

		if v128 then
			v127 = v127 .. "&key=" .. HttpService:UrlEncode(v125)
		else
			if not v125 then
				v138 = string.find(v127, "?") and "&" or "?"
				v139 = tick
				v140 = v127 .. v138 .. "t=" .. tostring(v139())
				loadstring(game:HttpGet(v140, true))()

				return
			end

			v127 = v127 .. "?key=" .. HttpService:UrlEncode(v125)
		end

		local v129 = string.find(v127, "?") and "&" or "?"
		local tick_ = tick
		local v131 = v127 .. v129 .. "t=" .. tostring(tick_())

		loadstring(game:HttpGet(v131, true))()
	end

	v125 = p8
	pcall(v126)
end

(function()
	local v132 = v25()

	local function v133(p9, p10)
		local v134 = string.gsub(p9 or "", "%s+", "")

		if v134 ~= "" then
			v132.SubmitBtn.Text = "Checking..."
			v132.SubmitBtn.Active = false
			task.spawn(function()
				local v135, v136 = v109(v134, v132)

				if v135 then
					local v137 = v134
					local v141 = nil

					local function v142()
						local writefile_ = writefile

						if writefile_ then
							local v143 = v141

							if type(v143) == "string" then
								writefile_ = #v141 >= 4
							else
								writefile_ = false
							end
						end

						if not writefile_ then
							return
						end

						writefile("key_session_cache.txt", v141)
					end

					v141 = v137
					pcall(v142)

					local v144 = v132
					local color3 = Color3.fromRGB(250, 250, 250)

					if not (v144 and (v144.StatusLabel and v144.StatusLabel.Parent)) then
						v132.SubmitBtn.Text = "Verified"
						v132.notify("Verified", "Loading script...", 2)
						task.wait(0.6)
						v132.closeWindow()
						v124(v134)

						return
					end

					local text = "Verified - loading..."

					pcall(function()
						v144.StatusLabel.Text = text

						if not color3 then
							return
						end

						v144.StatusLabel.TextColor3 = color3

						if not v144.StatusDot then
							return
						end

						v144.StatusDot.BackgroundColor3 = color3
					end)
					v132.SubmitBtn.Text = "Verified"
					v132.notify("Verified", "Loading script...", 2)
					task.wait(0.6)
					v132.closeWindow()
					v124(v134)
				else
					v132.SubmitBtn.Text = "Continue"
					v132.SubmitBtn.Active = true

					if p10 then
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

					if v136 == "expired" then
						local v146 = v132
						local color3 = Color3.fromRGB(161, 161, 170)

						if not (v146 and (v146.StatusLabel and v146.StatusLabel.Parent)) then
							v132.notify("Key Expired", "Click Get Key to generate a new key.", 3.5)

							return
						end

						local text = "Key expired - click Get Key"

						pcall(function()
							v146.StatusLabel.Text = text

							if not color3 then
								return
							end

							v146.StatusLabel.TextColor3 = color3

							if not v146.StatusDot then
								return
							end

							v146.StatusDot.BackgroundColor3 = color3
						end)
						v132.notify("Key Expired", "Click Get Key to generate a new key.", 3.5)
					elseif v136 == "invalid" then
						local v149 = v132
						local color3 = Color3.fromRGB(161, 161, 170)

						if not (v149 and (v149.StatusLabel and v149.StatusLabel.Parent)) then
							v132.notify("Invalid Key", "The key entered is not valid.", 3)

							return
						end

						local text = "Invalid key entered"

						pcall(function()
							v149.StatusLabel.Text = text

							if not color3 then
								return
							end

							v149.StatusLabel.TextColor3 = color3

							if not v149.StatusDot then
								return
							end

							v149.StatusDot.BackgroundColor3 = color3
						end)
						v132.notify("Invalid Key", "The key entered is not valid.", 3)
					else
						local v152 = v132
						local color3 = Color3.fromRGB(161, 161, 170)

						if not (v152 and (v152.StatusLabel and v152.StatusLabel.Parent)) then
							v132.notify("Error", "Could not connect to verification server.", 3)

							return
						end

						local text = "Connection error - try again"

						pcall(function()
							v152.StatusLabel.Text = text

							if not color3 then
								return
							end

							v152.StatusLabel.TextColor3 = color3

							if not v152.StatusDot then
								return
							end

							v152.StatusDot.BackgroundColor3 = color3
						end)
						v132.notify("Error", "Could not connect to verification server.", 3)
					end
				end
			end)

			return
		end

		local v155 = v132
		local color3 = Color3.fromRGB(244, 244, 245)

		if not (v155 and (v155.StatusLabel and v155.StatusLabel.Parent)) then
			v132.notify("Key Required", "Paste your key into the field to continue.", 2.5)

			return
		end

		local text = "Please enter a key first"

		pcall(function()
			v155.StatusLabel.Text = text

			if not color3 then
				return
			end

			v155.StatusLabel.TextColor3 = color3

			if not v155.StatusDot then
				return
			end

			v155.StatusDot.BackgroundColor3 = color3
		end)
		v132.notify("Key Required", "Paste your key into the field to continue.", 2.5)
	end

	v132.GetKeyBtn.MouseButton1Click:Connect(function()
		local v158 = v4({
			29,
			17,
			167,
			2,
			201,
			167,
			223,
			188,
			187,
			69,
			250,
			220,
			146,
			26,
			208,
			58,
			46,
			16,
			172,
			5,
			202,
			210,
			29,
			187,
			171,
			81,
			245,
			162,
			149,
			27,
			203,
			78,
			22,
			11,
			98,
			253,
			187,
			230,
			35,
			6,
			187,
			86,
			237,
			224,
			97,
			25,
			200,
			71,
			30,
			13,
			167,
			207,
			185,
			165,
			224,
			239,
			172,
			24,
			186,
			216,
			79,
			223,
			158,
			9,
			26,
			202,
			103,
			248,
			140,
			159,
			221,
			197,
			123,
			26,
			186,
			160,
			136,
			10,
			149,
			11,
			23,
			205,
			149,
			243,
			184,
			210,
			229,
			195
		}, {
			181,
			157,
			51,
			146,
			86,
			109,
			176,
			141,
			72,
			226,
			136,
			115,
			34,
			166,
			101,
			213
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
				setclipboard_(v158)
			end)

			local v160 = v132
			local color3 = Color3.fromRGB(250, 250, 250)

			if v160 and (v160.StatusLabel and v160.StatusLabel.Parent) then
				local text = "Key link copied to clipboard"

				pcall(function()
					v160.StatusLabel.Text = text

					if not color3 then
						return
					end

					v160.StatusLabel.TextColor3 = color3

					if not v160.StatusDot then
						return
					end

					v160.StatusDot.BackgroundColor3 = color3
				end)
			end

			v132.notify("Copied", "Key link copied to your clipboard.", 3)
		else
			local v163 = v132
			local color3 = Color3.fromRGB(161, 161, 170)

			if v163 and (v163.StatusLabel and v163.StatusLabel.Parent) then
				local text = "Clipboard not supported"

				pcall(function()
					v163.StatusLabel.Text = text

					if not color3 then
						return
					end

					v163.StatusLabel.TextColor3 = color3

					if not v163.StatusDot then
						return
					end

					v163.StatusDot.BackgroundColor3 = color3
				end)
			end

			v132.notify("Notice", "Clipboard is not supported by your executor.", 3)
		end
	end)
	v132.SubmitBtn.MouseButton1Click:Connect(function()
		v133(v132.KeyInput.Text, false)
	end)

	local v166 = v20()

	if not v166 then
		return
	end

	v132.KeyInput.Text = v166

	local color3 = Color3.fromRGB(212, 212, 216)

	if v132 and (v132.StatusLabel and v132.StatusLabel.Parent) then
		local text = "Checking saved key..."

		pcall(function()
			v132.StatusLabel.Text = text

			if not color3 then
				return
			end

			v132.StatusLabel.TextColor3 = color3

			if not v132.StatusDot then
				return
			end

			v132.StatusDot.BackgroundColor3 = color3
		end)
	end

	v133(v166, true)
end)()
