-- This file was generated at discord.gg/syncrypt

local spilledValues1 = {}
local capturedValues1 = {}
local unpackValues = unpack or table.unpack



while true do
    task.wait ()
    spilledValues1.value2 = game:IsLoaded()
    if spilledValues1.value2 then
        break
    end
end
if (not LPH_OBFUSCATED) then
    LPH_JIT = function(...)
        return ...
    end
    LPH_JIT_MAX = function(...)
        return ...
    end
    LPH_NO_VIRTUALIZE = function(...)
        return ...
    end
    LPH_ENCSTR = function(arg46_1)
        return arg46_1
    end
    LPH_HIDECALLS = function(arg47_1)
        return arg47_1
    end
end
local v603 = game
spilledValues1.value5, spilledValues1.value4 = 12834712622936, "b!\133*\0179\008"
local v601 = v603:GetService("Players")
v603 = game
spilledValues1.value5, spilledValues1.value6 = "\190&}\244\230\129A\223\233\184\176\r", 33503604964593
local v606 = v603:GetService("TweenService")
capturedValues1.value1 = v606
v606 = game
spilledValues1.value6, spilledValues1.value3 = 32235748178594, v606.GetService
spilledValues1.value3 = spilledValues1.value3(v606, "HttpService")
spilledValues1.value8, spilledValues1.value7 = 21355818788568, "\031\027\138\007\\\249 \169Da5"
capturedValues1.value2 = spilledValues1.value3
spilledValues1.value3 = v601.LocalPlayer
capturedValues1.value3 = spilledValues1.value3
local v607 = getgenv()
capturedValues1.value4 = v607
spilledValues1.value7 = LPH_ENCSTR("https://nxthub.my.id")
local v619 = LPH_ENCSTR("https://nxthub.my.id/script/loader_main.lua")
local v620 = LPH_ENCSTR("https://nxthub.my.id/script/NextUI.lua")
local v622 = LPH_ENCSTR("https://discord.gg/hJayhS9ZYZ")
v607 = {["SERVER_URL"] = spilledValues1.value7, ["LoaderScriptURL"] = v619, ["NextUIURL"] = v620, ["DiscordLink"] = v622, ["AUTH_TIMEOUT"] = 15}
capturedValues1.value5 = v607
spilledValues1.value5 = LPH_ENCSTR("NextHub")
capturedValues1.value6 = spilledValues1.value5
spilledValues1.value7 = LPH_ENCSTR("NextHub/Key.txt")
capturedValues1.value7 = spilledValues1.value7
spilledValues1.value7 = LPH_NO_VIRTUALIZE
local v618 = function()
    local up15 = ""
    local v289 = function()
        local v367, v369
        local v365 = isfolder
        local v366 = v365
        if v365 then
            v367 = isfile
            v365 = v367 and readfile
            v369, v366 = 7671208, v365
        end
        if v366 then
            v366 = (isfolder(capturedValues1.value6)) and (isfile(capturedValues1.value7))
            if v366 then
                up15 = (readfile(capturedValues1.value7))
            end
        end
        return
    end
    pcall(v289)

    return up15
end
spilledValues1.value6 = spilledValues1.value7(function(arg19_1)
    local up16
    local v291 = function()
        local v458 = makefolder and (not (isfolder(capturedValues1.value6)))
        if v458 then
            makefolder(capturedValues1.value6)
        end
        if writefile then
            writefile(capturedValues1.value7, up16)
        end
        return
    end
    up16 = arg19_1
    pcall(v291)

    return
end)
v620 = function()
    pcall(function()
        local v360, v364
        local v358 = isfile
        local v359 = v358
        if v358 then
            v360 = delfile
            v358 = v360 and (isfile(capturedValues1.value7))
            v359, v364 = v358, 7645216
        end
        if v359 then
            delfile(capturedValues1.value7)
        end
        return
    end)

    return
end
capturedValues1.value8 = spilledValues1.value6
v619 = LPH_NO_VIRTUALIZE(v618)
capturedValues1.value9 = nil
capturedValues1.value10 = v619
v618 = LPH_NO_VIRTUALIZE(v620)
capturedValues1.value11 = nil
v622 = function()
    local v297, v298, v299, v300, v301, v302, v303, v304, v305, v306, v307
    if capturedValues1.value11 then
        v297 = capturedValues1.value11
        return v297
    else
        v298 = function()
            local v515
            local v505 = fluxus
            local v506 = v505
            if v505 then
                v515 = ((type(fluxus.request)) == "function")
                v505 = v515
                if v515 then
                    v505 = fluxus.request
                end
                v506 = v505
            end
            return v506
        end
        v299 = function()
            return ((type(request)) == "function") and request
        end
        v300 = function()
            local v534
            local v523 = syn
            local v524 = v523
            if v523 then
                v534 = ((type(syn.request)) == "function")
                v523 = v534
                if v534 then
                    v523 = syn.request
                end
                v524 = v523
            end
            return v524
        end
        v301 = function()
            local v547
            local v536 = http
            local v537 = v536
            if v536 then
                v547 = ((type(http.request)) == "function")
                v536 = v547
                if v547 then
                    v536 = http.request
                end
                v537 = v536
            end
            return v537
        end
        v302 = function()
            local v558 = ((type(rawget(capturedValues1.value4, "request"))) == "function")
            local v559 = v558
            if v558 then
                v559 = (rawget(capturedValues1.value4, "request"))
            end
            return v559
        end
        v303 = function()
            return ((type(http_request)) == "function") and http_request
        end
        v298, v300 = {v300, v298, v301, v299, v303, v302}, "ipairs"
        for v299, v304 in ipairs(v298) do
            v305, v306 = pcall(v304)
            v307 = (v305 and v306)
            if v307 then
                capturedValues1.value11 = v306
                v307 = capturedValues1.value11
                return v307
            end
        end
        return nil
    end
end
capturedValues1.value12 = v618
capturedValues1.value11 = nil
v618 = LPH_NO_VIRTUALIZE
local v630 = function()
    local v308, v309, v310, v311, v313, v314, v315, v316, v317, v318, v319, v320, v327
    if capturedValues1.value9 then
        v308 = capturedValues1.value9
        return v308
    else
        v310 = function()
            local v572
            local v569 = type(gethwid)
            if (v569 == "function") then
                v572 = gethwid
                return v572()
            else
                v572 = nil
                return v572
            end
        end
        v308 = pcall
        v309, v311 = v308(v310)
        v310 = v309
        v309 = v310
        if v310 then
            v313 = type(v311)
            v317 = v308
            v319 = (v313 == "string") and ((#v311) >= 6)
            v308, v309 = v317, v319
        end
        if v309 then
            capturedValues1.value9 = v308
            return v311
        else
            v317 = 5
            v318 = 1
            for v319 = 1, v317, v318 do
                v314, v315 = pcall(function()
                    local v352 = game:GetService("RbxAnalyticsService")

                    return v352:GetClientId()
                end)
                v309 = v314
                if v314 then
                    v320 = v308
                    v327 = ((type(v315)) == "string") and ((#v315) >= 6)
                    v309, v308 = v327, v320
                end
                if v309 then
                    capturedValues1.value9 = ("RBX-" .. v315)
                    v316 = capturedValues1.value9
                    return v316
                else
                    task.wait(0.5)
                end
            end
            return nil
        end
    end
end
local v623 = v618(v622)
capturedValues1.value13 = v623
capturedValues1.value11 = (capturedValues1.value13())
capturedValues1.value9 = nil
spilledValues1.value8 = LPH_NO_VIRTUALIZE(v630)
capturedValues1.value14 = spilledValues1.value8
spilledValues1.value8 = LPH_NO_VIRTUALIZE
local v631 = function(arg23_1)
    local v331, v332, v334, v335, v336, v337, v338, v339, v340, v341, v342, v343, v344, v345, v347
    local v329 = (not capturedValues1.value11)
    local v330 = arg23_1
    if v329 then
        capturedValues1.value11 = (capturedValues1.value13())
    end
    if (not capturedValues1.value11) then
        v329 = false
        v334 = "NO_REQUEST_FUNCTION"
        return v329, v334
    else
        v334 = capturedValues1.value14()
        if (not v334) then
            v331 = "HWID_UNAVAILABLE"
            v329 = false
            return v329, v331
        else
            v329 = capturedValues1.value2
            v336 = capturedValues1.value3.UserId
            v332 = {["script_key"] = v330, ["userid"] = v336, ["hwid"] = v334}
            v336, v331 = "task", "JSONEncode"
            v331 = v329:JSONEncode(v332)
            local up17 = v331
            local up18 = {}
            local up19 = false
            task.spawn(function()
                local v183, v186
                v183, v186 = pcall(function()
                    local v192 = capturedValues1.value11
                    local v193 = (capturedValues1.value5.SERVER_URL .. "/auth")
                    local v197 = {["Content-Type"] = "application/json"}
                    local v204 = {["Url"] = v193, ["Method"] = "POST", ["Headers"] = v197, ["Body"] = up17}
                    return v192(v204)
                end)
                local v184 = up18
                local v187 = up18
                v184.ok = v183
                v187.result = v186
                up19 = true
                return
            end)
            v335 = 0
            v329 = .1
            v336 = .1
            while true do
                v338 = (not up19)
                v337 = v338
                if v338 then
                    v337 = (v335 < capturedValues1.value5.AUTH_TIMEOUT)
                end
                if v337 then
                    task.wait (v336)
                    v329 = (v335 + v336)
                    v335 = v329
                else
                    break
                end
            end
            v339 = (not up19)
            v337 = v339
            if not (v339) then
                v343 = up18
                v340 = v329
                v341 = (not v343.ok)
                v339 = v341
                if not (v341) then
                    v339 = ((type(up18.result)) ~= "table")
                end
                v337, v329 = v339, v340
            end
            if v337 then
                v338 = "SERVER_UNREACHABLE"
                return false, v338
            else
                v337 = up18.result.StatusCode
                v339, v340 = pcall(function()
                    local v463 = capturedValues1.value2
                    local v470 = up18.result.Body
                    return v463:JSONDecode(v470)
                end)
                v342 = (v337 == 200)
                v338 = v342
                if v342 then
                    v343 = v329
                    v342 = v339
                    if v339 then
                        v345 = v329
                        v344 = ((type(v340)) == "table") and v340.ok
                        v342, v329 = v344, v345
                    end
                    v338, v329 = v342, v343
                end
                if v338 then
                    return true, nil
                else
                    v342, v343 = v339, v329
                    if v339 then
                        v347 = type
                        v345 = v329
                        v344 = ((v347(v340)) == "table") and v340.detail
                        v342, v329 = v344, v345
                    end
                    v338, v329 = v342, v343
                    if not (v342) then
                        v338 = ("HTTP_" .. (tostring(v337)))
                    end
                    return false, v338
                end
            end
        end
    end
end
v630 = spilledValues1.value8(v631)
capturedValues1.value15 = v630
v631 = rawget(capturedValues1.value4, LPH_ENCSTR("SCRIPT_KEY"))
if v631 then
    v631 = task
    spilledValues1.value14 = function()
        local v174, v177
        local v175 = function()
            local v472 = loadstring
            local v473 = game
            local v479 = capturedValues1.value5.NextUIURL
            local v471 = v472(v473:HttpGet(v479))
            return v471()
        end
        v174, v177 = pcall(v175)
        v174 = (v174 and v177)
        if v174 then
            rawset(capturedValues1.value4, "NEXTHUB_UI_PREFETCHED", v177)
        end
        return
    end
    v631.spawn (LPH_NO_VIRTUALIZE(spilledValues1.value14))
    v630 = loadstring
    spilledValues1.value9 = game
    spilledValues1.value14 = capturedValues1.value5.LoaderScriptURL
    v630(spilledValues1.value9:HttpGet(spilledValues1.value14))()
    return
else
    local up59
    local up60
    spilledValues1.value14 = function()
        local v574, v575, v576, v577, v578, v579
        up60 = (rawget(capturedValues1.value4, "script_key"))
        if (up60 == nil) then
            v574 = pcall
            v575, v579 = v574(function()
                return script_key
            end)
            v576 = v575
            if v575 then
                v578 = v574
                v577 = ((type(v579)) == "string") and ((#v579) > 0)
                v574, v576 = v578, v577
            end
            if v576 then
                up60 = v579
            end
        end
        return
    end
    LPH_NO_VIRTUALIZE(spilledValues1.value14)()
    spilledValues1.value14 = ((type(up60)) == "string")
    v630 = spilledValues1.value14
    if spilledValues1.value14 then
        spilledValues1.value13 = spilledValues1.value1
        spilledValues1.value10 = ((#up60) >= 10)
        spilledValues1.value14 = spilledValues1.value10
        if spilledValues1.value10 then
            spilledValues1.value12 = (not (string.match(up60, LPH_ENCSTR("^FREE_"))))
            spilledValues1.value10 = spilledValues1.value12
            if spilledValues1.value12 then
                spilledValues1.value10 = (up60 ~= (LPH_ENCSTR("KEYLESS")))
            end
            spilledValues1.value14 = spilledValues1.value10
        end
        spilledValues1.value1, v630 = spilledValues1.value13, spilledValues1.value14
    end
    spilledValues1.value14 = function(arg1_1)
        local v78 = arg1_1
        if not (arg1_1) then
            v78 = Enum.FontWeight.Regular
        end
        return Font.new("rbxasset://fonts/families/GothamSSm.json", v78)
    end
    spilledValues1.value10 = function(arg2_1, arg2_2)
        local up3 = arg2_1
        local up1
        local up4
        local up2
        local v88 = function(arg15_1)
            local v246 = arg15_1
            local v255 = (v246.UserInputType == Enum.UserInputType.MouseButton1)
            local v256 = v255
            if not (v255) then
                v256 = (v246.UserInputType == Enum.UserInputType.Touch)
            end
            if v256 then
                up1 = true
                up4 = v246.Position
                up2 = up3.Position
            end
            return
        end
        arg2_2.InputBegan :Connect(v88)
        arg2_2.InputChanged:Connect(function(arg16_1)
            local v262, v270, v271
            local v258 = arg16_1
            local v259 = up1
            local v260 = v259
            if v259 then
                v262 = 4349275
                v270 = (v258.UserInputType == Enum.UserInputType.MouseMovement)
                v259 = v270
                if not (v270) then
                    v259 = (v258.UserInputType == Enum.UserInputType.Touch)
                end
                v260, v271 = v259, v262
            end
            if v260 then
                v259 = (v258.Position - up4)
                v271 = up3
                v270 = UDim2.new(up2.X.Scale, (up2.X.Offset + v259.X), up2.Y.Scale, (up2.Y .Offset + v259.Y))
                v271.Position = v270
            end
            return
        end)
        local v87 = arg2_2.InputEnded
        v88 = function(arg17_1)
            local v275 = arg17_1
            local v284 = (v275.UserInputType == Enum.UserInputType.MouseButton1)
            local v285 = v284
            if not (v284) then
                v285 = (v275.UserInputType == Enum.UserInputType.Touch)
            end
            if v285 then
            end
            return
        end
        v87:Connect(v88)

        return
    end
    local up61 = spilledValues1.value14
    local up62 = function(arg3_1, arg3_2)
        local v96, v97, v98, v99, v100, v102, v103, v107
        v96, v97 = arg3_2, "Instance"
        v97 = (Instance.new(arg3_1))
        v98, v99, v100 = pairs(v96)
        local v101 = v98
        while true do
            v100, v103 = v101(v99, v100)
            if not v100 then
                break
            end
            v107 = v100
            if (v107 ~= "Parent") then
                v102 = v103
                v97[v107] = v102
            end
        end
        if v96.Parent then
            v99 = v96.Parent
            v97.Parent = v99
        end
        return v97
    end
    local up63 = spilledValues1.value10
    local up64 = function()
        local v108, v109, v111
        local v110 = type(gethui)
        if (v110 == "function") then
            v108, v110 = pcall(gethui)
            v108 = (v108 and v110)
            if v108 then
                return v110
            end
        end
        v110 = ((type(syn)) == "table")
        v108 = v110
        if v110 then
            v108 = ((type(syn.protect_gui)) == "function")
        end
        if v108 then
            v109 = function()
                local v590 = (Instance.new("ScreenGui"))
                syn.protect_gui(v590)
                v590.Parent = game:GetService("CoreGui")

                return v590
            end
            v108, v110 = pcall(v109)
            v108 = (v108 and v110)
            if v108 then
                return v110
            end
        end
        v109 = function()
            local v424 = game
            local v428 = "CoreGui"
            return v424:GetService(v428)
        end
        v108, v110 = pcall(v109)
        v108 = (v108 and v110)
        if v108 then
            return v110
        else
            v111 = game:GetService("Players").LocalPlayer
            v108 = (v111 and (v111:WaitForChild("PlayerGui", 5)) or nil)

            return v108
        end
    end
    spilledValues1.value16 = Color3.fromRGB(18, 18, 24)
    spilledValues1.value17 = Color3.fromRGB(108, 99, 255)
    spilledValues1.value19 = Color3.fromRGB(28, 28, 36)
    spilledValues1.value21 = Color3.fromRGB(28, 28, 36)
    spilledValues1.value22 = Color3.fromRGB(240, 240, 245)
    spilledValues1.value23 = Color3.fromRGB(140, 140, 160)
    spilledValues1.value24 = Color3.fromRGB(60, 60, 80)
    spilledValues1.value11 = {["DarkBg"] = spilledValues1.value16, ["Primary"] = spilledValues1.value17, ["InputBg"] = spilledValues1.value19, ["ElementBackground"] = spilledValues1.value21, ["Text"] = spilledValues1.value22, ["TextDim"] = spilledValues1.value23, ["Outline"] = spilledValues1.value24}
    local up65
    spilledValues1.value15 = function(arg5_1)
        local v120, v121, v122, v123, v125, v126, v130, v131, v133
        v120, v121 = 35184145891327, "\007\017\178b\195\r\173U:\219 \129"
        local up5 = arg5_1
        v122, v123 = 7189173865747, "\191\192\n\031"
        local v124 = up62
        local v128 = capturedValues1.value2
        v130, v120 = v128.GenerateGUID, false
        v130 = v130(v128, v120)
        v123 = up64()
        v126, v133 = {["Name"] = v130, ["Parent"] = v123, ["ResetOnSpawn"] = false, ["IgnoreGuiInset"] = true}, "\181v\199\002\153\187c\209t\156"
        local v135 = v124("ScreenGui", v126)
        local up6 = v135
        v124 = up62
        v122 = UDim2
        v133, v131 = 20895723415042, "\240\005\228\015g6\191\026"
        v122 = v122.fromOffset (320, 280)
        local v132 = UDim2.new
        v131, v133, v121, v125 = 0, 0.5, 0.5, 0
        local v134 = v132(v121, v131, v133, v125)
        v121 = Vector2.new
        v133, v125 = 0.5, 0.5
        v131 = v121(v133, v125)
        v133 = up65.DarkBg
        v135 = v124("Frame", {["Name"] = "MainFrame", ["Size"] = v122, ["Position"] = v134, ["AnchorPoint"] = v131, ["BackgroundColor3"] = v133, ["BackgroundTransparency"] = .05, ["Parent"] = up6})
        v123, v122 = "\021E\225D:Q\233J", 20386880513301
        local up7 = v135
        v124 = up62
        v132, v131 = "\154\001\248[#\202\025\0292\227\021v", "p\1623"
        v133, v122 = 24185295268862, "UDim"
        v120 = UDim.new
        v132, v122 = 10, 0
        v123 = v120(v122, v132)
        v121, v131 = "\231u\004\1998\173", 3505773069920
        v124("UICorner", {["CornerRadius"] = v123, ["Parent"] = up7})
        v124 = up62
        v123, v133, v122 = "\203\208w\209\145\250\016\136", 10706433774457, 18676145758712
        v120 = up65.Primary
        v131, v121 = 34910935383936, "\148D\160\145\166\160h\203Q"
        v124("UIStroke", {["Color"] = v120, ["Thickness"] = 1.8, ["Transparency"] = .2, ["Parent"] = up7})
        v132, v123 = "\\\127\022\154\229\137", "\133\179\209\133\191\196\019?~\148L\213"
        up63(up7, up7)
        v124 = up62
        v120 = up7
        v122 = Enum.HorizontalAlignment.Center
        v121 = UDim.new(0, 12)
        v131 = Enum.SortOrder.LayoutOrder
        v124("UIListLayout", {["Parent"] = v120, ["HorizontalAlignment"] = v122, ["Padding"] = v121, ["SortOrder"] = v131})
        v124 = up62
        v120 = up7
        v132 = UDim.new(0, 20)
        v124("UIPadding", {["Parent"] = v120, ["PaddingTop"] = v132})
        v124 = up62
        v123, v125, v132 = "\023\151R\196\135", 22859532347796, "B\131\182\025"
        v122, v133 = "UDim2", 31277103593700
        v120 = UDim2.new
        v122, v132, v121 = 1, 0, 45
        v123 = v120(v122, v132, 0, v121)
        v131, v133 = 2709009499373, "\251\218\246e\199\177\006\155\244\138\220"
        local v127 = (v124("Frame", {["Size"] = v123, ["BackgroundTransparency"] = 1, ["LayoutOrder"] = 1, ["Parent"] = up7}))
        v124 = up62
        v132, v122 = 22147848104009, "k\144\021\173T"
        v125, v132 = 24650873531606, "UDim2"
        v122 = UDim2
        v131, v121 = 0, 1
        v122 = v122.new (0, 150, v121, v131)
        v134 = UDim2
        v131, v133 = 0, 0.5
        v132 = v134.new
        v125, v121 = 0, 0.5
        v134 = v132(v121, v131, v133, v125)
        v131 = Vector2.new(0.5, 0.5)
        v128 = (v124("Frame", {["Size"] = v122, ["Position"] = v134, ["AnchorPoint"] = v131, ["BackgroundTransparency"] = 1, ["Parent"] = v127}))
        v124 = up62
        v133, v131, v132 = 34180410998316, 17968165232815, "\231\175\217\151\161/\254\252\243\161"
        v133, v125 = "\198\159\196\146", 9853102395884
        v121 = UDim2.fromOffset(35, 35)
        v133 = UDim2.new(0, 0, 0.5, 0)
        local v136 = Vector2.new(0, 0.5)
        v124("ImageLabel", {["Image"] = "rbxassetid://111607497408853", ["Size"] = v121, ["Position"] = v133, ["AnchorPoint"] = v136, ["BackgroundTransparency"] = 1, ["Parent"] = v128})
        v124 = up62
        v132, v121 = "l\211\216\136\147\192\131Q6", "\131\200\218\174"
        v125, v133 = 113696882740, 15288077474767
        v133 = up61(Enum.FontWeight.Bold)
        v125 = up65.Primary
        local v138 = UDim2.new(0, 42, 0.5, 0)
        local v140 = Vector2.new(0, 0.5)
        local v142 = UDim2.new(0, 100, 1, 0)
        local v145 = Enum.TextXAlignment.Left
        v124("TextLabel", {["Text"] = "NextHub", ["TextSize"] = 20, ["FontFace"] = v133, ["TextColor3"] = v125, ["Position"] = v138, ["AnchorPoint"] = v140, ["Size"] = v142, ["BackgroundTransparency"] = 1, ["TextXAlignment"] = v145, ["Parent"] = v128})
        v124 = up62
        v121, v125 = "t_\1762", "\233p\030"
        v132 = UDim2
        v133, v125 = 42, 22066156431395
        v132 = v132.new (0, 260, 0, v133)
        v134 = up65.InputBg
        v133, v130 = 32401793399536, v124("Frame", {["Size"] = v132, ["BackgroundColor3"] = v134, ["LayoutOrder"] = 2, ["Parent"] = up7})
        v124 = up62
        v132 = UDim.new
        v121, v125 = 0, "\237\195\165\130!\242"
        v134 = v132(v121, 8)
        v131, v123 = "J\231>\1812", {["CornerRadius"] = v134, ["Parent"] = v130}
        v124("UICorner", v123)
        v124 = up62
        v132 = up65.Primary
        v124("UIStroke", {["Color"] = v132, ["Thickness"] = 1.2, ["Transparency"] = 0.5, ["Parent"] = v130})
        v131, v120, v133 = 3298191345151, capturedValues1.value10(), "`UK\002"
        v124 = up62
        v134 = UDim2.new
        v131, v125 = 1, 1
        v121 = v134(v131, -20, v125, 0)
        v133 = UDim2.new(0.5, 0, 0.5, 0)
        v136 = Vector2.new(0.5, 0.5)
        v142 = up65.Text
        v145 = up61()
        v135 = v124("TextBox", {["Size"] = v121, ["Position"] = v133, ["AnchorPoint"] = v136, ["BackgroundTransparency"] = 1, ["PlaceholderText"] = "Enter your key here...", ["Text"] = v120, ["TextColor3"] = v142, ["FontFace"] = v145, ["TextSize"] = 14, ["ClearTextOnFocus"] = false, ["Parent"] = v130})
        v125, v133 = "\159;\148\232", 33729039564122
        local up8 = v135
        v124 = up62
        v121 = UDim2.new
        v125, v133 = 260, 0
        v131 = v121(v133, v125, 0, 42)
        v133 = up65.Primary
        local v141 = up61(Enum.FontWeight.Bold)
        v142 = up65.Text
        v135 = v124("TextButton", {["Size"] = v131, ["BackgroundColor3"] = v133, ["Text"] = "Verify Key", ["TextSize"] = 15, ["FontFace"] = v141, ["TextColor3"] = v142, ["AutoButtonColor"] = false, ["LayoutOrder"] = 3, ["Parent"] = up7})
        local up9 = v135
        v124 = up62
        v133 = UDim.new(0, 8)
        v124("UICorner", {["CornerRadius"] = v133, ["Parent"] = up9})
        v124 = up62
        v125, v133 = 5726493821546, "\207_\216c\149"
        v133 = UDim2.new(0, 260, 0, 20)
        v135 = v124("Frame", {["Size"] = v133, ["BackgroundTransparency"] = 1, ["LayoutOrder"] = 4, ["Parent"] = up7})
        local up10 = v135
        v134 = function(arg28_1)
            local v373 = up62
            local v378 = UDim2.new(0, 45, 0, 1)
            local v380 = UDim2.new(arg28_1, 0, 0.5, 0)
            local v382 = Vector2.new(arg28_1, 0.5)
            local v383 = up65.Outline
            v373("Frame", {["Size"] = v378, ["Position"] = v380, ["AnchorPoint"] = v382, ["BackgroundColor3"] = v383, ["Parent"] = up10})

            return
        end
        v134(0)
        v134(1)
        v124 = up62
        v138 = UDim2.new(1, 0, 1, 0)
        v141 = up65.TextDim
        local v144 = up61()
        v124("TextLabel", {["Text"] = "Join Discord To Get Key", ["Size"] = v138, ["BackgroundTransparency"] = 1, ["TextColor3"] = v141, ["FontFace"] = v144, ["TextSize"] = 11, ["Parent"] = up10})
        v124 = up62
        v136 = UDim2.new(0, 260, 0, 42)
        local v137 = up65.ElementBackground
        v142 = up61(Enum.FontWeight.Bold)
        local v143 = up65.Text
        v135 = v124("TextButton", {["Size"] = v136, ["BackgroundColor3"] = v137, ["Text"] = "Join Discord", ["FontFace"] = v142, ["TextColor3"] = v143, ["TextSize"] = 15, ["LayoutOrder"] = 5, ["Parent"] = up7})
        local up11 = v135
        v124 = up62
        v137 = UDim.new(0, 8)
        v124("UICorner", {["CornerRadius"] = v137, ["Parent"] = up11})
        v124 = up62
        v136 = up65.Outline
        v124("UIStroke", {["Color"] = v136, ["Thickness"] = 1, ["Parent"] = up11})
        local up12 = false
        local up13 = function(arg29_1, arg29_2, arg29_3)
            local v391
            up9.Text = arg29_1
            local v390 = up9
            v390.BackgroundColor3 = arg29_2
            if arg29_3 then
                task.wait(1.5)
                v390 = up9
                v390.Text = "Verify Key"
                v390 = up9
                v391 = up65.Primary
                v390.BackgroundColor3 = v391
                v390 = up9
                v390.AutoButtonColor = true
                up12 = false
            end
            return
        end
        v124 = function(arg30_1)
            local v398
            local up20 = arg30_1
            if up12 then
                return
            else
                v398 = up20
                if (v398 == "") then
                    up13("Invalid Format!", (Color3.fromRGB(200, 80, 80)), true)

                    return
                else
                    v398 = up9
                    v398.Text = "Checking..."
                    v398 = up9
                    v398.AutoButtonColor = false
                    task.spawn(function()
                        local v431, v432, v433, v434, v435, v436, v439, v440
                        v431, v432 = capturedValues1.value15(up20)
                        if v431 then
                            up59 = up20
                            capturedValues1.value8(up20)
                            v431 = up9
                            v431.Text = "Success!"
                            v431 = up9
                            v435 = Color3.fromRGB(80, 200, 80)
                            v431.BackgroundColor3 = v435
                            v431 = capturedValues1.value1
                            v433 = up7
                            v436 = TweenInfo.new(.4, Enum.EasingStyle.Back, Enum.EasingDirection.In )
                            v439 = UDim2
                            v434 = v431.Create
                            v439 = v439.fromOffset (0, 0)
                            v434 = v434(v431, v433, v436, {["Size"] = v439, ["BackgroundTransparency"] = 1})
                            v434:Play()
                            task.wait (1)
                            up6:Destroy()
                            if up5 then
                                up5()
                            end
                        else
                            capturedValues1.value12()
                            v434 = "Invalid Key!"
                            if (v432 == "Key Expired") then
                                v434 = "Key Expired!"
                            else
                                if (v432 == "HWID_BANNED") then
                                    v434 = "HWID Banned!"
                                else
                                    if (v432 == "HWID_LIMIT_REACHED") then
                                        v434 = "HWID Limit Reached!"
                                    else
                                        if (v432 == "HWID_REQUIRED") then
                                            v434 = "HWID Unavailable!"
                                        else
                                            if (v432 == "HWID_UNAVAILABLE") then
                                                v434 = "Executor Not Supported!"
                                            else
                                                if (v432 == "NO_REQUEST_FUNCTION") then
                                                    v434 = "Executor Not Supported!"
                                                else
                                                    if (v432 == "SERVER_UNREACHABLE") then
                                                        v434 = "Server Unreachable!"
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            v440 = up8
                            v440.Text = ""
                            up13(v434, (Color3.fromRGB(200, 80, 80)), true)
                        end
                        return
                    end)
                    return
                end
            end
        end
        local up14 = v124
        v124 = up9.Activated
        v136 = function()
            up14(up8.Text)

            return
        end
        v124:Connect(v136)
        if (v120 ~= "") then
            up14(v120)
        end
        v124 = up11.Activated
        v138 = function()
            local v170
            local v163 = setclipboard or toclipboard
            if v163 then
                v163(capturedValues1.value5.DiscordLink )
                v170 = up11
                v170.Text = "Link Copied!"
            else
                v170 = up11
                v170.Text = "Check Console (F9)"
                print(("Discord: " .. capturedValues1.value5.DiscordLink))
            end
            task.wait(2)
            up11.Text = "Join Discord"
            return
        end
        v137 = {LPH_NO_VIRTUALIZE(v138)}
        v124:Connect(unpackValues(v137))

        return
    end
    up65 = spilledValues1.value11
    local up66 = spilledValues1.value15
    spilledValues1.value16 = task
    spilledValues1.value18 = function()
        local v155, v157
        local v154 = function()
            local v449 = loadstring
            local v450 = game
            local v456 = capturedValues1.value5.NextUIURL
            local v448 = v449(v450:HttpGet(v456))
            return v448()
        end
        v155, v157 = pcall(v154)
        v155 = (v155 and v157)
        if v155 then
            rawset(capturedValues1.value4, "NEXTHUB_UI_PREFETCHED", v157)
        end
        return
    end
    spilledValues1.value16.spawn(LPH_NO_VIRTUALIZE(spilledValues1.value18))
    if (not v630) then
        spilledValues1.value20 = function()
            local v481 = function()
                rawset(capturedValues1.value4, "SCRIPT_KEY", up59)
                local v496 = loadstring
                local v497 = game
                local v498 = capturedValues1.value5.LoaderScriptURL
                v496(v497:HttpGet(v498))()
                return
            end
            up66(v481)

            return
        end
        LPH_NO_VIRTUALIZE(spilledValues1.value20)()
        return
    else
        spilledValues1.value20 = function()
            local v483, v485, v486, v487, v488
            v485, v486 = capturedValues1.value15(up60)
            if v485 then
                rawset(capturedValues1.value4, "SCRIPT_KEY", up60)
                v483 = loadstring
                v487 = game
                v488 = capturedValues1.value5.LoaderScriptURL
                v483(v487:HttpGet(v488))()
            else
                rawset(capturedValues1.value4, "SCRIPT_KEY", nil)
                rawset(capturedValues1.value4, "script_key", nil)
                if (v486 == "Key Expired") then
                    capturedValues1.value3:Kick("NextHub: Your key has expired.")
                else
                    if (v486 == "HWID_BANNED") then
                        capturedValues1.value3:Kick("NextHub: Your hardware (HWID) has been banned.")
                    else
                        if (v486 == "HWID_LIMIT_REACHED") then
                            capturedValues1.value3:Kick("NextHub: HWID limit reached.\nThis key is already in use on another device.")
                        else
                            v485 = (v486 == "HWID_REQUIRED") or (v486 == "HWID_UNAVAILABLE")
                            if v485 then
                                capturedValues1.value3:Kick("NextHub: Unable to generate a device ID (HWID) on this executor.")
                            else
                                if (v486 == "NO_REQUEST_FUNCTION") then
                                    capturedValues1.value3:Kick("NextHub: Your executor does not support HTTP requests.")
                                else
                                    if (v486 == "SERVER_UNREACHABLE") then
                                        capturedValues1.value3:Kick("NextHub: Server unreachable. Please check your internet and re-execute.")
                                    else
                                        if (v486 == "Invalid Key") then
                                            capturedValues1.value3:Kick("NextHub: Invalid key. Please check your key and try again.")
                                        else
                                            capturedValues1.value3:Kick("NextHub: Key validation failed. Please check your key and try again.")
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
        LPH_NO_VIRTUALIZE(spilledValues1.value20)()
        return
    end
end
