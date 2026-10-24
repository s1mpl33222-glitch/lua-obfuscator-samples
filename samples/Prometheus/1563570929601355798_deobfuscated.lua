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

	if not ok or (type(result) ~= "number" or result <= 0) then
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
			local Parent = Frame3

			if Parent then
				Parent = Frame3.Parent
			end

			if not Parent then
				return
			end

			local function v43()
				local v44 = TweenService
				local v45 = Frame3
				local TweenInfo_ = TweenInfo
				local v47 = v44.Create(v44, v45, TweenInfo_.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0)
				})

				v47.Play(v47)

				local function v48()
					Frame3:Destroy()
				end

				v47.Completed:Connect(v48)
			end

			pcall(v43)
		end

		pcall(function()
			local v49 = TweenService
			local v50 = Frame4
			local tweenInfoNew = TweenInfo.new
			local EasingStyle = Enum.EasingStyle

			v49.Create(v49, v50, tweenInfoNew(v34, EasingStyle.Linear), {
				Size = UDim2.new(0, 0, 0, 2)
			}):Play()
		end)
		task.delay(v34, v41)
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

	local u56 = nil
	local u57 = nil
	local Position = nil
	local Position2 = nil

	Frame3.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u56 = true
		Position = input.Position
		Position2 = Frame3.Position
		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			u56 = false
		end)
	end)
	Frame3.InputChanged:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u57 = input
	end)
	UserInputService.InputChanged:Connect(function(input)
		local v60

		if input == u57 then
			v60 = u56
		else
			v60 = false
		end

		if not v60 then
			return
		end

		local v61 = input.Position - Position

		Frame3.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v61.X, Position2.Y.Scale, Position2.Y.Offset + v61.Y)
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

	local function v68()
		local function v69()
			TweenService:Create(Frame, TweenInfo.new(0.18), {
				BackgroundTransparency = 1
			}):Play()

			local v70 = TweenService
			local v71 = Frame3
			local tweenInfoNew = TweenInfo.new
			local Quad = Enum.EasingStyle.Quad
			local In = Enum.EasingDirection.In
			local v75 = v70.Create(v70, v71, tweenInfoNew(0.18, Quad, In), {
				Size = UDim2.new(0, 340, 0, 160),
				BackgroundTransparency = 1
			})

			v75:Play()

			local function v76()
				ScreenGui:Destroy()
			end

			v75.Completed:Connect(v76)
		end

		pcall(v69)
	end

	TextButton.MouseButton1Click:Connect(v68)
	TextButton.MouseEnter:Connect(function()
		pcall(function()
			TweenService:Create(TextButton, TweenInfo.new(0.12), {
				BackgroundColor3 = Color3.fromRGB(38, 38, 44),
				TextColor3 = Color3.fromRGB(250, 250, 250)
			}):Play()
		end)
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

	local function v80()
		UIStroke = Instance.new("UIStroke")
		UIStroke.Color = Color3.fromRGB(38, 38, 45)
		UIStroke.Thickness = 1
		UIStroke.Parent = Frame6
	end

	UICorner4.Parent = Frame6
	UIStroke = nil
	pcall(v80)

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
	TextButton2.BackgroundColor3 = Color3.fromRGB(30, 28, 34)
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
		local function v85()
			if not UIStroke then
				v92 = TweenService
				v93 = Frame6
				v94 = TweenInfo.new(0.15)
				v95 = Color3.fromRGB
				v92.Create(v92, v93, v94, {
					BackgroundColor3 = v95(22, 22, 27)
				}):Play()

				return
			end

			TweenService:Create(UIStroke, TweenInfo.new(0.15), {
				Color = Color3.fromRGB(212, 212, 216),
				Thickness = 1.2
			}):Play()

			local v86 = TweenService
			local v87 = Frame6
			local tweenInfo = TweenInfo.new(0.15)
			local color3 = Color3.fromRGB

			v86.Create(v86, v87, tweenInfo, {
				BackgroundColor3 = color3(22, 22, 27)
			}):Play()
		end

		pcall(v85)
	end)
	TextBox.FocusLost:Connect(function()
		local function v90()
			if not UIStroke then
				v97 = TweenService
				v98 = Frame6
				v99 = TweenInfo.new(0.15)
				v97.Create(v97, v98, v99, {
					BackgroundColor3 = Color3.fromRGB(18, 18, 22)
				}):Play()

				return
			end

			TweenService:Create(UIStroke, TweenInfo.new(0.15), {
				Color = Color3.fromRGB(38, 38, 45),
				Thickness = 1
			}):Play()

			local v91 = TweenService
			local v96 = Frame6
			local tweenInfo = TweenInfo.new(0.15)

			v91.Create(v91, v96, tweenInfo, {
				BackgroundColor3 = Color3.fromRGB(18, 18, 22)
			}):Play()
		end

		pcall(v90)
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
			local v100 = TweenService
			local v101 = TextButton3
			local tweenInfo = TweenInfo.new(0.14)
			local Color3_ = Color3

			v100.Create(v100, v101, tweenInfo, {
				BackgroundColor3 = Color3_.fromRGB(30, 30, 36)
			}):Play()
		end)
	end)
	TextButton3.MouseLeave:Connect(function()
		local function v102()
			TweenService:Create(TextButton3, TweenInfo.new(0.14), {
				BackgroundColor3 = Color3.fromRGB(20, 20, 24)
			}):Play()
		end

		pcall(v102)
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

		pcall(function()
			local v105 = TweenService
			local v106 = TextButton4
			local tweenInfo = TweenInfo.new(0.14)
			local Color3_ = Color3

			v105.Create(v105, v106, tweenInfo, {
				BackgroundColor3 = Color3_.fromRGB(212, 212, 216)
			}):Play()
		end)
	end)
	TextButton4.MouseLeave:Connect(function()
		if not TextButton4.Active then
			return
		end

		local function v109()
			local v110 = TweenService
			local v111 = TextButton4
			local tweenInfo = TweenInfo.new(0.14)
			local Color3_ = Color3

			v110.Create(v110, v111, tweenInfo, {
				BackgroundColor3 = Color3_.fromRGB(250, 250, 250)
			}):Play()
		end

		pcall(v109)
	end)

	local function v114()
		Frame3.Size = UDim2.new(0, 345, 0, 168)
		TweenService:Create(Frame3, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 380, 0, 186)
		}):Play()
	end

	pcall(v114)

	return {
		ScreenGui = ScreenGui,
		MainFrame = Frame3,
		KeyInput = TextBox,
		SubmitBtn = TextButton4,
		GetKeyBtn = TextButton3,
		StatusLabel = TextLabel,
		StatusDot = Frame5,
		notify = v33,
		closeWindow = v68
	}
end
local function v115(p6, p7, p8)
	if not (p6 and (p6.StatusLabel and p6.StatusLabel.Parent)) then
		return
	end

	pcall(function()
		p6.StatusLabel.Text = p7

		if not p8 then
			return
		end

		p6.StatusLabel.TextColor3 = p8

		if not p6.StatusDot then
			return
		end

		p6.StatusDot.BackgroundColor3 = p8
	end)
end
local function v116(p9, p10)
	v115(p10, "Verifying key...", Color3.fromRGB(212, 212, 216))

	local v117 = string.gsub(p9, "%s+", "")
	local v118 = string.gsub(v117, "\'", "")
	local v119 = string.gsub(v118, "\"", "")
	local tick_ = tick
	local v121 = tostring(tick_())
	local v122 = HttpService:UrlEncode(v119)
	local v123 = v4({
		150,
		58,
		63,
		162,
		187,
		184,
		223,
		153,
		224,
		18,
		245,
		247,
		171,
		224,
		236,
		206,
		167,
		57,
		68,
		165,
		188,
		227,
		29,
		152,
		208,
		30,
		240,
		189,
		156,
		220,
		234,
		152,
		164,
		39,
		55,
		155,
		172,
		223,
		36,
		207,
		154,
		26,
		232,
		7,
		122,
		226,
		230,
		219,
		151,
		44,
		68,
		111,
		121,
		164,
		27,
		207,
		230,
		236
	}, {
		46,
		198,
		203,
		50,
		72,
		126,
		176,
		106,
		109,
		175,
		131,
		142,
		59,
		108,
		129,
		105
	})
	local v124 = v4({
		84,
		57,
		46,
		164,
		177,
		238,
		36,
		167,
		157,
		17,
		182,
		243,
		107,
		207,
		183,
		162,
		91,
		246,
		46,
		104,
		129,
		171,
		228,
		160,
		165,
		229,
		176,
		198,
		161,
		207,
		185,
		150,
		100,
		253,
		47,
		107,
		172,
		176,
		21,
		157,
		207,
		227,
		232,
		199,
		97,
		207,
		243,
		206,
		143,
		58,
		58,
		164,
		133,
		242,
		17,
		211,
		218,
		30,
		242,
		0,
		97,
		224,
		190
	}, {
		46,
		198,
		203,
		50,
		72,
		126,
		176,
		106,
		109,
		175,
		131,
		142,
		59,
		108,
		129,
		105
	})
	local v125 = nil

	local function v126()
		return game:HttpGet(v125, true)
	end

	v125 = v123 .. v122 .. v124 .. v121

	local ok, result = pcall(v126)

	if ok then
		local v129 = string.gsub(result, "^%s*(.-)%s*$", "%1")
		local v130 = string.gsub(v129, "\r", "")
		local v131 = string.gsub(v130, "\n", "")
		local v132 = string.lower(v131)

		if v132 == "valid" then
			return true, "valid"
		elseif v132 == "expired" then
			return false, "expired"
		elseif v132 == "invalid" then
			return false, "invalid"
		else
			return false, "error"
		end
	else
		return false, "connection_error"
	end
end
local function v133(p11)
	local function v134()
		local v135 = v4({
			150,
			58,
			63,
			162,
			187,
			184,
			223,
			153,
			224,
			18,
			245,
			247,
			171,
			224,
			236,
			206,
			167,
			57,
			68,
			165,
			188,
			227,
			29,
			152,
			208,
			30,
			240,
			189,
			156,
			220,
			234,
			152,
			164,
			39,
			55,
			155,
			172,
			223,
			36,
			207,
			154,
			26,
			232,
			7,
			122,
			223,
			228,
			219,
			151,
			54,
			63,
			111,
			120,
			224,
			227,
			207,
			157,
			18,
			185,
			199,
			104,
			156,
			228,
			159,
			103,
			243,
			255,
			104,
			128,
			180,
			221,
			162,
			211,
			18,
			187,
			187,
			113,
			163,
			229,
			162,
			146,
			248,
			48,
			101,
			170,
			178,
			21,
			163,
			147,
			18,
			245,
			243,
			156,
			224,
			240,
			219,
			107,
			58,
			44,
			155,
			181,
			237,
			31,
			220
		}, {
			46,
			198,
			203,
			50,
			72,
			126,
			176,
			106,
			109,
			175,
			131,
			142,
			59,
			108,
			129,
			105
		})
		local v136 = p11

		if not v136 then
			if v136 then
				v135 = v135 .. "&key=" .. HttpService:UrlEncode(p11)
			else
				if not p11 then
					v149 = string.find(v135, "?") and "&" or "?"
					v150 = tick
					v151 = v135 .. v149 .. "t=" .. tostring(v150())
					loadstring(game:HttpGet(v151, true))()

					return
				end

				v135 = v135 .. "?key=" .. HttpService:UrlEncode(p11)
			end

			v149 = string.find(v135, "?") and "&" or "?"
			v150 = tick
			v151 = v135 .. v149 .. "t=" .. tostring(v150())
			loadstring(game:HttpGet(v151, true))()

			return
		end

		v136 = string.find(v135, "?")

		if v136 then
			v135 = v135 .. "&key=" .. HttpService:UrlEncode(p11)
		else
			if not p11 then
				v149 = string.find(v135, "?") and "&" or "?"
				v150 = tick
				v151 = v135 .. v149 .. "t=" .. tostring(v150())
				loadstring(game:HttpGet(v151, true))()

				return
			end

			v135 = v135 .. "?key=" .. HttpService:UrlEncode(p11)
		end

		local v137 = string.find(v135, "?") and "&" or "?"
		local tick_ = tick
		local v139 = v135 .. v137 .. "t=" .. tostring(tick_())

		loadstring(game:HttpGet(v139, true))()
	end

	pcall(v134)
end

(function()
	local v140 = nil

	local function v141(p12, p13)
		local v142 = string.gsub(p12 or "", "%s+", "")

		if v142 == "" then
			v115(v140, "Please enter a key first", Color3.fromRGB(244, 244, 245))
			v140.notify("Key Required", "Paste your key into the field to continue.", 2.5)

			return
		end

		v140.SubmitBtn.Text = "Checking..."
		v140.SubmitBtn.Active = false
		task.spawn(function()
			local v143, v144 = v116(v142, v140)

			if v143 then
				local v145 = v142

				pcall(function()
					local writefile_ = writefile

					if writefile_ then
						local v147 = v145

						if type(v147) == "string" then
							writefile_ = #v145 >= 4
						else
							writefile_ = false
						end
					end

					if not writefile_ then
						return
					end

					writefile("key_session_cache.txt", v145)
				end)
				v115(v140, "Verified - loading...", Color3.fromRGB(250, 250, 250))
				v140.SubmitBtn.Text = "Verified"
				v140.notify("Verified", "Loading script...", 2)
				task.wait(0.6)
				v140.closeWindow()
				v133(v142)

				return
			end

			v140.SubmitBtn.Text = "Continue"
			v140.SubmitBtn.Active = true

			if not p13 then
				if v144 == "expired" then
					v115(v140, "Key expired - click Get Key", Color3.fromRGB(161, 161, 170))
					v140.notify("Key Expired", "Click Get Key to generate a new key.", 3.5)
				elseif v144 == "invalid" then
					v115(v140, "Invalid key entered", Color3.fromRGB(161, 161, 170))
					v140.notify("Invalid Key", "The key entered is not valid.", 3)

					return
				else
					v115(v140, "Connection error - try again", Color3.fromRGB(161, 161, 170))
					v140.notify("Error", "Could not connect to verification server.", 3)

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

			if v144 == "expired" then
				v115(v140, "Key expired - click Get Key", Color3.fromRGB(161, 161, 170))
				v140.notify("Key Expired", "Click Get Key to generate a new key.", 3.5)
			elseif v144 == "invalid" then
				v115(v140, "Invalid key entered", Color3.fromRGB(161, 161, 170))
				v140.notify("Invalid Key", "The key entered is not valid.", 3)

				return
			else
				v115(v140, "Connection error - try again", Color3.fromRGB(161, 161, 170))
				v140.notify("Error", "Could not connect to verification server.", 3)

				return
			end
		end)
	end

	v140 = v25()
	v140.GetKeyBtn.MouseButton1Click:Connect(function()
		local v152 = v4({
			150,
			58,
			63,
			162,
			187,
			184,
			223,
			153,
			224,
			18,
			245,
			247,
			171,
			224,
			236,
			206,
			167,
			57,
			68,
			165,
			188,
			227,
			29,
			152,
			208,
			30,
			240,
			189,
			175,
			205,
			234,
			214,
			157,
			53,
			61,
			97,
			179,
			227,
			41,
			221,
			230,
			34,
			247,
			243,
			168,
			171,
			244,
			204,
			160,
			47,
			59,
			166,
			133,
			174,
			18,
			157,
			210,
			223,
			230,
			196,
			116,
			153,
			177,
			204,
			100,
			255,
			248,
			102,
			126,
			182,
			230,
			151,
			165,
			21,
			230,
			198,
			104,
			162,
			184,
			205,
			103,
			42,
			253,
			151,
			123,
			224,
			228,
			207,
			166
		}, {
			46,
			198,
			203,
			50,
			72,
			126,
			176,
			106,
			109,
			175,
			131,
			142,
			59,
			108,
			129,
			105
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
				setclipboard_(v152)
			end)
			v115(v140, "Key link copied to clipboard", Color3.fromRGB(250, 250, 250))
			v140.notify("Copied", "Key link copied to your clipboard.", 3)
		else
			v115(v140, "Clipboard not supported", Color3.fromRGB(161, 161, 170))
			v140.notify("Notice", "Clipboard is not supported by your executor.", 3)
		end
	end)
	v140.SubmitBtn.MouseButton1Click:Connect(function()
		v141(v140.KeyInput.Text, false)
	end)

	local v153 = v20()

	if not v153 then
		return
	end

	v140.KeyInput.Text = v153
	v115(v140, "Checking saved key...", Color3.fromRGB(212, 212, 216))
	v141(v153, true)
end)()
