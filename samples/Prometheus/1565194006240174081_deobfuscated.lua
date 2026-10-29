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

	local function v26()
		TweenService:Create(Frame, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0.5
		}):Play()
	end

	pcall(v26)

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

	local function v29(p3, p4, p5)
		local v30 = p5 or 3
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
		pcall(function()
			local v37 = TweenService
			local v38 = Frame4
			local tweenInfo = TweenInfo.new(v30, Enum.EasingStyle.Linear)
			local t2 = {
				Size = UDim2.new(0, 0, 0, 2)
			}

			v37.Create(v37, v38, tweenInfo, t2):Play()
		end)

		local function v41()
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

				local function v45()
					Frame3:Destroy()
				end

				tween.Completed:Connect(v45)
			end

			pcall(v43)
		end

		task.delay(v30, v41)
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

	local u49 = nil
	local u50 = nil
	local Position = nil
	local Position2 = nil

	Frame3.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u49 = true
		Position = input.Position
		Position2 = Frame3.Position
		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			u49 = false
		end)
	end)
	Frame3.InputChanged:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u50 = input
	end)
	UserInputService.InputChanged:Connect(function(input)
		local v53

		if input == u50 then
			v53 = u49
		else
			v53 = false
		end

		if not v53 then
			return
		end

		local v54 = input.Position - Position

		Frame3.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v54.X, Position2.Y.Scale, Position2.Y.Offset + v54.Y)
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

	local function v61()
		local function v62()
			local v63 = TweenService
			local v64 = Frame
			local tweenInfo = TweenInfo.new(0.18)

			v63.Create(v63, v64, tweenInfo, {
				BackgroundTransparency = 1
			}):Play()

			local v66 = TweenService
			local v67 = Frame3
			local tweenInfo2 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			local UDim2_ = UDim2
			local v70 = v66.Create(v66, v67, tweenInfo2, {
				Size = UDim2_.new(0, 340, 0, 160),
				BackgroundTransparency = 1
			})

			local function v71()
				ScreenGui:Destroy()
			end

			v70.Play(v70)
			v70.Completed:Connect(v71)
		end

		pcall(v62)
	end

	TextButton.MouseButton1Click:Connect(v61)
	TextButton.MouseEnter:Connect(function()
		local function v72()
			TweenService:Create(TextButton, TweenInfo.new(0.12), {
				BackgroundColor3 = Color3.fromRGB(38, 38, 44),
				TextColor3 = Color3.fromRGB(250, 250, 250)
			}):Play()
		end

		pcall(v72)
	end)
	TextButton.MouseLeave:Connect(function()
		local function v73()
			TweenService:Create(TextButton, TweenInfo.new(0.12), {
				BackgroundColor3 = Color3.fromRGB(22, 22, 26),
				TextColor3 = Color3.fromRGB(140, 140, 150)
			}):Play()
		end

		pcall(v73)
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

	local function v77()
		UIStroke = Instance.new("UIStroke")
		UIStroke.Color = Color3.fromRGB(38, 38, 45)
		UIStroke.Thickness = 1
		UIStroke.Parent = Frame6
	end

	UICorner4.Parent = Frame6
	UIStroke = nil
	pcall(v77)

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
		pcall(function()
			if not UIStroke then
				v92 = TweenService
				v93 = Frame6
				v94 = TweenInfo.new(0.15)
				v95 = {
					BackgroundColor3 = Color3.fromRGB(22, 22, 27)
				}
				v92.Create(v92, v93, v94, v95):Play()

				return
			end

			local v82 = TweenService
			local v83 = UIStroke
			local tweenInfo = TweenInfo.new(0.15)

			v82.Create(v82, v83, tweenInfo, {
				Color = Color3.fromRGB(212, 212, 216),
				Thickness = 1.2
			}):Play()

			local v85 = TweenService
			local v86 = Frame6
			local tweenInfo2 = TweenInfo.new(0.15)
			local t3 = {
				BackgroundColor3 = Color3.fromRGB(22, 22, 27)
			}

			v85.Create(v85, v86, tweenInfo2, t3):Play()
		end)
	end)
	TextBox.FocusLost:Connect(function()
		local function v89()
			if not UIStroke then
				v99 = TweenService
				v100 = Frame6
				v101 = TweenInfo.new(0.15)
				v102 = {
					BackgroundColor3 = Color3.fromRGB(18, 18, 22)
				}
				v99.Create(v99, v100, v101, v102):Play()

				return
			end

			local v90 = TweenService
			local v91 = UIStroke
			local TweenInfo_ = TweenInfo

			v90.Create(v90, v91, TweenInfo_.new(0.15), {
				Color = Color3.fromRGB(38, 38, 45),
				Thickness = 1
			}):Play()

			local v96 = TweenService
			local v97 = Frame6
			local tweenInfo = TweenInfo.new(0.15)
			local t4 = {
				BackgroundColor3 = Color3.fromRGB(18, 18, 22)
			}

			v96.Create(v96, v97, tweenInfo, t4):Play()
		end

		pcall(v89)
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
		local function v103()
			TweenService:Create(TextButton3, TweenInfo.new(0.14), {
				BackgroundColor3 = Color3.fromRGB(30, 30, 36)
			}):Play()
		end

		pcall(v103)
	end)
	TextButton3.MouseLeave:Connect(function()
		local function v104()
			local v105 = TweenService
			local v106 = TextButton3
			local tweenInfo = TweenInfo.new(0.14)
			local Color3_ = Color3

			v105.Create(v105, v106, tweenInfo, {
				BackgroundColor3 = Color3_.fromRGB(20, 20, 24)
			}):Play()
		end

		pcall(v104)
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
			local v109 = TweenService
			local v110 = TextButton4
			local tweenInfo = TweenInfo.new(0.14)
			local t5 = {
				BackgroundColor3 = Color3.fromRGB(212, 212, 216)
			}

			v109.Create(v109, v110, tweenInfo, t5):Play()
		end)
	end)
	TextButton4.MouseLeave:Connect(function()
		if not TextButton4.Active then
			return
		end

		local function v113()
			local v114 = TweenService
			local v115 = TextButton4
			local TweenInfo_ = TweenInfo

			v114.Create(v114, v115, TweenInfo_.new(0.14), {
				BackgroundColor3 = Color3.fromRGB(250, 250, 250)
			}):Play()
		end

		pcall(v113)
	end)

	local function v117()
		Frame3.Size = UDim2.new(0, 345, 0, 168)
		TweenService:Create(Frame3, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 380, 0, 186)
		}):Play()
	end

	pcall(v117)

	return {
		ScreenGui = ScreenGui,
		MainFrame = Frame3,
		KeyInput = TextBox,
		SubmitBtn = TextButton4,
		GetKeyBtn = TextButton3,
		StatusLabel = TextLabel,
		StatusDot = Frame5,
		notify = v29,
		closeWindow = v61
	}
end
local function v118(p6, p7)
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

	local v121 = string.gsub(p6, "%s+", "")
	local v122 = string.gsub(v121, "\'", "")
	local v123 = string.gsub(v122, "\"", "")
	local tick_ = tick
	local v125 = tostring(tick_())
	local v126 = HttpService
	local v127 = v126.UrlEncode(v126, v123)
	local v128 = v4({
		222,
		59,
		203,
		248,
		236,
		22,
		94,
		251,
		21,
		152,
		235,
		58,
		241,
		50,
		193,
		140,
		239,
		58,
		208,
		251,
		237,
		65,
		156,
		250,
		5,
		164,
		230,
		0,
		226,
		46,
		191,
		86,
		236,
		40,
		195,
		241,
		221,
		61,
		163,
		49,
		207,
		160,
		222,
		74,
		192,
		52,
		187,
		153,
		223,
		45,
		208,
		197,
		170,
		2,
		154,
		49,
		27,
		114
	}, {
		118,
		199,
		87,
		136,
		121,
		220,
		47,
		204,
		162,
		53,
		121,
		209,
		129,
		190,
		86,
		39
	})
	local v129 = v4({
		156,
		58,
		186,
		250,
		226,
		76,
		163,
		9,
		8,
		101,
		220,
		53,
		228,
		35,
		135,
		139,
		163,
		249,
		135,
		193,
		170,
		9,
		99,
		48,
		215,
		154,
		166,
		9,
		227,
		31,
		141,
		84,
		167,
		40,
		144,
		233,
		178,
		13,
		103,
		46,
		216,
		104,
		173,
		50,
		167,
		33,
		200,
		140,
		215,
		59,
		198,
		250,
		182,
		80,
		144,
		53,
		15,
		164,
		232,
		67,
		167,
		50,
		147
	}, {
		118,
		199,
		87,
		136,
		121,
		220,
		47,
		204,
		162,
		53,
		121,
		209,
		129,
		190,
		86,
		39
	})
	local v130 = nil

	local function v131()
		return game:HttpGet(v130, true)
	end

	v130 = v128 .. v127 .. v129 .. v125

	local ok, result = pcall(v131)

	if ok then
		local v134 = string.gsub(result, "^%s*(.-)%s*$", "%1")
		local v135 = string.gsub(v134, "\r", "")
		local v136 = string.gsub(v135, "\n", "")
		local v137 = string.lower(v136)

		if v137 == "valid" then
			return true, "valid"
		elseif v137 == "expired" then
			return false, "expired"
		elseif v137 == "invalid" then
			return false, "invalid"
		else
			return false, "error"
		end
	else
		return false, "connection_error"
	end
end
local function v138(p8)
	local v139 = nil

	local function v140()
		local v141 = v4({
			222,
			59,
			203,
			248,
			236,
			22,
			94,
			251,
			21,
			152,
			235,
			58,
			241,
			50,
			193,
			140,
			239,
			58,
			208,
			251,
			237,
			65,
			156,
			250,
			5,
			164,
			230,
			0,
			226,
			46,
			191,
			86,
			236,
			40,
			195,
			241,
			221,
			61,
			163,
			49,
			207,
			160,
			222,
			74,
			192,
			49,
			185,
			153,
			223,
			55,
			203,
			197,
			223,
			12,
			146,
			48,
			5,
			154,
			170,
			53,
			174,
			240,
			134,
			96,
			167,
			244,
			139,
			236,
			174,
			65,
			92,
			4,
			4,
			150,
			176,
			254,
			178,
			31,
			143,
			136,
			175,
			248,
			143,
			234,
			175,
			15,
			99,
			45,
			200,
			152,
			235,
			54,
			226,
			50,
			197,
			153,
			179,
			59,
			184,
			241,
			230,
			75,
			158,
			62
		}, {
			118,
			199,
			87,
			136,
			121,
			220,
			47,
			204,
			162,
			53,
			121,
			209,
			129,
			190,
			86,
			39
		})
		local v142 = v139

		if not v142 then
			if v142 then
				v141 = v141 .. "&key=" .. HttpService:UrlEncode(v139)
			else
				if not v139 then
					v152 = string.find(v141, "?") and "&" or "?"
					v153 = tick
					v154 = v141 .. v152 .. "t=" .. tostring(v153())
					loadstring(game:HttpGet(v154, true))()

					return
				end

				v141 = v141 .. "?key=" .. HttpService:UrlEncode(v139)
			end

			v152 = string.find(v141, "?") and "&" or "?"
			v153 = tick
			v154 = v141 .. v152 .. "t=" .. tostring(v153())
			loadstring(game:HttpGet(v154, true))()

			return
		end

		v142 = string.find(v141, "?")

		if v142 then
			v141 = v141 .. "&key=" .. HttpService:UrlEncode(v139)
		else
			if not v139 then
				v152 = string.find(v141, "?") and "&" or "?"
				v153 = tick
				v154 = v141 .. v152 .. "t=" .. tostring(v153())
				loadstring(game:HttpGet(v154, true))()

				return
			end

			v141 = v141 .. "?key=" .. HttpService:UrlEncode(v139)
		end

		local v143 = string.find(v141, "?") and "&" or "?"
		local tick_ = tick
		local v145 = v141 .. v143 .. "t=" .. tostring(tick_())

		loadstring(game:HttpGet(v145, true))()
	end

	v139 = p8
	pcall(v140)
end

(function()
	local v146 = v20()

	local function v147(p9, p10)
		local v148 = string.gsub(p9 or "", "%s+", "")

		if v148 ~= "" then
			v146.SubmitBtn.Text = "Checking..."
			v146.SubmitBtn.Active = false
			task.spawn(function()
				local t6 = { v118(v148, v146) }
				local v150 = t6[2]

				if t6[1] then
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

					local v155 = v146
					local color3 = Color3.fromRGB(250, 250, 250)

					if not (v155 and (v155.StatusLabel and v155.StatusLabel.Parent)) then
						v146.SubmitBtn.Text = "Verified"
						v146.notify("Verified", "Loading script...", 2)
						task.wait(0.6)
						v146.closeWindow()
						v138(v148)

						return
					end

					local text = "Verified - loading..."

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
					v146.SubmitBtn.Text = "Verified"
					v146.notify("Verified", "Loading script...", 2)
					task.wait(0.6)
					v146.closeWindow()
					v138(v148)
				else
					v146.SubmitBtn.Text = "Continue"
					v146.SubmitBtn.Active = true

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

					if v150 == "expired" then
						local v156 = v146
						local color3 = Color3.fromRGB(161, 161, 170)

						if not (v156 and (v156.StatusLabel and v156.StatusLabel.Parent)) then
							v146.notify("Key Expired / Used", "Each key is one-time use. Click Get Key for a new key.", 3.5)

							return
						end

						local text = "Key already used or expired - click Get Key"

						pcall(function()
							v156.StatusLabel.Text = text

							if not color3 then
								return
							end

							v156.StatusLabel.TextColor3 = color3

							if not v156.StatusDot then
								return
							end

							v156.StatusDot.BackgroundColor3 = color3
						end)
						v146.notify("Key Expired / Used", "Each key is one-time use. Click Get Key for a new key.", 3.5)
					elseif v150 == "invalid" then
						local v159 = v146
						local color3 = Color3.fromRGB(161, 161, 170)

						if not (v159 and (v159.StatusLabel and v159.StatusLabel.Parent)) then
							v146.notify("Invalid Key", "The key entered is not valid.", 3)

							return
						end

						local text = "Invalid key entered"

						pcall(function()
							v159.StatusLabel.Text = text

							if not color3 then
								return
							end

							v159.StatusLabel.TextColor3 = color3

							if not v159.StatusDot then
								return
							end

							v159.StatusDot.BackgroundColor3 = color3
						end)
						v146.notify("Invalid Key", "The key entered is not valid.", 3)
					else
						local v162 = v146
						local color3 = Color3.fromRGB(161, 161, 170)

						if not (v162 and (v162.StatusLabel and v162.StatusLabel.Parent)) then
							v146.notify("Error", "Could not connect to verification server.", 3)

							return
						end

						local text = "Connection error - try again"

						pcall(function()
							v162.StatusLabel.Text = text

							if not color3 then
								return
							end

							v162.StatusLabel.TextColor3 = color3

							if not v162.StatusDot then
								return
							end

							v162.StatusDot.BackgroundColor3 = color3
						end)
						v146.notify("Error", "Could not connect to verification server.", 3)
					end
				end
			end)

			return
		end

		local v165 = v146
		local color3 = Color3.fromRGB(244, 244, 245)

		if not (v165 and (v165.StatusLabel and v165.StatusLabel.Parent)) then
			v146.notify("Key Required", "Paste your key into the field to continue.", 2.5)

			return
		end

		local text = "Please enter a key first"

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
		v146.notify("Key Required", "Paste your key into the field to continue.", 2.5)
	end

	v146.GetKeyBtn.MouseButton1Click:Connect(function()
		local v168 = v4({
			222,
			59,
			203,
			248,
			236,
			22,
			94,
			251,
			14,
			164,
			232,
			69,
			229,
			35,
			201,
			155,
			164,
			54,
			201,
			239,
			168,
			79,
			110,
			14,
			227,
			159,
			239,
			67,
			229,
			46,
			196
		}, {
			118,
			199,
			87,
			136,
			121,
			220,
			47,
			204,
			162,
			53,
			121,
			209,
			129,
			190,
			86,
			39
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
				setclipboard_(v168)
			end)

			local v170 = v146
			local color3 = Color3.fromRGB(250, 250, 250)

			if v170 and (v170.StatusLabel and v170.StatusLabel.Parent) then
				local text = "Key link copied to clipboard"

				pcall(function()
					v170.StatusLabel.Text = text

					if not color3 then
						return
					end

					v170.StatusLabel.TextColor3 = color3

					if not v170.StatusDot then
						return
					end

					v170.StatusDot.BackgroundColor3 = color3
				end)
			end

			v146.notify("Copied", "Key link copied to your clipboard.", 3)
		else
			local v173 = v146
			local color3 = Color3.fromRGB(161, 161, 170)

			if v173 and (v173.StatusLabel and v173.StatusLabel.Parent) then
				local text = "Clipboard not supported"

				pcall(function()
					v173.StatusLabel.Text = text

					if not color3 then
						return
					end

					v173.StatusLabel.TextColor3 = color3

					if not v173.StatusDot then
						return
					end

					v173.StatusDot.BackgroundColor3 = color3
				end)
			end

			v146.notify("Notice", "Clipboard is not supported by your executor.", 3)
		end
	end)
	v146.SubmitBtn.MouseButton1Click:Connect(function()
		v147(v146.KeyInput.Text, false)
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
