-- Voltils logo: Downloads/Voltils.png, revision ac791f1c, cache repair v2.
do
    pcall(function()
    local env = (getgenv and getgenv()) or _G
    local revision = "ac791f1c"
    if env.VoltilsBrandRevision ~= revision or env.VoltilsBrandVersion ~= 2 then
        local path = "VoltilsAssets/VoltilsLogo-" .. revision .. "-v2.png"
        local customAsset = getcustomasset or getsynasset
        local asset
        if type(customAsset) == "function" and type(writefile) == "function" then
            local ok, result = pcall(function()
                if type(makefolder) == "function" and (type(isfolder) ~= "function" or not isfolder("VoltilsAssets")) then
                    pcall(makefolder, "VoltilsAssets")
                end
                local function isPNG(body)
                    return type(body) == "string" and body:sub(1, 8) == "\137PNG\13\10\26\10"
                end
                local cached = false
                if type(isfile) == "function" and isfile(path) and type(readfile) == "function" then
                    local valid, body = pcall(readfile, path)
                    cached = valid and isPNG(body)
                end
                if not cached then
                    local url = "https://voltils.cc/assets/voltils-script-logo-ac791f1c.png"
                    local success, body = pcall(function() return game:HttpGet(url) end)
                    if not success or not isPNG(body) then
                        local req = request or http_request or (http and http.request) or (fluxus and fluxus.request)
                        if type(req) == "function" then
                            local response = req({Url = url, Method = "GET"})
                            body = type(response) == "table" and (response.Body or response.body)
                        end
                    end
                    assert(type(body) == "string" and body:sub(1, 8) == "\137PNG\13\10\26\10", "Logo download was not a PNG")
                    writefile(path, body)
                end
                return customAsset(path)
            end)
            if ok and type(result) == "string" and result ~= "" then asset = result end
        end
        if asset then
            env.VoltilsBrandAsset = asset
            env.VoltilsBrandRevision = revision
            env.VoltilsBrandVersion = 2
            local ids = { ["75621515979706"] = true, ["93061773121162"] = true,
                ["83267942683828"] = true, ["7488932274"] = true }
            local function update(object)
                if object:IsA("ImageLabel") or object:IsA("ImageButton") then
                    local image = tostring(object.Image)
                    local id = image:match("rbxassetid://(%d+)") or image:match("[?&]id=(%d+)") or image:match("^(%d+)$")
                    if ids[id] or (image:find("VoltilsLogo-", 1, true) and image ~= asset) then
                        object.Image = asset
                        object.ImageColor3 = Color3.fromRGB(255, 255, 255)
                        object.ScaleType = Enum.ScaleType.Fit
                    end
                end
            end
            local roots, seen = {}, {}
            local function add(root)
                if root and not seen[root] then seen[root] = true; table.insert(roots, root) end
            end
            if type(gethui) == "function" then pcall(function() add(gethui()) end) end
            pcall(function() add(game:GetService("CoreGui")) end)
            pcall(function() add(game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")) end)
            for _, root in ipairs(roots) do
                root.DescendantAdded:Connect(function(object)
                    task.defer(function() pcall(update, object) end)
                    task.delay(0.5, function() if object.Parent then pcall(update, object) end end)
                end)
            end
            task.spawn(function()
                -- Catch libraries that assign their logo after parenting the GUI.
                for _ = 1, 40 do
                    for _, root in ipairs(roots) do
                        for _, object in ipairs(root:GetDescendants()) do pcall(update, object) end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
    end)
end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer
local HttpRequest =
    (type(request) == "function" and request)
    or (type(http_request) == "function" and http_request)
    or (type(syn) == "table" and type(syn.request) == "function" and syn.request)
    or (type(http) == "table" and type(http.request) == "function" and http.request)

local LOADER_ID = "sE9MLA"
local BASE_URL = "https://voltils.cc"
local generatedSession = nil

local function requestJson(url)
    local ok, body = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok then
        return nil, tostring(body)
    end
    local decodedOk, decoded = pcall(function()
        return HttpService:JSONDecode(body)
    end)
    if not decodedOk then
        return nil, "Invalid server response"
    end
    return decoded
end

local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 6
        })
    end)
end

local gameName = "Current Game"
pcall(function()
    local info = MarketplaceService:GetProductInfo(game.PlaceId)
    if info and info.Name then
        gameName = info.Name
    end
end)

local sessionUrl = BASE_URL .. "/api/key/session?loader=" .. HttpService:UrlEncode(LOADER_ID)
    .. "&robloxUserId=" .. HttpService:UrlEncode(tostring(player.UserId))
    .. "&robloxUsername=" .. HttpService:UrlEncode(player.Name)
    .. "&placeId=" .. HttpService:UrlEncode(tostring(game.PlaceId))
    .. "&gameName=" .. HttpService:UrlEncode(gameName)

local deviceTokenPath = "VoltilsLoader/access_" .. LOADER_ID .. "_" .. tostring(player.UserId) .. ".txt"
local function readDeviceToken()
    if type(readfile) ~= "function" then return nil end
    local ok, value = pcall(function() return readfile(deviceTokenPath) end)
    if ok and type(value) == "string" and value ~= "" then return value end
    return nil
end

local function saveDeviceToken(token)
    if type(writefile) ~= "function" or type(token) ~= "string" or token == "" then return false end
    pcall(function()
        if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder("VoltilsLoader") then
            makefolder("VoltilsLoader")
        end
    end)
    return pcall(function() writefile(deviceTokenPath, token) end)
end

local function clearDeviceToken()
    if type(delfile) == "function" then pcall(function() delfile(deviceTokenPath) end) end
end

local function requestProtectedPayload(key, deviceToken, sessionId)
    if type(HttpRequest) ~= "function" then return nil, "This executor does not provide the request function required to load scripts." end
    local body = { loader = LOADER_ID, robloxUserId = tostring(player.UserId) }
    if key and key ~= "" then body.key = key end
    if deviceToken and deviceToken ~= "" then body.deviceToken = deviceToken end
    if sessionId and sessionId ~= "" then body.sessionId = sessionId end
    local ok, response = pcall(function()
        return HttpRequest({
            Url = BASE_URL .. "/api/key/validate",
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(body),
        })
    end)
    if not ok then return nil, tostring(response) end
    local responseBody = type(response) == "table" and (response.Body or response.body) or nil
    if type(responseBody) ~= "string" then return nil, "The server returned an unreadable response." end
    local decodedOk, decoded = pcall(function() return HttpService:JSONDecode(responseBody) end)
    if not decodedOk then return nil, "The server returned invalid JSON." end
    return decoded
end

local function runProtectedPayload(result)
    local chunk, compileError = loadstring(result.code or "")
    if not chunk then return false, compileError end
    local runOk, runError = pcall(chunk)
    if not runOk then return false, runError end
    return true
end

local cachedDeviceToken = readDeviceToken()
if cachedDeviceToken then
    local result = requestProtectedPayload(nil, cachedDeviceToken)
    if result and result.ok then
        local loaded = runProtectedPayload(result)
        if loaded then
            notify("Voltils", "Remembered device verified. Loading...")
            return
        end
    elseif result then
        clearDeviceToken()
    end
end

local initialSession = requestJson(sessionUrl)
if initialSession and initialSession.ok and initialSession.id then
    generatedSession = initialSession.id
end

local gui = Instance.new("ScreenGui")
gui.Name = "VoltilsKeySystem"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(500, 392)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(8, 9, 12)
frame.BorderSizePixel = 0
frame.Parent = gui

local dragging = false
local dragStart = nil
local startPosition = nil
local UserInputService = game:GetService("UserInputService")
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = frame.Position
    end
end)
frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = frame.Position:Lerp(
            UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y),
            0.35
        )
    end
end)

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(42, 45, 52)
stroke.Thickness = 1
stroke.Parent = frame

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 18)
padding.PaddingRight = UDim.new(0, 18)
padding.PaddingBottom = UDim.new(0, 18)
padding.PaddingLeft = UDim.new(0, 18)
padding.Parent = frame

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 32)
title.Font = Enum.Font.GothamBold
title.Text = "Voltils Key"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 24
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local close = Instance.new("TextButton")
close.BackgroundColor3 = Color3.fromRGB(24, 25, 30)
close.BorderSizePixel = 0
close.Position = UDim2.new(1, -30, 0, 0)
close.Size = UDim2.fromOffset(30, 30)
close.Font = Enum.Font.GothamBold
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.TextSize = 14
close.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = close

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local cards = Instance.new("Frame")
cards.BackgroundTransparency = 1
cards.Position = UDim2.fromOffset(0, 46)
cards.Size = UDim2.new(1, 0, 0, 96)
cards.Parent = frame

local list = Instance.new("UIListLayout")
list.FillDirection = Enum.FillDirection.Horizontal
list.Padding = UDim.new(0, 10)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = cards

local function makeDetectedCard(label, value, image)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.5, -5, 1, 0)
    card.BackgroundColor3 = Color3.fromRGB(18, 19, 24)
    card.BorderSizePixel = 0
    card.Parent = cards

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 8)
    cardCorner.Parent = card

    local avatar = Instance.new("ImageLabel")
    avatar.BackgroundColor3 = Color3.fromRGB(28, 30, 36)
    avatar.BorderSizePixel = 0
    avatar.Position = UDim2.fromOffset(12, 16)
    avatar.Size = UDim2.fromOffset(64, 64)
    avatar.Image = image
    avatar.Parent = card

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(0, 8)
    avatarCorner.Parent = avatar

    local heading = Instance.new("TextLabel")
    heading.BackgroundTransparency = 1
    heading.Position = UDim2.fromOffset(88, 18)
    heading.Size = UDim2.new(1, -100, 0, 20)
    heading.Font = Enum.Font.GothamBold
    heading.Text = label
    heading.TextColor3 = Color3.fromRGB(42, 211, 238)
    heading.TextSize = 13
    heading.TextXAlignment = Enum.TextXAlignment.Left
    heading.Parent = card

    local body = Instance.new("TextLabel")
    body.BackgroundTransparency = 1
    body.Position = UDim2.fromOffset(88, 42)
    body.Size = UDim2.new(1, -100, 0, 36)
    body.Font = Enum.Font.Gotham
    body.Text = value
    body.TextColor3 = Color3.fromRGB(242, 244, 248)
    body.TextSize = 14
    body.TextWrapped = true
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.TextYAlignment = Enum.TextYAlignment.Top
    body.Parent = card
end

makeDetectedCard("User Detected", player.Name .. " (" .. tostring(player.UserId) .. ")", "rbxthumb://type=AvatarHeadShot&id=" .. tostring(player.UserId) .. "&w=150&h=150")
makeDetectedCard("Game Detected", gameName, "rbxthumb://type=GameIcon&id=" .. tostring(game.PlaceId) .. "&w=150&h=150")

local desc = Instance.new("TextLabel")
desc.BackgroundTransparency = 1
desc.Position = UDim2.fromOffset(0, 156)
desc.Size = UDim2.new(1, 0, 0, 38)
desc.Font = Enum.Font.Gotham
desc.Text = "Login with Discord to generate a 24h key tied to this Roblox account."
desc.TextColor3 = Color3.fromRGB(174, 179, 190)
desc.TextSize = 14
desc.TextWrapped = true
desc.TextXAlignment = Enum.TextXAlignment.Left
desc.TextYAlignment = Enum.TextYAlignment.Top
desc.Parent = frame

local linkBox = Instance.new("TextBox")
linkBox.Position = UDim2.fromOffset(0, 202)
linkBox.Size = UDim2.new(1, 0, 0, 42)
linkBox.BackgroundColor3 = Color3.fromRGB(20, 21, 26)
linkBox.BorderSizePixel = 0
linkBox.ClearTextOnFocus = false
linkBox.Font = Enum.Font.Code
linkBox.Text = "Press Generate Link to copy your login link."
linkBox.TextColor3 = Color3.fromRGB(255, 255, 255)
linkBox.TextSize = 13
linkBox.TextXAlignment = Enum.TextXAlignment.Left
linkBox.Parent = frame

local linkCorner = Instance.new("UICorner")
linkCorner.CornerRadius = UDim.new(0, 8)
linkCorner.Parent = linkBox

local generate = Instance.new("TextButton")
generate.Position = UDim2.fromOffset(0, 202)
generate.Size = UDim2.new(1, 0, 0, 42)
generate.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
generate.BorderSizePixel = 0
generate.Font = Enum.Font.GothamBold
generate.Text = "Generate Link"
generate.TextColor3 = Color3.fromRGB(8, 8, 10)
generate.TextSize = 14
generate.Parent = frame
local generateCorner = Instance.new("UICorner")
generateCorner.CornerRadius = UDim.new(0, 8)
generateCorner.Parent = generate

linkBox.Visible = false

generate.MouseButton1Click:Connect(function()
    generate.Text = "Generating..."
    local session, sessionError = initialSession, nil
    if not session or not session.ok then session, sessionError = requestJson(sessionUrl) end
    if not session or not session.ok then
        generate.Text = "Generate Link"
        notify("Voltils", sessionError or (session and session.error) or "Could not generate link")
        return
    end
    if session.id then generatedSession = session.id end
    if session.hasValidKey then
        generate.Text = "Recovery Link Copied"
        if type(setclipboard) == "function" then
            setclipboard(session.loginUrl)
        else
            linkBox.Text = session.loginUrl
            linkBox.Visible = true
        end
        notify("Voltils", "Active key found. Sign into the Discord account that owns it; this device will resume automatically.")
        task.spawn(function()
            for _ = 1, 180 do
                if not generatedSession then return end
                local statusUrl = BASE_URL .. "/api/key/session?id=" .. HttpService:UrlEncode(generatedSession)
                local state = requestJson(statusUrl)
                if state and state.ok and state.keyCode then
                    local payload = requestProtectedPayload(nil, nil, generatedSession)
                    if payload and payload.ok then
                        saveDeviceToken(payload.deviceToken)
                        gui:Destroy()
                        local loaded, loadError = runProtectedPayload(payload)
                        if not loaded then warn("[Voltils] Protected loader failed:", loadError) end
                        return
                    end
                end
                task.wait(2)
            end
        end)
        return
    end
    if type(setclipboard) == "function" then
        setclipboard(session.loginUrl)
        generate.Text = "Link Copied"
        notify("Voltils", "Link copied to your clipboard - paste into a browser to continue")
    else
        linkBox.Text = session.loginUrl
        linkBox.Visible = true
        generate.Text = "Copy Manually"
        notify("Voltils", "Copy the link and paste it into a browser to continue")
    end
end)

local keyBox = Instance.new("TextBox")
keyBox.Position = UDim2.fromOffset(0, 256)
keyBox.Size = UDim2.new(1, 0, 0, 42)
keyBox.BackgroundColor3 = Color3.fromRGB(20, 21, 26)
keyBox.BorderSizePixel = 0
keyBox.ClearTextOnFocus = false
keyBox.PlaceholderText = "Paste your 24h key here"
keyBox.Font = Enum.Font.Gotham
keyBox.Text = ""
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.TextSize = 14
keyBox.Parent = frame

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 8)
keyCorner.Parent = keyBox

local button = Instance.new("TextButton")
button.Position = UDim2.fromOffset(0, 310)
button.Size = UDim2.new(1, 0, 0, 38)
button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
button.BorderSizePixel = 0
button.Font = Enum.Font.GothamBold
button.Text = "Validate Key"
button.TextColor3 = Color3.fromRGB(8, 8, 10)
button.TextSize = 14
button.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = button

local footer = Instance.new("TextLabel")
footer.BackgroundTransparency = 1
footer.Position = UDim2.fromOffset(0, 358)
footer.Size = UDim2.new(1, 0, 0, 18)
footer.Font = Enum.Font.GothamBold
footer.Text = "Get a free key through Discord, or enter a key you already have."
footer.TextColor3 = Color3.fromRGB(34, 197, 94)
footer.TextSize = 12
footer.TextXAlignment = Enum.TextXAlignment.Center
footer.Parent = frame

if initialSession and initialSession.hasValidKey then
    generate.Text = "Recover Active Key"
    footer.Text = "Active key found. Continue with the Discord account that owns it; this device will remember access."
end

notify("Voltils", "Press Generate Link, authorize Discord, then paste your key.")

button.MouseButton1Click:Connect(function()
    local key = keyBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if key == "" then
        notify("Voltils", "Paste your key first.")
        return
    end

    button.Text = "Checking..."
    local result, requestError = requestProtectedPayload(key, nil, generatedSession)
    if result and result.ok then
        saveDeviceToken(result.deviceToken)
        button.Text = "Access Granted"
        notify("Voltils", "Key accepted. Loading script...")
        task.wait(0.5)
        gui:Destroy()
        local loaded, loadError = runProtectedPayload(result)
        if not loaded then warn("[Voltils] Protected loader failed:", loadError) end
    else
        button.Text = "Validate Key"
        notify("Voltils", (result and result.error) or requestError or "Could not validate key.")
    end
end)