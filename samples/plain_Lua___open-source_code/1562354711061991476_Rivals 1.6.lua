-- Session-only execution guard: blocks duplicate runs without leaving a
-- permanent file that can prevent the script from loading next time.
local EXEC_ENV = (type(getgenv) == "function" and getgenv()) or _G
if EXEC_ENV.__SKIBIDI_HUB_EXECUTED == true then
    return
end
EXEC_ENV.__SKIBIDI_HUB_EXECUTED = true

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HS = game:GetService("HttpService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

repeat task.wait() until game:IsLoaded()

local C = {
    bg = Color3.fromRGB(6,6,6),
    bgDark = Color3.fromRGB(3,3,3),
    row = Color3.fromRGB(16,16,16),
    input = Color3.fromRGB(16,16,16),
    blue = Color3.fromRGB(210,210,210),
    blueDim = Color3.fromRGB(70,70,70),
    blueDark = Color3.fromRGB(22,22,22),
    text = Color3.fromRGB(255,255,255),
    textDim = Color3.fromRGB(160,160,160),
    textMuted = Color3.fromRGB(100,100,100),
    white = Color3.fromRGB(255,255,255),
    divider = Color3.fromRGB(32,32,32),
    green = Color3.fromRGB(80,220,120),
}

-- ============================================================
-- BACKGROUND PICTURE OPTIONS
-- ============================================================
local BG_OPTIONS = {
    { name = "Default",     value = "rbxassetid://102775518748491" },
    { name = "New Picture", value = "https://files.catbox.moe/lqz8tg.jpeg" },
}

-- ============================================================
-- INTRO SONGS (per-song duration)
-- ============================================================
local INTRO_SONGS = {
    { name = "tuff russian song", url = "https://files.catbox.moe/1yq8cb.mp3",  file = "tuff_russian_song.mp3", duration = 6 },
    { name = "idk tuff?",         url = "https://files.catbox.moe/zdmhse.mp3",  file = "idk_tuff.mp3",         duration = 6 },
    { name = "idk",               url = "https://files.catbox.moe/qbampj.mp3",  file = "idk.mp3",              duration = 6 },
    { name = "tuff🔥",            url = "https://files.catbox.moe/50lojq.mp3",  file = "tuff_fire.mp3",        duration = 6 },
    { name = "sad",               url = "https://files.catbox.moe/znkivc.mp3",  file = "sad.mp3",              duration = 8 },
    { name = "fire🔥",             url = "https://files.catbox.moe/i1aj16.mp3",   file = "skibidi_audio_i1aj16.mp3", duration = 6 },
}

local CONFIG_FILE = "skibidi_config.json"

local Config = {
    animPackEnabled = false,
    animPackName = "SKIBIDI OFF",
    espEnabled = false,
    tracerEnabled = false,
    espColor = Color3.fromRGB(255,80,110),
    tracerColor = Color3.fromRGB(255,80,110),
    silentAimEnabled = false,
    silentAimTargetPart = "Head",
    silentAimFOV = 150,
    silentAimSize = 6,
    aimbotEnabled = false,
    aimbotSmoothness = 0.25,
    introSongEnabled = true,
    introSongIndex = 1,
    fontChangeEnabled = false,
    uiLocked = false,
    bgIndex = 1,
    bgCustom = {},
}

local function colorToTable(c)
    if typeof(c) == "Color3" then return {c.R, c.G, c.B} end
    return {1,1,1}
end
local function tableToColor(t)
    if type(t) == "table" and #t >= 3 then return Color3.new(t[1], t[2], t[3]) end
    return Color3.fromRGB(255,255,255)
end

local lastSavedJSON = nil
local saveQueued = false

local function buildConfigTable()
    return {
        animPackEnabled    = Config.animPackEnabled,
        animPackName       = Config.animPackName,
        espEnabled         = Config.espEnabled,
        tracerEnabled      = Config.tracerEnabled,
        espColor           = colorToTable(Config.espColor),
        tracerColor        = colorToTable(Config.tracerColor),
        silentAimEnabled   = Config.silentAimEnabled,
        silentAimTargetPart= Config.silentAimTargetPart,
        silentAimFOV       = Config.silentAimFOV,
        silentAimSize      = Config.silentAimSize,
        aimbotEnabled      = Config.aimbotEnabled,
        aimbotSmoothness   = Config.aimbotSmoothness,
        introSongEnabled   = Config.introSongEnabled,
        introSongIndex     = Config.introSongIndex,
        fontChangeEnabled  = Config.fontChangeEnabled,
        uiLocked           = Config.uiLocked,
        bgIndex            = Config.bgIndex,
        bgCustom           = Config.bgCustom,
    }
end

local function saveConfig()
    if not (writefile and HS) then return end
    local ok, json = pcall(function() return HS:JSONEncode(buildConfigTable()) end)
    if not ok or not json then return end
    if json == lastSavedJSON then return end
    pcall(function() writefile(CONFIG_FILE, json) end)
    lastSavedJSON = json
end

local function queueSave()
    if saveQueued then return end
    saveQueued = true
    task.delay(0.25, function()
        saveQueued = false
        pcall(saveConfig)
    end)
end

local function loadConfig()
    if not (isfile and readfile and HS) then return false end
    local ok, exists = pcall(function() return isfile(CONFIG_FILE) end)
    if not ok or not exists then return false end
    local ok2, raw = pcall(function() return readfile(CONFIG_FILE) end)
    if not ok2 or not raw or raw == "" then return false end
    local ok3, data = pcall(function() return HS:JSONDecode(raw) end)
    if not ok3 or type(data) ~= "table" then return false end

    if data.animPackEnabled ~= nil then Config.animPackEnabled = data.animPackEnabled == true end
    if data.animPackName then Config.animPackName = tostring(data.animPackName) end
    if data.espEnabled ~= nil then Config.espEnabled = data.espEnabled == true end
    if data.tracerEnabled ~= nil then Config.tracerEnabled = data.tracerEnabled == true end
    if data.espColor then Config.espColor = tableToColor(data.espColor) end
    if data.tracerColor then Config.tracerColor = tableToColor(data.tracerColor) end
    if data.silentAimEnabled ~= nil then Config.silentAimEnabled = data.silentAimEnabled == true end
    if data.silentAimTargetPart then Config.silentAimTargetPart = tostring(data.silentAimTargetPart) end
    if data.silentAimFOV ~= nil then Config.silentAimFOV = math.clamp(tonumber(data.silentAimFOV) or 150, 20, 500) end
    if data.silentAimSize ~= nil then Config.silentAimSize = math.clamp(tonumber(data.silentAimSize) or 6, 1, 20) end
    if data.aimbotEnabled ~= nil then Config.aimbotEnabled = data.aimbotEnabled == true end
    if data.aimbotSmoothness ~= nil then Config.aimbotSmoothness = math.clamp(tonumber(data.aimbotSmoothness) or 0.25, 0.05, 1) end
    if data.introSongEnabled ~= nil then Config.introSongEnabled = data.introSongEnabled == true end
    if data.introSongIndex ~= nil then Config.introSongIndex = math.clamp(tonumber(data.introSongIndex) or 1, 1, #INTRO_SONGS) end
    if data.fontChangeEnabled ~= nil then Config.fontChangeEnabled = data.fontChangeEnabled == true end
    if data.uiLocked ~= nil then Config.uiLocked = data.uiLocked == true end
    if data.bgIndex ~= nil then Config.bgIndex = math.clamp(tonumber(data.bgIndex) or 1, 0, 100) end
    if type(data.bgCustom) == "table" then
        local savedCustom = {}
        for _, item in ipairs(data.bgCustom) do
            if type(item) == "table" and type(item.url) == "string" and item.url ~= "" then
                table.insert(savedCustom, {
                    name = tostring(item.name or ("Custom " .. tostring(#savedCustom + 1))),
                    url = item.url,
                })
            end
        end
        Config.bgCustom = savedCustom
    end

    lastSavedJSON = raw
    return true
end

loadConfig()

-- Resolve the current background
local BG_IMAGE = BG_OPTIONS[Config.bgIndex] and BG_OPTIONS[Config.bgIndex].value or BG_OPTIONS[1].value

-- ============================================================
-- IMAGE LOADER
-- ============================================================
local function loadCustomImageAsset(url, fileName)
    if not url or url == "" then return url end
    fileName = fileName or ("skibidi_img_" .. tostring(math.floor(tick()*1000)) .. ".png")
    local function resolve(path)
        local funcs = {getcustomasset, getsynasset, getasset}
        for _, f in ipairs(funcs) do
            if typeof(f) == "function" then
                local ok, a = pcall(function() return f(path) end)
                if ok and type(a) == "string" and a ~= "" then return a end
            end
        end
        if typeof(getcustomasset) == "function" then
            local ok, a = pcall(function() return getcustomasset(path, true) end)
            if ok and type(a) == "string" and a ~= "" then return a end
        end
        return ""
    end
    if isfile and isfile(fileName) then
        local a = resolve(fileName)
        if a ~= "" then return a end
    end
    local raw = nil
    pcall(function()
        local body = game:HttpGet(url)
        if body and #body > 80 then raw = body end
    end)
    if not raw then
        local req = (syn and syn.request) or (http and (http.request or http.Request)) or request or http_request
        if req then
            local ok, res = pcall(function()
                return req({Url = url, Method = "GET", Headers = {["User-Agent"]="Mozilla/5.0"}})
            end)
            if ok and type(res) == "table" then
                raw = res.Body or res.body or res.Data or res.data
            elseif ok and type(res) == "string" then
                raw = res
            end
        end
    end
    if not raw or #raw < 80 then return url end
    pcall(function() if writefile then writefile(fileName, raw) end end)
    task.wait(0.05)
    local asset = resolve(fileName)
    if asset ~= "" then return asset end
    return url
end

-- ============================================================
-- STARBORN FONT
-- ============================================================
local starbornFont = nil
local fontChangeEnabled = Config.fontChangeEnabled

local function loadStarbornFont()
    if starbornFont then return starbornFont end
    if not (isfile and writefile and getcustomasset) then return nil end
    if not isfile("starborn.ttf") then
        local ok, data = pcall(game.HttpGet, game, "https://files.catbox.moe/pwgdui.ttf")
        if not ok or not data or #data < 1000 then return nil end
        pcall(function() writefile("starborn.ttf", data) end)
    end
    if not isfile("starborn.json") then
        pcall(function()
            writefile("starborn.json", HS:JSONEncode({
                name = "Starborn",
                faces = {{
                    name    = "Regular",
                    weight  = 400,
                    style   = "normal",
                    assetId = getcustomasset("starborn.ttf"),
                }}
            }))
        end)
    end
    local ok, font = pcall(function() return Font.new(getcustomasset("starborn.json")) end)
    if ok and font then starbornFont = font; return font end
    return nil
end

local function applyFontToTree(root, font)
    if not root or not font then return end
    for _, v in ipairs(root:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
            pcall(function() v.FontFace = font end)
        end
    end
end

local function setFontChangeEnabled(state, guiRoot)
    fontChangeEnabled = state
    Config.fontChangeEnabled = state
    queueSave()
    if not guiRoot then return end
    if state then
        local font = loadStarbornFont()
        if font then applyFontToTree(guiRoot, font) end
    else
        for _, v in ipairs(guiRoot:GetDescendants()) do
            if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
                pcall(function() v.FontFace = Font.fromEnum(v.Font) end)
            end
        end
    end
end

-- ============================================================
-- AUDIO
-- ============================================================
local introSongEnabled = Config.introSongEnabled
local introSongIndex = Config.introSongIndex or 1
local currentIntroSound = nil

local function isValidAudio(data)
    if not data or type(data) ~= "string" then return false end
    if #data < 10000 then return false end
    local head = data:sub(1, 200)
    if head:find("<!DOCTYPE") or head:find("<html") or head:find("404") or head:find("Not Found") then
        return false
    end
    if head:sub(1, 3) == "ID3" then return true end
    local b1, b2 = head:byte(1), head:byte(2)
    if b1 == 0xFF and (b2 == 0xFB or b2 == 0xF3 or b2 == 0xF2 or b2 == 0xE3) then
        return true
    end
    local nonPrintable = 0
    for i = 1, math.min(100, #head) do
        local b = head:byte(i)
        if b and (b < 9 or b > 126) then nonPrintable = nonPrintable + 1 end
    end
    return nonPrintable > 20
end

local function resolveCustomAsset(fileName)
    if not fileName then return "" end
    local funcs = {getcustomasset, getsynasset, getasset}
    for _, f in ipairs(funcs) do
        if typeof(f) == "function" then
            local ok, a = pcall(function() return f(fileName) end)
            if ok and type(a) == "string" and a ~= "" then return a end
        end
    end
    if typeof(getcustomasset) == "function" then
        local ok, a = pcall(function() return getcustomasset(fileName, true) end)
        if ok and type(a) == "string" and a ~= "" then return a end
    end
    return ""
end

local function downloadAudio(songData)
    if isfile and isfile(songData.file) then
        local cached = resolveCustomAsset(songData.file)
        if cached ~= "" then
            print("[Skibidi Intro] Using cached: " .. songData.file)
            return cached
        end
    end
    print("[Skibidi Intro] Downloading: " .. songData.url)
    local raw = nil
    local ok, body = pcall(function() return game:HttpGet(songData.url, true) end)
    if ok and isValidAudio(body) then raw = body end
    if not raw then
        local reqFunc = (syn and syn.request) or (http and (http.request or http.Request)) or request or http_request
        if reqFunc then
            local ok2, res = pcall(function()
                return reqFunc({ Url = songData.url, Method = "GET", Headers = { ["User-Agent"] = "Mozilla/5.0" } })
            end)
            if ok2 and type(res) == "table" then
                local b = res.Body or res.body or res.Data or res.data
                if isValidAudio(b) then raw = b end
            elseif ok2 and type(res) == "string" then
                if isValidAudio(res) then raw = res end
            end
        end
    end
    if not raw then
        warn("[Skibidi Intro] Failed to download or invalid audio: " .. songData.url)
        return ""
    end
    local wrote = pcall(function() writefile(songData.file, raw) end)
    if not wrote then
        warn("[Skibidi Intro] Could not write file: " .. songData.file)
        return ""
    end
    task.wait(0.1)
    local asset = resolveCustomAsset(songData.file)
    if asset == "" then
        warn("[Skibidi Intro] getcustomasset failed for: " .. songData.file)
        return ""
    end
    print("[Skibidi Intro] Loaded: " .. asset)
    return asset
end

-- ============================================================
-- INTRO SEQUENCE (custom duration per song)
-- ============================================================
local function playIntroSongAndFlash(songIndex)
    songIndex = songIndex or introSongIndex or 1
    local songData = INTRO_SONGS[songIndex] or INTRO_SONGS[1]
    if not songData then return end

    local audioDuration = tonumber(songData.duration) or 6
    local fadeStart     = math.max(audioDuration - 1, 1)
    local totalDuration = audioDuration + 1

    local SoundService = game:GetService("SoundService")

    if currentIntroSound then
        pcall(function() currentIntroSound:Stop(); currentIntroSound:Destroy() end)
        currentIntroSound = nil
    end
    pcall(function()
        local old = SoundService:FindFirstChild("SkibidiIntro")
        if old then old:Stop(); old:Destroy() end
    end)
    pcall(function()
        local old = SoundService:FindFirstChild("SkibidiFlashSound")
        if old then old:Stop(); old:Destroy() end
    end)

    pcall(function()
        local old = game:GetService("CoreGui"):FindFirstChild("SkibidiSpinningFlash")
        if old then old:Destroy() end
    end)
    pcall(function()
        local pg = LP:FindFirstChildOfClass("PlayerGui")
        if pg then
            local old = pg:FindFirstChild("SkibidiSpinningFlash")
            if old then old:Destroy() end
        end
    end)

    local asset = downloadAudio(songData)
    if asset ~= "" then
        local song = Instance.new("Sound")
        song.Name         = "SkibidiFlashSound"
        song.SoundId      = asset
        song.Volume       = 2
        song.Looped       = false
        song.PlayOnRemove = false
        song.RollOffMode  = Enum.RollOffMode.Inverse
        song.RollOffMinDistance = 5
        song.RollOffMaxDistance = 100000
        song.Parent       = SoundService
        currentIntroSound = song

        pcall(function() SoundService.RespectFilteringEnabled = false end)

        local played = false
        local function tryPlay()
            if played or not song or not song.Parent then return end
            played = true
            local ok2, err = pcall(function() song:Play() end)
            if not ok2 then warn("[Skibidi Intro] Play failed: " .. tostring(err))
            else print("[Skibidi Intro] ▶ Playing: " .. songData.name .. " (" .. audioDuration .. "s)") end
        end
        if song.IsLoaded then tryPlay() else song.Loaded:Connect(tryPlay); task.delay(0.75, tryPlay) end
        task.delay(3, function()
            if song and song.Parent and not song.IsPlaying and not played then
                pcall(function() song:Play() end)
            end
        end)

        task.delay(fadeStart, function()
            if song and song.Parent then
                local fadeTween = TweenService:Create(
                    song,
                    TweenInfo.new(1.0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
                    { Volume = 0 }
                )
                fadeTween:Play()
                fadeTween.Completed:Connect(function()
                    pcall(function() song:Stop(); song:Destroy() end)
                    print("[Skibidi Intro] Audio faded & stopped")
                end)
            end
        end)
    end

    local flashGui = Instance.new("ScreenGui")
    flashGui.Name            = "SkibidiSpinningFlash"
    flashGui.ResetOnSpawn    = false
    flashGui.IgnoreGuiInset  = true
    flashGui.DisplayOrder    = 90
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(flashGui) end end)
    if not pcall(function() flashGui.Parent = game:GetService("CoreGui") end) then
        flashGui.Parent = LP:WaitForChild("PlayerGui")
    end

    local wrapper = Instance.new("Frame", flashGui)
    wrapper.AnchorPoint            = Vector2.new(0.5, 0.5)
    wrapper.Position               = UDim2.new(0.5, 0, 0.5, 0)
    wrapper.Size                   = UDim2.new(0, 520, 0, 180)
    wrapper.BackgroundTransparency = 1
    wrapper.Rotation               = 0
    wrapper.ZIndex                 = 60

    local card = Instance.new("Frame", wrapper)
    card.AnchorPoint      = Vector2.new(0, 0)
    card.Position         = UDim2.new(0, 0, 0, 0)
    card.Size             = UDim2.new(1, 0, 1, 0)
    card.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    card.BorderSizePixel  = 0
    card.ZIndex           = 60
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)

    local cardStroke = Instance.new("UIStroke", card)
    cardStroke.Color        = Color3.fromRGB(0, 0, 0)
    cardStroke.Thickness    = 3
    cardStroke.Transparency = 0.2

    local shockLbl = Instance.new("TextLabel", card)
    shockLbl.AnchorPoint            = Vector2.new(0.5, 0.5)
    shockLbl.Position               = UDim2.new(0.5, 0, 0.5, 0)
    shockLbl.Size                   = UDim2.new(1, -30, 1, -30)
    shockLbl.BackgroundTransparency = 1
    shockLbl.Text                   = "SKIBIDI"
    shockLbl.Font                   = Enum.Font.GothamBlack
    shockLbl.TextScaled             = true
    shockLbl.TextColor3             = Color3.fromRGB(0, 0, 0)
    shockLbl.TextStrokeTransparency = 1
    shockLbl.TextTransparency       = 0
    shockLbl.Rotation               = 0
    shockLbl.ZIndex                 = 61

    local cardScale = Instance.new("UIScale")
    cardScale.Scale  = 0.1
    cardScale.Parent = wrapper
    TweenService:Create(
        cardScale,
        TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Scale = 1.15 }
    ):Play()

    task.spawn(function()
        local t = 0
        while wrapper and wrapper.Parent do
            t = t + 0.016
            wrapper.Rotation = (t * 60) % 360
            local moveX = math.sin(t * 1.2) * 40
            local moveY = math.cos(t * 1.2) * 25
            local shakeX = math.sin(t * 60) * 5
            local shakeY = math.cos(t * 65) * 5
            wrapper.Position = UDim2.new(
                0.5, moveX + shakeX,
                0.5, moveY + shakeY
            )
            task.wait(0.016)
        end
    end)

    task.delay(0.18, function()
        if wrapper and wrapper.Parent then
            TweenService:Create(
                cardScale,
                TweenInfo.new(0.25, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
                { Scale = 1.0 }
            ):Play()
        end
    end)

    task.delay(2.0, function()
        if card and card.Parent then
            local fadeCard = TweenService:Create(
                card,
                TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { BackgroundTransparency = 1 }
            )
            local fadeText = TweenService:Create(
                shockLbl,
                TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { TextTransparency = 1 }
            )
            fadeCard:Play()
            fadeText:Play()
            fadeCard.Completed:Connect(function()
                pcall(function() wrapper:Destroy() end)
            end)
        end
    end)

    task.delay(2.4, function()
        local flash = Instance.new("Frame", flashGui)
        flash.Name                   = "WhiteFlash"
        flash.Size                   = UDim2.new(1, 0, 1, 0)
        flash.Position               = UDim2.new(0, 0, 0, 0)
        flash.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
        flash.BackgroundTransparency = 1
        flash.BorderSizePixel        = 0
        flash.ZIndex                 = 200

        local flashIn = TweenService:Create(
            flash,
            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { BackgroundTransparency = 0 }
        )
        flashIn:Play()

        task.delay(0.85, function()
            if flash and flash.Parent then
                local flashOut = TweenService:Create(
                    flash,
                    TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    { BackgroundTransparency = 1 }
                )
                flashOut:Play()
                flashOut.Completed:Connect(function()
                    pcall(function() flash:Destroy() end)
                end)
            end
        end)
    end)

    task.delay(2.5, function()
        local credit = Instance.new("TextLabel", flashGui)
        credit.Name                   = "MadeByLowTier"
        credit.AnchorPoint            = Vector2.new(0.5, 0)
        credit.Position               = UDim2.new(0.5, 0, 0, 40)
        credit.Size                   = UDim2.new(0, 600, 0, 80)
        credit.BackgroundTransparency = 1
        credit.Text                   = "made by low tier"
        credit.Font                   = Enum.Font.GothamBlack
        credit.TextSize               = 48
        credit.TextColor3             = Color3.fromRGB(0, 0, 0)
        credit.TextStrokeColor3       = Color3.fromRGB(255, 255, 255)
        credit.TextStrokeTransparency = 0.2
        credit.TextTransparency       = 1
        credit.ZIndex                 = 210

        local creditIn = TweenService:Create(
            credit,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { TextTransparency = 0 }
        )
        creditIn:Play()

        task.delay(1.5, function()
            if credit and credit.Parent then
                local creditOut = TweenService:Create(
                    credit,
                    TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    { TextTransparency = 1 }
                )
                creditOut:Play()
                creditOut.Completed:Connect(function()
                    pcall(function() credit:Destroy() end)
                end)
            end
        end)
    end)

    task.delay(totalDuration, function()
        pcall(function() flashGui:Destroy() end)
        print("[Skibidi Intro] ✅ Sequence complete (" .. totalDuration .. "s)")
    end)
end

-- ============================================================
-- ANIMATION PACKS
-- ============================================================
local ANIM_PACK_ORDER = {"SKIBIDI OFF","Skibidi Sports","Skibidi Community","Skibidi Aura","Skibidi Popular","Skibidi Elder","Skibidi Zombie","Skibidi Mage","Skibidi Glam","Skibidi Astronaut"}
local ANIM_PACKS = {
    ["Skibidi Sports"]={WalkAnim=18537392113,RunAnim=18537384940,JumpAnim=18537380791,FallAnim=18537367238,ClimbAnim=18537363391,Animation1=18537376492,Animation2=18537371272},
    ["Skibidi Community"]={WalkAnim=122150855457006,RunAnim=82598234841035,JumpAnim=75290611992385,FallAnim=98600215928904,ClimbAnim=88763136693023,Animation1=122257458498464,Animation2=102357151005774},
    ["Skibidi Aura"]={WalkAnim=83842218823011,RunAnim=118320322718866,JumpAnim=109996626521204,FallAnim=95603166884636,ClimbAnim=97824616490448,Animation1=110211186840347,Animation2=114191137265065},
    ["Skibidi Popular"]={WalkAnim=92072849924640,RunAnim=72301599441680,JumpAnim=104325245285198,FallAnim=121152442762481,ClimbAnim=131326830509784,Animation1=118832222982049,Animation2=76049494037641},
    ["Skibidi Elder"]={WalkAnim=10921111375,RunAnim=10921104374,JumpAnim=10921107367,FallAnim=10921105765,ClimbAnim=10921100400,Animation1=10921101664,Animation2=10921102574},
    ["Skibidi Zombie"]={WalkAnim=10921355261,RunAnim=616163682,JumpAnim=10921351278,FallAnim=10921350320,ClimbAnim=10921343576,Animation1=10921344533,Animation2=10921345304},
    ["Skibidi Mage"]={WalkAnim=10921152678,RunAnim=10921148209,JumpAnim=10921149743,FallAnim=10921148939,ClimbAnim=10921143404,Animation1=10921144709,Animation2=10921145797},
    ["Skibidi Glam"]={WalkAnim=109168724482748,RunAnim=81024476153754,JumpAnim=116936326516985,FallAnim=92294537340807,ClimbAnim=119377220967554,Animation1=133806214992291,Animation2=94970088341563},
    ["Skibidi Astronaut"]={WalkAnim=10921046031,RunAnim=10921039308,JumpAnim=10921042494,FallAnim=10921040576,ClimbAnim=10921032124,Animation1=10921034824,Animation2=10921036806},
}
local _animOriginalIds = {}
local animPackEnabled = Config.animPackEnabled
local animPackName = Config.animPackName or "SKIBIDI OFF"

local function stopAnimTracks(hum)
    if not hum then return end
    for _,tr in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() tr:Stop(0) end) end
end
local function setAnimId(obj,id)
    if obj and id then pcall(function() obj.AnimationId="rbxassetid://"..tostring(id) end) end
end
local function saveOriginalAnims(char)
    local animate=char and char:FindFirstChild("Animate")
    if not animate or next(_animOriginalIds) then return end
    local function gid(folder,child)
        local f=animate:FindFirstChild(folder)
        local a=f and f:FindFirstChild(child)
        return a and a.AnimationId or nil
    end
    _animOriginalIds={
        walk=gid("walk","WalkAnim"), run=gid("run","RunAnim"),
        jump=gid("jump","JumpAnim"), fall=gid("fall","FallAnim"),
        climb=gid("climb","ClimbAnim"),
        idle1=gid("idle","Animation1"), idle2=gid("idle","Animation2"),
    }
end
local function resetAnimPack(char)
    char=char or LP.Character
    local animate=char and char:FindFirstChild("Animate")
    if not animate or not next(_animOriginalIds) then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    stopAnimTracks(hum)
    local function apply(folder,child,key)
        local f=animate:FindFirstChild(folder)
        local a=f and f:FindFirstChild(child)
        if a and _animOriginalIds[key] then a.AnimationId=_animOriginalIds[key] end
    end
    apply("walk","WalkAnim","walk"); apply("run","RunAnim","run")
    apply("jump","JumpAnim","jump"); apply("fall","FallAnim","fall")
    apply("climb","ClimbAnim","climb")
    apply("idle","Animation1","idle1"); apply("idle","Animation2","idle2")
    pcall(function() animate.Disabled=true; task.wait(); animate.Disabled=false end)
end
function applyAnimPack(packName)
    animPackName=packName or "SKIBIDI OFF"
    local char=LP.Character
    if not char then return false end
    if not animPackEnabled or packName=="SKIBIDI OFF" or not ANIM_PACKS[packName] then
        resetAnimPack(char)
        return false
    end
    local pack=ANIM_PACKS[packName]
    saveOriginalAnims(char)
    local animate=char:FindFirstChild("Animate")
    if not animate then return false end
    local hum=char:FindFirstChildOfClass("Humanoid")
    stopAnimTracks(hum)
    local function ensure(folderName,animName)
        local folder=animate:FindFirstChild(folderName)
        if not folder then return nil end
        local a=folder:FindFirstChild(animName)
        if not a then a=Instance.new("Animation"); a.Name=animName; a.Parent=folder end
        return a
    end
    setAnimId(ensure("walk","WalkAnim"),pack.WalkAnim)
    setAnimId(ensure("run","RunAnim"),pack.RunAnim)
    setAnimId(ensure("jump","JumpAnim"),pack.JumpAnim)
    setAnimId(ensure("fall","FallAnim"),pack.FallAnim)
    setAnimId(ensure("climb","ClimbAnim"),pack.ClimbAnim)
    setAnimId(ensure("idle","Animation1"),pack.Animation1)
    setAnimId(ensure("idle","Animation2"),pack.Animation2)
    pcall(function() animate.Disabled=true; task.wait(); animate.Disabled=false end)
    return true
end

LP.CharacterAdded:Connect(function(char)
    if animPackEnabled and animPackName and animPackName~="SKIBIDI OFF" then
        task.delay(0.5, function() pcall(function() applyAnimPack(animPackName) end) end)
    end
end)

-- ============================================================
-- ESP SYSTEM
-- ============================================================
local E = {
    ["ESP Players"] = Config.espEnabled,
    ["Player Tracers"] = Config.tracerEnabled,
}

local espColor = Config.espColor
local tracerColor = Config.tracerColor

do
    local BLACK = Color3.fromRGB(0, 0, 0)
    local espActive, espCache, espLoop = false, {}, nil

    local function buildESP()
        local data = {Highlight = Instance.new("Highlight"), Lines = {}}
        data.Highlight.Name = "SkibidiESP_Highlight"
        data.Highlight.FillColor = espColor
        data.Highlight.OutlineColor = BLACK
        data.Highlight.FillTransparency = 0.12
        data.Highlight.OutlineTransparency = 0.18
        data.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

        local parentGui
        local ok, robloxGui = pcall(function() return game:GetService("CoreGui"):FindFirstChild("RobloxGui") end)
        if ok and robloxGui then parentGui = robloxGui else parentGui = LP:FindFirstChildOfClass("PlayerGui") end
        if not parentGui then parentGui = game:GetService("CoreGui") end
        pcall(function() data.Highlight.Parent = parentGui end)

        local bb = Instance.new("BillboardGui")
        bb.Name = "SkibidiESP_Name"
        bb.Size = UDim2.new(0, 170, 0, 28)
        bb.StudsOffset = Vector3.new(0, 1.3, 0)
        bb.AlwaysOnTop = true
        bb.Parent = parentGui

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(0, 170, 0, 28)
        nameLbl.AnchorPoint = Vector2.new(0.5, 0)
        nameLbl.Position = UDim2.new(0.5, 0, 0, 2)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = ""
        nameLbl.TextColor3 = espColor
        nameLbl.TextSize = 15
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextStrokeColor3 = BLACK
        nameLbl.TextStrokeTransparency = 0
        nameLbl.TextXAlignment = Enum.TextXAlignment.Center
        nameLbl.TextYAlignment = Enum.TextYAlignment.Center
        nameLbl.ZIndex = 5
        nameLbl.Parent = bb

        local outline = Instance.new("UIStroke")
        outline.Color = BLACK
        outline.Thickness = 2.2
        outline.Transparency = 0.12
        outline.Parent = nameLbl

        data.NameTag = bb
        data.NameLabel = nameLbl
        data.NameOutline = outline
        return data
    end

    local function destroyESP(player)
        local data = espCache[player]
        if data then
            if data.esp.Highlight then pcall(function() data.esp.Highlight:Destroy() end) end
            if data.esp.NameTag then pcall(function() data.esp.NameTag:Destroy() end) end
            for _, line in ipairs(data.esp.Lines) do pcall(function() line:Remove() end) end
            if data.loopConn then pcall(function() data.loopConn:Disconnect() end) end
            espCache[player] = nil
        end
    end

    local function updateESP(player, data)
        if not espActive then
            data.Highlight.Enabled = false
            for _, line in ipairs(data.Lines) do line.Visible = false end
            return
        end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart or char:FindFirstChild("UpperTorso"))
        if char and root and (not hum or hum.Health > 0) then
            data.Highlight.Adornee = char
            data.Highlight.Enabled = E["ESP Players"] or false
            if data.NameTag and data.NameLabel then
                pcall(function()
                    data.NameTag.Adornee = root
                    data.NameTag.Enabled = E["ESP Players"] or false
                    data.NameLabel.Text = player.Name or player.DisplayName or ""
                    data.NameLabel.TextColor3 = espColor
                    data.NameLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
                    if data.NameOutline then data.NameOutline.Color = Color3.fromRGB(0,0,0) end
                end)
            end
        else
            data.Highlight.Enabled = false
            data.Highlight.Adornee = nil
            if data.NameTag and data.NameLabel then pcall(function() data.NameTag.Enabled = false end) end
        end
    end

    local function createESP(player)
        if player == LP then return end
        if espCache[player] and espCache[player].esp then
            if espCache[player].esp.NameTag then
                pcall(function() espCache[player].esp.NameTag.Enabled = E["ESP Players"] or false end)
            end
            return
        end
        destroyESP(player)
        espCache[player] = {esp = buildESP()}
    end

    function startESP()
        if espActive then return end
        espActive = true
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP then task.spawn(function() createESP(p) end) end
        end
        local acc = 0
        if espLoop then espLoop:Disconnect() end
        espLoop = RunService.Heartbeat:Connect(function(dt)
            acc += dt or 0
            if acc < 0.5 then return end
            acc = 0
            for player, data in pairs(espCache) do
                if typeof(player) == "Instance" and player:IsA("Player") and data and data.esp then
                    pcall(function() updateESP(player, data.esp) end)
                end
            end
        end)
        espCache._joinConn = Players.PlayerAdded:Connect(function(p)
            if not espActive or p == LP then return end
            task.wait(0.3)
            createESP(p)
        end)
        espCache._leaveConn = Players.PlayerRemoving:Connect(function(p) destroyESP(p) end)
    end

    function stopESP()
        espActive = false
        if espLoop then espLoop:Disconnect(); espLoop = nil end
        if espCache._joinConn then pcall(function() espCache._joinConn:Disconnect() end); espCache._joinConn = nil end
        if espCache._leaveConn then pcall(function() espCache._leaveConn:Disconnect() end); espCache._leaveConn = nil end
        for p in pairs(espCache) do
            if typeof(p) == "Instance" and p:IsA("Player") and p ~= LP then destroyESP(p) end
        end
    end

    function refreshESPColors(newColor)
        espColor = newColor or espColor
        Config.espColor = espColor
        queueSave()
        for _, data in pairs(espCache) do
            if typeof(data) == "table" and data.esp then
                pcall(function()
                    if data.esp.Highlight then data.esp.Highlight.FillColor = espColor end
                    if data.esp.NameLabel then data.esp.NameLabel.TextColor3 = espColor end
                end)
            end
        end
    end
end

do
    local tracerGui = Instance.new("ScreenGui")
    tracerGui.Name = "SkibidiPlayerTracerOverlay"
    tracerGui.IgnoreGuiInset = true
    tracerGui.ResetOnSpawn = false
    tracerGui.DisplayOrder = 1000
    tracerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    tracerGui.Parent = LP:WaitForChild("PlayerGui")

    local tracerLine = Instance.new("Frame")
    tracerLine.Name = "SkibidiESPLine"
    tracerLine.AnchorPoint = Vector2.new(0.5, 0.5)
    tracerLine.BorderSizePixel = 0
    tracerLine.Active = false
    tracerLine.Visible = false
    tracerLine.ZIndex = 1
    tracerLine.Parent = tracerGui

    local lineStroke = Instance.new("UIStroke", tracerLine)
    lineStroke.Color = Color3.fromRGB(255, 255, 255)
    lineStroke.Thickness = 0.7
    lineStroke.Transparency = 0.45

    local tracerState = {scanElapsed = math.huge, targetRoot = nil}

    function refreshTracerColor(newColor)
        tracerColor = newColor or tracerColor
        Config.tracerColor = tracerColor
        queueSave()
        lineStroke.Color = tracerColor
    end

    RunService.RenderStepped:Connect(function(dt)
        if not E["Player Tracers"] then
            if tracerLine.Visible then tracerLine.Visible = false end
            tracerState.targetRoot = nil
            tracerState.scanElapsed = math.huge
            return
        end
        if not pcall(function()
            local cam, myChar = workspace.CurrentCamera, LP.Character
            local myBase = myChar and (myChar:FindFirstChild("LowerTorso") or myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
            if not cam or not myBase then tracerLine.Visible = false; return end
            local myPos = myBase.Position
            tracerState.scanElapsed = tracerState.scanElapsed + (dt or 0)
            local target = tracerState.targetRoot
            local targetParent = target and target.Parent
            local targetHum = targetParent and targetParent:FindFirstChildOfClass("Humanoid")
            local targetAlive = targetParent and (not targetHum or targetHum.Health > 0)
            if tracerState.scanElapsed >= 0.12 or not targetAlive then
                tracerState.scanElapsed = 0
                local bestDist, bestRoot = math.huge
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP then
                        local char = plr.Character
                        local hum = char and char:FindFirstChildOfClass("Humanoid")
                        local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("LowerTorso") or char:FindFirstChild("Torso"))
                        if root and root:IsA("BasePart") and (not hum or hum.Health > 0) then
                            local diff = root.Position - myPos
                            local distSq = diff:Dot(diff)
                            if distSq < bestDist then bestDist, bestRoot = distSq, root end
                        end
                    end
                end
                tracerState.targetRoot = bestRoot
            end
            local root = tracerState.targetRoot
            if not root or not root.Parent then tracerLine.Visible = false; return end
            local worldPos = root.Position
            local myViewport = cam:WorldToViewportPoint(myPos - Vector3.new(0, myBase.Size.Y * 0.35, 0))
            local targetViewport = cam:WorldToViewportPoint(worldPos)
            local viewportSize = cam.ViewportSize
            local myScreen = Vector2.new(myViewport.X, myViewport.Y)
            local targetScreen = Vector2.new(targetViewport.X, targetViewport.Y)
            if not targetViewport or targetViewport.Z <= 0 then
                local center = viewportSize * 0.5
                local dir = targetScreen - center
                dir = if (if targetViewport.Z <= 0 then -dir else dir).Magnitude < 0.001 then Vector2.new(0, -1) else (if targetViewport.Z <= 0 then -dir else dir)
                local clampPos = Vector2.new(math.max(8, center.X - 8), math.max(8, center.Y - 8))
                local sx, sy = clampPos.X / math.max(math.abs(dir.X), 0.001), clampPos.Y / math.max(math.abs(dir.Y), 0.001)
                targetScreen = center + dir * math.min(sx, sy)
            end
            myScreen = if myViewport.Z <= 0 or myScreen.X < 0 or myScreen.X > viewportSize.X or myScreen.Y < 0 or myScreen.Y > viewportSize.Y
                then Vector2.new(viewportSize.X * 0.5, viewportSize.Y - 8) else myScreen
            local delta = targetScreen - myScreen
            local mid = (myScreen + targetScreen) * 0.5
            tracerLine.Position = UDim2.fromOffset(mid.X, mid.Y)
            tracerLine.Size = UDim2.fromOffset(math.max(delta.Magnitude, 1), 2)
            tracerLine.Rotation = math.deg(math.atan2(delta.Y, delta.X))
            tracerLine.BackgroundColor3 = tracerColor
            tracerLine.Visible = true
        end) then
            pcall(function() tracerLine.Visible = false end)
        end
    end)
end

-- ============================================================
-- SILENT AIM + AIMBOT
-- ============================================================
local silentAimEnabled = Config.silentAimEnabled
local silentAimTarget = nil
local silentAimTargetPlayer = nil
local silentAimTargetPart = Config.silentAimTargetPart or "Head"
local silentAimFOV = Config.silentAimFOV or 150
local silentAimSize = Config.silentAimSize or 6

local aimbotEnabled = Config.aimbotEnabled
local aimbotSmoothness = Config.aimbotSmoothness or 0.25

local function getSilentAimTargetPart(character)
    if not character then return nil end
    if silentAimTargetPart == "Head" then
        return character:FindFirstChild("Head")
    else
        return character:FindFirstChild("UpperTorso")
            or character:FindFirstChild("Torso")
            or character:FindFirstChild("HumanoidRootPart")
    end
end

local function isValidSilentAimTarget(targetPlayer)
    if targetPlayer == LP then return false end
    local character = targetPlayer.Character
    if not character then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local targetBone = getSilentAimTargetPart(character)
    if not (humanoid and targetBone and humanoid.Health > 0) then return false end
    local distance = (targetBone.Position - Camera.CFrame.Position).Magnitude
    if distance > 1000 then return false end
    if targetPlayer.Team and LP.Team then
        if targetPlayer.Team == LP.Team then return false end
    end
    local myTeam = LP:GetAttribute("TeamID")
    local theirTeam = targetPlayer:GetAttribute("TeamID")
    if myTeam and theirTeam and myTeam == theirTeam then return false end
    return true
end

local function findBestSilentAimTarget()
    local viewportCenter = Camera.ViewportSize / 2
    local bestPlayer = nil
    local bestDistance = math.huge
    local fovRadius = silentAimFOV
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if isValidSilentAimTarget(otherPlayer) then
            local character = otherPlayer.Character
            local targetBone = getSilentAimTargetPart(character)
            if targetBone then
                local screenPos, isOnScreen = Camera:WorldToViewportPoint(targetBone.Position)
                if isOnScreen then
                    local distanceFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - viewportCenter).Magnitude
                    if distanceFromCenter <= fovRadius and distanceFromCenter < bestDistance then
                        bestDistance = distanceFromCenter
                        bestPlayer = otherPlayer
                    end
                end
            end
        end
    end
    return bestPlayer
end

local silentAimOriginalIndex = nil
local silentAimHookActive = false

function setupSilentAimHook()
    if silentAimHookActive then return end
    if not hookmetamethod then return end
    local isCaller = checkcaller or function() return false end
    silentAimOriginalIndex = hookmetamethod(game, "__index", newcclosure(function(self, index)
        if silentAimEnabled and not isCaller() and index == "ViewportSize" and self == Camera and silentAimTarget then
            local screenPos, isOnScreen = Camera:WorldToViewportPoint(silentAimTarget)
            if isOnScreen then
                return Vector2.new(screenPos.X * 2, screenPos.Y * 2)
            end
        end
        return silentAimOriginalIndex(self, index)
    end))
    silentAimHookActive = true
end

task.spawn(function()
    while true do
        if silentAimEnabled then
            local bestPlayer = findBestSilentAimTarget()
            if bestPlayer then
                local character = bestPlayer.Character
                local targetBone = getSilentAimTargetPart(character)
                if targetBone then
                    silentAimTarget = targetBone.Position
                    silentAimTargetPlayer = bestPlayer
                else
                    silentAimTarget = nil
                    silentAimTargetPlayer = nil
                end
            else
                silentAimTarget = nil
                silentAimTargetPlayer = nil
            end
        else
            silentAimTarget = nil
            silentAimTargetPlayer = nil
        end
        RunService.Heartbeat:Wait()
    end
end)

setupSilentAimHook()

local aimbotConn = nil

local function getAimbotTarget()
    local viewportCenter = Camera.ViewportSize / 2
    local bestBone = nil
    local bestDist = math.huge
    local fovRadius = silentAimFOV
    for _, plr in ipairs(Players:GetPlayers()) do
        if isValidSilentAimTarget(plr) then
            local character = plr.Character
            local targetBone = getSilentAimTargetPart(character)
            if targetBone then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetBone.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - viewportCenter).Magnitude
                    if dist <= fovRadius and dist < bestDist then
                        bestDist = dist
                        bestBone = targetBone
                    end
                end
            end
        end
    end
    return bestBone
end

local function startAimbot()
    if aimbotConn then return end
    aimbotConn = RunService.RenderStepped:Connect(function()
        if not aimbotEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local target = getAimbotTarget()
        if not target then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        local targetPos = target.Position
        local camPos = cam.CFrame.Position
        local desiredCFrame = CFrame.lookAt(camPos, targetPos)
        cam.CFrame = cam.CFrame:Lerp(desiredCFrame, 1 - aimbotSmoothness)
    end)
end

local function stopAimbot()
    if aimbotConn then
        aimbotConn:Disconnect()
        aimbotConn = nil
    end
end

local saToggleSetRef = nil
local aimbotToggleSetRef = nil

function setAimbotEnabled(state)
    if state then
        if silentAimEnabled then
            silentAimEnabled = false
            Config.silentAimEnabled = false
            silentAimTarget = nil
            silentAimTargetPlayer = nil
            if saToggleSetRef then saToggleSetRef(false) end
        end
        aimbotEnabled = true
        Config.aimbotEnabled = true
        startAimbot()
    else
        aimbotEnabled = false
        Config.aimbotEnabled = false
        stopAimbot()
    end
    queueSave()
end

function setSilentAimEnabled(state)
    if state then
        if aimbotEnabled then
            aimbotEnabled = false
            Config.aimbotEnabled = false
            stopAimbot()
            if aimbotToggleSetRef then aimbotToggleSetRef(false) end
        end
        silentAimEnabled = true
        Config.silentAimEnabled = true
        if not silentAimHookActive then setupSilentAimHook() end
    else
        silentAimEnabled = false
        Config.silentAimEnabled = false
        silentAimTarget = nil
        silentAimTargetPlayer = nil
    end
    queueSave()
end

-- FOV Circle
local fovCircleGui = Instance.new("ScreenGui")
fovCircleGui.Name = "SkibidiFOVCircle"
fovCircleGui.ResetOnSpawn = false
fovCircleGui.IgnoreGuiInset = true
fovCircleGui.DisplayOrder = 999
pcall(function() if syn and syn.protect_gui then syn.protect_gui(fovCircleGui) end end)
if not pcall(function() fovCircleGui.Parent = game:GetService("CoreGui") end) then
    fovCircleGui.Parent = LP:WaitForChild("PlayerGui")
end

local fovCircle = Instance.new("Frame")
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
fovCircle.Visible = false
fovCircle.ZIndex = 999
fovCircle.Parent = fovCircleGui

local fovCircleCorner = Instance.new("UICorner", fovCircle)
fovCircleCorner.CornerRadius = UDim.new(1, 0)

local fovCircleStroke = Instance.new("UIStroke", fovCircle)
fovCircleStroke.Color = Color3.fromRGB(255, 80, 110)
fovCircleStroke.Thickness = 1.2
fovCircleStroke.Transparency = 0.3

RunService.RenderStepped:Connect(function()
    if silentAimEnabled or aimbotEnabled then
        fovCircle.Visible = true
        fovCircle.Size = UDim2.new(0, silentAimFOV * 2, 0, silentAimFOV * 2)
        fovCircleStroke.Color = espColor
    else
        fovCircle.Visible = false
    end
end)

-- ============================================================
-- GUI HELPERS
-- ============================================================
local function guiCorner(p,r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 10); c.Parent=p; return c end
local function guiStroke(p,col,t) local s=Instance.new("UIStroke"); s.Color=col or Color3.fromRGB(60,60,70); s.Thickness=t or 1; s.Parent=p; return s end
local function tw(obj,props,ti) TweenService:Create(obj,ti or TweenInfo.new(0.12),props):Play() end

local uiLocked = Config.uiLocked
local function makeDraggable(dragTarget, moveTarget)
    moveTarget = moveTarget or dragTarget
    local dragging, dragInput, dragStart, startPos = false
    dragTarget.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=input.Position; startPos=moveTarget.Position
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    dragTarget.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
    end)
    UIS.InputChanged:Connect(function(input)
        if input==dragInput and dragging then
            if uiLocked then return end
            local delta=input.Position-dragStart
            moveTarget.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)
end

local PlayerGui = LP:WaitForChild("PlayerGui")

local GuiHub = Instance.new("ScreenGui")
GuiHub.Name = "SkibidiHub"
GuiHub.ResetOnSpawn = false
GuiHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GuiHub.Parent = PlayerGui

local Outer = Instance.new("Frame")
Outer.Name = "SkibidiOuter"
Outer.Size = UDim2.new(0,340,0,340)
Outer.Position = UDim2.new(0,6,0,48)
Outer.BackgroundTransparency = 1
Outer.BorderSizePixel = 0
Outer.ClipsDescendants = false
Outer.ZIndex = 5
Outer.Parent = GuiHub

local OuterScale = Instance.new("UIScale")
OuterScale.Scale = 0.70
OuterScale.Parent = Outer

local Inner = Instance.new("Frame")
Inner.Name = "SkibidiInner"
Inner.ClipsDescendants = true
Inner.Size = UDim2.new(1,0,1,0)
Inner.BackgroundColor3 = C.bg
Inner.BackgroundTransparency = 0.15
Inner.BorderSizePixel = 0
Inner.Parent = Outer
guiCorner(Inner,16)
guiStroke(Inner,Color3.fromRGB(45,45,45),1.5)

local BgImage = Instance.new("ImageLabel")
BgImage.Name = "SkibidiBgImage"
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.Position = UDim2.new(0, 0, 0, 0)
BgImage.BackgroundTransparency = 1
BgImage.Image = BG_IMAGE
BgImage.ImageColor3 = Color3.fromRGB(255, 80, 110)
BgImage.ImageTransparency = 0.7
BgImage.ScaleType = Enum.ScaleType.Crop
BgImage.ZIndex = 0
BgImage.Parent = Inner
guiCorner(BgImage, 16)

-- Resolve the current background if it's a remote URL
if BG_IMAGE:sub(1, 10) ~= "rbxassetid" then
    task.spawn(function()
        local asset = loadCustomImageAsset(BG_IMAGE, "skibidi_bg_" .. tostring(Config.bgIndex) .. ".png")
        if BgImage and BgImage.Parent then
            BgImage.Image = (asset and asset ~= "") and asset or BG_IMAGE
        end
    end)
end

local BgOverlay = Instance.new("Frame")
BgOverlay.Name = "SkibidiBgOverlay"
BgOverlay.Size = UDim2.new(1, 0, 1, 0)
BgOverlay.BackgroundColor3 = Color3.fromRGB(3, 3, 3)
BgOverlay.BackgroundTransparency = 0.55
BgOverlay.BorderSizePixel = 0
BgOverlay.ZIndex = 0
BgOverlay.Parent = Inner
guiCorner(BgOverlay, 16)

local HF = Instance.new("Frame")
HF.Name = "SkibidiHeader"
HF.Size = UDim2.new(1,0,0,100)
HF.ClipsDescendants = false
HF.BackgroundTransparency = 1
HF.BorderSizePixel = 0
HF.Parent = Inner
HF.ZIndex = 2
makeDraggable(HF, Outer)

local TITLE_URL = "https://files.catbox.moe/547vve.jpeg"
local TL = Instance.new("ImageLabel")
TL.Name = "SkibidiTitle"
TL.AnchorPoint = Vector2.new(0.5,0.5)
TL.Position = UDim2.new(0.5,0,0.5,0)
TL.Size = UDim2.new(0,240,0,95)
TL.BackgroundTransparency = 1
TL.BorderSizePixel = 0
TL.ScaleType = Enum.ScaleType.Fit
TL.Image = TITLE_URL
TL.ImageTransparency = 0
TL.ImageColor3 = Color3.fromRGB(255,255,255)
TL.ZIndex = 6
TL.Parent = HF

task.spawn(function()
    local asset = loadCustomImageAsset(TITLE_URL, "skibidi_title.jpeg")
    if TL and TL.Parent then
        TL.Image = (asset and asset ~= "") and asset or TITLE_URL
    end
end)

local titleVisible = true
local TitleToggle = Instance.new("TextButton")
TitleToggle.Name = "SkibidiTitleToggle"
TitleToggle.Size = UDim2.new(0,26,0,26)
TitleToggle.Position = UDim2.new(0,12,0,12)
TitleToggle.BackgroundColor3 = Color3.fromRGB(20,20,24)
TitleToggle.BackgroundTransparency = 0.2
TitleToggle.BorderSizePixel = 0
TitleToggle.Text = "SK"
TitleToggle.TextColor3 = Color3.fromRGB(255,255,255)
TitleToggle.Font = Enum.Font.GothamBlack
TitleToggle.TextSize = 10
TitleToggle.AutoButtonColor = false
TitleToggle.ZIndex = 20
TitleToggle.Parent = HF
guiCorner(TitleToggle, 6)
guiStroke(TitleToggle, Color3.fromRGB(70,70,80), 1)

TitleToggle.MouseButton1Click:Connect(function()
    titleVisible = not titleVisible
    local s = TitleToggle:FindFirstChildOfClass("UIScale")
    if not s then
        s = Instance.new("UIScale")
        s.Scale = 1
        s.Parent = TitleToggle
    end
    TweenService:Create(s, TweenInfo.new(0.08), {Scale = 0.85}):Play()
    task.delay(0.08, function()
        TweenService:Create(s, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    end)
    if TL then
        local target = titleVisible and 0 or 1
        TweenService:Create(TL, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            ImageTransparency = target
        }):Play()
    end
    TitleToggle.BackgroundColor3 = titleVisible and Color3.fromRGB(20,20,24) or Color3.fromRGB(8,8,10)
    TitleToggle.TextColor3 = titleVisible and Color3.fromRGB(255,255,255) or Color3.fromRGB(120,120,130)
end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,26,0,26)
CloseBtn.Position = UDim2.new(1,-34,0,12)
CloseBtn.BackgroundColor3 = C.bgDark
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "-"
CloseBtn.TextColor3 = C.textMuted
CloseBtn.Font = Enum.Font.GothamBlack
CloseBtn.TextSize = 20
CloseBtn.ZIndex = 5
CloseBtn.Parent = HF
guiCorner(CloseBtn,6)
guiStroke(CloseBtn,Color3.fromRGB(45,45,45),1)
CloseBtn.MouseEnter:Connect(function() tw(CloseBtn,{BackgroundColor3=Color3.fromRGB(28,28,28),TextColor3=C.text}) end)
CloseBtn.MouseLeave:Connect(function() tw(CloseBtn,{BackgroundColor3=C.bgDark,TextColor3=C.textMuted}) end)

local MiniBtn = Instance.new("TextButton")
MiniBtn.Name = "SkibidiOpenPill"
MiniBtn.Size = UDim2.new(0,190,0,42)
MiniBtn.Position = Outer.Position
MiniBtn.BackgroundColor3 = Color3.fromRGB(12,12,14)
MiniBtn.BorderSizePixel = 0
MiniBtn.Text = ""
MiniBtn.AutoButtonColor = false
MiniBtn.ZIndex = 20
MiniBtn.Visible = false
MiniBtn.Parent = GuiHub
guiCorner(MiniBtn,12)
local miniStroke = Instance.new("UIStroke", MiniBtn)
miniStroke.Color = Color3.fromRGB(55,55,60)
miniStroke.Thickness = 1.1
miniStroke.Transparency = 0.2

local accent = Instance.new("Frame", MiniBtn)
accent.Size = UDim2.new(0,3,0.58,0)
accent.Position = UDim2.new(0,7,0.5,0)
accent.AnchorPoint = Vector2.new(0,0.5)
accent.BackgroundColor3 = Color3.fromRGB(255,255,255)
accent.BorderSizePixel = 0
accent.ZIndex = 21
guiCorner(accent,2)

local logoBox = Instance.new("Frame", MiniBtn)
logoBox.Size = UDim2.new(0,30,0,30)
logoBox.Position = UDim2.new(0,16,0.5,0)
logoBox.AnchorPoint = Vector2.new(0,0.5)
logoBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
logoBox.BorderSizePixel = 0
logoBox.ZIndex = 21
guiCorner(logoBox,8)

local logoTxt = Instance.new("TextLabel", logoBox)
logoTxt.Size = UDim2.new(1,0,1,0)
logoTxt.BackgroundTransparency = 1
logoTxt.Text = "SKIB"
logoTxt.TextColor3 = Color3.fromRGB(12,12,14)
logoTxt.Font = Enum.Font.GothamBlack
logoTxt.TextSize = 9
logoTxt.ZIndex = 22

local titleTxt = Instance.new("TextLabel", MiniBtn)
titleTxt.Size = UDim2.new(0,90,0,14)
titleTxt.Position = UDim2.new(0,54,0,8)
titleTxt.BackgroundTransparency = 1
titleTxt.Text = "SKIBIDI HUB"
titleTxt.TextColor3 = Color3.fromRGB(255,255,255)
titleTxt.Font = Enum.Font.GothamBlack
titleTxt.TextSize = 11
titleTxt.TextXAlignment = Enum.TextXAlignment.Left
titleTxt.ZIndex = 21

local subTxt = Instance.new("TextLabel", MiniBtn)
subTxt.Size = UDim2.new(0,90,0,12)
subTxt.Position = UDim2.new(0,54,0,23)
subTxt.BackgroundTransparency = 1
subTxt.Text = "SKIBIDI TAP"
subTxt.TextColor3 = Color3.fromRGB(170,170,180)
subTxt.Font = Enum.Font.GothamBold
subTxt.TextSize = 8
subTxt.TextXAlignment = Enum.TextXAlignment.Left
subTxt.ZIndex = 21

makeDraggable(MiniBtn, MiniBtn)
MiniBtn.MouseEnter:Connect(function() tw(MiniBtn,{BackgroundColor3=Color3.fromRGB(18,18,22)}) end)
MiniBtn.MouseLeave:Connect(function() tw(MiniBtn,{BackgroundColor3=Color3.fromRGB(12,12,14)}) end)

local guiAnimBusy = false
local function getBaseScale() return OuterScale.Scale or 0.70 end
local function showGui()
    if guiAnimBusy then return end
    guiAnimBusy = true
    MiniBtn.Visible = false
    Outer.Visible = true
    local base = getBaseScale()
    OuterScale.Scale = base * 0.82
    Inner.BackgroundTransparency = 0.35
    local ti = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    TweenService:Create(OuterScale, ti, {Scale = base}):Play()
    TweenService:Create(Inner, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.15
    }):Play()
    task.delay(0.3, function() guiAnimBusy = false end)
end
local function hideGui()
    if guiAnimBusy then return end
    guiAnimBusy = true
    local base = getBaseScale()
    local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    TweenService:Create(OuterScale, ti, {Scale = base * 0.86}):Play()
    TweenService:Create(Inner, ti, {BackgroundTransparency = 0.45}):Play()
    task.delay(0.2, function()
        Outer.Visible = false
        MiniBtn.Visible = true
        OuterScale.Scale = base
        Inner.BackgroundTransparency = 0.15
        local ms = Instance.new("UIScale")
        ms.Scale = 0.7
        ms.Parent = MiniBtn
        TweenService:Create(ms, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        task.delay(0.25, function() pcall(function() ms:Destroy() end) end)
        guiAnimBusy = false
    end)
end
CloseBtn.MouseButton1Click:Connect(hideGui)
MiniBtn.MouseButton1Click:Connect(showGui)

local HSep = Instance.new("Frame")
HSep.Position = UDim2.new(0,14,0,92)
HSep.Size = UDim2.new(1,-28,0,1)
HSep.BackgroundColor3 = C.blue
HSep.BackgroundTransparency = 0.7
HSep.BorderSizePixel = 0
HSep.Parent = Inner
HSep.ZIndex = 2

local LeftPanel = Instance.new("Frame")
LeftPanel.Name = "SkibidiTabBar"
LeftPanel.Size = UDim2.new(1,-16,0,58)
LeftPanel.Position = UDim2.new(0,8,0,96)
LeftPanel.BackgroundTransparency = 1
LeftPanel.BorderSizePixel = 0
LeftPanel.Parent = Inner
LeftPanel.ZIndex = 2

local CatList = Instance.new("Frame")
CatList.Name = "SkibidiCategoryList"
CatList.Size = UDim2.new(1,0,1,0)
CatList.BackgroundTransparency = 1
CatList.BorderSizePixel = 0
CatList.Parent = LeftPanel

local CF = Instance.new("ScrollingFrame")
CF.Name = "SkibidiContent"
CF.Size = UDim2.new(1,-16,1,-166)
CF.Position = UDim2.new(0,8,0,160)
CF.BackgroundTransparency = 1
CF.BorderSizePixel = 0
CF.ScrollBarThickness = 8
CF.ScrollBarImageColor3 = C.blue
CF.CanvasSize = UDim2.new(0,0,0,800)
CF.AutomaticCanvasSize = Enum.AutomaticSize.None
CF.ScrollingDirection = Enum.ScrollingDirection.Y
CF.ScrollingEnabled = true
CF.Active = true
CF.ElasticBehavior = Enum.ElasticBehavior.Never
CF.Parent = Inner
CF.ZIndex = 2

local _cfDragging = false
local function snapScrollStop()
    _cfDragging = false
    local maxY = math.max(0, CF.AbsoluteCanvasSize.Y - CF.AbsoluteSize.Y)
    local snapY = math.clamp(CF.CanvasPosition.Y, 0, maxY)
    pcall(function() CF.ScrollVelocity = Vector2.new(0, 0) end)
    CF.CanvasPosition = Vector2.new(0, snapY)
    task.spawn(function()
        for _ = 1, 6 do
            pcall(function() CF.ScrollVelocity = Vector2.new(0, 0) end)
            CF.CanvasPosition = Vector2.new(0, math.clamp(CF.CanvasPosition.Y, 0, maxY))
            task.wait()
        end
    end)
end
CF.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.MouseButton2 then
        _cfDragging = true
    end
end)
CF.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.MouseButton2 then
        snapScrollStop()
    end
end)
UIS.InputEnded:Connect(function(inp)
    if not _cfDragging then return end
    if inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.MouseButton2 then
        snapScrollStop()
    end
end)
RunService.RenderStepped:Connect(function()
    if not _cfDragging then
        pcall(function()
            if CF.ScrollVelocity.Magnitude > 0.01 then CF.ScrollVelocity = Vector2.new(0, 0) end
        end)
    end
end)

local CLay = Instance.new("UIListLayout")
CLay.SortOrder = Enum.SortOrder.LayoutOrder
CLay.Padding = UDim.new(0,6)
CLay.Parent = CF

local function refreshCanvas()
    task.defer(function()
        local totalH = 0
        for _, child in ipairs(CF:GetChildren()) do
            if child:IsA("GuiObject") and child.Visible then
                local sum = 0
                for _, row in ipairs(child:GetChildren()) do
                    if row:IsA("GuiObject") and row.Visible then
                        local rh = row.AbsoluteSize.Y
                        if rh < 1 then rh = 40 end
                        sum = sum + rh + 6
                    end
                end
                if sum > totalH then totalH = sum end
                if child.AbsoluteSize.Y > totalH then totalH = child.AbsoluteSize.Y end
            end
        end
        if totalH < 1 then totalH = CLay.AbsoluteContentSize.Y end
        local pad = 220
        local need = math.max(totalH + pad, CF.AbsoluteSize.Y + 40)
        CF.CanvasSize = UDim2.new(0, 0, 0, need)
    end)
end
CLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() task.defer(refreshCanvas) end)
CF:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() task.defer(refreshCanvas) end)
task.spawn(function()
    for _ = 1, 12 do task.wait(0.12); refreshCanvas() end
end)

local CPad = Instance.new("UIPadding")
CPad.PaddingLeft = UDim.new(0,6)
CPad.PaddingRight = UDim.new(0,6)
CPad.PaddingTop = UDim.new(0,6)
CPad.PaddingBottom = UDim.new(0,180)
CPad.Parent = CF

local function addSectLbl(parent,text,order)
    local w=Instance.new("Frame",parent); w.Size=UDim2.new(1,0,0,22); w.BackgroundTransparency=1; w.LayoutOrder=order
    local L=Instance.new("TextLabel",w); L.Size=UDim2.new(1,0,0,16); L.BackgroundTransparency=1
    L.Text=text; L.TextColor3=C.textDim; L.TextSize=10; L.Font=Enum.Font.GothamBold; L.TextXAlignment=Enum.TextXAlignment.Left
    return L
end

local function addToggleRow(parent,label,enabled,order,onToggle)
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,38); Row.BackgroundColor3=C.row
    Row.BackgroundTransparency=0.5; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,10); guiStroke(Row,C.divider,1)
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.6,0,0,16); Lb.Position=UDim2.new(0,12,0,6)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=C.text; Lb.TextSize=11; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    local Track=Instance.new("Frame",Row); Track.Size=UDim2.new(0,36,0,18); Track.Position=UDim2.new(1,-46,0,10)
    Track.BackgroundColor3=C.blueDark; Track.BackgroundTransparency=0.5; Track.BorderSizePixel=0; guiCorner(Track,10); guiStroke(Track,C.blueDim,1)
    local Knob=Instance.new("Frame",Track); Knob.Size=UDim2.new(0,14,0,14)
    Knob.Position=enabled and UDim2.new(0.5,2,0.5,-7) or UDim2.new(0,2,0.5,-7)
    Knob.BackgroundColor3=C.blue; Knob.BackgroundTransparency=enabled and 0.3 or 0.5; Knob.BorderSizePixel=0; guiCorner(Knob,7)
    local st=enabled
    local rowScale=Instance.new("UIScale"); rowScale.Scale=1; rowScale.Parent=Row
    local function setV(on)
        st=on
        local ti=TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        TweenService:Create(Knob, ti, {
            Position=on and UDim2.new(0.5,2,0.5,-7) or UDim2.new(0,2,0.5,-7),
            BackgroundTransparency=on and 0.15 or 0.5
        }):Play()
        TweenService:Create(Track, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3=on and Color3.fromRGB(40,40,48) or C.blueDark
        }):Play()
        TweenService:Create(Row, TweenInfo.new(0.12), {BackgroundTransparency=0.2}):Play()
        task.delay(0.12, function()
            TweenService:Create(Row, TweenInfo.new(0.18), {BackgroundTransparency=0.5}):Play()
        end)
    end
    local Btn=Instance.new("TextButton",Row); Btn.Size=UDim2.new(0,36,0,18); Btn.Position=UDim2.new(1,-46,0,10); Btn.BackgroundTransparency=1; Btn.Text=""
    Btn.MouseButton1Click:Connect(function()
        st=not st
        setV(st)
        TweenService:Create(rowScale, TweenInfo.new(0.08), {Scale=0.97}):Play()
        task.delay(0.08, function()
            TweenService:Create(rowScale, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale=1}):Play()
        end)
        if onToggle then onToggle(st) end
    end)
    local hov=Instance.new("TextButton",Row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
    hov.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end)
    hov.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.5}) end)
    return Row,setV
end

local function addToggleRowWithExpand(parent,label,enabled,order,onToggle,expandContentBuilder)
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,38); Row.BackgroundColor3=C.row
    Row.BackgroundTransparency=0.5; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,10); guiStroke(Row,C.divider,1)
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.55,0,0,16); Lb.Position=UDim2.new(0,12,0,6)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=C.text; Lb.TextSize=11; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left

    local ExpBtn=Instance.new("TextButton",Row)
    ExpBtn.Size=UDim2.new(0,22,0,22)
    ExpBtn.Position=UDim2.new(1,-74,0.5,-11)
    ExpBtn.BackgroundColor3=C.input
    ExpBtn.BackgroundTransparency=0.4
    ExpBtn.BorderSizePixel=0
    ExpBtn.Text="-"
    ExpBtn.TextColor3=C.text
    ExpBtn.Font=Enum.Font.GothamBlack
    ExpBtn.TextSize=14
    ExpBtn.AutoButtonColor=false
    guiCorner(ExpBtn,6)
    guiStroke(ExpBtn,C.divider,1)

    local Track=Instance.new("Frame",Row); Track.Size=UDim2.new(0,36,0,18); Track.Position=UDim2.new(1,-46,0,10)
    Track.BackgroundColor3=C.blueDark; Track.BackgroundTransparency=0.5; Track.BorderSizePixel=0; guiCorner(Track,10); guiStroke(Track,C.blueDim,1)
    local Knob=Instance.new("Frame",Track); Knob.Size=UDim2.new(0,14,0,14)
    Knob.Position=enabled and UDim2.new(0.5,2,0.5,-7) or UDim2.new(0,2,0.5,-7)
    Knob.BackgroundColor3=C.blue; Knob.BackgroundTransparency=enabled and 0.3 or 0.5; Knob.BorderSizePixel=0; guiCorner(Knob,7)
    local st=enabled
    local rowScale=Instance.new("UIScale"); rowScale.Scale=1; rowScale.Parent=Row
    local function setV(on)
        st=on
        local ti=TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        TweenService:Create(Knob, ti, {
            Position=on and UDim2.new(0.5,2,0.5,-7) or UDim2.new(0,2,0.5,-7),
            BackgroundTransparency=on and 0.15 or 0.5
        }):Play()
        TweenService:Create(Track, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3=on and Color3.fromRGB(40,40,48) or C.blueDark
        }):Play()
        TweenService:Create(Row, TweenInfo.new(0.12), {BackgroundTransparency=0.2}):Play()
        task.delay(0.12, function()
            TweenService:Create(Row, TweenInfo.new(0.18), {BackgroundTransparency=0.5}):Play()
        end)
    end
    local Btn=Instance.new("TextButton",Row); Btn.Size=UDim2.new(0,36,0,18); Btn.Position=UDim2.new(1,-46,0,10); Btn.BackgroundTransparency=1; Btn.Text=""
    Btn.MouseButton1Click:Connect(function()
        st=not st
        setV(st)
        TweenService:Create(rowScale, TweenInfo.new(0.08), {Scale=0.97}):Play()
        task.delay(0.08, function()
            TweenService:Create(rowScale, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale=1}):Play()
        end)
        if onToggle then onToggle(st) end
    end)
    local hov=Instance.new("TextButton",Row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
    hov.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end)
    hov.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.5}) end)

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1,0,0,0)
    content.BackgroundColor3 = Color3.fromRGB(10,10,12)
    content.BackgroundTransparency = 0.3
    content.BorderSizePixel = 0
    content.LayoutOrder = order + 0.5
    content.ClipsDescendants = true
    content.Visible = false
    content.Parent = parent
    guiCorner(content,10)
    guiStroke(content,C.divider,1)

    local lay = Instance.new("UIListLayout", content)
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.Padding = UDim.new(0,6)
    local p = Instance.new("UIPadding", content)
    p.PaddingTop = UDim.new(0,8)
    p.PaddingBottom = UDim.new(0,8)
    p.PaddingLeft = UDim.new(0,8)
    p.PaddingRight = UDim.new(0,8)

    local function rebuild()
        for _, c in ipairs(content:GetChildren()) do
            if not c:IsA("UIListLayout") and not c:IsA("UIPadding") and not c:IsA("UIStroke") and not c:IsA("UICorner") then
                c:Destroy()
            end
        end
        if expandContentBuilder then expandContentBuilder(content) end
        local h = 0
        for _, c in ipairs(content:GetChildren()) do
            if c:IsA("GuiObject") then
                h = h + (c.AbsoluteSize.Y > 0 and c.AbsoluteSize.Y or c.Size.Y.Offset) + 6
            end
        end
        h = h + 16
        content:SetAttribute("ContentH", h)
    end
    rebuild()
    task.delay(0.1, rebuild)

    local expanded = false
    ExpBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        ExpBtn.Text = expanded and "+" or "-"
        local h = content:GetAttribute("ContentH") or 0
        if h < 1 then h = 120 end
        if expanded then
            content.Visible = true
            content.Size = UDim2.new(1, 0, 0, 0)
            TweenService:Create(content, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, h)}):Play()
        else
            local t = TweenService:Create(content, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 0)})
            t:Play()
            t.Completed:Connect(function() if not expanded then content.Visible = false end end)
        end
        task.defer(refreshCanvas)
    end)

    return Row,setV
end

local function addColorRow(parent,label,initialColor,order,onChange)
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,44); Row.BackgroundColor3=C.row
    Row.BackgroundTransparency=0.5; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,10); guiStroke(Row,C.divider,1)
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.5,0,0,16); Lb.Position=UDim2.new(0,12,0,14)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=C.text; Lb.TextSize=11; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left

    local swatch = Instance.new("TextButton", Row)
    swatch.Size = UDim2.new(0, 50, 0, 24)
    swatch.Position = UDim2.new(1, -62, 0.5, -12)
    swatch.BackgroundColor3 = initialColor
    swatch.BorderSizePixel = 0
    swatch.Text = ""
    swatch.AutoButtonColor = false
    guiCorner(swatch, 6); guiStroke(swatch, Color3.fromRGB(80,80,80), 1)

    local PRESETS = {
        Color3.fromRGB(255,0,0), Color3.fromRGB(255,128,0), Color3.fromRGB(255,255,0),
        Color3.fromRGB(0,255,0), Color3.fromRGB(0,255,255), Color3.fromRGB(0,128,255),
        Color3.fromRGB(128,0,255), Color3.fromRGB(255,0,255), Color3.fromRGB(255,255,255),
        Color3.fromRGB(0,0,0),
    }
    local palette = Instance.new("Frame", Row)
    palette.Size = UDim2.new(1, -24, 0, 0)
    palette.Position = UDim2.new(0, 12, 1, 4)
    palette.BackgroundColor3 = Color3.fromRGB(10,10,12)
    palette.BorderSizePixel = 0
    palette.ClipsDescendants = true
    palette.Visible = false
    palette.ZIndex = 30
    guiCorner(palette, 8); guiStroke(palette, C.divider, 1)

    local palLay = Instance.new("UIGridLayout", palette)
    palLay.CellSize = UDim2.new(0, 22, 0, 22)
    palLay.CellPadding = UDim2.new(0, 4, 0, 4)
    palLay.SortOrder = Enum.SortOrder.LayoutOrder

    for i, c in ipairs(PRESETS) do
        local sw = Instance.new("TextButton", palette)
        sw.BackgroundColor3 = c
        sw.Text = ""
        sw.BorderSizePixel = 0
        sw.LayoutOrder = i
        sw.AutoButtonColor = false
        guiCorner(sw, 4)
        sw.MouseButton1Click:Connect(function()
            swatch.BackgroundColor3 = c
            if onChange then onChange(c) end
        end)
    end

    local open = false
    swatch.MouseButton1Click:Connect(function()
        open = not open
        palette.Visible = open
        TweenService:Create(Row, TweenInfo.new(0.2), {Size = open and UDim2.new(1,0,0,110) or UDim2.new(1,0,0,44)}):Play()
        TweenService:Create(palette, TweenInfo.new(0.2), {Size = open and UDim2.new(1,-24,0,64) or UDim2.new(1,-24,0,0)}):Play()
        task.defer(refreshCanvas)
    end)

    return Row, swatch
end

local Categories = {"Animation","ESP","Silent Aim","Config"}
local CategoryRefs = {contents={}, btnsSide={}, active="Animation"}

for _,name in pairs(Categories) do
    local page=Instance.new("Frame"); page.Size=UDim2.new(1,0,0,0); page.AutomaticSize=Enum.AutomaticSize.Y
    page.BackgroundTransparency=1; page.Visible=(name=="Animation"); page.Parent=CF
    CategoryRefs.contents[name]=page
    local lay=Instance.new("UIListLayout"); lay.SortOrder=Enum.SortOrder.LayoutOrder; lay.Padding=UDim.new(0,6); lay.Parent=page
    lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() if page.Visible then refreshCanvas() end end)
end

local TabHL = Instance.new("Frame")
TabHL.Name = "SkibidiTabHL"
TabHL.BackgroundColor3 = Color3.fromRGB(255,255,255)
TabHL.BackgroundTransparency = 0.88
TabHL.BorderSizePixel = 0
TabHL.ZIndex = 1
TabHL.Parent = CatList
guiCorner(TabHL,8)
local hlStroke = Instance.new("UIStroke",TabHL)
hlStroke.Color = Color3.fromRGB(255,255,255)
hlStroke.Thickness = 1.2
hlStroke.Transparency = 0.55

local TAB_TWEEN = TweenInfo.new(0.28,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
local function moveTabHL(btn)
    if not btn then return end
    TweenService:Create(TabHL,TAB_TWEEN,{Position=btn.Position,Size=btn.Size}):Play()
end

for i,name in ipairs(Categories) do
    local btn=Instance.new("TextButton")
    btn.Size=UDim2.new(0.24,-4,0.7,-2)
    btn.Position=UDim2.new((i-1)*0.25+0.005,2,0.15,1)
    btn.BackgroundColor3=C.blueDark
    btn.BackgroundTransparency=(i==1) and 0.12 or 0.42
    btn.Text=name
    btn.TextColor3=(i==1) and Color3.fromRGB(255,255,255) or Color3.fromRGB(230,230,235)
    btn.TextSize=9
    btn.Font=Enum.Font.GothamBold
    btn.BorderSizePixel=0
    btn.LayoutOrder=i
    btn.ZIndex=3
    btn.Parent=CatList
    guiCorner(btn,8)
    local ind=Instance.new("Frame"); ind.Name="indicator"
    ind.Size=UDim2.new(1,-10,0,2); ind.Position=UDim2.new(0,5,1,-3)
    ind.BackgroundColor3=C.white; ind.BackgroundTransparency=(i==1) and 0.1 or 1
    ind.BorderSizePixel=0; ind.ZIndex=4; ind.Parent=btn
    CategoryRefs.btnsSide[name]=btn
    btn.MouseButton1Click:Connect(function()
        if CategoryRefs.active==name then return end
        for _,f in pairs(CategoryRefs.contents) do f.Visible=false end
        CategoryRefs.contents[name].Visible=true; CategoryRefs.active=name
        local ps = CategoryRefs.contents[name]:FindFirstChildOfClass("UIScale")
        if not ps then ps = Instance.new("UIScale"); ps.Parent = CategoryRefs.contents[name] end
        ps.Scale = 0.96
        TweenService:Create(ps, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        for n,b in pairs(CategoryRefs.btnsSide) do
            local ac=(n==name)
            TweenService:Create(b,TAB_TWEEN,{BackgroundTransparency=ac and 0.12 or 0.42}):Play()
            b.TextColor3=ac and Color3.fromRGB(255,255,255) or Color3.fromRGB(230,230,235)
            local i2=b:FindFirstChild("indicator")
            if i2 then TweenService:Create(i2,TAB_TWEEN,{BackgroundTransparency=ac and 0.1 or 1}):Play() end
        end
        moveTabHL(btn)
        task.defer(function() refreshCanvas(); CF.CanvasPosition = Vector2.new(0, 0) end)
    end)
    btn.MouseEnter:Connect(function()
        if CategoryRefs.active~=name then
            TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundTransparency=0.25}):Play()
            btn.TextColor3=Color3.fromRGB(255,255,255)
        end
    end)
    btn.MouseLeave:Connect(function()
        if CategoryRefs.active~=name then
            TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundTransparency=0.42}):Play()
            btn.TextColor3=Color3.fromRGB(230,230,235)
        end
    end)
end
if CategoryRefs.btnsSide["Animation"] then
    local first = CategoryRefs.btnsSide["Animation"]
    TabHL.Position = first.Position
    TabHL.Size = first.Size
end

-- ANIMATION PAGE
local animPage = CategoryRefs.contents["Animation"]
addSectLbl(animPage,"SKIBIDI ANIMATION PACK",0)

local animIdx = 1
for i,n in ipairs(ANIM_PACK_ORDER) do if n==animPackName then animIdx=i; break end end

local animRow = Instance.new("Frame")
animRow.Size = UDim2.new(1,0,0,38)
animRow.BackgroundColor3 = C.row
animRow.BackgroundTransparency = 0.5
animRow.BorderSizePixel = 0
animRow.LayoutOrder = 1
animRow.Parent = animPage
guiCorner(animRow,10); guiStroke(animRow,C.divider,1)

local animLbl = Instance.new("TextLabel",animRow)
animLbl.Size = UDim2.new(0.42,0,0,16)
animLbl.Position = UDim2.new(0,12,0,6)
animLbl.BackgroundTransparency = 1
animLbl.Text = "Skibidi Pack"
animLbl.TextColor3 = C.text
animLbl.TextSize = 11
animLbl.Font = Enum.Font.GothamBold
animLbl.TextXAlignment = Enum.TextXAlignment.Left

local animVal = Instance.new("TextLabel",animRow)
animVal.Size = UDim2.new(0,90,0,16)
animVal.Position = UDim2.new(1,-150,0,6)
animVal.BackgroundTransparency = 1
animVal.Text = animPackName
animVal.TextColor3 = C.textDim
animVal.TextSize = 9
animVal.Font = Enum.Font.GothamBold
animVal.TextXAlignment = Enum.TextXAlignment.Right

local animBtn = Instance.new("TextButton",animRow)
animBtn.Size = UDim2.new(0,48,0,22)
animBtn.Position = UDim2.new(1,-56,0.5,-11)
animBtn.BackgroundColor3 = C.blue
animBtn.BackgroundTransparency = 0.5
animBtn.BorderSizePixel = 0
animBtn.Text = "Next"
animBtn.TextColor3 = C.white
animBtn.TextSize = 9
animBtn.Font = Enum.Font.GothamBold
guiCorner(animBtn,5)
animBtn.MouseButton1Click:Connect(function()
    animIdx = animIdx % #ANIM_PACK_ORDER + 1
    animPackName = ANIM_PACK_ORDER[animIdx]
    animVal.Text = animPackName
    animPackEnabled = (animPackName ~= "SKIBIDI OFF")
    Config.animPackName = animPackName
    Config.animPackEnabled = animPackEnabled
    applyAnimPack(animPackName)
    queueSave()
end)

local _, animToggleSet = addToggleRow(animPage,"Skibidi Anim Enabled",animPackEnabled,2,function(on)
    animPackEnabled = on
    Config.animPackEnabled = on
    if on then applyAnimPack(animPackName) else resetAnimPack(LP.Character) end
    queueSave()
end)

-- ESP PAGE
local espPage = CategoryRefs.contents["ESP"]
addSectLbl(espPage,"SKIBIDI ESP",0)

local _, espToggleSet = addToggleRow(espPage,"ESP Players",E["ESP Players"],1,function(on)
    E["ESP Players"] = on
    Config.espEnabled = on
    if on then startESP() else stopESP() end
    queueSave()
end)

local _, tracerToggleSet = addToggleRow(espPage,"Player Tracers",E["Player Tracers"],2,function(on)
    E["Player Tracers"] = on
    Config.tracerEnabled = on
    queueSave()
end)

local _, espColorSwatch = addColorRow(espPage,"ESP Color",espColor,3,function(c)
    espColor = c
    Config.espColor = c
    if refreshESPColors then refreshESPColors(c) end
    queueSave()
end)

local _, tracerColorSwatch = addColorRow(espPage,"Tracer Color",tracerColor,4,function(c)
    tracerColor = c
    Config.tracerColor = c
    if refreshTracerColor then refreshTracerColor(c) end
    queueSave()
end)

-- SILENT AIM PAGE
local saPage = CategoryRefs.contents["Silent Aim"]
addSectLbl(saPage,"RIVALS SILENT AIM",0)

local function buildTargetPanel(panel)
    local header = Instance.new("TextLabel", panel)
    header.Size = UDim2.new(1,0,0,16)
    header.BackgroundTransparency = 1
    header.Text = "SKIBIDI TARGET PART"
    header.TextColor3 = C.textDim
    header.TextSize = 10
    header.Font = Enum.Font.GothamBold
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.LayoutOrder = 1

    local options = {
        {label = "Aim at the Head", part = "Head"},
        {label = "Aim at the Body", part = "Torso"},
    }
    local buttons = {}

    local function refresh()
        for _, info in ipairs(options) do
            local b = buttons[info.part]
            if b then
                local on = (silentAimTargetPart == info.part)
                b.BackgroundColor3 = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(20,20,24)
                b.TextColor3 = on and Color3.fromRGB(0,0,0) or Color3.fromRGB(230,230,235)
                local stroke = b:FindFirstChildOfClass("UIStroke")
                if stroke then
                    stroke.Color = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(60,60,70)
                    stroke.Thickness = on and 1.8 or 1
                end
            end
        end
    end

    for i, info in ipairs(options) do
        local b = Instance.new("TextButton", panel)
        b.Size = UDim2.new(1,0,0,34)
        b.BackgroundColor3 = Color3.fromRGB(20,20,24)
        b.BorderSizePixel = 0
        b.Text = info.label
        b.TextColor3 = Color3.fromRGB(230,230,235)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 11
        b.AutoButtonColor = false
        b.LayoutOrder = i + 1
        guiCorner(b,8)
        guiStroke(b,Color3.fromRGB(60,60,70),1)
        b.MouseButton1Click:Connect(function()
            silentAimTargetPart = info.part
            Config.silentAimTargetPart = info.part
            refresh()
            queueSave()
        end)
        buttons[info.part] = b
    end
    refresh()

    local aimbotLbl = Instance.new("TextLabel", panel)
    aimbotLbl.Size = UDim2.new(1,0,0,16)
    aimbotLbl.BackgroundTransparency = 1
    aimbotLbl.Text = "SKIBIDI AIMBOT"
    aimbotLbl.TextColor3 = C.textDim
    aimbotLbl.TextSize = 10
    aimbotLbl.Font = Enum.Font.GothamBold
    aimbotLbl.TextXAlignment = Enum.TextXAlignment.Left
    aimbotLbl.LayoutOrder = 5

    local aimbotRow = Instance.new("Frame", panel)
    aimbotRow.Size = UDim2.new(1,0,0,38)
    aimbotRow.BackgroundColor3 = Color3.fromRGB(20,20,24)
    aimbotRow.BorderSizePixel = 0
    aimbotRow.LayoutOrder = 6
    guiCorner(aimbotRow,8)
    guiStroke(aimbotRow,Color3.fromRGB(60,60,70),1)

    local aimbotTxt = Instance.new("TextLabel", aimbotRow)
    aimbotTxt.Size = UDim2.new(0.6,0,0,16)
    aimbotTxt.Position = UDim2.new(0,12,0,6)
    aimbotTxt.BackgroundTransparency = 1
    aimbotTxt.Text = "Enable Aimbot"
    aimbotTxt.TextColor3 = C.text
    aimbotTxt.TextSize = 11
    aimbotTxt.Font = Enum.Font.GothamBold
    aimbotTxt.TextXAlignment = Enum.TextXAlignment.Left

    local aimbotTrack = Instance.new("Frame", aimbotRow)
    aimbotTrack.Size = UDim2.new(0,36,0,18)
    aimbotTrack.Position = UDim2.new(1,-46,0,10)
    aimbotTrack.BackgroundColor3 = C.blueDark
    aimbotTrack.BackgroundTransparency = 0.5
    aimbotTrack.BorderSizePixel = 0
    guiCorner(aimbotTrack,10)
    guiStroke(aimbotTrack,C.blueDim,1)

    local aimbotKnob = Instance.new("Frame", aimbotTrack)
    aimbotKnob.Size = UDim2.new(0,14,0,14)
    aimbotKnob.Position = aimbotEnabled and UDim2.new(0.5,2,0.5,-7) or UDim2.new(0,2,0.5,-7)
    aimbotKnob.BackgroundColor3 = C.blue
    aimbotKnob.BackgroundTransparency = aimbotEnabled and 0.3 or 0.5
    aimbotKnob.BorderSizePixel = 0
    guiCorner(aimbotKnob,7)

    local aimbotBtn = Instance.new("TextButton", aimbotRow)
    aimbotBtn.Size = UDim2.new(0,36,0,18)
    aimbotBtn.Position = UDim2.new(1,-46,0,10)
    aimbotBtn.BackgroundTransparency = 1
    aimbotBtn.Text = ""

    aimbotBtn.MouseButton1Click:Connect(function()
        local newState = not aimbotEnabled
        setAimbotEnabled(newState)
        if aimbotToggleSetRef then aimbotToggleSetRef(newState) end
        local ti = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        TweenService:Create(aimbotKnob, ti, {
            Position = newState and UDim2.new(0.5,2,0.5,-7) or UDim2.new(0,2,0.5,-7),
            BackgroundTransparency = newState and 0.15 or 0.5
        }):Play()
        TweenService:Create(aimbotTrack, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = newState and Color3.fromRGB(40,40,48) or C.blueDark
        }):Play()
    end)

    local smoothLbl = Instance.new("TextLabel", panel)
    smoothLbl.Size = UDim2.new(1,0,0,16)
    smoothLbl.BackgroundTransparency = 1
    smoothLbl.Text = "AIMBOT SMOOTHNESS"
    smoothLbl.TextColor3 = C.textDim
    smoothLbl.TextSize = 10
    smoothLbl.Font = Enum.Font.GothamBold
    smoothLbl.TextXAlignment = Enum.TextXAlignment.Left
    smoothLbl.LayoutOrder = 7

    local smoothRow = Instance.new("Frame", panel)
    smoothRow.Size = UDim2.new(1,0,0,30)
    smoothRow.BackgroundColor3 = Color3.fromRGB(20,20,24)
    smoothRow.BorderSizePixel = 0
    smoothRow.LayoutOrder = 8
    guiCorner(smoothRow,8)
    guiStroke(smoothRow,Color3.fromRGB(60,60,70),1)

    local smoothVal = Instance.new("TextLabel", smoothRow)
    smoothVal.Size = UDim2.new(0,50,1,0)
    smoothVal.Position = UDim2.new(1,-56,0,0)
    smoothVal.BackgroundTransparency = 1
    smoothVal.Text = string.format("%.2f", aimbotSmoothness)
    smoothVal.TextColor3 = C.text
    smoothVal.TextSize = 11
    smoothVal.Font = Enum.Font.GothamBold
    smoothVal.TextXAlignment = Enum.TextXAlignment.Right

    local smoothTrack = Instance.new("Frame", smoothRow)
    smoothTrack.Size = UDim2.new(1,-72,0,4)
    smoothTrack.Position = UDim2.new(0,8,0.5,-2)
    smoothTrack.BackgroundColor3 = Color3.fromRGB(40,40,44)
    smoothTrack.BorderSizePixel = 0
    guiCorner(smoothTrack,2)

    local smoothFill = Instance.new("Frame", smoothTrack)
    smoothFill.Size = UDim2.new((aimbotSmoothness-0.05)/(1-0.05), 0, 1, 0)
    smoothFill.BackgroundColor3 = C.white
    smoothFill.BorderSizePixel = 0
    guiCorner(smoothFill,2)

    local smoothKnob = Instance.new("Frame", smoothTrack)
    smoothKnob.Size = UDim2.new(0,12,0,12)
    smoothKnob.Position = UDim2.new((aimbotSmoothness-0.05)/(1-0.05),-6,0.5,-6)
    smoothKnob.BackgroundColor3 = C.white
    smoothKnob.BorderSizePixel = 0
    guiCorner(smoothKnob,6)

    local smoothSlider = Instance.new("TextButton", smoothRow)
    smoothSlider.Size = UDim2.new(1,0,1,0)
    smoothSlider.BackgroundTransparency = 1
    smoothSlider.Text = ""

    local smoothDragging = false
    local function setSmoothFromX(absX)
        local rel = math.clamp((absX - smoothTrack.AbsolutePosition.X) / smoothTrack.AbsoluteSize.X, 0, 1)
        local val = 0.05 + rel * (1 - 0.05)
        aimbotSmoothness = val
        Config.aimbotSmoothness = val
        smoothVal.Text = string.format("%.2f", val)
        smoothFill.Size = UDim2.new(rel, 0, 1, 0)
        smoothKnob.Position = UDim2.new(rel, -6, 0.5, -6)
        queueSave()
    end

    smoothSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            smoothDragging = true
            setSmoothFromX(input.Position.X)
        end
    end)
    smoothSlider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            smoothDragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if smoothDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            setSmoothFromX(input.Position.X)
        end
    end)

    local fovLbl = Instance.new("TextLabel", panel)
    fovLbl.Size = UDim2.new(1,0,0,16)
    fovLbl.BackgroundTransparency = 1
    fovLbl.Text = "SKIBIDI FOV"
    fovLbl.TextColor3 = C.textDim
    fovLbl.TextSize = 10
    fovLbl.Font = Enum.Font.GothamBold
    fovLbl.TextXAlignment = Enum.TextXAlignment.Left
    fovLbl.LayoutOrder = 10

    local fovRow = Instance.new("Frame", panel)
    fovRow.Size = UDim2.new(1,0,0,30)
    fovRow.BackgroundColor3 = Color3.fromRGB(20,20,24)
    fovRow.BorderSizePixel = 0
    fovRow.LayoutOrder = 11
    guiCorner(fovRow,8)
    guiStroke(fovRow,Color3.fromRGB(60,60,70),1)

    local fovVal = Instance.new("TextLabel", fovRow)
    fovVal.Size = UDim2.new(0,50,1,0)
    fovVal.Position = UDim2.new(1,-56,0,0)
    fovVal.BackgroundTransparency = 1
    fovVal.Text = tostring(silentAimFOV)
    fovVal.TextColor3 = C.text
    fovVal.TextSize = 11
    fovVal.Font = Enum.Font.GothamBold
    fovVal.TextXAlignment = Enum.TextXAlignment.Right

    local fovTrack = Instance.new("Frame", fovRow)
    fovTrack.Size = UDim2.new(1,-72,0,4)
    fovTrack.Position = UDim2.new(0,8,0.5,-2)
    fovTrack.BackgroundColor3 = Color3.fromRGB(40,40,44)
    fovTrack.BorderSizePixel = 0
    guiCorner(fovTrack,2)

    local fovFill = Instance.new("Frame", fovTrack)
    fovFill.Size = UDim2.new((silentAimFOV-20)/(500-20), 0, 1, 0)
    fovFill.BackgroundColor3 = C.white
    fovFill.BorderSizePixel = 0
    guiCorner(fovFill,2)

    local fovKnob = Instance.new("Frame", fovTrack)
    fovKnob.Size = UDim2.new(0,12,0,12)
    fovKnob.Position = UDim2.new((silentAimFOV-20)/(500-20),-6,0.5,-6)
    fovKnob.BackgroundColor3 = C.white
    fovKnob.BorderSizePixel = 0
    guiCorner(fovKnob,6)

    local fovSlider = Instance.new("TextButton", fovRow)
    fovSlider.Size = UDim2.new(1,0,1,0)
    fovSlider.BackgroundTransparency = 1
    fovSlider.Text = ""

    local fovDragging = false
    local function setFOVFromX(absX)
        local rel = math.clamp((absX - fovTrack.AbsolutePosition.X) / fovTrack.AbsoluteSize.X, 0, 1)
        local val = math.floor(20 + rel * (500 - 20))
        silentAimFOV = val
        Config.silentAimFOV = val
        fovVal.Text = tostring(val)
        fovFill.Size = UDim2.new(rel, 0, 1, 0)
        fovKnob.Position = UDim2.new(rel, -6, 0.5, -6)
        queueSave()
    end

    fovSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            fovDragging = true
            setFOVFromX(input.Position.X)
        end
    end)
    fovSlider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            fovDragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if fovDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            setFOVFromX(input.Position.X)
        end
    end)

    local sizeLbl = Instance.new("TextLabel", panel)
    sizeLbl.Size = UDim2.new(1,0,0,16)
    sizeLbl.BackgroundTransparency = 1
    sizeLbl.Text = "SKIBIDI HITBOX SIZE"
    sizeLbl.TextColor3 = C.textDim
    sizeLbl.TextSize = 10
    sizeLbl.Font = Enum.Font.GothamBold
    sizeLbl.TextXAlignment = Enum.TextXAlignment.Left
    sizeLbl.LayoutOrder = 12

    local sizeRow = Instance.new("Frame", panel)
    sizeRow.Size = UDim2.new(1,0,0,30)
    sizeRow.BackgroundColor3 = Color3.fromRGB(20,20,24)
    sizeRow.BorderSizePixel = 0
    sizeRow.LayoutOrder = 13
    guiCorner(sizeRow,8)
    guiStroke(sizeRow,Color3.fromRGB(60,60,70),1)

    local sizeVal = Instance.new("TextLabel", sizeRow)
    sizeVal.Size = UDim2.new(0,50,1,0)
    sizeVal.Position = UDim2.new(1,-56,0,0)
    sizeVal.BackgroundTransparency = 1
    sizeVal.Text = tostring(silentAimSize)
    sizeVal.TextColor3 = C.text
    sizeVal.TextSize = 11
    sizeVal.Font = Enum.Font.GothamBold
    sizeVal.TextXAlignment = Enum.TextXAlignment.Right

    local sizeTrack = Instance.new("Frame", sizeRow)
    sizeTrack.Size = UDim2.new(1,-72,0,4)
    sizeTrack.Position = UDim2.new(0,8,0.5,-2)
    sizeTrack.BackgroundColor3 = Color3.fromRGB(40,40,44)
    sizeTrack.BorderSizePixel = 0
    guiCorner(sizeTrack,2)

    local sizeFill = Instance.new("Frame", sizeTrack)
    sizeFill.Size = UDim2.new((silentAimSize-1)/(20-1), 0, 1, 0)
    sizeFill.BackgroundColor3 = C.white
    sizeFill.BorderSizePixel = 0
    guiCorner(sizeFill,2)

    local sizeKnob = Instance.new("Frame", sizeTrack)
    sizeKnob.Size = UDim2.new(0,12,0,12)
    sizeKnob.Position = UDim2.new((silentAimSize-1)/(20-1),-6,0.5,-6)
    sizeKnob.BackgroundColor3 = C.white
    sizeKnob.BorderSizePixel = 0
    guiCorner(sizeKnob,6)

    local sizeSlider = Instance.new("TextButton", sizeRow)
    sizeSlider.Size = UDim2.new(1,0,1,0)
    sizeSlider.BackgroundTransparency = 1
    sizeSlider.Text = ""

    local sizeDragging = false
    local function setSizeFromX(absX)
        local rel = math.clamp((absX - sizeTrack.AbsolutePosition.X) / sizeTrack.AbsoluteSize.X, 0, 1)
        local val = math.floor(1 + rel * (20 - 1))
        silentAimSize = val
        Config.silentAimSize = val
        sizeVal.Text = tostring(val)
        sizeFill.Size = UDim2.new(rel, 0, 1, 0)
        sizeKnob.Position = UDim2.new(rel, -6, 0.5, -6)
        queueSave()
    end

    sizeSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sizeDragging = true
            setSizeFromX(input.Position.X)
        end
    end)
    sizeSlider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sizeDragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if sizeDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            setSizeFromX(input.Position.X)
        end
    end)

    refresh()
    return refresh
end

local saTargetRefresh = nil

local _, saToggleSet = addToggleRowWithExpand(saPage,"Skibidi Silent Aim",silentAimEnabled,1,function(on)
    setSilentAimEnabled(on)
end, function(panel)
    saTargetRefresh = buildTargetPanel(panel)
end)
saToggleSetRef = saToggleSet

local _, aimbotToggleOut = addToggleRow(saPage,"Skibidi Aimbot",aimbotEnabled,2,function(on)
    setAimbotEnabled(on)
end)
aimbotToggleSetRef = aimbotToggleOut

addSectLbl(saPage,"SKIBIDI INFO",3)
local infoRow = Instance.new("Frame")
infoRow.Size = UDim2.new(1,0,0,68)
infoRow.BackgroundColor3 = C.row
infoRow.BackgroundTransparency = 0.5
infoRow.BorderSizePixel = 0
infoRow.LayoutOrder = 4
infoRow.Parent = saPage
guiCorner(infoRow,10); guiStroke(infoRow,C.divider,1)

local infoLbl = Instance.new("TextLabel",infoRow)
infoLbl.Size = UDim2.new(1,-16,1,-12)
infoLbl.Position = UDim2.new(0,8,0,6)
infoLbl.BackgroundTransparency = 1
infoLbl.Text = "Silent Aim = invisible lock. Aimbot = visible camera lock.\nEnabling one auto-disables the other. Only one can be ON."
infoLbl.TextColor3 = C.textDim
infoLbl.TextSize = 10
infoLbl.Font = Enum.Font.GothamBold
infoLbl.TextWrapped = true
infoLbl.TextXAlignment = Enum.TextXAlignment.Left
infoLbl.TextYAlignment = Enum.TextYAlignment.Top

-- CONFIG PAGE
local cfgPage = CategoryRefs.contents["Config"]
addSectLbl(cfgPage,"SKIBIDI CONFIG",0)

local _, introToggleSet = addToggleRow(cfgPage,"Intro Song",introSongEnabled,1,function(on)
    introSongEnabled = on
    Config.introSongEnabled = on
    if on then
        task.spawn(function() playIntroSongAndFlash(introSongIndex) end)
    else
        pcall(function()
            local ss = game:GetService("SoundService")
            local old = ss:FindFirstChild("SkibidiFlashSound")
            if old then old:Stop(); old:Destroy() end
            local old2 = ss:FindFirstChild("SkibidiIntro")
            if old2 then old2:Stop(); old2:Destroy() end
        end)
        pcall(function()
            local cg = game:GetService("CoreGui"):FindFirstChild("SkibidiSpinningFlash")
            if cg then cg:Destroy() end
        end)
    end
    queueSave()
end)

local songRow = Instance.new("Frame",cfgPage)
songRow.Size = UDim2.new(1,0,0,38)
songRow.BackgroundColor3 = C.row
songRow.BackgroundTransparency = 0.5
songRow.BorderSizePixel = 0
songRow.LayoutOrder = 2
songRow.Parent = cfgPage
guiCorner(songRow,10); guiStroke(songRow,C.divider,1)

local songLbl = Instance.new("TextLabel",songRow)
songLbl.Size = UDim2.new(0.55,0,0,16)
songLbl.Position = UDim2.new(0,12,0,6)
songLbl.BackgroundTransparency = 1
songLbl.Text = "Intro Song Choice"
songLbl.TextColor3 = C.text
songLbl.TextSize = 11
songLbl.Font = Enum.Font.GothamBold
songLbl.TextXAlignment = Enum.TextXAlignment.Left

local songExpandBtn = Instance.new("TextButton",songRow)
songExpandBtn.Size = UDim2.new(0,22,0,22)
songExpandBtn.Position = UDim2.new(1,-30,0.5,-11)
songExpandBtn.BackgroundColor3 = C.input
songExpandBtn.BackgroundTransparency = 0.4
songExpandBtn.BorderSizePixel = 0
songExpandBtn.Text = "-"
songExpandBtn.TextColor3 = C.text
songExpandBtn.Font = Enum.Font.GothamBlack
songExpandBtn.TextSize = 14
songExpandBtn.AutoButtonColor = false
guiCorner(songExpandBtn,6)
guiStroke(songExpandBtn,C.divider,1)

local songNameLbl = Instance.new("TextLabel",songRow)
songNameLbl.Size = UDim2.new(0,110,1,0)
songNameLbl.Position = UDim2.new(1,-142,0,0)
songNameLbl.BackgroundTransparency = 1
songNameLbl.Text = INTRO_SONGS[introSongIndex] and INTRO_SONGS[introSongIndex].name or ""
songNameLbl.TextColor3 = C.textDim
songNameLbl.TextSize = 10
songNameLbl.Font = Enum.Font.GothamBold
songNameLbl.TextXAlignment = Enum.TextXAlignment.Right

local songList = Instance.new("Frame",cfgPage)
songList.Size = UDim2.new(1,0,0,0)
songList.BackgroundColor3 = Color3.fromRGB(10,10,12)
songList.BackgroundTransparency = 0.3
songList.BorderSizePixel = 0
songList.LayoutOrder = 2.5
songList.ClipsDescendants = true
songList.Visible = false
songList.Parent = cfgPage
guiCorner(songList,10)
guiStroke(songList,C.divider,1)

local songListPad = Instance.new("UIPadding", songList)
songListPad.PaddingTop = UDim.new(0,8)
songListPad.PaddingBottom = UDim.new(0,8)
songListPad.PaddingLeft = UDim.new(0,8)
songListPad.PaddingRight = UDim.new(0,8)

local songListLay = Instance.new("UIListLayout", songList)
songListLay.SortOrder = Enum.SortOrder.LayoutOrder
songListLay.Padding = UDim.new(0,6)

local songButtons = {}
for i, song in ipairs(INTRO_SONGS) do
    local btn = Instance.new("TextButton", songList)
    btn.Size = UDim2.new(1,0,0,34)
    btn.BackgroundColor3 = (i == introSongIndex) and Color3.fromRGB(255,255,255) or Color3.fromRGB(20,20,24)
    btn.BorderSizePixel = 0
    btn.Text = song.name
    btn.TextColor3 = (i == introSongIndex) and Color3.fromRGB(0,0,0) or Color3.fromRGB(230,230,235)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.AutoButtonColor = false
    btn.LayoutOrder = i
    guiCorner(btn,8)
    guiStroke(btn, Color3.fromRGB(60,60,70), 1)

    btn.MouseButton1Click:Connect(function()
        introSongIndex = i
        Config.introSongIndex = i
        songNameLbl.Text = song.name
        for j, b in ipairs(songButtons) do
            local on = (j == i)
            b.BackgroundColor3 = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(20,20,24)
            b.TextColor3 = on and Color3.fromRGB(0,0,0) or Color3.fromRGB(230,230,235)
            local st = b:FindFirstChildOfClass("UIStroke")
            if st then
                st.Color = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(60,60,70)
                st.Thickness = on and 1.8 or 1
            end
        end
        queueSave()
        if introSongEnabled then
            task.spawn(function() playIntroSongAndFlash(introSongIndex) end)
        end
    end)
    table.insert(songButtons, btn)
end

local songExpanded = false
songExpandBtn.MouseButton1Click:Connect(function()
    songExpanded = not songExpanded
    songExpandBtn.Text = songExpanded and "+" or "-"
    if songExpanded then
        songList.Visible = true
        songList.Size = UDim2.new(1, 0, 0, 0)
        local h = #INTRO_SONGS * 40 + 16
        TweenService:Create(songList, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, h)}):Play()
    else
        local t = TweenService:Create(songList, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 0)})
        t:Play()
        t.Completed:Connect(function() if not songExpanded then songList.Visible = false end end)
    end
    task.defer(refreshCanvas)
end)

-- ============================================================
-- CHANGE BACKGROUND (Config)
-- ============================================================
local bgRow = Instance.new("Frame", cfgPage)
bgRow.Size = UDim2.new(1,0,0,38)
bgRow.BackgroundColor3 = C.row
bgRow.BackgroundTransparency = 0.5
bgRow.BorderSizePixel = 0
bgRow.LayoutOrder = 2
bgRow.Parent = cfgPage
guiCorner(bgRow,10); guiStroke(bgRow,C.divider,1)

local bgLbl = Instance.new("TextLabel", bgRow)
bgLbl.Size = UDim2.new(0.48,0,0,16)
bgLbl.Position = UDim2.new(0,12,0,5)
bgLbl.BackgroundTransparency = 1
bgLbl.Text = "Change Background"
bgLbl.TextColor3 = C.text
bgLbl.TextSize = 11
bgLbl.Font = Enum.Font.GothamBold
bgLbl.TextXAlignment = Enum.TextXAlignment.Left

local bgNameLbl = Instance.new("TextLabel", bgRow)
bgNameLbl.Size = UDim2.new(0.30,0,0,16)
bgNameLbl.Position = UDim2.new(0.48,0,0,5)
bgNameLbl.BackgroundTransparency = 1
bgNameLbl.Text = "Default"
bgNameLbl.TextColor3 = C.textDim
bgNameLbl.TextSize = 9
bgNameLbl.Font = Enum.Font.GothamMedium
bgNameLbl.TextXAlignment = Enum.TextXAlignment.Right
bgNameLbl.TextTruncate = Enum.TextTruncate.AtEnd

local bgExpandBtn = Instance.new("TextButton", bgRow)
bgExpandBtn.Size = UDim2.fromOffset(58,22)
bgExpandBtn.Position = UDim2.new(1,-68,0.5,-11)
bgExpandBtn.BackgroundColor3 = C.input
bgExpandBtn.BackgroundTransparency = 0.2
bgExpandBtn.BorderSizePixel = 0
bgExpandBtn.Text = "OPEN"
bgExpandBtn.TextColor3 = C.text
bgExpandBtn.TextSize = 10
bgExpandBtn.Font = Enum.Font.GothamBold
bgExpandBtn.AutoButtonColor = false
guiCorner(bgExpandBtn,6); guiStroke(bgExpandBtn,C.divider,1)

-- ============================================================
-- BACKGROUND PICTURE GALLERY
-- ============================================================
local KyzBackground = {}
KyzBackground.__index = KyzBackground

function KyzBackground.new()
    local self = setmetatable({}, KyzBackground)
    self.backgroundIndex = tonumber(Config.bgIndex) or 0
    self.defs = {
        {name="Default", url="rbxassetid://102775518748491"},
        {name="KYZ 1", url="https://happy-image-link.lovable.app/api/public/f/kx7m2a128.png"},
        {name="KYZ 2", url="https://happy-image-link.lovable.app/api/public/f/kx7m2a94.png"},
        {name="KYZ 3", url="https://happy-image-link.lovable.app/api/public/f/kx7m2a129.png"},
        {name="KYZ 4", url="https://happy-image-link.lovable.app/api/public/f/kx7m2a130.png"},
        {name="KYZ 5", url="https://happy-image-link.lovable.app/api/public/f/kx7m2a131.png"},
    }
    self.custom = {}
    if type(Config.bgCustom) == "table" then
        for _, item in ipairs(Config.bgCustom) do
            if type(item) == "table" and type(item.url) == "string" and item.url ~= "" then
                table.insert(self.custom, {
                    name = tostring(item.name or ("Custom " .. tostring(#self.custom + 1))),
                    url = item.url,
                })
            end
        end
    end
    return self
end

function KyzBackground:_asset(src, idx)
    src = tostring(src or "")
    if src == "" then return "" end
    if src:lower():sub(1,11) == "rbxassetid:" or src:lower():sub(1,11) == "rbxasset://" then
        return src
    end
    if tonumber(src) then return "rbxassetid://" .. src end
    local ok, asset = pcall(loadCustomImageAsset, src, "skibidi_kyz_bg_" .. tostring(idx or 0) .. ".png")
    if ok and asset and asset ~= "" then return asset end
    return src
end

function KyzBackground:apply(idx)
    idx = tonumber(idx) or 0
    if idx < 0 or idx > #self.defs + #self.custom then idx = 0 end
    self.backgroundIndex = idx
    Config.bgIndex = idx
    if idx == 0 then
        BG_IMAGE = "rbxassetid://102775518748491"
        if BgImage then BgImage.Image = BG_IMAGE end
        if BgOverlay then BgOverlay.BackgroundTransparency = 0.55; BgOverlay.Visible = true end
    else
        local d = self.defs[idx]
        if not d then d = self.custom[idx - #self.defs] end
        if d then
            BG_IMAGE = d.url
            local token = idx
            task.spawn(function()
                local asset = self:_asset(d.url, token)
                if BgImage and BgImage.Parent and self.backgroundIndex == token then
                    BgImage.Image = asset
                    BgImage.Visible = true
                    if BgOverlay then BgOverlay.Visible = true; BgOverlay.BackgroundTransparency = 0.55 end
                end
            end)
        end
    end
    if bgNameLbl then
        local d = self.defs[idx] or self.custom[idx - #self.defs]
        bgNameLbl.Text = d and d.name or "Default"
    end
    if queueSave then queueSave() end
    -- Persist the selected preset index so the background is restored on the next run.
    if saveConfig then task.defer(function() pcall(saveConfig) end) end
end

function KyzBackground:open()
    local CoreGui = game:GetService("CoreGui")
    local Lighting = game:GetService("Lighting")
    local TweenService = game:GetService("TweenService")
    local old = CoreGui:FindFirstChild("KyzDuelsBackgroundGalleryLayer")
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "KyzDuelsBackgroundGalleryLayer"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999
    gui.Parent = CoreGui

    local blur = Instance.new("BlurEffect")
    blur.Name = "KyzDuelsBGGalleryBlur"
    blur.Size = 0
    blur.Parent = Lighting

    local overlay = Instance.new("TextButton", gui)
    overlay.Size = UDim2.fromScale(1,1)
    overlay.BackgroundColor3 = Color3.fromRGB(2,3,8)
    overlay.BackgroundTransparency = 0.35
    overlay.Text = ""
    overlay.AutoButtonColor = false

    local popup = Instance.new("Frame", overlay)
    popup.AnchorPoint = Vector2.new(.5,.5)
    popup.Position = UDim2.fromScale(.5,.5)
    popup.Size = UDim2.fromOffset(440,430)
    popup.BackgroundColor3 = Color3.fromRGB(10,10,14)
    popup.BorderSizePixel = 0
    guiCorner(popup,18)
    guiStroke(popup,Color3.fromRGB(55,55,65),1)

    local title = Instance.new("TextLabel", popup)
    title.Position = UDim2.fromOffset(16,12)
    title.Size = UDim2.new(1,-60,0,26)
    title.BackgroundTransparency = 1
    title.Text = "KYZ DUELS BACKGROUNDS"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left

    local close = Instance.new("TextButton", popup)
    close.Position = UDim2.new(1,-42,0,10)
    close.Size = UDim2.fromOffset(30,30)
    close.BackgroundColor3 = Color3.fromRGB(28,28,32)
    close.Text = "×"
    close.TextColor3 = Color3.fromRGB(230,230,235)
    close.TextSize = 20
    close.Font = Enum.Font.GothamBold
    close.AutoButtonColor = false
    guiCorner(close,8)

    local preview = Instance.new("ImageLabel", popup)
    preview.Position = UDim2.fromOffset(16,52)
    preview.Size = UDim2.new(1,-32,0,220)
    preview.BackgroundColor3 = Color3.fromRGB(15,15,19)
    preview.BorderSizePixel = 0
    preview.ScaleType = Enum.ScaleType.Crop
    guiCorner(preview,12)

    local scroll = Instance.new("ScrollingFrame", popup)
    scroll.Position = UDim2.fromOffset(16,284)
    scroll.Size = UDim2.new(1,-32,0,58)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollingDirection = Enum.ScrollingDirection.X
    local lay = Instance.new("UIListLayout", scroll)
    lay.FillDirection = Enum.FillDirection.Horizontal
    lay.Padding = UDim.new(0,8)
    lay.VerticalAlignment = Enum.VerticalAlignment.Center

    local add = Instance.new("TextButton", popup)
    add.Position = UDim2.fromOffset(16,354)
    add.Size = UDim2.fromOffset(120,34)
    add.BackgroundColor3 = Color3.fromRGB(24,30,42)
    add.Text = "+ ADD BACKGROUND"
    add.TextColor3 = Color3.fromRGB(205,215,240)
    add.Font = Enum.Font.GothamBold
    add.TextSize = 10
    add.AutoButtonColor = false
    guiCorner(add,9)

    local apply = Instance.new("TextButton", popup)
    apply.Position = UDim2.new(1,-156,0,354)
    apply.Size = UDim2.fromOffset(140,34)
    apply.BackgroundColor3 = Color3.fromRGB(42,48,65)
    apply.Text = "APPLY BACKGROUND"
    apply.TextColor3 = Color3.fromRGB(235,238,245)
    apply.Font = Enum.Font.GothamBold
    apply.TextSize = 10
    apply.AutoButtonColor = false
    guiCorner(apply,9)

    local selected = self.backgroundIndex
    local cards = {}
    local all = {}
    for _,d in ipairs(self.defs) do table.insert(all,d) end
    for _,d in ipairs(self.custom) do table.insert(all,d) end

    local function assetFor(i)
        local d=all[i]
        return d and self:_asset(d.url,i) or ""
    end
    local function refresh()
        preview.Image = selected == 0 and "" or assetFor(selected)
        apply.Text = selected == self.backgroundIndex and "APPLIED" or "APPLY BACKGROUND"
        for i,b in pairs(cards) do
            local st=b:FindFirstChildOfClass("UIStroke")
            if st then st.Color=(i==selected) and Color3.fromRGB(235,235,240) or Color3.fromRGB(55,58,70); st.Thickness=(i==selected) and 2 or 1 end
        end
    end
    local none=Instance.new("TextButton",scroll)
    none.Size=UDim2.fromOffset(88,52); none.Text="NONE"; none.BackgroundColor3=Color3.fromRGB(18,18,22); none.TextColor3=Color3.fromRGB(210,210,220); none.Font=Enum.Font.GothamBold; none.TextSize=11; none.AutoButtonColor=false; guiCorner(none,9); guiStroke(none,Color3.fromRGB(55,58,70),1)
    none.MouseButton1Click:Connect(function() selected=0; refresh() end)
    cards[0]=none
    for i,d in ipairs(all) do
        local b=Instance.new("ImageButton",scroll)
        b.Size=UDim2.fromOffset(88,52); b.BackgroundColor3=Color3.fromRGB(18,18,22); b.Image=assetFor(i); b.ScaleType=Enum.ScaleType.Crop; b.AutoButtonColor=false; guiCorner(b,9); guiStroke(b,Color3.fromRGB(55,58,70),1)
        b.MouseButton1Click:Connect(function() selected=i; refresh() end)
        cards[i]=b
    end
    scroll.CanvasSize=UDim2.fromOffset((#all+1)*96,52)
    refresh()

    local function closeAll()
        pcall(function() blur:Destroy() end)
        pcall(function() gui:Destroy() end)
    end
    close.MouseButton1Click:Connect(closeAll)
    overlay.MouseButton1Click:Connect(function(x,y)
        if x <= popup.AbsolutePosition.X or x >= popup.AbsolutePosition.X+popup.AbsoluteSize.X or y <= popup.AbsolutePosition.Y or y >= popup.AbsolutePosition.Y+popup.AbsoluteSize.Y then closeAll() end
    end)
    apply.MouseButton1Click:Connect(function() self:apply(selected); task.delay(.1,closeAll) end)
    add.MouseButton1Click:Connect(function()
        local box=Instance.new("TextBox",popup); box.Position=UDim2.fromOffset(16,394); box.Size=UDim2.new(1,-132,0,26); box.BackgroundColor3=Color3.fromRGB(8,8,12); box.Text=""; box.PlaceholderText="Lovable link or rbx id"; box.TextColor3=Color3.fromRGB(235,235,245); box.TextSize=10; box.Font=Enum.Font.GothamMedium; box.ClearTextOnFocus=false; guiCorner(box,7)
        local ok=Instance.new("TextButton",popup); ok.Position=UDim2.new(1,-108,0,394); ok.Size=UDim2.fromOffset(92,26); ok.BackgroundColor3=Color3.fromRGB(40,55,90); ok.Text="ADD"; ok.TextColor3=Color3.fromRGB(230,235,255); ok.Font=Enum.Font.GothamBold; ok.TextSize=10; guiCorner(ok,7)
        ok.MouseButton1Click:Connect(function()
            local raw=box.Text:gsub("^%s+",""):gsub("%s+$","")
            if raw=="" then box.PlaceholderText="Enter a URL or asset id"; return end
            local url=tonumber(raw) and "rbxassetid://"..raw or raw
            table.insert(self.custom,{name="Custom "..tostring(#self.custom+1),url=url})
            Config.bgCustom = self.custom
            if queueSave then queueSave() end
            box:Destroy(); ok:Destroy(); gui:Destroy(); self:open()
        end)
    end)
    TweenService:Create(blur,TweenInfo.new(.25),{Size=12}):Play()
end

local BG_GALLERY = KyzBackground.new()
BG_GALLERY:apply(Config.bgIndex or 0)
bgExpandBtn.Text = "OPEN"
bgExpandBtn.Size = UDim2.fromOffset(42,22)
bgExpandBtn.Position = UDim2.new(1,-50,0.5,-11)
if bgNameLbl then bgNameLbl.Text = BG_GALLERY.defs[Config.bgIndex] and BG_GALLERY.defs[Config.bgIndex].name or "Default" end
bgExpandBtn.MouseButton1Click:Connect(function() BG_GALLERY:open() end)

local _, fontToggleSet = addToggleRow(cfgPage,"Starborn Font",fontChangeEnabled,3,function(on)
    setFontChangeEnabled(on, GuiHub)
end)

local _, lockToggleSet = addToggleRow(cfgPage,"Lock UI",uiLocked,4,function(on)
    uiLocked = on
    Config.uiLocked = on
    queueSave()
end)

local cfgInfoRow = Instance.new("Frame")
cfgInfoRow.Size = UDim2.new(1,0,0,76)
cfgInfoRow.BackgroundColor3 = C.row
cfgInfoRow.BackgroundTransparency = 0.5
cfgInfoRow.BorderSizePixel = 0
cfgInfoRow.LayoutOrder = 5
cfgInfoRow.Parent = cfgPage
guiCorner(cfgInfoRow,10); guiStroke(cfgInfoRow,C.divider,1)

local cfgInfoLbl = Instance.new("TextLabel",cfgInfoRow)
cfgInfoLbl.Size = UDim2.new(1,-16,0,20)
cfgInfoLbl.Position = UDim2.new(0,8,0,6)
cfgInfoLbl.BackgroundTransparency = 1
cfgInfoLbl.Text = "more coming soon and better"
cfgInfoLbl.TextColor3 = C.white
cfgInfoLbl.TextSize = 12
cfgInfoLbl.Font = Enum.Font.GothamBold
cfgInfoLbl.TextWrapped = true
cfgInfoLbl.TextXAlignment = Enum.TextXAlignment.Left
cfgInfoLbl.TextYAlignment = Enum.TextYAlignment.Top

local cfgSubLbl = Instance.new("TextLabel",cfgInfoRow)
cfgSubLbl.Size = UDim2.new(1,-16,0,20)
cfgSubLbl.Position = UDim2.new(0,8,0,30)
cfgSubLbl.BackgroundTransparency = 1
cfgSubLbl.Text = "this is just a test (no ban)"
cfgSubLbl.TextColor3 = C.textDim
cfgSubLbl.TextSize = 10
cfgSubLbl.Font = Enum.Font.GothamBold
cfgSubLbl.TextWrapped = true
cfgSubLbl.TextXAlignment = Enum.TextXAlignment.Left
cfgSubLbl.TextYAlignment = Enum.TextYAlignment.Top

-- SKIBIDI MUSIC (inside Config)
local skibidiMusicStarted = false
local skibidiMusicRow = Instance.new("Frame", cfgPage)
skibidiMusicRow.Size = UDim2.new(1,0,0,38)
skibidiMusicRow.BackgroundColor3 = C.row
skibidiMusicRow.BackgroundTransparency = 0.5
skibidiMusicRow.BorderSizePixel = 0
skibidiMusicRow.LayoutOrder = 5
skibidiMusicRow.Parent = cfgPage
guiCorner(skibidiMusicRow,10); guiStroke(skibidiMusicRow,C.divider,1)

local skibidiMusicLbl = Instance.new("TextLabel",skibidiMusicRow)
skibidiMusicLbl.Size = UDim2.new(0.65,0,1,0)
skibidiMusicLbl.Position = UDim2.new(0,12,0,0)
skibidiMusicLbl.BackgroundTransparency = 1
skibidiMusicLbl.Text = "Skibidi Music"
skibidiMusicLbl.TextColor3 = C.text
skibidiMusicLbl.TextSize = 11
skibidiMusicLbl.Font = Enum.Font.GothamBold
skibidiMusicLbl.TextXAlignment = Enum.TextXAlignment.Left

local skibidiMusicBtn = Instance.new("TextButton",skibidiMusicRow)
skibidiMusicBtn.Size = UDim2.new(0,72,0,24)
skibidiMusicBtn.Position = UDim2.new(1,-82,0.5,-12)
skibidiMusicBtn.BackgroundColor3 = C.input
skibidiMusicBtn.BorderSizePixel = 0
skibidiMusicBtn.Text = "OPEN"
skibidiMusicBtn.TextColor3 = C.text
skibidiMusicBtn.TextSize = 10
skibidiMusicBtn.Font = Enum.Font.GothamBold
skibidiMusicBtn.AutoButtonColor = false
guiCorner(skibidiMusicBtn,6); guiStroke(skibidiMusicBtn,C.divider,1)

local skibidiMusicSource = [=[

getgenv().YMP = getgenv().YMP or false

if getgenv().YMP then
	return
end

getgenv().YMP = true
task.wait(0.5)

local fn = cloneref or function(arg)
	return arg
end

local tweenInfo = TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tbl = { Ordem = "relevance", Data = "any", Duracao = "any", Pagina = 1 }
local tweenInfo3 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local ordem = "relevance"
local data = "any"
local duracao = "any"
local tbl2 = { "relevance", "view" }
local tbl3 = { "any", "hours", "today", "week", "month", "year" }
local tbl4 = { "any", "short", "medium", "long" }
local tbl5 = {}
local tbl6 = {}
local tbl7 = {}
local tbl8 = {}
local tbl9 = {}
local tbl10 = {}
local tbl11 = {}
local v = fn(game:GetService("CoreGui"))
local v2 = fn(game:GetService("StarterGui"))
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = v
screenGui.IgnoreGuiInset = true
HttpService = fn(game:GetService("HttpService"))
local v3 = fn(game:GetService("Lighting"))
local v4 = fn(game:GetService("Players"))
local userId = v4.LocalPlayer.UserId
local str = v4.LocalPlayer.LocaleId:lower()
local v5 = fn(game:GetService("LogService"))
local v6 = fn(game:GetService("TweenService"))
fn(Instance.new("Sound"))
local v7 = fn(game:GetService("SoundService"))
local v8 = fn(game:GetService("Workspace"))
fn(game:GetService("RunService"))
fn(game:GetService("TextService"))
local v9 = fn(game:GetService("UserInputService"))
local currentCamera = v8.CurrentCamera
local flag = false
local flag2 = false
local screenGui2 = nil
local n = 1
local str2 = "Todos"
local flag3 = false
local flag4 = false
local n2 = 0
local v10 = nil
local tweenInfo4 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo5 = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo6 = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local flag5 = true
local flag6 = false
local str3 = "https://ymp-api.ddns.net"
local websocket_ = WebSocket or websocket or Websocket or syn and syn.websocket or nil
local flag7 = false
local flag8 = false
local str4 = "Auto"
local v11 = nil
local flag9 = false
local v12 = nil
local udim2 = nil
local flag10 = false
local flag11 = false
local flag12 = false
local flag13 = false
local tween = nil
local n3 = 0
local text = nil
local flag14 = false
local layoutOrder = 0
local udim22 = UDim2.new(0, 4, 0, 4)
local udim23 = UDim2.new(0, 4, 1, 4)
local flag15 = true
local tween2 = nil
local v13 = nil
local tween3 = nil
local flag16 = false
local flag17 = false
local request_ = request or http_request or syn_request or syn and syn.request or http and http.request or fluxus and fluxus.request or getgenv and getgenv().request
local requestAsync

if request_ then
	requestAsync = request_
else
	requestAsync = http and http.request_async
end

local writeClipboard = setclipboard or toclipboard or syn and syn.write_clipboard
local setclipboard_

if writeClipboard then
	setclipboard_ = writeClipboard
else
	setclipboard_ = fluxus and fluxus.setclipboard
end

local gethwid_ = gethwid and gethwid()

if not gethwid_ then
	gethwid_ = syn and syn.gethwid and syn.gethwid()
end

gethwid_ = gethwid_ or fluxus and fluxus.gethwid and fluxus.gethwid()
local hwid

if gethwid_ then
	hwid = gethwid_
else
	hwid = getgenv and getgenv().hwid
end

local v14 = hwid or userId
local flag18 = typeof(clonefunction) == "function" and clonefunction or nil
local v15 = flag18 and flag18(pcall) or pcall
local v16 = flag18 and flag18(typeof) or typeof

CheckRequest = function()
	local v17 = v15(function()
		return ishooked
	end) and ishooked or nil

	local v18 = v15(function()
		return restorefunction
	end) and restorefunction or nil

	if v16(v18) == "function" and v16(v17) == "function" then
		local v19, v20 = v15(v17, v17)

		if v19 and v20 then
			v15(v18, v17)
		end
	end

	if v16(v17) == "function" then
		local v19, v20 = v15(v17, requestAsync)
		if v19 and v20 then
			return false
		end
		local v21, v22 = v15(v17, game.HttpGet)
		if v21 and v22 then
			return false
		end
	end

	return true
end

if not CheckRequest() then
	return
end

local ok, result = pcall(game.HttpGet, game, "https://raw.githubusercontent.com/Dan41/Roblox-Scripts/refs/heads/main/Youtube%20Music%20Player/Versao")

if not ok or not result or not CheckRequest() then
	return
end

local str5 = result:gsub("%s+", ""):gsub("[^%w.]", "")

if str5 == "off" then
	return
end

-- Remote version redirect disabled so the local customized script keeps running.

-- Startup update notification removed.

Carregar = function()
	if not flag then
		flag = true
		screenGui2 = Instance.new("ScreenGui")
		screenGui2.Parent = v
		local imageLabel = Instance.new("ImageLabel")
		imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		imageLabel.Size = UDim2.new(0, 0, 0, 0)
		imageLabel.Position = UDim2.new(0.5, 0, 0.4, 0)
		imageLabel.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		imageLabel.Image = "rbxassetid://132058030456598"
		imageLabel.Active = true
		imageLabel.Draggable = false
		imageLabel.Parent = screenGui2
		local uiCorner = Instance.new("UICorner")
		uiCorner.CornerRadius = UDim.new(0, 5)
		uiCorner.Parent = imageLabel
		local uiStroke = Instance.new("UIStroke")
		uiStroke.Thickness = 2
		uiStroke.Color = Color3.fromRGB(255, 0, 0)
		uiStroke.Parent = imageLabel
		local tween4 = v6:Create(imageLabel, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(0.4, 0, 0.5, 0), Position = UDim2.new(0.5, 0, 0.4, 0) })
		tween4:Play()

		tween4.Completed:Connect(function()
			if not flag then
				return
			end
			flag2 = true

			task.spawn(function()
				while true do
					if flag2 and imageLabel.Parent then
						local tween5 = v6:Create(imageLabel, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Position = UDim2.new(0.5, 0, 0.38, 0) })
						local tween6 = v6:Create(imageLabel, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Position = UDim2.new(0.5, 0, 0.42, 0) })
						tween5:Play()
						tween5.Completed:Wait()

						if flag2 then
							tween6:Play()
							tween6.Completed:Wait()
							continue
						end
					end

					break
				end
			end)
		end)
	else
		flag = false
		flag2 = false

		if screenGui2 then
			local imageLabel = screenGui2:FindFirstChildWhichIsA("ImageLabel")

			if imageLabel then
				local tween4 = v6:Create(imageLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					Position = UDim2.new(0.5, 0, -0.5, 0),
					BackgroundTransparency = 1,
					ImageTransparency = 1,
				})

				tween4:Play()

				tween4.Completed:Connect(function()
					if screenGui2 then
						screenGui2:Destroy()
						screenGui2 = nil
					end
				end)
			else
				screenGui2:Destroy()
				screenGui2 = nil
			end
		end
	end
end

Carregar()

Traducao = {
	Sucesso = "Success",
	Erro = "Error",
	Imcompativel = "Your executor does not have support",
	Navegacao = "Navigation",
	Player = "Media Player",
	Add = "Add New",
	Equalizador = "Audio adjustment",
	Welcome = "Welcome",
	Dev = "Creator",
	Hey = "Hey you!",
	Play = "Play a song for me",
	Volume = "Volume",
	Freque = "Sound frequencies",
	Efeitos = "Sound effects",
	Graves = "Bass",
	Medios = "Mids",
	Agudos = "Treble",
	Nenhum = "None",
	Todos = "All",
	Musicas = "Musics",
	Favoritos = "Favorites",
	Favoritado = "Added to favorites",
	Desfavoritado = "Removed from favorites",
	Excluido = "Content deleted",
	Vazio = "Empty",
	VazioTexto = "There is nothing in this category at the moment",
	Search = "Search",
	Pesquisar = "Search for a YouTube title or link",
	Pesquisar2 = "Search for a YouTube title or link, or a Roblox ID",
	PesquiseTitle = "Start a search",
	PesquiseText = "We'll do our best to find your video or music",
	PesquiseTextPL = "We'll search through your entire playlist",
	SemResutadoTitle = "No results",
	SemResutadoText = "We checked everywhere possible, but we couldn't find any results for that search",
	SemResutadoTextPL = "We didn't find any results for that search in your playlist",
	LocalTitle = "Local Audios",
	LocalText = "There's nothing here yet, Add new audio files to the 'Local Audio' folder of the script",
	EscolhaFor = "Select the desired format",
	Musica = "Music",
	Cancelar = "Cancel",
	De = "By",
	In = "In",
	ErroCrackTitle = "Request denied",
	ErroCrackText = "It appears you do not have a valid Premium key",
	ErroTitle = "Something went wrong",
	ErroText = "There was an instability on our servers or in your internet connection, Please try again",
	Aguarde = "Please wait",
	Dados = "We are obtaining data from your file",
	MaisUmPauco = "Almost ready",
	Baixando = "We are downloading your file to add it to your playlist",
	Baixado = "Download complete!",
	Terminou = "Everything went well, and it's already been added to your playlist",
	Priv1 = "Download and play videos",
	Priv2 = "Advanced search",
	PP = "Premium Privilege",
	SobrePri1 = "You will be able to download and watch any YouTube video",
	SobrePri2 = "Have an advanced search that includes search filters and more pages of results",
	SobrePri3 = "You can use MiniPlayer to watch videos or control music on a small floating window",
	SobrePri4 = "Add and listen to any audio from the Roblox library",
	SobrePri5 = "You will be able to interact in Global Chat and converse with other YouTube Music Player users in real time",
	SobrePri6 = "The floating button will have a stylish yellow look!",
	Key = "Enter the Premium key here",
	Link = "Get a free key",
	Robux = "Buy a key with Robux",
	KeyInvalida = "The key you provided is invalid or has expired!",
	KeyErro = "An error occurred while validating your key, Please try again in a few seconds",
	JaTemKey = "It seems to me that you already have a registered key",
	LinkCopiado = "Link copied!",
	Navegador = "Paste the link into your browser to get the key",
	TooMany = "Too many requests",
	RateLi = "You are making too many requests, Wait a few seconds and try again!",
	KeyError = "An error occurred in the key system, Please try again",
	OpcaoBloqueadaTitle = "Option blocked",
	OpcaoBloqueadaText = "Get a Premium key to use this!",
	NenhumaMidia = "No valid tracks found in your playlist's current category!",
	PlayMode = "Playback mode",
	Auto = "Auto-skip: The next track from the current category in your playlist will be selected automatically",
	Repetir = "Repeat: The current track you are listening to will be repeated on a loop",
	Random = "Random: The system will randomly select a track from the current category of your playlist",
	PlayModeRepetir = "No valid tracks found in your playlist's current category, Repeating...",
	DownloadFazendo = "Wait for the system to finish loading the images",
	RecursoTi = "Resource unavailable",
	RecursoTe = "The main equalizer options are not compatible with video",
	RsetadoEqua = "All the changes you made to the equalizer have been removed!",
	NaoPodePagina = "You cannot change pages at the moment",
	NaoPodeFiltro = "Do a search before applying filters!",
	Processando = "Processing...",
	Filter = "Search filters",
	Order = "Order:",
	UploaDate = "Upload Date:",
	Duration = "Duration:",
	AplicarF = "Apply filters",
	RemoverF = "Remove filters",
	Relevance = "Relevance",
	View = "Most viewed",
	Any = "Any",
	Hours = "Last hours",
	Today = "Today",
	Week = "This week",
	Month = "This month",
	Year = "This year",
	Short = "Short(less than 4 minutes)",
	Long = "Long(more than 20 minutes)",
	Medium = "Medium(4 to 20 minutes)",
	JaTemRoblox = "You already have this Roblox ID in your playlist!",
	JaTemMusica = "You already have this song in your playlist!",
	JaTemVideo = "You already have this video in your playlist!",
	FiltrosRemovidos = "All applied filters have been removed!",
	FiltrosJaPadrao = "All filters are already defined by default!",
	Privado = "This audio has been set to private or deleted, It cannot be played",
	VocePremium = "Validated Key",
	Keyless = "Global Chat keyless",
	KeylessOn = "Keyless mode is enabled, Global chat is now unlocked!",
	KeylessOff = "Keyless mode has been disabled, Global Chat is blocked!",
	VocePremiumTexto = "Your Premium has been successfully activated, Enjoy your privileges!",
	Respeito = "Follow the rules to avoid being banned",
	RegrasTi = "Chat Rules",
	Regras = "No insults, No racism, No inappropriate or malicious content, No spam, No suspicious links",
	Sistema = "System",
	EnvieGc = "Write something...",
	GcKey = "Get a premium key to send messages in global chat",
	GcBan = "You have been banned from Global Chat, You can appeal on Discord using your ID:",
	GcUnban = "You have been unbanned from global chat, Behave yourself to avoid being banned again!",
	Banido = "You have been banned",
	Desbanido = "You have been unbanned",
	ExploitIcomGC = "Your executor does not support Global Chat!",
	TraducaoSystem = "Translation",
	TraduOn = "The Global Chat translation system has been enabled",
	TraduOff = "The Global Chat translation system has been disabled",
	TextoCopiado = "Copied message",
	Mutado = "Sounds Removed",
	Desmutado = "Sounds Restored",
	SobreMute = "All game sounds have been removed",
	SobreUnmute = "All the game sounds have been restored",
	AvisoReport1 = "Report Notice — You are about to report the user",
	AvisoReport2 = "on Global Chat, Are you sure you want to continue? False reports that do not involve an actual rule violation may result in a ban.",
	ReportSucesso = "Report sent!",
	ReportSucesso2 = "Your report has been submitted to our staff team, We will review it and take the necessary actions",
	MotivoReport = "Enter the reason for the report here",
	ReportErro = "Report Error",
	ReportErro1 = "For security reasons, you must have a valid Premium key to submit reports",
	ReportErro2 = "The reported message could not be found, Are you attempting to submit a false report?",
	ReportErro3 = "An error occurred while processing the report, Please try again",
	ReportErro4 = "You can only submit new reports every 2 minutes",
	ReportErro5 = "Are you seriously trying to report yourself?",
	ReportErro6 = "You have already reported this message",
	ReportErro7 = "This message has already been reported by another user",
	ReportErro8 = "You are banned and cannot submit reports",
	ReportErro10 = "Write a reason in your report!",
	ReportErro11 = "The reason must be a minimum of 10 characters and a maximum of 200 characters",
	Aviso = "Warning",
	FecharAviso = "Close warn",
	MsgMod = "Message from the moderator:",
	Tutorial = "The link has been copied successfully — Paste it into your browser for instructions on how to resolve download errors",
	Tentando = "Trying Again",
	TentandoTexto = "We will try downloading again",
	GCmudo = "Global Chat muted",
	GCmudoTexto = "New messages will not be notified via the floating button",
	GCunmudo = "Global Chat unmuted",
	GCunmudoTexto = "You will be notified of each new message",
	MidiaErro = "Error loading media",
	MidiaErroMsg = "Could not load: Unsupported executor or corrupted file",
}

pcall(function()
	if str == "en-us" or not Traducao then
		return
	end
	local str6 = str:sub(1, 2)
	local tbl12 = {}
	local tbl13 = {}
	local n4 = 0

	for k, v17 in pairs(Traducao) do
		n4 += 1
		tbl12[n4] = k
		tbl13[n4] = v17
	end

	local str7 = table.concat(tbl13, " || ")

	local ok3, result3 = pcall(function()
		return game:HttpGet("https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=" .. str6 .. "&dt=t&q=" .. HttpService:UrlEncode(str7))
	end)

	if ok3 and result3 then
		local data2 = HttpService:JSONDecode(result3)
		local v17 = data2 and data2[1]
		local str8 = ""

		if v17 then
			for _, v18 in ipairs(data2[1]) do
				str8 ..= v18[1] or ""
			end
		end

		local parts = str8:split("||")

		for i = 1, n4 do
			local v18 = parts[i]

			if v18 then
				Traducao[tbl12[i]] = v18:match("^%s*(.-)%s*$")
			end
		end
	end
end)

TraduzirMsg = function(arg)
	local str6 = (str or "en"):sub(1, 2)

	local ok3, result3 = pcall(function()
		local response = game:HttpGet("https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=" .. str6 .. "&dt=t&q=" .. HttpService:UrlEncode(arg))
		local data2 = HttpService:JSONDecode(response)

		if data2 and data2[1] then
			if data2[2] == str6 then
				return arg
			end
			local tbl12 = {}

			for _, v17 in ipairs(data2[1]) do
				table.insert(tbl12, v17[1] or "")
			end

			return table.concat(tbl12):match("^%s*(.-)%s*$")
		end

		return arg
	end)

	arg = ok3 and result3 or arg
	return arg
end

local sound = Instance.new("Sound")
sound.Looped = false
sound.Parent = v7

local function fn2(arg)
	sound.SoundId = "rbxassetid://" .. arg
	sound:Play()
end

local function fn3(text2, text3, arg, arg2)
	if type(text2) ~= "string" then
		local v17 = tostring
		text2 = text2 or ""
		text2 = v17(text2)
	end

	if type(text3) ~= "string" then
		local v17 = tostring
		text3 = text3 or ""
		text3 = v17(text3)
	end

	if type(arg) ~= "number" then
		arg = 3
	end

	n2 += 1
	local v17 = n2
	fn2(arg2 ~= nil and type(arg2) == "number" and tostring(arg2) or "129485210015224")
	local notifGui = v4.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("NotifGui")

	if not notifGui then
		notifGui = Instance.new("ScreenGui")
		notifGui.Name = "NotifGui"
		notifGui.ResetOnSpawn = false
		notifGui.Parent = v
	end

	if v10 and v10.Parent then
		v10:Destroy()
		v10 = nil
	end

	local imageButton = Instance.new("ImageButton")
	imageButton.Size = UDim2.new(0, 0, 0, 0)
	imageButton.Position = UDim2.new(0.5, 0, 0, 10)
	imageButton.AnchorPoint = Vector2.new(0.5, 0)
	imageButton.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
	imageButton.BackgroundTransparency = 0.08
	imageButton.BorderSizePixel = 0
	imageButton.AutomaticSize = Enum.AutomaticSize.Y
	imageButton.ClipsDescendants = true
	imageButton.Parent = notifGui
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = imageButton
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = Color3.fromRGB(178, 34, 34)
	uiStroke.Thickness = 0
	uiStroke.Parent = imageButton
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, -10, 0, 25)
	textLabel.Position = UDim2.new(0, 5, 0, 5)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = text2
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextScaled = true
	textLabel.TextXAlignment = Enum.TextXAlignment.Center
	textLabel.TextYAlignment = Enum.TextYAlignment.Center
	textLabel.Parent = imageButton
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.Size = UDim2.new(1, -10, 0, -2)
	textLabel2.Position = UDim2.new(0, 5, 0, 35)
	textLabel2.BackgroundTransparency = 1
	textLabel2.TextColor3 = Color3.fromRGB(200, 200, 200)
	textLabel2.Font = Enum.Font.SourceSans
	textLabel2.Size = UDim2.new(1, -10, 0, 0)
	textLabel2.AutomaticSize = Enum.AutomaticSize.Y
	textLabel2.TextWrapped = true
	textLabel2.TextSize = 20
	textLabel2.Text = ""
	textLabel2.TextXAlignment = Enum.TextXAlignment.Center
	textLabel2.TextYAlignment = Enum.TextYAlignment.Center
	textLabel2.Parent = imageButton
	v10 = imageButton
	local tween4 = v6:Create(imageButton, TweenInfo.new(0.45, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), { Size = UDim2.new(0.45, 0, 0, 70) })
	imageButton.Size = UDim2.new(0, 0, 0, 70)
	tween4:Play()
	task.wait(0.1)
	uiStroke.Thickness = 2
	textLabel2.Text = text3
	local flag19 = false

	local function fn4()
		if flag19 then
			return
		end
		flag19 = true
		if not imageButton or not imageButton.Parent then
			return
		end
		textLabel.Text = ""
		textLabel2.Text = ""
		local uiStroke2 = imageButton:FindFirstChildOfClass("UIStroke")

		if uiStroke2 then
			uiStroke2:Destroy()
		end

		local tween5 = v6:Create(imageButton, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Size = UDim2.new(0, 0, 0, imageButton.Size.Y.Offset) })
		tween5:Play()

		tween5.Completed:Connect(function()
			if not imageButton.Parent then
				return
			end
			local tween6 = v6:Create(imageButton, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Size = UDim2.new(0, 0, 0, 0) })
			tween6:Play()

			tween6.Completed:Connect(function()
				if imageButton then
					imageButton:Destroy()
				end

				if v10 == imageButton then
					v10 = nil
				end
			end)
		end)
	end

	imageButton.MouseButton1Click:Connect(fn4)

	task.delay(arg, function()
		if v17 ~= n2 then
			return
		end
		fn4()
	end)
end

for _, v17 in ipairs({
	"writefile",
	"readfile",
	"isfile",
	"delfile",
	"listfiles",
	"makefolder",
	"isfolder",
	"delfolder",
	"getcustomasset",
}) do
	if type(_G[v17] or getgenv()[v17]) ~= "function" then
		fn3(Traducao.Erro, Traducao.Imcompativel, 15)
		Carregar()
		getgenv().YMP = false
		return
	end
end

if not requestAsync then
	fn3(Traducao.Erro, Traducao.Imcompativel, 15)
	Carregar()
	getgenv().YMP = false
	return
end

if not isfolder("YouTube Music Player") then
	makefolder("YouTube Music Player")
end

if not isfolder("YouTube Music Player/Musics") then
	makefolder("YouTube Music Player/Musics")
end

if not isfolder("YouTube Music Player/Videos") then
	makefolder("YouTube Music Player/Videos")
end

if not isfolder("YouTube Music Player/Roblox IDS") then
	makefolder("YouTube Music Player/Roblox IDS")
end

if not isfolder("YouTube Music Player/Local Audios") then
	makefolder("YouTube Music Player/Local Audios")
end

if not isfolder("YouTube Music Player/Internal") then
	makefolder("YouTube Music Player/Internal")
end

if not isfolder("YouTube Music Player/Internal/Cache") then
	makefolder("YouTube Music Player/Internal/Cache")
end

if isfolder("YouTube Music Player/Cache") then
	delfolder("YouTube Music Player/Cache")
end

if not isfile("YouTube Music Player/Internal/Data.json") then
	writefile("YouTube Music Player/Internal/Data.json", "[{\"Key\":\"\",\"Favorites\":[]}]")
end

if not isfile("YouTube Music Player/[ IMPORTANT ] README.txt") then
	writefile("YouTube Music Player/[ IMPORTANT ] README.txt", [[[ YouTube Music Player ]

This script was developed by @Termux_404
I am deeply grateful for using my script! :D

[>] If you want to add audio files without downloading them using the script's search and download engine, place the MP3 file in the folder "Local Audios"
Make sure the file is not corrupted or too large, otherwise the audio will not play.

[ Social media ]

Discord server: https://discord.gg/kbh2dEdnYP

YouTube channel: https://youtube.com/@termux_404

Scriptblox: https://scriptblox.com/u/Termux_404

Have a good game and enjoy!]])
end

if not isfile("YouTube Music Player/Internal/Cache/ABOUT CACHE.txt") then
	writefile("YouTube Music Player/Internal/Cache/ABOUT CACHE.txt", [[[YouTube Music Player Cache]

This folder is used to temporarily store images to help things load faster.

All files here will be cleared the first time you execute the script.

You can ignore everything here without any problem! :D]])
end

if isfile("YouTube Music Player/[YMP] README.txt") then
	delfile("YouTube Music Player/[YMP] README.txt")
end

for _, v17 in ipairs(listfiles("YouTube Music Player/Internal/Cache")) do
	if not string.find(v17, "ABOUT CACHE.txt") then
		delfile(v17)
	end
end

if isfile("YouTube Music Player/Musics/TAn5b0_j64s.mp3") then
	delfile("YouTube Music Player/Musics/TAn5b0_j64s.mp3")
end

pcall(function()
	if not isfile("YouTube Music Player/Musics/LvvrO6JifEA.mp3") then
		writefile("YouTube Music Player/Musics/LvvrO6JifEA.mp3", game:HttpGet("https://github.com/Dan41/Roblox-Scripts/raw/refs/heads/main/Youtube%20Music%20Player/Welcome.mp3"))
	end
end)

Corner = function(parent, arg, arg2)
	local uiCorner = Instance.new("UICorner")

	if arg2 == nil then
		uiCorner.CornerRadius = UDim.new(0, arg)
	else
		uiCorner.CornerRadius = UDim.new(arg, arg2)
	end

	uiCorner.Parent = parent
end

Stroke = function(parent, arg, arg2, arg3, thickness, transparency)
	local uiStroke = parent:FindFirstChildOfClass("UIStroke")

	if not uiStroke then
		uiStroke = Instance.new("UIStroke")
		uiStroke.Parent = parent
	end

	uiStroke.Color = Color3.fromRGB(arg, arg2, arg3)
	uiStroke.Thickness = thickness

	if transparency ~= nil then
		uiStroke.Transparency = transparency
	end
end

Draggable = function(arg, arg2)
	if not arg or not arg:IsA("GuiObject") then
		return
	end
	local flag19 = false
	local v17 = nil
	local position = nil
	local position2 = nil
	local n4 = 2
	arg:SetAttribute("Blocked", false)
	arg:SetAttribute("Moved", false)

	local function fn4(arg3)
		local n5 = arg3.Position - position

		if not arg:GetAttribute("Moved") and n5.Magnitude > n4 then
			arg:SetAttribute("Moved", true)
		end

		local n6 = position2.X.Offset + n5.X
		local n7 = position2.Y.Offset + n5.Y

		if arg2 then
			local screenGui3 = arg:FindFirstAncestorWhichIsA("ScreenGui")

			if screenGui3 then
				local absoluteSize = screenGui3.AbsoluteSize
				local absoluteSize2 = arg.AbsoluteSize
				local anchorPoint = arg.AnchorPoint
				local uiStroke = arg:FindFirstChildWhichIsA("UIStroke")
				local enabled = uiStroke and uiStroke.Enabled
				local n8 = 0

				if enabled then
					n8 = uiStroke.Thickness
				end

				local n9 = -position2.Y.Scale * absoluteSize.Y + anchorPoint.Y * absoluteSize2.Y + n8
				local n10 = (1 - position2.Y.Scale) * absoluteSize.Y - (1 - anchorPoint.Y) * absoluteSize2.Y - n8
				n6 = math.clamp(n6, -position2.X.Scale * absoluteSize.X + anchorPoint.X * absoluteSize2.X + n8, (1 - position2.X.Scale) * absoluteSize.X - (1 - anchorPoint.X) * absoluteSize2.X - n8)
				n7 = math.clamp(n7, n9, n10)
			end
		end

		arg.Position = UDim2.new(position2.X.Scale, n6, position2.Y.Scale, n7)
	end

	arg.InputBegan:Connect(function(input)
		if flag19 then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag19 = true
			v17 = input
			position = input.Position
			position2 = arg.Position
			arg:SetAttribute("Blocked", true)
			arg:SetAttribute("Moved", false)
			local connection = nil

			connection = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					flag19 = false
					v17 = nil
					arg:SetAttribute("Blocked", false)
					connection:Disconnect()
				end
			end)
		end
	end)

	arg.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if not v17 then
				v17 = input
			end
		end
	end)

	v9.InputChanged:Connect(function(input)
		if flag19 and input == v17 then
			fn4(input)
		end
	end)
end

local frame = Instance.new("Frame")
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Size = UDim2.new(0, 587, 0, 300)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
frame.BackgroundTransparency = 0
frame.BorderSizePixel = 0
frame.Active = true
frame.Visible = false
frame.Parent = screenGui
local imageButton = Instance.new("ImageButton")
imageButton.Size = UDim2.new(0, 50, 0, 50)
imageButton.AnchorPoint = Vector2.new(0.5, 0)
imageButton.Position = UDim2.new(0.5, 0, 0, 20)
imageButton.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
imageButton.Image = "rbxassetid://83758613781843"
imageButton.Visible = false
imageButton.Parent = screenGui
ContadorJA = Instance.new("Frame")
ContadorJA.Size = UDim2.new(0, 17, 0, 17)
ContadorJA.Position = UDim2.new(0, 36, 0, -3)
ContadorJA.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
ContadorJA.Visible = false
ContadorJA.Parent = imageButton
ContadorJANU = Instance.new("TextLabel")
ContadorJANU.Size = UDim2.new(0, 15, 0, 15)
ContadorJANU.Position = UDim2.new(0, 1, 0, 1)
ContadorJANU.BackgroundTransparency = 1
ContadorJANU.Text = "0"
ContadorJANU.TextColor3 = Color3.fromRGB(0, 0, 0)
ContadorJANU.TextScaled = true
ContadorJANU.Parent = ContadorJA
Draggable(imageButton, true)
Draggable(frame)
Mutar = Instance.new("ImageButton")
Mutar.Size = UDim2.new(0, 30, 0, 30)
Mutar.Position = UDim2.new(0, 6, 0, 6)
Mutar.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Mutar.Image = "rbxassetid://109518972658686"
Mutar.Parent = frame
BotaoFechar = Instance.new("ImageButton")
BotaoFechar.Size = UDim2.new(0, 30, 0, 30)
BotaoFechar.Position = UDim2.new(1, -36, 0, 6)
BotaoFechar.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
BotaoFechar.Parent = frame
X = Instance.new("ImageLabel")
X.AnchorPoint = Vector2.new(0.5, 0.5)
X.Size = UDim2.new(0, 17, 0, 17)
X.Position = UDim2.new(0.5, 0, 0.5, 0)
X.BackgroundTransparency = 1
X.Image = "rbxassetid://119026663645791"
X.Parent = BotaoFechar
Titulo = Instance.new("Frame")
Titulo.Size = UDim2.new(0, 488, 0, 30)
Titulo.Position = UDim2.new(0, 50, 0, 6)
Titulo.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Titulo.Parent = frame
TextoTitulo = Instance.new("TextLabel")
TextoTitulo.Size = UDim2.new(1, 0, 1, -4)
TextoTitulo.Position = UDim2.new(0, 0, 0, 2)
TextoTitulo.BackgroundTransparency = 1
TextoTitulo.Text = "skibidi music"
TextoTitulo.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoTitulo.TextScaled = true
TextoTitulo.Font = Enum.Font.Highway
TextoTitulo.Parent = Titulo
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 5)
Linha.Position = UDim2.new(0, 0, 0, 42)
Linha.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Linha.BorderSizePixel = 0
Linha.Parent = frame
Navegacao = Instance.new("Frame")
Navegacao.Size = UDim2.new(0, 160, 1, -61)
Navegacao.Position = UDim2.new(0, 7, 0, 54)
Navegacao.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Navegacao.BorderSizePixel = 0
Navegacao.Visible = true
Navegacao.ClipsDescendants = true
Navegacao.Parent = frame
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 2)
Linha.Position = UDim2.new(0, 0, 0, 42)
Linha.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Linha.BorderSizePixel = 0
Linha.Parent = Navegacao
TituloNave = Instance.new("Frame")
TituloNave.Size = UDim2.new(0, 150, 0, 32)
TituloNave.Position = UDim2.new(0, 5, 0, 5)
TituloNave.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
TituloNave.Parent = Navegacao
FotoNave = Instance.new("ImageLabel")
FotoNave.Size = UDim2.new(0, 32, 0, 32)
FotoNave.Position = UDim2.new(0, 0, 0, 0)
FotoNave.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
FotoNave.BackgroundTransparency = 0.5
FotoNave.Image = "rbxassetid://123533799129853"
FotoNave.Parent = TituloNave
NomeNave = Instance.new("TextLabel")
NomeNave.Size = UDim2.new(0, 102, 1, 0)
NomeNave.Position = UDim2.new(0, 37, 0, 0)
NomeNave.BackgroundTransparency = 1
NomeNave.Text = Traducao.Navegacao
NomeNave.TextColor3 = Color3.fromRGB(255, 0, 0)
NomeNave.Font = Enum.Font.SourceSansBold
NomeNave.TextScaled = true
NomeNave.Parent = TituloNave
BaseSF = Instance.new("Frame")
BaseSF.Size = UDim2.new(0, 158, 0, 193)
BaseSF.Position = UDim2.new(0, 1, 0, 45)
BaseSF.BackgroundTransparency = 1
BaseSF.BorderSizePixel = 0
BaseSF.ClipsDescendants = true
BaseSF.Parent = Navegacao
ScrollNave = Instance.new("ScrollingFrame")
ScrollNave.Size = UDim2.new(1, 0, 1, 0)
ScrollNave.Position = UDim2.new(0, 0, 0, 0)
ScrollNave.BackgroundTransparency = 1
ScrollNave.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollNave.ScrollBarImageTransparency = 0.5
ScrollNave.BorderSizePixel = 0
ScrollNave.ScrollBarThickness = 1
ScrollNave.CanvasSize = UDim2.new(0, 0, 0, 181)
ScrollNave.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollNave.ClipsDescendants = false
ScrollNave.Parent = BaseSF
Botao1 = Instance.new("ImageButton")
Botao1.Name = "Botao1"
Botao1.Size = UDim2.new(0, 148, 0, 35)
Botao1.Position = UDim2.new(0, 5, 0, 5)
Botao1.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Botao1.AutoButtonColor = false
Botao1.Parent = ScrollNave
Botao2 = Instance.new("ImageButton")
Botao2.Name = "Botao2"
Botao2.Size = UDim2.new(0, 148, 0, 35)
Botao2.Position = UDim2.new(0, 5, 0, 50)
Botao2.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Botao2.AutoButtonColor = false
Botao2.Parent = ScrollNave
Botao3 = Instance.new("ImageButton")
Botao3.Name = "Botao3"
Botao3.Size = UDim2.new(0, 148, 0, 35)
Botao3.Position = UDim2.new(0, 5, 0, 95)
Botao3.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Botao3.AutoButtonColor = false
Botao3.Parent = ScrollNave
Botao4 = Instance.new("ImageButton")
Botao4.Name = "Botao4"
Botao4.Size = UDim2.new(0, 148, 0, 35)
Botao4.Position = UDim2.new(0, 5, 0, 140)
Botao4.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Botao4.AutoButtonColor = false
Botao4.Parent = ScrollNave
Botao5 = Instance.new("ImageButton")
Botao5.Name = "Botao5"
Botao5.Size = UDim2.new(0, 148, 0, 35)
Botao5.Position = UDim2.new(0, 5, 0, 185)
Botao5.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Botao5.BackgroundTransparency = 0.9
Botao5.AutoButtonColor = false
Botao5.Parent = ScrollNave
Botao6 = Instance.new("ImageButton")
Botao6.Name = "Botao6"
Botao6.Size = UDim2.new(0, 148, 0, 35)
Botao6.Position = UDim2.new(0, 5, 0, 230)
Botao6.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Botao6.AutoButtonColor = false
Botao6.Parent = ScrollNave
Botao5.Visible = false
Botao6.Visible = false
Icone1 = Instance.new("ImageLabel")
Icone1.Size = UDim2.new(0, 35, 0, 35)
Icone1.Position = UDim2.new(0, 0, 0, 0)
Icone1.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Icone1.Image = "rbxassetid://107770126918811"
Icone1.Parent = Botao1
Icone2 = Instance.new("ImageLabel")
Icone2.Size = UDim2.new(0, 35, 0, 35)
Icone2.Position = UDim2.new(0, 0, 0, 0)
Icone2.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Icone2.Image = "rbxassetid://79505391139157"
Icone2.Parent = Botao2
Icone3 = Instance.new("ImageLabel")
Icone3.Size = UDim2.new(0, 35, 0, 35)
Icone3.Position = UDim2.new(0, 0, 0, 0)
Icone3.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Icone3.Image = "rbxassetid://116645068635461"
Icone3.Parent = Botao3
Icone4 = Instance.new("ImageLabel")
Icone4.Size = UDim2.new(0, 35, 0, 35)
Icone4.Position = UDim2.new(0, 0, 0, 0)
Icone4.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Icone4.Image = "rbxassetid://71048917954785"
Icone4.Parent = Botao4
Icone5 = Instance.new("ImageLabel")
Icone5.Size = UDim2.new(0, 35, 0, 35)
Icone5.Position = UDim2.new(0, 0, 0, 0)
Icone5.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Icone5.BackgroundTransparency = 0.9
Icone5.Image = "rbxassetid://140320771062475"
Icone5.ImageTransparency = 0.9
Icone5.Parent = Botao5
Icone6 = Instance.new("ImageLabel")
Icone6.Size = UDim2.new(0, 35, 0, 35)
Icone6.Position = UDim2.new(0, 0, 0, 0)
Icone6.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Icone6.Image = "rbxassetid://75536888881661"
Icone6.Parent = Botao6
Nome1 = Instance.new("TextLabel")
Nome1.Size = UDim2.new(0, 103, 1, 0)
Nome1.Position = UDim2.new(0, 41, 0, 0)
Nome1.BackgroundTransparency = 1
Nome1.Text = "Home"
Nome1.TextColor3 = Color3.fromRGB(255, 255, 255)
Nome1.Font = Enum.Font.SourceSansBold
Nome1.TextScaled = true
Nome1.Parent = Botao1
Nome2 = Instance.new("TextLabel")
Nome2.Size = UDim2.new(0, 103, 1, 0)
Nome2.Position = UDim2.new(0, 41, 0, 0)
Nome2.BackgroundTransparency = 1
Nome2.Text = Traducao.Player
Nome2.TextColor3 = Color3.fromRGB(255, 255, 255)
Nome2.Font = Enum.Font.SourceSansBold
Nome2.TextScaled = true
Nome2.Parent = Botao2
Nome3 = Instance.new("TextLabel")
Nome3.Size = UDim2.new(0, 103, 1, 0)
Nome3.Position = UDim2.new(0, 41, 0, 0)
Nome3.BackgroundTransparency = 1
Nome3.Text = Traducao.Equalizador
Nome3.TextColor3 = Color3.fromRGB(255, 255, 255)
Nome3.Font = Enum.Font.SourceSansBold
Nome3.TextScaled = true
Nome3.Parent = Botao3
Nome4 = Instance.new("TextLabel")
Nome4.Size = UDim2.new(0, 103, 1, 0)
Nome4.Position = UDim2.new(0, 41, 0, 0)
Nome4.BackgroundTransparency = 1
Nome4.Text = Traducao.Add
Nome4.TextColor3 = Color3.fromRGB(255, 255, 255)
Nome4.Font = Enum.Font.SourceSansBold
Nome4.TextScaled = true
Nome4.Parent = Botao4
Nome5 = Instance.new("TextLabel")
Nome5.Size = UDim2.new(0, 103, 1, 0)
Nome5.Position = UDim2.new(0, 41, 0, 0)
Nome5.BackgroundTransparency = 1
Nome5.Text = "Global Chat"
Nome5.TextColor3 = Color3.fromRGB(20, 20, 20)
Nome5.Font = Enum.Font.SourceSansBold
Nome5.TextScaled = true
Nome5.Parent = Botao5
Nome6 = Instance.new("TextLabel")
Nome6.Size = UDim2.new(0, 103, 1, 0)
Nome6.Position = UDim2.new(0, 41, 0, 0)
Nome6.BackgroundTransparency = 1
Nome6.Text = "Premium"
Nome6.TextColor3 = Color3.fromRGB(255, 255, 153)
Nome6.Font = Enum.Font.SourceSansBold
Nome6.TextScaled = true
Nome6.Parent = Botao6
ContadorJABO = Instance.new("Frame")
ContadorJABO.Size = UDim2.new(0, 15, 0, 15)
ContadorJABO.Position = UDim2.new(0, 0, 0, -3)
ContadorJABO.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
ContadorJABO.Visible = false
ContadorJABO.Parent = Icone5
ContadorJANUBO = Instance.new("TextLabel")
ContadorJANUBO.Size = UDim2.new(0, 15, 0, 15)
ContadorJANUBO.Position = UDim2.new(0, 0, 0, 0)
ContadorJANUBO.BackgroundTransparency = 1
ContadorJANUBO.Text = "0"
ContadorJANUBO.TextColor3 = Color3.fromRGB(0, 0, 0)
ContadorJANUBO.TextScaled = true
ContadorJANUBO.Parent = ContadorJABO
Playlist = Instance.new("Frame")
Playlist.Size = UDim2.new(0, 160, 1, -61)
Playlist.Position = UDim2.new(0, 420, 0, 54)
Playlist.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Playlist.BorderSizePixel = 0
Playlist.Parent = frame
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 2)
Linha.Position = UDim2.new(0, 0, 0, 42)
Linha.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Linha.BorderSizePixel = 0
Linha.Parent = Playlist
Linha2 = Instance.new("Frame")
Linha2.Size = UDim2.new(1, 0, 0, 2)
Linha2.Position = UDim2.new(0, 0, 0, 195)
Linha2.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Linha2.BorderSizePixel = 0
Linha2.Parent = Playlist
TituloPlayL = Instance.new("Frame")
TituloPlayL.Size = UDim2.new(0, 150, 0, 32)
TituloPlayL.Position = UDim2.new(0, 5, 0, 5)
TituloPlayL.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
TituloPlayL.Parent = Playlist
FotoPlayL = Instance.new("ImageLabel")
FotoPlayL.Size = UDim2.new(0, 32, 0, 32)
FotoPlayL.Position = UDim2.new(0, 0, 0, 0)
FotoPlayL.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
FotoPlayL.BackgroundTransparency = 0.5
FotoPlayL.Image = "rbxassetid://96966806844504"
FotoPlayL.Parent = TituloPlayL
NomePlayL = Instance.new("TextLabel")
NomePlayL.Size = UDim2.new(0, 102, 1, 0)
NomePlayL.Position = UDim2.new(0, 37, 0, 0)
NomePlayL.BackgroundTransparency = 1
NomePlayL.Text = "Playlist"
NomePlayL.TextColor3 = Color3.fromRGB(255, 0, 0)
NomePlayL.Font = Enum.Font.SourceSansBold
NomePlayL.TextScaled = true
NomePlayL.Parent = TituloPlayL
EsquerdaPL = Instance.new("ImageButton")
EsquerdaPL.Size = UDim2.new(0, 32, 0, 32)
EsquerdaPL.Position = UDim2.new(0, 6, 0, 202)
EsquerdaPL.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
EsquerdaPL.Image = "rbxassetid://121046797518772"
EsquerdaPL.Parent = Playlist
DireitaPL = Instance.new("ImageButton")
DireitaPL.Size = UDim2.new(0, 32, 0, 32)
DireitaPL.Position = UDim2.new(0, 122, 0, 202)
DireitaPL.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
DireitaPL.Image = "rbxassetid://132437763424488"
DireitaPL.Parent = Playlist
Vazio = Instance.new("ImageLabel")
Vazio.Size = UDim2.new(0, 70, 0, 70)
Vazio.Position = UDim2.new(0, 45, 0, 63)
Vazio.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Vazio.BackgroundTransparency = 1
Vazio.Image = "rbxassetid://123712679435265"
Vazio.Visible = false
Vazio.Parent = Playlist
VazioLocal = Instance.new("ImageLabel")
VazioLocal.Size = UDim2.new(0, 70, 0, 70)
VazioLocal.Position = UDim2.new(0, 45, 0, 63)
VazioLocal.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
VazioLocal.BackgroundTransparency = 1
VazioLocal.Image = "rbxassetid://103453753684654"
VazioLocal.Visible = false
VazioLocal.Parent = Playlist
AguardandoPL = Instance.new("ImageLabel")
AguardandoPL.Size = UDim2.new(0, 70, 0, 70)
AguardandoPL.Position = UDim2.new(0, 45, 0, 63)
AguardandoPL.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
AguardandoPL.BackgroundTransparency = 1
AguardandoPL.Image = "rbxassetid://128559285276409"
AguardandoPL.Visible = false
AguardandoPL.Parent = Playlist
SemResultadoPL = Instance.new("ImageLabel")
SemResultadoPL.Size = UDim2.new(0, 70, 0, 70)
SemResultadoPL.Position = UDim2.new(0, 45, 0, 63)
SemResultadoPL.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
SemResultadoPL.BackgroundTransparency = 1
SemResultadoPL.Image = "rbxassetid://109542040841239"
SemResultadoPL.Visible = false
SemResultadoPL.Parent = Playlist
ErroPL = Instance.new("TextLabel")
ErroPL.Size = UDim2.new(0, 150, 0, 42)
ErroPL.Position = UDim2.new(0, 5, 0, 149)
ErroPL.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
ErroPL.BackgroundTransparency = 0.5
ErroPL.RichText = true
ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Vazio .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.VazioTexto .. "</font>"
ErroPL.Font = Enum.Font.SourceSansBold
ErroPL.TextScaled = true
ErroPL.Visible = false
ErroPL.Parent = Playlist
FrameAbaPL = Instance.new("Frame")
FrameAbaPL.Size = UDim2.new(0, 70, 0, 32)
FrameAbaPL.Position = UDim2.new(0, 45, 0, 202)
FrameAbaPL.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
FrameAbaPL.BackgroundTransparency = 0.5
FrameAbaPL.Parent = Playlist
AbaPL = Instance.new("TextLabel")
AbaPL.Size = UDim2.new(1, -6, 1, -6)
AbaPL.Position = UDim2.new(0, 3, 0, 3)
AbaPL.BackgroundTransparency = 1
AbaPL.Text = Traducao.Todos
AbaPL.TextColor3 = Color3.fromRGB(255, 0, 0)
AbaPL.Font = Enum.Font.SourceSansBold
AbaPL.TextScaled = true
AbaPL.Visible = true
AbaPL.Parent = FrameAbaPL
PesquisaPL = Instance.new("TextBox")
PesquisaPL.Size = UDim2.new(1, -6, 1, -6)
PesquisaPL.Position = UDim2.new(0, 3, 0, 3)
PesquisaPL.BackgroundTransparency = 1
PesquisaPL.Text = ""
PesquisaPL.PlaceholderText = Traducao.Search
PesquisaPL.TextColor3 = Color3.fromRGB(255, 255, 255)
PesquisaPL.Font = Enum.Font.SourceSansBold
PesquisaPL.TextScaled = true
PesquisaPL.TextWrapped = true
PesquisaPL.Visible = false
PesquisaPL.Parent = FrameAbaPL
BaseSF = Instance.new("Frame")
BaseSF.Size = UDim2.new(0, 158, 0, 149)
BaseSF.Position = UDim2.new(0, 1, 0, 45)
BaseSF.BackgroundTransparency = 1
BaseSF.BorderSizePixel = 0
BaseSF.ClipsDescendants = true
BaseSF.Parent = Playlist
ScrollTodos = Instance.new("ScrollingFrame")
ScrollTodos.Name = "ScrollTodos"
ScrollTodos.Size = UDim2.new(1, 0, 1, 0)
ScrollTodos.Position = UDim2.new(0, 0, 0, 0)
ScrollTodos.BackgroundTransparency = 1
ScrollTodos.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollTodos.ScrollBarImageTransparency = 0.5
ScrollTodos.BorderSizePixel = 0
ScrollTodos.ScrollBarThickness = 1
ScrollTodos.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollTodos.CanvasPosition = Vector2.new(0, 0)
ScrollTodos.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollTodos.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollTodos.Visible = true
ScrollTodos.Parent = BaseSF
ScrollMusicas = Instance.new("ScrollingFrame")
ScrollMusicas.Name = "ScrollMusicas"
ScrollMusicas.Size = UDim2.new(1, 0, 1, 0)
ScrollMusicas.Position = UDim2.new(0, 0, 0, 0)
ScrollMusicas.BackgroundTransparency = 1
ScrollMusicas.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollMusicas.ScrollBarImageTransparency = 0.5
ScrollMusicas.BorderSizePixel = 0
ScrollMusicas.ScrollBarThickness = 1
ScrollMusicas.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollMusicas.CanvasPosition = Vector2.new(0, 0)
ScrollMusicas.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollMusicas.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollMusicas.Visible = false
ScrollMusicas.Parent = BaseSF
ScrollVideos = Instance.new("ScrollingFrame")
ScrollVideos.Name = "ScrollVideos"
ScrollVideos.Size = UDim2.new(1, 0, 1, 0)
ScrollVideos.Position = UDim2.new(0, 0, 0, 0)
ScrollVideos.BackgroundTransparency = 1
ScrollVideos.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollVideos.ScrollBarImageTransparency = 0.5
ScrollVideos.BorderSizePixel = 0
ScrollVideos.ScrollBarThickness = 1
ScrollVideos.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollVideos.CanvasPosition = Vector2.new(0, 0)
ScrollVideos.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollVideos.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollVideos.Visible = false
ScrollVideos.Parent = BaseSF
ScrollRoblox = Instance.new("ScrollingFrame")
ScrollRoblox.Name = "ScrollRoblox"
ScrollRoblox.Size = UDim2.new(1, 0, 1, 0)
ScrollRoblox.Position = UDim2.new(0, 0, 0, 0)
ScrollRoblox.BackgroundTransparency = 1
ScrollRoblox.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollRoblox.ScrollBarImageTransparency = 0.5
ScrollRoblox.BorderSizePixel = 0
ScrollRoblox.ScrollBarThickness = 1
ScrollRoblox.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollRoblox.CanvasPosition = Vector2.new(0, 0)
ScrollRoblox.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollRoblox.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollRoblox.Visible = false
ScrollRoblox.Parent = BaseSF
ScrollFav = Instance.new("ScrollingFrame")
ScrollFav.Name = "ScrollFav"
ScrollFav.Size = UDim2.new(1, 0, 1, 0)
ScrollFav.Position = UDim2.new(0, 0, 0, 0)
ScrollFav.BackgroundTransparency = 1
ScrollFav.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollFav.ScrollBarImageTransparency = 0.5
ScrollFav.BorderSizePixel = 0
ScrollFav.ScrollBarThickness = 1
ScrollFav.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollFav.CanvasPosition = Vector2.new(0, 0)
ScrollFav.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollFav.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollFav.Visible = false
ScrollFav.Parent = BaseSF
ScrollLocal = Instance.new("ScrollingFrame")
ScrollLocal.Name = "ScrollLocal"
ScrollLocal.Size = UDim2.new(1, 0, 1, 0)
ScrollLocal.Position = UDim2.new(0, 0, 0, 0)
ScrollLocal.BackgroundTransparency = 1
ScrollLocal.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollLocal.ScrollBarImageTransparency = 0.5
ScrollLocal.BorderSizePixel = 0
ScrollLocal.ScrollBarThickness = 1
ScrollLocal.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollLocal.CanvasPosition = Vector2.new(0, 0)
ScrollLocal.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollLocal.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollLocal.Visible = false
ScrollLocal.Parent = BaseSF
ScrollPesquisa = Instance.new("ScrollingFrame")
ScrollPesquisa.Name = "ScrollPesquisa"
ScrollPesquisa.Size = UDim2.new(1, 0, 1, 0)
ScrollPesquisa.Position = UDim2.new(0, 0, 0, 0)
ScrollPesquisa.BackgroundTransparency = 1
ScrollPesquisa.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollPesquisa.ScrollBarImageTransparency = 0.5
ScrollPesquisa.BorderSizePixel = 0
ScrollPesquisa.ScrollBarThickness = 1
ScrollPesquisa.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollPesquisa.CanvasPosition = Vector2.new(0, 0)
ScrollPesquisa.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollPesquisa.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollPesquisa.Visible = false
ScrollPesquisa.Parent = BaseSF
Tela1 = Instance.new("Frame")
Tela1.Size = UDim2.new(0, 247, 0, 251)
Tela1.Position = UDim2.new(0, 170, 0, 48)
Tela1.BackgroundTransparency = 1
Tela1.BorderSizePixel = 0
Tela1.Visible = true
Tela1.Parent = frame
Tela2 = Instance.new("Frame")
Tela2.Size = UDim2.new(0, 247, 0, 251)
Tela2.Position = UDim2.new(0, 170, 0, 48)
Tela2.BackgroundTransparency = 1
Tela2.BorderSizePixel = 0
Tela2.Visible = false
Tela2.Parent = frame
Tela3 = Instance.new("Frame")
Tela3.Size = UDim2.new(0, 247, 0, 251)
Tela3.Position = UDim2.new(0, 170, 0, 48)
Tela3.BackgroundTransparency = 1
Tela3.BorderSizePixel = 0
Tela3.Visible = false
Tela3.Parent = frame
Tela4 = Instance.new("Frame")
Tela4.Size = UDim2.new(0, 247, 0, 251)
Tela4.Position = UDim2.new(0, 170, 0, 48)
Tela4.BackgroundTransparency = 1
Tela4.BorderSizePixel = 0
Tela4.Visible = false
Tela4.Parent = frame
Tela5 = Instance.new("Frame")
Tela5.Size = UDim2.new(0, 247, 0, 251)
Tela5.Position = UDim2.new(0, 170, 0, 48)
Tela5.BackgroundTransparency = 1
Tela5.BorderSizePixel = 0
Tela5.Visible = false
Tela5.Parent = frame
Tela6 = Instance.new("Frame")
Tela6.Size = UDim2.new(0, 247, 0, 251)
Tela6.Position = UDim2.new(0, 170, 0, 48)
Tela6.BackgroundTransparency = 1
Tela6.BorderSizePixel = 0
Tela6.Visible = false
Tela6.Parent = frame
Welcome = Instance.new("Frame")
Welcome.Size = UDim2.new(0, 235, 0, 43)
Welcome.Position = UDim2.new(0, 6, 0, 6)
Welcome.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Welcome.BorderSizePixel = 0
Welcome.Parent = Tela1
NomeWelcome = Instance.new("TextLabel")
NomeWelcome.Size = UDim2.new(1, 0, 1, 0)
NomeWelcome.Position = UDim2.new(0, 0, 0, 0)
NomeWelcome.BackgroundTransparency = 1
NomeWelcome.Text = Traducao.Welcome
NomeWelcome.TextColor3 = Color3.fromRGB(255, 0, 0)
NomeWelcome.Font = Enum.Font.SourceSansBold
NomeWelcome.TextScaled = true
NomeWelcome.Parent = Welcome
Social = Instance.new("Frame")
Social.Size = UDim2.new(0, 235, 0, 117)
Social.Position = UDim2.new(0, 6, 0, 128)
Social.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Social.BorderSizePixel = 0
Social.Parent = Tela1
SocialTitulo = Instance.new("Frame")
SocialTitulo.Size = UDim2.new(1, 0, 0, 30)
SocialTitulo.Position = UDim2.new(0, 0, 0, 0)
SocialTitulo.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
SocialTitulo.BorderSizePixel = 0
SocialTitulo.Parent = Social
SocialTexto = Instance.new("TextLabel")
SocialTexto.Size = UDim2.new(1, 0, 1, 0)
SocialTexto.Position = UDim2.new(0, 0, 0, 0)
SocialTexto.BackgroundTransparency = 1
SocialTexto.Text = "Social"
SocialTexto.TextColor3 = Color3.fromRGB(70, 130, 180)
SocialTexto.Font = Enum.Font.SourceSansBold
SocialTexto.TextScaled = true
SocialTexto.Parent = SocialTitulo
Discord = Instance.new("ImageButton")
Discord.Size = UDim2.new(0, 223, 0, 32)
Discord.Position = UDim2.new(0, 6, 0, 40)
Discord.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Discord.Parent = Social
UIScaleDis = Instance.new("UIScale")
UIScaleDis.Parent = Discord
IconeDiscord = Instance.new("ImageLabel")
IconeDiscord.Size = UDim2.new(0, 32, 0, 32)
IconeDiscord.Position = UDim2.new(0, 0, 0, 0)
IconeDiscord.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeDiscord.Image = "rbxassetid://90602349315916"
IconeDiscord.Parent = Discord
TextoDiscord = Instance.new("TextLabel")
TextoDiscord.Size = UDim2.new(1, -50, 1, 0)
TextoDiscord.Position = UDim2.new(0, 39, 0, 0)
TextoDiscord.BackgroundTransparency = 1
TextoDiscord.Text = "Discord"
TextoDiscord.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoDiscord.Font = Enum.Font.Garamond
TextoDiscord.TextScaled = true
TextoDiscord.Parent = Discord
You = Instance.new("ImageButton")
You.Size = UDim2.new(0, 223, 0, 32)
You.Position = UDim2.new(0, 6, 0, 79)
You.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
You.Parent = Social
UIScaleYou = Instance.new("UIScale")
UIScaleYou.Parent = You
IconeYou = Instance.new("ImageLabel")
IconeYou.Size = UDim2.new(0, 32, 0, 32)
IconeYou.Position = UDim2.new(0, 0, 0, 0)
IconeYou.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeYou.Image = "rbxassetid://111196037573101"
IconeYou.Parent = You
TextoYou = Instance.new("TextLabel")
TextoYou.Size = UDim2.new(1, -50, 1, 0)
TextoYou.Position = UDim2.new(0, 39, 0, 0)
TextoYou.BackgroundTransparency = 1
TextoYou.Text = "YouTube"
TextoYou.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoYou.Font = Enum.Font.Garamond
TextoYou.TextScaled = true
TextoYou.Parent = You
Musica = Instance.new("ImageLabel")
Musica.Size = UDim2.new(0, 235, 0, 120)
Musica.Position = UDim2.new(0, 6, 0, 6)
Musica.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Musica.BorderSizePixel = 0
Musica.Visible = true
Musica.ImageRectOffset = Vector2.new(0, 0)
Musica.ImageRectSize = Vector2.new(0, 0)
Musica.Image = "rbxassetid://120329190202259"
Musica.Parent = Tela2
Video = Instance.new("VideoFrame")
Video.Size = UDim2.new(0, 235, 0, 120)
Video.Position = UDim2.new(0, 6, 0, 6)
Video.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Video.BorderSizePixel = 0
Video.Visible = false
Video.Video = ""
Video.Volume = 1
Video.Looped = false
Video.Parent = nil
BotaoTela = Instance.new("ImageButton")
BotaoTela.Size = UDim2.new(0, 235, 0, 120)
BotaoTela.Position = UDim2.new(0, 6, 0, 6)
BotaoTela.BackgroundTransparency = 1
BotaoTela.ClipsDescendants = true
BotaoTela.Visible = true
BotaoTela.ZIndex = 2
BotaoTela.Parent = Tela2
TempoAtual = Instance.new("Frame")
TempoAtual.Size = UDim2.new(0, 55, 0, 20)
TempoAtual.Position = UDim2.new(0, 6, 0, 6)
TempoAtual.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
TempoAtual.BackgroundTransparency = 0.5
TempoAtual.ZIndex = 2
TempoAtual.Parent = BotaoTela
TempoTotal = Instance.new("Frame")
TempoTotal.Size = UDim2.new(0, 55, 0, 20)
TempoTotal.Position = UDim2.new(0, 174, 0, 6)
TempoTotal.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
TempoTotal.BackgroundTransparency = 0.5
TempoTotal.ZIndex = 2
TempoTotal.Parent = BotaoTela
TimerAtual = Instance.new("TextLabel")
TimerAtual.Size = UDim2.new(1, 0, 1, 0)
TimerAtual.Position = UDim2.new(0, 0, 0, 0)
TimerAtual.BackgroundTransparency = 1
TimerAtual.Text = "00:00"
TimerAtual.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerAtual.TextScaled = true
TimerAtual.Font = Enum.Font.SourceSansBold
TimerAtual.ZIndex = 2
TimerAtual.Parent = TempoAtual
TimerTotal = Instance.new("TextLabel")
TimerTotal.Size = UDim2.new(1, 0, 1, 0)
TimerTotal.Position = UDim2.new(0, 0, 0, 0)
TimerTotal.BackgroundTransparency = 1
TimerTotal.Text = "00:00"
TimerTotal.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerTotal.TextScaled = true
TimerTotal.Font = Enum.Font.SourceSansBold
TimerTotal.ZIndex = 2
TimerTotal.Parent = TempoTotal
Repetir = Instance.new("ImageButton")
Repetir.Size = UDim2.new(0, 30, 0, 30)
Repetir.Position = UDim2.new(0.5, -35, 0.5, -54)
Repetir.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Repetir.BackgroundTransparency = 0.5
Repetir.BorderSizePixel = 0
Repetir.Image = "rbxassetid://72571947341676"
Repetir.ZIndex = 2
Repetir.Parent = BotaoTela
Miniplayer = Instance.new("ImageButton")
Miniplayer.Size = UDim2.new(0, 30, 0, 30)
Miniplayer.Position = UDim2.new(0.5, 5, 0.5, -54)
Miniplayer.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Miniplayer.BackgroundTransparency = 0.5
Miniplayer.BorderSizePixel = 0
Miniplayer.Image = "rbxassetid://102723588572082"
Miniplayer.ZIndex = 2
Miniplayer.Parent = BotaoTela
BarraProgresso = Instance.new("ImageButton")
BarraProgresso.Size = UDim2.new(0, 223, 0, 10)
BarraProgresso.Position = UDim2.new(0, 6, 0, 103)
BarraProgresso.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
BarraProgresso.BorderSizePixel = 0
BarraProgresso.AutoButtonColor = false
BarraProgresso.ZIndex = 2
BarraProgresso.Parent = BotaoTela
Rastro = Instance.new("Frame")
Rastro.Size = UDim2.new(0, 0, 1, 0)
Rastro.Position = UDim2.new(0, 0, 0, 0)
Rastro.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Rastro.BorderSizePixel = 0
Rastro.ZIndex = 2
Rastro.Parent = BarraProgresso
BolaProgresso = Instance.new("ImageButton")
BolaProgresso.Size = UDim2.new(0, 16, 0, 16)
BolaProgresso.Position = UDim2.new(0, 0, 0, -3)
BolaProgresso.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
BolaProgresso.BorderSizePixel = 0
BolaProgresso.AnchorPoint = Vector2.new(0, 0)
BolaProgresso.ZIndex = 2
BolaProgresso.Parent = BarraProgresso
MicroBola = Instance.new("Frame")
MicroBola.Size = UDim2.new(0, 6, 0, 6)
MicroBola.Position = UDim2.new(0, 5, 0, 5)
MicroBola.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
MicroBola.BorderSizePixel = 0
MicroBola.ZIndex = 2
MicroBola.Parent = BolaProgresso
PlayerInfo = Instance.new("VideoFrame")
PlayerInfo.Size = UDim2.new(0, 235, 0, 61)
PlayerInfo.Position = UDim2.new(0, 6, 0, 135)
PlayerInfo.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
PlayerInfo.BorderSizePixel = 0
PlayerInfo.Parent = Tela2
FotoAutor = Instance.new("ImageLabel")
FotoAutor.Size = UDim2.new(0, 50, 0, 49)
FotoAutor.Position = UDim2.new(0, 6, 0, 6)
FotoAutor.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
FotoAutor.BorderSizePixel = 0
FotoAutor.Visible = true
FotoAutor.Image = "rbxassetid://130243480255582"
FotoAutor.Parent = PlayerInfo
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(0, 2, 1, 0)
Linha.Position = UDim2.new(0, 63, 0, 0)
Linha.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Linha.BorderSizePixel = 0
Linha.Parent = PlayerInfo
Linhah = Instance.new("Frame")
Linhah.Size = UDim2.new(0, 2, 1, 0)
Linhah.Position = UDim2.new(0, 170, 0, 0)
Linhah.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Linhah.BorderSizePixel = 0
Linhah.Parent = PlayerInfo
TituloMusica = Instance.new("TextLabel")
TituloMusica.Size = UDim2.new(1, -140, 1, -8)
TituloMusica.Position = UDim2.new(0, 70, 0, 4)
TituloMusica.BackgroundTransparency = 1
TituloMusica.TextColor3 = Color3.fromRGB(255, 255, 255)
TituloMusica.Font = Enum.Font.SourceSansBold
TituloMusica.TextScaled = true
TituloMusica.RichText = true
TituloMusica.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Hey .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.Play .. "</font>"
TituloMusica.Parent = PlayerInfo
Disco = Instance.new("ImageLabel")
Disco.Size = UDim2.new(0, 50, 0, 49)
Disco.Position = UDim2.new(0, 179, 0, 6)
Disco.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Disco.BorderSizePixel = 0
Disco.Visible = true
Disco.Image = "rbxassetid://76801681748723"
Disco.ClipsDescendants = true
Disco.Parent = PlayerInfo
Controles = Instance.new("Frame")
Controles.Size = UDim2.new(0, 235, 0, 40)
Controles.Position = UDim2.new(0, 6, 0, 205)
Controles.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Controles.BorderSizePixel = 0
Controles.Parent = Tela2
Voltar = Instance.new("ImageButton")
Voltar.Size = UDim2.new(0, 30, 0, 30)
Voltar.Position = UDim2.new(0, 10, 0.5, -15)
Voltar.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Voltar.BorderSizePixel = 0
Voltar.Image = "rbxassetid://88757150664292"
Voltar.Parent = Controles
Retroceder = Instance.new("ImageButton")
Retroceder.Size = UDim2.new(0, 30, 0, 30)
Retroceder.Position = UDim2.new(0, 55, 0.5, -15)
Retroceder.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Retroceder.BorderSizePixel = 0
Retroceder.Image = "rbxassetid://122950454234379"
Retroceder.Parent = Controles
Play = Instance.new("ImageButton")
Play.Size = UDim2.new(0, 30, 0, 30)
Play.Position = UDim2.new(0.5, -15, 0.5, -15)
Play.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Play.BorderSizePixel = 0
Play.Image = "rbxassetid://110560238983134"
Play.Parent = Controles
Adiantar = Instance.new("ImageButton")
Adiantar.Size = UDim2.new(0, 30, 0, 30)
Adiantar.Position = UDim2.new(1, -85, 0.5, -15)
Adiantar.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Adiantar.BorderSizePixel = 0
Adiantar.Image = "rbxassetid://102857578902137"
Adiantar.Parent = Controles
Pular = Instance.new("ImageButton")
Pular.Size = UDim2.new(0, 30, 0, 30)
Pular.Position = UDim2.new(1, -40, 0.5, -15)
Pular.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Pular.BorderSizePixel = 0
Pular.Image = "rbxassetid://82401540450034"
Pular.Parent = Controles
local imageButton2 = Instance.new("ImageButton")
imageButton2.Size = UDim2.new(0.27, 0, 0.37, 0)
imageButton2.AnchorPoint = Vector2.new(1, 1)
imageButton2.Position = UDim2.new(1, -20, 1, -20)
imageButton2.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
imageButton2.BorderSizePixel = 0
imageButton2.BackgroundTransparency = 1
imageButton2.AutoButtonColor = false
imageButton2.Active = true
imageButton2.Visible = false
imageButton2.ZIndex = 3
imageButton2.Parent = nil
Draggable(imageButton2, true)
MiniMusica = Instance.new("ImageLabel")
MiniMusica.Size = UDim2.new(1, 0, 1, 0)
MiniMusica.Position = UDim2.new(0, 0, 0, 0)
MiniMusica.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
MiniMusica.BorderSizePixel = 0
MiniMusica.Visible = true
MiniMusica.ImageRectOffset = Vector2.new(0, 0)
MiniMusica.ImageRectSize = Vector2.new(0, 0)
MiniMusica.Image = "rbxassetid://120329190202259"
MiniMusica.ZIndex = 3
MiniMusica.Parent = imageButton2
MiniVideo = Instance.new("VideoFrame")
MiniVideo.Size = UDim2.new(1, 0, 1, 0)
MiniVideo.Position = UDim2.new(0, 0, 0, 0)
MiniVideo.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
MiniVideo.BorderSizePixel = 0
MiniVideo.Visible = false
MiniVideo.Video = ""
MiniVideo.Volume = 1
MiniVideo.Looped = false
MiniVideo.ZIndex = 3
MiniVideo.Parent = imageButton2
MiniBack = Instance.new("ImageButton")
MiniBack.Size = UDim2.new(0.18, -8, 0.27, 0)
MiniBack.AnchorPoint = Vector2.new(0.5, 1)
MiniBack.Position = UDim2.new(0.105, 0, 0.94, 0)
MiniBack.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
MiniBack.BackgroundTransparency = 0.5
MiniBack.Image = "rbxassetid://122582556337724"
MiniBack.Visible = false
MiniBack.ZIndex = 3
MiniBack.Parent = imageButton2
MiniRetroceder = Instance.new("ImageButton")
MiniRetroceder.Size = UDim2.new(0.18, -8, 0.27, 0)
MiniRetroceder.AnchorPoint = Vector2.new(0.5, 1)
MiniRetroceder.Position = UDim2.new(0.3025, 0, 0.94, 0)
MiniRetroceder.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
MiniRetroceder.BackgroundTransparency = 0.5
MiniRetroceder.Image = "rbxassetid://95993997488260"
MiniRetroceder.Visible = false
MiniRetroceder.ZIndex = 3
MiniRetroceder.Parent = imageButton2
MiniPlay = Instance.new("ImageButton")
MiniPlay.Size = UDim2.new(0.18, -8, 0.27, 0)
MiniPlay.AnchorPoint = Vector2.new(0.5, 1)
MiniPlay.Position = UDim2.new(0.5, 0, 0.94, 0)
MiniPlay.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
MiniPlay.BackgroundTransparency = 0.5
MiniPlay.Image = "rbxassetid://119936293795425"
MiniPlay.Visible = false
MiniPlay.ZIndex = 3
MiniPlay.Parent = imageButton2
MiniAvancar = Instance.new("ImageButton")
MiniAvancar.Size = UDim2.new(0.18, -8, 0.27, 0)
MiniAvancar.AnchorPoint = Vector2.new(0.5, 1)
MiniAvancar.Position = UDim2.new(0.6975, 0, 0.94, 0)
MiniAvancar.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
MiniAvancar.BackgroundTransparency = 0.5
MiniAvancar.Image = "rbxassetid://95582496868769"
MiniAvancar.Visible = false
MiniAvancar.ZIndex = 3
MiniAvancar.Parent = imageButton2
MiniSkip = Instance.new("ImageButton")
MiniSkip.Size = UDim2.new(0.18, -8, 0.27, 0)
MiniSkip.AnchorPoint = Vector2.new(0.5, 1)
MiniSkip.Position = UDim2.new(0.895, 0, 0.94, 0)
MiniSkip.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
MiniSkip.BackgroundTransparency = 0.5
MiniSkip.Image = "rbxassetid://101914600863480"
MiniSkip.Visible = false
MiniSkip.ZIndex = 3
MiniSkip.Parent = imageButton2
TelaCheia = Instance.new("ImageButton")
TelaCheia.Size = UDim2.new(0.18, -8, 0.27, 0)
TelaCheia.AnchorPoint = Vector2.new(0.5, 0)
TelaCheia.Position = UDim2.new(0.105, 0, 0.03, 0)
TelaCheia.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
TelaCheia.BackgroundTransparency = 0.5
TelaCheia.Image = "rbxassetid://73952228795506"
TelaCheia.Visible = false
TelaCheia.ZIndex = 3
TelaCheia.Parent = imageButton2
FecharMini = Instance.new("ImageButton")
FecharMini.Size = UDim2.new(0.18, -8, 0.27, 0)
FecharMini.AnchorPoint = Vector2.new(0.5, 0)
FecharMini.Position = UDim2.new(0.895, 0, 0.03, 0)
FecharMini.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
FecharMini.BackgroundTransparency = 0.5
FecharMini.Image = "rbxassetid://71780293592221"
FecharMini.Visible = false
FecharMini.ZIndex = 3
FecharMini.Parent = imageButton2
TituloEqua = Instance.new("Frame")
TituloEqua.Size = UDim2.new(0, 235, 0, 43)
TituloEqua.Position = UDim2.new(0, 6, 0, 6)
TituloEqua.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
TituloEqua.BorderSizePixel = 0
TituloEqua.Parent = Tela3
NomeEqua = Instance.new("TextLabel")
NomeEqua.Size = UDim2.new(1, 0, 1, 0)
NomeEqua.Position = UDim2.new(0, 0, 0, 0)
NomeEqua.BackgroundTransparency = 1
NomeEqua.Text = Traducao.Equalizador
NomeEqua.TextColor3 = Color3.fromRGB(255, 0, 0)
NomeEqua.Font = Enum.Font.SourceSansBold
NomeEqua.TextScaled = true
NomeEqua.Parent = TituloEqua
EquaFrame = Instance.new("Frame")
EquaFrame.Size = UDim2.new(0, 235, 0, 187)
EquaFrame.Position = UDim2.new(0, 6, 0, 58)
EquaFrame.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
EquaFrame.BorderSizePixel = 0
EquaFrame.Parent = Tela3
NoEquaFrame = Instance.new("Frame")
NoEquaFrame.Size = UDim2.new(0, 235, 0, 129)
NoEquaFrame.Position = UDim2.new(0, 6, 0, 116)
NoEquaFrame.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
NoEquaFrame.BorderSizePixel = 0
NoEquaFrame.Visible = false
NoEquaFrame.Parent = Tela3
Blockedicon = Instance.new("ImageLabel")
Blockedicon.Size = UDim2.new(0, 60, 0, 60)
Blockedicon.AnchorPoint = Vector2.new(0.5, 0.5)
Blockedicon.Position = UDim2.new(0.5, 0, 0.5, -23)
Blockedicon.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Blockedicon.BackgroundTransparency = 1
Blockedicon.Image = "rbxassetid://140149151607570"
Blockedicon.Parent = NoEquaFrame
ErroEqua = Instance.new("TextLabel")
ErroEqua.Size = UDim2.new(0, 224, 0, 42)
ErroEqua.Position = UDim2.new(0, 5, 0, 82)
ErroEqua.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
ErroEqua.BackgroundTransparency = 0.5
ErroEqua.RichText = true
ErroEqua.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.RecursoTi .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.RecursoTe .. "</font>"
ErroEqua.Font = Enum.Font.SourceSansBold
ErroEqua.TextScaled = true
ErroEqua.Parent = NoEquaFrame
BaseSF = Instance.new("Frame")
BaseSF.Size = UDim2.new(1, 0, 1, -4)
BaseSF.Position = UDim2.new(0, 0, 0, 2)
BaseSF.BackgroundTransparency = 1
BaseSF.BorderSizePixel = 0
BaseSF.ClipsDescendants = true
BaseSF.Parent = EquaFrame
ScrollEqua = Instance.new("ScrollingFrame")
ScrollEqua.Size = UDim2.new(1, -1, 1, 0)
ScrollEqua.Position = UDim2.new(0, 0, 0, 0)
ScrollEqua.BackgroundTransparency = 1
ScrollEqua.BorderSizePixel = 0
ScrollEqua.ScrollBarThickness = 1
ScrollEqua.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollEqua.ScrollBarImageTransparency = 0.5
ScrollEqua.CanvasSize = UDim2.new(0, 0, 0, 1015)
ScrollEqua.CanvasPosition = Vector2.new(0, 0)
ScrollEqua.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollEqua.ScrollingEnabled = true
ScrollEqua.ClipsDescendants = true
ScrollEqua.Parent = BaseSF
Volume = Instance.new("Frame")
Volume.Size = UDim2.new(0, 219, 0, 35)
Volume.Position = UDim2.new(0, 8, 0, 5)
Volume.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Volume.Parent = ScrollEqua
IconeVolume = Instance.new("ImageLabel")
IconeVolume.Size = UDim2.new(0, 35, 0, 35)
IconeVolume.Position = UDim2.new(0, 0, 0, 0)
IconeVolume.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeVolume.BackgroundTransparency = 0
IconeVolume.Image = "rbxassetid://89282663179812"
IconeVolume.Parent = Volume
VolumeBox = Instance.new("TextBox")
VolumeBox.Size = UDim2.new(0, 182, 1, 0)
VolumeBox.Position = UDim2.new(0, 39, 0, 0)
VolumeBox.BackgroundTransparency = 1
VolumeBox.Text = "1"
VolumeBox.PlaceholderText = Traducao.Volume
VolumeBox.TextWrapped = true
VolumeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
VolumeBox.Font = Enum.Font.SourceSansBold
VolumeBox.TextScaled = true
VolumeBox.Parent = Volume
Pitch = Instance.new("Frame")
Pitch.Size = UDim2.new(0, 219, 0, 35)
Pitch.Position = UDim2.new(0, 8, 0, 50)
Pitch.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Pitch.Parent = ScrollEqua
IconePitch = Instance.new("ImageLabel")
IconePitch.Size = UDim2.new(0, 35, 0, 35)
IconePitch.Position = UDim2.new(0, 0, 0, 0)
IconePitch.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconePitch.BackgroundTransparency = 0
IconePitch.Image = "rbxassetid://102339134358611"
IconePitch.Parent = Pitch
PitchBox = Instance.new("TextBox")
PitchBox.Size = UDim2.new(0, 182, 1, 0)
PitchBox.Position = UDim2.new(0, 39, 0, 0)
PitchBox.BackgroundTransparency = 1
PitchBox.Text = "1"
PitchBox.PlaceholderText = "Pitch"
PitchBox.TextWrapped = true
PitchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PitchBox.Font = Enum.Font.SourceSansBold
PitchBox.TextScaled = true
PitchBox.Parent = Pitch
FrequenciaTitulo = Instance.new("Frame")
FrequenciaTitulo.Size = UDim2.new(0, 219, 0, 25)
FrequenciaTitulo.Position = UDim2.new(0, 8, 0, 105)
FrequenciaTitulo.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
FrequenciaTitulo.BackgroundTransparency = 0.6
FrequenciaTitulo.BorderSizePixel = 1
FrequenciaTitulo.Parent = ScrollEqua
TextoFrenquencia = Instance.new("TextLabel")
TextoFrenquencia.Size = UDim2.new(1, -70, 1, -4)
TextoFrenquencia.Position = UDim2.new(0, 35, 0, 2)
TextoFrenquencia.BackgroundTransparency = 1
TextoFrenquencia.Text = Traducao.Freque
TextoFrenquencia.Font = Enum.Font.Garamond
TextoFrenquencia.TextColor3 = Color3.fromRGB(255, 0, 0)
TextoFrenquencia.TextScaled = true
TextoFrenquencia.Parent = FrequenciaTitulo
Graves = Instance.new("Frame")
Graves.Size = UDim2.new(0, 219, 0, 35)
Graves.Position = UDim2.new(0, 8, 0, 150)
Graves.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Graves.Parent = ScrollEqua
IconeGraves = Instance.new("ImageLabel")
IconeGraves.Size = UDim2.new(0, 35, 0, 35)
IconeGraves.Position = UDim2.new(0, 0, 0, 0)
IconeGraves.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeGraves.BackgroundTransparency = 0
IconeGraves.Image = "rbxassetid://91932971942355"
IconeGraves.Parent = Graves
GravesBox = Instance.new("TextBox")
GravesBox.Size = UDim2.new(0, 182, 1, 0)
GravesBox.Position = UDim2.new(0, 39, 0, 0)
GravesBox.BackgroundTransparency = 1
GravesBox.Text = "1"
GravesBox.PlaceholderText = Traducao.Graves
GravesBox.TextWrapped = true
GravesBox.TextColor3 = Color3.fromRGB(255, 255, 255)
GravesBox.Font = Enum.Font.SourceSansBold
GravesBox.TextScaled = true
GravesBox.Parent = Graves
Medios = Instance.new("Frame")
Medios.Size = UDim2.new(0, 219, 0, 35)
Medios.Position = UDim2.new(0, 8, 0, 195)
Medios.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Medios.Parent = ScrollEqua
IconeMedios = Instance.new("ImageLabel")
IconeMedios.Size = UDim2.new(0, 35, 0, 35)
IconeMedios.Position = UDim2.new(0, 0, 0, 0)
IconeMedios.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeMedios.BackgroundTransparency = 0
IconeMedios.Image = "rbxassetid://91932971942355"
IconeMedios.Parent = Medios
MediosBox = Instance.new("TextBox")
MediosBox.Size = UDim2.new(0, 182, 1, 0)
MediosBox.Position = UDim2.new(0, 39, 0, 0)
MediosBox.BackgroundTransparency = 1
MediosBox.Text = "1"
MediosBox.PlaceholderText = Traducao.Medios
MediosBox.TextWrapped = true
MediosBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MediosBox.Font = Enum.Font.SourceSansBold
MediosBox.TextScaled = true
MediosBox.Parent = Medios
Agudos = Instance.new("Frame")
Agudos.Size = UDim2.new(0, 219, 0, 35)
Agudos.Position = UDim2.new(0, 8, 0, 240)
Agudos.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Agudos.Parent = ScrollEqua
IconeAgudos = Instance.new("ImageLabel")
IconeAgudos.Size = UDim2.new(0, 35, 0, 35)
IconeAgudos.Position = UDim2.new(0, 0, 0, 0)
IconeAgudos.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeAgudos.BackgroundTransparency = 0
IconeAgudos.Image = "rbxassetid://91932971942355"
IconeAgudos.Parent = Agudos
AgudosBox = Instance.new("TextBox")
AgudosBox.Size = UDim2.new(0, 182, 1, 0)
AgudosBox.Position = UDim2.new(0, 39, 0, 0)
AgudosBox.BackgroundTransparency = 1
AgudosBox.Text = "1"
AgudosBox.PlaceholderText = Traducao.Agudos
AgudosBox.TextWrapped = true
AgudosBox.TextColor3 = Color3.fromRGB(255, 255, 255)
AgudosBox.Font = Enum.Font.SourceSansBold
AgudosBox.TextScaled = true
AgudosBox.Parent = Agudos
EfeitosTitulo = Instance.new("Frame")
EfeitosTitulo.Size = UDim2.new(0, 219, 0, 25)
EfeitosTitulo.Position = UDim2.new(0, 8, 0, 295)
EfeitosTitulo.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
EfeitosTitulo.BackgroundTransparency = 0.6
EfeitosTitulo.BorderSizePixel = 1
EfeitosTitulo.Parent = ScrollEqua
TextoEfeitos = Instance.new("TextLabel")
TextoEfeitos.Size = UDim2.new(1, -70, 1, -4)
TextoEfeitos.Position = UDim2.new(0, 35, 0, 2)
TextoEfeitos.BackgroundTransparency = 1
TextoEfeitos.Text = Traducao.Efeitos
TextoEfeitos.Font = Enum.Font.Garamond
TextoEfeitos.TextColor3 = Color3.fromRGB(255, 0, 0)
TextoEfeitos.TextScaled = true
TextoEfeitos.Parent = EfeitosTitulo
Nenhum = Instance.new("ImageButton")
Nenhum.Name = "Nenhum"
Nenhum.Size = UDim2.new(0, 219, 0, 35)
Nenhum.Position = UDim2.new(0, 8, 0, 340)
Nenhum.AutoButtonColor = false
Nenhum.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Nenhum.Parent = ScrollEqua
IconeNenhum = Instance.new("ImageLabel")
IconeNenhum.Size = UDim2.new(0, 35, 0, 35)
IconeNenhum.Position = UDim2.new(0, 0, 0, 0)
IconeNenhum.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeNenhum.BackgroundTransparency = 0
IconeNenhum.Image = "rbxassetid://130043384241999"
IconeNenhum.Parent = Nenhum
NenhumTexto = Instance.new("TextLabel")
NenhumTexto.Size = UDim2.new(0, 182, 1, 0)
NenhumTexto.Position = UDim2.new(0, 39, 0, 0)
NenhumTexto.BackgroundTransparency = 1
NenhumTexto.Text = Traducao.Nenhum
NenhumTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
NenhumTexto.Font = Enum.Font.SourceSansBold
NenhumTexto.TextScaled = true
NenhumTexto.Parent = Nenhum
Reverb = Instance.new("ImageButton")
Reverb.Name = "Reverb"
Reverb.Size = UDim2.new(0, 219, 0, 35)
Reverb.Position = UDim2.new(0, 8, 0, 385)
Reverb.AutoButtonColor = false
Reverb.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Reverb.Parent = ScrollEqua
IconeReverb = Instance.new("ImageLabel")
IconeReverb.Size = UDim2.new(0, 35, 0, 35)
IconeReverb.Position = UDim2.new(0, 0, 0, 0)
IconeReverb.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeReverb.BackgroundTransparency = 0
IconeReverb.Image = "rbxassetid://72645952367955"
IconeReverb.Parent = Reverb
ReverbTexto = Instance.new("TextLabel")
ReverbTexto.Size = UDim2.new(0, 182, 1, 0)
ReverbTexto.Position = UDim2.new(0, 39, 0, 0)
ReverbTexto.BackgroundTransparency = 1
ReverbTexto.Text = "Reverb"
ReverbTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
ReverbTexto.Font = Enum.Font.SourceSansBold
ReverbTexto.TextScaled = true
ReverbTexto.Parent = Reverb
Echo = Instance.new("ImageButton")
Echo.Name = "Echo"
Echo.Size = UDim2.new(0, 219, 0, 35)
Echo.Position = UDim2.new(0, 8, 0, 430)
Echo.AutoButtonColor = false
Echo.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Echo.Parent = ScrollEqua
IconeEcho = Instance.new("ImageLabel")
IconeEcho.Size = UDim2.new(0, 35, 0, 35)
IconeEcho.Position = UDim2.new(0, 0, 0, 0)
IconeEcho.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeEcho.BackgroundTransparency = 0
IconeEcho.Image = "rbxassetid://72645952367955"
IconeEcho.Parent = Echo
EchoTexto = Instance.new("TextLabel")
EchoTexto.Size = UDim2.new(0, 182, 1, 0)
EchoTexto.Position = UDim2.new(0, 39, 0, 0)
EchoTexto.BackgroundTransparency = 1
EchoTexto.Text = "Echo"
EchoTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
EchoTexto.Font = Enum.Font.SourceSansBold
EchoTexto.TextScaled = true
EchoTexto.Parent = Echo
Distortion = Instance.new("ImageButton")
Distortion.Name = "Distortion"
Distortion.Size = UDim2.new(0, 219, 0, 35)
Distortion.Position = UDim2.new(0, 8, 0, 475)
Distortion.AutoButtonColor = false
Distortion.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Distortion.Parent = ScrollEqua
IconeDistortion = Instance.new("ImageLabel")
IconeDistortion.Size = UDim2.new(0, 35, 0, 35)
IconeDistortion.Position = UDim2.new(0, 0, 0, 0)
IconeDistortion.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeDistortion.Image = "rbxassetid://72645952367955"
IconeDistortion.Parent = Distortion
DistortionTexto = Instance.new("TextLabel")
DistortionTexto.Size = UDim2.new(0, 182, 1, 0)
DistortionTexto.Position = UDim2.new(0, 39, 0, 0)
DistortionTexto.BackgroundTransparency = 1
DistortionTexto.Text = "Distortion"
DistortionTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
DistortionTexto.Font = Enum.Font.SourceSansBold
DistortionTexto.TextScaled = true
DistortionTexto.Parent = Distortion
Chorus = Instance.new("ImageButton")
Chorus.Name = "Chorus"
Chorus.Size = UDim2.new(0, 219, 0, 35)
Chorus.Position = UDim2.new(0, 8, 0, 520)
Chorus.AutoButtonColor = false
Chorus.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Chorus.Parent = ScrollEqua
IconeChorus = Instance.new("ImageLabel")
IconeChorus.Size = UDim2.new(0, 35, 0, 35)
IconeChorus.Position = UDim2.new(0, 0, 0, 0)
IconeChorus.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeChorus.Image = "rbxassetid://72645952367955"
IconeChorus.Parent = Chorus
ChorusTexto = Instance.new("TextLabel")
ChorusTexto.Size = UDim2.new(0, 182, 1, 0)
ChorusTexto.Position = UDim2.new(0, 39, 0, 0)
ChorusTexto.BackgroundTransparency = 1
ChorusTexto.Text = "Chorus"
ChorusTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
ChorusTexto.Font = Enum.Font.SourceSansBold
ChorusTexto.TextScaled = true
ChorusTexto.Parent = Chorus
Flanger = Instance.new("ImageButton")
Flanger.Name = "Flanger"
Flanger.Size = UDim2.new(0, 219, 0, 35)
Flanger.Position = UDim2.new(0, 8, 0, 565)
Flanger.AutoButtonColor = false
Flanger.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Flanger.Parent = ScrollEqua
IconeFlanger = Instance.new("ImageLabel")
IconeFlanger.Size = UDim2.new(0, 35, 0, 35)
IconeFlanger.Position = UDim2.new(0, 0, 0, 0)
IconeFlanger.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeFlanger.Image = "rbxassetid://72645952367955"
IconeFlanger.Parent = Flanger
FlangerTexto = Instance.new("TextLabel")
FlangerTexto.Size = UDim2.new(0, 182, 1, 0)
FlangerTexto.Position = UDim2.new(0, 39, 0, 0)
FlangerTexto.BackgroundTransparency = 1
FlangerTexto.Text = "Flanger"
FlangerTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
FlangerTexto.Font = Enum.Font.SourceSansBold
FlangerTexto.TextScaled = true
FlangerTexto.Parent = Flanger
Tremolo = Instance.new("ImageButton")
Tremolo.Name = "Tremolo"
Tremolo.Size = UDim2.new(0, 219, 0, 35)
Tremolo.Position = UDim2.new(0, 8, 0, 610)
Tremolo.AutoButtonColor = false
Tremolo.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Tremolo.Parent = ScrollEqua
IconeTremolo = Instance.new("ImageLabel")
IconeTremolo.Size = UDim2.new(0, 35, 0, 35)
IconeTremolo.Position = UDim2.new(0, 0, 0, 0)
IconeTremolo.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeTremolo.Image = "rbxassetid://72645952367955"
IconeTremolo.Parent = Tremolo
TremoloTexto = Instance.new("TextLabel")
TremoloTexto.Size = UDim2.new(0, 182, 1, 0)
TremoloTexto.Position = UDim2.new(0, 39, 0, 0)
TremoloTexto.BackgroundTransparency = 1
TremoloTexto.Text = "Tremolo"
TremoloTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
TremoloTexto.Font = Enum.Font.SourceSansBold
TremoloTexto.TextScaled = true
TremoloTexto.Parent = Tremolo
Compressor = Instance.new("ImageButton")
Compressor.Name = "Compressor"
Compressor.Size = UDim2.new(0, 219, 0, 35)
Compressor.Position = UDim2.new(0, 8, 0, 655)
Compressor.AutoButtonColor = false
Compressor.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Compressor.Parent = ScrollEqua
IconeCompressor = Instance.new("ImageLabel")
IconeCompressor.Size = UDim2.new(0, 35, 0, 35)
IconeCompressor.Position = UDim2.new(0, 0, 0, 0)
IconeCompressor.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeCompressor.Image = "rbxassetid://72645952367955"
IconeCompressor.Parent = Compressor
CompressorTexto = Instance.new("TextLabel")
CompressorTexto.Size = UDim2.new(0, 182, 1, 0)
CompressorTexto.Position = UDim2.new(0, 39, 0, 0)
CompressorTexto.BackgroundTransparency = 1
CompressorTexto.Text = "Compressor"
CompressorTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
CompressorTexto.Font = Enum.Font.SourceSansBold
CompressorTexto.TextScaled = true
CompressorTexto.Parent = Compressor
Radio = Instance.new("ImageButton")
Radio.Name = "Radio"
Radio.Size = UDim2.new(0, 219, 0, 35)
Radio.Position = UDim2.new(0, 8, 0, 700)
Radio.AutoButtonColor = false
Radio.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Radio.Parent = ScrollEqua
IconeRadio = Instance.new("ImageLabel")
IconeRadio.Size = UDim2.new(0, 35, 0, 35)
IconeRadio.Position = UDim2.new(0, 0, 0, 0)
IconeRadio.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeRadio.Image = "rbxassetid://72645952367955"
IconeRadio.Parent = Radio
RadioTexto = Instance.new("TextLabel")
RadioTexto.Size = UDim2.new(0, 182, 1, 0)
RadioTexto.Position = UDim2.new(0, 39, 0, 0)
RadioTexto.BackgroundTransparency = 1
RadioTexto.Text = "Radio"
RadioTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
RadioTexto.Font = Enum.Font.SourceSansBold
RadioTexto.TextScaled = true
RadioTexto.Parent = Radio
Cinema = Instance.new("ImageButton")
Cinema.Name = "Cinema"
Cinema.Size = UDim2.new(0, 219, 0, 35)
Cinema.Position = UDim2.new(0, 8, 0, 745)
Cinema.AutoButtonColor = false
Cinema.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Cinema.Parent = ScrollEqua
IconeCinema = Instance.new("ImageLabel")
IconeCinema.Size = UDim2.new(0, 35, 0, 35)
IconeCinema.Position = UDim2.new(0, 0, 0, 0)
IconeCinema.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeCinema.Image = "rbxassetid://72645952367955"
IconeCinema.Parent = Cinema
CinemaTexto = Instance.new("TextLabel")
CinemaTexto.Size = UDim2.new(0, 182, 1, 0)
CinemaTexto.Position = UDim2.new(0, 39, 0, 0)
CinemaTexto.BackgroundTransparency = 1
CinemaTexto.Text = "Cinema"
CinemaTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
CinemaTexto.Font = Enum.Font.SourceSansBold
CinemaTexto.TextScaled = true
CinemaTexto.Parent = Cinema
Underwater = Instance.new("ImageButton")
Underwater.Name = "Underwater"
Underwater.Size = UDim2.new(0, 219, 0, 35)
Underwater.Position = UDim2.new(0, 8, 0, 790)
Underwater.AutoButtonColor = false
Underwater.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Underwater.Parent = ScrollEqua
IconeUnderwater = Instance.new("ImageLabel")
IconeUnderwater.Size = UDim2.new(0, 35, 0, 35)
IconeUnderwater.Position = UDim2.new(0, 0, 0, 0)
IconeUnderwater.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeUnderwater.Image = "rbxassetid://72645952367955"
IconeUnderwater.Parent = Underwater
UnderwaterTexto = Instance.new("TextLabel")
UnderwaterTexto.Size = UDim2.new(0, 182, 1, 0)
UnderwaterTexto.Position = UDim2.new(0, 39, 0, 0)
UnderwaterTexto.BackgroundTransparency = 1
UnderwaterTexto.Text = "Underwater"
UnderwaterTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
UnderwaterTexto.Font = Enum.Font.SourceSansBold
UnderwaterTexto.TextScaled = true
UnderwaterTexto.Parent = Underwater
Kid = Instance.new("ImageButton")
Kid.Name = "Kid"
Kid.Size = UDim2.new(0, 219, 0, 35)
Kid.Position = UDim2.new(0, 8, 0, 835)
Kid.AutoButtonColor = false
Kid.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Kid.Parent = ScrollEqua
IconeKid = Instance.new("ImageLabel")
IconeKid.Size = UDim2.new(0, 35, 0, 35)
IconeKid.Position = UDim2.new(0, 0, 0, 0)
IconeKid.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeKid.BackgroundTransparency = 0
IconeKid.Image = "rbxassetid://72645952367955"
IconeKid.Parent = Kid
KidTexto = Instance.new("TextLabel")
KidTexto.Size = UDim2.new(0, 182, 1, 0)
KidTexto.Position = UDim2.new(0, 39, 0, 0)
KidTexto.BackgroundTransparency = 1
KidTexto.Text = "Kid"
KidTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
KidTexto.Font = Enum.Font.SourceSansBold
KidTexto.TextScaled = true
KidTexto.Parent = Kid
Robot = Instance.new("ImageButton")
Robot.Name = "Robot"
Robot.Size = UDim2.new(0, 219, 0, 35)
Robot.Position = UDim2.new(0, 8, 0, 880)
Robot.AutoButtonColor = false
Robot.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Robot.Parent = ScrollEqua
IconeRobot = Instance.new("ImageLabel")
IconeRobot.Size = UDim2.new(0, 35, 0, 35)
IconeRobot.Position = UDim2.new(0, 0, 0, 0)
IconeRobot.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeRobot.BackgroundTransparency = 0
IconeRobot.Image = "rbxassetid://72645952367955"
IconeRobot.Parent = Robot
RobotTexto = Instance.new("TextLabel")
RobotTexto.Size = UDim2.new(0, 182, 1, 0)
RobotTexto.Position = UDim2.new(0, 39, 0, 0)
RobotTexto.BackgroundTransparency = 1
RobotTexto.Text = "Bug"
RobotTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
RobotTexto.Font = Enum.Font.SourceSansBold
RobotTexto.TextScaled = true
RobotTexto.Parent = Robot
Slowed = Instance.new("ImageButton")
Slowed.Name = "Slowed"
Slowed.Size = UDim2.new(0, 219, 0, 35)
Slowed.Position = UDim2.new(0, 8, 0, 925)
Slowed.AutoButtonColor = false
Slowed.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Slowed.Parent = ScrollEqua
IconeSlowed = Instance.new("ImageLabel")
IconeSlowed.Size = UDim2.new(0, 35, 0, 35)
IconeSlowed.Position = UDim2.new(0, 0, 0, 0)
IconeSlowed.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeSlowed.BackgroundTransparency = 0
IconeSlowed.Image = "rbxassetid://72645952367955"
IconeSlowed.Parent = Slowed
SlowedTexto = Instance.new("TextLabel")
SlowedTexto.Size = UDim2.new(0, 182, 1, 0)
SlowedTexto.Position = UDim2.new(0, 39, 0, 0)
SlowedTexto.BackgroundTransparency = 1
SlowedTexto.Text = "Slowed"
SlowedTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
SlowedTexto.Font = Enum.Font.SourceSansBold
SlowedTexto.TextScaled = true
SlowedTexto.Parent = Slowed
ResetarEqua = Instance.new("ImageButton")
ResetarEqua.Name = "Resetar"
ResetarEqua.Size = UDim2.new(0, 219, 0, 35)
ResetarEqua.Position = UDim2.new(0, 8, 0, 975)
ResetarEqua.AutoButtonColor = false
ResetarEqua.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
ResetarEqua.Parent = ScrollEqua
ResetarTexto = Instance.new("TextLabel")
ResetarTexto.Size = UDim2.new(1, 0, 1, 0)
ResetarTexto.Position = UDim2.new(0, 0, 0, 0)
ResetarTexto.BackgroundTransparency = 1
ResetarTexto.Text = "Reset"
ResetarTexto.TextColor3 = Color3.fromRGB(255, 0, 0)
ResetarTexto.Font = Enum.Font.SourceSansBold
ResetarTexto.TextScaled = true
ResetarTexto.Parent = ResetarEqua
Pesquisa = Instance.new("Frame")
Pesquisa.Size = UDim2.new(0, 235, 0, 43)
Pesquisa.Position = UDim2.new(0, 6, 0, 6)
Pesquisa.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Pesquisa.BorderSizePixel = 0
Pesquisa.Parent = Tela4
Lupa = Instance.new("ImageButton")
Lupa.Size = UDim2.new(0, 43, 0, 43)
Lupa.Position = UDim2.new(0, 0, 0, 0)
Lupa.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Lupa.Image = "rbxassetid://78857002895466"
Lupa.Active = true
Lupa.Parent = Pesquisa
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(0, 2, 1, 0)
Linha.Position = UDim2.new(0, 43, 0, 0)
Linha.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Linha.BorderSizePixel = 0
Linha.Parent = Pesquisa
PesquisarBox = Instance.new("TextBox")
PesquisarBox.Size = UDim2.new(0, 139, 0, 37)
PesquisarBox.Position = UDim2.new(0, 48, 0, 3)
PesquisarBox.Text = ""
PesquisarBox.PlaceholderText = Traducao.Pesquisar
PesquisarBox.TextScaled = true
PesquisarBox.TextWrapped = true
PesquisarBox.ClearTextOnFocus = false
PesquisarBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PesquisarBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
PesquisarBox.BackgroundTransparency = 1
PesquisarBox.Active = true
PesquisarBox.Parent = Pesquisa
Linha2 = Instance.new("Frame")
Linha2.Size = UDim2.new(0, 2, 1, 0)
Linha2.Position = UDim2.new(0, 190, 0, 0)
Linha2.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Linha2.BorderSizePixel = 0
Linha2.Parent = Pesquisa
Filtro = Instance.new("ImageButton")
Filtro.Size = UDim2.new(0, 33, 0, 33)
Filtro.Position = UDim2.new(0, 197, 0, 5)
Filtro.AutoButtonColor = false
Filtro.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Filtro.Image = "rbxassetid://128216827107080"
Filtro.Parent = Pesquisa
DownloadFrame = Instance.new("Frame")
DownloadFrame.Size = UDim2.new(0, 235, 0, 151)
DownloadFrame.Position = UDim2.new(0, 6, 0, 58)
DownloadFrame.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
DownloadFrame.BorderSizePixel = 0
DownloadFrame.Parent = Tela4
DownloadFrameTexto = Instance.new("TextLabel")
DownloadFrameTexto.Size = UDim2.new(0, 223, 0, 40)
DownloadFrameTexto.Position = UDim2.new(0, 6, 0, 105)
DownloadFrameTexto.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
DownloadFrameTexto.BackgroundTransparency = 0.5
DownloadFrameTexto.RichText = true
DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.PesquiseTitle .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.PesquiseText .. "</font>"
DownloadFrameTexto.Font = Enum.Font.SourceSansBold
DownloadFrameTexto.TextScaled = true
DownloadFrameTexto.Visible = true
DownloadFrameTexto.Parent = DownloadFrame
padding2 = Instance.new("UIPadding")
padding2.PaddingLeft = UDim.new(0, 2)
padding2.PaddingRight = UDim.new(0, 2)
padding2.PaddingTop = UDim.new(0, 2)
padding2.PaddingBottom = UDim.new(0, 2)
padding2.Parent = DownloadFrameTexto
PaginaFrame = Instance.new("Frame")
PaginaFrame.Size = UDim2.new(0, 235, 0, 27)
PaginaFrame.Position = UDim2.new(0, 6, 0, 218)
PaginaFrame.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
PaginaFrame.BorderSizePixel = 0
PaginaFrame.Visible = false
PaginaFrame.Parent = Tela4
ScrollPagina = Instance.new("ScrollingFrame")
ScrollPagina.Size = UDim2.new(1, -6, 1, 0)
ScrollPagina.Position = UDim2.new(0, 3, 0, 0)
ScrollPagina.BackgroundTransparency = 1
ScrollPagina.BorderSizePixel = 0
ScrollPagina.ScrollBarThickness = 1
ScrollPagina.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollPagina.ScrollBarImageTransparency = 0.5
ScrollPagina.CanvasSize = UDim2.new(0, 280, 0, 0)
ScrollPagina.ScrollingDirection = Enum.ScrollingDirection.X
ScrollPagina.ClipsDescendants = true
ScrollPagina.Parent = PaginaFrame
PaginaEsperandoFrame = Instance.new("Frame")
PaginaEsperandoFrame.Size = UDim2.new(0, 235, 0, 27)
PaginaEsperandoFrame.Position = UDim2.new(0, 6, 0, 218)
PaginaEsperandoFrame.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
PaginaEsperandoFrame.BorderSizePixel = 0
PaginaEsperandoFrame.Visible = true
PaginaEsperandoFrame.Parent = Tela4
PaginaEsperandoIcon = Instance.new("ImageLabel")
PaginaEsperandoIcon.Size = UDim2.new(0, 27, 0, 27)
PaginaEsperandoIcon.Position = UDim2.new(0, 0, 0, 0)
PaginaEsperandoIcon.BackgroundTransparency = 1
PaginaEsperandoIcon.Image = "rbxassetid://130610275359163"
PaginaEsperandoIcon.Parent = PaginaEsperandoFrame
PaginaEsperandoText = Instance.new("TextLabel")
PaginaEsperandoText.Size = UDim2.new(1, -36, 1, 0)
PaginaEsperandoText.Position = UDim2.new(0, 32, 0, 0)
PaginaEsperandoText.RichText = true
PaginaEsperandoText.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.RecursoTi .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.NaoPodePagina .. "</font>"
PaginaEsperandoText.TextScaled = true
PaginaEsperandoText.Font = Enum.Font.SourceSansBold
PaginaEsperandoText.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
PaginaEsperandoText.BackgroundTransparency = 1
PaginaEsperandoText.BorderSizePixel = 0
PaginaEsperandoText.Parent = PaginaEsperandoFrame
Aguardando = Instance.new("ImageLabel")
Aguardando.Size = UDim2.new(0, 80, 0, 80)
Aguardando.AnchorPoint = Vector2.new(0.5, 0.5)
Aguardando.Position = UDim2.new(0.5, 2, 0.5, -20)
Aguardando.BackgroundTransparency = 1
Aguardando.Image = "rbxassetid://130321829564804"
Aguardando.Visible = true
Aguardando.Parent = DownloadFrame
Loading = Instance.new("ImageLabel")
Loading.Size = UDim2.new(0, 75, 0, 75)
Loading.AnchorPoint = Vector2.new(0.5, 0.5)
Loading.Position = UDim2.new(0.5, 0, 0.5, -2)
Loading.BackgroundTransparency = 1
Loading.Image = "rbxassetid://124877910068047"
Loading.Visible = false
Loading.Parent = DownloadFrame
SemResultado = Instance.new("ImageLabel")
SemResultado.Size = UDim2.new(0, 80, 0, 80)
SemResultado.AnchorPoint = Vector2.new(0.5, 0.5)
SemResultado.Position = UDim2.new(0.5, 3, 0.5, -20)
SemResultado.BackgroundTransparency = 1
SemResultado.Image = "rbxassetid://94766101394526"
SemResultado.Visible = false
SemResultado.Parent = DownloadFrame
Resultados = Instance.new("Frame")
Resultados.Size = UDim2.new(1, 0, 1, -4)
Resultados.Position = UDim2.new(0, 0, 0, 2)
Resultados.BackgroundTransparency = 1
Resultados.BorderSizePixel = 0
Resultados.ClipsDescendants = true
Resultados.Parent = DownloadFrame
FiltroFrame = Instance.new("Frame")
FiltroFrame.Size = UDim2.new(1, 0, 1, 0)
FiltroFrame.Position = UDim2.new(0, 0, 0, 0)
FiltroFrame.BackgroundTransparency = 1
FiltroFrame.BorderSizePixel = 0
FiltroFrame.Visible = false
FiltroFrame.Parent = Resultados
TituloFiltro = Instance.new("TextLabel")
TituloFiltro.Size = UDim2.new(0, 227, 0, 24)
TituloFiltro.Position = UDim2.new(0, 4, 0, 2)
TituloFiltro.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
TituloFiltro.TextColor3 = Color3.fromRGB(255, 255, 255)
TituloFiltro.BackgroundTransparency = 0.5
TituloFiltro.BorderSizePixel = 0
TituloFiltro.Text = Traducao.Filter
TituloFiltro.TextSize = 12
TituloFiltro.Parent = FiltroFrame
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 2)
Linha.Position = UDim2.new(0, 0, 0, 30)
Linha.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Linha.BorderSizePixel = 0
Linha.Parent = FiltroFrame
ScrollFiltro = Instance.new("ScrollingFrame")
ScrollFiltro.Size = UDim2.new(1, -1, 1, -10)
ScrollFiltro.Position = UDim2.new(0, 0, 0, 34)
ScrollFiltro.BackgroundTransparency = 1
ScrollFiltro.BorderSizePixel = 0
ScrollFiltro.ScrollBarThickness = 1
ScrollFiltro.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollFiltro.ScrollBarImageTransparency = 0.5
ScrollFiltro.CanvasSize = UDim2.new(0, 0, 0, 210)
ScrollFiltro.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollFiltro.ClipsDescendants = true
ScrollFiltro.Parent = FiltroFrame
Relevancia = Instance.new("ImageButton")
Relevancia.Size = UDim2.new(0, 221, 0, 35)
Relevancia.Position = UDim2.new(0, 7, 0, 5)
Relevancia.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Relevancia.BorderSizePixel = 0
Relevancia.AutoButtonColor = false
Relevancia.Parent = ScrollFiltro
DataUpload = Instance.new("ImageButton")
DataUpload.Size = UDim2.new(0, 221, 0, 35)
DataUpload.Position = UDim2.new(0, 7, 0, 50)
DataUpload.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
DataUpload.BackgroundTransparency = 0
DataUpload.BorderSizePixel = 0
DataUpload.AutoButtonColor = false
DataUpload.Active = true
DataUpload.Parent = ScrollFiltro
Duracao = Instance.new("ImageButton")
Duracao.Size = UDim2.new(0, 221, 0, 35)
Duracao.Position = UDim2.new(0, 7, 0, 95)
Duracao.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Duracao.BorderSizePixel = 0
Duracao.AutoButtonColor = false
Duracao.Parent = ScrollFiltro
IconeRelevancia = Instance.new("ImageLabel")
IconeRelevancia.Size = UDim2.new(0, 35, 0, 35)
IconeRelevancia.Position = UDim2.new(0, 0, 0, 0)
IconeRelevancia.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeRelevancia.BackgroundTransparency = 0
IconeRelevancia.Image = "rbxassetid://86663364934636"
IconeRelevancia.Parent = Relevancia
IconeDataUpload = Instance.new("ImageLabel")
IconeDataUpload.Size = UDim2.new(0, 35, 0, 35)
IconeDataUpload.Position = UDim2.new(0, 0, 0, 0)
IconeDataUpload.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeDataUpload.BackgroundTransparency = 0
IconeDataUpload.Image = "rbxassetid://102239634857456"
IconeDataUpload.ImageTransparency = 0
IconeDataUpload.Parent = DataUpload
IconeDuracao = Instance.new("ImageLabel")
IconeDuracao.Size = UDim2.new(0, 35, 0, 35)
IconeDuracao.Position = UDim2.new(0, 0, 0, 0)
IconeDuracao.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeDuracao.BackgroundTransparency = 0
IconeDuracao.Image = "rbxassetid://124803568759863"
IconeDuracao.Parent = Duracao
RelevanciaTexto = Instance.new("TextLabel")
RelevanciaTexto.Size = UDim2.new(0, 178, 1, 0)
RelevanciaTexto.Position = UDim2.new(0, 39, 0, 0)
RelevanciaTexto.BackgroundTransparency = 1
RelevanciaTexto.Text = Traducao.Order .. "\n" .. Traducao.Relevance
RelevanciaTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
RelevanciaTexto.Font = Enum.Font.SourceSansBold
RelevanciaTexto.TextScaled = true
RelevanciaTexto.Parent = Relevancia
DataUploadTexto = Instance.new("TextLabel")
DataUploadTexto.Size = UDim2.new(0, 178, 1, 0)
DataUploadTexto.Position = UDim2.new(0, 39, 0, 0)
DataUploadTexto.BackgroundTransparency = 1
DataUploadTexto.Text = Traducao.UploaDate .. "\n" .. Traducao.Any
DataUploadTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
DataUploadTexto.Font = Enum.Font.SourceSansBold
DataUploadTexto.TextScaled = true
DataUploadTexto.Parent = DataUpload
DuracaoTexto = Instance.new("TextLabel")
DuracaoTexto.Size = UDim2.new(0, 178, 1, 0)
DuracaoTexto.Position = UDim2.new(0, 39, 0, 0)
DuracaoTexto.BackgroundTransparency = 1
DuracaoTexto.Text = Traducao.Duration .. "\n" .. Traducao.Any
DuracaoTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
DuracaoTexto.Font = Enum.Font.SourceSansBold
DuracaoTexto.TextScaled = true
DuracaoTexto.Parent = Duracao
AplicarFiltro = Instance.new("ImageButton")
AplicarFiltro.Size = UDim2.new(0, 100, 0, 35)
AplicarFiltro.Position = UDim2.new(0, 7, 0, 145)
AplicarFiltro.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
AplicarFiltro.BackgroundTransparency = 0.9
AplicarFiltro.BorderSizePixel = 0
AplicarFiltro.AutoButtonColor = false
AplicarFiltro.Parent = ScrollFiltro
RemoverFiltro = Instance.new("ImageButton")
RemoverFiltro.Size = UDim2.new(0, 100, 0, 35)
RemoverFiltro.Position = UDim2.new(0, 128, 0, 145)
RemoverFiltro.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
RemoverFiltro.BackgroundTransparency = 0.9
RemoverFiltro.BorderSizePixel = 0
RemoverFiltro.AutoButtonColor = false
RemoverFiltro.Parent = ScrollFiltro
NomeAplicarFiltro = Instance.new("TextLabel")
NomeAplicarFiltro.Size = UDim2.new(1, -8, 1, -8)
NomeAplicarFiltro.Position = UDim2.new(0, 4, 0, 4)
NomeAplicarFiltro.BackgroundTransparency = 1
NomeAplicarFiltro.Text = Traducao.AplicarF
NomeAplicarFiltro.TextColor3 = Color3.fromRGB(20, 20, 20)
NomeAplicarFiltro.Font = Enum.Font.SourceSansBold
NomeAplicarFiltro.TextScaled = true
NomeAplicarFiltro.Parent = AplicarFiltro
NomeRemoverFiltro = Instance.new("TextLabel")
NomeRemoverFiltro.Size = UDim2.new(1, -8, 1, -8)
NomeRemoverFiltro.Position = UDim2.new(0, 4, 0, 4)
NomeRemoverFiltro.BackgroundTransparency = 1
NomeRemoverFiltro.Text = Traducao.RemoverF
NomeRemoverFiltro.TextColor3 = Color3.fromRGB(20, 20, 20)
NomeRemoverFiltro.Font = Enum.Font.SourceSansBold
NomeRemoverFiltro.TextScaled = true
NomeRemoverFiltro.Parent = RemoverFiltro
Formato = Instance.new("Frame")
Formato.Size = UDim2.new(1, 0, 1, 0)
Formato.Position = UDim2.new(0, 0, 0, 0)
Formato.BackgroundTransparency = 1
Formato.BorderSizePixel = 0
Formato.Visible = false
Formato.Parent = Resultados
TituloFormato = Instance.new("TextLabel")
TituloFormato.Size = UDim2.new(0, 227, 0, 24)
TituloFormato.Position = UDim2.new(0, 4, 0, 2)
TituloFormato.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
TituloFormato.TextColor3 = Color3.fromRGB(255, 255, 255)
TituloFormato.BackgroundTransparency = 0.5
TituloFormato.BorderSizePixel = 0
TituloFormato.Text = Traducao.EscolhaFor
TituloFormato.TextSize = 12
TituloFormato.Parent = Formato
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 2)
Linha.Position = UDim2.new(0, 0, 0, 30)
Linha.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Linha.BorderSizePixel = 0
Linha.Parent = Formato
Thumbfor = Instance.new("ImageLabel")
Thumbfor.Size = UDim2.new(0, 85, 0, 50)
Thumbfor.Position = UDim2.new(0, 7, 0, 39)
Thumbfor.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Thumbfor.Image = "rbxassetid://0"
Thumbfor.ImageRectOffset = Vector2.new(0, 0)
Thumbfor.ImageRectSize = Vector2.new(0, 0)
Thumbfor.Parent = Formato
Titulofor = Instance.new("Frame")
Titulofor.Size = UDim2.new(0, 127, 0, 50)
Titulofor.Position = UDim2.new(0, 101, 0, 39)
Titulofor.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Titulofor.Parent = Formato
TextoTituloFor = Instance.new("TextLabel")
TextoTituloFor.Size = UDim2.new(1, -10, 1, -10)
TextoTituloFor.Position = UDim2.new(0, 5, 0, 5)
TextoTituloFor.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
TextoTituloFor.BackgroundTransparency = 1
TextoTituloFor.BorderSizePixel = 0
TextoTituloFor.RichText = true
TextoTituloFor.Text = ""
TextoTituloFor.TextScaled = true
TextoTituloFor.Parent = Titulofor
BotaoMp3 = Instance.new("ImageButton")
BotaoMp3.Size = UDim2.new(0, 60, 0, 30)
BotaoMp3.Position = UDim2.new(0, 7, 0, 112)
BotaoMp3.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
BotaoMp3.BackgroundTransparency = 0
BotaoMp3.AutoButtonColor = true
BotaoMp3.Parent = Formato
BotaoMp4 = Instance.new("ImageButton")
BotaoMp4.Size = UDim2.new(0, 60, 0, 30)
BotaoMp4.Position = UDim2.new(0, 88, 0, 112)
BotaoMp4.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
BotaoMp4.BackgroundTransparency = 0.9
BotaoMp4.AutoButtonColor = false
BotaoMp4.Parent = Formato
BotaoCancelar = Instance.new("ImageButton")
BotaoCancelar.Size = UDim2.new(0, 60, 0, 30)
BotaoCancelar.Position = UDim2.new(0, 168, 0, 112)
BotaoCancelar.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
BotaoCancelar.Parent = Formato
NomeMp3 = Instance.new("TextLabel")
NomeMp3.Size = UDim2.new(1, -8, 1, -8)
NomeMp3.Position = UDim2.new(0, 4, 0, 4)
NomeMp3.BackgroundTransparency = 1
NomeMp3.Text = Traducao.Musica
NomeMp3.TextColor3 = Color3.fromRGB(0, 191, 255)
NomeMp3.Font = Enum.Font.SourceSansBold
NomeMp3.TextScaled = true
NomeMp3.Parent = BotaoMp3
NomeMp4 = Instance.new("TextLabel")
NomeMp4.Size = UDim2.new(1, -8, 1, -8)
NomeMp4.Position = UDim2.new(0, 4, 0, 4)
NomeMp4.BackgroundTransparency = 1
NomeMp4.Text = "Video"
NomeMp4.TextColor3 = Color3.fromRGB(144, 238, 144)
NomeMp4.Font = Enum.Font.SourceSansBold
NomeMp4.TextScaled = true
NomeMp4.Parent = BotaoMp4
NomeCancel = Instance.new("TextLabel")
NomeCancel.Size = UDim2.new(1, -8, 1, -8)
NomeCancel.Position = UDim2.new(0, 4, 0, 4)
NomeCancel.BackgroundTransparency = 1
NomeCancel.Text = Traducao.Cancelar
NomeCancel.TextColor3 = Color3.fromRGB(178, 55, 34)
NomeCancel.Font = Enum.Font.SourceSansBold
NomeCancel.TextScaled = true
NomeCancel.Parent = BotaoCancelar
Erro = Instance.new("ImageLabel")
Erro.Size = UDim2.new(0, 80, 0, 80)
Erro.AnchorPoint = Vector2.new(0.5, 0.5)
Erro.Position = UDim2.new(0.5, -3, 0.5, -20)
Erro.BackgroundTransparency = 1
Erro.Image = "rbxassetid://80694922314021"
Erro.Visible = false
Erro.Parent = Resultados
Baixando = Instance.new("ImageLabel")
Baixando.Size = UDim2.new(0, 80, 0, 80)
Baixando.AnchorPoint = Vector2.new(0.5, 0.5)
Baixando.Position = UDim2.new(0.5, -3, 0.5, -20)
Baixando.BackgroundTransparency = 1
Baixando.Image = "rbxassetid://76931060119037"
Baixando.Visible = false
Baixando.Parent = Resultados
Concluido = Instance.new("ImageLabel")
Concluido.Size = UDim2.new(0, 77, 0, 77)
Concluido.AnchorPoint = Vector2.new(0.5, 0.5)
Concluido.Position = UDim2.new(0.5, -3, 0.5, -20)
Concluido.BackgroundTransparency = 1
Concluido.Image = "rbxassetid://135264044346021"
Concluido.Visible = false
Concluido.Parent = Resultados
Tutorial = Instance.new("ImageButton")
Tutorial.Size = UDim2.new(0, 25, 0, 25)
Tutorial.Position = UDim2.new(0, 7, 0, 5)
Tutorial.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Tutorial.BorderSizePixel = 0
Tutorial.Visible = false
Tutorial.Parent = Resultados
TutoTexto = Instance.new("TextLabel")
TutoTexto.Size = UDim2.new(1, 0, 1, 0)
TutoTexto.Position = UDim2.new(0, 0, 0, 0)
TutoTexto.BackgroundTransparency = 1
TutoTexto.Text = "?"
TutoTexto.TextColor3 = Color3.fromRGB(188, 11, 35)
TutoTexto.Font = Enum.Font.SourceSansBold
TutoTexto.TextScaled = true
TutoTexto.Parent = Tutorial
Novamente = Instance.new("ImageButton")
Novamente.Size = UDim2.new(0, 25, 0, 25)
Novamente.Position = UDim2.new(0, 203, 0, 5)
Novamente.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Novamente.BorderSizePixel = 0
Novamente.Visible = false
Novamente.Parent = Resultados
FotoNova = Instance.new("ImageLabel")
FotoNova.Size = UDim2.new(0, 18, 0, 18)
FotoNova.Position = UDim2.new(0, 3, 0, 3)
FotoNova.BackgroundTransparency = 1
FotoNova.ImageTransparency = 0
FotoNova.Image = "rbxassetid://95528695645064"
FotoNova.Parent = Novamente
ScrollDownload = Instance.new("ScrollingFrame")
ScrollDownload.Size = UDim2.new(1, -1, 1, 0)
ScrollDownload.Position = UDim2.new(0, 0, 0, 0)
ScrollDownload.BackgroundTransparency = 1
ScrollDownload.BorderSizePixel = 0
ScrollDownload.ScrollBarThickness = 1
ScrollDownload.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollDownload.ScrollBarImageTransparency = 0.5
ScrollDownload.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollDownload.CanvasPosition = Vector2.new(0, 0)
ScrollDownload.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollDownload.ClipsDescendants = true
ScrollDownload.Visible = false
ScrollDownload.Parent = Resultados
TituloGC = Instance.new("Frame")
TituloGC.Size = UDim2.new(0, 235, 0, 43)
TituloGC.Position = UDim2.new(0, 6, 0, 6)
TituloGC.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
TituloGC.BorderSizePixel = 0
TituloGC.Parent = Tela5
NomeGC = Instance.new("TextLabel")
NomeGC.Size = UDim2.new(1, 0, 1, 0)
NomeGC.Position = UDim2.new(0, 0, 0, 0)
NomeGC.BackgroundTransparency = 1
NomeGC.Text = "Global Chat"
NomeGC.TextColor3 = Color3.fromRGB(255, 0, 0)
NomeGC.Font = Enum.Font.SourceSansBold
NomeGC.TextScaled = true
NomeGC.Parent = TituloGC
GCFrame = Instance.new("Frame")
GCFrame.Size = UDim2.new(0, 235, 0, 187)
GCFrame.Position = UDim2.new(0, 6, 0, 58)
GCFrame.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
GCFrame.BorderSizePixel = 0
GCFrame.Parent = Tela5
Regras = Instance.new("TextButton")
Regras.Size = UDim2.new(0, 19, 0, 19)
Regras.Position = UDim2.new(0, 5, 0, 3)
Regras.Text = "R"
Regras.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Regras.TextColor3 = Color3.fromRGB(255, 255, 255)
Regras.BackgroundTransparency = 0.5
Regras.Parent = GCFrame
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 2)
Linha.Position = UDim2.new(0, 0, 0, 25)
Linha.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Linha.BorderSizePixel = 0
Linha.Parent = GCFrame
AvisoGC = Instance.new("TextLabel")
AvisoGC.Size = UDim2.new(0, 177, 0, 19)
AvisoGC.Position = UDim2.new(0, 29, 0, 3)
AvisoGC.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
AvisoGC.BackgroundTransparency = 0.5
AvisoGC.Text = Traducao.Respeito
AvisoGC.TextColor3 = Color3.fromRGB(255, 255, 255)
AvisoGC.Font = Enum.Font.SourceSansBold
AvisoGC.TextScaled = true
AvisoGC.Visible = true
AvisoGC.Parent = GCFrame
padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 3)
padding.PaddingRight = UDim.new(0, 3)
padding.PaddingTop = UDim.new(0, 3)
padding.PaddingBottom = UDim.new(0, 3)
padding.Parent = AvisoGC
NotificarGC = Instance.new("ImageButton")
NotificarGC.Size = UDim2.new(0, 19, 0, 19)
NotificarGC.Position = UDim2.new(0, 211, 0, 3)
NotificarGC.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
NotificarGC.BackgroundTransparency = 0.5
NotificarGC.Parent = GCFrame
Sino = Instance.new("ImageLabel")
Sino.Size = UDim2.new(0, 17, 0, 16)
Sino.Position = UDim2.new(0, 1, 0, 1)
Sino.Image = "rbxassetid://115374069603142"
Sino.BackgroundTransparency = 1
Sino.Parent = NotificarGC
EsperandoIMG = Instance.new("ImageLabel")
EsperandoIMG.Size = UDim2.new(0, 90, 0, 90)
EsperandoIMG.AnchorPoint = Vector2.new(0.5, 0.5)
EsperandoIMG.Position = UDim2.new(0.5, -3, 0.5, -5)
EsperandoIMG.BackgroundTransparency = 1
EsperandoIMG.Image = "rbxassetid://18836713445"
EsperandoIMG.Visible = true
EsperandoIMG.Parent = GCFrame
BaseFinalGC = Instance.new("Frame")
BaseFinalGC.Size = UDim2.new(0, 40, 0, 40)
BaseFinalGC.AnchorPoint = Vector2.new(0.5, 0.5)
BaseFinalGC.Position = UDim2.new(0.5, 0, 0.5, 26)
BaseFinalGC.BorderSizePixel = 0
BaseFinalGC.BackgroundTransparency = 1
BaseFinalGC.ZIndex = 2
BaseFinalGC.ClipsDescendants = true
BaseFinalGC.Parent = GCFrame
FinalGC = Instance.new("ImageButton")
FinalGC.Size = UDim2.new(0, 32, 0, 32)
FinalGC.Position = UDim2.new(0, 4, 1, 4)
FinalGC.ZIndex = 2
FinalGC.Image = "rbxassetid://128357204583758"
FinalGC.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
FinalGC.Parent = BaseFinalGC
ScrollGC = Instance.new("ScrollingFrame")
ScrollGC.Size = UDim2.new(1, -2, 1, -73)
ScrollGC.Position = UDim2.new(0, 1, 0, 28)
ScrollGC.BackgroundTransparency = 1
ScrollGC.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollGC.ScrollBarImageTransparency = 0.5
ScrollGC.BorderSizePixel = 0
ScrollGC.ScrollBarThickness = 1
ScrollGC.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollGC.CanvasPosition = Vector2.new(0, 0)
ScrollGC.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollGC.ClipsDescendants = true
ScrollGC.Visible = false
ScrollGC.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollGC.Parent = GCFrame
paddinggc = Instance.new("UIPadding")
paddinggc.PaddingLeft = UDim.new(0, 5)
paddinggc.PaddingRight = UDim.new(0, 5)
paddinggc.PaddingTop = UDim.new(0, 5)
paddinggc.PaddingBottom = UDim.new(0, 5)
paddinggc.Parent = ScrollGC
layoutgc = Instance.new("UIListLayout")
layoutgc.Parent = ScrollGC
layoutgc.SortOrder = Enum.SortOrder.LayoutOrder
layoutgc.Padding = UDim.new(0, 9)
Linha2 = Instance.new("Frame")
Linha2.Size = UDim2.new(1, 0, 0, 2)
Linha2.Position = UDim2.new(0, 0, 0, 143)
Linha2.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Linha2.BorderSizePixel = 0
Linha2.Parent = GCFrame
MsgFrame = Instance.new("Frame")
MsgFrame.Size = UDim2.new(0, 223, 0, 32)
MsgFrame.Position = UDim2.new(0, 6, 0, 150)
MsgFrame.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
MsgFrame.BorderSizePixel = 0
MsgFrame.Parent = GCFrame
MsgErroGC = Instance.new("TextLabel")
MsgErroGC.Size = UDim2.new(0, 215, 0, 28)
MsgErroGC.Position = UDim2.new(0, 4, 0, 2)
MsgErroGC.Text = Traducao.GcKey
MsgErroGC.TextScaled = true
MsgErroGC.TextColor3 = Color3.fromRGB(220, 220, 220)
MsgErroGC.BackgroundTransparency = 1
MsgErroGC.Visible = true
MsgErroGC.Parent = MsgFrame
Traduzir = Instance.new("ImageButton")
Traduzir.Size = UDim2.new(0, 24, 0, 24)
Traduzir.Position = UDim2.new(0, 4, 0, 4)
Traduzir.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Traduzir.Visible = false
Traduzir.Parent = MsgFrame
FotoTradu = Instance.new("ImageLabel")
FotoTradu.Size = UDim2.new(0, 18, 0, 18)
FotoTradu.Position = UDim2.new(0, 3, 0, 3)
FotoTradu.BackgroundTransparency = 1
FotoTradu.ImageTransparency = 0
FotoTradu.Image = "rbxassetid://84867288877251"
FotoTradu.Parent = Traduzir
LinhaTraducao = Instance.new("Frame")
LinhaTraducao.Size = UDim2.new(0, 1, 1, 0)
LinhaTraducao.Position = UDim2.new(0, 32, 0, 0)
LinhaTraducao.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
LinhaTraducao.BorderSizePixel = 0
LinhaTraducao.Visible = false
LinhaTraducao.Parent = MsgFrame
GCBox = Instance.new("TextBox")
GCBox.Size = UDim2.new(0, 151, 0, 28)
GCBox.Position = UDim2.new(0, 36, 0, 2)
GCBox.Text = ""
GCBox.ClearTextOnFocus = false
GCBox.PlaceholderText = Traducao.EnvieGc
GCBox.TextScaled = true
GCBox.TextColor3 = Color3.fromRGB(255, 255, 255)
GCBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
GCBox.BackgroundTransparency = 1
GCBox.Active = false
GCBox.Visible = false
GCBox.Parent = MsgFrame
SendGC = Instance.new("ImageButton")
SendGC.Size = UDim2.new(0, 32, 0, 32)
SendGC.Position = UDim2.new(0, 191, 0, 0)
SendGC.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
SendGC.Visible = false
SendGC.Parent = MsgFrame
Aviao = Instance.new("ImageLabel")
Aviao.Size = UDim2.new(0, 24, 0, 24)
Aviao.Position = UDim2.new(0, 4, 0, 4)
Aviao.BackgroundTransparency = 1
Aviao.ImageTransparency = 0
Aviao.Image = "rbxassetid://111380412941011"
Aviao.Parent = SendGC
TituloPremium = Instance.new("Frame")
TituloPremium.Size = UDim2.new(0, 235, 0, 43)
TituloPremium.Position = UDim2.new(0, 6, 0, 6)
TituloPremium.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
TituloPremium.BorderSizePixel = 0
TituloPremium.Parent = Tela6
NomePremium = Instance.new("TextLabel")
NomePremium.Size = UDim2.new(1, 0, 1, 0)
NomePremium.Position = UDim2.new(0, 0, 0, 0)
NomePremium.BackgroundTransparency = 1
NomePremium.Text = "Premium"
NomePremium.TextColor3 = Color3.fromRGB(255, 255, 0)
NomePremium.Font = Enum.Font.SourceSansBold
NomePremium.TextScaled = true
NomePremium.Parent = TituloPremium
Privilegios = Instance.new("Frame")
Privilegios.Size = UDim2.new(0, 235, 0, 100)
Privilegios.Position = UDim2.new(0, 6, 0, 58)
Privilegios.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Privilegios.BorderSizePixel = 0
Privilegios.Parent = Tela6
BaseSF = Instance.new("Frame")
BaseSF.Size = UDim2.new(1, 0, 1, -4)
BaseSF.Position = UDim2.new(0, 0, 0, 2)
BaseSF.BackgroundTransparency = 1
BaseSF.BorderSizePixel = 0
BaseSF.ClipsDescendants = true
BaseSF.Visible = true
BaseSF.Parent = Privilegios
ScrollPremium = Instance.new("ScrollingFrame")
ScrollPremium.Size = UDim2.new(1, -2, 1, 0)
ScrollPremium.Position = UDim2.new(0, 0, 0, 0)
ScrollPremium.BackgroundTransparency = 1
ScrollPremium.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollPremium.ScrollBarImageTransparency = 0.5
ScrollPremium.BorderSizePixel = 0
ScrollPremium.ScrollBarThickness = 1
ScrollPremium.CanvasSize = UDim2.new(0, 0, 0, 270)
ScrollPremium.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollPremium.ClipsDescendants = false
ScrollPremium.Parent = BaseSF
Priv1 = Instance.new("ImageButton")
Priv1.Size = UDim2.new(0, 221, 0, 35)
Priv1.Position = UDim2.new(0, 7, 0, 5)
Priv1.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Priv1.AutoButtonColor = false
Priv1.Parent = ScrollPremium
Priv2 = Instance.new("ImageButton")
Priv2.Size = UDim2.new(0, 221, 0, 35)
Priv2.Position = UDim2.new(0, 7, 0, 50)
Priv2.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Priv2.AutoButtonColor = false
Priv2.Parent = ScrollPremium
Priv3 = Instance.new("ImageButton")
Priv3.Size = UDim2.new(0, 221, 0, 35)
Priv3.Position = UDim2.new(0, 7, 0, 95)
Priv3.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Priv3.AutoButtonColor = false
Priv3.Parent = ScrollPremium
Priv4 = Instance.new("ImageButton")
Priv4.Size = UDim2.new(0, 221, 0, 35)
Priv4.Position = UDim2.new(0, 7, 0, 140)
Priv4.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Priv4.AutoButtonColor = false
Priv4.Parent = ScrollPremium
Priv5 = Instance.new("ImageButton")
Priv5.Size = UDim2.new(0, 221, 0, 35)
Priv5.Position = UDim2.new(0, 7, 0, 185)
Priv5.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Priv5.AutoButtonColor = false
Priv5.Parent = ScrollPremium
Priv6 = Instance.new("ImageButton")
Priv6.Size = UDim2.new(0, 221, 0, 35)
Priv6.Position = UDim2.new(0, 7, 0, 230)
Priv6.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Priv6.AutoButtonColor = false
Priv6.Parent = ScrollPremium
IconePriv1 = Instance.new("ImageLabel")
IconePriv1.Size = UDim2.new(0, 35, 0, 35)
IconePriv1.Position = UDim2.new(0, 0, 0, 0)
IconePriv1.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconePriv1.Image = "rbxassetid://140605327166526"
IconePriv1.Parent = Priv1
IconePriv2 = Instance.new("ImageLabel")
IconePriv2.Size = UDim2.new(0, 35, 0, 35)
IconePriv2.Position = UDim2.new(0, 0, 0, 0)
IconePriv2.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconePriv2.Image = "rbxassetid://128999640209878"
IconePriv2.Parent = Priv2
IconePriv3 = Instance.new("ImageLabel")
IconePriv3.Size = UDim2.new(0, 35, 0, 35)
IconePriv3.Position = UDim2.new(0, 0, 0, 0)
IconePriv3.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconePriv3.Image = "rbxassetid://126724539196702"
IconePriv3.Parent = Priv3
IconePriv4 = Instance.new("ImageLabel")
IconePriv4.Size = UDim2.new(0, 35, 0, 35)
IconePriv4.Position = UDim2.new(0, 0, 0, 0)
IconePriv4.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconePriv4.Image = "rbxassetid://77651842919295"
IconePriv4.Parent = Priv4
IconePriv5 = Instance.new("ImageLabel")
IconePriv5.Size = UDim2.new(0, 35, 0, 35)
IconePriv5.Position = UDim2.new(0, 0, 0, 0)
IconePriv5.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconePriv5.Image = "rbxassetid://129506682254424"
IconePriv5.Parent = Priv5
IconePriv6 = Instance.new("ImageLabel")
IconePriv6.Size = UDim2.new(0, 35, 0, 35)
IconePriv6.Position = UDim2.new(0, 0, 0, 0)
IconePriv6.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconePriv6.Image = "rbxassetid://135757623745817"
IconePriv6.Parent = Priv6
TextoPriv1 = Instance.new("TextLabel")
TextoPriv1.Size = UDim2.new(0, 160, 1, 0)
TextoPriv1.Position = UDim2.new(0, 45, 0, 0)
TextoPriv1.BackgroundTransparency = 1
TextoPriv1.Text = Traducao.Priv1
TextoPriv1.TextColor3 = Color3.fromRGB(144, 238, 144)
TextoPriv1.Font = Enum.Font.SourceSansBold
TextoPriv1.TextScaled = true
TextoPriv1.Parent = Priv1
TextoPriv2 = Instance.new("TextLabel")
TextoPriv2.Size = UDim2.new(0, 160, 1, 0)
TextoPriv2.Position = UDim2.new(0, 45, 0, 0)
TextoPriv2.BackgroundTransparency = 1
TextoPriv2.Text = Traducao.Priv2
TextoPriv2.TextColor3 = Color3.fromRGB(173, 216, 230)
TextoPriv2.Font = Enum.Font.SourceSansBold
TextoPriv2.TextScaled = true
TextoPriv2.Parent = Priv2
TextoPriv3 = Instance.new("TextLabel")
TextoPriv3.Size = UDim2.new(0, 160, 1, 0)
TextoPriv3.Position = UDim2.new(0, 45, 0, 0)
TextoPriv3.BackgroundTransparency = 1
TextoPriv3.Text = "MiniPlayer"
TextoPriv3.TextColor3 = Color3.fromRGB(186, 85, 211)
TextoPriv3.Font = Enum.Font.SourceSansBold
TextoPriv3.TextScaled = true
TextoPriv3.Parent = Priv3
TextoPriv4 = Instance.new("TextLabel")
TextoPriv4.Size = UDim2.new(0, 160, 1, 0)
TextoPriv4.Position = UDim2.new(0, 45, 0, 0)
TextoPriv4.BackgroundTransparency = 1
TextoPriv4.Text = "Roblox Audio"
TextoPriv4.TextColor3 = Color3.fromRGB(255, 99, 71)
TextoPriv4.Font = Enum.Font.SourceSansBold
TextoPriv4.TextScaled = true
TextoPriv4.Parent = Priv4
TextoPriv5 = Instance.new("TextLabel")
TextoPriv5.Size = UDim2.new(0, 160, 1, 0)
TextoPriv5.Position = UDim2.new(0, 45, 0, 0)
TextoPriv5.BackgroundTransparency = 1
TextoPriv5.Text = "Global Chat"
TextoPriv5.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoPriv5.Font = Enum.Font.SourceSansBold
TextoPriv5.TextScaled = true
TextoPriv5.Parent = Priv5
TextoPriv6 = Instance.new("TextLabel")
TextoPriv6.Size = UDim2.new(0, 160, 1, 0)
TextoPriv6.Position = UDim2.new(0, 45, 0, 0)
TextoPriv6.BackgroundTransparency = 1
TextoPriv6.Text = "Premium UI"
TextoPriv6.TextColor3 = Color3.fromRGB(139, 69, 19)
TextoPriv6.Font = Enum.Font.SourceSansBold
TextoPriv6.TextScaled = true
TextoPriv6.Parent = Priv6
local frame2 = Instance.new("Frame")
frame2.Size = UDim2.new(0, 235, 0, 78)
frame2.Position = UDim2.new(0, 6, 0, 167)
frame2.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
frame2.BorderSizePixel = 0
frame2.Visible = false
frame2.Parent = Tela6
IconeKeyOk = Instance.new("ImageLabel")
IconeKeyOk.Size = UDim2.new(0, 40, 0, 40)
IconeKeyOk.AnchorPoint = Vector2.new(0.5, 0)
IconeKeyOk.Position = UDim2.new(0.5, 0, 0, 2)
IconeKeyOk.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeKeyOk.BackgroundTransparency = 1
IconeKeyOk.Image = "rbxassetid://132948829118667"
IconeKeyOk.Parent = frame2
PremiumOkTexto = Instance.new("TextLabel")
PremiumOkTexto.Size = UDim2.new(0, 225, 0, 30)
PremiumOkTexto.Position = UDim2.new(0, 5, 0, 44)
PremiumOkTexto.RichText = true
PremiumOkTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.VocePremium .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.VocePremiumTexto .. "</font>"
PremiumOkTexto.TextScaled = true
PremiumOkTexto.Font = Enum.Font.SourceSansBold
PremiumOkTexto.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
PremiumOkTexto.BackgroundTransparency = 0.5
PremiumOkTexto.BorderSizePixel = 0
PremiumOkTexto.Parent = frame2
KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 235, 0, 43)
KeyFrame.Position = UDim2.new(0, 6, 0, 167)
KeyFrame.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
KeyFrame.BorderSizePixel = 0
KeyFrame.Visible = true
KeyFrame.Parent = Tela6
SendKey = Instance.new("ImageButton")
SendKey.Size = UDim2.new(0, 43, 0, 43)
SendKey.Position = UDim2.new(0, 0, 0, 0)
SendKey.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
SendKey.Parent = KeyFrame
IconeKey = Instance.new("ImageLabel")
IconeKey.Size = UDim2.new(0, 30, 0, 30)
IconeKey.Position = UDim2.new(0, 6, 0, 6)
IconeKey.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
IconeKey.BackgroundTransparency = 1
IconeKey.Image = "rbxassetid://108124574887969"
IconeKey.Parent = SendKey
KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0, 186, 0, 41)
KeyBox.Position = UDim2.new(0, 47, 0, 1)
KeyBox.Text = ""
KeyBox.ClearTextOnFocus = false
KeyBox.PlaceholderText = Traducao.Key
KeyBox.TextScaled = true
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.BackgroundTransparency = 1
KeyBox.Active = true
KeyBox.Parent = KeyFrame
GetKey = Instance.new("ImageButton")
GetKey.Size = UDim2.new(0, 235, 0, 26)
GetKey.Position = UDim2.new(0, 6, 0, 219)
GetKey.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
GetKey.Visible = true
GetKey.Parent = Tela6
SetaES = Instance.new("ImageButton")
SetaES.Size = UDim2.new(0, 26, 0, 26)
SetaES.Position = UDim2.new(0, 0, 0, 0)
SetaES.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
SetaES.Parent = GetKey
SetaDI = Instance.new("ImageButton")
SetaDI.Size = UDim2.new(0, 26, 0, 26)
SetaDI.Position = UDim2.new(0, 209, 0, 0)
SetaDI.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
SetaDI.Parent = GetKey
Esquerda = Instance.new("TextLabel")
Esquerda.Size = UDim2.new(0, 20, 0, 20)
Esquerda.Position = UDim2.new(0, 3, 0, 2)
Esquerda.BackgroundTransparency = 1
Esquerda.Text = "<"
Esquerda.TextColor3 = Color3.fromRGB(0, 0, 0)
Esquerda.Font = Enum.Font.SourceSansBold
Esquerda.TextSize = 25
Esquerda.Parent = SetaES
Direita = Instance.new("TextLabel")
Direita.Size = UDim2.new(0, 20, 0, 20)
Direita.Position = UDim2.new(0, 3, 0, 2)
Direita.BackgroundTransparency = 1
Direita.Text = ">"
Direita.TextColor3 = Color3.fromRGB(0, 0, 0)
Direita.Font = Enum.Font.SourceSansBold
Direita.TextSize = 25
Direita.Parent = SetaDI
GetKeyTexto = Instance.new("TextLabel")
GetKeyTexto.Size = UDim2.new(0, 165, 1, 0)
GetKeyTexto.Position = UDim2.new(0, 35, 0, 0)
GetKeyTexto.BackgroundTransparency = 1
GetKeyTexto.Text = Traducao.Link
GetKeyTexto.TextColor3 = Color3.fromRGB(70, 130, 180)
GetKeyTexto.Font = Enum.Font.SourceSansBold
GetKeyTexto.TextScaled = true
GetKeyTexto.Parent = GetKey
ReportFrame = Instance.new("Frame")
ReportFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ReportFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
ReportFrame.Size = UDim2.new(0, 300, 0, 250)
ReportFrame.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
ReportFrame.BorderSizePixel = 0
ReportFrame.Visible = false
ReportFrame.Parent = screenGui
TituloReportFrame = Instance.new("Frame")
TituloReportFrame.Size = UDim2.new(0, 286, 0, 30)
TituloReportFrame.Position = UDim2.new(0, 7, 0, 6)
TituloReportFrame.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
TituloReportFrame.Parent = ReportFrame
TextoTituloReportFrame = Instance.new("TextLabel")
TextoTituloReportFrame.Size = UDim2.new(1, 0, 1, -4)
TextoTituloReportFrame.Position = UDim2.new(0, 0, 0, 2)
TextoTituloReportFrame.BackgroundTransparency = 1
TextoTituloReportFrame.Text = "Report"
TextoTituloReportFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoTituloReportFrame.TextScaled = true
TextoTituloReportFrame.Font = Enum.Font.Highway
TextoTituloReportFrame.Parent = TituloReportFrame
LinhaReport = Instance.new("Frame")
LinhaReport.Size = UDim2.new(1, 0, 0, 5)
LinhaReport.Position = UDim2.new(0, 0, 0, 42)
LinhaReport.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
LinhaReport.BorderSizePixel = 0
LinhaReport.Parent = ReportFrame
TextoReportFrameFrame = Instance.new("Frame")
TextoReportFrameFrame.Size = UDim2.new(0, 286, 0, 135)
TextoReportFrameFrame.Position = UDim2.new(0, 7, 0, 54)
TextoReportFrameFrame.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
TextoReportFrameFrame.Parent = ReportFrame
TextoReportFrame = Instance.new("TextLabel")
TextoReportFrame.Size = UDim2.new(0, 276, 0, 90)
TextoReportFrame.Position = UDim2.new(0, 5, 0, 5)
TextoReportFrame.BackgroundTransparency = 1
TextoReportFrame.Text = ""
TextoReportFrame.TextXAlignment = Enum.TextXAlignment.Left
TextoReportFrame.TextColor3 = Color3.fromRGB(192, 192, 192)
TextoReportFrame.TextScaled = true
TextoReportFrame.Font = Enum.Font.Highway
TextoReportFrame.Parent = TextoReportFrameFrame
LinhaMotivo = Instance.new("Frame")
LinhaMotivo.Size = UDim2.new(1, 0, 0, 2)
LinhaMotivo.Position = UDim2.new(0, 0, 0, 100)
LinhaMotivo.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
LinhaMotivo.BorderSizePixel = 0
LinhaMotivo.Parent = TextoReportFrameFrame
Motivo = Instance.new("Frame")
Motivo.Size = UDim2.new(0, 274, 0, 23)
Motivo.Position = UDim2.new(0, 6, 0, 107)
Motivo.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Motivo.BorderSizePixel = 0
Motivo.Parent = TextoReportFrameFrame
MotivoBox = Instance.new("TextBox")
MotivoBox.Size = UDim2.new(1, -6, 1, -6)
MotivoBox.Position = UDim2.new(0, 3, 0, 3)
MotivoBox.BackgroundTransparency = 1
MotivoBox.Text = ""
MotivoBox.PlaceholderText = Traducao.MotivoReport
MotivoBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MotivoBox.Font = Enum.Font.SourceSansBold
MotivoBox.TextScaled = true
MotivoBox.ClearTextOnFocus = false
MotivoBox.Parent = Motivo
Denunciar = Instance.new("ImageButton")
Denunciar.Size = UDim2.new(0, 100, 0, 30)
Denunciar.Position = UDim2.new(0, 193, 0, 210)
Denunciar.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Denunciar.Active = true
Denunciar.Parent = ReportFrame
FotoReport = Instance.new("ImageLabel")
FotoReport.Size = UDim2.new(0, 40, 0, 40)
FotoReport.Position = UDim2.new(0, 131, 0, 200)
FotoReport.BackgroundTransparency = 1
FotoReport.Image = ""
FotoReport.Parent = ReportFrame
CancelarReport = Instance.new("ImageButton")
CancelarReport.Size = UDim2.new(0, 100, 0, 30)
CancelarReport.Position = UDim2.new(0, 7, 0, 210)
CancelarReport.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
CancelarReport.Active = true
CancelarReport.Parent = ReportFrame
DenunciarTexto = Instance.new("TextLabel")
DenunciarTexto.Size = UDim2.new(1, -6, 1, -6)
DenunciarTexto.Position = UDim2.new(0, 3, 0, 3)
DenunciarTexto.BackgroundTransparency = 1
DenunciarTexto.Text = "Report"
DenunciarTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
DenunciarTexto.TextScaled = true
DenunciarTexto.Parent = Denunciar
CancelarReportTexto = Instance.new("TextLabel")
CancelarReportTexto.Size = UDim2.new(1, -6, 1, -6)
CancelarReportTexto.Position = UDim2.new(0, 3, 0, 3)
CancelarReportTexto.BackgroundTransparency = 1
CancelarReportTexto.Text = Traducao.Cancelar
CancelarReportTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
CancelarReportTexto.TextScaled = true
CancelarReportTexto.Parent = CancelarReport
BlurEffect = Instance.new("BlurEffect")
BlurEffect.Size = 0
BlurEffect.Parent = v3
Warn = Instance.new("Frame")
Warn.AnchorPoint = Vector2.new(0.5, 0.5)
Warn.Position = UDim2.new(0.5, 0, 0.5, 0)
Warn.Size = UDim2.new(0, 300, 0, 250)
Warn.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Warn.BorderSizePixel = 0
Warn.Visible = false
Warn.Parent = screenGui
TituloWarn = Instance.new("Frame")
TituloWarn.Size = UDim2.new(0, 286, 0, 30)
TituloWarn.Position = UDim2.new(0, 7, 0, 6)
TituloWarn.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
TituloWarn.Parent = Warn
TextoTituloWarn = Instance.new("TextLabel")
TextoTituloWarn.Size = UDim2.new(1, 0, 1, -4)
TextoTituloWarn.Position = UDim2.new(0, 0, 0, 2)
TextoTituloWarn.BackgroundTransparency = 1
TextoTituloWarn.Text = Traducao.Aviso
TextoTituloWarn.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoTituloWarn.TextScaled = true
TextoTituloWarn.Font = Enum.Font.Highway
TextoTituloWarn.Parent = TituloWarn
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 5)
Linha.Position = UDim2.new(0, 0, 0, 42)
Linha.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
Linha.BorderSizePixel = 0
Linha.Parent = Warn
TextoWarnFrame = Instance.new("Frame")
TextoWarnFrame.Size = UDim2.new(0, 286, 0, 125)
TextoWarnFrame.Position = UDim2.new(0, 7, 0, 54)
TextoWarnFrame.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
TextoWarnFrame.Parent = Warn
TextoWarn = Instance.new("TextLabel")
TextoWarn.Size = UDim2.new(0, 276, 0, 115)
TextoWarn.Position = UDim2.new(0, 5, 0, 5)
TextoWarn.BackgroundTransparency = 1
TextoWarn.Text = ""
TextoWarn.TextXAlignment = Enum.TextXAlignment.Left
TextoWarn.TextColor3 = Color3.fromRGB(192, 192, 192)
TextoWarn.TextScaled = true
TextoWarn.Font = Enum.Font.Highway
TextoWarn.Parent = TextoWarnFrame
CloseWarn = Instance.new("ImageButton")
CloseWarn.Size = UDim2.new(0, 150, 0, 30)
CloseWarn.AnchorPoint = Vector2.new(0.5, 0.5)
CloseWarn.Position = UDim2.new(0.5, 0, 0, 215)
CloseWarn.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
CloseWarn.BackgroundTransparency = 0
CloseWarn.Parent = Warn
CloseWarnTexto = Instance.new("TextLabel")
CloseWarnTexto.Size = UDim2.new(1, -6, 1, -6)
CloseWarnTexto.Position = UDim2.new(0, 3, 0, 3)
CloseWarnTexto.BackgroundTransparency = 1
CloseWarnTexto.Text = Traducao.FecharAviso
CloseWarnTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseWarnTexto.TextScaled = true
CloseWarnTexto.Parent = CloseWarn

YmpHwid = function()
	return v14
end

YmpClipboard = function(arg)
	if setclipboard_ then
		pcall(function()
			setclipboard_(arg)
		end)
	end
end

YmpRequest = function(...)
	return requestAsync(...)
end

scrolls = { ScrollTodos, ScrollMusicas, ScrollVideos, ScrollRoblox, ScrollFav, ScrollLocal, ScrollPesquisa }

ApiInfo = function(arg)
	local n4 = 0

	while n4 < 8 do
		n4 += 1

		local ok3, result3, result4, result5, result6 = pcall(function()
			local response = game:HttpGet(str3 .. "/info?url=" .. "https://youtu.be/" .. arg)
			local data2 = HttpService:JSONDecode(response)
			return data2.Name, data2.Author, data2.Thumbnail, data2.AuthorUrl
		end)

		if ok3 and result3 then
			return result3, result4, result5, result6
		end
		task.wait(2)
	end

	return nil
end

ApiRoblox = function(arg)
	local n4 = 0

	while n4 < 8 do
		n4 += 1

		local ok3, result3, result4, result5, result6 = pcall(function()
			local response = game:HttpGet(str3 .. "/roblox?assetId=" .. tostring(arg))
			local data2 = HttpService:JSONDecode(response)
			return data2.Name, data2.Creator.Id, data2.Creator.Name, data2.Public
		end)

		if ok3 and result3 then
			return result3, result4, result5, result6
		end
		task.wait(2)
	end

	return nil
end

local flag19 = false
local flag20 = false

processQueue = function()
	if flag7 then
		return
	end
	flag7 = true

	while #tbl7 > 0 do
		table.remove(tbl7, 1)()
	end

	flag7 = false
end

FavoritarFile = function(arg)
	task.spawn(function()
		table.insert(tbl7, function()
			local ok3, result3 = pcall(function()
				return HttpService:JSONDecode(readfile("YouTube Music Player/Internal/Data.json"))
			end)

			local v17 = ok3 and result3
			local tbl12

			if v17 then
				tbl12 = v17
			else
				tbl12 = { { Key = "", Favorites = tbl6 or {} } }
			end

			tbl12[1] = tbl12[1] or { Key = "", Favorites = {} }
			tbl12[1].Favorites = tbl12[1].Favorites or {}
			local favorites = tbl12[1].Favorites

			for _, favorite in ipairs(favorites) do
				if favorite == arg then
					tbl6 = favorites
					return
				end
			end

			table.insert(favorites, arg)
			tbl6 = favorites

			pcall(function()
				writefile("YouTube Music Player/Internal/Data.json", HttpService:JSONEncode(tbl12))
			end)
		end)

		processQueue()
	end)
end

DesfavoritarFile = function(arg)
	task.spawn(function()
		table.insert(tbl7, function()
			local ok3, result3 = pcall(function()
				return HttpService:JSONDecode(readfile("YouTube Music Player/Internal/Data.json"))
			end)

			ok3 = ok3 and result3
			local tbl12

			if ok3 then
				tbl12 = ok3
			else
				tbl12 = { { Key = "", Favorites = tbl6 or {} } }
			end

			tbl12[1] = tbl12[1] or { Key = "", Favorites = {} }
			tbl12[1].Favorites = tbl12[1].Favorites or {}
			local favorites = tbl12[1].Favorites

			for i, favorite in ipairs(favorites) do
				if favorite == arg then
					table.remove(favorites, i)
					break
				end
			end

			tbl6 = favorites

			pcall(function()
				writefile("YouTube Music Player/Internal/Data.json", HttpService:JSONEncode(tbl12))
			end)
		end)

		processQueue()
	end)
end

pcall(function()
	local data2 = HttpService:JSONDecode(readfile("YouTube Music Player/Internal/Data.json"))

	if data2[1] and data2[1].Favorites then
		tbl6 = data2[1].Favorites
	end
end)

local sound2 = Instance.new("Sound")
sound2.Parent = v7
sound2.Looped = false
sound2.Volume = 1
sound2.SoundId = ""
sound2.PlaybackSpeed = 1
Equalizer = Instance.new("EqualizerSoundEffect")
Equalizer.LowGain = 1
Equalizer.MidGain = 1
Equalizer.HighGain = 1
Equalizer.Parent = sound2
VolumesOriginais = {}
MuteCon = nil
Mutado = false

GlobalMute = function(arg)
	pcall(function()
		if arg then
			if Mutado then
				return
			end
			Mutado = true

			local function fn4(arg2)
				pcall(function()
					if not arg2:IsA("Sound") then
						return
					end

					if arg2 == sound2 or arg2 == sound then
						return
					end

					if VolumesOriginais[arg2] == nil then
						VolumesOriginais[arg2] = arg2.Volume
					end

					arg2.Volume = 0
				end)
			end

			for _, descendant in ipairs(game:GetDescendants()) do
				fn4(descendant)
			end

			MuteCon = game.DescendantAdded:Connect(function(descendant)
				if Mutado then
					fn4(descendant)
				end
			end)
		else
			if not Mutado then
				return
			end
			Mutado = false

			if MuteCon then
				MuteCon:Disconnect()
				MuteCon = nil
			end

			for k, v17 in pairs(VolumesOriginais) do
				pcall(function()
					if k and k.Parent and k ~= sound2 then
						k.Volume = v17
					end
				end)
			end

			table.clear(VolumesOriginais)
		end
	end)
end

Mutar.MouseButton1Click:Connect(function()
	if Mutar.Image == "rbxassetid://109518972658686" then
		Mutar.Image = "rbxassetid://139303337799549"
		fn3(Traducao.Mutado, Traducao.SobreMute, 5)
		GlobalMute(true)
	else
		Mutar.Image = "rbxassetid://109518972658686"
		fn3(Traducao.Desmutado, Traducao.SobreUnmute, 5)
		GlobalMute(false)
	end
end)

BibliotecaMusicas = {}
BilbliotecaVideos = {}
BibliotecaRoblox = {}
BibliotecaLocal = {}
Girando = false
Congelado = false
GiroBackup = 1
GiroSpeed = 1

Girar = function(arg)
	if arg then
		Girando = true
		Congelado = false
	else
		Girando = false
		Disco.Rotation = 0
		Congelado = false
	end
end

SetFreeze = function(arg)
	Congelado = arg
end

task.spawn(function()
	while true do
		if Girando and not Congelado and GiroSpeed > 0 then
			local v17 = Disco
			v17.Rotation = v17.Rotation + GiroSpeed
		end

		task.wait(0.02)
	end
end)

formatar = function(arg)
	local n4 = math.floor(arg / 60)
	local n5 = math.floor(arg % 60)
	return string.format("%02d:%02d", n4, n5)
end

Reset = function()
	Rastro.Size = UDim2.new(0, 0, 1, 0)
	BolaProgresso.AnchorPoint = Vector2.new(0, 0.5)
	BolaProgresso.Position = UDim2.new(0, 0, 0.5, 0)
	TimerAtual.Text = "00:00"
end

setProgress = function(arg)
	local n4 = math.clamp(arg, 0, 1)
	Rastro.Size = UDim2.new(n4, 0, 1, 0)
	BolaProgresso.AnchorPoint = Vector2.new(n4, 0.5)
	BolaProgresso.Position = UDim2.new(n4, 0, 0.5, 0)
end

getProgress = function(arg)
	local x = BarraProgresso.AbsolutePosition.X
	local x2 = BarraProgresso.AbsoluteSize.X
	if x2 <= 0 then
		return 0
	end
	return math.clamp((arg - x) / x2, 0, 1)
end

seek = function(arg)
	local v17 = v12
	local flag21 = v12

	if v17 then
		flag21 = v17.TimeLength > 0
	end

	if flag21 then
		TimerAtual.Text = formatar(arg * v17.TimeLength)
	end
end

BarraProgresso.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		local v17 = v12
		local flag21 = v12

		if v17 then
			flag21 = v17.TimeLength > 0
		end

		if flag21 and flag9 then
			flag8 = true
			local v18 = getProgress(input.Position.X)
			setProgress(v18)
			seek(v18)
		end
	end
end)

BolaProgresso.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		local v17 = v12
		local flag21 = v12

		if v17 then
			flag21 = v17.TimeLength > 0
		end

		if flag21 and flag9 then
			flag8 = true
		end
	end
end)

v9.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if flag8 then
			local v17 = v12
			local flag21 = v12

			if v17 then
				flag21 = v17.TimeLength > 0
			end

			if flag21 and flag9 then
				local timeLength = v17.TimeLength
				v17.TimePosition = math.clamp(getProgress(input.Position.X), 0, 0.999) * timeLength
			end

			flag8 = false
		end
	end
end)

v9.InputChanged:Connect(function(input)
	if flag8 then
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local v17 = v12
			local flag21 = v12

			if v17 then
				flag21 = v17.TimeLength > 0
			end

			if flag21 and flag9 then
				local n4 = math.clamp(getProgress(input.Position.X), 0, 0.999)
				setProgress(n4)
				seek(n4)
			end
		end
	end
end)

task.spawn(function()
	while true do
		task.wait(0.1)
		local v17 = v12
		local flag21 = v12

		if v17 then
			flag21 = v17.TimeLength > 0
		end

		if flag21 and not flag8 then
			local timePosition = v17.TimePosition
			setProgress(timePosition / v17.TimeLength)
			TimerAtual.Text = formatar(timePosition)
		end
	end
end)

Equalizador = function(arg)
	if arg == true then
		EquaFrame.Size = UDim2.new(0, 235, 0, 187)
		NoEquaFrame.Visible = false
		ScrollEqua.ScrollingEnabled = true
	else
		EquaFrame.Size = UDim2.new(0, 235, 0, 49)
		NoEquaFrame.Visible = true
		ScrollEqua.CanvasPosition = Vector2.new(0, 0)
		ScrollEqua.ScrollingEnabled = false
	end
end

Selecionar = function(arg, arg2)
	local tbl12 = { ScrollTodos, ScrollMusicas, ScrollVideos, ScrollRoblox, ScrollFav, ScrollLocal, ScrollPesquisa }
	local v17 = nil

	for _, v18 in ipairs(tbl12) do
		for _, child in ipairs(v18:GetChildren()) do
			if child:IsA("ImageButton") then
				local v19 = string.split(child.Name, ":")
				if v19[1] == arg2 and v19[2] == arg then
					v17 = child
					break
				end
			end
		end

		if not v17 then
			continue
		end
		break
	end

	if not v17 then
		return
	end

	local function fn4(arg3)
		local imageLabel = arg3:FindFirstChildOfClass("ImageLabel")
		arg3.BackgroundColor3 = Color3.fromRGB(128, 128, 128)

		if imageLabel then
			Stroke(imageLabel, 50, 50, 50, 2)
		end

		Stroke(arg3, 50, 50, 50, 2)

		for _, child in ipairs(arg3:GetChildren()) do
			if child:IsA("ImageButton") then
				Stroke(child, 50, 50, 50, 2)
			end
		end
	end

	if BotaoSelecionadoAtual == v17 then
		for _, v18 in ipairs(tbl12) do
			for _, child in ipairs(v18:GetChildren()) do
				if child:IsA("ImageButton") then
					fn4(child)
				end
			end
		end

		BotaoSelecionadoAtual = nil
		return
	end

	for _, v18 in ipairs(tbl12) do
		for _, child in ipairs(v18:GetChildren()) do
			if child:IsA("ImageButton") then
				fn4(child)
			end
		end
	end

	local imageLabel = v17:FindFirstChildOfClass("ImageLabel")
	v17.BackgroundColor3 = Color3.fromRGB(128, 128, 128)

	if imageLabel then
		Stroke(imageLabel, 255, 0, 0, 2)
	end

	Stroke(v17, 255, 0, 0, 2)

	for _, child in ipairs(v17:GetChildren()) do
		if child:IsA("ImageButton") then
			Stroke(child, 255, 0, 0, 2)
		end
	end

	BotaoSelecionadoAtual = v17
end

CurrentMediaId = nil
thumbAtual = nil
BloquearMidia = false

resetSound = function(arg)
	if arg then
		pcall(function()
			arg:Stop()
			arg.SoundId = ""
			arg.TimePosition = 0
		end)
	end
end

resetVideo = function(arg)
	if arg then
		pcall(function()
			arg:Pause()
			arg.Video = ""
			arg.TimePosition = 0
		end)
	end
end

local function fn4(arg, arg2)
	if not arg2 or not arg then
		return
	end

	if BloquearMidia then
		fn3(Traducao.Aguarde, Traducao.DownloadFazendo, 5)
		return
	end
	resetSound(sound2)
	resetVideo(Video)
	resetVideo(MiniVideo)
	BloquearMidia = true
	local n4 = math.random()
	CurrentRequestId = n4
	task.wait(0.05)
	CurrentMediaId = arg2
	thumbAtual = nil
	local currentPlaying = arg .. ":" .. arg2
	Selecionar(arg, arg2)
	local visible = imageButton2.Visible

	if _G.CurrentPlaying == currentPlaying then
		_G.CurrentPlaying = nil
		Reset()
		Play.Image = "rbxassetid://110560238983134"
		MiniPlay.Image = "rbxassetid://119936293795425"
		flag9 = false
		Girar(false)
		Equalizador(true)
		GiroSpeed = GiroBackup
		BloquearMidia = false

		if visible then
			Musica.Image = "rbxassetid://109021809317392"
		else
			Musica.Image = "rbxassetid://120329190202259"
		end

		Musica.ImageRectOffset = Vector2.new(0, 0)
		Musica.ImageRectSize = Vector2.new(0, 0)
		MiniMusica.Image = "rbxassetid://120329190202259"
		MiniMusica.ImageRectOffset = Vector2.new(0, 0)
		MiniMusica.ImageRectSize = Vector2.new(0, 0)
		Musica.Visible = true
		MiniMusica.Visible = true
		Video.Visible = false
		MiniVideo.Visible = false
		TimerTotal.Text = "00:00"
		FotoAutor.Image = "rbxassetid://130243480255582"
		TituloMusica.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Hey .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.Play .. "</font>"
		return
	end

	_G.CurrentPlaying = currentPlaying
	Play.Image = "rbxassetid://80704722265943"
	MiniPlay.Image = "rbxassetid://110232191351528"
	flag9 = true

	if sound2 then
		pcall(function()
			sound2:Stop()
			sound2.TimePosition = 0
		end)
	end

	if Video then
		pcall(function()
			Video:Pause()
			Video.TimePosition = 0
		end)
	end

	if MiniVideo then
		pcall(function()
			MiniVideo:Pause()
			MiniVideo.TimePosition = 0
		end)
	end

	local function fn5(arg3)
		v12 = arg3 and (visible and MiniVideo or Video) or sound2
		Musica.Visible = true
		MiniMusica.Visible = true
		Video.Visible = arg3 and not visible
		MiniVideo.Visible = arg3 and visible
	end

	local function fn6(arg3, arg4)
		return "<font color=\"rgb(255,255,255)\">" .. arg3 .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.De .. " " .. arg4 .. "</font>"
	end

	local function fn7(arg3)
		local n5 = math.floor(arg3 or 0)
		return string.format("%02d:%02d", math.floor(n5 / 60), n5 % 60)
	end

	local function fn8(arg3)
		local ok3, result3 = pcall(function()
			return getcustomasset(arg3)
		end)

		if ok3 and typeof(result3) == "string" then
			return result3
		end
		return nil
	end

	local function fn9(arg3, arg4)
		local str6 = "YouTube Music Player/Internal/Cache/" .. arg4 .. ".png"
		if isfile(str6) then
			return fn8(str6)
		end

		local ok3 = pcall(function()
			local response = game:HttpGet(arg3)
			if not response or typeof(response) ~= "string" or #response < 50 then
				return
			end
			writefile(str6, response)
		end)

		task.wait(0.08)
		if not ok3 or not isfile(str6) then
			return nil
		end
		return fn8(str6)
	end

	local function fn10()
		if arg == "Musica" then
			for _, v17 in ipairs(BibliotecaMusicas) do
				if v17.id == arg2 then
					return v17
				end
			end
		elseif arg == "Video" then
			for _, v17 in ipairs(BilbliotecaVideos) do
				if v17.id == arg2 then
					return v17
				end
			end
		elseif arg == "Roblox" then
			for _, v17 in ipairs(BibliotecaRoblox) do
				if v17.id == arg2 then
					return v17
				end
			end
		elseif arg == "Local" then
			for _, v17 in ipairs(BibliotecaLocal) do
				if v17.name == arg2 then
					return v17
				end
			end
		end
	end

	local v17 = fn10()
	if not v17 then
		return
	end
	TimerTotal.Text = "00:00"
	Girar(true)

	if arg == "Musica" or arg == "Video" then
		fn5(arg == "Video")
		local v18 = visible and MiniMusica or Musica
		v18.Image = "rbxassetid://108154884074176"
		v18.ImageRectOffset = Vector2.new(0, 0)
		v18.ImageRectSize = Vector2.new(0, 0)
		FotoAutor.Image = "rbxassetid://108154884074176"
		TituloMusica.Text = fn6(v17.name, v17.author)

		task.spawn(function()
			task.wait(0.05)
			if CurrentRequestId ~= n4 then
				return
			end
			local authorUrl = v17.authorUrl and fn9(v17.authorUrl, "author_" .. arg2)
			if CurrentRequestId ~= n4 then
				return
			end
			FotoAutor.Image = authorUrl or "rbxassetid://106804518898726"

			if arg == "Musica" and v17.thumb then
				local v19 = fn9(v17.thumb, "thumb_" .. arg2)
				if CurrentRequestId ~= n4 then
					return
				end

				if v19 then
					v18.Image = v19
					thumbAtual = v19
					v18.ImageRectOffset = Vector2.new(0, 45)
					v18.ImageRectSize = Vector2.new(480, 270)
				else
					v18.Image = "rbxassetid://110787075859454"
					v18.ImageRectOffset = Vector2.new(0, 0)
					v18.ImageRectSize = Vector2.new(0, 0)
				end
			end

			BloquearMidia = false
		end)

		if arg == "Musica" then
			pcall(function()
				sound2.SoundId = getcustomasset("YouTube Music Player/Musics/" .. arg2 .. ".mp3")
				sound2:Play()
				Equalizador(true)
				GiroSpeed = GiroBackup

				task.spawn(function()
					local n5 = 0

					while sound2.TimeLength == 0 and n5 < 5 do
						n5 += task.wait(0.1)
					end

					if CurrentRequestId ~= n4 then
						return
					end
					TimerTotal.Text = fn7(sound2.TimeLength)
				end)
			end)
		else
			pcall(function()
				local v19 = getcustomasset("YouTube Music Player/Videos/" .. arg2 .. ".webm")
				local v20 = visible and MiniVideo or Video
				v20.Video = v19
				v20:Play()
				Equalizador(false)
				GiroSpeed = 1

				task.spawn(function()
					local n5 = 0

					while v20.TimeLength == 0 and n5 < 5 do
						n5 += task.wait(0.1)
					end

					if CurrentRequestId ~= n4 then
						return
					end
					TimerTotal.Text = fn7(v20.TimeLength)
				end)
			end)
		end
	elseif arg == "Roblox" then
		fn5(false)
		local v18 = visible and MiniMusica or Musica
		v18.Image = "rbxassetid://100415102639682"
		v18.ImageRectOffset = Vector2.new(0, 0)
		v18.ImageRectSize = Vector2.new(0, 0)
		TituloMusica.Text = "<font color=\"rgb(255,255,255)\">" .. v17.name .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.De .. " " .. v17.creatorName .. "</font>"
		FotoAutor.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. v17.creatorId .. "&width=420&height=420&format=png"

		pcall(function()
			sound2.SoundId = "rbxassetid://" .. arg2
			sound2:Play()
			Equalizador(true)
			GiroSpeed = GiroBackup

			task.spawn(function()
				local n5 = 0

				while sound2.TimeLength == 0 and n5 < 5 do
					n5 += task.wait(0.1)
				end

				if CurrentRequestId ~= n4 then
					return
				end
				TimerTotal.Text = fn7(sound2.TimeLength)
			end)
		end)

		BloquearMidia = false
	elseif arg == "Local" then
		fn5(false)
		local v18 = visible and MiniMusica or Musica
		v18.Image = "rbxassetid://84131152943912"
		v18.ImageRectOffset = Vector2.new(0, 0)
		v18.ImageRectSize = Vector2.new(0, 0)
		TituloMusica.Text = "<font color=\"rgb(255,255,255)\">" .. arg2 .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.In .. " " .. Traducao.LocalTitle .. "</font>"
		FotoAutor.Image = "rbxassetid://99316239950686"

		pcall(function()
			sound2.SoundId = getcustomasset("YouTube Music Player/Local Audios/" .. arg2 .. ".mp3")
			sound2:Play()
			Equalizador(true)
			GiroSpeed = GiroBackup

			task.spawn(function()
				local n5 = 0

				while sound2.TimeLength == 0 and n5 < 5 do
					n5 += task.wait(0.1)
				end

				if CurrentRequestId ~= n4 then
					return
				end
				TimerTotal.Text = fn7(sound2.TimeLength)
			end)
		end)

		BloquearMidia = false
	end
end

SetMiniPlayer = function(visible)
	imageButton2.Visible = visible

	local function fn5(arg)
		if arg then
			pcall(function()
				arg:Pause()
				arg:Stop()
				arg.Video = nil
			end)
		end
	end

	local function fn6(arg)
		local v17 = nil

		pcall(function()
			v17 = getcustomasset(arg)
		end)

		return v17
	end

	local function fn7(arg, arg2)
		if not arg then
			return
		end

		if arg2 then
			arg.ImageRectOffset = Vector2.new(0, 45)
			arg.ImageRectSize = Vector2.new(480, 270)
		else
			arg.ImageRectOffset = Vector2.new(0, 0)
			arg.ImageRectSize = Vector2.new(0, 0)
		end
	end

	local function fn8(arg)
		if arg == "rbxassetid://108154884074176" then
			return "loading"
		end

		if arg == "rbxassetid://110787075859454" then
			return "empty"
		end

		if arg == "rbxassetid://84131152943912" then
			return "special"
		end

		if arg == "rbxassetid://109021809317392" then
			return "mini"
		end

		if arg == "rbxassetid://100415102639682" then
			return "roblox"
		end
		return "default"
	end

	local function fn9(arg, arg2)
		if arg2 == "loading" then
			arg.Image = "rbxassetid://108154884074176"
			fn7(arg, false)
		elseif arg2 == "empty" then
			arg.Image = "rbxassetid://110787075859454"
			fn7(arg, false)
		elseif arg2 == "special" then
			arg.Image = "rbxassetid://84131152943912"
			fn7(arg, false)
		elseif arg2 == "mini" then
			arg.Image = "rbxassetid://109021809317392"
			fn7(arg, false)
		elseif arg2 == "roblox" then
			arg.Image = "rbxassetid://100415102639682"
			fn7(arg, false)
		else
			arg.Image = "rbxassetid://120329190202259"
			fn7(arg, false)
		end
	end

	if visible then
		if Musica then
			Musica.Visible = true
			local v17 = fn8(Musica.Image)
			fn9(MiniMusica, v17)
			Musica.Image = "rbxassetid://109021809317392"
			fn7(Musica, false)
		end

		if MiniMusica then
			MiniMusica.Visible = true

			if thumbAtual then
				MiniMusica.Image = thumbAtual
				fn7(MiniMusica, true)
				Musica.Image = "rbxassetid://109021809317392"
				fn7(Musica, false)
			end
		end

		if Video and Video.Visible then
			local timePosition = Video.TimePosition
			local v17 = fn6("YouTube Music Player/Videos/" .. CurrentMediaId .. ".webm")
			fn5(Video)

			if MiniVideo and v17 then
				fn5(MiniVideo)
				MiniVideo.Visible = true
				MiniVideo.Video = v17
				MiniVideo.TimePosition = timePosition
				MiniVideo:Play()
				v12 = MiniVideo
				Play.Image = "rbxassetid://80704722265943"
				MiniPlay.Image = "rbxassetid://110232191351528"
			end

			Video.Visible = false
		elseif MiniVideo and MiniVideo.Visible then
			Video.Visible = false
		end
	else
		if MiniVideo and MiniVideo.Visible then
			local timePosition = MiniVideo.TimePosition
			local v17 = fn6("YouTube Music Player/Videos/" .. CurrentMediaId .. ".webm")
			fn5(MiniVideo)

			if Video and v17 then
				fn5(Video)
				Video.Visible = true
				Video.Video = v17
				Video.TimePosition = timePosition
				Video:Play()
				v12 = Video
				Play.Image = "rbxassetid://80704722265943"
				MiniPlay.Image = "rbxassetid://110232191351528"
			end
		end

		if Musica then
			Musica.Visible = true

			if MiniMusica then
				MiniMusica.Visible = true
			end

			if MiniMusica then
				local v17 = fn8(MiniMusica.Image)
				fn9(Musica, v17)

				if thumbAtual then
					Musica.Image = thumbAtual
					fn7(Musica, true)
				end
			end
		end
	end
end

SortMedia = function(arg, arg2)
	local attribute = arg:GetAttribute("Build")
	local attribute2 = arg2:GetAttribute("Build")
	if attribute and not attribute2 then
		return true
	end

	if attribute2 and not attribute then
		return false
	end
	local tag = arg:FindFirstChild("tag")
	local tag2 = arg2:FindFirstChild("tag")

	if tag then
		tag = tag.Text:match("^%s*(.-)%s*$"):lower()
	end

	tag = tag or ""

	if tag2 then
		tag2 = tag2.Text:match("^%s*(.-)%s*$"):lower()
	end

	return tag < (tag2 or "")
end

GetScrollAtual = function()
	for _, v17 in ipairs(scrolls) do
		if v17.Visible then
			return v17
		end
	end
end

GetLista = function(arg)
	local tbl12 = {}

	for _, child in ipairs(arg:GetChildren()) do
		if child:IsA("ImageButton") then
			if not child:GetAttribute("Privado") then
				local match, v17 = child.Name:match("(.+):(.+)")

				if match and v17 then
					if not ((v17 == "Video" or v17 == "Roblox") and not flag19) then
						table.insert(tbl12, child)
					end
				end
			end
		end
	end

	table.sort(tbl12, SortMedia)
	return tbl12
end

GetSelecionado = function(arg)
	for _, v17 in ipairs(arg) do
		if v17.BackgroundColor3 == Color3.fromRGB(139, 0, 0) then
			return v17
		end
	end
end

PlayBtn = function(arg)
	local match, v17 = arg.Name:match("(.+):(.+)")

	if match and v17 then
		fn4(v17, match)
	end
end

Pause = function()
	if not v12 or not flag9 then
		return
	end

	if v12:IsA("Sound") then
		if v12.Playing then
			v12:Pause()
			Play.Image = "rbxassetid://110560238983134"
			MiniPlay.Image = "rbxassetid://119936293795425"
			SetFreeze(true)
		else
			v12:Resume()
			Play.Image = "rbxassetid://80704722265943"
			MiniPlay.Image = "rbxassetid://110232191351528"
			SetFreeze(false)
		end
	elseif v12:IsA("VideoFrame") then
		if v12.Playing then
			v12:Pause()
			Play.Image = "rbxassetid://110560238983134"
			MiniPlay.Image = "rbxassetid://119936293795425"
			SetFreeze(true)
		else
			v12:Play()
			Play.Image = "rbxassetid://80704722265943"
			MiniPlay.Image = "rbxassetid://110232191351528"
			SetFreeze(false)
		end
	end
end

Avancar10s = function()
	if not v12 or not flag9 then
		return
	end
	local v17 = v12
	if v17.TimeLength <= 0 then
		return
	end
	local timePosition = v17.TimePosition + 10

	if v17.TimeLength < timePosition then
		timePosition = v17.TimeLength
	end

	v17.TimePosition = timePosition
end

Retroceder10s = function()
	if not v12 or not flag9 then
		return
	end
	local v17 = v12
	if v17.TimeLength <= 0 then
		return
	end
	local timePosition = v17.TimePosition - 10

	if timePosition < 0 then
		timePosition = 0
	end

	v17.TimePosition = timePosition
end

Skip = function()
	local v17 = GetScrollAtual()
	if not v17 then
		fn3(Traducao.Erro, Traducao.NenhumaMidia, 5)
		return
	end
	local v18 = GetLista(v17)
	if #v18 == 0 then
		fn3(Traducao.Erro, Traducao.NenhumaMidia, 5)
		return
	end

	if #v18 == 1 then
		if v18[1].BackgroundColor3 ~= Color3.fromRGB(139, 0, 0) then
			PlayBtn(v18[1])
		end

		return
	end

	local v19 = GetSelecionado(v18)
	if not v19 then
		PlayBtn(v18[1])
		return
	end
	local v20 = nil

	for i, v21 in ipairs(v18) do
		if v21 == v19 then
			v20 = i
			break
		else
			v20 = nil
		end
	end

	local n4 = v20 + 1

	if n4 > #v18 then
		n4 = 1
	end

	PlayBtn(v18[n4])
end

Back = function()
	local v17 = GetScrollAtual()
	if not v17 then
		fn3(Traducao.Erro, Traducao.NenhumaMidia, 5)
		return
	end
	local v18 = GetLista(v17)
	if #v18 == 0 then
		fn3(Traducao.Erro, Traducao.NenhumaMidia, 5)
		return
	end

	if #v18 == 1 then
		if v18[1].BackgroundColor3 ~= Color3.fromRGB(139, 0, 0) then
			PlayBtn(v18[1])
		end

		return
	end

	local v19 = GetSelecionado(v18)
	if not v19 then
		PlayBtn(v18[1])
		return
	end
	local v20 = nil

	for i, v21 in ipairs(v18) do
		if v21 == v19 then
			v20 = i
			break
		else
			v20 = nil
		end
	end

	local n4 = v20 - 1

	if n4 < 1 then
		n4 = #v18
	end

	PlayBtn(v18[n4])
end

EscolherRandom = function(arg)
	local tbl12 = {}
	local v17 = GetSelecionado(arg)

	for _, v18 in ipairs(arg) do
		if v18 ~= v17 and not tbl5[v18] then
			table.insert(tbl12, v18)
		end
	end

	if #tbl12 == 0 then
		tbl5 = {}

		for _, v18 in ipairs(arg) do
			if v18 ~= v17 then
				table.insert(tbl12, v18)
			end
		end
	end

	if #tbl12 == 0 then
		return v17
	end
	local v18 = tbl12[math.random(1, #tbl12)]
	tbl5[v18] = true
	return v18
end

HandleEnded = function(arg)
	if str4 == "nill" then
		return
	end
	task.wait()
	arg.Looped = false
	local v17 = GetScrollAtual()

	if v17 ~= v11 then
		tbl5 = {}
		v11 = v17
	end

	if not v17 then
		fn3(Traducao.PlayMode, Traducao.PlayModeRepetir, 5)
		v12.TimePosition = 0
		v12:Play()
		return
	end

	local v18 = GetLista(v17)

	if #v18 == 0 then
		fn3(Traducao.PlayMode, Traducao.PlayModeRepetir, 5)
		v12.TimePosition = 0
		v12:Play()
		return
	end

	local v19 = GetSelecionado(v18)

	if v19 then
		tbl5[v19] = true
	end

	if #v18 == 1 then
		if not v19 then
			PlayBtn(v18[1])
		else
			fn3(Traducao.PlayMode, Traducao.PlayModeRepetir, 5)
			v12.TimePosition = 0
			v12:Play()
		end

		return
	end

	if str4 == "Random" then
		local v20 = EscolherRandom(v18)

		if v20 then
			PlayBtn(v20)
		end

		return
	end

	Skip()
end

sound2.Ended:Connect(function()
	HandleEnded(sound2)
end)

Video.Ended:Connect(function()
	if Video and Video.Visible then
		HandleEnded(Video)
	end
end)

MiniVideo.Ended:Connect(function()
	if MiniVideo and MiniVideo.Visible then
		HandleEnded(MiniVideo)
	end
end)

Deletar = function(arg, arg2)
	if BloquearMidia then
		fn3(Traducao.Aguarde, Traducao.DownloadFazendo, 5)
		return
	end

	if _G.CurrentPlaying then
		local match, v17 = _G.CurrentPlaying:match("^(.-)%:(.+)$")

		if v17 == arg then
			fn4(match, v17)
		end
	end

	local tbl12 = {
		"YouTube Music Player/Internal/Cache/author_" .. arg .. ".png",
		"YouTube Music Player/Internal/Cache/thumb_" .. arg .. ".png",
	}

	for _, v17 in ipairs({
		"YouTube Music Player/Musics/" .. arg .. ".mp3",
		"YouTube Music Player/Videos/" .. arg .. ".webm",
		"YouTube Music Player/Roblox IDS/" .. arg .. ".rbx",
		"YouTube Music Player/Local Audios/" .. arg .. ".mp3",
	}) do
		if isfile(v17) then
			delfile(v17)
		end
	end

	for _, v17 in ipairs(tbl12) do
		if isfile(v17) then
			delfile(v17)
		end
	end

	for i = #BibliotecaMusicas, 1, -1 do
		if BibliotecaMusicas[i].id == arg then
			table.remove(BibliotecaMusicas, i)
		end
	end

	for i = #BilbliotecaVideos, 1, -1 do
		if BilbliotecaVideos[i].id == arg then
			table.remove(BilbliotecaVideos, i)
		end
	end

	for i = #BibliotecaRoblox, 1, -1 do
		if BibliotecaRoblox[i].id == arg then
			table.remove(BibliotecaRoblox, i)
		end
	end

	for i = #BibliotecaLocal, 1, -1 do
		if BibliotecaLocal[i].name == arg then
			table.remove(BibliotecaLocal, i)
		end
	end

	DesfavoritarFile(arg)
	fn3(Traducao.Excluido, arg2, 8)

	local function fn5(arg3)
		for _, child in ipairs(arg3:GetChildren()) do
			local name = child:IsA("ImageButton") and child.Name and arg

			if name then
				local str6 = arg .. ":"
				name = child.Name:sub(1, #arg + 1) == str6
			end

			if name then
				child:Destroy()
			end
		end
	end

	task.wait(0.1)
	fn5(ScrollTodos)
	fn5(ScrollMusicas)
	fn5(ScrollVideos)
	fn5(ScrollRoblox)
	fn5(ScrollLocal)
	fn5(ScrollFav)
	fn5(ScrollPesquisa)
end

-- https://discord.gg/AwGHNh7Z7T
local function fn5(text2, arg, arg2, arg3)
	local tbl12 = {}
	local imageButton3 = Instance.new("ImageButton")
	imageButton3.Name = arg2 .. ":" .. arg
	imageButton3.Size = UDim2.new(0, 148, 0, 35)
	imageButton3.Position = UDim2.new(0, 5, 0, 5)
	imageButton3.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
	imageButton3.BackgroundTransparency = 0
	imageButton3.AutoButtonColor = false
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = UDim2.new(0, 35, 0, 35)
	imageLabel.Position = UDim2.new(0, 0, 0, 0)
	imageLabel.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
	imageLabel.BackgroundTransparency = 0
	local v17 = ScrollTodos
	local v18

	if arg == "Musica" then
		imageLabel.Image = "rbxassetid://136933987460149"

		if str2 == "Musicas" then
			v18 = ScrollMusicas
		else
			v18 = v17
		end
	elseif arg == "Video" then
		imageLabel.Image = "rbxassetid://105308603886068"

		if str2 == "Videos" then
			v18 = ScrollVideos
		else
			v18 = v17
		end
	elseif arg == "Roblox" then
		imageLabel.Image = "rbxassetid://118724747640040"

		if str2 ~= "Roblox" then
			v18 = v17
		else
			v18 = ScrollRoblox
		end
	elseif arg == "Local" then
		imageLabel.Image = "rbxassetid://93635917640466"

		if str2 ~= "Local" then
			v18 = v17
		else
			v18 = ScrollLocal
		end
	else
		v18 = v17
	end

	imageButton3.Parent = v18
	imageLabel.Parent = imageButton3
	imageLabel.ImageTransparency = 0
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(0, 107, 1, 0)
	textLabel.Position = UDim2.new(0, 38, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextScaled = true
	textLabel.TextWrapped = true
	textLabel.Name = "tag"
	textLabel.Text = text2
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.Parent = imageButton3
	local imageButton4 = Instance.new("ImageButton")
	imageButton4.Size = UDim2.new(0, 35, 0, 35)
	imageButton4.Position = UDim2.new(1, 8, 0, 0)
	imageButton4.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
	imageButton4.Parent = imageButton3
	local v19 = ipairs
	local v20 = tbl6
	local tbl13

	if tbl6 then
		tbl13 = v20
	else
		tbl13 = {}
	end

	local flag21 = false

	for _, v21 in v19(tbl13) do
		if v21 == arg2 then
			flag21 = true
			break
		end
	end

	if flag21 then
		imageButton4.Image = "rbxassetid://122765197997575"
	else
		imageButton4.Image = "rbxassetid://102097543764342"
	end

	local imageButton5 = Instance.new("ImageButton")
	imageButton5.Size = UDim2.new(0, 35, 0, 35)
	imageButton5.Position = UDim2.new(1, 51, 0, 0)
	imageButton5.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
	imageButton5.BackgroundTransparency = 0
	imageButton5.Image = "rbxassetid://125370105968945"
	imageButton5.Parent = imageButton3

	if arg2 == "LvvrO6JifEA" then
		imageButton5.ImageTransparency = 0.8
		imageButton5.Active = false
		imageButton3:SetAttribute("Build", true)
	end

	Corner(imageButton3, 5)
	Corner(imageLabel, 5)
	Corner(imageButton4, 5)
	Corner(imageButton5, 5)
	Stroke(imageButton3, 50, 50, 50, 2)
	Stroke(imageLabel, 50, 50, 50, 2)
	Stroke(imageButton4, 50, 50, 50, 2)
	Stroke(imageButton5, 50, 50, 50, 2)

	if arg == "Roblox" and arg3 == false then
		imageButton3:SetAttribute("Privado", true)
		imageButton3.BackgroundTransparency = 0.9
		imageLabel.BackgroundTransparency = 0.9
		imageLabel.ImageTransparency = 0.9
		textLabel.TextColor3 = Color3.fromRGB(20, 20, 20)
	end

	if (arg == "Video" or arg == "Roblox") and not flag19 then
		imageButton3.BackgroundTransparency = 0.9
		imageLabel.BackgroundTransparency = 0.9
		imageLabel.ImageTransparency = 0.9
		textLabel.TextColor3 = Color3.fromRGB(20, 20, 20)
	end

	tbl12[#tbl12 + 1] = imageButton3.MouseButton1Click:Connect(function()
		if arg == "Roblox" and arg3 == false then
			fn3(Traducao.Erro, Traducao.Privado, 10)
			return
		end

		if (arg == "Video" or arg == "Roblox") and not flag19 then
			fn3(Traducao.OpcaoBloqueadaTitle, Traducao.OpcaoBloqueadaText, 10)
		else
			fn4(arg, arg2)
		end
	end)

	tbl12[#tbl12 + 1] = imageButton4.MouseButton1Click:Connect(function()
		if imageButton4.Image == "rbxassetid://122765197997575" then
			imageButton4.Image = "rbxassetid://102097543764342"
			fn3(Traducao.Desfavoritado, text2, 8)
			DesfavoritarFile(arg2)

			if str2 == "Favoritos" then
				local v21 = ScrollTodos

				if arg == "Musica" then
					v21 = ScrollMusicas
				elseif arg == "Video" then
					v21 = ScrollVideos
				elseif arg == "Roblox" then
					v21 = ScrollRoblox
				end

				if imageButton3.Parent ~= v21 then
					imageButton3.Parent = v21
				end
			end
		else
			imageButton4.Image = "rbxassetid://122765197997575"
			fn3(Traducao.Favoritado, text2, 8)
			FavoritarFile(arg2)
		end
	end)

	tbl12[#tbl12 + 1] = imageButton5.MouseButton1Click:Connect(function()
		if not imageButton5.Active then
			return
		end
		Deletar(arg2, textLabel.Text)
	end)

	imageButton3.Destroying:Connect(function()
		for _, v21 in ipairs(tbl12) do
			pcall(function()
				v21:Disconnect()
			end)
		end

		tbl12 = {}
	end)
end

Parent = function(arg)
	local tbl12 = {}

	local v17 = ({
		Musica = ScrollMusicas,
		Video = ScrollVideos,
		Roblox = ScrollRoblox,
		Local = ScrollLocal,
		Todos = ScrollTodos,
		Favoritos = ScrollFav,
	})[arg]

	if not v17 then
		return
	end

	for i = 1, #scrolls do
		local children = scrolls[i]:GetChildren()

		for i2 = 1, #children do
			local v18 = children[i2]

			if v18:IsA("GuiObject") then
				tbl12[#tbl12 + 1] = v18
			end
		end
	end

	if arg == "Todos" then
		for i = 1, #tbl12 do
			tbl12[i].Parent = v17
		end
	elseif arg == "Favoritos" then
		local v18 = tbl6

		for i = 1, #tbl12 do
			local v19 = tbl12[i]
			local match = v19.Name:match("^(.-):")

			if table.find(v18, match) then
				v19.Parent = v17
			end
		end
	else
		for i = 1, #tbl12 do
			local v18 = tbl12[i]
			local match, v19 = v18.Name:match("^(.-):(.+)$")

			if v19 == arg then
				v18.Parent = v17
			end
		end
	end

	v17.CanvasPosition = Vector2.zero
end

AtualizarScroll = function(arg)
	if arg == ScrollLocal and #arg:GetChildren() == 0 then
		arg.Visible = false
		VazioLocal.Visible = true
		ErroPL.Visible = true
		ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.LocalTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.LocalText .. "</font>"
		SemResultadoPL.Visible = false
		AguardandoPL.Visible = false
		Vazio.Visible = false
		return
	end

	if #arg:GetChildren() > 0 then
		arg.Visible = true
		Vazio.Visible = false
		VazioLocal.Visible = false
		ErroPL.Visible = false
		SemResultadoPL.Visible = false
		AguardandoPL.Visible = false
	else
		arg.Visible = false
		Vazio.Visible = true
		ErroPL.Visible = true
		ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Vazio .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.VazioTexto .. "</font>"
		SemResultadoPL.Visible = false
		AguardandoPL.Visible = false
		VazioLocal.Visible = false
	end
end

Abas = {
	Todos = {
		parent = "Todos",
		text = function()
			return Traducao.Todos
		end,
		scroll = ScrollTodos,
	},
	Musicas = {
		parent = "Musica",
		text = function()
			return Traducao.Musicas
		end,
		scroll = ScrollMusicas,
	},
	Videos = {
		parent = "Video",
		text = function()
			return "Videos"
		end,
		scroll = ScrollVideos,
	},
	Roblox = {
		parent = "Roblox",
		text = function()
			return "Roblox IDS"
		end,
		scroll = ScrollRoblox,
	},
	Favoritos = {
		parent = "Favoritos",
		text = function()
			return Traducao.Favoritos
		end,
		scroll = ScrollFav,
	},
	Local = {
		parent = "Local",
		text = function()
			return Traducao.LocalTitle
		end,
		scroll = ScrollLocal,
	},
}

Ordem = { "Todos", "Musicas", "Videos", "Roblox", "Favoritos", "Local", "Pesquisar" }

OcultarScrolls = function()
	ScrollTodos.Visible = false
	ScrollMusicas.Visible = false
	ScrollVideos.Visible = false
	ScrollRoblox.Visible = false
	ScrollFav.Visible = false
	ScrollLocal.Visible = false
	ScrollPesquisa.Visible = false
end

ToTab = function(arg)
	str2 = arg
	OcultarScrolls()

	if arg == "Pesquisar" then
		AbaPL.Visible = false
		PesquisaPL.Visible = true
		AguardandoPL.Visible = true
		Vazio.Visible = false
		ErroPL.Visible = true
		PesquisaPL.Text = ""
		VazioLocal.Visible = false
		ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.PesquiseTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.PesquiseTextPL .. "</font>"
		return
	end

	local v17 = Abas[arg]
	if not v17 then
		return
	end
	Parent(v17.parent)
	AbaPL.Text = v17.text()
	AbaPL.Visible = true
	PesquisaPL.Visible = false
	AtualizarScroll(v17.scroll)
end

ProximaAba = function(arg)
	local v17 = nil

	for i, v18 in ipairs(Ordem) do
		if v18 == str2 then
			v17 = i
			break
		else
			v17 = nil
		end
	end

	if not v17 then
		return
	end
	local n4 = v17 + arg

	if #Ordem < n4 then
		n4 = 1
	end

	if n4 < 1 then
		n4 = #Ordem
	end

	return Ordem[n4]
end

DireitaPL.MouseButton1Click:Connect(function()
	fn2("88442833509532")
	ToTab(ProximaAba(1))
end)

EsquerdaPL.MouseButton1Click:Connect(function()
	fn2("88442833509532")
	ToTab(ProximaAba(-1))
end)

OrganizarSF = function(arg)
	task.wait()
	local tbl12 = {}

	for _, child in ipairs(arg:GetChildren()) do
		if child:IsA("GuiObject") then
			table.insert(tbl12, child)
		end
	end

	table.sort(tbl12, SortMedia)
	local n4 = 5

	for _, v17 in ipairs(tbl12) do
		v17.Position = UDim2.new(0, 5, 0, n4)
		n4 = n4 + v17.Size.Y.Offset + 10
	end

	arg.CanvasSize = UDim2.new(0, 243, 0, math.max(n4 - 6, 0))
end

Pesquisando = false

PesquisarPL = function(arg)
	local tbl12 = { ScrollTodos, ScrollMusicas, ScrollVideos, ScrollRoblox, ScrollFav, ScrollLocal }
	ScrollPesquisa.CanvasPosition = Vector2.new(0, 0)
	Pesquisando = true

	for _, child in ipairs(ScrollPesquisa:GetChildren()) do
		if child:IsA("ImageButton") then
			child.Parent = ScrollTodos
		end
	end

	Pesquisando = false

	if not arg or arg:match("^%s*$") then
		ScrollPesquisa.Visible = false
		SemResultadoPL.Visible = false
		AguardandoPL.Visible = true
		ErroPL.Visible = true
		ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.PesquiseTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.PesquiseTextPL .. "</font>"
		return
	end

	local str6 = arg:lower()
	local visible = false

	for _, v17 in ipairs(tbl12) do
		for _, child in ipairs(v17:GetChildren()) do
			if child:IsA("GuiObject") then
				local tag = child:FindFirstChild("tag")

				if tag and tag.Text then
					if string.find(tag.Text:lower(), str6, 1, true) then
						child.Parent = ScrollPesquisa
						visible = true
					end
				end
			end
		end
	end

	ScrollPesquisa.Visible = visible
	AguardandoPL.Visible = false
	local visible2 = not visible
	SemResultadoPL.Visible = visible2
	ErroPL.Visible = visible2

	if visible2 then
		ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.SemResutadoTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.SemResutadoTextPL .. "</font>"
	end
end

Scrolls = {
	Todos = ScrollTodos,
	Musicas = ScrollMusicas,
	Videos = ScrollVideos,
	Roblox = ScrollRoblox,
	Favoritos = ScrollFav,
	Local = ScrollLocal,
}

ConectarScroll = function(arg, arg2)
	arg2.ChildAdded:Connect(function()
		OrganizarSF(arg2)

		if str2 == arg then
			AtualizarScroll(arg2)
		end
	end)

	arg2.ChildRemoved:Connect(function()
		OrganizarSF(arg2)

		if str2 == arg then
			AtualizarScroll(arg2)
		end
	end)
end

for k, v17 in pairs(Scrolls) do
	ConectarScroll(k, v17)
end

ScrollPesquisa.ChildAdded:Connect(function()
	OrganizarSF(ScrollPesquisa)
end)

ScrollPesquisa.ChildRemoved:Connect(function()
	if ScrollPesquisa.Visible and not Pesquisando then
		PesquisarPL(PesquisaPL.Text)
	end
end)

PesquisaPL.Focused:Connect(function()
	PesquisarPL()
end)

PesquisaPL.FocusLost:Connect(function()
	local match = PesquisaPL.Text:match("^%s*(.-)%s*$")
	PesquisaPL.Text = match

	if match ~= "" then
		PesquisarPL(match)
	end
end)

FixNome = function()
	local str6 = "YouTube Music Player/Local Audios"

	for _, v17 in ipairs(listfiles("YouTube Music Player/Local Audios")) do
		pcall(function()
			local match = v17:match("[^/\\]+$")

			if match and match:sub(-4) == ".mp3" then
				local str7 = match:sub(1, -5)

				if #str7 > 90 then
					local str8 = str6 .. "/" .. str7:sub(1, 80) .. "_" .. tostring(math.random(10000, 99999)) .. ".mp3"

					if not isfile(str8) then
						local v18 = readfile(v17)
						writefile(str8, v18)
						delfile(v17)
						local n4 = 0

						while isfile(v17) and n4 < 50 do
							task.wait()
							n4 += 1
						end
					end
				end
			end
		end)
	end
end

UpdatePlaylist = function()
	task.spawn(function()
		local tbl12 = {
			Musics = "YouTube Music Player/Musics",
			Videos = "YouTube Music Player/Videos",
			Roblox = "YouTube Music Player/Roblox IDS",
			Local = "YouTube Music Player/Local Audios",
		}

		FixNome()

		for _, v17 in pairs(tbl12) do
			if not isfolder(v17) then
				makefolder(v17)
			end
		end

		local function fn6(arg)
			local ok3, result3 = pcall(listfiles, arg)
			return ok3 and result3 or {}
		end

		local function fn7(arg)
			return arg:match("[^/\\]+$")
		end

		local function fn8(arg, arg2)
			return arg:gsub(arg2:gsub("%.", "%%."), "")
		end

		local tbl13 = { Musics = {}, Videos = {}, Roblox = {}, Local = {} }

		for _, v17 in pairs(BibliotecaMusicas) do
			tbl13.Musics[v17.id] = true
		end

		for _, v17 in pairs(BilbliotecaVideos) do
			tbl13.Videos[v17.id] = true
		end

		for _, v17 in pairs(BibliotecaRoblox) do
			tbl13.Roblox[v17.id] = true
		end

		for _, v17 in pairs(BibliotecaLocal) do
			tbl13.Local[v17.name] = true
		end

		local tbl14 = { Musics = {}, Videos = {}, Roblox = {}, Local = {} }
		local v17 = ipairs
		local v18 = fn6(tbl12.Musics)

		for _, v19 in v17(v18) do
			local v20 = fn8(fn7(v19), ".mp3")
			tbl14.Musics[v20] = true

			if not tbl13.Musics[v20] then
				task.spawn(function()
					local v21, v22, v23, v24 = ApiInfo(v20)
					if not (v21 and v22 and v23) then
						return
					end
					table.insert(BibliotecaMusicas, { id = v20, name = v21, author = v22, thumb = v23, authorUrl = v24 })
					fn5(v21, "Musica", v20)
				end)
			end
		end

		local v19 = ipairs
		local v20 = fn6(tbl12.Videos)

		for _, v21 in v19(v20) do
			local v22 = fn8(fn7(v21), ".webm")
			tbl14.Videos[v22] = true

			if not tbl13.Videos[v22] then
				task.spawn(function()
					local v23, v24, v25, v26 = ApiInfo(v22)
					if not (v23 and v24 and v25) then
						return
					end
					table.insert(BilbliotecaVideos, { id = v22, name = v23, author = v24, thumb = v25, authorUrl = v26 })
					fn5(v23, "Video", v22)
				end)
			end
		end

		local v21 = ipairs
		local v22 = fn6(tbl12.Roblox)

		for _, v23 in v21(v22) do
			local v24 = fn8(fn7(v23), ".rbx")
			tbl14.Roblox[v24] = true

			if not tbl13.Roblox[v24] then
				task.spawn(function()
					local v25, v26, v27, v28 = ApiRoblox(v24)
					if not (v25 and v26 and v27) then
						return
					end
					table.insert(BibliotecaRoblox, { id = v24, name = v25, creatorId = v26, creatorName = v27 })
					fn5(v25, "Roblox", v24, v28)
				end)
			end
		end

		local v23 = ipairs
		local v24 = fn6(tbl12.Local)

		for _, v25 in v23(v24) do
			local match = fn7(v25):match("^(.*)%.mp3$")
			tbl14.Local[match] = true

			if not tbl13.Local[match] then
				table.insert(BibliotecaLocal, { name = match })
				fn5(match, "Local", match)
			end
		end

		for i = #BibliotecaMusicas, 1, -1 do
			local v25 = BibliotecaMusicas[i]

			if not tbl14.Musics[v25.id] then
				Deletar(v25.id)
				table.remove(BibliotecaMusicas, i)
			end
		end

		for i = #BilbliotecaVideos, 1, -1 do
			local v25 = BilbliotecaVideos[i]

			if not tbl14.Videos[v25.id] then
				Deletar(v25.id)
				table.remove(BilbliotecaVideos, i)
			end
		end

		for i = #BibliotecaRoblox, 1, -1 do
			local v25 = BibliotecaRoblox[i]

			if not tbl14.Roblox[v25.id] then
				Deletar(v25.id)
				table.remove(BibliotecaRoblox, i)
			end
		end

		for i = #BibliotecaLocal, 1, -1 do
			local v25 = BibliotecaLocal[i]

			if not tbl14.Local[v25.name] then
				Deletar(v25.name)
				table.remove(BibliotecaLocal, i)
			end
		end
	end)
end

UpdatePlaylist()
CACHE_LINK = nil
KEY_ATUAL = nil
VIDEO_ATUAL = nil
DownloadAtual = nil
DOWNLOAD_SESSION = nil
DOWNLOAD_TOKEN = nil
DOWNLOAD_CLEARANCE = nil

ApiSearchFree = function(arg)
	local str6 = str3 .. "/search/youtube/free/" .. HttpService:UrlEncode(arg)
	if not CheckRequest() then
		return "error"
	end

	local ok3, result3 = pcall(function()
		return game:HttpGet(str6)
	end)

	if not ok3 or not result3 then
		return "error"
	end
	local v17 = string.lower(result3)
	if string.find(v17, "too many requests") then
		return "rate"
	end

	if string.find(v17, "no results") then
		return "sem"
	end

	local ok4, result4 = pcall(function()
		return HttpService:JSONDecode(result3)
	end)

	if ok4 and result4 and result4.results then
		return result4.results
	end
	return "error"
end

ApiSearchPremium = function(arg, arg2, arg3, arg4, arg5, arg6, arg7)
	local v17 = HttpService
	local str6 = str3 .. "/search/youtube/premium/" .. tostring(arg) .. "/" .. tostring(arg2) .. "/" .. tostring(arg3) .. "/" .. tostring(arg4) .. "/" .. tostring(arg5) .. "/" .. tostring(YmpHwid()) .. "/" .. v17:UrlEncode(arg7)
	if not CheckRequest() then
		return "error"
	end

	local ok3, result3 = pcall(function()
		return game:HttpGet(str6)
	end)

	if not ok3 or not result3 then
		return "error"
	end
	local v18 = string.lower(result3)
	if string.find(v18, "no results") then
		return "sem"
	end

	if string.find(v18, "request denied") then
		return "denied"
	end

	if string.find(v18, "too many requests") then
		return "rate"
	end

	local ok4, result4 = pcall(function()
		return HttpService:JSONDecode(result3)
	end)

	if ok4 and result4 and result4.results then
		return result4.results
	end
	return "error"
end

DownloadLog = function(arg, arg2)
	if not CheckRequest() then
		return
	end

	task.spawn(function()
		pcall(function()
			YmpRequest({
				Url = str3 .. "/dl",
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = HttpService:JSONEncode({ tipo = arg2, link = arg }),
			})
		end)
	end)
end

local tbl12 = {
	1116352408,
	1899447441,
	3049323471,
	3921009573,
	961987163,
	1508970993,
	2453635748,
	2870763221,
	3624381080,
	310598401,
	607225278,
	1426881987,
	1925078388,
	2162078206,
	2614888103,
	3248222580,
	3835390401,
	4022224774,
	264347078,
	604807628,
	770255983,
	1249150122,
	1555081692,
	1996064986,
	2554220882,
	2821834349,
	2952996808,
	3210313671,
	3336571891,
	3584528711,
	113926993,
	338241895,
	666307205,
	773529912,
	1294757372,
	1396182291,
	1695183700,
	1986661051,
	2177026350,
	2456956037,
	2730485921,
	2820302411,
	3259730800,
	3345764771,
	3516065817,
	3600352804,
	4094571909,
	275423344,
	430227734,
	506948616,
	659060556,
	883997877,
	958139571,
	1322822218,
	1537002063,
	1747873779,
	1955562222,
	2024104815,
	2227730452,
	2361852424,
	2428436474,
	2756734187,
	3204031479,
	3329325298,
}

local str6 = "https://p.savenow.to"
local str7 = "https://en.loader.to/"
local str8 = "dfcb6d76f2f6a9894gjkege8a4ab232222"
local n4 = 200
local n5 = 0.003
local n6 = 30

local str9 = str:gsub("^(%a+)%-(%a+)$", function(arg, arg2)
	return arg .. "-" .. arg2:upper()
end) .. "," .. (str:match("^(%a+)") or "en") .. ";q=0.9,en-US;q=0.8,en;q=0.7"

local v17 = nil
local n7 = 0
local flag21 = false

local function fn6(arg, arg2)
	return bit32.rrotate(arg, arg2)
end

local function fn7(...)
	local v18 = table.pack(...)
	local n8 = 0

	for i = 1, select("#", ...) do
		n8 = bit32.band(n8 + select(i, table.unpack(v18, 1, v18.n)), 4294967295)
	end

	return n8
end

local function fn8(arg)
	local n8 = #arg
	local tbl13 = { string.byte(arg, 1, n8) }
	local n9 = n8 * 8
	tbl13[#tbl13 + 1] = 128

	while #tbl13 % 64 ~= 56 do
		tbl13[#tbl13 + 1] = 0
	end

	local n10 = math.floor(n9 / 4294967296)
	local n11 = n9 % 4294967296

	for i = 24, 0, -8 do
		tbl13[#tbl13 + 1] = bit32.band(bit32.rshift(n10, i), 255)
	end

	for i = 24, 0, -8 do
		tbl13[#tbl13 + 1] = bit32.band(bit32.rshift(n11, i), 255)
	end

	local n12 = 1779033703
	local n13 = 3144134277
	local n14 = 1013904242
	local n15 = 2773480762
	local n16 = 1359893119
	local n17 = 2600822924
	local n18 = 528734635
	local n19 = 1541459225

	for i = 1, #tbl13, 64 do
		local tbl14 = {}

		for i2 = 0, 15 do
			local n20 = i + i2 * 4
			tbl14[i2 + 1] = bit32.bor(bit32.lshift(tbl13[n20], 24), bit32.lshift(tbl13[n20 + 1], 16), bit32.lshift(tbl13[n20 + 2], 8), tbl13[n20 + 3])
		end

		for i2 = 17, 64 do
			local v18 = tbl14[i2 - 15]
			local v19 = tbl14[i2 - 2]
			local rshift = bit32.rshift
			local v20 = bit32.bxor(fn6(v18, 7), fn6(v18, 18), rshift(v18, 3))
			local rshift2 = bit32.rshift
			local v21 = bit32.bxor(fn6(v19, 17), fn6(v19, 19), rshift2(v19, 10))
			tbl14[i2] = fn7(tbl14[i2 - 16], v20, tbl14[i2 - 7], v21)
		end

		local v18 = n16
		local v19 = n17
		local v20 = n18
		local v21 = n19
		local v22 = n12
		local v23 = n13
		local v24 = n14
		local v25 = n15

		for i2 = 1, 64 do
			local bxor = bit32.bxor
			local v26 = tbl12[i2]
			local v27 = tbl14[i2]
			local v28 = fn7(v21, bit32.bxor(fn6(v18, 6), fn6(v18, 11), fn6(v18, 25)), bxor(bit32.band(v18, v19), bit32.band(bit32.bnot(v18), v20)), v26, v27)
			local v29 = bit32.bxor(fn6(v22, 2), fn6(v22, 13), fn6(v22, 22))
			local band = bit32.band
			local v30 = bit32.bxor(bit32.band(v22, v23), bit32.band(v22, v24), band(v23, v24))
			local v31 = fn7(v29, v30)
			local v32 = fn7(v25, v28)
			v21 = v20
			v25 = v24
			v20 = v19
			v24 = v23
			v19 = v18
			v23 = v22
			v18 = v32
			v22 = fn7(v28, v31)
		end

		n12 = fn7(n12, v22)
		n13 = fn7(n13, v23)
		n14 = fn7(n14, v24)
		n15 = fn7(n15, v25)
		n16 = fn7(n16, v18)
		n17 = fn7(n17, v19)
		n18 = fn7(n18, v20)
		n19 = fn7(n19, v21)
	end

	return string.format("%08x%08x%08x%08x%08x%08x%08x%08x", n12, n13, n14, n15, n16, n17, n18, n19)
end

local function fn9(arg, arg2)
	local num = tonumber(arg2)
	if not num then
		return nil
	end
	local str10 = string.rep("0", num)
	local n8 = #str10
	local str11 = tostring(arg) .. ":"
	local n9 = 0

	while true do
		local now = os.clock()
		local exitTo = nil

		while fn8(str11 .. tostring(n9)):sub(1, n8) ~= str10 do
			n9 += 1
			if n5 <= os.clock() - now then
				exitTo = 1
				break
			end
		end

		if exitTo == 1 then
			task.wait()
			continue
		end
		break
	end

	return tostring(n9)
end

local function fn10(arg, arg2)
	local tbl13 = {
		accept = "*/*",
		["accept-language"] = str9,
		referer = str7,
		["sec-ch-ua"] = "\"Chromium\";v=\"137\", \"Not/A)Brand\";v=\"24\"",
		["sec-ch-ua-mobile"] = "?1",
		["sec-ch-ua-platform"] = "\"Android\"",
		["sec-fetch-dest"] = "empty",
		["sec-fetch-mode"] = "cors",
		["sec-fetch-site"] = "cross-site",
	}

	if arg2 then
		tbl13["content-type"] = "application/json"
	end

	if arg then
		tbl13.authorization = "Bearer " .. arg
	end

	return tbl13
end

local function fn11(arg)
	if not arg then
		return nil
	end
	local body = arg.Body or arg.body
	if type(body) ~= "string" then
		return nil
	end
	local ok3, result3 = pcall(HttpService.JSONDecode, HttpService, body)
	if not ok3 or type(result3) ~= "table" then
		return nil
	end
	return result3
end

local function fn12()
	local now = os.time()
	if v17 and now < n7 - n6 then
		return v17
	end

	if flag21 then
		local now2 = os.clock()

		while flag21 do
			if not (os.clock() - now2 >= 10) then
				task.wait()
				continue
			end
			break
		end

		local now3 = os.time()
		if v17 and now3 < n7 - n6 then
			return v17
		end
	end

	flag21 = true

	local ok3, result3, result4 = pcall(function()
		local v18 = YmpRequest({ Url = str6 .. "/api/pow/challenge", Method = "GET", Headers = fn10() })
		local v19 = fn11(v18)
		if not v19 then
			return nil
		end

		if v19.salt == nil or v19.difficulty == nil or v19.expires_at == nil or v19.signature == nil then
			return nil
		end
		local v20 = fn9(v19.salt, v19.difficulty)
		if not v20 then
			return nil
		end

		local v21 = YmpRequest({
			Url = str6 .. "/api/pow/verify",
			Method = "POST",
			Headers = fn10(nil, true),
			Body = HttpService:JSONEncode({
				salt = v19.salt,
				difficulty = v19.difficulty,
				expires_at = v19.expires_at,
				signature = v19.signature,
				nonce = v20,
			}),
		})

		local v22 = fn11(v21)
		if not v22 or v22.success ~= true or type(v22.token) ~= "string" then
			return nil
		end
		return v22.token, tonumber(v22.expires_at) or tonumber(v19.expires_at) or os.time() + 300
	end)

	flag21 = false
	if not ok3 or type(result3) ~= "string" then
		return nil
	end
	v17 = result3
	n7 = tonumber(result4) or os.time() + 300
	return v17
end

local function fn13(arg, arg2, arg3)
	local now = os.clock()
	local v18 = fn12()
	local v19 = HttpService
	local str10 = "&apikey=" .. str8
	local str11 = str6 .. "/api/v2/download?format=" .. HttpService:UrlEncode(arg2) .. "&url=" .. v19:UrlEncode(arg) .. str10
	local v20 = fn10(v18)

	local ok3, result3 = pcall(function()
		return YmpRequest({ Url = str11, Method = "GET", Headers = v20 })
	end)

	if not ok3 then
		return "error"
	end
	local v21 = fn11(result3)
	if not v21 or v21.success == false or type(v21.progress_url) ~= "string" then
		return "error"
	end
	local progressUrl = v21.progress_url
	task.wait(2)
	local v22

	while true do
		v22 = nil

		if os.clock() - now <= n4 then
			local ok4, result4 = pcall(function()
				return YmpRequest({ Url = progressUrl, Method = "GET", Headers = v20 })
			end)

			if ok4 then
				local v23 = fn11(result4)

				if v23 then
					if v23.progress == 1000 and type(v23.download_url) == "string" then
						v22 = v23
						break
					else
						task.wait(2)
					end
				else
					task.wait(2)
				end
			else
				task.wait(2)
			end
		else
			break
		end
	end

	if not v22 then
		return "error"
	end
	local tbl13 = {}

	if type(v22.download_url) == "string" then
		tbl13[#tbl13 + 1] = v22.download_url
	end

	if type(v22.alternative_download_urls) == "table" then
		for _, alternativeDownloadUrl in ipairs(v22.alternative_download_urls) do
			if not (#tbl13 >= 4) then
				if type(alternativeDownloadUrl) == "table" and type(alternativeDownloadUrl.url) == "string" and alternativeDownloadUrl.url ~= v22.download_url then
					tbl13[#tbl13 + 1] = alternativeDownloadUrl.url
				end

				continue
			end

			break
		end
	end

	if #tbl13 == 0 then
		return "error"
	end
	DownloadLog(arg, arg3)
	local v23 = table.create(math.min(#tbl13, 4))

	for i = 1, math.min(#tbl13, 4) do
		v23[i] = "Download" .. i .. ": " .. tbl13[i]
	end

	return table.concat(v23, "\n")
end

DownloadMusic = function(arg)
	return fn13(arg, "mp3", "music")
end

DownloadVideo = function(arg)
	return fn13(arg, "360", "video")
end

DesativarBusca = function(arg)
	if arg then
		PesquisarBox.Text = Traducao.Processando
		PesquisarBox.Active = false
		PaginaFrame.Visible = false
		PaginaEsperandoFrame.Visible = true
	else
		PesquisarBox.Text = text
		PesquisarBox.Active = true
		PaginaFrame.Visible = true
		PaginaEsperandoFrame.Visible = false
	end
end

CancelarBusca = function()
	ScrollDownload.Visible = false
	ScrollDownload.CanvasPosition = Vector2.new(0, 0)
	Aguardando.Visible = true
	DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.PesquiseTitle .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.PesquiseText .. "</font>"
	DownloadFrameTexto.Visible = true
	Concluido.Visible = false
	PaginaFrame.Visible = false
	PaginaEsperandoFrame.Visible = true
	SemResultado.Visible = false
	Erro.Visible = false
	Tutorial.Visible = false
	Novamente.Visible = false
	FiltroFrame.Visible = false
	Formato.Visible = false
	ScrollDownload.Visible = false
	TextoTituloFor.Text = ""
	Thumbfor.Image = "rbxassetid://0"
	DownloadAtual = nil

	for _, child in ipairs(ScrollDownload:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
end

Carregando = function(arg)
	if arg then
		flag12 = true
		Loading.Visible = true
		ScrollDownload.Visible = false
		Aguardando.Visible = false

		task.spawn(function()
			while flag12 do
				local v18 = Loading
				v18.Rotation = v18.Rotation + 5
				task.wait(0.04)
			end
		end)
	else
		flag12 = false
		Loading.Visible = false
	end
end

CarregandoRoblox = function(arg)
	if arg then
		if flag13 then
			return
		end
		flag13 = true
		Baixando.Visible = true

		task.spawn(function()
			while flag13 do
				local n8 = Baixando.Rotation + 360
				tween = v6:Create(Baixando, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { Rotation = n8 })
				tween:Play()
				tween.Completed:Wait()
				local n9 = 0

				while n9 < 0.35 and flag13 do
					n9 += task.wait()
				end
			end
		end)
	else
		flag13 = false

		if tween then
			tween:Cancel()
			tween = nil
		end

		Baixando.Visible = false
		Baixando.Rotation = 0
	end
end

AddRoblox = function(arg)
	local str10 = "YouTube Music Player/Roblox IDS" .. "/" .. tostring(arg) .. ".rbx"

	pcall(function()
		if not isfolder("YouTube Music Player/Roblox IDS") then
			makefolder("YouTube Music Player/Roblox IDS")
		end

		writefile(str10, "")
	end)

	CancelarBusca()
	UpdatePlaylist()
end

TelaDownload = function(arg, arg2, arg3)
	VIDEO_ATUAL = arg
	ScrollDownload.Visible = false
	Formato.Visible = true
	local str10 = "Youtube Music Player/Internal/Cache/Search_" .. tostring(arg) .. ".jpg"

	if isfile and isfile(str10) then
		Thumbfor.Image = getcustomasset(str10)
		Thumbfor.ImageRectOffset = Vector2.new(0, 45)
		Thumbfor.ImageRectSize = Vector2.new(480, 270)
	else
		Thumbfor.Image = "rbxassetid://110787075859454"
		Thumbfor.ImageRectOffset = Vector2.new(0, 0)
		Thumbfor.ImageRectSize = Vector2.new(0, 0)
	end

	local str11 = "Youtube Music Player/Musics/" .. tostring(arg) .. ".mp3"
	local str12 = "Youtube Music Player/Videos/" .. tostring(arg) .. ".webm"
	local v18 = isfile and isfile(str11)
	local v19 = flag19 and isfile and isfile(str12)

	if v18 then
		BotaoMp3.BackgroundTransparency = 0.9
		BotaoMp3.AutoButtonColor = false
		NomeMp3.TextColor3 = Color3.fromRGB(20, 20, 20)
	else
		BotaoMp3.BackgroundTransparency = 0
		BotaoMp3.AutoButtonColor = true
		NomeMp3.TextColor3 = Color3.fromRGB(0, 191, 255)
	end

	if flag19 then
		if v19 then
			BotaoMp4.BackgroundTransparency = 0.9
			BotaoMp4.AutoButtonColor = false
			NomeMp4.TextColor3 = Color3.fromRGB(20, 20, 20)
		else
			BotaoMp4.BackgroundTransparency = 0
			BotaoMp4.AutoButtonColor = true
			NomeMp4.TextColor3 = Color3.fromRGB(154, 205, 50)
		end
	end

	TextoTituloFor.Text = "<font color=\"rgb(255,255,255)\">" .. arg2 .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. arg3 .. "</font>"
end

CriarResultado = function(arg, arg2, arg3, arg4, arg5, arg6)
	local tbl13 = {}
	local flag22 = false
	local str10 = "Youtube Music Player/Internal/Cache/Search_" .. arg2 .. ".jpg"
	local frame3 = Instance.new("Frame")
	frame3.Size = UDim2.new(0, 221, 0, 43)
	frame3.Position = UDim2.new(0, 7, 0, 5)
	frame3.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
	frame3.BorderSizePixel = 0
	frame3.Parent = ScrollDownload
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = UDim2.new(0, 60, 0, 43)
	imageLabel.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
	imageLabel.Parent = frame3
	local frame4 = Instance.new("Frame")
	frame4.Size = UDim2.new(0, 25, 0, 10)
	frame4.Position = UDim2.new(0, 3, 0, 3)
	frame4.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
	frame4.BackgroundTransparency = 0.5
	frame4.BorderSizePixel = 0
	frame4.Visible = arg6 ~= nil
	frame4.Parent = imageLabel
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = tostring(arg6 or "00:00")
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextScaled = true
	textLabel.Parent = frame4
	local frame5 = Instance.new("Frame")
	frame5.Size = UDim2.new(0, 2, 1, 0)
	frame5.Position = UDim2.new(0, 60, 0, 0)
	frame5.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
	frame5.BorderSizePixel = 0
	frame5.Parent = frame3
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.Size = UDim2.new(0, 108, 1, -6)
	textLabel2.Position = UDim2.new(0, 65, 0, 3)
	textLabel2.BackgroundTransparency = 1
	textLabel2.RichText = true
	textLabel2.Font = Enum.Font.SourceSansBold
	textLabel2.TextScaled = true
	textLabel2.Text = string.format("<font color=\"rgb(255,255,255)\">%s</font>\n<font color=\"rgb(192,192,192)\">%s %s</font>", arg3, Traducao.De, arg4)
	textLabel2.Parent = frame3
	local frame6 = Instance.new("Frame")
	frame6.Size = UDim2.new(0, 2, 1, 0)
	frame6.Position = UDim2.new(0, 176, 0, 0)
	frame6.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
	frame6.BorderSizePixel = 0
	frame6.Parent = frame3
	local imageButton3 = Instance.new("ImageButton")
	imageButton3.Size = UDim2.new(0, 33, 0, 33)
	imageButton3.Position = UDim2.new(0, 183, 0, 5)
	imageButton3.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
	imageButton3.AutoButtonColor = false
	imageButton3.Parent = frame3
	Corner(frame3, 5)
	Corner(imageLabel, 5)
	Corner(frame4, 5)
	Corner(imageButton3, 5)
	Stroke(frame3, 50, 50, 50, 2)
	Stroke(imageLabel, 50, 50, 50, 2)
	Stroke(imageButton3, 50, 50, 50, 2)

	if arg == "Roblox" then
		local str11 = tostring(arg2) .. ".rbx"

		pcall(function()
			if isfolder and isfolder("YouTube Music Player/Roblox IDS") then
				for _, v18 in ipairs(listfiles("YouTube Music Player/Roblox IDS")) do
					if string.find(v18, str11) then
						flag22 = true
						break
					end
				end
			end
		end)

		imageButton3.Image = flag22 and "rbxassetid://75203635436406" or "rbxassetid://125446601626694"
		imageLabel.Image = "rbxassetid://112075012925512"
	else
		imageButton3.Image = "rbxassetid://126311565377599"

		task.spawn(function()
			if not pcall(function()
				if not isfolder("Youtube Music Player/Internal/Cache") then
					makefolder("Youtube Music Player/Internal/Cache")
				end

				local response = game:HttpGet(arg5)
				writefile(str10, response)
				imageLabel.Image = getcustomasset(str10)
				imageLabel.ImageRectOffset = Vector2.new(0, 45)
				imageLabel.ImageRectSize = Vector2.new(480, 270)
			end) then
				imageLabel.Image = "rbxassetid://110787075859454"
			end
		end)
	end

	table.insert(tbl13, imageButton3.MouseButton1Click:Connect(function()
		if arg == "Roblox" then
			if not flag19 then
				return
			end

			if flag22 then
				fn3(Traducao.Erro, Traducao.JaTemRoblox, 5)
			else
				AddRoblox(arg2)
			end
		else
			TelaDownload(arg2, arg3, arg4)
		end
	end))

	frame3.Destroying:Connect(function()
		for _, v18 in ipairs(tbl13) do
			v18:Disconnect()
		end

		if arg ~= "Roblox" then
			pcall(function()
				if delfile and isfile(str10) then
					delfile(str10)
				end
			end)
		end
	end)
end

organizarItens = function()
	n3 = 0

	for _, child in ipairs(ScrollDownload:GetChildren()) do
		if child:IsA("Frame") then
			child.Position = UDim2.new(0, 7, 0, n3 + 5)
			n3 += 58
		end
	end

	ScrollDownload.CanvasSize = UDim2.new(0, 0, 0, n3 - 3)
end

Buscar = function(arg)
	for _, child in ipairs(ScrollDownload:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	DesativarBusca(true)
	Carregando(true)
	DownloadFrameTexto.Visible = false
	FiltroFrame.Visible = false

	local function fn14()
		DesativarBusca(false)
		Carregando(false)
	end

	local function fn15(arg2, arg3, arg4)
		ScrollDownload.Visible = false

		if arg4 then
			SemResultado.Visible = true
		else
			Erro.Visible = true
			Tutorial.Visible = true
		end

		DownloadFrameTexto.Text = string.format("<font color=\"rgb(255,255,255)\">%s</font>\n<font color=\"rgb(192,192,192)\">%s</font>", arg2, arg3)
		DownloadFrameTexto.Visible = true
		fn14()
	end

	if not CheckRequest() then
		fn15(Traducao.ErroTitle, Traducao.ErroText)
		return
	end
	local v18 = nil
	local flag22 = false

	task.spawn(function()
		if flag19 then
			v18 = ApiSearchPremium(tbl.Ordem or "relevance", tbl.Data or "any", tbl.Duracao or "any", tbl.Pagina or 1, KEY_ATUAL, YmpHwid(), arg)
		else
			v18 = ApiSearchFree(arg)
		end

		flag22 = true
	end)

	local now = tick()

	while true do
		task.wait(0.1)
		if not (flag22 or tick() - now > 15) then
			continue
		end
		break
	end

	if not flag22 or v18 == "error" or not v18 then
		fn15(Traducao.ErroTitle, Traducao.ErroText)
		return
	end

	if v18 == "denied" then
		fn15(Traducao.ErroCrackTitle, Traducao.ErroCrackText)
		return
	end

	if v18 == "rate" then
		fn15(Traducao.TooMany, Traducao.RateLi)
		return
	end

	if v18 == "sem" then
		fn15(Traducao.SemResutadoTitle, Traducao.SemResutadoText, true)
		return
	end

	for _, v19 in ipairs(v18) do
		if flag19 and v19.type == "roblox" then
			CriarResultado("Roblox", v19.id, v19.Name, v19.CreatorName, nil, nil)
		else
			CriarResultado("YouTube", v19.id, v19.name, v19.author, v19.thumbnail, v19.duration)
		end
	end

	fn14()
	ScrollDownload.Visible = true
end

SetPag = function(pagina)
	if not flag19 then
		return
	end

	if tbl.Pagina == pagina then
		return
	end
	tbl.Pagina = pagina
	ScrollDownload.CanvasPosition = Vector2.new(0, 0)

	for _, child in ipairs(ScrollPagina:GetChildren()) do
		if child:IsA("ImageButton") then
			local uiStroke = child:FindFirstChildOfClass("UIStroke")

			if child.Name == tostring(pagina) then
				child.BackgroundColor3 = Color3.fromRGB(128, 128, 128)

				if uiStroke then
					uiStroke.Color = Color3.fromRGB(255, 0, 0)
				end
			else
				child.BackgroundColor3 = Color3.fromRGB(128, 128, 128)

				if uiStroke then
					uiStroke.Color = Color3.fromRGB(50, 50, 50)
				end
			end
		end
	end
end

Baixar = function(arg)
	Formato.Visible = false
	FiltroFrame.Visible = false
	Erro.Visible = false
	Tutorial.Visible = false
	Novamente.Visible = false
	DesativarBusca(true)
	CarregandoRoblox(true)
	DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Aguarde .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.Dados .. "</font>"
	DownloadFrameTexto.Visible = true
	local v18 = VIDEO_ATUAL
	local str10 = "https://youtu.be/" .. tostring(v18)

	local function fn14(arg2)
		if type(arg2) ~= "string" then
			return nil
		end
		local tbl13 = {}

		for match in string.gmatch(arg2, "[^\n]+") do
			local v19, v20 = string.match(match, "Download(%d+):%s*(.+)")

			if v19 and v20 then
				tbl13[tonumber(v19)] = v20
			end
		end

		return tbl13
	end

	local v19

	if arg == "Musica" then
		v19 = DownloadMusic(str10)
	else
		v19 = nil

		if arg == "Video" then
			v19 = DownloadVideo(str10)
		end
	end

	if v19 == "error" or v19 == "rate" or v19 == "denied" or not CheckRequest() then
		CarregandoRoblox(false)
		DesativarBusca(false)
		Erro.Visible = true
		Tutorial.Visible = true
		Novamente.Visible = true

		if not frame.Visible or not Tela4.Visible then
			fn3(Traducao.ErroTitle, Traducao.ErroText, 10)
		end

		DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.ErroTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.ErroText .. "</font>"
		return
	end

	local v20 = fn14(v19)

	if not v20 then
		CarregandoRoblox(false)
		DesativarBusca(false)
		Erro.Visible = true
		Tutorial.Visible = true
		Novamente.Visible = true

		if not frame.Visible or not Tela4.Visible then
			fn3(Traducao.ErroTitle, Traducao.ErroText, 10)
		end

		DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.ErroTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.ErroText .. "</font>"
		return
	end

	DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.MaisUmPauco .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.Baixando .. "</font>"
	local v21 = nil

	for i = 1, 4 do
		local v22 = v20[i]

		if v22 and type(v22) == "string" then
			for i2 = 1, 2 do
				local ok3, result3 = pcall(function()
					return game:HttpGet(v22)
				end)

				if ok3 and result3 then
					v21 = result3
					break
				else
					task.wait(0.5)
				end
			end

			if not v21 then
				continue
			end
		else
			continue
		end

		break
	end

	if not v21 then
		CarregandoRoblox(false)
		DesativarBusca(false)
		Erro.Visible = true
		Tutorial.Visible = true
		Novamente.Visible = true

		if not frame.Visible or not Tela4.Visible then
			fn3(Traducao.ErroTitle, Traducao.ErroText, 10)
		end

		DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.ErroTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.ErroText .. "</font>"
		return
	end

	local str11 = "YouTube Music Player/" .. (arg == "Video" and "Videos" or "Musics")
	local str12 = arg == "Video" and ".webm" or ".mp3"
	local str13 = str11 .. "/" .. tostring(v18) .. str12

	pcall(function()
		if not isfolder(str11) then
			makefolder(str11)
		end

		writefile(str13, v21)
	end)

	task.wait(1)
	UpdatePlaylist()
	CarregandoRoblox(false)
	DesativarBusca(false)
	Concluido.Visible = true

	if not frame.Visible or not Tela4.Visible then
		fn3(Traducao.Baixado, Traducao.Terminou, 10)
	end

	DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Baixado .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.Terminou .. "</font>"
end

for i = 1, 10 do
	local imageButton3 = Instance.new("ImageButton")
	imageButton3.Size = UDim2.new(0, 21, 0, 21)
	imageButton3.Position = UDim2.new(0, 3 + (i - 1) * 28, 0, 3)
	imageButton3.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
	imageButton3.BackgroundTransparency = 0.9
	imageButton3.Name = i
	imageButton3.Parent = ScrollPagina
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.Position = UDim2.new(0, 0, 0, 0)
	textLabel.TextColor3 = Color3.fromRGB(20, 20, 20)
	textLabel.BackgroundTransparency = 1
	textLabel.BorderSizePixel = 0
	textLabel.Text = tostring(i)
	textLabel.Parent = imageButton3
	Corner(imageButton3, 20)
	Stroke(imageButton3, 50, 50, 50, 1)
	local uiStroke = imageButton3:FindFirstChildOfClass("UIStroke")

	if i == 1 then
		imageButton3.BackgroundTransparency = 0
		imageButton3.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

		if uiStroke then
			uiStroke.Color = Color3.fromRGB(255, 0, 0)
		end
	end

	imageButton3.MouseButton1Click:Connect(function()
		if i == tbl.Pagina then
			return
		end

		if not flag19 then
			fn3(Traducao.OpcaoBloqueadaTitle, Traducao.OpcaoBloqueadaText, 10)
			return
		end

		if Loading.Visible or Baixando.Visible then
			return
		end
		SetPag(i)
		Concluido.Visible = false
		DownloadFrameTexto.Visible = false
		SemResultado.Visible = false
		Erro.Visible = false
		Tutorial.Visible = false
		Novamente.Visible = false
		Buscar(text)
	end)
end

AplicarFiltro.MouseButton1Click:Connect(function()
	if not flag19 then
		fn3(Traducao.OpcaoBloqueadaTitle, Traducao.OpcaoBloqueadaText, 10)
		return
	end

	if not PaginaFrame.Visible then
		fn3(Traducao.Erro, Traducao.NaoPodeFiltro, 10)
		return
	end
	tbl.Ordem = ordem
	tbl.Data = data
	tbl.Duracao = duracao
	DownloadFrameTexto.Visible = false
	SemResultado.Visible = false
	Erro.Visible = false
	Tutorial.Visible = false
	Novamente.Visible = false
	Formato.Visible = false
	ScrollDownload.Visible = true
	TextoTituloFor.Text = ""
	Thumbfor.Image = "rbxassetid://0"
	SetPag(1)
	Buscar(text)
end)

RemoverFiltro.MouseButton1Click:Connect(function()
	if not flag19 then
		fn3(Traducao.OpcaoBloqueadaTitle, Traducao.OpcaoBloqueadaText, 10)
		return
	end

	if ordem == "relevance" and data == "any" and duracao == "any" then
		fn3(Traducao.Erro, Traducao.FiltrosJaPadrao, 10)
		return
	end
	ordem = "relevance"
	data = "any"
	duracao = "any"
	tbl.Ordem = ordem
	tbl.Data = data
	tbl.Duracao = duracao
	RelevanciaTexto.Text = Traducao.Order .. "\n" .. Traducao.Relevance
	DataUploadTexto.Text = Traducao.UploaDate .. "\n" .. Traducao.Any
	DuracaoTexto.Text = Traducao.Duration .. "\n" .. Traducao.Any
	DownloadFrameTexto.Visible = false
	SemResultado.Visible = false
	Erro.Visible = false
	Tutorial.Visible = false
	Novamente.Visible = false
	fn3(Traducao.Sucesso, Traducao.FiltrosRemovidos, 5)

	if PaginaFrame.Visible then
		Formato.Visible = false
		ScrollDownload.Visible = true
		TextoTituloFor.Text = ""
		Thumbfor.Image = "rbxassetid://0"
		SetPag(1)
		Buscar(text)
	end
end)

Relevancia.MouseButton1Click:Connect(function()
	for i, v18 in ipairs(tbl2) do
		if v18 == ordem then
			ordem = tbl2[i % #tbl2 + 1]
			break
		end
	end

	RelevanciaTexto.Text = Traducao.Order .. "\n" .. Traducao[ordem:gsub("^%l", string.upper)]
end)

DataUpload.MouseButton1Click:Connect(function()
	for i, v18 in ipairs(tbl3) do
		if v18 == data then
			data = tbl3[i % #tbl3 + 1]
			break
		end
	end

	DataUploadTexto.Text = Traducao.UploaDate .. "\n" .. Traducao[data:gsub("^%l", string.upper)]
end)

Duracao.MouseButton1Click:Connect(function()
	for i, v18 in ipairs(tbl4) do
		if v18 == duracao then
			duracao = tbl4[i % #tbl4 + 1]
			break
		end
	end

	DuracaoTexto.Text = Traducao.Duration .. "\n" .. Traducao[duracao:gsub("^%l", string.upper)]
end)

Filtro.MouseButton1Click:Connect(function()
	if Loading.Visible or Baixando.Visible then
		return
	end

	if not FiltroFrame.Visible then
		tbl10 = {}

		for _, v18 in ipairs({
			DownloadFrameTexto,
			Aguardando,
			Loading,
			SemResultado,
			Formato,
			ScrollDownload,
			Concluido,
			SemResultado,
			Erro,
		}) do
			if v18.Visible then
				table.insert(tbl10, v18)
				v18.Visible = false
			end
		end

		FiltroFrame.Visible = true
	else
		for _, v18 in ipairs(tbl10) do
			if v18 then
				v18.Visible = true
			end
		end

		tbl10 = {}
		FiltroFrame.Visible = false
	end
end)

ClearSearch = function()
	pcall(function()
		if isfolder("Youtube Music Player/Internal/Cache") then
			local Cache = listfiles("Youtube Music Player/Internal/Cache")

			for _, v18 in ipairs(Cache) do
				if string.find(v18, "Search_") then
					delfile(v18)
				end
			end
		end
	end)
end

PesquisarBox.FocusLost:Connect(function()
	local match = PesquisarBox.Text:match("^%s*(.-)%s*$")
	if match == "" then
		PesquisarBox.Text = ""
		return
	end
	ClearSearch()
	text = tostring(match)
	SetPag(1)
	Buscar(text)
end)

PesquisarBox.Focused:Connect(function()
	CancelarBusca()
end)

Lupa.MouseButton1Down:Connect(function()
	if not PesquisarBox.Active then
		return
	end
	flag14 = PesquisarBox:IsFocused()
end)

Lupa.MouseButton1Click:Connect(function()
	if not PesquisarBox.Active then
		return
	end

	if flag14 then
		PesquisarBox:ReleaseFocus()
	else
		PesquisarBox:CaptureFocus()
	end
end)

BotaoMp3.MouseButton1Click:Connect(function()
	if isfile("YouTube Music Player/Musics" .. "/" .. tostring(VIDEO_ATUAL) .. ".mp3") then
		fn3(Traducao.Erro, Traducao.JaTemMusica, 5)
		return
	end
	Baixar("Musica")
	DownloadAtual = "M"
end)

BotaoMp4.MouseButton1Click:Connect(function()
	if not flag19 then
		fn3(Traducao.OpcaoBloqueadaTitle, Traducao.OpcaoBloqueadaText, 10)
		return
	end

	if isfile("YouTube Music Player/Videos" .. "/" .. tostring(VIDEO_ATUAL) .. ".webm") then
		fn3(Traducao.Erro, Traducao.JaTemVideo, 5)
		return
	end
	Baixar("Video")
	DownloadAtual = "V"
end)

BotaoCancelar.MouseButton1Click:Connect(function()
	Formato.Visible = false
	ScrollDownload.Visible = true
	TextoTituloFor.Text = ""
	Thumbfor.Image = "rbxassetid://0"
end)

Novamente.MouseButton1Click:Connect(function()
	if DownloadAtual == "M" then
		fn3(Traducao.Tentando, Traducao.TentandoTexto, 7)
		Baixar("Musica")
	elseif DownloadAtual == "V" then
		fn3(Traducao.Tentando, Traducao.TentandoTexto, 7)
		Baixar("Video")
	end
end)

Tutorial.MouseButton1Click:Connect(function()
	fn3(Traducao.LinkCopiado, Traducao.Tutorial, 8)
	YmpClipboard("https://raw.githubusercontent.com/Dan41/Roblox-Scripts/refs/heads/main/Youtube%20Music%20Player/Tutorial.txt")
end)

ScrollDownload.ChildAdded:Connect(function(child)
	if not child:IsA("Frame") then
		return
	end
	organizarItens()
end)

ScrollDownload.ChildRemoved:Connect(function(child)
	if not child:IsA("Frame") then
		return
	end
	organizarItens()
end)

SetVolume = function(volume)
	sound2.Volume = volume
	Video.Volume = volume
	MiniVideo.Volume = volume
	VolumeBox.Text = tostring(volume)
end

SetPitch = function(playbackSpeed)
	sound2.PlaybackSpeed = playbackSpeed
	GiroSpeed = playbackSpeed
	GiroBackup = playbackSpeed
	PitchBox.Text = tostring(playbackSpeed)
end

SetEqualizer = function(lowGain, midGain, highGain)
	Equalizer.LowGain = lowGain
	Equalizer.MidGain = midGain
	Equalizer.HighGain = highGain
	GravesBox.Text = tostring(lowGain)
	MediosBox.Text = tostring(midGain)
	AgudosBox.Text = tostring(highGain)
end

EquaValue = function(arg, arg2)
	local v18 = string.match(string.gsub(string.gsub(arg, "^%s+", ""), "%s+$", ""), "-?%d+%.?%d*")
	if not v18 then
		return arg2
	end
	local num = tonumber(v18)
	if not num then
		return arg2
	end
	return (math.clamp(num, -1000, 1000))
end

SetEffect = function(arg)
	for _, child in pairs(sound2:GetChildren()) do
		if child:IsA("SoundEffect") then
			child:Destroy()
		end
	end

	SetPitch(1)
	SetEqualizer(1, 1, 1)
	if arg == "Nenhum" then
		return
	end

	if arg == "Reverb" then
		local reverbSoundEffect = Instance.new("ReverbSoundEffect", sound2)
		reverbSoundEffect.DecayTime = 2.6
		reverbSoundEffect.Density = 0.75
		reverbSoundEffect.Diffusion = 0.9
		reverbSoundEffect.WetLevel = -9
		reverbSoundEffect.DryLevel = 0
		SetEqualizer(-1, 0, -3)
	elseif arg == "Echo" then
		local echoSoundEffect = Instance.new("EchoSoundEffect", sound2)
		echoSoundEffect.Delay = 0.7
		echoSoundEffect.Feedback = 0.5
		echoSoundEffect.WetLevel = -6
		echoSoundEffect.DryLevel = 0
	elseif arg == "Distortion" then
		Instance.new("DistortionSoundEffect", sound2).Level = 0.4
		SetEqualizer(-4, 2, -2)
	elseif arg == "Chorus" then
		local chorusSoundEffect = Instance.new("ChorusSoundEffect", sound2)
		chorusSoundEffect.Depth = 0.25
		chorusSoundEffect.Rate = 1.2
		chorusSoundEffect.Mix = 0.6
	elseif arg == "Flanger" then
		local flangeSoundEffect = Instance.new("FlangeSoundEffect", sound2)
		flangeSoundEffect.Depth = 0.4
		flangeSoundEffect.Rate = 2
		flangeSoundEffect.Mix = 0.5
	elseif arg == "Tremolo" then
		local tremoloSoundEffect = Instance.new("TremoloSoundEffect", sound2)
		tremoloSoundEffect.Depth = 0.5
		tremoloSoundEffect.Frequency = 8
	elseif arg == "Compressor" then
		local compressorSoundEffect = Instance.new("CompressorSoundEffect", sound2)
		compressorSoundEffect.Threshold = -25
		compressorSoundEffect.Ratio = 15
		compressorSoundEffect.Attack = 0.02
		compressorSoundEffect.Release = 0.1
	elseif arg == "Radio" then
		Instance.new("DistortionSoundEffect", sound2).Level = 0.25
		local compressorSoundEffect = Instance.new("CompressorSoundEffect", sound2)
		compressorSoundEffect.Threshold = -10
		compressorSoundEffect.Ratio = 12
		compressorSoundEffect.Attack = 0.02
		compressorSoundEffect.Release = 0.08
		local equalizerSoundEffect = Instance.new("EqualizerSoundEffect", sound2)
		equalizerSoundEffect.LowGain = -10
		equalizerSoundEffect.MidGain = 10
		equalizerSoundEffect.HighGain = -12
		SetPitch(0.97)
	elseif arg == "Cinema" then
		local reverbSoundEffect = Instance.new("ReverbSoundEffect", sound2)
		reverbSoundEffect.DecayTime = 5
		reverbSoundEffect.Density = 0.7
		reverbSoundEffect.WetLevel = -15
		reverbSoundEffect.DryLevel = 0
		SetEqualizer(6, -2, 2)
	elseif arg == "Underwater" then
		local reverbSoundEffect = Instance.new("ReverbSoundEffect", sound2)
		reverbSoundEffect.DecayTime = 1.5
		reverbSoundEffect.Density = 1
		reverbSoundEffect.WetLevel = -6
		reverbSoundEffect.DryLevel = -4
		SetEqualizer(4, -12, -25)
	elseif arg == "Kid" then
		SetPitch(1.45)
		SetEqualizer(-5, 2, 4)
	elseif arg == "Robot" then
		local flangeSoundEffect = Instance.new("FlangeSoundEffect", sound2)
		flangeSoundEffect.Depth = 0.5
		flangeSoundEffect.Rate = 3
		local tremoloSoundEffect = Instance.new("TremoloSoundEffect", sound2)
		tremoloSoundEffect.Depth = 1
		tremoloSoundEffect.Frequency = 4
		SetEqualizer(-5, 5, 2)
	elseif arg == "Slowed" then
		SetPitch(0.72)
		Instance.new("DistortionSoundEffect", sound2).Level = 0.35
		local reverbSoundEffect = Instance.new("ReverbSoundEffect", sound2)
		reverbSoundEffect.DecayTime = 4
		reverbSoundEffect.WetLevel = -10
		SetEqualizer(8, -2, -12)
	end
end

SelecionarEqua = function(arg)
	local children = ScrollEqua:GetChildren()

	local function fn14(arg2)
		if not arg2:IsA("ImageButton") or arg2.Name == "Resetar" then
			return
		end
		local imageLabel = arg2:FindFirstChildOfClass("ImageLabel")
		arg2.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		Stroke(arg2, 50, 50, 50, 2)

		if imageLabel then
			Stroke(imageLabel, 50, 50, 50, 2)
		end
	end

	for _, child in ipairs(children) do
		fn14(child)
	end

	local imageLabel = arg:FindFirstChildOfClass("ImageLabel")
	arg.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
	Stroke(arg, 255, 0, 0, 2)

	if imageLabel then
		Stroke(imageLabel, 255, 0, 0, 2)
	end

	if arg.Name == "Nenhum" then
		SetEffect("Nenhum")
	elseif arg.Name == "Reverb" then
		SetEffect("Reverb")
	elseif arg.Name == "Echo" then
		SetEffect("Echo")
	elseif arg.Name == "Distortion" then
		SetEffect("Distortion")
	elseif arg.Name == "Chorus" then
		SetEffect("Chorus")
	elseif arg.Name == "Flanger" then
		SetEffect("Flanger")
	elseif arg.Name == "Tremolo" then
		SetEffect("Tremolo")
	elseif arg.Name == "Compressor" then
		SetEffect("Compressor")
	elseif arg.Name == "Radio" then
		SetEffect("Radio")
	elseif arg.Name == "Cinema" then
		SetEffect("Cinema")
	elseif arg.Name == "Underwater" then
		SetEffect("Underwater")
	elseif arg.Name == "Kid" then
		SetEffect("Kid")
	elseif arg.Name == "Robot" then
		SetEffect("Robot")
	elseif arg.Name == "Slowed" then
		SetEffect("Slowed")
	end
end

VolumeBox.FocusLost:Connect(function()
	SetVolume(EquaValue(VolumeBox.Text, 1))
end)

PitchBox.FocusLost:Connect(function()
	SetPitch(EquaValue(PitchBox.Text, 1))
end)

GravesBox.FocusLost:Connect(function()
	local v18 = EquaValue
	local text2 = AgudosBox.Text
	SetEqualizer(EquaValue(GravesBox.Text, 1), EquaValue(MediosBox.Text, 1), v18(text2, 1))
end)

MediosBox.FocusLost:Connect(function()
	local v18 = EquaValue
	local text2 = AgudosBox.Text
	SetEqualizer(EquaValue(GravesBox.Text, 1), EquaValue(MediosBox.Text, 1), v18(text2, 1))
end)

AgudosBox.FocusLost:Connect(function()
	local v18 = EquaValue
	local text2 = AgudosBox.Text
	SetEqualizer(EquaValue(GravesBox.Text, 1), EquaValue(MediosBox.Text, 1), v18(text2, 1))
end)

for _, child in ipairs(ScrollEqua:GetChildren()) do
	if child:IsA("ImageButton") and child.Name ~= "Resetar" then
		child.MouseButton1Click:Connect(function()
			SelecionarEqua(child)
		end)
	end
end

ResetarEqua.MouseButton1Click:Connect(function()
	SetVolume(1)
	SetPitch(1)
	SelecionarEqua(Nenhum)
	fn3(Traducao.Sucesso, Traducao.RsetadoEqua, 5)
end)

NumeroGC = function(arg)
	if arg == false then
		ContadorJA.Visible = false
		ContadorJABO.Visible = false
		ContadorJANU.Text = "0"
		ContadorJANUBO.Text = "0"
		return
	end

	ContadorJA.Visible = not flag17
	ContadorJABO.Visible = true
	local text2 = ContadorJANUBO.Text
	if text2 == "9+" then
		return
	end
	local n8 = tonumber(text2) or 1

	if n8 < 9 then
		local n9 = n8 + 1
		ContadorJANU.Text = tostring(n9)
		ContadorJANUBO.Text = tostring(n9)
	else
		ContadorJANU.Text = "9+"
		ContadorJANUBO.Text = "9+"
	end
end

if websocket_ then
	Botao5.BackgroundTransparency = 0
	Icone5.BackgroundTransparency = 0
	Icone5.ImageTransparency = 0
	Nome5.TextColor3 = Color3.fromRGB(255, 255, 255)
	Stroke(Nome5, 0, 0, 0, 1.5)
end

Tela = function(arg)
	if arg == n then
		return
	end
	local tbl13 = { Tela1, Tela2, Tela3, Tela4, Tela5, Tela6 }
	local v18 = ScrollNave:FindFirstChild("Botao" .. arg)
	if arg == 5 and v18 and v18.BackgroundTransparency > 0 then
		fn3(Traducao.Erro, Traducao.ExploitIcomGC, 5)
		return
	end
	n = arg

	if arg == 5 then
		NumeroGC(false)
	end

	for i = 1, #tbl13 do
		tbl13[i].Visible = false
	end

	fn2("102702078778790")

	for _, child in ipairs(ScrollNave:GetChildren()) do
		if child:IsA("ImageButton") then
			child.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
			local uiStroke = child:FindFirstChild("UIStroke")

			if uiStroke then
				uiStroke.Color = Color3.fromRGB(50, 50, 50)
			end

			local imageLabel = child:FindFirstChildWhichIsA("ImageLabel")

			if imageLabel then
				local uiStroke2 = imageLabel:FindFirstChild("UIStroke")

				if uiStroke2 then
					uiStroke2.Color = Color3.fromRGB(50, 50, 50)
				end
			end
		end
	end

	if tbl13[arg] then
		tbl13[arg].Visible = true
	end

	if v18 then
		local color = Color3.fromRGB(139, 0, 0)
		local color2 = Color3.fromRGB(255, 0, 0)

		if arg == 6 then
			color = Color3.fromRGB(255, 215, 0)
			color2 = Color3.fromRGB(184, 134, 11)
		end

		v18.BackgroundColor3 = color
		local uiStroke = v18:FindFirstChild("UIStroke")

		if uiStroke then
			uiStroke.Color = color2
		end

		local imageLabel = v18:FindFirstChildWhichIsA("ImageLabel")

		if imageLabel then
			local uiStroke2 = imageLabel:FindFirstChild("UIStroke")

			if uiStroke2 then
				uiStroke2.Color = color2
			end
		end
	end
end

Botao1.MouseButton1Click:Connect(function()
	Tela(1)
end)

Botao2.MouseButton1Click:Connect(function()
	Tela(2)
end)

Botao3.MouseButton1Click:Connect(function()
	Tela(3)
end)

Botao4.MouseButton1Click:Connect(function()
	Tela(4)
end)



Discord.MouseButton1Click:Connect(function()
	if flag3 then
		return
	end
	flag3 = true
	local tween4 = v6:Create(UIScaleDis, tweenInfo, { Scale = 0.9 })
	local tween5 = v6:Create(IconeDiscord, tweenInfo, { Rotation = -6 })
	tween4:Play()
	tween5:Play()
	tween4.Completed:Wait()
	local tween6 = v6:Create(UIScaleDis, tweenInfo2, { Scale = 1 })
	local tween7 = v6:Create(IconeDiscord, tweenInfo2, { Rotation = 0 })
	tween6:Play()
	tween7:Play()
	fn3(Traducao.LinkCopiado, "https://discord.gg/kbh2dEdnYP", 10)
	YmpClipboard("https://discord.gg/kbh2dEdnYP")
	tween6.Completed:Wait()
	flag3 = false
end)

You.MouseButton1Click:Connect(function()
	if flag4 then
		return
	end
	flag4 = true
	local tween4 = v6:Create(UIScaleYou, tweenInfo, { Scale = 0.9 })
	local tween5 = v6:Create(IconeYou, tweenInfo, { Rotation = -6 })
	tween4:Play()
	tween5:Play()
	tween4.Completed:Wait()
	local tween6 = v6:Create(UIScaleYou, tweenInfo2, { Scale = 1 })
	local tween7 = v6:Create(IconeYou, tweenInfo2, { Rotation = 0 })
	tween6:Play()
	tween7:Play()
	fn3("YouTube", "@Termux_404", 10)
	tween6.Completed:Wait()
	flag4 = false
end)

local tbl13 = {}
local tween4 = v6:Create(TempoAtual, tweenInfo4, { Position = UDim2.new(0, 6, 0, 6) })
local tween5 = v6:Create(TempoTotal, tweenInfo4, { Position = UDim2.new(0, 174, 0, 6) })
local tween6 = v6:Create(Repetir, tweenInfo4, { Position = UDim2.new(0.5, -35, 0.5, -54) })
local tween7 = v6:Create(Miniplayer, tweenInfo4, { Position = UDim2.new(0.5, 5, 0.5, -54) })
local create = v6.Create
local v18 = BarraProgresso
local tbl14 = { Position = UDim2.new(0, 6, 0, 103) }
tbl13[1] = tween4
tbl13[2] = tween5
tbl13[3] = tween6
tbl13[4] = tween7

do
	local values = table.pack(create(v6, v18, tweenInfo4, tbl14))
	table.move(values, 1, values.n, 5, tbl13)
end

tweensMostrar = tbl13
local tbl15 = {}
local tween8 = v6:Create(TempoAtual, tweenInfo4, { Position = UDim2.new(0, -60, 0, 6) })
local tween9 = v6:Create(TempoTotal, tweenInfo4, { Position = UDim2.new(0, 235, 0, 6) })
local tween10 = v6:Create(Repetir, tweenInfo4, { Position = UDim2.new(0.5, -35, 0.5, -120) })
local tween11 = v6:Create(Miniplayer, tweenInfo4, { Position = UDim2.new(0.5, 5, 0.5, -120) })
local create2 = v6.Create
local v19 = BarraProgresso
local tbl16 = { Position = UDim2.new(0, 6, 0, 125) }
tbl15[1] = tween8
tbl15[2] = tween9
tbl15[3] = tween10
tbl15[4] = tween11

do
	local values = table.pack(create2(v6, v19, tweenInfo4, tbl16))
	table.move(values, 1, values.n, 5, tbl15)
end

tweensOcultar = tbl15
infoTweenMini = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
listaControlesMini = { MiniBack, MiniRetroceder, MiniPlay, MiniAvancar, MiniSkip, TelaCheia, FecharMini }

Exibir = function()
	if flag6 then
		return
	end
	flag6 = true
	fn2("123430321654900")
	task.wait(0.1)
	flag5 = not flag5
	local v20 = flag5 and tweensMostrar or tweensOcultar

	for _, v21 in ipairs(v20) do
		v21:Play()
	end

	v20[1].Completed:Wait()
	flag6 = false
end

BotaoTela.MouseButton1Click:Connect(function()
	Exibir()
end)

Repetir.MouseButton1Click:Connect(function()
	if Repetir.Image == "rbxassetid://72571947341676" then
		Repetir.Image = "rbxassetid://133261841375114"
		fn3(Traducao.PlayMode, Traducao.Repetir, 8)
		str4 = "nill"
		sound2.Looped = true
		Video.Looped = true
		MiniVideo.Looped = true
	elseif Repetir.Image == "rbxassetid://133261841375114" then
		Repetir.Image = "rbxassetid://70388482182322"
		fn3(Traducao.PlayMode, Traducao.Random, 8)
		str4 = "Random"
		sound2.Looped = false
		Video.Looped = false
		MiniVideo.Looped = false
	else
		Repetir.Image = "rbxassetid://72571947341676"
		fn3(Traducao.PlayMode, Traducao.Auto, 8)
		str4 = "Auto"
		sound2.Looped = false
		Video.Looped = false
		MiniVideo.Looped = false
	end
end)

Miniplayer.MouseButton1Click:Connect(function()
	if not flag19 then
		fn3(Traducao.OpcaoBloqueadaTitle, Traducao.OpcaoBloqueadaText, 10)
		return
	end

	if BloquearMidia then
		fn3(Traducao.Aguarde, Traducao.DownloadFazendo, 5)
		return
	end

	if Miniplayer.Image == "rbxassetid://102723588572082" then
		Miniplayer.Image = "rbxassetid://84519235983477"
		fn2("85730811347567")
		SetMiniPlayer(true)
	elseif Miniplayer.Image == "rbxassetid://84519235983477" then
		Miniplayer.Image = "rbxassetid://102723588572082"
		fn2("85730811347567")
		SetMiniPlayer(false)
	end
end)

aplicarVisibilidadeMini = function(arg)
	flag11 = true
	local n8 = #listaControlesMini

	for _, v20 in ipairs(listaControlesMini) do
		if arg then
			v20.Visible = true
		end

		local tbl17 = {}

		if v20:IsA("ImageButton") or v20:IsA("ImageLabel") then
			tbl17.ImageTransparency = arg and 0 or 1
		end

		if v20:IsA("TextButton") or v20:IsA("TextLabel") then
			tbl17.TextTransparency = arg and 0 or 1
		end

		if v20.BackgroundTransparency ~= nil then
			tbl17.BackgroundTransparency = arg and 0 or 1
		end

		local tween12 = v6:Create(v20, infoTweenMini, tbl17)
		tween12:Play()

		tween12.Completed:Once(function()
			n8 -= 1

			if not arg then
				v20.Visible = false
			end

			if n8 <= 0 then
				flag11 = false
			end
		end)
	end
end

imageButton2.MouseButton1Click:Connect(function()
	if flag11 then
		return
	end

	if imageButton2:GetAttribute("Blocked") then
		return
	end

	if imageButton2:GetAttribute("Moved") then
		imageButton2:SetAttribute("Moved", false)
		return
	end
	estadoMiniUI = not estadoMiniUI
	aplicarVisibilidadeMini(estadoMiniUI)
end)

imageButton.MouseButton1Click:Connect(function()
	if imageButton:GetAttribute("Blocked") then
		return
	end

	if imageButton:GetAttribute("Moved") then
		imageButton:SetAttribute("Moved", false)
		return
	end
	imageButton.Visible = false
	frame.Visible = true

	if Tela5.Visible then
		NumeroGC(false)
	end

	fn2("122954374321453")
end)

BotaoFechar.MouseButton1Click:Connect(function()
	frame.Visible = false
	task.wait(0.2)
	imageButton.Visible = true
end)

animar = function(arg)
	if tbl8[arg] then
		return
	end
	tbl8[arg] = true
	local size = arg.Size
	local position = arg.Position

	if tbl9[arg] then
		for _, v20 in ipairs(tbl9[arg]) do
			v20:Cancel()
		end
	end

	tbl9[arg] = {}
	fn2("136328893130485")
	local tween12 = v6:Create(arg, tweenInfo5, { Size = size - UDim2.new(0, 6, 0, 6), Position = position + UDim2.new(0, 3, 0, 3) })
	local tween13 = v6:Create(arg, tweenInfo6, { Size = size, Position = position })
	local tween14 = v6:Create(arg, TweenInfo.new(0.05), { Rotation = 6 })
	local tween15 = v6:Create(arg, TweenInfo.new(0.05), { Rotation = -6 })
	local tween16 = v6:Create(arg, TweenInfo.new(0.05), { Rotation = 0 })
	table.insert(tbl9[arg], tween12)
	table.insert(tbl9[arg], tween13)
	table.insert(tbl9[arg], tween14)
	table.insert(tbl9[arg], tween15)
	table.insert(tbl9[arg], tween16)
	tween12:Play()
	tween12.Completed:Wait()
	tween13:Play()
	tween14:Play()
	tween14.Completed:Wait()
	tween15:Play()
	tween15.Completed:Wait()
	tween16:Play()
	tween16.Completed:Wait()
	tbl8[arg] = nil
end

FecharMini.MouseButton1Click:Connect(function()
	fn2("85730811347567")
	Miniplayer.Image = "rbxassetid://102723588572082"
	SetMiniPlayer(false)
end)

Voltar.MouseButton1Click:Connect(function()
	Back()
	animar(Voltar)
end)

Retroceder.MouseButton1Click:Connect(function()
	Retroceder10s()
	animar(Retroceder)
end)

Play.MouseButton1Click:Connect(function()
	Pause()
	animar(Play)
end)

Adiantar.MouseButton1Click:Connect(function()
	Avancar10s()
	animar(Adiantar)
end)

Pular.MouseButton1Click:Connect(function()
	Skip()
	animar(Pular)
end)

MiniBack.MouseButton1Click:Connect(function()
	Back()
	animar(MiniBack)
end)

MiniRetroceder.MouseButton1Click:Connect(function()
	Retroceder10s()
	animar(MiniRetroceder)
end)

MiniPlay.MouseButton1Click:Connect(function()
	Pause()
	animar(MiniPlay)
end)

MiniAvancar.MouseButton1Click:Connect(function()
	Avancar10s()
	animar(MiniAvancar)
end)

MiniSkip.MouseButton1Click:Connect(function()
	Skip()
	animar(MiniSkip)
end)

TelaCheia.MouseButton1Click:Connect(function()
	if isAnimating then
		return
	end
	isAnimating = true
	flag10 = not flag10
	local udim24

	if flag10 then
		udim24 = UDim2.new(udim2.X.Scale * 1.4, 0, udim2.Y.Scale * 1.4, 0)
		TelaCheia.Image = "rbxassetid://104681366724942"
		fn2("125296945528316")
		MiniBack.Size = UDim2.new(0.18, -8, 0.29, 0)
		MiniRetroceder.Size = UDim2.new(0.18, -8, 0.29, 0)
		MiniPlay.Size = UDim2.new(0.18, -8, 0.29, 0)
		MiniAvancar.Size = UDim2.new(0.18, -8, 0.29, 0)
		MiniSkip.Size = UDim2.new(0.18, -8, 0.29, 0)
		TelaCheia.Size = UDim2.new(0.18, -8, 0.29, 0)
		FecharMini.Size = UDim2.new(0.18, -8, 0.29, 0)
	else
		udim24 = udim2
		TelaCheia.Image = "rbxassetid://73952228795506"
		fn2("125296945528316")
		MiniBack.Size = UDim2.new(0.18, -8, 0.27, 0)
		MiniRetroceder.Size = UDim2.new(0.18, -8, 0.27, 0)
		MiniPlay.Size = UDim2.new(0.18, -8, 0.27, 0)
		MiniAvancar.Size = UDim2.new(0.18, -8, 0.27, 0)
		MiniSkip.Size = UDim2.new(0.18, -8, 0.27, 0)
		TelaCheia.Size = UDim2.new(0.18, -8, 0.27, 0)
		FecharMini.Size = UDim2.new(0.18, -8, 0.27, 0)
	end

	local tween12 = v6:Create(imageButton2, TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), { Size = udim24 })
	tween12:Play()

	tween12.Completed:Connect(function()
		isAnimating = false
	end)
end)

REPORT_ID = nil
REPORT_MOTIVO = nil

local function fn14(arg)
	if REPORT_MOTIVO == nil then
		fn3(Traducao.ReportErro, Traducao.ReportErro10, 8)
		return
	end
	local n8 = #REPORT_MOTIVO
	if n8 < 10 or n8 > 200 then
		fn3(Traducao.ReportErro, Traducao.ReportErro11, 8)
		return
	end
	Denunciar.Active = false
	CancelarReport.Active = false
	DenunciarTexto.Text = "..."
	CancelarReportTexto.Text = "..."

	local ok3, result3 = pcall(function()
		return YmpRequest({
			Url = str3 .. "/report",
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = HttpService:JSONEncode({ key = KEY_ATUAL, hwid = YmpHwid(), msgid = tostring(arg), reason = REPORT_MOTIVO }),
		})
	end)

	if ok3 then
		local str10 = tostring(result3.Body or result3):gsub("^\"", ""):gsub("\"$", "")

		if str10 == "request denied" then
			fn3(Traducao.ReportErro, Traducao.ReportErro1, 8)
		elseif str10 == "invalid report" then
			fn3(Traducao.ReportErro, Traducao.ReportErro2, 8)
		elseif str10 == "server error" then
			fn3(Traducao.ReportErro, Traducao.ReportErro3, 8)
		elseif str10 == "too many reports" then
			fn3(Traducao.ReportErro, Traducao.ReportErro4, 8)
		elseif str10 == "reporting to oneself is not allowed" then
			fn3(Traducao.ReportErro, Traducao.ReportErro5, 8)
		elseif str10 == "already reported by you" then
			fn3(Traducao.ReportErro, Traducao.ReportErro6, 8)
		elseif str10 == "already reported by another" then
			fn3(Traducao.ReportErro, Traducao.ReportErro7, 8)
		elseif str10 == "banned" then
			fn3(Traducao.ReportErro, Traducao.ReportErro8, 8)
		elseif string.find(tostring(str10), "reported") then
			fn3(Traducao.ReportSucesso, Traducao.ReportSucesso2, 8)
			task.wait(0.5)
			REPORT_ID = nil
			REPORT_MOTIVO = nil
			TextoReportFrame.Text = ""
			MotivoBox.Text = ""
			FotoReport.Image = ""
			ReportFrame.Visible = false
			frame.Visible = true
		else
			fn3(Traducao.ReportErro, Traducao.ReportErro3, 8)
		end
	else
		fn3(Traducao.ReportErro, Traducao.ReportErro3, 8)
	end

	task.wait(0.5)
	Denunciar.Active = true
	CancelarReport.Active = true
	DenunciarTexto.Text = "Report"
	CancelarReportTexto.Text = Traducao.Cancelar
end

Reportar = function(arg, arg2, image)
	REPORT_ID = arg2
	TextoReportFrame.Text = Traducao.AvisoReport1 .. " '{" .. arg .. "}' " .. Traducao.AvisoReport2
	FotoReport.Image = image
	ReportFrame.Visible = true
	frame.Visible = false
end

local function fn15(arg)
	if Warn.Visible then
		return
	end

	if v12 and v12.Playing then
		Pause()
	end

	if frame.Visible then
		frame.Visible = false
	end

	if imageButton.Visible then
		imageButton.Visible = false
	end

	if ReportFrame.Visible then
		REPORT_ID = nil
		TextoReportFrame.Text = ""
		FotoReport.Image = ""
		ReportFrame.Visible = false
	end

	task.wait(0.1)
	CloseWarn.BackgroundTransparency = 0.7
	CloseWarnTexto.TextColor3 = Color3.fromRGB(20, 20, 20)
	Warn.Visible = true
	BlurEffect.Size = 56
	fn2("107089652181213")
	TextoWarn.Text = Traducao.MsgMod .. " " .. arg
	task.wait(5)
	CloseWarn.BackgroundTransparency = 0
	CloseWarnTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
end

ProFinal = function()
	local n8 = ScrollGC.AbsoluteCanvasSize.Y - ScrollGC.AbsoluteWindowSize.Y

	if tween3 then
		tween3:Cancel()
	end

	tween3 = v6:Create(ScrollGC, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { CanvasPosition = Vector2.new(0, n8) })
	tween3:Play()
end

ChekFinal = function()
	local y = ScrollGC.CanvasPosition.Y
	return math.max(ScrollGC.AbsoluteCanvasSize.Y - ScrollGC.AbsoluteWindowSize.Y, 0) - y <= 5
end

local function fn16(arg, text2, arg2, arg3)
	layoutOrder += 1
	task.wait()

	local function fn17(arg4)
		if not (FotoTradu and FotoTradu.Image == "rbxassetid://72657045512999") then
			return arg4
		end

		local ok3, result3 = pcall(function()
			return TraduzirMsg(arg4)
		end)

		return ok3 and result3 or arg4
	end

	local v20 = fn17(arg2 or "")
	local result3 = nil

	if arg ~= "ymp" then
		local num = tonumber(arg)
		if not num then
			return
		end

		if tbl11[num] then
			result3 = tbl11[num]
		else
			local ok3

			ok3, result3 = pcall(function()
				local response = game:HttpGet("https://users.roblox.com/v1/users/" .. num)

				return {
					displayName = game:GetService("HttpService"):JSONDecode(response).displayName,
					image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. num .. "&width=420&height=420&format=png",
				}
			end)

			if not ok3 or not result3 or not result3.displayName then
				return
			end
			tbl11[num] = result3
		end
	end

	if not Tela5.Visible or imageButton.Visible == true then
		NumeroGC()
	end

	local v21 = ChekFinal()
	local frame3 = Instance.new("Frame")
	frame3.Size = UDim2.new(0.9, 0, 0, 0)
	frame3.AutomaticSize = Enum.AutomaticSize.Y
	frame3.BackgroundTransparency = 1
	frame3.BorderSizePixel = 0
	frame3.LayoutOrder = layoutOrder
	frame3.Parent = ScrollGC
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.Parent = frame3
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 10)
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = UDim2.new(0, 40, 0, 40)
	imageLabel.Position = UDim2.new(0, 1, 0, 1)
	imageLabel.BackgroundTransparency = 1
	imageLabel.Parent = frame3
	local frame4 = Instance.new("Frame")
	frame4.Size = UDim2.new(0, 60, 0, 15)
	frame4.Position = UDim2.new(0, 47, 0, 12)
	frame4.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
	frame4.BorderSizePixel = 0
	frame4.Parent = imageLabel
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Color3.fromRGB(192, 192, 192)
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextScaled = true
	textLabel.Parent = frame4
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 1)
	uiPadding.PaddingTop = UDim.new(0, 1)
	uiPadding.PaddingRight = UDim.new(0, 1)
	uiPadding.PaddingBottom = UDim.new(0, 1)
	uiPadding.Parent = textLabel
	local frame5 = Instance.new("Frame")
	frame5.Size = UDim2.new(0, 60, 0, 15)
	frame5.Position = UDim2.new(0, 112, 0, 12)
	frame5.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
	frame5.BorderSizePixel = 0
	frame5.Parent = imageLabel
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.Size = UDim2.new(1, -7, 1, 0)
	textLabel2.Position = UDim2.new(0, 4, 0, 0)
	textLabel2.BackgroundTransparency = 1
	textLabel2.TextColor3 = Color3.fromRGB(192, 192, 192)
	textLabel2.Font = Enum.Font.SourceSansBold
	textLabel2.TextScaled = true
	textLabel2.Parent = frame5
	local imageButton3 = Instance.new("ImageButton")
	imageButton3.Size = UDim2.new(0, 17, 0, 17)
	imageButton3.Position = UDim2.new(0, 177, 0, 12)
	imageButton3.BackgroundTransparency = 1
	imageButton3.BorderSizePixel = 0
	imageButton3.Parent = imageLabel
	local textLabel3 = Instance.new("TextLabel")
	textLabel3.Size = UDim2.new(1, 0, 1, 0)
	textLabel3.BackgroundTransparency = 1
	textLabel3.Font = Enum.Font.SourceSansBold
	textLabel3.TextScaled = true
	textLabel3.TextColor3 = Color3.fromRGB(192, 192, 192)
	textLabel3.Text = "C"
	textLabel3.Parent = imageButton3
	local imageButton4 = Instance.new("ImageButton")
	imageButton4.Size = UDim2.new(0, 17, 0, 17)
	imageButton4.Position = UDim2.new(0, 200, 0, 12)
	imageButton4.BackgroundTransparency = 1
	imageButton4.BorderSizePixel = 0
	imageButton4.Visible = arg ~= tostring(userId) and arg ~= "ymp"
	imageButton4.Parent = imageLabel
	local imageLabel2 = Instance.new("ImageLabel")
	imageLabel2.Size = UDim2.new(0, 10, 0, 10)
	imageLabel2.Position = UDim2.new(0, 4, 0, 4)
	imageLabel2.BackgroundTransparency = 1
	imageLabel2.Image = "rbxassetid://74995247007994"
	imageLabel2.Parent = imageButton4
	local textSize = game:GetService("TextService"):GetTextSize(v20, 16, Enum.Font.SourceSansBold, Vector2.new(170, math.huge))
	local frame6 = Instance.new("Frame")
	frame6.Size = UDim2.new(0, 180, 0, textSize.Y + 10)
	frame6.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
	frame6.BackgroundTransparency = 0.7
	frame6.BorderSizePixel = 0
	frame6.Parent = frame3
	local textLabel4 = Instance.new("TextLabel")
	textLabel4.Size = UDim2.new(0, 170, 0, textSize.Y)
	textLabel4.BackgroundTransparency = 1
	textLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel4.Font = Enum.Font.SourceSansBold
	textLabel4.TextWrapped = true
	textLabel4.TextXAlignment = Enum.TextXAlignment.Left
	textLabel4.TextYAlignment = Enum.TextYAlignment.Top
	textLabel4.TextSize = 14
	textLabel4.Text = v20
	textLabel4.Parent = frame6
	local uiPadding2 = Instance.new("UIPadding")
	uiPadding2.PaddingLeft = UDim.new(0, 5)
	uiPadding2.PaddingRight = UDim.new(0, 5)
	uiPadding2.PaddingTop = UDim.new(0, 5)
	uiPadding2.PaddingBottom = UDim.new(0, 5)
	uiPadding2.Parent = frame6

	imageButton3.MouseButton1Click:Connect(function()
		fn3(Traducao.TextoCopiado, v20, 5)
		YmpClipboard(v20)
	end)

	if arg == "ymp" then
		imageLabel.Image = "rbxassetid://83758613781843"
		imageLabel.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		textLabel.Text = "YMP OFFICIAL"
		textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
		textLabel2.Text = Traducao.Sistema
		textLabel2.TextColor3 = Color3.fromRGB(255, 0, 0)
		textLabel3.TextColor3 = Color3.fromRGB(255, 0, 0)
		Stroke(imageLabel, 255, 255, 255, 1)
		Stroke(frame4, 255, 255, 255, 1)
		Stroke(frame5, 255, 255, 255, 1)
		Stroke(imageButton3, 255, 255, 255, 1)
		Stroke(imageButton4, 255, 255, 255, 1)
		Stroke(textLabel2, 255, 255, 255, 0.5)
		Stroke(textLabel3, 255, 255, 255, 0.5)
		Stroke(textLabel, 255, 255, 255, 0.5)
	else
		imageLabel.Image = result3.image and result3.image ~= "" and result3.image or "rbxassetid://106804518898726"
		textLabel.Text = result3.displayName
		textLabel2.Text = text2
		Stroke(imageLabel, 50, 50, 50, 1)
		Stroke(frame4, 50, 50, 50, 1)
		Stroke(frame5, 50, 50, 50, 1)
		Stroke(imageButton3, 50, 50, 50, 1)
		Stroke(imageButton4, 50, 50, 50, 1)
		Stroke(textLabel, 50, 50, 50, 0.5)
	end

	Corner(imageLabel, 30)
	Corner(frame4, 30)
	Corner(frame5, 30)
	Corner(imageButton3, 30)
	Corner(imageButton4, 30)
	Corner(frame6, 5)
	Stroke(frame6, 50, 50, 50, 0.2)

	imageButton4.MouseButton1Click:Connect(function()
		if not flag19 then
			fn3(Traducao.ReportErro, Traducao.ReportErro1, 10)
			return
		end
		Reportar(text2, arg3, imageLabel.Image)
	end)

	if v21 then
		task.wait()
		ProFinal()
	end
end

local function fn17(arg, text2, arg2, arg3, arg4)
	layoutOrder += 1
	task.wait()
	local str10 = arg4 or ""

	local function fn18(arg5)
		local tbl17 = {}
		local n8 = 1

		while n8 <= #arg5 do
			local v20, v21, v22, v23 = string.find(arg5, "<:([%w_]+):(%d+)>", n8)

			if v20 then
				if v20 > n8 then
					table.insert(tbl17, { tipo = "texto", valor = string.sub(arg5, n8, v20 - 1) })
				end

				table.insert(tbl17, { tipo = "emoji", id = v23 })
				n8 = v21 + 1
			else
				table.insert(tbl17, { tipo = "texto", valor = string.sub(arg5, n8) })
				break
			end
		end

		return tbl17
	end

	local function fn19(arg5)
		if not (FotoTradu and FotoTradu.Image == "rbxassetid://72657045512999") then
			return arg5
		end

		local ok3, result3 = pcall(function()
			return TraduzirMsg(arg5)
		end)

		return ok3 and result3 or arg5
	end

	local v20 = fn18(str10)

	for _, v21 in ipairs(v20) do
		if v21.tipo == "texto" then
			v21.valor = fn19(v21.valor)
		end
	end

	local tbl17 = {}

	for _, v21 in ipairs(v20) do
		if v21.tipo == "emoji" then
			local id = v21.id
			local str11 = "YouTube Music Player/internal/Cache/emoji_" .. id .. ".png"

			if isfile and isfile(str11) then
				tbl17[id] = getcustomasset(str11)
			else
				local ok3, result3 = pcall(function()
					return game:HttpGet("https://cdn.discordapp.com/emojis/" .. id .. ".png")
				end)

				ok3 = ok3 and result3 and writefile
				local str12 = "rbxassetid://110787075859454"

				if ok3 then
					if pcall(function()
						writefile(str11, result3)
					end) and getcustomasset then
						str12 = getcustomasset(str11)
					end
				end

				tbl17[id] = str12
			end
		end
	end

	local str11 = "YouTube Music Player/internal/Cache/Dc_" .. tostring(arg) .. ".jpg"
	local image

	if isfile and isfile(str11) then
		image = getcustomasset(str11)
	else
		local ok3, result3 = pcall(function()
			return game:HttpGet(arg3)
		end)

		ok3 = ok3 and writefile
		image = "rbxassetid://106804518898726"

		if ok3 then
			if pcall(function()
				writefile(str11, result3)
			end) and getcustomasset then
				image = getcustomasset(str11)
			end
		end
	end

	if not Tela5.Visible or imageButton.Visible == true then
		NumeroGC()
	end

	local v21 = ChekFinal()
	local frame3 = Instance.new("Frame")
	frame3.Size = UDim2.new(0.9, 0, 0, 0)
	frame3.AutomaticSize = Enum.AutomaticSize.Y
	frame3.BackgroundTransparency = 1
	frame3.BorderSizePixel = 0
	frame3.LayoutOrder = layoutOrder
	frame3.Parent = ScrollGC
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.Parent = frame3
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 10)
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = UDim2.new(0, 40, 0, 40)
	imageLabel.Position = UDim2.new(0, 4, 0, 4)
	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = image
	imageLabel.Parent = frame3
	local frame4 = Instance.new("Frame")
	frame4.Size = UDim2.new(0, 60, 0, 15)
	frame4.Position = UDim2.new(0, 47, 0, 12)
	frame4.Parent = imageLabel
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.Position = UDim2.new(0, 0, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = text2 or ""
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextScaled = true
	textLabel.Parent = frame4
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 1)
	uiPadding.PaddingTop = UDim.new(0, 1)
	uiPadding.PaddingRight = UDim.new(0, 1)
	uiPadding.PaddingBottom = UDim.new(0, 1)
	uiPadding.Parent = textLabel
	local frame5 = Instance.new("Frame")
	frame5.Size = UDim2.new(0, 60, 0, 15)
	frame5.Position = UDim2.new(0, 112, 0, 12)
	frame5.BorderSizePixel = 0
	frame5.Parent = imageLabel
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.Size = UDim2.new(1, -7, 1, 0)
	textLabel2.Position = UDim2.new(0, 4, 0, 0)
	textLabel2.BackgroundTransparency = 1
	textLabel2.Font = Enum.Font.SourceSansBold
	textLabel2.TextScaled = true
	textLabel2.Parent = frame5
	local frame6 = Instance.new("Frame")
	frame6.Size = UDim2.new(1, -10, 0, 0)
	frame6.AutomaticSize = Enum.AutomaticSize.Y
	frame6.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
	frame6.BackgroundTransparency = 0.7
	frame6.Parent = frame3
	local uiPadding2 = Instance.new("UIPadding")
	uiPadding2.PaddingLeft = UDim.new(0, 5)
	uiPadding2.PaddingRight = UDim.new(0, 5)
	uiPadding2.PaddingTop = UDim.new(0, 5)
	uiPadding2.PaddingBottom = UDim.new(0, 5)
	uiPadding2.Parent = frame6
	local imageButton3 = Instance.new("ImageButton")
	imageButton3.Size = UDim2.new(0, 17, 0, 17)
	imageButton3.Position = UDim2.new(0, 177, 0, 12)
	imageButton3.BorderSizePixel = 0
	imageButton3.Parent = imageLabel
	local textLabel3 = Instance.new("TextLabel")
	textLabel3.Size = UDim2.new(1, -7, 1, 0)
	textLabel3.Position = UDim2.new(0, 3, 0, 0)
	textLabel3.BackgroundTransparency = 1
	textLabel3.Font = Enum.Font.SourceSansBold
	textLabel3.TextScaled = true
	textLabel3.Text = "C"
	textLabel3.Parent = imageButton3
	local uiListLayout2 = Instance.new("UIListLayout")
	uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout2.Wraps = true
	uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout2.Padding = UDim.new(0, 2)
	uiListLayout2.Parent = frame6
	local uiPadding3 = Instance.new("UIPadding")
	uiPadding3.PaddingLeft = UDim.new(0, 5)
	uiPadding3.PaddingTop = UDim.new(0, 5)
	uiPadding3.PaddingRight = UDim.new(0, 5)
	uiPadding3.PaddingBottom = UDim.new(0, 5)
	uiPadding3.Parent = frame6

	imageButton3.MouseButton1Click:Connect(function()
		fn3(Traducao.TextoCopiado, arg4, 5)
		YmpClipboard(arg4)
	end)

	local function fn20(text3)
		if text3 == "" then
			return
		end
		local textLabel4 = Instance.new("TextLabel")
		textLabel4.BackgroundTransparency = 1
		textLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel4.Font = Enum.Font.SourceSansBold
		textLabel4.TextSize = 14
		textLabel4.TextWrapped = true
		textLabel4.TextXAlignment = Enum.TextXAlignment.Left
		textLabel4.TextYAlignment = Enum.TextYAlignment.Top
		textLabel4.Text = text3
		local textSize = game:GetService("TextService"):GetTextSize(text3, 16, Enum.Font.SourceSansBold, Vector2.new(170, math.huge))
		local max = math.max
		local y = textSize.Y
		textLabel4.Size = UDim2.new(0, math.min(textSize.X, 170), 0, max(y, 21))
		textLabel4.Parent = frame6
	end

	local function fn21(arg5)
		local imageLabel2 = Instance.new("ImageLabel")
		imageLabel2.Size = UDim2.new(0, 21, 0, 21)
		imageLabel2.BackgroundTransparency = 1
		imageLabel2.Image = tbl17[arg5]
		imageLabel2.Parent = frame6
	end

	for _, v22 in ipairs(v20) do
		if v22.tipo == "texto" then
			fn20(v22.valor)
		else
			fn21(v22.id)
		end
	end

	if arg2 == "Mod" then
		textLabel.TextColor3 = Color3.fromRGB(255, 160, 122)
		frame4.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		frame5.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		imageButton3.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		textLabel2.Text = "Mod"
		textLabel2.TextColor3 = Color3.fromRGB(255, 160, 122)
		textLabel3.TextColor3 = Color3.fromRGB(255, 160, 122)
		Stroke(frame4, 255, 160, 122, 1)
		Stroke(imageLabel, 255, 160, 122, 1.5)
		Stroke(frame5, 255, 160, 122, 1)
		Stroke(imageButton3, 255, 160, 122, 1)
		Stroke(textLabel, 0, 0, 0, 1)
		Stroke(textLabel2, 0, 0, 0, 1)
		Stroke(textLabel3, 0, 0, 0, 1)
	elseif arg2 == "Admin" then
		textLabel.TextColor3 = Color3.fromRGB(220, 20, 60)
		frame4.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		frame5.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		imageButton3.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		textLabel2.Text = "Admin"
		textLabel2.TextColor3 = Color3.fromRGB(220, 20, 60)
		textLabel3.TextColor3 = Color3.fromRGB(220, 20, 60)
		Stroke(frame4, 220, 20, 60, 1)
		Stroke(imageLabel, 220, 20, 60, 1)
		Stroke(frame5, 220, 20, 60, 1)
		Stroke(imageButton3, 220, 20, 60, 1)
		Stroke(textLabel, 0, 0, 0, 1)
		Stroke(textLabel2, 0, 0, 0, 1)
		Stroke(textLabel3, 0, 0, 0, 1)
	elseif arg2 == "Dev" then
		textLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
		frame4.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		frame5.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		imageButton3.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		textLabel2.Text = "Dev"
		textLabel2.TextColor3 = Color3.fromRGB(255, 215, 0)
		textLabel3.TextColor3 = Color3.fromRGB(255, 215, 0)
		Stroke(frame4, 0, 0, 0, 1.5)
		Stroke(imageLabel, 0, 0, 0, 1.5)
		Stroke(textLabel, 0, 0, 0, 1)
		Stroke(frame5, 0, 0, 0, 1.5)
		Stroke(imageButton3, 0, 0, 0, 1.5)
		Stroke(textLabel2, 0, 0, 0, 1)
		Stroke(textLabel3, 0, 0, 0, 1)
	else
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		frame4.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		frame5.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		imageButton3.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		textLabel2.Text = "Discord"
		textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
		Stroke(frame4, 255, 255, 255, 1)
		Stroke(imageLabel, 255, 255, 255, 1)
		Stroke(textLabel, 0, 0, 0, 0.5)
		Stroke(frame5, 255, 255, 255, 1)
		Stroke(imageButton3, 255, 255, 255, 1)
		Stroke(textLabel2, 0, 0, 0, 0.5)
		Stroke(textLabel3, 0, 0, 0, 0.5)
	end

	Corner(imageLabel, 30)
	Corner(frame4, 30)
	Corner(frame5, 30)
	Corner(imageButton3, 30)
	Corner(frame6, 5)
	Stroke(frame6, 50, 50, 50, 0.2)

	if v21 then
		task.wait()
		ProFinal()
	end
end

IndoFinal = function(arg)
	if arg == v13 then
		return
	end
	estadoAtual = arg
	local v20 = arg and udim23 or udim22

	if v13 then
		tween2:Cancel()
	end

	tween2 = v6:Create(FinalGC, tweenInfo3, { Position = v20 })
	tween2:Play()
end

ScrollGC:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
	local y = ScrollGC.CanvasPosition.Y
	local flag22 = math.max(ScrollGC.AbsoluteCanvasSize.Y - ScrollGC.AbsoluteWindowSize.Y, 0) - y <= 120

	if flag22 ~= flag15 then
		flag15 = flag22
		IndoFinal(flag22)
	end
end)

FinalGC.MouseButton1Click:Connect(function()
	ProFinal()
end)

ScrollGC.ChildAdded:Connect(function()
	local tbl17 = {}
	EsperandoIMG.Visible = false
	ScrollGC.Visible = true

	for _, child in ipairs(ScrollGC:GetChildren()) do
		if child:IsA("Frame") then
			table.insert(tbl17, child)
		end
	end

	if #tbl17 > 30 then
		table.sort(tbl17, function(arg, arg2)
			return arg.LayoutOrder < arg2.LayoutOrder
		end)

		task.wait()
		tbl17[1]:Destroy()
	end
end)

local function fn18(arg)
	MsgErroGC.Visible = true
	MsgErroGC.Text = Traducao.GcBan .. " " .. tostring(arg or "")
	GCBox.Active = false
	GCBox.Visible = false
	SendGC.Visible = false
	Traduzir.Visible = false
	LinhaTraducao.Visible = false
	fn3(Traducao.Banido, Traducao.GcBan .. " " .. tostring(arg or ""), 10)
end

local function fn19()
	fn3(Traducao.Desbanido, Traducao.GcUnban, 10)

	if flag19 then
		MsgErroGC.Visible = false
		GCBox.Active = true
		GCBox.Visible = true
		SendGC.Visible = true
		Traduzir.Visible = true
		LinhaTraducao.Visible = true
	else
		MsgErroGC.Text = Traducao.GcKey
	end
end

local function fn20(arg)
	if arg == flag20 then
		return
	end

	if flag19 then
		return
	end

	if arg then
		if not flag16 and websocket_ ~= nil then
			flag20 = true
			MsgErroGC.Visible = false
			GCBox.Active = true
			GCBox.Visible = true
			SendGC.Visible = true
			Traduzir.Visible = true
			LinhaTraducao.Visible = true
			fn3(Traducao.Keyless, Traducao.KeylessOn, 15, 93360393539898)
		end
	elseif not flag19 and not flag16 then
		flag20 = false
		MsgErroGC.Visible = true
		MsgErroGC.Text = Traducao.GcKey
		GCBox.Active = false
		GCBox.Visible = false
		SendGC.Visible = false
		Traduzir.Visible = false
		LinhaTraducao.Visible = false
		fn3(Traducao.Keyless, Traducao.KeylessOff, 15, 93360393539898)
	end
end

hwidUrl = "wss://ymp-api.ddns.net/gc" .. "?hwid=" .. tostring(YmpHwid())

task.spawn(function()
	local flag22 = false
	local v20 = nil
	local n8 = 0
	local n9 = 0

	local function fn21()
		if not websocket_ then
			return
		end

		if flag22 then
			return
		end
		flag22 = true
		n8 += 1

		local ok3, result3 = pcall(function()
			local connect = websocket_.connect or websocket_.Connect or websocket_.new or websocket_.New
			if not connect then
				return nil
			end
			return connect(hwidUrl)
		end)

		if not ok3 or not result3 then
			flag22 = false
			return
		end
		v20 = result3
		flag22 = false

		if v20.OnClose then
			v20.OnClose:Connect(function()
				v20 = nil
			end)
		end

		local onMessage = result3.OnMessage or result3.onmessage or result3.MessageReceived

		if onMessage then
			onMessage:Connect(function(arg)
				if not arg then
					return
				end

				if arg == "keyless" then
					fn20(true)
					return
				end

				if arg == "unkeyless" then
					fn20(false)
					return
				end

				if arg:sub(1, 6) == "banned" then
					local match = arg:match("banned:%s*(%S+)")
					flag16 = true
					fn18(match)
					return
				end

				if arg == "unbanned" then
					flag16 = false
					fn19()
					return
				end

				if arg:sub(1, 6) == "warned" then
					fn15(arg:match("reason:%s*(.+)") or "")
					return
				end

				if arg:sub(1, 6) == "system" then
					local match = arg:match("message:%s*(.+)")

					if match then
						fn16("ymp", "a", match, "0")
						fn3(Traducao.Sistema, match, 10)
					else
						local match2 = arg:match("system\n(.+)")

						if match2 then
							fn16("ymp", "a", match2, "0")
						end
					end

					return
				end

				if arg:sub(1, 7) == "discord" then
					local match = arg:match("id:%s*([^\n]+)")
					local match2 = arg:match("name:%s*([^\n]+)")
					local match3 = arg:match("rank:%s*([^\n]+)")
					local match4 = arg:match("image:%s*([^\n]*)")
					local match5 = arg:match("message:%s*(.+)")

					if match and match2 and match3 and match5 then
						fn17(match, match2, match3, match4 ~= "" and match4 or nil, match5)
					end

					return
				end

				local match = arg:match("UserId:%s*(%d+)")
				local match2 = arg:match("id:%s*(%S+)")
				local match3 = arg:match("message:%s*(.+)")
				local match4 = arg:match("msgid:%s*(%d+)")

				if match and match2 and match3 then
					fn16(match, match2, match3, match4)
				end
			end)
		end
	end

	task.spawn(function()
		while task.wait(2) do
			if websocket_ then
				if not flag22 then
					if not v20 then
						if not (os.clock() - n9 < 3) then
							n9 = os.clock()
							fn21()
						end
					end
				end
			end
		end
	end)

	fn21()
end)

local function fn21(arg)
	if not arg or arg == "" then
		return
	end

	if not CheckRequest() then
		return
	end

	local v20 = YmpRequest({
		Url = str3 .. "/sendgc",
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = HttpService:JSONEncode({ key = KEY_ATUAL, hwid = YmpHwid(), Userid = userId, msg = arg }),
	})

	if v20 and v20.Body then
		local str10 = tostring(v20.Body):gsub("%s+", ""):gsub("\"", "")

		if str10 == "banned" then
			flag16 = true
			fn18()
		elseif str10 == "requestdenied" then
			fn3(Traducao.ErroCrackTitle, Traducao.ErroCrackText, 10)
		end
	end

	return v20
end

SendGC.MouseButton1Click:Connect(function()
	if Aviao.ImageTransparency ~= 0 then
		return
	end
	local text2 = GCBox.Text

	if text2 and text2 ~= "" then
		GCBox.Text = ""
		Aviao.ImageTransparency = 0.7
		fn21(text2)
		task.wait(3)
		Aviao.ImageTransparency = 0
	end
end)

GCBox.FocusLost:Connect(function()
	local match = GCBox.Text:gsub("[\r\n]", ""):match("^%s*(.-)%s*$")
	if match == "" then
		GCBox.Text = ""
		return
	end

	if #match > 200 then
		match = match:sub(1, 200)
	end

	GCBox.Text = match
end)

Regras.MouseButton1Click:Connect(function()
	fn3(Traducao.RegrasTi, Traducao.Regras, 10)
end)

NotificarGC.MouseButton1Click:Connect(function()
	if Sino.Image == "rbxassetid://115374069603142" then
		Sino.Image = "rbxassetid://89973491623305"
		fn3(Traducao.GCmudo, Traducao.GCmudoTexto, 6)
		flag17 = true
	else
		Sino.Image = "rbxassetid://115374069603142"
		fn3(Traducao.GCunmudo, Traducao.GCunmudoTexto, 6)
		flag17 = false
	end
end)

Denunciar.MouseButton1Click:Connect(function()
	if not Denunciar.Active then
		return
	end
	fn14(REPORT_ID)
end)

MotivoBox.FocusLost:Connect(function()
	local match = MotivoBox.Text:match("^%s*(.-)%s*$")

	if match == "" then
		MotivoBox.Text = ""
		REPORT_MOTIVO = nil
	else
		REPORT_MOTIVO = match
	end
end)

CancelarReport.MouseButton1Click:Connect(function()
	if not CancelarReport.Active then
		return
	end
	REPORT_ID = nil
	REPORT_MOTIVO = nil
	TextoReportFrame.Text = ""
	MotivoBox.Text = ""
	FotoReport.Image = ""
	ReportFrame.Visible = false
	frame.Visible = true
end)

CloseWarn.MouseButton1Click:Connect(function()
	if CloseWarn.BackgroundTransparency ~= 0 then
		return
	end
	Warn.Visible = false
	BlurEffect.Size = 0
	imageButton.Visible = true
	fn2("88442833509532")
end)

Traduzir.MouseButton1Click:Connect(function()
	if FotoTradu.Image == "rbxassetid://84867288877251" then
		FotoTradu.Image = "rbxassetid://72657045512999"
		fn3(Traducao.TraducaoSystem, Traducao.TraduOn, 5)
	else
		FotoTradu.Image = "rbxassetid://84867288877251"
		fn3(Traducao.TraducaoSystem, Traducao.TraduOff, 5)
	end
end)

Priv1.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri1, 8)
end)

Priv2.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri2, 8)
end)

Priv3.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri3, 8)
end)

Priv4.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri4, 8)
end)

Priv5.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri5, 8)
end)

Priv6.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri6, 8)
end)

local function fn22()
	pcall(function()
		game:GetService("Players").LocalPlayer:Kick("[Sussy Activity]\nPlease do not attempt to crack the script!")
	end)

	pcall(function()
		game:GetService("Players").LocalPlayer:Remove()
	end)

	pcall(function()
		game:GetService("Players").LocalPlayer:Destroy()
	end)

	pcall(function()
		game:GetService("Players").LocalPlayer.Parent = nil
	end)

	task.wait(2)

	while true do
	end
end

LockedUIS = { Video, imageButton2, frame2 }

for _, v20 in ipairs(LockedUIS) do
	if v20:IsA("GuiObject") then
		v20:GetPropertyChangedSignal("Visible"):Connect(function()
			if v20.Visible == true and flag19 == false then
				fn22()
			end
		end)
	end
end

SetKey = function(key)
	task.spawn(function()
		table.insert(tbl7, function()
			local ok3, result3 = pcall(function()
				return HttpService:JSONDecode(readfile("YouTube Music Player/Internal/Data.json"))
			end)

			local v20 = ok3 and result3
			local tbl17

			if v20 then
				tbl17 = v20
			else
				tbl17 = { { Key = "", Favorites = tbl6 or {} } }
			end

			tbl17[1] = tbl17[1] or { Key = "", Favorites = {} }
			tbl17[1].Key = key or ""

			pcall(function()
				writefile("YouTube Music Player/Internal/Data.json", HttpService:JSONEncode(tbl17))
			end)
		end)

		processQueue()
	end)
end

local function fn23()
	if flag19 == true then
		return
	end
	flag19 = true
	KeyFrame.Visible = false
	GetKey.Visible = false
	PremiumOkTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.VocePremium .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.VocePremiumTexto .. "</font>"
	frame2.Visible = true
	imageButton2.Parent = screenGui
	Video.Parent = Tela2
	BotaoMp4.BackgroundTransparency = 0
	NomeMp4.TextColor3 = Color3.fromRGB(154, 205, 50)
	BotaoMp4.AutoButtonColor = true
	AplicarFiltro.BackgroundTransparency = 0
	RemoverFiltro.BackgroundTransparency = 0
	NomeAplicarFiltro.TextColor3 = Color3.fromRGB(154, 205, 50)
	NomeRemoverFiltro.TextColor3 = Color3.fromRGB(178, 34, 34)
	AplicarFiltro.AutoButtonColor = true
	RemoverFiltro.AutoButtonColor = true
	PesquisarBox.PlaceholderText = Traducao.Pesquisar2
	imageButton.Image = "rbxassetid://76673896881913"
	fn3(Traducao.VocePremium, Traducao.VocePremiumTexto, 15)
	imageButton.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
	Stroke(imageButton, 255, 215, 0, 3)

	if not flag16 and websocket_ ~= nil and not flag20 then
		MsgErroGC.Visible = false
		GCBox.Active = true
		GCBox.Visible = true
		SendGC.Visible = true
		Traduzir.Visible = true
		LinhaTraducao.Visible = true
	end

	for _, child in ipairs(ScrollPagina:GetChildren()) do
		if child:IsA("ImageButton") and child.Name ~= "1" then
			child.BackgroundTransparency = 0
			local textLabel = child:FindFirstChildOfClass("TextLabel")

			if textLabel then
				textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			end
		end
	end

	for _, v20 in ipairs(scrolls) do
		for _, child in ipairs(v20:GetChildren()) do
			if child:IsA("ImageButton") and not child:GetAttribute("Privado") then
				local match = child.Name:match(":(.+)$")
				child.Name:match("^(.-):")
				local tag = child:FindFirstChild("tag")
				local imageLabel = child:FindFirstChildWhichIsA("ImageLabel")

				if match and tag and imageLabel then
					if match == "Video" or match == "Roblox" then
						child.BackgroundTransparency = 0
						imageLabel.BackgroundTransparency = 0
						imageLabel.ImageTransparency = 0
						tag.TextColor3 = Color3.fromRGB(255, 255, 255)
					end
				end
			end
		end
	end
end

-- Enable Premium UI locally for everyone without requiring a key entry.
task.defer(function()
	pcall(fn23)
end)

Token = nil

local function fn24()
	pcall(function()
		local fn25

		fn25 = function(arg, arg2)
			local tbl17 = arg2 or {}
			local kind = typeof(arg)
			if kind == "nil" then
				return "nil"
			end

			if kind == "string" then
				return arg
			end

			if kind == "number" then
				if arg ~= arg then
					return "nan"
				end
				local str10 = ""

				if arg < 0 then
					arg = -arg
					str10 = "-"
				end

				local n8 = math.floor(arg)
				local n9 = arg - n8
				local str11 = ""

				repeat
					str11 = string.char(48 + n8 % 10) .. str11
					n8 = math.floor(n8 / 10)
				until n8 == 0

				if n9 > 0 then
					str11 ..= "."
					local n10 = 0

					while n9 > 0 and n10 < 6 do
						local n11 = n9 * 10
						local n12 = math.floor(n11)
						str11 ..= string.char(48 + n12)
						n9 = n11 - n12
						n10 += 1
					end
				end

				return str10 .. str11
			end

			if kind == "boolean" then
				if arg then
					return "true"
				end
				return "false"
			end

			if kind == "table" then
				if tbl17[arg] then
					return "{cycle}"
				end
				tbl17[arg] = true
				local tbl18 = {}

				for k, v20 in pairs(arg) do
					table.insert(tbl18, "[" .. fn25(k, tbl17) .. "]=" .. fn25(v20, tbl17))
				end

				return "{ " .. table.concat(tbl18, ", ") .. " }"
			end

			return "<" .. kind .. ">"
		end

		local jobId = game.JobId
		local str10 = HttpService:GenerateGUID(false) .. HttpService:GenerateGUID(false) .. jobId .. tick() .. os.clock() .. os.time() .. os.date("%Y%m%d%H%M%S") .. math.random() .. fn25({})
		local n8 = 2166136261

		for i = 1, #str10 do
			local v20 = string.byte(str10, i)
			local n9 = bit32.bxor(n8, v20) * 16777619 % 4294967296
			n8 = bit32.bxor(n9, bit32.rshift(n9, 13)) * 2246822519 % 4294967296
		end

		math.randomseed(n8)
		local str11 = ""
		local n9 = 1

		while true do
			local n10 = math.random(1, 62)
			local str12 = str11 .. string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789", n10, n10)
			local n11 = bit32.bxor(n8, n10 * n9) * 3266489917 % 4294967296
			n8 = bit32.bxor(n11, bit32.lshift(n11, 11))

			if #str12 > 10 and bit32.band(n8, 3) == 0 then
				local n12 = math.floor(#str12 / 2)
				local str13 = string.sub(str12, 1, n12)
				str12 = string.sub(str12, n12 + 1) .. str13
			end

			if #str12 > 15 and bit32.band(n8, 7) == 1 then
				str11 = ""

				for i = #str12, 1, -1 do
					str11 ..= string.sub(str12, i, i)
				end
			else
				str11 = str12
			end

			local v20 = bit32.band(n8, 15)
			if not (#str11 > 110 and v20 == 0 or #str11 > 111) then
				n9 += 1
				continue
			end
			break
		end

		Token = str11
	end)
end

local function fn25(arg)
	local tbl17 = { bit32.bxor, bit32.lrotate, string.byte, string.format, tostring }

	if typeof(ishooked) == "function" and typeof(restorefunction) == "function" then
		local ok3, result3 = pcall(ishooked, ishooked)

		if ok3 and result3 then
			pcall(restorefunction, ishooked)
		end

		local v20 = ishooked

		for _, v21 in ipairs(tbl17) do
			local ok4, result4 = pcall(v20, v21)
			if not ok4 or result4 then
				return
			end
		end
	end

	local function fn26(arg2)
		local str10 = tostring(arg2 or "nil")
		local n8 = 2246822507
		local n9 = 3266489909
		local n10 = 2146245185

		for i = 1, #str10 do
			local v20 = string.byte(str10, i)
			n8 = (bit32.lrotate(bit32.bxor(n8, v20 + i), 13) * 5 + 3864292196) % 4294967296
			n9 = (bit32.lrotate(bit32.bxor(n9, n8 + v20), 17) * 3 + 2246822507) % 4294967296
			n10 = (bit32.lrotate(bit32.bxor(n10, n9 + i), 19) * 7 + 2815685321) % 4294967296
		end

		local v20 = bit32.bxor(n8, n9, n10, 2674666769)
		local str11 = string.format("%08x%08x%08x%08x%08x", n8, n9, n10, 2674666769, v20)
		return (str11 .. string.reverse(str11)):sub(1, 40)
	end

	if arg == fn26(Token) and #Token > 110 then
		fn23()
	else
		SetKey("")
	end
end

local function fn26(arg)
	local now = os.clock()
	local flag22 = false
	local str10 = nil

	task.spawn(function()
		local v20 = HttpService
		local str11 = str3 .. "/check/" .. arg .. "/" .. YmpHwid() .. "/" .. v20:UrlEncode(Token)

		local ok3, result3 = pcall(function()
			return game:HttpGet(str11)
		end)

		if not CheckRequest() then
			fn3(Traducao.Erro, Traducao.FalhaAoChekar, 10)
			KeyBox.Active = true
			str10 = "error"
			flag22 = true
			return
		end

		if not (ok3 and result3) then
			fn3(Traducao.Erro, Traducao.FalhaAoChekar, 10)
			KeyBox.Active = true
			str10 = "error"
			flag22 = true
			return
		end

		local v21 = string.lower(result3)

		if string.find(v21, "request denied") then
			str10 = "invalid"
			flag22 = true
			return
		end

		if string.find(v21, "too many request") then
			str10 = "too"
			flag22 = true
			return
		end

		if string.find(v21, "already registered") then
			str10 = "already"
			flag22 = true
			return
		end

		local v22 = string.match(result3, "Ok:%s*(.+)")

		if not v22 then
			str10 = "error"
			flag22 = true
			return
		end

		task.wait(1)
		fn25(v22)
		SetKey(arg)
		str10 = "ok"
		flag22 = true
	end)

	while not flag22 do
		if os.clock() - now > 10 then
			return "error"
		end
		task.wait()
	end

	return str10 or "error"
end

local function fn27()
	if CACHE_LINK ~= nil then
		YmpClipboard(CACHE_LINK)
		fn3(Traducao.LinkCopiado, Traducao.Navegador, 10)
		return CACHE_LINK
	end

	if not CheckRequest() then
		return nil
	end

	local ok3, result3 = pcall(function()
		return game:HttpGet(str3 .. "/getkey?hwid=" .. tostring(YmpHwid()))
	end)

	if not ok3 or not result3 then
		fn3("Premium Key", Traducao.KeyError, 5)
		return nil
	end
	local data2 = nil

	pcall(function()
		data2 = game:GetService("HttpService"):JSONDecode(result3)
	end)

	if not data2 or not data2.success or not data2.url then
		fn3("Premium Key", Traducao.KeyError, 5)
		return nil
	end
	CACHE_LINK = data2.url
	YmpClipboard(CACHE_LINK)
	fn3(Traducao.LinkCopiado, Traducao.Navegador, 10)
	return CACHE_LINK
end

SetaES.MouseButton1Click:Connect(function()
	if GetKey.BackgroundColor3 == Color3.fromRGB(47, 79, 79) then
		GetKey.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		SetaES.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		SetaDI.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		GetKeyTexto.Text = Traducao.Robux
		GetKeyTexto.TextColor3 = Color3.fromRGB(255, 255, 153)
	elseif GetKey.BackgroundColor3 == Color3.fromRGB(255, 215, 0) then
		GetKey.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		SetaES.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		SetaDI.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		GetKeyTexto.Text = Traducao.Link
		GetKeyTexto.TextColor3 = Color3.fromRGB(70, 130, 180)
	end
end)

SetaDI.MouseButton1Click:Connect(function()
	if GetKey.BackgroundColor3 == Color3.fromRGB(47, 79, 79) then
		GetKey.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		SetaES.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		SetaDI.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		GetKeyTexto.Text = Traducao.Robux
		GetKeyTexto.TextColor3 = Color3.fromRGB(255, 255, 153)
	elseif GetKey.BackgroundColor3 == Color3.fromRGB(255, 215, 0) then
		GetKey.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		SetaES.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		SetaDI.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
		GetKeyTexto.Text = Traducao.Link
		GetKeyTexto.TextColor3 = Color3.fromRGB(70, 130, 180)
	end
end)

local function fn28(text2)
	fn3("Premium Key", text2, 5)
	KeyBox.Active = false
	KeyBox.TextColor3 = Color3.fromRGB(255, 0, 0)
	KeyBox.Text = text2
	task.wait(2)
	KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	KeyBox.Text = ""
	KeyBox.Active = true
end

local function fn29()
	if KEY_ATUAL and KEY_ATUAL ~= "" then
		KeyBox.Active = false
		fn24()

		if not KEY_ATUAL:match("^KEY_") and not KEY_ATUAL:match("^FREE_") then
			fn28(Traducao.KeyInvalida)
			SetKey("")
			return
		end

		local v20 = fn26(KEY_ATUAL)
		if v20 == true then
			return
		end

		if v20 == "invalid" then
			fn28(Traducao.KeyInvalida)
			SetKey("")
		elseif v20 == "error" then
			fn28(Traducao.KeyErro)
		elseif v20 == "already" then
			fn28(Traducao.JaTemKey)
		elseif v20 == "too" then
			fn28(Traducao.RateLi)
		end
	end
end

KeyBox.FocusLost:Connect(function()
	if KeyBox.Active and KeyBox.Text then
		local match = KeyBox.Text:match("^%s*(.-)%s*$")
		if match == "" then
			KeyBox.Text = ""
			return
		end
		KEY_ATUAL = match
		fn29()
	end
end)

GetKey.MouseButton1Click:Connect(function()
	if GetKey.BackgroundColor3 == Color3.fromRGB(255, 215, 0) then
		fn3(Traducao.LinkCopiado, "https://www.roblox.com/games/113089627618447/CHAOTIC-Purchase", 8)
		YmpClipboard("https://www.roblox.com/games/113089627618447/CHAOTIC-Purchase")
	elseif GetKey.BackgroundColor3 == Color3.fromRGB(47, 79, 79) then
		fn27()
	end
end)

uiScale = frame:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", frame)

Resize = function()
	local viewportSize = currentCamera.ViewportSize
	uiScale.Scale = math.min(viewportSize.X * 0.8 / frame.AbsoluteSize.X / uiScale.Scale, viewportSize.Y * 0.8 / frame.AbsoluteSize.Y / uiScale.Scale, 1)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)

	task.defer(function()
		if flag8 then
			return
		end
		local v20 = v12
		local flag22 = v12

		if v20 then
			flag22 = v20.TimeLength > 0
		end

		if flag22 then
			setProgress(v20.TimePosition / v20.TimeLength)
		end
	end)
end

ResizeJa = function()
	imageButton.AnchorPoint = Vector2.new(0.5, 0)
	imageButton.Position = UDim2.new(0.5, 0, 0, 20)
end

ResizeMiniPlayer = function()
	local viewportSize = currentCamera.ViewportSize

	if viewportSize.Y > viewportSize.X then
		udim2 = UDim2.new(0.45, 0, 0.1, 0)
	else
		udim2 = UDim2.new(0.27, 0, 0.37, 0)
	end

	local udim24

	if flag10 then
		udim24 = UDim2.new(udim2.X.Scale * 1.4, 0, udim2.Y.Scale * 1.4, 0)
	else
		udim24 = udim2
	end

	imageButton2.Size = udim24
	imageButton2.Position = UDim2.new(1, -20, 1, -20)
end

currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	Resize()
	ResizeJa()
	ResizeMiniPlayer()
end)

Resize()
ResizeJa()
ResizeMiniPlayer()

game:GetService("GuiService").MenuOpened:Connect(function()
	if flag or not frame.Visible then
		return
	end
	frame.Visible = false
	imageButton.Visible = true
end)

v5.MessageOut:Connect(function(arg)
	if type(arg) ~= "string" then
		return
	end
	local str10 = arg:lower():gsub("%s+", "")

	if str10:match("^failedtoloadrbxasset://.+%.mp3$") or str10:match("^failedtoloadrbxasset://.+%.webm$") then
		fn3(Traducao.MidiaErro, Traducao.MidiaErroMsg, 10)
	end
end)

Corner(frame, 5)
Corner(imageButton, 30)
Corner(ContadorJA, 30)
Corner(ContadorJABO, 30)
Corner(Titulo, 30)
Corner(Mutar, 30)
Corner(BotaoFechar, 22)
Corner(Welcome, 5)
Corner(Navegacao, 5)
Corner(Playlist, 5)
Corner(TituloNave, 32)
Corner(FotoNave, 32)
Corner(TituloPlayL, 32)
Corner(FotoPlayL, 32)
Corner(Botao1, 5)
Corner(Botao2, 5)
Corner(Botao3, 5)
Corner(Botao4, 5)
Corner(Botao5, 5)
Corner(Botao6, 5)
Corner(Icone1, 5)
Corner(Icone2, 5)
Corner(Icone3, 5)
Corner(Icone4, 5)
Corner(Icone5, 5)
Corner(Icone6, 5)
Corner(EsquerdaPL, 5)
Corner(FrameAbaPL, 5)
Corner(DireitaPL, 5)
Corner(ErroPL, 5)
Corner(Social, 5)
Corner(SocialTitulo, 5)
Corner(You, 32)
Corner(IconeYou, 32)
Corner(Discord, 32)
Corner(IconeDiscord, 32)
Corner(Musica, 5)
Corner(Video, 5)
Corner(TempoAtual, 5)
Corner(TempoTotal, 5)
Corner(Repetir, 30)
Corner(Novamente, 30)
Corner(Miniplayer, 30)
Corner(BarraProgresso, 30)
Corner(Rastro, 30)
Corner(BolaProgresso, 30)
Corner(MicroBola, 10)
Corner(PlayerInfo, 5)
Corner(FotoAutor, 50)
Corner(Disco, 50)
Corner(Controles, 5)
Corner(Voltar, 40)
Corner(Retroceder, 40)
Corner(Play, 40)
Corner(Adiantar, 40)
Corner(Pular, 40)
Corner(MiniMusica, 10)
Corner(MiniVideo, 10)
Corner(MiniBack, 2, 0)
Corner(MiniRetroceder, 2, 0)
Corner(MiniPlay, 1, 0)
Corner(MiniAvancar, 1, 0)
Corner(MiniSkip, 1, 0)
Corner(TelaCheia, 1, 0)
Corner(FecharMini, 1, 0)
Corner(TituloEqua, 5)
Corner(EquaFrame, 5)
Corner(NoEquaFrame, 5)
Corner(ErroEqua, 5)
Corner(Volume, 5)
Corner(IconeVolume, 5)
Corner(Pitch, 5)
Corner(IconePitch, 5)
Corner(FrequenciaTitulo, 5)
Corner(Graves, 5)
Corner(IconeGraves, 5)
Corner(Medios, 5)
Corner(IconeMedios, 5)
Corner(Agudos, 5)
Corner(IconeAgudos, 5)
Corner(EfeitosTitulo, 5)
Corner(Nenhum, 5)
Corner(IconeNenhum, 5)
Corner(Reverb, 5)
Corner(IconeReverb, 5)
Corner(Echo, 5)
Corner(IconeEcho, 5)
Corner(Distortion, 5)
Corner(IconeDistortion, 5)
Corner(Chorus, 5)
Corner(IconeChorus, 5)
Corner(Flanger, 5)
Corner(IconeFlanger, 5)
Corner(Tremolo, 5)
Corner(IconeTremolo, 5)
Corner(Compressor, 5)
Corner(IconeCompressor, 5)
Corner(Radio, 5)
Corner(IconeRadio, 5)
Corner(Cinema, 5)
Corner(IconeCinema, 5)
Corner(Underwater, 5)
Corner(IconeUnderwater, 5)
Corner(Kid, 5)
Corner(IconeKid, 5)
Corner(Robot, 5)
Corner(IconeRobot, 5)
Corner(Slowed, 5)
Corner(IconeSlowed, 5)
Corner(ResetarEqua, 5)
Corner(Pesquisa, 5)
Corner(Lupa, 5)
Corner(Filtro, 5)
Corner(DownloadFrame, 5)
Corner(PaginaFrame, 5)
Corner(PaginaEsperandoFrame, 5)
Corner(PaginaEsperandoIcon, 5)
Corner(SemResultadoTexto, 5)
Corner(ErroTexto, 5)
Corner(Tutorial, 30)
Corner(BaixandoTexto, 5)
Corner(DownloadFrameTexto, 5)
Corner(Relevancia, 5)
Corner(DataUpload, 5)
Corner(Duracao, 5)
Corner(IconeRelevancia, 5)
Corner(IconeDataUpload, 5)
Corner(IconeDuracao, 5)
Corner(AplicarFiltro, 5)
Corner(RemoverFiltro, 5)
Corner(Thumbfor, 5)
Corner(Titulofor, 5)
Corner(TituloFiltro, 30)
Corner(TituloFormato, 30)
Corner(BotaoMp3, 5)
Corner(BotaoMp4, 5)
Corner(BotaoCancelar, 5)
Corner(TituloGC, 5)
Corner(GCFrame, 5)
Corner(Traduzir, 5)
Corner(SendGC, 5)
Corner(MsgFrame, 5)
Corner(AvisoGC, 30)
Corner(FinalGC, 32)
Corner(TituloPremium, 5)
Corner(Privilegios, 5)
Corner(Priv1, 35)
Corner(Priv2, 35)
Corner(Priv3, 35)
Corner(Priv4, 35)
Corner(Priv5, 35)
Corner(Priv6, 35)
Corner(IconePriv1, 35)
Corner(IconePriv2, 35)
Corner(IconePriv3, 35)
Corner(IconePriv4, 35)
Corner(IconePriv5, 35)
Corner(IconePriv6, 35)
Corner(frame2, 5)
Corner(PremiumOkTexto, 5)
Corner(KeyFrame, 5)
Corner(SendKey, 5)
Corner(GetKey, 5)
Corner(SetaES, 5)
Corner(SetaDI, 5)
Corner(ReportFrame, 5)
Corner(TituloReportFrame, 30)
Corner(TextoReportFrameFrame, 5)
Corner(Motivo, 5)
Corner(CancelarReport, 7)
Corner(FotoReport, 50)
Corner(Denunciar, 7)
Corner(Warn, 5)
Corner(TituloWarn, 30)
Corner(TextoWarnFrame, 5)
Corner(CloseWarn, 7)
Stroke(frame, 255, 0, 0, 5)
Stroke(imageButton, 255, 255, 255, 3)
Stroke(ContadorJA, 255, 255, 255, 1)
Stroke(ContadorJANU, 255, 255, 255, 0.5)
Stroke(ContadorJABO, 255, 255, 255, 1)
Stroke(ContadorJANUBO, 255, 255, 255, 0.5)
Stroke(Mutar, 255, 255, 255, 1)
Stroke(BotaoFechar, 255, 255, 255, 1)
Stroke(Titulo, 50, 50, 50, 1.5)
Stroke(TextoTitulo, 0, 0, 0, 1.5)
Stroke(Welcome, 50, 50, 50, 1.5)
Stroke(NomeWelcome, 255, 255, 255, 1)
Stroke(Navegacao, 50, 50, 50, 1.5)
Stroke(Playlist, 50, 50, 50, 1.5)
Stroke(TituloNave, 255, 255, 255, 1)
Stroke(FotoNave, 255, 255, 255, 1)
Stroke(NomeNave, 255, 255, 255, 1)
Stroke(TituloPlayL, 255, 255, 255, 1)
Stroke(FotoPlayL, 255, 255, 255, 1)
Stroke(NomePlayL, 255, 255, 255, 1)
Stroke(AbaPL, 255, 255, 255, 1)
Stroke(Botao1, 255, 0, 0, 2)
Stroke(Botao2, 50, 50, 50, 2)
Stroke(Botao3, 50, 50, 50, 2)
Stroke(Botao4, 50, 50, 50, 2)
Stroke(Botao5, 50, 50, 50, 2)
Stroke(Botao6, 50, 50, 50, 2)
Stroke(Icone1, 255, 0, 0, 2)
Stroke(Icone2, 50, 50, 50, 2)
Stroke(Icone3, 50, 50, 50, 2)
Stroke(Icone4, 50, 50, 50, 2)
Stroke(Icone5, 50, 50, 50, 2)
Stroke(Icone6, 50, 50, 50, 2)
Stroke(Nome1, 0, 0, 0, 1.5)
Stroke(Nome2, 0, 0, 0, 1.5)
Stroke(Nome3, 0, 0, 0, 1.5)
Stroke(Nome4, 0, 0, 0, 1.5)
Stroke(Nome6, 0, 0, 0, 1.5)
Stroke(EsquerdaPL, 255, 255, 255, 1)
Stroke(FrameAbaPL, 255, 255, 255, 1)
Stroke(DireitaPL, 255, 255, 255, 1)
Stroke(Social, 50, 50, 50, 1.5)
Stroke(SocialTitulo, 50, 50, 50, 1.5)
Stroke(SocialTexto, 0, 0, 0, 2)
Stroke(Discord, 0, 0, 0, 1.5)
Stroke(IconeDiscord, 0, 0, 0, 1.5)
Stroke(TextoDiscord, 0, 0, 0, 1.5)
Stroke(You, 255, 255, 255, 1.5)
Stroke(IconeYou, 255, 255, 255, 1.5)
Stroke(TextoYou, 0, 0, 0, 1.5)
Stroke(Musica, 50, 50, 50, 1.5)
Stroke(Video, 50, 50, 50, 1.5)
Stroke(TempoAtual, 50, 50, 50, 1)
Stroke(TempoTotal, 50, 50, 50, 1)
Stroke(Repetir, 50, 50, 50, 1)
Stroke(Novamente, 50, 50, 50, 1)
Stroke(Miniplayer, 50, 50, 50, 1)
Stroke(BolaProgresso, 255, 255, 255, 1)
Stroke(BarraProgresso, 50, 50, 50, 1.5)
Stroke(PlayerInfo, 50, 50, 50, 1.5)
Stroke(FotoAutor, 178, 34, 34, 1.5)
Stroke(Disco, 178, 34, 34, 1.5)
Stroke(Controles, 178, 34, 34, 1.5)
Stroke(Voltar, 255, 255, 255, 1)
Stroke(Retroceder, 255, 255, 255, 1)
Stroke(Play, 255, 255, 255, 1)
Stroke(Adiantar, 255, 255, 255, 1)
Stroke(Pular, 255, 255, 255, 1)
Stroke(TituloMusica, 0, 0, 0, 1)
Stroke(MiniMusica, 255, 255, 255, 1, 0.5)
Stroke(MiniVideo, 255, 255, 255, 1, 0.5)
Stroke(TituloEqua, 50, 50, 50, 1.5)
Stroke(NomeEqua, 255, 255, 255, 1)
Stroke(EquaFrame, 50, 50, 50, 1.5)
Stroke(NoEquaFrame, 50, 50, 50, 1.5)
Stroke(Volume, 50, 50, 50, 2)
Stroke(IconeVolume, 50, 50, 50, 2)
Stroke(VolumeBox, 0, 0, 0, 1)
Stroke(Pitch, 50, 50, 50, 2)
Stroke(IconePitch, 50, 50, 50, 2)
Stroke(PitchBox, 0, 0, 0, 1)
Stroke(FrequenciaTitulo, 50, 50, 50, 2)
Stroke(TextoFrenquencia, 255, 255, 255, 0.4)
Stroke(Graves, 50, 50, 50, 2)
Stroke(IconeGraves, 50, 50, 50, 2)
Stroke(GravesBox, 0, 0, 0, 1)
Stroke(Medios, 50, 50, 50, 2)
Stroke(IconeMedios, 50, 50, 50, 2)
Stroke(MediosBox, 0, 0, 0, 1)
Stroke(Agudos, 50, 50, 50, 2)
Stroke(IconeAgudos, 50, 50, 50, 2)
Stroke(AgudosBox, 0, 0, 0, 1)
Stroke(EfeitosTitulo, 50, 50, 50, 2)
Stroke(Nenhum, 255, 0, 0, 2)
Stroke(IconeNenhum, 255, 0, 0, 2)
Stroke(NenhumTexto, 0, 0, 0, 1)
Stroke(Reverb, 50, 50, 50, 2)
Stroke(IconeReverb, 50, 50, 50, 2)
Stroke(ReverbTexto, 0, 0, 0, 1)
Stroke(Echo, 50, 50, 50, 2)
Stroke(IconeEcho, 50, 50, 50, 2)
Stroke(EchoTexto, 0, 0, 0, 1)
Stroke(Distortion, 50, 50, 50, 2)
Stroke(IconeDistortion, 50, 50, 50, 2)
Stroke(DistortionTexto, 0, 0, 0, 1)
Stroke(Chorus, 50, 50, 50, 2)
Stroke(IconeChorus, 50, 50, 50, 2)
Stroke(ChorusTexto, 0, 0, 0, 1)
Stroke(Flanger, 50, 50, 50, 2)
Stroke(IconeFlanger, 50, 50, 50, 2)
Stroke(FlangerTexto, 0, 0, 0, 1)
Stroke(Tremolo, 50, 50, 50, 2)
Stroke(IconeTremolo, 50, 50, 50, 2)
Stroke(TremoloTexto, 0, 0, 0, 1)
Stroke(Compressor, 50, 50, 50, 2)
Stroke(IconeCompressor, 50, 50, 50, 2)
Stroke(CompressorTexto, 0, 0, 0, 1)
Stroke(Radio, 50, 50, 50, 2)
Stroke(IconeRadio, 50, 50, 50, 2)
Stroke(RadioTexto, 0, 0, 0, 1)
Stroke(Cinema, 50, 50, 50, 2)
Stroke(IconeCinema, 50, 50, 50, 2)
Stroke(CinemaTexto, 0, 0, 0, 1)
Stroke(Underwater, 50, 50, 50, 2)
Stroke(IconeUnderwater, 50, 50, 50, 2)
Stroke(UnderwaterTexto, 0, 0, 0, 1)
Stroke(Kid, 50, 50, 50, 2)
Stroke(IconeKid, 50, 50, 50, 2)
Stroke(KidTexto, 0, 0, 0, 1)
Stroke(Robot, 50, 50, 50, 2)
Stroke(IconeRobot, 50, 50, 50, 2)
Stroke(RobotTexto, 0, 0, 0, 1)
Stroke(Slowed, 50, 50, 50, 2)
Stroke(IconeSlowed, 50, 50, 50, 2)
Stroke(SlowedTexto, 0, 0, 0, 1)
Stroke(ResetarEqua, 20, 20, 20, 2)
Stroke(ResetarTexto, 255, 255, 255, 1)
Stroke(TextoEfeitos, 255, 255, 255, 0.4)
Stroke(Pesquisa, 50, 50, 50, 1.5)
Stroke(Lupa, 50, 50, 50, 1.5)
Stroke(PesquisarBox, 255, 0, 0, 0.3)
Stroke(Filtro, 50, 50, 50, 2)
Stroke(Tutorial, 50, 50, 50, 1.5)
Stroke(TutoTexto, 255, 255, 255, 0.5)
Stroke(DownloadFrame, 50, 50, 50, 1.5)
Stroke(PaginaFrame, 50, 50, 50, 1.5)
Stroke(PaginaEsperandoFrame, 50, 50, 50, 1.5)
Stroke(PaginaEsperandoIcon, 50, 50, 50, 1.5)
Stroke(Relevancia, 50, 50, 50, 2)
Stroke(DataUpload, 50, 50, 50, 2)
Stroke(Duracao, 50, 50, 50, 2)
Stroke(IconeRelevancia, 50, 50, 50, 2)
Stroke(IconeDataUpload, 50, 50, 50, 2)
Stroke(IconeDuracao, 50, 50, 50, 2)
Stroke(AplicarFiltro, 50, 50, 50, 2)
Stroke(RemoverFiltro, 50, 50, 50, 2)
Stroke(Thumbfor, 50, 50, 50, 1.5)
Stroke(Titulofor, 50, 50, 50, 1.5)
Stroke(BotaoMp3, 50, 50, 50, 1.5)
Stroke(BotaoMp4, 50, 50, 50, 1.5)
Stroke(BotaoCancelar, 50, 50, 50, 1.5)
Stroke(TituloGC, 50, 50, 50, 1.5)
Stroke(NomeGC, 255, 255, 255, 1)
Stroke(GCFrame, 50, 50, 50, 1.5)
Stroke(MsgFrame, 50, 50, 50, 1)
Stroke(Traduzir, 50, 50, 50, 1)
Stroke(SendGC, 50, 50, 50, 1)
Stroke(FinalGC, 255, 255, 255, 1)
Stroke(TituloPremium, 50, 50, 50, 1.5)
Stroke(NomePremium, 0, 0, 200, 1)
Stroke(Privilegios, 50, 50, 50, 1.5)
Stroke(Priv1, 0, 0, 0, 2)
Stroke(Priv2, 0, 0, 0, 2)
Stroke(Priv3, 0, 0, 0, 2)
Stroke(Priv4, 0, 0, 0, 2)
Stroke(Priv5, 0, 0, 0, 2)
Stroke(Priv6, 0, 0, 0, 2)
Stroke(IconePriv1, 0, 0, 0, 2)
Stroke(IconePriv2, 0, 0, 0, 2)
Stroke(IconePriv3, 0, 0, 0, 2)
Stroke(IconePriv4, 0, 0, 0, 1.5)
Stroke(IconePriv5, 0, 0, 0, 2)
Stroke(IconePriv6, 0, 0, 0, 2)
Stroke(TextoPriv1, 0, 0, 0, 1)
Stroke(TextoPriv2, 0, 0, 0, 1)
Stroke(TextoPriv3, 0, 0, 0, 1)
Stroke(TextoPriv4, 0, 0, 0, 1)
Stroke(TextoPriv5, 0, 0, 0, 1)
Stroke(TextoPriv6, 0, 0, 0, 1)
Stroke(frame2, 50, 50, 50, 1.5)
Stroke(KeyFrame, 50, 50, 50, 1.5)
Stroke(SendKey, 50, 50, 50, 1.5)
Stroke(KeyBox, 0, 0, 0, 1.5)
Stroke(GetKey, 0, 0, 0, 1.5)
Stroke(SetaES, 0, 0, 0, 1.5)
Stroke(SetaDI, 0, 0, 0, 1.5)
Stroke(GetKeyTexto, 0, 0, 0, 1.5)
Stroke(ReportFrame, 255, 0, 0, 5)
Stroke(TituloReportFrame, 50, 50, 50, 1.5)
Stroke(TextoTituloReportFrame, 0, 0, 0, 1.5)
Stroke(TextoReportFrameFrame, 50, 50, 50, 1.5)
Stroke(CancelarReport, 0, 0, 0, 1.5)
Corner(Regras, 30)
Corner(NotificarGC, 30)
Stroke(Motivo, 50, 50, 50, 1)
Stroke(FotoReport, 50, 50, 50, 1.5)
Stroke(Denunciar, 0, 0, 0, 1.5)
Stroke(DenunciarTexto, 0, 0, 0, 1.5)
Stroke(CancelarReportTexto, 0, 0, 0, 1.5)
Stroke(Warn, 255, 0, 0, 5)
Stroke(TituloWarn, 50, 50, 50, 1.5)
Stroke(TextoTituloWarn, 0, 0, 0, 1.5)
Stroke(TextoWarnFrame, 50, 50, 50, 1.5)
Stroke(CloseWarn, 0, 0, 0, 1.5)
Stroke(CloseWarnTexto, 0, 0, 0, 1.5)

local ok3, result3 = pcall(function()
	return game:HttpGet(str3 .. "/iskeyless")
end)

if ok3 and result3 and CheckRequest() and string.gsub(result3, "%s+", "") == "{\"keyless\":true}" then
	fn20(true)
	task.wait(3)
end

pcall(function()
	local data2 = HttpService:JSONDecode(readfile("YouTube Music Player/Internal/Data.json"))

	if data2[1] and data2[1].Key and data2[1].Key ~= "" then
		KEY_ATUAL = data2[1].Key
		KeyBox.Text = KEY_ATUAL
		fn29()
	end
end)

Carregar()
task.wait(0.5)
frame.Visible = true

]=]

skibidiMusicBtn.MouseButton1Click:Connect(function()
    if skibidiMusicStarted then
        skibidiMusicBtn.Text = "OPENED"
        return
    end
    if type(loadstring) ~= "function" then
        skibidiMusicBtn.Text = "NO LOADSTRING"
        return
    end
    skibidiMusicBtn.Text = "LOADING..."
    local ok, chunk = pcall(loadstring, skibidiMusicSource)
    if not ok or type(chunk) ~= "function" then
        skibidiMusicBtn.Text = "ERROR"
        warn("[Skibidi Music] Failed to compile: "..tostring(chunk))
        return
    end
    local ran, err = pcall(chunk)
    if not ran then
        skibidiMusicBtn.Text = "ERROR"
        warn("[Skibidi Music] Failed to start: "..tostring(err))
        return
    end
    skibidiMusicStarted = true
    skibidiMusicBtn.Text = "OPENED"
end)


-- ============================================================
-- RIVALS SKIN CHANGER CONFIG
-- ============================================================
local skinChangerRow = Instance.new("Frame")
skinChangerRow.Size = UDim2.new(1,0,0,38)
skinChangerRow.BackgroundColor3 = C.row
skinChangerRow.BackgroundTransparency = 0.5
skinChangerRow.BorderSizePixel = 0
skinChangerRow.LayoutOrder = 5.5
skinChangerRow.Parent = cfgPage
guiCorner(skinChangerRow,10); guiStroke(skinChangerRow,C.divider,1)

local skinChangerLbl = Instance.new("TextLabel",skinChangerRow)
skinChangerLbl.Size = UDim2.new(0.65,0,1,0)
skinChangerLbl.Position = UDim2.new(0,12,0,0)
skinChangerLbl.BackgroundTransparency = 1
skinChangerLbl.Text = "Rivals Skin Changer"
skinChangerLbl.TextColor3 = C.text
skinChangerLbl.TextSize = 11
skinChangerLbl.Font = Enum.Font.GothamBold
skinChangerLbl.TextXAlignment = Enum.TextXAlignment.Left

local skinChangerBtn = Instance.new("TextButton",skinChangerRow)
skinChangerBtn.Size = UDim2.new(0,72,0,24)
skinChangerBtn.Position = UDim2.new(1,-82,0.5,-12)
skinChangerBtn.BackgroundColor3 = C.input
skinChangerBtn.BorderSizePixel = 0
skinChangerBtn.Text = "OPEN"
skinChangerBtn.TextColor3 = C.text
skinChangerBtn.TextSize = 10
skinChangerBtn.Font = Enum.Font.GothamBold
skinChangerBtn.AutoButtonColor = false
guiCorner(skinChangerBtn,6); guiStroke(skinChangerBtn,C.divider,1)

local skinChangerSource = [=[
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local playerScripts = player.PlayerScripts
local controllers = playerScripts.Controllers
local EnumLibrary = require(ReplicatedStorage.Modules:WaitForChild("EnumLibrary", 10))
if EnumLibrary then EnumLibrary:WaitForEnumBuilder() end
local CosmeticLibrary = require(ReplicatedStorage.Modules:WaitForChild("CosmeticLibrary", 10))
local ItemLibrary = require(ReplicatedStorage.Modules:WaitForChild("ItemLibrary", 10))
local DataController = require(controllers:WaitForChild("PlayerDataController", 10))
local equipped, favorites = {}, {}
local constructingWeapon, viewingProfile = nil, nil

local function cloneCosmetic(name, cosmeticType, options)
    local base = CosmeticLibrary.Cosmetics[name]
    if not base then return nil end
    local data = {}
    for key, value in pairs(base) do data[key] = value end
    data.Name = name
    data.Type = data.Type or cosmeticType
    data.Seed = data.Seed or math.random(1, 1000000)
    if EnumLibrary then
        local success, enumId = pcall(EnumLibrary.ToEnum, EnumLibrary, name)
        if success and enumId then data.Enum, data.ObjectID = enumId, data.ObjectID or enumId end
    end
    if options then
        if options.inverted ~= nil then data.Inverted = options.inverted end
        if options.favoritesOnly ~= nil then data.OnlyUseFavorites = options.favoritesOnly end
    end
    return data
end

local saveFile = "Rivals-Skinchanger/skins.txt"
local function saveConfig()
    if not writefile then return end
    pcall(function()
        local config = {equipped = {}, favorites = favorites}
        for weapon, cosmetics in pairs(equipped) do
            config.equipped[weapon] = {}
            for cosmeticType, cosmeticData in pairs(cosmetics) do
                if cosmeticData and cosmeticData.Name then
                    config.equipped[weapon][cosmeticType] = {
                        name = cosmeticData.Name, seed = cosmeticData.Seed, inverted = cosmeticData.Inverted
                    }
                end
            end
        end
        makefolder("Rivals-Skinchanger")
        writefile(saveFile, HttpService:JSONEncode(config))
    end)
end

local function loadConfig()
    if not readfile or not isfile or not isfile(saveFile) then return end
    pcall(function()
        local config = HttpService:JSONDecode(readfile(saveFile))
        if config.equipped then
            for weapon, cosmetics in pairs(config.equipped) do
                equipped[weapon] = {}
                for cosmeticType, cosmeticData in pairs(cosmetics) do
                    local cloned = cloneCosmetic(cosmeticData.name, cosmeticType, {inverted = cosmeticData.inverted})
                    if cloned then cloned.Seed = cosmeticData.seed equipped[weapon][cosmeticType] = cloned end
                end
            end
        end
        favorites = config.favorites or {}
    end)
end

local function isFinisher(cosmetic)
    if not cosmetic then return false end
    local t = cosmetic.Type
    return t == "Finisher" or t == "Finish" or (t and string.find(t:lower(), "finish"))
end

local function isEmote(cosmetic)
    if not cosmetic then return false end
    local t = cosmetic.Type
    return t == "Dance" or t == "Emote"
end

local origOwnsCosmetic = CosmeticLibrary.OwnsCosmetic
CosmeticLibrary.OwnsCosmetic = function(self, inventory, name, weapon)
    if name:find("MISSING_") then return origOwnsCosmetic(self, inventory, name, weapon) end
    local cosmetic = CosmeticLibrary.Cosmetics[name]
    if cosmetic then return true end
    return origOwnsCosmetic(self, inventory, name, weapon)
end

local originalGet = DataController.Get
DataController.Get = function(self, key)
    local data = originalGet(self, key)
    if key == "CosmeticInventory" then
        local proxy = {}
        if data then for k, v in pairs(data) do
            local cosmetic = CosmeticLibrary.Cosmetics[k]
            if cosmetic then proxy[k] = v end
        end end
        return setmetatable(proxy, {__index = function(t, k)
            local cosmetic = CosmeticLibrary.Cosmetics[k]
            if cosmetic then return true end
            return nil
        end})
    end
    if key == "FavoritedCosmetics" then
        local result = data and table.clone(data) or {}
        for weapon, favs in pairs(favorites) do
            result[weapon] = result[weapon] or {}
            for name, isFav in pairs(favs) do
                local cosmetic = CosmeticLibrary.Cosmetics[name]
                if cosmetic then result[weapon][name] = isFav end
            end
        end
        return result
    end
    return data
end

local originalGetWeaponData = DataController.GetWeaponData
DataController.GetWeaponData = function(self, weaponName)
    local data = originalGetWeaponData(self, weaponName)
    if not data then return nil end
    local merged = {}
    for key, value in pairs(data) do merged[key] = value end
    merged.Name = weaponName
    if equipped[weaponName] then
        for cosmeticType, cosmeticData in pairs(equipped[weaponName]) do
            if cosmeticType ~= "Dances" then merged[cosmeticType] = cosmeticData end
        end
    end
    return merged
end

local FighterController
pcall(function() FighterController = require(controllers:WaitForChild("FighterController", 10)) end)

if hookmetamethod then
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local dataRemotes = remotes and remotes:FindFirstChild("Data")
    local equipRemote = dataRemotes and dataRemotes:FindFirstChild("EquipCosmetic")
    local favoriteRemote = dataRemotes and dataRemotes:FindFirstChild("FavoriteCosmetic")
    local replicationRemotes = remotes and remotes:FindFirstChild("Replication")
    local fighterRemotes = replicationRemotes and replicationRemotes:FindFirstChild("Fighter")
    local useItemRemote = fighterRemotes and fighterRemotes:FindFirstChild("UseItem")

    if equipRemote then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            if getnamecallmethod() ~= "FireServer" then return oldNamecall(self, ...) end
            local args = {...}
            if useItemRemote and self == useItemRemote then
                local objectID = args[1]
                if FighterController then
                    pcall(function()
                        local fighter = FighterController:GetFighter(player)
                        if fighter and fighter.Items then
                            for _, item in pairs(fighter.Items) do
                                if item:Get("ObjectID") == objectID then lastUsedWeapon = item.Name break end
                            end
                        end
                    end)
                end
            end
            if self == equipRemote then
                local weaponName, cosmeticType, cosmeticName, options = args[1], args[2], args[3], args[4] or {}
                local cosmetic = CosmeticLibrary.Cosmetics[cosmeticName]
                -- For finishers and emotes/dances: let remote fire, but update local state
                if cosmetic and (isFinisher(cosmetic) or isEmote(cosmetic)) then
                    if isEmote(cosmetic) then
                        equipped.Dances = equipped.Dances or {}
                        if not cosmeticName or cosmeticName == "None" or cosmeticName == "" then
                            equipped.Dances[cosmeticType] = nil
                        else
                            local cloned = cloneCosmetic(cosmeticName, cosmeticType, {inverted = options.IsInverted, favoritesOnly = options.OnlyUseFavorites})
                            if cloned then equipped.Dances[cosmeticType] = cloned end
                        end
                    else
                        equipped[weaponName] = equipped[weaponName] or {}
                        if not cosmeticName or cosmeticName == "None" or cosmeticName == "" then
                            equipped[weaponName][cosmeticType] = nil
                            if not next(equipped[weaponName]) then equipped[weaponName] = nil end
                        else
                            local cloned = cloneCosmetic(cosmeticName, cosmeticType, {inverted = options.IsInverted, favoritesOnly = options.OnlyUseFavorites})
                            if cloned then equipped[weaponName][cosmeticType] = cloned end
                        end
                    end
                    saveConfig()
                    -- Let the remote fire to server
                    return oldNamecall(self, ...)
                end
                -- For other cosmetics (skins, charms, wraps): block remote and handle locally
                if cosmeticName and cosmeticName ~= "None" and cosmeticName ~= "" then
                    local inventory = DataController:Get("CosmeticInventory")
                    if inventory and rawget(inventory, cosmeticName) then return oldNamecall(self, ...) end
                end
                -- Non-emote, non-finisher: handle locally
                equipped[weaponName] = equipped[weaponName] or {}
                if not cosmeticName or cosmeticName == "None" or cosmeticName == "" then
                    equipped[weaponName][cosmeticType] = nil
                    if not next(equipped[weaponName]) then equipped[weaponName] = nil end
                else
                    local cloned = cloneCosmetic(cosmeticName, cosmeticType, {inverted = options.IsInverted, favoritesOnly = options.OnlyUseFavorites})
                    if cloned then equipped[weaponName][cosmeticType] = cloned end
                end
                task.defer(function()
                    pcall(function() DataController.CurrentData:Replicate("WeaponInventory") end)
                    task.wait(0.2)
                    saveConfig()
                end)
                return
            end
            if self == favoriteRemote then
                local cosmetic = CosmeticLibrary.Cosmetics[args[2]]
                if cosmetic then
                    favorites[args[1]] = favorites[args[1]] or {}
                    favorites[args[1]][args[2]] = args[3] or nil
                    saveConfig()
                    task.spawn(function() pcall(function() DataController.CurrentData:Replicate("FavoritedCosmetics") end) end)
                end
                return
            end
            return oldNamecall(self, ...)
        end)
    end
end

local ClientItem
pcall(function() ClientItem = require(player.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem) end)

if ClientItem and ClientItem._CreateViewModel then
    local originalCreateViewModel = ClientItem._CreateViewModel
    ClientItem._CreateViewModel = function(self, viewmodelRef)
        local weaponName = self.Name
        local weaponPlayer = self.ClientFighter and self.ClientFighter.Player
        constructingWeapon = (weaponPlayer == player) and weaponName or nil
        if weaponPlayer == player and equipped[weaponName] and viewmodelRef then
            local dataKey, skinKey, charmKey, wrapKey, nameKey = self:ToEnum("Data"), self:ToEnum("Skin"), self:ToEnum("Charm"), self:ToEnum("Wrap"), self:ToEnum("Name")
            local data = viewmodelRef[dataKey] or viewmodelRef.Data
            if data then
                if equipped[weaponName].Skin then data[skinKey or "Skin"] = equipped[weaponName].Skin end
                if equipped[weaponName].Charm then data[charmKey or "Charm"] = equipped[weaponName].Charm end
                if equipped[weaponName].Wrap then data[wrapKey or "Wrap"] = equipped[weaponName].Wrap end
                if equipped[weaponName].Skin then data[nameKey or "Name"] = equipped[weaponName].Skin.Name end
            end
        end
        local result = originalCreateViewModel(self, viewmodelRef)
        constructingWeapon = nil
        return result
    end
end

local viewModelModule = player.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
if viewModelModule then
    local ClientViewModel = require(viewModelModule)
    local originalNew = ClientViewModel.new
    ClientViewModel.new = function(replicatedData, clientItem)
        local weaponPlayer = clientItem.ClientFighter and clientItem.ClientFighter.Player
        local weaponName = constructingWeapon or clientItem.Name
        if weaponPlayer == player and equipped[weaponName] then
            local ReplicatedClass = require(ReplicatedStorage.Modules.ReplicatedClass)
            local dataKey = ReplicatedClass:ToEnum("Data")
            replicatedData[dataKey] = replicatedData[dataKey] or {}
            local cosmetics = equipped[weaponName]
            if cosmetics.Skin then replicatedData[dataKey][ReplicatedClass:ToEnum("Skin")] = cosmetics.Skin end
            if cosmetics.Charm then replicatedData[dataKey][ReplicatedClass:ToEnum("Charm")] = cosmetics.Charm end
            if cosmetics.Wrap then replicatedData[dataKey][ReplicatedClass:ToEnum("Wrap")] = cosmetics.Wrap end
        end
        local result = originalNew(replicatedData, clientItem)
        if weaponPlayer == player and equipped[weaponName] and equipped[weaponName].Wrap and result._UpdateWrap then
            result:_UpdateWrap()
            task.delay(0.1, function() if not result._destroyed then result:_UpdateWrap() end end)
        end
        return result
    end
    if ClientViewModel.GetCharm then
        local originalGetCharmFunc = ClientViewModel.GetCharm
        ClientViewModel.GetCharm = function(self)
            local weaponName = self.ClientItem and self.ClientItem.Name
            local weaponPlayer = self.ClientItem and self.ClientItem.ClientFighter and self.ClientItem.ClientFighter.Player
            if weaponName and weaponPlayer == player and equipped[weaponName] and equipped[weaponName].Charm then
                return equipped[weaponName].Charm
            end
            return originalGetCharmFunc(self)
        end
    end
    if ClientViewModel.GetWrap then
        local originalGetWrapFunc = ClientViewModel.GetWrap
        ClientViewModel.GetWrap = function(self)
            local weaponName = self.ClientItem and self.ClientItem.Name
            local weaponPlayer = self.ClientItem and self.ClientItem.ClientFighter and self.ClientItem.ClientFighter.Player
            if weaponName and weaponPlayer == player and equipped[weaponName] and equipped[weaponName].Wrap then
                return equipped[weaponName].Wrap
            end
            return originalGetWrapFunc(self)
        end
    end
end

local originalGetViewModelImage = ItemLibrary.GetViewModelImageFromWeaponData
ItemLibrary.GetViewModelImageFromWeaponData = function(self, weaponData, highRes)
    if not weaponData then return originalGetViewModelImage(self, weaponData, highRes) end
    local weaponName = weaponData.Name
    local shouldShowSkin = (weaponData.Skin and equipped[weaponName] and weaponData.Skin == equipped[weaponName].Skin) or (viewingProfile == player and equipped[weaponName] and equipped[weaponName].Skin)
    if shouldShowSkin and equipped[weaponName] and equipped[weaponName].Skin then
        local skinInfo = self.ViewModels[equipped[weaponName].Skin.Name]
        if skinInfo then return skinInfo[highRes and "ImageHighResolution" or "Image"] or skinInfo.Image end
    end
    return originalGetViewModelImage(self, weaponData, highRes)
end

local EmoteController
pcall(function()
    EmoteController = require(controllers:WaitForChild("EmoteController", 10))
    if EmoteController and EmoteController.GetEmotes then
        local originalGetEmotes = EmoteController.GetEmotes
        EmoteController.GetEmotes = function(self)
            local emotes = originalGetEmotes(self)
            for name, cosmetic in pairs(CosmeticLibrary.Cosmetics) do
                if cosmetic and (cosmetic.Type == "Dance" or cosmetic.Type == "Emote") then
                    if not emotes[name] then
                        emotes[name] = {
                            Name = name,
                            Type = cosmetic.Type,
                            ObjectID = cosmetic.ObjectID,
                            Enum = cosmetic.Enum
                        }
                    end
                end
            end
            return emotes
        end
    end
end)

pcall(function()
    local ViewProfile = require(player.PlayerScripts.Modules.Pages.ViewProfile)
    if ViewProfile and ViewProfile.Fetch then
        local originalFetch = ViewProfile.Fetch
        ViewProfile.Fetch = function(self, targetPlayer)
            viewingProfile = targetPlayer
            return originalFetch(self, targetPlayer)
        end
    end
end)

loadConfig()local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local playerScripts = player.PlayerScripts
local controllers = playerScripts.Controllers
local EnumLibrary = require(ReplicatedStorage.Modules:WaitForChild("EnumLibrary", 10))
if EnumLibrary then EnumLibrary:WaitForEnumBuilder() end
local CosmeticLibrary = require(ReplicatedStorage.Modules:WaitForChild("CosmeticLibrary", 10))
local ItemLibrary = require(ReplicatedStorage.Modules:WaitForChild("ItemLibrary", 10))
local DataController = require(controllers:WaitForChild("PlayerDataController", 10))
local equipped, favorites = {}, {}
local constructingWeapon, viewingProfile = nil, nil

local function cloneCosmetic(name, cosmeticType, options)
    local base = CosmeticLibrary.Cosmetics[name]
    if not base then return nil end
    local data = {}
    for key, value in pairs(base) do data[key] = value end
    data.Name = name
    data.Type = data.Type or cosmeticType
    data.Seed = data.Seed or math.random(1, 1000000)
    if EnumLibrary then
        local success, enumId = pcall(EnumLibrary.ToEnum, EnumLibrary, name)
        if success and enumId then data.Enum, data.ObjectID = enumId, data.ObjectID or enumId end
    end
    if options then
        if options.inverted ~= nil then data.Inverted = options.inverted end
        if options.favoritesOnly ~= nil then data.OnlyUseFavorites = options.favoritesOnly end
    end
    return data
end

local saveFile = "Rivals-Skinchanger/skins.txt"
local function saveConfig()
    if not writefile then return end
    pcall(function()
        local config = {equipped = {}, favorites = favorites}
        for weapon, cosmetics in pairs(equipped) do
            config.equipped[weapon] = {}
            for cosmeticType, cosmeticData in pairs(cosmetics) do
                if cosmeticData and cosmeticData.Name then
                    config.equipped[weapon][cosmeticType] = {
                        name = cosmeticData.Name, seed = cosmeticData.Seed, inverted = cosmeticData.Inverted
                    }
                end
            end
        end
        makefolder("Rivals-Skinchanger")
        writefile(saveFile, HttpService:JSONEncode(config))
    end)
end

local function loadConfig()
    if not readfile or not isfile or not isfile(saveFile) then return end
    pcall(function()
        local config = HttpService:JSONDecode(readfile(saveFile))
        if config.equipped then
            for weapon, cosmetics in pairs(config.equipped) do
                equipped[weapon] = {}
                for cosmeticType, cosmeticData in pairs(cosmetics) do
                    local cloned = cloneCosmetic(cosmeticData.name, cosmeticType, {inverted = cosmeticData.inverted})
                    if cloned then cloned.Seed = cosmeticData.seed equipped[weapon][cosmeticType] = cloned end
                end
            end
        end
        favorites = config.favorites or {}
    end)
end

local function isFinisher(cosmetic)
    if not cosmetic then return false end
    local t = cosmetic.Type
    return t == "Finisher" or t == "Finish" or (t and string.find(t:lower(), "finish"))
end

local function isEmote(cosmetic)
    if not cosmetic then return false end
    local t = cosmetic.Type
    return t == "Dance" or t == "Emote"
end

local origOwnsCosmetic = CosmeticLibrary.OwnsCosmetic
CosmeticLibrary.OwnsCosmetic = function(self, inventory, name, weapon)
    if name:find("MISSING_") then return origOwnsCosmetic(self, inventory, name, weapon) end
    local cosmetic = CosmeticLibrary.Cosmetics[name]
    if cosmetic then return true end
    return origOwnsCosmetic(self, inventory, name, weapon)
end

local originalGet = DataController.Get
DataController.Get = function(self, key)
    local data = originalGet(self, key)
    if key == "CosmeticInventory" then
        local proxy = {}
        if data then for k, v in pairs(data) do
            local cosmetic = CosmeticLibrary.Cosmetics[k]
            if cosmetic then proxy[k] = v end
        end end
        return setmetatable(proxy, {__index = function(t, k)
            local cosmetic = CosmeticLibrary.Cosmetics[k]
            if cosmetic then return true end
            return nil
        end})
    end
    if key == "FavoritedCosmetics" then
        local result = data and table.clone(data) or {}
        for weapon, favs in pairs(favorites) do
            result[weapon] = result[weapon] or {}
            for name, isFav in pairs(favs) do
                local cosmetic = CosmeticLibrary.Cosmetics[name]
                if cosmetic then result[weapon][name] = isFav end
            end
        end
        return result
    end
    return data
end

local originalGetWeaponData = DataController.GetWeaponData
DataController.GetWeaponData = function(self, weaponName)
    local data = originalGetWeaponData(self, weaponName)
    if not data then return nil end
    local merged = {}
    for key, value in pairs(data) do merged[key] = value end
    merged.Name = weaponName
    if equipped[weaponName] then
        for cosmeticType, cosmeticData in pairs(equipped[weaponName]) do
            if cosmeticType ~= "Dances" then merged[cosmeticType] = cosmeticData end
        end
    end
    return merged
end

local FighterController
pcall(function() FighterController = require(controllers:WaitForChild("FighterController", 10)) end)

if hookmetamethod then
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local dataRemotes = remotes and remotes:FindFirstChild("Data")
    local equipRemote = dataRemotes and dataRemotes:FindFirstChild("EquipCosmetic")
    local favoriteRemote = dataRemotes and dataRemotes:FindFirstChild("FavoriteCosmetic")
    local replicationRemotes = remotes and remotes:FindFirstChild("Replication")
    local fighterRemotes = replicationRemotes and replicationRemotes:FindFirstChild("Fighter")
    local useItemRemote = fighterRemotes and fighterRemotes:FindFirstChild("UseItem")

    if equipRemote then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            if getnamecallmethod() ~= "FireServer" then return oldNamecall(self, ...) end
            local args = {...}
            if useItemRemote and self == useItemRemote then
                local objectID = args[1]
                if FighterController then
                    pcall(function()
                        local fighter = FighterController:GetFighter(player)
                        if fighter and fighter.Items then
                            for _, item in pairs(fighter.Items) do
                                if item:Get("ObjectID") == objectID then lastUsedWeapon = item.Name break end
                            end
                        end
                    end)
                end
            end
            if self == equipRemote then
                local weaponName, cosmeticType, cosmeticName, options = args[1], args[2], args[3], args[4] or {}
                local cosmetic = CosmeticLibrary.Cosmetics[cosmeticName]
                -- For finishers and emotes/dances: let remote fire, but update local state
                if cosmetic and (isFinisher(cosmetic) or isEmote(cosmetic)) then
                    if isEmote(cosmetic) then
                        equipped.Dances = equipped.Dances or {}
                        if not cosmeticName or cosmeticName == "None" or cosmeticName == "" then
                            equipped.Dances[cosmeticType] = nil
                        else
                            local cloned = cloneCosmetic(cosmeticName, cosmeticType, {inverted = options.IsInverted, favoritesOnly = options.OnlyUseFavorites})
                            if cloned then equipped.Dances[cosmeticType] = cloned end
                        end
                    else
                        equipped[weaponName] = equipped[weaponName] or {}
                        if not cosmeticName or cosmeticName == "None" or cosmeticName == "" then
                            equipped[weaponName][cosmeticType] = nil
                            if not next(equipped[weaponName]) then equipped[weaponName] = nil end
                        else
                            local cloned = cloneCosmetic(cosmeticName, cosmeticType, {inverted = options.IsInverted, favoritesOnly = options.OnlyUseFavorites})
                            if cloned then equipped[weaponName][cosmeticType] = cloned end
                        end
                    end
                    saveConfig()
                    -- Let the remote fire to server
                    return oldNamecall(self, ...)
                end
                -- For other cosmetics (skins, charms, wraps): block remote and handle locally
                if cosmeticName and cosmeticName ~= "None" and cosmeticName ~= "" then
                    local inventory = DataController:Get("CosmeticInventory")
                    if inventory and rawget(inventory, cosmeticName) then return oldNamecall(self, ...) end
                end
                -- Non-emote, non-finisher: handle locally
                equipped[weaponName] = equipped[weaponName] or {}
                if not cosmeticName or cosmeticName == "None" or cosmeticName == "" then
                    equipped[weaponName][cosmeticType] = nil
                    if not next(equipped[weaponName]) then equipped[weaponName] = nil end
                else
                    local cloned = cloneCosmetic(cosmeticName, cosmeticType, {inverted = options.IsInverted, favoritesOnly = options.OnlyUseFavorites})
                    if cloned then equipped[weaponName][cosmeticType] = cloned end
                end
                task.defer(function()
                    pcall(function() DataController.CurrentData:Replicate("WeaponInventory") end)
                    task.wait(0.2)
                    saveConfig()
                end)
                return
            end
            if self == favoriteRemote then
                local cosmetic = CosmeticLibrary.Cosmetics[args[2]]
                if cosmetic then
                    favorites[args[1]] = favorites[args[1]] or {}
                    favorites[args[1]][args[2]] = args[3] or nil
                    saveConfig()
                    task.spawn(function() pcall(function() DataController.CurrentData:Replicate("FavoritedCosmetics") end) end)
                end
                return
            end
            return oldNamecall(self, ...)
        end)
    end
end

local ClientItem
pcall(function() ClientItem = require(player.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem) end)

if ClientItem and ClientItem._CreateViewModel then
    local originalCreateViewModel = ClientItem._CreateViewModel
    ClientItem._CreateViewModel = function(self, viewmodelRef)
        local weaponName = self.Name
        local weaponPlayer = self.ClientFighter and self.ClientFighter.Player
        constructingWeapon = (weaponPlayer == player) and weaponName or nil
        if weaponPlayer == player and equipped[weaponName] and viewmodelRef then
            local dataKey, skinKey, charmKey, wrapKey, nameKey = self:ToEnum("Data"), self:ToEnum("Skin"), self:ToEnum("Charm"), self:ToEnum("Wrap"), self:ToEnum("Name")
            local data = viewmodelRef[dataKey] or viewmodelRef.Data
            if data then
                if equipped[weaponName].Skin then data[skinKey or "Skin"] = equipped[weaponName].Skin end
                if equipped[weaponName].Charm then data[charmKey or "Charm"] = equipped[weaponName].Charm end
                if equipped[weaponName].Wrap then data[wrapKey or "Wrap"] = equipped[weaponName].Wrap end
                if equipped[weaponName].Skin then data[nameKey or "Name"] = equipped[weaponName].Skin.Name end
            end
        end
        local result = originalCreateViewModel(self, viewmodelRef)
        constructingWeapon = nil
        return result
    end
end

local viewModelModule = player.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
if viewModelModule then
    local ClientViewModel = require(viewModelModule)
    local originalNew = ClientViewModel.new
    ClientViewModel.new = function(replicatedData, clientItem)
        local weaponPlayer = clientItem.ClientFighter and clientItem.ClientFighter.Player
        local weaponName = constructingWeapon or clientItem.Name
        if weaponPlayer == player and equipped[weaponName] then
            local ReplicatedClass = require(ReplicatedStorage.Modules.ReplicatedClass)
            local dataKey = ReplicatedClass:ToEnum("Data")
            replicatedData[dataKey] = replicatedData[dataKey] or {}
            local cosmetics = equipped[weaponName]
            if cosmetics.Skin then replicatedData[dataKey][ReplicatedClass:ToEnum("Skin")] = cosmetics.Skin end
            if cosmetics.Charm then replicatedData[dataKey][ReplicatedClass:ToEnum("Charm")] = cosmetics.Charm end
            if cosmetics.Wrap then replicatedData[dataKey][ReplicatedClass:ToEnum("Wrap")] = cosmetics.Wrap end
        end
        local result = originalNew(replicatedData, clientItem)
        if weaponPlayer == player and equipped[weaponName] and equipped[weaponName].Wrap and result._UpdateWrap then
            result:_UpdateWrap()
            task.delay(0.1, function() if not result._destroyed then result:_UpdateWrap() end end)
        end
        return result
    end
    if ClientViewModel.GetCharm then
        local originalGetCharmFunc = ClientViewModel.GetCharm
        ClientViewModel.GetCharm = function(self)
            local weaponName = self.ClientItem and self.ClientItem.Name
            local weaponPlayer = self.ClientItem and self.ClientItem.ClientFighter and self.ClientItem.ClientFighter.Player
            if weaponName and weaponPlayer == player and equipped[weaponName] and equipped[weaponName].Charm then
                return equipped[weaponName].Charm
            end
            return originalGetCharmFunc(self)
        end
    end
    if ClientViewModel.GetWrap then
        local originalGetWrapFunc = ClientViewModel.GetWrap
        ClientViewModel.GetWrap = function(self)
            local weaponName = self.ClientItem and self.ClientItem.Name
            local weaponPlayer = self.ClientItem and self.ClientItem.ClientFighter and self.ClientItem.ClientFighter.Player
            if weaponName and weaponPlayer == player and equipped[weaponName] and equipped[weaponName].Wrap then
                return equipped[weaponName].Wrap
            end
            return originalGetWrapFunc(self)
        end
    end
end

local originalGetViewModelImage = ItemLibrary.GetViewModelImageFromWeaponData
ItemLibrary.GetViewModelImageFromWeaponData = function(self, weaponData, highRes)
    if not weaponData then return originalGetViewModelImage(self, weaponData, highRes) end
    local weaponName = weaponData.Name
    local shouldShowSkin = (weaponData.Skin and equipped[weaponName] and weaponData.Skin == equipped[weaponName].Skin) or (viewingProfile == player and equipped[weaponName] and equipped[weaponName].Skin)
    if shouldShowSkin and equipped[weaponName] and equipped[weaponName].Skin then
        local skinInfo = self.ViewModels[equipped[weaponName].Skin.Name]
        if skinInfo then return skinInfo[highRes and "ImageHighResolution" or "Image"] or skinInfo.Image end
    end
    return originalGetViewModelImage(self, weaponData, highRes)
end

local EmoteController
pcall(function()
    EmoteController = require(controllers:WaitForChild("EmoteController", 10))
    if EmoteController and EmoteController.GetEmotes then
        local originalGetEmotes = EmoteController.GetEmotes
        EmoteController.GetEmotes = function(self)
            local emotes = originalGetEmotes(self)
            for name, cosmetic in pairs(CosmeticLibrary.Cosmetics) do
                if cosmetic and (cosmetic.Type == "Dance" or cosmetic.Type == "Emote") then
                    if not emotes[name] then
                        emotes[name] = {
                            Name = name,
                            Type = cosmetic.Type,
                            ObjectID = cosmetic.ObjectID,
                            Enum = cosmetic.Enum
                        }
                    end
                end
            end
            return emotes
        end
    end
end)

pcall(function()
    local ViewProfile = require(player.PlayerScripts.Modules.Pages.ViewProfile)
    if ViewProfile and ViewProfile.Fetch then
        local originalFetch = ViewProfile.Fetch
        ViewProfile.Fetch = function(self, targetPlayer)
            viewingProfile = targetPlayer
            return originalFetch(self, targetPlayer)
        end
    end
end)

loadConfig()
]=]

local skinChangerStarted = false
skinChangerBtn.MouseButton1Click:Connect(function()
    if skinChangerStarted then return end
    skinChangerBtn.Text = "LOADING..."

    if type(loadstring) ~= "function" then
        skinChangerBtn.Text = "NO LOADSTRING"
        warn("[Rivals Skin Changer] loadstring is unavailable")
        return
    end

    local ok, chunk = pcall(loadstring, skinChangerSource)
    if not ok or type(chunk) ~= "function" then
        skinChangerBtn.Text = "ERROR"
        warn("[Rivals Skin Changer] Failed to compile: "..tostring(chunk))
        return
    end

    local ran, err = pcall(chunk)
    if not ran then
        skinChangerBtn.Text = "ERROR"
        warn("[Rivals Skin Changer] Failed to start: "..tostring(err))
        return
    end

    skinChangerStarted = true
    skinChangerBtn.Text = "OPENED"
end)

local cfgResetRow = Instance.new("Frame")
cfgResetRow.Size = UDim2.new(1,0,0,38)
cfgResetRow.BackgroundColor3 = C.row
cfgResetRow.BackgroundTransparency = 0.5
cfgResetRow.BorderSizePixel = 0
cfgResetRow.LayoutOrder = 6
cfgResetRow.Parent = cfgPage
guiCorner(cfgResetRow,10); guiStroke(cfgResetRow,C.divider,1)

local cfgResetLbl = Instance.new("TextLabel",cfgResetRow)
cfgResetLbl.Size = UDim2.new(0.6,0,0,16)
cfgResetLbl.Position = UDim2.new(0,12,0,6)
cfgResetLbl.BackgroundTransparency = 1
cfgResetLbl.Text = "Reset Config"
cfgResetLbl.TextColor3 = C.text
cfgResetLbl.TextSize = 11
cfgResetLbl.Font = Enum.Font.GothamBold
cfgResetLbl.TextXAlignment = Enum.TextXAlignment.Left

local cfgResetBtn = Instance.new("TextButton",cfgResetRow)
cfgResetBtn.Size = UDim2.new(0,64,0,22)
cfgResetBtn.Position = UDim2.new(1,-72,0.5,-11)
cfgResetBtn.BackgroundColor3 = Color3.fromRGB(150,40,50)
cfgResetBtn.BackgroundTransparency = 0.3
cfgResetBtn.BorderSizePixel = 0
cfgResetBtn.Text = "RESET"
cfgResetBtn.TextColor3 = C.white
cfgResetBtn.TextSize = 10
cfgResetBtn.Font = Enum.Font.GothamBold
guiCorner(cfgResetBtn,5)
cfgResetBtn.MouseButton1Click:Connect(function()
    animPackEnabled = false
    animPackName = "SKIBIDI OFF"
    E["ESP Players"] = false
    E["Player Tracers"] = false
    espColor = Color3.fromRGB(255,80,110)
    tracerColor = Color3.fromRGB(255,80,110)
    silentAimEnabled = false
    silentAimTargetPart = "Head"
    silentAimFOV = 150
    silentAimSize = 6
    aimbotEnabled = false
    aimbotSmoothness = 0.25
    introSongEnabled = true
    introSongIndex = 1
    fontChangeEnabled = false
    uiLocked = false

    Config.animPackEnabled = false
    Config.animPackName = "SKIBIDI OFF"
    Config.espEnabled = false
    Config.tracerEnabled = false
    Config.espColor = espColor
    Config.tracerColor = tracerColor
    Config.silentAimEnabled = false
    Config.silentAimTargetPart = "Head"
    Config.silentAimFOV = 150
    Config.silentAimSize = 6
    Config.aimbotEnabled = false
    Config.aimbotSmoothness = 0.25
    Config.introSongEnabled = true
    Config.introSongIndex = 1
    Config.fontChangeEnabled = false
    Config.uiLocked = false
    Config.bgIndex = 1
    Config.bgCustom = {}
    if BG_GALLERY then BG_GALLERY.custom = {}; BG_GALLERY.backgroundIndex = 1 end
    BG_IMAGE = BG_OPTIONS[1].value

    if stopESP then stopESP() end
    if stopAimbot then stopAimbot() end
    pcall(function() resetAnimPack(LP.Character) end)

    if animToggleSet then animToggleSet(false) end
    if espToggleSet then espToggleSet(false) end
    if tracerToggleSet then tracerToggleSet(false) end
    if saToggleSetRef then saToggleSetRef(false) end
    if aimbotToggleSetRef then aimbotToggleSetRef(false) end
    if introToggleSet then introToggleSet(true) end
    if fontToggleSet then fontToggleSet(false) end
    if lockToggleSet then lockToggleSet(false) end

    if espColorSwatch then espColorSwatch.BackgroundColor3 = espColor end
    if tracerColorSwatch then tracerColorSwatch.BackgroundColor3 = tracerColor end
    if saTargetRefresh then pcall(saTargetRefresh) end

    if animVal then animVal.Text = animPackName end
    if songNameLbl then songNameLbl.Text = INTRO_SONGS[1] and INTRO_SONGS[1].name or "" end
    for j, b in ipairs(songButtons) do
        local on = (j == 1)
        b.BackgroundColor3 = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(20,20,24)
        b.TextColor3 = on and Color3.fromRGB(0,0,0) or Color3.fromRGB(230,230,235)
    end

    -- Reset background picker visuals
    if bgNameLbl then bgNameLbl.Text = BG_OPTIONS[1].name end
    for j, b in ipairs(bgButtons) do
        local on = (j == 1)
        b.BackgroundColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(20, 20, 24)
        b.TextColor3 = on and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(230, 230, 235)
    end
    if BgImage then applyBackground(BG_IMAGE) end

    saveConfig()
    cfgResetBtn.Text = "DONE"
    task.delay(1, function() cfgResetBtn.Text = "RESET" end)
end)

task.spawn(function()
    task.wait(0.15)

    if animPackEnabled and animPackName and animPackName ~= "SKIBIDI OFF" then
        pcall(function() applyAnimPack(animPackName) end)
    end
    if E["ESP Players"] then pcall(startESP) end

    if Config.aimbotEnabled then
        Config.silentAimEnabled = false
        silentAimEnabled = false
        aimbotEnabled = true
        pcall(startAimbot)
    elseif Config.silentAimEnabled then
        silentAimEnabled = true
        if not silentAimHookActive then pcall(setupSilentAimHook) end
    end

    if fontChangeEnabled then pcall(function() setFontChangeEnabled(true, GuiHub) end) end
    if introSongEnabled then task.spawn(function() pcall(playIntroSongAndFlash, introSongIndex) end) end

    if animToggleSet then animToggleSet(animPackEnabled) end
    if espToggleSet then espToggleSet(E["ESP Players"]) end
    if tracerToggleSet then tracerToggleSet(E["Player Tracers"]) end
    if saToggleSetRef then saToggleSetRef(silentAimEnabled) end
    if aimbotToggleSetRef then aimbotToggleSetRef(aimbotEnabled) end
    if introToggleSet then introToggleSet(introSongEnabled) end
    if fontToggleSet then fontToggleSet(fontChangeEnabled) end
    if lockToggleSet then lockToggleSet(uiLocked) end

    if espColorSwatch then espColorSwatch.BackgroundColor3 = espColor end
    if tracerColorSwatch then tracerColorSwatch.BackgroundColor3 = tracerColor end
end)

task.spawn(function()
    while task.wait(10) do pcall(saveConfig) end
end)

game:BindToClose(function() pcall(saveConfig) end)

print("SKIBIDI HUB LOADED")
print("Background ID: 102775518748491 / lqz8tg.jpeg")
print("Config file: " .. CONFIG_FILE)
