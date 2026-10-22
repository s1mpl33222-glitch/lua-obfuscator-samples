-- This file was generated at discord.gg/syncrypt

local capturedValues1 = {}
capturedValues1.value1 = "https://api.nebulauth.com"
capturedValues1.value2 = "mk_at_mqRNTHJ9GG0Xc7A1pWPb_OoCpshPMW-OSymq1encWnk"
capturedValues1.value3 = "mk_sig_0GCXObajBi8W5Sv4PjJkvrieyXBOAiwehA-iD94OMHA"
local v1426 = game:GetService("HttpService")
capturedValues1.value4 = v1426
local v1430 = game:GetService("UserInputService")
local v1432 = game:GetService("TweenService")
capturedValues1.value5 = v1432
local v1453 = game:FindFirstChild("CoreGui")
v1432 = v1453
if not (v1453) then
    v1432 = (game:GetService("CoreGui"))
end
capturedValues1.value6 = v1432
v1432 = game:GetService("Players").LocalPlayer
capturedValues1.value7 = v1432
v1432 = v1430.TouchEnabled and (not v1430.KeyboardEnabled)
local v1439 = function(arg73_1)
    local v995 = ".."
    local v992 = function(arg42_1)
        return string.char(tonumber(arg42_1, 16))
    end
    return arg73_1:gsub(v995, v992)
end
local v1436 = function(arg74_1)
    local v1001 = crypt.hash
    local v1000 = "sha256"
    return v1001(arg74_1, v1000)
end
local v1445 = function(arg75_1, arg75_2, arg75_3)
    local v1004, v1006, v1015
    local v1002 = arg75_1
    local v1003 = arg75_2
    local v1005 = arg75_3
    if request then
        v1015 = (request({["Url"] = v1002, ["Method"] = "POST", ["Headers"] = v1003, ["Body"] = v1005}))
        v1004 = v1015 and v1015.Body
        return v1004
    else
        v1015 = syn
        v1004 = v1015
        if v1015 then
            v1004 = syn.request
        end
        if v1004 then
            v1015 = (syn.request({["Url"] = v1002, ["Method"] = "POST", ["Headers"] = v1003, ["Body"] = v1005}))
            v1004 = v1015 and v1015.Body
            return v1004
        else
            v1006 = nil
            return v1006
        end
    end
end
capturedValues1.value8 = v1432
capturedValues1.value9 = v1436
capturedValues1.value10 = v1439
local v1440 = function(arg76_1, arg76_2)
    local v1029, v1033
    local v1016 = arg76_1
    local v1017 = arg76_2
    local v1019 = 64
    if ((#v1016) > v1019) then
        v1016 = (capturedValues1.value10(capturedValues1.value9(v1016)))
    end
    while true do
        if not ((#v1016) < v1019) then
            break
        end
        v1016 = (v1016 .. (string.char(0)))
    end
    local v1020 = {}
    local v1023 = v1019
    local v1025 = 1
    local v1022 = {}
    for v1024 = 1, v1023, v1025 do
        v1029 = string.byte(v1016, v1024)
        v1033 = string.char(bit32.bxor(v1029, 92))
        v1020[v1024] = v1033
        v1033 = string.char(bit32.bxor(v1029, 54))
        v1022[v1024] = v1033
    end
    v1023 = table.concat(v1020)
    local v1026 = ((table.concat(v1022)) .. v1017)
    local v1027 = capturedValues1.value9(v1026)
    v1025 = (v1023 .. (capturedValues1.value10(v1027)))

    return capturedValues1.value9(v1025)
end
local v1444 = function()
    local v1039, v1041, v1043
    local up10
    local v1038 = function()
        if gethwid then
            up10 = (gethwid())
        end
        return
    end
    up10 = nil
    pcall(v1038)
    if (not up10) then
        v1039 = "USER_"
        v1043 = capturedValues1.value7
        v1041 = v1043
        if v1043 then
            v1041 = capturedValues1.value7.UserId
        end
        up10 = (v1039 .. ((v1041 or 0) .. ("_" .. game.JobId)))
    end
    return up10
end
local v1441 = function(arg78_1, arg78_2)
    local up11
    local up12
    local v1051 = function()
        local v417, v418, v419, v420, v421, v422, v423, v430
        if writefile then
            v417 = capturedValues1.value4
            v422 = "key"
            v419 = up11
            v420 = "expiry"
            v423 = up12
            v421 = v423
            v418 = v417
            if not (v423) then
                v421 = ((os.time()) + 54000)
            end
            v430 = (v418:JSONEncode({[v422] = v419, [v420] = v421}))
            writefile("MystrixHub.dat", v430)
        end
        return
    end
    up11 = arg78_1
    up12 = arg78_2
    pcall(v1051)

    return
end
capturedValues1.value11 = v1440
capturedValues1.value12 = v1444
capturedValues1.value13 = nil
local v1446 = function(arg79_1)
    local v1056, v1058, v1059, v1060, v1061, v1062, v1063, v1064, v1065, v1066, v1067, v1068, v1069, v1070, v1071, v1072
    local v1055 = arg79_1
    local v1057 = (not v1055) or ((#v1055) < 10)
    if v1057 then
        v1059 = false
        v1057 = "INVALID_KEY"
        return v1059, v1057
    else
        v1056 = (capturedValues1.value12())
        v1060 = capturedValues1.value4:GenerateGUID(false):gsub("-", "")
        v1059 = {["key"] = v1055, ["requestId"] = v1060}
        v1057 = v1056
        v1058 = v1059
        if v1056 then
            v1057 = (v1056 ~= "")
        end
        if v1057 then
            v1058.hwid = v1056
        end
        v1060 = (capturedValues1.value4:JSONEncode(v1058))
        v1061 = (capturedValues1.value9(v1060))
        v1062 = (tostring(DateTime.now().UnixTimestampMillis))
        v1063 = (capturedValues1.value4:GenerateGUID(false):gsub("-", ""))
        v1064 = ("POST" .. ("\n" .. ("/keys/verify" .. ("\n" .. (v1062 .. ("\n" .. (v1063 .. ("\n" .. v1061))))))))
        v1065 = (capturedValues1.value11(capturedValues1.value3, v1064))
        v1066 = "application/json"
        v1070 = ("Bearer " .. capturedValues1.value2)
        v1071 = v1056 or ""
        v1066 = {["Content-Type"] = v1066, ["Authorization"] = v1070, ["X-Timestamp"] = v1062, ["X-Nonce"] = v1063, ["X-Signature"] = v1065, ["X-Body-Sha256"] = v1061, ["X-Hwid"] = v1071}
        v1068 = (capturedValues1.value13((capturedValues1.value1 .. "/api/v1/keys/verify"), v1066, v1060))
        if (not v1068) then
            v1059 = false
            v1057 = "NETWORK_ERROR"
            return v1059, v1057
        else
            v1070 = (capturedValues1.value4:JSONDecode(v1068))
            v1057 = v1070 and v1070.valid
            if v1057 then
                v1059 = true
                v1069 = v1070.keyId
                v1072 = v1070.label or "Key"
                v1071 = v1070.validUntil
                v1057 = {["keyId"] = v1069, ["label"] = v1072, ["validUntil"] = v1071}

                return v1059, v1057
            else
                v1069 = v1070
                v1067 = false
                if v1070 then
                    v1069 = v1070.reason
                end
                v1057 = v1069 or "INVALID_KEY"
                v1059 = v1067
                return v1059, v1057
            end
        end
    end
end
capturedValues1.value13 = v1445
local v1449 = function()
    local v1080 = (Instance.new("ScreenGui"))
    v1080.Name = "MystrixLoading"
    v1080.Parent = capturedValues1.value6
    v1080.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v1080.Enabled = true
    v1080.ResetOnSpawn = false
    local v1081 = Instance.new("Frame")
    local up13 = v1081
    up13.Name = "LoadingFrame"
    up13.Parent = v1080
    up13.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    up13.BorderSizePixel = 0
    up13.AnchorPoint = Vector2.new(0.5, 0.5)
    up13.Position = UDim2.new(0.5, 0, 0.5, 0)
    local v1086 = capturedValues1.value8
    local v1083 = v1086
    if v1086 then
        v1083 = (UDim2.new(.9, 0, 0, 360))
    end
    v1081 = v1083
    if not (v1083) then
        v1081 = (UDim2.new(0, 440, 0, 360))
    end
    local v1085 = up13
    v1083 = v1081
    v1085.Size = UDim2.new(0, 0, 0, 0)
    local v1084 = (Instance.new("UIGradient"))
    v1081 = ColorSequence.new
    local v1089 = ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 26))
    local v1090 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 20, 35))
    v1084.Color = v1081({v1089, v1090, ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 26))})
    v1084.Rotation = 45
    v1084.Parent = up13
    v1086 = (Instance.new("UICorner"))
    v1086.CornerRadius = UDim.new(0, 18)
    v1086.Parent = up13
    local v1087 = (Instance.new("TextLabel"))
    v1087.Name = "Title"
    v1087.Parent = up13
    v1087.BackgroundTransparency = 1
    v1087.Position = UDim2.new(0, 0, 0, 30)
    v1087.Size = UDim2.new(1, 0, 0, 50)
    v1087.Font = Enum.Font.GothamBlack
    v1087.Text = "MYSTRIX HUB"
    v1087.TextColor3 = Color3.fromRGB(255, 255, 255)
    v1087.TextSize = ((capturedValues1.value8 and 32) or 38)
    local v1088 = Instance.new("TextLabel")
    local up14 = v1088
    up14.Name = "LoadingLabel"
    up14.Parent = up13
    up14.BackgroundTransparency = 1
    up14.AnchorPoint = Vector2.new(0.5, 0.5)
    up14.Position = UDim2.new(0.5, 0, 0.5, 0)
    up14.Size = UDim2.new(1, 0, 0, 60)
    up14.Font = Enum.Font.GothamBold
    up14.Text = "LOADING"
    up14.TextColor3 = Color3.fromRGB(180, 140, 240)
    up14.TextSize = ((capturedValues1.value8 and 24) or 28)
    task.spawn(function()
        local v480, v481, v483, v485
        local v478 = {"", ".", "..", "..."}
        local v479 = 1
        while true do
            v480 = up13
            v481 = v480
            if v480 then
                v481 = up13.Parent
            end
            if v481 then
                v485 = up14
                v483 = v478[v479]
                v485.Text = ("LOADING" .. v483)
                v479 = ((v479 % 4) + 1)
                task.wait(.3)
            else
                break
            end
        end
        return
    end)
    v1088 = Instance.new("Frame")
    v1088.Name = "LoadingBarBackground"
    v1088.Parent = up13
    v1088.BackgroundColor3 = Color3.fromRGB(30, 26, 40)
    v1088.BorderSizePixel = 0
    v1088.AnchorPoint = Vector2.new(0.5, 0)
    v1088.Position = UDim2.new(0.5, 0, 0, 220)
    v1088.Size = UDim2.new(.7, 0, 0, 8)
    v1090 = Instance.new("UICorner")
    v1090.CornerRadius = UDim.new(1, 0)
    v1090.Parent = v1088
    local v1091 = Instance.new("Frame")
    local up15 = v1091
    up15.Name = "LoadingBar"
    up15.Parent = v1088
    up15.BackgroundColor3 = Color3.fromRGB(180, 140, 240)
    up15.BorderSizePixel = 0
    up15.Size = UDim2.new(0, 0, 1, 0)
    task.spawn(function()
        local v492, v493, v494, v500
        local v489 = 100
        local v490 = 1
        for v488 = 1, v489, v490 do
            v493 = v488
            v494 = up13
            v492 = v494
            if v494 then
                v492 = up13.Parent
            end
            if not ((not v492))then
                v500 = up15
                v494 = UDim2.new ((v493 / 100), 0, 1, 0)
                v500.Size = v494
                task.wait(.03)

                continue
            end
            break
        end
        return
    end)
    up13.BackgroundTransparency = 1
    v1081 = capturedValues1.value5
    local v1093 = up13
    local v1095 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    v1081:Create(v1093, v1095, {["Size"] = v1083}):Play()
    v1081 = capturedValues1.value5
    v1093 = up13
    v1095 = TweenInfo
    v1091 = v1081.Create
    v1095 = v1095.new(.4)
    v1091 = v1091(v1081, v1093, v1095, {["BackgroundTransparency"] = 0})
    v1091:Play()
    return v1080
end
capturedValues1.value14 = v1446
capturedValues1.value15 = v1441
v1441 = function()
    local up16
    local v1107 = function()
        local v1388, v1393, v1395
        local v1386 = isfile
        local v1387 = v1386
        if v1386 then
            v1388 = readfile
            v1386 = v1388
            if v1388 then
                v1386 = (isfile("MystrixHub.dat"))
            end
            v1387 = v1386
        end
        if v1387 then
            v1387 = readfile("MystrixHub.dat")
            local up67 = v1387
            v1387, v1395 = pcall(function()
                return capturedValues1.value4:JSONDecode(up67)
            end)
            v1388 = v1387
            v1387 = v1388
            if v1388 then
                v1393 = v1395
                if v1395 then
                    v1393 = v1395.key and v1395.expiry
                end
                v1387 = v1393
            end
            if v1387 then
                v1387 = os.time()
                if (v1387 < v1395["expiry"]) then
                    up16 = v1395.key
                else
                    delfile("MystrixHub.dat")
                end
            else
                delfile("MystrixHub.dat")
            end
        end
        return
    end
    up16 = nil
    pcall(v1107)

    return up16
end
capturedValues1.value16 = v1449
capturedValues1.value17 = {}
capturedValues1.value17.__index = capturedValues1.value17
capturedValues1.value17.new = function()
    local v1109 = setmetatable
    local v1114 = {["verified"] = false}
    return v1109(v1114, capturedValues1.value17)
end
v1449 = function(arg83_1)
    local up17 = arg83_1
    local v1116 = function()
        local v1305 = capturedValues1.value6:FindFirstChild("MystrixKeySystem")
        if v1305 then
            capturedValues1.value6:FindFirstChild("MystrixKeySystem"):Destroy()
        end
        return
    end
    pcall(v1116)
    up17.mainGui = Instance.new("ScreenGui")
    local v1117 = up17.mainGui
    v1117.Name = "MystrixKeySystem"
    v1117 = up17.mainGui
    v1117.Parent = capturedValues1.value6
    v1117 = up17.mainGui
    v1117.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v1117 = up17.mainGui
    v1117.Enabled = true
    v1117 = up17.mainGui
    v1117.ResetOnSpawn = false
    v1116 = ((capturedValues1.value8 and 360) or 440)
    local v1118 = ((capturedValues1.value8 and 420) or 360)
    local v1119 = ((capturedValues1.value8 and 28) or 38)
    local v1120 = ((capturedValues1.value8 and 14) or 16)
    local v1121 = ((capturedValues1.value8 and 50) or 48)
    up17.mainFrame = Instance.new("Frame")
    local v1115 = up17.mainFrame
    v1115.Name = "MainFrame"
    v1115 = up17.mainFrame
    v1115.Parent = up17.mainGui
    v1115 = up17.mainFrame
    v1115.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    v1115 = up17.mainFrame
    v1115.BorderSizePixel = 0
    v1115 = up17.mainFrame
    v1115.AnchorPoint = Vector2.new(0.5, 0.5)
    v1115 = up17.mainFrame
    v1115.Position = UDim2.new(0.5, 0, 0.5, 0)
    v1115 = up17.mainFrame
    v1115.Size = UDim2.new(0, v1116, 0, v1118)
    v1115 = up17.mainFrame
    v1115.Active = true
    v1115 = up17.mainFrame
    v1115.Draggable = (not capturedValues1.value8)
    local v1122 = Instance.new("UIGradient")
    local v1123 = ColorSequence.new
    local v1127 = ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 26))
    local v1128 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 20, 35))
    v1122.Color = v1123({v1127, v1128, ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 26))})
    v1122.Rotation = 45
    v1122.Parent = up17.mainFrame
    v1123 = Instance.new("UICorner")
    v1123.CornerRadius = UDim.new(0, 18)
    v1123.Parent = up17.mainFrame
    local v1124 = Instance.new("UIStroke")
    v1124.Color = Color3.fromRGB(40, 40, 60)
    v1124.Thickness = 3
    local v1125 = Instance.new("UIGradient")
    local v1126 = ColorSequence.new
    local v1130 = ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 70, 150))
    local v1131 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 100, 200))
    v1125.Color = v1126({v1130, v1131, ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 70, 150))})
    v1125.Rotation = 135
    v1125.Parent = v1124
    v1124.Parent = up17.mainFrame
    v1126 = Instance.new("TextLabel")
    v1126.Name = "Title"
    v1126.Parent = up17.mainFrame
    v1126.BackgroundTransparency = 1
    v1126.Position = UDim2.new(0, 0, 0, ((capturedValues1.value8 and 20) or 30))
    v1126.Size = UDim2.new(1, 0, 0, 50)
    v1126.Font = Enum.Font.GothamBlack
    v1126.Text = "MYSTRIX HUB"
    v1126.TextColor3 = Color3.fromRGB(255, 255, 255)
    v1126.TextSize = v1119
    v1127 = Instance.new("UIGradient")
    v1128 = ColorSequence.new
    local v1132 = ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 140, 240))
    local v1133 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
    v1127.Color = v1128({v1132, v1133, ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 140, 240))})
    v1127.Rotation = 90
    v1127.Parent = v1126
    v1128 = Instance.new("TextLabel")
    v1128.Name = "Subtitle"
    v1128.Parent = up17.mainFrame
    v1128.BackgroundTransparency = 1
    v1128.Position = UDim2.new(0, 0, 0, ((capturedValues1.value8 and 70) or 80))
    v1128.Size = UDim2.new(1, 0, 0, 20)
    v1128.Font = Enum.Font.GothamMedium
    v1128.Text = "Key Authentication"
    v1128.TextColor3 = Color3.fromRGB(200, 200, 220)
    v1128.TextSize = ((capturedValues1.value8 and 13) or 15)
    local v1129 = Instance.new("Frame")
    v1129.Name = "Divider"
    v1129.Parent = up17.mainFrame
    v1129.BackgroundColor3 = Color3.fromRGB(140, 100, 200)
    v1129.BorderSizePixel = 0
    v1129.Position = UDim2.new(0.5, 0, 0, ((capturedValues1.value8 and 100) or 110))
    v1129.AnchorPoint = Vector2.new(0.5, 0)
    v1129.Size = UDim2.new(0, (v1116 - 60), 0, 3)
    v1130 = Instance.new("TextBox")
    local up18 = v1130
    up18.Name = "KeyBox"
    up18.Parent = up17.mainFrame
    up18.BackgroundColor3 = Color3.fromRGB(25, 22, 35)
    up18.BorderSizePixel = 0
    up18.AnchorPoint = Vector2.new(0.5, 0)
    up18.Position = UDim2.new(0.5, 0, 0, ((capturedValues1.value8 and 120) or 130))
    up18.Size = UDim2.new(0, (v1116 - 40), 0, v1121)
    up18.Font = Enum.Font.GothamMedium
    up18.PlaceholderText = "Enter your key here..."
    up18.PlaceholderColor3 = Color3.fromRGB(140, 140, 160)
    up18.Text = ""
    up18.TextColor3 = Color3.fromRGB(255, 255, 255)
    up18.TextSize = v1120
    up18.ClearTextOnFocus = false
    up18.TextWrapped = true
    up18.TextXAlignment = Enum.TextXAlignment.Center
    v1130 = Instance.new("UICorner")
    v1130.CornerRadius = UDim.new(0, 12)
    v1130.Parent = up18
    v1132 = Instance.new("TextButton")
    v1132.Name = "VerifyButton"
    v1132.Parent = up17.mainFrame
    v1132.BackgroundColor3 = Color3.fromRGB(90, 65, 135)
    v1132.BorderSizePixel = 0
    v1132.AnchorPoint = Vector2.new(0.5, 0)
    v1132.Position = UDim2.new(0.5, 0, 0, ((capturedValues1.value8 and 190) or 195))
    v1132.Size = UDim2.new(0, (v1116 - 40), 0, v1121)
    v1132.Font = Enum.Font.GothamBlack
    v1132.Text = "VERIFY KEY"
    v1132.TextColor3 = Color3.fromRGB(255, 255, 255)
    v1132.TextSize = v1120
    v1133 = Instance.new("UIGradient")
    local v1134 = ColorSequence.new
    local v1138 = ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 70, 150))
    local v1139 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 100, 200))
    v1133.Color = v1134({v1138, v1139, ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 70, 150))})
    v1133.Rotation = 90
    v1133.Parent = v1132
    v1134 = Instance.new("UICorner")
    v1134.CornerRadius = UDim.new(0, 12)
    v1134.Parent = v1132
    local v1135 = Instance.new("Frame")
    v1135.Name = "ButtonRow"
    v1135.Parent = up17.mainFrame
    v1135.BackgroundTransparency = 1
    v1135.AnchorPoint = Vector2.new(0.5, 0)
    v1135.Position = UDim2.new(0.5, 0, 0, ((capturedValues1.value8 and 255) or 255))
    v1135.Size = UDim2.new(0, (v1116 - 40), 0, v1121)
    local v1136 = Instance.new("TextButton")
    v1136.Name = "GetKeyButton"
    v1136.Parent = v1135
    v1136.BackgroundColor3 = Color3.fromRGB(35, 30, 45)
    v1136.BorderSizePixel = 0
    v1136.Size = UDim2.new(0.5, -5, 1, 0)
    v1136.Position = UDim2.new(0, 0, 0, 0)
    v1136.Font = Enum.Font.GothamBold
    v1136.Text = "GET KEY"
    v1136.TextColor3 = Color3.fromRGB(220, 220, 240)
    v1136.TextSize = ((capturedValues1.value8 and 13) or 15)
    local v1137 = Instance.new("UICorner")
    v1137.CornerRadius = UDim.new(0, 10)
    v1137.Parent = v1136
    v1138 = Instance.new("TextButton")
    v1138.Name = "DiscordButton"
    v1138.Parent = v1135
    v1138.BackgroundColor3 = Color3.fromRGB(35, 30, 45)
    v1138.BorderSizePixel = 0
    v1138.Size = UDim2.new(0.5, -5, 1, 0)
    v1138.Position = UDim2.new(0.5, 5, 0, 0)
    v1138.Font = Enum.Font.GothamBold
    v1138.Text = "DISCORD"
    v1138.TextColor3 = Color3.fromRGB(220, 220, 240)
    v1138.TextSize = ((capturedValues1.value8 and 13) or 15)
    v1139 = Instance.new("UICorner")
    v1139.CornerRadius = UDim.new(0, 10)
    v1139.Parent = v1138
    local v1140 = Instance.new("TextButton")
    v1140.Name = "CloseButton"
    v1140.Parent = up17.mainFrame
    v1140.BackgroundColor3 = Color3.fromRGB(60, 55, 80)
    v1140.BorderSizePixel = 0
    v1140.Position = UDim2.new(1, -40, 0, 16)
    v1140.Size = UDim2.new(0, 28, 0, 28)
    v1140.Font = Enum.Font.GothamBold
    v1140.Text = "X"
    v1140.TextColor3 = Color3.fromRGB(255, 255, 255)
    v1140.TextSize = 16
    local v1141 = Instance.new("UICorner")
    v1141.CornerRadius = UDim.new(0, 10)
    v1141.Parent = v1140
    local v1142 = Instance.new("TextLabel")
    local up19 = v1142
    up19.Name = "StatusLabel"
    up19.Parent = up17.mainFrame
    up19.BackgroundTransparency = 1
    up19.Position = UDim2.new(0, 0, 1, -32)
    up19.Size = UDim2.new(1, 0, 0, 24)
    up19.Font = Enum.Font.GothamMedium
    up19.Text = ""
    up19.TextColor3 = Color3.fromRGB(255, 255, 255)
    up19.TextSize = ((capturedValues1.value8 and 12) or 14)
    up19.TextWrapped = true
    local v1144 = function()
        setclipboard("https://mystrixhub.alexrule49.workers.dev/")
        up19.Text = "Key link copied to clipboard"
        up19.TextColor3 = Color3.fromRGB(180, 140, 240)
        task.wait(2)
        up19.Text = ""
        return
    end
    v1136.MouseButton1Click :Connect(v1144)
    v1115 = v1138.MouseButton1Click
    v1144 = function()
        setclipboard("https://discord.gg/XV66VWqAaN")
        up19.Text = "Discord invite copied to clipboard"
        up19.TextColor3 = Color3.fromRGB(180, 140, 240)
        task.wait(2)
        up19.Text = ""
        return
    end
    v1115:Connect(v1144)
    v1115 = v1140.MouseButton1Click
    v1144 = function()
        up17.mainGui:Destroy()
        return
    end
    v1115:Connect(v1144)
    v1144 = function()
        local v1331 = up17
        local v1338 = up18.Text
        v1331:VerifyKey(v1338, up19)

        return
    end
    v1132.MouseButton1Click :Connect(v1144)
    up18.FocusLost:Connect(function(arg93_1)
        local v1339, v1345
        if arg93_1 then
            v1339 = up17
            v1345 = up18.Text
            v1339:VerifyKey(v1345, up19)
        end
        return
    end)
    v1115 = up17.mainFrame
    v1115.Size = UDim2.new(0, 0, 0, 0)
    v1115 = up17.mainFrame
    v1115.BackgroundTransparency = 1
    v1115 = capturedValues1.value5
    v1144 = up17.mainFrame
    local v1146 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    v1142 = v1115.Create
    local v1149 = UDim2.new(0, v1116, 0, v1118)
    v1142 = v1142(v1115, v1144, v1146, {["Size"] = v1149})
    v1142:Play()
    v1115 = capturedValues1.value5
    v1144 = up17.mainFrame
    v1146 = TweenInfo.new(.4)
    v1115:Create(v1144, v1146, {["BackgroundTransparency"] = 0}):Play()
    return
end
capturedValues1.value17.CreateMainGUI = v1449
v1449 = function(arg84_1, arg84_2, arg84_3)
    local v1163, v1164, v1166, v1167, v1168, v1169, v1170, v1171, v1172, v1173, v1174, v1175, v1176, v1177, v1180
    local v1181
    local v1157 = arg84_1
    local v1158 = arg84_2
    local v1159 = (not v1158)
    local v1160 = v1159
    local v1161 = arg84_3
    if not (v1159) then
        v1160 = (v1158 == "")
    end
    if v1160 then
        v1161.Text = "Please enter a key"
        v1159 = Color3.fromRGB(255, 100, 100)
        v1161.TextColor3 = v1159
        task.wait (2)
        v1161.Text = ""
        return
    else
        v1161.Text = "Verifying key..."
        v1159 = Color3.fromRGB(180, 140, 240)
        v1161.TextColor3 = v1159
        v1167, v1168 = capturedValues1.value14(v1158)
        local up20 = v1168
        if v1167 then
            v1161.Text = "ACCESS GRANTED"
            v1159 = Color3.fromRGB (100, 255, 100)
            v1161.TextColor3 = v1159
            v1159 = up20
            v1160 = v1159
            if v1159 then
                v1160 = up20.validUntil
            end
            if v1160 then
                v1166 = pcall
                v1163 = function()
                    return DateTime.fromIsoDate(up20.validUntil).UnixTimestamp
                end
                v1164 = {v1166(v1163)}
                v1159 = v1164[2]
                if v1164[1] then
                    capturedValues1.value15(v1158, v1159)
                else
                    capturedValues1.value15(v1158)
                end
            else
                capturedValues1.value15(v1158)
            end
            v1157.verified = true
            v1163 = 2
            v1164 = 1
            for v1159 = 1, v1163, v1164 do
                v1166 = capturedValues1.value5
                v1160 = v1166.Create
                v1171 = v1157.mainFrame
                v1172 = TweenInfo.new(.1)
                v1176 = v1157.mainFrame.Size
                v1181 = UDim2.new(0, 12, 0, 12)
                v1160 = v1160(v1166, v1171, v1172, {["Size"] = (v1176 + v1181)})
                v1160:Play()
                task.wait(.1)
                v1166 = capturedValues1.value5
                v1171 = v1157.mainFrame
                v1172 = TweenInfo.new(.1)
                v1176 = v1157.mainFrame.Size
                v1177 = UDim2.new
                v1160 = v1166.Create
                v1174 = (v1176 - (v1177(0, 12, 0, 12)))
                v1160 = v1160(v1166, v1171, v1172, {["Size"] = v1174})
                v1160:Play()
                task.wait(.1)
            end
            v1157.mainGui:Destroy()
            v1159 = (capturedValues1.value16())
            task.wait(0.5)
            v1157:LoadScript()
            task.wait(3)
            if v1159 then
                v1159:Destroy()
            end
        else
            v1160 = up20
            v1159 = "Invalid key"
            if (v1160 == "EXPIRED") then
                v1159 = "Key expired"
            else
                v1163 = up20
                if (v1163 == "REVOKED") then
                    v1159 = "Key revoked"
                else
                    v1164 = up20
                    if (v1164 == "NOT_FOUND") then
                        v1159 = "Key not found"
                    else
                        v1169 = up20
                        if (v1169 == "HWID_REQUIRED") then
                            v1159 = "HWID required"
                        else
                            v1170 = up20
                            if (v1170 == "HWID_MISMATCH") then
                                v1159 = "Wrong device"
                            else
                                v1171 = up20
                                if (v1171 == "NETWORK_ERROR") then
                                    v1159 = "Network error"
                                end
                            end
                        end
                    end
                end
            end
            v1161.Text = v1159
            v1172 = Color3.fromRGB(255, 100, 100)
            v1161.TextColor3 = v1172
            v1171 = v1157.mainFrame.Position
            v1173 = 4
            v1174 = 1
            for v1172 = 1, v1173, v1174 do
                v1177 = v1157.mainFrame
                v1180 = UDim2.new(0, 8, 0, 0)
                v1177.Position = (v1171 + v1180)
                task.wait(.04)
                v1177 = v1157.mainFrame
                v1180 = UDim2.new(0, 8, 0, 0)
                v1177.Position = (v1171 - v1180)
                task.wait(.04)
            end
            v1175 = v1157.mainFrame
            v1175.Position = v1171
            task.wait (2)
            v1161.Text = ""
        end
        return
    end
end
capturedValues1.value17.VerifyKey = v1449
v1449 = function(arg85_1)
    local spilledValues1 = {}
    
    local v1186 = function()
        local capturedValues2 = {}
        print("Mystrix Hub loaded successfully")
        local v1201 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))
        capturedValues2.value1 = (v1201())
        local v1203 = (capturedValues2.value1:CreateWindow({["Title"] = "Mystrix Hub - TOJ", ["Icon"] = "app-window-mac", ["Author"] = "Ummarxfarooq", ["Theme"] = "Dark"}))
        local v1202 = capturedValues2.value1
        local v1207 = capturedValues2.value1
        local v1220 = Color3.fromHex("#991B1B")
        local v1211 = {["Color"] = v1220, ["Transparency"] = 0}
        local v1221 = Color3.fromHex("#7F1D1D")
        local v1214 = {["0"] = v1211, ["100"] = {["Color"] = v1221, ["Transparency"] = 0}}
        local v1216 = v1207:Gradient(v1214, {["Rotation"] = 45})
        v1214 = capturedValues2.value1
        v1221 = Color3.fromHex("#0A0303")
        local v1213 = {["Color"] = v1221, ["Transparency"] = 0}
        local v1225 = Color3.fromHex("#120606")
        v1211 = {["0"] = v1213, ["100"] = {["Color"] = v1225, ["Transparency"] = 0}}
        local v1215 = v1214:Gradient(v1211, {["Rotation"] = 90})
        local v1218 = Color3.fromHex("#DC2626")
        v1220 = Color3.fromHex("#E5E5E5")
        v1221 = Color3.fromHex("#450A0A")
        local v1209 = capturedValues2.value1
        local v1230 = Color3.fromHex("#000000")
        local v1223 = {["Color"] = v1230, ["Transparency"] = 0}
        v1225 = v1209.Gradient
        local v1232 = Color3.fromHex("#0D0404")
        local v1227 = {["Color"] = v1232, ["Transparency"] = 0}
        v1225 = v1225(v1209, {["0"] = v1223, ["100"] = v1227}, {["Rotation"] = 180})
        local v1212 = capturedValues2.value1
        local v1226 = Color3.fromHex
        v1201 = v1202.AddTheme
        v1232 = v1226("#7F1D1D")
        v1227 = {["Color"] = v1232, ["Transparency"] = 0}
        local v1235 = Color3
        local v1219 = v1212.Gradient
        v1235 = v1235.fromHex("#991B1B")
        v1219 = v1219(v1212, {["0"] = v1227, ["100"] = {["Color"] = v1235, ["Transparency"] = 0}}, {["Rotation"] = 90})
        local v1229 = Color3.fromHex("#DC2626")
        v1201(v1202, {["Name"] = "RubyNoir", ["Accent"] = v1216, ["Dialog"] = v1215, ["Outline"] = v1218, ["Text"] = v1220, ["Placeholder"] = v1221, ["Background"] = v1225, ["Button"] = v1219, ["Icon"] = v1229})
        capturedValues2.value1:SetTheme("RubyNoir")
        v1202 = v1203.Section
        v1202 = v1202(v1203, {["Title"] = "Main", ["Icon"] = "gamepad-2", ["Opened"] = true})
        local v1204 = v1202
        v1202 = game
        v1201 = v1202.GetService
        v1201 = v1201(v1202, "Players")
        local v1206 = v1201
        v1201 = game:GetService("RunService")
        capturedValues2.value2 = v1201
        v1201 = game:GetService("UserInputService")
        capturedValues2.value3 = v1201
        v1201 = game:GetService("TextChatService")
        capturedValues2.value4 = v1201
        v1201 = game:GetService("ReplicatedStorage")
        capturedValues2.value5 = v1201
        v1201 = game:GetService("VirtualUser")
        capturedValues2.value6 = v1201
        v1201 = capturedValues2.value5:WaitForChild("CosmeticRemote")
        capturedValues2.value7 = v1201
        v1201 = capturedValues2.value5:WaitForChild("EquipTitle")
        capturedValues2.value8 = v1201
        capturedValues2.value9 = v1206.LocalPlayer
        v1202 = capturedValues2.value9
        v1201 = v1202:WaitForChild("PlayerGui")
        capturedValues2.value10 = v1201
        v1201 = getgenv()
        v1201.autoFarmEnabled = false
        v1201 = getgenv()
        v1201.autoFarmAltEnabled = false
        v1201 = getgenv()
        v1201.autoFarmNewEnabled = false
        v1201 = getgenv()
        v1201.flyEnabled = false
        v1201 = getgenv()
        v1201.walkSpeed = 16
        v1201 = getgenv()
        v1201.jumpPower = 50
        v1201 = getgenv()
        v1201.noClipEnabled = false
        v1201 = getgenv()
        v1201.InfJumpEnabled = false
        v1202 = getgenv
        v1201 = v1202()
        v1201.antiAfkEnabled = false
        v1202 = function()
            local v110, v111, v114
            local v115 = (capturedValues2.value10:FindFirstChild("TimerGui"))
            if v115 then
                v114 = "Timer"
                v111 = v115.FindFirstChild
                return v111(v115, v114)
            else
                v110 = nil
                return v110
            end
        end
        capturedValues2.value11 = v1202
        v1202 = function(arg1_1)
            local v122
            local v116 = capturedValues2.value9
            local v117 = arg1_1
            local v121 = v116.Character
            v116 = v121 and (v121:FindFirstChildOfClass("Humanoid"))
            if v116 then
                v122 = v121.Humanoid
                v122.WalkSpeed = v117
            end
            return
        end
        capturedValues2.value12 = v1202
        local up46 = function(arg2_1)
            local v127
            local v125 = capturedValues2.value9
            local v126 = arg2_1
            local v130 = v125.Character
            v125 = v130
            if v130 then
                v125 = (v130:FindFirstChildOfClass("Humanoid"))
            end
            if v125 then
                v127 = v130.Humanoid
                if v127.UseJumpPower then
                    v127.JumpPower = v126
                else
                    v125 = (v126 / 10)
                    v127.JumpHeight = v125
                end
            end
            return
        end
        capturedValues2.value13 = false
        local up49 = function()
            local v137, v140, v141
            if capturedValues2.value13 then
                return
            else
                capturedValues2.value13 = true
                v140 = capturedValues2.value9.Character
                v141 = v140
                if not (v140) then
                    v141 = (capturedValues2.value9.CharacterAdded:Wait())
                end
                v141 = v141:WaitForChild("HumanoidRootPart")
                local up2 = v141
                local up1 = 30
                local up3
                v141 = capturedValues2.value2.RenderStepped
                v137 = function(arg95_1)
                    local v1379, v1385
                    local v1374 = capturedValues2.value13
                    local v1375 = arg95_1
                    local v1376 = (not v1374)
                    local v1377 = v1376
                    if not (v1376) then
                        v1379 = (not up2)
                        v1376 = v1379
                        if not (v1379) then
                            v1376 = (not up2.Parent)
                        end
                        v1377 = v1376
                    end
                    if v1377 then
                        if up3 then
                            up3:Disconnect()
                        end
                        return
                    else
                        v1385 = up2
                        v1376 = (up2.CFrame * (CFrame.Angles(0, (up1 * v1375), 0)))
                        v1385.CFrame = v1376
                        return
                    end
                end
                up3 = (v141:Connect(v137))

                return
            end
        end
        capturedValues2.value14 = function()
            return
        end
        local up29 = function(arg5_1)
            local v150, v151
            v150, v151 = arg5_1:match("(%d+):(%d+)")
            local v146 = v151
            local v149 = v150
            v151 = (v149 and v146)
            if v151 then
                v150 = (((tonumber(v149)) * 60) + (tonumber(v146)))

                return v150
            else
                v150 = nil
                return v150
            end
        end
        v1202 = function()
            local v152, v153, v155, v156, v157, v158, v163, v164
            while true do
                v153 = getgenv()
                if not v153["autoFarmEnabled"] then
                    break
                end
                v153 = (capturedValues2.value11())
                if (not v153) then
                    print("Timer not found, waiting...")
                    task.wait(2)

                    continue
                else
                    v164 = up29(v153.Text)
                    v152 = v164
                    if not (v164) then
                        v152 = math.huge
                    end
                    v157 = (v152 <= 274)
                    while true do
                        v156 = (up29(v153.Text ))
                        if v156 then
                            print(("Current time: " .. (v153.Text .. (" (" .. (v156 .. "s)")))))
                        end
                        v164 = getgenv()
                        if not ((not v164["autoFarmEnabled"]))then
                            task.wait(.05)
                            v164 = up29(v153.Text)
                            v152 = v164
                            if not (v164) then
                                v152 = math.huge
                            end
                            if not ((v152 <= 274))then
                                continue
                            end
                        end
                        break
                    end
                    v158 = getgenv()
                    if not ((not v158["autoFarmEnabled"]))then
                        v156 = capturedValues2.value9.Character
                        v152 = v156
                        if not (v156) then
                            v152 = (capturedValues2.value9.CharacterAdded:Wait())
                        end
                        v155 = (v152:WaitForChild("HumanoidRootPart"))
                        v156 = CFrame.new(31.34, 219.23, 141.96)
                        v155.CFrame = v156
                        print("Teleported")
                        up49()
                        v164 = up29(v153.Text)
                        v152 = v164
                        if not (v164) then
                            v152 = math.huge
                        end
                        v157 = (v152 <= 270)
                        while true do
                            v156 = (up29(v153.Text ))
                            if v156 then
                                print(("Waiting for 4:30: " .. (v153.Text .. (" (" .. (v156 .. "s)")))))
                            end
                            v164 = getgenv()
                            if not ((not v164["autoFarmEnabled"]))then
                                task.wait(.05)
                                v164 = up29(v153.Text)
                                v152 = v164
                                if not (v164) then
                                    v152 = math.huge
                                end
                                if not ((v152 <= 270))then
                                    continue
                                end
                            end
                            break
                        end
                        v158 = getgenv()
                        if not ((not v158["autoFarmEnabled"]))then
                            capturedValues2.value4.TextChannels.RBXGeneral:SendAsync("/skip")
                            print("Sent /skip")
                            v152 = task
                            v158 = function()
                                capturedValues2.value14()
                                print("Spinning stopped after 2 seconds post-skip")

                                return
                            end
                            v152.delay (2, v158)
                            v157 = (((up29(v153.Text)) or 0) > 290)
                            while true do
                                v156 = up29(v153.Text)
                                if v156 then
                                    print(("Waiting for reset: " .. (v153.Text .. (" (" .. (v156 .. "s)")))))
                                end
                                v163 = getgenv()
                                if not ((not v163["autoFarmEnabled"]))then
                                    task.wait(.2)
                                    v163 = up29(v153.Text)
                                    if not (((v163 or 0) > 290))then
                                        continue
                                    end
                                end
                                break
                            end
                            print("Round reset detected, continuing loop")
                            task.wait(3)

                            continue
                        end
                    end
                end
                break
            end
            capturedValues2.value14()
            print("Auto-farm loop stopped")

            return
        end
        capturedValues2.value15 = v1202
        v1202 = function()
            local v170, v171, v173, v174, v175, v176, v181, v182
            while true do
                v171 = getgenv()
                if not v171["autoFarmAltEnabled"] then
                    break
                end
                v171 = (capturedValues2.value11())
                if (not v171) then
                    print("Alt Timer not found, waiting...")
                    task.wait(2)

                    continue
                else
                    v182 = up29(v171.Text)
                    v170 = v182
                    if not (v182) then
                        v170 = math.huge
                    end
                    v175 = (v170 <= 185)
                    while true do
                        v174 = (up29(v171.Text ))
                        if v174 then
                            print(("Alt Current time: " .. (v171.Text .. (" (" .. (v174 .. "s)")))))
                        end
                        v182 = getgenv()
                        if not ((not v182["autoFarmAltEnabled"]))then
                            task.wait(.05)
                            v182 = up29(v171.Text)
                            v170 = v182
                            if not (v182) then
                                v170 = math.huge
                            end
                            if not ((v170 <= 185))then
                                continue
                            end
                        end
                        break
                    end
                    v176 = getgenv()
                    if not ((not v176["autoFarmAltEnabled"]))then
                        v174 = capturedValues2.value9.Character
                        v170 = v174
                        if not (v174) then
                            v170 = (capturedValues2.value9.CharacterAdded:Wait())
                        end
                        v173 = (v170:WaitForChild("HumanoidRootPart"))
                        v174 = CFrame.new(31.34, 219.23, 141.96)
                        v173.CFrame = v174
                        print("Alt Teleported")
                        up49()
                        v182 = up29(v171.Text)
                        v170 = v182
                        if not (v182) then
                            v170 = math.huge
                        end
                        v175 = (v170 <= 180)
                        while true do
                            v174 = (up29(v171.Text ))
                            if v174 then
                                print(("Alt Waiting for 3:00: " .. (v171.Text .. (" (" .. (v174 .. "s)")))))
                            end
                            v182 = getgenv()
                            if not ((not v182["autoFarmAltEnabled"]))then
                                task.wait(.05)
                                v182 = up29(v171.Text)
                                v170 = v182
                                if not (v182) then
                                    v170 = math.huge
                                end
                                if not ((v170 <= 180))then
                                    continue
                                end
                            end
                            break
                        end
                        v176 = getgenv()
                        if not ((not v176["autoFarmAltEnabled"]))then
                            capturedValues2.value4.TextChannels.RBXGeneral:SendAsync("/skip")
                            print("Alt Sent /skip")
                            task.delay (2, function()
                                capturedValues2.value14()
                                print("Alt Spinning stopped after 2 seconds post-skip")

                                return
                            end)
                            v175 = (((up29(v171.Text)) or 0) > 290)
                            while true do
                                v174 = up29(v171.Text)
                                if v174 then
                                    print(("Alt Waiting for reset: " .. (v171.Text .. (" (" .. (v174 .. "s)")))))
                                end
                                v181 = getgenv()
                                if not ((not v181["autoFarmAltEnabled"]))then
                                    task.wait(.2)
                                    v181 = up29(v171.Text)
                                    if not (((v181 or 0) > 290))then
                                        continue
                                    end
                                end
                                break
                            end
                            print("Alt Round reset detected, continuing loop")
                            task.wait(3)

                            continue
                        end
                    end
                end
                break
            end
            capturedValues2.value14()
            print("Alt Auto-farm loop stopped")

            return
        end
        capturedValues2.value16 = v1202
        v1202 = function()
            local v188, v189, v191, v192, v193, v194, v199, v200
            while true do
                v189 = getgenv()
                if not v189["autoFarmNewEnabled"] then
                    break
                end
                v189 = (capturedValues2.value11())
                if (not v189) then
                    print("New Timer not found, waiting...")
                    task.wait(2)

                    continue
                else
                    v200 = up29(v189.Text)
                    v188 = v200
                    if not (v200) then
                        v188 = math.huge
                    end
                    v193 = (v188 <= 5)
                    while true do
                        v192 = (up29(v189.Text ))
                        if v192 then
                            print(("New Current time: " .. (v189.Text .. (" (" .. (v192 .. "s)")))))
                        end
                        v200 = getgenv()
                        if not ((not v200["autoFarmNewEnabled"]))then
                            task.wait(.05)
                            v200 = up29(v189.Text)
                            v188 = v200
                            if not (v200) then
                                v188 = math.huge
                            end
                            if not ((v188 <= 5))then
                                continue
                            end
                        end
                        break
                    end
                    v194 = getgenv()
                    if not ((not v194["autoFarmNewEnabled"]))then
                        v192 = capturedValues2.value9.Character
                        v188 = v192
                        if not (v192) then
                            v188 = (capturedValues2.value9.CharacterAdded:Wait())
                        end
                        v191 = (v188:WaitForChild("HumanoidRootPart"))
                        v192 = CFrame.new(31.34, 219.23, 141.96)
                        v191.CFrame = v192
                        print("New Teleported")
                        up49()
                        task.delay (7, function()
                            capturedValues2.value14()
                            print("New Spinning stopped after 7 seconds")

                            return
                        end)
                        v193 = (((up29(v189.Text)) or 0) > 290)
                        while true do
                            v192 = up29(v189.Text)
                            if v192 then
                                print(("New Waiting for reset: " .. (v189.Text .. (" (" .. (v192 .. "s)")))))
                            end
                            v199 = getgenv()
                            if not ((not v199["autoFarmNewEnabled"]))then
                                task.wait(.2)
                                v199 = up29(v189.Text)
                                if not (((v199 or 0) > 290))then
                                    continue
                                end
                            end
                            break
                        end
                        print("New Round reset detected, continuing loop")
                        task.wait(3)

                        continue
                    end
                end
                break
            end
            capturedValues2.value14()
            print("New Auto-farm loop stopped")

            return
        end
        capturedValues2.value17 = v1202
        capturedValues2.value18 = nil
        capturedValues2.value19 = 50
        capturedValues2.value20 = 100
        capturedValues2.value21 = .9
        capturedValues2.value22 = nil
        capturedValues2.value23 = nil
        capturedValues2.value24 = nil
        v1202 = function()
            local v208, v209, v215
            local v211 = capturedValues2.value9.Character
            local up4 = v211
            local v207 = (not up4)
            local v206 = v207
            if not (v207) then
                v209 = (not (up4:FindFirstChild("HumanoidRootPart")))
                v207 = v209
                if not (v209) then
                    v207 = (not (up4:FindFirstChildOfClass("Humanoid")))
                end
                v206 = v207
            end
            if v206 then
                return
            else
                v211 = up4.HumanoidRootPart
                local up5 = v211
                v208 = (up4:FindFirstChildOfClass("Humanoid"))
                v208.PlatformStand = true
                capturedValues2.value22 = (Instance.new("BodyVelocity"))
                v211 = capturedValues2.value22
                v215 = Vector3.new(math.huge, math.huge, math.huge)
                v211.MaxForce = v215
                v211 = capturedValues2.value22
                v215 = Vector3.new (0, 0, 0)
                v211.Velocity = v215
                v211 = capturedValues2.value22
                v211.Parent = up5
                v209 = Vector3.new (0, 0, 0)
                local up6 = v209
                v211 = capturedValues2.value2.RenderStepped
                v215 = function(arg94_1)
                    local v1348, v1349, v1350, v1351, v1352, v1353, v1356, v1357, v1358, v1359, v1360, v1362, v1363, v1364, v1365, v1367
                    local v1347 = arg94_1
                    local v1354 = (not getgenv().flyEnabled)
                    local v1355 = v1354
                    if not (v1354) then
                        v1348 = (not up4)
                        v1354 = v1348
                        if not (v1348) then
                            v1354 = (not up5.Parent)
                        end
                        v1355 = v1354
                    end
                    if v1355 then
                        stopFlying()
                        return
                    else
                        v1354 = (Vector3.new(0, 0, 0))
                        v1353 = workspace.CurrentCamera
                        v1358 = v1353.CFrame.LookVector
                        v1349 = "CFrame"
                        v1348 = v1358
                        v1349 = v1353[v1349].RightVector
                        v1355 = Vector3.new(0, 1, 0)
                        v1358 = capturedValues2.value3
                        v1356 = Enum
                        v1350 = v1355
                        v1352 = v1356.KeyCode
                        v1355 = v1358:IsKeyDown(v1352.W)
                        if v1355 then
                            v1354 = (v1354 + v1348)
                        end
                        v1355 = capturedValues2.value3
                        v1356 = Enum.KeyCode
                        v1351 = v1355:IsKeyDown(v1356.S)
                        if v1351 then
                            v1354 = (v1354 - v1348)
                        end
                        v1351 = capturedValues2.value3
                        v1356 = Enum.KeyCode.D
                        v1352 = v1351:IsKeyDown(v1356)
                        if v1352 then
                            v1354 = (v1354 + v1349)
                        end
                        v1352 = capturedValues2.value3
                        v1359 = Enum.KeyCode
                        v1356 = v1352:IsKeyDown(v1359.A)
                        if v1356 then
                            v1354 = (v1354 - v1349)
                        end
                        v1356 = capturedValues2.value3
                        v1360 = Enum.KeyCode
                        v1357 = v1356:IsKeyDown(v1360.Space)
                        if v1357 then
                            v1354 = (v1354 + v1350)
                        end
                        v1357 = capturedValues2.value3
                        v1360 = Enum.KeyCode.LeftControl
                        v1359 = v1357:IsKeyDown(v1360)
                        if v1359 then
                            v1354 = (v1354 - v1350)
                        end
                        if capturedValues2.value23 then
                            v1359 = v1353.ViewportSize
                            v1360 = capturedValues2.value23.Position
                            v1362 = (v1360 - (v1359 / 2)).Unit
                            v1363 = v1362.X
                            v1365 = (v1354 + ((v1348 * (-v1362.Y)) + (v1349 * v1363)))
                            v1367 = v1360.X
                            v1354 = v1365
                            if (v1367 > (v1359["X"] * 0.75)) then
                                v1367 = v1360.Y
                                if (v1367 < (v1359["Y"] * 0.5)) then
                                    v1354 = (v1354 + v1350)
                                else
                                    v1354 = (v1354 - v1350)
                                end
                            end
                        end
                        if (v1354["Magnitude"] > 0) then
                            v1359 = (v1354.Unit * capturedValues2.value19)
                            up6 = (up6 + ((v1359 - up6) * (capturedValues2.value20 * v1347)))
                        else
                            up6 = (up6 * capturedValues2.value21)
                        end
                        v1362 = capturedValues2.value22
                        v1364 = up6
                        v1362.Velocity = v1364
                        return
                    end
                end
                capturedValues2.value18 = (v211:Connect(v215))

                return
            end
        end
        capturedValues2.value25 = v1202
        local up43 = function()
            local v228, v230, v231, v233
            local v222 = getgenv().flyEnabled
            local v223 = getgenv()
            v223.flyEnabled = false
            if capturedValues2.value18 then
                capturedValues2.value18:Disconnect()
            end
            if capturedValues2.value22 then
                capturedValues2.value22:Destroy()
            end
            if capturedValues2.value23 then
                capturedValues2.value23 = nil
            end
            local v225 = capturedValues2.value9.Character
            local v226 = v225
            if v225 then
                v226 = (v225:FindFirstChildOfClass("Humanoid"))
            end
            if v226 then
                v226 = v225.Humanoid
                v226.PlatformStand = false
                v230 = getgenv().walkSpeed
                v226.WalkSpeed = (v230 or 16)
                up46((getgenv().jumpPower or 50))
                v231 = v225:FindFirstChild("HumanoidRootPart")
                if v231 then
                    v228 = v231.CFrame
                    v233 = Vector3.new (0, .1, 0)
                    v231.CFrame = (v228 + v233)
                    task.wait (.1)
                    v231.CFrame = v228
                end
            end
            if capturedValues2.value24 then
                capturedValues2.value24:Set(false)
            end
            if v222 then
                capturedValues2.value1:Notify({["Title"] = "Fly Disabled", ["Content"] = "Flying disabled. Normal movement restored.", ["Duration"] = 5, ["Icon"] = "plane"})
            end
            return
        end
        v1202 = capturedValues2.value3.TouchStarted
        local v1242 = function(arg11_1)
            local v241 = arg11_1
            local v243 = getgenv()
            if v243["flyEnabled"] then
                capturedValues2.value23 = v241
            end
            return
        end
        v1202:Connect(v1242)
        v1202 = capturedValues2.value3.TouchEnded
        v1201 = v1202.Connect
        v1201(v1202, function(arg12_1)
            if (capturedValues2.value23 == arg12_1) then
            end
            return
        end)
        capturedValues2.value26 = nil
        local up52 = function()
            local v249, v250, v254
            if capturedValues2.value26 then
                return
            else
                v254 = capturedValues2.value9.Character
                local up7 = v254
                v250 = (not up7)
                v249 = v250
                if not (v250) then
                    v249 = (not (up7:FindFirstChild("HumanoidRootPart")))
                end
                if v249 then
                    return
                else
                    v254 = capturedValues2.value2.Stepped
                    v250 = function()
                        local v1400, v1403, v1405, v1407
                        local v1401 = getgenv()
                        if (not v1401.noClipEnabled ) then
                            capturedValues2.value26:Disconnect()
                            capturedValues2.value26 = nil
                            return
                        else
                            v1400 = up7:GetDescendants()
                            v1405 = ipairs
                            for v1403, v1407 in v1405(v1400) do
                                v1405 = v1407:IsA("BasePart")
                                if v1405 then
                                    v1407.CanCollide = false
                                end
                            end
                            return
                        end
                    end
                    capturedValues2.value26 = (v254:Connect(v250))

                    return
                end
            end
        end
        local up51 = function()
            local v262, v263, v264, v265, v266, v268
            local v259 = getgenv()
            v259.noClipEnabled = false
            if capturedValues2.value26 then
                capturedValues2.value26:Disconnect()
            end
            local v261 = capturedValues2.value9.Character
            if v261 then
                v262 = (v261:FindFirstChildOfClass("Humanoid"))
                if v262 then
                    v265 = getgenv()
                    if (not v265.flyEnabled ) then
                        v262.PlatformStand = false
                    end
                    v265 = getgenv().walkSpeed
                    v262.WalkSpeed = (v265 or 16)
                    v262.HipHeight = 0
                    up46((getgenv().jumpPower or 50))
                end
                v263 = (v261:GetDescendants())
                v264, v265, v266 = ipairs(v263)
                while true do
                    v266, v268 = v264(v265, v266)
                    if not v266 then
                        break
                    end
                    v259 = v268:IsA("BasePart")
                    if v259 then
                        v268.CanCollide = true
                    end
                end
                v264 = (v261:FindFirstChild("HumanoidRootPart"))
                if v264 then
                    v265 = v264.CFrame
                    v268 = Vector3.new (0, .1, 0)
                    v264.CFrame = (v265 + v268)
                    task.wait (.1)
                    v264.CFrame = v265
                end
            end
            return
        end
        capturedValues2.value27 = nil
        local up56 = function()
            if capturedValues2.value27 then
                return
            else
                capturedValues2.value27 = (task.spawn(function()
                    local v448, v449, v450, v451, v452, v453, v454
                    while true do
                        v449 = getgenv()
                        if not v449.antiAfkEnabled then
                            break
                        end
                        v449 = capturedValues2.value9.Character
                        v448 = v449 and (v449:FindFirstChild("HumanoidRootPart"))
                        if v448 then
                            v450 = v449.HumanoidRootPart
                            v451 = v450.CFrame
                            v454 = CFrame.Angles(0, (math.rad(1)), 0)
                            v450.CFrame = (v451 * v454)
                            task.wait(.1)
                            v450.CFrame = v451
                            capturedValues2.value6:CaptureController()
                            v453 = capturedValues2.value6
                            v452 = Vector2.new
                            v453:ClickButton1(v452(0, 0))
                        end
                        task.wait(300)
                    end
                    return
                end))

                return
            end
        end
        local up53 = function()
            local v279 = getgenv()
            v279.antiAfkEnabled = false
            if capturedValues2.value27 then
                task.cancel(capturedValues2.value27)
            end
            return
        end
        v1202 = capturedValues2.value9.CharacterAdded
        local v1248 = function(arg17_1)
            task.wait(1)
            local v289 = getgenv()
            if v289["flyEnabled"] then
                capturedValues2.value25()
            end
            v289 = getgenv()
            if v289["noClipEnabled"] then
                up52()
            end
            v289 = getgenv()
            if v289["antiAfkEnabled"] then
                up56()
            end
            capturedValues2.value12(getgenv().walkSpeed)
            up46(getgenv().jumpPower)

            return
        end
        v1202:Connect(v1248)
        v1248 = (v1204:Tab({["Title"] = "Auto-Farm Wins", ["Icon"] = "infinity", ["Locked"] = false}))
        v1248:Select()
        v1248:Divider()
        v1202 = v1248.Button
        local v1253 = function()
            local v294, v300, v301, v302
            local v298 = capturedValues2.value5:FindFirstChild("RewardClaimed")
            local v299 = v298
            if not (v298) then
                v299 = (capturedValues2.value5:WaitForChild("RewardClaimed"))
            end
            local up8 = v299
            if (not up8) then
                warn("RewardClaimed RemoteEvent not found!")

                return
            else
                v298 = {300, 700, 1100, 1500, 1900, 2200, 2600, 3000}
                v300 = ipairs
                for v294, v301 in v300(v298) do
                    local up9 = v301
                    v302 = function()
                        up8:FireServer(up9)
                        print(("Claimed reward: " .. up9))
                        return
                    end
                    pcall(v302)
                    v300 = task.wait
                    v301 = nil
                    v300(.1)
                end
                print("All wins claimed!")

                return
            end
        end
        v1202(v1248, {["Title"] = "Auto-Claim Wins", ["Desc"] = "Auto-Claim All Wins For You!", ["Locked"] = false, ["Callback"] = v1253})
        v1248:Divider()
        v1202 = v1248.Toggle
        local v1258 = function(arg19_1)
            local v307 = getgenv()
            v307.autoFarmEnabled = arg19_1
            print(("Toggle Activated: " .. (tostring(arg19_1))))
            if arg19_1 then
                task.spawn(capturedValues2.value15)
            else
                capturedValues2.value14()
            end
            return
        end
        v1202(v1248, {["Title"] = "Auto-Farm Wins (VIP)", ["Desc"] = "This Works Only in PRIVATE SERVERS and for people with VIP GAMEPASS AND WORKS AT 4:30 !!!", ["Icon"] = "check", ["Type"] = "Checkbox", ["Default"] = false, ["Callback"] = v1258})
        v1202 = v1248.Toggle
        local v1236 = function(arg20_1)
            local v314 = getgenv()
            v314.autoFarmAltEnabled = arg20_1
            print(("Alt Toggle Activated: " .. (tostring(arg20_1))))
            if arg20_1 then
                task.spawn(capturedValues2.value16)
            else
                capturedValues2.value14()
            end
            return
        end
        v1202(v1248, {["Title"] = "Auto-Farm Wins (NON-VIP)", ["Desc"] = "This Works Only in PRIVATE SERVERS TOO and for normal people without VIP GAMEPASS AND WORKS AT 3:00!!!", ["Icon"] = "check", ["Type"] = "Checkbox", ["Default"] = false, ["Callback"] = v1236})
        v1202 = v1248.Toggle
        local v1259 = function(arg21_1)
            local v321 = getgenv()
            v321.autoFarmNewEnabled = arg21_1
            print(("New Toggle Activated: " .. (tostring(arg21_1))))
            if arg21_1 then
                task.spawn(capturedValues2.value17)
            else
                capturedValues2.value14()
            end
            return
        end
        v1202(v1248, {["Title"] = "Auto-Farm Wins (Public Server)", ["Desc"] = "This works for public server and for all users!!!", ["Icon"] = "check", ["Type"] = "Checkbox", ["Default"] = false, ["Callback"] = v1259})
        local v1250 = (v1204:Tab({["Title"] = "Teleports", ["Icon"] = "map-pin", ["Locked"] = false}))
        v1250:Divider()
        v1202 = v1250.Button
        v1258 = function()
            local v329, v330, v332, v334
            local v328 = game.Players.LocalPlayer
            local v333 = v328
            if v328 then
                v330 = v328.Character
                v332 = v330
                if v330 then
                    v332 = (v328.Character:FindFirstChild("HumanoidRootPart"))
                end
                v333 = v332
            end
            if v333 then
                v334 = v328.Character.HumanoidRootPart
                v329 = CFrame.new(31.63, 219.06, 93.76)
                v334.CFrame = v329
            else
                warn("Player character or HumanoidRootPart not found!")
            end
            return
        end
        v1202(v1250, {["Title"] = "Teleport To the Top", ["Desc"] = "Teleports you to the top without any effort!", ["Locked"] = false, ["Callback"] = v1258})
        v1202 = v1250.Button
        v1236 = function()
            local v340, v341, v343, v345
            local v339 = game.Players.LocalPlayer
            local v344 = v339
            if v339 then
                v341 = v339.Character
                v343 = v341
                if v341 then
                    v343 = (v339.Character:FindFirstChild("HumanoidRootPart"))
                end
                v344 = v343
            end
            if v344 then
                v345 = v339.Character.HumanoidRootPart
                v340 = CFrame.new(-38462.02, 387.7, -18.68)
                v345.CFrame = v340
            else
                warn("Player character or HumanoidRootPart not found!")
            end
            return
        end
        v1202(v1250, {["Title"] = "Teleport To the Winners Room", ["Desc"] = "Teleports you to the Winners Room!", ["Locked"] = false, ["Callback"] = v1236})
        v1259 = function()
            local v351, v352, v354, v356
            local v350 = game.Players.LocalPlayer
            local v355 = v350
            if v350 then
                v352 = v350.Character
                v354 = v352
                if v352 then
                    v354 = (v350.Character:FindFirstChild("HumanoidRootPart"))
                end
                v355 = v354
            end
            if v355 then
                v356 = v350.Character.HumanoidRootPart
                v351 = CFrame.new(31.34, 219.23, 141.96)
                v356.CFrame = v351
            else
                warn("Player character or HumanoidRootPart not found!")
            end
            return
        end
        v1250:Button({["Title"] = "Teleport To Win Door", ["Desc"] = "Teleports you to the Win Door with ease!", ["Locked"] = false, ["Callback"] = v1259})
        v1250:Divider()
        v1202 = v1250.Button
        local v1260 = function()
            local v362, v363, v365, v367
            local v361 = game.Players.LocalPlayer
            local v366 = v361
            if v361 then
                v363 = v361.Character
                v365 = v363
                if v363 then
                    v365 = (v361.Character:FindFirstChild("HumanoidRootPart"))
                end
                v366 = v365
            end
            if v366 then
                v367 = v361.Character.HumanoidRootPart
                v362 = CFrame.new(-38447.61, 388.11, -43.25)
                v367.CFrame = v362
            else
                warn("Player character or HumanoidRootPart not found!")
            end
            return
        end
        v1202(v1250, {["Title"] = "Teleport To Tic-Tac-Toe Game", ["Desc"] = "Teleports you to the Tic-Tac-Toe area!", ["Locked"] = false, ["Callback"] = v1260})
        v1202 = v1250.Button
        local v1243 = function()
            local v373, v374, v376, v378
            local v372 = game.Players.LocalPlayer
            local v377 = v372
            if v372 then
                v374 = v372.Character
                v376 = v374
                if v374 then
                    v376 = (v372.Character:FindFirstChild("HumanoidRootPart"))
                end
                v377 = v376
            end
            if v377 then
                v378 = v372.Character.HumanoidRootPart
                v373 = CFrame.new(-38503.78, 378.79, 1.47)
                v378.CFrame = v373
            else
                warn("Player character or HumanoidRootPart not found!")
            end
            return
        end
        v1202(v1250, {["Title"] = "Teleport To Swimming Pool", ["Desc"] = "Teleports you to the Swimming Pool!", ["Locked"] = false, ["Callback"] = v1243})
        v1202 = v1250.Button
        local v1245 = function()
            local v384, v385, v387, v389
            local v383 = game.Players.LocalPlayer
            local v388 = v383
            if v383 then
                v385 = v383.Character
                v387 = v385
                if v385 then
                    v387 = (v383.Character:FindFirstChild("HumanoidRootPart"))
                end
                v388 = v387
            end
            if v388 then
                v389 = v383.Character.HumanoidRootPart
                v384 = CFrame.new(-38473.77, 381.34, 86.95)
                v389.CFrame = v384
            else
                warn("Player character or HumanoidRootPart not found!")
            end
            return
        end
        v1202(v1250, {["Title"] = "Teleport Near Confetti Button", ["Desc"] = "Teleports you near the Confetti Button!", ["Locked"] = false, ["Callback"] = v1245})
        v1250:Divider()
        v1202 = v1250.Button
        local v1261 = function()
            local v395, v396, v398, v400
            local v394 = game.Players.LocalPlayer
            local v399 = v394
            if v394 then
                v396 = v394.Character
                v398 = v396
                if v396 then
                    v398 = (v394.Character:FindFirstChild("HumanoidRootPart"))
                end
                v399 = v398
            end
            if v399 then
                v400 = v394.Character.HumanoidRootPart
                v395 = CFrame.new(-38501.7, 387.33, -40.36)
                v400.CFrame = v395
            else
                warn("Player character or HumanoidRootPart not found!")
            end
            return
        end
        v1202(v1250, {["Title"] = "Teleport To Parkour Minigame", ["Desc"] = "Teleports you to the Parkour Minigame!", ["Locked"] = false, ["Callback"] = v1261})
        v1202 = v1250.Button
        v1261 = "Callback"
        local v1238 = function()
            local v406, v407, v409, v411
            local v405 = game.Players.LocalPlayer
            local v410 = v405
            if v405 then
                v407 = v405.Character
                v409 = v407
                if v407 then
                    v409 = (v405.Character:FindFirstChild("HumanoidRootPart"))
                end
                v410 = v409
            end
            if v410 then
                v411 = v405.Character.HumanoidRootPart
                v406 = CFrame.new(31.63, 300, 93.76)
                v411.CFrame = v406
            else
                warn("Player character or HumanoidRootPart not found!")
            end
            return
        end
        v1202(v1250, {["Title"] = "Teleport To Roof Of Tower", ["Desc"] = "Teleports you to the Roof of the Tower!", ["Locked"] = false, [v1261] = v1238})
        v1236 = (v1204:Tab({["Title"] = "Cosmetics", ["Icon"] = "sparkles", ["Locked"] = false}))
        v1236:Divider()
        v1260 = (capturedValues2.value10:WaitForChild("HaloGui"):WaitForChild("MainFrame"))
        local v1262 = v1260.GetChildren
        capturedValues2.value28 = {}
        v1202 = ipairs
        for v1261, v1263 in v1202(v1262(v1260)) do
            v1202 = v1263:IsA("ScrollingFrame")
            if v1202 then
                table.insert(capturedValues2.value28, v1263)
            end
        end
        v1202 = function(arg35_1)
            local v447
            local v441 = ipairs
            local v443 = arg35_1
            for v445, v446 in v441(capturedValues2.value28) do
                v447 = (v446:FindFirstChild(v443))
                if v447 then
                    return v447
                end
            end
            return nil
        end
        capturedValues2.value29 = v1202
        v1238 = (capturedValues2.value10:WaitForChild("TrailsGUI"):WaitForChild("MainFrame"))
        capturedValues2.value30 = {}
        v1202 = ipairs
        local v1266 = v1238.GetChildren
        for v1264, v1266 in v1202(v1266(v1238)) do
            v1202 = v1266:IsA("ScrollingFrame")
            if v1202 then
                table.insert(capturedValues2.value30, v1266)
            end
        end
        v1202 = function(arg49_1)
            local v564, v567, v568, v570, v571
            v564, v567, v568 = ipairs(capturedValues2.value30)
            local v569 = arg49_1
            local v566 = v564
            while true do
                v568, v570 = v566(v567, v568)
                if not v568 then
                    break
                end
                v571 = (v570:FindFirstChild(v569))
                if v571 then
                    return v571
                end
            end
            return nil
        end
        capturedValues2.value31 = v1202
        v1202 = v1236.Button
        local v1272 = function()
            local v575 = capturedValues2.value9:WaitForChild("leaderstats"):WaitForChild("Wins").Value
            local v577 = {"Halo1"}
            local v572 = {["req"] = 0, ["halos"] = v577, ["name"] = "Green Halo"}
            local v573 = {"Halo2"}
            local v578 = {["req"] = 1, ["halos"] = v573, ["name"] = "Blue Halo"}
            local v580 = {"Halo3"}
            local v574 = {["req"] = 2, ["halos"] = v580, ["name"] = "Red Halo"}
            local v581 = {"Halo4"}
            local v576 = {["req"] = 3, ["halos"] = v581, ["name"] = "Pink Halo"}
            local v582 = {"Halo5"}
            v577 = {["req"] = 5, ["halos"] = v582, ["name"] = "White Halo"}
            local v583 = {"Halo6"}
            v573 = {["req"] = 10, ["halos"] = v583, ["name"] = "Purple Halo"}
            local v584 = {"Halo7"}
            v580 = {["req"] = 25, ["halos"] = v584, ["name"] = "Black Halo"}
            local v585 = {"Halo8"}
            v581 = {["req"] = 50, ["halos"] = v585, ["name"] = "Golden Halo"}
            local v586 = {"Halo9", "Halo16", "Halo17", "Halo18"}
            v582 = {["req"] = 100, ["halos"] = v586, ["names"] = {"Rainbow Halo", "Toxic Halo", "Water Halo", "Flame Halo"}}
            local v587 = {"Halo10"}
            v583 = {["req"] = 150, ["halos"] = v587, ["name"] = "Soul Halo"}
            v587 = "halos"
            local v588 = {"Halo11"}
            v584 = {["req"] = 250, [v587] = v588, ["name"] = "Inferno Halo"}
            v588 = "halos"
            local v589 = {"Halo12"}
            v585 = {["req"] = 500, [v588] = v589, ["name"] = "Universe Halo"}
            v578 = {v572, v578, v574, v576, v577, v573, v580, v581, v582, v583, v584, v585}
            v574 = v578[1]
            for v577, v581 in ipairs(v578) do
                if (v575 >= v581["req"]) then
                    v574 = v581
                    continue
                end
                break
            end
            v577 = math.random(1, (#v574.halos))
            v576 = v574.halos[v577]
            v573 = v574.names and v574.names[v577] or v574.name
            v581 = capturedValues2.value29(v576)
            if v581 then
                v580 = v581:FindFirstChild("Equip")
                if v580 then
                    v584 = 5
                    v585 = 1
                    for v583 = 1, v584, v585 do
                        capturedValues2.value7:FireServer("halo", "Equip", v576, v580)
                    end
                    v582 = capturedValues2.value1
                    v583 = v582.Notify
                    v588 = ("Equipped " .. (v573 .. (" based on your " .. (v575 .. " wins!"))))
                    v583(v582, {["Title"] = "Equipped Halo", ["Content"] = v588, ["Duration"] = 5, ["Icon"] = "sparkles"})
                else
                    v582 = capturedValues2.value1
                    v588 = ("Equip button not found for " .. v573)
                    v582:Notify({["Title"] = "Error", ["Content"] = v588, ["Duration"] = 5, ["Icon"] = "x"})
                end
            else
                v580 = capturedValues2.value1
                v587 = ("Halo frame not found for " .. v573)
                v580:Notify({["Title"] = "Error", ["Content"] = v587, ["Duration"] = 5, ["Icon"] = "x"})
            end
            return
        end
        v1202(v1236, {["Title"] = "Equip Best Halo", ["Desc"] = "Equips the best halo based on your wins!", ["Locked"] = false, ["Callback"] = v1272})
        local v1270 = {["Title"] = "Green Halo (0 wins)", ["HaloId"] = "Halo1", ["Req"] = 0}
        local v1271 = {["Title"] = "Blue Halo (1 win)", ["HaloId"] = "Halo2", ["Req"] = 1}
        v1272 = {["Title"] = "Red Halo (2 wins)", ["HaloId"] = "Halo3", ["Req"] = 2}
        local v1273 = {["Title"] = "Pink Halo (3 wins)", ["HaloId"] = "Halo4", ["Req"] = 3}
        local v1274 = {["Title"] = "White Halo (5 wins)", ["HaloId"] = "Halo5", ["Req"] = 5}
        local v1275 = {["Title"] = "Purple Halo (10 wins)", ["HaloId"] = "Halo6", ["Req"] = 10}
        local v1276 = {["Title"] = "Black Halo (25 wins)", ["HaloId"] = "Halo7", ["Req"] = 25}
        local v1277 = {["Title"] = "Golden Halo (50 wins)", ["HaloId"] = "Halo8", ["Req"] = 50}
        local v1278 = {["Title"] = "Rainbow Halo (100 wins)", ["HaloId"] = "Halo9", ["Req"] = 100}
        local v1279 = {["Title"] = "Soul Halo (150 wins)", ["HaloId"] = "Halo10", ["Req"] = 150}
        v1202 = v1236.Dropdown
        local v1280 = {["Title"] = "Inferno Halo (250 wins)", ["HaloId"] = "Halo11", ["Req"] = 250}
        local v1281 = {["Title"] = "Universe Halo (500 wins)", ["HaloId"] = "Halo12", ["Req"] = 500}
        local v1282 = {["Title"] = "Toxic Halo (100 wins)", ["HaloId"] = "Halo16", ["Req"] = 100}
        local v1283 = {["Title"] = "Water Halo (100 wins)", ["HaloId"] = "Halo17", ["Req"] = 100}
        local v1269 = {v1270, v1271, v1272, v1273, v1274, v1275, v1276, v1277, v1278, v1279, v1280, v1281, v1282, v1283, {["Title"] = "Flame Halo (100 wins)", ["HaloId"] = "Halo18", ["Req"] = 100}}
        v1273 = function(arg51_1)
            local v600, v601, v602, v603, v604, v605, v606, v607, v608, v612, v613
            local v598 = arg51_1
            local v599 = capturedValues2.value9:WaitForChild("leaderstats"):WaitForChild("Wins").Value
            if (v599 >= v598["Req"]) then
                v604 = (capturedValues2.value29(v598.HaloId ))
                if v604 then
                    v601 = (v604:FindFirstChild("Equip"))
                    if v601 then
                        v603 = 5
                        v606 = 1
                        for v602 = 1, v603, v606 do
                            capturedValues2.value7:FireServer("halo", "Equip", v598.HaloId, v601)
                        end
                        v605 = capturedValues2.value1
                        v608 = ("Equipped " .. (v598.Title .. "!"))
                        v605:Notify({["Title"] = "Equipped Halo", ["Content"] = v608, ["Duration"] = 5, ["Icon"] = "sparkles"})
                    else
                        v605 = capturedValues2.value1
                        v608 = ("Equip button not found for " .. v598.Title)
                        v605:Notify({["Title"] = "Error", ["Content"] = v608, ["Duration"] = 5, ["Icon"] = "x"})
                    end
                else
                    v605 = capturedValues2.value1
                    v607 = ("Halo frame not found for " .. v598.Title)
                    v605:Notify({["Title"] = "Error", ["Content"] = v607, ["Duration"] = 5, ["Icon"] = "x"})
                end
            else
                v605 = capturedValues2.value1
                v612 = v598.Req
                v613 = v598.Title
                v600 = v605.Notify
                v606 = ("You need " .. (v612 .. (" wins for " .. (v613 .. ("! You have " .. (v599 .. "."))))))
                v600(v605, {["Title"] = "Insufficient Wins", ["Content"] = v606, ["Duration"] = 5, ["Icon"] = "x"})
            end
            return
        end
        v1202(v1236, {["Title"] = "Select Halo to Equip", ["Values"] = v1269, ["Value"] = "Green Halo (0 wins)", ["Callback"] = v1273})
        v1236:Divider()
        v1202 = v1236.Button
        v1274 = function()
            local v624 = capturedValues2.value9:WaitForChild("leaderstats"):WaitForChild("Wins").Value
            local v626 = {"Trail1"}
            local v621 = {["req"] = 0, ["trails"] = v626, ["name"] = "Green Trail"}
            local v625 = {"Trail2"}
            local v627 = {["req"] = 1, ["trails"] = v625, ["name"] = "Blue Trail"}
            local v629 = {"Trail3"}
            local v622 = {["req"] = 2, ["trails"] = v629, ["name"] = "Red Trail"}
            local v630 = {"Trail4"}
            local v623 = {["req"] = 5, ["trails"] = v630, ["name"] = "Purple Trail"}
            local v631 = {"Trail5"}
            v626 = {["req"] = 10, ["trails"] = v631, ["name"] = "Orange Trail"}
            local v632 = {"Trail6"}
            v625 = {["req"] = 20, ["trails"] = v632, ["name"] = "Rainbow Trail"}
            local v633 = {"Trail7"}
            v629 = {["req"] = 30, ["trails"] = v633, ["name"] = "Universe Trail"}
            local v634 = {"Trail8"}
            v630 = {["req"] = 50, ["trails"] = v634, ["name"] = "Inferno Trail"}
            local v635 = {"Trail9"}
            v631 = {["req"] = 75, ["trails"] = v635, ["name"] = "Soul Trail"}
            local v636 = {"Trail10"}
            v632 = {["req"] = 100, ["trails"] = v636, ["name"] = "Toxic Trail"}
            v636 = "trails"
            local v637 = {"Trail11"}
            v633 = {["req"] = 150, [v636] = v637, ["name"] = "Water Trail"}
            v637 = "trails"
            local v638 = {"Trail12"}
            v634 = {["req"] = 200, [v637] = v638, ["name"] = "Flame Trail"}
            v627 = {v621, v627, v622, v623, v626, v625, v629, v630, v631, v632, v633, v634}
            v622 = v627[1]
            for v626, v630 in ipairs(v627) do
                if (v624 >= v630["req"]) then
                    v622 = v630
                    continue
                end
                break
            end
            v626 = math.random(1, (#v622.trails))
            v623 = v622.trails[v626]
            v625 = v622.names and v622.names[v626] or v622.name
            v630 = capturedValues2.value31(v623)
            if v630 then
                v629 = v630:FindFirstChild("Equip")
                if v629 then
                    v633 = 5
                    v634 = 1
                    for v632 = 1, v633, v634 do
                        capturedValues2.value7:FireServer("trail", "Equip", v623, v629)
                    end
                    v631 = capturedValues2.value1
                    v637 = ("Equipped " .. (v625 .. (" based on your " .. (v624 .. " wins!"))))
                    v631:Notify({["Title"] = "Equipped Trail", ["Content"] = v637, ["Duration"] = 5, ["Icon"] = "sparkles"})
                else
                    v631 = capturedValues2.value1
                    v637 = ("Equip button not found for " .. v625)
                    v633 = {["Title"] = "Error", ["Content"] = v637, ["Duration"] = 5, ["Icon"] = "x"}
                    v631:Notify(v633)
                end
            else
                v629 = capturedValues2.value1
                v636 = ("Trail frame not found for " .. v625)
                v629:Notify({["Title"] = "Error", ["Content"] = v636, ["Duration"] = 5, ["Icon"] = "x"})
            end
            return
        end
        v1202(v1236, {["Title"] = "Equip Best Trail", ["Desc"] = "Equips the best trail based on your wins!", ["Locked"] = false, ["Callback"] = v1274})
        v1272 = {["Title"] = "Green Trail (0 wins)", ["TrailId"] = "Trail1", ["Req"] = 0}
        v1273 = {["Title"] = "Blue Trail (1 win)", ["TrailId"] = "Trail2", ["Req"] = 1}
        v1274 = {["Title"] = "Red Trail (2 wins)", ["TrailId"] = "Trail3", ["Req"] = 2}
        v1275 = {["Title"] = "Purple Trail (5 wins)", ["TrailId"] = "Trail4", ["Req"] = 5}
        v1276 = {["Title"] = "Orange Trail (10 wins)", ["TrailId"] = "Trail5", ["Req"] = 10}
        v1277 = {["Title"] = "Rainbow Trail (20 wins)", ["TrailId"] = "Trail6", ["Req"] = 20}
        v1278 = {["Title"] = "Universe Trail (30 wins)", ["TrailId"] = "Trail7", ["Req"] = 30}
        v1279 = {["Title"] = "Inferno Trail (50 wins)", ["TrailId"] = "Trail8", ["Req"] = 50}
        v1280 = {["Title"] = "Soul Trail (75 wins)", ["TrailId"] = "Trail9", ["Req"] = 75}
        v1281 = {["Title"] = "Toxic Trail (100 wins)", ["TrailId"] = "Trail10", ["Req"] = 100}
        v1202 = v1236.Dropdown
        v1282 = {["Title"] = "Water Trail (150 wins)", ["TrailId"] = "Trail11", ["Req"] = 150}
        v1271 = {v1272, v1273, v1274, v1275, v1276, v1277, v1278, v1279, v1280, v1281, v1282, {["Title"] = "Flame Trail (200 wins)", ["TrailId"] = "Trail12", ["Req"] = 200}}
        v1275 = function(arg53_1)
            local v649, v650, v652, v653, v654, v655, v656, v657, v661, v662
            local v648 = capturedValues2.value9
            local v651 = arg53_1
            v648 = v648:WaitForChild("leaderstats"):WaitForChild("Wins")
            local v647 = v648.Value
            if (v647 >= v651["Req"]) then
                v653 = (capturedValues2.value31(v651.TrailId ))
                if v653 then
                    v649 = (v653:FindFirstChild("Equip"))
                    if v649 then
                        v652 = 5
                        v655 = 1
                        for v650 = 1, v652, v655 do
                            capturedValues2.value7:FireServer("trail", "Equip", v651.TrailId, v649)
                        end
                        v654 = capturedValues2.value1
                        v657 = ("Equipped " .. (v651.Title .. "!"))
                        v654:Notify({["Title"] = "Equipped Trail", ["Content"] = v657, ["Duration"] = 5, ["Icon"] = "sparkles"})
                    else
                        v654 = capturedValues2.value1
                        v657 = ("Equip button not found for " .. v651.Title)
                        v650 = {["Title"] = "Error", ["Content"] = v657, ["Duration"] = 5, ["Icon"] = "x"}
                        v654:Notify(v650)
                    end
                else
                    v654 = capturedValues2.value1
                    v656 = ("Trail frame not found for " .. v651.Title)
                    v654:Notify({["Title"] = "Error", ["Content"] = v656, ["Duration"] = 5, ["Icon"] = "x"})
                end
            else
                v654 = capturedValues2.value1
                v661 = v651.Req
                v662 = v651.Title
                v648 = v654.Notify
                v655 = ("You need " .. (v661 .. (" wins for " .. (v662 .. ("! You have " .. (v647 .. "."))))))
                v648(v654, {["Title"] = "Insufficient Wins", ["Content"] = v655, ["Duration"] = 5, ["Icon"] = "x"})
            end
            return
        end
        v1202(v1236, {["Title"] = "Select Trail to Equip", ["Values"] = v1271, ["Value"] = "Green Trail (0 wins)", ["Callback"] = v1275})
        v1236:Divider()
        v1202 = v1236.Button
        v1276 = function()
            local v672 = capturedValues2.value9:WaitForChild("leaderstats"):WaitForChild("Wins").Value
            local v675 = {"Noob"}
            local v671 = {["req"] = 0, ["titles"] = v675, ["name"] = "Noob"}
            local v670 = {"Pro"}
            local v676 = {["req"] = 5, ["titles"] = v670, ["name"] = "Pro"}
            local v678 = {"SUPER Pro"}
            local v673 = {["req"] = 10, ["titles"] = v678, ["name"] = "SUPER Pro"}
            local v679 = {"Ultra Pro"}
            local v674 = {["req"] = 15, ["titles"] = v679, ["name"] = "Ultra Pro"}
            local v680 = {"Ultra Speedster"}
            v675 = {["req"] = 25, ["titles"] = v680, ["name"] = "Ultra Speedster"}
            local v681 = {"SPEEDRUNNER"}
            v670 = {["req"] = 40, ["titles"] = v681, ["name"] = "SPEEDRUNNER"}
            local v682 = {"GOD GAMER"}
            v678 = {["req"] = 50, ["titles"] = v682, ["name"] = "GOD GAMER"}
            local v683 = {"GODLY"}
            v679 = {["req"] = 75, ["titles"] = v683, ["name"] = "GODLY"}
            local v684 = {"Destroyer"}
            v680 = {["req"] = 100, ["titles"] = v684, ["name"] = "Destroyer"}
            local v685 = {"THE INFERNO"}
            v681 = {["req"] = 150, ["titles"] = v685, ["name"] = "THE INFERNO"}
            local v686 = {"THE UNIVERSE"}
            v682 = {["req"] = 500, ["titles"] = v686, ["name"] = "THE UNIVERSE"}
            v676 = {v671, v676, v673, v674, v675, v670, v678, v679, v680, v681, v682}
            v673 = v676[1]
            for v675, v679 in ipairs(v676) do
                if (v672 >= v679["req"]) then
                    v673 = v679
                    continue
                end
                break
            end
            v675 = math.random(1, (#v673.titles))
            v674 = v673.titles[v675]
            v670 = v673.name
            v678 = ((v674 == "THE UNIVERSE") and "THE UNIVERSE \240\159\140\140" or v674)
            v681 = 5
            v682 = 1
            for v680 = 1, v681, v682 do
                capturedValues2.value8:FireServer(v678, true)
            end
            v679 = capturedValues2.value1
            v680 = v679.Notify
            v685 = ("Equipped " .. (v670 .. (" based on your " .. (v672 .. " wins!"))))
            v680(v679, {["Title"] = "Equipped Title", ["Content"] = v685, ["Duration"] = 5, ["Icon"] = "sparkles"})

            return
        end
        v1202(v1236, {["Title"] = "Equip Best Title", ["Desc"] = "Equips the best title based on your wins!", ["Locked"] = false, ["Callback"] = v1276})
        v1274 = {["Title"] = "Noob (0 wins)", ["TitleId"] = "Noob", ["Req"] = 0}
        v1275 = {["Title"] = "Pro (5 wins)", ["TitleId"] = "Pro", ["Req"] = 5}
        v1276 = {["Title"] = "SUPER Pro (10 wins)", ["TitleId"] = "SUPER Pro", ["Req"] = 10}
        v1277 = {["Title"] = "Ultra Pro (15 wins)", ["TitleId"] = "Ultra Pro", ["Req"] = 15}
        v1278 = {["Title"] = "Ultra Speedster (25 wins)", ["TitleId"] = "Ultra Speedster", ["Req"] = 25}
        v1279 = {["Title"] = "SPEEDRUNNER (40 wins)", ["TitleId"] = "SPEEDRUNNER", ["Req"] = 40}
        v1280 = {["Title"] = "GOD GAMER (50 wins)", ["TitleId"] = "GOD GAMER", ["Req"] = 50}
        v1281 = {["Title"] = "GODLY (75 wins)", ["TitleId"] = "GODLY", ["Req"] = 75}
        v1282 = {["Title"] = "Destroyer (100 wins)", ["TitleId"] = "Destroyer", ["Req"] = 100}
        v1283 = {["Title"] = "THE INFERNO (150 wins)", ["TitleId"] = "THE INFERNO", ["Req"] = 150}
        v1202 = v1236.Dropdown
        v1273 = {v1274, v1275, v1276, v1277, v1278, v1279, v1280, v1281, v1282, v1283, {["Title"] = "THE UNIVERSE (500 wins)", ["TitleId"] = "THE UNIVERSE \240\159\140\140", ["Req"] = 500}}
        v1277 = function(arg55_1)
            local v696, v697, v702, v703, v708
            local v695 = capturedValues2.value9
            local v700 = "leaderstats"
            local v701 = arg55_1
            v695 = v695:WaitForChild(v700):WaitForChild("Wins")
            local v698 = v695.Value
            if (v698 >= v701["Req"]) then
                v696 = 5
                v697 = 1
                for v700 = 1, v696, v697 do
                    v702 = capturedValues2.value8
                    v708 = v701.TitleId
                    v702:FireServer(v708, true)
                end
                v702 = capturedValues2.value1
                v703 = ("Equipped " .. (v701.Title .. "!"))
                v702:Notify({["Title"] = "Equipped Title", ["Content"] = v703, ["Duration"] = 5, ["Icon"] = "sparkles"})
            else
                v702 = capturedValues2.value1
                v703 = ("You need " .. (v701.Req .. (" wins for " .. (v701.Title .. ("! You have " .. (v698 .. "."))))))
                v702:Notify({["Title"] = "Insufficient Wins", ["Content"] = v703, ["Duration"] = 5, ["Icon"] = "x"})
            end
            return
        end
        v1202(v1236, {["Title"] = "Select Title to Equip", ["Values"] = v1273, ["Value"] = "Noob (0 wins)", ["Callback"] = v1277})
        v1270 = (v1204:Tab({["Title"] = "Player", ["Icon"] = "user", ["Locked"] = false}))
        v1270:Divider()
        v1202 = v1270.Slider
        v1279 = {["Min"] = 1, ["Max"] = 100, ["Default"] = 16}
        v1281 = function(arg56_1)
            local v718 = getgenv()
            v718.walkSpeed = arg56_1
            capturedValues2.value12(arg56_1)
            print(("WalkSpeed set to: " .. arg56_1))

            return
        end
        v1202(v1270, {["Title"] = "Speed", ["Desc"] = "Adjust your walk speed (1-100). You can drag or type a value.", ["Step"] = 1, ["Value"] = v1279, ["Callback"] = v1281})
        v1202 = v1270.Slider
        v1280 = {["Min"] = 1, ["Max"] = 200, ["Default"] = 50}
        v1282 = function(arg57_1)
            local v725 = getgenv()
            v725.jumpPower = arg57_1
            up46(arg57_1)
            print(("JumpPower set to: " .. arg57_1))

            return
        end
        v1202(v1270, {["Title"] = "JumpPower", ["Desc"] = "Adjust your jump power (1-200). You can drag or type a value.", ["Step"] = 1, ["Value"] = v1280, ["Callback"] = v1282})
        v1270:Divider()
        v1202 = v1270.Toggle
        local v1285 = function(arg58_1)
            local v732 = getgenv()
            v732.flyEnabled = arg58_1
            local v733 = FlyToggle
            print(("Fly Toggle Activated: " .. (tostring(arg58_1))))
            if arg58_1 then
                capturedValues2.value25()
                capturedValues2.value1:Notify({["Title"] = "Fly Enabled", ["Content"] = "You can now fly! PC: WASD, Space (up), Ctrl (down). Mobile: Touch left for direction, right for up/down.", ["Duration"] = 5, ["Icon"] = "plane"})
            else
                up43()
            end
            return
        end
        v1202(v1270, {["Title"] = "Fly", ["Desc"] = "Enables or disables flying! (PC: WASD, Space (up), Ctrl (down); Mobile: Touch controls)", ["Icon"] = "plane", ["Type"] = "Checkbox", ["Default"] = false, ["Callback"] = v1285})
        v1202 = v1270.Toggle
        local v1286 = function(arg59_1)
            local v748, v754, v755
            local v749 = getgenv()
            local v750 = arg59_1
            if (v749["noClipEnabled"] ~= v750) then
                v754 = getgenv()
                v754.noClipEnabled = v750
                print(("NoClip Toggle Activated: " .. (tostring(v750))))
                if v750 then
                    up52()
                    v755 = capturedValues2.value1
                    v748 = {["Title"] = "NoClip Enabled", ["Content"] = "You can now pass through walls and objects!", ["Duration"] = 5, ["Icon"] = "ghost"}
                    v755:Notify(v748)
                else
                    up51()
                    capturedValues2.value1:Notify({["Title"] = "NoClip Disabled", ["Content"] = "Collisions restored.", ["Duration"] = 5, ["Icon"] = "ghost"})
                end
            end
            return
        end
        v1202(v1270, {["Title"] = "NoClip", ["Desc"] = "Allows you to pass through walls and objects!", ["Icon"] = "ghost", ["Type"] = "Checkbox", ["Default"] = false, ["Callback"] = v1286})
        v1202 = v1270.Toggle
        local v1287 = function(arg60_1)
            local v763 = getgenv()
            v763.InfJumpEnabled = arg60_1
            print(("Infinite Jump Toggle Activated: " .. (tostring(arg60_1))))

            return
        end
        v1202(v1270, {["Title"] = "Infinite Jump", ["Desc"] = "Hold or tap jump to bounce infinitely", ["Icon"] = "arrow-up", ["Type"] = "Checkbox", ["Default"] = false, ["Callback"] = v1287})
        v1202 = v1270.Toggle
        local v1288 = function(arg61_1)
            local v776
            local v770 = arg61_1
            local v772 = getgenv()
            if (v772["antiAfkEnabled"] ~= v770) then
                v776 = getgenv()
                v776.antiAfkEnabled = v770
                print(("Anti-AFK Toggle Activated: " .. (tostring(v770))))
                if v770 then
                    up56()
                    capturedValues2.value1:Notify({["Title"] = "Anti-AFK Enabled", ["Content"] = "You will no longer be kicked for inactivity!", ["Duration"] = 5, ["Icon"] = "clock"})
                else
                    up53()
                    capturedValues2.value1:Notify({["Title"] = "Anti-AFK Disabled", ["Content"] = "Anti-AFK system stopped.", ["Duration"] = 5, ["Icon"] = "clock"})
                end
            end
            return
        end
        v1202(v1270, {["Title"] = "Anti-AFK", ["Desc"] = "Prevents you from being kicked for inactivity!", ["Icon"] = "clock", ["Type"] = "Checkbox", ["Default"] = false, ["Callback"] = v1288})
        v1202 = capturedValues2.value3.InputBegan
        v1278 = function(arg62_1, arg62_2)
            local v794, v795
            local v785 = arg62_1
            if arg62_2 then
                return
            else
                v794 = (v785.KeyCode == Enum.KeyCode.Space)
                v795 = v794
                if not (v794) then
                    v795 = (v785.UserInputType == Enum.UserInputType.Touch)
                end
                if v795 then
                    jumping = true
                end
                return
            end
        end
        v1202:Connect(v1278)
        v1202 = capturedValues2.value3.InputEnded
        v1278 = function(arg63_1)
            local v797 = arg63_1
            local v806 = (v797.KeyCode == Enum.KeyCode.Space)
            local v807 = v806
            if not (v806) then
                v807 = (v797.UserInputType == Enum.UserInputType.Touch)
            end
            if v807 then
                jumping = false
            end
            return
        end
        v1202:Connect(v1278)
        task.spawn(function()
            local v809, v810, v811, v813
            while true do
                v809 = task.wait(.05)
                if not v809 then
                    break
                end
                v809 = getgenv().InfJumpEnabled and jumping
                if v809 then
                    v813 = capturedValues2.value9.Character
                    if v813 then
                        v810 = (v813:FindFirstChildOfClass("Humanoid"))
                        v809 = v810
                        if v810 then
                            v809 = ((v810:GetState()) ~= Enum.HumanoidStateType.Dead)
                        end
                        if v809 then
                            v811 = Enum.HumanoidStateType
                            v810:ChangeState(v811.Jumping)
                        end
                    end
                end
            end
            return
        end)
        v1277 = (v1204:Tab({["Title"] = "Performance ", ["Icon"] = "cpu", ["Locked"] = false}))
        v1277:Divider()
        v1202 = v1277.Toggle
        v1285 = function(arg65_1)
            local v827, v829, v835, v836, v838, v839, v841, v842
            local v823 = arg65_1
            local v825 = pairs
            local v826 = game
            local v831 = v826.Players
            local v830 = v831.GetPlayers
            for v833, v826 in v825(v830(v831)) do
                v827 = game.Players
                if (v826 ~= v827["LocalPlayer"]) then
                    v830 = v826.Character
                    if v830 then
                        v835 = v830.GetDescendants
                        v825 = pairs
                        for v829, v835 in v825(v835(v830)) do
                            v839 = v835:IsA("BasePart")
                            v825 = v839
                            if not (v839) then
                                v825 = (v835:IsA("Decal"))
                            end
                            if v825 then
                                v841 = v835.Name:lower():find("halo")
                                v836 = v841
                                if not (v841) then
                                    v838 = v835:IsA("Accessory")
                                    v841 = v838
                                    if v838 then
                                        v842 = v835:FindFirstChildWhichIsA("BasePart")
                                        v838 = v842
                                        if v842 then
                                            v838 = (v835:FindFirstChildWhichIsA("BasePart").Name:lower():find("halo"))
                                        end
                                        v841 = v838
                                    end
                                    v836 = v841
                                end
                                if (not v836) then
                                    if v823 then
                                        v836 = v835:GetAttribute("OriginalTransparency")
                                        if (not v836) then
                                            v825 = v835.SetAttribute
                                            v839 = v835.Transparency
                                            v825(v835, "OriginalTransparency", v839)
                                        end
                                        v835.Transparency = 1
                                    else
                                        v836 = ((v835:GetAttribute("OriginalTransparency")) or 0)
                                        v835.Transparency = v836
                                    end
                                end
                            end
                        end
                    end
                end
            end
            return
        end
        v1202(v1277, {["Title"] = "Hide Players", ["Default"] = false, ["Callback"] = v1285})
        v1202 = v1277.Toggle
        v1286 = function(arg66_1)
            local v853, v855, v861, v862, v863, v864, v866, v867, v868, v869
            local v872
            local v848 = arg66_1
            local v849 = v848
            local v851 = pairs
            local v852 = game
            local v857 = v852.Players
            local v856 = v857.GetPlayers
            for v859, v852 in v851(v856(v857)) do
                v853 = game.Players
                if (v852 ~= v853["LocalPlayer"]) then
                    v856 = v852.Character
                    if v856 then
                        v851 = pairs
                        v861 = v856.GetDescendants
                        for v855, v861 in v851(v861(v856)) do
                            v867 = v861:IsA("BasePart")
                            v868 = v867
                            if v867 then
                                v868 = (v861.Name:lower():find("halo"))
                            end
                            v851 = v868
                            if not (v868) then
                                v867 = v861:IsA("Accessory")
                                v868 = v867
                                if v867 then
                                    v863 = v861:FindFirstChildWhichIsA("BasePart")
                                    v867 = v863
                                    if v863 then
                                        v867 = (v861:FindFirstChildWhichIsA("BasePart").Name:lower():find("halo"))
                                    end
                                    v868 = v867
                                end
                                v851 = v868
                            end
                            v862 = v851
                            v851 = v862
                            if v862 then
                                v851 = (v861:IsA("BasePart")) or (v861:IsA("Decal"))
                            end
                            if v851 then
                                if v848 then
                                    v868 = v861:GetAttribute("OriginalTransparency")
                                    if (not v868) then
                                        v851 = v861.SetAttribute
                                        v872 = v861.Transparency
                                        v851(v861, "OriginalTransparency", v872)
                                    end
                                    v861.Transparency = 1
                                else
                                    v868 = ((v861:GetAttribute("OriginalTransparency")) or 0)
                                    v861.Transparency = v868
                                end
                            end
                            v872 = v861:IsA("ParticleEmitter")
                            v851 = v872
                            if not (v872) then
                                v866 = v861:IsA("Beam")
                                v872 = v866
                                if not (v866) then
                                    v864 = v861:IsA("Smoke")
                                    v866 = v864
                                    if not (v864) then
                                        v869 = v861:IsA("Fire")
                                        v864 = v869
                                        if not (v869) then
                                            v864 = (v861:IsA("Sparkles"))
                                        end
                                        v866 = v864
                                    end
                                    v872 = v866
                                end
                                v851 = v872
                            end
                            if v851 then
                                v868 = false
                                v872 = v861.Parent
                                while true do
                                    if not v872 then
                                        break
                                    end
                                    v864 = v872:IsA("BasePart")
                                    v866 = v864
                                    if v864 then
                                        v866 = (v872.Name:lower():find("halo"))
                                    end
                                    v851 = v866
                                    if not (v866) then
                                        v864 = v872:IsA("Accessory")
                                        v866 = v864
                                        if v864 then
                                            v869 = v872:FindFirstChildWhichIsA("BasePart")
                                            v864 = v869
                                            if v869 then
                                                v864 = (v872:FindFirstChildWhichIsA("BasePart").Name:lower():find("halo"))
                                            end
                                            v866 = v864
                                        end
                                        v851 = v866
                                    end
                                    if v851 then
                                        v868 = true
                                    else
                                        v872 = v872.Parent
                                        continue
                                    end
                                    break
                                end
                                if v868 then
                                    v863 = (not v848)
                                    v861.Enabled = v863
                                end
                            end
                        end
                    end
                end
            end
            return
        end
        v1202(v1277, {["Title"] = "Hide Halos", ["Default"] = false, ["Callback"] = v1286})
        v1202 = v1277.Toggle
        v1287 = function(arg67_1)
            local v881, v883, v889, v890, v891, v893, v894, v896, v899
            local v876 = arg67_1
            local v879 = pairs
            local v880 = game
            local v885 = v880.Players
            local v884 = v885.GetPlayers
            for v887, v880 in v879(v884(v885)) do
                v881 = game.Players
                if (v880 ~= v881["LocalPlayer"]) then
                    v884 = v880.Character
                    if v884 then
                        v889 = v884.GetDescendants
                        v879 = pairs
                        for v883, v889 in v879(v889(v884)) do
                            v879 = v889:IsA("Trail")
                            if v879 then
                                v890 = (not v876)
                                v889.Enabled = v890
                            end
                            v893 = v889:IsA("ParticleEmitter")
                            v891 = v893
                            if not (v893) then
                                v894 = v889:IsA("Beam")
                                v893 = v894
                                if not (v894) then
                                    v896 = v889:IsA("Smoke")
                                    v894 = v896
                                    if not (v896) then
                                        v899 = v889:IsA("Fire")
                                        v896 = v899
                                        if not (v899) then
                                            v896 = (v889:IsA("Sparkles"))
                                        end
                                        v894 = v896
                                    end
                                    v893 = v894
                                end
                                v891 = v893
                            end
                            v879 = v891
                            if v891 then
                                v893 = v889.Parent
                                v891 = v893
                                if v893 then
                                    v891 = (v889.Parent:IsA("Trail"))
                                end
                                v879 = v891
                            end
                            if v879 then
                                v890 = (not v876)
                                v889.Enabled = v890
                            end
                        end
                    end
                end
            end
            return
        end
        v1202(v1277, {["Title"] = "Hide Trails", ["Default"] = false, ["Callback"] = v1287})
        v1202 = v1277.Toggle
        v1288 = function(arg68_1)
            local v909, v911, v917, v920, v921, v922, v923, v924
            local v904 = arg68_1
            local v907 = pairs
            local v908 = game
            local v913 = v908.Players
            local v912 = v913.GetPlayers
            for v915, v908 in v907(v912(v913)) do
                v909 = game.Players
                if (v908 ~= v909["LocalPlayer"]) then
                    v912 = v908.Character
                    if v912 then
                        v907 = pairs
                        v917 = v912.GetDescendants
                        for v911, v917 in v907(v917(v912)) do
                            v922 = v917:IsA("BillboardGui")
                            v907 = v922
                            if v922 then
                                v907 = (v917.Name == "Nametag")
                            end
                            if v907 then
                                v907 = pairs
                                v920 = v917.GetChildren
                                for v923, v920 in v907(v920(v917)) do
                                    v924 = v920:IsA("TextLabel")
                                    v907 = v924
                                    if v924 then
                                        v907 = (v920.Name == "Username")
                                    end
                                    if v907 then
                                        if v904 then
                                            v921 = v920:GetAttribute("OriginalVisible")
                                            if (not v921) then
                                                v907 = v920.SetAttribute
                                                v924 = v920.Visible
                                                v907(v920, "OriginalVisible", v924)
                                            end
                                            v920.Visible = false
                                        else
                                            v921 = ((v920:GetAttribute("OriginalVisible")) ~= false)
                                            v920.Visible = v921
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            return
        end
        v1202(v1277, {["Title"] = "Hide Usernames", ["Default"] = false, ["Callback"] = v1288})
        v1202 = v1277.Toggle
        local v1289 = function(arg69_1)
            local v935, v937, v943, v946, v947, v948, v949, v950
            local v930 = arg69_1
            local v933 = pairs
            local v934 = game
            local v939 = v934.Players
            local v938 = v939.GetPlayers
            for v941, v934 in v933(v938(v939)) do
                v935 = game.Players
                if (v934 ~= v935["LocalPlayer"]) then
                    v938 = v934.Character
                    if v938 then
                        v933 = pairs
                        v943 = v938.GetDescendants
                        for v937, v943 in v933(v943(v938)) do
                            v946 = v943:IsA("BillboardGui")
                            v933 = v946
                            if v946 then
                                v933 = (v943.Name == "Nametag")
                            end
                            if v933 then
                                v947 = v943.GetChildren
                                v933 = pairs
                                for v949, v947 in v933(v947(v943)) do
                                    v950 = v947:IsA("TextLabel")
                                    v933 = v950
                                    if v950 then
                                        v933 = (v947.Name == "Wins")
                                    end
                                    if v933 then
                                        if v930 then
                                            v948 = v947:GetAttribute("OriginalVisible")
                                            if (not v948) then
                                                v933 = v947.SetAttribute
                                                v950 = v947.Visible
                                                v933(v947, "OriginalVisible", v950)
                                            end
                                            v947.Visible = false
                                        else
                                            v948 = ((v947:GetAttribute("OriginalVisible")) ~= false)
                                            v947.Visible = v948
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            return
        end
        v1202(v1277, {["Title"] = "Hide Wins", ["Default"] = false, ["Callback"] = v1289})
        local v1290 = function(arg70_1)
            local v958, v959, v960, v962
            local v956 = arg70_1
            local v963 = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
            if v963 then
                v958 = (v963:FindFirstChild("HeightGui"))
                if v958 then
                    v962 = (v958:FindFirstChild("Frame"))
                    v959 = (v958:FindFirstChild("Players"))
                    if v962 then
                        if v956 then
                            v960 = v962:GetAttribute("OriginalVisible")
                            if (not v960) then
                                v962:SetAttribute("OriginalVisible", v962.Visible)
                            end
                            v962.Visible = false
                        else
                            v960 = ((v962:GetAttribute("OriginalVisible")) ~= false)
                            v962.Visible = v960
                        end
                    end
                    if v959 then
                        if v956 then
                            v960 = v959:GetAttribute("OriginalVisible")
                            if (not v960) then
                                v959:SetAttribute("OriginalVisible", v959.Visible)
                            end
                            v959.Visible = false
                        else
                            v960 = ((v959:GetAttribute("OriginalVisible")) ~= false)
                            v959.Visible = v960
                        end
                    end
                end
            end
            return
        end
        v1277:Toggle({["Title"] = "Hide Height Bar", ["Default"] = false, ["Callback"] = v1290})
        v1285 = (v1203:Section({["Title"] = "Community", ["Icon"] = "users", ["Opened"] = true}):Tab({["Title"] = "Discord", ["Icon"] = "link"}))
        v1202 = v1285.Button
        local v1294 = function()
            local v970 = "https://discord.gg/XV66VWqAaN"
            if setclipboard then
                setclipboard(v970)
                capturedValues2.value1:Notify({["Title"] = "Discord Invite Copied", ["Desc"] = "Link copied to clipboard! Paste in Discord to join.", ["Duration"] = 5})
            else
                capturedValues2.value1:Notify({["Title"] = "Clipboard Unsupported", ["Desc"] = "Your executor doesn\226\128\153t support clipboard functions.", ["Duration"] = 5})
            end
            return
        end
        v1202(v1285, {["Title"] = "Join Our Discord", ["Desc"] = "Click to copy the invite link to clipboard.", ["Icon"] = "link", ["Callback"] = v1294})

        return
    end
    spilledValues1.value1, spilledValues1.value2 = pcall(v1186)
    if (not spilledValues1.value1) then
        warn("Script error:", spilledValues1.value2)
        game:GetService("StarterGui"):SetCore("SendNotification", {["Title"] = "Mystrix Hub", ["Text"] = "Script loaded with errors. Join Discord for help.", ["Duration"] = 5})
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {["Title"] = "Mystrix Hub", ["Text"] = "Successfully loaded", ["Duration"] = 3})
    end
    return
end
capturedValues1.value17.LoadScript = v1449
local v1451 = capturedValues1.value17.new()
capturedValues1.value18 = v1451
capturedValues1.value19 = (v1441())
if capturedValues1.value19 then
    task.spawn(function()
        local v985, v986, v987
        local v981 = capturedValues1.value14
        local v983 = {v981(capturedValues1.value19)}
        local v984 = v983[2]
        if v983[1] then
            v981 = capturedValues1.value18
            v981.verified = true
            v983 = (capturedValues1.value16())
            task.wait(0.5)
            capturedValues1.value18:LoadScript()
            task.wait(3)
            if v983 then
                v983:Destroy()
            end
        else
            capturedValues1.value18:CreateMainGUI()
            task.wait(0.5)
            v987 = capturedValues1.value18
            if v987.mainFrame then
                v983 = (capturedValues1.value18.mainFrame:FindFirstChild("KeyBox"))
                if v983 then
                    v987 = capturedValues1.value19
                    v983.Text = v987
                    if (v984 == "EXPIRED") then
                        v985 = (capturedValues1.value18.mainFrame:FindFirstChild("StatusLabel"))
                        if v985 then
                            v985.Text = "Your saved key has expired"
                            v986 = Color3.fromRGB(255, 100, 100)
                            v985.TextColor3 = v986
                        end
                    end
                end
            end
        end
        return
    end)
else
    capturedValues1.value18:CreateMainGUI()
end
return
