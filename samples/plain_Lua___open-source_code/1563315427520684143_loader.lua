-- Vitality Hub loader
-- Optional: getgenv().key = "YOUR_VITALITY_KEY"
local targetScript = "mainloaderls" -- VITALITY_SCRIPT_TARGET
local runtimeArgument = ...
local requestedRelease = type(runtimeArgument) == "table" and runtimeArgument.Release or nil
local requestedScript = type(runtimeArgument) == "table" and runtimeArgument.Script or nil
if requestedScript ~= nil and (type(requestedScript) ~= "string" or #requestedScript > 80 or not requestedScript:match("^[a-z0-9][a-z0-9_%-]*$")) then
    warn("Invalid Vitality script selector.")
    return
end
if requestedRelease ~= nil and (type(requestedRelease) ~= "string" or not requestedRelease:match("^[a-f0-9%-]+$") or #requestedRelease ~= 36) then
    warn("Invalid Vitality release selector.")
    return
end
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
if not game:IsLoaded() then game.Loaded:Wait() end
local environment = type(getgenv) == "function" and getgenv() or _G
local WEBSITE_KEY_MEMORY = "__VITALITY_WEBSITE_REMEMBERED_KEY"
local WEBSITE_KEY_PATH = "VitalityHubKeys/VitalityWebsiteKey.txt"
local send = request or http_request or (syn and syn.request)
if type(send) ~= "function" or type(loadstring) ~= "function" then
    warn("Vitality requires an executor with HTTP request and loadstring support.")
    return
end

local function trimKey(value)
    return type(value) == "string" and value:match("^%s*(.-)%s*$") or ""
end
local function clearWebsiteKey()
    environment.key = nil
    environment[WEBSITE_KEY_MEMORY] = nil
    local deleted = type(delfile) == "function" and pcall(delfile, WEBSITE_KEY_PATH)
    if not deleted and type(writefile) == "function" then pcall(writefile, WEBSITE_KEY_PATH, "") end
end
local function rememberWebsiteKey(key)
    environment.key = key
    environment[WEBSITE_KEY_MEMORY] = key
    if type(writefile) == "function" then
        if type(makefolder) == "function" then pcall(makefolder, "VitalityHubKeys") end
        pcall(writefile, WEBSITE_KEY_PATH, key)
    end
end
local function readWebsiteKey()
    local key = type(runtimeArgument) == "table" and trimKey(runtimeArgument.Key) or ""
    if key == "" then key = trimKey(environment.key) end
    if key == "" then key = trimKey(environment[WEBSITE_KEY_MEMORY]) end
    if key == "" and type(readfile) == "function" then
        local ok, stored = pcall(readfile, WEBSITE_KEY_PATH)
        if ok then key = trimKey(stored) end
    end
    return key
end

local function requestHeaders(key, device, executor)
    local headers = {
        ["Content-Type"] = "application/json", ["Authorization"] = "Bearer " .. key,
        ["X-Vitality-HWID"] = device, ["X-Vitality-Executor"] = executor
    }
    if requestedRelease then headers["X-Vitality-Release"] = requestedRelease end
    local player = Players.LocalPlayer
    if player then
        headers["X-Vitality-Roblox-UserId"] = tostring(player.UserId)
        headers["X-Vitality-Roblox-Username"] = player.Name
        headers["X-Vitality-Roblox-DisplayName"] = HttpService:UrlEncode(player.DisplayName)
    end
    return headers
end

local function getModule(key)
    key = trimKey(key)
    if #key ~= 47 or key:sub(1, 4) ~= "VTL-" or key:sub(5):find("[^%w_-]") then
        clearWebsiteKey()
        return nil, "Enter a valid Vitality key.", nil, true
    end
    local getDevice = gethwid or get_hwid
    local deviceOk, device = false, nil
    if type(getDevice) == "function" then deviceOk, device = pcall(getDevice) end
    device = deviceOk and trimKey(device) or ""
    if device == "" or #device > 256 or device:find("[^!-~]") then
        return nil, "Your executor needs gethwid support. Contact Vitality support."
    end
    local executor = "unknown"
    if type(identifyexecutor) == "function" then
        local identified, name = pcall(identifyexecutor)
        if identified and type(name) == "string" then executor = name:sub(1, 100) end
    end
    local function requestServer(path, body, pinnedRelease)
        local headers = requestHeaders(key, device, executor)
        if pinnedRelease then headers["X-Vitality-Release"] = pinnedRelease end
        local ok, response = pcall(send, {
            Url = "https://vitalitys.lol" .. path, Method = "POST",
            Headers = headers,
            Body = body and HttpService:JSONEncode(body) or nil
        })
        if not ok or type(response) ~= "table" then
            return nil, "Could not reach Vitality. Please try again.", false
        end
        local status = tonumber(response.StatusCode or response.Status) or 0
        if status ~= 200 then
            if path == "/api/keys/validate" and status == 403 then
                local parsed, denied = pcall(HttpService.JSONDecode, HttpService, response.Body or response.body or "")
                if parsed and type(denied) == "table" and denied.code == "DISCORD_LINK_REQUIRED" then
                    return nil, "Link your Discord account in My keys on vitalitys.lol, then run the loader again.", false
                end
            end
            local definitive = status == 401 or status == 403
            if definitive then clearWebsiteKey() end
            local messages = {
                [401] = "Your key is invalid, expired, revoked or no longer eligible. Enter a new key.",
                [403] = "This key belongs to another HWID. Contact Vitality support for a reset.",
                [404] = "This script is unavailable or individual delivery is disabled.",
                [409] = "Script or key access changed. Please try again.",
                [429] = "Too many requests. Wait before trying again.",
            }
            return nil, messages[status] or "Vitality is temporarily unavailable. Please try again.", definitive
        end
        local responseBody = response.Body or response.body
        if type(responseBody) ~= "string" or responseBody == "" then
            return nil, "Vitality returned an empty response. Please try again.", false
        end
        local headers = response.Headers or response.headers
        return {Body = responseBody, Headers = type(headers) == "table" and headers or {}}
    end
    local validated, errorMessage, definitive = requestServer("/api/keys/validate")
    if not validated then return nil, errorMessage, nil, definitive end
    local decoded, license = pcall(HttpService.JSONDecode, HttpService, validated.Body)
    if decoded and type(license) == "table" and license.valid == false then
        clearWebsiteKey()
        return nil, "Your key is invalid or expired. Enter a new key.", nil, true
    end
    if not decoded or type(license) ~= "table" or license.valid ~= true
        or (license.kind ~= "free" and license.kind ~= "premium")
        or type(license.serverTime) ~= "number" or license.serverTime ~= license.serverTime
        or license.serverTime <= 0 or license.serverTime == math.huge
        or not validated.Body:match('"expiresAt"%s*:')
        or (license.expiresAt ~= nil and (type(license.expiresAt) ~= "number"
            or license.expiresAt ~= license.expiresAt or math.abs(license.expiresAt) == math.huge)) then
        return nil, "Vitality returned an invalid license response. Please try again."
    end
    if license.expiresAt and license.expiresAt <= license.serverTime then
        clearWebsiteKey()
        return nil, "Your key has expired. Enter a new key.", nil, true
    end
    -- Only a complete, current server-validated license enters either cache.
    rememberWebsiteKey(key)
    local response
    -- Context modules always initialize through the shared main loader/library.
    response, errorMessage, definitive = requestServer("/api/script", {gameId = game.GameId, placeId = game.PlaceId, script = "mainloaderls"})
    if not response then return nil, errorMessage, nil, definitive end
    local contentType = ""
    for name, value in pairs(response.Headers) do
        if tostring(name):lower() == "content-type" then contentType = tostring(value):lower() end
    end
    if not contentType:find("text/plain", 1, true) or response.Body:match("^%s*[{[]") or response.Body:match("^%s*<") then
        return nil, "Vitality returned a non-Lua response. Please try again."
    end
    local compiled, chunk = pcall(loadstring, response.Body, "Vitality Hub")
    if not compiled or type(chunk) ~= "function" then
        return nil, "The published script could not be compiled. Contact Vitality support."
    end
    local deliveryId, releaseId
    for name, value in pairs(response.Headers) do
        if tostring(name):lower() == "x-vitality-delivery" then deliveryId = tostring(value) end
        if tostring(name):lower() == "x-vitality-release" then releaseId = tostring(value) end
    end
    local wanted = requestedScript or (targetScript ~= "mainloaderls" and targetScript or nil)
    if wanted then
        if not releaseId then return nil, "Vitality returned an invalid release selector." end
        local selected, selectionError = requestServer("/api/script/resolve", {gameId=game.GameId, placeId=game.PlaceId, script=wanted}, releaseId)
        if not selected then return nil, selectionError end
        local parsed, selection = pcall(HttpService.JSONDecode, HttpService, selected.Body)
        if not parsed or type(selection) ~= "table" or selection.script ~= wanted or selection.release ~= releaseId then
            return nil, "This individual script does not match the current game. Run the main hub loader."
        end
    end
    return chunk, nil, {deliveryId = deliveryId, device = device, executor = executor, releaseId = releaseId}
end

local function runModule(chunk, key, receipt)
    environment.key = key
    local function report(status)
        if not receipt or not receipt.deliveryId then return end
        pcall(send, {
            Url = "https://vitalitys.lol/api/script/execution", Method = "POST",
            Headers = requestHeaders(key, receipt.device, receipt.executor),
            Body = HttpService:JSONEncode({deliveryId = receipt.deliveryId, status = status})
        })
    end
    task.spawn(function()
        task.spawn(report, "started")
        local ok = pcall(chunk, {Key = key, Release = receipt and receipt.releaseId})
        if not ok then
            task.spawn(report, "error")
            warn("Vitality reported a script error. Contact support.")
        end
    end)
end

local initialKey = readWebsiteKey()
local initialError
if initialKey ~= "" then
    local chunk, errorMessage, receipt, definitive = getModule(initialKey)
    if chunk then runModule(chunk, initialKey, receipt) return end
    initialError = errorMessage
    if definitive then initialKey = "" end
end

local player = Players.LocalPlayer
if not player then warn("Vitality must be run on the client.") return end
local parent = player:WaitForChild("PlayerGui")
local existing = parent:FindFirstChild("VitalityKeyScreen")
if existing then existing:Destroy() end
local gui = Instance.new("ScreenGui")
gui.Name = "VitalityKeyScreen"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 100000
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = parent
local panel = Instance.new("Frame")
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.fromScale(0.5, 0.5)
panel.Size = UDim2.new(0.88, 0, 0, 316)
panel.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
panel.BorderSizePixel = 0
panel.Parent = gui
local constraint = Instance.new("UISizeConstraint")
constraint.MaxSize = Vector2.new(430, 316)
constraint.Parent = panel
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = panel
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(65, 65, 65)
stroke.Parent = panel

local function label(text, top, height, size, color)
    local value = Instance.new("TextLabel")
    value.Position = UDim2.new(0, 26, 0, top)
    value.Size = UDim2.new(1, -52, 0, height)
    value.BackgroundTransparency = 1
    value.Font = Enum.Font.Gotham
    value.Text = text
    value.TextSize = size
    value.TextColor3 = color or Color3.fromRGB(235, 235, 235)
    value.TextXAlignment = Enum.TextXAlignment.Left
    value.TextWrapped = true
    value.Parent = panel
    return value
end
local title = label("vitalitys.lol", 24, 30, 25)
title.Font = Enum.Font.GothamBold
label("Enter your key to open Vitality Hub.", 64, 28, 14, Color3.fromRGB(160, 160, 160))
local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(32, 32)
close.Position = UDim2.new(1, -48, 0, 22)
close.Text = "X"
close.Font = Enum.Font.Gotham
close.TextSize = 16
close.TextColor3 = Color3.fromRGB(170, 170, 170)
close.BackgroundTransparency = 1
close.Parent = panel
close.Activated:Connect(function() gui:Destroy() end)

local input = Instance.new("TextBox")
input.Position = UDim2.new(0, 26, 0, 111)
input.Size = UDim2.new(1, -52, 0, 46)
input.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
input.BorderSizePixel = 0
input.TextColor3 = Color3.fromRGB(235, 235, 235)
input.PlaceholderColor3 = Color3.fromRGB(115, 115, 115)
input.PlaceholderText = "Paste your key"
input.Text = initialKey
input.ClearTextOnFocus = false
input.Font = Enum.Font.Code
input.TextSize = 15
input.TextXAlignment = Enum.TextXAlignment.Left
input.Parent = panel
local inputPadding = Instance.new("UIPadding")
inputPadding.PaddingLeft = UDim.new(0, 12)
inputPadding.PaddingRight = UDim.new(0, 12)
inputPadding.Parent = input
local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = input

local function button(text, position, size, primary)
    local value = Instance.new("TextButton")
    value.Position = position
    value.Size = size
    value.BackgroundColor3 = primary and Color3.fromRGB(235, 235, 235) or Color3.fromRGB(31, 31, 31)
    value.TextColor3 = primary and Color3.fromRGB(10, 10, 10) or Color3.fromRGB(220, 220, 220)
    value.BorderSizePixel = 0
    value.Font = Enum.Font.GothamMedium
    value.TextSize = 14
    value.Text = text
    value.Parent = panel
    local rounding = Instance.new("UICorner")
    rounding.CornerRadius = UDim.new(0, 6)
    rounding.Parent = value
    return value
end
local submit = button("Open hub", UDim2.new(0, 26, 0, 173), UDim2.new(0.56, -31, 0, 44), true)
local getKey = button("Get a key", UDim2.new(0.56, 5, 0, 173), UDim2.new(0.44, -31, 0, 44), false)
local message = label(initialError or "Free keys: vitalitys.lol/free-key", 231, 60, 13, Color3.fromRGB(160, 160, 160))
local busy = false
local function submitKey()
    if busy then return end
    busy = true
    submit.Text = "Checking..."
    message.Text = "Checking your key and game..."
    local key = trimKey(input.Text)
    local chunk, errorMessage, receipt, definitive = getModule(key)
    if not gui.Parent then return end
    if chunk then gui:Destroy() runModule(chunk, key, receipt) return end
    if definitive then input.Text = "" end
    message.Text = errorMessage
    submit.Text = "Open hub"
    busy = false
end
submit.Activated:Connect(submitKey)
input.FocusLost:Connect(function(enterPressed) if enterPressed then submitKey() end end)
getKey.Activated:Connect(function()
    local clipboard = setclipboard or toclipboard
    local ok = type(clipboard) == "function" and pcall(clipboard, "https://vitalitys.lol/free-key")
    message.Text = ok and "Key-page link copied. Open it in your browser." or "Open https://vitalitys.lol/free-key in your browser."
end)
