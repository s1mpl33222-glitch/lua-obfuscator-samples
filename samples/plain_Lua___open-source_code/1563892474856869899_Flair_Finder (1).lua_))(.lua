-- Flair Finder client script 
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

-- Local overhead Discord tag (visible on this client only)
local DISCORD_TAG_TEXT = "discord.gg/hbb2Kj3EFh"
local function attachDiscordTag(character)
    if not character then return end
    local head = character:WaitForChild("Head", 10)
    if not head then return end

    local oldTag = head:FindFirstChild("FlairFinderDiscordTag")
    if oldTag then oldTag:Destroy() end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "FlairFinderDiscordTag"
    billboard.Adornee = head
    billboard.Size = UDim2.fromOffset(250, 32)
    billboard.StudsOffset = Vector3.new(0, 2.8, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 150
    billboard.Parent = head

    local label = Instance.new("TextLabel")
    label.Name = "DiscordText"
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    label.BackgroundTransparency = 0.15
    label.BorderSizePixel = 0
    label.Text = DISCORD_TAG_TEXT
    label.TextColor3 = Color3.fromRGB(235, 235, 245)
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.TextWrapped = false
    label.Parent = billboard

    local sizeLimit = Instance.new("UITextSizeConstraint")
    sizeLimit.MinTextSize = 11
    sizeLimit.MaxTextSize = 16
    sizeLimit.Parent = label

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = label

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(110, 110, 130)
    stroke.Thickness = 1
    stroke.Transparency = 0.15
    stroke.Parent = label
end

if LP.Character then
    task.spawn(attachDiscordTag, LP.Character)
end
LP.CharacterAdded:Connect(attachDiscordTag)

local LINE = Color3.fromRGB(70, 70, 70)
local DARK = Color3.fromRGB(12, 12, 12)
local SURFACE = Color3.fromRGB(22, 22, 22)
local WHITE = Color3.fromRGB(235, 235, 235)
local GRAY = Color3.fromRGB(115, 115, 115)
local RED = Color3.fromRGB(205, 45, 45)
local GREEN = Color3.fromRGB(45, 190, 45)
local ACCENT = Color3.fromRGB(170, 170, 170)
local SOFT = Color3.fromRGB(65, 65, 65)
local BLUE = Color3.fromRGB(15, 40, 90)

-- Animals API for 3D
local AnimalsAPI
do
    local ok, mod = pcall(function()
        return require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Animals"))
    end)
    if ok then AnimalsAPI = mod end
end

local AnimalsData
do
    local ok, mod = pcall(function()
        return require(ReplicatedStorage:WaitForChild("Datas"):WaitForChild("Animals"))
    end)
    if ok then AnimalsData = mod end
end

local TraitsData
do
    local Datas = ReplicatedStorage:FindFirstChild("Datas")
    local mod = Datas and Datas:FindFirstChild("Traits")
    if mod then
        local ok, t = pcall(require, mod)
        if ok then TraitsData = t end
    end
end

local ALL_BRAINROTS = {}
local nameSource = AnimalsData or AnimalsAPI
if nameSource then
    for name, _ in pairs(nameSource) do
        if type(name) == "string" and name ~= "None" and name ~= "" then
            table.insert(ALL_BRAINROTS, name)
        end
    end
    table.sort(ALL_BRAINROTS)
end

-- Blacklist
local blacklist = {}
local scannedAnimals = {}
local selectAllOn = false
local animalSettings = {}
local autoAcceptDuelOn = false

local hiddenFolder = Instance.new("Folder")
hiddenFolder.Name = "_HiddenByBlacklist"
hiddenFolder.Parent = ReplicatedStorage

local function hideBlacklistedModel(model)
    if not model or not model:IsA("Model") then return end
    if not blacklist[model.Name] then return end
    if not model.Parent then return end
    pcall(function() model.Parent = hiddenFolder end)
end

local function showUnblacklistedModel(model)
    if not model or not model:IsA("Model") then return end
    if blacklist[model.Name] then return end
    if not model.Parent then return end
    local plots = workspace:FindFirstChild("Plots")
    if plots then
        local plotName = model:GetAttribute("PlotName")
        local target = plotName and plots:FindFirstChild(plotName) or plots
        pcall(function() model.Parent = target end)
    else
        pcall(function() model.Parent = workspace end)
    end
end

local function applyBlacklistToWorld()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end
    for _, plot in plots:GetDescendants() do
        if plot:IsA("Model") then
            if blacklist[plot.Name] then
                hideBlacklistedModel(plot)
            end
        end
    end
    for _, model in hiddenFolder:GetChildren() do
        if model:IsA("Model") and not blacklist[model.Name] then
            showUnblacklistedModel(model)
        end
    end
end

local function hookBlacklistListener()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end
    plots.DescendantAdded:Connect(function(desc)
        task.wait()
        if desc:IsA("Model") and blacklist[desc.Name] then
            hideBlacklistedModel(desc)
        end
    end)
end

-- Config persistence
local CONFIG_FILE = "plaza_blacklist.json"

local function saveConfig()
    local list = {}
    for name, _ in pairs(blacklist) do
        table.insert(list, name)
    end
    local animSettings = {}
    for name, data in pairs(animalSettings) do
        animSettings[name] = {mutBlack = {}, tierBlack = {}}
        for k, _ in pairs(data.mutBlack) do animSettings[name].mutBlack[k] = true end
        for k, _ in pairs(data.tierBlack) do animSettings[name].tierBlack[k] = true end
    end
    writefile(CONFIG_FILE, HttpService:JSONEncode({
        blacklist = list,
        selectAll = selectAllOn,
        animalSettings = animSettings,
        autoAcceptDuel = autoAcceptDuelOn
    }))
end

local function loadConfig()
    if not isfile(CONFIG_FILE) then return end
    local ok, data = pcall(function()
        return HttpService:JSONDecode(readfile(CONFIG_FILE))
    end)
    if ok and type(data) == "table" then
        local list = data.blacklist or data
        if type(list) == "table" then
            for _, name in ipairs(list) do
                blacklist[name] = true
            end
        end
        if data.selectAll then selectAllOn = true end
        if data.autoAcceptDuel then autoAcceptDuelOn = true end
        if type(data.animalSettings) == "table" then
            for name, settings in pairs(data.animalSettings) do
                if type(settings) == "table" then
                    local s = {mutBlack = {}, tierBlack = {}}
                    if type(settings.mutBlack) == "table" then
                        for k, _ in pairs(settings.mutBlack) do s.mutBlack[k] = true end
                    end
                    if type(settings.tierBlack) == "table" then
                        for k, _ in pairs(settings.tierBlack) do s.tierBlack[k] = true end
                    end
                    animalSettings[name] = s
                end
            end
        end
    end
end

loadConfig()
task.defer(function()
    applyBlacklistToWorld()
    hookBlacklistListener()
end)

local function getPlotOwner(plot)
    local sign = plot:FindFirstChild("PlotSign")
    local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text == "Empty Base" then return nil end
    return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end

local function formatMoney(n)
    if not n then return "-" end
    if n >= 1e12 then return ("$%.2fT"):format(n / 1e12)
    elseif n >= 1e9 then return ("$%.2fB"):format(n / 1e9)
    elseif n >= 1e6 then return ("$%.2fM"):format(n / 1e6)
    elseif n >= 1e3 then return ("$%.2fK"):format(n / 1e3)
    else return ("$%.0f"):format(n) end
end

local function getAnimalData(name)
    if AnimalsData and type(AnimalsData) == "table" then
        local entry = AnimalsData[name]
        if type(entry) == "table" then
            return entry.Generation, entry.Price
        end
    end
    return nil, nil
end

local MutationsData, TierMultData
do
    local ok, m = pcall(function() return require(ReplicatedStorage.Datas.Mutations) end)
    if ok and type(m) == "table" then MutationsData = m end
end
do
    local ok, t = pcall(function() return require(ReplicatedStorage.Datas.Traits) end)
    if ok and type(t) == "table" then TierMultData = t end
end

local _sharedAnimals
local function GetSharedAnimals()
    if not _sharedAnimals then
        pcall(function() _sharedAnimals = require(ReplicatedStorage.Shared.Animals) end)
    end
    return _sharedAnimals
end

local function calcFinalGen(name, mutation, tier)
    if mutation == "None" then mutation = nil end
    local sa = GetSharedAnimals()
    if sa and sa.CalculateGeneration then
        local ok, val = pcall(function() return sa:CalculateGeneration(name, mutation, tier) end)
        if ok and val then return val end
    end
    local baseGen, basePrice = getAnimalData(name)
    if not baseGen then return nil, nil end
    local mutMult = 1
    if mutation then
        if MutationsData and MutationsData[mutation] and MutationsData[mutation].Modifier then
            mutMult = MutationsData[mutation].Modifier + 1
        else
            mutMult = ({Gold=1.25, Diamond=1.5, Rainbow=10})[mutation] or 1
        end
    end
    local traitAdd = 0
    if tier and TierMultData and TierMultData[tier] then
        traitAdd = TierMultData[tier].MultiplierModifier or 0
    end
    local totalMult = mutMult + traitAdd
    local result = baseGen * totalMult
    local priceResult = basePrice
    if tier == "Sleepy" then
        result = result * 0.5
        priceResult = priceResult and priceResult * 0.5 or nil
    end
    return result, priceResult
end

local function processPlotData(plotName, ownerName, data)
    if typeof(data) ~= "table" then return end
    local animalList = data.AnimalList
    if typeof(animalList) ~= "table" then return end
    local entries = {}
    for slot, animalData in pairs(animalList) do
        if typeof(animalData) ~= "table" or not animalData.Index then continue end
        local animalName = animalData.Index
        if blacklist[animalName] then continue end
        local mut = animalData.Mutation
        local mutation = (mut and mut ~= "" and mut ~= "None") and mut or nil
        local plr = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p.DisplayName == ownerName then plr = p; break end
        end
        if not plr or plr == LP then continue end
        local tierName = nil
        if type(animalData.Tier) == "string" and animalData.Tier ~= "" then
            tierName = animalData.Tier
        elseif type(animalData.Traits) == "table" then
            tierName = animalData.Traits[1]
        elseif type(animalData.Trait) == "string" and animalData.Trait ~= "" then
            tierName = animalData.Trait
        end
        local extras = animalSettings[animalName]
        if extras then
            if mutation and extras.mutBlack[mutation] then continue end
            if (not mutation) and extras.mutBlack["None"] then continue end
            if tierName and extras.tierBlack[tierName] then continue end
        end
        table.insert(entries, {
            name = animalName,
            mutation = mutation,
            tier = tierName,
            ownerName = ownerName,
            plotName = plotName,
            slot = tostring(slot),
            player = plr
        })
    end
    if #entries > 0 then
        local best = entries[1]
        local bestGen = calcFinalGen(best.name, best.mutation, best.tier) or 0
        for _, e in ipairs(entries) do
            local gen = calcFinalGen(e.name, e.mutation, e.tier) or 0
            if gen > bestGen or (gen == bestGen and not best.mutation and e.mutation) then
                best = e
                bestGen = gen
            end
        end
        return best
    end
    return nil
end

local function removePlayerAnimals(player)
    if not player then return end
    local filtered = {}
    for _, e in ipairs(scannedAnimals) do
        if e.player ~= player then
            table.insert(filtered, e)
        end
    end
    scannedAnimals = filtered
end

local function scanSinglePlot(plot)
    if not plot then return end
    local owner = getPlotOwner(plot)
    if not owner then return end
    local syncFolder = ReplicatedStorage:FindFirstChild("Packages") and
        ReplicatedStorage.Packages:FindFirstChild("Synchronizer")
    local requestData = syncFolder and syncFolder:FindFirstChild("RequestData")
    if not requestData then return end
    local ok, data = pcall(function()
        return requestData:InvokeServer(plot.Name)
    end)
    if not ok then return end
    local entry = processPlotData(plot.Name, owner, data)
    if not entry then return end
    for i, e in ipairs(scannedAnimals) do
        if e.player == entry.player then
            if not e.mutation and entry.mutation then
                scannedAnimals[i] = entry
            end
            return
        end
    end
    table.insert(scannedAnimals, entry)
    table.sort(scannedAnimals, function(a, b)
        return a.ownerName < b.ownerName
    end)
end

local scanning = false
local rebuildAnimalList

local function scanAllPlots()
    if scanning then return end
    scanning = true
    scannedAnimals = {}
    local plots = workspace:FindFirstChild("Plots")
    if not plots then
        scanning = false
        return
    end
    local syncFolder = ReplicatedStorage:FindFirstChild("Packages") and
        ReplicatedStorage.Packages:FindFirstChild("Synchronizer")
    local requestData = syncFolder and syncFolder:FindFirstChild("RequestData")
    if not requestData then
        scanning = false
        return
    end
    local plotInfos = {}
    for _, plot in ipairs(plots:GetChildren()) do
        local owner = getPlotOwner(plot)
        if owner then
            table.insert(plotInfos, {name = plot.Name, owner = owner})
        end
    end
    local results = {}
    local done = 0
    for i, info in ipairs(plotInfos) do
        task.spawn(function()
            local ok, data = pcall(function()
                return requestData:InvokeServer(info.name)
            end)
            results[i] = {ok = ok, data = data, info = info}
            done = done + 1
        end)
    end
    local startTime = tick()
    while done < #plotInfos and tick() - startTime < 10 do
        task.wait()
    end
    for _, res in ipairs(results) do
        if not res or not res.ok then continue end
        local entry = processPlotData(res.info.name, res.info.owner, res.data)
        if entry then
            table.insert(scannedAnimals, entry)
        end
    end
    local best = {}
    for _, e in ipairs(scannedAnimals) do
        local uid = e.player.UserId
        local cur = best[uid]
        if not cur then
            best[uid] = e
        elseif not cur.mutation and e.mutation then
            best[uid] = e
        end
    end
    scannedAnimals = {}
    for _, e in pairs(best) do
        table.insert(scannedAnimals, e)
    end
    table.sort(scannedAnimals, function(a, b)
        return a.ownerName < b.ownerName
    end)
    scanning = false
    rebuildAnimalList()
end

-- === SERVER PROMPT HELPERS ===
local function getTradePortalPrompt()
    local map = workspace:FindFirstChild("Map")
    if not map then return nil end
    local portal = map:FindFirstChild("TradeServerPortal")
    if not portal then return nil end
    local prompt = portal:FindFirstChild("Prompt")
    if prompt and prompt:IsA("ProximityPrompt") then
        return prompt
    end
    return portal:FindFirstChildWhichIsA("ProximityPrompt", true)
end

local function triggerProximityPrompt(prompt)
    if not prompt then return false end
    pcall(function()
        prompt.Enabled = true
        prompt.RequiresLineOfSight = false
    end)
    if fireproximityprompt then
        local ok = pcall(function()
            fireproximityprompt(prompt)
        end)
        if ok then return true end
    end
    if prompt.InputHoldBegin and prompt.InputHoldEnd then
        local ok = pcall(function()
            prompt:InputHoldBegin()
        end)
        if ok then
            local hold = prompt.HoldDuration or 0
            task.wait(math.max(0.05, hold))
            pcall(function()
                prompt:InputHoldEnd()
            end)
            return true
        end
    end
    return false
end

-- === GUI ===
local W, H = 700, 500
local LW = 370

local sg = Instance.new("ScreenGui")
sg.Name = "DuelGUIv5"
sg.Parent = LP:WaitForChild("PlayerGui")
sg.ResetOnSpawn = false
sg.DisplayOrder = 1000
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local cam = workspace.CurrentCamera
local vpX = cam and cam.ViewportSize.X or 700
local scale = math.min(1, math.max(0.45, vpX / (W + 40)))
local UIScale = Instance.new("UIScale")
UIScale.Scale = scale

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, W, 0, H)
main.Position = UDim2.new(0, 10, 0.5, -H/2)
main.BackgroundColor3 = DARK
main.BackgroundTransparency = 0
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Active = true
UIScale.Parent = main

do
    local c = Instance.new("UICorner", main)
    c.CornerRadius = UDim.new(0, 8)
end

local bgImage = Instance.new("ImageLabel", main)
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.BackgroundTransparency = 1
bgImage.Image = "rbxassetid://100244628400962"
bgImage.ImageColor3 = Color3.fromRGB(26, 26, 26)
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ZIndex = 0

do
    local s = Instance.new("UIStroke", main)
    s.Color = LINE
    s.Thickness = 2
    s.Transparency = 0.2
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end

local dragging, dragStart, frameStart = false
main.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = inp.Position; frameStart = main.Position
    end
end)
main.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UIS.InputChanged:Connect(function(inp)
    if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local d = inp.Position - dragStart
        main.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + d.X, frameStart.Y.Scale, frameStart.Y.Offset + d.Y)
    end
end)

-- Top bar
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, -12, 0, 42)
topBar.Position = UDim2.new(0, 6, 0, 6)
topBar.BackgroundColor3 = SURFACE
topBar.BorderSizePixel = 0

do
    local c = Instance.new("UICorner", topBar)
    c.CornerRadius = UDim.new(0, 6)
end

local vx7Container = Instance.new("Frame", topBar)
vx7Container.Size = UDim2.new(0, 100, 1, 0)
vx7Container.Position = UDim2.new(0, 8, 0, 0)
vx7Container.BackgroundTransparency = 1

local vLabel = Instance.new("TextLabel", vx7Container)
vLabel.Size = UDim2.new(0, 18, 1, 0)
vLabel.Position = UDim2.new(0, 0, 0, 0)
vLabel.BackgroundTransparency = 1
vLabel.Text = "R"
vLabel.TextColor3 = ACCENT
vLabel.Font = Enum.Font.GothamBlack
vLabel.TextSize = 24
vLabel.TextXAlignment = Enum.TextXAlignment.Left

local x7Label = Instance.new("TextLabel", vx7Container)
x7Label.Size = UDim2.new(0, 80, 1, 0)
x7Label.Position = UDim2.new(0, 16, 0, 0)
x7Label.BackgroundTransparency = 1
x7Label.Text = "ESTREINT"
x7Label.TextColor3 = WHITE
x7Label.Font = Enum.Font.GothamBlack
x7Label.TextSize = 24
x7Label.TextXAlignment = Enum.TextXAlignment.Left

local pfLabel = Instance.new("TextLabel", topBar)
pfLabel.Size = UDim2.new(0, 260, 1, 0)
pfLabel.Position = UDim2.new(0, 135, 0, 0)
pfLabel.BackgroundTransparency = 1
pfLabel.Text = "Flair Finder"
pfLabel.Font = Enum.Font.GothamBlack
pfLabel.TextSize = 24
pfLabel.TextXAlignment = Enum.TextXAlignment.Left
pfLabel.TextColor3 = ACCENT

local c1, c2 = ACCENT, Color3.fromRGB(105, 105, 105)
task.spawn(function()
    local t = 0
    while pfLabel and pfLabel.Parent do
        local dt = task.wait()
        t = t + dt
        local a = (math.sin(t * 1.8) + 1) / 2
        pfLabel.TextColor3 = Color3.new(c1.R * (1-a) + c2.R * a, c1.G * (1-a) + c2.G * a, c1.B * (1-a) + c2.B * a)
    end
end)

local autoDuelOn = false
local minimized = false
local serveurBusy = false

-- === NOTIFICATIONS (COIN HAUT DROITE DU MENU) ===
local NOTIF_W, NOTIF_H = 300, 54
local NOTIF_TOP = 52
local NOTIF_RIGHT = -NOTIF_W - 8
local notifStack = {}

local function updateNotifStack()
    for i, n in ipairs(notifStack) do
        if n and n.Parent then
            local targetY = NOTIF_TOP + (i - 1) * (NOTIF_H + 6)
            TweenService:Create(n, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, NOTIF_RIGHT, 0, targetY)
            }):Play()
        end
    end
end

local function removeNotif(n)
    for i, x in ipairs(notifStack) do
        if x == n then
            table.remove(notifStack, i)
            break
        end
    end
    updateNotifStack()
    for _, child in ipairs(n:GetDescendants()) do
        if child:IsA("TextLabel") then
            TweenService:Create(child, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        elseif child:IsA("ImageLabel") then
            TweenService:Create(child, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
        elseif child:IsA("Frame") then
            TweenService:Create(child, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        elseif child:IsA("UIStroke") then
            TweenService:Create(child, TweenInfo.new(0.3), {Transparency = 1}):Play()
        end
    end
    local out = TweenService:Create(n, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(1, NOTIF_RIGHT, 0, -NOTIF_H - 10),
        BackgroundTransparency = 1
    })
    out:Play()
    out.Completed:Wait()
    n:Destroy()
end

local function pushNotif(titleText, bodyText, iconText, strokeColor)
    local notif = Instance.new("Frame", main)
    notif.Name = "Notif"
    notif.Size = UDim2.new(0, NOTIF_W, 0, NOTIF_H)
    notif.Position = UDim2.new(1, NOTIF_RIGHT, 0, -NOTIF_H - 10)
    notif.BackgroundColor3 = SURFACE
    notif.BorderSizePixel = 0
    notif.ZIndex = 60

    local corner = Instance.new("UICorner", notif)
    corner.CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", notif)
    stroke.Color = LINE
    stroke.Thickness = 1.5
    stroke.Transparency = 0.25
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local icon = Instance.new("Frame", notif)
    icon.Size = UDim2.new(0, 32, 0, 32)
    icon.Position = UDim2.new(0, 10, 0.5, -16)
    icon.BackgroundColor3 = DARK
    icon.BorderSizePixel = 0
    icon.ZIndex = 61

    local iconCorner = Instance.new("UICorner", icon)
    iconCorner.CornerRadius = UDim.new(1, 0)

    local iconStroke = Instance.new("UIStroke", icon)
    iconStroke.Color = strokeColor
    iconStroke.Thickness = 1.5
    iconStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local star = Instance.new("TextLabel", icon)
    star.Size = UDim2.new(1, 0, 1, 0)
    star.BackgroundTransparency = 1
    star.Text = iconText
    star.TextSize = 15
    star.ZIndex = 62

    local title = Instance.new("TextLabel", notif)
    title.Size = UDim2.new(1, -90, 0, 14)
    title.Position = UDim2.new(0, 50, 0, 9)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.TextColor3 = ACCENT
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 9
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 61

    local body = Instance.new("TextLabel", notif)
    body.Size = UDim2.new(1, -90, 0, 16)
    body.Position = UDim2.new(0, 50, 0, 26)
    body.BackgroundTransparency = 1
    body.Text = bodyText
    body.TextColor3 = WHITE
    body.Font = Enum.Font.GothamBold
    body.TextSize = 11
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.TextTruncate = Enum.TextTruncate.AtEnd
    body.ZIndex = 61

    local now = Instance.new("TextLabel", notif)
    now.Size = UDim2.new(0, 40, 0, 12)
    now.Position = UDim2.new(1, -44, 0, 9)
    now.BackgroundTransparency = 1
    now.Text = "now"
    now.TextColor3 = GRAY
    now.Font = Enum.Font.Gotham
    now.TextSize = 9
    now.TextXAlignment = Enum.TextXAlignment.Right
    now.ZIndex = 61

    table.insert(notifStack, 1, notif)
    updateNotifStack()

    task.delay(4, function()
        if notif and notif.Parent then
            removeNotif(notif)
        end
    end)
end

local function showPriorityNotif(playerName)
    pushNotif("USER PRIORITAIRE", playerName .. " • invité en premier", "⭐", Color3.fromRGB(90, 160, 255))
end

local function showSystemNotif(bodyText)
    pushNotif("Flair Finder", bodyText, "🔔", LINE)
end

-- === USER PRIORITAIRE ===
local userPriorityOn = true
local PRIORITY_KEYWORDS = {"pvp", "duel", "1v1", "best", "dueleur"}
local notifiedPriority = {}

local function isPriorityPlayer(player)
    if not player then return false end
    local lowName = player.Name:lower()
    local lowDisplay = player.DisplayName:lower()
    for _, kw in ipairs(PRIORITY_KEYWORDS) do
        if lowName:find(kw, 1, true) or lowDisplay:find(kw, 1, true) then
            return true
        end
    end
    return false
end

local function checkPriorityPlayers()
    if not userPriorityOn then return end
    for _, e in ipairs(scannedAnimals) do
        if isPriorityPlayer(e.player) and not notifiedPriority[e.player.UserId] then
            notifiedPriority[e.player.UserId] = true
            showPriorityNotif(e.player.DisplayName)
        end
    end
end

-- AUTO DUEL TOGGLE
local autoDuelToggle = Instance.new("TextButton", topBar)
autoDuelToggle.Size = UDim2.new(0, 60, 0, 24)
autoDuelToggle.Position = UDim2.new(1, -124, 0, 9)
autoDuelToggle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
autoDuelToggle.BorderSizePixel = 0
autoDuelToggle.Text = ""
autoDuelToggle.Font = Enum.Font.Gotham
autoDuelToggle.TextSize = 9

do
    local c = Instance.new("UICorner", autoDuelToggle)
    c.CornerRadius = UDim.new(0, 12)
end
do
    local s = Instance.new("UIStroke", autoDuelToggle)
    s.Color = Color3.fromRGB(65, 65, 65)
    s.Thickness = 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end

local autoDuelLabel = Instance.new("TextLabel", autoDuelToggle)
autoDuelLabel.Size = UDim2.new(1, -8, 1, 0)
autoDuelLabel.Position = UDim2.new(0, 4, 0, 0)
autoDuelLabel.BackgroundTransparency = 1
autoDuelLabel.Text = "Auto Duel"
autoDuelLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
autoDuelLabel.Font = Enum.Font.GothamBold
autoDuelLabel.TextSize = 9
autoDuelLabel.TextXAlignment = Enum.TextXAlignment.Center

local function updateAutoDuelToggle()
    if autoDuelOn then
        autoDuelToggle.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
        autoDuelLabel.TextColor3 = WHITE
    else
        autoDuelToggle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        autoDuelLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
    end
end

autoDuelToggle.MouseButton1Click:Connect(function()
    autoDuelOn = not autoDuelOn
    updateAutoDuelToggle()
end)
updateAutoDuelToggle()

-- SERVEUR BUTTON
local serveurBtn = Instance.new("TextButton", topBar)
serveurBtn.Size = UDim2.new(0, 60, 0, 24)
serveurBtn.Position = UDim2.new(1, -192, 0, 9)
serveurBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
serveurBtn.BorderSizePixel = 0
serveurBtn.Text = ""
serveurBtn.Font = Enum.Font.Gotham
serveurBtn.TextSize = 9

do
    local c = Instance.new("UICorner", serveurBtn)
    c.CornerRadius = UDim.new(0, 12)
end
do
    local s = Instance.new("UIStroke", serveurBtn)
    s.Color = Color3.fromRGB(65, 65, 65)
    s.Thickness = 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end

local serveurLabel = Instance.new("TextLabel", serveurBtn)
serveurLabel.Size = UDim2.new(1, -8, 1, 0)
serveurLabel.Position = UDim2.new(0, 4, 0, 0)
serveurLabel.BackgroundTransparency = 1
serveurLabel.Text = "Serveur"
serveurLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
serveurLabel.Font = Enum.Font.GothamBold
serveurLabel.TextSize = 9
serveurLabel.TextXAlignment = Enum.TextXAlignment.Center

local function updateServeurButtonText()
    if serveurBusy then
        serveurLabel.Text = "..."
    else
        serveurLabel.Text = minimized and "Serv" or "Serveur"
    end
end

serveurBtn.MouseButton1Click:Connect(function()
    if serveurBusy then return end
    serveurBusy = true
    serveurBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    updateServeurButtonText()
    task.spawn(function()
        local prompt = getTradePortalPrompt()
        if prompt then
            triggerProximityPrompt(prompt)
        end
        task.wait(0.45)
        serveurBusy = false
        serveurBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        updateServeurButtonText()
    end)
end)
updateServeurButtonText()

-- USER BUTTON
local userBtn = Instance.new("TextButton", topBar)
userBtn.Size = UDim2.new(0, 60, 0, 24)
userBtn.Position = UDim2.new(1, -260, 0, 9)
userBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
userBtn.BorderSizePixel = 0
userBtn.Text = ""
userBtn.Font = Enum.Font.Gotham
userBtn.TextSize = 9

do
    local c = Instance.new("UICorner", userBtn)
    c.CornerRadius = UDim.new(0, 12)
end
do
    local s = Instance.new("UIStroke", userBtn)
    s.Color = Color3.fromRGB(65, 65, 65)
    s.Thickness = 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end

local userLabel = Instance.new("TextLabel", userBtn)
userLabel.Size = UDim2.new(1, -8, 1, 0)
userLabel.Position = UDim2.new(0, 4, 0, 0)
userLabel.BackgroundTransparency = 1
userLabel.Text = "User"
userLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
userLabel.Font = Enum.Font.GothamBold
userLabel.TextSize = 9
userLabel.TextXAlignment = Enum.TextXAlignment.Center

local function updateUserToggle()
    if userPriorityOn then
        userBtn.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
        userLabel.TextColor3 = WHITE
    else
        userBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        userLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
    end
end

userBtn.MouseButton1Click:Connect(function()
    userPriorityOn = not userPriorityOn
    updateUserToggle()
    if userPriorityOn then
        notifiedPriority = {}
        checkPriorityPlayers()
        showSystemNotif("Priorité USER activée")
    else
        showSystemNotif("Priorité USER désactivée")
    end
    rebuildAnimalList()
end)
updateUserToggle()

-- AUTO ACCEPT DUEL BUTTON
local autoAcceptBtn = Instance.new("TextButton", topBar)
autoAcceptBtn.Size = UDim2.new(0, 84, 0, 24)
autoAcceptBtn.Position = UDim2.new(1, -352, 0, 9)
autoAcceptBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
autoAcceptBtn.BorderSizePixel = 0
autoAcceptBtn.Text = ""
autoAcceptBtn.Font = Enum.Font.Gotham
autoAcceptBtn.TextSize = 9

do
    local c = Instance.new("UICorner", autoAcceptBtn)
    c.CornerRadius = UDim.new(0, 12)
end
do
    local s = Instance.new("UIStroke", autoAcceptBtn)
    s.Color = Color3.fromRGB(65, 65, 65)
    s.Thickness = 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end

local autoAcceptLabel = Instance.new("TextLabel", autoAcceptBtn)
autoAcceptLabel.Size = UDim2.new(1, -8, 1, 0)
autoAcceptLabel.Position = UDim2.new(0, 4, 0, 0)
autoAcceptLabel.BackgroundTransparency = 1
autoAcceptLabel.Text = "Auto Accept Duel"
autoAcceptLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
autoAcceptLabel.Font = Enum.Font.GothamBold
autoAcceptLabel.TextSize = 8
autoAcceptLabel.TextXAlignment = Enum.TextXAlignment.Center

local function updateAutoAcceptToggle()
    if autoAcceptDuelOn then
        autoAcceptBtn.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
        autoAcceptLabel.TextColor3 = WHITE
    else
        autoAcceptBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        autoAcceptLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
    end
end

autoAcceptBtn.MouseButton1Click:Connect(function()
    autoAcceptDuelOn = not autoAcceptDuelOn
    saveConfig()
    updateAutoAcceptToggle()
    if autoAcceptDuelOn then
        showSystemNotif("Auto Accept Duel activé")
    else
        showSystemNotif("Auto Accept Duel désactivé")
    end
end)
updateAutoAcceptToggle()

local minimizeBtn = Instance.new("TextButton", topBar)
minimizeBtn.Size = UDim2.new(0, 24, 0, 24)
minimizeBtn.Position = UDim2.new(1, -56, 0, 4)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = WHITE
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 14

do
    local c = Instance.new("UICorner", minimizeBtn)
    c.CornerRadius = UDim.new(1, 0)
end

local restoreBtn = Instance.new("TextButton", sg)
restoreBtn.Size = UDim2.new(0, 26, 0, 26)
restoreBtn.Position = UDim2.new(0, 10, 0, 10)
restoreBtn.BackgroundColor3 = SURFACE
restoreBtn.BorderSizePixel = 0
restoreBtn.Text = "FF"
restoreBtn.TextColor3 = ACCENT
restoreBtn.Font = Enum.Font.GothamBlack
restoreBtn.TextSize = 8
restoreBtn.Visible = false
restoreBtn.ZIndex = 100

do
    local c = Instance.new("UICorner", restoreBtn)
    c.CornerRadius = UDim.new(0, 4)
end
do
    local s = Instance.new("UIStroke", restoreBtn)
    s.Color = ACCENT
    s.Thickness = 1
    s.Transparency = 0.35
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end

local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -28, 0, 4)
closeBtn.BackgroundColor3 = Color3.fromRGB(135, 25, 25)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.TextColor3 = WHITE
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12

do
    local c = Instance.new("UICorner", closeBtn)
    c.CornerRadius = UDim.new(1, 0)
end

closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

-- Content body
local contentTop = 54
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -16, 1, -contentTop - 8)
content.Position = UDim2.new(0, 8, 0, contentTop)
content.BackgroundTransparency = 1

minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    main.Size = UDim2.new(0, minimized and 360 or W, 0, minimized and 48 or H)
    minimizeBtn.Text = minimized and "+" or "—"
    userBtn.Visible = not minimized
    autoAcceptBtn.Visible = not minimized
    if minimized then
        pfLabel.Size = UDim2.new(0, 192, 1, 0)
        serveurBtn.Size = UDim2.new(0, 40, 0, 24)
        serveurBtn.Position = UDim2.new(0, 200, 0, 9)
        autoDuelToggle.Size = UDim2.new(0, 40, 0, 24)
        autoDuelToggle.Position = UDim2.new(0, 244, 0, 9)
        autoDuelLabel.Text = "Duel"
    else
        pfLabel.Size = UDim2.new(0, 260, 1, 0)
        serveurBtn.Size = UDim2.new(0, 60, 0, 24)
        serveurBtn.Position = UDim2.new(1, -192, 0, 9)
        autoDuelToggle.Size = UDim2.new(0, 60, 0, 24)
        autoDuelToggle.Position = UDim2.new(1, -124, 0, 9)
        autoDuelLabel.Text = "Auto Duel"
    end
    updateServeurButtonText()
end)

restoreBtn.MouseButton1Click:Connect(function()
    restoreBtn.Visible = false
    main.Visible = true
    if minimized then
        minimized = false
        content.Visible = true
        main.Size = UDim2.new(0, W, 0, H)
        minimizeBtn.Text = "—"
        userBtn.Visible = true
        autoAcceptBtn.Visible = true
    end
    updateServeurButtonText()
end)

-- === LEFT PANEL ===
local leftPane = Instance.new("Frame", content)
leftPane.Size = UDim2.new(0, LW, 1, 0)
leftPane.BackgroundTransparency = 1

local listPane = Instance.new("Frame", leftPane)
listPane.Size = UDim2.new(1, 0, 0.55, -4)
listPane.BackgroundColor3 = SURFACE
listPane.BorderSizePixel = 0
listPane.BackgroundTransparency = 0.12

do
    local c = Instance.new("UICorner", listPane)
    c.CornerRadius = UDim.new(0, 6)
end

local listLabel = Instance.new("TextLabel", listPane)
listLabel.Size = UDim2.new(1, -8, 0, 20)
listLabel.Position = UDim2.new(0, 6, 0, 3)
listLabel.BackgroundTransparency = 1
listLabel.Text = "USERS"
listLabel.TextColor3 = ACCENT
listLabel.Font = Enum.Font.GothamBlack
listLabel.TextSize = 11
listLabel.TextXAlignment = Enum.TextXAlignment.Left

local animalScroll = Instance.new("ScrollingFrame", listPane)
animalScroll.Size = UDim2.new(1, -8, 1, -26)
animalScroll.Position = UDim2.new(0, 4, 0, 22)
animalScroll.BackgroundTransparency = 1
animalScroll.BorderSizePixel = 0
animalScroll.ScrollBarThickness = 3
animalScroll.ScrollBarImageColor3 = ACCENT
animalScroll.ScrollBarImageTransparency = 0.45
animalScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local animalLayout = Instance.new("UIListLayout", animalScroll)
animalLayout.SortOrder = Enum.SortOrder.LayoutOrder
animalLayout.Padding = UDim.new(0, 2)

-- BRAINROTS GRID
local brainrotPane = Instance.new("Frame", leftPane)
brainrotPane.Size = UDim2.new(1, 0, 0.45, -4)
brainrotPane.Position = UDim2.new(0, 0, 0.55, 8)
brainrotPane.BackgroundColor3 = SURFACE
brainrotPane.BorderSizePixel = 0
brainrotPane.BackgroundTransparency = 0.12

do
    local c = Instance.new("UICorner", brainrotPane)
    c.CornerRadius = UDim.new(0, 6)
end

local brainrotLabel = Instance.new("TextLabel", brainrotPane)
brainrotLabel.Size = UDim2.new(1, -8, 0, 16)
brainrotLabel.Position = UDim2.new(0, 6, 0, 2)
brainrotLabel.BackgroundTransparency = 1
brainrotLabel.Text = "ANIMALS"
brainrotLabel.TextColor3 = ACCENT
brainrotLabel.Font = Enum.Font.GothamBlack
brainrotLabel.TextSize = 11
brainrotLabel.TextXAlignment = Enum.TextXAlignment.Left

local brainrotSearch = Instance.new("TextBox", brainrotPane)
brainrotSearch.Size = UDim2.new(1, -62, 0, 16)
brainrotSearch.Position = UDim2.new(0, 6, 0, 18)
brainrotSearch.BackgroundColor3 = DARK
brainrotSearch.BorderSizePixel = 0
brainrotSearch.PlaceholderText = "Search..."
brainrotSearch.PlaceholderColor3 = GRAY
brainrotSearch.Text = ""
brainrotSearch.TextColor3 = WHITE
brainrotSearch.Font = Enum.Font.Gotham
brainrotSearch.TextSize = 9
brainrotSearch.ClearTextOnFocus = false

do
    local c = Instance.new("UICorner", brainrotSearch)
    c.CornerRadius = UDim.new(0, 4)
end

local selectAllBtn = Instance.new("TextButton", brainrotPane)
selectAllBtn.Size = UDim2.new(0, 50, 0, 16)
selectAllBtn.Position = UDim2.new(1, -54, 0, 18)
selectAllBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
selectAllBtn.BorderSizePixel = 0
selectAllBtn.Text = "ALL"
selectAllBtn.TextColor3 = ACCENT
selectAllBtn.Font = Enum.Font.GothamBold
selectAllBtn.TextSize = 8

if selectAllOn then
    selectAllBtn.Text = "NONE"
    selectAllBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    selectAllBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
end

do
    local c = Instance.new("UICorner", selectAllBtn)
    c.CornerRadius = UDim.new(0, 4)
end

local brainrotScroll = Instance.new("ScrollingFrame", brainrotPane)
brainrotScroll.Size = UDim2.new(1, -8, 1, -38)
brainrotScroll.Position = UDim2.new(0, 4, 0, 36)
brainrotScroll.BackgroundTransparency = 1
brainrotScroll.BorderSizePixel = 0
brainrotScroll.ScrollBarThickness = 3
brainrotScroll.ScrollBarImageColor3 = ACCENT
brainrotScroll.ScrollBarImageTransparency = 0.45
brainrotScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local brainrotGrid = Instance.new("UIGridLayout", brainrotScroll)
brainrotGrid.SortOrder = Enum.SortOrder.LayoutOrder
brainrotGrid.CellSize = UDim2.new(0, 70, 0, 56)
brainrotGrid.CellPadding = UDim2.new(0, 3, 0, 3)

-- === RIGHT PANEL ===
local rightPane = Instance.new("Frame", content)
rightPane.Size = UDim2.new(0, W - LW - 16, 1, 0)
rightPane.Position = UDim2.new(0, LW + 8, 0, 0)
rightPane.BackgroundTransparency = 1

local vpContainer = Instance.new("Frame", rightPane)
vpContainer.Size = UDim2.new(1, 0, 0.6, -4)
vpContainer.BackgroundColor3 = SURFACE
vpContainer.BorderSizePixel = 0
vpContainer.BackgroundTransparency = 0.12
vpContainer.ClipsDescendants = true

do
    local c = Instance.new("UICorner", vpContainer)
    c.CornerRadius = UDim.new(0, 8)
end
do
    local s = Instance.new("UIStroke", vpContainer)
    s.Color = LINE
    s.Thickness = 1
    s.Transparency = 0.4
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end

local viewport = Instance.new("ViewportFrame", vpContainer)
viewport.Size = UDim2.new(1, -8, 1, -8)
viewport.Position = UDim2.new(0, 4, 0, 4)
viewport.BackgroundTransparency = 1
viewport.Visible = false

local vpCam = Instance.new("Camera", viewport)
viewport.CurrentCamera = vpCam
vpCam.FieldOfView = 50

local placeholderLbl = Instance.new("TextLabel", vpContainer)
placeholderLbl.Size = UDim2.new(1, 0, 1, 0)
placeholderLbl.BackgroundTransparency = 1
placeholderLbl.Text = "Select an animal"
placeholderLbl.TextColor3 = GRAY
placeholderLbl.Font = Enum.Font.Gotham
placeholderLbl.TextSize = 14
placeholderLbl.Visible = true

-- Info section
local infoPane = Instance.new("Frame", rightPane)
infoPane.Size = UDim2.new(1, 0, 0.4, -8)
infoPane.Position = UDim2.new(0, 0, 0.6, 8)
infoPane.BackgroundColor3 = SURFACE
infoPane.BorderSizePixel = 0
infoPane.BackgroundTransparency = 0.12

do
    local c = Instance.new("UICorner", infoPane)
    c.CornerRadius = UDim.new(0, 6)
end

local infoTitle = Instance.new("TextLabel", infoPane)
infoTitle.Size = UDim2.new(1, -10, 0, 18)
infoTitle.Position = UDim2.new(0, 8, 0, 2)
infoTitle.BackgroundTransparency = 1
infoTitle.Text = "SELECTED"
infoTitle.TextColor3 = ACCENT
infoTitle.Font = Enum.Font.GothamBlack
infoTitle.TextSize = 10
infoTitle.TextXAlignment = Enum.TextXAlignment.Left

local nameLbl = Instance.new("TextLabel", infoPane)
nameLbl.Size = UDim2.new(1, -10, 0, 16)
nameLbl.Position = UDim2.new(0, 8, 0, 22)
nameLbl.BackgroundTransparency = 1
nameLbl.Text = "Name: -"
nameLbl.TextColor3 = WHITE
nameLbl.Font = Enum.Font.GothamBold
nameLbl.TextSize = 12
nameLbl.TextXAlignment = Enum.TextXAlignment.Left

local ownerLbl = Instance.new("TextLabel", infoPane)
ownerLbl.Size = UDim2.new(1, -10, 0, 14)
ownerLbl.Position = UDim2.new(0, 8, 0, 40)
ownerLbl.BackgroundTransparency = 1
ownerLbl.Text = "Owner: -"
ownerLbl.TextColor3 = GRAY
ownerLbl.Font = Enum.Font.Gotham
ownerLbl.TextSize = 11
ownerLbl.TextXAlignment = Enum.TextXAlignment.Left

local mutLbl = Instance.new("TextLabel", infoPane)
mutLbl.Size = UDim2.new(1, -10, 0, 14)
mutLbl.Position = UDim2.new(0, 8, 0, 56)
mutLbl.BackgroundTransparency = 1
mutLbl.Text = "Mutation: -"
mutLbl.TextColor3 = ACCENT
mutLbl.Font = Enum.Font.Gotham
mutLbl.TextSize = 11
mutLbl.TextXAlignment = Enum.TextXAlignment.Left

local infoTierRow = Instance.new("Frame", infoPane)
infoTierRow.Size = UDim2.new(1, -10, 0, 14)
infoTierRow.Position = UDim2.new(0, 8, 0, 72)
infoTierRow.BackgroundTransparency = 1

local infoTierIcon = Instance.new("ImageLabel", infoTierRow)
infoTierIcon.Size = UDim2.new(0, 12, 0, 12)
infoTierIcon.Position = UDim2.new(0, 0, 0, 1)
infoTierIcon.BackgroundTransparency = 1
infoTierIcon.BorderSizePixel = 0
infoTierIcon.Visible = false

local infoTierLbl = Instance.new("TextLabel", infoTierRow)
infoTierLbl.Size = UDim2.new(1, -16, 1, 0)
infoTierLbl.Position = UDim2.new(0, 14, 0, 0)
infoTierLbl.BackgroundTransparency = 1
infoTierLbl.Text = "Tiers: -"
infoTierLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
infoTierLbl.Font = Enum.Font.Gotham
infoTierLbl.TextSize = 11
infoTierLbl.TextXAlignment = Enum.TextXAlignment.Left

local genLbl = Instance.new("TextLabel", infoPane)
genLbl.Size = UDim2.new(1, -10, 0, 14)
genLbl.Position = UDim2.new(0, 8, 0, 88)
genLbl.BackgroundTransparency = 1
genLbl.Text = "Genera: -"
genLbl.TextColor3 = GRAY
genLbl.Font = Enum.Font.Gotham
genLbl.TextSize = 11
genLbl.TextXAlignment = Enum.TextXAlignment.Left

local priceLbl = Instance.new("TextLabel", infoPane)
priceLbl.Size = UDim2.new(1, -10, 0, 14)
priceLbl.Position = UDim2.new(0, 8, 0, 104)
priceLbl.BackgroundTransparency = 1
priceLbl.Text = "Price: -"
priceLbl.TextColor3 = GRAY
priceLbl.Font = Enum.Font.Gotham
priceLbl.TextSize = 11
priceLbl.TextXAlignment = Enum.TextXAlignment.Left

local tradeBtn = Instance.new("TextButton", infoPane)
tradeBtn.Size = UDim2.new(1, -16, 0, 22)
tradeBtn.Position = UDim2.new(0, 8, 0, 120)
tradeBtn.BackgroundColor3 = BLUE
tradeBtn.BorderSizePixel = 0
tradeBtn.Text = "ÉCHANGE"
tradeBtn.TextColor3 = WHITE
tradeBtn.Font = Enum.Font.GothamBlack
tradeBtn.TextSize = 12

do
    local c = Instance.new("UICorner", tradeBtn)
    c.CornerRadius = UDim.new(0, 5)
end

local duelBtn = Instance.new("TextButton", infoPane)
duelBtn.Size = UDim2.new(1, -16, 0, 22)
duelBtn.Position = UDim2.new(0, 8, 0, 144)
duelBtn.BackgroundColor3 = Color3.fromRGB(145, 30, 30)
duelBtn.BorderSizePixel = 0
duelBtn.Text = "DUEL"
duelBtn.TextColor3 = WHITE
duelBtn.Font = Enum.Font.GothamBlack
duelBtn.TextSize = 12

do
    local c = Instance.new("UICorner", duelBtn)
    c.CornerRadius = UDim.new(0, 5)
end

-- === MUTATION PALETTES ===
local MUTATION_PALETTES = {
    None = {
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(220, 220, 220), Color3.fromRGB(190, 190, 190),
        Color3.fromRGB(160, 160, 160), Color3.fromRGB(240, 240, 240), Color3.fromRGB(130, 130, 130)
    },
    Gold = {
        Color3.fromRGB(237, 178, 0), Color3.fromRGB(237, 194, 86), Color3.fromRGB(215, 111, 1),
        Color3.fromRGB(139, 74, 0), Color3.fromRGB(255, 164, 164), Color3.fromRGB(255, 244, 190)
    },
    Diamond = {
        Color3.fromRGB(37, 196, 254), Color3.fromRGB(116, 212, 254), Color3.fromRGB(28, 137, 254),
        Color3.fromRGB(21, 64, 254), Color3.fromRGB(160, 162, 254), Color3.fromRGB(176, 255, 252)
    },
    Bloodrot = {
        Color3.fromRGB(145, 0, 27), Color3.fromRGB(154, 94, 100), Color3.fromRGB(75, 0, 7),
        Color3.fromRGB(72, 0, 2), Color3.fromRGB(121, 112, 112), Color3.fromRGB(255, 152, 154)
    },
    Candy = {
        Color3.fromRGB(255, 105, 180), Color3.fromRGB(255, 182, 193), Color3.fromRGB(200, 50, 150),
        Color3.fromRGB(255, 20, 147), Color3.fromRGB(255, 200, 220), Color3.fromRGB(255, 240, 245)
    },
    Lava = {
        Color3.fromRGB(200, 50, 0), Color3.fromRGB(255, 100, 0), Color3.fromRGB(150, 20, 0),
        Color3.fromRGB(100, 10, 0), Color3.fromRGB(255, 160, 0), Color3.fromRGB(255, 220, 100)
    },
    Galaxy = {
        Color3.fromRGB(60, 0, 120), Color3.fromRGB(100, 0, 180), Color3.fromRGB(30, 0, 80),
        Color3.fromRGB(180, 0, 255), Color3.fromRGB(80, 0, 160), Color3.fromRGB(200, 150, 255)
    },
    YinYang = {
        Color3.fromRGB(13, 13, 13), Color3.fromRGB(20, 20, 28), Color3.fromRGB(230, 230, 240),
        Color3.fromRGB(230, 230, 240), Color3.fromRGB(128, 128, 128), Color3.fromRGB(24, 24, 30)
    },
    Radioactive = {
        Color3.fromRGB(100, 255, 0), Color3.fromRGB(150, 255, 50), Color3.fromRGB(50, 200, 0),
        Color3.fromRGB(0, 150, 0), Color3.fromRGB(200, 255, 100), Color3.fromRGB(230, 255, 180)
    },
    Cursed = {
        Color3.fromRGB(255, 23, 23), Color3.fromRGB(180, 0, 0), Color3.fromRGB(120, 0, 0),
        Color3.fromRGB(80, 0, 0), Color3.fromRGB(255, 100, 100), Color3.fromRGB(255, 180, 180)
    },
    Divine = {
        Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 255, 200), Color3.fromRGB(200, 160, 0),
        Color3.fromRGB(255, 240, 150), Color3.fromRGB(13, 13, 13), Color3.fromRGB(255, 250, 220)
    },
    Phantom = {
        Color3.fromRGB(10, 0, 15), Color3.fromRGB(25, 0, 35), Color3.fromRGB(40, 0, 50),
        Color3.fromRGB(60, 0, 70), Color3.fromRGB(0, 0, 0), Color3.fromRGB(200, 200, 255)
    },
}

local KNOWN_MUTATIONS = {
    YinYang = "rbxassetid://112996178302302",
    Rainbow = "rbxassetid://83078714090192",
    Radioactive = "rbxassetid://134809510446754",
    Phantom = "rbxassetid://133429883380355",
    Lava = "rbxassetid://70800471498231",
    Gold = "rbxassetid://136133057822407",
    Galaxy = "rbxassetid://139331671405138",
    Divine = "rbxassetid://117437279650650",
    Diamond = "rbxassetid://100875709547015",
    Cyber = "rbxassetid://91596580591665",
    Cursed = "rbxassetid://139160534192980",
    Candy = "rbxassetid://84797673698685",
    Bloodrot = "rbxassetid://75212036784031",
}

-- === STATE ===
local selectedEntry = nil
local currentLoadThread = nil
local DUEL_COOLDOWN = 6
local duelCooldowns = {}
local duelOverlays = {}
local duelCountdownThreads = {}

local function _buildCooldownOverlay(card, userId)
    local existing = card:FindFirstChild("_CooldownOverlay")
    if existing then existing:Destroy() end
    local overlay = Instance.new("Frame", card)
    overlay.Name = "_CooldownOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Position = UDim2.new(0, 0, 0, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.45
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 10
    do local c = Instance.new("UICorner", overlay); c.CornerRadius = UDim.new(0, 5) end
    local cdLabel = Instance.new("TextLabel", overlay)
    cdLabel.Name = "Timer"
    cdLabel.Size = UDim2.new(1, 0, 1, 0)
    cdLabel.BackgroundTransparency = 1
    cdLabel.Text = DUEL_COOLDOWN .. "s"
    cdLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    cdLabel.Font = Enum.Font.GothamBlack
    cdLabel.TextSize = 18
    cdLabel.ZIndex = 11
    duelOverlays[userId] = {overlay = overlay, label = cdLabel}
    return overlay, cdLabel
end

local function _findCardForUser(userId)
    for _, c in ipairs(animalScroll:GetChildren()) do
        if c:IsA("Frame") then
            local ref = c:FindFirstChild("DuelPlayerRef")
            if ref and ref:IsA("ObjectValue") and ref.Value and ref.Value.UserId == userId then
                return c
            end
        end
    end
    return nil
end

local function isDuelOnCooldown(userId)
    return duelCooldowns[userId] and duelCooldowns[userId] > tick()
end

local function startDuelCooldown(userId)
    duelCooldowns[userId] = tick() + DUEL_COOLDOWN
    if duelCountdownThreads[userId] then return end
    local card = _findCardForUser(userId)
    if not card then return end
    local overlay, cdLabel = _buildCooldownOverlay(card, userId)
    duelCountdownThreads[userId] = task.spawn(function()
        while duelCooldowns[userId] and duelCooldowns[userId] > tick() do
            local remaining = math.ceil(duelCooldowns[userId] - tick())
            cdLabel.Text = remaining .. "s"
            task.wait(0.25)
        end
        duelCooldowns[userId] = nil
        duelOverlays[userId] = nil
        duelCountdownThreads[userId] = nil
        if overlay and overlay.Parent then
            overlay:Destroy()
        end
    end)
end

local function reapplyCooldownOverlay(userId)
    if not isDuelOnCooldown(userId) then return end
    if duelCountdownThreads[userId] then
        pcall(function() task.cancel(duelCountdownThreads[userId]) end)
        duelCountdownThreads[userId] = nil
    end
    local card = _findCardForUser(userId)
    if not card then return end
    local overlay, cdLabel = _buildCooldownOverlay(card, userId)
    duelCountdownThreads[userId] = task.spawn(function()
        while duelCooldowns[userId] and duelCooldowns[userId] > tick() do
            local remaining = math.ceil(duelCooldowns[userId] - tick())
            cdLabel.Text = remaining .. "s"
            task.wait(0.25)
        end
        duelCooldowns[userId] = nil
        duelOverlays[userId] = nil
        duelCountdownThreads[userId] = nil
        if overlay and overlay.Parent then
            overlay:Destroy()
        end
    end)
end

local function _findVPModel()
    for _, desc in ipairs(viewport:GetDescendants()) do
        if desc:IsA("BasePart") then
            local p = desc
            while p and p ~= viewport do
                if p:IsA("Model") and not p.Name:find("^_Trait%.") then return p end
                p = p.Parent
            end
        end
    end
    return nil
end

local function _attachViaRigid(clone, model)
    local hadConstraint = false
    for _, part in clone:GetDescendants() do
        if part:IsA("Attachment") then
            local target = model:FindFirstChild(part.Name, true)
            if target and target:IsA("Attachment") then
                local rc = Instance.new("RigidConstraint")
                rc.Attachment0 = part
                rc.Attachment1 = target
                rc.Parent = part.Parent
                hadConstraint = true
            end
        end
    end
    if not hadConstraint then
        local rootPart = model.PrimaryPart or model:FindFirstChild("RootPart") or model:FindFirstChildWhichIsA("BasePart")
        if rootPart then
            local cframe = rootPart.CFrame * CFrame.new(0, 3, 0)
            for _, child in clone:GetChildren() do
                if child:IsA("BasePart") then
                    child.CFrame = cframe
                    child.Anchored = true
                end
            end
        end
    end
end

local function ApplyMutation(model, animalName, mutName)
    if not mutName or mutName == "None" then return end
    local sa = GetSharedAnimals()
    if sa then
        local ok = pcall(function() sa:ApplyMutation(model, animalName, mutName) end)
        if ok then return end
    end
    local ok, mutData = pcall(function() return require(ReplicatedStorage.Datas.Mutations) end)
    local palette
    if ok and mutData and mutData[mutName] then
        local mutInfo = mutData[mutName]
        palette = mutInfo.Palettes and mutInfo.Palettes[1]
    end
    if not palette then palette = MUTATION_PALETTES[mutName] end
    local mutSurface = ReplicatedStorage.MutationSurfaces and ReplicatedStorage.MutationSurfaces:FindFirstChild(animalName)
    if mutName == "Rainbow" then
        model:AddTag("RainbowModel")
        return
    end
    if palette then
        for _, v in model:GetDescendants() do
            if v:IsA("BasePart") and not v:GetAttribute("IgnoreColor") then
                pcall(function()
                    local mv = v.MaterialVariant
                    if mv == "Strawberry Stud Light" or mv == "Strawberry Stud Dark" then
                        v.MaterialVariant = mutName .. " Strawberry Stud Light"
                        return
                    end
                    local colIdx = tonumber(v:GetAttribute(("%s*Color"):format(mutName)) or v:GetAttribute("Color") or 1) or 1
                    colIdx = math.clamp(colIdx, 1, #palette)
                    local col = palette[colIdx] or palette[1]
                    if not col then return end
                    local surf = v:FindFirstChildOfClass("SurfaceAppearance")
                    if surf then
                        if mutSurface then
                            surf:Destroy()
                            local newSurf = mutSurface:Clone()
                            newSurf.Color = (mutName == "Divine" and (palette[1] or col)) or col
                            newSurf.Parent = v
                        end
                    else
                        v.Color = col
                    end
                    if v:GetAttribute("Neon") then
                        v.Material = Enum.Material.Neon
                    end
                end)
            end
        end
    end
    if mutName == "Galaxy" then
        for _, v in model:GetDescendants() do
            if v:IsA("BasePart") and not v:GetAttribute("IgnoreColor") then
                pcall(function()
                    if (v:GetAttribute("GalaxyColor") or v:GetAttribute("Color") or 1) == 1 then
                        v.Material = Enum.Material.Neon
                    end
                    v.MaterialVariant = "Galaxy Stud"
                end)
            end
        end
    elseif mutName == "Lava" then
        for _, v in model:GetDescendants() do
            if v:IsA("BasePart") and not v:GetAttribute("IgnoreColor") then
                pcall(function()
                    if (v:GetAttribute("LavaColor") or v:GetAttribute("Color") or 1) == 1 then
                        v.Material = Enum.Material.Neon
                    end
                end)
            end
        end
    elseif mutName == "YinYang" then
        for _, v in model:GetDescendants() do
            if v:IsA("BasePart") and not v:GetAttribute("IgnoreColor") then
                pcall(function()
                    local c = v:GetAttribute("YinYangColor") or v:GetAttribute("Color") or 1
                    if c == 3 or c == 4 then
                        v.Material = Enum.Material.Neon
                    end
                end)
            end
        end
    elseif mutName == "Divine" then
        local emissive = model:GetAttribute("EmissiveStrength") or 2
        for _, v in model:GetDescendants() do
            if v:IsA("SurfaceAppearance") then
                pcall(function() v.EmissiveStrength = emissive end)
            end
            if v:IsA("BasePart") and not v:GetAttribute("IgnoreColor") then
                pcall(function()
                    local c = v:GetAttribute("DivineColor") or v:GetAttribute("Color") or 1
                    if c == 2 then v.Material = Enum.Material.Neon end
                    if v:GetAttribute("Divine*Stud") == false then
                        v.MaterialVariant = ""
                    elseif v.MaterialVariant == "Custom Stud" or v:GetAttribute("Divine*Stud") == true then
                        v.Material = Enum.Material.SmoothPlastic
                        v.MaterialVariant = "Divine Stud"
                    elseif c ~= 2 and c ~= 6 then
                        v.Material = Enum.Material.SmoothPlastic
                        v.MaterialVariant = "Divine Stud"
                    end
                end)
            end
        end
    elseif mutName == "Radioactive" then
        for _, v in model:GetDescendants() do
            if v:IsA("BasePart") and not v:GetAttribute("IgnoreColor") then
                pcall(function()
                    local c = v:GetAttribute("RadioactiveColor") or v:GetAttribute("Color") or 1
                    if c == 2 then v.Material = Enum.Material.Neon end
                    if v:GetAttribute("Radioactive*Stud") == false then
                        v.MaterialVariant = ""
                    elseif v.MaterialVariant == "Custom Stud" or v:GetAttribute("Radioactive*Stud") == true or (c ~= 2 and c ~= 6) then
                        v.Material = Enum.Material.SmoothPlastic
                        v.MaterialVariant = "Radioactive Stud"
                    end
                end)
            end
        end
    elseif mutName == "Cursed" then
        for _, v in model:GetDescendants() do
            if v:IsA("BasePart") and not v:GetAttribute("IgnoreColor") then
                pcall(function()
                    local c = v:GetAttribute("CursedColor") or v:GetAttribute("Color") or 1
                    if c == 2 then v.Material = Enum.Material.Neon end
                    if v:GetAttribute("Cursed*Stud") == false then
                        v.MaterialVariant = ""
                    elseif v.MaterialVariant == "Custom Stud" or v:GetAttribute("Cursed*Stud") == true or (c ~= 2 and c ~= 6) then
                        v.Material = Enum.Material.SmoothPlastic
                        v.MaterialVariant = "Cursed Stud"
                        v.Color = Color3.fromRGB(255, 23, 23)
                    end
                    local sa = v:FindFirstChildOfClass("SurfaceAppearance")
                    if sa then
                        if not v:GetAttribute("Cursed*IgnoreSurfaceColor") then
                            sa.Color = Color3.fromRGB(255, 23, 23)
                        end
                        if v:GetAttribute("IgnoreSurface") then
                            sa:Destroy()
                        end
                    end
                end)
            end
        end
        local tpa = ReplicatedStorage.Models:FindFirstChild("TraitsPerAnimal")
        local zombieFolder = tpa and tpa:FindFirstChild("Zombie")
        local zombieModel = zombieFolder and zombieFolder:FindFirstChild(animalName)
        if zombieModel then
            local clone = zombieModel:Clone()
            clone.Name = "_Trait.Zombie"
            for _, part in clone:GetChildren() do
                part.Color = Color3.fromRGB(255, 23, 23)
                local att = part:FindFirstChildOfClass("Attachment")
                local target = att and model:FindFirstChild(att.Name, true)
                if target then
                    local rc = Instance.new("RigidConstraint")
                    rc.Attachment0 = att
                    rc.Attachment1 = target
                    rc.Parent = part
                else
                    part:Destroy()
                end
            end
            clone.Parent = model
        end
    elseif mutName == "Cyber" then
        for _, v in model:GetDescendants() do
            if v:IsA("BasePart") and v.Transparency ~= 1 and not v:GetAttribute("IgnoreColor") then
                pcall(function()
                    local c = tonumber(v:GetAttribute("Cyber*Color") or v:GetAttribute("Color") or 1) or 1
                    if v:GetAttribute("Eyes") then
                        v.Color = Color3.fromRGB(62, 155, 255)
                        v.Transparency = 0.25
                        v.Material = Enum.Material.Neon
                        return
                    end
                    if c == 7 then
                        v.Material = Enum.Material.Neon
                    elseif c == 4 then
                        v.Transparency = 0.5
                        v.Material = Enum.Material.SmoothPlastic
                        v.MaterialVariant = "Tech Stud"
                        v.Color = Color3.fromRGB(62, 155, 255)
                    elseif c == 3 then
                        v.Material = Enum.Material.Glass
                        v.Transparency = 0.5
                        if not v:FindFirstChildOfClass("SurfaceAppearance") and v.ClassName == "MeshPart" then
                            Instance.new("SurfaceAppearance").Parent = v
                        end
                    elseif c == 1 then
                        v.Material = Enum.Material.Glass
                        v.Transparency = 0.25
                        if not v:FindFirstChildOfClass("SurfaceAppearance") and v.ClassName == "MeshPart" then
                            Instance.new("SurfaceAppearance").Parent = v
                        end
                    end
                    local surf = v:FindFirstChildOfClass("SurfaceAppearance")
                    if surf then
                        local vol = v.Size.X * v.Size.Y * v.Size.Z
                        v.Transparency = 0
                        v.Material = Enum.Material.Neon
                        surf.AlphaMode = Enum.AlphaMode.Overlay
                        surf.EmissiveTint = Color3.fromRGB(255, 255, 255)
                        if vol > 3 then
                            surf.Color = Color3.fromRGB(35, 75, 115)
                            surf.EmissiveStrength = 50
                        else
                            surf.Color = Color3.fromRGB(0, 25, 30)
                            surf.EmissiveStrength = 25
                        end
                    end
                end)
            end
        end
    end
    if mutName == "Phantom" then
        for _, v in model:GetDescendants() do
            if v:IsA("BasePart") and not v:GetAttribute("IgnoreColor") then
                pcall(function()
                    if v:GetAttribute("Eyes") or v:GetAttribute("Teeth") then
                        v.Color = Color3.fromRGB(255, 255, 255)
                        v.Transparency = 0
                        v.Material = Enum.Material.Neon
                    else
                        v.Color = Color3.fromRGB(10, 0, 15)
                        v.Transparency = 0.35
                        v.Material = Enum.Material.SmoothPlastic
                        v.MaterialVariant = "Phantom Stud"
                    end
                    local surf = v:FindFirstChildOfClass("SurfaceAppearance")
                    if surf then
                        surf.Color = Color3.fromRGB(0, 0, 0)
                        surf.AlphaMode = Enum.AlphaMode.Overlay
                    end
                end)
            end
        end
    end
end

local function ApplyTraits(model, animalName, tierName)
    if not tierName then return end
    local sa = GetSharedAnimals()
    local apiApplied = false
    if sa then
        pcall(function()
            sa:ApplyTraits(model, animalName, {tierName})
            apiApplied = true
        end)
    end
    if apiApplied and model:FindFirstChild("_Trait." .. tierName) then return end
    local RS = ReplicatedStorage
    local tap = RS.Models:FindFirstChild("TraitsPerAnimal")
    local modTraits = RS.Models:FindFirstChild("Traits")
    local vfxTraits = RS.Vfx and RS.Vfx:FindFirstChild("Traits")
    local rootPart = model.PrimaryPart or model:FindFirstChild("RootPart")
    pcall(function()
        if model:FindFirstChild("_Trait." .. tierName) then return end
        local applied = false
        if tap then
            local traitFolder = tap:FindFirstChild(tierName)
            local traitModel = traitFolder and traitFolder:FindFirstChild(animalName)
            if traitModel then
                local clone = traitModel:Clone()
                clone.Name = "_Trait." .. tierName
                _attachViaRigid(clone, model)
                clone.Parent = model
                applied = true
            end
        end
        if not applied and modTraits then
            local traitModel = modTraits:FindFirstChild(tierName)
            if traitModel then
                local clone = traitModel:Clone()
                clone.Name = "_Trait." .. tierName
                _attachViaRigid(clone, model)
                clone.Parent = model
                applied = true
            end
        end
        if not applied and vfxTraits then
            local vfxModel = vfxTraits:FindFirstChild(tierName)
            if vfxModel then
                local clone = vfxModel:Clone()
                clone.Name = "_Trait." .. tierName
                local vfxPart = clone:FindFirstChild("VfxInstance")
                if vfxPart and rootPart then
                    local att = vfxPart:FindFirstChildOfClass("Attachment")
                    local targetAtt = att and model:FindFirstChild(att.Name, true)
                    if targetAtt then
                        local rc = Instance.new("RigidConstraint")
                        rc.Attachment0 = att
                        rc.Attachment1 = targetAtt
                        rc.Parent = vfxPart
                    else
                        local weld = Instance.new("Weld")
                        weld.Part0 = rootPart
                        weld.Part1 = vfxPart
                        weld.C0 = CFrame.new(0, 0, 0)
                        weld.Parent = vfxPart
                    end
                end
                clone.Parent = model
                applied = true
            end
        end
        if not applied then
            local broad = RS.Models:FindFirstChild(tierName, true)
            if broad and broad:IsA("Model") then
                local clone = broad:Clone()
                clone.Name = "_Trait." .. tierName
                _attachViaRigid(clone, model)
                clone.Parent = model
            end
        end
    end)
end

local function loadBrainrotPreview(name, mutation, tierName)
    if currentLoadThread then
        task.cancel(currentLoadThread)
        currentLoadThread = nil
    end
    for _, child in ipairs(viewport:GetChildren()) do
        if child ~= vpCam then child:Destroy() end
    end
    viewport.Visible = false
    placeholderLbl.Visible = true
    if not name or name == "" then return end
    local sa = GetSharedAnimals()
    if not sa or not sa.AttachOnViewportWithOptimizations then return end
    currentLoadThread = task.spawn(function()
        local ok = pcall(function()
            sa:AttachOnViewportWithOptimizations(name, viewport, "None", nil)
        end)
        if not ok then return end
        if (not mutation or mutation == "None") and not tierName then
            viewport.Visible = true
            placeholderLbl.Visible = false
            return
        end
        for _ = 1, 30 do
            local m = _findVPModel()
            if m then
                if mutation and mutation ~= "None" then
                    ApplyMutation(m, name, mutation)
                end
                if tierName then
                    ApplyTraits(m, name, tierName)
                end
                local okExt, ext = pcall(function() return m:GetExtentsSize() end)
                if okExt and ext then
                    local maxDim = math.max(ext.X, ext.Y, ext.Z)
                    local dist = (maxDim * 0.5 / math.tan(math.rad(25))) * 0.75
                    local lookAt = (m.PrimaryPart and m.PrimaryPart.CFrame) or CFrame.new(0, 0, 0)
                    vpCam.CFrame = CFrame.new(
                        (lookAt * CFrame.new(Vector3.new(-1, 0.25, -1).Unit * (dist + maxDim * 0.5))).Position,
                        lookAt.Position
                    )
                end
                viewport.Visible = true
                placeholderLbl.Visible = false
                return
            end
            task.wait()
        end
        viewport.Visible = true
        placeholderLbl.Visible = false
    end)
end

local MUT_COLORS = {
    None=Color3.fromRGB(255,255,255),
    Gold=Color3.fromRGB(220,220,220),
    Diamond=Color3.fromRGB(180,180,180),
    Bloodrot=Color3.fromRGB(160,160,160),
    Rainbow=Color3.fromRGB(200,200,200),
    Candy=Color3.fromRGB(190,190,190),
    Lava=Color3.fromRGB(170,170,170),
    Galaxy=Color3.fromRGB(150,150,150),
    YinYang=Color3.fromRGB(200,200,200),
    Radioactive=Color3.fromRGB(180,180,180),
    Cursed=Color3.fromRGB(140,140,140),
    Divine=Color3.fromRGB(230,230,230),
    Cyber=Color3.fromRGB(175,175,175),
    Phantom=Color3.fromRGB(130,130,130)
}

local function selectEntry(entry)
    selectedEntry = entry
    if entry then
        nameLbl.Text = "Name: " .. entry.name
        ownerLbl.Text = "Owner: " .. entry.ownerName
        mutLbl.Text = "Mutation: " .. (entry.mutation or "None")
        mutLbl.TextColor3 = entry.mutation and (MUT_COLORS[entry.mutation] or ACCENT) or (MUT_COLORS.None or GRAY)
        local tn = entry.tier or nil
        local ti = tn and TraitsData and TraitsData[tn]
        local ic = ti and (type(ti.Icon) == "string" and ti.Icon ~= "") and ti.Icon or nil
        if ic then
            infoTierIcon.Image = ic
            infoTierIcon.Visible = true
            infoTierLbl.Position = UDim2.new(0, 14, 0, 0)
        else
            infoTierIcon.Visible = false
            infoTierLbl.Position = UDim2.new(0, 0, 0, 0)
        end
        infoTierLbl.Text = tn and ("Tiers: " .. tn) or ""
        infoTierLbl.TextColor3 = tn and Color3.fromRGB(180, 180, 180) or GRAY
        local gen, price = calcFinalGen(entry.name, entry.mutation, entry.tier)
        genLbl.Text = "Genera: " .. (gen and formatMoney(gen) .. "/s" or "-")
        genLbl.TextColor3 = gen and Color3.fromRGB(180, 180, 180) or GRAY
        priceLbl.Text = "Price: " .. (price and formatMoney(price) or "-")
        priceLbl.TextColor3 = price and Color3.fromRGB(150, 150, 150) or GRAY
        loadBrainrotPreview(entry.name, entry.mutation, entry.tier)
    else
        nameLbl.Text = "Name: -"
        ownerLbl.Text = "Owner: -"
        mutLbl.Text = "Mutation: -"
        mutLbl.TextColor3 = GRAY
        infoTierIcon.Visible = false
        infoTierLbl.Position = UDim2.new(0, 0, 0, 0)
        infoTierLbl.Text = "Tiers: -"
        genLbl.Text = "Genera: -"
        genLbl.TextColor3 = GRAY
        priceLbl.Text = "Price: -"
        priceLbl.TextColor3 = GRAY
        for _, child in ipairs(viewport:GetChildren()) do
            if child ~= vpCam then child:Destroy() end
        end
        viewport.Visible = false
        placeholderLbl.Visible = true
    end
end

-- === ENVOI DUEL ===
local function sendDuelToPlayer(targetName)
    local gui = LP.PlayerGui:FindFirstChild("DuelsMachinePlayerList")
    gui = gui and gui:FindFirstChild("DuelsMachinePlayerList")
    if not gui then return false end
    local localList = gui:FindFirstChild("LocalList")
    if not localList then return false end
    for _, entry in pairs(localList:GetChildren()) do
        if entry.Name:lower():find(targetName:lower(), 1, true) then
            local fill = entry:FindFirstChild("Fill")
            local send = fill and fill:FindFirstChild("Send")
            if send then
                for _, event in ipairs({send.MouseButton1Click, send.MouseButton1Down, send.Activated}) do
                    local conns = getconnections(event)
                    if conns and #conns > 0 then
                        for _, conn in ipairs(conns) do
                            pcall(conn.Function)
                        end
                    end
                end
            end
            return true
        end
    end
    return false
end

-- === ENVOI TRADE ===
local function sendTradeToPlayer(targetName)
    local gui = LP.PlayerGui:FindFirstChild("TradePlayerList")
    if not gui then return false end
    local frame = gui:FindFirstChild("TradePlayerList")
    if not frame then return false end
    local sections = frame:FindFirstChild("Sections")
    if not sections then return false end
    local playersFrame = sections:FindFirstChild("Players")
    if not playersFrame then return false end
    local list = playersFrame:FindFirstChild("List")
    if not list then return false end

    for _, entry in pairs(list:GetChildren()) do
        if entry:IsA("Frame") and entry.Name ~= "Separator" then
            local fill = entry:FindFirstChild("Fill")
            if fill then
                local usernameLabel = fill:FindFirstChild("Username")
                local matched = false

                if usernameLabel and usernameLabel:IsA("TextLabel") then
                    local username = usernameLabel.Text
                    if username and username:lower():find(targetName:lower(), 1, true) then
                        matched = true
                    end
                end

                if not matched then
                    local frameName = entry.Name:split("_")[1] or entry.Name
                    if frameName:lower():find(targetName:lower(), 1, true) then
                        matched = true
                    end
                end

                if matched then
                    local sendBtn = fill:FindFirstChild("Send")
                    if sendBtn and (sendBtn:IsA("ImageButton") or sendBtn:IsA("TextButton")) then
                        for _, event in ipairs({sendBtn.MouseButton1Click, sendBtn.MouseButton1Down, sendBtn.Activated}) do
                            local conns = getconnections(event)
                            if conns and #conns > 0 then
                                for _, conn in ipairs(conns) do
                                    pcall(conn.Function)
                                end
                            end
                        end
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- Per-animal settings GUI
local function openAnimalSettings(animalName)
    local existing = sg:FindFirstChild("_Settings_" .. animalName)
    if existing then
        existing:Destroy()
        return
    end
    for _, c in ipairs(sg:GetChildren()) do
        if c.Name:find("^_Settings_") then
            c:Destroy()
        end
    end
    local data = animalSettings[animalName]
    if not data then
        data = {mutBlack = {}, tierBlack = {}}
        animalSettings[animalName] = data
    end
    local gw, gh = 230, 300
    local panel = Instance.new("Frame", sg)
    panel.Name = "_Settings_" .. animalName
    panel.Size = UDim2.new(0, gw, 0, gh)
    panel.Position = UDim2.new(0.5, -gw/2, 0.5, -gh/2)
    panel.BackgroundColor3 = DARK
    panel.BackgroundTransparency = 0
    panel.BorderSizePixel = 0
    panel.Active = true
    panel.ZIndex = 200

    local bg = Instance.new("ImageLabel", panel)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundTransparency = 1
    bg.Image = "rbxassetid://90746158236678"
    bg.ImageColor3 = Color3.fromRGB(25, 25, 25)
    bg.ScaleType = Enum.ScaleType.Crop
    bg.ZIndex = 0

    do
        local c = Instance.new("UICorner", panel)
        c.CornerRadius = UDim.new(0, 8)
    end
    do
        local c = Instance.new("UICorner", bg)
        c.CornerRadius = UDim.new(0, 8)
    end
    do
        local s = Instance.new("UIStroke", panel)
        s.Color = LINE
        s.Thickness = 2
        s.Transparency = 0.2
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    end

    local header = Instance.new("Frame", panel)
    header.Size = UDim2.new(1, -12, 0, 30)
    header.Position = UDim2.new(0, 6, 0, 6)
    header.BackgroundColor3 = SURFACE
    header.BorderSizePixel = 0

    do
        local c = Instance.new("UICorner", header)
        c.CornerRadius = UDim.new(0, 6)
    end

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -8, 1, 0)
    title.Position = UDim2.new(0, 8, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = animalName
    title.TextColor3 = ACCENT
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left

    local closeSettingsBtn = Instance.new("TextButton", header)
    closeSettingsBtn.Size = UDim2.new(0, 20, 0, 20)
    closeSettingsBtn.Position = UDim2.new(1, -24, 0, 5)
    closeSettingsBtn.BackgroundColor3 = Color3.fromRGB(130, 25, 25)
    closeSettingsBtn.BorderSizePixel = 0
    closeSettingsBtn.Text = "X"
    closeSettingsBtn.TextColor3 = WHITE
    closeSettingsBtn.Font = Enum.Font.GothamBold
    closeSettingsBtn.TextSize = 10

    do
        local c = Instance.new("UICorner", closeSettingsBtn)
        c.CornerRadius = UDim.new(1, 0)
    end

    closeSettingsBtn.MouseButton1Click:Connect(function() panel:Destroy() end)

    local settingsDragging, settingsDragStart, settingsFrameStart = false
    header.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            settingsDragging = true
            settingsDragStart = inp.Position
            settingsFrameStart = panel.Position
        end
    end)
    header.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            settingsDragging = false
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if settingsDragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local d = inp.Position - settingsDragStart
            panel.Position = UDim2.new(
                settingsFrameStart.X.Scale,
                settingsFrameStart.X.Offset + d.X,
                settingsFrameStart.Y.Scale,
                settingsFrameStart.Y.Offset + d.Y
            )
        end
    end)

    local contentTopSettings = 42
    local settingsContent = Instance.new("ScrollingFrame", panel)
    settingsContent.Size = UDim2.new(1, -16, 1, -contentTopSettings - 8)
    settingsContent.Position = UDim2.new(0, 8, 0, contentTopSettings)
    settingsContent.BackgroundTransparency = 1
    settingsContent.BorderSizePixel = 0
    settingsContent.ScrollBarThickness = 3
    settingsContent.ScrollBarImageColor3 = ACCENT
    settingsContent.ScrollBarImageTransparency = 0.45
    settingsContent.CanvasSize = UDim2.new(0, 0, 0, 0)

    local contentLayout = Instance.new("UIListLayout", settingsContent)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 6)

    local function makeSection(titleText)
        local section = Instance.new("Frame", settingsContent)
        section.Size = UDim2.new(1, 0, 0, 20)
        section.BackgroundTransparency = 1
        local label = Instance.new("TextLabel", section)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = titleText
        label.TextColor3 = ACCENT
        label.Font = Enum.Font.GothamBlack
        label.TextSize = 10
        label.TextXAlignment = Enum.TextXAlignment.Left
    end

    makeSection("MUTATIONS")

    local mutSet = {}
    if MutationsData and type(MutationsData) == "table" then
        for k, _ in pairs(MutationsData) do
            if type(k) == "string" and k ~= "None" and k ~= "" then
                mutSet[k] = true
            end
        end
    end
    if next(mutSet) == nil then
        for _, m in ipairs({"Gold","Diamond","Bloodrot","Rainbow","Candy","Lava","Galaxy","YinYang","Radioactive","Cursed","Divine","Cyber","Phantom"}) do
            mutSet[m] = true
        end
    end

    local allMuts = {"None"}
    for k in pairs(mutSet) do
        table.insert(allMuts, k)
    end
    table.sort(allMuts, function(a, b)
        if a == "None" then return true end
        if b == "None" then return false end
        return a < b
    end)

    local mutGrid = Instance.new("Frame", settingsContent)
    mutGrid.Size = UDim2.new(1, 0, 0, 0)
    mutGrid.BackgroundTransparency = 1

    local mutGridLayout = Instance.new("UIGridLayout", mutGrid)
    mutGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    mutGridLayout.CellSize = UDim2.new(0, 60, 0, 62)
    mutGridLayout.CellPadding = UDim2.new(0, 3, 0, 3)

    for _, mutName in ipairs(allMuts) do
        local bl = data.mutBlack[mutName] == true
        local cell = Instance.new("TextButton", mutGrid)
        cell.Size = UDim2.new(1, 0, 1, 0)
        cell.BackgroundColor3 = bl and Color3.fromRGB(42, 22, 22) or DARK
        cell.BorderSizePixel = 0
        cell.Text = ""

        do
            local c = Instance.new("UICorner", cell)
            c.CornerRadius = UDim.new(0, 4)
        end
        do
            local s = Instance.new("UIStroke", cell)
            s.Color = bl and RED or LINE
            s.Thickness = 1
            s.Transparency = bl and 0.25 or 0.6
            s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        end

        local imgId = KNOWN_MUTATIONS[mutName]
        if imgId then
            local icon = Instance.new("ImageLabel", cell)
            icon.Size = UDim2.new(0, 44, 0, 44)
            icon.Position = UDim2.new(0.5, -22, 0, 1)
            icon.BackgroundTransparency = 1
            icon.BorderSizePixel = 0
            icon.Image = imgId
        else
            local pal = MUTATION_PALETTES[mutName]
            local color = pal and pal[1] or Color3.fromRGB(80, 80, 80)
            local colorBlock = Instance.new("Frame", cell)
            colorBlock.Size = UDim2.new(0, 44, 0, 44)
            colorBlock.Position = UDim2.new(0.5, -22, 0, 1)
            colorBlock.BackgroundColor3 = color
            colorBlock.BorderSizePixel = 0
            do
                local c = Instance.new("UICorner", colorBlock)
                c.CornerRadius = UDim.new(0, 4)
            end
            local mc = MUT_COLORS[mutName]
            if mc then
                do
                    local s = Instance.new("UIStroke", colorBlock)
                    s.Color = mc
                    s.Thickness = 1
                    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                end
            end
        end

        local mutNameLbl = Instance.new("TextLabel", cell)
        mutNameLbl.Size = UDim2.new(1, -2, 0, 12)
        mutNameLbl.Position = UDim2.new(0, 1, 0, 48)
        mutNameLbl.BackgroundTransparency = 1
        mutNameLbl.Text = mutName
        mutNameLbl.TextColor3 = bl and Color3.fromRGB(170, 170, 170) or WHITE
        mutNameLbl.Font = Enum.Font.Gotham
        mutNameLbl.TextSize = 7
        mutNameLbl.TextXAlignment = Enum.TextXAlignment.Center
        mutNameLbl.TextTruncate = Enum.TextTruncate.AtEnd

        cell.MouseButton1Click:Connect(function()
            local newBl = not data.mutBlack[mutName]
            if newBl then
                data.mutBlack[mutName] = true
            else
                data.mutBlack[mutName] = nil
            end
            cell.BackgroundColor3 = newBl and Color3.fromRGB(42, 22, 22) or DARK
            local nameL = cell:FindFirstChildOfClass("TextLabel")
            if nameL then
                nameL.TextColor3 = newBl and Color3.fromRGB(170, 170, 170) or WHITE
            end
            local s = cell:FindFirstChildOfClass("UIStroke")
            if s then
                s.Color = newBl and RED or LINE
                s.Transparency = newBl and 0.25 or 0.6
            end
            saveConfig()
            task.spawn(function()
                scanAllPlots()
                rebuildAnimalList()
            end)
        end)
    end
    mutGrid.Size = UDim2.new(1, 0, 0, math.ceil(#allMuts / 3) * 65)

    local allTiers = {}
    if TraitsData and type(TraitsData) == "table" then
        for k, v in pairs(TraitsData) do
            if type(k) == "string" and type(v) == "table" and type(v.Icon) == "string" and v.Icon ~= "" then
                table.insert(allTiers, {name = k, icon = v.Icon})
            end
        end
        table.sort(allTiers, function(a, b) return a.name < b.name end)
    end

    if #allTiers > 0 then
        makeSection("TIERS")
        local tierGrid = Instance.new("Frame", settingsContent)
        tierGrid.Size = UDim2.new(1, 0, 0, 0)
        tierGrid.BackgroundTransparency = 1

        local tierGridLayout = Instance.new("UIGridLayout", tierGrid)
        tierGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tierGridLayout.CellSize = UDim2.new(0, 50, 0, 50)
        tierGridLayout.CellPadding = UDim2.new(0, 3, 0, 3)

        for _, tierInfo in ipairs(allTiers) do
            local bl = data.tierBlack[tierInfo.name] == true
            local cell = Instance.new("TextButton", tierGrid)
            cell.Size = UDim2.new(1, 0, 1, 0)
            cell.BackgroundColor3 = bl and Color3.fromRGB(42, 22, 22) or DARK
            cell.BorderSizePixel = 0
            cell.Text = ""

            do
                local c = Instance.new("UICorner", cell)
                c.CornerRadius = UDim.new(0, 4)
            end
            do
                local s = Instance.new("UIStroke", cell)
                s.Color = bl and RED or LINE
                s.Thickness = 1
                s.Transparency = bl and 0.25 or 0.6
                s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            end

            local icon = Instance.new("ImageLabel", cell)
            icon.Size = UDim2.new(0, 34, 0, 34)
            icon.Position = UDim2.new(0.5, -17, 0.5, -17)
            icon.BackgroundTransparency = 1
            icon.BorderSizePixel = 0
            icon.Image = tierInfo.icon

            cell.MouseButton1Click:Connect(function()
                local newBl = not data.tierBlack[tierInfo.name]
                if newBl then
                    data.tierBlack[tierInfo.name] = true
                else
                    data.tierBlack[tierInfo.name] = nil
                end
                cell.BackgroundColor3 = newBl and Color3.fromRGB(42, 22, 22) or DARK
                local s = cell:FindFirstChildOfClass("UIStroke")
                if s then
                    s.Color = newBl and RED or LINE
                    s.Transparency = newBl and 0.25 or 0.6
                end
                saveConfig()
                task.spawn(function()
                    scanAllPlots()
                    rebuildAnimalList()
                end)
            end)
        end
        tierGrid.Size = UDim2.new(1, 0, 0, math.ceil(#allTiers / 4) * 53)
    end

    task.spawn(function()
        settingsContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 4)
    end)
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        settingsContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 4)
    end)
end

local function rebuildBrainrotGrid(filter)
    for _, c in ipairs(brainrotScroll:GetChildren()) do
        if c:IsA("Frame") then
            c:Destroy()
        end
    end

    local rarityOrder = {OG = 1, Secret = 2, Exclusive = 999}
    local sorted = {}
    for _, bName in ipairs(ALL_BRAINROTS) do
        local entry = AnimalsData and AnimalsData[bName]
        local priority = math.huge
        local price = 0
        if entry then
            if type(entry.Rarity) == "string" then
                priority = rarityOrder[entry.Rarity] or 3
            elseif type(entry.Generation) == "number" then
                priority = entry.Generation
            end
            price = entry.Price or 0
        end
        table.insert(sorted, {name = bName, priority = priority, price = price})
    end
    table.sort(sorted, function(a, b)
        if a.priority ~= b.priority then return a.priority < b.priority end
        return a.price > b.price
    end)

    for i, item in ipairs(sorted) do
        local bName = item.name
        if filter and filter ~= "" then
            if not bName:lower():find(filter:lower(), 1, true) then continue end
        end

        local isBlacklisted = blacklist[bName] == true
        local cell = Instance.new("Frame", brainrotScroll)
        cell.LayoutOrder = i
        cell.Size = UDim2.new(1, 0, 1, 0)
        cell.BackgroundColor3 = isBlacklisted and Color3.fromRGB(42, 22, 22) or DARK
        cell.BorderSizePixel = 0

        do
            local c = Instance.new("UICorner", cell)
            c.CornerRadius = UDim.new(0, 4)
        end
        do
            local s = Instance.new("UIStroke", cell)
            s.Color = isBlacklisted and RED or LINE
            s.Thickness = 1
            s.Transparency = isBlacklisted and 0.25 or 0.6
            s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        end

        local smallVP = Instance.new("ViewportFrame", cell)
        smallVP.Size = UDim2.new(0, 44, 0, 30)
        smallVP.Position = UDim2.new(0.5, -22, 0, 2)
        smallVP.BackgroundTransparency = 1
        smallVP.Visible = false

        local smallCam = Instance.new("Camera", smallVP)
        smallVP.CurrentCamera = smallCam
        smallCam.FieldOfView = 50

        local nameLabel = Instance.new("TextLabel", cell)
        nameLabel.Size = UDim2.new(1, -2, 0, 12)
        nameLabel.Position = UDim2.new(0, 1, 0, 34)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = bName
        nameLabel.TextColor3 = isBlacklisted and Color3.fromRGB(170, 170, 170) or WHITE
        nameLabel.Font = Enum.Font.Gotham
        nameLabel.TextSize = 8
        nameLabel.TextXAlignment = Enum.TextXAlignment.Center
        nameLabel.TextTruncate = Enum.TextTruncate.AtEnd

        local clickBtn = Instance.new("TextButton", cell)
        clickBtn.Size = UDim2.new(1, 0, 1, 0)
        clickBtn.Position = UDim2.new(0, 0, 0, 0)
        clickBtn.BackgroundTransparency = 1
        clickBtn.Text = ""
        clickBtn.ZIndex = 5

        local gearSmall = Instance.new("TextButton", cell)
        gearSmall.Size = UDim2.new(0, 14, 0, 14)
        gearSmall.Position = UDim2.new(1, -16, 0, 1)
        gearSmall.BackgroundTransparency = 1
        gearSmall.BorderSizePixel = 0
        gearSmall.Text = "⚙"
        gearSmall.TextColor3 = Color3.fromRGB(140, 140, 140)
        gearSmall.Font = Enum.Font.Gotham
        gearSmall.TextSize = 10
        gearSmall.ZIndex = 10

        local gearAnimalName = bName
        gearSmall.MouseButton1Click:Connect(function()
            openAnimalSettings(gearAnimalName)
        end)

        local cellName = bName
        task.spawn(function()
            task.wait(math.min(i * 0.005, 0.3))
            if not cell.Parent then return end
            local ok = pcall(function()
                if AnimalsAPI then
                    AnimalsAPI:AttachOnViewportWithOptimizations(cellName, smallVP, "None", nil)
                end
            end)
            if ok then
                for _ = 1, 10 do
                    local m = nil
                    for _, desc in ipairs(smallVP:GetDescendants()) do
                        if desc:IsA("BasePart") then
                            local p = desc
                            while p and p ~= smallVP do
                                if p:IsA("Model") and not p.Name:find("^_Trait%.") then
                                    m = p
                                    break
                                end
                                p = p.Parent
                            end
                        end
                        if m then break end
                    end
                    if m then
                        local okExt, ext = pcall(function() return m:GetExtentsSize() end)
                        if okExt and ext then
                            local maxDim = math.max(ext.X, ext.Y, ext.Z)
                            local dist = (maxDim * 0.5 / math.tan(math.rad(25))) * 0.75
                            local lookAt = (m.PrimaryPart and m.PrimaryPart.CFrame) or CFrame.new(0, 0, 0)
                            smallCam.CFrame = CFrame.new(
                                (lookAt * CFrame.new(Vector3.new(-1, 0.25, -1).Unit * (dist + maxDim * 0.5))).Position,
                                lookAt.Position
                            )
                        end
                        smallVP.Visible = true
                        break
                    end
                    task.wait()
                end
                smallVP.Visible = true
            end
        end)

        local function toggleCell()
            local wasBlacklisted = blacklist[cellName] ~= nil
            if wasBlacklisted then
                blacklist[cellName] = nil
            else
                blacklist[cellName] = true
            end
            saveConfig()
            applyBlacklistToWorld()
            local bl = blacklist[cellName]
            cell.BackgroundColor3 = bl and Color3.fromRGB(42, 22, 22) or DARK
            local stroke = cell:FindFirstChildOfClass("UIStroke")
            if stroke then
                stroke.Color = bl and RED or LINE
                stroke.Transparency = bl and 0.25 or 0.6
            end
            nameLabel.TextColor3 = bl and Color3.fromRGB(170, 170, 170) or WHITE
            if wasBlacklisted then
                task.spawn(function()
                    scanAllPlots()
                    rebuildAnimalList()
                end)
            else
                local filtered = {}
                for _, e in ipairs(scannedAnimals) do
                    if not blacklist[e.name] then
                        table.insert(filtered, e)
                    end
                end
                scannedAnimals = filtered
                rebuildAnimalList()
            end
        end

        clickBtn.MouseButton1Click:Connect(function()
            toggleCell()
        end)
    end
    task.wait()
    brainrotScroll.CanvasSize = UDim2.new(0, 0, 0, brainrotGrid.AbsoluteContentSize.Y + 4)
end

local function getAvatar(userId)
    return "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=60&height=60&format=png"
end

rebuildAnimalList = function()
    for _, c in ipairs(animalScroll:GetChildren()) do
        if c:IsA("Frame") or c:IsA("TextLabel") then
            c:Destroy()
        end
    end

    if #scannedAnimals == 0 then
        local empty = Instance.new("TextLabel", animalScroll)
        empty.Size = UDim2.new(1, 0, 0, 40)
        empty.BackgroundTransparency = 1
        empty.Text = "No animals found"
        empty.TextColor3 = GRAY
        empty.Font = Enum.Font.Gotham
        empty.TextSize = 12
        animalScroll.CanvasSize = UDim2.new(0, 0, 0, 44)
        selectEntry(nil)
        return
    end

    local displayList = {}
    for _, e in ipairs(scannedAnimals) do
        table.insert(displayList, e)
    end
    table.sort(displayList, function(a, b)
        local pa = isPriorityPlayer(a.player) and 1 or 0
        local pb = isPriorityPlayer(b.player) and 1 or 0
        if pa ~= pb then return pa > pb end
        return a.ownerName < b.ownerName
    end)

    for i, entry in ipairs(displayList) do
        local card = Instance.new("Frame", animalScroll)
        card.LayoutOrder = i
        card.Size = UDim2.new(1, 0, 0, 80)
        card.BackgroundColor3 = DARK
        card.BorderSizePixel = 0

        do
            local c = Instance.new("UICorner", card)
            c.CornerRadius = UDim.new(0, 5)
        end
        do
            local s = Instance.new("UIStroke", card)
            s.Color = LINE
            s.Transparency = 0.75
            s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        end

        local avi = Instance.new("ImageLabel", card)
        avi.Size = UDim2.new(0, 26, 0, 26)
        avi.Position = UDim2.new(0, 4, 0, 4)
        avi.BackgroundColor3 = SURFACE
        avi.BorderSizePixel = 0
        avi.Image = getAvatar(entry.player.UserId)

        do
            local c = Instance.new("UICorner", avi)
            c.CornerRadius = UDim.new(1, 0)
        end

        local isPrio = isPriorityPlayer(entry.player)

        local dLbl = Instance.new("TextLabel", card)
        dLbl.Size = UDim2.new(1, -170, 0, 14)
        dLbl.Position = UDim2.new(0, 34, 0, 4)
        dLbl.BackgroundTransparency = 1
        dLbl.Text = (isPrio and "⭐ " or "") .. entry.player.DisplayName
        dLbl.TextColor3 = isPrio and Color3.fromRGB(90, 160, 255) or WHITE
        dLbl.Font = Enum.Font.GothamBold
        dLbl.TextSize = 11
        dLbl.TextXAlignment = Enum.TextXAlignment.Left
        dLbl.TextTruncate = Enum.TextTruncate.AtEnd

        local uLbl = Instance.new("TextLabel", card)
        uLbl.Size = UDim2.new(1, -170, 0, 12)
        uLbl.Position = UDim2.new(0, 34, 0, 20)
        uLbl.BackgroundTransparency = 1
        uLbl.Text = "@" .. entry.player.Name
        uLbl.TextColor3 = GRAY
        uLbl.Font = Enum.Font.Gotham
        uLbl.TextSize = 9
        uLbl.TextXAlignment = Enum.TextXAlignment.Left
        uLbl.TextTruncate = Enum.TextTruncate.AtEnd

        local smallVP = Instance.new("ViewportFrame", card)
        smallVP.Size = UDim2.new(0, 34, 0, 34)
        smallVP.Position = UDim2.new(1, -84, 0, 4)
        smallVP.BackgroundTransparency = 1
        smallVP.Visible = false

        local sCam = Instance.new("Camera", smallVP)
        smallVP.CurrentCamera = sCam
        sCam.FieldOfView = 50

        local tierName = entry.tier or nil
        local tierInfo = tierName and TraitsData and TraitsData[tierName]

        local aniLbl = Instance.new("TextLabel", card)
        aniLbl.Size = UDim2.new(1, -120, 0, 12)
        aniLbl.Position = UDim2.new(0, 34, 0, 36)
        aniLbl.BackgroundTransparency = 1
        aniLbl.Text = entry.name
        aniLbl.TextColor3 = GRAY
        aniLbl.Font = Enum.Font.Gotham
        aniLbl.TextSize = 8
        aniLbl.TextXAlignment = Enum.TextXAlignment.Left
        aniLbl.TextTruncate = Enum.TextTruncate.AtEnd

        local mutRow = Instance.new("Frame", card)
        mutRow.Size = UDim2.new(1, -120, 0, 14)
        mutRow.Position = UDim2.new(0, 36, 0, 48)
        mutRow.BackgroundTransparency = 1
        mutRow.Visible = true

        local mutCardLbl = Instance.new("TextLabel", mutRow)
        mutCardLbl.Size = UDim2.new(1, 0, 1, 0)
        mutCardLbl.BackgroundTransparency = 1
        mutCardLbl.TextXAlignment = Enum.TextXAlignment.Left
        mutCardLbl.Text = "Mutation: " .. (entry.mutation or "None")
        mutCardLbl.TextColor3 = entry.mutation and (MUT_COLORS[entry.mutation] or ACCENT) or (MUT_COLORS.None or GRAY)
        mutCardLbl.Font = Enum.Font.Gotham
        mutCardLbl.TextSize = 8

        local tierRow = Instance.new("Frame", card)
        tierRow.Size = UDim2.new(1, -120, 0, 14)
        tierRow.Position = UDim2.new(0, 36, 0, 62)
        tierRow.BackgroundTransparency = 1

        local ic = tierInfo and (type(tierInfo.Icon) == "string" and tierInfo.Icon ~= "") and tierInfo.Icon or nil
        if ic then
            local tierIcon = Instance.new("ImageLabel", tierRow)
            tierIcon.Size = UDim2.new(0, 12, 0, 12)
            tierIcon.Position = UDim2.new(0, 0, 0, 1)
            tierIcon.BackgroundTransparency = 1
            tierIcon.BorderSizePixel = 0
            tierIcon.Image = ic
        end

        local offset = ic and 14 or 0
        local tierLbl = Instance.new("TextLabel", tierRow)
        tierLbl.Size = UDim2.new(1, -16, 1, 0)
        tierLbl.Position = UDim2.new(0, offset, 0, 0)
        tierLbl.BackgroundTransparency = 1
        tierLbl.TextXAlignment = Enum.TextXAlignment.Left
        tierLbl.Text = tierName and ("Tiers: " .. tierName) or ""
        local tc = tierName and MUT_COLORS[tierName]
        tierLbl.TextColor3 = tc or Color3.fromRGB(180, 180, 180)
        tierLbl.Font = Enum.Font.Gotham
        tierLbl.TextSize = 8

        local brainrotTag = Instance.new("TextLabel", card)
        brainrotTag.Size = UDim2.new(0, 34, 0, 10)
        brainrotTag.Position = UDim2.new(1, -84, 0, 38)
        brainrotTag.BackgroundTransparency = 1
        brainrotTag.Text = "BRAINROT"
        brainrotTag.TextColor3 = ACCENT
        brainrotTag.Font = Enum.Font.GothamBlack
        brainrotTag.TextSize = 6
        brainrotTag.TextXAlignment = Enum.TextXAlignment.Center

        local cellName = entry.name
        local cellMut = entry.mutation

        task.spawn(function()
            task.wait(math.min(i * 0.005, 0.3))
            if not card.Parent then return end
            local ok = pcall(function()
                if AnimalsAPI then
                    AnimalsAPI:AttachOnViewportWithOptimizations(cellName, smallVP, "None", nil)
                end
            end)
            if ok then
                for _ = 1, 10 do
                    local m = nil
                    for _, desc in ipairs(smallVP:GetDescendants()) do
                        if desc:IsA("BasePart") then
                            local p = desc
                            while p and p ~= smallVP do
                                if p:IsA("Model") and not p.Name:find("^_Trait%.") then
                                    m = p
                                    break
                                end
                                p = p.Parent
                            end
                        end
                        if m then break end
                    end
                    if m then
                        if cellMut and cellMut ~= "None" and AnimalsAPI then
                            ApplyMutation(m, cellName, cellMut)
                        end
                        local okExt, ext = pcall(function() return m:GetExtentsSize() end)
                        if okExt and ext then
                            local maxDim = math.max(ext.X, ext.Y, ext.Z)
                            local dist = (maxDim * 0.5 / math.tan(math.rad(25))) * 0.75
                            local lookAt = (m.PrimaryPart and m.PrimaryPart.CFrame) or CFrame.new(0, 0, 0)
                            sCam.CFrame = CFrame.new(
                                (lookAt * CFrame.new(Vector3.new(-1, 0.25, -1).Unit * (dist + maxDim * 0.5))).Position,
                                lookAt.Position
                            )
                        end
                        smallVP.Visible = true
                        break
                    end
                    task.wait()
                end
                smallVP.Visible = true
            end
        end)

        local entryRef = entry
        local duelPlayerRef = entryRef.player

        local duelRefVal = Instance.new("ObjectValue", card)
        duelRefVal.Name = "DuelPlayerRef"
        duelRefVal.Value = duelPlayerRef

        card.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                selectEntry(entryRef)
                for _, other in ipairs(animalScroll:GetChildren()) do
                    if other:IsA("Frame") then
                        other.BackgroundColor3 = DARK
                        local s = other:FindFirstChildOfClass("UIStroke")
                        if s then s.Transparency = 0.75 end
                    end
                end
                card.BackgroundColor3 = SURFACE
                local s = card:FindFirstChildOfClass("UIStroke")
                if s then s.Transparency = 0.35 end
            end
        end)

        local tradeCardBtn = Instance.new("TextButton", card)
        tradeCardBtn.Size = UDim2.new(0, 36, 0, 20)
        tradeCardBtn.Position = UDim2.new(1, -40, 0, 20)
        tradeCardBtn.BackgroundColor3 = BLUE
        tradeCardBtn.BorderSizePixel = 0
        tradeCardBtn.Text = "TRADE"
        tradeCardBtn.TextColor3 = WHITE
        tradeCardBtn.Font = Enum.Font.GothamBold
        tradeCardBtn.TextSize = 7

        do
            local c = Instance.new("UICorner", tradeCardBtn)
            c.CornerRadius = UDim.new(0, 4)
        end

        tradeCardBtn.MouseButton1Click:Connect(function()
            if not duelPlayerRef or not duelPlayerRef.Parent then return end
            tradeCardBtn.Text = "✓"
            task.delay(1.5, function()
                if tradeCardBtn and tradeCardBtn.Parent then
                    tradeCardBtn.Text = "TRADE"
                end
            end)
            sendTradeToPlayer(duelPlayerRef.Name)
        end)

        local duelCardBtn = Instance.new("TextButton", card)
        duelCardBtn.Size = UDim2.new(0, 36, 0, 20)
        duelCardBtn.Position = UDim2.new(1, -40, 0, 44)
        duelCardBtn.BackgroundColor3 = Color3.fromRGB(145, 30, 30)
        duelCardBtn.BorderSizePixel = 0
        duelCardBtn.Text = "DUEL"
        duelCardBtn.TextColor3 = WHITE
        duelCardBtn.Font = Enum.Font.GothamBold
        duelCardBtn.TextSize = 7

        do
            local c = Instance.new("UICorner", duelCardBtn)
            c.CornerRadius = UDim.new(0, 4)
        end

        duelCardBtn.MouseButton1Click:Connect(function()
            if not duelPlayerRef or not duelPlayerRef.Parent then return end
            if isDuelOnCooldown(duelPlayerRef.UserId) then return end
            startDuelCooldown(duelPlayerRef.UserId)
            duelCardBtn.Text = "✓"
            task.delay(1.5, function()
                if duelCardBtn and duelCardBtn.Parent then
                    duelCardBtn.Text = "DUEL"
                end
            end)
            sendDuelToPlayer(duelPlayerRef.Name)
        end)

        if isDuelOnCooldown(duelPlayerRef.UserId) then
            reapplyCooldownOverlay(duelPlayerRef.UserId)
        end
    end

    animalScroll.CanvasSize = UDim2.new(0, 0, 0, animalLayout.AbsoluteContentSize.Y + 4)

    if selectedEntry then
        local found = false
        for _, e in ipairs(scannedAnimals) do
            if e.player == selectedEntry.player and e.name == selectedEntry.name then
                found = true
                break
            end
        end
        if not found then
            selectEntry(#scannedAnimals > 0 and scannedAnimals[1] or nil)
        end
    elseif #scannedAnimals > 0 then
        selectEntry(scannedAnimals[1])
    end
end

selectAllBtn.MouseButton1Click:Connect(function()
    selectAllOn = not selectAllOn
    if selectAllOn then
        for _, bName in ipairs(ALL_BRAINROTS) do
            blacklist[bName] = true
        end
        selectAllBtn.Text = "NONE"
        selectAllBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
        selectAllBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    else
        for _, bName in ipairs(ALL_BRAINROTS) do
            blacklist[bName] = nil
        end
        selectAllBtn.Text = "ALL"
        selectAllBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        selectAllBtn.TextColor3 = ACCENT
    end
    saveConfig()
    applyBlacklistToWorld()
    rebuildBrainrotGrid(brainrotSearch.Text)
    task.spawn(function()
        scanAllPlots()
        rebuildAnimalList()
    end)
end)

-- === EVENTS ===
tradeBtn.MouseButton1Click:Connect(function()
    if not selectedEntry then return end
    sendTradeToPlayer(selectedEntry.player.Name)
    tradeBtn.Text = "✓ ENVOYÉ"
    task.delay(1.5, function()
        if tradeBtn and tradeBtn.Parent then
            tradeBtn.Text = "ÉCHANGE"
        end
    end)
end)

duelBtn.MouseButton1Click:Connect(function()
    if not selectedEntry then return end
    if isDuelOnCooldown(selectedEntry.player.UserId) then return end
    startDuelCooldown(selectedEntry.player.UserId)
    sendDuelToPlayer(selectedEntry.player.Name)
end)

local searchThrottle = nil
brainrotSearch:GetPropertyChangedSignal("Text"):Connect(function()
    if searchThrottle then
        pcall(function() task.cancel(searchThrottle) end)
    end
    searchThrottle = task.delay(0.08, function()
        rebuildBrainrotGrid(brainrotSearch.Text)
    end)
end)

-- === INIT ===
task.spawn(function()
    scanAllPlots()
    checkPriorityPlayers()
    rebuildAnimalList()
    rebuildBrainrotGrid()
end)

task.delay(0.8, function()
    if userPriorityOn then
        showSystemNotif("Priorité USER activée automatiquement")
    end
    if autoAcceptDuelOn then
        showSystemNotif("Auto Accept Duel activé (sauvegardé)")
    end
end)

Players.PlayerAdded:Connect(function(player)
    local startTime = tick()
    local plot = nil
    while tick() - startTime < 15 do
        local plots = workspace:FindFirstChild("Plots")
        if plots then
            for _, p in plots:GetChildren() do
                local owner = getPlotOwner(p)
                if owner and owner == player.DisplayName then
                    plot = p
                    break
                end
            end
        end
        if plot then break end
        task.wait(0.5)
    end
    if not plot then return end
    task.wait(1)
    scanSinglePlot(plot)
    checkPriorityPlayers()
    rebuildAnimalList()
end)

Players.PlayerRemoving:Connect(function(player)
    removePlayerAnimals(player)
    notifiedPriority[player.UserId] = nil
    rebuildAnimalList()
end)

-- === AUTO ACCEPT DUEL (UNIQUEMENT LES DUELS, PAS LES TRADES) ===
local function isReallyVisible(obj)
    local o = obj
    while o and o ~= game do
        if o:IsA("GuiObject") and not o.Visible then return false end
        if o:IsA("ScreenGui") and not o.Enabled then return false end
        o = o.Parent
    end
    return true
end

-- Lit tous les textes de l'invitation (sauf le pseudo du joueur)
local function collectInviteText(root)
    local out = {}
    for _, d in pairs(root:GetDescendants()) do
        if d:IsA("TextLabel") and d.Text ~= "" and d.Name ~= "Username" then
            table.insert(out, d.Text:lower())
        end
    end
    return table.concat(out, " ")
end

-- Trouve le bouton Yes VISIBLE et vérifie que c'est bien un DUEL (pas un trade)
local function findVisibleDuelYesButton()
    local gui = LP.PlayerGui:FindFirstChild("DuelsMachinePrompt")
    if not gui then return nil end
    for _, desc in pairs(gui:GetDescendants()) do
        if (desc:IsA("TextButton") or desc:IsA("ImageButton")) and desc.Name == "Yes" then
            if isReallyVisible(desc) then
                -- Remonter jusqu'au template de l'invitation
                local root = desc
                while root and root.Parent and root.Parent ~= gui do
                    root = root.Parent
                    if root.Name == "InviteTemplate" then break end
                end
                local txt = collectInviteText(root or desc)
                -- ❌ Si le texte parle de TRADE → on ignore complètement
                if not txt:find("trade", 1, true) then
                    return desc
                end
            end
        end
    end
    return nil
end

local cachedAcceptRemote = nil
local function getDuelAcceptRemote()
    if cachedAcceptRemote then return cachedAcceptRemote end
    pcall(function()
        local packages = ReplicatedStorage:FindFirstChild("Packages")
        local net = packages and packages:FindFirstChild("Net")
        if not net then return end
        local r = net:FindFirstChild("RE/DuelsMachineService/Selection/Accept")
        if r then cachedAcceptRemote = r return end
        local re = net:FindFirstChild("RE")
        if re then
            local svc = re:FindFirstChild("DuelsMachineService")
            if svc then
                local sel = svc:FindFirstChild("Selection")
                local acc = (sel and sel:FindFirstChild("Accept")) or svc:FindFirstChild("Selection/Accept")
                if acc then cachedAcceptRemote = acc return end
            end
            local acc2 = re:FindFirstChild("DuelsMachineService/Selection/Accept")
            if acc2 then cachedAcceptRemote = acc2 return end
        end
        for _, desc in pairs(net:GetDescendants()) do
            if (desc:IsA("RemoteEvent") or desc:IsA("RemoteFunction"))
                and desc.Name:lower():find("accept", 1, true)
                and desc:GetFullName():lower():find("duelsmachine", 1, true) then
                cachedAcceptRemote = desc
                return
            end
        end
    end)
    return cachedAcceptRemote
end

local function tryAcceptOnce(yesBtn)
    -- Méthode 1 : connections du bouton Yes
    for _, event in ipairs({yesBtn.MouseButton1Click, yesBtn.MouseButton1Down, yesBtn.Activated}) do
        local ok, conns = pcall(function() return getconnections(event) end)
        if ok and conns and #conns > 0 then
            for _, conn in ipairs(conns) do
                pcall(function() conn.Function() end)
            end
        end
    end

    -- Méthode 2 : vrai clic souris sur le bouton
    pcall(function()
        local pos = yesBtn.AbsolutePosition + yesBtn.AbsoluteSize / 2
        if mousemoveto then
            mousemoveto(pos.X, pos.Y)
            task.wait(0.05)
        end
        if mouse1click then mouse1click() end
    end)

    -- Méthode 3 : remote Accept (duels uniquement)
    local rem = getDuelAcceptRemote()
    if rem and rem:IsA("RemoteEvent") then
        local usernameLbl = yesBtn.Parent and yesBtn.Parent:FindFirstChild("Username")
        local invName = usernameLbl and usernameLbl.Text or nil
        local invPlayer = invName and Players:FindFirstChild(invName) or nil
        pcall(function() rem:FireServer() end)
        if invPlayer then
            pcall(function() rem:FireServer(invPlayer) end)
            pcall(function() rem:FireServer(invPlayer.UserId) end)
            pcall(function() rem:FireServer(invName) end)
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.25)
        if not autoAcceptDuelOn then continue end
        local yesBtn = findVisibleDuelYesButton()
        if yesBtn then
            tryAcceptOnce(yesBtn)
        end
    end
end)

-- === AUTO DUEL LOOP (priorité USER d'abord) ===
task.spawn(function()
    local duelled = {}
    while true do
        if not autoDuelOn then
            task.wait(0.5)
            continue
        end
        if #scannedAnimals == 0 then
            task.wait(1)
            continue
        end
        local sent = false
        local queue = {}
        for _, e in ipairs(scannedAnimals) do
            table.insert(queue, e)
        end
        table.sort(queue, function(a, b)
            local pa = isPriorityPlayer(a.player) and 1 or 0
            local pb = isPriorityPlayer(b.player) and 1 or 0
            if pa ~= pb then return pa > pb end
            return a.ownerName < b.ownerName
        end)
        for _, entry in ipairs(queue) do
            if not autoDuelOn then break end
            if duelled[entry.player.UserId] then continue end
            if isDuelOnCooldown(entry.player.UserId) then
                duelled[entry.player.UserId] = true
                continue
            end
            selectEntry(entry)
            startDuelCooldown(entry.player.UserId)
            sendDuelToPlayer(entry.player.Name)
            duelled[entry.player.UserId] = true
            sent = true
            local waitTime = 0
            while waitTime < 5 and autoDuelOn do
                task.wait(0.25)
                waitTime = waitTime + 0.25
            end
        end
        if not sent or not autoDuelOn then
            task.wait(0.5)
        end
        if next(duelled) then
            local allDone = true
            for _, entry in ipairs(scannedAnimals) do
                if not duelled[entry.player.UserId] then
                    allDone = false
                    break
                end
            end
            if allDone then
                duelled = {}
            end
        end
    end
end)

-- === Mobile-friendly graphics optimization ===
do
    local Workspace = game:GetService("Workspace")
    local Lighting = game:GetService("Lighting")

    local function isLocalCharacter(obj)
        local character = LP and LP.Character
        return character ~= nil and obj:IsDescendantOf(character)
    end

    local function isAnimalModel(obj)
        local current = obj
        while current and current ~= Workspace do
            if current:IsA("Model") then
                if (current.Parent and current.Parent.Name == "Plots")
                    or current:GetAttribute("PlotName") then
                    return true
                end
            end
            current = current.Parent
        end
        return false
    end

    local function processDescendant(obj)
        if not obj or not obj.Parent or isLocalCharacter(obj) then return end

        if obj:IsA("ParticleEmitter") or obj:IsA("Trail")
            or obj:IsA("Beam") or obj:IsA("Fire") then
            obj.Enabled = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("BasePart") then
            if not isAnimalModel(obj) then
                obj.Material = Enum.Material.Plastic
            end
            obj.Reflectance = 0
            obj.CastShadow = false
        end
        -- Keep accessories intact; deleting them can cause visual glitches.
    end

    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100000
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0

    for _, effect in ipairs(Lighting:GetChildren()) do
        if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect")
            or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect")
            or effect:IsA("DepthOfFieldEffect") then
            effect.Enabled = false
        end
    end

    -- Queue new objects and process them in batches instead of doing heavy work
    -- immediately for every DescendantAdded event. This helps reduce mobile stutter.
    local queue = Workspace:GetDescendants()
    local nextIndex = 1
    Workspace.DescendantAdded:Connect(function(obj)
        queue[#queue + 1] = obj
    end)

    task.spawn(function()
        while true do
            if nextIndex <= #queue then
                local batchEnd = math.min(nextIndex + 119, #queue)
                while nextIndex <= batchEnd do
                    local obj = queue[nextIndex]
                    nextIndex = nextIndex + 1
                    pcall(processDescendant, obj)
                end
                -- Release processed references periodically to keep memory use low.
                if nextIndex > 500 and nextIndex > (#queue / 2) then
                    local remaining = {}
                    for i = nextIndex, #queue do
                        remaining[#remaining + 1] = queue[i]
                    end
                    queue = remaining
                    nextIndex = 1
                end
                task.wait()
            else
                task.wait(0.25)
            end
        end
    end)
end
