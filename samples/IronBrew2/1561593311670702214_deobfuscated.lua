print("[DexaHub] Script started")
local game_ = game
local t1 = {
    Players = game_.GetService(game_, "Players"),
}
game_ = game
t1.TweenService = game_.GetService(game_, "TweenService")
game_ = game
t1.UserInputService = game_.GetService(game_, "UserInputService")
game_ = game
t1.RunService = game_.GetService(game_, "RunService")
game_ = game
t1.HttpService = game_.GetService(game_, "HttpService")
local LocalPlayer = t1.Players.LocalPlayer
game_ = LocalPlayer
local v4 = LocalPlayer.WaitForChild(game_, "PlayerGui")
local t2 = {
    ServiceId = 33510,
    PlatoSecret = "d3c64560-0c8f-4dce-925b-d7865cfce423",
    ScriptUrl = "https://raw.githubusercontent.com/NihalIsDumb/script-ride/refs/heads/main/script",
    KeyFileName = "DexaHubKey.txt",
    DiscordUrl = "https://discord.gg/your-invite",
    MaxKeyLength = 60,
    AnimationSpeed = 0.4,
    ParticleCount = 60,
    ParticleSpeed = 60,
}
local t3 = {
    Enabled = true,
    WebhookUrl = "https://discord.com/api/webhooks/1560449724937666670/7R-Sz0bt81BEv3bs-igJS-YwkQKuwMR2iEmenSxeIh23Ko4XG-jxuz62cZuorakw-LIp",
    IncludeHwid = true,
    IncludeExecutor = true,
    LogHubOpened = false,
    LogFailedKey = true,
}
local n1 = 4294967296
local v8 = n1 - 1
local function v9(p1, p2)
    local n2 = 0
    local n3 = 1
    while p1 ~= 0 or p2 ~= 0 do
        n2 = n2 + (p1 % 2 + p2 % 2) % 2 * n3
        p1 = math.floor(p1 / 2)
        p2 = math.floor(p2 / 2)
        n3 = n3 * 2
    end
    return n2 % n1
end
local function v12(p3, p4, p5, ...)
    if not p4 then
        return not p3 and 0 or p3 % n1
    end
    local v13 = v9(p3 % n1, p4 % n1)
    if not p5 then
        return v13
    end
    v13 = v12(v13, p5, ...)
    return v13
end
local function v14(p6, p7, p8, ...)
    if not p7 then
        if p6 then
            return p6 % n1
        else
            return v8
        end
        return
    end
    local v15 = p6 % n1
    local v16 = p7 % n1
    v15 = (v15 + v16 - v9(v15, v16)) / 2
    if not p8 then
        return v15
    end
    v15 = v14(v15, p8, ...)
    return v15
end
local function v17(p9)
    return v8 - p9
end
local function v18(p10, p11)
    if p11 < 0 then
        return lshift(p10, -p11)
    else
        return math.floor(p10 % 4294967296 / 2 ^ p11)
    end
end
local function v19(p12, p13)
    return (p13 > 31 or p13 < -31) and 0 or v18(p12 % n1, p13)
end
local function v20(p14, p15)
    if p15 < 0 then
        return v19(p14, -p15)
    else
        return p14 * 2 ^ p15 % 4294967296
    end
end
local function v21(p16, p17)
    local v22 = p16 % n1
    local v23 = p17 % 32
    local v24 = v14(v22, 2 ^ v23 - 1)
    return v19(v22, v23) + v20(v24, 32 - v23)
end
local t4 = {
    1116352408,
    1899447441,
    3049323471,
    3921009573,
    961987163,
    1508970993,
    2453635748,
    2870763221,
    3624381080,
    310598401,
    607225278,
    1426881987,
    1925078388,
    2162078206,
    2614888103,
    3248222580,
    3835390401,
    4022224774,
    264347078,
    604807628,
    770255983,
    1249150122,
    1555081692,
    1996064986,
    2554220882,
    2821834349,
    2952996808,
    3210313671,
    3336571891,
    3584528711,
    113926993,
    338241895,
    666307205,
    773529912,
    1294757372,
    1396182291,
    1695183700,
    1986661051,
    2177026350,
    2456956037,
    2730485921,
    2820302411,
    3259730800,
    3345764771,
    3516065817,
    3600352804,
    4094571909,
    275423344,
    430227734,
    506948616,
    659060556,
    883997877,
    958139571,
    1322822218,
    1537002063,
    1747873779,
    1955562222,
    2024104815,
    2227730452,
    2361852424,
    2428436474,
    2756734187,
    3204031479,
    3329325298,
}
local function v26(p18)
    return string.gsub(p18, ".", function(p19)
        return string.format("%02x", string.byte(p19))
    end)
end
local function v27(p20, p21)
    local n4 = 1
    local s1 = ""
    for _ = 1, p21, n4 do
        local v31 = p20 % 256
        s1 = string.char(v31) .. s1
        p20 = (p20 - v31) / 256
        v31 = p21
        local _ = n4
    end
    return s1
end
local function v33(p22, p23)
    local v34 = p23 + 3
    local n5 = 1
    local n6 = 0
    for i = p23, v34, n5 do
        n6 = n6 * 256 + string.byte(p22, i)
        local _ = v34
        local _ = n5
    end
    return n6
end
local function v40(p24, p25)
    local v41 = 64 - (p25 + 9) % 64
    local v42 = v27(8 * p25, 8)
    v41 = p24 .. "\128" .. string.rep("\000", v41) .. v42
    assert(#v41 % 64 == 0)
    return v41
end
local function v43(p26)
    p26[1] = 1779033703
    p26[2] = 3144134277
    p26[3] = 1013904242
    p26[4] = 2773480762
    p26[5] = 1359893119
    p26[6] = 2600822924
    p26[7] = 528734635
    p26[8] = 1541459225
    return p26
end
local function v44(p27, p28, p29)
    local n7 = 16
    local n8 = 1
    local t5 = {}
    for i = 1, n7, n8 do
        t5[i] = v33(p27, p28 + (i - 1) * 4)
        v75 = n7
        v76 = n8
    end
    n7 = 64
    n8 = 1
    for i = 17, n7, n8 do
        v75 = t5[i - 15]
        v75 = v12(v21(v75, 7), v21(v75, 18), v19(v75, 3))
        v76 = t5[i - 2]
        t5[i] = (t5[i - 16] + v75 + t5[i - 7] + v12(v21(v76, 17), v21(v76, 19), v19(v76, 10))) % n1
        v75 = n7
        v76 = n8
    end
    n7 = p29[1]
    n8 = p29[2]
    local v50 = p29[3]
    local v51 = p29[4]
    local v52 = p29[5]
    local v53 = p29[6]
    local v54 = p29[7]
    local v55 = p29[8]
    local n9 = 64
    local n10 = 1
    for i = 1, n9, n10 do
        local v59 = (v12(v21(n7, 2), v21(n7, 13), v21(n7, 22)) + v12(v14(n7, n8), v14(n7, v50), v14(n8, v50))) % n1
        local v60 = v12(v21(v52, 6), v21(v52, 11), v21(v52, 25))
        local v61 = v12(v14(v52, v53), v14(v17(v52), v54))
        v55 = (v55 + v60 + v61 + t4[i] + t5[i]) % n1
        v51 = (v51 + v55) % n1
        v55 = (v55 + v59) % n1
        v59 = n9
        v60 = n10
        local v62 = n7
        n7 = v55
        v55 = v54
        v54 = v53
        v53 = v52
        v52 = v51
        v51 = v50
        v50 = n8
        n8 = v62
    end
    p29[1] = (p29[1] + n7) % n1
    p29[2] = (p29[2] + n8) % n1
    p29[3] = (p29[3] + v50) % n1
    p29[4] = (p29[4] + v51) % n1
    p29[5] = (p29[5] + v52) % n1
    p29[6] = (p29[6] + v53) % n1
    p29[7] = (p29[7] + v54) % n1
    p29[8] = (p29[8] + v55) % n1
end
local function v63(p30)
    local v64 = v40(p30, #p30)
    local v65 = v43({})
    local v66 = #v64
    local n11 = 64
    for i = 1, v66, n11 do
        v44(v64, i, v65)
        local _ = v66
        local _ = n11
    end
    return v26(v27(v65[1], 4) .. v27(v65[2], 4) .. v27(v65[3], 4) .. v27(v65[4], 4) .. v27(v65[5], 4) .. v27(v65[6], 4) .. v27(v65[7], 4) .. v27(v65[8], 4))
end
local function v71(_)
    local http_ = not request and (not (http_request or syn_request) and (not (syn and syn.request) and http))
    if not http_ then
        if not http_ then
            return nil
        end
        return
    end
    http_ = http.request
    if not http_ then
        return nil
    end
end
local function v73()
    if gethwid then
        local ok, result = pcall(gethwid)
        if ok and result then
            return result
        end
        return
    end
end
local function v77()
    local ok, result = pcall(function()
        return identifyexecutor and table.concat({
            identifyexecutor(),
        }, " ") or "Unknown"
    end)
    return ok and result and result or "Unknown"
end
local function v79(_, _)
    if not (t3.Enabled and t3.WebhookUrl ~= "") then
        return
    end
end
local s2 = "https://api.platoboost.com"
local function v81()
    local v82 = v71({
        Url = s2 .. "/public/connectivity",
        Method = "GET",
    })
    if v82 and (v82.StatusCode == 200 or v82.StatusCode == 429) then
        return true
    else
        s2 = "https://api.platoboost.net"
        if v71({
            Url = s2 .. "/public/connectivity",
            Method = "GET",
        }) then
            return true
        else
            return false
        end
        return
    end
end
local function v83()
    if v81() then
        local ok = v71
        local t6 = {
            Url = s2 .. "/public/start",
            Method = "POST",
        }
        local HttpService = t1.HttpService
        t6.Body = HttpService.JSONEncode(HttpService, {
            service = t2.ServiceId,
            identifier = v63(v73()),
        })
        t6.Headers = {
            ["Content-Type"] = "application/json",
        }
        ok = ok(t6)
        if ok and ok.StatusCode == 200 then
            ok, t6 = pcall(t1.HttpService.JSONDecode, t1.HttpService, ok.Body)
            if ok and (t6.success and t6.data) then
                return true, t6.data.url
            else
                return false, "Server unreachable"
            end
            return
        else
            return false, "Server unreachable"
        end
        return
    else
        return false, "Network error. Use VPN or different executor."
    end
end
local function v87()
    local n12 = 16
    local n13 = 1
    local s3 = ""
    for _ = 1, n12, n13 do
        s3 = s3 .. string.char(math.floor(math.random() * 26) + 97)
        local _ = n12
        local _ = n13
    end
    return s3
end
local function v94(p31)
    if not v81() then
        return false, "Network error."
    end
    local v95 = v87()
    local ok = v71
    local t7 = {
        Url = s2 .. "/public/redeem/" .. tostring(t2.ServiceId),
        Method = "POST",
    }
    local HttpService = t1.HttpService
    t7.Body = HttpService.JSONEncode(HttpService, {
        identifier = v63(v73()),
        key = p31,
        nonce = v95,
    })
    t7.Headers = {
        ["Content-Type"] = "application/json",
    }
    ok = ok(t7)
    if not (ok and ok.StatusCode == 200) then
        return false, "Server error."
    end
    ok, t7 = pcall(t1.HttpService.JSONDecode, t1.HttpService, ok.Body)
    if not (ok and (t7.success and (t7.data and t7.data.valid))) then
        return false, ok and t7.message or "Invalid key."
    end
    if t7.data.hash ~= v63("true" .. "-" .. v95 .. "-" .. t2.PlatoSecret) then
        return false, "Integrity check failed."
    end
    if type(writefile) ~= "function" then
        return true, "Success"
    end
    pcall(writefile, t2.KeyFileName, p31)
    return true, "Success"
end
local function v99()
    local game_2 = game
    game_2 = game_2.HttpGet(game_2, t2.ScriptUrl)
    if type(game_2) == "string" and #game_2 >= 10 then
        game_2 = loadstring(game_2)
        if game_2 then
            local result
            game_2, result = pcall(game_2)
            if game_2 then
                return true
            else
                return false, "Runtime error: " .. tostring(result)
            end
            return
        else
            return false, "Compile failed."
        end
        return
    else
        return false, "Empty script."
    end
end
local t8 = {
    Background = Color3.fromRGB(18, 18, 22),
    Surface = Color3.fromRGB(25, 25, 30),
    Primary = Color3.fromRGB(45, 45, 50),
    Secondary = Color3.fromRGB(35, 35, 40),
    Border = Color3.fromRGB(40, 40, 45),
    TextPrimary = Color3.fromRGB(220, 220, 225),
    TextSecondary = Color3.fromRGB(140, 140, 150),
    Success = Color3.fromRGB(25, 135, 84),
    Error = Color3.fromRGB(180, 50, 50),
    Warning = Color3.fromRGB(200, 120, 30),
    Discord = Color3.fromRGB(60, 70, 180),
    GetKey = Color3.fromRGB(40, 140, 100),
    HoverPrimary = Color3.fromRGB(55, 55, 60),
    HoverDiscord = Color3.fromRGB(50, 60, 160),
    HoverGetKey = Color3.fromRGB(30, 120, 80),
    NeonWhite = Color3.fromRGB(255, 255, 255),
    NeonGlow = Color3.fromRGB(240, 248, 255),
}
local t9 = {
    IsLoading = false,
    Particles = {},
    Animations = {},
    IsDestroyed = false,
    MousePosition = {
        X = 0,
        Y = 0,
    },
    FocusStates = {
        InputFocused = false,
        ButtonHovered = {},
        AnimationsActive = true,
    },
}
local t10 = {}
local function createScreenGui()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DexaHubKeySystem"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 100
    ScreenGui.Parent = v4
    t10.ScreenGui = ScreenGui
    return ScreenGui
end
local function createFrame(p32)
    local Frame = Instance.new("Frame")
    Frame.Name = "Backdrop"
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BackgroundTransparency = 0.1
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 100
    Frame.Parent = p32
    t10.Backdrop = Frame
    return Frame
end
local function createFrame2(p33)
    local Frame = Instance.new("Frame")
    Frame.Name = "MainContainer"
    Frame.Size = UDim2.new(0, 420, 0, 600)
    Frame.Position = UDim2.new(0.5, -210, 0.5, -300)
    Frame.BackgroundColor3 = t8.Background
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 110
    Frame.Selectable = false
    Frame.Parent = p33
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 20)
    UICorner.Parent = Frame
    UICorner = Instance.new("UIStroke")
    UICorner.Color = t8.Border
    UICorner.Thickness = 1
    UICorner.Transparency = 0.3
    UICorner.Parent = Frame
    t10.Container = Frame
    return Frame
end
local function createFrame3(p34)
    local Frame = Instance.new("Frame")
    Frame.Name = "AnimatedBorder"
    Frame.Size = UDim2.new(1, 6, 1, 6)
    Frame.Position = UDim2.new(0, -3, 0, -3)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 109
    Frame.Selectable = false
    Frame.Parent = p34
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 23)
    UICorner.Parent = Frame
    UICorner = Instance.new("UIStroke")
    UICorner.Color = t8.NeonWhite
    UICorner.Thickness = 2
    UICorner.Transparency = 0.3
    UICorner.Parent = Frame
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, t8.NeonWhite),
        ColorSequenceKeypoint.new(0.5, t8.NeonGlow),
        ColorSequenceKeypoint.new(1, t8.NeonWhite),
    })
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(0.2, 0.1),
        NumberSequenceKeypoint.new(0.8, 0.1),
        NumberSequenceKeypoint.new(1, 0.9),
    })
    UIGradient.Parent = UICorner
    t10.AnimatedBorder = {
        Frame = Frame,
        Gradient = UIGradient,
        Stroke = UICorner,
    }
    return Frame
end
local function createFrame4(p35)
    local Frame = Instance.new("Frame")
    Frame.Name = "Header"
    Frame.Size = UDim2.new(1, 0, 0, 100)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 111
    Frame.Selectable = false
    Frame.Parent = p35
    local Frame2 = Instance.new("Frame")
    Frame2.Size = UDim2.new(0, 56, 0, 56)
    Frame2.Position = UDim2.new(0.5, -28, 0, 24)
    Frame2.BackgroundColor3 = t8.Primary
    Frame2.BorderSizePixel = 0
    Frame2.ZIndex = 112
    Frame2.Selectable = false
    Frame2.Parent = Frame
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 14)
    UICorner.Parent = Frame2
    UICorner = Instance.new("Frame")
    UICorner.Size = UDim2.new(1, 12, 1, 12)
    UICorner.Position = UDim2.new(0, -6, 0, -6)
    UICorner.BackgroundTransparency = 1
    UICorner.ZIndex = 111
    UICorner.Selectable = false
    UICorner.Parent = Frame2
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 20)
    UICorner2.Parent = UICorner
    UICorner2 = Instance.new("UIStroke")
    UICorner2.Color = t8.NeonWhite
    UICorner2.Thickness = 3
    UICorner2.Transparency = 0.2
    UICorner2.Parent = UICorner
    UICorner = Instance.new("UIGradient")
    UICorner.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, t8.NeonWhite),
        ColorSequenceKeypoint.new(0.5, t8.NeonGlow),
        ColorSequenceKeypoint.new(1, t8.NeonWhite),
    })
    UICorner.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.2, 0.05),
        NumberSequenceKeypoint.new(0.8, 0.05),
        NumberSequenceKeypoint.new(1, 0.8),
    })
    UICorner.Parent = UICorner2
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Size = UDim2.new(0.8, 0, 0.8, 0)
    ImageLabel.Position = UDim2.new(0.1, 0, 0.1, 0)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://95233466475324"
    ImageLabel.ImageColor3 = t8.NeonWhite
    ImageLabel.ImageTransparency = 0.1
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.ZIndex = 113
    ImageLabel.Parent = Frame2
    t10.Header = {
        Container = Frame,
        IconGlow = UICorner,
        IconStroke = UICorner2,
    }
    return Frame
end
local function createFrame5(p36)
    local Frame = Instance.new("Frame")
    Frame.Name = "Content"
    Frame.Size = UDim2.new(1, -64, 0, 440)
    Frame.Position = UDim2.new(0, 32, 0, 120)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 111
    Frame.Selectable = false
    Frame.Parent = p36
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, 0, 0, 32)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "Access Key Required"
    TextLabel.TextColor3 = t8.TextPrimary
    TextLabel.TextSize = 24
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel.ZIndex = 112
    TextLabel.Parent = Frame
    TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, 0, 0, 40)
    TextLabel.Position = UDim2.new(0, 0, 0, 40)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "Enter your access key to continue"
    TextLabel.TextColor3 = t8.TextSecondary
    TextLabel.TextSize = 16
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel.TextWrapped = true
    TextLabel.ZIndex = 112
    TextLabel.Parent = Frame
    t10.Content = Frame
    return Frame
end
local function createFrame6(p37)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 100)
    Frame.Position = UDim2.new(0, 0, 0, 100)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 112
    Frame.Selectable = false
    Frame.Parent = p37
    local Frame2 = Instance.new("Frame")
    Frame2.Size = UDim2.new(1, 0, 0, 52)
    Frame2.BackgroundColor3 = t8.Surface
    Frame2.BorderSizePixel = 0
    Frame2.ZIndex = 113
    Frame2.Selectable = false
    Frame2.Parent = Frame
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Frame2
    UICorner = Instance.new("UIStroke")
    UICorner.Color = t8.Border
    UICorner.Thickness = 1
    UICorner.Transparency = 0.3
    UICorner.Parent = Frame2
    local Frame3 = Instance.new("Frame")
    Frame3.Size = UDim2.new(1, 8, 1, 8)
    Frame3.Position = UDim2.new(0, -4, 0, -4)
    Frame3.BackgroundTransparency = 1
    Frame3.ZIndex = 112
    Frame3.Visible = false
    Frame3.Selectable = false
    Frame3.Parent = Frame2
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 16)
    UICorner2.Parent = Frame3
    UICorner2 = Instance.new("UIStroke")
    UICorner2.Color = t8.NeonWhite
    UICorner2.Thickness = 2
    UICorner2.Transparency = 0.3
    UICorner2.Parent = Frame3
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, t8.NeonWhite),
        ColorSequenceKeypoint.new(0.5, t8.NeonGlow),
        ColorSequenceKeypoint.new(1, t8.NeonWhite),
    })
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.2, 0.1),
        NumberSequenceKeypoint.new(0.8, 0.1),
        NumberSequenceKeypoint.new(1, 0.8),
    })
    UIGradient.Parent = UICorner2
    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(1, -24, 1, 0)
    TextBox.Position = UDim2.new(0, 12, 0, 0)
    TextBox.BackgroundTransparency = 1
    TextBox.Text = ""
    TextBox.PlaceholderText = "Enter key here"
    TextBox.TextColor3 = t8.TextPrimary
    TextBox.PlaceholderColor3 = t8.TextSecondary
    TextBox.TextSize = 16
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.ClearTextOnFocus = false
    TextBox.ZIndex = 114
    TextBox.Selectable = true
    TextBox.Parent = Frame2
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(0, 80, 0, 20)
    TextLabel.Position = UDim2.new(1, -85, 0, 60)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "0/" .. t2.MaxKeyLength
    TextLabel.TextColor3 = t8.TextSecondary
    TextLabel.TextSize = 12
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right
    TextLabel.ZIndex = 113
    TextLabel.Parent = Frame
    Frame2 = {
        Container = Frame2,
        TextBox = TextBox,
        Counter = TextLabel,
        Stroke = UICorner,
        Glow = {
            Frame = Frame3,
            Stroke = UICorner2,
            Gradient = UIGradient,
        },
    }
    t10.Input = Frame2
    return Frame
end
local function v134(p38)
    local TextButton = Instance.new("TextButton")
    TextButton.Size = UDim2.new(1, 0, 0, 48)
    TextButton.Position = UDim2.new(0, 0, 0, 200)
    TextButton.BackgroundColor3 = t8.Primary
    TextButton.BorderSizePixel = 0
    TextButton.Text = "Verify Access Key"
    TextButton.TextColor3 = t8.TextPrimary
    TextButton.TextSize = 16
    TextButton.Font = Enum.Font.GothamMedium
    TextButton.AutoButtonColor = false
    TextButton.ZIndex = 113
    TextButton.Selectable = true
    TextButton.Parent = p38
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = TextButton
    UICorner = Instance.new("Frame")
    UICorner.Size = UDim2.new(0, 24, 0, 24)
    UICorner.Position = UDim2.new(0.5, -12, 0, 12)
    UICorner.BackgroundTransparency = 1
    UICorner.Visible = false
    UICorner.ZIndex = 114
    UICorner.Selectable = false
    UICorner.Parent = TextButton
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundColor3 = t8.TextPrimary
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 115
    Frame.Selectable = false
    Frame.Parent = UICorner
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(1, 0)
    UICorner2.Parent = Frame
    UICorner2 = Instance.new("UIGradient")
    UICorner2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.8, 0.8),
        NumberSequenceKeypoint.new(1, 1),
    })
    UICorner2.Parent = Frame
    UICorner2 = Instance.new("Frame")
    UICorner2.Size = UDim2.new(1, 0, 0, 48)
    UICorner2.Position = UDim2.new(0, 0, 0, 260)
    UICorner2.BackgroundTransparency = 1
    UICorner2.ZIndex = 112
    UICorner2.Selectable = false
    UICorner2.Parent = p38
    local TextButton2 = Instance.new("TextButton")
    TextButton2.Size = UDim2.new(0.48, 0, 1, 0)
    TextButton2.BackgroundColor3 = t8.GetKey
    TextButton2.BorderSizePixel = 0
    TextButton2.Text = "Get Key"
    TextButton2.TextColor3 = t8.TextPrimary
    TextButton2.TextSize = 14
    TextButton2.Font = Enum.Font.GothamMedium
    TextButton2.AutoButtonColor = false
    TextButton2.ZIndex = 113
    TextButton2.Selectable = true
    TextButton2.Parent = UICorner2
    local UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(0, 10)
    UICorner3.Parent = TextButton2
    UICorner3 = Instance.new("TextButton")
    UICorner3.Size = UDim2.new(0.48, 0, 1, 0)
    UICorner3.Position = UDim2.new(0.52, 0, 0, 0)
    UICorner3.BackgroundColor3 = t8.Discord
    UICorner3.BorderSizePixel = 0
    UICorner3.Text = "Discord"
    UICorner3.TextColor3 = t8.TextPrimary
    UICorner3.TextSize = 14
    UICorner3.Font = Enum.Font.GothamMedium
    UICorner3.AutoButtonColor = false
    UICorner3.ZIndex = 113
    UICorner3.Selectable = true
    UICorner3.Parent = UICorner2
    UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 10)
    UICorner2.Parent = UICorner3
    UICorner = {
        Submit = TextButton,
        GetKey = TextButton2,
        Discord = UICorner3,
        Loading = {
            Container = UICorner,
            Spinner = Frame,
        },
    }
    t10.Buttons = UICorner
    return {
        TextButton,
        TextButton2,
        UICorner3,
    }
end
local function createTextLabel(p39)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 60)
    Frame.Position = UDim2.new(0, 0, 0, 330)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 112
    Frame.Selectable = false
    Frame.Parent = p39
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = ""
    TextLabel.TextColor3 = t8.Error
    TextLabel.TextSize = 14
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel.TextWrapped = true
    TextLabel.ZIndex = 113
    TextLabel.Parent = Frame
    t10.Status = TextLabel
    return TextLabel
end
local function createFrame7(p40)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 105
    Frame.Selectable = false
    Frame.Parent = p40
    t10.ParticleContainer = Frame
    return Frame
end
local function v146()
    if t10.ParticleContainer and (t10.ParticleContainer.Parent and not t9.IsDestroyed) then
        local v147 = math.random(8, 24)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0, v147, 0, v147)
        Frame.Position = UDim2.new(math.random() * 1.4 - 0.2, 0, 1.2, 0)
        Frame.BackgroundColor3 = t8.NeonWhite
        Frame.BackgroundTransparency = math.random(60, 85) / 100
        Frame.BorderSizePixel = 0
        Frame.ZIndex = 106
        Frame.Selectable = false
        Frame.Parent = t10.ParticleContainer
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(1, 0)
        UICorner.Parent = Frame
        UICorner = Instance.new("UIGradient")
        local parent = {
            Color3.fromRGB(200, 230, 255),
            Color3.fromRGB(180, 220, 255),
            Color3.fromRGB(220, 240, 255),
            Color3.fromRGB(190, 210, 240),
        }
        local UICorner2 = parent[math.random(#parent)]
        parent = parent[math.random(#parent)]
        UICorner.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, UICorner2),
            ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.7, parent),
            ColorSequenceKeypoint.new(1, UICorner2),
        })
        UICorner.Rotation = math.random(0, 360)
        UICorner.Parent = Frame
        UICorner = Instance.new("Frame")
        UICorner.Size = UDim2.new(0.3, 0, 0.3, 0)
        UICorner.Position = UDim2.new(0.2, 0, 0.15, 0)
        UICorner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        UICorner.BackgroundTransparency = 0.3
        UICorner.BorderSizePixel = 0
        UICorner.ZIndex = Frame.ZIndex + 1
        UICorner.Parent = Frame
        parent = Instance.new("UICorner")
        parent.CornerRadius = UDim.new(1, 0)
        parent.Parent = UICorner
        parent = Instance.new("Frame")
        parent.Size = UDim2.new(1.8, 0, 1.8, 0)
        parent.Position = UDim2.new(-0.4, 0, -0.4, 0)
        parent.BackgroundColor3 = Color3.fromRGB(200, 230, 255)
        parent.BackgroundTransparency = 0.9
        parent.BorderSizePixel = 0
        parent.ZIndex = Frame.ZIndex - 1
        parent.Parent = Frame
        UICorner2 = Instance.new("UICorner")
        UICorner2.CornerRadius = UDim.new(1, 0)
        UICorner2.Parent = parent
        v147 = {
            frame = Frame,
            vx = (math.random() - 0.5) * 0.004,
            vy = -math.random(20, 50) / 10000,
            created = tick(),
            rotation = 0,
            rotationSpeed = (math.random() - 0.5) * 2,
            pulsePhase = math.random() * math.pi * 2,
            driftPhase = math.random() * math.pi * 2,
            originalTransparency = Frame.BackgroundTransparency,
            glow = parent,
            highlight = UICorner,
            lifetime = math.random(30, 60),
            originalSize = v147,
            wobblePhase = math.random() * math.pi * 2,
            repelForce = {
                x = 0,
                y = 0,
            },
            mass = v147 / 10,
        }
        table.insert(t9.Particles, v147)
        return Frame
    else
        return nil
    end
end
local function v152()
    if t9.IsDestroyed or not t10.ParticleContainer then
        return
    else
        local AbsoluteSize = t10.ScreenGui.AbsoluteSize
        local v154 = t9.MousePosition.X / AbsoluteSize.X
        AbsoluteSize = t9.MousePosition.Y / AbsoluteSize.Y
        local n14 = 1
        local n15 = -1
        for i = #t9.Particles, n14, n15 do
            local frame = t9.Particles[i]
            if frame and (frame.frame and frame.frame.Parent) then
                v193 = frame.frame.Position
                local backgroundTransparency = tick() - frame.created
                if v193.Y.Scale < -0.3 or frame.lifetime < backgroundTransparency then
                    frame = frame.frame
                    frame.Destroy(frame)
                    table.remove(t9.Particles, i)
                else
                    backgroundTransparency = math.sqrt((v193.X.Scale - v154) ^ 2 + (v193.Y.Scale - AbsoluteSize) ^ 2)
                    local n16 = 0.08
                    local backgroundTransparency2 = 0.15
                    if backgroundTransparency < backgroundTransparency2 and backgroundTransparency > 0 then
                        n16 = (backgroundTransparency2 - backgroundTransparency) / backgroundTransparency2 * n16 / frame.mass
                        backgroundTransparency2 = (v193.X.Scale - v154) / backgroundTransparency
                        local v162 = (v193.Y.Scale - AbsoluteSize) / backgroundTransparency
                        backgroundTransparency2 = backgroundTransparency2 * n16
                        n16 = v162 * n16
                    else
                        backgroundTransparency2 = 0
                        n16 = 0
                    end
                    frame.repelForce.x = frame.repelForce.x * 0.85 + backgroundTransparency2 * 0.15
                    frame.repelForce.y = frame.repelForce.y * 0.85 + n16 * 0.15
                    n16 = v193.X.Scale + frame.vx + frame.repelForce.x
                    v193 = v193.Y.Scale + frame.vy + frame.repelForce.y
                    n16 = n16 <= -0.2 and 1.2 or (n16 >= 1.2 and -0.2 or n16)
                    backgroundTransparency2 = tick() * 1.5 + frame.wobblePhase
                    n16 = n16 + math.sin(backgroundTransparency2) * 0.002
                    v193 = v193 + math.cos(backgroundTransparency2 * 0.7) * 0.001
                    n16 = n16 + (math.random() - 0.5) * 0.0008
                    v193 = v193 + (math.random() - 0.5) * 0.0005
                    frame.rotation = frame.rotation + frame.rotationSpeed
                    frame.frame.Rotation = frame.rotation
                    backgroundTransparency2 = math.sin(tick() * 2.5 + frame.pulsePhase) * 0.1 + 1
                    backgroundTransparency2 = frame.originalSize * backgroundTransparency2
                    frame.frame.Size = UDim2.new(0, backgroundTransparency2, 0, backgroundTransparency2)
                    backgroundTransparency2 = math.sin(tick() * 3 + frame.pulsePhase) * 0.1
                    backgroundTransparency2 = math.max(0.5, math.min(0.95, frame.originalTransparency + backgroundTransparency2))
                    frame.frame.BackgroundTransparency = backgroundTransparency2
                    backgroundTransparency = backgroundTransparency >= 0.2 and 0.9 or 0.7 + backgroundTransparency / 0.2 * 0.2
                    frame.glow.BackgroundTransparency = backgroundTransparency
                    backgroundTransparency = math.sin(tick() * 4 + frame.pulsePhase) * 0.2 + 0.3
                    frame.highlight.BackgroundTransparency = backgroundTransparency
                    frame.vx = frame.vx * 0.995
                    frame.vy = frame.vy * 0.998
                    frame.frame.Position = UDim2.new(n16, 0, v193, 0)
                end
            else
                table.remove(t9.Particles, i)
            end
            frame = n14
            local v163 = n15
        end
        return
    end
end
local function v164(p41, p42, p43)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 8, 1, 8)
    Frame.Position = UDim2.new(0, -4, 0, -4)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = p41.ZIndex - 1
    Frame.Visible = false
    Frame.Selectable = false
    Frame.Parent = p41
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 14)
    UICorner.Parent = Frame
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = t8.NeonWhite
    UIStroke.Thickness = 2
    UIStroke.Transparency = 0.3
    UIStroke.Parent = Frame
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, t8.NeonWhite),
        ColorSequenceKeypoint.new(0.5, t8.NeonGlow),
        ColorSequenceKeypoint.new(1, t8.NeonWhite),
    })
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.2, 0.1),
        NumberSequenceKeypoint.new(0.8, 0.1),
        NumberSequenceKeypoint.new(1, 0.8),
    })
    UIGradient.Parent = UIStroke
    local u169 = nil
    local v170 = tostring(p41)
    UICorner = p41.MouseEnter
    UICorner.Connect(UICorner, function()
        t9.FocusStates.ButtonHovered[v170] = true
        Frame.Visible = true
        local TweenService = t1.TweenService
        local t11 = {
            BackgroundColor3 = p42,
        }
        TweenService = TweenService.Create(TweenService, p41, TweenInfo.new(0.2, Enum.EasingStyle.Quad), t11)
        TweenService.Play(TweenService)
        TweenService = t1.TweenService
        TweenService = TweenService.Create(TweenService, UIStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Transparency = 0.1,
        })
        TweenService.Play(TweenService)
        if not u169 then
            TweenService = t1.TweenService
            u169 = TweenService.Create(TweenService, UIGradient, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
                Rotation = 360,
            })
            TweenService = u169
            TweenService.Play(TweenService)
            return
        end
        TweenService = u169
        TweenService.Cancel(TweenService)
        TweenService = t1.TweenService
        u169 = TweenService.Create(TweenService, UIGradient, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
            Rotation = 360,
        })
        TweenService = u169
        TweenService.Play(TweenService)
    end)
    UICorner = p41.MouseLeave
    UICorner.Connect(UICorner, function()
        t9.FocusStates.ButtonHovered[v170] = false
        local TweenService = t1.TweenService
        local t12 = {
            BackgroundColor3 = p43,
        }
        TweenService = TweenService.Create(TweenService, p41, TweenInfo.new(0.2, Enum.EasingStyle.Quad), t12)
        TweenService.Play(TweenService)
        TweenService = t1.TweenService
        TweenService = TweenService.Create(TweenService, UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Transparency = 0.8,
        })
        TweenService.Play(TweenService)
        if u169 then
            TweenService = u169
            TweenService.Cancel(TweenService)
            UIGradient.Rotation = 0
        end
        task.spawn(function()
            task.wait(0.3)
            if not (Frame and Frame.Parent) then
                return
            end
            Frame.Visible = false
        end)
    end)
    return {
        Frame,
        UIStroke,
        UIGradient,
    }
end
local function v175(p44, p45, p46)
    if t10.Status then
        t10.Status.Text = p44
        if p46 then
            t10.Status.TextColor3 = t8.Success
        elseif p45 then
            t10.Status.TextColor3 = t8.Error
        else
            t10.Status.TextColor3 = t8.Warning
        end
        t10.Status.TextTransparency = 1
        local TweenService = t1.TweenService
        TweenService = TweenService.Create(TweenService, t10.Status, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            TextTransparency = 0,
        })
        TweenService.Play(TweenService)
        return
    else
        return
    end
end
local function v177()
    if not t10.Status then
        return
    end
    local TweenService = t1.TweenService
    TweenService = TweenService.Create(TweenService, t10.Status, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        TextTransparency = 1,
    })
    TweenService.Play(TweenService)
end
local function v179(p47)
    t9.IsLoading = p47
    if t10.Buttons then
        t10.Buttons.Loading.Container.Visible = p47
        t10.Buttons.Submit.Text = p47 and "" or "Verify Access Key"
        local TweenService
        if p47 then
            TweenService = t1.TweenService
            TweenService = TweenService.Create(TweenService, t10.Buttons.Loading.Spinner, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
                Rotation = 360,
            })
            TweenService.Play(TweenService)
            t9.Animations.SpinTween = TweenService
        else
            if not t9.Animations.SpinTween then
                return
            end
            TweenService = t9.Animations.SpinTween
            TweenService.Cancel(TweenService)
            t10.Buttons.Loading.Spinner.Rotation = 0
        end
        return
    else
        return
    end
end
local function v181()
    if t10.Input then
        local v182 = string.len(t10.Input.TextBox.Text)
        t10.Input.Counter.Text = v182 .. "/" .. t2.MaxKeyLength
        if t2.MaxKeyLength <= v182 then
            t10.Input.Counter.TextColor3 = t8.Error
        elseif t2.MaxKeyLength * 0.8 <= v182 then
            t10.Input.Counter.TextColor3 = t8.Warning
        else
            t10.Input.Counter.TextColor3 = t8.TextSecondary
        end
        return
    else
        return
    end
end
local function v183(p48, p49)
    if pcall(function()
        if setclipboard then
            setclipboard(p48)
            v175(p49, false, true)
        else
            v175("Link: " .. p48, false, true)
        end
    end) then
        return
    end
    v175("Link: " .. p48, false, true)
end
local function v184()
    if t9.IsLoading then
        return
    else
        local Text = t10.Input.TextBox.Text
        if Text == "" then
            v175("Please enter an access key.", true)
            Text = t10.Input.TextBox
            Text.CaptureFocus(Text)
            return
        end
        return
    end
end
local function v186()
    local InputChanged = t1.UserInputService.InputChanged
    InputChanged.Connect(InputChanged, function(p50, _)
        if p50.UserInputType ~= Enum.UserInputType.MouseMovement then
            return
        end
        t9.MousePosition.X = p50.Position.X
        t9.MousePosition.Y = p50.Position.Y
    end)
    InputChanged = t10.Input.TextBox
    InputChanged = InputChanged.GetPropertyChangedSignal(InputChanged, "Text")
    InputChanged.Connect(InputChanged, function()
        local Text = t10.Input.TextBox.Text
        if not (string.len(Text) > t2.MaxKeyLength) then
            v181()
            v177()
            return
        end
        t10.Input.TextBox.Text = string.sub(Text, 1, t2.MaxKeyLength)
        v175("Maximum character limit reached (" .. t2.MaxKeyLength .. ")", true)
        v181()
        v177()
    end)
    local u189 = nil
    InputChanged = t10.Input.TextBox.Focused
    InputChanged.Connect(InputChanged, function()
        t9.FocusStates.InputFocused = true
        t10.Input.Glow.Frame.Visible = true
        local TweenService = t1.TweenService
        TweenService = TweenService.Create(TweenService, t10.Input.Stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Color = t8.NeonWhite,
            Transparency = 0.1,
        })
        TweenService.Play(TweenService)
        TweenService = t1.TweenService
        TweenService = TweenService.Create(TweenService, t10.Input.Glow.Stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Transparency = 0.1,
        })
        TweenService.Play(TweenService)
        if not u189 then
            TweenService = t1.TweenService
            u189 = TweenService.Create(TweenService, t10.Input.Glow.Gradient, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
                Rotation = 360,
            })
            TweenService = u189
            TweenService.Play(TweenService)
            t9.Animations.InputGlowTween = u189
            v177()
            return
        end
        TweenService = u189
        TweenService.Cancel(TweenService)
        TweenService = t1.TweenService
        u189 = TweenService.Create(TweenService, t10.Input.Glow.Gradient, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
            Rotation = 360,
        })
        TweenService = u189
        TweenService.Play(TweenService)
        t9.Animations.InputGlowTween = u189
        v177()
    end)
    InputChanged = t10.Input.TextBox.FocusLost
    InputChanged.Connect(InputChanged, function()
        t9.FocusStates.InputFocused = false
        local TweenService = t1.TweenService
        TweenService = TweenService.Create(TweenService, t10.Input.Stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Color = t8.Border,
            Transparency = 0.3,
        })
        TweenService.Play(TweenService)
        TweenService = t1.TweenService
        TweenService = TweenService.Create(TweenService, t10.Input.Glow.Stroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Transparency = 0.8,
        })
        TweenService.Play(TweenService)
        if u189 then
            TweenService = u189
            TweenService.Cancel(TweenService)
            t10.Input.Glow.Gradient.Rotation = 0
            t9.Animations.InputGlowTween = nil
        end
        task.spawn(function()
            task.wait(0.3)
            if not (t10.Input.Glow.Frame and t10.Input.Glow.Frame.Parent) then
                return
            end
            t10.Input.Glow.Frame.Visible = false
        end)
    end)
    InputChanged = t1.UserInputService.InputBegan
    InputChanged.Connect(InputChanged, function(p51, p52)
        if p52 or t9.IsDestroyed then
            return
        end
        if p51.KeyCode ~= Enum.KeyCode.Return then
            return
        end
        local TextBox = t10.Input.TextBox
        if not TextBox.IsFocused(TextBox) then
            return
        end
        v184()
    end)
    InputChanged = t10.Buttons.Submit.MouseButton1Click
    InputChanged.Connect(InputChanged, v184)
    InputChanged = t10.Buttons.GetKey.MouseButton1Click
    InputChanged.Connect(InputChanged, function()
        v175("Fetching key link...", false, false)
        task.spawn(function()
            local v194, v195 = v83()
            if v194 then
                v183(v195, "Platoboost link copied!")
            else
                v175(v195 or "Failed to get link.", true)
            end
        end)
    end)
    InputChanged = t10.Buttons.Discord.MouseButton1Click
    InputChanged.Connect(InputChanged, function()
        v175("Opening Discord invite...", false, false)
        v183(t2.DiscordUrl, "Discord link copied to clipboard!")
    end)
end
local function v196()
    t9.Animations.BorderTween = nil
    t9.Animations.IconTween = nil
    t9.FocusStates.AnimationsActive = true
    task.spawn(function()
        local n17 = 25
        local n18 = 1
        for _ = 1, n17, n18 do
            if t9.IsDestroyed then
                while not t9.IsDestroyed and t10.ScreenGui.Parent do
                    if #t9.Particles < t2.ParticleCount then
                        v146()
                    end
                    task.wait(math.random(400, 1200) / 1000)
                end
                return
            end
            v146()
            task.wait(math.random(20, 100) / 1000)
            local _ = n17
            local _ = n18
        end
        while not t9.IsDestroyed and t10.ScreenGui.Parent do
            if #t9.Particles < t2.ParticleCount then
                v146()
            end
            task.wait(math.random(400, 1200) / 1000)
        end
    end)
    task.spawn(function()
        while not t9.IsDestroyed and t10.ScreenGui.Parent do
            pcall(v152)
            task.wait(1 / t2.ParticleSpeed)
        end
    end)
    task.spawn(function()
        while not t9.IsDestroyed and (t10.AnimatedBorder and t10.AnimatedBorder.Frame.Parent) do
            if t9.Animations.BorderTween then
                v240 = t9.Animations.BorderTween
                v240.Cancel(v240)
            end
            local Rotation = t10.AnimatedBorder.Gradient.Rotation
            local TweenService = t1.TweenService
            local v203 = TweenService.Create(TweenService, t10.AnimatedBorder.Gradient, TweenInfo.new(4, Enum.EasingStyle.Linear), {
                Rotation = Rotation + 360,
            })
            t9.Animations.BorderTween = v203
            Rotation = v203
            v203.Play(Rotation)
            if not pcall(function()
                local Completed = v203.Completed
                Completed.Wait(Completed)
            end) then
                task.wait(4)
            end
            if t10.AnimatedBorder and (t10.AnimatedBorder.Gradient and t10.AnimatedBorder.Gradient.Parent) then
                t10.AnimatedBorder.Gradient.Rotation = t10.AnimatedBorder.Gradient.Rotation % 360
            end
            task.wait(0.1)
        end
    end)
    task.spawn(function()
        while not t9.IsDestroyed and (t10.Header and (t10.Header.IconGlow and t10.Header.IconGlow.Parent)) do
            if t9.Animations.IconTween then
                v244 = t9.Animations.IconTween
                v244.Cancel(v244)
            end
            local Rotation = t10.Header.IconGlow.Rotation
            local Animations = t9.Animations
            local TweenService = t1.TweenService
            Animations.IconTween = TweenService.Create(TweenService, t10.Header.IconGlow, TweenInfo.new(3, Enum.EasingStyle.Linear), {
                Rotation = Rotation + 360,
            })
            Rotation = t9.Animations.IconTween
            Rotation.Play(Rotation)
            if not pcall(function()
                local Completed = t9.Animations.IconTween.Completed
                Completed.Wait(Completed)
            end) then
                task.wait(3)
            end
            if t10.Header and (t10.Header.IconGlow and t10.Header.IconGlow.Parent) then
                t10.Header.IconGlow.Rotation = t10.Header.IconGlow.Rotation % 360
            end
            task.wait(0.1)
        end
    end)
end
local function v209()
    t10.Container.Size = UDim2.new(0, 0, 0, 0)
    t10.Container.BackgroundTransparency = 1
    t10.Backdrop.BackgroundTransparency = 1
    local TweenService = t1.TweenService
    TweenService = TweenService.Create(TweenService, t10.Backdrop, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 0.1,
    })
    TweenService.Play(TweenService)
    task.wait(0.1)
    TweenService = t1.TweenService
    TweenService = TweenService.Create(TweenService, t10.Container, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 420, 0, 600),
        BackgroundTransparency = 0,
    })
    TweenService.Play(TweenService)
    task.wait(0.5)
    TweenService = t10.Input.TextBox
    TweenService.CaptureFocus(TweenService)
end
game_ = function()
    local TextLabel = createScreenGui()
    createFrame7((createFrame(TextLabel)))
    TextLabel = createFrame2(TextLabel)
    createFrame3(TextLabel)
    createFrame4(TextLabel)
    TextLabel = createFrame5(TextLabel)
    createFrame6(TextLabel)
    v134(TextLabel)
    createTextLabel(TextLabel)
    v164(t10.Buttons.Submit, t8.HoverPrimary, t8.Primary)
    v164(t10.Buttons.GetKey, t8.HoverGetKey, t8.GetKey)
    v164(t10.Buttons.Discord, t8.HoverDiscord, t8.Discord)
    v181()
    v186()
    v196()
    v209()
    TextLabel = Instance.new("TextLabel", t10.Container)
    TextLabel.Size = UDim2.new(1, -20, 0, 16)
    TextLabel.Position = UDim2.new(0, 10, 1, -22)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "By verifying a key, your Roblox username is logged for security."
    TextLabel.TextColor3 = Color3.fromRGB(100, 100, 110)
    TextLabel.TextSize = 10
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel.ZIndex = 111
    if t3.LogHubOpened then
        v79("Hub Opened", {})
    end
    if not (type(isfile) == "function" and (type(readfile) == "function" and isfile(t2.KeyFileName))) then
        return
    end
    TextLabel = readfile(t2.KeyFileName)
    if not (TextLabel and TextLabel ~= "") then
        return
    end
    v175("Found saved key, verifying...", false, false)
    t10.Input.TextBox.Text = TextLabel
    task.spawn(function()
        local ScreenGui, v213 = v94(TextLabel)
        if ScreenGui then
            v175("Auto-login success!", false, true)
            v79("Auto-Login", {
                {
                    name = "🔑 Key Used",
                    value = "`" .. string.sub(TextLabel, 1, 25) .. "...`",
                    inline = false,
                },
            })
            task.wait(0.8)
            if v99() then
                v79("Script Executed", {})
                t9.IsDestroyed = true
                if not t10.ScreenGui then
                    return
                end
                ScreenGui = t10.ScreenGui
                ScreenGui.Destroy(ScreenGui)
            else
                v175("Script failed to load.", true)
            end
        else
            v175("Saved key invalid: " .. tostring(v213), true)
        end
    end)
end
local result
game_, result = pcall(game_)
if game_ then
    print("[DexaHub] Loaded OK")
else
    warn("[DexaHub] FATAL: " .. tostring(result))
    print("[DexaHub] FATAL: " .. tostring(result))
end
