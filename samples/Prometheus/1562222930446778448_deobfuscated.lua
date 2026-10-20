-- This file was generated at discord.gg/syncrypt

local s1 = "WhiteLotus/RoChess/access.json"
local getgenv_ = getgenv
if getgenv_ then
    getgenv_ = getgenv()
end
getgenv_ = getgenv_ or _G
if getgenv_.WhiteLotusRoChessAccess then
    warn("[RoChess] Access check already running")

    return
end
getgenv_.WhiteLotusRoChessAccess = true
local function v4(p1)
    getgenv_.WhiteLotusRoChessAccess = nil
    warn("[RoChess] " .. tostring(p1))
end
local value = rawget(getgenv_, "syn")
if not value then
    value = _G
    value = rawget(value, "syn")
end
local value2 = rawget(getgenv_, "http")
if not value2 then
    value2 = _G
    value2 = rawget(value2, "http")
end
local value3 = rawget(getgenv_, "fluxus")
if not value3 then
    value3 = _G
    value3 = rawget(value3, "fluxus")
end
local v8
local v9
local ipairs_ = ipairs
local s2 = "request"
local value4 = rawget(getgenv_, "request")
if not value4 then
    value4 = _G
    value4 = rawget(value4, "request")
end
s2 = { s2, value4 }
value4 = "http_request"
local value5 = rawget(getgenv_, "http_request")
if not value5 then
    value5 = _G
    value5 = rawget(value5, "http_request")
end
value4 = { value4, value5 }
value5 = "syn.request"
if value then
    v_u_25 = value.request
else
    v_u_25 = value
end
value5 = { value5, v_u_25 }
if value2 then
    value2 = value2.request
end
value2 = { "http.request", value2 }
if value3 then
    value3 = value3.request
end
value2, value3, ipairs_ = ipairs_({
	s2,
	value4,
	value5,
	value2,
	{ "fluxus.request", value3 }
})
while true do
    ipairs_, s2 = value2(value3, ipairs_)

    if not ipairs_ then
        break
    end

    value4 = s2[2]

    if type(value4) == "function" then
        v9 = s2[1]
        v8 = s2[2]

        break
    end
end
if type(v8) ~= "function" then
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
loadstring_ = game:GetService("HttpService")
value2 = game:GetService("UserInputService")
value3 = game:GetService("CoreGui")
ipairs_ = rawget(getgenv_, "setclipboard")
if not ipairs_ then
    ipairs_ = _G
    ipairs_ = rawget(ipairs_, "setclipboard") or rawget(getgenv_, "toclipboard")
end
s2 = readfile
s2 = type(s2) == "function"
if s2 then
    s2 = writefile
    s2 = type(s2) == "function"

    if s2 then
        s2 = makefolder
        s2 = type(s2) == "function"
    end
end
value4 = function(p2)
    local ok, result = pcall(loadstring_.JSONDecode, loadstring_, p2)

    return ok and result and result or nil
end
value5 = function(p3)
    local ok = ipairs_

    if type(ok) == "function" then
        ok = pcall(ipairs_, p3)
    else
        ok = false
    end

    return ok
end
loadstring_ = function(p4)
    local ok, result = pcall(loadstring_.JSONEncode, loadstring_, p4)

    return ok and result and result or nil
end
local function v19(p5)
    if not s2 then
        return
    end

    pcall(makefolder, "WhiteLotus")
    pcall(makefolder, "WhiteLotus/RoChess")

    local v20 = loadstring_({
		["key"] = p5
	})

    if not v20 then
        return
    end

    pcall(writefile, s1, v20)
end
v9 = (function()
    local s3 = "Unknown"
    local s4 = ""
    local value6 = getgenv_
    value6 = rawget(value6, "identifyexecutor")
    if not value6 then
        value6 = rawget(_G, "identifyexecutor")
        if not value6 then
            value6 = rawget(getgenv_, "getexecutorname")
            if not value6 then
                value6 = rawget(_G, "getexecutorname")
            end
        end
    end
    if type(value6) == "function" then
        v30 = pcall
        value6, v31, v33 = v30(value6)

        if value6 then
            if type(v31) == "string" then
                value6 = v31 ~= ""
            else
                value6 = false
            end

            if value6 then
                s3 = v31
            else
                v31 = v30
            end

            if type(v33) ~= "string" then
                v33 = s4
            end
        else
            v33 = s4
            v31 = v30
        end
    else
        v33 = s4
        v31 = v33

        local v33_ = v33

        v33 = v31
        v33_ = v31
    end
    s4 = function()
        return value2:GetPlatform()
    end
    s4 = { pcall(s4) }
    value6 = s4[2]
    s4 = not s4[1] and "Unknown" or (tostring(value6):match("%.([%w_]+)$") or tostring(value6))
    value6 = ""
    local v25 = false
    local value7 = rawget(getgenv_, "gethwid")
    local result
    if value7 then
        if type(value7) == "function" then
            value7, result = pcall(value7)

            if value7 then
                value7 = type(result) == "string"

                if value7 then
                    if #result >= 8 then
                        value7 = #result <= 512
                    else
                        value7 = false
                    end
                end
            end

            if value7 then
                v25 = true
            else
                result = value6
            end
        else
            result = value6
        end

        s3 = s3:sub(1, 64)
        value6 = v33:sub(1, 64)
        s4 = s4:sub(1, 32)
        value7 = v9
        v33 = s2
        v34 = ipairs_
        v34 = type(v34) == "function"
        v35 = gethui

        return {
			["executor"] = s3,
			["version"] = value6,
			["platform"] = s4,
			["adapter"] = value7,
			["hwid"] = v25,
			["fingerprint"] = result,
			["files"] = v33,
			["clipboard"] = v34,
			["ui"] = type(v35) == "function"
		}
    end
    value7 = _G
    value7 = rawget(value7, "gethwid")
    if type(value7) == "function" then
        value7, result = pcall(value7)

        if value7 then
            value7 = type(result) == "string"

            if value7 then
                if #result >= 8 then
                    value7 = #result <= 512
                else
                    value7 = false
                end
            end
        end

        if value7 then
            v25 = true
        else
            result = value6
        end
    else
        result = value6
    end
    s3 = s3:sub(1, 64)
    value6 = v33:sub(1, 64)
    s4 = s4:sub(1, 32)
    value7 = v9
    local v28 = s2
    local v29 = ipairs_
    v29 = type(v29) == "function"
    local gethui_ = gethui

    return {
		["executor"] = s3,
		["version"] = value6,
		["platform"] = s4,
		["adapter"] = value7,
		["hwid"] = v25,
		["fingerprint"] = result,
		["files"] = v28,
		["clipboard"] = v29,
		["ui"] = type(gethui_) == "function"
	}
end)()
local v32
ipairs_ = function(p6)
    local v36 = v32
    local s5 = "key"
    local v37

    if type(p6) == "string" then
        v36, s5 = v36("/api/rochess/access", {
			[s5] = p6 or nil,
			["capability"] = v9
		})

        if v36 then
            if v36 >= 200 then
                v37 = v36 < 300
            else
                v37 = false
            end

            if v37 then
                if s5 == "" then
                    return nil, "Empty payload response"
                else
                    return s5
                end

                return
            else
                s5 = value4(s5)

                return nil, type(s5) == "table" and s5.error or "HTTP " .. v36
            end

            return
        else
            return nil, s5
        end

        return
    end

    p6 = false
    v36, s5 = v36("/api/rochess/access", {
		[s5] = p6 or nil,
		["capability"] = v9
	})

    if v36 then
        if v36 >= 200 then
            v37 = v36 < 300
        else
            v37 = false
        end

        if v37 then
            if s5 == "" then
                return nil, "Empty payload response"
            else
                return s5
            end

            return
        else
            s5 = value4(s5)

            return nil, type(s5) == "table" and s5.error or "HTTP " .. v36
        end

        return
    else
        return nil, s5
    end
end
v32 = function(p7, p8)
    local ok = loadstring_(p8)

    if ok then
        local result

        ok, result = pcall(v8, {
			["Url"] = "https://access.valkorym.com" .. p7,
			["Method"] = "POST",
			["Headers"] = {
				["Content-Type"] = "application/json",
				["Accept"] = "application/json"
			},
			["Body"] = ok
		})

        if not ok or type(result) ~= "table" then
            return nil, "Network request failed"
        else
            ok = tonumber(result.StatusCode or (result.Status or (result.status_code or result.status)))

            if ok then
                return ok, result.Body or (result.body or "")
            else
                return nil, "Invalid executor response"
            end

            return
        end

        return
    else
        return nil, "Unable to encode request"
    end
end
loadstring_ = function(p9, p10)
    local v38, v39 = v32(p9, p10)

    if v38 then
        v39 = value4(v39)

        if v38 < 200 and true or v38 >= 300 then
            return nil, type(v39) == "table" and v39.error or "HTTP " .. v38
        else
            if type(v39) == "table" then
                return v39
            else
                return nil, "Invalid server response"
            end

            return
        end

        return
    else
        return nil, v39
    end
end
loadstring_ = function()
    local t1 = {}
    local BindableEvent = Instance.new("BindableEvent")
    local v41 = false
    local u42 = false
    local s6 = ""
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "WhiteLotusAccess"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local protectgui_ = value3
    local gethui_ = gethui
    if type(gethui_) == "function" then
        gethui_, v_u_57 = pcall(gethui)

        if gethui_ then
            gethui_ = typeof(v_u_57) == "Instance"
        end

        if not gethui_ then
            v_u_57 = protectgui_
        end
    else
        v_u_57 = protectgui_
    end
    protectgui_ = protectgui
    if type(protectgui_) == "function" then
        pcall(protectgui, ScreenGui)
    else
        protectgui_ = value

        if protectgui_ then
            protectgui_ = value.protect_gui
            protectgui_ = type(protectgui_) == "function"
        end

        if protectgui_ then
            pcall(value.protect_gui, ScreenGui)
        end
    end
    ScreenGui.Parent = v_u_57
    protectgui_ = Color3.fromRGB(18, 16, 22)
    gethui_ = Color3.fromRGB(26, 23, 31)
    local color3 = Color3.fromRGB(26, 23, 30)
    local color32 = Color3.fromRGB(40, 35, 45)
    local color33 = Color3.fromRGB(55, 48, 61)
    local color34 = Color3.fromRGB(121, 80, 162)
    local color35 = Color3.fromRGB(165, 108, 216)
    local color36 = Color3.fromRGB(246, 243, 250)
    local color37 = Color3.fromRGB(148, 139, 157)
    local color38 = Color3.fromRGB(113, 105, 120)
    local font = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Regular)
    local font2 = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium)
    local font3 = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold)
    local font4 = Font.new("rbxasset://fonts/families/RobotoMono.json", Enum.FontWeight.Regular)
    local image = "rbxassetid://92583561076971"
    local Frame = Instance.new("Frame")
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromOffset(430, 480)
    Frame.BackgroundColor3 = protectgui_
    Frame.BorderSizePixel = 0
    Frame.ClipsDescendants = true
    Frame.Parent = ScreenGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 11)
    protectgui_ = Instance.new("UIScale", Frame)
    local CurrentCamera = workspace.CurrentCamera
    local v62
    protectgui_ = function()
        if not CurrentCamera then
            return
        end

        local ViewportSize = CurrentCamera.ViewportSize
        local v64

        if ViewportSize.X >= ViewportSize.Y then
            v64 = ViewportSize.Y < 520
        else
            v64 = false
        end

        local v65 = v64 and 560 or (ViewportSize.X < 460 and 390 or 430)
        local v66 = v64 and 340 or 480

        Frame.Size = UDim2.fromOffset(v65, v66)

        local v67 = protectgui_

        v65 = (ViewportSize.X - 28) / v65
        ViewportSize = (ViewportSize.Y - 28) / v66
        ViewportSize = math.min(v65, ViewportSize)
        v67.Scale = math.clamp(ViewportSize, 0.45, 1)

        if not v62 then
            return
        end

        v62(v64)
    end
    protectgui_()
    if CurrentCamera then
        v_u_78 = CurrentCamera:GetPropertyChangedSignal("ViewportSize")
        table.insert(t1, v_u_78:Connect(protectgui_))
    end
    local UIStroke = Instance.new("UIStroke", Frame)
    UIStroke.Color = color33
    UIStroke.Transparency = 0
    UIStroke = function(p11, p12, p13)
        Instance.new("UICorner", p11).CornerRadius = UDim.new(0, p12)

        if not p13 then
            return
        end

        local UIStroke2 = Instance.new("UIStroke", p11)

        UIStroke2.Color = p13
        UIStroke2.Transparency = 0
    end
    local function v70(p14, p15)
        local UIPadding = Instance.new("UIPadding", p14)

        UIPadding.PaddingLeft = UDim.new(0, p15)
        UIPadding.PaddingRight = UDim.new(0, p15)
    end
    color36 = function(p16, p17, p18, p19, p20)
        local instance = Instance.new(p16)

        instance.Position = p18
        instance.Size = p19
        instance.BackgroundTransparency = p16 == "TextLabel" and 1 or 0
        instance.BackgroundColor3 = color32
        instance.BorderSizePixel = 0
        instance.FontFace = font
        instance.Text = p17
        instance.TextSize = 14
        instance.TextColor3 = p20 or color36
        instance.Parent = Frame

        if p16 ~= "TextLabel" then
            UIStroke(instance, 7, color33)
        end

        if p16 ~= "TextButton" then
            return instance
        end

        instance.AutoButtonColor = false

        return instance
    end
    font = Instance.new("Frame")
    font.Name = "Header"
    font.Size = UDim2.new(1, 0, 0, 60)
    font.BackgroundColor3 = gethui_
    font.BorderSizePixel = 0
    font.Parent = Frame
    UIStroke(font, 10)
    local Frame2 = Instance.new("Frame")
    Frame2.Name = "SquareBottom"
    Frame2.Size = UDim2.new(1, 0, 0, 10)
    Frame2.Position = UDim2.new(0, 0, 1, -10)
    Frame2.BackgroundColor3 = gethui_
    Frame2.BorderSizePixel = 0
    Frame2.Parent = font
    gethui_ = Instance.new("Frame")
    gethui_.Size = UDim2.new(1, 0, 0, 1)
    gethui_.Position = UDim2.new(0, 0, 1, -1)
    gethui_.BackgroundColor3 = color33
    gethui_.BorderSizePixel = 0
    gethui_.Parent = font
    gethui_ = Instance.new("ImageLabel")
    gethui_.Name = "LotusImage"
    gethui_.Size = UDim2.fromOffset(32, 32)
    gethui_.Position = UDim2.fromOffset(14, 14)
    gethui_.BackgroundTransparency = 1
    gethui_.Image = image
    gethui_.ImageRectOffset = Vector2.new(165, 270)
    gethui_.ImageRectSize = Vector2.new(694, 484)
    gethui_.ScaleType = Enum.ScaleType.Fit
    gethui_.Parent = font
    gethui_ = color36("TextLabel", "WhiteLotus", UDim2.fromOffset(54, 8), UDim2.fromOffset(190, 20))
    gethui_.Parent = font
    gethui_.FontFace = font3
    gethui_.TextSize = 16
    gethui_.TextXAlignment = Enum.TextXAlignment.Left
    gethui_.TextYAlignment = Enum.TextYAlignment.Bottom
    gethui_ = color36("TextLabel", "ROCHESS", UDim2.fromOffset(54, 30), UDim2.fromOffset(190, 18), color37)
    gethui_.Parent = font
    gethui_.FontFace = font2
    gethui_.TextSize = 11
    gethui_.TextXAlignment = Enum.TextXAlignment.Left
    gethui_.TextYAlignment = Enum.TextYAlignment.Top
    gethui_ = color36("TextButton", "\195\151", UDim2.new(1, -48, 0, 14), UDim2.fromOffset(34, 34), Color3.fromRGB(255, 196, 212))
    gethui_.Parent = font
    gethui_.BackgroundColor3 = Color3.fromRGB(70, 31, 46)
    gethui_.TextSize = 21
    gethui_.FontFace = font2
    image = gethui_:FindFirstChildWhichIsA("UIStroke")
    if image then
        image.Color = Color3.fromRGB(111, 51, 70)
    end
    image = color36("TextLabel", "ACCESS", UDim2.fromOffset(20, 76), UDim2.new(1, -40, 0, 14), color35)
    image.FontFace = font3
    image.TextSize = 11
    image.TextXAlignment = Enum.TextXAlignment.Left
    Frame2 = color36("TextLabel", "Start RoChess", UDim2.fromOffset(20, 94), UDim2.new(1, -40, 0, 28))
    Frame2.FontFace = font3
    Frame2.TextSize = 20
    Frame2.TextXAlignment = Enum.TextXAlignment.Left
    local TextLabel = color36("TextLabel", "Use your access key to open WhiteLotus.", UDim2.fromOffset(20, 122), UDim2.new(1, -40, 0, 20), color37)
    TextLabel.TextSize = 14
    TextLabel.TextWrapped = true
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    local Frame3 = Instance.new("Frame")
    Frame3.Position = UDim2.fromOffset(20, 153)
    Frame3.Size = UDim2.new(1, -40, 0, 50)
    Frame3.BackgroundColor3 = color3
    Frame3.BorderSizePixel = 0
    Frame3.Parent = Frame
    UIStroke(Frame3, 8, color33)
    color3 = Instance.new("Frame")
    color3.Size = UDim2.fromOffset(3, 24)
    color3.Position = UDim2.new(0, 12, 0.5, -12)
    color3.BackgroundColor3 = color34
    color3.BorderSizePixel = 0
    color3.Parent = Frame3
    UIStroke(color3, 2)
    color3 = color36("TextLabel", "Enter your key below, or create a link if you need one.", UDim2.fromOffset(26, 5), UDim2.new(1, -38, 1, -10), color37)
    color3.Parent = Frame3
    color3.TextSize = 13
    color3.TextWrapped = true
    color3.TextXAlignment = Enum.TextXAlignment.Left
    color3.TextYAlignment = Enum.TextYAlignment.Center
    color37 = color36("TextLabel", "ENTER YOUR KEY", UDim2.fromOffset(20, 220), UDim2.new(1, -40, 0, 14), color38)
    color37.FontFace = font3
    color37.TextSize = 11
    color37.TextXAlignment = Enum.TextXAlignment.Left
    UIStroke = Instance.new("Frame")
    UIStroke.Position = UDim2.fromOffset(126, 227)
    UIStroke.Size = UDim2.new(1, -146, 0, 1)
    UIStroke.BackgroundColor3 = color33
    UIStroke.BorderSizePixel = 0
    UIStroke.Parent = Frame
    local TextBox = color36("TextBox", "", UDim2.fromOffset(20, 240), UDim2.new(1, -40, 0, 42))
    TextBox.PlaceholderText = "WL-XXXXX-XXXXX-XXXXX-XXXXX"
    TextBox.PlaceholderColor3 = color38
    TextBox.ClearTextOnFocus = false
    TextBox.FontFace = font4
    TextBox.TextSize = 13
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    v70(TextBox, 12)
    color32 = function(p21, p22, p23, p24)
        local TextButton = color36("TextButton", p21, p22, p23)
        local s7 = "BackgroundColor3"
        local v79

        if p24 then
            v79 = color34
        else
            v79 = p24
        end

        TextButton[s7] = v79 or color32
        TextButton.FontFace = font2
        TextButton.TextSize = 14
        s7 = TextButton:FindFirstChildWhichIsA("UIStroke")

        if not (p24 and s7) then
            return TextButton
        end

        s7.Color = color35

        return TextButton
    end
    color34 = color32("Open RoChess", UDim2.fromOffset(20, 292), UDim2.new(1, -40, 0, 42), true)
    font2 = color36("TextLabel", "NEED A KEY?", UDim2.fromOffset(20, 351), UDim2.new(1, -40, 0, 14), color38)
    font2.FontFace = font3
    font2.TextSize = 11
    font2.TextXAlignment = Enum.TextXAlignment.Left
    font3 = Instance.new("Frame")
    font3.Position = UDim2.fromOffset(108, 358)
    font3.Size = UDim2.new(1, -128, 0, 1)
    font3.BackgroundColor3 = color33
    font3.BorderSizePixel = 0
    font3.Parent = Frame
    font4 = color36("TextBox", "", UDim2.fromOffset(20, 371), UDim2.new(1, -40, 0, 38))
    font4.PlaceholderText = "Your access link will appear here"
    font4.PlaceholderColor3 = color38
    font4.ClearTextOnFocus = false
    font4.TextSize = 12
    font4.TextXAlignment = Enum.TextXAlignment.Left
    font4.TextTruncate = Enum.TextTruncate.AtEnd
    v70(font4, 12)
    color33 = function(p25)
        local v80 = p25:FindFirstChildWhichIsA("UIStroke")

        if not v80 then
            return
        end
    end
    color33(TextBox)
    color33(font4)
    color33 = color32("Create access link", UDim2.fromOffset(20, 419), UDim2.new(0.62, -25, 0, 40), false)
    color32 = color32("Copy link", UDim2.new(0.62, 5, 0, 419), UDim2.new(0.38, -25, 0, 40), false)
    color35 = color36("TextLabel", "Access lasts 12 hours", UDim2.fromOffset(20, 462), UDim2.new(1, -40, 0, 14), color38)
    color35.TextSize = 11
    color35.TextXAlignment = Enum.TextXAlignment.Center
    v41 = function(input)
        if v41 then
            return
        end

        BindableEvent:Fire(input)
    end
    v62 = function(p26)
        local v81, uDim2, uDim22

        if p26 then
            v81 = image
            v81 = image
            uDim2 = UDim2.fromOffset(20, 76)
            uDim22 = UDim2.fromOffset(250, 14)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = Frame2
            v81 = Frame2
            uDim2 = UDim2.fromOffset(20, 94)
            uDim22 = UDim2.fromOffset(250, 28)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = TextLabel
            v81 = TextLabel
            uDim2 = UDim2.fromOffset(20, 122)
            uDim22 = UDim2.fromOffset(250, 36)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = Frame3
            v81 = Frame3
            uDim2 = UDim2.fromOffset(20, 166)
            uDim22 = UDim2.fromOffset(250, 68)
            v81.Position = uDim2
            v81.Size = uDim22
            color3.Size = UDim2.new(1, -38, 1, -10)
            v81 = color35
            v81 = color35
            uDim2 = UDim2.fromOffset(20, 246)
            uDim22 = UDim2.fromOffset(250, 14)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = color37
            v81 = color37
            uDim2 = UDim2.fromOffset(290, 78)
            uDim22 = UDim2.fromOffset(250, 14)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = UIStroke
            v81 = UIStroke
            uDim2 = UDim2.fromOffset(398, 85)
            uDim22 = UDim2.fromOffset(142, 1)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = TextBox
            v81 = TextBox
            uDim2 = UDim2.fromOffset(290, 98)
            uDim22 = UDim2.fromOffset(250, 42)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = color34
            v81 = color34
            uDim2 = UDim2.fromOffset(290, 150)
            uDim22 = UDim2.fromOffset(250, 42)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = font2
            v81 = font2
            uDim2 = UDim2.fromOffset(290, 214)
            uDim22 = UDim2.fromOffset(250, 14)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = font3
            v81 = font3
            uDim2 = UDim2.fromOffset(378, 221)
            uDim22 = UDim2.fromOffset(162, 1)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = font4
            v81 = font4
            uDim2 = UDim2.fromOffset(290, 234)
            uDim22 = UDim2.fromOffset(250, 38)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = color33
            v81 = color33
            uDim2 = UDim2.fromOffset(290, 282)
            uDim22 = UDim2.fromOffset(152, 40)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = color32
            v81 = color32
            uDim2 = UDim2.fromOffset(450, 282)
            uDim22 = UDim2.fromOffset(90, 40)
            v81.Position = uDim2
            v81.Size = uDim22
        else
            v81 = image
            v81 = image
            uDim2 = UDim2.fromOffset(20, 76)
            uDim22 = UDim2.new(1, -40, 0, 14)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = Frame2
            v81 = Frame2
            uDim2 = UDim2.fromOffset(20, 94)
            uDim22 = UDim2.new(1, -40, 0, 28)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = TextLabel
            v81 = TextLabel
            uDim2 = UDim2.fromOffset(20, 122)
            uDim22 = UDim2.new(1, -40, 0, 20)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = Frame3
            v81 = Frame3
            uDim2 = UDim2.fromOffset(20, 153)
            uDim22 = UDim2.new(1, -40, 0, 50)
            v81.Position = uDim2
            v81.Size = uDim22
            color3.Size = UDim2.new(1, -38, 1, -10)
            v81 = color35
            v81 = color35
            uDim2 = UDim2.fromOffset(20, 462)
            uDim22 = UDim2.new(1, -40, 0, 14)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = color37
            v81 = color37
            uDim2 = UDim2.fromOffset(20, 220)
            uDim22 = UDim2.new(1, -40, 0, 14)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = UIStroke
            v81 = UIStroke
            uDim2 = UDim2.fromOffset(126, 227)
            uDim22 = UDim2.new(1, -146, 0, 1)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = TextBox
            v81 = TextBox
            uDim2 = UDim2.fromOffset(20, 240)
            uDim22 = UDim2.new(1, -40, 0, 42)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = color34
            v81 = color34
            uDim2 = UDim2.fromOffset(20, 292)
            uDim22 = UDim2.new(1, -40, 0, 42)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = font2
            v81 = font2
            uDim2 = UDim2.fromOffset(20, 351)
            uDim22 = UDim2.new(1, -40, 0, 14)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = font3
            v81 = font3
            uDim2 = UDim2.fromOffset(108, 358)
            uDim22 = UDim2.new(1, -128, 0, 1)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = font4
            v81 = font4
            uDim2 = UDim2.fromOffset(20, 371)
            uDim22 = UDim2.new(1, -40, 0, 38)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = color33
            v81 = color33
            uDim2 = UDim2.fromOffset(20, 419)
            uDim22 = UDim2.new(0.62, -25, 0, 40)
            v81.Position = uDim2
            v81.Size = uDim22
            v81 = color32
            v81 = color32
            uDim2 = UDim2.new(0.62, 5, 0, 419)
            uDim22 = UDim2.new(0.38, -25, 0, 40)
            v81.Position = uDim2
            v81.Size = uDim22
        end
    end
    protectgui_()
    protectgui_ = {
		color33,
		color32,
		color34,
		gethui_
	}
    protectgui_ = function(p27, p28)
        u42 = p27

        for _, v in ipairs(protectgui_) do
            v.Active = not p27
            v.TextTransparency = p27 and 0.45 or 0
        end

        if not p28 then
            return
        end

        color3.Text = p28
    end
    table.insert(t1, gethui_.Activated:Connect(function()
        if u42 then
            return
        end

        v41(nil)
    end))
    table.insert(t1, color33.Activated:Connect(function()
        if u42 then
            return
        end
    end))
    table.insert(t1, color32.Activated:Connect(function()
        if u42 then
            return
        else
            if s6 == "" then
                color3.Text = "Create a key link first."

                return
            else
                if value5(s6) then
                    color3.Text = "Link copied."

                    return
                else
                    font4:CaptureFocus()
                    color3.Text = "Select the visible link."

                    return
                end

                return
            end

            return
        end
    end))
    table.insert(t1, color34.Activated:Connect(function()
        if u42 then
            return
        else
            local match = TextBox.Text:upper():match("^%s*(.-)%s*$")

            if match == "" then
                color3.Text = "Paste your key first."

                return
            end

            return
        end
    end))
    local u87 = false
    local u88
    local Position
    local AbsolutePosition
    v41 = function(p29)
        local UserInputType = p29.UserInputType

        if not (UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch) then
            return
        end

        u87 = true
        u88 = UserInputType == Enum.UserInputType.Touch and p29 and p29 or nil
        Position = p29.Position
        AbsolutePosition = Frame.AbsolutePosition
    end
    table.insert(t1, font.InputBegan:Connect(v41))
    table.insert(t1, value2.InputChanged:Connect(function(input)
        local v92 = not u87

        if not v92 then
            v92 = u88

            if v92 then
                v92 = input ~= u88
            end
        end

        if v92 then
            return
        end

        v92 = not u88

        if v92 then
            v92 = input.UserInputType ~= Enum.UserInputType.MouseMovement
        end

        if v92 then
            return
        end

        v92 = AbsolutePosition + (input.Position - Position)

        local vector2 = CurrentCamera

        if not vector2 then
            vector2 = vector2 or Vector2.new(1920, 1080)
            v125 = Frame.AbsoluteSize
            Frame.AnchorPoint = Vector2.zero
            v126 = Frame
            v127 = UDim2.fromOffset
            v128 = v92.X
            v129 = vector2.X - v125.X
            v129 = math.max(0, v129)
            v128 = math.clamp(v128, 0, v129)
            v92 = v92.Y
            vector2 = vector2.Y - v125.Y
            vector2 = math.max(0, vector2)
            v126.Position = v127(v128, (math.clamp(v92, 0, vector2)))

            return
        end

        vector2 = CurrentCamera.ViewportSize
        vector2 = vector2 or Vector2.new(1920, 1080)

        local AbsoluteSize = Frame.AbsoluteSize

        Frame.AnchorPoint = Vector2.zero

        local v95 = Frame
        local uDim2 = UDim2.fromOffset
        local X = v92.X
        local v98 = vector2.X - AbsoluteSize.X

        v98 = math.max(0, v98)
        X = math.clamp(X, 0, v98)
        v92 = v92.Y
        vector2 = vector2.Y - AbsoluteSize.Y
        vector2 = math.max(0, vector2)
        v95.Position = uDim2(X, (math.clamp(v92, 0, vector2)))
    end))
    table.insert(t1, value2.InputEnded:Connect(function(input)
        local v99 = u88

        if v99 then
            v99 = input == u88
        end

        if v99 then
            return
        end

        v99 = not u88

        if not v99 then
            return
        end

        v99 = input.UserInputType == Enum.UserInputType.MouseButton1
    end))
    v41 = BindableEvent.Event:Wait()
    for _, v in ipairs(t1) do
        v:Disconnect()
    end
    BindableEvent:Destroy()
    ScreenGui:Destroy()

    return v41
end
print("[RoChess] Checking access")
s1, value = ipairs_((function()
    if not s2 then
        return nil
    end

    local ok, result = pcall(readfile, s1)

    ok = ok and value4(result) or nil
    result = type(ok) == "table"

    if not result then
        return result or nil
    end

    result = ok.key

    if type(result) == "string" then
        result = ok.key
    else
        result = false
    end

    return result or nil
end)())
value2 = not s1
if value2 then
    value2 = value == "key_required" or (value == "invalid_key" and true or value == "expired_key")
end
if value2 then
    v19("")
    s1 = loadstring_()
    value = nil
end
if not s1 then
    v4("Access check failed: " .. tostring(value or "window closed"))

    return
end
print("[RoChess] Starting RoChess")
loadstring_, s1 = loadstring(s1)
if not loadstring_ then
    v4("Payload compilation failed: " .. tostring(s1))

    return
end
getgenv_.WhiteLotusRoChessAccess = nil
print("[RoChess] Access granted")
loadstring_ = { pcall(loadstring_) }
s1 = loadstring_[2]
if loadstring_[1] then
    return
end
warn("[RoChess] Payload error: " .. tostring(s1))
