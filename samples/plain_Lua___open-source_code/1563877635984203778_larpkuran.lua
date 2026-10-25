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
        app.Decision = proceed == true
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
    if not intended or matches(intended) then return true end
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
        RecommendedScript = recommendation and recommendation.Script,
        OnDecision = function(proceed) result = proceed == true end,
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
    return result
end

return Library
end)()
    local approved = type(context) == "table" and context.GameCompatibilityApproved == true
    if not approved and not gate.Await("larpkuran") then return false end
end
-- X8 loader 20261006-startup-handoff-02
local function _initLoader()
    local loaderErrorHandler, loaderCleanup
    local loaderStage = "Initializing loader"
    local function runLoader()
        local pcall = pcall
        local type = type
        local tostring = tostring
        local game = game
        local task = task
        local bit32 = bit32
        local buffer = buffer
        local string = string
        local table = table
        local os = os
        local math = math
        local UDim2 = UDim2
        local UDim = UDim
        local Color3 = Color3
        local Enum = Enum
        local Instance = Instance
        local ColorSequence = ColorSequence
        local ColorSequenceKeypoint = ColorSequenceKeypoint
        local NumberSequence = NumberSequence
        local NumberSequenceKeypoint = NumberSequenceKeypoint
        local TweenInfo = TweenInfo

        local TweenService = game:GetService("TweenService")
        local HttpService = game:GetService("HttpService")
        local Players = game:GetService("Players")
        local CoreGui = game:GetService("CoreGui")
        local SoundService = game:GetService("SoundService")
        local RunService = game:GetService("RunService")
        local Lighting = game:GetService("Lighting")
        local ContentProvider = game:GetService("ContentProvider")

        local req = (syn and syn.request) or (http and http.request) or http_request or request

        local executorName = "this executor"
        for _, detect in ipairs({ identifyexecutor or false, getexecutorname or false }) do
            if type(detect) == "function" then
                local ok, name = pcall(detect)
                if ok and type(name) == "string" and name:match("%S") then
                    executorName = name:gsub("%c", " "):sub(1, 48)
                    break
                end
            end
        end

        local lowerName = string.lower(executorName)

        -- SECURITY_HELPERS_BEGIN: bounded diagnostics, no native hook probes.
        local function redactDiagnostic(value)
            local text = tostring(value or "Unknown execution error"):sub(1, 12000)
            text = text:gsub("[Bb]earer%s+[^%s\"',};&]+", "Bearer [REDACTED]")
            text = text:gsub("x8stuff%d+%-[%w%-]+", "[KEY_REDACTED]")
            text = text:gsub("[A-Za-z0-9_%-]+%.[A-Za-z0-9_%-]+", function(token)
                local body, sig = token:match("^([A-Za-z0-9_%-]+)%.([A-Za-z0-9_%-]+)$")
                return body and #body >= 24 and #sig == 43 and "[SESSION_REDACTED]" or token
            end)
            text = text:gsub("%x+", function(hex) return #hex == 64 and "[SECRET_REDACTED]" or hex end)
            for _, field in ipairs({"sessionToken", "sessionKey", "StacyKey", "X8_KEY", "key", "token", "Authorization", "authorization", "x-x8-session"}) do
                local pattern = field:gsub("(%W)", "%%%1")
                text = text:gsub("(" .. pattern .. "[\"']?%s*[:=]%s*[\"']?)[^%s\"',};&]+", "%1[REDACTED]")
            end
            return text
        end
        local function inspectEnvironment()
            if type(req) ~= "function" or type(loadstring) ~= "function" then
                return false, "ENV_COMPAT_ERROR: HTTP request or loadstring is unavailable."
            end
            if type(buffer) ~= "table" or type(bit32) ~= "table" then
                return false, "ENV_COMPAT_ERROR: buffer or bit32 is unavailable."
            end
            for _, name in ipairs({"create", "fromstring", "tostring", "len", "copy", "readu8", "writeu8", "readu32", "writeu32"}) do
                if type(buffer[name]) ~= "function" then return false, "ENV_COMPAT_ERROR: missing buffer." .. name end
            end
            for _, name in ipairs({"band", "bor", "bxor", "lshift", "rshift"}) do
                if type(bit32[name]) ~= "function" then return false, "ENV_COMPAT_ERROR: missing bit32." .. name end
            end
            -- Names are only a signal. No closure classification, getgc scan or executor hook API.
            local ok, found = pcall(function()
                local cg = game:GetService("CoreGui")
                for _, name in ipairs({"SimpleSpy", "SimpleSpy2", "HttpSpy", "Hydroxide", "TurtleSpy"}) do
                    if cg:FindFirstChild(name) then return true end
                end
                return false
            end)
            if ok and found then
                return false, "ENV_INSPECTION_DETECTED: A known inspection UI is open. Close it and restart a clean client before signing in. No account penalty was applied."
            end
            return true
        end
        -- SECURITY_HELPERS_END

        local function reportAndShowError(scriptName, errText)
            task.spawn(function()
                local pcall = pcall
                local tostring = tostring
                local string = string
                local task = task
                local game = game
                local Instance = Instance
                local UDim2 = UDim2
                local UDim = UDim
                local Color3 = Color3
                local Enum = Enum
                local Vector2 = Vector2

                local env = (getfenv and getfenv()) or _G
                local function getGlobal(name)
                    local ok, val = pcall(function() return env[name] end)
                    return ok and val or nil
                end

                local setclipboard = getGlobal("setclipboard") or getGlobal("toclipboard") or getGlobal("set_clipboard")
                local syn = getGlobal("syn")
                local http = getGlobal("http")
                local req = (syn and syn.request) or (http and http.request) or getGlobal("http_request") or getGlobal("request")

                local username = "Unknown"
                local userId = "0"
                pcall(function()
                    local lp = game:GetService("Players").LocalPlayer
                    if lp then
                        username = lp.Name
                        userId = tostring(lp.UserId)
                    end
                end)

                local execName = "Unknown"
                local identifyexecutor = getGlobal("identifyexecutor") or getGlobal("getexecutorname")
                if type(identifyexecutor) == "function" then
                    local ok, res = pcall(identifyexecutor)
                    if ok and type(res) == "string" and res:match("%S") then
                        execName = res:gsub("%c", " "):sub(1, 48)
                    end
                end

                local fullErrorStr = redactDiagnostic(errText)
                local safeScript = tostring(scriptName or "larpkuran")

                -- REPORT_TRANSPORT_BEGIN: best-effort telemetry shares native download slots.
                if type(req) == "function" then
                    task.spawn(function()
                        pcall(function()
                            local HttpService = game:GetService("HttpService")
                            local payload = HttpService:JSONEncode({
                                script = safeScript, error = fullErrorStr, username = username,
                                userId = userId, executor = execName,
                            })
                            local shared = _G
                            if type(getgenv) == "function" then
                                local ok, value = pcall(getgenv)
                                if ok and type(value) == "table" then shared = value end
                            end
                            local ledger = shared._X8DownloadTransport
                            if type(ledger) ~= "table" or ledger.version ~= 1 then
                                ledger = {version = 1, inFlight = 0, generation = 0}
                                shared._X8DownloadTransport = ledger
                            end
                            -- Never queue telemetry behind stuck native calls; the local error UI still opens.
                            if ledger.inFlight >= 3 then return end
                            ledger.inFlight = ledger.inFlight + 1
                            pcall(req, {
                                Url = "https://api.x8stuff.lol/api/client-error",
                                Method = "POST",
                                Headers = {["Content-Type"] = "application/json", ["User-Agent"] = "Roblox/WinInet"},
                                Body = payload,
                            })
                            ledger.inFlight = math.max(0, ledger.inFlight - 1)
                        end)
                    end)
                end
                -- REPORT_TRANSPORT_END

                pcall(function()
                    local CoreGui = game:GetService("CoreGui")
                    local gethui = getGlobal("gethui")
                    local preferredParent
                    if type(gethui) == "function" then
                        local ok, ui = pcall(gethui)
                        if ok then preferredParent = ui end
                    end

                    local errorGui = Instance.new("ScreenGui")
                    errorGui.Name = "LarpBigErrorGui"
                    errorGui.ResetOnSpawn = false
                    errorGui.IgnoreGuiInset = false
                    errorGui.DisplayOrder = 999999
                    errorGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

                    local function interFont(weight)
                        local ok, face = pcall(Font.new, "rbxassetid://12187365364", weight or Enum.FontWeight.Regular)
                        return ok and face or Font.fromEnum(Enum.Font.BuilderSans)
                    end

                    local viewportFrame = Instance.new("Frame")
                    viewportFrame.Name = "Viewport"
                    viewportFrame.Size = UDim2.fromScale(1, 1)
                    viewportFrame.BackgroundTransparency = 1
                    viewportFrame.Parent = errorGui

                    local border = Instance.new("Frame")
                    border.Name = "ErrorFrame"
                    border.AnchorPoint = Vector2.new(0.5, 0.5)
                    border.Position = UDim2.fromScale(0.5, 0.5)
                    border.Size = UDim2.fromScale(0.5, 0.5)
                    border.BackgroundColor3 = Color3.fromRGB(76, 76, 80)
                    border.BorderSizePixel = 0
                    border.Parent = viewportFrame

                    local black = Instance.new("Frame")
                    black.Name = "BlackSurface"
                    black.Position = UDim2.fromOffset(3, 3)
                    black.Size = UDim2.new(1, -6, 1, -6)
                    black.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    black.BorderSizePixel = 0
                    black.Parent = border

                    local icon = Instance.new("ImageLabel")
                    icon.Name = "ErrorSplash"
                    icon.AnchorPoint = Vector2.new(0.5, 0.5)
                    icon.Position = UDim2.fromScale(0.5, 0.5)
                    icon.Size = UDim2.fromOffset(96, 96)
                    icon.BackgroundTransparency = 1
                    icon.ScaleType = Enum.ScaleType.Fit
                    icon.ZIndex = 2
                    icon.Parent = black

                    -- The vector icon keeps the error visible if the asset download fails.
                    local fallback = Instance.new("Frame")
                    fallback.Name = "ErrorSplashFallback"
                    fallback.AnchorPoint = Vector2.new(0.5, 0.5)
                    fallback.Position = UDim2.fromScale(0.5, 0.5)
                    fallback.Size = UDim2.fromOffset(76, 76)
                    fallback.BackgroundTransparency = 1
                    fallback.ZIndex = 1
                    fallback.Parent = black
                    local ring = Instance.new("Frame")
                    ring.Size = UDim2.fromScale(1, 1)
                    ring.BackgroundTransparency = 1
                    ring.Parent = fallback
                    local ringCorner = Instance.new("UICorner")
                    ringCorner.CornerRadius = UDim.new(1, 0)
                    ringCorner.Parent = ring
                    local ringStroke = Instance.new("UIStroke")
                    ringStroke.Color = Color3.fromRGB(148, 148, 148)
                    ringStroke.Thickness = 6
                    ringStroke.Parent = ring
                    local slash = Instance.new("Frame")
                    slash.AnchorPoint = Vector2.new(0.5, 0.5)
                    slash.Position = UDim2.fromScale(0.5, 0.5)
                    slash.Size = UDim2.fromOffset(6, 92)
                    slash.Rotation = -45
                    slash.BackgroundColor3 = Color3.fromRGB(148, 148, 148)
                    slash.BorderSizePixel = 0
                    slash.Parent = fallback

                    local visibleError = fullErrorStr:gsub("[%c]+", " "):gsub("%s+", " ")
                    if visibleError == "" then visibleError = "An unexpected loader error occurred." end

                    local messageGroup = Instance.new("Frame")
                    messageGroup.Name = "ErrorMessageGroup"
                    messageGroup.AnchorPoint = Vector2.new(0.5, 1)
                    messageGroup.Position = UDim2.fromScale(0.5, 0.86)
                    messageGroup.Size = UDim2.new(0.84, 0, 0, 88)
                    messageGroup.BackgroundTransparency = 1
                    messageGroup.Parent = black

                    local errorMessage = Instance.new("TextLabel")
                    errorMessage.Name = "ErrorMessage"
                    errorMessage.Size = UDim2.new(1, 0, 0, 58)
                    errorMessage.BackgroundTransparency = 1
                    errorMessage.FontFace = interFont(Enum.FontWeight.Regular)
                    errorMessage.Text = visibleError
                    errorMessage.TextColor3 = Color3.fromRGB(235, 235, 235)
                    errorMessage.TextSize = 15
                    errorMessage.TextWrapped = true
                    errorMessage.TextTruncate = Enum.TextTruncate.AtEnd
                    errorMessage.TextXAlignment = Enum.TextXAlignment.Center
                    errorMessage.TextYAlignment = Enum.TextYAlignment.Center
                    errorMessage.Parent = messageGroup

                    local reportMessage = Instance.new("TextLabel")
                    reportMessage.Name = "ReportMessage"
                    reportMessage.Position = UDim2.fromOffset(0, 62)
                    reportMessage.Size = UDim2.new(1, 0, 0, 24)
                    reportMessage.BackgroundTransparency = 1
                    reportMessage.FontFace = interFont(Enum.FontWeight.Regular)
                    reportMessage.Text = "report this issue to x8 immediately."
                    reportMessage.TextColor3 = Color3.fromRGB(210, 210, 210)
                    reportMessage.TextSize = 15
                    reportMessage.TextWrapped = true
                    reportMessage.TextTruncate = Enum.TextTruncate.AtEnd
                    reportMessage.TextXAlignment = Enum.TextXAlignment.Center
                    reportMessage.Parent = messageGroup

                    local copyBtn = Instance.new("TextButton")
                    copyBtn.Name = "CopyError"
                    copyBtn.AnchorPoint = Vector2.new(1, 1)
                    copyBtn.Position = UDim2.new(1, -16, 1, -12)
                    copyBtn.Size = UDim2.fromOffset(108, 24)
                    copyBtn.BackgroundTransparency = 1
                    copyBtn.FontFace = interFont(Enum.FontWeight.Medium)
                    copyBtn.Text = "COPY ERROR"
                    copyBtn.TextColor3 = Color3.fromRGB(130, 130, 134)
                    copyBtn.TextSize = 11
                    copyBtn.Parent = black
                    copyBtn.Activated:Connect(function()
                        if type(setclipboard) == "function" then
                            local ok = pcall(setclipboard, fullErrorStr)
                            copyBtn.Text = ok and "COPIED" or "COPY FAILED"
                        else
                            copyBtn.Text = "COPY UNAVAILABLE"
                        end
                    end)

                    local closeBtn = Instance.new("TextButton")
                    closeBtn.Name = "CloseError"
                    closeBtn.AnchorPoint = Vector2.new(1, 0)
                    closeBtn.Position = UDim2.new(1, -16, 0, 12)
                    closeBtn.Size = UDim2.fromOffset(48, 24)
                    closeBtn.BackgroundTransparency = 1
                    closeBtn.FontFace = interFont(Enum.FontWeight.Medium)
                    closeBtn.Text = "CLOSE"
                    closeBtn.TextColor3 = Color3.fromRGB(130, 130, 134)
                    closeBtn.TextSize = 11
                    closeBtn.Parent = black
                    closeBtn.Activated:Connect(function() errorGui:Destroy() end)

                    local function tryParent(candidate)
                        if typeof(candidate) ~= "Instance" then return false end
                        local oldPanel
                        pcall(function() oldPanel = candidate:FindFirstChild("LarpBigErrorGui") end)
                        local ok = pcall(function() errorGui.Parent = candidate end)
                        if not ok or errorGui.Parent ~= candidate then return false end
                        if oldPanel and oldPanel ~= errorGui then pcall(function() oldPanel:Destroy() end) end
                        return true
                    end
                    local attached = tryParent(preferredParent) or tryParent(CoreGui)
                    if not attached then
                        local player = game:GetService("Players").LocalPlayer
                        if player then
                            local ok, playerGui = pcall(function() return player:WaitForChild("PlayerGui", 2) end)
                            if ok then attached = tryParent(playerGui) end
                        end
                    end
                    if not attached then errorGui:Destroy(); return end

                    local function updateLayout()
                        local viewportSize = viewportFrame.AbsoluteSize
                        local screenWidth = viewportSize.X > 0 and viewportSize.X or 1280
                        local screenHeight = viewportSize.Y > 0 and viewportSize.Y or 832
                        local frameWidth = math.max(1, math.min(math.max(280, math.floor(screenWidth * 0.5)), screenWidth - 16))
                        local frameHeight = math.max(1, math.min(math.max(220, math.floor(screenHeight * 0.5)), screenHeight - 16))
                        border.Size = UDim2.fromOffset(frameWidth, frameHeight)
                        local size = border.AbsoluteSize
                        local height = size.Y > 0 and size.Y or frameHeight
                        local width = size.X > 0 and size.X or frameWidth
                        local compact = height < 420
                        local tiny = height < 260
                        local iconSize = math.clamp(math.floor(height * 0.18), tiny and 48 or 58, 96)
                        icon.Position = UDim2.fromScale(0.5, tiny and 0.42 or 0.5)
                        icon.Size = UDim2.fromOffset(iconSize, iconSize)
                        local symbolSize = math.floor(iconSize * 0.8)
                        fallback.Position = icon.Position
                        fallback.Size = UDim2.fromOffset(symbolSize, symbolSize)
                        ringStroke.Thickness = math.max(4, math.floor(iconSize * 0.063))
                        slash.Size = UDim2.fromOffset(ringStroke.Thickness, math.floor(iconSize * 0.96))
                        messageGroup.Position = UDim2.fromScale(0.5, tiny and 0.97 or compact and 0.94 or 0.86)
                        messageGroup.Size = UDim2.new(compact and 0.88 or 0.84, 0, 0, tiny and 64 or compact and 72 or 88)
                        errorMessage.Size = UDim2.new(1, 0, 0, tiny and 36 or compact and 44 or 58)
                        errorMessage.TextSize = tiny and 11 or compact and 12 or 15
                        reportMessage.Position = UDim2.fromOffset(0, tiny and 40 or compact and 46 or 62)
                        reportMessage.TextSize = tiny and 11 or compact and 12 or 15
                        local maxChars = tiny and 70 or width < 500 and 100 or width < 850 and 140 or 180
                        errorMessage.Text = #visibleError > maxChars and (visibleError:sub(1, maxChars - 3) .. "...") or visibleError
                        copyBtn.AnchorPoint = compact and Vector2.new(0, 0) or Vector2.new(1, 1)
                        copyBtn.Position = compact and UDim2.fromOffset(10, 8) or UDim2.new(1, -16, 1, -12)
                        copyBtn.Size = compact and UDim2.fromOffset(116, 40) or UDim2.fromOffset(108, 24)
                        closeBtn.Position = compact and UDim2.new(1, -10, 0, 8) or UDim2.new(1, -16, 0, 12)
                        closeBtn.Size = compact and UDim2.fromOffset(64, 40) or UDim2.fromOffset(48, 24)
                    end
                    updateLayout()
                    viewportFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateLayout)

                    task.spawn(function()
                        pcall(function()
                            local path = "Staconf/assets/larpkuran-loader-error.png"
                            local url = "https://raw.githubusercontent.com/x8lua/Staconf/main/assets/larpkuran-loader-error.png"
                            local assetFunctions = {}
                            local getgenv = getGlobal("getgenv")
                            if type(getgenv) == "function" then
                                local ok, shared = pcall(getgenv)
                                if ok and type(shared) == "table" and type(shared.gca) == "function" then
                                    table.insert(assetFunctions, shared.gca)
                                end
                            end
                            for _, name in ipairs({"getcustomasset", "getsynasset"}) do
                                local fn = getGlobal(name)
                                if type(fn) == "function" then table.insert(assetFunctions, fn) end
                            end
                            local isfile = getGlobal("isfile")
                            local readfile = getGlobal("readfile")
                            local function useCachedImage(knownWritten)
                                if not knownWritten then
                                    if type(isfile) ~= "function" then return false end
                                    local ok, exists = pcall(isfile, path)
                                    if not ok or not exists then return false end
                                end
                                if type(readfile) == "function" then
                                    local ok, bytes = pcall(readfile, path)
                                    if not ok or type(bytes) ~= "string" or bytes:sub(1, 8) ~= "\137PNG\r\n\26\n" then return false end
                                end
                                for _, customAsset in ipairs(assetFunctions) do
                                    local loaded, asset = pcall(customAsset, path)
                                    if loaded and type(asset) == "string" and asset ~= "" and icon.Parent then
                                        icon.Image = asset
                                        return true
                                    end
                                end
                                return false
                            end
                            if useCachedImage() then return end

                            local body
                            if type(req) == "function" then
                                local ok, response = pcall(req, {Url = url, Method = "GET"})
                                if ok and type(response) == "table" and tonumber(response.StatusCode or response.Status) == 200 then
                                    body = response.Body or response.body
                                end
                            end
                            if type(body) ~= "string" then
                                local ok, downloaded = pcall(function() return game:HttpGet(url, true) end)
                                if ok then body = downloaded end
                            end
                            if type(body) ~= "string" or #body < 100 or body:sub(1, 8) ~= "\137PNG\r\n\26\n" then return end
                            local writefile = getGlobal("writefile")
                            local makefolder = getGlobal("makefolder")
                            if type(writefile) ~= "function" then return end
                            if type(makefolder) == "function" then
                                pcall(makefolder, "Staconf")
                                pcall(makefolder, "Staconf/assets")
                            end
                            local saved = pcall(writefile, path, body)
                            if saved then useCachedImage(true) end
                        end)
                    end)
                end)
            end)
        end

        loaderErrorHandler = reportAndShowError
        local isBadExecutor = lowerName:find("xeno") or lowerName:find("solara") or (getgenv and getgenv().TEST_UNSUPPORTED)

        pcall(function()
            if type(isfolder) == "function" and type(makefolder) == "function" then
                if not isfolder("larp") then makefolder("larp") end
                if not isfolder("larp/load") then makefolder("larp/load") end
            end
        end)

        local function ensureAsset(path, url)
            pcall(function()
                if type(isfile) == "function" and not isfile(path) then
                    local downloaded = nil
                    if req then
                        local ok, res = pcall(req, { Url = url, Method = "GET" })
                        if ok and res and res.Body and #res.Body > 500 then
                            downloaded = res.Body
                        end
                    end
                    if not downloaded and type(game.HttpGet) == "function" then
                        local ok, res = pcall(game.HttpGet, game, url)
                        if ok and type(res) == "string" and #res > 500 then
                            downloaded = res
                        end
                    end
                    if downloaded and type(writefile) == "function" then
                        pcall(writefile, path, downloaded)
                    end
                end
            end)
        end

        ensureAsset("larp/splash.png", "https://api.x8stuff.lol/assets/splash.png")
        if isBadExecutor then
            ensureAsset("larp/real.png", "https://api.x8stuff.lol/assets/real.png")
            ensureAsset("larp/madium.png", "https://api.x8stuff.lol/assets/madium.png")
            ensureAsset("larp/load/Fear Before Failure 7.ogg", "https://api.x8stuff.lol/assets/fear_before_failure_7.ogg")
        end

        local gca = getgenv and getgenv().gca or getcustomasset or getsynasset or function(p) return p end

        local splashAsset = nil
        pcall(function()
            if type(isfile) == "function" and isfile("larp/splash.png") then
                splashAsset = gca("larp/splash.png")
            end
        end)
        if not splashAsset then
            splashAsset = "rbxassetid://10723415766"
        end

        local parentGui = nil
        pcall(function()
            if gethui then
                parentGui = gethui()
            elseif CoreGui then
                parentGui = CoreGui
            else
                parentGui = Players.LocalPlayer:WaitForChild("PlayerGui")
            end
        end)
        if not parentGui then parentGui = CoreGui end

        local splashGui = Instance.new("ScreenGui")
        splashGui.Name = "LarpkuranSplash_" .. tostring(math.random(10000, 99999))
        splashGui.ResetOnSpawn = false
        splashGui.IgnoreGuiInset = false
        splashGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        splashGui.DisplayOrder = 999999

        local function interFont(weight)
            local ok, face = pcall(Font.new, "rbxassetid://12187365364", weight or Enum.FontWeight.Regular)
            return ok and face or Font.fromEnum(Enum.Font.BuilderSans)
        end

        local demoSplash = "Staconf/assets/x8stuff-splash.png"
        if type(isfile) == "function" and type(gca) == "function" then
            pcall(function()
                if isfile(demoSplash) then splashAsset = gca(demoSplash) end
            end)
        end
        if splashAsset == "rbxassetid://10723415766" then splashAsset = nil end

        local mainCard = Instance.new("Frame")
        mainCard.Name = "Card"
        mainCard.AnchorPoint = Vector2.new(0.5, 0.5)
        mainCard.Position = UDim2.fromScale(0.5, 0.5)
        mainCard.Size = UDim2.new(0.62, 0, 0.62, 0)
        mainCard.BackgroundColor3 = Color3.fromRGB(31, 33, 41)
        mainCard.BorderSizePixel = 0
        mainCard.ClipsDescendants = true
        mainCard.Parent = splashGui

        local maxSize = Instance.new("UISizeConstraint")
        maxSize.MaxSize = Vector2.new(900, 540)
        maxSize.Parent = mainCard

        local cardStroke = Instance.new("UIStroke")
        cardStroke.Color = Color3.fromRGB(96, 101, 116)
        cardStroke.Transparency = 0.35
        cardStroke.Thickness = 1
        cardStroke.Parent = mainCard

        local windowGradient = Instance.new("UIGradient")
        windowGradient.Color = ColorSequence.new(Color3.fromRGB(48, 51, 63), Color3.fromRGB(22, 24, 31))
        windowGradient.Rotation = 90
        windowGradient.Parent = mainCard

        local splashImg = Instance.new("ImageLabel")
        splashImg.Name = "SplashImage"
        splashImg.AnchorPoint = Vector2.new(0.5, 0.5)
        splashImg.Position = UDim2.fromScale(0.5, 0.43)
        splashImg.Size = UDim2.new(0.78, 0, 0.54, 0)
        splashImg.BackgroundTransparency = 1
        splashImg.ScaleType = Enum.ScaleType.Fit
        splashImg.Image = splashAsset or ""
        splashImg.Parent = mainCard

        local fallback = Instance.new("TextLabel")
        fallback.Name = "SplashUnavailableFallback"
        fallback.AnchorPoint = Vector2.new(0.5, 0.5)
        fallback.Position = UDim2.fromScale(0.5, 0.43)
        fallback.Size = UDim2.new(0.86, 0, 0, 80)
        fallback.BackgroundTransparency = 1
        fallback.Text = "LarpKuran"
        fallback.TextColor3 = Color3.fromRGB(245, 245, 247)
        fallback.TextSize = 36
        fallback.FontFace = interFont(Enum.FontWeight.SemiBold)
        fallback.Visible = not splashAsset
        fallback.Parent = mainCard

        if not splashAsset then
            task.spawn(function()
                pcall(function()
                    local downloaded = game:HttpGet("https://raw.githubusercontent.com/x8lua/Staconf/main/assets/x8stuff-splash.png", true)
                    if type(downloaded) ~= "string" or #downloaded <= 100 or downloaded:sub(1, 8) ~= "\137PNG\r\n\26\n" then return end
                    if type(writefile) ~= "function" or type(gca) ~= "function" then return end
                    if type(makefolder) == "function" then
                        pcall(makefolder, "Staconf")
                        pcall(makefolder, "Staconf/assets")
                    end
                    writefile(demoSplash, downloaded)
                    local image = gca(demoSplash)
                    if splashImg.Parent then
                        splashImg.Image = image
                        fallback.Visible = false
                    end
                end)
            end)
        end

        local statusLabel = Instance.new("TextLabel")
        statusLabel.Name = "Status"
        statusLabel.AnchorPoint = Vector2.new(0.5, 1)
        statusLabel.Position = UDim2.new(0.5, 0, 0.76, -11)
        statusLabel.Size = UDim2.new(0.88, 0, 0, 24)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = ""
        statusLabel.TextColor3 = Color3.fromRGB(147, 150, 158)
        statusLabel.TextSize = 12
        statusLabel.FontFace = interFont(Enum.FontWeight.Regular)
        statusLabel.TextXAlignment = Enum.TextXAlignment.Left
        statusLabel.TextTruncate = Enum.TextTruncate.AtEnd
        statusLabel.Visible = false
        statusLabel.Parent = mainCard

        local barBg = Instance.new("Frame")
        barBg.Name = "BarBg"
        barBg.AnchorPoint = Vector2.new(0.5, 0)
        barBg.Position = UDim2.fromScale(0.5, 0.76)
        barBg.Size = UDim2.new(0.88, 0, 0, 6)
        barBg.BackgroundColor3 = Color3.fromRGB(46, 47, 52)
        barBg.BorderSizePixel = 0
        barBg.ClipsDescendants = true
        barBg.Visible = false
        barBg.Parent = mainCard

        local barBgCorner = Instance.new("UICorner")
        barBgCorner.CornerRadius = UDim.new(1, 0)
        barBgCorner.Parent = barBg

        local barFill = Instance.new("Frame")
        barFill.Name = "BarFill"
        barFill.Size = UDim2.fromScale(0, 1)
        barFill.BackgroundColor3 = Color3.fromRGB(250, 250, 252)
        barFill.BorderSizePixel = 0
        barFill.Parent = barBg

        local barFillCorner = Instance.new("UICorner")
        barFillCorner.CornerRadius = UDim.new(1, 0)
        barFillCorner.Parent = barFill

        local percentLabel = Instance.new("TextLabel")
        percentLabel.Name = "Percent"
        percentLabel.AnchorPoint = Vector2.new(1, 1)
        percentLabel.Position = UDim2.new(0.94, 0, 0.76, -11)
        percentLabel.Size = UDim2.new(0, 60, 0, 24)
        percentLabel.BackgroundTransparency = 1
        percentLabel.Text = "0%"
        percentLabel.TextColor3 = Color3.fromRGB(180, 182, 192)
        percentLabel.TextSize = 12
        percentLabel.FontFace = interFont(Enum.FontWeight.Medium)
        percentLabel.TextXAlignment = Enum.TextXAlignment.Right
        percentLabel.Visible = false
        percentLabel.Parent = mainCard

        local fillGrad = Instance.new("UIGradient")
        fillGrad.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(240, 240, 245))
        fillGrad.Parent = barFill

        local subTag = Instance.new("TextLabel")
        subTag.Name = "SubTag"
        subTag.AnchorPoint = Vector2.new(0.5, 0)
        subTag.Position = UDim2.fromScale(0.5, 0.81)
        subTag.Size = UDim2.new(0.78, 0, 0, 20)
        subTag.BackgroundTransparency = 1
        subTag.Text = ""
        subTag.TextColor3 = Color3.fromRGB(147, 150, 158)
        subTag.TextSize = 11
        subTag.TextTruncate = Enum.TextTruncate.AtEnd
        subTag.FontFace = interFont(Enum.FontWeight.Regular)
        subTag.Visible = false
        subTag.Parent = mainCard

        pcall(function() splashGui.Parent = parentGui end)

        local function fitSplash()
            if mainCard.Parent ~= splashGui then return end
            local available = splashGui.AbsoluteSize
            if available.X < 1 or available.Y < 1 then return end
            local compact = available.X < 700 or available.Y < 460
            if compact then
                local width = math.max(1, math.min(560, available.X - 24))
                local height = math.max(1, math.min(420, available.Y - 24, math.max(210, math.floor(available.Y * 0.58))))
                mainCard.Size = UDim2.fromOffset(width, height)
                splashImg.Position = UDim2.fromScale(0.5, 0.35)
                splashImg.Size = UDim2.new(0.82, 0, 0.48, 0)
                fallback.Position = splashImg.Position
                fallback.TextSize = width < 320 and 28 or 36
                statusLabel.AnchorPoint = Vector2.new(0, 1)
                statusLabel.Position = UDim2.new(0, 16, 0.76, -11)
                statusLabel.Size = UDim2.new(1, -94, 0, 24)
                statusLabel.TextSize = 11
                percentLabel.Position = UDim2.new(1, -16, 0.76, -11)
                subTag.Position = UDim2.fromScale(0.5, 0.83)
                subTag.Size = UDim2.new(0.9, 0, 0, 20)
            else
                mainCard.Size = UDim2.new(0.62, 0, 0.62, 0)
                splashImg.Position = UDim2.fromScale(0.5, 0.43)
                splashImg.Size = UDim2.new(0.78, 0, 0.54, 0)
                fallback.Position = splashImg.Position
                fallback.TextSize = 36
                statusLabel.AnchorPoint = Vector2.new(0.5, 1)
                statusLabel.Position = UDim2.new(0.5, 0, 0.76, -11)
                statusLabel.Size = UDim2.new(0.88, 0, 0, 24)
                statusLabel.TextSize = 12
                percentLabel.Position = UDim2.new(0.94, 0, 0.76, -11)
                subTag.Position = UDim2.fromScale(0.5, 0.81)
                subTag.Size = UDim2.new(0.78, 0, 0, 20)
            end
        end
        fitSplash()
        splashGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitSplash)

        local progressReady = false
        local progressClosed = false
        local pendingProgress = 0
        local pendingMessage = "Preparing update environment..."
        local progressTween = nil

        local function setProgress(pct, msg)
            loaderStage = msg or loaderStage
            if progressClosed then return end
            pendingProgress = math.clamp(pct, 0, 100)
            pendingMessage = msg or pendingMessage
            if not progressReady then return end
            statusLabel.Text = pendingMessage
            if progressTween then progressTween:Cancel() end
            if pendingProgress == 100 then
                barFill.Size = UDim2.fromScale(1, 1)
                return
            end
            progressTween = TweenService:Create(barFill, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.fromScale(pendingProgress / 100, 1)
            })
            progressTween:Play()
        end

        task.delay(Random.new():NextNumber(0.5, 1.2), function()
            if progressClosed or isBadExecutor or not splashGui.Parent then return end
            progressReady = true
            statusLabel.Visible = true
            barBg.Visible = true
            setProgress(pendingProgress, pendingMessage)
        end)

        if isBadExecutor then
            progressReady = true
            statusLabel.Visible = true
            barBg.Visible = true
            percentLabel.Visible = true
            subTag.Visible = true
            subTag.Text = "LARPKURAN // SECURE RUNTIME PIPELINE"
        end

        local function closeSplash()
            if progressClosed then return end
            progressClosed = true
            if progressTween then progressTween:Cancel() end
            pcall(function() splashGui:Destroy() end)
        end
        loaderCleanup = closeSplash

        if isBadExecutor then
            local random = Random.new()
            local connections, sounds, animations = {}, {}, {}
            local alive, dismissible, closing = true, false, false
            local blurEffect = nil

            local function connect(signal, callback)
                local connection = signal:Connect(callback)
                table.insert(connections, connection)
                return connection
            end

            connect(splashGui.Destroying, function()
                alive = false
                for _, connection in ipairs(connections) do connection:Disconnect() end
                for _, animation in ipairs(animations) do animation:Cancel() end
                for _, sound in ipairs(sounds) do sound:Destroy() end
                if blurEffect and blurEffect.Parent then
                    blurEffect:Destroy()
                end
            end)

            local function tween(object, duration, properties, style, direction)
                local animation = TweenService:Create(object, TweenInfo.new(duration,
                    style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out), properties)
                table.insert(animations, animation)
                animation:Play()
                return animation
            end

            local function sound(id, name)
                local result = Instance.new("Sound")
                result.Name = name
                result.SoundId = "rbxassetid://" .. id
                result.Volume = 1
                result.Parent = SoundService
                table.insert(sounds, result)
                return result
            end

            local intro = sound("81144200499205", "LoadingSFX")
            local unstick = sound("98298598356256", "UnstickSFX")
            local explosion = sound("139316396351592", "ExplosionSFX")
            local clickSfx = sound("129797567433050", "ClickSFX")
            local scaryJumpscareSfx = sound("131708837601656", "ScaryRefusalSFX")

            local fearBgm = nil
            pcall(function()
                if type(isfile) == "function" and isfile("larp/load/Fear Before Failure 7.ogg") then
                    local assetId = gca("larp/load/Fear Before Failure 7.ogg")
                    if assetId then
                        fearBgm = Instance.new("Sound")
                        fearBgm.Name = "FearBeforeFailureBGM"
                        fearBgm.SoundId = assetId
                        fearBgm.Volume = 0
                        fearBgm.Looped = true
                        fearBgm.Parent = SoundService
                        table.insert(sounds, fearBgm)
                    end
                end
            end)

            pcall(function()
                blurEffect = Instance.new("BlurEffect")
                blurEffect.Name = "UnsupportedBlur"
                blurEffect.Size = 0
                blurEffect.Parent = Lighting
                tween(blurEffect, 0.5, { Size = 14 })
            end)

            local flashOverlay = Instance.new("Frame")
            flashOverlay.Name = "JumpscareFlash"
            flashOverlay.Size = UDim2.fromScale(1, 1)
            flashOverlay.BackgroundColor3 = Color3.fromRGB(240, 20, 35)
            flashOverlay.BackgroundTransparency = 1
            flashOverlay.BorderSizePixel = 0
            flashOverlay.ZIndex = 999
            flashOverlay.Parent = splashGui

            local stage = Instance.new("Frame")
            stage.Size = UDim2.fromScale(1, 1)
            stage.BackgroundTransparency = 1
            stage.BorderSizePixel = 0
            stage.ZIndex = 2
            stage.Parent = splashGui

            local warning = Instance.new("Frame")
            warning.Size = UDim2.fromScale(1, 1)
            warning.BackgroundTransparency = 1
            warning.BorderSizePixel = 0
            warning.Visible = false
            warning.ZIndex = 3
            warning.Parent = splashGui

            local function label(parent, name, text, position, size, color, fontSize)
                local result = Instance.new("TextLabel")
                result.Name = name
                result.Position = position
                result.Size = size
                result.BackgroundTransparency = 1
                result.Font = Enum.Font.GothamMedium
                result.Text = text
                result.TextColor3 = color
                result.TextSize = fontSize
                result.Parent = parent
                return result
            end

            local white = Color3.fromRGB(250, 252, 255)
            local offWhite = Color3.fromRGB(230, 235, 245)
            local muted = Color3.fromRGB(160, 170, 190)
            local subMuted = Color3.fromRGB(110, 120, 140)
            local red = Color3.fromRGB(255, 55, 75)
            local bloodRed = Color3.fromRGB(220, 25, 45)
            local cyan = Color3.fromRGB(0, 225, 255)
            local purple = Color3.fromRGB(190, 120, 255)
            local green = Color3.fromRGB(34, 211, 138)

            local warningLayout = Instance.new("ScrollingFrame")
            warningLayout.AnchorPoint = Vector2.new(0.5, 0.5)
            warningLayout.Position = UDim2.fromScale(0.5, 0.5)
            warningLayout.Size = UDim2.fromOffset(820, 680)
            warningLayout.BackgroundTransparency = 1
            warningLayout.BorderSizePixel = 0
            warningLayout.CanvasSize = UDim2.fromOffset(0, 680)
            warningLayout.ScrollBarThickness = 3
            warningLayout.ScrollBarImageColor3 = Color3.fromRGB(90, 25, 35)
            warningLayout.ScrollingDirection = Enum.ScrollingDirection.Y
            warningLayout.Parent = warning

            local warningBody = Instance.new("Frame")
            warningBody.Size = UDim2.new(1, 0, 0, 680)
            warningBody.BackgroundTransparency = 1
            warningBody.Parent = warningLayout

            local function fitWarning()
                local size = splashGui.AbsoluteSize
                local w = math.max(1, math.floor(math.min(820, size.X - 28)))
                local h = math.max(1, math.floor(math.min(680, size.Y - 28)))
                warningLayout.Size = UDim2.fromOffset(w, h)
                warningLayout.Position = UDim2.fromOffset(math.floor(size.X / 2), math.floor(size.Y / 2))
            end
            fitWarning()
            connect(splashGui:GetPropertyChangedSignal("AbsoluteSize"), fitWarning)

            local function fadeTree(parent, duration, hidden)
                for _, child in ipairs(parent:GetDescendants()) do
                    local properties = {}
                    if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                        table.insert(properties, "TextTransparency")
                    elseif child:IsA("ImageLabel") then
                        table.insert(properties, "ImageTransparency")
                    elseif child:IsA("UIStroke") then
                        table.insert(properties, "Transparency")
                    end
                    if child:IsA("GuiObject") and (child.BackgroundTransparency < 1
                        or child:GetAttribute("RestBackgroundTransparency") ~= nil) then
                        table.insert(properties, "BackgroundTransparency")
                    end
                    for _, property in ipairs(properties) do
                        local attribute = "Rest" .. property
                        local base = child:GetAttribute(attribute)
                        if base == nil then
                            base = child[property]
                            child:SetAttribute(attribute, base)
                        end
                        if not hidden then child[property] = 1 end
                        tween(child, duration, { [property] = hidden and 1 or base })
                    end
                end
            end

            local headerCard = Instance.new("Frame")
            headerCard.Name = "HeaderCard"
            headerCard.Position = UDim2.fromOffset(16, 4)
            headerCard.Size = UDim2.new(1, -32, 0, 178)
            headerCard.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
            headerCard.BackgroundTransparency = 0.08
            headerCard.BorderSizePixel = 0
            headerCard.Parent = warningBody

            local hCorner = Instance.new("UICorner")
            hCorner.CornerRadius = UDim.new(0, 16)
            hCorner.Parent = headerCard

            local headerStroke = Instance.new("UIStroke")
            headerStroke.Color = Color3.fromRGB(180, 25, 45)
            headerStroke.Thickness = 1.4
            headerStroke.Transparency = 0.35
            headerStroke.Parent = headerCard

            local chip = Instance.new("Frame")
            chip.Name = "StatusChip"
            chip.AnchorPoint = Vector2.new(0.5, 0)
            chip.Position = UDim2.new(0.5, 0, 0, 16)
            chip.Size = UDim2.fromOffset(250, 24)
            chip.BackgroundColor3 = Color3.fromRGB(32, 8, 14)
            chip.BorderSizePixel = 0
            chip.Parent = headerCard

            local chipCorner = Instance.new("UICorner")
            chipCorner.CornerRadius = UDim.new(0, 12)
            chipCorner.Parent = chip

            local chipStroke = Instance.new("UIStroke")
            chipStroke.Color = Color3.fromRGB(220, 30, 50)
            chipStroke.Thickness = 1
            chipStroke.Transparency = 0.3
            chipStroke.Parent = chip

            local chipDot = Instance.new("Frame")
            chipDot.AnchorPoint = Vector2.new(0, 0.5)
            chipDot.Position = UDim2.new(0, 10, 0.5, 0)
            chipDot.Size = UDim2.fromOffset(6, 6)
            chipDot.BackgroundColor3 = Color3.fromRGB(255, 45, 75)
            chipDot.BorderSizePixel = 0
            chipDot.Parent = chip

            local dotCorner = Instance.new("UICorner")
            dotCorner.CornerRadius = UDim.new(0, 3)
            dotCorner.Parent = chipDot

            local chipText = label(chip, "ChipLabel", "UNSUPPORTED EXECUTOR DETECTED", UDim2.new(0, 24, 0, 0),
                UDim2.new(1, -32, 1, 0), Color3.fromRGB(255, 90, 110), 10)
            chipText.Font = Enum.Font.GothamBold
            chipText.TextXAlignment = Enum.TextXAlignment.Center

            task.spawn(function()
                local dotT = 0
                while alive do
                    dotT = dotT + 0.05
                    if chipDot and chipDot.Parent then
                        local p = (math.sin(dotT * 3.2) + 1) * 0.5
                        chipDot.BackgroundTransparency = p * 0.75
                    end
                    task.wait(0.05)
                end
            end)

            local title = label(headerCard, "Title", "Execution Blocked — Critical Detection Risk",
                UDim2.new(0, 20, 0, 48), UDim2.new(1, -40, 0, 28), white, 20)
            title.Font = Enum.Font.GothamBold
            title.TextWrapped = true

            local description = label(headerCard, "Description",
                "You are one step away from getting flagged and permanently banned in Gakuran because you are using an untrusted executor (like Xeno or Solara).\nTo protect your account from server-side bans, switch to an officially verified executor below.",
                UDim2.new(0, 20, 0, 80), UDim2.new(1, -40, 0, 38), Color3.fromRGB(220, 225, 235), 12)
            description.TextWrapped = true

            local divider = Instance.new("Frame")
            divider.Position = UDim2.new(0, 20, 0, 128)
            divider.Size = UDim2.new(1, -40, 0, 1)
            divider.BackgroundColor3 = Color3.fromRGB(60, 20, 30)
            divider.BorderSizePixel = 0
            divider.Parent = headerCard

            local divGrad = Instance.new("UIGradient")
            divGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.9),
                NumberSequenceKeypoint.new(0.5, 0.1),
                NumberSequenceKeypoint.new(1, 0.9),
            })
            divGrad.Parent = divider

            local sectionTitle = label(headerCard, "SectionTitle", "OFFICIALLY SUPPORTED EXECUTORS (UNDETECTED)",
                UDim2.new(0, 0, 0, 138), UDim2.new(1, 0, 0, 26), cyan, 11)
            sectionTitle.Font = Enum.Font.GothamBold

            local actions = Instance.new("Frame")
            actions.Name = "Actions"
            actions.Position = UDim2.fromOffset(16, 196)
            actions.Size = UDim2.new(1, -32, 0, 280)
            actions.BackgroundTransparency = 1
            actions.Visible = false
            actions.Parent = warningBody

            local function executorCard(config)
                local cardWrapper = Instance.new("Frame")
                cardWrapper.Name = config.Name .. "Wrapper"
                cardWrapper.Position = UDim2.new(config.Right and 0.5 or 0, config.Right and 8 or 0, 0, 0)
                cardWrapper.Size = UDim2.new(0.5, -8, 0, 276)
                cardWrapper.BackgroundTransparency = 1
                cardWrapper.Parent = actions

                local panel = Instance.new("Frame")
                panel.Name = "Card"
                panel.Position = UDim2.fromOffset(0, 0)
                panel.Size = UDim2.fromScale(1, 1)
                panel.BackgroundColor3 = Color3.fromRGB(12, 13, 18)
                panel.BackgroundTransparency = 0.05
                panel.BorderSizePixel = 0
                panel.ClipsDescendants = true
                panel.Parent = cardWrapper

                local pCorner = Instance.new("UICorner")
                pCorner.CornerRadius = UDim.new(0, 16)
                pCorner.Parent = panel

                local panelStroke = Instance.new("UIStroke")
                panelStroke.Color = config.AccentColor
                panelStroke.Thickness = 1.2
                panelStroke.Transparency = 0.55
                panelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                panelStroke.Parent = panel

                local strokeGradient = Instance.new("UIGradient")
                strokeGradient.Rotation = 45
                strokeGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, white),
                    ColorSequenceKeypoint.new(0.4, config.AccentColor),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 18, 26)),
                })
                strokeGradient.Parent = panelStroke

                local bgImage = Instance.new("ImageLabel")
                bgImage.Name = "CardBackground"
                bgImage.Size = UDim2.fromScale(1, 1)
                bgImage.Position = UDim2.fromScale(0, 0)
                bgImage.BackgroundTransparency = 1
                bgImage.ScaleType = Enum.ScaleType.Crop
                bgImage.Image = gca(config.ImagePath)
                bgImage.ZIndex = 1
                bgImage.Parent = panel

                local bgCorner = Instance.new("UICorner")
                bgCorner.CornerRadius = UDim.new(0, 16)
                bgCorner.Parent = bgImage

                local artVignette = Instance.new("Frame")
                artVignette.Name = "ArtVignette"
                artVignette.Size = UDim2.fromScale(1, 1)
                artVignette.BackgroundColor3 = Color3.fromRGB(10, 11, 16)
                artVignette.BackgroundTransparency = 0
                artVignette.BorderSizePixel = 0
                artVignette.ZIndex = 2
                artVignette.Parent = panel

                local avCorner = Instance.new("UICorner")
                avCorner.CornerRadius = UDim.new(0, 16)
                avCorner.Parent = artVignette

                local avGrad = Instance.new("UIGradient")
                avGrad.Rotation = 90
                avGrad.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.42),
                    NumberSequenceKeypoint.new(0.40, 0.28),
                    NumberSequenceKeypoint.new(0.70, 0.05),
                    NumberSequenceKeypoint.new(1, 0.01),
                })
                avGrad.Parent = artVignette

                local contentFrame = Instance.new("Frame")
                contentFrame.Name = "Content"
                contentFrame.Size = UDim2.fromScale(1, 1)
                contentFrame.BackgroundTransparency = 1
                contentFrame.ZIndex = 3
                contentFrame.Parent = panel

                local cardHeader = Instance.new("Frame")
                cardHeader.Name = "CardHeader"
                cardHeader.Position = UDim2.fromOffset(16, 14)
                cardHeader.Size = UDim2.new(1, -32, 0, 32)
                cardHeader.BackgroundTransparency = 1
                cardHeader.Parent = contentFrame

                local dotIndicator = Instance.new("Frame")
                dotIndicator.AnchorPoint = Vector2.new(0, 0.5)
                dotIndicator.Position = UDim2.new(0, 0, 0.5, 0)
                dotIndicator.Size = UDim2.fromOffset(8, 8)
                dotIndicator.BackgroundColor3 = config.AccentColor
                dotIndicator.BorderSizePixel = 0
                dotIndicator.Parent = cardHeader

                local dotIndCorner = Instance.new("UICorner")
                dotIndCorner.CornerRadius = UDim.new(0, 4)
                dotIndCorner.Parent = dotIndicator

                local cardTitle = label(cardHeader, "Title", config.Name, UDim2.new(0, 16, 0, 0),
                    UDim2.new(0.55, -16, 1, 0), white, 21)
                cardTitle.Font = Enum.Font.GothamBold
                cardTitle.TextXAlignment = Enum.TextXAlignment.Left

                local badge = Instance.new("Frame")
                badge.Name = "Badge"
                badge.AnchorPoint = Vector2.new(1, 0.5)
                badge.Position = UDim2.new(1, 0, 0.5, 0)
                badge.Size = UDim2.fromOffset(config.BadgeWidth or 96, 22)
                badge.BackgroundColor3 = config.BadgeBg
                badge.BorderSizePixel = 0
                badge.Parent = cardHeader

                local bCorner = Instance.new("UICorner")
                bCorner.CornerRadius = UDim.new(0, 6)
                bCorner.Parent = badge

                local badgeStroke = Instance.new("UIStroke")
                badgeStroke.Color = config.AccentColor
                badgeStroke.Thickness = 1
                badgeStroke.Transparency = 0.35
                badgeStroke.Parent = badge

                local badgeTxt = label(badge, "BadgeText", config.BadgeText, UDim2.fromScale(0, 0),
                    UDim2.fromScale(1, 1), config.AccentColor, 10)
                badgeTxt.Font = Enum.Font.GothamBold

                local controlsContainer = Instance.new("Frame")
                controlsContainer.Name = "ControlsContainer"
                controlsContainer.AnchorPoint = Vector2.new(0.5, 1)
                controlsContainer.Position = UDim2.new(0.5, 0, 1, -14)
                controlsContainer.Size = UDim2.new(1, -32, 0, 94)
                controlsContainer.BackgroundTransparency = 1
                controlsContainer.Parent = contentFrame

                local urlPill = Instance.new("Frame")
                urlPill.Name = "URLContainer"
                urlPill.Position = UDim2.fromOffset(0, 0)
                urlPill.Size = UDim2.new(1, 0, 0, 38)
                urlPill.BackgroundColor3 = Color3.fromRGB(15, 17, 24)
                urlPill.BackgroundTransparency = 0.2
                urlPill.BorderSizePixel = 0
                urlPill.Parent = controlsContainer

                local urlCorner = Instance.new("UICorner")
                urlCorner.CornerRadius = UDim.new(0, 10)
                urlCorner.Parent = urlPill

                local urlPillStroke = Instance.new("UIStroke")
                urlPillStroke.Color = Color3.fromRGB(40, 48, 70)
                urlPillStroke.Thickness = 1
                urlPillStroke.Transparency = 0.45
                urlPillStroke.Parent = urlPill

                local domainIcon = label(urlPill, "DomainIcon", "LINK", UDim2.fromOffset(10, 0),
                    UDim2.fromOffset(30, 38), subMuted, 9)
                domainIcon.Font = Enum.Font.GothamBold

                local urlBox = Instance.new("TextBox")
                urlBox.Name = "URLBox"
                urlBox.Text = config.Url
                urlBox.ClearTextOnFocus = false
                urlBox.TextEditable = false
                urlBox.Position = UDim2.new(0, 42, 0, 0)
                urlBox.Size = UDim2.new(1, -50, 1, 0)
                urlBox.BackgroundTransparency = 1
                urlBox.BorderSizePixel = 0
                urlBox.Font = Enum.Font.GothamMedium
                urlBox.TextSize = 12
                urlBox.TextColor3 = offWhite
                urlBox.TextXAlignment = Enum.TextXAlignment.Left
                urlBox.Parent = urlPill

                local copyBtn = Instance.new("TextButton")
                copyBtn.Name = "CopyButton"
                copyBtn.Position = UDim2.fromOffset(0, 46)
                copyBtn.Size = UDim2.new(1, 0, 0, 48)
                copyBtn.BackgroundColor3 = config.ButtonColor
                copyBtn.BackgroundTransparency = 0.05
                copyBtn.BorderSizePixel = 0
                copyBtn.Text = "COPY OFFICIAL LINK"
                copyBtn.TextSize = 13
                copyBtn.TextColor3 = white
                copyBtn.Font = Enum.Font.GothamBold
                copyBtn.AutoButtonColor = false
                copyBtn.Parent = controlsContainer

                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 12)
                btnCorner.Parent = copyBtn

                local copyBtnStroke = Instance.new("UIStroke")
                copyBtnStroke.Color = config.AccentColor
                copyBtnStroke.Thickness = 1.2
                copyBtnStroke.Transparency = 0.25
                copyBtnStroke.Parent = copyBtn

                local btnGradient = Instance.new("UIGradient")
                btnGradient.Rotation = 90
                btnGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180)),
                })
                btnGradient.Parent = copyBtn

                local hoverOverlay = Instance.new("ImageButton")
                hoverOverlay.Name = "HoverTrigger"
                hoverOverlay.Size = UDim2.fromScale(1, 1)
                hoverOverlay.BackgroundTransparency = 1
                hoverOverlay.BorderSizePixel = 0
                hoverOverlay.ZIndex = 10
                hoverOverlay.AutoButtonColor = false
                hoverOverlay.Parent = panel

                connect(hoverOverlay.MouseEnter, function()
                    if not closing then
                        tween(panel, 0.2, { Position = UDim2.fromOffset(0, -4) })
                        tween(panelStroke, 0.2, { Transparency = 0.1, Thickness = 1.8 })
                        tween(dotIndicator, 0.2, { Size = UDim2.fromOffset(10, 10) })
                    end
                end)
                connect(hoverOverlay.MouseLeave, function()
                    if not closing then
                        tween(panel, 0.2, { Position = UDim2.fromOffset(0, 0) })
                        tween(panelStroke, 0.2, { Transparency = 0.55, Thickness = 1.2 })
                        tween(dotIndicator, 0.2, { Size = UDim2.fromOffset(8, 8) })
                    end
                end)

                connect(copyBtn.MouseEnter, function()
                    if not closing then
                        tween(copyBtn, 0.15, { BackgroundColor3 = config.ButtonHoverColor or config.ButtonColor })
                        tween(copyBtnStroke, 0.15, { Transparency = 0, Thickness = 1.6 })
                    end
                end)
                connect(copyBtn.MouseLeave, function()
                    if not closing then
                        tween(copyBtn, 0.15, { BackgroundColor3 = config.ButtonColor })
                        tween(copyBtnStroke, 0.15, { Transparency = 0.25, Thickness = 1.2 })
                    end
                end)

                local function doCopy()
                    if not dismissible or closing then return end
                    pcall(function() clickSfx:Play() end)
                    local copied = false
                    if type(setclipboard) == "function" then
                        copied = pcall(setclipboard, config.Url)
                    elseif type(toclipboard) == "function" then
                        copied = pcall(toclipboard, config.Url)
                    end
                    if copied then
                        copyBtn.Text = "COPIED TO CLIPBOARD"
                        copyBtn.TextColor3 = white
                        copyBtn.BackgroundColor3 = Color3.fromRGB(16, 90, 52)
                        copyBtnStroke.Color = green
                        task.delay(1.8, function()
                            if alive and not closing then
                                copyBtn.Text = "COPY OFFICIAL LINK"
                                copyBtn.TextColor3 = white
                                copyBtn.BackgroundColor3 = config.ButtonColor
                                copyBtnStroke.Color = config.AccentColor
                            end
                        end)
                    else
                        urlBox:CaptureFocus()
                        urlBox.SelectionStart = 1
                        urlBox.CursorPosition = #config.Url + 1
                    end
                end

                connect(copyBtn.Activated, doCopy)
                connect(hoverOverlay.Activated, doCopy)

                return cardWrapper
            end

            local realWrapper = executorCard({
                Name = "Real",
                Url = "https://projectreal.gg/",
                Right = false,
                ImagePath = "larp/real.png",
                AccentColor = cyan,
                BadgeText = "RECOMMENDED",
                BadgeWidth = 100,
                BadgeBg = Color3.fromRGB(0, 32, 48),
                ButtonColor = Color3.fromRGB(0, 70, 110),
                ButtonHoverColor = Color3.fromRGB(0, 95, 145),
            })

            local madiumWrapper = executorCard({
                Name = "Madium",
                Url = "http://getmadium.net/",
                Right = true,
                ImagePath = "larp/madium.png",
                AccentColor = purple,
                BadgeText = "VERIFIED UNDETECTED",
                BadgeWidth = 135,
                BadgeBg = Color3.fromRGB(36, 16, 52),
                ButtonColor = Color3.fromRGB(75, 32, 115),
                ButtonHoverColor = Color3.fromRGB(98, 42, 150),
            })

            local warningPill = Instance.new("Frame")
            warningPill.Name = "NoticeCard"
            warningPill.Position = UDim2.fromOffset(16, 490)
            warningPill.Size = UDim2.new(1, -32, 0, 42)
            warningPill.BackgroundColor3 = Color3.fromRGB(22, 9, 13)
            warningPill.BackgroundTransparency = 0.25
            warningPill.BorderSizePixel = 0
            warningPill.Parent = warningBody

            local wpCorner = Instance.new("UICorner")
            wpCorner.CornerRadius = UDim.new(0, 10)
            wpCorner.Parent = warningPill

            local wpStroke = Instance.new("UIStroke")
            wpStroke.Color = bloodRed
            wpStroke.Thickness = 1
            wpStroke.Transparency = 0.6
            wpStroke.Parent = warningPill

            local noticeTxt = label(warningPill, "NoticeText",
                "WARNING: Detected executors (Xeno / Solara) leak memory addresses and result in an instant permanent ban in Gakuran.",
                UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), Color3.fromRGB(255, 185, 195), 12)
            noticeTxt.Font = Enum.Font.GothamMedium
            noticeTxt.TextWrapped = true

            local insist = Instance.new("TextButton")
            insist.Name = "UseAnyway"
            insist.Position = UDim2.fromOffset(16, 544)
            insist.Size = UDim2.new(1, -32, 0, 48)
            insist.BackgroundColor3 = Color3.fromRGB(24, 8, 12)
            insist.BackgroundTransparency = 0.15
            insist.BorderSizePixel = 0
            insist.Text = "I accept the permanent ban risk, continue on " .. executorName .. " anyway"
            insist.TextSize = 13
            insist.TextColor3 = Color3.fromRGB(255, 150, 160)
            insist.Font = Enum.Font.GothamBold
            insist.AutoButtonColor = false
            insist.TextWrapped = true
            insist.TextTruncate = Enum.TextTruncate.AtEnd
            insist.Parent = warningBody

            local inCorner = Instance.new("UICorner")
            inCorner.CornerRadius = UDim.new(0, 12)
            inCorner.Parent = insist

            local insistStroke = Instance.new("UIStroke")
            insistStroke.Color = bloodRed
            insistStroke.Thickness = 1.2
            insistStroke.Transparency = 0.45
            insistStroke.Parent = insist

            connect(insist.MouseEnter, function()
                if not closing then
                    tween(insistStroke, 0.15, { Color = red, Transparency = 0.1, Thickness = 1.5 })
                    tween(insist, 0.15, { BackgroundTransparency = 0.05 })
                end
            end)
            connect(insist.MouseLeave, function()
                if not closing then
                    tween(insistStroke, 0.15, { Color = bloodRed, Transparency = 0.45, Thickness = 1.2 })
                    tween(insist, 0.15, { BackgroundTransparency = 0.15 })
                end
            end)

            local refusal = false
            connect(insist.Activated, function()
                if not dismissible or closing then return end
                pcall(function() scaryJumpscareSfx:Play() end)
                refusal = not refusal

                flashOverlay.BackgroundTransparency = 0.12
                tween(flashOverlay, 0.65, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad)

                local shakeStart = os.clock()
                local sConn
                sConn = RunService.RenderStepped:Connect(function()
                    local elapsed = os.clock() - shakeStart
                    if elapsed >= 0.55 or not alive then
                        sConn:Disconnect()
                        warningBody.Position = UDim2.fromOffset(0, 0)
                        return
                    end
                    local decay = (1 - elapsed / 0.55)
                    local sx = math.sin(elapsed * 65) * 18 * decay
                    local sy = math.cos(elapsed * 48) * 8 * decay
                    warningBody.Position = UDim2.fromOffset(math.floor(sx), math.floor(sy))
                end)

                if refusal then
                    title.Text = "EXECUTION BLOCKED — PERMANENT BAN IMMINENT"
                    title.TextColor3 = red
                    description.Text = "You are one step away from getting flagged and permanently banned in Gakuran because you are using Xeno / Solara!\nInjecting under this executor will trigger automated server anticheat and blacklist your account.\nSwitch to Real or Madium immediately."
                    insist.Text = "GO BACK TO SAFETY"
                    insist.TextColor3 = white
                    insist.BackgroundColor3 = Color3.fromRGB(140, 15, 30)
                    headerStroke.Color = red
                    headerStroke.Thickness = 2.5
                else
                    title.Text = "Execution Blocked — Critical Detection Risk"
                    title.TextColor3 = white
                    description.Text = "You are one step away from getting flagged and permanently banned in Gakuran because you are using an untrusted executor (like Xeno or Solara).\nTo protect your account from server-side bans, switch to an officially verified executor below."
                    insist.Text = "I accept the permanent ban risk, continue on " .. executorName .. " anyway"
                    insist.TextColor3 = Color3.fromRGB(255, 150, 160)
                    insist.BackgroundColor3 = Color3.fromRGB(24, 8, 12)
                    headerStroke.Color = Color3.fromRGB(180, 25, 45)
                    headerStroke.Thickness = 1.4
                end
            end)

            local dismiss = Instance.new("TextButton")
            dismiss.Name = "Dismiss"
            dismiss.AnchorPoint = Vector2.new(0.5, 0)
            dismiss.Position = UDim2.new(0.5, 0, 0, 606)
            dismiss.Size = UDim2.fromOffset(180, 38)
            dismiss.BackgroundColor3 = Color3.fromRGB(16, 17, 24)
            dismiss.BackgroundTransparency = 0.3
            dismiss.BorderSizePixel = 0
            dismiss.Text = "DISMISS WARNING"
            dismiss.TextSize = 12
            dismiss.Font = Enum.Font.GothamBold
            dismiss.TextColor3 = muted
            dismiss.AutoButtonColor = false
            dismiss.Visible = false
            dismiss.Parent = warningBody

            local disCorner = Instance.new("UICorner")
            disCorner.CornerRadius = UDim.new(0, 10)
            disCorner.Parent = dismiss

            local dismissStroke = Instance.new("UIStroke")
            dismissStroke.Color = Color3.fromRGB(55, 60, 80)
            dismissStroke.Thickness = 1
            dismissStroke.Transparency = 0.5
            dismissStroke.Parent = dismiss

            connect(dismiss.MouseEnter, function()
                if not closing then
                    tween(dismissStroke, 0.15, { Color = white, Transparency = 0.2 })
                    tween(dismiss, 0.15, { TextColor3 = white, BackgroundTransparency = 0.1 })
                end
            end)
            connect(dismiss.MouseLeave, function()
                if not closing then
                    tween(dismissStroke, 0.15, { Color = Color3.fromRGB(55, 60, 80), Transparency = 0.5 })
                    tween(dismiss, 0.15, { TextColor3 = muted, BackgroundTransparency = 0.3 })
                end
            end)

            connect(dismiss.Activated, function()
                if not alive or not dismissible or closing then return end
                closing = true
                pcall(function() clickSfx:Play() end)
                for _, item in ipairs(sounds) do tween(item, 0.35, { Volume = 0 }) end
                if blurEffect then
                    tween(blurEffect, 0.35, { Size = 0 })
                end
                fadeTree(warning, 0.35, true)
                tween(warningBody, 0.35, { Position = UDim2.fromOffset(0, 30) }).Completed:Wait()
                if alive then splashGui:Destroy() end
            end)

            local function fitWarningContent()
                local mobile = warningLayout.AbsoluteSize.X < 620
                local bodyHeight = mobile and 1070 or 680
                warningBody.Size = UDim2.new(1, 0, 0, bodyHeight)
                warningLayout.CanvasSize = UDim2.fromOffset(0, bodyHeight)
                headerCard.Size = UDim2.new(1, -32, 0, mobile and 252 or 178)
                chip.Size = mobile and UDim2.new(1, -24, 0, 24) or UDim2.fromOffset(250, 24)
                title.Position = UDim2.fromOffset(20, 48)
                title.Size = UDim2.new(1, -40, 0, mobile and 44 or 28)
                title.TextSize = mobile and 16 or 20
                description.Position = UDim2.fromOffset(20, mobile and 96 or 80)
                description.Size = UDim2.new(1, -40, 0, mobile and 108 or 38)
                description.TextSize = mobile and 11 or 12
                divider.Position = UDim2.fromOffset(20, mobile and 210 or 128)
                sectionTitle.Position = UDim2.fromOffset(0, mobile and 216 or 138)
                sectionTitle.Size = UDim2.new(1, 0, 0, mobile and 32 or 26)
                sectionTitle.TextSize = mobile and 10 or 11
                sectionTitle.TextWrapped = mobile
                actions.Position = UDim2.fromOffset(16, mobile and 264 or 196)
                actions.Size = UDim2.new(1, -32, 0, mobile and 564 or 280)
                realWrapper.Position = UDim2.fromOffset(0, 0)
                realWrapper.Size = mobile and UDim2.new(1, 0, 0, 276) or UDim2.new(0.5, -8, 0, 276)
                madiumWrapper.Position = mobile and UDim2.fromOffset(0, 288) or UDim2.new(0.5, 8, 0, 0)
                madiumWrapper.Size = mobile and UDim2.new(1, 0, 0, 276) or UDim2.new(0.5, -8, 0, 276)
                warningPill.Position = UDim2.fromOffset(16, mobile and 840 or 490)
                warningPill.Size = UDim2.new(1, -32, 0, mobile and 72 or 42)
                noticeTxt.TextSize = mobile and 11 or 12
                insist.Position = UDim2.fromOffset(16, mobile and 924 or 544)
                insist.Size = UDim2.new(1, -32, 0, mobile and 76 or 48)
                insist.TextSize = mobile and 11 or 13
                dismiss.Position = UDim2.new(0.5, 0, 0, mobile and 1012 or 606)
                dismiss.Size = UDim2.fromOffset(180, mobile and 44 or 38)
            end
            fitWarningContent()
            connect(warningLayout:GetPropertyChangedSignal("AbsoluteSize"), fitWarningContent)

            local function animate(duration, callback)
                local started = os.clock()
                while alive do
                    local elapsed = math.min(os.clock() - started, duration)
                    callback(elapsed, elapsed / duration)
                    if elapsed >= duration then return true end
                    RunService.RenderStepped:Wait()
                end
                return false
            end

            local function rotate(vector, angle)
                local c, s = math.cos(angle), math.sin(angle)
                return Vector2.new(vector.X * c - vector.Y * s, vector.X * s + vector.Y * c)
            end

            local loaded = false
            task.spawn(function()
                pcall(function() ContentProvider:PreloadAsync({ splashImg, intro, unstick, explosion, clickSfx, scaryJumpscareSfx }) end)
                loaded = true
            end)
            local deadline = os.clock() + 2
            while alive and not loaded and os.clock() < deadline do task.wait(0.05) end
            if not alive then return end

            intro:Play()
            if not animate(2, function(t)
                local progress = 0.85 * (1 - (1 - t / 2) ^ 2)
                barFill.Size = UDim2.new(progress, 0, 1, 0)
                percentLabel.Text = tostring(math.floor(progress * 100)) .. "%"
                statusLabel.Text = t < 0.7 and "Initializing runtime context..." or (t < 1.4 and "Validating environment integrity..." or "Verifying executor signatures...")
            end) then return end

            statusLabel.Text = "UNSUPPORTED EXECUTOR DETECTED"
            statusLabel.TextColor3 = red
            percentLabel.Text = "FAILED"
            percentLabel.TextColor3 = red
            fillGrad.Color = ColorSequence.new(red, Color3.fromRGB(255, 140, 110))
            tween(intro, 1.5, { PlaybackSpeed = 0, Volume = 0 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local restPosition = mainCard.Position
            if not animate(1.5, function(t, fraction)
                local kick = math.exp(-t * 3.5) * 6
                mainCard.Position = restPosition + UDim2.fromOffset(
                    math.floor(math.sin(t * 62) * kick), math.floor(math.cos(t * 41) * kick * 0.4))
                local pulse = math.sin(t * 21) ^ 8 * (1 - fraction)
                splashImg.ImageTransparency = 0.12 * fraction + pulse * 0.16
                barFill.BackgroundTransparency = pulse * 0.6
            end) then return end

            mainCard.Position = restPosition
            barFill.BackgroundTransparency = 0
            subTag.Text = "INTEGRITY CHECK FAILED // DETECTED VULNERABILITY"
            subTag.TextColor3 = red
            intro:Stop()
            if not animate(0.5, function() end) then return end

            local loose = {}
            local cardSz = mainCard.AbsoluteSize
            local cardPos = mainCard.AbsolutePosition + cardSz / 2
            mainCard.Parent = stage
            mainCard.AnchorPoint = Vector2.new(0.5, 0.5)
            mainCard.Position = UDim2.fromOffset(cardPos.X, cardPos.Y)
            mainCard.ZIndex = 1
            table.insert(loose, {
                gui = mainCard, origin = cardPos, size = cardSz,
                offset = Vector2.new(random:NextNumber(-4, 4), random:NextNumber(2, 6)),
                rotation = random:NextNumber(-3, 3),
                bobSpeed = 2.4,
                bobPhase = 0,
                bobAmount = 2.5,
            })

            for index, source in ipairs({ splashImg, statusLabel, percentLabel, barBg, subTag }) do
                local size = source.AbsoluteSize
                local position = source.AbsolutePosition + size / 2
                source.Parent = stage
                source.AnchorPoint = Vector2.new(0.5, 0.5)
                source.Size = UDim2.fromOffset(size.X, size.Y)
                source.Position = UDim2.fromOffset(position.X, position.Y)
                source.ZIndex = (source == splashImg) and 2 or ((source == barBg) and 3 or 4)
                table.insert(loose, {
                    gui = source, origin = position, size = size,
                    offset = Vector2.new(random:NextNumber(-8, 8), random:NextNumber(4, 11)),
                    rotation = random:NextNumber(-6, 6),
                    bobSpeed = random:NextNumber(2.2, 3.8),
                    bobPhase = random:NextNumber(0, math.pi * 2),
                    bobAmount = random:NextNumber(2, 4.5),
                })
            end
            unstick:Play()

            if not animate(4, function(t, fraction)
                local drift = math.clamp(t / 0.8, 0, 1)
                drift = 1 - (1 - drift) ^ 3
                for _, item in ipairs(loose) do
                    local bob = math.sin(t * item.bobSpeed + item.bobPhase) * item.bobAmount
                    local current = item.origin + item.offset * drift + Vector2.new(0, bob)
                    item.gui.Position = UDim2.fromOffset(current.X, current.Y)
                    item.gui.Rotation = item.rotation * drift + math.sin(t * 1.5 + item.bobPhase) * 1.2
                end
            end) then return end

            local center = splashGui.AbsoluteSize / 2
            local fragments = {}
            local function spawnPiece(piece, pos, sz, baseAngle, spd, rotSpd)
                piece.Parent = stage
                piece.AnchorPoint = Vector2.new(0.5, 0.5)
                piece.Size = sz
                piece.Position = UDim2.fromOffset(pos.X, pos.Y)
                table.insert(fragments, {
                    gui = piece, origin = pos,
                    velocity = rotate(Vector2.new(spd, 0), baseAngle),
                    spin = rotSpd,
                })
            end

            for _, item in ipairs(loose) do
                local source = item.gui
                local pos = source.AbsolutePosition + source.AbsoluteSize / 2
                local base = (pos - center)
                local baseAngle = (base.Magnitude > 8) and math.atan2(base.Y, base.X) or random:NextNumber(-math.pi, math.pi)

                if source == mainCard then
                    local cols, rows = 4, 3
                    local sz = source.AbsoluteSize
                    local cellW, cellH = sz.X / cols, sz.Y / rows
                    for r = 0, rows - 1 do
                        for c = 0, cols - 1 do
                            local piece = Instance.new("Frame")
                            piece.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
                            piece.BorderSizePixel = 0
                            piece.Size = UDim2.fromOffset(cellW, cellH)
                            local pc = Instance.new("UICorner")
                            pc.CornerRadius = UDim.new(0, 4)
                            pc.Parent = piece
                            local cellCenter = source.AbsolutePosition + Vector2.new((c + 0.5) * cellW, (r + 0.5) * cellH)
                            local pieceAngle = baseAngle + random:NextNumber(-0.55, 0.55)
                            local spd = random:NextNumber(200, 460)
                            local rotSpd = random:NextNumber(-260, 260)
                            spawnPiece(piece, cellCenter, UDim2.fromOffset(cellW, cellH), pieceAngle, spd, rotSpd)
                        end
                    end
                    source:Destroy()
                elseif source == splashImg and source:IsA("ImageLabel") and source.Image ~= "" then
                    local cols, rows = 3, 3
                    local sz = source.AbsoluteSize
                    local cellW, cellH = sz.X / cols, sz.Y / rows
                    for r = 0, rows - 1 do
                        for c = 0, cols - 1 do
                            local piece = Instance.new("ImageLabel")
                            piece.BackgroundTransparency = 1
                            piece.Image = source.Image
                            piece.ScaleType = Enum.ScaleType.Crop
                            piece.ImageRectOffset = Vector2.new(c * (1024 / cols), r * (1024 / rows))
                            piece.ImageRectSize = Vector2.new(1024 / cols, 1024 / rows)
                            local cellCenter = source.AbsolutePosition + Vector2.new((c + 0.5) * cellW, (r + 0.5) * cellH)
                            local pieceAngle = baseAngle + random:NextNumber(-0.55, 0.55)
                            local spd = random:NextNumber(220, 480)
                            local rotSpd = random:NextNumber(-260, 260)
                            spawnPiece(piece, cellCenter, UDim2.fromOffset(cellW, cellH), pieceAngle, spd, rotSpd)
                        end
                    end
                    source:Destroy()
                else
                    local spd = random:NextNumber(240, 520)
                    local rotSpd = random:NextNumber(-220, 220)
                    spawnPiece(source, pos, UDim2.fromOffset(source.AbsoluteSize.X, source.AbsoluteSize.Y), baseAngle, spd, rotSpd)
                end
            end

            local embers = {}
            for i = 1, 28 do
                local ember = Instance.new("Frame")
                ember.Size = UDim2.fromOffset(random:NextInteger(4, 9), random:NextInteger(4, 9))
                ember.BackgroundColor3 = (i % 2 == 0) and Color3.fromRGB(255, 30, 60) or Color3.fromRGB(180, 10, 30)
                ember.BorderSizePixel = 0
                ember.AnchorPoint = Vector2.new(0.5, 0.5)
                ember.Position = UDim2.fromOffset(center.X, center.Y)
                ember.ZIndex = 5
                ember.Parent = stage

                local embCorner = Instance.new("UICorner")
                embCorner.CornerRadius = UDim.new(0.5, 0)
                embCorner.Parent = ember

                local angle = random:NextNumber(0, math.pi * 2)
                local speed = random:NextNumber(200, 650)
                table.insert(embers, {
                    gui = ember,
                    vel = Vector2.new(math.cos(angle) * speed, math.sin(angle) * speed),
                    pos = center,
                })
            end

            explosion:Play()

            pcall(function()
                if fearBgm then
                    fearBgm:Play()
                    tween(fearBgm, 2.5, { Volume = 0.85 })
                end
            end)

            warning.Visible = true
            warningBody.Position = UDim2.fromOffset(0, 40)
            fadeTree(warning, 0.6, false)
            tween(warningBody, 0.65, { Position = UDim2.fromOffset(0, 0) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            task.delay(0.2, function()
                if alive and actions then
                    actions.Visible = true
                    fadeTree(actions, 0.45, false)
                end
            end)

            local drag = 0.955
            local gravity = Vector2.new(0, 340)
            if not animate(1.6, function(t, fraction)
                local decay = (1 - fraction)
                for _, item in ipairs(fragments) do
                    item.velocity = (item.velocity + gravity * 0.016) * drag
                    item.origin = item.origin + item.velocity * 0.016
                    item.gui.Position = UDim2.fromOffset(item.origin.X, item.origin.Y)
                    item.gui.Rotation = item.gui.Rotation + item.spin * 0.016
                    if item.gui:IsA("GuiObject") then
                        if item.gui:IsA("ImageLabel") then
                            item.gui.ImageTransparency = fraction
                        elseif item.gui:IsA("TextLabel") then
                            item.gui.TextTransparency = fraction
                        end
                        item.gui.BackgroundTransparency = 0.2 + fraction * 0.8
                    end
                end
                for _, emb in ipairs(embers) do
                    emb.vel = emb.vel * 0.96
                    emb.pos = emb.pos + emb.vel * 0.016
                    emb.gui.Position = UDim2.fromOffset(emb.pos.X, emb.pos.Y)
                    emb.gui.BackgroundTransparency = fraction
                end
            end) then return end

            for _, item in ipairs(fragments) do item.gui:Destroy() end
            for _, emb in ipairs(embers) do emb.gui:Destroy() end
            stage:Destroy()

            dismissible = true
            dismiss.Visible = true
            fadeTree(dismiss, 0.4, false)
            return
        end

        setProgress(12, "Analyzing execution context & integrity...")
        task.wait(0.12)

        local safeEnvironment, environmentReason = inspectEnvironment()
        if not safeEnvironment then
            closeSplash()
            reportAndShowError("loader", environmentReason)
            return
        end

        setProgress(32, "Validating security protocol & runtime checksums...")
        task.wait(0.1)

                                local _sharedEnv = _G
        if type(getgenv) == "function" then
            local _ok, _env = pcall(getgenv)
            if _ok and type(_env) == "table" then _sharedEnv = _env end
        end
        local _role = tostring(_sharedEnv.LarpRole or _G.LarpRole or ""):lower()
        local _isStand = (_role == "stand")
        if _role ~= "main" and not _isStand and type(readfile) == "function" and type(isfile) == "function" then
            pcall(function()
                if isfile("larpkuran_always_stand.json") or isfile("larpkuran_stand_session.json") then
                    local _raw = readfile("larpkuran_always_stand.json")
                    if not _raw or _raw == "" then _raw = readfile("larpkuran_stand_session.json") end
                    local _data = game:GetService("HttpService"):JSONDecode(_raw)
                    if type(_data) == "table" and (_data.always == true or _data.role == "Stand" or _data.role == "stand") then
                        local _my = game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer.Name:lower() or ""
                        if not _data.alt or _data.alt == "" or _data.alt:lower() == _my then
                            _isStand = true
                        end
                    end
                end
            end)
        end
        local targetScript = _isStand and "Stand.lua" or "larpkuran.lua"
        local authPayload, encData
        local downloadStillCurrent = function() return true end
        do
            local function authAndFetch()
                local apiOrigin = "https://api.x8stuff.lol"
                local maxEncodedLength = 16 * 1024 * 1024
                if type(req) ~= "function" then
                    return nil, nil, "HTTP requests are unavailable in this executor."
                end

                local function cleanString(value, maxLength)
                    if type(value) ~= "string" then return nil end
                    value = value:match("^%s*(.-)%s*$")
                    if value == "" or #value > maxLength or value:find("%c") then return nil end
                    return value
                end

                local sharedEnv = _G
                if type(getgenv) == "function" then
                    local ok, env = pcall(getgenv)
                    if ok and type(env) == "table" then sharedEnv = env end
                end
                local sessionToken = cleanString(sharedEnv.StacyCMDStartupToken, 8192)
                    or cleanString(sharedEnv.StacyKeyToken, 8192)
                if not sessionToken then return nil, nil, "LOGIN_REQUIRED" end
                local savedKey = nil
                -- Keep the long-lived key inside this login transaction. Stand only needs a non-secret marker.
                for _, scope in ipairs({sharedEnv, _G}) do
                    scope.StacyCMDStartupKey = "SESSION_AUTHENTICATED"
                    scope.StacyKey = "SESSION_AUTHENTICATED"
                    scope.X8_KEY = nil
                end
                if savedKey == "SESSION_AUTHENTICATED" then savedKey = nil end


                local robloxUserId = Players.LocalPlayer and tostring(Players.LocalPlayer.UserId) or ""
                if not robloxUserId:match("^[1-9]%d*$") then
                    return nil, nil, "Unable to verify this Roblox account. Please rejoin and try again."
                end
                local deviceId
                if type(gethwid) == "function" then
                    local ok, value = pcall(gethwid)
                    if ok then
                        value = cleanString(value, 512)
                        if value and #value >= 6 and value:lower() ~= "unknowndevice" then deviceId = value end
                    end
                end
                if not deviceId then
                    local ok, value = pcall(function()
                        return game:GetService("RbxAnalyticsService"):GetClientId()
                    end)
                    if ok then
                        value = cleanString(value, 512)
                        if value and #value >= 6 and value:lower() ~= "unknowndevice" then deviceId = value end
                    end
                end
                -- Existing sessions may be Discord-only. The server enforces
                -- device binding for daily-key sessions and permits device-free OAuth.
                if not deviceId and not sessionToken then
                    return nil, nil, "A device ID is required for key login. Sign in with Discord in the account loader."
                end

                -- DOWNLOAD_TRANSPORT_BEGIN
                local lastFailure = "NO_RESPONSE"
                local requestTimedOut = false
                local downloadDeadline = os.clock() + 120
                local requestAttempt = 0
                local chunkLabel = nil
                -- Counts actual native calls across reloads. A timeout is not native cancellation.
                local transport = sharedEnv._X8DownloadTransport
                if type(transport) ~= "table" or transport.version ~= 1 then
                    transport = {version = 1, inFlight = 0, generation = 0}
                    sharedEnv._X8DownloadTransport = transport
                end
                transport.generation = transport.generation + 1
                local generation = transport.generation
                downloadStillCurrent = function() return transport.generation == generation end
                local function currentTransport()
                    return transport.generation == generation and os.clock() < downloadDeadline
                end
                local function beginRequest(options, ownerAlive)
                    while currentTransport() and (not ownerAlive or ownerAlive()) and transport.inFlight >= 3 do
                        task.wait(0.1)
                    end
                    if not currentTransport() or (ownerAlive and not ownerAlive()) then return nil end
                    local operation = {done = false, accepted = true}
                    transport.inFlight = transport.inFlight + 1
                    task.spawn(function()
                        local ok, response = pcall(req, options)
                        transport.inFlight = math.max(0, transport.inFlight - 1)
                        if operation.accepted and transport.generation == generation then
                            operation.ok, operation.response, operation.done = ok, response, true
                        end
                    end)
                    return operation
                end
                local function readResponse(operation, stage)
                    local ok, response = operation.ok, operation.response
                    operation.response = nil
                    operation.accepted = false
                    if not ok or type(response) ~= "table" then
                        local category = type(response):upper()
                        if type(response) == "string" then
                            local lower = response:lower()
                            category = (lower:find("timeout", 1, true) or lower:find("timed out", 1, true)) and "TRANSPORT_TIMEOUT"
                                or lower:find("resolve", 1, true) and "DNS_FAILED"
                                or (lower:find("ssl", 1, true) or lower:find("certificate", 1, true)) and "TLS_FAILED"
                                or lower:find("connect", 1, true) and "CONNECTION_FAILED" or "TRANSPORT_ERROR"
                        end
                        lastFailure = stage .. "_REQUEST_FAILED_" .. category
                        return nil, nil
                    end
                    local status = tonumber(response.StatusCode or response.Status or response.status_code)
                    lastFailure = stage .. "_HTTP_" .. tostring(status or "UNKNOWN")
                    return response.Body or response.body, status
                end
                local function sendRequest(options, retryableTimeout, timeoutSeconds, ownerAlive)
                    local download = options.Method == "GET"
                    local stage = download and "DOWNLOAD" or "AUTH"
                    local limit = timeoutSeconds or (download and 45 or 20)
                    local operation = beginRequest(options, ownerAlive)
                    if not operation then
                        if ownerAlive and not ownerAlive() then return nil, nil end
                        requestTimedOut = true
                        lastFailure = transport.generation ~= generation and "DOWNLOAD_REPLACED"
                            or "DOWNLOAD_TOTAL_TIMEOUT_120S"
                        return nil, nil
                    end
                    local started = os.clock()
                    local deadline = math.min(started + limit, downloadDeadline)
                    local displayed = -1
                    while not operation.done and currentTransport() and os.clock() < deadline
                        and (not ownerAlive or ownerAlive()) do
                        local elapsed = math.floor(os.clock() - started)
                        if not ownerAlive and elapsed ~= displayed then
                            displayed = elapsed
                            setProgress(download and 72 or 50, string.format("%s (%d/3) - %ds / %ds",
                                download and (chunkLabel or "Downloading Larpkuran") or "Verifying access", math.max(1, requestAttempt), elapsed, limit))
                        end
                        task.wait(0.1)
                    end
                    if ownerAlive and not ownerAlive() then
                        operation.accepted, operation.response = false, nil
                        return nil, nil
                    end
                    if not currentTransport() then
                        operation.accepted, operation.response = false, nil
                        requestTimedOut = true
                        lastFailure = transport.generation ~= generation and "DOWNLOAD_REPLACED" or "DOWNLOAD_TOTAL_TIMEOUT_120S"
                        return nil, nil
                    end
                    if not operation.done then
                        operation.accepted = false
                        requestTimedOut = not retryableTimeout
                        lastFailure = stage .. "_TIMEOUT_" .. tostring(limit) .. "S"
                        return nil, nil
                    end
                    return readResponse(operation, stage)
                end
                -- DOWNLOAD_TRANSPORT_END

                local function postJson(endpoint, payload, headers)
                    local safe, reason = inspectEnvironment()
                    if not safe then lastFailure = reason; return {ok=false, code="ENV_INSPECTION_DETECTED"}, 400 end
                    local encodedOk, encoded = pcall(HttpService.JSONEncode, HttpService, payload)
                    if not encodedOk then return nil, nil end
                    headers = headers or {}
                    headers["Content-Type"] = "application/json"
                    local body, status = sendRequest({
                        Url = apiOrigin .. endpoint,
                        Method = "POST",
                        Headers = headers,
                        Body = encoded,
                    })
                    if type(body) ~= "string" or #body > 16384 then return nil, status end
                    local ok, result = pcall(HttpService.JSONDecode, HttpService, body)
                    if not ok or type(result) ~= "table" then
                        lastFailure = lastFailure .. "_INVALID_JSON"
                        return nil, status
                    end
                    return result, status
                end

                local function keyError(result, status)
                    local code = type(result) == "table" and result.code or nil
                    if code == "GAME_MISMATCH" and type(result) == "table" and type(result.message) == "string" then
                        local serverMessage = cleanString(result.message, 200)
                        if serverMessage and serverMessage ~= "" then return serverMessage end
                    end
                    local messages = {
                        ENV_INSPECTION_DETECTED = "Environment check failed. Restart a clean client before signing in.",
                        INVALID_KEY = "That key was not accepted. Check it and try again.",
                        EXPIRED = "That key has expired. Enter a current key.",
                        REVOKED = "That key is no longer active.",
                        DEVICE_MISMATCH = "That key is linked to another device.",
                        GAME_MISMATCH = "That key does not include this game.",
                        RATE_LIMITED = "Too many attempts. Please try again shortly.",
                    }
                    if messages[code] then return messages[code] end
                    if status == 429 then return "Too many attempts. Please try again shortly." end
                    if status == 401 or status == 403 then return "That key was not accepted. Please try again." end
                    return "Unable to verify your key. Please try again."
                end

                local function activateKey(value, shouldAccept)
                    value = cleanString(value, 512)
                    if not value then return false, "Please enter your key." end
                    local player = Players.LocalPlayer
                    local gakuranName = "Unavailable"
                    pcall(function()
                        local character = player and player.Character
                        local billboard = character and character:FindFirstChild("PlayerInfoBillboard")
                        local info = billboard and billboard:FindFirstChild("Info")
                        if info and tostring(info.Text) ~= "" then gakuranName = tostring(info.Text) end
                    end)
                    local result, status = postJson("/v1/alpha/auth/activate-key", {
                        key = value,
                        deviceId = deviceId,
                        gameId = tostring(game.PlaceId),
                        executorName = executorName,
                        robloxUsername = player and tostring(player.Name) or "Unavailable",
                        robloxUserId = robloxUserId,
                        gakuranName = gakuranName,
                        slotRole = _isStand and "STAND" or "MAIN",
                    })
                    local token = result and cleanString(result.sessionToken, 8192)
                    if status ~= 200 or not result or result.ok ~= true or not token then
                        return false, keyError(result, status)
                    end
                    if shouldAccept and not shouldAccept() then return false, "Loading cancelled." end
                    sessionToken, savedKey = token, value
                    sharedEnv.StacyCMDStartupToken = token
                    sharedEnv.StacyKeyToken = token
                    sharedEnv.StacyCMDStartupKey = "SESSION_AUTHENTICATED"
                    sharedEnv.StacyKey = "SESSION_AUTHENTICATED"
                    sharedEnv.StacyCMDStartupKeyVerified = true
                    sharedEnv.StacyKeyVerified = true
                    return true
                end



                local refreshedSession = false
                local function refreshSession()
                    if refreshedSession then return false end
                    refreshedSession = true
                    return activateKey(savedKey)
                end

                local function validTicket(ticket)
                    if type(ticket) ~= "table" or ticket.ok ~= true or ticket.format ~= "base64" then return false end
                    if type(ticket.tempUrl) ~= "string" then return false end
                    local token = ticket.tempUrl:match("^/v1/temp%-stream/([a-fA-F0-9]+)$")
                    if not token or #token ~= 64 then return false end
                    if type(ticket.sessionKey) ~= "string" or #ticket.sessionKey ~= 64
                        or not ticket.sessionKey:match("^[a-fA-F0-9]+$") then return false end
                    local length = ticket.expectedLength
                    if ticket.chunkSize ~= nil then
                        if type(length) ~= "number" or type(ticket.chunkSize) ~= "number" or ticket.chunkSize ~= 65536
                            or type(ticket.chunkCount) ~= "number" or ticket.chunkCount ~= math.ceil(length / ticket.chunkSize) then return false end
                    end
                    return type(length) == "number" and length > 0 and length <= maxEncodedLength
                        and length % 4 == 0 and length == math.floor(length)
                end

                local function validPayload(data, expectedLength)
                    if type(data) ~= "string" or #data ~= expectedLength then return false end
                    if data:find("[^A-Za-z0-9+/=]") then return false end
                    local padding = data:find("=", 1, true)
                    return not padding or (padding >= #data - 1 and data:sub(padding):match("^==?$") ~= nil)
                end

                -- DOWNLOAD_RECOVERY_BEGIN
                local function recoverDownload(initialTicket, streamHeaders)
                    local live = true
                    local operations = {}
                    local function alive() return live and currentTransport() end
                    local function finish(ticket, data, status)
                        live = false
                        for _, operation in ipairs(operations) do
                            operation.accepted, operation.response = false, nil
                        end
                        return ticket, data, status
                    end
                    local function terminal(status)
                        return status == 401 or status == 403 or status == 409 or status == 429
                    end
                    local started = os.clock()
                    local full = beginRequest({Url = apiOrigin .. initialTicket.tempUrl .. "?format=base64",
                        Method = "GET", Headers = streamHeaders}, alive)
                    if not full then return finish(nil, nil, nil) end
                    operations[#operations + 1] = full
                    local fullRead, fullFailed, recoveryStarted, recoveryDone = false, false, false, false
                    local fatalStatus, completedTicket, completedData
                    local received, completedParts, totalParts = 0, 0, 0
                    local function startRecovery()
                        recoveryStarted = true
                        task.spawn(function()
                            local safe = inspectEnvironment()
                            if not safe then fatalStatus = 403; lastFailure = "ENV_INSPECTION_DETECTED"; recoveryDone = true; return end
                            local encodedOk, encoded = pcall(HttpService.JSONEncode, HttpService, {
                                script = targetScript, format = "base64", chunked = true,
                                role = _isStand and "Stand" or nil, sessionToken = sessionToken, deviceId = deviceId, robloxUserId = robloxUserId,
                            })
                            if not encodedOk then lastFailure = "AUTH_INVALID_JSON"; recoveryDone = true; return end
                            local ticket
                            for retry = 1, 3 do
                                local body, status = sendRequest({Url = apiOrigin .. "/v1/auth/request-script", Method = "POST",
                                    Headers = {["Content-Type"] = "application/json", ["X-X8-Session"] = sessionToken,
                                        ["X-X8-Device"] = deviceId, ["X-X8-Roblox-User-Id"] = robloxUserId}, Body = encoded}, true, 20, alive)
                                if not alive() then return end
                                if terminal(status) then fatalStatus = status; recoveryDone = true; return end
                                if status == 200 then
                                    local decoded, result = false, nil
                                    if type(body) == "string" and #body <= 16384 then
                                        decoded, result = pcall(HttpService.JSONDecode, HttpService, body)
                                    end
                                    if decoded and validTicket(result) and result.chunkSize then
                                        ticket = result
                                        break
                                    end
                                    lastFailure = decoded and "AUTH_RECOVERY_INVALID_TICKET" or "AUTH_RECOVERY_INVALID_JSON"
                                elseif status then
                                    lastFailure = "AUTH_RECOVERY_HTTP_" .. tostring(status)
                                end
                                if retry < 3 then task.wait(0.5 * retry) end
                            end
                            if not ticket then
                                recoveryDone = true
                                return
                            end
                            totalParts = ticket.chunkCount
                            local pieces, nextIndex, workers, failed = {}, 0, 2, false
                            local function workerAlive() return alive() and not fatalStatus and not failed end
                            for _ = 1, 2 do
                                task.spawn(function()
                                    while workerAlive() do
                                        local index = nextIndex
                                        if index >= ticket.chunkCount then break end
                                        nextIndex = nextIndex + 1
                                        local expected = math.min(ticket.chunkSize, ticket.expectedLength - index * ticket.chunkSize)
                                        local valid, piece, status = false, nil, nil
                                        for retry = 0, 2 do
                                            if not workerAlive() then break end
                                            piece, status = sendRequest({
                                                Url = apiOrigin .. ticket.tempUrl .. "?format=base64&chunk=" .. tostring(index) .. "&attempt=" .. tostring(retry),
                                                Method = "GET", Headers = streamHeaders,
                                            }, true, 45, workerAlive)
                                            if not workerAlive() then break end
                                            if terminal(status) then fatalStatus = status; break end
                                            valid = status == 200 and validPayload(piece, expected)
                                            if valid then break end
                                            if retry < 2 then task.wait(0.5 * (retry + 1)) end
                                        end
                                        if not workerAlive() then break end
                                        if not valid then failed = true; lastFailure = "DOWNLOAD_RECOVERY_PART_FAILED"; break end
                                        pieces[index + 1] = piece
                                        received = received + #piece
                                        completedParts = completedParts + 1
                                    end
                                    workers = workers - 1
                                    if workers == 0 and alive() then
                                        if not failed and not fatalStatus and completedParts == ticket.chunkCount and received == ticket.expectedLength then
                                            local assembled = table.concat(pieces)
                                            if validPayload(assembled, ticket.expectedLength) then completedTicket, completedData = ticket, assembled end
                                        end
                                        recoveryDone = true
                                    end
                                end)
                            end
                        end)
                    end
                    local displayed = -1
                    while alive() do
                        if fatalStatus then return finish(nil, nil, fatalStatus) end
                        if not fullRead and full.done then
                            fullRead = true
                            local data, status = readResponse(full, "DOWNLOAD")
                            if terminal(status) then return finish(nil, nil, status) end
                            if status == 200 and validPayload(data, initialTicket.expectedLength) then
                                return finish(initialTicket, data, 200)
                            end
                            fullFailed = true
                        end
                        if completedTicket then return finish(completedTicket, completedData, 200) end
                        if not recoveryStarted and (fullFailed or os.clock() - started >= 12) then startRecovery() end
                        if fullFailed and recoveryDone then return finish(nil, nil, nil) end
                        local elapsed = math.floor(os.clock() - started)
                        if elapsed ~= displayed then
                            displayed = elapsed
                            setProgress(72, recoveryStarted and string.format("Recovering download - %d/%d parts, %d KB (%ds)",
                                completedParts, totalParts, math.floor(received / 1024), elapsed)
                                or string.format("Downloading Larpkuran - %ds", elapsed))
                        end
                        task.wait(0.1)
                    end
                    requestTimedOut = true
                    lastFailure = transport.generation ~= generation and "DOWNLOAD_REPLACED" or "DOWNLOAD_TOTAL_TIMEOUT_120S"
                    return finish(nil, nil, nil)
                end
                -- DOWNLOAD_RECOVERY_END

                for attempt = 1, 3 do
                    if requestTimedOut then break end
                    requestAttempt = attempt
                    setProgress(50, "Verifying access...")
                    local reqHeaders = {
                        ["X-X8-Session"] = sessionToken,
                        ["X-X8-Device"] = deviceId, ["X-X8-Roblox-User-Id"] = robloxUserId,
                    }
                    local ticket, status = postJson("/v1/auth/request-script", {
                        script = targetScript,
                        format = "base64",
                        chunked = false, -- Recovery retains the full transfer and requests its own independent ticket.
                        role = _isStand and "Stand" or nil,
                        sessionToken = sessionToken,
                        deviceId = deviceId,
                        robloxUserId = robloxUserId,
                    }, reqHeaders)
                    if status == 429 then
                        return nil, nil, "Too many download attempts. Wait 60 seconds before trying again. [AUTH_HTTP_429]"
                    elseif status == 401 then
                        if not refreshSession() then return nil, nil, "LOGIN_REQUIRED" end
                    elseif status == 403 then
                        local code = type(ticket) == "table" and cleanString(ticket.code, 80) or "ACCESS_DENIED"
                        if code == "NOT_REGISTERED" or code == "KEY_REQUIRED" or code == "INVALID_SESSION" or code == "SESSION_REVOKED" then
                            return nil, nil, "LOGIN_REQUIRED"
                        end
                        local message = type(ticket) == "table" and cleanString(ticket.message, 512) or nil
                        return nil, nil, (message or "Your account does not have access to this script.") .. " [" .. code .. "]"
                    elseif status == 200 and validTicket(ticket) then
                        setProgress(72, "Downloading Larpkuran...")
                        local streamHeaders = {
                            ["X-X8-Session"] = sessionToken,
                            ["X-X8-Device"] = deviceId, ["X-X8-Roblox-User-Id"] = robloxUserId,
                            ["Cache-Control"] = "no-cache",
                        }
                        local winningTicket, data, downloadStatus = recoverDownload(ticket, streamHeaders)
                        if downloadStatus == 200 and winningTicket then
                            return winningTicket, data
                        end
                        if downloadStatus == 200 and data ~= nil then
                            local received = type(data) == "string" and #data or 0
                            lastFailure = received ~= ticket.expectedLength
                                and string.format("DOWNLOAD_LENGTH_MISMATCH_%d_OF_%d", received, ticket.expectedLength)
                                or "DOWNLOAD_INVALID_BASE64"
                        elseif type(data) == "string" and #data < 16384 then
                            local decoded, errorData = pcall(HttpService.JSONDecode, HttpService, data)
                            local knownCodes = { INVALID_TICKET = true, INVALID_SESSION = true, ACCESS_DENIED = true,
                                SCRIPT_UPDATED = true, SCRIPT_UNAVAILABLE = true, INVALID_FORMAT = true, RATE_LIMITED = true }
                            if decoded and type(errorData) == "table" and knownCodes[errorData.code] then
                                lastFailure = lastFailure .. "_" .. errorData.code
                            end
                        end
                        if downloadStatus == 429 then
                            return nil, nil, "Too many download attempts. Wait 60 seconds before trying again. [DOWNLOAD_HTTP_429]"
                        end
                        if downloadStatus == 401 and not refreshSession() then
                            return nil, nil, "LOGIN_REQUIRED"
                        end
                    elseif status == 200 then
                        lastFailure = "AUTH_INVALID_TICKET"
                    end
                    if requestTimedOut then break end
                    -- A download attempt always obtains a new ticket and encryption key.
                    if attempt < 3 then task.wait(0.6) end
                end
                return nil, nil, "Unable to download Larpkuran. [" .. lastFailure .. "] Please try again."
            end

            local failureMessage
            authPayload, encData, failureMessage = authAndFetch()
            if not downloadStillCurrent() then closeSplash(); return end
            if not authPayload or not encData then
                closeSplash()
                if failureMessage == "LOGIN_REQUIRED" then
                    local env = type(getgenv) == "function" and getgenv() or _G
                    env.LarpkuranRequestedAuthRole = _isStand and "STAND" or "MAIN"
                    env.LarpkuranForceKeyLogin = true
                    for _, scope in ipairs({env, _G}) do
                        scope.StacyCMDStartupToken, scope.StacyKeyToken = nil, nil
                        scope.StacyCMDStartupKeyVerified, scope.StacyKeyVerified = false, false
                    end
                    local ok, message = pcall(function()
                        local source = game:HttpGet("https://api.x8stuff.lol/scripts/stacyui.lua")
                        local chunk, compileError = loadstring(source, "LarpKuran Key System")
                        if not chunk then error(compileError) end
                        chunk()
                    end)
                    if not ok then reportAndShowError("LarpKuran Key System", tostring(message)) end
                    return
                end
                reportAndShowError(targetScript, failureMessage or "Authentication failed: unable to fetch secure runtime payload.")
                return
            end
        end

        setProgress(88, "Rebuilding internal opcode mappings & tables...")
        task.wait(0.05)

        if not downloadStillCurrent() then closeSplash(); return end
        local _b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
        local _b64lut = buffer.create(256)
        for index = 0, 255 do buffer.writeu8(_b64lut, index, 255) end
        for i = 1, 64 do
            buffer.writeu8(_b64lut, string.byte(_b64chars, i), i - 1)
        end

        local function _decodeB64(data)
            local dlen = #data
            while dlen > 0 and string.byte(data, dlen) == 61 do
                dlen = dlen - 1
            end
            local expectedBinaryLen = math.floor(dlen * 3 / 4)

            local syn_tbl = rawget(_G, "syn")
            local crypt = rawget(_G, "crypt") or (type(syn_tbl) == "table" and rawget(syn_tbl, "crypt"))
            if type(crypt) == "table" and type(rawget(crypt, "base64decode")) == "function" then
                local s, r = pcall(rawget(crypt, "base64decode"), data)
                if s and type(r) == "string" and #r == expectedBinaryLen then
                    return r
                end
            end
            if type(crypt) == "table" and type(rawget(crypt, "base64_decode")) == "function" then
                local s, r = pcall(rawget(crypt, "base64_decode"), data)
                if s and type(r) == "string" and #r == expectedBinaryLen then
                    return r
                end
            end
            local b64dec = rawget(_G, "base64_decode")
            if type(b64dec) == "function" then
                local s, r = pcall(b64dec, data)
                if s and type(r) == "string" and #r == expectedBinaryLen then
                    return r
                end
            end
            local b64tbl = rawget(_G, "base64")
            if type(b64tbl) == "table" and type(rawget(b64tbl, "decode")) == "function" then
                local s, r = pcall(rawget(b64tbl, "decode"), data)
                if s and type(r) == "string" and #r == expectedBinaryLen then
                    return r
                end
            end

            local outBuf = buffer.create(expectedBinaryLen + 4)
            local srcBuf = buffer.fromstring(data)
            local srcLen = buffer.len(srcBuf)
            local outOffset = 0
            local i = 0
            while i < srcLen do
                local c1 = buffer.readu8(srcBuf, i)
                local c2 = (i + 1 < srcLen) and buffer.readu8(srcBuf, i + 1) or 61
                local c3 = (i + 2 < srcLen) and buffer.readu8(srcBuf, i + 2) or 61
                local c4 = (i + 3 < srcLen) and buffer.readu8(srcBuf, i + 3) or 61
                i = i + 4
                if c1 == 61 or c2 == 61 then break end
                local v1 = buffer.readu8(_b64lut, c1)
                local v2 = buffer.readu8(_b64lut, c2)
                local v3 = (c3 ~= 61) and buffer.readu8(_b64lut, c3) or 0
                local v4 = (c4 ~= 61) and buffer.readu8(_b64lut, c4) or 0
                local triple = bit32.bor(bit32.lshift(v1, 18), bit32.lshift(v2, 12), bit32.lshift(v3, 6), v4)
                buffer.writeu8(outBuf, outOffset, bit32.band(bit32.rshift(triple, 16), 255))
                outOffset = outOffset + 1
                if c3 ~= 61 then
                    buffer.writeu8(outBuf, outOffset, bit32.band(bit32.rshift(triple, 8), 255))
                    outOffset = outOffset + 1
                    if c4 ~= 61 then
                        buffer.writeu8(outBuf, outOffset, bit32.band(triple, 255))
                        outOffset = outOffset + 1
                    end
                end
            end
            local resBuf = buffer.create(outOffset)
            buffer.copy(resBuf, 0, outBuf, 0, outOffset)
            return buffer.tostring(resBuf)
        end

        local function _nativeDecryptEngine(enc, key, isB64)
            if isB64 then
                enc = _decodeB64(enc)
            end
            local b = buffer.fromstring(enc)
            local blen = buffer.len(b)
            local kb = buffer.fromstring(key)
            local klen = buffer.len(kb)
            local words = math.floor(blen / 4)
            local kwords = math.floor(klen / 4)
            for i = 0, words - 1 do
                local offset = i * 4
                local koffset = (i % kwords) * 4
                local w = buffer.readu32(b, offset)
                local kw = buffer.readu32(kb, koffset)
                buffer.writeu32(b, offset, bit32.bxor(w, kw))
            end
            for offset = words * 4, blen - 1 do
                local kbyte = buffer.readu8(kb, offset % klen)
                local byte = buffer.readu8(b, offset)
                buffer.writeu8(b, offset, bit32.bxor(byte, kbyte))
            end
            return buffer.tostring(b)
        end

        local isB64 = (authPayload.format == "base64")
        local code = _nativeDecryptEngine(encData, authPayload.sessionKey, isB64)
        if not downloadStillCurrent() then closeSplash(); return end
        encData = nil
        authPayload = nil
        _nativeDecryptEngine = nil

        if type(code) ~= "string" or #code < 500 then
            closeSplash()
            reportAndShowError(targetScript, "Payload transfer integrity failure: corrupted or truncated data.")
            return
        end

        setProgress(96, "Finalizing virtualization & dispatch pipeline...")
        local safeEnvironment, environmentReason = inspectEnvironment()
        if not safeEnvironment then
            closeSplash()
            reportAndShowError("larpkuran.lua", environmentReason)
            return
        end

        local fn = nil
        local err = nil
        local ok1, res1, err1 = pcall(function()
            return loadstring(code, "=larpkuran")
        end)
        if ok1 and type(res1) == "function" then
            fn = res1
        else
            local ok2, res2, err2 = pcall(function()
                return loadstring(code)
            end)
            if ok2 and type(res2) == "function" then
                fn = res2
            else
                err = tostring(res2 or err2 or res1 or err1 or "Syntax or compilation error")
            end
        end
        code = nil

        if not downloadStillCurrent() then closeSplash(); return end
        if type(fn) == "function" then
            setProgress(98, "Starting LarpKuran...")
            local previousGuard = _G.__LarpkuranCriticalGuard
            local previousController = _G.LarpkuranController
            local previousRere = _G.LarpkuranRere
            local previousRereUI = _G.LarpkuranRereUI
            local okExec, execErr = xpcall(fn, function(e)
                local trace = type(debug) == "table" and type(debug.traceback) == "function" and debug.traceback() or ""
                return tostring(e) .. string.char(10) .. trace
            end)
            if not downloadStillCurrent() then closeSplash(); return false end
            if not okExec then
                closeSplash()
                reportAndShowError("larpkuran.lua", "Payload startup error: " .. tostring(execErr))
                return false
            end
            -- Full Prod starts its main runtime asynchronously. Returning from
            -- the dispatch function does not confirm that its UI initialized.
            if targetScript == "larpkuran.lua" then
                local deadline = os.clock() + 45
                local startupReady = false
                local lastStage = "waiting-for-payload-entry"
                local startupError
                while os.clock() < deadline do
                    if not downloadStillCurrent() then closeSplash(); return false end
                    local guard = _G.__LarpkuranCriticalGuard
                    if type(guard) == "table" and guard ~= previousGuard and guard.StartupProtocol == 1 then
                        lastStage = tostring(guard.Stage or "initializing"):sub(1, 160)
                        if guard.Crashed then
                            startupError = tostring(guard.Error or "Runtime initialization failed."):sub(1, 2048)
                            break
                        end
                        if guard.Active == false then
                            startupError = "The runtime stopped during initialization."
                            break
                        end
                        if guard.Ready == true then startupReady = true; break end
                    end
                    -- Compatibility handshake for payloads whose UI is mounted
                    -- before the critical guard flips Ready. This is bounded to
                    -- the current live controller/UI and leaves the real timeout
                    -- error path intact for an actual startup failure.
                    if not startupReady then
                        local liveController = _G.LarpkuranController or _G.LarpkuranRere
                        local hasNewController = type(liveController) == "table"
                            and liveController ~= previousController
                            and liveController ~= previousRere
                            and liveController.Stopped ~= true
                            and (liveController.LarpkuranOpenedState ~= nil
                                or liveController.RereDisconnect ~= nil)
                        local hasNewRereUi = type(_G.LarpkuranRereUI) == "table"
                            and _G.LarpkuranRereUI ~= previousRereUI
                        if hasNewController or hasNewRereUi then
                            lastStage = "controller-ready"
                            startupReady = true
                            break
                        end
                    end
                    setProgress(99, "Initializing LarpKuran UI...")
                    task.wait(0.1)
                end
                if not startupReady then
                    closeSplash()
                    reportAndShowError("larpkuran.lua", "Payload startup was not confirmed. Last stage: "
                        .. lastStage .. string.char(10) .. (startupError or "No complete UI frame was reported within 45 seconds. Reload and send this error to staff."))
                    return false
                end
            end
            setProgress(100, "LarpKuran startup complete.")
            closeSplash()
            return true
        else
            closeSplash()
            reportAndShowError("larpkuran.lua", "Assembly / Compilation Error: " .. tostring(err))
            return false
        end
    end
    local ok, result = xpcall(runLoader, function(err)
        local trace = type(debug) == "table" and type(debug.traceback) == "function" and debug.traceback() or ""
        return "Loader initialization error at " .. loaderStage .. ": " .. tostring(err) .. "\n" .. trace
    end)
    if not ok then
        if loaderCleanup then pcall(loaderCleanup) end
        if loaderErrorHandler then
            loaderErrorHandler("larpkuran.lua", result)
        else
            warn("[LarpKuran loader] " .. tostring(result))
        end
        return false
    end
    return result == true
end
return _initLoader()
