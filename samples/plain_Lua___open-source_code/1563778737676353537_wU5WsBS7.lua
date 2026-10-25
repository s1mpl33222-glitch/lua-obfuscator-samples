-- made by FEScriptzzBOII
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

if _G.ScreenshareCleanup then
    pcall(_G.ScreenshareCleanup)
end

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Settings = {
    Resolution = "32x18",
    TargetFPS = 60,                  
    ColorTolerance = 6,
    MaxBatchSize = 5000,           
    Distance = 12,
    HeightOffset = 4,
    IsStreaming = false,
    ShowOnClient = true,
    BuildMode = "Serverside: F3x",
    ScreenSize = 14,                 
    VortexLight = 0,               
    PartMaterial = Enum.Material.SmoothPlastic 
}

local currentWidth = 32
local currentHeight = 18
local studsPerPixel = 14 / 32


local activeScreens = {}

local fetchLoopActive = true
local buildGeneration = 0
local stopBuildingRequested = false
local lastProcessedFrameId = 0

-- Performance tracking variables
local lastHttpLatency = 0
local f3xInvokeCount = 0
local lastF3xRate = 0

local httpReq =
    (syn and syn.request)
    or (http and http.request)
    or http_request
    or request

local function httpRequestAsync(url, callback)
    task.spawn(function()
        local startTime = os.clock()
        local body
        local headers = {}
        local success = false

        pcall(function()
            if httpReq then
                local response = httpReq({
                    Url = url,
                    Method = "GET"
                })

                if response and response.Body then
                    body = response.Body
                    headers = response.Headers or {}
                    success = true
                end
            else
                body = game:HttpGet(url, true)
                if body then success = true end
            end
        end)

        lastHttpLatency = math.round((os.clock() - startTime) * 1000)
        callback(body, headers, success)
    end)
end

local function findServerEndpoint()
    local player = Players.LocalPlayer
    if not player then return nil end

    local character = player.Character or player.CharacterAdded:Wait()
    local containers = {
        character,
        player:FindFirstChild("Backpack"),
        ReplicatedStorage,
        workspace
    }

    for _, container in ipairs(containers) do
        if container then
            for _, item in ipairs(container:GetDescendants()) do
                if (item.Name == "SyncAPI" or item.Name == "Fork3X")
                    and item:FindFirstChild("ServerEndpoint") then
                    return item:FindFirstChild("ServerEndpoint")
                end
            end
        end
    end

    return nil
end

local resolutions = {
    ["16x9"] = {16, 9},
    ["24x14"] = {24, 14},
    ["32x18"] = {32, 18},
    ["42x24"] = {42, 24},
    ["64x36"] = {64, 36},
    ["85x48"] = {85, 48},
    ["96x54"] = {96, 54},
    ["128x72"] = {128, 72},
    ["160x90"] = {160, 90},
    ["192x108"] = {192, 108},
    ["256x144 (144p)"] = {256, 144},
    ["320x180"] = {320, 180},
    ["400x225"] = {400, 225},
    ["480x270 (270p)"] = {480, 270},
    ["640x360 (360p)"] = {640, 360},
    ["854x480 (480p)"] = {854, 480},
    ["1280x720 (720p)"] = {1280, 720},
}

local function parseResolution()
    local name = type(Settings.Resolution) == "table" and Settings.Resolution[1] or Settings.Resolution
    local res = resolutions[name]

    if res then
        currentWidth = res[1]
        currentHeight = res[2]
    else
        currentWidth = 32
        currentHeight = 18
    end
    studsPerPixel = Settings.ScreenSize / currentWidth
end

parseResolution()

local function invokeChunked(ServerEndpoint, action, dataTable)
    if #dataTable == 0 then return end
    local maxChunk = Settings.MaxBatchSize

    for i = 1, #dataTable, maxChunk do
        local chunk = {}
        local lastIndex = math.min(i + maxChunk - 1, #dataTable)
        for j = i, lastIndex do
            chunk[#chunk + 1] = dataTable[j]
        end

        task.defer(function()
            pcall(function()
                ServerEndpoint:InvokeServer(action, chunk)
                f3xInvokeCount += 1
            end)
        end)
    end
end

local function updateVortexLight()
    for _, screenData in ipairs(activeScreens) do
        local light = screenData.surfaceLight
        if not light and screenData.localCanvasPart then
            light = Instance.new("SurfaceLight")
            light.Face = Enum.NormalId.Front
            light.Range = 30
            light.Parent = screenData.localCanvasPart
            screenData.surfaceLight = light
        elseif not light and #screenData.partGrid > 0 then
            local midY = math.floor(screenData.height / 2)
            local midX = math.floor(screenData.width / 2)
            local centerPart = screenData.partGrid[midY] and screenData.partGrid[midY][midX]
            if centerPart then
                light = Instance.new("SurfaceLight")
                light.Face = Enum.NormalId.Front
                light.Range = 30
                light.Parent = centerPart
                screenData.surfaceLight = light
            end
        end
        if light then
            light.Brightness = Settings.VortexLight
            light.Enabled = Settings.VortexLight > 0
        end
    end
end

local function updateClientVisibility()
    local transparency = Settings.ShowOnClient and 0 or 1
    for _, screenData in ipairs(activeScreens) do
        if screenData.localCanvasPart then
            screenData.localCanvasPart.Transparency = transparency
        end
        if screenData.partGrid then
            for y = 1, #screenData.partGrid do
                local row = screenData.partGrid[y]
                if row then
                    for x = 1, #row do
                        local part = row[x]
                        if part then
                            pcall(function()
                                part.LocalTransparencyModifier = transparency
                            end)
                        end
                    end
                end
            end
        end
    end
end

local function deleteAllScreens()
    buildGeneration += 1

    local ServerEndpoint = findServerEndpoint()
    local destroyBatch = {}

    for _, screenData in ipairs(activeScreens) do
        if screenData.localCanvasPart then
            screenData.localCanvasPart:Destroy()
        end
        if screenData.partGrid then
            for y = 1, #screenData.partGrid do
                local row = screenData.partGrid[y]
                if row then
                    for x = 1, #row do
                        local part = row[x]
                        if part then
                            destroyBatch[#destroyBatch + 1] = part
                        end
                    end
                end
            end
        end
    end

    if ServerEndpoint and #destroyBatch > 0 then
        invokeChunked(ServerEndpoint, "Remove", destroyBatch)
    end

    activeScreens = {}
    Rayfield:Notify({Title = "Screen Status", Content = "All screens successfully deleted.", Duration = 2})
end

_G.ScreenshareCleanup = function()
    fetchLoopActive = false
    Settings.IsStreaming = false
    pcall(deleteAllScreens)
end

local function buildScreen()
    parseResolution()
    stopBuildingRequested = false
    buildGeneration += 1
    local myGeneration = buildGeneration

    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart", 5)

    if not root then return end

    local spawnCFrame = root.CFrame * CFrame.new(0, Settings.HeightOffset, -Settings.Distance - (#activeScreens * 2))

    if Settings.BuildMode == "clientside: SurfaceGui" then
        local Canvas = Instance.new("Part")
        Canvas.Name = "ClientScreenCanvas"
        Canvas.Size = Vector3.new(currentWidth * studsPerPixel, currentHeight * studsPerPixel, 0.2)
        Canvas.CFrame = spawnCFrame
        Canvas.Anchored = true
        Canvas.CanCollide = false
        Canvas.Transparency = Settings.ShowOnClient and 0 or 1
        Canvas.Parent = workspace

        local SGui = Instance.new("SurfaceGui")
        SGui.CanvasSize = Vector2.new(currentWidth, currentHeight)
        SGui.Adornee = Canvas
        SGui.Face = Enum.NormalId.Front
        SGui.Parent = Canvas

        local guiPixels = {}
        for y = 1, currentHeight do
            guiPixels[y] = table.create(currentWidth)
            for x = 1, currentWidth do
                local pixel = Instance.new("Frame")
                pixel.Size = UDim2.new(1 / currentWidth, 0, 1 / currentHeight, 0)
                pixel.Position = UDim2.new((x - 1) / currentWidth, 0, (y - 1) / currentHeight, 0)
                pixel.BorderSizePixel = 0
                pixel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                pixel.Parent = SGui
                guiPixels[y][x] = pixel
            end
        end

        local screenData = {
            width = currentWidth,
            height = currentHeight,
            partGrid = {},
            lastColors = {},
            localCanvasPart = Canvas,
            surfaceGui = SGui,
            guiPixels = guiPixels,
            surfaceLight = nil
        }
        table.insert(activeScreens, screenData)
        updateVortexLight()
        
        Rayfield:Notify({Title = "Build Status", Content = "Clientside SurfaceGui screen spawned!", Duration = 2})
        return
    end

    local ServerEndpoint = findServerEndpoint()
    if not ServerEndpoint then
        Rayfield:Notify({Title = "Error", Content = "F3X ServerEndpoint missing!", Duration = 3})
        return
    end

    local pixelW = studsPerPixel
    local pixelH = studsPerPixel

    local partGrid = {}
    local lastColors = {}

    for y = 1, currentHeight do
        partGrid[y] = table.create(currentWidth)
        lastColors[y] = table.create(currentWidth)
    end

    local screenData = {
        width = currentWidth,
        height = currentHeight,
        partGrid = partGrid,
        lastColors = lastColors,
        localCanvasPart = nil,
        surfaceLight = nil
    }
    table.insert(activeScreens, screenData)

    local totalParts = currentWidth * currentHeight
    local spawnedCount = 0

    local resizeBatch = {}
    local collisionBatch = {}
    local materialBatch = {}

    local workerThreads = 25
    local jobQueue = table.create(totalParts)

    for y = 1, currentHeight do
        for x = 1, currentWidth do
            jobQueue[#jobQueue + 1] = {x = x, y = y}
        end
    end

    local queueIndex = 1

    for w = 1, workerThreads do
        task.spawn(function()
            while queueIndex <= totalParts and myGeneration == buildGeneration do
                if stopBuildingRequested then break end

                local currentJobIndex = queueIndex
                queueIndex += 1

                local job = jobQueue[currentJobIndex]
                if not job then break end

                local x, y = job.x, job.y
                local offset = spawnCFrame * CFrame.new(
                    (x - 0.5 - currentWidth / 2) * pixelW,
                    (currentHeight / 2 - y + 0.5) * pixelH,
                    0
                )

                task.spawn(function()
                    if stopBuildingRequested then return end
                    local success, result = pcall(function()
                        return ServerEndpoint:InvokeServer("CreatePart", "Normal", offset, workspace)
                    end)

                    if success and myGeneration == buildGeneration then
                        local spawnedPart = type(result) == "table" and result[1] or result
                        if spawnedPart then
                            pcall(function()
                                spawnedPart.LocalTransparencyModifier = Settings.ShowOnClient and 0 or 1
                            end)

                            partGrid[y][x] = spawnedPart
                            lastColors[y][x] = -1

                            resizeBatch[#resizeBatch + 1] = {Part = spawnedPart, Size = Vector3.new(pixelW, pixelH, 0.02), CFrame = offset}
                            collisionBatch[#collisionBatch + 1] = {Part = spawnedPart, CanCollide = false}
                            materialBatch[#materialBatch + 1] = {Part = spawnedPart, Material = Settings.PartMaterial}
                        end
                    end
                    spawnedCount += 1
                end)
            end
        end)
    end

    while spawnedCount < totalParts do
        if myGeneration ~= buildGeneration or stopBuildingRequested then return end
        task.wait()
    end

    invokeChunked(ServerEndpoint, "SyncResize", resizeBatch)
    invokeChunked(ServerEndpoint, "SyncCollision", collisionBatch)
    invokeChunked(ServerEndpoint, "SyncMaterial", materialBatch)
    updateVortexLight()
    
    Rayfield:Notify({Title = "Build Status", Content = "F3X screen successfully spawned!", Duration = 2})
end

local function moveScreen()
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart", 5)
    if not root then return end

    local targetCFrame = root.CFrame * CFrame.new(0, Settings.HeightOffset, -Settings.Distance)

    local screenData = activeScreens[#activeScreens]
    if not screenData then return end

    if screenData.localCanvasPart then
        screenData.localCanvasPart.CFrame = targetCFrame
        return
    end

    local ServerEndpoint = findServerEndpoint()
    if not ServerEndpoint or #screenData.partGrid == 0 then return end

    local pixelW = studsPerPixel
    local pixelH = studsPerPixel
    local moveBatch = {}

    for y = 1, screenData.height do
        local row = screenData.partGrid[y]
        if row then
            for x = 1, screenData.width do
                local part = row[x]
                if part then
                    local offset = targetCFrame * CFrame.new(
                        (x - 0.5 - screenData.width / 2) * pixelW,
                        (screenData.height / 2 - y + 0.5) * pixelH,
                        0
                    )
                    moveBatch[#moveBatch + 1] = {Part = part, CFrame = offset}
                end
            end
        end
    end

    invokeChunked(ServerEndpoint, "SyncMove", moveBatch)
    Rayfield:Notify({Title = "Screen Status", Content = "Latest screen moved to you.", Duration = 2})
end

local function decodeToBuffer(b64Str)
    if buffer and buffer.frombase64 then
        local success, buf = pcall(buffer.frombase64, b64Str)
        if success and buf then return buf end
    end

    local cryptDecode = (crypt and crypt.base64decode) or base64_decode or (syn and syn.crypt and syn.crypt.base64.decode)
    if cryptDecode then
        local success, decoded = pcall(cryptDecode, b64Str)
        if success and decoded then return buffer.fromstring(decoded) end
    end

    return nil
end

local function processFrame(rawBuf)
    if not rawBuf then return end
    local bufLen = buffer.len(rawBuf)
    local readu8 = buffer.readu8
    local fromRGB = Color3.fromRGB
    local abs = math.abs
    local bor = bit32.bor
    local lshift = bit32.lshift
    local rshift = bit32.rshift
    local band = bit32.band

    local tolerance = Settings.ColorTolerance
    local maxBatch = Settings.MaxBatchSize
    local ServerEndpoint = findServerEndpoint()

    for _, screenData in ipairs(activeScreens) do
        local ptr = 0
        if screenData.localCanvasPart and screenData.guiPixels then
            for y = 1, screenData.height do
                local row = screenData.guiPixels[y]
                if row then
                    for x = 1, screenData.width do
                        if ptr + 2 >= bufLen then break end
                        local pixel = row[x]
                        if pixel then
                            pixel.BackgroundColor3 = fromRGB(readu8(rawBuf, ptr), readu8(rawBuf, ptr + 1), readu8(rawBuf, ptr + 2))
                        end
                        ptr += 3
                    end
                end
            end
        elseif #screenData.partGrid > 0 and ServerEndpoint then
            local batch = {}
            for y = 1, screenData.height do
                local row = screenData.partGrid[y]
                local previousRow = screenData.lastColors[y]

                if row and previousRow then
                    for x = 1, screenData.width do
                        if ptr + 2 >= bufLen then break end

                        local part = row[x]
                        if part then
                            local r = readu8(rawBuf, ptr)
                            local g = readu8(rawBuf, ptr + 1)
                            local b = readu8(rawBuf, ptr + 2)

                            local packed = bor(lshift(r, 16), lshift(g, 8), b)
                            local previous = previousRow[x]

                            if previous == nil or previous == -1 or
                                abs(rshift(previous, 16) - r) > tolerance or
                                abs(band(rshift(previous, 8), 0xFF) - g) > tolerance or
                                abs(band(previous, 0xFF) - b) > tolerance then

                                previousRow[x] = packed
                                batch[#batch + 1] = {Part = part, Color = fromRGB(r, g, b)}
                            end

                            if #batch >= maxBatch then
                                invokeChunked(ServerEndpoint, "SyncColor", batch)
                                batch = {}
                            end
                        end
                        ptr += 3
                    end
                end
            end

            if #batch > 0 then
                invokeChunked(ServerEndpoint, "SyncColor", batch)
            end
        end
    end
end


task.spawn(function()
    local nextFrame = os.clock()
    local errorNotifyCooldown = 0
    local isProcessing = false

    while fetchLoopActive do
        if Settings.IsStreaming and #activeScreens > 0 then
            local targetFPS = math.clamp(Settings.TargetFPS, 1, 60)
            local interval = 1 / targetFPS
            nextFrame += interval

            if not isProcessing then
                isProcessing = true
                local targetW, targetH = currentWidth, currentHeight
                if #activeScreens > 0 then
                    targetW = activeScreens[1].width
                    targetH = activeScreens[1].height
                end

                local url = "http://127.0.0.1:5000/screen"
                    .. "?w=" .. targetW
                    .. "&h=" .. targetH
                    .. "&channels=3"

                httpRequestAsync(url, function(rawBody, headers, success)
                    if not success and os.clock() > errorNotifyCooldown then
                        errorNotifyCooldown = os.clock() + 10
                        Rayfield:Notify({
                            Title = "Stream Error",
                            Content = "Python stream not found! Ensure local server is running.",
                            Duration = 4
                        })
                        isProcessing = false
                        return
                    end

                    if rawBody and #rawBody > 0 then
                        task.defer(function()
                            pcall(function()
                                local frameId = 0
                                if headers then
                                    for k, v in pairs(headers) do
                                        if k:lower() == "x-frame-id" then
                                            frameId = tonumber(v) or 0
                                            break
                                        end
                                    end
                                end

                                if frameId > 0 and frameId <= lastProcessedFrameId then
                                    isProcessing = false
                                    return
                                end
                                if frameId > 0 then
                                    lastProcessedFrameId = frameId
                                end

                                local rawBuf = decodeToBuffer(rawBody)
                                if rawBuf then
                                    processFrame(rawBuf)
                                end
                            end)
                        end)
                    end
                    isProcessing = false
                end)
            end

            local waitTime = nextFrame - os.clock()
            if waitTime > 0 then 
                task.wait(waitTime) 
            else 
                nextFrame = os.clock() 
                task.wait() 
            end
        else
            task.wait(0.05)
            nextFrame = os.clock()
        end
    end
end)


local Window = Rayfield:CreateWindow({
    Name = "FE F3X Screenshare",
    LoadingTitle = "Made by FEScriptzzBOII"
})

local StreamTab = Window:CreateTab("Control", 4483362458)
local ConfigTab = Window:CreateTab("Settings", 4483362458)
local PerfTab = Window:CreateTab("Performance", 4483362458)

StreamTab:CreateSection("Requirements")
StreamTab:CreateParagraph({
    Title = "Setup Requirement",
    Content = "This script ONLY works on PC. You must run the Python script for the streaming to work."
})

StreamTab:CreateButton({
    Name = "Copy Pastebin Link",
    Callback = function()
        local setClip = setclipboard or toclipboard or (syn and syn.write_clipboard)
        if setClip then
            setClip("https://pastebin.com/fe7LLTNP")
            Rayfield:Notify({Title = "Success", Content = "Pastebin link copied to clipboard!", Duration = 2})
        else
            Rayfield:Notify({Title = "Error", Content = "Your executor does not support clipboard functions.", Duration = 3})
        end
    end
})

StreamTab:CreateSection("Stream Controls")

StreamTab:CreateToggle({
    Name = "Enable Stream",
    CurrentValue = false,
    Callback = function(value)
        Settings.IsStreaming = value
    end
})

StreamTab:CreateToggle({
    Name = "Show Screen on Client",
    CurrentValue = true,
    Callback = function(value)
        Settings.ShowOnClient = value
        updateClientVisibility()
    end
})

StreamTab:CreateButton({
    Name = "Build Screen",
    Callback = buildScreen
})

StreamTab:CreateButton({
    Name = "Move Screen",
    Callback = moveScreen
})

StreamTab:CreateButton({
    Name = "Stop Building",
    Callback = function()
        stopBuildingRequested = true
        Rayfield:Notify({Title = "Build Status", Content = "Build creation stopped.", Duration = 2})
    end
})

StreamTab:CreateButton({
    Name = "Delete All Screens",
    Callback = deleteAllScreens
})

ConfigTab:CreateDropdown({
    Name = "Build Mode",
    Options = {"Serverside: F3x", "clientside: SurfaceGui"},
    CurrentOption = {"Serverside: F3x"},
    Callback = function(value)
        Settings.BuildMode = type(value) == "table" and value[1] or value
    end
})

ConfigTab:CreateDropdown({
    Name = "Screen Resolution",
    Options = {
        "16x9", "24x14", "32x18", "42x24", "64x36", "85x48", "96x54",
        "128x72", "160x90", "192x108", "256x144 (144p)", "320x180",
        "400x225", "480x270 (270p)", "640x360 (360p)", "854x480 (480p)", "1280x720 (720p)"
    },
    CurrentOption = {"32x18"},
    Callback = function(value)
        Settings.Resolution = type(value) == "table" and value[1] or value
        parseResolution()
    end
})

ConfigTab:CreateSlider({
    Name = "Screen Size (Width & Height)",
    Range = {8, 60},
    Increment = 2,
    CurrentValue = 14, -- Default small screen
    Callback = function(value)
        Settings.ScreenSize = value
        parseResolution()
    end
})

ConfigTab:CreateSlider({
    Name = "Screen Distance",
    Range = {4, 30},
    Increment = 1,
    CurrentValue = 12,
    Callback = function(value)
        Settings.Distance = value
    end
})

ConfigTab:CreateSlider({
    Name = "Screen Height Offset",
    Range = {-10, 15},
    Increment = 1,
    CurrentValue = 4,
    Callback = function(value)
        Settings.HeightOffset = value
    end
})

ConfigTab:CreateDropdown({
    Name = "Part Material",
    Options = {"SmoothPlastic", "Neon", "Glass", "ForceField"},
    CurrentOption = {"SmoothPlastic"},
    Callback = function(value)
        local matName = type(value) == "table" and value[1] or value
        Settings.PartMaterial = Enum.Material[matName] or Enum.Material.SmoothPlastic
    end
})

ConfigTab:CreateSlider({
    Name = "Vortex Light Brightness",
    Range = {0, 10},
    Increment = 0.5,
    CurrentValue = 0, -- Default 0
    Callback = function(value)
        Settings.VortexLight = value
        updateVortexLight()
    end
})

ConfigTab:CreateSlider({
    Name = "Target FPS",
    Range = {1, 60},
    Increment = 1,
    CurrentValue = 60, -- Default 60 FPS
    Callback = function(value)
        Settings.TargetFPS = math.clamp(value, 1, 60)
    end
})

ConfigTab:CreateSlider({
    Name = "F3X Remote Fire Rate (Max Batch)",
    Range = {500, 5000},
    Increment = 100,
    CurrentValue = 5000, -- Default highest
    Callback = function(value)
        Settings.MaxBatchSize = value
    end
})

ConfigTab:CreateSlider({
    Name = "Color Tolerance",
    Range = {0, 20},
    Increment = 1,
    CurrentValue = 6,
    Callback = function(value)
        Settings.ColorTolerance = value
    end
})


PerfTab:CreateSection("Live Streaming Diagnostics")
local PerfParagraph = PerfTab:CreateParagraph({
    Title = "Performance Stats",
    Content = "Stream is currently inactive. Turn on 'Enable Stream' to start live tracking."
})

task.spawn(function()
    while true do
        task.wait(1)
        lastF3xRate = f3xInvokeCount
        f3xInvokeCount = 0

        if Settings.IsStreaming then
            local clientPingMs = math.round(Players.LocalPlayer:GetNetworkPing() * 1000)
            local serverPingApprox = clientPingMs * 2

            local clientPingLabel = clientPingMs <= 50 and "30ms (great)" or (clientPingMs <= 100 and clientPingMs .. "ms (good)" or clientPingMs .. "ms (bad)")
            local serverPingLabel = serverPingApprox <= 100 and serverPingApprox .. "ms (good)" or serverPingApprox .. "ms (bad)"
            
            local streamLatencyStatus = lastHttpLatency < 60 and "good" or (lastHttpLatency < 150 and "moderate" or "bad")
            local pyLatencyStatus = lastHttpLatency < 80 and "good" or "bad"
            local f3xRateStatus = lastF3xRate > 5 and "good" or "bad"

            local content = string.format([[
- Streaming latency -- %s (%d ms)
- Clientside Ping -- %s
- Serverside Ping -- %s
- F3X RemoteFunction fire rate -- %s (%d req/s)
- Python stream latency -- %s (%d ms)
            ]], streamLatencyStatus, lastHttpLatency, clientPingLabel, serverPingLabel, f3xRateStatus, lastF3xRate, pyLatencyStatus, lastHttpLatency)

            pcall(function()
                PerfParagraph:Set({
                    Title = "Live Streaming Performance (Active)",
                    Content = content
                })
            end)
        else
            pcall(function()
                PerfParagraph:Set({
                    Title = "Live Streaming Performance",
                    Content = "Stream is stopped. Enable stream to view live true metrics."
                })
            end)
        end
    end
end)