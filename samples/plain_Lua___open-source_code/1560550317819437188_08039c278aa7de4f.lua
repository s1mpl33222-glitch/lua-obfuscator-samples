local PANDA_CONFIG = {
    origin = "https://vault.pandauth.com",
    publicId = "08039c278aa7de4f",
    preset = "smokedglass",
    displayName = "Suiryu Farm",
    description = nil,
    logoUrl = nil,
    supportUrl = nil,
    getKeyUrl = "https://ads.pandauth.com/getkey/pypublicfarm",
    accent = Color3.fromRGB(139, 92, 246),
    sessionSeconds = 600,
    heartbeatSeconds = 30,
    heartbeatRetries = 5,
}
--[[
    The Panda-managed KVS runtime.

    PANDA OWNS EVERYTHING IN THIS FILE. A developer supplies branding values,
    which arrive in the PANDA table below already escaped, and nothing else. They
    do not supply code, they do not supply the HTTP calls, and they do not supply
    the decision about whether a key is good: that decision is made on a server
    they do not control, and this file only shows the answer.

    This is also NOT the security boundary. Everything here runs on a player's
    machine and can be read, patched or replaced. It exists to make the flow work
    and to make an attack inconvenient. What makes an attack fail is that the
    server will not issue a delivery permit without a live nonce and a key it
    just checked with PandaAuth.
]]

local PANDA = PANDA_CONFIG

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Executors expose a POST-capable request under several names and none of them
-- are guaranteed. Found once here so the rest of the file can assume it, and so
-- a missing one becomes a readable message rather than a nil call later.
local httpRequest =
    (syn and syn.request)
    or (http and http.request)
    or request
    or http_request
    or (fluxus and fluxus.request)

local function fail(message)
    error("[Panda] " .. message, 0)
end

if not httpRequest then
    fail("Your executor does not support HTTP POST, which this script requires.")
end

-- The wire protocol this runtime speaks. Revision 2 understands structured
-- refusals: a JSON body whose "action" says continue, kick, stop or retry, and
-- "retryAfter" says when. The server keeps answering a client that does not
-- send this header exactly the way it always has.
local PROTOCOL = "2"

-- A delivery refusal the same permit may be fetched again after: storage was
-- briefly unreachable, or the download is still in flight elsewhere. It is a
-- Lua comment on the body's first line, the only channel a GET has.
local RETRY_MARKER = "--[[panda:retry]]"

local function nowMs()
    local ok, value = pcall(function() return DateTime.now().UnixTimestampMillis end)
    if ok and type(value) == "number" then
        return value
    end
    return tick() * 1000
end

-- Returns the decoded body and the HTTP status. A transport failure, or a body
-- that is not a JSON object, returns nil and a message: the caller treats that
-- as "Panda could not be reached" and decides whether to try again.
local function post(path, body)
    local ok, response = pcall(httpRequest, {
        Url = PANDA.origin .. path,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["X-Panda-Kvs-Protocol"] = PROTOCOL,
        },
        Body = HttpService:JSONEncode(body),
    })

    if not ok or not response or not response.Body then
        return nil, "Panda could not be reached. Check your internet connection."
    end

    local decoded
    ok, decoded = pcall(function() return HttpService:JSONDecode(response.Body) end)

    if not ok or type(decoded) ~= "table" then
        return nil, "Panda returned an unexpected response."
    end

    return decoded, tonumber(response.StatusCode)
end

-- A wait of roughly `seconds`, spread by up to `spread` so that clients that
-- started together (a server restart, a popular release) do not stay in step.
local function jittered(seconds, spread)
    return seconds + (math.random() * 2 - 1) * (spread or 0)
end

-- The device identifier. Executors disagree on the name, and one that offers
-- none at all cannot be used with a HWID-locked key, which the server will say.
local function hardwareId()
    local getters = {
        function() return game:GetService("RbxAnalyticsService"):GetClientId() end,
        function() return gethwid() end,
        function() return syn.crypt.hash(game:GetService("RbxAnalyticsService"):GetClientId()) end,
    }

    for _, getter in ipairs(getters) do
        local ok, value = pcall(getter)
        if ok and type(value) == "string" and #value > 0 then
            return value
        end
    end

    return ""
end

-- ── what the client can say about itself ─────────────────────────────────────
--
-- Three facts an owner sees in their Discord key log, when they turned one on.
-- ALL THREE ARE CLAIMS. They are read on the player's machine, they travel with
-- the key attempt, and the server treats them as text to print and never as an
-- input to a decision. Nothing here can refuse or allow anyone.

local function playerName()
    local ok, name = pcall(function() return Players.LocalPlayer.Name end)

    return (ok and type(name) == "string") and name or ""
end

-- identifyexecutor is the near-universal name; the others are what older or
-- smaller executors shipped. A missing one is reported as unknown by the server.
local function executorName()
    local getters = { identifyexecutor, getexecutorname }

    for _, getter in ipairs(getters) do
        if type(getter) == "function" then
            local ok, value = pcall(getter)
            if ok and type(value) == "string" and #value > 0 then
                return value
            end
        end
    end

    return ""
end

-- The place name costs a web call, so it is fetched once in the background while
-- the player is still reading the prompt, and the place id stands in until it
-- lands. A key attempt never waits for it.
local placeName = ""

task.spawn(function()
    local ok, info = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    end)

    if ok and type(info) == "table" and type(info.Name) == "string" then
        placeName = info.Name
    end
end)

local function gameName()
    if placeName ~= "" then
        return placeName
    end

    return "Place " .. tostring(game.PlaceId)
end

-- ── the interface ────────────────────────────────────────────────────────────
--
-- Every builder returns the same handle: { screen, field, submit, status }. The
-- flow below drives those four and knows nothing about which layout produced
-- them, so a new preset is a new builder plus a line in buildGui and nothing
-- else. field is the key box, submit is the primary button the flow relabels
-- while it checks, status is the line it writes the result to, screen is what it
-- destroys when it is done.

-- The service's get-key page carrying this machine's HWID, so the key the player
-- earns is one this device can use. The support link stands in only when the
-- script has no service to link to.
local function keyLink()
    if PANDA.getKeyUrl then
        local hwid = hardwareId()
        if hwid == "" then
            return PANDA.getKeyUrl
        end
        -- Raw when already URL-safe, as the V2 loaders send it. UrlEncode would
        -- turn every dash of a GUID into %2D.
        if not hwid:match("^[%w%-%._~]+$") then
            local ok, encoded = pcall(function() return HttpService:UrlEncode(hwid) end)
            hwid = ok and encoded or hwid
        end
        return PANDA.getKeyUrl .. "?hwid=" .. hwid
    end
    return PANDA.supportUrl
end

-- Copies a link to the clipboard, or shows it when the executor has no clipboard.
local function copyKeyLink(setStatus, accent, bad)
    local link = keyLink()
    if not link or link == "" then
        setStatus("No key page is configured for this script.", bad)
        return
    end
    local ok = pcall(function() setclipboard(link) end)
    setStatus(ok and "Key link copied to your clipboard." or link, accent)
end

-- Drag the whole card from anywhere on it, clamped so it can never be dragged
-- out of reach (the field and button are the only way forward).
local function makeDraggable(screen, card)
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragStart, dragOrigin = false, nil, nil
    card.Active = true
    card.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            dragOrigin = card.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            card.Position = UDim2.new(
                dragOrigin.X.Scale, dragOrigin.X.Offset + delta.X,
                dragOrigin.Y.Scale, dragOrigin.Y.Offset + delta.Y)
        end
    end)
end

local function buildStandard(session)
    local parent = (gethui and gethui())
        or game:GetService("CoreGui")

    local screen = Instance.new("ScreenGui")
    screen.Name = "PandaKvs_" .. tostring(math.random(100000, 999999))
    screen.ResetOnSpawn = false
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.Parent = parent

    local compact = PANDA.preset == "compact"
    local minimal = PANDA.preset == "minimal"

    -- Height follows the content: logo, description, Get Key and support link
    -- are each optional, and a fixed height clipped the bottom row.
    local card = Instance.new("Frame")
    card.Size = UDim2.fromOffset(compact and 300 or 360, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    card.BorderSizePixel = 0
    card.Parent = screen

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = PANDA.accent
    stroke.Transparency = 0.7
    stroke.Parent = card

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = card

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 18)
    padding.PaddingBottom = UDim.new(0, 18)
    padding.PaddingLeft = UDim.new(0, 18)
    padding.PaddingRight = UDim.new(0, 18)
    padding.Parent = card

    local order = 0
    local function nextOrder()
        order = order + 1
        return order
    end

    if PANDA.logoUrl and not minimal then
        local logo = Instance.new("ImageLabel")
        logo.Size = UDim2.fromOffset(44, 44)
        logo.BackgroundTransparency = 1
        logo.Image = PANDA.logoUrl
        logo.LayoutOrder = nextOrder()
        logo.Parent = card
    end

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 24)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 17
    title.TextColor3 = Color3.fromRGB(245, 245, 250)
    title.Text = PANDA.displayName
    title.LayoutOrder = nextOrder()
    title.Parent = card

    if PANDA.description and not minimal then
        local subtitle = Instance.new("TextLabel")
        subtitle.Size = UDim2.new(1, 0, 0, 30)
        subtitle.BackgroundTransparency = 1
        subtitle.Font = Enum.Font.Gotham
        subtitle.TextSize = 12
        subtitle.TextWrapped = true
        subtitle.TextColor3 = Color3.fromRGB(150, 150, 160)
        subtitle.Text = PANDA.description
        subtitle.LayoutOrder = nextOrder()
        subtitle.Parent = card
    end

    local field = Instance.new("TextBox")
    field.Size = UDim2.new(1, 0, 0, 36)
    field.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    field.BorderSizePixel = 0
    field.Font = Enum.Font.Code
    field.TextSize = 13
    field.TextColor3 = Color3.fromRGB(235, 235, 240)
    field.PlaceholderText = "Enter your key"
    field.Text = ""
    field.ClearTextOnFocus = false
    field.LayoutOrder = nextOrder()
    field.Parent = card

    local fieldCorner = Instance.new("UICorner")
    fieldCorner.CornerRadius = UDim.new(0, 8)
    fieldCorner.Parent = field

    local submit = Instance.new("TextButton")
    submit.Size = UDim2.new(1, 0, 0, 34)
    submit.BackgroundColor3 = PANDA.accent
    submit.BorderSizePixel = 0
    submit.Font = Enum.Font.GothamBold
    submit.TextSize = 13
    submit.TextColor3 = Color3.fromRGB(12, 12, 15)
    submit.Text = "Continue"
    submit.LayoutOrder = nextOrder()
    submit.Parent = card

    local submitCorner = Instance.new("UICorner")
    submitCorner.CornerRadius = UDim.new(0, 8)
    submitCorner.Parent = submit

    local getKey
    if PANDA.getKeyUrl or PANDA.supportUrl then
        getKey = Instance.new("TextButton")
        getKey.Size = UDim2.new(1, 0, 0, 34)
        getKey.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
        getKey.BorderSizePixel = 0
        getKey.Font = Enum.Font.GothamBold
        getKey.TextSize = 13
        getKey.TextColor3 = Color3.fromRGB(235, 235, 240)
        getKey.Text = "Get Key"
        getKey.LayoutOrder = nextOrder()
        getKey.Parent = card

        local getKeyCorner = Instance.new("UICorner")
        getKeyCorner.CornerRadius = UDim.new(0, 8)
        getKeyCorner.Parent = getKey

        local getKeyStroke = Instance.new("UIStroke")
        getKeyStroke.Color = PANDA.accent
        getKeyStroke.Transparency = 0.6
        getKeyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        getKeyStroke.Parent = getKey
    end

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 30)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.Gotham
    status.TextSize = 11
    status.TextWrapped = true
    status.TextColor3 = Color3.fromRGB(150, 150, 160)
    status.Text = ""
    status.LayoutOrder = nextOrder()
    status.Parent = card

    if getKey then
        getKey.MouseButton1Click:Connect(function()
            copyKeyLink(function(text, colour)
                status.Text = text
                status.TextColor3 = colour
            end, Color3.fromRGB(140, 220, 160), Color3.fromRGB(235, 120, 120))
        end)
    end

    -- Only alongside a real key page; with no service, Get Key already copies it.
    if PANDA.supportUrl and PANDA.getKeyUrl then
        local support = Instance.new("TextButton")
        support.Size = UDim2.new(1, 0, 0, 16)
        support.BackgroundTransparency = 1
        support.Font = Enum.Font.Gotham
        support.TextSize = 11
        support.TextColor3 = Color3.fromRGB(120, 120, 132)
        support.Text = "Need help? Click to copy the support link"
        support.LayoutOrder = nextOrder()
        support.Parent = card

        support.MouseButton1Click:Connect(function()
            local ok = pcall(function() setclipboard(PANDA.supportUrl) end)
            support.Text = ok and "Support link copied" or PANDA.supportUrl
        end)
    end

    return {
        screen = screen,
        card = card,
        field = field,
        submit = submit,
        status = status,
        stroke = stroke,
    }
end

-- A short rotating line, shared by the ported layouts. Cosmetic only.
local QUOTES = {
    "Read the code you paste.",
    "The server always wins.",
    "Nothing client-side is safe.",
    "Keys are cheap, trust is not.",
    "Patience beats brute force.",
    "One key, one machine, one story.",
}
local function pickQuote()
    return QUOTES[Random.new():NextInteger(1, #QUOTES)]
end

-- Glacier: the dashboard's own light look as a Roblox window. An ice-white
-- two-column panel, square corners, hairline rime borders, mono uppercase
-- captions. Identity and facts on the left, everything the player acts on down
-- the right. Ported from the ArcticAuth "Glacier" GUI onto Panda's key flow:
-- the HWID comes from hardwareId(), the key link from keyLink(), and the
-- check is the shared flow's own validation, not an injected SDK.
local function buildGlacier(session)
    local parent = (gethui and gethui()) or game:GetService("CoreGui")

    local accent = PANDA.accent
    local paper = Color3.fromRGB(247, 250, 251)
    local ice = Color3.fromRGB(237, 242, 245)
    local rime = Color3.fromRGB(201, 214, 223)
    local ink = Color3.fromRGB(7, 22, 32)
    local mute = Color3.fromRGB(78, 102, 117)
    local dim = Color3.fromRGB(122, 143, 155)
    local bad = Color3.fromRGB(176, 35, 72)

    local hwid = hardwareId()
    local hwidShown = hwid == "" and "UNAVAILABLE"
        or (#hwid > 22 and (hwid:sub(1, 22) .. "...") or hwid)
    local today = string.upper(os.date("%d %b %Y"))

    local screen = Instance.new("ScreenGui")
    screen.Name = "PandaKvs_" .. tostring(math.random(100000, 999999))
    screen.IgnoreGuiInset = true
    screen.ResetOnSpawn = false
    screen.DisplayOrder = 1000
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.Parent = parent

    local shade = Instance.new("Frame")
    shade.Size = UDim2.fromScale(1, 1)
    shade.BackgroundColor3 = Color3.fromRGB(4, 16, 26)
    shade.BackgroundTransparency = 0.45
    shade.BorderSizePixel = 0
    shade.Parent = screen

    local card = Instance.new("Frame")
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.Size = UDim2.fromOffset(640, 300)
    card.BackgroundColor3 = paper
    card.BorderSizePixel = 0
    card.Parent = screen
    local cardStroke = Instance.new("UIStroke", card)
    cardStroke.Color = rime
    cardStroke.Thickness = 1
    makeDraggable(screen, card)

    local function label(parentFrame, text, size, colour, font, order)
        local l = Instance.new("TextLabel")
        l.BackgroundTransparency = 1
        l.Size = UDim2.new(1, 0, 0, size + 4)
        l.AutomaticSize = Enum.AutomaticSize.Y
        l.Font = font
        l.TextSize = size
        l.TextColor3 = colour
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextYAlignment = Enum.TextYAlignment.Top
        l.TextWrapped = true
        l.Text = text
        l.LayoutOrder = order
        l.Parent = parentFrame
        return l
    end

    -- right column, built first so the status line exists for the HWID row
    local right = Instance.new("Frame")
    right.BackgroundTransparency = 1
    right.Position = UDim2.new(0, 253, 0, 0)
    right.Size = UDim2.new(1, -253, 1, 0)
    right.Parent = card
    local rightPad = Instance.new("UIPadding", right)
    rightPad.PaddingTop = UDim.new(0, 22)
    rightPad.PaddingLeft = UDim.new(0, 22)
    rightPad.PaddingRight = UDim.new(0, 26)
    local rightList = Instance.new("UIListLayout", right)
    rightList.Padding = UDim.new(0, 10)
    rightList.SortOrder = Enum.SortOrder.LayoutOrder

    local status = Instance.new("TextLabel")
    status.BackgroundTransparency = 1
    status.Size = UDim2.new(1, 0, 0, 15)
    status.AutomaticSize = Enum.AutomaticSize.Y
    status.Font = Enum.Font.Gotham
    status.TextSize = 12
    status.TextColor3 = accent
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.TextWrapped = true
    status.Text = ""
    status.LayoutOrder = 20
    status.Parent = right

    local function setStatusLocal(text, colour)
        status.Text = text
        status.TextColor3 = colour or accent
    end

    -- left column
    local left = Instance.new("Frame")
    left.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    left.BorderSizePixel = 0
    left.Size = UDim2.new(0, 252, 1, 0)
    left.Parent = card
    local leftWash = Instance.new("UIGradient", left)
    leftWash.Rotation = 90
    leftWash.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, ice),
        ColorSequenceKeypoint.new(0.55, ice),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 236, 231)),
    })

    local rule = Instance.new("Frame")
    rule.BackgroundColor3 = rime
    rule.BorderSizePixel = 0
    rule.Position = UDim2.new(0, 252, 0, 0)
    rule.Size = UDim2.new(0, 1, 1, 0)
    rule.Parent = card

    local stack = Instance.new("Frame")
    stack.BackgroundTransparency = 1
    stack.Position = UDim2.new(0, 24, 0, 22)
    stack.Size = UDim2.new(1, -46, 0, 0)
    stack.AutomaticSize = Enum.AutomaticSize.Y
    stack.Parent = left
    local stackList = Instance.new("UIListLayout", stack)
    stackList.Padding = UDim.new(0, 5)
    stackList.SortOrder = Enum.SortOrder.LayoutOrder

    local title = label(stack, PANDA.displayName, 19, ink, Enum.Font.GothamBold, 1)
    title.AutomaticSize = Enum.AutomaticSize.None
    title.TextWrapped = false
    title.TextTruncate = Enum.TextTruncate.AtEnd
    title.Size = UDim2.new(1, 0, 0, 23)

    if PANDA.description and PANDA.description ~= "" then
        label(stack, PANDA.description, 11, mute, Enum.Font.Gotham, 2)
    end

    local gap = Instance.new("Frame")
    gap.BackgroundTransparency = 1
    gap.Size = UDim2.new(1, 0, 0, 10)
    gap.LayoutOrder = 3
    gap.Parent = stack

    local function fact(order, name, value, onClick)
        local f = Instance.new(onClick and "TextButton" or "Frame")
        f.BackgroundColor3 = paper
        f.BorderSizePixel = 0
        f.Size = UDim2.new(1, 0, 0, 42)
        f.LayoutOrder = order
        f.Parent = stack
        if onClick then
            f.AutoButtonColor = true
            f.Text = ""
            f.MouseButton1Click:Connect(onClick)
        end
        local fs = Instance.new("UIStroke", f)
        fs.Color = rime
        fs.Thickness = 1

        local k = Instance.new("TextLabel")
        k.BackgroundTransparency = 1
        k.Position = UDim2.new(0, 11, 0, 7)
        k.Size = UDim2.new(1, -22, 0, 12)
        k.Font = Enum.Font.Code
        k.TextSize = 10
        k.TextColor3 = dim
        k.TextXAlignment = Enum.TextXAlignment.Left
        k.Text = string.upper(name)
        k.Parent = f

        local v = Instance.new("TextLabel")
        v.BackgroundTransparency = 1
        v.Position = UDim2.new(0, 11, 0, 21)
        v.Size = UDim2.new(1, -22, 0, 14)
        v.Font = Enum.Font.Code
        v.TextSize = 12
        v.TextColor3 = ink
        v.TextXAlignment = Enum.TextXAlignment.Left
        v.TextTruncate = Enum.TextTruncate.AtEnd
        v.Text = value
        v.Parent = f
        return f
    end

    fact(4, "HWID", hwidShown, function()
        if hwid ~= "" then
            local ok = pcall(function() setclipboard(hwid) end)
            setStatusLocal(ok and "HWID copied to your clipboard." or "No clipboard on this executor.", ok and accent or bad)
        else
            setStatusLocal("No HWID to copy on this executor.", bad)
        end
    end)
    fact(5, "Date", today, nil)

    local quoteLabel = Instance.new("TextLabel")
    quoteLabel.BackgroundTransparency = 1
    quoteLabel.AnchorPoint = Vector2.new(0, 1)
    quoteLabel.Position = UDim2.new(0, 24, 1, -22)
    quoteLabel.Size = UDim2.new(1, -46, 0, 0)
    quoteLabel.AutomaticSize = Enum.AutomaticSize.Y
    quoteLabel.Font = Enum.Font.GothamMedium
    quoteLabel.TextSize = 11
    quoteLabel.TextColor3 = mute
    quoteLabel.TextXAlignment = Enum.TextXAlignment.Left
    quoteLabel.TextYAlignment = Enum.TextYAlignment.Bottom
    quoteLabel.TextWrapped = true
    quoteLabel.Text = '"' .. pickQuote() .. '"'
    quoteLabel.Parent = left

    -- right column body: caption, key box, primary check, get-a-key
    local function caption(order, text)
        local c = label(right, string.upper(text), 10, dim, Enum.Font.Code, order)
        c.AutomaticSize = Enum.AutomaticSize.None
        c.TextWrapped = false
        c.Size = UDim2.new(1, 0, 0, 13)
        return c
    end

    local function button(order, text, filled)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 40)
        b.AutoButtonColor = true
        b.BorderSizePixel = 0
        b.Font = Enum.Font.Code
        b.TextSize = 12
        b.Text = string.upper(text)
        b.LayoutOrder = order
        b.Parent = right
        if filled then
            b.BackgroundColor3 = ink
            b.TextColor3 = Color3.fromRGB(244, 248, 250)
        else
            b.BackgroundColor3 = paper
            b.TextColor3 = ink
            local bs = Instance.new("UIStroke", b)
            bs.Color = rime
            bs.Thickness = 1
        end
        return b
    end

    caption(1, "Key")

    local field = Instance.new("TextBox")
    field.Size = UDim2.new(1, 0, 0, 40)
    field.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    field.BorderSizePixel = 0
    field.Font = Enum.Font.Gotham
    field.TextSize = 13
    field.TextColor3 = ink
    field.TextXAlignment = Enum.TextXAlignment.Left
    field.PlaceholderText = "Paste your key"
    field.PlaceholderColor3 = dim
    field.ClearTextOnFocus = false
    field.Text = ""
    field.LayoutOrder = 2
    field.Parent = right
    local xs = Instance.new("UIStroke", field)
    xs.Color = rime
    xs.Thickness = 1
    local bpad = Instance.new("UIPadding", field)
    bpad.PaddingLeft = UDim.new(0, 12)
    bpad.PaddingRight = UDim.new(0, 12)

    local submit = button(3, "Continue", true)

    if PANDA.getKeyUrl or PANDA.supportUrl then
        button(4, "Get Key", false).MouseButton1Click:Connect(function()
            copyKeyLink(setStatusLocal, accent, bad)
        end)
    end

    return { screen = screen, card = card, field = field, submit = submit, status = status }
end

-- Smoked Glass: a wide frosted charcoal panel over a backdrop blur, with a nav
-- rail on the left carrying the identity, facts and a rotating line. Ported from
-- the ArcticAuth "Smoked Glass" GUI onto Panda's key flow. The blur is always
-- torn down with the screen, so a destroyed GUI never leaves the world blurred.
local function buildSmokedGlass(session)
    local parent = (gethui and gethui()) or game:GetService("CoreGui")

    local accent = PANDA.accent
    local ink = Color3.fromRGB(240, 242, 246)
    local mute = Color3.fromRGB(147, 153, 161)
    local dim = Color3.fromRGB(112, 118, 126)
    local bad = Color3.fromRGB(255, 120, 120)

    local hwid = hardwareId()
    local hwidShown = hwid == "" and "unavailable"
        or (#hwid > 20 and (hwid:sub(1, 20) .. "...") or hwid)
    local today = os.date("%d %b %Y")

    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = game:GetService("Lighting")
    pcall(function() TweenService:Create(blur, TweenInfo.new(0.3), { Size = 18 }):Play() end)

    local screen = Instance.new("ScreenGui")
    screen.Name = "PandaKvs_" .. tostring(math.random(100000, 999999))
    screen.IgnoreGuiInset = true
    screen.ResetOnSpawn = false
    screen.DisplayOrder = 1000
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.Parent = parent

    -- The blur lives on Lighting, not under the ScreenGui, so it has to be
    -- removed by hand. Tie its teardown to the screen being destroyed.
    screen.AncestryChanged:Connect(function(_, newParent)
        if newParent == nil then
            pcall(function()
                if blur then TweenService:Create(blur, TweenInfo.new(0.2), { Size = 0 }):Play() end
            end)
            task.delay(0.25, function() pcall(function() if blur then blur:Destroy() end end) end)
        end
    end)

    local shade = Instance.new("Frame")
    shade.Size = UDim2.fromScale(1, 1)
    shade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shade.BackgroundTransparency = 0.55
    shade.BorderSizePixel = 0
    shade.Parent = screen

    local card = Instance.new("Frame")
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.Size = UDim2.fromOffset(660, 320)
    card.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.Parent = screen
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 18)
    local grad = Instance.new("UIGradient", card)
    grad.Rotation = 90
    grad.Color = ColorSequence.new(Color3.fromRGB(36, 38, 42), Color3.fromRGB(14, 15, 17))
    grad.Transparency = NumberSequence.new(0.1, 0.22)
    local cardStroke = Instance.new("UIStroke", card)
    cardStroke.Color = Color3.fromRGB(255, 255, 255)
    cardStroke.Transparency = 0.72
    cardStroke.Thickness = 1.5
    cardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    makeDraggable(screen, card)

    local function label(parentFrame, text, size, colour, font, order)
        local l = Instance.new("TextLabel")
        l.BackgroundTransparency = 1
        l.Size = UDim2.new(1, 0, 0, size + 5)
        l.AutomaticSize = Enum.AutomaticSize.Y
        l.Font = font
        l.TextSize = size
        l.TextColor3 = colour
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextYAlignment = Enum.TextYAlignment.Top
        l.TextWrapped = true
        l.Text = text
        l.LayoutOrder = order
        l.Parent = parentFrame
        return l
    end

    -- nav rail
    local rail = Instance.new("Frame")
    rail.BackgroundTransparency = 1
    rail.Size = UDim2.new(0, 214, 1, 0)
    rail.Parent = card

    local railTop = Instance.new("Frame")
    railTop.BackgroundTransparency = 1
    railTop.Position = UDim2.new(0, 22, 0, 20)
    railTop.Size = UDim2.new(1, -38, 0, 0)
    railTop.AutomaticSize = Enum.AutomaticSize.Y
    railTop.Parent = rail
    local railList = Instance.new("UIListLayout", railTop)
    railList.Padding = UDim.new(0, 3)
    railList.SortOrder = Enum.SortOrder.LayoutOrder

    label(railTop, PANDA.displayName, 15, ink, Enum.Font.GothamBold, 1)
    if PANDA.description and PANDA.description ~= "" then
        label(railTop, PANDA.description, 11, mute, Enum.Font.Gotham, 2)
    end

    local rule = Instance.new("Frame")
    rule.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    rule.BackgroundTransparency = 0.88
    rule.BorderSizePixel = 0
    rule.Position = UDim2.new(0, 214, 0, 18)
    rule.Size = UDim2.new(0, 1, 1, -36)
    rule.Parent = card

    -- rail footer: facts and a rotating line, pinned to the bottom
    local foot = Instance.new("Frame")
    foot.BackgroundTransparency = 1
    foot.AnchorPoint = Vector2.new(0, 1)
    foot.Position = UDim2.new(0, 22, 1, -18)
    foot.Size = UDim2.new(1, -38, 0, 0)
    foot.AutomaticSize = Enum.AutomaticSize.Y
    foot.Parent = rail
    local footList = Instance.new("UIListLayout", foot)
    footList.Padding = UDim.new(0, 6)
    footList.SortOrder = Enum.SortOrder.LayoutOrder

    local footRule = Instance.new("Frame")
    footRule.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    footRule.BackgroundTransparency = 0.9
    footRule.BorderSizePixel = 0
    footRule.Size = UDim2.new(1, 0, 0, 1)
    footRule.LayoutOrder = 1
    footRule.Parent = foot

    -- content pane
    local pane = Instance.new("Frame")
    pane.BackgroundTransparency = 1
    pane.Position = UDim2.new(0, 215, 0, 0)
    pane.Size = UDim2.new(1, -215, 1, 0)
    pane.Parent = card
    local panePad = Instance.new("UIPadding", pane)
    panePad.PaddingTop = UDim.new(0, 22)
    panePad.PaddingLeft = UDim.new(0, 22)
    panePad.PaddingRight = UDim.new(0, 22)
    local paneList = Instance.new("UIListLayout", pane)
    paneList.Padding = UDim.new(0, 10)
    paneList.SortOrder = Enum.SortOrder.LayoutOrder

    local status = Instance.new("TextLabel")
    status.BackgroundTransparency = 1
    status.AnchorPoint = Vector2.new(1, 1)
    status.Position = UDim2.new(1, -22, 1, -16)
    status.Size = UDim2.new(0, 380, 0, 16)
    status.Font = Enum.Font.Gotham
    status.TextSize = 12
    status.TextColor3 = accent
    status.TextXAlignment = Enum.TextXAlignment.Right
    status.TextTruncate = Enum.TextTruncate.AtEnd
    status.Text = ""
    status.Parent = card

    local function setStatusLocal(text, colour)
        status.Text = text
        status.TextColor3 = colour or accent
    end

    local function fact(order, name, value, onClick)
        local f = Instance.new(onClick and "TextButton" or "Frame")
        f.BackgroundTransparency = 1
        f.Size = UDim2.new(1, 0, 0, 30)
        f.LayoutOrder = order
        f.Parent = foot
        if onClick then
            f.AutoButtonColor = false
            f.Text = ""
            f.MouseButton1Click:Connect(onClick)
        end
        local k = Instance.new("TextLabel")
        k.BackgroundTransparency = 1
        k.Size = UDim2.new(1, 0, 0, 12)
        k.Font = Enum.Font.Gotham
        k.TextSize = 10
        k.TextColor3 = dim
        k.TextXAlignment = Enum.TextXAlignment.Left
        k.Text = name
        k.Parent = f
        local v = Instance.new("TextLabel")
        v.BackgroundTransparency = 1
        v.Position = UDim2.new(0, 0, 0, 14)
        v.Size = UDim2.new(1, 0, 0, 14)
        v.Font = Enum.Font.GothamMedium
        v.TextSize = 12
        v.TextColor3 = ink
        v.TextXAlignment = Enum.TextXAlignment.Left
        v.TextTruncate = Enum.TextTruncate.AtEnd
        v.Text = value
        v.Parent = f
        return f
    end

    fact(2, "HWID", hwidShown, function()
        if hwid ~= "" then
            local ok = pcall(function() setclipboard(hwid) end)
            setStatusLocal(ok and "HWID copied to your clipboard." or "No clipboard on this executor.", ok and accent or bad)
        else
            setStatusLocal("No HWID to copy on this executor.", bad)
        end
    end)
    fact(3, "Date", today, nil)

    local quoteLabel = label(foot, '"' .. pickQuote() .. '"', 11, dim, Enum.Font.GothamMedium, 4)
    quoteLabel.TextYAlignment = Enum.TextYAlignment.Bottom

    -- pane body
    local heading = label(pane, "Verification", 11, dim, Enum.Font.GothamMedium, 1)
    heading.Size = UDim2.new(1, 0, 0, 18)
    heading.AutomaticSize = Enum.AutomaticSize.None

    local field = Instance.new("TextBox")
    field.Size = UDim2.new(1, 0, 0, 38)
    field.BackgroundColor3 = Color3.fromRGB(18, 19, 22)
    field.BackgroundTransparency = 0.25
    field.BorderSizePixel = 0
    field.Font = Enum.Font.Gotham
    field.TextSize = 13
    field.TextColor3 = ink
    field.TextXAlignment = Enum.TextXAlignment.Left
    field.PlaceholderText = "Paste your key"
    field.PlaceholderColor3 = Color3.fromRGB(122, 128, 138)
    field.ClearTextOnFocus = false
    field.Text = ""
    field.LayoutOrder = 2
    field.Parent = pane
    Instance.new("UICorner", field).CornerRadius = UDim.new(0, 9)
    local xs = Instance.new("UIStroke", field)
    xs.Color = Color3.fromRGB(255, 255, 255)
    xs.Transparency = 0.86
    xs.Thickness = 1
    local bpad = Instance.new("UIPadding", field)
    bpad.PaddingLeft = UDim.new(0, 12)
    bpad.PaddingRight = UDim.new(0, 12)

    local function pill(order, text, filled)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 34)
        b.BackgroundColor3 = filled and accent or Color3.fromRGB(238, 240, 244)
        b.BackgroundTransparency = filled and 0 or 0.08
        b.BorderSizePixel = 0
        b.AutoButtonColor = true
        b.Font = Enum.Font.GothamMedium
        b.TextSize = 13
        b.TextColor3 = filled and Color3.fromRGB(12, 12, 15) or Color3.fromRGB(20, 21, 24)
        b.Text = text
        b.LayoutOrder = order
        b.Parent = pane
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 9)
        if not filled then
            local bs = Instance.new("UIStroke", b)
            bs.Color = Color3.fromRGB(255, 255, 255)
            bs.Transparency = 0.85
            bs.Thickness = 1
        end
        return b
    end

    local submit = pill(3, "Continue", true)

    if PANDA.getKeyUrl or PANDA.supportUrl then
        pill(4, "Get Key", false).MouseButton1Click:Connect(function()
            copyKeyLink(setStatusLocal, accent, bad)
        end)
    end

    return { screen = screen, card = card, field = field, submit = submit, status = status }
end

local function buildGui(session)
    if PANDA.preset == "glacier" then
        return buildGlacier(session)
    elseif PANDA.preset == "smokedglass" then
        return buildSmokedGlass(session)
    end
    return buildStandard(session)
end

-- ── the flow ─────────────────────────────────────────────────────────────────

-- Opening a session. A structured "retry" (the platform could not be confirmed
-- for a moment, or this network is briefly rate limited) is honoured a few
-- times before giving up; anything else ends here with the server's reason.
local session, sessionError

for sessionAttempt = 1, 3 do
    session, sessionError = post("/kvs/" .. PANDA.publicId .. "/session", {})

    if not session or session.ok or session.action ~= "retry" or sessionAttempt == 3 then
        break
    end

    task.wait(math.min(tonumber(session.retryAfter) or 2, 10) + math.random())
end

if not session then
    fail(sessionError)
end

if not session.ok then
    fail(session.message or "This script could not be started.")
end

local ui = buildGui(session)
local nonce = session.nonce
local busy = false
local timings = {}

local function setStatus(text, colour)
    ui.status.Text = text
    ui.status.TextColor3 = colour or Color3.fromRGB(150, 150, 160)
end

-- ── completion ───────────────────────────────────────────────────────────────
--
-- The flow ends exactly once, as one of: the script arrived, the server said
-- no, or the session ran out. The main thread waits on this signal rather than
-- polling: it used to wake every 0.2 seconds, which added up to that much delay
-- before the script ran, and it could also decide the flow had failed while
-- the download was still in progress and return without running anything.
local done = Instance.new("BindableEvent")
local outcome, outcomeMessage, deliveredSource = nil, nil, nil

local function settle(kind, message, body)
    if outcome then
        return
    end

    outcome, outcomeMessage, deliveredSource = kind, message, body
    done:Fire()
end

task.delay(PANDA.sessionSeconds, function()
    settle("timeout", "This session timed out. Run the script again.")
end)

-- What a refusal body looks like: the server answers a GET it will not serve
-- with a Lua error() chunk, so the message reaches a loadstring caller.
local REFUSAL_PREFIX = "error([==[[Panda] "

local function refusalMessage(body)
    local first = string.find(body, "[Panda] ", 1, true)
    local last = first and string.find(body, "]==]", first, true)

    if first and last then
        return string.sub(body, first + 8, last - 1)
    end

    return "The script could not be downloaded. Run it again."
end

-- Fetches the release body. A refusal carrying the retry marker means the
-- permit is still good (storage blipped, or another fetch of it is mid-flight),
-- so the same URL is tried again a few times, well inside the permit's minute.
-- A transport error is retried the same way; if the first fetch was actually
-- delivered and only the response was lost, the retry is told the permit is
-- used, and the player runs the script again.
--
-- A refusal is never handed on as if it were the script. Running it would only
-- raise its error, and the heartbeat started next would kick the player from
-- the game half a minute later for a session that never ran.
local function download(ticket)
    local url = PANDA.origin .. "/kvs/d/" .. ticket
    local lastError = "The script could not be downloaded. Run it again."

    for fetch = 1, 4 do
        local started = nowMs()
        local ok, body = pcall(function()
            return game:HttpGet(url)
        end)

        if ok and type(body) == "string" then
            if string.sub(body, 1, #RETRY_MARKER) == RETRY_MARKER then
                lastError = refusalMessage(body)
            elseif string.sub(body, 1, #REFUSAL_PREFIX) == REFUSAL_PREFIX then
                return nil, refusalMessage(body)
            else
                timings.downloadMs = math.floor(nowMs() - started)
                timings.bytes = #body
                return body
            end
        end

        if fetch < 4 then
            task.wait(jittered(0.5 * fetch, 0.25))
        end
    end

    return nil, lastError
end

local function attempt()
    -- One check at a time. A second press, or Enter and a click together, used
    -- to send the same challenge twice: the second was refused as a replay and
    -- ended the flow while the first was still succeeding.
    if outcome or busy then
        return
    end

    busy = true

    local key = ui.field.Text

    ui.submit.Text = "Checking"
    ui.submit.AutoButtonColor = false
    setStatus("")

    local checkStarted = nowMs()

    local result, transportError = post("/kvs/session/" .. session.sessionId .. "/key", {
        nonce = nonce,
        key = key,
        hwid = hardwareId(),

        -- Reported for the owner's key log only, and only used as text.
        username = playerName(),
        game = gameName(),
        executor = executorName(),
    })

    timings.keyCheckMs = math.floor(nowMs() - checkStarted)

    ui.submit.Text = "Continue"
    ui.submit.AutoButtonColor = true

    if not result then
        busy = false
        setStatus(transportError, Color3.fromRGB(235, 120, 120))
        return
    end

    if not result.ok then
        if result.nonce then
            -- The server hands back a fresh nonce whenever another attempt is
            -- allowed, a rate limit included. Without swapping it in, a second
            -- try would be refused as a replay rather than for the reason the
            -- player expects.
            nonce = result.nonce
            busy = false
            setStatus(result.message, Color3.fromRGB(235, 120, 120))
        elseif result.action == "retry" then
            -- Refused before the challenge was spent (the platform briefly
            -- unconfirmed at the edge of the request), so the same challenge
            -- is still good.
            busy = false
            setStatus(result.message, Color3.fromRGB(235, 120, 120))
        else
            settle("failed", result.message or "Authorization failed.")
        end

        return
    end

    setStatus("Loading", Color3.fromRGB(140, 220, 160))

    local body, downloadError = download(result.ticket)

    if body then
        settle("delivered", nil, body)
    else
        settle("failed", downloadError or "The script could not be downloaded. Run it again.")
    end
end

ui.submit.MouseButton1Click:Connect(attempt)
ui.field.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        attempt()
    end
end)

if not outcome then
    done.Event:Wait()
end

pcall(function() ui.screen:Destroy() end)
pcall(function() done:Destroy() end)

if outcome ~= "delivered" then
    fail(outcomeMessage or "This session ended. Run the script again.")
end

-- ── heartbeat ────────────────────────────────────────────────────────────────
--
-- While the delivered script runs, beat on an interval so the server can keep
-- the session alive and, just as importantly, END it: a script the owner
-- disables, a key that is revoked or expires, a session that outlived its
-- ceiling, or a session token seen from another machine all come back here as
-- a kick.
--
-- A beat that cannot reach Panda, or that Panda answers with "retry", is tried
-- again with growing, jittered backoff, up to PANDA.heartbeatRetries times. A
-- brief blip is survived; a real disconnect that outlasts the budget kicks the
-- player rather than leaving a script running with no way to be revoked. The
-- server's own window is longer than all of that, so a recovered client is
-- never kicked for having been patient. This is NOT the security boundary: it
-- runs on the player's machine and can be patched out.

local function kickPlayer(reason)
    pcall(function()
        Players.LocalPlayer:Kick("[Panda] " .. (reason or "Your session has ended."))
    end)
end

local function startHeartbeat(sessionId, firstTimings)
    task.spawn(function()
        local hwid = hardwareId()
        local pending = firstTimings
        local pause = jittered(PANDA.heartbeatSeconds, PANDA.heartbeatSeconds * 0.15)

        while true do
            task.wait(pause)

            local result
            local answered = false

            for try = 1, PANDA.heartbeatRetries do
                result = post("/kvs/session/" .. sessionId .. "/heartbeat", { hwid = hwid, timings = pending })

                if result and (result.ok or result.action == "kick" or result.action == "continue") then
                    answered = true
                    break
                end

                if result and result.ok == false and result.action ~= "retry" then
                    -- An answer, just not a revision 2 one: treat it as final.
                    answered = true
                    break
                end

                if try < PANDA.heartbeatRetries then
                    local backoff = math.max(tonumber(result and result.retryAfter) or 0, try * 2)
                    task.wait(jittered(backoff, 1))
                end
            end

            if not answered then
                -- Every reconnect attempt failed: the connection is gone.
                kickPlayer("Lost connection to Panda. Rejoin to try again.")
                return
            end

            if not result.ok or result.action == "kick" then
                -- The server answered, and the answer is stop.
                kickPlayer(result.message)
                return
            end

            pending = nil

            -- The server spreads beats itself; fall back to a local spread.
            pause = tonumber(result.nextBeatSeconds)
                or jittered(PANDA.heartbeatSeconds, PANDA.heartbeatSeconds * 0.15)
        end
    end)
end

local compileStarted = nowMs()
local chunk, compileError = loadstring(deliveredSource)
timings.compileMs = math.floor(nowMs() - compileStarted)

if not chunk then
    fail("The delivered script could not be loaded: " .. tostring(compileError))
end

-- Runs alongside the delivered script rather than before it: the beat loop is
-- spawned, then control falls straight through to running the chunk. The first
-- beat carries this run's load timings, so download, compile and key-check time
-- can be told apart from server time.
startHeartbeat(session.sessionId, timings)

return chunk()
