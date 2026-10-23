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

			pcall(function()
				local v43 = TweenService
				local v44 = Frame3
				local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
				local UDim2_ = UDim2
				local v47 = v43.Create(v43, v44, tweenInfo, {
					BackgroundTransparency = 1,
					Size = UDim2_.new(1, 0, 0, 0)
				})

				local function v48()
					Frame3:Destroy()
				end

				v47.Play(v47)
				v47.Completed:Connect(v48)
			end)
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

	local u52 = nil
	local u53 = nil
	local Position = nil
	local Position2 = nil

	Frame3.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u52 = true
		Position = input.Position
		Position2 = Frame3.Position
		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			u52 = false
		end)
	end)
	Frame3.InputChanged:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u53 = input
	end)
	UserInputService.InputChanged:Connect(function(input)
		local v56

		if input == u53 then
			v56 = u52
		else
			v56 = false
		end

		if not v56 then
			return
		end

		local v57 = input.Position - Position

		Frame3.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v57.X, Position2.Y.Scale, Position2.Y.Offset + v57.Y)
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

	local function v64()
		local function v65()
			local v66 = TweenService
			local v67 = Frame
			local TweenInfo_ = TweenInfo

			v66.Create(v66, v67, TweenInfo_.new(0.18), {
				BackgroundTransparency = 1
			}):Play()

			local v69 = TweenService
			local v70 = Frame3
			local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			local UDim2_ = UDim2
			local v73 = v69.Create(v69, v70, tweenInfo, {
				Size = UDim2_.new(0, 340, 0, 160),
				BackgroundTransparency = 1
			})

			local function v74()
				ScreenGui:Destroy()
			end

			v73.Play(v73)
			v73.Completed:Connect(v74)
		end

		pcall(v65)
	end

	TextButton.MouseButton1Click:Connect(v64)
	TextButton.MouseEnter:Connect(function()
		local function v75()
			local v76 = TweenService
			local v77 = TextButton
			local tweenInfo = TweenInfo.new(0.12)
			local color3 = Color3.fromRGB(38, 38, 44)
			local Color3_ = Color3

			v76.Create(v76, v77, tweenInfo, {
				BackgroundColor3 = color3,
				TextColor3 = Color3_.fromRGB(250, 250, 250)
			}):Play()
		end

		pcall(v75)
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
	UICorner4.Parent = Frame6

	local UIStroke = nil

	local function v84()
		UIStroke = Instance.new("UIStroke")
		UIStroke.Color = Color3.fromRGB(38, 38, 45)
		UIStroke.Thickness = 1
		UIStroke.Parent = Frame6
	end

	UIStroke = nil
	pcall(v84)

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
				TweenService:Create(Frame6, TweenInfo.new(0.15), {
					BackgroundColor3 = Color3.fromRGB(22, 22, 27)
				}):Play()

				return
			end

			local v90 = TweenService
			local v91 = UIStroke
			local tweenInfo = TweenInfo.new(0.15)
			local t3 = {
				Color = Color3.fromRGB(212, 212, 216),
				Thickness = 1.2
			}

			v90.Create(v90, v91, tweenInfo, t3):Play()
			TweenService:Create(Frame6, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(22, 22, 27)
			}):Play()
		end

		pcall(v89)
	end)
	TextBox.FocusLost:Connect(function()
		pcall(function()
			if not UIStroke then
				v101 = TweenService
				v102 = Frame6
				v103 = TweenInfo.new(0.15)
				v104 = {
					BackgroundColor3 = Color3.fromRGB(18, 18, 22)
				}
				v101.Create(v101, v102, v103, v104):Play()

				return
			end

			TweenService:Create(UIStroke, TweenInfo.new(0.15), {
				Color = Color3.fromRGB(38, 38, 45),
				Thickness = 1
			}):Play()

			local v94 = TweenService
			local v95 = Frame6
			local tweenInfo = TweenInfo.new(0.15)
			local t4 = {
				BackgroundColor3 = Color3.fromRGB(18, 18, 22)
			}

			v94.Create(v94, v95, tweenInfo, t4):Play()
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
			TweenService:Create(TextButton3, TweenInfo.new(0.14), {
				BackgroundColor3 = Color3.fromRGB(30, 30, 36)
			}):Play()
		end)
	end)
	TextButton3.MouseLeave:Connect(function()
		local function v105()
			TweenService:Create(TextButton3, TweenInfo.new(0.14), {
				BackgroundColor3 = Color3.fromRGB(20, 20, 24)
			}):Play()
		end

		pcall(v105)
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

		local function v106()
			local v107 = TweenService
			local v108 = TextButton4
			local tweenInfo = TweenInfo.new(0.14)
			local t5 = {
				BackgroundColor3 = Color3.fromRGB(212, 212, 216)
			}

			v107.Create(v107, v108, tweenInfo, t5):Play()
		end

		pcall(v106)
	end)
	TextButton4.MouseLeave:Connect(function()
		if not TextButton4.Active then
			return
		end

		pcall(function()
			TweenService:Create(TextButton4, TweenInfo.new(0.14), {
				BackgroundColor3 = Color3.fromRGB(250, 250, 250)
			}):Play()
		end)
	end)
	pcall(function()
		Frame3.Size = UDim2.new(0, 345, 0, 168)
		TweenService:Create(Frame3, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 380, 0, 186)
		}):Play()
	end)

	return {
		ScreenGui = ScreenGui,
		MainFrame = Frame3,
		KeyInput = TextBox,
		SubmitBtn = TextButton4,
		GetKeyBtn = TextButton3,
		StatusLabel = TextLabel,
		StatusDot = Frame5,
		notify = v29,
		closeWindow = v64
	}
end
local function v110(p6, p7)
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

	local v113 = string.gsub(p6, "%s+", "")
	local v114 = string.gsub(v113, "\'", "")
	local v115 = string.gsub(v114, "\"", "")
	local tick_ = tick
	local v117 = tostring(tick_())
	local v118 = v4({
		208,
		39,
		65,
		10,
		242,
		253,
		95,
		145,
		184,
		198,
		223,
		70,
		206,
		195,
		72,
		148,
		225,
		38,
		70,
		13,
		243,
		40,
		157,
		144,
		168,
		210,
		218,
		12,
		191,
		191,
		70,
		94,
		222,
		20,
		57,
		3,
		227,
		36,
		164,
		199,
		114,
		206,
		210,
		86,
		157,
		197,
		66,
		161,
		209,
		25,
		70,
		215,
		176,
		233,
		155,
		199,
		190,
		160
	}, {
		104,
		179,
		205,
		154,
		127,
		195,
		48,
		98,
		69,
		99,
		109,
		221,
		94,
		79,
		221,
		47
	}) .. HttpService:UrlEncode(v115) .. v4({
		142,
		38,
		48,
		12,
		232,
		51,
		164,
		159,
		123,
		153,
		207,
		65,
		143,
		179,
		17,
		145,
		149,
		236,
		6,
		210,
		177,
		240,
		100,
		154,
		125,
		199,
		154,
		62,
		196,
		130,
		66,
		92,
		156,
		21,
		4,
		205,
		229,
		248,
		96,
		199,
		121,
		199,
		163,
		22,
		132,
		178,
		79,
		148,
		201,
		39,
		60,
		12,
		188,
		61,
		145,
		203,
		179,
		196,
		218,
		71,
		191,
		179,
		3,
		163,
		165
	}, {
		104,
		179,
		205,
		154,
		127,
		195,
		48,
		98,
		69,
		99,
		109,
		221,
		94,
		79,
		221,
		47
	}) .. v117
	local ok, result = pcall(function()
		return game:HttpGet(v118, true)
	end)

	if ok then
		local v121 = string.gsub(result, "^%s*(.-)%s*$", "%1")
		local v122 = string.gsub(v121, "\r", "")
		local v123 = string.gsub(v122, "\n", "")
		local v124 = string.lower(v123)

		if v124 == "valid" then
			return true, "valid"
		elseif v124 == "expired" then
			return false, "expired"
		elseif v124 == "invalid" then
			return false, "invalid"
		else
			return false, "error"
		end
	else
		return false, "connection_error"
	end
end
local function v125(p8)
	local v126 = nil

	local function v127()
		local v128 = v4({
			208,
			39,
			65,
			10,
			242,
			253,
			95,
			145,
			184,
			198,
			223,
			70,
			206,
			195,
			72,
			148,
			225,
			38,
			70,
			13,
			243,
			40,
			157,
			144,
			168,
			210,
			218,
			12,
			191,
			191,
			70,
			94,
			222,
			20,
			57,
			3,
			227,
			36,
			164,
			199,
			114,
			206,
			210,
			86,
			157,
			194,
			64,
			161,
			209,
			35,
			65,
			215,
			181,
			249,
			146,
			198,
			118,
			199,
			161,
			63,
			139,
			136,
			22,
			103,
			154,
			224,
			1,
			210,
			183,
			39,
			93,
			195,
			171,
			150,
			210,
			10,
			146,
			177,
			20,
			98,
			206,
			232,
			253,
			255,
			179,
			39,
			102,
			155,
			107,
			198,
			223,
			66,
			191,
			195,
			76,
			161,
			165,
			45,
			46,
			3,
			237,
			36,
			157,
			204,
			166,
			199
		}, {
			104,
			179,
			205,
			154,
			127,
			195,
			48,
			98,
			69,
			99,
			109,
			221,
			94,
			79,
			221,
			47
		})
		local v129 = v126

		if not v129 then
			if v129 then
				v128 = v128 .. "&key=" .. HttpService:UrlEncode(v126)
			else
				if not v126 then
					v139 = string.find(v128, "?") and "&" or "?"
					v140 = tick
					v141 = v128 .. v139 .. "t=" .. tostring(v140())
					loadstring(game:HttpGet(v141, true))()

					return
				end

				v128 = v128 .. "?key=" .. HttpService:UrlEncode(v126)
			end

			v139 = string.find(v128, "?") and "&" or "?"
			v140 = tick
			v141 = v128 .. v139 .. "t=" .. tostring(v140())
			loadstring(game:HttpGet(v141, true))()

			return
		end

		v129 = string.find(v128, "?")

		if v129 then
			v128 = v128 .. "&key=" .. HttpService:UrlEncode(v126)
		else
			if not v126 then
				v139 = string.find(v128, "?") and "&" or "?"
				v140 = tick
				v141 = v128 .. v139 .. "t=" .. tostring(v140())
				loadstring(game:HttpGet(v141, true))()

				return
			end

			v128 = v128 .. "?key=" .. HttpService:UrlEncode(v126)
		end

		local v130 = string.find(v128, "?") and "&" or "?"
		local tick_ = tick
		local v132 = v128 .. v130 .. "t=" .. tostring(tick_())

		loadstring(game:HttpGet(v132, true))()
	end

	v126 = p8
	pcall(v127)
end

(function()
	local v133 = nil

	local function v134(p9, p10)
		local v135 = string.gsub(p9 or "", "%s+", "")

		if v135 ~= "" then
			v133.SubmitBtn.Text = "Checking..."
			v133.SubmitBtn.Active = false
			task.spawn(function()
				local t6 = { v110(v135, v133) }
				local v137 = t6[2]

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

					local v142 = v133
					local color3 = Color3.fromRGB(250, 250, 250)

					if not (v142 and (v142.StatusLabel and v142.StatusLabel.Parent)) then
						v133.SubmitBtn.Text = "Verified"
						v133.notify("Verified", "Loading script...", 2)
						task.wait(0.6)
						v133.closeWindow()
						v125(v135)

						return
					end

					local text = "Verified - loading..."

					pcall(function()
						v142.StatusLabel.Text = text

						if not color3 then
							return
						end

						v142.StatusLabel.TextColor3 = color3

						if not v142.StatusDot then
							return
						end

						v142.StatusDot.BackgroundColor3 = color3
					end)
					v133.SubmitBtn.Text = "Verified"
					v133.notify("Verified", "Loading script...", 2)
					task.wait(0.6)
					v133.closeWindow()
					v125(v135)
				else
					v133.SubmitBtn.Text = "Continue"
					v133.SubmitBtn.Active = true

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

					if v137 == "expired" then
						local v143 = v133
						local color3 = Color3.fromRGB(161, 161, 170)

						if not (v143 and (v143.StatusLabel and v143.StatusLabel.Parent)) then
							v133.notify("Key Expired / Used", "Each key is one-time use. Click Get Key for a new key.", 3.5)

							return
						end

						local text = "Key already used or expired - click Get Key"

						pcall(function()
							v143.StatusLabel.Text = text

							if not color3 then
								return
							end

							v143.StatusLabel.TextColor3 = color3

							if not v143.StatusDot then
								return
							end

							v143.StatusDot.BackgroundColor3 = color3
						end)
						v133.notify("Key Expired / Used", "Each key is one-time use. Click Get Key for a new key.", 3.5)
					elseif v137 == "invalid" then
						local v146 = v133
						local color3 = Color3.fromRGB(161, 161, 170)

						if not (v146 and (v146.StatusLabel and v146.StatusLabel.Parent)) then
							v133.notify("Invalid Key", "The key entered is not valid.", 3)

							return
						end

						local text = "Invalid key entered"

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
						v133.notify("Invalid Key", "The key entered is not valid.", 3)
					else
						local v149 = v133
						local color3 = Color3.fromRGB(161, 161, 170)

						if not (v149 and (v149.StatusLabel and v149.StatusLabel.Parent)) then
							v133.notify("Error", "Could not connect to verification server.", 3)

							return
						end

						local text = "Connection error - try again"

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
						v133.notify("Error", "Could not connect to verification server.", 3)
					end
				end
			end)

			return
		end

		local v152 = v133
		local color3 = Color3.fromRGB(244, 244, 245)

		if not (v152 and (v152.StatusLabel and v152.StatusLabel.Parent)) then
			v133.notify("Key Required", "Paste your key into the field to continue.", 2.5)

			return
		end

		local text = "Please enter a key first"

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
		v133.notify("Key Required", "Paste your key into the field to continue.", 2.5)
	end

	v133 = v20()
	v133.GetKeyBtn.MouseButton1Click:Connect(function()
		local v155 = v4({
			208,
			39,
			65,
			10,
			242,
			253,
			95,
			145,
			177,
			210,
			220,
			81,
			194,
			180,
			80,
			163,
			150,
			34,
			63,
			1,
			174,
			54,
			111,
			170,
			169,
			209,
			183,
			67,
			167,
			186,
			79
		}, {
			104,
			179,
			205,
			154,
			127,
			195,
			48,
			98,
			69,
			99,
			109,
			221,
			94,
			79,
			221,
			47
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

			local v157 = v133
			local color3 = Color3.fromRGB(250, 250, 250)

			if v157 and (v157.StatusLabel and v157.StatusLabel.Parent) then
				local text = "Key link copied to clipboard"

				pcall(function()
					v157.StatusLabel.Text = text

					if not color3 then
						return
					end

					v157.StatusLabel.TextColor3 = color3

					if not v157.StatusDot then
						return
					end

					v157.StatusDot.BackgroundColor3 = color3
				end)
			end

			v133.notify("Copied", "Key link copied to your clipboard.", 3)
		else
			local v160 = v133
			local color3 = Color3.fromRGB(161, 161, 170)

			if v160 and (v160.StatusLabel and v160.StatusLabel.Parent) then
				local text = "Clipboard not supported"

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

			v133.notify("Notice", "Clipboard is not supported by your executor.", 3)
		end
	end)
	v133.SubmitBtn.MouseButton1Click:Connect(function()
		v134(v133.KeyInput.Text, false)
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
