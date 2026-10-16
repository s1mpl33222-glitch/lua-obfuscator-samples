-- Babis Premium secure runtime loader
-- Use only inside Roblox experiences you own or are authorized to manage.
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local RUN_URL = "https://babis-keymaster.lovable.app/api/public/run/a9d50c8baf9f326bdc502093"
local HEARTBEAT_URL = "https://babis-keymaster.lovable.app/api/public/heartbeat"
local APPEAL_URL = "https://discord.gg/75auNNfmhS"
local CACHE_FILE = "babis_license_a9d50c8baf9f326bdc502093.txt"

local function safeRequest(url, method, body)
    local payload = body and HttpService:JSONEncode(body) or "{}"
    local headers = { ["Content-Type"] = "application/json" }
    local requestFn = (syn and syn.request) or (http and http.request) or request or http_request
    if requestFn then
        local ok, response = pcall(requestFn, { Url = url, Method = method or "POST", Headers = headers, Body = payload })
        if not ok or not response then return false, "Request failed" end
        local status = tonumber(response.StatusCode or response.status_code or response.Status or 0) or 0
        local text = tostring(response.Body or response.body or "")
        return status >= 200 and status < 300, text, status
    end
    if game.HttpPost then
        local ok, text = pcall(function() return game:HttpPost(url, payload, "application/json") end)
        if ok then return true, text, 200 end
    end
    return false, "No compatible HTTP request function is available", 0
end

local function decode(text)
    local ok, data = pcall(function() return HttpService:JSONDecode(text) end)
    if ok and type(data) == "table" then return data end
    return { ok = false, message = "Invalid server response" }
end

local function readCachedKey()
    if isfile and readfile then
        local ok, value = pcall(function() if isfile(CACHE_FILE) then return readfile(CACHE_FILE) end end)
        if ok and type(value) == "string" then return value end
    end
    return ""
end

local function saveCachedKey(value)
    if writefile and type(value) == "string" and #value > 0 then
        pcall(function() writefile(CACHE_FILE, value) end)
    end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BabisPremiumLoader"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
if syn and syn.protect_gui then pcall(function() syn.protect_gui(screenGui) end) end
screenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local shade = Instance.new("Frame")
shade.Name = "Shade"
shade.BackgroundColor3 = Color3.fromRGB(10, 12, 10)
shade.BackgroundTransparency = 0.18
shade.Size = UDim2.new(1, 0, 1, 0)
shade.Parent = screenGui

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.new(0.5, 0, 0.5, 0)
panel.Size = UDim2.new(0.86, 0, 0, 302)
panel.BackgroundColor3 = Color3.fromRGB(25, 27, 23)
panel.BorderSizePixel = 0
panel.Parent = shade

local sizeLimit = Instance.new("UISizeConstraint")
sizeLimit.MinSize = Vector2.new(280, 274)
sizeLimit.MaxSize = Vector2.new(440, 334)
sizeLimit.Parent = panel

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(218, 178, 86)
stroke.Thickness = 1
stroke.Transparency = 0.18
stroke.Parent = panel

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 18)
padding.PaddingBottom = UDim.new(0, 18)
padding.PaddingLeft = UDim.new(0, 18)
padding.PaddingRight = UDim.new(0, 18)
padding.Parent = panel

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.Padding = UDim.new(0, 12)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = panel

local title = Instance.new("TextLabel")
title.Name = "Title"
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 28)
title.Font = Enum.Font.GothamBold
title.Text = "Babis Premium"
title.TextColor3 = Color3.fromRGB(246, 225, 173)
title.TextScaled = true
title.Parent = panel

local status = Instance.new("TextLabel")
status.Name = "Status"
status.BackgroundTransparency = 1
status.Size = UDim2.new(1, 0, 0, 40)
status.Font = Enum.Font.Gotham
status.Text = "Checking access..."
status.TextColor3 = Color3.fromRGB(216, 218, 208)
status.TextWrapped = true
status.TextSize = 14
status.Parent = panel

local keyBox = Instance.new("TextBox")
keyBox.Name = "LicenseKey"
keyBox.Size = UDim2.new(1, 0, 0, 42)
keyBox.BackgroundColor3 = Color3.fromRGB(15, 17, 14)
keyBox.BorderSizePixel = 0
keyBox.ClearTextOnFocus = false
keyBox.PlaceholderText = "Enter license key"
keyBox.Text = readCachedKey()
keyBox.TextColor3 = Color3.fromRGB(245, 245, 238)
keyBox.PlaceholderColor3 = Color3.fromRGB(132, 134, 126)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 14
keyBox.Parent = panel
local keyPadding = Instance.new("UIPadding")
keyPadding.PaddingLeft = UDim.new(0, 12)
keyPadding.PaddingRight = UDim.new(0, 12)
keyPadding.Parent = keyBox

local button = Instance.new("TextButton")
button.Name = "Verify"
button.Size = UDim2.new(1, 0, 0, 42)
button.BackgroundColor3 = Color3.fromRGB(218, 178, 86)
button.BorderSizePixel = 0
button.Font = Enum.Font.GothamBold
button.Text = "Verify and launch"
button.TextColor3 = Color3.fromRGB(18, 16, 10)
button.TextSize = 14
button.Parent = panel

local trialButton = { Visible = false, Text = "" }
if true then
    trialButton = Instance.new("TextButton")
    trialButton.Name = "Trial"
    trialButton.Size = UDim2.new(1, 0, 0, 42)
    trialButton.BackgroundColor3 = Color3.fromRGB(218, 178, 86)
    trialButton.BorderSizePixel = 0
    trialButton.Font = Enum.Font.GothamBold
    trialButton.Text = "Trial: checking..."
    trialButton.TextColor3 = Color3.fromRGB(18, 16, 10)
    trialButton.TextSize = 14
    trialButton.Visible = false
    trialButton.Parent = panel
end

local function formatLeft(seconds)
    seconds = math.max(0, math.floor(tonumber(seconds) or 0))
    local d = math.floor(seconds / 86400)
    local h = math.floor((seconds % 86400) / 3600)
    local m = math.floor((seconds % 3600) / 60)
    if d > 0 then return d .. "d " .. h .. "h left" end
    if h > 0 then return h .. "h " .. m .. "m left" end
    return m .. "m left"
end

local useTrial = false
local sessionToken = nil
local launched = false
local function closeGui()
    local fadeInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    pcall(function() TweenService:Create(panel, fadeInfo, { Position = UDim2.new(0.5, 0, 0.48, 0), BackgroundTransparency = 1 }):Play() end)
    pcall(function() TweenService:Create(shade, fadeInfo, { BackgroundTransparency = 1 }):Play() end)
    task.delay(0.22, function() pcall(function() screenGui:Destroy() end) end)
end

local function launch()
    if launched then return end
    launched = true
    button.Active = false
    button.Text = "Launching..."
    status.Text = "Verifying access..."
    local body = {
        licenseKey = useTrial and "" or (keyBox.Text or ""),
        trial = useTrial,
        playerUserId = player and tostring(player.UserId) or "",
        playerName = player and player.Name or "",
        placeId = tostring(game.PlaceId),
        universeId = tostring(game.GameId),
        jobId = tostring(game.JobId),
        executorName = identifyexecutor and tostring(identifyexecutor()) or "Roblox"
    }
    local ok, text, httpStatus = safeRequest(RUN_URL, "POST", body)
    local response = decode(text or "")
    if not ok or not response.ok then
        launched = false
        button.Active = true
        button.Text = "Verify and launch"
        useTrial = false
        status.Text = tostring((response and response.message) or ("HTTP " .. tostring(httpStatus)))
        if httpStatus == 401 or httpStatus == 403 then status.Text = status.Text .. " | Appeal: " .. APPEAL_URL end
        return
    end
    sessionToken = response.sessionToken
    if not useTrial and keyBox.Text and #keyBox.Text > 0 then saveCachedKey(keyBox.Text) end
    status.Text = "Access granted. Starting " .. tostring(response.scriptName or "script") .. "..."
    closeGui()
    task.spawn(function()
        local StarterGui = game:GetService("StarterGui")
        while sessionToken do
            task.wait(10)
            local heartbeatOk, heartbeatText = safeRequest(HEARTBEAT_URL, "POST", { sessionToken = sessionToken })
            local heartbeat = decode(heartbeatText or "")
            if heartbeatOk and heartbeat and heartbeat.action == "kick" then
                local reason = tostring(heartbeat.reason or "Access revoked") .. " | Appeal: " .. APPEAL_URL
                pcall(function() if player then player:Kick(reason) end end)
                break
            end
            if heartbeatOk and heartbeat and heartbeat.message and #tostring(heartbeat.message) > 0 then
                pcall(function() StarterGui:SetCore("SendNotification", { Title = "Babis Premium", Text = tostring(heartbeat.message), Duration = 8 }) end)
            end
        end
    end)
    pcall(function() if player then player.AncestryChanged:Connect(function(_, parent) if not parent then sessionToken = nil end end) end end)
    local compile = loadstring or load
    if type(compile) ~= "function" then
        status.Text = "This runtime does not support dynamic Luau execution."
        return
    end
    local fn, compileError = compile(tostring(response.source or ""))
    if type(fn) ~= "function" then
        warn("Babis compile error: " .. tostring(compileError))
        return
    end
    local runOk, runError = pcall(fn)
    if not runOk then warn("Babis runtime error: " .. tostring(runError)) end
end

button.MouseButton1Click:Connect(function() useTrial = false launch() end)
if trialButton.Visible ~= nil and typeof(trialButton) == "Instance" then
    trialButton.MouseButton1Click:Connect(function() useTrial = true launch() end)
    task.spawn(function()
        local ok, text = safeRequest(RUN_URL, "POST", {
            trialCheck = true,
            playerUserId = player and tostring(player.UserId) or "",
            playerName = player and player.Name or "",
            placeId = tostring(game.PlaceId),
            universeId = tostring(game.GameId),
        })
        local info = decode(text or "")
        if ok and info.ok and info.trialAvailable then
            if info.trialStarted and (tonumber(info.secondsLeft) or 0) <= 0 then
                trialButton.Text = "Trial: expired"
            else
                trialButton.Text = "Trial: " .. formatLeft(info.secondsLeft)
            end
            trialButton.Visible = true
        end
    end)
end
if keyBox.Text and #keyBox.Text > 0 then task.delay(0.2, launch) end
