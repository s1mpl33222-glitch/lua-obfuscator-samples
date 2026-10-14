-- Cookie Hub universal loader.
-- One client for every game Cookie Hub supports: it sends the current PlaceId to the
-- worker, which decides whether that place is supported and returns its script.
-- This uses executor HTTP/loadstring APIs. Roblox Studio LocalScripts cannot make
-- arbitrary outbound HTTP requests or execute downloaded source; use a server-side
-- bridge for an experience you own instead.
local CLIENT_VERSION = "roblox-gui/1.8"
local REQUEST_ATTEMPTS = 4

assert(getgenv, "This loader needs getgenv to hand the key to the place script.")
local shared = getgenv()
local previous = shared.CookieHubLoaderState
if type(previous) == "table" and (previous.state == "starting" or previous.state == "waiting_key") then
    return -- A launch already owns initialization, including asynchronous startup.
end
local loaderState = { state = "starting" }
shared.CookieHubLoaderState = loaderState
if type(previous) == "table" and type(previous.retire) == "function" then
    pcall(previous.retire)
end
-- Claim ownership before retiring a stale window: its exit animation can yield.
if type(shared.CookieHubLoaderWindow) == "function" then
    pcall(shared.CookieHubLoaderWindow)
end
local function releaseLoader()
    if shared.CookieHubLoaderState == loaderState then shared.CookieHubLoaderState = nil end
end

-- Catch top-level setup failures as well as the explicit request/payload failures.
local loaderOk, loaderErr = pcall(function()

-- Retry transport exceptions/empty transport responses, with bounded backoff.
-- HTTP error responses are returned normally, so rejected keys are not retried.
local function requestWithRetry(send, valid, onRetry)
    for attempt = 1, REQUEST_ATTEMPTS do
        local ok, response = pcall(send)
        if ok and valid(response) then return response end
        if attempt < REQUEST_ATTEMPTS then
            local delay = 2 ^ (attempt - 1)
            if onRetry then onRetry(attempt + 1, delay) end
            task.wait(delay)
        end
    end
    error("HTTP request failed after 4 attempts. Check your connection and try again.", 0)
end

local function validHttpResponse(response)
    return type(response) == "table" and (tonumber(response.StatusCode or response.Status or response.status_code) or 0) > 0
end

local WORKER_ORIGIN = "https://script-access-worker.script-access-worker.workers.dev"
local PLACE_ID = tostring(game.PlaceId) -- the worker picks the script for this place
local DISCORD_URL = "http://dsc.gg/cookie-hub-rblx"

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local PLAYER_ID = tostring(Players.LocalPlayer.UserId)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local requestFn = request or http_request or (syn and syn.request)
assert(requestFn, "This loader needs an HTTP request API.")
assert(loadstring, "This loader needs loadstring enabled.")
getgenv().CookieHubDebugLog = nil -- discard the previous diagnostic build's buffer

local function installationId()
    -- Keep this stable if your executor exposes a persistent identifier. This sample
    -- intentionally does not claim that Roblox client values are hardware identity.
    return getgenv().ScriptAccessInstallationId or ("roblox-" .. Players.LocalPlayer.UserId)
end

local post
local reportedFailures = {}
local analyticsQueues = {}
local analyticsStopped = {}
local function analyticsAvailable(analytics)
    return type(analytics) == "table" and type(analytics.session_id) == "string" and type(analytics.session_token) == "string" and not analyticsStopped[analytics.session_id]
end
local function reportEvent(analytics, event, text)
    if not analyticsAvailable(analytics) then return end
    local queue = analyticsQueues[analytics.session_id]
    if not queue then
        queue = { events = {}, running = false }
        analyticsQueues[analytics.session_id] = queue
    end
    -- Keep terminal lifecycle events even if a slow connection accumulates
    -- heartbeats. The queue holds at most 32 pending events plus one in flight.
    if #queue.events >= 32 then
        if event == "heartbeat" then return end
        local removeIndex = 1
        for index, pendingEvent in ipairs(queue.events) do
            if pendingEvent.event == "heartbeat" then removeIndex = index; break end
        end
        table.remove(queue.events, removeIndex)
    end
    table.insert(queue.events, { id = HttpService:GenerateGUID(false), event = event, text = text })
    if queue.running then return end
    queue.running = true
    -- One background worker preserves success -> heartbeat -> unload order,
    -- including when a reload happens before the success request completes.
    task.spawn(function()
        while #queue.events > 0 do
            local pendingEvent = table.remove(queue.events, 1)
            local ok, status = pcall(post, "/v1/analytics/events", {
                session_id = analytics.session_id,
                session_token = analytics.session_token,
                events = { pendingEvent },
            })
            -- Expired or revoked telemetry credentials must not send recurring
            -- requests for the rest of an otherwise healthy game session.
            if ok and (status == 401 or status == 403) then
                analyticsStopped[analytics.session_id] = true
                table.clear(queue.events)
                break
            end
        end
        queue.running = false
        analyticsQueues[analytics.session_id] = nil
    end)
end
local function reportLoadFailure(analytics, reason)
    if type(analytics) ~= "table" or type(analytics.session_id) ~= "string" or type(analytics.session_token) ~= "string" then return end
    if reportedFailures[analytics.session_id] then return end
    reportedFailures[analytics.session_id] = true
    reportEvent(analytics, "load_failed", reason)
end

-- Observe asynchronous payload startup without polling or blocking the loader.
-- Keep state in a backing table so every assignment (including ready -> unloaded)
-- reaches the observer, rather than only the first write to a Lua table field.
local function startupTracker(analytics)
    local values = { state = "starting" }
    local observer, failureReported, successReported, unloadReported, retired
    local function retire()
        retired = true
        if successReported and not unloadReported and values.analyticsManaged ~= true then
            unloadReported = true
            reportEvent(analytics, "unload")
        end
    end
    loaderState.retire = retire
    local function heartbeat()
        if retired or values.state ~= "ready" or values.analyticsManaged == true or shared.CookieHubLoaderState ~= loaderState or not analyticsAvailable(analytics) then return end
        reportEvent(analytics, "heartbeat")
        task.delay(60, heartbeat)
    end
    local function changed()
        if values.state == "failed" then
            releaseLoader()
            if not failureReported then
                failureReported = true
                reportLoadFailure(analytics, "initialization_failed")
            end
        elseif values.state == "unloaded" then
            retire()
            releaseLoader()
        elseif values.state == "ready" and shared.CookieHubLoaderState == loaderState then
            loaderState.state = "ready"
            -- New payloads own their telemetry; older places still get CCU and
            -- successful-run counts through this loader lifecycle fallback.
            if not successReported and values.analyticsManaged ~= true and analyticsAvailable(analytics) then
                successReported = true
                reportEvent(analytics, "load_success")
                task.delay(60, heartbeat)
            end
        end
        if observer then observer(values.state, values.reason) end
    end
    local state = setmetatable({}, {
        __index = values,
        __newindex = function(_, key, value)
            values[key] = value
            if key == "state" then changed() end
        end,
    })
    return state, function(callback) observer = callback; changed() end
end

post = function(path, payload, onRetry)
    local encoded = HttpService:JSONEncode(payload)
    local requestId = "loader-" .. HttpService:GenerateGUID(false)
    local response = requestWithRetry(function() return requestFn({
        Url = WORKER_ORIGIN .. path,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json", ["X-Request-ID"] = requestId },
        -- Executors are inconsistent: Synapse-style APIs use Body, while some
        -- request shims only inspect lowercase body. Supplying both is harmless.
        Body = encoded,
        body = encoded,
    }) end, validHttpResponse, onRetry)
    local statusCode = tonumber(response.StatusCode or response.Status or response.status_code) or 0
    local raw = response.Body or response.body or ""
    local decoded, body = pcall(HttpService.JSONDecode, HttpService, raw)
    if not decoded or type(body) ~= "table" then
        return statusCode, { error = "The service returned an unreadable response." }, raw
    end
    return statusCode, body, raw
end

-- Report once when this loader starts, without delaying the GUI or key checks.
task.spawn(function()
    pcall(post, "/v1/client/start", { place_id = PLACE_ID, player_id = PLAYER_ID, client_version = CLIENT_VERSION })
end)

-- ============================================================================
-- Look & feel
-- ============================================================================
-- Ask the server before constructing any key UI. Only the server's current
-- per-place policy can grant keyless access; a local flag cannot unlock a game.
local probeOk, probeCode, probe = pcall(post, "/v1/scripts/load/" .. HttpService:UrlEncode(PLACE_ID), {
    place_id = PLACE_ID,
    player_id = PLAYER_ID,
    client_version = CLIENT_VERSION,
})
if not probeOk then error(tostring(probeCode), 0) end
if probeCode == 404 and probe.reason == "unsupported_place" then
    local function create(class, props)
        local object = Instance.new(class)
        local parent = props.Parent
        for key, value in pairs(props) do
            if key ~= "Parent" then object[key] = value end
        end
        object.Parent = parent
        return object
    end
    local screen = create("ScreenGui", {
        Name = "CookieHubUnsupportedGame", ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = Players.LocalPlayer:WaitForChild("PlayerGui"),
    })
    local card = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, -32, 0, 238), BackgroundColor3 = Color3.fromRGB(22, 24, 36),
        BorderSizePixel = 0, Parent = screen,
    })
    create("UISizeConstraint", { MaxSize = Vector2.new(420, 238), Parent = card })
    create("UICorner", { CornerRadius = UDim.new(0, 16), Parent = card })
    create("TextLabel", {
        Position = UDim2.fromOffset(22, 20), Size = UDim2.new(1, -44, 0, 20),
        BackgroundTransparency = 1, Text = "COOKIE HUB", Font = Enum.Font.GothamBold,
        TextSize = 13, TextColor3 = Color3.fromRGB(240, 160, 60), Parent = card,
    })
    create("TextLabel", {
        Position = UDim2.fromOffset(22, 52), Size = UDim2.new(1, -44, 0, 30),
        BackgroundTransparency = 1, Text = "Unsupported game", Font = Enum.Font.GothamBold,
        TextSize = 22, TextColor3 = Color3.fromRGB(240, 242, 250), Parent = card,
    })
    create("TextLabel", {
        Position = UDim2.fromOffset(22, 92), Size = UDim2.new(1, -44, 0, 76),
        BackgroundTransparency = 1, TextWrapped = true, Font = Enum.Font.Gotham,
        Text = "Cookie Hub has no published script for this game yet.\nPlace ID: " .. PLACE_ID,
        TextSize = 15, TextColor3 = Color3.fromRGB(137, 145, 172), Parent = card,
    })
    local dismiss = create("TextButton", {
        Position = UDim2.fromOffset(22, 182), Size = UDim2.new(1, -44, 0, 36),
        BackgroundColor3 = Color3.fromRGB(240, 160, 60), Text = "Got it",
        Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(38, 24, 6), Parent = card,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = dismiss })
    local function closeNotice()
        screen:Destroy()
        if shared.CookieHubLoaderWindow == closeNotice then shared.CookieHubLoaderWindow = nil end
    end
    shared.CookieHubLoaderWindow = closeNotice
    dismiss.MouseButton1Click:Connect(closeNotice)
    releaseLoader()
    return
end
if probeCode == 200 and probe.authorized == true and probe.keyless == true and type(probe.source) == "string" then
    local compiled, payload, compileErr = pcall(loadstring, probe.source, "=CookieHub/Place/" .. PLACE_ID)
    if not compiled or type(payload) ~= "function" then
        reportLoadFailure(probe.analytics, "compile_failed")
        error("Downloaded script could not compile: " .. tostring(compiled and compileErr or payload), 0)
    end
    local startupState = startupTracker(probe.analytics)
    -- A non-secret label supports existing payloads that require a nonempty Key.
    -- Their /v1/validate recheck still uses the server's actual keyless setting.
    getgenv().ScriptAccess = { Key = "keyless", Keyless = true, Fingerprint = installationId(), PlayerId = PLAYER_ID, BuildChannel = probe.build_channel or "production", StartupState = startupState, Analytics = probe.analytics }
    local ran, runErr = pcall(payload)
    getgenv().ScriptAccess = nil
    if not ran then
        reportLoadFailure(probe.analytics, "runtime_failed")
        error("Script failed: " .. tostring(runErr), 0)
    end
    if startupState.state == "failed" then error(startupState.reason or "Place script stopped during initialization.", 0) end
    return
end
if probeCode ~= 403 or probe.reason ~= "key_required" then
    error(tostring(probe.error or probe.reason or "Script was unavailable."), 0)
end
loaderState.state = "waiting_key"

-- Executor workspace storage, scoped to this Roblox account and place. A saved
-- key still goes through the server's normal verification on every launch.
local KEY_FOLDER = "cookie-hub"
local KEY_FILE = KEY_FOLDER .. "/key-" .. tostring(Players.LocalPlayer.UserId) .. "-" .. PLACE_ID .. ".txt"
local function readSavedKey()
    if type(readfile) ~= "function" then return nil end
    local ok, value = pcall(readfile, KEY_FILE)
    if not ok or type(value) ~= "string" then return nil end
    local key = value:match("^%s*(.-)%s*$")
    return key ~= "" and key or nil
end

local savedKey = readSavedKey()

local function saveKey(key)
    if type(writefile) ~= "function" then return false end
    -- Existing folders may make makefolder throw; the write determines success.
    if type(makefolder) == "function" then pcall(makefolder, KEY_FOLDER) end
    local ok = pcall(writefile, KEY_FILE, key)
    if ok then savedKey = key end
    return ok
end

local function clearSavedKey(key)
    if key ~= savedKey then return end
    savedKey = nil
    if type(delfile) == "function" and pcall(delfile, KEY_FILE) then return end
    -- Some executors expose writefile without delfile. An empty file is ignored.
    if type(writefile) == "function" then pcall(writefile, KEY_FILE, "") end
end

local InvalidKeyReasons = {
    key_not_found = true,
    key_revoked = true,
    key_expired = true,
    fingerprint_mismatch = true,
    fingerprint_already_claimed = true,
}

local Theme = {
    Card = Color3.fromRGB(22, 24, 36),
    CardDark = Color3.fromRGB(15, 16, 25),
    Field = Color3.fromRGB(12, 14, 22),
    Button = Color3.fromRGB(31, 35, 52),
    ButtonHover = Color3.fromRGB(42, 47, 69),
    Stroke = Color3.fromRGB(52, 57, 80),
    Accent = Color3.fromRGB(240, 160, 60),
    AccentHover = Color3.fromRGB(252, 182, 96),
    AccentText = Color3.fromRGB(38, 24, 6),
    Text = Color3.fromRGB(240, 242, 250),
    Muted = Color3.fromRGB(137, 145, 172),
    Success = Color3.fromRGB(74, 222, 128),
    Error = Color3.fromRGB(248, 113, 113),
}

local function create(class, props, children)
    local object = Instance.new(class)
    local parent
    for key, value in pairs(props) do
        if key == "Parent" then
            parent = value
        else
            object[key] = value
        end
    end
    for _, child in ipairs(children or {}) do
        child.Parent = object
    end
    object.Parent = parent
    return object
end

local function corner(radius)
    return create("UICorner", { CornerRadius = UDim.new(0, radius) })
end

local function stroke(color, transparency)
    return create("UIStroke", {
        Color = color,
        Thickness = 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
end

local function tween(object, seconds, goal)
    TweenService:Create(object, TweenInfo.new(seconds, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal):Play()
end

local busy = false -- true while a verification is in flight

local function hoverable(button, normal, hover, enabled)
    button.MouseEnter:Connect(function()
        if not enabled or enabled() then tween(button, 0.12, { BackgroundColor3 = hover }) end
    end)
    button.MouseLeave:Connect(function()
        if not enabled or enabled() then tween(button, 0.12, { BackgroundColor3 = normal }) end
    end)
end

-- ============================================================================
-- Window
-- ============================================================================
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local screen = create("ScreenGui", {
    Name = "ScriptAccess",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = playerGui,
})

local scale = create("UIScale", { Scale = 0.94 })

local card = create("CanvasGroup", {
    Name = "Card",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(420, 326),
    BackgroundColor3 = Theme.Card,
    GroupTransparency = 1,
    Parent = screen,
}, {
    corner(16),
    stroke(Theme.Stroke, 0.25),
    scale,
})

-- Background gradient lives on its own frame: a UIGradient placed directly on the
-- CanvasGroup would multiply the colour of every child (text, buttons, icons) too.
create("Frame", {
    Name = "Background",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel = 0,
    ZIndex = 0,
    Parent = card,
}, {
    create("UIGradient", {
        Rotation = 90,
        Color = ColorSequence.new(Theme.Card, Theme.CardDark),
    }),
})

-- Header (also the drag handle)
local header = create("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 78),
    BackgroundTransparency = 1,
    Active = true,
    Parent = card,
})

create("Frame", {
    Name = "Badge",
    Position = UDim2.fromOffset(20, 17),
    Size = UDim2.fromOffset(46, 46),
    BackgroundColor3 = Theme.Accent,
    BackgroundTransparency = 0.82,
    Parent = header,
}, {
    corner(12),
    stroke(Theme.Accent, 0.6),
    create("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "🍪",
        TextSize = 26,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.Text,
    }),
})

create("TextLabel", {
    Position = UDim2.fromOffset(78, 17),
    Size = UDim2.new(1, -130, 0, 26),
    BackgroundTransparency = 1,
    Text = "Cookie Hub",
    TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 21,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = header,
})

local subtitle = create("TextLabel", {
    Position = UDim2.fromOffset(78, 43),
    Size = UDim2.new(1, -130, 0, 18),
    BackgroundTransparency = 1,
    Text = "Place " .. PLACE_ID,
    TextColor3 = Theme.Muted,
    Font = Enum.Font.Gotham,
    TextSize = 13,
    TextTruncate = Enum.TextTruncate.AtEnd,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = header,
})

-- Show the name of the game we are in (falls back to the place id if the lookup fails)
task.spawn(function()
    local ok, info = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    end)
    if ok and type(info) == "table" and type(info.Name) == "string" and info.Name ~= "" and subtitle.Parent then
        subtitle.Text = info.Name
    end
end)

local closeButton = create("TextButton", {
    Name = "Close",
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -16, 0, 20),
    Size = UDim2.fromOffset(28, 28),
    BackgroundColor3 = Theme.Button,
    BackgroundTransparency = 1,
    AutoButtonColor = false,
    Text = "X",
    TextColor3 = Theme.Muted,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    Parent = header,
}, { corner(8) })

closeButton.MouseEnter:Connect(function()
    tween(closeButton, 0.12, { BackgroundTransparency = 0, TextColor3 = Theme.Error })
end)
closeButton.MouseLeave:Connect(function()
    tween(closeButton, 0.12, { BackgroundTransparency = 1, TextColor3 = Theme.Muted })
end)

create("Frame", {
    Position = UDim2.fromOffset(20, 78),
    Size = UDim2.new(1, -40, 0, 1),
    BackgroundColor3 = Theme.Stroke,
    BackgroundTransparency = 0.4,
    BorderSizePixel = 0,
    Parent = card,
})

-- Key field
create("TextLabel", {
    Position = UDim2.fromOffset(22, 96),
    Size = UDim2.new(1, -44, 0, 14),
    BackgroundTransparency = 1,
    Text = "ACCESS KEY",
    TextColor3 = Theme.Muted,
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = card,
})

local keyStroke = stroke(Theme.Stroke, 0.2)
local keyBox = create("TextBox", {
    Name = "Key",
    Position = UDim2.fromOffset(20, 116),
    Size = UDim2.new(1, -40, 0, 44),
    BackgroundColor3 = Theme.Field,
    PlaceholderText = "Paste your access key",
    PlaceholderColor3 = Color3.fromRGB(92, 100, 128),
    Text = savedKey or "",
    TextColor3 = Theme.Text,
    Font = Enum.Font.GothamMedium,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
    Parent = card,
}, {
    corner(10),
    keyStroke,
    create("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }),
})

keyBox.Focused:Connect(function()
    tween(keyStroke, 0.15, { Color = Theme.Accent })
end)

-- Buttons
local function makeButton(text, position, size, background, textColor)
    return create("TextButton", {
        Position = position,
        Size = size,
        BackgroundColor3 = background,
        AutoButtonColor = false,
        Text = text,
        TextColor3 = textColor,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Parent = card,
    }, { corner(10) })
end

local getKey = makeButton("Get key", UDim2.fromOffset(20, 174), UDim2.fromOffset(122, 44), Theme.Button, Theme.Text)
create("UIStroke", { Color = Theme.Stroke, Thickness = 1, Transparency = 0.25, Parent = getKey })
hoverable(getKey, Theme.Button, Theme.ButtonHover)

local verify = makeButton("Verify & load", UDim2.fromOffset(154, 174), UDim2.new(1, -174, 0, 44), Theme.Accent, Theme.AccentText)
hoverable(verify, Theme.Accent, Theme.AccentHover, function() return not busy end)

-- Status line
local statusDot = create("Frame", {
    Position = UDim2.fromOffset(22, 245),
    Size = UDim2.fromOffset(8, 8),
    BackgroundColor3 = Theme.Muted,
    BorderSizePixel = 0,
    Parent = card,
}, { corner(4) })

local statusLabel = create("TextLabel", {
    Position = UDim2.fromOffset(38, 234),
    Size = UDim2.new(1, -60, 0, 32),
    BackgroundTransparency = 1,
    Text = "Enter your key to continue.",
    TextColor3 = Theme.Muted,
    Font = Enum.Font.Gotham,
    TextSize = 13,
    TextWrapped = true,
    TextTruncate = Enum.TextTruncate.AtEnd,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    Parent = card,
})

local StatusColors = {
    info = Theme.Muted,
    working = Theme.Accent,
    ok = Theme.Success,
    error = Theme.Error,
}

local function setStatus(text, kind)
    local color = StatusColors[kind or "info"]
    statusLabel.Text = text
    statusLabel.TextColor3 = (kind == "info" or kind == nil) and Theme.Muted or color
    tween(statusDot, 0.15, { BackgroundColor3 = color })
end

-- Footer: Discord invite (click to copy)
create("Frame", {
    Position = UDim2.fromOffset(20, 276),
    Size = UDim2.new(1, -40, 0, 1),
    BackgroundColor3 = Theme.Stroke,
    BackgroundTransparency = 0.4,
    BorderSizePixel = 0,
    Parent = card,
})

local discordButton = create("TextButton", {
    Name = "Discord",
    Position = UDim2.fromOffset(20, 284),
    Size = UDim2.new(1, -40, 0, 30),
    BackgroundColor3 = Theme.Button,
    BackgroundTransparency = 1,
    AutoButtonColor = false,
    Text = "💬  Join our Discord  ·  dsc.gg/cookie-hub-rblx",
    TextColor3 = Theme.Muted,
    Font = Enum.Font.GothamMedium,
    TextSize = 12,
    Parent = card,
}, { corner(8) })

discordButton.MouseEnter:Connect(function()
    tween(discordButton, 0.12, { BackgroundTransparency = 0, TextColor3 = Theme.Text })
end)
discordButton.MouseLeave:Connect(function()
    tween(discordButton, 0.12, { BackgroundTransparency = 1, TextColor3 = Theme.Muted })
end)

-- ============================================================================
-- Behaviour
-- ============================================================================
local connections = {}

local function closeWindow(preserveStartup)
    if not preserveStartup then
        loaderState.cancelled = true
        releaseLoader()
    end
    if shared.CookieHubLoaderWindow == closeWindow then shared.CookieHubLoaderWindow = nil end
    if not screen.Parent then return end
    for _, connection in ipairs(connections) do
        connection:Disconnect()
    end
    table.clear(connections)
    tween(card, 0.18, { GroupTransparency = 1 })
    tween(scale, 0.18, { Scale = 0.94 })
    task.wait(0.2)
    screen:Destroy()
end

shared.CookieHubLoaderWindow = closeWindow
closeButton.MouseButton1Click:Connect(function() closeWindow() end)

-- Drag the card by its header (mouse and touch)
do
    local dragging, dragStart, startPosition = false, nil, nil

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = card.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    table.insert(connections, UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            card.Position = UDim2.new(
                startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end
    end))
end

discordButton.MouseButton1Click:Connect(function()
    if setclipboard and pcall(setclipboard, DISCORD_URL) then
        setStatus("Discord invite copied. Paste it into your browser to join.", "ok")
    else
        setStatus("Clipboard unavailable. Join here: " .. DISCORD_URL, "info")
    end
end)

getKey.MouseButton1Click:Connect(function()
    local target = WORKER_ORIGIN .. "/games/" .. HttpService:UrlEncode(PLACE_ID)
    if setclipboard and pcall(setclipboard, target) then
        setStatus("Key link copied. Open it in your browser to get your key.", "ok")
    else
        setStatus("Clipboard unavailable. Open this link: " .. target, "info")
    end
end)

local function setBusy(state)
    busy = state
    if not state then releaseLoader() end
    verify.Text = state and "Checking…" or "Verify & load"
    tween(verify, 0.12, { BackgroundColor3 = state and Theme.ButtonHover or Theme.Accent })
    verify.TextColor3 = state and Theme.Muted or Theme.AccentText
end

local function verifyAndLoad()
    if busy or not screen.Parent then return end
    local active = shared.CookieHubLoaderState
    if active and active ~= loaderState and (active.state == "starting" or active.state == "waiting_key") then return end

    local key = keyBox.Text:match("^%s*(.-)%s*$")
    if key == "" then
        setStatus("Enter your access key first.", "error")
        return
    end

    shared.CookieHubLoaderState = loaderState
    loaderState.state = "starting"
    loaderState.cancelled = false
    setBusy(true)
    setStatus("Checking key…", "working")

    local ok, code, tokenResult = pcall(post, "/v1/token", {
        key = key,
        fingerprint = installationId(),
        place_id = PLACE_ID,
        player_id = PLAYER_ID,
        client_version = CLIENT_VERSION,
    }, function(attempt)
        setStatus("Connection interrupted. Retrying verification (" .. attempt .. "/4)…", "working")
    end)
    if loaderState.cancelled or not screen.Parent then return end
    if not ok or type(tokenResult) ~= "table" or code ~= 200 or not tokenResult.authorized or type(tokenResult.token) ~= "string" then
        if ok and code == 403 and type(tokenResult) == "table" and InvalidKeyReasons[tokenResult.reason] then
            clearSavedKey(key)
            if keyBox.Text:match("^%s*(.-)%s*$") == key then keyBox.Text = "" end
        end
        local reason = type(tokenResult) == "table" and (tokenResult.error or tokenResult.reason) or nil
        setStatus(tostring(reason or (ok and "Key was not accepted.") or code), "error")
        setBusy(false)
        return
    end

    -- Save only after acceptance, even if the subsequent script download fails.
    local saved = saveKey(key)
    setStatus(saved and "Key accepted. Downloading script…" or "Key accepted. Saving unavailable; downloading…", "working")

    -- Send the short-lived token in JSON: this executor drops Body when Authorization is set.
    local loadedRequest, loadCode, result = pcall(post, "/v1/scripts/load/" .. HttpService:UrlEncode(PLACE_ID), { token = tokenResult.token, player_id = PLAYER_ID, client_version = CLIENT_VERSION }, function(attempt)
        setStatus("Connection interrupted. Retrying script download (" .. attempt .. "/4)…", "working")
    end)
    if loaderState.cancelled or not screen.Parent then return end
    if not loadedRequest or type(result) ~= "table" or loadCode ~= 200 or not result.authorized or type(result.source) ~= "string" then
        local reason = loadedRequest and type(result) == "table" and (result.error or result.reason or "Script was unavailable.") or tostring(loadCode)
        setStatus(tostring(reason), "error")
        setBusy(false)
        return
    end

    local compiled, payload, compileErr = pcall(loadstring, result.source, "=CookieHub/Place/" .. PLACE_ID)
    if not compiled or type(payload) ~= "function" then
        reportLoadFailure(result.analytics, "compile_failed")
        setStatus("Downloaded script could not compile: " .. tostring(compiled and compileErr or payload), "error")
        setBusy(false)
        return
    end

    setStatus("Verified. Loading Cookie Hub…", "ok")

    -- One-time handoff: the payload reads and clears this immediately, then
    -- re-validates the key itself. We clear it again afterwards in case it never ran.
    local startupState, observeStartup = startupTracker(result.analytics)
    getgenv().ScriptAccess = { Key = key, Fingerprint = installationId(), PlayerId = PLAYER_ID, BuildChannel = result.build_channel or "production", StartupState = startupState, Analytics = result.analytics }
    local ran, runErr = pcall(payload)
    getgenv().ScriptAccess = nil

    if not ran then
        reportLoadFailure(result.analytics, "runtime_failed")
        setStatus("Script failed: " .. tostring(runErr), "error")
        setBusy(false)
        return
    end

    observeStartup(function(state, reason)
        if loaderState.cancelled or not screen.Parent then return end
        if state == "failed" or state == "unloaded" then
            setStatus(reason or "Place script stopped during initialization.", "error")
            setBusy(false)
        elseif state == "ready" then
            closeWindow(true)
        end
    end)
end

local function tryVerifyAndLoad()
    local ok, failure = pcall(verifyAndLoad)
    if not ok then
        shared.ScriptAccess = nil
        releaseLoader()
        if screen.Parent then
            setStatus("Loader failed: " .. tostring(failure), "error")
            setBusy(false)
        end
    end
end

verify.MouseButton1Click:Connect(tryVerifyAndLoad)
keyBox.FocusLost:Connect(function(enterPressed)
    tween(keyStroke, 0.15, { Color = Theme.Stroke })
    if enterPressed then
        tryVerifyAndLoad()
    end
end)

-- Intro animation
tween(card, 0.25, { GroupTransparency = 0 })
tween(scale, 0.25, { Scale = 1 })

if savedKey then
    setStatus("Checking saved key…", "working")
    task.spawn(tryVerifyAndLoad)
elseif type(readfile) ~= "function" or type(writefile) ~= "function" then
    setStatus("Enter your key. This executor cannot save keys between sessions.", "info")
end
end)
if not loaderOk then
    releaseLoader()
    shared.ScriptAccess = nil
    error(loaderErr, 0)
end
