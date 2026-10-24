-- This file was generated at discord.gg/syncrypt

local s1 = "WhiteLotus/SellTheFries/access.json"
local getgenv_ = getgenv

if getgenv_ then
	getgenv_ = getgenv()
end

local _G_ = getgenv_ or _G

if _G_.WhiteLotusSellTheFriesAccess then
	warn("[SellTheFries] Access check already running")

	return
end

_G_.WhiteLotusSellTheFriesAccess = true

local function v4(p1)
	_G_.WhiteLotusSellTheFriesAccess = nil
	warn("[SellTheFries] " .. tostring(p1))
end

local value = rawget(_G_, "syn")

if not value then
	local _G_2 = _G

	value = rawget(_G_2, "syn")
end

local value2 = rawget(_G_, "http")

if not value2 then
	local _G_2 = _G

	value2 = rawget(_G_2, "http")
end

local value3 = rawget(_G_, "fluxus")

if not value3 then
	local _G_2 = _G

	value3 = rawget(_G_2, "fluxus")
end

local v11 = nil
local v12 = nil
local ipairs_ = ipairs
local s2 = "request"
local value4 = rawget(_G_, "request")

if not value4 then
	local _G_2 = _G

	value4 = rawget(_G_2, "request")
end

local t1 = { s2, value4 }
local s3 = "http_request"
local value5 = rawget(_G_, "http_request")

if not value5 then
	local _G_2 = _G

	value5 = rawget(_G_2, "http_request")
end

local t2 = { s3, value5 }
local s4 = "syn.request"
local request

if value then
	request = value.request
else
	request = value
end

local t3 = { s4, request }

if value2 then
	value2 = value2.request
end

local t4 = { "http.request", value2 }

if value3 then
	value3 = value3.request
end

local v26, v27, v28 = ipairs_({
	t1,
	t2,
	t3,
	t4,
	{ "fluxus.request", value3 }
})

while true do
	local v29

	v28, v29 = v26(v27, v28)

	if not v28 then
		break
	end

	local v30 = v29[2]

	if type(v30) == "function" then
		v12 = v29[1]
		v11 = v29[2]

		break
	end
end

if type(v11) ~= "function" then
	v4("Your executor does not support HTTP requests")

	return
end

local loadstring_ = loadstring

if type(loadstring_) ~= "function" then
	v4("Your executor does not support loadstring")

	return
end

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local value6 = rawget(_G_, "setclipboard")

if not value6 then
	local _G_2 = _G

	value6 = rawget(_G_2, "setclipboard") or rawget(_G_, "toclipboard")
end

local readfile_ = readfile
local v38 = type(readfile_) == "function"

if v38 then
	local writefile_ = writefile

	v38 = type(writefile_) == "function"

	if v38 then
		local makefolder_ = makefolder

		v38 = type(makefolder_) == "function"
	end
end

local function v41(p2)
	local ok, result = pcall(HttpService.JSONDecode, HttpService, p2)

	return ok and result and result or nil
end
local function v44(p3)
	local v45 = value6
	local ok

	if type(v45) == "function" then
		ok = pcall(value6, p3)
	else
		ok = false
	end

	return ok
end
local function v47(p4)
	local ok, result = pcall(HttpService.JSONEncode, HttpService, p4)

	return ok and result and result or nil
end
local function v50(p5)
	if not v38 then
		return
	end

	pcall(makefolder, "WhiteLotus")
	pcall(makefolder, "WhiteLotus/SellTheFries")

	local v51 = v47({
		key = p5
	})

	if not v51 then
		return
	end

	pcall(writefile, s1, v51)
end

local v52 = (function()
	local s5 = "Unknown"
	local s6 = ""
	local v55 = _G_
	local value7 = rawget(v55, "identifyexecutor")

	if not value7 then
		local _G_2 = _G

		value7 = rawget(_G_2, "identifyexecutor")

		if not value7 then
			local v58 = _G_

			value7 = rawget(v58, "getexecutorname")

			if not value7 then
				local _G_3 = _G

				value7 = rawget(_G_3, "getexecutorname")
			end
		end
	end

	local result, result2

	if type(value7) == "function" then
		local pcall_ = pcall
		local ok

		ok, result, result2 = pcall_(value7)

		if ok then
			local v64

			if type(result) == "string" then
				v64 = result ~= ""
			else
				v64 = false
			end

			if v64 then
				s5 = result
			else
				result = pcall_
			end

			if type(result2) ~= "string" then
				result2 = s6
			end
		else
			result2 = s6
			result = pcall_
		end
	else
		result2 = s6
		result = result2

		local v65 = result2

		result2 = result
		v65 = result
	end

	local function v66()
		return UserInputService:GetPlatform()
	end

	local t5 = { pcall(v66) }
	local v68 = t5[2]
	local match = not t5[1] and "Unknown" or (tostring(v68):match("%.([%w_]+)$") or tostring(v68))
	local s7 = ""
	local v71 = false
	local value8 = rawget(_G_, "gethwid")
	local ok, result3

	if value8 then
		if type(value8) == "function" then
			ok, result3 = pcall(value8)

			if ok then
				ok = type(result3) == "string"

				if ok then
					if #result3 >= 8 then
						ok = #result3 <= 512
					else
						ok = false
					end
				end
			end

			if ok then
				v71 = true
			else
				result3 = s7
			end
		else
			result3 = s7
		end

		v80 = s5:sub(1, 64)
		v81 = result2:sub(1, 64)
		v82 = match:sub(1, 32)
		v83 = v12
		v84 = v38
		v85 = value6
		v86 = type(v85) == "function"
		v87 = gethui

		return {
			executor = v80,
			version = v81,
			platform = v82,
			adapter = v83,
			hwid = v71,
			fingerprint = result3,
			files = v84,
			clipboard = v86,
			ui = type(v87) == "function"
		}
	end

	local _G_2 = _G

	value8 = rawget(_G_2, "gethwid")

	if type(value8) == "function" then
		ok, result3 = pcall(value8)

		if ok then
			ok = type(result3) == "string"

			if ok then
				if #result3 >= 8 then
					ok = #result3 <= 512
				else
					ok = false
				end
			end
		end

		if ok then
			v71 = true
		else
			result3 = s7
		end
	else
		result3 = s7
	end

	local v76 = s5:sub(1, 64)
	local v77 = result2:sub(1, 64)
	local v78 = match:sub(1, 32)
	local v79 = v12
	local v88 = v38
	local v89 = value6
	local v90 = type(v89) == "function"
	local gethui_ = gethui

	return {
		executor = v76,
		version = v77,
		platform = v78,
		adapter = v79,
		hwid = v71,
		fingerprint = result3,
		files = v88,
		clipboard = v90,
		ui = type(gethui_) == "function"
	}
end)()
local v91 = nil

local function v92(p6)
	local v93 = v91
	local s8 = "key"
	local v94, v97

	if type(p6) == "string" then
		v95, v96 = v93("/api/sellthefries/access", {
			[s8] = p6 or nil,
			capability = v52
		})

		if v95 then
			if v95 >= 200 then
				v94 = v95 < 300
			else
				v94 = false
			end

			if v94 then
				if v96 == "" then
					return nil, "Empty payload response"
				else
					return v96
				end
			else
				v97 = v41(v96)

				return nil, type(v97) == "table" and v97.error or "HTTP " .. v95
			end
		else
			return nil, v96
		end
	end

	p6 = false

	local v98, v99 = v93("/api/sellthefries/access", {
		[s8] = p6 or nil,
		capability = v52
	})

	if v98 then
		if v98 >= 200 then
			v94 = v98 < 300
		else
			v94 = false
		end

		if v94 then
			if v99 == "" then
				return nil, "Empty payload response"
			else
				return v99
			end
		else
			v97 = v41(v99)

			return nil, type(v97) == "table" and v97.error or "HTTP " .. v98
		end
	else
		return nil, v99
	end
end

v91 = function(p7, p8)
	local v100 = v47(p8)

	if v100 then
		local ok, result = pcall(v11, {
			Url = "https://access.valkorym.com" .. p7,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			},
			Body = v100
		})

		if not ok or type(result) ~= "table" then
			return nil, "Network request failed"
		else
			local v101 = tonumber(result.StatusCode or (result.Status or (result.status_code or result.status)))

			if v101 then
				return v101, result.Body or (result.body or "")
			else
				return nil, "Invalid executor response"
			end
		end
	else
		return nil, "Unable to encode request"
	end
end

local function v102(p9, p10)
	local v103, v104 = v91(p9, p10)

	if v103 then
		local v105 = v41(v104)

		if v103 < 200 and true or v103 >= 300 then
			return nil, type(v105) == "table" and v105.error or "HTTP " .. v103
		elseif type(v105) == "table" then
			return v105
		else
			return nil, "Invalid server response"
		end
	else
		return nil, v104
	end
end
local function v106()
	local t6 = {}
	local BindableEvent = Instance.new("BindableEvent")
	local v107 = false
	local u108 = false
	local text = ""
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "WhiteLotusAccess"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local v109 = CoreGui
	local gethui_ = gethui
	local parent

	if type(gethui_) == "function" then
		local ok

		ok, parent = pcall(gethui)

		if ok then
			ok = typeof(parent) == "Instance"
		end

		if not ok then
			parent = v109
		end
	else
		parent = v109
	end

	local protectgui_ = protectgui

	if type(protectgui_) == "function" then
		pcall(protectgui, ScreenGui)
	else
		local v112 = value

		if v112 then
			local protect_gui = value.protect_gui

			v112 = type(protect_gui) == "function"
		end

		if v112 then
			pcall(value.protect_gui, ScreenGui)
		end
	end

	ScreenGui.Parent = parent

	local color3 = Color3.fromRGB(18, 16, 22)
	local color32 = Color3.fromRGB(26, 23, 31)
	local color33 = Color3.fromRGB(26, 23, 30)
	local color34 = Color3.fromRGB(40, 35, 45)
	local color35 = Color3.fromRGB(55, 48, 61)
	local color36 = Color3.fromRGB(121, 80, 162)
	local color37 = Color3.fromRGB(165, 108, 216)
	local color38 = Color3.fromRGB(246, 243, 250)
	local color39 = Color3.fromRGB(148, 139, 157)
	local color310 = Color3.fromRGB(113, 105, 120)
	local font = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Regular)
	local font2 = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium)
	local font3 = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold)
	local font4 = Font.new("rbxasset://fonts/families/RobotoMono.json", Enum.FontWeight.Regular)
	local image = "rbxassetid://92583561076971"
	local Frame = Instance.new("Frame")

	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.Position = UDim2.fromScale(0.5, 0.5)
	Frame.Size = UDim2.fromOffset(430, 480)
	Frame.BackgroundColor3 = color3
	Frame.BorderSizePixel = 0
	Frame.ClipsDescendants = true
	Frame.Parent = ScreenGui
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 11)

	local UIScale = Instance.new("UIScale", Frame)
	local CurrentCamera = workspace.CurrentCamera
	local v132 = nil

	local function v133()
		if not CurrentCamera then
			return
		end

		local ViewportSize = CurrentCamera.ViewportSize
		local v135

		if ViewportSize.X >= ViewportSize.Y then
			v135 = ViewportSize.Y < 520
		else
			v135 = false
		end

		local v136 = v135 and 560 or (ViewportSize.X < 460 and 390 or 430)
		local v137 = v135 and 340 or 480

		Frame.Size = UDim2.fromOffset(v136, v137)

		local v138 = UIScale
		local v139 = (ViewportSize.X - 28) / v136
		local v140 = (ViewportSize.Y - 28) / v137
		local v141 = math.min(v139, v140)

		v138.Scale = math.clamp(v141, 0.45, 1)

		if not v132 then
			return
		end

		v132(v135)
	end

	v133()

	if CurrentCamera then
		local signal = CurrentCamera:GetPropertyChangedSignal("ViewportSize")

		table.insert(t6, signal:Connect(v133))
	end

	local UIStroke = Instance.new("UIStroke", Frame)

	UIStroke.Color = color35
	UIStroke.Transparency = 0

	local function v144(p11, p12, p13)
		Instance.new("UICorner", p11).CornerRadius = UDim.new(0, p12)

		if not p13 then
			return
		end

		local UIStroke2 = Instance.new("UIStroke", p11)

		UIStroke2.Color = p13
		UIStroke2.Transparency = 0
	end
	local function v146(p14, p15)
		local UIPadding = Instance.new("UIPadding", p14)

		UIPadding.PaddingLeft = UDim.new(0, p15)
		UIPadding.PaddingRight = UDim.new(0, p15)
	end
	local function v148(p16, p17, p18, p19, p20)
		local instance = Instance.new(p16)

		instance.Position = p18
		instance.Size = p19
		instance.BackgroundTransparency = p16 == "TextLabel" and 1 or 0
		instance.BackgroundColor3 = color34
		instance.BorderSizePixel = 0
		instance.FontFace = font
		instance.Text = p17
		instance.TextSize = 14
		instance.TextColor3 = p20 or color38
		instance.Parent = Frame

		if p16 ~= "TextLabel" then
			v144(instance, 7, color35)
		end

		if p16 ~= "TextButton" then
			return instance
		end

		instance.AutoButtonColor = false

		return instance
	end

	local Frame2 = Instance.new("Frame")

	Frame2.Name = "Header"
	Frame2.Size = UDim2.new(1, 0, 0, 60)
	Frame2.BackgroundColor3 = color32
	Frame2.BorderSizePixel = 0
	Frame2.Parent = Frame
	v144(Frame2, 10)

	local Frame3 = Instance.new("Frame")

	Frame3.Name = "SquareBottom"
	Frame3.Size = UDim2.new(1, 0, 0, 10)
	Frame3.Position = UDim2.new(0, 0, 1, -10)
	Frame3.BackgroundColor3 = color32
	Frame3.BorderSizePixel = 0
	Frame3.Parent = Frame2

	local Frame4 = Instance.new("Frame")

	Frame4.Size = UDim2.new(1, 0, 0, 1)
	Frame4.Position = UDim2.new(0, 0, 1, -1)
	Frame4.BackgroundColor3 = color35
	Frame4.BorderSizePixel = 0
	Frame4.Parent = Frame2

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Name = "LotusImage"
	ImageLabel.Size = UDim2.fromOffset(32, 32)
	ImageLabel.Position = UDim2.fromOffset(14, 14)
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Image = image
	ImageLabel.ImageRectOffset = Vector2.new(165, 270)
	ImageLabel.ImageRectSize = Vector2.new(694, 484)
	ImageLabel.ScaleType = Enum.ScaleType.Fit
	ImageLabel.Parent = Frame2

	local TextLabel = v148("TextLabel", "WhiteLotus", UDim2.fromOffset(54, 8), UDim2.fromOffset(190, 20))

	TextLabel.Parent = Frame2
	TextLabel.FontFace = font3
	TextLabel.TextSize = 16
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom

	local TextLabel2 = v148("TextLabel", "SELL THE FRIES", UDim2.fromOffset(54, 30), UDim2.fromOffset(190, 18), color39)

	TextLabel2.Parent = Frame2
	TextLabel2.FontFace = font2
	TextLabel2.TextSize = 11
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.TextYAlignment = Enum.TextYAlignment.Top

	local TextButton = v148("TextButton", "×", UDim2.new(1, -48, 0, 14), UDim2.fromOffset(34, 34), Color3.fromRGB(255, 196, 212))

	TextButton.Parent = Frame2
	TextButton.BackgroundColor3 = Color3.fromRGB(70, 31, 46)
	TextButton.TextSize = 21
	TextButton.FontFace = font2

	local UIStroke2 = TextButton:FindFirstChildWhichIsA("UIStroke")

	if UIStroke2 then
		UIStroke2.Color = Color3.fromRGB(111, 51, 70)
	end

	local TextLabel3 = v148("TextLabel", "ACCESS", UDim2.fromOffset(20, 76), UDim2.new(1, -40, 0, 14), color37)

	TextLabel3.FontFace = font3
	TextLabel3.TextSize = 11
	TextLabel3.TextXAlignment = Enum.TextXAlignment.Left

	local TextLabel4 = v148("TextLabel", "Start Sell The Fries", UDim2.fromOffset(20, 94), UDim2.new(1, -40, 0, 28))

	TextLabel4.FontFace = font3
	TextLabel4.TextSize = 20
	TextLabel4.TextXAlignment = Enum.TextXAlignment.Left

	local TextLabel5 = v148("TextLabel", "Use your access key to open WhiteLotus.", UDim2.fromOffset(20, 122), UDim2.new(1, -40, 0, 20), color39)

	TextLabel5.TextSize = 14
	TextLabel5.TextWrapped = true
	TextLabel5.TextXAlignment = Enum.TextXAlignment.Left

	local Frame5 = Instance.new("Frame")

	Frame5.Position = UDim2.fromOffset(20, 153)
	Frame5.Size = UDim2.new(1, -40, 0, 50)
	Frame5.BackgroundColor3 = color33
	Frame5.BorderSizePixel = 0
	Frame5.Parent = Frame
	v144(Frame5, 8, color35)

	local Frame6 = Instance.new("Frame")

	Frame6.Size = UDim2.fromOffset(3, 24)
	Frame6.Position = UDim2.new(0, 12, 0.5, -12)
	Frame6.BackgroundColor3 = color36
	Frame6.BorderSizePixel = 0
	Frame6.Parent = Frame5
	v144(Frame6, 2)

	local TextLabel6 = v148("TextLabel", "Enter your key below, or create a link if you need one.", UDim2.fromOffset(26, 5), UDim2.new(1, -38, 1, -10), color39)

	TextLabel6.Parent = Frame5
	TextLabel6.TextSize = 13
	TextLabel6.TextWrapped = true
	TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel6.TextYAlignment = Enum.TextYAlignment.Center

	local TextLabel7 = v148("TextLabel", "ENTER YOUR KEY", UDim2.fromOffset(20, 220), UDim2.new(1, -40, 0, 14), color310)

	TextLabel7.FontFace = font3
	TextLabel7.TextSize = 11
	TextLabel7.TextXAlignment = Enum.TextXAlignment.Left

	local Frame7 = Instance.new("Frame")

	Frame7.Position = UDim2.fromOffset(126, 227)
	Frame7.Size = UDim2.new(1, -146, 0, 1)
	Frame7.BackgroundColor3 = color35
	Frame7.BorderSizePixel = 0
	Frame7.Parent = Frame

	local TextBox = v148("TextBox", "", UDim2.fromOffset(20, 240), UDim2.new(1, -40, 0, 42))

	TextBox.PlaceholderText = "WL-XXXXX-XXXXX-XXXXX-XXXXX"
	TextBox.PlaceholderColor3 = color310
	TextBox.ClearTextOnFocus = false
	TextBox.FontFace = font4
	TextBox.TextSize = 13
	TextBox.TextXAlignment = Enum.TextXAlignment.Left
	v146(TextBox, 12)

	local function v167(p21, p22, p23, p24)
		local TextButton2 = v148("TextButton", p21, p22, p23)
		local s9 = "BackgroundColor3"
		local v170

		if p24 then
			v170 = color36
		else
			v170 = p24
		end

		TextButton2[s9] = v170 or color34
		TextButton2.FontFace = font2
		TextButton2.TextSize = 14

		local UIStroke3 = TextButton2:FindFirstChildWhichIsA("UIStroke")

		if not (p24 and UIStroke3) then
			return TextButton2
		end

		UIStroke3.Color = color37

		return TextButton2
	end

	local openSellTheFries = v167("Open Sell The Fries", UDim2.fromOffset(20, 292), UDim2.new(1, -40, 0, 42), true)
	local TextLabel8 = v148("TextLabel", "NEED A KEY?", UDim2.fromOffset(20, 351), UDim2.new(1, -40, 0, 14), color310)

	TextLabel8.FontFace = font3
	TextLabel8.TextSize = 11
	TextLabel8.TextXAlignment = Enum.TextXAlignment.Left

	local Frame8 = Instance.new("Frame")

	Frame8.Position = UDim2.fromOffset(108, 358)
	Frame8.Size = UDim2.new(1, -128, 0, 1)
	Frame8.BackgroundColor3 = color35
	Frame8.BorderSizePixel = 0
	Frame8.Parent = Frame

	local TextBox2 = v148("TextBox", "", UDim2.fromOffset(20, 371), UDim2.new(1, -40, 0, 38))

	TextBox2.PlaceholderText = "Your access link will appear here"
	TextBox2.PlaceholderColor3 = color310
	TextBox2.ClearTextOnFocus = false
	TextBox2.TextSize = 12
	TextBox2.TextXAlignment = Enum.TextXAlignment.Left
	TextBox2.TextTruncate = Enum.TextTruncate.AtEnd
	v146(TextBox2, 12)

	local function v176(p25)
		local v177 = p25.FindFirstChildWhichIsA(p25, "UIStroke")

		if not v177 then
			return
		end

		local v178 = t6
		local Focused = p25.Focused

		local function v180()
			v177.Color = color37
		end

		table.insert(v178, Focused:Connect(v180))

		local function v181()
			v177.Color = color35
		end

		table.insert(t6, p25.FocusLost:Connect(v181))
	end

	v176(TextBox)
	v176(TextBox2)

	local createAccessLink = v167("Create access link", UDim2.fromOffset(20, 419), UDim2.new(0.62, -25, 0, 40), false)
	local copyLink = v167("Copy link", UDim2.new(0.62, 5, 0, 419), UDim2.new(0.38, -25, 0, 40), false)
	local TextLabel9 = v148("TextLabel", "Access lasts 12 hours", UDim2.fromOffset(20, 462), UDim2.new(1, -40, 0, 14), color310)

	TextLabel9.TextSize = 11
	TextLabel9.TextXAlignment = Enum.TextXAlignment.Center

	local function v185(p26)
		if v107 then
			return
		end

		BindableEvent:Fire(p26)
	end

	v132 = function(p27)
		if p27 then
			local v186 = TextLabel3
			local v187 = TextLabel3
			local uDim2 = UDim2.fromOffset(20, 76)
			local uDim22 = UDim2.fromOffset(250, 14)

			v186.Position = uDim2
			v187.Size = uDim22

			local v190 = TextLabel4
			local v191 = TextLabel4
			local uDim23 = UDim2.fromOffset(20, 94)
			local uDim24 = UDim2.fromOffset(250, 28)

			v190.Position = uDim23
			v191.Size = uDim24

			local v194 = TextLabel5
			local v195 = TextLabel5
			local uDim25 = UDim2.fromOffset(20, 122)
			local uDim26 = UDim2.fromOffset(250, 36)

			v194.Position = uDim25
			v195.Size = uDim26

			local v198 = Frame5
			local v199 = Frame5
			local uDim27 = UDim2.fromOffset(20, 166)
			local uDim28 = UDim2.fromOffset(250, 68)

			v198.Position = uDim27
			v199.Size = uDim28
			TextLabel6.Size = UDim2.new(1, -38, 1, -10)

			local v202 = TextLabel9
			local v203 = TextLabel9
			local uDim29 = UDim2.fromOffset(20, 246)
			local uDim210 = UDim2.fromOffset(250, 14)

			v202.Position = uDim29
			v203.Size = uDim210

			local v206 = TextLabel7
			local v207 = TextLabel7
			local uDim211 = UDim2.fromOffset(290, 78)
			local uDim212 = UDim2.fromOffset(250, 14)

			v206.Position = uDim211
			v207.Size = uDim212

			local v210 = Frame7
			local v211 = Frame7
			local uDim213 = UDim2.fromOffset(398, 85)
			local uDim214 = UDim2.fromOffset(142, 1)

			v210.Position = uDim213
			v211.Size = uDim214

			local v214 = TextBox
			local v215 = TextBox
			local uDim215 = UDim2.fromOffset(290, 98)
			local uDim216 = UDim2.fromOffset(250, 42)

			v214.Position = uDim215
			v215.Size = uDim216

			local v218 = openSellTheFries
			local v219 = openSellTheFries
			local uDim217 = UDim2.fromOffset(290, 150)
			local uDim218 = UDim2.fromOffset(250, 42)

			v218.Position = uDim217
			v219.Size = uDim218

			local v222 = TextLabel8
			local v223 = TextLabel8
			local uDim219 = UDim2.fromOffset(290, 214)
			local uDim220 = UDim2.fromOffset(250, 14)

			v222.Position = uDim219
			v223.Size = uDim220

			local v226 = Frame8
			local v227 = Frame8
			local uDim221 = UDim2.fromOffset(378, 221)
			local uDim222 = UDim2.fromOffset(162, 1)

			v226.Position = uDim221
			v227.Size = uDim222

			local v230 = TextBox2
			local v231 = TextBox2
			local uDim223 = UDim2.fromOffset(290, 234)
			local uDim224 = UDim2.fromOffset(250, 38)

			v230.Position = uDim223
			v231.Size = uDim224

			local v234 = createAccessLink
			local v235 = createAccessLink
			local uDim225 = UDim2.fromOffset(290, 282)
			local uDim226 = UDim2.fromOffset(152, 40)

			v234.Position = uDim225
			v235.Size = uDim226

			local v238 = copyLink
			local v239 = copyLink
			local uDim227 = UDim2.fromOffset(450, 282)
			local uDim228 = UDim2.fromOffset(90, 40)

			v238.Position = uDim227
			v239.Size = uDim228
		else
			local v242 = TextLabel3
			local v243 = TextLabel3
			local uDim2 = UDim2.fromOffset(20, 76)
			local uDim22 = UDim2.new(1, -40, 0, 14)

			v242.Position = uDim2
			v243.Size = uDim22

			local v246 = TextLabel4
			local v247 = TextLabel4
			local uDim23 = UDim2.fromOffset(20, 94)
			local uDim24 = UDim2.new(1, -40, 0, 28)

			v246.Position = uDim23
			v247.Size = uDim24

			local v250 = TextLabel5
			local v251 = TextLabel5
			local uDim25 = UDim2.fromOffset(20, 122)
			local uDim26 = UDim2.new(1, -40, 0, 20)

			v250.Position = uDim25
			v251.Size = uDim26

			local v254 = Frame5
			local v255 = Frame5
			local uDim27 = UDim2.fromOffset(20, 153)
			local uDim28 = UDim2.new(1, -40, 0, 50)

			v254.Position = uDim27
			v255.Size = uDim28
			TextLabel6.Size = UDim2.new(1, -38, 1, -10)

			local v258 = TextLabel9
			local v259 = TextLabel9
			local uDim29 = UDim2.fromOffset(20, 462)
			local uDim210 = UDim2.new(1, -40, 0, 14)

			v258.Position = uDim29
			v259.Size = uDim210

			local v262 = TextLabel7
			local v263 = TextLabel7
			local uDim211 = UDim2.fromOffset(20, 220)
			local uDim212 = UDim2.new(1, -40, 0, 14)

			v262.Position = uDim211
			v263.Size = uDim212

			local v266 = Frame7
			local v267 = Frame7
			local uDim213 = UDim2.fromOffset(126, 227)
			local uDim214 = UDim2.new(1, -146, 0, 1)

			v266.Position = uDim213
			v267.Size = uDim214

			local v270 = TextBox
			local v271 = TextBox
			local uDim215 = UDim2.fromOffset(20, 240)
			local uDim216 = UDim2.new(1, -40, 0, 42)

			v270.Position = uDim215
			v271.Size = uDim216

			local v274 = openSellTheFries
			local v275 = openSellTheFries
			local uDim217 = UDim2.fromOffset(20, 292)
			local uDim218 = UDim2.new(1, -40, 0, 42)

			v274.Position = uDim217
			v275.Size = uDim218

			local v278 = TextLabel8
			local v279 = TextLabel8
			local uDim219 = UDim2.fromOffset(20, 351)
			local uDim220 = UDim2.new(1, -40, 0, 14)

			v278.Position = uDim219
			v279.Size = uDim220

			local v282 = Frame8
			local v283 = Frame8
			local uDim221 = UDim2.fromOffset(108, 358)
			local uDim222 = UDim2.new(1, -128, 0, 1)

			v282.Position = uDim221
			v283.Size = uDim222

			local v286 = TextBox2
			local v287 = TextBox2
			local uDim223 = UDim2.fromOffset(20, 371)
			local uDim224 = UDim2.new(1, -40, 0, 38)

			v286.Position = uDim223
			v287.Size = uDim224

			local v290 = createAccessLink
			local v291 = createAccessLink
			local uDim225 = UDim2.fromOffset(20, 419)
			local uDim226 = UDim2.new(0.62, -25, 0, 40)

			v290.Position = uDim225
			v291.Size = uDim226

			local v294 = copyLink
			local v295 = copyLink
			local uDim227 = UDim2.new(0.62, 5, 0, 419)
			local uDim228 = UDim2.new(0.38, -25, 0, 40)

			v294.Position = uDim227
			v295.Size = uDim228
		end
	end
	v133()

	local t7 = {
		createAccessLink,
		copyLink,
		openSellTheFries,
		TextButton
	}

	local function v299(p28, p29)
		u108 = p28

		for _, v in ipairs(t7) do
			v.Active = not p28
			v.TextTransparency = p28 and 0.45 or 0
		end

		if not p29 then
			return
		end

		TextLabel6.Text = p29
	end

	table.insert(t6, TextButton.Activated:Connect(function()
		if u108 then
			return
		end

		v185(nil)
	end))
	table.insert(t6, createAccessLink.Activated:Connect(function()
		if u108 then
			return
		end

		v299(true, "Creating LootLabs session…")
		task.spawn(function()
			local v302, v303 = v102("/api/sellthefries/session", {
				capability = v52
			})
			local v304

			if v302 then
				local url = v302.url

				v304 = type(url) == "string"
			else
				v304 = v302
			end

			if v304 then
				text = v302.url
				TextBox2.Text = text
				TextLabel6.Text = v44(text) and "Link copied. Complete LootLabs to receive your key." or "Link ready. Copy it, then complete LootLabs."
			else
				TextLabel6.Text = "Unable to create a link: " .. (({
					key_required = "Enter your access key first.",
					invalid_key = "This key is not valid. Check it and try again.",
					expired_key = "This key has expired. Create a new access link."
				})[v303] or tostring(v303))
			end

			v299(false)
		end)
	end))
	table.insert(t6, copyLink.Activated:Connect(function()
		if u108 then
		elseif text == "" then
			TextLabel6.Text = "Create a key link first."

			return
		elseif v44(text) then
			TextLabel6.Text = "Link copied."

			return
		else
			TextBox2:CaptureFocus()
			TextLabel6.Text = "Select the visible link."

			return
		end
	end))
	table.insert(t6, openSellTheFries.Activated:Connect(function()
		if u108 then
			return
		end

		local match = TextBox.Text:upper():match("^%s*(.-)%s*$")

		if match == "" then
			TextLabel6.Text = "Paste your key first."

			return
		end

		v299(true, "Verifying key…")
		task.spawn(function()
			local v307, v308 = v92(match)

			TextBox.Text = ""

			if v307 then
				v50(match)
				v185(v307)
			else
				TextLabel6.Text = ({
					key_required = "Enter your access key first.",
					invalid_key = "This key is not valid. Check it and try again.",
					expired_key = "This key has expired. Create a new access link."
				})[v308] or tostring(v308)
				v299(false)
			end
		end)
	end))

	local u309 = false
	local u310 = nil
	local Position = nil
	local AbsolutePosition = nil

	local function v313(input)
		local UserInputType = input.UserInputType

		if not (UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u309 = true
		u310 = UserInputType == Enum.UserInputType.Touch and input and input or nil
		Position = input.Position
		AbsolutePosition = Frame.AbsolutePosition
	end

	table.insert(t6, Frame2.InputBegan:Connect(v313))
	table.insert(t6, UserInputService.InputChanged:Connect(function(input)
		local v315 = not u309

		if not v315 then
			v315 = u310

			if v315 then
				v315 = input ~= u310
			end
		end

		if v315 then
			return
		end

		local v316 = not u310

		if v316 then
			v316 = input.UserInputType ~= Enum.UserInputType.MouseMovement
		end

		if v316 then
			return
		end

		local v317 = AbsolutePosition + (input.Position - Position)
		local ViewportSize = CurrentCamera

		if not ViewportSize then
			v348 = ViewportSize or Vector2.new(1920, 1080)
			v349 = Frame.AbsoluteSize
			Frame.AnchorPoint = Vector2.zero
			v350 = Frame
			v351 = UDim2.fromOffset
			v352 = v317.X
			v353 = v348.X - v349.X
			v354 = math.max(0, v353)
			v355 = math.clamp(v352, 0, v354)
			v356 = v317.Y
			v357 = v348.Y - v349.Y
			v358 = math.max(0, v357)
			v350.Position = v351(v355, (math.clamp(v356, 0, v358)))

			return
		end

		ViewportSize = CurrentCamera.ViewportSize

		local vector2 = ViewportSize or Vector2.new(1920, 1080)
		local AbsoluteSize = Frame.AbsoluteSize

		Frame.AnchorPoint = Vector2.zero

		local v321 = Frame
		local uDim2 = UDim2.fromOffset
		local X = v317.X
		local v324 = vector2.X - AbsoluteSize.X
		local v325 = math.max(0, v324)
		local v326 = math.clamp(X, 0, v325)
		local Y = v317.Y
		local v328 = vector2.Y - AbsoluteSize.Y
		local v329 = math.max(0, v328)

		v321.Position = uDim2(v326, (math.clamp(Y, 0, v329)))
	end))
	table.insert(t6, UserInputService.InputEnded:Connect(function(input)
		local v330 = u310

		if v330 then
			v330 = input == u310
		end

		if v330 then
			return
		end

		v330 = not u310

		if not v330 then
			return
		end

		v330 = input.UserInputType == Enum.UserInputType.MouseButton1
	end))

	local result = BindableEvent.Event:Wait()

	for _, v in ipairs(t6) do
		v:Disconnect()
	end

	BindableEvent:Destroy()
	ScreenGui:Destroy()

	return result
end

print("[SellTheFries] Checking access")

local v334, v335 = v92((function()
	if not v38 then
		return nil
	end

	local ok, result = pcall(readfile, s1)
	local v338 = ok and v41(result) or nil
	local v339 = type(v338) == "table"

	if not v339 then
		return v339 or nil
	end

	local key = v338.key

	if type(key) == "string" then
		v339 = v338.key
	else
		v339 = false
	end

	return v339 or nil
end)())
local v341 = not v334

if v341 then
	v341 = v335 == "key_required" or (v335 == "invalid_key" and true or v335 == "expired_key")
end

if v341 then
	v50("")
	v334 = v106()
	v335 = nil
end

if not v334 then
	v4("Access check failed: " .. tostring(v335 or "window closed"))

	return
end

print("[SellTheFries] Starting Sell The Fries")

local chunk, v343 = loadstring(v334)

if not chunk then
	v4("Payload compilation failed: " .. tostring(v343))

	return
end

_G_.WhiteLotusSellTheFriesAccess = nil
print("[SellTheFries] Access granted")

local t8 = { pcall(chunk) }
local v345 = t8[2]

if t8[1] then
	return
end

warn("[SellTheFries] Payload error: " .. tostring(v345))
