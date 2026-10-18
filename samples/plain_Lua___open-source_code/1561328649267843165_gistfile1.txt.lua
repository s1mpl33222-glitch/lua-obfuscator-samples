-- [[ NIXI HUB | MONOCHROME - KEY SYSTEM & MULTILANG EDITION ]] --

task.spawn(function()

local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
local Players = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local TweenService = cloneref and cloneref(game:GetService("TweenService")) or game:GetService("TweenService")
local HttpService = cloneref and cloneref(game:GetService("HttpService")) or game:GetService("HttpService")
local Workspace = cloneref and cloneref(game:GetService("Workspace")) or game:GetService("Workspace")
local RunService = cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
local Lighting = cloneref and cloneref(game:GetService("Lighting")) or game:GetService("Lighting")
local UserInputService = cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
local ProximityPromptService = cloneref and cloneref(game:GetService("ProximityPromptService")) or game:GetService("ProximityPromptService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- =========================================================================
--             1. ВАЙТ-ЛИСТ И НАСТРОЙКИ КЛЮЧЕВОЙ СИСТЕМЫ
-- =========================================================================
local GIST_ID = "7c0d14663809f6e3e567203572071ea3"
local GIST_USER = "nixirbx"
local BOT_LINK = "https://t.me/nixikeybot"
local KEY_FILE = "monochrome_nixi_key.txt"

-- Roblox UserId игроков, у которых ключ пропускается автоматически:
local WHITELIST_IDS = {
    1
}

local function IsWhitelisted(userId)
    if not userId then return false end
    for _, id in ipairs(WHITELIST_IDS) do
        if tonumber(id) == tonumber(userId) then
            return true
        end
    end
    return false
end

-- =========================================================================
--             2. ЗАЩИТА ОТ ПОВТОРНОГО ИНЖЕКТА (ОЧИСТКА ОКНА И ЦИКЛОВ)
-- =========================================================================
if getgenv().MONOCHROME_NIXI_CLEANUP and type(getgenv().MONOCHROME_NIXI_CLEANUP) == "function" then
    pcall(getgenv().MONOCHROME_NIXI_CLEANUP)
    getgenv().MONOCHROME_NIXI_CLEANUP = nil
end

local function PurgeAllExistingUI()
    local targets = { CoreGui, LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") }
    if gethui then
        pcall(function() table.insert(targets, gethui()) end)
    end
    for _, container in ipairs(targets) do
        if container then
            for _, child in ipairs(container:GetChildren()) do
                if child.Name == "NIXI_SquareKeySystem"
                   or child.Name == "NIXI_LangSelect"
                   or child.Name == "Nixi_RadarVER"
                   or child.Name == "Obsidian" then
                    pcall(function() child:Destroy() end)
                end
            end
        end
    end
end
pcall(PurgeAllExistingUI)

-- =========================================================================
--             3. ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ДЛЯ КЛЮЧА
-- =========================================================================
local function CleanKeyString(str)
    if not str or type(str) ~= "string" then return "" end
    str = str:gsub("^\239\187\191", ""):gsub("\239\187\191", "")
    str = str:gsub("\226\128\139", ""):gsub("\226\128\140", ""):gsub("\226\128\141", "")
    str = str:gsub("\226\128\142", ""):gsub("\226\128\143", "")
    str = str:gsub("\194\160", "")
    str = str:gsub('["\'`]', "")
    str = str:gsub("[%s%c]+", "")
    return str
end

local function ExtractKeysFromGist(rawText)
    if not rawText or type(rawText) ~= "string" then return {} end
    local list = {}
    
    local fullClean = CleanKeyString(rawText)
    if #fullClean > 0 then
        table.insert(list, fullClean:lower())
    end

    for line in rawText:gmatch("[^\r\n]+") do
        local l = line:gsub("^%s*[%-%-#/]+%s*", "")
        l = l:gsub("^[%w_]+%s*[:=]%s*", "")
        l = CleanKeyString(l)
        if #l > 0 then
            table.insert(list, l:lower())
        end
    end

    for word in rawText:gmatch("[%w%-%._]+") do
        local w = CleanKeyString(word)
        if #w >= 3 and not w:lower():find("^http") and w:lower() ~= "raw" then
            table.insert(list, w:lower())
        end
    end

    return list
end

local function IsKeyValid(entered, rawGistContent)
    if not entered or not rawGistContent then return false end
    local cleanEntered = CleanKeyString(entered):lower()
    if #cleanEntered == 0 then return false end

    local keys = ExtractKeysFromGist(rawGistContent)
    for _, k in ipairs(keys) do
        if cleanEntered == k then
            return true
        end
    end

    if #cleanEntered >= 3 then
        local rawLower = CleanKeyString(rawGistContent):lower()
        if rawLower:find(cleanEntered, 1, true) then
            return true
        end
    end

    return false
end

local function HttpGetRaw(url)
    if game.HttpGet then
        local ok, body = pcall(function() return game:HttpGet(url, true) end)
        if ok and type(body) == "string" and #body > 0 then return body end
        local ok2, body2 = pcall(function() return game:HttpGet(url) end)
        if ok2 and type(body2) == "string" and #body2 > 0 then return body2 end
    end

    local req = (syn and syn.request) or request or http_request
    if req then
        local ok, res = pcall(req, {
            Url = url,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
                ["Cache-Control"] = "no-cache, no-store, must-revalidate",
                ["Pragma"] = "no-cache"
            }
        })
        if ok and res and res.Body and (res.StatusCode == 200 or res.StatusCode == nil) then
            return res.Body
        end
    end
    return nil
end

local function FetchGistKey()
    -- 1. GitHub REST API (без кэша)
    local apiUrl = "https://api.github.com/gists/" .. GIST_ID
    local req = (syn and syn.request) or request or http_request
    if req then
        local ok, res = pcall(req, {
            Url = apiUrl,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "RobloxKeyClient/2.0",
                ["Accept"] = "application/vnd.github.v3+json"
            }
        })
        if ok and res and res.Body and res.StatusCode == 200 then
            local decodeOk, data = pcall(function() return HttpService:JSONDecode(res.Body) end)
            if decodeOk and data and type(data.files) == "table" then
                for _, fileData in pairs(data.files) do
                    if fileData.content and #fileData.content > 0 then
                        return fileData.content
                    end
                end
            end
        end
    end

    -- 2. Raw URL с антикэшем
    local cacheBuster = "?nocache=" .. tostring(os.time()) .. "_" .. tostring(math.random(1000, 9999))
    local rawUrls = {
        "https://gist.githubusercontent.com/" .. GIST_USER .. "/" .. GIST_ID .. "/raw/gistfile1.txt",
        "https://gist.githubusercontent.com/" .. GIST_USER .. "/" .. GIST_ID .. "/raw",
        "https://gist.github.com/" .. GIST_USER .. "/" .. GIST_ID .. "/raw"
    }

    for _, u in ipairs(rawUrls) do
        local body = HttpGetRaw(u .. cacheBuster)
        if body and type(body) == "string" and #body > 0 then
            local lower = body:lower()
            if not lower:find("404: not found", 1, true) and not lower:find("<!doctype", 1, true) and not lower:find("<html", 1, true) then
                return body
            end
        end
    end

    -- 3. Публичный веб-прокси (обход блокировок)
    local proxyUrl = "https://api.allorigins.win/raw?url=" .. HttpService:UrlEncode("https://gist.githubusercontent.com/" .. GIST_USER .. "/" .. GIST_ID .. "/raw?" .. tostring(os.time()))
    local proxyBody = HttpGetRaw(proxyUrl)
    if proxyBody and type(proxyBody) == "string" and #proxyBody > 0 then
        local lower = proxyBody:lower()
        if not lower:find("404: not found", 1, true) and not lower:find("<!doctype", 1, true) and not lower:find("<html", 1, true) then
            return proxyBody
        end
    end

    return nil
end

local function CopyToClipboard(text)
    if setclipboard then setclipboard(text)
    elseif toclipboard then toclipboard(text) end
end

-- =========================================================================
--             4. СИСТЕМА ЛОКАЛИЗАЦИИ
-- =========================================================================
local SelectedLang = "ru"

local Locales = {
    ["en"] = {
        LoadedNotify = "Script loaded successfully!",
        NoclipWarning = "ENABLE NOCLIP TO USE THIS FEATURE",
        MeterUnit = "m",
        Hideout = "Hideout",
        
        -- Radar
        RadarTitle = "VER RADAR",
        RadarSearch = "SEARCHING",
        RadarDanger = "DANGER!",
        RadarWarn = "WARNING",
        RadarSafe = "SAFE",
        RadarNotFound = "NOT FOUND",
        MonsterLabel = "Monster: ",

        -- Notifications
        MovedToKey = "Teleported to Key ",
        KeyNotFound = "Key not found: ",
        MovedToCode = "Teleported to code note",
        MovedToKeypad = "Teleported to keypad",
        InHideout = "Inside hideout!",

        -- Tabs
        Tab_Main = "Main",
        Tab_Visuals = "Visuals",
        Tab_Teleports = "Teleports",
        Tab_Anti = "Anti",
        Tab_Settings = "Config",

        -- Main Tab
        Sec_Movement = "Movement",
        SpeedToggle = "Speedhack",
        WalkSpeedSlider = "Walk Speed",
        NoclipToggle = "Noclip",
        FlyToggle = "Fly Mode",
        FlySpeedSlider = "Fly Speed",
        Sec_Interaction = "Interaction",
        InstantInteract = "Instant ProximityPrompt",
        InstantInteractDesc = "Removes hold duration (HoldDuration = 0) on all objects",

        -- Visuals Tab
        Sec_Camera = "Camera",
        FOVToggle = "Custom FOV",
        FOVSlider = "Field of View",
        Sec_ESP = "ESP Highlights",
        MonsterESPToggle = "Monster ESP",
        KeysESPToggle = "All Keys ESP",
        ClosetESPToggle = "Closets / Lockers ESP",
        ShowDistances = "Show Distance (Meters)",
        Sec_Tracers = "Tracers",
        TracersMonster = "Tracer to VER",
        TracersKeys = "Tracers to Keys",
        Sec_Lighting = "Lighting",
        FullbrightToggle = "Fullbright",
        NoFogToggle = "Remove Fog",
        NoStaticToggle = "Remove Pixel Static",

        -- Teleports Tab
        Sec_KeyTp = "Teleport to Keys",
        TpKeyBtn = "Teleport to Key ",
        Sec_MapPoints = "Map Locations",
        TpNoteBtn = "Teleport to Code Note",
        TpKeypadBtn = "Teleport to Lock (Keypad)",
        TpClosetBtn = "Teleport to Nearest Locker",

        -- Anti Tab
        Sec_AntiVER = "Protection from VER",
        AntiVER_Repel = "Forcefield (Anti-VER)",
        AntiVER_RepelDesc = "Physically repels your character when monster gets close",
        Sec_RadarBox = "Monitor & VER Radar",
        RadarWidgetToggle = "VER Radar Widget"
    },
    ["ru"] = {
        LoadedNotify = "Скрипт успешно загружен!",
        NoclipWarning = "ВКЛЮЧИТЕ NOCLIP ДЛЯ ВКЛЮЧЕНИЯ ЭТОЙ ФУНКЦИИ",
        MeterUnit = "м",
        Hideout = "Укрытие",

        -- Radar
        RadarTitle = "РАДАР VER",
        RadarSearch = "ПОИСК",
        RadarDanger = "ОПАСНОСТЬ!",
        RadarWarn = "ВНИМАНИЕ",
        RadarSafe = "БЕЗОПАСНО",
        RadarNotFound = "НЕ НАЙДЕН",
        MonsterLabel = "Монстр: ",

        -- Notifications
        MovedToKey = "Перемещен к Ключу ",
        KeyNotFound = "Не найден ключ: ",
        MovedToCode = "Телепортирован к коду",
        MovedToKeypad = "Телепортирован к замку",
        InHideout = "В укрытии!",

        -- Tabs
        Tab_Main = "Главная",
        Tab_Visuals = "Визуалы",
        Tab_Teleports = "Телепорты",
        Tab_Anti = "Анти",
        Tab_Settings = "Конфиг",

        -- Main Tab
        Sec_Movement = "Передвижение",
        SpeedToggle = "Скорость",
        WalkSpeedSlider = "Скорость ходьбы",
        NoclipToggle = "Noclip",
        FlyToggle = "Режим полёта",
        FlySpeedSlider = "Скорость полёта",
        Sec_Interaction = "Взаимодействие",
        InstantInteract = "Мгновенный Промпт",
        InstantInteractDesc = "Убирает задержку удержания (HoldDuration = 0) на всех объектах",

        -- Visuals Tab
        Sec_Camera = "Камера",
        FOVToggle = "Кастомный FOV",
        FOVSlider = "Угол обзора",
        Sec_ESP = "Подсветка",
        MonsterESPToggle = "ESP Монстра",
        KeysESPToggle = "ESP на все Ключи",
        ClosetESPToggle = "ESP на Шкафы",
        ShowDistances = "Показывать метры",
        Sec_Tracers = "Трейсеры",
        TracersMonster = "Трейсер к VER",
        TracersKeys = "Трейсеры к Ключам",
        Sec_Lighting = "Освещение",
        FullbrightToggle = "Полная видимость",
        NoFogToggle = "Убрать туман",
        NoStaticToggle = "Убрать помехи",

        -- Teleports Tab
        Sec_KeyTp = "Телепорт к Ключам",
        TpKeyBtn = "Телепорт к ключу ",
        Sec_MapPoints = "Точки карты",
        TpNoteBtn = "Телепорт к Заметке с Кодом",
        TpKeypadBtn = "Телепорт к Замку (Keypad)",
        TpClosetBtn = "Телепорт к Ближайшему Шкафу",

        -- Anti Tab
        Sec_AntiVER = "Защита от VER",
        AntiVER_Repel = "Силовое поле (анти VER)",
        AntiVER_RepelDesc = "Физически отталкивает персонажа от монстра при сближении",
        Sec_RadarBox = "Монитор и Радар VER",
        RadarWidgetToggle = "Круглый радар VER"
    }
}

local function T(key)
    local lang = Locales[SelectedLang]
    if lang and lang[key] then return lang[key] end
    local en = Locales["en"]
    if en and en[key] then return en[key] end
    return key
end

-- =========================================================
--             5. ОКНО ВЫБОРА ЯЗЫКА (MIDNIGHT STYLE)
-- =========================================================
local function ShowLanguageSelector(onSelectedCallback)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NIXI_LangSelect"
    ScreenGui.ResetOnSpawn = false
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 370, 0, 185)
    Main.Position = UDim2.new(0.5, -185, 0.5, -92)
    Main.BackgroundColor3 = Color3.fromRGB(15, 14, 22)
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Active = true
    Main.Draggable = true
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(75, 55, 120)
    Stroke.Thickness = 1.4
    Stroke.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 42)
    Title.BackgroundTransparency = 1
    Title.Text = "Choose Language / Выберите язык"
    Title.TextColor3 = Color3.fromRGB(240, 235, 255)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 14
    Title.Parent = Main

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Size = UDim2.new(1, 0, 0, 20)
    SubTitle.Position = UDim2.new(0, 0, 0, 44)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "Select your preferred language"
    SubTitle.TextColor3 = Color3.fromRGB(155, 145, 180)
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextSize = 12
    SubTitle.Parent = Main

    local BtnContainer = Instance.new("Frame")
    BtnContainer.Size = UDim2.new(1, -36, 0, 46)
    BtnContainer.Position = UDim2.new(0, 18, 0, 95)
    BtnContainer.BackgroundTransparency = 1
    BtnContainer.Parent = Main

    local Layout = Instance.new("UIListLayout")
    Layout.FillDirection = Enum.FillDirection.Horizontal
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.Padding = UDim.new(0, 14)
    Layout.Parent = BtnContainer

    local function CreateButton(text, bgCol, hoverCol)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.5, -7, 1, 0)
        btn.BackgroundColor3 = bgCol
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.AutoButtonColor = false
        btn.Parent = BtnContainer
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        local bStroke = Instance.new("UIStroke")
        bStroke.Color = Color3.fromRGB(255, 255, 255)
        bStroke.Transparency = 0.86
        bStroke.Parent = btn

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = hoverCol }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = bgCol }):Play()
        end)
        return btn
    end

    local BtnEN = CreateButton("English", Color3.fromRGB(45, 35, 75), Color3.fromRGB(65, 50, 110))
    local BtnRU = CreateButton("Русский", Color3.fromRGB(80, 45, 125), Color3.fromRGB(110, 65, 170))

    local function SmoothClose(lang)
        SelectedLang = lang
        local closeTween = TweenService:Create(Main, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 310, 0, 140),
            Position = UDim2.new(0.5, -155, 0.5, -70),
            BackgroundTransparency = 1
        })
        closeTween:Play()
        closeTween.Completed:Connect(function()
            ScreenGui:Destroy()
            if onSelectedCallback then onSelectedCallback() end
        end)
    end

    BtnEN.MouseButton1Click:Connect(function() SmoothClose("en") end)
    BtnRU.MouseButton1Click:Connect(function() SmoothClose("ru") end)

    Main.Size = UDim2.new(0, 310, 0, 140)
    Main.Position = UDim2.new(0.5, -155, 0.5, -70)
    Main.BackgroundTransparency = 0.5
    TweenService:Create(Main, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 370, 0, 185),
        Position = UDim2.new(0.5, -185, 0.5, -92),
        BackgroundTransparency = 0
    }):Play()
end

-- =========================================================================
--             6. ОСНОВНОЙ СКРИПТ (MONOCHROME MAIN)
-- =========================================================================
local function StartMainScript()
    local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
    local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
    local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
    local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

    local Camera = Workspace.CurrentCamera
    local Options = Library.Options
    local Toggles = Library.Toggles

    ----------------------------------------------------------------------
    -- КЭШ ОБЪЕКТОВ
    ----------------------------------------------------------------------
    local CachedKeys = {}
    local CachedMonster = nil
    local CachedMonsterRoot = nil
    local CachedClosets = {}

    local function StudsToMeters(studs)
        return math.floor(studs * 0.28)
    end

    local function RefreshWorldCache()
        local foundKeys = {}
        local addedKeys = {}
        local roots = { Workspace:FindFirstChild("monochrome"), Workspace }

        for _, root in ipairs(roots) do
            if root then
                for _, desc in ipairs(root:GetDescendants()) do
                    local isKeyHandle = desc:IsA("BasePart") and desc.Name == "KeyHandle"
                    local isHiddenKeyPart = desc:IsA("BasePart") and desc.Parent and string.find(desc.Parent.Name, "HiddenKey")

                    if (isKeyHandle or isHiddenKeyPart) and not addedKeys[desc] then
                        addedKeys[desc] = true
                        local parentModel = desc.Parent
                        local name = (parentModel and parentModel:IsA("Model")) and parentModel.Name or desc.Name
                        table.insert(foundKeys, {
                            Part = desc,
                            Model = parentModel,
                            Name = name
                        })
                    end
                end
            end
        end
        CachedKeys = foundKeys

        local ver = Workspace:FindFirstChild("VER")
        if ver and ver:FindFirstChild("RootPart") then
            CachedMonster = ver
            CachedMonsterRoot = ver.RootPart
        else
            CachedMonster = nil
            CachedMonsterRoot = nil
        end

        local closetFolder = Workspace:FindFirstChild("_MonsterClosetGuards")
        local foundClosets = {}
        if closetFolder then
            for _, p in ipairs(closetFolder:GetChildren()) do
                if p:IsA("BasePart") then
                    table.insert(foundClosets, p)
                end
            end
        end
        CachedClosets = foundClosets
    end

    RefreshWorldCache()
    task.spawn(function()
        while true do
            task.wait(2.5)
            RefreshWorldCache()
        end
    end)

    ----------------------------------------------------------------------
    -- ПРОВЕРКА NOCLIP ПЕРЕД ДЕЙСТВИЯМИ
    ----------------------------------------------------------------------
    local function CheckNoclip()
        if not (Toggles.NoclipToggle and Toggles.NoclipToggle.Value) then
            Library:Notify(T("NoclipWarning"), 4)
            return false
        end
        return true
    end

    ----------------------------------------------------------------------
    -- МЕХАНИЗМ ПОДБОРА КЛЮЧЕЙ
    ----------------------------------------------------------------------
    local function TriggerKeyPickup(keyData)
        local part = keyData.Part
        local model = keyData.Model or part.Parent
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not part or not root then return end

        for _, prompt in ipairs(model:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") and fireproximityprompt then
                prompt.HoldDuration = 0
                prompt.RequiresLineOfSight = false
                fireproximityprompt(prompt)
            end
        end

        for _, cd in ipairs(model:GetDescendants()) do
            if cd:IsA("ClickDetector") and fireclickdetector then
                fireclickdetector(cd)
            end
        end

        if firetouchinterest then
            firetouchinterest(root, part, 0)
            task.wait(0.02)
            firetouchinterest(root, part, 1)
        end
    end

    ----------------------------------------------------------------------
    -- AUTO-INTERACT
    ----------------------------------------------------------------------
    local function IsBoxOrKey(prompt)
        if not prompt or not prompt.Parent then return false end
        local full = prompt:GetFullName():lower()

        if full:find("keypad") or full:find("digit") or full:find("closet") or full:find("guard") or full:find("door") then
            return false
        end

        local aText = (prompt.ActionText or ""):lower()
        local oText = (prompt.ObjectText or ""):lower()

        if oText:find("key") or oText:find("box") or oText:find("drawer") or oText:find("crate") or oText:find("chest") then
            return true
        end
        if aText:find("take") or aText:find("pick") or aText:find("open") or aText:find("search") or aText:find("grab") then
            return true
        end

        local curr = prompt.Parent
        for _ = 1, 5 do
            if not curr or curr == Workspace then break end
            local n = curr.Name:lower()
            if (n:find("key") and not n:find("keypad")) 
                or n:find("box") 
                or n:find("drawer") 
                or n:find("crate") 
                or n:find("table") 
                or n:find("shelf") 
                or n:find("locker") then
                return true
            end
            curr = curr.Parent
        end

        return false
    end

    task.spawn(function()
        while true do
            task.wait(0.08)
            if Toggles.AutoInteractBoxesKeys and Toggles.AutoInteractBoxesKeys.Value then
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")

                if root then
                    for _, prompt in ipairs(Workspace:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") and prompt.Enabled and IsBoxOrKey(prompt) then
                            local part = prompt.Parent
                            local pos = part:IsA("BasePart") and part.Position or (part:IsA("Model") and part:GetPivot().Position)
                            if pos then
                                local dist = (pos - root.Position).Magnitude
                                local maxRange = math.max(prompt.MaxActivationDistance + 4, 12)

                                if dist <= maxRange then
                                    prompt.HoldDuration = 0
                                    prompt.RequiresLineOfSight = false
                                    if fireproximityprompt then
                                        fireproximityprompt(prompt)
                                    else
                                        prompt:InputHoldBegin()
                                        task.wait()
                                        prompt:InputHoldEnd()
                                    end
                                end
                            end
                        end
                    end

                    for _, k in ipairs(CachedKeys) do
                        if k.Part and k.Part.Parent then
                            local dist = (k.Part.Position - root.Position).Magnitude
                            if dist <= 12 then
                                TriggerKeyPickup(k)
                            end
                        end
                    end
                end
            end
        end
    end)

    ----------------------------------------------------------------------
    -- INSTANT INTERACT
    ----------------------------------------------------------------------
    local OriginalHoldDurations = {}

    local function SetInstantPrompt(prompt, enable)
        if not prompt:IsA("ProximityPrompt") then return end

        if enable then
            if OriginalHoldDurations[prompt] == nil then
                OriginalHoldDurations[prompt] = prompt.HoldDuration
            end
            prompt.HoldDuration = 0
            prompt.RequiresLineOfSight = false
        else
            if OriginalHoldDurations[prompt] ~= nil then
                prompt.HoldDuration = OriginalHoldDurations[prompt]
                OriginalHoldDurations[prompt] = nil
            end
        end
    end

    local function ApplyInstantToAll(enable)
        for _, prompt in ipairs(Workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                SetInstantPrompt(prompt, enable)
            end
        end
    end

    Workspace.DescendantAdded:Connect(function(desc)
        if desc:IsA("ProximityPrompt") and Toggles.InstantInteract and Toggles.InstantInteract.Value then
            task.wait()
            SetInstantPrompt(desc, true)
        end
    end)

    ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
        if Toggles.InstantInteract and Toggles.InstantInteract.Value then
            if fireproximityprompt then
                fireproximityprompt(prompt)
            end
        end
    end)

    ----------------------------------------------------------------------
    -- КРУГЛЫЙ РАДАР VER
    ----------------------------------------------------------------------
    local RadarGui = Instance.new("ScreenGui")
    RadarGui.Name = "Nixi_RadarVER"
    RadarGui.ResetOnSpawn = false
    pcall(function() RadarGui.Parent = CoreGui end)
    if not RadarGui.Parent then RadarGui.Parent = PlayerGui end

    local RadarCircle = Instance.new("Frame")
    RadarCircle.Name = "RadarCircle"
    RadarCircle.Size = UDim2.new(0, 130, 0, 130)
    RadarCircle.Position = UDim2.new(1, -150, 1, -150)
    RadarCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    RadarCircle.BackgroundTransparency = 0.15
    RadarCircle.Visible = false
    RadarCircle.ClipsDescendants = true
    RadarCircle.Parent = RadarGui

    local RadarCorner = Instance.new("UICorner")
    RadarCorner.CornerRadius = UDim.new(1, 0)
    RadarCorner.Parent = RadarCircle

    local RadarGradient = Instance.new("UIGradient")
    RadarGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(45, 12, 70)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(22, 6, 36)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(10, 2, 18))
    })
    RadarGradient.Rotation = 45
    RadarGradient.Parent = RadarCircle

    local RadarStroke = Instance.new("UIStroke")
    RadarStroke.Thickness = 2
    RadarStroke.Color = Color3.fromRGB(180, 70, 255)
    RadarStroke.Transparency = 0.2
    RadarStroke.Parent = RadarCircle

    local RadarTitle = Instance.new("TextLabel")
    RadarTitle.Size = UDim2.new(1, 0, 0, 20)
    RadarTitle.Position = UDim2.new(0, 0, 0, 18)
    RadarTitle.BackgroundTransparency = 1
    RadarTitle.Font = Enum.Font.GothamBold
    RadarTitle.Text = T("RadarTitle")
    RadarTitle.TextColor3 = Color3.fromRGB(220, 170, 255)
    RadarTitle.TextSize = 10
    RadarTitle.Parent = RadarCircle

    local RadarDistance = Instance.new("TextLabel")
    RadarDistance.Size = UDim2.new(1, 0, 0, 36)
    RadarDistance.Position = UDim2.new(0, 0, 0, 36)
    RadarDistance.BackgroundTransparency = 1
    RadarDistance.Font = Enum.Font.GothamBold
    RadarDistance.Text = "-- " .. T("MeterUnit")
    RadarDistance.TextColor3 = Color3.fromRGB(255, 255, 255)
    RadarDistance.TextSize = 22
    RadarDistance.Parent = RadarCircle

    local RadarStatus = Instance.new("TextLabel")
    RadarStatus.Size = UDim2.new(1, 0, 0, 18)
    RadarStatus.Position = UDim2.new(0, 0, 0, 78)
    RadarStatus.BackgroundTransparency = 1
    RadarStatus.Font = Enum.Font.GothamMedium
    RadarStatus.Text = T("RadarSearch")
    RadarStatus.TextColor3 = Color3.fromRGB(180, 150, 220)
    RadarStatus.TextSize = 10
    RadarStatus.Parent = RadarCircle

    task.spawn(function()
        while true do
            TweenService:Create(RadarStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.6}):Play()
            task.wait(1.2)
            TweenService:Create(RadarStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.1}):Play()
            task.wait(1.2)
        end
    end)

    ----------------------------------------------------------------------
    -- СОЗДАНИЕ ОКНА OBSIDIAN
    ----------------------------------------------------------------------
    local Window = Library:CreateWindow({
        Title = "NIXI HUB | MONOCHROME",
        Footer = "@NixiScripts",
        Icon = nil,
        NotifySide = "Right",
        ShowCustomCursor = true,
    })

    local Tabs = {
        Main = Window:AddTab(T("Tab_Main"), "gamepad-2"),
        Visuals = Window:AddTab(T("Tab_Visuals"), "eye"),
        Teleports = Window:AddTab(T("Tab_Teleports"), "map-pin"),
        Anti = Window:AddTab(T("Tab_Anti"), "shield"),
        ["UI Settings"] = Window:AddTab(T("Tab_Settings"), "settings"),
    }

    ----------------------------------------------------------------------
    -- ВКЛАДКА 1: ГЛАВНАЯ
    ----------------------------------------------------------------------
    local MoveBox = Tabs.Main:AddLeftGroupbox(T("Sec_Movement"))

    MoveBox:AddToggle("SpeedToggle", {
        Text = T("SpeedToggle"),
        Default = false,
    })

    MoveBox:AddSlider("WalkSpeedSlider", {
        Text = T("WalkSpeedSlider"),
        Default = 24,
        Min = 16,
        Max = 120,
        Rounding = 0,
        Compact = false,
    })

    MoveBox:AddToggle("NoclipToggle", {
        Text = T("NoclipToggle"),
        Default = false,
    })

    MoveBox:AddToggle("FlyToggle", {
        Text = T("FlyToggle"),
        Default = false,
    })

    MoveBox:AddSlider("FlySpeedSlider", {
        Text = T("FlySpeedSlider"),
        Default = 50,
        Min = 10,
        Max = 150,
        Rounding = 0,
        Compact = false,
    })

    local InteractBox = Tabs.Main:AddRightGroupbox(T("Sec_Interaction"))

    InteractBox:AddToggle("InstantInteract", {
        Text = T("InstantInteract"),
        Default = false,
        Tooltip = T("InstantInteractDesc"),
        Callback = function(val)
            ApplyInstantToAll(val)
        end
    })

    ----------------------------------------------------------------------
    -- ВКЛАДКА 2: ВИЗУАЛЫ
    ----------------------------------------------------------------------
    local CamBox = Tabs.Visuals:AddLeftGroupbox(T("Sec_Camera"))

    CamBox:AddToggle("FOVToggle", { Text = T("FOVToggle"), Default = false })
    CamBox:AddSlider("FOVSlider", { Text = T("FOVSlider"), Default = 90, Min = 60, Max = 120, Rounding = 0, Compact = false })

    local ESPBox = Tabs.Visuals:AddLeftGroupbox(T("Sec_ESP"))
    ESPBox:AddToggle("MonsterESPToggle", { Text = T("MonsterESPToggle"), Default = false })
    ESPBox:AddToggle("KeysESPToggle", { Text = T("KeysESPToggle"), Default = false })
    ESPBox:AddToggle("ClosetESPToggle", { Text = T("ClosetESPToggle"), Default = false })
    ESPBox:AddToggle("ShowDistances", { Text = T("ShowDistances"), Default = true })

    local TracerBox = Tabs.Visuals:AddRightGroupbox(T("Sec_Tracers"))
    TracerBox:AddToggle("TracersMonster", { Text = T("TracersMonster"), Default = false })
    TracerBox:AddToggle("TracersKeys", { Text = T("TracersKeys"), Default = false })

    local WorldBox = Tabs.Visuals:AddRightGroupbox(T("Sec_Lighting"))
    WorldBox:AddToggle("FullbrightToggle", { Text = T("FullbrightToggle"), Default = false })
    WorldBox:AddToggle("NoFogToggle", { Text = T("NoFogToggle"), Default = false })
    WorldBox:AddToggle("NoStaticToggle", { Text = T("NoStaticToggle"), Default = false })

    ----------------------------------------------------------------------
    -- ВКЛАДКА 3: ТЕЛЕПОРТЫ
    ----------------------------------------------------------------------
    local KeyTpBox = Tabs.Teleports:AddLeftGroupbox(T("Sec_KeyTp"))

    for i = 1, 4 do
        KeyTpBox:AddButton({
            Text = T("TpKeyBtn") .. i,
            Func = function()
                if not CheckNoclip() then return end

                RefreshWorldCache()
                local found = nil
                for _, k in ipairs(CachedKeys) do
                    if string.find(k.Name, tostring(i)) then
                        found = k
                        break
                    end
                end

                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if found and root then
                    root.CFrame = CFrame.new(found.Part.Position + Vector3.new(0, 1.2, 0))
                    task.wait(0.1)
                    TriggerKeyPickup(found)
                    Library:Notify(T("MovedToKey") .. i, 2)
                else
                    Library:Notify(T("KeyNotFound") .. i, 2)
                end
            end
        })
    end

    local PlacesBox = Tabs.Teleports:AddRightGroupbox(T("Sec_MapPoints"))

    PlacesBox:AddButton({
        Text = T("TpNoteBtn"),
        Func = function()
            if not CheckNoclip() then return end

            local note = Workspace:FindFirstChild("monochrome") and Workspace.monochrome:FindFirstChild("CodeNote")
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if note and root then
                root.CFrame = note.CFrame + Vector3.new(0, 2.5, 0)
                Library:Notify(T("MovedToCode"), 2)
            end
        end
    })

    PlacesBox:AddButton({
        Text = T("TpKeypadBtn"),
        Func = function()
            if not CheckNoclip() then return end

            local keypad = Workspace:FindFirstChild("monochrome") and Workspace.monochrome:FindFirstChild("Keypad")
            local part = keypad and keypad:FindFirstChildWhichIsA("BasePart", true)
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if part and root then
                root.CFrame = part.CFrame + Vector3.new(0, 1.5, 3)
                Library:Notify(T("MovedToKeypad"), 2)
            end
        end
    })

    PlacesBox:AddButton({
        Text = T("TpClosetBtn"),
        Func = function()
            if not CheckNoclip() then return end

            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root and #CachedClosets > 0 then
                local nearest, shortest = nil, math.huge
                for _, c in ipairs(CachedClosets) do
                    local d = (c.Position - root.Position).Magnitude
                    if d < shortest then
                        shortest = d
                        nearest = c
                    end
                end
                if nearest then
                    root.CFrame = nearest.CFrame + Vector3.new(0, 1.5, 0)
                    Library:Notify(T("InHideout"), 2)
                end
            end
        end
    })

    ----------------------------------------------------------------------
    -- ВКЛАДКА 4: АНТИ
    ----------------------------------------------------------------------
    local AntiVER_RepelConn = nil
    local AntiMainBox = Tabs.Anti:AddLeftGroupbox(T("Sec_AntiVER"))

    AntiMainBox:AddToggle("AntiVER_Repel", {
        Text = T("AntiVER_Repel"),
        Default = false,
        Tooltip = T("AntiVER_RepelDesc"),
        Callback = function(val)
            if AntiVER_RepelConn then
                AntiVER_RepelConn:Disconnect()
                AntiVER_RepelConn = nil
            end

            if val then
                if not (Toggles.NoclipToggle and Toggles.NoclipToggle.Value) then
                    Library:Notify(T("NoclipWarning"), 4)
                end

                AntiVER_RepelConn = RunService.Heartbeat:Connect(function()
                    local ver = Workspace:FindFirstChild("VER")
                    local vRoot = ver and ver:FindFirstChild("RootPart")
                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")

                    if vRoot and root then
                        local delta = root.Position - vRoot.Position
                        local dist = delta.Magnitude

                        if dist < 14 and dist > 0.1 then
                            local pushDir = Vector3.new(delta.X, 0, delta.Z).Unit
                            root.CFrame = root.CFrame + (pushDir * 2.8)
                            root.AssemblyLinearVelocity = pushDir * 35
                        end
                    end
                end)
            end
        end
    })

    local AntiRadarBox = Tabs.Anti:AddRightGroupbox(T("Sec_RadarBox"))

    AntiRadarBox:AddToggle("RadarWidgetToggle", {
        Text = T("RadarWidgetToggle"),
        Default = false,
        Callback = function(val)
            RadarCircle.Visible = val
        end
    })

    local MonsterMetersLabel = AntiRadarBox:AddLabel(T("MonsterLabel") .. "--")

    ----------------------------------------------------------------------
    -- ПУЛ ТЕГОВ И ТРЕЙСЕРОВ
    ----------------------------------------------------------------------
    local TagCache = {}
    local function UpdateTag(parent, text, color, enabled)
        if not parent or not parent.Parent then return end
        local tag = TagCache[parent]

        if not enabled then
            if tag then tag.Enabled = false end
            return
        end

        if not tag or not tag.Parent then
            local bill = Instance.new("BillboardGui")
            bill.Name = "NixiTag"
            bill.Size = UDim2.new(0, 140, 0, 32)
            bill.StudsOffset = Vector3.new(0, 1.8, 0)
            bill.AlwaysOnTop = true

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.TextColor3 = color
            label.TextStrokeTransparency = 0.3
            label.TextSize = 13
            label.Parent = bill

            bill.Parent = parent
            TagCache[parent] = bill
            tag = bill
        end

        tag.Enabled = true
        local lbl = tag:FindFirstChildWhichIsA("TextLabel")
        if lbl then
            lbl.Text = text
            lbl.TextColor3 = color
        end
    end

    local MonsterTracer = Drawing.new("Line")
    MonsterTracer.Visible = false
    MonsterTracer.Color = Color3.fromRGB(255, 60, 90)
    MonsterTracer.Thickness = 1.6
    MonsterTracer.Transparency = 0.8

    local KeyTracersPool = {}
    for i = 1, 8 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = Color3.fromRGB(240, 210, 40)
        line.Thickness = 1.4
        line.Transparency = 0.8
        table.insert(KeyTracersPool, line)
    end

    ----------------------------------------------------------------------
    -- RENDER ЦИКЛ
    ----------------------------------------------------------------------
    RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local screenBottom = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)

        if Toggles.SpeedToggle and Toggles.SpeedToggle.Value and char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = Options.WalkSpeedSlider.Value
        end

        if CachedMonsterRoot and root and Toggles.TracersMonster and Toggles.TracersMonster.Value then
            local pos, onScreen = Camera:WorldToViewportPoint(CachedMonsterRoot.Position)
            if onScreen then
                MonsterTracer.From = screenBottom
                MonsterTracer.To = Vector2.new(pos.X, pos.Y)
                MonsterTracer.Visible = true
            else
                MonsterTracer.Visible = false
            end
        else
            MonsterTracer.Visible = false
        end

        local showKeyTracers = Toggles.TracersKeys and Toggles.TracersKeys.Value
        for i, line in ipairs(KeyTracersPool) do
            local keyData = CachedKeys[i]
            if showKeyTracers and keyData and keyData.Part and keyData.Part.Parent and root then
                local pos, onScreen = Camera:WorldToViewportPoint(keyData.Part.Position)
                if onScreen then
                    line.From = screenBottom
                    line.To = Vector2.new(pos.X, pos.Y)
                    line.Visible = true
                else
                    line.Visible = false
                end
            else
                line.Visible = false
            end
        end
    end)

    ----------------------------------------------------------------------
    -- ВЫЧИСЛЕНИЕ ДИСТАНЦИЙ
    ----------------------------------------------------------------------
    task.spawn(function()
        while true do
            task.wait(0.1)
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")

                if CachedMonsterRoot and root then
                    local studs = (CachedMonsterRoot.Position - root.Position).Magnitude
                    local meters = StudsToMeters(studs)
                    local unit = T("MeterUnit")

                    MonsterMetersLabel:SetText(T("MonsterLabel") .. meters .. unit .. " (" .. math.floor(studs) .. " st)")
                    RadarDistance.Text = meters .. " " .. unit

                    if meters < 15 then
                        RadarStatus.Text = T("RadarDanger")
                        RadarStatus.TextColor3 = Color3.fromRGB(255, 60, 80)
                        RadarDistance.TextColor3 = Color3.fromRGB(255, 70, 70)
                    elseif meters < 35 then
                        RadarStatus.Text = T("RadarWarn")
                        RadarStatus.TextColor3 = Color3.fromRGB(255, 190, 60)
                        RadarDistance.TextColor3 = Color3.fromRGB(255, 220, 100)
                    else
                        RadarStatus.Text = T("RadarSafe")
                        RadarStatus.TextColor3 = Color3.fromRGB(180, 130, 255)
                        RadarDistance.TextColor3 = Color3.fromRGB(255, 255, 255)
                    end

                    local showMTag = Toggles.ShowDistances and Toggles.ShowDistances.Value and Toggles.MonsterESPToggle and Toggles.MonsterESPToggle.Value
                    UpdateTag(CachedMonsterRoot, "VER [" .. meters .. unit .. "]", Color3.fromRGB(255, 70, 90), showMTag)
                else
                    RadarDistance.Text = "-- " .. T("MeterUnit")
                    RadarStatus.Text = T("RadarNotFound")
                    RadarStatus.TextColor3 = Color3.fromRGB(150, 150, 170)
                    if CachedMonsterRoot then UpdateTag(CachedMonsterRoot, "", nil, false) end
                end

                local showKeysTag = Toggles.KeysESPToggle and Toggles.KeysESPToggle.Value
                local showDist = Toggles.ShowDistances and Toggles.ShowDistances.Value
                for _, k in ipairs(CachedKeys) do
                    if k.Part and k.Part.Parent and root then
                        if showKeysTag then
                            local studs = (k.Part.Position - root.Position).Magnitude
                            local txt = showDist and (k.Name .. " [" .. StudsToMeters(studs) .. T("MeterUnit") .. "]") or k.Name
                            UpdateTag(k.Part, txt, Color3.fromRGB(255, 220, 60), true)
                        else
                            UpdateTag(k.Part, "", nil, false)
                        end
                    end
                end

                local showCloset = Toggles.ClosetESPToggle and Toggles.ClosetESPToggle.Value
                for _, c in ipairs(CachedClosets) do
                    if c and c.Parent and root then
                        if showCloset then
                            UpdateTag(c, T("Hideout"), Color3.fromRGB(100, 255, 150), true)
                        else
                            UpdateTag(c, "", nil, false)
                        end
                    end
                end
            end)
        end
    end)

    ----------------------------------------------------------------------
    -- ФИЗИКА: NOCLIP & FLY
    ----------------------------------------------------------------------
    local NoclipConn = nil
    Toggles.NoclipToggle:OnChanged(function(enabled)
        if NoclipConn then NoclipConn:Disconnect() NoclipConn = nil end
        if enabled then
            NoclipConn = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    for _, p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") and p.CanCollide then
                            p.CanCollide = false
                        end
                    end
                end
            end)
        end
    end)

    local flyVel, flyGyro, flyConn
    Toggles.FlyToggle:OnChanged(function(enabled)
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not enabled then
            if flyConn then flyConn:Disconnect() flyConn = nil end
            if flyVel then flyVel:Destroy() flyVel = nil end
            if flyGyro then flyGyro:Destroy() flyGyro = nil end
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.PlatformStand = false
            end
            return
        end
        if not root then return end

        flyVel = Instance.new("BodyVelocity", root)
        flyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyVel.Velocity = Vector3.zero

        flyGyro = Instance.new("BodyGyro", root)
        flyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyGyro.CFrame = root.CFrame

        flyConn = RunService.RenderStepped:Connect(function()
            if not Toggles.FlyToggle.Value or not root.Parent then
                Toggles.FlyToggle:SetValue(false)
                return
            end
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.PlatformStand = true end

            local moveDir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

            flyVel.Velocity = moveDir.Magnitude > 0 and (moveDir.Unit * Options.FlySpeedSlider.Value) or Vector3.zero
            flyGyro.CFrame = Camera.CFrame
        end)
    end)

    ----------------------------------------------------------------------
    -- ПЕРЕКЛЮЧАТЕЛИ ВИЗУАЛОВ
    ----------------------------------------------------------------------
    local MonsterHighlight = nil
    Toggles.MonsterESPToggle:OnChanged(function(v)
        if not v and MonsterHighlight then
            MonsterHighlight:Destroy()
            MonsterHighlight = nil
            return
        end
        task.spawn(function()
            while Toggles.MonsterESPToggle.Value do
                if CachedMonster and (not MonsterHighlight or MonsterHighlight.Parent ~= CachedMonster) then
                    if MonsterHighlight then MonsterHighlight:Destroy() end
                    MonsterHighlight = Instance.new("Highlight")
                    MonsterHighlight.FillColor = Color3.fromRGB(255, 40, 80)
                    MonsterHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    MonsterHighlight.FillTransparency = 0.4
                    MonsterHighlight.Parent = CachedMonster
                end
                task.wait(1.5)
            end
        end)
    end)

    local function updateFOV()
        if Toggles.FOVToggle and Toggles.FOVToggle.Value then
            Camera.FieldOfView = Options.FOVSlider.Value
        else
            Camera.FieldOfView = 70
        end
    end
    Toggles.FOVToggle:OnChanged(updateFOV)
    Options.FOVSlider:OnChanged(updateFOV)

    local OriginalLighting = {
        Ambient = Lighting.Ambient,
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd
    }

    Toggles.FullbrightToggle:OnChanged(function(v)
        if v then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
        else
            Lighting.Ambient = OriginalLighting.Ambient
            Lighting.Brightness = OriginalLighting.Brightness
            Lighting.ClockTime = OriginalLighting.ClockTime
        end
    end)

    Toggles.NoFogToggle:OnChanged(function(v)
        if v then
            Lighting.FogEnd = 100000
        else
            Lighting.FogEnd = OriginalLighting.FogEnd
        end
    end)

    Toggles.NoStaticToggle:OnChanged(function(v)
        local grain = PlayerGui:FindFirstChild("PixelStatic")
        if grain then grain.Enabled = not v end
    end)

    ----------------------------------------------------------------------
    -- КОНФИГУРАЦИЯ И ТЕМЫ
    ----------------------------------------------------------------------
    ThemeManager:SetLibrary(Library)
    SaveManager:SetLibrary(Library)

    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

    ThemeManager:SetFolder("NixiHub")
    SaveManager:SetFolder("NixiHub/monochrome")

    SaveManager:BuildConfigSection(Tabs["UI Settings"])
    ThemeManager:ApplyToTab(Tabs["UI Settings"])

    SaveManager:LoadAutoloadConfig()

    getgenv().MONOCHROME_NIXI_CLEANUP = function()
        pcall(function() Library:Unload() end)
        if RadarGui then pcall(function() RadarGui:Destroy() end) end
        if AntiVER_RepelConn then AntiVER_RepelConn:Disconnect() end
        if NoclipConn then NoclipConn:Disconnect() end
        if flyConn then flyConn:Disconnect() end
        if flyVel then flyVel:Destroy() end
        if flyGyro then flyGyro:Destroy() end
        for _, v in ipairs(KeyTracersPool) do pcall(function() v:Remove() end) end
        if MonsterTracer then pcall(function() MonsterTracer:Remove() end) end
    end

    Library:Notify(T("LoadedNotify"), 4)
end

-- =========================================================================
--             7. КЛЮЧЕВАЯ СИСТЕМА (БЕЗ КНОПКИ PASTE)
-- =========================================================================
local function CreateKeySystemUI()
    if IsWhitelisted(LocalPlayer.UserId) then
        ShowLanguageSelector(function()
            StartMainScript()
        end)
        return
    end

    local activeKeyBody = FetchGistKey()
    if activeKeyBody and readfile and isfile and isfile(KEY_FILE) then
        local savedKey = readfile(KEY_FILE)
        if IsKeyValid(savedKey, activeKeyBody) then
            ShowLanguageSelector(function()
                StartMainScript()
            end)
            return
        end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NIXI_SquareKeySystem"
    ScreenGui.ResetOnSpawn = false
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 390, 0, 215)
    Main.Position = UDim2.new(0.5, -195, 0.5, -107)
    Main.BackgroundColor3 = Color3.fromRGB(15, 14, 22)
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Active = true
    Main.Draggable = true
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(75, 55, 120)
    Stroke.Thickness = 1.4
    Stroke.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 42)
    Title.BackgroundTransparency = 1
    Title.Text = "NIXI HUB KEY SYSTEM"
    Title.TextColor3 = Color3.fromRGB(240, 235, 255)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 14
    Title.Parent = Main

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -30, 0, 40)
    KeyInput.Position = UDim2.new(0, 15, 0, 52)
    KeyInput.BackgroundColor3 = Color3.fromRGB(22, 19, 32)
    KeyInput.BorderSizePixel = 0
    KeyInput.PlaceholderText = "Enter or paste key here..."
    KeyInput.PlaceholderColor3 = Color3.fromRGB(120, 110, 145)
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.Font = Enum.Font.GothamMedium
    KeyInput.TextSize = 13
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = Main
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 6)

    local InputStroke = Instance.new("UIStroke")
    InputStroke.Color = Color3.fromRGB(55, 45, 80)
    InputStroke.Thickness = 1
    InputStroke.Parent = KeyInput

    KeyInput.Focused:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(0.2), { Color = Color3.fromRGB(140, 85, 220) }):Play()
    end)
    KeyInput.FocusLost:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(0.2), { Color = Color3.fromRGB(55, 45, 80) }):Play()
    end)

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, -30, 0, 20)
    Status.Position = UDim2.new(0, 15, 0, 97)
    Status.BackgroundTransparency = 1
    Status.Text = ""
    Status.Font = Enum.Font.GothamBold
    Status.TextSize = 12
    Status.Parent = Main

    local BtnContainer = Instance.new("Frame")
    BtnContainer.Size = UDim2.new(1, -30, 0, 40)
    BtnContainer.Position = UDim2.new(0, 15, 0, 126)
    BtnContainer.BackgroundTransparency = 1
    BtnContainer.Parent = Main

    local BtnLayout = Instance.new("UIListLayout")
    BtnLayout.FillDirection = Enum.FillDirection.Horizontal
    BtnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    BtnLayout.Padding = UDim.new(0, 10)
    BtnLayout.Parent = BtnContainer

    local function MakeSquareButton(name, normalColor, hoverColor)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.5, -5, 1, 0)
        btn.BackgroundColor3 = normalColor
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.AutoButtonColor = false
        btn.Parent = BtnContainer
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        local bStroke = Instance.new("UIStroke")
        bStroke.Color = Color3.fromRGB(255, 255, 255)
        bStroke.Transparency = 0.88
        bStroke.Parent = btn

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = hoverColor }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = normalColor }):Play()
        end)
        return btn
    end

    local SubmitBtn = MakeSquareButton("Activate", Color3.fromRGB(80, 45, 125), Color3.fromRGB(110, 65, 170))
    local GetKeyBtn = MakeSquareButton("Get Key", Color3.fromRGB(45, 35, 75), Color3.fromRGB(65, 50, 110))

    GetKeyBtn.MouseButton1Click:Connect(function()
        CopyToClipboard(BOT_LINK)
        Status.TextColor3 = Color3.fromRGB(160, 130, 240)
        Status.Text = "Bot link copied to clipboard!"
    end)

    local function DoCheckKey()
        Status.TextColor3 = Color3.fromRGB(255, 215, 0)
        Status.Text = "Checking key..."

        local rawInput = KeyInput.Text
        local enteredClean = CleanKeyString(rawInput)
        if #enteredClean == 0 then
            Status.TextColor3 = Color3.fromRGB(255, 70, 70)
            Status.Text = "Поле пустое! Введите ключ."
            return
        end

        local remoteContent = FetchGistKey()
        if not remoteContent then
            Status.TextColor3 = Color3.fromRGB(255, 70, 70)
            Status.Text = "Ошибка сети / Gist недоступен!"
            return
        end

        if IsKeyValid(enteredClean, remoteContent) then
            Status.TextColor3 = Color3.fromRGB(90, 245, 130)
            Status.Text = "Ключ принят! Загрузка..."
            if writefile then pcall(function() writefile(KEY_FILE, enteredClean) end) end

            local closeTween = TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 350, 0, 175),
                Position = UDim2.new(0.5, -175, 0.5, -87),
                BackgroundTransparency = 1
            })
            closeTween:Play()
            closeTween.Completed:Connect(function()
                ScreenGui:Destroy()
                ShowLanguageSelector(function()
                    StartMainScript()
                end)
            end)
        else
            Status.TextColor3 = Color3.fromRGB(255, 70, 70)
            Status.Text = "Неверный ключ! Попробуйте снова."
        end
    end

    SubmitBtn.MouseButton1Click:Connect(DoCheckKey)
    KeyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then DoCheckKey() end
    end)

    Main.Size = UDim2.new(0, 350, 0, 175)
    Main.Position = UDim2.new(0.5, -175, 0.5, -87)
    Main.BackgroundTransparency = 0.5
    TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 390, 0, 215),
        Position = UDim2.new(0.5, -195, 0.5, -107),
        BackgroundTransparency = 0
    }):Play()
end

-- Запуск ключевой системы
CreateKeySystemUI()

end)