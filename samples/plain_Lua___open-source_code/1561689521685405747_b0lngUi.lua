local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local THEME = {
    bg          = Color3.fromRGB(17, 17, 19),
    surface     = Color3.fromRGB(24, 24, 28),
    surfaceAlt  = Color3.fromRGB(34, 34, 40),
    border      = Color3.fromRGB(46, 46, 54),
    text        = Color3.fromRGB(240, 240, 245),
    muted       = Color3.fromRGB(160, 162, 170),
    faint       = Color3.fromRGB(122, 124, 132),
    radius      = { xsm = 4, sm = 6, md = 8, lg = 10, xl = 16 },
    fontTitle   = Enum.Font.GothamBold,
    fontBody    = Enum.Font.Gotham,
    motion      = { fast = 0.12, normal = 0.2, slow = 0.35 },
}
local function AddCorner(gui, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = gui
    return c
end
local function AddStroke(gui, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or THEME.border
    s.Thickness = thickness or 1
    if transparency ~= nil then s.Transparency = transparency end
    s.Parent = gui
    return s
end

local BOLONG_ROOT = "BolongHub"
if not isfolder(BOLONG_ROOT) then
    makefolder(BOLONG_ROOT)
end

local placeId = game.PlaceId

local function SanitizeConfigName(name)
    name = tostring(name or "")
    name = name:gsub("[^%w_ ]", "")
    name = name:gsub("%s+", "_")
    return name
end

local function EnsureFolderForFile(path)
    local parts = {}
    for part in string.gmatch(path, "[^/\\]+") do
        table.insert(parts, part)
    end
    table.remove(parts)
    local current = ""
    for _, part in ipairs(parts) do
        current = (current == "" and part) or (current .. "/" .. part)
        if not isfolder(current) then
            makefolder(current)
        end
    end
end

local function ReadMetaFile(folder)
    local metaPath = BOLONG_ROOT .. "/" .. folder .. "/_meta.json"
    if isfile and isfile(metaPath) then
        local ok, raw = pcall(readfile, metaPath)
        if ok then
            local ok2, meta = pcall(function()
                return HttpService:JSONDecode(raw)
            end)
            if ok2 and type(meta) == "table" then
                return meta
            end
        end
    end
    return nil
end

local function WriteMetaFile(folder, data)
    if not writefile then return end
    EnsureFolderForFile(BOLONG_ROOT .. "/" .. folder .. "/_meta.json")
    local ok, encoded = pcall(function() return HttpService:JSONEncode(data) end)
    if ok then
        pcall(writefile, BOLONG_ROOT .. "/" .. folder .. "/_meta.json", encoded)
    end
end

local function FindGameFolder()
    if not listfolders then return nil end
    for attempt = 1, 5 do
        local ok, dirs = pcall(listfolders, BOLONG_ROOT)
        if ok and type(dirs) == "table" then
            for _, folder in ipairs(dirs) do
                local meta = ReadMetaFile(folder)
                if meta and tonumber(meta.PlaceId) == tonumber(placeId) then
                    return tostring(folder)
                end
            end
        end
        if attempt < 5 then task.wait(1) end
    end
    return nil
end

local gameName = FindGameFolder()
if not gameName then
    local function FetchGameName()
        local success, productInfo = pcall(function()
            return MarketplaceService:GetProductInfo(placeId)
        end)
        if success and productInfo and productInfo.Name then
            return tostring(productInfo.Name)
        end
        return nil
    end
    local fetched = nil
    for attempt = 1, 5 do
        fetched = FetchGameName()
        if fetched then break end
        if attempt < 5 then task.wait(2 + attempt) end
    end
    if fetched then
        local nameFolder = SanitizeConfigName(fetched)
        if nameFolder ~= "" then
            gameName = nameFolder
            WriteMetaFile(nameFolder, {
                PlaceId = placeId,
                Name = fetched,
                SavedAt = os.time(),
            })
        end
    end
end
if not gameName then gameName = "Unknown_Game" end
gameName = SanitizeConfigName(gameName)
if gameName == "" then gameName = "Unknown_Game" end

GameConfigFolder = BOLONG_ROOT .. "/" .. gameName
ConfigFile = GameConfigFolder .. "/_base.json"

ConfigData       = {}
Elements         = {}
CURRENT_VERSION  = nil
ActiveConfigName = nil
ActiveConfigPath = nil
ActiveConfigMode = nil
AutoSaveEnabled = false
ApplyingConfig = false
SaveQueued = false

local InternalConfigKeys = {
    ["Input_Config Name"] = true,
    ["Dropdown_Saved Configs"] = true,
    ["Toggle_Auto Load"] = true,
}

local function CopyConfigValue(value, seen)
    if type(value) ~= "table" then return value end
    seen = seen or {}
    if seen[value] then return seen[value] end

    local copy = {}
    seen[value] = copy
    for k, v in pairs(value) do
        copy[CopyConfigValue(k, seen)] = CopyConfigValue(v, seen)
    end
    return copy
end

function GetConfigSnapshot()
    local snapshot = {}

    for key, value in pairs(ConfigData or {}) do
        if key ~= "_version" and not InternalConfigKeys[key] then
            snapshot[key] = CopyConfigValue(value)
        end
    end

    snapshot._version = CURRENT_VERSION
    return snapshot
end

function SetActiveConfig(name, path, autoSave, mode)
    ActiveConfigName = name
    ActiveConfigPath = path
    if mode ~= nil then
        ActiveConfigMode = mode
    elseif name == nil then
        ActiveConfigMode = nil
    end
    if autoSave ~= nil then
        AutoSaveEnabled = autoSave
    end
end

local DEFAULT_CONFIG_NAME = "Default"
local DEFAULT_CONFIG_FLAG = "DefaultConfigSaved"

local function EnsureConfigFolder()
    if not isfolder(BOLONG_ROOT) then makefolder(BOLONG_ROOT) end
    if not isfolder(GameConfigFolder) then makefolder(GameConfigFolder) end
end

local function EnsureDefaultConfig()
    if not (writefile and CURRENT_VERSION) then return end
    local meta = ReadMetaFile(gameName) or {}
    if meta[DEFAULT_CONFIG_FLAG] then return end

    local snapshot = GetConfigSnapshot()
    local ok, encoded = pcall(function() return HttpService:JSONEncode(snapshot) end)
    if not ok then
        warn("[BolongUi] Gagal membuat default config:", encoded)
        return
    end

    EnsureConfigFolder()
    local path = GameConfigFolder .. "/" .. DEFAULT_CONFIG_NAME .. ".json"
    pcall(writefile, path, encoded)

    meta[DEFAULT_CONFIG_FLAG] = true
    WriteMetaFile(gameName, meta)
end

local function TryReadConfig(path, retries)
    if not (readfile and isfile) then return nil end
    retries = retries or 3
    for attempt = 1, retries do
        local okFile, raw = pcall(function()
            if isfile(path) then return readfile(path) end
            return nil
        end)
        if okFile and type(raw) == "string" and raw ~= "" then
            local okDec, dec = pcall(function()
                return HttpService:JSONDecode(raw)
            end)
            if okDec and type(dec) == "table" then
                return dec
            end
        end
        if attempt < retries then task.wait(0.25 * attempt) end
    end
    return nil
end

local function SafeWriteConfig(path, encoded)
    if not writefile then return false end
    EnsureFolderForFile(path)
    for attempt = 1, 3 do
        local ok = pcall(writefile, path, encoded)
        if ok then return true end
        if attempt < 3 then task.wait(0.2 * attempt) end
    end
    return false
end

local function IsEmptySnapshot(snapshot)
    if type(snapshot) ~= "table" then return true end
    local count = 0
    for key in pairs(snapshot) do
        if key ~= "_version" then count = count + 1 end
    end
    return count == 0
end

local AccountAutoLoadEnabledPending = false
local ActiveAccountIdOverride = nil

local function GetCurrentAccountId()
    if ActiveAccountIdOverride then return tostring(ActiveAccountIdOverride) end
    local ok, id = pcall(function()
        local lp = game:GetService("Players").LocalPlayer
        return lp and lp.UserId or 0
    end)
    if not ok then return "0" end
    return tostring(id or 0)
end

local function GetAccountBaseFile()
    if AccountAutoLoadEnabledPending then
        return GameConfigFolder .. "/_base." .. GetCurrentAccountId() .. ".json"
    end
    return ConfigFile
end

function SaveConfig(force)
    if not writefile or not CURRENT_VERSION then return false end
    if ApplyingConfig and not force then return false end
    if not force and not AutoSaveEnabled then return false end

    local target = ActiveConfigPath or GetAccountBaseFile()
    if not target or target == "" then return false end

    local snapshot = GetConfigSnapshot()
    local ok, encoded = pcall(function() return HttpService:JSONEncode(snapshot) end)
    if not ok then
        warn("SaveConfig failed to encode config:", encoded)
        return false
    end

    if IsEmptySnapshot(snapshot) and TryReadConfig(target, 1) ~= nil then
        warn("[BolongUi] Skip save: snapshot kosong, mencegah timpa '" .. tostring(ActiveConfigName or target) .. "'")
        return false
    end

    ConfigData = snapshot
    return SafeWriteConfig(target, encoded)
end

function QueueSaveConfig(force)
    if force then return SaveConfig(true) end
    if ApplyingConfig or not AutoSaveEnabled then return false end
    if SaveQueued then return true end

    SaveQueued = true
    SaveConfig(false)
    task.delay(0.35, function()
        SaveQueued = false
        SaveConfig(false)
    end)
    return true
end

local AUTOSAVE_STATE_FILE = "_autosave.json"

local function ReadAutoSaveState()
    local data = TryReadConfig(GameConfigFolder .. "/" .. AUTOSAVE_STATE_FILE, 2)
    if data and type(data.Enabled) == "boolean" then
        return data.Enabled == true
    end
    return nil
end

local function WriteAutoSaveState(value)
    if not writefile then return false end
    EnsureConfigFolder()
    local ok, encoded = pcall(function() return HttpService:JSONEncode({ Enabled = value == true }) end)
    if not ok then return false end
    return SafeWriteConfig(GameConfigFolder .. "/" .. AUTOSAVE_STATE_FILE, encoded)
end

local ACCOUNT_AUTOLOAD_FILE = "_account_autoload.json"

local function GetAccountAutoLoadInfo()
    local info = { Enabled = false, Accounts = {} }
    if not isfolder(GameConfigFolder) then return info end
    local data = TryReadConfig(GameConfigFolder .. "/" .. ACCOUNT_AUTOLOAD_FILE, 3)
    if data then
        info.Enabled = data.Enabled == true
        if type(data.Accounts) == "table" then
            for id, name in pairs(data.Accounts) do
                info.Accounts[tostring(id)] = tostring(name or "")
            end
        end
    end
    return info
end

local function WriteAccountAutoLoadInfo(info)
    if not writefile then return false end
    EnsureConfigFolder()
    local clean = {
        Enabled = info.Enabled == true,
        Accounts = {},
    }
    if type(info.Accounts) == "table" then
        for id, name in pairs(info.Accounts) do
            if tostring(name or "") ~= "" then
                clean.Accounts[tostring(id)] = tostring(name)
            end
        end
    end
    local ok, encoded = pcall(function() return HttpService:JSONEncode(clean) end)
    if not ok then return false end
    return SafeWriteConfig(GameConfigFolder .. "/" .. ACCOUNT_AUTOLOAD_FILE, encoded)
end

function LoadConfigFromFile()
    if not CURRENT_VERSION then return end
    ConfigData = { _version = CURRENT_VERSION }
    SetActiveConfig(nil, nil, nil, nil)

    local savedAutoSave = ReadAutoSaveState()
    if savedAutoSave ~= nil then
        AutoSaveEnabled = savedAutoSave
    end

    local accountInfo = GetAccountAutoLoadInfo()
    AccountAutoLoadEnabledPending = accountInfo.Enabled == true

    local autoName = ""
    if AccountAutoLoadEnabledPending then
        local bound = tostring(accountInfo.Accounts[GetCurrentAccountId()] or "")
        if bound ~= "" then
            autoName = bound
        end
    else
        local autoData = TryReadConfig(GameConfigFolder .. "/_autoload.json", 3)
        if autoData then
            autoName = tostring(autoData.Name or "")
        end
    end

    if autoName ~= "" then
        local result = TryReadConfig(GameConfigFolder .. "/" .. autoName .. ".json", 3)
        if result then
            ConfigData = result
            ConfigData._version = CURRENT_VERSION
            SetActiveConfig(autoName, GameConfigFolder .. "/" .. autoName .. ".json", nil, "autoload")
            return
        end
        task.spawn(function()
            warn("[BolongUi] Config '" .. autoName .. "' gagal dibaca setelah retry, pakai config dasar")
        end)
    end

    local baseData = TryReadConfig(GetAccountBaseFile(), 4)
    if baseData then
        if type(baseData.Data) == "table" then baseData = baseData.Data end
        for key, value in pairs(baseData) do
            if key ~= "_version" and not InternalConfigKeys[key] then
                ConfigData[key] = value
            end
        end
        ConfigData._version = CURRENT_VERSION
    end
end

function LoadConfigElements()
    ApplyingConfig = true
    for key, element in pairs(Elements) do
        if ConfigData[key] ~= nil and element.Set then
            local ok, err = pcall(function()
                element:Set(ConfigData[key], true)
            end)
            if not ok then
                warn("[BolongUi] Gagal menerapkan config untuk elemen '" .. tostring(key) .. "': " .. tostring(err))
            end
        end
    end
    ApplyingConfig = false
end

local lucide_source_url = "https://github.com/latte-soft/lucide-roblox/releases/latest/download/lucide-roblox.luau"

local Lucide
do
    local ok, result = pcall(function()
        return loadstring(game:HttpGet(lucide_source_url))()
    end)
    if ok and result then
        Lucide = result
    else
        warn("[BolongUi] Gagal memuat library resmi Lucide Icons dari " .. lucide_source_url .. " -- " .. tostring(result))
        Lucide = nil
    end
end

local LucideAssetCache = {}

local function GetLucideAsset(iconName, size)
    if not Lucide then return nil end

    local cacheKey = iconName .. ":" .. tostring(size or 256)
    local cached = LucideAssetCache[cacheKey]
    if cached ~= nil then
        if cached == false then return nil end
        return cached
    end

    local ok, asset = pcall(function()
        return Lucide.GetAsset(iconName, size)
    end)

    if ok and asset then
        LucideAssetCache[cacheKey] = asset
        return asset
    end

    LucideAssetCache[cacheKey] = false
    return nil
end

local function ApplyIcon(imageLabel, name, size)
    if not imageLabel then return end

    if name == nil or name == "" then
        imageLabel.Image = ""
        imageLabel.ImageRectOffset = Vector2.new(0, 0)
        imageLabel.ImageRectSize = Vector2.new(0, 0)
        return
    end

    if type(name) ~= "string" then
        imageLabel.Image = tostring(name)
        imageLabel.ImageRectOffset = Vector2.new(0, 0)
        imageLabel.ImageRectSize = Vector2.new(0, 0)
        return
    end

    if name:match("^rbxassetid://") or name:match("^rbxthumb://") or name:match("^https?://") or name:match("^%d+$") then
        local finalImage = name
        if name:match("^%d+$") then
            finalImage = "rbxassetid://" .. name
        end
        imageLabel.Image = finalImage
        imageLabel.ImageRectOffset = Vector2.new(0, 0)
        imageLabel.ImageRectSize = Vector2.new(0, 0)
        return
    end

    local asset = GetLucideAsset(name, size)
    if asset then
        imageLabel.Image = asset.Url
        imageLabel.ImageRectOffset = asset.ImageRectOffset
        imageLabel.ImageRectSize = asset.ImageRectSize
    else
        warn("[BolongUi] Ikon Lucide tidak ditemukan atau library gagal dimuat: \"" .. name .. "\"")
        imageLabel.Image = ""
        imageLabel.ImageRectOffset = Vector2.new(0, 0)
        imageLabel.ImageRectSize = Vector2.new(0, 0)
    end
end

local discord_logo_asset_id = "rbxassetid://95644421757953"

local WebImageCacheFolder = "BolongHub/ImageCache"
if not isfolder(WebImageCacheFolder) then
    makefolder(WebImageCacheFolder)
end

local MAX_CACHE_FILES = 5
local ManifestPath = WebImageCacheFolder .. "/_manifest.json"
local WebImageAssetCache = {}
local PendingImageEvents = {}
local CacheManifest = {}
local ManifestSaveQueued = false

local function LoadImageCacheManifest()
    if not (isfile and readfile and isfile(ManifestPath)) then return end
    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(readfile(ManifestPath))
    end)
    if ok and type(decoded) == "table" then
        CacheManifest = decoded
    end
end
LoadImageCacheManifest()

local function SaveImageCacheManifest()
    if ManifestSaveQueued or not writefile then return end
    ManifestSaveQueued = true
    task.delay(0.5, function()
        ManifestSaveQueued = false
        local ok, encoded = pcall(function()
            return HttpService:JSONEncode(CacheManifest)
        end)
        if ok then
            pcall(writefile, ManifestPath, encoded)
        end
    end)
end

local function HashUrl(str)
    local hash = 5381
    for i = 1, #str do
        hash = (hash * 33 + string.byte(str, i)) % 4294967296
    end
    return string.format("%08x", hash)
end

local function TrimImageCache()
    if not delfile then return end

    local count = 0
    for _ in pairs(CacheManifest) do count = count + 1 end
    if count <= MAX_CACHE_FILES then return end

    local entries = {}
    for hash, info in pairs(CacheManifest) do
        entries[#entries + 1] = { hash = hash, info = info }
    end
    table.sort(entries, function(a, b)
        return (a.info.lastUsed or 0) < (b.info.lastUsed or 0)
    end)

    local toRemove = count - MAX_CACHE_FILES
    for i = 1, toRemove do
        local entry = entries[i]
        if entry and entry.info and entry.info.file then
            local path = WebImageCacheFolder .. "/" .. entry.info.file
            if isfile and isfile(path) then
                pcall(delfile, path)
            end
            CacheManifest[entry.hash] = nil
            if entry.info.url then
                WebImageAssetCache[entry.info.url] = nil
            end
        end
    end

    SaveImageCacheManifest()
end

local function GetWebImageAsset(url)
    if not url or url == "" then return "" end
    if WebImageAssetCache[url] ~= nil then return WebImageAssetCache[url] end

    local existingEvent = PendingImageEvents[url]
    if existingEvent then
        return existingEvent.Event:Wait()
    end

    local getAsset = getcustomasset or getsynasset
    if not (writefile and getAsset and game.HttpGet) then
        warn("[BolongUi] Executor tidak mendukung getcustomasset/getsynasset, gambar dari url web mungkin tidak tampil.")
        return ""
    end

    local event = Instance.new("BindableEvent")
    PendingImageEvents[url] = event

    local ext = ".png"
    if url:match("%.jpe?g") then
        ext = ".jpg"
    elseif url:match("%.gif") then
        ext = ".gif"
    elseif url:match("%.webp") then
        ext = ".webp"
    end

    local hash = HashUrl(url)
    local filename = hash .. ext
    local path = WebImageCacheFolder .. "/" .. filename

    local result = ""

    if isfile and isfile(path) then
        local ok, assetId = pcall(getAsset, path)
        if ok and assetId and assetId ~= "" then
            result = assetId
        end
    end

    if result == "" then
        local ok, res = pcall(function()
            local data = game:HttpGet(url)
            if not data or data == "" then return nil end
            writefile(path, data)
            return getAsset(path)
        end)
        if ok and res and res ~= "" then
            result = res
        else
            warn("[BolongUi] Gagal memuat gambar dari url: " .. tostring(url) .. " -- " .. tostring(res))
        end
    end

    if result ~= "" then
        CacheManifest[hash] = { url = url, file = filename, lastUsed = os.time() }
        SaveImageCacheManifest()
        TrimImageCache()
    end

    WebImageAssetCache[url] = result
    PendingImageEvents[url] = nil
    event:Fire(result)
    event:Destroy()

    return result
end

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")



local ActiveDragInputs = {}

local function TrackDragInput(beganInput, changedFn, endedFn)
    ActiveDragInputs[beganInput] = { changed = changedFn, ended = endedFn }
end

local function StopDragInput(beganInput)
    ActiveDragInputs[beganInput] = nil
end

UserInputService.InputChanged:Connect(function(input)
    for activeInput, handlers in pairs(ActiveDragInputs) do
        if activeInput == input and handlers and handlers.changed then
            handlers.changed(input)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    local handlers = ActiveDragInputs[input]
    if handlers then
        ActiveDragInputs[input] = nil
        if handlers.ended then handlers.ended(input) end
    end
end)

local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")
local viewport = workspace.CurrentCamera.ViewportSize

local function isMobileDevice()
    return UserInputService.TouchEnabled
        and not UserInputService.KeyboardEnabled
        and not UserInputService.MouseEnabled
end

local isMobile = isMobileDevice()

local function safeSize(pxWidth, pxHeight)
    local scaleX = pxWidth / viewport.X
    local scaleY = pxHeight / viewport.Y

    if isMobile then
        if scaleX > 0.5 then scaleX = 0.5 end
        if scaleY > 0.3 then scaleY = 0.3 end
    end

    return UDim2.new(scaleX, 0, scaleY, 0)
end

local function MakeDraggable(topbarobject, object)
    local function CustomPos(topbarobject, object)
        local Dragging, DragInput, DragStart, StartPosition

        local function UpdatePos(input)
            local Delta = input.Position - DragStart
            local pos = UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )
            object.Position = pos
        end

        topbarobject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = input.Position
                StartPosition = object.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                    end
                end)
            end
        end)

        topbarobject.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                DragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == DragInput and Dragging then
                UpdatePos(input)
            end
        end)
    end

    local function CustomSize(object)
        local Dragging, DragInput, DragStart, StartSize

        local minSizeX, minSizeY
        local defSizeX, defSizeY

        if isMobile then
            minSizeX, minSizeY = 100, 100
            defSizeX, defSizeY = 490, 315
        else
            minSizeX, minSizeY = 100, 100
            defSizeX, defSizeY = 640, 400
        end

        object.Size = UDim2.new(0, defSizeX, 0, defSizeY)

        local changesizeobject = Instance.new("Frame")
        changesizeobject.AnchorPoint = Vector2.new(1, 1)
        changesizeobject.BackgroundTransparency = 1
        changesizeobject.Size = UDim2.new(0, 40, 0, 40)
        changesizeobject.Position = UDim2.new(1, 20, 1, 20)
        changesizeobject.Name = "changesizeobject"
        changesizeobject.Parent = object

        local function UpdateSize(input)
            local Delta = input.Position - DragStart
            local newWidth = StartSize.X.Offset + Delta.X
            local newHeight = StartSize.Y.Offset + Delta.Y

            newWidth = math.max(newWidth, minSizeX)
            newHeight = math.max(newHeight, minSizeY)

            object.Size = UDim2.new(0, newWidth, 0, newHeight)
        end

        changesizeobject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = input.Position
                StartSize = object.Size
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                    end
                end)
            end
        end)

        changesizeobject.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                DragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == DragInput and Dragging then
                UpdateSize(input)
            end
        end)
    end

    CustomSize(object)
    CustomPos(topbarobject, object)
end

function CircleClick(Button, X, Y)
    task.spawn(function()
        Button.ClipsDescendants = true
        local Circle = Instance.new("ImageLabel")
        Circle.Image = "rbxassetid://266543268"
        Circle.ImageColor3 = Color3.fromRGB(80, 80, 80)
        Circle.ImageTransparency = 0.9
        Circle.BackgroundTransparency = 1
        Circle.ZIndex = 10
        Circle.Name = "Circle"
        Circle.Parent = Button

        local NewX = X - Circle.AbsolutePosition.X
        local NewY = Y - Circle.AbsolutePosition.Y
        Circle.Position = UDim2.new(0, NewX, 0, NewY)
        local Size = 0
        if Button.AbsoluteSize.X > Button.AbsoluteSize.Y then
            Size = Button.AbsoluteSize.X * 1.5
        elseif Button.AbsoluteSize.X < Button.AbsoluteSize.Y then
            Size = Button.AbsoluteSize.Y * 1.5
        elseif Button.AbsoluteSize.X == Button.AbsoluteSize.Y then
            Size = Button.AbsoluteSize.X * 1.5
        end

        local Time = 0.5
        local SizeTween = TweenService:Create(Circle, TweenInfo.new(Time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { Size = UDim2.new(0, Size, 0, Size), Position = UDim2.new(0.5, -Size / 2, 0.5, -Size / 2) })
        local FadeTween = TweenService:Create(Circle, TweenInfo.new(Time, Enum.EasingStyle.Linear),
            { ImageTransparency = 1 })
        SizeTween:Play()
        FadeTween:Play()
        FadeTween.Completed:Wait()
        Circle:Destroy()
    end)
end

local Chloex = {}
function Chloex:MakeNotify(NotifyConfig)
    NotifyConfig = NotifyConfig or {}
    NotifyConfig.Title = NotifyConfig.Title or "BolongHub"
    NotifyConfig.Description = NotifyConfig.Description or "Notification"
    NotifyConfig.Content = NotifyConfig.Content or "Content"
    NotifyConfig.Color = NotifyConfig.Color or THEME.text
    NotifyConfig.Time = NotifyConfig.Time or 0.5
    NotifyConfig.Delay = NotifyConfig.Delay or 5

    local NotifyFunction = {}
    task.spawn(function()
        if not CoreGui:FindFirstChild("NotifyGui") then
            local NotifyGui = Instance.new("ScreenGui")
            NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            NotifyGui.IgnoreGuiInset = true
            NotifyGui.DisplayOrder = 999
            NotifyGui.Name = "NotifyGui"
            NotifyGui.Parent = CoreGui
        end
        if not CoreGui.NotifyGui:FindFirstChild("NotifyLayout") then
            local NotifyLayout = Instance.new("Frame")
            NotifyLayout.AnchorPoint = Vector2.new(1, 0)
            NotifyLayout.BackgroundTransparency = 1
            NotifyLayout.BorderSizePixel = 0
            NotifyLayout.Position = UDim2.new(1, -20, 0, 20)
            NotifyLayout.Size = UDim2.new(0, 340, 1, 0)
            NotifyLayout.Name = "NotifyLayout"
            NotifyLayout.Parent = CoreGui.NotifyGui

            local SortLayout = Instance.new("UIListLayout")
            SortLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SortLayout.VerticalAlignment = Enum.VerticalAlignment.Top
            SortLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
            SortLayout.Padding = UDim.new(0, 10)
            SortLayout.Parent = NotifyLayout
        end

        local measure = Instance.new("TextLabel")
        measure.BackgroundTransparency = 1
        measure.TextWrapped = true
        measure.Size = UDim2.new(0, 266, 0, 14)
        measure.TextSize = 12
        measure.Font = Enum.Font.Gotham
        measure.Parent = CoreGui.NotifyGui.NotifyLayout

        local Description = NotifyConfig.Content or NotifyConfig.Description
        measure.Text = Description
        local contentHeight = math.max(measure.TextBounds.Y + 36, 60)
        measure:Destroy()

        local NotifyFrame = Instance.new("Frame")
        NotifyFrame.Size = UDim2.new(0, 300, 0, contentHeight)
        NotifyFrame.BackgroundColor3 = THEME.surface
        NotifyFrame.BackgroundTransparency = 1
        NotifyFrame.BorderSizePixel = 0
        NotifyFrame.Name = "NotifyFrame"
        NotifyFrame.Parent = CoreGui.NotifyGui.NotifyLayout

        local cardScale = Instance.new("UIScale")
        cardScale.Scale = 0.92
        cardScale.Parent = NotifyFrame

        local NotifyStroke = AddStroke(NotifyFrame, THEME.border, 1, 1)
        AddCorner(NotifyFrame, THEME.radius.md)

        local TopLine = Instance.new("Frame")
        TopLine.BackgroundColor3 = NotifyConfig.Color or THEME.text
        TopLine.BackgroundTransparency = 1
        TopLine.BorderSizePixel = 0
        TopLine.Size = UDim2.new(0, 4, 1, 0)
        TopLine.Parent = NotifyFrame
        AddCorner(TopLine, 4)

        local Title = Instance.new("TextLabel")
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 18, 0, 10)
        Title.Size = UDim2.new(1, -28, 0, 18)
        Title.Font = THEME.fontTitle
        Title.Text = NotifyConfig.Title or "BolongHub"
        Title.TextColor3 = THEME.text
        Title.TextSize = 13
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = NotifyFrame

        local Content = Instance.new("TextLabel")
        Content.BackgroundTransparency = 1
        Content.Position = UDim2.new(0, 18, 0, 32)
        Content.Size = UDim2.new(1, -34, 1, -42)
        Content.Font = THEME.fontBody
        Content.Text = Description
        Content.TextColor3 = THEME.muted
        Content.TextSize = 12
        Content.TextWrapped = true
        Content.TextXAlignment = Enum.TextXAlignment.Left
        Content.TextYAlignment = Enum.TextYAlignment.Top
        Content.Parent = NotifyFrame

        local CloseButton = Instance.new("TextButton")
        CloseButton.BackgroundTransparency = 1
        CloseButton.Position = UDim2.new(1, -24, 0, 6)
        CloseButton.Size = UDim2.new(0, 18, 0, 18)
        CloseButton.Font = THEME.fontBody
        CloseButton.Text = "x"
        CloseButton.TextColor3 = THEME.faint
        CloseButton.TextSize = 14
        CloseButton.ZIndex = 3
        CloseButton.Parent = NotifyFrame
        CloseButton.MouseEnter:Connect(function()
            TweenService:Create(CloseButton, TweenInfo.new(0.1), { TextColor3 = THEME.text }):Play()
        end)
        CloseButton.MouseLeave:Connect(function()
            TweenService:Create(CloseButton, TweenInfo.new(0.1), { TextColor3 = THEME.faint }):Play()
        end)
        CloseButton.MouseButton1Click:Connect(function()
            NotifyFunction:Close()
        end)

        local FadeIn = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(NotifyFrame, FadeIn, { BackgroundTransparency = 0 }):Play()
        TweenService:Create(cardScale, FadeIn, { Scale = 1 }):Play()
        TweenService:Create(NotifyStroke, FadeIn, { Color = THEME.border, Transparency = 0 }):Play()
        TweenService:Create(TopLine, FadeIn, { BackgroundTransparency = 0 }):Play()

        task.delay(NotifyConfig.Delay, function()
            NotifyFunction:Close()
        end)

        function NotifyFunction:Close()
            if not NotifyFrame or not NotifyFrame.Parent then return end
            NotifyStroke:Destroy()
            local FadeOut = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            TweenService:Create(NotifyFrame, FadeOut, { BackgroundTransparency = 1 }):Play()
            TweenService:Create(cardScale, FadeOut, { Scale = 0.95 }):Play()
            TweenService:Create(TopLine, FadeOut, { BackgroundTransparency = 1 }):Play()
            task.delay(0.25, function()
                if NotifyFrame then NotifyFrame:Destroy() end
            end)
        end

        return NotifyFunction
    end)
end





local TargetSelectorId = 0

function Chloex:TargetSelector(TargetConfig)
    TargetConfig = TargetConfig or {}
    TargetConfig.Title = TargetConfig.Title or "SELECT TARGET"
    TargetConfig.Options = TargetConfig.Options or { "KILLER", "SURVIVOR", "ZOMBIE" }
    TargetConfig.Values = TargetConfig.Values or TargetConfig.Options
    TargetConfig.Default = TargetConfig.Default or TargetConfig.Values[1]
    TargetConfig.Accent = TargetConfig.Accent or THEME.text
    TargetConfig.Callback = TargetConfig.Callback or function() end

    local nOptions = #TargetConfig.Options
    if nOptions < 1 then return nil end
    if #TargetConfig.Values < nOptions then
        TargetConfig.Values = TargetConfig.Options
    end

    local selIndex = 1
    for i, v in ipairs(TargetConfig.Values) do
        if v == TargetConfig.Default then selIndex = i end
    end

    local MARGIN = 15
    local TITLE_HEIGHT = 30
    local PADDING_X = 12
    local PADDING_Y = 10
    local GAP = 5
    local CELL_W = isMobile and 64 or 72
    local CELL_H = isMobile and 34 or 32
    local MaxColumns = math.max(1, TargetConfig.MaxColumns or 3)

    local cols = math.min(MaxColumns, nOptions)
    local rows = math.ceil(nOptions / cols)
    local W = cols * CELL_W + (cols - 1) * GAP + PADDING_X * 2
    local H = TITLE_HEIGHT + PADDING_Y * 2 + rows * CELL_H + (rows - 1) * GAP

    local C = {
        bg          = THEME.bg,
        hover       = Color3.fromRGB(35, 35, 40),
        active      = TargetConfig.Accent,
        activeText  = THEME.bg,
        white       = THEME.text,
        stroke      = THEME.border,
        sep         = Color3.fromRGB(35, 35, 40),
        dim         = THEME.muted,
        danger      = Color3.fromRGB(235, 70, 70),
    }
    C.activeHover = Color3.fromRGB(
        math.max(0, C.active.R * 255 - 28),
        math.max(0, C.active.G * 255 - 28),
        math.max(0, C.active.B * 255 - 28)
    )

    local hoverInfo = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

    local Selector = { _value = TargetConfig.Values[selIndex] }

    local Gui = Instance.new("ScreenGui")
    TargetSelectorId = TargetSelectorId + 1
    Gui.Name = "TargetSelector_" .. TargetSelectorId
    Gui.ResetOnSpawn = false
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Gui.DisplayOrder = 99
    Gui.Parent = CoreGui

    local function bindDrag(topbar, frame)
        local dragging = false
        local dragStart, startPos
        topbar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    local Panel = Instance.new("Frame")
    Panel.Name = "Panel"
    Panel.Size = UDim2.new(0, W, 0, H)
    Panel.Position = UDim2.new(1, -(W + MARGIN), 0, MARGIN)
    Panel.BackgroundColor3 = C.bg
    Panel.BorderSizePixel = 0
    Panel.Active = true
    Panel.Visible = false
    Panel.Parent = Gui
    AddCorner(Panel, 8)
    AddStroke(Panel, C.stroke, 1, 0.2)

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, -70, 0, TITLE_HEIGHT)
    TitleBar.BackgroundTransparency = 1
    TitleBar.Parent = Panel
    bindDrag(TitleBar, Panel)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -60, 0, TITLE_HEIGHT)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = TargetConfig.Title
    Title.TextColor3 = C.white
    Title.TextSize = 12
    Title.Font = Enum.Font.GothamMedium
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 4
    Title.Parent = Panel

    local function makeWinBtn(sym, xOff)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 24, 0, TITLE_HEIGHT)
        b.Position = UDim2.new(1, xOff, 0, 0)
        b.BackgroundColor3 = C.bg
        b.BorderSizePixel = 0
        b.Text = sym
        b.TextColor3 = C.dim
        b.TextSize = 14
        b.Font = Enum.Font.GothamBold
        b.AutoButtonColor = false
        b.ZIndex = 4
        b.Parent = Panel
        b.MouseEnter:Connect(function()
            TweenService:Create(b, hoverInfo, { BackgroundColor3 = C.hover, TextColor3 = C.white }):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b, hoverInfo, { BackgroundColor3 = C.bg, TextColor3 = C.dim }):Play()
        end)
        return b
    end

    local MinBtn   = makeWinBtn("−", -48)

    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Size = UDim2.new(0, 16, 0, 16)
    CloseBtn.Position = UDim2.new(1, -20, 0, (TITLE_HEIGHT - 16) / 2)
    CloseBtn.BackgroundColor3 = C.bg
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Image = "rbxassetid://9886659671"
    CloseBtn.ImageColor3 = C.dim
    CloseBtn.ScaleType = Enum.ScaleType.Fit
    CloseBtn.AutoButtonColor = false
    CloseBtn.ZIndex = 4
    CloseBtn.Name = "CloseButton"
    CloseBtn.Parent = Panel

    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, hoverInfo, { BackgroundColor3 = C.danger, ImageColor3 = C.white }):Play()
    end)
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, hoverInfo, { BackgroundColor3 = C.bg, ImageColor3 = C.dim }):Play()
    end)

    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, 0, 0, 1)
    sep.Position = UDim2.new(0, 0, 0, TITLE_HEIGHT)
    sep.BackgroundColor3 = C.sep
    sep.BorderSizePixel = 0
    sep.ZIndex = 3
    sep.Parent = Panel

    local Box = Instance.new("Frame")
    Box.Size = UDim2.new(1, 0, 1, -TITLE_HEIGHT)
    Box.Position = UDim2.new(0, 0, 0, TITLE_HEIGHT)
    Box.BackgroundTransparency = 1
    Box.ZIndex = 3
    Box.Parent = Panel

    local Layout = Instance.new("UIGridLayout")
    Layout.CellSize = UDim2.new(0, CELL_W, 0, CELL_H)
    Layout.CellPadding = UDim2.new(0, GAP, 0, GAP)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.VerticalAlignment = Enum.VerticalAlignment.Center
    Layout.FillDirection = Enum.FillDirection.Horizontal
    Layout.FillDirectionMaxCells = cols
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Box

    local buttons = {}
    local activeBtn = nil

    local function updateBtnVisual(btn)
        local isActive = btn:GetAttribute("IsActive")
        local targetBg = isActive and C.active or C.bg
        local targetText = isActive and C.activeText or C.dim
        TweenService:Create(btn, hoverInfo, { BackgroundColor3 = targetBg, TextColor3 = targetText }):Play()
        local stroke = btn:FindFirstChildOfClass("UIStroke")
        if stroke then
            TweenService:Create(stroke, hoverInfo, { Color = isActive and C.active or C.stroke }):Play()
        end
    end

    local function applySelection(idx, fireCallback)
        local b = buttons[idx]
        if b then
            if activeBtn and activeBtn ~= b then
                activeBtn:SetAttribute("IsActive", false)
                updateBtnVisual(activeBtn)
            end
            b:SetAttribute("IsActive", true)
            activeBtn = b
            updateBtnVisual(b)
        end
        Selector._value = TargetConfig.Values[idx]
        if fireCallback then
            pcall(TargetConfig.Callback, Selector._value)
        end
    end

    for i = 1, nOptions do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, CELL_W, 0, CELL_H)
        b.BackgroundColor3 = C.bg
        b.BorderSizePixel = 0
        b.Text = tostring(TargetConfig.Options[i])
        b.TextColor3 = C.dim
        b.TextSize = 11
        b.TextWrapped = true
        b.Font = Enum.Font.GothamBold
        b.AutoButtonColor = false
        b.LayoutOrder = i
        b.ZIndex = 4
        b.Parent = Box
        AddCorner(b, 6)
        AddStroke(b, C.stroke, 1)

        b.MouseEnter:Connect(function()
            local isActive = b:GetAttribute("IsActive")
            TweenService:Create(b, hoverInfo, {
                BackgroundColor3 = isActive and C.activeHover or C.hover,
                TextColor3 = isActive and C.activeText or C.white,
            }):Play()
        end)
        b.MouseLeave:Connect(function()
            updateBtnVisual(b)
        end)
        b.MouseButton1Click:Connect(function()
            if activeBtn == b then
                b:SetAttribute("IsActive", false)
                activeBtn = nil
                updateBtnVisual(b)
                Selector._value = nil
                pcall(TargetConfig.Callback, nil)
            else
                applySelection(i, true)
            end
        end)
        buttons[i] = b
    end

    applySelection(selIndex, false)

    local minimized = false

    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        Box.Visible = not minimized
        sep.Visible = not minimized
        local targetSize = minimized and UDim2.new(0, W, 0, TITLE_HEIGHT) or UDim2.new(0, W, 0, H)
        TweenService:Create(Panel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = targetSize }):Play()
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        Selector:Hide()
    end)

    function Selector:Set(val)
        local idx = 1
        for i, v in ipairs(TargetConfig.Values) do
            if v == val then idx = i end
        end
        if TargetConfig.Values[idx] == val then
            applySelection(idx, false)
        end
        return self
    end

    function Selector:Get()
        return Selector._value
    end

    function Selector:Toggle()
        if Panel then
            Panel.Visible = not Panel.Visible
        end
        return self
    end

    function Selector:Show()
        if Panel then
            Panel.Visible = true
            if minimized then
                minimized = false
                Box.Visible = true
                sep.Visible = true
                Panel.Size = UDim2.new(0, W, 0, H)
            end
        end
        return self
    end

    function Selector:Hide()
        if Panel then Panel.Visible = false end
        return self
    end

    function Selector:Destroy()
        if Gui then Gui:Destroy() end
        Gui = nil
        return self
    end

    return Selector
end

local TogglePanelId = 0

function Chloex:TogglePanel(ToggleConfig)
    ToggleConfig = ToggleConfig or {}
    ToggleConfig.Title = ToggleConfig.Title or "TOGGLE"
    ToggleConfig.Subtitle = ToggleConfig.Subtitle or ""
    ToggleConfig.Default = ToggleConfig.Default and true or false
    ToggleConfig.Accent = ToggleConfig.Accent or THEME.text
    ToggleConfig.Callback = ToggleConfig.Callback or function() end
    ToggleConfig.OffsetY = ToggleConfig.OffsetY or 0

    local MARGIN = 15
    local TITLE_HEIGHT = 30
    local PADDING_X = 12
    local PADDING_Y = 10
    local ROW_H = 30
    local W = PADDING_X * 2 + 96
    local H = TITLE_HEIGHT + PADDING_Y * 2 + ROW_H

    local C = {
        bg      = THEME.bg,
        hover   = Color3.fromRGB(35, 35, 40),
        white   = THEME.text,
        chipOn  = Color3.fromRGB(240, 240, 245),
        onText  = THEME.bg,
        stroke  = THEME.border,
        sep     = Color3.fromRGB(35, 35, 40),
        dim     = THEME.muted,
        danger  = Color3.fromRGB(235, 70, 70),
    }

    local hoverInfo = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

    local Toggle = { _value = ToggleConfig.Default }

    local Gui = Instance.new("ScreenGui")
    TogglePanelId = TogglePanelId + 1
    Gui.Name = "TogglePanel_" .. TogglePanelId
    Gui.ResetOnSpawn = false
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Gui.DisplayOrder = 99
    Gui.Parent = CoreGui

    local function bindDrag(topbar, frame)
        local dragging = false
        local dragStart, startPos
        topbar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    local Panel = Instance.new("Frame")
    Panel.Name = "Panel"
    Panel.Size = UDim2.new(0, W, 0, H)
    Panel.Position = UDim2.new(1, -(W + MARGIN), 0, MARGIN + ToggleConfig.OffsetY)
    Panel.BackgroundColor3 = C.bg
    Panel.BorderSizePixel = 0
    Panel.Active = true
    Panel.Visible = false
    Panel.Parent = Gui
    AddCorner(Panel, 8)
    AddStroke(Panel, C.stroke, 1, 0.2)

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, -70, 0, TITLE_HEIGHT)
    TitleBar.BackgroundTransparency = 1
    TitleBar.Parent = Panel
    bindDrag(TitleBar, Panel)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -60, 0, TITLE_HEIGHT)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = ToggleConfig.Title
    Title.TextColor3 = C.white
    Title.TextSize = 12
    Title.Font = Enum.Font.GothamMedium
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 4
    Title.Parent = Panel

    local function makeWinBtn(sym, xOff)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 24, 0, TITLE_HEIGHT)
        b.Position = UDim2.new(1, xOff, 0, 0)
        b.BackgroundColor3 = C.bg
        b.BorderSizePixel = 0
        b.Text = sym
        b.TextColor3 = C.dim
        b.TextSize = 14
        b.Font = Enum.Font.GothamBold
        b.AutoButtonColor = false
        b.ZIndex = 4
        b.Parent = Panel
        b.MouseEnter:Connect(function()
            TweenService:Create(b, hoverInfo, { BackgroundColor3 = C.hover, TextColor3 = C.white }):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b, hoverInfo, { BackgroundColor3 = C.bg, TextColor3 = C.dim }):Play()
        end)
        return b
    end

    local MinBtn = makeWinBtn("−", -48)

    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Size = UDim2.new(0, 16, 0, 16)
    CloseBtn.Position = UDim2.new(1, -20, 0, (TITLE_HEIGHT - 16) / 2)
    CloseBtn.BackgroundColor3 = C.bg
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Image = "rbxassetid://9886659671"
    CloseBtn.ImageColor3 = C.dim
    CloseBtn.ScaleType = Enum.ScaleType.Fit
    CloseBtn.AutoButtonColor = false
    CloseBtn.ZIndex = 4
    CloseBtn.Name = "CloseButton"
    CloseBtn.Parent = Panel
    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, hoverInfo, { BackgroundColor3 = C.danger, ImageColor3 = C.white }):Play()
    end)
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, hoverInfo, { BackgroundColor3 = C.bg, ImageColor3 = C.dim }):Play()
    end)

    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, 0, 0, 1)
    sep.Position = UDim2.new(0, 0, 0, TITLE_HEIGHT)
    sep.BackgroundColor3 = C.sep
    sep.BorderSizePixel = 0
    sep.ZIndex = 3
    sep.Parent = Panel

    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 1, -TITLE_HEIGHT)
    Row.Position = UDim2.new(0, 0, 0, TITLE_HEIGHT)
    Row.BackgroundTransparency = 1
    Row.ZIndex = 3
    Row.Parent = Panel

    local Chip = Instance.new("TextButton")
    Chip.Name = "Chip"
    Chip.Size = UDim2.new(1, -PADDING_X * 2, 0, ROW_H)
    Chip.Position = UDim2.new(0, PADDING_X, 0.5, -ROW_H / 2)
    Chip.BackgroundColor3 = C.hover
    Chip.BorderSizePixel = 0
    Chip.Text = (ToggleConfig.Subtitle ~= "" and ToggleConfig.Subtitle) or "Status"
    Chip.TextColor3 = C.dim
    Chip.TextSize = 12
    Chip.Font = Enum.Font.GothamMedium
    Chip.AutoButtonColor = false
    Chip.ZIndex = 4
    Chip.Parent = Row
    AddCorner(Chip, 6)
    AddStroke(Chip, C.stroke, 1)

    local function updateVisual(value)
        if value then
            Chip.TextColor3 = C.onText
            TweenService:Create(Chip, hoverInfo, { BackgroundColor3 = C.chipOn }):Play()
            local s = Chip:FindFirstChildOfClass("UIStroke")
            if s then TweenService:Create(s, hoverInfo, { Color = C.chipOn, Transparency = 1 }):Play() end
        else
            Chip.TextColor3 = C.dim
            TweenService:Create(Chip, hoverInfo, { BackgroundColor3 = C.hover }):Play()
            local s = Chip:FindFirstChildOfClass("UIStroke")
            if s then TweenService:Create(s, hoverInfo, { Color = C.stroke, Transparency = 0 }):Play() end
        end
    end

    local function toggleValue(fireCallback)
        Toggle._value = not Toggle._value
        updateVisual(Toggle._value)
        if fireCallback then pcall(ToggleConfig.Callback, Toggle._value) end
    end

    Chip.MouseButton1Click:Connect(function()
        toggleValue(true)
    end)

    Chip.MouseEnter:Connect(function()
        if Toggle._value then return end
        TweenService:Create(Chip, hoverInfo, { BackgroundColor3 = Color3.fromRGB(46, 46, 54) }):Play()
    end)
    Chip.MouseLeave:Connect(function()
        updateVisual(Toggle._value)
    end)

    local minimized = false
    local function setSize(compact)
        local target = compact and UDim2.new(0, W, 0, TITLE_HEIGHT) or UDim2.new(0, W, 0, H)
        TweenService:Create(Panel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = target }):Play()
    end

    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        Row.Visible = not minimized
        sep.Visible = not minimized
        setSize(minimized)
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        Toggle:Hide()
    end)

    updateVisual(Toggle._value)

    function Toggle:Set(value, fireCallback)
        value = value and true or false
        local changed = Toggle._value ~= value
        Toggle._value = value
        updateVisual(Toggle._value)
        if fireCallback and changed then
            pcall(ToggleConfig.Callback, Toggle._value)
        end
        return self
    end

    function Toggle:Get()
        return Toggle._value
    end

    function Toggle:Toggle()
        if Panel then Panel.Visible = not Panel.Visible end
        return self
    end

    function Toggle:Show()
        if Panel then
            Panel.Visible = true
            if minimized then
                minimized = false
                Row.Visible = true
                sep.Visible = true
                Panel.Size = UDim2.new(0, W, 0, H)
            end
        end
        return self
    end

    function Toggle:Hide()
        if Panel then Panel.Visible = false end
        return self
    end

    function Toggle:Destroy()
        if Gui then Gui:Destroy() end
        Gui = nil
        return self
    end

    return Toggle
end

local function than(msg, delay, color, title, desc)
    return Chloex:MakeNotify({
        Title = title or "BolongHub",
        Description = desc or "Notification",
        Content = msg or "Content",
        Color = color or Color3.fromRGB(235, 235, 235),
        Delay = delay or 4
    })
end












































local function RunKeySystemGate(KeyConfig, AccentColor, ScopeName)
    KeyConfig          = KeyConfig or {}
    KeyConfig.Title    = KeyConfig.Title or "BolongHub"
    KeyConfig.Note     = KeyConfig.Note or "Masukkan key kamu di bawah ini untuk melanjutkan."
    KeyConfig.SaveKey  = (KeyConfig.SaveKey ~= false)
    if not KeyConfig.FileName or KeyConfig.FileName == "" then
        KeyConfig.FileName = GameConfigFolder .. "/key.txt"
    end
    AccentColor        = KeyConfig.Color or AccentColor or Color3.fromRGB(240, 240, 240)

    
    
    
    
    local JunkieActive  = false
    local JunkieLoadErr = nil
    local JunkieReq     = (syn and syn.request) or (fluxus and fluxus.request)
        or (http and http.request) or request or http_request
    local JunkieBase    = "https://api.jnkie.com/api/v1/whitelist"

    if type(KeyConfig.Junkie) == "table" then
        if not JunkieReq then
            JunkieLoadErr = "Executor tidak mendukung HTTP request (request/syn.request tidak ditemukan)."
        else
            JunkieActive = true
        end
    end

    local function JunkieCheckKey(key)
        local resp = JunkieReq({
            Method  = "POST",
            Url     = JunkieBase .. "/verifyOpen",
            Headers = { ["Content-Type"] = "application/json" },
            Body    = HttpService:JSONEncode({
                key        = tostring(key or ""),
                service    = tostring(KeyConfig.Junkie.service or ""),
                identifier = tostring(KeyConfig.Junkie.identifier or ""),
            }),
        })
        if not resp then return { valid = false, error = "ERROR" } end
        if resp.StatusCode ~= 200 then return { valid = false, error = "http " .. resp.StatusCode } end
        local ok, data = pcall(function() return HttpService:JSONDecode(resp.Body) end)
        if not ok or type(data) ~= "table" then return { valid = false, error = "ERROR" } end
        return data
    end

    local function JunkieGetKeyLink()
        local resp = JunkieReq({
            Method  = "POST",
            Url     = JunkieBase .. "/getKeyOpen",
            Headers = { ["Content-Type"] = "application/json" },
            Body    = HttpService:JSONEncode({
                service    = tostring(KeyConfig.Junkie.service or ""),
                provider   = tostring(KeyConfig.Junkie.provider or ""),
                identifier = tostring(KeyConfig.Junkie.identifier or ""),
            }),
        })
        if not resp then return nil, "ERROR" end
        if resp.StatusCode == 429 then return nil, "RATE_LIMITTED" end
        if resp.StatusCode ~= 200 then return nil, resp.Body or "ERROR" end
        return resp.Body, nil
    end

    local function Trim(s)
        return (tostring(s or ""):gsub("^%s*(.-)%s*$", "%1"))
    end

    local function IsValidKey(key)
        if key == "" then return false end
        if type(KeyConfig.Validate) == "function" then
            local ok, result = pcall(KeyConfig.Validate, key)
            return ok and result == true
        end
        if type(KeyConfig.Keys) == "table" then
            for _, k in ipairs(KeyConfig.Keys) do
                if tostring(k) == key then return true end
            end
        end
        return false
    end

    local function SaveValidKey(key)
        if not KeyConfig.SaveKey then return end
        local ok = pcall(function()
            EnsureFolderForFile(KeyConfig.FileName)
            writefile(KeyConfig.FileName, key)
        end)
        if not ok then
            warn("[BolongUi] Gagal menyimpan key ke " .. tostring(KeyConfig.FileName))
        end
    end

    if KeyConfig.SaveKey and isfile and isfile(KeyConfig.FileName) then
        local ok, saved = pcall(readfile, KeyConfig.FileName)
        if ok and Trim(saved) ~= "" then
            if JunkieActive then
                if JunkieLoadErr then
                    
                else
                    local passed, done = false, false
                    task.spawn(function()
                        local ok2, result = pcall(function()
                            return JunkieCheckKey(Trim(saved))
                        end)
                        passed = ok2 and type(result) == "table" and result.valid == true
                        done = true
                    end)
                    local deadline = 0
                    while not done and deadline < 200 do
                        task.wait(0.1)
                        deadline = deadline + 1
                    end
                    if passed then
                        return true
                    end
                end
            elseif IsValidKey(Trim(saved)) then
                return true
            end
        end
    end

    local _genv = (getgenv and getgenv()) or {}
    local genvKey = _genv.SCRIPT_KEY
    if genvKey and type(genvKey) == "string" and Trim(genvKey) ~= "" then
        if JunkieActive then
            if not JunkieLoadErr then
                local passed, done = false, false
                task.spawn(function()
                    local ok2, result = pcall(function()
                        return JunkieCheckKey(Trim(genvKey))
                    end)
                    passed = ok2 and type(result) == "table" and result.valid == true
                    done = true
                end)
                local deadline = 0
                while not done and deadline < 200 do
                    task.wait(0.1)
                    deadline = deadline + 1
                end
                if passed then
                    SaveValidKey(Trim(genvKey))
                    return true
                end
            end
        elseif IsValidKey(Trim(genvKey)) then
            SaveValidKey(Trim(genvKey))
            return true
        end
    end

    local BKey = Instance.new("ScreenGui")
    BKey.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    BKey.Name = "BKeySystem"
    BKey.ResetOnSpawn = false
    BKey.Parent = CoreGui

    local KeyDesignW = isMobile and 340 or 360
    local KeyDesignH = 192
    local UIScaleKey = Instance.new("UIScale")
    UIScaleKey.Scale = 1
    UIScaleKey.Name = "KeyScale"
    
    
    local CardSize = UDim2.new(0, KeyDesignW, 0, KeyDesignH)

    local ShadowHolder = Instance.new("Frame")
    ShadowHolder.BackgroundTransparency = 1
    ShadowHolder.BorderSizePixel = 0
    ShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    ShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    ShadowHolder.Size = CardSize
    ShadowHolder.Name = "ShadowHolder"
    ShadowHolder.Parent = BKey
    UIScaleKey.Parent = ShadowHolder

    local Shadow = Instance.new("ImageLabel")
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Color3.fromRGB(10, 10, 10)
    Shadow.ImageTransparency = 0.25
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.BorderSizePixel = 0
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Name = "Shadow"
    Shadow.Parent = ShadowHolder

    local KeyMain = Instance.new("Frame")
    KeyMain.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
    KeyMain.BorderSizePixel = 0
    KeyMain.ClipsDescendants = true
    KeyMain.AnchorPoint = Vector2.new(0.5, 0.5)
    KeyMain.Position = UDim2.new(0.5, 0, 0.5, 0)
    KeyMain.Size = UDim2.new(1, 0, 1, 0)
    KeyMain.Name = "KeyMain"
    
    
    KeyMain.Parent = ShadowHolder

    local KeyMainCorner = Instance.new("UICorner")
    KeyMainCorner.CornerRadius = UDim.new(0, 10)
    KeyMainCorner.Parent = KeyMain

    local KeyTop = Instance.new("Frame")
    KeyTop.BackgroundTransparency = 1
    KeyTop.BorderSizePixel = 0
    KeyTop.Position = UDim2.new(0, 0, 0, 0)
    KeyTop.Size = UDim2.new(1, 0, 0, 38)
    KeyTop.Name = "Top"
    KeyTop.Parent = KeyMain

    local KeyIconHolder = Instance.new("Frame")
    KeyIconHolder.BackgroundColor3 = AccentColor
    KeyIconHolder.BackgroundTransparency = 0.85
    KeyIconHolder.BorderSizePixel = 0
    KeyIconHolder.AnchorPoint = Vector2.new(0, 0.5)
    KeyIconHolder.Position = UDim2.new(0, 12, 0.5, 0)
    KeyIconHolder.Size = UDim2.new(0, 22, 0, 22)
    KeyIconHolder.Name = "IconHolder"
    KeyIconHolder.Parent = KeyTop

    local KeyIconHolderCorner = Instance.new("UICorner")
    KeyIconHolderCorner.CornerRadius = UDim.new(0, 6)
    KeyIconHolderCorner.Parent = KeyIconHolder

    local KeyIcon = Instance.new("ImageLabel")
    KeyIcon.BackgroundTransparency = 1
    KeyIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    KeyIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    KeyIcon.Size = UDim2.new(1, -6, 1, -6)
    KeyIcon.ImageColor3 = AccentColor
    KeyIcon.Name = "Icon"
    KeyIcon.Parent = KeyIconHolder
    ApplyIcon(KeyIcon, "key-round", 64)

    local KeyTitle = Instance.new("TextLabel")
    KeyTitle.Font = Enum.Font.GothamBold
    KeyTitle.Text = KeyConfig.Title
    KeyTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
    KeyTitle.TextSize = 14
    KeyTitle.TextXAlignment = Enum.TextXAlignment.Left
    KeyTitle.TextYAlignment = Enum.TextYAlignment.Center
    KeyTitle.BackgroundTransparency = 1
    KeyTitle.AnchorPoint = Vector2.new(0, 0.5)
    KeyTitle.Position = UDim2.new(0, 42, 0.5, 0)
    KeyTitle.Size = UDim2.new(1, -84, 1, 0)
    KeyTitle.Name = "Title"
    KeyTitle.Parent = KeyTop

    local KeyClose = Instance.new("TextButton")
    KeyClose.Font = Enum.Font.SourceSans
    KeyClose.Text = ""
    KeyClose.AutoButtonColor = false
    KeyClose.BackgroundTransparency = 1
    KeyClose.BorderSizePixel = 0
    KeyClose.AnchorPoint = Vector2.new(1, 0.5)
    KeyClose.Position = UDim2.new(1, -10, 0.5, 0)
    KeyClose.Size = UDim2.new(0, 24, 0, 24)
    KeyClose.Name = "Close"
    KeyClose.Parent = KeyTop

    local KeyCloseIcon = Instance.new("ImageLabel")
    KeyCloseIcon.Image = "rbxassetid://9886659671"
    KeyCloseIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    KeyCloseIcon.ImageTransparency = 0.25
    KeyCloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    KeyCloseIcon.BackgroundTransparency = 1
    KeyCloseIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    KeyCloseIcon.Size = UDim2.new(1, -8, 1, -8)
    KeyCloseIcon.Parent = KeyClose

    local closedByUser = false
    KeyClose.Activated:Connect(function()
        closedByUser = true
        BKey:Destroy()
    end)

    MakeDraggable(KeyTop, ShadowHolder)
    
    
    local keyResizeHandle = ShadowHolder:FindFirstChild("changesizeobject")
    if keyResizeHandle then keyResizeHandle:Destroy() end
    local KeyNote = Instance.new("TextLabel")
    KeyNote.Font = Enum.Font.Gotham
    KeyNote.Text = KeyConfig.Note
    KeyNote.TextColor3 = Color3.fromRGB(165, 165, 165)
    KeyNote.TextSize = 13
    KeyNote.TextWrapped = true
    KeyNote.TextXAlignment = Enum.TextXAlignment.Left
    KeyNote.TextYAlignment = Enum.TextYAlignment.Top
    KeyNote.BackgroundTransparency = 1
    KeyNote.Position = UDim2.new(0, 14, 0, 46)
    KeyNote.Size = UDim2.new(1, -28, 0, 38)
    KeyNote.Name = "Note"
    KeyNote.Parent = KeyMain

    local InputHolder = Instance.new("Frame")
    InputHolder.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    InputHolder.BorderSizePixel = 0
    InputHolder.Position = UDim2.new(0, 14, 0, 92)
    InputHolder.Size = UDim2.new(1, -28, 0, 36)
    InputHolder.Name = "InputHolder"
    InputHolder.Parent = KeyMain

    local InputHolderCorner = Instance.new("UICorner")
    InputHolderCorner.CornerRadius = UDim.new(0, 6)
    InputHolderCorner.Parent = InputHolder

    local InputStroke = Instance.new("UIStroke")
    InputStroke.Color = Color3.fromRGB(45, 45, 45)
    InputStroke.Thickness = 1
    InputStroke.Parent = InputHolder

    local KeyInput = Instance.new("TextBox")
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.PlaceholderText = "Masukkan key..."
    KeyInput.PlaceholderColor3 = Color3.fromRGB(110, 110, 110)
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.TextSize = 13
    KeyInput.ClearTextOnFocus = false
    KeyInput.TextXAlignment = Enum.TextXAlignment.Left
    KeyInput.BackgroundTransparency = 1
    KeyInput.Position = UDim2.new(0, 12, 0, 0)
    KeyInput.Size = UDim2.new(1, -24, 1, 0)
    KeyInput.Name = "KeyInput"
    KeyInput.Parent = InputHolder

    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.Text = "Get Key"
    GetKeyBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
    GetKeyBtn.TextSize = 13
    GetKeyBtn.AutoButtonColor = false
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    GetKeyBtn.BorderSizePixel = 0
    GetKeyBtn.Position = UDim2.new(0, 14, 0, 134)
    GetKeyBtn.Size = UDim2.new(0.5, -18, 0, 40)
    GetKeyBtn.Name = "GetKeyBtn"
    GetKeyBtn.Parent = KeyMain

    local GetKeyBtnCorner = Instance.new("UICorner")
    GetKeyBtnCorner.CornerRadius = UDim.new(0, 6)
    GetKeyBtnCorner.Parent = GetKeyBtn

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.Text = "Verify"
    SubmitBtn.TextColor3 = Color3.fromRGB(15, 15, 15)
    SubmitBtn.TextSize = 13
    SubmitBtn.AutoButtonColor = false
    SubmitBtn.BackgroundColor3 = AccentColor
    SubmitBtn.BorderSizePixel = 0
    SubmitBtn.Position = UDim2.new(0.5, 4, 0, 134)
    SubmitBtn.Size = UDim2.new(0.5, -18, 0, 40)
    SubmitBtn.Name = "SubmitBtn"
    SubmitBtn.Parent = KeyMain

    local SubmitBtnCorner = Instance.new("UICorner")
    SubmitBtnCorner.CornerRadius = UDim.new(0, 6)
    SubmitBtnCorner.Parent = SubmitBtn

    
    
    local function GetKeyViewport()
        local cam = workspace.CurrentCamera
        if cam then
            local s = cam.ViewportSize
            if s and s.X > 0 and s.Y > 0 then return s end
        end
        return viewport
    end

    local function LayoutKeyUI()
        if not BKey or not BKey.Parent then return end
        local vp = GetKeyViewport()
        
        local s = math.min(
            math.min(KeyDesignW, vp.X * 0.92) / KeyDesignW,
            math.min(KeyDesignH, vp.Y * 0.92) / KeyDesignH
        )
        if s <= 0 or s ~= s then s = 1 end
        UIScaleKey.Scale = s
        ShadowHolder.Size = CardSize
    end

    GetKeyBtn.MouseEnter:Connect(function()
        TweenService:Create(GetKeyBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(38, 38, 38) }):Play()
    end)
    GetKeyBtn.MouseLeave:Connect(function()
        TweenService:Create(GetKeyBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(28, 28, 28) }):Play()
    end)

    GetKeyBtn.Activated:Connect(function()
        
        if KeyConfig.GetKeyLink and KeyConfig.GetKeyLink ~= "" then
            if setclipboard then
                setclipboard(KeyConfig.GetKeyLink)
                than("Link disalin ke clipboard, buka di browser untuk mendapatkan key.", 5, AccentColor,
                    KeyConfig.Title, "Key System")
            else
                than("Link key: " .. tostring(KeyConfig.GetKeyLink), 6, AccentColor, KeyConfig.Title, "Key System")
            end
            return
        end
        
        if JunkieActive then
            if JunkieLoadErr then
                than(JunkieLoadErr, 5, Color3.fromRGB(255, 170, 0), KeyConfig.Title, "Key System")
                return
            end
            GetKeyBtn.Text = "..."
            task.spawn(function()
                local ok, link, err = pcall(JunkieGetKeyLink)
                task.wait()
                GetKeyBtn.Text = "Get Key"
                if ok and link then
                    if setclipboard then
                        setclipboard(tostring(link))
                        than("Link key disalin ke clipboard, buka di browser.", 5, AccentColor, KeyConfig.Title,
                            "Key System")
                    else
                        than("Link key: " .. tostring(link), 6, AccentColor, KeyConfig.Title, "Key System")
                    end
                elseif err and err:match("^RATE_LIMIT") then
                    than("Rate limited! Tunggu 5 menit sebelum minta link lagi.", 5, Color3.fromRGB(255, 170, 0),
                        KeyConfig.Title, "Key System")
                else
                    than("Gagal mengambil link key: " .. tostring(err or "ERROR"), 5, Color3.fromRGB(255, 90, 90),
                        KeyConfig.Title, "Key System")
                end
            end)
        else
            than("Belum ada link key yang diatur.", 4, Color3.fromRGB(255, 90, 90), KeyConfig.Title, "Key System")
        end
    end)

    local resolved, checking = false, false

    local function HandleJunkieError(err)
        err = tostring(err or "")
        local red    = Color3.fromRGB(255, 90, 90)
        local orange = Color3.fromRGB(255, 170, 0)
        if err == "KEY_INVALID" then
            than("Key tidak ditemukan di sistem.", 4, red, KeyConfig.Title, "Key System")
        elseif err == "KEY_EXPIRED" then
            than("Key sudah kedaluwarsa, dapatkan key baru.", 4, orange, KeyConfig.Title, "Key System")
        elseif err == "HWID_BANNED" then
            than("Hardware kamu di-ban, hubungi support.", 4, red, KeyConfig.Title, "Key System")
            closedByUser = true
            pcall(function() game.Players.LocalPlayer:Kick("HWID BANNED") end)
            pcall(function() BKey:Destroy() end)
        elseif err == "KEY_INVALIDATED" then
            than("Key dinonaktifkan secara manual.", 4, red, KeyConfig.Title, "Key System")
        elseif err == "ALREADY_USED" then
            than("Key sekali pakai sudah digunakan.", 4, red, KeyConfig.Title, "Key System")
        elseif err == "HWID_MISMATCH" then
            than("Batas perangkat (HWID) tercapai.", 4, orange, KeyConfig.Title, "Key System")
        elseif err == "SERVICE_NOT_FOUND" then
            than("Service tidak ditemukan di Junkie.", 4, red, KeyConfig.Title, "Key System")
        elseif err == "SERVICE_MISMATCH" then
            than("Key ini untuk service lain.", 4, orange, KeyConfig.Title, "Key System")
        elseif err == "PREMIUM_REQUIRED" then
            than("Diperlukan key premium untuk service ini.", 4, orange, KeyConfig.Title, "Key System")
        elseif err:match("^http %d+") then
            than("Server error: " .. err, 4, red, KeyConfig.Title, "Key System")
        elseif err == "ERROR" then
            than("Network error, coba lagi.", 4, orange, KeyConfig.Title, "Key System")
        else
            warn("[BolongUi][Junkie] Response tak dikenal: " .. tostring(err))
            than("Key salah atau sudah tidak berlaku.", 4, red, KeyConfig.Title, "Key System")
        end
    end

    local function FinishSuccess(key)
        than("Key valid, selamat datang!", 4, AccentColor, KeyConfig.Title, "Key System")
        SaveValidKey(key)
        resolved = true
        BKey:Destroy()
    end

    local function AttemptSubmit()
        if checking then return end
        local key = Trim(KeyInput.Text)
        if key == "" then
            than("Masukkan key terlebih dahulu.", 3, Color3.fromRGB(255, 170, 0), KeyConfig.Title, "Key System")
            return
        end

        checking = true
        SubmitBtn.Text = "..."
        local done = false
        local resultValid = false
        local resultErr = nil

        if JunkieActive then
            if JunkieLoadErr then
                than(JunkieLoadErr, 5, Color3.fromRGB(255, 170, 0), KeyConfig.Title, "Key System")
                checking = false
                SubmitBtn.Text = "Verify"
                return
            end
            task.spawn(function()
                local ok, result = pcall(function()
                    return JunkieCheckKey(key)
                end)
                done = true
                if ok and type(result) == "table" then
                    resultValid = result.valid == true
                    resultErr = result.error
                    print("[BolongUi][Junkie] check_key(" .. tostring(key) .. ") => valid=" .. tostring(resultValid)
                        .. " msg/err=" .. tostring(result.message or result.error))
                else
                    resultErr = ok and "ERROR" or tostring(result)
                    warn("[BolongUi][Junkie] check_key gagal: " .. tostring(result))
                end
            end)
            
            local deadline = 0
            while not done and deadline < 200 do
                task.wait(0.1)
                deadline = deadline + 1
            end
            checking = false
            SubmitBtn.Text = "Verify"
            if resultValid then
                FinishSuccess(key)
            else
                HandleJunkieError(resultErr)
                if type(KeyConfig.OnFail) == "function" then
                    pcall(KeyConfig.OnFail, key)
                end
            end
        else
            local valid = IsValidKey(key)
            checking = false
            SubmitBtn.Text = "Verify"
            if valid then
                FinishSuccess(key)
            else
                than("Key salah atau sudah tidak berlaku.", 4, Color3.fromRGB(255, 90, 90), KeyConfig.Title, "Key System")
                if type(KeyConfig.OnFail) == "function" then
                    pcall(KeyConfig.OnFail, key)
                end
            end
        end
    end

    SubmitBtn.Activated:Connect(AttemptSubmit)
    KeyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then AttemptSubmit() end
    end)

    KeyMain.BackgroundTransparency = 1
    LayoutKeyUI()
    local keyCam = workspace.CurrentCamera
    if keyCam then
        keyCam:GetPropertyChangedSignal("ViewportSize"):Connect(LayoutKeyUI)
    end
    ShadowHolder.Size = UDim2.new(0, KeyDesignW * 0.94, 0, KeyDesignH * 0.94)
    TweenService:Create(ShadowHolder, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = CardSize }):Play()
    TweenService:Create(KeyMain, TweenInfo.new(0.18), { BackgroundTransparency = 0 }):Play()

    repeat
        task.wait()
    until resolved or closedByUser

    return resolved
end

function Chloex:Window(GuiConfig)
    GuiConfig              = GuiConfig or {}
    GuiConfig.Title        = GuiConfig.Title or "BolongHub"
    GuiConfig.Image        = GuiConfig.Image or "84034353458936"
    GuiConfig.Footer       = GuiConfig.Footer or ""
    GuiConfig.Author       = GuiConfig.Author or ""
    GuiConfig.Color        = GuiConfig.Color or Color3.fromRGB(240, 240, 240)
    GuiConfig["Tab Width"] = GuiConfig["Tab Width"] or 120
    GuiConfig.Version      = GuiConfig.Version or 1
    if GuiConfig.Search == nil then GuiConfig.Search = true end
    GuiConfig.WindowKeybind = GuiConfig.WindowKeybind or Enum.KeyCode.B

    
    
    
    local FolderScope = SanitizeConfigName(GuiConfig.Folder)
    GuiConfig.Folder = FolderScope

    if FolderScope ~= "" then
        GameConfigFolder = BOLONG_ROOT .. "/" .. gameName .. "/" .. FolderScope
    else
        GameConfigFolder = BOLONG_ROOT .. "/" .. gameName
    end
    ConfigFile = GameConfigFolder .. "/_base.json"

    if GuiConfig.KeySystem then
        local passed = RunKeySystemGate(GuiConfig.KeySystem, GuiConfig.Color, GuiConfig.Folder)
        if not passed then
            return nil
        end
    end

    CURRENT_VERSION        = GuiConfig.Version
    LoadConfigFromFile()

    local GuiFunc = {}

    local SearchRegistry = {}
    local TabRegistry = {}

    local function SmartMatch(query, target)
        if query == "" then return 0 end
        local q, t = string.lower(query), string.lower(target)
        if q == t then return 1000 end
        if string.sub(t, 1, #q) == q then return 800 end
        local idx = string.find(t, q, 1, true)
        if idx then return 600 - idx end
        local qi, ti, lastIdx = 1, 1, 0
        while qi <= #q and ti <= #t do
            if string.sub(q, qi, qi) == string.sub(t, ti, ti) then
                lastIdx = ti
                qi = qi + 1
            end
            ti = ti + 1
        end
        if qi > #q then
            return 200 - (lastIdx - #q) * 2
        end
        return 0
    end

    local function RegisterSearch(entry)
        table.insert(SearchRegistry, entry)
    end

    local function ExtractConfigPayload(payload)
        local data = payload
        if type(payload.Data) == "table" then
            data = payload.Data
        elseif type(payload.Config) == "table" then
            data = payload.Config
        elseif type(payload.Settings) == "table" then
            data = payload.Settings
        end

        if type(data) ~= "table" then return nil end

        local cleaned = {}
        for key, value in pairs(data) do
            if key ~= "_version"
                and key ~= "Game"
                and key ~= "Version"
                and key ~= "PlaceId"
                and key ~= "Hub"
                and key ~= "SavedAt"
                and key ~= "ActiveConfig"
                and key ~= "AutoLoad"
                and not InternalConfigKeys[key] then
                cleaned[key] = value
            end
        end

        return cleaned
    end

    local function ApplyConfigData(data)
        if IsEmptySnapshot(data) then
            warn("[BolongUi] ApplyConfigData dilewati: data config kosong")
            return false
        end

        ApplyingConfig = true
        ConfigData = { _version = CURRENT_VERSION }

        for key, value in pairs(data) do
            ConfigData[key] = value
            if Elements[key] and Elements[key].Set then
                local ok, err = pcall(function()
                    Elements[key]:Set(value, true)
                end)
                if not ok then
                    warn("ApplyConfigData failed for '" .. tostring(key) .. "':", err)
                end
            end
        end

        ConfigData._version = CURRENT_VERSION
        ApplyingConfig = false
        return true
    end

    function GuiFunc:ExportConfig()
        local payload = HttpService:JSONEncode({
            Hub = "BolongHub",
            Game = gameName,
            PlaceId = game.PlaceId,
            Version = CURRENT_VERSION,
            ActiveConfig = ActiveConfigName or "",
            AutoLoad = GuiFunc:GetAutoLoad(),
            Data = GetConfigSnapshot(),
        })
        if setclipboard then
            setclipboard(payload)
            than("Config copied to clipboard", 4, GuiConfig.Color, "BolongHub", "Export")
        end
        return payload
    end

    function GuiFunc:ImportConfig(str)
        if not str or str == "" then
            than("Paste a config string first", 4, Color3.fromRGB(255, 90, 90), "BolongHub", "Import")
            return false
        end
        local ok, dec = pcall(function() return HttpService:JSONDecode(str) end)
        if not ok or type(dec) ~= "table" then
            than("Invalid config format", 4, Color3.fromRGB(255, 90, 90), "BolongHub", "Import")
            return false
        end
        local data = ExtractConfigPayload(dec)
        if not data then
            than("Config data is empty", 4, Color3.fromRGB(255, 90, 90), "BolongHub", "Import")
            return false
        end

        ApplyConfigData(data)
        QueueSaveConfig(AutoSaveEnabled)
        than("Config imported", 4, GuiConfig.Color, "BolongHub", "Import")
        return true
    end

    local function EnsureConfigFolder()
        if not isfolder(BOLONG_ROOT) then makefolder(BOLONG_ROOT) end
        EnsureFolderForFile(GameConfigFolder .. "/_base.json")
    end

    local InternalFileNames = {
        _meta = true,
        _autoload = true,
        _base = true,
        presets = true,
    }

    function GuiFunc:GetConfigs()
        local out = {}
        if not listfiles then return out end
        EnsureConfigFolder()
        for _, f in ipairs(listfiles(GameConfigFolder)) do
            local n = string.match(f, "([^/\\]+)%.json$")
            if n and string.sub(n, 1, 1) ~= "_" and not InternalFileNames[n] then
                table.insert(out, n)
            end
        end
        return out
    end

    function GuiFunc:SaveConfigAs(name)
        if not name or name == "" then
            than("Enter a config name first", 4, Color3.fromRGB(255, 90, 90), "BolongHub", "Config")
            return false
        end
        if not writefile then return false end
        EnsureConfigFolder()
        local path = GameConfigFolder .. "/" .. name .. ".json"

        local snapshot = GetConfigSnapshot()
        local ok, encoded = pcall(function() return HttpService:JSONEncode(snapshot) end)
        if not ok then
            warn("SaveConfigAs failed to encode config:", encoded)
            than("Failed to save config", 4, Color3.fromRGB(255, 90, 90), "BolongHub", "Config")
            return false
        end

        if not SafeWriteConfig(path, encoded) then
            than("Gagal menyimpan '" .. tostring(name) .. "'", 4, Color3.fromRGB(255, 90, 90), "BolongHub", "Config")
            return false
        end
        SetActiveConfig(name, path, nil, "saved")
        than("Saved '" .. name .. "'", 4, GuiConfig.Color, "BolongHub", "Config")
        return true
    end

    function GuiFunc:LoadConfigByName(name)
        if not name or name == "" then return false end
        local path = GameConfigFolder .. "/" .. name .. ".json"
        if not (isfile and isfile(path)) then
            than("Config '" .. tostring(name) .. "' tidak ditemukan", 4, Color3.fromRGB(255, 90, 90), "BolongHub", "Config")
            return false
        end
        local dec = TryReadConfig(path, 3)
        if not dec then
            than("Gagal membaca config '" .. tostring(name) .. "'", 4, Color3.fromRGB(255, 90, 90), "BolongHub", "Config")
            return false
        end
        local data = ExtractConfigPayload(dec)
        if not data then
            than("Config data is empty", 4, Color3.fromRGB(255, 90, 90), "BolongHub", "Config")
            return false
        end

        ApplyConfigData(data)
        SetActiveConfig(name, path, nil, "manual")
        than("Loaded '" .. name .. "'", 4, GuiConfig.Color, "BolongHub", "Config")
        return true
    end

    function GuiFunc:DeleteConfig(name)
        local path = GameConfigFolder .. "/" .. name .. ".json"
        if isfile and isfile(path) and delfile then
            delfile(path)
            if ActiveConfigName == name then
                SetActiveConfig(nil, nil, nil, nil)
            end
            if GuiFunc:GetAutoLoad() == name then
                GuiFunc:SetAutoLoad("")
            end

            local accInfo = GetAccountAutoLoadInfo()
            local changed = false
            for id, cfgName in pairs(accInfo.Accounts) do
                if cfgName == name then
                    accInfo.Accounts[id] = nil
                    changed = true
                end
            end
            if changed then WriteAccountAutoLoadInfo(accInfo) end

            than("Deleted '" .. name .. "'", 4, Color3.fromRGB(255, 170, 0), "BolongHub", "Config")
            return true
        end
        return false
    end

    function GuiFunc:SetAutoLoad(name)
        if not writefile then return end
        EnsureConfigFolder()
        name = name or ""
        writefile(GameConfigFolder .. "/_autoload.json", HttpService:JSONEncode({ Name = name }))
        if name ~= "" then
            local info = GetAccountAutoLoadInfo()
            if info.Enabled then
                info.Enabled = false
                WriteAccountAutoLoadInfo(info)
                AccountAutoLoadEnabledPending = false
            end
        end
    end

    function GuiFunc:GetAutoLoad()
        local path = GameConfigFolder .. "/_autoload.json"
        if isfile and isfile(path) then
            local ok, dec = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
            if ok and type(dec) == "table" then return dec.Name or "" end
        end
        return ""
    end

    function GuiFunc:GetAccountAutoLoadInfo()
        return GetAccountAutoLoadInfo()
    end

    function GuiFunc:WriteAccountAutoLoadInfo(info)
        return WriteAccountAutoLoadInfo(info)
    end

    function GuiFunc:GetCurrentAccountId()
        return GetCurrentAccountId()
    end

    function GuiFunc:SetAccountAutoLoad(accountId, configName)
        accountId = tostring(accountId or GetCurrentAccountId())
        local info = GetAccountAutoLoadInfo()
        if configName and configName ~= "" then
            info.Accounts[accountId] = tostring(configName)
        else
            info.Accounts[accountId] = nil
        end
        if not WriteAccountAutoLoadInfo(info) then
            than("Failed to save account mapping", 4, Color3.fromRGB(255, 90, 90), "BolongHub", "Config")
            return false
        end
        return true
    end

    function GuiFunc:SetAccountAutoLoadEnabled(value)
        local info = GetAccountAutoLoadInfo()
        info.Enabled = value == true
        if not WriteAccountAutoLoadInfo(info) then
            than("Failed to save per-account status", 4, Color3.fromRGB(255, 90, 90), "BolongHub", "Config")
            return false
        end
        AccountAutoLoadEnabledPending = info.Enabled
        if info.Enabled then
            GuiFunc:SetAutoLoad("")
        end
        return true
    end

    local BHub = Instance.new("ScreenGui");
    local DropShadowHolder = Instance.new("Frame");
    local DropShadow = Instance.new("ImageLabel");
    local Main = Instance.new("Frame");
    local UICorner = Instance.new("UICorner");
    local Top = Instance.new("Frame");
    local TextLabel = Instance.new("TextLabel");
    local UICorner1 = Instance.new("UICorner");
    local TextLabel1 = Instance.new("TextLabel");
    local Close = Instance.new("TextButton");
    local Lock = Instance.new("TextButton");
    local mainButtonLocked = false
    local ImageLabel1 = Instance.new("ImageLabel");
    local Min = Instance.new("TextButton");
    local ImageLabel2 = Instance.new("ImageLabel");
    local LayersTab = Instance.new("Frame");
    local UICorner2 = Instance.new("UICorner");
    local DecideFrame = Instance.new("Frame");
    local Layers = Instance.new("Frame");
    local UICorner6 = Instance.new("UICorner");
    local NameTab = Instance.new("TextLabel");
    local LayersReal = Instance.new("Frame");
    local LayersFolder = Instance.new("Folder");
    local LayersPageLayout = Instance.new("UIPageLayout");

    BHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    BHub.Name = "BHub"
    BHub.ResetOnSpawn = false
    BHub.Parent = game:GetService("CoreGui")

    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.BorderSizePixel = 0
    DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    if isMobile then
        DropShadowHolder.Size = safeSize(470, 270)
    else
        DropShadowHolder.Size = safeSize(640, 400)
    end
    DropShadowHolder.ZIndex = 0
    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.Parent = BHub

    DropShadowHolder.Position = UDim2.new(0, (BHub.AbsoluteSize.X // 2 - DropShadowHolder.Size.X.Offset // 2), 0,
        (BHub.AbsoluteSize.Y // 2 - DropShadowHolder.Size.Y.Offset // 2))
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = Color3.fromRGB(10, 10, 10)
    DropShadow.ImageTransparency = 1
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.BorderSizePixel = 0
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 47, 1, 47)
    DropShadow.ZIndex = 0
    DropShadow.Name = "DropShadow"
    DropShadow.Parent = DropShadowHolder

    if GuiConfig.Theme then
        Main:Destroy()
        Main = Instance.new("ImageLabel")
        Main.Image = "rbxassetid://" .. GuiConfig.Theme
        Main.ScaleType = Enum.ScaleType.Crop
        Main.BackgroundTransparency = 1
        Main.ImageTransparency = GuiConfig.ThemeTransparency or 0.15
    else
        Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        Main.BackgroundTransparency = 0.12
    end

    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BorderColor3 = Color3.fromRGB(15, 15, 15)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(1, -47, 1, -47)
    Main.Name = "Main"
    Main.Parent = DropShadow

    UICorner.Parent = Main

    Top.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Top.BackgroundTransparency = 1
    Top.BorderSizePixel = 0
    Top.Size = UDim2.new(1, 0, 0, 38)
    Top.Name = "Top"
    Top.Parent = Main

    local HeaderRow1Y = 14
    local HeaderRow2Y = 27

    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.Text = GuiConfig.Title
    TextLabel.TextColor3 = GuiConfig.Color
    TextLabel.TextSize = 14
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextYAlignment = Enum.TextYAlignment.Center
    TextLabel.BackgroundTransparency = 1
    TextLabel.BorderSizePixel = 0
    TextLabel.AnchorPoint = Vector2.new(0, 0.5)
    TextLabel.Size = UDim2.new(1, -100, 0, 16)
    TextLabel.Position = UDim2.new(0, 10, 0, HeaderRow1Y)
    TextLabel.Parent = Top

    UICorner1.Parent = Top

    local DiscordDivider, DiscordImg, DiscordBtn
    local discordOffset = 0
    local DiscordButtonRef = nil
    if GuiConfig.Discord and GuiConfig.Discord ~= "" then
        DiscordDivider = Instance.new("Frame")
        DiscordDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        DiscordDivider.BackgroundTransparency = 0.75
        DiscordDivider.BorderSizePixel = 0
        DiscordDivider.AnchorPoint = Vector2.new(0, 0.5)
        DiscordDivider.Size = UDim2.new(0, 1, 0, 16)
        DiscordDivider.Name = "DiscordDivider"
        DiscordDivider.Parent = Top

        local DividerCorner = Instance.new("UICorner")
        DividerCorner.CornerRadius = UDim.new(1, 0)
        DividerCorner.Parent = DiscordDivider

        DiscordImg = Instance.new("ImageLabel")
        DiscordImg.Image = discord_logo_asset_id
        DiscordImg.ImageColor3 = Color3.fromRGB(88, 101, 242)
        DiscordImg.BackgroundTransparency = 1
        DiscordImg.ScaleType = Enum.ScaleType.Fit
        DiscordImg.AnchorPoint = Vector2.new(0, 0.5)
        DiscordImg.Size = UDim2.new(0, 16, 0, 16)
        DiscordImg.Name = "DiscordImg"
        DiscordImg.Parent = Top

        DiscordBtn = Instance.new("TextButton")
        DiscordBtn.Text = ""
        DiscordBtn.AutoButtonColor = false
        DiscordBtn.BackgroundTransparency = 1
        DiscordBtn.BorderSizePixel = 0
        DiscordBtn.AnchorPoint = Vector2.new(0, 0.5)
        DiscordBtn.Size = UDim2.new(0, 0, 0, 16)
        DiscordBtn.Name = "DiscordBtn"
        DiscordBtn.Parent = Top

        DiscordBtn.MouseEnter:Connect(function()
            TweenService:Create(DiscordImg, TweenInfo.new(0.2), { ImageColor3 = Color3.fromRGB(120, 132, 255) }):Play()
            TweenService:Create(DiscordDivider, TweenInfo.new(0.2), { BackgroundTransparency = 0.5 }):Play()
        end)
        DiscordBtn.MouseLeave:Connect(function()
            TweenService:Create(DiscordImg, TweenInfo.new(0.2), { ImageColor3 = Color3.fromRGB(88, 101, 242) }):Play()
            TweenService:Create(DiscordDivider, TweenInfo.new(0.2), { BackgroundTransparency = 0.75 }):Play()
        end)
        DiscordBtn.Activated:Connect(function()
            if setclipboard then
                setclipboard(GuiConfig.Discord)
                than("Discord invite copied", 4, GuiConfig.Color, "BolongHub", "Community")
            end
        end)

        discordOffset = 36
        DiscordButtonRef = DiscordBtn
    end

    local TitleAuthorDivider
    local authorOffset = 0
    if GuiConfig.Author and GuiConfig.Author ~= "" then
        TitleAuthorDivider = Instance.new("Frame")
        TitleAuthorDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TitleAuthorDivider.BackgroundTransparency = 0.75
        TitleAuthorDivider.BorderSizePixel = 0
        TitleAuthorDivider.AnchorPoint = Vector2.new(0, 0.5)
        TitleAuthorDivider.Size = UDim2.new(0, 1, 0, 16)
        TitleAuthorDivider.Name = "TitleAuthorDivider"
        TitleAuthorDivider.Parent = Top

        local TitleAuthorDividerCorner = Instance.new("UICorner")
        TitleAuthorDividerCorner.CornerRadius = UDim.new(1, 0)
        TitleAuthorDividerCorner.Parent = TitleAuthorDivider

        authorOffset = 7.5
    end

    TextLabel1.Font = Enum.Font.GothamBold
    TextLabel1.Text = GuiConfig.Author
    TextLabel1.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel1.TextSize = 14
    TextLabel1.TextTransparency = 0
    TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel1.TextYAlignment = Enum.TextYAlignment.Center
    TextLabel1.BackgroundTransparency = 1
    TextLabel1.BorderSizePixel = 0
    TextLabel1.AnchorPoint = Vector2.new(0, 0.5)
    TextLabel1.Size = UDim2.new(1, -(TextLabel.TextBounds.X + 104 + discordOffset + authorOffset), 0, 16)
    TextLabel1.Name = "AuthorLabel"
    TextLabel1.Parent = Top

    
    local function UpdateHeaderLayout()
        local titleBoundsX = TextLabel.TextBounds.X
        local authorBoundsX = TextLabel1.TextBounds.X

        if GuiConfig.Discord and GuiConfig.Discord ~= "" then
            local discordBaseX = titleBoundsX + 18
            DiscordDivider.Position = UDim2.new(0, discordBaseX, 0, HeaderRow1Y)
            DiscordImg.Position = UDim2.new(0, discordBaseX + 10, 0, HeaderRow1Y)
            DiscordBtn.Position = UDim2.new(0, discordBaseX + 8, 0, HeaderRow1Y)
            DiscordBtn.Size = UDim2.new(0, discordOffset + authorBoundsX + 6, 0, 16)
        end

        if GuiConfig.Author and GuiConfig.Author ~= "" then
            local titleAuthorDividerX = titleBoundsX + 15 + discordOffset
            TitleAuthorDivider.Position = UDim2.new(0, titleAuthorDividerX, 0, HeaderRow1Y)
        end

        TextLabel1.Size = UDim2.new(1, -(titleBoundsX + 104 + discordOffset + authorOffset), 0, 16)
        TextLabel1.Position = UDim2.new(0, titleBoundsX + 15 + discordOffset + authorOffset, 0, HeaderRow1Y)

        local defHeight = isMobile and 315 or 400
        local targetWidth = 115 + titleBoundsX + 1 + authorBoundsX
        if not isMobile then
            if targetWidth < 500 then targetWidth = 500 end 
        else
            if targetWidth < 490 then targetWidth = 490 end 
        end
        
        DropShadowHolder.Size = UDim2.new(0, targetWidth, 0, defHeight)
    end

    TextLabel:GetPropertyChangedSignal("TextBounds"):Connect(UpdateHeaderLayout)
    TextLabel1:GetPropertyChangedSignal("TextBounds"):Connect(UpdateHeaderLayout)
    
    task.spawn(function()
        task.wait()
        UpdateHeaderLayout()
    end)

    local FooterLabel = Instance.new("TextLabel")
    FooterLabel.Font = Enum.Font.GothamBold
    FooterLabel.Text = GuiConfig.Footer
    FooterLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    FooterLabel.TextTransparency = 0.4
    FooterLabel.TextSize = 12
    FooterLabel.TextXAlignment = Enum.TextXAlignment.Left
    FooterLabel.TextYAlignment = Enum.TextYAlignment.Center
    FooterLabel.BackgroundTransparency = 1
    FooterLabel.BorderSizePixel = 0
    FooterLabel.AnchorPoint = Vector2.new(0, 0.5)
    FooterLabel.Size = UDim2.new(1, -100, 0, 14)
    FooterLabel.Position = UDim2.new(0, 10, 0, HeaderRow2Y)
    FooterLabel.Name = "FooterLabel"
    FooterLabel.Parent = Top

    Close.Font = Enum.Font.SourceSans
    Close.Text = ""
    Close.TextColor3 = Color3.fromRGB(15, 15, 15)
    Close.TextSize = 14
    Close.AnchorPoint = Vector2.new(1, 0.5)
    Close.BackgroundTransparency = 1
    Close.BorderSizePixel = 0
    Close.Position = UDim2.new(1, -8, 0.5, 0)
    Close.Size = UDim2.new(0, 25, 0, 25)
    Close.Name = "Close"
    Close.Parent = Top

    ImageLabel1.Image = "rbxassetid://9886659671"
    ImageLabel1.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel1.BackgroundTransparency = 1
    ImageLabel1.BorderSizePixel = 0
    ImageLabel1.Position = UDim2.new(0.49, 0, 0.5, 0)
    ImageLabel1.Size = UDim2.new(1, -8, 1, -8)
    ImageLabel1.Parent = Close

    Min.Font = Enum.Font.SourceSans
    Min.Text = ""
    Min.TextColor3 = Color3.fromRGB(15, 15, 15)
    Min.TextSize = 14
    Min.AnchorPoint = Vector2.new(1, 0.5)
    Min.BackgroundTransparency = 1
    Min.BorderSizePixel = 0
    Min.Position = UDim2.new(1, -38, 0.5, 0)
    Min.Size = UDim2.new(0, 25, 0, 25)
    Min.Name = "Min"
    Min.Parent = Top

    ImageLabel2.Image = "rbxassetid://9886659276"
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel2.BackgroundTransparency = 1
    ImageLabel2.ImageTransparency = 0.2
    ImageLabel2.BorderSizePixel = 0
    ImageLabel2.Position = UDim2.new(0.5, 0, 0.5, 0)
    ImageLabel2.Size = UDim2.new(1, -9, 1, -9)
    ImageLabel2.Parent = Min

    Lock.Font = Enum.Font.SourceSans
    Lock.Text = "○"
    Lock.TextColor3 = THEME.faint
    Lock.TextSize = 18
    Lock.AnchorPoint = Vector2.new(1, 0.5)
    Lock.BackgroundTransparency = 1
    Lock.BorderSizePixel = 0
    Lock.Position = UDim2.new(1, -66, 0.5, 0)
    Lock.Size = UDim2.new(0, 30, 0, 30)
    Lock.Name = "Lock"
    Lock.Parent = Top

    LayersTab.BackgroundTransparency = 1
    LayersTab.BorderSizePixel = 0
    LayersTab.Position = UDim2.new(0, 9, 0, 50)
    LayersTab.Size = UDim2.new(0, GuiConfig["Tab Width"], 1, -59)
    LayersTab.Name = "LayersTab"
    LayersTab.Parent = Main

    UICorner2.CornerRadius = UDim.new(0, 2)
    UICorner2.Parent = LayersTab

    DecideFrame.AnchorPoint = Vector2.new(0.5, 0)
    DecideFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DecideFrame.BackgroundTransparency = 0.85
    DecideFrame.BorderColor3 = Color3.fromRGB(15, 15, 15)
    DecideFrame.BorderSizePixel = 0
    DecideFrame.Position = UDim2.new(0.5, 0, 0, 38)
    DecideFrame.Size = UDim2.new(1, 0, 0, 1)
    DecideFrame.Name = "DecideFrame"
    DecideFrame.Parent = Main

    Layers.BackgroundTransparency = 1
    Layers.BorderSizePixel = 0
    Layers.Position = UDim2.new(0, GuiConfig["Tab Width"] + 18, 0, 50)
    Layers.Size = UDim2.new(1, -(GuiConfig["Tab Width"] + 9 + 18), 1, -59)
    Layers.Name = "Layers"
    Layers.Parent = Main

    UICorner6.CornerRadius = UDim.new(0, 2)
    UICorner6.Parent = Layers

    NameTab.Font = Enum.Font.GothamBold
    NameTab.Text = ""
    NameTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameTab.TextSize = 24
    NameTab.TextWrapped = true
    NameTab.TextXAlignment = Enum.TextXAlignment.Left
    NameTab.BackgroundTransparency = 1
    NameTab.BorderSizePixel = 0
    NameTab.Size = UDim2.new(1, 0, 0, 30)
    NameTab.Name = "NameTab"
    NameTab.Parent = Layers

    LayersReal.AnchorPoint = Vector2.new(0, 1)
    LayersReal.BackgroundTransparency = 1
    LayersReal.BorderSizePixel = 0
    LayersReal.ClipsDescendants = true
    LayersReal.Position = UDim2.new(0, 0, 1, 0)
    LayersReal.Size = UDim2.new(1, 0, 1, -33)
    LayersReal.Name = "LayersReal"
    LayersReal.Parent = Layers

    LayersFolder.Name = "LayersFolder"
    LayersFolder.Parent = LayersReal

    LayersPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LayersPageLayout.Name = "LayersPageLayout"
    LayersPageLayout.Parent = LayersFolder
    LayersPageLayout.TweenTime = 0.5
    LayersPageLayout.EasingDirection = Enum.EasingDirection.InOut
    LayersPageLayout.EasingStyle = Enum.EasingStyle.Quad

    local ScrollTab = Instance.new("ScrollingFrame");
    local UIListLayout = Instance.new("UIListLayout");

    ScrollTab.CanvasSize = UDim2.new(0, 0, 1.1, 0)
    ScrollTab.ScrollBarImageColor3 = Color3.fromRGB(15, 15, 15)
    ScrollTab.ScrollBarThickness = 0
    ScrollTab.Active = true
    ScrollTab.BackgroundTransparency = 1
    ScrollTab.BorderSizePixel = 0
    if GuiConfig.Search then
        ScrollTab.Position = UDim2.new(0, 0, 0, 34)
        ScrollTab.Size = UDim2.new(1, 0, 1, -34)
    else
        ScrollTab.Size = UDim2.new(1, 0, 1, 0)
    end
    ScrollTab.Name = "ScrollTab"
    ScrollTab.Parent = LayersTab

    UIListLayout.Padding = UDim.new(0, 3)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollTab

    local function UpdateSize1()
        local OffsetY = 0
        for _, child in ScrollTab:GetChildren() do
            if child.Name ~= "UIListLayout" then
                OffsetY = OffsetY + 3 + child.Size.Y.Offset
            end
        end
        ScrollTab.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
    end
    ScrollTab.ChildAdded:Connect(UpdateSize1)
    ScrollTab.ChildRemoved:Connect(UpdateSize1)

    local SearchResults, SearchResultsLayout, SearchBox
    if GuiConfig.Search then
        local SearchBar = Instance.new("Frame")
        SearchBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SearchBar.BackgroundTransparency = 0.93
        SearchBar.BorderSizePixel = 0
        SearchBar.Position = UDim2.new(0, 0, 0, 0)
        SearchBar.Size = UDim2.new(1, 0, 0, 28)
        SearchBar.Name = "SearchBar"
        SearchBar.Parent = LayersTab

        local SearchCorner = Instance.new("UICorner")
        SearchCorner.CornerRadius = UDim.new(0, 4)
        SearchCorner.Parent = SearchBar

        local SearchIcon = Instance.new("ImageLabel")
        ApplyIcon(SearchIcon, "search", 24)
        SearchIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
        SearchIcon.BackgroundTransparency = 1
        SearchIcon.ScaleType = Enum.ScaleType.Fit
        SearchIcon.Position = UDim2.new(0, 7, 0.5, 0)
        SearchIcon.AnchorPoint = Vector2.new(0, 0.5)
        SearchIcon.Size = UDim2.new(0, 14, 0, 14)
        SearchIcon.Name = "SearchIcon"
        SearchIcon.Parent = SearchBar

        SearchBox = Instance.new("TextBox")
        SearchBox.Font = Enum.Font.GothamBold
        SearchBox.PlaceholderText = "Search..."
        SearchBox.PlaceholderColor3 = Color3.fromRGB(130, 130, 130)
        SearchBox.Text = ""
        SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        SearchBox.TextSize = 12
        SearchBox.TextXAlignment = Enum.TextXAlignment.Left
        SearchBox.ClearTextOnFocus = false
        SearchBox.BackgroundTransparency = 1
        SearchBox.AnchorPoint = Vector2.new(0, 0.5)
        SearchBox.Position = UDim2.new(0, 28, 0.5, 0)
        SearchBox.Size = UDim2.new(1, -34, 1, -6)
        SearchBox.Name = "SearchBox"
        SearchBox.Parent = SearchBar

        SearchResults = Instance.new("ScrollingFrame")
        SearchResults.Active = true
        SearchResults.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        SearchResults.BackgroundTransparency = 0.05
        SearchResults.BorderSizePixel = 0
        SearchResults.ScrollBarThickness = 2
        SearchResults.ScrollBarImageColor3 = GuiConfig.Color
        SearchResults.CanvasSize = UDim2.new(0, 0, 0, 0)
        SearchResults.Position = UDim2.new(0, 0, 0, 34)
        SearchResults.Size = UDim2.new(1, 0, 1, -34)
        SearchResults.Visible = false
        SearchResults.ZIndex = 20
        SearchResults.Name = "SearchResults"
        SearchResults.Parent = LayersTab

        local SearchResultsCorner = Instance.new("UICorner")
        SearchResultsCorner.CornerRadius = UDim.new(0, 4)
        SearchResultsCorner.Parent = SearchResults

        SearchResultsLayout = Instance.new("UIListLayout")
        SearchResultsLayout.Padding = UDim.new(0, 4)
        SearchResultsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        SearchResultsLayout.Parent = SearchResults

        local SearchPad = Instance.new("UIPadding")
        SearchPad.PaddingTop = UDim.new(0, 4)
        SearchPad.PaddingBottom = UDim.new(0, 4)
        SearchPad.PaddingLeft = UDim.new(0,4)
        SearchPad.PaddingRight = UDim.new(0, 4)
        SearchPad.Parent = SearchResults

        SearchResultsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            SearchResults.CanvasSize = UDim2.new(0, 0, 0, SearchResultsLayout.AbsoluteContentSize.Y + 8)
        end)

        local function NavigateToEntry(entry)
            local sec = entry.section
            if not (sec and sec.ScrolLayers and sec.sectionFrame and sec.SetOpen) then
                if entry.kind == "Toggle" and entry.element and entry.element.Set then
                    entry.element.Value = not entry.element.Value
                    entry.element:Set(entry.element.Value)
                else
                    SearchBox.Text = ""
                    if entry.switch then entry.switch() end
                end
                return
            end
            SearchBox.Text = ""
            if entry.switch then entry.switch() end
            task.wait(0.1)
            local wasOpen = sec:GetOpen()
            if not wasOpen then
                sec:SetOpen(true)
            end
            task.wait(0.6)
            if sec.Flash then sec:Flash() end
            task.wait(0.15)
            local sl = sec.ScrolLayers
            local sf = sec.sectionFrame
            if sl and sf and sl.Parent then
                local target = math.max(0, sf.AbsolutePosition.Y - sl.AbsolutePosition.Y + sl.CanvasPosition.Y - 10)
                TweenService:Create(sl, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    { CanvasPosition = Vector2.new(0, target) }):Play()
            end
        end

        local function RunSearch()
            local q = string.gsub(string.gsub(string.lower(SearchBox.Text), "^%s+", ""), "%s+$", "")
            for _, c in pairs(SearchResults:GetChildren()) do
                if c:IsA("GuiObject") then c:Destroy() end
            end
            if q == "" then
                SearchResults.Visible = false
                ScrollTab.Visible = true
                return
            end
            ScrollTab.Visible = false
            SearchResults.Visible = true

            local scored = {}
            for _, entry in ipairs(SearchRegistry) do
                local score = SmartMatch(q, entry.label)
                if score > 0 then
                    table.insert(scored, { entry = entry, score = score })
                end
            end
            table.sort(scored, function(a, b) return a.score > b.score end)

            local found = 0
            for _, s in ipairs(scored) do
                local entry = s.entry
                local Row = Instance.new("Frame")
                Row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Row.BackgroundTransparency = 0.93
                Row.BorderSizePixel = 0
                Row.Size = UDim2.new(1, 0, 0, 40)
                Row.LayoutOrder = found
                Row.ZIndex = 21
                Row.Name = "Result"
                Row.Parent = SearchResults

                local RowCorner = Instance.new("UICorner")
                RowCorner.CornerRadius = UDim.new(0, 4)
                RowCorner.Parent = Row

                local RowLabel = Instance.new("TextLabel")
                RowLabel.Font = Enum.Font.GothamBold
                RowLabel.Text = entry.label
                RowLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
                RowLabel.TextSize = 12
                RowLabel.TextXAlignment = Enum.TextXAlignment.Left
                RowLabel.TextTruncate = Enum.TextTruncate.AtEnd
                RowLabel.BackgroundTransparency = 1
                RowLabel.Position = UDim2.new(0, 8, 0, 6)
                RowLabel.Size = UDim2.new(1, -16, 0, 14)
                RowLabel.ZIndex = 22
                RowLabel.Parent = Row

                local RowTab = Instance.new("TextLabel")
                RowTab.Font = Enum.Font.Gotham
                RowTab.Text = entry.tab .. (entry.kind and (" • " .. entry.kind) or "")
                RowTab.TextColor3 = GuiConfig.Color
                RowTab.TextSize = 10
                RowTab.TextXAlignment = Enum.TextXAlignment.Left
                RowTab.BackgroundTransparency = 1
                RowTab.Position = UDim2.new(0, 8, 0, 22)
                RowTab.Size = UDim2.new(1, -16, 0, 12)
                RowTab.ZIndex = 22
                RowTab.Parent = Row

                local RowButton = Instance.new("TextButton")
                RowButton.Text = ""
                RowButton.BackgroundTransparency = 1
                RowButton.Size = UDim2.new(1, 0, 1, 0)
                RowButton.ZIndex = 23
                RowButton.Parent = Row

                RowButton.Activated:Connect(function()
                    NavigateToEntry(entry)
                end)

                found = found + 1
                if found >= 15 then break end
            end

            if found == 0 then
                local Empty = Instance.new("TextLabel")
                Empty.Font = Enum.Font.GothamBold
                Empty.Text = "No results"
                Empty.TextColor3 = Color3.fromRGB(150, 150, 150)
                Empty.TextSize = 12
                Empty.BackgroundTransparency = 1
                Empty.Size = UDim2.new(1, 0, 0, 40)
                Empty.ZIndex = 22
                Empty.Parent = SearchResults
            end
        end

        local searchTicket = 0
        SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            searchTicket = searchTicket + 1
            local ticket = searchTicket
            task.delay(0.08, function()
                if ticket == searchTicket then
                    RunSearch()
                end
            end)
        end)
        GuiFunc.FocusSearch = function()
            SearchBox:CaptureFocus()
        end
    end

    function GuiFunc:DestroyGui()
        if CoreGui:FindFirstChild("BHub") then
            BHub:Destroy()
        end
    end

    Min.Activated:Connect(function()
        CircleClick(Min, Mouse.X, Mouse.Y)
        DropShadowHolder.Visible = false
    end)
    Lock.Activated:Connect(function()
        CircleClick(Lock, Mouse.X, Mouse.Y)
        GuiFunc:SetMainButtonLocked(not mainButtonLocked)
        than(
            mainButtonLocked and "Floating button locked" or "Floating button unlocked",
            4,
            GuiConfig.Color,
            GuiConfig.Title,
            "Lock"
        )
    end)
    Close.Activated:Connect(function()
        CircleClick(Close, Mouse.X, Mouse.Y)

        local Overlay = Instance.new("Frame")
        Overlay.Size = UDim2.new(1, 0, 1, 0)
        Overlay.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        Overlay.BackgroundTransparency = 0.3
        Overlay.ZIndex = 50
        Overlay.Parent = DropShadowHolder

        local Dialog = Instance.new("ImageLabel")
        Dialog.Size = UDim2.new(0, 300, 0, 150)
        Dialog.Position = UDim2.new(0.5, -150, 0.5, -75)
        Dialog.Image = "rbxassetid://9542022979"
        Dialog.ImageColor3 = THEME.surface
        Dialog.ImageTransparency = 0
        Dialog.BorderSizePixel = 0
        Dialog.ZIndex = 51
        Dialog.Parent = Overlay
        local UICorner = Instance.new("UICorner", Dialog)
        UICorner.CornerRadius = UDim.new(0, 10)

        local DialogStroke = Instance.new("UIStroke")
        DialogStroke.Color = THEME.border
        DialogStroke.Thickness = 1
        DialogStroke.Parent = Dialog

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 40)
        Title.Position = UDim2.new(0, 0, 0, 4)
        Title.BackgroundTransparency = 1
        Title.Font = Enum.Font.GothamBold
        Title.Text = "BolongHub Window"
        Title.TextSize = 22
        Title.TextColor3 = THEME.text
        Title.ZIndex = 52
        Title.Parent = Dialog

        local Message = Instance.new("TextLabel")
        Message.Size = UDim2.new(1, -20, 0, 60)
        Message.Position = UDim2.new(0, 10, 0, 30)
        Message.BackgroundTransparency = 1
        Message.Font = Enum.Font.Gotham
        Message.Text = "Do you want to close this window?\nYou will not be able to open it again"
        Message.TextSize = 14
        Message.TextColor3 = THEME.muted
        Message.TextWrapped = true
        Message.ZIndex = 52
        Message.Parent = Dialog

        local Yes = Instance.new("TextButton")
        Yes.Size = UDim2.new(0.45, -10, 0, 35)
        Yes.Position = UDim2.new(0.05, 0, 1, -55)
        Yes.BackgroundColor3 = GuiConfig.Color
        Yes.BackgroundTransparency = 0.1
        Yes.Text = "Yes"
        Yes.Font = Enum.Font.GothamBold
        Yes.TextSize = 15
        Yes.TextColor3 = Color3.fromRGB(15, 15, 15)
        Yes.TextTransparency = 0
        Yes.ZIndex = 52
        Yes.Name = "Yes"
        Yes.Parent = Dialog
        Instance.new("UICorner", Yes).CornerRadius = UDim.new(0, 6)
        AddStroke(Yes, GuiConfig.Color, 1, 0)

        local Cancel = Instance.new("TextButton")
        Cancel.Size = UDim2.new(0.45, -10, 0, 35)
        Cancel.Position = UDim2.new(0.5, 10, 1, -55)
        Cancel.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
        Cancel.BackgroundTransparency = 0.1
        Cancel.Text = "Cancel"
        Cancel.Font = Enum.Font.GothamBold
        Cancel.TextSize = 15
        Cancel.TextColor3 = THEME.text
        Cancel.TextTransparency = 0
        Cancel.ZIndex = 52
        Cancel.Name = "Cancel"
        Cancel.Parent = Dialog
        Instance.new("UICorner", Cancel).CornerRadius = UDim.new(0, 6)
        AddStroke(Cancel, THEME.border, 1, 0)

        Yes.MouseButton1Click:Connect(function()
            if BHub then BHub:Destroy() end
            if game.CoreGui:FindFirstChild("ToggleUIButton") then
                game.CoreGui.ToggleUIButton:Destroy()
            end
        end)

        Cancel.MouseButton1Click:Connect(function()
            Overlay:Destroy()
        end)
    end)

    function GuiFunc:ToggleUI()
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Parent = game:GetService("CoreGui")
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.Name = "ToggleUIButton"

        local MainButton = Instance.new("ImageLabel")
        MainButton.Parent = ScreenGui
        MainButton.Size = UDim2.new(0, 50, 0, 50)
        MainButton.Position = UDim2.new(0, 20, 0, 100)
        MainButton.BackgroundTransparency = 1
        MainButton.Image = "rbxassetid://" .. GuiConfig.Image
        MainButton.ScaleType = Enum.ScaleType.Fit

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 6)
        UICorner.Parent = MainButton

        local Button = Instance.new("TextButton")
        Button.Parent = MainButton
        Button.Size = UDim2.new(1, 0, 1, 0)
        Button.BackgroundTransparency = 1
        Button.Text = ""

        Button.MouseButton1Click:Connect(function()
            if DropShadowHolder then
                DropShadowHolder.Visible = not DropShadowHolder.Visible
            end
        end)

        local dragging = false
        local dragStart, startPos

        local function update(input)
            local delta = input.Position - dragStart
            MainButton.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end

        Button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if mainButtonLocked then return end
                dragging = true
                dragStart = input.Position
                startPos = MainButton.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)
    end

GuiFunc:ToggleUI()

    function GuiFunc:SetMainButtonLocked(value)
        mainButtonLocked = value and true or false
        if Lock then
            Lock.Text = mainButtonLocked and "●" or "○"
            Lock.TextColor3 = mainButtonLocked and GuiConfig.Color or THEME.faint
        end
        return self
    end

    function GuiFunc:IsMainButtonLocked()
        return mainButtonLocked
    end

    local windowKeybind = GuiConfig.WindowKeybind

    function GuiFunc:SetWindowKeybind(kc)
        if type(kc) == "string" then
            local ok, converted = pcall(function()
                return Enum.KeyCode[kc]
            end)
            kc = (ok and converted) or Enum.KeyCode.Unknown
        end
        windowKeybind = kc or Enum.KeyCode.Unknown
        return self
    end

    if windowKeybind and windowKeybind ~= Enum.KeyCode.Unknown then
        UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            if windowKeybind ~= Enum.KeyCode.Unknown and input.KeyCode == windowKeybind then
                if DropShadowHolder then
                    DropShadowHolder.Visible = not DropShadowHolder.Visible
                end
            end
        end)
    end

    MakeDraggable(Top, DropShadowHolder)

    local MoreBlur = Instance.new("Frame");
    local DropShadowHolder1 = Instance.new("Frame");
    local DropShadow1 = Instance.new("ImageLabel");
    local UICorner28 = Instance.new("UICorner");
    local ConnectButton = Instance.new("TextButton");

    MoreBlur.AnchorPoint = Vector2.new(1, 1)
    MoreBlur.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MoreBlur.BackgroundTransparency = 0.999
    MoreBlur.BorderColor3 = Color3.fromRGB(15, 15, 15)
    MoreBlur.BorderSizePixel = 0
    MoreBlur.ClipsDescendants = true
    MoreBlur.Position = UDim2.new(1, 8, 1, 8)
    MoreBlur.Size = UDim2.new(1, 154, 1, 54)
    MoreBlur.Visible = false
    MoreBlur.Name = "MoreBlur"
    MoreBlur.Parent = Layers

    DropShadowHolder1.BackgroundTransparency = 1
    DropShadowHolder1.BorderSizePixel = 0
    DropShadowHolder1.Size = UDim2.new(1, 0, 1, 0)
    DropShadowHolder1.ZIndex = 0
    DropShadowHolder1.Name = "DropShadowHolder"
    DropShadowHolder1.Parent = MoreBlur

    DropShadow1.Image = "rbxassetid://6015897843"
    DropShadow1.ImageColor3 = Color3.fromRGB(15, 15, 15)
    DropShadow1.ImageTransparency = 1
    DropShadow1.ScaleType = Enum.ScaleType.Slice
    DropShadow1.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow1.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow1.BackgroundTransparency = 1
    DropShadow1.BorderSizePixel = 0
    DropShadow1.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow1.Size = UDim2.new(1, 35, 1, 35)
    DropShadow1.ZIndex = 0
    DropShadow1.Name = "DropShadow"
    DropShadow1.Parent = DropShadowHolder1

    UICorner28.Parent = MoreBlur

    ConnectButton.Font = Enum.Font.SourceSans
    ConnectButton.Text = ""
    ConnectButton.TextColor3 = Color3.fromRGB(15, 15, 15)
    ConnectButton.TextSize = 14
    ConnectButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ConnectButton.BackgroundTransparency = 0.999
    ConnectButton.BorderColor3 = Color3.fromRGB(15, 15, 15)
    ConnectButton.BorderSizePixel = 0
    ConnectButton.Size = UDim2.new(1, 0, 1, 0)
    ConnectButton.Name = "ConnectButton"
    ConnectButton.Parent = MoreBlur

    local DropdownSelect = Instance.new("Frame");
    local UICorner36 = Instance.new("UICorner");
    local UIStroke14 = Instance.new("UIStroke");
    local DropdownSelectReal = Instance.new("Frame");
    local DropdownFolder = Instance.new("Folder");
    local DropPageLayout = Instance.new("UIPageLayout");

    DropdownSelect.AnchorPoint = Vector2.new(1, 0.5)
    DropdownSelect.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
    DropdownSelect.BackgroundTransparency = 0.15
    DropdownSelect.BorderColor3 = Color3.fromRGB(15, 15, 15)
    DropdownSelect.BorderSizePixel = 0
    DropdownSelect.LayoutOrder = 1
    DropdownSelect.Position = UDim2.new(1, 172, 0.5, 0)
    DropdownSelect.Size = UDim2.new(0, 160, 1, -16)
    DropdownSelect.Name = "DropdownSelect"
    DropdownSelect.ClipsDescendants = true
    DropdownSelect.Parent = MoreBlur

    ConnectButton.Activated:Connect(function()
        if MoreBlur.Visible then
            TweenService:Create(MoreBlur, TweenInfo.new(0.3), { BackgroundTransparency = 0.999 }):Play()
            TweenService:Create(DropdownSelect, TweenInfo.new(0.3), { Position = UDim2.new(1, 172, 0.5, 0) }):Play()
            task.wait(0.3)
            MoreBlur.Visible = false
        end
    end)
    UICorner36.CornerRadius = UDim.new(0, 3)
    UICorner36.Parent = DropdownSelect

    UIStroke14.Color = Color3.fromRGB(255, 255, 255)
    UIStroke14.Thickness = 2.5
    UIStroke14.Transparency = 0.8
    UIStroke14.Parent = DropdownSelect

    DropdownSelectReal.AnchorPoint = Vector2.new(0.5, 0.5)
    DropdownSelectReal.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    DropdownSelectReal.BackgroundTransparency = 0.4
    DropdownSelectReal.BorderColor3 = Color3.fromRGB(15, 15, 15)
    DropdownSelectReal.BorderSizePixel = 0
    DropdownSelectReal.LayoutOrder = 1
    DropdownSelectReal.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropdownSelectReal.Size = UDim2.new(1, 1, 1, 1)
    DropdownSelectReal.Name = "DropdownSelectReal"
    DropdownSelectReal.Parent = DropdownSelect

    DropdownFolder.Name = "DropdownFolder"
    DropdownFolder.Parent = DropdownSelectReal

    DropPageLayout.EasingDirection = Enum.EasingDirection.InOut
    DropPageLayout.EasingStyle = Enum.EasingStyle.Quad
    DropPageLayout.TweenTime = 0.01
    DropPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    DropPageLayout.FillDirection = Enum.FillDirection.Vertical
    DropPageLayout.Archivable = false
    DropPageLayout.Name = "DropPageLayout"
    DropPageLayout.Parent = DropdownFolder
    local Tabs = {}
    local CountTab = 0
    local CountDropdown = 0
    function Tabs:AddTab(TabConfig)
        local TabConfig = TabConfig or {}
        TabConfig.Name = TabConfig.Name or "Tab"
        TabConfig.Icon = TabConfig.Icon or ""

        local ScrolLayers = Instance.new("ScrollingFrame");
        local UIListLayout1 = Instance.new("UIListLayout");

        ScrolLayers.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
        ScrolLayers.ScrollBarThickness = 0
        ScrolLayers.Active = true
        ScrolLayers.LayoutOrder = CountTab
        ScrolLayers.BackgroundTransparency = 1
        ScrolLayers.BorderSizePixel = 0
        ScrolLayers.Size = UDim2.new(1, 0, 1, 0)
        ScrolLayers.Name = "ScrolLayers"
        ScrolLayers.Parent = LayersFolder

        UIListLayout1.Padding = UDim.new(0, 3)
        UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout1.Parent = ScrolLayers

        local Tab = Instance.new("Frame");
        local UICorner3 = Instance.new("UICorner");
        local TabButton = Instance.new("TextButton");
        local TabName = Instance.new("TextLabel")
        local FeatureImg = Instance.new("ImageLabel");
        local UIStroke2 = Instance.new("UIStroke");
        local UICorner4 = Instance.new("UICorner");

        Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        if CountTab == 0 then
            Tab.BackgroundTransparency = 0.92
        else
            Tab.BackgroundTransparency = 1
        end
        Tab.BorderColor3 = Color3.fromRGB(15, 15, 15)
        Tab.BorderSizePixel = 0
        Tab.LayoutOrder = CountTab
        Tab.Size = UDim2.new(1, 0, 0, 30)
        Tab.Name = "Tab"
        Tab.Parent = ScrollTab

        UICorner3.CornerRadius = UDim.new(0, 4)
        UICorner3.Parent = Tab

        TabButton.Font = Enum.Font.GothamBold
        TabButton.Text = ""
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.TextSize = 13
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.BackgroundTransparency = 1
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 1, 0)
        TabButton.Name = "TabButton"
        TabButton.Parent = Tab

        TabName.Font = Enum.Font.GothamBold
        TabName.Text = tostring(TabConfig.Name)
        TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabName.TextSize = 13
        TabName.TextXAlignment = Enum.TextXAlignment.Left
        TabName.BackgroundTransparency = 1
        TabName.BorderSizePixel = 0
        TabName.Size = UDim2.new(1, 0, 1, 0)
        TabName.Position = UDim2.new(0, 30, 0, 0)
        TabName.Name = "TabName"
        TabName.Parent = Tab

        FeatureImg.BackgroundTransparency = 1
        FeatureImg.BorderSizePixel = 0
        FeatureImg.Position = UDim2.new(0, 9, 0, 7)
        FeatureImg.Size = UDim2.new(0, 16, 0, 16)
        FeatureImg.Name = "FeatureImg"
        FeatureImg.Parent = Tab
        if CountTab == 0 then
            LayersPageLayout:JumpToIndex(0)
            NameTab.Text = TabConfig.Name
            local ChooseFrame = Instance.new("Frame");
            ChooseFrame.BackgroundColor3 = GuiConfig.Color
            ChooseFrame.BorderColor3 = Color3.fromRGB(15, 15, 15)
            ChooseFrame.BorderSizePixel = 0
            ChooseFrame.Position = UDim2.new(0, 2, 0, 9)
            ChooseFrame.Size = UDim2.new(0, 1, 0, 12)
            ChooseFrame.Name = "ChooseFrame"
            ChooseFrame.Parent = Tab

            UIStroke2.Color = GuiConfig.Color
            UIStroke2.Thickness = 1.6
            UIStroke2.Parent = ChooseFrame

            UICorner4.Parent = ChooseFrame
        end

        if TabConfig.Icon ~= "" then
            ApplyIcon(FeatureImg, TabConfig.Icon, 24)
        end

        local switchToken = 0
        local function switchToTab(force)
            local currentPage = LayersPageLayout.CurrentPage
            if not (force or Tab.LayoutOrder ~= currentPage.LayoutOrder) then return end
            local token = switchToken + 1
            switchToken = token

            local FrameChoose
            for _, s in ScrollTab:GetChildren() do
                for _, v in s:GetChildren() do
                    if v.Name == "ChooseFrame" then
                        FrameChoose = v
                        break
                    end
                end
            end
            if FrameChoose == nil then return end

            for _, TabFrame in ScrollTab:GetChildren() do
                if TabFrame.Name == "Tab" and token == switchToken then
                    TweenService:Create(
                        TabFrame,
                        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
                        { BackgroundTransparency = 1 }
                    ):Play()
                end
            end
            if token ~= switchToken then return end

            TweenService:Create(
                Tab,
                TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
                { BackgroundTransparency = 0.92 }
            ):Play()
            TweenService:Create(
                FrameChoose,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                { Position = UDim2.new(0, 2, 0, 9 + (33 * Tab.LayoutOrder)) }
            ):Play()
            LayersPageLayout:JumpToIndex(Tab.LayoutOrder)
            task.wait(0.05)
            if token ~= switchToken then return end
            NameTab.Text = TabConfig.Name
            TweenService:Create(
                FrameChoose,
                TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                { Size = UDim2.new(0, 1, 0, 20) }
            ):Play()
            task.wait(0.2)
            if token ~= switchToken then return end
            TweenService:Create(
                FrameChoose,
                TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                { Size = UDim2.new(0, 1, 0, 12) }
            ):Play()
        end

        TabButton.Activated:Connect(function()
            CircleClick(TabButton, Mouse.X, Mouse.Y)
            switchToTab(false)
        end)

        local function SearchSwitch()
            if SearchResults then
                SearchResults.Visible = false
                ScrollTab.Visible = true
            end
            switchToTab(true)
        end

        TabRegistry[TabConfig.Name] = SearchSwitch
        RegisterSearch({ label = TabConfig.Name, tab = TabConfig.Name, kind = "Tab", switch = SearchSwitch })
        local Sections = {}
        local CountSection = 0
        function Sections:AddSection(Title, AlwaysOpen)
            local Title = Title or "Title"
            local Section = Instance.new("Frame");
            local SectionDecideFrame = Instance.new("Frame");
            local UICorner1 = Instance.new("UICorner");
            local UIGradient = Instance.new("UIGradient");

            Section.BackgroundTransparency = 1
            Section.BorderSizePixel = 0
            Section.LayoutOrder = CountSection
            Section.ClipsDescendants = true
            Section.LayoutOrder = 1
            Section.Size = UDim2.new(1, 0, 0, 30)
            Section.Name = "Section"
            Section.Parent = ScrolLayers

            local SectionReal = Instance.new("Frame");
            local UICorner = Instance.new("UICorner");
            local UIStroke = Instance.new("UIStroke");
            local SectionButton = Instance.new("TextButton");
            local FeatureFrame = Instance.new("Frame");
            local FeatureImg = Instance.new("ImageLabel");
            local SectionTitle = Instance.new("TextLabel");

            SectionReal.AnchorPoint = Vector2.new(0.5, 0)
            SectionReal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SectionReal.BackgroundTransparency = 0.935
            SectionReal.BorderColor3 = Color3.fromRGB(15, 15, 15)
            SectionReal.BorderSizePixel = 0
            SectionReal.LayoutOrder = 1
            SectionReal.Position = UDim2.new(0.5, 0, 0, 0)
            SectionReal.Size = UDim2.new(1, 1, 0, 30)
            SectionReal.Name = "SectionReal"
            SectionReal.Parent = Section

            UICorner.CornerRadius = UDim.new(0, 4)
            UICorner.Parent = SectionReal

            SectionButton.Font = Enum.Font.SourceSans
            SectionButton.Text = ""
            SectionButton.TextColor3 = Color3.fromRGB(15, 15, 15)
            SectionButton.TextSize = 14
            SectionButton.BackgroundTransparency = 1
            SectionButton.BorderSizePixel = 0
            SectionButton.Size = UDim2.new(1, 0, 1, 0)
            SectionButton.Name = "SectionButton"
            SectionButton.Parent = SectionReal

            FeatureFrame.AnchorPoint = Vector2.new(1, 0.5)
            FeatureFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            FeatureFrame.BackgroundTransparency = 1
            FeatureFrame.BorderSizePixel = 0
            FeatureFrame.Position = UDim2.new(1, -5, 0.5, 0)
            FeatureFrame.Size = UDim2.new(0, 20, 0, 20)
            FeatureFrame.Name = "FeatureFrame"
            FeatureFrame.Parent = SectionReal

            FeatureImg.Image = "rbxassetid://16851841101"
            FeatureImg.AnchorPoint = Vector2.new(0.5, 0.5)
            FeatureImg.BackgroundTransparency = 1
            FeatureImg.BorderSizePixel = 0
            FeatureImg.Position = UDim2.new(0.5, 0, 0.5, 0)
            FeatureImg.Rotation = -90
            FeatureImg.Size = UDim2.new(1, 6, 1, 6)
            FeatureImg.Name = "FeatureImg"
            FeatureImg.Parent = FeatureFrame

            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = Title
            SectionTitle.TextColor3 = Color3.fromRGB(231, 231, 231)
            SectionTitle.TextSize = 13
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.TextYAlignment = Enum.TextYAlignment.Top
            SectionTitle.AnchorPoint = Vector2.new(0, 0.5)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.BorderSizePixel = 0
            SectionTitle.Position = UDim2.new(0, 10, 0.5, 0)
            SectionTitle.Size = UDim2.new(1, -50, 0, 13)
            SectionTitle.Name = "SectionTitle"
            SectionTitle.Parent = SectionReal

            SectionDecideFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SectionDecideFrame.BorderColor3 = Color3.fromRGB(15, 15, 15)
            SectionDecideFrame.AnchorPoint = Vector2.new(0.5, 0)
            SectionDecideFrame.BorderSizePixel = 0
            SectionDecideFrame.Position = UDim2.new(0.5, 0, 0, 33)
            SectionDecideFrame.Size = UDim2.new(0, 0, 0, 2)
            SectionDecideFrame.Name = "SectionDecideFrame"
            SectionDecideFrame.Parent = Section

            UICorner1.Parent = SectionDecideFrame

            UIGradient.Color = ColorSequence.new {
                ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 22)),
                ColorSequenceKeypoint.new(0.5, GuiConfig.Color),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 22))
            }
            UIGradient.Parent = SectionDecideFrame

            local SectionAdd = Instance.new("Frame");
            local UICorner8 = Instance.new("UICorner");
            local UIListLayout2 = Instance.new("UIListLayout");

            SectionAdd.AnchorPoint = Vector2.new(0.5, 0)
            SectionAdd.BackgroundTransparency = 1
            SectionAdd.BorderSizePixel = 0
            SectionAdd.ClipsDescendants = true
            SectionAdd.LayoutOrder = 1
            SectionAdd.Position = UDim2.new(0.5, 0, 0, 38)
            SectionAdd.Size = UDim2.new(1, 0, 0, 100)
            SectionAdd.Name = "SectionAdd"
            SectionAdd.Parent = Section

            UICorner8.CornerRadius = UDim.new(0, 2)
            UICorner8.Parent = SectionAdd

            UIListLayout2.Padding = UDim.new(0, 3)
            UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout2.Parent = SectionAdd

            local OpenSection = false
            local SectionHandle = { open = false }
            local scrollUpdatePending = false
            local function UpdateSizeScroll()
                if scrollUpdatePending then return end
                scrollUpdatePending = true
                task.defer(function()
                    scrollUpdatePending = false
                    local OffsetY = 0
                    for _, child in ScrolLayers:GetChildren() do
                        if child.Name ~= "UIListLayout" then
                            OffsetY = OffsetY + 3 + child.Size.Y.Offset
                        end
                    end
                    ScrolLayers.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
                end)
            end

            local sectionUpdatePending = false
            local function UpdateSizeSection()
                if not OpenSection then return end
                if sectionUpdatePending then return end
                sectionUpdatePending = true
                task.defer(function()
                    sectionUpdatePending = false
                    if not OpenSection then return end

                    local sectionContentH = 38
                    for _, v in SectionAdd:GetChildren() do
                        if v.Name ~= "UIListLayout" and v.Name ~= "UICorner" then
                            sectionContentH = sectionContentH + v.Size.Y.Offset + 3
                        end
                    end

                    if math.abs(Section.Size.Y.Offset - sectionContentH) <= 1 then
                        Section.Size = UDim2.new(1, 1, 0, sectionContentH)
                        SectionAdd.Size = UDim2.new(1, 0, 0, sectionContentH - 38)
                        UpdateSizeScroll()
                        return
                    end

                    pcall(function()
                        TweenService:Create(FeatureFrame, TweenInfo.new(0.5), { Rotation = 90 }):Play()
                        TweenService:Create(Section, TweenInfo.new(0.5), { Size = UDim2.new(1, 1, 0, sectionContentH) })
                            :Play()
                        TweenService:Create(SectionAdd, TweenInfo.new(0.5),
                            { Size = UDim2.new(1, 0, 0, sectionContentH - 38) }):Play()
                        TweenService:Create(SectionDecideFrame, TweenInfo.new(0.5), { Size = UDim2.new(1, 0, 0, 2) })
                            :Play()
                    end)
                    task.delay(0.5, UpdateSizeScroll)
                end)
            end

            if AlwaysOpen == true then
                SectionButton:Destroy()
                FeatureFrame:Destroy()
                OpenSection = true
                UpdateSizeSection()
            elseif AlwaysOpen == false then
                OpenSection = true
                UpdateSizeSection()
            else
                OpenSection = false
            end

            if AlwaysOpen ~= true then
                SectionButton.Activated:Connect(function()
                    CircleClick(SectionButton, Mouse.X, Mouse.Y)
                    if OpenSection then
                        TweenService:Create(FeatureFrame, TweenInfo.new(0.5), { Rotation = 0 }):Play()
                        TweenService:Create(Section, TweenInfo.new(0.5), { Size = UDim2.new(1, 1, 0, 30) }):Play()
                        TweenService:Create(SectionDecideFrame, TweenInfo.new(0.5), { Size = UDim2.new(0, 0, 0, 2) })
                            :Play()
                        OpenSection = false
                        SectionHandle.open = false
                        task.delay(0.5, UpdateSizeScroll)
                    else
                        OpenSection = true
                        SectionHandle.open = true
                        UpdateSizeSection()
                    end
                end)
            end

            if AlwaysOpen == true or AlwaysOpen == false then
                OpenSection = true
                SectionHandle.open = true
                local sectionContentH = 38
                for _, v in SectionAdd:GetChildren() do
                    if v.Name ~= "UIListLayout" and v.Name ~= "UICorner" then
                        sectionContentH = sectionContentH + v.Size.Y.Offset + 3
                    end
                end
                FeatureFrame.Rotation = 90
                Section.Size = UDim2.new(1, 1, 0, sectionContentH)
                SectionAdd.Size = UDim2.new(1, 0, 0, sectionContentH - 38)
                SectionDecideFrame.Size = UDim2.new(1, 0, 0, 2)
                UpdateSizeScroll()
            end

            SectionAdd.ChildAdded:Connect(UpdateSizeSection)
            SectionAdd.ChildRemoved:Connect(UpdateSizeSection)

            local layout = ScrolLayers:FindFirstChildOfClass("UIListLayout")
            if layout then
                layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    ScrolLayers.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
                end)
            end

            local function BuildItemsAPI(SectionAdd)
            local Items = {}
            local CountItem = 0

            function Items:AddParagraph(ParagraphConfig)
                local ParagraphConfig = ParagraphConfig or {}
                ParagraphConfig.Title = ParagraphConfig.Title or "Title"
                ParagraphConfig.Content = ParagraphConfig.Content or "Content"
                local ParagraphFunc = {}

                local Paragraph = Instance.new("Frame")
                local UICorner14 = Instance.new("UICorner")
                local ParagraphTitle = Instance.new("TextLabel")
                local ParagraphContent = Instance.new("TextLabel")

                Paragraph.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Paragraph.BackgroundTransparency = 0.935
                Paragraph.BorderSizePixel = 0
                Paragraph.LayoutOrder = CountItem
                Paragraph.Size = UDim2.new(1, 0, 0, 46)
                Paragraph.Name = "Paragraph"
                Paragraph.Parent = SectionAdd

                UICorner14.CornerRadius = UDim.new(0, 4)
                UICorner14.Parent = Paragraph

                local iconOffset = 10
                if ParagraphConfig.Icon then
                    local IconImg = Instance.new("ImageLabel")
                    IconImg.Size = UDim2.new(0, 20, 0, 20)
                    IconImg.Position = UDim2.new(0, 8, 0, 12)
                    IconImg.BackgroundTransparency = 1
                    IconImg.Name = "ParagraphIcon"
                    IconImg.Parent = Paragraph

                    ApplyIcon(IconImg, ParagraphConfig.Icon, 24)

                    iconOffset = 30
                end

                ParagraphTitle.Font = Enum.Font.GothamBold
                ParagraphTitle.Text = ParagraphConfig.Title
                ParagraphTitle.TextColor3 = Color3.fromRGB(231, 231, 231)
                ParagraphTitle.TextSize = 13
                ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
                ParagraphTitle.TextYAlignment = Enum.TextYAlignment.Top
                ParagraphTitle.BackgroundTransparency = 1
                ParagraphTitle.Position = UDim2.new(0, iconOffset, 0, 10)
                ParagraphTitle.Size = UDim2.new(1, -16, 0, 13)
                ParagraphTitle.Name = "ParagraphTitle"
                ParagraphTitle.Parent = Paragraph

                ParagraphContent.Font = Enum.Font.Gotham
                ParagraphContent.Text = ParagraphConfig.Content
                ParagraphContent.TextColor3 = Color3.fromRGB(255, 255, 255)
                ParagraphContent.TextSize = 12
                ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
                ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
                ParagraphContent.BackgroundTransparency = 1
                ParagraphContent.Position = UDim2.new(0, iconOffset, 0, 25)
                ParagraphContent.Name = "ParagraphContent"
                ParagraphContent.TextWrapped = true
                ParagraphContent.RichText = true
                
                ParagraphContent.AutomaticSize = Enum.AutomaticSize.None
                ParagraphContent.Size = UDim2.new(1, -(iconOffset + 10), 0, 14)
                ParagraphContent.Parent = Paragraph

                local TextService = game:GetService("TextService")

                local paragraphPending = false
                local lastParagraphText = ""
                local lastParagraphWidth = -1

                local function UpdateSize()
                    task.wait() 
                    local maxWidth = Paragraph.AbsoluteSize.X - (iconOffset + 10) - 10
                    if maxWidth <= 0 then maxWidth = 200 end 

                    if maxWidth == lastParagraphWidth and ParagraphContent.Text == lastParagraphText then
                        return
                    end

                    
                    local ok, bounds = pcall(function()
                        return TextService:GetTextSize(
                            ParagraphContent.Text, 
                            12, 
                            Enum.Font.Gotham, 
                            Vector2.new(maxWidth, math.huge)
                        )
                    end)

                    local contentHeight = (ok and bounds and bounds.Y) or 14
                    if contentHeight < 14 then contentHeight = 14 end

                    local buttonHeight = 0
                    if ParagraphButton then
                        buttonHeight = ParagraphButton.Size.Y.Offset + 5
                        ParagraphButton.Position = UDim2.new(0, 10, 0, contentHeight + 28)
                    end

                    local totalHeight = contentHeight + 33 + buttonHeight

                    ParagraphContent.Size = UDim2.new(1, -(iconOffset + 10), 0, contentHeight)
                    
                    if Paragraph.Size.Y.Offset ~= totalHeight then
                        Paragraph.Size = UDim2.new(1, 0, 0, totalHeight)
                        if UpdateSizeSection then UpdateSizeSection() end
                    end

                    lastParagraphText = ParagraphContent.Text
                    lastParagraphWidth = maxWidth
                end

                local function QueueParagraphResize()
                    if paragraphPending then return end
                    paragraphPending = true
                    task.defer(function()
                        paragraphPending = false
                        UpdateSize()
                    end)
                end

                ParagraphContent:GetPropertyChangedSignal("TextBounds"):Connect(QueueParagraphResize)
                
                task.spawn(QueueParagraphResize)

                function ParagraphFunc:SetContent(content)
                    content = content or "Content"
                    ParagraphContent.Text = content
                    QueueParagraphResize()
                end

                CountItem = CountItem + 1
                RegisterSearch({ label = ParagraphConfig.Title, tab = TabConfig.Name, kind = "Info", section = self, switch = SearchSwitch })
                return ParagraphFunc
            end

            function Items:AddPanel(PanelConfig)
                PanelConfig = PanelConfig or {}
                PanelConfig.Title = PanelConfig.Title or "Title"
                PanelConfig.Content = PanelConfig.Content or ""
                PanelConfig.Placeholder = PanelConfig.Placeholder or nil
                PanelConfig.Default = PanelConfig.Default or ""
                PanelConfig.ButtonText = PanelConfig.Button or PanelConfig.ButtonText or "Confirm"
                PanelConfig.ButtonCallback = PanelConfig.Callback or PanelConfig.ButtonCallback or function() end
                PanelConfig.SubButtonText = PanelConfig.SubButton or PanelConfig.SubButtonText or nil
                PanelConfig.SubButtonCallback = PanelConfig.SubCallback or PanelConfig.SubButtonCallback or
                    function() end

                local configKey = "Panel_" .. PanelConfig.Title
                local shouldSave = PanelConfig.Save ~= false
                if shouldSave and ConfigData[configKey] ~= nil then
                    PanelConfig.Default = ConfigData[configKey]
                end

                local PanelFunc = { Value = PanelConfig.Default }

                local baseHeight = 50

                if PanelConfig.Placeholder then
                    baseHeight = baseHeight + 40
                end

                if PanelConfig.SubButtonText then
                    baseHeight = baseHeight + 40
                else
                    baseHeight = baseHeight + 36
                end

                local Panel = Instance.new("Frame")
                Panel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Panel.BackgroundTransparency = 0.935
                Panel.Size = UDim2.new(1, 0, 0, baseHeight)
                Panel.LayoutOrder = CountItem
                Panel.Parent = SectionAdd

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = Panel

                local Title = Instance.new("TextLabel")
                Title.Font = Enum.Font.GothamBold
                Title.Text = PanelConfig.Title
                Title.TextSize = 13
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.BackgroundTransparency = 1
                Title.Position = UDim2.new(0, 10, 0, 10)
                Title.Size = UDim2.new(1, -20, 0, 13)
                Title.Parent = Panel

                local Content = Instance.new("TextLabel")
                Content.Font = Enum.Font.Gotham
                Content.Text = PanelConfig.Content
                Content.TextSize = 12
                Content.TextColor3 = Color3.fromRGB(255, 255, 255)
                Content.TextTransparency = 0
                Content.TextXAlignment = Enum.TextXAlignment.Left
                Content.BackgroundTransparency = 1
                Content.RichText = true
                Content.Position = UDim2.new(0, 10, 0, 28)
                Content.Size = UDim2.new(1, -20, 0, 14)
                Content.Parent = Panel

                local InputBox
                if PanelConfig.Placeholder then
                    local InputFrame = Instance.new("Frame")
                    InputFrame.AnchorPoint = Vector2.new(0.5, 0)
                    InputFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    InputFrame.BackgroundTransparency = 0.95
                    InputFrame.Position = UDim2.new(0.5, 0, 0, 48)
                    InputFrame.Size = UDim2.new(1, -20, 0, 30)
                    InputFrame.Parent = Panel

                    local inputCorner = Instance.new("UICorner")
                    inputCorner.CornerRadius = UDim.new(0, 4)
                    inputCorner.Parent = InputFrame

                    InputBox = Instance.new("TextBox")
                    InputBox.Font = Enum.Font.GothamBold
                    InputBox.PlaceholderText = PanelConfig.Placeholder
                    InputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
                    InputBox.Text = PanelConfig.Default
                    InputBox.TextSize = 11
                    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                    InputBox.BackgroundTransparency = 1
                    InputBox.TextXAlignment = Enum.TextXAlignment.Left
                    InputBox.Size = UDim2.new(1, -10, 1, -6)
                    InputBox.Position = UDim2.new(0, 5, 0, 3)
                    InputBox.Parent = InputFrame
                end

                local yBtn = 0
                if PanelConfig.Placeholder then
                    yBtn = 88
                else
                    yBtn = 48
                end

                local ButtonMain = Instance.new("TextButton")
                ButtonMain.Font = Enum.Font.GothamBold
                ButtonMain.Text = PanelConfig.ButtonText
                ButtonMain.TextColor3 = Color3.fromRGB(255, 255, 255)
                ButtonMain.TextSize = 12
                ButtonMain.TextTransparency = 0.3
                ButtonMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ButtonMain.BackgroundTransparency = 0.935
                ButtonMain.Size = PanelConfig.SubButtonText and UDim2.new(0.5, -12, 0, 30) or UDim2.new(1, -20, 0, 30)
                ButtonMain.Position = UDim2.new(0, 10, 0, yBtn)
                ButtonMain.Parent = Panel

                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 6)
                btnCorner.Parent = ButtonMain

                ButtonMain.MouseButton1Click:Connect(function()
                    PanelConfig.ButtonCallback(InputBox and InputBox.Text or "")
                end)

                if PanelConfig.SubButtonText then
                    local SubButton = Instance.new("TextButton")
                    SubButton.Font = Enum.Font.GothamBold
                    SubButton.Text = PanelConfig.SubButtonText
                    SubButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    SubButton.TextSize = 12
                    SubButton.TextTransparency = 0.3
                    SubButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    SubButton.BackgroundTransparency = 0.935
                    SubButton.Size = UDim2.new(0.5, -12, 0, 30)
                    SubButton.Position = UDim2.new(0.5, 2, 0, yBtn)
                    SubButton.Parent = Panel

                    local subCorner = Instance.new("UICorner")
                    subCorner.CornerRadius = UDim.new(0, 6)
                    subCorner.Parent = SubButton

                    SubButton.MouseButton1Click:Connect(function()
                        PanelConfig.SubButtonCallback(InputBox and InputBox.Text or "")
                    end)
                end

                if InputBox then
                    InputBox.FocusLost:Connect(function()
                        PanelFunc:Set(InputBox.Text)
                    end)
                end

                function PanelFunc:Set(Value, noSave)
                    Value = tostring(Value or "")
                    PanelFunc.Value = Value
                    if shouldSave then
                        ConfigData[configKey] = Value
                    end
                    if InputBox then
                        InputBox.Text = Value
                    end
                    if shouldSave and not noSave then QueueSaveConfig() end
                end

                function PanelFunc:GetInput()
                    return InputBox and InputBox.Text or ""
                end

                PanelFunc:Set(PanelFunc.Value, true)
                CountItem = CountItem + 1
                if shouldSave then
                    Elements[configKey] = PanelFunc
                end
                return PanelFunc
            end

            function Items:AddButton(ButtonConfig)
                ButtonConfig = ButtonConfig or {}
                ButtonConfig.Title = ButtonConfig.Title or "Confirm"
                ButtonConfig.Callback = ButtonConfig.Callback or function() end
                ButtonConfig.SubTitle = ButtonConfig.SubTitle or nil
                ButtonConfig.SubCallback = ButtonConfig.SubCallback or function() end

                local Button = Instance.new("Frame")
                Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Button.BackgroundTransparency = 0.935
                Button.Size = UDim2.new(1, 0, 0, 40)
                Button.LayoutOrder = CountItem
                Button.Parent = SectionAdd

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = Button

                local MainButton = Instance.new("TextButton")
                MainButton.Font = Enum.Font.GothamBold
                MainButton.Text = ButtonConfig.Title
                MainButton.TextSize = 12
                MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                MainButton.TextTransparency = 0.3
                MainButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                MainButton.BackgroundTransparency = 0.935
                MainButton.Size = ButtonConfig.SubTitle and UDim2.new(0.5, -8, 1, -10) or UDim2.new(1, -12, 1, -10)
                MainButton.Position = UDim2.new(0, 6, 0, 5)
                MainButton.Parent = Button

                local mainCorner = Instance.new("UICorner")
                mainCorner.CornerRadius = UDim.new(0, 4)
                mainCorner.Parent = MainButton

                MainButton.MouseButton1Click:Connect(ButtonConfig.Callback)

                if ButtonConfig.SubTitle then
                    local SubButton = Instance.new("TextButton")
                    SubButton.Font = Enum.Font.GothamBold
                    SubButton.Text = ButtonConfig.SubTitle
                    SubButton.TextSize = 12
                    SubButton.TextTransparency = 0.3
                    SubButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    SubButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    SubButton.BackgroundTransparency = 0.935
                    SubButton.Size = UDim2.new(0.5, -8, 1, -10)
                    SubButton.Position = UDim2.new(0.5, 2, 0, 5)
                    SubButton.Parent = Button

                    local subCorner = Instance.new("UICorner")
                    subCorner.CornerRadius = UDim.new(0, 4)
                    subCorner.Parent = SubButton

                    SubButton.MouseButton1Click:Connect(ButtonConfig.SubCallback)
                end

                CountItem = CountItem + 1
                RegisterSearch({ label = ButtonConfig.Title, tab = TabConfig.Name, kind = "Button", section = self, switch = SearchSwitch })
            end

            function Items:AddToggle(ToggleConfig)
                local ToggleConfig = ToggleConfig or {}
                ToggleConfig.Title = ToggleConfig.Title or "Title"
                ToggleConfig.Title2 = ToggleConfig.Title2 or ""
                ToggleConfig.Content = ToggleConfig.Content or ""
                ToggleConfig.Default = ToggleConfig.Default or false
                ToggleConfig.Callback = ToggleConfig.Callback or function() end
                ToggleConfig.Keybind = ToggleConfig.Keybind or Enum.KeyCode.Unknown
                ToggleConfig.KeybindSave = ToggleConfig.KeybindSave ~= false

                local configKey = "Toggle_" .. ToggleConfig.Title
                local shouldSave = ToggleConfig.Save ~= false
                if shouldSave and ConfigData[configKey] ~= nil then
                    ToggleConfig.Default = ConfigData[configKey]
                end

                local keybindConfigKey = "ToggleKeybind_" .. ToggleConfig.Title
                local shouldSaveKeybind = ToggleConfig.KeybindSave
                if shouldSaveKeybind and ConfigData[keybindConfigKey] ~= nil then
                    local ok, kc = pcall(function()
                        return Enum.KeyCode[ConfigData[keybindConfigKey]]
                    end)
                    if ok and kc then ToggleConfig.Keybind = kc end
                end

                local ToggleFunc = { Value = ToggleConfig.Default }

                local titleMargin = isMobile and 100 or 150

                local Toggle = Instance.new("Frame")
                local UICorner20 = Instance.new("UICorner")
                local ToggleTitle = Instance.new("TextLabel")
                local ToggleContent = Instance.new("TextLabel")
                local ToggleButton = Instance.new("TextButton")
                local FeatureFrame2 = Instance.new("Frame")
                local UICorner22 = Instance.new("UICorner")
                local UIStroke8 = Instance.new("UIStroke")
                local ToggleCircle = Instance.new("Frame")
                local UICorner23 = Instance.new("UICorner")

                Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Toggle.BackgroundTransparency = 0.935
                Toggle.BorderSizePixel = 0
                Toggle.LayoutOrder = CountItem
                Toggle.Name = "Toggle"
                Toggle.Parent = SectionAdd

                UICorner20.CornerRadius = UDim.new(0, 4)
                UICorner20.Parent = Toggle

                ToggleTitle.Font = Enum.Font.GothamBold
                ToggleTitle.Text = ToggleConfig.Title
                ToggleTitle.TextSize = 13
                ToggleTitle.TextColor3 = Color3.fromRGB(231, 231, 231)
                ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
                ToggleTitle.TextYAlignment = Enum.TextYAlignment.Top
                ToggleTitle.BackgroundTransparency = 1
                ToggleTitle.Position = UDim2.new(0, 10, 0, 10)
                ToggleTitle.Size = UDim2.new(1, -titleMargin, 0, 13)
                ToggleTitle.Name = "ToggleTitle"
                ToggleTitle.Parent = Toggle

                local ToggleTitle2 = Instance.new("TextLabel")
                ToggleTitle2.Font = Enum.Font.GothamBold
                ToggleTitle2.Text = ToggleConfig.Title2
                ToggleTitle2.TextSize = 12
                ToggleTitle2.TextColor3 = Color3.fromRGB(231, 231, 231)
                ToggleTitle2.TextXAlignment = Enum.TextXAlignment.Left
                ToggleTitle2.TextYAlignment = Enum.TextYAlignment.Top
                ToggleTitle2.BackgroundTransparency = 1
                ToggleTitle2.Position = UDim2.new(0, 10, 0, 23)
                ToggleTitle2.Size = UDim2.new(1, -titleMargin, 0, 12)
                ToggleTitle2.Name = "ToggleTitle2"
                ToggleTitle2.Parent = Toggle

                ToggleContent.Font = Enum.Font.GothamBold
                ToggleContent.Text = ToggleConfig.Content
                ToggleContent.TextColor3 = Color3.fromRGB(255, 255, 255)
                ToggleContent.TextSize = 12
                ToggleContent.TextTransparency = 0.6
                ToggleContent.TextXAlignment = Enum.TextXAlignment.Left
                ToggleContent.TextYAlignment = Enum.TextYAlignment.Bottom
                ToggleContent.BackgroundTransparency = 1
                ToggleContent.Size = UDim2.new(1, -titleMargin, 0, 12)
                ToggleContent.Name = "ToggleContent"
                ToggleContent.Parent = Toggle

                if ToggleConfig.Title2 ~= "" then
                    Toggle.Size = UDim2.new(1, 0, 0, 57)
                    ToggleContent.Position = UDim2.new(0, 10, 0, 36)
                    ToggleTitle2.Visible = true
                else
                    Toggle.Size = UDim2.new(1, 0, 0, 46)
                    ToggleContent.Position = UDim2.new(0, 10, 0, 23)
                    ToggleTitle2.Visible = false
                end

                ToggleContent.Size = UDim2.new(1, -titleMargin, 0,
                    12 + (12 * (ToggleContent.TextBounds.X // ToggleContent.AbsoluteSize.X)))
                ToggleContent.TextWrapped = true
                if ToggleConfig.Title2 ~= "" then
                    Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 47)
                else
                    Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 33)
                end

                local stayedSize = nil
                ToggleContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                    local newToggleH = ToggleContent.AbsoluteSize.Y + (ToggleConfig.Title2 ~= "" and 47 or 33)
                    if stayedSize ~= nil and math.abs(Toggle.Size.Y.Offset - newToggleH) <= 1 then
                        return
                    end

                    ToggleContent.TextWrapped = false
                    ToggleContent.Size = UDim2.new(1, -titleMargin, 0,
                        12 + (12 * (ToggleContent.TextBounds.X // ToggleContent.AbsoluteSize.X)))
                    if ToggleConfig.Title2 ~= "" then
                        Toggle.Size = UDim2.new(Toggle.Size.X.Scale, Toggle.Size.X.Offset, 0,
                            ToggleContent.AbsoluteSize.Y + 47)
                    else
                        Toggle.Size = UDim2.new(Toggle.Size.X.Scale, Toggle.Size.X.Offset, 0,
                            ToggleContent.AbsoluteSize.Y + 33)
                    end
                    ToggleContent.TextWrapped = true
                    stayedSize = Toggle.Size.Y.Offset
                    UpdateSizeSection()
                end)

                ToggleButton.Font = Enum.Font.SourceSans
                ToggleButton.Text = ""
                ToggleButton.BackgroundTransparency = 1
                ToggleButton.Size = UDim2.new(1, 0, 1, 0)
                ToggleButton.Name = "ToggleButton"
                ToggleButton.Parent = Toggle

                if not isMobile then
                local KeybindValue = ToggleConfig.Keybind
                local listening = false

                local KeyBtn = Instance.new("TextButton")
                KeyBtn.Font = Enum.Font.GothamBold
                KeyBtn.Text = KeybindValue ~= Enum.KeyCode.Unknown and KeybindValue.Name or "None"
                KeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                KeyBtn.TextSize = 12
                KeyBtn.TextWrapped = true
                KeyBtn.AutoButtonColor = false
                KeyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                KeyBtn.BackgroundTransparency = 0.2
                KeyBtn.BorderSizePixel = 0
                KeyBtn.AnchorPoint = Vector2.new(1, 0.5)
                KeyBtn.Position = UDim2.new(1, -58, 0.5, 0)
                KeyBtn.Size = UDim2.new(0, 52, 0, 28)
                KeyBtn.Name = "KeyBtn"
                KeyBtn.Parent = Toggle

                local KeyBtnCorner = Instance.new("UICorner")
                KeyBtnCorner.CornerRadius = UDim.new(0, 8)
                KeyBtnCorner.Parent = KeyBtn

                local KeyBtnStroke = Instance.new("UIStroke")
                KeyBtnStroke.Color = Color3.fromRGB(60, 60, 60)
                KeyBtnStroke.Thickness = 1
                KeyBtnStroke.Transparency = 0.2
                KeyBtnStroke.Parent = KeyBtn

                local kDefaultBg = Color3.fromRGB(35, 35, 35)
                local kDefaultBgTrans = 0.2
                local kDefaultStroke = Color3.fromRGB(60, 60, 60)
                local kDefaultText = Color3.fromRGB(200, 200, 200)
                local kHoverBg = Color3.fromRGB(45, 45, 45)
                local kHoverStroke = Color3.fromRGB(90, 90, 90)

                local function SetKeybindListening(state)
                    listening = state
                    if state then
                        KeyBtn.Text = "..."
                        TweenService:Create(KeyBtnStroke, TweenInfo.new(0.2), { Color = GuiConfig.Color, Transparency = 0 }):Play()
                        TweenService:Create(KeyBtn, TweenInfo.new(0.2), { BackgroundColor3 = GuiConfig.Color, BackgroundTransparency = 0.85 }):Play()
                        TweenService:Create(KeyBtn, TweenInfo.new(0.2), { TextColor3 = GuiConfig.Color }):Play()
                    else
                        KeyBtn.Text = KeybindValue ~= Enum.KeyCode.Unknown and KeybindValue.Name or "None"
                        TweenService:Create(KeyBtnStroke, TweenInfo.new(0.2), { Color = kDefaultStroke, Transparency = 0.2 }):Play()
                        TweenService:Create(KeyBtn, TweenInfo.new(0.2), { BackgroundColor3 = kDefaultBg, BackgroundTransparency = kDefaultBgTrans }):Play()
                        TweenService:Create(KeyBtn, TweenInfo.new(0.2), { TextColor3 = kDefaultText }):Play()
                    end
                end

                KeyBtn.MouseEnter:Connect(function()
                    if not listening then
                        TweenService:Create(KeyBtn, TweenInfo.new(0.15), { BackgroundColor3 = kHoverBg }):Play()
                        TweenService:Create(KeyBtnStroke, TweenInfo.new(0.15), { Color = kHoverStroke }):Play()
                    end
                end)

                KeyBtn.MouseLeave:Connect(function()
                    if not listening then
                        TweenService:Create(KeyBtn, TweenInfo.new(0.15), { BackgroundColor3 = kDefaultBg, BackgroundTransparency = kDefaultBgTrans }):Play()
                        TweenService:Create(KeyBtnStroke, TweenInfo.new(0.15), { Color = kDefaultStroke, Transparency = 0.2 }):Play()
                    end
                end)

                KeyBtn.MouseButton1Click:Connect(function()
                    SetKeybindListening(not listening)
                end)

                UserInputService.InputBegan:Connect(function(input, gpe)
                    if not listening then
                        if gpe then return end
                        if KeybindValue == Enum.KeyCode.Unknown then return end
                        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
                        if input.KeyCode == KeybindValue then
                            ToggleFunc.Value = not ToggleFunc.Value
                            ToggleFunc:Set(ToggleFunc.Value)
                        end
                        return
                    end
                    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
                    if input.KeyCode == Enum.KeyCode.Escape then
                        SetKeybindListening(false)
                        return
                    end
                    KeybindValue = input.KeyCode
                    KeyBtn.Text = KeybindValue.Name
                    if shouldSaveKeybind then
                        ConfigData[keybindConfigKey] = KeybindValue.Name
                        QueueSaveConfig()
                    end
                    SetKeybindListening(false)
                end)

                function ToggleFunc:SetKeybind(kc, noSave)
                    if type(kc) == "string" then
                        local ok, converted = pcall(function()
                            return Enum.KeyCode[kc]
                        end)
                        kc = (ok and converted) or Enum.KeyCode.Unknown
                    end
                    kc = kc or Enum.KeyCode.Unknown
                    KeybindValue = kc
                    KeyBtn.Text = KeybindValue ~= Enum.KeyCode.Unknown and KeybindValue.Name or "None"
                    if shouldSaveKeybind then
                        ConfigData[keybindConfigKey] = KeybindValue ~= Enum.KeyCode.Unknown and KeybindValue.Name or "None"
                        if not noSave then QueueSaveConfig() end
                    end
                end
                end

                FeatureFrame2.AnchorPoint = Vector2.new(1, 0.5)
                FeatureFrame2.BackgroundColor3 = Color3.fromRGB(58, 58, 66)
                FeatureFrame2.BackgroundTransparency = 0.25
                FeatureFrame2.BorderSizePixel = 0
                FeatureFrame2.Position = UDim2.new(1, -15, 0.5, 0)
                FeatureFrame2.Size = UDim2.new(0, 36, 0, 20)
                FeatureFrame2.Name = "FeatureFrame"
                FeatureFrame2.Parent = Toggle

                UICorner22.Parent = FeatureFrame2
                UICorner22.CornerRadius = UDim.new(1, 0)

                UIStroke8.Color = THEME.border
                UIStroke8.Thickness = 1
                UIStroke8.Transparency = 0
                UIStroke8.Parent = FeatureFrame2

                ToggleCircle.BackgroundColor3 = Color3.fromRGB(190, 192, 200)
                ToggleCircle.BorderSizePixel = 0
                ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
                ToggleCircle.Position = UDim2.new(0, 3, 0.5, 0)
                ToggleCircle.Size = UDim2.new(0, 14, 0, 14)
                ToggleCircle.Name = "ToggleCircle"
                ToggleCircle.Parent = FeatureFrame2

                UICorner23.CornerRadius = UDim.new(1, 0)
                UICorner23.Parent = ToggleCircle

                ToggleButton.Activated:Connect(function()
                    ToggleFunc.Value = not ToggleFunc.Value
                    ToggleFunc:Set(ToggleFunc.Value)
                end)

                function ToggleFunc:Set(Value, noSave)
                    Value = Value and true or false
                    ToggleFunc.Value = Value
                    if typeof(ToggleConfig.Callback) == "function" then
                        local ok, err = pcall(function()
                            ToggleConfig.Callback(Value)
                        end)
                        if not ok then warn("Toggle Callback error:", err) end
                    end
                    if shouldSave then
                        ConfigData[configKey] = Value
                        if not noSave then QueueSaveConfig() end
                    end
                    if Value then
                        TweenService:Create(ToggleTitle, TweenInfo.new(0.2), { TextColor3 = GuiConfig.Color }):Play()
                        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                            Position = UDim2.new(0, 19, 0.5, 0),
                            BackgroundColor3 = GuiConfig.Color,
                        }):Play()
                        TweenService:Create(UIStroke8, TweenInfo.new(0.2), {
                            Color = GuiConfig.Color,
                            Thickness = 1.5,
                            Transparency = 0,
                        }):Play()
                        TweenService:Create(FeatureFrame2, TweenInfo.new(0.2), {
                            BackgroundColor3 = GuiConfig.Color,
                            BackgroundTransparency = 0.7,
                        }):Play()
                    else
                        TweenService:Create(ToggleTitle, TweenInfo.new(0.2),
                            { TextColor3 = Color3.fromRGB(230, 230, 230) }):Play()
                        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                            Position = UDim2.new(0, 3, 0.5, 0),
                            BackgroundColor3 = Color3.fromRGB(190, 192, 200),
                        }):Play()
                        TweenService:Create(UIStroke8, TweenInfo.new(0.2), { Color = THEME.border, Transparency = 0 })
                            :Play()
                        TweenService:Create(FeatureFrame2, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(58, 58, 66),
                            BackgroundTransparency = 0.25,
                        }):Play()
                    end
                end

                ToggleFunc:Set(ToggleFunc.Value, true)
                if not isMobile then
                    ToggleFunc:SetKeybind(ToggleConfig.Keybind, true)
                end
                CountItem = CountItem + 1
                if shouldSave then
                    Elements[configKey] = ToggleFunc
                end
                RegisterSearch({ label = ToggleConfig.Title, tab = TabConfig.Name, kind = "Toggle", element = ToggleFunc, section = self, switch = SearchSwitch })
                return ToggleFunc
            end

            function Items:AddSlider(SliderConfig)
                local SliderConfig = SliderConfig or {}
                SliderConfig.Title = SliderConfig.Title or "Slider"
                SliderConfig.Content = SliderConfig.Content or ""
                SliderConfig.Min = tonumber(SliderConfig.Min) or 0
                SliderConfig.Max = tonumber(SliderConfig.Max) or 100
                if SliderConfig.Max < SliderConfig.Min then
                    SliderConfig.Min, SliderConfig.Max = SliderConfig.Max, SliderConfig.Min
                end
                SliderConfig.Default = tonumber(SliderConfig.Default) or SliderConfig.Min
                SliderConfig.Increment = tonumber(SliderConfig.Increment or SliderConfig.Step) or 1
                local sliderSpan = SliderConfig.Max - SliderConfig.Min
                if SliderConfig.Increment <= 0 then
                    SliderConfig.Increment = sliderSpan >= 1 and 1 or (sliderSpan > 0 and math.max(sliderSpan / 100, 0.01) or 1)
                elseif sliderSpan > 0 and SliderConfig.Increment >= sliderSpan then
                    SliderConfig.Increment = sliderSpan >= 1 and 1 or math.max(sliderSpan / 100, 0.01)
                end
                SliderConfig.Live = SliderConfig.Live == true
                SliderConfig.Callback = SliderConfig.Callback or function() end

                local configKey = "Slider_" .. SliderConfig.Title
                local shouldSave = SliderConfig.Save ~= false
                if shouldSave and ConfigData[configKey] ~= nil then
                    SliderConfig.Default = tonumber(ConfigData[configKey]) or SliderConfig.Default
                end

                local SliderFunc = { Value = SliderConfig.Default }

                local Slider = Instance.new("Frame");
                local UICorner15 = Instance.new("UICorner");
                local SliderTitle = Instance.new("TextLabel");
                local SliderContent = Instance.new("TextLabel");
                local SliderInput = Instance.new("Frame");
                local UICorner16 = Instance.new("UICorner");
                local TextBox = Instance.new("TextBox");
                local SliderFrame = Instance.new("Frame");
                local UICorner17 = Instance.new("UICorner");
                local SliderDraggable = Instance.new("Frame");
                local UICorner18 = Instance.new("UICorner");
                local UIStroke5 = Instance.new("UIStroke");
                local SliderCircle = Instance.new("Frame");
                local UICorner19 = Instance.new("UICorner");
                local UIStroke6 = Instance.new("UIStroke");
                local UIStroke7 = Instance.new("UIStroke");

                Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Slider.BackgroundTransparency = 0.935
                Slider.BorderColor3 = Color3.fromRGB(15, 15, 15)
                Slider.BorderSizePixel = 0
                Slider.LayoutOrder = CountItem
                Slider.Size = UDim2.new(1, 0, 0, 46)
                Slider.Name = "Slider"
                Slider.Parent = SectionAdd

                UICorner15.CornerRadius = UDim.new(0, 4)
                UICorner15.Parent = Slider

                SliderTitle.Font = Enum.Font.GothamBold
                SliderTitle.Text = SliderConfig.Title
                SliderTitle.TextColor3 = Color3.fromRGB(231, 231, 231)
                SliderTitle.TextSize = 13
                SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
                SliderTitle.TextYAlignment = Enum.TextYAlignment.Top
                SliderTitle.BackgroundTransparency = 1
                SliderTitle.BorderSizePixel = 0
                SliderTitle.Position = UDim2.new(0, 10, 0, 10)
                SliderTitle.Size = UDim2.new(1, -230, 0, 13)
                SliderTitle.Name = "SliderTitle"
                SliderTitle.Parent = Slider

                SliderContent.Font = Enum.Font.GothamBold
                SliderContent.Text = SliderConfig.Content
                SliderContent.TextColor3 = Color3.fromRGB(255, 255, 255)
                SliderContent.TextSize = 12
                SliderContent.TextTransparency = 0.6
                SliderContent.TextXAlignment = Enum.TextXAlignment.Left
                SliderContent.TextYAlignment = Enum.TextYAlignment.Bottom
                SliderContent.BackgroundTransparency = 1
                SliderContent.BorderSizePixel = 0
                SliderContent.Position = UDim2.new(0, 10, 0, 25)
                SliderContent.Size = UDim2.new(1, -230, 0, 12)
                SliderContent.Name = "SliderContent"
                SliderContent.Parent = Slider

                SliderContent.Size = UDim2.new(1, -230, 0,
                    12 + (12 * (SliderContent.TextBounds.X // SliderContent.AbsoluteSize.X)))
                SliderContent.TextWrapped = true
                Slider.Size = UDim2.new(1, 0, 0, SliderContent.AbsoluteSize.Y + 33)

                local sliderStayedH = nil
                SliderContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                    local newSliderH = SliderContent.AbsoluteSize.Y + 33
                    if sliderStayedH ~= nil and math.abs(Slider.Size.Y.Offset - newSliderH) <= 1 then
                        return
                    end

                    SliderContent.TextWrapped = false
                    SliderContent.Size = UDim2.new(1, -230, 0,
                        12 + (12 * (SliderContent.TextBounds.X // SliderContent.AbsoluteSize.X)))
                    Slider.Size = UDim2.new(Slider.Size.X.Scale, Slider.Size.X.Offset, 0,
                        SliderContent.AbsoluteSize.Y + 33)
                    SliderContent.TextWrapped = true
                    sliderStayedH = Slider.Size.Y.Offset
                    UpdateSizeSection()
                end)

                SliderInput.AnchorPoint = Vector2.new(0, 0.5)
                SliderInput.BackgroundColor3 = GuiConfig.Color
                SliderInput.BackgroundTransparency = 1
                SliderInput.BorderSizePixel = 0
                SliderInput.Position = UDim2.new(1, -210, 0.5, 0)
                SliderInput.Size = UDim2.new(0, 44, 0, 20)
                SliderInput.Name = "SliderInput"
                SliderInput.Parent = Slider

                UICorner16.CornerRadius = UDim.new(0, 2)
                UICorner16.Parent = SliderInput

                TextBox.Font = Enum.Font.GothamBold
                TextBox.Text = "90"
                TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextBox.TextSize = 13
                TextBox.TextWrapped = true
                TextBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                TextBox.BackgroundTransparency = 1
                TextBox.BorderSizePixel = 0
                TextBox.Position = UDim2.new(0, -1, 0, 0)
                TextBox.Size = UDim2.new(1, 0, 1, 0)
                TextBox.Parent = SliderInput

                SliderFrame.AnchorPoint = Vector2.new(1, 0.5)
                SliderFrame.BackgroundColor3 = Color3.fromRGB(60, 62, 70)
                SliderFrame.BackgroundTransparency = 0.35
                SliderFrame.BorderSizePixel = 0
                SliderFrame.Position = UDim2.new(1, -24, 0.5, 0)
                SliderFrame.Size = UDim2.new(0, 140, 0, 4)
                SliderFrame.Name = "SliderFrame"
                SliderFrame.Parent = Slider

                UICorner17.Parent = SliderFrame

                SliderDraggable.AnchorPoint = Vector2.new(0, 0.5)
                SliderDraggable.BackgroundColor3 = GuiConfig.Color
                SliderDraggable.BorderSizePixel = 0
                SliderDraggable.Position = UDim2.new(0, 0, 0.5, 0)
                SliderDraggable.Size = UDim2.new(0, 0, 0, 4)
                SliderDraggable.Name = "SliderDraggable"
                SliderDraggable.Parent = SliderFrame

                UICorner18.Parent = SliderDraggable

                SliderCircle.AnchorPoint = Vector2.new(1, 0.5)
                SliderCircle.BackgroundColor3 = GuiConfig.Color
                SliderCircle.BorderSizePixel = 0
                SliderCircle.Position = UDim2.new(1, 0, 0.5, 0)
                SliderCircle.Size = UDim2.new(0, 12, 0, 12)
                SliderCircle.Name = "SliderCircle"
                SliderCircle.Parent = SliderDraggable

                UICorner19.Parent = SliderCircle

                UIStroke6.Color = GuiConfig.Color
                UIStroke6.Thickness = 1.5
                UIStroke6.Transparency = 0.4
                UIStroke6.Parent = SliderCircle

                local SliderHitbox = Instance.new("Frame")
                SliderHitbox.AnchorPoint = Vector2.new(1, 0.5)
                SliderHitbox.BackgroundTransparency = 1
                SliderHitbox.BorderSizePixel = 0
                SliderHitbox.Position = UDim2.new(1, -24, 0.5, 0)
                SliderHitbox.Size = UDim2.new(0, 140, 0, 36)
                SliderHitbox.ZIndex = 5
                SliderHitbox.Active = true
                SliderHitbox.Name = "SliderHitbox"
                SliderHitbox.Parent = Slider

                local Dragging = false
                local UpdatingText = false

                local function Round(Number, Factor)
                    if sliderSpan <= 0 then return SliderConfig.Min end
                    local Steps = math.floor(((Number - SliderConfig.Min) / Factor) + 0.5)
                    return SliderConfig.Min + (Steps * Factor)
                end

                local function FormatValue(Value)
                    if math.abs(Value - math.floor(Value)) < 0.000001 then
                        return tostring(math.floor(Value))
                    end
                    local text = string.format("%.4f", Value)
                    text = text:gsub("0+$", ""):gsub("%.$", "")
                    return text
                end

                local function ValueScale(Value)
                    if sliderSpan <= 0 then return 0 end
                    return math.clamp((Value - SliderConfig.Min) / sliderSpan, 0, 1)
                end

                local function ApplySliderValue(Value, noSave, instant, fireCallback)
                    Value = tonumber(Value) or SliderConfig.Min
                    Value = math.clamp(Round(Value, SliderConfig.Increment), SliderConfig.Min, SliderConfig.Max)

                    SliderFunc.Value = Value
                    if shouldSave then
                        ConfigData[configKey] = Value
                    end

                    UpdatingText = true
                    TextBox.Text = FormatValue(Value)
                    UpdatingText = false

                    local targetSize = UDim2.fromScale(ValueScale(Value), 1)
                    if instant then
                        SliderDraggable.Size = targetSize
                    else
                        TweenService:Create(
                            SliderDraggable,
                            TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            { Size = targetSize }
                        ):Play()
                    end

                    if fireCallback then
                        local ok, err = pcall(function()
                            SliderConfig.Callback(Value)
                        end)
                        if not ok then warn("Slider Callback error:", err) end
                    end

                    if shouldSave and not noSave then QueueSaveConfig() end
                end

                function SliderFunc:Set(Value, noSave)
                    ApplySliderValue(Value, noSave, false, true)
                end

                local function ChangeSliderValue(Input)
                    if Input.UserInputType ~= Enum.UserInputType.MouseMovement
                        and Input.UserInputType ~= Enum.UserInputType.Touch then
                        return
                    end
                    local SizeScale = math.clamp(
                        (Input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X,
                        0,
                        1
                    )
                    ApplySliderValue(SliderConfig.Min + (sliderSpan * SizeScale), true, true, SliderConfig.Live)
                end

                local function FinishSliderDrag(Input)
                    if not Dragging then return end
                    Dragging = false
                    StopDragInput(Input)
                    ApplySliderValue(SliderFunc.Value, false, false, not SliderConfig.Live)
                    TweenService:Create(
                        SliderCircle,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        { Size = UDim2.new(0, 12, 0, 12) }
                    ):Play()
                end

                SliderHitbox.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true
                        TweenService:Create(
                            SliderCircle,
                            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            { Size = UDim2.new(0, 14, 0, 14) }
                        ):Play()
                        local SizeScale = math.clamp(
                            (Input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X,
                            0,
                            1
                        )
                        ApplySliderValue(SliderConfig.Min + (sliderSpan * SizeScale), true, true, SliderConfig.Live)
                        TrackDragInput(Input, ChangeSliderValue, FinishSliderDrag)
                    end
                end)

                TextBox.FocusLost:Connect(function()
                    if UpdatingText then return end
                    local raw = TextBox.Text:gsub(",", ".")
                    local number = tonumber(raw)
                    if number then
                        SliderFunc:Set(number)
                    else
                        TextBox.Text = FormatValue(SliderFunc.Value)
                    end
                end)
                SliderFunc:Set(SliderConfig.Default, true)
                CountItem = CountItem + 1
                if shouldSave then
                    Elements[configKey] = SliderFunc
                end
                RegisterSearch({ label = SliderConfig.Title, tab = TabConfig.Name, kind = "Slider", element = SliderFunc, section = self, switch = SearchSwitch })
                return SliderFunc
            end

            function Items:AddColorPicker(ColorConfig)
                local ColorConfig = ColorConfig or {}
                ColorConfig.Title = ColorConfig.Title or "Color"
                ColorConfig.Content = ColorConfig.Content or ""
                ColorConfig.Default = typeof(ColorConfig.Default) == "Color3" and ColorConfig.Default or Color3.fromRGB(255, 255, 255)
                ColorConfig.Callback = ColorConfig.Callback or function() end
                ColorConfig.Colors = ColorConfig.Colors or {
                    Color3.fromRGB(255, 255, 255), Color3.fromRGB(200, 200, 200), Color3.fromRGB(120, 120, 120),
                    Color3.fromRGB(40, 40, 40), Color3.fromRGB(0, 0, 0),
                    Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 85, 0), Color3.fromRGB(255, 170, 0),
                    Color3.fromRGB(255, 255, 0), Color3.fromRGB(170, 255, 0),
                    Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 255, 170), Color3.fromRGB(0, 255, 255),
                    Color3.fromRGB(0, 170, 255), Color3.fromRGB(0, 85, 255),
                    Color3.fromRGB(0, 0, 255), Color3.fromRGB(85, 0, 255), Color3.fromRGB(170, 0, 255),
                    Color3.fromRGB(255, 0, 255), Color3.fromRGB(255, 0, 170),
                    Color3.fromRGB(255, 0, 85), Color3.fromRGB(139, 69, 19), Color3.fromRGB(255, 192, 203),
                    Color3.fromRGB(0, 128, 128), Color3.fromRGB(255, 215, 0),
                }

                local configKey = "ColorPicker_" .. ColorConfig.Title
                local shouldSave = ColorConfig.Save ~= false
                if shouldSave and ConfigData[configKey] ~= nil and type(ConfigData[configKey]) == "table" then
                    local c = ConfigData[configKey]
                    ColorConfig.Default = Color3.fromRGB(tonumber(c.R) or 255, tonumber(c.G) or 255, tonumber(c.B) or 255)
                end

                local ColorFunc = { Value = ColorConfig.Default }

                local ColorPicker = Instance.new("Frame")
                ColorPicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ColorPicker.BackgroundTransparency = 0.935
                ColorPicker.BorderSizePixel = 0
                ColorPicker.LayoutOrder = CountItem
                ColorPicker.Size = UDim2.new(1, 0, 0, 46)
                ColorPicker.Name = "ColorPicker"
                ColorPicker.Parent = SectionAdd

                local PickerCorner = Instance.new("UICorner")
                PickerCorner.CornerRadius = UDim.new(0, 4)
                PickerCorner.Parent = ColorPicker

                local PickerTitle = Instance.new("TextLabel")
                PickerTitle.Font = Enum.Font.GothamBold
                PickerTitle.Text = ColorConfig.Title
                PickerTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                PickerTitle.TextSize = 13
                PickerTitle.TextXAlignment = Enum.TextXAlignment.Left
                PickerTitle.TextYAlignment = Enum.TextYAlignment.Top
                PickerTitle.BackgroundTransparency = 1
                PickerTitle.Position = UDim2.new(0, 10, 0, 10)
                PickerTitle.Size = UDim2.new(1, -70, 0, 13)
                PickerTitle.Parent = ColorPicker

                local PickerContent = Instance.new("TextLabel")
                PickerContent.Font = Enum.Font.GothamBold
                PickerContent.Text = ColorConfig.Content
                PickerContent.TextColor3 = Color3.fromRGB(255, 255, 255)
                PickerContent.TextSize = 12
                PickerContent.TextTransparency = 0.6
                PickerContent.TextXAlignment = Enum.TextXAlignment.Left
                PickerContent.TextYAlignment = Enum.TextYAlignment.Bottom
                PickerContent.BackgroundTransparency = 1
                PickerContent.Position = UDim2.new(0, 10, 0, 25)
                PickerContent.Size = UDim2.new(1, -70, 0, 12)
                PickerContent.Parent = ColorPicker

                local Swatch = Instance.new("TextButton")
                Swatch.Text = ""
                Swatch.AnchorPoint = Vector2.new(1, 0.5)
                Swatch.BackgroundColor3 = ColorConfig.Default
                Swatch.BorderSizePixel = 0
                Swatch.Position = UDim2.new(1, -10, 0.5, 0)
                Swatch.Size = UDim2.new(0, 28, 0, 18)
                Swatch.Name = "Swatch"
                Swatch.Parent = ColorPicker

                local SwatchCorner = Instance.new("UICorner")
                SwatchCorner.CornerRadius = UDim.new(0, 4)
                SwatchCorner.Parent = Swatch

                local SwatchStroke = Instance.new("UIStroke")
                SwatchStroke.Color = THEME.border
                SwatchStroke.Transparency = 0.45
                SwatchStroke.Parent = Swatch

                local function ApplyColor(color, noSave, fireCallback)
                    ColorFunc.Value = color
                    Swatch.BackgroundColor3 = color
                    if shouldSave then
                        ConfigData[configKey] = { R = math.floor(color.R * 255), G = math.floor(color.G * 255), B = math.floor(color.B * 255) }
                    end
                    if fireCallback then
                        local ok, err = pcall(function() ColorConfig.Callback(color) end)
                        if not ok then warn("ColorPicker Callback error:", err) end
                    end
                    if shouldSave and not noSave then QueueSaveConfig() end
                end

                local function OpenPalette()
                    local editH, editS, editV = ColorFunc.Value:ToHSV()
                    local editColor = ColorFunc.Value
                    local svDragging, hueDragging = false, false
                    local Connections = {}

                    local Overlay = Instance.new("Frame")
                    Overlay.Size = UDim2.new(1, 0, 1, 0)
                    Overlay.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                    Overlay.BackgroundTransparency = 0.35
                    Overlay.ZIndex = 60
                    Overlay.Name = "ColorOverlay"
                    Overlay.Parent = DropShadowHolder

                    local OverlayClose = Instance.new("TextButton")
                    OverlayClose.Text = ""
                    OverlayClose.BackgroundTransparency = 1
                    OverlayClose.Size = UDim2.new(1, 0, 1, 0)
                    OverlayClose.ZIndex = 60
                    OverlayClose.Parent = Overlay

                    local dialogWidth, dialogHeight = 300, 340

                    local Dialog = Instance.new("Frame")
                    Dialog.Size = UDim2.new(0, dialogWidth, 0, dialogHeight)
                    Dialog.Position = UDim2.new(0.5, -dialogWidth / 2, 0.5, -dialogHeight / 2)
                    Dialog.BackgroundColor3 = THEME.surface
                    Dialog.BorderSizePixel = 0
                    Dialog.ZIndex = 61
                    Dialog.Parent = Overlay

                    local DialogCorner = Instance.new("UICorner")
                    DialogCorner.CornerRadius = UDim.new(0, 10)
                    DialogCorner.Parent = Dialog

                    local DialogStroke = Instance.new("UIStroke")
                    DialogStroke.Color = THEME.border
                    DialogStroke.Transparency = 0
                    DialogStroke.Parent = Dialog

                    local DialogTitle = Instance.new("TextLabel")
                    DialogTitle.Font = Enum.Font.GothamBold
                    DialogTitle.Text = ColorConfig.Title
                    DialogTitle.TextColor3 = THEME.text
                    DialogTitle.TextSize = 15
                    DialogTitle.TextXAlignment = Enum.TextXAlignment.Left
                    DialogTitle.BackgroundTransparency = 1
                    DialogTitle.Position = UDim2.new(0, 14, 0, 12)
                    DialogTitle.Size = UDim2.new(1, -28, 0, 20)
                    DialogTitle.ZIndex = 62
                    DialogTitle.Parent = Dialog

                    local SVBox = Instance.new("Frame")
                    SVBox.Name = "SVBox"
                    SVBox.BackgroundColor3 = Color3.fromHSV(editH, 1, 1)
                    SVBox.BorderSizePixel = 0
                    SVBox.Position = UDim2.new(0, 14, 0, 40)
                    SVBox.Size = UDim2.new(0, 200, 0, 150)
                    SVBox.ZIndex = 62
                    SVBox.Parent = Dialog

                    local SVBoxCorner = Instance.new("UICorner")
                    SVBoxCorner.CornerRadius = UDim.new(0, 8)
                    SVBoxCorner.Parent = SVBox

                    local SVWhiteOverlay = Instance.new("Frame")
                    SVWhiteOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    SVWhiteOverlay.BorderSizePixel = 0
                    SVWhiteOverlay.Size = UDim2.new(1, 0, 1, 0)
                    SVWhiteOverlay.ZIndex = 62
                    SVWhiteOverlay.Parent = SVBox

                    local SVWhiteCorner = Instance.new("UICorner")
                    SVWhiteCorner.CornerRadius = UDim.new(0, 8)
                    SVWhiteCorner.Parent = SVWhiteOverlay

                    local SVWhiteGradient = Instance.new("UIGradient")
                    SVWhiteGradient.Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0),
                        NumberSequenceKeypoint.new(1, 1),
                    })
                    SVWhiteGradient.Parent = SVWhiteOverlay

                    local SVBlackOverlay = Instance.new("Frame")
                    SVBlackOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    SVBlackOverlay.BorderSizePixel = 0
                    SVBlackOverlay.Size = UDim2.new(1, 0, 1, 0)
                    SVBlackOverlay.ZIndex = 62
                    SVBlackOverlay.Parent = SVBox

                    local SVBlackCorner = Instance.new("UICorner")
                    SVBlackCorner.CornerRadius = UDim.new(0, 8)
                    SVBlackCorner.Parent = SVBlackOverlay

                    local SVBlackGradient = Instance.new("UIGradient")
                    SVBlackGradient.Rotation = 90
                    SVBlackGradient.Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(1, 0),
                    })
                    SVBlackGradient.Parent = SVBlackOverlay

                    local SVCursor = Instance.new("Frame")
                    SVCursor.AnchorPoint = Vector2.new(0.5, 0.5)
                    SVCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    SVCursor.BorderSizePixel = 0
                    SVCursor.Size = UDim2.new(0, 16, 0, 16)
                    SVCursor.ZIndex = 63
                    SVCursor.Parent = SVBox

                    local SVCursorCorner = Instance.new("UICorner")
                    SVCursorCorner.CornerRadius = UDim.new(1, 0)
                    SVCursorCorner.Parent = SVCursor

                    local SVCursorStroke = Instance.new("UIStroke")
                    SVCursorStroke.Color = GuiConfig.Color
                    SVCursorStroke.Thickness = 2
                    SVCursorStroke.Parent = SVCursor

                    local SVHitbox = Instance.new("TextButton")
                    SVHitbox.Text = ""
                    SVHitbox.BackgroundTransparency = 1
                    SVHitbox.Size = UDim2.new(1, 0, 1, 0)
                    SVHitbox.ZIndex = 64
                    SVHitbox.Parent = SVBox

                    local HueSlider = Instance.new("Frame")
                    HueSlider.Name = "HueSlider"
                    HueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    HueSlider.BorderSizePixel = 0
                    HueSlider.Position = UDim2.new(0, 224, 0, 40)
                    HueSlider.Size = UDim2.new(0, 20, 0, 150)
                    HueSlider.ZIndex = 62
                    HueSlider.Parent = Dialog

                    local HueCorner = Instance.new("UICorner")
                    HueCorner.CornerRadius = UDim.new(0, 10)
                    HueCorner.Parent = HueSlider

                    local HueGradient = Instance.new("UIGradient")
                    HueGradient.Rotation = 90
                    HueGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                        ColorSequenceKeypoint.new(1 / 6, Color3.fromRGB(255, 255, 0)),
                        ColorSequenceKeypoint.new(2 / 6, Color3.fromRGB(0, 255, 0)),
                        ColorSequenceKeypoint.new(3 / 6, Color3.fromRGB(0, 255, 255)),
                        ColorSequenceKeypoint.new(4 / 6, Color3.fromRGB(0, 0, 255)),
                        ColorSequenceKeypoint.new(5 / 6, Color3.fromRGB(255, 0, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
                    })
                    HueGradient.Parent = HueSlider

                    local HueCursor = Instance.new("Frame")
                    HueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
                    HueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    HueCursor.BorderSizePixel = 0
                    HueCursor.Position = UDim2.new(0.5, 0, 0, 0)
                    HueCursor.Size = UDim2.new(0, 26, 0, 10)
                    HueCursor.ZIndex = 63
                    HueCursor.Parent = HueSlider

                    local HueCursorCorner = Instance.new("UICorner")
                    HueCursorCorner.CornerRadius = UDim.new(1, 0)
                    HueCursorCorner.Parent = HueCursor

                    local HueCursorStroke = Instance.new("UIStroke")
                    HueCursorStroke.Color = Color3.fromRGB(20, 20, 20)
                    HueCursorStroke.Thickness = 2
                    HueCursorStroke.Parent = HueCursor

                    local HueHitbox = Instance.new("TextButton")
                    HueHitbox.Text = ""
                    HueHitbox.BackgroundTransparency = 1
                    HueHitbox.Size = UDim2.new(1, 0, 1, 0)
                    HueHitbox.ZIndex = 64
                    HueHitbox.Parent = HueSlider

                    local function CreateField(posX, posY, width, labelText)
                        local Field = Instance.new("Frame")
                        Field.BackgroundColor3 = THEME.surfaceAlt
                        Field.BackgroundTransparency = 0
                        Field.BorderSizePixel = 0
                        Field.Position = UDim2.new(0, posX, 0, posY)
                        Field.Size = UDim2.new(0, width, 0, 30)
                        Field.ZIndex = 62
                        Field.Parent = Dialog

                        local FieldCorner = Instance.new("UICorner")
                        FieldCorner.CornerRadius = UDim.new(0, 6)
                        FieldCorner.Parent = Field

                        local ValueBox = Instance.new("TextBox")
                        ValueBox.Font = Enum.Font.GothamBold
                        ValueBox.Text = ""
                        ValueBox.TextColor3 = THEME.text
                        ValueBox.TextSize = 13
                        ValueBox.TextXAlignment = Enum.TextXAlignment.Left
                        ValueBox.ClearTextOnFocus = false
                        ValueBox.BackgroundTransparency = 1
                        ValueBox.Position = UDim2.new(0, 12, 0, 0)
                        ValueBox.Size = UDim2.new(0.5, -12, 1, 0)
                        ValueBox.ZIndex = 63
                        ValueBox.Parent = Field

                        local Label = Instance.new("TextLabel")
                        Label.Font = Enum.Font.GothamBold
                        Label.Text = labelText
                        Label.TextColor3 = THEME.muted
                        Label.TextTransparency = 0
                        Label.TextSize = 12
                        Label.TextXAlignment = Enum.TextXAlignment.Right
                        Label.BackgroundTransparency = 1
                        Label.Position = UDim2.new(0.5, 0, 0, 0)
                        Label.Size = UDim2.new(0.5, -12, 1, 0)
                        Label.ZIndex = 63
                        Label.Parent = Field

                        return ValueBox
                    end

                    local PreviewSwatch = Instance.new("Frame")
                    PreviewSwatch.BackgroundColor3 = editColor
                    PreviewSwatch.BorderSizePixel = 0
                    PreviewSwatch.Position = UDim2.new(0, 14, 0, 204)
                    PreviewSwatch.Size = UDim2.new(0, 30, 0, 30)
                    PreviewSwatch.ZIndex = 62
                    PreviewSwatch.Parent = Dialog

                    local PreviewCorner = Instance.new("UICorner")
                    PreviewCorner.CornerRadius = UDim.new(0, 6)
                    PreviewCorner.Parent = PreviewSwatch

                    local PreviewStroke = Instance.new("UIStroke")
                    PreviewStroke.Color = THEME.border
                    PreviewStroke.Transparency = 0.6
                    PreviewStroke.Parent = PreviewSwatch

                    local HexBox = CreateField(52, 204, 234, "Hex")
                    local RBox = CreateField(14, 242, 85, "Red")
                    local GBox = CreateField(107, 242, 85, "Green")
                    local BBox = CreateField(200, 242, 85, "Blue")

                    local CancelButton = Instance.new("TextButton")
                    CancelButton.Font = Enum.Font.GothamBold
                    CancelButton.Text = "Cancel"
                    CancelButton.TextColor3 = THEME.muted
                    CancelButton.TextSize = 15
                    CancelButton.AutoButtonColor = false
                    CancelButton.BackgroundColor3 = THEME.surfaceAlt
                    CancelButton.BorderSizePixel = 0
                    CancelButton.Position = UDim2.new(0, 14, 0, 284)
                    CancelButton.Size = UDim2.new(0, 132, 0, 44)
                    CancelButton.ZIndex = 62
                    CancelButton.Parent = Dialog

                    local CancelCorner = Instance.new("UICorner")
                    CancelCorner.CornerRadius = UDim.new(1, 0)
                    CancelCorner.Parent = CancelButton

                    local CancelStroke = Instance.new("UIStroke")
                    CancelStroke.Color = THEME.border
                    CancelStroke.Transparency = 0
                    CancelStroke.Parent = CancelButton

                    CancelButton.MouseEnter:Connect(function()
                        TweenService:Create(CancelButton, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(46, 46, 54) }):Play()
                    end)
                    CancelButton.MouseLeave:Connect(function()
                        TweenService:Create(CancelButton, TweenInfo.new(0.15), { BackgroundColor3 = THEME.surfaceAlt }):Play()
                    end)

                    local accent = GuiConfig.Color
                    local function ClampChannel(v) return math.clamp(v, 0, 1) end
                    local function Brighten(c, amt)
                        amt = amt or 24
                        return Color3.new(
                            math.clamp(c.R * 255 + amt, 0, 255) / 255,
                            math.clamp(c.G * 255 + amt, 0, 255) / 255,
                            math.clamp(c.B * 255 + amt, 0, 255) / 255
                        )
                    end
                    local ApplyHover = Brighten(accent)

                    local ApplyButton = Instance.new("TextButton")
                    ApplyButton.Font = Enum.Font.GothamBold
                    ApplyButton.Text = "Apply"
                    ApplyButton.TextColor3 = Color3.fromRGB(20, 20, 20)
                    ApplyButton.TextSize = 15
                    ApplyButton.AutoButtonColor = false
                    ApplyButton.BackgroundColor3 = accent
                    ApplyButton.BorderSizePixel = 0
                    ApplyButton.Position = UDim2.new(0, 154, 0, 284)
                    ApplyButton.Size = UDim2.new(0, 132, 0, 44)
                    ApplyButton.ZIndex = 62
                    ApplyButton.Parent = Dialog

                    local ApplyCorner = Instance.new("UICorner")
                    ApplyCorner.CornerRadius = UDim.new(1, 0)
                    ApplyCorner.Parent = ApplyButton

                    ApplyButton.MouseEnter:Connect(function()
                        TweenService:Create(ApplyButton, TweenInfo.new(0.15), { BackgroundColor3 = ApplyHover }):Play()
                    end)
                    ApplyButton.MouseLeave:Connect(function()
                        TweenService:Create(ApplyButton, TweenInfo.new(0.15), { BackgroundColor3 = accent }):Play()
                    end)


                    local updatingFields = false

                    local function RefreshUI(skipFields)
                        editColor = Color3.fromHSV(editH, editS, editV)
                        SVBox.BackgroundColor3 = Color3.fromHSV(editH, 1, 1)
                        SVCursor.Position = UDim2.new(editS, 0, 1 - editV, 0)
                        HueCursor.Position = UDim2.new(0.5, 0, editH, 0)
                        PreviewSwatch.BackgroundColor3 = editColor

                        if not skipFields then
                            local r = math.floor(editColor.R * 255 + 0.5)
                            local g = math.floor(editColor.G * 255 + 0.5)
                            local b = math.floor(editColor.B * 255 + 0.5)
                            updatingFields = true
                            HexBox.Text = string.format("#%02X%02X%02X", r, g, b)
                            RBox.Text = tostring(r)
                            GBox.Text = tostring(g)
                            BBox.Text = tostring(b)
                            updatingFields = false
                        end
                    end

                    local function UpdateSVFromInput(inputPos)
                        local relX = math.clamp((inputPos.X - SVBox.AbsolutePosition.X) / SVBox.AbsoluteSize.X, 0, 1)
                        local relY = math.clamp((inputPos.Y - SVBox.AbsolutePosition.Y) / SVBox.AbsoluteSize.Y, 0, 1)
                        editS = relX
                        editV = 1 - relY
                        RefreshUI(false)
                    end

                    local function UpdateHueFromInput(inputPos)
                        local relY = math.clamp((inputPos.Y - HueSlider.AbsolutePosition.Y) / HueSlider.AbsoluteSize.Y, 0, 1)
                        editH = relY
                        RefreshUI(false)
                    end

                    table.insert(Connections, SVHitbox.InputBegan:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                            svDragging = true
                            UpdateSVFromInput(inp.Position)
                        end
                    end))

                    table.insert(Connections, HueHitbox.InputBegan:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                            hueDragging = true
                            UpdateHueFromInput(inp.Position)
                        end
                    end))

                    table.insert(Connections, UserInputService.InputChanged:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                            if svDragging then UpdateSVFromInput(inp.Position) end
                            if hueDragging then UpdateHueFromInput(inp.Position) end
                        end
                    end))

                    local function StopDragging(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                            svDragging = false
                            hueDragging = false
                        end
                    end
                    table.insert(Connections, UserInputService.InputEnded:Connect(StopDragging))

                    HexBox.FocusLost:Connect(function()
                        if updatingFields then return end
                        local text = HexBox.Text:gsub("#", ""):gsub("%s", "")
                        if #text == 6 and text:match("^%x+$") then
                            local r = tonumber(text:sub(1, 2), 16)
                            local g = tonumber(text:sub(3, 4), 16)
                            local b = tonumber(text:sub(5, 6), 16)
                            editH, editS, editV = Color3.fromRGB(r, g, b):ToHSV()
                        end
                        RefreshUI(false)
                    end)

                    local function ApplyRGBEdit()
                        if updatingFields then return end
                        local curR = math.floor(editColor.R * 255 + 0.5)
                        local curG = math.floor(editColor.G * 255 + 0.5)
                        local curB = math.floor(editColor.B * 255 + 0.5)
                        local r = math.clamp(math.floor(tonumber(RBox.Text) or curR), 0, 255)
                        local g = math.clamp(math.floor(tonumber(GBox.Text) or curG), 0, 255)
                        local b = math.clamp(math.floor(tonumber(BBox.Text) or curB), 0, 255)
                        editH, editS, editV = Color3.fromRGB(r, g, b):ToHSV()
                        RefreshUI(false)
                    end
                    RBox.FocusLost:Connect(ApplyRGBEdit)
                    GBox.FocusLost:Connect(ApplyRGBEdit)
                    BBox.FocusLost:Connect(ApplyRGBEdit)

                    local function CloseModal()
                        for _, connection in ipairs(Connections) do
                            connection:Disconnect()
                        end
                        Overlay:Destroy()
                    end

                    CancelButton.MouseButton1Click:Connect(CloseModal)
                    OverlayClose.MouseButton1Click:Connect(CloseModal)

                    ApplyButton.MouseButton1Click:Connect(function()
                        ApplyColor(editColor, false, true)
                        CloseModal()
                    end)

                    RefreshUI(false)
                end

                Swatch.MouseButton1Click:Connect(OpenPalette)

                function ColorFunc:Set(color, noSave)
                    if typeof(color) == "table" then
                        color = Color3.fromRGB(tonumber(color.R) or 255, tonumber(color.G) or 255, tonumber(color.B) or 255)
                    end
                    ApplyColor(color, noSave, true)
                end

                ApplyColor(ColorConfig.Default, true, true)

                CountItem = CountItem + 1
                if shouldSave then
                    Elements[configKey] = ColorFunc
                end
                RegisterSearch({ label = ColorConfig.Title, tab = TabConfig.Name, kind = "ColorPicker", element = ColorFunc, section = self, switch = SearchSwitch })
                return ColorFunc
            end

            function Items:AddInput(InputConfig)
                local InputConfig = InputConfig or {}
                InputConfig.Title = InputConfig.Title or "Title"
                InputConfig.Content = InputConfig.Content or ""
                InputConfig.Callback = InputConfig.Callback or function() end
                InputConfig.Default = InputConfig.Default or ""
                InputConfig.Placeholder = InputConfig.Placeholder or "Input Here"

                local configKey = "Input_" .. InputConfig.Title
                local shouldSave = InputConfig.Save ~= false
                if shouldSave and ConfigData[configKey] ~= nil then
                    InputConfig.Default = ConfigData[configKey]
                end

                local InputFunc = { Value = InputConfig.Default }

                local Input = Instance.new("Frame");
                local UICorner12 = Instance.new("UICorner");
                local InputTitle = Instance.new("TextLabel");
                local InputContent = Instance.new("TextLabel");
                local InputFrame = Instance.new("Frame");
                local UICorner13 = Instance.new("UICorner");
                local InputTextBox = Instance.new("TextBox");

                Input.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Input.BackgroundTransparency = 0.935
                Input.BorderColor3 = Color3.fromRGB(15, 15, 15)
                Input.BorderSizePixel = 0
                Input.LayoutOrder = CountItem
                Input.Size = UDim2.new(1, 0, 0, 46)
                Input.Name = "Input"
                Input.Parent = SectionAdd

                UICorner12.CornerRadius = UDim.new(0, 4)
                UICorner12.Parent = Input

                InputTitle.Font = Enum.Font.GothamBold
                InputTitle.Text = InputConfig.Title or "TextBox"
                InputTitle.TextColor3 = Color3.fromRGB(231, 231, 231)
                InputTitle.TextSize = 13
                InputTitle.TextXAlignment = Enum.TextXAlignment.Left
                InputTitle.TextYAlignment = Enum.TextYAlignment.Top
                InputTitle.BackgroundTransparency = 1
                InputTitle.BorderSizePixel = 0
                InputTitle.Position = UDim2.new(0, 10, 0, 10)
                InputTitle.Size = UDim2.new(1, -180, 0, 13)
                InputTitle.Name = "InputTitle"
                InputTitle.Parent = Input

                InputContent.Font = Enum.Font.GothamBold
                InputContent.Text = InputConfig.Content or "This is a TextBox"
                InputContent.TextColor3 = Color3.fromRGB(255, 255, 255)
                InputContent.TextSize = 12
                InputContent.TextTransparency = 0.6
                InputContent.TextWrapped = true
                InputContent.TextXAlignment = Enum.TextXAlignment.Left
                InputContent.TextYAlignment = Enum.TextYAlignment.Bottom
                InputContent.BackgroundTransparency = 1
                InputContent.BorderSizePixel = 0
                InputContent.Position = UDim2.new(0, 10, 0, 25)
                InputContent.Size = UDim2.new(1, -180, 0, 12)
                InputContent.Name = "InputContent"
                InputContent.Parent = Input

                InputContent.Size = UDim2.new(1, -180, 0,
                    12 + (12 * (InputContent.TextBounds.X // InputContent.AbsoluteSize.X)))
                InputContent.TextWrapped = true
                Input.Size = UDim2.new(1, 0, 0, InputContent.AbsoluteSize.Y + 33)

                local inputStayedH = nil
                InputContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                    local newInputH = InputContent.AbsoluteSize.Y + 33
                    if inputStayedH ~= nil and math.abs(Input.Size.Y.Offset - newInputH) <= 1 then
                        return
                    end

                    InputContent.TextWrapped = false
                    InputContent.Size = UDim2.new(1, -180, 0,
                        12 + (12 * (InputContent.TextBounds.X // InputContent.AbsoluteSize.X)))
                    Input.Size = UDim2.new(Input.Size.X.Scale, Input.Size.X.Offset, 0,
                        InputContent.AbsoluteSize.Y + 33)
                    InputContent.TextWrapped = true
                    inputStayedH = Input.Size.Y.Offset
                    UpdateSizeSection()
                end)

                InputFrame.AnchorPoint = Vector2.new(1, 0.5)
                InputFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                InputFrame.BackgroundTransparency = 0.95
                InputFrame.BorderColor3 = Color3.fromRGB(15, 15, 15)
                InputFrame.BorderSizePixel = 0
                InputFrame.ClipsDescendants = true
                InputFrame.Position = UDim2.new(1, -7, 0.5, 0)
                InputFrame.Size = UDim2.new(0, 148, 0, 30)
                InputFrame.Name = "InputFrame"
                InputFrame.Parent = Input

                UICorner13.CornerRadius = UDim.new(0, 4)
                UICorner13.Parent = InputFrame

                InputTextBox.CursorPosition = -1
                InputTextBox.Font = Enum.Font.GothamBold
                InputTextBox.PlaceholderColor3 = Color3.fromRGB(120, 120,
                    120)
                InputTextBox.PlaceholderText = InputConfig.Placeholder
                InputTextBox.Text = InputConfig.Default
                InputTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                InputTextBox.TextSize = 12
                InputTextBox.TextXAlignment = Enum.TextXAlignment.Left
                InputTextBox.AnchorPoint = Vector2.new(0, 0.5)
                InputTextBox.BackgroundTransparency = 1
                InputTextBox.BorderSizePixel = 0
                InputTextBox.Position = UDim2.new(0, 5, 0.5, 0)
                InputTextBox.Size = UDim2.new(1, -10, 1, -8)
                InputTextBox.Name = "InputTextBox"
                InputTextBox.Parent = InputFrame
                function InputFunc:Set(Value, noSave)
                    Value = tostring(Value or "")
                    InputTextBox.Text = Value
                    InputFunc.Value = Value
                    InputConfig.Callback(Value)
                    if shouldSave then
                        ConfigData[configKey] = Value
                        if not noSave then QueueSaveConfig() end
                    end
                end

                InputFunc:Set(InputFunc.Value, true)

                InputTextBox.FocusLost:Connect(function()
                    InputFunc:Set(InputTextBox.Text)
                end)
                CountItem = CountItem + 1
                if shouldSave then
                    Elements[configKey] = InputFunc
                end
                RegisterSearch({ label = InputConfig.Title, tab = TabConfig.Name, kind = "Input", element = InputFunc, section = self, switch = SearchSwitch })
                return InputFunc
            end

            function Items:AddKeybind(KeybindConfig)
                local KeybindConfig = KeybindConfig or {}
                
                
                if isMobile then
                    local DummyFunc = { Value = Enum.KeyCode.Unknown }
                    function DummyFunc:Set(kc) end
                    function DummyFunc:GetValue() return Enum.KeyCode.Unknown end
                    return DummyFunc
                end

                KeybindConfig.Title   = KeybindConfig.Title   or "Keybind"
                KeybindConfig.Content = KeybindConfig.Content or ""
                KeybindConfig.Default = KeybindConfig.Default or Enum.KeyCode.Unknown
                KeybindConfig.Callback = KeybindConfig.Callback or function() end

                local configKey = "Keybind_" .. KeybindConfig.Title
                local shouldSave = KeybindConfig.Save ~= false
                if shouldSave and ConfigData[configKey] ~= nil then
                    local ok, kc = pcall(function()
                        return Enum.KeyCode[ConfigData[configKey]]
                    end)
                    if ok and kc then KeybindConfig.Default = kc end
                end

                local KeybindFunc = { Value = KeybindConfig.Default }
                local listening = false

                local KeyRow = Instance.new("Frame")
                KeyRow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                KeyRow.BackgroundTransparency = 0.935
                KeyRow.BorderSizePixel = 0
                KeyRow.LayoutOrder = CountItem
                KeyRow.Size = UDim2.new(1, 0, 0, 46)
                KeyRow.Name = "Keybind"
                KeyRow.Parent = SectionAdd

                local KeyCorner = Instance.new("UICorner")
                KeyCorner.CornerRadius = UDim.new(0, 4)
                KeyCorner.Parent = KeyRow

                local KeyTitle = Instance.new("TextLabel")
                KeyTitle.Font = Enum.Font.GothamBold
                KeyTitle.Text = KeybindConfig.Title
                KeyTitle.TextColor3 = Color3.fromRGB(231, 231, 231)
                KeyTitle.TextSize = 13
                KeyTitle.TextXAlignment = Enum.TextXAlignment.Left
                KeyTitle.TextYAlignment = Enum.TextYAlignment.Top
                KeyTitle.BackgroundTransparency = 1
                KeyTitle.Position = UDim2.new(0, 10, 0, 10)
                KeyTitle.Size = UDim2.new(1, -110, 0, 13)
                KeyTitle.Parent = KeyRow

                local KeyContent = Instance.new("TextLabel")
                KeyContent.Font = Enum.Font.GothamBold
                KeyContent.Text = KeybindConfig.Content
                KeyContent.TextColor3 = Color3.fromRGB(255, 255, 255)
                KeyContent.TextSize = 12
                KeyContent.TextTransparency = 0.6
                KeyContent.TextXAlignment = Enum.TextXAlignment.Left
                KeyContent.TextYAlignment = Enum.TextYAlignment.Bottom
                KeyContent.BackgroundTransparency = 1
                KeyContent.Position = UDim2.new(0, 10, 0, 25)
                KeyContent.Size = UDim2.new(1, -110, 0, 12)
                KeyContent.Parent = KeyRow

                local KeyBtn = Instance.new("TextButton")
                KeyBtn.Font = Enum.Font.GothamBold
                KeyBtn.Text = KeybindConfig.Default ~= Enum.KeyCode.Unknown
                    and KeybindConfig.Default.Name
                    or "None"
                KeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                KeyBtn.TextSize = 12
                KeyBtn.TextWrapped = true
                KeyBtn.AutoButtonColor = false
                KeyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                KeyBtn.BackgroundTransparency = 0.2
                KeyBtn.BorderSizePixel = 0
                KeyBtn.AnchorPoint = Vector2.new(1, 0.5)
                KeyBtn.Position = UDim2.new(1, -10, 0.5, 0)
                KeyBtn.Size = UDim2.new(0, 70, 0, 28)
                KeyBtn.Name = "KeyBtn"
                KeyBtn.Parent = KeyRow

                local KeyBtnCorner = Instance.new("UICorner")
                KeyBtnCorner.CornerRadius = UDim.new(0, 8)
                KeyBtnCorner.Parent = KeyBtn

                local KeyBtnStroke = Instance.new("UIStroke")
                KeyBtnStroke.Color = Color3.fromRGB(60, 60, 60)
                KeyBtnStroke.Thickness = 1
                KeyBtnStroke.Transparency = 0.2
                KeyBtnStroke.Parent = KeyBtn

                local defaultBg = Color3.fromRGB(35, 35, 35)
                local defaultBgTrans = 0.2
                local defaultStroke = Color3.fromRGB(60, 60, 60)
                local defaultText = Color3.fromRGB(200, 200, 200)
                local hoverBg = Color3.fromRGB(45, 45, 45)
                local hoverStroke = Color3.fromRGB(90, 90, 90)

                local function SetListening(state)
                    listening = state
                    if state then
                        KeyBtn.Text = "..."
                        
                        TweenService:Create(KeyBtnStroke, TweenInfo.new(0.2), { Color = GuiConfig.Color, Transparency = 0 }):Play()
                        TweenService:Create(KeyBtn, TweenInfo.new(0.2), { BackgroundColor3 = GuiConfig.Color, BackgroundTransparency = 0.85 }):Play()
                        TweenService:Create(KeyBtn, TweenInfo.new(0.2), { TextColor3 = GuiConfig.Color }):Play()
                    else
                        local label = KeybindFunc.Value ~= Enum.KeyCode.Unknown
                            and KeybindFunc.Value.Name
                            or "None"
                        KeyBtn.Text = label
                        TweenService:Create(KeyBtnStroke, TweenInfo.new(0.2), { Color = defaultStroke, Transparency = 0.2 }):Play()
                        TweenService:Create(KeyBtn, TweenInfo.new(0.2), { BackgroundColor3 = defaultBg, BackgroundTransparency = defaultBgTrans }):Play()
                        TweenService:Create(KeyBtn, TweenInfo.new(0.2), { TextColor3 = defaultText }):Play()
                    end
                end

                KeyBtn.MouseEnter:Connect(function()
                    if not listening then
                        TweenService:Create(KeyBtn, TweenInfo.new(0.15), { BackgroundColor3 = hoverBg }):Play()
                        TweenService:Create(KeyBtnStroke, TweenInfo.new(0.15), { Color = hoverStroke }):Play()
                    end
                end)

                KeyBtn.MouseLeave:Connect(function()
                    if not listening then
                        TweenService:Create(KeyBtn, TweenInfo.new(0.15), { BackgroundColor3 = defaultBg, BackgroundTransparency = defaultBgTrans }):Play()
                        TweenService:Create(KeyBtnStroke, TweenInfo.new(0.15), { Color = defaultStroke, Transparency = 0.2 }):Play()
                    end
                end)

                function KeybindFunc:Set(kc, noSave)
                    if type(kc) == "string" then
                        local ok, converted = pcall(function() return Enum.KeyCode[kc] end)
                        kc = (ok and converted) or Enum.KeyCode.Unknown
                    end
                    kc = kc or Enum.KeyCode.Unknown

                    KeybindFunc.Value = kc
                    local label = kc ~= Enum.KeyCode.Unknown and kc.Name or "None"
                    KeyBtn.Text = label
                    if shouldSave then
                        ConfigData[configKey] = kc.Name
                        if not noSave then QueueSaveConfig() end
                    end
                end

                KeyBtn.MouseButton1Click:Connect(function()
                    SetListening(not listening)
                end)

                UserInputService.InputBegan:Connect(function(input, gpe)
                    if not listening then
                        if gpe then return end
                        if KeybindFunc.Value == Enum.KeyCode.Unknown then return end
                        
                        if input.KeyCode == KeybindFunc.Value then
                            local ok, err = pcall(KeybindConfig.Callback, KeybindFunc.Value)
                            if not ok then warn("Keybind Callback error:", err) end
                        end
                        return
                    end
                    
                    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
                    if input.KeyCode == Enum.KeyCode.Escape then
                        SetListening(false)
                        return
                    end
                    KeybindFunc:Set(input.KeyCode, false)
                    local ok, err = pcall(KeybindConfig.Callback, KeybindFunc.Value)
                    if not ok then warn("Keybind Callback error:", err) end
                    SetListening(false)
                end)

                KeybindFunc:Set(KeybindConfig.Default, true)
                CountItem = CountItem + 1
                if shouldSave then
                    Elements[configKey] = KeybindFunc
                end
                RegisterSearch({ label = KeybindConfig.Title, tab = TabConfig.Name, kind = "Keybind", element = KeybindFunc, section = self, switch = SearchSwitch })
                return KeybindFunc
            end

            
            
            
            function Items:AddKeybind2(KeybindConfig)
                if isMobile then
                    local DummyFunc = { Value = { Enum.KeyCode.Unknown, Enum.KeyCode.Unknown } }
                    function DummyFunc:Set(kc1, kc2, noSave) end
                    function DummyFunc:SetSlot(slot, kc, noSave) end
                    function DummyFunc:Get(slot) return Enum.KeyCode.Unknown end
                    return DummyFunc
                end
                KeybindConfig = KeybindConfig or {}
                KeybindConfig.Title = KeybindConfig.Title or "Keybind"
                KeybindConfig.Content = KeybindConfig.Content or ""
                KeybindConfig.Slots = KeybindConfig.Slots or { {}, {} }
                KeybindConfig.Slots[1] = KeybindConfig.Slots[1] or {}
                KeybindConfig.Slots[2] = KeybindConfig.Slots[2] or {}

                local defaultKeys = {
                    KeybindConfig.Slots[1].Key or KeybindConfig.Default1 or Enum.KeyCode.Unknown,
                    KeybindConfig.Slots[2].Key or KeybindConfig.Default2 or Enum.KeyCode.Unknown,
                }
                local slotTitles = {
                    KeybindConfig.Slots[1].Title or "1",
                    KeybindConfig.Slots[2].Title or "2",
                }

                local configKey = "Keybind2_" .. KeybindConfig.Title
                local shouldSave = KeybindConfig.Save ~= false
                if shouldSave and type(ConfigData[configKey]) == "table" then
                    local saved = ConfigData[configKey]
                    if saved[1] and Enum.KeyCode[saved[1]] then defaultKeys[1] = Enum.KeyCode[saved[1]] end
                    if saved[2] and Enum.KeyCode[saved[2]] then defaultKeys[2] = Enum.KeyCode[saved[2]] end
                end

                local KeybindFunc = { Value = table.clone(defaultKeys) }
                local listeningSlot = 0

                local KeyRow = Instance.new("Frame")
                KeyRow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                KeyRow.BackgroundTransparency = 0.935
                KeyRow.BorderSizePixel = 0
                KeyRow.LayoutOrder = CountItem
                KeyRow.Size = UDim2.new(1, 0, 0, 46)
                KeyRow.Name = "Keybind2"
                KeyRow.Parent = SectionAdd

                local KeyCorner = Instance.new("UICorner")
                KeyCorner.CornerRadius = UDim.new(0, 4)
                KeyCorner.Parent = KeyRow

                local KeyTitle = Instance.new("TextLabel")
                KeyTitle.Font = Enum.Font.GothamBold
                KeyTitle.Text = KeybindConfig.Title
                KeyTitle.TextColor3 = Color3.fromRGB(231, 231, 231)
                KeyTitle.TextSize = 13
                KeyTitle.TextXAlignment = Enum.TextXAlignment.Left
                KeyTitle.TextYAlignment = Enum.TextYAlignment.Top
                KeyTitle.BackgroundTransparency = 1
                KeyTitle.Position = UDim2.new(0, 10, 0, 8)
                KeyTitle.Size = UDim2.new(1, -172, 0, 13)
                KeyTitle.Parent = KeyRow

                if KeybindConfig.Content and KeybindConfig.Content ~= "" then
                    local KeyContent = Instance.new("TextLabel")
                    KeyContent.Font = Enum.Font.GothamBold
                    KeyContent.Text = KeybindConfig.Content
                    KeyContent.TextColor3 = Color3.fromRGB(255, 255, 255)
                    KeyContent.TextSize = 12
                    KeyContent.TextTransparency = 0.6
                    KeyContent.TextXAlignment = Enum.TextXAlignment.Left
                    KeyContent.TextYAlignment = Enum.TextYAlignment.Bottom
                    KeyContent.BackgroundTransparency = 1
                    KeyContent.Position = UDim2.new(0, 10, 0, 23)
                    KeyContent.Size = UDim2.new(1, -172, 0, 12)
                    KeyContent.Parent = KeyRow
                end

                local defaultBg = Color3.fromRGB(35, 35, 35)
                local defaultBgTrans = 0.2
                local defaultStroke = Color3.fromRGB(60, 60, 60)
                local defaultText = Color3.fromRGB(200, 200, 200)
                local hoverBg = Color3.fromRGB(45, 45, 45)

                local KeyChips = Instance.new("Frame")
                KeyChips.BackgroundTransparency = 1
                KeyChips.AnchorPoint = Vector2.new(1, 0.5)
                KeyChips.Position = UDim2.new(1, -10, 0.5, 0)
                KeyChips.Size = UDim2.new(0, 128, 0, 28)
                KeyChips.Parent = KeyRow

                local ChipLayout = Instance.new("UIListLayout")
                ChipLayout.FillDirection = Enum.FillDirection.Horizontal
                ChipLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                ChipLayout.Padding = UDim.new(0, 6)
                ChipLayout.Parent = KeyChips

                local slotBtn = {}
                local slotStroke = {}
                local slotBadge = {}

                for i = 1, 2 do
                    local btn = Instance.new("TextButton")
                    btn.Font = Enum.Font.GothamBold
                    btn.Text = defaultKeys[i] ~= Enum.KeyCode.Unknown and defaultKeys[i].Name or "None"
                    btn.TextColor3 = defaultText
                    btn.TextSize = 11
                    btn.TextWrapped = true
                    btn.AutoButtonColor = false
                    btn.BackgroundColor3 = defaultBg
                    btn.BackgroundTransparency = defaultBgTrans
                    btn.BorderSizePixel = 0
                    btn.Size = UDim2.new(0, 61, 0, 28)
                    btn.Name = "KeyChip" .. i
                    btn.Parent = KeyChips

                    local corner = Instance.new("UICorner")
                    corner.CornerRadius = UDim.new(0, 8)
                    corner.Parent = btn

                    local stroke = Instance.new("UIStroke")
                    stroke.Color = defaultStroke
                    stroke.Thickness = 1
                    stroke.Transparency = 0.2
                    stroke.Parent = btn

                    local badge = Instance.new("TextLabel")
                    badge.BackgroundColor3 = Color3.fromRGB(80, 82, 90)
                    badge.BackgroundTransparency = 0.2
                    badge.Font = Enum.Font.GothamBold
                    badge.Text = slotTitles[i]
                    badge.TextColor3 = Color3.fromRGB(235, 235, 235)
                    badge.TextSize = 8
                    badge.AnchorPoint = Vector2.new(1, 0)
                    badge.Position = UDim2.new(1, 1, 0, -1)
                    badge.Size = UDim2.new(0, 14, 0, 10)
                    badge.ZIndex = 3
                    badge.Parent = btn

                    local badgeCorner = Instance.new("UICorner")
                    badgeCorner.CornerRadius = UDim.new(0, 4)
                    badgeCorner.Parent = badge

                    slotBtn[i] = btn
                    slotStroke[i] = stroke
                    slotBadge[i] = badge

                    btn.MouseEnter:Connect(function()
                        if listeningSlot == 0 then
                            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = hoverBg }):Play()
                            TweenService:Create(stroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(90, 90, 90) }):Play()
                        end
                    end)

                    btn.MouseLeave:Connect(function()
                        if listeningSlot == 0 then
                            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = defaultBg, BackgroundTransparency = defaultBgTrans }):Play()
                            TweenService:Create(stroke, TweenInfo.new(0.15), { Color = defaultStroke, Transparency = 0.2 }):Play()
                        end
                    end)

                    btn.MouseButton1Click:Connect(function()
                        listeningSlot = (listeningSlot == i) and 0 or i
                        RefreshSlots()
                        if listeningSlot == i then
                            slotBtn[i].Text = "..."
                            TweenService:Create(slotStroke[i], TweenInfo.new(0.2), { Color = GuiConfig.Color, Transparency = 0 }):Play()
                            TweenService:Create(slotBtn[i], TweenInfo.new(0.2), { BackgroundColor3 = GuiConfig.Color, BackgroundTransparency = 0.85 }):Play()
                            TweenService:Create(slotBtn[i], TweenInfo.new(0.2), { TextColor3 = GuiConfig.Color }):Play()
                            TweenService:Create(slotBadge[i], TweenInfo.new(0.2), { BackgroundColor3 = GuiConfig.Color }):Play()
                        end
                    end)
                end

                local function RefreshSlots()
                    for i = 1, 2 do
                        local label = KeybindFunc.Value[i] ~= Enum.KeyCode.Unknown and KeybindFunc.Value[i].Name or "None"
                        slotBtn[i].Text = label
                        TweenService:Create(slotStroke[i], TweenInfo.new(0.15), { Color = defaultStroke, Transparency = 0.2 }):Play()
                        TweenService:Create(slotBtn[i], TweenInfo.new(0.15), { BackgroundColor3 = defaultBg, BackgroundTransparency = defaultBgTrans }):Play()
                        TweenService:Create(slotBtn[i], TweenInfo.new(0.15), { TextColor3 = defaultText }):Play()
                        TweenService:Create(slotBadge[i], TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(80, 82, 90) }):Play()
                    end
                end

                local function ParseKey(kc)
                    if type(kc) == "string" then
                        local ok, conv = pcall(function() return Enum.KeyCode[kc] end)
                        return (ok and conv) or Enum.KeyCode.Unknown
                    end
                    return kc or Enum.KeyCode.Unknown
                end

                function KeybindFunc:Set(kc1, kc2, noSave)
                    if type(kc1) == "table" then
                        kc2, kc1 = kc1[2], kc1[1]
                    end
                    KeybindFunc.Value[1] = ParseKey(kc1)
                    KeybindFunc.Value[2] = ParseKey(kc2)
                    RefreshSlots()
                    if shouldSave then
                        ConfigData[configKey] = { KeybindFunc.Value[1].Name, KeybindFunc.Value[2].Name }
                        if not noSave then QueueSaveConfig() end
                    end
                end

                function KeybindFunc:SetSlot(slot, kc, noSave)
                    slot = (slot == 1 or slot == 2) and slot or 1
                    KeybindFunc.Value[slot] = ParseKey(kc)
                    RefreshSlots()
                    if shouldSave then
                        ConfigData[configKey] = { KeybindFunc.Value[1].Name, KeybindFunc.Value[2].Name }
                        if not noSave then QueueSaveConfig() end
                    end
                end

                function KeybindFunc:Get(slot)
                    slot = (slot == 1 or slot == 2) and slot or 1
                    return KeybindFunc.Value[slot]
                end

                UserInputService.InputBegan:Connect(function(input, gpe)
                    if listeningSlot == 0 then
                        if gpe then return end
                        for i = 1, 2 do
                            local bound = KeybindFunc.Value[i]
                            if bound ~= Enum.KeyCode.Unknown and bound == input.KeyCode then
                                local ok, err = pcall(KeybindConfig.Callback, i, bound)
                                if not ok then warn("Keybind2 Callback error:", err) end
                                break
                            end
                        end
                        return
                    end
                    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
                    if input.KeyCode == Enum.KeyCode.Escape then
                        listeningSlot = 0
                        RefreshSlots()
                        return
                    end
                    local finishedSlot = listeningSlot
                    KeybindFunc:SetSlot(finishedSlot, input.KeyCode, false)
                    listeningSlot = 0
                    RefreshSlots()
                    local ok, err = pcall(KeybindConfig.Callback, finishedSlot, KeybindFunc.Value[finishedSlot])
                    if not ok then warn("Keybind2 Callback error:", err) end
                end)

                KeybindFunc:Set(defaultKeys[1], defaultKeys[2], true)
                CountItem = CountItem + 1
                if shouldSave then
                    Elements[configKey] = KeybindFunc
                end
                RegisterSearch({ label = KeybindConfig.Title, tab = TabConfig.Name, kind = "Keybind", element = KeybindFunc, section = self, switch = SearchSwitch })
                return KeybindFunc
            end

            function Items:AddDropdown(DropdownConfig)
                local DropdownConfig = DropdownConfig or {}
                DropdownConfig.Title = DropdownConfig.Title or "Title"
                DropdownConfig.Content = DropdownConfig.Content or ""
                DropdownConfig.Multi = DropdownConfig.Multi or false
                DropdownConfig.Options = DropdownConfig.Options or {}
                DropdownConfig.Default = DropdownConfig.Default or (DropdownConfig.Multi and {} or nil)
                DropdownConfig.Callback = DropdownConfig.Callback or function() end

                local configKey = "Dropdown_" .. DropdownConfig.Title
                local shouldSave = DropdownConfig.Save ~= false
                if shouldSave and ConfigData[configKey] ~= nil then
                    DropdownConfig.Default = ConfigData[configKey]
                end

                local DropdownFunc = { Value = DropdownConfig.Default, Options = DropdownConfig.Options }

                local Dropdown = Instance.new("Frame")
                local DropdownButton = Instance.new("TextButton")
                local UICorner10 = Instance.new("UICorner")
                local DropdownTitle = Instance.new("TextLabel")
                local DropdownContent = Instance.new("TextLabel")
                local SelectOptionsFrame = Instance.new("Frame")
                local UICorner11 = Instance.new("UICorner")
                local OptionSelecting = Instance.new("TextLabel")
                local OptionImg = Instance.new("ImageLabel")

                Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Dropdown.BackgroundTransparency = 0.935
                Dropdown.BorderSizePixel = 0
                Dropdown.LayoutOrder = CountItem
                Dropdown.Size = UDim2.new(1, 0, 0, 46)
                Dropdown.Name = "Dropdown"
                Dropdown.Parent = SectionAdd

                DropdownButton.Text = ""
                DropdownButton.BackgroundTransparency = 1
                DropdownButton.Size = UDim2.new(1, 0, 1, 0)
                DropdownButton.Name = "ToggleButton"
                DropdownButton.Parent = Dropdown

                UICorner10.CornerRadius = UDim.new(0, 4)
                UICorner10.Parent = Dropdown

                DropdownTitle.Font = Enum.Font.GothamBold
                DropdownTitle.Text = DropdownConfig.Title
                DropdownTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                DropdownTitle.TextSize = 13
                DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
                DropdownTitle.BackgroundTransparency = 1
                DropdownTitle.Position = UDim2.new(0, 10, 0, 10)
                DropdownTitle.Size = UDim2.new(1, -180, 0, 13)
                DropdownTitle.Name = "DropdownTitle"
                DropdownTitle.Parent = Dropdown

                DropdownContent.Font = Enum.Font.GothamBold
                DropdownContent.Text = DropdownConfig.Content
                DropdownContent.TextColor3 = Color3.fromRGB(255, 255, 255)
                DropdownContent.TextSize = 12
                DropdownContent.TextTransparency = 0.6
                DropdownContent.TextWrapped = true
                DropdownContent.TextXAlignment = Enum.TextXAlignment.Left
                DropdownContent.BackgroundTransparency = 1
                DropdownContent.Position = UDim2.new(0, 10, 0, 25)
                DropdownContent.Size = UDim2.new(1, -180, 0, 12)
                DropdownContent.Name = "DropdownContent"
                DropdownContent.Parent = Dropdown

                SelectOptionsFrame.AnchorPoint = Vector2.new(1, 0.5)
                SelectOptionsFrame.BackgroundTransparency = 0.95
                SelectOptionsFrame.Position = UDim2.new(1, -7, 0.5, 0)
                SelectOptionsFrame.Size = UDim2.new(0, 148, 0, 30)
                SelectOptionsFrame.Name = "SelectOptionsFrame"
                SelectOptionsFrame.LayoutOrder = CountDropdown
                SelectOptionsFrame.Parent = Dropdown

                UICorner11.CornerRadius = UDim.new(0, 4)
                UICorner11.Parent = SelectOptionsFrame

                DropdownButton.Activated:Connect(function()
                    if not MoreBlur.Visible then
                        MoreBlur.Visible = true
                        DropPageLayout:JumpToIndex(SelectOptionsFrame.LayoutOrder)
                        TweenService:Create(MoreBlur, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
                        TweenService:Create(DropdownSelect, TweenInfo.new(0.3), { Position = UDim2.new(1, -11, 0.5, 0) })
                            :Play()
                    end
                end)

                OptionSelecting.Font = Enum.Font.GothamBold
                OptionSelecting.Text = DropdownConfig.Multi and "Select Options" or "Select Option"
                OptionSelecting.TextColor3 = Color3.fromRGB(255, 255, 255)
                OptionSelecting.TextSize = 12
                OptionSelecting.TextTransparency = 0.6
                OptionSelecting.TextXAlignment = Enum.TextXAlignment.Left
                OptionSelecting.AnchorPoint = Vector2.new(0, 0.5)
                OptionSelecting.BackgroundTransparency = 1
                OptionSelecting.Position = UDim2.new(0, 5, 0.5, 0)
                OptionSelecting.Size = UDim2.new(1, -30, 1, -8)
                OptionSelecting.Name = "OptionSelecting"
                OptionSelecting.Parent = SelectOptionsFrame

                OptionImg.Image = "rbxassetid://16851841101"
                OptionImg.ImageColor3 = Color3.fromRGB(230, 230, 230)
                OptionImg.AnchorPoint = Vector2.new(1, 0.5)
                OptionImg.BackgroundTransparency = 1
                OptionImg.Position = UDim2.new(1, 0, 0.5, 0)
                OptionImg.Size = UDim2.new(0, 25, 0, 25)
                OptionImg.Name = "OptionImg"
                OptionImg.Parent = SelectOptionsFrame

                local DropdownContainer = Instance.new("Frame")
                DropdownContainer.Size = UDim2.new(1, 0, 1, 0)
                DropdownContainer.BackgroundTransparency = 1
                DropdownContainer.Parent = DropdownFolder

                local SearchBox = Instance.new("TextBox")
                SearchBox.PlaceholderText = "Search"
                SearchBox.Font = Enum.Font.Gotham
                SearchBox.Text = ""
                SearchBox.TextSize = 12
                SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                SearchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                SearchBox.BackgroundTransparency = 0.9
                SearchBox.BorderSizePixel = 0
                SearchBox.Size = UDim2.new(1, 0, 0, 25)
                SearchBox.Position = UDim2.new(0, 0, 0, 0)
                SearchBox.ClearTextOnFocus = false
                SearchBox.Name = "SearchBox"
                SearchBox.Parent = DropdownContainer

                local ScrollSelect = Instance.new("ScrollingFrame")
                ScrollSelect.Size = UDim2.new(1, 0, 1, -30)
                ScrollSelect.Position = UDim2.new(0, 0, 0, 30)
                ScrollSelect.ScrollBarImageTransparency = 1
                ScrollSelect.BorderSizePixel = 0
                ScrollSelect.BackgroundTransparency = 1
                ScrollSelect.ScrollBarThickness = 0
                ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, 0)
                ScrollSelect.Name = "ScrollSelect"
                ScrollSelect.Parent = DropdownContainer

                local UIListLayout4 = Instance.new("UIListLayout")
                UIListLayout4.Padding = UDim.new(0, 3)
                UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout4.Parent = ScrollSelect

                UIListLayout4:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, UIListLayout4.AbsoluteContentSize.Y)
                end)

                local dropdownSearchTicket = 0
                local function RunDropdownSearch()
                    local query = string.lower(SearchBox.Text)
                    for _, option in pairs(ScrollSelect:GetChildren()) do
                        if option.Name == "Option" and option:FindFirstChild("OptionText") then
                            local text = string.lower(option.OptionText.Text)
                            option.Visible = query == "" or string.find(text, query, 1, true)
                        end
                    end
                    ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, UIListLayout4.AbsoluteContentSize.Y)
                end

                SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                    dropdownSearchTicket = dropdownSearchTicket + 1
                    local ticket = dropdownSearchTicket
                    task.delay(0.08, function()
                        if ticket == dropdownSearchTicket then
                            RunDropdownSearch()
                        end
                    end)
                end)

                local DropCount = 0

                function DropdownFunc:Clear()
                    for _, DropFrame in ScrollSelect:GetChildren() do
                        if DropFrame.Name == "Option" then
                            DropFrame:Destroy()
                        end
                    end
                    DropdownFunc.Value = DropdownConfig.Multi and {} or nil
                    DropdownFunc.Options = {}
                    OptionSelecting.Text = DropdownConfig.Multi and "Select Options" or "Select Option"
                    DropCount = 0
                end

                function DropdownFunc:AddOption(option)
                    local label, value
                    if typeof(option) == "table" and option.Label and option.Value ~= nil then
                        label = tostring(option.Label)
                        value = option.Value
                    else
                        label = tostring(option)
                        value = option
                    end

                    local Option = Instance.new("Frame")
                    local OptionButton = Instance.new("TextButton")
                    local OptionText = Instance.new("TextLabel")
                    local ChooseFrame = Instance.new("Frame")
                    local UIStroke15 = Instance.new("UIStroke")
                    local UICorner38 = Instance.new("UICorner")
                    local UICorner37 = Instance.new("UICorner")

                    Option.BackgroundTransparency = 1
                    Option.Size = UDim2.new(1, 0, 0, 30)
                    Option.Name = "Option"
                    Option.Parent = ScrollSelect

                    UICorner37.CornerRadius = UDim.new(0, 3)
                    UICorner37.Parent = Option

                    OptionButton.BackgroundTransparency = 1
                    OptionButton.Size = UDim2.new(1, 0, 1, 0)
                    OptionButton.Text = ""
                    OptionButton.Name = "OptionButton"
                    OptionButton.Parent = Option

                    OptionText.Font = Enum.Font.GothamBold
                    OptionText.Text = label
                    OptionText.TextSize = 13
                    OptionText.TextColor3 = Color3.fromRGB(230, 230, 230)
                    OptionText.Position = UDim2.new(0, 8, 0, 8)
                    OptionText.Size = UDim2.new(1, -100, 0, 13)
                    OptionText.BackgroundTransparency = 1
                    OptionText.TextXAlignment = Enum.TextXAlignment.Left
                    OptionText.Name = "OptionText"
                    OptionText.Parent = Option

                    Option:SetAttribute("RealValue", value)

                    ChooseFrame.AnchorPoint = Vector2.new(0, 0.5)
                    ChooseFrame.BackgroundColor3 = GuiConfig.Color
                    ChooseFrame.Position = UDim2.new(0, 2, 0.5, 0)
                    ChooseFrame.Size = UDim2.new(0, 0, 0, 0)
                    ChooseFrame.Name = "ChooseFrame"
                    ChooseFrame.Parent = Option

                    UIStroke15.Color = GuiConfig.Color
                    UIStroke15.Thickness = 1.6
                    UIStroke15.Transparency = 0.999
                    UIStroke15.Parent = ChooseFrame
                    UICorner38.Parent = ChooseFrame

                    OptionButton.Activated:Connect(function()
                        if DropdownConfig.Multi then
                            if not table.find(DropdownFunc.Value, value) then
                                table.insert(DropdownFunc.Value, value)
                            else
                                for i, v in pairs(DropdownFunc.Value) do
                                    if v == value then
                                        table.remove(DropdownFunc.Value, i)
                                        break
                                    end
                                end
                            end
                        else
                            DropdownFunc.Value = value
                        end
                        DropdownFunc:Set(DropdownFunc.Value)
                    end)
                end

                function DropdownFunc:Set(Value, noSave)
                    task.spawn(function()
                        if DropdownConfig.Multi then
                            DropdownFunc.Value = type(Value) == "table" and Value or {}
                        else
                            DropdownFunc.Value = (type(Value) == "table" and Value[1]) or Value
                        end

                        if shouldSave then
                            ConfigData[configKey] = DropdownFunc.Value
                            if not noSave then QueueSaveConfig() end
                        end

                        local texts = {}
                        for _, Drop in ScrollSelect:GetChildren() do
                            if Drop.Name == "Option" and Drop:FindFirstChild("OptionText") then
                                local v = Drop:GetAttribute("RealValue")
                                local selected = DropdownConfig.Multi and table.find(DropdownFunc.Value, v) or
                                    DropdownFunc.Value == v

                                if selected then
                                    TweenService:Create(Drop.ChooseFrame, TweenInfo.new(0.2),
                                        { Size = UDim2.new(0, 1, 0, 12) }):Play()
                                    TweenService:Create(Drop.ChooseFrame.UIStroke, TweenInfo.new(0.2), { Transparency = 0 })
                                        :Play()
                                    TweenService:Create(Drop, TweenInfo.new(0.2), { BackgroundTransparency = 0.935 }):Play()
                                    table.insert(texts, Drop.OptionText.Text)
                                else
                                    TweenService:Create(Drop.ChooseFrame, TweenInfo.new(0.1),
                                        { Size = UDim2.new(0, 0, 0, 0) }):Play()
                                    TweenService:Create(Drop.ChooseFrame.UIStroke, TweenInfo.new(0.1),
                                        { Transparency = 0.999 }):Play()
                                    TweenService:Create(Drop, TweenInfo.new(0.1), { BackgroundTransparency = 0.999 }):Play()
                                end
                            end
                        end

                        OptionSelecting.Text = (#texts == 0)
                            and (DropdownConfig.Multi and "Select Options" or "Select Option")
                            or table.concat(texts, ", ")

                        if DropdownConfig.Callback then
                            if DropdownConfig.Multi then
                                DropdownConfig.Callback(DropdownFunc.Value)
                            else
                                local str = (DropdownFunc.Value ~= nil) and tostring(DropdownFunc.Value) or ""
                                DropdownConfig.Callback(str)
                            end
                        end
                    end)
                end

                function DropdownFunc:SetValue(val)
                    self:Set(val)
                end

                function DropdownFunc:GetValue()
                    return self.Value
                end

                function DropdownFunc:SetValues(newList, selecting, noSave)
                    newList = newList or {}
                    selecting = selecting or (DropdownConfig.Multi and {} or nil)
                    DropdownFunc:Clear()
                    task.spawn(function()
                        for i, v in ipairs(newList) do
                            DropdownFunc:AddOption(v)
                            if i % 20 == 0 then
                                task.wait()
                            end
                        end
                        DropdownFunc:Set(selecting, noSave)
                    end)
                    DropdownFunc.Options = newList
                end

                DropdownFunc:SetValues(DropdownFunc.Options, DropdownFunc.Value, true)

                CountItem = CountItem + 1
                CountDropdown = CountDropdown + 1
                if shouldSave then
                    Elements[configKey] = DropdownFunc
                end
                RegisterSearch({ label = DropdownConfig.Title, tab = TabConfig.Name, kind = "Dropdown", element = DropdownFunc, section = self, switch = SearchSwitch })
                return DropdownFunc
            end

            function Items:AddTargetSelector(TargetCfg)
                TargetCfg = TargetCfg or {}
                local DropdownTitle = TargetCfg.DropdownTitle or TargetCfg.Title or "Target Type"
                local PanelTitle = TargetCfg.Title or "SELECT TARGET"
                local ButtonTitle = TargetCfg.ButtonTitle or "Select Target Panel"
                local Options = TargetCfg.Options or TargetCfg.Values or { "KILLER", "SURVIVOR", "ZOMBIE" }
                local Values = TargetCfg.Values or TargetCfg.Options or Options
                local Default = TargetCfg.Default or Values[1]
                local Callback = TargetCfg.Callback or function() end

                local Selector

                local Dropdown = Items:AddDropdown({
                    Title = DropdownTitle,
                    Options = Values,
                    Default = Default,
                    Callback = function(v)
                        Callback(v)
                        if Selector and v ~= Selector:Get() then Selector:Set(v) end
                    end,
                })

                Selector = Chloex:TargetSelector({
                    Title = PanelTitle,
                    Options = Options,
                    Values = Values,
                    Default = Dropdown and Dropdown.Value or Default,
                    Callback = function(v)
                        if not v then return end
                        Callback(v)
                        if Dropdown and v ~= Dropdown.Value then Dropdown:Set(v, true) end
                    end,
                })

                Items:AddButton({
                    Title = ButtonTitle,
                    Callback = function()
                        if Selector then Selector:Toggle() end
                    end,
                })

                return Selector
            end

            function Items:AddTogglePanel(ToggleCfg)
                ToggleCfg = ToggleCfg or {}
                local ItemTitle = ToggleCfg.Title or "Toggle"
                local PanelTitle = ToggleCfg.PanelTitle or ItemTitle
                local Subtitle = ToggleCfg.Subtitle or ""
                local Default = ToggleCfg.Default and true or false
                local OffsetY = ToggleCfg.OffsetY or 0
                local Callback = ToggleCfg.Callback or function() end

                local ToggleItem
                local Panel
                local syncing = false

                local function dispatch(v)
                    syncing = true
                    local ok, err = pcall(Callback, v)
                    syncing = false
                    if not ok then warn("AddTogglePanel Callback error:", err) end
                end

                ToggleItem = Items:AddToggle({
                    Title = ItemTitle,
                    Content = ToggleCfg.Content or Subtitle,
                    Default = Default,
                    Save = ToggleCfg.Save,
                    Keybind = ToggleCfg.Keybind,
                    KeybindSave = ToggleCfg.KeybindSave,
                    Callback = function(v)
                        if syncing then return end
                        syncing = true
                        if Panel then Panel:Set(v, true) end
                        syncing = false
                        dispatch(v)
                    end,
                })

                Panel = Chloex:TogglePanel({
                    Title = PanelTitle,
                    Subtitle = Subtitle,
                    Default = ToggleItem.Value,
                    Accent = GuiConfig.Color,
                    OffsetY = OffsetY,
                    Callback = function(v)
                        if syncing then return end
                        syncing = true
                        if ToggleItem then ToggleItem:Set(v, true) end
                        syncing = false
                        dispatch(v)
                    end,
                })

                Items:AddButton({
                    Title = ToggleCfg.ButtonTitle or ("Open " .. PanelTitle .. " Panel"),
                    Callback = function()
                        if Panel then Panel:Toggle() end
                    end,
                })

                return Panel
            end

            function Items:AddConfig(ConfigCfg)
                ConfigCfg = ConfigCfg or {}

                EnsureDefaultConfig()

                local autoName = GuiFunc:GetAutoLoad()
                local currentName = ""
                local importJson = ""
                
                
                local selectedConfig = autoName ~= "" and autoName or DEFAULT_CONFIG_NAME

                local NameInput = Items:AddInput({
                    Title       = "Config Name",
                    Content     = "Name for saving",
                    Placeholder = "MyConfig",
                    Save        = false,
                    Callback    = function(text) currentName = text end,
                })

                local ConfigList
                local function RefreshList()
                    local list = GuiFunc:GetConfigs()
                    if ConfigList and ConfigList.SetValues then
                        ConfigList:SetValues(list, selectedConfig, true)
                    end
                end

                ConfigList = Items:AddDropdown({
                    Title    = "Saved Configs",
                    Content  = "Select a config",
                    Multi    = false,
                    Options  = GuiFunc:GetConfigs(),
                    Default  = selectedConfig,
                    Save     = false,
                    Callback = function(choice)
                        selectedConfig = choice ~= "" and choice or nil
                        if selectedConfig and NameInput then
                            currentName = selectedConfig
                            NameInput:Set(selectedConfig)
                        end
                    end,
                })

                Items:AddButton({
                    Title    = "Save",
                    SubTitle = "Load",
                    Callback = function()
                        if GuiFunc:SaveConfigAs(currentName) then
                            selectedConfig = currentName
                            RefreshList()
                        end
                    end,
                    SubCallback = function()
                        if selectedConfig then GuiFunc:LoadConfigByName(selectedConfig) end
                    end,
                })

                Items:AddButton({
                    Title    = "Delete",
                    SubTitle = "Refresh List",
                    Callback = function()
                        if selectedConfig then
                            GuiFunc:DeleteConfig(selectedConfig)
                            selectedConfig = nil
                            RefreshList()
                        end
                    end,
                    SubCallback = function()
                        RefreshList()
                    end,
                })

                local AutoSaveToggle
                local initializingAutoSaveToggle = true
                AutoSaveToggle = Items:AddToggle({
                    Title    = "Auto Save",
                    Content  = "Save changes automatically",
                    Default  = AutoSaveEnabled,
                    Save     = false,
                    Callback = function(value)
                        AutoSaveEnabled = value
                        WriteAutoSaveState(value)
                        SetActiveConfig(ActiveConfigName, ActiveConfigPath, AutoSaveEnabled, ActiveConfigMode)
                        
                        
                        if initializingAutoSaveToggle then return end
                        if value then
                            than("Auto Save diaktifkan", 4, GuiConfig.Color, "BolongHub", "Config")
                        else
                            than("Auto Save dimatikan", 4, Color3.fromRGB(255, 170, 0), "BolongHub", "Config")
                        end
                    end,
                })
                initializingAutoSaveToggle = false

                local AccToggle
                local AutoToggle
                local initializingAutoToggle = true
                AutoToggle = Items:AddToggle({
                    Title    = "Auto Load",
                    Content  = autoName ~= "" and ("Auto: " .. autoName) or "Load selected on startup",
                    Default  = autoName ~= "",
                    Save     = false,
                    Callback = function(value)
                        if initializingAutoToggle then return end
                        if value and selectedConfig then
                            GuiFunc:SetAutoLoad(selectedConfig)
                            if AccToggle and AccToggle.Set then AccToggle:Set(false, true) end
                            than("Auto load set to '" .. selectedConfig .. "'", 4, GuiConfig.Color, "BolongHub", "Config")
                        elseif value then
                            GuiFunc:SetAutoLoad("")
                            if AutoToggle then AutoToggle:Set(false, true) end
                            than("Select a config first", 4, Color3.fromRGB(255, 170, 0), "BolongHub", "Config")
                        else
                            GuiFunc:SetAutoLoad("")
                        end
                    end,
                })
                initializingAutoToggle = false

                -- ===== Auto Load Per Akun =====
                local accInfo = GuiFunc:GetAccountAutoLoadInfo()
                local accId = GuiFunc:GetCurrentAccountId()

                local AccStatus = Items:AddParagraph({
                    Title = "Auto Load Per Akun",
                    Content = "Account ID: " .. accId,
                })

                local function UpdateAccStatus()
                    local info = GuiFunc:GetAccountAutoLoadInfo()
                    local bound = tostring(info.Accounts[accId] or "")
                    local text = "Account ID: " .. accId
                    if bound ~= "" then
                        text = text .. "\nBound to: " .. bound
                    else
                        text = text .. "\nNot set, no autoload for this account"
                    end
                    text = text .. "\nStatus: " .. (info.Enabled and "ON" or "OFF")
                    if AccStatus and AccStatus.SetContent then
                        AccStatus:SetContent(text)
                    end
                end
                UpdateAccStatus()

                local initializingAccToggle = true
                AccToggle = Items:AddToggle({
                    Title    = "Enable Per-Account Autoload",
                    Content  = "Load config berbeda per Roblox account / cocok untuk multi-instance di satu device",
                    Default  = accInfo.Enabled == true,
                    Save     = false,
                    Callback = function(value)
                        if initializingAccToggle then return end
                        if not GuiFunc:SetAccountAutoLoadEnabled(value) then
                            if AccToggle then AccToggle:Set(not value, true) end
                            return
                        end
                        if value then
                            if AutoToggle and AutoToggle.Set then AutoToggle:Set(false, true) end
                            than("Per-Account Autoload enabled", 4, GuiConfig.Color, "BolongHub", "Config")
                        end
                        UpdateAccStatus()
                    end,
                })
                initializingAccToggle = false

                local selectedAccConfig = tostring(accInfo.Accounts[accId] or "") ~= ""
                    and tostring(accInfo.Accounts[accId]) or nil

                local AccConfigList = Items:AddDropdown({
                    Title    = "Config untuk Account Ini",
                    Content  = "Pilih config yang akan di-load untuk account " .. accId,
                    Multi    = false,
                    Options  = GuiFunc:GetConfigs(),
                    Default  = selectedAccConfig or "",
                    Save     = false,
                    Callback = function(choice)
                        selectedAccConfig = choice ~= "" and choice or nil
                    end,
                })

                Items:AddButton({
                    Title    = "Set untuk Account Ini",
                    SubTitle = "Clear Binding",
                    Callback = function()
                        if not selectedAccConfig then
                            than("Silakan pilih config terlebih dahulu", 4, Color3.fromRGB(255, 170, 0), "BolongHub", "Config")
                            return
                        end
                        if GuiFunc:SetAccountAutoLoad(accId, selectedAccConfig) then
                            than("Account " .. accId .. " -> '" .. selectedAccConfig .. "'", 4, GuiConfig.Color, "BolongHub", "Config")
                            UpdateAccStatus()
                        end
                    end,
                    SubCallback = function()
                        if GuiFunc:SetAccountAutoLoad(accId, nil) then
                            selectedAccConfig = nil
                            if AccConfigList and AccConfigList.Set then
                                AccConfigList:Set("", true)
                            end
                            than("Binding untuk account " .. accId .. " berhasil dihapus", 4, Color3.fromRGB(255, 170, 0), "BolongHub", "Config")
                            UpdateAccStatus()
                        end
                    end,
                })

                local ImportInput = Items:AddInput({
                    Title       = "Import JSON",
                    Content     = "Paste exported config",
                    Placeholder = "{...}",
                    Save        = false,
                    Callback    = function(text) importJson = text end,
                })

                Items:AddButton({
                    Title    = "Import JSON",
                    SubTitle = "Import from Clipboard",
                    Callback = function()
                        if GuiFunc:ImportConfig(importJson) then
                            RefreshList()
                        end
                    end,
                    SubCallback = function()
                        local clip = (getclipboard and getclipboard()) or ""
                        if GuiFunc:ImportConfig(clip) then
                            RefreshList()
                        end
                    end,
                })

                Items:AddButton({
                    Title    = "Export to Clipboard",
                    Callback = function()
                        GuiFunc:ExportConfig()
                    end,
                })

                task.spawn(function()
                    for _ = 1, 5 do
                        task.wait(1)
                        local list = GuiFunc:GetConfigs()
                        if #list > 0 then
                            RefreshList()
                            if AccConfigList and AccConfigList.SetValues then
                                AccConfigList:SetValues(list, selectedAccConfig or "", true)
                            end
                            break
                        end
                    end
                end)

                return { Refresh = RefreshList }
            end

            function Items:AddBanner(BannerConfig)
                BannerConfig = BannerConfig or {}
                local asset = tostring(BannerConfig.Image or BannerConfig.Banner or "")
                if asset ~= "" and not string.find(asset, "rbxassetid://") then
                    asset = "rbxassetid://" .. asset
                end

                local ratio = BannerConfig.AspectRatio or (16 / 5)

                local Banner = Instance.new("Frame")
                Banner.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
                Banner.BackgroundTransparency = 0.2
                Banner.BorderSizePixel = 0
                Banner.ClipsDescendants = true
                Banner.LayoutOrder = CountItem
                Banner.Size = UDim2.new(1, 0, 0, 110)
                Banner.Name = "Banner"
                Banner.Parent = SectionAdd

                local BannerCorner = Instance.new("UICorner")
                BannerCorner.CornerRadius = UDim.new(0, 8)
                BannerCorner.Parent = Banner

                local function FitHeight()
                    local w = Banner.AbsoluteSize.X
                    if w > 0 then
                        local h = math.floor(w / ratio)
                        if math.abs(Banner.Size.Y.Offset - h) > 1 then
                            Banner.Size = UDim2.new(Banner.Size.X.Scale, Banner.Size.X.Offset, 0, h)
                            UpdateSizeSection()
                        end
                    end
                end

                if asset ~= "" then
                    local Img = Instance.new("ImageLabel")
                    Img.Image = asset
                    Img.BackgroundTransparency = 1
                    Img.ScaleType = Enum.ScaleType.Crop
                    Img.Size = UDim2.new(1, 0, 1, 0)
                    Img.Name = "BannerImage"
                    Img.Parent = Banner
                else
                    local Grad = Instance.new("UIGradient")
                    Grad.Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 22)),
                        ColorSequenceKeypoint.new(0.5, GuiConfig.Color),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 22))
                    }
                    Grad.Rotation = 25
                    Grad.Parent = Banner
                end

                if BannerConfig.Version then
                    local VerPill = Instance.new("Frame")
                    VerPill.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                    VerPill.BackgroundTransparency = 0.35
                    VerPill.BorderSizePixel = 0
                    VerPill.AnchorPoint = Vector2.new(1, 0)
                    VerPill.Position = UDim2.new(1, -8, 0, 8)
                    VerPill.Size = UDim2.new(0, 52, 0, 20)
                    VerPill.ZIndex = 3
                    VerPill.Name = "VersionPill"
                    VerPill.Parent = Banner

                    local VerCorner = Instance.new("UICorner")
                    VerCorner.CornerRadius = UDim.new(0, 10)
                    VerCorner.Parent = VerPill

                    local VerLabel = Instance.new("TextLabel")
                    VerLabel.Font = Enum.Font.GothamBold
                    VerLabel.Text = tostring(BannerConfig.Version)
                    VerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    VerLabel.TextSize = 10
                    VerLabel.BackgroundTransparency = 1
                    VerLabel.Size = UDim2.new(1, 0, 1, 0)
                    VerLabel.ZIndex = 4
                    VerLabel.Parent = VerPill
                end

                Banner:GetPropertyChangedSignal("AbsoluteSize"):Connect(FitHeight)
                task.spawn(function()
                    task.wait()
                    FitHeight()
                end)

                CountItem = CountItem + 1
                return Banner
            end

            function Items:AddCardWidget(CardConfig)
                CardConfig = CardConfig or {}
                local asset = tostring(CardConfig.catwidget or CardConfig.CatWidget or CardConfig.Image or CardConfig.Url or "")
                local ratio = CardConfig.AspectRatio or (1000 / 300)

                local Widget = Instance.new("Frame")
                Widget.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
                Widget.BackgroundTransparency = 0.2
                Widget.BorderSizePixel = 0
                Widget.ClipsDescendants = true
                Widget.LayoutOrder = CountItem
                Widget.Size = UDim2.new(1, 0, 0, 110)
                Widget.Name = "CardWidget"
                Widget.Parent = SectionAdd

                local WidgetCorner = Instance.new("UICorner")
                WidgetCorner.CornerRadius = UDim.new(0, 8)
                WidgetCorner.Parent = Widget

                local function FitHeight()
                    local w = Widget.AbsoluteSize.X
                    if w > 0 then
                        local h = math.floor(w / ratio)
                        if math.abs(Widget.Size.Y.Offset - h) > 1 then
                            Widget.Size = UDim2.new(Widget.Size.X.Scale, Widget.Size.X.Offset, 0, h)
                            UpdateSizeSection()
                        end
                    end
                end

                if asset ~= "" then
                    local Img = Instance.new("ImageLabel")
                    Img.BackgroundTransparency = 1
                    Img.ScaleType = Enum.ScaleType.Fit
                    Img.Size = UDim2.new(1, 0, 1, 0)
                    Img.Name = "CardWidgetImage"
                    Img.Image = ""
                    Img.Parent = Widget

                    local LoadingLabel = Instance.new("TextLabel")
                    LoadingLabel.Font = Enum.Font.Gotham
                    LoadingLabel.Text = "Loading..."
                    LoadingLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
                    LoadingLabel.TextSize = 12
                    LoadingLabel.BackgroundTransparency = 1
                    LoadingLabel.Size = UDim2.new(1, 0, 1, 0)
                    LoadingLabel.Name = "CardWidgetLoading"
                    LoadingLabel.Parent = Widget

                    if asset:match("^rbxassetid://") or asset:match("^rbxasset://") or asset:match("^rbxthumb://") or asset:match("^%d+$") then
                        ApplyIcon(Img, asset, 512)
                        LoadingLabel:Destroy()
                    else
                        task.spawn(function()
                            local loaded = GetWebImageAsset(asset)
                            if Img and Img.Parent then
                                if loaded ~= "" then
                                    Img.Image = loaded
                                else
                                    LoadingLabel.Text = "Failed to load image"
                                    LoadingLabel.TextColor3 = Color3.fromRGB(255, 120, 120)
                                    return
                                end
                            end
                            if LoadingLabel and LoadingLabel.Parent then
                                LoadingLabel:Destroy()
                            end
                        end)
                    end

                    if CardConfig.Callback or CardConfig.Link then
                        local Click = Instance.new("TextButton")
                        Click.BackgroundTransparency = 1
                        Click.AutoButtonColor = false
                        Click.Text = ""
                        Click.Size = UDim2.new(1, 0, 1, 0)
                        Click.ZIndex = 5
                        Click.Name = "ClickArea"
                        Click.Parent = Widget

                        Click.MouseButton1Click:Connect(function()
                            if CardConfig.Callback then
                                pcall(CardConfig.Callback)
                            end
                            if CardConfig.Link then
                                if setclipboard then
                                    pcall(setclipboard, CardConfig.Link)
                                    than("Link copied to clipboard", 4, GuiConfig.Color, "BolongHub", "Widget")
                                end
                            end
                        end)
                    end
                else
                    local Grad = Instance.new("UIGradient")
                    Grad.Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 22)),
                        ColorSequenceKeypoint.new(0.5, GuiConfig.Color),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 22))
                    }
                    Grad.Rotation = 25
                    Grad.Parent = Widget
                end

                Widget:GetPropertyChangedSignal("AbsoluteSize"):Connect(FitHeight)
                task.spawn(function()
                    task.wait()
                    FitHeight()
                end)

                RegisterSearch({ label = CardConfig.Title or "Card Widget", tab = TabConfig.Name, kind = "CardWidget", section = self, switch = SearchSwitch })
                CountItem = CountItem + 1
                return Widget
            end

            function Items:AddCardsWidget(CardsWidget)
                CardsWidget = CardsWidget or {}
                local created = {}
                for _, entry in ipairs(CardsWidget) do
                    created[#created + 1] = Items:AddCardWidget(entry)
                end
                return created
            end

            function Items:AddCard(CardConfig)
                CardConfig = CardConfig or {}
                CardConfig.Title = CardConfig.Title or "Card"
                CardConfig.Description = CardConfig.Description or ""
                local btns = CardConfig.Buttons or {}

                local Card = Instance.new("Frame")
                Card.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Card.BackgroundTransparency = 0.935
                Card.BorderSizePixel = 0
                Card.LayoutOrder = CountItem
                Card.Size = UDim2.new(1, 0, 0, 70)
                Card.Name = "Card"
                Card.Parent = SectionAdd

                local CardCorner = Instance.new("UICorner")
                CardCorner.CornerRadius = UDim.new(0, 6)
                CardCorner.Parent = Card

                local cx = 12
                if CardConfig.Logo and CardConfig.Logo ~= "" then
                    local Logo = Instance.new("ImageLabel")
                    Logo.BackgroundTransparency = 1
                    Logo.ScaleType = Enum.ScaleType.Fit
                    Logo.Position = UDim2.new(0, 12, 0, 14)
                    Logo.Size = UDim2.new(0, 32, 0, 32)
                    Logo.Name = "CardLogo"
                    Logo.Parent = Card
                    ApplyIcon(Logo, CardConfig.Logo, 48)
                    cx = 52
                end

                local CardTitle = Instance.new("TextLabel")
                CardTitle.Font = Enum.Font.GothamBold
                CardTitle.Text = CardConfig.Title
                CardTitle.TextColor3 = Color3.fromRGB(235, 235, 235)
                CardTitle.TextSize = 13
                CardTitle.TextXAlignment = Enum.TextXAlignment.Left
                CardTitle.BackgroundTransparency = 1
                CardTitle.Position = UDim2.new(0, cx, 0, 12)
                CardTitle.Size = UDim2.new(1, -cx - 12, 0, 16)
                CardTitle.Parent = Card

                local measure = Instance.new("TextLabel")
                measure.BackgroundTransparency = 1
                measure.TextWrapped = true
                measure.Size = UDim2.new(1, -cx - 12, 0, 40)
                measure.TextSize = 11
                measure.Font = Enum.Font.Gotham
                measure.Text = CardConfig.Description
                measure.Parent = Card
                local descH = math.max(measure.TextBounds.Y, 20)
                measure:Destroy()

                local btnH = #btns > 0 and 40 or 0
                local padBeforeBtn = #btns > 0 and 18 or 12
                local cardHeight = 32 + descH + padBeforeBtn + btnH

                local CardDesc = Instance.new("TextLabel")
                CardDesc.Font = Enum.Font.Gotham
                CardDesc.Text = CardConfig.Description
                CardDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
                CardDesc.TextSize = 11
                CardDesc.TextXAlignment = Enum.TextXAlignment.Left
                CardDesc.TextYAlignment = Enum.TextYAlignment.Top
                CardDesc.TextWrapped = true
                CardDesc.RichText = true
                CardDesc.BackgroundTransparency = 1
                CardDesc.Position = UDim2.new(0, cx, 0, 32)
                CardDesc.Size = UDim2.new(1, -cx - 12, 0, descH)
                CardDesc.Parent = Card

                Card.Size = UDim2.new(1, 0, 0, cardHeight)

                if #btns > 0 then
                    local Row = Instance.new("Frame")
                    Row.BackgroundTransparency = 1
                    Row.Position = UDim2.new(0, 8, 0, cardHeight - 38)
                    Row.Size = UDim2.new(1, -16, 0, 30)
                    Row.Parent = Card

                    local RowLayout = Instance.new("UIListLayout")
                    RowLayout.FillDirection = Enum.FillDirection.Horizontal
                    RowLayout.Padding = UDim.new(0, 6)
                    RowLayout.Parent = Row

                    local bw = (#btns == 1) and UDim2.new(1, 0, 1, 0) or UDim2.new(0.5, -3, 1, 0)
                    for _, bd in ipairs(btns) do
                        local Btn = Instance.new("TextButton")
                        Btn.Font = Enum.Font.GothamBold
                        Btn.Text = bd.Name or "Button"
                        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                        Btn.TextSize = 11
                        Btn.TextTransparency = 0.2
                        Btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        Btn.BackgroundTransparency = 0.9
                        Btn.BorderSizePixel = 0
                        Btn.Size = bw
                        Btn.Parent = Row

                        local BtnCorner = Instance.new("UICorner")
                        BtnCorner.CornerRadius = UDim.new(0, 6)
                        BtnCorner.Parent = Btn

                        if bd.Callback then
                            Btn.MouseButton1Click:Connect(bd.Callback)
                        end
                    end
                end

                RegisterSearch({ label = CardConfig.Title, tab = TabConfig.Name, kind = "Card", section = self, switch = SearchSwitch })
                CountItem = CountItem + 1
                return Card
            end

function Items:AddDivider()
                local Divider = Instance.new("Frame")
                Divider.Name = "Divider"
                Divider.Parent = SectionAdd
                Divider.Size = UDim2.new(1, 0, 0, 2)
                Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Divider.BackgroundTransparency = 0
                Divider.BorderSizePixel = 0
                Divider.LayoutOrder = CountItem

                local UIGradient = Instance.new("UIGradient")
                UIGradient.Color = ColorSequence.new {
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 22)),
                    ColorSequenceKeypoint.new(0.5, GuiConfig.Color),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 22))
                }
                UIGradient.Parent = Divider

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 2)
                UICorner.Parent = Divider

                CountItem = CountItem + 1
                return Divider
            end

            function Items:AddSubSection(title)
                title = title or "Sub Section"

                local SubSection = Instance.new("Frame")
                SubSection.Name = "SubSection"
                SubSection.Parent = SectionAdd
                SubSection.BackgroundTransparency = 1
                SubSection.Size = UDim2.new(1, 0, 0, 22)
                SubSection.LayoutOrder = CountItem

                local Background = Instance.new("Frame")
                Background.Parent = SubSection
                Background.Size = UDim2.new(1, 0, 1, 0)
                Background.BackgroundColor3 = THEME.surface
                Background.BackgroundTransparency = 0.45
                Background.BorderSizePixel = 0
                Instance.new("UICorner", Background).CornerRadius = UDim.new(0, THEME.radius.sm)

                local Label = Instance.new("TextLabel")
                Label.Parent = SubSection
                Label.AnchorPoint = Vector2.new(0, 0.5)
                Label.Position = UDim2.new(0, 10, 0.5, 0)
                Label.Size = UDim2.new(1, -20, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Font = THEME.fontTitle
                Label.Text = string.upper(title)
                Label.TextColor3 = THEME.muted
                Label.TextSize = 11
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.TextTransparency = 0.35

                CountItem = CountItem + 1
                return SubSection
            end

            function Items:AddSpace(SpaceConfig)
                SpaceConfig = SpaceConfig or {}
                local Space = Instance.new("Frame")
                Space.Name = "Space"
                Space.BackgroundTransparency = 1
                Space.BorderSizePixel = 0
                Space.LayoutOrder = CountItem
                Space.Size = UDim2.new(0, SpaceConfig.Width or 12, 0, SpaceConfig.Height or 8)
                Space.Parent = SectionAdd

                CountItem = CountItem + 1
                return Space
            end

            function Items:AddHStack(StackConfig)
                StackConfig = StackConfig or {}
                local Padding = StackConfig.Padding or 6
                local FixedHeight = StackConfig.Height
                local Sizing = StackConfig.Sizing or "Equal"
                local HorizontalAlignment = StackConfig.HorizontalAlignment or Enum.HorizontalAlignment.Left
                local VerticalAlignment = StackConfig.VerticalAlignment or Enum.VerticalAlignment.Center

                local Stack = Instance.new("Frame")
                Stack.Name = "HStack"
                Stack.BackgroundTransparency = 1
                Stack.BorderSizePixel = 0
                Stack.LayoutOrder = CountItem
                Stack.Size = UDim2.new(1, 0, 0, FixedHeight or 0)
                Stack.Parent = SectionAdd

                local StackLayout = Instance.new("UIListLayout")
                StackLayout.FillDirection = Enum.FillDirection.Horizontal
                StackLayout.Padding = UDim.new(0, Padding)
                StackLayout.HorizontalAlignment = HorizontalAlignment
                StackLayout.VerticalAlignment = VerticalAlignment
                StackLayout.SortOrder = Enum.SortOrder.LayoutOrder
                StackLayout.Parent = Stack

                if not FixedHeight then
                    local function UpdateStackHeight()
                        Stack.Size = UDim2.new(1, 0, 0, StackLayout.AbsoluteContentSize.Y)
                        UpdateSizeSection()
                    end
                    StackLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateStackHeight)
                end

                local EqualHeight = StackConfig.EqualHeight
                if EqualHeight == nil then EqualHeight = true end
                local heightConnections = {}
                local syncingHeight = false

                local function RecalculateHeights()
                    if not EqualHeight or syncingHeight then return end
                    syncingHeight = true

                    local maxHeight = 0
                    local contentChildren = {}
                    for _, child in ipairs(Stack:GetChildren()) do
                        if child:IsA("GuiObject") and child.Name ~= "Space" then
                            table.insert(contentChildren, child)
                            if child.Size.Y.Offset > maxHeight then
                                maxHeight = child.Size.Y.Offset
                            end
                        end
                    end

                    for _, child in ipairs(contentChildren) do
                        if child.Size.Y.Offset ~= maxHeight then
                            child.Size = UDim2.new(child.Size.X.Scale, child.Size.X.Offset, 0, maxHeight)
                        end
                    end

                    syncingHeight = false
                end
                local heightsPending = false
                local function ScheduleRecalculateHeights()
                    if heightsPending then return end
                    heightsPending = true
                    task.defer(function()
                        heightsPending = false
                        RecalculateHeights()
                    end)
                end

                if Sizing == "Equal" then
                    local function RecalculateWidths()
                        local contentChildren, allChildrenCount, spaceOffsetTotal = {}, 0, 0
                        for _, child in ipairs(Stack:GetChildren()) do
                            if child:IsA("GuiObject") then
                                allChildrenCount = allChildrenCount + 1
                                if child.Name == "Space" then
                                    spaceOffsetTotal = spaceOffsetTotal + child.Size.X.Offset
                                else
                                    table.insert(contentChildren, child)
                                end
                            end
                        end
                        local count = #contentChildren
                        if count == 0 then return end
                        local totalPadding = Padding * math.max(allChildrenCount - 1, 0)
                        local extraOffset = -(totalPadding + spaceOffsetTotal)
                        for _, child in ipairs(contentChildren) do
                            child.Size = UDim2.new(1 / count, extraOffset / count, child.Size.Y.Scale,
                                child.Size.Y.Offset)
                        end
                    end
                    local widthsPending = false
                    local function ScheduleRecalculateWidths()
                        if widthsPending then return end
                        widthsPending = true
                        task.defer(function()
                            widthsPending = false
                            RecalculateWidths()
                        end)
                    end
                    Stack.ChildAdded:Connect(function(child)
                        if child:IsA("GuiObject") then
                            ScheduleRecalculateWidths()
                        end
                    end)
                    Stack.ChildRemoved:Connect(function(child)
                        if child:IsA("GuiObject") then
                            ScheduleRecalculateWidths()
                        end
                    end)
                end

                Stack.ChildAdded:Connect(function(child)
                    if child:IsA("GuiObject") then
                        heightConnections[child] = child:GetPropertyChangedSignal("Size"):Connect(function()
                            ScheduleRecalculateHeights()
                        end)
                        ScheduleRecalculateHeights()
                    end
                end)
                Stack.ChildRemoved:Connect(function(child)
                    if heightConnections[child] then
                        heightConnections[child]:Disconnect()
                        heightConnections[child] = nil
                    end
                    ScheduleRecalculateHeights()
                end)

                CountItem = CountItem + 1
                return BuildItemsAPI(Stack)
            end

            function Items:AddVStack(StackConfig)
                StackConfig = StackConfig or {}
                local Padding = StackConfig.Padding or 3
                local HorizontalAlignment = StackConfig.HorizontalAlignment or Enum.HorizontalAlignment.Left
                local VerticalAlignment = StackConfig.VerticalAlignment or Enum.VerticalAlignment.Top

                local Stack = Instance.new("Frame")
                Stack.Name = "VStack"
                Stack.BackgroundTransparency = 1
                Stack.BorderSizePixel = 0
                Stack.LayoutOrder = CountItem
                Stack.Size = UDim2.new(1, 0, 0, 0)
                Stack.Parent = SectionAdd

                local StackLayout = Instance.new("UIListLayout")
                StackLayout.FillDirection = Enum.FillDirection.Vertical
                StackLayout.Padding = UDim.new(0, Padding)
                StackLayout.HorizontalAlignment = HorizontalAlignment
                StackLayout.VerticalAlignment = VerticalAlignment
                StackLayout.SortOrder = Enum.SortOrder.LayoutOrder
                StackLayout.Parent = Stack

                local function UpdateStackHeight()
                    Stack.Size = UDim2.new(1, 0, 0, StackLayout.AbsoluteContentSize.Y)
                    UpdateSizeSection()
                end
                StackLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateStackHeight)

                CountItem = CountItem + 1
                return BuildItemsAPI(Stack)
            end

            function Items:AddPresetManager(PresetConfig)
                local PresetConfig = PresetConfig or {}
                PresetConfig.Title = PresetConfig.Title or "Preset Manager"
                PresetConfig.Content = PresetConfig.Content or "Save and load values"
                PresetConfig.Placeholder = PresetConfig.Placeholder or "Enter value..."
                PresetConfig.Default = PresetConfig.Default or ""
                PresetConfig.Callback = PresetConfig.Callback or function() end
                
                local configKey = "PresetManager_" .. PresetConfig.Title
                local shouldSave = PresetConfig.Save ~= false

                local presetFilePath = GameConfigFolder .. "/presets.json"
                local presetFileData = { Presets = {}, Value = "", SelectedPreset = "" }

                local function LoadPresetFile()
                    if not isfile then return end
                    if isfile(presetFilePath) then
                        local ok, data = pcall(function()
                            return HttpService:JSONDecode(readfile(presetFilePath))
                        end)
                        if ok and type(data) == "table" then
                            presetFileData.Presets = type(data.Presets) == "table" and data.Presets or {}
                            presetFileData.Value = tostring(data.Value or "")
                            presetFileData.SelectedPreset = tostring(data.SelectedPreset or "")
                        end
                    end
                end

                
                LoadPresetFile()

                
                local presets = PresetConfig.Presets or {}
                
                for k, v in pairs(presetFileData.Presets) do
                    presets[k] = v
                end

                local savedValue = presetFileData.Value ~= "" and presetFileData.Value or PresetConfig.Default
                local savedSelectedPreset = presetFileData.SelectedPreset

                
                local PresetFunc = { Value = savedValue, Presets = presets }
                local currentPresetName = savedSelectedPreset

                local function SavePresetFile()
                    if not writefile then return end
                    
                    presetFileData.Value = PresetFunc.Value or ""
                    presetFileData.SelectedPreset = currentPresetName or ""
                    presetFileData.Presets = PresetFunc.Presets or {}
                    
                    local ok, encoded = pcall(function()
                        return HttpService:JSONEncode(presetFileData)
                    end)
                    if ok then
                        writefile(presetFilePath, encoded)
                    end
                end

                
                local PresetDropdown
                local RefreshDropdown

                
                local Card = Instance.new("Frame")
                Card.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Card.BackgroundTransparency = 0.935
                Card.BorderSizePixel = 0
                Card.LayoutOrder = CountItem
                Card.Size = UDim2.new(1, 0, 0, 0)
                Card.Name = "PresetManagerCard"
                Card.Parent = SectionAdd
                
                local CardCorner = Instance.new("UICorner")
                CardCorner.CornerRadius = UDim.new(0, 6)
                CardCorner.Parent = Card
                
                local CardLayout = Instance.new("UIListLayout")
                CardLayout.Padding = UDim.new(0, 8)
                CardLayout.SortOrder = Enum.SortOrder.LayoutOrder
                CardLayout.Parent = Card
                
                local CardPadding = Instance.new("UIPadding")
                CardPadding.PaddingTop = UDim.new(0, 12)
                CardPadding.PaddingBottom = UDim.new(0, 12)
                CardPadding.PaddingLeft = UDim.new(0, 12)
                CardPadding.PaddingRight = UDim.new(0, 12)
                CardPadding.Parent = Card
                
                local sizeQueued = false
                local function UpdateCardSize()
                    if sizeQueued then return end
                    sizeQueued = true
                    task.defer(function()
                        sizeQueued = false
                        Card.Size = UDim2.new(1, 0, 0, CardLayout.AbsoluteContentSize.Y + 24)
                        UpdateSizeSection()
                    end)
                end
                CardLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCardSize)

                local TitleLabel = Instance.new("TextLabel")
                TitleLabel.Font = Enum.Font.GothamBold
                TitleLabel.Text = PresetConfig.Title
                TitleLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
                TitleLabel.TextSize = 13
                TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
                TitleLabel.BackgroundTransparency = 1
                TitleLabel.Size = UDim2.new(1, 0, 0, 16)
                TitleLabel.Parent = Card

                local function CreateModernInput(placeholder)
                    local InputFrame = Instance.new("Frame")
                    InputFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                    InputFrame.BackgroundTransparency = 0.2
                    InputFrame.BorderSizePixel = 0
                    InputFrame.Size = UDim2.new(1, 0, 0, 34)
                    InputFrame.Parent = Card

                    local Corner = Instance.new("UICorner")
                    Corner.CornerRadius = UDim.new(0, 6)
                    Corner.Parent = InputFrame

                    local Stroke = Instance.new("UIStroke")
                    Stroke.Color = Color3.fromRGB(60, 60, 60)
                    Stroke.Transparency = 0.5
                    Stroke.Parent = InputFrame

                    local Box = Instance.new("TextBox")
                    Box.Font = Enum.Font.GothamBold
                    Box.PlaceholderText = placeholder
                    Box.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
                    Box.Text = ""
                    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Box.TextSize = 12
                    Box.ClearTextOnFocus = false
                    Box.TextXAlignment = Enum.TextXAlignment.Left
                    Box.BackgroundTransparency = 1
                    Box.Position = UDim2.new(0, 10, 0, 0)
                    Box.Size = UDim2.new(1, -20, 1, 0)
                    Box.Parent = InputFrame
                    return Box
                end

                local ValueBox = CreateModernInput(PresetConfig.Placeholder)
                ValueBox.Text = savedValue
                PresetFunc.Value = savedValue

                ValueBox.FocusLost:Connect(function()
                    PresetFunc.Value = ValueBox.Text
                    PresetConfig.Callback(ValueBox.Text)
                    SavePresetFile()
                end)

                function PresetFunc:Set(value, noSave)
                    if type(value) == "table" then
                        
                        return
                    end

                    ValueBox.Text = tostring(value or "")
                    PresetFunc.Value = ValueBox.Text
                    PresetConfig.Callback(PresetFunc.Value)
                    if not noSave then
                        SavePresetFile()
                    end
                end

                PresetDropdown = Items:AddDropdown({
                    Title = "Saved Presets",
                    Content = "Pilih preset untuk dimuat",
                    Options = {},
                    Default = nil,
                    Save = false,
                    Callback = function(selectedName)
                        currentPresetName = selectedName
                        if selectedName and selectedName ~= "" then
                            if PresetFunc.Presets[selectedName] then
                                ValueBox.Text = tostring(PresetFunc.Presets[selectedName])
                                PresetFunc.Value = ValueBox.Text
                                PresetConfig.Callback(PresetFunc.Value)
                                SavePresetFile()
                            end
                        end
                    end
                })

                local DropUI
                for _, child in ipairs(SectionAdd:GetChildren()) do
                    if child.Name == "Dropdown" then
                        local title = child:FindFirstChild("DropdownTitle")
                        if title and title.Text == "Saved Presets" then
                            DropUI = child
                            break
                        end
                    end
                end

                if DropUI then
                    DropUI.Parent = Card
                    DropUI.LayoutOrder = 2
                    DropUI.BackgroundTransparency = 1
                    DropUI.Size = UDim2.new(1, 0, 0, 34)
                    
                    local SelectFrame = DropUI:FindFirstChild("SelectOptionsFrame")
                    if SelectFrame then
                        SelectFrame.AnchorPoint = Vector2.new(0, 0)
                        SelectFrame.Position = UDim2.new(0, 0, 0, 0)
                        SelectFrame.Size = UDim2.new(1, 0, 1, 0)
                        SelectFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                        SelectFrame.BackgroundTransparency = 0.2
                        
                        Instance.new("UICorner", SelectFrame).CornerRadius = UDim.new(0, 6)
                        local SStroke = Instance.new("UIStroke", SelectFrame)
                        SStroke.Color = Color3.fromRGB(60, 60, 60)
                        SStroke.Transparency = 0.5
                        
                        local OptText = SelectFrame:FindFirstChild("OptionSelecting")
                        if OptText then
                            OptText.AnchorPoint = Vector2.new(0, 0.5)
                            OptText.Position = UDim2.new(0, 10, 0.5, 0)
                            OptText.Size = UDim2.new(1, -40, 1, -8)
                            OptText.Font = Enum.Font.GothamBold
                            OptText.TextSize = 12
                            OptText.TextColor3 = Color3.fromRGB(200, 200, 200)
                            OptText.TextXAlignment = Enum.TextXAlignment.Left
                        end
                        
                        local OptImg = SelectFrame:FindFirstChild("OptionImg")
                        if OptImg then
                            OptImg.AnchorPoint = Vector2.new(1, 0.5)
                            OptImg.Position = UDim2.new(1, -10, 0.5, 0)
                            OptImg.Size = UDim2.new(0, 16, 0, 16)
                        end
                    end
                    
                    local DTitle = DropUI:FindFirstChild("DropdownTitle")
                    local DContent = DropUI:FindFirstChild("DropdownContent")
                    if DTitle then DTitle.Visible = false end
                    if DContent then DContent.Visible = false end
                end

                RefreshDropdown = function()
                    local names = {}
                    for name, _ in pairs(PresetFunc.Presets) do
                        table.insert(names, name)
                    end
                    table.sort(names)
                    if PresetDropdown and PresetDropdown.SetValues then
                        PresetDropdown:SetValues(names, currentPresetName ~= "" and currentPresetName or nil, true)
                    end
                end
                RefreshDropdown()

                local OptHeader = Instance.new("TextButton")
                OptHeader.BackgroundTransparency = 1
                OptHeader.Size = UDim2.new(1, 0, 0, 24)
                OptHeader.Text = ""
                OptHeader.LayoutOrder = 3
                OptHeader.Parent = Card
                
                local OptTitle = Instance.new("TextLabel")
                OptTitle.Font = Enum.Font.GothamBold
                OptTitle.Text = "Pengaturan Preset (Save / Delete)"
                OptTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
                OptTitle.TextSize = 12
                OptTitle.TextXAlignment = Enum.TextXAlignment.Left
                OptTitle.BackgroundTransparency = 1
                OptTitle.AnchorPoint = Vector2.new(0, 0.5)
                OptTitle.Position = UDim2.new(0, 4, 0.5, 0)
                OptTitle.Size = UDim2.new(1, -20, 0, 14)
                OptTitle.Parent = OptHeader
                
                local OptArrow = Instance.new("ImageLabel")
                OptArrow.Image = "rbxassetid://16851841101"
                OptArrow.Rotation = -90
                OptArrow.AnchorPoint = Vector2.new(1, 0.5)
                OptArrow.Position = UDim2.new(1, -4, 0.5, 0)
                OptArrow.Size = UDim2.new(0, 16, 0, 16)
                OptArrow.BackgroundTransparency = 1
                OptArrow.Parent = OptHeader
                
                local OptContainer = Instance.new("Frame")
                OptContainer.BackgroundTransparency = 1
                OptContainer.Size = UDim2.new(1, 0, 0, 0)
                OptContainer.ClipsDescendants = true
                OptContainer.LayoutOrder = 4
                OptContainer.Parent = Card
                
                local OptLayout = Instance.new("UIListLayout")
                OptLayout.Padding = UDim.new(0, 8)
                OptLayout.SortOrder = Enum.SortOrder.LayoutOrder
                OptLayout.Parent = OptContainer
                
                local isOptOpen = false
                OptHeader.MouseButton1Click:Connect(function()
                    CircleClick(OptHeader, Mouse.X, Mouse.Y)
                    isOptOpen = not isOptOpen
                    if isOptOpen then
                        OptArrow.Rotation = 0
                        TweenService:Create(OptContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, OptLayout.AbsoluteContentSize.Y) }):Play()
                    else
                        OptArrow.Rotation = -90
                        TweenService:Create(OptContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, 0) }):Play()
                    end
                    task.delay(0.35, UpdateCardSize)
                end)
                
                local NameBoxFrame = Instance.new("Frame")
                NameBoxFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                NameBoxFrame.BackgroundTransparency = 0.2
                NameBoxFrame.BorderSizePixel = 0
                NameBoxFrame.Size = UDim2.new(1, 0, 0, 34)
                NameBoxFrame.Parent = OptContainer
                
                Instance.new("UICorner", NameBoxFrame).CornerRadius = UDim.new(0, 6)
                local NStroke = Instance.new("UIStroke", NameBoxFrame)
                NStroke.Color = Color3.fromRGB(60, 60, 60)
                NStroke.Transparency = 0.5
                
                local NameBox = Instance.new("TextBox")
                NameBox.Font = Enum.Font.GothamBold
                NameBox.PlaceholderText = "Preset Name (e.g. Avatar 1)"
                NameBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
                NameBox.Text = savedSelectedPreset
                NameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                NameBox.TextSize = 12
                NameBox.ClearTextOnFocus = false
                NameBox.TextXAlignment = Enum.TextXAlignment.Left
                NameBox.BackgroundTransparency = 1
                NameBox.Position = UDim2.new(0, 10, 0, 0)
                NameBox.Size = UDim2.new(1, -20, 1, 0)
                NameBox.Parent = NameBoxFrame
                NameBox.FocusLost:Connect(function() currentPresetName = NameBox.Text end)
                
                local BtnRow = Instance.new("Frame")
                BtnRow.BackgroundTransparency = 1
                BtnRow.Size = UDim2.new(1, 0, 0, 34)
                BtnRow.Parent = OptContainer
                
                local BtnLayout = Instance.new("UIListLayout")
                BtnLayout.FillDirection = Enum.FillDirection.Horizontal
                BtnLayout.Padding = UDim.new(0, 8)
                BtnLayout.SortOrder = Enum.SortOrder.LayoutOrder
                BtnLayout.Parent = BtnRow
                
                local function CreateBtn(text, bgColor, callback)
                    local Btn = Instance.new("TextButton")
                    Btn.Font = Enum.Font.GothamBold
                    Btn.Text = text
                    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Btn.TextSize = 12
                    Btn.TextTransparency = 0.1
                    Btn.BackgroundColor3 = bgColor
                    Btn.Size = UDim2.new(0.5, -4, 1, 0)
                    Btn.AutoButtonColor = false
                    Btn.Parent = BtnRow
                    
                    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
                    local BtnStroke = Instance.new("UIStroke", Btn)
                    BtnStroke.Color = Color3.fromRGB(60, 60, 60)
                    BtnStroke.Transparency = 0.5
                    
                    Btn.MouseEnter:Connect(function()
                        TweenService:Create(Btn, TweenInfo.new(0.15), { BackgroundColor3 = bgColor:lerp(Color3.fromRGB(255, 255, 255), 0.1) }):Play()
                    end)
                    Btn.MouseLeave:Connect(function()
                        TweenService:Create(Btn, TweenInfo.new(0.15), { BackgroundColor3 = bgColor }):Play()
                    end)
                    
                    Btn.Activated:Connect(function()
                        CircleClick(Btn, Mouse.X, Mouse.Y)
                        callback()
                    end)
                end
                
                CreateBtn("Save", Color3.fromRGB(40, 40, 40), function()
                    if currentPresetName == "" or not currentPresetName then
                        than("Masukkan nama preset terlebih dahulu!", 3, Color3.fromRGB(255, 170, 0), "BolongHub", "Preset")
                        return
                    end
                    PresetFunc.Presets[currentPresetName] = PresetFunc.Value
                    SavePresetFile()
                    RefreshDropdown()
                    PresetDropdown:Set(currentPresetName)
                    than("Preset '" .. currentPresetName .. "' disimpan!", 3, GuiConfig.Color, "BolongHub", "Preset")
                end)
                
                CreateBtn("Delete", Color3.fromRGB(60, 25, 25), function()
                    if currentPresetName == "" or not currentPresetName then return end
                    if PresetFunc.Presets[currentPresetName] then
                        PresetFunc.Presets[currentPresetName] = nil
                        SavePresetFile()
                        currentPresetName = ""
                        NameBox.Text = ""
                        RefreshDropdown()
                        than("Preset berhasil dihapus.", 3, Color3.fromRGB(255, 170, 0), "BolongHub", "Preset")
                    else
                        than("Preset tidak ditemukan.", 3, Color3.fromRGB(255, 90, 90), "BolongHub", "Preset")
                    end
                end)

                
                if shouldSave then
                    Elements[configKey] = { Set = function() end }
                end

                UpdateCardSize()
                CountItem = CountItem + 1
                RegisterSearch({ label = PresetConfig.Title, tab = TabConfig.Name, kind = "PresetManager", element = PresetFunc, section = self, switch = SearchSwitch })
                return PresetFunc
            end

            return Items
            end

            local Items = BuildItemsAPI(SectionAdd)

            Items.SectionTitle = Title
            Items.LayoutOrder = Tab.LayoutOrder
            Items.ScrolLayers = ScrolLayers
            Items.sectionFrame = Section
            function Items:GetOpen() return SectionHandle.open end
            function Items:SetOpen(open)
                open = open and true or false
                SectionHandle.open = open
                OpenSection = open
                if open then
                    TweenService:Create(FeatureFrame, TweenInfo.new(0.5), { Rotation = 90 }):Play()
                    UpdateSizeSection()
                else
                    TweenService:Create(FeatureFrame, TweenInfo.new(0.5), { Rotation = 0 }):Play()
                    TweenService:Create(Section, TweenInfo.new(0.5), { Size = UDim2.new(1, 1, 0, 30) }):Play()
                    TweenService:Create(SectionDecideFrame, TweenInfo.new(0.5), { Size = UDim2.new(0, 0, 0, 2) })
                        :Play()
                    task.delay(0.5, UpdateSizeScroll)
                end
            end
            function Items:Flash()
                local sr = Section:FindFirstChild("SectionReal")
                if not sr then return end
                local baseBg = sr.BackgroundColor3
                local baseTrans = sr.BackgroundTransparency
                TweenService:Create(sr, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    { BackgroundColor3 = GuiConfig.Color, BackgroundTransparency = 0.45 }):Play()
                task.delay(0.35, function()
                    TweenService:Create(sr, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                        { BackgroundColor3 = baseBg, BackgroundTransparency = baseTrans }):Play()
                end)
            end

            CountSection = CountSection + 1
            return Items
        end

        CountTab = CountTab + 1
        return Sections
    end

    function Tabs:InfoTab(InfoConfig)
    InfoConfig = InfoConfig or {}
    local Sections = Tabs:AddTab({
        Name = InfoConfig.Name or "Info",
        Icon = InfoConfig.Icon or "lightbulb",
    })
    local Items = Sections:AddSection(InfoConfig.SectionTitle or "Information", true)

    if InfoConfig.Banner and InfoConfig.Banner ~= "" then
        Items:AddBanner({
            Image = InfoConfig.Banner,
            Version = InfoConfig.Version,
            AspectRatio = InfoConfig.BannerAspectRatio,
        })
    end

    if InfoConfig.DiscordLink then
        local fullDescription = InfoConfig.DiscordText or "Support, updates and announcements."
        if InfoConfig.DiscordDesc and InfoConfig.DiscordDesc ~= "" then
            fullDescription = fullDescription .. "\n" .. InfoConfig.DiscordDesc
        end
        
        Items:AddCard({
            Title = InfoConfig.DiscordName or "Community",
            Description = fullDescription,
            Logo = discord_logo_asset_id,
            Buttons = {
                {
                    Name = "Copy Invite",
                    Callback = function()
                        if setclipboard then
                            setclipboard(InfoConfig.DiscordLink)
                            than("Discord invite copied", 4, GuiConfig.Color, "BolongHub", "Community")
                        end
                    end,
                },
            },
        })
    end

    for _, card in ipairs(InfoConfig.Cards or {}) do
        Items:AddCard(card)
    end

    for _, widget in ipairs(InfoConfig.CardsWidget or {}) do
        Items:AddCardWidget(widget)
    end

    return Sections, Items
  end

    GuiFunc.InfoTab = function(_, cfg) return Tabs:InfoTab(cfg) end
    Tabs.Window = GuiFunc
    Tabs.ExportConfig = function() return GuiFunc:ExportConfig() end
    Tabs.ImportConfig = function(_, str) return GuiFunc:ImportConfig(str) end

    if GuiConfig.Search then
        UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            local ctrl = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
                or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
                or UserInputService:IsKeyDown(Enum.KeyCode.LeftMeta)
                or UserInputService:IsKeyDown(Enum.KeyCode.RightMeta)
            local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
                or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
            if ctrl and shift and input.KeyCode == Enum.KeyCode.F then
                if DropShadowHolder then DropShadowHolder.Visible = true end
                if GuiFunc.FocusSearch then GuiFunc.FocusSearch() end
            elseif ctrl and input.KeyCode == Enum.KeyCode.O then
                if DropShadowHolder then DropShadowHolder.Visible = true end
                if GuiFunc.FocusSearch then GuiFunc.FocusSearch() end
            end
        end)
    end

    task.spawn(function()
        task.wait(0.5)

        local targetName = ""
        local accountInfo = GetAccountAutoLoadInfo()
        if accountInfo.Enabled then
            local bound = tostring(accountInfo.Accounts[GetCurrentAccountId()] or "")
            if bound ~= "" then
                targetName = bound
            end
        else
            targetName = GuiFunc:GetAutoLoad()
        end

        if not targetName or targetName == "" then return end

        for attempt = 1, 4 do
            if GuiFunc:LoadConfigByName(targetName) then
                if attempt > 1 then
                    than("Config '" .. targetName .. "' dimuat (percobaan ke-" .. attempt .. ")", 4,
                        Color3.fromRGB(255, 170, 0), "BolongHub", "Config")
                end
                return
            end
            task.wait(1)
        end

        than("Gagal auto load '" .. targetName .. "' setelah beberapa percobaan", 6,
            Color3.fromRGB(255, 90, 90), "BolongHub", "Config")
    end)

    return Tabs
end

return Chloex
