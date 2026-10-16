--[[
    SneakyCrack — IN-GAME KEY SYSTEM UI  (served by /api/loader)

    This is the window users see inside Roblox after running the loader.
    It mirrors the website: dark glass panel, green accent, shimmer title.

    Flow: key + HWID + PlaceId  →  /api/exec
      → key valid      : one-time stub → payload for THIS game → execute
      → key invalid    : red status message, nothing runs
      → no key + premium HWID : keyless execution, premium tier
    Vouchers: code + HWID → /api/redeem → premium binds to this device.
]]

local SITE = "https://sneakycracker.vercel.app"
local SITE_HOST = SITE:gsub("^https?://", "")

local GREEN      = Color3.fromRGB(0, 224, 84)    -- #00e054
local GREEN_SOFT = Color3.fromRGB(166, 255, 63)  -- #a6ff3f
local GREEN_TEXT = Color3.fromRGB(157, 255, 190) -- #9dffbe
local DARK_TEXT  = Color3.fromRGB(4, 18, 10)     -- #04120a
local BG_DIM     = Color3.fromRGB(3, 6, 4)
local CARD_BG    = Color3.fromRGB(10, 16, 11)
local INPUT_BG   = Color3.fromRGB(3, 7, 4)
local WHITE      = Color3.fromRGB(255, 255, 255)
local MUTED      = Color3.fromRGB(158, 172, 161) -- white/55
local FAINT      = Color3.fromRGB(110, 122, 113) -- white/35
local RED_TEXT   = Color3.fromRGB(252, 165, 165)
local AMBER_TEXT = Color3.fromRGB(252, 211, 77)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- ── helpers ──────────────────────────────────────────────────────────

local HWID_CACHE = nil
local function hwid()
    if HWID_CACHE then return HWID_CACHE end
    if typeof(gethwid) == "function" then
        HWID_CACHE = tostring(gethwid())
        return HWID_CACHE
    end
    local ok, id = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    HWID_CACHE = ok and tostring(id) or "unknown"
    return HWID_CACHE
end

local function presetKey()
    local g = (typeof(getgenv) == "function" and getgenv()) or _G
    local k = rawget(g, "SNEAKY_PRESET_KEY")
    if typeof(k) == "string" and #k >= 10 and k ~= "PASTE_YOUR_KEY_HERE" then
        return k
    end
    return nil
end

local function corner(radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = radius
    return c
end

local function stroke(color, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Transparency = transparency
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end

local function padding(l, t, r, b)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, l)
    p.PaddingTop = UDim.new(0, t)
    p.PaddingRight = UDim.new(0, r)
    p.PaddingBottom = UDim.new(0, b)
    return p
end

local function label(props)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.BorderSizePixel = 0
    l.Font = props.font or Enum.Font.Gotham
    l.Text = props.text or ""
    l.TextColor3 = props.color or WHITE
    l.TextSize = props.size or 14
    l.TextXAlignment = props.xalign or Enum.TextXAlignment.Left
    l.TextYAlignment = props.yalign or Enum.TextYAlignment.Center
    l.Size = props.dim or UDim2.new(0, 100, 0, 20)
    l.Position = props.pos or UDim2.new(0, 0, 0, 0)
    l.AnchorPoint = props.anchor or Vector2.new(0, 0)
    l.RichText = props.rich or false
    l.TextWrapped = props.wrap or false
    l.ZIndex = props.z or 3
    l.Parent = props.parent
    return l
end

-- ── gui root ─────────────────────────────────────────────────────────

local parent
do
    local ok, hui = pcall(function()
        return (typeof(gethui) == "function" and gethui()) or game:GetService("CoreGui")
    end)
    if ok and hui then
        parent = hui
    else
        parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
end

pcall(function()
    local old = parent:FindFirstChild("SneakyCrackUI")
    if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "SneakyCrackUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = parent

-- dim backdrop
local dim = Instance.new("Frame")
dim.Name = "Dim"
dim.Size = UDim2.fromScale(1, 1)
dim.BackgroundColor3 = BG_DIM
dim.BackgroundTransparency = 1
dim.BorderSizePixel = 0
dim.ZIndex = 1
dim.Parent = gui

-- soft green glow behind the card (fake bloom, website "orb")
local glow = Instance.new("Frame")
glow.Name = "Glow"
glow.AnchorPoint = Vector2.new(0.5, 0.5)
glow.Position = UDim2.fromScale(0.5, 0.5)
glow.Size = UDim2.fromOffset(560, 560)
glow.BackgroundColor3 = GREEN
glow.BackgroundTransparency = 0.94
glow.BorderSizePixel = 0
glow.ZIndex = 1
glow.Parent = gui
corner(UDim.new(1, 0)).Parent = glow

local glow2 = glow:Clone()
glow2.Size = UDim2.fromOffset(360, 360)
glow2.BackgroundTransparency = 0.9
glow2.Position = UDim2.new(0.5, 0, 0.5, -40)
glow2.Parent = gui

-- ── card ─────────────────────────────────────────────────────────────

local CARD_W, CARD_H = 440, 560

local card = Instance.new("Frame")
card.Name = "Card"
card.AnchorPoint = Vector2.new(0.5, 0.5)
card.Position = UDim2.fromScale(0.5, 0.5)
card.Size = UDim2.fromOffset(CARD_W, CARD_H)
card.BackgroundColor3 = CARD_BG
card.BackgroundTransparency = 0.08
card.BorderSizePixel = 0
card.ClipsDescendants = true
card.ZIndex = 2
card.Parent = gui
corner(UDim.new(0, 24)).Parent = card
stroke(WHITE, 0.9).Parent = card

-- glass gradient sheen
local glassGrad = Instance.new("UIGradient")
glassGrad.Rotation = 65
glassGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 48, 40)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(16, 24, 18)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 32, 26)),
})
glassGrad.Parent = card

-- top specular highlight strip
local sheen = Instance.new("Frame")
sheen.Size = UDim2.new(1, 0, 0, 90)
sheen.BackgroundColor3 = WHITE
sheen.BackgroundTransparency = 0.95
sheen.BorderSizePixel = 0
sheen.ZIndex = 2
sheen.Parent = card
corner(UDim.new(0, 24)).Parent = sheen
local sheenGrad = Instance.new("UIGradient")
sheenGrad.Rotation = 90
sheenGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.55),
    NumberSequenceKeypoint.new(1, 1),
})
sheenGrad.Parent = sheen

-- auto-scale for small (mobile executor) windows
local uiScale = Instance.new("UIScale")
uiScale.Parent = card
local function fitScale()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local v = cam.ViewportSize
    uiScale.Scale = math.clamp(math.min(v.X / (CARD_W + 40), v.Y / (CARD_H + 40)), 0.5, 1)
end
fitScale()
pcall(function()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitScale)
end)

-- ── header (logo + close) ────────────────────────────────────────────

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 64)
header.BackgroundTransparency = 1
header.ZIndex = 3
header.Parent = card

local dot = Instance.new("Frame")
dot.AnchorPoint = Vector2.new(0, 0.5)
dot.Position = UDim2.new(0, 26, 0.5, 0)
dot.Size = UDim2.fromOffset(10, 10)
dot.BackgroundColor3 = GREEN
dot.BorderSizePixel = 0
dot.ZIndex = 3
dot.Parent = header
corner(UDim.new(1, 0)).Parent = dot

-- pulsing dot, like the website nav
task.spawn(function()
    local info = TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    TweenService:Create(dot, info, { Size = UDim2.fromOffset(7, 7), BackgroundTransparency = 0.35 }):Play()
end)

label({
    parent = header,
    text = "SNEAKY<font color=\"#00e054\">CRACK</font>",
    rich = true,
    font = Enum.Font.GothamBlack,
    size = 19,
    pos = UDim2.new(0, 44, 0, 0),
    dim = UDim2.new(1, -120, 1, 0),
})

local closeBtn = Instance.new("TextButton")
closeBtn.AnchorPoint = Vector2.new(1, 0.5)
closeBtn.Position = UDim2.new(1, -18, 0.5, 0)
closeBtn.Size = UDim2.fromOffset(36, 36)
closeBtn.BackgroundColor3 = WHITE
closeBtn.BackgroundTransparency = 0.96
closeBtn.Text = "✕"
closeBtn.TextColor3 = MUTED
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.ZIndex = 4
closeBtn.AutoButtonColor = false
closeBtn.Parent = header
corner(UDim.new(1, 0)).Parent = closeBtn
stroke(WHITE, 0.92).Parent = closeBtn

-- ── body ─────────────────────────────────────────────────────────────

local body = Instance.new("Frame")
body.Position = UDim2.new(0, 26, 0, 64)
body.Size = UDim2.new(1, -52, 1, -64)
body.BackgroundTransparency = 1
body.ZIndex = 3
body.Parent = card

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Vertical
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 12)
layout.Parent = body

label({
    parent = body,
    text = "K E Y   S Y S T E M",
    font = Enum.Font.GothamBold,
    size = 11,
    color = GREEN,
    dim = UDim2.new(1, 0, 0, 14),
}).LayoutOrder = 1

local title = label({
    parent = body,
    text = "GET YOUR KEY",
    font = Enum.Font.GothamBlack,
    size = 34,
    dim = UDim2.new(1, 0, 0, 40),
})
title.LayoutOrder = 2

-- shimmer across the title, like the website's .text-shimmer
local shimmer = Instance.new("UIGradient")
shimmer.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, WHITE),
    ColorSequenceKeypoint.new(0.5, WHITE),
    ColorSequenceKeypoint.new(0.72, GREEN_SOFT),
    ColorSequenceKeypoint.new(0.88, GREEN),
    ColorSequenceKeypoint.new(1, GREEN_SOFT),
})
shimmer.Parent = title
task.spawn(function()
    local info = TweenInfo.new(2.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    TweenService:Create(shimmer, info, { Offset = Vector2.new(-0.25, 0) }):Play()
end)

local sub = label({
    parent = body,
    text = "Paste your key to unlock SneakyCrack for this game — or leave it empty and go keyless with premium. Free 12-hour keys at "
        .. SITE_HOST .. "/key",
    size = 13,
    color = MUTED,
    wrap = true,
    yalign = Enum.TextYAlignment.Top,
    dim = UDim2.new(1, 0, 0, 50),
})
sub.LayoutOrder = 3

-- key input
local inputWrap = Instance.new("Frame")
inputWrap.Size = UDim2.new(1, 0, 0, 50)
inputWrap.BackgroundColor3 = INPUT_BG
inputWrap.BackgroundTransparency = 0.25
inputWrap.BorderSizePixel = 0
inputWrap.ZIndex = 3
inputWrap.LayoutOrder = 4
inputWrap.Parent = body
corner(UDim.new(0, 14)).Parent = inputWrap
local inputStroke = stroke(WHITE, 0.88)
inputStroke.Parent = inputWrap

local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -28, 1, 0)
input.Position = UDim2.new(0, 14, 0, 0)
input.BackgroundTransparency = 1
input.Font = Enum.Font.Code
input.PlaceholderText = "SNKY-XXXXX-XXXXX-XXXXX"
input.PlaceholderColor3 = FAINT
input.Text = presetKey() or ""
input.TextColor3 = GREEN_TEXT
input.TextSize = 15
input.TextXAlignment = Enum.TextXAlignment.Left
input.ClearTextOnFocus = false
input.ClipsDescendants = true
input.ZIndex = 4
input.Parent = inputWrap

input.Focused:Connect(function()
    inputStroke.Color = GREEN
    inputStroke.Transparency = 0.4
end)
input.FocusLost:Connect(function()
    inputStroke.Color = WHITE
    inputStroke.Transparency = 0.88
end)

-- activate button (website .btn-primary)
local activate = Instance.new("TextButton")
activate.Size = UDim2.new(1, 0, 0, 48)
activate.BackgroundColor3 = GREEN
activate.Text = "ACTIVATE"
activate.TextColor3 = DARK_TEXT
activate.TextSize = 14
activate.Font = Enum.Font.GothamBlack
activate.AutoButtonColor = false
activate.ZIndex = 4
activate.LayoutOrder = 5
activate.Parent = body
corner(UDim.new(0.5, 0)).Parent = activate
local activateGrad = Instance.new("UIGradient")
activateGrad.Rotation = 25
activateGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, GREEN),
    ColorSequenceKeypoint.new(1, GREEN_SOFT),
})
activateGrad.Parent = activate

-- get key button (website .btn-ghost)
local getKey = Instance.new("TextButton")
getKey.Size = UDim2.new(1, 0, 0, 46)
getKey.BackgroundColor3 = WHITE
getKey.BackgroundTransparency = 0.96
getKey.Text = "GET A FREE KEY"
getKey.TextColor3 = WHITE
getKey.TextSize = 13
getKey.Font = Enum.Font.GothamBold
getKey.AutoButtonColor = false
getKey.ZIndex = 4
getKey.LayoutOrder = 6
getKey.Parent = body
corner(UDim.new(0.5, 0)).Parent = getKey
stroke(WHITE, 0.86).Parent = getKey

-- voucher toggle (website-style text button)
local voucherToggle = Instance.new("TextButton")
voucherToggle.Size = UDim2.new(1, 0, 0, 20)
voucherToggle.BackgroundTransparency = 1
voucherToggle.Text = "Have a voucher? Redeem it for premium"
voucherToggle.TextColor3 = GREEN_SOFT
voucherToggle.TextSize = 12
voucherToggle.Font = Enum.Font.GothamBold
voucherToggle.ZIndex = 4
voucherToggle.LayoutOrder = 7
voucherToggle.Parent = body

-- voucher panel (hidden until toggled)
local voucherPanel = Instance.new("Frame")
voucherPanel.Size = UDim2.new(1, 0, 0, 0)
voucherPanel.AutomaticSize = Enum.AutomaticSize.Y
voucherPanel.BackgroundColor3 = INPUT_BG
voucherPanel.BackgroundTransparency = 0.45
voucherPanel.BorderSizePixel = 0
voucherPanel.Visible = false
voucherPanel.ZIndex = 3
voucherPanel.LayoutOrder = 8
voucherPanel.ClipsDescendants = true
voucherPanel.Parent = body
corner(UDim.new(0, 14)).Parent = voucherPanel
padding(14, 12, 14, 12).Parent = voucherPanel

local vLayout = Instance.new("UIListLayout")
vLayout.FillDirection = Enum.FillDirection.Vertical
vLayout.Padding = UDim.new(0, 8)
vLayout.SortOrder = Enum.SortOrder.LayoutOrder
vLayout.Parent = voucherPanel

local voucherInput = Instance.new("TextBox")
voucherInput.Size = UDim2.new(1, 0, 0, 38)
voucherInput.BackgroundColor3 = CARD_BG
voucherInput.BackgroundTransparency = 0.2
voucherInput.Font = Enum.Font.Code
voucherInput.PlaceholderText = "SNKYV-XXXXX-XXXXX-XXXXX"
voucherInput.PlaceholderColor3 = FAINT
voucherInput.Text = ""
voucherInput.TextColor3 = GREEN_TEXT
voucherInput.TextSize = 14
voucherInput.ClearTextOnFocus = false
voucherInput.ZIndex = 4
voucherInput.LayoutOrder = 1
voucherInput.Parent = voucherPanel
corner(UDim.new(0, 10)).Parent = voucherInput
stroke(WHITE, 0.9).Parent = voucherInput
local voucherPad = Instance.new("UIPadding")
voucherPad.PaddingLeft = UDim.new(0, 12)
voucherPad.Parent = voucherInput

local voucherBtn = Instance.new("TextButton")
voucherBtn.Size = UDim2.new(1, 0, 0, 38)
voucherBtn.BackgroundColor3 = GREEN
voucherBtn.BackgroundTransparency = 0.75
voucherBtn.Text = "REDEEM VOUCHER"
voucherBtn.TextColor3 = GREEN_TEXT
voucherBtn.TextSize = 12
voucherBtn.Font = Enum.Font.GothamBlack
voucherBtn.AutoButtonColor = false
voucherBtn.ZIndex = 4
voucherBtn.LayoutOrder = 2
voucherBtn.Parent = voucherPanel
corner(UDim.new(0, 10)).Parent = voucherBtn
stroke(GREEN, 0.55).Parent = voucherBtn

-- HWID row (tap to copy — needed to redeem on the website)
local hwidRow = Instance.new("TextButton")
hwidRow.Size = UDim2.new(1, 0, 0, 18)
hwidRow.BackgroundTransparency = 1
hwidRow.Text = ""
hwidRow.ZIndex = 4
hwidRow.LayoutOrder = 9
hwidRow.AutoButtonColor = false
hwidRow.Parent = body

local hwidLabel = label({
    parent = hwidRow,
    text = "HWID: " .. hwid():sub(1, 26) .. (#hwid() > 26 and "…" or "") .. "  (tap to copy)",
    font = Enum.Font.Code,
    size = 10,
    color = FAINT,
    dim = UDim2.new(1, 0, 1, 0),
    xalign = Enum.TextXAlignment.Center,
})

-- status line
local status = label({
    parent = body,
    text = "Free keys via checkpoints — premium skips them entirely.",
    size = 12,
    color = FAINT,
    dim = UDim2.new(1, 0, 0, 18),
    xalign = Enum.TextXAlignment.Center,
})
status.LayoutOrder = 10

-- footer strip
local footer = label({
    parent = body,
    text = "12H KEYS  •  HWID LOCKED  •  PREMIUM KEYLESS  •  " .. SITE_HOST:upper(),
    font = Enum.Font.Code,
    size = 10,
    color = FAINT,
    dim = UDim2.new(1, 0, 0, 14),
    xalign = Enum.TextXAlignment.Center,
})
footer.LayoutOrder = 11

-- ── behaviour ────────────────────────────────────────────────────────

local function setStatus(kind, text)
    if kind == "ok" then
        status.TextColor3 = GREEN_TEXT
    elseif kind == "err" then
        status.TextColor3 = RED_TEXT
    elseif kind == "wait" then
        status.TextColor3 = AMBER_TEXT
    else
        status.TextColor3 = FAINT
    end
    status.Text = text
end

local function setLoading(on, text)
    activate.Active = not on
    activate.TextTransparency = on and 0.35 or 0
    activate.Text = on and (text or "WORKING…") or "ACTIVATE"
end

local destroyed = false
local function closeUI()
    if destroyed then return end
    destroyed = true
    local info = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    TweenService:Create(dim, info, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(uiScale, info, { Scale = uiScale.Scale * 0.94 }):Play()
    task.delay(0.3, function()
        pcall(function() gui:Destroy() end)
    end)
end

closeBtn.MouseButton1Click:Connect(closeUI)

local function copyGetKeyLink()
    local url = SITE .. "/key"
    local ok = pcall(function()
        if typeof(setclipboard) == "function" then setclipboard(url) end
    end)
    if ok and typeof(setclipboard) == "function" then
        setStatus("ok", "Link copied — open " .. SITE_HOST .. "/key in your browser.")
    else
        setStatus("info", "Open " .. SITE_HOST .. "/key in your browser for a free key.")
    end
end
getKey.MouseButton1Click:Connect(copyGetKeyLink)

local function serverMessage(body)
    -- luaError chunks look like: error("[SneakyCrack] message", 0)
    return body:match('%[SneakyCrack%]%s*(.-)"%s*,%s*0%s*%)')
end

-- ── premium keyless execution (reusable) ──────────────────────────────
local function executePremium()
    if gui then gui:Destroy() end
    
    local execUrl = SITE .. "/api/exec?hwid=" .. hwid()
        .. "&placeId=" .. tostring(game.PlaceId)
    
    local execOk, execBody = pcall(function()
        return game:HttpGet(execUrl)
    end)
    
    if execOk and execBody then
        local fn, err = loadstring(execBody)
        if fn then
            local runOk, runErr = pcall(fn)
            if not runOk then
                warn("[SneakyCrack] " .. tostring(runErr))
            end
        else
            warn("[SneakyCrack] Failed to load premium payload: " .. tostring(err))
        end
    else
        warn("[SneakyCrack] Failed to fetch premium payload.")
    end
end

local function runStub(stub)
    local fn, cerr = loadstring(stub)
    if not fn then
        setStatus("err", "Server reply not understood — try again.")
        setLoading(false)
        return
    end
    setStatus("ok", "Key verified — loading script…")
    task.spawn(function()
        local ok, rerr = pcall(fn)
        if not ok then
            warn("[SneakyCrack] " .. tostring(rerr))
        end
    end)
    task.delay(1.1, closeUI)
end

local busy = false

-- quick green pulse on the card border — premium redeem feedback
local function flashSuccess()
    local s = card:FindFirstChildOfClass("UIStroke")
    if not s then return end
    task.spawn(function()
        s.Color = GREEN
        s.Transparency = 0.1
        TweenService:Create(s, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 0.9,
        }):Play()
        task.delay(0.6, function()
            s.Color = WHITE
        end)
    end)
end

local function premiumKeyless()
    busy = true
    setLoading(true, "CHECKING PREMIUM…")
    setStatus("wait", "No key entered — checking premium on this device…")

    task.spawn(function()
        local url = SITE .. "/api/exec?hwid=" .. hwid()
            .. "&placeId=" .. tostring(game.PlaceId)

        local ok, body = pcall(function()
            return game:HttpGet(url)
        end)

        busy = false
        if not ok then
            setLoading(false)
            setStatus("err", "Could not reach the server. Try again.")
            return
        end

        local msg = serverMessage(body)
        if msg then
            setLoading(false)
            setStatus("err", msg)
        elseif body:find("/api/script/", 1, true) then
            setStatus("ok", "Premium verified — keyless execution…")
            flashSuccess()
            runStub(body)
        else
            setLoading(false)
            setStatus("err", "No key entered and this device has no premium.")
        end
    end)
end

local function activateKey()
    if busy then return end
    local key = input.Text:gsub("%s+", ""):upper()
    if #key == 0 then
        -- empty box = premium keyless attempt
        premiumKeyless()
        return
    end
    if #key < 10 then
        setStatus("err", "Enter your full key first (SNKY-XXXXX-XXXXX-XXXXX).")
        return
    end
    busy = true
    setLoading(true, "VERIFYING…")
    setStatus("wait", "Verifying key with the server…")

    task.spawn(function()
        local url = SITE .. "/api/exec?key=" .. key
            .. "&hwid=" .. hwid()
            .. "&placeId=" .. tostring(game.PlaceId)

        local ok, body = pcall(function()
            return game:HttpGet(url)
        end)

        busy = false
        if not ok then
            setLoading(false)
            setStatus("err", "Could not reach the server. Try again.")
            return
        end

        local msg = serverMessage(body)
        if msg then
            setLoading(false)
            setStatus("err", msg)
        elseif body:find("/api/script/", 1, true) then
            runStub(body)
        else
            setLoading(false)
            setStatus("err", "Invalid key — check for typos.")
        end
    end)
end

activate.MouseButton1Click:Connect(activateKey)
input.FocusLost:Connect(function(enter)
    if enter and #input.Text:gsub("%s+", "") > 0 then activateKey() end
end)

-- ── voucher redeem ─────────────────────────────────────────────

voucherToggle.MouseButton1Click:Connect(function()
    voucherPanel.Visible = not voucherPanel.Visible
    voucherToggle.Text = voucherPanel.Visible
        and "Hide voucher redeem"
        or  "Have a voucher? Redeem it for premium"
end)

hwidRow.MouseButton1Click:Connect(function()
    local ok = pcall(function()
        if typeof(setclipboard) == "function" then setclipboard(hwid()) end
    end)
    if ok and typeof(setclipboard) == "function" then
        hwidLabel.Text = "HWID copied — paste it on the site to redeem."
        task.delay(2.5, function()
            hwidLabel.Text = "HWID: " .. hwid():sub(1, 26) .. (#hwid() > 26 and "…" or "") .. "  (tap to copy)"
        end)
    end
end)

local voucherBusy = false
local function redeemVoucher()
    if voucherBusy then return end
    local code = voucherInput.Text:gsub("%s+", ""):upper()
    if #code < 10 then
        setStatus("err", "Enter the full voucher code (SNKYV-XXXXX-XXXXX-XXXXX).")
        return
    end
    voucherBusy = true
    voucherBtn.Text = "REDEEMING…"
    voucherBtn.TextTransparency = 0.35
    setStatus("wait", "Redeeming voucher…")

    task.spawn(function()
        local url = SITE .. "/api/redeem?code=" .. code .. "&hwid=" .. hwid()
        local ok, body = pcall(function()
            return game:HttpGet(url)
        end)

        voucherBusy = false
        voucherBtn.Text = "REDEEM VOUCHER"
        voucherBtn.TextTransparency = 0

        if not ok then
            setStatus("err", "Could not reach the server. Try again.")
            return
        end

        if body:sub(1, 3) == "OK|" then
            local kind = body:match("^OK|(%w+)")
            voucherInput.Text = ""
            voucherPanel.Visible = false
            voucherToggle.Text = "Have a voucher? Redeem it for premium"
            flashSuccess()
            
            if kind == "permanent" then
                setStatus("ok", "PERMANENT premium activated! Skipping key system in 5s...")
            else
                setStatus("ok", "Premium activated! Skipping key system in 5s...")
            end
            
            -- Auto-skip after 5 seconds
            task.delay(5, function()
                executePremium()
            end)
        else
            local reason = body:match("^ERR|(.+)$") or "unknown"
            local friendly = ({
                ["invalid-format"] = "That code format looks wrong (SNKYV-XXXXX-XXXXX-XXXXX).",
                ["unknown-code"] = "Unknown voucher code — check for typos.",
                ["already-redeemed"] = "This voucher was already redeemed.",
                ["rate-limited"] = "Too many attempts — wait a minute.",
            })[reason] or ("Redeem failed (" .. reason .. ").")
            setStatus("err", friendly)
        end
    end)
end

voucherBtn.MouseButton1Click:Connect(redeemVoucher)
voucherInput.FocusLost:Connect(function(enter)
    if enter then redeemVoucher() end
end)

-- ── dragging (mouse + touch) ─────────────────────────────────────────

do
    local dragging = false
    local dragStart, startPos

    header.InputBegan:Connect(function(io)
        if io.UserInputType == Enum.UserInputType.MouseButton1
            or io.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = io.Position
            startPos = card.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(io)
        if dragging and (io.UserInputType == Enum.UserInputType.MouseMovement
            or io.UserInputType == Enum.UserInputType.Touch) then
            local d = io.Position - dragStart
            card.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
            glow.Position = card.Position
            glow2.Position = UDim2.new(card.Position.X.Scale, card.Position.X.Offset,
                card.Position.Y.Scale, card.Position.Y.Offset - 40)
        end
    end)

    UserInputService.InputEnded:Connect(function(io)
        if io.UserInputType == Enum.UserInputType.MouseButton1
            or io.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- ── entrance animation ───────────────────────────────────────────────

dim.BackgroundTransparency = 1
uiScale.Scale = uiScale.Scale * 0.92
TweenService:Create(dim, TweenInfo.new(0.35), { BackgroundTransparency = 0.32 }):Play()
fitScale()
local target = uiScale.Scale
uiScale.Scale = target * 0.92
TweenService:Create(
    uiScale,
    TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    { Scale = target }
):Play()

-- preset key → one-tap start, but never auto-fire without the user
if presetKey() then
    setStatus("info", "Key prefilled from the loader — hit ACTIVATE.")
end

-- ── auto-bypass for premium users ───────────────────────────────────
-- If this device has premium, skip the UI entirely and execute directly.
task.spawn(function()
    local HttpService = game:GetService("HttpService")
    local url = SITE .. "/api/premium?hwid=" .. hwid()
    local ok, body = pcall(function()
        return game:HttpGet(url)
    end)
    
    if ok then
        local success, data = pcall(function()
            return HttpService:JSONDecode(body)
        end)
        
        if success and data and data.premium then
            executePremium()
        end
    end
end)
