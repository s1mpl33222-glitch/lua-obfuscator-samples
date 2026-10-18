-- ======================================
-- HIGH AUTO REDEEMER v2 (Unified)
-- ======================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove GUIs antigas
pcall(function()
    local oldGui = playerGui:FindFirstChild("HighAutoRedeemer")
    if oldGui then oldGui:Destroy() end
    local oldLogs = playerGui:FindFirstChild("HighLogs")
    if oldLogs then oldLogs:Destroy() end
end)

local env = (typeof(getgenv) == "function" and getgenv()) or _G
if env.Skyr0Stop then pcall(env.Skyr0Stop) end

local getupvalues = (debug and debug.getupvalues) or getupvalues
local getconns = getconnections or (debug and debug.getconnections)
local setupv = (debug and debug.setupvalue) or setupvalue

-- ============================================================
-- CORES (High Style)
-- ============================================================
local C = {
    Bg        = Color3.fromRGB(20, 15, 20),
    BgRow     = Color3.fromRGB(25, 20, 28),
    Accent    = Color3.fromRGB(235, 120, 180),
    AccentHi  = Color3.fromRGB(255, 150, 210),
    AccentOn  = Color3.fromRGB(255, 180, 220),
    Text      = Color3.fromRGB(235, 235, 240),
    Muted     = Color3.fromRGB(160, 140, 145),
    White     = Color3.fromRGB(255, 255, 255),
    Black     = Color3.fromRGB(0,   0,   0),
    Red       = Color3.fromRGB(200, 50,  50),
    Green     = Color3.fromRGB(34, 197, 94),
    InputBg   = Color3.fromRGB(25, 20, 28),
    Card      = Color3.fromRGB(25, 20, 28),
    Stroke    = Color3.fromRGB(235, 120, 180),
    TrackOff  = Color3.fromRGB(30, 15, 25),
    KnobOn    = Color3.fromRGB(255, 150, 210),
    KnobOff   = Color3.fromRGB(80, 50, 70),
    FloatBg   = Color3.fromRGB(20, 15, 20),
    FloatHover = Color3.fromRGB(235, 120, 180),
    Panel     = Color3.fromRGB(28, 28, 32),
}

-- ============================================================
-- CONFIGURAÇÃO
-- ============================================================
local CONFIG_FILE = "high_auto_redeemer_v2.json"
local cfg = {
    codeSniper   = false,
    autoSubmit   = true,
    submitAfter  = 3,
    retypeInvalid = false,
    riddleSolver = false,
}

pcall(function()
    if isfile and isfile(CONFIG_FILE) then
        local decoded = HttpService:JSONDecode(readfile(CONFIG_FILE))
        if type(decoded) == "table" then
            for k, v in pairs(cfg) do
                if decoded[k] ~= nil then cfg[k] = decoded[k] end
            end
            cfg.submitAfter = math.max(1, math.floor(tonumber(cfg.submitAfter) or 3))
        end
    end
end)

local function saveConfig()
    if writefile then
        pcall(function()
            writefile(CONFIG_FILE, HttpService:JSONEncode(cfg))
        end)
    end
end

-- ============================================================
-- SAB KNOWLEDGE BASE (Riddle Solver)
-- ============================================================
local SAB_DB = {
    ["real name"] = "SAMMY",
    ["sammy real name"] = "SAMMY",
    ["sammys real name"] = "SAMMY",
    ["my real name"] = "SAMMY",
    ["creator real name"] = "SAMMY",
    ["owner real name"] = "SAMMY",
    ["creator name"] = "SAMMY",
    ["who created sab"] = "SAMMY",
    ["who made sab"] = "SAMMY",
    ["who is the owner"] = "SAMMY",
    ["who owns sab"] = "SAMMY",
    ["owner"] = "SAMMY",
    ["creator"] = "SAMMY",
    ["name"] = "SAMMY",
    ["my name"] = "SAMMY",
    ["game owner"] = "SAMMY",
    ["developer"] = "SAMMY",
    ["dev"] = "SAMMY",
    ["made by"] = "SAMMY",
    ["roblox username"] = "SPYDERSAMMY",
    ["my roblox username"] = "SPYDERSAMMY",
    ["username"] = "SPYDERSAMMY",
    ["roblox name"] = "SPYDERSAMMY",
    ["roblox"] = "SPYDERSAMMY",
    ["channel"] = "SPYDERSAMMY",
    ["handle"] = "SPYDERSAMMY",
    ["how old am i"] = "24",
    ["how old is sammy"] = "24",
    ["my age"] = "24",
    ["sammy age"] = "24",
    ["age"] = "24",
    ["birth year"] = "2002",
    ["year born"] = "2002",
    ["born year"] = "2002",
    ["birth day"] = "FRIDAY",
    ["day i was born"] = "FRIDAY",
    ["birthday"] = "FRIDAY",
    ["birth month"] = "FEBRUARY",
    ["month born"] = "FEBRUARY",
    ["birthplace"] = "ALGERIA",
    ["where was i born"] = "ALGERIA",
    ["where am i from"] = "BRAZIL",
    ["where is sammy from"] = "BRAZIL",
    ["my country"] = "BRAZIL",
    ["sammy country"] = "BRAZIL",
    ["country"] = "BRAZIL",
    ["where do i live"] = "BRAZIL",
    ["nationality"] = "BRAZILIAN",
    ["my nationality"] = "BRAZILIAN",
    ["state"] = "SAOPAULO",
    ["city"] = "SAOPAULO",
    ["favorite color"] = "BLUE",
    ["my color"] = "BLUE",
    ["sammy color"] = "BLUE",
    ["color"] = "BLUE",
    ["favorite sport"] = "FOOTBALL",
    ["sport"] = "FOOTBALL",
    ["favorite food"] = "PIZZA",
    ["my food"] = "PIZZA",
    ["food"] = "PIZZA",
    ["favorite animal"] = "SPIDER",
    ["my pet"] = "SPIDER",
    ["pet"] = "SPIDER",
    ["animal"] = "SPIDER",
    ["favorite game"] = "ROBLOX",
    ["game"] = "ROBLOX",
    ["lucky number"] = "SEVEN",
    ["number"] = "SEVEN",
    ["youtube"] = "SPYDERSAMMY",
    ["discord"] = "ACE",
    ["twitter"] = "SPYDERSAMMY",
    ["tiktok"] = "SPYDERSAMMY",
    ["instagram"] = "SPYDERSAMMY",
    ["game created on"] = "FRIDAY",
    ["created on"] = "FRIDAY",
    ["release month"] = "MAY",
    ["release year"] = "2025",
    ["year sab was created"] = "2025",
    ["year the game was created"] = "2025",
    ["when was sab made"] = "MAY162025",
    ["release date"] = "MAY162025",
    ["game release date"] = "MAY162025",
    ["my name twice"] = "SAMMYSAMMY",
    ["my name 3 times"] = "SAMMYSAMMYSAMMY",
    ["name twice"] = "SAMMYSAMMY",
    ["my age twice"] = "2424",
    ["my age 3 times"] = "242424",
    ["favorite color twice"] = "BLUEBLUE",
    ["favorite color 3 times"] = "BLUEBLUEBLUE",
    ["favorite color 5 times"] = "BLUEBLUEBLUEBLUEBLUE",
    ["first trait"] = "LIGHTNING",
    ["1st trait"] = "LIGHTNING",
    ["trait"] = "LIGHTNING",
    ["struck by lightning"] = "MATEO",
    ["lightning trait"] = "MATEO",
    ["lightning"] = "MATEO",
    ["first mutation"] = "GOLD",
    ["1st mutation"] = "GOLD",
    ["second mutation"] = "DIAMOND",
    ["2nd mutation"] = "DIAMOND",
    ["third mutation"] = "BLOODROT",
    ["3rd mutation"] = "BLOODROT",
    ["fourth mutation"] = "RAINBOW",
    ["4th mutation"] = "RAINBOW",
    ["fifth mutation"] = "CANDY",
    ["5th mutation"] = "CANDY",
    ["sixth mutation"] = "LAVA",
    ["6th mutation"] = "LAVA",
    ["seventh mutation"] = "GALAXY",
    ["7th mutation"] = "GALAXY",
    ["eighth mutation"] = "YINYANG",
    ["8th mutation"] = "YINYANG",
    ["ninth mutation"] = "RADIOACTIVE",
    ["9th mutation"] = "RADIOACTIVE",
    ["tenth mutation"] = "CURSED",
    ["10th mutation"] = "CURSED",
    ["eleventh mutation"] = "DIVINE",
    ["11th mutation"] = "DIVINE",
    ["twelfth mutation"] = "CYBER",
    ["12th mutation"] = "CYBER",
    ["thirteenth mutation"] = "PHANTOM",
    ["13th mutation"] = "PHANTOM",
    ["fourteenth mutation"] = "CRYSTAL",
    ["14th mutation"] = "CRYSTAL",
    ["mutation 1"] = "GOLD",
    ["mutation 2"] = "DIAMOND",
    ["mutation 3"] = "BLOODROT",
    ["mutation 4"] = "RAINBOW",
    ["mutation 5"] = "CANDY",
    ["mutation 6"] = "LAVA",
    ["mutation 7"] = "GALAXY",
    ["mutation 8"] = "YINYANG",
    ["mutation 9"] = "RADIOACTIVE",
    ["mutation 10"] = "CURSED",
    ["mutation 11"] = "DIVINE",
    ["mutation 12"] = "CYBER",
    ["mutation 13"] = "PHANTOM",
    ["mutation 14"] = "CRYSTAL",
    ["evil mutation"] = "CURSED",
    ["cursed"] = "CURSED",
    ["angelic mutation"] = "DIVINE",
    ["divine"] = "DIVINE",
    ["good mutation"] = "DIVINE",
    ["latest mutation"] = "CRYSTAL",
    ["most recent mutation"] = "CRYSTAL",
    ["newest mutation"] = "CRYSTAL",
    ["divinecursed"] = "DIVINECURSED",
    ["green mutation"] = "RADIOACTIVE",
    ["purple mutation"] = "GALAXY",
    ["black and white mutation"] = "YINYANG",
    ["yellow mutation"] = "DIVINE",
    ["red mutation"] = "CURSED",
    ["orange mutation"] = "LAVA",
    ["blue mutation"] = "DIAMOND",
    ["pink mutation"] = "CANDY",
    ["color of gold mutation"] = "YELLOW",
    ["color of diamond mutation"] = "BLUE",
    ["color of bloodrot mutation"] = "RED",
    ["color of rainbow mutation"] = "RAINBOW",
    ["color of candy mutation"] = "PINK",
    ["color of lava mutation"] = "ORANGE",
    ["color of galaxy mutation"] = "PURPLE",
    ["color of yinyang mutation"] = "BLACK",
    ["color of radioactive mutation"] = "GREEN",
    ["color of cursed mutation"] = "RED",
    ["color of divine mutation"] = "YELLOW",
    ["what number is gold"] = "1",
    ["what number is diamond"] = "2",
    ["what number is bloodrot"] = "3",
    ["what number is rainbow"] = "4",
    ["what number is candy"] = "5",
    ["what number is lava"] = "6",
    ["what number is galaxy"] = "7",
    ["what number is yinyang"] = "8",
    ["what number is radioactive"] = "9",
    ["what number is cursed"] = "10",
    ["what number is divine"] = "11",
    ["what number is cyber"] = "12",
    ["what number is phantom"] = "13",
    ["what number is crystal"] = "14",
    ["first machine"] = "RAINBOWMACHINE",
    ["1st machine"] = "RAINBOWMACHINE",
    ["second machine"] = "BUBBLEGUMMACHINE",
    ["2nd machine"] = "BUBBLEGUMMACHINE",
    ["third machine"] = "FUSEMACHINE",
    ["3rd machine"] = "FUSEMACHINE",
    ["fourth machine"] = "CRAFTMACHINE",
    ["4th machine"] = "CRAFTMACHINE",
    ["fifth machine"] = "WITCHFUSE",
    ["5th machine"] = "WITCHFUSE",
    ["sixth machine"] = "BRAINROTDEALER",
    ["6th machine"] = "BRAINROTDEALER",
    ["seventh machine"] = "BRAINROTTRADER",
    ["7th machine"] = "BRAINROTTRADER",
    ["eighth machine"] = "SANTASFUSE",
    ["8th machine"] = "SANTASFUSE",
    ["ninth machine"] = "SANTASSHOP",
    ["9th machine"] = "SANTASSHOP",
    ["tenth machine"] = "NEWYEARSMACHINE",
    ["10th machine"] = "NEWYEARSMACHINE",
    ["eleventh machine"] = "DUELSMACHINE",
    ["11th machine"] = "DUELSMACHINE",
    ["twelfth machine"] = "CUPIDSMACHINE",
    ["12th machine"] = "CUPIDSMACHINE",
    ["thirteenth machine"] = "TRADEMACHINE",
    ["13th machine"] = "TRADEMACHINE",
    ["fourteenth machine"] = "DIVINEFUSE",
    ["14th machine"] = "DIVINEFUSE",
    ["fifteenth machine"] = "EGGINCUBATOR",
    ["15th machine"] = "EGGINCUBATOR",
    ["sixteenth machine"] = "CYBERCRAFTMACHINE",
    ["16th machine"] = "CYBERCRAFTMACHINE",
    ["seventeenth machine"] = "SUMMERFUSE",
    ["17th machine"] = "SUMMERFUSE",
    ["eighteenth machine"] = "LOSTRADERS",
    ["18th machine"] = "LOSTRADERS",
    ["machine 1"] = "RAINBOWMACHINE",
    ["machine 2"] = "BUBBLEGUMMACHINE",
    ["machine 3"] = "FUSEMACHINE",
    ["machine 4"] = "CRAFTMACHINE",
    ["machine 5"] = "WITCHFUSE",
    ["machine 6"] = "BRAINROTDEALER",
    ["machine 7"] = "BRAINROTTRADER",
    ["machine 8"] = "SANTASFUSE",
    ["machine 9"] = "SANTASSHOP",
    ["machine 10"] = "NEWYEARSMACHINE",
    ["machine 11"] = "DUELSMACHINE",
    ["machine 12"] = "CUPIDSMACHINE",
    ["machine 13"] = "TRADEMACHINE",
    ["machine 14"] = "DIVINEFUSE",
    ["machine 15"] = "EGGINCUBATOR",
    ["machine 16"] = "CYBERCRAFTMACHINE",
    ["machine 17"] = "SUMMERFUSE",
    ["machine 18"] = "LOSTRADERS",
    ["latest machine"] = "LOSTRADERS",
    ["newest machine"] = "LOSTRADERS",
    ["rarest brainrot"] = "HEADLESSHORSEMAN",
    ["unobtainable brainrot"] = "HEADLESSHORSEMAN",
    ["best brainrot"] = "STRAWBERRYELEPHANT",
    ["og 1"] = "STRAWBERRYELEPHANT",
    ["og 2"] = "MEOWL",
    ["og 3"] = "SKIBIDITOILET",
    ["og 5"] = "JOHNPORK",
    ["first brainrot added"] = "STRAWBERRYELEPHANT",
    ["oldest brainrot"] = "STRAWBERRYELEPHANT",
    ["worst brainrot"] = "NOOBINIPIZZANINI",
    ["most common brainrot"] = "NOOBINIPIZZANINI",
    ["weakest brainrot"] = "NOOBINIPIZZANINI",
    ["most popular brainrot"] = "DRAGONCANNELONNI",
    ["rarest rarity"] = "OG",
    ["best rarity"] = "OG",
    ["lowest rarity"] = "COMMON",
    ["worst rarity"] = "COMMON",
    ["common"] = "COMMON",
    ["uncommon"] = "UNCOMMON",
    ["rare"] = "RARE",
    ["epic"] = "EPIC",
    ["legendary"] = "LEGENDARY",
    ["og"] = "OG",
    ["fire represents"] = "DRAGON",
    ["fire"] = "DRAGON",
    ["dragon"] = "DRAGON",
    ["won the world cup"] = "SPAIN",
    ["world cup winner"] = "SPAIN",
    ["worst game owner"] = "SECRETLOKII",
    ["most boring game owner"] = "SECRETLOKII",
    ["most boring game on roblox"] = "KEYBOARDESCAPE",
    ["admin war brainrot"] = "RACOONINIJANDELINI",
    ["who did sammy fight"] = "JANDEL",
    ["won the admin abuse war"] = "GROWAGARDEN",
    ["worst secret"] = "KARKERKARKURKUR",
    ["maximum server size"] = "EIGHT",
    ["max players"] = "EIGHT",
    ["server capacity"] = "EIGHT",
    ["brother of hydra bunny"] = "CERBERUS",
    ["cerberus"] = "CERBERUS",
    ["game name"] = "STEALABRAINROT",
    ["sab"] = "STEALABRAINROT",
    ["sab stands for"] = "STEALABRAINROT",
    ["full game name"] = "STEALABRAINROT",
    ["how many mutations"] = "14",
    ["how many machines"] = "18",
    ["total machines"] = "18",
    ["total rarities"] = "SIX",
    ["how many rarities"] = "SIX",
    ["game genre"] = "SIMULATOR",
    ["first update"] = "MUTATIONS",
    ["favorite color favorite sport"] = "BLUEFOOTBALL",
    ["favorite color favorite animal"] = "BLUESPIDER",
    ["favorite color favorite food"] = "BLUEPIZZA",
    ["favorite color owner"] = "BLUESAMMY",
    ["name favorite food"] = "SAMMYPIZZA",
    ["name favorite color"] = "SAMMYBLUE",
}

local WORD_ALIAS = {
    favourite = "favorite", fav = "favorite", favorites = "favorite",
    colour = "color", colours = "color", colors = "color",
    whats = "what is", ["what's"] = "what is",
    whos = "who is", ["who's"] = "who is",
    wheres = "where is", whens = "when is",
    u = "you", ur = "your", pls = "", please = "",
    ["sammy's"] = "sammys", ["i'm"] = "i am",
}

local FILLERS = {
    "what is", "what are", "what was", "what were", "what do", "what does",
    "who is", "who was", "who are", "when is", "when was", "where is",
    "where are", "how old", "how many", "how much", "do you know",
    "can you tell me", "tell me", "i need", "give me", "answer me",
    "say", "type", "write", "the answer to", "question",
    "am i", "do i", "did i", "have i", "is my", "is the", "is a",
}

local NUMWORDS = {
    first = 1, second = 2, third = 3, fourth = 4, fifth = 5, sixth = 6,
    seventh = 7, eighth = 8, ninth = 9, tenth = 10, eleventh = 11,
    twelfth = 12, thirteenth = 13, fourteenth = 14, fifteenth = 15,
    sixteenth = 16, seventeenth = 17, eighteenth = 18,
}

local CARDINALS = {
    one = 1, two = 2, three = 3, four = 4, five = 5, six = 6, seven = 7,
    eight = 8, nine = 9, ten = 10, eleven = 11, twelve = 12,
    thirteen = 13, fourteen = 14, fifteen = 15, sixteen = 16,
    seventeen = 17, eighteen = 18,
}

local ORD_SUFFIX = { [1] = "1st", [2] = "2nd", [3] = "3rd" }
local function ordinal(n) return ORD_SUFFIX[n] or (tostring(n) .. "th") end

local function trim(s) return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")) end
local function stripRich(s)
    if type(s) ~= "string" then return tostring(s) end
    return (s:gsub("<[^>]->", ""))
end
local function upperClean(s)
    return (tostring(s or ""):upper():gsub("%s+", ""):gsub("[%?%.%,!\"'`\n\r]", ""))
end
local function basicClean(s)
    s = tostring(s or ""):lower()
    s = s:gsub("[%?%!%.%,%;%:\"'`]", " ")
    s = s:gsub("%s+", " ")
    return trim(s)
end

local function applyAliases(s)
    local out = {}
    for word in s:gmatch("%S+") do
        local swapped = WORD_ALIAS[word]
        if swapped ~= nil then
            if swapped ~= "" then out[#out + 1] = swapped end
        else
            out[#out + 1] = word
        end
    end
    return table.concat(out, " ")
end

local function stripFillers(s)
    local out = " " .. s .. " "
    for _, filler in ipairs(FILLERS) do
        out = out:gsub("%s" .. filler:gsub("%%", "%%%%") .. "%s", " ")
    end
    out = out:gsub("%s+my%s+", " "):gsub("^%s*my%s+", " ")
    out = out:gsub("%s+sammys?%s+", " "):gsub("^%s*sammys?%s+", " ")
    out = out:gsub("%s+the%s+", " "):gsub("%s+of%s+", " "):gsub("%s+for%s+", " ")
    out = out:gsub("%s+a%s+", " "):gsub("%s+an%s+", " "):gsub("%s+in%s+", " ")
    out = out:gsub("%s+i%s+", " "):gsub("%s+is%s+", " "):gsub("%s+was%s+", " ")
    out = out:gsub("%s+", " ")
    return trim(out)
end

local function toDigits(s)
    local conv = s
    for word, n in pairs(NUMWORDS) do
        conv = conv:gsub("%f[%a]" .. word .. "%f[%A]", ordinal(n))
    end
    for word, n in pairs(CARDINALS) do
        conv = conv:gsub("%f[%a]" .. word .. "%f[%A]", tostring(n))
    end
    return conv
end

local QWORDS = { who = true, what = true, which = true, when = true, where = true, how = true }
local CATEGORY_WORDS = { mutation = true, machine = true, trait = true, brainrot = true, rarity = true, color = true, number = true }

local function words(s)
    local list = {}
    for word in s:gmatch("%S+") do list[#list + 1] = word end
    return list
end

local function dropLead(s)
    local list = words(s)
    if #list < 2 or not QWORDS[list[1]] then return nil end
    table.remove(list, 1)
    if #list > 1 and CATEGORY_WORDS[list[1]] then table.remove(list, 1) end
    return table.concat(list, " ")
end

local function localAnswer(text)
    if not text or text == "" then return nil end
    local raw = basicClean(text)
    local aliased = applyAliases(raw)
    local core = stripFillers(aliased)
    local candidates = { raw, aliased, core }
    local lead = dropLead(core)
    if lead then candidates[#candidates + 1] = lead end

    local base = #candidates
    for i = 1, base do
        local converted = toDigits(candidates[i])
        if converted ~= candidates[i] then candidates[#candidates + 1] = converted end
    end

    for _, key in ipairs(candidates) do
        key = trim(key)
        if key ~= "" and SAB_DB[key] then return SAB_DB[key] end
    end
    return nil
end

local PROTECTED = { ["black and white"] = "\1blackwhite\1" }
local UNPROTECT = { ["\1blackwhite\1"] = "black and white" }

local function splitQuestions(text)
    local s = " " .. tostring(text or ""):lower() .. " "
    for phrase, token in pairs(PROTECTED) do s = s:gsub(phrase, token) end
    s = s:gsub("%s*[%?%;%,]%s*", " and ")
    s = s:gsub("%s*&%s*", " and ")
    s = s:gsub("%s*%+%s*", " and ")
    s = " " .. basicClean(s) .. " "
    s = s:gsub("%s+add%s+", " and ")
    s = s:gsub("%s+plus%s+", " and ")
    s = s:gsub("%s+then%s+", " and ")
    s = s:gsub("%s+", " ")

    local parts = {}
    for part in (s .. " and "):gmatch("(.-)%s+and%s+") do
        part = trim(part)
        if part ~= "" then
            for token, phrase in pairs(UNPROTECT) do part = part:gsub(token, phrase) end
            parts[#parts + 1] = part
        end
    end
    if #parts == 0 then parts[1] = trim(basicClean(text)) end
    return parts
end

local function multiplierOf(text)
    local l = text:lower()
    if l:find("twice") then return 2 end
    if l:find("thrice") then return 3 end
    local n = tonumber(l:match("(%d+)%s*times"))
    if n and n >= 2 and n <= 10 then return n end
    for word, value in pairs(CARDINALS) do
        if value >= 2 and value <= 10 and l:find("%f[%a]" .. word .. "%s+times") then return value end
    end
    return nil
end

local function stripMultiplier(text)
    local s = text
    s = s:gsub("%s*%d+%s*times%s*", " ")
    s = s:gsub("%s*twice%s*", " ")
    s = s:gsub("%s*thrice%s*", " ")
    for word, value in pairs(CARDINALS) do
        if value >= 2 and value <= 10 then s = s:gsub("%s*" .. word .. "%s+times%s*", " ")
        end
    end
    return trim(s) ~= "" and s or text
end

local function resolvePart(part)
    local times = multiplierOf(part)
    local q = stripMultiplier(part)
    q = trim(q)
    if q == "" then return nil end
    local onlyNumber = q:match("^%d+$")
    if onlyNumber then
        return times and string.rep(onlyNumber, times) or onlyNumber
    end
    local answer = localAnswer(q)
    if not answer then return nil end
    local clean = upperClean(answer)
    if clean == "" then return nil end
    return times and string.rep(clean, times) or clean
end

local function solveRiddle(text)
    local parts = splitQuestions(text)
    local answers = {}
    local breakdown = {}
    local missing = 0

    for _, part in ipairs(parts) do
        local ok, result = pcall(resolvePart, part)
        if ok and result and result ~= "" then
            answers[#answers + 1] = result
            breakdown[#breakdown + 1] = part:sub(1, 30) .. " = " .. result
        else
            missing = missing + 1
            breakdown[#breakdown + 1] = part:sub(1, 30) .. " = ?"
        end
    end

    if #answers == 0 then
        return nil, breakdown, "not in database"
    end

    local out = table.concat(answers, "")
    return out, breakdown, (missing > 0) and (missing .. " part(s) not in database") or nil
end

local QUESTION_STARTERS = { "what", "whats", "who", "whos", "when", "where", "which", "how", "name", "tell", "type", "say", "guess", "answer", "riddle" }

local function looksLikeRiddle(text)
    local l = basicClean(text)
    if l == "" then return false end
    if not l:find(" ") then return false end
    if l:find("?", 1, true) then return true end
    local firstWord = l:match("^(%S+)")
    for _, starter in ipairs(QUESTION_STARTERS) do
        if firstWord == starter then return true end
    end
    if l:find("%f[%a]my%f[%A]") and (l:find("%f[%a]and%f[%A]") or l:find("favorite") or l:find("favourite")) then
        return true
    end
    if l:find("favorite") or l:find("favourite") then return true end
    return false
end

-- ============================================================
-- VARIÁVEIS DE ESTADO
-- ============================================================
local _enabled = cfg.codeSniper
local _autoAccept = cfg.autoSubmit
local _submitAfter = cfg.submitAfter
local _retypeInvalid = cfg.retypeInvalid
local _riddleSolver = cfg.riddleSolver

local _seen = {}
local _capturedParts = {}
local _lastWatchedBox = nil
local _boxTextConn = nil
local _boxAncestryConn = nil
local _lastNonBlankBoxText = ""
local _pendingRejectedText = nil
local _pendingRejectedBox = nil
local _pendingRejectedUntil = 0
local _pendingRejectedToken = 0
local _lastStatusMsg = nil
local _solvedCount = 0
local _askedCount = 0
local _riddleQueue = {}
local _riddleBusy = false
local LogContainer = nil
local logLines = {}
local MAX_LOG_LINES = 50

local listenConn = nil
local solveLabel = nil

-- ============================================================
-- FUNÇÕES AUXILIARES
-- ============================================================
local function arredondar(instancia, radius)
    if not instancia then return end
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = instancia
    return corner
end

local grads = {}
local borderAnims = {}

local function mkAnimatedStroke(parent, thick, color1, color2, tr, speed)
    local s = Instance.new("UIStroke")
    s.Color = color1 or C.Stroke
    s.Thickness = thick or 1.5
    s.Transparency = tr or 0.2
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent

    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1 or C.Accent),
        ColorSequenceKeypoint.new(0.3, color2 or C.AccentHi),
        ColorSequenceKeypoint.new(0.6, color1 or C.Accent),
        ColorSequenceKeypoint.new(0.8, C.White),
        ColorSequenceKeypoint.new(1, color1 or C.Accent)
    })
    g.Rotation = 0
    g.Parent = s
    table.insert(grads, g)

    local conn = RunService.Heartbeat:Connect(function()
        if not g or not g.Parent then
            conn:Disconnect()
            return
        end
        g.Rotation = (g.Rotation + (speed or 60) * 0.016) % 360
    end)
    table.insert(borderAnims, conn)
    return s, g
end

local function updateGradients()
    local ang = (tick() * 120) % 360
    for i = #grads, 1, -1 do
        local g = grads[i]
        if g and g.Parent then
            g.Rotation = ang
        else
            table.remove(grads, i)
        end
    end
end
RunService.Heartbeat:Connect(updateGradients)

-- ============================================================
-- SISTEMA DE LOGS
-- ============================================================
local function addLog(text, color)
    color = color or C.Muted
    text = tostring(text)
    table.insert(logLines, {text = text, color = color})
    if #logLines > MAX_LOG_LINES then
        table.remove(logLines, 1)
    end
    pcall(function()
        if not LogContainer then return end
        for _, child in ipairs(LogContainer:GetChildren()) do
            if child:IsA("TextLabel") then child:Destroy() end
        end
        for i, line in ipairs(logLines) do
            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, -10, 0, 16)
            label.Position = UDim2.new(0, 5, 0, (i - 1) * 16)
            label.Font = Enum.Font.Gotham
            label.TextSize = 11
            label.TextColor3 = line.color
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = line.text
            label.Parent = LogContainer
        end
        local layout = LogContainer:FindFirstChildOfClass("UIListLayout")
        if layout then
            LogContainer.CanvasPosition = Vector2.new(0, math.max(0, #logLines * 16 - LogContainer.AbsoluteSize.Y))
        end
    end)
end

local function setStatus(msg, col)
    if msg == _lastStatusMsg then return end
    _lastStatusMsg = msg
    addLog(msg, col or C.Muted)
end

local function flashCode(code, col)
    if not code or code == "" then return end
    setStatus("[code] -> " .. tostring(code), col or C.White)
end

local function bumpSolvedLabel()
    if solveLabel then
        solveLabel.Text = _solvedCount .. " solved / " .. _askedCount .. " asked"
    end
end

-- ============================================================
-- LÓGICA DE CÓDIGO
-- ============================================================
local function isOurGui(instance)
    local p = instance
    for _ = 1, 10 do
        if not p then break end
        if p.Name == "HighAutoRedeemer" or p.Name == "HighLogs" then return true end
        p = p.Parent
    end
    return false
end

local function isVisibleChain(inst)
    local current = inst
    while current do
        if current:IsA("GuiObject") and not current.Visible then return false end
        if current:IsA("ScreenGui") then return current.Enabled end
        current = current.Parent
    end
    return true
end

local function findAllTextBoxes(pg)
    local boxes = {}
    for _, gui in ipairs(pg:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled and not isOurGui(gui) then
            for _, d in ipairs(gui:GetDescendants()) do
                if d:IsA("TextBox") and not isOurGui(d) then
                    boxes[#boxes+1] = d
                end
            end
        end
    end
    return boxes
end

local function findCodeButtons(pg)
    local btns = {}
    for _, gui in ipairs(pg:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled and not isOurGui(gui) then
            for _, d in ipairs(gui:GetDescendants()) do
                if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) then
                    local n = d.Name:lower()
                    local pn = (d.Parent and d.Parent.Name or ""):lower()
                    if (n:find("code") or n:find("redeem") or pn:find("code") or pn:find("redeem"))
                        and isVisibleChain(d) then
                        btns[#btns+1] = d
                    end
                end
            end
        end
    end
    return btns
end

local function fireConnections(signal, ...)
    if typeof(getconns) ~= "function" then return false end
    local ok, connections = pcall(getconns, signal)
    if not ok or type(connections) ~= "table" then return false end
    local args = table.pack(...)
    local fired = false
    for _, connection in ipairs(connections) do
        local fireOk = pcall(function()
            if connection.Enabled ~= false then
                if args.n > 0 then connection:Fire(table.unpack(args, 1, args.n))
                else connection:Fire() end
            end
        end)
        fired = fired or fireOk
    end
    return fired
end

local function clickButton(btn)
    if not btn then return false end
    local any = false
    any = pcall(function() btn.MouseButton1Click:Fire() end) or any
    any = pcall(function() btn.Activated:Fire() end) or any
    if typeof(firesignal) == "function" then
        any = pcall(firesignal, btn.MouseButton1Click) or any
        any = pcall(firesignal, btn.Activated) or any
    end
    any = fireConnections(btn.MouseButton1Click) or any
    any = fireConnections(btn.Activated) or any
    if typeof(fireclick) == "function" then any = pcall(fireclick, btn) or any end
    return any
end

local function fireBoxFocusLost(box)
    if not box then return false end
    local any = false
    if typeof(firesignal) == "function" then
        any = pcall(firesignal, box.FocusLost, true) or any
    end
    if typeof(getconns) == "function" then
        local ok, connections = pcall(getconns, box.FocusLost)
        if ok and type(connections) == "table" then
            for _, connection in ipairs(connections) do
                any = pcall(function()
                    if connection.Enabled ~= false then connection:Fire(true) end
                end) or any
            end
        end
    end
    return any
end

local function currentCodeBox()
    local pg = playerGui or player:FindFirstChildOfClass("PlayerGui")
    if not pg then return nil end
    local codesGui = pg:FindFirstChild("Codes")
    if codesGui then
        local root = codesGui:FindFirstChild("Codes") or codesGui
        local redeem = root:FindFirstChild("CodeRedeem")
        local box = redeem and redeem:FindFirstChild("TextBox")
        if box and box:IsA("TextBox") then return box end
        for _, d in ipairs(codesGui:GetDescendants()) do
            if d:IsA("TextBox") then return d end
        end
    end
    for _, box in ipairs(findAllTextBoxes(pg)) do
        if isVisibleChain(box) then return box end
    end
    return nil
end

local function findSubmitButton(box)
    local names = { "submit", "redeem", "claim", "confirm", "enter", "send", "apply", "ok", "use", "go", "check" }
    local node = box.Parent
    for _ = 1, 8 do
        if not node then break end
        for _, d in ipairs(node:GetDescendants()) do
            if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) and d ~= box then
                local n = d.Name:lower()
                local txt = ""
                pcall(function() txt = tostring(d.Text):lower() end)
                for _, key in ipairs(names) do
                    if (n:find(key) or txt:find(key)) and isVisibleChain(d) then return d end
                end
            end
        end
        node = node.Parent
    end
    return nil
end

local function typeAndSubmitCode(code, captureFocus)
    code = tostring(code or "")
    if code == "" then return false, "empty code" end

    local pg = playerGui or player:FindFirstChildOfClass("PlayerGui")
    if not pg then return false, "no PlayerGui" end

    local codesGui = pg:FindFirstChild("Codes")
    if codesGui then
        pcall(function()
            if codesGui:IsA("ScreenGui") then codesGui.Enabled = true end
            local node = codesGui:FindFirstChild("Codes") or codesGui
            while node and node ~= codesGui do
                if node:IsA("GuiObject") then node.Visible = true end
                node = node.Parent
            end
        end)
    else
        for _, btn in ipairs(findCodeButtons(pg)) do
            clickButton(btn)
            task.wait(0.05)
        end
        task.wait(0.2)
    end

    local box
    local deadline = tick() + 2
    repeat
        box = currentCodeBox()
        if box then break end
        task.wait(0.1)
    until tick() > deadline
    if not box then return false, "code box not found" end

    if captureFocus then
        pcall(function() box:CaptureFocus() end)
        task.wait(0.05)
    end

    pcall(function() box.Text = "" end)
    task.wait(0.03)
    pcall(function() box.Text = code end)
    for _ = 1, 10 do
        if box.Text == code then break end
        task.wait(0.04)
        pcall(function() box.Text = code end)
    end
    task.wait(0.08)

    local submitted = fireBoxFocusLost(box)

    local btn = findSubmitButton(box)
    if btn then
        clickButton(btn)
        submitted = true
    end

    pcall(function()
        if typeof(keypress) == "function" then
            keypress(0x0D)
            task.wait(0.04)
            if typeof(keyrelease) == "function" then keyrelease(0x0D) end
            submitted = true
        end
    end)

    if captureFocus then
        task.wait(0.05)
        pcall(function() box:ReleaseFocus(false) end)
    end

    return true, submitted and "submitted" or "typed"
end

local function clearCapture()
    _capturedParts = {}
end

local function clearBoxWatchers()
    if _boxTextConn then pcall(function() _boxTextConn:Disconnect() end) end
    if _boxAncestryConn then pcall(function() _boxAncestryConn:Disconnect() end) end
    _boxTextConn = nil
    _boxAncestryConn = nil
    _lastWatchedBox = nil
end

local function watchBox(box)
    if not box or _lastWatchedBox == box then return end
    clearBoxWatchers()
    _lastWatchedBox = box
    if box.Text ~= "" then _lastNonBlankBoxText = box.Text end
    _boxTextConn = box:GetPropertyChangedSignal("Text"):Connect(function()
        if box.Text == "" then clearCapture()
        else _lastNonBlankBoxText = box.Text end
    end)
    _boxAncestryConn = box.AncestryChanged:Connect(function(_, parent)
        if not parent then clearCapture(); clearBoxWatchers() end
    end)
end

local function clearPendingSubmission()
    _pendingRejectedToken = _pendingRejectedToken + 1
    _pendingRejectedText = nil
    _pendingRejectedBox = nil
    _pendingRejectedUntil = 0
end

local function rememberPendingSubmission(box, text, replaceExisting)
    if not _retypeInvalid or not text or text == "" then return end
    if not replaceExisting and _pendingRejectedText and os.clock() <= _pendingRejectedUntil then return end
    _pendingRejectedToken = _pendingRejectedToken + 1
    local token = _pendingRejectedToken
    _pendingRejectedText = text
    _pendingRejectedBox = box
    _pendingRejectedUntil = os.clock() + 8
    task.delay(8, function()
        if token == _pendingRejectedToken then
            _pendingRejectedText = nil
            _pendingRejectedBox = nil
            _pendingRejectedUntil = 0
        end
    end)
end

local function restoreRejectedText(box, previousText)
    if not _retypeInvalid or not previousText or previousText == "" then return false end
    RunService.Heartbeat:Wait()
    local repasteBox = currentCodeBox() or box
    if not repasteBox or not isVisibleChain(repasteBox) then return false end
    local restored = pcall(function() repasteBox.Text = previousText end)
    if restored then
        _lastWatchedBox = repasteBox
        watchBox(repasteBox)
    end
    return restored
end

local function handleRedemptionFeedback(text, feedbackObject)
    if not _retypeInvalid or not _pendingRejectedText then return end
    if os.clock() > _pendingRejectedUntil then clearPendingSubmission(); return end
    if feedbackObject and feedbackObject:IsDescendantOf(playerGui:FindFirstChild("HighAutoRedeemer")) then return end
    local lower = tostring(text or ""):lower()
    local rejected = lower:find("invalid code", 1, true)
        or lower:find("code is invalid", 1, true)
        or lower:find("expired", 1, true)
        or lower:find("already redeemed", 1, true)
        or lower:find("already used", 1, true)
        or lower:find("doesn't exist", 1, true)
        or lower:find("does not exist", 1, true)
        or lower:find("not found", 1, true)
        or lower:find("rejected", 1, true)
    if not rejected then return end
    local previousText = _pendingRejectedText
    local previousBox = _pendingRejectedBox
    local restored = restoreRejectedText(previousBox, previousText)
    clearPendingSubmission()
    if restored then
        setStatus("Invalid - repasted: " .. previousText, C.Text)
        flashCode(previousText, C.Red)
    end
end

local function appendToBox(text)
    if not text or text == "" then return end
    if _lastWatchedBox and not isVisibleChain(_lastWatchedBox) then
        clearCapture()
        clearBoxWatchers()
    end

    local box = currentCodeBox()
    _capturedParts[#_capturedParts + 1] = text
    local combinedCode = table.concat(_capturedParts)
    local capturedCount = #_capturedParts

    if box then
        _lastWatchedBox = box
        watchBox(box)
        local boxWasFocused = UserInputService:GetFocusedTextBox() == box
        box.Text = combinedCode
        if boxWasFocused then
            pcall(function()
                local caretEnd = #combinedCode + 1
                box.CursorPosition = caretEnd
                box.SelectionStart = caretEnd
            end)
        end
    end

    setStatus("Pasted " .. tostring(capturedCount) .. "/" .. tostring(_submitAfter), C.Green)
    flashCode(combinedCode, C.Green)

    if capturedCount >= _submitAfter then
        _capturedParts = {}
        if _autoAccept then
            rememberPendingSubmission(box, combinedCode, true)
            local ok, statusMsg = typeAndSubmitCode(combinedCode, false)
            if ok then
                setStatus("Redeemed: " .. combinedCode, C.Green)
            else
                local restored = restoreRejectedText(box, combinedCode)
                clearPendingSubmission()
                if restored then
                    setStatus("Invalid - repasted: " .. combinedCode, C.Text)
                    flashCode(combinedCode, C.Red)
                else
                    setStatus("Failed: " .. tostring(statusMsg), C.Red)
                end
            end
        end
    end
end

-- ============================================================
-- RIDDLE QUEUE
-- ============================================================
local function runRiddle(question)
    _askedCount = _askedCount + 1
    bumpSolvedLabel()

    setStatus("Riddle: " .. question:sub(1, 90), C.Muted)

    local answer, breakdown, note = solveRiddle(question)

    if breakdown then
        for _, line in ipairs(breakdown) do
            local colour = line:sub(-1) == "?" and C.Red or C.Muted
            addLog("  " .. line, colour)
        end
    end

    if not answer or answer == "" then
        setStatus("  " .. tostring(note or "not in database"), C.Red)
        return
    end

    _solvedCount = _solvedCount + 1
    bumpSolvedLabel()
    setStatus("  Answer: " .. answer, C.Green)
    if note then
        setStatus("  " .. note, C.Muted)
    end

    if _autoAccept then
        local ok, message = typeAndSubmitCode(answer, true)
        setStatus("  " .. (ok and message or ("submit failed: " .. tostring(message))), ok and C.Green or C.Red)
    else
        setStatus("  Auto submit is off, not sent", C.Muted)
    end
end

local function pumpQueue()
    if _riddleBusy then return end
    _riddleBusy = true
    task.spawn(function()
        while #_riddleQueue > 0 do
            local question = table.remove(_riddleQueue, 1)
            pcall(runRiddle, question)
        end
        _riddleBusy = false
    end)
end

local function queueRiddle(question)
    if #_riddleQueue > 6 then return end
    _riddleQueue[#_riddleQueue + 1] = question
    pumpQueue()
end

-- ============================================================
-- DETECÇÃO DE ANÚNCIOS
-- ============================================================
local function resolveNotifyRemote()
    if _G.PhiNotifyRemote then return _G.PhiNotifyRemote end

    local ok, controller = pcall(function()
        if not ReplicatedStorage then return nil end
        local controllers = ReplicatedStorage:FindFirstChild("Controllers")
        local notification = controllers and controllers:FindFirstChild("NotificationController", true)
        if notification then return require(notification) end
        return nil
    end)
    if ok and type(controller) == "table" and type(controller.Start) == "function"
        and typeof(getupvalues) == "function" then
        local valuesOk, values = pcall(getupvalues, controller.Start)
        if valuesOk and type(values) == "table" then
            for _, value in pairs(values) do
                if typeof(value) == "Instance"
                    and (value:IsA("RemoteEvent") or value:IsA("UnreliableRemoteEvent")) then
                    return value
                end
            end
        end
    end

    local getinfo = debug and (debug.getinfo or debug.info)
    local packages = ReplicatedStorage and ReplicatedStorage:FindFirstChild("Packages")
    local net = packages and packages:FindFirstChild("Net")
    if net and getinfo and getconns then
        for _, d in ipairs(net:GetDescendants()) do
            if d:IsA("RemoteEvent") then
                local okConns, connections = pcall(getconns, d.OnClientEvent)
                if okConns and type(connections) == "table" then
                    for _, connection in ipairs(connections) do
                        local fnOk, fn = pcall(function() return connection.Function end)
                        if fnOk and type(fn) == "function" then
                            local infoOk, info = pcall(getinfo, fn)
                            if infoOk and info
                                and tostring(info.short_src or info.source or ""):find("NotificationController", 1, true) then
                                return d
                            end
                        end
                    end
                end
            end
        end
    end
    return nil
end

local function onAnnouncement(...)
    local text = trim(stripRich(tostring((...) or "")))
    if text == "" then return end

    if text:find("%s") then
        if _riddleSolver and looksLikeRiddle(text) then
            queueRiddle(text)
        end
        return
    end

    for word in text:gmatch("[%w_]+") do
        if word ~= "" and not _seen[word] then
            _seen[word] = true
            task.delay(1.25, function() _seen[word] = nil end)
            appendToBox(word)
        end
    end
end

task.spawn(function()
    local remote = resolveNotifyRemote()
    if remote and (remote:IsA("RemoteEvent") or remote:IsA("UnreliableRemoteEvent")) then
        listenConn = remote.OnClientEvent:Connect(function(...)
            if not _enabled then return end
            pcall(onAnnouncement, ...)
        end)
        setStatus("Listener attached: " .. remote.Name, C.Green)
    else
        setStatus("No notify remote found", C.Red)
    end
end)

-- Monitorar feedback de redenção
local function watchRedemptionFeedbackObject(obj)
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton")) then return end
    handleRedemptionFeedback(obj.Text or "", obj)
    obj:GetPropertyChangedSignal("Text"):Connect(function()
        handleRedemptionFeedback(obj.Text or "", obj)
    end)
end

for _, obj in ipairs(playerGui:GetDescendants()) do
    watchRedemptionFeedbackObject(obj)
end
playerGui.DescendantAdded:Connect(function(obj)
    task.wait(0.04)
    watchRedemptionFeedbackObject(obj)
end)

-- ============================================================
-- TOGGLE ANIMATION
-- ============================================================
local function atualizarToggle(ativo, bg, circle)
    if not bg or not circle then return end
    pcall(function()
        if ativo then
            TweenService:Create(bg, TweenInfo.new(0.18), {BackgroundColor3 = C.AccentHi}):Play()
            TweenService:Create(circle, TweenInfo.new(0.18), {Position = UDim2.new(1, -16, 0.5, -7), BackgroundColor3 = C.White}):Play()
        else
            TweenService:Create(bg, TweenInfo.new(0.18), {BackgroundColor3 = C.TrackOff}):Play()
            TweenService:Create(circle, TweenInfo.new(0.18), {Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = C.KnobOff}):Play()
        end
    end)
end

-- ============================================================
-- CRIAÇÃO DA GUI PRINCIPAL
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HighAutoRedeemer"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 0)
MainFrame.AutomaticSize = Enum.AutomaticSize.Y
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -120)
MainFrame.BackgroundColor3 = C.Bg
MainFrame.BackgroundTransparency = 0.08
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
arredondar(MainFrame, 14)
mkAnimatedStroke(MainFrame, 1.8, C.Stroke, C.AccentHi, 0.2, 55)

local mainListLayout = Instance.new("UIListLayout")
mainListLayout.FillDirection = Enum.FillDirection.Vertical
mainListLayout.Padding = UDim.new(0, 4)
mainListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
mainListLayout.SortOrder = Enum.SortOrder.LayoutOrder
mainListLayout.Parent = MainFrame

local mainPadding = Instance.new("UIPadding")
mainPadding.PaddingTop = UDim.new(0, 8)
mainPadding.PaddingBottom = UDim.new(0, 8)
mainPadding.PaddingLeft = UDim.new(0, 8)
mainPadding.PaddingRight = UDim.new(0, 8)
mainPadding.Parent = MainFrame

-- HEADER
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 22)
header.BackgroundTransparency = 1
header.LayoutOrder = 1
header.Parent = MainFrame

local dot = Instance.new("Frame")
dot.Size = UDim2.new(0, 7, 0, 7)
dot.Position = UDim2.new(0, 0, 0, 6)
dot.BackgroundColor3 = C.AccentHi
dot.BorderSizePixel = 0
dot.Parent = header
arredondar(dot, 3.5)

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 14, 0, 3)
title.Size = UDim2.new(1, -30, 0, 16)
title.Font = Enum.Font.GothamBold
title.TextSize = 11
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = C.Text
title.Text = "High Auto Redeemer v2"
title.Parent = header

do
    local tg = Instance.new("UIGradient")
    tg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.Accent),
        ColorSequenceKeypoint.new(0.5, C.AccentHi),
        ColorSequenceKeypoint.new(1, C.Accent)
    })
    tg.Parent = title
    local conn = RunService.Heartbeat:Connect(function()
        if tg and tg.Parent then
            tg.Rotation = (tg.Rotation + 0.4) % 360
        else
            conn:Disconnect()
        end
    end)
    table.insert(borderAnims, conn)
end

-- CORPO
local corpo = Instance.new("Frame")
corpo.Name = "Corpo"
corpo.Size = UDim2.new(1, 0, 0, 0)
corpo.AutomaticSize = Enum.AutomaticSize.Y
corpo.BackgroundTransparency = 1
corpo.LayoutOrder = 2
corpo.Parent = MainFrame

local corpoLayout = Instance.new("UIListLayout")
corpoLayout.FillDirection = Enum.FillDirection.Vertical
corpoLayout.Padding = UDim.new(0, 4)
corpoLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
corpoLayout.SortOrder = Enum.SortOrder.LayoutOrder
corpoLayout.Parent = corpo

-- ROW 1: AUTO CODE (SNIPER)
local autoRow = Instance.new("Frame")
autoRow.Size = UDim2.new(1, 0, 0, 28)
autoRow.BackgroundColor3 = C.BgRow
autoRow.BackgroundTransparency = 0.4
autoRow.BorderSizePixel = 0
autoRow.LayoutOrder = 1
autoRow.Parent = corpo
arredondar(autoRow, 8)
mkAnimatedStroke(autoRow, 1.2, C.Stroke, C.Accent, 0.3, 45)

local autoLabel = Instance.new("TextLabel")
autoLabel.BackgroundTransparency = 1
autoLabel.Position = UDim2.new(0, 10, 0, 0)
autoLabel.Size = UDim2.new(0.6, 0, 1, 0)
autoLabel.Font = Enum.Font.GothamMedium
autoLabel.TextSize = 10
autoLabel.TextXAlignment = Enum.TextXAlignment.Left
autoLabel.TextColor3 = C.Text
autoLabel.Text = "Code Sniper"
autoLabel.Parent = autoRow

local autoToggleBg = Instance.new("Frame")
autoToggleBg.Size = UDim2.new(0, 30, 0, 16)
autoToggleBg.Position = UDim2.new(1, -38, 0.5, -8)
autoToggleBg.BackgroundColor3 = C.TrackOff
autoToggleBg.BorderSizePixel = 0
autoToggleBg.Parent = autoRow
arredondar(autoToggleBg, 8)

local autoToggleCircle = Instance.new("Frame")
autoToggleCircle.Size = UDim2.new(0, 12, 0, 12)
autoToggleCircle.Position = UDim2.new(0, 2, 0.5, -6)
autoToggleCircle.BackgroundColor3 = C.KnobOff
autoToggleCircle.BorderSizePixel = 0
autoToggleCircle.Parent = autoToggleBg
arredondar(autoToggleCircle, 6)

local autoToggleBtn = Instance.new("TextButton")
autoToggleBtn.Size = UDim2.new(1, 0, 1, 0)
autoToggleBtn.BackgroundTransparency = 1
autoToggleBtn.Text = ""
autoToggleBtn.Parent = autoToggleBg

-- ROW 2: AUTO SUBMIT
local submitRow = Instance.new("Frame")
submitRow.Size = UDim2.new(1, 0, 0, 28)
submitRow.BackgroundColor3 = C.BgRow
submitRow.BackgroundTransparency = 0.4
submitRow.BorderSizePixel = 0
submitRow.LayoutOrder = 2
submitRow.Parent = corpo
arredondar(submitRow, 8)
mkAnimatedStroke(submitRow, 1.2, C.Stroke, C.Accent, 0.3, 45)

local submitLabel = Instance.new("TextLabel")
submitLabel.BackgroundTransparency = 1
submitLabel.Position = UDim2.new(0, 10, 0, 0)
submitLabel.Size = UDim2.new(0.6, 0, 1, 0)
submitLabel.Font = Enum.Font.GothamMedium
submitLabel.TextSize = 10
submitLabel.TextXAlignment = Enum.TextXAlignment.Left
submitLabel.TextColor3 = C.Text
submitLabel.Text = "Auto Submit"
submitLabel.Parent = submitRow

local submitToggleBg = Instance.new("Frame")
submitToggleBg.Size = UDim2.new(0, 30, 0, 16)
submitToggleBg.Position = UDim2.new(1, -38, 0.5, -8)
submitToggleBg.BackgroundColor3 = C.TrackOff
submitToggleBg.BorderSizePixel = 0
submitToggleBg.Parent = submitRow
arredondar(submitToggleBg, 8)

local submitToggleCircle = Instance.new("Frame")
submitToggleCircle.Size = UDim2.new(0, 12, 0, 12)
submitToggleCircle.Position = UDim2.new(0, 2, 0.5, -6)
submitToggleCircle.BackgroundColor3 = C.KnobOff
submitToggleCircle.BorderSizePixel = 0
submitToggleCircle.Parent = submitToggleBg
arredondar(submitToggleCircle, 6)

local submitToggleBtn = Instance.new("TextButton")
submitToggleBtn.Size = UDim2.new(1, 0, 1, 0)
submitToggleBtn.BackgroundTransparency = 1
submitToggleBtn.Text = ""
submitToggleBtn.Parent = submitToggleBg

-- ROW 3: SUBMIT AFTER
local afterRow = Instance.new("Frame")
afterRow.Size = UDim2.new(1, 0, 0, 28)
afterRow.BackgroundColor3 = C.BgRow
afterRow.BackgroundTransparency = 0.4
afterRow.BorderSizePixel = 0
afterRow.LayoutOrder = 3
afterRow.Parent = corpo
arredondar(afterRow, 8)
mkAnimatedStroke(afterRow, 1.2, C.Stroke, C.Accent, 0.3, 45)

local afterLabel = Instance.new("TextLabel")
afterLabel.BackgroundTransparency = 1
afterLabel.Position = UDim2.new(0, 10, 0, 0)
afterLabel.Size = UDim2.new(0.6, 0, 1, 0)
afterLabel.Font = Enum.Font.GothamMedium
afterLabel.TextSize = 10
afterLabel.TextXAlignment = Enum.TextXAlignment.Left
afterLabel.TextColor3 = C.Text
afterLabel.Text = "Submit after"
afterLabel.Parent = afterRow

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 18, 0, 18)
minusBtn.Position = UDim2.new(1, -58, 0.5, -9)
minusBtn.BackgroundColor3 = C.BgRow
minusBtn.BackgroundTransparency = 0.4
minusBtn.BorderSizePixel = 0
minusBtn.Text = "−"
minusBtn.TextColor3 = C.Text
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 11
minusBtn.Parent = afterRow
arredondar(minusBtn, 4)
mkAnimatedStroke(minusBtn, 1, C.Stroke, C.Accent, 0.3, 35)

local afterValueLabel = Instance.new("TextLabel")
afterValueLabel.Size = UDim2.new(0, 22, 0, 18)
afterValueLabel.Position = UDim2.new(1, -36, 0.5, -9)
afterValueLabel.BackgroundTransparency = 1
afterValueLabel.Text = tostring(_submitAfter)
afterValueLabel.TextColor3 = C.Text
afterValueLabel.Font = Enum.Font.GothamBold
afterValueLabel.TextSize = 11
afterValueLabel.Parent = afterRow

local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 18, 0, 18)
plusBtn.Position = UDim2.new(1, -18, 0.5, -9)
plusBtn.BackgroundColor3 = C.Accent
plusBtn.BackgroundTransparency = 0.2
plusBtn.BorderSizePixel = 0
plusBtn.Text = "+"
plusBtn.TextColor3 = C.White
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 11
plusBtn.Parent = afterRow
arredondar(plusBtn, 4)
mkAnimatedStroke(plusBtn, 1, C.Stroke, C.AccentHi, 0.3, 35)

-- ROW 4: RETYPE INVALID
local rtRow = Instance.new("Frame")
rtRow.Size = UDim2.new(1, 0, 0, 28)
rtRow.BackgroundColor3 = C.BgRow
rtRow.BackgroundTransparency = 0.4
rtRow.BorderSizePixel = 0
rtRow.LayoutOrder = 4
rtRow.Parent = corpo
arredondar(rtRow, 8)
mkAnimatedStroke(rtRow, 1.2, C.Stroke, C.Accent, 0.3, 45)

local rtLabel = Instance.new("TextLabel")
rtLabel.BackgroundTransparency = 1
rtLabel.Position = UDim2.new(0, 10, 0, 0)
rtLabel.Size = UDim2.new(0.6, 0, 1, 0)
rtLabel.Font = Enum.Font.GothamMedium
rtLabel.TextSize = 10
rtLabel.TextXAlignment = Enum.TextXAlignment.Left
rtLabel.TextColor3 = C.Text
rtLabel.Text = "Retype Invalid"
rtLabel.Parent = rtRow

local rtToggleBg = Instance.new("Frame")
rtToggleBg.Size = UDim2.new(0, 30, 0, 16)
rtToggleBg.Position = UDim2.new(1, -38, 0.5, -8)
rtToggleBg.BackgroundColor3 = C.TrackOff
rtToggleBg.BorderSizePixel = 0
rtToggleBg.Parent = rtRow
arredondar(rtToggleBg, 8)

local rtToggleCircle = Instance.new("Frame")
rtToggleCircle.Size = UDim2.new(0, 12, 0, 12)
rtToggleCircle.Position = UDim2.new(0, 2, 0.5, -6)
rtToggleCircle.BackgroundColor3 = C.KnobOff
rtToggleCircle.BorderSizePixel = 0
rtToggleCircle.Parent = rtToggleBg
arredondar(rtToggleCircle, 6)

local rtToggleBtn = Instance.new("TextButton")
rtToggleBtn.Size = UDim2.new(1, 0, 1, 0)
rtToggleBtn.BackgroundTransparency = 1
rtToggleBtn.Text = ""
rtToggleBtn.Parent = rtToggleBg

-- ROW 5: RIDDLE SOLVER (NOVO)
local riddleRow = Instance.new("Frame")
riddleRow.Size = UDim2.new(1, 0, 0, 28)
riddleRow.BackgroundColor3 = C.BgRow
riddleRow.BackgroundTransparency = 0.4
riddleRow.BorderSizePixel = 0
riddleRow.LayoutOrder = 5
riddleRow.Parent = corpo
arredondar(riddleRow, 8)
mkAnimatedStroke(riddleRow, 1.2, C.Stroke, C.Accent, 0.3, 45)

local riddleLabel = Instance.new("TextLabel")
riddleLabel.BackgroundTransparency = 1
riddleLabel.Position = UDim2.new(0, 10, 0, 0)
riddleLabel.Size = UDim2.new(0.6, 0, 1, 0)
riddleLabel.Font = Enum.Font.GothamMedium
riddleLabel.TextSize = 10
riddleLabel.TextXAlignment = Enum.TextXAlignment.Left
riddleLabel.TextColor3 = C.Text
riddleLabel.Text = "Riddle Solver"
riddleLabel.Parent = riddleRow

local riddleToggleBg = Instance.new("Frame")
riddleToggleBg.Size = UDim2.new(0, 30, 0, 16)
riddleToggleBg.Position = UDim2.new(1, -38, 0.5, -8)
riddleToggleBg.BackgroundColor3 = C.TrackOff
riddleToggleBg.BorderSizePixel = 0
riddleToggleBg.Parent = riddleRow
arredondar(riddleToggleBg, 8)

local riddleToggleCircle = Instance.new("Frame")
riddleToggleCircle.Size = UDim2.new(0, 12, 0, 12)
riddleToggleCircle.Position = UDim2.new(0, 2, 0.5, -6)
riddleToggleCircle.BackgroundColor3 = C.KnobOff
riddleToggleCircle.BorderSizePixel = 0
riddleToggleCircle.Parent = riddleToggleBg
arredondar(riddleToggleCircle, 6)

local riddleToggleBtn = Instance.new("TextButton")
riddleToggleBtn.Size = UDim2.new(1, 0, 1, 0)
riddleToggleBtn.BackgroundTransparency = 1
riddleToggleBtn.Text = ""
riddleToggleBtn.Parent = riddleToggleBg

-- ROW 6: SOLVED STATS
local statsRow = Instance.new("Frame")
statsRow.Size = UDim2.new(1, 0, 0, 22)
statsRow.BackgroundColor3 = C.BgRow
statsRow.BackgroundTransparency = 0.3
statsRow.BorderSizePixel = 0
statsRow.LayoutOrder = 6
statsRow.Parent = corpo
arredondar(statsRow, 8)

solveLabel = Instance.new("TextLabel")
solveLabel.BackgroundTransparency = 1
solveLabel.Size = UDim2.new(1, -10, 1, 0)
solveLabel.Position = UDim2.new(0, 5, 0, 0)
solveLabel.Font = Enum.Font.Gotham
solveLabel.TextSize = 10
solveLabel.TextColor3 = C.Green
solveLabel.TextXAlignment = Enum.TextXAlignment.Center
solveLabel.Text = "0 solved / 0 asked"
solveLabel.Parent = statsRow

-- ROW 7: HIDE LOGS
local hideLogsFrame = Instance.new("Frame")
hideLogsFrame.Size = UDim2.new(1, 0, 0, 28)
hideLogsFrame.BackgroundColor3 = C.Accent
hideLogsFrame.BackgroundTransparency = 0.2
hideLogsFrame.BorderSizePixel = 0
hideLogsFrame.LayoutOrder = 7
hideLogsFrame.Parent = corpo
arredondar(hideLogsFrame, 8)
mkAnimatedStroke(hideLogsFrame, 1.5, C.Stroke, C.AccentHi, 0.3, 45)

local hideLogsBtn = Instance.new("TextButton")
hideLogsBtn.Size = UDim2.new(1, 0, 1, 0)
hideLogsBtn.BackgroundTransparency = 1
hideLogsBtn.Text = "Hide Logs"
hideLogsBtn.Font = Enum.Font.GothamBold
hideLogsBtn.TextSize = 11
hideLogsBtn.TextColor3 = C.White
hideLogsBtn.Parent = hideLogsFrame

-- ROW 8: FOOTER
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -10, 0, 14)
footer.BackgroundTransparency = 1
footer.LayoutOrder = 8
footer.Font = Enum.Font.Gotham
footer.TextSize = 8
footer.TextColor3 = C.Muted
footer.Text = "SNIPER | SOLVER | RETYPE"
footer.TextXAlignment = Enum.TextXAlignment.Right
footer.Parent = corpo

-- ============================================================
-- LOGS GUI
-- ============================================================
local logsGui = Instance.new("ScreenGui")
logsGui.Name = "HighLogs"
logsGui.ResetOnSpawn = false
logsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
logsGui.Parent = playerGui

local logsFrame = Instance.new("Frame")
logsFrame.Name = "LogsFrame"
logsFrame.Size = UDim2.new(0, 240, 0, 200)
logsFrame.Position = UDim2.new(0.5, -360, 0.5, -140)
logsFrame.BackgroundColor3 = C.Bg
logsFrame.BackgroundTransparency = 0.08
logsFrame.BorderSizePixel = 0
logsFrame.ClipsDescendants = true
logsFrame.Active = true
logsFrame.Draggable = true
logsFrame.Parent = logsGui
arredondar(logsFrame, 14)
mkAnimatedStroke(logsFrame, 1.5, C.Stroke, C.Accent, 0.2, 50)

local logsHeader = Instance.new("Frame")
logsHeader.Size = UDim2.new(1, 0, 0, 22)
logsHeader.BackgroundTransparency = 1
logsHeader.Parent = logsFrame

local logsTitle = Instance.new("TextLabel")
logsTitle.Size = UDim2.new(1, -24, 0, 18)
logsTitle.Position = UDim2.new(0, 10, 0, 2)
logsTitle.BackgroundTransparency = 1
logsTitle.Font = Enum.Font.GothamBold
logsTitle.TextSize = 12
logsTitle.TextColor3 = C.Text
logsTitle.TextXAlignment = Enum.TextXAlignment.Left
logsTitle.Text = "Logs"
logsTitle.Parent = logsHeader

do
    local tg = Instance.new("UIGradient")
    tg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.Accent),
        ColorSequenceKeypoint.new(0.5, C.AccentHi),
        ColorSequenceKeypoint.new(1, C.Accent)
    })
    tg.Parent = logsTitle
    local conn = RunService.Heartbeat:Connect(function()
        if tg and tg.Parent then
            tg.Rotation = (tg.Rotation + 0.4) % 360
        else
            conn:Disconnect()
        end
    end)
    table.insert(borderAnims, conn)
end

local logsCloseBtn = Instance.new("TextButton")
logsCloseBtn.Size = UDim2.new(0, 18, 0, 18)
logsCloseBtn.Position = UDim2.new(1, -22, 0, 2)
logsCloseBtn.BackgroundColor3 = C.BgRow
logsCloseBtn.BackgroundTransparency = 0.4
logsCloseBtn.Text = "X"
logsCloseBtn.Font = Enum.Font.GothamBold
logsCloseBtn.TextSize = 10
logsCloseBtn.TextColor3 = C.Muted
logsCloseBtn.AutoButtonColor = false
logsCloseBtn.Parent = logsHeader
arredondar(logsCloseBtn, 5)
mkAnimatedStroke(logsCloseBtn, 1, C.Stroke, C.Accent, 0.3, 35)

LogContainer = Instance.new("ScrollingFrame")
LogContainer.Name = "LogContainer"
LogContainer.Size = UDim2.new(1, 0, 1, -22)
LogContainer.Position = UDim2.new(0, 0, 0, 22)
LogContainer.BackgroundTransparency = 1
LogContainer.BorderSizePixel = 0
LogContainer.ScrollBarThickness = 3
LogContainer.ScrollBarImageColor3 = C.Accent
LogContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
LogContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
LogContainer.Parent = logsFrame

local logLayout = Instance.new("UIListLayout")
logLayout.FillDirection = Enum.FillDirection.Vertical
logLayout.Padding = UDim.new(0, 2)
logLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
logLayout.Parent = LogContainer

local logPadding = Instance.new("UIPadding")
logPadding.PaddingTop = UDim.new(0, 6)
logPadding.PaddingBottom = UDim.new(0, 4)
logPadding.PaddingLeft = UDim.new(0, 8)
logPadding.PaddingRight = UDim.new(0, 4)
logPadding.Parent = LogContainer

-- ============================================================
-- DRAG
-- ============================================================
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

local function updateMain(input)
    local delta = input.Position - dragStart
    local newX = startPos.X.Offset + delta.X
    local newY = startPos.Y.Offset + delta.Y
    MainFrame.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateMain(input)
    end
end)

local logsDragging = false
local logsDragStart = nil
local logsStartPos = nil

logsFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        logsDragging = true
        logsDragStart = input.Position
        logsStartPos = logsFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                logsDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if logsDragging then
        local delta = input.Position - logsDragStart
        local newX = logsStartPos.X.Offset + delta.X
        local newY = logsStartPos.Y.Offset + delta.Y
        logsFrame.Position = UDim2.new(logsStartPos.X.Scale, newX, logsStartPos.Y.Scale, newY)
    end
end)

-- ============================================================
-- CONEXÕES DOS TOGGLES
-- ============================================================
autoToggleBtn.MouseButton1Click:Connect(function()
    _enabled = not _enabled
    cfg.codeSniper = _enabled
    saveConfig()
    atualizarToggle(_enabled, autoToggleBg, autoToggleCircle)
    if _enabled then
        setStatus("Code Sniper: ON", C.Green)
        addLog("Scanning for codes...", C.Muted)
    else
        setStatus("Code Sniper: OFF", C.Red)
        clearCapture()
        clearBoxWatchers()
    end
end)

submitToggleBtn.MouseButton1Click:Connect(function()
    _autoAccept = not _autoAccept
    cfg.autoSubmit = _autoAccept
    saveConfig()
    atualizarToggle(_autoAccept, submitToggleBg, submitToggleCircle)
    setStatus("Auto Submit: " .. (_autoAccept and "ON" or "OFF"), _autoAccept and C.Green or C.Red)
end)

rtToggleBtn.MouseButton1Click:Connect(function()
    _retypeInvalid = not _retypeInvalid
    cfg.retypeInvalid = _retypeInvalid
    saveConfig()
    atualizarToggle(_retypeInvalid, rtToggleBg, rtToggleCircle)
    setStatus("Retype Invalid: " .. (_retypeInvalid and "ON" or "OFF"), _retypeInvalid and C.Green or C.Red)
end)

riddleToggleBtn.MouseButton1Click:Connect(function()
    _riddleSolver = not _riddleSolver
    cfg.riddleSolver = _riddleSolver
    saveConfig()
    atualizarToggle(_riddleSolver, riddleToggleBg, riddleToggleCircle)
    setStatus("Riddle Solver: " .. (_riddleSolver and "ON" or "OFF"), _riddleSolver and C.Green or C.Red)
end)

local function setSubmitAfter(valor)
    _submitAfter = math.max(1, math.min(10, valor))
    cfg.submitAfter = _submitAfter
    saveConfig()
    afterValueLabel.Text = tostring(_submitAfter)
    clearCapture()
end

minusBtn.MouseButton1Click:Connect(function()
    setSubmitAfter(_submitAfter - 1)
end)

plusBtn.MouseButton1Click:Connect(function()
    setSubmitAfter(_submitAfter + 1)
end)

-- ============================================================
-- MOSTRAR/ESCONDER LOGS
-- ============================================================
local function showLogs()
    if logsFrame then
        logsFrame.Visible = true
        hideLogsBtn.Text = "Hide Logs"
    end
end

local function hideLogs()
    if logsFrame then
        logsFrame.Visible = false
        hideLogsBtn.Text = "Show Logs"
    end
end

hideLogsBtn.MouseButton1Click:Connect(function()
    if logsFrame and logsFrame.Visible then
        hideLogs()
    else
        showLogs()
    end
end)

logsCloseBtn.MouseButton1Click:Connect(function()
    hideLogs()
end)

-- ============================================================
-- INICIALIZAÇÃO
-- ============================================================
atualizarToggle(_enabled, autoToggleBg, autoToggleCircle)
atualizarToggle(_autoAccept, submitToggleBg, submitToggleCircle)
atualizarToggle(_retypeInvalid, rtToggleBg, rtToggleCircle)
atualizarToggle(_riddleSolver, riddleToggleBg, riddleToggleCircle)
afterValueLabel.Text = tostring(_submitAfter)

addLog("High Auto Redeemer v2 loaded!", C.Green)
addLog("Code Sniper: " .. (_enabled and "ON" or "OFF"), _enabled and C.Green or C.Muted)
addLog("Auto Submit: " .. (_autoAccept and "ON" or "OFF"), _autoAccept and C.Green or C.Muted)
addLog("Retype Invalid: " .. (_retypeInvalid and "ON" or "OFF"), _retypeInvalid and C.Green or C.Muted)
addLog("Riddle Solver: " .. (_riddleSolver and "ON" or "OFF"), _riddleSolver and C.Green or C.Muted)
addLog("Submit after: " .. tostring(_submitAfter), C.Muted)
addLog("Example: what is my name and what is my favorite food?", C.Muted)

showLogs()
bumpSolvedLabel()

-- ============================================================
-- LIMPEZA AO SAIR
-- ============================================================
local function stopEverything()
    if listenConn then
        pcall(function() listenConn:Disconnect() end)
        listenConn = nil
    end
    for _, conn in ipairs(borderAnims) do
        pcall(function() conn:Disconnect() end)
    end
    borderAnims = {}
    clearBoxWatchers()
    if ScreenGui then pcall(function() ScreenGui:Destroy() end) end
    if logsGui then pcall(function() logsGui:Destroy() end) end
end

env.Skyr0Stop = stopEverything
env.HighStop = stopEverything

task.spawn(function()
    while ScreenGui and ScreenGui.Parent do task.wait(5) end
    stopEverything()
end)

print("[High Auto Redeemer v2] Loaded successfully!")
