-- This file was generated at discord.gg/syncrypt

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local function v3(p1, p2)
	local t1 = {}

	for i = 1, #p1 do
		local v6 = (p1[i] - p2[(i - 1) % #p2 + 1] + 256) % 256

		t1[i] = string.char(v6)
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

local function v19()
	local LocalPlayer = game:GetService("Players").LocalPlayer
	local ScreenGui = Instance.new("ScreenGui")
	local random = math.random

	ScreenGui.Name = "KeySystemUI_" .. tostring(random(1000, 9999))
	ScreenGui.ResetOnSpawn = false

	if not pcall(function()
		ScreenGui.Parent = game:GetService("CoreGui")
	end) and LocalPlayer then
		if not LocalPlayer:FindFirstChild("PlayerGui") then
			LocalPlayer.WaitForChild(LocalPlayer, "PlayerGui", 10)
		end

		ScreenGui.Parent = LocalPlayer.PlayerGui
	end

	local Frame = Instance.new("Frame")

	Frame.Name = "MainFrame"
	Frame.Parent = ScreenGui
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame.Size = UDim2.new(0, 360, 0, 265)
	Frame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
	Frame.BorderSizePixel = 0
	Frame.Active = true
	Frame.Draggable = true
	Frame.ClipsDescendants = true

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, 16)
	UICorner.Parent = Frame
	pcall(function()
		local UIStroke = Instance.new("UIStroke")

		UIStroke.Color = Color3.fromRGB(36, 36, 42)
		UIStroke.Thickness = 1.2
		UIStroke.Parent = Frame
	end)

	local Frame2 = Instance.new("Frame")

	Frame2.Name = "TopAccentLine"
	Frame2.Parent = Frame
	Frame2.Position = UDim2.new(0, 0, 0, 0)
	Frame2.Size = UDim2.new(1, 0, 0, 2)
	Frame2.BorderSizePixel = 0
	Frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame2.ZIndex = 5
	pcall(function()
		local UIGradient = Instance.new("UIGradient")

		UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(0.4, Color3.fromRGB(161, 161, 170)), ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 24, 27)) })
		UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.6, 0.3), NumberSequenceKeypoint.new(1, 0.85) })
		UIGradient.Parent = Frame2
	end)

	local Frame3 = Instance.new("Frame")

	Frame3.Name = "TopBar"
	Frame3.Parent = Frame
	Frame3.Size = UDim2.new(1, 0, 0, 46)
	Frame3.BackgroundColor3 = Color3.fromRGB(17, 17, 20)
	Frame3.BorderSizePixel = 0

	local UICorner2 = Instance.new("UICorner")

	UICorner2.CornerRadius = UDim.new(0, 16)
	UICorner2.Parent = Frame3

	local Frame4 = Instance.new("Frame")

	Frame4.Name = "TopBarCover"
	Frame4.Parent = Frame3
	Frame4.Position = UDim2.new(0, 0, 1, -10)
	Frame4.Size = UDim2.new(1, 0, 0, 10)
	Frame4.BackgroundColor3 = Color3.fromRGB(17, 17, 20)
	Frame4.BorderSizePixel = 0

	local Frame5 = Instance.new("Frame")

	Frame5.Parent = Frame3
	Frame5.Position = UDim2.new(0, 0, 1, 0)
	Frame5.Size = UDim2.new(1, 0, 0, 1)
	Frame5.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
	Frame5.BorderSizePixel = 0

	local Frame6 = Instance.new("Frame")

	Frame6.Parent = Frame3
	Frame6.AnchorPoint = Vector2.new(0, 0.5)
	Frame6.Position = UDim2.new(0, 16, 0.5, 0)
	Frame6.Size = UDim2.new(0, 8, 0, 8)
	Frame6.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
	Frame6.BorderSizePixel = 0

	local UICorner3 = Instance.new("UICorner")

	UICorner3.CornerRadius = UDim.new(1, 0)

	local function v34()
		TweenService:Create(Frame6, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			BackgroundTransparency = 0.5
		}):Play()
	end

	UICorner3.Parent = Frame6
	pcall(v34)

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Parent = Frame3
	TextLabel.AnchorPoint = Vector2.new(0, 0.5)
	TextLabel.Position = UDim2.new(0, 32, 0.5, 0)
	TextLabel.Size = UDim2.new(0, 90, 1, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "Key System"
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextSize = 13
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left

	local Frame7 = Instance.new("Frame")

	Frame7.Parent = Frame3
	Frame7.AnchorPoint = Vector2.new(0, 0.5)
	Frame7.Position = UDim2.new(0, 114, 0.5, 0)
	Frame7.Size = UDim2.new(0, 48, 0, 18)
	Frame7.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
	Frame7.BorderSizePixel = 0

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(0, 5)
	UICorner4.Parent = Frame7

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Parent = Frame7
	TextLabel2.Size = UDim2.new(1, 0, 1, 0)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = "SECURE"
	TextLabel2.TextColor3 = Color3.fromRGB(161, 161, 170)
	TextLabel2.TextSize = 9
	TextLabel2.Font = Enum.Font.GothamBold

	local TextButton = Instance.new("TextButton")

	TextButton.Name = "CloseBtn"
	TextButton.Parent = Frame3
	TextButton.AnchorPoint = Vector2.new(1, 0.5)
	TextButton.Position = UDim2.new(1, -12, 0.5, 0)
	TextButton.Size = UDim2.new(0, 26, 0, 26)
	TextButton.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
	TextButton.BorderSizePixel = 0
	TextButton.Text = "×"
	TextButton.TextColor3 = Color3.fromRGB(161, 161, 170)
	TextButton.TextSize = 17
	TextButton.Font = Enum.Font.GothamBold

	local UICorner5 = Instance.new("UICorner")

	UICorner5.CornerRadius = UDim.new(0, 7)
	UICorner5.Parent = TextButton
	TextButton.MouseButton1Click:Connect(function()
		local function v41()
			local v42 = TweenService
			local v43 = Frame
			local tweenInfoNew = TweenInfo.new
			local Quad = Enum.EasingStyle.Quad
			local In = Enum.EasingDirection.In
			local v47 = v42.Create(v42, v43, tweenInfoNew(0.2, Quad, In), {
				Size = UDim2.new(0, 300, 0, 220),
				BackgroundTransparency = 1
			})

			local function v48()
				ScreenGui:Destroy()
			end

			v47.Play(v47)
			v47.Completed:Connect(v48)
		end

		pcall(v41)
	end)
	TextButton.MouseEnter:Connect(function()
		pcall(function()
			local v49 = TweenService
			local v50 = TextButton
			local tweenInfo = TweenInfo.new(0.15)
			local t2 = {
				BackgroundColor3 = Color3.fromRGB(239, 68, 68),
				TextColor3 = Color3.fromRGB(255, 255, 255)
			}

			v49.Create(v49, v50, tweenInfo, t2):Play()
		end)
	end)
	TextButton.MouseLeave:Connect(function()
		local function v53()
			local v54 = TweenService
			local v55 = TextButton
			local tweenInfo = TweenInfo.new(0.15)
			local t3 = {
				BackgroundColor3 = Color3.fromRGB(24, 24, 30),
				TextColor3 = Color3.fromRGB(161, 161, 170)
			}

			v54.Create(v54, v55, tweenInfo, t3):Play()
		end

		pcall(v53)
	end)

	local TextBox = Instance.new("TextBox")

	TextBox.Parent = Frame
	TextBox.Position = UDim2.new(0.5, 0, 0, 60)
	TextBox.AnchorPoint = Vector2.new(0.5, 0)
	TextBox.Size = UDim2.new(0.92, 0, 0, 40)
	TextBox.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
	TextBox.BorderSizePixel = 0
	TextBox.Text = ""
	TextBox.PlaceholderText = "Paste your key here..."
	TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.PlaceholderColor3 = Color3.fromRGB(113, 113, 122)
	TextBox.TextSize = 13
	TextBox.Font = Enum.Font.Gotham
	TextBox.ClearTextOnFocus = false

	local UICorner6 = Instance.new("UICorner")

	UICorner6.CornerRadius = UDim.new(0, 9)

	local UIStroke = nil

	UICorner6.Parent = TextBox

	local function v61()
		UIStroke = Instance.new("UIStroke")
		UIStroke.Color = Color3.fromRGB(36, 36, 42)
		UIStroke.Thickness = 1
		UIStroke.Parent = TextBox
	end

	UIStroke = nil
	pcall(v61)
	TextBox.Focused:Connect(function()
		local function v62()
			if not UIStroke then
				v63 = TweenService
				v64 = TextBox
				v65 = TweenInfo.new(0.18)
				v66 = Color3
				v63.Create(v63, v64, v65, {
					BackgroundColor3 = v66.fromRGB(24, 24, 30)
				}):Play()

				return
			end

			TweenService:Create(UIStroke, TweenInfo.new(0.18), {
				Color = Color3.fromRGB(255, 255, 255),
				Thickness = 1.3
			}):Play()

			local v67 = TweenService
			local v71 = TextBox
			local tweenInfo = TweenInfo.new(0.18)
			local Color3_ = Color3

			v67.Create(v67, v71, tweenInfo, {
				BackgroundColor3 = Color3_.fromRGB(24, 24, 30)
			}):Play()
		end

		pcall(v62)
	end)
	TextBox.FocusLost:Connect(function()
		pcall(function()
			if not UIStroke then
				v68 = TweenService
				v69 = TextBox
				v70 = TweenInfo.new(0.18)
				v68.Create(v68, v69, v70, {
					BackgroundColor3 = Color3.fromRGB(18, 18, 22)
				}):Play()

				return
			end

			TweenService:Create(UIStroke, TweenInfo.new(0.18), {
				Color = Color3.fromRGB(36, 36, 42),
				Thickness = 1
			}):Play()

			local v72 = TweenService
			local v73 = TextBox
			local tweenInfo = TweenInfo.new(0.18)

			v72.Create(v72, v73, tweenInfo, {
				BackgroundColor3 = Color3.fromRGB(18, 18, 22)
			}):Play()
		end)
	end)

	local TextButton2 = Instance.new("TextButton")

	TextButton2.Parent = Frame
	TextButton2.Position = UDim2.new(0.5, 0, 0, 110)
	TextButton2.AnchorPoint = Vector2.new(0.5, 0)
	TextButton2.Size = UDim2.new(0.92, 0, 0, 40)
	TextButton2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextButton2.BorderSizePixel = 0
	TextButton2.Text = "Verify Key"
	TextButton2.TextColor3 = Color3.fromRGB(10, 10, 12)
	TextButton2.TextSize = 13
	TextButton2.Font = Enum.Font.GothamBold
	TextButton2.AutoButtonColor = false

	local UICorner7 = Instance.new("UICorner")

	UICorner7.CornerRadius = UDim.new(0, 9)
	UICorner7.Parent = TextButton2
	TextButton2.MouseEnter:Connect(function()
		if not TextButton2.Active then
			return
		end

		local function v74()
			TweenService:Create(TextButton2, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundColor3 = Color3.fromRGB(228, 228, 231),
				Size = UDim2.new(0.92, 4, 0, 40)
			}):Play()
		end

		pcall(v74)
	end)
	TextButton2.MouseLeave:Connect(function()
		if not TextButton2.Active then
			return
		end

		local function v75()
			TweenService:Create(TextButton2, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(0.92, 0, 0, 40)
			}):Play()
		end

		pcall(v75)
	end)

	local TextButton3 = Instance.new("TextButton")

	TextButton3.Parent = Frame
	TextButton3.Position = UDim2.new(0.5, 0, 0, 158)
	TextButton3.AnchorPoint = Vector2.new(0.5, 0)
	TextButton3.Size = UDim2.new(0.92, 0, 0, 38)
	TextButton3.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
	TextButton3.BorderSizePixel = 0
	TextButton3.Text = "Get Key Link"
	TextButton3.TextColor3 = Color3.fromRGB(244, 244, 245)
	TextButton3.TextSize = 13
	TextButton3.Font = Enum.Font.GothamBold
	TextButton3.AutoButtonColor = false

	local UICorner8 = Instance.new("UICorner")

	UICorner8.CornerRadius = UDim.new(0, 9)
	UICorner8.Parent = TextButton3

	local UIStroke2 = nil

	pcall(function()
		UIStroke2 = Instance.new("UIStroke")
		UIStroke2.Color = Color3.fromRGB(44, 44, 52)
		UIStroke2.Thickness = 1
		UIStroke2.Parent = TextButton3
	end)
	TextButton3.MouseEnter:Connect(function()
		local function v77()
			local v78 = TweenService
			local v79 = TextButton3
			local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local color3 = Color3.fromRGB(32, 32, 38)
			local UDim2_ = UDim2

			v78.Create(v78, v79, tweenInfo, {
				BackgroundColor3 = color3,
				Size = UDim2_.new(0.92, 4, 0, 38)
			}):Play()

			if not UIStroke2 then
				return
			end

			local v83 = TweenService
			local v84 = UIStroke2
			local tweenInfo2 = TweenInfo.new(0.15)
			local Color3_ = Color3

			v83.Create(v83, v84, tweenInfo2, {
				Color = Color3_.fromRGB(64, 64, 76)
			}):Play()
		end

		pcall(v77)
	end)
	TextButton3.MouseLeave:Connect(function()
		local function v87()
			TweenService:Create(TextButton3, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundColor3 = Color3.fromRGB(22, 22, 26),
				Size = UDim2.new(0.92, 0, 0, 38)
			}):Play()

			if not UIStroke2 then
				return
			end

			local v88 = TweenService
			local v89 = UIStroke2
			local tweenInfo = TweenInfo.new(0.15)
			local t4 = {
				Color = Color3.fromRGB(44, 44, 52)
			}

			v88.Create(v88, v89, tweenInfo, t4):Play()
		end

		pcall(v87)
	end)

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Parent = Frame
	TextLabel3.Position = UDim2.new(0.5, 0, 0, 206)
	TextLabel3.AnchorPoint = Vector2.new(0.5, 0)
	TextLabel3.Size = UDim2.new(0.92, 0, 0, 48)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Text = "Ready to verify"
	TextLabel3.TextColor3 = Color3.fromRGB(113, 113, 122)
	TextLabel3.TextSize = 11
	TextLabel3.Font = Enum.Font.Gotham
	TextLabel3.TextWrapped = true

	local function v93()
		Frame.Size = UDim2.new(0, 310, 0, 230)
		TweenService:Create(Frame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 360, 0, 265)
		}):Play()
	end

	TextLabel3.TextYAlignment = Enum.TextYAlignment.Center
	pcall(v93)

	return {
		ScreenGui = ScreenGui,
		MainFrame = Frame,
		KeyInput = TextBox,
		SubmitBtn = TextButton2,
		GetKeyBtn = TextButton3,
		StatusLabel = TextLabel3
	}
end
local function v94(p3, p4)
	local color3 = Color3.fromRGB(251, 191, 36)

	if p4 and p4.Parent then
		local text = "Starting verification..."

		pcall(function()
			local v97 = TweenService
			local v98 = p4
			local tweenInfo = TweenInfo.new(0.08)

			v97.Create(v97, v98, tweenInfo, {
				TextTransparency = 0.8
			}):Play()
			task.wait(0.08)
			p4.Text = text

			if not color3 then
				TweenService:Create(p4, TweenInfo.new(0.12), {
					TextTransparency = 0
				}):Play()

				return
			end

			p4.TextColor3 = color3
			TweenService:Create(p4, TweenInfo.new(0.12), {
				TextTransparency = 0
			}):Play()
		end)
	end

	task.wait(0.1)

	local v100 = string.gsub(p3, "%s+", "")
	local v101 = string.gsub(v100, "\'", "")
	local v102 = string.gsub(v101, "\"", "")
	local color32 = Color3.fromRGB(251, 191, 36)

	if p4 and p4.Parent then
		local text = "Building request..."

		pcall(function()
			local v105 = TweenService
			local v106 = p4
			local tweenInfo = TweenInfo.new(0.08)

			v105.Create(v105, v106, tweenInfo, {
				TextTransparency = 0.8
			}):Play()
			task.wait(0.08)
			p4.Text = text

			if not color32 then
				TweenService:Create(p4, TweenInfo.new(0.12), {
					TextTransparency = 0
				}):Play()

				return
			end

			p4.TextColor3 = color32
			TweenService:Create(p4, TweenInfo.new(0.12), {
				TextTransparency = 0
			}):Play()
		end)
	end

	local tick_ = tick
	local v109 = tostring(tick_())
	local v110 = v3({
		172,
		18,
		36,
		78,
		243,
		210,
		172,
		138,
		180,
		192,
		188,
		254,
		40,
		169,
		155,
		42,
		189,
		17,
		41,
		81,
		244,
		253,
		234,
		137,
		164,
		204,
		183,
		196,
		25,
		165,
		153,
		244,
		186,
		255,
		28,
		71,
		228,
		249,
		241,
		192,
		110,
		200,
		175,
		14,
		247,
		171,
		149,
		55,
		173,
		4,
		41,
		27,
		177,
		190,
		232,
		192,
		186,
		154
	}, {
		68,
		158,
		176,
		222,
		128,
		152,
		125,
		91,
		65,
		93,
		74,
		149,
		184,
		53,
		48,
		197
	}) .. HttpService:UrlEncode(v102) .. v3({
		106,
		17,
		19,
		80,
		233,
		8,
		241,
		152,
		116,
		145,
		124,
		201,
		29,
		106,
		96,
		40,
		113,
		206,
		229,
		20,
		227,
		197,
		177,
		148,
		163,
		195,
		119,
		246,
		238,
		102,
		105,
		242,
		123,
		214,
		228,
		64,
		225,
		204,
		178,
		144,
		163,
		144,
		122,
		201,
		222,
		169,
		109
	}, {
		68,
		158,
		176,
		222,
		128,
		152,
		125,
		91,
		65,
		93,
		74,
		149,
		184,
		53,
		48,
		197
	}) .. v109

	task.wait(0.1)

	local color33 = Color3.fromRGB(251, 191, 36)

	if p4 and p4.Parent then
		local text = "Connecting to server..."

		pcall(function()
			local v113 = TweenService
			local v114 = p4
			local tweenInfo = TweenInfo.new(0.08)

			v113.Create(v113, v114, tweenInfo, {
				TextTransparency = 0.8
			}):Play()
			task.wait(0.08)
			p4.Text = text

			if not color33 then
				TweenService:Create(p4, TweenInfo.new(0.12), {
					TextTransparency = 0
				}):Play()

				return
			end

			p4.TextColor3 = color33
			TweenService:Create(p4, TweenInfo.new(0.12), {
				TextTransparency = 0
			}):Play()
		end)
	end

	local ok, result = pcall(function()
		return game:HttpGet(v110, true)
	end)
	local color34 = Color3.fromRGB(251, 191, 36)

	if p4 and p4.Parent then
		local text = "Processing response..."

		pcall(function()
			local v120 = TweenService
			local v121 = p4
			local tweenInfo = TweenInfo.new(0.08)

			v120.Create(v120, v121, tweenInfo, {
				TextTransparency = 0.8
			}):Play()
			task.wait(0.08)
			p4.Text = text

			if not color34 then
				TweenService:Create(p4, TweenInfo.new(0.12), {
					TextTransparency = 0
				}):Play()

				return
			end

			p4.TextColor3 = color34
			TweenService:Create(p4, TweenInfo.new(0.12), {
				TextTransparency = 0
			}):Play()
		end)
	end

	if not ok then
		return false, "connection_error"
	end

	local v123 = string.gsub(result, "^%s*(.-)%s*$", "%1")
	local v124 = string.gsub(v123, "\r", "")
	local v125 = string.gsub(v124, "\n", "")
	local v126 = string.lower(v125)
	local color35 = Color3.fromRGB(251, 191, 36)

	if not (p4 and p4.Parent) then
		task.wait(0.1)

		if v126 == "valid" then
			return true, "valid"
		elseif v126 == "expired" then
			return false, "expired"
		elseif v126 == "invalid" then
			return false, "invalid"
		else
			return false, "error"
		end
	end

	local text = "Validating key..."

	pcall(function()
		local v129 = TweenService
		local v130 = p4
		local tweenInfo = TweenInfo.new(0.08)

		v129.Create(v129, v130, tweenInfo, {
			TextTransparency = 0.8
		}):Play()
		task.wait(0.08)
		p4.Text = text

		if not color35 then
			TweenService:Create(p4, TweenInfo.new(0.12), {
				TextTransparency = 0
			}):Play()

			return
		end

		p4.TextColor3 = color35
		TweenService:Create(p4, TweenInfo.new(0.12), {
			TextTransparency = 0
		}):Play()
	end)
	task.wait(0.1)

	if v126 == "valid" then
		return true, "valid"
	elseif v126 == "expired" then
		return false, "expired"
	elseif v126 == "invalid" then
		return false, "invalid"
	else
		return false, "error"
	end
end
local function v132(p5)
	local function v133()
		local v134 = v3({
			172,
			18,
			36,
			78,
			243,
			210,
			172,
			138,
			180,
			192,
			188,
			254,
			40,
			169,
			155,
			42,
			189,
			17,
			41,
			81,
			244,
			253,
			234,
			137,
			164,
			204,
			183,
			196,
			25,
			165,
			153,
			244,
			186,
			255,
			28,
			71,
			228,
			249,
			241,
			192,
			110,
			200,
			175,
			14,
			247,
			168,
			147,
			55,
			173,
			14,
			36,
			27,
			179,
			204,
			175,
			143,
			166,
			146,
			122,
			248,
			229,
			101,
			101,
			251,
			167,
			203,
			228,
			23,
			226,
			254,
			170,
			188,
			119,
			142,
			131,
			194,
			239,
			109,
			100,
			39,
			165,
			210,
			229,
			19,
			226,
			203,
			173,
			143
		}, {
			68,
			158,
			176,
			222,
			128,
			152,
			125,
			91,
			65,
			93,
			74,
			149,
			184,
			53,
			48,
			197
		})
		local v135 = p5

		if not v135 then
			if v135 then
				v134 = v134 .. "&key=" .. HttpService:UrlEncode(p5)
			else
				if not p5 then
					v139 = string.find(v134, "?") and "&" or "?"
					v140 = tick
					v141 = v134 .. v139 .. "t=" .. tostring(v140())
					loadstring(game:HttpGet(v141, true))()

					return
				end

				v134 = v134 .. "?key=" .. HttpService:UrlEncode(p5)
			end

			v139 = string.find(v134, "?") and "&" or "?"
			v140 = tick
			v141 = v134 .. v139 .. "t=" .. tostring(v140())
			loadstring(game:HttpGet(v141, true))()

			return
		end

		v135 = string.find(v134, "?")

		if v135 then
			v134 = v134 .. "&key=" .. HttpService:UrlEncode(p5)
		else
			if not p5 then
				v139 = string.find(v134, "?") and "&" or "?"
				v140 = tick
				v141 = v134 .. v139 .. "t=" .. tostring(v140())
				loadstring(game:HttpGet(v141, true))()

				return
			end

			v134 = v134 .. "?key=" .. HttpService:UrlEncode(p5)
		end

		local v136 = string.find(v134, "?") and "&" or "?"
		local tick_ = tick
		local v138 = v134 .. v136 .. "t=" .. tostring(tick_())

		loadstring(game:HttpGet(v138, true))()
	end

	local ok = pcall(v133)

	if ok then
		return
	end

	pcall(function()
		local StarterGui = game:GetService("StarterGui")

		StarterGui.SetCore(StarterGui, "SendNotification", {
			Title = "Error",
			Text = "Script failed to load.",
			Duration = 4
		})
	end)
end

(function()
	local v142 = v19()

	v142.GetKeyBtn.MouseButton1Click:Connect(function()
		local v143 = v3({
			172,
			18,
			36,
			78,
			243,
			210,
			172,
			138,
			180,
			192,
			188,
			254,
			40,
			169,
			155,
			42,
			189,
			17,
			41,
			81,
			244,
			253,
			234,
			137,
			164,
			204,
			183,
			196,
			44,
			150,
			153,
			50,
			179,
			13,
			34,
			13,
			235,
			253,
			246,
			206,
			186,
			208,
			190,
			250,
			37,
			116,
			163,
			40,
			182,
			7,
			32,
			82,
			189,
			203,
			177,
			141,
			117,
			194,
			127,
			197,
			27,
			98,
			96,
			250,
			122,
			1,
			221,
			18,
			185,
			250,
			227,
			136,
			162,
			147,
			123,
			206,
			229,
			108,
			104,
			249,
			166,
			255,
			228,
			19,
			181,
			250,
			176,
			139,
			117
		}, {
			68,
			158,
			176,
			222,
			128,
			152,
			125,
			91,
			65,
			93,
			74,
			149,
			184,
			53,
			48,
			197
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
				setclipboard_(v143)
			end)

			local StatusLabel = v142.StatusLabel
			local color3 = Color3.fromRGB(52, 211, 153)

			if StatusLabel and StatusLabel.Parent then
				local text = "URL copied to clipboard!"

				pcall(function()
					local v148 = TweenService
					local v149 = StatusLabel
					local tweenInfo = TweenInfo.new(0.08)

					v148.Create(v148, v149, tweenInfo, {
						TextTransparency = 0.8
					}):Play()
					task.wait(0.08)
					StatusLabel.Text = text

					if not color3 then
						TweenService:Create(StatusLabel, TweenInfo.new(0.12), {
							TextTransparency = 0
						}):Play()

						return
					end

					StatusLabel.TextColor3 = color3
					TweenService:Create(StatusLabel, TweenInfo.new(0.12), {
						TextTransparency = 0
					}):Play()
				end)
			end
		else
			local StatusLabel = v142.StatusLabel
			local color3 = Color3.fromRGB(248, 113, 113)

			if StatusLabel and StatusLabel.Parent then
				local text = "Clipboard not supported"

				pcall(function()
					local v154 = TweenService
					local v155 = StatusLabel
					local tweenInfo = TweenInfo.new(0.08)

					v154.Create(v154, v155, tweenInfo, {
						TextTransparency = 0.8
					}):Play()
					task.wait(0.08)
					StatusLabel.Text = text

					if not color3 then
						TweenService:Create(StatusLabel, TweenInfo.new(0.12), {
							TextTransparency = 0
						}):Play()

						return
					end

					StatusLabel.TextColor3 = color3
					TweenService:Create(StatusLabel, TweenInfo.new(0.12), {
						TextTransparency = 0
					}):Play()
				end)
			end
		end

		task.wait(3)

		local StatusLabel = v142.StatusLabel

		if StatusLabel then
			StatusLabel = v142.StatusLabel.Parent
		end

		if not StatusLabel then
			return
		end

		local StatusLabel2 = v142.StatusLabel
		local color3 = Color3.fromRGB(113, 113, 122)

		if not (StatusLabel2 and StatusLabel2.Parent) then
			return
		end

		local text = "Ready to verify"

		pcall(function()
			local v161 = TweenService
			local v162 = StatusLabel2
			local tweenInfo = TweenInfo.new(0.08)

			v161.Create(v161, v162, tweenInfo, {
				TextTransparency = 0.8
			}):Play()
			task.wait(0.08)
			StatusLabel2.Text = text

			if not color3 then
				TweenService:Create(StatusLabel2, TweenInfo.new(0.12), {
					TextTransparency = 0
				}):Play()

				return
			end

			StatusLabel2.TextColor3 = color3
			TweenService:Create(StatusLabel2, TweenInfo.new(0.12), {
				TextTransparency = 0
			}):Play()
		end)
	end)

	local MouseButton1Click = v142.SubmitBtn.MouseButton1Click

	MouseButton1Click.Connect(MouseButton1Click, function()
		local Text = v142.KeyInput.Text

		if Text == "" then
			local StatusLabel = v142.StatusLabel
			local color3 = Color3.fromRGB(248, 113, 113)

			if not (StatusLabel and StatusLabel.Parent) then
				return
			end

			local text = "Please enter a key"

			pcall(function()
				local v169 = TweenService
				local v170 = StatusLabel
				local tweenInfo = TweenInfo.new(0.08)

				v169.Create(v169, v170, tweenInfo, {
					TextTransparency = 0.8
				}):Play()
				task.wait(0.08)
				StatusLabel.Text = text

				if not color3 then
					TweenService:Create(StatusLabel, TweenInfo.new(0.12), {
						TextTransparency = 0
					}):Play()

					return
				end

				StatusLabel.TextColor3 = color3
				TweenService:Create(StatusLabel, TweenInfo.new(0.12), {
					TextTransparency = 0
				}):Play()
			end)
		else
			local StatusLabel = v142.StatusLabel
			local color3 = Color3.fromRGB(251, 191, 36)

			if StatusLabel and StatusLabel.Parent then
				local text = "Verifying key..."

				pcall(function()
					local v175 = TweenService
					local v176 = StatusLabel
					local tweenInfo = TweenInfo.new(0.08)

					v175.Create(v175, v176, tweenInfo, {
						TextTransparency = 0.8
					}):Play()
					task.wait(0.08)
					StatusLabel.Text = text

					if not color3 then
						TweenService:Create(StatusLabel, TweenInfo.new(0.12), {
							TextTransparency = 0
						}):Play()

						return
					end

					StatusLabel.TextColor3 = color3
					TweenService:Create(StatusLabel, TweenInfo.new(0.12), {
						TextTransparency = 0
					}):Play()
				end)
			end

			v142.SubmitBtn.Text = "Checking..."
			v142.SubmitBtn.Active = false
			task.spawn(function()
				local v178, v179 = v94(Text, v142.StatusLabel)

				if v178 then
					local StatusLabel2 = v142.StatusLabel
					local color32 = Color3.fromRGB(52, 211, 153)

					if StatusLabel2 and StatusLabel2.Parent then
						local text = "Key verified! Loading script..."

						pcall(function()
							local v183 = TweenService
							local v184 = StatusLabel2
							local tweenInfo = TweenInfo.new(0.08)

							v183.Create(v183, v184, tweenInfo, {
								TextTransparency = 0.8
							}):Play()
							task.wait(0.08)
							StatusLabel2.Text = text

							if not color32 then
								TweenService:Create(StatusLabel2, TweenInfo.new(0.12), {
									TextTransparency = 0
								}):Play()

								return
							end

							StatusLabel2.TextColor3 = color32
							TweenService:Create(StatusLabel2, TweenInfo.new(0.12), {
								TextTransparency = 0
							}):Play()
						end)
					end

					v142.SubmitBtn.Text = "Verified"
					pcall(function()
						local v186 = TweenService
						local SubmitBtn = v142.SubmitBtn
						local tweenInfo = TweenInfo.new(0.2)
						local t5 = {
							BackgroundColor3 = Color3.fromRGB(16, 185, 129),
							TextColor3 = Color3.fromRGB(255, 255, 255)
						}

						v186.Create(v186, SubmitBtn, tweenInfo, t5):Play()
					end)
					pcall(function()
						game:GetService("StarterGui"):SetCore("SendNotification", {
							Title = "Key Verified",
							Text = "Loading script...",
							Duration = 3
						})
					end)
					task.wait(1.2)

					local v190 = string.gsub(Text, "%s+", "")

					local function v191()
						local tween = TweenService:Create(v142.MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
							Size = UDim2.new(0, 300, 0, 220),
							BackgroundTransparency = 1
						})

						local function v193()
							v142.ScreenGui:Destroy()
						end

						tween:Play()
						tween.Completed:Connect(v193)
					end

					pcall(v191)
					v132(v190)
				else
					v142.SubmitBtn.Text = "Verify Key"
					v142.SubmitBtn.Active = true

					if v179 == "expired" then
						local StatusLabel2 = v142.StatusLabel
						local color32 = Color3.fromRGB(248, 113, 113)

						if not (StatusLabel2 and StatusLabel2.Parent) then
							return
						end

						local text = "Key has expired"

						pcall(function()
							local v197 = TweenService
							local v198 = StatusLabel2
							local tweenInfo = TweenInfo.new(0.08)

							v197.Create(v197, v198, tweenInfo, {
								TextTransparency = 0.8
							}):Play()
							task.wait(0.08)
							StatusLabel2.Text = text

							if not color32 then
								TweenService:Create(StatusLabel2, TweenInfo.new(0.12), {
									TextTransparency = 0
								}):Play()

								return
							end

							StatusLabel2.TextColor3 = color32
							TweenService:Create(StatusLabel2, TweenInfo.new(0.12), {
								TextTransparency = 0
							}):Play()
						end)
					elseif v179 == "invalid" then
						local StatusLabel2 = v142.StatusLabel
						local color32 = Color3.fromRGB(248, 113, 113)

						if not (StatusLabel2 and StatusLabel2.Parent) then
							return
						end

						local text = "Invalid key entered"

						pcall(function()
							local v203 = TweenService
							local v204 = StatusLabel2
							local tweenInfo = TweenInfo.new(0.08)

							v203.Create(v203, v204, tweenInfo, {
								TextTransparency = 0.8
							}):Play()
							task.wait(0.08)
							StatusLabel2.Text = text

							if not color32 then
								TweenService:Create(StatusLabel2, TweenInfo.new(0.12), {
									TextTransparency = 0
								}):Play()

								return
							end

							StatusLabel2.TextColor3 = color32
							TweenService:Create(StatusLabel2, TweenInfo.new(0.12), {
								TextTransparency = 0
							}):Play()
						end)
					else
						local StatusLabel2 = v142.StatusLabel
						local text = "Verification failed: " .. tostring(v179)
						local color32 = Color3.fromRGB(248, 113, 113)

						if not (StatusLabel2 and StatusLabel2.Parent) then
							return
						end

						pcall(function()
							local v209 = TweenService
							local v210 = StatusLabel2
							local tweenInfo = TweenInfo.new(0.08)

							v209.Create(v209, v210, tweenInfo, {
								TextTransparency = 0.8
							}):Play()
							task.wait(0.08)
							StatusLabel2.Text = text

							if not color32 then
								TweenService:Create(StatusLabel2, TweenInfo.new(0.12), {
									TextTransparency = 0
								}):Play()

								return
							end

							StatusLabel2.TextColor3 = color32
							TweenService:Create(StatusLabel2, TweenInfo.new(0.12), {
								TextTransparency = 0
							}):Play()
						end)
					end
				end
			end)
		end
	end)
end)()
