local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local LOADER_ID = "kingslegacy"
local LOADER_VERSION = "1.0.0"
local CLIENT_VERSION = "2026.04.22"

local function trim(value)
    return tostring(value or ""):match("^%s*(.-)%s*$")
end

local function formatProjectMessage(message)
    local formatted = trim(message)
    if formatted == "" then
        formatted = "Unknown error."
    end

    formatted = formatted:gsub("[Ff]ingerprint", "HWID")
    if formatted:sub(1, 9) ~= "[PROJECT]" then
        formatted = "[PROJECT] " .. formatted
    end

    return formatted
end

local function getGlobalScriptKey()
    return rawget(getgenv(), "script_key")
        or rawget(_G, "script_key")
        or rawget(getgenv(), "ProjectScriptKey")
        or rawget(_G, "ProjectScriptKey")
end

local function setGlobalScriptKey(value)
    local normalized = trim(value)
    getgenv().script_key = normalized
    getgenv().ProjectScriptKey = normalized
    _G.script_key = normalized
    _G.ProjectScriptKey = normalized
    return normalized
end

local function resolvePromptParent()
    local ok, coreGui = pcall(function()
        return game:GetService("CoreGui")
    end)
    if ok and coreGui then
        return coreGui
    end

    return LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui") or nil
end

local function uiCreate(className, props, parent)
    local instance = Instance.new(className)
    for key, value in pairs(props or {}) do
        instance[key] = value
    end
    instance.Parent = parent
    return instance
end

local function promptForScriptKey()
    local parent = resolvePromptParent()
    if not parent then
        return ""
    end

    local existing = parent:FindFirstChild("ProjectKeyPrompt")
    if existing then
        existing:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ProjectKeyPrompt"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 2000

    local palette = {
        overlay = Color3.fromRGB(6, 6, 8),
        panel = Color3.fromRGB(18, 18, 22),
        panelAlt = Color3.fromRGB(28, 28, 34),
        panelSoft = Color3.fromRGB(52, 52, 60),
        accent = Color3.fromRGB(86, 39, 255),
        accentSoft = Color3.fromRGB(124, 92, 255),
        text = Color3.fromRGB(240, 240, 245),
        subtext = Color3.fromRGB(170, 170, 180),
        warning = Color3.fromRGB(255, 116, 116),
        success = Color3.fromRGB(124, 255, 151),
        pending = Color3.fromRGB(255, 214, 120),
        disabled = Color3.fromRGB(110, 110, 118),
    }
    local DISCORD_INVITE_CODE = "RTAzWS7nx4"
    local DISCORD_INVITE_URL = "https://discord.gg/" .. DISCORD_INVITE_CODE
    local DISCORD_LOCAL_PORT = 6463

    local backdrop = uiCreate("Frame", {
        Name = "Backdrop",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = palette.overlay,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, screenGui)

    local panel = uiCreate("Frame", {
        Name = "Panel",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(420, 320),
        BackgroundColor3 = palette.panel,
        BorderSizePixel = 0,
    }, backdrop)
    uiCreate("UICorner", {CornerRadius = UDim.new(0, 22)}, panel)
    uiCreate("UIStroke", {
        Color = palette.accent,
        Transparency = 0.35,
        Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, panel)

    local logo = uiCreate("ImageLabel", {
        Name = "Logo",
        Position = UDim2.new(0.5, -110, 0, 16),
        Size = UDim2.fromOffset(220, 48),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Image = "http://www.roblox.com/asset/?id=109806584615988",
        ScaleType = Enum.ScaleType.Stretch,
    }, panel)
    uiCreate("UICorner", {CornerRadius = UDim.new(0, 12)}, logo)

    local input = uiCreate("TextBox", {
        Name = "Input",
        Position = UDim2.fromOffset(16, 84),
        Size = UDim2.new(1, -32, 0, 48),
        BackgroundColor3 = palette.panelAlt,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Font = Enum.Font.Code,
        PlaceholderText = "ENTER LICENSE KEY",
        Text = "",
        TextColor3 = palette.text,
        PlaceholderColor3 = palette.subtext,
        TextSize = 18,
    }, panel)
    uiCreate("UICorner", {CornerRadius = UDim.new(0, 14)}, input)
    local inputStroke = uiCreate("UIStroke", {
        Color = palette.panelSoft,
        Thickness = 1,
        Transparency = 0,
    }, input)
    uiCreate("UIPadding", {
        PaddingLeft = UDim.new(0, 16),
        PaddingRight = UDim.new(0, 16),
    }, input)

    local status = uiCreate("TextLabel", {
        Name = "Status",
        Position = UDim2.fromOffset(16, 142),
        Size = UDim2.new(1, -32, 0, 28),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = "Paste license key. Bootstrap stores value in getgenv().script_key.",
        TextColor3 = palette.pending,
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
    }, panel)

    local unlockButton = uiCreate("TextButton", {
        Name = "UnlockButton",
        Position = UDim2.fromOffset(16, 184),
        Size = UDim2.new(1, -32, 0, 42),
        BackgroundColor3 = palette.accent,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = "Unlock Hub",
        TextColor3 = palette.text,
        TextSize = 13,
    }, panel)
    uiCreate("UICorner", {CornerRadius = UDim.new(0, 14)}, unlockButton)

    local buttonRow = uiCreate("Frame", {
        Name = "ButtonRow",
        Position = UDim2.fromOffset(16, 234),
        Size = UDim2.new(1, -32, 0, 42),
        BackgroundTransparency = 1,
    }, panel)

    local discordButton = uiCreate("TextButton", {
        Name = "DiscordButton",
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0.48, 0, 0, 42),
        BackgroundColor3 = palette.panelSoft,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = "Discord",
        TextColor3 = palette.text,
        TextSize = 13,
    }, buttonRow)
    uiCreate("UICorner", {CornerRadius = UDim.new(0, 14)}, discordButton)
    uiCreate("UIStroke", {
        Color = palette.accentSoft,
        Thickness = 1,
        Transparency = 0.25,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, discordButton)

    local getKeyButton = uiCreate("TextButton", {
        Name = "GetKeyButton",
        Position = UDim2.new(0.52, 0, 0, 0),
        Size = UDim2.new(0.48, 0, 0, 42),
        BackgroundColor3 = palette.panelSoft,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = "Get Key",
        TextColor3 = palette.text,
        TextSize = 13,
    }, buttonRow)
    uiCreate("UICorner", {CornerRadius = UDim.new(0, 14)}, getKeyButton)
    uiCreate("UIStroke", {
        Color = palette.accentSoft,
        Thickness = 1,
        Transparency = 0.25,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, getKeyButton)

    local resetSession = uiCreate("TextButton", {
        Name = "ResetSession",
        Position = UDim2.fromOffset(110, 278),
        Size = UDim2.fromOffset(200, 16),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Font = Enum.Font.Gotham,
        Text = "Reset Session",
        TextColor3 = palette.subtext,
        TextSize = 12,
    }, panel)

    local submitted = false
    local busy = false
    local inviteAttempted = false
    local value = ""

    local function getDiscordInviteUrl()
        return DISCORD_INVITE_URL
    end

    local function openDiscordInviteViaLocalPort()
        local requestFn = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
        if type(requestFn) ~= "function" then
            return false, "request unavailable"
        end

        local payload = HttpService:JSONEncode({
            cmd = "INVITE_BROWSER",
            nonce = HttpService:GenerateGUID(false),
            args = {
                code = DISCORD_INVITE_CODE,
            },
        })

        for port = DISCORD_LOCAL_PORT, 6472 do
            local ok, response = pcall(function()
                return requestFn({
                    Url = "http://127.0.0.1:" .. tostring(port) .. "/rpc?v=1",
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json",
                        ["Origin"] = "https://discord.com",
                    },
                    Body = payload,
                })
            end)

            if ok and response and tonumber(response.StatusCode) == 200 then
                return true, tostring(port)
            end
        end

        return false, "discord rpc unavailable"
    end

    local function setStatus(message, tone)
        status.Text = message
        if tone == "error" then
            status.TextColor3 = palette.warning
            inputStroke.Color = palette.warning
        elseif tone == "success" then
            status.TextColor3 = palette.success
            inputStroke.Color = palette.accentSoft
        elseif tone == "pending" then
            status.TextColor3 = palette.pending
            inputStroke.Color = palette.accentSoft
        else
            status.TextColor3 = palette.subtext
            inputStroke.Color = palette.panelSoft
        end
    end

    local function setBusy(nextBusy)
        busy = nextBusy
        input.TextEditable = not nextBusy
        unlockButton.AutoButtonColor = not nextBusy
        discordButton.AutoButtonColor = not nextBusy
        getKeyButton.AutoButtonColor = not nextBusy
        resetSession.AutoButtonColor = not nextBusy
        if nextBusy then
            unlockButton.BackgroundColor3 = palette.accentSoft
            discordButton.BackgroundColor3 = palette.panelAlt
            getKeyButton.BackgroundColor3 = palette.panelAlt
            unlockButton.Text = "Unlocking..."
        else
            unlockButton.BackgroundColor3 = palette.accent
            discordButton.BackgroundColor3 = palette.panelSoft
            getKeyButton.BackgroundColor3 = palette.panelSoft
            unlockButton.Text = "Unlock Hub"
        end
    end

    local function handleDiscordInvite()
        if busy then
            return
        end

        inviteAttempted = true
        local opened, openInfo = openDiscordInviteViaLocalPort()

        if opened then
            setStatus("Discord invite opened and link copied.", "success")
        else
            setStatus("Discord invite failed. Copy manually: " .. getDiscordInviteUrl(), "error")
        end

        return opened, openInfo
    end

    local function copyTextValue(text)
        local copyFn = type(setclipboard) == "function" and setclipboard or (type(toclipboard) == "function" and toclipboard or nil)
        if not copyFn then
            return false
        end

        return pcall(copyFn, text)
    end

    local function openBrowserUrl(targetUrl)
        local requestFn = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
        if type(requestFn) ~= "function" then
            return false
        end

        local payload = HttpService:JSONEncode({
            cmd = "BROWSER_OPEN",
            nonce = HttpService:GenerateGUID(false),
            args = {
                url = targetUrl,
            },
        })

        for port = DISCORD_LOCAL_PORT, 6472 do
            local ok, response = pcall(function()
                return requestFn({
                    Url = "http://127.0.0.1:" .. tostring(port) .. "/rpc?v=1",
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json",
                        ["Origin"] = "https://discord.com",
                    },
                    Body = payload,
                })
            end)

            if ok and response and tonumber(response.StatusCode) == 200 then
                return true
            end
        end

        return false
    end

    local function handleGetKey()
        if busy then
            return
        end

        local targetUrl = "https://projecthub.projectoficial.com"
        local opened = openBrowserUrl(targetUrl)
        local copied = copyTextValue(targetUrl)
        if opened and copied then
            setStatus("Get Key opened and portal link copied.", "success")
        elseif opened then
            setStatus("Get Key portal opened.", "success")
        elseif copied then
            setStatus("Get Key link copied: " .. targetUrl, "pending")
        else
            setStatus("Open Get Key manually: " .. targetUrl, "error")
        end
    end

    local function resetSessionState()
        if busy then
            return
        end

        value = ""
        input.Text = ""
        getgenv().script_key = nil
        getgenv().ProjectScriptKey = nil
        _G.script_key = nil
        _G.ProjectScriptKey = nil
        setStatus("Session reset. Paste a new key to continue.", "pending")
        task.defer(function()
            if input and input.Parent then
                input:CaptureFocus()
            end
        end)
    end

    local function finish(candidate)
        if busy then
            return
        end

        value = trim(candidate)
        if value == "" then
            setStatus("License key required before bootstrap can continue.", "error")
            return
        end

        setBusy(true)
        setStatus("Key stored in script_key. Continuing host bootstrap...", "success")
        task.wait(0.12)
        submitted = true
    end

    unlockButton.MouseButton1Click:Connect(function()
        finish(input.Text)
    end)
    unlockButton.Activated:Connect(function()
        finish(input.Text)
    end)
    discordButton.MouseButton1Click:Connect(function()
        handleDiscordInvite()
    end)
    discordButton.Activated:Connect(function()
        handleDiscordInvite()
    end)
    getKeyButton.MouseButton1Click:Connect(function()
        handleGetKey()
    end)
    getKeyButton.Activated:Connect(function()
        handleGetKey()
    end)
    resetSession.MouseButton1Click:Connect(function()
        resetSessionState()
    end)
    resetSession.Activated:Connect(function()
        resetSessionState()
    end)
    input.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            finish(input.Text)
        end
    end)

    screenGui.Parent = parent
    input:CaptureFocus()
    setStatus("Insert your license key to store it in script_key.", "pending")
    if not inviteAttempted then
        task.spawn(function()
            task.wait(0.05)
            if screenGui.Parent and not submitted then
                handleDiscordInvite()
            end
        end)
    end

    while not submitted do
        task.wait(0.1)
        if not screenGui.Parent then
            break
        end
    end

    screenGui:Destroy()
    return value
end

local scriptKey = trim(getGlobalScriptKey())
if scriptKey == "" then
    scriptKey = promptForScriptKey()
    if scriptKey ~= "" then
        scriptKey = setGlobalScriptKey(scriptKey)
    end
end

if scriptKey == "" then
    warn(formatProjectMessage("License key required. Set getgenv().script_key before loadstring if prompt does not open."))
    return
end

local function uuid4()
    local ok, guid = pcall(function()
        return HttpService:GenerateGUID(false)
    end)
    if ok and type(guid) == "string" then
        return guid:lower()
    end
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    return (template:gsub("[xy]", function(c)
        local v = (c == "x") and math.random(0, 15) or math.random(8, 11)
        return string.format("%x", v)
    end))
end

local function getExecutorName()
    if type(identifyexecutor) == "function" then
        local ok, name = pcall(identifyexecutor)
        if ok and type(name) == "string" and name ~= "" then
            return name
        end
    end
    return "unknown"
end

local function getExecutorFingerprint()
    local resolvers = {
        function() return type(gethwid) == "function" and gethwid() or nil end,
        function() return type(get_hwid) == "function" and get_hwid() or nil end,
    }
    for _, resolver in ipairs(resolvers) do
        local ok, value = pcall(resolver)
        if ok and type(value) == "string" and value ~= "" then
            return value
        end
    end
    return tostring(LocalPlayer and LocalPlayer.UserId or "0") .. ":" .. getExecutorName()
end

local function getHttpRequest()
    return request or (syn and syn.request) or http_request or (fluxus and fluxus.request)
end

local function getApiBase()
    local override = rawget(getgenv(), "ProjectAuthApiBase")
    if type(override) == "string" and trim(override) ~= "" then
        return trim(override)
    end
    return "https://panel.projectoficial.com"
end

local function apiUrl(path)
    local base = getApiBase()
    if base:find("__path=", 1, true) then
        return base .. path
    end
    return base:gsub("/+$", "") .. path
end

if type(rawget(getgenv(), "ProjectAuthApiBase")) ~= "string" or trim(rawget(getgenv(), "ProjectAuthApiBase")) == "" then
    getgenv().ProjectAuthApiBase = "https://panel.projectoficial.com"
end
if type(rawget(getgenv(), "ProjectPublicLoaderUrl")) ~= "string" or trim(rawget(getgenv(), "ProjectPublicLoaderUrl")) == "" then
    getgenv().ProjectPublicLoaderUrl = "https://files.projectoficial.com/kingslegacy"
end
if type(rawget(getgenv(), "ProjectResolvedLoaderUrl")) ~= "string" or trim(rawget(getgenv(), "ProjectResolvedLoaderUrl")) == "" then
    getgenv().ProjectResolvedLoaderUrl = "https://files.projectoficial.com/kingslegacy"
end
if type(rawget(getgenv(), "ProjectLoaderPublicBase")) ~= "string" or trim(rawget(getgenv(), "ProjectLoaderPublicBase")) == "" then
    getgenv().ProjectLoaderPublicBase = "https://files.projectoficial.com/kingslegacy"
end

local httpRequest = getHttpRequest()
assert(httpRequest, "Executor sem request/http_request")

local executorName = getExecutorName()
local fingerprint = {
    roblox_user_id = LocalPlayer and LocalPlayer.UserId or 0,
    executor_name = executorName,
    executor_fingerprint = getExecutorFingerprint(),
    loader_version = LOADER_VERSION,
    client_version = CLIENT_VERSION,
}
local context = {
    platform = "roblox",
    script_variant = "bootstrap",
    channel = "stable",
}

-- Step 1: Activate
local activateBody = {
    license_key = scriptKey,
    fingerprint = fingerprint,
    context = context,
}

local activateResponse = httpRequest({
    Url = apiUrl("/v1/auth/activate"),
    Method = "POST",
    Headers = {["Content-Type"] = "application/json", ["Accept"] = "application/json"},
    Body = HttpService:JSONEncode(activateBody),
})

local activateData = HttpService:JSONDecode(activateResponse and (activateResponse.Body or activateResponse.body) or "{}")
if not activateData.ok then
    local authMessage = formatProjectMessage(tostring(activateData.message or "Unknown error"))
    if LocalPlayer then
        LocalPlayer:Kick(authMessage)
    else
        warn(authMessage)
    end
    return
end

local session = activateData.data.session
local nextNonce = activateData.data.next_nonce

-- Step 2: Load Source
local loaderBody = {
    access_token = session.access_token,
    nonce = nextNonce,
    request_id = uuid4(),
    timestamp = os.time(),
    loader_id = LOADER_ID,
    module = "host",
    fingerprint = fingerprint,
    context = context,
}

local response = httpRequest({
    Url = apiUrl("/v1/loader/source"),
    Method = "POST",
    Headers = {["Content-Type"] = "application/json", ["Accept"] = "text/plain"},
    Body = HttpService:JSONEncode(loaderBody),
})
local source = response and (response.Body or response.body)
assert(type(source) == "string" and source ~= "", "Loader source empty")
loadstring(source, "=" .. tostring(LOADER_ID) .. "_host")()