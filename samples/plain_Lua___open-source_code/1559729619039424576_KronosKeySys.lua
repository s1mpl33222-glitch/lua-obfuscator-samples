local Loader = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer

local Theme = {
    Ink = Color3.fromRGB(6, 8, 13),
    InkSoft = Color3.fromRGB(11, 13, 20),
    Panel = Color3.fromRGB(12, 14, 21),
    PanelDeep = Color3.fromRGB(7, 9, 14),
    PanelBlue = Color3.fromRGB(22, 28, 44),
    Text = Color3.fromRGB(238, 240, 250),
    TextDim = Color3.fromRGB(135, 141, 160),
    TextMuted = Color3.fromRGB(78, 84, 104),
    Line = Color3.fromRGB(57, 62, 83),
    LineSoft = Color3.fromRGB(35, 39, 55),
    Accent = Color3.fromRGB(149, 159, 255),
    AccentHot = Color3.fromRGB(180, 188, 255),
    AccentDeep = Color3.fromRGB(95, 107, 188),
    Success = Color3.fromRGB(112, 229, 170),
    Error = Color3.fromRGB(255, 103, 123),
    Warning = Color3.fromRGB(255, 207, 120),
}

local TweenInfoSet = {
    Open = TweenInfo.new(0.52, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Close = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
    Soft = TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Fast = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Toast = TweenInfo.new(0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    ToastOut = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
}

local State = {
    Destroyed = false,
    Open = true,
    Validating = false,
    Title = "KRONOS",
    Version = "",
    KeyLink = "https://imphub.vercel.app/GetKeyAccess",
    ValidateCallback = nil,
    ExpiryToken = 0,
    Connections = {},
    Tweens = {},
    Toasts = {},
    ToastQueue = {},
    ScaleTarget = 1,
    Center = nil,
    WasDragged = false,
    LoadingTick = 0,
    ScriptLoaderActive = false,
    ScriptLoaderTransitioning = false,
    ScriptLoaderConnection = nil,
    ValidationToken = 0,
    ModalCopyUrl = DISCORD_CONTACT_URL,
    DiscordModalOpen = false,
    DiscordModalClosing = false,
    Drag = {
        Active = false,
        Input = nil,
        StartPointer = Vector2.zero,
        StartCenter = Vector2.zero,
        TargetCenter = Vector2.zero,
        CurrentCenter = Vector2.zero,
        Velocity = Vector2.zero,
        LastPointer = Vector2.zero,
        LastTime = 0,
    },
}

local UI = {}
local BASE_SIZE = Vector2.new(980, 582)
local SAFE_PAD = 18
local DISCORD_CONTACT_URL = "dsc.gg/kronoshub"
local PURCHASE_ACCESS_URL = "https://funpay.com/lots/offer?id=40879132"

local function connect(signal, callback)
    local connection = signal:Connect(callback)
    State.Connections[#State.Connections + 1] = connection
    return connection
end

local function disconnect(connection)
    if connection then
        pcall(function()
            connection:Disconnect()
        end)
    end
end

local function new(className, props)
    local object = Instance.new(className)
    for key, value in pairs(props or {}) do
        if key ~= "Parent" then
            object[key] = value
        end
    end
    if props and props.Parent then
        object.Parent = props.Parent
    end
    return object
end

local function corner(parent, radius)
    return new("UICorner", {
        CornerRadius = UDim.new(0, radius),
        Parent = parent,
    })
end

local function stroke(parent, color, thickness, transparency)
    return new("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = color,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        Parent = parent,
    })
end

local function gradient(parent, colorSequence, rotation, transparency)
    return new("UIGradient", {
        Color = colorSequence,
        Rotation = rotation or 0,
        Transparency = transparency or NumberSequence.new(0),
        Parent = parent,
    })
end

local function canTouchInstance(object)
    if State.Destroyed or not object then
        return false
    end
    local ok, parent = pcall(function()
        return object.Parent
    end)
    return ok and parent ~= nil
end

local function setProperty(object, key, value)
    return pcall(function()
        object[key] = value
    end)
end

local function tween(object, info, properties)
    if not canTouchInstance(object) then
        return nil
    end

    local ok, created = pcall(function()
        return TweenService:Create(object, info, properties)
    end)
    if ok and created then
        State.Tweens[#State.Tweens + 1] = created
        local started = pcall(function()
            created.Completed:Once(function()
                local index = table.find(State.Tweens, created)
                if index then
                    table.remove(State.Tweens, index)
                end
            end)
            created:Play()
        end)
        if started then
            return created
        end
        local index = table.find(State.Tweens, created)
        if index then
            table.remove(State.Tweens, index)
        end
        pcall(function()
            created:Cancel()
        end)
    end

    for key, value in pairs(properties) do
        setProperty(object, key, value)
    end
    return nil
end

local function cancelTween(tweenObject)
    if tweenObject then
        pcall(function()
            tweenObject:Cancel()
        end)
    end
end

local function getViewport()
    local camera = workspace.CurrentCamera
    if camera and camera.ViewportSize.X > 0 and camera.ViewportSize.Y > 0 then
        return camera.ViewportSize
    end
    if UI.Root and UI.Root.AbsoluteSize.X > 0 and UI.Root.AbsoluteSize.Y > 0 then
        return UI.Root.AbsoluteSize
    end
    return Vector2.new(1920, 1080)
end

local function clampCenter(center)
    return Vector2.new(center.X, center.Y)
end

local function applyWindowPosition(center)
    State.Center = clampCenter(center)
    State.Drag.CurrentCenter = State.Center
    State.Drag.TargetCenter = State.Center
    if UI.WindowHost then
        UI.WindowHost.Position = UDim2.fromOffset(State.Center.X, State.Center.Y)
    end
end

local function updateScale()
    if not UI.WindowScale then
        return
    end

    local viewport = getViewport()
    local pad = UserInputService.TouchEnabled and 12 or 32
    local usableX = math.max(viewport.X - pad * 2, 240)
    local usableY = math.max(viewport.Y - pad * 2, 180)
    local maxScale = UserInputService.TouchEnabled and not UserInputService.MouseEnabled and 0.94 or 1
    local scale = math.min(usableX / BASE_SIZE.X, usableY / BASE_SIZE.Y, maxScale)
    State.ScaleTarget = math.clamp(scale, 0.285, maxScale)
    UI.WindowScale.Scale = State.ScaleTarget

    if not State.Center or not State.WasDragged then
        applyWindowPosition(Vector2.new(viewport.X * 0.5, viewport.Y * 0.5))
    else
        applyWindowPosition(State.Center)
    end
end

local function setParent(screenGui)
    local parented = pcall(function()
        screenGui.Parent = game:GetService("CoreGui")
    end)
    if parented then
        return
    end

    local playerGui = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not playerGui and LocalPlayer then
        playerGui = LocalPlayer:WaitForChild("PlayerGui", 8)
    end
    if playerGui then
        parented = pcall(function()
            screenGui.Parent = playerGui
        end)
    end
    if not parented then
        pcall(function()
            screenGui.Parent = game:GetService("CoreGui")
        end)
    end
end

local function buildNoise(parent, zIndex, dotCount)
    local layer = new("Frame", {
        Name = "Noise Layer",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = zIndex,
        Parent = parent,
    })
    corner(layer, 12)

    for index = 1, dotCount do
        local x = ((index * 47) % 997) / 997
        local y = ((index * 83) % 991) / 991
        local alpha = 0.9 + (((index * 19) % 7) * 0.01)
        new("Frame", {
            Name = "NoiseDot",
            Size = UDim2.fromOffset(1, 1),
            Position = UDim2.fromScale(x, y),
            BackgroundColor3 = index % 3 == 0 and Color3.new(0, 0, 0) or Color3.new(1, 1, 1),
            BackgroundTransparency = alpha,
            BorderSizePixel = 0,
            ZIndex = zIndex,
            Parent = layer,
        })
    end

    return layer
end

local function createAcrylic(parent, zIndex, radius, tint, tintTransparency)
    local depth = new("Frame", {
        Name = "Depth Layer",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(0, 1, 4),
        BackgroundTransparency = 0.36,
        BorderSizePixel = 0,
        ZIndex = zIndex,
        Parent = parent,
    })
    corner(depth, radius)
    gradient(
        depth,
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 18, 28)),
            ColorSequenceKeypoint.new(0.55, Color3.fromRGB(6, 8, 13)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(1, 2, 5)),
        }),
        90,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(0.55, 0.03),
            NumberSequenceKeypoint.new(1, 0.16),
        })
    )

    local glassTint = new("Frame", {
        Name = "Glass Tint Layer",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = tint or Theme.Panel,
        BackgroundTransparency = tintTransparency or 0.72,
        BorderSizePixel = 0,
        ZIndex = zIndex + 1,
        Parent = parent,
    })
    corner(glassTint, radius)

    local diffusion = new("Frame", {
        Name = "Light Diffusion Layer",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Theme.PanelBlue,
        BackgroundTransparency = 0.88,
        BorderSizePixel = 0,
        ZIndex = zIndex + 2,
        Parent = parent,
    })
    corner(diffusion, radius)
    gradient(
        diffusion,
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(62, 72, 100)),
            ColorSequenceKeypoint.new(0.42, Color3.fromRGB(18, 22, 34)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 7, 13)),
        }),
        26,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.62),
            NumberSequenceKeypoint.new(0.45, 0.91),
            NumberSequenceKeypoint.new(1, 0.78),
        })
    )

    local ambient = new("Frame", {
        Name = "Ambient Lighting Layer",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Theme.AccentDeep,
        BackgroundTransparency = 0.94,
        BorderSizePixel = 0,
        ZIndex = zIndex + 3,
        Parent = parent,
    })
    corner(ambient, radius)
    gradient(
        ambient,
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(117, 126, 190)),
            ColorSequenceKeypoint.new(0.48, Color3.fromRGB(20, 24, 38)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 8, 14)),
        }),
        -38,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.72),
            NumberSequenceKeypoint.new(0.5, 0.97),
            NumberSequenceKeypoint.new(1, 0.88),
        })
    )

    local materialGradient = new("Frame", {
        Name = "Gradient Layer",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(19, 23, 34),
        BackgroundTransparency = 0.84,
        BorderSizePixel = 0,
        ZIndex = zIndex + 4,
        Parent = parent,
    })
    corner(materialGradient, radius)
    gradient(
        materialGradient,
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(43, 51, 76)),
            ColorSequenceKeypoint.new(0.34, Color3.fromRGB(10, 13, 22)),
            ColorSequenceKeypoint.new(0.7, Color3.fromRGB(4, 6, 11)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(21, 25, 39)),
        }),
        118,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.66),
            NumberSequenceKeypoint.new(0.4, 0.92),
            NumberSequenceKeypoint.new(1, 0.72),
        })
    )

    local noise = buildNoise(parent, zIndex + 5, 168)

    local reflection = new("Frame", {
        Name = "Reflection Layer",
        Size = UDim2.new(1, 0, 0.42, 0),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.93,
        BorderSizePixel = 0,
        ZIndex = zIndex + 6,
        Parent = parent,
    })
    corner(reflection, radius)
    gradient(
        reflection,
        ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(148, 160, 220)),
        90,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.74),
            NumberSequenceKeypoint.new(0.42, 0.96),
            NumberSequenceKeypoint.new(1, 1),
        })
    )

    local edgeHighlight = new("Frame", {
        Name = "Edge Highlight Layer",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = zIndex + 7,
        Parent = parent,
    })
    corner(edgeHighlight, radius)
    local edgeStroke = stroke(edgeHighlight, Color3.fromRGB(185, 195, 230), 1, 0.78)
    edgeStroke.Name = "EdgeHighlightStroke"

    local border = stroke(parent, Color3.fromRGB(82, 90, 120), 1, 0.56)
    border.Name = "Border Layer"

    return {
        Background = depth,
        Depth = depth,
        Tint = glassTint,
        GlassTint = glassTint,
        Blur = diffusion,
        LightDiffusion = diffusion,
        AmbientLighting = ambient,
        Gradient = materialGradient,
        Noise = noise,
        Reflection = reflection,
        Highlight = edgeHighlight,
        EdgeHighlight = edgeHighlight,
        Glow = ambient,
        Border = border,
    }
end

local function clearChildren(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
end

local function buildWordmark(parent, text, options)
    local holder = new("Frame", {
        Name = options.Name or "Wordmark",
        Size = options.Size,
        Position = options.Position,
        AnchorPoint = options.AnchorPoint or Vector2.zero,
        BackgroundTransparency = 1,
        ZIndex = options.ZIndex,
        Parent = parent,
    })

    local layout = new("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = options.HorizontalAlignment or Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, options.Padding or 10),
        Parent = holder,
    })

    local function render(newText)
        clearChildren(holder)
        layout.Parent = holder
        local order = 0
        for index = 1, #newText do
            local char = string.sub(newText, index, index)
            order += 1
            if char == " " then
                new("Frame", {
                    Name = "Gap",
                    Size = UDim2.fromOffset(options.SpaceWidth or 10, 1),
                    BackgroundTransparency = 1,
                    LayoutOrder = order,
                    ZIndex = options.ZIndex,
                    Parent = holder,
                })
            else
                local accentStart = math.max(2, math.floor(#newText * 0.42))
                local accentEnd = math.min(#newText, accentStart + 2)
                new("TextLabel", {
                    Name = "Letter_" .. char,
                    Size = UDim2.fromOffset(options.LetterWidth or 24, options.TextSize + 8),
                    BackgroundTransparency = 1,
                    Text = string.upper(char),
                    TextColor3 = index >= accentStart and index <= accentEnd and Theme.AccentHot or Theme.Text,
                    TextTransparency = options.TextTransparency or 0,
                    TextSize = options.TextSize,
                    Font = options.Font or Enum.Font.GothamMedium,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextYAlignment = Enum.TextYAlignment.Center,
                    LayoutOrder = order,
                    ZIndex = options.ZIndex,
                    Parent = holder,
                })
            end
        end
    end

    render(text)
    return holder, render
end

local function letterSpaced(text)
    local parts = {}
    for index = 1, #text do
        parts[#parts + 1] = string.sub(text, index, index)
    end
    return table.concat(parts, "  ")
end

local function createTinyUserIcon(parent, zIndex)
    local holder = new("Frame", {
        Name = "UserIcon",
        Size = UDim2.fromOffset(24, 24),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -15, 0.5, 0),
        BackgroundTransparency = 1,
        ZIndex = zIndex,
        Parent = parent,
    })
    local head = new("Frame", {
        Size = UDim2.fromOffset(8, 8),
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromOffset(12, 5),
        BackgroundColor3 = Theme.TextMuted,
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        ZIndex = zIndex,
        Parent = holder,
    })
    corner(head, 8)
    local body = new("Frame", {
        Size = UDim2.fromOffset(15, 7),
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromOffset(12, 20),
        BackgroundColor3 = Theme.TextMuted,
        BackgroundTransparency = 0.48,
        BorderSizePixel = 0,
        ZIndex = zIndex,
        Parent = holder,
    })
    corner(body, 7)
    return holder
end

local function createTinyKeyIcon(parent, zIndex)
    local holder = new("Frame", {
        Name = "KeyIcon",
        Size = UDim2.fromOffset(24, 24),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -15, 0.5, 0),
        BackgroundTransparency = 1,
        ZIndex = zIndex,
        Rotation = -25,
        Parent = parent,
    })
    local ring = new("Frame", {
        Size = UDim2.fromOffset(9, 9),
        Position = UDim2.fromOffset(4, 7),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = zIndex,
        Parent = holder,
    })
    corner(ring, 9)
    stroke(ring, Theme.TextMuted, 2, 0.35)
    local stem = new("Frame", {
        Size = UDim2.fromOffset(11, 2),
        Position = UDim2.fromOffset(12, 11),
        BackgroundColor3 = Theme.TextMuted,
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        ZIndex = zIndex,
        Parent = holder,
    })
    corner(stem, 2)
    new("Frame", {
        Size = UDim2.fromOffset(2, 5),
        Position = UDim2.fromOffset(19, 12),
        BackgroundColor3 = Theme.TextMuted,
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        ZIndex = zIndex,
        Parent = holder,
    })
    return holder
end

local function setStatus(kind, message)
    if not UI.StatusText then
        return
    end
    local color = Theme.TextDim
    local lineTransparency = kind == "idle" and 0.74 or 0.5
    if kind == "success" then
        color = Color3.fromRGB(202, 208, 236)
        lineTransparency = 0.54
    elseif kind == "error" then
        color = Color3.fromRGB(205, 198, 224)
        lineTransparency = 0.48
    elseif kind == "loading" then
        color = Color3.fromRGB(204, 211, 250)
        lineTransparency = 0.44
    elseif kind == "warning" then
        color = Color3.fromRGB(205, 198, 224)
        lineTransparency = 0.48
    end
    setProperty(UI.StatusText, "Text", message or "Status")
    setProperty(UI.StatusText, "TextColor3", color)
    if UI.StatusLine then
        tween(UI.StatusLine, TweenInfoSet.Soft, { BackgroundColor3 = color, BackgroundTransparency = lineTransparency })
    end
end

local function setInputLocked(locked)
    if UI.KeyBox then
        pcall(function()
            UI.KeyBox.TextEditable = not locked
        end)
        setProperty(UI.KeyBox, "Active", not locked)
    end
    if UI.ValidateButton then
        setProperty(UI.ValidateButton, "Active", not locked)
    end
    if UI.GetKeyButton then
        setProperty(UI.GetKeyButton, "Active", not locked)
    end
end

local function setLoadingMessage(message)
    if UI.ValidationLoadingText then
        setProperty(UI.ValidationLoadingText, "Text", letterSpaced(message or "Validating Access"))
    end
end

local function startLoadingVisual(message)
    State.LoadingTick = 0
    setLoadingMessage(message)
    if UI.StatusText then
        tween(UI.StatusText, TweenInfoSet.Fast, { TextTransparency = 1 })
    end
    if UI.StatusLine then
        tween(UI.StatusLine, TweenInfoSet.Fast, { BackgroundTransparency = 1 })
    end
    if UI.ValidationOverlay then
        setProperty(UI.ValidationOverlay, "Visible", true)
        setProperty(UI.ValidationOverlay, "GroupTransparency", 1)
        tween(UI.ValidationOverlay, TweenInfoSet.Soft, { GroupTransparency = 0 })
    end
    if UI.ValidationOverlayScale then
        setProperty(UI.ValidationOverlayScale, "Scale", 0.94)
        tween(UI.ValidationOverlayScale, TweenInfoSet.Soft, { Scale = 1 })
    end
    if UI.ValidateLabel then
        setProperty(UI.ValidateLabel, "Text", "Validating")
    end
    disconnect(State.LoadingConnection)
    State.LoadingConnection = connect(RunService.RenderStepped, function(dt)
        State.LoadingTick += dt
        if UI.ValidationSpinner then
            setProperty(UI.ValidationSpinner, "Rotation", (State.LoadingTick * 178) % 360)
        end
        if UI.SpinnerSegments then
            for index, segment in ipairs(UI.SpinnerSegments) do
                local wave = (math.sin(State.LoadingTick * 7.2 + index * 0.7) + 1) * 0.5
                setProperty(segment, "BackgroundTransparency", 0.38 + wave * 0.42)
            end
        end
    end)
end
local function stopLoadingVisual()
    disconnect(State.LoadingConnection)
    State.LoadingConnection = nil
    if UI.ValidationOverlay then
        local overlay = UI.ValidationOverlay
        local outTween = tween(overlay, TweenInfoSet.Fast, { GroupTransparency = 1 })
        if outTween then
            pcall(function()
                outTween.Completed:Once(function()
                    if not State.Validating and canTouchInstance(overlay) then
                        setProperty(overlay, "Visible", false)
                    end
                end)
            end)
        else
            setProperty(overlay, "Visible", false)
        end
    end
    if UI.ValidationOverlayScale then
        tween(UI.ValidationOverlayScale, TweenInfoSet.Fast, { Scale = 0.96 })
    end
    if UI.ValidateLabel then
        setProperty(UI.ValidateLabel, "Text", "Validate")
    end
end
local function shake(object)
    if not object then
        return
    end
    local ok, original = pcall(function()
        return object.Position
    end)
    if not ok then
        return
    end
    task.spawn(function()
        for _, offset in ipairs({ -8, 8, -5, 5, 0 }) do
            if not canTouchInstance(object) then
                return
            end
            tween(object, TweenInfo.new(0.045, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = original + UDim2.fromOffset(offset, 0),
            })
            task.wait(0.045)
        end
        if canTouchInstance(object) then
            setProperty(object, "Position", original)
        end
    end)
end

local function getToastMetrics()
    local viewport = getViewport()
    local safeInset = GuiService:GetGuiInset()
    local width = math.clamp(viewport.X - 28, 280, 348)
    local height = 92
    local top = math.max(18, safeInset.Y + 14)
    local right = math.max(14, UserInputService.TouchEnabled and 16 or 24)
    return width, height, top, right
end

local function getToastPosition(index, offscreen)
    local width, height, top, right = getToastMetrics()
    local xOffset = offscreen and (width + 44) or -right
    return UDim2.new(1, xOffset, 0, top + (index - 1) * (height + 12))
end

local function reflowToasts()
    for index, toast in ipairs(State.Toasts) do
        if toast.Gui and toast.Gui.Parent then
            local width, height = getToastMetrics()
            toast.Gui.Size = UDim2.fromOffset(width, height)
            tween(toast.Gui, TweenInfoSet.Toast, {
                Position = getToastPosition(index, false),
            })
        end
    end
end

local function removeToast(toast)
    if toast.Removing then
        return
    end
    toast.Removing = true
    local foundIndex = table.find(State.Toasts, toast)
    if foundIndex then
        table.remove(State.Toasts, foundIndex)
    end
    if toast.ProgressTween then
        cancelTween(toast.ProgressTween)
        toast.ProgressTween = nil
    end
    if toast.Gui and toast.Gui.Parent then
        local outTween = tween(toast.Gui, TweenInfoSet.ToastOut, {
            Position = toast.Gui.Position + UDim2.fromOffset(34, -4),
            GroupTransparency = 1,
        })
        if toast.Scale then
            tween(toast.Scale, TweenInfoSet.ToastOut, { Scale = 0.975 })
        end
        if outTween then
            outTween.Completed:Once(function()
                if toast.Gui then
                    toast.Gui:Destroy()
                end
            end)
        else
            toast.Gui:Destroy()
        end
    end
    reflowToasts()

    local nextConfig = table.remove(State.ToastQueue, 1)
    if nextConfig then
        task.defer(function()
            Loader:Toast(nextConfig)
        end)
    end
end

local function toastColor(toastType)
    if toastType == "success" then
        return Color3.fromRGB(176, 235, 205), "✓"
    elseif toastType == "error" then
        return Color3.fromRGB(238, 176, 192), "!"
    elseif toastType == "warning" then
        return Color3.fromRGB(238, 210, 158), "!"
    elseif toastType == "loading" then
        return Color3.fromRGB(196, 205, 255), "…"
    end
    return Color3.fromRGB(196, 205, 255), "i"
end

local function createToastMaterial(parent, accent)
    local shadowLayer = new("Frame", {
        Name = "Shadow Layer",
        Size = UDim2.new(1, 18, 1, 20),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.55),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.76,
        BorderSizePixel = 0,
        ZIndex = 308,
        Parent = parent,
    })
    corner(shadowLayer, 24)
    gradient(
        shadowLayer,
        ColorSequence.new(Color3.fromRGB(0, 0, 0), accent),
        90,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.42),
            NumberSequenceKeypoint.new(0.58, 0.78),
            NumberSequenceKeypoint.new(1, 1),
        })
    )

    local card = new("CanvasGroup", {
        Name = "ToastCard",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(7, 9, 15),
        BackgroundTransparency = 0.34,
        GroupTransparency = 0,
        ClipsDescendants = true,
        BorderSizePixel = 0,
        ZIndex = 310,
        Parent = parent,
    })
    corner(card, 18)

    local backgroundLayer = new("Frame", {
        Name = "Background Layer",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(4, 6, 11),
        BackgroundTransparency = 0.34,
        BorderSizePixel = 0,
        ZIndex = 311,
        Parent = card,
    })
    corner(backgroundLayer, 18)

    local tintLayer = new("Frame", {
        Name = "Tint Layer",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(13, 16, 26),
        BackgroundTransparency = 0.42,
        BorderSizePixel = 0,
        ZIndex = 312,
        Parent = card,
    })
    corner(tintLayer, 18)
    gradient(
        tintLayer,
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(31, 36, 54)),
            ColorSequenceKeypoint.new(0.46, Color3.fromRGB(11, 14, 24)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 6, 12)),
        }),
        18,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.62),
            NumberSequenceKeypoint.new(0.55, 0.76),
            NumberSequenceKeypoint.new(1, 0.68),
        })
    )

    local noiseLayer = buildNoise(card, 313, 76)
    noiseLayer.Name = "Noise Layer"

    local reflectionLayer = new("Frame", {
        Name = "Reflection Layer",
        Size = UDim2.new(1, -18, 0.42, 0),
        Position = UDim2.fromOffset(9, 5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0,
        ZIndex = 314,
        Parent = card,
    })
    corner(reflectionLayer, 16)
    gradient(
        reflectionLayer,
        ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(160, 170, 220)),
        90,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.76),
            NumberSequenceKeypoint.new(0.48, 0.96),
            NumberSequenceKeypoint.new(1, 1),
        })
    )

    local highlightLayer = new("Frame", {
        Name = "Highlight Layer",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 315,
        Parent = card,
    })
    corner(highlightLayer, 18)
    local edge = stroke(highlightLayer, Color3.fromRGB(202, 210, 246), 1, 0.72)
    edge.Name = "Edge Highlight"

    local accentGlow = new("Frame", {
        Name = "Accent Glow",
        Size = UDim2.new(0, 70, 1, 18),
        Position = UDim2.fromOffset(-26, -9),
        BackgroundColor3 = accent,
        BackgroundTransparency = 0.86,
        BorderSizePixel = 0,
        ZIndex = 316,
        Parent = card,
    })
    corner(accentGlow, 36)
    gradient(
        accentGlow,
        ColorSequence.new(accent, Color3.fromRGB(8, 10, 16)),
        0,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.48),
            NumberSequenceKeypoint.new(0.66, 0.96),
            NumberSequenceKeypoint.new(1, 1),
        })
    )

    local borderLayer = stroke(card, Color3.fromRGB(95, 104, 136), 1, 0.52)
    borderLayer.Name = "Border Layer"

    return card
end
local function createButton(parent, name, text, position, size, primary, callback)
    local button = new("TextButton", {
        Name = name,
        Position = position,
        Size = size,
        AutoButtonColor = false,
        BackgroundColor3 = primary and Color3.fromRGB(183, 192, 255) or Color3.fromRGB(10, 13, 21),
        BackgroundTransparency = primary and 0.2 or 0.76,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Text = "",
        ZIndex = 48,
        Parent = parent,
    })
    corner(button, primary and 24 or 18)

    local glow = new("Frame", {
        Name = "Glow Layer",
        Size = primary and UDim2.new(1, 30, 1, 24) or UDim2.new(1, 12, 1, 10),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.56),
        BackgroundColor3 = primary and Color3.fromRGB(176, 190, 255) or Theme.AccentDeep,
        BackgroundTransparency = primary and 0.78 or 0.95,
        BorderSizePixel = 0,
        ZIndex = 45,
        Parent = button,
    })
    corner(glow, primary and 34 or 24)
    gradient(
        glow,
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(247, 247, 255)),
            ColorSequenceKeypoint.new(0.46, Color3.fromRGB(182, 190, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(126, 145, 230)),
        }),
        0,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, primary and 0.7 or 0.92),
            NumberSequenceKeypoint.new(0.48, primary and 0.34 or 0.82),
            NumberSequenceKeypoint.new(1, 1),
        })
    )

    local base = new("Frame", {
        Name = "Base Layer",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = primary and Color3.fromRGB(150, 163, 237) or Color3.fromRGB(8, 11, 18),
        BackgroundTransparency = primary and 0.1 or 0.78,
        BorderSizePixel = 0,
        ZIndex = 48,
        Parent = button,
    })
    corner(base, primary and 24 or 18)

    local gradientLayer = new("Frame", {
        Name = "Gradient Layer",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = primary and Color3.fromRGB(206, 211, 255) or Color3.fromRGB(12, 15, 24),
        BackgroundTransparency = primary and 0.02 or 0.74,
        BorderSizePixel = 0,
        ZIndex = 49,
        Parent = button,
    })
    corner(gradientLayer, primary and 24 or 18)
    gradient(
        gradientLayer,
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, primary and Color3.fromRGB(244, 244, 255) or Color3.fromRGB(20, 24, 36)),
            ColorSequenceKeypoint.new(0.18, primary and Color3.fromRGB(218, 222, 255) or Color3.fromRGB(16, 19, 30)),
            ColorSequenceKeypoint.new(0.58, primary and Color3.fromRGB(178, 187, 255) or Color3.fromRGB(11, 14, 23)),
            ColorSequenceKeypoint.new(1, primary and Color3.fromRGB(137, 157, 239) or Color3.fromRGB(6, 8, 14)),
        }),
        90,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, primary and 0.06 or 0.42),
            NumberSequenceKeypoint.new(0.44, primary and 0.01 or 0.24),
            NumberSequenceKeypoint.new(1, primary and 0.08 or 0.48),
        })
    )

    local highlight = new("Frame", {
        Name = "Highlight Layer",
        Size = UDim2.new(1, -18, 0, primary and 16 or 10),
        Position = UDim2.fromOffset(9, primary and 4 or 3),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = primary and 0.6 or 0.92,
        BorderSizePixel = 0,
        ZIndex = 50,
        Parent = button,
    })
    corner(highlight, primary and 16 or 12)
    gradient(
        highlight,
        ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(218, 224, 255)),
        90,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, primary and 0.34 or 0.86),
            NumberSequenceKeypoint.new(0.62, primary and 0.86 or 0.98),
            NumberSequenceKeypoint.new(1, 1),
        })
    )

    local reflection = new("Frame", {
        Name = "Reflection Layer",
        Size = UDim2.new(0.54, 0, 0.72, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0.08, 0.44),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = primary and 0.84 or 0.96,
        BorderSizePixel = 0,
        Rotation = -10,
        ZIndex = 51,
        Parent = button,
    })
    corner(reflection, primary and 24 or 18)
    gradient(
        reflection,
        ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(185, 196, 255)),
        0,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, primary and 0.7 or 0.96),
            NumberSequenceKeypoint.new(0.38, primary and 0.88 or 1),
            NumberSequenceKeypoint.new(1, 1),
        })
    )

    local edgeLight = new("Frame", {
        Name = "Edge Light Layer",
        Size = UDim2.new(1, -4, 1, -4),
        Position = UDim2.fromOffset(2, 2),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 52,
        Parent = button,
    })
    corner(edgeLight, primary and 22 or 16)
    local edgeStroke = stroke(edgeLight, Color3.fromRGB(252, 253, 255), 1, primary and 0.54 or 0.88)
    edgeStroke.Name = "EdgeLightStroke"

    local borderStroke =
        stroke(button, primary and Color3.fromRGB(224, 229, 255) or Theme.Line, 1, primary and 0.28 or 0.72)
    borderStroke.Name = "Border Layer"
    local scale = new("UIScale", { Scale = 1, Parent = button })

    local label = new("TextLabel", {
        Name = "Label",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = primary and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(185, 193, 240),
        TextTransparency = primary and 0.04 or 0.2,
        Font = Enum.Font.GothamMedium,
        TextSize = primary and 15 or 13,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 55,
        Parent = button,
    })

    local arrow = new("TextLabel", {
        Name = "Arrow",
        Size = UDim2.fromOffset(28, 20),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -88, 0.5, 0),
        BackgroundTransparency = 1,
        Text = "→",
        TextColor3 = primary and Color3.fromRGB(255, 255, 255) or Theme.AccentHot,
        TextTransparency = primary and 0.16 or 0.38,
        Font = Enum.Font.GothamMedium,
        TextSize = primary and 22 or 16,
        ZIndex = 55,
        Parent = button,
    })
    if not primary then
        arrow.Visible = false
    end

    connect(button.MouseEnter, function()
        if not button.Active then
            return
        end
        tween(scale, TweenInfoSet.Fast, { Scale = 1.015 })
        tween(glow, TweenInfoSet.Fast, { BackgroundTransparency = primary and 0.68 or 0.9 })
        tween(highlight, TweenInfoSet.Fast, { BackgroundTransparency = primary and 0.52 or 0.9 })
        tween(reflection, TweenInfoSet.Fast, { BackgroundTransparency = primary and 0.78 or 0.94 })
        tween(edgeStroke, TweenInfoSet.Fast, { Transparency = primary and 0.38 or 0.78 })
        tween(borderStroke, TweenInfoSet.Fast, { Transparency = primary and 0.16 or 0.54 })
    end)
    connect(button.MouseLeave, function()
        tween(scale, TweenInfoSet.Fast, { Scale = 1 })
        tween(glow, TweenInfoSet.Fast, { BackgroundTransparency = primary and 0.78 or 0.95 })
        tween(highlight, TweenInfoSet.Fast, { BackgroundTransparency = primary and 0.6 or 0.92 })
        tween(reflection, TweenInfoSet.Fast, { BackgroundTransparency = primary and 0.84 or 0.96 })
        tween(edgeStroke, TweenInfoSet.Fast, { Transparency = primary and 0.54 or 0.88 })
        tween(borderStroke, TweenInfoSet.Fast, { Transparency = primary and 0.28 or 0.72 })
    end)
    connect(button.MouseButton1Down, function()
        if button.Active then
            tween(scale, TweenInfoSet.Fast, { Scale = 0.978 })
            tween(glow, TweenInfoSet.Fast, { BackgroundTransparency = primary and 0.74 or 0.94 })
            tween(gradientLayer, TweenInfoSet.Fast, { BackgroundTransparency = primary and 0.07 or 0.78 })
        end
    end)
    connect(button.MouseButton1Up, function()
        if button.Active then
            tween(scale, TweenInfoSet.Fast, { Scale = 1.008 })
            tween(glow, TweenInfoSet.Fast, { BackgroundTransparency = primary and 0.7 or 0.9 })
            tween(gradientLayer, TweenInfoSet.Fast, { BackgroundTransparency = primary and 0.02 or 0.74 })
        end
    end)
    connect(button.MouseButton1Click, callback)

    return button, label
end

local function copyDiscordLink()
    local copied = false
    pcall(function()
        if typeof(setclipboard) == "function" then
            setclipboard(State.ModalCopyUrl or DISCORD_CONTACT_URL)
            copied = true
        elseif typeof(toclipboard) == "function" then
            toclipboard(State.ModalCopyUrl or DISCORD_CONTACT_URL)
            copied = true
        end
    end)

    if copied then
        Loader:Toast({
            Type = "success",
            Icon = "shield-check",
            Title = "Link Copied",
            Subtitle = State.ModalCopyUrl or DISCORD_CONTACT_URL,
            Duration = 3,
        })
    else
        Loader:Toast({
            Type = "warning",
            Icon = "info",
            Title = "Copy Link",
            Subtitle = State.ModalCopyUrl or DISCORD_CONTACT_URL,
            Duration = 5,
        })
    end
end

local function createModalCopyGlyph(parent, zIndex)
    local glyph = new("Frame", {
        Name = "CopyGlyph",
        Size = UDim2.fromOffset(22, 22),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = zIndex,
        Parent = parent,
    })

    local backSheet = new("Frame", {
        Name = "BackSheet",
        Size = UDim2.fromOffset(10, 12),
        Position = UDim2.fromOffset(4, 3),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = zIndex,
        Parent = glyph,
    })
    corner(backSheet, 4)
    local backStroke = stroke(backSheet, Color3.fromRGB(214, 224, 255), 1, 0.74)

    local frontSheet = new("Frame", {
        Name = "FrontSheet",
        Size = UDim2.fromOffset(11, 13),
        Position = UDim2.fromOffset(8, 7),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = zIndex + 1,
        Parent = glyph,
    })
    corner(frontSheet, 4)
    local frontStroke = stroke(frontSheet, Color3.fromRGB(230, 237, 255), 1, 0.68)

    local check = new("Frame", {
        Name = "CheckGlyph",
        Size = UDim2.fromOffset(22, 22),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = zIndex + 2,
        Parent = glyph,
    })

    local checkA = new("Frame", {
        Name = "CheckA",
        Size = UDim2.fromOffset(7, 2),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(8, 13),
        BackgroundColor3 = Color3.fromRGB(226, 240, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Rotation = 42,
        ZIndex = zIndex + 2,
        Parent = check,
    })
    corner(checkA, 2)

    local checkB = new("Frame", {
        Name = "CheckB",
        Size = UDim2.fromOffset(12, 2),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(14, 10),
        BackgroundColor3 = Color3.fromRGB(226, 240, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Rotation = -42,
        ZIndex = zIndex + 2,
        Parent = check,
    })
    corner(checkB, 2)

    return {
        Root = glyph,
        Strokes = { backStroke, frontStroke },
        Check = { checkA, checkB },
    }
end

local function setModalCopyGlyphHover(hovered)
    if not UI.DiscordModalCopyIcon then
        return
    end
    local icon = UI.DiscordModalCopyIcon
    tween(icon.Button, TweenInfoSet.Fast, {
        Position = hovered and UDim2.new(1, -35, 0.5, 0) or UDim2.new(1, -30, 0.5, 0),
    })
    tween(icon.Scale, TweenInfoSet.Fast, { Scale = hovered and 1 or 0.95 })
    tween(icon.Glow, TweenInfoSet.Fast, { BackgroundTransparency = hovered and 0.84 or 0.98 })
    for _, line in ipairs(icon.Glyph.Strokes) do
        tween(line, TweenInfoSet.Fast, {
            Color = hovered and Color3.fromRGB(244, 248, 255) or Color3.fromRGB(214, 224, 255),
            Transparency = hovered and 0.08 or 0.72,
        })
    end
end

local function playDiscordCopyFeedback()
    if not UI.DiscordModalFieldStroke then
        return
    end

    tween(UI.DiscordModalFieldStroke, TweenInfoSet.Fast, {
        Color = Color3.fromRGB(135, 165, 255),
        Transparency = 0.12,
    })
    if UI.DiscordModalFieldGlow then
        tween(UI.DiscordModalFieldGlow, TweenInfoSet.Fast, { BackgroundTransparency = 0.72 })
    end
    if UI.DiscordModalCopyIcon then
        local glyph = UI.DiscordModalCopyIcon.Glyph
        for _, line in ipairs(glyph.Strokes) do
            tween(line, TweenInfoSet.Fast, { Transparency = 1 })
        end
        for _, line in ipairs(glyph.Check) do
            tween(line, TweenInfoSet.Fast, { BackgroundTransparency = 0 })
        end
    end

    task.delay(0.72, function()
        if State.Destroyed or not UI.DiscordModalFieldStroke or not UI.DiscordModalFieldStroke.Parent then
            return
        end
        tween(UI.DiscordModalFieldStroke, TweenInfoSet.Soft, {
            Color = Color3.fromRGB(86, 96, 132),
            Transparency = 0.58,
        })
        if UI.DiscordModalFieldGlow then
            tween(UI.DiscordModalFieldGlow, TweenInfoSet.Soft, { BackgroundTransparency = 0.92 })
        end
        if UI.DiscordModalCopyIcon then
            local glyph = UI.DiscordModalCopyIcon.Glyph
            for _, line in ipairs(glyph.Strokes) do
                tween(line, TweenInfoSet.Soft, { Transparency = 0.72 })
            end
            for _, line in ipairs(glyph.Check) do
                tween(line, TweenInfoSet.Soft, { BackgroundTransparency = 1 })
            end
        end
    end)
end

local function copyDiscordFromModal()
    copyDiscordLink()
    playDiscordCopyFeedback()
end

local function createModalButton(parent, name, text, position, primary, callback)
    local button = new("TextButton", {
        Name = name,
        Size = UDim2.fromOffset(166, 44),
        Position = position,
        AutoButtonColor = false,
        BackgroundColor3 = primary and Color3.fromRGB(206, 214, 255) or Color3.fromRGB(13, 16, 25),
        BackgroundTransparency = primary and 0.08 or 0.4,
        BorderSizePixel = 0,
        Text = "",
        ZIndex = 244,
        Parent = parent,
    })
    corner(button, 15)

    local scale = new("UIScale", { Scale = 1, Parent = button })
    local glow = new("Frame", {
        Name = "ButtonGlow",
        Size = UDim2.new(1, 20, 1, 18),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.55),
        BackgroundColor3 = primary and Color3.fromRGB(143, 161, 255) or Color3.fromRGB(78, 93, 155),
        BackgroundTransparency = primary and 0.78 or 0.96,
        BorderSizePixel = 0,
        ZIndex = 242,
        Parent = button,
    })
    corner(glow, 21)
    gradient(
        glow,
        ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(88, 112, 220)),
        16,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.52),
            NumberSequenceKeypoint.new(0.46, 0.78),
            NumberSequenceKeypoint.new(1, 1),
        })
    )

    local body = new("Frame", {
        Name = "MaterialBody",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = primary and Color3.fromRGB(219, 224, 255) or Color3.fromRGB(13, 16, 25),
        BackgroundTransparency = primary and 0.05 or 0.36,
        BorderSizePixel = 0,
        ZIndex = 245,
        Parent = button,
    })
    corner(body, 15)
    gradient(
        body,
        primary
                and ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(250, 249, 255)),
                    ColorSequenceKeypoint.new(0.46, Color3.fromRGB(205, 212, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(169, 191, 255)),
                })
            or ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 35, 52)),
                ColorSequenceKeypoint.new(0.52, Color3.fromRGB(12, 15, 24)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 9, 15)),
            }),
        90,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, primary and 0.02 or 0.2),
            NumberSequenceKeypoint.new(0.55, primary and 0.05 or 0.02),
            NumberSequenceKeypoint.new(1, primary and 0.12 or 0.22),
        })
    )

    local highlight = new("Frame", {
        Name = "GlassHighlight",
        Size = UDim2.new(1, -18, 0, 15),
        Position = UDim2.fromOffset(9, 5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = primary and 0.52 or 0.9,
        BorderSizePixel = 0,
        ZIndex = 246,
        Parent = button,
    })
    corner(highlight, 13)
    gradient(
        highlight,
        ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(180, 193, 255)),
        90,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.35),
            NumberSequenceKeypoint.new(0.55, 0.92),
            NumberSequenceKeypoint.new(1, 1),
        })
    )

    local border = stroke(
        button,
        primary and Color3.fromRGB(245, 247, 255) or Color3.fromRGB(85, 93, 126),
        1,
        primary and 0.32 or 0.6
    )
    local label = new("TextLabel", {
        Name = "Label",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = primary and Color3.fromRGB(17, 22, 40) or Theme.Text,
        TextTransparency = primary and 0.03 or 0.08,
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 248,
        Parent = button,
    })

    connect(button.MouseEnter, function()
        tween(scale, TweenInfoSet.Fast, { Scale = 1.012 })
        tween(glow, TweenInfoSet.Fast, { BackgroundTransparency = primary and 0.62 or 0.86 })
        tween(body, TweenInfoSet.Fast, { BackgroundTransparency = primary and 0.02 or 0.28 })
        tween(highlight, TweenInfoSet.Fast, { BackgroundTransparency = primary and 0.42 or 0.82 })
        tween(border, TweenInfoSet.Fast, { Transparency = primary and 0.18 or 0.42 })
    end)
    connect(button.MouseLeave, function()
        tween(scale, TweenInfoSet.Fast, { Scale = 1 })
        tween(glow, TweenInfoSet.Fast, { BackgroundTransparency = primary and 0.78 or 0.96 })
        tween(body, TweenInfoSet.Fast, { BackgroundTransparency = primary and 0.05 or 0.36 })
        tween(highlight, TweenInfoSet.Fast, { BackgroundTransparency = primary and 0.52 or 0.9 })
        tween(border, TweenInfoSet.Fast, { Transparency = primary and 0.32 or 0.6 })
    end)
    connect(button.MouseButton1Down, function()
        tween(scale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 0.97 })
    end)
    connect(button.MouseButton1Up, function()
        tween(scale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1.012 })
    end)
    connect(button.MouseButton1Click, callback)

    return button, label
end

local function closeDiscordModal()
    if not State.DiscordModalOpen or State.DiscordModalClosing then
        return
    end
    State.DiscordModalClosing = true

    if UI.DiscordModalBackdrop then
        tween(UI.DiscordModalBackdrop, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
        })
    end
    if UI.DiscordModalCard then
        tween(UI.DiscordModalCard, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            GroupTransparency = 1,
        })
    end
    if UI.DiscordModalScale then
        tween(
            UI.DiscordModalScale,
            TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
            { Scale = 0.92 }
        )
    end

    task.delay(0.24, function()
        if State.Destroyed then
            return
        end
        if UI.DiscordModalBackdrop then
            UI.DiscordModalBackdrop.Visible = false
        end
        State.DiscordModalOpen = false
        State.DiscordModalClosing = false
    end)
end

local function createDiscordModal(parent)
    local backdrop = new("Frame", {
        Name = "DiscordModalBackdrop",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(1, 2, 6),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 210,
        Parent = parent,
    })

    local outside = new("TextButton", {
        Name = "OutsideDismissLayer",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        Text = "",
        ZIndex = 211,
        Parent = backdrop,
    })

    local shadow = new("Frame", {
        Name = "ModalShadow",
        Size = UDim2.fromOffset(452, 318),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.515),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.46,
        BorderSizePixel = 0,
        ZIndex = 214,
        Parent = backdrop,
    })
    corner(shadow, 28)
    gradient(
        shadow,
        ColorSequence.new(Color3.fromRGB(75, 85, 145), Color3.fromRGB(0, 0, 0)),
        90,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.9),
            NumberSequenceKeypoint.new(0.48, 0.36),
            NumberSequenceKeypoint.new(1, 0.78),
        })
    )

    local card = new("CanvasGroup", {
        Name = "DiscordModalCard",
        Size = UDim2.fromOffset(420, 286),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.49),
        BackgroundColor3 = Theme.Panel,
        BackgroundTransparency = 1,
        GroupTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 220,
        Parent = backdrop,
    })
    corner(card, 18)
    createAcrylic(card, 220, 18, Color3.fromRGB(13, 17, 27), 0.48)
    local cardBorder = stroke(card, Color3.fromRGB(95, 105, 145), 1, 0.48)
    UI.DiscordModalScale = new("UIScale", { Scale = 0.92, Parent = card })

    local title = new("TextLabel", {
        Name = "DiscordTitle",
        Size = UDim2.fromOffset(352, 34),
        Position = UDim2.fromOffset(34, 28),
        BackgroundTransparency = 1,
        Text = "Discord",
        TextColor3 = Theme.Text,
        TextTransparency = 0.02,
        Font = Enum.Font.GothamSemibold,
        TextSize = 25,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 236,
        Parent = card,
    })

    local description = new("TextLabel", {
        Name = "ModalDescription",
        Size = UDim2.fromOffset(352, 38),
        Position = UDim2.fromOffset(34, 60),
        BackgroundTransparency = 1,
        Text = "Join Kronos support, updates, and announcements.",
        TextColor3 = Theme.TextDim,
        TextTransparency = 0.16,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 236,
        Parent = card,
    })

    local badge = new("TextLabel", {
        Name = "OfficialStoreBadge",
        Size = UDim2.fromOffset(108, 24),
        Position = UDim2.fromOffset(278, 32),
        BackgroundColor3 = Color3.fromRGB(84, 101, 190),
        BackgroundTransparency = 0.74,
        BorderSizePixel = 0,
        Text = "Official Store",
        TextColor3 = Color3.fromRGB(224, 230, 255),
        TextTransparency = 0.06,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        Visible = false,
        ZIndex = 238,
        Parent = card,
    })
    corner(badge, 999)
    stroke(badge, Color3.fromRGB(156, 174, 255), 1, 0.66)

    local pricingCards = {}
    local function createPlanCard(name, x, plan, price, detail)
        local planCard = new("Frame", {
            Name = name,
            Size = UDim2.fromOffset(169, 72),
            Position = UDim2.fromOffset(x, 112),
            BackgroundColor3 = Color3.fromRGB(8, 11, 18),
            BackgroundTransparency = 0.34,
            BorderSizePixel = 0,
            Visible = false,
            ZIndex = 237,
            Parent = card,
        })
        corner(planCard, 16)
        stroke(planCard, Color3.fromRGB(112, 126, 188), 1, 0.58)
        gradient(
            planCard,
            ColorSequence.new(Color3.fromRGB(28, 33, 54), Color3.fromRGB(6, 8, 14)),
            90,
            NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.12),
                NumberSequenceKeypoint.new(1, 0.28),
            })
        )
        new("TextLabel", {
            Name = "Plan",
            Size = UDim2.fromOffset(130, 20),
            Position = UDim2.fromOffset(14, 10),
            BackgroundTransparency = 1,
            Text = plan,
            TextColor3 = Theme.Text,
            TextTransparency = 0.04,
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 239,
            Parent = planCard,
        })
        new("TextLabel", {
            Name = "Price",
            Size = UDim2.fromOffset(130, 22),
            Position = UDim2.fromOffset(14, 29),
            BackgroundTransparency = 1,
            Text = price,
            TextColor3 = Color3.fromRGB(225, 231, 255),
            TextTransparency = 0.02,
            Font = Enum.Font.GothamSemibold,
            TextSize = 17,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 239,
            Parent = planCard,
        })
        new("TextLabel", {
            Name = "Detail",
            Size = UDim2.fromOffset(140, 16),
            Position = UDim2.fromOffset(14, 52),
            BackgroundTransparency = 1,
            Text = detail,
            TextColor3 = Theme.TextDim,
            TextTransparency = 0.16,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 239,
            Parent = planCard,
        })
        pricingCards[#pricingCards + 1] = planCard
    end
    createPlanCard("MonthlyPlan", 34, "Monthly", "$5 USD", "Flexible access")
    createPlanCard("LifetimePlan", 217, "Lifetime", "$10 USD", "One-time unlock")

    local trustText = new("TextLabel", {
        Name = "PurchaseTrustText",
        Size = UDim2.fromOffset(352, 18),
        Position = UDim2.fromOffset(34, 270),
        BackgroundTransparency = 1,
        Text = "Secure checkout through the official Kronos storefront.",
        TextColor3 = Theme.TextDim,
        TextTransparency = 0.22,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Visible = false,
        ZIndex = 238,
        Parent = card,
    })

    local field = new("Frame", {
        Name = "DiscordLinkField",
        Size = UDim2.fromOffset(352, 58),
        Position = UDim2.fromOffset(34, 112),
        BackgroundColor3 = Color3.fromRGB(8, 11, 18),
        BackgroundTransparency = 0.34,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 235,
        Parent = card,
    })
    corner(field, 16)
    gradient(
        field,
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(31, 36, 55)),
            ColorSequenceKeypoint.new(0.55, Color3.fromRGB(9, 12, 20)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 7, 12)),
        }),
        90,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.18),
            NumberSequenceKeypoint.new(0.55, 0.04),
            NumberSequenceKeypoint.new(1, 0.2),
        })
    )

    local fieldGlow = new("Frame", {
        Name = "FieldBlueGlow",
        Size = UDim2.fromOffset(376, 76),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(210, 141),
        BackgroundColor3 = Color3.fromRGB(100, 130, 255),
        BackgroundTransparency = 0.92,
        BorderSizePixel = 0,
        ZIndex = 233,
        Parent = card,
    })
    corner(fieldGlow, 22)
    gradient(
        fieldGlow,
        ColorSequence.new(Color3.fromRGB(180, 196, 255), Color3.fromRGB(58, 78, 170)),
        0,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.42),
            NumberSequenceKeypoint.new(0.5, 0.76),
            NumberSequenceKeypoint.new(1, 1),
        })
    )

    local innerLight = new("Frame", {
        Name = "FieldInnerLight",
        Size = UDim2.new(1, -12, 0, 14),
        Position = UDim2.fromOffset(6, 5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0,
        ZIndex = 237,
        Parent = field,
    })
    corner(innerLight, 12)
    gradient(
        innerLight,
        ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(167, 184, 255)),
        90,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.64),
            NumberSequenceKeypoint.new(0.58, 0.96),
            NumberSequenceKeypoint.new(1, 1),
        })
    )

    local linkText = new("TextLabel", {
        Name = "LinkText",
        Size = UDim2.new(1, -82, 1, 0),
        Position = UDim2.fromOffset(20, 0),
        BackgroundTransparency = 1,
        Text = State.ModalCopyUrl or DISCORD_CONTACT_URL,
        TextColor3 = Color3.fromRGB(217, 224, 250),
        TextTransparency = 0.08,
        Font = Enum.Font.GothamMedium,
        TextSize = 16,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 240,
        Parent = field,
    })

    local copyButton = new("TextButton", {
        Name = "CopyIconButton",
        Size = UDim2.fromOffset(34, 34),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(1, -30, 0.5, 0),
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        Text = "",
        ZIndex = 242,
        Parent = field,
    })
    local copyScale = new("UIScale", { Scale = 0.95, Parent = copyButton })
    local copyGlow = new("Frame", {
        Name = "CopyIconGlow",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(116, 143, 255),
        BackgroundTransparency = 0.98,
        BorderSizePixel = 0,
        ZIndex = 241,
        Parent = copyButton,
    })
    corner(copyGlow, 12)
    local copyGlyph = createModalCopyGlyph(copyButton, 244)

    local fieldStroke = stroke(field, Color3.fromRGB(86, 96, 132), 1, 0.58)
    fieldStroke.Name = "InputFieldStroke"

    connect(field.MouseEnter, function()
        setModalCopyGlyphHover(true)
        tween(fieldStroke, TweenInfoSet.Fast, { Transparency = 0.38, Color = Color3.fromRGB(105, 116, 157) })
        tween(field, TweenInfoSet.Fast, { BackgroundTransparency = 0.28 })
    end)
    connect(field.MouseLeave, function()
        setModalCopyGlyphHover(false)
        tween(fieldStroke, TweenInfoSet.Fast, { Transparency = 0.58, Color = Color3.fromRGB(86, 96, 132) })
        tween(field, TweenInfoSet.Fast, { BackgroundTransparency = 0.34 })
    end)
    connect(copyButton.MouseButton1Click, copyDiscordFromModal)

    local copyAction, copyActionLabel =
        createModalButton(card, "CopyButton", "Copy", UDim2.fromOffset(34, 210), true, copyDiscordFromModal)
    local closeAction =
        createModalButton(card, "CloseButton", "Close", UDim2.fromOffset(220, 210), false, closeDiscordModal)

    connect(outside.MouseButton1Click, closeDiscordModal)

    UI.DiscordModalBackdrop = backdrop
    UI.DiscordModalShadow = shadow
    UI.DiscordModalCard = card
    UI.DiscordModalField = field
    UI.DiscordModalFieldStroke = fieldStroke
    UI.DiscordModalFieldGlow = fieldGlow
    UI.DiscordModalTitle = title
    UI.DiscordModalDescription = description
    UI.DiscordModalBadge = badge
    UI.DiscordModalPricingCards = pricingCards
    UI.DiscordModalTrustText = trustText
    UI.DiscordModalCopyAction = copyAction
    UI.DiscordModalCopyActionLabel = copyActionLabel
    UI.DiscordModalCloseAction = closeAction
    UI.DiscordModalLinkText = linkText
    UI.DiscordModalCopyIcon = {
        Button = copyButton,
        Scale = copyScale,
        Glow = copyGlow,
        Glyph = copyGlyph,
    }

    return backdrop, card, cardBorder, title, linkText
end

local function openLinkModal(title, url, description, purchaseMode)
    if State.Destroyed or State.DiscordModalClosing then
        return
    end
    if not UI.DiscordModalBackdrop or not UI.DiscordModalBackdrop.Parent then
        if not UI.Window then
            return
        end
        createDiscordModal(UI.Window)
    end
    State.ModalCopyUrl = tostring(url or DISCORD_CONTACT_URL)
    local isPurchase = purchaseMode == true
    if UI.DiscordModalTitle then
        UI.DiscordModalTitle.Text = tostring(title or "Link")
    end
    if UI.DiscordModalDescription then
        UI.DiscordModalDescription.Text = tostring(description or "Copy this Kronos link when you need it.")
    end
    if UI.DiscordModalLinkText then
        UI.DiscordModalLinkText.Text = State.ModalCopyUrl
    end
    if UI.DiscordModalBadge then
        UI.DiscordModalBadge.Visible = isPurchase
    end
    if UI.DiscordModalTrustText then
        UI.DiscordModalTrustText.Visible = isPurchase
    end
    if UI.DiscordModalPricingCards then
        for _, planCard in ipairs(UI.DiscordModalPricingCards) do
            planCard.Visible = isPurchase
        end
    end
    if UI.DiscordModalShadow then
        UI.DiscordModalShadow.Size = isPurchase and UDim2.fromOffset(452, 388) or UDim2.fromOffset(452, 318)
    end
    if UI.DiscordModalCard then
        UI.DiscordModalCard.Size = isPurchase and UDim2.fromOffset(420, 356) or UDim2.fromOffset(420, 286)
    end
    if UI.DiscordModalDescription then
        UI.DiscordModalDescription.Size = isPurchase and UDim2.fromOffset(240, 44) or UDim2.fromOffset(352, 38)
    end
    if UI.DiscordModalField then
        UI.DiscordModalField.Position = isPurchase and UDim2.fromOffset(34, 204) or UDim2.fromOffset(34, 112)
    end
    if UI.DiscordModalFieldGlow then
        UI.DiscordModalFieldGlow.Position = isPurchase and UDim2.fromOffset(210, 233) or UDim2.fromOffset(210, 141)
    end
    if UI.DiscordModalCopyAction then
        UI.DiscordModalCopyAction.Position = isPurchase and UDim2.fromOffset(34, 292) or UDim2.fromOffset(34, 210)
    end
    if UI.DiscordModalCopyActionLabel then
        UI.DiscordModalCopyActionLabel.Text = isPurchase and "Copy Store Link" or "Copy"
    end
    if UI.DiscordModalCloseAction then
        UI.DiscordModalCloseAction.Position = isPurchase and UDim2.fromOffset(220, 292) or UDim2.fromOffset(220, 210)
    end
    if State.DiscordModalOpen then
        return
    end

    State.DiscordModalOpen = true
    UI.DiscordModalBackdrop.Visible = true
    UI.DiscordModalBackdrop.BackgroundTransparency = 1
    UI.DiscordModalCard.GroupTransparency = 1
    UI.DiscordModalScale.Scale = 0.92
    if UI.DiscordModalFieldStroke then
        UI.DiscordModalFieldStroke.Color = Color3.fromRGB(86, 96, 132)
        UI.DiscordModalFieldStroke.Transparency = 0.58
    end
    setModalCopyGlyphHover(false)

    tween(UI.DiscordModalBackdrop, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.42,
    })
    tween(UI.DiscordModalCard, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        GroupTransparency = 0,
    })
    tween(UI.DiscordModalScale, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1,
    })
end

local function openDiscordModal()
    openLinkModal("Discord", DISCORD_CONTACT_URL, "Join Kronos support, updates, and announcements.")
end

local function openPurchaseModal()
    openLinkModal("Purchase Access", PURCHASE_ACCESS_URL, "Unlock Kronos with a plan that fits your grind.", true)
end

local function createScriptLoader(parent)
    local loader = new("CanvasGroup", {
        Name = "ScriptLoader",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Theme.Ink,
        BackgroundTransparency = 0,
        GroupTransparency = 1,
        Visible = false,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 170,
        Parent = parent,
    })
    corner(loader, 12)
    UI.ScriptLoaderScale = new("UIScale", { Scale = 0.965, Parent = loader })

    local backdrop = new("Frame", {
        Name = "Backdrop",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(2, 3, 6),
        BorderSizePixel = 0,
        ZIndex = 171,
        Parent = loader,
    })
    UI.ScriptLoaderBackdropGradient = gradient(
        backdrop,
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 12, 19)),
            ColorSequenceKeypoint.new(0.46, Color3.fromRGB(4, 5, 9)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(1, 2, 4)),
        }),
        124,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.04),
            NumberSequenceKeypoint.new(0.55, 0),
            NumberSequenceKeypoint.new(1, 0.06),
        })
    )

    local ambientGlow = new("Frame", {
        Name = "AmbientGlow",
        Size = UDim2.fromOffset(560, 220),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.23),
        BackgroundColor3 = Color3.fromRGB(83, 90, 120),
        BackgroundTransparency = 0.965,
        BorderSizePixel = 0,
        ZIndex = 172,
        Parent = loader,
    })
    corner(ambientGlow, 999)
    gradient(
        ambientGlow,
        ColorSequence.new(Color3.fromRGB(128, 136, 174), Color3.fromRGB(42, 47, 67)),
        0,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.82),
            NumberSequenceKeypoint.new(0.5, 0.58),
            NumberSequenceKeypoint.new(1, 1),
        })
    )
    UI.ScriptLoaderAmbientGlow = ambientGlow

    local surface = new("Frame", {
        Name = "LaunchSurface",
        Size = UDim2.fromOffset(650, 424),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(490, 291),
        BackgroundColor3 = Color3.fromRGB(5, 6, 10),
        BackgroundTransparency = 0.12,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 173,
        Parent = loader,
    })
    corner(surface, 24)
    gradient(
        surface,
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 14, 21)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(5, 6, 10)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(2, 3, 6)),
        }),
        116,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.08),
            NumberSequenceKeypoint.new(0.58, 0),
            NumberSequenceKeypoint.new(1, 0.06),
        })
    )
    UI.ScriptLoaderSurface = surface
    UI.ScriptLoaderSurfaceStroke = stroke(surface, Color3.fromRGB(42, 46, 60), 1, 0.54)

    local surfaceHighlight = new("Frame", {
        Name = "SurfaceHighlight",
        Size = UDim2.new(1, -54, 0, 1),
        Position = UDim2.fromOffset(27, 1),
        BackgroundColor3 = Color3.fromRGB(154, 161, 190),
        BackgroundTransparency = 0.82,
        BorderSizePixel = 0,
        ZIndex = 175,
        Parent = surface,
    })
    gradient(
        surfaceHighlight,
        ColorSequence.new(Color3.fromRGB(112, 119, 151), Color3.fromRGB(205, 210, 229)),
        0,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0.18),
            NumberSequenceKeypoint.new(1, 1),
        })
    )

    local scanLine = new("Frame", {
        Name = "SurfaceScan",
        Size = UDim2.fromOffset(96, 422),
        Position = UDim2.fromOffset(-110, 1),
        BackgroundColor3 = Color3.fromRGB(132, 139, 164),
        BackgroundTransparency = 0.965,
        BorderSizePixel = 0,
        ZIndex = 176,
        Parent = surface,
    })
    gradient(
        scanLine,
        ColorSequence.new(Color3.fromRGB(84, 90, 113), Color3.fromRGB(176, 181, 199)),
        0,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0.54),
            NumberSequenceKeypoint.new(1, 1),
        })
    )
    UI.ScriptLoaderScanLine = scanLine

    for index, x in ipairs({ 24, 606 }) do
        local edge = new("Frame", {
            Name = "CornerDetail" .. index,
            Size = UDim2.fromOffset(20, 1),
            Position = UDim2.fromOffset(x, 21),
            BackgroundColor3 = Color3.fromRGB(88, 94, 116),
            BackgroundTransparency = 0.58,
            BorderSizePixel = 0,
            ZIndex = 177,
            Parent = surface,
        })
        gradient(
            edge,
            ColorSequence.new(Color3.fromRGB(56, 61, 78), Color3.fromRGB(122, 128, 150)),
            index == 1 and 0 or 180,
            NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 0.08),
            })
        )
    end

    local badge = new("TextLabel", {
        Name = "Badge",
        Size = UDim2.fromOffset(134, 24),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(490, 82),
        BackgroundColor3 = Color3.fromRGB(10, 12, 18),
        BackgroundTransparency = 0.18,
        BorderSizePixel = 0,
        Text = letterSpaced("SECURE SESSION"),
        TextColor3 = Color3.fromRGB(153, 159, 181),
        TextTransparency = 0.08,
        Font = Enum.Font.GothamMedium,
        TextSize = 10,
        ZIndex = 180,
        Parent = loader,
    })
    corner(badge, 999)
    stroke(badge, Color3.fromRGB(59, 64, 82), 1, 0.48)
    UI.ScriptLoaderBadge = badge

    local wordmark, renderWordmark = buildWordmark(loader, State.Title, {
        Name = "LoaderWordmark",
        Size = UDim2.fromOffset(400, 50),
        Position = UDim2.fromOffset(490, 146),
        AnchorPoint = Vector2.new(0.5, 0.5),
        TextSize = 29,
        LetterWidth = 23,
        Padding = 12,
        SpaceWidth = 16,
        ZIndex = 181,
    })
    UI.ScriptLoaderWordmark = wordmark
    UI.RenderScriptLoaderWordmark = renderWordmark

    UI.ScriptLoaderTitle = new("TextLabel", {
        Name = "Title",
        Size = UDim2.fromOffset(560, 44),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(490, 213),
        BackgroundTransparency = 1,
        Text = "Starting Script",
        TextColor3 = Color3.fromRGB(226, 229, 239),
        TextTransparency = 0.04,
        Font = Enum.Font.GothamSemibold,
        TextSize = 29,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 181,
        Parent = loader,
    })

    UI.ScriptLoaderSubtitle = new("TextLabel", {
        Name = "Subtitle",
        Size = UDim2.fromOffset(560, 24),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(490, 250),
        BackgroundTransparency = 1,
        Text = "Preparing your Kronos experience",
        TextColor3 = Color3.fromRGB(108, 113, 132),
        TextTransparency = 0.08,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 181,
        Parent = loader,
    })

    local progressGroup = new("CanvasGroup", {
        Name = "ProgressGroup",
        Size = UDim2.fromOffset(520, 82),
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromOffset(490, 292),
        BackgroundTransparency = 1,
        GroupTransparency = 0,
        ZIndex = 181,
        Parent = loader,
    })
    UI.ScriptLoaderProgressGroup = progressGroup

    local statusMark = new("Frame", {
        Name = "StatusSignal",
        Size = UDim2.fromOffset(14, 2),
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromOffset(0, 10),
        BackgroundColor3 = Color3.fromRGB(108, 115, 148),
        BackgroundTransparency = 0.14,
        BorderSizePixel = 0,
        ZIndex = 184,
        Parent = progressGroup,
    })
    corner(statusMark, 999)
    UI.ScriptLoaderStatusMark = statusMark

    UI.ScriptLoaderStatus = new("TextLabel", {
        Name = "Status",
        Size = UDim2.fromOffset(408, 20),
        Position = UDim2.fromOffset(24, 0),
        BackgroundTransparency = 1,
        Text = "Preparing secure runtime",
        TextColor3 = Color3.fromRGB(139, 145, 166),
        TextTransparency = 0.06,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 184,
        Parent = progressGroup,
    })

    UI.ScriptLoaderPercent = new("TextLabel", {
        Name = "Percent",
        Size = UDim2.fromOffset(58, 24),
        Position = UDim2.fromOffset(462, -2),
        BackgroundColor3 = Color3.fromRGB(9, 11, 16),
        BackgroundTransparency = 0.12,
        Text = "0%",
        TextColor3 = Color3.fromRGB(176, 181, 201),
        TextTransparency = 0.03,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 184,
        Parent = progressGroup,
    })
    corner(UI.ScriptLoaderPercent, 8)
    stroke(UI.ScriptLoaderPercent, Color3.fromRGB(50, 54, 69), 1, 0.5)

    local railGlow = new("Frame", {
        Name = "RailGlow",
        Size = UDim2.new(1, 12, 0, 20),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0, 42),
        BackgroundColor3 = Color3.fromRGB(86, 93, 122),
        BackgroundTransparency = 0.965,
        BorderSizePixel = 0,
        ZIndex = 181,
        Parent = progressGroup,
    })
    corner(railGlow, 999)
    UI.ScriptLoaderRailGlow = railGlow

    local rail = new("Frame", {
        Name = "ProgressRail",
        Size = UDim2.new(1, 0, 0, 7),
        Position = UDim2.fromOffset(0, 39),
        BackgroundColor3 = Color3.fromRGB(13, 15, 21),
        BackgroundTransparency = 0.04,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 182,
        Parent = progressGroup,
    })
    corner(rail, 999)
    stroke(rail, Color3.fromRGB(43, 47, 61), 1, 0.48)

    local fill = new("Frame", {
        Name = "ProgressFill",
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(111, 118, 150),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 184,
        Parent = rail,
    })
    corner(fill, 999)
    UI.ScriptLoaderFill = fill
    UI.ScriptLoaderFillGradient = gradient(
        fill,
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(61, 67, 89)),
            ColorSequenceKeypoint.new(0.46, Color3.fromRGB(104, 112, 145)),
            ColorSequenceKeypoint.new(0.68, Color3.fromRGB(176, 181, 203)),
            ColorSequenceKeypoint.new(0.78, Color3.fromRGB(112, 120, 154)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(72, 78, 103)),
        }),
        0,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.12),
            NumberSequenceKeypoint.new(0.58, 0.04),
            NumberSequenceKeypoint.new(1, 0.16),
        })
    )

    local fillHighlight = new("Frame", {
        Name = "FillHighlight",
        Size = UDim2.new(1, -4, 0, 1),
        Position = UDim2.fromOffset(2, 1),
        BackgroundColor3 = Color3.fromRGB(226, 229, 239),
        BackgroundTransparency = 0.72,
        BorderSizePixel = 0,
        ZIndex = 185,
        Parent = fill,
    })
    corner(fillHighlight, 999)

    UI.ScriptLoaderStageSegments = {}
    for index = 1, 4 do
        local segment = new("Frame", {
            Name = "Stage" .. index,
            Size = UDim2.fromOffset(118, 2),
            Position = UDim2.fromOffset((index - 1) * 134, 62),
            BackgroundColor3 = Color3.fromRGB(42, 46, 59),
            BackgroundTransparency = 0.42,
            BorderSizePixel = 0,
            ZIndex = 183,
            Parent = progressGroup,
        })
        corner(segment, 999)
        UI.ScriptLoaderStageSegments[index] = segment
    end

    local supportButton = new("TextButton", {
        Name = "DiscordSupport",
        Size = UDim2.fromOffset(382, 52),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(490, 448),
        BackgroundColor3 = Color3.fromRGB(4, 5, 8),
        BackgroundTransparency = 0.12,
        AutoButtonColor = false,
        Text = "",
        ZIndex = 182,
        Parent = loader,
    })
    corner(supportButton, 16)
    local supportStroke = stroke(supportButton, Color3.fromRGB(40, 44, 57), 1, 0.5)
    local supportScale = new("UIScale", { Scale = 1, Parent = supportButton })
    UI.ScriptLoaderSupportScale = supportScale

    local iconPlate = new("Frame", {
        Name = "DiscordIconPlate",
        Size = UDim2.fromOffset(34, 34),
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromOffset(10, 26),
        BackgroundColor3 = Color3.fromRGB(23, 26, 37),
        BackgroundTransparency = 0.08,
        BorderSizePixel = 0,
        ZIndex = 184,
        Parent = supportButton,
    })
    corner(iconPlate, 12)
    stroke(iconPlate, Color3.fromRGB(70, 76, 98), 1, 0.48)

    local sourceGlyph = UI.ContactDiscordButton and UI.ContactDiscordButton:FindFirstChild("DiscordGlyph", true)
    if sourceGlyph then
        local discordGlyph = sourceGlyph:Clone()
        discordGlyph.Size = UDim2.fromOffset(19, 16)
        discordGlyph.Position = UDim2.fromScale(0.5, 0.5)
        discordGlyph.Parent = iconPlate
        for _, descendant in ipairs(discordGlyph:GetDescendants()) do
            if descendant:IsA("GuiObject") then
                descendant.ZIndex = 186
            end
        end
        discordGlyph.ZIndex = 186
    end

    new("TextLabel", {
        Name = "Question",
        Size = UDim2.fromOffset(112, 22),
        Position = UDim2.fromOffset(58, 15),
        BackgroundTransparency = 1,
        Text = "Having issues?",
        TextColor3 = Color3.fromRGB(104, 109, 126),
        TextTransparency = 0.04,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 184,
        Parent = supportButton,
    })

    local joinLabel = new("TextLabel", {
        Name = "JoinDiscord",
        Size = UDim2.fromOffset(104, 22),
        Position = UDim2.fromOffset(169, 15),
        BackgroundTransparency = 1,
        Text = "Join Discord",
        TextColor3 = Color3.fromRGB(141, 150, 195),
        TextTransparency = 0.03,
        Font = Enum.Font.GothamSemibold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 184,
        Parent = supportButton,
    })

    local underline = new("Frame", {
        Name = "LinkUnderline",
        Size = UDim2.fromOffset(76, 1),
        Position = UDim2.fromOffset(169, 37),
        BackgroundColor3 = Color3.fromRGB(126, 136, 181),
        BackgroundTransparency = 0.34,
        BorderSizePixel = 0,
        ZIndex = 184,
        Parent = supportButton,
    })
    corner(underline, 999)
    gradient(underline, ColorSequence.new(Color3.fromRGB(77, 84, 115), Color3.fromRGB(158, 166, 204)), 0)

    local arrow = new("TextLabel", {
        Name = "Arrow",
        Size = UDim2.fromOffset(30, 22),
        Position = UDim2.fromOffset(342, 15),
        BackgroundTransparency = 1,
        Text = "↗",
        TextColor3 = Color3.fromRGB(112, 119, 148),
        TextTransparency = 0.12,
        Font = Enum.Font.GothamSemibold,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 184,
        Parent = supportButton,
    })

    connect(supportButton.MouseEnter, function()
        tween(supportScale, TweenInfoSet.Fast, { Scale = 1.012 })
        tween(supportButton, TweenInfoSet.Fast, { BackgroundColor3 = Color3.fromRGB(8, 9, 14) })
        tween(supportStroke, TweenInfoSet.Fast, { Color = Color3.fromRGB(73, 79, 101), Transparency = 0.34 })
        tween(iconPlate, TweenInfoSet.Fast, { BackgroundColor3 = Color3.fromRGB(31, 35, 48) })
        tween(joinLabel, TweenInfoSet.Fast, { TextColor3 = Color3.fromRGB(174, 181, 211) })
        tween(underline, TweenInfoSet.Fast, { Size = UDim2.fromOffset(104, 1), BackgroundTransparency = 0.12 })
        tween(arrow, TweenInfoSet.Fast, { Position = UDim2.fromOffset(345, 12), TextTransparency = 0.02 })
    end)
    connect(supportButton.MouseLeave, function()
        tween(supportScale, TweenInfoSet.Fast, { Scale = 1 })
        tween(supportButton, TweenInfoSet.Fast, { BackgroundColor3 = Color3.fromRGB(4, 5, 8) })
        tween(supportStroke, TweenInfoSet.Fast, { Color = Color3.fromRGB(40, 44, 57), Transparency = 0.5 })
        tween(iconPlate, TweenInfoSet.Fast, { BackgroundColor3 = Color3.fromRGB(23, 26, 37) })
        tween(joinLabel, TweenInfoSet.Fast, { TextColor3 = Color3.fromRGB(141, 150, 195) })
        tween(underline, TweenInfoSet.Fast, { Size = UDim2.fromOffset(76, 1), BackgroundTransparency = 0.34 })
        tween(arrow, TweenInfoSet.Fast, { Position = UDim2.fromOffset(342, 15), TextTransparency = 0.12 })
    end)
    connect(supportButton.MouseButton1Down, function()
        tween(supportScale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 0.975 })
    end)
    connect(supportButton.MouseButton1Up, function()
        tween(supportScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1.012 })
    end)
    connect(supportButton.MouseButton1Click, openDiscordModal)

    UI.ScriptLoader = loader
    UI.ScriptLoaderSupportButton = supportButton
    return loader
end

local function showScriptLoader()
    if State.Destroyed or State.ScriptLoaderActive then
        return
    end
    if not UI.ScriptLoader then
        Loader:Close()
        return
    end

    State.ScriptLoaderActive = true
    disconnect(State.ScriptLoaderConnection)
    State.ScriptLoaderConnection = nil

    if UI.ValidationOverlay then
        setProperty(UI.ValidationOverlay, "Visible", false)
    end
    setProperty(UI.ScriptLoader, "Visible", true)
    setProperty(UI.ScriptLoader, "GroupTransparency", 1)
    setProperty(UI.ScriptLoaderScale, "Scale", 0.975)
    setProperty(UI.ScriptLoaderFill, "Size", UDim2.new(0, 0, 1, 0))
    setProperty(UI.ScriptLoaderPercent, "Text", "0%")
    setProperty(UI.ScriptLoaderStatus, "Text", "Preparing secure runtime")
    setProperty(UI.ScriptLoaderStatusMark, "BackgroundColor3", Color3.fromRGB(108, 115, 148))
    setProperty(UI.ScriptLoaderStatusMark, "Size", UDim2.fromOffset(6, 2))
    setProperty(UI.ScriptLoaderBadge, "Position", UDim2.fromOffset(490, 92))
    setProperty(UI.ScriptLoaderWordmark, "Position", UDim2.fromOffset(490, 156))
    setProperty(UI.ScriptLoaderTitle, "Position", UDim2.fromOffset(490, 224))
    setProperty(UI.ScriptLoaderTitle, "TextTransparency", 1)
    setProperty(UI.ScriptLoaderSubtitle, "Position", UDim2.fromOffset(490, 262))
    setProperty(UI.ScriptLoaderSubtitle, "TextTransparency", 1)
    setProperty(UI.ScriptLoaderProgressGroup, "Position", UDim2.fromOffset(490, 306))
    setProperty(UI.ScriptLoaderProgressGroup, "GroupTransparency", 1)
    setProperty(UI.ScriptLoaderSupportButton, "Position", UDim2.fromOffset(490, 462))
    setProperty(UI.ScriptLoaderSupportScale, "Scale", 0.96)
    setProperty(UI.ScriptLoaderAmbientGlow, "BackgroundTransparency", 0.985)
    setProperty(UI.ScriptLoaderSurfaceStroke, "Transparency", 0.82)
    setProperty(UI.ScriptLoaderScanLine, "Position", UDim2.fromOffset(-110, 1))
    for _, segment in ipairs(UI.ScriptLoaderStageSegments or {}) do
        setProperty(segment, "BackgroundColor3", Color3.fromRGB(42, 46, 59))
        setProperty(segment, "BackgroundTransparency", 0.42)
    end

    tween(UI.ScriptLoader, TweenInfo.new(0.38, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        GroupTransparency = 0,
    })
    tween(UI.ScriptLoaderScale, TweenInfo.new(0.58, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Scale = 1 })
    tween(UI.ScriptLoaderAmbientGlow, TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.965,
    })
    tween(UI.ScriptLoaderSurfaceStroke, TweenInfo.new(0.64, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Transparency = 0.54,
    })
    tween(UI.ScriptLoaderBadge, TweenInfo.new(0.46, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.fromOffset(490, 82),
    })
    tween(UI.ScriptLoaderWordmark, TweenInfo.new(0.52, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.fromOffset(490, 146),
    })
    tween(UI.ScriptLoaderTitle, TweenInfo.new(0.56, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.fromOffset(490, 213),
        TextTransparency = 0.04,
    })
    tween(UI.ScriptLoaderSubtitle, TweenInfo.new(0.62, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.fromOffset(490, 250),
        TextTransparency = 0.08,
    })
    tween(UI.ScriptLoaderProgressGroup, TweenInfo.new(0.66, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.fromOffset(490, 292),
        GroupTransparency = 0,
    })
    tween(UI.ScriptLoaderSupportButton, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.fromOffset(490, 448),
    })
    tween(UI.ScriptLoaderSupportScale, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Scale = 1,
    })
    tween(UI.ScriptLoaderStatusMark, TweenInfo.new(0.44, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(14, 2),
    })
    if UI.WindowScale then
        tween(UI.WindowScale, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Scale = State.ScaleTarget,
        })
    end

    local startedAt = os.clock() + 0.12
    local duration = 2.7
    local stage = 0
    local finished = false
    local stages = {
        { 0.28, "Preparing secure runtime" },
        { 0.58, "Loading Kronos components" },
        { 0.84, "Restoring your session" },
        { 1, "Starting Script" },
    }
    local progressStops = {
        { 0, 0 },
        { 0.22, 0.16 },
        { 0.5, 0.47 },
        { 0.78, 0.79 },
        { 1, 1 },
    }

    local function cinematicProgress(value)
        for index = 1, #progressStops - 1 do
            local current = progressStops[index]
            local following = progressStops[index + 1]
            if value <= following[1] then
                local alpha = math.clamp((value - current[1]) / (following[1] - current[1]), 0, 1)
                alpha = alpha * alpha * (3 - 2 * alpha)
                return current[2] + (following[2] - current[2]) * alpha
            end
        end
        return 1
    end

    State.ScriptLoaderConnection = connect(RunService.RenderStepped, function()
        if State.Destroyed or not State.ScriptLoaderActive then
            return
        end

        local now = os.clock()
        local linear = math.clamp((now - startedAt) / duration, 0, 1)
        local progress = cinematicProgress(linear)
        setProperty(UI.ScriptLoaderFill, "Size", UDim2.new(progress, 0, 1, 0))
        setProperty(UI.ScriptLoaderPercent, "Text", string.format("%d%%", math.floor(progress * 100 + 0.5)))
        setProperty(UI.ScriptLoaderFillGradient, "Offset", Vector2.new((now * 0.38) % 2 - 1, 0))
        setProperty(UI.ScriptLoaderRailGlow, "BackgroundTransparency", 0.96 + math.sin(now * 3.1) * 0.009)
        setProperty(
            UI.ScriptLoaderBackdropGradient,
            "Offset",
            Vector2.new(math.sin(now * 0.24) * 0.06, math.cos(now * 0.2) * 0.035)
        )
        setProperty(
            UI.ScriptLoaderAmbientGlow,
            "Position",
            UDim2.fromScale(0.5 + math.sin(now * 0.32) * 0.004, 0.23 + math.cos(now * 0.28) * 0.003)
        )
        setProperty(UI.ScriptLoaderSurfaceStroke, "Transparency", 0.54 + math.sin(now * 1.7) * 0.018)
        setProperty(UI.ScriptLoaderScanLine, "Position", UDim2.fromOffset(-110 + linear * 870, 1))

        local nextStage = stage
        for index, data in ipairs(stages) do
            if linear <= data[1] then
                nextStage = index
                break
            end
        end
        if nextStage ~= stage then
            stage = nextStage
            setProperty(UI.ScriptLoaderStatus, "Text", stages[stage][2])
            setProperty(UI.ScriptLoaderStatus, "TextTransparency", 0.46)
            setProperty(UI.ScriptLoaderStatusMark, "Size", UDim2.fromOffset(7, 2))
            tween(UI.ScriptLoaderStatus, TweenInfoSet.Fast, { TextTransparency = 0.06 })
            tween(UI.ScriptLoaderStatusMark, TweenInfoSet.Fast, { Size = UDim2.fromOffset(14, 2) })
            for index, segment in ipairs(UI.ScriptLoaderStageSegments or {}) do
                local complete = index <= stage
                tween(segment, TweenInfoSet.Fast, {
                    BackgroundColor3 = complete and Color3.fromRGB(103, 110, 139) or Color3.fromRGB(42, 46, 59),
                    BackgroundTransparency = complete and 0.14 or 0.42,
                })
            end
        end

        if linear >= 1 and not finished then
            finished = true
            disconnect(State.ScriptLoaderConnection)
            State.ScriptLoaderConnection = nil
            setProperty(UI.ScriptLoaderFill, "Size", UDim2.fromScale(1, 1))
            setProperty(UI.ScriptLoaderPercent, "Text", "100%")
            setProperty(UI.ScriptLoaderStatus, "Text", "Kronos is ready")
            tween(UI.ScriptLoaderStatusMark, TweenInfoSet.Soft, {
                BackgroundColor3 = Color3.fromRGB(156, 163, 191),
                Size = UDim2.fromOffset(22, 2),
            })
            tween(UI.ScriptLoaderPercent, TweenInfoSet.Soft, { TextColor3 = Color3.fromRGB(207, 211, 225) })
            tween(UI.ScriptLoaderSurfaceStroke, TweenInfoSet.Soft, { Transparency = 0.4 })
            for _, segment in ipairs(UI.ScriptLoaderStageSegments or {}) do
                tween(segment, TweenInfoSet.Soft, {
                    BackgroundColor3 = Color3.fromRGB(132, 138, 162),
                    BackgroundTransparency = 0.08,
                })
            end
            task.delay(0.72, function()
                while not State.Destroyed and State.DiscordModalOpen do
                    task.wait(0.12)
                end
                if not State.Destroyed and State.ScriptLoaderActive then
                    Loader:Close()
                end
            end)
        end
    end)
end

local function transitionToScriptLoader()
    if State.Destroyed or State.ScriptLoaderActive or State.ScriptLoaderTransitioning then
        return
    end

    State.ScriptLoaderTransitioning = true
    setInputLocked(true)

    if UI.LeftPanel then
        tween(UI.LeftPanel, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            GroupTransparency = 1,
            Position = UDim2.fromOffset(-18, 0),
        })
    end
    if UI.RightPanel then
        tween(UI.RightPanel, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            GroupTransparency = 1,
            Position = UDim2.fromOffset(508, 0),
        })
    end
    if UI.SplitLine then
        tween(UI.SplitLine, TweenInfoSet.Close, { BackgroundTransparency = 1 })
    end
    if UI.WindowAcrylic and UI.WindowAcrylic.Border then
        tween(UI.WindowAcrylic.Border, TweenInfoSet.Close, {
            Color = Color3.fromRGB(48, 52, 68),
            Transparency = 0.72,
        })
    end
    if UI.WindowScale then
        tween(UI.WindowScale, TweenInfoSet.Close, {
            Scale = math.max((State.ScaleTarget or 1) * 0.972, 0.01),
        })
    end

    task.delay(0.31, function()
        if State.Destroyed or not State.ScriptLoaderTransitioning then
            return
        end
        setProperty(UI.LeftPanel, "Visible", false)
        setProperty(UI.RightPanel, "Visible", false)
        setProperty(UI.SplitLine, "Visible", false)
        State.ScriptLoaderTransitioning = false
        showScriptLoader()
    end)
end

local function createContactSection(parent)
    local title = new("TextLabel", {
        Name = "ContactTitle",
        Size = UDim2.fromOffset(286, 18),
        Position = UDim2.fromOffset(105, 475),
        BackgroundTransparency = 1,
        Text = letterSpaced("OUR CONTACTS"),
        TextColor3 = Theme.TextDim,
        TextTransparency = 0.47,
        Font = Enum.Font.GothamMedium,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 64,
        Parent = parent,
    })

    local row = new("Frame", {
        Name = "ContactRow",
        Size = UDim2.fromOffset(286, 44),
        Position = UDim2.fromOffset(105, 507),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 64,
        Parent = parent,
    })

    local restPosition = UDim2.fromOffset(0, 0)
    local hoverPosition = UDim2.fromOffset(0, -2)
    local pressPosition = UDim2.fromOffset(0, -1)
    local iconBase = Color3.fromRGB(210, 218, 255)
    local iconHover = Color3.fromRGB(239, 244, 255)
    local iconCut = Color3.fromRGB(9, 12, 20)

    local button = new("TextButton", {
        Name = "DiscordContactButton",
        Size = UDim2.fromOffset(44, 40),
        Position = restPosition,
        AutoButtonColor = false,
        BackgroundColor3 = Color3.fromRGB(7, 10, 17),
        BackgroundTransparency = 0.48,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Text = "",
        ZIndex = 66,
        Parent = row,
    })
    corner(button, 16)

    local scale = new("UIScale", {
        Scale = 1,
        Parent = button,
    })

    local shadow = new("Frame", {
        Name = "Shadow Base",
        Size = UDim2.new(1, 20, 1, 18),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.62),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.48,
        BorderSizePixel = 0,
        ZIndex = 62,
        Parent = button,
    })
    corner(shadow, 24)
    gradient(
        shadow,
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(74, 86, 158)),
            ColorSequenceKeypoint.new(0.42, Color3.fromRGB(9, 12, 24)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
        }),
        90,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.96),
            NumberSequenceKeypoint.new(0.54, 0.36),
            NumberSequenceKeypoint.new(1, 0.82),
        })
    )

    local hoverGlow = new("Frame", {
        Name = "Animated Hover Glow",
        Size = UDim2.new(1, 18, 1, 16),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.44, 0.46),
        BackgroundColor3 = Color3.fromRGB(118, 142, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 64,
        Parent = button,
    })
    corner(hoverGlow, 25)
    gradient(
        hoverGlow,
        ColorSequence.new(Color3.fromRGB(202, 214, 255), Color3.fromRGB(65, 88, 180)),
        18,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.54),
            NumberSequenceKeypoint.new(0.45, 0.78),
            NumberSequenceKeypoint.new(1, 1),
        })
    )

    local body = new("Frame", {
        Name = "Dark Acrylic Body",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(8, 11, 18),
        BackgroundTransparency = 0.22,
        BorderSizePixel = 0,
        ZIndex = 67,
        Parent = button,
    })
    corner(body, 16)
    gradient(
        body,
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(27, 31, 48)),
            ColorSequenceKeypoint.new(0.34, Color3.fromRGB(12, 15, 26)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 6, 12)),
        }),
        90,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.18),
            NumberSequenceKeypoint.new(0.5, 0.04),
            NumberSequenceKeypoint.new(1, 0.18),
        })
    )

    local directionLight = new("Frame", {
        Name = "Directional Light",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(150, 168, 255),
        BackgroundTransparency = 0.94,
        BorderSizePixel = 0,
        ZIndex = 68,
        Parent = button,
    })
    corner(directionLight, 16)
    gradient(
        directionLight,
        ColorSequence.new(Color3.fromRGB(210, 222, 255), Color3.fromRGB(20, 24, 42)),
        0,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.7),
            NumberSequenceKeypoint.new(0.42, 0.94),
            NumberSequenceKeypoint.new(1, 1),
        })
    )

    local innerShadow = new("Frame", {
        Name = "Inner Shadow",
        Size = UDim2.new(1, -4, 1, -4),
        Position = UDim2.fromOffset(2, 2),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.86,
        BorderSizePixel = 0,
        ZIndex = 69,
        Parent = button,
    })
    corner(innerShadow, 14)
    gradient(
        innerShadow,
        ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0)),
        90,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.58, 0.98),
            NumberSequenceKeypoint.new(1, 0.64),
        })
    )

    local topHighlight = new("Frame", {
        Name = "Top Glass Highlight",
        Size = UDim2.new(1, -12, 0, 12),
        Position = UDim2.fromOffset(6, 4),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0,
        ZIndex = 70,
        Parent = button,
    })
    corner(topHighlight, 12)
    gradient(
        topHighlight,
        ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(167, 184, 255)),
        90,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.66),
            NumberSequenceKeypoint.new(0.52, 0.96),
            NumberSequenceKeypoint.new(1, 1),
        })
    )

    local bottomShade = new("Frame", {
        Name = "Bottom Bevel Shadow",
        Size = UDim2.new(1, -8, 0, 9),
        Position = UDim2.new(0, 4, 1, -12),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.78,
        BorderSizePixel = 0,
        ZIndex = 70,
        Parent = button,
    })
    corner(bottomShade, 10)
    gradient(
        bottomShade,
        ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(42, 53, 100)),
        90,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.48, 0.84),
            NumberSequenceKeypoint.new(1, 0.52),
        })
    )

    local edgeArcGlow = new("Frame", {
        Name = "Neptune Edge Glow",
        Size = UDim2.fromOffset(32, 6),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.62, 0, 1, -5),
        BackgroundColor3 = Color3.fromRGB(118, 148, 255),
        BackgroundTransparency = 0.94,
        BorderSizePixel = 0,
        Rotation = -8,
        ZIndex = 72,
        Parent = button,
    })
    corner(edgeArcGlow, 8)
    gradient(
        edgeArcGlow,
        ColorSequence.new(Color3.fromRGB(220, 232, 255), Color3.fromRGB(91, 121, 236)),
        0,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.34, 0.52),
            NumberSequenceKeypoint.new(0.72, 0.3),
            NumberSequenceKeypoint.new(1, 1),
        })
    )

    local edgeArc = new("Frame", {
        Name = "Neptune Edge Arc",
        Size = UDim2.fromOffset(29, 2),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.6, 0, 1, -5),
        BackgroundColor3 = Color3.fromRGB(211, 224, 255),
        BackgroundTransparency = 0.74,
        BorderSizePixel = 0,
        Rotation = -8,
        ZIndex = 73,
        Parent = button,
    })
    corner(edgeArc, 4)
    local arcGradient = gradient(
        edgeArc,
        ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(118, 148, 255)),
        0,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.18, 0.42),
            NumberSequenceKeypoint.new(0.7, 0.08),
            NumberSequenceKeypoint.new(1, 1),
        })
    )
    arcGradient.Offset = Vector2.new(-0.22, 0)

    local iconBloom = new("Frame", {
        Name = "Icon Bloom",
        Size = UDim2.fromOffset(32, 28),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(160, 182, 255),
        BackgroundTransparency = 0.96,
        BorderSizePixel = 0,
        ZIndex = 74,
        Parent = button,
    })
    corner(iconBloom, 999)
    gradient(
        iconBloom,
        ColorSequence.new(Color3.fromRGB(225, 232, 255), Color3.fromRGB(86, 111, 215)),
        0,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.36),
            NumberSequenceKeypoint.new(0.58, 0.72),
            NumberSequenceKeypoint.new(1, 1),
        })
    )

    local glyph = new("Frame", {
        Name = "DiscordGlyph",
        Size = UDim2.fromOffset(24, 20),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 78,
        Parent = button,
    })

    local glyphTop = new("Frame", {
        Name = "GlyphTopContour",
        Size = UDim2.fromOffset(18, 7),
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromOffset(12, 1),
        BackgroundColor3 = iconBase,
        BackgroundTransparency = 0.08,
        BorderSizePixel = 0,
        ZIndex = 78,
        Parent = glyph,
    })
    corner(glyphTop, 6)

    local glyphBody = new("Frame", {
        Name = "GlyphBody",
        Size = UDim2.fromOffset(24, 16),
        Position = UDim2.fromOffset(0, 4),
        BackgroundColor3 = iconBase,
        BackgroundTransparency = 0.08,
        BorderSizePixel = 0,
        ZIndex = 79,
        Parent = glyph,
    })
    corner(glyphBody, 7)

    local leftCheek = new("Frame", {
        Name = "GlyphLeftCheek",
        Size = UDim2.fromOffset(6, 9),
        Position = UDim2.fromOffset(-2, 7),
        BackgroundColor3 = iconBase,
        BackgroundTransparency = 0.08,
        BorderSizePixel = 0,
        ZIndex = 79,
        Parent = glyph,
    })
    corner(leftCheek, 999)

    local rightCheek = new("Frame", {
        Name = "GlyphRightCheek",
        Size = UDim2.fromOffset(6, 9),
        Position = UDim2.fromOffset(20, 7),
        BackgroundColor3 = iconBase,
        BackgroundTransparency = 0.08,
        BorderSizePixel = 0,
        ZIndex = 79,
        Parent = glyph,
    })
    corner(rightCheek, 999)

    local bottomCut = new("Frame", {
        Name = "GlyphBottomCut",
        Size = UDim2.fromOffset(10, 4),
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromOffset(12, 17),
        BackgroundColor3 = iconCut,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ZIndex = 80,
        Parent = glyph,
    })
    corner(bottomCut, 999)

    local leftEye = new("Frame", {
        Name = "GlyphLeftEye",
        Size = UDim2.fromOffset(3, 4),
        Position = UDim2.fromOffset(7, 10),
        BackgroundColor3 = iconCut,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ZIndex = 81,
        Parent = glyph,
    })
    corner(leftEye, 999)

    local rightEye = new("Frame", {
        Name = "GlyphRightEye",
        Size = UDim2.fromOffset(3, 4),
        Position = UDim2.fromOffset(14, 10),
        BackgroundColor3 = iconCut,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ZIndex = 81,
        Parent = glyph,
    })
    corner(rightEye, 999)

    local glyphSheen = new("Frame", {
        Name = "GlyphSheen",
        Size = UDim2.new(1, -7, 0, 5),
        Position = UDim2.fromOffset(4, 5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.88,
        BorderSizePixel = 0,
        ZIndex = 82,
        Parent = glyph,
    })
    corner(glyphSheen, 5)
    gradient(
        glyphSheen,
        ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(190, 205, 255)),
        90,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.64),
            NumberSequenceKeypoint.new(0.58, 0.96),
            NumberSequenceKeypoint.new(1, 1),
        })
    )

    local border = stroke(button, Color3.fromRGB(78, 86, 120), 1, 0.54)
    border.Name = "Border Layer"
    local innerEdge = stroke(body, Color3.fromRGB(226, 234, 255), 1, 0.86)
    innerEdge.Name = "Inner Edge Light"

    local function tweenGlyph(color, transparency)
        tween(glyphTop, TweenInfoSet.Fast, { BackgroundColor3 = color, BackgroundTransparency = transparency })
        tween(glyphBody, TweenInfoSet.Fast, { BackgroundColor3 = color, BackgroundTransparency = transparency })
        tween(leftCheek, TweenInfoSet.Fast, { BackgroundColor3 = color, BackgroundTransparency = transparency })
        tween(rightCheek, TweenInfoSet.Fast, { BackgroundColor3 = color, BackgroundTransparency = transparency })
    end

    connect(button.MouseEnter, function()
        tween(button, TweenInfoSet.Fast, { Position = hoverPosition })
        tween(scale, TweenInfoSet.Fast, { Scale = 1.025 })
        tween(shadow, TweenInfoSet.Fast, { BackgroundTransparency = 0.36 })
        tween(hoverGlow, TweenInfoSet.Fast, { BackgroundTransparency = 0.82, Position = UDim2.fromScale(0.4, 0.44) })
        tween(body, TweenInfoSet.Fast, { BackgroundTransparency = 0.16 })
        tween(directionLight, TweenInfoSet.Fast, { BackgroundTransparency = 0.84 })
        tween(topHighlight, TweenInfoSet.Fast, { BackgroundTransparency = 0.82 })
        tween(bottomShade, TweenInfoSet.Fast, { BackgroundTransparency = 0.68 })
        tween(edgeArcGlow, TweenInfoSet.Fast, { BackgroundTransparency = 0.76 })
        tween(edgeArc, TweenInfoSet.Fast, {
            BackgroundTransparency = 0.18,
            Position = UDim2.new(0.68, 0, 1, -5),
            Rotation = -4,
        })
        tween(arcGradient, TweenInfo.new(0.36, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Offset = Vector2.new(0.24, 0),
        })
        tween(iconBloom, TweenInfoSet.Fast, { BackgroundTransparency = 0.82 })
        tween(glyphSheen, TweenInfoSet.Fast, { BackgroundTransparency = 0.8 })
        tweenGlyph(iconHover, 0.02)
        tween(border, TweenInfoSet.Fast, {
            Color = Color3.fromRGB(128, 145, 218),
            Transparency = 0.34,
        })
        tween(innerEdge, TweenInfoSet.Fast, { Transparency = 0.68 })
    end)
    connect(button.MouseLeave, function()
        tween(button, TweenInfoSet.Fast, { Position = restPosition })
        tween(scale, TweenInfoSet.Fast, { Scale = 1 })
        tween(shadow, TweenInfoSet.Fast, { BackgroundTransparency = 0.48 })
        tween(hoverGlow, TweenInfoSet.Fast, { BackgroundTransparency = 1, Position = UDim2.fromScale(0.44, 0.46) })
        tween(body, TweenInfoSet.Fast, { BackgroundTransparency = 0.22 })
        tween(directionLight, TweenInfoSet.Fast, { BackgroundTransparency = 0.94 })
        tween(topHighlight, TweenInfoSet.Fast, { BackgroundTransparency = 0.9 })
        tween(bottomShade, TweenInfoSet.Fast, { BackgroundTransparency = 0.78 })
        tween(edgeArcGlow, TweenInfoSet.Fast, { BackgroundTransparency = 0.94 })
        tween(edgeArc, TweenInfoSet.Fast, {
            BackgroundTransparency = 0.74,
            Position = UDim2.new(0.6, 0, 1, -5),
            Rotation = -8,
        })
        tween(arcGradient, TweenInfoSet.Fast, { Offset = Vector2.new(-0.22, 0) })
        tween(iconBloom, TweenInfoSet.Fast, { BackgroundTransparency = 0.96 })
        tween(glyphSheen, TweenInfoSet.Fast, { BackgroundTransparency = 0.88 })
        tweenGlyph(iconBase, 0.08)
        tween(border, TweenInfoSet.Fast, {
            Color = Color3.fromRGB(78, 86, 120),
            Transparency = 0.54,
        })
        tween(innerEdge, TweenInfoSet.Fast, { Transparency = 0.86 })
    end)
    connect(button.MouseButton1Down, function()
        tween(button, TweenInfoSet.Fast, { Position = pressPosition })
        tween(scale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 0.96 })
        tween(hoverGlow, TweenInfoSet.Fast, { BackgroundTransparency = 0.72 })
        tween(edgeArc, TweenInfoSet.Fast, { BackgroundTransparency = 0.08 })
        tween(iconBloom, TweenInfoSet.Fast, { BackgroundTransparency = 0.74 })
    end)
    connect(button.MouseButton1Up, function()
        tween(button, TweenInfoSet.Fast, { Position = hoverPosition })
        tween(scale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1.025 })
        tween(hoverGlow, TweenInfoSet.Fast, { BackgroundTransparency = 0.82 })
        tween(edgeArc, TweenInfoSet.Fast, { BackgroundTransparency = 0.18 })
        tween(iconBloom, TweenInfoSet.Fast, { BackgroundTransparency = 0.82 })
    end)
    local purchaseButton = button:Clone()
    purchaseButton.Name = "PurchaseAccessButton"
    purchaseButton.Position = UDim2.fromOffset(56, 0)
    purchaseButton.Parent = row
    local purchaseGlyph = purchaseButton:FindFirstChild("DiscordGlyph", true)
    if purchaseGlyph then
        purchaseGlyph:Destroy()
    end
    local keyGlyph = new("Frame", {
        Name = "KeyGlyph",
        Size = UDim2.fromOffset(26, 22),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundTransparency = 1,
        Rotation = -18,
        ZIndex = 84,
        Parent = purchaseButton,
    })
    local keyRing = new("Frame", {
        Name = "KeyRing",
        Size = UDim2.fromOffset(11, 11),
        Position = UDim2.fromOffset(2, 5),
        BackgroundTransparency = 1,
        ZIndex = 84,
        Parent = keyGlyph,
    })
    corner(keyRing, 999)
    stroke(keyRing, iconBase, 2, 0.08)
    corner(
        new("Frame", {
            Name = "KeyStem",
            Size = UDim2.fromOffset(14, 3),
            Position = UDim2.fromOffset(12, 9),
            BackgroundColor3 = iconBase,
            BackgroundTransparency = 0.08,
            BorderSizePixel = 0,
            ZIndex = 84,
            Parent = keyGlyph,
        }),
        3
    )
    new("Frame", {
        Name = "KeyToothA",
        Size = UDim2.fromOffset(3, 7),
        Position = UDim2.fromOffset(21, 10),
        BackgroundColor3 = iconBase,
        BackgroundTransparency = 0.08,
        BorderSizePixel = 0,
        ZIndex = 84,
        Parent = keyGlyph,
    })
    connect(purchaseButton.MouseEnter, function()
        tween(purchaseButton, TweenInfoSet.Fast, { Position = UDim2.fromOffset(56, -2) })
    end)
    connect(purchaseButton.MouseLeave, function()
        tween(purchaseButton, TweenInfoSet.Fast, { Position = UDim2.fromOffset(56, 0) })
    end)
    connect(purchaseButton.MouseButton1Down, function()
        tween(purchaseButton, TweenInfoSet.Fast, { Position = UDim2.fromOffset(56, -1) })
    end)
    connect(purchaseButton.MouseButton1Click, openPurchaseModal)

    connect(button.MouseButton1Click, openDiscordModal)

    return title, row, button, purchaseButton
end

local function openKeyLink()
    local url = State.KeyLink
    if type(url) ~= "string" or url == "" then
        setStatus("error", "Key link unavailable")
        Loader:Toast({
            Type = "error",
            Title = "No Key Link",
            Subtitle = "A key link has not been configured",
            Duration = 3,
        })
        return
    end

    setStatus("success", "Key link ready to copy")
    openLinkModal("Get Key", url, "Copy your personal access link and complete the checkpoint in your browser.")
end

local function showStatusText(kind, message)
    setStatus(kind, message)
    if UI.StatusText then
        tween(UI.StatusText, TweenInfoSet.Soft, { TextTransparency = 0.14 })
    end
    if UI.StatusLine then
        tween(UI.StatusLine, TweenInfoSet.Soft, { BackgroundTransparency = kind == "success" and 0.54 or 0.46 })
    end
end

local function finishValidation(success, message, options, token)
    options = options or {}
    if token and token ~= State.ValidationToken then
        return
    end

    if success then
        State.Validating = false
        stopLoadingVisual()
        if UI.ValidateButton then
            tween(UI.ValidateButton, TweenInfoSet.Soft, { BackgroundTransparency = 0.12 })
        end
        if UI.WindowAcrylic and UI.WindowAcrylic.Border then
            tween(UI.WindowAcrylic.Border, TweenInfoSet.Soft, {
                Color = Color3.fromRGB(210, 218, 255),
                Transparency = 0.34,
            })
        end
        if UI.WindowScale then
            tween(
                UI.WindowScale,
                TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { Scale = State.ScaleTarget * 0.985 }
            )
        end
        if options.Auto then
            showStatusText("success", message or "Saved key validated")
        end
        task.delay(options.Auto and 0.5 or 0.18, function()
            if not State.Destroyed and (not token or token == State.ValidationToken) then
                transitionToScriptLoader()
            end
        end)
        return
    end

    State.Validating = false
    stopLoadingVisual()
    setInputLocked(false)
    if UI.StatusText then
        setProperty(UI.StatusText, "TextTransparency", 1)
    end
    if UI.StatusLine then
        setProperty(UI.StatusLine, "BackgroundTransparency", 1)
    end
    showStatusText("error", message or (options.Auto and "Saved key invalid. Enter a new key" or "Validation failed"))
    if UI.FormGroup then
        local ok, original = pcall(function()
            return UI.FormGroup.Position
        end)
        if ok then
            tween(UI.FormGroup, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = original + UDim2.fromOffset(0, 2),
            })
            task.delay(0.08, function()
                if canTouchInstance(UI.FormGroup) then
                    tween(
                        UI.FormGroup,
                        TweenInfo.new(0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                        { Position = original }
                    )
                end
            end)
        end
    end
end

local function beginValidationFlow(key, options)
    options = options or {}
    if State.Validating or State.Destroyed then
        return false
    end
    key = tostring(key or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if key == "" then
        showStatusText("error", options.Auto and "Saved key was empty. Enter a new key" or "Enter your key first")
        return false
    end
    if type(State.ValidateCallback) ~= "function" then
        showStatusText("error", "Validator unavailable")
        return false
    end

    State.ValidationToken += 1
    local token = State.ValidationToken
    State.Validating = true
    setInputLocked(true)

    if UI.KeyBox and options.FillInput ~= false then
        setProperty(UI.KeyBox, "Text", key)
    end

    if options.Auto then
        showStatusText("loading", options.StartMessage or "Saved key found — validating securely")
        startLoadingVisual(options.LoadingMessage or "Validating Saved Key")
    else
        startLoadingVisual(options.LoadingMessage or "Validating Access")
    end

    task.spawn(function()
        local ok, accepted, resultMessage = pcall(State.ValidateCallback, key)
        if State.Destroyed or token ~= State.ValidationToken then
            return
        end
        if not ok then
            finishValidation(false, tostring(accepted or "Validation error"), options, token)
        else
            local success = accepted == true
            local fallback = success and (options.Auto and "Saved key validated" or "Welcome back!")
                or (options.Auto and "Saved key invalid. Enter a new key" or "Validation failed")
            finishValidation(success, tostring(resultMessage or fallback), options, token)
        end
    end)

    return true
end

local function validateKey()
    local key = UI.KeyBox and UI.KeyBox.Text or ""
    return beginValidationFlow(key, { Auto = false, FillInput = false })
end
local function setWordmark(text)
    State.Title = tostring(text or "KRONOS")
    if UI.RenderLeftWordmark then
        UI.RenderLeftWordmark(State.Title)
    end
    if UI.RenderRightWordmark then
        UI.RenderRightWordmark(State.Title)
    end
    if UI.RenderScriptLoaderWordmark then
        UI.RenderScriptLoaderWordmark(State.Title)
    end
end

local function pointInObject(guiObject, point)
    if not guiObject or not guiObject.Parent then
        return false
    end
    local pos = guiObject.AbsolutePosition
    local size = guiObject.AbsoluteSize
    return point.X >= pos.X and point.X <= pos.X + size.X and point.Y >= pos.Y and point.Y <= pos.Y + size.Y
end

local function beginDrag(input)
    if
        State.Destroyed
        or State.Validating
        or State.ScriptLoaderActive
        or State.ScriptLoaderTransitioning
        or State.DiscordModalOpen
    then
        return
    end
    local inputType = input.UserInputType
    if inputType ~= Enum.UserInputType.MouseButton1 and inputType ~= Enum.UserInputType.Touch then
        return
    end
    local point = Vector2.new(input.Position.X, input.Position.Y)
    if
        pointInObject(UI.KeyField, point)
        or pointInObject(UI.StatusField, point)
        or pointInObject(UI.ValidateButton, point)
        or pointInObject(UI.GetKeyButton, point)
        or pointInObject(UI.ContactDiscordButton, point)
        or pointInObject(UI.PurchaseAccessButton, point)
    then
        return
    end

    State.WasDragged = true
    State.Drag.Active = true
    State.Drag.Input = input
    State.Drag.StartPointer = Vector2.new(input.Position.X, input.Position.Y)
    State.Drag.StartCenter = State.Center or Vector2.new(getViewport().X * 0.5, getViewport().Y * 0.5)
    State.Drag.TargetCenter = State.Drag.StartCenter
    State.Drag.CurrentCenter = State.Drag.StartCenter
    State.Drag.LastPointer = State.Drag.StartPointer
    State.Drag.LastTime = os.clock()
    State.Drag.Velocity = Vector2.zero

    local releaseConnection
    releaseConnection = input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            State.Drag.Active = false
            disconnect(releaseConnection)
        end
    end)
end

local function updateDragInput(input)
    if not State.Drag.Active then
        return
    end
    local inputType = input.UserInputType
    if inputType ~= Enum.UserInputType.MouseMovement and inputType ~= Enum.UserInputType.Touch then
        return
    end
    local pointer = Vector2.new(input.Position.X, input.Position.Y)
    local delta = pointer - State.Drag.StartPointer
    local now = os.clock()
    local dt = math.max(now - State.Drag.LastTime, 1 / 240)
    local velocity = (pointer - State.Drag.LastPointer) / dt
    if velocity.Magnitude > 4200 then
        velocity = velocity.Unit * 4200
    end
    local nextCenter = State.Drag.StartCenter + delta
    State.Drag.Velocity = velocity
    State.Drag.LastPointer = pointer
    State.Drag.LastTime = now
    State.Drag.TargetCenter = nextCenter
    State.Drag.CurrentCenter = nextCenter
    State.Center = nextCenter
    if UI.WindowHost then
        UI.WindowHost.Position = UDim2.fromOffset(nextCenter.X, nextCenter.Y)
    end
end

local function updateDrag(dt)
    if State.Destroyed or not UI.WindowHost then
        return
    end
    local drag = State.Drag
    if drag.Active then
        return
    end

    if drag.Velocity.Magnitude > 8 then
        local nextCenter = drag.CurrentCenter + drag.Velocity * dt * 0.34
        drag.CurrentCenter = nextCenter
        drag.TargetCenter = nextCenter
        State.Center = nextCenter
        UI.WindowHost.Position = UDim2.fromOffset(nextCenter.X, nextCenter.Y)
        drag.Velocity *= math.exp(-dt * 9.8)
    end
end

local function createField(parent, name, y, isInput)
    local field = new("Frame", {
        Name = name,
        Size = UDim2.fromOffset(270, 54),
        Position = UDim2.fromOffset(122, y),
        BackgroundColor3 = Color3.fromRGB(4, 6, 10),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 42,
        Parent = parent,
    })

    local aura = new("Frame", {
        Name = "FocusAura",
        Size = UDim2.new(1, -10, 0, 22),
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -3),
        BackgroundColor3 = Theme.AccentHot,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 42,
        Parent = field,
    })
    corner(aura, 18)
    gradient(
        aura,
        ColorSequence.new(Theme.AccentHot, Theme.AccentDeep),
        0,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.78),
            NumberSequenceKeypoint.new(0.52, 0.52),
            NumberSequenceKeypoint.new(1, 1),
        })
    )

    local line = new("Frame", {
        Name = "BottomLine",
        Size = UDim2.new(1, -18, 0, 1),
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -6),
        BackgroundColor3 = Theme.LineSoft,
        BackgroundTransparency = 0.68,
        BorderSizePixel = 0,
        ZIndex = 44,
        Parent = field,
    })

    local caption = new("TextLabel", {
        Name = "Caption",
        Size = UDim2.new(1, -58, 0, 18),
        Position = UDim2.fromOffset(18, 6),
        BackgroundTransparency = 1,
        Text = isInput and "Enter Key" or "Status",
        TextColor3 = Theme.TextMuted,
        TextTransparency = 0.34,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 45,
        Parent = field,
    })

    if isInput then
        local box = new("TextBox", {
            Name = "Input",
            Size = UDim2.new(1, -68, 0, 25),
            Position = UDim2.fromOffset(18, 24),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            ClearTextOnFocus = false,
            Text = "",
            PlaceholderText = "Enter your key...",
            PlaceholderColor3 = Color3.fromRGB(88, 94, 116),
            TextColor3 = Theme.Text,
            TextTransparency = 0.07,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextWrapped = false,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 46,
            Parent = field,
        })
        createTinyUserIcon(field, 46)
        connect(box.Focused, function()
            tween(line, TweenInfoSet.Soft, {
                BackgroundColor3 = Color3.fromRGB(225, 230, 255),
                BackgroundTransparency = 0.1,
                Size = UDim2.new(1, -10, 0, 1),
            })
            tween(aura, TweenInfoSet.Soft, { BackgroundTransparency = 0.88 })
            tween(caption, TweenInfoSet.Soft, { TextTransparency = 0.18 })
        end)
        connect(box.FocusLost, function(enterPressed)
            tween(line, TweenInfoSet.Soft, {
                BackgroundColor3 = Theme.LineSoft,
                BackgroundTransparency = 0.68,
                Size = UDim2.new(1, -18, 0, 1),
            })
            tween(aura, TweenInfoSet.Soft, { BackgroundTransparency = 1 })
            tween(caption, TweenInfoSet.Soft, { TextTransparency = 0.34 })
            if enterPressed then
                validateKey()
            end
        end)
        return field, box, line, caption
    end

    local value = new("TextLabel", {
        Name = "Value",
        Size = UDim2.new(1, -68, 0, 25),
        Position = UDim2.fromOffset(18, 24),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Text = "Status",
        TextColor3 = Theme.TextDim,
        TextTransparency = 0.14,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 46,
        Parent = field,
    })
    createTinyKeyIcon(field, 46)
    return field, value, line, caption
end

local function createShadow(parent)
    for index = 1, 7 do
        local spread = 16 + index * 12
        local shadow = new("Frame", {
            Name = "SoftShadow",
            Size = UDim2.new(1, spread, 1, spread),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 7 + index * 2),
            BackgroundColor3 = index <= 2 and Color3.fromRGB(6, 8, 14) or Color3.new(0, 0, 0),
            BackgroundTransparency = 0.82 + index * 0.018,
            BorderSizePixel = 0,
            ZIndex = 2,
            Parent = parent,
        })
        corner(shadow, 18 + index * 5)
    end
end

local function createValidationOverlay(parent)
    local overlay = new("CanvasGroup", {
        Name = "ValidationOverlay",
        Size = UDim2.fromScale(1, 1),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(2, 3, 6),
        BackgroundTransparency = 0.72,
        GroupTransparency = 1,
        Visible = false,
        BorderSizePixel = 0,
        ZIndex = 250,
        Parent = parent,
    })
    corner(overlay, 12)
    UI.ValidationOverlayScale = new("UIScale", { Scale = 0.94, Parent = overlay })

    local diffusion = new("Frame", {
        Name = "OverlayDiffusion",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(16, 20, 32),
        BackgroundTransparency = 0.86,
        BorderSizePixel = 0,
        ZIndex = 251,
        Parent = overlay,
    })
    corner(diffusion, 12)
    gradient(
        diffusion,
        ColorSequence.new(Color3.fromRGB(44, 50, 72), Color3.fromRGB(3, 4, 8)),
        90,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.7),
            NumberSequenceKeypoint.new(0.56, 0.92),
            NumberSequenceKeypoint.new(1, 0.82),
        })
    )

    local spinner = new("Frame", {
        Name = "RouletteSpinner",
        Size = UDim2.fromOffset(76, 76),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 260,
        Parent = overlay,
    })
    UI.ValidationSpinner = spinner
    UI.SpinnerSegments = {}

    local bloom = new("Frame", {
        Name = "SpinnerGlow",
        Size = UDim2.fromOffset(82, 82),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(178, 190, 255),
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0,
        ZIndex = 258,
        Parent = spinner,
    })
    corner(bloom, 82)
    gradient(
        bloom,
        ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(130, 150, 235)),
        0,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.72),
            NumberSequenceKeypoint.new(0.48, 0.42),
            NumberSequenceKeypoint.new(1, 1),
        })
    )

    for index = 1, 14 do
        local angle = (index - 1) * (360 / 14)
        local segment = new("Frame", {
            Name = "Segment" .. index,
            Size = UDim2.fromOffset(3, 15),
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(230, 234, 255),
            BackgroundTransparency = 0.42 + index * 0.026,
            BorderSizePixel = 0,
            Rotation = angle,
            ZIndex = 261,
            Parent = spinner,
        })
        segment.Position = UDim2.new(0.5, math.sin(math.rad(angle)) * 28, 0.5, -math.cos(math.rad(angle)) * 28)
        corner(segment, 3)
        UI.SpinnerSegments[index] = segment
    end

    local label = new("TextLabel", {
        Name = "LoadingText",
        Size = UDim2.fromOffset(240, 24),
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0.5, 52),
        BackgroundTransparency = 1,
        Text = letterSpaced("Validating Access"),
        TextColor3 = Color3.fromRGB(198, 204, 232),
        TextTransparency = 0.42,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 261,
        Parent = overlay,
    })

    UI.ValidationLoadingText = label
    UI.ValidationOverlay = overlay
    return overlay
end

local function buildInterface()
    UI.ScreenGui = new("ScreenGui", {
        Name = "KRONOS_KeySystem",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 999999,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    setParent(UI.ScreenGui)

    UI.Blur = new("BlurEffect", {
        Name = "KRONOS_AcrylicBlur",
        Size = 0,
        Parent = Lighting,
    })
    tween(UI.Blur, TweenInfoSet.Open, { Size = 8 })

    UI.Root = new("Frame", {
        Name = "Root",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ZIndex = 0,
        Parent = UI.ScreenGui,
    })
    gradient(
        UI.Root,
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 8, 14)),
            ColorSequenceKeypoint.new(0.45, Color3.fromRGB(8, 10, 16)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(1, 2, 5)),
        }),
        18,
        NumberSequence.new(0)
    )

    UI.WindowHost = new("Frame", {
        Name = "WindowHost",
        Size = UDim2.fromOffset(BASE_SIZE.X, BASE_SIZE.Y),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundTransparency = 1,
        ZIndex = 2,
        Parent = UI.Root,
    })
    createShadow(UI.WindowHost)

    UI.Window = new("CanvasGroup", {
        Name = "Window",
        Size = UDim2.fromOffset(BASE_SIZE.X, BASE_SIZE.Y),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundColor3 = Theme.Ink,
        BackgroundTransparency = 1,
        GroupTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 8,
        Parent = UI.WindowHost,
    })
    corner(UI.Window, 12)
    UI.WindowScale = new("UIScale", { Scale = 1, Parent = UI.WindowHost })
    UI.WindowAcrylic = createAcrylic(UI.Window, 8, 12, Theme.Panel, 0.74)

    UI.LeftPanel = new("CanvasGroup", {
        Name = "LeftPanel",
        Size = UDim2.new(0, 490, 1, 0),
        BackgroundColor3 = Theme.InkSoft,
        BackgroundTransparency = 0.74,
        GroupTransparency = 0,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 20,
        Parent = UI.Window,
    })
    createAcrylic(UI.LeftPanel, 20, 12, Color3.fromRGB(7, 10, 18), 0.78)

    UI.SplitLine = new("Frame", {
        Name = "PanelSplit",
        Size = UDim2.new(0, 1, 1, -34),
        Position = UDim2.fromOffset(490, 17),
        BackgroundColor3 = Color3.fromRGB(18, 23, 36),
        BackgroundTransparency = 0.68,
        BorderSizePixel = 0,
        ZIndex = 38,
        Parent = UI.Window,
    })

    UI.RightPanel = new("CanvasGroup", {
        Name = "RightPanel",
        Size = UDim2.new(1, -490, 1, 0),
        Position = UDim2.fromOffset(490, 0),
        BackgroundColor3 = Color3.fromRGB(5, 7, 12),
        BackgroundTransparency = 0.7,
        GroupTransparency = 0,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 30,
        Parent = UI.Window,
    })
    createAcrylic(UI.RightPanel, 30, 12, Color3.fromRGB(5, 7, 12), 0.74)

    local leftWordmark, leftRender = buildWordmark(UI.LeftPanel, State.Title, {
        Name = "LeftWordmark",
        Size = UDim2.fromOffset(340, 58),
        Position = UDim2.fromOffset(245, 300),
        AnchorPoint = Vector2.new(0.5, 0.5),
        TextSize = 35,
        LetterWidth = 26,
        Padding = 15,
        SpaceWidth = 18,
        ZIndex = 62,
    })
    UI.LeftWordmark = leftWordmark
    UI.RenderLeftWordmark = leftRender

    UI.Powered = new("TextLabel", {
        Name = "Powered",
        Size = UDim2.fromOffset(350, 30),
        Position = UDim2.fromOffset(42, 538),
        BackgroundTransparency = 1,
        Text = letterSpaced("Powered by Delta"),
        TextColor3 = Theme.TextDim,
        TextTransparency = 0.48,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 62,
        Parent = UI.LeftPanel,
    })

    UI.VersionLabel = new("TextLabel", {
        Name = "Version",
        Size = UDim2.fromOffset(140, 24),
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -34, 1, -20),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Theme.TextMuted,
        TextTransparency = 0.35,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Right,
        Visible = false,
        ZIndex = 62,
        Parent = UI.LeftPanel,
    })

    local rightWordmark, rightRender = buildWordmark(UI.RightPanel, State.Title, {
        Name = "RightWordmark",
        Size = UDim2.fromOffset(330, 48),
        Position = UDim2.fromOffset(255, 90),
        AnchorPoint = Vector2.new(0.5, 0.5),
        TextSize = 30,
        LetterWidth = 23,
        Padding = 12,
        SpaceWidth = 16,
        ZIndex = 64,
    })
    UI.RightWordmark = rightWordmark
    UI.RenderRightWordmark = rightRender

    UI.Subtitle = new("TextLabel", {
        Name = "Subtitle",
        Size = UDim2.fromOffset(370, 28),
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromOffset(255, 128),
        BackgroundTransparency = 1,
        Text = letterSpaced("Key System"),
        TextColor3 = Theme.TextDim,
        TextTransparency = 0.48,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 64,
        Parent = UI.RightPanel,
    })

    UI.FormGroup = new("Frame", {
        Name = "FormGroup",
        Size = UDim2.fromOffset(490, 330),
        Position = UDim2.fromOffset(0, 0),
        BackgroundTransparency = 1,
        ZIndex = 40,
        Parent = UI.RightPanel,
    })

    UI.KeyField, UI.KeyBox = createField(UI.FormGroup, "EnterKeyField", 206, true)
    UI.StatusField, UI.StatusText, UI.StatusLine = createField(UI.FormGroup, "StatusField", 274, false)

    UI.ValidateButton, UI.ValidateLabel = createButton(
        UI.FormGroup,
        "ValidateButton",
        "Validate",
        UDim2.fromOffset(105, 350),
        UDim2.fromOffset(286, 48),
        true,
        validateKey
    )
    UI.GetKeyButton = nil
    UI.GetKeyLabel = nil
    UI.GetKeyButton, UI.GetKeyLabel = createButton(
        UI.FormGroup,
        "GetKeyButton",
        "Get Key",
        UDim2.fromOffset(105, 414),
        UDim2.fromOffset(286, 38),
        false,
        openKeyLink
    )
    UI.ContactTitle, UI.ContactRow, UI.ContactDiscordButton, UI.PurchaseAccessButton =
        createContactSection(UI.FormGroup)

    createScriptLoader(UI.Window)
    createValidationOverlay(UI.Window)

    UI.ToastLayer = new("Frame", {
        Name = "ToastLayer",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 300,
        Parent = UI.Root,
    })

    connect(UI.LeftPanel.InputBegan, beginDrag)
    connect(UI.RightPanel.InputBegan, beginDrag)
    connect(UI.Window.InputBegan, beginDrag)
    connect(UserInputService.InputChanged, updateDragInput)
    connect(RunService.RenderStepped, updateDrag)
    connect(UI.Root:GetPropertyChangedSignal("AbsoluteSize"), updateScale)
    connect(UI.Root:GetPropertyChangedSignal("AbsoluteSize"), reflowToasts)
    connect(workspace:GetPropertyChangedSignal("CurrentCamera"), function()
        disconnect(State.CameraViewportConnection)
        State.CameraViewportConnection = nil
        if workspace.CurrentCamera then
            State.CameraViewportConnection =
                connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), updateScale)
        end
        task.defer(updateScale)
    end)
    if workspace.CurrentCamera then
        State.CameraViewportConnection =
            connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), updateScale)
    end

    setStatus("idle", "Status")
    updateScale()
    UI.Window.GroupTransparency = 1
    tween(UI.Window, TweenInfoSet.Open, { GroupTransparency = 0 })
    tween(UI.Root, TweenInfoSet.Open, { BackgroundTransparency = 0.48 })
end

function Loader:SetTitle(title)
    setWordmark(title or "KRONOS")
    return self
end

function Loader:SetVersion(version)
    State.Version = tostring(version or "")
    if UI.VersionLabel then
        if State.Version == "" then
            UI.VersionLabel.Visible = false
        else
            UI.VersionLabel.Visible = true
            UI.VersionLabel.Text = "v" .. State.Version
        end
    end
    return self
end

function Loader:SetKeyLink(url)
    State.KeyLink = tostring(url or "")
    return self
end

function Loader:SetExpiry(seconds)
    State.ExpiryToken += 1
    local token = State.ExpiryToken
    local expiry = tonumber(seconds)
    if expiry and expiry > 0 then
        task.delay(expiry, function()
            if State.Destroyed or token ~= State.ExpiryToken then
                return
            end
            State.Validating = false
            setInputLocked(false)
            stopLoadingVisual()
            setStatus("warning", "Session expired")
            Loader:Toast({
                Type = "warning",
                Title = "Session Expired",
                Subtitle = "Generate or enter a fresh key",
                Duration = 4,
            })
        end)
    end
    return self
end

function Loader:SetOnValidate(callback)
    if type(callback) == "function" then
        State.ValidateCallback = callback
    else
        State.ValidateCallback = nil
    end
    return self
end

function Loader:AutoValidate(key)
    return beginValidationFlow(key, {
        Auto = true,
        FillInput = true,
        StartMessage = "Saved key found — validating securely",
        LoadingMessage = "Validating Saved Key",
    })
end

function Loader:ValidateSavedKey(key)
    return self:AutoValidate(key)
end

function Loader:Toast(config)
    if State.Destroyed then
        return nil
    end
    if type(config) == "string" then
        config = { Title = config }
    elseif type(config) ~= "table" then
        config = { Title = "Notification" }
    end
    if not UI.ToastLayer then
        return nil
    end

    if #State.Toasts >= 4 then
        State.ToastQueue[#State.ToastQueue + 1] = config
        return nil
    end

    local accent, icon = toastColor(string.lower(tostring(config.Type or "info")))
    if type(config.Icon) == "string" then
        local iconName = string.lower(config.Icon)
        if iconName == "shield-check" or iconName == "check" or iconName == "check-circle" then
            icon = "✓"
        elseif iconName == "x" or iconName == "x-circle" or iconName == "alert" then
            icon = "!"
        elseif iconName == "info" then
            icon = "i"
        elseif iconName == "loader" or iconName == "loading" then
            icon = "…"
        end
    end

    local width, height = getToastMetrics()
    local wrapper = new("CanvasGroup", {
        Name = "Toast",
        Size = UDim2.fromOffset(width, height),
        AnchorPoint = Vector2.new(1, 0),
        Position = getToastPosition(1, true),
        BackgroundTransparency = 1,
        GroupTransparency = 1,
        ClipsDescendants = false,
        ZIndex = 306,
        Parent = UI.ToastLayer,
    })
    local wrapperScale = new("UIScale", { Scale = 0.965, Parent = wrapper })
    local card = createToastMaterial(wrapper, accent)

    local iconFrame = new("Frame", {
        Name = "IconFrame",
        Size = UDim2.fromOffset(38, 38),
        Position = UDim2.fromOffset(17, 18),
        BackgroundColor3 = accent,
        BackgroundTransparency = 0.88,
        BorderSizePixel = 0,
        ZIndex = 322,
        Parent = card,
    })
    corner(iconFrame, 13)
    stroke(iconFrame, accent, 1, 0.66)
    local iconGlow = new("Frame", {
        Name = "IconGlow",
        Size = UDim2.new(1, 10, 1, 10),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundColor3 = accent,
        BackgroundTransparency = 0.92,
        BorderSizePixel = 0,
        ZIndex = 321,
        Parent = iconFrame,
    })
    corner(iconGlow, 18)

    new("TextLabel", {
        Name = "Icon",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = icon,
        TextColor3 = accent,
        TextTransparency = 0.03,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 323,
        Parent = iconFrame,
    })

    local titleText = tostring(config.Title or "Notification")
    local subtitleText = tostring(config.Subtitle or "")
    local title = new("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -82, 0, subtitleText == "" and 32 or 22),
        Position = UDim2.fromOffset(68, subtitleText == "" and 25 or 18),
        BackgroundTransparency = 1,
        Text = titleText,
        TextColor3 = Color3.fromRGB(240, 243, 255),
        TextTransparency = 0.02,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 323,
        Parent = card,
    })

    if subtitleText ~= "" then
        new("TextLabel", {
            Name = "Subtitle",
            Size = UDim2.new(1, -82, 0, 32),
            Position = UDim2.fromOffset(68, 42),
            BackgroundTransparency = 1,
            Text = subtitleText,
            TextColor3 = Color3.fromRGB(154, 162, 190),
            TextTransparency = 0.12,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextWrapped = true,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            ZIndex = 323,
            Parent = card,
        })
    else
        title.TextSize = 14
    end

    local progressTrack = new("Frame", {
        Name = "LifetimeTrack",
        Size = UDim2.new(1, -28, 0, 1),
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -8),
        BackgroundColor3 = Color3.fromRGB(80, 88, 118),
        BackgroundTransparency = 0.72,
        BorderSizePixel = 0,
        ZIndex = 324,
        Parent = card,
    })
    corner(progressTrack, 1)

    local progressFill = new("Frame", {
        Name = "LifetimeIndicator",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = accent,
        BackgroundTransparency = 0.18,
        BorderSizePixel = 0,
        ZIndex = 325,
        Parent = progressTrack,
    })
    corner(progressFill, 1)
    gradient(
        progressFill,
        ColorSequence.new(Color3.fromRGB(245, 247, 255), accent),
        0,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.12),
            NumberSequenceKeypoint.new(1, 0.36),
        })
    )

    local toast = { Gui = wrapper, Card = card, Scale = wrapperScale, Token = os.clock(), Removing = false }
    table.insert(State.Toasts, 1, toast)
    reflowToasts()
    tween(wrapper, TweenInfoSet.Toast, {
        Position = getToastPosition(1, false),
        GroupTransparency = 0,
    })
    tween(wrapperScale, TweenInfoSet.Toast, { Scale = 1 })

    local duration = math.max(tonumber(config.Duration) or 3, 0.5)
    toast.ProgressTween = tween(
        progressFill,
        TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 0, 1, 0) }
    )
    if toast.ProgressTween then
        toast.ProgressTween.Completed:Once(function()
            if not State.Destroyed then
                removeToast(toast)
            end
        end)
    else
        task.delay(duration, function()
            if not State.Destroyed then
                removeToast(toast)
            end
        end)
    end

    return wrapper
end
local function cleanupVisuals()
    disconnect(State.LoadingConnection)
    State.LoadingConnection = nil
    disconnect(State.ScriptLoaderConnection)
    State.ScriptLoaderConnection = nil
    disconnect(State.CameraViewportConnection)
    State.CameraViewportConnection = nil

    for _, connection in ipairs(State.Connections) do
        disconnect(connection)
    end
    table.clear(State.Connections)

    for _, tweenObject in ipairs(State.Tweens) do
        cancelTween(tweenObject)
    end
    table.clear(State.Tweens)

    if UI.Blur then
        pcall(function()
            UI.Blur:Destroy()
        end)
        UI.Blur = nil
    end
    if UI.ScreenGui then
        pcall(function()
            UI.ScreenGui:Destroy()
        end)
        UI.ScreenGui = nil
    end
    table.clear(State.Toasts)
    table.clear(State.ToastQueue)
    table.clear(UI)
    State.Destroyed = true
end

function Loader:Close(callback)
    if State.Destroyed then
        if type(callback) == "function" then
            task.defer(callback)
        end
        return self
    end
    if not State.Open then
        if type(callback) == "function" then
            task.defer(callback)
        end
        return self
    end

    State.Open = false
    State.Validating = false
    State.ScriptLoaderActive = false
    State.ScriptLoaderTransitioning = false
    setInputLocked(true)
    disconnect(State.LoadingConnection)
    State.LoadingConnection = nil
    disconnect(State.ScriptLoaderConnection)
    State.ScriptLoaderConnection = nil

    if UI.ValidationOverlay then
        setProperty(UI.ValidationOverlay, "Visible", false)
    end
    if UI.Blur then
        tween(UI.Blur, TweenInfoSet.Close, { Size = 0 })
    end
    if UI.Root then
        tween(UI.Root, TweenInfoSet.Close, { BackgroundTransparency = 1 })
    end
    if UI.WindowScale then
        tween(UI.WindowScale, TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Scale = math.max((State.ScaleTarget or 1) * 0.982, 0.01),
        })
    end

    local function finalizeClose()
        cleanupVisuals()
        if type(callback) == "function" then
            callback()
        end
    end

    if UI.Window then
        local closeTween = tween(UI.Window, TweenInfoSet.Close, { GroupTransparency = 1 })
        if closeTween then
            local connected = pcall(function()
                closeTween.Completed:Once(finalizeClose)
            end)
            if not connected then
                task.delay(TweenInfoSet.Close.Time, finalizeClose)
            end
        else
            finalizeClose()
        end
    else
        finalizeClose()
    end
    return self
end

function Loader:Destroy()
    if State.Destroyed then
        return self
    end
    State.Open = false
    State.Validating = false
    cleanupVisuals()
    return self
end

buildInterface()

return Loader
