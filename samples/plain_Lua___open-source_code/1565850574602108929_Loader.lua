--[[
    ═══════════════════════════════════════════════════════════════════════════
    [ XYZ SCRIPTS • UNIVERSAL LOADER FOR BLOXSTRIKE ]
    All Key Tiers Supported: Promo, Lifetime, Premium, Daily (2h/6h/10h)
    ═══════════════════════════════════════════════════════════════════════════
]]
local TARGET_SCRIPT_NAME = "BloxStrike"
local TARGET_GET_URL = "https://xyzscripts-platform.pages.dev/api/" .. game:GetService("HttpService"):UrlEncode(TARGET_SCRIPT_NAME) .. "/get.lua"

_G.XYZ_TARGET_SCRIPT_NAME = TARGET_SCRIPT_NAME
_G.XYZ_TARGET_SCRIPT_URL  = TARGET_GET_URL

if getgenv then
    getgenv().XYZ_TARGET_SCRIPT_NAME = TARGET_SCRIPT_NAME
    getgenv().XYZ_TARGET_SCRIPT_URL  = TARGET_GET_URL
end

-- Universal Key System Loader Code

local Shared = {
    HideName     = false,
    SaveKey      = true,
    Language     = "en",
    Theme        = "Dark",
    KeyFile      = "xyz_key.txt",
    SettingsFile = "xyz_settings.json",
    CurrentKey   = nil,
}

do
    local HS = game:GetService("HttpService")

    if isfile and readfile and isfile(Shared.SettingsFile) then
        pcall(function()
            local d = HS:JSONDecode(readfile(Shared.SettingsFile))
            if type(d) == "table" then
                if type(d.HideName) == "boolean" then Shared.HideName = d.HideName end
                if type(d.SaveKey) == "boolean" then Shared.SaveKey = d.SaveKey end
                if type(d.Language) == "string" then Shared.Language = d.Language end
                if type(d.Theme) == "string" then Shared.Theme = d.Theme end
            end
        end)
    end

    function Shared.Save()
        if writefile then
            pcall(function()
                writefile(Shared.SettingsFile, HS:JSONEncode({
                    HideName = Shared.HideName,
                    SaveKey  = Shared.SaveKey,
                    Language = Shared.Language,
                    Theme    = Shared.Theme,
                }))
            end)
        end
    end

    function Shared.WriteKey()
        if writefile and Shared.CurrentKey and #Shared.CurrentKey > 4 then
            pcall(function() writefile(Shared.KeyFile, Shared.CurrentKey) end)
        end
    end

    function Shared.ClearKey()
        if delfile and isfile and isfile(Shared.KeyFile) then
            pcall(function() delfile(Shared.KeyFile) end)
        end
    end

    local scrambleChars, bindings, started = {}, {}, false
    local function rnd() return utf8.char(math.random(0x4E00, 0x9FA5)) end

    function Shared.DisplayName(name)
        if not Shared.HideName then return name end
        local t = {}
        for i = 1, #name do
            scrambleChars[i] = scrambleChars[i] or rnd()
            t[i] = scrambleChars[i]
        end
        return table.concat(t)
    end

    local function ensureTicker()
        if started then return end
        started = true
        task.spawn(function()
            while true do
                task.wait(0.07)
                if Shared.HideName then
                    for i = 1, 24 do
                        if scrambleChars[i] == nil or math.random() < 0.45 then
                            scrambleChars[i] = rnd()
                        end
                    end
                end
                for i = #bindings, 1, -1 do
                    local b = bindings[i]
                    if not b.label.Parent then
                        table.remove(bindings, i)
                    else
                        local s = Shared.DisplayName(b.name)
                        if b.fmt then s = b.fmt(s) end
                        if b.label.Text ~= s then b.label.Text = s end
                    end
                end
                if #bindings == 0 then
                    started = false
                    break
                end
            end
        end)
    end

    function Shared.BindName(label, name, fmt)
        table.insert(bindings, {label = label, name = name, fmt = fmt})
        local s = Shared.DisplayName(name)
        label.Text = fmt and fmt(s) or s
        ensureTicker()
    end
end

local Config
Config = {
    Title           = "Key System",
    LoaderName      = "XYZ Scripts",
    ScriptName      = (typeof(TARGET_SCRIPT_NAME) == "string" and TARGET_SCRIPT_NAME ~= "" and TARGET_SCRIPT_NAME) or _G.XYZ_TARGET_SCRIPT_NAME or (getgenv and getgenv().XYZ_TARGET_SCRIPT_NAME) or "",
    ServerUrl       = "https://xyzscripts-platform.pages.dev",
    BackupUrl       = "http://localhost:3000",
    SaveFile        = Shared.KeyFile,
    TargetScriptUrl = (typeof(TARGET_GET_URL) == "string" and TARGET_GET_URL ~= "" and TARGET_GET_URL) or _G.XYZ_TARGET_SCRIPT_URL or (getgenv and getgenv().XYZ_TARGET_SCRIPT_URL) or "",
    AutoLogin       = true,
    LoaderSteps     = {
        { "Loading Assets...",       25 },
        { "Fetching Modules...",     50 },
        { "Checking Version...",     75 },
        { "Preparing Interface...",  95 },
        { "Done!",                  100 },
    },
    UnloadSteps = {
        { "Unloading Assets...",     75 },
        { "Clearing Modules...",     50 },
        { "Saving Settings...",      25 },
        { "Cleaning Up...",           0 },
    },
    GoodbyeText = "Goodbye!",
    DefaultTab = "Welcome",
    KeyLink    = "https://xyzscripts-platform.pages.dev/key",
    Links = {
        Discord    = { "discord.gg/x7gd33fY8S",  "https://discord.gg/x7gd33fY8S" },
        RScripts   = { "@XyzScriptsOfficial",    "https://rscripts.net/@XyzScriptsOfficial" },
        ScriptBlox = { "officialXyzScripts",     "https://scriptblox.com/u/officialXyzScripts" },
    },
    Status     = "Free",
    ValidKeys  = {},
    OnSuccess  = function(keyData)
        print("[XYZ SCRIPTS] Key verifiziert! (" .. tostring(keyData and keyData.tier or "Active") .. ")")

        _G.XYZ_AUTHENTICATED = true
        _G.XYZ_CURRENT_KEY   = Shared.CurrentKey
        _G.XYZ_CURRENT_TIER  = (type(keyData) == "table" and keyData.tier) and tostring(keyData.tier) or "Active"
        if getgenv then
            getgenv().XYZ_AUTHENTICATED = true
            getgenv().XYZ_CURRENT_KEY   = Shared.CurrentKey
            getgenv().XYZ_CURRENT_TIER  = _G.XYZ_CURRENT_TIER
        end

        local hook = (getgenv and getgenv().XYZ_ON_SUCCESS) or _G.XYZ_ON_SUCCESS
        if type(hook) == "function" then
            pcall(hook, keyData)
            return
        end

        -- 1. Prioritize luaCode directly returned from API (ensure it is not recursively a loader)
        if type(keyData) == "table" and keyData.luaCode and #keyData.luaCode > 5 and not keyData.luaCode:lower():find("/loader%.lua") then
            task.spawn(function()
                local fn, compileErr = loadstring(keyData.luaCode)
                if fn then
                    local ok, execErr = pcall(fn)
                    if ok then
                        print("[XYZ SCRIPTS] Main script successfully executed!")
                        return
                    else
                        warn("[XYZ SCRIPTS] Script execution error: " .. tostring(execErr))
                    end
                else
                    warn("[XYZ SCRIPTS] Syntax error in script payload: " .. tostring(compileErr))
                end
            end)
            return
        end

        -- 2. Fallback to target URL
        local targetUrl = nil
        if type(keyData) == "table" and keyData.payloadUrl and keyData.payloadUrl ~= "" and not keyData.payloadUrl:lower():find("/loader%.lua") then
            targetUrl = keyData.payloadUrl
        elseif Config.TargetScriptUrl and Config.TargetScriptUrl ~= "" and not Config.TargetScriptUrl:lower():find("/loader%.lua") then
            targetUrl = Config.TargetScriptUrl
        else
            targetUrl = "https://xyzscripts-platform.pages.dev/api/" .. game:GetService("HttpService"):UrlEncode(Config.ScriptName) .. "/get.lua"
        end

        if targetUrl and targetUrl ~= "" then
            if targetUrl:sub(1, 1) == "/" then
                targetUrl = Config.ServerUrl .. targetUrl
            end
            task.spawn(function()
                local ok, scriptSrc = pcall(function()
                    return game:HttpGet(targetUrl)
                end)
                if ok and scriptSrc and #scriptSrc > 10 and not scriptSrc:find("404 Not Found") then
                    local fn, compileErr = loadstring(scriptSrc)
                    if fn then
                        local runOk, runErr = pcall(fn)
                        if runOk then
                            print("[XYZ SCRIPTS] Main script successfully executed!")
                        else
                            warn("[XYZ SCRIPTS] Runtime error: " .. tostring(runErr))
                        end
                    else
                        warn("[XYZ SCRIPTS] Syntax error: " .. tostring(compileErr))
                    end
                else
                    warn("[XYZ SCRIPTS] Could not load main script from: " .. tostring(targetUrl))
                end
            end)
        end
    end,
}

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")

local player = Players.LocalPlayer
if not player then
    pcall(function()
        player = Players:GetPlayers()[1] or Players.PlayerAdded:Wait()
    end)
end

local function getDeviceHWID()
    local hwid = nil
    pcall(function()
        if gethwid then 
            hwid = gethwid()
        elseif get_hwid then 
            hwid = get_hwid()
        elseif identifyexecutor and game:GetService("RbxAnalyticsService") then
            hwid = identifyexecutor() .. "-" .. game:GetService("RbxAnalyticsService"):GetClientId()
        elseif game:GetService("RbxAnalyticsService") then
            hwid = game:GetService("RbxAnalyticsService"):GetClientId()
        end
    end)
    if not hwid or hwid == "" then
        pcall(function()
            hwid = "DEV-" .. tostring(player and player.UserId or 0) .. "-RBX"
        end)
    end
    return tostring(hwid or "UNKNOWN-HWID")
end

local DEVICE_HWID = getDeviceHWID()

local function httpRequest(url)
    local pName = player and player.Name or "Unknown"
    local pUserId = tostring(player and player.UserId or 0)
    local req = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
    if req then
        local success, res = pcall(function()
            return req({
                Url = url,
                Method = "GET",
                Headers = {
                    ["User-Agent"]     = "XYZ-Roblox-Executor/4.0",
                    ["Roblox-HWID"]    = DEVICE_HWID,
                    ["Roblox-Player"]  = pName,
                    ["Roblox-User-Id"] = pUserId
                }
            })
        end)
        if success and type(res) == "table" then
            local body = res.Body or res.body or res.data
            local code = res.StatusCode or res.status_code or res.Status or 200
            return body, code
        end
    end
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if ok then
        return body, 200
    end
    return nil, 500
end

local function validateKeyRemote(keyCode)
    if not keyCode or keyCode == "" then
        return false, "Bitte gib einen Key ein."
    end

    local cleanKey = string.gsub(keyCode, "%s+", "")
    local keyUpper = cleanKey:upper()

    -- Instant Universal Master Key Bypass (XYZ123, XYZ, etc.) - Valid everywhere, NEVER bound to HWID
    if keyUpper == "XYZ123" or keyUpper == "XYZ" or keyUpper == "XYZ-ADMIN" or keyUpper == "XYZ-VIP-PERMANENT" or keyUpper == "XYZ-DEVELOPER-KEY" or keyUpper == "XYZ-TEST-KEY" then
        return true, { tier = "PERMANENT", valid = true, remainingHours = "Lifetime" }
    end

    local pName = player and player.Name or "Unknown"
    local pUserId = tostring(player and player.UserId or 0)
    local sName = Config.ScriptName or ""
    local pId = tostring(game and game.PlaceId or 0)
    local query = "?key=" .. HttpService:UrlEncode(cleanKey)
        .. "&hwid=" .. HttpService:UrlEncode(DEVICE_HWID)
        .. "&player=" .. HttpService:UrlEncode(pName)
        .. "&username=" .. HttpService:UrlEncode(pName)
        .. "&userId=" .. HttpService:UrlEncode(pUserId)
        .. "&scriptName=" .. HttpService:UrlEncode(sName)
        .. "&placeId=" .. HttpService:UrlEncode(pId)

    local success, response = pcall(function()
        local body, status = httpRequest(Config.ServerUrl .. "/api/v1/validate" .. query)
        return HttpService:JSONDecode(body)
    end)

    if not success or type(response) ~= "table" then
        local fbSuccess, fbResponse = pcall(function()
            local body, status = httpRequest(Config.BackupUrl .. "/api/v1/validate" .. query)
            return HttpService:JSONDecode(body)
        end)
        if fbSuccess and type(fbResponse) == "table" then
            response = fbResponse
            success  = true
        end
    end

    if not success or type(response) ~= "table" then
        return false, "Connection error: Server unreachable.", true
    end

    if response.valid == true then
        return true, response
    else
        local reason = response.message or "Ungültiger oder abgelaufener Key."
        return false, reason
    end
end

local function getSavedKey()
    if isfile and isfile(Config.SaveFile) then
        local ok, content = pcall(function() return readfile(Config.SaveFile) end)
        if ok and content and #content > 4 then
            return string.gsub(content, "%s+", "")
        end
    end
    if script_key and type(script_key) == "string" and #script_key > 4 then return script_key end
    if _G.script_key and type(_G.script_key) == "string" then return _G.script_key end
    if _G.XYZ_KEY and type(_G.XYZ_KEY) == "string" then return _G.XYZ_KEY end
    return nil
end

local function saveKeyLocally(key)
    if writefile and key and #key > 4 then
        pcall(function() writefile(Config.SaveFile, key) end)
    end
end

local function clearSavedKey()
    if delfile and isfile and isfile(Config.SaveFile) then
        pcall(function() delfile(Config.SaveFile) end)
    end
end

local existingKey = getSavedKey()
if Config.AutoLogin and Shared.SaveKey and existingKey and #existingKey >= 4 then
    local isValid, dataOrErr, netFail = validateKeyRemote(existingKey)
    if isValid then
        local activeKey = (type(dataOrErr) == "table" and type(dataOrErr.key) == "string" and #dataOrErr.key >= 4) and dataOrErr.key or existingKey
        Shared.CurrentKey = activeKey
        if activeKey ~= existingKey and writefile then
            saveKeyLocally(activeKey)
        end
        _G.XYZ_AUTHENTICATED = true
        _G.XYZ_CURRENT_KEY   = activeKey
        _G.XYZ_CURRENT_TIER  = (type(dataOrErr) == "table" and dataOrErr.tier) and tostring(dataOrErr.tier) or "Active"
        if getgenv then
            getgenv().XYZ_AUTHENTICATED = true
            getgenv().XYZ_CURRENT_KEY   = activeKey
            getgenv().XYZ_CURRENT_TIER  = _G.XYZ_CURRENT_TIER
        end
        Config.OnSuccess(dataOrErr)
        return
    elseif not netFail then
        clearSavedKey()
        existingKey = nil
    end
end

local C = {
    Window   = Color3.fromRGB(20, 20, 22),
    Side     = Color3.fromRGB(24, 24, 26),
    Row      = Color3.fromRGB(30, 30, 33),
    RowHover = Color3.fromRGB(38, 38, 42),
    Stroke   = Color3.fromRGB(45, 45, 50),
    Text     = Color3.fromRGB(240, 240, 240),
    SubText  = Color3.fromRGB(140, 140, 145),
    Accent   = Color3.fromRGB(170, 170, 180),
    Good     = Color3.fromRGB(80, 200, 120),
    Bad      = Color3.fromRGB(220, 80, 80),
}

local function getParent()
    local ok, ui = pcall(function()
        return (gethui and gethui()) or game:GetService("CoreGui")
    end)
    if ok and ui then return ui end
    return player:WaitForChild("PlayerGui")
end

local function new(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do inst[k] = v end
    for _, c in ipairs(children or {}) do c.Parent = inst end
    return inst
end

local function corner(r) return new("UICorner", { CornerRadius = UDim.new(0, r) }) end
local function stroke(col, t) return new("UIStroke", { Color = col, Thickness = t or 1 }) end

local parent = getParent()
if parent:FindFirstChild("KeySystemUI") then parent.KeySystemUI:Destroy() end

local gui = new("ScreenGui", {
    Name = "KeySystemUI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

local Settings    = { Notifications = true, Keybind = true, Theme = Shared.Theme or "Dark", HideName = Shared.HideName, SaveKey = Shared.SaveKey }
local connections = {}
local uiReady     = false
local playUnloadAnimation

local function unload()
    for _, c in ipairs(connections) do
        pcall(function() c:Disconnect() end)
    end
    gui:Destroy()
end

local toastHolder = new("Frame", {
    Name = "Toasts",
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, -16, 1, -16),
    Size = UDim2.fromOffset(280, 320),
    BackgroundTransparency = 1,
    ZIndex = 100,
    Parent = gui,
}, {
    new("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
    }),
})

local toastCount = 0
local function notify(title, text, color, force)
    if not Settings.Notifications and not force then return end
    toastCount = toastCount + 1

    local wrapper = new("Frame", {
        Size = UDim2.fromOffset(280, 48),
        BackgroundTransparency = 1,
        LayoutOrder = toastCount,
        Parent = toastHolder,
    })
    local toast = new("Frame", {
        Position = UDim2.fromOffset(300, 0),
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = C.Row,
        Parent = wrapper,
    }, { corner(6), stroke(C.Stroke) })

    new("Frame", {
        Position = UDim2.fromOffset(8, 7),
        Size = UDim2.new(0, 3, 1, -14),
        BackgroundColor3 = color or C.Accent,
        BorderSizePixel = 0,
        Parent = toast,
    }, { new("UICorner", { CornerRadius = UDim.new(1, 0) }) })
    new("TextLabel", {
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = C.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(20, 6),
        Size = UDim2.new(1, -28, 0, 16),
        Parent = toast,
    })
    new("TextLabel", {
        Text = text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = C.SubText,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(20, 24),
        Size = UDim2.new(1, -28, 0, 16),
        Parent = toast,
    })

    TweenService:Create(toast, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.fromOffset(0, 0),
    }):Play()

    task.delay(3, function()
        if not toast.Parent then return end
        local out = TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.fromOffset(300, 0),
        })
        out:Play()
        out.Completed:Wait()
        wrapper:Destroy()
    end)
end

local Themes = {
    { name = "Dark", colors = {
        Window = Color3.fromRGB(20, 20, 22), Side = Color3.fromRGB(24, 24, 26),
        Row = Color3.fromRGB(30, 30, 33), RowHover = Color3.fromRGB(38, 38, 42),
        Stroke = Color3.fromRGB(45, 45, 50), Text = Color3.fromRGB(240, 240, 240),
        SubText = Color3.fromRGB(140, 140, 145), Accent = Color3.fromRGB(170, 170, 180),
    }},
    { name = "Midnight", colors = {
        Window = Color3.fromRGB(12, 16, 28), Side = Color3.fromRGB(15, 20, 34),
        Row = Color3.fromRGB(20, 27, 46), RowHover = Color3.fromRGB(27, 36, 60),
        Stroke = Color3.fromRGB(38, 50, 80), Text = Color3.fromRGB(235, 240, 255),
        SubText = Color3.fromRGB(130, 145, 175), Accent = Color3.fromRGB(80, 140, 255),
    }},
    { name = "Purple", colors = {
        Window = Color3.fromRGB(20, 14, 28), Side = Color3.fromRGB(24, 17, 34),
        Row = Color3.fromRGB(32, 23, 46), RowHover = Color3.fromRGB(42, 30, 60),
        Stroke = Color3.fromRGB(60, 44, 84), Text = Color3.fromRGB(245, 238, 255),
        SubText = Color3.fromRGB(150, 135, 175), Accent = Color3.fromRGB(170, 90, 255),
    }},
    { name = "Crimson", colors = {
        Window = Color3.fromRGB(26, 13, 14), Side = Color3.fromRGB(31, 16, 17),
        Row = Color3.fromRGB(40, 22, 23), RowHover = Color3.fromRGB(52, 29, 30),
        Stroke = Color3.fromRGB(72, 40, 42), Text = Color3.fromRGB(255, 238, 238),
        SubText = Color3.fromRGB(170, 135, 136), Accent = Color3.fromRGB(235, 64, 72),
    }},
    { name = "Emerald", colors = {
        Window = Color3.fromRGB(12, 22, 18), Side = Color3.fromRGB(15, 27, 22),
        Row = Color3.fromRGB(21, 37, 30), RowHover = Color3.fromRGB(28, 49, 40),
        Stroke = Color3.fromRGB(40, 68, 56), Text = Color3.fromRGB(236, 255, 244),
        SubText = Color3.fromRGB(130, 170, 150), Accent = Color3.fromRGB(60, 210, 130),
    }},
    { name = "Light", colors = {
        Window = Color3.fromRGB(240, 240, 243), Side = Color3.fromRGB(230, 230, 235),
        Row = Color3.fromRGB(250, 250, 252), RowHover = Color3.fromRGB(222, 222, 228),
        Stroke = Color3.fromRGB(205, 205, 212), Text = Color3.fromRGB(30, 30, 34),
        SubText = Color3.fromRGB(110, 110, 120), Accent = Color3.fromRGB(60, 60, 75),
    }},
}

local themeKeys = { "Window", "Side", "Row", "RowHover", "Stroke", "Text", "SubText", "Accent" }
local onThemeApplied = {}

local function ck(c)
    return math.floor(c.R * 255 + 0.5) .. "," .. math.floor(c.G * 255 + 0.5) .. "," .. math.floor(c.B * 255 + 0.5)
end

local function applyTheme(name)
    local target
    for _, t in ipairs(Themes) do
        if t.name == name then target = t.colors end
    end
    if not target then return end

    local map = {}
    for _, k in ipairs(themeKeys) do map[ck(C[k])] = target[k] end

    for _, d in ipairs(gui:GetDescendants()) do
        if not d:GetAttribute("NoTheme") then
            if d:IsA("GuiObject") then
                local n = map[ck(d.BackgroundColor3)]
                if n then d.BackgroundColor3 = n end
            end
            if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                local n = map[ck(d.TextColor3)]
                if n then d.TextColor3 = n end
            end
            if d:IsA("TextBox") then
                local n = map[ck(d.PlaceholderColor3)]
                if n then d.PlaceholderColor3 = n end
            end
            if d:IsA("UIStroke") then
                local n = map[ck(d.Color)]
                if n then d.Color = n end
            end
            if d:IsA("ImageLabel") then
                local n = map[ck(d.ImageColor3)]
                if n then d.ImageColor3 = n end
            end
        end
    end

    for _, k in ipairs(themeKeys) do C[k] = target[k] end
    Settings.Theme = name
    Shared.Theme = name
    Shared.Save()
    for _, cb in ipairs(onThemeApplied) do pcall(cb) end
end

local main = new("Frame", {
    Name = "Main",
    Visible = false,
    Size = UDim2.fromOffset(500, 300),
    Position = UDim2.new(0.5, -250, 0.5, -150),
    BackgroundColor3 = C.Window,
    BorderSizePixel = 0,
    Parent = gui,
}, { corner(8), stroke(C.Stroke) })

local mainScale = new("UIScale", { Scale = 0.85, Parent = main })

local titleBar = new("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundTransparency = 1,
    Parent = main,
})

new("TextLabel", {
    Text = Config.Title,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = C.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(16, 0),
    Size = UDim2.new(1, -100, 1, 0),
    Parent = titleBar,
})

local function titleButton(text, xOffset)
    return new("TextButton", {
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = C.SubText,
        BackgroundColor3 = C.Row,
        AutoButtonColor = false,
        Size = UDim2.fromOffset(22, 18),
        Position = UDim2.new(1, xOffset, 0.5, -9),
        Parent = titleBar,
    }, { corner(4) })
end

local minBtn   = titleButton("–", -56)
local closeBtn = titleButton("×", -30)

new("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.fromOffset(0, 40),
    BackgroundColor3 = C.Stroke,
    BorderSizePixel = 0,
    Parent = main,
})

local side = new("Frame", {
    Name = "Sidebar",
    Position = UDim2.fromOffset(0, 41),
    Size = UDim2.new(0, 150, 1, -41),
    BackgroundColor3 = C.Side,
    BorderSizePixel = 0,
    Parent = main,
}, { corner(8) })

new("Frame", {
    Position = UDim2.new(1, -8, 0, 0),
    Size = UDim2.new(0, 8, 1, 0),
    BackgroundColor3 = C.Side,
    BorderSizePixel = 0,
    Parent = side,
})
new("Frame", {
    Size = UDim2.new(1, 0, 0, 8),
    BackgroundColor3 = C.Side,
    BorderSizePixel = 0,
    Parent = side,
})

local pages, tabs = {}, {}
local currentTab

local function setTab(name)
    currentTab = name
    for n, t in pairs(tabs) do
        local active = (n == name)
        TweenService:Create(t.btn, TweenInfo.new(0.15), {
            BackgroundTransparency = active and 0 or 1,
        }):Play()
        t.label.TextColor3 = active and C.Text or C.SubText
        t.stroke.Color = active and C.Text or C.SubText
        t.dot.BackgroundTransparency = active and 0 or 1
    end
    for n, p in pairs(pages) do
        p.Visible = (n == name)
    end
end

local function createTab(name, y)
    local btn = new("TextButton", {
        Text = "",
        AutoButtonColor = false,
        Position = UDim2.fromOffset(8, y),
        Size = UDim2.new(1, -16, 0, 28),
        BackgroundColor3 = C.Row,
        BackgroundTransparency = 1,
        Parent = side,
    }, { corner(6) })

    local circle = new("Frame", {
        Size = UDim2.fromOffset(12, 12),
        Position = UDim2.fromOffset(8, 8),
        BackgroundTransparency = 1,
        Parent = btn,
    }, { new("UICorner", { CornerRadius = UDim.new(1, 0) }) })
    local st = new("UIStroke", { Color = C.SubText, Thickness = 1.5, Parent = circle })
    local dot = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(4, 4),
        BackgroundColor3 = C.Text,
        BackgroundTransparency = 1,
        Parent = circle,
    }, { new("UICorner", { CornerRadius = UDim.new(1, 0) }) })

    local label = new("TextLabel", {
        Text = name,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        TextColor3 = C.SubText,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(30, 0),
        Size = UDim2.new(1, -30, 1, 0),
        Parent = btn,
    })

    tabs[name] = { btn = btn, label = label, stroke = st, dot = dot }

    btn.MouseEnter:Connect(function()
        if currentTab ~= name then
            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0.6 }):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if currentTab ~= name then
            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
        end
    end)
    btn.MouseButton1Click:Connect(function() setTab(name) end)
end

createTab("Welcome", 10)
createTab("Premium", 40)
createTab("Key", 70)
createTab("Config", 100)

local profile = new("Frame", {
    Position = UDim2.new(0, 0, 1, -50),
    Size = UDim2.new(1, 0, 0, 50),
    BackgroundTransparency = 1,
    Parent = side,
})
new("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = C.Stroke,
    BorderSizePixel = 0,
    Parent = profile,
})

local avatar = new("ImageLabel", {
    Size = UDim2.fromOffset(32, 32),
    Position = UDim2.fromOffset(10, 9),
    BackgroundColor3 = C.Row,
    Parent = profile,
}, { new("UICorner", { CornerRadius = UDim.new(1, 0) }) })

task.spawn(function()
    local ok, img = pcall(function()
        return Players:GetUserThumbnailAsync(
            player.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size100x100
        )
    end)
    if ok then avatar.Image = img end
end)

local profileName = new("TextLabel", {
    Text = player.Name,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextColor3 = C.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(50, 9),
    Size = UDim2.new(1, -56, 0, 16),
    Parent = profile,
})
local statusProfileLabel = new("TextLabel", {
    Text = Config.Status,
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextColor3 = C.SubText,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(50, 25),
    Size = UDim2.new(1, -56, 0, 14),
    Parent = profile,
})

Shared.BindName(profileName, player.Name)

local content = new("Frame", {
    Position = UDim2.fromOffset(160, 51),
    Size = UDim2.new(1, -172, 1, -63),
    BackgroundTransparency = 1,
    Parent = main,
})

local function newPage(name)
    local p = new("Frame", {
        Name = name .. "Page",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = content,
    })
    pages[name] = p
    return p
end

local keyPage     = newPage("Key")
local welcomePage = newPage("Welcome")
local premiumPage = newPage("Premium")

local function copyText(text)
    local fn = setclipboard or toclipboard or (syn and syn.write_clipboard) or (Clipboard and Clipboard.set)
    if fn then
        local ok = pcall(fn, text)
        return ok
    end
    return false
end

local function linkRow(parentFrame, y, title, display, url, toastText)
    local row = new("TextButton", {
        Text = "",
        AutoButtonColor = false,
        Position = UDim2.fromOffset(0, y),
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = C.Row,
        Parent = parentFrame,
    }, { corner(6), stroke(C.Stroke) })

    new("TextLabel", {
        Text = title,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextColor3 = C.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(0, 90, 1, 0),
        Parent = row,
    })
    local right = new("TextLabel", {
        Text = display,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = C.SubText,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 100, 0, 0),
        Size = UDim2.new(1, -112, 1, 0),
        Parent = row,
    })

    row.MouseEnter:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.15), { BackgroundColor3 = C.RowHover }):Play()
    end)
    row.MouseLeave:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.15), { BackgroundColor3 = C.Row }):Play()
    end)

    local busy = false
    row.MouseButton1Click:Connect(function()
        if busy then return end
        busy = true
        local ok = copyText(url)
        if ok then
            notify("Copied", toastText or (title .. " link copied to clipboard"), C.Good)
        else
            notify("Error", "Clipboard is not supported by your executor", C.Bad, true)
        end
        right.Text = ok and "Copied!" or "Copy failed"
        right.TextColor3 = ok and C.Good or C.Bad
        task.wait(1.5)
        right.Text = display
        right.TextColor3 = C.SubText
        busy = false
    end)
    return row
end

local function infoRow(parentFrame, y, text)
    local row = new("Frame", {
        Position = UDim2.fromOffset(0, y),
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = C.Row,
        Parent = parentFrame,
    }, { corner(6), stroke(C.Stroke) })
    new("TextLabel", {
        Text = text,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextColor3 = C.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(1, -24, 1, 0),
        Parent = row,
    })
    return row
end

local welcomeTitle = new("TextLabel", {
    Text = "",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = C.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(2, 0),
    Size = UDim2.new(1, 0, 0, 56),
    Parent = welcomePage,
})
Shared.BindName(welcomeTitle, player.Name, function(n)
    return "Welcome " .. n .. " to " .. Config.LoaderName .. ", get your free key and start Cheating!"
end)

new("TextLabel", {
    Text = "Join our community for updates, new scripts and support!",
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = C.SubText,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextWrapped = true,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(2, 60),
    Size = UDim2.new(1, 0, 0, 16),
    Parent = welcomePage,
})

linkRow(welcomePage, 88,  "Discord",    Config.Links.Discord[1],    Config.Links.Discord[2])
linkRow(welcomePage, 126, "RScripts",   Config.Links.RScripts[1],   Config.Links.RScripts[2])
linkRow(welcomePage, 164, "ScriptBlox", Config.Links.ScriptBlox[1], Config.Links.ScriptBlox[2])

new("TextLabel", {
    Text = "Premium",
    Font = Enum.Font.GothamBold,
    TextSize = 17,
    TextColor3 = C.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(2, 0),
    Size = UDim2.new(1, 0, 0, 22),
    Parent = premiumPage,
})
new("TextLabel", {
    Text = "Current plan: " .. Config.Status,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = C.SubText,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(2, 24),
    Size = UDim2.new(1, 0, 0, 16),
    Parent = premiumPage,
})
infoRow(premiumPage, 52,  "No key system wait times")
infoRow(premiumPage, 90,  "Exclusive premium & lifetime script features")
infoRow(premiumPage, 128, "Priority support & instant execution")
linkRow(premiumPage, 176, "Get Premium", "Discord", Config.Links.Discord[2], "Discord link copied - open a ticket for Premium")

local settingsPage = new("ScrollingFrame", {
    Name = "ConfigPage",
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = C.Stroke,
    CanvasSize = UDim2.new(0, 0, 0, 300),
    Visible = false,
    Parent = content,
})
pages["Config"] = settingsPage

new("TextLabel", {
    Text = "Config",
    Font = Enum.Font.GothamBold,
    TextSize = 17,
    TextColor3 = C.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(2, 0),
    Size = UDim2.new(1, 0, 0, 22),
    Parent = settingsPage,
})
new("TextLabel", {
    Text = "Customize your interface",
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = C.SubText,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(2, 24),
    Size = UDim2.new(1, 0, 0, 16),
    Parent = settingsPage,
})
new("TextLabel", {
    Text = "Theme",
    Font = Enum.Font.GothamMedium,
    TextSize = 12,
    TextColor3 = C.SubText,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(2, 48),
    Size = UDim2.new(1, 0, 0, 14),
    Parent = settingsPage,
})

local chips = {}
local function refreshChips()
    for name, chip in pairs(chips) do
        local active = (name == Settings.Theme)
        chip.Color = active and C.Accent or C.Stroke
        chip.Thickness = active and 1.5 or 1
    end
end

for i, t in ipairs(Themes) do
    local col = (i - 1) % 3
    local rowIdx = math.floor((i - 1) / 3)
    local st = stroke(C.Stroke)
    local chip = new("TextButton", {
        Text = "",
        AutoButtonColor = false,
        Position = UDim2.fromOffset(col * 111, 66 + rowIdx * 34),
        Size = UDim2.fromOffset(106, 28),
        BackgroundColor3 = C.Row,
        Parent = settingsPage,
    }, { corner(6), st })

    local swatch = new("Frame", {
        Position = UDim2.fromOffset(8, 8),
        Size = UDim2.fromOffset(12, 12),
        BackgroundColor3 = t.colors.Accent,
        Parent = chip,
    }, { new("UICorner", { CornerRadius = UDim.new(1, 0) }) })
    swatch:SetAttribute("NoTheme", true)

    new("TextLabel", {
        Text = t.name,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = C.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(28, 0),
        Size = UDim2.new(1, -30, 1, 0),
        Parent = chip,
    })

    chips[t.name] = st
    chip.MouseButton1Click:Connect(function()
        applyTheme(t.name)
        notify("Theme", t.name .. " theme applied")
    end)
end

local function toggleRow(y, title, key, onChange)
    local row = new("TextButton", {
        Text = "",
        AutoButtonColor = false,
        Position = UDim2.fromOffset(0, y),
        Size = UDim2.new(1, -8, 0, 34),
        BackgroundColor3 = C.Row,
        Parent = settingsPage,
    }, { corner(6), stroke(C.Stroke) })

    new("TextLabel", {
        Text = title,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextColor3 = C.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(1, -70, 1, 0),
        Parent = row,
    })

    local sw = new("Frame", {
        Position = UDim2.new(1, -46, 0.5, -9),
        Size = UDim2.fromOffset(34, 18),
        BackgroundColor3 = Settings[key] and C.Accent or C.Stroke,
        Parent = row,
    }, { new("UICorner", { CornerRadius = UDim.new(1, 0) }) })
    local knob = new("Frame", {
        Position = Settings[key] and UDim2.fromOffset(18, 2) or UDim2.fromOffset(2, 2),
        Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = Color3.fromRGB(250, 250, 250),
        Parent = sw,
    }, { new("UICorner", { CornerRadius = UDim.new(1, 0) }) })
    knob:SetAttribute("NoTheme", true)

    row.MouseEnter:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.15), { BackgroundColor3 = C.RowHover }):Play()
    end)
    row.MouseLeave:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.15), { BackgroundColor3 = C.Row }):Play()
    end)
    row.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        local on = Settings[key]
        TweenService:Create(sw, TweenInfo.new(0.15), { BackgroundColor3 = on and C.Accent or C.Stroke }):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {
            Position = on and UDim2.fromOffset(18, 2) or UDim2.fromOffset(2, 2),
        }):Play()
        if onChange then onChange(on) end
    end)
end

toggleRow(142, "Notifications", "Notifications", function(on)
    if on then notify("Notifications", "Notifications enabled", nil, true) end
end)
toggleRow(180, "Toggle UI with RightShift", "Keybind")
toggleRow(218, "Hide username", "HideName", function(on)
    Shared.HideName = on
    Shared.Save()
end)
toggleRow(256, "Save key (auto-load next time)", "SaveKey", function(on)
    Shared.SaveKey = on
    Shared.Save()
    if on then
        Shared.WriteKey()
    else
        clearSavedKey()
    end
end)

table.insert(onThemeApplied, refreshChips)
table.insert(onThemeApplied, function() setTab(currentTab) end)
refreshChips()

local enterRow = new("Frame", {
    Size = UDim2.new(1, 0, 0, 34),
    BackgroundColor3 = C.Row,
    Parent = keyPage,
}, { corner(6), stroke(C.Stroke) })

new("TextLabel", {
    Text = "Enter Key",
    Font = Enum.Font.GothamMedium,
    TextSize = 13,
    TextColor3 = C.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(12, 0),
    Size = UDim2.new(0, 90, 1, 0),
    Parent = enterRow,
})

local input = new("TextBox", {
    PlaceholderText = "Input",
    PlaceholderColor3 = C.SubText,
    Text = "",
    ClearTextOnFocus = false,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = C.Text,
    TextXAlignment = Enum.TextXAlignment.Right,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 100, 0, 0),
    Size = UDim2.new(1, -112, 1, 0),
    Parent = enterRow,
})

if existingKey and Shared.SaveKey then input.Text = existingKey end

local checkRow = new("TextButton", {
    Text = "",
    AutoButtonColor = false,
    Position = UDim2.fromOffset(0, 42),
    Size = UDim2.new(1, 0, 0, 34),
    BackgroundColor3 = C.Row,
    Parent = keyPage,
}, { corner(6), stroke(C.Stroke) })

new("TextLabel", {
    Text = "Check Key",
    Font = Enum.Font.GothamMedium,
    TextSize = 13,
    TextColor3 = C.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(12, 0),
    Size = UDim2.new(1, -50, 1, 0),
    Parent = checkRow,
})

local indicator = new("Frame", {
    Size = UDim2.fromOffset(10, 10),
    Position = UDim2.new(1, -22, 0.5, -5),
    BackgroundColor3 = C.SubText,
    Parent = checkRow,
}, { new("UICorner", { CornerRadius = UDim.new(1, 0) }) })

linkRow(keyPage, 84, "Get Key", "xyzscripts-platform.pages.dev", Config.KeyLink, "Key link copied - paste it in your browser")

local status = new("TextLabel", {
    Text = "",
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = C.SubText,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(2, 126),
    Size = UDim2.new(1, 0, 0, 16),
    Parent = keyPage,
})

setTab(Config.DefaultTab)

local checking = false
local function checkKey()
    if checking then return end
    checking = true

    local entered = input.Text:gsub("%s+", "")
    if #entered < 4 then
        status.Text = "Please enter a key first!"
        status.TextColor3 = C.Bad
        notify("Error", "Please enter a key", C.Bad)
        checking = false
        return
    end

    status.Text = "Verifying key with server..."
    status.TextColor3 = C.SubText
    TweenService:Create(indicator, TweenInfo.new(0.2), { BackgroundColor3 = C.Accent }):Play()

    task.spawn(function()
        local valid, dataOrErr = validateKeyRemote(entered)

        if not valid and Config.ValidKeys then
            for _, k in ipairs(Config.ValidKeys) do
                if entered == k then
                    valid = true
                    dataOrErr = { tier = "Free", valid = true }
                    break
                end
            end
        end

        if valid then
            local keyToSave = (type(dataOrErr) == "table" and type(dataOrErr.key) == "string" and #dataOrErr.key >= 4) and dataOrErr.key or entered
            Shared.CurrentKey = keyToSave
            if Shared.SaveKey then saveKeyLocally(keyToSave) else clearSavedKey() end
            _G.XYZ_AUTHENTICATED = true
            _G.XYZ_CURRENT_KEY   = keyToSave
            _G.XYZ_CURRENT_TIER  = (type(dataOrErr) == "table" and dataOrErr.tier) and tostring(dataOrErr.tier) or "Active"
            if getgenv then
                getgenv().XYZ_AUTHENTICATED = true
                getgenv().XYZ_CURRENT_KEY   = keyToSave
                getgenv().XYZ_CURRENT_TIER  = _G.XYZ_CURRENT_TIER
            end
            local tier = (type(dataOrErr) == "table" and dataOrErr.tier) and tostring(dataOrErr.tier):upper() or "ACTIVE"
            status.Text = "Key verified! [" .. tier .. "]"
            status.TextColor3 = C.Good
            Config.Status = tier
            pcall(function() statusProfileLabel.Text = tier end)
            notify("Success", "Key verified! Access granted (" .. tier .. ")", C.Good)
            TweenService:Create(indicator, TweenInfo.new(0.2), { BackgroundColor3 = C.Good }):Play()
            task.wait(0.7)
            unload()
            pcall(function()
                Config.OnSuccess(dataOrErr)
            end)
        else
            local msg = tostring(dataOrErr or "Invalid key!")
            status.Text = msg
            status.TextColor3 = C.Bad
            notify("Error", msg, C.Bad)
            TweenService:Create(indicator, TweenInfo.new(0.2), { BackgroundColor3 = C.Bad }):Play()
            task.wait(1.5)
            TweenService:Create(indicator, TweenInfo.new(0.2), { BackgroundColor3 = C.SubText }):Play()
            checking = false
        end
    end)
end

checkRow.MouseButton1Click:Connect(checkKey)
input.FocusLost:Connect(function(enter) if enter then checkKey() end end)

local function hover(btn, base, over)
    local function col(x) return typeof(x) == "string" and C[x] or x end
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = col(over) }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = col(base) }):Play()
    end)
end
hover(checkRow, "Row", "RowHover")
hover(minBtn, "Row", "Stroke")
hover(closeBtn, "Row", Color3.fromRGB(90, 40, 40))

local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    side.Visible = not minimized
    content.Visible = not minimized
    TweenService:Create(main, TweenInfo.new(0.2), {
        Size = minimized and UDim2.fromOffset(500, 40) or UDim2.fromOffset(500, 300)
    }):Play()
end)

local overlay = new("Frame", {
    Name = "UnloadOverlay",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Visible = false,
    Active = true,
    ZIndex = 50,
    Parent = gui,
})

local dialog = new("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(340, 150),
    BackgroundColor3 = C.Window,
    BorderSizePixel = 0,
    Parent = overlay,
}, { corner(8), stroke(C.Stroke) })
local dialogScale = new("UIScale", { Scale = 0.9, Parent = dialog })

new("TextLabel", {
    Text = "Unload Interface",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = C.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(20, 16),
    Size = UDim2.new(1, -40, 0, 20),
    Parent = dialog,
})
new("TextLabel", {
    Text = "Are you sure you want to unload the interface?",
    Font = Enum.Font.Gotham,
    TextSize = 13,
    TextColor3 = C.SubText,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(20, 44),
    Size = UDim2.new(1, -40, 0, 36),
    Parent = dialog,
})

local function dialogButton(text, pos, bg, txtColor)
    return new("TextButton", {
        Text = text,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextColor3 = txtColor,
        AutoButtonColor = false,
        BackgroundColor3 = bg,
        Position = pos,
        Size = UDim2.new(0.5, -25, 0, 32),
        Parent = dialog,
    }, { corner(6) })
end

local cancelBtn = dialogButton("Cancel", UDim2.new(0, 20, 0, 102), C.Row, C.Text)
local unloadBtn = dialogButton("Unload", UDim2.new(0.5, 5, 0, 102), Color3.fromRGB(200, 70, 70), Color3.fromRGB(250, 250, 250))
hover(cancelBtn, "Row", "RowHover")
hover(unloadBtn, Color3.fromRGB(200, 70, 70), Color3.fromRGB(225, 90, 90))

local function openDialog()
    overlay.Visible = true
    dialogScale.Scale = 0.9
    TweenService:Create(overlay, TweenInfo.new(0.25), { BackgroundTransparency = 0.45 }):Play()
    TweenService:Create(dialogScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
end
local function closeDialog()
    local t = TweenService:Create(overlay, TweenInfo.new(0.2), { BackgroundTransparency = 1 })
    TweenService:Create(dialogScale, TweenInfo.new(0.2), { Scale = 0.9 }):Play()
    t:Play()
    t.Completed:Wait()
    overlay.Visible = false
end

closeBtn.MouseButton1Click:Connect(openDialog)
cancelBtn.MouseButton1Click:Connect(closeDialog)
unloadBtn.MouseButton1Click:Connect(function() playUnloadAnimation() end)

local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, i.Position, main.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
table.insert(connections, UserInputService.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end))

table.insert(connections, UserInputService.InputBegan:Connect(function(input, processed)
    if processed or not uiReady or not Settings.Keybind then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
        if not main.Visible then
            notify("UI hidden", "Press RightShift to show it again")
        end
    end
end))

local function tw(obj, t, props, style, dir)
    local tween = TweenService:Create(
        obj,
        TweenInfo.new(t, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        props
    )
    tween:Play()
    return tween
end

local function buildLetters(parent, text, textSize, height)
    local holder = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, height),
        BackgroundTransparency = 1,
        Parent = parent,
    }, {
        new("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
        }),
    })

    local letters = {}
    for i = 1, #text do
        local ch = text:sub(i, i)
        local isSpace = (ch == " ")
        letters[#letters + 1] = new("TextLabel", {
            Text = ch,
            Font = Enum.Font.GothamBlack,
            TextSize = textSize,
            TextColor3 = C.SubText,
            TextTransparency = 1,
            BackgroundTransparency = 1,
            Size = isSpace and UDim2.fromOffset(math.floor(textSize * 0.35), height) or UDim2.fromOffset(0, height),
            AutomaticSize = isSpace and Enum.AutomaticSize.None or Enum.AutomaticSize.X,
            LayoutOrder = i,
            Parent = holder,
        })
    end
    return holder, letters
end

local function buildLoaderUI(titleText)
    local frame = new("Frame", {
        Name = "Loader",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(420, 150),
        BackgroundTransparency = 1,
        Parent = gui,
    })

    local _, letters = buildLetters(frame, titleText, 40, 48)

    local line = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 56),
        Size = UDim2.fromOffset(0, 2),
        BackgroundColor3 = C.Text,
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        Parent = frame,
    }, { new("UICorner", { CornerRadius = UDim.new(1, 0) }) })

    local barBg = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 84),
        Size = UDim2.fromOffset(280, 6),
        BackgroundColor3 = C.Row,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = frame,
    }, { new("UICorner", { CornerRadius = UDim.new(1, 0) }) })

    local barFill = new("Frame", {
        Size = UDim2.fromScale(0, 1),
        BackgroundColor3 = C.Text,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = barBg,
    }, {
        new("UICorner", { CornerRadius = UDim.new(1, 0) }),
        new("UIGradient", {
            Color = ColorSequence.new(Color3.fromRGB(150, 150, 160), Color3.fromRGB(255, 255, 255)),
        }),
    })

    local loadText = new("TextLabel", {
        Text = "",
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextColor3 = C.SubText,
        TextTransparency = 1,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 100),
        Size = UDim2.fromOffset(280, 20),
        Parent = frame,
    })

    local percentText = new("TextLabel", {
        Text = "0%",
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = C.SubText,
        TextTransparency = 1,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 122),
        Size = UDim2.fromOffset(280, 16),
        Parent = frame,
    })

    return {
        frame = frame, letters = letters, line = line, barBg = barBg,
        barFill = barFill, loadText = loadText, percentText = percentText,
    }
end

local function fadeInBar(L)
    tw(L.barBg, 0.3, { BackgroundTransparency = 0 })
    tw(L.barFill, 0.3, { BackgroundTransparency = 0 })
    tw(L.loadText, 0.3, { TextTransparency = 0 })
    tw(L.percentText, 0.3, { TextTransparency = 0 })
end

local function fadeOutAll(L, t)
    for _, l in ipairs(L.letters) do
        tw(l, t, { TextTransparency = 1 })
    end
    tw(L.line, t, { BackgroundTransparency = 1 })
    tw(L.barBg, t, { BackgroundTransparency = 1 })
    tw(L.barFill, t, { BackgroundTransparency = 1 })
    tw(L.loadText, t, { TextTransparency = 1 })
    tw(L.percentText, t, { TextTransparency = 1 })
end

local function runStep(L, text, from, to)
    L.loadText.Text = text
    local dur = math.random(45, 90) / 100
    tw(L.barFill, dur, { Size = UDim2.fromScale(to / 100, 1) }, Enum.EasingStyle.Sine)
    local t0 = os.clock()
    while os.clock() - t0 < dur do
        local a = (os.clock() - t0) / dur
        L.percentText.Text = math.floor(from + (to - from) * a) .. "%"
        task.wait()
    end
    L.percentText.Text = to .. "%"
end

local loaderUI = buildLoaderUI(Config.LoaderName)

task.spawn(function()
    local ok, err = pcall(function()
        local L = loaderUI

        for _, l in ipairs(L.letters) do
            tw(l, 0.35, { TextTransparency = 0, TextColor3 = C.Text })
            task.wait(0.07)
        end
        task.wait(0.2)

        tw(L.line, 0.5, { Size = UDim2.fromOffset(220, 2) }, Enum.EasingStyle.Quint)
        task.wait(0.35)

        fadeInBar(L)
        task.wait(0.35)

        local last = 0
        for _, step in ipairs(Config.LoaderSteps) do
            runStep(L, step[1], last, step[2])
            last = step[2]
            task.wait(0.15)
        end
        task.wait(0.4)

        fadeOutAll(L, 0.4)
        task.wait(0.5)
        L.frame:Destroy()

        main.Visible = true
        uiReady = true
        tw(mainScale, 0.5, { Scale = 1 }, Enum.EasingStyle.Back)
    end)

    if not ok then
        warn("[KeySystem] Loader-Fehler: " .. tostring(err))
        pcall(function() loaderUI.frame:Destroy() end)
        mainScale.Scale = 1
        main.Visible = true
        uiReady = true
    end
end)

local unloading = false
playUnloadAnimation = function()
    if unloading then return end
    unloading = true
    uiReady = false

    for _, c in ipairs(connections) do
        pcall(function() c:Disconnect() end)
    end
    connections = {}

    local ok, err = pcall(function()
        overlay.Visible = false
        toastHolder.Visible = false
        tw(mainScale, 0.3, { Scale = 0.85 }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.3)
        main.Visible = false
        task.wait(0.2)

        local L = buildLoaderUI(Config.LoaderName)
        L.barFill.Size = UDim2.fromScale(1, 1)
        L.percentText.Text = "100%"

        for _, l in ipairs(L.letters) do
            tw(l, 0.3, { TextTransparency = 0, TextColor3 = C.Text })
            task.wait(0.05)
        end
        task.wait(0.15)
        tw(L.line, 0.4, { Size = UDim2.fromOffset(220, 2) }, Enum.EasingStyle.Quint)
        task.wait(0.3)
        fadeInBar(L)
        task.wait(0.35)

        local last = 100
        for _, step in ipairs(Config.UnloadSteps) do
            runStep(L, step[1], last, step[2])
            last = step[2]
            task.wait(0.15)
        end
        task.wait(0.4)

        fadeOutAll(L, 0.4)
        task.wait(0.55)
        L.frame:Destroy()

        local bye = new("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(420, 60),
            BackgroundTransparency = 1,
            Parent = gui,
        })
        local _, byeLetters = buildLetters(bye, Config.GoodbyeText, 44, 60)
        for _, l in ipairs(byeLetters) do
            tw(l, 0.35, { TextTransparency = 0, TextColor3 = C.Text })
            task.wait(0.08)
        end
        task.wait(1.1)
        for _, l in ipairs(byeLetters) do
            tw(l, 0.45, { TextTransparency = 1 })
        end
        task.wait(0.6)
    end)

    if not ok then
        warn("[KeySystem] Unload-Fehler: " .. tostring(err))
    end
    unload()
end

gui.Parent = parent

