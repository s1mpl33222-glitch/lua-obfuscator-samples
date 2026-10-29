if not game:IsLoaded()then game.Loaded:Wait()end;do ("JNKIE Game Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local S,P,G={"6a738d69bfbf6714714cc37a11021c149c512e93db82b9c422ca99e0b686deb5","1dd3cab110476b9fa428c6658bd23b2f73fbd9942d4266364a3bede2c1c368a9","c28cd6e4b94fd4da60771aaf9cfc6c3a134e4b393cdaa1e09d42724d3384a6ec"},{},{[6061766680]=1,[10764627709]=2,[10769552054]=3};local i=P[game.PlaceId]or G[game.GameId];if not i then local h="Unsupported game or script is down!";warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="Ravine";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end);return end;--[[
    Ravine Key System - FREE
    UI im Stil der RavineUI
]]

local CONFIG = {
    Service     = "ravine",
    Identifier  = "1064771",
    Provider    = "ravine",
    KeyFile     = "verified_key.txt",
    Discord     = "https://discord.gg/get-ravine",
    Badge       = "FREE",
    BadgeColor  = Color3.fromRGB(46, 204, 113),
    Heading     = "Enter Key",
    Description = "Get your free key on our Discord, then paste it below.",
    Placeholder = "Paste your key here",
    VerifyText  = "Verify",
    Footer      = "Made by xaaaxaa/yen",
}

-- ============================================
-- KEY SYSTEM (UI im Stil der RavineUI)
-- ============================================
local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = CONFIG.Service
Junkie.identifier = CONFIG.Identifier
Junkie.provider = CONFIG.Provider

local result = (function()
    getgenv().UI_CLOSED = false
    getgenv().SCRIPT_KEY = nil

    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Lighting = game:GetService("Lighting")

    -- Gleiche Farben wie die RavineUI
    local Theme = {
        Background = Color3.fromRGB(10, 10, 13),
        Secondary = Color3.fromRGB(16, 16, 20),
        Tertiary = Color3.fromRGB(24, 24, 29),
        Border = Color3.fromRGB(42, 42, 50),
        Text = Color3.fromRGB(235, 235, 240),
        SubText = Color3.fromRGB(140, 140, 155),
        Accent = Color3.fromRGB(200, 30, 40),
        AccentHover = Color3.fromRGB(225, 48, 58),
        Success = Color3.fromRGB(46, 204, 113),
        Warning = Color3.fromRGB(236, 190, 60),
        Error = Color3.fromRGB(248, 81, 73),
        Font = Enum.Font.GothamMedium,
        FontBold = Enum.Font.GothamBold,
    }

    local LOGO_ASSET = "rbxassetid://128553373538203"
    local WIDTH, HEIGHT = 440, 284

    -- ============ KEY DATEI ============
    local function loadKey()
        if not (isfile and readfile) then
            return nil
        end
        local ok, content = pcall(function()
            if isfile(CONFIG.KeyFile) then
                return readfile(CONFIG.KeyFile)
            end
            return nil
        end)
        if ok and type(content) == "string" then
            content = content:gsub("%s+", "")
            if content ~= "" then
                return content
            end
        end
        return nil
    end

    local function saveKey(key)
        pcall(function()
            writefile(CONFIG.KeyFile, key)
        end)
    end

    local function delKey()
        pcall(function()
            if delfile and isfile and isfile(CONFIG.KeyFile) then
                delfile(CONFIG.KeyFile)
            end
        end)
    end

    -- ============ SCHON GESPEICHERTER KEY ============
    -- Wird vor dem Aufbau der UI geprueft, damit bei gueltigem Key gar nichts aufpoppt
    local saved = loadKey()
    if saved then
        local ok, r = pcall(Junkie.check_key, saved)
        if ok and r and r.valid then
            getgenv().SCRIPT_KEY = saved
            getgenv().UI_CLOSED = true
            return saved
        elseif ok then
            delKey() -- nur loeschen, wenn der Key wirklich ungueltig ist (nicht bei Verbindungsfehlern)
        end
    end

    -- ============ HELFER ============
    local function Create(className, props)
        local inst = Instance.new(className)
        local parent
        for k, v in pairs(props or {}) do
            if k == "Parent" then
                parent = v
            else
                inst[k] = v
            end
        end
        if parent then
            inst.Parent = parent
        end
        return inst
    end

    local function Corner(inst, radius)
        return Create("UICorner", { CornerRadius = UDim.new(0, radius or 6), Parent = inst })
    end

    local function Stroke(inst, color, thickness)
        return Create("UIStroke", {
            Color = color or Theme.Border,
            Thickness = thickness or 1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Parent = inst,
        })
    end

    local function Tween(inst, time, props)
        local t = TweenService:Create(inst, TweenInfo.new(time or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
        t:Play()
        return t
    end

    local function GetGuiParent()
        local ok, hui = pcall(function()
            return gethui and gethui()
        end)
        if ok and hui then
            return hui
        end
        return game:GetService("CoreGui")
    end

    -- Lucide-Icons (wie in der RavineUI), mit Fallback auf die alten Asset-IDs
    local IconModule
    pcall(function()
        local mod = loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/mstudio45/lucide-roblox-direct/refs/heads/main/source.lua"
        ))()
        if type(mod) == "table" then
            IconModule = mod
        end
    end)

    local FallbackAssets = {
        shield = 84528813312016,
        x = 73070135088117,
        key = 128426502701541,
        check = 83827110621355,
        link = 73034596791310,
    }

    local function NewIcon(parent, name, px, color, fallback)
        local img = Create("ImageLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(px, px),
            ImageColor3 = color,
            ScaleType = Enum.ScaleType.Fit,
            Parent = parent,
        })
        if IconModule and IconModule.GetAsset then
            local ok, data = pcall(IconModule.GetAsset, name)
            if ok and data then
                img.Image = data.Url
                img.ImageRectOffset = data.ImageRectOffset or Vector2.new(0, 0)
                img.ImageRectSize = data.ImageRectSize or Vector2.new(0, 0)
                return img
            end
        end
        local id = fallback and FallbackAssets[fallback]
        if id then
            img.Image = "rbxassetid://" .. tostring(id)
        end
        return img
    end

    -- ============ GUI ============
    local parent = GetGuiParent()
    pcall(function()
        local old = parent:FindFirstChild("RavineKeySystem")
        if old then
            old:Destroy()
        end
        for _, c in ipairs(Lighting:GetChildren()) do
            if c.Name == "RavineKeyBlur" then
                c:Destroy()
            end
        end
    end)

    local gui = Create("ScreenGui", {
        Name = "RavineKeySystem",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 1000,
        Parent = parent,
    })

    local backdrop = Create("Frame", {
        Name = "Backdrop",
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        Active = true,
        Parent = gui,
    })

    local blur
    pcall(function()
        blur = Create("BlurEffect", { Name = "RavineKeyBlur", Size = 0, Parent = Lighting })
        Tween(blur, 0.3, { Size = 12 })
    end)

    local main = Create("Frame", {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(WIDTH, HEIGHT),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0.04,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = backdrop,
    })
    Corner(main, 12)
    Stroke(main, Theme.Border, 1)

    local function fitScale()
        local cam = workspace.CurrentCamera
        if not cam then
            return 1
        end
        local vp = cam.ViewportSize
        local fit = math.min((vp.X - 24) / WIDTH, (vp.Y - 24) / HEIGHT)
        return math.clamp(math.min(1, fit), 0.5, 1)
    end

    local uiScale = Create("UIScale", { Scale = fitScale() * 0.94, Parent = main })

    local conns = {}
    local function track(c)
        table.insert(conns, c)
        return c
    end

    if workspace.CurrentCamera then
        track(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            uiScale.Scale = fitScale()
        end))
    end

    -- ============ TOPBAR ============
    local topBar = Create("Frame", {
        Name = "TopBar",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 46),
        Parent = main,
    })
    Create("Frame", {
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -1),
        Size = UDim2.new(1, 0, 0, 1),
        Parent = topBar,
    })

    Create("ImageLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 12, 0.5, 0),
        Size = UDim2.fromOffset(32, 32),
        Image = LOGO_ASSET,
        ScaleType = Enum.ScaleType.Fit,
        Parent = topBar,
    })

    local titleHolder = Create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 54, 0, 0),
        Size = UDim2.new(1, -100, 1, 0),
        Parent = topBar,
    })
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = titleHolder,
    })
    Create("TextLabel", {
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 0, 0, 20),
        LayoutOrder = 1,
        Font = Theme.FontBold,
        Text = "Ravine",
        TextColor3 = Theme.Text,
        TextSize = 15,
        Parent = titleHolder,
    })
    Create("TextLabel", {
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 0, 0, 20),
        LayoutOrder = 2,
        Font = Theme.Font,
        Text = "Key System",
        TextColor3 = Theme.SubText,
        TextSize = 12,
        Parent = titleHolder,
    })

    -- Edition-Badge (PAID / FREE)
    local badge = Create("Frame", {
        BackgroundColor3 = CONFIG.BadgeColor,
        BackgroundTransparency = 0.85,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 0, 0, 18),
        LayoutOrder = 3,
        Parent = titleHolder,
    })
    Corner(badge, 9)
    local badgeStroke = Stroke(badge, CONFIG.BadgeColor, 1)
    badgeStroke.Transparency = 0.5
    Create("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = badge })
    Create("TextLabel", {
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 0, 1, 0),
        Font = Theme.FontBold,
        Text = CONFIG.Badge,
        TextColor3 = CONFIG.BadgeColor,
        TextSize = 10,
        Parent = badge,
    })

    local closeBtn = Create("TextButton", {
        BackgroundColor3 = Theme.Tertiary,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.fromOffset(28, 28),
        Text = "",
        AutoButtonColor = false,
        Parent = topBar,
    })
    Corner(closeBtn, 8)
    local closeStroke = Stroke(closeBtn, Theme.Border, 1)
    local closeIcon = NewIcon(closeBtn, "x", 14, Theme.SubText, "x")
    closeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    closeIcon.Position = UDim2.fromScale(0.5, 0.5)
    closeBtn.MouseEnter:Connect(function()
        Tween(closeIcon, 0.15, { ImageColor3 = Theme.Text })
        Tween(closeStroke, 0.15, { Color = Theme.Accent })
    end)
    closeBtn.MouseLeave:Connect(function()
        Tween(closeIcon, 0.15, { ImageColor3 = Theme.SubText })
        Tween(closeStroke, 0.15, { Color = Theme.Border })
    end)

    -- ============ BODY ============
    local body = Create("Frame", {
        Name = "Body",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 46),
        Size = UDim2.new(1, 0, 1, -46),
        Parent = main,
    })
    Create("UIPadding", {
        PaddingTop = UDim.new(0, 16),
        PaddingBottom = UDim.new(0, 14),
        PaddingLeft = UDim.new(0, 16),
        PaddingRight = UDim.new(0, 16),
        Parent = body,
    })
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        Parent = body,
    })

    -- Ueberschrift + Beschreibung
    local head = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 50),
        LayoutOrder = 1,
        Parent = body,
    })
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Font = Theme.FontBold,
        Text = CONFIG.Heading,
        TextColor3 = Theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = head,
    })
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 23),
        Size = UDim2.new(1, 0, 0, 28),
        Font = Theme.Font,
        Text = CONFIG.Description,
        TextColor3 = Theme.SubText,
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = head,
    })

    -- Eingabefeld (im gleichen Stil wie die Zeilen der RavineUI)
    local inputHolder = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 42),
        LayoutOrder = 2,
        Parent = body,
    })
    local inputRow = Create("Frame", {
        BackgroundColor3 = Theme.Tertiary,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        ClipsDescendants = true,
        Parent = inputHolder,
    })
    Corner(inputRow, 6)
    local inputStroke = Stroke(inputRow, Theme.Border, 1)
    local keyIcon = NewIcon(inputRow, "key-round", 16, Theme.SubText, "key")
    keyIcon.AnchorPoint = Vector2.new(0, 0.5)
    keyIcon.Position = UDim2.new(0, 12, 0.5, 0)

    local keyInput = Create("TextBox", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 38, 0, 0),
        Size = UDim2.new(1, -50, 1, 0),
        Font = Theme.Font,
        Text = "",
        PlaceholderText = CONFIG.Placeholder,
        PlaceholderColor3 = Theme.SubText,
        TextColor3 = Theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = inputRow,
    })
    keyInput.Focused:Connect(function()
        Tween(inputStroke, 0.15, { Color = Theme.Accent })
        Tween(keyIcon, 0.15, { ImageColor3 = Theme.Accent })
    end)

    -- Status
    local status = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 16),
        LayoutOrder = 3,
        Font = Theme.Font,
        Text = "",
        TextColor3 = Theme.SubText,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = body,
    })

    -- Buttons (gleicher Stil wie Groupbox:AddButton)
    local buttonRow = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 38),
        LayoutOrder = 4,
        Parent = body,
    })
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = buttonRow,
    })

    local function MakeButton(text, iconName, fallback, primary, order)
        local base = primary and Theme.Accent or Theme.Tertiary
        local hover = primary and Theme.AccentHover or Theme.Accent
        local baseStroke = primary and Theme.Accent or Theme.Border
        local btn = Create("TextButton", {
            BackgroundColor3 = base,
            BorderSizePixel = 0,
            Size = UDim2.new(0.5, -4, 1, 0),
            LayoutOrder = order,
            Font = Theme.Font,
            Text = text,
            TextColor3 = primary and Color3.new(1, 1, 1) or Theme.Text,
            TextSize = 13,
            AutoButtonColor = false,
            Parent = buttonRow,
        })
        Corner(btn, 6)
        local strk = Stroke(btn, baseStroke, 1)
        local ic = NewIcon(btn, iconName, 16, primary and Color3.new(1, 1, 1) or Theme.Text, fallback)
        ic.Position = UDim2.new(0, 12, 0.5, -8)

        local function over()
            Tween(btn, 0.15, { BackgroundColor3 = hover })
            Tween(strk, 0.15, { Color = hover })
        end
        local function out()
            Tween(btn, 0.15, { BackgroundColor3 = base })
            Tween(strk, 0.15, { Color = baseStroke })
        end
        btn.MouseEnter:Connect(over)
        btn.MouseLeave:Connect(out)
        btn.MouseButton1Click:Connect(function()
            -- Auf Touch bleibt sonst der Hover-Zustand haengen
            if UserInputService.TouchEnabled then
                task.delay(0.15, out)
            end
        end)
        return btn
    end

    local getKeyBtn = MakeButton("Get Key", "copy", "link", false, 1)
    local verifyBtn = MakeButton(CONFIG.VerifyText, "shield-check", "shield", true, 2)

    -- Footer
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 14),
        LayoutOrder = 5,
        Font = Theme.Font,
        Text = CONFIG.Footer,
        TextColor3 = Theme.SubText,
        TextSize = 11,
        TextTransparency = 0.3,
        Parent = body,
    })

    -- ============ LOGIK ============
    local closed = false
    local function closeUI()
        if closed then
            return
        end
        closed = true
        getgenv().UI_CLOSED = true
        for _, c in ipairs(conns) do
            pcall(function()
                c:Disconnect()
            end)
        end
        pcall(function()
            Tween(uiScale, 0.15, { Scale = fitScale() * 0.94 })
            Tween(backdrop, 0.15, { BackgroundTransparency = 1 })
            if blur then
                Tween(blur, 0.15, { Size = 0 })
            end
        end)
        task.wait(0.15)
        pcall(function()
            gui:Destroy()
        end)
        if blur then
            pcall(function()
                blur:Destroy()
            end)
        end
    end

    local statusToken = 0
    local function setStatus(text, color, duration)
        statusToken = statusToken + 1
        local token = statusToken
        status.Text = text
        status.TextColor3 = color or Theme.SubText
        if duration and duration > 0 then
            task.delay(duration, function()
                if statusToken == token then
                    status.Text = ""
                end
            end)
        end
    end

    local function shake()
        for _ = 1, 3 do
            Tween(inputRow, 0.05, { Position = UDim2.fromOffset(-8, 0) })
            task.wait(0.05)
            Tween(inputRow, 0.05, { Position = UDim2.fromOffset(8, 0) })
            task.wait(0.05)
        end
        Tween(inputRow, 0.05, { Position = UDim2.fromOffset(0, 0) })
        Tween(inputStroke, 0.3, { Color = Theme.Error })
        task.delay(0.8, function()
            if keyInput:IsFocused() then
                Tween(inputStroke, 0.2, { Color = Theme.Accent })
            else
                Tween(inputStroke, 0.2, { Color = Theme.Border })
            end
        end)
    end

    local busy = false
    local function verify()
        if busy or closed then
            return
        end
        local key = (keyInput.Text:gsub("%s+", ""))
        if key == "" then
            setStatus("Please enter a key", Theme.Error, 3)
            task.spawn(shake)
            return
        end

        busy = true
        verifyBtn.Text = "Verifying..."
        setStatus("Verifying...", Theme.Warning, 0)

        local ok, r = pcall(Junkie.check_key, key)
        verifyBtn.Text = CONFIG.VerifyText

        if ok and r and r.valid then
            saveKey(key)
            getgenv().SCRIPT_KEY = key
            setStatus("Key verified!", Theme.Success, 0)
            task.wait(0.5)
            closeUI()
            return
        elseif not ok then
            setStatus("Connection error - please try again", Theme.Error, 4)
        else
            setStatus("Invalid key", Theme.Error, 3)
            task.spawn(shake)
        end
        busy = false
    end

    verifyBtn.MouseButton1Click:Connect(verify)

    keyInput.FocusLost:Connect(function(enterPressed)
        if not busy then
            Tween(inputStroke, 0.15, { Color = Theme.Border })
        end
        Tween(keyIcon, 0.15, { ImageColor3 = Theme.SubText })
        if enterPressed then
            verify()
        end
    end)

    getKeyBtn.MouseButton1Click:Connect(function()
        local copy = setclipboard or toclipboard or set_clipboard
        if copy then
            local ok = pcall(copy, CONFIG.Discord)
            if ok then
                setStatus("Discord link copied! Join for your key.", Theme.Success, 4)
                return
            end
        end
        setStatus("Couldn't copy - " .. CONFIG.Discord, Theme.Warning, 6)
    end)

    closeBtn.MouseButton1Click:Connect(closeUI)

    -- ============ VERSCHIEBEN (bleibt immer im Bild) ============
    do
        local dragging = false
        local mouseStart, centerStart, szStart
        topBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                mouseStart = Vector2.new(input.Position.X, input.Position.Y)
                szStart = main.AbsoluteSize
                centerStart = main.AbsolutePosition + szStart / 2
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        track(UserInputService.InputChanged:Connect(function(input)
            if dragging and mouseStart and (input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch) then
                local c = centerStart + (Vector2.new(input.Position.X, input.Position.Y) - mouseStart)
                local ps = gui.AbsoluteSize
                if ps.X < 1 or ps.Y < 1 then
                    return
                end
                local hx, hy = szStart.X / 2, szStart.Y / 2
                local x = (szStart.X >= ps.X) and ps.X / 2 or math.clamp(c.X, hx, ps.X - hx)
                local y = (szStart.Y >= ps.Y) and ps.Y / 2 or math.clamp(c.Y, hy, ps.Y - hy)
                main.Position = UDim2.fromScale(x / ps.X, y / ps.Y)
            end
        end))
    end

    -- ============ EINBLENDEN ============
    Tween(uiScale, 0.2, { Scale = fitScale() })
    Tween(backdrop, 0.25, { BackgroundTransparency = 0.45 })

    while not getgenv().UI_CLOSED do
        task.wait(0.1)
    end
    return getgenv().SCRIPT_KEY
end)()
do local k=getgenv().SCRIPT_KEY or SCRIPT_KEY or"";if type(k)~="string"then k=""end;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table"and type(syn.request)=="function"and syn.request)or(type(request)=="function"and request)or(type(http_request)=="function"and http_request)or(type(http)=="table"and type(http.request)=="function"and http.request);if type(r)~="function"then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/"..S[i].."?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table"and type(x.Body)=="string"and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"then warn(m);return end;if not (string.sub(x.Body,1,8)=="https://")then warn(m);return end;a,x=q({Url=x.Body,Method="GET"});if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function"then warn(m);return end;f()end end