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
local function v39()
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

	local function v47(p7, p8, p9)
		local v48 = p9 or 3
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

		local function v55()
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

				local function v58()
					Frame3:Destroy()
				end

				tween.Play(tween)
				tween.Completed:Connect(v58)
			end)
		end
		local function v59()
			local v60 = TweenService
			local v61 = Frame4
			local tweenInfo = TweenInfo.new(v48, Enum.EasingStyle.Linear)
			local t3 = {
				Size = UDim2.new(0, 0, 0, 2)
			}

			v60.Create(v60, v61, tweenInfo, t3):Play()
		end

		pcall(v59)
		task.delay(v48, v55)
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

	local u67 = nil
	local u68 = nil
	local Position = nil
	local Position2 = nil

	Frame3.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u67 = true
		Position = input.Position
		Position2 = Frame3.Position
		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			u67 = false
		end)
	end)
	Frame3.InputChanged:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u68 = input
	end)
	UserInputService.InputChanged:Connect(function(input)
		local v71

		if input == u68 then
			v71 = u67
		else
			v71 = false
		end

		if not v71 then
			return
		end

		local v72 = input.Position - Position

		Frame3.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v72.X, Position2.Y.Scale, Position2.Y.Offset + v72.Y)
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

	local function v79()
		local function v80()
			TweenService:Create(Frame, TweenInfo.new(0.18), {
				BackgroundTransparency = 1
			}):Play()

			local tween = TweenService:Create(Frame3, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 340, 0, 160),
				BackgroundTransparency = 1
			})

			local function v82()
				ScreenGui:Destroy()
			end

			tween:Play()
			tween.Completed:Connect(v82)
		end

		pcall(v80)
	end

	TextButton.MouseButton1Click:Connect(v79)
	TextButton.MouseEnter:Connect(function()
		pcall(function()
			local v83 = TweenService
			local v84 = TextButton
			local TweenInfo_ = TweenInfo

			v83.Create(v83, v84, TweenInfo_.new(0.12), {
				BackgroundColor3 = Color3.fromRGB(38, 38, 44),
				TextColor3 = Color3.fromRGB(250, 250, 250)
			}):Play()
		end)
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

	local function v94()
		TextBox.Text = ""
		v37()
		TextLabel.Text = "Input cleared"
		TextLabel.TextColor3 = Color3.fromRGB(161, 161, 170)
	end

	UICorner5.Parent = TextButton2
	TextButton2.MouseButton1Click:Connect(v94)
	TextBox.Focused:Connect(function()
		pcall(function()
			if not UIStroke then
				v109 = TweenService
				v110 = Frame6
				v111 = TweenInfo
				v109.Create(v109, v110, v111.new(0.15), {
					BackgroundColor3 = Color3.fromRGB(22, 22, 27)
				}):Play()

				return
			end

			local v95 = TweenService
			local v96 = UIStroke
			local tweenInfoNew = TweenInfo.new

			v95.Create(v95, v96, tweenInfoNew(0.15), {
				Color = Color3.fromRGB(212, 212, 216),
				Thickness = 1.2
			}):Play()

			local v98 = TweenService
			local v99 = Frame6
			local TweenInfo_ = TweenInfo

			v98.Create(v98, v99, TweenInfo_.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(22, 22, 27)
			}):Play()
		end)
	end)
	TextBox.FocusLost:Connect(function()
		local function v101()
			if not UIStroke then
				v115 = TweenService
				v116 = Frame6
				v117 = TweenInfo.new(0.15)
				v118 = {
					BackgroundColor3 = Color3.fromRGB(18, 18, 22)
				}
				v115.Create(v115, v116, v117, v118):Play()

				return
			end

			local v102 = TweenService
			local v103 = UIStroke
			local tweenInfoNew = TweenInfo.new

			v102.Create(v102, v103, tweenInfoNew(0.15), {
				Color = Color3.fromRGB(38, 38, 45),
				Thickness = 1
			}):Play()

			local v105 = TweenService
			local v106 = Frame6
			local tweenInfo = TweenInfo.new(0.15)
			local t4 = {
				BackgroundColor3 = Color3.fromRGB(18, 18, 22)
			}

			v105.Create(v105, v106, tweenInfo, t4):Play()
		end

		pcall(v101)
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
			local v114 = TweenService
			local v119 = TextButton3
			local tweenInfo = TweenInfo.new(0.14)
			local t5 = {
				BackgroundColor3 = Color3.fromRGB(30, 30, 36)
			}

			v114.Create(v114, v119, tweenInfo, t5):Play()
		end

		pcall(v113)
	end)
	TextButton3.MouseLeave:Connect(function()
		pcall(function()
			local v120 = TweenService
			local v121 = TextButton3
			local tweenInfo = TweenInfo.new(0.14)
			local t6 = {
				BackgroundColor3 = Color3.fromRGB(20, 20, 24)
			}

			v120.Create(v120, v121, tweenInfo, t6):Play()
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

		local function v124()
			local v125 = TweenService
			local v126 = TextButton4
			local TweenInfo_ = TweenInfo

			v125.Create(v125, v126, TweenInfo_.new(0.14), {
				BackgroundColor3 = Color3.fromRGB(212, 212, 216)
			}):Play()
		end

		pcall(v124)
	end)
	TextButton4.MouseLeave:Connect(function()
		if not TextButton4.Active then
			return
		end

		local function v128()
			local v129 = TweenService
			local v130 = TextButton4
			local TweenInfo_ = TweenInfo

			v129.Create(v129, v130, TweenInfo_.new(0.14), {
				BackgroundColor3 = Color3.fromRGB(250, 250, 250)
			}):Play()
		end

		pcall(v128)
	end)

	local function v132()
		Frame3.Size = UDim2.new(0, 345, 0, 168)

		local v133 = TweenService
		local v134 = Frame3
		local tweenInfoNew = TweenInfo.new
		local EasingStyle = Enum.EasingStyle

		v133.Create(v133, v134, tweenInfoNew(0.28, EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 380, 0, 186)
		}):Play()
	end

	pcall(v132)

	return {
		ScreenGui = ScreenGui,
		MainFrame = Frame3,
		KeyInput = TextBox,
		SubmitBtn = TextButton4,
		GetKeyBtn = TextButton3,
		StatusLabel = TextLabel,
		StatusDot = Frame5,
		notify = v47,
		closeWindow = v79
	}
end
local function v137(p10, p11, p12)
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
local function v138(p13, p14)
	v137(p14, "Verifying key...", Color3.fromRGB(212, 212, 216))

	local v139 = string.gsub(p13, "%s+", "")
	local v140 = string.gsub(v139, "\'", "")
	local v141 = string.gsub(v140, "\"", "")
	local v142 = v12(v141)

	if not v142 then
		return false, "invalid"
	end

	local v143 = v8({
		160,
		31,
		235,
		57,
		55,
		170,
		253,
		22,
		84,
		89,
		116,
		188,
		58,
		50,
		176,
		117,
		118,
		123,
		206,
		1,
		149,
		179,
		0,
		114,
		34,
		42,
		204,
		96,
		240,
		139,
		140,
		4,
		208,
		71,
		134,
		84,
		99,
		116,
		100,
		135,
		177,
		131,
		162,
		111,
		43,
		111,
		77,
		164,
		161,
		17,
		240,
		6,
		245,
		150,
		57,
		76,
		90,
		51
	}, {
		190,
		108,
		219,
		79,
		133,
		212,
		84,
		168,
		69,
		124,
		195,
		183,
		80,
		127,
		169,
		150
	}, v142)

	if string.sub(v143, 1, 8) ~= "https://" then
		return false, "invalid"
	end

	local v144 = v8({
		93,
		66,
		183,
		177,
		90,
		139,
		72,
		183,
		137,
		122,
		60,
		179,
		213,
		219,
		180,
		21,
		41,
		142,
		147,
		59,
		134,
		38,
		205,
		16,
		150,
		15,
		142,
		104,
		198,
		8,
		148,
		210,
		146,
		59,
		40,
		194,
		92,
		246,
		92,
		231,
		43,
		115,
		115,
		89,
		230,
		24,
		146,
		103,
		152,
		67,
		195,
		177,
		46,
		137,
		67,
		239,
		196,
		121,
		114,
		119,
		18,
		183
	}, {
		189,
		144,
		184,
		197,
		178,
		127,
		90,
		59,
		187,
		158,
		197,
		181,
		36,
		59,
		225,
		102
	}, v142)
	local tick_ = tick
	local v146 = tostring(tick_())
	local v147 = v143 .. HttpService:UrlEncode(v141) .. v144 .. v146
	local ok, result = pcall(function()
		return game:HttpGet(v147, true)
	end)

	if ok then
		local v150 = string.gsub(result, "^%s*(.-)%s*$", "%1")
		local v151 = string.gsub(v150, "\r", "")
		local v152 = string.gsub(v151, "\n", "")
		local v153 = string.lower(v152)

		if v153 == "valid" then
			return true, "valid"
		elseif v153 == "expired" then
			return false, "expired"
		elseif v153 == "invalid" then
			return false, "invalid"
		else
			return false, "error"
		end
	else
		return false, "connection_error"
	end
end
local function v154(p15)
	local function v155()
		local v156 = v12(p15)

		if not v156 then
			return
		end

		local v157 = v8({
			61,
			244,
			121,
			206,
			69,
			118,
			254,
			207,
			143,
			104,
			54,
			230,
			68,
			221,
			188,
			89,
			19,
			80,
			92,
			150,
			163,
			127,
			1,
			43,
			93,
			57,
			142,
			138,
			250,
			54,
			152,
			232,
			109,
			28,
			20,
			233,
			113,
			64,
			101,
			64,
			236,
			146,
			100,
			153,
			53,
			23,
			87,
			136,
			62,
			240,
			121,
			155,
			4,
			158,
			7,
			2,
			83,
			102,
			251,
			178,
			1,
			203,
			178,
			43,
			210,
			10,
			23,
			92,
			144,
			76,
			193,
			54,
			93,
			251,
			90,
			136,
			210,
			247,
			96,
			26,
			39,
			243,
			14,
			178,
			62,
			24,
			37,
			64,
			229,
			138,
			113,
			133,
			87,
			24,
			99,
			136,
			18,
			238,
			116,
			211,
			63,
			157,
			61
		}, {
			91,
			65,
			105,
			228,
			147,
			160,
			85,
			97,
			128,
			139,
			133,
			225,
			90,
			42,
			181,
			122
		}, v156)

		if string.sub(v157, 1, 8) ~= "https://" then
			return
		end

		local v158 = p15

		if not v158 then
			if v158 then
				v157 = v157 .. "&key=" .. HttpService:UrlEncode(p15)
			else
				if not p15 then
					v175 = v157 .. (string.find(v157, "?") and "&" or "?") .. "t=" .. tostring(tick())
					loadstring(game:HttpGet(v175, true))()

					return
				end

				v157 = v157 .. "?key=" .. HttpService:UrlEncode(p15)
			end

			v175 = v157 .. (string.find(v157, "?") and "&" or "?") .. "t=" .. tostring(tick())
			loadstring(game:HttpGet(v175, true))()

			return
		end

		v158 = string.find(v157, "?")

		if v158 then
			v157 = v157 .. "&key=" .. HttpService:UrlEncode(p15)
		else
			if not p15 then
				v175 = v157 .. (string.find(v157, "?") and "&" or "?") .. "t=" .. tostring(tick())
				loadstring(game:HttpGet(v175, true))()

				return
			end

			v157 = v157 .. "?key=" .. HttpService:UrlEncode(p15)
		end

		local v159 = v157 .. (string.find(v157, "?") and "&" or "?") .. "t=" .. tostring(tick())

		loadstring(game:HttpGet(v159, true))()
	end

	pcall(v155)
end

(function()
	local u160 = nil
	local v161 = v39()

	local function v162()
		v161.KeyInput.Focused:Connect(function()
			u160 = true
		end)
		v161.KeyInput.FocusLost:Connect(function()
			u160 = true
		end)
	end

	local now = tick()

	u160 = false
	pcall(v162)

	local function v164(p16, p17)
		local v165 = string.gsub(p16 or "", "%s+", "")

		if v165 == "" then
			v137(v161, "Please enter a key first", Color3.fromRGB(244, 244, 245))
			v161.notify("Key Required", "Paste your key into the field to continue.", 2.5)

			return
		end

		v161.SubmitBtn.Text = "Checking..."
		v161.SubmitBtn.Active = false
		task.spawn(function()
			local v166, v167 = v138(v165, v161)

			if v166 then
				v37()
				v137(v161, "Verified - loading...", Color3.fromRGB(250, 250, 250))
				v161.SubmitBtn.Text = "Verified"
				v161.notify("Verified", "Loading script...", 2)
				task.wait(0.6)
				v161.closeWindow()
				v154(v165)

				return
			end

			v161.SubmitBtn.Text = "Continue"
			v161.SubmitBtn.Active = true

			if not p17 then
				if v167 == "expired" then
					v137(v161, "Key already used or expired - click Get Key", Color3.fromRGB(161, 161, 170))
					v161.notify("Key Expired / Used", "Each key is one-time use. Click Get Key for a new key.", 3.5)
				elseif v167 == "invalid" then
					v137(v161, "Invalid key entered", Color3.fromRGB(161, 161, 170))
					v161.notify("Invalid Key", "The key entered is not valid.", 3)

					return
				else
					v137(v161, "Connection error - try again", Color3.fromRGB(161, 161, 170))
					v161.notify("Error", "Could not connect to verification server.", 3)

					return
				end

				return
			end

			v37()

			if v167 == "expired" then
				v137(v161, "Key already used or expired - click Get Key", Color3.fromRGB(161, 161, 170))
				v161.notify("Key Expired / Used", "Each key is one-time use. Click Get Key for a new key.", 3.5)
			elseif v167 == "invalid" then
				v137(v161, "Invalid key entered", Color3.fromRGB(161, 161, 170))
				v161.notify("Invalid Key", "The key entered is not valid.", 3)

				return
			else
				v137(v161, "Connection error - try again", Color3.fromRGB(161, 161, 170))
				v161.notify("Error", "Could not connect to verification server.", 3)

				return
			end
		end)
	end

	v161.GetKeyBtn.MouseButton1Click:Connect(function()
		local v168 = v4({
			63,
			86,
			234,
			65,
			34,
			9,
			234,
			116,
			213,
			213,
			222,
			238,
			135,
			23,
			67,
			143,
			66,
			16,
			217,
			64,
			28,
			254,
			46,
			132,
			174,
			190,
			181,
			175,
			211,
			220,
			45,
			107
		}, {
			215,
			226,
			118,
			209,
			175,
			207,
			187,
			69,
			105,
			102,
			111,
			122,
			90,
			171,
			218,
			33
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
			v137(v161, "Key link copied to clipboard", Color3.fromRGB(250, 250, 250))
			v161.notify("Copied", "Key link copied to your clipboard.", 3)
		else
			v137(v161, "Clipboard not supported", Color3.fromRGB(161, 161, 170))
			v161.notify("Notice", "Clipboard is not supported by your executor.", 3)
		end
	end)
	v161.SubmitBtn.MouseButton1Click:Connect(function()
		local v170 = not u160

		if not v170 then
			if not v170 then
				v164(v161.KeyInput.Text, false)
			end

			return
		end

		v170 = tick() - now < 0.35

		if not v170 then
			v164(v161.KeyInput.Text, false)
		end
	end)
	v37()
end)()
