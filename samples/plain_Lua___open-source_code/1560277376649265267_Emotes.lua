--[[ 
    Source script taken from: https://github.com/Roblox/creator-docs/blob/main/content/en-us/characters/emotes.md

    scriptblox: https://scriptblox.com/script/Universal-Script-7yd7-I-Emote-Script-48024
]]


if _G.EmotesGUIRunning then
    getgenv().Notify({
        Title = '7yd7 | Emote',
        Content = '⚠️ It works It actually works',
        Duration = 5
    })
    return
end
_G.EmotesGUIRunning = true
local offsaleAnimationJson = true

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")
local request = http_request or (syn and syn.request) or request

local State = {
    currentMode = "emote",
    savedAnimPage = 1,
    savedEmotePage = 1,
    emotesWalkEnabled = false,
    favoriteEnabled = false,
    hudEditorActive = false,
    speedEmoteEnabled = false,
    isLoading = false,
    favoriteSetVersion = 0,
    favoriteSetBuiltVersion = -1,
    emoteCacheVersion = 0,
    animationCacheVersion = 0,
    isGUICreated = false,
    isMonitoringClicks = false,
    lastRadialActionTime = 0,
    lastWheelVisibleTime = 0,
    lastActionTick = 0,
    lastRandomEmoteId = nil,
    lastRandomAnimationId = nil,
    lastRandomVisualSpam = 0,
    randomSpamConn = nil,
    animImageSpamConn = nil,
    animImageSpamMap = nil,
    animImageSpamTicks = nil,
    animImageSpamToken = 0,
    animImageRetry = 0,
    randomSlotBlockerConn = nil,
    totalEmotesLoaded = 0,
    currentPage = 1,
    totalPages = 1,
    itemsPerPage = 8,
    emoteSearchTerm = "",
    animationSearchTerm = "",
    currentEmoteTrack = nil,
    currentCharacter = nil,
    emoteClickConnections = {},
    guiConnections = {},
    animationsData = {},
    originalAnimationsData = {},
    filteredAnimations = {},
    favoriteAnimations = {},
    favoriteAnimationsFileName = "FavoriteAnimations.json",
    emotesData = {},
    originalEmotesData = {},
    filteredEmotes = {},
    scannedEmotes = {},
    favoriteEmotes = {},
    favoriteFileName = "FavoriteEmotes.json",
    speedEmoteConfigFile = "SpeedEmoteConfig.json",
    favoriteEmoteSet = {},
    favoriteAnimationSet = {},
    emotePageCache = { version = nil, normal = {}, favorites = {} },
    animationPageCache = { version = nil, normal = {}, favorites = {} },
    suppressSearch = false,
    emoteMonitorToken = 0,
    animationMonitorToken = 0,
    imageUpdateToken = 0,
    defaultButtonImage = "rbxassetid://71408678974152",
    enabledButtonImage = "rbxassetid://106798555684020",
    favoriteIconId = "rbxassetid://97307461910825",
    notFavoriteIconId = "rbxassetid://124025954365505",
    toolEquipped = false,
    EmoteTheme = nil,
    isApplyingTheme = false,
    targetImages = {},
    AnimationCachePath = "7yd7/AnimationCache.json",
    AnimationCache = {},
    AnimationListCachePath = "7yd7/AnimationListCache.json",
    EmoteListCachePath = "7yd7/EmoteListCache.json",
    CustomAnimationPath = "7yd7/CustomAnimations.json",
    CustomAnimations = {},
    currentCustomAnimationName = "Default",
    customAnimationEditorActive = false,
    customAnimationEditingKey = nil,
    customAnimationEditingName = nil,
    EmotePagePath = "7yd7/EmotePages.json",
    EmotePages = {},
    currentEmotePageName = "Default",
    EmoteDataCachePath = "7yd7/EmoteDataCache.json"
}

Config = {
    NotifyEnabled = true,
    SearchVisible = true,
    FavVisible = true,
    ModeVisible = true,
    FreezeVisible = true,
    SpeedVisible = true,
    NavVisible = true,
    EmoteSpeed = 1,
    EmoteSpeedEnabled = false,
    SelectedTheme = "Default",
    EmotePage = 1,
    AnimationPage = 1,
    RandomEnabled = true,
    RandomMode = "All",
    AuthenticFirstPage = false,
    HUDPositions = {},
    HUDSizes = {},
    HUDProperties = {},
    CustomFrames = {},
    AutoReloadEnabled = false,
    LastPlayedAnimationData = nil,
    DiscordVisible = true
}

HUD = {
    Connections = {},
    IsUnlocked = false,
    DefaultPositions = {},
    DefaultSizes = {},
    DefaultTexts = {},
    DefaultPlaceholders = {},
    Layouts = {},
    LayoutsRemoved = {},
    SelectionGui = nil,
    SelectedElement = nil,
    ResizeHandles = {},
    ResizeConnections = {},
    FriendlyNames = {
        ["Under.1left"] = "PrevPage",
        ["Under.9right"] = "NextPage",
        ["Under.4pages"] = "TotalPages",
        ["Under.3TextLabel"] = "Divider",
        ["Under.2Route-number"] = "CurrentPage",
        ["Top.Search"] = "Search",
        ["EmoteWalkButton"] = "Freeze",
        ["Favorite"] = "Favorite",
        ["SpeedEmote"] = "SpeedEmote",
        ["SpeedBox"] = "SpeedBox",
        ["Changepage"] = "ChangePage",
        ["Reload"] = "AutoReload",
        ["Top"] = "Top",
        ["Under"] = "Under"
    }
}

local DEFAULT_IDLE_ICON_ID = "rbxassetid://106798555684020"
local DEFAULT_IDLE_ICON_COLOR = Color3.fromRGB(0, 255, 150)

function DeepCopy(original)
    if type(original) ~= "table" then return original end
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            v = DeepCopy(v)
        end
        copy[k] = v
    end
    return copy
end

function ColorToTable(color)
    return {color.R, color.G, color.B}
end

function TableToColor(tbl)
    if not tbl or type(tbl) ~= "table" or #tbl < 3 then return Color3.new(1,1,1) end
    return Color3.new(tbl[1], tbl[2], tbl[3])
end

function loadAnimationCache()
    if isfile and isfile(State.AnimationCachePath) then
        local success, decoded = pcall(function()
            return HttpService:JSONDecode(readfile(State.AnimationCachePath))
        end)
        if success and type(decoded) == "table" then
            State.AnimationCache = decoded
        end
    end
end

function saveAnimationCache()
    if writefile then
        pcall(function()
            if not isfolder("7yd7") then makefolder("7yd7") end
            writefile(State.AnimationCachePath, HttpService:JSONEncode(State.AnimationCache))
        end)
    end
end

function resolveAnimationMappings(bundledItems)
    local mappings = {}
    for _, assetIds in pairs(bundledItems) do
        for _, assetId in pairs(assetIds) do
            local success, objects = pcall(function()
                return game:GetObjects("rbxassetid://" .. assetId)
            end)
            if success and objects then
                local function searchTree(parent, parentPath)
                    for _, child in pairs(parent:GetChildren()) do
                        if child:IsA("Animation") then
                            local animationPath = parentPath .. "." .. child.Name
                            local pathParts = animationPath:split(".")
                            local weightVals = {}
                            for _, wChild in ipairs(child:GetChildren()) do
                                if wChild:IsA("NumberValue") and wChild.Name == "Weight" then
                                    table.insert(weightVals, wChild.Value)
                                end
                            end
                            table.insert(mappings, {
                                category = pathParts[#pathParts - 1],
                                name = pathParts[#pathParts],
                                animationId = child.AnimationId,
                                weights = weightVals
                            })
                        elseif #child:GetChildren() > 0 then
                            searchTree(child, parentPath .. "." .. child.Name)
                        end
                    end
                end
                for _, obj in pairs(objects) do
                    searchTree(obj, obj.Name)
                    obj.Parent = workspace
                    task.delay(1, function()
                        if obj then obj:Destroy() end
                    end)
                end
            end
        end
    end
    return mappings
end

function buildCustomSetMappings(setName)
    if type(setName) == "string" then
        setName = setName:gsub("%s*%-.*$", "")
    end
    local set = State.CustomAnimations and State.CustomAnimations.Sets and State.CustomAnimations.Sets[setName]
    if not set then return {} end
    local mappings = {}
    for cat, anims in pairs(set) do
        if cat ~= "__meta" then
            for name, id in pairs(anims) do
                if tostring(id) ~= "0" then
                    table.insert(mappings, {category = cat, name = name, animationId = "rbxassetid://" .. id})
                end
            end
        end
    end
    return mappings
end



loadAnimationCache()


local UI = {
    CustomFrames = {},
    Under = nil, 
    _1left = nil, 
    _9right = nil, 
    _4pages = nil, 
    _3TextLabel = nil, 
    _2Routenumber = nil, 
    Top = nil, 
    EmoteWalkButton = nil,
    Search = nil, 
    Favorite = nil, 
    SpeedEmote = nil, 
    SpeedBox = nil, 
    Changepage = nil,
    Reload = nil,
    Background = nil
}

local HUD = { 
    Connections = {},
    Strokes = {},
    ResizeHandles = {},
    ResizeConnections = {},
    UndoStack = {},
    SelectedElement = nil,
    Overlay = nil,
    IsUnlocked = false,
    ForceVisibleConn = nil,
    Layouts = {},
    LayoutsRemoved = {},
    FriendlyNames = {
        ["Under.1left"] = "Left Arrow",
        ["Under.9right"] = "Right Arrow",
        ["Under.4pages"] = "Total Pages",
        ["Under.3TextLabel"] = "Separator Label",
        ["Under.2Route-number"] = "Page Number Box",
        ["Top.Search"] = "Search/ID Box",
    },
    DefaultPositions = {
        Top = UDim2.new(0.127499998, 0, -0.109999999, 0),
        Under = UDim2.new(0.129999995, 0, 1, 0),
        EmoteWalkButton = UDim2.new(0.889999986, 0, -0.107500002, 0),
        Favorite = UDim2.new(0.0189999994, 0, -0.108000003, 0),
        SpeedEmote = UDim2.new(0.888999999, 0, 0, 0),
        SpeedBox = UDim2.new(0.0189999398, 0, -0.000499992399, 0),
        Changepage = UDim2.new(0.019, 0, 1.021, 0),
        Reload = UDim2.new(0.888999999, 0, 1.02100003, 0),
        ["Left Arrow"] = UDim2.new(0, 0, 0.028, 0),
        ["Right Arrow"] = UDim2.new(0.169, 0, 0.028, 0),
        ["Total Pages"] = UDim2.new(0.339, 0, 0.094, 0), 
        ["Separator Label"] = UDim2.new(0.498, 0, 0.028, 0),
        ["Page Number Box"] = UDim2.new(0.837, 0, 0.094, 0),
        ["Search/ID Box"] = UDim2.new(0.01, 0, 0.092, 0),
    },
    DefaultSizes = {
        Top = UDim2.new(0.737500012, 0, 0.0949999914, 0),
        Under = UDim2.new(0.737500012, 0, 0.132499993, 0),
        EmoteWalkButton = UDim2.new(0.0874999985, 0, 0.0874999985, 0),
        Favorite = UDim2.new(0.0874999985, 0, 0.0874999985, 0),
        SpeedEmote = UDim2.new(0.0874999985, 0, 0.0874999985, 0),
        SpeedBox = UDim2.new(0.0874999985, 0, 0.0874999985, 0),
        Changepage = UDim2.new(0.087, 0, 0.087, 0),
        Reload = UDim2.new(0.0869999975, 0, 0.0869999975, 0),
        ["Left Arrow"] = UDim2.new(0.169491529, 0, 0.94339627, 0),
        ["Right Arrow"] = UDim2.new(0.169491529, 0, 0.94339627, 0),
        ["Total Pages"] = UDim2.new(0.159322038, 0, 0.811320841, 0),
        ["Separator Label"] = UDim2.new(0.338983059, 0, 0.94339627, 0),
        ["Page Number Box"] = UDim2.new(0.159322038, 0, 0.811320841, 0),
        ["Search/ID Box"] = UDim2.new(0.864406765, 0, 0.81578958, 0),
    },
    DefaultTexts = {
        ["Left Arrow"] = "",
        ["Right Arrow"] = "",
        ["Total Pages"] = "1",
        ["Separator Label"] = " ------ ",
        ["Page Number Box"] = "1",
        ["Search/ID Box"] = "",
        ["SpeedBox"] = "1",
    },
    DefaultPlaceholders = {
        ["Search/ID Box"] = "Search/ID",
    }
}

function getAllHUDObjects()
    local elems = {}
    if UI.Top then elems["Top"] = UI.Top end
    if UI.Under then elems["Under"] = UI.Under end
    if UI.EmoteWalkButton then elems["EmoteWalkButton"] = UI.EmoteWalkButton end
    if UI.Favorite then elems["Favorite"] = UI.Favorite end
    if UI.SpeedEmote then elems["SpeedEmote"] = UI.SpeedEmote end
    if UI.SpeedBox then elems["SpeedBox"] = UI.SpeedBox end
    if UI.Changepage then elems["Changepage"] = UI.Changepage end
    if UI.Reload then elems["Reload"] = UI.Reload end
    if UI.CustomFrames then
        for n, f in pairs(UI.CustomFrames) do
            elems[n] = f
        end
    end

    if UI.Top then
        for _, child in pairs(UI.Top:GetChildren()) do
            if child:IsA("GuiObject") and not child:IsA("UIListLayout") and not child:IsA("UICorner") then
                local internalName = "Top." .. child.Name
                elems[HUD.FriendlyNames[internalName] or internalName] = child
            end
        end
    end
    if UI.Under then
        for _, child in pairs(UI.Under:GetChildren()) do
            if child:IsA("GuiObject") and not child:IsA("UIListLayout") and not child:IsA("UICorner") then
                local internalName = "Under." .. child.Name
                elems[HUD.FriendlyNames[internalName] or internalName] = child
            end
        end
    end
    return elems
end

function getMovableElements()
    local all = getAllHUDObjects()
    local movable = {}
    
    for name, el in pairs(all) do
        local isChild = false
        for _, friendly in pairs(HUD.FriendlyNames) do 
            if name == friendly then isChild = true; break end 
        end
        
        if not isChild or HUD.IsUnlocked then
            movable[name] = el
        end
    end
    return movable
end

function ColorToTable(c) return {math.round(c.R*255), math.round(c.G*255), math.round(c.B*255)} end
function TableToColor(t)
    if type(t) ~= "table" then
        return Color3.fromRGB(255, 255, 255)
    end
    local r = tonumber(t[1]) or 255
    local g = tonumber(t[2]) or 255
    local b = tonumber(t[3]) or 255
    return Color3.fromRGB(r, g, b)
end

local function isThemeDefaultRGB(r, g, b)
    return r == 28 and g == 30 and b == 32
end

local AnimationSystem = {
    Cache = {},
    currentThemeName = "Default"
}   

AnimationSystem.LooksLikeGif = function(url)
    if not url then return false end
    url = string.lower(tostring(url))
    return url:find(".gif") or url:find("gif") or url:find("format=gif") or url:find("image/gif")
end

AnimationSystem.NormalizeUrl = function(url)
    if not url or url == "" then return url end
    local targetUrl = tostring(url)
    
    targetUrl = targetUrl:gsub("%?raw=true", "")
    
    if targetUrl:find("github%.com/") and not targetUrl:find("raw.githubusercontent%.com") then
        targetUrl = targetUrl:gsub("github%.com/", "raw.githubusercontent.com/")
        targetUrl = targetUrl:gsub("/blob/", "/")
        targetUrl = targetUrl:gsub("/raw/", "/")
    end
    
    if targetUrl:find(" ") and not targetUrl:find("%%20") then
        targetUrl = targetUrl:gsub(" ", "%%20")
    end
    
    if not targetUrl:find("://") then
        local id = targetUrl:match("id=(%d+)") or targetUrl:match("^(%d+)$")
        if id then return "rbxassetid://" .. id end
    end
    return targetUrl
end

AnimationSystem.ParseGifInfo = function(bytes)
    if not bytes or #bytes < 13 then return nil end
    if bytes:sub(1, 3) ~= "GIF" then return nil end
    local function u16le(pos)
        local b1 = bytes:byte(pos) or 0
        local b2 = bytes:byte(pos + 1) or 0
        return b1 + b2 * 256
    end
    local width = u16le(7)
    local height = u16le(9)
    local packed = bytes:byte(11) or 0
    local gctFlag = bit32.band(packed, 0x80) ~= 0
    local gctSize = bit32.band(packed, 0x07)
    local offset = 13
    if gctFlag then
        offset = offset + (3 * (2 ^ (gctSize + 1)))
    end

    local frames = 0
    local delays = {}
    local pendingDelay = nil

    local function skipSubBlocks(pos)
        while pos <= #bytes do
            local size = bytes:byte(pos) or 0
            pos = pos + 1
            if size == 0 then break end
            pos = pos + size
        end
        return pos
    end

    while offset <= #bytes do
        local b = bytes:byte(offset)
        if not b then break end
        if b == 0x3B then
            break
        elseif b == 0x21 then
            local label = bytes:byte(offset + 1) or 0
            if label == 0xF9 then
                local delay = u16le(offset + 4)
                pendingDelay = delay
                offset = offset + 8
            else
                offset = skipSubBlocks(offset + 2)
            end
        elseif b == 0x2C then
            frames = frames + 1
            if pendingDelay then
                table.insert(delays, pendingDelay)
                pendingDelay = nil
            end
            local packedImg = bytes:byte(offset + 9) or 0
            local lctFlag = bit32.band(packedImg, 0x80) ~= 0
            local lctSize = bit32.band(packedImg, 0x07)
            offset = offset + 10
            if lctFlag then
                offset = offset + (3 * (2 ^ (lctSize + 1)))
            end
            offset = offset + 1
            offset = skipSubBlocks(offset)
        else
            offset = offset + 1
        end
    end

    local totalDelay = 0
    for _, d in ipairs(delays) do totalDelay = totalDelay + d end
    local avgDelay = (#delays > 0) and (totalDelay / #delays) or 10

    return {
        width = width,
        height = height,
        frames = frames > 0 and frames or #delays,
        totalDelayCs = totalDelay,
        avgDelayCs = avgDelay
    }
end

AnimationSystem.ParsePngInfo = function(bytes)
    if not bytes or #bytes < 24 then return nil end
    if bytes:sub(1, 8) ~= "\137PNG\r\n\26\n" then return nil end
    local function u32be(pos)
        local b1 = bytes:byte(pos) or 0
        local b2 = bytes:byte(pos + 1) or 0
        local b3 = bytes:byte(pos + 2) or 0
        local b4 = bytes:byte(pos + 3) or 0
        return ((b1 * 256 + b2) * 256 + b3) * 256 + b4
    end
    local width = u32be(17)
    local height = u32be(21)
    if width <= 0 or height <= 0 then return nil end
    return { width = width, height = height }
end

AnimationSystem.StopGif = function()
    if State.currentWheelAnimToken then
        State.currentWheelAnimToken = State.currentWheelAnimToken + 1
    end
end

AnimationSystem.SetImageMode = function(img, custom)
    if not img then return end
    if custom then
        img.ScaleType = Enum.ScaleType.Stretch
        img.SliceCenter = Rect.new(0, 0, 0, 0)
        img.SliceScale = 1
    else
        img.ScaleType = Enum.ScaleType.Fit
    end
end

AnimationSystem.StartGif = function(img, data)
    AnimationSystem.StopGif()
    if not img or not data or not data.sprite then return end
    
    State.currentWheelAnimToken = (State.currentWheelAnimToken or 0) + 1
    local token = State.currentWheelAnimToken
    
    local frames = data.frames or 1
    local frameW = data.frameW or 0
    local frameH = data.frameH or 0
    local cols = data.cols or 1
    local rows = data.rows or 1
    local delay = data.delay or 0.1
    if delay <= 0 then delay = 0.1 end
    local sheetW = data.sheetW or (cols * frameW)
    local sheetH = data.sheetH or (rows * frameH)
    
    img.Image = data.sprite
    img.ImageRectSize = Vector2.new(frameW, frameH)
    img.ImageRectOffset = Vector2.new(0, 0)
    task.spawn(function()
        pcall(function() ContentProvider:PreloadAsync({img}) end)
    end)
    
    local current = 0
    local acc = 0
    local connection
    connection = RunService.Heartbeat:Connect(function(dt)
        if token ~= State.currentWheelAnimToken then
            connection:Disconnect()
            return
        end
        if not img or not img.Parent then
            connection:Disconnect()
            return
        end
        acc = acc + dt
        if acc < delay then return end
        while acc >= delay do
            acc = acc - delay
            current = (current + 1) % frames
        end
        local col = current % cols
        local row = math.floor(current / cols)
        local offsetX = math.min(col * frameW, math.max(0, sheetW - frameW))
        local offsetY = math.min(row * frameH, math.max(0, sheetH - frameH))
        img.ImageRectOffset = Vector2.new(offsetX, offsetY)
    end)
end

AnimationSystem.AreMetaEqual = function(a, b)
    if not a or not b then return a == b end
    return a.GifUrl == b.GifUrl and a.SheetUrl == b.SheetUrl and a.Enabled == b.Enabled
end

AnimationSystem.MakeKey = function(gif, sheet)
    return tostring(gif) .. "|" .. tostring(sheet)
end

function ApplyFreezeButtonVisual()
    if not UI.EmoteWalkButton then return end
    UI.EmoteWalkButton.Image = State.emotesWalkEnabled and State.enabledButtonImage or State.defaultButtonImage
end

AnimationSystem.GetIconColor = function(key)
    if themes and themes[AnimationSystem.currentThemeName] then
        local theme = themes[AnimationSystem.currentThemeName]
        if theme.IconColors and theme.IconColors[key] then
            return TableToColor(theme.IconColors[key])
        end
        return TableToColor(theme.ImageColor or {255, 255, 255})
    elseif State.EmoteTheme then
        local theme = State.EmoteTheme
        if theme.IconColors and theme.IconColors[key] then
            return TableToColor(theme.IconColors[key])
        end
        return theme.ImageColor or Color3.new(1, 1, 1)
    end
    return Color3.fromRGB(255, 255, 255)
end

AnimationSystem.ResetRandomSlot = function(frontFrame)
    if not frontFrame then return end
    local slot = frontFrame:FindFirstChild("1")
    if slot and slot:IsA("ImageLabel") then
        slot.ImageColor3 = Color3.fromRGB(255, 255, 255)
        slot.Image = ""
        local idValue = slot:FindFirstChild("AnimationID")
        if idValue then idValue:Destroy() end
    end
end

function SafeLoad(url, name)
    local success, content
    for i = 1, 3 do
        success, content = pcall(function() return game:HttpGet(url) end)
        if success and content and content ~= "" then break end
        task.wait(0.5)
    end
    
    if not success or not content or content == "" then
        getgenv().Notify({
            Title = '7yd7 | Error',
            Content = 'Failed to download ' .. (name or "script") .. ' after 3 attempts.',
            Duration = 5
        })
        return function() end
    end

    local func, err = loadstring(content)
    if not func then
        warn("7yd7 | SafeLoad: Failed to parse " .. (name or "script") .. ": " .. tostring(err))
        return function() end
    end

    local ok, res = pcall(func)
    if not ok then
        warn("7yd7 | SafeLoad: Error executing " .. (name or "script") .. ": " .. tostring(res))
        return function() end
    end
    return res
end

SafeLoad("https://raw.githubusercontent.com/7yd7/Menu-7yd7/refs/heads/Script/GUIS/Off-site/Notify.lua", "Notify System")

local function getAssetCustom(filePath)
    if not filePath or filePath == "" then return nil end
    local customFn = getcustomasset or getsynasset
    if customFn then
        local ok, res = pcall(customFn, filePath)
        if ok and res and res ~= "" then
            return res
        end
    end
    return nil
end

local function fetchBinary(url)
    if not url or url == "" then return nil end
    local targetUrl = AnimationSystem.NormalizeUrl(url)
    
    if request then
        local ok, res = pcall(function()
            return request({
                Url = targetUrl,
                Method = "GET",
                Headers = {
                    ["User-Agent"] = "Roblox/WinInet"
                }
            })
        end)
        if ok and res and (res.StatusCode == 200 or res.Status == 200) and res.Body and #res.Body > 0 then
            local low = res.Body:sub(1, 100):lower()
            if not (low:find("<!doctype") or low:find("<html") or low:find("<head")) then
                return res.Body
            end
        end
    end

    local ok, body = pcall(function()
        return game:HttpGet(targetUrl)
    end)
    if ok and body and #body > 0 then
        local low = body:sub(1, 100):lower()
        if not (low:find("<!doctype") or low:find("<html") or low:find("<head")) then
            return body
        end
    end
    return nil
end

function GetAsset(asset, preloadedBytes)
    if not asset or asset == "" then return "" end
    local assetStr = tostring(asset)
    
    _G.AssetCache = _G.AssetCache or {}
    if _G.AssetCache[assetStr] then return _G.AssetCache[assetStr] end

    if not assetStr:find("://") and tonumber(assetStr) then
        local id = "rbxassetid://" .. assetStr
        _G.AssetCache[assetStr] = id
        return id
    end
    
    if assetStr:find("rbxassetid://") or assetStr:find("rbxasset://") or assetStr:find("rbxthumb://") then
        return assetStr
    end
    
    if assetStr:find("http") then
        local targetUrl = AnimationSystem.NormalizeUrl(assetStr)

        local filename = targetUrl:match("([^/]+)$") or "asset.png"
        filename = filename:match("([^%?]+)") or filename
        
        filename = filename:gsub("[%c%*%?%\"%<%>%|]", "_")
        
        if filename:lower():find("%.gif$") then
            filename = filename:gsub("%.[gG][iI][fF]$", ".png")
        end
        if not filename:find("%.") then filename = filename .. ".png" end
        
        local path = "7yd7/Assets/" .. filename
        
        if isfile and isfile(path) then
            local res = getAssetCustom(path)
            if res and res ~= "" then
                _G.AssetCache[assetStr] = res
                return res
            end
        end

        if not isfolder("7yd7/Assets") then 
            pcall(function()
                if not isfolder("7yd7") then makefolder("7yd7") end
                makefolder("7yd7/Assets") 
            end)
        end
        
        local content = preloadedBytes or fetchBinary(targetUrl)
        if content and #content > 0 then
            pcall(function() writefile(path, content) end)
            
            for attempt = 1, 4 do
                local res = getAssetCustom(path)
                if res and res ~= "" then
                    _G.AssetCache[assetStr] = res
                    return res
                end
                task.wait(0.08)
            end
        end
    end
    
    return assetStr
end

local function estimateRobloxResizedSize(origW, origH)
    if origW <= 0 or origH <= 0 then return origW, origH end
    local longest = math.max(origW, origH)
    local scale = 1
    if longest > 1024 then
        scale = 1024 / longest
    end
    return origW * scale, origH * scale
end

local function getExactImageSize(asset)
    local AssetService = game:GetService("AssetService")
    local ok, editImage = pcall(function()
        return AssetService:CreateEditableImageAsync(asset)
    end)
    if ok and editImage then
        local w = editImage.Size.X
        local h = editImage.Size.Y
        editImage:Destroy()
        if w > 0 and h > 0 then
            return w, h
        end
    end
    return nil
end

local DEFAULT_WHEEL_BG = "rbxasset://textures/ui/Emotes/Large/SegmentedCircle.png"
local RANDOM_SLOT_ICON = "rbxassetid://109283577128136"
local RANDOM_SLOT_COLOR = Color3.fromRGB(188, 188, 188)
local DEFAULT_IDLE_ICON_ID = "98513150727403"
local DEFAULT_IDLE_ICON_COLOR = Color3.fromRGB(188, 188, 188)
local wheelImgState = setmetatable({}, { __mode = "k" })
local checkEmotesMenuExists
local playEmote
local playRandomEmote
local handleSectorAction
local calculateTotalPages
local updatePageDisplay
local updateEmotes
local isInFavorites
local toggleFavorite
local toggleFavoriteAnimation
local refreshCustomAnimationState
local findCustomAnimationDataByName
local applyAnimation

local ConfigPath = "7yd7/EmoteSettings.json"

function updateHUDLayouts()
    if not Config then return end
    local function toggleLayout(parent, unlocked)
        if not parent then return end
        local key = parent.Name
        local l = parent:FindFirstChildOfClass("UIListLayout") or HUD.Layouts[key]
        
        if l then
            HUD.Layouts[key] = l
            
            local hasCustomP = false
            for _, child in pairs(parent:GetChildren()) do
                if child:IsA("GuiObject") then
                    local internalName = key .. "." .. child.Name
                    local friendly = HUD.FriendlyNames[internalName] or internalName
                    if Config.HUDPositions and Config.HUDPositions[friendly] then
                        hasCustomP = true
                        break
                    end
                end
            end

            if HUD.IsUnlocked then
                l.Parent = nil
            elseif hasCustomP or (HUD.LayoutsRemoved and HUD.LayoutsRemoved[key]) then
                l.Parent = nil 
            else
                l.Parent = parent
            end
        end
    end
    
    toggleLayout(UI.Top, HUD.IsUnlocked)
    toggleLayout(UI.Under, HUD.IsUnlocked)
end

function applySavedPositions() end 
local enterHUDEditor, exitHUDEditor

local function updateSpeedBoxVisibility()
    if not UI.SpeedBox then return end
    if State.hudEditorActive then
        UI.SpeedBox.Visible = Config.SpeedVisible
    else
        UI.SpeedBox.Visible = (Config.SpeedVisible and State.speedEmoteEnabled)
    end
end

function ApplyUIVisibility()
    pcall(function()
        if UI.Search and UI.Top then UI.Top.Visible = Config.SearchVisible end
        if UI.Favorite then UI.Favorite.Visible = Config.FavVisible end
        if UI.Changepage then UI.Changepage.Visible = Config.ModeVisible end
        if UI.EmoteWalkButton then UI.EmoteWalkButton.Visible = Config.FreezeVisible end
        if UI.SpeedEmote then UI.SpeedEmote.Visible = Config.SpeedVisible end
        updateSpeedBoxVisibility()
        if UI.Under then UI.Under.Visible = Config.NavVisible end
        if UI.Reload then 
            if State.hudEditorActive then
                UI.Reload.Visible = true
            else
                UI.Reload.Visible = (State.currentMode == "animation" and Config.NavVisible) 
            end
        end
    end)
end

function SaveConfig()
    if not isfolder("7yd7") then makefolder("7yd7") end
    writefile(ConfigPath, HttpService:JSONEncode(Config))
end

function LoadConfig()
    if isfile(ConfigPath) then
        local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(ConfigPath)) end)
        if success and type(decoded) == "table" then
            for k, v in pairs(decoded) do Config[k] = v end
        end
    end
    getgenv().autoReloadEnabled = Config.AutoReloadEnabled or false
    getgenv().lastPlayedAnimation = Config.LastPlayedAnimationData
end
LoadConfig()

local rawNotify = getgenv().Notify
getgenv().Notify = function(data)
    if Config.NotifyEnabled then
        rawNotify(data)
    end
end

local SettingsLib = SafeLoad("https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Settings.lua", "Settings Library")

local ToggleContainer = Instance.new("Frame")
ToggleContainer.Name = "open/Close"
ToggleContainer.Parent = SettingsLib.UI
ToggleContainer.BackgroundTransparency = 1
ToggleContainer.Size = UDim2.fromScale(1, 1)
ToggleContainer.ZIndex = 5000
ToggleContainer.Visible = false
ToggleContainer.Active = false
ToggleContainer.Selectable = false

local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "ToggleSettings"
ToggleBtn.Parent = ToggleContainer
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleBtn.BackgroundTransparency = 0.4
ToggleBtn.Position = UDim2.new(0, 10, 1, -52)
ToggleBtn.Size = UDim2.fromOffset(42, 42)
ToggleBtn.Image = "rbxassetid://79568054778195"

local DiscordBtn = Instance.new("ImageButton")
DiscordBtn.Name = "DiscordButton"
DiscordBtn.Parent = ToggleContainer
DiscordBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DiscordBtn.BackgroundTransparency = 0.4
DiscordBtn.Position = UDim2.new(0, 57, 1, -52)
DiscordBtn.Size = UDim2.fromOffset(42, 42)
DiscordBtn.Image = "rbxassetid://98681818461563"

local DiscordCorner = Instance.new("UICorner")
DiscordCorner.CornerRadius = UDim.new(0, 10)
DiscordCorner.Parent = DiscordBtn

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleBtn

function getSettingsMainFrame()
    if SettingsLib and SettingsLib.UI then
        return SettingsLib.UI:FindFirstChild("MainFrame")
    end
    return nil
end

function applySettingsToggleStyle()
    local main = getSettingsMainFrame()
    local bgColor
    if main then
        bgColor = main.BackgroundColor3
    elseif State.EmoteTheme and State.EmoteTheme.Background then
        bgColor = State.EmoteTheme.Background
    end

    if bgColor then
        ToggleBtn.BackgroundColor3 = bgColor
        DiscordBtn.BackgroundColor3 = bgColor
    end
end

function syncToggleVisibility()
    local main = getSettingsMainFrame()
    if main then
        ToggleContainer.Visible = not main.Visible
    else
        ToggleContainer.Visible = true
    end
end

function syncDiscordVisibility()
    DiscordBtn.Visible = Config.DiscordVisible
end

DiscordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/kRfzv2kV7X")
    getgenv().Notify({Title = "Discord", Content = "The Discord invite has been copied", Duration = 3})
end)

ToggleBtn.MouseButton1Click:Connect(function()
    local main = getSettingsMainFrame()
    if main then
        main.Visible = not main.Visible
        syncToggleVisibility()
    else
        SettingsLib.UI.Enabled = not SettingsLib.UI.Enabled
    end
end)

applySettingsToggleStyle()
syncToggleVisibility()
syncDiscordVisibility()

do
    local main = getSettingsMainFrame()
    if main then
        main:GetPropertyChangedSignal("Visible"):Connect(syncToggleVisibility)
    end
end

local TogglesUI = {}
local GeneralTab = SettingsLib.CreateTab("General", 1)
TogglesUI.NotifyEnabled = SettingsLib.AddToggle(GeneralTab, "Show Notifications", "Receive alerts and feedback", Config.NotifyEnabled, function(v)
    Config.NotifyEnabled = v
    SaveConfig()
end)

TogglesUI.AuthenticFirstPage = SettingsLib.AddToggle(GeneralTab, "Authentic Emotes Page", "Show owned emotes on page 1", Config.AuthenticFirstPage, function(v)
    Config.AuthenticFirstPage = v
    State.totalPages = calculateTotalPages()
    if State.currentPage > State.totalPages then
        State.currentPage = State.totalPages
    end
    updatePageDisplay()
    updateEmotes()
    SaveConfig()
end)

local randomModes = { "All", "Favorites" }
local randomDropdown = SettingsLib.AddDropdown(GeneralTab, "Random Source", randomModes, Config.RandomMode or "All", function(v)
    Config.RandomMode = v
    SaveConfig()
end)
if randomDropdown and randomDropdown.Button then
    randomDropdown.Button.Text = (Config.RandomMode or "All") .. "  ▼"
end

TogglesUI.RandomEnabled = SettingsLib.AddToggle(GeneralTab, "Random Enabled", "Enable/disable random", Config.RandomEnabled, function(v)
    Config.RandomEnabled = v
    if not v then
        pcall(function()
            local frontFrame = game:GetService("CoreGui").RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Front.EmotesButtons
            local slot1 = frontFrame and frontFrame:FindFirstChild("1")
            local slot2 = frontFrame and frontFrame:FindFirstChild("2")
            if slot1 and slot1:IsA("ImageLabel") and slot2 and slot2:IsA("ImageLabel") then
                local img2 = slot2.Image
                if img2 and img2 ~= "" then
                    slot1.Image = img2
                end
            end
        end)
    end
    State.totalPages = calculateTotalPages()
    if State.currentPage > State.totalPages then
        State.currentPage = State.totalPages
    end
    updatePageDisplay()
    updateEmotes()
    SaveConfig()
end)

local CleanFavItem = SettingsLib.AddItem(GeneralTab, "Clean Deleted Favorites", "Scan all favorites (emotes + animations) and remove any that were deleted (click twice)")
CleanFavItem.LayoutOrder = 10
local CleanFavBtn = SettingsLib:Create("TextButton", {
    Parent = CleanFavItem,
    BackgroundColor3 = Color3.fromRGB(220, 60, 60),
    Position = UDim2.new(1, -90, 0.5, -12),
    Size = UDim2.new(0, 80, 0, 24),
    Font = Enum.Font.GothamBold,
    Text = "CLEAN",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 11
}, { SettingsLib:Create("UICorner", {CornerRadius = UDim.new(0, 6)}) })

local cleanFavConfirm = false
local cleanFavConfirmConn = nil
local cleanFavCleaning = false

local function resetCleanButton()
    cleanFavConfirm = false
    if cleanFavConfirmConn then
        pcall(function() cleanFavConfirmConn:Cancel() end)
        cleanFavConfirmConn = nil
    end
    if CleanFavBtn and CleanFavBtn.Parent then
        CleanFavBtn.Text = "CLEAN"
        CleanFavBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    end
end

local cleanDeletedFavorites

cleanDeletedFavorites = function()
    if cleanFavCleaning then return end
    cleanFavCleaning = true

    local emoteIds = {}
    local animIds = {}

    local emotePages = (State.EmotePages and State.EmotePages.Sets) or {}
    for _, favList in pairs(emotePages) do
        if type(favList) == "table" then
            for _, fav in ipairs(favList) do
                if fav and fav.id and tonumber(fav.id) and tonumber(fav.id) > 0 then
                    emoteIds[tostring(fav.id)] = true
                end
            end
        end
    end

    for _, fav in ipairs(State.favoriteAnimations or {}) do
        if fav and fav.id and not fav.isCustomSet and tonumber(fav.id) and tonumber(fav.id) > 0 then
            animIds[tostring(fav.id)] = true
        end
    end

    local emoteIdList = {}
    for id in pairs(emoteIds) do table.insert(emoteIdList, id) end
    local animIdList = {}
    for id in pairs(animIds) do table.insert(animIdList, id) end

    local totalChecks = #emoteIdList + #animIdList
    if totalChecks == 0 then
        getgenv().Notify({ Title = "7yd7 | Clean", Content = "No favorites to check!", Duration = 3 })
        cleanFavCleaning = false
        resetCleanButton()
        return
    end

    getgenv().Notify({ Title = "7yd7 | Clean", Content = "Checking " .. totalChecks .. " favorites...", Duration = 3 })

    local deletedEmotes = {}
    local deletedAnims = {}
    local checked = 0

    local function updateProgress()
        if CleanFavBtn and CleanFavBtn.Parent then
            CleanFavBtn.Text = math.floor((checked / totalChecks) * 100) .. "%"
        end
    end

    local function checkBatch(ids, isBundle, deletedOut)
        local url
        if isBundle then
            url = "https://thumbnails.roblox.com/v1/bundles/thumbnails?bundleIds=" .. table.concat(ids, ",") .. "&size=420x420&format=Png"
        else
            url = "https://thumbnails.roblox.com/v1/assets?assetIds=" .. table.concat(ids, ",") .. "&size=420x420&format=Png"
        end
        local body = fetchBinary(url)
        local parsed = nil
        if body and #body > 0 then
            pcall(function()
                parsed = HttpService:JSONDecode(body)
            end)
        end
        if parsed and parsed.data and type(parsed.data) == "table" then
            for _, entry in ipairs(parsed.data) do
                local targetId = tostring(entry.targetId)
                if entry.state == "Blocked" or entry.state == "Error" or not entry.imageUrl or entry.imageUrl == "" then
                    deletedOut[targetId] = true
                end
            end
        end
        task.wait(0.05)
    end

    local BATCH = 50
    for i = 1, #emoteIdList, BATCH do
        local chunk = {}
        for j = i, math.min(i + BATCH - 1, #emoteIdList) do table.insert(chunk, emoteIdList[j]) end
        checkBatch(chunk, false, deletedEmotes)
        checked = checked + #chunk
        updateProgress()
    end
    for i = 1, #animIdList, BATCH do
        local chunk = {}
        for j = i, math.min(i + BATCH - 1, #animIdList) do table.insert(chunk, animIdList[j]) end
        checkBatch(chunk, true, deletedAnims)
        checked = checked + #chunk
        updateProgress()
    end

    local removedEmotes = 0
    for pageName, favList in pairs(emotePages) do
        if type(favList) == "table" then
            local newList = {}
            for _, fav in ipairs(favList) do
                if fav and fav.id and deletedEmotes[tostring(fav.id)] then
                    removedEmotes = removedEmotes + 1
                else
                    table.insert(newList, fav)
                end
            end
            State.EmotePages.Sets[pageName] = newList
        end
    end

    local removedAnims = 0
    local newAnims = {}
    for _, fav in ipairs(State.favoriteAnimations or {}) do
        if fav and fav.id and not fav.isCustomSet and deletedAnims[tostring(fav.id)] then
            removedAnims = removedAnims + 1
        else
            table.insert(newAnims, fav)
        end
    end
    State.favoriteAnimations = newAnims

    State.favoriteEmotes = DeepCopy(State.EmotePages.Sets[State.currentEmotePageName] or {}) or {}
    State.favoriteEmoteSet = {}
    for _, fav in pairs(State.favoriteEmotes) do
        State.favoriteEmoteSet[tostring(fav.id)] = true
    end
    State.favoriteAnimationSet = {}
    for _, fav in pairs(State.favoriteAnimations) do
        State.favoriteAnimationSet[tostring(fav.id)] = true
    end
    State.favoriteSetVersion = State.favoriteSetVersion + 1

    State.SaveEmotePages(State.EmotePages)
    pcall(function()
        if not isfolder("7yd7") then makefolder("7yd7") end
        writefile(State.favoriteAnimationsFileName, HttpService:JSONEncode(State.favoriteAnimations))
    end)

    _G.filteredFavoritesForDisplay = nil
    _G.filteredFavoritesAnimationsForDisplay = nil

    State.totalPages = calculateTotalPages()
    if State.currentPage > State.totalPages then
        State.currentPage = State.totalPages
    end
    updatePageDisplay()
    if State.currentMode == "animation" then
        updateAnimations()
    else
        updateEmotes()
    end
    updateAllFavoriteIcons()

    for _, fav in pairs(State.favoriteEmotes) do
        if fav and fav.id then
            preloadThumbnail("rbxthumb://type=Asset&id=" .. tostring(fav.id) .. "&w=420&h=420")
        end
    end
    for _, fav in pairs(State.favoriteAnimations) do
        if fav and fav.id and not fav.isCustomSet then
            preloadThumbnail("rbxthumb://type=BundleThumbnail&id=" .. tostring(fav.id) .. "&w=420&h=420")
        end
    end

    local cleanUpToken = State.imageUpdateToken
    task.delay(0.35, function()
        if State.imageUpdateToken ~= cleanUpToken then return end
        updatePageDisplay()
        if State.currentMode == "animation" then
            updateAnimations()
        else
            updateEmotes()
        end
        updateAllFavoriteIcons()
    end)

    getgenv().Notify({
        Title = "7yd7 | Cleaned",
        Content = "Removed " .. removedEmotes .. " deleted emote" .. (removedEmotes == 1 and "" or "s") .. " & " .. removedAnims .. " deleted animation" .. (removedAnims == 1 and "" or "s"),
        Duration = 5
    })
    cleanFavCleaning = false
    resetCleanButton()
end

CleanFavBtn.MouseButton1Click:Connect(function()
    if cleanFavCleaning then return end
    if not cleanFavConfirm then
        cleanFavConfirm = true
        CleanFavBtn.Text = "CONFIRM?"
        CleanFavBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 30)
        if cleanFavConfirmConn then
            pcall(function() cleanFavConfirmConn:Cancel() end)
        end
        cleanFavConfirmConn = task.delay(3, resetCleanButton)
        return
    end
    resetCleanButton()
    CleanFavBtn.Text = "0%"
    CleanFavBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
    task.spawn(cleanDeletedFavorites)
end)

local ButtonsTab = SettingsLib.CreateTab("Buttons", 2)

TogglesUI.SearchVisible = SettingsLib.AddToggle(ButtonsTab, "Search Bar", "Show/Hide the search input", Config.SearchVisible, function(v)
    Config.SearchVisible = v
    ApplyUIVisibility()
    SaveConfig()
end)

TogglesUI.FavVisible = SettingsLib.AddToggle(ButtonsTab, "Favorites Button", "Show/Hide the star button", Config.FavVisible, function(v)
    Config.FavVisible = v
    ApplyUIVisibility()
    SaveConfig()
end)

TogglesUI.ModeVisible = SettingsLib.AddToggle(ButtonsTab, "Mode Switcher", "Show/Hide animation mode button", Config.ModeVisible, function(v)
    Config.ModeVisible = v
    ApplyUIVisibility()
    SaveConfig()
end)

TogglesUI.FreezeVisible = SettingsLib.AddToggle(ButtonsTab, "Freeze Button", "Show/Hide emote freeze button", Config.FreezeVisible, function(v)
    Config.FreezeVisible = v
    ApplyUIVisibility()
    SaveConfig()
end)

TogglesUI.SpeedVisible = SettingsLib.AddToggle(ButtonsTab, "Speed Button", "Show/Hide the speed controller", Config.SpeedVisible, function(v)
    Config.SpeedVisible = v
    ApplyUIVisibility()
    SaveConfig()
end)

TogglesUI.NavVisible = SettingsLib.AddToggle(ButtonsTab, "Page Controls", "Show/Hide navigation buttons", Config.NavVisible, function(v)
    Config.NavVisible = v
    ApplyUIVisibility()
    SaveConfig()
end)

TogglesUI.DiscordVisible = SettingsLib.AddToggle(ButtonsTab, "Discord Button", "Show/Hide the discord link button", Config.DiscordVisible, function(v)
    Config.DiscordVisible = v
    syncDiscordVisibility()
    SaveConfig()
end)

local cachedOverlay = nil
local hudEditorItem = SettingsLib.AddItem(ButtonsTab, "HUD Editor", "Reposition buttons & UI elements")
hudEditorItem.LayoutOrder = -10
local hudEditorBtn = SettingsLib:Create("TextButton", {
    Parent = hudEditorItem,
    BackgroundColor3 = Color3.fromRGB(0, 255, 150),
    Position = UDim2.new(1, -80, 0.5, -12),
    Size = UDim2.new(0, 70, 0, 24),
    Font = Enum.Font.GothamBold,
    Text = "EDIT",
    TextColor3 = Color3.fromRGB(24, 25, 28),
    TextSize = 11
}, { SettingsLib:Create("UICorner", {CornerRadius = UDim.new(0, 6)}) })

hudEditorBtn.MouseButton1Click:Connect(function()
    if enterHUDEditor then enterHUDEditor() end
end)
function getBackgroundOverlay()
    if cachedOverlay and cachedOverlay.Parent then return cachedOverlay end
    
    local success, result = pcall(function()
        return game:GetService("CoreGui").RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Back.Background
                   .BackgroundCircleOverlay
    end)
    if success and result then
        cachedOverlay = result
        return result
    end
    return nil
end

function DeepCopy(t)
    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            copy[k] = DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

local ApplyFavoriteButtonVisual
function updateGUIColors()
    local backgroundOverlay = getBackgroundOverlay()
    if not backgroundOverlay then
        return
    end

    local theme = State.EmoteTheme
    if not theme then return end
    
    local bgColor = theme.Background
    local accentColor = theme.Accent
    local imgColor = theme.ImageColor
    local bgTransparency = backgroundOverlay.BackgroundTransparency

    local function getIconColor(key)
        if theme.IconColors and theme.IconColors[key] then
            return TableToColor(theme.IconColors[key])
        end
        return imgColor
    end

    if UI._1left then
        UI._1left.ImageColor3 = getIconColor("Left")
        UI._1left.ImageTransparency = bgTransparency
        UI._1left.BackgroundTransparency = 1 
    end

    if UI._9right then
        UI._9right.ImageColor3 = getIconColor("Right")
        UI._9right.ImageTransparency = bgTransparency
        UI._9right.BackgroundTransparency = 1
    end

    if UI._4pages then
        UI._4pages.TextColor3 = bgColor 
        UI._4pages.TextTransparency = bgTransparency
    end

    if UI._3TextLabel then
        UI._3TextLabel.TextColor3 = bgColor
        UI._3TextLabel.TextTransparency = bgTransparency
    end

    if UI._2Routenumber then
        UI._2Routenumber.TextColor3 = bgColor
        UI._2Routenumber.PlaceholderColor3 = bgColor
        UI._2Routenumber.TextTransparency = bgTransparency
    end

    if UI.Under then
        UI.Under.BackgroundTransparency = 1
    end

    if UI.Top then
        UI.Top.BackgroundColor3 = bgColor
        UI.Top.BackgroundTransparency = bgTransparency
    end

    if UI.EmoteWalkButton then
        UI.EmoteWalkButton.BackgroundColor3 = bgColor
        UI.EmoteWalkButton.BackgroundTransparency = bgTransparency
    end

    if UI.CustomFrames then
        for _, frame in pairs(UI.CustomFrames) do
            frame.BackgroundColor3 = bgColor
            frame.BackgroundTransparency = bgTransparency
        end
    end

    if UI.SpeedEmote then
        UI.SpeedEmote.BackgroundColor3 = bgColor
        UI.SpeedEmote.BackgroundTransparency = bgTransparency
    end

     if UI.Changepage then
        UI.Changepage.BackgroundColor3 = bgColor
        UI.Changepage.BackgroundTransparency = bgTransparency
    end

    if UI.SpeedBox then
        UI.SpeedBox.BackgroundColor3 = bgColor
        UI.SpeedBox.BackgroundTransparency = bgTransparency
    end

    if UI.Favorite then
        UI.Favorite.BackgroundColor3 = bgColor
        UI.Favorite.BackgroundTransparency = bgTransparency
    end

    if UI.Reload then
        UI.Reload.BackgroundColor3 = bgColor
        UI.Reload.BackgroundTransparency = bgTransparency
    end
    
    if ApplyFavoriteButtonVisual then
        ApplyFavoriteButtonVisual()
    end

    local function applyHUDProperties()
        if not Config.HUDProperties then return end
        local allMovable = getAllHUDObjects()
        for name, uiExt in pairs(allMovable) do
            local props = Config.HUDProperties[name]
            if props then
                if props.ZIndex ~= nil then pcall(function() uiExt.ZIndex = props.ZIndex end) end
                if props.BgTrans ~= nil then pcall(function() uiExt.BackgroundTransparency = props.BgTrans end) end
                if props.ImgTrans ~= nil and (uiExt:IsA("ImageLabel") or uiExt:IsA("ImageButton")) then pcall(function() uiExt.ImageTransparency = props.ImgTrans end) end
                if props.BgColor and type(props.BgColor) == "table" then
                    local r, g, b = props.BgColor[1], props.BgColor[2], props.BgColor[3]
                    if r and g and b and not isThemeDefaultRGB(r, g, b) then
                        pcall(function() uiExt.BackgroundColor3 = Color3.fromRGB(r, g, b) end)
                    end
                end
                if props.ImgColor and type(props.ImgColor) == "table" and (uiExt:IsA("ImageLabel") or uiExt:IsA("ImageButton")) then
                    local r, g, b = props.ImgColor[1], props.ImgColor[2], props.ImgColor[3]
                    if r and g and b and not isThemeDefaultRGB(r, g, b) then
                        pcall(function() uiExt.ImageColor3 = Color3.fromRGB(r, g, b) end)
                    end
                end
                if props.TxtColor and type(props.TxtColor) == "table" and (uiExt:IsA("TextLabel") or uiExt:IsA("TextBox")) then
                    local r, g, b = props.TxtColor[1], props.TxtColor[2], props.TxtColor[3]
                    if r and g and b and not isThemeDefaultRGB(r, g, b) then
                        pcall(function() uiExt.TextColor3 = Color3.fromRGB(r, g, b) end)
                    end
                end
                if props.Radius and uiExt:FindFirstChildWhichIsA("UICorner") then
                    local s1, o1 = props.Radius:match("{%s*([%d%.%-]+)%s*,%s*([%d%.%-]+)%s*}")
                    if s1 then pcall(function() uiExt:FindFirstChildWhichIsA("UICorner").CornerRadius = UDim.new(tonumber(s1), tonumber(o1)) end) end
                end
            end
        end
    end
    
    applyHUDProperties()
    ApplyUIVisibility()
    applySettingsToggleStyle()
end

ApplyFavoriteButtonVisual = function()
    if not UI.Favorite then return end
    local isOn = State.favoriteEnabled
    local image = isOn and State.favoriteIconId or State.notFavoriteIconId
    if image and image ~= "" then
        UI.Favorite.Image = image
    end
    local colorKey = isOn and "Favorite" or "NotFavorite"
    UI.Favorite.ImageColor3 = AnimationSystem.GetIconColor(colorKey)
end

-- Optimizing performance: Removed RenderStepped loop
-- game:GetService("RunService").RenderStepped:Connect(function()
--     updateGUIColors()
-- end)

local ThemeTab = SettingsLib.CreateTab("Theme", 3)

local DiscordPromo = SettingsLib.AddItem(ThemeTab, "WANT THEMES?", "Join our Discord for themes!")
DiscordPromo.LayoutOrder = -1

local CopyBtn = SettingsLib:Create("TextButton", {
    Parent = DiscordPromo,
    BackgroundColor3 = Color3.fromRGB(0, 255, 150),
    Position = UDim2.new(1, -95, 0.5, -12),
    Size = UDim2.new(0, 85, 0, 24),
    Font = Enum.Font.GothamBold,
    Text = "COPY LINK",
    TextColor3 = Color3.fromRGB(24, 25, 28),
    TextSize = 11
}, { SettingsLib:Create("UICorner", {CornerRadius = UDim.new(0, 6)}) })

CopyBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/kRfzv2kV7X")
    getgenv().Notify({Title = "Discord", Content = "Link copied to clipboard!", Duration = 3})
end)

local ThemeConfigPath = "7yd7/EmoteThemes.json"

local lastSaveTime = 0
local saveDebounce = 1
local pendingSave = false

function SaveThemesImplementation(themes)
    if not isfolder("7yd7") then makefolder("7yd7") end
    local toSave = { Themes = {}, Order = {}, Selected = themes.Selected or AnimationSystem.currentThemeName }
    
    toSave.Order = themes.Order or {}
    
    for name, data in pairs(themes) do
        if name ~= "Default" and name ~= "Order" and name ~= "Selected" then
            toSave.Themes[name] = data
        end
    end
    writefile(ThemeConfigPath, HttpService:JSONEncode(toSave))
end

function SaveThemes(themes)
    if pendingSave then 
        pendingSave = "queued"
        return 
    end
    pendingSave = true
    task.delay(0.5, function()
        SaveThemesImplementation(themes)
        local wasQueued = pendingSave == "queued"
        pendingSave = false
        if wasQueued then
            SaveThemes(themes)
        end
    end)
end

function LoadThemes()
    local defaultTheme = {
        Background = {28, 30, 32},
        Accent = {0, 255, 150},
        ImageColor = {255, 255, 255},
        IconColors = {
            Left = {0, 0, 0},
            Right = {0, 0, 0}
        },
        Icons = {
            Left = "93111945058621",
            Right = "107938916240738",
            Walk = "71408678974152",
            Favorite = "97307461910825",
            NotFavorite = "124025954365505",
            Speed = "116056570415896",
            Page = "13285615740",
            Reload = "127493377027615"
        },
        Wheel = {
            BackgroundImage = "rbxasset://textures/ui/Emotes/Large/SegmentedCircle.png",
            BackgroundImageColor = {255, 255, 255},
            SelectionGradient = "rbxasset://textures/ui/Emotes/Large/SelectedGradient.png",
            SelectionGradientColor = {255, 255, 255},
            SelectionLine = "rbxasset://textures/ui/Emotes/Large/SelectedLine.png",
            SelectionLineColor = {255, 255, 255}
        }
    }
    
    local loaded = { Default = defaultTheme, Order = {"Default"} }
    
    if isfile(ThemeConfigPath) then
        local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(ThemeConfigPath)) end)
        if success and type(decoded) == "table" then
            local themesTable = decoded.Themes or decoded 
            local orderTable = decoded.Order or {}
            
            for name, data in pairs(themesTable) do
                if not data.Icons then data.Icons = DeepCopy(defaultTheme.Icons) end
                if not data.Wheel then data.Wheel = DeepCopy(defaultTheme.Wheel) end
                loaded[name] = data
                
                if name == "Default" then
                    if not data.IconColors then data.IconColors = {} end
                    data.IconColors.Left = {0, 0, 0}
                    data.IconColors.Right = {0, 0, 0}
                end

                if not decoded.Order and name ~= "Default" then
                    table.insert(loaded.Order, name)
                end
            end
            
            if decoded.Order then
                loaded.Order = {"Default"}
                for _, name in ipairs(decoded.Order) do
                    if name ~= "Default" and loaded[name] then
                        table.insert(loaded.Order, name)
                    end
                end
            end
            
            if decoded.Selected and loaded[decoded.Selected] then
                loaded.Selected = decoded.Selected
            end
            
            return loaded
        end
    end
    return loaded
end

State.pendingCustomAnimSave = false
State.SaveCustomAnimationsImplementation = function(animData)
    if not isfolder("7yd7") then makefolder("7yd7") end
    local toSave = { Sets = {}, Order = animData.Order or {"Default"}, Selected = animData.Selected or "Default" }
    for name, data in pairs(animData.Sets) do
        if name ~= "Default" then
            toSave.Sets[name] = data
        end
    end
    writefile(State.CustomAnimationPath, HttpService:JSONEncode(toSave))
end

State.SaveCustomAnimations = function(animData)
    if State.pendingCustomAnimSave then
        State.pendingCustomAnimSave = "queued"
        return
    end
    State.pendingCustomAnimSave = true
    task.delay(0.5, function()
        State.SaveCustomAnimationsImplementation(animData)
        local wasQueued = State.pendingCustomAnimSave == "queued"
        State.pendingCustomAnimSave = false
        if wasQueued then State.SaveCustomAnimations(animData) end
    end)
end

State.LoadCustomAnimations = function()
    local defaultAnim = {
        idle = { Animation1 = 0, Animation2 = 0 },
        walk = { WalkAnim = 0 },
        run = { RunAnim = 0 },
        jump = { JumpAnim = 0 },
        fall = { FallAnim = 0 },
        climb = { ClimbAnim = 0 },
        swimidle = { SwimIdle = 0 },
        swim = { Swim = 0 },
        __meta = { IconImage = DEFAULT_IDLE_ICON_ID, IconColor = ColorToTable(DEFAULT_IDLE_ICON_COLOR) }
    }
    local loaded = { Sets = { Default = defaultAnim }, Order = {"Default"}, Selected = "Default" }
    
    if isfile(State.CustomAnimationPath) then
        local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(State.CustomAnimationPath)) end)
        if success and type(decoded) == "table" then
            local setsTable = decoded.Sets or {}
            for name, data in pairs(setsTable) do
                loaded.Sets[name] = data
            end
            
            if decoded.Order then
                loaded.Order = {"Default"}
                for _, name in ipairs(decoded.Order) do
                    if name ~= "Default" and loaded.Sets[name] then
                        table.insert(loaded.Order, name)
                    end
                end
            end
            
            if decoded.Selected and loaded.Sets[decoded.Selected] then
                loaded.Selected = decoded.Selected
            end
        end
    end
    
    return loaded
end

State.SaveEmotePages = function(pageData)
    if not isfolder("7yd7") then makefolder("7yd7") end
    local toSave = { 
        Sets = {}, 
        Order = pageData.Order or {"Default"}, 
        Selected = pageData.Selected or "Default" 
    }
    for name, data in pairs(pageData.Sets) do
        if name ~= "Default" then
            toSave.Sets[name] = data
        end
    end
    writefile(State.EmotePagePath, HttpService:JSONEncode(toSave))
    
    if pageData.Sets["Default"] then
        writefile(State.favoriteFileName, HttpService:JSONEncode(pageData.Sets["Default"]))
    end
end

function SwitchEmotePage(pageName)
    if not State.EmotePages.Sets[pageName] then return end
    
    State.currentEmotePageName = pageName
    State.EmotePages.Selected = pageName
    
    local pageData = State.EmotePages.Sets[pageName]
    State.favoriteEmotes = DeepCopy(pageData) or {}
    
    State.favoriteEmoteSet = {}
    for _, fav in pairs(State.favoriteEmotes) do
        State.favoriteEmoteSet[tostring(fav.id)] = true
    end
    
    State.favoriteSetVersion = State.favoriteSetVersion + 1
    State.totalPages = calculateTotalPages()
    if State.currentPage > State.totalPages then
        State.currentPage = State.totalPages
    end
    
    updatePageDisplay()
    if State.currentMode == "emote" then
        updateEmotes()
    end
    updateAllFavoriteIcons()
end

State.LoadEmotePages = function()
    local defaultFavorites = {}
    
    if isfile(State.favoriteFileName) then
        local ok, decoded = pcall(function() return HttpService:JSONDecode(readfile(State.favoriteFileName)) end)
        if ok and type(decoded) == "table" then
            defaultFavorites = decoded
        end
    end

    local loaded = { Sets = { Default = defaultFavorites }, Order = {"Default"}, Selected = "Default" }
    
    if isfile(State.EmotePagePath) then
        local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(State.EmotePagePath)) end)
        if success and type(decoded) == "table" then
            local setsTable = decoded.Sets or {}
            for name, data in pairs(setsTable) do
                if name ~= "Default" then
                    loaded.Sets[name] = data
                end
            end
            
            if decoded.Order then
                loaded.Order = {"Default"}
                for _, name in ipairs(decoded.Order) do
                    if name ~= "Default" and loaded.Sets[name] then
                        table.insert(loaded.Order, name)
                    end
                end
            end
            
            if decoded.Selected and (loaded.Sets[decoded.Selected] or decoded.Selected == "Default") then
                loaded.Selected = decoded.Selected
            end
        end
    end
    
    return loaded
end

State.EmotePages = State.LoadEmotePages()
State.currentEmotePageName = State.EmotePages.Selected or "Default"
if not State.EmotePages.Sets[State.currentEmotePageName] then 
    State.currentEmotePageName = "Default" 
end

State.favoriteEmotes = DeepCopy(State.EmotePages.Sets[State.currentEmotePageName]) or {}
State.favoriteEmoteSet = {}
for _, fav in pairs(State.favoriteEmotes) do
    State.favoriteEmoteSet[tostring(fav.id)] = true
end

State.favoriteAnimations = {}
pcall(function()
    if isfile and isfile(State.favoriteAnimationsFileName) then
        local json = readfile(State.favoriteAnimationsFileName)
        local decoded = HttpService:JSONDecode(json)
        if type(decoded) == "table" then
            State.favoriteAnimations = decoded
        end
    end
end)
State.favoriteAnimationSet = {}
for _, fav in pairs(State.favoriteAnimations) do
    State.favoriteAnimationSet[tostring(fav.id)] = true
end


State.CustomAnimations = State.LoadCustomAnimations()
State.currentCustomAnimationName = State.CustomAnimations.Selected or "Default"
if not State.CustomAnimations.Sets[State.currentCustomAnimationName] then 
    State.currentCustomAnimationName = "Default" 
end

local themes = LoadThemes()
local currentThemeName = Config.SelectedTheme or themes.Selected or "Default"
if not themes[currentThemeName] then currentThemeName = "Default" end

local themeDropdown

function GetNames()
    local n = {}
    if themes.Order then
        for _, name in ipairs(themes.Order) do
            if name ~= "Order" and name ~= "Selected" and themes[name] then 
                table.insert(n, name) 
            end
        end
    end
    for name, _ in pairs(themes) do
        if name ~= "Order" and name ~= "Selected" and not table.find(n, name) then
            table.insert(n, name)
        end
    end
    return n
end

local UIElements = {
    Background = {},
    Accent = {},
    ImageColor = {},
    Icons = {},
    Wheel = {}
}

function ApplyWheelBackgroundImage(bgImg, wheel)
    if not bgImg or not wheel then return end
    local bgSrc = wheel.BackgroundImage or ""
    local isCustomBg = tostring(bgSrc) ~= DEFAULT_WHEEL_BG

    local gifUrl, sheetUrl = nil, nil
    if bgSrc and tostring(bgSrc):find("\n") then
        local lines = {}
        for line in tostring(bgSrc):gmatch("[^\r\n]+") do
            line = line:match("^%s*(.-)%s*$")
            if line ~= "" then table.insert(lines, line) end
        end
        gifUrl = lines[1]
        sheetUrl = lines[2]
    elseif tostring(bgSrc):find("|") then
        local parts = {}
        for part in tostring(bgSrc):gmatch("[^|]+") do
            part = part:match("^%s*(.-)%s*$")
            if part ~= "" then table.insert(parts, part) end
        end
        gifUrl = parts[1]
        sheetUrl = parts[2]
    elseif AnimationSystem.LooksLikeGif(bgSrc) then
        gifUrl = bgSrc
    end
 
    local targetUrl = AnimationSystem.NormalizeUrl(bgSrc)
    if gifUrl then gifUrl = AnimationSystem.NormalizeUrl(gifUrl) end
    if sheetUrl then sheetUrl = AnimationSystem.NormalizeUrl(sheetUrl) end
 
    if gifUrl and sheetUrl and sheetUrl ~= "" then
        if gifUrl:lower():find("%.png") and (sheetUrl:lower():find("%.gif") or sheetUrl:lower():find("format=gif")) then
            local temp = gifUrl
            gifUrl = sheetUrl
            sheetUrl = temp
        end

        local cacheKey = AnimationSystem.MakeKey(gifUrl, sheetUrl)
        local meta = wheel.Animation
        if meta and meta.GifUrl == gifUrl and meta.SheetUrl == sheetUrl then
            AnimationSystem.Cache[cacheKey] = meta
        else
            meta = AnimationSystem.Cache[cacheKey]
        end
 
        if meta and meta.Enabled == true then
            if (meta.FrameWidth or 0) > 0 and (meta.FrameHeight or 0) > 0 then
                local frames = tonumber(meta.Frames) or 0
                local cols = tonumber(meta.Cols) or 0
                local rows = tonumber(meta.Rows) or 0
                local frameW = tonumber(meta.FrameWidth) or 0
                local frameH = tonumber(meta.FrameHeight) or 0
                local fps = tonumber(meta.FPS) or 10
                local delay = fps > 0 and (1 / fps) or 0.1
                local rawSheetW = tonumber(meta.SheetWidth) or (cols * frameW)
                local rawSheetH = tonumber(meta.SheetHeight) or (rows * frameH)
                local sheetAsset = GetAsset(sheetUrl)
                if sheetAsset and sheetAsset ~= "" and not sheetAsset:find("^https?://") then
                    local resizedW, resizedH = estimateRobloxResizedSize(rawSheetW, rawSheetH)
                    local adjFrameW = frameW * (resizedW / rawSheetW)
                    local adjFrameH = frameH * (resizedH / rawSheetH)

                    local spriteData = {
                        sprite = sheetAsset,
                        frames = frames,
                        frameW = adjFrameW,
                        frameH = adjFrameH,
                        cols = cols,
                        rows = rows,
                        sheetW = resizedW,
                        sheetH = resizedH,
                        delay = delay
                    }
                    AnimationSystem.SetImageMode(bgImg, true)
                    AnimationSystem.StartGif(bgImg, spriteData)
                    return
                end
            end
        end

        task.spawn(function()
            local gifBytes = fetchBinary(gifUrl)
            local gifInfo = gifBytes and AnimationSystem.ParseGifInfo(gifBytes) or nil

            local sheetBytes = fetchBinary(sheetUrl)
            local sheetInfo = sheetBytes and AnimationSystem.ParsePngInfo(sheetBytes) or nil
            local sheetAsset = GetAsset(sheetUrl, sheetBytes)

            if gifInfo and sheetInfo and sheetAsset and sheetAsset ~= "" and not sheetAsset:find("^https?://") then
                local frameW = gifInfo.width
                local frameH = gifInfo.height
                local cols = math.max(1, math.floor(sheetInfo.width / frameW + 0.0001))
                local rows = math.max(1, math.floor(sheetInfo.height / frameH + 0.0001))
                local maxFrames = cols * rows
                local frames = math.min(gifInfo.frames or maxFrames, maxFrames)
                local fps = (gifInfo.avgDelayCs and gifInfo.avgDelayCs > 0) and (100 / gifInfo.avgDelayCs) or 10

                local resizedW, resizedH = estimateRobloxResizedSize(sheetInfo.width, sheetInfo.height)
                local scaleX = resizedW / sheetInfo.width
                local scaleY = resizedH / sheetInfo.height
                local adjFrameW = frameW * scaleX
                local adjFrameH = frameH * scaleY

                local spriteData = {
                    sprite = sheetAsset,
                    frames = frames,
                    frameW = adjFrameW,
                    frameH = adjFrameH,
                    cols = cols,
                    rows = rows,
                    sheetW = resizedW,
                    sheetH = resizedH,
                    gifInfo = gifInfo
                }

                local newMeta = {
                    Enabled = true,
                    FrameWidth = frameW,
                    FrameHeight = frameH,
                    FPS = math.floor(fps + 0.5),
                    Frames = frames,
                    Cols = cols,
                    Rows = rows,
                    SheetWidth = sheetInfo.width,
                    SheetHeight = sheetInfo.height,
                    GifUrl = gifUrl,
                    SheetUrl = sheetUrl
                }
                wheel.Animation = newMeta
                AnimationSystem.Cache[cacheKey] = newMeta
                if AnimationSystem.currentThemeName and AnimationSystem.currentThemeName ~= "Default" then
                    SaveThemes(themes)
                end

                AnimationSystem.SetImageMode(bgImg, true)
                AnimationSystem.StartGif(bgImg, spriteData)
                return
            else
                AnimationSystem.StopGif()
                AnimationSystem.SetImageMode(bgImg, isCustomBg)
                local fallback = GetAsset(sheetUrl, sheetBytes)
                if fallback and fallback ~= "" and not fallback:find("^https?://") then
                    bgImg.Image = fallback
                else
                    bgImg.Image = DEFAULT_WHEEL_BG
                end
                bgImg.ImageRectSize = Vector2.new(0, 0)
                bgImg.ImageRectOffset = Vector2.new(0, 0)
            end
        end)
        return
    end
 
    AnimationSystem.StopGif()
    AnimationSystem.SetImageMode(bgImg, isCustomBg)
    bgImg.Image = GetAsset(targetUrl)
    bgImg.ImageRectSize = Vector2.new(0, 0)
    bgImg.ImageRectOffset = Vector2.new(0, 0)
end

function ApplyTheme(themeData)
    if State.isApplyingTheme then return end
    if not themeData then
        warn("7yd7 | ApplyTheme: themeData is nil. Falling back to Default.")
        themeData = themes and themes["Default"] or nil
        if not themeData then return end
    end
    
    State.isApplyingTheme = true
    
    local ok, err = pcall(function()
        if themeData.Background then
            State.EmoteTheme = {
                Background = TableToColor(themeData.Background),
                Accent = TableToColor(themeData.Accent or {0, 255, 150}),
                ImageColor = TableToColor(themeData.ImageColor or {255, 255, 255}),
                Icons = themeData.Icons or {},
                IconColors = themeData.IconColors or {},
                Wheel = themeData.Wheel or {}
            }
            
            local function getIconColor(key)
                if State.EmoteTheme.IconColors and State.EmoteTheme.IconColors[key] then
                    return TableToColor(State.EmoteTheme.IconColors[key])
                end
                return State.EmoteTheme.ImageColor 
            end
            
            State.favoriteIconId = GetAsset(State.EmoteTheme.Icons.Favorite)
            State.notFavoriteIconId = GetAsset(State.EmoteTheme.Icons.NotFavorite)
            
            updateGUIColors()
            
            if UI._1left then UI._1left.Image = GetAsset(State.EmoteTheme.Icons.Left); UI._1left.ImageColor3 = getIconColor("Left") end
            if UI._9right then UI._9right.Image = GetAsset(State.EmoteTheme.Icons.Right); UI._9right.ImageColor3 = getIconColor("Right") end
            if UI.EmoteWalkButton then 
                UI.EmoteWalkButton.ImageColor3 = getIconColor("Walk") 
                ApplyFreezeButtonVisual()
            end
            if UI.SpeedEmote then UI.SpeedEmote.Image = GetAsset(State.EmoteTheme.Icons.Speed); UI.SpeedEmote.ImageColor3 = getIconColor("Speed") end
            if UI.Changepage then UI.Changepage.Image = GetAsset(State.EmoteTheme.Icons.Page); UI.Changepage.ImageColor3 = getIconColor("Page") end
            if UI.Reload then UI.Reload.Image = GetAsset(State.EmoteTheme.Icons.Reload); UI.Reload.ImageColor3 = getIconColor("Reload") end
            
            if UI.Favorite then ApplyFavoriteButtonVisual() end 

            
            if UI.Background and UI.Background.Main then UI.Background.Main.SetValue(State.EmoteTheme.Background) end
            
            for key, comp in pairs(UIElements.Icons) do
                local iconVal = State.EmoteTheme.Icons[key] or ""
                local specificColor = State.EmoteTheme.IconColors and State.EmoteTheme.IconColors[key]
                local colorVal
                
                if specificColor then
                    colorVal = TableToColor(specificColor)
                else
                    colorVal = State.EmoteTheme.ImageColor 
                end
                
                if comp then comp.SetValue(iconVal, colorVal) end
            end

            for name, data in pairs(themes) do
                if data == themeData then
                    AnimationSystem.currentThemeName = name
                    break
                end
            end

            local function applyWheel()
                pcall(function()
                    local coreGui = game:GetService("CoreGui")
                    local robloxGui = coreGui:FindFirstChild("RobloxGui")
                    if not robloxGui then return end
                    local emotesMenu = robloxGui:FindFirstChild("EmotesMenu")
                    if not emotesMenu then return end
                    local children = emotesMenu:FindFirstChild("Children")
                    local main = children and children:FindFirstChild("Main")
                    local emotesWheel = main and main:FindFirstChild("EmotesWheel")
                    local back = emotesWheel and emotesWheel:FindFirstChild("Back")
                    local root = back and back:FindFirstChild("Background")
                    if not root then return end
                    
                    local wheel = State.EmoteTheme.Wheel
                    if not wheel then return end

                    local function getAsset(id)
                        return GetAsset(id)
                    end

                    local bgImg = root:FindFirstChild("BackgroundImage")
                    if bgImg then
                        ApplyWheelBackgroundImage(bgImg, wheel)
                        bgImg.ImageColor3 = TableToColor(wheel.BackgroundImageColor or {255,255,255})
                    end

                    local gradContainer = root:FindFirstChild("BackgroundGradient")
                    local selectionGrad = gradContainer and gradContainer:FindFirstChild("SelectionGradient")
                    local grad = selectionGrad and selectionGrad:FindFirstChild("SelectedGradient")
                    if grad then
                        grad.Image = getAsset(wheel.SelectionGradient)
                        grad.ImageColor3 = TableToColor(wheel.SelectionGradientColor or {255,255,255})
                    end

                    local selection = root:FindFirstChild("Selection")
                    local selectionEffect = selection and selection:FindFirstChild("SelectionEffect")
                    local line = selectionEffect and selectionEffect:FindFirstChild("SelectedLine")
                    if line then
                        line.Image = getAsset(wheel.SelectionLine)
                        line.ImageColor3 = TableToColor(wheel.SelectionLineColor or {255,255,255})
                    end
                end)
            end
            applyWheel()

            for key, comp in pairs(UIElements.Wheel) do
                local imgVal = State.EmoteTheme.Wheel[key] or ""
                local colorVal = TableToColor(State.EmoteTheme.Wheel[key.."Color"] or {255, 255, 255})
                if comp then comp.SetValue(imgVal, colorVal) end
            end
        end
    end)
    
    State.isApplyingTheme = false
    
    if not ok then
        warn("7yd7 | ApplyTheme error: " .. tostring(err))
    end
end

checkEmotesMenuExists = function()
    local coreGui = game:GetService("CoreGui")
    local robloxGui = coreGui:FindFirstChild("RobloxGui")
    if not robloxGui then
        return false
    end

    local emotesMenu = robloxGui:FindFirstChild("EmotesMenu")
    if not emotesMenu then
        return false
    end

    local children = emotesMenu:FindFirstChild("Children")
    if not children then
        return false
    end

    local main = children:FindFirstChild("Main")
    if not main then
        return false
    end

    local emotesWheel = main:FindFirstChild("EmotesWheel")
    if not emotesWheel then
        return false
    end

    return true, emotesWheel
end

task.spawn(function()
    local attempts = 0
    while attempts < 30 do
        local exists, emotesWheel = checkEmotesMenuExists()
        if exists and emotesWheel then
            ApplyTheme(themes[currentThemeName])
            
            emotesWheel:GetPropertyChangedSignal("Visible"):Connect(function()
                if emotesWheel.Visible then
                    task.wait(0.05)
                    ApplyTheme(themes[currentThemeName])
                end
            end)
            break
        end
        attempts = attempts + 1
        task.wait(1)
    end
end)

themeDropdown = SettingsLib.AddDropdown(ThemeTab, "Select Theme", GetNames(), currentThemeName, function(v)
    currentThemeName = v
    Config.SelectedTheme = v
    SaveConfig()
    if themes[v] then
        SaveThemes(themes) 
        task.wait(0.1)
        ApplyTheme(themes[v])
    end
end)
if themeDropdown and themeDropdown.Button and themeDropdown.Button.Parent and themeDropdown.Button.Parent.Parent then
   themeDropdown.Button.Parent.Parent.LayoutOrder = 0
end

local BtnItem = SettingsLib.AddItem(ThemeTab, "Theme Management", "Manage your themes")
BtnItem.LayoutOrder = 1 
BtnItem.BackgroundColor3 = Color3.fromRGB(35, 38, 42)
BtnItem.Size = UDim2.new(0.95, 0, 0, 70) 

for _, v in pairs(BtnItem:GetChildren()) do if v.Name == "Title" or v.Name == "Desc" then v:Destroy() end end

local ManagementContainer = Instance.new("Frame")
ManagementContainer.Parent = BtnItem
ManagementContainer.BackgroundTransparency = 1
ManagementContainer.Size = UDim2.new(1, 0, 1, 0)

local Layout = Instance.new("UIListLayout")
Layout.FillDirection = Enum.FillDirection.Horizontal
Layout.Padding = UDim.new(0, 15)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.VerticalAlignment = Enum.VerticalAlignment.Center
Layout.Parent = ManagementContainer

local BtnRow = ManagementContainer 

function CreatePopup(title, size)
    local panel = Instance.new("Frame")
    panel.Size = size or UDim2.fromOffset(280, 140)
    panel.Position = UDim2.fromScale(0.5, 0.5)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.BackgroundColor3 = Color3.fromHex("18191c")
    panel.ZIndex = 2000
    panel.Parent = SettingsLib.UI

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = panel

    local stroke = Instance.new("UIStroke")
    stroke.Parent = panel
    stroke.Color = (State.EmoteTheme and State.EmoteTheme.Accent) or Color3.fromRGB(0, 255, 150)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.5

    local lbl = Instance.new("TextLabel")
    lbl.Parent = panel
    lbl.Size = UDim2.new(1, 0, 0, 35)
    lbl.BackgroundTransparency = 1
    lbl.Text = title:upper()
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextColor3 = Color3.new(1,1,1)
    
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Parent = panel
    content.BackgroundTransparency = 1
    content.Position = UDim2.new(0, 0, 0, 35)
    content.Size = UDim2.new(1, 0, 1, -35)
    
    return panel, content
end

function CreateInput(parent, placeholder, text, isMulti)
    local box = Instance.new("TextBox")
    box.Size = isMulti and UDim2.new(0.9, 0, 0, 100) or UDim2.new(0.9, 0, 0, 35)
    box.Position = UDim2.new(0.05, 0, 0, 5)
    box.BackgroundColor3 = Color3.fromRGB(35, 38, 41)
    box.TextColor3 = Color3.new(1,1,1)
    box.PlaceholderText = placeholder or ""
    box.Text = text or ""
    box.Font = Enum.Font.Gotham
    box.TextSize = 12
    box.MultiLine = isMulti
    box.TextWrapped = isMulti
    box.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = box
    
    return box
end

function CreateButton(parent, text, color, pos, size)
    local btn = Instance.new("TextButton")
    btn.Size = size or UDim2.new(0.4, 0, 0, 32)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = (color.R + color.G + color.B < 1.5) and Color3.new(1,1,1) or Color3.new(0,0,0)
    btn.TextSize = 12
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    return btn
end

SettingsLib.AddIconButton(BtnRow, "108445456753346", function()
    local popup, content = CreatePopup("Create Theme")
    local In = CreateInput(content, "Theme Name...")
    
    local Save = CreateButton(content, "SAVE", (State.EmoteTheme and State.EmoteTheme.Accent) or Color3.fromRGB(0, 255, 150), UDim2.new(0.05, 0, 0.6, 0))
    local Cancel = CreateButton(content, "CANCEL", Color3.fromRGB(50, 50, 50), UDim2.new(0.55, 0, 0.6, 0))
    Cancel.TextColor3 = Color3.new(1,1,1)

    Save.MouseButton1Click:Connect(function()
        if In.Text ~= "" and not themes[In.Text] then
            themes[In.Text] = DeepCopy(themes[currentThemeName])
            if not themes[In.Text].IconColors then themes[In.Text].IconColors = {} end
            table.insert(themes.Order, In.Text)
            
            table.sort(themes.Order, function(a, b)
                if a == "Default" then return true end
                if b == "Default" then return false end
                return a:lower() < b:lower()
            end)
            
            SaveThemes(themes)
            currentThemeName = In.Text
            themeDropdown.Refresh(GetNames())
            themeDropdown.Button.Text = currentThemeName .. "  ▼"
            ApplyTheme(themes[currentThemeName])
            popup:Destroy()
        end
    end)
    
    Cancel.MouseButton1Click:Connect(function() popup:Destroy() end)
end)

SettingsLib.AddIconButton(BtnRow, "71829270056766", function()
    if currentThemeName ~= "Default" then
        local idx = table.find(themes.Order, currentThemeName)
        if idx then table.remove(themes.Order, idx) end
        
        themes[currentThemeName] = nil
        SaveThemes(themes)
        currentThemeName = "Default"
        themeDropdown.Refresh(GetNames())
        themeDropdown.Button.Text = "Default  ▼"
        ApplyTheme(themes["Default"])
    end
end)

SettingsLib.AddIconButton(BtnRow, "117761881427472", function()
    if currentThemeName == "Default" then return end
    
    local popup, content = CreatePopup("Rename Theme")
    local In = CreateInput(content, "New Name...", currentThemeName)
    
    local Save = CreateButton(content, "RENAME", (State.EmoteTheme and State.EmoteTheme.Accent) or Color3.fromRGB(0, 255, 150), UDim2.new(0.05, 0, 0.6, 0))
    local Cancel = CreateButton(content, "CANCEL", Color3.fromRGB(50, 50, 50), UDim2.new(0.55, 0, 0.6, 0))
    Cancel.TextColor3 = Color3.new(1,1,1)

    Save.MouseButton1Click:Connect(function()
        if In.Text ~= "" and not themes[In.Text] then
            local idx = table.find(themes.Order, currentThemeName)
            if idx then themes.Order[idx] = In.Text end
            
            themes[In.Text] = themes[currentThemeName]
            themes[currentThemeName] = nil
            currentThemeName = In.Text
            SaveThemes(themes)
            themeDropdown.Refresh(GetNames())
            themeDropdown.Button.Text = currentThemeName .. "  ▼"
            popup:Destroy()
        end
    end)
    
    Cancel.MouseButton1Click:Connect(function() popup:Destroy() end)
end)

SettingsLib.AddIconButton(BtnRow, "78317476576895", function()
    local popup, content = CreatePopup("Import Theme", UDim2.fromOffset(320, 240))
    local box = CreateInput(content, "Paste Theme JSON here...", "", true)
    box.Size = UDim2.new(0.9, 0, 0, 130)
    
    local imp = CreateButton(content, "IMPORT THEME", (State.EmoteTheme and State.EmoteTheme.Accent) or Color3.fromRGB(0, 255, 150), UDim2.new(0.05, 0, 0.8, 0), UDim2.new(0.9, 0, 0, 35))

    imp.MouseButton1Click:Connect(function()
        local s, d = pcall(function() return HttpService:JSONDecode(box.Text) end)
        if s and type(d) == "table" and d.name then
            if d.name == "Default" then
                getgenv().Notify({Title = "Error", Content = "Cannot overwrite 'Default' theme.", Duration = 3})
                return
            end
            if not themes[d.name] then
                table.insert(themes.Order, d.name)
            end
            themes[d.name] = d.data
            SaveThemes(themes)
            themeDropdown.Refresh(GetNames())
            popup:Destroy()
        else
            getgenv().Notify({Title = "Error", Content = "Invalid JSON Format!", Duration = 3})
        end
    end)
    
    local close = Instance.new("TextButton")
    close.Size = UDim2.fromOffset(24, 24)
    close.Position = UDim2.new(1, -30, 0, 5)
    close.Text = "×"
    close.Font = Enum.Font.GothamBold
    close.TextSize = 20
    close.BackgroundTransparency = 1
    close.TextColor3 = Color3.new(1,1,1)
    close.Parent = popup
    close.MouseButton1Click:Connect(function() popup:Destroy() end)
end)

SettingsLib.AddIconButton(BtnRow, "107588515524752", function()
    local exportData = { name = currentThemeName, data = themes[currentThemeName] }
    local json = HttpService:JSONEncode(exportData)
    
    local popup, content = CreatePopup("Export Theme", UDim2.fromOffset(320, 240))
    local box = CreateInput(content, "", json, true)
    box.Size = UDim2.new(0.9, 0, 0, 130)
    box.TextEditable = false
    
    local copy = CreateButton(content, "COPY TO CLIPBOARD", (State.EmoteTheme and State.EmoteTheme.Accent) or Color3.fromRGB(0, 255, 150), UDim2.new(0.05, 0, 0.8, 0), UDim2.new(0.9, 0, 0, 35))

    copy.MouseButton1Click:Connect(function()
        setclipboard(json)
        copy.Text = "COPIED!"
        task.delay(1, function() copy.Text = "COPY TO CLIPBOARD" end)
    end)
    
    local close = Instance.new("TextButton")
    close.Size = UDim2.fromOffset(24, 24)
    close.Position = UDim2.new(1, -30, 0, 5)
    close.Text = "×"
    close.Font = Enum.Font.GothamBold
    close.TextSize = 20
    close.BackgroundTransparency = 1
    close.TextColor3 = Color3.new(1,1,1)
    close.Parent = popup
    close.MouseButton1Click:Connect(function() popup:Destroy() end)
end)


function SmartUpdate(key, subkey, val)
    if currentThemeName == "Default" then
        getgenv().Notify({Title = "Theme", Content = "Cannot modify Default theme. Create a new one!", Duration = 2})
        return
    end

    if themes[currentThemeName] then
        if not themes[currentThemeName][key] then themes[currentThemeName][key] = {} end
        
        if subkey then
            themes[currentThemeName][key][subkey] = val
        else
            themes[currentThemeName][key] = val
        end
        SaveThemes(themes)
        ApplyTheme(themes[currentThemeName])
    end
end

local WheelFolder = SettingsLib.AddFolder(ThemeTab, "Wheel Settings")
WheelFolder.Parent.LayoutOrder = 1.1

function AddWheelInput(title, wheelKey)
    local initialData = themes["Default"].Wheel[wheelKey]
    local initialColor = TableToColor(themes["Default"].Wheel[wheelKey.."Color"])
    
    local current = (themes[currentThemeName].Wheel and themes[currentThemeName].Wheel[wheelKey]) or initialData
    local currentColor = TableToColor((themes[currentThemeName].Wheel and themes[currentThemeName].Wheel[wheelKey.."Color"]) or themes["Default"].Wheel[wheelKey.."Color"])
    
    local comp = SettingsLib.AddAssetColor(WheelFolder, title, "Asset ID...", current, currentColor, function(text, color)
        if currentThemeName == "Default" then
            getgenv().Notify({Title = "Theme", Content = "Cannot modify Default theme!", Duration = 2})
            return
        end
        
        if themes[currentThemeName] then
            if not themes[currentThemeName].Wheel then themes[currentThemeName].Wheel = {} end
            themes[currentThemeName].Wheel[wheelKey] = text
            themes[currentThemeName].Wheel[wheelKey.."Color"] = ColorToTable(color)
            
            SaveThemes(themes)
            ApplyTheme(themes[currentThemeName])
        end
    end)
    UIElements.Wheel[wheelKey] = comp

    local resetBtn = SettingsLib:Create("ImageButton", {
        Parent = comp.Item,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -120, 0.5, -10),
        Size = UDim2.fromOffset(20, 20),
        Image = "rbxassetid://127493377027615",
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 10
    })
    
    resetBtn.MouseButton1Click:Connect(function()
        if currentThemeName == "Default" then return end
        comp.SetValue(initialData, initialColor)
        if themes[currentThemeName] then
            if not themes[currentThemeName].Wheel then themes[currentThemeName].Wheel = {} end
            themes[currentThemeName].Wheel[wheelKey] = initialData
            themes[currentThemeName].Wheel[wheelKey.."Color"] = ColorToTable(initialColor)
            SaveThemes(themes)
            ApplyTheme(themes[currentThemeName])
        end
    end)
end

AddWheelInput("Wheel Background", "BackgroundImage")
AddWheelInput("Selection Gradient", "SelectionGradient")
AddWheelInput("Selection Line", "SelectionLine")

local BackgroundFolder = SettingsLib.AddFolder(ThemeTab, "Background Settings")
BackgroundFolder.Parent.LayoutOrder = 2
UIElements.Background.Main = SettingsLib.AddColorPicker(BackgroundFolder, "Main Background", TableToColor(themes[currentThemeName].Background), function(c)
    SmartUpdate("Background", nil, ColorToTable(c))
end)

local IconSettingsFolder = SettingsLib.AddFolder(ThemeTab, "Icon Settings")
IconSettingsFolder.Parent.LayoutOrder = 3

function AddAssetInput(title, iconKey)
    local current = (themes[currentThemeName].Icons and themes[currentThemeName].Icons[iconKey]) or ""
    local defaultText = (themes["Default"].Icons and themes["Default"].Icons[iconKey]) or ""
    
    local currentColor = Color3.new(1,1,1)
    if themes[currentThemeName].IconColors and themes[currentThemeName].IconColors[iconKey] then
        currentColor = TableToColor(themes[currentThemeName].IconColors[iconKey])
    elseif themes[currentThemeName].ImageColor then
        currentColor = TableToColor(themes[currentThemeName].ImageColor)
    end
    
    local defaultColor = Color3.new(1,1,1)
    if themes["Default"].IconColors and themes["Default"].IconColors[iconKey] then
        defaultColor = TableToColor(themes["Default"].IconColors[iconKey])
    elseif themes["Default"].ImageColor then
        defaultColor = TableToColor(themes["Default"].ImageColor)
    end
    
    local comp = SettingsLib.AddInputWithColor(IconSettingsFolder, title, "Asset ID...", defaultText, defaultColor, function(text, color)
        local s, err = pcall(function()
            if currentThemeName == "Default" then
                getgenv().Notify({Title = "Theme", Content = "Cannot modify Default theme!", Duration = 2})
                return
            end
            
            if themes[currentThemeName] then
                if not themes[currentThemeName].Icons then themes[currentThemeName].Icons = {} end
                if not themes[currentThemeName].IconColors then themes[currentThemeName].IconColors = {} end
                
                local cTable = ColorToTable(color)
                themes[currentThemeName].Icons[iconKey] = text
                themes[currentThemeName].IconColors[iconKey] = cTable
                
                SaveThemes(themes)
                ApplyTheme(themes[currentThemeName])
            end
        end)
        if not s then
            warn("Theme Save Error: " .. tostring(err))
            getgenv().Notify({Title = "Error", Content = "Failed to save color!", Duration = 3})
        end
    end)
    comp.SetValue(current, currentColor)
    UIElements.Icons[iconKey] = comp
end

AddAssetInput("Left Arrow", "Left")
AddAssetInput("Right Arrow", "Right")
AddAssetInput("Walk Icon", "Walk")
AddAssetInput("Speed Icon", "Speed")
AddAssetInput("Page Icon", "Page")
AddAssetInput("Reload Icon", "Reload")
AddAssetInput("Favorite (Star)", "Favorite")
AddAssetInput("Not Favorite", "NotFavorite")

State.exitCustomAnimationEditor = function()
    if not State.customAnimationEditorActive then return end
    State.customAnimationEditorActive = false
    State.customAnimationEditingKey = nil
    State.customAnimationEditingName = nil

    for _, conn in pairs(State.CustomAnimEditorConnections or {}) do
        pcall(function() conn:Disconnect() end)
    end
    State.CustomAnimEditorConnections = {}

    if State.CustomAnimOverlay and State.CustomAnimOverlay.Parent then 
        State.CustomAnimOverlay:Destroy() 
    end
    State.CustomAnimOverlay = nil

    if State.CustomAnimForceVisibleConn then 
        State.CustomAnimForceVisibleConn:Disconnect()
        State.CustomAnimForceVisibleConn = nil 
    end

    if UI.Search then UI.Search.TextEditable = true; UI.Search.Active = true end
    if UI.SpeedBox then UI.SpeedBox.TextEditable = true; UI.SpeedBox.Active = true end
    if UI._2Routenumber then UI._2Routenumber.TextEditable = true; UI._2Routenumber.Active = true end
    
    pcall(function() game:GetService("GuiService"):SetEmotesMenuOpen(false) end)
    pcall(function() game:GetService("CoreGui").RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Visible = false end)

    local main = getSettingsMainFrame()
    if main then main.Visible = true end
    if syncToggleVisibility then syncToggleVisibility() end

    if State.RefreshCustomAnimUI then State.RefreshCustomAnimUI() end

    if State.currentMode ~= "animation" then
        State.currentMode = "animation"
        State.suppressSearch = true
        if UI.Search then UI.Search.Text = State.animationSearchTerm end
        State.suppressSearch = false
        if State.animationSearchTerm ~= "" and searchAnimations then
            searchAnimations(State.animationSearchTerm)
        end
        State.currentPage = State.savedAnimPage
        State.totalPages = calculateTotalPages()
        updatePageDisplay()
        updateEmotes()
        if updateScriptPriorityOverlay then updateScriptPriorityOverlay() end
        State.animationMonitorToken = State.animationMonitorToken + 1
        local token = State.animationMonitorToken
        State.isMonitoringClicks = true
        if monitorAnimations then
            task.spawn(function() monitorAnimations(token) end)
        end
    end
end

State.enterCustomAnimationEditor = function(category, animName)
    if State.customAnimationEditorActive then return end
    if State.currentCustomAnimationName == "Default" then
        getgenv().Notify({ Title = "7yd7 | Error", Content = "Cannot edit Default Animation set. Create a new one!", Duration = 3 })
        return
    end

    State.customAnimationEditorActive = true
    State.customAnimationEditingKey = category
    State.customAnimationEditingName = animName
    
    if State.currentMode ~= "animation" then
        State.currentMode = "animation"
        State.suppressSearch = true
        if UI.Search then UI.Search.Text = State.animationSearchTerm end
        State.suppressSearch = false
        State.currentPage = State.savedAnimPage
        State.totalPages = calculateTotalPages()
        updatePageDisplay()
        updateEmotes()
        if updateScriptPriorityOverlay then updateScriptPriorityOverlay() end
        State.animationMonitorToken = State.animationMonitorToken + 1
        local token = State.animationMonitorToken
        State.isMonitoringClicks = true
        if monitorAnimations then
            task.spawn(function()
                monitorAnimations(token)
            end)
        end
        
        local beforeVersion = State.animationCacheVersion
        task.spawn(function()
            if fetchAllAnimations then
                fetchAllAnimations()
            else
                return
            end
            if State.currentMode ~= "animation" then return end
            if State.animationCacheVersion ~= beforeVersion then
                State.suppressSearch = true
                if UI.Search then UI.Search.Text = State.animationSearchTerm end
                State.suppressSearch = false
                if State.animationSearchTerm ~= "" and searchAnimations then
                    searchAnimations(State.animationSearchTerm)
                end
                State.currentPage = State.savedAnimPage
                State.totalPages = calculateTotalPages()
                updatePageDisplay()
                updateEmotes()
                if updateScriptPriorityOverlay then updateScriptPriorityOverlay() end
            end
        end)
    end

    GuiService:SetEmotesMenuOpen(false)
    task.wait(0.15)

    local exists, emotesWheel = checkEmotesMenuExists()
    if not exists then State.customAnimationEditorActive = false; return end
    emotesWheel.Visible = true

    State.CustomAnimForceVisibleConn = RunService.Heartbeat:Connect(function()
        if not State.customAnimationEditorActive then return end
        pcall(function()
            local _, ew = checkEmotesMenuExists()
            if ew then ew.Visible = true end
        end)
    end)

    local main = getSettingsMainFrame()
    if main then main.Visible = false end
    if syncToggleVisibility then syncToggleVisibility() end

    local overlay = Instance.new("Frame")
    overlay.Name = "CustomAnimOverlay"
    overlay.Parent = SettingsLib.UI
    overlay.BackgroundTransparency = 1
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.ZIndex = 6000
    overlay.Active = false
    State.CustomAnimOverlay = overlay

    local bc = Instance.new("Frame")
    bc.Parent = overlay
    bc.BackgroundTransparency = 1
    bc.AnchorPoint = Vector2.new(1, 0)
    bc.Position = UDim2.new(1, -10, 0, 10)
    bc.Size = UDim2.fromOffset(42, 42)
    bc.ZIndex = 6000

    local backBtn = Instance.new("ImageButton")
    backBtn.Name = "CustomAnimBackBtn"
    backBtn.Size = UDim2.fromOffset(42, 42)
    backBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    backBtn.BackgroundTransparency = 0.4
    backBtn.Image = "rbxassetid://79024388644722"
    backBtn.ZIndex = 6001
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = backBtn
    
    backBtn.Parent = bc
    
    State.CustomAnimEditorConnections = State.CustomAnimEditorConnections or {}
    table.insert(State.CustomAnimEditorConnections, backBtn.MouseButton1Click:Connect(function()
        State.exitCustomAnimationEditor()
    end))

    if UI._2Routenumber then UI._2Routenumber.TextEditable = false; UI._2Routenumber.Active = false; pcall(function() UI._2Routenumber:ReleaseFocus() end) end

    getgenv().Notify({ Title = "7yd7 | Animation Editor", Content = "🖱️ Select an animation from the wheel to set for " .. animName, Duration = 5 })
end

State.CustomAnimTab = SettingsLib.CreateTab("Animation", 4)
State.CustomAnimDropdown = SettingsLib.AddDropdown(State.CustomAnimTab, "Select Animation", State.CustomAnimations.Order, State.currentCustomAnimationName, function(v)
    State.currentCustomAnimationName = v
    State.CustomAnimations.Selected = v
    State.SaveCustomAnimations(State.CustomAnimations)
    if State.RefreshCustomAnimUI then State.RefreshCustomAnimUI() end
    if State.ApplyCustomAnimIconUI then State.ApplyCustomAnimIconUI() end
    if refreshCustomAnimationState then refreshCustomAnimationState(false) end
end)
if State.CustomAnimDropdown and State.CustomAnimDropdown.Button and State.CustomAnimDropdown.Button.Parent and State.CustomAnimDropdown.Button.Parent.Parent then
   State.CustomAnimDropdown.Button.Parent.Parent.LayoutOrder = 0
end

local CustomAnimBtnItem = SettingsLib.AddItem(State.CustomAnimTab, "Animation Management", "Manage your animations")
CustomAnimBtnItem.LayoutOrder = 1 
CustomAnimBtnItem.BackgroundColor3 = Color3.fromRGB(35, 38, 42)
CustomAnimBtnItem.Size = UDim2.new(0.95, 0, 0, 70) 
for _, v in pairs(CustomAnimBtnItem:GetChildren()) do if v.Name == "Title" or v.Name == "Desc" then v:Destroy() end end

local CustomAnimMgtContainer = Instance.new("Frame")
CustomAnimMgtContainer.Parent = CustomAnimBtnItem
CustomAnimMgtContainer.BackgroundTransparency = 1
CustomAnimMgtContainer.Size = UDim2.new(1, 0, 1, 0)

local CustomAnimLayout = Instance.new("UIListLayout")
CustomAnimLayout.FillDirection = Enum.FillDirection.Horizontal
CustomAnimLayout.Padding = UDim.new(0, 15)
CustomAnimLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
CustomAnimLayout.VerticalAlignment = Enum.VerticalAlignment.Center
CustomAnimLayout.Parent = CustomAnimMgtContainer

function NormalizeCustomAnimationData(animData)
    local defaultAnim = {
        idle = { Animation1 = 0, Animation2 = 0 },
        walk = { WalkAnim = 0 },
        run = { RunAnim = 0 },
        jump = { JumpAnim = 0 },
        fall = { FallAnim = 0 },
        swimidle = { SwimIdle = 0 },
        swim = { Swim = 0 },
        __meta = { IconImage = DEFAULT_IDLE_ICON_ID, IconColor = ColorToTable(DEFAULT_IDLE_ICON_COLOR) }
    }
    
    local result = { Sets = { Default = DeepCopy(defaultAnim) }, Order = {"Default"}, Selected = "Default" }
    if type(animData) ~= "table" then return result end
    
    local setsTable = animData.Sets or animData
    if type(setsTable) == "table" then
        for name, data in pairs(setsTable) do
            if type(data) == "table" then
                if name == "Default" then
                    result.Sets.Default = data
                else
                    result.Sets[name] = data
                end
                data.__meta = data.__meta or {}
                if data.__meta.IconImage == nil then data.__meta.IconImage = DEFAULT_IDLE_ICON_ID end
                if data.__meta.IconColor == nil then data.__meta.IconColor = ColorToTable(DEFAULT_IDLE_ICON_COLOR) end
            end
        end
    end
    
    local order = animData.Order
    if type(order) == "table" then
        for _, name in ipairs(order) do
            if name ~= "Default" and result.Sets[name] then
                table.insert(result.Order, name)
            end
        end
    else
        for name, _ in pairs(result.Sets) do
            if name ~= "Default" then table.insert(result.Order, name) end
        end
    end
    
    local selected = animData.Selected
    if type(selected) == "string" and result.Sets[selected] then
        result.Selected = selected
    end
    
    return result
end

function MakeUniqueSetName(baseSets, desiredName)
    if not baseSets[desiredName] then return desiredName end
    local i = 2
    local candidate = desiredName .. " (Imported)"
    if not baseSets[candidate] then return candidate end
    while true do
        candidate = desiredName .. " (Imported " .. i .. ")"
        if not baseSets[candidate] then return candidate end
        i = i + 1
    end
end

SettingsLib.AddIconButton(CustomAnimMgtContainer, "108445456753346", function()
    local popup, content = CreatePopup("Create Animation")
    local In = CreateInput(content, "Animation Name...")
    
    local Save = CreateButton(content, "SAVE", (State.EmoteTheme and State.EmoteTheme.Accent) or Color3.fromRGB(0, 255, 150), UDim2.new(0.05, 0, 0.6, 0))
    local Cancel = CreateButton(content, "CANCEL", Color3.fromRGB(50, 50, 50), UDim2.new(0.55, 0, 0.6, 0))
    Cancel.TextColor3 = Color3.new(1,1,1)

    Save.MouseButton1Click:Connect(function()
        if In.Text ~= "" and not State.CustomAnimations.Sets[In.Text] then
            local defaultAnim = {
                idle = { Animation1 = 0, Animation2 = 0 },
                walk = { WalkAnim = 0 },
                run = { RunAnim = 0 },
                jump = { JumpAnim = 0 },
                fall = { FallAnim = 0 },
                swimidle = { SwimIdle = 0 },
                swim = { Swim = 0 },
                __meta = { IconImage = DEFAULT_IDLE_ICON_ID, IconColor = ColorToTable(DEFAULT_IDLE_ICON_COLOR) }
            }
            State.CustomAnimations.Sets[In.Text] = defaultAnim
            table.insert(State.CustomAnimations.Order, In.Text)
            
            table.sort(State.CustomAnimations.Order, function(a, b)
                if a == "Default" then return true end
                if b == "Default" then return false end
                return a:lower() < b:lower()
            end)
            
            State.currentCustomAnimationName = In.Text
            State.CustomAnimations.Selected = In.Text
            State.SaveCustomAnimations(State.CustomAnimations)
            if State.CustomAnimDropdown then
                State.CustomAnimDropdown.Refresh(State.CustomAnimations.Order)
                State.CustomAnimDropdown.Button.Text = State.currentCustomAnimationName .. "  ▼"
            end
            if State.RefreshCustomAnimUI then State.RefreshCustomAnimUI() end
            if State.ApplyCustomAnimIconUI then State.ApplyCustomAnimIconUI() end
            if refreshCustomAnimationState then refreshCustomAnimationState(false) end
            popup:Destroy()
        end
    end)
    Cancel.MouseButton1Click:Connect(function() popup:Destroy() end)
end)

SettingsLib.AddIconButton(CustomAnimMgtContainer, "71829270056766", function()
    if State.currentCustomAnimationName ~= "Default" then
        local idx = table.find(State.CustomAnimations.Order, State.currentCustomAnimationName)
        if idx then table.remove(State.CustomAnimations.Order, idx) end
        
        State.CustomAnimations.Sets[State.currentCustomAnimationName] = nil
        State.currentCustomAnimationName = "Default"
        State.CustomAnimations.Selected = "Default"
        State.SaveCustomAnimations(State.CustomAnimations)
        if State.CustomAnimDropdown then
            State.CustomAnimDropdown.Refresh(State.CustomAnimations.Order)
            State.CustomAnimDropdown.Button.Text = "Default  ▼"
        end
        if State.RefreshCustomAnimUI then State.RefreshCustomAnimUI() end
        if State.ApplyCustomAnimIconUI then State.ApplyCustomAnimIconUI() end
        if refreshCustomAnimationState then refreshCustomAnimationState(false) end
    end
end)

SettingsLib.AddIconButton(CustomAnimMgtContainer, "117761881427472", function()
    if State.currentCustomAnimationName == "Default" then return end
    
    local popup, content = CreatePopup("Rename Animation")
    local In = CreateInput(content, "New Name...", State.currentCustomAnimationName)
    
    local Save = CreateButton(content, "RENAME", (State.EmoteTheme and State.EmoteTheme.Accent) or Color3.fromRGB(0, 255, 150), UDim2.new(0.05, 0, 0.6, 0))
    local Cancel = CreateButton(content, "CANCEL", Color3.fromRGB(50, 50, 50), UDim2.new(0.55, 0, 0.6, 0))
    Cancel.TextColor3 = Color3.new(1,1,1)

    Save.MouseButton1Click:Connect(function()
        if In.Text ~= "" and not State.CustomAnimations.Sets[In.Text] then
            local idx = table.find(State.CustomAnimations.Order, State.currentCustomAnimationName)
            if idx then State.CustomAnimations.Order[idx] = In.Text end
            
            State.CustomAnimations.Sets[In.Text] = State.CustomAnimations.Sets[State.currentCustomAnimationName]
            State.CustomAnimations.Sets[State.currentCustomAnimationName] = nil
            State.currentCustomAnimationName = In.Text
            State.CustomAnimations.Selected = In.Text
            State.SaveCustomAnimations(State.CustomAnimations)
            if State.CustomAnimDropdown then
                State.CustomAnimDropdown.Refresh(State.CustomAnimations.Order)
                State.CustomAnimDropdown.Button.Text = State.currentCustomAnimationName .. "  ▼"
            end
            if State.RefreshCustomAnimUI then State.RefreshCustomAnimUI() end
            if State.ApplyCustomAnimIconUI then State.ApplyCustomAnimIconUI() end
            if refreshCustomAnimationState then refreshCustomAnimationState(false) end
            popup:Destroy()
        end
    end)
    Cancel.MouseButton1Click:Connect(function() popup:Destroy() end)
end)

SettingsLib.AddIconButton(CustomAnimMgtContainer, "107588515524752", function()
    local currentSet = State.CustomAnimations.Sets[State.currentCustomAnimationName]
    local data = {
        Type = "CustomAnimationSet",
        Name = State.currentCustomAnimationName,
        Data = currentSet
    }
    local json = HttpService:JSONEncode(data)
    
    local popup, content = CreatePopup("Export Animations", UDim2.fromOffset(320, 240))
    local box = CreateInput(content, "", json, true)
    box.Size = UDim2.new(0.9, 0, 0, 130)
    box.TextEditable = false
    
    local copy = CreateButton(content, "COPY TO CLIPBOARD", (State.EmoteTheme and State.EmoteTheme.Accent) or Color3.fromRGB(0, 255, 150), UDim2.new(0.05, 0, 0.8, 0), UDim2.new(0.9, 0, 0, 35))
    copy.MouseButton1Click:Connect(function()
        setclipboard(json)
        copy.Text = "COPIED!"
        task.delay(1, function() copy.Text = "COPY TO CLIPBOARD" end)
    end)
    
    local close = Instance.new("TextButton")
    close.Size = UDim2.fromOffset(24, 24)
    close.Position = UDim2.new(1, -30, 0, 5)
    close.Text = "X"
    close.Font = Enum.Font.GothamBold
    close.TextSize = 20
    close.BackgroundTransparency = 1
    close.TextColor3 = Color3.new(1,1,1)
    close.Parent = popup
    close.MouseButton1Click:Connect(function() popup:Destroy() end)
end)

SettingsLib.AddIconButton(CustomAnimMgtContainer, "78317476576895", function()
    local popup, content = CreatePopup("Import Animations", UDim2.fromOffset(320, 240))
    local box = CreateInput(content, "Paste Animation JSON here...", "", true)
    box.Size = UDim2.new(0.9, 0, 0, 130)
    
    local imp = CreateButton(content, "IMPORT DATA", (State.EmoteTheme and State.EmoteTheme.Accent) or Color3.fromRGB(0, 255, 150), UDim2.new(0.05, 0, 0.8, 0), UDim2.new(0.9, 0, 0, 35))
    imp.MouseButton1Click:Connect(function()
        local s, d = pcall(function() return HttpService:JSONDecode(box.Text) end)
        if s and type(d) == "table" then
            if d.Type and d.Type ~= "CustomAnimationSet" then
                getgenv().Notify({ Title = "Error", Content = "Backup type mismatch!", Duration = 3 })
                return
            end
            if type(d.Data) ~= "table" then
                getgenv().Notify({ Title = "Error", Content = "Invalid JSON", Duration = 3 })
                return
            end
            State.CustomAnimations = NormalizeCustomAnimationData(State.CustomAnimations)
            local sourceName = d.Name or "Imported"
            local targetName = MakeUniqueSetName(State.CustomAnimations.Sets, sourceName)
            local imported = d.Data
            imported.__meta = imported.__meta or {}
            if imported.__meta.IconImage == nil then imported.__meta.IconImage = DEFAULT_IDLE_ICON_ID end
            if imported.__meta.IconColor == nil then imported.__meta.IconColor = ColorToTable(DEFAULT_IDLE_ICON_COLOR) end
            State.CustomAnimations.Sets[targetName] = imported
            table.insert(State.CustomAnimations.Order, targetName)
            State.currentCustomAnimationName = targetName
            State.CustomAnimations.Selected = targetName
            
            State.SaveCustomAnimations(State.CustomAnimations)
            if State.CustomAnimDropdown then
                State.CustomAnimDropdown.Refresh(State.CustomAnimations.Order)
                State.CustomAnimDropdown.Button.Text = State.currentCustomAnimationName .. "  ▼"
            end
            if State.RefreshCustomAnimUI then State.RefreshCustomAnimUI() end
            if State.ApplyCustomAnimIconUI then State.ApplyCustomAnimIconUI() end
            if refreshCustomAnimationState then refreshCustomAnimationState(false) end
            popup:Destroy()
            getgenv().Notify({ Title = "7yd7 | Animation", Content = "✅ Imported custom animations", Duration = 3 })
        else
            getgenv().Notify({ Title = "Error", Content = "Invalid JSON", Duration = 3 })
        end
    end)
    
    local close = Instance.new("TextButton")
    close.Size = UDim2.fromOffset(24, 24)
    close.Position = UDim2.new(1, -30, 0, 5)
    close.Text = "x"
    close.Font = Enum.Font.GothamBold
    close.TextSize = 20
    close.BackgroundTransparency = 1
    close.TextColor3 = Color3.new(1,1,1)
    close.Parent = popup
    close.MouseButton1Click:Connect(function() popup:Destroy() end)
end)

function GetCurrentCustomAnimMeta()
    local set = State.CustomAnimations.Sets[State.currentCustomAnimationName]
    if not set then return nil end
    set.__meta = set.__meta or {}
    if set.__meta.IconImage == nil then set.__meta.IconImage = DEFAULT_IDLE_ICON_ID end
    if set.__meta.IconColor == nil then set.__meta.IconColor = ColorToTable(DEFAULT_IDLE_ICON_COLOR) end
    return set.__meta
end

State.ApplyCustomAnimIconUI = function()
    if not State.CustomAnimIconControl or not State.CustomAnimIconControl.SetValue then return end
    local meta = GetCurrentCustomAnimMeta()
    if not meta then return end
    State.CustomAnimIconControl.SetValue(meta.IconImage or DEFAULT_IDLE_ICON_ID, TableToColor(meta.IconColor or ColorToTable(DEFAULT_IDLE_ICON_COLOR)))
end

do
    local meta = GetCurrentCustomAnimMeta() or {}
    local currentImage = meta.IconImage or DEFAULT_IDLE_ICON_ID
    local currentColor = TableToColor(meta.IconColor or ColorToTable(DEFAULT_IDLE_ICON_COLOR))
    State.CustomAnimIconControl = SettingsLib.AddAssetColor(State.CustomAnimTab, "Icon", "Asset ID or URL...", currentImage, currentColor, function(text, color)
        local set = State.CustomAnimations.Sets[State.currentCustomAnimationName]
        if not set then return end
        set.__meta = set.__meta or {}
        set.__meta.IconImage = text
        set.__meta.IconColor = ColorToTable(color)
        State.SaveCustomAnimations(State.CustomAnimations)
        if refreshCustomAnimationState then refreshCustomAnimationState(false) end
    end)
    if State.CustomAnimIconControl and State.CustomAnimIconControl.Item then
        State.CustomAnimIconControl.Item.LayoutOrder = 1.5
    end
    
    local resetBtn = SettingsLib:Create("ImageButton", {
        Parent = State.CustomAnimIconControl.Item,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -120, 0.5, -10),
        Size = UDim2.fromOffset(20, 20),
        Image = "rbxassetid://127493377027615",
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 10
    })
    resetBtn.MouseButton1Click:Connect(function()
        local set = State.CustomAnimations.Sets[State.currentCustomAnimationName]
        if not set then return end
        set.__meta = set.__meta or {}
        set.__meta.IconImage = DEFAULT_IDLE_ICON_ID
        set.__meta.IconColor = ColorToTable(DEFAULT_IDLE_ICON_COLOR)
        State.SaveCustomAnimations(State.CustomAnimations)
        if State.CustomAnimIconControl and State.CustomAnimIconControl.SetValue then
            State.CustomAnimIconControl.SetValue(DEFAULT_IDLE_ICON_ID, DEFAULT_IDLE_ICON_COLOR)
        end
        if refreshCustomAnimationState then refreshCustomAnimationState(false) end
    end)
end

State.CustomAnimUIElems = {}
function CreateAnimSetUI(folder, cat, name)
    local item = SettingsLib.AddItem(folder, cat .. " - " .. name, "Current ID: 0")
    
    local resetBtn = SettingsLib:Create("ImageButton", {
        Parent = item,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -70, 0.5, -10),
        Size = UDim2.fromOffset(20, 20),
        Image = "rbxassetid://127493377027615",
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 10
    })
    
    local editBtn = SettingsLib:Create("ImageButton", {
        Parent = item,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -40, 0.5, -10),
        Size = UDim2.fromOffset(20, 20),
        Image = "rbxassetid://117761881427472",
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 10
    })
    
    resetBtn.MouseButton1Click:Connect(function()
        if State.currentCustomAnimationName == "Default" then return end
        if State.CustomAnimations.Sets[State.currentCustomAnimationName] then
            if not State.CustomAnimations.Sets[State.currentCustomAnimationName][cat] then
                State.CustomAnimations.Sets[State.currentCustomAnimationName][cat] = {}
            end
            State.CustomAnimations.Sets[State.currentCustomAnimationName][cat][name] = 0
            State.SaveCustomAnimations(State.CustomAnimations)
            if State.RefreshCustomAnimUI then State.RefreshCustomAnimUI() end
            if refreshCustomAnimationState then refreshCustomAnimationState(true) end
        end
    end)
    
    editBtn.MouseButton1Click:Connect(function()
        State.enterCustomAnimationEditor(cat, name)
    end)
    
    table.insert(State.CustomAnimUIElems, { item = item, cat = cat, name = name })
end

State.CustomAnimFolders = {}
State.CustomAnimFolders.Idle = SettingsLib.AddFolder(State.CustomAnimTab, "Idle Animations")
State.CustomAnimFolders.Idle.Parent.LayoutOrder = 2
CreateAnimSetUI(State.CustomAnimFolders.Idle, "idle", "Animation1")
CreateAnimSetUI(State.CustomAnimFolders.Idle, "idle", "Animation2")

State.CustomAnimFolders.Movement = SettingsLib.AddFolder(State.CustomAnimTab, "Movement Animations")
State.CustomAnimFolders.Movement.Parent.LayoutOrder = 3
CreateAnimSetUI(State.CustomAnimFolders.Movement, "walk", "WalkAnim")
CreateAnimSetUI(State.CustomAnimFolders.Movement, "run", "RunAnim")
CreateAnimSetUI(State.CustomAnimFolders.Movement, "jump", "JumpAnim")
CreateAnimSetUI(State.CustomAnimFolders.Movement, "fall", "FallAnim")
CreateAnimSetUI(State.CustomAnimFolders.Movement, "climb", "ClimbAnim")
CreateAnimSetUI(State.CustomAnimFolders.Movement, "swimidle", "SwimIdle")
CreateAnimSetUI(State.CustomAnimFolders.Movement, "swim", "Swim")

State.RefreshCustomAnimUI = function()
    local set = State.CustomAnimations.Sets[State.currentCustomAnimationName]
    if not set then return end
    
    for _, elem in pairs(State.CustomAnimUIElems) do
        local desc = elem.item:FindFirstChild("Desc")
        if desc then
            local val = set[elem.cat] and set[elem.cat][elem.name] or 0
            desc.Text = "Current ID: " .. tostring(val)
        end
    end
end
State.RefreshCustomAnimUI()

State.PageTab = SettingsLib.CreateTab("Page", 5)

function GetEmotePageNames()
    return State.EmotePages.Order
end

SettingsLib.AddItem(State.PageTab, "Page Profiles", "Pages allow you to save different favorite sets. Switch pages to quickly change your favorite wheel loadout.")

SettingsLib.AddItem(State.PageTab, "Emote Profiles", "Manage your favorite emote profiles")

State.PageDropdown = SettingsLib.AddDropdown(State.PageTab, "Select Emote Page", GetEmotePageNames(), State.currentEmotePageName, function(v)
    SwitchEmotePage(v)
    State.SaveEmotePages(State.EmotePages)
end)

local EmotePageMgtItem = SettingsLib.AddItem(State.PageTab, "Emote Page Management", " ")
EmotePageMgtItem.BackgroundColor3 = Color3.fromRGB(35, 38, 42)
EmotePageMgtItem.Size = UDim2.new(0.95, 0, 0, 70)
for _, v in pairs(EmotePageMgtItem:GetChildren()) do if v.Name == "Title" or v.Name == "Desc" then v:Destroy() end end

local EmotePageMgtContainer = Instance.new("Frame")
EmotePageMgtContainer.Parent = EmotePageMgtItem
EmotePageMgtContainer.BackgroundTransparency = 1
EmotePageMgtContainer.Size = UDim2.new(1, 0, 1, 0)

local EmotePageLayout = Instance.new("UIListLayout")
EmotePageLayout.FillDirection = Enum.FillDirection.Horizontal
EmotePageLayout.Padding = UDim.new(0, 15)
EmotePageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
EmotePageLayout.VerticalAlignment = Enum.VerticalAlignment.Center
EmotePageLayout.Parent = EmotePageMgtContainer

SettingsLib.AddIconButton(EmotePageMgtContainer, "108445456753346", function()
    local popup, content = CreatePopup("Create Emote Page")
    local In = CreateInput(content, "Page Name...")
    local Save = CreateButton(content, "SAVE", (State.EmoteTheme and State.EmoteTheme.Accent) or Color3.fromRGB(0, 255, 150), UDim2.new(0.05, 0, 0.6, 0))
    local Cancel = CreateButton(content, "CANCEL", Color3.fromRGB(50, 50, 50), UDim2.new(0.55, 0, 0.6, 0))
    Save.MouseButton1Click:Connect(function()
        if In.Text ~= "" and not State.EmotePages.Sets[In.Text] then
            State.EmotePages.Sets[In.Text] = {}
            table.insert(State.EmotePages.Order, In.Text)
            table.sort(State.EmotePages.Order, function(a, b)
                if a == "Default" then return true end
                if b == "Default" then return false end
                return a:lower() < b:lower()
            end)
            State.SaveEmotePages(State.EmotePages)
            if State.PageDropdown then State.PageDropdown.Refresh(GetEmotePageNames()) end
            SwitchEmotePage(In.Text)
            if State.PageDropdown then State.PageDropdown.Button.Text = State.currentEmotePageName .. "  ▼" end
            popup:Destroy()
        end
    end)
    Cancel.MouseButton1Click:Connect(function() popup:Destroy() end)
end)

SettingsLib.AddIconButton(EmotePageMgtContainer, "71829270056766", function()
    if State.currentEmotePageName ~= "Default" then
        local idx = table.find(State.EmotePages.Order, State.currentEmotePageName)
        if idx then table.remove(State.EmotePages.Order, idx) end
        State.EmotePages.Sets[State.currentEmotePageName] = nil
        State.currentEmotePageName = "Default"
        State.EmotePages.Selected = "Default"
        State.SaveEmotePages(State.EmotePages)
        if State.PageDropdown then
            State.PageDropdown.Refresh(GetEmotePageNames())
            State.PageDropdown.Button.Text = "Default  ▼"
        end
        SwitchEmotePage("Default")
    end
end)

SettingsLib.AddIconButton(EmotePageMgtContainer, "117761881427472", function()
    if State.currentEmotePageName == "Default" then return end
    local popup, content = CreatePopup("Rename Emote Page")
    local In = CreateInput(content, "New Name...", State.currentEmotePageName)
    local Save = CreateButton(content, "RENAME", (State.EmoteTheme and State.EmoteTheme.Accent) or Color3.fromRGB(0, 255, 150), UDim2.new(0.05, 0, 0.6, 0))
    local Cancel = CreateButton(content, "CANCEL", Color3.fromRGB(50, 50, 50), UDim2.new(0.55, 0, 0.6, 0))
    Save.MouseButton1Click:Connect(function()
        if In.Text ~= "" and not State.EmotePages.Sets[In.Text] then
            local idx = table.find(State.EmotePages.Order, State.currentEmotePageName)
            if idx then State.EmotePages.Order[idx] = In.Text end
            State.EmotePages.Sets[In.Text] = State.EmotePages.Sets[State.currentEmotePageName]
            State.EmotePages.Sets[State.currentEmotePageName] = nil
            State.currentEmotePageName = In.Text
            State.EmotePages.Selected = In.Text
            State.SaveEmotePages(State.EmotePages)
            if State.PageDropdown then
                State.PageDropdown.Refresh(GetEmotePageNames())
                State.PageDropdown.Button.Text = State.currentEmotePageName .. "  ▼"
            end
            popup:Destroy()
        end
    end)
    Cancel.MouseButton1Click:Connect(function() popup:Destroy() end)
end)

SettingsLib.AddIconButton(EmotePageMgtContainer, "107588515524752", function() 
    local currentSet = State.EmotePages.Sets[State.currentEmotePageName]
    local data = { Type = "EmotePageSet", Name = State.currentEmotePageName, Data = currentSet }
    local json = HttpService:JSONEncode(data)
    local popup, content = CreatePopup("Export Emote Page", UDim2.fromOffset(320, 240))
    local box = CreateInput(content, "", json, true)
    box.Size = UDim2.new(0.9, 0, 0, 130)
    box.TextEditable = false
    local copy = CreateButton(content, "COPY TO CLIPBOARD", (State.EmoteTheme and State.EmoteTheme.Accent) or Color3.fromRGB(0, 255, 150), UDim2.new(0.05, 0, 0.8, 0), UDim2.new(0.9, 0, 0, 35))
    copy.MouseButton1Click:Connect(function()
        setclipboard(json)
        copy.Text = "COPIED!"
        task.delay(1, function() copy.Text = "COPY TO CLIPBOARD" end)
    end)
    local close = Instance.new("TextButton")
    close.Size = UDim2.fromOffset(24, 24)
    close.Position = UDim2.new(1, -30, 0, 5)
    close.Text = "×"
    close.Font = Enum.Font.GothamBold
    close.TextSize = 20
    close.BackgroundTransparency = 1
    close.TextColor3 = Color3.new(1,1,1)
    close.Parent = popup
    close.MouseButton1Click:Connect(function() popup:Destroy() end)
end)

SettingsLib.AddIconButton(EmotePageMgtContainer, "78317476576895", function() 
    local popup, content = CreatePopup("Import Emote Page", UDim2.fromOffset(320, 240))
    local box = CreateInput(content, "Paste Page JSON here...", "", true)
    box.Size = UDim2.new(0.9, 0, 0, 130)
    local imp = CreateButton(content, "IMPORT DATA", (State.EmoteTheme and State.EmoteTheme.Accent) or Color3.fromRGB(0, 255, 150), UDim2.new(0.05, 0, 0.8, 0), UDim2.new(0.9, 0, 0, 35))
    imp.MouseButton1Click:Connect(function()
        local s, d = pcall(function() return HttpService:JSONDecode(box.Text) end)
        if s and type(d) == "table" and d.Type == "EmotePageSet" and type(d.Data) == "table" then
            local targetName = MakeUniqueSetName(State.EmotePages.Sets, d.Name or "Imported")
            State.EmotePages.Sets[targetName] = d.Data
            table.insert(State.EmotePages.Order, targetName)
            State.currentEmotePageName = targetName
            State.EmotePages.Selected = targetName
            State.SaveEmotePages(State.EmotePages)
            if State.PageDropdown then
                State.PageDropdown.Refresh(GetEmotePageNames())
                State.PageDropdown.Button.Text = State.currentEmotePageName .. "  ▼"
            end
            SwitchEmotePage(targetName)
            popup:Destroy()
            getgenv().Notify({ Title = "7yd7 | Page", Content = "✅ Imported Emote page", Duration = 3 })
        else
            getgenv().Notify({ Title = "Error", Content = "Invalid Emote Page JSON", Duration = 3 })
        end
    end)
    local close = Instance.new("TextButton")
    close.Size = UDim2.fromOffset(24, 24)
    close.Position = UDim2.new(1, -30, 0, 5)
    close.Text = "×"
    close.Font = Enum.Font.GothamBold
    close.TextSize = 20
    close.BackgroundTransparency = 1
    close.TextColor3 = Color3.new(1,1,1)
    close.Parent = popup
    close.MouseButton1Click:Connect(function() popup:Destroy() end)
end)

SettingsLib.AddItem(State.PageTab, "Animation Profiles", "Manage your favorite animation profiles")


local BackupTab = SettingsLib.CreateTab("Backup", 6)

local BackupDesc = SettingsLib.AddItem(BackupTab, "What's included in a backup?", " ")
BackupDesc.LayoutOrder = 1
BackupDesc.Size = UDim2.new(0.95, 0, 0, 110)
for _, v in pairs(BackupDesc:GetChildren()) do if v.Name == "Title" or v.Name == "Desc" then v:Destroy() end end
BackupDesc.BackgroundTransparency = 0
BackupDesc.BackgroundColor3 = Color3.fromRGB(35, 38, 42)

local BackupTitle = Instance.new("TextLabel")
BackupTitle.Parent = BackupDesc
BackupTitle.BackgroundTransparency = 1
BackupTitle.Position = UDim2.new(0, 12, 0, 6)
BackupTitle.Size = UDim2.new(1, -24, 0, 18)
BackupTitle.Font = Enum.Font.GothamBold
BackupTitle.Text = "What's included in a backup?"
BackupTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
BackupTitle.TextSize = 12
BackupTitle.TextXAlignment = Enum.TextXAlignment.Left

local DescList = Instance.new("Frame")
DescList.Parent = BackupDesc
DescList.BackgroundTransparency = 1
DescList.Position = UDim2.new(0, 12, 0, 28)
DescList.Size = UDim2.new(1, -24, 1, -28)

local LayoutDesc = Instance.new("UIListLayout")
LayoutDesc.Parent = DescList
LayoutDesc.Padding = UDim.new(0, 4)

function MakeDescLine(text)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = DescList
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 0, 15)
    lbl.AutomaticSize = Enum.AutomaticSize.Y
    lbl.TextWrapped = true
    lbl.Font = Enum.Font.Gotham
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(150, 150, 150)
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.RichText = true
end

MakeDescLine("<b>• Theme:</b> Saves custom themes")
MakeDescLine("<b>• Settings:</b> Saves HUD layout & values")
MakeDescLine("<b>• Favorite:</b> Saves favorite emotes/anims")
MakeDescLine("<b>• All:</b> Includes everything above")

local ExportItem = SettingsLib.AddItem(BackupTab, "Export Settings", "Save current settings to a file for sharing or later import.")
ExportItem.LayoutOrder = 2

local ExportBtnContainer = Instance.new("Frame")
ExportBtnContainer.Parent = ExportItem
ExportBtnContainer.BackgroundTransparency = 1
ExportBtnContainer.Size = UDim2.new(1, -24, 0, 60)

local expDesc = ExportItem:FindFirstChild("Desc")
if expDesc then
    expDesc.Size = UDim2.new(1, -24, 0, 0)
    local function updateExpPos()
        ExportBtnContainer.Position = UDim2.new(0, 12, 0, expDesc.Position.Y.Offset + expDesc.AbsoluteSize.Y + 12)
    end
    expDesc:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateExpPos)
    updateExpPos()
else
    ExportBtnContainer.Position = UDim2.new(0, 12, 0, 32)
end

local ExportLayout = Instance.new("UIGridLayout")
ExportLayout.CellSize = UDim2.new(0.48, 0, 0, 26)
ExportLayout.CellPadding = UDim2.new(0.04, 0, 0, 8)
ExportLayout.SortOrder = Enum.SortOrder.LayoutOrder
ExportLayout.Parent = ExportBtnContainer

function CreateExportBtn(text, color, order)
    local btn = Instance.new("TextButton")
    btn.LayoutOrder = order
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 11
    btn.Parent = ExportBtnContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    return btn
end

local btnColors = {
    dark = Color3.fromRGB(45, 48, 52),
    blue = Color3.fromRGB(88, 101, 242)
}

local BtnExportAll = CreateExportBtn("Export All Settings", btnColors.dark, 1)
local BtnExportThemes = CreateExportBtn("Export Themes", btnColors.blue, 2)
local BtnExportSettings = CreateExportBtn("Export Settings", btnColors.blue, 3)
local BtnExportFavorites = CreateExportBtn("Export Favorites", btnColors.blue, 4)

function GetFavoritesData()
    local favAnimsStr = "{}"
    if isfile and isfile(State.favoriteAnimationsFileName) then
        favAnimsStr = readfile(State.favoriteAnimationsFileName)
    end
    return {
        EmotePages = State.EmotePages,
        Animations = HttpService:JSONDecode(favAnimsStr) or {}
    }
end

BtnExportAll.MouseButton1Click:Connect(function()
    local data = {
        Type = "All",
        Themes = LoadThemes(),
        Settings = Config,
        Favorites = GetFavoritesData()
    }
    setclipboard(HttpService:JSONEncode(data))
    BtnExportAll.Text = "Copied!"
    task.delay(1, function() BtnExportAll.Text = "Export All Settings" end)
end)

BtnExportThemes.MouseButton1Click:Connect(function()
    local data = {
        Type = "Themes",
        Themes = LoadThemes()
    }
    setclipboard(HttpService:JSONEncode(data))
    BtnExportThemes.Text = "Copied!"
    task.delay(1, function() BtnExportThemes.Text = "Export Themes" end)
end)

BtnExportSettings.MouseButton1Click:Connect(function()
    local data = {
        Type = "Settings",
        Settings = Config
    }
    setclipboard(HttpService:JSONEncode(data))
    BtnExportSettings.Text = "Copied!"
    task.delay(1, function() BtnExportSettings.Text = "Export Settings" end)
end)

BtnExportFavorites.MouseButton1Click:Connect(function()
    local data = {
        Type = "Favorites",
        Favorites = GetFavoritesData()
    }
    setclipboard(HttpService:JSONEncode(data))
    BtnExportFavorites.Text = "Copied!"
    task.delay(1, function() BtnExportFavorites.Text = "Export Favorites" end)
end)


local ImportItem = SettingsLib.AddItem(BackupTab, "Import Settings", "Select a backup file to restore your configuration and overwrite current settings.")
ImportItem.LayoutOrder = 3

local ImportBtnContainer = Instance.new("Frame")
ImportBtnContainer.Parent = ImportItem
ImportBtnContainer.BackgroundTransparency = 1
ImportBtnContainer.Size = UDim2.new(1, -24, 0, 60)

local impDesc = ImportItem:FindFirstChild("Desc")
if impDesc then
    impDesc.Size = UDim2.new(1, -24, 0, 0)
    local function updateImpPos()
        ImportBtnContainer.Position = UDim2.new(0, 12, 0, impDesc.Position.Y.Offset + impDesc.AbsoluteSize.Y + 12)
    end
    impDesc:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateImpPos)
    updateImpPos()
else
    ImportBtnContainer.Position = UDim2.new(0, 12, 0, 32)
end

local ImportLayout = Instance.new("UIGridLayout")
ImportLayout.CellSize = UDim2.new(0.48, 0, 0, 26)
ImportLayout.CellPadding = UDim2.new(0.04, 0, 0, 8)
ImportLayout.SortOrder = Enum.SortOrder.LayoutOrder
ImportLayout.Parent = ImportBtnContainer

function CreateImportBtn(text, color, order)
    local btn = Instance.new("TextButton")
    btn.LayoutOrder = order
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 11
    btn.Parent = ImportBtnContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    return btn
end

local BtnImportAll = CreateImportBtn("Import All Settings", btnColors.dark, 1)
local BtnImportThemes = CreateImportBtn("Import Themes", btnColors.blue, 2)
local BtnImportSettings = CreateImportBtn("Import Settings", btnColors.blue, 3)
local BtnImportFavorites = CreateImportBtn("Import Favorites", btnColors.blue, 4)

function HandleImportPrompt(typeStr)
    local popup, content = CreatePopup("Import " .. typeStr, UDim2.fromOffset(320, 240))
    local box = CreateInput(content, "Paste Backup JSON here...", "", true)
    box.Size = UDim2.new(0.9, 0, 0, 130)
    
    local imp = CreateButton(content, "IMPORT DATA", (State.EmoteTheme and State.EmoteTheme.Accent) or Color3.fromRGB(0, 255, 150), UDim2.new(0.05, 0, 0.8, 0), UDim2.new(0.9, 0, 0, 35))

    imp.MouseButton1Click:Connect(function()
        local s, d = pcall(function() return HttpService:JSONDecode(box.Text) end)
        if s and type(d) == "table" and d.Type then
            if typeStr ~= "All" and d.Type ~= "All" and typeStr ~= d.Type then
                 getgenv().Notify({Title = "Error", Content = "Backup type mismatch!", Duration = 3})
                 return
            end
            
            if d.Themes and (typeStr == "All" or typeStr == "Themes") then
                themes = d.Themes
                currentThemeName = themes.Selected or Config.SelectedTheme or "Default"
                SaveThemesImplementation(themes)
                themeDropdown.Refresh(GetNames())
                if themeDropdown and themeDropdown.Button then
                    themeDropdown.Button.Text = currentThemeName .. "  ▼"
                end
                local themeToApply = themes[currentThemeName] or themes["Default"]
                if themeToApply then
                    State.isApplyingTheme = false
                    ApplyTheme(themeToApply)
                else
                    warn("7yd7 | Missing Default theme during import fallback")
                end
            end
            if d.Settings and (typeStr == "All" or typeStr == "Settings") then
                for k, v in pairs(d.Settings) do Config[k] = v end
                SaveConfig()
                ApplyUIVisibility()
                if applySavedPositions then applySavedPositions() end
                if State.RefreshSettingsUI then State.RefreshSettingsUI() end
            end
            if (d.Favorites or d.EmotePages) and (typeStr == "All" or typeStr == "Favorites") then
                local emotesData = d.EmotePages
                if not emotesData and type(d.Favorites) == "table" then
                    emotesData = d.Favorites.EmotePages or d.Favorites.Emotes
                end
                if emotesData then
                    if emotesData.Sets then
                        State.EmotePages = emotesData
                    else
                        State.EmotePages.Sets.Default = emotesData
                    end
                    State.SaveEmotePages(State.EmotePages)
                    local targetPage = State.EmotePages.Selected
                    if not State.EmotePages.Sets[targetPage] then targetPage = "Default" end
                    SwitchEmotePage(targetPage)
                end
                
                if d.Favorites and d.Favorites.Animations then
                     State.favoriteAnimations = d.Favorites.Animations
                     writefile(State.favoriteAnimationsFileName, HttpService:JSONEncode(d.Favorites.Animations))
                     State.favoriteSetVersion = State.favoriteSetVersion + 1
                end
                if State.RefreshUI then State.RefreshUI() end
            end
            
            getgenv().Notify({Title = "Success", Content = "Data imported successfully!", Duration = 3})
            popup:Destroy()
        else
            getgenv().Notify({Title = "Error", Content = "Invalid Backup JSON Format!", Duration = 3})
        end
    end)
    
    local close = Instance.new("TextButton")
    close.Size = UDim2.fromOffset(24, 24)
    close.Position = UDim2.new(1, -30, 0, 5)
    close.Text = "×"
    close.Font = Enum.Font.GothamBold
    close.TextSize = 20
    close.BackgroundTransparency = 1
    close.TextColor3 = Color3.new(1,1,1)
    close.Parent = popup
    close.MouseButton1Click:Connect(function() popup:Destroy() end)
end

BtnImportAll.MouseButton1Click:Connect(function() HandleImportPrompt("All") end)
BtnImportThemes.MouseButton1Click:Connect(function() HandleImportPrompt("Themes") end)
BtnImportSettings.MouseButton1Click:Connect(function() HandleImportPrompt("Settings") end)
BtnImportFavorites.MouseButton1Click:Connect(function() HandleImportPrompt("Favorites") end)

getgenv().Notify({
    Title = '7yd7 | Emote',
    Content = '⚠️ Script loading...',
    Duration = 5
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer
if not player then
    player = Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
end
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

getgenv().OwnedAuthenticEmotes = getgenv().OwnedAuthenticEmotes or {}
function gatherAuthenticEmotes(char)
    if not char then return end
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end
    local desc = hum:WaitForChild("HumanoidDescription", 5)
    if not desc then return end
    local allEmotes = desc:GetEmotes()
    local owned = {}
    
    for _, e in ipairs(desc:GetEquippedEmotes()) do
        local id = allEmotes[e.Name] and allEmotes[e.Name][1]
        if id then
            local idNum = tonumber((tostring(id):gsub("rbxassetid://", "")))
            if idNum then
                table.insert(owned, {
                    name = e.Name,
                    id = idNum
                })
            end
        end
    end
    if #owned > 0 then
        getgenv().OwnedAuthenticEmotes = owned
    end
end

task.spawn(function() gatherAuthenticEmotes(character) end)
player.CharacterAdded:Connect(gatherAuthenticEmotes)

local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

RunService.Heartbeat:Connect(function()
    local success, menu = pcall(function() return CoreGui.RobloxGui.EmotesMenu.Children end)
    if not (success and menu) then return end
    
    pcall(function()
        local wheelVisible = menu.Main.EmotesWheel.Visible
        if wheelVisible then
            State.lastWheelVisibleTime = tick()
        end
        ToggleContainer.Visible = wheelVisible
    end)

    local errorMsg = menu:FindFirstChild("ErrorMessage")

    if errorMsg and errorMsg.Visible then
        if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
            errorMsg.ErrorText.Text = "Only r15 does not work r6"
        elseif tick() - State.lastRadialActionTime < 2 then
            errorMsg.Visible = false
        end
    end
end)


function ErrorMessage(text, duration)

    if State.currentTimer then
        task.cancel(State.currentTimer)
        State.currentTimer = nil
    end
    
    local errorMessage = CoreGui.RobloxGui.EmotesMenu.Children.ErrorMessage
    local errorText = errorMessage.ErrorText
    
    errorText.Text = text
    
    errorMessage.Visible = true
    
    State.currentTimer = task.delay(duration, function()
        errorMessage.Visible = false
        State.currentTimer = nil
    end)
end

function stopEmotes()
    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
        track:Stop()
    end
end

function getCharacterAndHumanoid()
    local character = player.Character
    if not character then
        return nil, nil
    end
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then
        return nil, nil
    end
    return character, humanoid
end

function urlToId(animationId)
    animationId = string.gsub(animationId, "http://www%.roblox%.com/asset/%?id=", "")
    animationId = string.gsub(animationId, "rbxassetid://", "")
    return animationId
end

function resolveEmoteToAnimationId(emoteId)
    local fallbackId = tonumber(emoteId)
    if not emoteId or emoteId == "" then return fallbackId end

    local objects
    local ok = false
    local idStr = tostring(emoteId)
    for _, url in ipairs({
        "rbxassetid://" .. idStr,
        "http://www.roblox.com/asset/?id=" .. idStr
    }) do
        ok, objects = pcall(function()
            return game:GetObjects(url)
        end)
        if ok and type(objects) == "table" and #objects > 0 then
            break
        end
    end
    if ok and type(objects) == "table" then
        local function findAnimId(obj)
            if obj:IsA("Animation") then
                local animId = tonumber(urlToId(obj.AnimationId))
                if animId and animId > 0 then
                    return animId
                end
            end
            for _, child in ipairs(obj:GetChildren()) do
                local found = findAnimId(child)
                if found then return found end
            end
            return nil
        end

        local rootObj = objects[1]
        if rootObj and rootObj.Parent == nil then
            pcall(function() rootObj.Parent = workspace end)
        end
        if rootObj then
            local foundRoot = findAnimId(rootObj)
            if foundRoot then
                pcall(function() rootObj:Destroy() end)
                return foundRoot
            end
        end
        for _, obj in ipairs(objects) do
            local found = findAnimId(obj)
            pcall(function() obj:Destroy() end)
            if found then
                return found
            end
        end
    end
    return fallbackId
end

function saveFavoritesAnimations()
    if writefile then
        local jsonData = HttpService:JSONEncode(State.favoriteAnimations)
        writefile(State.favoriteAnimationsFileName, jsonData)
    end
end

function loadFavoritesAnimations()
    if readfile and isfile and isfile(State.favoriteAnimationsFileName) then
        local success, result = pcall(function()
            local fileContent = readfile(State.favoriteAnimationsFileName)
            return HttpService:JSONDecode(fileContent)
        end)
        if success and type(result) == "table" then
            local filtered = {}
            for _, fav in pairs(result) do
                local idNum = fav and tonumber(fav.id)
                if fav and idNum and (idNum > 0 or idNum < -1000) then
                    if fav.isCustomSet == nil and idNum < 0 then
                        fav.isCustomSet = true
                    end
                    if IsCustomSetData(fav) and not fav.customSetName and type(fav.name) == "string" then
                        local baseName = fav.name:gsub("%s*%-.*$", "")
                        fav.customSetName = baseName
                    end
                    table.insert(filtered, fav)
                end
            end
            State.favoriteAnimations = filtered
            State.favoriteSetVersion = State.favoriteSetVersion + 1
        end
    end
end

function disconnectAllConnections()
    for _, connection in pairs(State.guiConnections) do
        if connection then
            connection:Disconnect()
        end
    end
    State.guiConnections = {}
    if ContextActionService then
        ContextActionService:UnbindAction("7yd7_EmoteWheelHotkeys")
    end
end

function loadSpeedEmoteConfig()
    State.speedEmoteEnabled = Config.EmoteSpeedEnabled
    if UI.SpeedBox then
        UI.SpeedBox.Text = tostring(Config.EmoteSpeed)
        updateSpeedBoxVisibility()
    end
end

function extractAssetId(imageUrl)
    local assetId = string.match(imageUrl, "Asset&id=(%d+)")
    return assetId
end

local isRandomSlotEnabled
local isRandomSlotActive

function isEmoteSearchActive()
    return State.currentMode == "emote" and State.emoteSearchTerm and State.emoteSearchTerm ~= ""
end

function isAnimationSearchActive()
    return State.currentMode == "animation" and State.animationSearchTerm and State.animationSearchTerm ~= ""
end

function isSearchActive()
    return isEmoteSearchActive() or isAnimationSearchActive()
end

function shouldRandomSlotBeShown()
    if Config.RandomEnabled ~= true then return false end
    if State.currentMode == "emote" then
        return not isEmoteSearchActive()
    elseif State.currentMode == "animation" then
        return not isAnimationSearchActive()
    end
    return false
end

function getFirstPageSize()
    if shouldRandomSlotBeShown() then
        return math.max(State.itemsPerPage - 1, 1)
    end
    return State.itemsPerPage
end

isRandomSlotEnabled = function()
    return Config.RandomEnabled == true
end

function calcPagesForList(count, isFirstList)
    if count <= 0 then return 0 end
    if isFirstList then
        local first = getFirstPageSize()
        if count <= first then return 1 end
        return 1 + math.ceil((count - first) / State.itemsPerPage)
    end
    return math.ceil(count / State.itemsPerPage)
end

function getCategoryStats()
    local stats = {}
    local randomCaptured = false
    local shouldShowRandom = shouldRandomSlotBeShown()

    local authenticEmotes = (Config.AuthenticFirstPage and State.currentMode == "emote") and (getgenv().OwnedAuthenticEmotes or {}) or {}
    if #authenticEmotes > 0 then
        local pages = calcPagesForList(#authenticEmotes, false)
        table.insert(stats, { name = "Authentic", list = authenticEmotes, pages = pages, hasRandom = false })
    end

    local favoritesToUse = (State.currentMode == "animation") and (_G.filteredFavoritesAnimationsForDisplay or State.favoriteAnimations) or (_G.filteredFavoritesForDisplay or State.favoriteEmotes)
    if #favoritesToUse > 0 then
        local hasRandom = not randomCaptured and shouldShowRandom
        if hasRandom then randomCaptured = true end
        local pages = calcPagesForList(#favoritesToUse, hasRandom)
        table.insert(stats, { name = "Favorites", list = favoritesToUse, pages = pages, hasRandom = hasRandom })
    end

    local normalList = {}
    if State.currentMode == "animation" then
        normalList = State.animationPageCache.normal or {}
    else
        normalList = State.emotePageCache.normal or {}
    end

    if #normalList > 0 then
        local hasRandom = not randomCaptured and shouldShowRandom
        if hasRandom then randomCaptured = true end
        local pages = calcPagesForList(#normalList, hasRandom)
        table.insert(stats, { name = "Normal", list = normalList, pages = pages, hasRandom = hasRandom })
    end

    return stats
end

isRandomSlotActive = function()
    if not shouldRandomSlotBeShown() then return false end
    local categories = getCategoryStats()
    local totalPages = 0
    for _, cat in ipairs(categories) do
        if cat.hasRandom then
            return State.currentPage == totalPages + 1
        end
        totalPages = totalPages + cat.pages
    end
    return false
end

function getPageSize(pageNumber, isFirstList)
    if isFirstList and pageNumber == 1 then
        return getFirstPageSize()
    end
    return State.itemsPerPage
end

function getListSlice(list, pageNumber, isFirstList)
    local pageSize = getPageSize(pageNumber, isFirstList)
    local startIndex
    if isFirstList and pageNumber == 1 then
        startIndex = 1
    elseif isFirstList then
        startIndex = getFirstPageSize() + (pageNumber - 2) * State.itemsPerPage + 1
    else
        startIndex = (pageNumber - 1) * State.itemsPerPage + 1
    end
    local endIndex = math.min(startIndex + pageSize - 1, #list)
    local items = {}
    for i = startIndex, endIndex do
        if list[i] then table.insert(items, list[i]) end
    end
    return items
end

function getRandomSourceList()
    if Config.RandomEnabled == false then
        return {}
    end
    if State.favoriteEnabled then
        if State.currentMode == "animation" then
            return State.filteredAnimations
        end
        return State.filteredEmotes
    end
    if Config.RandomMode == "Favorites" then
        if State.currentMode == "animation" then
            return _G.filteredFavoritesAnimationsForDisplay or State.favoriteAnimations
        end
        return _G.filteredFavoritesForDisplay or State.favoriteEmotes
    end
    if State.currentMode == "animation" then
        return State.filteredAnimations
    end
    return State.filteredEmotes
end

function pickRandomItem()
    local list = getRandomSourceList() or {}
    if #list == 0 then return nil end
    return list[math.random(1, #list)]
end

function pickRandomItemForMode()
    local list = getRandomSourceList() or {}
    if #list == 0 then return nil end
    if State.currentMode == "animation" then
        local filtered = {}
        for _, item in ipairs(list) do
            if item.bundledItems then
                table.insert(filtered, item)
            end
        end
        if #filtered == 0 then return nil end
        return filtered[math.random(1, #filtered)]
    end
    return list[math.random(1, #list)]
end
function updateRandomSlotBlocker(frontFrame, enable)
    if not frontFrame then return end
    local slot = frontFrame:FindFirstChild("1")
    if not slot or not slot:IsA("ImageLabel") then return end

    local blocker = slot:FindFirstChild("RandomBlocker")
    if enable then
        if not blocker then
            blocker = Instance.new("ImageButton")
            blocker.Name = "RandomBlocker"
            blocker.BackgroundTransparency = 1
            blocker.Size = UDim2.new(1, 0, 1, 0)
            blocker.Position = UDim2.new(0, 0, 0, 0)
            blocker.AutoButtonColor = false
            blocker.ZIndex = slot.ZIndex + 10
            blocker.Parent = slot
        else
            blocker.ZIndex = slot.ZIndex + 10
        end
        blocker.Active = true
    else
        if blocker then blocker:Destroy() end
        if State.randomSlotBlockerConn then
            State.randomSlotBlockerConn:Disconnect()
            State.randomSlotBlockerConn = nil
        end
    end
end

function clearCustomHitboxes()
    if State.randomSlotBlockerConn then
        State.randomSlotBlockerConn:Disconnect()
        State.randomSlotBlockerConn = nil
    end
    local success, frontFrame = pcall(function()
        return game:GetService("CoreGui").RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Front.EmotesButtons
    end)
    if not success or not frontFrame then return end
    local slot1 = frontFrame:FindFirstChild("1")
    if slot1 then
        local blocker = slot1:FindFirstChild("RandomBlocker")
        if blocker then blocker:Destroy() end
    end
    for _, child in pairs(frontFrame:GetChildren()) do
        if child:IsA("ImageLabel") then
            child.Active = false
        end
    end
    frontFrame.Active = true   
end

function applyEmotesButtonsActiveState()
end

function setEmotesButtonsActiveForFavorites()
    local success, frontFrame = pcall(function()
        return game:GetService("CoreGui").RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Front.EmotesButtons
    end)
    if not success or not frontFrame then return end
    for _, child in pairs(frontFrame:GetChildren()) do
        if child:IsA("ImageLabel") then
            child.Active = true
        end
    end
    frontFrame.Active = true
end

function updateScriptPriorityOverlay()
    local success, frontFrame = pcall(function()
        return game:GetService("CoreGui").RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Front.EmotesButtons
    end)
    if not success or not frontFrame then return end

    local enable = (State.favoriteEnabled or State.currentMode == "animation" or State.customAnimationEditorActive)
    local blocker = frontFrame:FindFirstChild("ScriptPriorityBlocker")
    if enable then
        if not blocker then
            blocker = Instance.new("ImageButton")
            blocker.Name = "ScriptPriorityBlocker"
            blocker.BackgroundTransparency = 1
            blocker.Size = UDim2.new(1, 0, 1, 0)
            blocker.Position = UDim2.new(0, 0, 0, 0)
            blocker.AutoButtonColor = false
            blocker.ZIndex = 9999
            blocker.Parent = frontFrame
            
            blocker.InputBegan:Connect(function(input)
                if State.hudEditorActive then return end
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
                
                local okWheel, emotesWheel = pcall(function()
                    return game:GetService("CoreGui").RobloxGui.EmotesMenu.Children.Main.EmotesWheel
                end)
                if not (okWheel and emotesWheel) then return end
                if not emotesWheel.Visible then return end

                local actualPos = Vector2.new(input.Position.X, input.Position.Y)
                local absPos = emotesWheel.AbsolutePosition
                local absSize = emotesWheel.AbsoluteSize

                local inXBounds = (actualPos.X >= absPos.X) and (actualPos.X <= absPos.X + absSize.X)
                local inYBounds = (actualPos.Y >= absPos.Y) and (actualPos.Y <= absPos.Y + absSize.Y)
                if not (inXBounds and inYBounds) then return end

                local center = absPos + (absSize / 2)
                local dx = actualPos.X - center.X
                local dy = actualPos.Y - center.Y

                local distance = math.sqrt(dx*dx + dy*dy)
                local radius = math.min(absSize.X, absSize.Y) * 0.5
                if distance > radius then return end
                local dynamicDeadzone = radius * 0.2
                if distance < dynamicDeadzone then return end

                local sectorAngle = 360 / 8
                local angle = math.deg(math.atan2(dy, dx))
                local correctedAngle = (angle + 90 + (sectorAngle / 2)) % 360
                local index = math.floor(correctedAngle / sectorAngle) + 1
                if not (State.customAnimationEditorActive or State.favoriteEnabled or State.currentMode == "animation" or (index == 1 and isRandomSlotActive())) then return end

                handleSectorAction(index)
            end)
        end
        blocker.Active = true
    else
        if blocker then blocker:Destroy() end
    end
end

function applyRandomSlotVisual(frontFrame)
    if not frontFrame then return end
    local slot = frontFrame:FindFirstChild("1")
    if slot and slot:IsA("ImageLabel") then
        if not isRandomSlotEnabled() then
            AnimationSystem.ResetRandomSlot(frontFrame)
            return
        end
        if slot.Image ~= RANDOM_SLOT_ICON then
            slot.Image = RANDOM_SLOT_ICON
        end
        if slot.ImageColor3 ~= RANDOM_SLOT_COLOR then
            slot.ImageColor3 = RANDOM_SLOT_COLOR
        end
        if State.currentMode == "emote" then
            updateRandomSlotBlocker(frontFrame, true)
        else
            updateRandomSlotBlocker(frontFrame, false)
        end
        local idValue = slot:FindFirstChild("AnimationID")
        if idValue then idValue:Destroy() end
        local favoriteIcon = slot:FindFirstChild("FavoriteIcon")
        if favoriteIcon then favoriteIcon:Destroy() end
    end
end

function resetRandomSlotColor(frontFrame)
    if not frontFrame then return end
    local slot = frontFrame:FindFirstChild("1")
    if slot and slot:IsA("ImageLabel") then
        if slot.ImageColor3 == RANDOM_SLOT_COLOR then
            slot.ImageColor3 = Color3.new(1, 1, 1)
        end
        if slot.Image == RANDOM_SLOT_ICON then
            slot.Image = ""
        end
    end
    updateRandomSlotBlocker(frontFrame, false)
    if State.randomSpamConn then
        State.randomSpamConn:Disconnect()
        State.randomSpamConn = nil
    end
end

function applySearchSlot1Image()
    pcall(function()
        local frontFrame = game:GetService("CoreGui").RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Front.EmotesButtons
        local slot1 = frontFrame and frontFrame:FindFirstChild("1")
        local slot2 = frontFrame and frontFrame:FindFirstChild("2")
        if slot1 and slot1:IsA("ImageLabel") and slot2 and slot2:IsA("ImageLabel") then
            local img2 = slot2.Image
            if img2 and img2 ~= "" then
                slot1.Image = img2
            end
        end
    end)
end

function bumpImageUpdateToken()
    State.imageUpdateToken = State.imageUpdateToken + 1
end

local ContentProvider = game:GetService("ContentProvider")
function preloadThumbnail(url)
    if not url or url == "" then return end
    task.spawn(function()
        pcall(function()
            ContentProvider:PreloadAsync({Instance.new("ImageLabel", {Image = url})})
        end)
    end)
end

function enforceImages()
    local success, frontFrame = pcall(function()
        return game:GetService("CoreGui").RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Front.EmotesButtons
    end)
    if not success or not frontFrame then return end
    
    local token = State.imageUpdateToken
    for slotName, targetImg in pairs(State.targetImages) do
        local slot = frontFrame:FindFirstChild(slotName)
        if slot and slot:IsA("ImageLabel") then
            if slot.Image ~= targetImg then
                slot.Image = targetImg
            end
            if slotName == "1" and isRandomSlotActive() then
                if slot.ImageColor3 ~= RANDOM_SLOT_COLOR then
                    slot.ImageColor3 = RANDOM_SLOT_COLOR
                end
            end
        end
    end
end

function spamRandomSlotVisual(frontFrame, token)
    if not frontFrame then return end
    State.targetImages["1"] = RANDOM_SLOT_ICON
    enforceImages()
end

function spamAnimationImages(frontFrame, imageMap, token)
    if not frontFrame then return end
    for k, v in pairs(imageMap or {}) do
        State.targetImages[k] = v
    end
    enforceImages()
end


function getEmoteName(assetId)
    local success, productInfo = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(tonumber(assetId))
    end)
    
    if success and productInfo then
        return productInfo.Name
    else
        return "Emote_" .. tostring(assetId)
    end
end

isInFavorites = function(assetId)
    if not assetId then return false end
    if State.favoriteSetBuiltVersion ~= State.favoriteSetVersion then
        State.favoriteEmoteSet = {}
        for _, favorite in pairs(State.favoriteEmotes) do
            if favorite.id then
                State.favoriteEmoteSet[tostring(favorite.id)] = true
            end
        end
        State.favoriteAnimationSet = {}
        for _, favorite in pairs(State.favoriteAnimations) do
            if favorite.id then
                State.favoriteAnimationSet[tostring(favorite.id)] = true
            end
        end
        State.favoriteSetBuiltVersion = State.favoriteSetVersion
    end
    if State.currentMode == "animation" then
        return State.favoriteAnimationSet[tostring(assetId)] == true
    end
    return State.favoriteEmoteSet[tostring(assetId)] == true
end

function rebuildEmoteNormalCache()
    if State.emotePageCache.version == State.emoteCacheVersion and State.emotePageCache.favVersion == State.favoriteSetVersion then
        return
    end
    if State.favoriteSetBuiltVersion ~= State.favoriteSetVersion then
        State.favoriteEmoteSet = {}
        for _, favorite in pairs(State.favoriteEmotes) do
            State.favoriteEmoteSet[tostring(favorite.id)] = true
        end
        State.favoriteAnimationSet = {}
        for _, favorite in pairs(State.favoriteAnimations) do
            State.favoriteAnimationSet[tostring(favorite.id)] = true
        end
        State.favoriteSetBuiltVersion = State.favoriteSetVersion
    end
    local normal = {}
    for _, emote in ipairs(State.filteredEmotes) do
        if not State.favoriteEmoteSet[tostring(emote.id)] then
            table.insert(normal, emote)
        end
    end
    State.emotePageCache.normal = normal
    State.emotePageCache.version = State.emoteCacheVersion
    State.emotePageCache.favVersion = State.favoriteSetVersion
end

function rebuildAnimationNormalCache()
    if State.animationPageCache.version == State.animationCacheVersion and State.animationPageCache.favVersion == State.favoriteSetVersion then
        return
    end
    if State.favoriteSetBuiltVersion ~= State.favoriteSetVersion then
        State.favoriteEmoteSet = {}
        for _, favorite in pairs(State.favoriteEmotes) do
            State.favoriteEmoteSet[tostring(favorite.id)] = true
        end
        State.favoriteAnimationSet = {}
        for _, favorite in pairs(State.favoriteAnimations) do
            State.favoriteAnimationSet[tostring(favorite.id)] = true
        end
        State.favoriteSetBuiltVersion = State.favoriteSetVersion
    end
    local normal = {}
    for _, animation in ipairs(State.filteredAnimations) do
        if not State.favoriteAnimationSet[tostring(animation.id)] then
            table.insert(normal, animation)
        end
    end
    State.animationPageCache.normal = normal
    State.animationPageCache.version = State.animationCacheVersion
    State.animationPageCache.favVersion = State.favoriteSetVersion
end

function getCustomSetIcon(setName)
    local set = State.CustomAnimations and State.CustomAnimations.Sets and State.CustomAnimations.Sets[setName]
    local meta = set and set.__meta or {}
    local iconImage = meta.IconImage or DEFAULT_IDLE_ICON_ID
    local iconColor = TableToColor(meta.IconColor or ColorToTable(DEFAULT_IDLE_ICON_COLOR))
    return iconImage, iconColor
end

function IsCustomSetData(data)
    if not data then return false end
    if data.isCustomSet then return true end
    local idNum = tonumber(data.id)
    return idNum and idNum < 0 or false
end

function GetCustomSetName(data)
    if not data then return nil end
    local name = data.customSetName or data.name
    if type(name) == "string" then
        name = name:gsub("%s*%-.*$", "")
    end
    return name
end

function updateAnimationImages(currentPageAnimations, randomActive)
    local token = State.imageUpdateToken
    local success, frontFrame = pcall(function()
        return game:GetService("CoreGui").RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Front.EmotesButtons
    end)
    
    if not success or not frontFrame then
        return
    end

    if randomActive then
        applyRandomSlotVisual(frontFrame)
        State.targetImages = {["1"] = RANDOM_SLOT_ICON}
        spamRandomSlotVisual(frontFrame, token)
    else
        State.targetImages = {}
        resetRandomSlotColor(frontFrame)
    end

    local startSlot = randomActive and 2 or 1
    local imageMap = {}
    local newTargetImages = {}
    if randomActive then
        newTargetImages["1"] = RANDOM_SLOT_ICON
    end

    for i = 1, 12 do
        if i >= startSlot then
            local listIndex = randomActive and (i - 1) or i
            local animationData = currentPageAnimations[listIndex]
            if animationData and animationData.id then
                local idStr = tostring(animationData.id)
                local image
                if IsCustomSetData(animationData) then
                    local customImage = getCustomSetIcon(GetCustomSetName(animationData) or animationData.name)
                    image = GetAsset(customImage)
                else
                    image = "rbxthumb://type=BundleThumbnail&id=" .. idStr .. "&w=420&h=420"
                end
                newTargetImages[tostring(i)] = image
                imageMap[tostring(i)] = image
            else
                newTargetImages[tostring(i)] = ""
                imageMap[tostring(i)] = ""
            end
        end
    end
    
    State.targetImages = newTargetImages

    for slotName, image in pairs(imageMap) do
        local child = frontFrame:FindFirstChild(slotName)
        if child and child:IsA("ImageLabel") then
            preloadThumbnail(image)
            child.Image = image
            
            local listIndex = randomActive and (tonumber(slotName) - 1) or tonumber(slotName)
            local animationData = currentPageAnimations[listIndex]
            if animationData and animationData.id then
                local idValue = child:FindFirstChild("AnimationID") or Instance.new("IntValue")
                idValue.Name = "AnimationID"
                idValue.Value = tonumber(animationData.id) or 0
                idValue.Parent = child
                
                if IsCustomSetData(animationData) then
                    local _, customColor = getCustomSetIcon(GetCustomSetName(animationData) or animationData.name)
                    child.ImageColor3 = customColor
                else
                    child.ImageColor3 = Color3.new(1, 1, 1)
                end
            elseif not randomActive and child.ImageColor3 == RANDOM_SLOT_COLOR then
                child.ImageColor3 = Color3.new(1, 1, 1)
            end
        end
    end
    
    applyEmotesButtonsActiveState()
end


function updateFavoriteIcon(imageLabel, assetId, isFavorite)
    local favoriteIcon = imageLabel:FindFirstChild("FavoriteIcon")
    
    if not favoriteIcon then
        favoriteIcon = Instance.new("ImageLabel")
        favoriteIcon.Name = "FavoriteIcon"
        favoriteIcon.Size = UDim2.new(0.3, 0, 0.3, 0) 
        favoriteIcon.Position = UDim2.new(0.7, 0, 0, 0)
        favoriteIcon.AnchorPoint = Vector2.new(0, 0)
        favoriteIcon.BackgroundTransparency = 1
        favoriteIcon.ZIndex = imageLabel.ZIndex + 5
        favoriteIcon.ScaleType = Enum.ScaleType.Fit
        favoriteIcon.Parent = imageLabel
    end
    
    if isFavorite then
        favoriteIcon.Image = State.favoriteIconId
    else
        favoriteIcon.Image = State.notFavoriteIconId 
    end
end

function updateAllFavoriteIcons()
    local success, frontFrame = pcall(function()
        return game:GetService("CoreGui").RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Front.EmotesButtons
    end)
    
    if success and frontFrame then
        if not State.favoriteEnabled then
            for _, child in pairs(frontFrame:GetChildren()) do
                if child:IsA("ImageLabel") then
                    local favoriteIcon = child:FindFirstChild("FavoriteIcon")
                    if favoriteIcon then favoriteIcon:Destroy() end
                end
            end
            return
        end
        local randomActive = isRandomSlotActive()
        for _, child in pairs(frontFrame:GetChildren()) do
            if child:IsA("ImageLabel") and child.Image ~= "" and (not randomActive or child.Name ~= "1") then
                local assetId
                if State.currentMode == "animation" then
                    local idValue = child:FindFirstChild("AnimationID")
                    if idValue then
                        assetId = idValue.Value
                    end
                else
                    assetId = extractAssetId(child.Image)
                end
                
                if assetId then
                    local isFavorite = isInFavorites(assetId)
                    updateFavoriteIcon(child, assetId, isFavorite)
                end
            end
        end
        applyEmotesButtonsActiveState()
    end
end

function updateAnimations()
    local character, humanoid = getCharacterAndHumanoid()
    if not character or not humanoid then
        return
    end

    local humanoidDescription = humanoid.HumanoidDescription
    if not humanoidDescription then
        if not State.pendingAnimRetry then
            State.pendingAnimRetry = true
            task.delay(0.2, function()
                State.pendingAnimRetry = false
                if State.currentMode == "animation" then
                    updateAnimations()
                end
            end)
        end
        return
    end

    bumpImageUpdateToken()
    rebuildAnimationNormalCache()

    local currentPageAnimations = {}
    local animationTable = {}
    local equippedAnimations = {}

    local categories = getCategoryStats()
    local accumulatedPages = 0
    local currentCat = nil
    
    for _, cat in ipairs(categories) do
        if State.currentPage <= accumulatedPages + cat.pages then
            local adjustedPage = State.currentPage - accumulatedPages
            currentPageAnimations = getListSlice(cat.list, adjustedPage, cat.hasRandom)
            currentCat = cat
            break
        end
        accumulatedPages = accumulatedPages + cat.pages
    end

    local randomActive = isRandomSlotActive()
    if randomActive then
        local randomFallback = currentPageAnimations[1] or (State.filteredAnimations and State.filteredAnimations[1])
        if randomFallback then
            animationTable["Random Animation"] = {randomFallback.id}
            table.insert(equippedAnimations, "Random Animation")
        end
    end

    State.animImageRetry = 0
    for _, animation in pairs(currentPageAnimations) do
        local animationName = animation.name
        local animationId = animation.id
        animationTable[animationName] = {animationId}
        table.insert(equippedAnimations, animationName)
    end

    humanoidDescription:SetEmotes(animationTable)
    humanoidDescription:SetEquippedEmotes(equippedAnimations)
    
    updateAnimationImages(currentPageAnimations, randomActive)
    if State.favoriteEnabled then
        setEmotesButtonsActiveForFavorites()
    end

    task.delay(0.2, function()
        if State.favoriteEnabled then
            setEmotesButtonsActiveForFavorites()
        end
        if State.favoriteEnabled then
            updateAllFavoriteIcons()
        end
    end)
end

updateEmotes = function()
    local character, humanoid = getCharacterAndHumanoid()
    if not character or not humanoid then
        return
    end

    if State.currentMode == "animation" then
        updateAnimations()
        return
    end
    
    bumpImageUpdateToken()
    local token = State.imageUpdateToken
    
    if State.animImageSpamConn then
        State.animImageSpamConn:Disconnect()
        State.animImageSpamConn = nil
        State.animImageSpamMap = nil
        State.animImageSpamTicks = nil
        State.animImageSpamToken = State.animImageSpamToken + 1
    end

    local humanoidDescription = humanoid.HumanoidDescription
    if not humanoidDescription then
        return
    end

    local currentPageEmotes = {}
    local emoteTable = {}
    local equippedEmotes = {}

    rebuildEmoteNormalCache()
    local categories = getCategoryStats()
    local accumulatedPages = 0
    local currentCat = nil
    
    for _, cat in ipairs(categories) do
        if State.currentPage <= accumulatedPages + cat.pages then
            local adjustedPage = State.currentPage - accumulatedPages
            currentPageEmotes = getListSlice(cat.list, adjustedPage, cat.hasRandom)
            currentCat = cat
            break
        end
        accumulatedPages = accumulatedPages + cat.pages
    end

    local randomActive = isRandomSlotActive()
    if randomActive then
        local randomFallback = currentPageEmotes[1] or (State.filteredEmotes and State.filteredEmotes[1])
        if randomFallback then
            emoteTable["Random Emote"] = {randomFallback.id}
            table.insert(equippedEmotes, "Random Emote")
        end
    end

    for _, emote in pairs(currentPageEmotes) do
        local emoteName = emote.name
        local emoteId = emote.id
        emoteTable[emoteName] = {emoteId}
        table.insert(equippedEmotes, emoteName)
    end

    humanoidDescription:SetEmotes(emoteTable)
    humanoidDescription:SetEquippedEmotes(equippedEmotes)
    
    local newTargetImages = {}
    if randomActive then
        newTargetImages["1"] = RANDOM_SLOT_ICON
    end

    local startSlot = randomActive and 2 or 1
    for i = 1, 12 do
        if i >= startSlot then
            local listIndex = randomActive and (i - 1) or i
            local emoteData = currentPageEmotes[listIndex]
            if emoteData and emoteData.id then
                local idStr = tostring(emoteData.id)
                newTargetImages[tostring(i)] = "rbxthumb://type=Asset&id=" .. idStr .. "&w=420&h=420"
            else
                newTargetImages[tostring(i)] = ""
            end
        end
    end
    
    State.targetImages = newTargetImages

    local success, frontFrame = pcall(function()
        return game:GetService("CoreGui").RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Front.EmotesButtons
    end)
    
    if success and frontFrame then
        for slotName, image in pairs(newTargetImages) do
            local child = frontFrame:FindFirstChild(slotName)
            if child and child:IsA("ImageLabel") then
                child.Image = image
                if slotName == "1" and randomActive then
                    child.ImageColor3 = RANDOM_SLOT_COLOR
                else
                    child.ImageColor3 = Color3.new(1, 1, 1)
                end
            end
        end
        
        if State.favoriteEnabled then
            setEmotesButtonsActiveForFavorites()
        end
        if randomActive then
            applyRandomSlotVisual(frontFrame)
            spamRandomSlotVisual(frontFrame, token)
        else
            resetRandomSlotColor(frontFrame)
        end
    end

    task.delay(0.2, function()
        if State.favoriteEnabled then
            setEmotesButtonsActiveForFavorites()
        end
        if State.favoriteEnabled then
            updateAllFavoriteIcons()
        end
    end)
end

calculateTotalPages = function()
    rebuildEmoteNormalCache()
    rebuildAnimationNormalCache()

    local categories = getCategoryStats()
    local total = 0
    for _, cat in ipairs(categories) do
        total = total + cat.pages
    end
    return math.max(total, 1)
end

function isGivenAnimation(animationHolder, animationId)
    for _, animation in animationHolder:GetChildren() do
        if animation:IsA("Animation") and urlToId(animation.AnimationId) == animationId then
            return true
        end
    end
    return false
end

local function isToolAnimation(animationTrack)
    local animation = animationTrack and animationTrack.Animation
    if not animation then return false end
    local current = animation.Parent
    while current do
        if current:IsA("Tool") then
            return true
        end
        current = current.Parent
    end
    return false
end

local function findAnimationInDescendants(folder, animationId)
    if not folder then return false end
    for _, obj in ipairs(folder:GetDescendants()) do
        if obj:IsA("Animation") and urlToId(obj.AnimationId) == animationId then
            return true
        end
    end
    return false
end

local toolAnimationIds = {}

local function refreshToolAnimationIds()
    local newSet = {}
    local function addFrom(container)
        if not container then return end
        for _, tool in ipairs(container:GetChildren()) do
            if tool:IsA("Tool") then
                for _, obj in ipairs(tool:GetDescendants()) do
                    if obj:IsA("Animation") then
                        local animId = urlToId(obj.AnimationId)
                        if animId ~= "" and animId ~= "0" then
                            newSet[animId] = true
                        end
                    end
                end
            end
        end
    end
    addFrom(player.Character)
    addFrom(player.Backpack)
    toolAnimationIds = newSet
end

function isDancing(character, animationTrack)
    if not character or not character.Animate or not animationTrack or not animationTrack.Animation then
        return false
    end
    if isToolAnimation(animationTrack) then
        return false
    end
    local animationId = urlToId(animationTrack.Animation.AnimationId)
    if toolAnimationIds[animationId] then
        return false
    end
    if findAnimationInDescendants(character.Animate:FindFirstChild("Tools"), animationId) then
        return false
    end
    for _, animationHolder in character.Animate:GetChildren() do
        if animationHolder:IsA("StringValue") then
            local sharesAnimationId = isGivenAnimation(animationHolder, animationId)
            if sharesAnimationId then
                return false
            end
        end
    end
    return true
end

function createGUIElements()
    local exists, emotesWheel = checkEmotesMenuExists()
    if not exists then
        return false
    end

    if UI.CustomFrames then
        for _, frame in pairs(UI.CustomFrames) do
            if frame and frame.Parent then frame:Destroy() end
        end
    end
    UI.CustomFrames = {}

    if emotesWheel:FindFirstChild("Under") then
        emotesWheel.Under:Destroy()
    end
    if emotesWheel:FindFirstChild("Top") then
        emotesWheel.Top:Destroy()
    end
    if emotesWheel:FindFirstChild("EmoteWalkButton") then
        emotesWheel.EmoteWalkButton:Destroy()
    end
    if emotesWheel:FindFirstChild("Favorite") then
        emotesWheel.Favorite:Destroy()
    end
    if emotesWheel:FindFirstChild("SpeedEmote") then
        emotesWheel.SpeedEmote:Destroy()
    end
    if emotesWheel:FindFirstChild("Changepage") then
        emotesWheel.Changepage:Destroy()
    end
    if emotesWheel:FindFirstChild("SpeedBox") then
        emotesWheel.SpeedBox:Destroy()
    end
    if emotesWheel:FindFirstChild("Reload") then
        emotesWheel.Reload:Destroy()
    end

    UI.Under = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    UI._1left = Instance.new("ImageButton")
    UI._9right = Instance.new("ImageButton")
    UI._4pages = Instance.new("TextLabel")
    UI._3TextLabel = Instance.new("TextLabel")
    UI._2Routenumber = Instance.new("TextBox")
    UI.EmoteWalkButton = Instance.new("ImageButton")
    local UICorner_Left = Instance.new("UICorner")
    UICorner_Left.CornerRadius = UDim.new(0, 10)
    UICorner_Left.Parent = UI._1left
    
    local UICorner_Right = Instance.new("UICorner")
    UICorner_Right.CornerRadius = UDim.new(0, 10)
    UICorner_Right.Parent = UI._9right

    local UICorner1 = Instance.new("UICorner")
    UI.Top = Instance.new("Frame")
    local UIListLayout_2 = Instance.new("UIListLayout")
    local UICorner = Instance.new("UICorner")
    UI.Search = Instance.new("TextBox")
    UI.Favorite = Instance.new("ImageButton")
    local UICorner2 = Instance.new("UICorner")
    UI.SpeedBox = Instance.new("TextBox")
    local UICorner_4 = Instance.new("UICorner")
    UI.SpeedEmote = Instance.new("ImageButton")
    local UICorner_2 = Instance.new("UICorner")
    UI.Changepage = Instance.new("ImageButton")
    local UICorner_5 = Instance.new("UICorner")
    UI.Reload = Instance.new("ImageButton")
    local UICorner_6 = Instance.new("UICorner")

    UI.Under.Name = "Under"
    UI.Under.Parent = emotesWheel
    UI.Under.BackgroundTransparency = 1.000
    UI.Under.BorderSizePixel = 0
    UI.Under.Position = UDim2.new(0.129999995, 0, 1, 0)
    UI.Under.Size = UDim2.new(0.737500012, 0, 0.132499993, 0)

    UIListLayout.Parent = UI.Under
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    UI._1left.Name = "1left"
    UI._1left.Parent = UI.Under
    UI._1left.BackgroundTransparency = 1.000
    UI._1left.BorderSizePixel = 0
    UI._1left.Size = UDim2.new(0.169491529, 0, 0.94339627, 0)
    UI._1left.Image = "rbxassetid://93111945058621"
    UI._1left.ImageColor3 = Color3.fromRGB(0, 0, 0)
    UI._1left.ImageTransparency = 0.400

    UI._9right.Name = "9right"
    UI._9right.Parent = UI.Under
    UI._9right.BackgroundTransparency = 1.000
    UI._9right.BorderSizePixel = 0
    UI._9right.Size = UDim2.new(0.169491529, 0, 0.94339627, 0)
    UI._9right.Image = "rbxassetid://107938916240738"
    UI._9right.ImageColor3 = Color3.fromRGB(0, 0, 0)
    UI._9right.ImageTransparency = 0.400

    UI._4pages.Name = "4pages"
    UI._4pages.Parent = UI.Under
    UI._4pages.BackgroundTransparency = 1.000
    UI._4pages.BorderSizePixel = 0
    UI._4pages.Size = UDim2.new(0.159322038, 0, 0.811320841, 0)
    UI._4pages.Font = Enum.Font.SourceSansBold
    UI._4pages.Text = "1"
    UI._4pages.TextColor3 = Color3.fromRGB(0, 0, 0)
    UI._4pages.TextScaled = true
    UI._4pages.TextSize = 14.000
    UI._4pages.TextTransparency = 0.400
    UI._4pages.TextWrapped = true

    UI._3TextLabel.Name = "3TextLabel"
    UI._3TextLabel.Parent = UI.Under
    UI._3TextLabel.BackgroundTransparency = 1.000
    UI._3TextLabel.BorderSizePixel = 0
    UI._3TextLabel.Size = UDim2.new(0.338983059, 0, 0.94339627, 0)
    UI._3TextLabel.Font = Enum.Font.SourceSansBold
    UI._3TextLabel.Text = " ------ "
    UI._3TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    UI._3TextLabel.TextScaled = true
    UI._3TextLabel.TextSize = 14.000
    UI._3TextLabel.TextTransparency = 0.400
    UI._3TextLabel.TextWrapped = true

    UI._2Routenumber.Name = "2Route-number"
    UI._2Routenumber.Parent = UI.Under
    UI._2Routenumber.Active = true
    UI._2Routenumber.BackgroundTransparency = 1.000
    UI._2Routenumber.BorderSizePixel = 0
    UI._2Routenumber.Size = UDim2.new(0.159322038, 0, 0.811320841, 0)
    UI._2Routenumber.Font = Enum.Font.SourceSansBold
    UI._2Routenumber.PlaceholderColor3 = Color3.fromRGB(0, 0, 0)
    UI._2Routenumber.Text = "1"
    UI._2Routenumber.TextColor3 = Color3.fromRGB(0, 0, 0)
    UI._2Routenumber.TextScaled = true
    UI._2Routenumber.TextSize = 14.000
    UI._2Routenumber.TextTransparency = 0.400
    UI._2Routenumber.TextWrapped = true

    UI.Top.Name = "Top"
    UI.Top.Parent = emotesWheel
    UI.Top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    UI.Top.BackgroundTransparency = 0.400
    UI.Top.BorderSizePixel = 0
    UI.Top.Position = UDim2.new(0.127499998, 0, -0.109999999, 0)
    UI.Top.Size = UDim2.new(0.737500012, 0, 0.0949999914, 0)

    UIListLayout_2.Parent = UI.Top
    UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center

    UICorner.CornerRadius = UDim.new(0, 20)
    UICorner.Parent = UI.Top

    UI.Search.Name = "Search"
    UI.Search.Parent = UI.Top
    UI.Search.BackgroundTransparency = 1.000
    UI.Search.Size = UDim2.new(0.864406765, 0, 0.81578958, 0)
    UI.Search.Font = Enum.Font.SourceSansBold
    UI.Search.PlaceholderText = "Search/ID"
    UI.Search.Text = ""
    UI.Search.TextColor3 = Color3.fromRGB(255, 255, 255)
    UI.Search.TextScaled = true
    UI.Search.TextSize = 14.000
    UI.Search.TextWrapped = true

    UI.EmoteWalkButton.Name = "EmoteWalkButton"
    UI.EmoteWalkButton.Parent = emotesWheel
    UI.EmoteWalkButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    UI.EmoteWalkButton.BackgroundTransparency = 0.400
    UI.EmoteWalkButton.BorderSizePixel = 0
    UI.EmoteWalkButton.Position = UDim2.new(0.889999986, 0, -0.107500002, 0)
    UI.EmoteWalkButton.Size = UDim2.new(0.0874999985, 0, 0.0874999985, 0)
    UI.EmoteWalkButton.Image = State.defaultButtonImage

    UICorner1.CornerRadius = UDim.new(0, 10)
    UICorner1.Parent = UI.EmoteWalkButton

    UI.Favorite.Name = "Favorite"
    UI.Favorite.Parent = emotesWheel
    UI.Favorite.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    UI.Favorite.BackgroundTransparency = 0.400
    UI.Favorite.BorderSizePixel = 0
    UI.Favorite.Position = UDim2.new(0.0189999994, 0, -0.108000003, 0)
    UI.Favorite.Size = UDim2.new(0.0874999985, 0, 0.0874999985, 0)
    UI.Favorite.Image = "rbxassetid://124025954365505"

    UICorner2.CornerRadius = UDim.new(0, 10)
    UICorner2.Parent = UI.Favorite

    UI.SpeedBox.Name = "SpeedBox"
    UI.SpeedBox.Parent = emotesWheel
    UI.SpeedBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    UI.SpeedBox.BackgroundTransparency = 0.400
    UI.SpeedBox.BorderSizePixel = 0
    UI.SpeedBox.Position = UDim2.new(0.0189999398, 0, -0.000499992399, 0)
    UI.SpeedBox.Size = UDim2.new(0.0874999985, 0, 0.0874999985, 0)
    UI.SpeedBox.Visible = false
    UI.SpeedBox.Font = Enum.Font.SourceSansBold
    UI.SpeedBox.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
    UI.SpeedBox.Text = "1"
    UI.SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    UI.SpeedBox.TextScaled = true
    UI.SpeedBox.TextWrapped = true
    UI.SpeedBox:GetPropertyChangedSignal("Text"):Connect(function()
       UI.SpeedBox.Text = UI.SpeedBox.Text:gsub("[^%d.]", "")
    end)
    UI.SpeedBox.ZIndex = 2

    UICorner_4.CornerRadius = UDim.new(0, 10)
    UICorner_4.Parent = UI.SpeedBox

    UI.SpeedEmote.Name = "SpeedEmote"
    UI.SpeedEmote.Parent = emotesWheel
    UI.SpeedEmote.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    UI.SpeedEmote.BackgroundTransparency = 0.400
    UI.SpeedEmote.BorderSizePixel = 0
    UI.SpeedEmote.Position = UDim2.new(0.888999999, 0, -0, 0)
    UI.SpeedEmote.Size = UDim2.new(0.0874999985, 0, 0.0874999985, 0)
    UI.SpeedEmote.Image = "rbxassetid://116056570415896"
    UI.SpeedEmote.ZIndex = 2

    UICorner_2.CornerRadius = UDim.new(0, 10)
    UICorner_2.Parent = UI.SpeedEmote

UI.Changepage.Name = "Changepage"
UI.Changepage.Parent = emotesWheel
UI.Changepage.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
UI.Changepage.BackgroundTransparency = 0.400
UI.Changepage.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.Changepage.BorderSizePixel = 0
UI.Changepage.Position = UDim2.new(0.019, 0,1.021, 0)
UI.Changepage.Size = UDim2.new(0.087, 0,0.087, 0)
UI.Changepage.ZIndex = 3
UI.Changepage.Image = "rbxassetid://13285615740"

UICorner_5.CornerRadius = UDim.new(0, 10)
UICorner_5.Parent = UI.Changepage

    UI.Reload.Name = "Reload"
    UI.Reload.Parent = emotesWheel
    UI.Reload.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    UI.Reload.BackgroundTransparency = 0.400
    UI.Reload.BorderSizePixel = 0
    UI.Reload.Position = UDim2.new(0.888999999, 0, 1.02100003, 0)
    UI.Reload.Size = UDim2.new(0.0869999975, 0, 0.0869999975, 0)
    UI.Reload.ZIndex = 3
    UI.Reload.Image = "rbxassetid://127493377027615"

    UICorner_6.CornerRadius = UDim.new(0, 10)
    UICorner_6.Parent = UI.Reload

    local function spawnCustomFrame(name, zIndex)
        local cf = Instance.new("Frame")
        cf.Name = name
        cf.Parent = emotesWheel
        cf.BackgroundColor3 = Color3.fromRGB(0,0,0)
        cf.BackgroundTransparency = 0.4
        cf.ZIndex = zIndex or 3
        cf.BorderSizePixel = 0
        cf.Active = true
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = cf

        if not UI.CustomFrames then UI.CustomFrames = {} end
        UI.CustomFrames[name] = cf

        return cf
    end

    local function recordDefaults()
        local allMovable = getMovableElements()
        for name, el in pairs(allMovable) do
             HUD.DefaultPositions[name] = el.Position
             HUD.DefaultSizes[name] = el.Size
             if el:IsA("TextLabel") or el:IsA("TextBox") then
                 HUD.DefaultTexts[name] = el.Text
                 if el:IsA("TextBox") then
                     HUD.DefaultPlaceholders[name] = el.PlaceholderText
                 end
             end
        end
    end
    
    if Config.CustomFrames then
        for name, data in pairs(Config.CustomFrames) do
            spawnCustomFrame(name, data.ZIndex or 3)
        end
    end
    
    recordDefaults()
    loadSpeedEmoteConfig()

    connectEvents()
    State.isGUICreated = true
    
    ApplyTheme(themes[currentThemeName] or themes.Default)
    
    updateGUIColors()
    
    ApplyUIVisibility()
    
    if ApplyFreezeButtonVisual then ApplyFreezeButtonVisual() end
    if applySavedPositions then applySavedPositions() end
    if updateHUDLayouts then updateHUDLayouts() end
    
    return true
end

updatePageDisplay = function()
    if UI._4pages and UI._2Routenumber then
        UI._4pages.Text = tostring(State.totalPages)
        UI._2Routenumber.Text = tostring(State.currentPage)
    end
end


toggleFavorite = function(emoteId, emoteName)
    local found = false
    local index = 0

    for i, fav in pairs(State.favoriteEmotes) do
        if tostring(fav.id) == tostring(emoteId) then
            found = true
            index = i
            break
        end
    end

    if found then
        table.remove(State.favoriteEmotes, index)
        getgenv().Notify({
            Title = '7yd7 | Favorite System',
            Content = '🗑️ Removed "' .. emoteName .. '" from favorites',
            Duration = 3
        })
    else
        table.insert(State.favoriteEmotes, {
            id = emoteId,
            name = emoteName .. " - ⭐"
        })
        getgenv().Notify({
            Title = '7yd7 | Favorite System',
            Content = '✅ Added "' .. emoteName .. '" to favorites',
            Duration = 3
        })
    end

    State.EmotePages.Sets[State.currentEmotePageName] = DeepCopy(State.favoriteEmotes)
    State.SaveEmotePages(State.EmotePages)

    State.favoriteSetVersion = State.favoriteSetVersion + 1
    State.totalPages = calculateTotalPages()
    updatePageDisplay()
    updateEmotes()
    updateAllFavoriteIcons()
end


toggleFavoriteAnimation = function(animationData)
    local found = false
    local index = 0

    for i, fav in pairs(State.favoriteAnimations) do
        if fav.id == animationData.id then
            found = true
            index = i
            break
        end
    end

    if found then
        table.remove(State.favoriteAnimations, index)
        getgenv().Notify({
            Title = '7yd7 | Favorite System',
            Content = '🗑️ Removed "' .. animationData.name .. '" from favorites',
            Duration = 3
        })
    else
        table.insert(State.favoriteAnimations, {
            id = animationData.id,
            name = animationData.name .. " - ⭐",
            bundledItems = animationData.bundledItems,
            isCustomSet = IsCustomSetData(animationData),
            customSetName = IsCustomSetData(animationData) and (type(animationData.name) == "string" and animationData.name:gsub("%s*%-.*$", "") or animationData.name) or nil
        })
        getgenv().Notify({
            Title = '7yd7 | Favorite System',
            Content = '✅ Added "' .. animationData.name .. '" to favorites',
            Duration = 3
        })
    end

    State.favoriteSetVersion = State.favoriteSetVersion + 1
    
    pcall(function()
        if not isfolder("7yd7") then makefolder("7yd7") end
        writefile(State.favoriteAnimationsFileName, HttpService:JSONEncode(State.favoriteAnimations))
    end)

    State.totalPages = calculateTotalPages()
    updatePageDisplay()
    updateAnimations()
    updateAllFavoriteIcons()
end



function setupEmoteClickDetection()
    if State.isMonitoringClicks then
        return
    end
    
    State.emoteMonitorToken = State.emoteMonitorToken + 1
    local token = State.emoteMonitorToken

    local function monitorEmotes()
        while State.favoriteEnabled and State.currentMode == "emote" and State.emoteMonitorToken == token do
            local success, frontFrame = pcall(function()
                return game:GetService("CoreGui").RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Front.EmotesButtons
            end)

            if success and frontFrame then
                for _, connection in pairs(State.emoteClickConnections) do
                    if connection then
                        connection:Disconnect()
                    end
                end
                State.emoteClickConnections = {}

                local randomActive = isRandomSlotActive()
                for _, child in pairs(frontFrame:GetChildren()) do
                    if child:IsA("ImageLabel") and child.Image ~= "" and (not randomActive or child.Name ~= "1") then
                        local imageUrl = child.Image
                        local assetId = extractAssetId(imageUrl)
                        if assetId then
                            local isFavorite = isInFavorites(assetId)
                            updateFavoriteIcon(child, assetId, isFavorite)
                        end
                    end
                end

                applyEmotesButtonsActiveState()
            end

            task.wait(0.1)
        end
    end

    if State.favoriteEnabled then
        State.isMonitoringClicks = true
        task.spawn(monitorEmotes)
    end
end

applyAnimation = function(animationData)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChild("Humanoid")
    local animate = character:FindFirstChild("Animate")
    
    if not animate or not humanoid then
        getgenv().Notify({
            Title = '7yd7 | Animation Error',
            Content = '❌ Animate or Humanoid not found',
            Duration = 3
        })
        return
    end
    
    local bundleId = animationData.id
    local bundledItems = animationData.bundledItems

    getgenv().lastPlayedAnimation = animationData
    Config.LastPlayedAnimationData = animationData
    task.spawn(SaveConfig)
    
        if not bundledItems and not animationData.isCustomSet then
        getgenv().Notify({
            Title = '7yd7 | Animation Error', 
            Content = '??? No bundled items found',
            Duration = 3
        })
        return
    end
    
    if animationData.isCustomSet and not bundledItems then
        bundledItems = {"Custom-Animation"}
    end
    
    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
        track:Stop()
    end
    
    local cacheKey = tostring(bundleId)
    local mappings = State.AnimationCache[cacheKey]
    
    if mappings and #mappings > 0 and mappings._version ~= 2 then
        mappings = nil
    end
    
        if animationData.isCustomSet then
            mappings = buildCustomSetMappings(GetCustomSetName(animationData) or animationData.name)
            if #mappings > 0 then
                mappings._version = 2
                State.AnimationCache[cacheKey] = mappings
                task.spawn(saveAnimationCache)
            end
    elseif not mappings then
        mappings = resolveAnimationMappings(bundledItems)
        if #mappings > 0 then
            mappings._version = 2
            State.AnimationCache[cacheKey] = mappings
            task.spawn(saveAnimationCache)
        end
    end
    
    if #mappings == 0 then return end
    
    local sorted = {}
    for _, m in ipairs(mappings) do
        if m.category:lower() == "idle" then
            table.insert(sorted, 1, m)
        else
            table.insert(sorted, m)
        end
    end
    
    local function applyAnimationToObject(animObj, animId, weights)
        if not animObj or not animObj:IsA("Animation") then return end

        animObj.AnimationId = animId

        if weights ~= nil then
            for _, child in ipairs(animObj:GetChildren()) do
                if child:IsA("NumberValue") and child.Name == "Weight" then
                    child:Destroy()
                end
            end
            for _, wVal in ipairs(weights) do
                local w = Instance.new("NumberValue")
                w.Name = "Weight"
                w.Value = wVal
                w.Parent = animObj
            end
        end
    end

    local mappingMap = {}
    for _, m in ipairs(sorted) do
        local cat = m.category:lower()
        if not mappingMap[cat] then
            mappingMap[cat] = { folderName = m.category, items = {} }
        end
        mappingMap[cat].items[m.name:lower()] = m
    end

    for cat, data in pairs(mappingMap) do
        local categoryFolder = animate:FindFirstChild(data.folderName)
        if not categoryFolder then
            continue
        end

        local items = data.items

        local sourceByName = {}
        for name, m in pairs(items) do
            sourceByName[name] = m
        end

        for _, animObj in ipairs(categoryFolder:GetChildren()) do
            if animObj:IsA("Animation") then
                local lowerName = animObj.Name:lower()
                local m = sourceByName[lowerName]
                if m then
                    sourceByName[lowerName] = nil
                    applyAnimationToObject(animObj, m.animationId, m.weights)
                    if animObj.Name ~= m.name then
                        animObj.Name = m.name
                    end
                else
                    animObj:Destroy()
                end
            end
        end

        for name, m in pairs(sourceByName) do
            local animObj = Instance.new("Animation")
            animObj.Name = m.name
            applyAnimationToObject(animObj, m.animationId, m.weights)
            animObj.Parent = categoryFolder
        end
    end
    
    if humanoid.MoveDirection.Magnitude == 0 then
        animate.Disabled = true
        animate.Disabled = false
    end
end

function playAnimationPreview(animationData)
    local _, humanoid = getCharacterAndHumanoid()
    if not humanoid then return false end
    local animator = humanoid:FindFirstChild("Animator")
    if not animator then return false end

    local bundledItems = animationData and animationData.bundledItems
    if not bundledItems then return false end
    
    local bundleId = animationData.id
    local cacheKey = tostring(bundleId)
    local mappings = State.AnimationCache[cacheKey]
    
    if not mappings then
        mappings = resolveAnimationMappings(bundledItems)
        if #mappings > 0 then
            State.AnimationCache[cacheKey] = mappings
            task.spawn(saveAnimationCache)
        end
    end
    
    if #mappings == 0 then return false end
    
    local m = mappings[1]
    local animation = Instance.new("Animation")
    animation.AnimationId = m.animationId
    local ok, track = pcall(function()
        return animator:LoadAnimation(animation)
    end)
    if ok and track then
        track.Priority = Enum.AnimationPriority.Action
        track.Looped = true
        if State.speedEmoteEnabled or State.emotesWalkEnabled then
            track:Play()
        end
        State.currentEmoteTrack = track
        if State.speedEmoteEnabled then
            local speedVal = tonumber(UI.SpeedBox.Text) or Config.EmoteSpeed or 1
            track:AdjustSpeed(speedVal)
        end
        return true
    end

    return false
end

handleSectorAction = function(index)
    if tick() - State.lastActionTick < 0.25 then return end
    State.lastActionTick = tick()

    if State.customAnimationEditorActive and (not State.customAnimationEditingKey or not State.customAnimationEditingName or not (State.CustomAnimOverlay and State.CustomAnimOverlay.Parent)) then
        if State.exitCustomAnimationEditor then
            State.exitCustomAnimationEditor()
        else
            State.customAnimationEditorActive = false
        end
    end

    local randomActive = isRandomSlotActive()
    if index == 1 and randomActive then
        local itemData = pickRandomItemForMode()
        if not itemData then
            getgenv().Notify({
                Title = '7yd7 | Random',
                Content = '? No valid random item found',
                Duration = 3
            })
            return
        end
        State.lastRadialActionTime = tick()

        if State.customAnimationEditorActive then
            local animIdToSave = itemData.id
            local cat = State.customAnimationEditingKey
            local name = State.customAnimationEditingName
            if State.CustomAnimations.Sets[State.currentCustomAnimationName] and cat and name then
                if State.currentMode == "emote" or (State.currentMode == "animation" and not itemData.bundledItems) then
                    local resolved = resolveEmoteToAnimationId(itemData.id)
                    if resolved then animIdToSave = resolved end
                end
                if not State.CustomAnimations.Sets[State.currentCustomAnimationName][cat] then
                    State.CustomAnimations.Sets[State.currentCustomAnimationName][cat] = {}
                end
                State.CustomAnimations.Sets[State.currentCustomAnimationName][cat][name] = animIdToSave
                State.SaveCustomAnimations(State.CustomAnimations)
                getgenv().Notify({ Title = "7yd7 | Saved", Content = "✅ Saved " .. name, Duration = 3 })
                if State.RefreshCustomAnimUI then State.RefreshCustomAnimUI() end
                if refreshCustomAnimationState then refreshCustomAnimationState(true) end
                State.exitCustomAnimationEditor()
            end
            return
        end

        if State.favoriteEnabled then
            if State.currentMode == "animation" then
                if not isInFavorites(itemData.id) then
                    toggleFavoriteAnimation(itemData)
                end
            else
                if not isInFavorites(itemData.id) then
                    toggleFavorite(itemData.id, itemData.name)
                end
            end
            return
        end

        if State.currentMode == "animation" then
            if stopCurrentEmote then stopCurrentEmote() end
            applyAnimation(itemData)
            State.lastRandomAnimationId = itemData.id
            if not State.favoriteEnabled then
                pcall(function()
                    game:GetService("GuiService"):SetEmotesMenuOpen(false)
                end)
                pcall(function()
                    game:GetService("CoreGui").RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Visible = false
                end)
            end
        else
            local _, hum = getCharacterAndHumanoid()
            if hum then
                pcall(function()
                    game:GetService("GuiService"):SetEmotesMenuOpen(false)
                end)
                pcall(function()
                    game:GetService("CoreGui").RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Visible = false
                end)
                playRandomEmote(hum, itemData.id)
                State.lastRandomEmoteId = itemData.id
            end
        end
        return
    end

    if State.currentMode == "animation" then
        rebuildAnimationNormalCache()
    else
        rebuildEmoteNormalCache()
    end

    local function getEmoteAtIndex(idx)
        local categories = getCategoryStats()
        local accumulatedPages = 0
        
        for _, cat in ipairs(categories) do
            if State.currentPage <= accumulatedPages + cat.pages then
                local adjustedPage = State.currentPage - accumulatedPages
                local pageItems = getListSlice(cat.list, adjustedPage, cat.hasRandom)
                return pageItems[idx]
            end
            accumulatedPages = accumulatedPages + cat.pages
        end
        return nil
    end

    local slotOffset = randomActive and 1 or 0
    local itemData = getEmoteAtIndex(index - slotOffset)
    if not itemData then return end

    State.lastRadialActionTime = tick()

    if State.customAnimationEditorActive then
        local animIdToSave = itemData.id
        local cat = State.customAnimationEditingKey
        local name = State.customAnimationEditingName

        if State.currentMode == "emote" or (State.currentMode == "animation" and not itemData.bundledItems) then
            local resolved = resolveEmoteToAnimationId(itemData.id)
            if resolved then animIdToSave = resolved end
        end

        if State.currentMode == "animation" and itemData.bundledItems then
            local resolved = resolveAnimationMappings(itemData.bundledItems)
            if resolved and #resolved > 0 then
                local match
                for _, m in ipairs(resolved) do
                    if m.category:lower() == cat:lower() and m.name:lower() == name:lower() then
                        match = m
                        break
                    end
                end
                if not match then
                    for _, m in ipairs(resolved) do
                        if m.category:lower() == cat:lower() then
                            match = m
                            break
                        end
                    end
                end
                if match then
                    local extractedId = tonumber(urlToId(match.animationId))
                    if extractedId then
                        animIdToSave = extractedId
                    end
                end
                
                if animIdToSave == itemData.id and resolved[1] then
                    animIdToSave = tonumber(urlToId(resolved[1].animationId)) or itemData.id
                end
            end
        end

        if State.CustomAnimations.Sets[State.currentCustomAnimationName] and cat and name then
            if not State.CustomAnimations.Sets[State.currentCustomAnimationName][cat] then
                State.CustomAnimations.Sets[State.currentCustomAnimationName][cat] = {}
            end
            State.CustomAnimations.Sets[State.currentCustomAnimationName][cat][name] = animIdToSave
            State.SaveCustomAnimations(State.CustomAnimations)
            getgenv().Notify({ Title = "7yd7 | Saved", Content = "✅ Saved " .. name, Duration = 3 })
            
            if State.RefreshCustomAnimUI then State.RefreshCustomAnimUI() end
            if refreshCustomAnimationState then refreshCustomAnimationState(true) end
            State.exitCustomAnimationEditor()
        end
        return
    end

    if State.favoriteEnabled then
        if State.currentMode == "animation" then
            toggleFavoriteAnimation(itemData)
        else
            toggleFavorite(itemData.id, itemData.name)
        end
    else
        if State.currentMode == "animation" then
            applyAnimation(itemData)
            pcall(function()
                game:GetService("GuiService"):SetEmotesMenuOpen(false)
            end)
            pcall(function()
                game:GetService("CoreGui").RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Visible = false
            end)
        else
            local _, hum = getCharacterAndHumanoid()
            if hum then
                if playRandomEmote then
                    playRandomEmote(hum, itemData.id)
                elseif playEmote then
                    playEmote(hum, itemData.id)
                end
            end
        end
    end

end

function clearAnimationSlotImages()
    local success, frontFrame = pcall(function()
        return game:GetService("CoreGui").RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Front.EmotesButtons
    end)
    if not success or not frontFrame then
        return
    end

    for i = 1, State.itemsPerPage do
        local child = frontFrame:FindFirstChild(tostring(i))
        if child and child:IsA("ImageLabel") then
            local idValue = child:FindFirstChild("AnimationID")
            if idValue then
                idValue:Destroy()
            end
            if child.Image and child.Image:find("rbxthumb://type=BundleThumbnail") then
                child.Image = ""
            end
        end
    end
end


function monitorAnimations(token)
    while State.currentMode == "animation" and State.animationMonitorToken == token do
        local success, frontFrame = pcall(function()
            return game:GetService("CoreGui").RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Front.EmotesButtons
        end)
        
        if success and frontFrame then
            for _, connection in pairs(State.emoteClickConnections) do
                if connection then
                    connection:Disconnect()
                end
            end
            State.emoteClickConnections = {}
            
            local favoritesToUse = _G.filteredFavoritesAnimationsForDisplay or State.favoriteAnimations
            local hasFavorites = #favoritesToUse > 0
            local favoritePagesCount = hasFavorites and calcPagesForList(#favoritesToUse, true) or 0
            local isInFavoritesPages = State.currentPage <= favoritePagesCount
            
            local currentPageAnimations = {}
            
            if isInFavoritesPages and hasFavorites then
                currentPageAnimations = getListSlice(favoritesToUse, State.currentPage, true)
            else
                local normalAnimations = {}
                for _, animation in pairs(State.filteredAnimations) do
                    if not isInFavorites(animation.id) then
                        table.insert(normalAnimations, animation)
                    end
                end
                
                local adjustedPage = State.currentPage - favoritePagesCount
                local isFirstNormalList = (favoritePagesCount == 0)
                currentPageAnimations = getListSlice(normalAnimations, adjustedPage, isFirstNormalList)
            end
            
            local randomActive = isRandomSlotActive()
            local buttonIndex = 1
            for _, child in pairs(frontFrame:GetChildren()) do
                if child:IsA("ImageLabel") and (not randomActive or child.Name ~= "1") then
                    if buttonIndex <= #currentPageAnimations then
                        local animationData = currentPageAnimations[buttonIndex]
                        
                        if State.favoriteEnabled then
                            local isFavorite = isInFavorites(animationData.id)
                            updateFavoriteIcon(child, animationData.id, isFavorite)
                        else
                            local favoriteIcon = child:FindFirstChild("FavoriteIcon")
                            if favoriteIcon then
                                favoriteIcon:Destroy()
                            end
                        end
                        buttonIndex = buttonIndex + 1
                    else
                        local favoriteIcon = child:FindFirstChild("FavoriteIcon")
                        if favoriteIcon then
                            favoriteIcon:Destroy()
                        end
                    end
                end
            end

        end
        
        task.wait(0.1)
    end
end

function stopEmoteClickDetection()
    State.isMonitoringClicks = false
    State.emoteMonitorToken = State.emoteMonitorToken + 1
    State.animationMonitorToken = State.animationMonitorToken + 1
    
    for _, connection in pairs(State.emoteClickConnections) do
        if connection then
            connection:Disconnect()
        end
    end
    State.emoteClickConnections = {}
    
    local success, frontFrame = pcall(function()
        return game:GetService("CoreGui").RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Front.EmotesButtons
    end)
    
    if success and frontFrame then
        for _, child in pairs(frontFrame:GetChildren()) do
            if child:IsA("ImageLabel") then
                local clickDetector = child:FindFirstChild("ClickDetector")
                if clickDetector then
                    clickDetector:Destroy()
                end
                
                local favoriteIcon = child:FindFirstChild("FavoriteIcon")
                if favoriteIcon then
                    favoriteIcon:Destroy()
                end
            end
        end
        applyEmotesButtonsActiveState()
    end
end


function fetchAllEmotes()
    if State.isLoading then
        return
    end
    State.isLoading = true

    local function applyData(data, total)
        State.emotesData = data
        State.totalEmotesLoaded = total
        State.originalEmotesData = State.emotesData
        State.filteredEmotes = State.emotesData
        State.emoteCacheVersion = State.emoteCacheVersion + 1
        State.totalPages = calculateTotalPages()
        State.currentPage = 1
        updatePageDisplay()
        updateEmotes()
        State.isLoading = false
    end

    local function fetchFromUrl()
        local success, result = pcall(function()
            local jsonContent = game:HttpGet("https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/EmoteSniper.json")
            if jsonContent and jsonContent ~= "" then
                local data = HttpService:JSONDecode(jsonContent)
                return data.data or {}
            else
                return nil
            end
        end)

        if success and result then
            local emoteData = {}
            local total = 0
            for _, item in pairs(result) do
                local id = tonumber(item.id)
                if id and id > 0 then
                    table.insert(emoteData, {id = id, name = item.name or ("Emote_" .. id)})
                    total = total + 1
                end
            end
            if #emoteData > 0 then
                pcall(function()
                    if not isfolder("7yd7") then makefolder("7yd7") end
                    writefile(State.EmoteDataCachePath, HttpService:JSONEncode(emoteData))
                end)
                return emoteData, total
            end
        end
        return nil, nil
    end

    local cacheData = nil
    pcall(function()
        if isfile and isfile(State.EmoteDataCachePath) then
            local json = readfile(State.EmoteDataCachePath)
            local decoded = HttpService:JSONDecode(json)
            if type(decoded) == "table" and #decoded > 0 then
                cacheData = decoded
            end
        end
    end)

    if cacheData then
        applyData(cacheData, #cacheData)
    else
        State.emotesData = {{id = 3360686498, name = "Stadium"},{id = 3360692915, name = "Tilt"},{id = 3576968026, name = "Shrug"},{id = 3360689775, name = "Salute"}}
        State.totalEmotesLoaded = #State.emotesData
        State.originalEmotesData = State.emotesData
        State.filteredEmotes = State.emotesData
        State.emoteCacheVersion = State.emoteCacheVersion + 1
        State.totalPages = calculateTotalPages()
        State.currentPage = 1
        updatePageDisplay()
        updateEmotes()
        State.isLoading = false
    end

    task.spawn(function()
        while true do
            local emoteData, total = fetchFromUrl()
            if emoteData then
                applyData(emoteData, total)
                getgenv().Notify({Title = '7yd7 | Emote', Content = "📦 Emotes loaded", Duration = 3})
                return
            end
            task.wait(3)
        end
    end)
end

function fetchAllAnimations()
    if State.isLoading then
        return
    end
    State.isLoading = true
    State.animationsData = {}

    local function processCustomSets()
        if State.CustomAnimations and State.CustomAnimations.Order then
            for idx, customSetName in ipairs(State.CustomAnimations.Order) do
                if customSetName ~= "Default" and State.CustomAnimations.Sets[customSetName] then
                    local fakeId = -1000 - idx
                    local customSetData = State.CustomAnimations.Sets[customSetName]
                    local mappings = {}
                    for cat, anims in pairs(customSetData) do
                        if cat ~= "__meta" then
                            for name, id in pairs(anims) do
                                if tostring(id) ~= "0" then
                                    table.insert(mappings, {category = cat, name = name, animationId = "rbxassetid://" .. id})
                                end
                            end
                        end
                    end
                    mappings._version = 2
                    State.AnimationCache[tostring(fakeId)] = mappings

                    local customAnimationData = {
                        id = fakeId,
                        name = customSetName,
                        bundledItems = {"Custom-Animation"},
                        isCustomSet = true
                    }
                    table.insert(State.animationsData, 1, customAnimationData)
                end
            end
        end
    end

    local function finalize()
        State.originalAnimationsData = State.animationsData
        State.filteredAnimations = State.animationsData
        State.animationCacheVersion = State.animationCacheVersion + 1
        State.isLoading = false
    end

    processCustomSets()
    finalize()

    task.spawn(function()
        local success, result = pcall(function()
            local jsonContent = game:HttpGet("https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/AnimationSniper.json")
            if jsonContent and jsonContent ~= "" then
                local data = HttpService:JSONDecode(jsonContent)
                return data.data or {}
            end
            return nil
        end)

        local offsaleSuccess, offsaleResult
        if offsaleAnimationJson then
            offsaleSuccess, offsaleResult = pcall(function()
                local jsonContent = game:HttpGet("https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/AnimationSniperoffsale.json")
                if jsonContent and jsonContent ~= "" then
                    local data = HttpService:JSONDecode(jsonContent)
                    return data.data or {}
                end
                return nil
            end)
        end

        if success or offsaleSuccess then
            local animationsData = {}
            local seenIds = {}

            if success and result then
                for _, item in pairs(result) do
                    local id = tonumber(item.id)
                    if id and id > 0 then
                        seenIds[id] = true
                        table.insert(animationsData, {
                            id = id,
                            name = item.name or ("Animation_" .. id),
                            bundledItems = item.bundledItems
                        })
                    end
                end
            end

            if offsaleSuccess and offsaleResult then
                for _, item in pairs(offsaleResult) do
                    local id = tonumber(item.id)
                    if id and id > 0 and not seenIds[id] then
                        seenIds[id] = true
                        table.insert(animationsData, {
                            id = id,
                            name = item.name or ("Animation_Offsale_" .. id),
                            bundledItems = item.bundledItems
                        })
                    end
                end
            end

            local prevMode = State.currentMode
            State.animationsData = animationsData
            processCustomSets()
            finalize()
            State.totalPages = calculateTotalPages()
            if State.currentPage > State.totalPages then
                State.currentPage = State.totalPages
            end
            if prevMode == "animation" then
                if State.animationSearchTerm ~= "" and searchAnimations then
                    searchAnimations(State.animationSearchTerm)
                else
                    updatePageDisplay()
                    updateAnimations()
                end
            end
        end
    end)
end

local function smartSearchMatch(name, searchTerm)
    if not searchTerm or searchTerm == "" then return true end
    name = name:lower()
    searchTerm = searchTerm:lower()
    
    for word in searchTerm:gmatch("%S+") do
        if not name:find(word, 1, true) then
            return false
        end
    end
    return true
end

function searchEmotes(searchTerm)
    if State.isLoading then
        getgenv().Notify({
            Title = '7yd7 | Emote',
            Content = '⚠️ Loading please wait...',
            Duration = 5
        })
        return
    end

    searchTerm = searchTerm:lower()

    if searchTerm == "" then
        State.filteredEmotes = State.originalEmotesData
        State.emoteCacheVersion = State.emoteCacheVersion + 1
        if _G.originalFavoritesBackup then
            _G.originalFavoritesBackup = nil
        end
        _G.filteredFavoritesForDisplay = nil
    else
        local isIdSearch = searchTerm:match("^%d+$")
        
        local newFilteredList = {}
        
        if isIdSearch then
            for _, emote in pairs(State.originalEmotesData) do
                if tostring(emote.id) == searchTerm then
                    table.insert(newFilteredList, emote)
                end
            end
        else
            for _, emote in pairs(State.originalEmotesData) do
                if smartSearchMatch(emote.name, searchTerm) then
                    table.insert(newFilteredList, emote)
                end
            end
        end
        
        State.filteredEmotes = newFilteredList
        State.emoteCacheVersion = State.emoteCacheVersion + 1

        if not isIdSearch then
            if not _G.originalFavoritesBackup then
                _G.originalFavoritesBackup = {}
                for i, favorite in pairs(State.favoriteEmotes) do
                    _G.originalFavoritesBackup[i] = {
                        id = favorite.id,
                        name = favorite.name
                    }
                end
            end

            _G.filteredFavoritesForDisplay = {}
            for _, favorite in pairs(State.favoriteEmotes) do
                if smartSearchMatch(favorite.name, searchTerm) then
                    table.insert(_G.filteredFavoritesForDisplay, favorite)
                end
            end
        end
        applySearchSlot1Image()
    end

    State.totalPages = calculateTotalPages()
    State.currentPage = 1
    updatePageDisplay()
    updateEmotes()
end

function searchAnimations(searchTerm)
    if State.isLoading then
        getgenv().Notify({
            Title = '7yd7 | Animation',
            Content = '⚠️ Loading please wait...',
            Duration = 5
        })
        return
    end

    searchTerm = searchTerm:lower()

    if searchTerm == "" then
        State.filteredAnimations = State.originalAnimationsData
        State.animationCacheVersion = State.animationCacheVersion + 1
        if _G.originalAnimationFavoritesBackup then
            _G.originalAnimationFavoritesBackup = nil
        end
        _G.filteredFavoritesAnimationsForDisplay = nil
    else
        local isIdSearch = searchTerm:match("^%d+$")
        
        local newFilteredList = {}
        
        if isIdSearch then
            for _, animation in pairs(State.originalAnimationsData) do
                if tostring(animation.id) == searchTerm then
                    table.insert(newFilteredList, animation)
                end
            end
        else
            for _, animation in pairs(State.originalAnimationsData) do
                if smartSearchMatch(animation.name, searchTerm) then
                    table.insert(newFilteredList, animation)
                end
            end
        end
        
        State.filteredAnimations = newFilteredList
        State.animationCacheVersion = State.animationCacheVersion + 1

        if not isIdSearch then
            if not _G.originalAnimationFavoritesBackup then
                _G.originalAnimationFavoritesBackup = {}
                for i, favorite in pairs(State.favoriteAnimations) do
                    _G.originalAnimationFavoritesBackup[i] = {
                        id = favorite.id,
                        name = favorite.name,
                        bundledItems = favorite.bundledItems
                    }
                end
            end

            _G.filteredFavoritesAnimationsForDisplay = {}
            for _, favorite in pairs(State.favoriteAnimations) do
                if smartSearchMatch(favorite.name, searchTerm) then
                    table.insert(_G.filteredFavoritesAnimationsForDisplay, favorite)
                end
            end
        end
        applySearchSlot1Image()
    end

    State.totalPages = calculateTotalPages()
    State.currentPage = 1
    updatePageDisplay()
    updateAnimations()
end

findCustomAnimationDataByName = function(setName)
    if not setName or setName == "Default" then
        return nil
    end

    for _, animationData in ipairs(State.originalAnimationsData or {}) do
        if animationData.isCustomSet and animationData.name == setName then
            return animationData
        end
    end

    for _, animationData in ipairs(State.animationsData or {}) do
        if animationData.isCustomSet and animationData.name == setName then
            return animationData
        end
    end

    return nil
end

refreshCustomAnimationState = function(applySelectedSet)
    local activeSearch = State.animationSearchTerm or ""
    local previousPage = State.currentPage

    fetchAllAnimations()

    if activeSearch ~= "" then
        searchAnimations(activeSearch)
    else
        State.filteredAnimations = State.originalAnimationsData
        State.animationCacheVersion = State.animationCacheVersion + 1
        State.totalPages = calculateTotalPages()
        local maxPage = math.max(State.totalPages, 1)
        if previousPage < 1 then
            State.currentPage = 1
        elseif previousPage > maxPage then
            State.currentPage = maxPage
        else
            State.currentPage = previousPage
        end
        updatePageDisplay()
        if State.currentMode == "animation" then
            updateAnimations()
        end
    end

    if applySelectedSet and State.currentCustomAnimationName ~= "Default" then
        local selectedAnimationData = findCustomAnimationDataByName(State.currentCustomAnimationName)
        if selectedAnimationData then
            pcall(function()
                applyAnimation(selectedAnimationData)
            end)
        end
    end
end

function goToPage(pageNumber)
    bumpImageUpdateToken()
    if pageNumber < 1 then
        State.currentPage = 1
    elseif pageNumber > State.totalPages then
        State.currentPage = State.totalPages
    else
        State.currentPage = pageNumber
    end
    updatePageDisplay()
    updateEmotes()
end

function previousPage()
    bumpImageUpdateToken()
    if State.currentPage <= 1 then
        State.currentPage = State.totalPages
    else
        State.currentPage = State.currentPage - 1
    end
    updatePageDisplay()
    updateEmotes()
end

function nextPage()
    bumpImageUpdateToken()
    if State.currentPage >= State.totalPages then
        State.currentPage = 1
    else
        State.currentPage = State.currentPage + 1
    end
    updatePageDisplay()
    updateEmotes()
end

function stopCurrentEmote()
    if State.currentEmoteTrack then
        State.currentEmoteTrack:Stop()
        State.currentEmoteTrack = nil
    end
end

playEmote = function(humanoid, emoteId)
    stopCurrentEmote()
    stopEmotes()

    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. emoteId

    local success, animTrack = pcall(function()
        return humanoid.Animator:LoadAnimation(animation)
    end)

    if success and animTrack then
        State.currentEmoteTrack = animTrack
        State.currentEmoteTrack.Priority = Enum.AnimationPriority.Action
        State.currentEmoteTrack.Looped = true
        task.wait(0.1)
        if State.speedEmoteEnabled or State.emotesWalkEnabled then
            State.currentEmoteTrack:Play()

            if State.speedEmoteEnabled then
                local speedValue = tonumber(UI.SpeedBox.Text) or 1
                State.currentEmoteTrack:AdjustSpeed(speedValue)
            end
        end
    end
end

playRandomEmote = function(humanoid, emoteId)
    stopCurrentEmote()
    stopEmotes()

    local ok, track = pcall(function()
        return humanoid:PlayEmoteAndGetAnimTrackById(emoteId)
    end)
    if ok and track and typeof(track) == "Instance" and track:IsA("AnimationTrack") then
        State.currentEmoteTrack = track
        if State.speedEmoteEnabled then
            local speedVal = tonumber(UI.SpeedBox.Text) or Config.EmoteSpeed or 1
            track:AdjustSpeed(speedVal)
        end
    end
end

function onCharacterAdded(character)
    State.currentCharacter = character
    stopCurrentEmote()

    local humanoid = character:WaitForChild("Humanoid")
    local animator = humanoid:WaitForChild("Animator")

    if getgenv().autoReloadEnabled and getgenv().lastPlayedAnimation then
        task.spawn(function()
            local player = game.Players.LocalPlayer
            if not player:HasAppearanceLoaded() then
                player.CharacterAppearanceLoaded:Wait()
            end
            local animate = character:WaitForChild("Animate")
            character:WaitForChild("HumanoidRootPart")
            applyAnimation(getgenv().lastPlayedAnimation)
            getgenv().Notify({
                Title = '7yd7 | Auto Reload Animation',
                Content = '🔄 The last animation was automatically \n reapplied',
                Duration = 3
            })
            
            local lastAnim = getgenv().lastPlayedAnimation
            local cacheKey = tostring(lastAnim.id)
            local changed = false
            for i = 1, 7 do
                task.wait(0.01)
                if not character or not character.Parent or not humanoid then break end
                local mappings = State.AnimationCache[cacheKey]
                if not mappings and lastAnim.isCustomSet then
                    mappings = buildCustomSetMappings(GetCustomSetName and GetCustomSetName(lastAnim) or lastAnim.name)
                end
                if mappings and animate and animate.Parent then
                    for _, m in ipairs(mappings) do
                        local categoryFolder = animate:FindFirstChild(m.category)
                        if categoryFolder then
                            for _, animObj in ipairs(categoryFolder:GetChildren()) do
                                if animObj:IsA("Animation") and animObj.Name:lower() == m.name:lower() then
                                    if animObj.AnimationId ~= m.animationId then
                                        animObj.AnimationId = m.animationId
                                        if m.weights ~= nil then
                                            for _, child in ipairs(animObj:GetChildren()) do
                                                if child:IsA("NumberValue") and child.Name == "Weight" then
                                                    child:Destroy()
                                                end
                                            end
                                            for _, wVal in ipairs(m.weights) do
                                                local w = Instance.new("NumberValue")
                                                w.Name = "Weight"
                                                w.Value = wVal
                                                w.Parent = animObj
                                            end
                                        end
                                        changed = true
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if changed and humanoid.MoveDirection.Magnitude == 0 then
                animate.Disabled = true
                animate.Disabled = false
            end
        end)
    end

    local function isAnyEmoteEnhanceActive()
        return State.emotesWalkEnabled or State.speedEmoteEnabled
    end

    local function handleFrozenToolEquip()
        State.toolEquipped = true
        refreshToolAnimationIds()
    end

    local function handleFrozenToolUnequip()
        State.toolEquipped = false
        refreshToolAnimationIds()
    end

    if character:FindFirstChildOfClass("Tool") then
        State.toolEquipped = true
    end
    refreshToolAnimationIds()

    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            handleFrozenToolEquip()
        end
    end)

    character.ChildRemoved:Connect(function(child)
        if child:IsA("Tool") and not character:FindFirstChildOfClass("Tool") then
            handleFrozenToolUnequip()
        end
    end)

    animator.AnimationPlayed:Connect(function(animationTrack)
        if isDancing(character, animationTrack) then
            local playedEmoteId = urlToId(animationTrack.Animation.AnimationId)
            if playedEmoteId == "" or playedEmoteId == "0" then return end

            if State.toolEquipped then
                return
            end

            if State.emotesWalkEnabled then
                if State.currentEmoteTrack then
                    local currentEmoteId = urlToId(State.currentEmoteTrack.Animation.AnimationId)
                    if currentEmoteId == playedEmoteId then
                        return
                    else
                        stopCurrentEmote()
                    end
                end

                playEmote(humanoid, playedEmoteId)

                if currentEmoteTrack then
                    currentEmoteTrack.Ended:Connect(function()
                        if currentEmoteTrack == animationTrack then
                            currentEmoteTrack = nil
                        end
                    end)
                end
            end

            if State.speedEmoteEnabled and not State.emotesWalkEnabled then
                if State.currentEmoteTrack then
                    local currentEmoteId = urlToId(State.currentEmoteTrack.Animation.AnimationId)
                    if currentEmoteId == playedEmoteId then
                        return
                    else
                        stopCurrentEmote()
                    end
                end

                playEmote(humanoid, playedEmoteId)

                if currentEmoteTrack then
                    currentEmoteTrack.Ended:Connect(function()
                        if currentEmoteTrack == animationTrack then
                            currentEmoteTrack = nil
                        end
                    end)
                end
            end
        end
    end)

    humanoid.Died:Connect(function()
    if State.hudEditorActive and exitHUDEditor then exitHUDEditor() end
    State.emotesWalkEnabled = false
    State.speedEmoteEnabled = false
    State.favoriteEnabled = false
    State.toolEquipped = false
    State.currentEmoteTrack = nil

    stopEmotes()
        stopCurrentEmote()
    end)
end

function toggleEmoteWalk()
    State.emotesWalkEnabled = not State.emotesWalkEnabled
    ApplyFreezeButtonVisual()

    if State.emotesWalkEnabled then
        getgenv().Notify({
            Title = '7yd7 | Emote Freeze',
            Content = "🔒 Emote freeze ON",
            Duration = 5
        })

        task.wait(0.1)
        stopCurrentEmote()
        if State.currentEmoteTrack and State.currentEmoteTrack.IsPlaying then
            State.currentEmoteTrack:AdjustSpeed(1)
        end
    else
        getgenv().Notify({
            Title = '7yd7 | Emote Freeze',
            Content = '🔓 Emote freeze OFF',
            Duration = 5
        })
        task.wait(0.1)
        stopCurrentEmote()

        if State.currentEmoteTrack and State.currentEmoteTrack.IsPlaying and State.speedEmoteEnabled then
            local speedValue = tonumber(UI.SpeedBox.Text) or 1
            State.currentEmoteTrack:AdjustSpeed(speedValue)
        elseif State.currentEmoteTrack and State.currentEmoteTrack.IsPlaying then
            State.currentEmoteTrack:AdjustSpeed(1)
        end
    end
end

function toggleSpeedEmote()
    State.speedEmoteEnabled = not State.speedEmoteEnabled
    updateSpeedBoxVisibility()

    if State.speedEmoteEnabled then
        getgenv().Notify({
            Title = '7yd7 | Speed Emote',
            Content = "⚡ Speed Emote ON",
            Duration = 5
        })
        task.wait(0.1)
        stopCurrentEmote()
    else
        getgenv().Notify({
            Title = '7yd7 | Speed Emote',
            Content = '⚡ Speed Emote OFF',
            Duration = 5
        })
        task.wait(0.1)
        stopCurrentEmote()
    end

    Config.EmoteSpeedEnabled = State.speedEmoteEnabled
    Config.EmoteSpeed = tonumber(UI.SpeedBox.Text) or 1
    SaveConfig()
end

function toggleFavoriteMode()
    State.favoriteEnabled = not State.favoriteEnabled

    if State.favoriteEnabled then
        ApplyFavoriteButtonVisual()
        getgenv().Notify({
            Title = '7yd7 | Favorite System',
            Content = "🔒 Favorite ON",
            Duration = 5
        })

        updateScriptPriorityOverlay()
        setEmotesButtonsActiveForFavorites()

        if State.currentMode == "emote" then
            setupEmoteClickDetection()
        else 
            updateAllFavoriteIcons()
        end
    else
        ApplyFavoriteButtonVisual()
        getgenv().Notify({
            Title = '7yd7 | Favorite System',
            Content = '🔓 Favorite OFF',
            Duration = 3
        })
        
        if State.currentMode == "emote" then
            stopEmoteClickDetection()
        else
            updateAllFavoriteIcons()
        end
        clearCustomHitboxes()
        updateScriptPriorityOverlay()
    end

    pcall(function()
        local frontFrame = CoreGui.RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Front.EmotesButtons
        applyEmotesButtonsActiveState()
    end)
end

local clickCooldown = {}
local CLICK_COOLDOWN_TIME = 0.1

function safeButtonClick(buttonName, callback)
    if State.hudEditorActive then return end
    local currentTime = tick()
    if not clickCooldown[buttonName] or (currentTime - clickCooldown[buttonName]) > CLICK_COOLDOWN_TIME then
        clickCooldown[buttonName] = currentTime
        callback()
    end
end

function setupAnimationClickDetection()
    if State.isMonitoringClicks then
        return
    end
    
    if State.currentMode == "animation" then
        State.animationMonitorToken = State.animationMonitorToken + 1
        local token = State.animationMonitorToken
        State.isMonitoringClicks = true
        task.spawn(function()
            monitorAnimations(token)
        end)
    end
end

function toggleAutoReload()
    getgenv().autoReloadEnabled = not getgenv().autoReloadEnabled
    Config.AutoReloadEnabled = getgenv().autoReloadEnabled
    task.spawn(SaveConfig)
    
    if getgenv().autoReloadEnabled then
        getgenv().Notify({
            Title = '7yd7 | Auto Reload Animation',
            Content = "🔄 Auto Reload ON",
            Duration = 5
        })
    else
        getgenv().Notify({
            Title = '7yd7 | Auto Reload Animation',
            Content = '🔄 Auto Reload OFF',
            Duration = 3
        })
    end
end

function connectEvents()
    disconnectAllConnections()

    if UI._1left then
        table.insert(State.guiConnections, UI._1left.MouseButton1Click:Connect(function()
            safeButtonClick("PrevPage", previousPage)
        end))
    end

    if UI._9right then
        table.insert(State.guiConnections, UI._9right.MouseButton1Click:Connect(function()
            safeButtonClick("NextPage", nextPage)
        end))
    end

    if UI._2Routenumber then
        table.insert(State.guiConnections, UI._2Routenumber.FocusLost:Connect(function(enterPressed)
            if State.hudEditorActive then return end
            local pageNum = tonumber(UI._2Routenumber.Text)
            if pageNum then
                goToPage(pageNum)
            else
                UI._2Routenumber.Text = tostring(State.currentPage)
            end
        end))
    end

    if UI.Search then
        table.insert(State.guiConnections, UI.Search.Changed:Connect(function(property)
            if State.hudEditorActive then return end
            if property == "Text" then
                if State.suppressSearch then
                    return
                end
                if State.currentMode == "emote" then
                    State.emoteSearchTerm = UI.Search.Text
                    searchEmotes(State.emoteSearchTerm)
                else
                    State.animationSearchTerm = UI.Search.Text
                    searchAnimations(State.animationSearchTerm)
                end
            end
        end))
    end

    local SECTOR_COUNT = 8
    local SECTOR_ANGLE = 360 / SECTOR_COUNT
    
    local function isAuthenticPageActive()
        if not (Config.AuthenticFirstPage and State.currentMode == "emote") then
            return false
        end
        local authenticEmotes = getgenv().OwnedAuthenticEmotes or {}
        local authenticPagesCount = calcPagesForList(#authenticEmotes, false)
        return #authenticEmotes > 0 and State.currentPage <= authenticPagesCount
    end

    table.insert(State.guiConnections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if State.hudEditorActive then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        
        local exists, emotesWheel = checkEmotesMenuExists()
        local isRecentlyVisible = (tick() - State.lastWheelVisibleTime < 0.15)
        if not (exists and (emotesWheel.Visible or isRecentlyVisible)) then return end

        
        local actualPos = Vector2.new(input.Position.X, input.Position.Y)

        local absPos = emotesWheel.AbsolutePosition
        local absSize = emotesWheel.AbsoluteSize

        local inXBounds = (actualPos.X >= absPos.X) and (actualPos.X <= absPos.X + absSize.X)
        local inYBounds = (actualPos.Y >= absPos.Y) and (actualPos.Y <= absPos.Y + absSize.Y)
        if not (inXBounds and inYBounds) then return end

        local center = absPos + (absSize / 2)
        local dx = actualPos.X - center.X
        local dy = actualPos.Y - center.Y

        local distance = math.sqrt(dx*dx + dy*dy)
        local radius = math.min(absSize.X, absSize.Y) * 0.5
        if distance > radius then return end
        local dynamicDeadzone = radius * 0.2
        if distance < dynamicDeadzone then return end

        local angle = math.deg(math.atan2(dy, dx))
        local correctedAngle = (angle + 90 + (SECTOR_ANGLE / 2)) % 360
        local index = math.floor(correctedAngle / SECTOR_ANGLE) + 1
        if not (State.favoriteEnabled or State.currentMode == "animation" or isAuthenticPageActive() or (index == 1 and isRandomSlotActive())) then return end

        handleSectorAction(index)
    end))

    local function bindWheelHotkeys()
        if not ContextActionService then return end

        local keyToIndex = {
            [Enum.KeyCode.One] = 1, [Enum.KeyCode.Two] = 2, [Enum.KeyCode.Three] = 3, [Enum.KeyCode.Four] = 4,
            [Enum.KeyCode.Five] = 5, [Enum.KeyCode.Six] = 6, [Enum.KeyCode.Seven] = 7, [Enum.KeyCode.Eight] = 8,
            [Enum.KeyCode.KeypadOne] = 1, [Enum.KeyCode.KeypadTwo] = 2, [Enum.KeyCode.KeypadThree] = 3, [Enum.KeyCode.KeypadFour] = 4,
            [Enum.KeyCode.KeypadFive] = 5, [Enum.KeyCode.KeypadSix] = 6, [Enum.KeyCode.KeypadSeven] = 7, [Enum.KeyCode.KeypadEight] = 8
        }

        local function onHotkey(actionName, inputState, inputObject)
            if inputState ~= Enum.UserInputState.Begin then return Enum.ContextActionResult.Pass end
            if State.hudEditorActive then return Enum.ContextActionResult.Pass end
            if UserInputService:GetFocusedTextBox() then return Enum.ContextActionResult.Pass end
            if State.customAnimationEditorActive and (not State.customAnimationEditingKey or not State.customAnimationEditingName or not (State.CustomAnimOverlay and State.CustomAnimOverlay.Parent)) then
                if State.exitCustomAnimationEditor then
                    State.exitCustomAnimationEditor()
                else
                    State.customAnimationEditorActive = false
                end
            end

            local index = keyToIndex[inputObject.KeyCode]
            if not index then return Enum.ContextActionResult.Pass end
            
            if isAuthenticPageActive() then
                return Enum.ContextActionResult.Pass
            end

            if not (State.favoriteEnabled or State.currentMode == "animation" or (index == 1 and isRandomSlotActive())) then
                return Enum.ContextActionResult.Pass
            end

            local exists, emotesWheel = checkEmotesMenuExists()
            local isRecentlyVisible = (tick() - State.lastWheelVisibleTime < 0.15)
            if not (exists and (emotesWheel.Visible or isRecentlyVisible)) then return Enum.ContextActionResult.Pass end

            local success, frontFrame = pcall(function()
                return game:GetService("CoreGui").RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Front.EmotesButtons
            end)
            if success and frontFrame then
                local target = frontFrame:FindFirstChild(tostring(index))
                if target and target:IsA("ImageLabel") and target.Image ~= "" then
                    handleSectorAction(index)
                    if State.currentMode == "animation" and not State.favoriteEnabled then
                        pcall(function()
                            game:GetService("GuiService"):SetEmotesMenuOpen(false)
                        end)
                        pcall(function()
                            game:GetService("CoreGui").RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Visible = false
                        end)
                    end
                    return Enum.ContextActionResult.Sink
                end
            end

            return Enum.ContextActionResult.Pass
        end

        ContextActionService:UnbindAction("7yd7_EmoteWheelHotkeys")
        ContextActionService:BindActionAtPriority(
            "7yd7_EmoteWheelHotkeys",
            onHotkey,
            false,
            (Enum.ContextActionPriority.High.Value + 50),
            Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four,
            Enum.KeyCode.Five, Enum.KeyCode.Six, Enum.KeyCode.Seven, Enum.KeyCode.Eight,
            Enum.KeyCode.KeypadOne, Enum.KeyCode.KeypadTwo, Enum.KeyCode.KeypadThree, Enum.KeyCode.KeypadFour,
            Enum.KeyCode.KeypadFive, Enum.KeyCode.KeypadSix, Enum.KeyCode.KeypadSeven, Enum.KeyCode.KeypadEight
        )
    end

    bindWheelHotkeys()

    if UI.EmoteWalkButton then
        table.insert(State.guiConnections, UI.EmoteWalkButton.MouseButton1Click:Connect(function()
            safeButtonClick("EmoteWalk", toggleEmoteWalk)
        end))
    end

    if UI.Favorite then
        table.insert(State.guiConnections, UI.Favorite.MouseButton1Click:Connect(function()
            safeButtonClick("Favorite", toggleFavoriteMode)
        end))
    end

    if UI.SpeedEmote then
        table.insert(State.guiConnections, UI.SpeedEmote.MouseButton1Click:Connect(function()
            safeButtonClick("SpeedEmote", toggleSpeedEmote)
        end))
    end

    if UI.Reload then
        table.insert(State.guiConnections, UI.Reload.MouseButton1Click:Connect(function()
            safeButtonClick("AutoReload", toggleAutoReload)
        end))
    end

    if UI.Changepage then
        table.insert(State.guiConnections, UI.Changepage.MouseButton1Click:Connect(function()
            safeButtonClick("ChangePage", function()
                stopEmoteClickDetection()
                if State.animImageSpamConn then
                    State.animImageSpamConn:Disconnect()
                    State.animImageSpamConn = nil
                    State.animImageSpamMap = nil
                    State.animImageSpamTicks = nil
                    State.animImageSpamToken = State.animImageSpamToken + 1
                end
                
                if State.currentMode == "emote" then
                    State.savedEmotePage = State.currentPage
                    State.currentMode = "animation"
                    
                    local function applyAnimationModeUI()
                        State.suppressSearch = true
                        UI.Search.Text = State.animationSearchTerm
                        State.suppressSearch = false
                        if State.animationSearchTerm ~= "" then
                            searchAnimations(State.animationSearchTerm)
                        end
                        State.currentPage = State.savedAnimPage
                        State.totalPages = calculateTotalPages()
                        updatePageDisplay()
                        updateEmotes() 
                        updateScriptPriorityOverlay()
                        State.animationMonitorToken = State.animationMonitorToken + 1
                        local token = State.animationMonitorToken
                        State.isMonitoringClicks = true
                        task.spawn(function()
                            monitorAnimations(token)
                        end)
                    end

                    applyAnimationModeUI()
                    
                    local beforeVersion = State.animationCacheVersion
                    task.spawn(function()
                        fetchAllAnimations()
                        if State.currentMode ~= "animation" then return end
                        if State.animationCacheVersion ~= beforeVersion then
                            applyAnimationModeUI()
                        end
                    end)
                    
                    getgenv().Notify({
                        Title = '7yd7 | Animation',
                        Content = '📄 Changed to Emote > Animation Mode',
                        Duration = 3
                    })

                else
                    State.savedAnimPage = State.currentPage
                    State.currentMode = "emote"
                    clearCustomHitboxes()
                    State.suppressSearch = true
                    UI.Search.Text = State.emoteSearchTerm
                    State.suppressSearch = false
                    if State.emoteSearchTerm ~= "" and searchEmotes then
                        searchEmotes(State.emoteSearchTerm)
                    end
                    State.currentPage = State.savedEmotePage
                    State.totalPages = calculateTotalPages()
                    updatePageDisplay() 
                    updateEmotes()
                    updateScriptPriorityOverlay()
                    
                    if State.favoriteEnabled then
                        setupEmoteClickDetection()
                    end
                    
                    getgenv().Notify({
                        Title = '7yd7 | Emote', 
                        Content = '📄 Changed to Animation > Emote Mode',
                        Duration = 3
                    })
                end
            end)
        end))
    end



    if UI.SpeedBox then
        table.insert(State.guiConnections, UI.SpeedBox.FocusLost:Connect(function()
            if State.hudEditorActive then return end
            local speedValue = tonumber(UI.SpeedBox.Text) or 1
            Config.EmoteSpeed = speedValue
            SaveConfig()
        end))
    end

    table.insert(State.guiConnections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if State.hudEditorActive then return end
        local exists, emotesWheel = checkEmotesMenuExists()
        if not (exists and emotesWheel.Visible) then return end

        if input.KeyCode == Enum.KeyCode.Q then
            if UserInputService:GetFocusedTextBox() then return end
            previousPage()
        elseif input.KeyCode == Enum.KeyCode.E then
            if UserInputService:GetFocusedTextBox() then return end
            nextPage()
        elseif (input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl) then
            if not UserInputService:GetFocusedTextBox() and UI.Search then
                UI.Search:CaptureFocus()
            end
        end
    end))
end






function calculateSnap(element, newPos, currentName, allMovable)
    local SNAP_THRESHOLD = 8
    local parent = element.Parent
    if not parent then return newPos, nil, nil end
    local ps = parent.AbsoluteSize
    local pp = parent.AbsolutePosition
    local absX = pp.X + newPos.X.Scale * ps.X + newPos.X.Offset
    local absY = pp.Y + newPos.Y.Scale * ps.Y + newPos.Y.Offset
    local absW = element.AbsoluteSize.X
    local absH = element.AbsoluteSize.Y
    local sX, sY = absX, absY
    local didX, didY = false, false
    local guideX, guideY
    for oName, oEl in pairs(allMovable) do
        if oName ~= currentName then
            local oX = oEl.AbsolutePosition.X
            local oY = oEl.AbsolutePosition.Y
            local oW = oEl.AbsoluteSize.X
            local oH = oEl.AbsoluteSize.Y
            if not didX then
                if math.abs(absX - oX) < SNAP_THRESHOLD then sX = oX; didX = true; guideX = oX end
                if math.abs(absX - (oX + oW)) < SNAP_THRESHOLD then sX = oX + oW; didX = true; guideX = oX + oW end
                if math.abs((absX + absW) - oX) < SNAP_THRESHOLD then sX = oX - absW; didX = true; guideX = oX end
                if math.abs((absX + absW) - (oX + oW)) < SNAP_THRESHOLD then sX = oX + oW - absW; didX = true; guideX = oX + oW end
                if math.abs((absX + absW/2) - (oX + oW/2)) < SNAP_THRESHOLD then sX = oX + oW/2 - absW/2; didX = true; guideX = oX + oW/2 end
            end
            if not didY then
                if math.abs(absY - oY) < SNAP_THRESHOLD then sY = oY; didY = true; guideY = oY end
                if math.abs(absY - (oY + oH)) < SNAP_THRESHOLD then sY = oY + oH; didY = true; guideY = oY + oH end
                if math.abs((absY + absH) - oY) < SNAP_THRESHOLD then sY = oY - absH; didY = true; guideY = oY end
                if math.abs((absY + absH) - (oY + oH)) < SNAP_THRESHOLD then sY = oY + oH - absH; didY = true; guideY = oY + oH end
                if math.abs((absY + absH/2) - (oY + oH/2)) < SNAP_THRESHOLD then sY = oY + oH/2 - absH/2; didY = true; guideY = oY + oH/2 end
            end
        end
    end
    local fsx = (sX - pp.X) / ps.X
    local fsy = (sY - pp.Y) / ps.Y
    return UDim2.new(fsx, newPos.X.Offset, fsy, newPos.Y.Offset), guideX, guideY
end

local function hudColorToRGB(c)
    return {math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5)}
end

local function copyProps(name)
    local src = Config.HUDProperties and Config.HUDProperties[name]
    if not src then return {} end
    local out = {}
    for k, v in pairs(src) do
        if type(v) == "table" then
            local t = {}
            for i, sv in pairs(v) do
                t[i] = sv
            end
            out[k] = t
        else
            out[k] = v
        end
    end
    return out
end

local function captureHUDState(n, el)
    if not n or not el then return nil end
    local cR = el:FindFirstChildWhichIsA("UICorner")
    local s = {
        name = n,
        pos = el.Position,
        size = el.Size,
        z = el.ZIndex,
        bgTrans = el.BackgroundTransparency,
        bgColor = el.BackgroundColor3,
        radius = cR and cR.CornerRadius or nil
    }
    if el:IsA("ImageLabel") or el:IsA("ImageButton") then
        s.imgTrans = el.ImageTransparency
        s.imgColor = el.ImageColor3
    end
    if el:IsA("TextLabel") or el:IsA("TextBox") then
        s.text = el.Text
        s.textTrans = el.TextTransparency
        s.textColor = el.TextColor3
        if el:IsA("TextBox") then
            s.placeholder = el.PlaceholderText
        end
    end
    s.props = copyProps(n)
    return s
end

local function pushUndo(state)
    if not state then return end
    if not HUD.UndoStack then HUD.UndoStack = {} end
    table.insert(HUD.UndoStack, state)
    if #HUD.UndoStack > 50 then
        table.remove(HUD.UndoStack, 1)
    end
end

local function sameUDim2(a, b)
    return a.X.Scale == b.X.Scale and a.X.Offset == b.X.Offset and a.Y.Scale == b.Y.Scale and a.Y.Offset == b.Y.Offset
end

local function sameUDim(a, b)
    return a.Scale == b.Scale and a.Offset == b.Offset
end

local function sameColor(a, b)
    return math.abs(a.R - b.R) < 0.001 and math.abs(a.G - b.G) < 0.001 and math.abs(a.B - b.B) < 0.001
end

local function applyHUDState(state)
    if not state or not state.name then return end
    local all = getAllHUDObjects()
    local el = all[state.name]
    if not el then return end

    if state.pos then
        el.Position = state.pos
        if not Config.HUDPositions then Config.HUDPositions = {} end
        Config.HUDPositions[state.name] = {state.pos.X.Scale, state.pos.X.Offset, state.pos.Y.Scale, state.pos.Y.Offset}
    end
    if state.size then
        el.Size = state.size
        if not Config.HUDSizes then Config.HUDSizes = {} end
        Config.HUDSizes[state.name] = {state.size.X.Scale, state.size.X.Offset, state.size.Y.Scale, state.size.Y.Offset}
    end
    if state.z ~= nil then el.ZIndex = state.z end
    if state.props and state.props.BgTrans ~= nil then el.BackgroundTransparency = state.bgTrans end
    if state.props and state.props.BgColor then el.BackgroundColor3 = state.bgColor end
    if el:IsA("ImageLabel") or el:IsA("ImageButton") then
        if state.props and state.props.ImgTrans ~= nil then el.ImageTransparency = state.imgTrans end
        if state.props and state.props.ImgColor then el.ImageColor3 = state.imgColor end
    end
    if el:IsA("TextLabel") or el:IsA("TextBox") then
        if state.props and state.props.Text ~= nil then el.Text = state.text end
        if state.props and state.props.TextTransparency ~= nil then el.TextTransparency = state.textTrans end
        if state.props and state.props.TxtColor then el.TextColor3 = state.textColor end
        if el:IsA("TextBox") and state.placeholder ~= nil then
            el.PlaceholderText = state.placeholder
        end
    end
    if state.radius then
        local cR = el:FindFirstChildWhichIsA("UICorner")
        if cR then cR.CornerRadius = state.radius end
    end

    if not Config.HUDProperties then Config.HUDProperties = {} end
    Config.HUDProperties[state.name] = state.props or {}
    SaveConfig()
    pcall(function() updateGUIColors() end)
end

local function undoLastHUD()
    if not State.hudEditorActive then return end
    if not HUD.UndoStack or #HUD.UndoStack == 0 then return end
    local state = table.remove(HUD.UndoStack)
    applyHUDState(state)
end

local function normalizeUDim2(u, ps)
    if not u or not ps or ps.X <= 0 or ps.Y <= 0 then
        return nil
    end
    local sx = u.X.Scale + (u.X.Offset / ps.X)
    local sy = u.Y.Scale + (u.Y.Offset / ps.Y)
    return sx, 0, sy, 0
end

local function tableToUDim2(v)
    if type(v) ~= "table" or #v ~= 4 then return nil end
    return UDim2.new(v[1], v[2], v[3], v[4])
end

local function normalizeHUDScale()
    local elems = getAllHUDObjects()
    for name, el in pairs(elems) do
        local parent = el and el.Parent
        if parent then
            local hasLayout = parent:FindFirstChildOfClass("UIListLayout")
            if hasLayout and not HUD.IsUnlocked then
                return
            end
            local ps = parent.AbsoluteSize
            if Config.HUDPositions and Config.HUDPositions[name] then
                local v = Config.HUDPositions[name]
                if type(v) == "table" and #v == 4 then
                    local sx, ox, sy, oy = v[1], v[2], v[3], v[4]
                    if ox ~= 0 or oy ~= 0 then
                        local nsx, nox, nsy, noy = normalizeUDim2(UDim2.new(sx, ox, sy, oy), ps)
                        if nsx then
                            Config.HUDPositions[name] = {nsx, nox, nsy, noy}
                            el.Position = UDim2.new(nsx, nox, nsy, noy)
                        end
                    end
                end
            end
            if Config.HUDSizes and Config.HUDSizes[name] then
                local v = Config.HUDSizes[name]
                if type(v) == "table" and #v == 4 then
                    local def = HUD.DefaultSizes and HUD.DefaultSizes[name]
                    local isDefault = def and sameUDim2(def, tableToUDim2(v) or UDim2.new(0,0,0,0))
                    if isDefault then
                        return
                    end
                    local sx, ox, sy, oy = v[1], v[2], v[3], v[4]
                    if ox ~= 0 or oy ~= 0 then
                        local nsx, nox, nsy, noy = normalizeUDim2(UDim2.new(sx, ox, sy, oy), ps)
                        if nsx then
                            Config.HUDSizes[name] = {nsx, nox, nsy, noy}
                            el.Size = UDim2.new(nsx, nox, nsy, noy)
                        end
                    end
                end
            end
        end
    end
    SaveConfig()
end

local function normalizeHUDScaleForElement(name, el, normalizePos, normalizeSize)
    if not name or not el or not el.Parent then return end
    if normalizePos == nil then normalizePos = true end
    if normalizeSize == nil then normalizeSize = true end
    local parent = el.Parent
    local hasLayout = parent:FindFirstChildOfClass("UIListLayout")
    if hasLayout and not HUD.IsUnlocked then return end
    local ps = parent.AbsoluteSize
    if ps.X <= 0 or ps.Y <= 0 then return end

    if normalizePos then
        local nsx, nox, nsy, noy = normalizeUDim2(el.Position, ps)
        if nsx then
            el.Position = UDim2.new(nsx, nox, nsy, noy)
            if not Config.HUDPositions then Config.HUDPositions = {} end
            Config.HUDPositions[name] = {nsx, nox, nsy, noy}
        end
    end

    if normalizeSize then
        local nsx, nox, nsy, noy = normalizeUDim2(el.Size, ps)
        if nsx then
            el.Size = UDim2.new(nsx, nox, nsy, noy)
            if not Config.HUDSizes then Config.HUDSizes = {} end
            Config.HUDSizes[name] = {nsx, nox, nsy, noy}
        end
    end

    SaveConfig()
end

function selectHUDElement(name, element)
    if HUD.SelectedElement == element then return end
    HUD.SelectedElement = element
    HUD.LastTouchedElement = element
    HUD.LastTouchedName = name

    local parent = element.Parent
    if UI and parent and (parent == UI.Top or parent == UI.Under) then
        local key = parent.Name
        local l = parent:FindFirstChildOfClass("UIListLayout") or (HUD.Layouts and HUD.Layouts[key])
        if l then
            HUD.Layouts[key] = l
            HUD.LayoutsRemoved[key] = true
            l.Parent = nil
        end
    end

    for _, h in pairs(HUD.ResizeHandles) do pcall(function() h:Destroy() end) end
    HUD.ResizeHandles = {}
    for _, c in pairs(HUD.ResizeConnections) do pcall(function() c:Disconnect() end) end
    HUD.ResizeConnections = {}

    local selectionGui = HUD.SelectionGui
    local wrapper = Instance.new("Frame")
    wrapper.Name = "SelectionWrapper"
    wrapper.BackgroundTransparency = 1
    wrapper.ZIndex = 1
    wrapper.Parent = selectionGui

    table.insert(HUD.ResizeHandles, wrapper)
    table.insert(HUD.ResizeConnections, RunService.RenderStepped:Connect(function()
        if HUD.SelectedElement == element and element.Parent then
            wrapper.Size = UDim2.fromOffset(element.AbsoluteSize.X, element.AbsoluteSize.Y)
            wrapper.Position = UDim2.fromOffset(element.AbsolutePosition.X, element.AbsolutePosition.Y)
        end
    end))

    local handlePositions = {
        TopLeft = {UDim2.new(0,0,0,0), Vector2.new(-1, -1)},
        Top = {UDim2.new(0.5,0,0,0), Vector2.new(0, -1)},
        TopRight = {UDim2.new(1,0,0,0), Vector2.new(1, -1)},
        Left = {UDim2.new(0,0,0.5,0), Vector2.new(-1, 0)},
        Right = {UDim2.new(1,0,0.5,0), Vector2.new(1, 0)},
        BottomLeft = {UDim2.new(0,0,1,0), Vector2.new(-1, 1)},
        Bottom = {UDim2.new(0.5,0,1,0), Vector2.new(0, 1)},
        BottomRight = {UDim2.new(1,0,1,0), Vector2.new(1, 1)}
    }

    for dir, data in pairs(handlePositions) do
        local h = Instance.new("Frame")
        h.Name = "Resize_"..dir
        h.Size = UDim2.new(0, 8, 0, 8)
        h.AnchorPoint = Vector2.new(0.5, 0.5)
        h.Position = data[1]
        h.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        h.BorderColor3 = Color3.fromRGB(0, 0, 0)
        h.ZIndex = 11000
        h.Parent = wrapper

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 4, 1, 4)
        btn.Position = UDim2.new(0.5, 0, 0.5, 0)
        btn.AnchorPoint = Vector2.new(0.5, 0.5)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.ZIndex = 11001
        btn.Parent = h

        local resizing = false
        local dragStart
        local startAbsSize
        local startAbsPos
        local resizeUndo

        table.insert(HUD.ResizeConnections, btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                resizing = true
                resizeUndo = captureHUDState(name, element)
                dragStart = input.Position
                startAbsSize = element.AbsoluteSize
                startAbsPos = element.AbsolutePosition
            end
        end))

        table.insert(HUD.ResizeConnections, UserInputService.InputChanged:Connect(function(input)
            if not resizing then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                local pSize = element.Parent and element.Parent.AbsoluteSize or Vector2.new(1, 1)
                
                local dirVec = data[2]
                local newW = startAbsSize.X + (dirVec.X == 1 and delta.X or (dirVec.X == -1 and -delta.X or 0))
                local newH = startAbsSize.Y + (dirVec.Y == 1 and delta.Y or (dirVec.Y == -1 and -delta.Y or 0))
                local newX = startAbsPos.X + (dirVec.X == -1 and delta.X or 0)
                local newY = startAbsPos.Y + (dirVec.Y == -1 and delta.Y or 0)

                if newW < 20 then
                    if dirVec.X == -1 then newX = newX - (20 - newW) end
                    newW = 20
                end
                if newH < 20 then
                    if dirVec.Y == -1 then newY = newY - (20 - newH) end
                    newH = 20
                end

                local parentPos = element.Parent and element.Parent.AbsolutePosition or Vector2.new(0,0)
                local relX = (newX - parentPos.X) / pSize.X
                local relY = (newY - parentPos.Y) / pSize.Y

                element.Size = UDim2.new(newW / pSize.X, 0, newH / pSize.Y, 0)
                element.Position = UDim2.new(relX, 0, relY, 0)
            end
        end))

        table.insert(HUD.ResizeConnections, UserInputService.InputEnded:Connect(function(input)
             if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                 if resizing then
                     resizing = false
                     if resizeUndo and (not sameUDim2(resizeUndo.pos, element.Position) or not sameUDim2(resizeUndo.size, element.Size)) then
                         pushUndo(resizeUndo)
                     end
                     local rPs = element.Parent and element.Parent.AbsoluteSize or Vector2.new(1, 1)
                     local pXs = element.Position.X.Scale + (element.Position.X.Offset / rPs.X)
                     local pYs = element.Position.Y.Scale + (element.Position.Y.Offset / rPs.Y)
                     Config.HUDPositions[name] = {pXs, 0, pYs, 0}
                     if not Config.HUDSizes then Config.HUDSizes = {} end
                     local sXs = element.Size.X.Scale + (element.Size.X.Offset / rPs.X)
                     local sYs = element.Size.Y.Scale + (element.Size.Y.Offset / rPs.Y)
                     Config.HUDSizes[name] = {sXs, 0, sYs, 0}
                 end
             end
        end))
    end
end

function setupElementDragging(name, element, allMovable, snapGuideV, snapGuideH)
    element.Visible = true
    local stroke = Instance.new("UIStroke")
    stroke.Name = "HUDEditorStroke"
    stroke.Color = Color3.fromRGB(0, 255, 100)
    stroke.Thickness = 2
    stroke.Parent = element
    table.insert(HUD.Strokes, stroke)

    local isChild = false
    for _, friendly in pairs(HUD.FriendlyNames) do
        if name == friendly then
            isChild = true
            break
        end
    end

    local inputTarget = Instance.new("TextButton")
    inputTarget.Name = "HUDDragHandle_" .. name
    inputTarget.BackgroundTransparency = 1
    inputTarget.Text = ""
    inputTarget.ZIndex = isChild and 10 or 5
    inputTarget.Active = true
    inputTarget.Parent = HUD.SelectionGui

    table.insert(HUD.Connections, RunService.RenderStepped:Connect(function()
        if element and element.Parent then
            inputTarget.Size = UDim2.fromOffset(element.AbsoluteSize.X, element.AbsoluteSize.Y)
            inputTarget.Position = UDim2.fromOffset(element.AbsolutePosition.X, element.AbsolutePosition.Y)
        end
    end))

    local dragging = false
    local dragStart, startPos
    local dragUndo
    table.insert(HUD.Connections, inputTarget.InputBegan:Connect(function(input)
        if not State.hudEditorActive then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragUndo = captureHUDState(name, element)
            dragStart = input.Position
            startPos = element.Position
            stroke.Color = Color3.fromRGB(255, 255, 255)
            selectHUDElement(name, element)
        end
    end))

    table.insert(HUD.Connections, UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if not dragStart then return end
            local delta = input.Position - dragStart
            local ps = element.Parent and element.Parent.AbsoluteSize or Vector2.new(1, 1)
            local rawPos = UDim2.new(
                startPos.X.Scale + delta.X / ps.X, startPos.X.Offset,
                startPos.Y.Scale + delta.Y / ps.Y, startPos.Y.Offset
            )
            local snapped, gx, gy = calculateSnap(element, rawPos, name, allMovable)
            element.Position = snapped
            local ovP = HUD.Overlay and HUD.Overlay.AbsolutePosition or Vector2.new(0, 0)
            if snapGuideV then snapGuideV.Visible = (gx ~= nil); if gx then snapGuideV.Position = UDim2.fromOffset(gx - ovP.X, 0) end end
            if snapGuideH then snapGuideH.Visible = (gy ~= nil); if gy then snapGuideH.Position = UDim2.fromOffset(0, gy - ovP.Y) end end
        end
    end))

    table.insert(HUD.Connections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                stroke.Color = Color3.fromRGB(0, 255, 100)
                if snapGuideV then snapGuideV.Visible = false end
                if snapGuideH then snapGuideH.Visible = false end
                if dragUndo and not sameUDim2(dragUndo.pos, element.Position) then
                    pushUndo(dragUndo)
                end
                    local dPs = element.Parent and element.Parent.AbsoluteSize or Vector2.new(1, 1)
                    local dpXs = element.Position.X.Scale + (element.Position.X.Offset / dPs.X)
                    local dpYs = element.Position.Y.Scale + (element.Position.Y.Offset / dPs.Y)
                    element.Position = UDim2.new(dpXs, 0, dpYs, 0)
                    Config.HUDPositions[name] = {dpXs, 0, dpYs, 0}
                end
        end
    end))
end

applySavedPositions = function()
    local elems = getAllHUDObjects()
    for name, el in pairs(elems) do
        local customPos = Config.HUDPositions and Config.HUDPositions[name]
        if customPos and type(customPos) == "table" and #customPos == 4 then
            el.Position = UDim2.new(customPos[1], customPos[2], customPos[3], customPos[4])
        elseif HUD.DefaultPositions and HUD.DefaultPositions[name] then
             el.Position = HUD.DefaultPositions[name]
        end

        local customSz = Config.HUDSizes and Config.HUDSizes[name]
        if customSz and type(customSz) == "table" and #customSz == 4 then
            el.Size = UDim2.new(customSz[1], customSz[2], customSz[3], customSz[4])
        elseif HUD.DefaultSizes and HUD.DefaultSizes[name] then
             el.Size = HUD.DefaultSizes[name]
        end

        local props = Config.HUDProperties and Config.HUDProperties[name]
        if props then
            for k, v in pairs(props) do
                pcall(function()
                    if k == "Radius" or k == "CornerRadius" then
                        local cR = el:FindFirstChildWhichIsA("UICorner")
                        if cR and type(v) == "table" then
                             cR.CornerRadius = UDim.new(tonumber(v[1]) or 0, tonumber(v[2]) or 0)
                        end
                    elseif k == "RadiusString" or k == "PlaceholderTransparency" then
                    else
                        el[k] = v
                    end
                end)
            end
        end
    end
end

exitHUDEditor = function()
    if not State.hudEditorActive then return end
    State.hudEditorActive = false
    if SettingsLib and SettingsLib.UI and SettingsLib.UI:IsA("ScreenGui") and HUD.SettingsDisplayOrderPrev ~= nil then
        pcall(function()
            SettingsLib.UI.DisplayOrder = HUD.SettingsDisplayOrderPrev
        end)
        HUD.SettingsDisplayOrderPrev = nil
    end
    for _, conn in pairs(HUD.Connections) do pcall(function() conn:Disconnect() end) end
    HUD.Connections = {}
    for _, conn in pairs(HUD.ResizeConnections) do pcall(function() conn:Disconnect() end) end
    HUD.ResizeConnections = {}
    for _, h in pairs(HUD.ResizeHandles) do pcall(function() h:Destroy() end) end
    HUD.ResizeHandles = {}
    HUD.SelectedElement = nil
    for _, stroke in pairs(HUD.Strokes) do
        pcall(function() if stroke and stroke.Parent then stroke:Destroy() end end)
    end
    HUD.Strokes = {}

    if HUD.SelectionGui then
        pcall(function() HUD.SelectionGui:Destroy() end)
        HUD.SelectionGui = nil
    end
    for _, el in pairs(getMovableElements()) do
        local h = el:FindFirstChild("HUDDragHandle")
        if h then h:Destroy() end
        if el:FindFirstChildOfClass("UIListLayout") then
            for _, child in pairs(el:GetChildren()) do
                if child:IsA("GuiButton") or child:IsA("TextBox") then
                    child.Active = true
                end
            end
        end
    end
    if HUD.Overlay then
        for _, g in pairs(HUD.Overlay:GetChildren()) do
            if g.Name == "SnapGuide" then g:Destroy() end
        end
    end
    if HUD.Overlay and HUD.Overlay.Parent then HUD.Overlay:Destroy() end
    HUD.Overlay = nil
    if HUD.ForceVisibleConn then HUD.ForceVisibleConn:Disconnect(); HUD.ForceVisibleConn = nil end
    if UI.Search then UI.Search.TextEditable = true; UI.Search.Active = true end
    if UI.SpeedBox then UI.SpeedBox.TextEditable = true; UI.SpeedBox.Active = true end
    if UI._2Routenumber then UI._2Routenumber.TextEditable = true; UI._2Routenumber.Active = true end
    pcall(function() game:GetService("GuiService"):SetEmotesMenuOpen(false) end)
    pcall(function() game:GetService("CoreGui").RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Visible = false end)
end

enterHUDEditor = function()
    if State.hudEditorActive then return end
    State.hudEditorActive = true
    HUD.UndoStack = {}

    GuiService:SetEmotesMenuOpen(false)
    task.wait(0.15)

    local exists, emotesWheel = checkEmotesMenuExists()
    if not exists then State.hudEditorActive = false; return end
    emotesWheel.Visible = true

    HUD.ForceVisibleConn = RunService.Heartbeat:Connect(function()
        if not State.hudEditorActive then return end
        pcall(function()
            local _, ew = checkEmotesMenuExists()
            if ew then ew.Visible = true end
        end)
    end)

    local main = getSettingsMainFrame()
    if main then main.Visible = false end
    syncToggleVisibility()
    if SettingsLib and SettingsLib.UI and SettingsLib.UI:IsA("ScreenGui") then
        if HUD.SettingsDisplayOrderPrev == nil then
            HUD.SettingsDisplayOrderPrev = SettingsLib.UI.DisplayOrder
        end
        pcall(function() SettingsLib.UI.DisplayOrder = 99998 end)
    end
    ApplyUIVisibility()

    local selectionGui = game:GetService("CoreGui"):FindFirstChild("7yd7_HUDSelection")
    if not selectionGui then
        selectionGui = Instance.new("ScreenGui")
        selectionGui.Name = "7yd7_HUDSelection"
        selectionGui.IgnoreGuiInset = false
        selectionGui.DisplayOrder = 99999
        selectionGui.Parent = game:GetService("CoreGui")
    else
        selectionGui.IgnoreGuiInset = false
        selectionGui.DisplayOrder = 99999
    end
    HUD.SelectionGui = selectionGui

    local overlay = Instance.new("Frame")
    overlay.Name = "HUDEditorOverlay"
    overlay.Parent = SettingsLib.UI
    overlay.BackgroundTransparency = 1
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.ZIndex = 6000
    overlay.Active = false
    HUD.Overlay = overlay
    table.insert(HUD.Connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if not State.hudEditorActive then return end
        if input.KeyCode == Enum.KeyCode.Z then
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
                undoLastHUD()
            end
        end
    end))
    table.insert(HUD.Connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local p = input.Position
            if HUD.SelectedElement then
                local e = HUD.SelectedElement
                local pos = e.AbsolutePosition
                local sz = e.AbsoluteSize
                if p.X < pos.X - 25 or p.X > pos.X + sz.X + 25 or p.Y < pos.Y - 25 or p.Y > pos.Y + sz.Y + 25 then
                    task.delay(0.1, function()
                        if HUD.SelectedElement == e then
                            HUD.SelectedElement = nil
                            for _, h in pairs(HUD.ResizeHandles) do pcall(function() h:Destroy() end) end
                            HUD.ResizeHandles = {}
                            for _, c in pairs(HUD.ResizeConnections) do pcall(function() c:Disconnect() end) end
                            HUD.ResizeConnections = {}
                        end
                    end)
                end
            end
        end
    end))

    local bc = Instance.new("Frame")
    bc.Parent = overlay
    bc.BackgroundTransparency = 1
    bc.AnchorPoint = Vector2.new(1, 0)
    bc.Position = UDim2.new(1, -10, 0, 10)
    bc.Size = UDim2.fromOffset(360, 42)
    bc.ZIndex = 6000

    local bl = Instance.new("UIListLayout")
    bl.FillDirection = Enum.FillDirection.Horizontal
    bl.Padding = UDim.new(0, 8)
    bl.HorizontalAlignment = Enum.HorizontalAlignment.Right
    bl.VerticalAlignment = Enum.VerticalAlignment.Center
    bl.Parent = bc

    local propertiesBtn = Instance.new("ImageButton")
    propertiesBtn.Parent = bc
    propertiesBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    propertiesBtn.BackgroundTransparency = 0.4
    propertiesBtn.Size = UDim2.fromOffset(42, 42)
    propertiesBtn.Image = "rbxassetid://111026029750357"
    propertiesBtn.ZIndex = 6001
    local propCorner = Instance.new("UICorner")
    propCorner.CornerRadius = UDim.new(0, 10)
    propCorner.Parent = propertiesBtn

    local exportBtn = Instance.new("ImageButton")
    exportBtn.Parent = bc
    exportBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    exportBtn.BackgroundTransparency = 0.4
    exportBtn.Size = UDim2.fromOffset(42, 42)
    exportBtn.Image = "rbxassetid://107588515524752"
    exportBtn.ZIndex = 6001
    local exportCorner = Instance.new("UICorner")
    exportCorner.CornerRadius = UDim.new(0, 10)
    exportCorner.Parent = exportBtn

    local importBtn = Instance.new("ImageButton")
    importBtn.Parent = bc
    importBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    importBtn.BackgroundTransparency = 0.4
    importBtn.Size = UDim2.fromOffset(42, 42)
    importBtn.Image = "rbxassetid://78317476576895"
    importBtn.ZIndex = 6001
    local importCorner = Instance.new("UICorner")
    importCorner.CornerRadius = UDim.new(0, 10)
    importCorner.Parent = importBtn

    local resetBtn = Instance.new("ImageButton")
    resetBtn.Parent = bc
    resetBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    resetBtn.BackgroundTransparency = 0.4
    resetBtn.Size = UDim2.fromOffset(42, 42)
    resetBtn.Image = "rbxassetid://123088523596870"
    resetBtn.ZIndex = 6001
    local resetCorner = Instance.new("UICorner")
    resetCorner.CornerRadius = UDim.new(0, 10)
    resetCorner.Parent = resetBtn

    local lockBtn = Instance.new("ImageButton")
    lockBtn.Parent = bc
    lockBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    lockBtn.BackgroundTransparency = 0.4
    lockBtn.Size = UDim2.fromOffset(42, 42)
    lockBtn.Image = HUD.IsUnlocked and "rbxassetid://137042445663198" or "rbxassetid://137985778533954"
    lockBtn.ZIndex = 6001
    local lockCorner = Instance.new("UICorner")
    lockCorner.CornerRadius = UDim.new(0, 10)
    lockCorner.Parent = lockBtn

    local addBtn = Instance.new("ImageButton")
    addBtn.Parent = bc
    addBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    addBtn.BackgroundTransparency = 0.4
    addBtn.Size = UDim2.fromOffset(42, 42)
    addBtn.Image = "rbxassetid://108445456753346"
    addBtn.ZIndex = 6001
    local addCorner = Instance.new("UICorner")
    addCorner.CornerRadius = UDim.new(0, 10)
    addCorner.Parent = addBtn

    local backBtn = Instance.new("ImageButton")
    backBtn.Parent = bc
    backBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    backBtn.BackgroundTransparency = 0.4
    backBtn.Size = UDim2.fromOffset(42, 42)
    backBtn.Image = "rbxassetid://79024388644722"
    backBtn.ZIndex = 6001
    local backCorner = Instance.new("UICorner")
    backCorner.CornerRadius = UDim.new(0, 10)
    backCorner.Parent = backBtn



    local function rebuildHUDOverlays()
        for _, conn in pairs(HUD.ResizeConnections) do pcall(function() conn:Disconnect() end) end
        HUD.ResizeConnections = {}
        for _, h in pairs(HUD.ResizeHandles) do pcall(function() h:Destroy() end) end
        HUD.ResizeHandles = {}
        for _, stroke in pairs(HUD.Strokes) do pcall(function() stroke:Destroy() end) end
        HUD.Strokes = {}
        if selectionGui then selectionGui:ClearAllChildren() end
        HUD.SelectedElement = nil
        
        local allMovable = getMovableElements()
        
        local snapGuideH = Instance.new("Frame")
        snapGuideH.Name = "SnapGuide"
        snapGuideH.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        snapGuideH.BorderSizePixel = 0
        snapGuideH.Size = UDim2.new(1, 0, 0, 1)
        snapGuideH.ZIndex = 6002
        snapGuideH.Visible = false
        snapGuideH.Parent = selectionGui

        local snapGuideV = Instance.new("Frame")
        snapGuideV.Name = "SnapGuide"
        snapGuideV.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        snapGuideV.BorderSizePixel = 0
        snapGuideV.Size = UDim2.new(0, 1, 1, 0)
        snapGuideV.ZIndex = 6002
        snapGuideV.Visible = false
        snapGuideV.Parent = selectionGui

        for name, element in pairs(allMovable) do
            setupElementDragging(name, element, allMovable, snapGuideV, snapGuideH)
        end
        
        updateHUDLayouts()
        
        applySavedPositions()
    end

    local function rebuildCustomFramesFromConfig()
        if UI.CustomFrames then
            for _, frame in pairs(UI.CustomFrames) do
                if frame and frame.Parent then frame:Destroy() end
            end
        end
        UI.CustomFrames = {}

        if not Config.CustomFrames then return end
        local _, emotesWheel = checkEmotesMenuExists()
        if not emotesWheel then return end

        for name, data in pairs(Config.CustomFrames) do
            local cf = Instance.new("Frame")
            cf.Name = name
            cf.Parent = emotesWheel
            cf.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            cf.BackgroundTransparency = 0.4
            cf.ZIndex = data and data.ZIndex or 3
            cf.BorderSizePixel = 0
            cf.Active = true

            local pos = Config.HUDPositions and Config.HUDPositions[name]
            local size = Config.HUDSizes and Config.HUDSizes[name]
            if pos and type(pos) == "table" and #pos == 4 then
                cf.Position = UDim2.new(pos[1], pos[2], pos[3], pos[4])
            else
                cf.Position = UDim2.new(0.5, 0, 0.5, 0)
            end
            if size and type(size) == "table" and #size == 4 then
                cf.Size = UDim2.new(size[1], size[2], size[3], size[4])
            else
                cf.Size = UDim2.new(0.3, 0, 0.3, 0)
            end

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = cf

            UI.CustomFrames[name] = cf
            HUD.DefaultPositions[name] = cf.Position
            HUD.DefaultSizes[name] = cf.Size
        end
    end

    local function applyHUDSettingsReplace(settings)
        local function normalizeImportTable(tbl)
            if type(tbl) ~= "table" then return {} end
            local allElems = getAllHUDObjects()
            for eName, v in pairs(tbl) do
                if type(v) == "table" and #v == 4 then
                    local sx, ox, sy, oy = v[1], v[2], v[3], v[4]
                    if ox ~= 0 or oy ~= 0 then
                        local el = allElems[eName]
                        local ps = el and el.Parent and el.Parent.AbsoluteSize
                        if ps and ps.X > 0 and ps.Y > 0 then
                            tbl[eName] = {sx + (ox / ps.X), 0, sy + (oy / ps.Y), 0}
                        end
                    end
                end
            end
            return tbl
        end
        Config.HUDPositions = normalizeImportTable(settings.HUDPositions or {})
        Config.HUDSizes = normalizeImportTable(settings.HUDSizes or {})
        Config.HUDProperties = settings.HUDProperties or {}
        Config.CustomFrames = settings.CustomFrames or {}
        HUD.LayoutsRemoved = {}
        SaveConfig()
        rebuildCustomFramesFromConfig()
        applySavedPositions()

        rebuildHUDOverlays()
        updateHUDLayouts()
        ApplyUIVisibility()
        pcall(function() updateGUIColors() end)
    end

    table.insert(HUD.Connections, lockBtn.MouseButton1Click:Connect(function()
        HUD.IsUnlocked = not HUD.IsUnlocked
        lockBtn.Image = HUD.IsUnlocked and "rbxassetid://137042445663198" or "rbxassetid://137985778533954"
        rebuildHUDOverlays()
        pcall(function() updateGUIColors() end)
        getgenv().Notify({ 
            Title = "7yd7 | HUD Editor", 
            Content = HUD.IsUnlocked and "🔓 Interior Unlocked! Children are now editable." or "🔒 Interior Locked! Top-level only.", 
            Duration = 2 
        })
    end))

    rebuildHUDOverlays()

    table.insert(HUD.Connections, exportBtn.MouseButton1Click:Connect(function()
        local function normalizeExportTable(tbl)
            if type(tbl) ~= "table" then return {} end
            local out = {}
            local allElems = getAllHUDObjects()
            for eName, v in pairs(tbl) do
                if type(v) == "table" and #v == 4 then
                    local sx, ox, sy, oy = v[1], v[2], v[3], v[4]
                    if ox ~= 0 or oy ~= 0 then
                        local el = allElems[eName]
                        local ps = el and el.Parent and el.Parent.AbsoluteSize
                        if ps and ps.X > 0 and ps.Y > 0 then
                            sx = sx + (ox / ps.X)
                            sy = sy + (oy / ps.Y)
                        end
                    end
                    out[eName] = {sx, 0, sy, 0}
                else
                    out[eName] = v
                end
            end
            return out
        end
        local function normalizeExportProps(props)
            if type(props) ~= "table" then return {} end
            local out = {}
            local allElems = getAllHUDObjects()
            for eName, p in pairs(props) do
                local ep = {}
                for k, v in pairs(p) do
                    if (k == "CornerRadius" or k == "Radius") and type(v) == "table" and #v == 2 then
                        local rs, ro = v[1], v[2]
                        if ro ~= 0 and rs == 0 then
                            local el = allElems[eName]
                            if el then
                                local minDim = math.min(el.AbsoluteSize.X, el.AbsoluteSize.Y)
                                if minDim > 0 then
                                    rs = ro / minDim
                                    ro = 0
                                end
                            end
                        end
                        ep[k] = {rs, ro}
                    else
                        ep[k] = v
                    end
                end
                out[eName] = ep
            end
            return out
        end
        local data = {
            Type = "HUD",
            Settings = {
                HUDPositions = normalizeExportTable(Config.HUDPositions or {}),
                HUDSizes = normalizeExportTable(Config.HUDSizes or {}),
                HUDProperties = normalizeExportProps(Config.HUDProperties or {}),
                CustomFrames = Config.CustomFrames or {}
            }
        }
        setclipboard(HttpService:JSONEncode(data))
        getgenv().Notify({ Title = "7yd7 | HUD Editor", Content = "✅ HUD settings copied", Duration = 2 })
    end))

    table.insert(HUD.Connections, importBtn.MouseButton1Click:Connect(function()
        local popup, content = CreatePopup("Import HUD", UDim2.fromOffset(320, 240))
        local popupRoot = HUD.SelectionGui or SettingsLib.UI
        if popupRoot and popup.Parent ~= popupRoot then
            popup.Parent = popupRoot
        end

        local baseZ = 7000
        popup.ZIndex = baseZ

        local backdrop = Instance.new("TextButton")
        backdrop.Name = "HUDImportBackdrop"
        backdrop.Parent = popup.Parent
        backdrop.Size = UDim2.fromScale(1, 1)
        backdrop.BackgroundTransparency = 1
        backdrop.Text = ""
        backdrop.AutoButtonColor = false
        backdrop.ZIndex = baseZ - 1
        backdrop.Active = true

        local scroll = Instance.new("ScrollingFrame")
        scroll.Parent = content
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.Position = UDim2.new(0.05, 0, 0, 5)
        scroll.Size = UDim2.new(0.9, 0, 0, 130)
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.ScrollBarThickness = 4
        scroll.Active = true
        scroll.ScrollingEnabled = true
        scroll.ScrollingDirection = Enum.ScrollingDirection.Y
        scroll.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable

        local box = CreateInput(scroll, "Paste HUD JSON here...", "", true)
        box.Size = UDim2.new(1, -8, 0, 130)
        box.Position = UDim2.new(0, 0, 0, 0)
        box.TextYAlignment = Enum.TextYAlignment.Top
        box.ClearTextOnFocus = false

        local function updateCanvas()
            local padding = 8
            local h = math.max(130, (box.TextBounds.Y or 0) + padding)
            scroll.CanvasSize = UDim2.new(0, 0, 0, h)
        end
        box:GetPropertyChangedSignal("Text"):Connect(updateCanvas)
        box:GetPropertyChangedSignal("TextBounds"):Connect(updateCanvas)
        updateCanvas()

        local imp = CreateButton(content, "IMPORT HUD", (State.EmoteTheme and State.EmoteTheme.Accent) or Color3.fromRGB(0, 255, 150), UDim2.new(0.05, 0, 0.8, 0), UDim2.new(0.9, 0, 0, 35))

        imp.MouseButton1Click:Connect(function()
            local s, d = pcall(function() return HttpService:JSONDecode(box.Text) end)
            if s and type(d) == "table" then
                local settings = d.Settings or d
                if d.Type and d.Type ~= "HUD" then
                    getgenv().Notify({ Title = "Error", Content = "HUD import type mismatch!", Duration = 3 })
                    return
                end
                if type(settings) ~= "table" then
                    getgenv().Notify({ Title = "Error", Content = "Invalid HUD JSON", Duration = 3 })
                    return
                end
                applyHUDSettingsReplace(settings)
                HUD.UndoStack = {}
                if backdrop then backdrop:Destroy() end
                popup:Destroy()
                getgenv().Notify({ Title = "7yd7 | HUD Editor", Content = "✅ HUD settings imported", Duration = 2 })
            else
                getgenv().Notify({ Title = "Error", Content = "Invalid HUD JSON", Duration = 3 })
            end
        end)

        local close = Instance.new("TextButton")
        close.Size = UDim2.fromOffset(24, 24)
        close.Position = UDim2.new(1, -30, 0, 5)
        close.Text = "×"
        close.Font = Enum.Font.GothamBold
        close.TextSize = 20
        close.BackgroundTransparency = 1
        close.TextColor3 = Color3.new(1,1,1)
        close.ZIndex = baseZ + 2
        close.Active = true
        close.AutoButtonColor = false
        close.Parent = popup
        close.MouseButton1Click:Connect(function()
            if backdrop then backdrop:Destroy() end
            popup:Destroy()
        end)
        backdrop.MouseButton1Click:Connect(function()
            if backdrop then backdrop:Destroy() end
            popup:Destroy()
        end)

        local function bumpPopupZIndex(panel, z)
            if not panel then return end
            panel.ZIndex = z
            for _, d in ipairs(panel:GetDescendants()) do
                if d:IsA("GuiObject") then
                    d.ZIndex = z + 1
                end
            end
        end
        bumpPopupZIndex(popup, baseZ)
        close.ZIndex = baseZ + 2
    end))

    table.insert(HUD.Connections, backBtn.MouseButton1Click:Connect(function()
        exitHUDEditor()
    end))

    table.insert(HUD.Connections, resetBtn.MouseButton1Click:Connect(function()
        Config.HUDPositions = {}
        Config.HUDSizes = {}
        Config.CustomFrames = {}
        Config.HUDProperties = {}
        HUD.LayoutsRemoved = {}
        SaveConfig()
        
        local allElements = getAllHUDObjects()
        for name, el in pairs(allElements) do
            if name:match("^CustomFrame_") then
                el:Destroy()
                if UI.CustomFrames then UI.CustomFrames[name] = nil end
            else
                if HUD.DefaultPositions[name] then el.Position = HUD.DefaultPositions[name] end
                if HUD.DefaultSizes[name] then el.Size = HUD.DefaultSizes[name] end
                
                for internal, friendly in pairs(HUD.FriendlyNames) do
                    if name == friendly then
                        if internal:match("^Under%.") then
                            el.Parent = UI.Under
                        elseif internal:match("^Top%.") then
                            el.Parent = UI.Top
                        end
                        break
                    end
                end

                el.ZIndex = (name == "Top" or name == "Under") and 3 or (el:IsA("ImageButton") and 4 or 3)
                if name == "Under" then
                    el.BackgroundTransparency = 1
                else
                    el.BackgroundTransparency = (name == "Top" or name == "Reload" or name == "Changepage" or name == "EmoteWalkButton" or name == "SpeedBox" or name == "SpeedEmote" or name == "Favorite") and 0.4 or 1
                end
                
                if el:IsA("ImageButton") or el:IsA("ImageLabel") then
                    el.ImageTransparency = 0
                end
                
                if el:IsA("TextLabel") or el:IsA("TextBox") then
                    el.TextTransparency = 0.4
                    if HUD.DefaultTexts and HUD.DefaultTexts[name] then
                        el.Text = HUD.DefaultTexts[name]
                    end
                    if el:IsA("TextBox") and HUD.DefaultPlaceholders and HUD.DefaultPlaceholders[name] then
                        el.PlaceholderText = HUD.DefaultPlaceholders[name]
                    end
                end

                local cR = el:FindFirstChildWhichIsA("UICorner")
                if cR then
                    cR.CornerRadius = UDim.new(0, 10)
                end
            end
        end

        pcall(function() updateGUIColors() end)
        
        HUD.SelectedElement = nil
        for _, h in pairs(HUD.ResizeHandles) do pcall(function() h:Destroy() end) end
        HUD.ResizeHandles = {}
        for _, c in pairs(HUD.ResizeConnections) do pcall(function() c:Disconnect() end) end
        HUD.ResizeConnections = {}
        
        rebuildHUDOverlays()
        updateHUDLayouts()
        ApplyUIVisibility()
        State.totalPages = calculateTotalPages()
        if State.currentPage > State.totalPages then
            State.currentPage = State.totalPages
        end
        updatePageDisplay()
        
        getgenv().Notify({ Title = "7yd7 | HUD Editor", Content = "🔄 All designs and frames have been fully reset", Duration = 3 })
    end))

    local propertiesPanel = Instance.new("Frame")
    propertiesPanel.Name = "HUDPropertiesPanel"
    propertiesPanel.Parent = overlay
    propertiesPanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    propertiesPanel.BackgroundTransparency = 0.4
    propertiesPanel.Size = UDim2.fromOffset(260, 150)
    propertiesPanel.AnchorPoint = Vector2.new(1, 0)
    propertiesPanel.Position = UDim2.new(1, -10, 0, 60)
    propertiesPanel.Visible = false
    propertiesPanel.ZIndex = 6005
    propertiesPanel.ClipsDescendants = true
    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 10)
    panelCorner.Parent = propertiesPanel
    
    local title = Instance.new("TextLabel")
    title.Parent = propertiesPanel
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 26)
    title.Position = UDim2.new(0, 0, 0, 2)
    title.Font = Enum.Font.SourceSansBold
    title.Text = "No Element"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 14
    title.TextScaled = true
    title.ZIndex = 6006

    local propContent = Instance.new("ScrollingFrame")
    propContent.Parent = propertiesPanel
    propContent.BackgroundTransparency = 1
    propContent.Position = UDim2.new(0, 0, 0, 28)
    propContent.Size = UDim2.new(1, 0, 1, -32)
    propContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    propContent.ScrollBarThickness = 2
    propContent.Active = true
    propContent.ScrollingEnabled = true
    propContent.ZIndex = 6006

    local propLayout = Instance.new("UIListLayout")
    propLayout.Parent = propContent
    propLayout.SortOrder = Enum.SortOrder.LayoutOrder
    propLayout.Padding = UDim.new(0, 6)
    propLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    HUD.LastTouchedElement = nil
    HUD.LastTouchedName = nil

    local function createPropRow(label, lOrder, isLarge)
        local row = Instance.new("Frame")
        row.BackgroundTransparency = 1
        row.Size = UDim2.new(0.92, 0, 0, isLarge and 50 or 26)
        row.LayoutOrder = lOrder
        row.ZIndex = 6006
        row.Parent = propContent

        local lbl = Instance.new("TextLabel")
        lbl.Parent = row
        lbl.Size = UDim2.new(0, 70, 0, 26)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Font = Enum.Font.SourceSansBold
        lbl.TextSize = 12
        lbl.ZIndex = 6007

        local tbox = Instance.new("TextBox")
        tbox.Parent = row
        tbox.Size = UDim2.new(1, -75, 1, -4)
        tbox.Position = UDim2.new(0, 75, 0, 2)
        tbox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tbox.BackgroundTransparency = 0.3
        tbox.TextColor3 = Color3.fromRGB(255, 255, 255)
        tbox.Font = Enum.Font.Code
        tbox.TextSize = 12
        tbox.TextXAlignment = isLarge and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
        tbox.TextYAlignment = isLarge and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
        tbox.ClearTextOnFocus = false
        tbox.TextWrapped = isLarge
        tbox.PlaceholderText = ""
        tbox.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
        tbox.ZIndex = 6007
        local tc = Instance.new("UICorner"); tc.CornerRadius = UDim.new(0, 6); tc.Parent = tbox

        return row, tbox
    end

    local _, posBox = createPropRow("Position", 1)
    local _, sizeBox = createPropRow("Size", 2)
    local zRow, zBox = createPropRow("ZIndex", 3)
    local bgRow, bgBox = createPropRow("BgTrans", 4)
    local bgcRow, bgcBox = createPropRow("BgColor", 5)
    local imgRow, imgBox = createPropRow("ImgTrans", 6)
    local imgcRow, imgcBox = createPropRow("ImgColor", 7)
    local radRow, radBox = createPropRow("Radius", 8)
    local txtRow, txtBox = createPropRow("Text", 9, true)
    local phRow, phBox = createPropRow("Placeholder", 10, true)
    local ttrRow, ttrBox = createPropRow("TxtTrans", 11)
    local txtcRow, txtcBox = createPropRow("TxtColor", 12)

    local deleteRow = Instance.new("Frame")
    deleteRow.BackgroundTransparency = 1
    deleteRow.Size = UDim2.new(0.92, 0, 0, 28)
    deleteRow.LayoutOrder = 13
    deleteRow.ZIndex = 6006
    deleteRow.Parent = propContent

    local deleteBtn = Instance.new("TextButton")
    deleteBtn.Parent = deleteRow
    deleteBtn.Size = UDim2.new(1, 0, 1, 0)
    deleteBtn.BackgroundColor3 = Color3.fromRGB(170, 60, 60)
    deleteBtn.BackgroundTransparency = 0.1
    deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    deleteBtn.Font = Enum.Font.GothamBold
    deleteBtn.TextSize = 12
    deleteBtn.Text = "Delete Custom Frame"
    deleteBtn.ZIndex = 6007
    local delCorner = Instance.new("UICorner"); delCorner.CornerRadius = UDim.new(0, 6); delCorner.Parent = deleteBtn



    local function parseUDim2(text)
        local s1, o1, s2, o2 = text:match("{%s*([%d%.%-]+)%s*,%s*([%d%.%-]+)%s*}%s*,%s*{%s*([%d%.%-]+)%s*,%s*([%d%.%-]+)%s*}")
        if s1 and o1 and s2 and o2 then
            return tonumber(s1), tonumber(o1), tonumber(s2), tonumber(o2)
        end
        local a, b = text:match("([%d%.%-]+)%s*,%s*([%d%.%-]+)")
        if a and b then
            local va, vb = tonumber(a), tonumber(b)
            if va and vb then
                return 0, va, 0, vb
            end
        end
        return nil
    end

    local function formatUDim2(udim)
        return string.format("{%g, %g},{%g, %g}", udim.X.Scale, udim.X.Offset, udim.Y.Scale, udim.Y.Offset)
    end

    table.insert(HUD.Connections, propertiesBtn.MouseButton1Click:Connect(function()
        propertiesPanel.Visible = not propertiesPanel.Visible
    end))

    local function formatUDim(udim)
        return string.format("{%g, %g}", udim.Scale, udim.Offset)
    end

    local function formatRGB(c)
        return string.format("%d, %d, %d", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
    end

    local function parseRGB(text)
        local a, b, c = text:match("([%d%.%-]+)%s*,%s*([%d%.%-]+)%s*,%s*([%d%.%-]+)")
        if not a then return nil end
        local r, g, b2 = tonumber(a), tonumber(b), tonumber(c)
        if not r or not g or not b2 then return nil end
        local maxv = math.max(r, g, b2)
        if maxv <= 1 then
            r, g, b2 = r * 255, g * 255, b2 * 255
        end
        r = math.clamp(r, 0, 255)
        g = math.clamp(g, 0, 255)
        b2 = math.clamp(b2, 0, 255)
        return r, g, b2
    end

    table.insert(HUD.Connections, RunService.RenderStepped:Connect(function()
        if not propertiesPanel.Visible then return end
        local e = HUD.LastTouchedElement
        local eName = HUD.LastTouchedName
        if e and e.Parent then
            title.Text = string.format("[%s] %s", e.ClassName, eName or "Unknown")
            if not posBox:IsFocused() then posBox.Text = formatUDim2(e.Position) end
            if not sizeBox:IsFocused() then sizeBox.Text = formatUDim2(e.Size) end
            
            zRow.Visible = true
            if not zBox:IsFocused() then zBox.Text = tostring(e.ZIndex) end

            bgRow.Visible = true
            if not bgBox:IsFocused() then bgBox.Text = tostring(math.floor(e.BackgroundTransparency * 100) / 100) end

            if e:IsA("ImageLabel") or e:IsA("ImageButton") then
                imgRow.Visible = true
                if not imgBox:IsFocused() then imgBox.Text = tostring(math.floor(e.ImageTransparency * 100) / 100) end
            else
                imgRow.Visible = false
            end
            
            bgcRow.Visible = true
            if not bgcBox:IsFocused() then bgcBox.Text = formatRGB(e.BackgroundColor3) end
            
            if e:IsA("ImageLabel") or e:IsA("ImageButton") then
                imgcRow.Visible = true
                if not imgcBox:IsFocused() then imgcBox.Text = formatRGB(e.ImageColor3) end
            else
                imgcRow.Visible = false
            end
            
            if e:IsA("TextLabel") or e:IsA("TextBox") then
                ttrRow.Visible = true
                if not ttrBox:IsFocused() then ttrBox.Text = tostring(math.floor(e.TextTransparency * 100) / 100) end
                
                txtRow.Visible = true
                if not txtBox:IsFocused() then txtBox.Text = e.Text end

                txtcRow.Visible = true
                if not txtcBox:IsFocused() then txtcBox.Text = formatRGB(e.TextColor3) end
                
                if e:IsA("TextBox") then
                    phRow.Visible = true
                    if not phBox:IsFocused() then phBox.Text = e.PlaceholderText end
                else
                    phRow.Visible = false
                end
            else
                ttrRow.Visible = false
                txtRow.Visible = false
                phRow.Visible = false
                txtcRow.Visible = false
            end

            deleteRow.Visible = (eName and eName:match("^CustomFrame_")) and true or false


            local cR = e:FindFirstChildWhichIsA("UICorner")
            if cR then
                radRow.Visible = true
                if not radBox:IsFocused() then radBox.Text = formatUDim(cR.CornerRadius) end
            else
                radRow.Visible = false
            end
        else
            title.Text = "No Element Selected"
            zRow.Visible = false
            bgRow.Visible = false
            imgRow.Visible = false
            bgcRow.Visible = false
            imgcRow.Visible = false
            radRow.Visible = false
            ttrRow.Visible = false
            txtRow.Visible = false
            phRow.Visible = false
            txtcRow.Visible = false
            deleteRow.Visible = false
            if not posBox:IsFocused() then posBox.Text = "" end
            if not sizeBox:IsFocused() then sizeBox.Text = "" end
        end
        
        local totalH = propLayout.AbsoluteContentSize.Y + 10
        propContent.CanvasSize = UDim2.new(0, 0, 0, totalH)
        local vpY = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.Y or 800
        local maxH = math.floor(vpY * 0.55)
        propertiesPanel.Size = UDim2.fromOffset(260, math.min(maxH, totalH + 40))
    end))

    local function saveHUDProp(eName, propKey, val)
        if not Config.HUDProperties then Config.HUDProperties = {} end
        if not Config.HUDProperties[eName] then Config.HUDProperties[eName] = {} end
        Config.HUDProperties[eName][propKey] = val
        SaveConfig()
    end

    table.insert(HUD.Connections, deleteBtn.MouseButton1Click:Connect(function()
        local eName = HUD.LastTouchedName
        if not eName or not eName:match("^CustomFrame_") then return end
        local frame = UI.CustomFrames and UI.CustomFrames[eName]
        if frame and frame.Parent then frame:Destroy() end
        if UI.CustomFrames then UI.CustomFrames[eName] = nil end
        if Config.CustomFrames then Config.CustomFrames[eName] = nil end
        if Config.HUDPositions then Config.HUDPositions[eName] = nil end
        if Config.HUDSizes then Config.HUDSizes[eName] = nil end
        if Config.HUDProperties then Config.HUDProperties[eName] = nil end
        if HUD.DefaultPositions then HUD.DefaultPositions[eName] = nil end
        if HUD.DefaultSizes then HUD.DefaultSizes[eName] = nil end
        if HUD.DefaultTexts then HUD.DefaultTexts[eName] = nil end
        if HUD.DefaultPlaceholders then HUD.DefaultPlaceholders[eName] = nil end
        SaveConfig()

        HUD.SelectedElement = nil
        HUD.LastTouchedElement = nil
        HUD.LastTouchedName = nil
        for _, h in pairs(HUD.ResizeHandles) do pcall(function() h:Destroy() end) end
        HUD.ResizeHandles = {}
        for _, c in pairs(HUD.ResizeConnections) do pcall(function() c:Disconnect() end) end
        HUD.ResizeConnections = {}

        rebuildHUDOverlays()
        updateHUDLayouts()
        ApplyUIVisibility()
        pcall(function() updateGUIColors() end)
        getgenv().Notify({ Title = "7yd7 | HUD Editor", Content = "🗑️ Custom Frame deleted", Duration = 2 })
    end))



    table.insert(HUD.Connections, posBox.FocusLost:Connect(function()
        local e, eName = HUD.LastTouchedElement, HUD.LastTouchedName
        if not e or not e.Parent or not eName then return end
        local s1, o1, s2, o2 = parseUDim2(posBox.Text)
        if s1 then
            local prev = captureHUDState(eName, e)
            e.Position = UDim2.new(s1, o1, s2, o2)
            if prev and not sameUDim2(prev.pos, e.Position) then
                pushUndo(prev)
            end
            Config.HUDPositions[eName] = {s1, o1, s2, o2}
        end
    end))

    table.insert(HUD.Connections, sizeBox.FocusLost:Connect(function()
        local e, eName = HUD.LastTouchedElement, HUD.LastTouchedName
        if not e or not e.Parent or not eName then return end
        local s1, o1, s2, o2 = parseUDim2(sizeBox.Text)
        if s1 then
            local prev = captureHUDState(eName, e)
            e.Size = UDim2.new(s1, o1, s2, o2)
            if prev and not sameUDim2(prev.size, e.Size) then
                pushUndo(prev)
            end
            if not Config.HUDSizes then Config.HUDSizes = {} end
            Config.HUDSizes[eName] = {s1, o1, s2, o2}
        end
    end))

    table.insert(HUD.Connections, zBox.FocusLost:Connect(function()
        local e, eName = HUD.LastTouchedElement, HUD.LastTouchedName
        if not e or not e.Parent or not eName then return end
        local v = tonumber(zBox.Text)
        if v then
            local prev = captureHUDState(eName, e)
            e.ZIndex = v
            if prev and prev.z ~= e.ZIndex then
                pushUndo(prev)
            end
            saveHUDProp(eName, "ZIndex", v)
        end
    end))

    table.insert(HUD.Connections, bgBox.FocusLost:Connect(function()
        local e, eName = HUD.LastTouchedElement, HUD.LastTouchedName
        if not e or not e.Parent or not eName then return end
        local v = tonumber(bgBox.Text)
        if v then
            local prev = captureHUDState(eName, e)
            e.BackgroundTransparency = math.clamp(v, 0, 1)
            if prev and prev.bgTrans ~= e.BackgroundTransparency then
                pushUndo(prev)
            end
            saveHUDProp(eName, "BgTrans", e.BackgroundTransparency)
        end
    end))

    table.insert(HUD.Connections, imgBox.FocusLost:Connect(function()
        local e, eName = HUD.LastTouchedElement, HUD.LastTouchedName
        if not e or not e.Parent or not eName then return end
        local v = tonumber(imgBox.Text)
        if v and (e:IsA("ImageLabel") or e:IsA("ImageButton")) then
            local prev = captureHUDState(eName, e)
            e.ImageTransparency = math.clamp(v, 0, 1)
            if prev and prev.imgTrans ~= e.ImageTransparency then
                pushUndo(prev)
            end
            saveHUDProp(eName, "ImgTrans", e.ImageTransparency)
        end
    end))
    
    table.insert(HUD.Connections, bgcBox.FocusLost:Connect(function()
        local e, eName = HUD.LastTouchedElement, HUD.LastTouchedName
        if not e or not e.Parent or not eName then return end
        local r, g, b = parseRGB(bgcBox.Text)
        if r then
            if isThemeDefaultRGB(r, g, b) then
                if Config.HUDProperties and Config.HUDProperties[eName] then
                    Config.HUDProperties[eName].BgColor = nil
                    if next(Config.HUDProperties[eName]) == nil then
                        Config.HUDProperties[eName] = nil
                    end
                    SaveConfig()
                end
                pcall(function() updateGUIColors() end)
                return
            end
            local prev = captureHUDState(eName, e)
            local c = Color3.fromRGB(r, g, b)
            pcall(function() e.BackgroundColor3 = c end)
            if prev and not sameColor(prev.bgColor, e.BackgroundColor3) then
                pushUndo(prev)
            end
            saveHUDProp(eName, "BgColor", {r, g, b})
        end
    end))
    
    table.insert(HUD.Connections, imgcBox.FocusLost:Connect(function()
        local e, eName = HUD.LastTouchedElement, HUD.LastTouchedName
        if not e or not e.Parent or not eName then return end
        if not (e:IsA("ImageLabel") or e:IsA("ImageButton")) then return end
        local r, g, b = parseRGB(imgcBox.Text)
        if r then
            if isThemeDefaultRGB(r, g, b) then
                if Config.HUDProperties and Config.HUDProperties[eName] then
                    Config.HUDProperties[eName].ImgColor = nil
                    if next(Config.HUDProperties[eName]) == nil then
                        Config.HUDProperties[eName] = nil
                    end
                    SaveConfig()
                end
                pcall(function() updateGUIColors() end)
                return
            end
            local prev = captureHUDState(eName, e)
            local c = Color3.fromRGB(r, g, b)
            pcall(function() e.ImageColor3 = c end)
            if prev and prev.imgColor and not sameColor(prev.imgColor, e.ImageColor3) then
                pushUndo(prev)
            end
            saveHUDProp(eName, "ImgColor", {r, g, b})
        end
    end))

    table.insert(HUD.Connections, radBox.FocusLost:Connect(function(enter)
        if not enter then return end
        local e, eName = HUD.LastTouchedElement, HUD.LastTouchedName
        if not e or not e.Parent or not eName then return end
        local a, b = radBox.Text:match("{%s*([%d%.%-]+)%s*,%s*([%d%.%-]+)%s*}")
        if not a and not b then a, b = radBox.Text:match("([%d%.%-]+)%s*,%s*([%d%.%-]+)") end
        if a and b then
            local va, vb = tonumber(a), tonumber(b)
            if va and vb then
                local cR = e:FindFirstChildWhichIsA("UICorner")
                if cR then
                    local prev = captureHUDState(eName, e)
                    if vb ~= 0 and va == 0 then
                        local minDim = math.min(e.AbsoluteSize.X, e.AbsoluteSize.Y)
                        if minDim > 0 then
                            va = vb / minDim
                            vb = 0
                        end
                    end
                    cR.CornerRadius = UDim.new(va, vb)
                    if prev and prev.radius and not sameUDim(prev.radius, cR.CornerRadius) then
                        pushUndo(prev)
                    end
                    saveHUDProp(eName, "CornerRadius", {va, vb})
                end
            end
        end
    end))

    table.insert(HUD.Connections, txtBox.FocusLost:Connect(function(enter)
        if not enter then return end
        local e, eName = HUD.LastTouchedElement, HUD.LastTouchedName
        if not e or not e.Parent or not eName then return end
        if e:IsA("TextLabel") or e:IsA("TextBox") then
            local prev = captureHUDState(eName, e)
            e.Text = txtBox.Text
            if prev and prev.text ~= e.Text then
                pushUndo(prev)
            end
            saveHUDProp(eName, "Text", txtBox.Text)
        end
    end))

    table.insert(HUD.Connections, phBox.FocusLost:Connect(function(enter)
        if not enter then return end
        local e, eName = HUD.LastTouchedElement, HUD.LastTouchedName
        if not e or not e.Parent or not eName then return end
        if e:IsA("TextBox") then
            local prev = captureHUDState(eName, e)
            e.PlaceholderText = phBox.Text
            if prev and prev.placeholder ~= e.PlaceholderText then
                pushUndo(prev)
            end
            saveHUDProp(eName, "PlaceholderText", phBox.Text)
        end
    end))

    table.insert(HUD.Connections, ttrBox.FocusLost:Connect(function(enter)
        if not enter then return end
        local e, eName = HUD.LastTouchedElement, HUD.LastTouchedName
        if not e or not e.Parent or not eName then return end
        local v = tonumber(ttrBox.Text)
        if v and (e:IsA("TextLabel") or e:IsA("TextBox")) then
            local prev = captureHUDState(eName, e)
            e.TextTransparency = math.clamp(v, 0, 1)
            if prev and prev.textTrans ~= e.TextTransparency then
                pushUndo(prev)
            end
            saveHUDProp(eName, "TextTransparency", e.TextTransparency)
        end
    end))

    table.insert(HUD.Connections, txtcBox.FocusLost:Connect(function()
        local e, eName = HUD.LastTouchedElement, HUD.LastTouchedName
        if not e or not e.Parent or not eName then return end
        if not (e:IsA("TextLabel") or e:IsA("TextBox")) then return end
        local r, g, b = parseRGB(txtcBox.Text)
        if r then
            if isThemeDefaultRGB(r, g, b) then
                if Config.HUDProperties and Config.HUDProperties[eName] then
                    Config.HUDProperties[eName].TxtColor = nil
                    if next(Config.HUDProperties[eName]) == nil then
                        Config.HUDProperties[eName] = nil
                    end
                    SaveConfig()
                end
                pcall(function() updateGUIColors() end)
                return
            end
            local prev = captureHUDState(eName, e)
            local c = Color3.fromRGB(r, g, b)
            pcall(function() e.TextColor3 = c end)
            if prev and prev.textColor and not sameColor(prev.textColor, e.TextColor3) then
                pushUndo(prev)
            end
            saveHUDProp(eName, "TxtColor", {r, g, b})
        end
    end))




    if UI.Search then UI.Search.TextEditable = false; UI.Search.Active = false; pcall(function() UI.Search:ReleaseFocus() end) end
    if UI.SpeedBox then UI.SpeedBox.TextEditable = false; UI.SpeedBox.Active = false; pcall(function() UI.SpeedBox:ReleaseFocus() end) end
    if UI._2Routenumber then UI._2Routenumber.TextEditable = false; UI._2Routenumber.Active = false; pcall(function() UI._2Routenumber:ReleaseFocus() end) end

    local allMovable = getMovableElements()
    local snapGuideH = Instance.new("Frame")
    snapGuideH.Name = "SnapGuide"
    snapGuideH.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    snapGuideH.BorderSizePixel = 0
    snapGuideH.Size = UDim2.new(1, 0, 0, 1)
    snapGuideH.ZIndex = 6002
    snapGuideH.Visible = false
    snapGuideH.Parent = overlay

    local snapGuideV = Instance.new("Frame")
    snapGuideV.Name = "SnapGuide"
    snapGuideV.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    snapGuideV.BorderSizePixel = 0
    snapGuideV.Size = UDim2.new(0, 1, 1, 0)
    snapGuideV.ZIndex = 6002
    snapGuideV.Visible = false
    snapGuideV.Parent = overlay

    for name, element in pairs(allMovable) do
        setupElementDragging(name, element, getMovableElements(), snapGuideV, snapGuideH)
    end

    table.insert(HUD.Connections, addBtn.MouseButton1Click:Connect(function()
        local nameIndex = 1
        while UI.CustomFrames and UI.CustomFrames["CustomFrame_"..nameIndex] do
            nameIndex = nameIndex + 1
        end
        local newName = "CustomFrame_"..nameIndex
        
        local _, emotesWheel = checkEmotesMenuExists()
        local cf = Instance.new("Frame")
        cf.Name = newName
        cf.Parent = emotesWheel
        cf.BackgroundTransparency = 0.4
        cf.ZIndex = 3
        cf.BorderSizePixel = 0
        cf.Active = true
        cf.Size = UDim2.new(0.3, 0, 0.3, 0)
        cf.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = cf

        if not UI.CustomFrames then UI.CustomFrames = {} end
        UI.CustomFrames[newName] = cf

        HUD.DefaultSizes[newName] = UDim2.new(0.3, 0, 0.3, 0)
        HUD.DefaultPositions[newName] = UDim2.new(0.5, 0, 0.5, 0)

        Config.HUDPositions[newName] = {0.5, 0, 0.5, 0}
        if not Config.HUDSizes then Config.HUDSizes = {} end
        Config.HUDSizes[newName] = {0.3, 0, 0.3, 0}
        if not Config.CustomFrames then Config.CustomFrames = {} end
        Config.CustomFrames[newName] = {ZIndex = 3}

        pcall(function() updateGUIColors() end)

        setupElementDragging(newName, cf, getMovableElements(), snapGuideV, snapGuideH)
        selectHUDElement(newName, cf)
        
        getgenv().Notify({ Title = "7yd7 | HUD Editor", Content = "➕ Custom Frame added!", Duration = 2 })
    end))

    getgenv().Notify({ Title = "7yd7 | HUD Editor", Content = "✏️ Drag elements to reposition", Duration = 5 })
end

State.RefreshUI = function()
    State.totalPages = calculateTotalPages()
    updatePageDisplay()
    if State.currentMode == "animation" then
        updateAnimations()
    else
        updateEmotes()
    end
end

State.RefreshSettingsUI = function()
    if TogglesUI then
        for key, toggle in pairs(TogglesUI) do
            if Config[key] ~= nil and toggle.SetState then
                toggle.SetState(Config[key])
            end
        end
    end
end

function checkAndRecreateGUI()
    local exists, emotesWheel = checkEmotesMenuExists()
    if not exists then
        State.isGUICreated = false
        return
    end

    if not emotesWheel:FindFirstChild("Under") or not emotesWheel:FindFirstChild("Top") or
        not emotesWheel:FindFirstChild("EmoteWalkButton") or not emotesWheel:FindFirstChild("Favorite") or
        not emotesWheel:FindFirstChild("SpeedEmote") or not emotesWheel:FindFirstChild("SpeedBox") or
        not emotesWheel:FindFirstChild("Changepage") or not emotesWheel:FindFirstChild("Reload") then
        State.isGUICreated = false
        if createGUIElements() then
            updatePageDisplay()
            updateEmotes()
            loadSpeedEmoteConfig()
        end
    end
end

if player.Character then
    onCharacterAdded(player.Character)
end

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    onCharacterAdded(char)
    
    task.spawn(function()
        local attempts = 0
        while attempts < 20 do
            if checkEmotesMenuExists() then
                task.wait(0.2)
                if createGUIElements() then
                    updatePageDisplay()
                    updateEmotes()
                    updateGUIColors()
                    loadSpeedEmoteConfig()
                end
                break
            end
            attempts = attempts + 1
            task.wait(0.1)
        end
    end)
end)


RunService.Heartbeat:Connect(function()
    if not State.isGUICreated then
        checkAndRecreateGUI()
    else
        updateGUIColors()
        enforceImages()
    end
end)

RunService.Stepped:Connect(function()
    if humanoid and State.currentEmoteTrack and typeof(State.currentEmoteTrack) == "Instance" and State.currentEmoteTrack:IsA("AnimationTrack") and State.currentEmoteTrack.IsPlaying then
        if humanoid.MoveDirection.Magnitude > 0 then
            if State.toolEquipped or (State.speedEmoteEnabled and not State.emotesWalkEnabled) then
                State.currentEmoteTrack:Stop()
                State.currentEmoteTrack = nil
            end
        end
    end
end)

task.spawn(function()
    loadFavoritesAnimations()
    fetchAllEmotes()
    fetchAllAnimations()
    loadSpeedEmoteConfig()
end)

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
task.spawn(function()
    while true do
        local robloxGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")
        local emotesMenu = robloxGui and robloxGui:FindFirstChild("EmotesMenu")

        if not emotesMenu then
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, true)

        else
            local exists = emotesMenu:FindFirstChild("Children") and emotesMenu.Children:FindFirstChild("Main") and
                               emotesMenu.Children.Main:FindFirstChild("EmotesWheel")

            if exists then
                local emotesWheel = emotesMenu.Children.Main.EmotesWheel
                if not emotesWheel:FindFirstChild("Under") or not emotesWheel:FindFirstChild("Top") then
                    if createGUIElements then
                        createGUIElements()
                        loadSpeedEmoteConfig()
                    end
                    updateGUIColors()
                    updatePageDisplay()
                end
            end
        end

        task.wait(0.3)
    end
end)

if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    SafeLoad("https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/OpenEmote.lua", "Open Emote")
    getgenv().Notify({
        Title = '7yd7 | Emote Mobile',
        Content = '📱 Added emote open button for ease of use',
        Duration = 10
    })
end

if UserInputService.KeyboardEnabled then
    getgenv().Notify({
        Title = '7yd7 | Emote PC',
        Content = '💻 Open menu press button "."',
        Duration = 10
    })
end
