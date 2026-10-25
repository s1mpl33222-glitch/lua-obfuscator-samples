-- This file was generated at discord.gg/syncrypt

("VoidedX:591969746"):gsub(".+", function(p1)
	_dZhabtb = p1
end)

local unpack_ = unpack or table.unpack
local handlers = {}

if _dZhabtb ~= "VoidedX:591969746" then
	return
end

handlers[23] = loadstring

local t1 = {
	value1 = handlers[23]
}

if not handlers[23] then
	handlers[23] = load
	t1.value1 = handlers[23]
end

handlers[1] = { nil }
handlers[1][1] = t1.value1

if not table.clear then
	function t1.value2(p2)
		for k in pairs(p2) do
			p2[k] = nil
		end
	end

	t1.value3 = table
	t1.value3.clear = t1.value2
end

t1.value1 = tick or os.clock

local t2 = {
	value1 = t1.value1
}
local value1 = t2.value1
local v7 = tostring(value1())
local random = math.random

t1.value3 = v7 .. tostring(random(1000, 9999))
t2.value2 = t1.value3
t1.value1 = type
handlers[25] = _G
handlers[26] = handlers[25].NapoleonCleanup
handlers[24] = t1.value1(handlers[26])

if handlers[24] == "function" then
	t1.value3 = pcall
	handlers[26] = _G
	handlers[24] = handlers[26].NapoleonCleanup
	t1.value3(handlers[24])
end

t1.value3 = _G
handlers[2] = { nil }
t2.value3 = nil
handlers[24] = t2.value2
t1.value3.NapoleonRunId = handlers[24]

function t1.value3()
	return _G.NapoleonRunId == t2.value2
end

handlers[3] = { nil }
t2.value4 = t1.value3

function t1.value4()
	local isfile_ = isfile

	if isfile_ then
		isfile_ = isfile("napoleon_bg_v1.png")
	end

	if isfile_ and getcustomasset then
		t2.value3 = getcustomasset("napoleon_bg_v1.png")
	end

	if t2.value3 then
		return
	end

	local response = game:HttpGet("https://tr.rbxcdn.com/180DAY-c6af2404d410dd3273a96997d7f6a6d4/420/420/Decal/Webp/noFilter")

	if writefile then
		writefile("napoleon_bg_v1.png", response)
	end

	if not getcustomasset then
		return
	end

	t2.value3 = getcustomasset("napoleon_bg_v1.png")
end
function t1.value3(p3)
	local ok, result = pcall(function()
		return game:HttpGet(p3)
	end)

	if ok then
		return result
	end

	error("Falha HTTP: " .. p3)

	return result
end

handlers[3][1] = t1.value3
handlers[2][1] = "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
t1.value3 = nil
t1.value1 = "pcall"
t2.value3 = t1.value3
t1.value3 = pcall
t1.value4 = t1.value3(t1.value4)
t1.value1 = not (t1.value4 and t2.value3)

if t1.value1 then
	t1.value3 = "rbxassetid://6031091004"
	t2.value3 = "rbxassetid://6031091004"
end

t1.value4 = nil
t1.value1 = nil
t2.value5 = t1.value1

local v13 = handlers[3]
local v14 = handlers[2]
local v15 = handlers[1]

local function v16()
	local v17 = v13[1](v14[1])
	local v18 = v15[1](v17)

	if v18 then
		return v18()
	end

	error("loadstring nil para WindUI")

	return v18()
end

t2.value5 = v16()
t1.value6 = game:GetService("Players")
t2.value6 = t1.value6
t1.value6 = game:GetService("RunService")
t2.value7 = t1.value6
t1.value6 = game:GetService("UserInputService")
t2.value8 = t1.value6
t1.value6 = game:GetService("GuiService")
handlers[4] = { nil }
handlers[4][1] = t1.value6
t1.value6 = game:GetService("TweenService")
t2.value9 = t1.value6
t1.value6 = game:GetService("ReplicatedStorage")
handlers[5] = { nil }
handlers[5][1] = t1.value6
t1.value6 = game:GetService("VirtualInputManager")
t2.value10 = t1.value6
t1.value6 = game:GetService("Workspace")
t2.value11 = t1.value6
t1.value6 = game:GetService("Lighting")
t2.value12 = t1.value6
t1.value6 = game:GetService("CoreGui")
t2.value13 = t1.value6
t1.value6 = game:GetService("HttpService")
t2.value14 = t1.value6
t1.value1 = t2.value6.LocalPlayer
t2.value15 = t1.value1
handlers[27] = t2.value15:WaitForChild("PlayerGui")
t2.value16 = handlers[27]
t1.value1 = pcall

function t1.value7()
	local t3 = { t2.value13, t2.value16 }

	pcall(function()
		local gethui_ = gethui

		if gethui_ then
			gethui_ = gethui()
		end

		if not gethui_ then
			return
		end

		local v21 = t3

		table.insert(v21, gethui_)
	end)

	for _, v in ipairs(t3) do
		pcall(function()
			local v24 = v

			for _, child in ipairs(v24.GetChildren(v24)) do
				if child.Name == "NapoleonLoading" then
					child:Destroy()
				end
			end
		end)
	end

	for _, v in ipairs({ "NapoleonKeyBlur", "NapoleonLoadBlur" }) do
		local v29 = t2.value12:FindFirstChild(v)

		if v29 then
			v29:Destroy()
		end
	end

	local NapoleonHubPredict = t2.value11:FindFirstChild("NapoleonHubPredict")

	if NapoleonHubPredict then
		NapoleonHubPredict:Destroy()
	end

	local NapoleonClientPredict = t2.value11:FindFirstChild("NapoleonClientPredict")

	if not NapoleonClientPredict then
		return
	end

	NapoleonClientPredict:Destroy()
end

handlers[27] = t1.value1(t1.value7)
t1.value7 = t2.value8.TouchEnabled

local value7 = t1.value7
local value3 = t1.value3

t1.value1 = value7
handlers[27] = value3

if t1.value7 then
	handlers[28] = t2.value8
	t1.value1 = not handlers[28].KeyboardEnabled
end

local v34 = handlers[27]

t1.value9 = false
t1.value3 = v34
handlers[6] = { nil }
handlers[6][1] = t1.value1

function t1.value1()
	local vector2 = Vector2.new(1280, 720)
	local ViewportSize = nil

	local function v37()
		ViewportSize = t2.value11.CurrentCamera.ViewportSize
	end

	ViewportSize = vector2
	pcall(v37)

	return ViewportSize
end

t2.value17 = t1.value1

local function v38(p4, p5)
	local v39 = t2.value17()
	local uDim2 = UDim2.fromOffset
	local v41 = v39.X * 0.92
	local v42 = math.max(300, v41)
	local v43 = math.clamp(p4, 300, v42)

	return uDim2(math.floor(v43), (math.floor((math.clamp(p5, 220, (math.max(220, v39.Y * 0.85)))))))
end

t2.value18 = 60
t2.value19 = nil
t1.value1 = t2.value7.Heartbeat
handlers[7] = { nil }

function t1.value10(p6)
	if not t2.value4() then
		t2.value19:Disconnect()

		return
	end

	if not (p6 > 0) then
		return
	end

	t2.value18 = t2.value18 + (1 / p6 - t2.value18) * 0.05
end

t1.value11 = t1.value1:Connect(t1.value10)
t2.value19 = t1.value11

local function v44()
	local function v45()
		local value12 = t2.value12
		local v47 = value12.FindFirstChild(value12, "NapoleonKeyBlur")

		if not v47 then
			return
		end

		v47:Destroy()
	end

	pcall(v45)
end

function t1.value1()
	local function v48()
		local BlurEffect = Instance.new("BlurEffect")

		BlurEffect.Name = "NapoleonKeyBlur"
		BlurEffect.Size = 0
		BlurEffect.Parent = t2.value12
		t2.value9:Create(BlurEffect, TweenInfo.new(0.6), {
			Size = 20
		}):Play()
	end
	local function v50()
		local value12 = t2.value12
		local v52 = value12.FindFirstChild(value12, "NapoleonKeyBlur")

		if not v52 then
			return
		end

		v52:Destroy()
	end

	pcall(v50)
	pcall(v48)
end

handlers[7][1] = t1.value1

function t1.value1(p7)
	local v53 = nil

	local function v54()
		local v55 = v53
		local v56 = v53
		local t4 = {
			["0"] = {
				Color = Color3.fromHex("#f3e1ae"),
				Transparency = 0
			},
			["50"] = {
				Color = Color3.fromHex("#cfae63"),
				Transparency = 0
			},
			["100"] = {
				Color = Color3.fromHex("#7a5e28"),
				Transparency = 0
			}
		}
		local v58 = v56.Gradient(v56, t4, {
			Rotation = 90
		})
		local color3 = Color3.fromHex("#0b0907")
		local color32 = Color3.fromHex("#cfae63")
		local color33 = Color3.fromHex("#f7edd8")
		local color34 = Color3.fromHex("#8a7a5c")
		local v63 = v53
		local color35 = Color3.fromHex("#2c2519")
		local AddTheme = v55.AddTheme
		local Gradient = v63.Gradient
		local t5 = {
			["0"] = {
				Color = color35,
				Transparency = 0
			},
			["100"] = {
				Color = Color3.fromHex("#16120d"),
				Transparency = 0
			}
		}
		local v68 = v53
		local t6 = {
			Name = "Napoleon",
			Accent = v58,
			Dialog = color3,
			Outline = color32,
			Text = color33,
			Placeholder = color34,
			Button = Gradient(v63, t5, {
				Rotation = 90
			}),
			Icon = Color3.fromHex("#e0c27a"),
			Toggle = Color3.fromHex("#d9b96a"),
			Slider = Color3.fromHex("#c9a961"),
			Checkbox = Color3.fromHex("#d9b96a"),
			SliderIcon = Color3.fromHex("#f3e1ae"),
			Primary = Color3.fromHex("#d9b96a")
		}
		local t7 = {
			["0"] = {
				Color = Color3.fromHex("#080604"),
				Transparency = 0.1
			},
			["100"] = {
				Color = Color3.fromHex("#1b150e"),
				Transparency = 0.1
			}
		}

		t6.Background = v68:Gradient(t7, {
			Rotation = 125
		})
		t6.PanelBackground = Color3.fromHex("#100d09")
		t6.PanelBackgroundTransparency = 0.18
		t6.LabelBackground = Color3.fromHex("#000000")
		t6.LabelBackgroundTransparency = 0.7
		t6.ElementBackground = Color3.fromHex("#1d1912")
		t6.ElementBackgroundTransparency = 0.2
		AddTheme(v55, t6)
		v53:SetTheme("Napoleon")
	end

	v53 = p7
	pcall(v54)
end

t2.value20 = t1.value1
t2.value20(t2.value5)

function t1.value1(p8)
	pcall(function()
		local v71 = p8
		local v72 = p8
		local t8 = {
			["0"] = {
				Color = Color3.fromHex("#f9ecc0"),
				Transparency = 0
			},
			["50"] = {
				Color = Color3.fromHex("#cfae63"),
				Transparency = 0
			},
			["100"] = {
				Color = Color3.fromHex("#6b5224"),
				Transparency = 0
			}
		}
		local v74 = v72:Gradient(t8, {
			Rotation = 90
		})
		local color3 = Color3.fromHex("#070503")
		local color32 = Color3.fromHex("#cfae63")
		local color33 = Color3.fromHex("#f7edd8")
		local color34 = Color3.fromHex("#8a7a5c")
		local v79 = p8
		local color35 = Color3.fromHex
		local Gradient = v79.Gradient
		local t9 = {
			["0"] = {
				Color = color35("#2e2718"),
				Transparency = 0
			},
			["100"] = {
				Color = Color3.fromHex("#15110c"),
				Transparency = 0
			}
		}
		local v83 = Gradient(v79, t9, {
			Rotation = 90
		})
		local color36 = Color3.fromHex("#f3e1ae")
		local AddTheme = v71.AddTheme
		local v86 = p8
		local t10 = {
			Name = "NapoleonKeys",
			Accent = v74,
			Dialog = color3,
			Outline = color32,
			Text = color33,
			Placeholder = color34,
			Button = v83,
			Icon = color36,
			Toggle = Color3.fromHex("#d9b96a"),
			Slider = Color3.fromHex("#c9a961"),
			Checkbox = Color3.fromHex("#d9b96a"),
			SliderIcon = Color3.fromHex("#f3e1ae"),
			Primary = Color3.fromHex("#d9b96a")
		}
		local t11 = {
			["0"] = {
				Color = Color3.fromHex("#050403"),
				Transparency = 0.08
			},
			["100"] = {
				Color = Color3.fromHex("#1c1610"),
				Transparency = 0.08
			}
		}

		t10.Background = v86:Gradient(t11, {
			Rotation = 135
		})
		t10.PanelBackground = Color3.fromHex("#0e0c09")
		t10.PanelBackgroundTransparency = 0.18
		t10.LabelBackground = Color3.fromHex("#000000")
		t10.LabelBackgroundTransparency = 0.65
		t10.ElementBackground = Color3.fromHex("#1a1610")
		t10.ElementBackgroundTransparency = 0.18
		AddTheme(v71, t10)
		p8:SetTheme("NapoleonKeys")
	end)
end

handlers[8] = { nil }
handlers[8][1] = t1.value1

local function v89(p9, p10, p11)
	if p9 then
		for _, v in ipairs(p10) do
			local v92 = p9[v]

			if type(v92) == "function" then
				local t12 = { pcall(p9[v], p9, p11) }
				local v94 = t12[2]

				if t12[1] then
					return v94 or true
				end
			end
		end

		return nil
	else
		return nil
	end
end

handlers[9] = { nil }

local function v95(p12, p13)
	return v89(p12, { "Slider", "AddSlider", "CreateSlider" }, p13)
end
local function v96(p14, p15)
	return v89(p14, { "Dropdown", "AddDropdown", "CreateDropdown" }, p15)
end

function t1.value1(p16, p17)
	return v89(p16, {
		"Input",
		"AddInput",
		"CreateInput",
		"TextBox"
	}, p17)
end

handlers[9][1] = t1.value1

local function v97(p18, p19, p20)
	if not p18 or p18 == true then
		return
	end

	pcall(function()
		p18:SetTitle(p19)
	end)
	pcall(function()
		p18:SetDesc(p20)
	end)
end

t1.value15 = Color3.fromRGB(0, 0, 0)
t2.value21 = {
	AutoDive = false,
	AutoCatch = false,
	AutoPos = t1.value9,
	Mode = "Legit",
	DiveRange = 35,
	CatchRange = 8,
	MinSpeed = 0,
	MaxSpeed = 200,
	Predict = true,
	PredictTime = 0.4,
	DiveCooldown = 0,
	CatchCooldown = 0.2,
	HighThreshold = 1.4,
	SideThreshold = 2,
	Theme = "Napoleon",
	DiveLead = 0.6,
	ReachOn = false,
	ReachDist = 5,
	ReachSphere = true,
	DisableNotify = false,
	BallESP = false,
	BallESPColor = "Ciano",
	BallESPTrans = 3,
	PredictColor = t1.value15,
	PredictRGB = false,
	Language = "Português (BR)"
}

local function v98(p21)
	if t2.value21.DisableNotify then
		return
	end

	if not t2.value5 then
		return
	end

	local Notify = t2.value5.Notify

	if type(Notify) == "function" then
		local function v100()
			t2.value5:Notify(p21)
		end

		pcall(v100)

		return
	end

	local Notification = t2.value5.Notification

	if Notification then
		local Notification2 = t2.value5.Notification

		Notification = type(Notification2) == "function"
	end

	if not Notification then
		return
	end

	local function v103()
		t2.value5:Notification(p21)
	end

	pcall(v103)
end

local value32 = t1.value3

t1.value13 = {}
t1.value3 = value32
t1.value9 = {}
handlers[10] = { nil }
t2.value22 = {
	Osc = t1.value13,
	Spin = t1.value9,
	Pulse = {}
}
handlers[11] = { nil }

function t2.value23(p22)
	local Osc = t2.value22.Osc

	table.insert(Osc, p22)
end
function t1.value1(p23)
	local Spin = t2.value22.Spin

	table.insert(Spin, p23)
end

handlers[11][1] = t1.value1

function t1.value1(p24)
	local Pulse = t2.value22.Pulse

	table.insert(Pulse, p24)
end

handlers[10][1] = t1.value1
t1.value1 = task.spawn

function t1.value12()
	while t2.value4() do
		local v108 = t2.value1()

		for i = #t2.value22.Osc, 1, -1 do
			local v110 = t2.value22.Osc[i]
			local Parent

			if v110 then
				Parent = v110.Parent
			else
				Parent = v110
			end

			if Parent then
				pcall(function()
					local v112 = v110
					local v113 = v108 * 1.6

					v112.Rotation = math.sin(v113) * 18 + 90
				end)
			else
				table.remove(t2.value22.Osc, i)
			end
		end

		for i = #t2.value22.Spin, 1, -1 do
			local v115 = t2.value22.Spin[i]
			local Parent

			if v115 then
				Parent = v115.Parent
			else
				Parent = v115
			end

			if Parent then
				pcall(function()
					v115.Rotation = v108 * 25 % 360
				end)
			else
				table.remove(t2.value22.Spin, i)
			end
		end

		for i = #t2.value22.Pulse, 1, -1 do
			local v118 = t2.value22.Pulse[i]
			local Parent

			if v118 then
				Parent = v118.Parent
			else
				Parent = v118
			end

			if Parent then
				pcall(function()
					local v120 = v118
					local v121 = v108 * 2.2

					v120.Transparency = math.sin(v121) * 0.2 + 0.45
				end)
			else
				table.remove(t2.value22.Pulse, i)
			end
		end

		task.wait()
	end
end

t1.value1(t1.value12)
t2.value24 = {
	Attached = {}
}

function t1.value1(...)
	local t13 = { pcall(Font.new, ...) }
	local v123 = t13[2]

	if t13[1] then
		return v123
	else
		return nil
	end
end

t1.value11 = Enum
t1.value12 = t1.value1
t1.value1 = t1.value12(t1.value11.Font.Bodoni, Enum.FontWeight.Bold, Enum.FontStyle.Normal) or t1.value12("rbxasset://fonts/families/Bodoni.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
t1.value3 = t1.value3
t1.value20 = "rbxasset://fonts/families/BuilderSans.json"
t1.value19 = "Enum"
t2.value25 = t1.value1
t1.value18 = Enum.FontWeight.SemiBold
t1.value17 = Enum.FontStyle.Normal
t1.value1 = t1.value12("rbxasset://fonts/families/BuilderSans.json", t1.value18, t1.value17)
t2.value26 = t1.value1
t1.value1 = t1.value12("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
t2.value27 = t1.value1
t1.value1 = t1.value12("rbxasset://fonts/families/RomanAntique.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
t2.value28 = t1.value1

function t1.value1(p25, p26, p27)
	if p26 and pcall(function()
		p25.FontFace = p26
	end) then
		return
	end

	if not p27 then
		return
	end

	pcall(function()
		p25.Font = p27
	end)
end

t2.value29 = t1.value1
t1.value19 = Color3.fromHex("#f9ecc0")
t2.value30 = t1.value19
t1.value19 = Color3.fromHex("#d9b96a")
t2.value31 = t1.value19
t1.value19 = Color3
t1.value19 = t1.value19.fromHex("#8a6a2f")
t2.value32 = t1.value19

local function v124()
	local t14 = { t2.value13, t2.value16 }

	pcall(function()
		local gethui_ = gethui

		if gethui_ then
			gethui_ = gethui()
		end

		if not gethui_ then
			return
		end

		local v127 = t14

		table.insert(v127, gethui_)
	end)

	return t14
end

function t1.value1(p28)
	local function v128()
		if not (p28:IsA("TextLabel") or (p28:IsA("TextButton") or p28:IsA("TextBox"))) then
			return
		end

		local v129 = tostring(p28.Text or "")
		local v130 = string.lower(p28.Name or "")

		if v129:find("NAPOLEON HUB") then
			t2.value29(p28, t2.value25, Enum.Font.Bodoni)

			if p28.TextSize < 19 then
				p28.TextSize = 20
			end

			p28.TextColor3 = t2.value30

			if not p28:FindFirstChild("ImperialTitleGrad") then
				local UIGradient = Instance.new("UIGradient")

				UIGradient.Name = "ImperialTitleGrad"
				UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t2.value30), ColorSequenceKeypoint.new(0.55, t2.value31), ColorSequenceKeypoint.new(1, t2.value32) })
				UIGradient.Rotation = 90
				UIGradient.Parent = p28
				t2.value23(UIGradient)
			end

			if p28:FindFirstChild("ImperialTitleStroke") then
				return
			end

			local UIStroke = Instance.new("UIStroke")

			UIStroke.Name = "ImperialTitleStroke"
			UIStroke.Color = Color3.fromHex("#3a2c12")
			UIStroke.Transparency = 0.25
			UIStroke.Thickness = 1
			UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
			UIStroke.Parent = p28
		else
			local pos = v130:find("tag")

			if pos then
				if pos then
					t2.value29(p28, t2.value28, Enum.Font.Antique)

					return
				elseif (p28.TextSize or 14) >= 17 then
					t2.value29(p28, t2.value26, Enum.Font.GothamBold)

					return
				else
					t2.value29(p28, t2.value27, Enum.Font.Gotham)

					return
				end
			end

			pos = p28.Parent

			if pos then
			elseif pos then
				t2.value29(p28, t2.value28, Enum.Font.Antique)

				return
			elseif (p28.TextSize or 14) >= 17 then
				t2.value29(p28, t2.value26, Enum.Font.GothamBold)

				return
			else
				t2.value29(p28, t2.value27, Enum.Font.Gotham)

				return
			end

			pos = string.lower(p28.Parent.Name or ""):find("tag")

			if pos then
				t2.value29(p28, t2.value28, Enum.Font.Antique)

				return
			elseif (p28.TextSize or 14) >= 17 then
				t2.value29(p28, t2.value26, Enum.Font.GothamBold)

				return
			else
				t2.value29(p28, t2.value27, Enum.Font.Gotham)

				return
			end
		end
	end

	pcall(v128)
end

t2.value33 = t1.value1
task.spawn(function()
	while t2.value4() do
		for k in pairs(t2.value24.Attached) do
			if not (k and k.Parent) then
				t2.value24.Attached[k] = nil
			end
		end

		for _, v in ipairs((v124())) do
			local function v137()
				local v138 = v

				for _, child in ipairs(v138.GetChildren(v138)) do
					local isScreenGui = child:IsA("ScreenGui")

					if isScreenGui then
						isScreenGui = child.Name == "WindUI" and true or child.Name:find("WindUI") ~= nil
					end

					if isScreenGui then
						isScreenGui = not t2.value24.Attached[child]
					end

					if isScreenGui then
						t2.value24.Attached[child] = true

						for _, descendant in ipairs(child.GetDescendants(child)) do
							t2.value33(descendant)
						end

						child.DescendantAdded:Connect(function(descendant)
							task.defer(function()
								t2.value33(descendant)
							end)
						end)
					end
				end
			end

			pcall(v137)
		end

		task.wait(2)
	end
end)
t2.value34 = {}
t2.value35 = nil
task.spawn(function()
	local function v144()
		return t2.value6:GetUserThumbnailAsync(t2.value15.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
	end

	local ok, value35 = pcall(v144)

	if ok then
		ok = value35
	end

	if not ok then
		return
	end

	t2.value35 = value35

	for _, v in ipairs(t2.value34) do
		pcall(function()
			local Avatar = v:FindFirstChild("Avatar")

			if not Avatar then
				return
			end

			Avatar.Image = value35
		end)
	end
end)

function t1.value1(p29)
	local vector2 = Vector2.new(1920, 1080)

	local function v151()
		vector2 = t2.value11.CurrentCamera.ViewportSize
	end

	pcall(v151)

	local GetDescendants = p29.GetDescendants
	local v153 = vector2
	local n1 = 0
	local v155 = nil

	for _, v in ipairs(GetDescendants(p29)) do
		local isCanvasGroup = not v:IsA("Frame") and v:IsA("CanvasGroup")

		if isCanvasGroup then
			isCanvasGroup = v.Visible
		end

		if isCanvasGroup then
			local AbsoluteSize = v.AbsoluteSize
			local v160 = AbsoluteSize.X >= 300

			if v160 then
				v160 = AbsoluteSize.Y >= 250

				if v160 then
					if AbsoluteSize.X <= v153.X * 0.95 then
						v160 = AbsoluteSize.Y <= v153.Y * 0.95
					else
						v160 = false
					end
				end
			end

			if v160 then
				local v161 = AbsoluteSize.X * AbsoluteSize.Y

				if n1 < v161 then
					v155 = v
					n1 = v161
				end
			end
		end
	end

	return v155
end

t2.value36 = t1.value1

local v162 = handlers[11]
local v163 = handlers[10]

function t1.value1(p30)
	if #t2.value34 > 0 then
		return
	end

	local v164 = t2.value36(p30)

	if not v164 then
		return
	end

	if v164.AbsoluteSize.X < 600 then
		return
	end

	if v164:FindFirstChild("NapoleonUserCard") then
		return
	end

	if not v164:FindFirstChild("ImperialWindowGlow") then
		local UIStroke = Instance.new("UIStroke")

		UIStroke.Name = "ImperialWindowGlow"
		UIStroke.Color = Color3.fromHex("#e8d5a0")
		UIStroke.Thickness = 1.5
		UIStroke.Transparency = 0.55
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke.Parent = v164

		local UIGradient = Instance.new("UIGradient")

		UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("#7a5e28")), ColorSequenceKeypoint.new(0.5, Color3.fromHex("#f9ecc0")), ColorSequenceKeypoint.new(1, Color3.fromHex("#7a5e28")) })
		UIGradient.Parent = UIStroke
		v162[1](UIGradient)
		v163[1](UIStroke)
	end

	local Frame = Instance.new("Frame")

	Frame.Name = "NapoleonUserCard"
	Frame.AnchorPoint = Vector2.new(0, 1)
	Frame.Position = UDim2.new(0, 14, 1, -14)
	Frame.Size = UDim2.new(0, 168, 0, 56)
	Frame.BackgroundColor3 = Color3.fromHex("#12100c")
	Frame.BackgroundTransparency = 0.12
	Frame.ZIndex = 60
	Frame.Parent = v164

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = Frame

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = Color3.fromHex("#c9a961")
	UIStroke.Thickness = 1
	UIStroke.Transparency = 0.35
	UIStroke.Parent = Frame

	local UIGradient = Instance.new("UIGradient")

	UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("#221c12")), ColorSequenceKeypoint.new(1, Color3.fromHex("#0b0906")) })
	UIGradient.Rotation = 90
	UIGradient.Parent = Frame

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Name = "Avatar"
	ImageLabel.Size = UDim2.new(0, 34, 0, 34)
	ImageLabel.Position = UDim2.new(0, 6, 0.5, 0)
	ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
	ImageLabel.BackgroundColor3 = Color3.fromHex("#0a0806")
	ImageLabel.BackgroundTransparency = 0
	ImageLabel.Image = t2.value35 or "rbxassetid://6031091004"
	ImageLabel.ScaleType = Enum.ScaleType.Crop
	ImageLabel.ZIndex = 61
	ImageLabel.Parent = Frame

	local UICorner2 = Instance.new("UICorner")

	UICorner2.CornerRadius = UDim.new(1, 0)
	UICorner2.Parent = ImageLabel

	local UIStroke2 = Instance.new("UIStroke")

	UIStroke2.Color = Color3.fromHex("#e8d5a0")
	UIStroke2.Thickness = 1.5
	UIStroke2.Transparency = 0.15
	UIStroke2.Parent = ImageLabel

	local Frame2 = Instance.new("Frame")

	Frame2.Name = "OnlineDot"
	Frame2.Size = UDim2.new(0, 10, 0, 10)
	Frame2.Position = UDim2.new(1, -4, 1, -4)
	Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame2.BackgroundColor3 = Color3.fromRGB(90, 220, 120)
	Frame2.BorderSizePixel = 0
	Frame2.ZIndex = 63
	Frame2.Parent = ImageLabel

	local UICorner3 = Instance.new("UICorner")

	UICorner3.CornerRadius = UDim.new(1, 0)
	UICorner3.Parent = Frame2

	local UIStroke3 = Instance.new("UIStroke")

	UIStroke3.Color = Color3.fromHex("#0b0906")
	UIStroke3.Thickness = 1.5
	UIStroke3.Parent = Frame2

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Name = "DisplayName"
	TextLabel.Size = UDim2.new(1, -52, 0, 18)
	TextLabel.Position = UDim2.new(0, 46, 0, 8)
	TextLabel.BackgroundTransparency = 1

	local DisplayName = t2.value15.DisplayName

	TextLabel.Text = tostring(DisplayName)
	TextLabel.TextColor3 = Color3.fromHex("#e8d5a0")
	TextLabel.TextSize = 13
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
	TextLabel.ZIndex = 61
	TextLabel.Parent = Frame

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Name = "Username"
	TextLabel2.Size = UDim2.new(1, -52, 0, 14)
	TextLabel2.Position = UDim2.new(0, 46, 0, 27)
	TextLabel2.BackgroundTransparency = 1

	local Name = t2.value15.Name

	TextLabel2.Text = "@" .. tostring(Name)
	TextLabel2.TextColor3 = Color3.fromHex("#8a7a5c")
	TextLabel2.TextSize = 11
	TextLabel2.Font = Enum.Font.Gotham
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.TextTruncate = Enum.TextTruncate.AtEnd
	TextLabel2.ZIndex = 61
	TextLabel2.Parent = Frame

	local ImageLabel2 = Instance.new("ImageLabel")

	ImageLabel2.Name = "Crown"
	ImageLabel2.Size = UDim2.new(0, 16, 0, 16)
	ImageLabel2.Position = UDim2.new(1, -22, 0.5, 0)
	ImageLabel2.AnchorPoint = Vector2.new(0, 0.5)
	ImageLabel2.BackgroundTransparency = 1
	ImageLabel2.Image = "rbxassetid://6031091004"
	ImageLabel2.ImageColor3 = Color3.fromHex("#c9a961")
	ImageLabel2.ZIndex = 61
	ImageLabel2.Parent = Frame

	local value34 = t2.value34

	table.insert(value34, Frame)
end

t2.value37 = t1.value1
task.spawn(function()
	while t2.value4() do
		for _, v in ipairs((v124())) do
			local function v185()
				local v186 = v

				for _, child in ipairs(v186.GetChildren(v186)) do
					local isScreenGui = child:IsA("ScreenGui")

					if isScreenGui then
						isScreenGui = child.Name == "WindUI" and true or child.Name:find("WindUI") ~= nil
					end

					if isScreenGui then
						local v190 = t2.value36(child)
						local v191

						if v190 then
							v191 = v190.AbsoluteSize.X < 600
						else
							v191 = v190
						end

						local NapoleonUserCard = v191 and v190:FindFirstChild("NapoleonUserCard")

						if NapoleonUserCard then
							NapoleonUserCard:Destroy()
						end

						t2.value37(child)
					end
				end
			end

			pcall(v185)
		end

		for i = #t2.value34, 1, -1 do
			if not (t2.value34[i] and t2.value34[i].Parent) then
				table.remove(t2.value34, i)
			end
		end

		task.wait(1)
	end
end)
t2.value38 = {}
t2.value39 = nil

local function v194()
	for i = #t2.value38, 1, -1 do
		local v196 = t2.value38[i]
		local Parent

		if v196 then
			Parent = v196.Parent
		else
			Parent = v196
		end

		if Parent then
			local NapoleonImg = v196:FindFirstChild("NapoleonImg")

			if NapoleonImg then
				NapoleonImg.ImageTransparency = 0.55
				NapoleonImg.ImageColor3 = Color3.fromRGB(255, 240, 210)
			end
		else
			table.remove(t2.value38, i)
		end
	end
end

function t1.value1()
	if t2.value39 then
		pcall(task.cancel, t2.value39)
		t2.value39 = nil
	end

	t2.value39 = task.spawn(function()
		local function v199()
			local t15 = {}

			local function v201()
				local v202 = t15
				local value13 = t2.value13

				table.insert(v202, value13)
			end

			pcall(v201)

			local function v204()
				local v205 = t15
				local value16 = t2.value16

				table.insert(v205, value16)
			end

			pcall(v204)
			pcall(function()
				local gethui_ = gethui

				if gethui_ then
					gethui_ = gethui()
				end

				if not gethui_ then
					return
				end

				local v208 = t15

				table.insert(v208, gethui_)
			end)

			return t15
		end
		local function v209(p31)
			if not (p31 and p31.Parent) then
				return
			end

			local vector2 = Vector2.new(1920, 1080)

			local function v211()
				vector2 = t2.value11.CurrentCamera.ViewportSize
			end

			pcall(v211)

			local GetDescendants = p31.GetDescendants
			local ipairs_ = ipairs
			local v214 = vector2
			local n2 = 0
			local v216 = nil

			for _, v in ipairs_(GetDescendants(p31)) do
				local isCanvasGroup = not v:IsA("Frame") and v:IsA("CanvasGroup")

				if isCanvasGroup then
					isCanvasGroup = v.Visible
				end

				if isCanvasGroup then
					local AbsoluteSize = v.AbsoluteSize

					ipairs_ = v.AbsolutePosition

					local v221 = AbsoluteSize.X >= 400

					if v221 then
						v221 = AbsoluteSize.Y >= 300

						if v221 then
							v221 = AbsoluteSize.X <= v214.X * 0.95

							if v221 then
								v221 = AbsoluteSize.Y <= v214.Y * 0.95

								if v221 then
									if ipairs_.X >= 0 then
										v221 = ipairs_.Y >= 0
									else
										v221 = false
									end
								end
							end
						end
					end

					if v221 then
						ipairs_ = AbsoluteSize.X * AbsoluteSize.Y

						if n2 < ipairs_ then
							v216 = v
							n2 = ipairs_
						end
					end
				end
			end

			if not v216 then
				return
			end

			local AbsolutePosition = v216.AbsolutePosition
			local GetDescendants2 = v216.GetDescendants
			local n3 = 0
			local v225 = nil

			for _, v in ipairs(GetDescendants2(v216)) do
				local isFrame = v:IsA("Frame") or (v:IsA("CanvasGroup") or v:IsA("ScrollingFrame"))

				if isFrame then
					isFrame = v.Visible
				end

				if isFrame then
					local AbsolutePosition2 = v.AbsolutePosition
					local AbsoluteSize = v.AbsoluteSize
					local v231 = AbsolutePosition2.X >= AbsolutePosition.X + 100

					if v231 then
						v231 = AbsoluteSize.X >= 200

						if v231 then
							v231 = AbsoluteSize.Y >= 150

							if v231 then
								if AbsoluteSize.X <= v214.X * 0.95 then
									v231 = AbsoluteSize.Y <= v214.Y * 0.95
								else
									v231 = false
								end
							end
						end
					end

					if v231 then
						local v232 = AbsoluteSize.X * AbsoluteSize.Y

						if n3 < v232 then
							v225 = v
							n3 = v232
						end
					end
				end
			end

			local v233 = nil

			local function v234()
				v233.ClipsDescendants = true
			end

			v233 = v225 or v216
			pcall(v234)

			local v235 = v233

			for _, child in ipairs(v233:GetChildren()) do
				if child.Name == "NapoleonWatermark" then
					return
				end
			end

			local Frame = Instance.new("Frame")

			Frame.Name = "NapoleonWatermark"
			Frame.BackgroundTransparency = 1
			Frame.Size = UDim2.fromScale(1, 1)
			Frame.Position = UDim2.fromScale(0, 0)
			Frame.ZIndex = 0
			Frame.ClipsDescendants = true
			Frame.Parent = v235

			local UICorner = Instance.new("UICorner")

			UICorner.CornerRadius = UDim.new(0, 8)
			UICorner.Parent = Frame

			local ImageLabel = Instance.new("ImageLabel")

			ImageLabel.Name = "NapoleonImg"
			ImageLabel.Image = t2.value3
			ImageLabel.ImageTransparency = 0.55
			ImageLabel.ImageColor3 = Color3.fromRGB(255, 240, 210)
			ImageLabel.BackgroundTransparency = 1
			ImageLabel.Size = UDim2.fromScale(1, 1)
			ImageLabel.Position = UDim2.fromScale(0, 0)
			ImageLabel.ZIndex = 0
			ImageLabel.ScaleType = Enum.ScaleType.Fit
			ImageLabel.Parent = Frame

			local UIGradient = Instance.new("UIGradient")

			UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.05), NumberSequenceKeypoint.new(0.5, 0.35), NumberSequenceKeypoint.new(1, 0.65) })
			UIGradient.Rotation = 90
			UIGradient.Parent = ImageLabel

			local UIGradient2 = Instance.new("UIGradient")

			UIGradient2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.55), NumberSequenceKeypoint.new(0.25, 1), NumberSequenceKeypoint.new(1, 1) })
			UIGradient2.Rotation = 0
			UIGradient2.Parent = ImageLabel

			local value38 = t2.value38

			table.insert(value38, Frame)
			v194()
		end

		while t2.value4() do
			for _, v in ipairs((v199())) do
				pcall(function()
					local v246 = v

					for _, child in ipairs(v246.GetChildren(v246)) do
						local isScreenGui = child:IsA("ScreenGui")

						if isScreenGui then
							isScreenGui = child.Name == "WindUI" and true or child.Name:find("WindUI") ~= nil
						end

						if isScreenGui then
							v209(child)
						end
					end
				end)
			end

			task.wait(1)
		end
	end)
end

t2.value40 = t1.value1
t2.value41 = nil
t2.value42 = nil
t2.value43 = nil

function t1.value1(p32)
	t2.value41 = p32
	t2.value42 = p32:WaitForChild("Humanoid", 5)
	t2.value43 = p32:WaitForChild("HumanoidRootPart", 5)
end

t2.value43 = nil
t2.value44 = t1.value1
t1.value1 = t2.value44
t1.value16 = t2.value15.Character or t2.value15.CharacterAdded:Wait()
t1.value1(t1.value16)
t1.value1 = t2.value15.CharacterAdded

function t1.value16(p33)
	task.wait(0.2)
	t2.value44(p33)
end

t1.value15 = t1.value1.Connect
t1.value2 = 80
t1.value15(t1.value1, t1.value16)
handlers[12] = { nil }

local function v250()
	for _, v in ipairs((v124())) do
		pcall(function()
			local v253 = v

			for _, child in ipairs(v253.GetChildren(v253)) do
				local isScreenGui = child:IsA("ScreenGui")

				if isScreenGui then
					isScreenGui = child.Name == "WindUI" and true or child.Name:find("WindUI") ~= nil
				end

				if isScreenGui then
					pcall(function()
						local NapoleonWatermark = child:FindFirstChild("NapoleonWatermark", true)

						if NapoleonWatermark then
							NapoleonWatermark:Destroy()
						end

						local NapoleonUserCard = child:FindFirstChild("NapoleonUserCard", true)

						if not NapoleonUserCard then
							return
						end

						NapoleonUserCard:Destroy()
					end)
					child:Destroy()
				end
			end
		end)
	end

	table.clear(t2.value38)
	table.clear(t2.value34)
end

local v259 = handlers[8]

local function v260(p34)
	v250()
	task.wait(0.3)
	t2.value5 = v16()
	t2.value20(t2.value5)

	if p34 ~= "NapoleonKeys" then
		return
	end

	v259[1](t2.value5)

	local function v261()
		t2.value5:SetTheme("NapoleonKeys")
	end

	pcall(v261)
end

t2.value45 = nil
t1.value21 = "Backpack"
t1.value8 = true
t2.value46 = false
t2.value47 = nil
t1.value10 = 0
t1.value14 = "Carregando modulos..."
t1.value23 = 0
t1.value1 = {
	Target = t1.value10,
	Shown = 0,
	Step = t1.value23
}
t1.value24 = 76
t1.value5 = 0
t1.value23 = "Preparando o Imperio..."
t2.value48 = t1.value1
t1.value10 = {
	at = t1.value5,
	msg = "Preparando o Imperio..."
}
t1.value25 = "DisableNotify"
t1.value26 = 255
t1.value23 = "msg"
t1.value5 = "at"
t1.value14 = "msg"
t1.value23 = 45
t1.value5 = {
	at = t1.value23,
	msg = "Afiando as espadas..."
}
t1.value27 = 0
t1.value23 = "at"
t1.value14 = 70
t1.value15 = {
	at = t1.value14,
	msg = "Posicionando as tropas..."
}
t1.value14 = {
	at = 100,
	msg = "Imperio pronto!"
}
t2.value49 = {
	t1.value10,
	{
		at = 20,
		msg = "Carregando modulos..."
	},
	t1.value5,
	t1.value15,
	{
		at = 90,
		msg = "Coroando o General..."
	},
	t1.value14
}
t1.value23 = "Dica: entre no Discord para novidades e keys."
t1.value5 = "Dica: ajuste a distancia de defesa na aba Defesa."
t1.value1 = {
	"Dica: aperte K para abrir e fechar o hub.",
	"Dica: ajuste a distancia de defesa na aba Defesa.",
	"Dica: use Trajetoria para ver a previsao da bola.",
	"Dica: entre no Discord para novidades e keys."
}
t1.value15 = "NAPOLEON-7815953992"
t2.value50 = t1.value1

local function v262(p35, p36, p37, p38, p39)
	local tween = t2.value9:Create(p35, TweenInfo.new(p36, p38 or Enum.EasingStyle.Quad, p39 or Enum.EasingDirection.Out), p37)

	tween:Play()

	return tween
end

function t2.value51(p40)
	local value48 = t2.value48
	local Target = t2.value48.Target
	local v266 = math.min(p40, 100)

	value48.Target = math.max(Target, v266)
end
function t1.value1()
	local function v267()
		if t2.value47 then
			t2.value47:Disconnect()
			t2.value47 = nil
		end

		if not t2.value45 then
			return
		end

		t2.value45:Destroy()
	end

	pcall(v267)

	local value46 = false

	t2.value46 = value46

	local value48 = t2.value48
	local value482 = t2.value48

	t2.value48.Target = 0
	value48.Shown = 0
	value482.Step = 0

	local value483 = t2.value48

	t2.value48.Mul = 0.92
	value483.MulTarget = 1

	for _, v in ipairs((v124())) do
		pcall(function()
			local v274 = v

			for _, child in ipairs(v274.GetChildren(v274)) do
				if child.Name == "NapoleonLoading" then
					child:Destroy()
				end
			end
		end)
	end

	local value16 = nil

	local function v278()
		local gethui_ = gethui

		if gethui_ then
			gethui_ = gethui()
		end

		if not gethui_ then
			return
		end

		value16 = gethui_
	end

	value16 = t2.value16
	pcall(v278)

	local color3 = Color3.fromHex("#f9ecc0")

	local function v281()
		local NapoleonLoadBlur = t2.value12:FindFirstChild("NapoleonLoadBlur")

		if not NapoleonLoadBlur then
			v303 = Instance.new("BlurEffect")
			v303.Name = "NapoleonLoadBlur"
			v303.Size = 0
			v303.Parent = t2.value12
			v262(v303, 0.6, {
				Size = 16
			})

			return
		end

		NapoleonLoadBlur:Destroy()

		local BlurEffect = Instance.new("BlurEffect")

		BlurEffect.Name = "NapoleonLoadBlur"
		BlurEffect.Size = 0
		BlurEffect.Parent = t2.value12
		v262(BlurEffect, 0.6, {
			Size = 16
		})
	end

	local color32 = Color3.fromHex("#c9a961")
	local color33 = Color3.fromHex("#7a5e28")

	pcall(v281)

	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "NapoleonLoading"
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.DisplayOrder = 999
	pcall(function()
		ScreenGui.ScreenInsets = Enum.ScreenInsets.None
	end)
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = value16
	t2.value45 = ScreenGui

	local CanvasGroup = Instance.new("CanvasGroup")

	CanvasGroup.Name = "Root"
	CanvasGroup.Size = UDim2.fromScale(1, 1)
	CanvasGroup.BackgroundColor3 = Color3.fromHex("#070605")
	CanvasGroup.BorderSizePixel = 0
	CanvasGroup.GroupTransparency = 1
	CanvasGroup.Parent = ScreenGui

	local UIGradient = Instance.new("UIGradient")

	UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("#050403")), ColorSequenceKeypoint.new(0.5, Color3.fromHex("#15100a")), ColorSequenceKeypoint.new(1, Color3.fromHex("#050403")) })
	UIGradient.Rotation = 125
	UIGradient.Parent = CanvasGroup

	for _, v in ipairs({ true, false }) do
		local Frame = Instance.new("Frame")

		Frame.Size = UDim2.new(1, 0, 0.3, 0)

		local uDim2

		if v then
			uDim2 = UDim2.fromScale(0, 0)
		else
			uDim2 = v
		end

		Frame.Position = uDim2 or UDim2.fromScale(0, 0.7)
		Frame.BackgroundColor3 = Color3.new(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.ZIndex = 2
		Frame.Parent = CanvasGroup

		local UIGradient2 = Instance.new("UIGradient")

		UIGradient2.Rotation = v and 90 or 270
		UIGradient2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 1) })
		UIGradient2.Parent = Frame
	end

	local t16 = {}

	for i = 1, 28 do
		local Frame = Instance.new("Frame")
		local v297 = math.random(2, 5)

		Frame.Size = UDim2.fromOffset(v297, v297)
		Frame.BackgroundColor3 = i % 2 == 0 and color3 and color3 or color32
		Frame.BorderSizePixel = 0
		Frame.ZIndex = 1
		Frame.Parent = CanvasGroup

		local UICorner = Instance.new("UICorner")

		UICorner.CornerRadius = UDim.new(1, 0)
		UICorner.Parent = Frame
		t16[i] = {
			f = Frame,
			x = math.random(),
			y = math.random(),
			speed = 0.02 + math.random() * 0.05,
			phase = math.random() * 6.28,
			base = 0.35 + math.random() * 0.4
		}
	end

	local Frame = Instance.new("Frame")

	Frame.Name = "Center"
	Frame.Size = UDim2.fromOffset(440, 340)
	Frame.Position = UDim2.fromScale(0.5, 0.5)
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.BackgroundTransparency = 1
	Frame.ZIndex = 5
	Frame.Parent = CanvasGroup

	local UIScale = Instance.new("UIScale")

	UIScale.Scale = 1
	UIScale.Parent = Frame

	local function v301(p41, p42, p43)
		local Frame2 = Instance.new("Frame")

		Frame2.Size = UDim2.fromOffset(p41, p41)
		Frame2.Position = UDim2.new(0.5, 0, 0, 70)
		Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
		Frame2.BackgroundTransparency = 1
		Frame2.ZIndex = 5
		Frame2.Parent = Frame

		local UICorner = Instance.new("UICorner")

		UICorner.CornerRadius = UDim.new(1, 0)
		UICorner.Parent = Frame2

		local UIStroke = Instance.new("UIStroke")

		UIStroke.Color = color3
		UIStroke.Thickness = p42
		UIStroke.Transparency = p43
		UIStroke.Parent = Frame2

		local UIGradient2 = Instance.new("UIGradient")

		UIGradient2.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.6, 0),
			NumberSequenceKeypoint.new(0.601, 1),
			NumberSequenceKeypoint.new(1, 1)
		})
		UIGradient2.Parent = UIStroke

		return Frame2, UIGradient2, UIStroke
	end

	local _, v307 = v301(124, 2.5, 0)
	local _, v309 = v301(100, 1.5, 0.25)
	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.fromOffset(80, 80)
	TextLabel.Position = UDim2.new(0.5, 0, 0, 70)
	TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "N"
	TextLabel.Font = Enum.Font.Bodoni
	TextLabel.TextSize = 54
	TextLabel.TextColor3 = color3
	TextLabel.TextTransparency = 1
	TextLabel.ZIndex = 6
	TextLabel.Parent = Frame

	local UIGradient2 = Instance.new("UIGradient")

	UIGradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, color3), ColorSequenceKeypoint.new(1, color33) })
	UIGradient2.Rotation = 90
	UIGradient2.Parent = TextLabel

	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.new(1, 0, 0, 40)
	Frame2.Position = UDim2.new(0, 0, 0, 150)
	Frame2.BackgroundTransparency = 1
	Frame2.ZIndex = 5
	Frame2.Parent = Frame

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Padding = UDim.new(0, 2)
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = Frame2

	for i = 1, 12 do
		local v315 = ("NAPOLEON HUB").sub("NAPOLEON HUB", i, i)
		local TextLabel2 = Instance.new("TextLabel")

		TextLabel2.LayoutOrder = i
		TextLabel2.BackgroundTransparency = 1

		if v315 == " " then
			TextLabel2.Size = UDim2.fromOffset(14, 40)
			TextLabel2.Text = ""
		else
			TextLabel2.AutomaticSize = Enum.AutomaticSize.X
			TextLabel2.Size = UDim2.fromOffset(0, 40)
			TextLabel2.Text = v315
		end

		TextLabel2.Font = Enum.Font.Bodoni
		TextLabel2.TextSize = 30
		TextLabel2.TextColor3 = color3
		TextLabel2.TextTransparency = 1
		TextLabel2.ZIndex = 6
		TextLabel2.Parent = Frame2

		local UIGradient3 = Instance.new("UIGradient")

		UIGradient3.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, color3), ColorSequenceKeypoint.new(0.6, color32), ColorSequenceKeypoint.new(1, color33) })
		UIGradient3.Rotation = 90
		UIGradient3.Parent = TextLabel2
		task.delay(0.3 + i * 0.05, function()
			local Parent = TextLabel2

			if Parent then
				Parent = TextLabel2.Parent
			end

			if not Parent then
				return
			end

			v262(TextLabel2, 0.45, {
				TextTransparency = 0
			})
		end)
	end

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, 0, 0, 16)
	TextLabel2.Position = UDim2.new(0, 0, 0, 190)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = "IMPERIO DO GOL - V3"
	TextLabel2.Font = Enum.Font.Gotham
	TextLabel2.TextSize = 11
	TextLabel2.TextColor3 = Color3.fromHex("#8a7a5c")
	TextLabel2.TextTransparency = 1
	TextLabel2.ZIndex = 6
	TextLabel2.Parent = Frame

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Name = "Status"
	TextLabel3.Size = UDim2.new(1, 0, 0, 18)
	TextLabel3.Position = UDim2.new(0, 0, 0, 228)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Text = t2.value49[1].msg
	TextLabel3.Font = Enum.Font.GothamMedium
	TextLabel3.TextSize = 13
	TextLabel3.TextColor3 = Color3.fromHex("#d9c9a0")
	TextLabel3.ZIndex = 6
	TextLabel3.Parent = Frame

	local Frame3 = Instance.new("Frame")

	Frame3.Size = UDim2.new(1, -80, 0, 6)
	Frame3.Position = UDim2.new(0, 40, 0, 258)
	Frame3.BackgroundColor3 = Color3.fromHex("#1a1610")
	Frame3.BorderSizePixel = 0
	Frame3.ZIndex = 6
	Frame3.Parent = Frame

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(1, 0)
	UICorner.Parent = Frame3

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = color32
	UIStroke.Transparency = 0.7
	UIStroke.Parent = Frame3

	local Frame4 = Instance.new("Frame")

	Frame4.Size = UDim2.new(0, 0, 1, 0)
	Frame4.BackgroundColor3 = color32
	Frame4.BorderSizePixel = 0
	Frame4.ZIndex = 7
	Frame4.Parent = Frame3

	local UICorner2 = Instance.new("UICorner")

	UICorner2.CornerRadius = UDim.new(1, 0)
	UICorner2.Parent = Frame4

	local UIGradient3 = Instance.new("UIGradient")

	UIGradient3.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, color33), ColorSequenceKeypoint.new(0.5, color3), ColorSequenceKeypoint.new(1, color32) })
	UIGradient3.Parent = Frame4

	local TextLabel4 = Instance.new("TextLabel")

	TextLabel4.Size = UDim2.new(1, 0, 0, 16)
	TextLabel4.Position = UDim2.new(0, 0, 0, 274)
	TextLabel4.BackgroundTransparency = 1
	TextLabel4.Text = "0%"
	TextLabel4.Font = Enum.Font.GothamBold
	TextLabel4.TextSize = 12
	TextLabel4.TextColor3 = color32
	TextLabel4.ZIndex = 6
	TextLabel4.Parent = Frame

	local TextLabel5 = Instance.new("TextLabel")

	TextLabel5.Size = UDim2.new(1, 0, 0, 16)
	TextLabel5.Position = UDim2.new(0, 0, 0, 308)
	TextLabel5.BackgroundTransparency = 1
	TextLabel5.Text = t2.value50[1]
	TextLabel5.Font = Enum.Font.Gotham
	TextLabel5.TextSize = 11
	TextLabel5.TextColor3 = Color3.fromHex("#8a7a5c")
	TextLabel5.ZIndex = 6
	TextLabel5.Parent = Frame
	v262(CanvasGroup, 0.5, {
		GroupTransparency = 0
	})
	v262(TextLabel, 0.6, {
		TextTransparency = 0
	})
	v262(TextLabel2, 0.8, {
		TextTransparency = 0
	})
	task.spawn(function()
		local n4 = 1

		while true do
			local Parent = ScreenGui.Parent

			if Parent then
				Parent = not t2.value46
			end

			if not Parent then
				return
			end

			task.wait(2.2)

			if t2.value46 or not TextLabel5.Parent then
				return
			end

			n4 = n4 % #t2.value50 + 1
			v262(TextLabel5, 0.2, {
				TextTransparency = 1
			})
			task.wait(0.22)
			TextLabel5.Text = t2.value50[n4]
			v262(TextLabel5, 0.2, {
				TextTransparency = 0
			})
		end
	end)
	t2.value47 = t2.value7.RenderStepped:Connect(function(dt)
		local v331 = t2.value1()
		local v332 = t2.value17()
		local clamp = math.clamp
		local min = math.min
		local X = v332.X
		local Y = v332.Y
		local v337 = clamp(min(X / 520, Y / 400), 0.55, 1.25)
		local value484 = t2.value48
		local Mul = t2.value48.Mul
		local v340 = t2.value48.MulTarget - t2.value48.Mul
		local v341 = dt * 7

		value484.Mul = Mul + v340 * math.min(1, v341)
		UIScale.Scale = v337 * t2.value48.Mul

		local v342 = not t2.value46

		if v342 then
			v342 = t2.value48.Target < 92
		end

		if v342 then
			local value485 = t2.value48
			local v344 = t2.value48.Target + dt * 9 * (1 - t2.value48.Target / 100)

			value485.Target = math.min(92, v344)
		end

		local value485 = t2.value48
		local Shown = t2.value48.Shown
		local v347 = t2.value48.Target - t2.value48.Shown
		local v348 = dt * 5

		value485.Shown = Shown + v347 * math.min(1, v348)

		local Shown2 = t2.value48.Shown

		Frame4.Size = UDim2.new(Shown2 / 100, 0, 1, 0)

		local v350 = TextLabel4
		local v351 = Shown2 + 0.5

		v350.Text = math.floor(v351) .. "%"
		UIGradient3.Offset = Vector2.new(v331 * 0.8 % 2 - 1, 0)

		local step = 1

		for i, v in ipairs(t2.value49) do
			if v.at - 0.5 <= Shown2 then
				step = i
			end
		end

		local f, uDim2, x, sin, phase, f2, base, sin2, phase2

		if step == t2.value48.Step then
			v307.Rotation = v331 * 140 % 360
			v309.Rotation = 360 - v331 * 90 % 360
			v389 = TextLabel
			v390 = v331 * 2.4
			v389.TextSize = 54 + math.sin(v390) * 2

			for _, v in ipairs(t16) do
				v.y = v.y - v.speed * dt

				if v.y < -0.05 then
					v.y = 1.05
					v.x = math.random()
				end

				f = v.f
				uDim2 = UDim2.fromScale
				x = v.x
				sin = math.sin
				phase = v.phase
				f.Position = uDim2(x + sin(v331 * 0.8 + phase) * 0.012, v.y)
				f2 = v.f
				base = v.base
				sin2 = math.sin
				phase2 = v.phase
				f2.BackgroundTransparency = 1 - base * (0.6 + 0.4 * sin2(v331 * 2 + phase2))
			end

			return
		end

		t2.value48.Step = step

		local msg = t2.value49[step].msg

		task.spawn(function()
			if TextLabel3.Parent then
				v262(TextLabel3, 0.12, {
					TextTransparency = 1
				})
				task.wait(0.13)
				TextLabel3.Text = msg
				v262(TextLabel3, 0.15, {
					TextTransparency = 0
				})
			end
		end)
		v307.Rotation = v331 * 140 % 360
		v309.Rotation = 360 - v331 * 90 % 360

		local v367 = TextLabel
		local v368 = v331 * 2.4

		v367.TextSize = 54 + math.sin(v368) * 2

		for _, v in ipairs(t16) do
			v.y = v.y - v.speed * dt

			if v.y < -0.05 then
				v.y = 1.05
				v.x = math.random()
			end

			f = v.f
			uDim2 = UDim2.fromScale
			x = v.x
			sin = math.sin
			phase = v.phase
			f.Position = uDim2(x + sin(v331 * 0.8 + phase) * 0.012, v.y)
			f2 = v.f
			base = v.base
			sin2 = math.sin
			phase2 = v.phase
			f2.BackgroundTransparency = 1 - base * (0.6 + 0.4 * sin2(v331 * 2 + phase2))
		end
	end)
end

t2.value52 = t1.value1

local function v371()
	t2.value46 = true
	t2.value48.Target = 100

	local value45 = t2.value45

	if not (value45 and value45.Parent) then
		return
	end

	local v373 = t2.value1()

	while true do
		local v374

		if t2.value48.Shown < 99.4 then
			v374 = t2.value1() - v373 < 1.5
		else
			v374 = false
		end

		if not v374 then
			task.wait(0.35)

			local Root = value45:FindFirstChild("Root")
			local Center

			if Root then
				Center = Root:FindFirstChild("Center")
			else
				Center = Root
			end

			if Center then
				Center:FindFirstChildOfClass("UIScale")
			end

			if Root then
				v262(Root, 0.6, {
					GroupTransparency = 1
				})
			end

			t2.value48.MulTarget = 1.1

			local function v377()
				local NapoleonLoadBlur = t2.value12:FindFirstChild("NapoleonLoadBlur")

				if not NapoleonLoadBlur then
					return
				end

				v262(NapoleonLoadBlur, 0.6, {
					Size = 0
				})
				task.delay(0.7, function()
					if not NapoleonLoadBlur then
						return
					end

					NapoleonLoadBlur:Destroy()
				end)
			end

			pcall(v377)
			task.wait(0.65)

			if t2.value47 then
				t2.value47:Disconnect()
				t2.value47 = nil
			end

			pcall(function()
				value45:Destroy()
			end)
			t2.value45 = nil

			return
		end

		task.wait()
	end
end

handlers[13] = { nil }
handlers[13][1] = {
	["unk acess now"] = true,
	["UNK ACESS NOW"] = true,
	["NAPOLEON-7815953992"] = true
}
t1.value29 = "Language"
t1.value1 = "napoleon_key.txt"
t2.value53 = "napoleon_key.txt"
t2.value54 = "napoleon_key_time.txt"
t2.value55 = 86400

function t1.value1()
	local now = os.time and os.time()

	if now then
		return now
	end

	local v380 = t2.value1()

	now = math.floor(v380)

	return now
end

handlers[14] = { nil }
t2.value56 = t1.value1

local v381 = handlers[13]

function t2.value57(p44)
	return v381[1][p44] == true
end
function t2.value58()
	if not writefile then
		return
	end

	local pcall_ = pcall
	local writefile_ = writefile
	local value54 = t2.value54
	local value56 = t2.value56

	pcall_(writefile_, value54, (tostring(value56())))
end
function t1.value1()
	local v386

	if isfile and readfile then
		local ok, result = pcall(readfile, t2.value54)

		if ok and result then
			v386 = tonumber(result)
		else
			v386 = nil
		end
	else
		v386 = nil
	end

	return not v386 and true or t2.value56() - v386 >= t2.value55
end

handlers[12][1] = t1.value1

function t1.value1()
	local v391

	if isfile and readfile then
		local ok, result = pcall(readfile, t2.value54)

		if ok and result then
			v391 = tonumber(result)
		else
			v391 = nil
		end
	else
		v391 = nil
	end

	return not v391 and 0 or math.max(0, t2.value55 - (t2.value56() - v391))
end

t2.value59 = t1.value1

local v392 = handlers[12]

function t1.value1()
	if isfile and readfile then
		local ok, result = pcall(readfile, t2.value53)

		if ok and (result and t2.value57(result)) then
			return not v392[1]()
		else
			return false
		end
	else
		return false
	end
end

handlers[32] = t1.value1
handlers[33] = true
t2.value60 = "napoleon_cfg.json"
t1.value25 = "Low Catch"
handlers[34] = 64
t2.value61 = nil

function t1.value22()
	local isfile_ = isfile

	if isfile_ then
		isfile_ = readfile

		if isfile_ then
			isfile_ = isfile(t2.value60)
		end
	end

	if not isfile_ then
		return
	end

	local data = t2.value14:JSONDecode(readfile(t2.value60))

	for _, v in ipairs(t2.value61) do
		local v399

		if data[v] == nil then
			v399 = false
		else
			local v400 = data[v]
			local kind = type(v400)
			local v402 = t2.value21[v]

			v399 = kind == type(v402)
		end

		if v399 then
			t2.value21[v] = data[v]
		end
	end
end

t2.value61 = {
	"Mode",
	"DiveRange",
	"CatchRange",
	"MinSpeed",
	"MaxSpeed",
	"Predict",
	"PredictTime",
	"DiveCooldown",
	"CatchCooldown",
	"HighThreshold",
	"SideThreshold",
	"Theme",
	"DiveLead",
	"ReachOn",
	"ReachDist",
	"ReachSphere",
	"DisableNotify",
	"BallESP",
	"BallESPColor",
	"BallESPTrans",
	"AutoPos",
	"PredictRGB",
	"Language"
}
t1.value1 = pcall
t1.value1(t1.value22)
handlers[31] = 0
t2.value62 = false

function t1.value1()
	if t2.value62 or not writefile then
		return
	end

	t2.value62 = true

	local function v403()
		t2.value62 = false
		pcall(function()
			local t17 = {}

			for _, v in ipairs(t2.value61) do
				t17[v] = t2.value21[v]
			end

			writefile(t2.value60, t2.value14:JSONEncode(t17))
		end)
	end

	task.delay(1, v403)
end

t2.value63 = t1.value1

function t2.value64(p45, p46)
	t2.value21[p45] = p46
	t2.value63()
end

handlers[30] = 0
t2.value65 = 0
t2.value66 = 0
t2.value67 = handlers[30]
t2.value68 = handlers[31]
t2.value69 = false
t2.value70 = false
t2.value71 = nil
handlers[15] = { nil }
handlers[15][1] = {
	"High Dive Left",
	"High Dive Right",
	"Dive Left",
	"Dive Right",
	"High Catch",
	"Low Catch",
	"Front Dive",
	"Reflex"
}
t1.value22 = 20
t1.value1 = {}
t2.value72 = t1.value1
t2.value73 = {}
t1.value25 = Color3.fromRGB(20, t1.value22, 20)
t1.value22 = Color3.fromRGB(0, 102, 255)
t1.value34 = Color3.fromRGB(0, 255, t1.value26)
t1.value30 = "Verde"
t1.value26 = "Color3"
t1.value29 = Color3.fromRGB(34, 177, t1.value24)
t1.value32 = Color3.fromRGB(0, t1.value2, 0)
t1.value26 = 102
t1.value2 = 0
t1.value24 = 0
t2.value74 = {
	Preto = t1.value25,
	Azul = t1.value22,
	Ciano = t1.value34,
	Verde = t1.value29,
	["Verde Escuro"] = t1.value32
}
t1.value22 = "Color3"
t1.value30 = 255
t1.value33 = Color3
t1.value29 = 20
t1.value22 = "fromRGB"
t1.value33 = t1.value33.fromRGB(0, t1.value30, 255)
handlers[35] = true
t1.value25 = "Preto"
t1.value32 = 255
t1.value30 = Color3.fromRGB(20, 20, t1.value29)
t1.value1 = Color3
t1.value22 = "Azul"
t1.value29 = "fromRGB"
t1.value1 = t1.value1.fromRGB(0, t1.value26, t1.value32)
t1.value28 = 118
t1.value32 = "Color3"
t1.value1 = {
	Ciano = t1.value33,
	Preto = t1.value30,
	Azul = t1.value1,
	Vermelho = Color3.fromRGB(255, t1.value24, t1.value2)
}
handlers[16] = { nil }
t1.value25 = "Preto Total (100% Black)"
t1.value30 = "Color3"
handlers[16][1] = t1.value1
t1.value22 = Color3
t1.value2 = 230
t1.value30 = "fromRGB"
t1.value32 = 42
t1.value29 = 255
t1.value22 = t1.value22.fromRGB(0, 0, 0)
t1.value34 = Color3.fromRGB(0, t1.value29, 255)
t1.value29 = Color3
t1.value24 = 255
t1.value30 = "Roxo Imperial"
t1.value26 = "fromRGB"
t1.value29 = t1.value29.fromRGB(163, t1.value32, t1.value24)
t1.value32 = Color3.fromRGB(0, t1.value2, t1.value28)
t1.value2 = Color3
t1.value33 = 68
t1.value28 = "fromRGB"
t1.value24 = t1.value2.fromRGB
t1.value26 = "Amarelo Ouro"
t1.value28 = 255
t1.value2 = t1.value24(t1.value28, 214, t1.value27)
t1.value27 = "Color3"
t1.value24 = "Laranja Fogo"
t1.value35 = Color3.fromRGB(255, 109, 0)
handlers[36] = 129
t1.value28 = "Vermelho Sangue"
t1.value1 = Color3
handlers[37] = nil
t1.value1 = t1.value1.fromRGB(255, 23, t1.value33)
t1.value27 = "Rosa Choque"
t1.value33 = "Color3"
t1.value27 = Color3
t1.value33 = "fromRGB"
handlers[38] = true
t1.value27 = t1.value27.fromRGB
t1.value27 = t1.value27(255, handlers[34], handlers[36])
t2.value75 = {
	["Preto Total (100% Black)"] = t1.value22,
	["Ciano Neon"] = t1.value34,
	["Roxo Imperial"] = t1.value29,
	["Verde Brilhante"] = t1.value32,
	["Amarelo Ouro"] = t1.value2,
	["Laranja Fogo"] = t1.value35,
	["Vermelho Sangue"] = t1.value1,
	["Rosa Choque"] = t1.value27
}

function t1.value1(p47)
	if not (p47 and p47:IsA("BasePart")) then
		return false
	end

	local v407 = p47.Name:lower()

	if v407:find("line") or (v407:find("linha") or (v407:find("net") or (v407:find("rede") or (v407:find("goal") or (v407:find("trave") or (v407:find("wall") or v407:find("parede"))))))) then
		return false
	end

	local v408 = p47.Color.R > 0.8

	if v408 then
	elseif v408 then
		return false
	else
		return (v407:find("grass") or (v407:find("pitch") or (v407.find(v407, "field") or (v407.find(v407, "grama") or (v407:find("gramado") or v407:find("campo")))))) and true or p47.Material == Enum.Material.Grass
	end

	if p47.Color.G > 0.8 then
		v408 = p47.Color.B > 0.8
	else
		v408 = false
	end

	if v408 then
		return false
	else
		return (v407:find("grass") or (v407:find("pitch") or (v407.find(v407, "field") or (v407.find(v407, "grama") or (v407:find("gramado") or v407:find("campo")))))) and true or p47.Material == Enum.Material.Grass
	end
end

handlers[17] = { nil }
handlers[17][1] = t1.value1

local v409 = handlers[17]

local function v410(p48)
	local ipairs_ = ipairs
	local value11 = t2.value11

	for _, descendant in ipairs_(value11.GetDescendants(value11)) do
		if v409[1](descendant) then
			if not t2.value73[descendant] then
				t2.value73[descendant] = descendant.Color
			end

			descendant.Color = p48
		end
	end
end
local function v415()
	for k, v in pairs(t2.value73) do
		local Parent

		if k then
			Parent = k.Parent
		else
			Parent = k
		end

		if Parent then
			k.Color = v
		end
	end

	table.clear(t2.value73)
end

handlers[18] = { nil }
t1.value27 = "Instance"
t1.value1 = {}
t2.value76 = t1.value1
t2.value77 = {}
t2.value78 = {}

function t1.value1()
	if not t2.value78.Saved then
		t2.value78.Saved = true

		local Brightness = t2.value12.Brightness

		t2.value78.Brightness = Brightness

		local ClockTime = t2.value12.ClockTime

		t2.value78.ClockTime = ClockTime

		local GlobalShadows = t2.value12.GlobalShadows

		t2.value78.GlobalShadows = GlobalShadows

		local OutdoorAmbient = t2.value12.OutdoorAmbient

		t2.value78.OutdoorAmbient = OutdoorAmbient
	end

	local function v423()
		t2.value12.GlobalShadows = false

		local ipairs_ = ipairs
		local value12 = t2.value12

		for _, child in ipairs_(value12.GetChildren(value12)) do
			local isPostEffect = child:IsA("PostEffect")

			if isPostEffect then
				if child.Name == "NapoleonKeyBlur" then
					isPostEffect = false
				else
					isPostEffect = child.Name ~= "NapoleonLoadBlur"
				end
			end

			if isPostEffect then
				child.Enabled = false
			end

			if child:IsA("Atmosphere") or (child:IsA("Clouds") or child:IsA("Sky")) then
				child.Enabled = false
			end
		end

		local ipairs_2 = ipairs
		local value11 = t2.value11

		for _, descendant in ipairs_2(value11.GetDescendants(value11)) do
			if descendant:IsA("BasePart") then
				descendant.CastShadow = false

				if not t2.value76[descendant] then
					t2.value76[descendant] = descendant.Material
				end

				descendant.Material = Enum.Material.SmoothPlastic
			elseif descendant:IsA("Texture") or descendant:IsA("Decal") then
				if t2.value77[descendant] == nil then
					t2.value77[descendant] = descendant.Transparency
				end

				descendant.Transparency = 1
			end
		end
	end

	pcall(v423)
end

t2.value79 = t1.value1
t1.value35 = Instance.new("Folder")
t1.value34 = {}
t2.value80 = t1.value35
t2.value80.Name = "NapoleonClientPredict"
t1.value1 = t2.value11
t2.value80.Parent = t1.value1
t2.value81 = {}
t2.value82 = nil

local function v433()
	for i = #t2.value81, 1, -1 do
		local v435 = t2.value81[i]
		local Parent

		if v435 then
			Parent = v435.Parent
		else
			Parent = v435
		end

		if Parent then
			v435:Destroy()
		end
	end

	table.clear(t2.value81)

	if not t2.value82 then
		return
	end

	t2.value82:Destroy()
	t2.value82 = nil
end
local function v437(p49, p50)
	local Magnitude = (p50 - p49).Magnitude

	if not (Magnitude <= 0.01) then
		local Part = Instance.new("Part")

		Part.Name = "PredictLine"
		Part.Anchored = true
		Part.CanCollide = false
		Part.CanTouch = false
		Part.CanQuery = false
		Part.Material = Enum.Material.Neon
		Part.Color = t2.value21.PredictColor or Color3.fromRGB(0, 0, 0)
		Part.Size = Vector3.new(0.08, 0.08, Magnitude)
		Part.CFrame = CFrame.lookAt((p49 + p50) / 2, p50)
		Part.Parent = t2.value80

		local value81 = t2.value81

		table.insert(value81, Part)
	end
end

function t1.value1(p51)
	if not t2.value82 then
		t2.value82 = Instance.new("Part")
		t2.value82.Name = "LandingPoint"
		t2.value82.Shape = Enum.PartType.Ball
		t2.value82.Size = Vector3.new(0.5, 0.5, 0.5)
		t2.value82.Anchored = true
		t2.value82.CanCollide = false
		t2.value82.CanTouch = false
		t2.value82.CanQuery = false
		t2.value82.Material = Enum.Material.Neon
		t2.value82.Color = t2.value21.PredictColor or Color3.fromRGB(0, 0, 0)
		t2.value82.Position = p51 + Vector3.new(0, 0.15, 0)
		t2.value82.Parent = t2.value80

		return
	end

	t2.value82:Destroy()
	t2.value82 = Instance.new("Part")
	t2.value82.Name = "LandingPoint"
	t2.value82.Shape = Enum.PartType.Ball
	t2.value82.Size = Vector3.new(0.5, 0.5, 0.5)
	t2.value82.Anchored = true
	t2.value82.CanCollide = false
	t2.value82.CanTouch = false
	t2.value82.CanQuery = false
	t2.value82.Material = Enum.Material.Neon
	t2.value82.Color = t2.value21.PredictColor or Color3.fromRGB(0, 0, 0)
	t2.value82.Position = p51 + Vector3.new(0, 0.15, 0)
	t2.value82.Parent = t2.value80
end

handlers[18][1] = t1.value1
t2.value83 = {
	ball = handlers[35],
	bola = true,
	tps = true,
	football = handlers[33],
	esa = t1.value8,
	mrs = true,
	prs = true,
	mps = handlers[38],
	sss = true,
	aifa = true,
	rbz = true,
	rsf = true,
	vef = true,
	saml = true
}

local function v441(p52)
	if not (p52 and p52:IsA("BasePart")) then
		return false
	end

	if p52.Anchored then
		return false
	end

	local value41 = t2.value41

	if value41 then
		value41 = p52:IsDescendantOf(t2.value41)
	end

	if value41 then
		return false
	end

	local Model = p52:FindFirstAncestorOfClass("Model")
	local v444, v445

	if Model then
	elseif Model then
		return false
	else
		v444 = p52.Name:lower()

		if t2.value83[v444] then
			if p52.Size.X >= 0.4 then
				v445 = p52.Size.X <= 8
			else
				v445 = false
			end

			return v445
		else
			return false
		end
	end

	Model = Model:FindFirstChildOfClass("Humanoid")

	if Model then
		return false
	else
		v444 = p52.Name:lower()

		if t2.value83[v444] then
			if p52.Size.X >= 0.4 then
				v445 = p52.Size.X <= 8
			else
				v445 = false
			end

			return v445
		else
			return false
		end
	end
end

handlers[19] = { nil }
handlers[20] = { nil }
t2.value84 = {
	Set = {},
	LastFull = 0
}

function t1.value1(p53)
	local isBasePart = p53:IsA("BasePart")

	if isBasePart then
		isBasePart = t2.value83[p53.Name:lower()]
	end

	if not isBasePart then
		return
	end

	t2.value84.Set[p53] = true
end

t2.value84.Loose = t1.value1

function t1.value1()
	local ipairs_ = ipairs
	local value11 = t2.value11

	for _, descendant in ipairs_(value11.GetDescendants(value11)) do
		t2.value84.Loose(descendant)
	end
end

t2.value84.Scan = t1.value1

function t1.value1()
	if t2.value43 then
		local Position = t2.value43.Position
		local huge = math.huge
		local v453 = nil

		for k in pairs(t2.value84.Set) do
			if k.Parent then
				if v441(k) then
					local Magnitude = (k.Position - Position).Magnitude

					if Magnitude < huge then
						v453 = k
						huge = Magnitude
					end
				end
			else
				t2.value84.Set[k] = nil
			end
		end

		return v453
	else
		return nil
	end
end

t2.value84.Pick = t1.value1

local function v456()
	if t2.value43 then
		local v457 = t2.value84.Pick()

		if v457 then
			return v457
		else
			local v458 = t2.value1()

			if v458 - t2.value84.LastFull >= 1 then
				t2.value84.LastFull = v458
				t2.value84.Scan()

				return t2.value84.Pick()
			else
				return nil
			end
		end
	else
		return nil
	end
end

t2.value84.Scan()
t1.value1 = t2.value84
t1.value21 = t2.value11.DescendantAdded
handlers[29] = t2.value84
t1.value31 = t1.value21.Connect
handlers[33] = handlers[29].Loose
t1.value31 = t1.value31(t1.value21, handlers[33])
t1.value1.Conn = t1.value31

local v459 = handlers[16]

local function v460()
	local ipairs_ = ipairs
	local value11 = t2.value11

	for _, descendant in ipairs_(value11.GetDescendants(value11)) do
		if v441(descendant) then
			local NapoleonBallESP = descendant:FindFirstChild("NapoleonBallESP")

			if t2.value21.BallESP then
				if not NapoleonBallESP then
					NapoleonBallESP = Instance.new("Highlight")
					NapoleonBallESP.Name = "NapoleonBallESP"
					NapoleonBallESP.Adornee = descendant
					NapoleonBallESP.Parent = descendant
				end

				local color3 = v459[1][t2.value21.BallESPColor] or Color3.fromRGB(0, 255, 255)

				NapoleonBallESP.FillColor = color3
				NapoleonBallESP.OutlineColor = color3

				local v467 = (t2.value21.BallESPTrans - 1) / 9
				local fillTransparency = math.clamp(v467, 0, 0.95)

				NapoleonBallESP.FillTransparency = fillTransparency

				local v469 = fillTransparency * 0.5

				NapoleonBallESP.OutlineTransparency = math.clamp(v469, 0, 0.5)
			elseif NapoleonBallESP then
				NapoleonBallESP:Destroy()
			end
		end
	end
end

t1.value1 = t2.value7.Heartbeat

function t1.value31()
	if t2.value21.BallESP then
		v460()
	end

	if not t2.value21.PredictRGB then
		return
	end

	local v470 = t2.value1()
	local color3 = Color3.fromHSV(v470 % 5 / 5, 1, 1)

	for _, v in ipairs(t2.value81) do
		local Parent

		if v then
			Parent = v.Parent
		else
			Parent = v
		end

		if Parent then
			v.Color = color3
		end
	end

	local value82 = t2.value82

	if value82 then
		value82 = t2.value82.Parent
	end

	if not value82 then
		return
	end

	t2.value82.Color = color3
end

t1.value1:Connect(t1.value31)
t2.value85 = 0

local v476 = handlers[18]

function t1.value1()
	if not t2.value21.Predict then
		v433()

		return
	end

	local v477 = t2.value1()

	if v477 - t2.value85 < 0.05 then
		return
	end

	t2.value85 = v477

	local v478 = v456()

	if not v478 then
		v433()

		return
	end

	local AssemblyLinearVelocity = v478.AssemblyLinearVelocity

	if AssemblyLinearVelocity.Magnitude < t2.value21.MinSpeed then
		v433()

		return
	end

	v433()

	local Position = v478.Position
	local vector3 = Vector3.new(0, -t2.value11.Gravity * 0.95, 0)
	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = { t2.value41, v478, t2.value80 }

	local n5 = 0.05
	local v484 = math.floor(t2.value21.PredictTime / n5)
	local v485 = 1 < 0
	local n6 = 1
	local n7 = 0

	while true do
		n7 = n6 + n7

		local v488 = not v485

		if v488 then
			v488 = n7 <= v484
		end

		if not (v485 and v484 <= n7 and true or v488) then
			return
		end

		local Position2 = v478.Position
		local v490 = n7 * n5
		local v491 = v490 * v490
		local v492 = Position2 + AssemblyLinearVelocity * v490 + 0.5 * vector3 * v491
		local hit = t2.value11:Raycast(Position, v492 - Position, raycastParams)

		if hit then
			v437(Position, hit.Position)
			v476[1](hit.Position)

			return
		end

		v437(Position, v492)
		Position = v492
	end
end

t2.value86 = nil
t2.value87 = t1.value1

local v494 = handlers[15]

local function v495()
	table.clear(t2.value72)

	if not t2.value16 then
		return
	end

	local ipairs_ = ipairs
	local value16 = t2.value16

	for _, descendant in ipairs_(value16.GetDescendants(value16)) do
		if descendant:IsA("TextButton") or descendant:IsA("ImageButton") then
			local s1 = ""

			local function v501()
				s1 = descendant.Text
			end

			pcall(v501)

			local v502 = s1

			for _, v in ipairs(v494[1]) do
				if v502:lower() == v:lower() and true or descendant.Name:lower() == v:lower() then
					t2.value72[v] = descendant

					break
				end
			end
		end
	end
end

function t1.value1(p54)
	local v505 = t2.value72[p54]
	local Parent

	if v505 then
		Parent = v505.Parent
	else
		Parent = v505
	end

	if Parent then
		return v505
	else
		v495()

		return t2.value72[p54]
	end
end

handlers[21] = { nil }
handlers[21][1] = t1.value1

local v507 = handlers[5]

function t1.value31()
	t2.value86 = v507[1]:FindFirstChild("CatchBall", true)
end

local v508 = handlers[21]
local v509 = handlers[4]

local function v510(p55)
	local v511 = v508[1](p55)

	if not v511 then
		return false
	end

	local firesignal_ = firesignal
	local ok

	if typeof(firesignal_) == "function" then
		ok = pcall(function()
			firesignal(v511.Activated)
			firesignal(v511.MouseButton1Click)
			pcall(function()
				firesignal(v511.MouseButton1Down)
				firesignal(v511.MouseButton1Up)
			end)
		end)
	else
		ok = false
	end

	if ok then
		return true
	end

	local v514 = v511.AbsolutePosition + v511.AbsoluteSize / 2
	local guiInset = v509[1]:GetGuiInset()
	local X = v514.X
	local Y = v514.Y
	local Y2 = guiInset.Y
	local game_ = game

	t2.value10:SendMouseButtonEvent(X, Y + Y2, 0, true, game_, 0)

	local value10 = t2.value10
	local X2 = v514.X
	local Y3 = v514.Y
	local Y4 = guiInset.Y
	local game_2 = game

	value10:SendMouseButtonEvent(X2, Y3 + Y4, 0, false, game_2, 0)

	return true
end

function t1.value1()
	if not t2.value42 then
		return
	end

	pcall(function()
		t2.value42.Jump = true
		t2.value42:ChangeState(Enum.HumanoidStateType.Jumping)
	end)
end

handlers[19][1] = t1.value1
t2.value86 = nil
pcall(t1.value31)
handlers[22] = { nil }

function t1.value1(p56)
	if not t2.value86 then
		return
	end

	local function v525()
		if t2.value86:IsA("RemoteEvent") then
			t2.value86:FireServer(p56)

			return
		end

		if not t2.value86:IsA("RemoteFunction") then
			return
		end

		t2.value86:InvokeServer(p56)
	end

	pcall(v525)
end

handlers[22][1] = t1.value1

function t2.value88()
	return t2.value1() < t2.value68
end
function t1.value1()
	if t2.value69 then
		return nil
	else
		local v526 = v456()

		if v526 and t2.value43 then
			local AssemblyLinearVelocity = v526.AssemblyLinearVelocity
			local Magnitude = AssemblyLinearVelocity.Magnitude
			local Position = v526.Position
			local Position2 = t2.value43.Position
			local Magnitude2 = (Position - Position2).Magnitude

			if Magnitude2 < 0.5 and true or t2.value21.DiveRange < Magnitude2 then
				return nil
			elseif Magnitude < t2.value21.MinSpeed and true or t2.value21.MaxSpeed < Magnitude then
				return nil
			else
				local CurrentCamera = t2.value11.CurrentCamera

				if CurrentCamera then
					local CFrame_ = CurrentCamera.CFrame
					local Unit = Vector3.new(CFrame_.RightVector.X, 0, CFrame_.RightVector.Z).Unit
					local DiveLead = t2.value21.DiveLead
					local vector3 = Vector3.new(0, -t2.value11.Gravity * 0.95, 0)
					local v537 = Position + AssemblyLinearVelocity * DiveLead + 0.5 * vector3 * (DiveLead * DiveLead)
					local v538 = (v537 - Position2):Dot(Unit)
					local v539 = math.max(Position.Y - Position2.Y, v537.Y - Position2.Y)
					local v540 = math.abs(v538)
					local v541 = t2.value21.HighThreshold <= v539
					local v542 = v538 < 0 and "Left" or "Right"
					local v543

					if v540 < t2.value21.SideThreshold then
						v543 = v539 >= 0.5 and "High Catch" or "Low Catch"
					elseif v541 then
						v543 = "High Dive " .. v542
					else
						v543 = "Dive " .. v542
					end

					return {
						Action = v543,
						Jump = false,
						Distance = Magnitude2,
						Speed = Magnitude,
						Ball = v526
					}
				else
					return nil
				end
			end
		else
			return nil
		end
	end
end

t2.value89 = t1.value1

local v544 = handlers[19]

local function v545()
	local v546

	if t2.value21.DiveCooldown > 0 then
		v546 = t2.value1() - t2.value65 < t2.value21.DiveCooldown
	else
		v546 = false
	end

	if v546 then
		return
	end

	local v547 = t2.value89()

	if not (v547 and v547.Action) then
		return
	end

	t2.value65 = t2.value1()

	if v547.Jump then
		v544[1]()
	end

	if v547.Action ~= "Reflex" then
		v510(v547.Action)

		return
	end

	local v548 = t2
	local value68 = t2.value68
	local v550 = t2.value1() + 0.4

	v548.value68 = math.max(value68, v550)
	v510(v547.Action)
end

function t1.value1(p57)
	if p57 and t2.value43 then
		local AssemblyLinearVelocity = p57.AssemblyLinearVelocity

		if AssemblyLinearVelocity.Magnitude <= 0.5 then
			return false
		else
			local Unit = (t2.value43.Position - p57.Position).Unit

			return AssemblyLinearVelocity.Unit:Dot(Unit) > -0.1
		end
	else
		return false
	end
end

t2.value90 = t1.value1

local v553 = handlers[22]

local function v554(p58)
	if t2.value69 or t2.value70 then
		return
	end

	if not (p58 and t2.value43) then
		return
	end

	if p58.AssemblyLinearVelocity.Magnitude <= 0.5 then
		return
	end

	if t2.value1() - t2.value66 < t2.value21.CatchCooldown then
		return
	end

	t2.value66 = t2.value1()
	t2.value70 = true

	local Y = t2.value43.CFrame:PointToObjectSpace(p58.Position).Y

	if Y >= 1.2 then
		v510("High Catch")
	else
		local v556

		if Y >= -0.5 then
			v556 = Y < 1.2
		else
			v556 = false
		end

		if v556 then
			if p58.AssemblyLinearVelocity.Magnitude > 30 then
				if not v510("Reflex") then
					v510("High Catch")
				end
			else
				v510("High Catch")
			end
		else
			v510("Low Catch")
		end
	end

	v553[1](p58)

	local firetouchinterest_ = firetouchinterest

	if typeof(firetouchinterest_) ~= "function" then
		return
	end

	pcall(function()
		firetouchinterest(p58, t2.value43, 0)
		firetouchinterest(p58, t2.value43, 1)
	end)
end

t2.value91 = nil
t2.value92 = nil
t2.value93 = nil

function t1.value1()
	if not t2.value43 then
		return
	end

	local ipairs_ = ipairs
	local value11 = t2.value11
	local t18 = {}

	for _, descendant in ipairs_(value11.GetDescendants(value11)) do
		if descendant:IsA("BasePart") then
			local v563 = descendant.Name:lower()
			local pos = v563.find(v563, "post") or (v563:find("trave") or (v563:find("bar") or (v563.find(v563, "goal") or (v563:find("net") or v563:find("rede")))))

			if pos then
				pos = not v563:find("cross")
			end

			if pos then
				table.insert(t18, descendant)
			end
		end
	end

	if not (#t18 >= 2) then
		t2.value93 = t2.value43.Position

		return
	end

	table.sort(t18, function(p59, p60)
		return (p59.Position - t2.value43.Position).Magnitude < (p60.Position - t2.value43.Position).Magnitude
	end)
	t2.value91 = t18[1]
	t2.value92 = t18[2]
	t2.value93 = (t18[1].Position + t18[2].Position) / 2
end

handlers[20][1] = t1.value1

local v565 = handlers[20]

function t1.value1()
	if not (t2.value21.AutoPos and (t2.value43 and t2.value42)) then
		return
	end

	local v566 = v456
	local v567 = v566()

	if not (t2.value91 and (t2.value92 and (t2.value91.Parent and t2.value92.Parent))) then
		v566 = v565[1]
		v566()
	end

	local Position

	if v567 then
		Position = v567.Position
	else
		Position = v567
	end

	local v569 = Position or nil
	local Magnitude

	if v567 then
		Magnitude = v567.AssemblyLinearVelocity.Magnitude
	else
		Magnitude = v567
	end

	local v571 = Magnitude or 0

	if v567 then
		if v571 > 12 then
			v567 = t2.value90(v567)
		else
			v567 = false
		end
	end

	if v567 then
		t2.value42:MoveTo(unpack_({ Vector3.new(v569.X, t2.value43.Position.Y, v569.Z) }))

		return
	end

	local value93 = t2.value93
	local value91 = t2.value91

	if value91 then
		value91 = t2.value92
	end

	if value91 then
		local Position2 = t2.value91.Position
		local Position3 = t2.value92.Position

		value93 = (Position2 + Position3) / 2

		if v569 then
			local v576 = Position3 - Position2
			local Unit = v576.Unit
			local v578 = (v569 - Position2):Dot(Unit)
			local v579 = v576.Magnitude - 2

			value93 = Position2 + Unit * math.clamp(v578, 2, v579)
		end
	end

	local v580

	if value93 then
		v580 = (t2.value43.Position - value93).Magnitude > 1.5
	else
		v580 = value93
	end

	if not v580 then
		return
	end

	t2.value42:MoveTo(unpack_({ Vector3.new(value93.X, t2.value43.Position.Y, value93.Z) }))
end

t2.value94 = t1.value1

local function v581()
	t2.value67 = t2.value1() + 1.5

	if not t2.value21.AutoCatch then
		return
	end

	local v582 = t2
	local value68 = t2.value68
	local v584 = t2.value1() + 0.4

	v582.value68 = math.max(value68, v584)
end
local function v585(p61)
	if not (p61 and p61:IsA("Tool")) then
		return
	end

	local v586 = p61.Name:lower()

	if not (v586:find("kick") or (v586:find("shoot") or (v586:find("ball") or (v586:find("glove") or (v586:find("chute") or v586:find("luva")))))) then
		return
	end

	pcall(function()
		p61.Activated:Connect(v581)
		p61.Equipped:Connect(v581)
		p61.Unequipped:Connect(v581)
	end)
end
local function v587(p62)
	if not p62 then
		return
	end

	local GetChildren = p62.GetChildren

	for _, v in ipairs(GetChildren(p62)) do
		v585(v)
	end

	p62.ChildAdded:Connect(function(child)
		task.wait(0.1)
		v585(child)
	end)
end

handlers[39] = v587(t2.value15:FindFirstChild("Backpack"))
t1.value1 = t2.value15.CharacterAdded

function t1.value36(p63)
	task.wait(0.5)
	t2.value91 = nil
	t2.value92 = nil
	t2.value93 = nil

	local v591 = v587
	local t19 = { t2.value15:FindFirstChild("Backpack") }
	local GetChildren = p63.GetChildren

	v591(unpack_(t19))

	for _, v in ipairs(GetChildren(p63)) do
		v585(v)
	end

	local function v596(child)
		task.wait(0.1)
		v585(child)
	end

	p63.ChildAdded:Connect(v596)
end

local Connect = t1.value1.Connect

t1.value21 = 0
handlers[39] = Connect
handlers[39] = handlers[39](t1.value1, t1.value36)
t2.value95 = {
	Ball = nil,
	LastScan = t1.value21,
	LastTouch = 0,
	Sphere = nil
}

local function v598()
	if t2.value21.ReachOn and (t2.value21.ReachSphere and (t2.value43 and t2.value43.Parent)) then
		if t2.value95.Sphere and t2.value95.Sphere.Parent then
			v630 = t2.value21.ReachDist * 2
			t2.value95.Sphere.Size = Vector3.new(v630, v630, v630)
			t2.value95.Sphere.Position = t2.value43.Position

			return
		end

		local Part = Instance.new("Part")

		Part.Name = "NapoleonReachSphere"
		Part.Shape = Enum.PartType.Ball
		Part.Anchored = true
		Part.CanCollide = false
		Part.CanTouch = false
		Part.CanQuery = false
		Part.CastShadow = false
		Part.Transparency = 0.8
		Part.Material = Enum.Material.ForceField
		Part.Color = Color3.fromRGB(0, 255, 0)
		Part.Parent = t2.value11
		t2.value95.Sphere = Part

		local v600 = t2.value21.ReachDist * 2

		t2.value95.Sphere.Size = Vector3.new(v600, v600, v600)
		t2.value95.Sphere.Position = t2.value43.Position

		return
	end

	if not t2.value95.Sphere then
		return
	end

	local function v601()
		t2.value95.Sphere:Destroy()
	end

	pcall(v601)
	t2.value95.Sphere = nil
end

function t1.value1()
	if not (t2.value43 and (t2.value43.Parent and t2.value41)) then
		return
	end

	local v602 = t2.value1()

	if not t2.value95.Ball or (not t2.value95.Ball.Parent or v602 - t2.value95.LastScan > 0.25) then
		t2.value95.Ball = v456()
		t2.value95.LastScan = v602
	end

	v598()

	local Ball = t2.value95.Ball

	if not (Ball and Ball.Parent) then
		return
	end

	local firetouchinterest_ = firetouchinterest

	if typeof(firetouchinterest_) ~= "function" then
		return
	end

	if v602 - t2.value95.LastTouch < 0.03 then
		return
	end

	t2.value95.LastTouch = v602

	local ReachDist = t2.value21.ReachDist
	local Position = Ball.Position
	local ipairs_ = ipairs
	local value41 = t2.value41

	for _, child in ipairs_(value41.GetChildren(value41)) do
		local isBasePart = child:IsA("BasePart")

		if isBasePart then
			if child.Name == "HumanoidRootPart" then
				isBasePart = false
			else
				isBasePart = (Position - child.Position).Magnitude <= ReachDist
			end
		end

		if isBasePart then
			pcall(function()
				firetouchinterest(Ball, child, 0)
				firetouchinterest(Ball, child, 1)
			end)
		end
	end
end

t2.value96 = t1.value1

function t1.value1()
	if t2.value71 then
		return
	end

	local n8 = 0

	t2.value71 = t2.value7.Heartbeat:Connect(function(dt)
		n8 = n8 + dt

		if n8 < 0.015 then
			return
		end

		n8 = 0
		t2.value87()

		local v613 = v456()

		if v613 and t2.value43 then
			local Magnitude = (v613.Position - t2.value43.Position).Magnitude
			local Magnitude2 = v613.AssemblyLinearVelocity.Magnitude
			local value69

			if Magnitude < 3 then
				value69 = Magnitude2 < 4
			else
				value69 = false
			end

			t2.value69 = value69

			if Magnitude > 6 then
				t2.value70 = false
			end
		else
			t2.value69 = false
		end

		if t2.value21.ReachOn then
			t2.value96()
		end

		if t2.value21.AutoPos then
			t2.value94()
		end

		local v617 = not t2.value21.AutoDive

		if v617 then
			v617 = not t2.value21.AutoCatch
		end

		if v617 then
			return
		end

		if not t2.value43 or (not t2.value43.Parent or (not t2.value42 or t2.value42.Health <= 0)) then
			return
		end

		local v618 = v456()

		if not v618 then
			return
		end

		local AutoCatch = t2.value21.AutoCatch

		if AutoCatch then
			AutoCatch = not t2.value69

			if AutoCatch then
				AutoCatch = not t2.value70

				if AutoCatch then
					AutoCatch = not t2.value88()
				end
			end
		end

		if AutoCatch then
			local v620

			if (v618.Position - t2.value43.Position).Magnitude <= t2.value21.CatchRange then
				v620 = t2.value90(v618)
			else
				v620 = false
			end

			if v620 then
				v554(v618)

				return
			end
		end

		local AutoDive = t2.value21.AutoDive

		if AutoDive then
			AutoDive = not t2.value69
		end

		if not AutoDive then
			return
		end

		if t2.value1() < t2.value67 then
			return
		end

		local v622

		if t2.value21.DiveCooldown > 0 then
			v622 = t2.value1() - t2.value65 < t2.value21.DiveCooldown
		else
			v622 = false
		end

		if v622 then
			return
		end

		local Action = t2.value89()

		if Action then
			Action = Action.Action
		end

		if not Action then
			return
		end

		v545()
	end)
end

t2.value97 = t1.value1

local function v624()
	if not t2.value71 then
		v433()

		return
	end

	t2.value71:Disconnect()
	t2.value71 = nil
	v433()
end

v495()
task.spawn(function()
	while true do
		local v625 = t2.value4()

		if v625 then
			v625 = task.wait(2)
		end

		if not v625 then
			return
		end

		v495()
	end
end)
t2.value98 = {
	Orig = nil,
	Atmos = nil,
	Clouds = handlers[37],
	Post = t1.value34
}

function t1.value1(p64)
	local pairs_ = pairs
	local value11 = t2.value11

	for _, descendant in pairs_(value11.GetDescendants(value11)) do
		if descendant:IsA("BasePart") or descendant:IsA("Model") then
			local v631 = string.lower(descendant.Name)
			local v632 = string.find(v631, "sky") or (string.find(v631, "dome") or (string.find(v631, "ceu") or string.find(v631, "atmosphere")))

			if v632 then
				v632 = not string.find(v631, "napoleon")
			end

			if v632 then
				pcall(function()
					descendant:Destroy()
				end)
			end
		end
	end

	local pairs_2 = pairs
	local value12 = t2.value12

	for _, child in pairs_2(value12.GetChildren(value12)) do
		if child:IsA("Sky") then
			if not t2.value98.Orig then
				t2.value98.Orig = child:Clone()
			end

			child:Destroy()
		elseif child:IsA("Atmosphere") then
			if not t2.value98.Atmos then
				t2.value98.Atmos = child:Clone()
			end

			child:Destroy()
		elseif child:IsA("Clouds") then
			if not t2.value98.Clouds then
				local Clone = child.Clone

				t2.value98.Clouds = Clone(child)
			end

			child:Destroy()
		else
			local isPostEffect = child:IsA("PostEffect")

			if isPostEffect then
				if child.Name == "NapoleonKeyBlur" then
					isPostEffect = false
				else
					isPostEffect = child.Name ~= "NapoleonLoadBlur"
				end
			end

			if isPostEffect then
				local Post = t2.value98.Post

				table.insert(Post, child:Clone())
				child:Destroy()
			end
		end
	end

	local u639 = nil

	local function v640()
		game:GetObjects("rbxassetid://" .. tostring(p64))

		for _, v in pairs("pairs") do
			if v:IsA("Sky") then
				v.Name = "NapoleonSky"
				v.Parent = t2.value12
				u639 = true
			end
		end
	end

	u639 = false
	pcall(v640)

	if u639 then
		return
	end

	local Sky = Instance.new("Sky")

	Sky.Name = "NapoleonSky"

	local skyboxBk = "rbxassetid://" .. tostring(p64)

	Sky.SkyboxBk = skyboxBk
	Sky.SkyboxDn = skyboxBk
	Sky.SkyboxFt = skyboxBk
	Sky.SkyboxLf = skyboxBk
	Sky.SkyboxRt = skyboxBk
	Sky.SkyboxUp = skyboxBk
	Sky.Parent = t2.value12
end

t2.value99 = t1.value1

local function v645()
	local pairs_ = pairs
	local value12 = t2.value12

	for _, child in pairs_(value12.GetChildren(value12)) do
		if child:IsA("Sky") or child.Name == "NapoleonSky" then
			child:Destroy()
		end
	end

	if t2.value98.Orig then
		t2.value98.Orig:Clone().Parent = t2.value12
		t2.value98.Orig = nil
	end

	if t2.value98.Atmos then
		t2.value98.Atmos:Clone().Parent = t2.value12
		t2.value98.Atmos = nil
	end

	if not t2.value98.Clouds then
		for _, v in ipairs(t2.value98.Post) do
			if v then
				v:Clone().Parent = t2.value12
			end
		end

		t2.value98.Post = {}

		return
	end

	t2.value98.Clouds:Clone().Parent = t2.value12
	t2.value98.Clouds = nil

	for _, v in ipairs(t2.value98.Post) do
		if v then
			v:Clone().Parent = t2.value12
		end
	end

	t2.value98.Post = {}
end

t2.value100 = nil
t2.value101 = false

local v654 = handlers[7]
local v655 = handlers[9]

function t1.value1()
	if t2.value101 then
		return
	end

	t2.value101 = true

	if t2.value100 then
		local function v656()
			t2.value100:Destroy()
		end

		pcall(v656)
		t2.value100 = nil
	end

	v260("NapoleonKeys")
	v654[1]()
	task.wait(0.4)
	t2.value100 = t2.value5:CreateWindow({
		Title = "NAPOLEON HUB",
		Author = "Sistema Imperial de Key",
		Size = v38(480, 420),
		Theme = "NapoleonKeys",
		HasOutline = true,
		Transparent = false
	})
	v89(t2.value100, { "Tag", "CreateTag", "AddTag" }, {
		Title = "Imperio Napoleon",
		Icon = "crown",
		Color = Color3.fromHex("#c9a961"),
		Radius = 6
	})

	local value100 = t2.value100

	if value100 then
		pcall(function()
			local v658 = value100
			local t20 = {
				Title = "NAPOLEON",
				Icon = "crown",
				CornerRadius = UDim.new(0, 16),
				StrokeThickness = 2,
				Color = ColorSequence.new(Color3.fromHex("#f9ecc0"), Color3.fromHex("#7a5e28")),
				OnlyMobile = false,
				Enabled = true,
				Draggable = true
			}

			v658.EditOpenButton(v658, t20)
		end)
	end

	local v660 = v89(t2.value100, { "Tab", "AddTab", "CreateTab" }, {
		Title = "Key",
		Icon = "lucide:key",
		IconShape = "Square",
		Border = true
	})

	if not v660 then
		t2.value101 = false

		return
	end

	v89(v660, { "Section", "AddSection", "CreateSection" }, {
		Title = "Bem-vindo, General"
	})
	v89(v660, { "Paragraph", "AddParagraph", "CreateParagraph" }, {
		Title = "Acesso ao Imperio",
		Desc = "Insira sua key imperial para desbloquear el hub.\nCada key fica ativa por 24 horas.\n\ndiscord.gg/fTKM4ubCw"
	})

	local v661 = v89(v660, { "Paragraph", "AddParagraph", "CreateParagraph" }, {
		Title = "Status",
		Desc = "Aguardando sua key..."
	})
	local u662 = nil

	local function v663(p65)
		if u662 then
			return
		end

		local v664 = tostring(p65 or ""):gsub("^%s+", ""):gsub("%s+$", "")

		if not t2.value57(v664) then
			v97(v661, "Key Invalida", "Verifique e tente novamente. Pegue sua key no Discord.")
			v98({
				Title = "Key Invalida",
				Content = "Verifique e tente novamente.",
				Duration = 4,
				Icon = "x"
			})

			return
		end

		u662 = true

		if writefile then
			pcall(writefile, t2.value53, v664)
			t2.value58()
		end

		v97(v661, "Key Valida", "Bem-vindo ao Imperio, General! Abrindo o hub...")
		v98({
			Title = "Key Valida",
			Content = "Bem-vindo ao Imperio, General!",
			Duration = 3,
			Icon = "crown"
		})

		local function v665()
			local value12 = t2.value12
			local v667 = value12.FindFirstChild(value12, "NapoleonKeyBlur")

			if not v667 then
				return
			end

			v667:Destroy()
		end

		pcall(v665)
		task.spawn(function()
			task.wait(0.4)
			pcall(function()
				if not t2.value100 then
					return
				end

				t2.value100:Destroy()
				t2.value100 = nil
			end)
			t2.value101 = false
			t2.value52()
			task.wait(0.5)
			pcall(function()
				if not _G.NapoleonLoadHub then
					return
				end

				_G.NapoleonLoadHub()
			end)
			task.wait(0.4)
			v371()
		end)
	end

	local s2 = ""

	u662 = false

	local function v669(p66)
		s2 = p66
	end

	v89(v660, { "Section", "AddSection", "CreateSection" }, {
		Title = "Autenticacao"
	})
	v655[1](v660, {
		Title = "Sua Key",
		Desc = "Cole a key de acesso aqui:",
		Value = "",
		Placeholder = "Cole sua key imperial aqui...",
		Callback = v669
	})
	v89(v660, { "Button", "AddButton", "CreateButton" }, {
		Title = "Verificar e Entrar",
		Desc = "Valida sua key e abre o hub",
		Icon = "lucide:check-circle",
		Callback = function()
			v663(s2)
		end
	})
	v89(v660, { "Button", "AddButton", "CreateButton" }, {
		Title = "Copiar link do Discord",
		Desc = "Copia o convite para a area de transferencia",
		Icon = "lucide:copy",
		Callback = function()
			local ok

			if setclipboard then
				ok = pcall(setclipboard, "discord.gg/fTKM4ubCw")
			else
				ok = false
			end

			v98({
				Title = "Discord",
				Content = ok and "Link copiado!" or "discord.gg/fTKM4ubCw",
				Duration = 3,
				Icon = ok and "check" or "info"
			})
		end
	})
	v89(v660, { "Section", "AddSection", "CreateSection" }, {
		Title = "Informacoes"
	})
	v89(v660, { "Paragraph", "AddParagraph", "CreateParagraph" }, {
		Title = "Duracao",
		Desc = "Sua key e valida por 24 horas apos a validacao.\nDepois disso, pegue uma nova no Discord."
	})
	v89(v660, { "Paragraph", "AddParagraph", "CreateParagraph" }, {
		Title = "Creditos",
		Desc = "Feito por: equipe unk\nDiscord: discord.gg/fTKM4ubCw"
	})
	t2.value40()
end

t2.value102 = t1.value1
t2.value103 = nil
handlers[14][1] = nil
t2.value104 = false
t2.value105 = false
t2.value106 = nil
t1.value1 = _G

local v671 = handlers[6]
local v672 = handlers[14]

function t1.value36()
	t2.value51(25)
	t2.value104 = false
	t2.value105 = false

	if t2.value106 then
		t2.value106:Disconnect()
		t2.value106 = nil
	end

	local u673 = true
	local v674 = nil

	local function v675()
		local value12 = t2.value12
		local v677 = value12.FindFirstChild(value12, "NapoleonKeyBlur")

		if not v677 then
			return
		end

		v677:Destroy()
	end

	pcall(v675)
	v260("Napoleon")
	task.wait(0.4)
	t2.value51(45)

	local value5 = t2.value5
	local v679 = v38(720, 500)
	local Theme = t2.value21.Theme
	local KeyCode = Enum.KeyCode
	local CreateWindow = value5.CreateWindow
	local K = KeyCode.K

	t2.value103 = CreateWindow(value5, {
		Title = "NAPOLEON HUB",
		Author = "Feito por: equipe unk",
		Folder = "NapoleonHub",
		Size = v679,
		Transparent = false,
		Theme = Theme,
		SideBarWidth = v671[1] and 150 or 200,
		HasOutline = true,
		Resizable = true,
		ToggleKey = K
	})
	v89(t2.value103, { "Tag", "CreateTag", "AddTag" }, {
		Title = "Imperio Napoleon",
		Icon = "crown",
		Color = Color3.fromHex("#c9a961"),
		Radius = 6
	})
	v89(t2.value103, { "Tag", "CreateTag", "AddTag" }, {
		Title = "discord.gg/fTKM4ubCw",
		Icon = "message-square-more",
		Color = Color3.fromHex("#a8916b"),
		Radius = 6
	})

	local value103 = t2.value103

	if value103 then
		pcall(function()
			local v685 = value103
			local t21 = {
				Title = "NAPOLEON",
				Icon = "crown",
				CornerRadius = UDim.new(0, 16),
				StrokeThickness = 2,
				Color = ColorSequence.new(Color3.fromHex("#f9ecc0"), Color3.fromHex("#7a5e28")),
				OnlyMobile = false,
				Enabled = true,
				Draggable = true
			}

			v685.EditOpenButton(v685, t21)
		end)
	end

	t2.value40()
	t2.value51(60)

	local v687 = v89(t2.value103, { "Tab", "AddTab", "CreateTab" }, {
		Title = "Status",
		Icon = "lucide:activity",
		IconShape = "Square",
		Border = true
	})

	v89(v687, { "Section", "AddSection", "CreateSection" }, {
		Title = "Controles Rapidos"
	})

	local function v688()
		if t2.value21.AutoDive or (t2.value21.AutoCatch or (t2.value21.Predict or (t2.value21.ReachOn or t2.value21.AutoPos))) then
			t2.value97()

			return
		end

		if not t2.value71 then
			v433()

			return
		end

		t2.value71:Disconnect()
		t2.value71 = nil
		v433()
	end

	local t22 = {}

	local function v690(p67, p68)
		local v691 = t22[p67]
		local v692

		if type(v691) == "table" then
			local Set = v691.Set

			v692 = type(Set) == "function"
		else
			v692 = false
		end

		if not v692 then
			return
		end

		pcall(function()
			v691:Set(p68)
		end)
	end
	local function v694(p69)
		local autoDive = p69 and true or false

		if t2.value21.AutoDive ~= autoDive then
			t2.value21.AutoDive = autoDive
			v688()
			v690("Dive", autoDive)
			v98({
				Title = "Auto Dive",
				Content = autoDive and "ATIVADO" or "DESATIVADO",
				Duration = 2,
				Icon = autoDive and "check" or "x"
			})
		end
	end
	local function v696(p70)
		local autoCatch = p70 and true or false

		if t2.value21.AutoCatch ~= autoCatch then
			t2.value21.AutoCatch = autoCatch
			v688()
			v690("Catch", autoCatch)
			v98({
				Title = "Auto Catch",
				Content = autoCatch and "ATIVADO" or "DESATIVADO",
				Duration = 2,
				Icon = autoCatch and "check" or "x"
			})
		end
	end
	local function v698(p71)
		local autoPos = p71 and true or false

		if t2.value21.AutoPos ~= autoPos then
			t2.value21.AutoPos = autoPos
			v688()
			v690("AutoPos", autoPos)
			v98({
				Title = "Auto Posicionamento",
				Content = autoPos and "ATIVADO" or "DESATIVADA",
				Duration = 2,
				Icon = autoPos and "check" or "x"
			})
		end
	end
	local function v700(p72)
		local v701 = p72 and true or false

		if t2.value21.Predict == v701 then
			return
		end

		t2.value64("Predict", v701)

		if v701 then
			v688()
			v690("Predict", v701)
			v98({
				Title = "Trajetoria",
				Content = v701 and "ATIVADA" or "DESATIVADA",
				Duration = 2,
				Icon = v701 and "check" or "x"
			})

			return
		end

		v433()
		v688()
		v690("Predict", v701)
		v98({
			Title = "Trajetoria",
			Content = v701 and "ATIVADA" or "DESATIVADA",
			Duration = 2,
			Icon = v701 and "check" or "x"
		})
	end

	t22.Dive = v89(v687, { "Toggle", "AddToggle", "CreateToggle" }, {
		Title = "Auto Dive",
		Desc = "Dive automatico baseado na trajetoria da bola. Atalho: F",
		Value = false,
		Callback = function(p73)
			v694(p73)
		end
	})
	t22.Catch = v89(v687, { "Toggle", "AddToggle", "CreateToggle" }, {
		Title = "Auto Catch",
		Desc = "Captura automatica das bolas proximas. Atalho: G",
		Value = false,
		Callback = function(p74)
			v696(p74)
		end
	})
	t22.AutoPos = v89(v687, { "Toggle", "AddToggle", "CreateToggle" }, {
		Title = "Auto Posicionamento",
		Desc = "Mantem o goleiro alinhado ao centro do gol e fecha o angulo da bola.",
		Value = false,
		Callback = function(p75)
			v698(p75)
		end
	})
	t22.Predict = v89(v687, { "Toggle", "AddToggle", "CreateToggle" }, {
		Title = "Linha de Trajetoria",
		Desc = "Mostra a trajetoria prevista da bola.",
		Value = t2.value21.Predict,
		Callback = function(p76)
			v700(p76)
		end
	})
	v688()
	t2.value106 = t2.value8.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed or not (t2.value4() and u673) then
			return
		end

		if input.KeyCode == Enum.KeyCode.F then
			v694(not t2.value21.AutoDive)

			return
		end

		if input.KeyCode ~= Enum.KeyCode.G then
			return
		end

		v696(not t2.value21.AutoCatch)
	end)
	v89(v687, { "Section", "AddSection", "CreateSection" }, {
		Title = "Estado do Hub"
	})

	local v702 = v89(v687, { "Paragraph", "AddParagraph", "CreateParagraph" }, {
		Title = "Sistema",
		Desc = "Modo: Legit\nAuto Dive: Desligado\nAuto Catch: Desligado\nKey: Carregando..."
	})
	local v703 = v89(v687, { "Paragraph", "AddParagraph", "CreateParagraph" }, {
		Title = "Bola",
		Desc = "Nenhuma bola detectada."
	})

	v89(v687, { "Button", "AddButton", "CreateButton" }, {
		Title = "Atualizar Status",
		Desc = "Forca atualizacao das informacoes",
		Icon = "lucide:refresh-cw",
		Callback = function()
			local v704 = v456()

			if not v704 then
				v97(v703, "Bola", v704 or "Nenhuma bola detectada.")
				v98({
					Title = "Status",
					Content = "Atualizado!",
					Duration = 2,
					Icon = "check"
				})

				return
			end

			local floor = math.floor
			local Position = v704.Position
			local value43 = t2.value43

			if value43 then
				value43 = t2.value43.Position
			end

			v704 = "Detectada a " .. floor((Position - (value43 or Vector3.zero)).Magnitude) .. " studs"
			v97(v703, "Bola", v704 or "Nenhuma bola detectada.")
			v98({
				Title = "Status",
				Content = "Atualizado!",
				Duration = 2,
				Icon = "check"
			})
		end
	})
	v89(v687, { "Section", "AddSection", "CreateSection" }, {
		Title = "Atalhos"
	})

	local function v708()
		local function v709()
			if not delfile then
				return
			end

			local isfile_ = isfile

			if isfile_ then
				isfile_ = isfile(t2.value53)
			end

			if isfile_ then
				delfile(t2.value53)
			end

			local isfile_2 = isfile

			if isfile_2 then
				isfile_2 = isfile(t2.value54)
			end

			if not isfile_2 then
				return
			end

			delfile(t2.value54)
		end

		pcall(v709)
		v98({
			Title = "Key",
			Content = "Key apagada! Voltando para a tela de key...",
			Duration = 3,
			Icon = "trash"
		})

		local function v712()
			if not v674 then
				return
			end

			v674()
		end

		task.delay(1.2, v712)
	end

	v89(v687, { "Paragraph", "AddParagraph", "CreateParagraph" }, {
		Title = "Teclas",
		Desc = "K - Abre/Fecha o Hub (PC)\nBotao dourado NAPOLEON - Abre/Fecha (celular)\nF - Auto Dive\nG - Auto Catch\n\nUse as abas a esquerda pra navegar."
	})
	v89(v687, { "Button", "AddButton", "CreateButton" }, {
		Title = "Resetar Key",
		Desc = "Apaga sua key salva e forca digitar de novo.",
		Icon = "lucide:trash-2",
		Callback = v708
	})

	local v713 = v89(t2.value103, { "Tab", "AddTab", "CreateTab" }, {
		Title = "Defesa",
		Icon = "lucide:shield",
		IconShape = "Square",
		Border = true
	})

	v89(v713, { "Section", "AddSection", "CreateSection" }, {
		Title = "Modo de Defesa"
	})

	local function v714(p77)
		t2.value64("Mode", (tostring(p77)))
		v98({
			Title = "Modo de Defesa",
			Content = "Definido: " .. tostring(p77),
			Duration = 3,
			Icon = "info"
		})
	end

	v89(v713, { "Dropdown", "AddDropdown", "CreateDropdown" }, {
		Title = "Estilo da Defesa",
		Desc = "Escolha entre Legit ou Blatant.",
		Multi = false,
		Value = t2.value21.Mode,
		Values = { "Legit", "Blatant" },
		Callback = v714
	})

	local function v715(p78)
		t2.value21.AutoPos = p78 and true or false
		t2.value63()
		v688()
		v98({
			Title = "Auto Posicionamento",
			Content = t2.value21.AutoPos and "Ativado!" or "Desativado!",
			Duration = 3,
			Icon = t2.value21.AutoPos and "check" or "x"
		})
	end

	v89(v713, { "Section", "AddSection", "CreateSection" }, {
		Title = "Automação do Goleiro"
	})
	v89(v713, { "Toggle", "AddToggle", "CreateToggle" }, {
		Title = "Auto Posicionamento",
		Desc = "Calcula a linha central do gol e acompanha os chutes.",
		Value = t2.value21.AutoPos,
		Icon = "lucide:navigation",
		Callback = v715
	})
	v89(v713, { "Section", "AddSection", "CreateSection" }, {
		Title = "Distancia"
	})

	local function v716(p79)
		t2.value64("DiveRange", p79)
	end

	v89(v713, { "Slider", "AddSlider", "CreateSlider" }, {
		Title = "Distancia de Defesa",
		Desc = "Alcance maximo para dar dive.",
		Value = {
			Min = 10,
			Max = 60,
			Default = t2.value21.DiveRange
		},
		Step = 1,
		Callback = v716
	})

	local function v717(p80)
		t2.value64("CatchRange", p80)
	end

	v89(v713, { "Slider", "AddSlider", "CreateSlider" }, {
		Title = "Distancia de Captura",
		Desc = "Alcance para capturar a bola.",
		Value = {
			Min = 3,
			Max = 20,
			Default = t2.value21.CatchRange
		},
		Step = 1,
		Callback = v717
	})
	v89(v713, { "Section", "AddSection", "CreateSection" }, {
		Title = "Velocidade"
	})

	local function v718(p81)
		t2.value64("MinSpeed", p81)
	end

	v89(v713, { "Slider", "AddSlider", "CreateSlider" }, {
		Title = "Velocidade Minima",
		Desc = "Velocidade minima da bola.",
		Value = {
			Min = 0,
			Max = 80,
			Default = t2.value21.MinSpeed
		},
		Step = 1,
		Callback = v718
	})

	local function v719(p82)
		t2.value64("MaxSpeed", p82)
	end

	v89(v713, { "Slider", "AddSlider", "CreateSlider" }, {
		Title = "Velocidade Maxima",
		Desc = "Velocidade maxima da bola.",
		Value = {
			Min = 60,
			Max = 200,
			Default = t2.value21.MaxSpeed
		},
		Step = 1,
		Callback = v719
	})
	t2.value51(72)

	local v720 = v89(t2.value103, { "Tab", "AddTab", "CreateTab" }, {
		Title = "Trajetoria",
		Icon = "lucide:crosshair",
		IconShape = "Square",
		Border = true
	})

	v89(v720, { "Section", "AddSection", "CreateSection" }, {
		Title = "Previsao da Bola"
	})

	local v721 = v95
	local v722 = t2.value21.PredictTime * 1000 + 0.5

	v721(v720, {
		Title = "Tempo de Previsao (ms)",
		Desc = "Quanto tempo da trajetoria mostrar.",
		Value = {
			Min = 100,
			Max = 800,
			Default = math.floor(v722)
		},
		Step = 10,
		Callback = function(p83)
			t2.value64("PredictTime", p83 / 1000)
		end
	})
	v89(v720, { "Section", "AddSection", "CreateSection" }, {
		Title = "Paleta de Cores da Trajetoria"
	})
	v89(v720, { "Dropdown", "AddDropdown", "CreateDropdown" }, {
		Title = "Cor da Linha Predict",
		Desc = "Escolha a cor ou ative o modo RGB na linha de previsão.",
		Multi = false,
		Value = "Preto Total (100% Black)",
		Values = {
			"Preto Total (100% Black)",
			"RGB (Arco-íris)",
			"Ciano Neon",
			"Roxo Imperial",
			"Verde Brilhante",
			"Amarelo Ouro",
			"Laranja Fogo",
			"Vermelho Sangue",
			"Rosa Choque"
		},
		Callback = function(p84)
			local v723 = tostring(p84)

			if v723 == "RGB (Arco-íris)" then
				t2.value21.PredictRGB = true
				t2.value63()
				v98({
					Title = "Trajetoria",
					Content = "Modo RGB ativado na linha de previsão!",
					Duration = 2.5,
					Icon = "check"
				})

				return
			end

			t2.value21.PredictRGB = false
			t2.value63()

			local v724 = t2.value75[v723]

			if not v724 then
				return
			end

			t2.value21.PredictColor = v724

			for _, v in ipairs(t2.value81) do
				local Parent

				if v then
					Parent = v.Parent
				else
					Parent = v
				end

				if Parent then
					v.Color = v724
				end
			end

			if t2.value82 then
				t2.value82.Color = v724
			end

			v98({
				Title = "Cor da Trajetoria",
				Content = "Cor alterada para " .. v723 .. "!",
				Duration = 2.5,
				Icon = "check"
			})
		end
	})
	v89(v720, { "Button", "AddButton", "CreateButton" }, {
		Title = "Apagar Trajetoria",
		Desc = "Limpa todas as linhas da tela.",
		Icon = "lucide:trash",
		Callback = function()
			v433()
			v98({
				Title = "Trajetoria",
				Content = "Linhas apagadas!",
				Duration = 3,
				Icon = "trash"
			})
		end
	})

	local v728 = v89(t2.value103, { "Tab", "AddTab", "CreateTab" }, {
		Title = "GK Reach",
		Icon = "lucide:mouse",
		IconShape = "Square",
		Border = true
	})

	local function v729(p85)
		t2.value21.ReachOn = p85 and true or false
		t2.value63()
		v688()
		v98({
			Title = "Reach",
			Content = t2.value21.ReachOn and "Ativado!" or "Desativado!",
			Duration = 3,
			Icon = t2.value21.ReachOn and "check" or "x"
		})
	end

	v89(v728, { "Section", "AddSection", "CreateSection" }, {
		Title = "Alcance"
	})
	v89(v728, { "Toggle", "AddToggle", "CreateToggle" }, {
		Title = "Ativar Reach",
		Desc = "Pega a bola de mais longe.",
		Value = t2.value21.ReachOn,
		Icon = "lucide:zap",
		Callback = v729
	})

	local function v730(p86)
		t2.value64("ReachDist", p86)
	end

	v89(v728, { "Slider", "AddSlider", "CreateSlider" }, {
		Title = "Distancia",
		Desc = "Tamanho do alcance.",
		Value = {
			Min = 1,
			Max = 20,
			Default = t2.value21.ReachDist
		},
		Step = 1,
		Callback = v730
	})
	v89(v728, { "Toggle", "AddToggle", "CreateToggle" }, {
		Title = "Mostrar Bola",
		Desc = "Mostra a esfera de alcance.",
		Value = t2.value21.ReachSphere,
		Callback = function(p87)
			t2.value21.ReachSphere = p87 and true or false
			t2.value63()
			v598()
		end
	})

	local v731 = v89(t2.value103, { "Tab", "AddTab", "CreateTab" }, {
		Title = "Campo",
		Icon = "lucide:palette",
		IconShape = "Square",
		Border = true
	})

	v89(v731, { "Section", "AddSection", "CreateSection" }, {
		Title = "Cor do Gramado"
	})
	v89(v731, { "Dropdown", "AddDropdown", "CreateDropdown" }, {
		Title = "Escolher Cor do Campo",
		Desc = "Altera apenas a cor do gramado/campo de futebol.",
		Multi = false,
		Value = "Verde",
		Values = {
			"Preto",
			"Azul",
			"Ciano",
			"Verde",
			"Verde Escuro"
		},
		Callback = function(p88)
			local v732 = t2.value74[p88]

			if not v732 then
				return
			end

			v410(v732)
			v98({
				Title = "Campo",
				Content = "Cor do campo alterada para " .. p88 .. "!",
				Duration = 3,
				Icon = "check"
			})
		end
	})
	v89(v731, { "Button", "AddButton", "CreateButton" }, {
		Title = "Restaurar Cor Original",
		Desc = "Volta a cor padrao do campo.",
		Icon = "lucide:rotate-ccw",
		Callback = function()
			v415()
			v98({
				Title = "Campo",
				Content = "Cor original do campo restaurada!",
				Duration = 3,
				Icon = "check"
			})
		end
	})

	local v733 = v89(t2.value103, { "Tab", "AddTab", "CreateTab" }, {
		Title = "Visual",
		Icon = "lucide:eye",
		IconShape = "Square",
		Border = true
	})

	v89(v733, { "Section", "AddSection", "CreateSection" }, {
		Title = "ESP da Bola"
	})
	v89(v733, { "Toggle", "AddToggle", "CreateToggle" }, {
		Title = "Ativar ESP da Bola",
		Desc = "Destaca a bola visualmente onde quer que ela esteja no campo.",
		Value = t2.value21.BallESP,
		Callback = function(p89)
			t2.value21.BallESP = p89 and true or false
			t2.value63()
			v460()
			v98({
				Title = "ESP da Bola",
				Content = t2.value21.BallESP and "Ativado!" or "Desativado!",
				Duration = 3,
				Icon = "check"
			})
		end
	})
	v89(v733, { "Dropdown", "AddDropdown", "CreateDropdown" }, {
		Title = "Cor do ESP da Bola",
		Desc = "Escolha a cor do destaque da bola.",
		Multi = false,
		Value = t2.value21.BallESPColor,
		Values = {
			"Ciano",
			"Preto",
			"Azul",
			"Vermelho"
		},
		Callback = function(p90)
			t2.value64("BallESPColor", (tostring(p90)))
			v460()
			v98({
				Title = "ESP da Bola",
				Content = "Cor definida para " .. tostring(p90),
				Duration = 3,
				Icon = "check"
			})
		end
	})
	v89(v733, { "Slider", "AddSlider", "CreateSlider" }, {
		Title = "Transparência do ESP",
		Desc = "Ajusta a transparência do visual (1 = mais visível, 10 = mais transparente).",
		Value = {
			Min = 1,
			Max = 10,
			Default = t2.value21.BallESPTrans
		},
		Step = 1,
		Callback = function(p91)
			t2.value64("BallESPTrans", p91)
			v460()
		end
	})

	local v734 = v89(t2.value103, { "Tab", "AddTab", "CreateTab" }, {
		Title = "Otimização",
		Icon = "lucide:cpu",
		IconShape = "Square",
		Border = true
	})

	local function v735()
		if not t2.value78.Saved then
			t2.value78.Saved = true

			local Brightness = t2.value12.Brightness

			t2.value78.Brightness = Brightness

			local ClockTime = t2.value12.ClockTime

			t2.value78.ClockTime = ClockTime

			local GlobalShadows = t2.value12.GlobalShadows

			t2.value78.GlobalShadows = GlobalShadows

			local OutdoorAmbient = t2.value12.OutdoorAmbient

			t2.value78.OutdoorAmbient = OutdoorAmbient
		end

		local function v740()
			t2.value12.GlobalShadows = false

			local ipairs_ = ipairs
			local value12 = t2.value12

			for _, child in ipairs_(value12.GetChildren(value12)) do
				local isPostEffect = child:IsA("PostEffect")

				if isPostEffect then
					if child.Name == "NapoleonKeyBlur" then
						isPostEffect = false
					else
						isPostEffect = child.Name ~= "NapoleonLoadBlur"
					end
				end

				if isPostEffect then
					child.Enabled = false
				end
			end
		end

		pcall(v740)
		v98({
			Title = "Otimização",
			Content = "Modo Low aplicado com sucesso!",
			Duration = 3,
			Icon = "check"
		})
	end

	v89(v734, { "Section", "AddSection", "CreateSection" }, {
		Title = "Modos de Desempenho"
	})

	local t23 = {
		Title = "Otimização Low",
		Desc = "Remove apenas alguns efeitos visuais pesados.",
		Icon = "lucide:zap",
		Callback = v735
	}

	local function v747()
		if not t2.value78.Saved then
			t2.value78.Saved = true

			local Brightness = t2.value12.Brightness

			t2.value78.Brightness = Brightness

			local ClockTime = t2.value12.ClockTime

			t2.value78.ClockTime = ClockTime

			local GlobalShadows = t2.value12.GlobalShadows

			t2.value78.GlobalShadows = GlobalShadows

			local OutdoorAmbient = t2.value12.OutdoorAmbient

			t2.value78.OutdoorAmbient = OutdoorAmbient
		end

		local function v752()
			t2.value12.GlobalShadows = false

			local ipairs_ = ipairs
			local value12 = t2.value12

			for _, child in ipairs_(value12.GetChildren(value12)) do
				local isPostEffect = child:IsA("PostEffect")

				if isPostEffect then
					if child.Name == "NapoleonKeyBlur" then
						isPostEffect = false
					else
						isPostEffect = child.Name ~= "NapoleonLoadBlur"
					end
				end

				if isPostEffect then
					child.Enabled = false
				end

				if child:IsA("Atmosphere") or child:IsA("Clouds") then
					child.Enabled = false
				end
			end

			for _, descendant in ipairs(t2.value11:GetDescendants()) do
				if descendant:IsA("BasePart") then
					descendant.CastShadow = false
				end
			end
		end

		pcall(v752)
		v98({
			Title = "Otimização",
			Content = "Otimização média aplicada!",
			Duration = 3,
			Icon = "check"
		})
	end

	v89(v734, { "Button", "AddButton", "CreateButton" }, t23)

	local t24 = {
		Title = "Otimização (Médio)",
		Desc = "Otimiza mais o jogo desativando sombras e atmosferas.",
		Icon = "lucide:activity",
		Callback = v747
	}

	local function v761()
		t2.value79()
		v98({
			Title = "Otimização",
			Content = "High Otimização aplicada!",
			Duration = 3,
			Icon = "check"
		})
	end

	v89(v734, { "Button", "AddButton", "CreateButton" }, t24)

	local t25 = {
		Title = "High Otimização",
		Desc = "Otimiza o jogo todo, desativando texturas e sombras.",
		Icon = "lucide:gauge",
		Callback = v761
	}

	local function v763()
		local function v764()
			local Parent, Parent2

			if not t2.value78.Saved then
				v827 = ipairs
				v828 = t2.value12

				for _, child in v827(v828.GetChildren(v828)) do
					if child:IsA("PostEffect") or (child.IsA(child, "Atmosphere") or (child:IsA("Clouds") or child:IsA("Sky"))) then
						child.Enabled = true
						v827 = "Enabled"
					end
				end

				for k, v in pairs(t2.value76) do
					if k then
						Parent = k.Parent
					else
						Parent = k
					end

					if Parent then
						k.Material = v
						k.CastShadow = true
					end
				end

				table.clear(t2.value76)

				for k, v in pairs(t2.value77) do
					if k then
						Parent2 = k.Parent
					else
						Parent2 = k
					end

					if Parent2 then
						k.Transparency = v
					end
				end

				table.clear(t2.value77)

				return
			end

			local Brightness = t2.value78.Brightness

			t2.value12.Brightness = Brightness

			local ClockTime = t2.value78.ClockTime

			t2.value12.ClockTime = ClockTime

			local GlobalShadows = t2.value78.GlobalShadows

			t2.value12.GlobalShadows = GlobalShadows
			t2.value12.OutdoorAmbient = t2.value78.OutdoorAmbient

			local ipairs_ = ipairs
			local value12 = t2.value12

			for _, child in ipairs_(value12.GetChildren(value12)) do
				if child:IsA("PostEffect") or (child.IsA(child, "Atmosphere") or (child:IsA("Clouds") or child:IsA("Sky"))) then
					child.Enabled = true
					ipairs_ = "Enabled"
				end
			end

			for k, v in pairs(t2.value76) do
				if k then
					Parent = k.Parent
				else
					Parent = k
				end

				if Parent then
					k.Material = v
					k.CastShadow = true
				end
			end

			table.clear(t2.value76)

			for k, v in pairs(t2.value77) do
				if k then
					Parent2 = k.Parent
				else
					Parent2 = k
				end

				if Parent2 then
					k.Transparency = v
				end
			end

			table.clear(t2.value77)
		end

		pcall(v764)
		v98({
			Title = "Otimização",
			Content = "Otimização removida, padrão restaurado!",
			Duration = 3,
			Icon = "check"
		})
	end

	v89(v734, { "Button", "AddButton", "CreateButton" }, t25)
	v89(v734, { "Section", "AddSection", "CreateSection" }, {
		Title = "Restaurar Padrão"
	})
	v89(v734, { "Button", "AddButton", "CreateButton" }, {
		Title = "Tirar Otimização",
		Desc = "Remove a otimização e volta as texturas e efeitos normais.",
		Icon = "lucide:rotate-ccw",
		Callback = v763
	})

	local function v784()
		t2.value99("113859918879279")
		v98({
			Title = "Sky",
			Content = "Green Sky aplicado",
			Duration = 3,
			Icon = "check"
		})
	end

	local v785 = v89(t2.value103, { "Tab", "AddTab", "CreateTab" }, {
		Title = "Sky",
		Icon = "lucide:cloud",
		IconShape = "Square",
		Border = true
	})

	v89(v785, { "Section", "AddSection", "CreateSection" }, {
		Title = "Skies Disponiveis"
	})
	v89(v785, { "Button", "AddButton", "CreateButton" }, {
		Title = "Green Sky",
		Icon = "lucide:cloud",
		Callback = v784
	})

	local function v786()
		t2.value99("96736589365838")
		v98({
			Title = "Sky",
			Content = "Minecraft Sky applied",
			Duration = 3,
			Icon = "check"
		})
	end
	local function v787()
		v645()
		v98({
			Title = "Sky",
			Content = "Sky restaurado",
			Duration = 3,
			Icon = "check"
		})
	end

	v89(v785, { "Button", "AddButton", "CreateButton" }, {
		Title = "Pink Sky",
		Icon = "lucide:cloud",
		Callback = function()
			t2.value99("96902346573845")
			v98({
				Title = "Sky",
				Content = "Pink Sky aplicado",
				Duration = 3,
				Icon = "check"
			})
		end
	})
	v89(v785, { "Button", "AddButton", "CreateButton" }, {
		Title = "Minecraft Sky",
		Icon = "lucide:cloud",
		Callback = v786
	})
	v89(v785, { "Section", "AddSection", "CreateSection" }, {
		Title = "Restaurar"
	})
	v89(v785, { "Button", "AddButton", "CreateButton" }, {
		Title = "Restaurar Sky Original",
		Desc = "Volta o ceu original do jogo.",
		Icon = "lucide:refresh-cw",
		Callback = v787
	})
	t2.value51(84)

	local v788 = v89(t2.value103, { "Tab", "AddTab", "CreateTab" }, {
		Title = "Ajustes",
		Icon = "lucide:settings",
		IconShape = "Square",
		Border = true
	})

	v89(v788, { "Section", "AddSection", "CreateSection" }, {
		Title = "Tempo de Resposta"
	})

	local v789 = v96
	local s3

	if t2.value21.DiveCooldown == 0 then
		s3 = "0 (Instantaneo)"
	else
		local DiveCooldown = t2.value21.DiveCooldown

		s3 = tostring(DiveCooldown)
	end

	v789(v788, {
		Title = "Intervalo da Defesa",
		Desc = "Tempo entre dives (cooldown).",
		Multi = false,
		Value = s3,
		Values = {
			"0 (Instantaneo)",
			"0.0001",
			"0.0005",
			"0.001",
			"0.005",
			"0.01",
			"0.02",
			"0.05"
		},
		Callback = function(p92)
			t2.value64("DiveCooldown", p92 == "0 (Instantaneo)" and 0 or (tonumber(p92) or 0))
		end
	})

	local function v792(p93)
		t2.value64("CatchCooldown", p93)
	end

	v89(v788, { "Slider", "AddSlider", "CreateSlider" }, {
		Title = "Intervalo da Captura",
		Desc = "Cooldown entre capturas.",
		Value = {
			Min = 0.1,
			Max = 3,
			Default = t2.value21.CatchCooldown
		},
		Step = 0.01,
		Callback = v792
	})

	local v793 = v95
	local v794 = t2.value21.DiveLead * 1000 + 0.5

	local function v795(p94)
		t2.value64("DiveLead", p94 / 1000)
	end

	v793(v788, {
		Title = "Antecedencia da Defesa (ms)",
		Desc = "Quanto tempo antes do impacto o dive e acionado.",
		Value = {
			Min = 150,
			Max = 1000,
			Default = math.floor(v794)
		},
		Step = 10,
		Callback = v795
	})
	v89(v788, { "Section", "AddSection", "CreateSection" }, {
		Title = "Sensibilidade"
	})

	local function v796(p95)
		t2.value64("HighThreshold", p95)
	end

	v89(v788, { "Slider", "AddSlider", "CreateSlider" }, {
		Title = "Altura da Defesa Alta",
		Desc = "Ajusta a altura pra dive alto.",
		Value = {
			Min = 0.5,
			Max = 4,
			Default = t2.value21.HighThreshold
		},
		Step = 0.1,
		Callback = v796
	})

	local function v797(p96)
		t2.value64("SideThreshold", p96)
	end

	v89(v788, { "Slider", "AddSlider", "CreateSlider" }, {
		Title = "Sensibilidade Lateral",
		Desc = "Ajusta o dive lateral.",
		Value = {
			Min = 1,
			Max = 4,
			Default = t2.value21.SideThreshold
		},
		Step = 0.1,
		Callback = v797
	})
	v89(v788, { "Toggle", "AddToggle", "CreateToggle" }, {
		Title = "Atalhos de Teclado",
		Desc = "F = Auto Dive, G = Auto Catch.",
		Value = true,
		Callback = function(p97)
			u673 = p97
		end
	})
	v89(v788, { "Section", "AddSection", "CreateSection" }, {
		Title = "Idioma / Language"
	})
	v89(v788, { "Dropdown", "AddDropdown", "CreateDropdown" }, {
		Title = "Idioma do Hub",
		Desc = "Alternar entre Português (BR) e Inglês (EN).",
		Multi = false,
		Value = t2.value21.Language,
		Values = { "Português (BR)", "English (EN)" },
		Callback = function(p98)
			t2.value64("Language", (tostring(p98)))
			v98({
				Title = "Idioma / Language",
				Content = "Idioma definido para: " .. tostring(p98),
				Duration = 3,
				Icon = "globe"
			})
		end
	})

	local function v798()
		v495()
		v433()
		v98({
			Title = "Debug",
			Content = "Atualizado",
			Duration = 3,
			Icon = "check"
		})
	end

	v89(v788, { "Section", "AddSection", "CreateSection" }, {
		Title = "Debug"
	})

	local t26 = {
		Title = "Atualizar Sistema",
		Desc = "Re-escaneia os botoes e limpa predicoes.",
		Icon = "lucide:refresh-cw",
		Callback = v798
	}

	local function v800()
		local v801 = v456()
		local value43

		if v801 then
			value43 = t2.value43
		else
			value43 = v801
		end

		if value43 then
			local v803 = (v801.Position - t2.value43.Position).Magnitude * 10
			local v804 = math.floor(v803) / 10

			v98({
				Title = "Bola Detectada",
				Content = "Bola: " .. v801.Name .. " (" .. v804 .. " studs)",
				Duration = 4,
				Icon = "check"
			})
		else
			v98({
				Title = "Detectar Bola",
				Content = "Aguardando surgimento da bola...",
				Duration = 3,
				Icon = "info"
			})
		end
	end

	v89(v788, { "Button", "AddButton", "CreateButton" }, t26)
	v89(v788, { "Button", "AddButton", "CreateButton" }, {
		Title = "Detectar Bola",
		Desc = "Mostra a distância atual da bola.",
		Icon = "lucide:crosshair",
		Callback = v800
	})
	v89(v788, { "Toggle", "AddToggle", "CreateToggle" }, {
		Title = "Desativar Notificações",
		Desc = "Desativa todas as notificações flutuantes do script.",
		Value = t2.value21.DisableNotify,
		Callback = function(p99)
			t2.value21.DisableNotify = p99 and true or false
			t2.value63()
		end
	})
	t2.value51(92)

	local v805 = v89(t2.value103, { "Tab", "AddTab", "CreateTab" }, {
		Title = "Creditos",
		Icon = "lucide:heart",
		IconShape = "Square",
		Border = true
	})

	local function v806()
		local ok

		if setclipboard then
			ok = pcall(setclipboard, "discord.gg/fTKM4ubCw")
		else
			ok = false
		end

		v98({
			Title = "Discord",
			Content = ok and "Link copiado!" or "discord.gg/fTKM4ubCw",
			Duration = 3,
			Icon = ok and "check" or "info"
		})
	end

	v89(v805, { "Section", "AddSection", "CreateSection" }, {
		Title = "Informacoes"
	})
	v89(v805, { "Paragraph", "AddParagraph", "CreateParagraph" }, {
		Title = "NAPOLEON HUB v3.3",
		Desc = "Feito por: equipe unk\nDiscord: discord.gg/fTKM4ubCw\n\nNovidades v3.3: Auto Dive Ultra Rápido (Reação sem caminhada necessária)."
	})
	v89(v805, { "Button", "AddButton", "CreateButton" }, {
		Title = "Copiar link do Discord",
		Desc = "Copia o convite para a area de transferencia",
		Icon = "lucide:copy",
		Callback = v806
	})
	v89(v805, { "Section", "AddSection", "CreateSection" }, {
		Title = "Agradecimentos"
	})
	v89(v805, { "Paragraph", "AddParagraph", "CreateParagraph" }, {
		Title = "Equipe",
		Desc = "unk"
	})

	local function v808()
		if t2.value105 then
			return
		end

		t2.value105 = true
		t2.value104 = true

		if t2.value106 then
			t2.value106:Disconnect()
			t2.value106 = nil
		end

		local value21 = t2.value21
		local value212 = t2.value21

		t2.value21.AutoDive = false
		value21.AutoCatch = false
		value212.AutoPos = false
		pcall(v624)

		local function v811()
			if not delfile then
				return
			end

			local isfile_ = isfile

			if isfile_ then
				isfile_ = isfile(t2.value53)
			end

			if isfile_ then
				delfile(t2.value53)
			end

			local isfile_2 = isfile

			if isfile_2 then
				isfile_2 = isfile(t2.value54)
			end

			if not isfile_2 then
				return
			end

			delfile(t2.value54)
		end

		pcall(v811)
		task.spawn(function()
			if not t2.value103 then
				task.wait(0.5)
				t2.value102()

				return
			end

			pcall(function()
				t2.value103:Destroy()
			end)
			t2.value103 = nil
			task.wait(0.5)
			t2.value102()
		end)
	end
	local function v814()
		v98({
			Title = "NAPOLEON HUB v3.3",
			Content = "Auto Dive Ultra Rápido ativado! Deixe o Intervalo em 0.",
			Duration = 6,
			Icon = "crown"
		})
	end

	local n9 = 0

	v672[1] = task.spawn(function()
		while true do
			local v816 = t2.value4()

			if v816 then
				v816 = not t2.value104
			end

			if not v816 then
				return
			end

			task.wait(1)

			if t2.value104 or not t2.value4() then
				return
			end

			local v817 = t2.value59()

			if v817 <= 0 then
				v808()

				return
			end

			local format = string.format
			local Mode = t2.value21.Mode
			local v820 = t2.value21.AutoDive and "Ligado" or "Desligado"
			local v821 = t2.value21.AutoCatch and "Ligado" or "Desligado"
			local v822 = math.floor(v817)
			local v823 = v822 / 3600
			local v824 = math.floor(v823)
			local v825 = v822 % 3600 / 60
			local v826 = math.floor(v825)
			local v829 = v822 % 60
			local v830 = string.format("%02d:%02d:%02d", v824, v826, v829)
			local value18 = t2.value18
			local v831 = math.floor(value18)
			local ok, result = pcall(function()
				local value = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()

				return math.floor(value)
			end)

			v97(v702, "Sistema", (format("Modo: %s\nAuto Dive: %s\nAuto Catch: %s\nKey: %s\nFPS: %d | Ping: %d ms", Mode, v820, v821, v830, v831, ok and result and result or 0)))
			n9 = n9 + 1

			if n9 % 2 == 0 then
				local function v834()
					local v835 = v456()
					local s4 = "Nenhuma bola detectada."
					local value43

					if v835 then
						value43 = t2.value43
					else
						value43 = v835
					end

					if not value43 then
						v97(v703, "Bola", s4)

						return
					end

					local format2 = string.format
					local Magnitude = (v835.Position - t2.value43.Position).Magnitude
					local v840 = math.floor(Magnitude)
					local Magnitude2 = v835.AssemblyLinearVelocity.Magnitude

					s4 = format2("Detectada a %d studs\nVelocidade: %d", v840, (math.floor(Magnitude2)))
					v97(v703, "Bola", s4)
				end

				pcall(v834)
			end
		end
	end)
	t2.value15.CharacterAdded:Connect(function()
		task.wait(1)
		t2.value91 = nil
		t2.value92 = nil
		t2.value93 = nil
		v495()
		v433()
	end)
	t2.value51(100)
	task.delay(1.2, v814)
end

t1.value1.NapoleonLoadHub = t1.value36

function t1.value36()
	_G.NapoleonRunId = nil
	t2.value104 = true
	t2.value101 = false

	if t2.value106 then
		local function v842()
			t2.value106:Disconnect()
		end

		pcall(v842)
		t2.value106 = nil
	end

	pcall(v624)

	local function v843()
		if not t2.value47 then
			return
		end

		t2.value47:Disconnect()
		t2.value47 = nil
	end

	pcall(v843)

	local function v844()
		if not t2.value45 then
			return
		end

		t2.value45:Destroy()
		t2.value45 = nil
	end

	pcall(v844)
	pcall(v250)

	local function v845()
		t2.value80:Destroy()
	end

	pcall(v845)
	pcall(v44)
	pcall(v415)

	local function v846()
		if not t2.value95.Sphere then
			return
		end

		t2.value95.Sphere:Destroy()
	end

	pcall(v846)
	pcall(function()
		local value12 = t2.value12
		local v848 = value12.FindFirstChild(value12, "NapoleonLoadBlur")

		if not v848 then
			return
		end

		v848:Destroy()
	end)

	if not t2.value39 then
		return
	end

	pcall(task.cancel, t2.value39)
	t2.value39 = nil
end

t1.value1 = _G
t1.value1.NapoleonCleanup = t1.value36
t1.value1 = handlers[32]()

if not t1.value1 then
	t2.value102()

	return
end

t2.value52()
task.wait(0.5)

function t1.value36()
	_G.NapoleonLoadHub()
end

pcall(t1.value36)
task.wait(0.4)
v371()
