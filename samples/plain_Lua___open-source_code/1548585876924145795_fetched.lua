local KEY_SERVER = "https://alxhub.online"
local HUB = "asylum-item"
local HUB_NAME = "Asylum Item"
local KEY_FILE = "ALXHub_asylum-item.key"
local DISCORD = "https://discord.gg/WeW9EZJQ3e"

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local httpRequest = (syn and syn.request)
    or http_request
    or request
    or (fluxus and fluxus.request)
    or (http and http.request)

local function getHWID()
    local hwid = ""
    pcall(function()
        hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    if hwid == nil or hwid == "" then
        pcall(function()
            hwid = "uid_" .. tostring(LocalPlayer.UserId)
        end)
    end
    return hwid
end

local function readSavedKey()
    local saved = nil
    pcall(function()
        if isfile and isfile(KEY_FILE) and readfile then
            saved = readfile(KEY_FILE)
        end
    end)
    if type(saved) == "string" then
        saved = saved:gsub("%s+", "")
        if #saved > 0 then return saved end
    end
    return nil
end

local function saveKey(k)
    pcall(function()
        if writefile then writefile(KEY_FILE, k) end
    end)
end

local function clearSavedKey()
    pcall(function()
        if delfile and isfile and isfile(KEY_FILE) then delfile(KEY_FILE) end
    end)
end

local function copyToClipboard(text)
    local copied = false
    pcall(function()
        local clip = setclipboard or toclipboard or (Clipboard and Clipboard.set) or set_clipboard
        if clip then
            clip(text)
            copied = true
        end
    end)
    return copied
end

local function notify(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 5,
        })
    end)
end

local function beacon(event)
    task.spawn(function()
        pcall(function()
            if not httpRequest then return end
            httpRequest({
                Url = KEY_SERVER .. "/api/loader-event",
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode({ hub = HUB, event = event }),
            })
        end)
    end)
end

local function fail(reason, detail)
    warn("[ALX HUB] " .. reason .. (detail and (" - " .. detail) or ""))
    error("[ALX HUB] " .. reason, 0)
end

local function requestHub(key)
    if not httpRequest then
        return false, "Your executor cannot make HTTP requests."
    end

    local ok, response = pcall(function()
        return httpRequest({
            Url = KEY_SERVER .. "/api/script",
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({
                key = key,
                hwid = getHWID(),
                hub = HUB,
            }),
        })
    end)

    if not ok or not response then
        return false, "Could not reach the key server. Check your connection."
    end

    local status = response.StatusCode or response.status_code or 0
    local body = response.Body or ""

    if status == 200 then
        if body == "" then
            return false, "The server returned an empty script."
        end
        return true, body
    end

    local message = "Key rejected."
    pcall(function()
        local decoded = HttpService:JSONDecode(body)
        if decoded and decoded.error then message = decoded.error end
    end)
    return false, message
end

local function runHub(source)
    local chunk, compileErr = loadstring(source)
    if not chunk then
        fail("Script error", tostring(compileErr))
    end
    return chunk()
end

if key ~= nil and type(key) == "string" and key ~= "" then
    local ok, result = requestHub(key)
    if ok then
        saveKey(key)
        print("[ALX HUB] Key accepted. Loading " .. HUB_NAME .. "...")
        return runHub(result)
    end
    fail("Key rejected", result)
end

local parentGui = nil
pcall(function()
    if gethui then parentGui = gethui() end
end)
if not parentGui then
    local ok, core = pcall(function() return game:GetService("CoreGui") end)
    parentGui = ok and core or LocalPlayer:WaitForChild("PlayerGui")
end

pcall(function()
    local old = parentGui:FindFirstChild("ALXHubKeyPrompt")
    if old then old:Destroy() end
end)

local function make(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    if parent then inst.Parent = parent end
    return inst
end

local COLORS = {
    bg = Color3.fromRGB(0, 0, 0),
    card = Color3.fromRGB(24, 24, 26),
    cardTop = Color3.fromRGB(24, 24, 26),
    field = Color3.fromRGB(43, 43, 47),
    border = Color3.fromRGB(255, 255, 255),
    borderFocus = Color3.fromRGB(255, 255, 255),
    text = Color3.fromRGB(245, 245, 247),
    sub = Color3.fromRGB(152, 152, 158),
    dim = Color3.fromRGB(126, 126, 132),
    faint = Color3.fromRGB(92, 92, 98),
    accent = Color3.fromRGB(255, 255, 255),
    accentGlow = Color3.fromRGB(228, 228, 232),
    submit = Color3.fromRGB(97, 101, 118),
    submitHover = Color3.fromRGB(112, 117, 136),
    success = Color3.fromRGB(255, 255, 255),
    danger = Color3.fromRGB(228, 96, 96),
    white = Color3.fromRGB(255, 255, 255),
    ink = Color3.fromRGB(16, 16, 18),
    discord = Color3.fromRGB(43, 43, 47),
}

local SUBMIT_LABEL = "\u{2192}  Submit"

local function makeKeyIcon(parent, x, y, tint)
    local holder = make("Frame", {
        Position = UDim2.fromOffset(x, y),
        Size = UDim2.fromOffset(20, 16),
        BackgroundTransparency = 1,
    }, parent)
    local ring = make("Frame", {
        Position = UDim2.fromOffset(0, 3),
        Size = UDim2.fromOffset(11, 11),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, holder)
    make("UICorner", { CornerRadius = UDim.new(1, 0) }, ring)
    make("UIStroke", { Color = tint, Thickness = 2 }, ring)
    make("Frame", {
        Position = UDim2.fromOffset(10, 7.5),
        Size = UDim2.fromOffset(10, 2),
        BackgroundColor3 = tint,
        BorderSizePixel = 0,
    }, holder)
    make("Frame", {
        Position = UDim2.fromOffset(15, 9.5),
        Size = UDim2.fromOffset(2, 4),
        BackgroundColor3 = tint,
        BorderSizePixel = 0,
    }, holder)
    make("Frame", {
        Position = UDim2.fromOffset(18, 9.5),
        Size = UDim2.fromOffset(2, 3),
        BackgroundColor3 = tint,
        BorderSizePixel = 0,
    }, holder)
    return holder
end

local function makeChevron(parent, tint)
    local holder = make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(12, 12),
        BackgroundTransparency = 1,
    }, parent)
    local left = make("Frame", {
        Position = UDim2.fromOffset(1, 5),
        Size = UDim2.fromOffset(7, 1.8),
        BackgroundColor3 = tint,
        BorderSizePixel = 0,
        Rotation = 45,
    }, holder)
    local right = make("Frame", {
        Position = UDim2.fromOffset(5, 5),
        Size = UDim2.fromOffset(7, 1.8),
        BackgroundColor3 = tint,
        BorderSizePixel = 0,
        Rotation = -45,
    }, holder)
    return holder, left, right
end

local screenGui = make("ScreenGui", {
    Name = "ALXHubKeyPrompt",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, parentGui)

local backdrop = make("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = COLORS.bg,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
}, screenGui)

local hasDiscord = DISCORD ~= ""

local CARD_W = 424
local PAD = 22
local ROW_Y = 168
local CARD_H = 226
local PANEL_H = hasDiscord and 92 or 66

local card = make("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(CARD_W, CARD_H),
    BackgroundColor3 = COLORS.card,
    BorderSizePixel = 0,
    BackgroundTransparency = 1,
    ClipsDescendants = true,
}, screenGui)
make("UICorner", { CornerRadius = UDim.new(0, 16) }, card)
local cardStroke = make("UIStroke", { Color = COLORS.border, Thickness = 1, Transparency = 1 }, card)

local header = make("Frame", {
    Size = UDim2.new(1, 0, 0, 68),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
}, card)

make("TextLabel", {
    Position = UDim2.fromOffset(PAD, 19),
    Size = UDim2.new(1, -PAD * 2, 0, 21),
    BackgroundTransparency = 1,
    Text = HUB_NAME,
    TextColor3 = COLORS.text,
    Font = Enum.Font.GothamBold,
    TextSize = 17,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
}, card)

make("TextLabel", {
    Position = UDim2.fromOffset(PAD, 44),
    Size = UDim2.new(1, -PAD * 2, 0, 18),
    BackgroundTransparency = 1,
    Text = "Enter your key to continue.",
    TextColor3 = COLORS.sub,
    Font = Enum.Font.Gotham,
    TextSize = 13.5,
    TextXAlignment = Enum.TextXAlignment.Left,
}, card)

local field = make("Frame", {
    Position = UDim2.fromOffset(PAD, 76),
    Size = UDim2.new(1, -PAD * 2, 0, 44),
    BackgroundColor3 = COLORS.field,
    BorderSizePixel = 0,
}, card)
make("UICorner", { CornerRadius = UDim.new(0, 10) }, field)
local fieldStroke = make("UIStroke", { Color = COLORS.border, Thickness = 1, Transparency = 0.9 }, field)

makeKeyIcon(field, 14, 15, COLORS.dim)

local input = make("TextBox", {
    Position = UDim2.fromOffset(40, 0),
    Size = UDim2.new(1, -54, 1, 0),
    BackgroundTransparency = 1,
    Text = "",
    PlaceholderText = "Enter Key",
    PlaceholderColor3 = COLORS.faint,
    TextColor3 = COLORS.text,
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
    ClipsDescendants = true,
}, field)

local status = make("TextLabel", {
    Position = UDim2.fromOffset(PAD, 126),
    Size = UDim2.new(1, -PAD * 2, 0, 34),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = COLORS.sub,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
    Visible = false,
}, card)

local function ghostButton(x, w, label, parent)
    local btn = make("TextButton", {
        Position = UDim2.fromOffset(x, ROW_Y),
        Size = UDim2.fromOffset(w, 38),
        BackgroundColor3 = COLORS.field,
        BorderSizePixel = 0,
        Text = label,
        TextColor3 = COLORS.text,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        AutoButtonColor = false,
    }, parent)
    make("UICorner", { CornerRadius = UDim.new(0, 9) }, btn)
    make("UIStroke", { Color = COLORS.border, Thickness = 1, Transparency = 0.88 }, btn)
    return btn
end

local closeBtn = ghostButton(PAD, 86, "\u{00D7}  Exit", card)

local getKeyBtn = ghostButton(PAD + 94, 106, "     Get key", card)
makeKeyIcon(getKeyBtn, 14, 12, COLORS.text)

local dropBtn = ghostButton(PAD + 202, 36, "", card)
local _, chevL, chevR = makeChevron(dropBtn, COLORS.text)

local verifyBtn = make("TextButton", {
    Position = UDim2.fromOffset(CARD_W - PAD - 122, ROW_Y),
    Size = UDim2.fromOffset(122, 38),
    BackgroundColor3 = COLORS.submit,
    BorderSizePixel = 0,
    Text = SUBMIT_LABEL,
    TextColor3 = COLORS.white,
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    AutoButtonColor = false,
}, card)
make("UICorner", { CornerRadius = UDim.new(0, 9) }, verifyBtn)

local panel = make("Frame", {
    Position = UDim2.fromOffset(PAD, ROW_Y + 48),
    Size = UDim2.new(1, -PAD * 2, 0, PANEL_H - 12),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
}, card)

make("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = COLORS.border,
    BackgroundTransparency = 0.9,
    BorderSizePixel = 0,
}, panel)

make("TextLabel", {
    Position = UDim2.fromOffset(0, 12),
    Size = UDim2.new(1, 0, 0, 13),
    BackgroundTransparency = 1,
    Text = "OPEN THIS IN YOUR BROWSER",
    TextColor3 = COLORS.faint,
    Font = Enum.Font.Code,
    TextSize = 9.5,
    TextXAlignment = Enum.TextXAlignment.Left,
}, panel)

make("TextLabel", {
    Position = UDim2.fromOffset(0, 28),
    Size = UDim2.new(1, 0, 0, 18),
    BackgroundTransparency = 1,
    Text = HOST_LABEL,
    TextColor3 = COLORS.text,
    Font = Enum.Font.Code,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
}, panel)

local discordBtn
if hasDiscord then
    discordBtn = make("TextButton", {
        Position = UDim2.fromOffset(0, 52),
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = COLORS.discord,
        BorderSizePixel = 0,
        Text = "Join Discord",
        TextColor3 = COLORS.dim,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        AutoButtonColor = false,
    }, panel)
    make("UICorner", { CornerRadius = UDim.new(0, 8) }, discordBtn)
    make("UIStroke", { Color = COLORS.border, Thickness = 1, Transparency = 0.9 }, discordBtn)
end

local panelOpen = false
dropBtn.MouseButton1Click:Connect(function()
    panelOpen = not panelOpen
    chevL.Rotation = panelOpen and -45 or 45
    chevR.Rotation = panelOpen and 45 or -45
    local target = panelOpen and (CARD_H + PANEL_H) or CARD_H
    local ok = pcall(function()
        TweenService:Create(card, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(CARD_W, target),
        }):Play()
    end)
    if not ok then card.Size = UDim2.fromOffset(CARD_W, target) end
end)

local function setStatus(text, colour)
    status.Text = text
    status.TextColor3 = colour or COLORS.sub
    status.Visible = text ~= ""
end

local function tween(inst, props, time)
    local ok = pcall(function()
        TweenService:Create(inst, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
    end)
    if not ok then
        for k, v in pairs(props) do inst[k] = v end
    end
end

beacon("prompt_shown")

tween(backdrop, { BackgroundTransparency = 0.45 }, 0.3)
tween(card, { BackgroundTransparency = 0 }, 0.3)
tween(cardStroke, { Transparency = 0.82 }, 0.35)

closeBtn.MouseEnter:Connect(function() closeBtn.TextColor3 = COLORS.danger end)
closeBtn.MouseLeave:Connect(function() closeBtn.TextColor3 = COLORS.text end)
getKeyBtn.MouseEnter:Connect(function() getKeyBtn.TextColor3 = COLORS.text end)
getKeyBtn.MouseLeave:Connect(function() getKeyBtn.TextColor3 = COLORS.text end)
verifyBtn.MouseEnter:Connect(function() tween(verifyBtn, { BackgroundColor3 = COLORS.submitHover }, 0.15) end)
verifyBtn.MouseLeave:Connect(function() tween(verifyBtn, { BackgroundColor3 = COLORS.submit }, 0.15) end)
input.Focused:Connect(function() tween(fieldStroke, { Transparency = 0.35 }, 0.15) end)
input.FocusLost:Connect(function() tween(fieldStroke, { Transparency = 0.86 }, 0.15) end)

do
    local dragging, dragStart, startPos = false, nil, nil
    header.InputBegan:Connect(function(inputObj)
        if inputObj.UserInputType == Enum.UserInputType.MouseButton1
            or inputObj.UserInputType == Enum.UserInputType.Touch then
            dragging, dragStart, startPos = true, inputObj.Position, card.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(inputObj)
        if not dragging then return end
        if inputObj.UserInputType == Enum.UserInputType.MouseMovement
            or inputObj.UserInputType == Enum.UserInputType.Touch then
            local delta = inputObj.Position - dragStart
            card.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(inputObj)
        if inputObj.UserInputType == Enum.UserInputType.MouseButton1
            or inputObj.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

getKeyBtn.MouseButton1Click:Connect(function()
    beacon("getkey_clicked")
    local url = KEY_SERVER .. "/"
    if copyToClipboard(url) then
        beacon("clipboard_ok")
        setStatus("Key link copied.", COLORS.text)
    else
        beacon("clipboard_failed")
        setStatus("Could not copy. Type the address shown above into your browser.", COLORS.text)
    end
    notify("ALX HUB", "Open " .. HOST_LABEL .. " in your browser to get a key.")
end)

if hasDiscord then
    discordBtn.MouseButton1Click:Connect(function()
        if copyToClipboard(DISCORD) then
            setStatus("Discord invite copied.", COLORS.sub)
        else
            setStatus("Join us at " .. DISCORD, COLORS.dim)
        end
    end)

    discordBtn.MouseEnter:Connect(function()
        discordBtn.TextColor3 = COLORS.text
    end)
    discordBtn.MouseLeave:Connect(function()
        discordBtn.TextColor3 = COLORS.dim
    end)
end

local closed = false
local finished = false

local function shutdown()
    if closed then return end
    closed = true
    tween(backdrop, { BackgroundTransparency = 1 }, 0.15)
    tween(card, { BackgroundTransparency = 1 }, 0.15)
    task.delay(0.2, function()
        pcall(function() screenGui:Destroy() end)
    end)
end

closeBtn.MouseButton1Click:Connect(function()
    if not finished then beacon("closed") end
    shutdown()
    notify("ALX HUB", "Cancelled. Run the script again when you have a key.")
end)

local checking = false
local hubSource = nil

local function attempt()
    if checking or finished then return end

    local candidate = input.Text:gsub("%s+", "")
    if candidate == "" then
        setStatus("Paste your key first.", COLORS.danger)
        return
    end

    if candidate:find("loadstring") or candidate:find("HttpGet") or candidate:find("http") then
        setStatus("That is the script, not the key. Paste only the key, which looks like AC-XXXXXXXX-XXXXXXXX-XXXXXXXX.", COLORS.danger)
        return
    end
    if not candidate:match("^AC%-%x+%-%x+%-%x+$") then
        setStatus("That does not look like a key. It should look like AC-XXXXXXXX-XXXXXXXX-XXXXXXXX.", COLORS.danger)
        return
    end

    checking = true
    verifyBtn.Text = "..."
    verifyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    verifyBtn.TextColor3 = COLORS.sub
    setStatus("Checking...", COLORS.sub)

    task.spawn(function()
        local ok, result = requestHub(candidate)

        if ok then
            finished = true
            hubSource = result
            saveKey(candidate)
            setStatus("✓ Loading...", COLORS.success)
            verifyBtn.Text = "✓"
            verifyBtn.BackgroundColor3 = COLORS.success
            verifyBtn.TextColor3 = COLORS.ink
            task.wait(0.5)
            shutdown()
            return
        end

        beacon("verify_failed")
        if readSavedKey() == candidate then clearSavedKey() end

        checking = false
        verifyBtn.Text = SUBMIT_LABEL
        verifyBtn.BackgroundColor3 = COLORS.submit
        verifyBtn.TextColor3 = COLORS.white
        setStatus(hasDiscord and (result .. " Need help? Join Discord below.") or result, COLORS.danger)
    end)
end

verifyBtn.MouseButton1Click:Connect(attempt)
input.FocusLost:Connect(function(enterPressed)
    if enterPressed then attempt() end
end)

do
    local saved = readSavedKey()
    if saved then
        beacon("saved_key_auto")
        input.Text = saved
        setStatus("Found a saved key, checking it...", COLORS.dim)
        task.spawn(function()
            task.wait(0.35)
            attempt()
        end)
    end
end

while not finished and not closed do
    task.wait(0.1)
end

if not finished then
    return
end

print("[ALX HUB] Loading " .. HUB_NAME .. "...")
return runHub(hubSource)
