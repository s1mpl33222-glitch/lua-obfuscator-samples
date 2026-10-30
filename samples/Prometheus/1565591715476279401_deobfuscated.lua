-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local HttpService = game:GetService("HttpService")

game:GetService("TweenService")

local CoreGui = game:GetService("CoreGui")
local syn_ = syn

if syn_ then
	syn_ = syn.request
end

if not syn_ then
	local http_ = http

	if http_ then
		http_ = http.request
	end

	syn_ = http_ or (http_request or request)
end

local function v6(p1)
	local v7 = p1 / 1000 - os.time()
	local v8 = math.floor(v7)
	local v9 = math.max(0, v8)
	local v10 = v9 / 86400
	local v11 = math.floor(v10)
	local v12 = v9 % 86400 / 3600
	local v13 = math.floor(v12)
	local v14 = v9 % 3600 / 60
	local v15 = math.floor(v14)

	if v11 > 0 then
		return string.format("%dd %dh", v11, v13)
	else
		return string.format("%dh %dm", v13, v15)
	end
end
local function v16(p2)
	if not syn_ then
		return false, "Seu executor não suporta requisições HTTP."
	end

	local ok, result = pcall(syn_, {
		Url = "https://nexora-keys.nexorakeys.workers.dev/api/validate",
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json"
		},
		Body = HttpService:JSONEncode({
			key = p2
		})
	})

	if not (ok and (result and result.Body)) then
		return false, "Não foi possível conectar ao servidor."
	end

	local data = nil

	local function v20()
		data = HttpService:JSONDecode(result.Body)
	end

	local v21 = not pcall(v20)

	if v21 then
		if v21 then
			return false, "Resposta inválida do servidor."
		elseif data.valid then
			return true, data
		else
			return false, data.error or "Key inválida."
		end
	end

	local v22 = data

	v21 = type(v22) ~= "table"

	if v21 then
		return false, "Resposta inválida do servidor."
	elseif data.valid then
		return true, data
	else
		return false, data.error or "Key inválida."
	end
end

local v23 = (function()
	local t1 = {}
	local TweenService = game:GetService("TweenService")
	local UserInputService = game:GetService("UserInputService")
	local Players = game:GetService("Players")
	local HttpService2 = game:GetService("HttpService")
	local TextService = game:GetService("TextService")
	local CoreGui2 = game:GetService("CoreGui")
	local value1 = {
		Background = Color3.fromRGB(9, 11, 24),
		Sidebar = Color3.fromRGB(13, 16, 34),
		Card = Color3.fromRGB(22, 27, 56),
		CardHover = Color3.fromRGB(32, 38, 76),
		Text = Color3.fromRGB(238, 242, 255),
		SubText = Color3.fromRGB(136, 146, 190),
		Off = Color3.fromRGB(46, 52, 88),
		Accent = Color3.fromRGB(74, 128, 255),
		AccentLight = Color3.fromRGB(156, 92, 255)
	}
	local t2 = {
		Bold = Enum.Font.GothamBold,
		Medium = Enum.Font.GothamMedium,
		Light = Enum.Font.Gotham
	}
	local t3 = {}
	local n1 = 0

	local function v35(p3, p4)
		local v36 = p4 + n1

		p3.BackgroundTransparency = math.clamp(v36, 0, 0.95)

		local v37 = t3

		table.insert(v37, {
			obj = p3,
			base = p4
		})
	end
	local function v38(p5, p6, p7)
		local v39 = TweenService
		local tweenInfoNew = TweenInfo.new
		local Enum_ = Enum

		v39.Create(v39, p5, tweenInfoNew(p7 or 0.2, Enum_.EasingStyle.Quad, Enum.EasingDirection.Out), p6):Play()
	end
	local function createUIStroke(p8, p9, p10, p11)
		local UIStroke = Instance.new("UIStroke")

		UIStroke.Color = p9
		UIStroke.Thickness = p10 or 1
		UIStroke.Transparency = p11 or 0
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke.Parent = p8

		return UIStroke
	end
	local function createUIGradient(p12, p13)
		local UIGradient = Instance.new("UIGradient")

		UIGradient.Color = ColorSequence.new(value1.Accent, value1.AccentLight)
		UIGradient.Rotation = p13 or 0
		UIGradient.Parent = p12

		return UIGradient
	end
	local function createTextLabel(p14, p15, p16, p17, p18)
		local TextLabel = Instance.new("TextLabel")

		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = p15
		TextLabel.TextSize = p16
		TextLabel.Font = p17 or t2.Medium
		TextLabel.TextColor3 = p18 or value1.Text
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.TextYAlignment = Enum.TextYAlignment.Center
		TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
		TextLabel.Parent = p14

		return TextLabel
	end
	local function v48(p19)
		return p19.UserInputType == Enum.UserInputType.MouseButton1 and true or p19.UserInputType == Enum.UserInputType.Touch
	end
	local function v49(p20, p21)
		local t4 = {
			moved = false
		}
		local u51 = nil
		local Position = nil
		local Position2 = nil

		local function v54(input)
			if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
				return
			end

			u51 = true
			t4.moved = false
			Position = input.Position
			Position2 = p21.Position
			input.Changed:Connect(function()
				if input.UserInputState ~= Enum.UserInputState.End then
					return
				end

				u51 = false
			end)
		end

		p20.InputBegan:Connect(v54)
		UserInputService.InputChanged:Connect(function(input)
			local v55 = u51

			if v55 then
				v55 = input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch
			end

			if not v55 then
				return
			end

			local v56 = input.Position - Position

			if v56.Magnitude > 6 then
				t4.moved = true
			end

			p21.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v56.X, Position2.Y.Scale, Position2.Y.Offset + v56.Y)
		end)

		return t4
	end
	local function v57(p22, p23)
		local Frame = Instance.new("Frame")

		Frame.Size = UDim2.new(1, 0, 0, p23)
		Frame.BackgroundColor3 = value1.Card
		Frame.BorderSizePixel = 0
		Frame.Parent = p22
		v35(Frame, 0.42)

		local UICorner = Instance.new("UICorner")

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = Frame

		local color3 = Color3.new(1, 1, 1)
		local UIStroke = Instance.new("UIStroke")

		UIStroke.Color = color3
		UIStroke.Thickness = 1
		UIStroke.Transparency = 0.92
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke.Parent = Frame
		Frame.MouseEnter:Connect(function()
			v38(Frame, {
				BackgroundColor3 = value1.CardHover
			}, 0.15)
			v38(UIStroke, {
				Transparency = 0.8
			}, 0.15)
		end)
		Frame.MouseLeave:Connect(function()
			v38(Frame, {
				BackgroundColor3 = value1.Card
			}, 0.2)
			v38(UIStroke, {
				Transparency = 0.92
			}, 0.2)
		end)

		return Frame, UIStroke
	end
	local function v62(p24, p25, p26)
		local v63

		if p25.Description == nil then
			v63 = false
		else
			v63 = p25.Description ~= ""
		end

		local v64 = createTextLabel(p24, p25.Name, 14, t2.Medium, value1.Text)

		v64.Position = UDim2.new(0, 16, 0, v63 and 11 or 0)
		v64.Size = UDim2.new(1, -p26, 0, v63 and 20 or p24.Size.Y.Offset)

		if not v63 then
			return
		end

		local v65 = createTextLabel(p24, p25.Description, 12, t2.Light, value1.SubText)

		v65.Position = UDim2.new(0, 16, 0, 32)
		v65.Size = UDim2.new(1, -p26, 0, 18)
	end

	function t1.CreateWindow(_, p27)
		local t5 = {}
		local v68 = p27 or {}
		local Name = v68.Name or "NEON"
		local Subtitle = v68.Subtitle
		local t6 = {
			value1 = v68.ToggleKey or Enum.KeyCode.RightShift,
			value2 = v68.ConfigFolder or "NeonUI"
		}
		local value14 = v68.Loading ~= false

		if v68.Accent then
			t5.value1 = value1
			t5.value2 = v68.Accent
			t5.value1.Accent = t5.value2
		end

		if v68.Accent2 then
			t5.value1 = value1
			t5.value2 = v68.Accent2
			t5.value1.AccentLight = t5.value2
		end

		t5.value1 = {}
		t3 = t5.value1
		n1 = 0
		t5.value2 = workspace.CurrentCamera

		local ViewportSize = t5.value2 and t5.value2.ViewportSize or Vector2.new(1280, 720)
		local value12 = t5.value1

		t5.value6 = 2609307157695
		t5.value3 = "math"
		t5.value1 = value12

		local clamp = math.clamp

		t5.value3 = ViewportSize.X * 0.88
		t5.value6 = "\255\4\175\159p"
		t5.value4 = 440
		t5.value7 = 640
		t5.value8 = 7869210463824
		t6.value3 = clamp(t5.value3, t5.value4, t5.value7)

		local clamp2 = math.clamp

		t5.value4 = ViewportSize.Y * 0.82
		t5.value7 = 290
		t5.value5 = 420
		t5.value3 = clamp2(t5.value4, t5.value7, t5.value5)

		local value13 = t5.value1
		local value15 = t5.value1

		t5.value8 = 520
		t5.value5 = value13
		t5.value4 = value15

		local v78 = t6.value3 < t5.value8

		t5.value6 = 132
		t5.value5 = 168
		t6.value4 = v78 and t5.value6 or t5.value5

		local n2 = 56

		t6.value5 = {}
		t6.value6 = {}
		t6.value7 = {}
		t5.value8 = Instance.new("ScreenGui")
		t6.value8 = t5.value8
		t6.value8.Name = "NeonUI"
		t6.value8.ResetOnSpawn = false
		t6.value8.DisplayOrder = 999999
		t5.value8 = t6.value8

		local value16 = t5.value1
		local value17 = t5.value1

		t5.value11 = value16
		t5.value9 = value17

		local gethui_ = gethui

		if gethui_ then
			gethui_ = gethui()
		end

		local value9 = t5.value9

		t5.value10 = gethui_
		t5.value1 = value9

		if not gethui_ then
			t5.value10 = CoreGui2
		end

		t5.value8.Parent = t5.value10
		t5.value1 = t5.value11
		t5.value10 = "Instance"

		local Instance_ = Instance

		t5.value12 = "\3\154N"
		t5.value14 = 11834303157638
		t5.value13 = 20848144983532
		t5.value8 = Instance_.new
		t5.value12 = ":\t\0249J"
		t5.value15 = 15288077474767
		t6.value9 = t5.value8("Frame")
		t6.value9.Name = "Window"

		local value92 = t6.value9
		local UDim2_ = UDim2

		t5.value17 = "\242<\224"
		t5.value13 = 0
		value92.Size = UDim2_.new(0, t6.value3, t5.value13, t5.value3)

		local value93 = t6.value9
		local UDim2_2 = UDim2

		t5.value14 = 0
		t5.value12 = 0
		t5.value15 = 29317142099283
		value93.Position = UDim2_2.new(0.5, t5.value12, 0.5, t5.value14)

		local value94 = t6.value9

		t5.value17 = "\31g\193"
		t5.value13 = 21057188734541
		t5.value11 = Vector2.new
		t5.value13 = 8229332766456
		t5.value12 = 0.5
		value94.AnchorPoint = t5.value11(0.5, t5.value12)

		local value95 = t6.value9

		t5.value13 = 23766198233915
		t5.value12 = "\169D\194#\175\187\161"
		value95.BackgroundTransparency = 1
		t6.value9.Visible = false
		t6.value9.Parent = t6.value8
		t5.value10 = Instance.new("UIScale")
		t6.value10 = t5.value10
		t6.value10.Scale = 0.92
		t6.value10.Parent = t6.value9
		t5.value11 = Instance.new("ImageLabel")
		t5.value18 = 29111237571827
		t5.value12 = "Vector2"

		local vector2New = Vector2.new

		t5.value12 = 0.5
		t5.value13 = 0.5
		t5.value11.AnchorPoint = vector2New(t5.value12, t5.value13)
		t5.value14 = 23712032451361
		t5.value13 = "\163) R:\238?F"
		t5.value9 = UDim2
		t5.value15 = "\143@\177"
		t5.value14 = 0.5

		local new = t5.value9.new

		t5.value17 = 6
		t5.value13 = 0
		t5.value12 = 0.5
		t5.value11.Position = new(t5.value12, t5.value13, t5.value14, t5.value17)

		local uDim2New = UDim2.new

		t5.value17 = 80
		t5.value12 = 1
		t5.value14 = 1
		t5.value13 = 80
		t5.value11.Size = uDim2New(t5.value12, t5.value13, t5.value14, t5.value17)
		t5.value17 = 25710253190852
		t5.value11.BackgroundTransparency = 1
		t5.value14 = 22066156431395
		t5.value13 = "\2400\146&\254"
		t5.value11.Image = "rbxassetid://6014261993"
		t5.value15 = "\195\20\217"
		t5.value13 = "\173\139\215\t72\147\130_q\19"

		local color3New = Color3.new

		t5.value12 = 0
		t5.value14 = 0
		t5.value13 = 0
		t5.value11.ImageColor3 = color3New(t5.value12, t5.value13, t5.value14)
		t5.value14 = 7114729491697
		t5.value13 = " J9\1916\n;\202S䧒\240\211\0266{"
		t5.value13 = "*i\255\155\1518\154\3k"
		t5.value11.ImageTransparency = 0.5
		t5.value11.ScaleType = Enum.ScaleType.Slice
		t5.value14 = 9051724451959
		t5.value13 = "e\240\179l\205s(e\200p\7"
		t5.value15 = "u\178S"
		t5.value12 = "Rect"

		local rectNew = Rect.new

		t5.value12 = 49
		t5.value13 = 49
		t5.value11.SliceCenter = rectNew(t5.value12, t5.value13, 450, 450)
		t5.value13 = "\27i \176=\141"
		t5.value16 = 20290493687016
		t5.value15 = 30870202578983
		t5.value14 = 9165421351083
		t5.value13 = "wϥ\16\177\223"
		t5.value11.ZIndex = 0
		t5.value11.Parent = t6.value9

		local Frame = Instance.new("Frame")

		t5.value17 = "ZSB\28"
		t5.value15 = 3915163240223
		Frame.Name = "Main"
		t5.value9 = UDim2.new
		t5.value13 = 1
		t5.value15 = 0
		t5.value14 = 0
		t5.value17 = 1
		Frame.Size = t5.value9(t5.value13, t5.value14, t5.value17, t5.value15)
		t5.value17 = 20871772562935
		t5.value14 = "\234\177\206\16\161\177\206 \165\155\131f^\245\27\249"
		Frame.BackgroundColor3 = value1.Background
		t5.value14 = "˓y\0\239\221\229\222C\134q:\211S\16"
		t5.value17 = 10160464695931
		t5.value14 = "nO\165\241\166\23\132.vz8J\21I\2084"
		t5.value17 = 27294883328422
		t5.value16 = "c\17\199"
		Frame.BorderSizePixel = 0
		Frame.ClipsDescendants = true
		Frame.Parent = t6.value9
		v35(Frame, 0.2)
		t5.value12 = 16
		t5.value14 = "Color3"

		local value122 = t5.value12
		local UICorner = Instance.new("UICorner")

		UICorner.CornerRadius = value122 == "full" and UDim.new(1, 0) or UDim.new(0, value122 or 10)
		UICorner.Parent = Frame
		t5.value10 = createUIStroke
		t5.value12 = Color3.new
		t5.value15 = 1
		t5.value17 = 1
		t5.value14 = 1
		t5.value13 = t5.value12(t5.value14, t5.value17, t5.value15)
		t5.value15 = "2\134\236"
		t5.value12 = 1
		t5.value14 = 0.86
		t5.value10(Frame, t5.value13, t5.value12, t5.value14)
		t5.value9 = Instance.new("TextButton")
		t6.value11 = t5.value9
		t5.value9 = t6.value11
		t5.value13 = UDim2.new
		t5.value17 = 0
		t5.value15 = 128
		t5.value9.Size = t5.value13(t5.value17, t5.value15, 0, 34)
		t5.value9 = t6.value11
		t5.value13 = UDim2.new
		t5.value16 = 12
		t5.value15 = -64
		t5.value17 = 0.5
		t5.value9.Position = t5.value13(t5.value17, t5.value15, 0, t5.value16)
		t6.value11.BackgroundColor3 = value1.Sidebar
		t6.value11.Text = "Fechar Hub"
		t6.value11.Font = t2.Bold
		t5.value9 = t6.value11
		t5.value13 = 13
		t5.value15 = "\232\22\158lq6J=\183\228"
		t5.value18 = 27242326733197
		t5.value9.TextSize = t5.value13
		t6.value11.TextColor3 = value1.Text
		t6.value11.AutoButtonColor = false
		t6.value11.Visible = false
		t6.value11.Parent = t6.value8
		v35(t6.value11, 0.25)

		local value11 = t6.value11
		local UICorner2 = Instance.new("UICorner")

		UICorner2.CornerRadius = UDim.new(1, 0) or UDim.new(0, "full")
		UICorner2.Parent = value11
		t5.value9 = createUIGradient
		t5.value13 = createUIStroke
		t5.value17 = t6.value11
		t5.value15 = Color3.new
		t5.value18 = 1
		t5.value16 = 1

		local v101 = t5.value15(t5.value16, 1, t5.value18)

		t5.value16 = 0.1
		t5.value15 = 1.5
		t5.value9(t5.value13(t5.value17, v101, t5.value15, t5.value16), 0)
		t5.value12 = v49(t6.value11, t6.value11)
		t6.value12 = t5.value12
		t6.value13 = nil

		local function value172(p28)
			t6.value13 = p28
			t6.value11.Text = p28 and "Fechar Hub" or "Abrir Hub"

			if p28 then
				t6.value10.Scale = 0.92
				t6.value9.Visible = true
				v38(t6.value10, {
					Scale = 1
				}, 0.22)

				return
			end

			v38(t6.value10, {
				Scale = 0.92
			}, 0.15)
			task.delay(0.16, function()
				if t6.value13 then
					return
				end

				t6.value9.Visible = false
			end)
		end

		t6.value13 = false
		t6.value14 = value14
		t6.value15 = false
		t6.value16 = 0
		t6.value17 = value172
		t6.value11.MouseButton1Click:Connect(function()
			if not (t6.value12.moved or t6.value14) then
				local v103 = not t6.value13

				t6.value17(v103)
			end
		end)
		UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed or (t6.value14 or t6.value15) then
				return
			end

			if os.clock() - t6.value16 < 0.25 then
				return
			end

			local v104

			if input.UserInputType == Enum.UserInputType.Keyboard then
				v104 = input.KeyCode == t6.value1
			else
				v104 = false
			end

			if not v104 then
				return
			end

			t6.value17(not t6.value13)
		end)
		t5.value16 = Instance.new("Frame")
		t5.value16.Size = UDim2.new(0, t6.value4, 1, 0)
		t5.value16.BackgroundColor3 = value1.Sidebar
		t5.value16.BorderSizePixel = 0
		t5.value16.Parent = Frame
		v35(t5.value16, 0.3)

		local Frame2 = Instance.new("Frame")

		Frame2.Size = UDim2.new(0, 1, 1, 0)
		Frame2.Position = UDim2.new(1, -1, 0, 0)
		Frame2.BackgroundColor3 = Color3.new(1, 1, 1)
		Frame2.BackgroundTransparency = 0.92
		Frame2.BorderSizePixel = 0
		Frame2.Parent = t5.value16
		t5.value18 = Instance.new("Frame")
		t5.value18.Size = UDim2.new(1, 0, 0, 68)
		t5.value18.BackgroundTransparency = 1
		t5.value18.Parent = t5.value16

		local Frame3 = Instance.new("Frame")

		Frame3.Size = UDim2.new(0, 34, 0, 34)
		Frame3.Position = UDim2.new(0, 14, 0, 17)
		Frame3.BackgroundColor3 = Color3.new(1, 1, 1)
		Frame3.BorderSizePixel = 0
		Frame3.Parent = t5.value18

		local UICorner3 = Instance.new("UICorner")

		UICorner3.CornerRadius = UDim.new(0, 10)
		UICorner3.Parent = Frame3

		local UIGradient = Instance.new("UIGradient")

		UIGradient.Color = ColorSequence.new(value1.Accent, value1.AccentLight)
		UIGradient.Rotation = 45
		UIGradient.Parent = Frame3

		local v109 = createTextLabel(Frame3, string.sub(Name, 1, 1), 17, t2.Bold, Color3.new(1, 1, 1))

		v109.Size = UDim2.new(1, 0, 1, 0)
		v109.TextXAlignment = Enum.TextXAlignment.Center

		local v110 = createTextLabel(t5.value18, Name, 14, t2.Bold, value1.Text)

		v110.Position = UDim2.new(0, 56, 0, Subtitle and 18 or 0)
		v110.Size = UDim2.new(1, -64, 0, Subtitle and 18 or 68)

		if Subtitle then
			local v111 = createTextLabel(t5.value18, Subtitle, 11, t2.Light, value1.SubText)

			t5.value19 = UDim2.new(0, 56, 0, 36)
			v111.Position = t5.value19
			t5.value19 = UDim2.new(1, -64, 0, 14)
			v111.Size = t5.value19
		end

		t6.value18 = Instance.new("ScrollingFrame")
		t6.value18.Position = UDim2.new(0, 0, 0, 68)
		t6.value18.Size = UDim2.new(1, 0, 1, -136)
		t6.value18.BackgroundTransparency = 1
		t6.value18.BorderSizePixel = 0
		t6.value18.ScrollBarThickness = 0
		t6.value18.CanvasSize = UDim2.new(0, 0, 0, 0)
		t6.value18.AutomaticCanvasSize = Enum.AutomaticSize.Y
		t6.value18.Parent = t5.value16

		local UIListLayout = Instance.new("UIListLayout")

		UIListLayout.Padding = UDim.new(0, 4)
		UIListLayout.Parent = t6.value18
		t5.value19 = Instance.new("UIPadding")
		t5.value19.PaddingLeft = UDim.new(0, 10)
		t5.value19.PaddingRight = UDim.new(0, 10)
		t5.value19.PaddingTop = UDim.new(0, 4)
		t5.value19.Parent = t6.value18

		local Frame4 = Instance.new("Frame")

		Frame4.Position = UDim2.new(0, 10, 1, -60)
		Frame4.Size = UDim2.new(1, -20, 0, 50)
		Frame4.BackgroundColor3 = value1.Card
		Frame4.BorderSizePixel = 0
		Frame4.Parent = t5.value16
		v35(Frame4, 0.42)

		local UICorner4 = Instance.new("UICorner")

		UICorner4.CornerRadius = UDim.new(0, 12)
		UICorner4.Parent = Frame4

		local color3 = Color3.new(1, 1, 1)
		local UIStroke = Instance.new("UIStroke")

		UIStroke.Color = color3
		UIStroke.Thickness = 1
		UIStroke.Transparency = 0.92
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke.Parent = Frame4
		t6.value19 = Instance.new("ImageLabel")
		t6.value19.Size = UDim2.new(0, 34, 0, 34)
		t6.value19.Position = UDim2.new(0, 8, 0.5, -17)
		t6.value19.BackgroundColor3 = value1.Off
		t6.value19.BorderSizePixel = 0
		t6.value19.Image = ""
		t6.value19.Parent = Frame4

		local value19 = t6.value19
		local UICorner5 = Instance.new("UICorner")

		UICorner5.CornerRadius = UDim.new(1, 0) or UDim.new(0, "full")
		UICorner5.Parent = value19
		t6.value20 = Players.LocalPlayer

		local v119 = createTextLabel(Frame4, t6.value20.DisplayName, 13, t2.Bold, value1.Text)

		v119.Position = UDim2.new(0, 50, 0, 8)
		v119.Size = UDim2.new(1, -56, 0, 17)

		local v120 = createTextLabel(Frame4, "@" .. t6.value20.Name, 11, t2.Light, value1.SubText)

		v120.Position = UDim2.new(0, 50, 0, 25)
		v120.Size = UDim2.new(1, -56, 0, 15)
		task.spawn(function()
			local ok, image = pcall(function()
				return Players:GetUserThumbnailAsync(t6.value20.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
			end)

			if ok then
				if image then
					ok = t6.value19.Parent
				else
					ok = image
				end
			end

			if not ok then
				return
			end

			t6.value19.Image = image
		end)
		t6.value21 = Instance.new("Frame")
		t6.value21.Position = UDim2.new(0, t6.value4, 0, 0)
		t6.value21.Size = UDim2.new(1, -t6.value4, 0, n2)
		t6.value21.BackgroundTransparency = 1
		t6.value21.Parent = Frame
		t6.value22 = createTextLabel(t6.value21, "", 20, t2.Bold, value1.Text)
		t6.value22.Position = UDim2.new(0, 22, 0, 0)
		t6.value22.Size = UDim2.new(1, -120, 1, 0)

		local function createTextButton(p29, p30)
			local TextButton = Instance.new("TextButton")

			TextButton.Size = UDim2.new(0, 30, 0, 30)
			TextButton.Position = UDim2.new(1, p30, 0.5, -15)
			TextButton.BackgroundColor3 = value1.Card
			TextButton.Text = p29
			TextButton.Font = t2.Bold
			TextButton.TextSize = 16
			TextButton.TextColor3 = value1.SubText
			TextButton.AutoButtonColor = false
			TextButton.Parent = t6.value21
			v35(TextButton, 0.45)

			local UICorner6 = Instance.new("UICorner")

			UICorner6.CornerRadius = UDim.new(0, 8)
			UICorner6.Parent = TextButton

			return TextButton
		end

		t6.value23 = createTextButton("-", -78)
		t6.value24 = createTextButton("x", -42)
		t6.value23.MouseEnter:Connect(function()
			v38(t6.value23, {
				BackgroundColor3 = value1.CardHover,
				TextColor3 = value1.Text
			}, 0.15)
		end)
		t6.value23.MouseLeave:Connect(function()
			v38(t6.value23, {
				BackgroundColor3 = value1.Card,
				TextColor3 = value1.SubText
			}, 0.15)
		end)
		t6.value23.MouseButton1Click:Connect(function()
			t6.value17(false)
		end)
		t6.value25 = false
		t6.value24.MouseEnter:Connect(function()
			v38(t6.value24, {
				BackgroundColor3 = Color3.fromRGB(200, 50, 70),
				TextColor3 = Color3.new(1, 1, 1)
			}, 0.15)
		end)
		t6.value24.MouseLeave:Connect(function()
			if t6.value25 then
				return
			end

			v38(t6.value24, {
				BackgroundColor3 = value1.Card,
				TextColor3 = value1.SubText
			}, 0.15)
		end)
		t6.value24.MouseButton1Click:Connect(function()
			if t6.value25 then
				t6.value8:Destroy()

				return
			end

			t6.value24.Text = "?"

			local function v126()
				if not t6.value24.Parent then
					return
				end

				t6.value24.Text = "x"
				v38(t6.value24, {
					BackgroundColor3 = value1.Card,
					TextColor3 = value1.SubText
				}, 0.15)
			end

			task.delay(2, v126)
		end)
		v49(t6.value21, t6.value9)
		v49(t5.value18, t6.value9)
		t6.value26 = Instance.new("Frame")
		t6.value26.Position = UDim2.new(0, t6.value4, 0, n2)
		t6.value26.Size = UDim2.new(1, -t6.value4, 1, -n2)
		t6.value26.BackgroundTransparency = 1
		t6.value26.Parent = Frame
		t6.value27 = Instance.new("Frame")
		t6.value27.Size = UDim2.new(0, 280, 1, -16)
		t6.value27.Position = UDim2.new(1, -296, 0, 0)
		t6.value27.BackgroundTransparency = 1
		t6.value27.Parent = t6.value8

		local UIListLayout2 = Instance.new("UIListLayout")

		UIListLayout2.Padding = UDim.new(0, 10)
		UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Bottom
		UIListLayout2.Parent = t6.value27

		local function notify(_, p31)
			local v129 = p31 or {}
			local Duration = v129.Duration or 3
			local CanvasGroup = Instance.new("CanvasGroup")

			CanvasGroup.Size = UDim2.new(1, 0, 0, 62)
			CanvasGroup.BackgroundColor3 = value1.Sidebar
			CanvasGroup.BackgroundTransparency = 0.12
			CanvasGroup.BorderSizePixel = 0
			CanvasGroup.GroupTransparency = 1
			CanvasGroup.Parent = t6.value27

			local UICorner6 = Instance.new("UICorner")

			UICorner6.CornerRadius = UDim.new(0, 12)
			UICorner6.Parent = CanvasGroup
			createUIStroke(CanvasGroup, Color3.new(1, 1, 1), 1, 0.86)

			local Frame5 = Instance.new("Frame")

			Frame5.Size = UDim2.new(0, 4, 1, -24)
			Frame5.Position = UDim2.new(0, 10, 0, 12)
			Frame5.BackgroundColor3 = Color3.new(1, 1, 1)
			Frame5.BorderSizePixel = 0
			Frame5.Parent = CanvasGroup

			local UICorner7 = Instance.new("UICorner")

			UICorner7.CornerRadius = UDim.new(1, 0) or UDim.new(0, "full")
			UICorner7.Parent = Frame5

			local UIGradient2 = Instance.new("UIGradient")

			UIGradient2.Color = ColorSequence.new(value1.Accent, value1.AccentLight)
			UIGradient2.Rotation = 90
			UIGradient2.Parent = Frame5

			local v136 = createTextLabel(CanvasGroup, v129.Title or "NeonUI", 14, t2.Bold, value1.Text)

			v136.Position = UDim2.new(0, 26, 0, 10)
			v136.Size = UDim2.new(1, -38, 0, 18)

			local v137 = createTextLabel(CanvasGroup, v129.Content or "", 12, t2.Light, value1.SubText)

			v137.Position = UDim2.new(0, 26, 0, 30)
			v137.Size = UDim2.new(1, -38, 0, 18)

			local Frame6 = Instance.new("Frame")

			Frame6.Size = UDim2.new(1, 0, 0, 2)
			Frame6.Position = UDim2.new(0, 0, 1, -2)
			Frame6.BackgroundColor3 = Color3.new(1, 1, 1)
			Frame6.BorderSizePixel = 0
			Frame6.Parent = CanvasGroup

			local UIGradient3 = Instance.new("UIGradient")

			UIGradient3.Color = ColorSequence.new(value1.Accent, value1.AccentLight)
			UIGradient3.Rotation = 0
			UIGradient3.Parent = Frame6
			v38(CanvasGroup, {
				GroupTransparency = 0
			}, 0.25)

			local v140 = TweenService
			local tweenInfo = TweenInfo.new(Duration, Enum.EasingStyle.Linear)
			local UDim2_3 = UDim2

			v140.Create(v140, Frame6, tweenInfo, {
				Size = UDim2_3.new(0, 0, 0, 2)
			}):Play()
			task.delay(Duration, function()
				v38(CanvasGroup, {
					GroupTransparency = 1
				}, 0.25)
				task.wait(0.3)
				CanvasGroup:Destroy()
			end)
		end

		t6.value5.Notify = notify

		function t6.value5.Toggle(_)
			t6.value17(not t6.value13)
		end
		function t6.value5.Destroy(_)
			t6.value8:Destroy()
		end
		function t6.value5.SetTransparency(_, p32)
			n1 = math.clamp(p32, 0, 0.6)

			for i = #t3, 1, -1 do
				local v144 = t3[i]

				if v144.obj.Parent then
					local obj = v144.obj
					local v146 = v144.base + n1

					obj.BackgroundTransparency = math.clamp(v146, 0, 0.95)
				else
					table.remove(t3, i)
				end
			end
		end
		function t6.value28()
			local writefile_ = writefile

			if not writefile_ then
				return writefile_
			end

			writefile_ = readfile and (isfile and makefolder)

			if not writefile_ then
				return writefile_
			end

			writefile_ = isfolder

			return writefile_
		end
		function t6.value29()
			if isfolder(t6.value2) then
				return
			end

			makefolder(t6.value2)
		end
		function t6.value30(p33)
			local v148 = tostring(p33 or ""):gsub("[^%w_%-]", "")

			return v148 == "" and "padrao" or v148
		end
		function t6.value5.SaveConfig(_, p34)
			if not t6.value28() then
				return false, "Seu executor não suporta salvar arquivos."
			end

			local configSalva = t6.value30(p34)
			local t7 = {}

			for k, v in pairs(t6.value7) do
				t7[k] = v.Get()
			end

			local t8 = { pcall(function()
					t6.value29()
					writefile(t6.value2 .. "/" .. configSalva .. ".json", HttpService2:JSONEncode(t7))
				end) }
			local v154 = t8[2]

			if t8[1] then
				return true, "Config salva: " .. configSalva
			else
				return false, "Erro ao salvar: " .. tostring(v154)
			end
		end
		function t6.value5.LoadConfig(_, p35)
			if not t6.value28() then
				return false, "Seu executor não suporta ler arquivos."
			end

			local configCarregada = t6.value30(p35)
			local v156 = t6.value2 .. "/" .. configCarregada .. ".json"

			if not isfile(v156) then
				return false, "Config não encontrada: " .. configCarregada
			end

			local function v157()
				return HttpService2:JSONDecode(unpack_({ readfile(v156) }))
			end

			local ok, result = pcall(v157)

			if not ok or type(result) ~= "table" then
				return false, "Arquivo de config inválido."
			else
				for k, v in pairs(result) do
					local v162 = t6.value7[k]

					if v162 then
						pcall(v162.Set, v)
					end
				end

				return true, "Config carregada: " .. configCarregada
			end
		end
		function t6.value5.DeleteConfig(_, p36)
			local delfile_ = t6.value28()
			local configApagada, v165

			if delfile_ then
			elseif delfile_ then
				configApagada = t6.value30(p36)
				v165 = t6.value2 .. "/" .. configApagada .. ".json"

				if isfile(v165) then
					pcall(delfile, v165)

					return true, "Config apagada: " .. configApagada
				else
					return false, "Config não encontrada: " .. configApagada
				end
			else
				return false, "Seu executor não suporta apagar arquivos."
			end

			delfile_ = delfile

			if delfile_ then
				configApagada = t6.value30(p36)
				v165 = t6.value2 .. "/" .. configApagada .. ".json"

				if isfile(v165) then
					pcall(delfile, v165)

					return true, "Config apagada: " .. configApagada
				else
					return false, "Config não encontrada: " .. configApagada
				end
			else
				return false, "Seu executor não suporta apagar arquivos."
			end
		end
		function t6.value5.ListConfigs(_)
			local t9 = {}
			local listfiles_ = listfiles

			if listfiles_ then
				listfiles_ = isfolder

				if listfiles_ then
					listfiles_ = isfolder(t6.value2)
				end
			end

			if not listfiles_ then
				return t9
			end

			local ok, result = pcall(listfiles, t6.value2)

			if not ok then
				return t9
			end

			for _, v in ipairs(result) do
				local match = tostring(v):match("([^/\\]+)%.json$")

				if match then
					table.insert(t9, match)
				end
			end

			return t9
		end
		function t6.value31()
			return t6.value2 .. "/autoload.txt"
		end

		local function v173()
			local v174 = t6.value28()

			if v174 then
				v174 = isfile(t6.value31())
			end

			if not v174 then
				return nil
			end

			local ok, result = pcall(readfile, t6.value31())

			if ok then
			elseif ok then
				return t6.value30(result)
			else
				return nil
			end

			if result then
				ok = result ~= ""
			else
				ok = result
			end

			if ok then
				return t6.value30(result)
			else
				return nil
			end
		end
		local function createTab(_, p37)
			local t10 = {}
			local t11 = {
				active = false
			}
			local TextButton = Instance.new("TextButton")

			TextButton.Size = UDim2.new(1, 0, 0, 38)
			TextButton.BackgroundColor3 = value1.Card
			TextButton.BackgroundTransparency = 1
			TextButton.Text = p37
			TextButton.Font = t2.Medium
			TextButton.TextSize = 14
			TextButton.TextColor3 = value1.SubText
			TextButton.TextXAlignment = Enum.TextXAlignment.Left
			TextButton.AutoButtonColor = false
			TextButton.Parent = t6.value18

			local UICorner6 = Instance.new("UICorner")

			UICorner6.CornerRadius = UDim.new(0, 10)
			UICorner6.Parent = TextButton

			local UIPadding = Instance.new("UIPadding")

			UIPadding.PaddingLeft = UDim.new(0, 16)
			UIPadding.Parent = TextButton

			local Frame5 = Instance.new("Frame")

			Frame5.Size = UDim2.new(0, 3, 0.5, 0)
			Frame5.Position = UDim2.new(0, -13, 0.25, 0)
			Frame5.BackgroundColor3 = Color3.new(1, 1, 1)
			Frame5.BorderSizePixel = 0
			Frame5.Visible = false
			Frame5.Parent = TextButton

			local UICorner7 = Instance.new("UICorner")

			UICorner7.CornerRadius = UDim.new(1, 0) or UDim.new(0, "full")
			UICorner7.Parent = Frame5

			local UIGradient2 = Instance.new("UIGradient")

			UIGradient2.Color = ColorSequence.new(value1.Accent, value1.AccentLight)
			UIGradient2.Rotation = 90
			UIGradient2.Parent = Frame5

			local ScrollingFrame = Instance.new("ScrollingFrame")

			ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
			ScrollingFrame.BackgroundTransparency = 1
			ScrollingFrame.BorderSizePixel = 0
			ScrollingFrame.ScrollBarThickness = 3
			ScrollingFrame.ScrollBarImageColor3 = value1.Accent
			ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
			ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
			ScrollingFrame.Visible = false
			ScrollingFrame.Parent = t6.value26

			local UIListLayout3 = Instance.new("UIListLayout")

			UIListLayout3.Padding = UDim.new(0, 8)
			UIListLayout3.Parent = ScrollingFrame

			local UIPadding2 = Instance.new("UIPadding")

			UIPadding2.PaddingTop = UDim.new(0, 4)
			UIPadding2.PaddingBottom = UDim.new(0, 16)
			UIPadding2.PaddingLeft = UDim.new(0, 22)
			UIPadding2.PaddingRight = UDim.new(0, 22)
			UIPadding2.Parent = ScrollingFrame

			function t11.activate()
				t11.active = true
				ScrollingFrame.Visible = true
				Frame5.Visible = true
				t6.value22.Text = p37
				v38(TextButton, {
					BackgroundTransparency = 0.4,
					TextColor3 = value1.Text
				}, 0.2)
			end
			function t11.deactivate()
				t11.active = false
				ScrollingFrame.Visible = false
				Frame5.Visible = false
				v38(TextButton, {
					BackgroundTransparency = 1,
					TextColor3 = value1.SubText
				}, 0.2)
			end

			local value6 = t6.value6

			table.insert(value6, t11)
			TextButton.MouseButton1Click:Connect(function()
				for _, v in ipairs(t6.value6) do
					v.deactivate()
				end

				t11.activate()
			end)
			TextButton.MouseEnter:Connect(function()
				if t11.active then
					return
				end

				v38(TextButton, {
					TextColor3 = value1.Text
				}, 0.15)
			end)
			TextButton.MouseLeave:Connect(function()
				if t11.active then
					return
				end

				v38(TextButton, {
					TextColor3 = value1.SubText
				}, 0.15)
			end)

			if #t6.value6 == 1 then
				t11.activate()
			end

			function t10.CreateSection(_, p38)
				local Frame6 = Instance.new("Frame")

				Frame6.Size = UDim2.new(1, 0, 0, 30)
				Frame6.BackgroundTransparency = 1
				Frame6.Parent = ScrollingFrame

				local Frame7 = Instance.new("Frame")

				Frame7.Size = UDim2.new(0, 3, 0, 14)
				Frame7.Position = UDim2.new(0, 2, 0.5, -7)
				Frame7.BackgroundColor3 = Color3.new(1, 1, 1)
				Frame7.BorderSizePixel = 0
				Frame7.Parent = Frame6

				local UICorner8 = Instance.new("UICorner")

				UICorner8.CornerRadius = UDim.new(1, 0) or UDim.new(0, "full")
				UICorner8.Parent = Frame7

				local UIGradient3 = Instance.new("UIGradient")

				UIGradient3.Color = ColorSequence.new(value1.Accent, value1.AccentLight)
				UIGradient3.Rotation = 90
				UIGradient3.Parent = Frame7

				local v196 = createTextLabel(Frame6, p38, 13, t2.Bold, value1.Text)

				v196.Position = UDim2.new(0, 14, 0, 0)
				v196.Size = UDim2.new(1, -14, 1, 0)
			end
			function t10.CreateParagraph(_, p39)
				local Content = p39.Content or ""
				local v198 = t6.value3 - t6.value4 - 44 - 32
				local v199 = math.max(120, v198)
				local textSize = TextService:GetTextSize(Content, 12, t2.Light, Vector2.new(v199, 10000))
				local v201 = v57(ScrollingFrame, 46 + textSize.Y)
				local v202 = createTextLabel(v201, p39.Title or "", 14, t2.Bold, value1.Text)

				v202.Position = UDim2.new(0, 16, 0, 10)
				v202.Size = UDim2.new(1, -32, 0, 20)

				local v203 = createTextLabel(v201, Content, 12, t2.Light, value1.SubText)

				v203.Position = UDim2.new(0, 16, 0, 34)
				v203.Size = UDim2.new(1, -32, 0, textSize.Y)
				v203.TextWrapped = true
				v203.TextTruncate = Enum.TextTruncate.None
				v203.TextYAlignment = Enum.TextYAlignment.Top
			end
			function t10.CreateCredit(_, p40)
				local v204 = v57(ScrollingFrame, 62)
				local ImageLabel = Instance.new("ImageLabel")

				ImageLabel.Size = UDim2.new(0, 38, 0, 38)
				ImageLabel.Position = UDim2.new(0, 14, 0.5, -19)
				ImageLabel.BackgroundColor3 = Color3.new(1, 1, 1)
				ImageLabel.BorderSizePixel = 0
				ImageLabel.Image = ""
				ImageLabel.Parent = v204

				local UICorner8 = Instance.new("UICorner")

				UICorner8.CornerRadius = UDim.new(1, 0) or UDim.new(0, "full")
				UICorner8.Parent = ImageLabel

				local UIGradient3 = Instance.new("UIGradient")

				UIGradient3.Color = ColorSequence.new(value1.Accent, value1.AccentLight)
				UIGradient3.Rotation = 45
				UIGradient3.Parent = ImageLabel

				if p40.UserId then
					task.spawn(function()
						local function v208()
							return Players:GetUserThumbnailAsync(p40.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
						end

						local ok, image = pcall(v208)

						if ok then
							if image then
								ok = ImageLabel.Parent
							else
								ok = image
							end
						end

						if not ok then
							return
						end

						ImageLabel.Image = image
					end)
				else
					local v211 = createTextLabel(ImageLabel, string.upper(string.sub(p40.Name or "?", 1, 1)), 16, t2.Bold, Color3.new(1, 1, 1))

					v211.Size = UDim2.new(1, 0, 1, 0)
					v211.TextXAlignment = Enum.TextXAlignment.Center
				end

				local v212 = createTextLabel(v204, p40.Name or "", 14, t2.Bold, value1.Text)

				v212.Position = UDim2.new(0, 64, 0, 12)
				v212.Size = UDim2.new(1, -76, 0, 20)

				local v213 = createTextLabel(v204, p40.Role or "", 12, t2.Light, value1.SubText)

				v213.Position = UDim2.new(0, 64, 0, 33)
				v213.Size = UDim2.new(1, -76, 0, 18)
			end
			function t10.CreateInput(_, p41)
				local v214 = v57
				local v215 = ScrollingFrame
				local n3 = 50
				local n4 = 64
				local v218

				if p41.Description == nil then
					v218 = false
				else
					v218 = p41.Description ~= ""
				end

				if v218 then
					n3 = n4
				end

				local v219 = v214(v215, n3)

				v62(v219, p41, 176)

				local TextBox = Instance.new("TextBox")

				TextBox.Size = UDim2.new(0, 130, 0, 28)
				TextBox.Position = UDim2.new(1, -144, 0.5, -14)
				TextBox.BackgroundColor3 = value1.Background
				TextBox.BackgroundTransparency = 0.2
				TextBox.Text = p41.Default or ""
				TextBox.PlaceholderText = p41.Placeholder or ""
				TextBox.PlaceholderColor3 = value1.SubText
				TextBox.TextColor3 = value1.Text
				TextBox.Font = t2.Medium
				TextBox.TextSize = 13
				TextBox.ClearTextOnFocus = false
				TextBox.TextXAlignment = Enum.TextXAlignment.Left
				TextBox.Parent = v219

				local UICorner8 = Instance.new("UICorner")

				UICorner8.CornerRadius = UDim.new(0, 8)
				UICorner8.Parent = TextBox

				local color32 = Color3.new(1, 1, 1)
				local UIStroke2 = Instance.new("UIStroke")

				UIStroke2.Color = color32
				UIStroke2.Thickness = 1
				UIStroke2.Transparency = 0.9
				UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				UIStroke2.Parent = TextBox

				local UIPadding3 = Instance.new("UIPadding")

				UIPadding3.PaddingLeft = UDim.new(0, 8)
				UIPadding3.PaddingRight = UDim.new(0, 8)
				UIPadding3.Parent = TextBox
				TextBox.FocusLost:Connect(function()
					if not p41.Callback then
						return
					end

					task.spawn(p41.Callback, TextBox.Text)
				end)

				return {
					Get = function(_)
						return TextBox.Text
					end,
					Set = function(_, p42)
						TextBox.Text = tostring(p42)
					end
				}
			end
			function t10.CreateKeybind(_, p43)
				local Default = p43.Default or Enum.KeyCode.RightShift
				local v226 = v57
				local v227 = ScrollingFrame
				local n5 = 50
				local n6 = 64
				local v230

				if p43.Description == nil then
					v230 = false
				else
					v230 = p43.Description ~= ""
				end

				if v230 then
					n5 = n6
				end

				local v231 = v226(v227, n5)

				v62(v231, p43, 170)

				local TextButton2 = Instance.new("TextButton")

				TextButton2.Size = UDim2.new(0, 120, 0, 28)
				TextButton2.Position = UDim2.new(1, -134, 0.5, -14)
				TextButton2.BackgroundColor3 = value1.Background
				TextButton2.BackgroundTransparency = 0.2
				TextButton2.Text = Default.Name
				TextButton2.Font = t2.Bold
				TextButton2.TextSize = 12
				TextButton2.TextColor3 = value1.Accent
				TextButton2.AutoButtonColor = false
				TextButton2.Parent = v231

				local UICorner8 = Instance.new("UICorner")

				UICorner8.CornerRadius = UDim.new(0, 8)
				UICorner8.Parent = TextButton2

				local Accent = value1.Accent
				local UIStroke2 = Instance.new("UIStroke")

				UIStroke2.Color = Accent
				UIStroke2.Thickness = 1
				UIStroke2.Transparency = 0.6
				UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				UIStroke2.Parent = TextButton2

				local t12 = {
					Get = function(_)
						return Default
					end,
					Set = function(_, p44)
						if typeof(p44) == "string" then
							local ok, result = pcall(function()
								return Enum.KeyCode[p44]
							end)

							if not (ok and result) then
								return
							end

							local v239 = result

							p44 = v239
						end

						if typeof(p44) ~= "EnumItem" then
							return
						end

						Default = p44
						TextButton2.Text = Default.Name

						if not p43.Callback then
							return
						end

						task.spawn(p43.Callback, Default)
					end
				}

				TextButton2.MouseButton1Click:Connect(function()
					TextButton2.Text = "Aperte uma tecla..."
					v38(UIStroke2, {
						Transparency = 0
					}, 0.15)

					local connection = nil

					connection = UserInputService.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.Keyboard then
							if input.KeyCode == Enum.KeyCode.Unknown then
								return
							else
								connection:Disconnect()
								os.clock()
								v38(UIStroke2, {
									Transparency = 0.6
								}, 0.15)

								if input.KeyCode == Enum.KeyCode.Escape then
									TextButton2.Text = Default.Name

									return
								else
									t12:Set(input.KeyCode)

									return
								end
							end
						end
					end)
				end)

				if not p43.Flag then
					return t12
				end

				t6.value7[p43.Flag] = {
					Get = function()
						return Default.Name
					end,
					Set = function(p45)
						t12:Set(p45)
					end
				}

				return t12
			end
			function t10.CreateDropdown(_, p46)
				local Options = p46.Options or {}
				local Default = p46.Default or Options[1]
				local n7 = 50
				local n8 = 64
				local v245

				if p46.Description == nil then
					v245 = false
				else
					v245 = p46.Description ~= ""
				end

				if v245 then
					n7 = n8
				end

				local v246 = v57(ScrollingFrame, n7)

				v246.ClipsDescendants = true
				v62(v246, p46, 190)

				local TextButton2 = Instance.new("TextButton")

				TextButton2.Size = UDim2.new(0, 150, 0, 28)

				local uDim2New2 = UDim2.new
				local v249 = (n7 - 28) / 2

				TextButton2.Position = uDim2New2(1, -164, 0, (math.floor(v249)))
				TextButton2.BackgroundColor3 = value1.Background
				TextButton2.BackgroundTransparency = 0.2
				TextButton2.Font = t2.Medium
				TextButton2.TextSize = 12
				TextButton2.TextColor3 = value1.Text
				TextButton2.AutoButtonColor = false
				TextButton2.Text = ""
				TextButton2.Parent = v246

				local UICorner8 = Instance.new("UICorner")

				UICorner8.CornerRadius = UDim.new(0, 8)
				UICorner8.Parent = TextButton2
				createUIStroke(TextButton2, Color3.new(1, 1, 1), 1, 0.9)

				local Frame6 = Instance.new("Frame")

				Frame6.Position = UDim2.new(0, 12, 0, n7)
				Frame6.Size = UDim2.new(1, -24, 0, 0)
				Frame6.BackgroundTransparency = 1
				Frame6.Parent = v246

				local UIListLayout4 = Instance.new("UIListLayout")

				UIListLayout4.Padding = UDim.new(0, 4)
				UIListLayout4.Parent = Frame6

				local t13 = {}
				local t14 = {}
				local u255 = false

				local function v256()
					return #Options * 36
				end
				local function v257()
					local v258

					if Default == nil then
						v258 = false
					else
						local v259 = Default

						v258 = tostring(v259)
					end

					TextButton2.Text = (v258 or "Nenhuma") .. "  v"

					for k, v in pairs(t13) do
						v.TextColor3 = k == Default and value1.Accent or value1.Text
					end
				end
				local function v262(p47)
					u255 = p47

					local v263 = n7

					if p47 then
						p47 = #Options > 0
					end

					if not p47 then
						v38(v246, {
							Size = UDim2.new(1, 0, 0, v263)
						}, 0.2)

						return
					end

					v263 = n7 + #Options * 36 + 10
					v38(v246, {
						Size = UDim2.new(1, 0, 0, v263)
					}, 0.2)
				end
				local function v264()
					for _, v in pairs(t13) do
						v:Destroy()
					end

					t13 = {}
					Frame6.Size = UDim2.new(1, -24, 0, v256())

					for _, Option in ipairs(Options) do
						local TextButton3 = Instance.new("TextButton")

						TextButton3.Size = UDim2.new(1, 0, 0, 32)
						TextButton3.BackgroundColor3 = value1.Background
						TextButton3.BackgroundTransparency = 0.35
						TextButton3.Text = tostring(Option)
						TextButton3.Font = t2.Medium
						TextButton3.TextSize = 13
						TextButton3.TextColor3 = value1.Text
						TextButton3.AutoButtonColor = false
						TextButton3.Parent = Frame6

						local UICorner9 = Instance.new("UICorner")

						UICorner9.CornerRadius = UDim.new(0, 8)
						UICorner9.Parent = TextButton3
						t13[Option] = TextButton3
						TextButton3.MouseEnter:Connect(function()
							v38(TextButton3, {
								BackgroundTransparency = 0.1
							}, 0.12)
						end)
						TextButton3.MouseLeave:Connect(function()
							v38(TextButton3, {
								BackgroundTransparency = 0.35
							}, 0.12)
						end)

						local MouseButton1Click = TextButton3.MouseButton1Click

						local function v272()
							t14:Set(Option)
							v262(false)
						end

						MouseButton1Click.Connect(MouseButton1Click, v272)
					end
				end

				function t14.Get(_)
					return Default
				end
				function t14.Set(_, p48)
					if not table.find(Options, p48) then
						return
					end

					Default = p48
					v257()

					if not p46.Callback then
						return
					end

					task.spawn(p46.Callback, Default)
				end
				function t14.SetOptions(_, p49)
					Options = p49 or {}

					if Default == nil and true or not table.find(Options, Default) then
						Default = Options[1]
					end

					v264()
					v257()

					if not u255 then
						return
					end

					v262(true)
				end

				TextButton2.MouseButton1Click:Connect(function()
					v262(not u255)
				end)

				if not p46.Flag then
					v264()
					v257()

					return t14
				end

				t6.value7[p46.Flag] = {
					Get = function()
						return Default
					end,
					Set = function(p50)
						t14:Set(p50)
					end
				}
				v264()
				v257()

				return t14
			end
			function t10.CreateButton(_, p51)
				local v273 = v57
				local v274 = ScrollingFrame
				local n9 = 50
				local n10 = 64
				local v277

				if p51.Description == nil then
					v277 = false
				else
					v277 = p51.Description ~= ""
				end

				if v277 then
					n9 = n10
				end

				local v278 = v273(v274, n9)

				v62(v278, p51, 56)

				local v279 = createTextLabel(v278, ">", 16, t2.Bold, value1.SubText)

				v279.Size = UDim2.new(0, 24, 1, 0)
				v279.Position = UDim2.new(1, -36, 0, 0)
				v279.TextXAlignment = Enum.TextXAlignment.Center

				local TextButton2 = Instance.new("TextButton")

				TextButton2.Size = UDim2.new(1, 0, 1, 0)
				TextButton2.BackgroundTransparency = 1
				TextButton2.Text = ""
				TextButton2.AutoButtonColor = false
				TextButton2.Parent = v278
				TextButton2.MouseEnter:Connect(function()
					v38(v279, {
						TextColor3 = value1.Accent
					}, 0.15)
				end)
				TextButton2.MouseLeave:Connect(function()
					v38(v279, {
						TextColor3 = value1.SubText
					}, 0.15)
				end)

				local function v281()
					v38(v278, {
						BackgroundColor3 = value1.Accent
					}, 0.08)

					local function v282()
						v38(v278, {
							BackgroundColor3 = value1.Card
						}, 0.3)
					end

					task.delay(0.1, v282)

					if not p51.Callback then
						return
					end

					task.spawn(p51.Callback)
				end

				TextButton2.MouseButton1Click:Connect(v281)
			end
			function t10.CreateToggle(_, p52)
				local n11 = 50
				local Default = p52.Default or false
				local v285 = v57
				local v286 = ScrollingFrame
				local n12 = 64
				local v288

				if p52.Description == nil then
					v288 = false
				else
					v288 = p52.Description ~= ""
				end

				if v288 then
					n11 = n12
				end

				local v289 = v285(v286, n11)

				v62(v289, p52, 84)

				local Frame6 = Instance.new("Frame")

				Frame6.Size = UDim2.new(0, 44, 0, 24)
				Frame6.Position = UDim2.new(1, -58, 0.5, -12)
				Frame6.BackgroundColor3 = value1.Off
				Frame6.BorderSizePixel = 0
				Frame6.Parent = v289

				local UICorner8 = Instance.new("UICorner")

				UICorner8.CornerRadius = UDim.new(1, 0) or UDim.new(0, "full")
				UICorner8.Parent = Frame6

				local UIGradient3 = Instance.new("UIGradient")

				UIGradient3.Color = ColorSequence.new(value1.Accent, value1.AccentLight)
				UIGradient3.Rotation = 0
				UIGradient3.Parent = Frame6
				UIGradient3.Enabled = false

				local Frame7 = Instance.new("Frame")

				Frame7.Size = UDim2.new(0, 18, 0, 18)
				Frame7.Position = UDim2.new(0, 3, 0.5, -9)
				Frame7.BackgroundColor3 = Color3.new(1, 1, 1)
				Frame7.BorderSizePixel = 0
				Frame7.Parent = Frame6

				local UICorner9 = Instance.new("UICorner")

				UICorner9.CornerRadius = UDim.new(1, 0) or UDim.new(0, "full")
				UICorner9.Parent = Frame7

				local TextButton2 = Instance.new("TextButton")

				TextButton2.Size = UDim2.new(1, 0, 1, 0)
				TextButton2.BackgroundTransparency = 1
				TextButton2.Text = ""
				TextButton2.Parent = v289

				local function v296()
					if Default then
						UIGradient3.Enabled = true
						v38(Frame6, {
							BackgroundColor3 = Color3.new(1, 1, 1)
						}, 0.2)
						v38(Frame7, {
							Position = UDim2.new(1, -21, 0.5, -9)
						}, 0.2)
					else
						UIGradient3.Enabled = false
						v38(Frame6, {
							BackgroundColor3 = value1.Off
						}, 0.2)
						v38(Frame7, {
							Position = UDim2.new(0, 3, 0.5, -9)
						}, 0.2)
					end
				end

				local t15 = {
					Set = function(_, p53)
						Default = p53 and true or false
						v296()

						if not p52.Callback then
							return
						end

						task.spawn(p52.Callback, Default)
					end
				}

				TextButton2.MouseButton1Click:Connect(function()
					local v298 = t15

					v298.Set(v298, not Default)
				end)

				if not p52.Flag then
					v296()

					return t15
				end

				t6.value7[p52.Flag] = {
					Get = function()
						return Default
					end,
					Set = function(p54)
						t15:Set(p54)
					end
				}
				v296()

				return t15
			end
			function t10.CreateSlider(_, p55)
				local v299 = p55.Range[1]
				local v300 = p55.Range[2]
				local Increment = p55.Increment or 1
				local u302 = math.clamp(p55.Default or v299, v299, v300)
				local v303 = v57(ScrollingFrame, 68)
				local v304 = createTextLabel(v303, p55.Name, 14, t2.Medium, value1.Text)

				v304.Position = UDim2.new(0, 16, 0, 10)
				v304.Size = UDim2.new(1, -100, 0, 22)

				local Frame6 = Instance.new("Frame")

				Frame6.Size = UDim2.new(0, 54, 0, 24)
				Frame6.Position = UDim2.new(1, -70, 0, 9)
				Frame6.BackgroundColor3 = value1.Background
				Frame6.BackgroundTransparency = 0.25
				Frame6.BorderSizePixel = 0
				Frame6.Parent = v303

				local UICorner8 = Instance.new("UICorner")

				UICorner8.CornerRadius = UDim.new(0, 8)
				UICorner8.Parent = Frame6

				local color32 = Color3.new(1, 1, 1)
				local UIStroke2 = Instance.new("UIStroke")

				UIStroke2.Color = color32
				UIStroke2.Thickness = 1
				UIStroke2.Transparency = 0.9
				UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				UIStroke2.Parent = Frame6

				local v309 = createTextLabel(Frame6, tostring(u302), 13, t2.Bold, value1.Text)

				v309.Size = UDim2.new(1, 0, 1, 0)
				v309.TextXAlignment = Enum.TextXAlignment.Center

				local Frame7 = Instance.new("Frame")

				Frame7.Position = UDim2.new(0, 16, 0, 50)
				Frame7.Size = UDim2.new(1, -32, 0, 6)
				Frame7.BackgroundColor3 = value1.Background
				Frame7.BackgroundTransparency = 0.2
				Frame7.BorderSizePixel = 0
				Frame7.Parent = v303

				local UICorner9 = Instance.new("UICorner")

				UICorner9.CornerRadius = UDim.new(1, 0) or UDim.new(0, "full")
				UICorner9.Parent = Frame7

				local Frame8 = Instance.new("Frame")

				Frame8.Size = UDim2.new(0, 0, 1, 0)
				Frame8.BackgroundColor3 = Color3.new(1, 1, 1)
				Frame8.BorderSizePixel = 0
				Frame8.Parent = Frame7

				local UICorner10 = Instance.new("UICorner")

				UICorner10.CornerRadius = UDim.new(1, 0) or UDim.new(0, "full")
				UICorner10.Parent = Frame8

				local UIGradient3 = Instance.new("UIGradient")

				UIGradient3.Color = ColorSequence.new(value1.Accent, value1.AccentLight)
				UIGradient3.Rotation = 0
				UIGradient3.Parent = Frame8

				local Frame9 = Instance.new("Frame")

				Frame9.Size = UDim2.new(0, 16, 0, 16)
				Frame9.AnchorPoint = Vector2.new(0.5, 0.5)
				Frame9.Position = UDim2.new(0, 0, 0.5, 0)
				Frame9.BackgroundColor3 = Color3.new(1, 1, 1)
				Frame9.BorderSizePixel = 0
				Frame9.Parent = Frame7

				local UICorner11 = Instance.new("UICorner")

				UICorner11.CornerRadius = UDim.new(1, 0) or UDim.new(0, "full")
				UICorner11.Parent = Frame9

				local Accent = value1.Accent
				local UIStroke3 = Instance.new("UIStroke")

				UIStroke3.Color = Accent
				UIStroke3.Thickness = 2
				UIStroke3.Transparency = 0
				UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				UIStroke3.Parent = Frame9

				local TextButton2 = Instance.new("TextButton")

				TextButton2.Position = UDim2.new(0, 10, 0, 38)
				TextButton2.Size = UDim2.new(1, -20, 0, 30)
				TextButton2.BackgroundTransparency = 1
				TextButton2.Text = ""
				TextButton2.Parent = v303

				local t16 = {
					Set = function(_, p56)
						local v321 = tonumber(p56)

						if not v321 then
							return
						end

						local v322 = v299
						local v323 = v300
						local v324 = math.clamp(v321, v322, v323) / Increment + 0.5
						local v325 = math.floor(v324) * Increment
						local format = string.format
						local v327 = tonumber(format("%.3f", v325))
						local v328 = math.clamp(v327, v299, v300)

						if v328 == u302 then
							return
						end

						u302 = v328

						local v329 = (u302 - v299) / (v300 - v299)

						Frame8.Size = UDim2.new(v329, 0, 1, 0)
						Frame9.Position = UDim2.new(v329, 0, 0.5, 0)

						local v330 = u302

						v309.Text = tostring(v330)

						if not p55.Callback then
							return
						end

						task.spawn(p55.Callback, u302)
					end
				}

				local function v331(p57)
					local v332 = math.clamp((p57 - Frame7.AbsolutePosition.X) / Frame7.AbsoluteSize.X, 0, 1)

					t16:Set(v299 + (v300 - v299) * v332)
				end

				local u333 = false

				TextButton2.InputBegan:Connect(function(input)
					if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
						return
					end

					u333 = true
					ScrollingFrame.ScrollingEnabled = false
					v38(Frame9, {
						Size = UDim2.new(0, 22, 0, 22)
					}, 0.12)
					v331(input.Position.X)
				end)
				UserInputService.InputChanged:Connect(function(input)
					local v334 = u333

					if v334 then
						v334 = input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch
					end

					if not v334 then
						return
					end

					v331(input.Position.X)
				end)
				UserInputService.InputEnded:Connect(function(input)
					local v335 = u333

					if v335 then
						v335 = input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch
					end

					if not v335 then
						return
					end

					ScrollingFrame.ScrollingEnabled = true
					v38(Frame9, {
						Size = UDim2.new(0, 16, 0, 16)
					}, 0.12)
				end)

				if not p55.Flag then
					v396 = (u302 - v299) / (v300 - v299)
					Frame8.Size = UDim2.new(v396, 0, 1, 0)
					Frame9.Position = UDim2.new(v396, 0, 0.5, 0)
					v309.Text = tostring(u302)

					return t16
				end

				t6.value7[p55.Flag] = {
					Get = function()
						return u302
					end,
					Set = function(p58)
						t16:Set(p58)
					end
				}

				local v336 = (u302 - v299) / (v300 - v299)

				Frame8.Size = UDim2.new(v336, 0, 1, 0)
				Frame9.Position = UDim2.new(v336, 0, 0.5, 0)
				v309.Text = tostring(u302)

				return t16
			end

			return t10
		end

		t6.value5.CreateTab = createTab

		function t6.value5.CreateCreditsTab(_, p59)
			local v337 = p59 or {}
			local v338 = t6.value5:CreateTab(v337.TabName or "Créditos")

			v338:CreateSection(v337.Section or "Equipe")

			local v339, v340, v341 = ipairs(v337.Credits or {})

			while true do
				local v342

				v341, v342 = v339(v340, v341)

				if not v341 then
					break
				end

				v338:CreateCredit(v342)
			end

			local Links = v337.Links

			if Links then
				Links = #v337.Links > 0
			end

			if Links then
				v338:CreateSection("Links")

				for _, link in ipairs(v337.Links) do
					local t17 = {
						Name = link.Name,
						Description = link.Description or "Toque para copiar o link",
						Callback = function()
							if setclipboard then
								setclipboard(link.Url)

								local value5 = t6.value5
								local t18 = {
									Title = "Link copiado",
									Content = link.Name,
									Duration = 2
								}

								value5.Notify(value5, t18)
							else
								t6.value5:Notify({
									Title = link.Name,
									Content = link.Url,
									Duration = 5
								})
							end
						end
					}

					v338.CreateButton(v338, t17)
				end
			end

			if not v337.About then
				return v338
			end

			v338:CreateSection("Sobre")
			v338.CreateParagraph(v338, {
				Title = v337.About.Title,
				Content = v337.About.Content
			})

			return v338
		end

		local function createSettingsTab(_)
			local v350 = t6.value5:CreateTab("Configurações")

			v350:CreateSection("Configuração")

			local t19 = {
				Name = "Nome da config",
				Description = "Só letras e números",
				Default = v173() or "padrao",
				Placeholder = "padrao"
			}
			local v352 = v350.CreateInput(v350, t19)

			local function v353()
				local v354 = v352
				local Get = v354.Get

				return t6.value30(Get(v354))
			end

			local t20 = {
				Name = "Salvar config",
				Description = "Salva todas as opções do hub",
				Callback = function()
					local _, v358 = t6.value5:SaveConfig(unpack_({ v353() }))

					t6.value5:Notify({
						Title = "Configurações",
						Content = v358,
						Duration = 3
					})
				end
			}

			v350.CreateButton(v350, t20)

			local t21 = {
				Name = "Carregar config",
				Description = "Aplica a config com esse nome",
				Callback = function()
					local _, v361 = t6.value5:LoadConfig(unpack_({ v353() }))

					t6.value5:Notify({
						Title = "Configurações",
						Content = v361,
						Duration = 3
					})
				end
			}

			v350.CreateButton(v350, t21)

			local t22 = {
				Name = "Apagar config",
				Description = "Remove a config com esse nome",
				Callback = function()
					local _, v364 = t6.value5:DeleteConfig(unpack_({ v353() }))

					t6.value5:Notify({
						Title = "Configurações",
						Content = v364,
						Duration = 3
					})
				end
			}

			v350.CreateButton(v350, t22)

			local t23 = {
				Name = "Listar configs",
				Description = "Mostra as configs salvas",
				Callback = function()
					local v366 = t6.value5:ListConfigs()
					local v367

					if #v366 > 0 then
						v367 = table.concat(v366, ", ")
					else
						v367 = false
					end

					t6.value5:Notify({
						Title = "Configs salvas",
						Content = v367 or "Nenhuma config salva.",
						Duration = 4
					})
				end
			}

			v350.CreateButton(v350, t23)
			v350.CreateToggle(v350, {
				Name = "Carregar automaticamente",
				Description = "Carrega essa config ao abrir o hub",
				Default = v173() ~= nil,
				Callback = function(p60)
					if not t6.value28() then
						t6.value5:Notify({
							Title = "Configurações",
							Content = "Seu executor não suporta salvar arquivos.",
							Duration = 3
						})

						return
					end

					local function v368()
						if p60 then
							t6.value29()
							writefile(t6.value31(), v353())

							return
						end

						local delfile_ = isfile(t6.value31())

						if delfile_ then
							delfile_ = delfile
						end

						if not delfile_ then
							return
						end

						delfile(t6.value31())
					end

					pcall(v368)
				end
			})
			v350:CreateSection("Interface")

			local t24 = {
				Name = "Tecla para abrir/fechar",
				Description = "Clique e aperte uma tecla (evite W, A, S, D)",
				Default = t6.value1,
				Flag = "NeonUI_ToggleKey",
				Callback = function(p61)
					t6.value1 = p61

					local value5 = t6.value5

					value5.Notify(value5, {
						Title = "Tecla alterada",
						Content = "Abrir/fechar: " .. p61.Name,
						Duration = 2
					})
				end
			}

			v350.CreateKeybind(v350, t24)

			local t25 = {
				Name = "Transparência da janela",
				Range = { 0, 60 },
				Increment = 5,
				Default = 0,
				Flag = "NeonUI_Transparency",
				Callback = function(p62)
					t6.value5:SetTransparency(p62 / 100)
				end
			}

			v350.CreateSlider(v350, t25)

			local t26 = {
				Name = "Mostrar botão Abrir/Fechar",
				Description = "No celular, deixe ligado para reabrir o hub",
				Default = true,
				Flag = "NeonUI_ShowToggleButton",
				Callback = function(p63)
					if t6.value14 then
						return
					end

					t6.value11.Visible = p63
				end
			}

			v350.CreateToggle(v350, t26)

			local t27 = {
				Name = "Descarregar hub",
				Description = "Remove a interface da tela",
				Callback = function()
					t6.value8:Destroy()
				end
			}

			v350.CreateButton(v350, t27)

			return v350
		end

		t6.value5.CreateSettingsTab = createSettingsTab

		if value14 then
			t5.value20 = v68.LoadingTitle or Name
			t5.value25 = v68.LoadingSubtitle
			t5.value21 = t5.value25

			if not t5.value25 then
				t5.value22 = t5.value1
				t5.value25 = Subtitle

				if not Subtitle then
					t5.value25 = ""
				end

				local value25 = t5.value25
				local value22 = t5.value22

				t5.value21 = value25
				t5.value1 = value22
			end

			t5.value22 = v68.LoadingTime

			local value22 = t5.value22 or 2.4

			t5.value22 = Instance.new("CanvasGroup")

			local value222 = t5.value22

			t5.value22 = value222
			t5.value26 = UDim2.new(0, 340, 0, 210)
			t5.value22.Size = t5.value26
			t5.value22 = value222
			t5.value26 = UDim2.new(0.5, 0, 0.5, 0)
			t5.value22.Position = t5.value26
			t5.value22 = value222
			t5.value26 = Vector2.new(0.5, 0.5)
			t5.value22.AnchorPoint = t5.value26
			t5.value22 = value222
			t5.value24 = value1.Sidebar
			t5.value22.BackgroundColor3 = t5.value24
			t5.value22 = value222
			t5.value22.BackgroundTransparency = 0.1
			t5.value22 = value222
			t5.value22.BorderSizePixel = 0
			t5.value22 = value222
			t5.value22.GroupTransparency = 1
			t5.value22 = value222
			t5.value22.Parent = t6.value8

			local UICorner6 = Instance.new("UICorner")

			UICorner6.CornerRadius = UDim.new(0, 18)
			UICorner6.Parent = value222

			local color32 = Color3.new(1, 1, 1)
			local UIStroke2 = Instance.new("UIStroke")

			UIStroke2.Color = color32
			UIStroke2.Thickness = 1.5
			UIStroke2.Transparency = 0.1
			UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke2.Parent = value222

			local UIGradient2 = Instance.new("UIGradient")

			UIGradient2.Color = ColorSequence.new(value1.Accent, value1.AccentLight)
			UIGradient2.Rotation = 45
			UIGradient2.Parent = UIStroke2
			t5.value23 = Instance.new("Frame")
			t5.value26 = UDim2.new(0, 56, 0, 56)
			t5.value23.Size = t5.value26
			t5.value26 = UDim2.new(0.5, -28, 0, 24)
			t5.value23.Position = t5.value26
			t5.value26 = Color3.new(1, 1, 1)
			t5.value23.BackgroundColor3 = t5.value26
			t5.value23.BorderSizePixel = 0
			t5.value23.Parent = value222

			local value23 = t5.value23
			local UICorner7 = Instance.new("UICorner")

			UICorner7.CornerRadius = UDim.new(0, 16)
			UICorner7.Parent = value23

			local value232 = t5.value23
			local UIGradient3 = Instance.new("UIGradient")

			UIGradient3.Color = ColorSequence.new(value1.Accent, value1.AccentLight)
			UIGradient3.Rotation = 45
			UIGradient3.Parent = value232
			t5.value24 = createTextLabel(t5.value23, string.sub(Name, 1, 1), 26, t2.Bold, Color3.new(1, 1, 1))
			t5.value27 = UDim2.new(1, 0, 1, 0)
			t5.value24.Size = t5.value27
			t5.value26 = Enum.TextXAlignment.Center
			t5.value24.TextXAlignment = t5.value26
			t5.value26 = Instance.new("UIScale")
			t5.value26.Parent = t5.value23
			t5.value22 = TweenService
			t5.value29 = TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
			t5.value22:Create(t5.value26, t5.value29, {
				Scale = 1.12
			}):Play()
			t5.value27 = createTextLabel(value222, t5.value20, 18, t2.Bold, value1.Text)
			t5.value29 = UDim2.new(0, 20, 0, 94)
			t5.value27.Position = t5.value29
			t5.value29 = UDim2.new(1, -40, 0, 24)
			t5.value27.Size = t5.value29
			t5.value28 = Enum.TextXAlignment.Center
			t5.value27.TextXAlignment = t5.value28
			t5.value28 = createTextLabel(value222, t5.value21, 12, t2.Light, value1.SubText)
			t5.value30 = UDim2.new(0, 20, 0, 118)
			t5.value28.Position = t5.value30
			t5.value30 = UDim2.new(1, -40, 0, 16)
			t5.value28.Size = t5.value30
			t5.value29 = Enum.TextXAlignment.Center
			t5.value28.TextXAlignment = t5.value29
			t5.value29 = Instance.new("Frame")
			t5.value31 = UDim2.new(0, 30, 0, 156)
			t5.value29.Position = t5.value31
			t5.value31 = UDim2.new(1, -60, 0, 6)
			t5.value29.Size = t5.value31
			t5.value30 = value1.Off
			t5.value29.BackgroundColor3 = t5.value30
			t5.value29.BorderSizePixel = 0
			t5.value29.Parent = value222

			local value29 = t5.value29
			local UICorner8 = Instance.new("UICorner")

			UICorner8.CornerRadius = UDim.new(1, 0) or UDim.new(0, "full")
			UICorner8.Parent = value29
			t5.value30 = Instance.new("Frame")

			local value30 = t5.value30

			t5.value30 = value30
			t5.value33 = UDim2.new(0, 0, 1, 0)
			t5.value30.Size = t5.value33
			t5.value30 = value30
			t5.value33 = Color3.new(1, 1, 1)
			t5.value30.BackgroundColor3 = t5.value33
			t5.value30 = value30
			t5.value30.BorderSizePixel = 0
			t5.value30 = value30
			t5.value30.Parent = t5.value29

			local UICorner9 = Instance.new("UICorner")

			UICorner9.CornerRadius = UDim.new(1, 0) or UDim.new(0, "full")
			UICorner9.Parent = value30

			local UIGradient4 = Instance.new("UIGradient")

			UIGradient4.Color = ColorSequence.new(value1.Accent, value1.AccentLight)
			UIGradient4.Rotation = 0
			UIGradient4.Parent = value30
			t5.value31 = createTextLabel(value222, "Iniciando...", 11, t2.Light, value1.SubText)

			local value31 = t5.value31

			t5.value31 = value31
			t5.value34 = UDim2.new(0, 30, 0, 172)
			t5.value31.Position = t5.value34
			t5.value31 = value31
			t5.value34 = UDim2.new(0.6, 0, 0, 16)
			t5.value31.Size = t5.value34
			t5.value32 = createTextLabel(value222, "0%", 11, t2.Bold, value1.Text)

			local value32 = t5.value32

			t5.value32 = value32
			t5.value35 = UDim2.new(1, -80, 0, 172)
			t5.value32.Position = t5.value35
			t5.value32 = value32
			t5.value35 = UDim2.new(0, 50, 0, 16)
			t5.value32.Size = t5.value35
			t5.value32 = value32
			t5.value34 = Enum.TextXAlignment.Right
			t5.value32.TextXAlignment = t5.value34
			v38(value222, {
				GroupTransparency = 0
			}, 0.3)
			task.spawn(function()
				local t28 = {
					"Iniciando...",
					"Carregando módulos...",
					"Preparando interface...",
					"Pronto!"
				}
				local v395 = value22 / #t28

				for i, v in ipairs(t28) do
					value31.Text = v

					local v398 = value32
					local v399 = i / #t28 * 100
					local v400 = math.floor(v399)

					v398.Text = tostring(v400) .. "%"
					v38(value30, {
						Size = UDim2.new(i / #t28, 0, 1, 0)
					}, v395)
					task.wait(v395)
				end

				task.wait(0.2)
				v38(value222, {
					GroupTransparency = 1
				}, 0.3)
				task.wait(0.35)
				value222:Destroy()

				if not t6.value8.Parent then
					return
				end

				t6.value11.Visible = true
				t6.value17(true)
				task.spawn(function()
					task.wait(0.4)

					local carregadaAutomaticamente = v173()

					if not carregadaAutomaticamente then
						return
					end

					local v402, v403 = t6.value5:LoadConfig(carregadaAutomaticamente)
					local value5 = t6.value5

					if v402 then
						v402 = "Carregada automaticamente: " .. carregadaAutomaticamente
					end

					value5:Notify({
						Title = "Configurações",
						Content = v402 or v403,
						Duration = 3
					})
				end)
			end)
		else
			task.spawn(function()
				task.wait(0.3)

				if not t6.value8.Parent then
					return
				end

				t6.value11.Visible = true
				t6.value17(true)
				task.spawn(function()
					task.wait(0.4)

					local carregadaAutomaticamente = v173()

					if not carregadaAutomaticamente then
						return
					end

					local v406, v407 = t6.value5:LoadConfig(carregadaAutomaticamente)
					local value5 = t6.value5

					if v406 then
						v406 = "Carregada automaticamente: " .. carregadaAutomaticamente
					end

					value5:Notify({
						Title = "Configurações",
						Content = v406 or v407,
						Duration = 3
					})
				end)
			end)
		end

		return t6.value5
	end

	return t1
end)()

local function v409()
	local t29 = {
		value1 = game:GetService("Players")
	}
	local game_ = game

	t29.value2 = game_.GetService(game_, "RunService")

	local UserInputService = game:GetService("UserInputService")

	t29.value3 = game:GetService("ReplicatedStorage")
	t29.value4 = game:GetService("Workspace")
	t29.value5 = t29.value1.LocalPlayer
	t29.value6 = {
		isActive = false,
		reachDistance = 3.5,
		sphereEnabled = false
	}
	t29.value7 = {}
	t29.value8 = nil
	t29.value9 = 0
	t29.value10 = 0.05

	local function v413(p64)
		if p64 and p64:IsA("BasePart") then
			local v414 = p64.Name:lower()

			return p64.Name == "TPS" or (v414.find(v414, "ball") ~= nil or (v414:find("bola") ~= nil or (v414:find("football") ~= nil and true or v414:find("soccer") ~= nil)))
		else
			return false
		end
	end

	local ipairs_ = ipairs
	local value4 = t29.value4

	local function v417(descendant)
		if not v413(descendant) then
			return
		end

		t29.value7[descendant] = true
	end

	for _, descendant in ipairs_(value4.GetDescendants(value4)) do
		v417(descendant)
	end

	t29.value4.DescendantAdded:Connect(v417)

	local DescendantRemoving = t29.value4.DescendantRemoving

	DescendantRemoving.Connect(DescendantRemoving, function(p65)
		t29.value7[p65] = nil

		if t29.value8 ~= p65 then
			return
		end

		t29.value8 = nil
	end)

	local function v421(p66)
		if p66 and p66.Parent then
			if os.clock() - t29.value9 < t29.value10 then
				return t29.value8
			else
				local huge = math.huge
				local Position = p66.Position
				local v424 = nil

				for k in pairs(t29.value7) do
					if k.Parent and v413(k) then
						local v426 = k.Position - Position
						local v427 = v426.X * v426.X + v426.Y * v426.Y + v426.Z * v426.Z

						if v427 < huge then
							v424 = k
							huge = v427
						end
					else
						t29.value7[k] = nil
					end
				end

				return v424
			end
		else
			return nil
		end
	end

	t29.value11 = nil

	local function v428()
		if t29.value6.sphereEnabled then
			local Character = t29.value5.Character

			if Character then
				Character = Character:FindFirstChild("HumanoidRootPart")
			end

			if not Character then
				return
			end

			if t29.value11 then
				v494 = t29.value6.reachDistance * 2
				t29.value11.Size = Vector3.new(v494, v494, v494)
				t29.value11.CFrame = Character.CFrame

				return
			end

			t29.value11 = Instance.new("Part")
			t29.value11.Name = "NexoraReachSphere"
			t29.value11.Shape = Enum.PartType.Ball
			t29.value11.Anchored = true
			t29.value11.CanCollide = false
			t29.value11.CanTouch = false
			t29.value11.CanQuery = false
			t29.value11.Massless = true
			t29.value11.Material = Enum.Material.ForceField
			t29.value11.Color = Color3.fromRGB(0, 105, 0)
			t29.value11.Transparency = 0.8
			t29.value11.CastShadow = false
			t29.value11.Parent = t29.value4

			local v430 = t29.value6.reachDistance * 2

			t29.value11.Size = Vector3.new(v430, v430, v430)
			t29.value11.CFrame = Character.CFrame
		else
			if not t29.value11 then
				return
			end

			t29.value11:Destroy()
			t29.value11 = nil
		end
	end

	t29.value2.RenderStepped:Connect(function()
		if not (t29.value6.sphereEnabled and t29.value11) then
			return
		end

		local Character = t29.value5.Character

		if Character then
			Character = Character:FindFirstChild("HumanoidRootPart")
		end

		if not Character then
			return
		end

		t29.value11.Position = Character.Position
	end)
	t29.value12 = 0
	t29.value13 = 0.035

	local Heartbeat = t29.value2.Heartbeat

	Heartbeat.Connect(Heartbeat, function()
		if t29.value6.isActive then
			if firetouchinterest then
				local Character = t29.value5.Character
				local HumanoidRootPart

				if Character then
					HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
				else
					HumanoidRootPart = Character
				end

				local Humanoid

				if Character then
					Humanoid = Character:FindFirstChildOfClass("Humanoid")
				else
					Humanoid = Character
				end

				if not HumanoidRootPart or (not Humanoid or Humanoid.Health <= 0) then
					return
				elseif os.clock() - t29.value12 < t29.value13 then
					return
				else
					local v436 = v421(HumanoidRootPart)

					if v436 and v436.Parent then
						local Magnitude = (v436.Position - HumanoidRootPart.Position).Magnitude
						local X = v436.Size.X
						local Y = v436.Size.Y
						local Z = v436.Size.Z

						if Magnitude - math.max(X, Y, Z) / 2 > t29.value6.reachDistance then
							return
						else
							for _, descendant in ipairs(Character.GetDescendants(Character)) do
								if descendant:IsA("BasePart") then
									firetouchinterest(descendant, v436, 0)
									firetouchinterest(descendant, v436, 1)
								end
							end

							return
						end
					else
						return
					end
				end
			else
				return
			end
		end
	end)
	t29.value5.CharacterAdded:Connect(function() end)
	t29.value14 = false
	t29.value15 = nil
	t29.value16 = false
	t29.value17 = 150
	t29.value18 = 0.8
	t29.value19 = t29.value5.Character or t29.value5.CharacterAdded:Wait()
	t29.value20 = t29.value19:WaitForChild("Humanoid")
	t29.value21 = t29.value19:WaitForChild("HumanoidRootPart")
	t29.value22 = Instance.new("ScreenGui")
	t29.value22.Name = "TPSFollowUI"
	t29.value22.ResetOnSpawn = false
	t29.value22.IgnoreGuiInset = true
	t29.value22.Enabled = false
	t29.value22.Parent = t29.value5:WaitForChild("PlayerGui")
	t29.value23 = Instance.new("TextButton")
	t29.value23.Name = "FollowButton"
	t29.value23.Size = UDim2.new(0, 120, 0, 42)
	t29.value23.Position = UDim2.new(0.82, 0, 0.68, 0)
	t29.value23.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	t29.value23.BorderSizePixel = 0
	t29.value23.Text = "Follow: OFF"
	t29.value23.TextColor3 = Color3.fromRGB(255, 255, 255)
	t29.value23.TextSize = 13
	t29.value23.Font = Enum.Font.GothamBold
	t29.value23.AutoButtonColor = true
	t29.value23.Visible = true
	t29.value23.Parent = t29.value22
	Instance.new("UICorner", t29.value23).CornerRadius = UDim.new(0, 8)
	t29.value24 = Instance.new("UIStroke", t29.value23)
	t29.value24.Color = Color3.fromRGB(80, 80, 90)
	t29.value24.Thickness = 1.5

	function t29.value25(p67)
		local isBasePart

		if p67 then
			isBasePart = p67.Parent and p67:IsA("BasePart")

			if not isBasePart then
				return isBasePart
			end

			if p67.Name == "TPS" then
				isBasePart = p67:IsDescendantOf(t29.value4)
			else
				isBasePart = false
			end
		else
			isBasePart = p67
		end

		return isBasePart
	end

	local function v444()
		local ipairs_2 = ipairs
		local value42 = t29.value4
		local huge = math.huge
		local v448 = nil

		for _, descendant in ipairs_2(value42.GetDescendants(value42)) do
			local isBasePart = descendant:IsA("BasePart")

			if isBasePart then
				isBasePart = descendant.Name == "TPS"
			end

			if isBasePart then
				local Magnitude = (descendant.Position - t29.value21.Position).Magnitude
				local v453

				if Magnitude <= t29.value17 then
					v453 = Magnitude < huge
				else
					v453 = false
				end

				if v453 then
					v448 = descendant
					huge = Magnitude
				end
			end
		end

		return v448
	end
	local function v454()
		if t29.value14 then
			t29.value23.Text = "Follow: ON"
			t29.value23.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
			t29.value23.TextColor3 = Color3.fromRGB(255, 255, 255)
			t29.value24.Color = Color3.fromRGB(100, 255, 150)
		else
			t29.value23.Text = "Follow: OFF"
			t29.value23.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
			t29.value23.TextColor3 = Color3.fromRGB(200, 200, 200)
			t29.value24.Color = Color3.fromRGB(80, 80, 90)
		end
	end

	t29.value23.MouseButton1Click:Connect(function()
		if t29.value16 then
			if t29.value14 then
				t29.value14 = false
				t29.value15 = nil
				v454()

				return
			else
				local v455 = v444()

				if v455 then
					t29.value15 = v455
					t29.value14 = true
					v454()

					return
				else
					return
				end
			end
		end
	end)
	t29.value2.RenderStepped:Connect(function()
		if t29.value14 then
			if t29.value19 and t29.value19.Parent then
				if not t29.value20 or t29.value20.Health <= 0 then
					return
				elseif t29.value21 and t29.value21.Parent then
					if t29.value25(t29.value15) then
						if t29.value15:IsDescendantOf(t29.value19) then
							return
						else
							local v456 = t29.value15.Position - t29.value21.Position
							local vector3 = Vector3.new(v456.X, 0, v456.Z)

							if vector3.Magnitude <= t29.value18 then
								return
							elseif t29.value20.MoveDirection.Magnitude > 0.05 then
								return
							else
								t29.value20:Move(vector3.Unit, false)

								return
							end
						end
					else
						t29.value14 = false
						t29.value15 = nil
						v454()

						return
					end
				else
					return
				end
			else
				return
			end
		end
	end)

	local value26 = false

	t29.value26 = value26
	t29.value27 = value26
	t29.value28 = value26
	t29.value29 = value26
	t29.value23.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		t29.value26 = true
		t29.value27 = input.Position
		t29.value28 = t29.value23.Position
		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			t29.value26 = false
		end)
	end)
	t29.value23.InputChanged:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		t29.value29 = input
	end)
	UserInputService.InputChanged:Connect(function(input)
		local value262 = t29.value26

		if value262 then
			value262 = input == t29.value29
		end

		if not value262 then
			return
		end

		local v460 = input.Position - t29.value27

		t29.value23.Position = UDim2.new(t29.value28.X.Scale, t29.value28.X.Offset + v460.X, t29.value28.Y.Scale, t29.value28.Y.Offset + v460.Y)
	end)
	t29.value5.CharacterAdded:Connect(function(character)
		t29.value19 = character
		t29.value19:WaitForChild("Humanoid")
		t29.value19:WaitForChild("HumanoidRootPart")
		v454()
	end)
	t29.value30 = {
		Enabled = false,
		Studs = 10
	}
	t29.value2.Heartbeat:Connect(function()
		if t29.value30.Enabled then
			local v461, v462, v463 = ipairs(t29.value4:GetDescendants())
			local v464 = nil
			local ipairs_2, value1, v467, HumanoidRootPart, Unit

			while true do
				v463, v540 = v461(v462, v463)

				if not v463 then
					break
				end

				local isBasePart = v540:IsA("BasePart")

				if isBasePart then
					isBasePart = v540.Name == "TPS"
				end

				if isBasePart then
					if v540 then
						ipairs_2 = ipairs
						value1 = t29.value1

						for _, player in ipairs_2(value1.GetPlayers(value1)) do
							if player == t29.value5 then
								v467 = false
							else
								v467 = player.Character
							end

							if v467 then
								HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

								if HumanoidRootPart and (HumanoidRootPart.Position - v540.Position).Magnitude <= t29.value30.Studs then
									Unit = (HumanoidRootPart.Position - v540.Position).Unit

									if Unit.Magnitude == 0 and true or Unit ~= Unit then
										Unit = Vector3.new(1, 0, 0)
									end

									HumanoidRootPart.CFrame = CFrame.new(v540.Position + Unit * (t29.value30.Studs + 2))
								end
							end
						end

						return
					else
						return
					end
				end
			end

			local v473 = v464

			if v473 then
				ipairs_2 = ipairs
				value1 = t29.value1

				for _, player in ipairs_2(value1.GetPlayers(value1)) do
					if player == t29.value5 then
						v467 = false
					else
						v467 = player.Character
					end

					if v467 then
						HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

						if HumanoidRootPart and (HumanoidRootPart.Position - v473.Position).Magnitude <= t29.value30.Studs then
							Unit = (HumanoidRootPart.Position - v473.Position).Unit

							if Unit.Magnitude == 0 and true or Unit ~= Unit then
								Unit = Vector3.new(1, 0, 0)
							end

							HumanoidRootPart.CFrame = CFrame.new(v473.Position + Unit * (t29.value30.Studs + 2))
						end
					end
				end

				return
			else
				return
			end
		end
	end)

	local CurrentCamera = t29.value4.CurrentCamera

	t29.value31 = CurrentCamera
	t29.value32 = CurrentCamera
	t29.value33 = 0.65

	function t29.value34()
		if t29.value32 then
			return
		end

		t29.value32 = t29.value2.RenderStepped:Connect(function()
			t29.value31.CFrame = t29.value31.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, t29.value33, 0, 0, 0, 1)
		end)
	end
	function t29.value35()
		if not t29.value32 then
			return
		end

		t29.value32:Disconnect()
	end

	t29.value34()

	function t29.value36(p68)
		local v477 = p68 / 100
		local v478 = math.clamp(v477, 0.1, 1)

		t29.value31.FieldOfView = 1 / v478 * 70
	end

	t29.value37 = false
	t29.value38 = 10
	t29.value39 = 1
	t29.value40 = 0
	t29.value41 = true
	task.spawn(function()
		while true do
			if true then
			end

			task.wait()

			local value37 = t29.value37

			if value37 then
				local Character = t29.value5.Character

				if Character then
					local Tool = Character:FindFirstChildOfClass("Tool")

					if Tool then
						value37 = Tool.Name == "GK" and true or Tool.Name == "Gk"
					else
						value37 = false
					end
				else
					value37 = false
				end
			end

			if value37 and tick() - t29.value40 >= t29.value39 then
				local Character = t29.value5.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

				if HumanoidRootPart then
					for _, descendant in ipairs(t29.value4:GetDescendants()) do
						if descendant.Name == "TPS" and descendant:IsA("BasePart") or descendant:IsA("Model") then
							local isBasePart = descendant:IsA("BasePart") and descendant and descendant or (descendant.PrimaryPart or descendant:FindFirstChildWhichIsA("BasePart"))

							if isBasePart then
								isBasePart = (isBasePart.Position - HumanoidRootPart.Position).Magnitude <= t29.value38
							end

							if isBasePart then
								local function v487()
									t29.value3.CatchBall:FireServer(descendant)
								end

								pcall(v487)

								local Humanoid = Character:FindFirstChildOfClass("Humanoid")

								if t29.value41 then
									task.spawn(function()
										local now = tick()

										while tick() - now < 0.12 do
											if not (HumanoidRootPart and HumanoidRootPart.Parent) then
												return
											end

											local v490 = Humanoid

											if v490 then
												v490 = Humanoid.MoveDirection.Magnitude > 0.1
											end

											if v490 then
												return
											end

											local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity

											HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X * 0.1, AssemblyLinearVelocity.Y, AssemblyLinearVelocity.Z * 0.1)
											task.wait()
										end
									end)
								end

								tick()
							end
						end
					end
				end
			end
		end
	end)

	local value42 = false

	t29.value42 = value42
	t29.value43 = value42

	local function v493()
		local value43 = t29.value43
		local Part

		if value43 then
		elseif value43 then
			return t29.value43
		else
			Part = Instance.new("Part")
			Part.Name = "NexoraLanding"
			Part.Shape = Enum.PartType.Cylinder
			Part.Size = Vector3.new(0.2, 4, 4)
			Part.Anchored = true
			Part.CanCollide = false
			Part.CanTouch = false
			Part.CanQuery = false
			Part.CastShadow = false
			Part.Material = Enum.Material.Neon
			Part.Color = Color3.fromRGB(255, 80, 80)
			Part.Transparency = 0.3
			Part.Parent = t29.value4
			t29.value43 = "Parent"

			return Part
		end

		value43 = t29.value43.Parent

		if value43 then
			return t29.value43
		else
			Part = Instance.new("Part")
			Part.Name = "NexoraLanding"
			Part.Shape = Enum.PartType.Cylinder
			Part.Size = Vector3.new(0.2, 4, 4)
			Part.Anchored = true
			Part.CanCollide = false
			Part.CanTouch = false
			Part.CanQuery = false
			Part.CastShadow = false
			Part.Material = Enum.Material.Neon
			Part.Color = Color3.fromRGB(255, 80, 80)
			Part.Transparency = 0.3
			Part.Parent = t29.value4
			t29.value43 = "Parent"

			return Part
		end
	end

	local Heartbeat2 = t29.value2.Heartbeat

	Heartbeat2:Connect(function()
		if not t29.value42 then
			return
		end

		local Character = t29.value5.Character
		local HumanoidRootPart

		if Character then
			HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		else
			HumanoidRootPart = Character
		end

		if not HumanoidRootPart then
			return
		end

		local v499 = v421(HumanoidRootPart)

		if v499 and v499.Parent then
			local AssemblyLinearVelocity = v499.AssemblyLinearVelocity

			if AssemblyLinearVelocity.Magnitude < 2 then
				if not t29.value43 then
					return
				end

				t29.value43:Destroy()
				t29.value43 = nil

				return
			else
				local raycastParams = RaycastParams.new()

				raycastParams.FilterType = Enum.RaycastFilterType.Exclude
				raycastParams.FilterDescendantsInstances = { Character, v499, t29.value43 }

				local hit = t29.value4:Raycast(v499.Position, Vector3.new(0, -500, 0), raycastParams)

				if hit then
					hit = hit.Position.Y
				end

				local v503 = hit or HumanoidRootPart.Position.Y - 3
				local X = v499.Size.X
				local Y = v499.Size.Y
				local Z = v499.Size.Z
				local v507 = math.max(X, Y, Z)
				local math_ = math
				local v509 = v507 / 2
				local v510 = math_.max(0, v499.Position.Y - v503 - v509)
				local Gravity = t29.value4.Gravity
				local v512 = AssemblyLinearVelocity.Y * AssemblyLinearVelocity.Y + 2 * Gravity * v510

				if not (v512 < 0) then
					local Y2 = AssemblyLinearVelocity.Y
					local v514 = math.sqrt(v512)
					local Vector3_ = Vector3
					local v516 = (Y2 + v514) / Gravity
					local vector3 = Vector3_.new(v499.Position.X + AssemblyLinearVelocity.X * v516, v503 + 0.1, v499.Position.Z + AssemblyLinearVelocity.Z * v516)

					v493().CFrame = CFrame.new(vector3) * CFrame.Angles(0, 0, 1.5707963267948966)

					return
				end

				if not t29.value43 then
					return
				end

				t29.value43:Destroy()
				t29.value43 = nil

				return
			end
		else
			if not t29.value43 then
				return
			end

			t29.value43:Destroy()
			t29.value43 = nil
		end
	end)
	t29.value44 = Heartbeat2

	local value45 = false

	t29.value45 = value45
	t29.value46 = value45

	local function v519(p69)
		if t29.value46 then
			for _, v in ipairs(t29.value46) do
				v:Disconnect()
			end
		end

		if not (t29.value45 and p69) then
			return
		end

		local function v522()
			if not (t29.value45 and t29.value44) then
				return
			end

			if not p69.UseJumpPower then
				p69.UseJumpPower = true
			end

			if p69.JumpPower == t29.value44 then
				return
			end

			p69.JumpPower = t29.value44
		end

		local connection = p69:GetPropertyChangedSignal("JumpPower"):Connect(v522)
		local signal = p69:GetPropertyChangedSignal("UseJumpPower")
		local _ = { connection, signal.Connect(signal, v522) }
	end

	t29.value5.CharacterAdded:Connect(function(character)
		local Humanoid = character:WaitForChild("Humanoid")

		if not t29.value44 then
			v519(Humanoid)

			return
		end

		local Character = t29.value5.Character

		if Character then
			Character = Character:FindFirstChildOfClass("Humanoid")
		end

		if not Character then
			v519(Humanoid)

			return
		end

		Character.UseJumpPower = true
		Character.JumpPower = t29.value44
		v519(Humanoid)
	end)
	t29.value47 = 16
	t29.value2.Heartbeat:Connect(function()
		if t29.value47 == 16 then
			return
		end

		local Character = t29.value5.Character

		if not Character then
			return
		end

		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		local v530 = not HumanoidRootPart
		local v531 = Character.FindFirstChildOfClass(Character, "Humanoid")

		if v530 or not v531 then
			return
		end

		local MoveDirection = v531.MoveDirection

		if not (MoveDirection.Magnitude > 0.1) then
			return
		end

		local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity

		HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(MoveDirection.X * t29.value47, AssemblyLinearVelocity.Y, MoveDirection.Z * t29.value47)
	end)
	t29.value48 = game:GetService("Lighting")

	local value49 = {
		"ClockTime",
		"Brightness",
		"Ambient",
		"OutdoorAmbient",
		"FogColor",
		"FogEnd"
	}

	t29.value49 = value49
	t29.value50 = value49

	local value51 = {}

	t29.value51 = value51
	t29.value52 = value51
	t29.value53 = value51
	t29.value54 = value51
	t29.value55 = value51

	function t29.value56()
		if t29.value54 then
			t29.value54:Disconnect()
		end

		if t29.value53 then
			t29.value53:Destroy()
			t29.value53 = nil
		end

		if t29.value55 then
			t29.value55:Destroy()
			t29.value55 = nil
		end

		t29.value53 = Instance.new("Folder")
		t29.value53.Name = "NexoraRain"
		t29.value53.Parent = t29.value4

		local t30 = {}
		local n13 = 120

		for i = 1, 50 do
			local Part = Instance.new("Part")

			Part.Size = Vector3.new(0.05, 3, 0.05)
			Part.Anchored = true
			Part.CanCollide = false
			Part.CanQuery = false
			Part.CanTouch = false
			Part.CastShadow = false
			Part.Material = Enum.Material.SmoothPlastic
			Part.Color = Color3.fromRGB(160, 200, 255)
			Part.Transparency = 0.5
			Part.Parent = t29.value53
			t30[i] = {
				part = Part,
				x = math.random(-100, 100),
				y = math.random(0, 50),
				z = math.random(-100, 100)
			}
		end

		t29.value2.RenderStepped:Connect(function(dt)
			local Character = t29.value5.Character

			if not Character then
				v610 = Character and Character.Position or Vector3.zero

				for _, v in ipairs(t30) do
					v.y = v.y - n13 * dt

					if v.y < v610.Y - 10 then
						v.y = v610.Y + 50
						v.x = math.random(-100, 100)
						v.z = math.random(-100, 100)
					end

					v.part.Position = Vector3.new(v610.X + v.x, v.y, v610.Z + v.z)
				end

				return
			end

			Character = Character:FindFirstChild("HumanoidRootPart")

			local Position = Character and Character.Position or Vector3.zero

			for _, v in ipairs(t30) do
				v.y = v.y - n13 * dt

				if v.y < Position.Y - 10 then
					v.y = Position.Y + 50
					v.x = math.random(-100, 100)
					v.z = math.random(-100, 100)
				end

				v.part.Position = Vector3.new(Position.X + v.x, v.y, Position.Z + v.z)
			end
		end)
		t29.value55 = Instance.new("Sound")
		t29.value55.Name = "NexoraRainAmbience"
		t29.value55.SoundId = "rbxassetid://365362615"
		t29.value55.Looped = true
		t29.value55.Volume = 0.4
		t29.value55.Parent = t29.value4
		t29.value55:Play()
	end

	local t31 = {
		Bk = "rbxassetid://4498828382",
		Dn = "rbxassetid://4498828812",
		Ft = "rbxassetid://4498829917",
		Lf = "rbxassetid://4498830911",
		Rt = "rbxassetid://4498830417",
		Up = "rbxassetid://4498831746"
	}

	t29.value57 = {
		Sol = {
			Lighting = {
				ClockTime = 7,
				Brightness = 2,
				OutdoorAmbient = Color3.fromRGB(200, 200, 255),
				Ambient = Color3.fromRGB(255, 210, 160),
				FogColor = Color3.fromRGB(255, 170, 100),
				FogEnd = 100000
			},
			Sky = {
				Bk = "rbxassetid://541743453",
				Dn = "rbxassetid://541743443",
				Ft = "rbxassetid://541743446",
				Lf = "rbxassetid://541743436",
				Rt = "rbxassetid://541743435",
				Up = "rbxassetid://541743441"
			}
		},
		Lua = {
			Lighting = {
				ClockTime = 21,
				Brightness = 1,
				OutdoorAmbient = Color3.fromRGB(128, 128, 128),
				Ambient = Color3.fromRGB(0, 0, 0),
				FogColor = Color3.fromRGB(150, 150, 150),
				FogEnd = 100000
			},
			Sky = t31
		},
		Chuva = {
			Lighting = {
				ClockTime = 21,
				Brightness = 1,
				OutdoorAmbient = Color3.fromRGB(100, 100, 120),
				Ambient = Color3.fromRGB(50, 50, 60),
				FogColor = Color3.fromRGB(100, 100, 120),
				FogEnd = 100000
			},
			Sky = t31,
			Rain = true
		}
	}

	local function v547(p70, p71, p72, p73, p74, p75)
		return {
			Bk = "rbxassetid://" .. p70,
			Dn = "rbxassetid://" .. p71,
			Ft = "rbxassetid://" .. p72,
			Lf = "rbxassetid://" .. p73,
			Rt = "rbxassetid://" .. p74,
			Up = "rbxassetid://" .. p75
		}
	end

	t29.value57["Dark Sky"] = {
		Lighting = {},
		Celestial = false,
		Sky = v547(570555736, 570555964, 570555800, 570555840, 570555882, 570555929)
	}
	t29.value57["Art Mountain"] = {
		Lighting = {},
		Celestial = false,
		Sky = v547(2128458653, 2128462480, 2128458653, 2128462027, 2128462027, 2128462236)
	}
	t29.value57.Vaporwave = {
		Lighting = {},
		Celestial = false,
		Sky = v547(1417494030, 1417494146, 1417494253, 1417494402, 1417494499, 1417494643)
	}
	t29.value57.Nebula = {
		Lighting = {},
		Celestial = false,
		Sky = v547(159454299, 159454296, 159454293, 159454286, 159454300, 159454288)
	}
	t29.value57.Twilight = {
		Lighting = {},
		Celestial = false,
		Sky = v547(264908339, 264907909, 264909420, 264909758, 264908886, 264907379)
	}
	t29.value57["Lake Sky"] = {
		Lighting = {},
		Celestial = true,
		Sun = "rbxassetid://5392574622",
		Sky = v547(6823523318, 6823525702, 6823482923, 6823530023, 6823531746, 6823528533)
	}
	t29.value57["Alien Red"] = {
		Lighting = {},
		Celestial = false,
		Sky = v547(7123385217, 7123387679, 7123390433, 7123394786, 7123402505, 7123412196)
	}
	t29.value57["Black Mesa"] = {
		Lighting = {},
		Celestial = false,
		Sky = v547(9569742122, 9569613307, 9569611418, 9569608166, 9569601267, 9569598752)
	}
	t29.value57.Clouds = {
		Lighting = {},
		Celestial = false,
		Sky = v547(570557514, 570557775, 570557559, 570557620, 570557672, 570557727)
	}

	function t29.value58()
		if not t29.value50 then
			t29.value50 = {}

			for _, v in ipairs(t29.value49) do
				t29.value50[v] = t29.value48[v]
			end
		end
	end
	function t29.value59()
		if t29.value54 then
			t29.value54:Disconnect()
		end

		if t29.value53 then
			t29.value53:Destroy()
			t29.value53 = nil
		end

		if t29.value55 then
			t29.value55:Destroy()
			t29.value55 = nil
		end

		if not t29.value52 then
			return
		end

		t29.value52:Destroy()
	end

	local function v550(p76)
		if p76 == "Padrão" then
			t29.value59()

			for _, v in ipairs(t29.value51) do
				v.Parent = t29.value48
			end

			t29.value51 = {}

			if not t29.value50 then
				return
			end

			for k, v in pairs(t29.value50) do
				t29.value48[k] = v
			end

			return
		end

		local v555 = t29.value57[p76]

		if not v555 then
			return
		end

		t29.value58()
		t29.value59()

		local v556, v557, v558 = ipairs(t29.value48:GetChildren())

		while true do
			local v559

			v558, v559 = v556(v557, v558)

			if not v558 then
				break
			end

			if v559:IsA("Sky") then
				local value512 = t29.value51

				table.insert(value512, v559)
				v559.Parent = nil
			end
		end

		if not t29.value50 then
			for k, v in pairs(v555.Lighting) do
				t29.value48[k] = v
			end

			v638 = Instance.new("Sky")
			v638.Name = "NexoraSky"
			v638.SkyboxBk = v555.Sky.Bk
			v638.SkyboxDn = v555.Sky.Dn
			v638.SkyboxFt = v555.Sky.Ft
			v638.SkyboxLf = v555.Sky.Lf
			v638.SkyboxRt = v555.Sky.Rt
			v638.SkyboxUp = v555.Sky.Up
			v638.CelestialBodiesShown = v555.Celestial ~= false

			if v555.Sun then
				v638.SunTextureId = v555.Sun
			end

			v638.Parent = t29.value48

			if not v555.Rain then
				return
			end

			t29.value56()

			return
		end

		for k, v in pairs(t29.value50) do
			t29.value48[k] = v
		end

		for k, v in pairs(v555.Lighting) do
			t29.value48[k] = v
		end

		local Sky = Instance.new("Sky")

		Sky.Name = "NexoraSky"
		Sky.SkyboxBk = v555.Sky.Bk
		Sky.SkyboxDn = v555.Sky.Dn
		Sky.SkyboxFt = v555.Sky.Ft
		Sky.SkyboxLf = v555.Sky.Lf
		Sky.SkyboxRt = v555.Sky.Rt
		Sky.SkyboxUp = v555.Sky.Up
		Sky.CelestialBodiesShown = v555.Celestial ~= false

		if v555.Sun then
			Sky.SunTextureId = v555.Sun
		end

		Sky.Parent = t29.value48

		if not v555.Rain then
			return
		end

		t29.value56()
	end

	t29.value60 = "NexoraHub/skyboxes.json"

	local value61 = {}

	t29.value61 = value61
	t29.value62 = value61

	local function v569()
		local t32 = {}

		for k in pairs(t29.value61) do
			table.insert(t32, k)
		end

		table.sort(t32)

		return t32
	end
	local function v572(p77)
		local v573, v574, v575 = tostring(p77 or ""):gmatch("%d+")
		local t33 = {}

		while true do
			v575 = v573(v574, v575)

			if not v575 then
				break
			end

			if #v575 >= 5 then
				table.insert(t33, v575)
			end
		end

		if #t33 == 1 then
			return {
				t33[1],
				t33[1],
				t33[1],
				t33[1],
				t33[1],
				t33[1]
			}
		elseif #t33 == 6 then
			return t33
		else
			return nil
		end
	end
	local function v577(p78)
		t29.value58()
		t29.value59()

		local value512

		if not t29.value50 then
			v656 = ipairs
			v657 = t29.value48

			for _, child in v656(v657.GetChildren(v657)) do
				if child:IsA("Sky") then
					value512 = t29.value51
					table.insert(value512, child)
					child.Parent = nil
				end
			end

			v660 = Instance.new("Sky")
			v660.Name = "NexoraSky"
			v660.SkyboxBk = "rbxassetid://" .. p78[1]
			v660.SkyboxDn = "rbxassetid://" .. p78[2]
			v660.SkyboxFt = "rbxassetid://" .. p78[3]
			v660.SkyboxLf = "rbxassetid://" .. p78[4]
			v660.SkyboxRt = "rbxassetid://" .. p78[5]
			v660.SkyboxUp = "rbxassetid://" .. p78[6]
			v660.CelestialBodiesShown = false
			v660.Parent = t29.value48

			return
		end

		for k, v in pairs(t29.value50) do
			t29.value48[k] = v
		end

		local ipairs_2 = ipairs
		local value48 = t29.value48

		for _, child in ipairs_2(value48.GetChildren(value48)) do
			if child:IsA("Sky") then
				value512 = t29.value51
				table.insert(value512, child)
				child.Parent = nil
			end
		end

		local Sky = Instance.new("Sky")

		Sky.Name = "NexoraSky"
		Sky.SkyboxBk = "rbxassetid://" .. p78[1]
		Sky.SkyboxDn = "rbxassetid://" .. p78[2]
		Sky.SkyboxFt = "rbxassetid://" .. p78[3]
		Sky.SkyboxLf = "rbxassetid://" .. p78[4]
		Sky.SkyboxRt = "rbxassetid://" .. p78[5]
		Sky.SkyboxUp = "rbxassetid://" .. p78[6]
		Sky.CelestialBodiesShown = false
		Sky.Parent = t29.value48
	end

	(function()
		local writefile_ = writefile

		if writefile_ then
			writefile_ = readfile and (isfile and makefolder)

			if writefile_ then
				writefile_ = isfolder
			end
		end

		if not (writefile_ and isfile(t29.value60)) then
			return
		end

		local function v589()
			return HttpService:JSONDecode(unpack_({ readfile(t29.value60) }))
		end

		local ok, result = pcall(v589)

		if not (not ok or type(result) ~= "table") then
			local pairs_ = pairs

			for k, v in pairs_(result) do
				local v595 = type(k) == "string"

				if v595 then
					if type(v) == "table" then
						v595 = #v == 6
					else
						v595 = false
					end
				end

				if v595 then
					pairs_ = t29.value61
					pairs_[k] = v
				end
			end
		end
	end)()

	local value63 = {
		["Champions Laranja"] = {
			Texture = "http://www.roblox.com/asset/?id=6631296730",
			Mesh = "rbxassetid://4545270159"
		},
		["Champions Azul"] = {
			Texture = "rbxassetid://8108082224",
			Mesh = "rbxassetid://4454597214"
		},
		["Champions Branca"] = {
			Texture = "http://www.roblox.com/asset/?id=7897839361",
			Mesh = "rbxassetid://4761031195"
		}
	}

	t29.value63 = value63
	t29.value64 = value63
	t29.value65 = {}

	function t29.value66(p79, p80)
		pcall(function()
			local SpecialMesh

			if t29.value65[p79] then
				if p79:IsA("MeshPart") then
					p79.MeshId = p80.Mesh
					p79.TextureID = p80.Texture
				else
					SpecialMesh = p79:FindFirstChildOfClass("SpecialMesh")

					if not SpecialMesh then
						SpecialMesh = Instance.new("SpecialMesh")
						SpecialMesh.Name = "NexoraSkinMesh"
						SpecialMesh.Parent = p79
						t29.value65[p79].CreatedMesh = true
					end

					SpecialMesh.MeshType = Enum.MeshType.FileMesh
					SpecialMesh.MeshId = p80.Mesh
					SpecialMesh.TextureId = p80.Texture
				end

				v680 = p79

				for _, child in ipairs(v680.GetChildren(v680)) do
					if child:IsA("Decal") or child:IsA("Texture") then
						child.Texture = p80.Texture
						child.Transparency = 0
					end
				end

				return
			end

			local t34 = {
				Decals = {}
			}

			if p79:IsA("MeshPart") then
				t34.MeshId = p79.MeshId
				t34.TextureID = p79.TextureID
			else
				local SpecialMesh2 = p79:FindFirstChildOfClass("SpecialMesh")

				if SpecialMesh2 then
					t34.Mesh = {
						MeshId = SpecialMesh2.MeshId,
						TextureId = SpecialMesh2.TextureId,
						MeshType = SpecialMesh2.MeshType
					}
				end
			end

			local v602 = p79

			for _, child in ipairs(v602.GetChildren(v602)) do
				if child:IsA("Decal") or child:IsA("Texture") then
					t34.Decals[child] = {
						Texture = child.Texture,
						Transparency = child.Transparency
					}
				end
			end

			t29.value65[p79] = t34

			if p79:IsA("MeshPart") then
				p79.MeshId = p80.Mesh
				p79.TextureID = p80.Texture
			else
				SpecialMesh = p79:FindFirstChildOfClass("SpecialMesh")

				if not SpecialMesh then
					SpecialMesh = Instance.new("SpecialMesh")
					SpecialMesh.Name = "NexoraSkinMesh"
					SpecialMesh.Parent = p79
					t29.value65[p79].CreatedMesh = true
				end

				SpecialMesh.MeshType = Enum.MeshType.FileMesh
				SpecialMesh.MeshId = p80.Mesh
				SpecialMesh.TextureId = p80.Texture
			end

			local v605 = p79

			for _, child in ipairs(v605.GetChildren(v605)) do
				if child:IsA("Decal") or child:IsA("Texture") then
					child.Texture = p80.Texture
					child.Transparency = 0
				end
			end
		end)
	end

	local function v608(p81)
		if p81 ~= "Original" then
			local v609 = t29.value63[p81]

			if v609 then
				t29.value64 = v609

				for k in pairs(t29.value7) do
					if k.Parent then
						t29.value66(k, v609)
					end
				end

				return
			else
				return
			end
		end

		t29.value64 = nil

		for k in pairs(t29.value65) do
			local v612 = t29.value65[k]

			if v612 then
				pcall(function()
					if k:IsA("MeshPart") then
						if v612.MeshId then
							k.MeshId = v612.MeshId
						end

						if not v612.TextureID then
							for k2, decal in pairs(v612.Decals) do
								if k2.Parent then
									k2.Texture = decal.Texture
									k2.Transparency = decal.Transparency
								end
							end

							return
						end

						k.TextureID = v612.TextureID
					else
						local SpecialMesh = k:FindFirstChildOfClass("SpecialMesh")

						if not SpecialMesh then
							for k2, decal in pairs(v612.Decals) do
								if k2.Parent then
									k2.Texture = decal.Texture
									k2.Transparency = decal.Transparency
								end
							end

							return
						end

						if v612.CreatedMesh then
							SpecialMesh:Destroy()
						else
							if not v612.Mesh then
								for k2, decal in pairs(v612.Decals) do
									if k2.Parent then
										k2.Texture = decal.Texture
										k2.Transparency = decal.Transparency
									end
								end

								return
							end

							SpecialMesh.MeshType = v612.Mesh.MeshType
							SpecialMesh.MeshId = v612.Mesh.MeshId
							SpecialMesh.TextureId = v612.Mesh.TextureId
						end
					end

					for k2, decal in pairs(v612.Decals) do
						if k2.Parent then
							k2.Texture = decal.Texture
							k2.Transparency = decal.Transparency
						end
					end
				end)
				t29.value65[k] = nil
			end
		end
	end

	t29.value4.DescendantAdded:Connect(function(descendant)
		local value64 = t29.value64

		if value64 then
			value64 = v413(descendant)
		end

		if not value64 then
			return
		end

		task.defer(function()
			local Parent = descendant.Parent

			if Parent then
				Parent = t29.value64
			end

			if not Parent then
				return
			end

			local v624 = descendant
			local value642 = t29.value64

			t29.value66(v624, value642)
		end)
	end)
	t29.value67 = game:GetService("VirtualInputManager")
	t29.value68 = {
		center_high = Enum.KeyCode.R,
		center_low = Enum.KeyCode.F,
		left_high = Enum.KeyCode.Q,
		left_low = Enum.KeyCode.Z,
		right_high = Enum.KeyCode.E,
		right_low = Enum.KeyCode.C
	}
	t29.value69 = {
		enabled = false,
		range = 15
	}
	t29.value70 = false
	t29.value71 = 0
	t29.value72 = 1.2
	t29.value73 = 1.5
	t29.value74 = 1.5
	t29.value75 = 8
	t29.value76 = 2
	t29.value77 = 6
	t29.value78 = 1.5
	t29.value2.Heartbeat:Connect(function()
		if not t29.value69.enabled then
			return
		end

		local Character = t29.value5.Character
		local v627

		if Character then
			local Tool = Character:FindFirstChildOfClass("Tool")

			if Tool then
				v627 = Tool.Name == "GK" and true or Tool.Name == "Gk"
			else
				v627 = false
			end
		else
			v627 = false
		end

		if not v627 then
			return
		end

		if t29.value70 then
			return
		end

		if tick() - t29.value71 < t29.value72 then
			return
		end

		local Character2 = t29.value5.Character

		if not Character2 then
			return
		end

		local HumanoidRootPart = Character2:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character2:FindFirstChildOfClass("Humanoid")

		if not HumanoidRootPart or (not Humanoid or Humanoid.Health <= 0) then
			return
		end

		local v632 = v421(HumanoidRootPart)

		if not (v632 and v632.Parent) then
			return
		end

		local v633 = v632.Position - HumanoidRootPart.Position
		local Magnitude = v633.Magnitude

		if t29.value69.range < Magnitude then
			return
		end

		local Y = v632.Position.Y
		local HipHeight = Humanoid and Humanoid.HipHeight or 2
		local v637 = Y - (HumanoidRootPart.Position.Y - HipHeight)
		local v639

		if Magnitude <= t29.value75 then
			v639 = t29.value76 < v637
		else
			v639 = false
		end

		if v639 then
			tick()
			pcall(function()
				Humanoid.Jump = true
			end)
			task.delay(t29.value72, function() end)

			return
		end

		local CurrentCamera2 = t29.value4.CurrentCamera

		if CurrentCamera2 then
			CurrentCamera2 = CurrentCamera2.CFrame
		end

		local CFrame_ = CurrentCamera2 or HumanoidRootPart.CFrame
		local v641

		if v633:Dot(CFrame_.LookVector) > 0 then
			v641 = v637 <= t29.value78
		else
			v641 = false
		end

		local v642

		if v641 then
			v642 = v637

			local v643 = false

			for _, player in ipairs(t29.value1:GetPlayers()) do
				local v646

				if player == t29.value5 then
					v646 = false
				else
					v646 = player.Character
				end

				if v646 then
					local HumanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")

					if HumanoidRootPart2 then
						HumanoidRootPart2 = (HumanoidRootPart2.Position - v632.Position).Magnitude <= t29.value77
					end

					if HumanoidRootPart2 then
						v643 = true

						break
					end
				end
			end

			if v643 then
				tick()

				local H = Enum.KeyCode.H

				pcall(function()
					t29.value67:SendKeyEvent(true, H, false, game)
					task.wait(0.05)
					t29.value67:SendKeyEvent(false, H, false, game)
				end)
				task.delay(t29.value72, function() end)

				return
			end
		else
			v642 = v637
		end

		if v632.AssemblyLinearVelocity.Magnitude < 8 then
			return
		end

		local v649 = v633:Dot(CFrame_.RightVector)
		local v650 = t29.value73 < v649 and "right" or (v649 < -t29.value73 and "left" or "center")
		local v651 = t29.value74 < v637
		local v652 = t29.value68[v650 .. "_" .. (v651 and "high" or v651 or "low")]

		tick()
		pcall(function()
			t29.value67:SendKeyEvent(true, v652, false, game)
			task.wait(0.05)
			t29.value67:SendKeyEvent(false, v652, false, game)
		end)
		task.delay(t29.value72, function() end)
	end)
	t29.value79 = v23:CreateWindow({
		Name = "NEXORA",
		Subtitle = "by riive3lino",
		LoadingTitle = "NEXORA HUB",
		LoadingSubtitle = "by riive3lino",
		ConfigFolder = "NexoraHub"
	})

	local Reach = t29.value79:CreateTab("Reach")

	Reach:CreateSection("Configurações do Reach")
	Reach.CreateToggle(Reach, {
		Name = "Ativar Reach",
		Description = "Aumenta o alcance para tocar na bola",
		Default = false,
		Flag = "ReachToggle",
		Callback = function(p82)
			t29.value6.isActive = p82
			t29.value79:Notify({
				Title = "Nexora Hub",
				Content = p82 and "Reach foi ativado!" or p82 or "Reach foi desativado!",
				Duration = 2
			})
		end
	})
	Reach.CreateToggle(Reach, {
		Name = "Reach Sphere (mostrar alcance)",
		Description = "Mostra o alcance em volta de você",
		Default = false,
		Flag = "ReachSphereToggle",
		Callback = function(p83)
			t29.value6.sphereEnabled = p83
			v428()
		end
	})
	Reach.CreateSlider(Reach, {
		Name = "Distância (Studs)",
		Range = { 1, 10 },
		Increment = 0.5,
		Default = 3.5,
		Flag = "ReachSlider",
		Callback = function(p84)
			t29.value6.reachDistance = p84

			if not t29.value6.sphereEnabled then
				return
			end

			v428()
		end
	})

	local Player = t29.value79:CreateTab("Player")

	Player:CreateSection("Auto Follow Bola")
	Player.CreateToggle(Player, {
		Name = "Ativar Auto Follow",
		Description = "Segue a bola automaticamente",
		Default = false,
		Flag = "AutoFollowToggle",
		Callback = function(p85)
			t29.value22.Enabled = p85

			if p85 then
				t29.value79:Notify({
					Title = "Auto Follow",
					Content = p85 and "Auto Follow Habilitado!" or p85 or "Auto Follow Desabilitado!",
					Duration = 2
				})

				return
			end

			t29.value14 = false
			t29.value15 = nil
			v454()
			t29.value79:Notify({
				Title = "Auto Follow",
				Content = p85 and "Auto Follow Habilitado!" or p85 or "Auto Follow Desabilitado!",
				Duration = 2
			})
		end
	})
	Player:CreateSection("Shield da Bola (Anti-Inimigo)")
	Player.CreateToggle(Player, {
		Name = "Ativar Ball Shield",
		Description = "Afasta os inimigos que chegam perto da bola",
		Default = false,
		Flag = "ShieldToggle",
		Callback = function(p86)
			t29.value30.Enabled = p86
			t29.value79:Notify({
				Title = "Ball Shield",
				Content = p86 and "Ball Shield Ativado!" or p86 or "Ball Shield Desativado!",
				Duration = 2
			})
		end
	})
	Player.CreateSlider(Player, {
		Name = "Distância do Shield (Studs)",
		Range = { 5, 30 },
		Increment = 1,
		Default = 10,
		Flag = "ShieldSlider",
		Callback = function(p87)
			t29.value30.Studs = p87
		end
	})
	Player:CreateSection("Interface Flutuante Mobile")
	Player:CreateToggle({
		Name = "Mostrar Botão Flutuante",
		Description = "Botão para ligar o Follow na tela",
		Default = true,
		Flag = "FollowButtonToggle",
		Callback = function(p88)
			t29.value23.Visible = p88
		end
	})
	Player:CreateSection("Pulo")
	Player.CreateSlider(Player, {
		Name = "Força do Pulo",
		Range = { 50, 200 },
		Increment = 5,
		Default = 50,
		Flag = "JumpSlider",
		Callback = function(p89)
			t29.value44 = p89

			if t29.value44 then
				local Character = t29.value5.Character

				if Character then
					Character = Character:FindFirstChildOfClass("Humanoid")
				end

				if Character then
					Character.UseJumpPower = true
					Character.JumpPower = t29.value44
				end
			end

			if not t29.value45 then
				return
			end

			local v658 = v519
			local Character = t29.value5.Character

			if Character then
				Character = t29.value5.Character:FindFirstChildOfClass("Humanoid")
			end

			v658(Character)
		end
	})
	Player.CreateToggle(Player, {
		Name = "Travar Pulo",
		Description = "Corrige o pulo se o jogo tentar mudar ele",
		Default = false,
		Flag = "JumpLockToggle",
		Callback = function(p90)
			t29.value45 = p90

			local Character = t29.value5.Character

			if Character then
				Character = Character:FindFirstChildOfClass("Humanoid")
			end

			if not t29.value44 then
				v519(Character)

				return
			end

			local Character2 = t29.value5.Character

			if Character2 then
				Character2 = Character2:FindFirstChildOfClass("Humanoid")
			end

			if not Character2 then
				v519(Character)

				return
			end

			Character2.UseJumpPower = true
			Character2.JumpPower = t29.value44
			v519(Character)
		end
	})
	Player:CreateSection("Velocidade")
	Player.CreateSlider(Player, {
		Name = "Velocidade",
		Range = { 16, 150 },
		Increment = 1,
		Default = 16,
		Flag = "SpeedSlider",
		Callback = function(p91)
			t29.value47 = p91
		end
	})

	local Goalkeeper = t29.value79:CreateTab("Goalkeeper")

	Goalkeeper:CreateSection("Auto Catch (Goleiro)")
	Goalkeeper.CreateToggle(Goalkeeper, {
		Name = "Ativar Auto Catch",
		Description = "Defende a bola sozinho (goleiro)",
		Default = false,
		Flag = "AutoCatchToggle",
		Callback = function(p92)
			t29.value79:Notify({
				Title = "Goalkeeper",
				Content = p92 and "Auto Catch Ativado!" or p92 or "Auto Catch Desativado!",
				Duration = 2
			})
		end
	})
	Goalkeeper.CreateSlider(Goalkeeper, {
		Name = "Alcance da Defesa (Studs)",
		Range = { 1, 50 },
		Increment = 1,
		Default = 10,
		Flag = "AutoCatchSlider",
		Callback = function(p93)
			t29.value38 = p93
		end
	})
	Goalkeeper.CreateToggle(Goalkeeper, {
		Name = "Reduzir empurrão ao pegar a bola",
		Description = "Segura o personagem por um instante após a captura",
		Default = true,
		Flag = "ReduceCatchPushToggle",
		Callback = function(p94)
			t29.value41 = p94
		end
	})
	Goalkeeper:CreateSection("Previsão da Bola")
	Goalkeeper.CreateToggle(Goalkeeper, {
		Name = "Mostrar onde a bola vai cair",
		Description = "Marca no chão o ponto de queda da bola",
		Default = false,
		Flag = "PredictToggle",
		Callback = function(p95)
			if p95 or not t29.value43 then
				return
			end

			t29.value43:Destroy()
			t29.value43 = nil
		end
	})

	local Visual = t29.value79:CreateTab("Visual")

	Visual:CreateSection("Skybox")
	Visual.CreateDropdown(Visual, {
		Name = "Céu",
		Description = "Muda o céu e a iluminação do mapa",
		Options = {
			"Padrão",
			"Sol",
			"Lua",
			"Chuva",
			"Dark Sky",
			"Art Mountain",
			"Vaporwave",
			"Nebula",
			"Twilight",
			"Lake Sky",
			"Alien Red",
			"Black Mesa",
			"Clouds"
		},
		Default = "Padrão",
		Flag = "SkyboxDropdown",
		Callback = function(p96)
			v550(p96)
		end
	})
	Visual:CreateSection("Skybox personalizada")
	Visual.CreateParagraph(Visual, {
		Title = "Como usar",
		Content = "Cole 1 ID (vale para todas as faces) ou 6 IDs de imagem, na ordem: trás, baixo, frente, esquerda, direita, cima. Toque em Aplicar para testar e em Salvar para guardar na lista."
	})
	t29.value80 = Visual:CreateInput({
		Name = "Nome da skybox",
		Description = "Só letras e números",
		Default = "minhasky",
		Placeholder = "minhasky"
	})
	t29.value81 = Visual:CreateInput({
		Name = "IDs das imagens",
		Description = "1 ID ou 6 IDs",
		Placeholder = "123456, 123457..."
	})
	Visual.CreateButton(Visual, {
		Name = "Aplicar skybox",
		Description = "Mostra a skybox agora",
		Callback = function()
			local v662 = v572(t29.value81:Get())

			if v662 then
				v577(v662)
				t29.value79:Notify({
					Title = "Skybox",
					Content = "Skybox aplicada!",
					Duration = 2
				})
			else
				t29.value79:Notify({
					Title = "Skybox",
					Content = "Informe 1 ID ou 6 IDs (números).",
					Duration = 3
				})
			end
		end
	})

	local t35 = {
		Name = "Salvar skybox",
		Description = "Guarda na lista de baixo",
		Callback = function()
			local v664 = v572(t29.value81:Get())

			if not v664 then
				t29.value79:Notify({
					Title = "Skybox",
					Content = "Informe 1 ID ou 6 IDs (números).",
					Duration = 3
				})

				return
			end

			local value80 = t29.value80
			local salva = tostring(value80:Get()):gsub("[^%w_%-]", "")
			local s1

			if salva == "" then
				salva = "minhasky"
				s1 = "minhasky"
			else
				s1 = salva
			end

			t29.value61[salva] = v664

			local writefile_ = writefile

			if writefile_ then
				writefile_ = readfile and (isfile and makefolder)

				if writefile_ then
					writefile_ = isfolder
				end
			end

			if writefile_ then
				local function v669()
					if isfolder("NexoraHub") then
						writefile(t29.value60, HttpService:JSONEncode(t29.value61))

						return
					end

					makefolder("NexoraHub")
					writefile(t29.value60, HttpService:JSONEncode(t29.value61))
				end

				v764 = pcall(v669)
			else
				v764 = false
			end

			t29.value62:SetOptions(v569())
			t29.value62:Set(salva)

			local value79 = t29.value79
			local s2 = "Title"
			local s3 = "Skybox"
			local s4 = "Content"

			if not v764 then
				value79:Notify({
					[s2] = s3,
					[s4] = v764 or "Aplicada, mas seu executor não salva arquivos.",
					Duration = 3
				})

				return
			end

			local v674 = "Salva: " .. salva

			value79:Notify({
				[s2] = s3,
				[s4] = v674 or "Aplicada, mas seu executor não salva arquivos.",
				Duration = 3
			})
		end
	}

	Visual.CreateButton(Visual, t35)
	t29.value62 = Visual.CreateDropdown(Visual, {
		Name = "Minhas skyboxes",
		Description = "Escolha uma que você salvou",
		Options = v569(),
		Flag = "CustomSkyDropdown",
		Callback = function(p97)
			local v675 = t29.value61[p97]

			if not v675 then
				return
			end

			v577(v675)
		end
	})

	local function v676()
		local apagada = t29.value62:Get()

		if not (apagada and t29.value61[apagada]) then
			t29.value79:Notify({
				Title = "Skybox",
				Content = "Nenhuma skybox selecionada.",
				Duration = 2
			})

			return
		end

		t29.value61[apagada] = nil

		local writefile_ = writefile

		if writefile_ then
			writefile_ = readfile and (isfile and makefolder)

			if writefile_ then
				writefile_ = isfolder
			end
		end

		if not writefile_ then
			t29.value62:SetOptions((v569()))
			t29.value79:Notify({
				Title = "Skybox",
				Content = "Apagada: " .. apagada,
				Duration = 2
			})

			return
		end

		local function v679()
			if isfolder("NexoraHub") then
				writefile(t29.value60, HttpService:JSONEncode(t29.value61))

				return
			end

			makefolder("NexoraHub")
			writefile(t29.value60, HttpService:JSONEncode(t29.value61))
		end

		pcall(v679)
		t29.value62:SetOptions((v569()))
		t29.value79:Notify({
			Title = "Skybox",
			Content = "Apagada: " .. apagada,
			Duration = 2
		})
	end

	Visual.CreateButton(Visual, {
		Name = "Apagar skybox selecionada",
		Description = "Remove da lista",
		Callback = v676
	})
	Visual:CreateSection("Bola")
	Visual.CreateDropdown(Visual, {
		Name = "Skin da bola",
		Description = "Troca a aparência da bola (só para você)",
		Options = {
			"Original",
			"Champions Laranja",
			"Champions Azul",
			"Champions Branca"
		},
		Default = "Original",
		Flag = "BallSkinDropdown",
		Callback = function(p98)
			v608(p98)
		end
	})
	Goalkeeper:CreateSection("Auto Dive")
	Goalkeeper.CreateToggle(Goalkeeper, {
		Name = "Ativar Auto Dive",
		Description = "Aperta sozinho a tecla certa de defesa/agarrar (Q/E/R/F/Z/C)",
		Default = false,
		Flag = "DiveToggle",
		Callback = function(p99)
			t29.value69.enabled = p99
		end
	})
	Goalkeeper.CreateSlider(Goalkeeper, {
		Name = "Alcance do Auto Dive (Studs)",
		Range = { 5, 30 },
		Increment = 1,
		Default = 15,
		Flag = "DiveRangeSlider",
		Callback = function(p100)
			t29.value69.range = p100
		end
	})

	local Misc = t29.value79:CreateTab("Misc")

	Misc:CreateSection("Ajustes Visuais")
	Misc.CreateToggle(Misc, {
		Name = "Stretched Resolution",
		Description = "Deixa a tela esticada",
		Default = true,
		Flag = "StretchedToggle",
		Callback = function(p101)
			if p101 then
				t29.value34()
			else
				t29.value35()
			end
		end
	})
	Misc.CreateSlider(Misc, {
		Name = "Ajuste de FOV / Resolução",
		Range = { 10, 100 },
		Increment = 1,
		Default = 100,
		Flag = "ResolutionSlider",
		Callback = function(p102)
			t29.value36(p102)
		end
	})

	local value79 = t29.value79

	value79.CreateCreditsTab(value79, {
		Credits = {
			{
				Name = "riive3lino",
				Role = "Criador e desenvolvedor do Nexora"
			},
			{
				Name = "Skyrovah",
				Role = "Contribuiu e ajudou no desenvolvimento"
			}
		},
		About = {
			Title = "Nexora Hub",
			Content = "Obrigado por usar o Nexora Hub! Sugestões e problemas podem ser enviados para o criador."
		}
	})
	t29.value79:CreateSettingsTab()
end

local v682 = nil

local function v683()
	print("[Nexora] Key válida, executando o script...")
	task.spawn(function()
		local t36 = { xpcall(v409, function(p103)
				local v685 = tostring(p103)
				local traceback = debug.traceback

				return v685 .. "\n" .. tostring(traceback())
			end) }
		local v687 = t36[2]

		if t36[1] then
			return
		end

		v682(v687)
	end)

	return true
end

v682 = function(p104)
	warn("[Nexora] " .. tostring(p104))

	local function v688()
		local ScreenGui = Instance.new("ScreenGui")

		ScreenGui.Name = "NexoraError"
		ScreenGui.ResetOnSpawn = false
		ScreenGui.DisplayOrder = 1000000

		local gethui_ = gethui

		if gethui_ then
			gethui_ = gethui()
		end

		ScreenGui.Parent = gethui_ or CoreGui

		local TextLabel = Instance.new("TextLabel")

		TextLabel.Size = UDim2.new(0.9, 0, 0, 170)
		TextLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
		TextLabel.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
		TextLabel.TextColor3 = Color3.fromRGB(255, 210, 210)
		TextLabel.TextWrapped = true
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.TextYAlignment = Enum.TextYAlignment.Top
		TextLabel.TextSize = 12
		TextLabel.Font = Enum.Font.Code

		local v692 = p104

		TextLabel.Text = "[Nexora] Erro (copiado para a área de transferência):\n" .. tostring(v692)
		TextLabel.Parent = ScreenGui

		if setclipboard then
			local v693 = p104

			setclipboard((tostring(v693)))
		end

		task.delay(40, function()
			ScreenGui:Destroy()
		end)
	end

	pcall(v688)
end

local ok, result = pcall(function()
	local isfile_ = isfile

	if not isfile_ then
		if isfile_ then
			return readfile("Nexora/key.txt")
		end

		return
	end

	isfile_ = isfile("Nexora/key.txt")

	if isfile_ then
		return readfile("Nexora/key.txt")
	end
end)
local v697 = ok and result and result or nil
local v698

if v697 then
	v698 = v697 ~= ""
else
	v698 = v697
end

if v698 then
	local v699 = v16(v697)

	if v699 then
		v699 = v683()
	end

	if v699 then
		return
	end
end

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "NexoraKey"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999

local gethui_ = gethui

if gethui_ then
	gethui_ = gethui()
end

ScreenGui.Parent = gethui_ or CoreGui

local Frame = Instance.new("Frame")

Frame.Size = UDim2.new(0, 360, 0, 210)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

local UIStroke = Instance.new("UIStroke", Frame)

UIStroke.Color = Color3.fromRGB(125, 70, 255)
UIStroke.Thickness = 1.5

local function createTextLabel(p105, p106, p107, p108)
	local TextLabel = Instance.new("TextLabel")

	TextLabel.BackgroundTransparency = 1
	TextLabel.Size = UDim2.new(1, -40, 0, p106 + 4)
	TextLabel.Position = UDim2.new(0, 20, 0, p107)
	TextLabel.Text = p105
	TextLabel.TextColor3 = Color3.fromRGB(235, 232, 255)

	local s5 = "Font"

	if not p108 then
		TextLabel[s5] = p108 or Enum.Font.Gotham
		TextLabel.TextSize = p106
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.Parent = Frame

		return TextLabel
	end

	p108 = Enum.Font.GothamBold
	TextLabel[s5] = p108 or Enum.Font.Gotham
	TextLabel.TextSize = p106
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Parent = Frame

	return TextLabel
end

createTextLabel("NEXORA", 20, 14, true)
createTextLabel("Insira sua key para continuar", 13, 42, false)

local TextBox = Instance.new("TextBox")

TextBox.Size = UDim2.new(1, -40, 0, 36)
TextBox.Position = UDim2.new(0, 20, 0, 76)
TextBox.BackgroundColor3 = Color3.fromRGB(34, 30, 54)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.PlaceholderText = "NEXORA-XXXX-XXXX-XXXX"
TextBox.PlaceholderColor3 = Color3.fromRGB(130, 125, 160)
TextBox.Font = Enum.Font.Gotham
TextBox.TextSize = 14
TextBox.ClearTextOnFocus = false
TextBox.Text = ""
TextBox.Parent = Frame
Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 8)

local v709 = createTextLabel("", 12, 118, false)

v709.TextColor3 = Color3.fromRGB(255, 120, 120)

local function createTextButton(p109, p110, p111, p112)
	local TextButton = Instance.new("TextButton")

	TextButton.Size = UDim2.new(0, p111, 0, 36)
	TextButton.Position = UDim2.new(0, p110, 0, 156)
	TextButton.BackgroundColor3 = p112
	TextButton.Text = p109
	TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton.Font = Enum.Font.GothamBold
	TextButton.TextSize = 13
	TextButton.AutoButtonColor = true
	TextButton.Parent = Frame
	Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 8)

	return TextButton
end

local v712 = false
local verificarKey = createTextButton("Verificar key", v712 and 180 or 20, v712 and 160 or 320, Color3.fromRGB(125, 70, 255))

if v712 then
	createTextButton("Pegar key", 20, 150, Color3.fromRGB(50, 44, 80)).MouseButton1Click:Connect(function()
		if setclipboard then
			setclipboard("")
			v709.TextColor3 = Color3.fromRGB(150, 255, 170)
			v709.Text = "Link copiado para a área de transferência."
		else
			v709.Text = ""
		end
	end)
end

verificarKey.MouseButton1Click:Connect(function()
	local v714 = TextBox.Text:gsub("%s+", "")

	if v714 == "" then
		v709.TextColor3 = Color3.fromRGB(255, 120, 120)
		v709.Text = "Digite uma key."

		return
	end

	v709.TextColor3 = Color3.fromRGB(200, 200, 255)
	v709.Text = "Verificando..."

	local v715, v716 = v16(v714)

	if not v715 then
		v709.TextColor3 = Color3.fromRGB(255, 120, 120)
		v709.Text = tostring(v716)

		return
	end

	pcall(function()
		local makefolder_ = makefolder

		if makefolder_ then
			makefolder_ = not isfolder("Nexora")
		end

		if makefolder_ then
			makefolder("Nexora")
		end

		if not writefile then
			return
		end

		writefile("Nexora/key.txt", v714)
	end)
	v709.TextColor3 = Color3.fromRGB(150, 255, 170)
	v709.Text = "Key válida! Tempo restante: " .. v6(v716.expiresAt)
	task.wait(0.8)
	ScreenGui:Destroy()
	v683()
end)
