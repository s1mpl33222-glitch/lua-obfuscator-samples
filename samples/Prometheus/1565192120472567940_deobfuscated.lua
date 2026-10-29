-- This file was generated at discord.gg/syncrypt

local spilledValues1 = {}
local capturedValues1 = {}

local v1915, v1922, v1925, v1926, v1927, v1928, v1929, v1930, v1934, v1936

local v1968, v1971, v1974, v1976, v1984, v1986

spilledValues1.value1, v1915, spilledValues1.value2, spilledValues1.value5, spilledValues1.value7 = nil, 25237642063336, "game", 18063688655067, 12834712622936
spilledValues1.value2 = game:GetService("Players")
capturedValues1.value1 = spilledValues1.value2
local v1894 = game:GetService("RunService")
spilledValues1.value2 = game
spilledValues1.value7, spilledValues1.value3 = "\191!\129\001\180\1931\215\228\164\200\024\005r\152\253", "GetService"
spilledValues1.value3 = spilledValues1.value2:GetService("UserInputService")
capturedValues1.value2 = spilledValues1.value3
local v1898 = game:GetService("TweenService")
spilledValues1.value3 = game
spilledValues1.value8, spilledValues1.value6 = 32235748178594, "\022$\153\2523C\248"
spilledValues1.value8, spilledValues1.value4 = "r\134\218\001\250\157\173\021", spilledValues1.value3.GetService
spilledValues1.value4 = spilledValues1.value4(spilledValues1.value3, "CoreGui")
capturedValues1.value3 = spilledValues1.value4
local v1897 = game:GetService("Lighting")
capturedValues1.value4 = v1897
local v1901 = game:GetService("Workspace")
capturedValues1.value5 = v1901
v1901 = capturedValues1.value1.LocalPlayer
capturedValues1.value6 = v1901
spilledValues1.value5 = capturedValues1.value6:GetMouse()
v1901 = capturedValues1.value5.CurrentCamera
capturedValues1.value7 = v1901
v1901, spilledValues1.value9 = nil, nil
capturedValues1.value8 = v1901
capturedValues1.value9 = nil
capturedValues1.value10 = spilledValues1.value9
local v1912 = capturedValues1.value6
spilledValues1.value9 = function(arg10_1)
    capturedValues1.value8 = arg10_1
    capturedValues1.value9 = (arg10_1:WaitForChild("HumanoidRootPart"))
    capturedValues1.value10 = (arg10_1:WaitForChild("Humanoid"))

    return
end
if v1912["Character"] then
    spilledValues1.value9(capturedValues1.value6.Character)
end
v1912 = capturedValues1.value6
v1922, v1925 = "\186O\021\194\t\2132\132C\248\1878\213m", "\239\245\004\201p\221\244\129"
v1912.CharacterAdded:Connect(spilledValues1.value9)
local v1913 = function()
    local v590 = capturedValues1.value3:FindFirstChild("RivoHub")
    if v590 then
        capturedValues1.value3.RivoHub:Destroy()
    end
    return
end
v1912, v1927, v1922 = "pcall", 18446715576717, 3828369377014
pcall(v1913)
v1929, v1913 = "\222ǛD\171L\207i", false
local v1973 = "Flight"
local v2023 = Color3.fromRGB(255, 60, 60)
local v2025 = Color3.fromRGB(60, 170, 255)
local v2051 = Color3.fromRGB(255, 200, 140)
local v2066 = capturedValues1.value4.Brightness
local v2068 = capturedValues1.value4.Ambient
local v2070 = capturedValues1.value4.GlobalShadows
local v2072 = capturedValues1.value4.FogEnd
local v2074 = capturedValues1.value4.FogStart
local v2076 = capturedValues1.value4.ClockTime
local v2078 = capturedValues1.value4.ExposureCompensation
local v2082 = {}
local v1914 = {["SilentAim"] = v1913, ["HitChance"] = 100, ["Aimbot"] = false, ["AimSmooth"] = .14, ["ShowFOV"] = true, ["FOVRadius"] = 130, ["AimPart"] = "Head", ["Priority"] = "Crosshair", ["TeamCheck"] = true, ["WallCheck"] = false, ["Ragebot"] = false, ["Triggerbot"] = false, ["TrigDelay"] = .06, ["NoRecoil"] = false, ["NoSpread"] = false, ["RapidFire"] = false, ["InstantAim"] = false, ["LeadTargets"] = false, ["LeadAmt"] = .12, ["SkipKatana"] = false, ["AutoDeflect"] = false, ["LockLine"] = false, ["SpeedBoost"] = false, ["SpeedAmt"] = 28, ["AirJumps"] = false, ["AirJumpMax"] = 3, ["AirJumpsLeft"] = 3, [v1973] = false, ["FlySpeed"] = 90, ["FlyVel"] = nil, ["FlyGyro"] = nil, ["NoSlowdown"] = false, ["SprintLock"] = false, ["MeleeHaste"] = false, ["AbilityHaste"] = false, ["QuickFuse"] = false, ["ESP"] = true, ["ESPBox"] = true, ["FilledBox"] = false, ["ESPName"] = true, ["HealthBar"] = true, ["HealthNum"] = true, ["ESPDist"] = true, ["ESPWeapon"] = true, ["HeadDot"] = true, ["Tracers"] = false, ["TracerFrom"] = "Bottom", ["Chams"] = false, ["OccludeChams"] = false, ["OffscreenInd"] = true, ["ShowTeammates"] = false, ["ESPColor"] = v2023, ["TeamColor"] = v2025, ["Fullbright"] = false, ["NoFog"] = false, ["CamFOV"] = 70, ["OverrideTime"] = false, ["TimeVal"] = 14, ["ExposureShift"] = 0, ["GlowFX"] = false, ["SoftFocus"] = false, ["ColorGrade"] = false, ["HazeFX"] = false, ["SkyOverride"] = false, ["AmbientTint"] = false, ["AmbientCol"] = v2051, ["HitChime"] = false, ["HitCross"] = false, ["DamageFeed"] = false, ["ShotTrails"] = false, ["HideFlashes"] = false, ["ClearSmoke"] = false, ["SpectatorAlert"] = false, ["OrigBright"] = v2066, ["OrigAmbient"] = v2068, ["OrigShadows"] = v2070, ["OrigFogEnd"] = v2072, ["OrigFogStart"] = v2074, ["OrigClockTime"] = v2076, ["OrigExposure"] = v2078, ["CurrentTarget"] = nil, ["DamageFeedList"] = v2082}
capturedValues1.value11 = v1914
capturedValues1.value12 = nil
local v1916 = function(arg42_1, arg42_2, arg42_3)
    capturedValues1.value12:Create(arg42_1, arg42_2, arg42_3):Play()
    return
end
capturedValues1.value12 = v1898
capturedValues1.value13 = v1916
local v1919 = TweenInfo.new(.13, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
capturedValues1.value14 = v1919
v1919 = TweenInfo.new
v1922, v1926 = .24, "Enum"
local v1918 = v1919(v1922, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
v1934, spilledValues1.value12 = "׹\251%\166\240\200", 5552344730137
capturedValues1.value15 = v1918
local v1931 = Color3.fromRGB
v1926, v1930 = 9, 9
local v1932 = v1931(v1930, v1926, 14)
v1926 = Color3.fromRGB(14, 14, 22)
local v1935 = Color3.fromRGB(11, 11, 18)
local v1938 = Color3.fromRGB(180, 30, 55)
local v1940 = Color3.fromRGB(28, 18, 26)
local v1943 = Color3.fromRGB(15, 13, 20)
v1927 = Color3.fromRGB(210, 35, 65)
local v1946 = Color3.fromRGB(255, 110, 75)
local v1948 = Color3.fromRGB(235, 235, 248)
local v1950 = Color3.fromRGB(115, 105, 135)
local v1952 = Color3.fromRGB(200, 32, 60)
local v1955 = Color3.fromRGB(34, 32, 48)
local v1957 = Color3.fromRGB(245, 240, 255)
local v1960 = Color3.fromRGB(18, 17, 28)
local v1962 = Color3.fromRGB(46, 24, 38)
local v1964 = Color3.fromRGB(13, 12, 22)
local v1966 = Color3.fromRGB(48, 28, 52)
local v1967 = Color3.fromRGB
spilledValues1.value12, v1928, v1934, v1936 = 42, 35106931261403, 60, "\218\127\234"
local v1969 = v1967(215, spilledValues1.value12, v1934)
spilledValues1.value12 = Color3
v1936, v1928 = 205, 98
local v1970 = spilledValues1.value12.fromRGB
v1968, v1934 = "D\233S", 48
spilledValues1.value12 = v1970(v1934, v1936, v1928)
v1934 = Color3.fromRGB
v1928, v1968 = 255, 148
v1936 = v1934(v1928, v1968, 28)
v1918 = {["Bg"] = v1932, ["Panel"] = v1926, ["Sidebar"] = v1935, ["TabOn"] = v1938, ["TabHov"] = v1940, ["TabOff"] = v1943, ["Accent"] = v1927, ["Acc2"] = v1946, ["Text"] = v1948, ["Sub"] = v1950, ["TON"] = v1952, ["TOFF"] = v1955, ["Knob"] = v1957, ["Btn"] = v1960, ["BtnH"] = v1962, ["Sec"] = v1964, ["Bord"] = v1966, ["Red"] = v1969, ["Grn"] = spilledValues1.value12, ["Org"] = v1936}
capturedValues1.value16 = nil
v1932 = function(arg43_1, arg43_2, arg43_3)
    local v599
    local v598 = Instance
    local v601 = arg43_3
    local v597 = (v598.new("UIStroke", arg43_1))
    v598, v599 = arg43_2, "Color"
    if not (arg43_2) then
        v598 = capturedValues1.value16.Bord
    end
    v597[v599] = v598
    v597.Thickness = (v601 or 1)

    return
end
capturedValues1.value16 = v1918
v1931 = function(arg44_1, arg44_2)
    local v612 = (Instance.new("UICorner", arg44_1))
    v612.CornerRadius = UDim.new(0, (arg44_2 or 8))

    return
end
capturedValues1.value17 = v1931
v1930 = function(arg45_1, arg45_2, arg45_3, arg45_4, arg45_5)
    local v620 = (Instance.new("UIPadding", arg45_1))
    v620.PaddingTop = UDim.new(0, (arg45_2 or 0))
    v620.PaddingLeft = UDim.new(0, (arg45_3 or 0))
    v620.PaddingRight = UDim.new(0, (arg45_4 or 0))
    v620.PaddingBottom = UDim.new(0, (arg45_5 or 0))

    return
end
capturedValues1.value18 = v1932
capturedValues1.value19 = v1930
v1926 = Instance.new("ScreenGui", capturedValues1.value3)
capturedValues1.value20 = v1926
capturedValues1.value20.Name = "RivoHub"
capturedValues1.value20.ResetOnSpawn = false
capturedValues1.value20.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
capturedValues1.value20.DisplayOrder = 999
v1935 = function()
    local v625 = syn
    local v626 = v625
    if v625 then
        v626 = syn.protect_gui
    end
    if v626 then
        syn.protect_gui(capturedValues1.value20)
    end
    return
end
pcall(v1935)
local v1933 = Instance.new("Frame", capturedValues1.value20)
capturedValues1.value21 = v1933
capturedValues1.value21.Size = UDim2.new(0, 820, 0, 580)
capturedValues1.value21.Position = UDim2.new(0.5, -410, 0.5, -290)
capturedValues1.value21.BackgroundColor3 = capturedValues1.value16.Bg
capturedValues1.value21.BorderSizePixel = 0
capturedValues1.value21.ClipsDescendants = false
capturedValues1.value17(capturedValues1.value21, 12)
capturedValues1.value18(capturedValues1.value21, capturedValues1.value16.Bord, 1.5)
v1935 = Instance.new("ImageLabel", capturedValues1.value21)
v1935.BackgroundTransparency = 1
v1935.Image = "rbxassetid://5028857084"
v1935.ImageColor3 = capturedValues1.value16.Accent
v1935.ImageTransparency = .8
v1935.Size = UDim2.new(1, 90, 1, 90)
v1935.Position = UDim2.new(0, -45, 0, -45)
v1938 = capturedValues1.value21.ZIndex
v1935.ZIndex = (v1938 - 1)
v1935.ScaleType = Enum.ScaleType.Slice
v1935.SliceCenter = Rect.new(49, 49, 450, 450)
local v1937 = Instance.new("Frame", capturedValues1.value21)
capturedValues1.value22 = v1937
capturedValues1.value22.Size = UDim2.new(1, 0, 0, 50)
capturedValues1.value22.BackgroundColor3 = capturedValues1.value16.Panel
capturedValues1.value22.BorderSizePixel = 0
capturedValues1.value17(capturedValues1.value22, 12)
v1938 = Instance.new("Frame", capturedValues1.value22)
v1938.Size = UDim2.new(1, 0, .55, 0)
local v1939 = UDim2.new
v1927, spilledValues1.value12 = 0, 26273237757898
v1938.Position = v1939(0, 0, .45, v1927)
v1938.BackgroundColor3 = capturedValues1.value16.Panel
v1938.BorderSizePixel = 0
v1939 = Instance.new("Frame", capturedValues1.value22)
capturedValues1.value23 = v1939
capturedValues1.value23.Size = UDim2.new(0, 0, 0, 2)
capturedValues1.value23.Position = UDim2.new(0, 0, 1, -2)
capturedValues1.value23.BackgroundColor3 = capturedValues1.value16.Accent
capturedValues1.value23.BorderSizePixel = 0
v1940 = Instance.new("UIGradient", capturedValues1.value23)
local v1941 = ColorSequence.new
local v1945 = ColorSequenceKeypoint.new(0, capturedValues1.value16.Acc2)
v1946 = ColorSequenceKeypoint.new(0.5, capturedValues1.value16.Accent)
v1927 = ColorSequenceKeypoint.new
local v1949 = capturedValues1.value16.Acc2
v1940.Color = v1941({v1945, v1946, v1927(1, v1949)})
v1941 = task
local v1944 = function()
    local v633 = capturedValues1.value13
    local v634 = capturedValues1.value23
    local v635 = TweenInfo.new(.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local v637 = UDim2.new(1, 0, 0, 2)
    v633(v634, v635, {["Size"] = v637})

    return
end
v1941.delay (.4, v1944)
v1941 = Instance.new("TextLabel", capturedValues1.value22)
v1941.Text = "  RIVO HUB  |  Rivals"
v1941.Font = Enum.Font.GothamBold
v1941.TextSize = 17
v1941.TextColor3 = capturedValues1.value16.Text
v1941.BackgroundTransparency = 1
v1943 = UDim2.new
v1927, v1968 = .45, 26770451689649
v1941.Size = v1943(v1927, 0, 1, -2)
v1941.TextXAlignment = Enum.TextXAlignment.Left
v1943 = Instance.new("TextLabel", capturedValues1.value22)
v1943.Text = "v2.0  |  Insert = toggle  |  Del = Silent Aim  |  End = Aimbot"
v1943.Font = Enum.Font.Gotham
v1943.TextSize = 11
v1943.TextColor3 = capturedValues1.value16.Sub
v1943.BackgroundTransparency = 1
v1943.Size = UDim2.new(.52, 0, 1, 0)
v1943.Position = UDim2.new(.45, 0, 0, 0)
v1943.TextXAlignment = Enum.TextXAlignment.Right
v1939 = function(arg48_1, arg48_2, arg48_3, arg48_4)
    local v651 = (Instance.new("TextButton", capturedValues1.value22))
    v651.Text = arg48_2
    v651.Font = Enum.Font.GothamBold
    v651.TextSize = 13
    v651.TextColor3 = arg48_3
    v651.BackgroundTransparency = 1
    v651.Size = UDim2.new(0, 32, 0, 32)
    v651.Position = UDim2.new(1, arg48_1, 0.5, -16)
    v651.AutoButtonColor = false
    v651.MouseButton1Click:Connect(arg48_4)

    return v651
end
capturedValues1.value24 = true
local v1947 = capturedValues1.value16.Red
v1948 = function()
    local v656 = capturedValues1.value13
    local v657 = capturedValues1.value21
    local v658 = capturedValues1.value15
    local v660 = UDim2.new(0, 0, 0, 0)
    local v663 = UDim2.new(0.5, 0, 0.5, 0)
    v656(v657, v658, {["Size"] = v660, ["Position"] = v663})
    local v669 = task
    v658 = function()
        capturedValues1.value20:Destroy()
        return
    end
    v669.delay (.3, v658)

    return
end
v1939(-36, "X", v1947, v1948)
capturedValues1.value25 = false
v1948 = capturedValues1.value16.Sub
v1949 = function()
    local v670, v672, v673, v677
    capturedValues1.value25 = (not capturedValues1.value25)
    if capturedValues1.value25 then
        v670 = CONTENT
        v670.Visible = false
        v670 = capturedValues1.value13
        v672 = capturedValues1.value21
        v673 = capturedValues1.value15
        v677 = UDim2.new(0, 820, 0, 50)
        v670(v672, v673, {["Size"] = v677})
    else
        v670 = capturedValues1.value13
        v672 = capturedValues1.value21
        v673 = capturedValues1.value15
        v677 = UDim2.new(0, 820, 0, 580)
        v670(v672, v673, {["Size"] = v677})
        task.delay(.22, function()
            CONTENT.Visible = true
            return
        end)
    end
    return
end
v1939(-72, "-", v1948, v1949)
capturedValues1.value26 = nil
capturedValues1.value27 = nil
capturedValues1.value28 = nil
capturedValues1.value22.InputBegan:Connect(function(arg51_1)
    local v683 = arg51_1
    local v688 = v683.UserInputType
    local v684 = Enum.UserInputType
    if (v688 == v684.MouseButton1 ) then
        capturedValues1.value26 = true
        capturedValues1.value27 = v683.Position
        capturedValues1.value28 = capturedValues1.value21.Position
    end
    return
end)
v1947 = capturedValues1.value2.InputChanged
v1950 = function(arg52_1)
    local v694, v695, v699, v704
    local v693 = capturedValues1.value26
    v694, v695 = v693, arg52_1
    if v693 then
        v694 = (v695.UserInputType == Enum.UserInputType.MouseMovement)
    end
    if v694 then
        v693 = (v695.Position - capturedValues1.value27)
        v704 = capturedValues1.value21
        v699 = UDim2.new(capturedValues1.value28.X.Scale, (capturedValues1.value28.X.Offset + v693.X), capturedValues1.value28.Y.Scale, (capturedValues1.value28.Y .Offset + v693.Y))
        v704.Position = v699
    end
    return
end
v1947:Connect(v1950)
v1947 = capturedValues1.value2.InputEnded
v1950 = function(arg53_1)
    local v714 = arg53_1.UserInputType
    local v710 = Enum.UserInputType
    if (v714 == v710["MouseButton1"]) then
    end
    return
end
v1947:Connect(v1950)
CONTENT = (Instance.new("Frame", capturedValues1.value21))
CONTENT.Size = UDim2.new(1, 0, 1, -50)
CONTENT.Position = UDim2.new(0, 0, 0, 50)
CONTENT.BackgroundTransparency = 1
CONTENT.BorderSizePixel = 0
v1950 = Instance.new("Frame", CONTENT)
capturedValues1.value29 = v1950
capturedValues1.value29.Size = UDim2.new(0, 158, 1, 0)
capturedValues1.value29.BackgroundColor3 = capturedValues1.value16.Sidebar
capturedValues1.value29.BorderSizePixel = 0
capturedValues1.value19(capturedValues1.value29, 10, 7, 7, 10)
local v1951 = Instance.new("UIListLayout", capturedValues1.value29)
v1951.SortOrder = Enum.SortOrder.LayoutOrder
v1951.Padding = UDim.new(0, 3)
v1952 = Instance.new("Frame", CONTENT)
v1952.Size = UDim2.new(0, 1, 1, 0)
v1952.Position = UDim2.new(0, 158, 0, 0)
v1952.BackgroundColor3 = capturedValues1.value16.Bord
v1952.BorderSizePixel = 0
local v1954 = Instance.new("Frame", CONTENT)
capturedValues1.value30 = v1954
capturedValues1.value30.Size = UDim2.new(1, -159, 1, 0)
capturedValues1.value30.Position = UDim2.new(0, 159, 0, 0)
capturedValues1.value30.BackgroundTransparency = 1
capturedValues1.value30.BorderSizePixel = 0
capturedValues1.value30.ClipsDescendants = true
capturedValues1.value21.Size = UDim2.new(0, 0, 0, 0)
v1954 = capturedValues1.value21
v1957 = UDim2.new(0.5, 0, 0.5, 0)
v1925 = nil
local v1963 = function(arg54_1, arg54_2, arg54_3, arg54_4, arg54_5, arg54_6)
    local v719, v720, v723, v725, v727, v730, v731, v733
    local up7 = arg54_2
    local up8 = arg54_5
    v719, v720 = "Instance", 2042533118903
    local up9 = arg54_6
    local v721 = Instance.new("Frame", arg54_1)
    local up10 = v721
    local v726 = up10
    local v724 = UDim2
    v720, v723 = 0, 0
    local v722 = v724.new
    v725, v727 = 1, 38
    v726.Size = v722(v725, v723, v720, v727)
    up10.BackgroundColor3 = capturedValues1.value16.Btn
    up10.BorderSizePixel = 0
    up10.ClipsDescendants = false
    capturedValues1.value17(up10, 8)
    v721 = Instance
    v727, v720 = 5940429703886, "\\\178\023"
    v720, v727 = "dc\"\172\171\002\030[\024", 20568262092137
    v721 = v721.new("TextLabel", up10)
    local up11 = v721
    v726 = up11
    v725 = up7
    local v728 = tostring(arg54_4())
    v726.Text = (v725 .. (": " .. v728))
    up11.Font = Enum.Font.Gotham
    v726 = up11
    v727, v720 = 25663400079022, "\255\245Y\202\r\194\253\140"
    v726.TextSize = 12
    up11.TextColor3 = capturedValues1.value16.Text
    up11.BackgroundTransparency = 1
    v726 = up11
    v724 = UDim2.new
    v723, v727, v720 = 1, 1, -36
    v726.Size = v724(v723, v720, v727, 0)
    v726 = up11
    v727, v720 = 32774878100381, "_\247\243\200.\138f\178"
    v724 = UDim2.new
    v723, v720 = 0, 10
    v726.Position = v724(v723, v720, 0, 0)
    up11.TextXAlignment = Enum.TextXAlignment.Left
    v724 = (Instance.new("TextLabel", up10))
    v720, v727 = "\025\008v\152", 9465382834487
    v724.Text = "v"
    v721 = Enum.Font.GothamBold
    v727, v720 = 7547891928506, "G\222\028]d\253\011\137"
    v724.Font = v721
    v724.TextSize = 12
    v724.TextColor3 = capturedValues1.value16.Accent
    v724.BackgroundTransparency = 1
    v725 = UDim2
    v720, v727 = 24, 1
    v725 = v725.new (0, v720, v727, 0)
    v724.Size = v725
    v720, v727 = "\249\"\151\140\1760F?", 29991551579789
    v721 = UDim2.new
    v723, v727, v720 = 1, 0, -28
    v724.Position = v721(v723, v720, v727, 0)
    v721 = Instance.new("Frame", up10)
    local up12 = v721
    up12.Size = UDim2.new(1, 0, 0, (((#arg54_3) * 28) + 4))
    up12.Position = UDim2.new(0, 0, 1, 2)
    up12.BackgroundColor3 = capturedValues1.value16.Panel
    up12.BorderSizePixel = 0
    up12.ZIndex = 20
    v726 = up12
    v723, v720 = false, 6
    v726.Visible = v723
    capturedValues1.value17(up12, v720)
    v726 = capturedValues1.value18
    v723 = up12
    v720 = capturedValues1.value16.Bord
    v726(v723, v720, 1)
    v726 = ipairs
    for v720, v729 in v726(arg54_3) do
        local up13 = v729
        v730 = Instance.new("TextButton", up12)
        local up14 = v730
        v726 = up14
        v733 = UDim2.new(1, -4, 0, 26)
        v726.Size = v733
        v726 = up14
        v733 = UDim2.new(0, 2, 0, (((v720 - 1) * 28) + 2))
        v726.Position = v733
        v726 = up14
        v726.BackgroundTransparency = 1
        v726 = up14
        v726.Text = up13
        v726 = up14
        v731 = Enum.Font.Gotham
        v726.Font = v731
        v726 = up14
        v726.TextSize = 12
        v726 = up14
        v731 = capturedValues1.value16.Text
        v726.TextColor3 = v731
        v726 = up14
        v726.ZIndex = 21
        up14.MouseButton1Click:Connect(function()
            up8(up13)
            up11.Text = (up7 .. (": " .. up13))
            up12.Visible = false
            if up9 then
                up9(up13)
            end
            return
        end)
        v726 = up14.MouseEnter
        v731 = function()
            up14.BackgroundTransparency = .55
            up14.BackgroundColor3 = capturedValues1.value16.Accent
            return
        end
        v729 = nil
        v726:Connect(v731)
        up14.MouseLeave:Connect(function()
            up14.BackgroundTransparency = 1
            return
        end)
    end
    v723 = Instance.new("TextButton", up10)
    v723.Size = UDim2.new(1, 0, 1, 0)
    v723.BackgroundTransparency = 1
    v723.Text = ""
    v723.ZIndex = 19
    v726 = v723.MouseEnter
    v727 = function()
        local v1787 = capturedValues1.value13
        local v1788 = up10
        local v1789 = capturedValues1.value14
        local v1790 = capturedValues1.value16.BtnH
        v1787(v1788, v1789, {["BackgroundColor3"] = v1790})

        return
    end
    v726:Connect(v727)
    v723.MouseLeave:Connect(function()
        local v1799 = capturedValues1.value13
        local v1800 = up10
        local v1801 = capturedValues1.value14
        local v1802 = capturedValues1.value16.Btn
        v1799(v1800, v1801, {["BackgroundColor3"] = v1802})

        return
    end)
    v727 = function()
        up12.Visible = (not up12.Visible)

        return
    end
    v723.MouseButton1Click :Connect(v727)

    return
end
v1954.Position = v1957
v1955 = task
v1957 = function()
    local v743 = capturedValues1.value13
    local v744 = capturedValues1.value21
    local v745 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local v747 = UDim2.new(0, 820, 0, 580)
    local v754 = UDim2.new(0.5, -410, 0.5, -290)
    v743(v744, v745, {["Size"] = v747, ["Position"] = v754})

    return
end
local v1958 = function(arg56_1, arg56_2, arg56_3)
    local v757 = (Instance.new("TextLabel", arg56_1))
    v757.Size = UDim2.new(1, 0, 0, 20)
    v757.BackgroundTransparency = 1
    v757.Text = ("  " .. arg56_2)
    v757.Font = Enum.Font.Gotham
    v757.TextSize = 11
    local v758 = arg56_3
    if not (arg56_3) then
        v758 = capturedValues1.value16.Sub
    end
    v757.TextColor3 = v758
    v757.TextXAlignment = Enum.TextXAlignment.Left
    return v757
end
v1962 = function(arg57_1, arg57_2, arg57_3)
    local up15 = arg57_3
    local v767 = Instance.new("TextButton", arg57_1)
    local up16 = v767
    up16.Size = UDim2.new(1, 0, 0, 36)
    up16.BackgroundColor3 = capturedValues1.value16.Btn
    up16.BorderSizePixel = 0
    up16.Text = arg57_2
    up16.Font = Enum.Font.GothamSemibold
    up16.TextSize = 13
    up16.TextColor3 = capturedValues1.value16.Text
    up16.AutoButtonColor = false
    capturedValues1.value17(up16, 8)
    local v772 = up16.MouseEnter
    local v768 = function()
        local v1730 = capturedValues1.value13
        local v1731 = up16
        local v1732 = capturedValues1.value14
        local v1733 = capturedValues1.value16.BtnH
        local v1737 = Color3.fromRGB(255, 255, 255)
        v1730(v1731, v1732, {["BackgroundColor3"] = v1733, ["TextColor3"] = v1737})

        return
    end
    v772:Connect(v768)
    v772 = up16.MouseLeave
    v768 = function()
        local v1744 = capturedValues1.value13
        local v1745 = up16
        local v1746 = capturedValues1.value14
        local v1747 = capturedValues1.value16.Btn
        local v1749 = capturedValues1.value16.Text
        v1744(v1745, v1746, {["BackgroundColor3"] = v1747, ["TextColor3"] = v1749})

        return
    end
    v772:Connect(v768)
    v772 = up16.MouseButton1Down
    v768 = function()
        local v1758 = capturedValues1.value13
        local v1759 = up16
        local v1760 = TweenInfo.new(.07)
        local v1761 = capturedValues1.value16.Accent
        v1758(v1759, v1760, {["BackgroundColor3"] = v1761})

        return
    end
    v772:Connect(v768)
    v772 = up16.MouseButton1Up
    v768 = function()
        local v1770 = capturedValues1.value13
        local v1771 = up16
        local v1772 = capturedValues1.value14
        local v1773 = capturedValues1.value16.BtnH
        v1770(v1771, v1772, {["BackgroundColor3"] = v1773})

        return
    end
    v772:Connect(v768)
    v772 = up16.MouseButton1Click
    v768 = function()
        if up15 then
            up15()
        end
        return
    end
    v772:Connect(v768)

    return
end
v1955.delay (.05, v1957)
local v1961 = function(arg58_1, arg58_2, arg58_3, arg58_4, arg58_5, arg58_6, arg58_7, arg58_8)
    local up19 = arg58_2
    local up18 = arg58_4
    local up21 = arg58_5
    local up17 = arg58_6
    local up20 = arg58_7
    local up22 = arg58_8
    local v782 = (Instance.new("Frame", arg58_1))
    v782.Size = UDim2.new(1, 0, 0, 56)
    v782.BackgroundColor3 = capturedValues1.value16.Btn
    v782.BorderSizePixel = 0
    capturedValues1.value17(v782, 8)
    local v778 = Instance.new("TextLabel", v782)
    local up23 = v778
    up23.Font = Enum.Font.Gotham
    up23.TextSize = 13
    up23.TextColor3 = capturedValues1.value16.Text
    up23.BackgroundTransparency = 1
    up23.Size = UDim2.new(1, -12, 0, 26)
    up23.Position = UDim2.new(0, 12, 0, 4)
    up23.TextXAlignment = Enum.TextXAlignment.Left
    local v783 = function(arg0_1)
        local v114 = up20
        local v115 = arg0_1
        if v114 then
            v114 = up20
            return v114(v115)
        else
            v114 = tostring
            return v114(v115)
        end
    end
    local up24 = v783
    v783 = up23
    local v784 = up19
    local v788 = up24(arg58_3())
    v783.Text = (v784 .. (": " .. v788))
    v778 = Instance.new("Frame", v782)
    local up25 = v778
    up25.Size = UDim2.new(1, -24, 0, 6)
    up25.Position = UDim2.new(0, 12, 0, 36)
    up25.BackgroundColor3 = capturedValues1.value16.TOFF
    up25.BorderSizePixel = 0
    capturedValues1.value17(up25, 3)
    v778 = Instance.new("Frame", up25)
    local up26 = v778
    up26.BackgroundColor3 = capturedValues1.value16.Accent
    up26.BorderSizePixel = 0
    capturedValues1.value17(up26, 3)
    v778 = Instance.new("Frame", up25)
    local up27 = v778
    up27.Size = UDim2.new(0, 14, 0, 14)
    up27.BackgroundColor3 = capturedValues1.value16.Knob
    up27.BorderSizePixel = 0
    capturedValues1.value17(up27, 7)
    capturedValues1.value18(up27, capturedValues1.value16.Accent, 1.5)
    local up28 = function(arg1_1)
        local v117
        local v122 = math.clamp
        local v119 = (arg1_1 - up21)
        v117, v122 = v122((v119 / (up17 - up21)), 0, 1), nil
        local v118 = (up17 - up21)
        if (v118 > 10) then
            v119 = (math.floor((up21 + (v117 * (up17 - up21)))))
        else
            v119 = ((math.floor(((up21 + (v117 * (up17 - up21))) * 100))) / 100)
        end
        up18(v119)
        up26.Size = UDim2.new(v117, 0, 1, 0)
        up27.Position = UDim2.new(v117, -7, 0.5, -7)
        up23.Text = (up19 .. (": " .. (up24(v119))))
        if up22 then
            up22(v119)
        end
        return
    end
    up28(arg58_3())
    local up29 = false
    up25.InputBegan:Connect(function(arg2_1)
        local v133 = arg2_1
        local v135 = v133.UserInputType
        local v130 = Enum.UserInputType
        if (v135 == v130.MouseButton1 ) then
            up29 = true
            up28((up21 + ((math.clamp(((v133.Position.X - up25.AbsolutePosition .X) / up25.AbsoluteSize.X), 0, 1)) * (up17 - up21))))
        end
        return
    end)
    capturedValues1.value2.InputEnded:Connect(function(arg3_1)
        local v153 = arg3_1.UserInputType
        local v149 = Enum.UserInputType
        if (v153 == v149.MouseButton1 ) then
            up29 = false
        end
        return
    end)
    capturedValues1.value2.InputChanged:Connect(function(arg4_1)
        local v158 = arg4_1
        local v159 = up29
        local v160 = v159
        if v159 then
            v160 = (v158.UserInputType == Enum.UserInputType.MouseMovement)
        end
        if v160 then
            up28((up21 + ((math.clamp(((v158.Position.X - up25.AbsolutePosition .X) / up25.AbsoluteSize.X), 0, 1)) * (up17 - up21))))
        end
        return
    end)

    return
end
capturedValues1.value31 = nil
v1960 = function(arg59_1, arg59_2, arg59_3, arg59_4, arg59_5)
    local up30 = arg59_3
    local up31 = arg59_4
    local up32 = arg59_5
    local v798 = Instance.new("Frame", arg59_1)
    local up33 = v798
    up33.Size = UDim2.new(1, 0, 0, 38)
    up33.BackgroundColor3 = capturedValues1.value16.Btn
    up33.BorderSizePixel = 0
    capturedValues1.value17(up33, 8)
    local v799 = (Instance.new("TextLabel", up33))
    v799.Text = arg59_2
    v799.Font = Enum.Font.Gotham
    v799.TextSize = 13
    v799.TextColor3 = capturedValues1.value16.Text
    v799.BackgroundTransparency = 1
    v799.Size = UDim2.new(1, -58, 1, 0)
    v799.Position = UDim2.new(0, 12, 0, 0)
    v799.TextXAlignment = Enum.TextXAlignment.Left
    v798 = Instance.new("Frame", up33)
    local up34 = v798
    up34.Size = UDim2.new(0, 42, 0, 22)
    up34.Position = UDim2.new(1, -52, 0.5, -11)
    up34.BorderSizePixel = 0
    capturedValues1.value17(up34, 11)
    v798 = Instance.new("Frame", up34)
    local up35 = v798
    up35.Size = UDim2.new(0, 18, 0, 18)
    up35.BorderSizePixel = 0
    capturedValues1.value17(up35, 9)
    up35.BackgroundColor3 = capturedValues1.value16.Knob
    local up36 = function()
        local v541, v542, v550, v551
        local v536 = up30()
        local v535 = capturedValues1.value13
        local v537 = up34
        local v538 = v536
        local v539 = capturedValues1.value14
        v541, v542 = v535, v538
        if v538 then
            v542 = capturedValues1.value16.TON
        end
        local v540 = v542
        if not (v542) then
            v540 = capturedValues1.value16.TOFF
        end
        v535, v551 = v541, {["BackgroundColor3"] = v540}
        v535(v537, v539, v551)
        v535 = capturedValues1.value13
        v537 = up35
        v539 = capturedValues1.value14
        v541, v550 = v535, v535
        v542 = v538
        if v538 then
            v542 = (UDim2.new(1, -20, 0.5, -9))
        end
        v535, v540 = v550, v542
        if not (v542) then
            v540 = (UDim2.new(0, 2, 0.5, -9))
        end
        v535, v551 = v541, {["Position"] = v540}
        v535(v537, v539, v551)

        return
    end
    up36()
    local v805 = (Instance.new("TextButton", up33))
    v805.Size = UDim2.new(1, 0, 1, 0)
    v805.BackgroundTransparency = 1
    v805.Text = ""
    local v803 = v805.MouseEnter
    local v806 = function()
        local v552 = capturedValues1.value13
        local v553 = up33
        local v554 = capturedValues1.value14
        local v555 = capturedValues1.value16.BtnH
        v552(v553, v554, {["BackgroundColor3"] = v555})

        return
    end
    v803:Connect(v806)
    v803 = v805.MouseLeave
    v806 = function()
        local v564 = capturedValues1.value13
        local v565 = up33
        local v566 = capturedValues1.value14
        local v567 = capturedValues1.value16.Btn
        v564(v565, v566, {["BackgroundColor3"] = v567})

        return
    end
    v803:Connect(v806)
    v806 = function()
        up31((not (up30())))
        up36()
        if up32 then
            up32(up30())
        end
        return
    end
    v805.MouseButton1Click :Connect(v806)

    return up33, up36
end
v1957 = function(arg60_1, arg60_2)
    local v815 = (Instance.new("Frame", arg60_1))
    v815.Size = UDim2.new(1, 0, 0, 26)
    v815.BackgroundColor3 = capturedValues1.value16.Sec
    v815.BorderSizePixel = 0
    capturedValues1.value17(v815, 6)
    capturedValues1.value18(v815, capturedValues1.value16.Accent, .7)
    local v812 = (Instance.new("TextLabel", v815))
    v812.Text = ("  >> " .. arg60_2)
    v812.Font = Enum.Font.GothamBold
    v812.TextSize = 11
    v812.TextColor3 = capturedValues1.value16.Accent
    v812.BackgroundTransparency = 1
    v812.Size = UDim2.new(1, 0, 1, 0)
    v812.TextXAlignment = Enum.TextXAlignment.Left
    return
end
capturedValues1.value32 = {}
v1955 = function(arg61_1)
    local up37 = arg61_1
    local v821 = Instance.new("ScrollingFrame", capturedValues1.value30)
    local up38 = v821
    up38.Size = UDim2.new(1, 0, 1, 0)
    up38.BackgroundTransparency = 1
    up38.BorderSizePixel = 0
    up38.ScrollBarThickness = 3
    up38.ScrollBarImageColor3 = capturedValues1.value16.Accent
    up38.CanvasSize = UDim2.new(0, 0, 0, 0)
    up38.AutomaticCanvasSize = Enum.AutomaticSize.Y
    up38.Visible = false
    local v822 = (Instance.new("UIListLayout", up38))
    v822.SortOrder = Enum.SortOrder.LayoutOrder
    v822.Padding = UDim.new(0, 5)
    capturedValues1.value19(up38, 10, 10, 10, 14)
    v821 = Instance.new("TextButton", capturedValues1.value29)
    local up39 = v821
    up39.Size = UDim2.new(1, 0, 0, 36)
    up39.BackgroundColor3 = capturedValues1.value16.TabOff
    up39.BorderSizePixel = 0
    up39.Text = up37
    up39.Font = Enum.Font.GothamBold
    up39.TextSize = 12
    up39.TextColor3 = capturedValues1.value16.Sub
    up39.TextXAlignment = Enum.TextXAlignment.Left
    up39.AutoButtonColor = false
    capturedValues1.value17(up39, 7)
    capturedValues1.value19(up39, 0, 12, 0, 0)
    v821 = Instance.new("Frame", up39)
    local up40 = v821
    up40.Size = UDim2.new(0, 3, .6, 0)
    up40.Position = UDim2.new(0, 0, .2, 0)
    up40.BackgroundColor3 = capturedValues1.value16.Accent
    up40.BorderSizePixel = 0
    capturedValues1.value17(up40, 3)
    up40.Visible = false
    local v826 = up39.MouseEnter
    local v827 = function()
        local v264, v265, v266, v267
        if (capturedValues1.value31 ~= up37) then
            v264 = capturedValues1.value13
            v265 = up39
            v266 = capturedValues1.value14
            v267 = capturedValues1.value16.TabHov
            v264(v265, v266, {["BackgroundColor3"] = v267})
        end
        return
    end
    v826:Connect(v827)
    v826 = up39.MouseLeave
    v827 = function()
        local v276, v277, v278, v279
        if (capturedValues1.value31 ~= up37) then
            v276 = capturedValues1.value13
            v277 = up39
            v278 = capturedValues1.value14
            v279 = capturedValues1.value16.TabOff
            v276(v277, v278, {["BackgroundColor3"] = v279})
        end
        return
    end
    v826:Connect(v827)
    v826 = up39.MouseButton1Click
    v827 = function()
        local v288, v289, v290, v291, v293, v294, v295, v296, v297
        if (capturedValues1.value31 == up37) then
            return
        else
            v289 = capturedValues1.value31 and capturedValues1.value32[capturedValues1.value31]
            if v289 then
                v293 = capturedValues1.value32[capturedValues1.value31].page
                v293.Visible = false
                v293 = capturedValues1.value13
                v288 = capturedValues1.value32[capturedValues1.value31].btn
                v290 = capturedValues1.value14
                v294 = capturedValues1.value16.TabOff
                v296 = capturedValues1.value16.Sub
                v293(v288, v290, {["BackgroundColor3"] = v294, ["TextColor3"] = v296})
                v293 = capturedValues1.value32[capturedValues1.value31].strip
                v293.Visible = false
            end
            v289 = up38
            v289.Visible = true
            v289 = up38
            v291 = UDim2.new (.04, 0, 0, 0)
            v289.Position = v291
            v289 = capturedValues1.value13
            v290 = up38
            v291 = capturedValues1.value15
            v296 = UDim2.new(0, 0, 0, 0)
            v289(v290, v291, {["Position"] = v296})
            v289 = capturedValues1.value13
            v290 = up39
            v291 = capturedValues1.value14
            v295 = capturedValues1.value16.TabOn
            v297 = capturedValues1.value16.Text
            v289(v290, v291, {["BackgroundColor3"] = v295, ["TextColor3"] = v297})
            v289 = up40
            v289.Visible = true
            return
        end
    end
    v826:Connect(v827)
    capturedValues1.value32[up37] = {["page"] = up38, ["btn"] = up39, ["strip"] = up40}

    return up38
end
v1964 = v1955("Aimbot")
local v1965 = v1955("Ragebot")
v1966 = v1955("Movement")
v1967 = v1955("ESP")
v1969 = v1955("Visuals")
v1970 = v1955("Misc")
v1957(v1964, "Aimbot — Camera Lerp")
v1934 = "Aimbot"
v1928 = function(arg62_1)
    capturedValues1.value11.Aimbot = arg62_1
    return
end
v1960(v1964, v1934, function()
    return capturedValues1.value11.Aimbot
end, v1928, nil)
v1928 = function(arg64_1)
    capturedValues1.value11.InstantAim = arg64_1
    return
end
v1936 = function()
    return capturedValues1.value11.InstantAim
end
v1968, v1971 = nil, 11399147033788
v1960(v1964, "Instant Aim", v1936, v1928, v1968)
v1934 = "Smoothing (lower = faster)"
v1928 = function(arg66_1)
    capturedValues1.value11.AimSmooth = arg66_1
    return
end
v1961(v1964, v1934, function()
    return capturedValues1.value11.AimSmooth
end, v1928, .01, .98, nil, v1925)
v1934 = "FOV Radius"
v1936 = function()
    return capturedValues1.value11.FOVRadius
end
v1925, v1968 = nil, 20
v1961(v1964, v1934, v1936, function(arg69_1)
    capturedValues1.value11.FOVRadius = arg69_1
    return
end, v1968, 500, nil, v1925)
v1960(v1964, "Show FOV Circle", function()
    return capturedValues1.value11.ShowFOV
end, function(arg71_1)
    capturedValues1.value11.ShowFOV = arg71_1
    return
end, nil)
v1936 = {"Head", "UpperTorso", "HumanoidRootPart"}
v1928 = function()
    return capturedValues1.value11.AimPart
end
v1968 = function(arg73_1)
    capturedValues1.value11.AimPart = arg73_1
    return
end
spilledValues1.value11, v1971 = 4295528024016, 27028832530730
v1963(v1964, "Aim Part", v1936, v1928, v1968, nil)
v1963(v1964, "Target Priority", {"Crosshair", "Nearest", "Lowest HP", "Highest HP"}, function()
    return capturedValues1.value11.Priority
end, function(arg75_1)
    capturedValues1.value11.Priority = arg75_1
    return
end, nil)
v1928 = function(arg76_1)
    capturedValues1.value11.TeamCheck = arg76_1
    return
end
v1960(v1964, "Team Check", function()
    return capturedValues1.value11.TeamCheck
end, v1928, nil)
v1934 = "Wall Check"
v1928 = function(arg78_1)
    capturedValues1.value11.WallCheck = arg78_1
    return
end
v1968, v1971 = nil, 16253387857296
v1960(v1964, v1934, function()
    return capturedValues1.value11.WallCheck
end, v1928, v1968)
v1928 = function(arg80_1)
    capturedValues1.value11.LockLine = arg80_1
    return
end
v1936 = function()
    return capturedValues1.value11.LockLine
end
v1968, v1971 = nil, 27652534891084
v1960(v1964, "Lock Line", v1936, v1928, v1968)
v1957(v1964, "Silent Aim — CFrame Hook")
v1958(v1964, "Redirects bullet by modifying Camera.CFrame on fire frame")
v1960(v1964, "Silent Aim  [Del key]", function()
    return capturedValues1.value11.SilentAim
end, function(arg83_1)
    capturedValues1.value11.SilentAim = arg83_1
    return
end, nil)
v1928 = function(arg84_1)
    capturedValues1.value11.HitChance = arg84_1
    return
end
v1936 = function()
    return capturedValues1.value11.HitChance
end
v1968, v1971 = 1, nil
v1961(v1964, "Hit Chance %", v1936, v1928, v1968, 100, v1971, nil)
v1928 = function(arg86_1)
    capturedValues1.value11.LeadTargets = arg86_1
    return
end
v1934 = "Lead Moving Targets"
v1971, v1925, v1968 = 20976617580072, nil, nil
v1960(v1964, v1934, function()
    return capturedValues1.value11.LeadTargets
end, v1928, v1968)
v1928 = function(arg88_1)
    capturedValues1.value11.LeadAmt = arg88_1
    return
end
v1936 = function()
    return capturedValues1.value11.LeadAmt
end
v1968, v1971 = .01, nil
v1961(v1964, "Lead Amount", v1936, v1928, v1968, 0.5, v1971, v1925)
v1925, v1971 = nil, 18978922406533
v1928 = function(arg90_1)
    capturedValues1.value11.SkipKatana = arg90_1
    return
end
v1936 = function()
    return capturedValues1.value11.SkipKatana
end
v1971, v1968 = 20325246625016, nil
v1960(v1964, "Skip Deflecting Katanas", v1936, v1928, v1968)
v1957(v1964, "Triggerbot")
v1934 = "Triggerbot"
v1968, v1971 = nil, 13166021531634
v1928 = function(arg92_1)
    capturedValues1.value11.Triggerbot = arg92_1
    return
end
v1960(v1964, v1934, function()
    return capturedValues1.value11.Triggerbot
end, v1928, v1968)
v1934 = "Delay (sec)"
v1928 = function(arg94_1)
    capturedValues1.value11.TrigDelay = arg94_1
    return
end
v1971, v1968 = nil, 0
v1961(v1964, v1934, function()
    return capturedValues1.value11.TrigDelay
end, v1928, v1968, 0.5, v1971, v1925)
v1957(v1964, "Weapon")
v1928 = function(arg96_1)
    capturedValues1.value11.NoRecoil = arg96_1
    return
end
v1960(v1964, "No Recoil", function()
    return capturedValues1.value11.NoRecoil
end, v1928, nil)
v1928 = function(arg98_1)
    capturedValues1.value11.NoSpread = arg98_1
    return
end
v1936 = function()
    return capturedValues1.value11.NoSpread
end
v1971, v1968 = 22349251094695, nil
v1960(v1964, "No Spread", v1936, v1928, v1968)
v1934 = "Rapid Fire"
v1928 = function(arg100_1)
    capturedValues1.value11.RapidFire = arg100_1
    return
end
v1971, v1968 = 17676673130535, nil
v1960(v1964, v1934, function()
    return capturedValues1.value11.RapidFire
end, v1928, v1968)
v1928 = function(arg102_1)
    capturedValues1.value11.AutoDeflect = arg102_1
    return
end
v1960(v1964, "Auto Deflect", function()
    return capturedValues1.value11.AutoDeflect
end, v1928, nil)
v1957(v1965, "Ragebot Preset")
v1958(v1965, "Maxes all combat options in one toggle")
v1960(v1965, "Ragebot", function()
    return capturedValues1.value11.Ragebot
end, function(arg105_1)
    local v1075, v1076
    local v1073 = arg105_1
    capturedValues1.value11.Ragebot = v1073
    capturedValues1.value11.SilentAim = v1073
    local v1074 = capturedValues1.value11
    local v1077 = (v1073 and 100)
    v1075, v1076 = v1077, v1074
    if not (v1077) then
        v1075 = capturedValues1.value11.HitChance
    end
    v1076.HitChance = v1075
    capturedValues1.value11.InstantAim = v1073
    capturedValues1.value11.NoRecoil = v1073
    capturedValues1.value11.NoSpread = v1073
    capturedValues1.value11.RapidFire = v1073
    return
end, nil)
v1962(v1965, "Apply Max Settings", function()
    capturedValues1.value11.Ragebot = true
    capturedValues1.value11.SilentAim = true
    capturedValues1.value11.HitChance = 100
    capturedValues1.value11.InstantAim = true
    capturedValues1.value11.NoRecoil = true
    capturedValues1.value11.NoSpread = true
    capturedValues1.value11.RapidFire = true
    return
end)
v1962(v1965, "Reset to Legit", function()
    capturedValues1.value11.Ragebot = false
    capturedValues1.value11.InstantAim = false
    capturedValues1.value11.NoRecoil = false
    capturedValues1.value11.NoSpread = false
    capturedValues1.value11.RapidFire = false
    capturedValues1.value11.HitChance = 85
    capturedValues1.value11.AimSmooth = .18
    return
end)
v1957(v1966, "Speed")
v1928 = function(arg108_1)
    capturedValues1.value11.SpeedBoost = arg108_1
    return
end
v1960(v1966, "Speed Boost", function()
    return capturedValues1.value11.SpeedBoost
end, v1928, function(arg110_1)
    local v1107, v1108, v1110, v1111
    local v1105 = capturedValues1.value10
    local v1106 = arg110_1
    if v1105 then
        v1105 = capturedValues1.value10
        v1111 = "WalkSpeed"
        v1107 = v1105
        v1110 = v1106
        if v1106 then
            v1110 = capturedValues1.value11.SpeedAmt
        end
        v1105 = v1107
        v1108 = (v1110 or 16)
        v1105[v1111] = v1108
    end
    return
end)
v1928 = function(arg111_1)
    local v1118 = arg111_1
    local v1119 = capturedValues1.value11
    v1119.SpeedAmt = v1118
    local v1123 = capturedValues1.value11.SpeedBoost and capturedValues1.value10
    if v1123 then
        v1119 = capturedValues1.value10
        v1119.WalkSpeed = v1118
    end
    return
end
v1961(v1966, "Speed Amount", function()
    return capturedValues1.value11.SpeedAmt
end, v1928, 16, 300, nil, nil)
v1960(v1966, "No Slowdown", function()
    return capturedValues1.value11.NoSlowdown
end, function(arg114_1)
    capturedValues1.value11.NoSlowdown = arg114_1
    return
end, nil)
v1928 = function(arg115_1)
    capturedValues1.value11.SprintLock = arg115_1
    return
end
v1960(v1966, "Sprint Lock", function()
    return capturedValues1.value11.SprintLock
end, v1928, nil)
v1925, v1971 = nil, 12658839148294
v1957(v1966, "Jump")
v1928 = function(arg117_1)
    capturedValues1.value11.AirJumps = arg117_1
    capturedValues1.value11.AirJumpsLeft = capturedValues1.value11.AirJumpMax
    return
end
v1960(v1966, "Air Jumps", function()
    return capturedValues1.value11.AirJumps
end, v1928, nil)
v1928 = function(arg119_1)
    capturedValues1.value11.AirJumpMax = arg119_1
    return
end
v1934 = "Air Jump Count"
v1971, v1968 = nil, 1
v1961(v1966, v1934, function()
    return capturedValues1.value11.AirJumpMax
end, v1928, v1968, 15, v1971, v1925)
v1925 = nil
v1957(v1966, "Flight  [WASD + Space/Ctrl]")
v1934 = "Flight"
v1936 = function()
    return capturedValues1.value11.Flight
end
v1968 = function(arg122_1)
    local v1186, v1187, v1188, v1190
    if arg122_1 then
        v1186 = capturedValues1.value11
        v1188 = Instance.new("BodyVelocity")
        v1186.FlyVel = v1188
        v1186 = capturedValues1.value11.FlyVel
        v1188 = Vector3.new(1000000000, 1000000000, 1000000000)
        v1186.MaxForce = v1188
        v1186 = capturedValues1.value11.FlyVel
        v1187 = Vector3.zero
        v1186.Velocity = v1187
        v1186 = capturedValues1.value11.FlyVel
        v1186.Parent = capturedValues1.value9
        v1186 = capturedValues1.value11
        v1188 = Instance.new("BodyGyro")
        v1186.FlyGyro = v1188
        v1186 = capturedValues1.value11.FlyGyro
        v1188 = Vector3.new (1000000000, 1000000000, 1000000000)
        v1186.MaxTorque = v1188
        v1186 = capturedValues1.value11.FlyGyro
        v1186.P = 10000
        v1186 = capturedValues1.value11.FlyGyro
        v1187 = capturedValues1.value9
        v1186.Parent = v1187
    else
        v1190 = capturedValues1.value11
        if v1190["FlyVel"] then
            capturedValues1.value11.FlyVel :Destroy()
            v1186 = capturedValues1.value11
            v1186.FlyVel = nil
        end
        v1190 = capturedValues1.value11
        if v1190["FlyGyro"] then
            capturedValues1.value11.FlyGyro :Destroy()
            v1186 = capturedValues1.value11
            v1186.FlyGyro = nil
        end
    end
    return
end
v1960(v1966, v1934, v1936, function(arg123_1)
    capturedValues1.value11.Flight = arg123_1
    return
end, v1968)
v1961(v1966, "Flight Speed", function()
    return capturedValues1.value11.FlySpeed
end, function(arg125_1)
    capturedValues1.value11.FlySpeed = arg125_1
    return
end, 20, 400, nil, v1925)
v1957(v1966, "Ability Haste")
v1928 = function(arg126_1)
    capturedValues1.value11.MeleeHaste = arg126_1
    return
end
v1936 = function()
    return capturedValues1.value11.MeleeHaste
end
v1968, v1971 = nil, 27269913457050
v1960(v1966, "Melee Haste", v1936, v1928, v1968)
v1928 = function(arg128_1)
    capturedValues1.value11.AbilityHaste = arg128_1
    return
end
v1934 = "Ability Haste"
v1971, v1968 = 7292195769667, nil
v1960(v1966, v1934, function()
    return capturedValues1.value11.AbilityHaste
end, v1928, v1968)
v1934 = "Quick Fuse"
v1928 = function(arg130_1)
    capturedValues1.value11.QuickFuse = arg130_1
    return
end
v1960(v1966, v1934, function()
    return capturedValues1.value11.QuickFuse
end, v1928, nil)
v1957(v1967, "Core")
v1936 = function()
    return capturedValues1.value11.ESP
end
v1928 = function(arg133_1)
    capturedValues1.value11.ESP = arg133_1
    return
end
v1968, v1971 = nil, 25047964806543
v1960(v1967, "ESP Master Toggle", v1936, v1928, v1968)
v1928 = function(arg134_1)
    capturedValues1.value11.ESPBox = arg134_1
    return
end
v1960(v1967, "Box ESP", function()
    return capturedValues1.value11.ESPBox
end, v1928, nil)
v1934 = "Filled Box"
v1928 = function(arg136_1)
    capturedValues1.value11.FilledBox = arg136_1
    return
end
v1960(v1967, v1934, function()
    return capturedValues1.value11.FilledBox
end, v1928, nil)
v1928 = function(arg138_1)
    capturedValues1.value11.ESPName = arg138_1
    return
end
v1960(v1967, "Name Tag", function()
    return capturedValues1.value11.ESPName
end, v1928, nil)
v1936 = function()
    return capturedValues1.value11.HealthBar
end
v1928 = function(arg141_1)
    capturedValues1.value11.HealthBar = arg141_1
    return
end
v1968, v1971 = nil, 16187184487793
v1960(v1967, "Health Bar", v1936, v1928, v1968)
v1928 = function(arg142_1)
    capturedValues1.value11.HealthNum = arg142_1
    return
end
v1960(v1967, "Health Number", function()
    return capturedValues1.value11.HealthNum
end, v1928, nil)
v1960(v1967, "Distance", function()
    return capturedValues1.value11.ESPDist
end, function(arg145_1)
    capturedValues1.value11.ESPDist = arg145_1
    return
end, nil)
v1934 = "Weapon Name"
v1928 = function(arg146_1)
    capturedValues1.value11.ESPWeapon = arg146_1
    return
end
v1960(v1967, v1934, function()
    return capturedValues1.value11.ESPWeapon
end, v1928, nil)
v1934 = "Head Dot"
v1928 = function(arg148_1)
    capturedValues1.value11.HeadDot = arg148_1
    return
end
v1971, v1968 = 15003022957386, nil
v1960(v1967, v1934, function()
    return capturedValues1.value11.HeadDot
end, v1928, v1968)
v1934 = "Show Teammates"
v1928 = function(arg150_1)
    capturedValues1.value11.ShowTeammates = arg150_1
    return
end
v1960(v1967, v1934, function()
    return capturedValues1.value11.ShowTeammates
end, v1928, nil)
v1934 = "Offscreen Arrows"
v1928 = function(arg152_1)
    capturedValues1.value11.OffscreenInd = arg152_1
    return
end
v1960(v1967, v1934, function()
    return capturedValues1.value11.OffscreenInd
end, v1928, nil)
v1957(v1967, "Tracers")
v1928 = function(arg154_1)
    capturedValues1.value11.Tracers = arg154_1
    return
end
v1934 = "Tracers"
v1925, v1968 = "\184\177\155p\014\148", nil
v1960(v1967, v1934, function()
    return capturedValues1.value11.Tracers
end, v1928, v1968)
v1934 = "Tracer Origin"
v1936 = {"Bottom", "Center", "Top", "Mouse"}
v1968 = function(arg156_1)
    capturedValues1.value11.TracerFrom = arg156_1
    return
end
v1963(v1967, v1934, v1936, function()
    return capturedValues1.value11.TracerFrom
end, v1968, nil)
v1957(v1967, "Chams")
v1928 = function(arg158_1)
    local v1388, v1389, v1391, v1392, v1393
    local v1386 = capturedValues1.value11
    v1386.Chams = arg158_1
    if (not arg158_1) then
        v1391 = pairs
        v1392 = ChamsTable
        v1389 = v1392 or {}
        v1386 = v1391
        for v1388, v1392 in v1386(v1389) do
            local up41 = v1392
            v1393 = function()
                up41:Destroy()
                return
            end
            v1386 = pcall
            v1392 = nil
            v1386(v1393)
        end
        ChamsTable = {}
    end
    return
end
v1934 = "Chams (Highlight)"
v1971, v1968 = 3843309356797, nil
v1960(v1967, v1934, function()
    return capturedValues1.value11.Chams
end, v1928, v1968)
v1934 = "Occlude Chams (walls only)"
v1928 = function(arg160_1)
    capturedValues1.value11.OccludeChams = arg160_1
    return
end
v1960(v1967, v1934, function()
    return capturedValues1.value11.OccludeChams
end, v1928, nil)
v1957(v1969, "Lighting")
v1934 = "Fullbright"
v1968 = function(arg162_1)
    local v1412, v1413, v1414
    if arg162_1 then
        v1412 = capturedValues1.value4
        v1412.Brightness = 6
        v1412 = capturedValues1.value4
        v1414 = Color3.fromRGB(255, 255, 255)
        v1412.Ambient = v1414
        v1412 = capturedValues1.value4
        v1412.GlobalShadows = false
    else
        v1412 = capturedValues1.value4
        v1413 = capturedValues1.value11.OrigBright
        v1412.Brightness = v1413
        v1412 = capturedValues1.value4
        v1413 = capturedValues1.value11.OrigAmbient
        v1412.Ambient = v1413
        v1412 = capturedValues1.value4
        v1413 = capturedValues1.value11.OrigShadows
        v1412.GlobalShadows = v1413
    end
    return
end
v1960(v1969, v1934, function()
    return capturedValues1.value11.Fullbright
end, function(arg164_1)
    capturedValues1.value11.Fullbright = arg164_1
    return
end, v1968)
v1934 = "No Fog"
v1928 = function(arg165_1)
    capturedValues1.value11.NoFog = arg165_1
    return
end
v1960(v1969, v1934, function()
    return capturedValues1.value11.NoFog
end, v1928, function(arg167_1)
    local v1442, v1443
    if arg167_1 then
        v1442 = capturedValues1.value4
        v1442.FogEnd = 1000000000
        v1442 = capturedValues1.value4
        v1442.FogStart = 900000000
    else
        v1442 = capturedValues1.value4
        v1443 = capturedValues1.value11.OrigFogEnd
        v1442.FogEnd = v1443
        v1442 = capturedValues1.value4
        v1443 = capturedValues1.value11.OrigFogStart
        v1442.FogStart = v1443
    end
    return
end)
v1934 = "Camera FOV"
v1925 = function(arg168_1)
    capturedValues1.value7.FieldOfView = arg168_1
    return
end
v1961(v1969, v1934, function()
    return capturedValues1.value11.CamFOV
end, function(arg170_1)
    capturedValues1.value11.CamFOV = arg170_1
    capturedValues1.value7.FieldOfView = arg170_1
    return
end, 40, 140, nil, v1925)
v1928 = function(arg171_1)
    capturedValues1.value11.OverrideTime = arg171_1
    return
end
v1934 = "Override Time of Day"
v1968 = function(arg172_1)
    local v1471, v1472
    if arg172_1 then
        v1471 = capturedValues1.value4
        v1472 = capturedValues1.value11.TimeVal
        v1471.ClockTime = v1472
    else
        v1471 = capturedValues1.value4
        v1472 = capturedValues1.value11.OrigClockTime
        v1471.ClockTime = v1472
    end
    return
end
v1971, v1925 = 32258823404205, nil
v1960(v1969, v1934, function()
    return capturedValues1.value11.OverrideTime
end, v1928, v1968)
v1934 = "Time of Day"
v1928 = function(arg174_1)
    local v1485 = arg174_1
    local v1486 = capturedValues1.value11
    v1486.TimeVal = v1485
    local v1490 = capturedValues1.value11
    if v1490["OverrideTime"] then
        v1486 = capturedValues1.value4
        v1486.ClockTime = v1485
    end
    return
end
v1961(v1969, v1934, function()
    return capturedValues1.value11.TimeVal
end, v1928, 0, 24, nil, v1925)
v1936 = function()
    return capturedValues1.value11.ExposureShift
end
v1928 = function(arg177_1)
    capturedValues1.value11.ExposureShift = arg177_1
    capturedValues1.value4.ExposureCompensation = arg177_1
    return
end
v1925 = function(arg178_1)
    capturedValues1.value4.ExposureCompensation = arg178_1
    return
end
v1961(v1969, "Exposure Shift", v1936, v1928, -5, 5, nil, v1925)
v1957(v1969, "Post FX")
v1934 = "Glow / Bloom"
v1968 = function(arg179_1)
    local v1514 = arg179_1
    local v1518 = capturedValues1.value4:FindFirstChildOfClass("BloomEffect")
    local v1521 = v1518
    if not (v1518) then
        v1521 = (Instance.new("BloomEffect", capturedValues1.value4))
    end
    local v1515 = v1521
    v1515.Enabled = v1514
    v1515.Intensity = ((v1514 and 2.2) or 0)
    v1515.Size = ((v1514 and 60) or 24)
    v1515.Threshold = ((v1514 and .9) or 1)

    return
end
v1928 = function(arg180_1)
    capturedValues1.value11.GlowFX = arg180_1
    return
end
v1960(v1969, v1934, function()
    return capturedValues1.value11.GlowFX
end, v1928, v1968)
v1928 = function(arg182_1)
    capturedValues1.value11.SoftFocus = arg182_1
    return
end
v1934 = "Soft Focus (DoF)"
v1968 = function(arg183_1)
    local v1539 = arg183_1
    local v1542 = capturedValues1.value4:FindFirstChildOfClass("DepthOfFieldEffect")
    local v1546 = v1542
    if not (v1542) then
        v1546 = (Instance.new("DepthOfFieldEffect", capturedValues1.value4))
    end
    local v1540 = v1546
    v1540.Enabled = v1539
    v1540.FarIntensity = ((v1539 and .35) or 0)
    v1540.NearIntensity = ((v1539 and 0.25) or 0)

    return
end
v1960(v1969, v1934, function()
    return capturedValues1.value11.SoftFocus
end, v1928, v1968)
v1934 = "Sun Rays"
v1928 = function(arg185_1)
    capturedValues1.value11.ColorGrade = arg185_1
    return
end
v1968 = function(arg186_1)
    local v1562, v1563
    local v1559 = capturedValues1.value4
    v1562, v1563 = arg186_1, v1559.FindFirstChildOfClass
    v1563 = v1563(v1559, "SunRaysEffect")
    local v1566 = v1563
    if not (v1563) then
        v1566 = (Instance.new("SunRaysEffect", capturedValues1.value4))
    end
    v1559 = v1566
    v1559.Enabled = v1562
    v1559.Intensity = ((v1562 and .2) or 0)

    return
end
v1960(v1969, v1934, function()
    return capturedValues1.value11.ColorGrade
end, v1928, v1968)
v1960(v1969, "Haze (Atmosphere)", function()
    return capturedValues1.value11.HazeFX
end, function(arg189_1)
    capturedValues1.value11.HazeFX = arg189_1
    return
end, function(arg190_1)
    local v1585 = arg190_1
    local v1589 = capturedValues1.value4:FindFirstChildOfClass("Atmosphere")
    local v1592 = v1589
    if not (v1589) then
        v1592 = (Instance.new("Atmosphere", capturedValues1.value4))
    end
    local v1586 = v1592
    if v1585 then
        v1586.Haze = 2.2
        v1586.Density = .38
    else
        v1586.Haze = 0
        v1586.Density = .3
    end
    return
end)
v1934 = "Clear Sky Override"
v1968 = function(arg191_1)
    local v1599
    if arg191_1 then
        v1599 = capturedValues1.value4:FindFirstChild("_RSky")
        if (not v1599) then
            v1599 = (Instance.new("Sky", capturedValues1.value4))
            v1599.Name = "_RSky"
        end
    else
        v1599 = (capturedValues1.value4:FindFirstChild("_RSky"))
        if v1599 then
            v1599:Destroy()
        end
    end
    return
end
v1928 = function(arg192_1)
    capturedValues1.value11.SkyOverride = arg192_1
    return
end
v1960(v1969, v1934, function()
    return capturedValues1.value11.SkyOverride
end, v1928, v1968)
v1934 = "Ambient Tint"
v1936 = function()
    return capturedValues1.value11.AmbientTint
end
v1968 = function(arg195_1)
    local v1619, v1620, v1621
    local v1618 = capturedValues1.value4
    v1621, v1620 = v1618, v1618
    local v1622 = arg195_1
    if arg195_1 then
        v1622 = capturedValues1.value11.AmbientCol
    end
    v1619, v1618 = v1622, v1621
    if not (v1622) then
        v1619 = capturedValues1.value11.OrigAmbient
    end
    v1620.Ambient = v1619
    return
end
v1960(v1969, v1934, v1936, function(arg196_1)
    capturedValues1.value11.AmbientTint = arg196_1
    return
end, v1968)
v1957(v1970, "Combat FX")
v1928 = function(arg197_1)
    capturedValues1.value11.HitChime = arg197_1
    return
end
v1960(v1970, "Hit Chime", function()
    return capturedValues1.value11.HitChime
end, v1928, nil)
v1934 = "Hit Cross"
v1928 = function(arg199_1)
    capturedValues1.value11.HitCross = arg199_1
    return
end
v1960(v1970, v1934, function()
    return capturedValues1.value11.HitCross
end, v1928, nil)
v1928 = function(arg201_1)
    capturedValues1.value11.DamageFeed = arg201_1
    return
end
v1960(v1970, "Damage Feed", function()
    return capturedValues1.value11.DamageFeed
end, v1928, nil)
v1928 = function(arg203_1)
    capturedValues1.value11.ShotTrails = arg203_1
    return
end
v1960(v1970, "Shot Trails", function()
    return capturedValues1.value11.ShotTrails
end, v1928, nil)
v1934 = "Hide Gun Flashes"
v1928 = function(arg205_1)
    capturedValues1.value11.HideFlashes = arg205_1
    return
end
v1960(v1970, v1934, function()
    return capturedValues1.value11.HideFlashes
end, v1928, nil)
v1934 = "Clear Smoke"
v1928 = function(arg207_1)
    capturedValues1.value11.ClearSmoke = arg207_1
    return
end
v1960(v1970, v1934, function()
    return capturedValues1.value11.ClearSmoke
end, v1928, nil)
v1957(v1970, "Security")
v1928 = function(arg209_1)
    capturedValues1.value11.SpectatorAlert = arg209_1
    return
end
v1936 = function()
    return capturedValues1.value11.SpectatorAlert
end
v1971, v1968 = 27733425091186, nil
v1960(v1970, "Spectator Alert", v1936, v1928, v1968)
v1957(v1970, "Status")
spilledValues1.value12 = v1958(v1970, "Target: none", capturedValues1.value16.Org)
capturedValues1.value33 = spilledValues1.value12
spilledValues1.value12 = v1958(v1970, "FPS: -- | Ping: --ms", capturedValues1.value16.Sub)
capturedValues1.value34 = spilledValues1.value12
spilledValues1.value11, v1925 = 6403656141733, "k\172\205\127\144V\249\020a\242 \164"
spilledValues1.value12 = v1958(v1970, "Position: --", capturedValues1.value16.Sub)
capturedValues1.value35 = spilledValues1.value12
spilledValues1.value10, v1929 = 27367379857863, 864673366418
v1957(v1970, "Keybinds")
v1958(v1970, "Insert       — Toggle window")
v1958(v1970, "Delete       — Toggle Silent Aim")
spilledValues1.value11, v1929 = "\232\242\2505)\003\134\240\203&M\025\174\025g\014\1603\134\204-\129\166\244\207\020\247\157H\023", 7468539661717
v1958(v1970, "End          — Toggle Aimbot")
v1929, spilledValues1.value11 = 13555891378344, "\168C\129\185t\182\148\207Ïa1G\232\201˒w\144\155\166\183\023\230\015\nE"
v1958(v1970, "RightShift   — Toggle ESP")
task.defer(function()
    capturedValues1.value32.Aimbot.btn.MouseButton1Click:Fire()
    return
end)
spilledValues1.value12 = Drawing.new
v1929, spilledValues1.value10 = "\173\186\164| \170", 18667145798132
v1968 = spilledValues1.value12("Circle")
capturedValues1.value36 = v1968
capturedValues1.value36.Visible = false
v1968 = capturedValues1.value36
v1971 = Color3.fromRGB
spilledValues1.value11, v1929 = 210, 35
v1968.Color = v1971(spilledValues1.value11, v1929, 65)
v1968 = capturedValues1.value36
v1971, spilledValues1.value10 = 1, 31562328340841
v1968.Transparency = v1971
v1968 = capturedValues1.value36
v1929, v1971, spilledValues1.value10 = "1B\145\188\135\232", 1.5, 29699586504197
v1968.Thickness = v1971
capturedValues1.value36.Filled = false
local v1972 = Drawing.new("Line")
capturedValues1.value37 = v1972
v1972 = capturedValues1.value37
spilledValues1.value10, v1925 = "+2\020O0", false
v1972.Visible = v1925
capturedValues1.value37.Color = Color3.fromRGB(210, 35, 65)
capturedValues1.value37.Thickness = 1.5
capturedValues1.value37.Transparency = .55
v1972 = {}
spilledValues1.value11 = 4
capturedValues1.value38 = v1972
v1929 = 1
for v1925 = 1, spilledValues1.value11, v1929 do
    v1974 = Drawing.new("Line")
    v1974.Visible = false
    v1976 = Color3.fromRGB(255, 255, 255)
    v1974.Color = v1976
    v1974.Thickness = 2
    v1973 = capturedValues1.value38
    v1973[v1925] = v1974
end
v1972 = function(arg22_1)
    local v318, v319, v320, v321, v323, v325, v329
    v318, v319, v320, v321 = arg22_1, 0, 0, 10
    local v322 = v321
    local v324 = {(-v322), v320, v322, v319}
    v325, v320 = 0, 0
    v323, v324 = {v324, {v320, (-v322), v325, v322}}, "ipairs"
    v321 = ipairs
    for v319, v326 in v321(v323) do
        v321 = capturedValues1.value38[v319]
        v329 = Vector2.new((v318.X + v326[1]), (v318.Y + v326[2]))
        v321.From = v329
        v321 = capturedValues1.value38[v319]
        v329 = Vector2.new((v318.X + v326[3]), (v318.Y + v326[4]))
        v321.To = v329
        v321 = capturedValues1.value38[v319]
        v321.Visible = true
    end
    task.delay(.12, function()
        local v314
        local v309 = 2
        local v310 = 1
        for v308 = 1, v309, v310 do
            v314 = capturedValues1.value38[v308]
            v314.Visible = false
        end
        return
    end)

    return
end
capturedValues1.value39 = nil
v1976 = function(arg23_1)
    local v340, v344, v345, v346
    local v338 = capturedValues1.value39
    local v339 = arg23_1
    if v338[v339] then
        for v344, v345 in pairs(capturedValues1.value39[v339]) do
            local up1 = v345
            v346 = function()
                up1:Remove()
                return
            end
            v345 = nil
            pcall(v346)
        end
        v340 = capturedValues1.value39
        v340[v339] = nil
    end
    return
end
capturedValues1.value40 = {}
local v1977 = function()
    local v348, v349, v350, v351, v357, v358, v359, v361, v362, v363, v370, v371, v372
    local v373, v374
    v348, v349, v350 = nil, "\154P};", "math"
    v350, v351 = math.huge, v348
    local v352 = (capturedValues1.value2:GetMouseLocation())
    v348 = ipairs
    v349 = capturedValues1.value1
    local v356 = v349.GetPlayers
    for v354, v356 in v348(v356(v349)) do
        if not ((v356 == capturedValues1.value6))then
            v362 = capturedValues1.value11.TeamCheck
            v363 = v362
            if v362 then
                v357 = v348
                v361 = v356.Team
                v362 = v361
                if v361 then
                    v359 = capturedValues1.value6.Team
                    v361 = v359
                    if v359 then
                        v361 = (v356.Team == capturedValues1.value6.Team)
                    end
                    v362 = v361
                end
                v348, v363 = v357, v362
            end
            if not (v363) then
                if not ((not v356["Character"]))then
                    v370 = (v356.Character:FindFirstChild("HumanoidRootPart"))
                    v348 = v356.Character
                    v363 = v348:FindFirstChildOfClass("Humanoid")
                    v362 = (not v370)
                    v371 = v363
                    v363 = v362
                    if not (v362) then
                        v361, v357 = (not v371), v348
                        v362 = v361 or (v371.Health <= 0)
                        v363, v348 = v362, v357
                    end
                    if not (v363) then
                        v363 = capturedValues1.value11
                        if v363["WallCheck"] then
                            v363 = (v370.Position - capturedValues1.value7.CFrame.Position)
                            v362 = Ray.new(capturedValues1.value7.CFrame.Position, (v363.Unit * v363.Magnitude))
                            v348 = capturedValues1.value5
                            v358 = capturedValues1.value8
                            v359 = v356.Character
                            v361 = {v358, v359}
                            v357 = v348:FindPartOnRayWithIgnoreList(v362, v361)
                            if v357 then
                                continue
                            end
                        end
                        v348 = capturedValues1.value7
                        v357 = v370.Position
                        v363, v362 = v348:WorldToScreenPoint(v357)
                        v348 = (not v362)
                        v372 = v363
                        if not (v348) then
                            v348 = ((Vector2.new(v372.X, v372.Y)) - v352).Magnitude
                            v362 = capturedValues1.value11
                            v373 = v348
                            if not ((v373 > v362["FOVRadius"]))then
                                v348 = nil
                                v363 = capturedValues1.value11.Priority
                                if (v363 == "Crosshair") then
                                    v348 = v373
                                    v374 = v348
                                else
                                    v362 = capturedValues1.value11.Priority
                                    if (v362 == "Nearest") then
                                        v374 = (v370.Position - capturedValues1.value9.Position).Magnitude
                                    else
                                        v357 = capturedValues1.value11.Priority
                                        if (v357 == "Lowest HP") then
                                            v374 = v371.Health
                                        else
                                            v361 = capturedValues1.value11.Priority
                                            if (v361 == "Highest HP") then
                                                v374 = (-v371.Health)
                                            else
                                                v374 = v373
                                            end
                                        end
                                    end
                                end
                                if (v374 < v350) then
                                    v350 = v374
                                    v351 = v356
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return v351
end
capturedValues1.value41 = nil
v1925 = function(arg25_1, arg25_2)
    local v378, v381, v382, v383, v385, v388
    local v375 = capturedValues1.value11
    local v376 = arg25_2
    local v379 = arg25_1
    if (not v375["DamageFeed"]) then
        return
    else
        v375 = (Drawing.new("Text"))
        v378 = tostring(math.floor(v379))
        v375.Text = ("-" .. v378)
        v382 = Color3.fromRGB(255, 70, 55)
        v375.Color = v382
        v375.Size = 17
        v381 = Drawing.Fonts.GothamBold
        v375.Font = v381
        v375.Position = v376
        v375.Visible = true
        v375.Outline = true
        v383 = table.insert
        v382 = capturedValues1.value40
        v388 = tick()
        v385 = v376.Y
        v383(v382, {["d"] = v375, ["t"] = v388, ["baseY"] = v385})
        return
    end
end
pcall(function()
    capturedValues1.value41 = (Instance.new("Sound", capturedValues1.value20))
    capturedValues1.value41.SoundId = "rbxassetid://6042053626"
    capturedValues1.value41.Volume = 0.5
    return
end)
v1973, v1929 = "ChamsTable", {}
v1974 = function()
    local v398, v401, v402, v403, v404, v405, v406, v407, v408, v409, v410, v411, v412, v413, v421
    v398, v401, v402 = pairs(ChamsTable)
    local v400 = v398
    while true do
        v402, v403 = v400(v401, v402)
        if not v402 then
            break
        end
        local up2 = v403
        pcall(function()
            up2:Destroy()
            return
        end)
    end
    local v399 = {}
    ChamsTable = v399
    v400 = capturedValues1.value11
    if (not v400["Chams"]) then
        return
    else
        v401 = ipairs
        v403 = capturedValues1.value1
        v404 = v403.GetPlayers
        for v406, v403 in v401(v404(v403)) do
            if not ((v403 == capturedValues1.value6))then
                v413 = (not capturedValues1.value11.ShowTeammates)
                v404 = v413
                if v413 then
                    v412 = v399
                    v407 = capturedValues1.value11.TeamCheck
                    v413 = v407
                    if v407 then
                        v411 = v399
                        v408 = v403.Team
                        v407 = v408
                        if v408 then
                            v409 = v399
                            v410 = capturedValues1.value6.Team
                            v408 = v410
                            if v410 then
                                v408 = (v403.Team == capturedValues1.value6.Team)
                            end
                            v407, v399 = v408, v409
                        end
                        v413, v399 = v407, v411
                    end
                    v404, v399 = v413, v412
                end
                if not (v404) then
                    if not ((not v403["Character"]))then
                        v405 = (Instance.new("Highlight", capturedValues1.value3))
                        v421 = v403.Character
                        v405.Adornee = v421
                        v421 = capturedValues1.value11.ESPColor
                        v405.FillColor = v421
                        v421 = Color3.fromRGB
                        v407, v412 = 255, 255
                        v413 = v421(v412, v407, 255)
                        v405.OutlineColor = v413
                        v405.FillTransparency = .35
                        v405.OutlineTransparency = 0
                        v407 = v399
                        v404 = "DepthMode"
                        v413 = v399
                        v411 = capturedValues1.value11.OccludeChams
                        v412 = v411
                        if v411 then
                            v412 = Enum.HighlightDepthMode.Occluded
                        end
                        v399, v421 = v407, v412
                        if not (v412) then
                            v421 = Enum.HighlightDepthMode.AlwaysOnTop
                        end
                        v405[v404] = v421
                        v399 = v413
                        v404 = ChamsTable
                        v404[v403] = v405
                    end
                end
            end
        end
        return
    end
end
local v1978 = function(arg28_1)
    local v423, v425, v426, v429, v430
    local v422 = arg28_1
    local v424 = (not v422) or (not v422.Character)
    if v424 then
        v430 = nil
        return v430
    else
        v424 = capturedValues1.value11.AimPart
        if (v424 == "Head") then
            v423 = (v422.Character:FindFirstChild("Head"))
        else
            v429 = capturedValues1.value11.AimPart
            if (v429 == "UpperTorso") then
                v425 = v422.Character:FindFirstChild("UpperTorso")
                v429 = v425
                if not (v425) then
                    v429 = (v422.Character:FindFirstChild("Torso"))
                end
                v423 = v429
            else
                v423 = (v422.Character:FindFirstChild("HumanoidRootPart"))
            end
        end
        if (not v423) then
            v430 = nil
            return v430
        else
            v425 = v423.Position
            v426 = capturedValues1.value11
            if v426["LeadTargets"] then
                v425 = (v425 + (v423.AssemblyLinearVelocity * capturedValues1.value11.LeadAmt))
            end
            return v425
        end
    end
end
ChamsTable = v1929
capturedValues1.value42 = v1974
capturedValues1.value39 = {}
capturedValues1.value43 = v1976
capturedValues1.value44 = v1977
capturedValues1.value45 = v1978
capturedValues1.value46 = 0
v1978 = capturedValues1.value7.ViewportSize
capturedValues1.value47 = v1978
local v1982 = function(arg29_1)
    local v438, v439, v440, v441, v442, v443, v444, v445, v446, v447, v448, v449, v450, v451, v452, v453
    local v454, v455, v456, v457, v458, v459, v460
    local v461, v462, v463, v464, v465, v466, v467, v468, v469, v470, v471, v472, v473, v474, v475, v476
    local v477, v478, v479, v480, v481, v483
    local v485, v487, v489, v491, v493
    local v437 = capturedValues1.value9
    v438, v439 = arg29_1, (not v437)
    if v439 then
        return
    else
        v439 = capturedValues1.value7.ViewportSize
        capturedValues1.value47 = v439
        v443 = capturedValues1.value2:GetMouseLocation()
        v437 = capturedValues1.value36
        v441 = capturedValues1.value11.ShowFOV and capturedValues1.value24
        v437.Visible = v441
        v440 = capturedValues1.value11
        if v440["ShowFOV"] then
            v437 = capturedValues1.value36
            v441 = capturedValues1.value11.FOVRadius
            v437.Radius = v441
            v437 = capturedValues1.value36
            v437.Position = v443
        end
        v440 = capturedValues1.value44()
        v437 = capturedValues1.value11
        v437.CurrentTarget = v440
        if v440 then
            v437 = capturedValues1.value33
            v441 = "Text"
            v444 = "  Target: "
            v449 = v440.Name
            v447 = " ("
            v450 = math.floor
            v460 = v440.Character
            v453 = v460
            if v460 then
                v459 = v439
                v457 = v440.Character:FindFirstChild("HumanoidRootPart")
                v460 = v457
                if v457 then
                    v460 = (v440.Character.HumanoidRootPart.Position - capturedValues1.value9.Position).Magnitude
                end
                v453, v439 = v460, v459
            end
            v442 = (v444 .. (v449 .. (v447 .. ((v450((v453 or 0))) .. "m)"))))
            v437[v441] = v442
        else
            v437 = capturedValues1.value33
            v437.Text = "  Target: none"
        end
        v437 = (capturedValues1.value11.Aimbot and v440)
        if v437 then
            v441 = capturedValues1.value45(v440)
            if v441 then
                v442 = CFrame.new(capturedValues1.value7.CFrame.Position , v441)
                v444 = capturedValues1.value11
                if v444["InstantAim"] then
                    v437 = capturedValues1.value7
                    v437.CFrame = v442
                else
                    v437 = capturedValues1.value7
                    v445 = capturedValues1.value7.CFrame
                    v446 = capturedValues1.value11.AimSmooth
                    v449 = v445:Lerp(v442, v446)
                    v437.CFrame = v449
                end
            end
        end
        v437 = (capturedValues1.value11.LockLine and v440)
        if v437 then
            v441 = capturedValues1.value45(v440)
            if v441 then
                v437 = capturedValues1.value7
                v445 = {v437:WorldToScreenPoint(v441)}
                v442 = v445[1]
                if v445[2] then
                    v437 = capturedValues1.value37
                    v437.Visible = true
                    v437 = capturedValues1.value37
                    v437.From = v443
                    v437 = capturedValues1.value37
                    v446 = Vector2.new(v442.X, v442.Y)
                    v437.To = v446
                else
                    v437 = capturedValues1.value37
                    v437.Visible = false
                end
            else
                v437 = capturedValues1.value37
                v437.Visible = false
            end
        else
            v437 = capturedValues1.value37
            v437.Visible = false
        end
        v441 = capturedValues1.value11
        if v441["Triggerbot"] then
            v442 = ((tick()) - capturedValues1.value46)
            v445 = capturedValues1.value11
            if (v442 > v445["TrigDelay"]) then
                v437 = capturedValues1.value7
                v444 = v443.X
                v442 = v437:ScreenPointToRay(v444, v443.Y )
                v444 = Ray.new(v442.Origin, (v442.Direction * 2000))
                v437 = capturedValues1.value5
                v446 = capturedValues1.value8
                v449, v445 = {v446}, v437.FindPartOnRayWithIgnoreList
                v445 = v445(v437, v444, v449)
                if v445 then
                    v449 = (v445:FindFirstAncestorOfClass("Model"))
                    if v449 then
                        v446 = capturedValues1.value1:GetPlayerFromCharacter(v449)
                        v437 = v446
                        if v446 then
                            v450 = v439
                            v451 = (v446 ~= capturedValues1.value6)
                            v448 = v451
                            if v451 then
                                v454 = capturedValues1.value11
                                v452 = v439
                                v453 = v454.TeamCheck
                                v455 = v453
                                if v453 then
                                    v455 = (v446.Team == capturedValues1.value6.Team)
                                end
                                v439, v451 = v452, (not v455)
                                v448 = v451
                            end
                            v439, v437 = v450, v448
                        end
                        if v437 then
                            v447 = capturedValues1.value8:FindFirstChildOfClass("Tool")
                            if v447 then
                                v448 = v439
                                v450 = v447:FindFirstChild("Fire")
                                v437 = v450
                                if not (v450) then
                                    v437 = (v447:FindFirstChild("Shoot")) or (v447:FindFirstChildOfClass("RemoteEvent"))
                                end
                                v439 = v448
                                local up3 = v437
                                v451 = up3
                                v437 = v451
                                if v451 then
                                    v437 = (up3:IsA("RemoteEvent"))
                                end
                                if v437 then
                                    pcall(function()
                                        up3:FireServer()
                                        return
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end
        v444 = capturedValues1.value11.Flight
        v441 = v444
        if v444 then
            v446 = capturedValues1.value11
            v445 = v439
            v449 = v446.FlyVel
            v444 = v449
            if v449 then
                v444 = capturedValues1.value11.FlyGyro and capturedValues1.value9
            end
            v441, v439 = v444, v445
        end
        if v441 then
            v441 = Vector3.zero
            v442 = capturedValues1.value2
            v449 = Enum.KeyCode
            v444 = v442:IsKeyDown(v449.W)
            if v444 then
                v441 = (v441 + capturedValues1.value7.CFrame.LookVector)
            end
            v444 = capturedValues1.value2
            v446 = Enum.KeyCode
            v445 = v444:IsKeyDown(v446.S)
            if v445 then
                v441 = (v441 - capturedValues1.value7.CFrame.LookVector)
            end
            v445 = capturedValues1.value2
            v446 = Enum.KeyCode.A
            v449 = v445:IsKeyDown(v446)
            if v449 then
                v441 = (v441 - capturedValues1.value7.CFrame.RightVector)
            end
            v449 = capturedValues1.value2
            v447 = Enum.KeyCode.D
            v446 = v449:IsKeyDown(v447)
            if v446 then
                v441 = (v441 + capturedValues1.value7.CFrame.RightVector)
            end
            v446 = capturedValues1.value2
            v448 = Enum.KeyCode.Space
            v447 = v446:IsKeyDown(v448)
            if v447 then
                v441 = (v441 + Vector3.yAxis)
            end
            v447 = capturedValues1.value2
            v451 = Enum.KeyCode
            v448 = v447:IsKeyDown(v451.LeftControl)
            if v448 then
                v441 = (v441 - Vector3.yAxis)
            end
            v448 = capturedValues1.value11.FlyVel
            v450 = "Velocity"
            v453 = v439
            v454 = (v441.Magnitude > 0)
            v452 = v454
            if v454 then
                v452 = (v441.Unit * capturedValues1.value11.FlySpeed)
            end
            v439, v451 = v453, v452
            if not (v452) then
                v451 = Vector3.zero
            end
            v448[v450] = v451
            v448 = capturedValues1.value11.FlyGyro
            v451 = capturedValues1.value7.CFrame
            v448.CFrame = v451
        end
        v450 = capturedValues1.value11.SpeedBoost
        v441 = v450
        if v450 then
            v455 = capturedValues1.value10
            v450, v451 = v455, v439
            if v455 then
                v450 = (capturedValues1.value10.WalkSpeed ~= capturedValues1.value11.SpeedAmt)
            end
            v439, v441 = v451, v450
        end
        if v441 then
            v441 = capturedValues1.value10
            v450 = capturedValues1.value11.SpeedAmt
            v441.WalkSpeed = v450
        end
        v450 = capturedValues1.value11.NoSlowdown
        v441 = v450
        if v450 then
            v455 = capturedValues1.value10
            v450, v451 = v455, v439
            if v455 then
                v452 = capturedValues1.value10.WalkSpeed
                v456 = capturedValues1.value11.SpeedBoost
                v460 = v456
                if v456 then
                    v460 = capturedValues1.value11.SpeedAmt
                end
                v450 = (v452 < (v460 or 16))
            end
            v441, v439 = v450, v451
        end
        if v441 then
            v441 = capturedValues1.value10
            v448 = "WalkSpeed"
            v453 = capturedValues1.value11.SpeedBoost
            v455 = v453
            if v453 then
                v455 = capturedValues1.value11.SpeedAmt
            end
            v450 = (v455 or 16)
            v441[v448] = v450
        end
        v448 = capturedValues1.value11
        if v448["HideFlashes"] then
            v441 = ipairs
            v455 = capturedValues1.value5
            for v451, v455 in v441(v455:GetDescendants()) do
                v454 = v455:IsA("ParticleEmitter")
                v452 = v454
                if v454 then
                    v452 = (v455.Name:lower():match("flash|muzzle|fire"))
                end
                if v452 then
                    v455.Enabled = false
                end
            end
        end
        v448 = capturedValues1.value11
        if v448["ClearSmoke"] then
            v441 = ipairs
            v455 = capturedValues1.value5
            for v451, v455 in v441(v455:GetDescendants()) do
                v454 = v455:IsA("ParticleEmitter")
                v452 = v454
                if v454 then
                    v452 = (v455.Name:lower():match("smoke|cloud|gas"))
                end
                if v452 then
                    v455.Enabled = false
                end
            end
        end
        v441 = (#capturedValues1.value40)
        v450 = 1
        v451 = -1
        for v448 = v441, v450, v451 do
            v441 = v448
            v452 = capturedValues1.value40[v441]
            local up4 = v452
            v452 = ((tick()) - up4.t)
            if (v452 > 1.3) then
                v459 = function()
                    up4.d:Remove()
                    return
                end
                pcall(v459)
                table.remove(capturedValues1.value40, v441)
            else
                v454 = up4.d
                v456 = Vector2.new(up4.d.Position.X, (up4.baseY - (v452 * 38)))
                v454.Position = v456
                v454 = up4.d
                v459 = (v452 / 1.3)
                v454.Transparency = v459
            end
        end
        v450 = capturedValues1.value11
        if (not v450["ESP"]) then
            v441 = pairs
            v455 = capturedValues1.value39
            for v451, v455 in v441(v455) do
                capturedValues1.value43(v451)
            end
            v441 = capturedValues1.value34
            v450 = ("  FPS: " .. ((math.floor((1 / v438))) .. (" | Ping: " .. ((math.floor(((capturedValues1.value6:GetNetworkPing()) * 1000))) .. "ms"))))
            v441.Text = v450
            if capturedValues1.value9 then
                v441 = capturedValues1.value35
                v450 = ("  Pos: " .. ((math.floor(capturedValues1.value9.Position.X)) .. ("," .. ((math.floor(capturedValues1.value9.Position.Y)) .. ("," .. (math.floor(capturedValues1.value9.Position.Z)))))))
                v441.Text = v450
            end
            return
        else
            v448 = ipairs
            v441 = {}
            v450, v451, v455 = v448(capturedValues1.value1:GetPlayers())
            while true do
                v455, v452 = v450(v451, v455)
                if not v455 then
                    break
                end
                if not ((v452 == capturedValues1.value6))then
                    v466 = v439
                    v467 = capturedValues1.value11.TeamCheck
                    v465 = v467
                    if v467 then
                        v472 = v452.Team
                        v467 = v472
                        if v472 then
                            v470 = capturedValues1.value6.Team
                            v472 = v470
                            if v470 then
                                v472 = (v452.Team == capturedValues1.value6.Team)
                            end
                            v467 = v472
                        end
                        v465 = v467
                    end
                    v453 = v465
                    v439 = v466
                    if v453 then
                        v465 = (not capturedValues1.value11.ShowTeammates)
                    end
                    if v465 then
                        capturedValues1.value43(v452)
                    else
                        if (not v452["Character"]) then
                            capturedValues1.value43(v452)
                        else
                            v454 = (v452.Character:FindFirstChild("HumanoidRootPart"))
                            v460 = (v452.Character:FindFirstChild("Head"))
                            v459 = (v452.Character:FindFirstChildOfClass("Humanoid"))
                            v465 = (not v454) or (not v459)
                            if v465 then
                                capturedValues1.value43(v452)
                            else
                                v466, v467 = v439, v453
                                v441[v452] = true
                                v468 = v439
                                if v453 then
                                    v467 = capturedValues1.value11.TeamColor
                                end
                                v465, v439 = v467, v468
                                if not (v467) then
                                    v465 = capturedValues1.value11.ESPColor
                                end
                                v439, v456 = v466, v465
                                v465 = capturedValues1.value7
                                v468 = v454.Position
                                v466, v467 = v465:WorldToScreenPoint(v468)
                                v458 = v467
                                v457 = v466
                                v461 = (math.clamp((v459.Health / (math.max(v459.MaxHealth, 1))), 0, 1))
                                v462 = (Color3.fromRGB((math.floor(((1 - v461) * 255))), ((math.floor((v461 * 200))) + 55), 50))
                                v463 = (v454.Position - capturedValues1.value9.Position).Magnitude
                                if (not capturedValues1.value39[v452]) then
                                    v465 = capturedValues1.value39
                                    v472 = Drawing.new("Square")
                                    v470 = Drawing.new("Square")
                                    v473 = Drawing.new("Text")
                                    v475 = Drawing.new("Square")
                                    v477 = Drawing.new("Square")
                                    v479 = Drawing.new("Text")
                                    v481 = Drawing.new("Text")
                                    v483 = Drawing.new("Text")
                                    v485 = Drawing.new("Circle")
                                    v487 = Drawing.new("Line")
                                    v489 = Drawing.new("Line")
                                    v491 = Drawing.new("Line")
                                    v493 = Drawing.new("Line")
                                    v465[v452] = {["box"] = v472, ["boxFill"] = v470, ["name"] = v473, ["hpBack"] = v475, ["hpFill"] = v477, ["hpNum"] = v479, ["distT"] = v481, ["weapT"] = v483, ["headDot"] = v485, ["tracer"] = v487, ["offArr1"] = v489, ["offArr2"] = v491, ["offArr3"] = v493}
                                    v465 = capturedValues1.value39[v452]
                                    v466 = v465.box
                                    v466.Filled = false
                                    v466 = v465.box
                                    v466.Thickness = 1.5
                                    v466 = v465.boxFill
                                    v466.Filled = true
                                    v466 = v465.boxFill
                                    v466.Transparency = .78
                                    v466 = v465.name
                                    v466.Size = 14
                                    v466 = v465.name
                                    v468 = Drawing.Fonts.GothamBold
                                    v466.Font = v468
                                    v466 = v465.name
                                    v466.Outline = true
                                    v466 = v465.name
                                    v466.Center = true
                                    v466 = v465.hpBack
                                    v466.Filled = true
                                    v466 = v465.hpBack
                                    v472 = Color3.fromRGB(0, 0, 0)
                                    v466.Color = v472
                                    v466 = v465.hpBack
                                    v466.Transparency = .4
                                    v466 = v465.hpFill
                                    v466.Filled = true
                                    v466 = v465.hpNum
                                    v466.Size = 11
                                    v466 = v465.hpNum
                                    v468 = Drawing.Fonts.Gotham
                                    v466.Font = v468
                                    v466 = v465.hpNum
                                    v466.Outline = true
                                    v466 = v465.hpNum
                                    v466.Center = true
                                    v466 = v465.distT
                                    v466.Size = 12
                                    v466 = v465.distT
                                    v468 = Drawing.Fonts.Gotham
                                    v466.Font = v468
                                    v466 = v465.distT
                                    v466.Outline = true
                                    v466 = v465.distT
                                    v466.Center = true
                                    v466 = v465.weapT
                                    v466.Size = 11
                                    v466 = v465.weapT
                                    v468 = Drawing.Fonts.Gotham
                                    v466.Font = v468
                                    v466 = v465.weapT
                                    v466.Outline = true
                                    v466 = v465.weapT
                                    v466.Center = true
                                    v466 = v465.headDot
                                    v466.Filled = true
                                    v466 = v465.headDot
                                    v466.Thickness = 1
                                    v466 = v465.tracer
                                    v466.Thickness = 1.2
                                    v466 = ipairs
                                    v469 = {"offArr1", "offArr2", "offArr3"}
                                    for v472, v469 in v466(v469) do
                                        v470 = v465[v469]
                                        v470.Thickness = 2
                                        v470 = v465[v469]
                                        v470.Color = v456
                                    end
                                end
                                v464 = capturedValues1.value39[v452]
                                v465 = v458 and (v457.Z > 0)
                                if v465 then
                                    v465, v466 = v460, v439
                                    if v460 then
                                        v467 = capturedValues1.value7
                                        v469 = v460.Position
                                        v471 = Vector3.new(0, 1, 0)
                                        v465 = (v467:WorldToScreenPoint((v469 + v471)))
                                    end
                                    v439 = v466
                                    v466 = capturedValues1.value7
                                    v472 = v454.Position
                                    v470 = Vector3.new (0, 3, 0)
                                    v467, v469 = "WorldToScreenPoint", v439
                                    v468 = (v472 - v470)
                                    v472, v467 = v465, v466.WorldToScreenPoint
                                    v467 = v467(v466, v468)
                                    if v465 then
                                        v472 = (math.abs((v467.Y - v465.Y)))
                                    end
                                    v439 = v469
                                    v466 = (v472 or 80)
                                    v468 = (v466 * .52)
                                    v469 = v457.X
                                    v473 = v439
                                    v472 = (v469 - (v468 / 2))
                                    v470 = v439
                                    v471 = v465 and v465.Y
                                    v469, v439 = v471, v473
                                    if not (v471) then
                                        v469 = (v457.Y - (v466 / 2))
                                    end
                                    v439 = v470
                                    v470 = v464.box
                                    v473 = capturedValues1.value11.ESPBox
                                    v470.Visible = v473
                                    v470 = v464.box
                                    v470.Color = v456
                                    v470 = v464.box
                                    v474 = Vector2.new(v472, v469)
                                    v470.Position = v474
                                    v470 = v464.box
                                    v474 = Vector2.new(v468, v466)
                                    v470.Size = v474
                                    v470 = v464.boxFill
                                    v471 = "Visible"
                                    v475 = capturedValues1.value11.FilledBox
                                    v473 = v475
                                    if v475 then
                                        v473 = capturedValues1.value11.ESPBox
                                    end
                                    v439, v476 = v439, "Ђ\140Zf\182h"
                                    v470[v471] = v473
                                    v470 = v464.boxFill
                                    v470.Color = v456
                                    v470 = v464.boxFill
                                    v474 = Vector2.new(v472, v469)
                                    v476, v479 = "ls\242v\167\021\019", "\004,\168"
                                    v470.Position = v474
                                    v470 = v464.boxFill
                                    v474 = Vector2.new(v468, v466)
                                    v470.Size = v474
                                    v470 = v464.name
                                    v473 = capturedValues1.value11.ESPName
                                    v470.Visible = v473
                                    v470 = v464.name
                                    v470.Color = v456
                                    v470 = v464.name
                                    v473 = v452.Name
                                    v470.Text = v473
                                    v470 = v464.name
                                    v474 = Vector2.new((v472 + (v468 / 2)), (v469 - 17))
                                    v470.Position = v474
                                    v470 = (v472 - 7)
                                    v471 = v464.hpBack
                                    v474 = capturedValues1.value11.HealthBar
                                    v471.Visible = v474
                                    v471 = v464.hpBack
                                    v474 = Vector2.new
                                    v478, v480 = 32237696694947, "š_"
                                    v475 = v474((v470 - 1), (v469 - 1))
                                    v471.Position = v475
                                    v471 = v464.hpBack
                                    v474 = Vector2.new
                                    v476, v478 = 5, 2
                                    v475 = v474(v476, (v466 + v478))
                                    v471.Size = v475
                                    v471 = v464.hpFill
                                    v474 = capturedValues1.value11.HealthBar
                                    v471.Visible = v474
                                    v471 = v464.hpFill
                                    v471.Color = v462
                                    v480, v478 = "%x\212", 29837162477126
                                    v471 = v464.hpFill
                                    v474 = Vector2.new
                                    v478, v480 = 29281307342147, "!\153f"
                                    v475 = v474(v470, (v469 + (v466 * (1 - v461))))
                                    v471.Position = v475
                                    v471 = v464.hpFill
                                    v474 = Vector2.new
                                    v476, v479 = 3, "math"
                                    v475 = v474(v476, math.max((v466 * v461), 1))
                                    v471.Size = v475
                                    v471 = v464.hpNum
                                    v474 = capturedValues1.value11.HealthNum
                                    v471.Visible = v474
                                    v471 = v464.hpNum
                                    v471.Color = v462
                                    v471 = v464.hpNum
                                    v476 = math.floor(v459.Health)
                                    v471.Text = (v476 .. "hp")
                                    v471 = v464.hpNum
                                    v475 = Vector2.new((v470 + 2), ((v469 + v466) + 3))
                                    v471.Position = v475
                                    v471 = v452.Character
                                    v478, v473 = "@&&\212", "FindFirstChildOfClass"
                                    v480, v473 = 32757151120277, v471.FindFirstChildOfClass
                                    v473 = v473(v471, "Tool")
                                    v471 = ((v469 + v466) + 3)
                                    v474 = v464.distT
                                    v476 = capturedValues1.value11.ESPDist
                                    v474.Visible = v476
                                    v474 = v464.distT
                                    v477 = capturedValues1.value16
                                    v480, v479 = 5836445633181, "-\225\\\250Y"
                                    v476 = v477.Sub
                                    v474.Color = v476
                                    v474 = v464.distT
                                    v478 = math.floor(v463)
                                    v474.Text = (v478 .. "m")
                                    v479, v480 = "\170\000\221\236f", 15731728948381
                                    v474 = v464.distT
                                    v477 = Vector2.new((v472 + (v468 / 2)), v471)
                                    v474.Position = v477
                                    v479 = capturedValues1.value11.ESPDist
                                    v478, v480 = 0, 13
                                    v474 = (v471 + ((v479 and v480) or v478))
                                    v480, v471 = "\130\160\006\193|", v474
                                    v475 = v464.weapT
                                    v477 = capturedValues1.value11.ESPWeapon
                                    v475.Visible = v477
                                    v475 = v464.weapT
                                    v478 = Color3.fromRGB(255, 195, 75)
                                    v475.Color = v478
                                    v475 = v464.weapT
                                    v478 = v439
                                    v476 = "Text"
                                    v479, v480 = v473, v439
                                    if v473 then
                                        v479 = v473.Name
                                    end
                                    v477, v439 = v479, v480
                                    if not (v479) then
                                        v477 = "—"
                                    end
                                    v439 = v478
                                    v475[v476] = v477
                                    v475 = v464.weapT
                                    v478 = Vector2.new((v472 + (v468 / 2)), v471)
                                    v475.Position = v478
                                    v475 = (capturedValues1.value11.HeadDot and v460)
                                    if v475 then
                                        v475 = capturedValues1.value7
                                        v477 = v460.Position
                                        v476 = v475:WorldToScreenPoint(v477)
                                        v475 = v464.headDot
                                        v475.Visible = true
                                        v475 = v464.headDot
                                        v475.Color = v456
                                        v475 = v464.headDot
                                        v475.Radius = 4
                                        v475 = v464.headDot
                                        v479 = Vector2.new(v476.X, v476.Y)
                                        v475.Position = v479
                                    else
                                        v475 = v464.headDot
                                        v475.Visible = false
                                    end
                                    v476 = capturedValues1.value11
                                    if v476["Tracers"] then
                                        v475 = v464.tracer
                                        v475.Visible = true
                                        v475 = v464.tracer
                                        v475.Color = v456
                                        v475 = v464.tracer
                                        v475.Transparency = .45
                                        v479 = (capturedValues1.value11.TracerFrom == "Bottom")
                                        v477 = v479
                                        if v479 then
                                            v477 = capturedValues1.value47.Y
                                        end
                                        v475 = v477
                                        if not (v477) then
                                            v483 = capturedValues1.value11
                                            v478 = v439
                                            v479 = ((v483.TracerFrom == "Top") and 0)
                                            v477 = v479
                                            if not (v479) then
                                                v480 = v439
                                                v483 = (capturedValues1.value11.TracerFrom == "Center")
                                                v481 = v483
                                                if v483 then
                                                    v481 = (capturedValues1.value47.Y / 2)
                                                end
                                                v479 = v481
                                                if not (v481) then
                                                    v479 = capturedValues1.value2:GetMouseLocation().Y
                                                end
                                                v477, v439 = v479, v480
                                            end
                                            v475, v439 = v477, v478
                                        end
                                        v476 = v464.tracer
                                        v479 = Vector2.new((capturedValues1.value47.X / 2), v475)
                                        v476.From = v479
                                        v476 = v464.tracer
                                        v479 = Vector2.new(v457.X, v457.Y)
                                        v476.To = v479
                                    else
                                        v475 = v464.tracer
                                        v475.Visible = false
                                    end
                                    v475 = v464.offArr1
                                    v475.Visible = false
                                    v475 = v464.offArr2
                                    v475.Visible = false
                                    v475 = v464.offArr3
                                    v475.Visible = false
                                else
                                    v465 = v464.box
                                    v465.Visible = false
                                    v465 = v464.boxFill
                                    v465.Visible = false
                                    v465 = v464.name
                                    v465.Visible = false
                                    v465 = v464.hpBack
                                    v465.Visible = false
                                    v465 = v464.hpFill
                                    v465.Visible = false
                                    v465 = v464.hpNum
                                    v465.Visible = false
                                    v465 = v464.distT
                                    v465.Visible = false
                                    v465 = v464.weapT
                                    v465.Visible = false
                                    v465 = v464.headDot
                                    v465.Visible = false
                                    v465 = v464.tracer
                                    v465.Visible = false
                                    v466 = capturedValues1.value11
                                    if v466["OffscreenInd"] then
                                        v465 = (v454.Position - capturedValues1.value7.CFrame.Position)
                                        v468 = capturedValues1.value7.CFrame
                                        v466 = v465:Dot(v468.RightVector)
                                        v472 = capturedValues1.value7.CFrame
                                        v467 = v465:Dot(v472.UpVector)
                                        v472 = math.atan2((-v467), v466)
                                        v468 = (capturedValues1.value47.X / 2)
                                        v469 = (capturedValues1.value47.Y / 2)
                                        v470 = ((math.min(v468, v469)) - 36)
                                        v471 = (v468 + ((math.cos(v472)) * v470))
                                        v473 = (v469 + ((math.sin(v472)) * v470))
                                        v476 = (-(math.sin(v472)))
                                        v478 = math.cos(v472)
                                        v479 = Vector2.new((v471 + ((math.cos(v472)) * 10)), (v473 + ((math.sin(v472)) * 10)))
                                        v480 = Vector2.new((v471 + ((v476 * 10) * .45)), (v473 + ((v478 * 10) * .45)))
                                        v481 = Vector2.new((v471 - ((v476 * 10) * .45)), (v473 - ((v478 * 10) * .45)))
                                        v477 = v464.offArr1
                                        v477.Visible = true
                                        v477 = v464.offArr1
                                        v477.From = v479
                                        v477 = v464.offArr1
                                        v477.To = v480
                                        v477 = v464.offArr1
                                        v477.Color = v456
                                        v477 = v464.offArr2
                                        v477.Visible = true
                                        v477 = v464.offArr2
                                        v477.From = v479
                                        v477 = v464.offArr2
                                        v477.To = v481
                                        v477 = v464.offArr2
                                        v477.Color = v456
                                        v477 = v464.offArr3
                                        v477.Visible = true
                                        v477 = v464.offArr3
                                        v477.From = v480
                                        v477 = v464.offArr3
                                        v477.To = v481
                                        v477 = v464.offArr3
                                        v477.Color = v456
                                    else
                                        v465 = v464.offArr1
                                        v465.Visible = false
                                        v465 = v464.offArr2
                                        v465.Visible = false
                                        v465 = v464.offArr3
                                        v465.Visible = false
                                    end
                                end
                            end
                        end
                    end
                end
            end
            v448 = pairs
            v452 = capturedValues1.value39
            for v455, v452 in v448(v452) do
                v448 = v455
                if (not v441[v448]) then
                    capturedValues1.value43(v448)
                end
            end
            v448 = capturedValues1.value34
            v451 = ("  FPS: " .. ((math.floor((1 / v438))) .. (" | Ping: " .. ((math.floor(((capturedValues1.value6:GetNetworkPing()) * 1000))) .. "ms"))))
            v448.Text = v451
            if capturedValues1.value9 then
                v448 = capturedValues1.value35
                v451 = ("  Pos: " .. ((math.floor(capturedValues1.value9.Position.X)) .. ("," .. ((math.floor(capturedValues1.value9.Position.Y)) .. ("," .. (math.floor(capturedValues1.value9.Position.Z)))))))
                v448.Text = v451
            end
            return
        end
    end
end
v1894.RenderStepped :Connect(v1982)
capturedValues1.value48 = false
spilledValues1.value5.Button1Down:Connect(function()
    local v499, v502, v503, v504
    local v498 = capturedValues1.value11
    if (not v498.SilentAim ) then
        return
    else
        v498 = math.random(1, 100)
        v502 = capturedValues1.value11
        if (v498 > v502.HitChance ) then
            return
        else
            v498 = (capturedValues1.value44())
            if (not v498) then
                return
            else
                v502 = (capturedValues1.value45(v498))
                if (not v502) then
                    return
                else
                    v503 = capturedValues1.value11.SkipKatana and v498.Character
                    if v503 then
                        v499 = (v498.Character:FindFirstChildOfClass("Tool"))
                        v503 = v499
                        if v499 then
                            v503 = (v499.Name:lower():find("katana"))
                        end
                        if v503 then
                            return
                        end
                    end
                    capturedValues1.value48 = true
                    v503 = capturedValues1.value7.CFrame
                    local up5 = v503
                    v503 = capturedValues1.value7
                    v504 = CFrame.new(up5.Position, v502)
                    v503.CFrame = v504
                    task.delay(.07, function()
                        local v1883, v1884
                        if capturedValues1.value48 then
                            v1883 = capturedValues1.value7
                            v1884 = up5
                            v1883.CFrame = v1884
                        end
                        return
                    end)

                    return
                end
            end
        end
    end
end)
local v1983 = function()
    return
end
spilledValues1.value5.Button1Up :Connect(v1983)
capturedValues1.value2.JumpRequest:Connect(function()
    local v513, v517, v523
    local v518 = capturedValues1.value11.AirJumps
    local v519 = v518
    if v518 then
        v517 = capturedValues1.value10
        v518, v513 = v517, 8395450
        if v517 then
            v518 = (capturedValues1.value11.AirJumpsLeft > 0)
        end
        v523, v519 = v513, v518
    end
    if v519 then
        v523 = capturedValues1.value10
        v517 = Enum
        v523:ChangeState(v517.HumanoidStateType.Jumping)
        v523 = capturedValues1.value11
        v518 = (capturedValues1.value11.AirJumpsLeft - 1)
        v523.AirJumpsLeft = v518
    end
    return
end)
capturedValues1.value6.CharacterAdded:Connect(function()
    capturedValues1.value11.AirJumpsLeft = capturedValues1.value11.AirJumpMax
    return
end)
v1978 = capturedValues1.value1.PlayerRemoving
v1983 = function(arg34_1)
    local v532, v534
    local up6 = arg34_1
    capturedValues1.value43(up6)
    if ChamsTable[up6] then
        pcall(function()
            ChamsTable[up6]:Destroy()
            return
        end)
        v532 = ChamsTable
        v534 = up6
        v532[v534] = nil
    end
    return
end
v1978:Connect(v1983)
v1978 = ipairs
local v1985 = capturedValues1.value1
for v1984, v1985 in v1978(v1985:GetPlayers()) do
    v1986 = v1985.CharacterAdded
    spilledValues1.value13 = function()
        task.wait(1)
        local v181 = capturedValues1.value11
        if v181.Chams then
            capturedValues1.value42()
        end
        return
    end
    v1986:Connect(spilledValues1.value13)
end
v1978 = capturedValues1.value1.PlayerAdded
v1983 = function(arg228_1)
    local v1843 = arg228_1.CharacterAdded
    local v1839 = function()
        task.wait(1)
        local v581 = capturedValues1.value11
        if v581["Chams"] then
            capturedValues1.value42()
        end
        return
    end
    v1843:Connect(v1839)

    return
end
v1978:Connect(v1983)
task.spawn(function()
    local v1845
    while true do
        task.wait(4)
        v1845 = capturedValues1.value11
        if v1845.Chams then
            capturedValues1.value42()
        end
    end
end)
capturedValues1.value49 = {}
task.spawn(function()
    local v1850, v1851, v1852, v1853, v1855, v1857, v1858, v1859, v1865
    while true do
        task.wait(2)
        v1851 = capturedValues1.value11
        if v1851.SpectatorAlert then
            v1850, v1855 = {}, "ipairs"
            capturedValues1.value49 = v1850
            v1855, v1852, v1853 = ipairs(capturedValues1.value1:GetPlayers())
            while true do
                v1853, v1857 = v1855(v1852, v1853)
                if not v1853 then
                    break
                end
                v1859 = (v1857 ~= capturedValues1.value6)
                v1851 = v1859
                if v1859 then
                    v1858 = v1850
                    v1865 = (not v1857.Character)
                    v1859 = v1865
                    if not (v1865) then
                        v1859 = (not (v1857.Character:FindFirstChild("HumanoidRootPart")))
                    end
                    v1851, v1850 = v1859, v1858
                end
                if v1851 then
                    table.insert(capturedValues1.value49, v1857.Name)
                end
            end
            if ((#capturedValues1.value49) > 0) then
                v1851 = capturedValues1.value33
                v1852 = ("  SPEC: " .. (table.concat(capturedValues1.value49, ", ")))
                v1851.Text = v1852
            end
        end
    end
end)
v1978 = capturedValues1.value2.InputBegan
v1984 = function(arg231_1, arg231_2)
    local v1868, v1869, v1871, v1872, v1875, v1878
    local v1867 = arg231_1
    if arg231_2 then
        return
    else
        v1872 = v1867.KeyCode
        v1868 = Enum.KeyCode
        if (v1872 == v1868["Insert"]) then
            capturedValues1.value24 = (not capturedValues1.value24)
            if capturedValues1.value24 then
                v1872 = capturedValues1.value21
                v1872.Visible = true
                v1872 = capturedValues1.value13
                v1868 = capturedValues1.value21
                v1869 = capturedValues1.value15
                v1875 = UDim2.new(0, 820, 0, 580)
                v1878 = UDim2.new(0.5, -410, 0.5, -290)
                v1872(v1868, v1869, {["Size"] = v1875, ["Position"] = v1878})
                task.delay(.2, function()
                    CONTENT.Visible = true
                    return
                end)
            else
                v1872 = CONTENT
                v1872.Visible = false
                v1872 = capturedValues1.value13
                v1868 = capturedValues1.value21
                v1869 = capturedValues1.value15
                v1875 = UDim2.new(0, 0, 0, 0)
                v1878 = UDim2.new(0.5, 0, 0.5, 0)
                v1872(v1868, v1869, {["Size"] = v1875, ["Position"] = v1878})
                task.delay(.3, function()
                    capturedValues1.value21.Visible = false
                    return
                end)
            end
        end
        v1871 = v1867.KeyCode
        v1869 = Enum.KeyCode
        if (v1871 == v1869["Delete"]) then
            v1872 = capturedValues1.value11
            v1868 = (not capturedValues1.value11.SilentAim)
            v1872.SilentAim = v1868
        end
        v1871 = v1867.KeyCode
        v1869 = Enum.KeyCode
        if (v1871 == v1869["End"]) then
            v1872 = capturedValues1.value11
            v1868 = (not capturedValues1.value11.Aimbot)
            v1872.Aimbot = v1868
        end
        v1871 = v1867.KeyCode
        v1869 = Enum.KeyCode
        if (v1871 == v1869["RightShift"]) then
            v1872 = capturedValues1.value11
            v1868 = (not capturedValues1.value11.ESP)
            v1872.ESP = v1868
        end
        return
    end
end
v1978:Connect(v1984)
print("RIVO HUB v2 loaded — Insert=GUI | Del=SilentAim | End=Aimbot | RShift=ESP")
game:GetService("Players")
v1984 = game:GetService("UserInputService")
v1984.MouseIconEnabled = true
v1984.MouseBehavior = Enum.MouseBehavior.Default
return
