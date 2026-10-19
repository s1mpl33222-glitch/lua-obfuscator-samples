getgenv().SCRIPT_KEY = "keyless"
do
    local Players      = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local lp           = Players.LocalPlayer
    local sg           = Instance.new("ScreenGui")
    sg.Name            = "MeritLoader"
    sg.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
    sg.ResetOnSpawn    = false
    sg.DisplayOrder    = 10000
    pcall(function() sg.IgnoreGuiInset = true end)
    local placed = pcall(function() sg.Parent = gethui() end)
    if not placed or not sg.Parent then
        sg.Parent = lp:WaitForChild("PlayerGui")
    end

    local function mk(cls, props)
        local inst = Instance.new(cls)
        for k, v in pairs(props) do
            if k ~= "Parent" and k ~= "Children" then inst[k] = v end
        end
        if props.Children then
            for _, c in ipairs(props.Children) do c.Parent = inst end
        end
        if props.Parent then inst.Parent = props.Parent end
        return inst
    end

    local K = {
        Card    = Color3.fromRGB(21, 19, 31),
        Track   = Color3.fromRGB(30, 28, 45),
        Line    = Color3.fromRGB(48, 45, 68),
        Accent  = Color3.fromRGB(196, 165, 250),
        Accent2 = Color3.fromRGB(140, 110, 240),
        OnAcc   = Color3.fromRGB(28, 22, 34),
        Text    = Color3.fromRGB(224, 222, 244),
        Dim     = Color3.fromRGB(128, 124, 156),
    }
    local FONT      = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    local FONT_MED  = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    local FONT_BOLD = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    local GLOW      = "rbxassetid://8992230677"
    local W, H      = 320, 112

    mk("Frame", {
        Parent = sg, Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.55, BorderSizePixel = 0,
        Active = true,
    })

    local holder = mk("Frame", {
        Parent = sg, Size = UDim2.new(0, W, 0, H),
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        BackgroundTransparency = 1,
    })
    local fit = 1
    pcall(function()
        fit = math.min(1, (workspace.CurrentCamera.ViewportSize.X - 24) / W)
    end)
    local scale = mk("UIScale", { Parent = holder, Scale = fit * 0.94 })

    mk("ImageLabel", {
        Parent = holder, Size = UDim2.new(1, 50, 1, 50), Position = UDim2.new(0, -25, 0, -25),
        BackgroundTransparency = 1, Image = "rbxassetid://6014261993", ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.6, ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450),
    })

    local card = mk("CanvasGroup", {
        Parent = holder, Size = UDim2.fromScale(1, 1), BackgroundColor3 = K.Card,
        BorderSizePixel = 0, GroupTransparency = 1,
    })
    mk("UICorner", { CornerRadius = UDim.new(0, 12), Parent = card })
    mk("UIStroke", { Parent = card, Color = K.Line, Thickness = 1, Transparency = 0.2 })

    mk("ImageLabel", {
        Parent = card, Size = UDim2.new(0, 260, 0, 180), Position = UDim2.new(0, 20, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Image = GLOW,
        ImageColor3 = K.Accent2, ImageTransparency = 0.88,
    })
    mk("ImageLabel", {
        Parent = card, Size = UDim2.new(0, 300, 0, 160), Position = UDim2.new(1, -10, 1, 10),
        AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Image = GLOW,
        ImageColor3 = K.Accent, ImageTransparency = 0.86,
    })

    local topLine = mk("Frame", {
        Parent = card, Size = UDim2.new(0, 120, 0, 2), Position = UDim2.new(0.5, -60, 0, 0),
        BackgroundColor3 = K.Accent, BorderSizePixel = 0, ZIndex = 3,
    })
    mk("UIGradient", {
        Parent = topLine, Color = ColorSequence.new(K.Accent2, K.Accent),
        Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1) }),
    })

    local badge = mk("Frame", {
        Parent = card, Size = UDim2.new(0, 38, 0, 38), Position = UDim2.new(0, 22, 0, 20),
        BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 2,
    })
    mk("UICorner", { CornerRadius = UDim.new(0, 10), Parent = badge })
    mk("UIStroke", { Parent = badge, Color = K.Line, Thickness = 1, Transparency = 0 })
    mk("UIGradient", { Parent = badge, Rotation = 90, Color = ColorSequence.new(Color3.fromRGB(37, 37, 49), Color3.fromRGB(45, 41, 55)) })
    local badgeM = mk("TextLabel", {
        Parent = badge, Size = UDim2.fromScale(1, 1), Position = UDim2.new(0, 0, 0, 1), BackgroundTransparency = 1,
        Text = "M", TextColor3 = Color3.fromRGB(224, 222, 244), TextSize = 25,
        FontFace = Font.fromEnum(Enum.Font.Garamond), ZIndex = 3,
    })
    local badgeImg = mk("ImageLabel", {
        Parent = badge, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, ZIndex = 4,
    })
    mk("UICorner", { CornerRadius = UDim.new(0, 10), Parent = badgeImg })
    task.spawn(function()
        pcall(function()
            local toAsset = getcustomasset or getsynasset
            if not (toAsset and writefile and isfile) then return end
            local path = "merithub_icon.png"
            if not isfile(path) then
                local data = game:HttpGet("https://usemerit.store/favicon.ico")
                if type(data) ~= "string" or data:sub(2, 4) ~= "PNG" then return end
                writefile(path, data)
            end
            local id = toAsset(path)
            if id and badgeImg.Parent then
                badgeImg.Image = id
                badgeImg.Visible = true
                badgeM.Visible = false
            end
        end)
    end)

    local ring = mk("Frame", {
        Parent = card, Size = UDim2.new(0, 38, 0, 38), Position = UDim2.new(0, 41, 0, 39),
        AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, ZIndex = 1,
    })
    mk("UICorner", { CornerRadius = UDim.new(0, 12), Parent = ring })
    local ringStroke = mk("UIStroke", { Parent = ring, Color = K.Accent, Thickness = 1.5, Transparency = 0.3 })
    task.spawn(function()
        while ring.Parent do
            ring.Size = UDim2.new(0, 38, 0, 38)
            ringStroke.Transparency = 0.3
            TweenService:Create(ring, TweenInfo.new(1.4, Enum.EasingStyle.Sine), { Size = UDim2.new(0, 58, 0, 58) }):Play()
            TweenService:Create(ringStroke, TweenInfo.new(1.4, Enum.EasingStyle.Sine), { Transparency = 1 }):Play()
            task.wait(1.8)
        end
    end)

    mk("TextLabel", {
        Parent = card, Size = UDim2.new(1, -90, 0, 22), Position = UDim2.new(0, 72, 0, 19),
        BackgroundTransparency = 1, Text = "MeritHub", TextColor3 = K.Text, TextSize = 19,
        FontFace = FONT_MED, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2,
    })
    local subLbl = mk("TextLabel", {
        Parent = card, Size = UDim2.new(1, -90, 0, 14), Position = UDim2.new(0, 72, 0, 41),
        BackgroundTransparency = 1, Text = "Loading", TextColor3 = K.Dim, TextSize = 12,
        FontFace = FONT, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2,
    })
    task.spawn(function()
        local n = 0
        while subLbl.Parent do
            n = n % 3 + 1
            subLbl.Text = "Loading" .. string.rep(".", n)
            task.wait(0.4)
        end
    end)

    local track = mk("Frame", {
        Parent = card, Size = UDim2.new(1, -44, 0, 4), Position = UDim2.new(0, 22, 0, 72),
        BackgroundColor3 = K.Track, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 2,
    })
    mk("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })
    local sweep = mk("Frame", {
        Parent = track, Size = UDim2.new(0.35, 0, 1, 0), Position = UDim2.new(-0.35, 0, 0, 0),
        BackgroundColor3 = K.Accent, BorderSizePixel = 0, ZIndex = 3,
    })
    mk("UICorner", { CornerRadius = UDim.new(1, 0), Parent = sweep })
    mk("UIGradient", { Parent = sweep, Color = ColorSequence.new(K.Accent2, K.Accent) })
    task.spawn(function()
        while sweep.Parent do
            sweep.Position = UDim2.new(-0.35, 0, 0, 0)
            TweenService:Create(sweep, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Position = UDim2.new(1, 0, 0, 0) }):Play()
            task.wait(1.25)
        end
    end)

    local warnLbl = mk("TextLabel", {
        Parent = card, Size = UDim2.new(1, -44, 0, 14), Position = UDim2.new(0, 22, 0, 84),
        BackgroundTransparency = 1,
        Text = "Might take a few seconds to load.",
        TextColor3 = K.Dim, TextSize = 11, FontFace = FONT,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2,
    })

    TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quint), { GroupTransparency = 0 }):Play()
    TweenService:Create(scale, TweenInfo.new(0.35, Enum.EasingStyle.Back), { Scale = fit }):Play()

    shared.__MeritSplashWarn = function()
        pcall(function()
            warnLbl.Visible = true
        end)
    end
    shared.__MeritSplashDismiss = function()
        pcall(function() if sg.Parent then sg:Destroy() end end)
        shared.__MeritSplashWarn = nil
        shared.__MeritSplashDismiss = nil
    end
end
local function __meritKillSplash()
    pcall(function() if shared.__MeritSplashDismiss then shared.__MeritSplashDismiss() end end)
    pcall(function()
        local __roots = {}
        if gethui then pcall(function() table.insert(__roots, gethui()) end) end
        pcall(function() table.insert(__roots, game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")) end)
        for _, __root in ipairs(__roots) do
            for _, __g in ipairs(__root:GetChildren()) do
                if __g.Name == "MeritLoader" then pcall(function() __g:Destroy() end) end
            end
        end
    end)
end
task.spawn(function()
    local __t0 = os.clock()
    while not shared.MeritInjected and (os.clock() - __t0) < 20 do task.wait(0.5) end
    task.wait(1)
    __meritKillSplash()
end)
local __meritOk, __meritErr = pcall(function()
    loadstring(game:HttpGet('https://usemerit.store/raw/prod/main.lua'))()
end)
__meritKillSplash()
if not __meritOk then warn("[Merit] main failed: " .. tostring(__meritErr)) end
