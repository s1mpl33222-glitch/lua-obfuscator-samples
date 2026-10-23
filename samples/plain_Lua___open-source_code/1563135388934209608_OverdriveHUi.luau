-- Clean-room dashboard UI inspired by measurements of a bottom-navigation layout.
-- Source parts are concatenated in manifest order; they are not runtime modules.

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")

local LocalPlayer = Players.LocalPlayer
local GLOBAL_ENV = type(getgenv) == "function" and getgenv() or _G

local LIBRARY_NAME = "OverdriveHUi"
local LIBRARY_VERSION = "1.0.0"
-- The live surface is authored at 600x300 and displayed through its measured UIScale.
-- Keeping those authored dimensions matters because all of its tween targets and
-- navigation coordinates are expressed in this space.
local DESIGN_WIDTH = 600
local DESIGN_HEIGHT = 300
local OPENING_HEIGHT = 320
local SHELL_SEQUENCE_DELAY = 3.112
local DASHBOARD_REVEAL_DELAY = 12.533
local DESIGN_SCALE = 1.46449995040894

local OverdriveHUi = {
    Name = LIBRARY_NAME,
    Version = LIBRARY_VERSION,
}

local activeWindows = {}
local nextWindowId = 0

local createWindow
local createTab
local createDashboardTab
local createSection
local selectTab
local refreshNavigationCanvas
local refreshNavigationSelectionStyle
local refreshWindowScale
local createNotification
local attachTabShortcuts
local createDelayedHeaderSurface
local materializeDashboardSurface
local finalizeWindowReady

local function copyTable(source)
    local result = {}
    for key, value in pairs(source or {}) do
        if type(value) == "table" then
            result[key] = copyTable(value)
        else
            result[key] = value
        end
    end
    return result
end

local function mergeTable(base, overrides)
    local result = copyTable(base)
    for key, value in pairs(type(overrides) == "table" and overrides or {}) do
        if type(value) == "table" and type(result[key]) == "table" then
            result[key] = mergeTable(result[key], value)
        else
            result[key] = value
        end
    end
    return result
end

local function normalizeOptions(options, fallbackLabel)
    if type(options) == "string" then
        return {label = options, title = options, name = options}
    end
    options = type(options) == "table" and options or {}
    if fallbackLabel and options.label == nil and options.title == nil and options.name == nil then
        options.label = fallbackLabel
    end
    return options
end

local function make(className, properties, parent)
    local object = Instance.new(className)
    for property, value in pairs(properties or {}) do
        object[property] = value
    end
    object.Parent = parent
    return object
end

local function addCorner(parent, radius)
    return make("UICorner", {
        Name = "Corner",
        CornerRadius = UDim.new(0, radius or 8),
    }, parent)
end

local function addStroke(parent, color, thickness, transparency)
    return make("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = color,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
    }, parent)
end

local function addPadding(parent, left, right, top, bottom)
    return make("UIPadding", {
        PaddingLeft = UDim.new(0, left or 0),
        PaddingRight = UDim.new(0, right or left or 0),
        PaddingTop = UDim.new(0, top or left or 0),
        PaddingBottom = UDim.new(0, bottom or top or left or 0),
    }, parent)
end

local function addGradient(parent, color, rotation, transparency)
    return make("UIGradient", {
        Name = "Gradient",
        Color = color,
        Rotation = rotation or 0,
        Transparency = transparency or NumberSequence.new(0),
    }, parent)
end

local function trackConnection(window, connection)
    if connection then
        table.insert(window._connections, connection)
    end
    return connection
end

local function disconnectAll(window)
    for index = #window._connections, 1, -1 do
        local connection = window._connections[index]
        window._connections[index] = nil
        pcall(function()
            connection:Disconnect()
        end)
    end
end

local function invoke(callback, ...)
    if type(callback) ~= "function" then
        return
    end
    local arguments = table.pack(...)
    task.spawn(function()
        local ok, err = pcall(callback, table.unpack(arguments, 1, arguments.n))
        if not ok then
            warn("[" .. LIBRARY_NAME .. "] callback failed: " .. tostring(err))
        end
    end)
end

local function tween(object, duration, properties, style, direction)
    local animation = TweenService:Create(object, TweenInfo.new(
        duration or 0.18,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    ), properties)
    animation:Play()
    return animation
end

local function resolveGuiParent(configuredParent)
    if typeof(configuredParent) == "Instance" then
        return configuredParent
    end

    if type(gethui) == "function" then
        local ok, hiddenUi = pcall(gethui)
        if ok and typeof(hiddenUi) == "Instance" then
            -- Some executors return RobloxGui itself instead of a Folder/CoreGui.
            -- A ScreenGui nested inside another ScreenGui exists but does not render.
            if hiddenUi:IsA("ScreenGui") and hiddenUi.Parent then
                return hiddenUi.Parent
            end
            return hiddenUi
        end
    end

    local ok = pcall(function()
        return CoreGui.Name
    end)
    if ok then
        return CoreGui
    end

    return LocalPlayer:WaitForChild("PlayerGui")
end

local function protectScreenGui(screenGui)
    if type(syn) == "table" and type(syn.protect_gui) == "function" then
        pcall(syn.protect_gui, screenGui)
    elseif type(GLOBAL_ENV.protectgui) == "function" then
        pcall(GLOBAL_ENV.protectgui, screenGui)
    end
end

local function setButtonFeedback(button, baseColor, hoverColor, window)
    trackConnection(window, button.MouseEnter:Connect(function()
        tween(button, 0.14, {BackgroundColor3 = hoverColor})
    end))
    trackConnection(window, button.MouseLeave:Connect(function()
        tween(button, 0.14, {BackgroundColor3 = baseColor})
    end))
end

local function bindAutomaticCanvas(window, scrollingFrame, layout, extraPadding)
    local function refresh()
        if scrollingFrame.Parent then
            scrollingFrame.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + (extraPadding or 0))
        end
    end
    trackConnection(window, layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refresh))
    task.defer(refresh)
end

local function getViewportSize()
    local camera = workspace.CurrentCamera
    if camera then
        return camera.ViewportSize
    end
    return Vector2.new(DESIGN_WIDTH + 40, DESIGN_HEIGHT + 40)
end
local ASSET_BASE_URL = "https://raw.githubusercontent.com/HELLOWORLDIMASKID/overdrive-h-ui/main/Assets/OverdriveH/"
local ASSET_CACHE_ROOT = "OverdriveHUi/assets-v1"
local assetCache = {}

local function getExecutorFunction(name)
    local value = type(GLOBAL_ENV) == "table" and rawget(GLOBAL_ENV, name) or nil
    if type(value) == "function" then
        return value
    end
    value = type(_G) == "table" and rawget(_G, name) or nil
    return type(value) == "function" and value or nil
end

local function ensureAssetCache()
    local makeFolder = getExecutorFunction("makefolder")
    if not makeFolder then
        return
    end
    pcall(makeFolder, "OverdriveHUi")
    pcall(makeFolder, ASSET_CACHE_ROOT)
end

local function isSupportedImageBody(body)
    return type(body) == "string" and (
        string.sub(body, 1, 8) == "\137PNG\r\n\26\n"
        or string.sub(body, 1, 3) == "\255\216\255"
    )
end

local function resolveAsset(filename)
    if assetCache[filename] then
        return assetCache[filename]
    end

    local path = ASSET_CACHE_ROOT .. "/" .. filename
    local isFile = getExecutorFunction("isfile")
    local writeFile = getExecutorFunction("writefile")
    local getAsset = getExecutorFunction("getcustomasset") or getExecutorFunction("getsynasset")
    local present = false
    if isFile then
        local ok, exists = pcall(isFile, path)
        present = ok and exists == true
    end

    if not present and writeFile then
        ensureAssetCache()
        local ok, body = pcall(function()
            return game:HttpGet(ASSET_BASE_URL .. filename)
        end)
        if ok and isSupportedImageBody(body) then
            present = pcall(writeFile, path, body)
        end
    end

    if present and getAsset then
        local ok, contentId = pcall(getAsset, path)
        if ok and type(contentId) == "string" and contentId ~= "" then
            assetCache[filename] = contentId
            return contentId
        end
    end

    local fallback = ASSET_BASE_URL .. filename
    assetCache[filename] = fallback
    warn("[" .. LIBRARY_NAME .. "] could not register " .. filename .. "; getcustomasset and filesystem APIs are required")
    return fallback
end

local DEFAULT_THEME = {
    background = Color3.fromRGB(0, 20, 40),
    backgroundSecondary = Color3.fromRGB(4, 10, 24),
    surface = Color3.fromRGB(20, 20, 20),
    surfaceRaised = Color3.fromRGB(45, 45, 45),
    surfaceHover = Color3.fromRGB(25, 23, 100),
    text = Color3.new(1, 1, 1),
    textMuted = Color3.fromRGB(150, 150, 150),
    textDim = Color3.fromRGB(92, 92, 92),
    success = Color3.fromRGB(0, 255, 0),
    cyan = Color3.fromRGB(0, 170, 255),
    teal = Color3.fromRGB(34, 211, 126),
    magenta = Color3.fromRGB(120, 40, 120),
    blue = Color3.fromRGB(20, 20, 140),
    danger = Color3.fromRGB(245, 79, 108),
    warning = Color3.fromRGB(255, 194, 64),
    stroke = Color3.fromRGB(120, 40, 120),
    shadow = Color3.fromRGB(0, 0, 0),
}

local DEFAULT_ICONS = {
    dashboard = resolveAsset("creation_date.png"),
    changelogs = resolveAsset("creation_date.png"),
    home = resolveAsset("house.png"),
    main = resolveAsset("house.png"),
    visuals = resolveAsset("eye.png"),
    world = resolveAsset("world.png"),
    premium = resolveAsset("diamond.png"),
    effects = resolveAsset("glowing_star.png"),
    exclusive = resolveAsset("glowing_star.png"),
    combat = resolveAsset("combat.png"),
    farm = resolveAsset("money.png"),
    settings = resolveAsset("cogwheel.png"),
    plugins = resolveAsset("puzzle.png"),
    error = resolveAsset("error.png"),
    minimize = resolveAsset("arrow_down_right.png"),
    close = resolveAsset("arrow_down_right.png"),
    account = resolveAsset("avatar.png"),
    fps = resolveAsset("lightning.png"),
    latency = resolveAsset("wifi.png"),
    logo = resolveAsset("title.png"),
    arrow = "›",
    check = "✓",
}

local function resolveTheme(overrides)
    return mergeTable(DEFAULT_THEME, overrides)
end

local function resolveIcon(icons, value, fallback)
    if type(value) == "string" and value ~= "" then
        return icons[value] or value
    end
    return icons[fallback] or "•"
end

local function createNeonStroke(parent, theme, thickness, transparency, window, initialRotation)
    local stroke = addStroke(parent, Color3.new(1, 1, 1), thickness or 1.5, transparency or 0)
    stroke.Name = "Stroke"
    local gradient = addGradient(stroke, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
        ColorSequenceKeypoint.new(0.75, theme.blue),
        ColorSequenceKeypoint.new(1, theme.magenta),
    }), 0)
    gradient.Name = "Gradient"
    gradient.Rotation = tonumber(initialRotation) or 0
    local connection = RunService.RenderStepped:Connect(function()
        if gradient.Parent then gradient.Rotation += 2 end
    end)
    if window then trackConnection(window, connection) end
    return stroke
end

local function createSurface(parent, theme, radius, transparency)
    local surface = make("Frame", {
        BackgroundColor3 = theme.surface,
        BackgroundTransparency = transparency or 0.12,
        BorderSizePixel = 0,
    }, parent)
    addCorner(surface, radius or 5)
    return surface
end
local function createTextLabel(parent, properties)
    local label = make("TextLabel", {
        BackgroundTransparency = 1,
        BorderSizePixel = 1,
        Font = Enum.Font.Jura,
        Text = "",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    }, parent)
    for property, value in pairs(properties or {}) do
        label[property] = value
    end
    return label
end

local function createIconLabel(parent, icon, theme, properties)
    properties = properties or {}
    if type(icon) == "string" and string.find(icon, "^rbxasset") then
        local image = make("ImageLabel", {
            BackgroundTransparency = 1,
            BorderSizePixel = 1,
            Image = icon,
            ImageColor3 = properties.TextColor3 or properties.ImageColor3 or theme.teal,
            ScaleType = Enum.ScaleType.Fit,
        }, parent)
        for property, value in pairs(properties) do
            if property ~= "TextColor3" and property ~= "TextSize" and property ~= "Font" then
                image[property] = value
            end
        end
        return image
    end
    return createTextLabel(parent, mergeTable({
        Font = Enum.Font.GothamBold,
        Text = icon,
        TextColor3 = theme.teal,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Center,
    }, properties))
end

refreshWindowScale = function(window)
    if window._destroyed or not window._scale.Parent then
        return
    end
    if window._scaleOverride then
        window._scale.Scale = window._scaleOverride
        return
    end
    if not window._adaptiveScale then
        window._scale.Scale = DESIGN_SCALE
        return
    end
    local viewport = getViewportSize()
    local fitX = math.max(0.35, (viewport.X - 24) / DESIGN_WIDTH)
    local fitY = math.max(0.35, (viewport.Y - 24) / DESIGN_HEIGHT)
    window._scale.Scale = math.min(DESIGN_SCALE, fitX, fitY)
end

local function enableWindowDragging(window, handle)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPosition = nil

    trackConnection(window, handle.InputBegan:Connect(function(input)
        if window._minimized then return end
        local kind = input.UserInputType
        if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end
        dragging = true
        dragStart = input.Position
        startPosition = window._main.Position
        trackConnection(window, input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end))
    end))
    trackConnection(window, handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end))
    trackConnection(window, UserInputService.InputChanged:Connect(function(input)
        if not dragging or input ~= dragInput or not dragStart or not startPosition then return end
        local divisor = math.max(window._scale.Scale, 0.01)
        local delta = (input.Position - dragStart) / divisor
        window._main.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end))
end

local function createAccountPanel(window, parent, options, decorators)
    local theme = window._theme
    local panel = make("CanvasGroup", {
        Name = "Identity",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = theme.surface,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 1,
        ClipsDescendants = true,
        GroupTransparency = 0,
        Position = UDim2.new(0.70, 0, 0.10, 0),
        Size = UDim2.fromOffset(175, 40),
    }, parent)
    addCorner(panel, 5)
    local avatar = make("ImageLabel", {
        Name = "Icon",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 1,
        Image = options.accountImage or resolveIcon(window._icons, nil, "account"),
        Position = UDim2.fromScale(0.865, 0.5),
        ScaleType = Enum.ScaleType.Stretch,
        Size = UDim2.fromOffset(33, 33),
    }, panel)
    local status = createTextLabel(panel, {
        Name = "Title",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.55, 0.15),
        Size = UDim2.fromOffset(0, 0),
        Text = options.accountCaption or "Logged in as",
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Center,
    })
    local username = createTextLabel(panel, {
        Name = "Header",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.45, 0.55),
        Size = UDim2.fromOffset(100, 30),
        Text = options.username or (LocalPlayer and LocalPlayer.Name or "Player"),
        TextColor3 = Color3.new(1, 1, 1),
        TextScaled = true,
        TextSize = 8,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Right,
    })
    table.insert(decorators, function()
        addGradient(username, ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 211, 126)),
            ColorSequenceKeypoint.new(0.6, Color3.fromRGB(59, 130, 127)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 130, 128)),
        }), 0)
        createNeonStroke(panel, theme, 1.5, 0, window)
    end)
    window._accountRefs = {panel = panel, status = status, username = username, avatar = avatar}
end

local function createIntroDecorations(window, parent, options)
    local gradientColor = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 211, 126)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(59, 130, 127)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 130, 128)),
    })
    local gameIcon = make("ImageLabel", {
        Name = "GameIcon", AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1,
        BorderSizePixel = 1, Image = options.gameIcon or "rbxassetid://78058287554916",
        ImageTransparency = window._motionEnabled and 0.8 or 1, Position = UDim2.fromScale(0.5, 0.5),
        ScaleType = Enum.ScaleType.Stretch,
        Size = window._motionEnabled and UDim2.fromOffset(85, 85) or UDim2.fromOffset(55, 55),
        ZIndex = 1,
    }, parent)
    local gameIconCorner = make("UICorner", {
        Name = "Corner",
        CornerRadius = window._motionEnabled and UDim.new(0, 8) or UDim.new(0, 20),
    }, gameIcon)
    local function circle(name, initialSize, finalSize, initialTransparency, backgroundTransparency)
        local object = make("ImageLabel", {
            Name = name, AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = backgroundTransparency, BorderSizePixel = 1,
            Image = resolveAsset("circle.png"), ImageTransparency = window._motionEnabled and initialTransparency or 1,
            Position = UDim2.fromScale(0.5, 0.5), ScaleType = Enum.ScaleType.Stretch,
            Size = UDim2.fromOffset(window._motionEnabled and initialSize or finalSize, window._motionEnabled and initialSize or finalSize),
            ZIndex = 1,
        }, parent)
        addGradient(object, gradientColor, 0)
        return object
    end
    return {
        gameIcon = gameIcon,
        gameIconCorner = gameIconCorner,
        circle1 = circle("RotatingCircle1", 210, 400, 0.5, 1),
        circle2 = circle("RotatingCircle2", 420, 500, 0.8, 0.999),
    }
end

local function createHeader(window, parent, options)
    -- The original header controls are direct MainCanva children. Keeping a
    -- synthetic full-size Header frame changes both the descendant contract and
    -- clipping/stacking behavior, so the canvas itself is the header parent.
    local header = parent

    local titleImage = make("ImageLabel", {
        Name = "Title",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = resolveIcon(window._icons, options.logoIcon, "logo"),
        Position = window._motionEnabled and UDim2.fromScale(0.5, 0.15) or UDim2.new(0.125, 0, 0.10, 0),
        ScaleType = Enum.ScaleType.Stretch,
        Size = window._motionEnabled and UDim2.fromOffset(280, 280) or UDim2.fromOffset(125, 125),
        ZIndex = 1,
    }, header)
    window._introRefs = nil
    if not window._motionEnabled then
        window._introRefs = createIntroDecorations(window, header, options)
    end

    window._header = parent
    window._titleImage = titleImage
    enableWindowDragging(window, parent.Parent)
end

createDelayedHeaderSurface = function(window, parent, options, decorators)
    local theme = window._theme
    local versionLabel = createTextLabel(parent, {
        Name = "Version",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.035, 0.035),
        Size = UDim2.fromOffset(0, 0),
        RichText = true,
        Text = options.versionText or 'v3.5 | Murder Mystery 2 | <font color="rgb(0, 255, 0)">.gg/overdrivehub</font>',
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 13,
        ZIndex = 1,
    })

    local minimize = make("ImageButton", {
        Name = "Minimize",
        AnchorPoint = Vector2.new(0.5, 0.5),
        AutoButtonColor = false,
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 1,
        Image = "",
        Position = UDim2.new(0.91, 0, 0.10, 0),
        ScaleType = Enum.ScaleType.Stretch,
        Size = UDim2.fromOffset(40, 40),
        ZIndex = 1,
    }, parent)
    addCorner(minimize, 5)
    local placeholder = make("ImageLabel", {
        Name = "Placeholder",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 1,
        Image = resolveIcon(window._icons, options.closeIcon or options.minimizeIcon, "minimize"),
        Position = UDim2.fromScale(0.5, 0.5),
        ScaleType = Enum.ScaleType.Stretch,
        Size = UDim2.fromScale(0.5, 0.5),
        ZIndex = 1,
    }, minimize)
    createAccountPanel(window, parent, options, decorators)
    table.insert(decorators, function()
        createNeonStroke(minimize, theme, 1.5, 0, window)
    end)
    trackConnection(window, minimize.MouseButton1Click:Connect(function()
        window.Close()
    end))

    window._versionLabel = versionLabel
    window._closeButton = minimize
    window._minimizeButton = minimize
    return versionLabel, minimize, placeholder
end

local function createBackdrop(window, parent)
    local theme = window._theme
    local backdrop = make("ImageLabel", {
        Name = "MainCanva",
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 1,
        Image = resolveAsset("borealis_sprites_sheet.png"),
        ImageRectOffset = Vector2.new(819.2, 0),
        ImageRectSize = Vector2.new(204.8, 129.4336),
        ImageTransparency = 0.15,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        ClipsDescendants = false,
        ScaleType = Enum.ScaleType.Stretch,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 1,
    }, parent)
    addGradient(backdrop, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 20, 40)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 85, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 128)),
    }), 0)
    window._mainStroke = createNeonStroke(parent, theme, 1.5, 0, window, 0)
    local frameIndex = 0
    local elapsed = 0
    trackConnection(window, RunService.RenderStepped:Connect(function(deltaTime)
        elapsed += deltaTime
        while elapsed >= 0.05 do
            elapsed -= 0.05
            frameIndex = (frameIndex + 1) % 20
            local column = frameIndex % 5
            local row = math.floor(frameIndex / 5)
            if window._useSpriteSheet then
                backdrop.ImageRectSize = Vector2.new(204.8, 129.43359375)
                backdrop.ImageRectOffset = Vector2.new(column * 204.8, row * 129.43359375)
            end
        end
    end))
    return backdrop
end

local function createNotifications(window, screenGui)
    local notifications = make("Frame", {
        Name = "Notifications",
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -14, 0, 14),
        Size = UDim2.fromOffset(300, 360),
    }, screenGui)
    make("UIListLayout", {HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, notifications)
    return notifications
end

finalizeWindowReady = function(window)
    if window._destroyed or window._ready or window._readyStarted or not window._dashboardMaterialized then
        return
    end
    window._readyStarted = true
    task.defer(function()
        if window._destroyed then return end
        local preload = {}
        for _, descendant in ipairs(window._screenGui:GetDescendants()) do
            if descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
                table.insert(preload, descendant)
            end
        end
        pcall(ContentProvider.PreloadAsync, ContentProvider, preload)
        if not window._destroyed and not window._ready then
            window._ready = true
            window._readyEvent:Fire(window)
        end
    end)
end

createWindow = function(options)
    options = normalizeOptions(options)
    local createdAt = os.clock()
    nextWindowId += 1
    local readyEvent = Instance.new("BindableEvent")
    local window = {
        _id = nextWindowId,
        _connections = {}, _tabs = {}, _tabOrder = {}, _selectedTab = nil,
        _destroyed = false, _visible = true, _minimized = false, _onOverview = true,
        _ready = false, _readyEvent = readyEvent, _motionEnabled = options.motionEnabled ~= false,
        _dashboardRevealDelay = options.motionEnabled == false and 0 or DASHBOARD_REVEAL_DELAY,
        _createdAt = createdAt, _surfacePending = {}, _pendingNavigationButtons = {},
        _dashboardMaterialized = false, _readyStarted = false,
        _useSpriteSheet = true, _adaptiveScale = options.adaptiveScale == true,
        _theme = resolveTheme(options.theme), _icons = mergeTable(DEFAULT_ICONS, options.icons), _options = options,
    }
    window._surfaceRevealAt = createdAt + window._dashboardRevealDelay
    window._navigationRevealAt = window._surfaceRevealAt

    local screenGui = make("ScreenGui", {
        Name = options.guiName or "",
        DisplayOrder = options.displayOrder or 0,
        IgnoreGuiInset = false,
        ResetOnSpawn = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() screenGui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets end)
    pcall(function() screenGui.ClipToDeviceSafeArea = true end)
    pcall(function() screenGui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.FullscreenExtension end)
    protectScreenGui(screenGui)
    screenGui.Parent = resolveGuiParent(options.parent)

    -- The complete constructor series fits a 0.85 second Cubic Out tween from
    -- 0x0/transparent to 600x300/opaque. The root corner then resolves from a
    -- pill to the measured eight-pixel radius over another 0.5 seconds.
    local openingSize = window._motionEnabled
        and UDim2.fromOffset(0, 0)
        or UDim2.fromOffset(DESIGN_WIDTH, DESIGN_HEIGHT)
    local main = make("CanvasGroup", {
        Name = "OverdriveRoot",
        Active = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        GroupTransparency = window._motionEnabled and 1 or 0,
        Position = UDim2.new(0.5, window._motionEnabled and 0 or (options.offsetX or 3), 0.5, window._motionEnabled and 0 or (options.offsetY or 1)),
        Size = openingSize,
    }, screenGui)
    local mainCorner = make("UICorner", {
        CornerRadius = window._motionEnabled and UDim.new(1, 0) or UDim.new(0, 8),
    }, main)
    local scale = make("UIScale", {Scale = DESIGN_SCALE}, main)
    window._backdrop = createBackdrop(window, main)
    local backdrop = window._backdrop

    -- Dashboard objects are direct MainCanva children in the original hierarchy.
    local overview = backdrop
    createHeader(window, backdrop, options)

    window._screenGui = screenGui
    window._main = main
    window._scale = scale
    window._overview = overview
    window._dashboardObjects = {}
    window._statRefs = {}
    window._pages = nil
    window._content = nil
    window._notifications = createNotifications(window, screenGui)

    window.GetScreenGui = function() return window._screenGui end
    window.GetMainFrame = function() return window._main end
    window.GetSelectedTab = function() return window._selectedTab end
    window.GetTab = function(id) return window._tabs[tostring(id)] end
    window.GetPosition = function() return window._main.Position end
    window.SetPosition = function(position)
        if typeof(position) == "UDim2" then window._main.Position = position end
        return window._main.Position
    end
    window.SetScale = function(scaleValue)
        local numeric = tonumber(scaleValue)
        window._scaleOverride = numeric and math.clamp(numeric, 0.35, 3) or nil
        refreshWindowScale(window)
        return window._scale.Scale
    end
    window.SetAdaptiveScale = function(enabled)
        window._adaptiveScale = enabled == true
        window._scaleOverride = nil
        refreshWindowScale(window)
        return window._scale.Scale
    end
    window.SetMotionEnabled = function(enabled) window._motionEnabled = enabled == true end
    window.SetVersion = function(value)
        local text = tostring(value or "")
        if window._versionLabel then window._versionLabel.Text = text else window._surfacePending.version = text end
    end
    window.SetLogo = function(value) window._titleImage.Image = tostring(value or "") end
    window.SetTitle = window.SetLogo
    window.SetBackground = function(value, spriteSheet)
        window._backdrop.Image = tostring(value or "")
        window._useSpriteSheet = spriteSheet == true
        if not window._useSpriteSheet then
            window._backdrop.ImageRectOffset = Vector2.zero
            window._backdrop.ImageRectSize = Vector2.zero
        end
    end
    window.SetNavigationHint = function(value)
        local text = tostring(value or "")
        if window._instruction then window._instruction.Text = text else window._surfacePending.navigationHint = text end
    end
    window.ScrollToTab = function(tabOrId)
        local tab = type(tabOrId) == "table" and tabOrId or window._tabs[tostring(tabOrId)]
        if not tab then
            for _, candidate in ipairs(window._tabOrder) do
                if candidate.title == tabOrId then tab = candidate break end
            end
        end
        if not tab then return false end
        if not window._navigation then
            window._surfacePending.scrollTab = tab
            return true
        end
        local scaleValue = window._scale.Scale
        local targetX = math.max(0, (tab.order - 1) * 53 * scaleValue)
        local contentWidth = (#window._tabOrder * 53 + 1) * scaleValue
        local maximum = math.max(0, contentWidth - window._navigation.AbsoluteSize.X)
        window._navigation.CanvasPosition = Vector2.new(math.min(targetX, maximum), 0)
        return true
    end
    window.Ready = readyEvent.Event
    window.IsReady = function() return window._ready end
    window.IsVisible = function() return window._visible and not window._destroyed end
    window.SetMinimized = function(minimized)
        if window._destroyed then return end
        minimized = minimized == true
        if not window._minimizeButton then
            window._surfacePending.minimized = minimized
            return
        end
        if minimized == window._minimized then return end
        window._minimized = minimized
        local duration = window._motionEnabled and 0.5 or 0
        if minimized then
            window._restorePosition = window._main.Position
            tween(window._minimizeButton, duration, {Position = UDim2.fromScale(0.5, 0.5)}, Enum.EasingStyle.Sine)
            tween(window._main, duration, {
                Position = UDim2.new(1, -46, 1, -46),
                Size = UDim2.fromOffset(40, 40),
                BackgroundTransparency = 1,
            }, Enum.EasingStyle.Sine)
        else
            tween(window._main, duration, {
                Position = window._restorePosition or UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(DESIGN_WIDTH, DESIGN_HEIGHT),
                BackgroundTransparency = 1,
            }, Enum.EasingStyle.Sine)
            tween(window._minimizeButton, duration, {Position = UDim2.new(0.91, 0, 0.10, 0)}, Enum.EasingStyle.Sine)
        end
    end
    window.SetVisible = function(visible)
        if window._destroyed then return end
        window._visible = visible == true
        window._screenGui.Enabled = window._visible
    end
    window.Toggle = function() window.SetVisible(not window.IsVisible()) end
    window.SetAccount = function(account)
        account = type(account) == "table" and account or {}
        local refs = window._accountRefs
        if not refs then
            window._surfacePending.account = copyTable(account)
            return
        end
        if account.caption ~= nil then refs.status.Text = tostring(account.caption) end
        if account.username ~= nil then refs.username.Text = tostring(account.username) end
        if account.image ~= nil then refs.avatar.Image = tostring(account.image) end
    end
    window.SetWhitelist = function(text, progress)
        if not window._dashboardRefs then
            window._surfacePending.whitelist = {text = text, progress = progress}
            return
        end
        window._dashboardRefs.whitelist.Text = 'Whitelist Duration: <font color="rgb(0, 255, 0)">'..tostring(text or "Unlimited")..'</font>'
        tween(window._dashboardRefs.progress, 0.25, {Size = UDim2.new(math.clamp(tonumber(progress) or 1, 0, 1), 0, 1, 0)})
    end
    window.SetStat = function(id, value, caption)
        local stat = window._statRefs and window._statRefs[id]
        if not stat then
            if id == "fps" or id == "latency" then
                window._surfacePending["stat_" .. id] = {value = value, caption = caption}
            end
            return
        end
        stat.value.Text = tostring(value)
        if caption ~= nil then stat.caption.Text = tostring(caption) end
    end
    window.SetProfile = function(profileOptions)
        profileOptions = type(profileOptions) == "table" and profileOptions or {}
        local profile = window._dashboardRefs and window._dashboardRefs.profile
        if not profile then
            window._surfacePending.profile = copyTable(profileOptions)
            return
        end
        if profileOptions.avatar ~= nil then profile.avatar.Image = tostring(profileOptions.avatar) end
        if profileOptions.displayName ~= nil then profile.displayName.Text = tostring(profileOptions.displayName) end
        if profileOptions.handle ~= nil then profile.handle.Text = tostring(profileOptions.handle) end
        if profileOptions.plan ~= nil then profile.plan.Text = '<font color="rgb(0, 0, 255)">'..tostring(profileOptions.plan)..'</font>' end
    end
    window._flushPendingSurface = function()
        local pending = window._surfacePending
        window._surfacePending = {}
        if pending.version ~= nil then window.SetVersion(pending.version) end
        if pending.account ~= nil then window.SetAccount(pending.account) end
        if pending.profile ~= nil then window.SetProfile(pending.profile) end
        if pending.whitelist ~= nil then window.SetWhitelist(pending.whitelist.text, pending.whitelist.progress) end
        if pending.stat_fps ~= nil then window.SetStat("fps", pending.stat_fps.value, pending.stat_fps.caption) end
        if pending.stat_latency ~= nil then window.SetStat("latency", pending.stat_latency.value, pending.stat_latency.caption) end
        if pending.navigationHint ~= nil then window.SetNavigationHint(pending.navigationHint) end
        if pending.scrollTab ~= nil then window.ScrollToTab(pending.scrollTab) end
        if pending.minimized ~= nil then window.SetMinimized(pending.minimized) end
    end
    window.CreateTab = function(tabOptions) return createTab(window, tabOptions) end
    window.createTab = window.CreateTab
    window.SelectTab = function(tabOrId) return selectTab(window, tabOrId) end
    window.Notify = function(notificationOptions) return createNotification(window, notificationOptions) end
    window.Unload = function()
        if window._destroyed then return end
        window._destroyed = true window._visible = false
        disconnectAll(window) activeWindows[window._id] = nil
        if window._screenGui then window._screenGui:Destroy() end
        if window._readyEvent then window._readyEvent:Destroy() end
        invoke(options.onUnload)
    end
    window.Destroy = window.Unload
    window.Close = function()
        if window._destroyed or window._closing then return end
        window._closing = true
        local duration = window._motionEnabled and 0.5 or 0
        tween(window._main, duration, {Size = UDim2.fromOffset(0, 0)}, Enum.EasingStyle.Sine)
        task.delay(duration, function()
            if not window._destroyed then window.Unload() end
        end)
    end

    local function bindCamera()
        refreshWindowScale(window)
        local camera = workspace.CurrentCamera
        if camera then trackConnection(window, camera:GetPropertyChangedSignal("ViewportSize"):Connect(function() refreshWindowScale(window) end)) end
    end
    trackConnection(window, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera))
    bindCamera()

    local toggleKey = options.toggleKey
    if toggleKey == nil then toggleKey = Enum.KeyCode.RightShift end
    if typeof(toggleKey) == "EnumItem" then
        trackConnection(window, UserInputService.InputBegan:Connect(function(input, processed)
            if not processed and input.KeyCode == toggleKey and not UserInputService:GetFocusedTextBox() then window.Toggle() end
        end))
    end

    activeWindows[window._id] = window
    createDashboardTab(window, options.dashboard)
    if window._motionEnabled then
        tween(main, 0.85, {
            GroupTransparency = 0,
            Size = UDim2.fromOffset(DESIGN_WIDTH, OPENING_HEIGHT),
        }, Enum.EasingStyle.Cubic)
        task.delay(0.5, function()
            if not window._destroyed and window._titleImage.Parent then
                tween(window._titleImage, 0.5, {
                    Position = UDim2.new(0.125, 0, 0.10, 0),
                    Size = UDim2.fromOffset(125, 125),
                }, Enum.EasingStyle.Cubic)
            end
        end)
        task.delay(0.85, function()
            if not window._destroyed and mainCorner.Parent then
                tween(mainCorner, 0.5, {CornerRadius = UDim.new(0, 8)}, Enum.EasingStyle.Cubic)
            end
        end)
        task.delay(1.265, function()
            if window._destroyed then return end
            local intro = createIntroDecorations(window, window._header, options)
            window._introRefs = intro
            tween(intro.gameIcon, 0.45, {ImageTransparency = 0, Size = UDim2.fromOffset(55, 55)}, Enum.EasingStyle.Cubic)
            tween(intro.gameIconCorner, 0.45, {CornerRadius = UDim.new(0, 20)}, Enum.EasingStyle.Cubic)
            tween(intro.circle1, 0.45, {ImageTransparency = 0, Size = UDim2.fromOffset(75, 75)}, Enum.EasingStyle.Cubic)
            tween(intro.circle2, 0.9, {ImageTransparency = 0, Size = UDim2.fromOffset(100, 100)}, Enum.EasingStyle.Cubic)
        end)
        task.delay(2.225, function()
            if window._destroyed or not window._introRefs then return end
            local intro = window._introRefs
            tween(intro.gameIcon, 0.45, {ImageTransparency = 1}, Enum.EasingStyle.Cubic)
            tween(intro.circle1, 0.45, {ImageTransparency = 1, Size = UDim2.fromOffset(400, 400)}, Enum.EasingStyle.Cubic)
            tween(intro.circle2, 0.45, {ImageTransparency = 1, Size = UDim2.fromOffset(500, 500)}, Enum.EasingStyle.Cubic)
            task.delay(0.45, function()
                if window._destroyed then return end
                for _, object in ipairs({intro.gameIcon, intro.circle1, intro.circle2}) do
                    if object and object.Parent then object:Destroy() end
                end
                if window._introRefs == intro then window._introRefs = nil end
            end)
        end)
        task.delay(SHELL_SEQUENCE_DELAY, function()
            if window._destroyed or not main.Parent then return end
            local finalOffsetX = options.offsetX or 3
            local finalOffsetY = options.offsetY or 1
            main.Position = UDim2.new(0.5, 1, 0.5, 0)
            task.delay(0.004511, function()
                if not window._destroyed and main.Parent then
                    main.Position = UDim2.new(0.5, 1, 0.5, 1)
                end
            end)
            task.delay(0.777631, function()
                if not window._destroyed and main.Parent then
                    main.Position = UDim2.new(0.5, 2, 0.5, 1)
                end
            end)
            task.delay(0.788572, function()
                if not window._destroyed and main.Parent then
                    main.Position = UDim2.new(0.5, finalOffsetX, 0.5, finalOffsetY)
                end
            end)

            tween(main, 0.0657, {Size = UDim2.fromOffset(606, 326)}, Enum.EasingStyle.Sine)
            task.delay(0.075, function()
                if not window._destroyed and main.Parent then
                    tween(main, 0.85, {Size = UDim2.fromOffset(DESIGN_WIDTH, DESIGN_HEIGHT)}, Enum.EasingStyle.Cubic)
                end
            end)

            local pulseExtrema = {
                {0.671583, 608, 319},
                {0.751290, 606, 314},
                {0.838127, 610, 323},
                {0.937502, 607, 316},
                {1.026491, 611, 325},
                {1.121221, 608, 318},
                {1.232306, 612, 327},
                {1.304169, 609, 321},
                {1.406065, 612, 328},
                {1.493057, 609, 321},
                {1.576570, 611, 327},
                {1.689199, 608, 318},
                {1.783206, 611, 326},
                {1.854528, 609, 320},
                {1.943679, 612, 327},
                {2.031718, 609, 320},
                {2.121114, 612, 327},
                {2.221416, 609, 319},
                {2.304661, 612, 326},
                {2.377152, 609, 320},
                {2.492808, 612, 328},
            }
            local pulseStart = 0.537841
            for _, frame in ipairs(pulseExtrema) do
                local startAt = pulseStart
                local duration = frame[1] - pulseStart
                local width, height = frame[2], frame[3]
                task.delay(startAt, function()
                    if not window._destroyed and main.Parent then
                        tween(main, duration, {Size = UDim2.fromOffset(width, height)}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                    end
                end)
                pulseStart = frame[1]
            end
            task.delay(2.492808, function()
                if not window._destroyed and main.Parent then
                    tween(main, 0.85, {Size = UDim2.fromOffset(DESIGN_WIDTH, DESIGN_HEIGHT)}, Enum.EasingStyle.Cubic)
                end
            end)
            task.delay(2.8835, function()
                if not window._destroyed and main.Parent then
                    tween(main, 0.25, {Size = UDim2.fromOffset(613, 331)}, Enum.EasingStyle.Sine)
                end
            end)
            task.delay(3.1393, function()
                if not window._destroyed and main.Parent then
                    tween(main, 0.85, {Size = UDim2.fromOffset(DESIGN_WIDTH, DESIGN_HEIGHT)}, Enum.EasingStyle.Cubic)
                end
            end)
            task.delay(3.9893, function()
                if not window._destroyed and main.Parent then
                    main.Size = UDim2.fromOffset(DESIGN_WIDTH, DESIGN_HEIGHT)
                    main.Position = UDim2.new(0.5, finalOffsetX, 0.5, finalOffsetY)
                end
            end)
        end)
        task.delay(math.max(0, window._surfaceRevealAt - os.clock()), function()
            if not window._destroyed then materializeDashboardSurface(window) end
        end)
    else
        materializeDashboardSurface(window)
    end
    return window
end
refreshNavigationCanvas = function(window)
    if not window._navigation then return end
    window._navigation.CanvasSize = UDim2.fromOffset(0, 0)
end

local function setIconColor(icon, color)
    if icon:IsA("ImageLabel") then icon.ImageColor3 = color else icon.TextColor3 = color end
end

local function tweenIconColor(icon, color)
    if icon:IsA("ImageLabel") then
        tween(icon, 0.15, {ImageColor3 = color})
    else
        tween(icon, 0.15, {TextColor3 = color})
    end
end

local NAVIGATION_BUTTON_PEAK_OFFSETS = {
    0,
    0.217,
    0.823,
    1.105,
    1.955,
    2.282,
    2.610,
    2.955,
    3.315,
    3.610,
}
local NAVIGATION_BUTTON_RISE_DURATION = 0.2
local NAVIGATION_BUTTON_SETTLE_DURATION = 0.305
local NAVIGATION_ICON_GRADIENT = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 211, 126)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(59, 130, 127)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 130, 128)),
})

local function scheduleNavigationButtonEntrance(window, button, order)
    if not window._motionEnabled then return end
    local peakOffset = NAVIGATION_BUTTON_PEAK_OFFSETS[order]
    if not peakOffset then
        peakOffset = NAVIGATION_BUTTON_PEAK_OFFSETS[#NAVIGATION_BUTTON_PEAK_OFFSETS]
            + ((order - #NAVIGATION_BUTTON_PEAK_OFFSETS) * 0.35)
    end
    local revealAt = window._navigationRevealAt or os.clock()
    local delayBeforeRise = math.max(0, revealAt + peakOffset - NAVIGATION_BUTTON_RISE_DURATION - os.clock())
    task.delay(delayBeforeRise, function()
        if window._destroyed or not button.Parent then return end
        button.Size = UDim2.fromOffset(48, 48)
        tween(button, NAVIGATION_BUTTON_RISE_DURATION, {
            Size = UDim2.fromOffset(58, 58),
        }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        task.delay(NAVIGATION_BUTTON_RISE_DURATION, function()
            if window._destroyed or not button.Parent then return end
            tween(button, NAVIGATION_BUTTON_SETTLE_DURATION, {
                Size = UDim2.fromOffset(48, 48),
            }, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)
        end)
    end)
end

refreshNavigationSelectionStyle = function(window)
    for _, tab in ipairs(window._tabOrder) do
        local active = not window._onOverview and tab == window._selectedTab
        local resting = window._onOverview or active
        if tab.button then
            tween(tab.button, 0.25, {
                BackgroundColor3 = resting and Color3.fromRGB(10, 10, 10) or Color3.fromRGB(15, 23, 42),
                BackgroundTransparency = resting and 0.999 or 0.35,
                ImageColor3 = resting and Color3.new(1, 1, 1) or Color3.fromRGB(32, 125, 115),
                ImageTransparency = resting and 0 or 0.08,
            }, Enum.EasingStyle.Cubic)
            setIconColor(tab.buttonIcon, resting and Color3.new(1, 1, 1) or Color3.fromRGB(48, 180, 137))
        end
    end
end

local function createNavigationButton(window, tab, options)
    if not window._navigation then
        for _, pending in ipairs(window._pendingNavigationButtons) do
            if pending.tab == tab then
                pending.options = copyTable(options)
                return nil
            end
        end
        table.insert(window._pendingNavigationButtons, {tab = tab, options = copyTable(options)})
        return nil
    end
    if tab.button and tab.button.Parent then return tab.button end
    local theme = window._theme
    local button = make("ImageButton", {
        Name = "@widget.elia",
        AutoButtonColor = false,
        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
        BackgroundTransparency = 0.999,
        BorderSizePixel = 1,
        Image = "rbxassetid://139999149736863",
        ImageColor3 = Color3.new(1, 1, 1),
        ImageTransparency = 0,
        LayoutOrder = 0,
        ScaleType = Enum.ScaleType.Stretch,
        Size = UDim2.fromOffset(48, 48),
        ZIndex = 1,
    }, window._navigation)
    addCorner(button, 5)
    addGradient(button, NAVIGATION_ICON_GRADIENT, 0)
    local tooltip = createTextLabel(button, {
        Name = "Hint",
        AnchorPoint = Vector2.new(0.5, 0.5),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Color3.fromRGB(0, 0, 80),
        BackgroundTransparency = 1,
        BorderSizePixel = 1,
        Position = UDim2.fromScale(0.5, -0.425),
        Size = UDim2.fromOffset(0, 25),
        Text = tab.title,
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 15,
        TextTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 1,
    })
    addCorner(tooltip, 5)
    addPadding(tooltip, 5, 5, 0, 0)
    local icon = createIconLabel(button, resolveIcon(window._icons, options.icon, options.iconKey or "dashboard"), theme, {
        Name = "Icon",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 1,
        ImageTransparency = 0,
        Position = UDim2.fromScale(0.5, 0.5),
        ScaleType = Enum.ScaleType.Stretch,
        Size = UDim2.fromScale(0.55, 0.55),
        TextColor3 = Color3.new(1, 1, 1),
        ZIndex = 1,
    })
    addGradient(icon, NAVIGATION_ICON_GRADIENT, 0)

    tab.button, tab.buttonIcon, tab.tooltip = button, icon, tooltip
    scheduleNavigationButtonEntrance(window, button, tab.order or #window._tabOrder)
    trackConnection(window, button.MouseEnter:Connect(function()
        tweenIconColor(icon, Color3.new(1, 1, 1))
        tween(button, 0.25, {
            BackgroundColor3 = Color3.fromRGB(100, 100, 100),
            BackgroundTransparency = 0,
        }, Enum.EasingStyle.Cubic)
        tween(tooltip, 0.25, {
            BackgroundTransparency = 0,
            TextTransparency = 0,
        }, Enum.EasingStyle.Cubic)
    end))
    trackConnection(window, button.MouseLeave:Connect(function()
        local active = not window._onOverview and tab == window._selectedTab
        local resting = window._onOverview or active
        tweenIconColor(icon, (window._onOverview or active) and Color3.new(1, 1, 1) or Color3.fromRGB(48, 180, 137))
        tween(button, 0.25, {
            BackgroundColor3 = resting and Color3.fromRGB(10, 10, 10) or Color3.fromRGB(15, 23, 42),
            BackgroundTransparency = resting and 0.999 or 0.35,
        }, Enum.EasingStyle.Cubic)
        tween(tooltip, 0.25, {BackgroundTransparency = 1, TextTransparency = 1}, Enum.EasingStyle.Cubic)
    end))
    trackConnection(window, button.MouseButton1Click:Connect(function()
        selectTab(window, tab)
        if window._onOverview then window.Navigate() end
    end))
    task.defer(function() refreshNavigationCanvas(window) end)
    return button
end

local function flushNavigationButtons(window)
    local pending = window._pendingNavigationButtons
    window._pendingNavigationButtons = {}
    for _, entry in ipairs(pending) do
        if not window._destroyed then createNavigationButton(window, entry.tab, entry.options) end
    end
end

selectTab = function(window, tabOrId)
    if window._destroyed then return nil end
    local requested = tabOrId
    if type(tabOrId) == "string" then
        requested = window._tabs[tabOrId]
        if not requested then
            for _, candidate in ipairs(window._tabOrder) do
                if candidate.title == tabOrId then requested = candidate break end
            end
        end
    end
    if type(requested) ~= "table" or not requested.page then return nil end
    window._selectedTab = requested
    for _, tab in ipairs(window._tabOrder) do
        for _, section in ipairs(tab.sections or {}) do
            if section.frame and section.frame.Parent then
                section.frame.Visible = tab == requested and not tab._accessDenied
            end
        end
        if tab._accessDenied then
            local visible = tab == requested
            tab._accessDenied.icon.Visible = visible
            tab._accessDenied.label.Visible = visible
        end
    end
    refreshNavigationSelectionStyle(window)
    if window._pageTitle then window._pageTitle.Text = requested.title end
    if window._indicator then window._indicator.Text = requested.title end
    if window._applySearch then window._applySearch() end
    invoke(requested.onSelected, requested)
    return requested
end

local function createDashboardProfile(window, page, options, decorators)
    local theme = window._theme
    local card = make("CanvasGroup", {
        Name = "Overview", AnchorPoint = Vector2.new(0.5,0.5), BackgroundTransparency = 1,
        BorderSizePixel = 1, ClipsDescendants = true, GroupTransparency = 0,
        Position = UDim2.new(0.18,0,0.30,0), Size = UDim2.fromOffset(200,55),
    }, page)
    local placeholder = make("Frame", {
        Name = "Placeholder", AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundColor3 = theme.surface, BackgroundTransparency = 0.5,
        BorderSizePixel = 1, Position = UDim2.fromScale(0.5,0.5),
        Size = UDim2.fromScale(0.95,0.95),
    }, card)
    addCorner(placeholder, 5)
    placeholder.Size = UDim2.fromScale(0.95,0.95)
    local fallbackAvatar = LocalPlayer
        and string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=100&h=100", LocalPlayer.UserId)
        or "rbxasset://textures/ui/GuiImagePlaceholder.png"
    local avatar = make("ImageLabel", {
        Name = "Icon", AnchorPoint = Vector2.new(0.5,0.5), BackgroundTransparency = 1,
        BorderSizePixel = 1, Image = options.avatar or fallbackAvatar,
        Position = UDim2.fromScale(0.15,0.5), ScaleType = Enum.ScaleType.Stretch,
        Size = UDim2.fromOffset(50,50), ZIndex = 1,
    }, placeholder)
    local displayName = createTextLabel(placeholder, {
        Name="Header",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.30,0.20),
        Size=UDim2.fromOffset(0,0),Text=options.displayName or (LocalPlayer and LocalPlayer.DisplayName or "Player"),
        TextColor3=Color3.new(1,1,1),TextSize=15,
    })
    local handle = createTextLabel(placeholder, {
        Name="Name",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.30,0.485),
        Size=UDim2.fromOffset(0,0),Text=options.handle or (LocalPlayer and LocalPlayer.Name or "Player"),
        TextColor3=Color3.new(1,1,1),TextSize=11,
    })
    local planText = tostring(options.plan or "Premium")
    local plan = createTextLabel(placeholder, {
        Name="SubscriptionStatus",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.30,0.75),
        RichText=true,Size=UDim2.fromOffset(0,0),Text='<font color="rgb(0, 0, 255)">'..planText..'</font>',
        TextColor3=Color3.new(1,1,1),TextSize=11,
    })
    table.insert(decorators, function()
        createNeonStroke(placeholder, theme, 1.5, 0, window)
    end)
    return {card=card,placeholder=placeholder,avatar=avatar,displayName=displayName,handle=handle,plan=plan}
end

local function createStatCard(window, page, id, options, decorators)
    local theme = window._theme
    local card = make("CanvasGroup", {
        Name = options.instanceName or id, AnchorPoint = Vector2.new(0.5,0.5), BackgroundTransparency = 1,
        BorderSizePixel = 1, ClipsDescendants = true, GroupTransparency = 0,
        Position = options.position, Size = UDim2.fromOffset(185,75),
    }, page)
    local placeholder = make("Frame", {
        Name = "Placeholder", AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.5,
        BorderSizePixel = 1, Position = UDim2.fromScale(0.5,0.5),
        Size = UDim2.fromScale(0.95,0.95),
    }, card)
    addCorner(placeholder, 5)
    addGradient(placeholder, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20,20,20)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(45,45,45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(70,70,70)),
    }), -45)
    local caption = createTextLabel(placeholder, {
        Name="Header",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.085,0.20),
        Size=UDim2.fromOffset(0,0),Text=options.caption,TextColor3=Color3.fromRGB(150,150,150),TextSize=12,
    })
    createIconLabel(placeholder, resolveIcon(window._icons, nil, options.iconKey), theme, {
        Name="Icon",AnchorPoint=Vector2.new(0.5,0.5),BorderSizePixel=1,
        Position=UDim2.fromScale(0.85,0.20),ScaleType=Enum.ScaleType.Stretch,
        Size=UDim2.fromOffset(15,15),TextColor3=Color3.new(1,1,1),ZIndex=1,
    })
    local value = createTextLabel(placeholder, {
        Name="Text",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.10,0.555),
        Size=UDim2.fromOffset(0,0),Text=options.value,TextColor3=theme.success,TextSize=30,
    })
    table.insert(decorators, function()
        createNeonStroke(placeholder, theme, 1.5, 0, window)
    end)
    window._statRefs[id] = {card=card,placeholder=placeholder,caption=caption,value=value}
    return card
end

local function createOverviewNavigation(window, overview, decorators)
    local theme = window._theme
    local navigation = make("ScrollingFrame", {
        Name="BottomNavigation",AnchorPoint=Vector2.new(0.5,0.5),AutomaticCanvasSize=Enum.AutomaticSize.X,
        BackgroundColor3=Color3.fromRGB(15,23,42),BackgroundTransparency=0.5,BorderSizePixel=1,
        CanvasSize=UDim2.fromOffset(0,0),Position=UDim2.new(0.5,0,0.85,0),ScrollBarThickness=0,
        ScrollingDirection=Enum.ScrollingDirection.XY,
        Size=window._motionEnabled and UDim2.fromOffset(0,0) or UDim2.fromOffset(375,50),ClipsDescendants=true,
    }, overview)
    window._navigation = navigation
    table.insert(decorators, function()
        addCorner(navigation,5)
        addPadding(navigation,3,3,1,0)
        window._navigationLayout = make("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder,VerticalAlignment=Enum.VerticalAlignment.Top}, navigation)
        createNeonStroke(navigation,theme,1.5,0,window)
    end)
    if window._motionEnabled then
        task.delay(math.max(0, window._navigationRevealAt - os.clock()), function()
            if not window._destroyed and navigation.Parent then
                navigation.Size = UDim2.fromOffset(0,50)
                tween(navigation, 2, {Size = UDim2.fromOffset(375,50)}, Enum.EasingStyle.Cubic)
            end
        end)
    end
    return navigation
end

local function createPageChrome(window)
    if window._pageContainer and window._pageContainer.Parent then return end
    local theme = window._theme
    local container = make("Frame", {
        Name = "Container",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(163, 162, 165),
        BackgroundTransparency = 1,
        BorderSizePixel = 1,
        Position = UDim2.fromScale(0.5, 1.35),
        Size = UDim2.fromOffset(575, 205),
        Visible = true,
        ZIndex = 1,
    }, window._overview)
    local column = make("ScrollingFrame", {
        Name = "Container1",
        AnchorPoint = Vector2.new(0.5, 0.5),
        AutomaticCanvasSize = Enum.AutomaticSize.None,
        BackgroundColor3 = Color3.fromRGB(163, 162, 165),
        BackgroundTransparency = 1,
        BorderSizePixel = 1,
        CanvasSize = UDim2.fromOffset(0, 0),
        Position = UDim2.fromScale(0.25, 0.5),
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Size = UDim2.new(0.495, 0, 1, 0),
        ZIndex = 1,
    }, container)
    local layout = make("UIListLayout", {
        Name = "ListLayout",
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, column)
    addPadding(column, 0, 0, 0, 0).Name = "Padding"
    bindAutomaticCanvas(window, column, layout, 0)

    local searchBar = make("CanvasGroup", {
        Name = "SearchBar",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(0, 0, 200),
        BackgroundTransparency = 0.75,
        BorderSizePixel = 1,
        GroupTransparency = 1,
        Position = UDim2.fromScale(0.65, 0.23),
        Size = UDim2.new(0, 250, 0.09, 0),
        Visible = true,
        ZIndex = 1,
    }, window._overview)
    addCorner(searchBar, 20)
    make("ImageLabel", {
        Name = "Icon",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 1,
        Image = resolveAsset("search.png"),
        Position = UDim2.fromScale(0.1, 0.5),
        ScaleType = Enum.ScaleType.Stretch,
        Size = UDim2.new(0, 25, 0.9, 0),
        ZIndex = 1,
    }, searchBar)
    local search = make("TextBox", {
        Name = "Input",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 1,
        ClearTextOnFocus = true,
        Font = Enum.Font.Jura,
        PlaceholderText = "Looking for a feature?",
        PlaceholderColor3 = Color3.fromRGB(104, 104, 104),
        Position = UDim2.fromScale(0.565, 0.5),
        Size = UDim2.new(0, 200, 0.9, 0),
        Text = "",
        TextColor3 = theme.text,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 1,
    }, searchBar)

    window._pages = container
    window._content = container
    window._pageContainer = container
    window._pageColumn = column
    window._pageLayout = layout
    window._searchBar = searchBar
    window._pageTitle, window._search = nil, search

    window.Navigate = function()
        if window._destroyed or window._canNavigate == false then return end
        if window._onOverview and not window._selectedTab then return end
        window._canNavigate = false
        window._onOverview = not window._onOverview
        refreshNavigationSelectionStyle(window)
        local duration = window._motionEnabled and 0.5 or 0
        local enteringPage = not window._onOverview
        tween(container, window._motionEnabled and (enteringPage and 0.25 or 0.5) or 0, {
            Position = UDim2.fromScale(0.5, window._onOverview and 1.35 or 0.625),
        }, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        tween(searchBar, duration, {
            GroupTransparency = window._onOverview and 1 or 0,
        }, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        for _, dashboardGroup in ipairs({window._profileCard, window._fpsCard, window._pingCard, window._whitelistGroup}) do
            if dashboardGroup and dashboardGroup.Parent then
                tween(dashboardGroup, duration, {
                    GroupTransparency = window._onOverview and 0 or 1,
                }, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
            end
        end
        if window._navigation and window._navigation.Parent then
            tween(window._navigation, duration, {
                Position = UDim2.fromScale(0.5, window._onOverview and 0.85 or 1.2),
            }, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        end
        if window._navigate and window._navigate.Parent then
            tween(window._navigate, duration, {
                ImageTransparency = window._onOverview and 1 or 0,
            }, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        end
        if window._indicator and window._indicator.Parent then
            window._indicator.Text = window._selectedTab and window._selectedTab.title or "Label"
            tween(window._indicator, duration, {
                TextTransparency = window._onOverview and 1 or 0,
            }, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        end
        task.delay(duration, function()
            if not window._destroyed then window._canNavigate = true end
        end)
    end
    window._applySearch = function()
        local query = string.lower(search.Text or "")
        local selected = window._selectedTab
        if not selected then return end
        for _, tab in ipairs(window._tabOrder) do
            for _, section in ipairs(tab.sections or {}) do
                local visible = tab == selected and not tab._accessDenied and query == ""
                if tab == selected and not tab._accessDenied and not visible then
                    local textParts = {}
                    for _, descendant in ipairs(section.frame:GetDescendants()) do
                        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
                            table.insert(textParts, descendant.Text)
                        end
                    end
                    visible = string.find(string.lower(table.concat(textParts, " ")), query, 1, true) ~= nil
                end
                section.frame.Visible = visible
            end
        end
    end
    trackConnection(window, search:GetPropertyChangedSignal("Text"):Connect(window._applySearch))
end

materializeDashboardSurface = function(window)
    if window._destroyed or window._dashboardMaterialized then return end
    local options = window._dashboardOptions or {}
    local theme = window._theme
    local overview = window._overview
    local decorators = {}

    createDelayedHeaderSurface(window, overview, window._options, decorators)
    local profile = createDashboardProfile(window, overview, options.profile or {}, decorators)
    local fpsCard = createStatCard(window,overview,"fps",{instanceName="FPS",position=UDim2.new(0.80,0,0.325,0),caption=options.fpsCaption or "FPS",value=options.fps or "60",iconKey="fps",iconColor=theme.success},decorators)
    local pingCard = createStatCard(window,overview,"latency",{instanceName="Ping",position=UDim2.new(0.80,0,0.60,0),caption=options.latencyCaption or "Network Latency",value=options.latency or "--ms",iconKey="latency",iconColor=theme.cyan},decorators)
    local navigation = createOverviewNavigation(window, overview, decorators)
    local navigate=make("ImageButton",{
        Name="Navigate",AnchorPoint=Vector2.new(0.5,0.5),AutoButtonColor=false,
        BackgroundTransparency=1,BorderSizePixel=1,Image="rbxassetid://119225240670011",
        ImageTransparency=1,Position=UDim2.fromScale(0.05,0.225),ScaleType=Enum.ScaleType.Stretch,
        Size=UDim2.fromOffset(30,25),ZIndex=1,
    },overview)
    local indicator = createTextLabel(overview,{
        Name="Indicator",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.10,0.225),
        Size=UDim2.fromOffset(0,0),Text=window._selectedTab and window._selectedTab.title or "Label",TextColor3=Color3.new(1,1,1),
        TextSize=20,TextTransparency=1,ZIndex=1,
    })
    local whitelistGroup = make("CanvasGroup", {
        Name="WhitelistBar",AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,BorderSizePixel=1,
        ClipsDescendants=true,GroupTransparency=0,Position=UDim2.new(0.20,0,0.60,0),Size=UDim2.fromOffset(225,70),
    }, overview)
    local duration = tostring(options.duration or "-1:-1:-1:-1")
    local whitelist = createTextLabel(whitelistGroup,{
        Name="Label",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.06,0.10),
        RichText=true,Size=UDim2.fromOffset(0,0),Text='Whitelist Duration: <font color="rgb(0, 255, 0)">'..duration..'</font>',
        TextColor3=Color3.new(1,1,1),TextSize=15,
    })
    local track = make("Frame",{Name="Placeholder",AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=Color3.fromRGB(20,20,20),BackgroundTransparency=0,BorderSizePixel=1,Position=UDim2.fromScale(0.45,0.45),Size=UDim2.fromOffset(180,12)},whitelistGroup)
    addCorner(track,5)
    local progress=make("Frame",{Name="Duration",AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=Color3.fromRGB(0,200,0),BorderSizePixel=1,Position=UDim2.fromScale(0,0.5),Size=UDim2.fromScale(1,1)},track)
    addCorner(progress,5)
    window._instruction = createTextLabel(overview, {Name="Instruction",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.965,0),Size=UDim2.fromOffset(0,0),Text="> Scroll to the right to show other tabs.",TextColor3=Color3.new(1,1,1),TextSize=12,TextXAlignment=Enum.TextXAlignment.Center})
    if window._motionEnabled then
        task.spawn(function()
            local fadeTarget = 1
            while not window._destroyed and window._instruction and window._instruction.Parent do
                local animation = tween(window._instruction, 1, {
                    TextTransparency = fadeTarget,
                }, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
                animation.Completed:Wait()
                fadeTarget = fadeTarget == 1 and 0 or 1
            end
        end)
    end

    for _, decorate in ipairs(decorators) do decorate() end
    -- These are constructed early so callers can populate tabs during the intro,
    -- then reinserted here to match the live MainCanva sibling order and stacking.
    if window._pageContainer and window._pageContainer.Parent then
        window._pageContainer.Parent = nil
        window._pageContainer.Parent = overview
    end
    if window._searchBar and window._searchBar.Parent then
        window._searchBar.Parent = nil
        window._searchBar.Parent = overview
    end
    trackConnection(window,navigate.MouseButton1Click:Connect(window.Navigate))
    window._profileCard, window._fpsCard, window._pingCard = profile.card, fpsCard, pingCard
    window._navigation, window._navigate, window._indicator = navigation, navigate, indicator
    window._whitelistGroup = whitelistGroup
    window._dashboardObjects = {profile.card, fpsCard, pingCard, navigation, navigate, indicator, whitelistGroup, window._instruction}
    window._dashboardRefs={profile=profile,whitelistGroup=whitelistGroup,whitelist=whitelist,progressTrack=track,progress=progress}
    window._dashboardMaterialized = true
    flushNavigationButtons(window)
    refreshNavigationSelectionStyle(window)
    window._flushPendingSurface()
    finalizeWindowReady(window)
end

createDashboardTab = function(window, dashboardOptions)
    local options = type(dashboardOptions)=="table" and dashboardOptions or {}
    window._dashboardOptions = options
    createPageChrome(window)

    local tab={id=options.id or "changelogs",title=options.title or "Changelogs",order=1,sections={},isDashboard=true,onSelected=options.onSelected,window=window}
    local page=window._pageColumn
    tab.page,tab.leftColumn,tab.rightColumn,tab.layout,tab._nextColumn=page,page,nil,window._pageLayout,1
    tab.CreateSection=function(sectionOptions) return createSection(tab,sectionOptions) end
    tab.AddSection=tab.CreateSection
    tab.Select=function() return selectTab(window,tab) end
    tab.GetContainer=function() return page end
    attachTabShortcuts(tab)
    window._tabs[tab.id]=tab table.insert(window._tabOrder,tab)
    createNavigationButton(window,tab,{icon=options.icon,iconKey=options.iconKey or "changelogs"})
    selectTab(window,tab)
    return tab
end

createTab = function(window, tabOptions)
    local options=normalizeOptions(tabOptions,"Tab")
    local title=tostring(options.title or options.name or options.label or "Tab")
    local id=tostring(options.id or string.lower((title:gsub("[^%w]+","-"))))
    if id=="" then id="tab-"..tostring(#window._tabOrder+1) end
    if window._tabs[id] then return window._tabs[id] end
    local tab={id=id,title=title,order=#window._tabOrder+1,sections={},onSelected=options.onSelected or options.onSelect,window=window,_nextColumn=1}
    local page=window._pageColumn
    local left=page
    local right=nil
    tab.page,tab.leftColumn,tab.rightColumn,tab.layout=page,left,right,window._pageLayout
    tab.CreateSection=function(sectionOptions) return createSection(tab,sectionOptions) end
    tab.AddSection=tab.CreateSection
    tab.Select=function() return selectTab(window,tab) end
    tab.GetContainer=function() return page end
    tab.SetAccessDenied=function(message)
        local denied = message ~= false
        for _, section in ipairs(tab.sections) do section.frame.Visible = not denied and tab == window._selectedTab end
        if denied and not tab._accessDenied then
            local icon = make("ImageLabel", {
                Name = "AccessDeniedIcon", AnchorPoint = Vector2.new(0.5,0.5), BackgroundTransparency = 1,
                Image = resolveIcon(window._icons, nil, "error"), Position = UDim2.fromScale(0.5,0.35),
                ScaleType = Enum.ScaleType.Stretch, Size = UDim2.fromOffset(50,50),
            }, window._pageContainer)
            local label = createTextLabel(window._pageContainer, {
                Name = "AccessDeniedMessage", AnchorPoint = Vector2.new(0.5,0.5), BackgroundTransparency = 1,
                Font = Enum.Font.Jura, Position = UDim2.fromScale(0.5,0.625), Size = UDim2.fromOffset(0,0),
                Text = tostring(type(message)=="string" and message or "You are unable to access this tab."),
                TextColor3 = Color3.fromRGB(255,0,0), TextSize = 17, TextTransparency = 0.5,
                TextXAlignment = Enum.TextXAlignment.Center,
            })
            icon.Visible = tab == window._selectedTab
            label.Visible = tab == window._selectedTab
            tab._accessDenied = {icon=icon,label=label}
        elseif denied and tab._accessDenied and type(message)=="string" then
            tab._accessDenied.label.Text = message
        elseif not denied and tab._accessDenied then
            tab._accessDenied.icon:Destroy() tab._accessDenied.label:Destroy() tab._accessDenied = nil
        end
        return denied
    end
    attachTabShortcuts(tab)
    window._tabs[id]=tab table.insert(window._tabOrder,tab)
    createNavigationButton(window,tab,{icon=options.icon,iconKey=options.iconKey or string.lower(title),iconSize=options.iconSize})
    if options.accessDenied then tab.SetAccessDenied(type(options.accessDenied)=="string" and options.accessDenied or nil) end
    if options.select==true or options.selected==true then selectTab(window,tab) end
    return tab
end
local OVERDRIVE_UI_SCALE = DESIGN_SCALE

local function authoredPixels(screenPixels)
    return screenPixels / OVERDRIVE_UI_SCALE
end

local function createControlRow(section, height, properties)
    local overrides = properties or {}
    local row = make("Frame", {
        Name = overrides.Name or "Control",
        AutomaticSize = Enum.AutomaticSize.None,
        BackgroundColor3 = overrides.BackgroundColor3 or Color3.fromRGB(163, 162, 165),
        BackgroundTransparency = overrides.BackgroundTransparency == nil and 1 or overrides.BackgroundTransparency,
        BorderSizePixel = 1,
        LayoutOrder = 0,
        Size = UDim2.new(0.95, 0, 0, height or 25),
    }, section.body)
    section._nextOrder += 1
    return row
end

local function createControlLabel(row, theme, text, widthOffset)
    return createTextLabel(row, {
        Name = "Label",
        Position = UDim2.fromOffset(authoredPixels(20), 0),
        Size = UDim2.new(1, widthOffset or -authoredPixels(40), 1, 0),
        Text = tostring(text or "Control"),
        TextColor3 = theme.text,
        RichText = true,
        TextSize = 13,
    })
end

local function addLabel(section, options)
    options = normalizeOptions(options, "Label")
    local theme = section.window._theme
    local label = make("TextLabel", {
        Name = "\2",
        BackgroundColor3 = Color3.fromRGB(163, 162, 165),
        BackgroundTransparency = 1,
        BorderSizePixel = 1,
        Font = Enum.Font.Jura,
        LayoutOrder = 0,
        RichText = true,
        Size = UDim2.new(0.95, 0, 0, options.height or 20),
        Text = tostring(options.text or options.label or options.title or "Label"),
        TextColor3 = options.color or theme.text,
        TextSize = options.textSize or 11,
        TextTransparency = 0,
        TextWrapped = options.wrapped == true,
        TextXAlignment = options.textXAlignment or Enum.TextXAlignment.Left,
        TextYAlignment = options.wrapped and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
    }, section.body)
    section._nextOrder += 1

    local control = {}
    control.SetText = function(value)
        label.Text = tostring(value)
    end
    control.GetText = function()
        return label.Text
    end
    control.Destroy = function()
        label:Destroy()
    end
    control.Instance = label
    return control
end

local function addParagraph(section, options)
    options = normalizeOptions(options, "Information")
    local theme = section.window._theme
    local row = createControlRow(section, options.height or authoredPixels(75))
    local title = createTextLabel(row, {
        Position = UDim2.fromOffset(authoredPixels(20), 0),
        Size = UDim2.new(1, -authoredPixels(40), 0, authoredPixels(27)),
        Text = tostring(options.title or options.label or "Information"),
        TextColor3 = theme.text,
        TextSize = 13,
    })
    local content = createTextLabel(row, {
        Position = UDim2.fromOffset(authoredPixels(20), authoredPixels(27)),
        Size = UDim2.new(1, -authoredPixels(40), 1, -authoredPixels(30)),
        Text = tostring(options.text or options.content or ""),
        TextColor3 = theme.textMuted,
        TextSize = 13,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top,
    })
    local control = {Instance = row}
    control.SetTitle = function(value) title.Text = tostring(value) end
    control.SetText = function(value) content.Text = tostring(value) end
    control.Destroy = function() row:Destroy() end
    return control
end

local function addButton(section, options)
    options = normalizeOptions(options, "Button")
    local window = section.window
    local theme = window._theme
    local button = make("TextButton", {
        Name = "",
        AutoButtonColor = false,
        BackgroundColor3 = Color3.fromRGB(25, 23, 100),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 1,
        Font = Enum.Font.Jura,
        LayoutOrder = 0,
        RichText = true,
        Size = UDim2.new(0.95, 0, 0, options.height or 28),
        Text = tostring(options.label or options.title or options.name or "Button"),
        TextColor3 = theme.text,
        TextSize = 14,
        TextTransparency = 0,
        TextXAlignment = Enum.TextXAlignment.Center,
    }, section.body)
    section._nextOrder += 1
    addCorner(button, 5)
    local stroke = addStroke(button, Color3.fromRGB(120, 120, 120), 0.5, 0)
    stroke.Name = "Stroke"
    trackConnection(window, button.MouseButton1Click:Connect(function()
        invoke(options.onClick or options.callback)
    end))

    local control = {Instance = button}
    control.SetText = function(value) button.Text = tostring(value) end
    control.Fire = function() invoke(options.onClick or options.callback) end
    control.Destroy = function() button:Destroy() end
    return control
end

local function addKeybind(section, options)
    options = normalizeOptions(options, "Keybind")
    local window = section.window
    local theme = window._theme
    local row = createControlRow(section, options.height or 25, {Name = ""})
    local label = createTextLabel(row, {
        Name = "Title",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(163, 162, 165),
        Position = UDim2.fromScale(0.05, 0.5),
        Size = UDim2.fromOffset(0, 0),
        Text = tostring(options.label or options.title or options.name or "Keybind"),
        TextColor3 = theme.text,
        TextSize = 13,
    })
    local input = make("TextButton", {
        Name = "Input",
        AnchorPoint = Vector2.new(0.5, 0.5),
        AutoButtonColor = false,
        BackgroundColor3 = Color3.fromRGB(25, 23, 100),
        BackgroundTransparency = 0,
        BorderSizePixel = 1,
        Font = Enum.Font.Jura,
        Position = UDim2.fromScale(0.885, 0.5),
        Size = UDim2.fromOffset(50, 15),
        TextColor3 = theme.text,
        TextSize = 14,
    }, row)
    addCorner(input, 5)

    local key = options.default or options.value or options.key or "Unknown"
    local listening = false
    local control = {Instance = row, Input = input}
    local function displayKey(value)
        if typeof(value) == "EnumItem" then return value.Name end
        return tostring(value or "Unknown")
    end
    local function matches(inputObject)
        if typeof(key) == "EnumItem" then
            return inputObject.KeyCode == key or inputObject.UserInputType == key
        end
        return inputObject.KeyCode.Name == tostring(key) or inputObject.UserInputType.Name == tostring(key)
    end
    control.SetKey = function(value, silent)
        key = value
        input.Text = displayKey(key)
        if not silent then invoke(options.onChange, key) end
    end
    control.Set = control.SetKey
    control.GetKey = function() return key end
    control.Get = control.GetKey
    control.Destroy = function() row:Destroy() end
    trackConnection(window, input.MouseButton1Click:Connect(function()
        listening = true
        input.Text = "..."
    end))
    trackConnection(window, UserInputService.InputBegan:Connect(function(inputObject, processed)
        if listening then
            if inputObject.KeyCode == Enum.KeyCode.Escape then
                listening = false
                input.Text = displayKey(key)
                return
            end
            if inputObject.KeyCode ~= Enum.KeyCode.Unknown then
                listening = false
                control.SetKey(inputObject.KeyCode)
            end
            return
        end
        if not processed and not UserInputService:GetFocusedTextBox() and matches(inputObject) then
            invoke(options.onPressed or options.callback, key)
        end
    end))
    input.Text = displayKey(key)
    return control
end

local function addToggle(section, options)
    options = normalizeOptions(options, "Toggle")
    local window = section.window
    local theme = window._theme
    local row = createControlRow(section, options.height or 25, {Name = ""})
    local label = createTextLabel(row, {
        Name = "Title",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(163, 162, 165),
        Position = UDim2.fromScale(0.05, 0.5),
        Size = UDim2.fromOffset(0, 0),
        Text = tostring(options.label or options.title or options.name or "Toggle"),
        TextColor3 = theme.text,
        RichText = true,
        TextSize = 13,
    })
    local button = make("ImageButton", {
        Name = "Toggle",
        AnchorPoint = Vector2.new(0.5, 0.5),
        AutoButtonColor = false,
        BackgroundColor3 = Color3.fromRGB(23, 42, 80),
        BackgroundTransparency = 0,
        BorderSizePixel = 1,
        Image = "",
        Position = UDim2.fromScale(0.885, 0.5),
        Size = UDim2.fromOffset(45, 22),
    }, row)
    addCorner(button, 12)
    local knob = make("Frame", {
        Name = "Placeholder",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(5, 5, 5),
        BackgroundTransparency = 0,
        BorderSizePixel = 1,
        Position = UDim2.fromScale(0.25, 0.5),
        Size = UDim2.fromOffset(18, 15),
    }, button)
    make("UICorner", {Name = "Corner", CornerRadius = UDim.new(0.5, 0)}, knob)

    local state = options.default == true or options.value == true
    local control = {Instance = row}
    local function render(animated)
        local duration = animated and 0.16 or 0
        tween(button, duration, {BackgroundColor3 = state and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(23, 42, 80)})
        tween(knob, duration, {
            BackgroundColor3 = Color3.fromRGB(5, 5, 5),
            Position = UDim2.fromScale(state and 0.75 or 0.25, 0.5),
        })
    end
    control.SetToggle = function(value, silent)
        local nextState = value == true
        if state == nextState then
            render(false)
            return
        end
        state = nextState
        render(true)
        if not silent then
            invoke(options.onChange or options.callback, state)
        end
    end
    control.Set = control.SetToggle
    control.GetToggle = function() return state end
    control.Get = control.GetToggle
    control.Destroy = function() row:Destroy() end
    trackConnection(window, button.MouseButton1Click:Connect(function()
        control.SetToggle(not state)
    end))
    trackConnection(window, row.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            control.SetToggle(not state)
        end
    end))
    render(false)
    return control
end

local function addSlider(section, options)
    options = normalizeOptions(options, "Slider")
    local window = section.window
    local theme = window._theme
    local minimum = tonumber(options.min) or 0
    local maximum = tonumber(options.max) or 100
    if maximum <= minimum then maximum = minimum + 1 end
    local step = math.max(tonumber(options.step or options.increment) or 1, 0.000001)
    local value = math.clamp(tonumber(options.default or options.value) or minimum, minimum, maximum)
    local row = createControlRow(section, options.height or 45, {Name = "\3\2\3"})
    local sliderLabel = createTextLabel(row, {
        Name = "Title",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(163, 162, 165),
        Position = UDim2.fromScale(0.05, 0.185),
        Size = UDim2.fromOffset(0, 0),
        Text = tostring(options.label or options.title or options.name or "Slider"),
        TextColor3 = theme.text,
        RichText = true,
        TextSize = 13,
    })
    local valueLabel = make("TextBox", {
        Name = "Value",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(0, 50, 150),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 1,
        ClearTextOnFocus = false,
        Font = Enum.Font.Jura,
        Position = UDim2.fromScale(0.85, 0.185),
        Size = UDim2.fromOffset(15, 18),
        TextColor3 = theme.text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Center,
    }, row)
    addCorner(valueLabel, 5)
    addPadding(valueLabel, 2, 2, 0, 0).Name = "Padding"
    local bar = make("Frame", {
        Name = "Placeholder",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(5, 5, 5),
        BackgroundTransparency = 0,
        BorderSizePixel = 1,
        Position = UDim2.fromScale(0.5, 0.75),
        Size = UDim2.new(0.95, 0, 0, 5),
    }, row)
    addCorner(bar, 5)
    local fill = make("Frame", {
        Name = "Filler",
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(20, 150, 250),
        BorderSizePixel = 1,
        Position = UDim2.fromScale(0, 0.5),
        Size = UDim2.new(0, 0, 0, 5),
    }, bar)
    addCorner(fill, 5)
    local knob = make("Frame", {
        Name = "Knob",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 1,
        Position = UDim2.fromScale(1, 0.5),
        Size = UDim2.fromOffset(10, 10),
        Active = true,
    }, fill)
    make("UICorner", {Name = "Corner", CornerRadius = UDim.new(0.5, 0)}, knob)

    local dragging = false
    local control = {Instance = row}
    local function quantize(raw)
        local stepped = minimum + math.floor(((raw - minimum) / step) + 0.5) * step
        return math.clamp(stepped, minimum, maximum)
    end
    local function render()
        local ratio = (value - minimum) / (maximum - minimum)
        fill.Size = UDim2.new(ratio, 0, 0, 5)
        local formatter = options.format
        valueLabel.Text = type(formatter) == "function" and tostring(formatter(value)) or tostring(value) .. tostring(options.suffix or "")
    end
    control.SetValue = function(nextValue, silent)
        local resolved = quantize(tonumber(nextValue) or value)
        if resolved == value then
            render()
            return
        end
        value = resolved
        render()
        if not silent then invoke(options.onChange or options.callback, value) end
    end
    control.Set = control.SetValue
    control.GetValue = function() return value end
    control.Get = control.GetValue
    control.Destroy = function() row:Destroy() end
    local function updateFromX(x)
        if bar.AbsoluteSize.X <= 0 then return end
        local ratio = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        control.SetValue(minimum + (maximum - minimum) * ratio)
    end
    trackConnection(window, bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromX(input.Position.X)
        end
    end))
    trackConnection(window, UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromX(input.Position.X)
        end
    end))
    trackConnection(window, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))
    trackConnection(window, valueLabel.FocusLost:Connect(function()
        control.SetValue(tonumber(valueLabel.Text) or value)
    end))
    render()
    return control
end

local function addInput(section, options)
    options = normalizeOptions(options, "Input")
    local window = section.window
    local theme = window._theme
    local row = createControlRow(section, options.height or authoredPixels(75))
    local inputLabel = createControlLabel(row, theme, options.label or options.title or options.name, -authoredPixels(40))
    inputLabel.Size = UDim2.new(1, -authoredPixels(40), 0, authoredPixels(30))
    local box = make("TextBox", {
        BackgroundColor3 = Color3.fromRGB(5, 5, 50),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ClearTextOnFocus = options.clearOnFocus == true,
        Font = Enum.Font.Jura,
        PlaceholderColor3 = theme.textDim,
        PlaceholderText = tostring(options.placeholder or "Enter value"),
        Position = UDim2.fromOffset(authoredPixels(10), authoredPixels(37.5)),
        Size = options.width and UDim2.fromOffset(options.width, authoredPixels(37.5))
            or UDim2.new(1, -authoredPixels(20), 0, authoredPixels(37.5)),
        Text = tostring(options.default or options.value or ""),
        TextColor3 = theme.text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    addCorner(box, 5)
    addPadding(box, authoredPixels(10), authoredPixels(10), 0, 0)
    local boxStroke = addStroke(box, Color3.fromRGB(120, 40, 120), 0.5, 0.5)
    trackConnection(window, box.Focused:Connect(function()
        tween(boxStroke, 0.15, {Color = theme.teal, Transparency = 0.05})
    end))
    trackConnection(window, box.FocusLost:Connect(function(enterPressed)
        tween(boxStroke, 0.15, {Color = theme.stroke, Transparency = 0.42})
        invoke(options.onChange or options.callback, box.Text, enterPressed)
    end))
    local control = {Instance = row, TextBox = box}
    control.SetText = function(value, silent)
        box.Text = tostring(value or "")
        if not silent then invoke(options.onChange or options.callback, box.Text, false) end
    end
    control.Set = control.SetText
    control.GetText = function() return box.Text end
    control.Get = control.GetText
    control.Destroy = function() row:Destroy() end
    return control
end

local function addDropdown(section, options)
    options = normalizeOptions(options, "Dropdown")
    local window = section.window
    local theme = window._theme
    local values = type(options.values) == "table" and options.values or type(options.options) == "table" and options.options or {}
    local selected = options.default or options.value
    local open = false
    local row = make("ImageButton", {
        Name = "\2\1\1",
        AutoButtonColor = false,
        BackgroundColor3 = Color3.fromRGB(25, 23, 100),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 1,
        Image = "",
        LayoutOrder = 0,
        Size = UDim2.new(0.95, 0, 0, 0),
    }, section.body)
    section._nextOrder += 1
    row.ClipsDescendants = false
    addCorner(row, 3)
    local selectorStroke = addStroke(row, Color3.fromRGB(120, 120, 120), 0.5, 0)
    selectorStroke.Name = "Stroke"
    selectorStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    addPadding(row, 0, 0, 0, 5).Name = "Padding"
    local caption = createTextLabel(row, {
        Name = "Title",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(163, 162, 165),
        Position = UDim2.fromOffset(15, 5),
        Size = UDim2.fromOffset(0, 0),
        Text = tostring(options.label or options.title or options.name or "Dropdown"),
        TextColor3 = theme.text,
        TextSize = 10,
    })
    local selectedLabel = createTextLabel(row, {
        Name = "Selected",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(163, 162, 165),
        Position = UDim2.fromOffset(15, 20),
        Size = UDim2.fromOffset(0, 0),
        Text = tostring(selected or options.placeholder or "Select"),
        TextColor3 = theme.text,
        RichText = true,
        TextSize = 15,
    })
    local arrow = make("ImageLabel", {
        Name = "Icon",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(163, 162, 165),
        BackgroundTransparency = 1,
        Image = resolveAsset("down.png"),
        ImageColor3 = theme.text,
        Position = UDim2.fromOffset(225, 20),
        Size = UDim2.fromOffset(12, 12),
        ZIndex = 1,
    }, row)
    local optionHolder = make("ScrollingFrame", {
        Name = "Content",
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.fromRGB(20, 20, 50),
        BackgroundTransparency = 0.85,
        BorderSizePixel = 1,
        CanvasSize = UDim2.fromOffset(0, 0),
        Position = UDim2.fromOffset(130, 30),
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.XY,
        Size = UDim2.new(0.9, 0, 0, 0),
        Visible = true,
        ZIndex = 1,
    }, row)
    local optionLayout = make("UIListLayout", {
        Name = "ListLayout",
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 1),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, optionHolder)

    local control = {Instance = row}
    local optionButtons = {}
    local function refreshOptionColors()
        for index, button in ipairs(optionButtons) do
            button.TextColor3 = values[index] == selected and theme.text or Color3.fromRGB(104, 104, 104)
        end
    end
    local function setOpen(nextOpen)
        open = nextOpen == true
        local optionHeight = #values * 20
        optionHolder.CanvasSize = UDim2.fromOffset(0, optionHeight)
        tween(row, 0.18, {Size = UDim2.new(0.95, 0, 0, open and (30 + math.min(optionHeight, 120)) or 0)})
        tween(optionHolder, 0.18, {Size = UDim2.new(0.9, 0, 0, open and math.min(optionHeight, 120) or 0)})
        tween(arrow, 0.18, {Rotation = open and 180 or 0})
        tween(selectorStroke, 0.18, {Color = open and theme.teal or theme.stroke, Transparency = open and 0.08 or 0.4})
    end
    local function choose(value, silent)
        selected = value
        selectedLabel.Text = tostring(value)
        selectedLabel.TextColor3 = theme.text
        refreshOptionColors()
        setOpen(false)
        if not silent then invoke(options.onChange or options.callback, selected) end
    end
    local function rebuild()
        for _, button in ipairs(optionButtons) do button:Destroy() end
        table.clear(optionButtons)
        for index, value in ipairs(values) do
            local optionButton = make("TextButton", {
                Name = "\t",
                AutoButtonColor = false,
                BackgroundColor3 = Color3.fromRGB(163, 162, 165),
                BackgroundTransparency = 1,
                BorderSizePixel = 1,
                Font = Enum.Font.Jura,
                LayoutOrder = 0,
                Size = UDim2.new(0.85, 0, 0, 20),
                Text = tostring(value),
                TextColor3 = value == selected and theme.text or Color3.fromRGB(104, 104, 104),
                RichText = true,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex = 1,
            }, optionHolder)
            trackConnection(window, optionButton.MouseButton1Click:Connect(function()
                choose(value, false)
            end))
            table.insert(optionButtons, optionButton)
        end
        if open then setOpen(true) end
    end
    control.SetValue = choose
    control.Set = choose
    control.GetValue = function() return selected end
    control.Get = control.GetValue
    control.SetOptions = function(nextValues, keepSelection)
        values = type(nextValues) == "table" and nextValues or {}
        if not keepSelection then
            selected = nil
            selectedLabel.Text = tostring(options.placeholder or "Select")
            selectedLabel.TextColor3 = theme.textDim
        end
        rebuild()
    end
    control.SetOpen = setOpen
    control.Destroy = function() row:Destroy() end
    trackConnection(window, row.MouseButton1Click:Connect(function()
        setOpen(not open)
    end))
    rebuild()
    return control
end

local function addDivider(section, options)
    options = type(options) == "table" and options or {}
    local row = make("Frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 0,
        Size = UDim2.new(1, 0, 0, options.height or 12),
    }, section.body)
    section._nextOrder += 1
    make("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = options.color or section.window._theme.stroke,
        BackgroundTransparency = options.transparency or 0.5,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 8, 0.5, 0),
        Size = UDim2.new(1, -16, 0, 1),
    }, row)
    return {Instance = row, Destroy = function() row:Destroy() end}
end

createSection = function(tab, sectionOptions)
    local options = normalizeOptions(sectionOptions, "Section")
    local window = tab.window
    local theme = window._theme
    local section = {
        tab = tab,
        window = window,
        _nextOrder = 1,
    }
    local sectionParent = tab.window._pageColumn or tab.page
    local columnName = "left"
    local frame = make("Frame", {
        Name = "Section",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BackgroundTransparency = 0.9,
        BorderSizePixel = 1,
        LayoutOrder = 0,
        Size = UDim2.new(0.985, 0, 0, 0),
        Visible = tab == window._selectedTab,
    }, sectionParent)
    addCorner(frame, 5)
    make("UIListLayout", {
        Name = "ListLayout",
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, frame)
    addPadding(frame, 0, 0, 0, 5).Name = "Padding"
    local rawTitle = tostring(options.title or options.name or options.label or "Section")
    local title = createTextLabel(frame, {
        Name = "Title",
        BackgroundColor3 = Color3.fromRGB(163, 162, 165),
        Font = Enum.Font.GothamBold,
        LayoutOrder = 0,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(1, 0, 0, 40),
        Text = "\n  " .. string.upper(rawTitle) .. "\n",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 28,
    })
    addCorner(title, 5)
    local titleStroke = addStroke(title, Color3.fromRGB(80, 80, 80), 0.5, 0)
    titleStroke.Name = "Stroke"
    addGradient(title, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 211, 126)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(59, 130, 127)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 130, 128)),
    }), 0)
    local categoryText = tostring(options.category or options.subtitle or options.description or "")
    local category = createTextLabel(title, {
        Name = "Subtitle",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(163, 162, 165),
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.05, 0.875),
        Size = UDim2.fromOffset(0, 0),
        Text = string.upper(categoryText),
        TextColor3 = theme.text,
        TextSize = 8,
    })
    createNeonStroke(frame, theme, 1.5, 0, window)

    section.frame = frame
    section.body = frame
    section.title = title
    section.category = category
    section.column = columnName
    section.AddLabel = function(controlOptions) return addLabel(section, controlOptions) end
    section.AddText = section.AddLabel
    section.AddParagraph = function(controlOptions) return addParagraph(section, controlOptions) end
    section.AddButton = function(controlOptions) return addButton(section, controlOptions) end
    section.AddKeybind = function(controlOptions) return addKeybind(section, controlOptions) end
    section.AddToggle = function(controlOptions) return addToggle(section, controlOptions) end
    section.AddSlider = function(controlOptions) return addSlider(section, controlOptions) end
    section.AddInput = function(controlOptions) return addInput(section, controlOptions) end
    section.AddDropdown = function(controlOptions) return addDropdown(section, controlOptions) end
    section.AddDivider = function(controlOptions) return addDivider(section, controlOptions) end
    section.SetTitle = function(value) title.Text = "\n  " .. string.upper(tostring(value)) .. "\n" end
    section.SetCategory = function(value) category.Text = string.upper(tostring(value or "")) end
    section.Destroy = function() frame:Destroy() end
    table.insert(tab.sections, section)
    return section
end

attachTabShortcuts = function(tab)
    local defaultSection = nil
    local function getDefaultSection()
        if not defaultSection or not defaultSection.frame.Parent then
            defaultSection = createSection(tab, {title = tab.title})
        end
        return defaultSection
    end
    tab.AddLabel = function(options) return getDefaultSection().AddLabel(options) end
    tab.AddText = tab.AddLabel
    tab.AddParagraph = function(options) return getDefaultSection().AddParagraph(options) end
    tab.AddButton = function(options) return getDefaultSection().AddButton(options) end
    tab.AddKeybind = function(options) return getDefaultSection().AddKeybind(options) end
    tab.AddToggle = function(options) return getDefaultSection().AddToggle(options) end
    tab.AddSlider = function(options) return getDefaultSection().AddSlider(options) end
    tab.AddInput = function(options) return getDefaultSection().AddInput(options) end
    tab.AddDropdown = function(options) return getDefaultSection().AddDropdown(options) end
    tab.AddDivider = function(options) return getDefaultSection().AddDivider(options) end
end

createNotification = function(window, notificationOptions)
    local options = normalizeOptions(notificationOptions, "Notification")
    local theme = window._theme
    local card = createSurface(window._notifications, theme, 8, 0.04)
    card.Name = "Notification"
    card.LayoutOrder = -math.floor(os.clock() * 1000)
    card.Size = UDim2.fromOffset(300, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundTransparency = 1
    addPadding(card, 12, 12, 9, 10)
    local cardStroke = addStroke(card, options.color or theme.teal, 1, 1)
    local content = make("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
    }, card)
    make("UIListLayout", {
        Padding = UDim.new(0, 3),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, content)
    createTextLabel(content, {
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Text = tostring(options.title or options.label or "Notification"),
        TextColor3 = options.color or theme.teal,
        TextSize = 14,
        TextWrapped = true,
    })
    createTextLabel(content, {
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 2,
        Size = UDim2.new(1, 0, 0, 18),
        Text = tostring(options.text or options.content or ""),
        TextColor3 = theme.textMuted,
        TextSize = 13,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top,
    })
    local dismiss = make("TextButton", {
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Position = UDim2.new(1, -28, 0, 2),
        Size = UDim2.fromOffset(24, 24),
        Text = "×",
        TextColor3 = theme.textMuted,
        TextSize = 16,
        ZIndex = 4,
    }, card)
    local closed = false
    local function close()
        if closed or not card.Parent then return end
        closed = true
        local animation = tween(card, 0.18, {BackgroundTransparency = 1})
        tween(cardStroke, 0.18, {Transparency = 1})
        task.spawn(function()
            animation.Completed:Wait()
            if card.Parent then card:Destroy() end
        end)
    end
    trackConnection(window, dismiss.MouseButton1Click:Connect(close))
    task.defer(function()
        if card.Parent then
            tween(card, 0.2, {BackgroundTransparency = 0.04})
            tween(cardStroke, 0.2, {Transparency = 0.08})
        end
    end)
    local duration = tonumber(options.duration)
    if duration == nil then duration = 4 end
    if duration > 0 then task.delay(duration, close) end
    return {Instance = card, Close = close}
end
OverdriveHUi.CreateWindow = createWindow
OverdriveHUi.New = createWindow
OverdriveHUi.createWindow = createWindow

OverdriveHUi.GetActiveWindows = function()
    local windows = {}
    for _, window in pairs(activeWindows) do
        if not window._destroyed then
            table.insert(windows, window)
        end
    end
    table.sort(windows, function(a, b)
        return a._id < b._id
    end)
    return windows
end

OverdriveHUi.UnloadAll = function()
    local windows = OverdriveHUi.GetActiveWindows()
    for _, window in ipairs(windows) do
        window.Unload()
    end
end

OverdriveHUi.GetDefaultTheme = function()
    return copyTable(DEFAULT_THEME)
end

OverdriveHUi.GetDefaultIcons = function()
    return copyTable(DEFAULT_ICONS)
end

OverdriveHUi.ExposeGlobal = function(name)
    local globalName = type(name) == "string" and name ~= "" and name or "OverdriveHUiLibrary"
    GLOBAL_ENV[globalName] = OverdriveHUi
    return OverdriveHUi
end

GLOBAL_ENV.OverdriveHUiLibrary = OverdriveHUi

return OverdriveHUi
