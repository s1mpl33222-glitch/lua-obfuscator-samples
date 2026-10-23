-- X8 game compatibility preflight
do
    local context = ...
    local gate = (function()
-- Game compatibility gate 20261009.1; runs before sign-in and payload delivery.
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Library = {}
local regular = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
local medium = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
local bold = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold)
local ink = Color3.fromRGB(30, 31, 35)
local muted = Color3.fromRGB(111, 113, 120)

local function make(class, properties, parent)
    local object = Instance.new(class)
    for key, value in pairs(properties) do object[key] = value end
    object.Parent = parent
    return object
end

local function round(object, radius)
    make("UICorner", {CornerRadius = UDim.new(0, radius)}, object)
end

local function thumbnail(info)
    return info.Thumbnail or (info.UniverseId and
        "rbxthumb://type=GameIcon&id=" .. tostring(info.UniverseId) .. "&w=150&h=150") or ""
end

function Library.Show(config)
    config = config or {}
    local intended = config.IntendedGame or {Name = "Gakuran", Creator = "Gakuran Team", UniverseId = 9199655655}
    local current = config.CurrentGame or {Name = "Shigaku", Creator = "Shigaku Team", UniverseId = 10504918958}
    local loader = config.Loader and tostring(config.Loader) or "No recommended loader is available for this game."
    local app = {Alive = true, Connections = {}, Tweens = {}}
    local gui = make("ScreenGui", {Name = "X8GameCompatibility", ResetOnSpawn = false,
        IgnoreGuiInset = true, DisplayOrder = 100005, ZIndexBehavior = Enum.ZIndexBehavior.Sibling},
        config.Parent or Players.LocalPlayer:WaitForChild("PlayerGui"))
    local root = make("Frame", {Name = "CenteredWindow", AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(520, 526), BackgroundTransparency = 1}, gui)
    gui.ScreenInsets = Enum.ScreenInsets.None
    gui.ClipToDeviceSafeArea = false
    local scale = make("UIScale", {Scale = 1}, root)
    for index = 5, 1, -1 do
        local shadow = make("Frame", {Name = "Shadow", BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 0.965 - (6 - index) * 0.008, BorderSizePixel = 0,
            Position = UDim2.fromOffset(-index * 4, -index * 2 + 10),
            Size = UDim2.new(1, index * 8, 1, index * 6), ZIndex = 1}, root)
        round(shadow, 18 + index * 2)
    end
    local window = make("CanvasGroup", {Name = "Reminder", Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(246, 246, 248), BorderSizePixel = 0,
        GroupTransparency = 1, ZIndex = 2}, root)
    round(window, 16)
    make("UIStroke", {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.25, Thickness = 1}, window)
    local function connect(signal, callback)
        table.insert(app.Connections, signal:Connect(callback))
    end
    local function label(name, text, x, y, width, height, size, font, color, alignment)
        return make("TextLabel", {Name = name, Text = text, BackgroundTransparency = 1,
            Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(width, height),
            FontFace = font or regular, TextSize = size, TextColor3 = color or ink,
            TextWrapped = true, TextXAlignment = alignment or Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center, ZIndex = 3}, window)
    end
    local function animate(object, goals, duration)
        local tween = TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), goals)
        table.insert(app.Tweens, tween)
        tween:Play()
    end
    function app.Resolve(proceed)
        if not app.Alive then return end
        app.Decision = proceed == true and config.AllowProceed ~= false
        app.Destroy()
    end
    function app.Destroy()
        if not app.Alive then return end
        app.Alive = false
        for _, connection in ipairs(app.Connections) do connection:Disconnect() end
        for _, tween in ipairs(app.Tweens) do tween:Cancel() end
        table.clear(app.Connections)
        table.clear(app.Tweens)
        gui:Destroy()
        if type(config.OnDecision) == "function" then config.OnDecision(app.Decision == true) end
        if type(config.OnClose) == "function" then task.spawn(config.OnClose) end
    end
    label("Titlebar", "Game compatibility", 40, 0, 440, 44, 12, medium, muted)
    local close = make("TextButton", {Name = "CloseWindow", Text = "", AutoButtonColor = false,
        Position = UDim2.fromOffset(15, 13), Size = UDim2.fromOffset(18, 18),
        BackgroundTransparency = 1, ZIndex = 4}, window)
    local dot = make("Frame", {Size = UDim2.fromOffset(12, 12), Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = Color3.fromRGB(255, 95, 87), BorderSizePixel = 0}, close)
    round(dot, 6)
    connect(close.Activated, app.Destroy)
    local heroIcon = make("ImageLabel", {Name = "IntendedGameIcon", Image = thumbnail(intended),
        Position = UDim2.fromOffset(216, 61), Size = UDim2.fromOffset(88, 88),
        BackgroundColor3 = Color3.fromRGB(226, 227, 233), BorderSizePixel = 0, ScaleType = Enum.ScaleType.Crop, ZIndex = 3}, window)
    round(heroIcon, 18)
    local headline = label("Headline", "This script is meant for\n" .. tostring(intended.Name), 32, 168, 456, 64, 24, bold)
    local intendedCreator = label("Creator", "By " .. tostring(intended.Creator or "Unknown creator"), 32, 239, 456, 20, 12, regular, muted)
    make("Frame", {Position = UDim2.fromOffset(32, 282), Size = UDim2.fromOffset(456, 1),
        BackgroundColor3 = Color3.fromRGB(220, 221, 226), BorderSizePixel = 0, ZIndex = 3}, window)
    local currentIcon = make("ImageLabel", {Name = "CurrentGameIcon", Image = thumbnail(current),
        Position = UDim2.fromOffset(32, 302), Size = UDim2.fromOffset(42, 42),
        BackgroundColor3 = Color3.fromRGB(226, 227, 233), BorderSizePixel = 0, ScaleType = Enum.ScaleType.Crop, ZIndex = 3}, window)
    round(currentIcon, 8)
    label("CurrentGameCaption", "CURRENT GAME", 86, 300, 390, 16, 10, medium, muted, Enum.TextXAlignment.Left)
    local currentName = label("CurrentGame", tostring(current.Name), 86, 318, 390, 21, 15, bold, ink, Enum.TextXAlignment.Left)
    local currentCreator = label("CurrentCreator", "By " .. tostring(current.Creator or "Unknown creator"), 86, 339, 390, 16, 10,
        regular, muted, Enum.TextXAlignment.Left)
    label("Recommendation", config.RecommendedScript and ("For this game, use " .. tostring(config.RecommendedScript) .. ".") or "This game is not supported by this loader.",
        32, 360, 456, 24, 13, medium, ink, Enum.TextXAlignment.Left)
    local code = make("TextBox", {Name = "Loader", Text = loader, TextEditable = false,
        ClearTextOnFocus = false, MultiLine = true, TextWrapped = true,
        Position = UDim2.fromOffset(32, 397), Size = UDim2.fromOffset(456, 54),
        BackgroundColor3 = Color3.fromRGB(234, 235, 239), BorderSizePixel = 0,
        FontFace = Font.fromEnum(Enum.Font.Code), TextSize = 11, TextColor3 = Color3.fromRGB(69, 71, 79),
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, ZIndex = 3}, window)
    round(code, 6)
    make("UIPadding", {PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)}, code)
    local function button(name, text, x, width, primary)
        local color = primary and Color3.fromRGB(0, 112, 245) or Color3.fromRGB(228, 229, 234)
        local item = make("TextButton", {Name = name, Text = text, AutoButtonColor = false,
            Position = UDim2.fromOffset(x, 475), Size = UDim2.fromOffset(width, 32),
            BackgroundColor3 = color, BorderSizePixel = 0, FontFace = medium, TextSize = 12,
            TextColor3 = primary and Color3.new(1, 1, 1) or ink, ZIndex = 4}, window)
        round(item, 7)
        connect(item.MouseEnter, function() item.BackgroundColor3 = primary and Color3.fromRGB(0, 97, 222) or Color3.fromRGB(216, 218, 224) end)
        connect(item.MouseLeave, function() item.BackgroundColor3 = color end)
        return item
    end
    local cancel = button("Close", "Close", 32, 84, false)
    local copy = button("CopyLoader", "Copy loader", 126, 131, false)
    local proceed = button("Proceed", "Yes, Proceed", 317, 171, true)
    proceed.Visible = config.AllowProceed ~= false
    connect(proceed.Activated, function() app.Resolve(true) end)
    copy.Visible = config.Loader ~= nil
    connect(cancel.Activated, app.Destroy)
    connect(copy.Activated, function()
        local clipboard = setclipboard or toclipboard
        local ok = type(clipboard) == "function" and pcall(clipboard, loader)
        copy.Text = ok and "Copied" or "Select code above"
        task.delay(1.8, function() if app.Alive then copy.Text = "Copy loader" end end)
    end)
    function app.UpdateGame(target, name, creator)
        if not app.Alive then return end
        if target == "intended" then
            if type(name) == "string" and name ~= "" then headline.Text = "This script is meant for\n" .. name end
            if type(creator) == "string" then intendedCreator.Text = "By " .. creator end
        else
            if type(name) == "string" and name ~= "" then currentName.Text = name end
            if type(creator) == "string" then currentCreator.Text = "By " .. creator end
        end
    end
    currentName.TextWrapped = false
    currentName.TextTruncate = Enum.TextTruncate.AtEnd
    currentCreator.TextWrapped = false
    currentCreator.TextTruncate = Enum.TextTruncate.AtEnd
    headline.TextScaled = true
    make("UITextSizeConstraint", {MinTextSize = 16, MaxTextSize = 24}, headline)
    connect(gui.AncestryChanged, function(_, parent) if parent == nil and app.Alive then app.Resolve(false) end end)
    local function fit()
        scale.Scale = math.max(0.05, math.min(1, (gui.AbsoluteSize.X - 48) / 520, (gui.AbsoluteSize.Y - 48) / 526))
    end
    connect(gui:GetPropertyChangedSignal("AbsoluteSize"), fit)
    fit()
    root.Position = UDim2.new(0.5, 0, 0.5, 10)
    animate(root, {Position = UDim2.fromScale(0.5, 0.5)}, 0.24)
    animate(window, {GroupTransparency = 0}, 0.2)
    app.Gui = gui
    return app
end
Library.Catalog = {
    larpkuran = {Name = "Gakuran", Creator = "Gakuran", UniverseId = 9199655655,
        PlaceIds = {128736949265057, 76165410142500}, Script = "LarpKuran", LoaderPath = "stacyui.lua"},
    larpgaku = {Name = "Shigaku", Creator = "dsafasfasdfasdf", UniverseId = 10504918958,
        PlaceIds = {109329896664198}, Script = "Larpgaku", LoaderPath = "Larpgaku.lua"},
    nights99 = {Name = "99 Nights in the Forest", Creator = "Grandma's Favourite Games", UniverseId = 7326934954,
        PlaceIds = {79546208627805, 126509999114328}, Script = "99 Nights", LoaderPath = "99.lua"},
    komorebi = {Name = "Komorebi Prison", Creator = "Komorebi RP", UniverseId = 10420832668,
        PlaceIds = {71689406215487}, Script = "LarpMore-bi", LoaderPath = "komorebi.lua"},
}

local function matches(info)
    if tonumber(info.UniverseId) == game.GameId then return true end
    for _, id in ipairs(info.PlaceIds or {}) do
        if tonumber(id) == game.PlaceId then return true end
    end
    return false
end

function Library.IsBlocked(product)
    -- Larpgaku must never enter its sign-in/payload flow inside Gakuran.
    return product == "larpgaku" and matches(Library.Catalog.larpkuran)
end

function Library.ForScript(config)
    local id = tostring(config.Product or config.Id or config.Script or ""):lower()
    if id:find("larpgaku", 1, true) then return "larpgaku" end
    if id:find("nights99", 1, true) or id:find("99", 1, true) then return "nights99" end
    if id:find("komorebi", 1, true) then return "komorebi" end
    if id:find("larpkuran", 1, true) or id:find("rerelarp", 1, true) then return "larpkuran" end
end

function Library.Await(product, options)
    options = options or {}
    local intended = options.IntendedGame or Library.Catalog[product]
    local hardBlocked = Library.IsBlocked(product)
    if not hardBlocked and (not intended or matches(intended)) then return true end
    local env = type(getgenv) == "function" and getgenv() or _G
    local runtime = rawget(env, "_X8GameCompatibility")
    if type(runtime) ~= "table" then
        runtime = {}
        rawset(env, "_X8GameCompatibility", runtime)
    end
    if runtime.Active and runtime.Active.Alive then runtime.Active.Resolve(false) end
    local current, recommendation
    for _, info in pairs(Library.Catalog) do
        if matches(info) then current, recommendation = table.clone(info), info; break end
    end
    current = current or {Name = "Place " .. tostring(game.PlaceId), Creator = "Unknown creator", UniverseId = game.GameId}
    local loader = recommendation and ('loadstring(game:HttpGet("https://api.x8stuff.lol/scripts/' .. recommendation.LoaderPath .. '"))()') or nil
    local result
    local app = Library.Show({
        IntendedGame = intended, CurrentGame = current, Loader = loader,
        AllowProceed = not hardBlocked,
        RecommendedScript = recommendation and recommendation.Script,
        OnDecision = function(proceed) result = proceed == true and not hardBlocked end,
    })
    runtime.Active = app
    local marketplace = game:GetService("MarketplaceService")
    local function refresh(placeId, target)
        task.spawn(function()
            local ok, info = pcall(marketplace.GetProductInfo, marketplace, placeId, Enum.InfoType.Asset)
            if not ok or not app.Alive or type(info) ~= "table" then return end
            local creator = type(info.Creator) == "table" and info.Creator.Name or nil
            app.UpdateGame(target, info.Name, creator)
        end)
    end
    refresh(game.PlaceId, "current")
    if intended.PlaceIds and intended.PlaceIds[1] then refresh(intended.PlaceIds[1], "intended") end
    while result == nil do task.wait() end
    if runtime.Active == app then runtime.Active = nil end
    return result == true and not hardBlocked
end

return Library
end)()
    local approved = type(context) == "table" and context.GameCompatibilityApproved == true
    if (gate.IsBlocked("larpgaku") or not approved) and not gate.Await("larpgaku") then return false end
end
-- Discord product key loader; gameplay is delivered only after server authorization.
local ui = loadstring(game:HttpGet("https://api.x8stuff.lol/scripts/product-key-ui.lua?t=" .. tostring(os.time())), "=ProductKeyUI")()
return ui.Start({GameCompatibilityApproved = true, Product = "larpgaku", Title = "Larpgaku", Script = "Larpgaku.lua", StopPrevious = function(env) if env.Larpgaku and type(env.Larpgaku.Stop) == "function" then env.Larpgaku.Stop() end end,})
