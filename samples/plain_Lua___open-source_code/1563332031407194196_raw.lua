-- ============================================================
-- SOUND INTRO GATE
-- Main script starts only after the intro finishes or is skipped.
-- ============================================================
repeat task.wait() until game:IsLoaded()

local _SoundIntroPlayers = game:GetService("Players")
local _SoundIntroRunService = game:GetService("RunService")
local _SoundIntroUIS = game:GetService("UserInputService")
local _SoundIntroLighting = game:GetService("Lighting")
local _SoundIntroSoundService = game:GetService("SoundService")
local _SoundIntroTweenService = game:GetService("TweenService")
local _SoundIntroPlayer = _SoundIntroPlayers.LocalPlayer

local _SOUND_INTRO_MUSIC_URL = "https://files.catbox.moe/y4q5y3.mp3"
local _SOUND_INTRO_MUSIC_FILE = "cleanhub_intro_song_14.mp3"
local _SOUND_INTRO_MUSIC_VOLUME = 1
local _SOUND_INTRO_FALLBACK_MUSIC_ID = "rbxassetid://9046862121"
local _SOUND_INTRO_CHARACTER_ASSET_ID = "92554477662878"

_G._SoundIntroFinished = false
_G._VantaSkipIntro = false
_G._VantaIntroActive = true

local function _soundResolveIntroMusicId()
    local assetGetter = getcustomasset or getsynasset
    if type(assetGetter) == "function" and type(writefile) == "function" then
        local exists = false
        if type(isfile) == "function" then
            pcall(function() exists = isfile(_SOUND_INTRO_MUSIC_FILE) end)
        end
        if not exists then
            local ok, data = pcall(function() return game:HttpGet(_SOUND_INTRO_MUSIC_URL) end)
            if ok and type(data) == "string" and #data > 0 then
                pcall(writefile, _SOUND_INTRO_MUSIC_FILE, data)
            end
        end
        local ok, asset = pcall(assetGetter, _SOUND_INTRO_MUSIC_FILE)
        if ok and asset then return asset end
    end
    return _SOUND_INTRO_FALLBACK_MUSIC_ID
end

local function _soundShowIntro(onFinished)
    local introSound
    local function stopIntroMusic()
        if introSound then
            pcall(function() introSound:Stop() end)
            pcall(function() introSound:Destroy() end)
            introSound = nil
        end
    end

    if _G._VantaLoadIntroCleanup then pcall(_G._VantaLoadIntroCleanup) end
    local isMobile = _SoundIntroUIS.TouchEnabled and not _SoundIntroUIS.KeyboardEnabled
    local playerGui = _SoundIntroPlayer:WaitForChild("PlayerGui")
    local old = playerGui:FindFirstChild("VantaLoadIntro")
    if old then old:Destroy() end
    local oldBlur = _SoundIntroLighting:FindFirstChild("VantaLoadIntroBlur")
    if oldBlur then oldBlur:Destroy() end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "VantaLoadIntro"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 1000005
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = playerGui

    introSound = Instance.new("Sound")
    introSound.Name = "VantaIntroMusic"
    introSound.SoundId = _soundResolveIntroMusicId()
    introSound.Volume = _SOUND_INTRO_MUSIC_VOLUME
    introSound.Looped = false
    introSound.Parent = _SoundIntroSoundService
    pcall(function() introSound:Play() end)

    local instance = Instance.new("Frame")
    instance.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
    instance.BackgroundTransparency = 1
    instance.BorderSizePixel = 0
    instance.Size = UDim2.fromScale(1, 1)
    instance.ZIndex = 1000
    instance.Parent = screenGui

    local rainContainer = Instance.new("Frame")
    rainContainer.Name = "PurpleRain"
    rainContainer.BackgroundTransparency = 1
    rainContainer.Size = UDim2.fromScale(1, 1)
    rainContainer.ZIndex = 1001
    rainContainer.ClipsDescendants = true
    rainContainer.Parent = instance

    local running = true
    local closing = false
    task.spawn(function()
        while running and not closing do
            local drop = Instance.new("Frame")
            drop.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
            drop.BackgroundTransparency = math.random(40, 70) / 100
            drop.BorderSizePixel = 0
            drop.Size = UDim2.fromOffset(math.random(1, 3), math.random(15, 30))
            drop.Position = UDim2.fromScale(math.random(0, 100) / 100, -0.1)
            drop.ZIndex = 1001
            drop.Parent = rainContainer
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = drop
            local fallTime = math.random(15, 25) / 10
            local tween = _SoundIntroTweenService:Create(drop, TweenInfo.new(fallTime, Enum.EasingStyle.Linear), {
                Position = UDim2.fromScale(drop.Position.X.Scale, 1.1)
            })
            tween:Play()
            task.delay(fallTime + 0.1, function()
                if drop and drop.Parent then drop:Destroy() end
            end)
            task.wait(math.random(2, 6) / 100)
        end
    end)

    local characterFrame = Instance.new("Frame")
    characterFrame.Name = "CharacterContainer"
    characterFrame.BackgroundTransparency = 1
    characterFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    characterFrame.Position = UDim2.fromScale(0.5, 1.5)
    characterFrame.Size = isMobile and UDim2.fromOffset(250, 250) or UDim2.fromOffset(450, 450)
    characterFrame.ZIndex = 1005
    characterFrame.Parent = instance

    local characterImg = Instance.new("ImageLabel")
    characterImg.BackgroundTransparency = 1
    characterImg.Size = UDim2.fromScale(1, 1)
    characterImg.Image = "rbxassetid://" .. _SOUND_INTRO_CHARACTER_ASSET_ID
    characterImg.ScaleType = Enum.ScaleType.Fit
    characterImg.ZIndex = 1006
    characterImg.Parent = characterFrame

    task.delay(0.2, function()
        if not running then return end
        _SoundIntroTweenService:Create(characterFrame, TweenInfo.new(1.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.fromScale(0.5, 0.45)
        }):Play()
        task.spawn(function()
            local direction = -1
            while running and not closing do
                _SoundIntroTweenService:Create(characterFrame, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Position = UDim2.fromScale(0.5, 0.45 + direction * 0.015)
                }):Play()
                direction = -direction
                task.wait(1.2)
            end
        end)
    end)

    local frame2 = Instance.new("Frame")
    frame2.Name = "VantaWordmark"
    frame2.BackgroundTransparency = 1
    frame2.BorderSizePixel = 0
    frame2.AnchorPoint = Vector2.new(0.5, 0.5)
    frame2.Position = UDim2.fromScale(0.5, 0.43)
    frame2.Size = isMobile and UDim2.fromOffset(240, 75) or UDim2.fromOffset(570, 160)
    frame2.ClipsDescendants = false
    frame2.ZIndex = 1003
    frame2.Parent = instance
    local uiScale = Instance.new("UIScale")
    uiScale.Scale = 0.86
    uiScale.Parent = frame2

    local wordmarkSpecs = {
        { id = 122032214221892, from = Vector2.new(-0.4, 0.2), final = Vector2.new(0.08, 0.5), rotation = -32, delay = 0.52 },
        { id = 122800305096107, from = Vector2.new(0.3, -0.55), final = Vector2.new(0.245, 0.5), rotation = 20, delay = 0.62 },
        { id = 88122827689967, from = Vector2.new(1.42, 0.3), final = Vector2.new(0.41, 0.5), rotation = -22, delay = 0.72 },
        { id = 88857087413344, from = Vector2.new(0.68, 1.55), final = Vector2.new(0.575, 0.5), rotation = 27, delay = 0.82 },
        { id = 110589136602702, from = Vector2.new(1.48, -0.42), final = Vector2.new(0.74, 0.5), rotation = 18, delay = 0.92 },
        { id = 110589136602702, from = Vector2.new(-0.35, 1.35), final = Vector2.new(0.905, 0.5), rotation = -14, delay = 1.02 },
    }
    local wordmarkItems = {}
    for i, spec in ipairs(wordmarkSpecs) do
        local slot = Instance.new("Frame")
        slot.BackgroundTransparency = 1
        slot.BorderSizePixel = 0
        slot.AnchorPoint = Vector2.new(0.5, 0.5)
        slot.Position = UDim2.fromScale(spec.from.X, spec.from.Y)
        slot.Size = UDim2.fromScale(0.10, 0.70)
        slot.Rotation = spec.rotation
        slot.ZIndex = 1003 + i
        slot.Parent = frame2
        local img = Instance.new("ImageLabel")
        img.BackgroundTransparency = 1
        img.BorderSizePixel = 0
        img.Image = "rbxassetid://" .. tostring(spec.id)
        img.ImageColor3 = Color3.fromRGB(255, 255, 255)
        img.ImageTransparency = 1
        img.ScaleType = Enum.ScaleType.Fit
        img.AnchorPoint = Vector2.new(0.5, 0.5)
        img.Position = UDim2.fromScale(0.5, 0.5)
        img.Size = UDim2.fromScale(0.85, 0.85)
        img.ZIndex = 1004 + i
        img.Parent = slot
        local imgCorner = Instance.new("UICorner")
        imgCorner.CornerRadius = UDim.new(0, 6)
        imgCorner.Parent = img
        wordmarkItems[i] = { slot = slot, image = img, spec = spec }
    end

    local textLabel = Instance.new("TextLabel")
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "TAP ANYWHERE TO SKIP"
    textLabel.TextColor3 = Color3.fromRGB(240, 240, 244)
    textLabel.TextTransparency = 1
    textLabel.TextSize = isMobile and 11 or 22
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    textLabel.Position = UDim2.new(0.5, 0, 0.85, 0)
    textLabel.Size = UDim2.new(0.8, 0, 0, 24)
    textLabel.ZIndex = 1010
    textLabel.Parent = instance

    local textLabel2 = Instance.new("TextLabel")
    textLabel2.BackgroundTransparency = 1
    textLabel2.Text = "Discord.gg/soundhubb"
    textLabel2.TextColor3 = Color3.fromRGB(166, 168, 178)
    textLabel2.TextTransparency = 1
    textLabel2.TextSize = isMobile and 10 or 16
    textLabel2.Font = Enum.Font.GothamMedium
    textLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
    textLabel2.Position = UDim2.new(0.5, 0, 0.88, 0)
    textLabel2.Size = UDim2.new(0.8, 0, 0, 22)
    textLabel2.ZIndex = 1010
    textLabel2.Parent = instance

    local skipBtn = Instance.new("TextButton")
    skipBtn.Name = "SkipAnywhereButton"
    skipBtn.BackgroundTransparency = 1
    skipBtn.Text = ""
    skipBtn.AutoButtonColor = false
    skipBtn.Size = UDim2.fromScale(1, 1)
    skipBtn.ZIndex = 1011
    skipBtn.Parent = instance

    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Name = "VantaLoadIntroBlur"
    blurEffect.Size = 0
    blurEffect.Parent = _SoundIntroLighting
    local canSkip = true

    local function smoothstep(a)
        local n = math.clamp(a, 0, 1)
        return n * n * (3 - 2 * n)
    end
    local function bezier(p0, p1, p2, t)
        local n = 1 - t
        return Vector2.new(n*n*p0.X + 2*n*t*p1.X + t*t*p2.X, n*n*p0.Y + 2*n*t*p1.Y + t*t*p2.Y)
    end

    local function closeIntro()
        if closing then return end
        closing = true
        running = false
        _G._VantaSkipIntro = true
        stopIntroMusic()
        local ti = TweenInfo.new(0.42, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        _SoundIntroTweenService:Create(instance, ti, { BackgroundTransparency = 1 }):Play()
        _SoundIntroTweenService:Create(uiScale, ti, { Scale = 0.72 }):Play()
        _SoundIntroTweenService:Create(characterFrame, ti, { Position = UDim2.fromScale(0.5, 1.5) }):Play()
        _SoundIntroTweenService:Create(blurEffect, ti, { Size = 0 }):Play()
        _SoundIntroTweenService:Create(textLabel, ti, { TextTransparency = 1 }):Play()
        _SoundIntroTweenService:Create(textLabel2, ti, { TextTransparency = 1 }):Play()
        for _, item in ipairs(wordmarkItems) do
            _SoundIntroTweenService:Create(item.image, ti, { ImageTransparency = 1 }):Play()
        end
        task.delay(0.42, function()
            if screenGui.Parent then screenGui:Destroy() end
            if blurEffect.Parent then blurEffect:Destroy() end
            _G._VantaLoadIntroCleanup = nil
            _G._VantaIntroActive = false
            if onFinished then onFinished() end
        end)
    end

    _G._VantaLoadIntroCleanup = function()
        running = false
        closing = true
        stopIntroMusic()
        if screenGui.Parent then screenGui:Destroy() end
        if blurEffect.Parent then blurEffect:Destroy() end
        _G._VantaIntroActive = false
        _G._SoundIntroFinished = true
    end
    skipBtn.Activated:Connect(closeIntro)

    _SoundIntroTweenService:Create(instance, TweenInfo.new(0.25), { BackgroundTransparency = 0.5 }):Play()
    _SoundIntroTweenService:Create(blurEffect, TweenInfo.new(0.25), { Size = 10 }):Play()
    task.delay(1.5, function()
        if not running then return end
        _SoundIntroTweenService:Create(textLabel, TweenInfo.new(0.3), { TextTransparency = 0.22 }):Play()
        _SoundIntroTweenService:Create(textLabel2, TweenInfo.new(0.3), { TextTransparency = 0.18 }):Play()
    end)

    task.spawn(function()
        local now = os.clock()
        while running and not closing do
            local animTime = os.clock() - now - 0.5
            if animTime > 0 then
                local v = smoothstep((animTime - 0.38) / 0.9)
                local s1 = math.sin(animTime * 1.62) * v
                local s2 = math.sin(animTime * 3.24) * v
                uiScale.Scale = 0.86 + smoothstep(animTime / 0.78) * 0.14 + s1 * 0.012
                for i, item in ipairs(wordmarkItems) do
                    local spec = item.spec
                    local offset = i - 3
                    local distance = math.abs(offset) / 2
                    local progress = math.clamp((animTime - spec.delay) / 0.96, 0, 1)
                    local eased = 1 - (1 - progress)^3
                    local pos = bezier(spec.from, Vector2.new((spec.from.X + spec.final.X) * 0.5 - offset * 0.08, (spec.from.Y + spec.final.Y) * 0.5 + ((i % 2 == 0) and -0.23 or 0.23)), spec.final, eased)
                    item.slot.Position = UDim2.fromScale(pos.X + offset * s1 * 0.009, pos.Y + (distance*distance*12 - 6) * s1 / 230 + s2 * (1 - distance) * 2.4 / 230)
                    item.slot.Size = UDim2.fromScale(0.15 * (1 + s1 * (0.035 + distance*0.055)), 0.65 - s1 * (0.028 + distance*0.045))
                    item.slot.Rotation = spec.rotation * (1 - eased) + offset * s1 * 5.8 + s2 * (1 - distance) * 0.8
                    local a = math.sin(animTime * 2.85 + i * 0.82)
                    local b = math.sin(animTime * 2.1 + i * 0.64)
                    item.image.Position = UDim2.new(0.5, 0, 0.5, b * 1.35)
                    item.image.Size = UDim2.fromScale(1 + a * 0.026, 1 - a * 0.038)
                    item.image.Rotation = b * 0.9
                    item.image.ImageTransparency = 1 - smoothstep((progress - 0.02) / 0.18)
                end
            end
            _SoundIntroRunService.RenderStepped:Wait()
        end
    end)

    task.delay(10, function()
        if running and not closing then closeIntro() end
    end)
end

_soundShowIntro(function()
    _G._SoundIntroFinished = true
    print("[Sound] Intro finished — loading main script...")
end)

repeat task.wait() until _G._SoundIntroFinished == true
print("[Sound] Intro terminée. Starting main script.")
-- ============================================================
-- END SOUND INTRO GATE
-- ============================================================

if not LPH_OBFUSCATED then
	LPH_NO_VIRTUALIZE = function(callback)
	return callback
	end
	end

	;LPH_NO_VIRTUALIZE(function()

	do
	local scriptEnv = _G
	pcall(function()
	if type(getfenv) == "function" then scriptEnv = getfenv(0) end
	end)
	local sharedEnv = scriptEnv
	pcall(function()
	if type(getgenv) == "function" then sharedEnv = getgenv() end
	end)
	if type(scriptEnv) ~= "table" then scriptEnv = _G end
	if type(sharedEnv) ~= "table" then sharedEnv = scriptEnv end

	local hiddenSetter = rawget(scriptEnv, "sethiddenproperty")
	or rawget(sharedEnv, "sethiddenproperty")
	or rawget(scriptEnv, "set_hidden_property")
	or rawget(sharedEnv, "set_hidden_property")
	or rawget(scriptEnv, "sethiddenprop")
	or rawget(sharedEnv, "sethiddenprop")
	local synApi = rawget(scriptEnv, "syn") or rawget(sharedEnv, "syn")
	if type(hiddenSetter) ~= "function" and type(synApi) == "table" then
	hiddenSetter = rawget(synApi, "sethiddenproperty") or rawget(synApi, "set_hidden_property")
	end
	if type(hiddenSetter) == "function" then
	pcall(function() rawset(scriptEnv, "sethiddenproperty", hiddenSetter) end)
	pcall(function() rawset(sharedEnv, "sethiddenproperty", hiddenSetter) end)
	end

	local fpsCapSetter = rawget(scriptEnv, "setfpscap")
	or rawget(sharedEnv, "setfpscap")
	or rawget(scriptEnv, "set_fps_cap")
	or rawget(sharedEnv, "set_fps_cap")
	or rawget(scriptEnv, "setfpslimit")
	or rawget(sharedEnv, "setfpslimit")
	if type(fpsCapSetter) ~= "function" and type(synApi) == "table" then
	fpsCapSetter = rawget(synApi, "setfpscap") or rawget(synApi, "set_fps_cap")
	end
	if type(fpsCapSetter) == "function" then pcall(fpsCapSetter, 9999) end
	end

	local Players, UserInputService, TweenService, RunService, ReplicatedStorage,
	Lighting, HttpService, Player, isMobile = (function()
	local players = game:GetService("Players")
	local input = game:GetService("UserInputService")

	local mobile = input.TouchEnabled
	pcall(function()
	local platform = input:GetPlatform()
	mobile = input.TouchEnabled and (
	platform == Enum.Platform.Android
	or platform == Enum.Platform.IOS
	or not input.MouseEnabled
	)
	end)

	return players,
	input,
	game:GetService("TweenService"),
	game:GetService("RunService"),
	game:GetService("ReplicatedStorage"),
	game:GetService("Lighting"),
	game:GetService("HttpService"),
	players.LocalPlayer,
	mobile
	end)()

	-- Same layout/sizes on mobile as on PC (only the menu panel keeps a mobile shape)
	_G.__CrystalRealMobile = isMobile
	isMobile = false

	local executorName = "unknown"
	do
	local executorEnv = _G
	pcall(function()
	if type(getgenv) == "function" then executorEnv = getgenv() end
	end)
	if type(executorEnv) ~= "table" then executorEnv = _G end
	local identify = rawget(executorEnv, "identifyexecutor")
	or rawget(executorEnv, "getexecutorname")
	or (type(_G) == "table" and (rawget(_G, "identifyexecutor") or rawget(_G, "getexecutorname")))
	if type(identify) == "function" then
	pcall(function()
	local name = identify()
	if name ~= nil then executorName = tostring(name) end
	end)
	end
	end
	local waveSafeMode = string.find(string.lower(executorName), "wave", 1, true) ~= nil
	_G.__CrystalWaveSafeMode = waveSafeMode

	do
	local guiRootNames = {
	"Eclipse_Panel", "EclipseHub", "CRYSTAL_Panel", "Sound_Panel", "DashEffectGui",
	"CrystalAutoGrabBar", "SoundAutoGrabBar",
	"CrystalLaggerGUI", "SoundLaggerGUI", "SoundAntiLosePanel", "AntiLoseUI", "K9RS", "hyejuSpeedBypass",
	"CrystalMobileUI", "SoundMobileUI",
	"CrystalEnemyWidget", "SoundEnemyWidget",
	"SoundDuelsIntro",
	}

	pcall(function()
	local oldLagger = _G.CrystalLagger
	if oldLagger then
	if oldLagger.Stop then
	oldLagger.Stop()
	else
	if oldLagger.SetEnabled then oldLagger.SetEnabled(false) end
	if oldLagger.SetLowEndEnabled then oldLagger.SetLowEndEnabled(false) end
	end
	end
	end)
	_G.CrystalLagger = nil
	_G.__openLaggerGUI = nil
	_G._SoundLaggerGUILoaded = nil
	_G.__bypassFrame = nil
	if _G.__CRYSTAL_STATE then
	_G.__CRYSTAL_STATE.alive = false
	pcall(function()
	for _, stopper in ipairs(_G.__CRYSTAL_STATE.stoppers or {}) do pcall(stopper) end
	for _, conn in ipairs(_G.__CRYSTAL_STATE.conns or {}) do pcall(function() conn:Disconnect() end) end
	end)
	end
	_G.__CRYSTAL_STATE = nil
	_G.__CrystalTrackConn = nil
	_G.__CrystalTrackStopper = nil
	_G.__SoundDuelsIntroPlayed = nil

	pcall(function()
	if _G.__speedBoostConn then _G.__speedBoostConn:Disconnect(); _G.__speedBoostConn = nil end
	end)
	pcall(function() if _G.__stopSpeedBoost then _G.__stopSpeedBoost() end end)

	pcall(function()
	game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
	end)

	pcall(function()
	local coreGui = game:GetService("CoreGui")
	for _, container in ipairs({ coreGui, Player.PlayerGui }) do
	for _, name in ipairs(guiRootNames) do
	while true do
	local found = container:FindFirstChild(name)
	if not found then break end
	found:Destroy()
	end
	end
	end
	end)

	pcall(function()
	for _, plr in ipairs(Players:GetPlayers()) do
	local ch = plr.Character
	if ch then
	for _, part in ipairs(ch:GetChildren()) do
	for _, child in ipairs(part:GetChildren()) do
	if child.Name == "GreenDuelsBB" or child.Name == "Green22sBB" or child.Name == "22sSpeedBill" or child.Name == "22sHubOverhead"
	or child.Name == "CrystalSpeedBill" or child.Name == "SoundSpeedBill"
	or child.Name == "CrystalHubOverhead" or child.Name == "SoundHubOverhead"
	or child.Name == "CrystalTPBatMarkerBodyLock" or child.Name == "CrystalTPBatMarkerAttachment" then
	child:Destroy()
	end
	end
	end
	end
	end
	end)

	_G.__CRYSTAL_STATE = { conns = {}, stoppers = {}, alive = true }
	_G.__CrystalTrackConn = function(conn)
	if conn then table.insert(_G.__CRYSTAL_STATE.conns, conn) end
	return conn
	end
	_G.__CrystalTrackStopper = function(fn)
	if fn then table.insert(_G.__CRYSTAL_STATE.stoppers, fn) end
	end
	_G.__CrystalResetHooks = {}
	_G.__CrystalOnNewInstance = function(fn)
	if fn then table.insert(_G.__CrystalResetHooks, fn) end
	end
	end

	local crystalRuntimeState = _G.__CRYSTAL_STATE

	-- Shared Sound intro / menu / auto-steal artwork
	local Sound_INTRO_IMAGE = "rbxassetid://100534832091396"
	_G["_SoundHub_UI_ColorTheme"] = "purple"
	_G.__CrystalSoundIntroImage = Sound_INTRO_IMAGE
	_G.__SoundAccentColor = function()
		local ct = "purple"
		if _G.__CrystalHalloweenMode == true then return Color3.fromRGB(255, 126, 26) end
		if ct == "azure" then return Color3.fromRGB(80, 170, 255) end
		if ct == "green" then return Color3.fromRGB(70, 210, 110) end
		return Color3.fromRGB(168, 85, 247)
	end
	_G.__CrystalAutoGrabV2ImageId = Sound_INTRO_IMAGE

	-- Intro fully disabled: no slideshow, intro GUI, or intro music.
	_G.__SoundIntroSongs = {}
	_G.__SoundDuelsIntroPlayed = true
	_G.__CrystalIntroSound = nil
	_G.__CrystalIntroGui = nil
	_G.__CrystalSkipIntro = function()
		_G.__SoundDuelsIntroPlayed = true
		if _G.__CrystalIntroSound then pcall(function() _G.__CrystalIntroSound:Stop(); _G.__CrystalIntroSound:Destroy() end) end
		_G.__CrystalIntroSound = nil
		if _G.__CrystalIntroGui then pcall(function() _G.__CrystalIntroGui:Destroy() end) end
		_G.__CrystalIntroGui = nil
	end

	do
	local traversalJobs = {}
	local traversalConnection = nil
	local function ensureTraversalRunner()
	if traversalConnection then return end
	traversalConnection = RunService.Heartbeat:Connect(function()
	local deadline = os.clock() + 0.0008
	local processedCount = 0
	while traversalJobs[1] and processedCount < 140 and os.clock() < deadline do
	local job = traversalJobs[1]
	if job.cancelled or (job.continue and not job.continue()) then
	table.remove(traversalJobs, 1)
	else
	local object = job.pending[#job.pending]
	if not object then
	table.remove(traversalJobs, 1)
	else
	job.pending[#job.pending] = nil
	pcall(job.apply, object)
	processedCount = processedCount + 1
	local ok, children = pcall(function() return object:GetChildren() end)
	if ok then
	for _, child in ipairs(children) do job.pending[#job.pending + 1] = child end
	end

	if traversalJobs[2] then
	table.remove(traversalJobs, 1)
	traversalJobs[#traversalJobs + 1] = job
	end
	end
	end
	end
	if not traversalJobs[1] then
	traversalConnection:Disconnect()
	traversalConnection = nil
	end
	end)
	_G.__CrystalTrackConn(traversalConnection)
	end
	_G.__CrystalWalkDescendantsBatched = function(roots, apply, shouldContinue)
	local job = { pending = {}, apply = apply, continue = shouldContinue, cancelled = false }
	if typeof(roots) == "Instance" then roots = { roots } end
	for _, root in ipairs(roots or {}) do
	if root then
	local ok, children = pcall(function() return root:GetChildren() end)
	if ok then for _, child in ipairs(children) do job.pending[#job.pending + 1] = child end end
	end
	end
	traversalJobs[#traversalJobs + 1] = job
	ensureTraversalRunner()
	return function() job.cancelled = true end
	end
	_G.__CrystalTrackStopper(function()
	for _, job in ipairs(traversalJobs) do job.cancelled = true end
	traversalJobs = {}
	if traversalConnection then traversalConnection:Disconnect(); traversalConnection = nil end
	end)
	end
	local CONFIG_FILE = "SoundHub_UI_Config.txt"

	do

	local antiDieEnabled = false
	local antiDieStopped = false
	_G.__CrystalAntiDieGuiEnabled = nil
	local antiDieCharConns = {}
	local antiDieCharAddedConn = nil

	local function clearCharEntry(char, restore)
	local entry = antiDieCharConns[char]
	if entry then
	if entry.healthConn then pcall(function() entry.healthConn:Disconnect() end) end
	if entry.diedConn then pcall(function() entry.diedConn:Disconnect() end) end
	if entry.cleanupConn then pcall(function() entry.cleanupConn:Disconnect() end) end
	antiDieCharConns[char] = nil
	end
	if restore and char and char.Parent then
	pcall(function()
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
	hum.BreakJointsOnDeath = true
	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
	end
	end)
	end
	end

	local function applyAntiDieToCharacter(char)
	if not char or not char.Parent then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	clearCharEntry(char, false)

	hum.BreakJointsOnDeath = false
	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

	local entry = { humanoid = hum }
	entry.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
	if antiDieEnabled and antiDieCharConns[char] == entry and hum.Health <= 0 then
	hum.Health = hum.MaxHealth
	end
	end)

	entry.diedConn = hum.Died:Connect(function()
	task.defer(function()
	if antiDieEnabled and antiDieCharConns[char] == entry and hum and hum.Parent then
	hum.BreakJointsOnDeath = false
	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	hum.Health = hum.MaxHealth
	end
	end)
	end)

	entry.cleanupConn = char.AncestryChanged:Connect(function()
	if not char.Parent then
	clearCharEntry(char, false)
	end
	end)

	antiDieCharConns[char] = entry
	end

	local function setAntiDieEnabled(enabled)
	enabled = enabled == true
	if enabled == antiDieEnabled then return end
	antiDieEnabled = enabled
	if enabled then
	if not antiDieCharAddedConn then
	antiDieCharAddedConn = Player.CharacterAdded:Connect(function(char)
	task.wait(0.2)
	if antiDieEnabled and char and char.Parent then
	applyAntiDieToCharacter(char)
	end
	end)
	end
	local char = Player.Character
	if char and char.Parent and not antiDieCharConns[char] then
	applyAntiDieToCharacter(char)
	end
	else
	for char in pairs(antiDieCharConns) do
	clearCharEntry(char, true)
	end
	end
	end

	local antiDieSources = { toggle = false, autobat = false }
	local function refreshAntiDie()
	if antiDieStopped then return end
	local manual = antiDieSources.toggle
	if _G.__CrystalAntiDieGuiEnabled then manual = _G.__CrystalAntiDieGuiEnabled() == true end
	setAntiDieEnabled(manual or antiDieSources.autobat)
	end

	_G.__CrystalAntiDieSource = function(source, enabled)
	if antiDieStopped or antiDieSources[source] == nil then return end
	antiDieSources[source] = enabled == true
	refreshAntiDie()
	end

	_G.__CrystalAntiDieSet = function(enabled)
	_G.__CrystalAntiDieSource("autobat", enabled)
	end

	_G.__CrystalAntiDieIsEnabled = function() return antiDieEnabled end

	_G.__CrystalTrackStopper(function()
	antiDieStopped = true
	antiDieSources.toggle = false
	antiDieSources.autobat = false
	setAntiDieEnabled(false)
	end)
	local antiDieCharAddedTracked = false
	local _antiDieOrigSet = setAntiDieEnabled
	setAntiDieEnabled = function(enabled)
	_antiDieOrigSet(enabled)
	if antiDieCharAddedConn and not antiDieCharAddedTracked then
	antiDieCharAddedTracked = true
	_G.__CrystalTrackConn(antiDieCharAddedConn)
	end
	end
	local antiDieTickAcc = 0
	_G.__CrystalTrackConn(RunService.Heartbeat:Connect(function(dt)
	if antiDieStopped then return end
	antiDieTickAcc = antiDieTickAcc + (dt or 0)
	-- Refresh source flags infrequently; health recovery stays responsive when enabled.
	if antiDieTickAcc >= 0.35 then
	antiDieTickAcc = 0
	refreshAntiDie()
	end
	if not antiDieEnabled then return end
	local char = Player.Character
	local hum = char and char.Parent and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local entry = antiDieCharConns[char]
	if not entry or entry.humanoid ~= hum then applyAntiDieToCharacter(char) end
	if hum.BreakJointsOnDeath then hum.BreakJointsOnDeath = false end
	if hum:GetStateEnabled(Enum.HumanoidStateType.Dead) then
	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	end
	if hum.Health <= 0 then hum.Health = hum.MaxHealth end
	end))
	end

	FeatureToggles = FeatureToggles or {}

	local toggleStates = {}
	local transientToggles = {
	["Aimbot"] = true,
	["Autoplay"] = true,
	["Lagger"] = true,
	}
	local mobileFeatures = {
	["Aimbot"] = true,
	["Drop"] = true,
	["TP Down"] = true,
	["Autoplay"] = true,
	["ESP Players"] = true,
	["Player Tracers"] = true,
	}
	local mobileShortcutStates = {}
	local mobileBtnPlaced = {}
	for featName, _ in pairs(mobileFeatures) do
	mobileShortcutStates[featName] = false
	mobileBtnPlaced[featName] = true
	end

	if featureName == "Toggle UI" then
	bindPill.Visible = true
	bindPill.Position = UDim2.new(1, -48, 0.5, -10)
	end
	local speedValues = {
	NormalBoost = 59,
	NormalSteal = 29,
	LaggerBoost = 40,
	LaggerSteal = 20,
	DesyncBoost = 59,
	DesyncSteal = 29,
	MobileButtonScale = 1.0,
	FOV = 90,
	StretchIntensity = 0.75,
	CypherAimbotApproachSpeed = 57,
	AutoTPDownHeight = 20,
	InfJumpPower = 55,
	}
	local customSpeeds = {}
	local autoStealValues = {
	Radius      = 65,
	Duration    = 1.33,
	}
	local autoStealMode = "v1"
	local selectedMode = "Normal"
	local violetteSkinMode = "1"
	local batSkinMode = "Default"
	local batAimbotMode = "BYPASS"
	_G._AdaptBatMode = "BYPASS"
	_G._AdaptBatVersion = math.clamp(math.floor(tonumber(_G._AdaptBatVersion) or 1), 1, 3)
	if _G._AdaptBatMode ~= "NORMAL" then _G._AdaptBatVersion = 1 end
	local batSkinModeLabels = { ["Default"] = "DEFAULT", ["Abyss Blue"] = "BLUE", ["Venom Green"] = "GREEN", ["Royal Gold"] = "GOLD", ["Velvet Rose"] = "ROSE", ["Crimson Night"] = "CRIMSON", ["RGB"] = "RGB" }
	local selectedIntroMusicIndex = 1
	local normalSpeed = 59
	local carrySpeed = 29
	local laggerSpeed = 40
	local speedToggled = false
	local normalCarryManualOverride, normalCarrySelected = false, false
	local laggerCarryManualOverride, laggerCarrySelected = false, false
	local toggleSpeedPair = nil
	local carrySpeedMode = (_G._RaVeSpeedMethod == "V1") and "v1" or "v2"
	_G._RaVeSpeedMethod = (_G._RaVeSpeedMethod == "V1") and "V1" or "V2"
	-- Speed engine chosen by the user: V1 = original velocity logic, V2 = BodyForce logic
	_G.__SoundSpeedEngine = "V1"
	local laggerEnabled = false
	local lastMoveDir = Vector3.new(0, 0, 0)
	local MOVE_KEYS = {
	[Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true, [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
	[Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true, [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true,
	}
	local _prevSpeed = false
	local FeatureKeybinds = {
	SelectNormalMode = nil,
	SelectLaggerMode = nil,
	Drop = nil,
	Autoplay = nil,
	["Toggle UI"] = nil,
	["Speed Boost"] = nil,
	["Aimbot"] = nil,
	["Carry Speed"] = nil,
	["TP Bat"] = Enum.KeyCode.P,
	["TP Down"] = nil,
	["Auto Left"] = nil,
	["Auto Right"] = nil,
	["Insta Reset"] = nil,
	FuckerToggle = nil,
	}
	local listeningBindBtn = nil
	local listeningFeature = nil
	local _allBindBtns = {}
	local _featureToggleMap = {}
	local toggleVisualUpdaters = {}
	local toggleStateSetters = {}
	local ragdollCounterPaused = false
	local FeaturePostToggle = FeaturePostToggle or {}
	local FPSLabel = nil
	local PingLabel = nil
	local StatsRightFps = nil
	local StatsRightPing = nil
	_G = _G or {}
	_G.__CrystalDropMode = (_G.__CrystalDropMode == "Jump Drop") and "Jump Drop" or "Stand Drop"
	_G["_SoundHub_UI_Data"] = _G["_SoundHub_UI_Data"] or {}
	local mobileButtonPositions = {}
	local quickButtonPositions = {}
	_G.__CrystalButtonsSize = 1
	_G.__CrystalGuiScale = 1.10
	_G.__CrystalButtonsShape = _G.__CrystalButtonsShape or "Circle"
	_G.__CrystalGuiPositionResetters = {}
	_G.__CrystalResetButtonPositions = nil
	_G.__CrystalGuiPositionsReset = false
	_G.__CrystalRoundPanelBackground = function(image, panel)
		local mask = Instance.new("CanvasGroup")
		mask.Name = "RoundedBackgroundMask"
		mask.Size = UDim2.fromScale(1, 1)
		mask.Position = UDim2.fromOffset(0, 0)
		mask.BackgroundTransparency = 1
		mask.BorderSizePixel = 0
		mask.GroupTransparency = 0
		mask.ZIndex = image.ZIndex
		mask.Parent = panel
		local panelCorner = panel:FindFirstChildOfClass("UICorner")
		local corner = Instance.new("UICorner", mask)
		corner.CornerRadius = panelCorner and panelCorner.CornerRadius or UDim.new(0, 16)
		local imageCorner = image:FindFirstChildOfClass("UICorner")
		if imageCorner then imageCorner:Destroy() end
		image.Parent = mask
	end
	_G.__CrystalFramePanelBackground = function(image, index, panel)
		if not image then return end
		image.ScaleType = Enum.ScaleType.Crop
		local idx = tonumber(index) or 1
		-- Red theme: shift image more to the right in the panel
		if idx == 1 then
			image.Size = UDim2.new(1.28, 0, 1, 0)
			image.Position = UDim2.new(-0.22, 0, 0, 0)
		else
			image.Size = UDim2.fromScale(1, 1)
			image.Position = UDim2.fromScale(0, 0)
		end
	end
	_G.__CrystalApplyMainBgFrame = function(image, index)
		pcall(_G.__CrystalFramePanelBackground, image, index, nil)
	end

	_G.__EclipseAddOriginalGui3Title = function(parent, panel)
	if parent then parent.Text = string.upper(tostring(panel or "Sound")) end
	end

	local function clampOffsetsInsideViewport(scaleX, offsetX, scaleY, offsetY, width, height, sizeScale)
	local camera = workspace.CurrentCamera
	local vs = camera and camera.ViewportSize or Vector2.new(1920, 1080)
	if vs.X <= 0 or vs.Y <= 0 then return offsetX, offsetY end
	sizeScale = sizeScale or 1
	width = width * sizeScale
	height = height * sizeScale
	local minX = -vs.X * scaleX
	local maxX = vs.X * (1 - scaleX) - width
	local minY = -vs.Y * scaleY
	local maxY = vs.Y * (1 - scaleY) - height
	if maxX < minX then maxX = minX end
	if maxY < minY then maxY = minY end
	return math.clamp(offsetX, minX, maxX), math.clamp(offsetY, minY, maxY)
	end

	local function placeInsideViewport(gui, scaleX, offsetX, scaleY, offsetY, sizeScale)
	local width = gui.Size.X.Offset
	local height = gui.Size.Y.Offset
	local x, y = clampOffsetsInsideViewport(scaleX, offsetX, scaleY, offsetY, width, height, sizeScale)
	gui.Position = UDim2.new(scaleX, x, scaleY, y)
	return x, y
	end

	local isScrollDragging = false

	local function attachCleanHubTap(btn, onTap)
	return false
	end

	local cleanTapStates = setmetatable({}, { __mode = "k" })
	_G.__CrystalTrackConn(UserInputService.InputChanged:Connect((function(inp)
	local states = cleanTapStates[inp]
	if not states then return end
	if inp.UserInputType ~= Enum.UserInputType.Touch and inp.UserInputType ~= Enum.UserInputType.MouseMovement then return end
	for _, state in ipairs(states) do
	if (inp.Position - state.tapStart).Magnitude > 12 then state.tapMoved = true end
	end
	end)))
	_G.__CrystalTrackConn(UserInputService.InputEnded:Connect(function(inp)
	local states = cleanTapStates[inp]
	if not states then return end
	cleanTapStates[inp] = nil
	for _, state in ipairs(states) do
	if not state.tapMoved and not isScrollDragging then
	local scrollMoved = state.scroll and state.scrollCanvasAtStart
	and math.abs(state.scroll.CanvasPosition.Y - state.scrollCanvasAtStart) > 5
	if not scrollMoved then state.callback() end
	end
	end
	end))

	local function connectBtn(btn, callback)
	if attachCleanHubTap(btn, callback) then return end
	btn.InputBegan:Connect(function(inp)
	if inp.UserInputType ~= Enum.UserInputType.Touch and inp.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
	local activeScroll = Scroll
	local states = cleanTapStates[inp]
	if not states then states = {}; cleanTapStates[inp] = states end
	table.insert(states, {
	tapStart = inp.Position,
	tapMoved = false,
	scroll = activeScroll,
	scrollCanvasAtStart = activeScroll and activeScroll.CanvasPosition.Y or nil,
	callback = callback,
	})
	end)
	end

	local darkPalette = {
	["245,250,255"] = Color3.fromRGB(25, 31, 42),
	["235,245,255"] = Color3.fromRGB(31, 49, 70),
	["210,230,250"] = Color3.fromRGB(35, 57, 82),
	["190,220,250"] = Color3.fromRGB(55, 105, 160),
	["140,190,240"] = Color3.fromRGB(60, 135, 205),
	["80,160,255"] = Color3.fromRGB(38, 112, 205),
	["50,110,190"] = Color3.fromRGB(160, 205, 255),
	["80,130,200"] = Color3.fromRGB(165, 210, 255),
	["40,80,150"] = Color3.fromRGB(150, 200, 255),
	["30,90,200"] = Color3.fromRGB(130, 190, 255),
	["60,120,200"] = Color3.fromRGB(150, 205, 255),
	["100,140,200"] = Color3.fromRGB(165, 210, 255),
	}
	local GUI_WATCH_PROPERTIES = {"BackgroundColor3", "BorderColor3"}
	local TEXT_COLOR_PROPERTIES = {"BackgroundColor3", "TextColor3", "BorderColor3"}
	local TEXT_WATCH_PROPERTIES = {"TextColor3", "TextStrokeColor3", "TextStrokeTransparency"}
	local applyDarkPaletteTo
	local buttonThemeStates = setmetatable({}, {__mode = "k"})
	local function applyButtonTheme(instance)
	local owner = instance
	while owner and not owner:IsA("GuiButton") and not owner:GetAttribute("CrystalButtonThemeControl") do
	owner = owner.Parent
	end
	if not owner then return end
	local property = instance:IsA("UIStroke") and "Color"
		or instance:IsA("UIGradient") and "Color"
		or instance:IsA("GuiObject") and "BackgroundColor3"
	if not property then return end
	local state = buttonThemeStates[instance]
	if not state then
	state = {}
	buttonThemeStates[instance] = state
	_G.__CrystalTrackConn(instance:GetPropertyChangedSignal(property):Connect(function()
	applyButtonTheme(instance)
	end))
	end
	if state.busy then return end
	local current = instance[property]
	if current == state.applied and state.theme == _G.__CrystalGuiTheme then return end
	if current ~= state.applied then state.original = current end
	local theme = _G.__CrystalGuiTheme
	local function tint(color)
	if theme ~= "GUI 2" and theme ~= "GUI 3" then return color end
	local brightness = math.max(color.R, color.G, color.B)

	local dark = theme == "GUI 2" and Color3.fromRGB(12, 24, 42) or Color3.fromRGB(43, 13, 17)
	local bright = theme == "GUI 2" and Color3.fromRGB(100, 175, 255) or Color3.fromRGB(246, 65, 77)
	return dark:Lerp(bright, brightness)
	end
	local result = state.original
	if instance:IsA("UIGradient") then
	if theme == "GUI 2" or theme == "GUI 3" then
	local points = {}
	for _, point in ipairs(result.Keypoints) do
	table.insert(points, ColorSequenceKeypoint.new(point.Time, tint(point.Value)))
	end
	result = ColorSequence.new(points)
	end
	else
	result = tint(result)
	end
	state.applied = result
	state.theme = theme
	if current ~= result then
	state.busy = true
	instance[property] = result
	state.busy = false
	end
	end
	applyDarkPaletteTo = (function(instance)
	if not instance then return end
	local colorProperties = nil
	if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
	colorProperties = TEXT_COLOR_PROPERTIES
	elseif instance:IsA("GuiObject") then
	colorProperties = GUI_WATCH_PROPERTIES
	end
	if colorProperties then
	for _, property in ipairs(colorProperties) do
	local color = instance[property]
	local key = string.format("%d,%d,%d", math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
	if darkPalette[key] then instance[property] = darkPalette[key] end
	end
	end
	if instance:IsA("UIStroke") then
	local color = instance.Color
	local key = string.format("%d,%d,%d", math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
	if color.B > color.R + 12 and color.B >= color.G then instance.Color = Color3.fromRGB(0, 0, 0)
	elseif darkPalette[key] then instance.Color = darkPalette[key] end
	end

	if not _G.__CrystalModernGuiActive and not instance:GetAttribute("CrystalDarkPaletteWatched") then
	instance:SetAttribute("CrystalDarkPaletteWatched", true)
	local function watchProperty(property)
	_G.__CrystalTrackConn(instance:GetPropertyChangedSignal(property):Connect(function()
	applyDarkPaletteTo(instance)
	end))
	end
	if instance:IsA("UIStroke") then
	watchProperty("Color")
	elseif instance:IsA("GuiObject") then
	for _, property in ipairs(GUI_WATCH_PROPERTIES) do watchProperty(property) end
	if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
	for _, property in ipairs(TEXT_WATCH_PROPERTIES) do watchProperty(property) end
	end
	end
	end
	applyButtonTheme(instance)
	end)

	_G.__CrystalThemeRoots = {}
	local themeWalkCancels = setmetatable({}, { __mode = "k" })
	_G.__CrystalRegisterThemeRoot = (function(root)
	if not root then return end
	for _, savedRoot in ipairs(_G.__CrystalThemeRoots) do
	if savedRoot == root then return end
	end
	table.insert(_G.__CrystalThemeRoots, root)
	applyDarkPaletteTo(root)
	if themeWalkCancels[root] then themeWalkCancels[root]() end
	themeWalkCancels[root] = _G.__CrystalWalkDescendantsBatched(root, applyDarkPaletteTo, function()
	return root.Parent ~= nil
	end)
	_G.__CrystalTrackConn(root.DescendantAdded:Connect(applyDarkPaletteTo))
	end)
	_G.__CrystalApplyTheme = (function()
	for _, root in ipairs(_G.__CrystalThemeRoots) do
	if root and root.Parent then
	applyDarkPaletteTo(root)
	if themeWalkCancels[root] then themeWalkCancels[root]() end
	themeWalkCancels[root] = _G.__CrystalWalkDescendantsBatched(root, applyDarkPaletteTo, function()
	return root.Parent ~= nil
	end)
	end
	end
	end)

_G.__CrystalAddUnifiedPanelShade = function(parent, cornerRadius, zIndex)
	if not parent then return nil end
	for _, oldName in ipairs({"UnifiedBackgroundShade", "UnifiedPanelWhiteOutline", "UnifiedPanelWhiteGlow", "UnifiedPanelAccentOutline"}) do
		local old = parent:FindFirstChild(oldName)
		if old then old:Destroy() end
	end
	local shade = Instance.new("Frame")
	shade.Name = "UnifiedBackgroundShade"
	shade.Size = UDim2.fromScale(1, 1)
	shade.Position = UDim2.fromScale(0, 0)
	shade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	shade.BackgroundTransparency = 0.68
	shade.BorderSizePixel = 0
	shade.Active = false
	shade.ZIndex = zIndex or 1
	shade.Parent = parent
	Instance.new("UICorner", shade).CornerRadius = UDim.new(0, cornerRadius or 16)
	local shadeGradient = Instance.new("UIGradient", shade)
	shadeGradient.Rotation = 90
	shadeGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.28),
		NumberSequenceKeypoint.new(0.55, 0.42),
		NumberSequenceKeypoint.new(1, 0.56),
	})

	-- Match AmbitiousTest's crisp purple outline (no white edge or glow).
	local outline = Instance.new("UIStroke")
	outline.Name = "UnifiedPanelAccentOutline"
	outline.Color = Color3.fromRGB(126, 71, 190)
	outline.Thickness = 1.4
	outline.Transparency = 0.32
	outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	outline.LineJoinMode = Enum.LineJoinMode.Round
	outline.Parent = parent
	return shade
end


	local gamepadInputTypes = {
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true,
	[Enum.UserInputType.Gamepad5] = true,
	[Enum.UserInputType.Gamepad6] = true,
	[Enum.UserInputType.Gamepad7] = true,
	[Enum.UserInputType.Gamepad8] = true,
	}

	local function isBindableInput(input)
	return input
	and input.KeyCode
	and input.KeyCode ~= Enum.KeyCode.Unknown
	and (input.UserInputType == Enum.UserInputType.Keyboard or gamepadInputTypes[input.UserInputType])
	end

	local function isClearKeybindInput(input)
	return input
	and input.UserInputType == Enum.UserInputType.Keyboard
	and input.KeyCode == Enum.KeyCode.RightControl
	end

	local mouseButtonMap = {}
	local mouseButtonDisplay = {
	["MB3"] = "Mouse3",
	}
	pcall(function() mouseButtonMap[Enum.UserInputType.MouseButton3] = "MB3" end)
	local function isMouseSideButton(input)
	return input and mouseButtonMap[input.UserInputType] ~= nil
	end
	local function getMouseButtonBind(input)
	return mouseButtonMap[input.UserInputType]
	end

	local function keybindDisplayName(key)
	if not key then return "-" end
	if type(key) == "string" then return mouseButtonDisplay[key] or key end
	return tostring(key):match("KeyCode%.(.+)") or tostring(key)
	end

	local VIOLETTE_SKIN_SETS = {
	["1"] = {
		displayName = "PURPLE", hats = "1744060292,439945661,1125510,1029025", hair = "",
		headless = true, korblox = "Right",
		accessories = {1744060292, 439945661, 1125510, 1029025, 11748356, 8465506143, 11444217173},
		clothing = {7424637509, 7689651773},
	},
	["2"] = {
		displayName = "BLUE", hats = "74891470",
		hair = "16630147,6346833550,6594911228,6594919952,6823338112,7097747842",
		headless = true, korblox = "Right",
		accessories = {74891470, 16630147, 6346833550, 6594911228, 6594919952, 6823338112, 7097747842},
		clothing = {18423061209, 18423154566},
	},
	["3"] = {
		displayName = "RED", hats = "215718515,439945661", hair = "7183785281",
		headless = true, korblox = "Right",
		accessories = {215718515, 439945661, 7183785281},
		clothing = {15998365201, 7689651773},
	},
	["4"] = {
		displayName = "BLACK", hats = "10159600649,439946249,17798262442,92482095662016",
		hair = "139101716417676", headless = true, korblox = "Right",
		accessories = {10159600649, 439946249, 17798262442, 92482095662016, 139101716417676, 12490213797},
		clothing = {18766106994, 13925390578},
	},
	["5"] = {
		displayName = "GREEN", hats = "553970961,1744060292", hair = "93268856876777",
		headless = true, korblox = "Right",
		accessories = {553970961, 1744060292, 93268856876777},
		clothing = {9478068776, 6348682339},
	},
	["6"] = {
		displayName = "WHITE",
		hats = "74891470,215718515,439945661,1016143686,1744060292,10159600649,89012651581593,88365652378427",
		hair = "126447390530523", headless = true, korblox = "Right",
		accessories = {74891470, 215718515, 439945661, 1016143686, 1744060292, 10159600649, 89012651581593, 126447390530523},
		clothing = {88032876921227, 108259950755140},
	},
	-- Skins ported from Rival Hub.
	["7"] = {
		displayName = "ALIEN",
		headless = true,
		accessories = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322, 10997283529, 125085889448130},
	},
	-- Outfit packs imported from the VX7 script.

	["8"] = {
		displayName = "OUTFIT",
		accessories = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322, 125157548394108, 123231522991173, 74827642361405},
	},
	["9"] = {
		displayName = "OUTFIT 2",
		face = 86109936998865,
		scales = {HeightScale = 1, WidthScale = 0.85, DepthScale = 0.88, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.85},
		accessories = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322, 136644276218918, 132022106987543, 131740907052260},
	},
	["10"] = {
		displayName = "OUTFIT 3",
		headless = true,
		accessories = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322, 119331031817124, 84952305140948},
	},
	["11"] = {
		displayName = "OUTFIT 4",
		headless = true,
		accessories = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322, 18902416696, 17739456422, 116750288839357, 12842417046, 122223069519702},
	},
	["12"] = {
		displayName = "OUTFIT 5",
		accessories = {13935333090, 16110951997, 10632503818},
	},
	["13"] = {
		displayName = "OUTFIT 6",
		headless = true,
		accessories = {74891470, 4390891467, 91274263831244, 128424248603010, 91151766440767, 17044638424},
	},
	["14"] = {
		displayName = "RIVAL",
		headless = true,
		korblox = "Right",
		accessories = {76479271580913, 1402432199, 140627490971265, 128912609563885, 17449551560, 5796531729, 139607718},
	},
	["15"] = {
		displayName = "NEW SKIN",
		headless = true,
		korblox = "Right",
		accessories = {70414871864071, 14863917259, 133498027006138, 82277826177074},
	},
	["16"] = {
		displayName = "OUTFIT 1",
		korblox = "Right",
		accessories = {10159600649},
		clothing = {9683332638, 93182020184041},
	},
	["17"] = {
		displayName = "OUTFIT 2 CLASSIC",
		korblox = "Right",
		accessories = {1744060292},
		clothing = {9683332638, 93182020184041},
	},


}
local function getVioletteSkinSet(mode)
	return VIOLETTE_SKIN_SETS[tostring(mode or "1")]
end
local function refreshVioletteSkinCatalog()
	local activeSets = {}
	local order = {}
	for key, skin in pairs(VIOLETTE_SKIN_SETS) do
		activeSets[key] = skin
		table.insert(order, key)
	end
	table.sort(order, function(a, b)
		return (tonumber(a) or math.huge) < (tonumber(b) or math.huge)
	end)
	_G._KawatanSkinSets = activeSets
	_G._KawatanSkinSetOrder = order
	return activeSets
end
refreshVioletteSkinCatalog()
_G.__CrystalHalloweenVioletteSkinSets = {}
_G._KawatanSkinColor = _G._KawatanSkinColor or "1"
	do
		local assetProperties = {
			[11] = "Shirt", [12] = "Pants", [2] = "GraphicTShirt",
			[8] = "HatAccessory", [41] = "HairAccessory", [42] = "FaceAccessory",
			[43] = "NeckAccessory", [44] = "ShouldersAccessory", [45] = "FrontAccessory",
			[46] = "BackAccessory", [47] = "WaistAccessory", [64] = "TShirtAccessory",
			[65] = "ShirtAccessory", [66] = "PantsAccessory", [67] = "JacketAccessory",
			[68] = "SweaterAccessory", [69] = "ShortsAccessory", [70] = "LeftShoeAccessory",
			[71] = "RightShoeAccessory", [72] = "DressSkirtAccessory",
		}
		local function addPreviewAsset(description, assetId)
			local ok, info = pcall(function()
				return game:GetService("MarketplaceService"):GetProductInfo(assetId, Enum.InfoType.Asset)
			end)
			if not ok or not info then return end
			local property = assetProperties[tonumber(info.AssetTypeId)]
			if not property then return end
			if property == "Shirt" or property == "Pants" or property == "GraphicTShirt" then
				pcall(function() description[property] = assetId end)
			else
				local current = ""
				pcall(function() current = tostring(description[property] or "") end)
				pcall(function() description[property] = current == "" and tostring(assetId) or (current .. "," .. tostring(assetId)) end)
			end
		end
		_G._KawatanBuildSetDescription = function(setName)
			local skin = getVioletteSkinSet(setName)
			if not skin then return nil end
			local base
			pcall(function()
				local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
				if hum then base = hum:GetAppliedDescription() end
			end)
			local description = base and base:Clone() or Instance.new("HumanoidDescription")
			for _, property in ipairs({"HatAccessory", "HairAccessory", "FaceAccessory", "NeckAccessory", "ShouldersAccessory", "FrontAccessory", "BackAccessory", "WaistAccessory", "ShirtAccessory", "PantsAccessory", "JacketAccessory", "SweaterAccessory", "ShortsAccessory", "TShirtAccessory", "DressSkirtAccessory"}) do pcall(function() description[property] = "" end) end
			pcall(function() description.Shirt = 0; description.Pants = 0; description.GraphicTShirt = 0 end)
			pcall(function()
				description.HatAccessory = skin.hats or ""
				description.HairAccessory = skin.hair or ""
				if skin.head then description.Head = skin.head end
				if skin.face then description.Face = skin.face end
				for property, value in pairs(skin.scales or {}) do description[property] = value end
			end)
			for _, id in ipairs(skin.accessories or {}) do addPreviewAsset(description, id) end
			for _, id in ipairs(skin.clothing or {}) do addPreviewAsset(description, id) end
			return description
		end
	end

	local toggleDefaults = {}
	toggleDefaults["Intro Skip"] = false
	toggleDefaults["Inf Jump"] = false
	toggleDefaults["TP Down"] = false
	toggleDefaults["Auto TP Down"] = false
	toggleDefaults["Anti Ragdoll"] = false
toggleDefaults["Ragdoll TP"] = false
toggleDefaults["Anti Void"] = false
	_G.__CrystalPanelScales = type(_G.__CrystalPanelScales) == "table" and _G.__CrystalPanelScales or { Bypass = 1, Lagger = 1, AntiLose = 1 }
	_G.__CrystalPanelsLocked = _G.__CrystalPanelsLocked == true
	toggleDefaults["Anti Anti Lose"] = false
	toggleDefaults["No Player Collision"] = false
	toggleDefaults["Ragdoll Counter"] = false
	toggleDefaults["Medusa Counter"] = false
	toggleDefaults["Medusa Range Circle"] = false
	toggleDefaults["Anti Bat"] = false
	toggleDefaults["White Tools"] = false
	toggleDefaults["Aimbot"] = false
	toggleDefaults["Mirror TP"] = false
	toggleDefaults["Autoplay"] = false
	toggleDefaults["Drop"] = false
	toggleDefaults["auto steal"] = false
	toggleDefaults["Steal Bar"] = true
	toggleDefaults["ESP Players"] = false
	toggleDefaults["Player Tracers"] = false
	toggleDefaults["Skeleton ESP"] = false
	toggleDefaults["Show Buttons"] = false
	toggleDefaults["Lock Panel Positions"] = false
	_G.__CrystalHiddenQuickButtons = type(_G.__CrystalHiddenQuickButtons) == "table" and _G.__CrystalHiddenQuickButtons or {}
	toggleDefaults["Lock Buttons"] = false
	toggleDefaults["Show FPS"] = false
	toggleDefaults["FPS Boost"] = false
	toggleDefaults["Anti Lag"] = false
	toggleDefaults["Potato Graphics"] = false
	toggleDefaults["Vivid Graphics"] = false
	toggleDefaults["X-Ray"] = false
	toggleDefaults["Lagger"] = false
	toggleDefaults["Speed Boost"] = false
	toggleDefaults["Toggle UI"] = true
	toggleDefaults["Auto Steal Speed"] = false
	toggleDefaults["Auto Carry Speed"] = false
	toggleDefaults["Carry Speed"] = false
	toggleDefaults["Unwalk"] = false
	toggleDefaults["Harder Hit Anim"] = false
	toggleDefaults["Animations"] = false
	toggleDefaults["Custom FOV"] = false
	toggleDefaults["Custom Font"] = true
toggleDefaults["Motion Blur"] = false
	toggleDefaults["Stretchz Res"] = false
	toggleDefaults["Sky Changer"] = false
	toggleDefaults["Violette Custom Skins"] = false
	toggleDefaults["Sound Skin"] = false
	toggleDefaults["Headless Visual"] = false
	toggleDefaults["Korblox Visual"] = false
	toggleDefaults["Halloween Mode"] = false
	toggleDefaults["Anti Die"] = false
	for k, v in pairs(toggleDefaults) do toggleStates[k] = v end

	local lastSavedConfigData = nil
	local pendingConfigData = nil
	local configSaveGeneration = 0
	local function flushConfig(data)
	if not data or data == lastSavedConfigData then return end
	pcall(writefile, CONFIG_FILE, data)
	lastSavedConfigData = data
	end
	local function saveConfig()
	local lines = {}
	for name, state in pairs(toggleStates) do
	if not transientToggles[name] then
	table.insert(lines, "T:" .. name .. "=" .. tostring(state))
	end
	end
	for name, state in pairs(mobileShortcutStates) do
	table.insert(lines, "S:" .. name .. "=" .. tostring(state))
	end
	for name, state in pairs(mobileBtnPlaced) do
	table.insert(lines, "B:" .. name .. "=" .. tostring(state))
	end
	for k, v in pairs(speedValues) do
	table.insert(lines, "V:" .. k .. "=" .. tostring(v))
	end
	for k, v in pairs(autoStealValues) do
	table.insert(lines, "A:" .. k .. "=" .. tostring(v))
	end
	for _, cs in ipairs(customSpeeds) do
	table.insert(lines, "C:" .. cs.name .. "=" .. cs.boost .. "," .. cs.steal)
	end
	if _G.__SoundHub_Anims then
	for k, v in pairs(_G.__SoundHub_Anims) do
	table.insert(lines, "N:" .. k .. "=" .. v)
	end
	end
	table.insert(lines, "M:selectedMode=" .. selectedMode)
	table.insert(lines, "M:normalCarryManual=" .. tostring(normalCarryManualOverride))
	table.insert(lines, "M:normalCarrySelected=" .. tostring(normalCarrySelected))
	table.insert(lines, "M:laggerCarryManual=" .. tostring(laggerCarryManualOverride))
	table.insert(lines, "M:laggerCarrySelected=" .. tostring(laggerCarrySelected))
	table.insert(lines, "M:optimizerMode=" .. tostring(_G.__optimizerMode or "Ultra"))
	table.insert(lines, "M:autoplayMode=Semi")
	table.insert(lines, "M:skyIndex=" .. (tostring(_G.__skyGetIndex and _G.__skyGetIndex() or 1)))
	table.insert(lines, "M:skyMode=" .. tostring(_G.__CrystalSkyChangerMode or "blue"))
	table.insert(lines, "M:violetteSkinMode=" .. tostring(violetteSkinMode))
table.insert(lines, "M:batSkinMode=" .. tostring(batSkinMode or "Default"))
table.insert(lines, "M:batAimbotMode=" .. ((_G._AdaptBatMode == "BYPASS") and "BYPASS" or "NORMAL"))
table.insert(lines, "M:batAimbotVersion=" .. tostring(math.clamp(math.floor(tonumber(_G._AdaptBatVersion) or 1), 1, 3)))
	table.insert(lines, "M:katanaIndex=" .. (tostring(_G.__katanaGetIndex and _G.__katanaGetIndex() or 1)))
	table.insert(lines, "M:autoStealMode=" .. tostring(autoStealMode or "v1"))
	table.insert(lines, "M:speedMethod=AUTO")
	table.insert(lines, "M:speedEngine=V1")
	table.insert(lines, "M:carrySpeedMode=v2")
	table.insert(lines, "M:autoCarryMode=" .. ((_G.__SoundAutoCarryMode == "SOFT") and "SOFT" or "NORMAL"))
	table.insert(lines, "M:dropMode=" .. ((_G.__CrystalDropMode == "Jump Drop") and "Jump Drop" or "Stand Drop"))
	table.insert(lines, "M:infJumpMode=" .. (_G.__CrystalInfJumpMode or "manual"))
	table.insert(lines, "M:panelVisible=" .. tostring(_G.__CrystalPanelVisible ~= false))
	table.insert(lines, "M:tabPosition=" .. tostring(_G.__CrystalTabPosition or "Top"))
	table.insert(lines, "M:batVersion=" .. tostring(math.clamp(math.floor(tonumber(_G.__batVersion) or 1), 1, 2)))
	table.insert(lines, "M:buttonsSize=" .. tostring(_G.__CrystalButtonsSize or 1))
	table.insert(lines, "M:buttonsShape=" .. tostring(_G.__CrystalButtonsShape or "Circle"))
	table.insert(lines, "M:tpBatV2Distance=3")
	if _G.__CrystalAnimationPreset then
	table.insert(lines, "M:animationPreset=" .. tostring(_G.__CrystalAnimationPreset))
	end
	table.insert(lines, "M:animationPackIndex=" .. tostring(math.clamp(math.floor(tonumber(_G.__CrystalAnimationPackIndex) or 1), 1, 13)))
	local animationConfigIds = type(_G.__CrystalCustomAnimationIds) == "table" and _G.__CrystalCustomAnimationIds or {}
	for _, animationSlot in ipairs({"idle", "walk", "run", "jump", "fall"}) do
		table.insert(lines, "M:animationCustom_" .. animationSlot .. "=" .. tostring(animationConfigIds[animationSlot] or ""))
	end
	table.insert(lines, "M:guiTheme=" .. tostring(_G.__CrystalGuiTheme or "GUI 1"))
	table.insert(lines, "M:customFont=" .. tostring(_G.CrystalFontChoice or "Default"))
	table.insert(lines, "M:themePrimary=" .. (_G.__CrystalThemePrimary or "BLACK"))
	table.insert(lines, "M:themeSecondary=" .. (_G.__CrystalThemeSecondary or "BLUE"))
	table.insert(lines, "M:autoGrabExpanded=" .. tostring(_G["_SoundHub_UI_AutoGrabExpanded"] ~= false))
	table.insert(lines, "M:autoGrabBarScale=" .. tostring(_G["_SoundHub_UI_AutoGrabBarScale"] or 1))
	table.insert(lines, "M:autoGrabBarStyle=" .. tostring(_G["_SoundHub_UI_AutoGrabBarStyle"] or "4"))
	table.insert(lines, "M:autoStealUiV1=" .. tostring(_G["_SoundHub_UI_AutoGrabSkin"] or "V1"))
	table.insert(lines, "M:purpleTitle=" .. ((_G["_SoundHub_UI_PurpleTitle"] == "New") and "New" or "Default"))
	table.insert(lines, "M:titleAzure=" .. ((_G["_SoundHub_UI_TitleVariant_azure"] == "V2") and "V2" or "V1"))
	table.insert(lines, "M:titleGreen=" .. ((_G["_SoundHub_UI_TitleVariant_green"] == "V2") and "V2" or "V1"))
	table.insert(lines, "M:titleHalloween=" .. ((_G["_SoundHub_UI_TitleVariant_halloween"] == "V2") and "V2" or "V1"))
	for feat, key in pairs(FeatureKeybinds) do
	if key then
	local keyName
	if type(key) == "string" then
	keyName = key
	else
	keyName = tostring(key):match("KeyCode%.(.+)") or tostring(key)
	end
	table.insert(lines, "K:" .. feat .. "=" .. keyName)
	end
	end
	if _G["_SoundHub_UI_MenuPos"] then
	local pos = _G["_SoundHub_UI_MenuPos"]
	if pos.x and pos.y then
	table.insert(lines, "P:menuPos=" .. math.floor(pos.x) .. "," .. math.floor(pos.y))
	end
	end
	table.insert(lines, "M:introMusicIndex=" .. tostring(selectedIntroMusicIndex))
	table.insert(lines, "M:bgIndex=" .. tostring(_G["_SoundHub_UI_BgIndex"] or 1))
	do
		local ps = type(_G.__CrystalPanelScales) == "table" and _G.__CrystalPanelScales or {}
		table.insert(lines, "M:panelScaleBypass=" .. tostring(ps.Bypass or 1))
		table.insert(lines, "M:panelScaleLagger=" .. tostring(ps.Lagger or 1))
		table.insert(lines, "M:panelScaleAntiLose=" .. tostring(ps.AntiLose or 1))
	end
	table.insert(lines, "M:panelsLocked=" .. tostring(_G.__CrystalPanelsLocked == true))
	if typeof(_G.__CrystalQuickPanelOrigin) == "Vector2" then table.insert(lines, "M:quickPanelPos=" .. math.floor(_G.__CrystalQuickPanelOrigin.X) .. "," .. math.floor(_G.__CrystalQuickPanelOrigin.Y)) end
	table.insert(lines, "M:quickPanel=" .. tostring(_G.__CrystalQuickPanel == true))
	table.insert(lines, "M:quickBgIndex=" .. tostring(tonumber(_G.__CrystalQuickBgIndex) or 1))
	local hiddenQB = _G.__CrystalHiddenQuickButtons
	if type(hiddenQB) == "table" then
		local parts = {}
		for name, hid in pairs(hiddenQB) do if hid then table.insert(parts, tostring(name)) end end
		table.sort(parts)
		if #parts > 0 then table.insert(lines, "M:hiddenQuickButtons=" .. table.concat(parts, ",")) end
		if hiddenQB["AUTO PLAY"] == false then table.insert(lines, "M:shownQuickDefaultOff=AUTO PLAY") end
		if hiddenQB["CUSTOM SPEED"] == false then table.insert(lines, "M:shownQuickDefaultOff2=CUSTOM SPEED") end
	end
	table.insert(lines, "M:colorTheme=" .. tostring(_G["_SoundHub_UI_ColorTheme"] or "azure"))
	table.insert(lines, "M:bgPicked=" .. ((_G["_SoundHub_UI_BgPicked"] == true) and "1" or "0"))
	table.insert(lines, "M:bgUserPicked=" .. ((_G["_SoundHub_UI_BgUserPicked"] == true) and "1" or "0"))
	table.insert(lines, "M:menuUi=" .. tostring(_G["_SoundHub_UI_MenuUi"] or "1"))
	if _G.__toggleBtn then
	table.insert(lines, "P:toggleBtn=" .. math.floor(_G.__toggleBtn.Position.X.Offset) .. "," .. math.floor(_G.__toggleBtn.Position.Y.Offset))
	end

	for name, pos in pairs(mobileButtonPositions) do
	if pos.x and pos.y then
	local extra = ""
	if pos.xs and pos.ys then extra = ":" .. pos.xs .. ":" .. pos.ys end
	table.insert(lines, "P:mobileBtn_" .. name .. "=" .. math.floor(pos.x) .. "," .. math.floor(pos.y) .. extra)
	end
	end
	for name, pos in pairs(quickButtonPositions) do
	if pos.x and pos.y then
	table.insert(lines, "P:quickBtn_" .. name .. "=" .. math.floor(pos.x) .. "," .. math.floor(pos.y))
	end
	end
	if _G["_SoundHub_UI_SpeedFramePos"] then
	local pos = _G["_SoundHub_UI_SpeedFramePos"]
	if pos.x and pos.y then
	table.insert(lines, "P:speedFrame=" .. math.floor(pos.x) .. "," .. math.floor(pos.y))
	end
	end
	if _G["_SoundHub_EnemyWidget_SaveHook"] then pcall(_G["_SoundHub_EnemyWidget_SaveHook"]) end
	if _G["_SoundHub_UI_EnemyWidgetPos"] then
	local pos = _G["_SoundHub_UI_EnemyWidgetPos"]
	if pos.x and pos.y then
	table.insert(lines, "P:enemyWidget=" .. math.floor(pos.x) .. "," .. math.floor(pos.y))
	end
	end
	if _G["_SoundHub_UI_AutoGrabBarPos"] then
	local pos = _G["_SoundHub_UI_AutoGrabBarPos"]
	if pos.x and pos.y then
	table.insert(lines, "P:autoGrabBar=" .. math.floor(pos.x) .. "," .. math.floor(pos.y))
	end
	end
	if _G["_SoundHub_UI_AutoGrabBarSize"] then
	table.insert(lines, "P:autoGrabBarSize=" .. tostring(_G["_SoundHub_UI_AutoGrabBarSize"]))
	end
	if _G["_SoundHub_UI_ModernMiniPos"] then
	local pos = _G["_SoundHub_UI_ModernMiniPos"]
	if pos.x and pos.y then table.insert(lines, "P:modernMini=" .. math.floor(pos.x) .. "," .. math.floor(pos.y)) end
	end
	local data = table.concat(lines, "\n")
	if data == lastSavedConfigData or data == pendingConfigData then return end
	pendingConfigData = data
	_G["_SoundHub_UI_Data"] = data
	configSaveGeneration = configSaveGeneration + 1
	local generation = configSaveGeneration

	task.delay(0.2, function()
	if generation ~= configSaveGeneration or pendingConfigData ~= data then return end
	pendingConfigData = nil
	flushConfig(data)
	end)
	end
	_G.__CrystalTrackStopper(function()
	if pendingConfigData then flushConfig(pendingConfigData); pendingConfigData = nil end
	end)

	local function deactivateOtherAimbots(keepName)
	local changed = false
	for _, name in ipairs({ "Aimbot", "TP Bat" }) do
	if name ~= keepName and name ~= "TP Bat" and toggleStates[name] then
	toggleStates[name] = false
	changed = true
	local setter = toggleStateSetters[name]
	if setter then pcall(setter, false) end
	if FeaturePostToggle[name] then pcall(FeaturePostToggle[name], false) end
	end
	end
	if changed then saveConfig() end
	end

	local function deactivateBatExclusive(keepName)
	local changed = false
	for _, name in ipairs({ "Aimbot", "TP Bat" }) do
	if name ~= keepName and name ~= "TP Bat" and toggleStates[name] then
	toggleStates[name] = false
	changed = true
	local setter = toggleStateSetters[name]
	if setter then pcall(setter, false) end
	if FeaturePostToggle[name] then pcall(FeaturePostToggle[name], false) end
	end
	end
	if changed then saveConfig() end
	end
	_G.__deactivateBatExclusive = deactivateBatExclusive

	local function loadConfig()
	local data = nil
	local ok, result = pcall(readfile, CONFIG_FILE)
	if ok and result and #result > 0 then
	data = result
	elseif _G["_SoundHub_UI_Data"] and #_G["_SoundHub_UI_Data"] > 0 then
	data = _G["_SoundHub_UI_Data"]
	end
	if not data then return end
	for line in data:gmatch("[^\n]+") do
	local prefix = line:sub(1, 2)
	local rest = line:sub(3)
	local k, v = rest:match("([^=]+)=(.+)")
	if k and v then
	k = k:match("^%s*(.-)%s*$")
	v = v:match("^%s*(.-)%s*$")
	if prefix == "T:" and k == "Animaciones" then k = "Animations" end
	if prefix == "T:" and toggleStates[k] ~= nil and not transientToggles[k] then
	toggleStates[k] = (v == "true")
	elseif prefix == "S:" then
	mobileShortcutStates[k] = (v == "true")
	elseif prefix == "B:" then
	mobileBtnPlaced[k] = (v == "true")
	elseif prefix == "V:" and speedValues[k] ~= nil then
	local num = tonumber(v)
	if num then
	speedValues[k] = num
	if k == "NormalBoost" then normalSpeed = num end
	if k == "NormalSteal" then carrySpeed = num end
	if k == "LaggerBoost" then laggerSpeed = num end
	end
	elseif prefix == "N:" then
	_G.__savedAnimations = _G.__savedAnimations or {}
	_G.__savedAnimations[k] = v
	elseif prefix == "M:" then
	if k == "introMusicIndex" then
	selectedIntroMusicIndex = math.clamp(tonumber(v) or 1, 1, 9)
	_G.__SoundIntroMusicIndex = selectedIntroMusicIndex
	elseif k == "bgIndex" then
	_G["_SoundHub_UI_BgIndex"] = math.clamp(tonumber(v) or 1, 1, 99)
	elseif k == "panelScaleBypass" or k == "panelScaleLagger" or k == "panelScaleAntiLose" then
	_G.__CrystalPanelScales = type(_G.__CrystalPanelScales) == "table" and _G.__CrystalPanelScales or {}
	local key = (k == "panelScaleBypass" and "Bypass") or (k == "panelScaleLagger" and "Lagger") or "AntiLose"
	_G.__CrystalPanelScales[key] = math.clamp(tonumber(v) or 1, 0.6, 1.8)
	elseif k == "quickPanelPos" then
	local px, py = tostring(v):match("^(-?%d+),(-?%d+)$")
	if px and py then _G.__CrystalQuickPanelOrigin = Vector2.new(tonumber(px), tonumber(py)) end
	elseif k == "quickPanel" then
	-- Ignore any old saved setting; Buttons Panel Menu BG stays permanently OFF.
	_G.__CrystalQuickPanel = false
	elseif k == "quickBgIndex" then
	_G.__CrystalQuickBgIndex = math.clamp(math.floor(tonumber(v) or 1), 0, 9)
	elseif k == "panelsLocked" then
	_G.__CrystalPanelsLocked = (v == "true" or v == true)
	elseif k == "hiddenQuickButtons" then
	local hidden = {}
	for name in tostring(v or ""):gmatch("[^,]+") do
		local n = name:match("^%s*(.-)%s*$")
		if n and n ~= "" then hidden[n] = true end
	end
	_G.__CrystalHiddenQuickButtons = hidden
	elseif k == "shownQuickDefaultOff" or k == "shownQuickDefaultOff2" then
	if type(_G.__CrystalHiddenQuickButtons) ~= "table" then _G.__CrystalHiddenQuickButtons = {} end
	_G.__CrystalHiddenQuickButtons[tostring(v)] = false
	elseif k == "colorTheme" then
	_G["_SoundHub_UI_ColorTheme"] = "purple"
	elseif k == "bgPicked" then
	_G["_SoundHub_UI_BgPicked"] = (v == "1")
	elseif k == "bgUserPicked" then
	_G["_SoundHub_UI_BgUserPicked"] = (v == "1")
	elseif k == "halloweenBgIndex" then
	local n = tonumber(v)
	if n then _G["_SoundHub_UI_HalloweenBgIndex"] = math.clamp(n, 1, 99) end
	elseif k == "selectedMode" then
	if v == "Normal" or v == "Lagger" or v == "Desync" then selectedMode = v end
	elseif k == "normalCarryManual" then
	normalCarryManualOverride = (v == "true")
	elseif k == "normalCarrySelected" then
	normalCarrySelected = (v == "true")
	elseif k == "laggerCarryManual" then
	laggerCarryManualOverride = (v == "true")
	elseif k == "laggerCarrySelected" then
	laggerCarrySelected = (v == "true")
	elseif k == "autoplayMode" then
	_G.__autoplayMode = "Semi"
	elseif k == "skyIndex" then
	_G.__savedSkyIndex = tonumber(v)
	elseif k == "skyMode" then
	if v == "blue" or v == "sunset" or v == "galaxy" or v == "cherry" or v == "aurora" or v == "ocean" or v == "dusk" or v == "toxic" then _G.__CrystalSkyChangerMode = v end
	elseif k == "katanaIndex" then
	_G.__savedKatanaIndex = tonumber(v)
	elseif k == "autoStealMode" then

	if v == "v3" then v = "v1" end
	autoStealMode = "v1"
	elseif k == "speedEngine" then
	_G.__SoundSpeedEngine = "V1"
	elseif k == "speedMethod" then
	_G._RaVeSpeedMethod = (v == "V1") and "V1" or "V2"
	carrySpeedMode = (_G._RaVeSpeedMethod == "V1") and "v1" or "v2"
	elseif k == "carrySpeedMode" then
	if v == "v1" or v == "v2" then
		carrySpeedMode = v
		_G._RaVeSpeedMethod = (v == "v1") and "V1" or "V2"
	end
	elseif k == "optimizerMode" then
	if v == "Normal" or v == "Ultra" then _G.__optimizerMode = v end
	elseif k == "autoCarryMode" then
	_G.__SoundAutoCarryMode = (v == "SOFT") and "SOFT" or "NORMAL"
	elseif k == "dropMode" then
	_G.__CrystalDropMode = (v == "Jump Drop") and "Jump Drop" or "Stand Drop"
	elseif k == "infJumpMode" then
	if v == "hold" or v == "manual" then _G.__CrystalInfJumpMode = v end
	elseif k == "autoGrabExpanded" then
	_G["_SoundHub_UI_AutoGrabExpanded"] = (v == "true")
	elseif k == "menuUi" then
	_G["_SoundHub_UI_MenuUi"] = (v == "2") and "2" or "1"
	elseif k == "autoGrabBarStyle" then
	_G["_SoundHub_UI_AutoGrabBarStyle"] = "4"
	elseif k == "purpleTitle" then
	_G["_SoundHub_UI_PurpleTitle"] = (v == "New") and "New" or "Default"
	elseif k == "titleAzure" then
	_G["_SoundHub_UI_TitleVariant_azure"] = (v == "V2") and "V2" or "V1"
	elseif k == "titleGreen" then
	_G["_SoundHub_UI_TitleVariant_green"] = (v == "V2") and "V2" or "V1"
	elseif k == "titleHalloween" then
	_G["_SoundHub_UI_TitleVariant_halloween"] = (v == "V2") and "V2" or "V1"
	elseif k == "autoStealUi" then
	-- old saved value ignored: everyone starts on V1 once, choice saved under autoStealUiV1 from now on
	elseif k == "autoStealUiV1" then
	_G["_SoundHub_UI_AutoGrabSkin"] = (v == "V1") and "V1" or "V2"
	elseif k == "autoGrabBarScale" then
	_G["_SoundHub_UI_AutoGrabBarScale"] = math.clamp(tonumber(v) or 1, 0.6, 1.6)
	elseif k == "panelVisible" then
	_G.__CrystalPanelVisible = (v == "true")
	toggleStates["Toggle UI"] = _G.__CrystalPanelVisible
	elseif k == "tabPosition" then
	-- Tabs position is permanently fixed to Top; ignore legacy saved values.
	_G.__CrystalTabPosition = "Top"
	elseif k == "themePrimary" then
	_G.__CrystalThemePrimary = "BLACK"
	elseif k == "themeSecondary" then
	_G.__CrystalThemeSecondary = "BLUE"
	elseif k == "buttonsSize" then
	local size = tonumber(v)
	if size and size == size and math.abs(size) < math.huge then
	_G.__CrystalButtonsSize = math.clamp(size, 0.5, 2)
	end
	elseif k == "guiScale" then
	local size = tonumber(v)
	if size and size == size and math.abs(size) < math.huge then
	_G.__CrystalGuiScale = math.clamp(size, 0.50, 1.50)
	end
	elseif k == "buttonsShape" then
	_G.__CrystalButtonsShape = (v == "Rectangle" or v == "Rectangular") and "Rectangle" or "Circle"
	elseif k == "violetteSkinMode" then
	violetteSkinMode = (VIOLETTE_SKIN_SETS[v]) and v or "1"
	elseif k == "batAimbotMode" then
	_G._AdaptBatMode = (v == "BYPASS") and "BYPASS" or "NORMAL"
	batAimbotMode = _G._AdaptBatMode
	elseif k == "batAimbotVersion" then
	_G._AdaptBatVersion = math.clamp(math.floor(tonumber(v) or 1), 1, 3)
	if _G._AdaptBatMode ~= "NORMAL" then _G._AdaptBatVersion = 1 end
	elseif k == "batSkinMode" then
		local validBatSkinModes = { ["Default"] = true, ["Abyss Blue"] = true, ["Venom Green"] = true, ["Royal Gold"] = true, ["Velvet Rose"] = true, ["Crimson Night"] = true, ["RGB"] = true }
		batSkinMode = validBatSkinModes[v] and v or "Default"
		elseif k == "batVersion" then
	_G.__batVersion = math.clamp(math.floor(tonumber(v) or 1), 1, 2)
	elseif k == "tpBatV2Distance" then
	_G.__tpBatV2Distance = 3
	elseif k == "animationPreset" then
	_G.__CrystalAnimationPreset = v
	local name = tostring(v or "")
	local lower = string.lower(name)
	local cleanPacks = { Off=1, Zombie=2, Ninja=3, Knight=4, Elder=5, Levitate=6, Astronaut=7, Pirate=8, Toy=9, Vampire=10, Werewolf=11, Rthro=12, Stylish=13 }
	if lower == "none" or lower == "off" then
		_G.__CrystalAnimationPackIndex = 1
		_G.__CrystalAnimationPackPreset = "Off"
	elseif cleanPacks[name] then
		_G.__CrystalAnimationPackIndex = cleanPacks[name]
		_G.__CrystalAnimationPackPreset = name
	end
	-- else keep existing pack index (do not force 1)
	elseif k == "animationPackIndex" then
	_G.__CrystalAnimationPackIndex = math.clamp(math.floor(tonumber(v) or 1), 1, 13)
	elseif string.match(k or "", "^animationCustom_") then
	local animationSlot = string.match(k, "^animationCustom_(%a+)$")
	if animationSlot == "idle" or animationSlot == "walk" or animationSlot == "run" or animationSlot == "jump" or animationSlot == "fall" then
		local animationIds = type(_G.__CrystalCustomAnimationIds) == "table" and _G.__CrystalCustomAnimationIds or {}
		animationIds[animationSlot] = tostring(v):match("(%d+)") or ""
		_G.__CrystalCustomAnimationIds = animationIds
	end
	elseif k == "customFont" then
	_G.CrystalFontChoice = tostring(v or "Default")
	elseif k == "guiTheme" then
	_G.__CrystalGuiTheme = "GUI 1"
	end
	elseif prefix == "A:" and autoStealValues[k] ~= nil then
	local num = tonumber(v)
	if num then autoStealValues[k] = num end
	elseif prefix == "C:" then
	local boostStr, stealStr = v:match("([^,]+),([^,]+)")
	if boostStr and stealStr then
	table.insert(customSpeeds, { name = k, boost = tonumber(boostStr) or 59, steal = tonumber(stealStr) or 29 })
	end
	elseif prefix == "K:" then
	if mouseButtonDisplay[v] then
	FeatureKeybinds[k] = v
	else
	local okKey, key = pcall(function() return Enum.KeyCode[v] end)
	if okKey then FeatureKeybinds[k] = key end
	end
	elseif prefix == "P:" then
	if k == "menuPos" then
	local mx, my = v:match("(-?%d+),(-?%d+)")
	if mx and my then _G["_SoundHub_UI_MenuPos"] = { x = tonumber(mx), y = tonumber(my) } end
	elseif k == "toggleBtn" then
	local bx, by = v:match("(-?%d+),(-?%d+)")
	if bx and by then _G["_SoundHub_UI_BtnPos"] = { x = tonumber(bx), y = tonumber(by) } end
	elseif k == "speedFrame" then
	local sx, sy = v:match("(-?%d+),(-?%d+)")
	if sx and sy then _G["_SoundHub_UI_SpeedFramePos"] = { x = tonumber(sx), y = tonumber(sy) } end
	elseif k == "enemyWidget" then
	local ex, ey = v:match("(-?%d+),(-?%d+)")
	if ex and ey then _G["_SoundHub_UI_EnemyWidgetPos"] = { x = tonumber(ex), y = tonumber(ey) } end
	elseif k == "autoGrabBar" then
	local ax, ay = v:match("(-?%d+),(-?%d+)")
	if ax and ay then _G["_SoundHub_UI_AutoGrabBarPos"] = { x = tonumber(ax), y = tonumber(ay) } end
	elseif k == "autoGrabBarSize" then
	local num = tonumber(v)
	if num then _G["_SoundHub_UI_AutoGrabBarSize"] = num end
	elseif k == "modernMini" then
	local mx, my = v:match("(-?%d+),(-?%d+)")
	if mx and my then _G["_SoundHub_UI_ModernMiniPos"] = { x = tonumber(mx), y = tonumber(my) } end
	else
	local quickName = k:match("^quickBtn_(.+)$")
	if quickName then
	local qx, qy = v:match("^(-?%d+),(-?%d+)")
	if qx and qy then quickButtonPositions[quickName] = { x = tonumber(qx), y = tonumber(qy) } end
	else
	local mobileName = k:match("^mobileBtn_(.+)$")
	if mobileName then
	local bx, by = v:match("^(-?%d+),(-?%d+)")
	if bx and by then
	_G["_SoundHub_UI_MobileBtnPos"] = _G["_SoundHub_UI_MobileBtnPos"] or {}
	local pos = { x = tonumber(bx), y = tonumber(by) }
	local sx, sy = v:match(":(-?%d+):(-?%d+)$")
	if sx and sy then pos.xs = tonumber(sx); pos.ys = tonumber(sy) end
	_G["_SoundHub_UI_MobileBtnPos"][mobileName] = pos
	end
	end
	end
	end
	end
	end
	end
	end
	loadConfig()
	-- Potato Graphics stays off (heavy). Anti Lag is a light version and is allowed.
	toggleStates["Potato Graphics"] = false
	selectedIntroMusicIndex = math.clamp(tonumber(selectedIntroMusicIndex) or 1, 1, 9)
	_G.__SoundIntroMusicIndex = selectedIntroMusicIndex
	speedValues.InfJumpPower = 55
	-- Undo the previous blanket 55 defaults if they were written to the local config.
	if speedValues.NormalBoost == 55 and speedValues.NormalSteal == 55
	and speedValues.LaggerBoost == 55 and speedValues.LaggerSteal == 55 then
		speedValues.NormalBoost, speedValues.NormalSteal = 59, 29
		speedValues.LaggerBoost, speedValues.LaggerSteal = 40, 20
		normalSpeed, carrySpeed, laggerSpeed = 59, 29, 40
	end
	_G._RaVeSpeedMethod = "V1"
	carrySpeedMode = "v1"
	_G.__batVersion = math.clamp(math.floor(tonumber(_G.__batVersion) or 1), 1, 2)
	_G.__tpBatV2Distance = 3
	_G["_SoundHub_UI_MenuUi"] = (tostring(_G["_SoundHub_UI_MenuUi"] or "1") == "2") and "2" or "1"
	_G["_SoundHub_UI_AutoGrabBarStyle"] = "4"
	-- Bat Aimbot mode is no longer forced: the saved/selected mode (NORMAL or BYPASS) is kept
	batAimbotMode = (_G._AdaptBatMode == "NORMAL") and "NORMAL" or "BYPASS"
	_G._AdaptBatMode = batAimbotMode
	speedValues.CypherAimbotApproachSpeed = 57
	_G._AdaptBatVersion = (batAimbotMode == "NORMAL") and math.clamp(math.floor(tonumber(_G._AdaptBatVersion) or 1), 1, 3) or 1
	refreshVioletteSkinCatalog()
	if type(_G.__CrystalPanelVisible) == "boolean" then
	toggleStates["Toggle UI"] = _G.__CrystalPanelVisible
	else
	_G.__CrystalPanelVisible = toggleStates["Toggle UI"] ~= false
	toggleStates["Toggle UI"] = _G.__CrystalPanelVisible
	end
	autoStealMode = "v1"
	_G._RaVeSpeedMethod = "V1"
	carrySpeedMode = "v2"
	_G.__batVersion = math.clamp(math.floor(tonumber(_G.__batVersion) or 1), 1, 2)
	_G.__tpBatV2Distance = 3
	laggerEnabled = (selectedMode == "Lagger")
	speedToggled = toggleStates["Carry Speed"]
	if selectedMode == "Normal" and normalCarryManualOverride then
		speedToggled = normalCarrySelected
	elseif selectedMode == "Lagger" and laggerCarryManualOverride then
		speedToggled = laggerCarrySelected
	end
	toggleStates["Carry Speed"] = speedToggled
	toggleStates["TP Bat"] = false
	-- The steal bar is a HUD element: always show it when the hub starts.
	-- It can still be hidden manually from the Combat tab.
	toggleStates["Steal Bar"] = true
	toggleStates["Korblox"] = false
	pcall(function()
	local character = Player.Character
	if not character then return end
	for _, child in ipairs(character:GetChildren()) do
	if child.Name == "Korblox_RightLeg" then
	child:Destroy()
	end
	end
	for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
	local limb = character:FindFirstChild(partName)
	if limb and limb:IsA("BasePart") then
	limb.Transparency = 0
	limb.CanCollide = true
	end
	end
	end)
	toggleStates["Autoplay"] = false
	toggleStates["Lagger"] = false
	-- Persist panel visibility across restarts (outer panel code reads these)
	_G.__CrystalAimbotActive = toggleStates["Aimbot"] == true
	_G.__CrystalTPBatActive = toggleStates["TP Bat"] == true

	mobileButtonPositions = _G["_SoundHub_UI_MobileBtnPos"] or {}

	_G.__CrystalModernGuiActive = true
	local coreGui = game:GetService("CoreGui")
	local existing = Player.PlayerGui:FindFirstChild("Sound_Panel") or coreGui:FindFirstChild("Sound_Panel")
	if existing then existing:Destroy() end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "EclipseHub"

	ScreenGui.Enabled = false
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.DisplayOrder = 9999999
	ScreenGui.IgnoreGuiInset = true
	pcall(function() ScreenGui.Parent = coreGui end)
	if not ScreenGui.Parent then ScreenGui.Parent = Player.PlayerGui end

	local vp = workspace.CurrentCamera.ViewportSize
	GUI_METRICS = {
	sectionPad = isMobile and 4 or 6, sectionGap = isMobile and 4 or 6,
	sectionHeaderH = isMobile and 16 or 20, toggleH = isMobile and 44 or 62,
	compactRowH = isMobile and 30 or 36, compactCardH = isMobile and 28 or 32,
	toggleTextSize = isMobile and 9 or 10, bindW = isMobile and 34 or 40,
	bindH = isMobile and 16 or 20, bindTextSize = isMobile and 8 or 9,
	}
	local PANEL_W = isMobile and math.clamp(math.floor(vp.X * 0.42), 165, 205) or math.min(340, math.floor(vp.X * 0.52))
	local PANEL_H = isMobile and math.clamp(math.floor(vp.Y * 0.55), 200, 330) or math.min(560, math.floor(vp.Y * 0.84))

	local Panel = Instance.new("Frame")
	Panel.Name = "Panel"
	Panel.Active = true
	Panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
	-- Start the main GUI on the LEFT side instead of the right.
	-- Clear any previously saved right-side position so the change takes effect.
	_G["_SoundHub_UI_MenuPos"] = nil
	local savedMenuPos = nil
	if savedMenuPos then
	local mx, my = placeInsideViewport(Panel, 0, savedMenuPos.x, 0, savedMenuPos.y)
	Panel.Position = UDim2.new(0, mx, 0, my)
	else
	Panel.Position = UDim2.new(0, 20, 0.5, -PANEL_H / 2)
	end
	Panel.BackgroundTransparency = 1
	Panel.BorderSizePixel = 0
	Panel.Visible = false
	Panel.Parent = ScreenGui

	local SidebarHeader = Instance.new("Frame")
	SidebarHeader.Name = "LegacyHeaderStub"
	SidebarHeader.BackgroundTransparency = 1
	SidebarHeader.Visible = false
	SidebarHeader.Parent = Panel
	FPSLabel = Instance.new("TextLabel")
	FPSLabel.BackgroundTransparency = 1
	FPSLabel.Visible = false
	FPSLabel.Parent = SidebarHeader
	PingLabel = Instance.new("TextLabel")
	PingLabel.BackgroundTransparency = 1
	PingLabel.Visible = false
	PingLabel.Parent = SidebarHeader

	local ContentArea = Instance.new("Frame")
	ContentArea.Name = "LegacyContentStub"
	ContentArea.BackgroundTransparency = 1
	ContentArea.Visible = false
	ContentArea.Parent = Panel

	local AZZURRO_BACKGROUND = "rbxassetid://100534832091396"
	local AZZURRO_BACKGROUND_2 = "rbxassetid://98695754338509"
	local halloweenBackgroundIds = {
		"",
		"",
		"",
		"",
		""
	}
	local halloweenBgIndex = math.clamp(tonumber(_G["_SoundHub_UI_HalloweenBgIndex"]) or 1, 1, #halloweenBackgroundIds)
	_G["_SoundHub_UI_HalloweenBgIndex"] = halloweenBgIndex
	local function getHalloweenBackground()
		local idx = math.clamp(tonumber(_G["_SoundHub_UI_HalloweenBgIndex"]) or halloweenBgIndex or 1, 1, #halloweenBackgroundIds)
		halloweenBgIndex = idx
		return halloweenBackgroundIds[idx] or halloweenBackgroundIds[1]
	end
	local HALLOWEEN_BACKGROUND = getHalloweenBackground()
	local AZURE_BACKGROUND_IDS = {
		"",
		"",
		"",
		"",
		"",
		""
	}
	local PURPLE_BACKGROUND_IDS = {
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	}
	local GREEN_BACKGROUND_IDS = {
		"",
		"",
		"",
		"",
		""
	}
	local backgroundIds = {}
	local function loadBackgroundSet()
		local ct = "purple"
		local list = AZURE_BACKGROUND_IDS
		if ct == "purple" then list = PURPLE_BACKGROUND_IDS
		elseif ct == "green" then list = GREEN_BACKGROUND_IDS
		end
		for i = #backgroundIds, 1, -1 do backgroundIds[i] = nil end
		for i, id in ipairs(list) do backgroundIds[i] = id end
	end
	-- Fixed theme: purple only; theme selection UI removed.
	_G["_SoundHub_UI_ColorTheme"] = "purple"
	loadBackgroundSet()
	_G.__SoundLoadBackgroundSet = function()
		loadBackgroundSet()
		pcall(function()
			if type(_G.__refreshSpeedBillboards) == "function" then _G.__refreshSpeedBillboards() end
			if type(_G.__CrystalRefreshHalloweenOverhead) == "function" then _G.__CrystalRefreshHalloweenOverhead() end
		end)
	end
	_G.__SoundGetMenuBackgroundImage = function()
		pcall(function()
			if type(_G.__SoundLoadBackgroundSet) == "function" then _G.__SoundLoadBackgroundSet() end
		end)
		if _G.__CrystalHalloweenMode == true or (toggleStates and toggleStates["Halloween Mode"] == true) then
			local okH, hImg = pcall(getHalloweenBackground)
			if okH and type(hImg) == "string" and hImg ~= "" then return hImg end
			local list = type(halloweenBackgroundIds) == "table" and halloweenBackgroundIds or nil
			local hi = math.clamp(tonumber(_G["_SoundHub_UI_HalloweenBgIndex"]) or 1, 1, list and math.max(1, #list) or 1)
			if list and list[hi] then return list[hi] end
		end
		local bi = math.clamp(tonumber(_G["_SoundHub_UI_BgIndex"]) or 1, 1, math.max(1, #backgroundIds))
		if backgroundIds[bi] then return backgroundIds[bi] end
		if BgImage and BgImage.Image and BgImage.Image ~= "" then return BgImage.Image end
		return ""
	end
	-- Purple defaults to image 4; other color themes retain their previous image-2 default.
	_G["_SoundHub_UI_BgPicked"] = true
	local defaultBgIdx = (#backgroundIds >= 2) and 2 or 1
	if _G["_SoundHub_UI_ColorTheme"] == "purple" or _G["_SoundHub_UI_ColorTheme"] == "azure" then defaultBgIdx = 1 end
	local bgIndex = math.clamp(tonumber(_G["_SoundHub_UI_BgIndex"]) or defaultBgIdx, 1, math.max(1, #backgroundIds))
	if not _G["_SoundHub_UI_BgIndex"] or _G["_SoundHub_UI_BgIndex"] < 1 then
		bgIndex = defaultBgIdx
	end
	-- On first run, use the theme-specific default.
	if not _G["_SoundHub_UI_BgUserPicked"] then
		bgIndex = defaultBgIdx
	end
	_G["_SoundHub_UI_BgIndex"] = bgIndex
	_G.__CrystalSoundIntroImage = AZZURRO_BACKGROUND
	local BgImage = Instance.new("ImageLabel")
	BgImage.Name = "LegacyBackgroundStub"
	BgImage.BackgroundTransparency = 1
	BgImage.Image = backgroundIds[bgIndex]
	BgImage.Visible = false
	BgImage.Parent = Panel
	local HeaderBgBtn = Instance.new("TextButton")
	HeaderBgBtn.Name = "LegacyBackgroundButtonStub"
	HeaderBgBtn.Visible = false
	HeaderBgBtn.Parent = Panel

	-- ==================== GRAPHICS COORDINATION (FPS FIX) ====================
	-- 1) _G.__CrystalPreserveOptimizerUI was called by FPS Boost / Optimizer
	--    but never defined anywhere, so every call errored inside a pcall:
	--    both features walked the whole workspace doing nothing but costing
	--    FPS. It is defined once here, and it is CHEAP (no ancestor walks for
	--    ordinary parts): hub UI is in CoreGui/PlayerGui, which the world
	--    derenders never scan; only billboard/surface children and a few
	--    named hub parts inside workspace need preserving.
	if type(_G.__CrystalPreserveOptimizerUI) ~= "function" then
	_G.__CrystalPreserveOptimizerUI = function(obj)
	if not obj then return true end
	if obj:IsA("GuiObject") or obj:IsA("LayerCollector") or obj:IsA("GuiBase2d") then return true end
	local n = obj.Name
	if n == "PredictionSphere" or n == "GreenDuelsBB" or n == "Headless_Headless" or n:sub(1, 8) == "Korblox_" then return true end
	local p = obj.Parent
	if p and (p:IsA("BillboardGui") or p:IsA("SurfaceGui") or p:IsA("LayerCollector")) then return true end
	return false
	end
	end
	-- 2) The graphics modes used to STACK: Anti Lag + Potato Graphics + FPS
	--    Boost (+ Optimizer / Vivid) each ran their own full workspace walk
	--    and their own permanent DescendantAdded handler, rewriting and even
	--    Destroy()-ing the same instances 3-4x. That is why turning "FPS"
	--    features ON dropped FPS. They are now mutually exclusive: enabling
	--    one cleanly disables the others (toggle state + UI included).
	_G.__CrystalDerenderOwner = nil
	_G.__CrystalReleaseGraphics = function(name)
	if _G.__CrystalDerenderOwner == name then _G.__CrystalDerenderOwner = nil end
	end
	_G.__CrystalExclusiveGraphics = function(name)
	_G.__CrystalDerenderOwner = name
	local conflicts
	if name == "Vivid Graphics" or name == "FPS Boost" then
	conflicts = {"Anti Lag", "Potato Graphics", "Optimizer"}
	else
	conflicts = {"FPS Boost", "Anti Lag", "Potato Graphics", "Optimizer", "Vivid Graphics"}
	end
	for _, other in ipairs(conflicts) do
	if other ~= name and toggleStates[other] then
	toggleStates[other] = false
	local post = FeaturePostToggle[other]
	if post then pcall(post, false) end
	local updater = toggleVisualUpdaters[other]
	if updater then pcall(updater) end
	end
	end
	end
	do
	local fpsBoostDescConn = nil
	local fpsBoostCharConn = nil
	local fpsBoostActive = false
	local fpsBoostWalkCancel = nil
	local fpsBoostCharWalkCancel = nil
	-- FPS FIX (FPS Boost): the old applyFPSDerender errored on its first line
	-- (it called _G.__CrystalPreserveOptimizerUI, which was never defined),
	-- so enabling FPS Boost walked the ENTIRE workspace + kept a permanent
	-- DescendantAdded handler and did literally nothing except burn FPS.
	-- It also ran two ancestor walks (one with pattern :find) plus a Lighting
	-- IsDescendantOf inside a pcall for every instance, folders and all.
	-- Now: class gate first, no Lighting check (this only scans workspace),
	-- compare-before-write, weak done-set, protected names checked 1 level up.
	local fpsBoostProcessed = setmetatable({}, { __mode = "k" })

	local function applyFPSDerender(obj)
	if not fpsBoostActive or not obj then return end
	if fpsBoostProcessed[obj] then return end
	if obj:IsA("BasePart") then
	local parent = obj.Parent
	if obj.Name == "Headless_Headless" or obj.Name == "PredictionSphere" or obj.Name:sub(1, 8) == "Korblox_"
	or (parent and (parent.Name == "Headless_Headless" or parent.Name:sub(1, 8) == "Korblox_")) then
	fpsBoostProcessed[obj] = true
	return
	end
	fpsBoostProcessed[obj] = true
	if obj.Material ~= Enum.Material.Plastic then obj.Material = Enum.Material.Plastic end
	if obj.Reflectance ~= 0 then obj.Reflectance = 0 end
	if obj.CastShadow then obj.CastShadow = false end
	elseif obj:IsA("Decal") or obj:IsA("Texture") then
	fpsBoostProcessed[obj] = true
	if obj.Transparency ~= 1 then obj.Transparency = 1 end
	elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
	fpsBoostProcessed[obj] = true
	if obj.Enabled then obj.Enabled = false end
	elseif obj:IsA("Accessory") or obj:IsA("Hat") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("BodyColors") or obj:IsA("CharacterMesh") then
	if obj.Name == "Headless_Headless" or obj.Name:sub(1, 8) == "Korblox_" then
	fpsBoostProcessed[obj] = true
	return
	end
	fpsBoostProcessed[obj] = true
	obj:Destroy()
	elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
	fpsBoostProcessed[obj] = true
	local ancestor = obj.Parent
	while ancestor and ancestor ~= workspace do
	if ancestor:IsA("Model") and Players:GetPlayerFromCharacter(ancestor) then return end
	ancestor = ancestor.Parent
	end
	for _, t in ipairs(obj:GetPlayingAnimationTracks()) do
	pcall(function() t:Stop(0) end)
	end
	end
	end

	local function processAllDescendants()
	if fpsBoostWalkCancel then fpsBoostWalkCancel() end
	fpsBoostWalkCancel = _G.__CrystalWalkDescendantsBatched(workspace, applyFPSDerender, function()
	return fpsBoostActive
	end)
	end

	local function startFPSBoost()
	if fpsBoostActive then return end
	if _G.__CrystalExclusiveGraphics then _G.__CrystalExclusiveGraphics("FPS Boost") end
	fpsBoostActive = true
	fpsBoostProcessed = setmetatable({}, { __mode = "k" })

	if fpsBoostDescConn then fpsBoostDescConn:Disconnect() end
	fpsBoostDescConn = workspace.DescendantAdded:Connect(function(obj)
	if fpsBoostActive then pcall(applyFPSDerender, obj) end
	end)
	processAllDescendants()

	if fpsBoostCharConn then fpsBoostCharConn:Disconnect() end
	fpsBoostCharConn = Player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	if fpsBoostActive then
	if fpsBoostCharWalkCancel then fpsBoostCharWalkCancel() end
	fpsBoostCharWalkCancel = _G.__CrystalWalkDescendantsBatched(char, applyFPSDerender, function() return fpsBoostActive end)
	end
	end)
	end

	local function stopFPSBoost()
	if not fpsBoostActive then return end
	fpsBoostActive = false
	if _G.__CrystalReleaseGraphics then _G.__CrystalReleaseGraphics("FPS Boost") end
	if fpsBoostWalkCancel then fpsBoostWalkCancel(); fpsBoostWalkCancel = nil end
	if fpsBoostCharWalkCancel then fpsBoostCharWalkCancel(); fpsBoostCharWalkCancel = nil end

	if fpsBoostDescConn then
	fpsBoostDescConn:Disconnect()
	fpsBoostDescConn = nil
	end
	if fpsBoostCharConn then
	fpsBoostCharConn:Disconnect()
	fpsBoostCharConn = nil
	end
	fpsBoostProcessed = setmetatable({}, { __mode = "k" })
	end

	_G.__refreshFPSBoost = startFPSBoost
	_G.__stopFPSBoost = stopFPSBoost

	FeaturePostToggle["FPS Boost"] = function(active)
	if active then startFPSBoost() else stopFPSBoost() end
	end

	end

	;(function()
	local active, generation = false, 0
	local connections = {}
	local saved = setmetatable({}, { __mode = "k" })
	local detached = {}
	local animators = setmetatable({}, { __mode = "k" })
	local stoppedTracks = setmetatable({}, { __mode = "k" })
	local scanCancel = nil
	-- FPS FIX (Anti Lag): the old version dropped FPS instead of raising it:
	--  * DescendantAdded did task.defer() PER spawned instance (a new thread
	--    allocation for every part/effect the game created).
	--  * isProtectedVisual ran TWO full ancestor walks per object with
	--    pattern :match() calls on every ancestor name.
	--  * change() wrapped every single property write in a pcall (7+ pcalls
	--    per MeshPart, over the whole map).
	--  * stop() restored every saved property of the whole map in ONE
	--    synchronous loop = guaranteed freeze on toggle-off.
	-- Now: one merged cheap walk, no inner pcalls (callers are protected),
	-- a bounded heartbeat queue for spawns, a weak done-set, chunked restore.
	local appliedOnce = setmetatable({}, { __mode = "k" })
	local SKY_FACES = {"SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp", "SunTextureId", "MoonTextureId"}
	local pending = {}
	local pendingHead = 1
	local drainConn = nil

	local function change(object, property, value)
	local original = object[property]
	if original == value then return end
	object[property] = value
	local properties = saved[object]
	if not properties then properties = {}; saved[object] = properties end
	if not properties[property] then properties[property] = { value = original } end
	end

	local function isProtectedVisual(object)
	local char = Player.Character
	if char and (object == char or object:IsDescendantOf(char)) then return true end

	-- Sound Skin assets (especially the hat) must keep their textures and visibility
	-- when Anti Lag strips textures/materials from the rest of the world.
	-- Single walk, plain prefix compares (no pattern matching).
	local parent = object
	while parent and parent ~= workspace do
	if parent:GetAttribute("_SoundSkin") == true then return true end
	if parent:IsA("LayerCollector") or parent:IsA("GuiObject")
	or parent:IsA("GuiBase2d") then return true end
	local name = parent.Name or ""
	if name:sub(1, 7) == "Crystal" or name:sub(1, 9) == "__Crystal" or name:sub(1, 7) == "Eclipse"
	or name:sub(1, 4) == "ESP_" or name:sub(1, 8) == "Korblox_"
	or name == "Headless_Headless" or name == "GreenDuelsBB"
	or name == "PredictionSphere" then return true end
	parent = parent.Parent
	end
	if toggleStates["Sky Changer"] and (object == Lighting or object:IsDescendantOf(Lighting)) then return true end
	return false
	end

	local function stopAnimations(animator)
	if animators[animator] then return end

	local char = Player.Character
	if char and animator:IsDescendantOf(char) then return end
	animators[animator] = true
	local token = generation
	local ok, connection = pcall(function()
	return animator.AnimationPlayed:Connect(function(track)
	if not active or generation ~= token then return end

	task.defer(function()
	if active and generation == token then pcall(function() track:Stop(0) end) end
	end)
	end)
	end)
	if ok then table.insert(connections, connection) end
	pcall(function()
	for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
	if track.IsPlaying then
	stoppedTracks[track] = { animator = animator, time = track.TimePosition, speed = track.Speed }
	track:Stop(0)
	end
	end
	end)
	end

	local function apply(object)
	if not active or appliedOnce[object] then return end
	if isProtectedVisual(object) then return end
	appliedOnce[object] = true
	if object:IsA("Terrain") then
	change(object, "Decoration", false)
	change(object, "WaterWaveSize", 0)
	change(object, "WaterWaveSpeed", 0)
	change(object, "WaterReflectance", 0)
	change(object, "WaterTransparency", 1)
	end
	if object:IsA("BasePart") then
	change(object, "Material", Enum.Material.Plastic)
	change(object, "MaterialVariant", "")
	change(object, "Reflectance", 0)
	change(object, "CastShadow", false)
	if object:IsA("MeshPart") then
	change(object, "TextureID", "")
	change(object, "RenderFidelity", Enum.RenderFidelity.Performance)
	change(object, "DoubleSided", false)
	elseif object:IsA("PartOperation") then
	change(object, "RenderFidelity", Enum.RenderFidelity.Performance)
	end
	elseif object:IsA("SpecialMesh") then
	change(object, "TextureId", "")
	elseif object:IsA("SurfaceAppearance") then
	detached[object] = true
	change(object, "Parent", nil)
	elseif object:IsA("Decal") or object:IsA("Texture") then
	change(object, "Transparency", 1)
	change(object, "Texture", "")
	elseif object:IsA("ParticleEmitter") then
	change(object, "Enabled", false)
	change(object, "Rate", 0)
	pcall(function() object:Clear() end)
	elseif object:IsA("Trail") then
	change(object, "Enabled", false)
	pcall(function() object:Clear() end)
	elseif object:IsA("Beam") or object:IsA("Fire") or object:IsA("Smoke")
	or object:IsA("Sparkles") or object:IsA("Light") or object:IsA("PostEffect")
	or object:IsA("Clouds") then
	change(object, "Enabled", false)
	elseif object:IsA("Atmosphere") then
	change(object, "Density", 0)
	change(object, "Haze", 0)
	change(object, "Glare", 0)
	elseif object:IsA("Sky") then
	for _, face in ipairs(SKY_FACES) do
	change(object, face, "")
	end
	change(object, "StarCount", 0)
	change(object, "CelestialBodiesShown", false)
	elseif object:IsA("Shirt") then
	change(object, "ShirtTemplate", "")
	elseif object:IsA("Pants") then
	change(object, "PantsTemplate", "")
	elseif object:IsA("ShirtGraphic") then
	change(object, "Graphic", "")
	elseif object:IsA("Animator") then
	stopAnimations(object)
	end
	end

	local function applyLighting()
	if toggleStates["Sky Changer"] then return end
	change(Lighting, "GlobalShadows", false)
	change(Lighting, "EnvironmentDiffuseScale", 0)
	change(Lighting, "EnvironmentSpecularScale", 0)
	change(Lighting, "FogStart", 0)
	change(Lighting, "FogEnd", 1e10)
	end

	local function stopDrain()
	if drainConn then pcall(function() drainConn:Disconnect() end); drainConn = nil end
	pending = {}
	pendingHead = 1
	end

	local function ensureDrain()
	if drainConn then return end
	local token = generation
	drainConn = RunService.Heartbeat:Connect(function()
	if not active or generation ~= token then stopDrain(); return end
	local deadline = os.clock() + 0.0007
	local processed = 0
	while pendingHead <= #pending and processed < 120 and os.clock() < deadline do
	local object = pending[pendingHead]
	pending[pendingHead] = nil
	pendingHead = pendingHead + 1
	processed = processed + 1
	if object then pcall(apply, object) end
	end
	if pendingHead > #pending then
	pending = {}
	pendingHead = 1
	local conn = drainConn
	drainConn = nil
	if conn then pcall(function() conn:Disconnect() end) end
	end
	end)
	end

	local function queueApply(object)
	if not active then return end
	pending[#pending + 1] = object
	ensureDrain()
	end

	local function stop()
	if not active then return end
	active = false
	generation = generation + 1
	if _G.__CrystalReleaseGraphics then _G.__CrystalReleaseGraphics("Anti Lag") end
	if scanCancel then scanCancel(); scanCancel = nil end
	stopDrain()
	for _, connection in ipairs(connections) do pcall(function() connection:Disconnect() end) end
	connections = {}

	for track, state in pairs(stoppedTracks) do
	pcall(function()
	if state.animator.Parent and not track.IsPlaying then
	track:Play(0, 1, state.speed)
	track.TimePosition = state.time
	end
	end)
	end
	stoppedTracks = setmetatable({}, { __mode = "k" })

	-- Chunked restore (snapshot first: the weak table is reset right away).
	local snapshot = {}
	for object, properties in pairs(saved) do
	snapshot[#snapshot + 1] = {object, properties}
	end
	saved = setmetatable({}, { __mode = "k" })
	detached = {}
	animators = setmetatable({}, { __mode = "k" })
	appliedOnce = setmetatable({}, { __mode = "k" })
	local restoreToken = generation
	if #snapshot > 0 then
	task.spawn(function()
	for i, entry in ipairs(snapshot) do
	if generation ~= restoreToken then return end
	local owner = _G.__CrystalDerenderOwner
	if owner and owner ~= "Anti Lag" and owner ~= "Vivid Graphics" then return end
	for property, original in pairs(entry[2]) do
	pcall(function() entry[1][property] = original.value end)
	end
	if i % 150 == 0 then task.wait() end
	end
	end)
	end
	end

	FeaturePostToggle["Anti Lag"] = function(enabled)
	if not enabled then stop(); return end
	if active then return end
	if _G.__CrystalExclusiveGraphics then _G.__CrystalExclusiveGraphics("Anti Lag") end
	active = true
	generation = generation + 1
	local token = generation
	applyLighting()
	pcall(function() change(settings().Rendering, "QualityLevel", Enum.QualityLevel.Level01) end)
	pcall(function()
	change(UserSettings():GetService("UserGameSettings"), "SavedQualityLevel", Enum.SavedQualitySetting.QualityLevel1)
	end)
	for _, root in ipairs({ workspace, Lighting }) do
	table.insert(connections, root.DescendantAdded:Connect(function(object)
	queueApply(object)
	end))
	end
	table.insert(connections, Lighting.Changed:Connect(function(property)
	if active and (property == "GlobalShadows" or property == "EnvironmentDiffuseScale"
	or property == "EnvironmentSpecularScale" or property == "FogStart" or property == "FogEnd") then
	applyLighting()
	end
	end))
	if scanCancel then scanCancel() end
	scanCancel = _G.__CrystalWalkDescendantsBatched({ workspace, Lighting }, apply, function()
	return active and generation == token
	end)
	end
	_G.__CrystalTrackStopper(stop)

	end)()

	-- ==================== POTATO GRAPHICS (from Adapt VisualStrip) ====================
	do
		local potatoOn = false
		local potatoConns = {}
		local potatoGen = 0
		local potatoWalkCancel = nil
		-- FPS FIX (Potato): the old stripObject was the single biggest FPS
		-- killer in the hub:
		--  * EVERY BasePart ran FindFirstChildWhichIsA("Light", true) -- a
		--    recursive descendant search per part = O(n^2) on a full map.
		--  * EVERY object ran a 12-deep ancestor walk doing :lower(), string
		--    finds and FindFirstChildOfClass per level, inside a pcall.
		--  * start did workspace:GetDescendants() (one giant table for the
		--    whole game) and DescendantAdded used task.defer per instance.
		--  * every Animator added a new AnimationPlayed connection with no
		--    dedupe, so connections piled up forever.
		-- Now: class gate first, cheap bounded checks only, compare-before-
		-- write, weak done-sets, streamed batched scan, direct DescendantAdded.
		local potatoProcessed = setmetatable({}, { __mode = "k" })
		local potatoAnimatorSeen = setmetatable({}, { __mode = "k" })

		local function isProtectedVisual(obj)
			if not obj then return true end
			-- Protect local character clothing while stealing so grab visuals stay intact
			local myChar = Player.Character
			if myChar and obj:IsDescendantOf(myChar) and Player:GetAttribute("Stealing") == true then
				return true
			end
			-- Protect brainrot / animal models + hub visuals. Cheap name checks
			-- only: no FindFirstChildOfClass, no per-level animator probing.
			local cur = obj
			for _ = 1, 12 do
				if not cur then break end
				local n = cur.Name or ""
				if string.lower(n) == "animals" then return true end
				if string.find(string.lower(n), "brainrot", 1, true) then return true end
				if string.find(n, "Crystal", 1, true) or string.find(n, "Sound", 1, true) or string.find(n, "Eclipse", 1, true) then
					return true
				end
				cur = cur.Parent
			end
			return false
		end

		local function stripObject(obj)
			if not potatoOn or not obj or potatoProcessed[obj] then return end
			if obj:IsA("BasePart") then
				potatoProcessed[obj] = true
				if not isProtectedVisual(obj) then
					if obj.Material ~= Enum.Material.SmoothPlastic then obj.Material = Enum.Material.SmoothPlastic end
					if obj.MaterialVariant ~= "" then obj.MaterialVariant = "" end
				end
				if obj.Reflectance ~= 0 then obj.Reflectance = 0 end
				if obj.CastShadow then obj.CastShadow = false end
				-- Lamp/light parts: name check only (Lights themselves are
				-- destroyed below). No recursive search per part anymore.
				local n = string.lower(obj.Name or "")
				if string.find(n, "light", 1, true) or string.find(n, "lamp", 1, true) then
					obj.LocalTransparencyModifier = 1
				end
				local p1 = obj.Parent
				local p2 = p1 and p1.Parent
				if (p1 and p1:IsA("Accessory")) or (p2 and p2:IsA("Accessory")) then
					obj.LocalTransparencyModifier = 1
				end
			elseif obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("BodyColors") then
				potatoProcessed[obj] = true
				obj:Destroy()
			elseif obj:IsA("FaceControls") then
				potatoProcessed[obj] = true
				obj:Destroy()
			elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("SurfaceAppearance") then
				potatoProcessed[obj] = true
				if not isProtectedVisual(obj) then obj:Destroy() end
			elseif obj:IsA("SpecialMesh") then
				potatoProcessed[obj] = true
				if not isProtectedVisual(obj) and obj.TextureId ~= "" then obj.TextureId = "" end
			elseif obj:IsA("Animator") then
				if potatoAnimatorSeen[obj] then return end
				potatoAnimatorSeen[obj] = true
				potatoProcessed[obj] = true
				local model = obj:FindFirstAncestorOfClass("Model")
				if not (model and Players:GetPlayerFromCharacter(model)) then
					for _, track in ipairs(obj:GetPlayingAnimationTracks()) do
						pcall(function() track:Stop(0); track:AdjustSpeed(0) end)
					end
					local token = potatoGen
					table.insert(potatoConns, obj.AnimationPlayed:Connect(function(track)
						if potatoOn and potatoGen == token then
							pcall(function() track:Stop(0); track:AdjustSpeed(0) end)
						end
					end))
				end
			elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
				or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Highlight") then
				potatoProcessed[obj] = true
				obj:Destroy()
			elseif obj:IsA("Light") then
				potatoProcessed[obj] = true
				local bp = obj.Parent
				if bp and bp:IsA("BasePart") then bp.LocalTransparencyModifier = 1 end
				obj:Destroy()
			elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
				potatoProcessed[obj] = true
				-- only strip world-related images, not hub UI
				if not obj:FindFirstAncestorOfClass("ScreenGui") and obj.Image ~= "" then
					obj.Image = ""
				end
			elseif obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("Clouds") or obj:IsA("PostEffect") then
				potatoProcessed[obj] = true
				obj:Destroy()
			end
		end

		local function applyPotatoLighting()
			pcall(function()
				Lighting.GlobalShadows = false
				Lighting.EnvironmentDiffuseScale = 0
				Lighting.EnvironmentSpecularScale = 0
				Lighting.FogStart = 1e9
				Lighting.FogEnd = 1e9
				local terrain = workspace:FindFirstChildOfClass("Terrain")
				if terrain then
					terrain.Decoration = false
					terrain.WaterWaveSize = 0
					terrain.WaterWaveSpeed = 0
					terrain.WaterReflectance = 0
					terrain.WaterTransparency = 1
				end
				for _, d in ipairs(Lighting:GetDescendants()) do
					pcall(stripObject, d)
				end
			end)
			pcall(function()
				settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
			end)
			pcall(function()
				settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
			end)
			pcall(function()
				UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
			end)
		end

		local function startPotatoGraphics()
			if potatoOn then return end
			if _G.__CrystalExclusiveGraphics then _G.__CrystalExclusiveGraphics("Potato Graphics") end
			potatoOn = true
			potatoGen = potatoGen + 1
			local token = potatoGen
			for _, c in ipairs(potatoConns) do pcall(function() c:Disconnect() end) end
			potatoConns = {}
			potatoProcessed = setmetatable({}, { __mode = "k" })
			potatoAnimatorSeen = setmetatable({}, { __mode = "k" })
			applyPotatoLighting()
			-- Streamed scan with a per-frame budget instead of one giant
			-- workspace:GetDescendants() table + task.wait() every 100.
			if potatoWalkCancel then potatoWalkCancel() end
			potatoWalkCancel = _G.__CrystalWalkDescendantsBatched({ workspace, Lighting }, stripObject, function()
				return potatoOn and potatoGen == token
			end)
			table.insert(potatoConns, workspace.DescendantAdded:Connect(function(d)
				if potatoOn then pcall(stripObject, d) end
			end))
			table.insert(potatoConns, Lighting.DescendantAdded:Connect(function(d)
				if potatoOn then pcall(stripObject, d) end
			end))
		end

		local function stopPotatoGraphics()
			potatoOn = false
			potatoGen = potatoGen + 1
			if _G.__CrystalReleaseGraphics then _G.__CrystalReleaseGraphics("Potato Graphics") end
			if potatoWalkCancel then potatoWalkCancel(); potatoWalkCancel = nil end
			for _, c in ipairs(potatoConns) do pcall(function() c:Disconnect() end) end
			potatoConns = {}
			potatoProcessed = setmetatable({}, { __mode = "k" })
			potatoAnimatorSeen = setmetatable({}, { __mode = "k" })
			-- Adapt does not restore stripped visuals (destructive). Connections only are cleared.
		end

		FeaturePostToggle["Potato Graphics"] = function(active)
			if active then startPotatoGraphics() else stopPotatoGraphics() end
		end
		_G.__CrystalTrackStopper(stopPotatoGraphics)
		_G.__CrystalStartPotatoGraphics = startPotatoGraphics
		_G.__CrystalStopPotatoGraphics = stopPotatoGraphics
	end

	do
	local currentFps, currentPing = 0, 0
	local fpsElapsed, fpsFrames = 0, 0
	local topFpsConn = nil

	local function safeGetPing()
	local ok, ping = pcall(function() return Player:GetNetworkPing() * 1000 end)
	if ok and type(ping) == "number" then return math.floor(ping) end
	return 0
	end

	local function updateTopLabel()
	if FPSLabel then FPSLabel.Text = tostring(currentFps) .. " FPS" end
	if PingLabel then PingLabel.Text = tostring(currentPing) .. " MS" end
	if StatsRightFps then StatsRightFps.Text = "FPS: " .. tostring(currentFps) end
	if StatsRightPing then StatsRightPing.Text = "PING: " .. tostring(currentPing) .. "ms" end
	end

	if topFpsConn then return end
	fpsElapsed = 0; fpsFrames = 0
	topFpsConn = _G.__CrystalTrackConn(RunService.RenderStepped:Connect((function(dt)
	fpsFrames = fpsFrames + 1; fpsElapsed = fpsElapsed + dt
	if fpsElapsed >= 1 then
	currentFps = math.floor((fpsFrames / fpsElapsed) + 0.5); fpsFrames = 0; fpsElapsed = 0
	currentPing = safeGetPing()
	updateTopLabel()
	end
	end)))

	end

	do
	local enemyWidget = nil
	local enemyWidgetDragging, enemyWidgetDragStart, enemyWidgetStartPos = false, nil, nil
	local enemyWidgetPos = _G["_SoundHub_UI_EnemyWidgetPos"] or { x = 140, y = -340 }
	_G.__CrystalGuiPositionResetters.EnemyWidget = function()
	enemyWidgetDragging = false
	enemyWidgetPos = { x = 140, y = -340 }
	_G["_SoundHub_UI_EnemyWidgetPos"] = nil
	if enemyWidget and enemyWidget.Parent then
	enemyWidget.Position = UDim2.fromOffset(enemyWidgetPos.x, enemyWidgetPos.y)
	end
	end
	local enemyRagdollCountdown = 0
	local trackedEnemy = nil
	local trackedEnemyId = nil
	local lastEnemyRagdollState = false
	local cachedTimerLbl = nil
	local cachedEnemyHum = nil
	local lastTimerText = ""
	local lastWidgetVisible = nil

	_G.__CrystalGetVisualEnemy = function()
	if trackedEnemy and trackedEnemy.Parent == Players then return trackedEnemy end
	return nil
	end

	local function createEnemyWidget()
	if enemyWidget and enemyWidget.Parent then return enemyWidget end

	enemyWidget = Instance.new("Frame", ScreenGui)
	enemyWidget.Name = "SoundEnemyWidget"
	enemyWidget.Size = UDim2.new(0, 140, 0, 80)
	enemyWidget.Position = UDim2.new(0, enemyWidgetPos.x, 0, enemyWidgetPos.y)
	_G.__enemyWidget = enemyWidget
	_G.__CrystalRegisterThemeRoot(enemyWidget)
	enemyWidget.BackgroundTransparency = 0.15
	enemyWidget.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	enemyWidget.ZIndex = 600
	enemyWidget.Visible = false
	Instance.new("UICorner", enemyWidget).CornerRadius = UDim.new(0, 8)
	local stroke = Instance.new("UIStroke", enemyWidget)
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 1

	local titleLbl = Instance.new("TextLabel", enemyWidget)
	titleLbl.Name = "EWTitle"
	titleLbl.Size = UDim2.new(1, -10, 0, 14)
	titleLbl.Position = UDim2.new(0, 8, 0, 4)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = "RIVAL"
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextSize = 10
	titleLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.ZIndex = 601

	local avatarImg = Instance.new("ImageLabel", enemyWidget)
	avatarImg.Name = "EWAvatar"
	avatarImg.Size = UDim2.new(0, 44, 0, 44)
	avatarImg.Position = UDim2.new(0, 6, 0, 20)
	avatarImg.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	avatarImg.BorderSizePixel = 0
	avatarImg.Image = ""
	avatarImg.ZIndex = 601
	Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(0, 6)
	local avatarStroke = Instance.new("UIStroke", avatarImg)
	avatarStroke.Color = Color3.fromRGB(180, 180, 180)
	avatarStroke.Thickness = 1

	local nameLbl = Instance.new("TextLabel", enemyWidget)
	nameLbl.Name = "EWName"
	nameLbl.Size = UDim2.new(1, -60, 0, 18)
	nameLbl.Position = UDim2.new(0, 56, 0, 22)
	nameLbl.BackgroundTransparency = 1
	nameLbl.Text = "---"
	nameLbl.Font = Enum.Font.GothamBold
	nameLbl.TextSize = 13
	nameLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
	nameLbl.TextXAlignment = Enum.TextXAlignment.Left
	nameLbl.TextScaled = false

	local timerLbl = Instance.new("TextLabel", enemyWidget)
	timerLbl.Name = "EWTimer"
	timerLbl.Size = UDim2.new(1, -60, 0, 20)
	timerLbl.Position = UDim2.new(0, 56, 0, 44)
	timerLbl.BackgroundTransparency = 1
	timerLbl.Text = ""
	timerLbl.Font = Enum.Font.GothamBlack
	timerLbl.TextSize = 16
	timerLbl.TextColor3 = Color3.fromRGB(255, 221, 0)
	timerLbl.TextXAlignment = Enum.TextXAlignment.Left
	timerLbl.ZIndex = 601

	enemyWidget.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
	enemyWidgetDragging = true
	enemyWidgetDragStart = inp.Position
	enemyWidgetStartPos = enemyWidget.Position
	inp.Changed:Connect(function()
	if inp.UserInputState == Enum.UserInputState.End then
	enemyWidgetDragging = false
	enemyWidgetPos.x = enemyWidget.Position.X.Offset
	enemyWidgetPos.y = enemyWidget.Position.Y.Offset
	_G["_SoundHub_UI_EnemyWidgetPos"] = { x = enemyWidgetPos.x, y = enemyWidgetPos.y }
	saveConfig()
	end
	end)
	end
	end)
	_G.__CrystalTrackConn(UserInputService.InputChanged:Connect((function(inp)
	if not enemyWidgetDragging then return end
	if inp.UserInputType ~= Enum.UserInputType.MouseMovement and inp.UserInputType ~= Enum.UserInputType.Touch then return end
	local delta = inp.Position - enemyWidgetDragStart
	local vs = workspace.CurrentCamera.ViewportSize
	local nx = math.clamp(enemyWidgetStartPos.X.Offset + delta.X, 0, vs.X - enemyWidget.AbsoluteSize.X)
	local ny = math.clamp(enemyWidgetStartPos.Y.Offset + delta.Y, 0, vs.Y - enemyWidget.AbsoluteSize.Y)
	enemyWidget.Position = UDim2.new(0, nx, 0, ny)
	end)))

	return enemyWidget
	end

	local function loadEnemyThumbnail(userId)
	local w = createEnemyWidget()
	local avatarImg = w:FindFirstChild("EWAvatar")
	if not avatarImg then return end
	avatarImg.Image = ""
	task.spawn(function()
	local ok, img = pcall(function()
	return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
	end)
	if ok and img and avatarImg and avatarImg.Parent then
	avatarImg.Image = img
	end
	end)
	end

	local function setTrackedEnemy(player)
	if player and trackedEnemy and player.UserId == trackedEnemyId then return end
	if not player and not trackedEnemy then return end
	trackedEnemy = player
	lastEnemyRagdollState = false
	cachedEnemyHum = nil

	local w = createEnemyWidget()
	local nameLbl = w:FindFirstChild("EWName")
	cachedTimerLbl = w:FindFirstChild("EWTimer")

	if player then
	trackedEnemyId = player.UserId
	if nameLbl then nameLbl.Text = player.Name end
	if cachedTimerLbl then cachedTimerLbl.Text = ""; lastTimerText = "" end
	loadEnemyThumbnail(player.UserId)
	w.Visible = true; lastWidgetVisible = true
	else
	trackedEnemyId = nil
	if nameLbl then nameLbl.Text = "---" end
	if cachedTimerLbl then cachedTimerLbl.Text = ""; lastTimerText = "" end
	local avatarImg = w:FindFirstChild("EWAvatar")
	if avatarImg then avatarImg.Image = "" end
	w.Visible = false; lastWidgetVisible = false
	end
	end

	local function updateEnemyTimer(dt)
	if enemyRagdollCountdown > 0 then
	enemyRagdollCountdown = math.max(0, enemyRagdollCountdown - dt)
	end
	local timerLbl = cachedTimerLbl
	if not timerLbl or not timerLbl.Parent then return end
	if enemyRagdollCountdown > 0 then
	local newText = string.format("%.1fs", enemyRagdollCountdown)
	if newText ~= lastTimerText then
	timerLbl.Text = newText
	timerLbl.TextColor3 = Color3.fromRGB(255, 221, 0)
	lastTimerText = newText
	end
	elseif lastTimerText ~= "" then
	timerLbl.Text = ""
	lastTimerText = ""
	end
	end

	local ewLastScan = 0
	local ewTimerAcc = 0
	_G.__CrystalTrackConn(RunService.Heartbeat:Connect((function(dt)

	ewTimerAcc = ewTimerAcc + (dt or 0)
	if trackedEnemy and ewTimerAcc >= 0.20 then
	updateEnemyTimer(ewTimerAcc)
	ewTimerAcc = 0
	elseif not trackedEnemy and ewTimerAcc >= 0.20 then
	ewTimerAcc = 0
	end

	local now = os.clock()
	if now - ewLastScan < 0.25 then return end
	ewLastScan = now

	local myChar = Player.Character
	local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
	if not myHRP then return end

	local myPos = myHRP.Position
	local closest = nil
	local closestDist = math.huge
	for _, plr in ipairs(Players:GetPlayers()) do
	local character = plr ~= Player and plr.Character
	if character then
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if hrp then
	local position = hrp.Position
	local dx = myPos.X - position.X
	local dy = myPos.Y - position.Y
	local dz = myPos.Z - position.Z
	local d = dx*dx + dy*dy + dz*dz
	if d < closestDist then
	closestDist = d
	closest = plr
	end
	end
	end
	end

	if closest ~= trackedEnemy then
	setTrackedEnemy(closest)
	end

	local w = enemyWidget
	if w and w.Parent then
	local shouldShow = closest ~= nil
	if shouldShow ~= lastWidgetVisible then
	w.Visible = shouldShow
	lastWidgetVisible = shouldShow
	end
	end

	if trackedEnemy then
	local nameLbl = w and w:FindFirstChild("EWName")
	if nameLbl then
	if trackedEnemy:GetAttribute("Stealing") == true then
	nameLbl.TextColor3 = Color3.fromRGB(255, 60, 60)
	else
	nameLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
	end
	end
	end

	if trackedEnemy and trackedEnemy.Character then
	if not cachedEnemyHum or not cachedEnemyHum.Parent then
	cachedEnemyHum = trackedEnemy.Character:FindFirstChildOfClass("Humanoid")
	end
	if cachedEnemyHum then
	local state = cachedEnemyHum:GetState()
	local isRagdolled = (
	state == Enum.HumanoidStateType.Physics or
	state == Enum.HumanoidStateType.Ragdoll or
	state == Enum.HumanoidStateType.FallingDown
	)
	if isRagdolled and not lastEnemyRagdollState then
	enemyRagdollCountdown = 3.0
	elseif isRagdolled and enemyRagdollCountdown < 0.5 then

	enemyRagdollCountdown = 0.5
	end
	lastEnemyRagdollState = isRagdolled
	end
	end
	end)))

	_G["_SoundHub_EnemyWidget_SaveHook"] = function()
	if enemyWidget and enemyWidget.Parent then
	enemyWidgetPos.x = enemyWidget.Position.X.Offset
	enemyWidgetPos.y = enemyWidget.Position.Y.Offset
	_G["_SoundHub_UI_EnemyWidgetPos"] = { x = enemyWidgetPos.x, y = enemyWidgetPos.y }
	end
	end

	createEnemyWidget()
	end

	local function makeUraniumSection(parent, title)
	local section = Instance.new("Frame")
	section.Name = (title and tostring(title) or "Section") .. "SectionStub"
	section.BackgroundTransparency = 1
	section.Visible = false
	section.Parent = parent
	return section
	end

	local function makeToggle(parent, text, featureName, buildExtensionContent)
	local container = Instance.new("Frame")
	container.Name = tostring(featureName or text or "Toggle") .. "Stub"
	container.BackgroundTransparency = 1
	container.Visible = false
	container.Parent = parent
	if buildExtensionContent then
	local card = Instance.new("TextButton")
	card.Text = ""
	card.Parent = container
	local extension = Instance.new("Frame")
	extension.BackgroundTransparency = 1
	extension.Parent = container
	buildExtensionContent(extension)
	end
	return container
	end

	local function makeToggleNoKeybind(parent, text, featureName)
	local container = Instance.new("Frame")
	container.Name = tostring(featureName or text or "Toggle") .. "Stub"
	container.BackgroundTransparency = 1
	container.Visible = false
	container.Parent = parent
	return container
	end

	local function selectMode(mode)

	toggleStates["Speed Boost"] = true
	if _G.__refreshSpeedBoost then pcall(_G.__refreshSpeedBoost) end
	if selectedMode == mode then
	if _G._RaVeSpeedMethod == "V2" then
		speedToggled = not speedToggled
		toggleStates["Carry Speed"] = speedToggled
		if toggleVisualUpdaters["Carry Speed"] then toggleVisualUpdaters["Carry Speed"]() end
		pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
		pcall(function() if _G.__refreshSpeedBoost then _G.__refreshSpeedBoost() end end)
		saveConfig()
	end
	return
	end

	if _G.__CrystalResetSpeedDirection then pcall(_G.__CrystalResetSpeedDirection) end
	selectedMode = mode
	-- Script 2 behavior: V1 treats Lagger as the active speed family;
	-- V2 keeps Lagger/Normal selection separate from the carry flag.
	if _G._RaVeSpeedMethod == "V1" then
		laggerEnabled = (mode == "Lagger")
	else
		laggerEnabled = (mode == "Lagger")
	end
	if mode == "Normal" then
		speedToggled = normalCarryManualOverride and normalCarrySelected or false
		toggleStates["Carry Speed"] = speedToggled
	elseif mode == "Lagger" then
		speedToggled = laggerCarryManualOverride and laggerCarrySelected or false
		toggleStates["Carry Speed"] = speedToggled
	end
	if toggleVisualUpdaters["Carry Speed"] then pcall(toggleVisualUpdaters["Carry Speed"]) end
	for _, ref in ipairs(_speedCardRefs) do
	if ref.updateVisual then pcall(ref.updateVisual) end
	end
	saveConfig()
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	end

	FeatureToggles = FeatureToggles or {}
	FeatureToggles["SelectNormalMode"] = function()
		if toggleSpeedPair then return toggleSpeedPair("Normal") end
		return selectMode("Normal")
	end
	FeatureToggles["Auto Left"] = function()
		if _G.__CrystalAutoplaySideToggle then pcall(_G.__CrystalAutoplaySideToggle, "left") end
	end
	FeatureToggles["Auto Right"] = function()
		if _G.__CrystalAutoplaySideToggle then pcall(_G.__CrystalAutoplaySideToggle, "right") end
	end
	FeatureToggles["SelectLaggerMode"] = function()
		if toggleSpeedPair then return toggleSpeedPair("Lagger") end
		return selectMode("Lagger")
	end
	FeatureToggles["SelectDesyncMode"] = function() selectMode("Desync") end
	FeatureToggles["Toggle UI"] = function()

	if _G.__setPanelVisible then
	_G.__setPanelVisible(not Panel.Visible)
	else
	panelVisible = not Panel.Visible
	Panel.Visible = panelVisible
	toggleStates["Toggle UI"] = panelVisible
	end
	if toggleVisualUpdaters["Toggle UI"] then toggleVisualUpdaters["Toggle UI"]() end
	saveConfig()
	end
	_G._RvRefreshSpeedModes = function()
		_G._RaVeSpeedMethod = "V1"
		carrySpeedMode = "v2"
		laggerEnabled = (selectedMode == "Lagger")
		pcall(function() if _G.__refreshSpeedBoost then _G.__refreshSpeedBoost() end end)
		pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	end

	local function getSelectedBoostSpeed()
	if selectedMode == "Lagger" or laggerEnabled then
	return speedValues.LaggerBoost or laggerSpeed
	elseif selectedMode == "Desync" then
	return speedValues.DesyncBoost or normalSpeed
	end
	for _, cs in ipairs(customSpeeds) do
	if selectedMode == cs.name then return cs.boost end
	end
	return speedValues.NormalBoost or normalSpeed
	end

	-- Anti Ragdoll (TS / "splatter" recovery): force GettingUp, zero velocities,
	-- re-enable motors, restore camera + controls when ragdolled/physics/falling.
	local AntiRagdollState = {
		enabled = false,
		conn = nil,
		ResetCooldown = 0,
	}

	local function stopAntiRagdoll()
		AntiRagdollState.enabled = false
		if AntiRagdollState.conn then
			pcall(function() AntiRagdollState.conn:Disconnect() end)
			AntiRagdollState.conn = nil
		end
	end

	local function startAntiRagdoll()
		if AntiRagdollState.conn then return end
		AntiRagdollState.enabled = true
		AntiRagdollState.conn = RunService.Heartbeat:Connect(function()
			if not AntiRagdollState.enabled or not toggleStates["Anti Ragdoll"] then return end
			local character = Player.Character
			if not character then return end
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
			if not humanoid or not humanoidRootPart or humanoid.Health <= 0 then return end
			if _G.dropActive or _G.__CrystalDropActive then return end

			local state = humanoid:GetState()
			local currentTime = tick()
			if state == Enum.HumanoidStateType.Physics
				or state == Enum.HumanoidStateType.Ragdoll
				or state == Enum.HumanoidStateType.FallingDown
				or humanoid.PlatformStand then
				if currentTime - AntiRagdollState.ResetCooldown > 0.15 then
					AntiRagdollState.ResetCooldown = currentTime
					pcall(function()
						humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
						humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
						humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
						pcall(function()
							humanoidRootPart.Velocity = Vector3.zero
							humanoidRootPart.RotVelocity = Vector3.zero
						end)

						-- FPS: cache Motor6D/Constraint list per character instead of GetDescendants every hit
						local cache = AntiRagdollState.jointCache
						if not cache or cache.char ~= character then
							local joints = {}
							for _, descendant in ipairs(character:GetDescendants()) do
								if descendant:IsA("Motor6D") or descendant:IsA("Constraint") then
									joints[#joints + 1] = descendant
								end
							end
							cache = { char = character, joints = joints }
							AntiRagdollState.jointCache = cache
						end
						for _, joint in ipairs(cache.joints) do
							if joint and joint.Parent then pcall(function() joint.Enabled = true end) end
						end

						if workspace.CurrentCamera then
							workspace.CurrentCamera.CameraSubject = humanoid
						end

						-- FPS: require ControlModule once, not on every recovery
						if AntiRagdollState.controlModule == nil then
							local playerModule = Player:FindFirstChild("PlayerScripts")
								and Player.PlayerScripts:FindFirstChild("PlayerModule")
							if playerModule then
								local ok, controlModule = pcall(function()
									return require(playerModule:FindFirstChild("ControlModule"))
								end)
								AntiRagdollState.controlModule = (ok and controlModule) or false
							end
						end
						local controlModule = AntiRagdollState.controlModule
						if controlModule and controlModule.Enable then
							pcall(function() controlModule:Enable() end)
						end

						humanoid.AutoRotate = true
						humanoid.PlatformStand = false
						humanoid.Sit = false
					end)
				end
			end
		end)
		if _G.__CrystalTrackConn then _G.__CrystalTrackConn(AntiRagdollState.conn) end
	end

	_G.__CrystalTrackStopper(stopAntiRagdoll)
	FeaturePostToggle["Anti Ragdoll"] = function(active)
		if active then startAntiRagdoll() else stopAntiRagdoll() end
	end


	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function()
	task.wait(0.5)
	if toggleStates["Anti Ragdoll"] then
		stopAntiRagdoll()
		startAntiRagdoll()
	end
	end))

if toggleStates["Anti Ragdoll"] then startAntiRagdoll() end

	local function getSelectedStealSpeed()
	if selectedMode == "Lagger" or laggerEnabled then
	return speedValues.LaggerSteal or carrySpeed
	elseif selectedMode == "Desync" then
	return speedValues.DesyncSteal or carrySpeed
	end
	for _, cs in ipairs(customSpeeds) do
	if selectedMode == cs.name then return cs.steal end
	end
	return speedValues.NormalSteal or carrySpeed
	end

	-- Auto-carry speed detection adapted from Clean Hub Duel.
	-- Scan animal podium spawn points and latch the steal speed while carrying.
	-- Auto Carry Speed (Ambitious-style)
	-- Primary signal: Humanoid.WalkSpeed < 25
	-- SOFT mode: also latch near enemy animal podium spawns
	-- Edge-triggered lock: enters Carry Speed on low, restores previous on high
	_G.__SoundAutoCarryMode = (_G.__SoundAutoCarryMode == "SOFT") and "SOFT" or "NORMAL"
	local autoCarrySoft = _G.__SoundAutoCarrySoft or { radius = 9.5, animals = {}, lastScan = 0, scanInterval = 2 }
	_G.__SoundAutoCarrySoft = autoCarrySoft
	local autoCarryAS = _G.__SoundAutoCarryAS or { wasLow = false, locked = false, savedSpeedToggled = nil, savedCarry = nil }
	_G.__SoundAutoCarryAS = autoCarryAS
	local autoCarryLatched = false
	local autoCarryCheckAt = 0
	local autoCarryIsCarrying = false

	local function scanAutoCarryAnimals()
		local now = tick()
		if (now - (autoCarrySoft.lastScan or 0)) < (autoCarrySoft.scanInterval or 2) then return end
		autoCarrySoft.lastScan = now
		local list = {}
		local plots = workspace:FindFirstChild("Plots")
		if not plots then autoCarrySoft.animals = list; return end
		for _, plot in ipairs(plots:GetChildren()) do
			if plot:IsA("Model") then
				local mine = false
				local sign = plot:FindFirstChild("PlotSign")
				local yourBase = sign and sign:FindFirstChild("YourBase")
				if yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled == true then mine = true end
				if not mine then
					local podiums = plot:FindFirstChild("AnimalPodiums")
					if podiums then
						for _, podium in ipairs(podiums:GetChildren()) do
							if podium:IsA("Model") then
								local base = podium:FindFirstChild("Base")
								local spawn = base and base:FindFirstChild("Spawn")
								if spawn and spawn:IsA("BasePart") then list[#list + 1] = spawn.Position end
							end
						end
					end
				end
			end
		end
		autoCarrySoft.animals = list
	end

	local function autoCarryNearTarget()
		scanAutoCarryAnimals()
		local char = Player.Character
		local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
		if not root then return false end
		local best, rp = math.huge, root.Position
		for _, pos in ipairs(autoCarrySoft.animals) do
			local d = (rp - pos).Magnitude
			if d < best then best = d end
		end
		return best <= (tonumber(autoCarrySoft.radius) or 9.5)
	end

	local function detectAutoCarry()
		local now = tick()
		if now - autoCarryCheckAt < 0.05 then return autoCarryIsCarrying end
		autoCarryCheckAt = now
		local char = Player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		-- Ambitious primary: reduced WalkSpeed while carrying
		local carrying = hum and hum.WalkSpeed > 0 and hum.WalkSpeed < 25
		if not carrying then
			carrying = Player:GetAttribute("Stealing") == true
				or (char and char:GetAttribute("Stealing") == true)
				or false
		end
		autoCarryIsCarrying = carrying == true
		return autoCarryIsCarrying
	end

	local function applyAutoCarryLock(wantCarry)
		if wantCarry then
			if not autoCarryAS.locked then
				autoCarryAS.savedSpeedToggled = speedToggled == true
				autoCarryAS.savedCarry = toggleStates["Carry Speed"] == true
			end
			autoCarryAS.locked = true
			if not speedToggled then
				speedToggled = true
				toggleStates["Carry Speed"] = true
				if toggleVisualUpdaters["Carry Speed"] then pcall(toggleVisualUpdaters["Carry Speed"]) end
				if not toggleStates["Speed Boost"] then
					toggleStates["Speed Boost"] = true
					if FeaturePostToggle["Speed Boost"] then pcall(FeaturePostToggle["Speed Boost"], true) end
				end
				if _G.__refreshSpeedBoost then pcall(_G.__refreshSpeedBoost) end
			end
			autoCarryLatched = true
		else
			if autoCarryAS.locked then
				autoCarryAS.locked = false
				-- Restore previous carry state only if we forced it on
				if autoCarryAS.savedSpeedToggled == false or autoCarryAS.savedCarry == false then
					speedToggled = false
					toggleStates["Carry Speed"] = false
					if toggleVisualUpdaters["Carry Speed"] then pcall(toggleVisualUpdaters["Carry Speed"]) end
					if _G.__refreshSpeedBoost then pcall(_G.__refreshSpeedBoost) end
				end
				autoCarryAS.savedSpeedToggled = nil
				autoCarryAS.savedCarry = nil
			end
			autoCarryLatched = false
		end
	end

	local function updateAutoSwitchToCarry()
		if not toggleStates["Auto Carry Speed"] then
			if autoCarryAS.locked then applyAutoCarryLock(false) end
			autoCarryAS.wasLow = false
			return
		end
		local isLow = detectAutoCarry()
		if _G.__SoundAutoCarryMode == "SOFT" then
			isLow = isLow or autoCarryNearTarget()
		end
		if isLow == autoCarryAS.wasLow then return end
		autoCarryAS.wasLow = isLow
		applyAutoCarryLock(isLow)
	end

	_G.__CrystalTrackConn(RunService.Heartbeat:Connect(function()
		updateAutoSwitchToCarry()
	end))

	local function getManualCarryChoiceForActiveFamily()
		if selectedMode == "Lagger" or laggerEnabled then
			if laggerCarryManualOverride then return laggerCarrySelected end
		elseif selectedMode == "Normal" then
			if normalCarryManualOverride then return normalCarrySelected end
		end
		return nil
	end
	local function setManualCarryChoice(mode, carry)
		if mode == "Normal" then
			normalCarryManualOverride = true
			normalCarrySelected = carry == true
		elseif mode == "Lagger" then
			laggerCarryManualOverride = true
			laggerCarrySelected = carry == true
		end
	end
	local function setActivePairManualChoice(carry)
		if selectedMode == "Lagger" or laggerEnabled then
			setManualCarryChoice("Lagger", carry)
		elseif selectedMode == "Normal" then
			setManualCarryChoice("Normal", carry)
		end
	end
	local function shouldUseStealSpeed(isStealing)
		local manualChoice = getManualCarryChoiceForActiveFamily()
		-- Only honor force-ON manual; force-OFF must not block Auto Carry (Ambitious).
		if manualChoice == true then return true end
		if speedToggled then return true end
		if not toggleStates["Auto Carry Speed"] then autoCarryLatched = false; return false end
		local carrying = isStealing or detectAutoCarry()
		if _G.__SoundAutoCarryMode == "SOFT" and autoCarryNearTarget() then carrying = true end
		if carrying then autoCarryLatched = true; return true end
		if autoCarryLatched and detectAutoCarry() then return true end
		autoCarryLatched = false
		return false
	end

	local function updateAutoSpeedMethod(isStealing)
		-- Keeps the carry/normal flag in sync; the engine (V1/V2) is chosen by the user, so no restart is needed.
		local useCarrySpeed = shouldUseStealSpeed(isStealing)
		local desiredMethod = useCarrySpeed and "V2" or "V1"
		if _G._RaVeSpeedMethod ~= desiredMethod then
			_G._RaVeSpeedMethod = desiredMethod
			carrySpeedMode = "v2"
		end
		return false
	end

	toggleSpeedPair = function(mode)
		if mode ~= "Normal" and mode ~= "Lagger" then return false end
		local isActivePair = selectedMode == mode
		local currentCarry = false
		if mode == "Normal" then
			if normalCarryManualOverride then
				currentCarry = normalCarrySelected
			elseif isActivePair then
				currentCarry = shouldUseStealSpeed(Player:GetAttribute("Stealing") == true)
			end
		else
			if laggerCarryManualOverride then
				currentCarry = laggerCarrySelected
			elseif isActivePair then
				currentCarry = shouldUseStealSpeed(Player:GetAttribute("Stealing") == true)
			end
		end
		local nextCarry = not currentCarry
		setManualCarryChoice(mode, nextCarry)
		if selectedMode ~= mode then selectMode(mode) end
		toggleStates["Speed Boost"] = true
		speedToggled = nextCarry
		toggleStates["Carry Speed"] = nextCarry
		if toggleVisualUpdaters["Carry Speed"] then pcall(toggleVisualUpdaters["Carry Speed"]) end
		if _G.__refreshSpeedBoost then pcall(_G.__refreshSpeedBoost) end
		updateAutoSpeedMethod(Player:GetAttribute("Stealing") == true)
		if _G.__refreshSpeedBillboards then pcall(_G.__refreshSpeedBillboards) end
		pcall(saveConfig)
		return nextCarry
	end

	do

	local oldSpeedState = _G.__CrystalSpeedSpoofState
	if type(oldSpeedState) == "table" then oldSpeedState.enabled = false end
	local s2State = _G.__CrystalS2SpeedState
	if type(s2State) ~= "table" then
		s2State = { hooked = false }
		_G.__CrystalS2SpeedState = s2State
	end
	s2State.enabled = false
	s2State.root = nil
	s2State.velChecked = setmetatable({}, { __mode = "k" })

	local function setupVelChecked(character)
		s2State.velChecked = setmetatable({}, { __mode = "k" })
		if not character then s2State.root = nil; return nil end
		local root = character:WaitForChild("HumanoidRootPart", 5)
		if root then
			s2State.root = root
			s2State.velChecked[root] = true
		end
		return root
	end

	local function hookVelHRP(root)
		if not root then return end
		s2State.root = root
		s2State.velChecked[root] = true
		if s2State.hooked then return end
		if type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function"
			or type(newcclosure) ~= "function" or type(checkcaller) ~= "function" then return end
		pcall(function()
			local mt = getrawmetatable(game)
			if not mt then return end
			local originalIndex = rawget(mt, "__index")
			if type(originalIndex) ~= "function" and type(originalIndex) ~= "table" then return end
			local replacementIndex = newcclosure(function(self, key)
				local value
				if type(originalIndex) == "function" then value = originalIndex(self, key)
				else value = originalIndex[key] end
				if not checkcaller() and s2State.velChecked[self]
					and (key == "AssemblyLinearVelocity" or key == "Velocity")
					and typeof(value) == "Vector3" and value.Magnitude > 20 then
					return value.Unit * 20
				end
				return value
			end)
			setreadonly(mt, false)
			mt.__index = replacementIndex
			s2State.hooked = true
			setreadonly(mt, true)
		end)
	end

	local function resetSpeedMovement()
		lastMoveDir = Vector3.zero
		s2State.enabled = false
	end
	_G.__CrystalResetSpeedDirection = function()
		lastMoveDir = Vector3.zero
		local character = Player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if humanoid and root and humanoid.MoveDirection.Magnitude <= 0.05 then
			root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
		end
	end
	local isRagdollState = (function(hum)
		if not hum then return true end
		local st = hum:GetState()
		return hum.PlatformStand or st == Enum.HumanoidStateType.Physics
			or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
	end)
	local getTargetSpeed = (function(isStealing)
		if shouldUseStealSpeed(isStealing) then return getSelectedStealSpeed() end
		return getSelectedBoostSpeed()
	end)
	local cleanSpeedLV, cleanSpeedAttachment
	local speedBodyForce
	local cleanSpeedBlockedTime = 0
	local function destroyCleanSpeedLV()
		if cleanSpeedLV then pcall(function() cleanSpeedLV:Destroy() end) end
		if cleanSpeedAttachment then pcall(function() cleanSpeedAttachment:Destroy() end) end
		cleanSpeedLV, cleanSpeedAttachment = nil, nil
		cleanSpeedBlockedTime = 0
		if speedBodyForce then pcall(function() speedBodyForce:Destroy() end); speedBodyForce = nil end
	end
	local function setupSpeedBodyForce(root)
		if not root then return end
		if speedBodyForce and speedBodyForce.Parent == root then return end
		if speedBodyForce then pcall(function() speedBodyForce:Destroy() end); speedBodyForce = nil end
		speedBodyForce = Instance.new("BodyForce")
		speedBodyForce.Name = "SoundSpeedBF"
		speedBodyForce.Force = Vector3.zero
		speedBodyForce.Parent = root
	end
	local function setupCleanSpeedLV(root)
		if cleanSpeedLV and cleanSpeedLV.Parent == root then return end
		destroyCleanSpeedLV()
		local att = Instance.new("Attachment")
		att.Name = "SoundCleanSpeedAttachment"
		att.Parent = root
		local lv = Instance.new("LinearVelocity")
		lv.Name = "SoundCleanSpeedLV"
		lv.Attachment0 = att
		lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
		lv.PrimaryTangentAxis = Vector3.new(1, 0, 0)
		lv.SecondaryTangentAxis = Vector3.new(0, 0, 1)
		lv.RelativeTo = Enum.ActuatorRelativeTo.World
		lv.MaxForce = 2200
		lv.PlaneVelocity = Vector2.zero
		lv.Parent = root
		cleanSpeedAttachment, cleanSpeedLV = att, lv
		pcall(function() root:SetNetworkOwner(Player) end)
	end
	local function stopSpeedBoost()
		if _G.__speedBoostConn then _G.__speedBoostConn:Disconnect(); _G.__speedBoostConn = nil end
		destroyCleanSpeedLV()
		resetSpeedMovement()
	end
	local function applyVelocitySpeed(direction, speed)
		local character = Player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoid or not root or humanoid.Health <= 0 then return end
		if type(speed) ~= "number" or speed ~= speed or speed <= 0 or speed == math.huge then return end

		local verticalVelocity = root.AssemblyLinearVelocity.Y
		if _G._ZurichHub_MovementBlocked == true or _G._SoundHub_MovementBlocked == true then
			root.AssemblyLinearVelocity = Vector3.new(0, math.min(verticalVelocity, 0), 0)
			return
		end
		if direction and direction.Magnitude > 0.05 then
			pcall(function()
				if root.SetNetworkOwner then root:SetNetworkOwner(Player) end
			end)
			local unit = direction.Unit
			root.AssemblyLinearVelocity = Vector3.new(unit.X * speed, verticalVelocity, unit.Z * speed)
		else
			root.AssemblyLinearVelocity = Vector3.new(0, verticalVelocity, 0)
		end
	end
	local function startSpeedBoost()
		stopSpeedBoost()
		-- V1: velocity-based speed on Heartbeat (RenderStepped was unnecessary FPS cost).
		_G.__speedBoostConn = RunService.Heartbeat:Connect(function()
			if not toggleStates["Speed Boost"] then return end
			if updateAutoSpeedMethod(Player:GetAttribute("Stealing") == true) then return end
			local character = Player.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			local root = character and character:FindFirstChild("HumanoidRootPart")
			if not humanoid or not root or humanoid.Health <= 0 then return end
			if toggleStates["Autoplay"] or toggleStates["TP Bat"] or toggleStates["Aimbot"] or _G.dropActive or _G.IsDropping or _G.__CrystalSideRunActive then resetSpeedMovement(); return end
			if isRagdollState(humanoid) and not _G._CrystalHitCountdownActive then lastMoveDir = Vector3.zero; return end
			if s2State.root ~= root or not s2State.velChecked[root] then
				lastMoveDir = Vector3.zero; setupVelChecked(character); hookVelHRP(root)
			end
			s2State.enabled = true
			local direction
			if humanoid.MoveDirection.Magnitude > 0 then lastMoveDir = humanoid.MoveDirection; direction = humanoid.MoveDirection
			elseif lastMoveDir.Magnitude > 0 then
				for key in pairs(MOVE_KEYS) do if UserInputService:IsKeyDown(key) then direction = lastMoveDir; break end end
			end
			applyVelocitySpeed(direction, tonumber(getTargetSpeed(Player:GetAttribute("Stealing") == true)) or 16)
		end)
	end

	local function applySpeedBoostNow()
		if not toggleStates["Speed Boost"] then return end
		local character = Player.Character
		local hum = character and character:FindFirstChildOfClass("Humanoid")
		if not hum or hum.Health <= 0 then return end
		if isRagdollState(hum) and not _G._CrystalHitCountdownActive then return end
		local direction = hum.MoveDirection.Magnitude > 0.05 and hum.MoveDirection or nil
		applyVelocitySpeed(direction, getTargetSpeed(Player:GetAttribute("Stealing") == true))
	end
	local function refreshSpeedBoost()
		if toggleStates["Speed Boost"] then startSpeedBoost() else stopSpeedBoost() end
	end
	_G.__refreshSpeedBoost = refreshSpeedBoost
	_G.__stopSpeedBoost = stopSpeedBoost
	_G.__CrystalTrackStopper(function()
		toggleStates["Speed Boost"] = false
		stopSpeedBoost()
		s2State.root = nil
		_G.__CrystalResetSpeedDirection = nil
	end)
	if Player.Character then
		local initialRoot = setupVelChecked(Player.Character)
		hookVelHRP(initialRoot)
	end
	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(character)
		task.wait(0.5)
		resetSpeedMovement()
		local root = character:WaitForChild("HumanoidRootPart", 5)
		if root then setupVelChecked(character); hookVelHRP(root) end
		if toggleStates["Speed Boost"] then startSpeedBoost() end
	end))
	_G.__CrystalTrackConn(Player.CharacterRemoving:Connect(function()
		stopSpeedBoost()
		s2State.root = nil
		s2State.velChecked = setmetatable({}, { __mode = "k" })
	end))
	FeatureToggles["Speed Boost"] = function()
	if carrySpeedMode == "v2" then

	speedToggled = not speedToggled
	setActivePairManualChoice(speedToggled)
	toggleStates["Carry Speed"] = speedToggled

	toggleStates["Speed Boost"] = true
	startSpeedBoost()
	if toggleVisualUpdaters["Carry Speed"] then toggleVisualUpdaters["Carry Speed"]() end
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	saveConfig()
	return
	end
	toggleStates["Speed Boost"] = not toggleStates["Speed Boost"]
	if toggleVisualUpdaters["Speed Boost"] then toggleVisualUpdaters["Speed Boost"]() end
	refreshSpeedBoost(); saveConfig()
	end
	FeaturePostToggle["Speed Boost"] = function(active) if active then startSpeedBoost() else stopSpeedBoost() end end

	FeatureToggles["Carry Speed"] = function()
	if _G._RaVeSpeedMethod == "V1" then
		speedToggled = not speedToggled
		toggleStates["Carry Speed"] = speedToggled
	else
		toggleStates["Carry Speed"] = not toggleStates["Carry Speed"]
		speedToggled = toggleStates["Carry Speed"]
	end
	setActivePairManualChoice(speedToggled)

	toggleStates["Speed Boost"] = true
	startSpeedBoost()
	applySpeedBoostNow()
	if toggleVisualUpdaters["Carry Speed"] then toggleVisualUpdaters["Carry Speed"]() end
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	saveConfig()
	end
	FeaturePostToggle["Carry Speed"] = function(active)
	speedToggled = active
	setActivePairManualChoice(active)
	if active or carrySpeedMode == "v2" then
	toggleStates["Speed Boost"] = true
	startSpeedBoost()
	applySpeedBoostNow()
	end
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	end

	FeatureToggles["Auto Carry Speed"] = function()
		toggleStates["Auto Carry Speed"] = not toggleStates["Auto Carry Speed"]
		local active = toggleStates["Auto Carry Speed"]
		local postToggle = FeaturePostToggle["Auto Carry Speed"]
		if postToggle then pcall(postToggle, active) end
		if toggleVisualUpdaters["Auto Carry Speed"] then pcall(toggleVisualUpdaters["Auto Carry Speed"]) end
		if saveConfig then pcall(saveConfig) end
	end
	local autoCarryStartedBoost = false
	FeaturePostToggle["Auto Carry Speed"] = function(active)
	if active and not toggleStates["Speed Boost"] then
	toggleStates["Speed Boost"] = true
	autoCarryStartedBoost = true
	startSpeedBoost()
	elseif not active and autoCarryStartedBoost then
	toggleStates["Speed Boost"] = false
	autoCarryStartedBoost = false
	stopSpeedBoost()
	end
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	end

	local sbSetupPending = {}
	local speedLabelCache = setmetatable({}, {__mode = "k"})
	local LOCAL_SPEED_GRADIENT_GUI1 = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 220, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 220, 255)),
	})
	local LOCAL_SPEED_GRADIENT_GUI2 = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 110, 200)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 200, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 150, 240)),
	})

	local function getOverheadAccentColor()
		-- Prefer Sound color theme accent so purple / azure / green actually recolor head labels
		if type(_G.__SoundAccentColor) == "function" then
			local ok, c = pcall(_G.__SoundAccentColor)
			if ok and typeof(c) == "Color3" then return c end
		end
		if typeof(_G.__CrystalCurtAccent) == "Color3" then return _G.__CrystalCurtAccent end
		local ct = "purple"
		if _G.__CrystalHalloweenMode == true then return Color3.fromRGB(255, 126, 26) end
		if ct == "azure" then return Color3.fromRGB(80, 170, 255) end
		if ct == "green" then return Color3.fromRGB(70, 210, 110) end
		if _G.__CrystalGuiTheme == "GUI 3" then return Color3.fromRGB(255, 45, 45) end
		if _G.__CrystalGuiTheme == "GUI 2" then return Color3.fromRGB(70, 150, 240) end
		return Color3.fromRGB(168, 85, 247)
	end

	local function getSpeedThemeGradient(isLocal)
		local accent = getOverheadAccentColor()
		-- Brighter / more lit gradient (più scintillante e acceso)
		local hot = accent:Lerp(Color3.fromRGB(255, 255, 255), 0.55)
		local bright = accent:Lerp(Color3.fromRGB(255, 255, 255), 0.28)
		local mid = accent:Lerp(Color3.fromRGB(255, 240, 255), 0.08)
		local deep = accent:Lerp(Color3.fromRGB(255, 180, 255), 0.15)
		return ColorSequence.new({
			ColorSequenceKeypoint.new(0, hot),
			ColorSequenceKeypoint.new(0.35, bright),
			ColorSequenceKeypoint.new(0.7, mid),
			ColorSequenceKeypoint.new(1, deep),
		})
	end
	local setupSpeedBillboard

	-- Intro sequence and intro music are disabled.
	local function playSoundIntroSong() end

	local function getPlayerSpeedDisplayText(p)
	local char = p.Character
	if not char then return "Speed: 0" end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return "Speed: 0" end
	local velocity = hrp.AssemblyLinearVelocity
	local realSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
	local displaySpeed = realSpeed < 0.5 and 0 or math.floor(realSpeed + 0.5)
	if p == Player then
	local isStealing = Player:GetAttribute("Stealing") == true
	-- Afișează viteza selectată chiar și când jucătorul stă pe loc.
	displaySpeed = math.floor(getTargetSpeed(isStealing) + 0.5)
	if isStealing or toggleStates["Carry Speed"] == true then
	return "Speed: " .. tostring(displaySpeed) .. " - Carry"
	end
	return "Speed: " .. tostring(displaySpeed)
	end
	return "Speed: " .. tostring(displaySpeed)
	end

	local function requestSpeedBillboard(char, isLocal)
	if not char or not char.Parent then return end
	if sbSetupPending[char] then return end
	sbSetupPending[char] = true
	task.spawn(function()
	setupSpeedBillboard(char, isLocal)
	sbSetupPending[char] = nil
	end)
	end

	setupSpeedBillboard = function(char, isLocal)
	task.wait(0.3)
	local head = char:FindFirstChild("Head")
	if not head then return end
	local old = head:FindFirstChild("GreenDuelsBB")
	if old then old:Destroy() end
	local oldCrystal = head:FindFirstChild("SoundSpeedBill")
	if oldCrystal then oldCrystal:Destroy() end
	local oldOverhead = head:FindFirstChild("SoundHubOverhead")
	if oldOverhead then oldOverhead:Destroy() end
	-- Elimină variante vechi care puteau rămâne active la zoom.
	for _, oldName in ipairs({"Green22sBB", "22sSpeedBill", "22sHubOverhead"}) do
		local stale = head:FindFirstChild(oldName)
		if stale then stale:Destroy() end
	end

	local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
	if torso then local oldTorsoBB = torso:FindFirstChild("GreenDuelsBB")
	if oldTorsoBB then oldTorsoBB:Destroy() end end
	local localPlayerGui = isLocal and Player:FindFirstChildOfClass("PlayerGui") or nil
	if localPlayerGui then
		local previousLocalBillboard = localPlayerGui:FindFirstChild("GreenDuelsBB")
		if previousLocalBillboard then previousLocalBillboard:Destroy() end
	end
	local bb = Instance.new("BillboardGui")
	bb.Adornee = head
	bb.Parent = localPlayerGui or head
	bb.Name = "GreenDuelsBB"
	bb:SetAttribute("CrystalThemeWorldAccent", true)
	-- Match the fixed-pixel overhead sizing from the reference script.
	bb.Size = isLocal and UDim2.fromOffset(160, 64) or UDim2.fromOffset(150, 48)
	bb.StudsOffset = isLocal and Vector3.new(0, 1.6, 0) or Vector3.new(0, 4.8, 0)
	bb.AlwaysOnTop = true
	bb.LightInfluence = 0
	bb.MaxDistance = 0

	local function applySpeedLabelStyle(lbl, localOnly)
	-- Custom font on overhead (discord + speed) when selected
	local customFont = nil
	pcall(function()
		if _G.CrystalFonts and _G.CrystalFonts.current then
			customFont = _G.CrystalFonts.current()
		end
	end)
	if customFont then
		pcall(function() lbl.FontFace = customFont end)
	else
		lbl.Font = Enum.Font.GothamBlack
	end
	lbl.TextStrokeTransparency = 0
	local accent = getOverheadAccentColor()
	local lit = accent:Lerp(Color3.fromRGB(255, 255, 255), 0.4)
	if localOnly then
	lbl.TextColor3 = lit
	local stroke = Instance.new("UIStroke", lbl)
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 1.5
	stroke.Transparency = 0.2
	local grad = Instance.new("UIGradient")
	grad.Name = "SpeedTextGradient"
	grad.Color = getSpeedThemeGradient(true)
	grad.Parent = lbl
	else
	lbl.TextColor3 = lit
	local stroke = Instance.new("UIStroke", lbl)
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 2
	stroke.Transparency = 0.1
	local grad = Instance.new("UIGradient")
	grad.Name = "SpeedTextGradient"
	grad.Color = getSpeedThemeGradient(false)
	grad.Parent = lbl
	end
	end

	local discordLbl = Instance.new("TextLabel", bb)
	discordLbl.Name = "DiscordBillLbl"
	discordLbl.Size = UDim2.new(1, 0, 0, isLocal and 28 or 22)
	discordLbl.Position = UDim2.new(0, 0, 0, 0)
	discordLbl.BackgroundTransparency = 1
	discordLbl.Text = isLocal and "I Love Sound" or ""
	discordLbl.Visible = isLocal
	discordLbl.TextScaled = false
	discordLbl.TextSize = isLocal and 17 or 15
	applySpeedLabelStyle(discordLbl, isLocal)

	-- Small header panel (top) behind "I LOVE Sound"; speed label sits below it
	discordLbl.ZIndex = 2
	discordLbl.Size = UDim2.new(0, 130, 0, 26)
	discordLbl.AnchorPoint = Vector2.new(0.5, 0)
	discordLbl.Position = UDim2.new(0.5, 0, 0, 1)
	discordLbl.TextSize = 15
	if isLocal then
		-- pill layout: big number on top, divider, discord tag underneath
		discordLbl.Size = UDim2.new(1, -12, 0, 18)
		discordLbl.Position = UDim2.new(0.5, 0, 0, 4)
		discordLbl.TextSize = 13
		discordLbl.ZIndex = 4
	end
	if isLocal then
		-- No panel: menu TITLE image on top, speed text underneath
		discordLbl.Visible = false
		discordLbl.Text = ""
		local titleImg = Instance.new("ImageLabel")
		titleImg.Name = "OverheadTitleImage"
		titleImg.BackgroundTransparency = 1
		titleImg.AnchorPoint = Vector2.new(0.5, 0)
		titleImg.Position = UDim2.new(0.5, 0, 0, 0)
		titleImg.Size = UDim2.new(1, 0, 0, 38)
		titleImg.ScaleType = Enum.ScaleType.Fit
		titleImg.Image = (type(_G.__CrystalCurrentTitleImage) == "string" and _G.__CrystalCurrentTitleImage ~= "" and _G.__CrystalCurrentTitleImage)
			or _G.__CrystalCurtWordImage or "rbxassetid://135364804744286"
		titleImg.ZIndex = 4
		titleImg.Parent = bb
		task.spawn(function()
			local lastAccent = nil
			while titleImg.Parent do
				local cur = _G.__CrystalCurrentTitleImage
				if _G.__CrystalHalloweenMode == true or (toggleStates and toggleStates["Halloween Mode"] == true) then
					cur = (type(_G.__CrystalHalloweenTitleImage) == "string" and _G.__CrystalHalloweenTitleImage ~= "" and _G.__CrystalHalloweenTitleImage)
						or ((_G["_SoundHub_UI_TitleVariant_halloween"] == "V2") and "rbxassetid://103565524925775" or "rbxassetid://95866470022902")
				end
				if type(cur) == "string" and cur ~= "" and titleImg.Image ~= cur then titleImg.Image = cur end
				-- repaint the speed label live when the colour theme changes (no rejoin needed)
				local okA, acc = pcall(getOverheadAccentColor)
				local key = okA and tostring(acc) or nil
				if key and lastAccent ~= nil and key ~= lastAccent then
					if type(_G.__CrystalRefreshHalloweenOverhead) == "function" then pcall(_G.__CrystalRefreshHalloweenOverhead) end
				end
				lastAccent = key or lastAccent
				task.wait(0.5)
			end
		end)
	end

	local overheadDivider = Instance.new("Frame")
	overheadDivider.Name = "HalloweenDivider"
	overheadDivider.BorderSizePixel = 0
	overheadDivider.BackgroundColor3 = Color3.fromRGB(255, 126, 26)
	overheadDivider.BackgroundTransparency = 0.05
	overheadDivider.Size = UDim2.new(0.72, 0, 0, 1)
	overheadDivider.AnchorPoint = Vector2.new(0.5, 0)
	overheadDivider.Position = UDim2.new(0.5, 0, 0, isLocal and 28 or 22)
	overheadDivider.Visible = false
	overheadDivider.Parent = bb
	local dividerGlow = Instance.new("UIStroke")
	dividerGlow.Name = "HalloweenGlow"
	dividerGlow.Color = Color3.fromRGB(255, 126, 26)
	dividerGlow.Thickness = 2
	dividerGlow.Transparency = 0.15
	dividerGlow.Enabled = false
	dividerGlow.Parent = overheadDivider

	local speedLbl = Instance.new("TextLabel", bb)
	speedLbl.Name = "SpeedBillLbl"
	speedLbl.Size = UDim2.new(1, 0, 0, isLocal and 29 or 20)
	speedLbl.Position = UDim2.new(0, 0, 0, isLocal and 33 or 26)
	speedLbl.BackgroundTransparency = 1
	local owner = Players:GetPlayerFromCharacter(char)
	speedLbl.Text = owner and getPlayerSpeedDisplayText(owner) or "Speed: 0"
	if owner then speedLabelCache[owner] = speedLbl end
	speedLbl.TextScaled = false
	speedLbl.TextSize = isLocal and 20 or 15
	applySpeedLabelStyle(speedLbl, isLocal)
	if isLocal then
		speedLbl.Position = UDim2.new(0, 0, 0, 40)
		speedLbl.Size = UDim2.new(1, 0, 0, 22)
		speedLbl.TextSize = 16
		speedLbl.ZIndex = 4
	end

	-- Register overhead labels with font changer
	pcall(function()
		if _G.CrystalFonts and _G.CrystalFonts.applyOne then
			local f = _G.CrystalFonts.current and _G.CrystalFonts.current() or nil
			_G.CrystalFonts.applyOne(discordLbl, f)
			_G.CrystalFonts.applyOne(speedLbl, f)
		end
	end)

	_G.__CrystalRegisterThemeRoot(bb)
	end

	local halloweenGlowTweens = setmetatable({}, {__mode = "k"})
	local function setHalloweenGlow(glow, enabled, thickness)
		if not glow then return end
		local existing = halloweenGlowTweens[glow]
		if enabled then
			glow.Enabled = true
			glow.Color = Color3.fromRGB(255, 126, 26)
			glow.Thickness = thickness or 2.5
			if not existing then
				local tween = game:GetService("TweenService"):Create(glow, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.62, Thickness = 4})
				halloweenGlowTweens[glow] = tween
				tween:Play()
			end
		else
			if existing then pcall(function() existing:Cancel() end); halloweenGlowTweens[glow] = nil end
			glow.Transparency = 1
			glow.Thickness = 1
			glow.Enabled = false
		end
	end

	local function refreshHalloweenOverheadTheme()
		local halloween = (_G.__CrystalHalloweenMode == true) or (toggleStates and toggleStates["Halloween Mode"] == true)
		for _, p in ipairs(Players:GetPlayers()) do
			local char = p.Character
			local head = char and char:FindFirstChild("Head")
			local bb = nil
			if p == Player then
				local pg = Player:FindFirstChildOfClass("PlayerGui")
				bb = pg and pg:FindFirstChild("GreenDuelsBB")
			end
			bb = bb or (head and head:FindFirstChild("GreenDuelsBB"))
			if bb then
				local discord = bb:FindFirstChild("DiscordBillLbl")
				local speed = bb:FindFirstChild("SpeedBillLbl")
				local divider = bb:FindFirstChild("HalloweenDivider")
				if discord and p == Player then discord.Text = "I Love Sound" end
				if speed then
					local base = getPlayerSpeedDisplayText(p)
					if halloween then
						local value = base:match("[Ss]peed:%s*(.-)%s*%-?%s*[Cc]arry$") or base:match("[Ss]peed:%s*(.*)$") or "0"
						speed.Text = "SPEED: " .. value .. " - CARRY"
					else speed.Text = base end
					local glow = speed:FindFirstChild("HalloweenGlow")
					if not glow then glow = Instance.new("UIStroke"); glow.Name = "HalloweenGlow"; glow.Parent = speed end
					setHalloweenGlow(glow, halloween, 2.5)
					local accent = getOverheadAccentColor()
					speed.TextColor3 = halloween and Color3.fromRGB(255, 157, 55) or accent
					local oldGrad = speed:FindFirstChild("SpeedTextGradient")
					if oldGrad then
						oldGrad.Enabled = not halloween
						if not halloween then oldGrad.Color = getSpeedThemeGradient(p == Player) end
					end
				end
				if discord then
					local accent = getOverheadAccentColor()
					discord.TextColor3 = halloween and Color3.fromRGB(255, 157, 55) or accent
					local glow = discord:FindFirstChild("HalloweenGlow")
					if not glow then glow = Instance.new("UIStroke"); glow.Name = "HalloweenGlow"; glow.Parent = discord end
					setHalloweenGlow(glow, halloween, 2.5)
					local grad = discord:FindFirstChild("SpeedTextGradient")
					if grad then
						grad.Enabled = not halloween
						if not halloween then grad.Color = getSpeedThemeGradient(p == Player) end
					end
				end
				if divider then
					divider.Visible = halloween
					local dg = divider:FindFirstChild("HalloweenGlow"); if dg then setHalloweenGlow(dg, halloween, 2) end
				end
			end
		end
	end
	_G.__CrystalRefreshHalloweenOverhead = refreshHalloweenOverheadTheme

	local function setupForPlayer(p)
	if p.Character then requestSpeedBillboard(p.Character, p == Player) end
	_G.__CrystalTrackConn(p.CharacterAdded:Connect(function(char) requestSpeedBillboard(char, p == Player) end))
	end

	for _, p in ipairs(Players:GetPlayers()) do
	if p ~= Player then setupForPlayer(p) end
	end
	_G.__CrystalTrackConn(Players.PlayerAdded:Connect(function(p) setupForPlayer(p) end))
	if Player.Character then requestSpeedBillboard(Player.Character, true) end
	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(char)

	speedToggled = toggleStates["Carry Speed"] == true
	task.spawn(function()
	requestSpeedBillboard(char, true)
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	end)
	end))

	local sbLastUpdate = 0

	local sbThrottle = 0.25
	local sbLastText = {}

	_G.__CrystalTrackConn(RunService.Heartbeat:Connect((function(dt)
	sbLastUpdate = sbLastUpdate + (dt or 0)
	if sbLastUpdate < sbThrottle then return end
	sbLastUpdate = 0
	for _, p in ipairs(Players:GetPlayers()) do
	local char = p.Character
	if char then
	local sl = speedLabelCache[p]
	if not sl or not sl.Parent then
	speedLabelCache[p] = nil
	requestSpeedBillboard(char, p == Player)
	else
	local newText = getPlayerSpeedDisplayText(p)
	if sbLastText[p.UserId] ~= newText then
	sl.Text = newText
	sbLastText[p.UserId] = newText
	end
	end
	end
	end
	end)))
	_G.__refreshSpeedBillboards = function()
	for _, p in ipairs(Players:GetPlayers()) do
	local char = p.Character
	if not char then continue end
	local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
	local head = char:FindFirstChild("Head")
	local torso = char:FindFirstChild("UpperTorso") or hrp
	if not hrp and not head then continue end
	local localBillboard = nil
	if p == Player then
	local playerGui = Player:FindFirstChildOfClass("PlayerGui")
	localBillboard = playerGui and playerGui:FindFirstChild("GreenDuelsBB")
	end
	local bb = localBillboard or (head and (head:FindFirstChild("Green22sBB") or head:FindFirstChild("GreenDuelsBB")))
		or (torso and (torso:FindFirstChild("Green22sBB") or torso:FindFirstChild("GreenDuelsBB")))
	if not bb then continue end
	local sl = bb:FindFirstChild("SpeedBillLbl")
	local dl = bb:FindFirstChild("DiscordBillLbl")
	pcall(function()
		if _G.CrystalFonts and _G.CrystalFonts.applyOne then
			local f = _G.CrystalFonts.current and _G.CrystalFonts.current() or nil
			if sl then _G.CrystalFonts.applyOne(sl, f) end
			if dl then _G.CrystalFonts.applyOne(dl, f) end
		end
	end)
	if not sl then continue end
	speedLabelCache[p] = sl
	sl.Text = getPlayerSpeedDisplayText(p)
	do
	local gradientColor = getSpeedThemeGradient(p == Player)
	local accent = getOverheadAccentColor()
	local lit = accent:Lerp(Color3.fromRGB(255, 255, 255), 0.4)
	local halloween = (_G.__CrystalHalloweenMode == true) or (toggleStates and toggleStates["Halloween Mode"] == true)
	for _, child in ipairs(bb:GetChildren()) do
	if child:IsA("TextLabel") then
	local gradient = child:FindFirstChild("SpeedTextGradient")
	if gradient then
		gradient.Color = gradientColor
		gradient.Enabled = not halloween
	end
	if not halloween then
		child.TextColor3 = lit
	else
		child.TextColor3 = Color3.fromRGB(255, 157, 55)
	end
	end
	end
	end
	end
	end

	refreshSpeedBoost()

	local autoLeftWaypoints = {
	Vector3.new(-475.86,-7,91.97), Vector3.new(-485.83,-7,97.37),
	Vector3.new(-475.86,-7,91.97), Vector3.new(-476.35,-7,27.88), Vector3.new(-477.09,-7,19.85),
	}
	local autoRightWaypoints = {
	Vector3.new(-475.84,-7,28.81), Vector3.new(-486.04,-7,23.32),
	Vector3.new(-475.51,-7,29.01), Vector3.new(-476.43,-7,91.61), Vector3.new(-476.27,-7,98.86),
	}
	_G.__autoLeftWaypoints = autoLeftWaypoints
	_G.__autoRightWaypoints = autoRightWaypoints

	local autoplayActive = false; local autoplayMode = "none"; local autoplayWPIdx = 1
	local autoplayConn = nil

	_G.__autoplayMode = "Semi"

	local function getAutoplayModeForMyBase()
	local plots = workspace:FindFirstChild("Plots"); if not plots then return "left" end
	for _, plot in ipairs(plots:GetChildren()) do
	local sign = plot:FindFirstChild("PlotSign"); local yourBase = sign and sign:FindFirstChild("YourBase")
	if yourBase and yourBase.Enabled then
	local target = plot:FindFirstChild("AnimalTarget",true); local refPos = target and target.Position
	if not refPos then local delivery=plot:FindFirstChild("DeliveryHitbox"); refPos=delivery and delivery.Position end
	if refPos then
	if type(autoLeftWaypoints)=="table" and type(autoRightWaypoints)=="table" and autoLeftWaypoints[1] and autoRightWaypoints[1] then
	local leftDist=(refPos-autoLeftWaypoints[1]).Magnitude; local rightDist=(refPos-autoRightWaypoints[1]).Magnitude
	return (leftDist<=rightDist) and "right" or "left"
	end
	end
	do
	local pivotPos = nil
	if typeof(plot.GetPivot) == "function" then
	pcall(function()
	local piv = plot:GetPivot()
	if piv then pivotPos = piv.Position end
	end)
	end
	if pivotPos then
	return (pivotPos.Z>=60) and "right" or "left"
	else
	return (Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("HumanoidRootPart").Position.Z>=60) and "right" or "left"
	end
	end
	end
	end
	return "left"
	end
	_G.__CrystalGetAutoplaySide = getAutoplayModeForMyBase

	;(function()
	if _G.__ZurichSetFullNoPlayerCollision then pcall(_G.__ZurichSetFullNoPlayerCollision, false) end
	local npcEnabled = false
	local npcSuspended = false
	local npcConnections = {}
	local npcOriginalCollisions = setmetatable({}, {__mode = "k"})

	local function autoBatControlsPhysics()
	return toggleStates["TP Bat"] == true
	end

	local function disablePartCollision(part)
	if not part:IsA("BasePart") then return end
	if npcOriginalCollisions[part] == nil then
	npcOriginalCollisions[part] = {
	CanCollide = part.CanCollide,
	CanTouch = part.CanTouch,
	}
	end
	if part.CanCollide then part.CanCollide = false end
	if part.CanTouch then part.CanTouch = false end
	end

	local function disableCharacterCollisions(character)
	if not character then return end
	for _, part in ipairs(character:GetDescendants()) do
	disablePartCollision(part)
	end
	end

	local function watchCharacterCollisions(character)
	if autoBatControlsPhysics() then return end
	disableCharacterCollisions(character)
	table.insert(npcConnections, character.DescendantAdded:Connect(function(part)
	if npcEnabled and not npcSuspended and not autoBatControlsPhysics() then disablePartCollision(part) end
	end))
	end

	local function watchPlayerCollisions(plr)
	if plr == Player then return end
	if plr.Character then watchCharacterCollisions(plr.Character) end
	table.insert(npcConnections, plr.CharacterAdded:Connect(function(character)
	if npcEnabled and not npcSuspended and not autoBatControlsPhysics() then watchCharacterCollisions(character) end
	end))
	end

	local function restoreTrackedCollisions()
	for part, original in pairs(npcOriginalCollisions) do
	if part and part.Parent then
	pcall(function()
	part.CanCollide = original.CanCollide
	part.CanTouch = original.CanTouch
	end)
	end
	end
	npcOriginalCollisions = setmetatable({}, {__mode = "k"})
	end

	local alwaysOnAntiFling = (function()
	if _G.dropActive or _G.IsDropping then return end
	local character = Player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not root or not humanoid or humanoid.Health <= 0 then return end
	local velocity = root.AssemblyLinearVelocity
	local horizontal = Vector3.new(velocity.X, 0, velocity.Z)
	local angular = root.AssemblyAngularVelocity
	local intentionalMovement = toggleStates["TP Bat"] == true
		or toggleStates["Aimbot"] == true
		or autoplayActive == true
	local flung = horizontal.Magnitude > 375 or math.abs(velocity.Y) > 300 or angular.Magnitude > 110
	if flung and not intentionalMovement then
	-- FPS: only zero root velocities; full GetDescendants every PostSimulation was expensive
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	pcall(function()
	root.Velocity = Vector3.zero
	root.RotVelocity = Vector3.zero
	end)
	end
	end)

	local function enableNoPlayerCollision()
	if npcEnabled then return end
	npcEnabled = true
	npcSuspended = autoBatControlsPhysics()

	if not npcSuspended then
	for _, plr in ipairs(Players:GetPlayers()) do watchPlayerCollisions(plr) end
	end
	table.insert(npcConnections, Players.PlayerAdded:Connect(watchPlayerCollisions))

	-- FPS: do not re-walk every character every Stepped frame.
	-- Event-driven watchers already apply on CharacterAdded / DescendantAdded.
	-- Keep a light throttled safety pass (~1s) only.
	local npcScanAcc = 0
	table.insert(npcConnections, RunService.Heartbeat:Connect(function(dt)
	if not npcEnabled then return end
	local shouldSuspend = autoBatControlsPhysics()
	if shouldSuspend then
	if not npcSuspended then
	npcSuspended = true
	restoreTrackedCollisions()
	end
	return
	end
	if npcSuspended then
	npcSuspended = false
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= Player and plr.Character then
	watchCharacterCollisions(plr.Character)
	end
	end
	end
	npcScanAcc = npcScanAcc + (dt or 0)
	if npcScanAcc < 1.0 then return end
	npcScanAcc = 0
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= Player and plr.Character then
	-- only touch top-level BaseParts (cheap), not full GetDescendants
	for _, part in ipairs(plr.Character:GetChildren()) do
	if part:IsA("BasePart") then disablePartCollision(part) end
	end
	end
	end
	end))
	end

	local function disableNoPlayerCollision()
	if not npcEnabled then return end
	npcEnabled = false
	for _, connection in ipairs(npcConnections) do
	pcall(function() connection:Disconnect() end)
	end
	npcConnections = {}
	restoreTrackedCollisions()
	npcSuspended = false
	end

	_G.__ZurichSetFullNoPlayerCollision = function(active)
	if active then enableNoPlayerCollision() else disableNoPlayerCollision() end
	end
	_G.__setNoPlayerCollision = _G.__ZurichSetFullNoPlayerCollision
	_G.__getNoPlayerCollision = function() return npcEnabled end
	_G.__CrystalTrackStopper(disableNoPlayerCollision)

_G.__CrystalTrackConn(RunService.PostSimulation:Connect(alwaysOnAntiFling))
	enableNoPlayerCollision()
	end)()

	-- Base-entry fix: never alter collision on invisible world parts. Some games use
	-- invisible collidable parts as base doors/barriers, so changing CanCollide here
	-- can make base entry and plot boundaries behave incorrectly.
	local function killInvisiblePart(part)
		return -- intentionally disabled; preserve map/base collision state
	end
	local function killInvisibleParts(center, radius)
		return -- intentionally disabled; preserve map/base collision state
	end
	_G.__killInvisibleNear = killInvisibleParts
	-- Do not change CanCollide when new parts are added.
	do

	local invisibleCheckAcc = 0
	local invisibleCheckInterval = 2.0
	local invisibleGlobalAcc = 0
	local invisibleGlobalInterval = 15
	local invisibleGlobalScanCancel = nil
	_G.__CrystalTrackConn(RunService.Heartbeat:Connect((function(dt)
	local hasVisualsActive = toggleStates["ESP Players"] or toggleStates["Player Tracers"] or toggleStates["Stretchz Res"]
	if not hasVisualsActive then return end
	invisibleCheckAcc = invisibleCheckAcc + (dt or 0)
	invisibleGlobalAcc = invisibleGlobalAcc + (dt or 0)
	if invisibleCheckAcc >= invisibleCheckInterval then
	invisibleCheckAcc = 0
	local char = Player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root then
	for _, part in ipairs(char:GetDescendants()) do
	killInvisiblePart(part)
	end
	local rootVelocity = root.AssemblyLinearVelocity
	local velFlat = Vector3.new(rootVelocity.X, 0, rootVelocity.Z)
	local speed = velFlat.Magnitude
	local radius = math.clamp(20 + speed * 0.2, 20, 40)
	killInvisibleParts(root.Position, radius)
	if speed > 5 then killInvisibleParts(root.Position + velFlat * 0.35, radius) end
	end
	end
	if invisibleGlobalAcc >= invisibleGlobalInterval then
	invisibleGlobalAcc = 0
	if invisibleGlobalScanCancel then invisibleGlobalScanCancel() end
	invisibleGlobalScanCancel = _G.__CrystalWalkDescendantsBatched(workspace, killInvisiblePart, function()
	return toggleStates["ESP Players"] or toggleStates["Player Tracers"] or toggleStates["Stretchz Res"]
	end)
	end
	end)))
	end

	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function()
	awfLastRecovery = 0
	end))

	local autoplayEnabledAutoCarry = false
	local function setAutoplayAutoCarry(active)
	if active then
	if toggleStates["Auto Carry Speed"] then return end
	autoplayEnabledAutoCarry = true
	else
	if not autoplayEnabledAutoCarry then return end
	autoplayEnabledAutoCarry = false
	end

	toggleStates["Auto Carry Speed"] = active
	local setter = toggleStateSetters["Auto Carry Speed"]
	if setter then pcall(setter, active) end
	local postToggle = FeaturePostToggle["Auto Carry Speed"]
	if postToggle then pcall(postToggle, active) end
	local visual = toggleVisualUpdaters["Auto Carry Speed"]
	if visual then pcall(visual) end
	end

	local function setAutoplayToggleUI(state)
	toggleStates["Autoplay"] = state
	local setter = toggleStateSetters["Autoplay"]
	if setter then
	pcall(setter, state)
	return
	end
	local visual = toggleVisualUpdaters["Autoplay"]
	if visual then pcall(visual) end
	end

	local function stopAutoplay(keepToggle)
	if autoplayActive then
	autoplayActive = false
	autoplayMode = "none"
	autoplayWPIdx = 1
	if autoplayConn then autoplayConn:Disconnect(); autoplayConn = nil end
	local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
	if hrp then hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0) end
	end
	setAutoplayAutoCarry(false)
	if keepToggle then return end
	_G.__CrystalForceAutoplaySide = nil
	if toggleStates["Autoplay"] then
	setAutoplayToggleUI(false)
	saveConfig()
	end
	end
	_G.__stopAutoplay = stopAutoplay
	_G.__CrystalTrackStopper(stopAutoplay)

	local function startAutoplay()
	if autoplayActive then stopAutoplay(true) end
	deactivateOtherAimbots()

	if toggleStates["TP Bat"] and _G.CrystalAutoBat then _G.CrystalAutoBat.SetEnabled(false) end
	local mode=_G.__CrystalForceAutoplaySide or getAutoplayModeForMyBase(); autoplayMode=mode; autoplayWPIdx=1; autoplayActive=true
	setAutoplayAutoCarry(true)

	_G.__autoplayMode = "Semi"
	if autoplayConn then autoplayConn:Disconnect() end
	autoplayConn = RunService.Heartbeat:Connect((function(dt)
	if not autoplayActive then return end
	setAutoplayAutoCarry(true)
	local waypoints=(autoplayMode=="left") and autoLeftWaypoints or autoRightWaypoints

	local stopIdx = 2 -- Semi mode only; never run the full waypoint route
	local wp=waypoints[autoplayWPIdx]; if not wp then return end
	local char=Player.Character; if not char then return end
	local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
	local myPos=hrp.Position
	local targetXZ=Vector3.new(wp.X,0,wp.Z); local myXZ=Vector3.new(myPos.X,0,myPos.Z)
	local dXZ=(targetXZ-myXZ).Magnitude
	if dXZ<=1.1 then
	hrp.Velocity=Vector3.new(0,hrp.Velocity.Y,0)
	if autoplayWPIdx>=stopIdx then

	if Player:GetAttribute("Stealing") ~= true then stopAutoplay() end
	return
	end
	autoplayWPIdx=autoplayWPIdx+1
	else
	local dir=(targetXZ-myXZ); if dir.Magnitude>0.001 then dir=dir.Unit end
	-- Autoplay path always uses Normal Speed (NormalBoost); rest of hub keeps chosen speeds
	local speed = tonumber(speedValues and speedValues.NormalBoost) or tonumber(normalSpeed) or 59
	speed = math.max(1, speed)
	if dXZ<1.5 then speed=speed*math.clamp(dXZ/1.5,0.6,1) end

	speed=math.min(speed,dXZ/math.max(dt or 1/60,1/240))
	hrp.Velocity=Vector3.new(dir.X*speed,hrp.Velocity.Y,dir.Z*speed)
	end
	end))
	end

	_G.__CrystalStartAutoplay = startAutoplay
	_G.__CrystalStopAutoplay = stopAutoplay
	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function() task.wait(0.5); if autoplayActive then startAutoplay() end end))
	FeaturePostToggle["Autoplay"] = function(active)
	if active then
	setAutoplayAutoCarry(true)
	-- Enabled during hit countdown: wait until countdown ends, then start immediately
	if _G._CrystalHitCountdownActive == true then
	_G.__CrystalPendingAutoplayAfterCountdown = true
	return
	end
	_G.__CrystalPendingAutoplayAfterCountdown = false
	_G.__checkAndAutoDrop(function()
	startAutoplay()
	end)
	else
	_G.__CrystalPendingAutoplayAfterCountdown = false
	stopAutoplay()
	end
	end
	FeatureToggles["Autoplay"] = function()
	toggleStates["Autoplay"]=not toggleStates["Autoplay"]
	if toggleStates["Autoplay"] then
	setAutoplayAutoCarry(true)
	if _G._CrystalHitCountdownActive == true then
	_G.__CrystalPendingAutoplayAfterCountdown = true
	if toggleVisualUpdaters["Autoplay"] then toggleVisualUpdaters["Autoplay"]() end
	saveConfig()
	return
	end
	_G.__CrystalPendingAutoplayAfterCountdown = false
	_G.__checkAndAutoDrop(function()
	startAutoplay()
	end)
	else
	_G.__CrystalPendingAutoplayAfterCountdown = false
	stopAutoplay()
	end
	if toggleVisualUpdaters["Autoplay"] then toggleVisualUpdaters["Autoplay"]() end
	saveConfig()
	end
	if toggleStates["Autoplay"] then startAutoplay() end

	do
	local TP_DOWN_COOLDOWN = 0.10
	local lastTPDownAt = 0
	local tpDownPending = false
	local tpDownGeneration = 0
	local tpDownAlive = true
	local function cancelPendingTPDown()
	tpDownGeneration += 1
	tpDownPending = false
	end
	_G.__CrystalTrackConn(Player.CharacterRemoving:Connect(cancelPendingTPDown))
	_G.__CrystalTrackStopper(function()
	tpDownAlive = false
	cancelPendingTPDown()
	end)
	local function executeTPDown()
	if not tpDownAlive or _G.dropActive or _G.IsDropping then return end
	local now = os.clock()
	local remaining = TP_DOWN_COOLDOWN - (now - lastTPDownAt)
	if remaining > 0 then
	if not tpDownPending then
	tpDownPending = true
	local generation = tpDownGeneration
	local pendingCharacter = Player.Character
	task.delay(remaining, function()
	if generation ~= tpDownGeneration or Player.Character ~= pendingCharacter then return end
	tpDownPending = false
	executeTPDown()
	end)
	end
	return
	end
	local char = Player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 or hrp.Anchored or hum.Sit or hum.SeatPart then return end
	lastTPDownAt = os.clock()
	cancelPendingTPDown()

	local _, yaw = hrp.CFrame:ToEulerAnglesYXZ()
	pcall(function()
	hrp.CFrame = CFrame.new(hrp.Position.X, -7, hrp.Position.Z)
	* CFrame.Angles(0, yaw, 0)
	hrp.AssemblyLinearVelocity = Vector3.zero
	end)
	end

	_G["ExecuteTPDown"] = executeTPDown
	FeatureToggles["TP Down"] = executeTPDown

	;(function()
	_G.__loadInstaReset = true
	local RESET_COOLDOWN = 0.15
	local resetState = _G.__SoundInstaResetState
	if type(resetState) ~= "table" then
		resetState = {
			busy = false, busyAt = 0, token = 0, lastTrigger = 0,
			cameraConn = nil, cameraHeld = false, cameraHeldAt = 0,
			want = {}, thread = nil,
		}
		_G.__SoundInstaResetState = resetState
	end
	resetState.want = type(resetState.want) == "table" and resetState.want or {}
	_G.__CrystalInstaResetBusy = resetState.busy == true

	local function releaseResetCamera()
		if resetState.cameraConn then
			pcall(function() resetState.cameraConn:Disconnect() end)
			resetState.cameraConn = nil
		end
		resetState.cameraHeld = false
		local camera = workspace.CurrentCamera
		if camera then
			pcall(function()
				camera.CameraType = Enum.CameraType.Custom
				local character = Player.Character
				local humanoid = character and character:FindFirstChildOfClass("Humanoid")
				if humanoid then camera.CameraSubject = humanoid end
			end)
		end
	end

	local function holdResetCamera(targetCharacter)
		local camera = workspace.CurrentCamera
		if not camera then return end
		local stillHeld = resetState.cameraHeld and (os.clock() - (resetState.cameraHeldAt or 0) < 5)
		if stillHeld then return end
		resetState.cameraHeld = true
		resetState.cameraHeldAt = os.clock()
		local savedCFrame, savedFocus = camera.CFrame, camera.Focus
		pcall(function() camera.CameraType = Enum.CameraType.Scriptable end)
		resetState.cameraConn = RunService.RenderStepped:Connect(function()
			if workspace.CurrentCamera ~= camera then return end
			pcall(function()
				camera.CameraType = Enum.CameraType.Scriptable
				camera.CFrame = savedCFrame
				camera.Focus = savedFocus
			end)
		end)
		task.spawn(function()
			local elapsed = 0
			while Player.Character == targetCharacter and elapsed < 3 do
				elapsed += RunService.Heartbeat:Wait()
			end
			releaseResetCamera()
		end)
	end

	local function setTemporaryFeature(featureName, active)
		if toggleStates[featureName] == (active == true) then return end
		toggleStates[featureName] = active == true
		local callback = FeaturePostToggle[featureName]
		if callback then pcall(callback, active == true) end
		local updater = toggleVisualUpdaters[featureName]
		if updater then pcall(updater) end
	end

	local function suspendResetConflicts()
		for _, featureName in ipairs({"Anti Die", "Anti Bat", "Anti Ragdoll", "TP Bat"}) do
			if toggleStates[featureName] == true then
				resetState.want[featureName] = true
				setTemporaryFeature(featureName, false)
			end
		end
	end

	local function resumeResetConflicts()
		local restore = resetState.want or {}
		resetState.want = {}
		for featureName, shouldResume in pairs(restore) do
			if shouldResume then setTemporaryFeature(featureName, true) end
		end
	end

	local function forceHumanoidReset(character, humanoid)
		if not (character and humanoid and character.Parent) then return end
		pcall(function()
			humanoid.PlatformStand = false
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
			humanoid.BreakJointsOnDeath = true
			if humanoid.MaxHealth == math.huge or humanoid.MaxHealth <= 0 then humanoid.MaxHealth = 100 end
			humanoid.Health = 0
		end)
		pcall(function() character:BreakJoints() end)
	end

	local function prepareResetRoot(character, humanoid)
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not (root and root:IsA("BasePart") and humanoid) then return false end
		pcall(function()
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
			humanoid.BreakJointsOnDeath = true
			humanoid.PlatformStand = true
			humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
		end)
		local pulseVelocity = Vector3.new(0, math.clamp(tonumber(resetState.speed) or 1000000, 1000, 10000000), 0)
		local function pulse()
			if not root.Parent or Player.Character ~= character then return false end
			return pcall(function()
				root.AssemblyAngularVelocity = Vector3.zero
				root.AssemblyLinearVelocity = pulseVelocity
			end)
		end
		if not pulse() then return false end
		task.spawn(function()
			local elapsed = 0
			while elapsed < 1.5 do
				elapsed += RunService.Heartbeat:Wait()
				if not root.Parent or Player.Character ~= character then return end
				pulse()
			end
		end)
		return true
	end

	local function finishReset(token)
		if resetState.token ~= token then return end
		resetState.busy = false
		_G.__CrystalInstaResetBusy = false
		resetState.thread = nil
		releaseResetCamera()
		resumeResetConflicts()
	end

	local function doInstaReset()
		local now = os.clock()
		if resetState.busy and now - (resetState.busyAt or 0) < 10 then return end
		if resetState.busy then
			resetState.busy = false
			_G.__CrystalInstaResetBusy = false
			resumeResetConflicts()
		end
		if now - (resetState.lastTrigger or 0) < RESET_COOLDOWN then return end
		local character = Player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not (character and humanoid and root and root:IsA("BasePart")) then return end
		resetState.lastTrigger = now
		resetState.busy = true
		resetState.busyAt = now
		resetState.token = (resetState.token or 0) + 1
		local token = resetState.token
		_G.__CrystalInstaResetBusy = true
		suspendResetConflicts()
		resetState.thread = task.spawn(function()
			holdResetCamera(character)
			if not prepareResetRoot(character, humanoid) then forceHumanoidReset(character, humanoid) end
			local elapsed = 0
			while Player.Character == character and elapsed < 1.2 do elapsed += task.wait() or 0 end
			if Player.Character == character then
				local currentHumanoid = character:FindFirstChildOfClass("Humanoid")
				if currentHumanoid and currentHumanoid.Health > 0 then forceHumanoidReset(character, currentHumanoid) end
			end
			elapsed = 0
			while Player.Character == character and elapsed < 8 do elapsed += task.wait() or 0 end
			finishReset(token)
		end)
	end

	local function stopInstaReset()
		resetState.token = (resetState.token or 0) + 1
		if resetState.thread then pcall(task.cancel, resetState.thread); resetState.thread = nil end
		resetState.busy = false
		_G.__CrystalInstaResetBusy = false
		releaseResetCamera()
		resumeResetConflicts()
	end

	FeatureToggles["Insta Reset"] = doInstaReset
	_G.__CrystalInstaReset = doInstaReset
	_G.InstaReset = { Trigger = doInstaReset }
	_G.SoundDoInstaReset = doInstaReset
	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function()
		releaseResetCamera()
	end))
	_G.__CrystalTrackConn(RunService.Heartbeat:Connect(function()
		if not resetState.busy then return end
		local age = os.clock() - (resetState.busyAt or 0)
		if age >= 10 then
			resetState.token = (resetState.token or 0) + 1
			resetState.busy = false
			_G.__CrystalInstaResetBusy = false
			releaseResetCamera()
			resumeResetConflicts()
			return
		end
		for featureName, shouldResume in pairs(resetState.want) do
			if shouldResume and toggleStates[featureName] == true then setTemporaryFeature(featureName, false) end
		end
	end))
	_G.__CrystalTrackStopper(stopInstaReset)
	end)()

	local autoTPDownElapsed = 0
	local autoTPDownTriggered = false
	local autoTPDownRoot = nil
	local autoTPDownRaycast = RaycastParams.new()
	autoTPDownRaycast.FilterType = Enum.RaycastFilterType.Exclude
	pcall(function() autoTPDownRaycast.RespectCanCollide = true end)
	FeaturePostToggle["Auto TP Down"] = function(active)
	if not active then
	autoTPDownElapsed = 0
	autoTPDownTriggered = false
	autoTPDownRoot = nil
	end
	end
	_G.__CrystalTrackConn(RunService.Heartbeat:Connect((function(dt)
	if toggleStates["Auto TP Down"] ~= true then return end

	if _G.dropActive or _G.IsDropping then
	autoTPDownElapsed = 0
	return
	end
	-- Only while carrying a grabbed brainrot; after the drop-off it disarms until the next grab
	if Player:GetAttribute("Stealing") ~= true then
	autoTPDownTriggered = false
	autoTPDownElapsed = 0
	return
	end
	autoTPDownElapsed += dt or 0
	if autoTPDownElapsed < 0.10 then return end
	autoTPDownElapsed = 0
	local char = Player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root or not hum or hum.Health <= 0 then
	autoTPDownTriggered = false
	autoTPDownRoot = nil
	return
	end
	if root ~= autoTPDownRoot then
	autoTPDownRoot = root
	autoTPDownTriggered = false
	end
	local vel = root.AssemblyLinearVelocity
	if Vector3.new(vel.X, 0, vel.Z).Magnitude >= 25 then
	autoTPDownTriggered = false
	return
	end
	local threshold = math.clamp(tonumber(speedValues.AutoTPDownHeight) or 20, 1, 1000)
	autoTPDownRaycast.FilterDescendantsInstances = { char }
	local result = workspace:Raycast(root.Position, Vector3.new(0, -2048, 0), autoTPDownRaycast)
	local height = result and math.max(0, root.Position.Y - result.Position.Y) or nil
	local reachedHeight = height ~= nil and height >= threshold
	if reachedHeight and not autoTPDownTriggered then
	autoTPDownTriggered = true
	executeTPDown()
	elseif not reachedHeight then
	autoTPDownTriggered = false
	end
	end)))
	end

	do
	local _dropDropActive = false
	local _dropConn = nil

	local DROP_ASCEND_DURATION = 0.2
	local DROP_ASCEND_SPEED = 150

	local function drop()
	if _dropDropActive then return end
	local char = Player.Character; if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
	if _dropConn then _dropConn:Disconnect(); _dropConn = nil end

	local DROP_TARGET_Y = root.Position.Y
	_dropDropActive = true
	_G.dropActive = true
	_G.IsDropping = true
	local t0 = tick()

	_dropConn = RunService.Heartbeat:Connect(function()
	local r = char and char:FindFirstChild("HumanoidRootPart")
	if not r then
	_dropConn:Disconnect(); _dropConn = nil
	_dropDropActive = false
	_G.dropActive = false
	_G.IsDropping = false
	return
	end

	if tick() - t0 >= DROP_ASCEND_DURATION then
	_dropConn:Disconnect(); _dropConn = nil

	local _, yaw = r.CFrame:ToEulerAnglesYXZ()
	r.CFrame = CFrame.new(r.Position.X, DROP_TARGET_Y, r.Position.Z)
	* CFrame.Angles(0, yaw, 0)
	r.AssemblyLinearVelocity = Vector3.zero
	pcall(function() r.Velocity = Vector3.zero end)

	_dropDropActive = false
	_G.dropActive = false
	_G.IsDropping = false
	return
	end

	r.AssemblyLinearVelocity = Vector3.new(
	r.AssemblyLinearVelocity.X,
	DROP_ASCEND_SPEED,
	r.AssemblyLinearVelocity.Z
	)
	end)
	end

	FeatureToggles["Drop"] = drop
	_G.doDrop = drop
	end

	local function checkAndAutoDrop(callback)
	ragdollCounterPaused = true
	local function unpauseRagdollCounter()
	ragdollCounterPaused = false
	end
	if Player:GetAttribute("Stealing") then
	local char = Player.Character
	if not char then
	if callback then callback() end
	unpauseRagdollCounter()
	return
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then
	if callback then callback() end
	unpauseRagdollCounter()
	return
	end

	if FeatureToggles["Drop"] then
	FeatureToggles["Drop"]()
	local start = tick()
	while Player:GetAttribute("Stealing") and (tick() - start) < 5 do
	task.wait()
	end
	end

	if callback then
	callback()
	end
	unpauseRagdollCounter()
	else
	if callback then
	callback()
	end
	unpauseRagdollCounter()
	end
	end
	_G.__checkAndAutoDrop = checkAndAutoDrop
	end

	local v1Progress = 0

	local V2 = { busy = false, data = {} }

	do
	local LP = Player
	-- Do not block the entire hub on a map-specific folder.
	-- Some experiences (including maps other than Sab) do not have workspace.Plots.
	-- Use a harmless fallback now, then switch to the real folder if it appears later.
	local plots = workspace:FindFirstChild("Plots")
	if not plots then
		plots = Instance.new("Folder")
		plots.Name = "__SoundPlotsFallback"
		task.spawn(function()
			while not workspace:FindFirstChild("Plots") do
				task.wait(2)
			end
			local realPlots = workspace:FindFirstChild("Plots")
			if realPlots then
				plots = realPlots
			end
		end)
	end

	local AnimalsData = {}
	local syncRemotes = nil
	local plotAnimalSync = { caches = {}, connections = {} }
	local allAnimalsCache = {}
	local InternalStealCache = {}
	local stealConnection = nil
	local syncStarted = false
	local syncLoopStarted = false
	local _stealDetectConns = {}
	local _stealDetectTimer = nil
	local autoStealGeneration = 0

	local CONFIG_AUTO_STEAL = {
	AUTO_STEAL_ENABLED = false,
	HOLD_MIN = 1.3,
	HOLD_MAX = 2.6,
	ENTRY_DELAY = 0.01,
	COOLDOWN = 0.05,
	STEAL_RANGE = 6,
	PRIME_RANGE = math.clamp(tonumber(autoStealValues.Radius) or 65, 10, 150),
	}
	local stealPromptCache = setmetatable({}, { __mode = "k" })
	local function getCachedStealPrompt(spawn)
	if not spawn then return nil end
	local cached = stealPromptCache[spawn]
	if cached and cached.Parent and cached:IsA("ProximityPrompt") and cached.ActionText and cached.ActionText:find("Steal") then
	return cached
	end
	local promptAttachment = spawn:FindFirstChild("PromptAttachment")
	local candidates = promptAttachment and promptAttachment:GetChildren() or spawn:GetDescendants()
	for _, candidate in ipairs(candidates) do
	if candidate:IsA("ProximityPrompt") and candidate.ActionText and candidate.ActionText:find("Steal") then
	stealPromptCache[spawn] = candidate
	return candidate
	end
	end
	stealPromptCache[spawn] = nil
	return nil
	end

	local StealState = {
	active = false,
	startTime = 0,
	phase = "idle",
	label = "",
	lastResult = "",
	lastResultTime = 0,
	totalSteals = 0,
	failedSteals = 0,
	}

	local State = _G.__CrystalAutoStealState or { isStealing = false }
	_G.__CrystalAutoStealState = State

	local function setStealState(on)
	on = on == true
	if State.isStealing == on then return end
	State.isStealing = on
	end

	local function initializeAutoStealSync()
	if syncRemotes then return true end
	local ok = pcall(function()
	local Packages = ReplicatedStorage:WaitForChild("Packages", 10)
	local Datas = ReplicatedStorage:WaitForChild("Datas", 10)
	if not Packages or not Datas then return end
	AnimalsData = require(Datas:WaitForChild("Animals"))
	local folder = Packages:WaitForChild("Synchronizer")
	syncRemotes = {
	channelFolder = folder:WaitForChild("Channel"),
	routeRemote = folder:WaitForChild("CommunicationRoute"),
	requestData = folder:FindFirstChild("RequestData"),
	}
	end)
	return ok and syncRemotes ~= nil
	end

	local function splitSyncPath(path)
	if typeof(path) == "table" then return path end
	local out = {}
	for part in string.gmatch(tostring(path), "[^%.]+") do
	table.insert(out, tonumber(part) or part)
	end
	return out
	end

	local function resolveSyncPath(path, root)
	local current = root
	local parent = nil
	local key = nil
	for _, part in ipairs(splitSyncPath(path)) do
	parent = current
	key = part
	current = current and current[part] or nil
	end
	return current, parent, key
	end

	local function applyPlotSyncDiff(channelName, packet)
	local cache = plotAnimalSync.caches[channelName]
	if typeof(cache) ~= "table" then return end
	local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
	local current, parent, key = resolveSyncPath(path, cache)
	if action == "Changed" then
	if parent ~= nil then parent[key] = a end
	elseif action == "ArrayInsert" then
	if current ~= nil then table.insert(current, b, a) end
	elseif action == "ArrayRemoved" then
	if current ~= nil then table.remove(current, b) end
	elseif action == "DictionaryInsert" then
	if current ~= nil then current[b] = a end
	elseif action == "DictionaryRemoved" then
	if current ~= nil then current[b] = nil end
	end
	end

	local function attachPlotChannel(remote)
	if not syncRemotes or plotAnimalSync.connections[remote] then return end
	local channelName = tostring(remote.Name)
	if not plots:FindFirstChild(channelName) then return end
	if syncRemotes.requestData and plotAnimalSync.caches[channelName] == nil then
	local ok, data = pcall(function() return syncRemotes.requestData:InvokeServer(channelName) end)
	plotAnimalSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
	elseif plotAnimalSync.caches[channelName] == nil then
	plotAnimalSync.caches[channelName] = {}
	end
	plotAnimalSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
	for _, packet in ipairs(queue) do applyPlotSyncDiff(channelName, packet) end
	end)
	end

	local function detachPlotChannel(channelName)
	for remote, conn in pairs(plotAnimalSync.connections) do
	if tostring(remote.Name) == tostring(channelName) then
	conn:Disconnect()
	plotAnimalSync.connections[remote] = nil
	plotAnimalSync.caches[tostring(channelName)] = nil
	break
	end
	end
	end

	local function startAutoStealSync()
	if syncStarted then return true end
	if not initializeAutoStealSync() then return false end
	if not syncRemotes or not syncRemotes.channelFolder then return false end
	for _, child in ipairs(syncRemotes.channelFolder:GetChildren()) do
	if child:IsA("RemoteEvent") then attachPlotChannel(child) end
	end
	syncRemotes.channelFolder.ChildAdded:Connect(function(child)
	if child:IsA("RemoteEvent") then attachPlotChannel(child) end
	end)
	syncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
	for _, action in ipairs(actions) do
	local kind, channelName = action[1], tostring(action[2])
	if plots:FindFirstChild(channelName) then
	if kind == "ListenerAdded" then
	local remote = syncRemotes.channelFolder:FindFirstChild(channelName)
	if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote) end
	elseif kind == "ListenerRemoved" then
	detachPlotChannel(channelName)
	end
	end
	end
	end)
	syncStarted = true
	return true
	end

	local function getPlotChannelData(plotName)
	return plotAnimalSync.caches[plotName]
	end

	local function getAnimalPosition(animalData)
	local plot = plots:FindFirstChild(animalData.plot)
	local podiums = plot and plot:FindFirstChild("AnimalPodiums")
	local podium = podiums and podiums:FindFirstChild(animalData.slot)
	return podium and podium:GetPivot().Position
	end

	local function distToAnimal(animalData)
	local character = Player.Character
	local hrp = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso"))
	if not hrp then return math.huge end
	local pos = getAnimalPosition(animalData)
	if not pos then return math.huge end
	return (hrp.Position - pos).Magnitude
	end

	local function scanAllPlots()
	if not plots then return {} end
	local newCache = {}
	for _, plot in ipairs(plots:GetChildren()) do
	local cache = getPlotChannelData(plot.Name)
	local animalList = cache and cache.AnimalList
	if typeof(animalList) == "table" then
	for slot, animalData in pairs(animalList) do
	if type(animalData) == "table" then
	local animalName = animalData.Index
	local animalInfo = AnimalsData[animalName]
	if animalInfo then
	table.insert(newCache, {
	name = animalInfo.DisplayName or animalName,
	plot = plot.Name,
	slot = tostring(slot),
	uid = plot.Name .. "_" .. tostring(slot),
	})
	end
	end
	end
	end
	end
	allAnimalsCache = newCache
	return #allAnimalsCache
	end

	local function buildStealCallbacks(prompt)
	if InternalStealCache[prompt] then return end
	local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
	local ok1, conns1 = false, nil
	if getconnections then ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan) end
	if ok1 and type(conns1) == "table" then
	for _, conn in ipairs(conns1) do
	if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end
	end
	end
	local ok2, conns2 = false, nil
	if getconnections then ok2, conns2 = pcall(getconnections, prompt.Triggered) end
	if ok2 and type(conns2) == "table" then
	for _, conn in ipairs(conns2) do
	if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end
	end
	end
	if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then
	InternalStealCache[prompt] = data
	end
	end

	local function executeStealAsync(prompt, animalData)
	local data = InternalStealCache[prompt]
	if not data or not data.ready then return false end
	data.ready = false
	local label = animalData and animalData.name or "Animal"
	StealState.active = true
	StealState.startTime = tick()
	StealState.phase = "holding"
	StealState.label = label
	setStealState(false)
	v1Progress = 0
	local runGeneration = autoStealGeneration
	task.spawn(function()
	CONFIG_AUTO_STEAL.HOLD_MIN = autoStealValues.Duration or CONFIG_AUTO_STEAL.HOLD_MIN
	CONFIG_AUTO_STEAL.HOLD_MAX = CONFIG_AUTO_STEAL.HOLD_MIN + 1.3
	for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
	while tick() - StealState.startTime < CONFIG_AUTO_STEAL.HOLD_MIN do
	if runGeneration ~= autoStealGeneration then data.ready = true; return end
	if not CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED or not prompt.Parent then break end
	local elapsed = tick() - StealState.startTime
	v1Progress = math.clamp(elapsed / CONFIG_AUTO_STEAL.HOLD_MAX, 0, 1)

	task.wait(0.05)
	end
	StealState.phase = "waitingRange"
	local alreadyInRange = animalData and distToAnimal(animalData) <= CONFIG_AUTO_STEAL.STEAL_RANGE
	local fired = false
	while runGeneration == autoStealGeneration and CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED and prompt.Parent do
	local elapsed = tick() - StealState.startTime
	v1Progress = math.clamp(elapsed / CONFIG_AUTO_STEAL.HOLD_MAX, 0, 1)
	if elapsed > CONFIG_AUTO_STEAL.HOLD_MAX then break end
	if animalData and distToAnimal(animalData) <= CONFIG_AUTO_STEAL.STEAL_RANGE then
	if not alreadyInRange then task.wait(CONFIG_AUTO_STEAL.ENTRY_DELAY) end
	for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
	fired = true
	break
	end
	task.wait(0.05)
	end
	if runGeneration ~= autoStealGeneration then data.ready = true; return end
	if fired then
	StealState.totalSteals = StealState.totalSteals + 1
	StealState.lastResult = "Stole " .. label
	StealState.phase = "success"
	setStealState(true)
	else
	StealState.failedSteals = StealState.failedSteals + 1
	StealState.lastResult = "Missed window: " .. label
	StealState.phase = "failed"
	end
	StealState.active = false
	StealState.lastResultTime = tick()
	v1Progress = 1
	task.wait(CONFIG_AUTO_STEAL.COOLDOWN)
	v1Progress = 0
	data.ready = true
	end)
	return true
	end

	local function attemptSteal(prompt, animalData)
	if not prompt or not prompt.Parent then return false end
	buildStealCallbacks(prompt)
	return executeStealAsync(prompt, animalData)
	end

                local V3New = {
                    busy = false,
                    active = false,
                    progress = 0,
                    isStealing = false,
                    currentTarget = nil,
                    totalSteals = 0,
                    failedSteals = 0,
                    lastResult = "",
                    generation = 0,
                    phase = "idle",
                    startTime = 0,
                    data = {}
                }

                local V3Config = {
                    RADIUS = 65,
					HOLD_MIN = 1.3,
					HOLD_MAX = 2.6,
					NEAR_TARGET_RANGE = 20,
					ENTRY_DELAY = 0.3,
					FIRE_RANGE = 12,
                    COOLDOWN = 0.45,
                }
					local v3TargetCache = { prompt = nil, radius = 0, expiresAt = 0 }

                local function v3NewFindNearestPrompt(searchRadius)
					local radius = math.max(0, tonumber(searchRadius) or V3Config.RADIUS)
					if v3TargetCache.expiresAt > tick()
					and v3TargetCache.radius == radius
					and v3TargetCache.prompt
					and v3TargetCache.prompt.Parent then
					return v3TargetCache.prompt
					end
                    local char = Player.Character
                    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
                    if not root then return nil end

					local nearest, nearestDistSq = nil, math.huge
					local radiusSq = radius * radius

                    for _, plot in ipairs(plots:GetChildren()) do
                        local sign = plot:FindFirstChild("PlotSign")
                        local yourBase = sign and sign:FindFirstChild("YourBase")
                        if plot:IsA("Model") and not (yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled) then
                            local pods = plot:FindFirstChild("AnimalPodiums")
                            if pods then
                                for _, pod in ipairs(pods:GetChildren()) do
                                    local spawn = pod:FindFirstChild("Base") and pod.Base:FindFirstChild("Spawn")
                                    if spawn then
									local delta = spawn.Position - root.Position
									local distanceSq = delta:Dot(delta)
									if distanceSq <= radiusSq and distanceSq < nearestDistSq then
										local prompt = getCachedStealPrompt(spawn)
										if prompt then nearest, nearestDistSq = prompt, distanceSq end
                                        end
                                    end
                                end
                            end
                        end
                    end
					v3TargetCache.prompt = nearest
					v3TargetCache.radius = radius
					v3TargetCache.expiresAt = tick() + 0.12
                    return nearest
                end

                _G.__CrystalAutoGrabTargetInRadius = function(radius)
                    return v3NewFindNearestPrompt(radius or 65) ~= nil
                end

                local function v3NewGetPromptDistance(prompt)
                    local char = Player.Character
                    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
                    if not root then return math.huge end

                    local part = prompt.Parent
                    if part and part:IsA("Attachment") then part = part.Parent end
                    if part and part:IsA("BasePart") then
                        return (part.Position - root.Position).Magnitude
                    end

                    local ok, pos = pcall(function() return prompt.Parent and prompt.Parent.WorldPosition end)
                    if ok and pos then
                        return (pos - root.Position).Magnitude
                    end
                    return math.huge
                end

				local function v3NewGetPromptCallbacks(prompt)
                    local data = V3New.data[prompt]
                    if data then return data end

                    data = { hold = {}, trigger = {}, ready = true }

                    if getconnections then
                        for _, conn in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                            if conn.Function then
                                table.insert(data.hold, conn.Function)
                            end
                        end
                        for _, conn in ipairs(getconnections(prompt.Triggered)) do
                            if conn.Function then
                                table.insert(data.trigger, conn.Function)
                            end
                        end
                    end

                    V3New.data[prompt] = data
					return data
				end

				local function v3NewTriggerPrompt(prompt, data)
					if not prompt or not prompt.Parent then return false end
					if Player:GetAttribute("Stealing") == true then return false end
					local invoked = false
					for _, callback in ipairs(data.trigger) do
						local ok = pcall(callback)
						if ok then invoked = true end
					end

					if not invoked and Player:GetAttribute("Stealing") ~= true and typeof(fireproximityprompt) == "function" then
						local ok = pcall(fireproximityprompt, prompt)
						invoked = ok or invoked
					end
					if not invoked and Player:GetAttribute("Stealing") ~= true then
						local ok = pcall(function()
							prompt:InputHoldBegin()
							task.wait(0.05)
							prompt:InputHoldEnd()
						end)
						invoked = ok
					end
					return invoked
				end

				local function v3NewExecuteSteal(prompt)
					if V3New.busy or not prompt or not prompt.Parent then return end
					if Player:GetAttribute("Stealing") == true then return end

					local data = v3NewGetPromptCallbacks(prompt)
					if #data.trigger == 0 then
						V3New.data[prompt] = nil
						data = v3NewGetPromptCallbacks(prompt)
					end
                    if not data.ready then return end

                    data.ready = false
                    V3New.busy = true
                    V3New.active = true
                    V3New.isStealing = true
                    V3New.startTime = tick()
                    V3New.progress = 0
                    V3New.phase = "holding"
                    V3New.generation = V3New.generation + 1
                    local runGen = V3New.generation

                    setStealState(true)

                    task.spawn(function()

                        for _, callback in ipairs(data.hold) do
                            task.spawn(callback)
                        end

                        local holdStart = tick()

                        while V3New.busy and tick() - holdStart < V3Config.HOLD_MIN do
                            if runGen ~= V3New.generation then return end
                            V3New.progress = math.clamp((tick() - holdStart) / V3Config.HOLD_MIN, 0, 1)
                            v1Progress = V3New.progress

							task.wait(0.05)
                        end

                        if runGen ~= V3New.generation then return end

                        V3New.progress = 1
                        v1Progress = 1
                        V3New.phase = "waiting"

						local wasInRange = v3NewGetPromptDistance(prompt) <= V3Config.FIRE_RANGE
                        local fired = false

						while runGen == V3New.generation and
							prompt.Parent and
							CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED and Player:GetAttribute("Stealing") ~= true do

                            V3New.progress = 1
                            v1Progress = 1

							local promptDistance = v3NewGetPromptDistance(prompt)
							if promptDistance > V3Config.NEAR_TARGET_RANGE and tick() - holdStart > V3Config.HOLD_MAX then
								break
							end

							if promptDistance <= V3Config.FIRE_RANGE then
								if not wasInRange then
									task.wait(V3Config.ENTRY_DELAY)
									if runGen ~= V3New.generation or not prompt.Parent
									or v3NewGetPromptDistance(prompt) > V3Config.FIRE_RANGE then
										task.wait(0.05)
										continue
									end
								end

                                V3New.phase = "triggering"

								local didTrigger = v3NewTriggerPrompt(prompt, data)
								if not didTrigger then
									V3New.phase = "waiting"
									task.wait(0.05)
									continue
								end

                                V3New.totalSteals = V3New.totalSteals + 1
                                StealState.totalSteals = StealState.totalSteals + 1
                                V3New.lastResult = "✅ ROBADO!"
                                StealState.lastResult = "Stole"
                                fired = true
                                V3New.isStealing = true
                                V3New.phase = "success"
                                break
                            end

							task.wait(0.05)
                        end

                        if runGen ~= V3New.generation then return end

                        V3New.active = false
                        V3New.isStealing = false
                        V3New.busy = false
                        data.ready = true

                        setStealState(false)

                        if not fired then
                            V3New.failedSteals = V3New.failedSteals + 1
	                            V3New.lastResult = "❌ FAILED"
                            V3New.phase = "failed"
                        end

                        V3New.lastResultTime = tick()
                        StealState.lastResultTime = tick()

                        task.wait(V3Config.COOLDOWN)
                        if runGen ~= V3New.generation then return end
                        V3New.progress = 0
                        v1Progress = 0
                        V3New.phase = "idle"
                    end)
                end

	local V1DonorConfig = {
		HOLD_TIME = 1.33,
		POST_HOLD = 1.15,
		MAX_TOTAL_TIME = 2.99,
		AVERAGE_TRIGGER_DISTANCE = 6.8,
		TRYHARD_TRIGGER_DISTANCE = 7.1,
		EXTRA_DELAY = 0,
		COOLDOWN = 0.05,
	}

	local function getV1DonorTriggerDistance()
		return (_G.__CrystalAutoStealDelayPreference == "Tryhard")
			and V1DonorConfig.TRYHARD_TRIGGER_DISTANCE
			or V1DonorConfig.AVERAGE_TRIGGER_DISTANCE
	end

	local function v1DonorExecuteSteal(prompt)
		if V3New.busy or not prompt or not prompt.Parent then return false end
		if Player:GetAttribute("Stealing") == true then return false end

		local data = v3NewGetPromptCallbacks(prompt)
		if #data.trigger == 0 then
			V3New.data[prompt] = nil
			data = v3NewGetPromptCallbacks(prompt)
		end
		if not data.ready then return false end

		data.ready = false
		V3New.busy = true
		V3New.active = true
		V3New.isStealing = true
		V3New.currentTarget = prompt
		V3New.startTime = tick()
		V3New.progress = 0
		V3New.phase = "holding"
		V3New.generation = V3New.generation + 1
		local runGen = V3New.generation
		StealState.active = true
		StealState.startTime = V3New.startTime
		StealState.phase = "holding"
		StealState.label = ""
		v1Progress = 0
		setStealState(true)

		task.spawn(function()
			for _, callback in ipairs(data.hold) do task.spawn(callback) end
			local holdStart = tick()
			local stillRunning = function()
				return runGen == V3New.generation
					and CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED
					and prompt.Parent ~= nil
					and Player:GetAttribute("Stealing") ~= true
			end

			while stillRunning() and tick() - holdStart < V1DonorConfig.POST_HOLD do
				local elapsed = tick() - holdStart
				V3New.progress = math.clamp(elapsed / V1DonorConfig.HOLD_TIME, 0, 1)
				v1Progress = V3New.progress
				StealState.label = math.floor(V3New.progress * 100) .. "%"
				if v3NewGetPromptDistance(prompt) > (tonumber(autoStealValues.Radius) or 65) then break end
				task.wait()
			end

			local maxWait = math.max(
				V1DonorConfig.MAX_TOTAL_TIME
					- V1DonorConfig.POST_HOLD
					- math.max(V1DonorConfig.HOLD_TIME - V1DonorConfig.POST_HOLD, 0),
				0.05
			)
			local waitStart = tick()
			local triggerDistance = getV1DonorTriggerDistance()
			while stillRunning() and tick() - waitStart < maxWait do
				local distance = v3NewGetPromptDistance(prompt)
				if distance <= triggerDistance then break end
				if distance > (tonumber(autoStealValues.Radius) or 65) then break end
				task.wait()
			end

			if V1DonorConfig.EXTRA_DELAY > 0 and stillRunning() then
				task.wait(V1DonorConfig.EXTRA_DELAY)
			end

			local fired = false
			if stillRunning() then
				local finishStart = tick()
				local remain = math.max(V1DonorConfig.HOLD_TIME - V1DonorConfig.POST_HOLD, 0.05)
				while stillRunning() do
					local finish = math.clamp((tick() - finishStart) / remain, 0, 1)
					local progress = math.clamp(V1DonorConfig.POST_HOLD / V1DonorConfig.HOLD_TIME, 0, 1)
						+ finish * (1 - math.clamp(V1DonorConfig.POST_HOLD / V1DonorConfig.HOLD_TIME, 0, 1))
					V3New.progress = progress
					v1Progress = progress
					StealState.label = math.floor(progress * 100) .. "%"
					if finish >= 1 then break end
					task.wait()
				end
				if stillRunning() then
					V3New.phase = "triggering"
					StealState.phase = "triggering"
					fired = v3NewTriggerPrompt(prompt, data)
				end
			end

			if runGen ~= V3New.generation then return end
			V3New.active = false
			V3New.isStealing = false
			V3New.busy = false
			V3New.currentTarget = nil
			data.ready = true
			StealState.active = false
			StealState.lastResultTime = tick()
			setStealState(false)
			if fired then
				V3New.totalSteals = V3New.totalSteals + 1
				V3New.lastResult = "Stole"
				V3New.phase = "success"
				StealState.totalSteals = StealState.totalSteals + 1
				StealState.lastResult = "Stole"
			else
				V3New.failedSteals = V3New.failedSteals + 1
				V3New.lastResult = "Missed window"
				V3New.phase = "failed"
				StealState.failedSteals = StealState.failedSteals + 1
				StealState.lastResult = "Missed window"
			end
			StealState.phase = V3New.phase
			StealState.lastResultTime = tick()
			task.wait(V1DonorConfig.COOLDOWN)
			if runGen == V3New.generation then
				V3New.progress = 0
				v1Progress = 0
				V3New.phase = "idle"
				StealState.label = ""
			end
		end)
		return true
	end


	local function _startStealHeartbeat()
	if stealConnection then return end
	local elapsed = 0
	stealConnection = RunService.Heartbeat:Connect((function(dt)
	elapsed = elapsed + (dt or 0)
	local scanInterval = 0.15
	if elapsed < scanInterval then return end
	elapsed = 0
	if not CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED then return end
	if Player:GetAttribute("Stealing") == true then return end
	if _G.__CrystalAutoGrabRagdollBlocked == true then return end
	if StealState.active or V2.busy or V3New.busy then return end
	if autoStealMode == "v2" then
		-- V2 uses Kyz Duels V3 logic (handled by separate heartbeat)
		return
	end
	if autoStealMode == "v1" then
	local prompt = v3NewFindNearestPrompt(autoStealValues.Radius)
	if prompt then v1DonorExecuteSteal(prompt) end
	return
	end
	end))
	end

	_G.CrystalAutoStealRunCycle = function(prompt, target)
	return v1DonorExecuteSteal(prompt)
	end

	local function stopStealDetection()
	if _stealDetectConns then for _, c in ipairs(_stealDetectConns) do pcall(function() c:Disconnect() end) end end
	_stealDetectConns = {}
	if _stealDetectTimer then task.cancel(_stealDetectTimer); _stealDetectTimer = nil end
	end

	local startStealDetection = (function(char)
	stopStealDetection()
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	table.insert(_stealDetectConns, hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
	setStealState(hum.WalkSpeed < 22)
	end))
	local function watchPrompt(obj)
	if not obj:IsA("ProximityPrompt") then return end
	table.insert(_stealDetectConns, obj.PromptButtonHoldBegan:Connect(function(player)
	if player ~= LP then return end
	setStealState(true)
	if _stealDetectTimer then task.cancel(_stealDetectTimer) end
	_stealDetectTimer = task.delay(CONFIG_AUTO_STEAL.HOLD_MAX + 0.5, function()
	setStealState(false)
	end)
	end))
	table.insert(_stealDetectConns, obj.Triggered:Connect(function(player)
	if player ~= LP then return end
	task.delay(0.2, function() setStealState(false) end)
	end))
	end

	table.insert(_stealDetectConns, workspace.DescendantAdded:Connect(function(obj)
	task.defer(watchPrompt, obj)
	end))
	_G.__CrystalWalkDescendantsBatched(plots, watchPrompt, function()
	return char.Parent ~= nil
	end)
	end)

	local function ensureSyncLoop()
	if syncLoopStarted then return end
	syncLoopStarted = true
	task.spawn(function()
	if startAutoStealSync() then
	if CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED then scanAllPlots() end
	while crystalRuntimeState.alive do
	task.wait(5)
	if not crystalRuntimeState.alive then break end
	if CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED then scanAllPlots() end
	end
	end
	end)
	end

	ensureSyncLoop()
	if Player.Character then task.defer(startStealDetection, Player.Character) end
	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	startStealDetection(char)
	if toggleStates["auto steal"] then
	CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED = false
	if stealConnection then stealConnection:Disconnect(); stealConnection = nil end
	CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED = true
	scanAllPlots()
	_startStealHeartbeat()
	end
	end))

	_G.CrystalAutoGrab = {
	GetMode = function() return autoStealMode end,
	SetMode = function(mode)
	if mode ~= "v1" then return false end
	autoStealMode = mode
	saveConfig()
	return true
	end,
	}

	local function enableAutoSteal()
	ensureSyncLoop()
	scanAllPlots()
	CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED = true
	if autoStealMode == "v2" then
		if _G.__KyzV3AutoStealStart then _G.__KyzV3AutoStealStart() end
	else
		_startStealHeartbeat()
	end
	end

	local function disableAutoSteal()
	autoStealGeneration = autoStealGeneration + 1
	if stealConnection then stealConnection:Disconnect(); stealConnection = nil end
	CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED = false
	if _G.__KyzV3AutoStealStop then _G.__KyzV3AutoStealStop() end
	StealState.active = false
	StealState.phase = "idle"
	setStealState(false)
	v1Progress = 0
	InternalStealCache = {}
	V2.busy = false
	V2.data = {}
	if V3New then
	V3New.generation = V3New.generation + 1
	V3New.busy = false
	V3New.active = false
	V3New.isStealing = false
	V3New.progress = 0
	V3New.phase = "idle"
	V3New.data = {}
	end
	end

	autoStealDisableInternal = disableAutoSteal
	_G.__CrystalTrackConn(Player.CharacterRemoving:Connect(disableAutoSteal))
	_G.__CrystalTrackStopper(disableAutoSteal)

	;(function()
	local restartSerial = 0
	local humanoidStateConnection = nil
	local platformStandConnection = nil
	local stoneSignalConnection = nil
	local ragdollLatched = false
	local ragdollResumeScheduled = false
	local stoneDetectedUntil = 0
	local RAGDOLL_DURATION = 3.0
	local RAGDOLL_REMAINING_BEFORE_GRAB = 2.0
	local STONE_MEMORY_DURATION = 5.0

	local function isRagdollState(hum, state)
	return hum.PlatformStand
	or state == Enum.HumanoidStateType.Physics
	or state == Enum.HumanoidStateType.Ragdoll
	or state == Enum.HumanoidStateType.FallingDown
	end

	local function hasPetrificationSignal(char)
	if not char then return false end
	for _, obj in ipairs(char:GetDescendants()) do
	if not obj:FindFirstAncestorOfClass("Tool") then
	local name = obj.Name:lower()
	if name:find("medusa") or name:find("petrif") or name:find("gorgon") or name:find("stone") then
	return true
	end
	for attributeName, value in pairs(obj:GetAttributes()) do
	local key = tostring(attributeName):lower()
	if value and (key:find("medusa") or key:find("petrif") or key:find("gorgon") or key:find("stone")) then
	return true
	end
	end
	end
	end
	return false
	end

	local function restartAfterRagdoll(_cameFromStone)
	restartSerial = restartSerial + 1
	local thisRestart = restartSerial
	_G.__CrystalAutoGrabRagdollBlocked = true
	ragdollResumeScheduled = true
	disableAutoSteal()

	task.delay(math.max(0, RAGDOLL_DURATION - RAGDOLL_REMAINING_BEFORE_GRAB), function()
	if thisRestart ~= restartSerial then return end
	ragdollResumeScheduled = false
	if not toggleStates["auto steal"] then return end
	_G.__CrystalAutoGrabRagdollBlocked = false
	if not CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED then enableAutoSteal() end
	end)
	end

	local function bindRagdollRestart(char)
	if humanoidStateConnection then
	humanoidStateConnection:Disconnect()
	humanoidStateConnection = nil
	end
	if platformStandConnection then
	platformStandConnection:Disconnect()
	platformStandConnection = nil
	end
	if stoneSignalConnection then
	stoneSignalConnection:Disconnect()
	stoneSignalConnection = nil
	end
	ragdollLatched = false
	stoneDetectedUntil = 0
	local hum = char and (char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5))
	if not hum then return end
	if hasPetrificationSignal(char) then
	stoneDetectedUntil = tick() + STONE_MEMORY_DURATION
	end
	stoneSignalConnection = char.DescendantAdded:Connect(function(obj)
	if obj:FindFirstAncestorOfClass("Tool") then return end
	local name = obj.Name:lower()
	if name:find("medusa") or name:find("petrif") or name:find("gorgon") or name:find("stone") then
	stoneDetectedUntil = tick() + STONE_MEMORY_DURATION
	end
	end)
	local function updateRagdollState(state)
	if hasPetrificationSignal(char) then
	stoneDetectedUntil = tick() + STONE_MEMORY_DURATION
	end
	local ragdolled = isRagdollState(hum, state)
	if ragdolled and not ragdollLatched then
	ragdollLatched = true
	restartAfterRagdoll(tick() <= stoneDetectedUntil)
	elseif not ragdolled then
	ragdollLatched = false

	if not ragdollResumeScheduled then
	_G.__CrystalAutoGrabRagdollBlocked = false
	if toggleStates["auto steal"] and not CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED then
		enableAutoSteal()
	end
	end
	end
	end
	humanoidStateConnection = hum.StateChanged:Connect(function(_, state)
	updateRagdollState(state)
	end)
	platformStandConnection = hum:GetPropertyChangedSignal("PlatformStand"):Connect(function()
	updateRagdollState(hum:GetState())
	end)
	end

	if Player.Character then task.defer(bindRagdollRestart, Player.Character) end
	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(char)
	restartSerial = restartSerial + 1
	ragdollResumeScheduled = false
	_G.__CrystalAutoGrabRagdollBlocked = false
	bindRagdollRestart(char)
	end))
	end)()

	FeaturePostToggle["auto steal"] = function(active)
	if active then
	if _G.__CrystalAutoGrabRagdollBlocked ~= true then enableAutoSteal() end
	else
	disableAutoSteal()
	end
	end

	if toggleStates["auto steal"] then enableAutoSteal() end
	end

	do

	do
	local function setFeatureState(featureName, state)
	if toggleStates[featureName] == state then return end
	-- Avatar skin systems are exclusive: enabling Sound Skin disables custom skin packs,
	-- and enabling a custom skin pack disables Sound Skin.
	if state == true and featureName == "Sound Skin" and toggleStates["Violette Custom Skins"] then
		toggleStates["Violette Custom Skins"] = false
		if FeaturePostToggle["Violette Custom Skins"] then pcall(FeaturePostToggle["Violette Custom Skins"], false) end
		if toggleVisualUpdaters["Violette Custom Skins"] then pcall(toggleVisualUpdaters["Violette Custom Skins"]) end
	elseif state == true and featureName == "Violette Custom Skins" and toggleStates["Sound Skin"] then
		toggleStates["Sound Skin"] = false
		if FeaturePostToggle["Sound Skin"] then pcall(FeaturePostToggle["Sound Skin"], false) end
		if toggleVisualUpdaters["Sound Skin"] then pcall(toggleVisualUpdaters["Sound Skin"]) end
	end
	toggleStates[featureName] = state

	if FeaturePostToggle[featureName] then
	FeaturePostToggle[featureName](state)
	end
	if toggleVisualUpdaters[featureName] then
	toggleVisualUpdaters[featureName]()
	end
	saveConfig()
	end

	local function disableBoth()
	setFeatureState("Autoplay", false)
	end

	local function showStealCountdown(char)
	if not char then return end

	local nowT = os.clock()
	if _G._CrystalHitCountdownLast and (nowT - _G._CrystalHitCountdownLast) < 0.15 then return end
	_G._CrystalHitCountdownLast = nowT

	local gen = (_G._CrystalHitCountdownGen or 0) + 1
	_G._CrystalHitCountdownGen = gen
	_G._CrystalHitCountdownActive = true
	if _G._CrystalHitCountdownBB then
	pcall(function() _G._CrystalHitCountdownBB:Destroy() end)
	_G._CrystalHitCountdownBB = nil
	end

	pcall(function() _G._CrystalShowStealCountdown = showStealCountdown end)
	local root = char:FindFirstChild("LowerTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
	if not root then _G._CrystalHitCountdownActive = false; return end
	local bb = Instance.new("BillboardGui")
	bb.Name = "CrystalHitCountdown"
	bb.Adornee = root
	bb.Size = UDim2.new(0, 120, 0, 56)
	bb.StudsOffset = Vector3.new(0, 0.6, 0)
	bb.AlwaysOnTop = true
	bb.LightInfluence = 0
	local parentGui = Player and (Player:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")) or game:GetService("CoreGui")
	bb.Parent = parentGui
	_G._CrystalHitCountdownBB = bb

	local frame = Instance.new("Frame", bb)
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.Position = UDim2.new(0, 0, 0, 6)
	label.BackgroundTransparency = 1
	label.Text = "3"
	label.TextScaled = false
	label.TextSize = 28
	label.Font = Enum.Font.GothamBlack
	label.TextColor3 = Color3.fromRGB(175, 180, 185)
	label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	label.TextStrokeTransparency = 0
	label.ZIndex = 10
	label.TextTransparency = 1

	local function animateText(txt, color)
	label.Text = txt
	if color then label.TextColor3 = color end
	local hold = (txt == "STEAL!") and 1.0 or 0.76

	for i = 0, 6 do
	label.TextTransparency = 1 - (i / 6)
	task.wait(0.02)
	if _G._CrystalHitCountdownGen ~= gen then return false end
	end
	task.wait(hold)
	if _G._CrystalHitCountdownGen ~= gen then return false end

	for i = 0, 6 do
	label.TextTransparency = i / 6
	task.wait(0.02)
	if _G._CrystalHitCountdownGen ~= gen then return false end
	end
	return true
	end

	task.spawn(function()
	pcall(function()
	label.TextStrokeTransparency = 0
	label.TextColor3 = Color3.fromRGB(175, 180, 185)
	for step = 0, 24 do
	local value = 2.4 - (2.4 * step / 24)
	local display = value <= 0.05 and "0" or string.format("%.1f", value)
	label.Text = display
	label.TextTransparency = 0
	for i = 0, 2 do
	label.TextTransparency = 0.18 * i
	task.wait(0.02)
	if _G._CrystalHitCountdownGen ~= gen then return end
	end
	if _G._CrystalHitCountdownGen ~= gen then return end
	task.wait(0.08)
	if _G._CrystalHitCountdownGen ~= gen then return end
	end
	if not animateText("STEAL!", Color3.fromRGB(175, 180, 185)) then return end
	end)

	if _G._CrystalHitCountdownGen == gen then
	pcall(function() bb:Destroy() end)
	if _G._CrystalHitCountdownBB == bb then _G._CrystalHitCountdownBB = nil end
	_G._CrystalHitCountdownActive = false
	-- If Auto Play was turned on during countdown, start it NOW (Semi/Full as selected)
	local shouldStart = (_G.__CrystalPendingAutoplayAfterCountdown == true) or (toggleStates["Autoplay"] == true)
	_G.__CrystalPendingAutoplayAfterCountdown = false
	if shouldStart and toggleStates["Autoplay"] == true then
	task.defer(function()
	if toggleStates["Autoplay"] ~= true then return end
	if Player:GetAttribute("Stealing") == true then return end
	pcall(function()
	if type(_G.__CrystalStartAutoplay) == "function" then
	_G.__CrystalStartAutoplay()
	elseif FeaturePostToggle and type(FeaturePostToggle["Autoplay"]) == "function" then
	-- Active already false; force start path
	FeaturePostToggle["Autoplay"](true)
	end
	end)
	end)
	end
	end
	end)
	end

	local function attachDamageDetection(char)
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local lastHealth = hum.Health

	hum.HealthChanged:Connect(function(newHealth)
	if newHealth < lastHealth then
	disableBoth()
	pcall(function() showStealCountdown(char) end)
	end
	lastHealth = newHealth
	end)

	if hum.StateChanged then
	hum.StateChanged:Connect(function(oldState, newState)
	local isRagdolled = (newState == Enum.HumanoidStateType.Physics or newState == Enum.HumanoidStateType.Ragdoll or newState == Enum.HumanoidStateType.FallingDown)
	if isRagdolled then
	pcall(function() showStealCountdown(char) end)
	end
	end)
	end

	pcall(function()
	hum:GetPropertyChangedSignal("PlatformStand"):Connect(function()
	if hum.PlatformStand then pcall(function() showStealCountdown(char) end) end
	end)
	end)

	hum.Died:Connect(function()
	disableBoth()
	end)

	end

	if Player.Character then
	attachDamageDetection(Player.Character)
	end

	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(char)
	local hum = char:WaitForChild("Humanoid", 5)
	if hum then
	disableBoth()
	attachDamageDetection(char)
	else
	task.wait(0.5)
	disableBoth()
	attachDamageDetection(char)
	end
	end))
	end

	do
	local unwalkState = {
		generation = 0,
		animationConn = nil,
		animate = nil,
		disabledByUs = false,
	}

	local function disconnectUnwalk()
		unwalkState.generation += 1
		if unwalkState.animationConn then
			unwalkState.animationConn:Disconnect()
			unwalkState.animationConn = nil
		end
	end

	local function resumeAnimations(force)
		local animate = unwalkState.animate
		local shouldEnable = unwalkState.disabledByUs
		unwalkState.animate = nil
		unwalkState.disabledByUs = false
		if animate and animate.Parent and shouldEnable and (force or not toggleStates["Unwalk"]) then
			pcall(function() animate.Disabled = false end)
		end
	end

	local function applyUnwalk(character)
		local previousAnimate = unwalkState.animate
		local previouslyDisabledByUs = unwalkState.disabledByUs
		disconnectUnwalk()
		if not toggleStates["Unwalk"] or character ~= Player.Character then return end
		local generation = unwalkState.generation
		local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
		local animate = character:FindFirstChild("Animate") or character:WaitForChild("Animate", 5)
		if not humanoid or not animate or generation ~= unwalkState.generation or not toggleStates["Unwalk"] then return end
		unwalkState.animate = animate
		unwalkState.disabledByUs = (previousAnimate == animate and previouslyDisabledByUs)
			or (animate:IsA("LocalScript") and not animate.Disabled)
		if animate:IsA("LocalScript") then animate.Disabled = true end

		local function stopAllTracks()
			if generation ~= unwalkState.generation or not toggleStates["Unwalk"]
				or character ~= Player.Character or humanoid.Parent ~= character then return end
			for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
				pcall(function() track:Stop(0) end)
			end
		end

		unwalkState.animationConn = humanoid.AnimationPlayed:Connect(function(track)
			if generation ~= unwalkState.generation or not toggleStates["Unwalk"] then return end
			pcall(function() track:Stop(0) end)
		end)

		stopAllTracks()
	end

	FeaturePostToggle["Unwalk"] = function(active)
		if active then
			applyUnwalk(Player.Character)
		else
			disconnectUnwalk()
			resumeAnimations(false)
		end
	end
	_G.__CrystalTrackStopper(function()
		disconnectUnwalk()
		resumeAnimations(true)
	end)
	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(character)
		if not toggleStates["Unwalk"] then return end
		task.defer(function() applyUnwalk(character) end)
	end))
	if toggleStates["Unwalk"] then
		task.defer(function() applyUnwalk(Player.Character) end)
	end
	end


	do
	local counterConn  = nil
	local wasRagdolled = false

	local function getBat()
	local char = Player.Character
	if not char then return nil end
	local equipped = char:FindFirstChildOfClass("Tool")
	if equipped and equipped.Name:lower():find("bat") then return equipped end
	local bp = Player:FindFirstChild("Backpack")
	if bp then
	local hum = char:FindFirstChildOfClass("Humanoid")
	for _, t in ipairs(bp:GetChildren()) do
	if t:IsA("Tool") and t.Name:lower():find("bat") then
	if hum then pcall(function() hum:EquipTool(t) end) end
	return char:FindFirstChild(t.Name) or t
	end
	end
	end
	return nil
	end

	local function getClosest(hrp)
	local best, bestDist = nil, math.huge
	for _, p in ipairs(Players:GetPlayers()) do
	if p ~= Player and p.Character then
	local r = p.Character:FindFirstChild("HumanoidRootPart")
	local targetHumanoid = p.Character:FindFirstChildOfClass("Humanoid")
	if r and targetHumanoid and targetHumanoid.Health > 0 then
	local d = (hrp.Position - r.Position).Magnitude
	if d < bestDist then bestDist = d; best = r end
	end
	end
	end
	return best, bestDist
	end

	local function onRagdoll(hrp)
	if ragdollCounterPaused or not toggleStates["Ragdoll Counter"] then return end
	local char = Player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not char or not hum or not root or hum.Health <= 0 then return end
	local targetRoot, distance = getClosest(root)

	if targetRoot and distance <= 4 then
		local lookPosition = Vector3.new(targetRoot.Position.X, root.Position.Y, targetRoot.Position.Z)
		if (lookPosition - root.Position).Magnitude > 0.01 then
			pcall(function()
				hum.AutoRotate = false
				root.CFrame = CFrame.lookAt(root.Position, lookPosition)
			end)
		end
	end
	local bat = getBat()
	if bat then
	pcall(function() bat:Activate() end)
	local remote = bat:FindFirstChildWhichIsA("RemoteEvent", true)
	if remote then pcall(function() remote:FireServer() end) end
	end
	task.defer(function()
	if hum.Parent then hum.AutoRotate = true end
	end)
	end

	local function startRagdollCounter()
	if counterConn then return end
	local char = Player.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return end

	counterConn = {}

	do
	local ok, con = pcall(function()
	return hum.StateChanged:Connect(function(_, newState)
	if ragdollCounterPaused or not toggleStates["Ragdoll Counter"] then return end
	local isRag = (newState == Enum.HumanoidStateType.Physics or newState == Enum.HumanoidStateType.Ragdoll or newState == Enum.HumanoidStateType.FallingDown)
	if isRag and not wasRagdolled then wasRagdolled = true; pcall(function() onRagdoll(hrp) end)
	elseif not isRag and wasRagdolled then wasRagdolled = false end
	end)
	end)
	if ok and con then table.insert(counterConn, con) end
	end

	do
	local ok, con = pcall(function()
	return hum:GetPropertyChangedSignal("PlatformStand"):Connect(function()
	if ragdollCounterPaused or not toggleStates["Ragdoll Counter"] then return end
	if hum.PlatformStand and not wasRagdolled then
	wasRagdolled = true
	pcall(function() onRagdoll(hrp) end)
	elseif not hum.PlatformStand then
	wasRagdolled = false
	end
	end)
	end)
	if ok and con then table.insert(counterConn, con) end
	end
	end

	local function stopRagdollCounter()
	if counterConn then
	for _, c in ipairs(counterConn) do pcall(function() c:Disconnect() end) end
	counterConn = nil
	end
	wasRagdolled = false
	end

	FeaturePostToggle["Ragdoll Counter"] = function(active)
	if active then startRagdollCounter() else stopRagdollCounter() end
	end

	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function()
	task.wait(0.5); wasRagdolled = false
	if toggleStates["Ragdoll Counter"] then
	stopRagdollCounter()
	startRagdollCounter()
	end
	end))

	if toggleStates["Ragdoll Counter"] then startRagdollCounter() end
	end

	do

	local MEDUSA_COOLDOWN = 25
	local medusaDebounce = false
	local medusaLastUsed = 0
	_G.__CrystalIsMedusaHit = function() return medusaLastUsed > 0 and (tick() - medusaLastUsed) <= 4 end
	local medusaCounterEnabled = false
	local medusaConns = {}

	local function findMedusa()
	local char = Player.Character
	if not char then return nil end
	for _, t in ipairs(char:GetChildren()) do
	if t:IsA("Tool") and (t.Name:lower():find("medusa") or t.Name:lower():find("head") or t.Name:lower():find("stone")) then
	return t
	end
	end
	local bp = Player:FindFirstChild("Backpack")
	if bp then
	for _, t in ipairs(bp:GetChildren()) do
	if t:IsA("Tool") and (t.Name:lower():find("medusa") or t.Name:lower():find("head") or t.Name:lower():find("stone")) then
	return t
	end
	end
	end
	return nil
	end

	local function useMedusa()
	if not medusaCounterEnabled then return end
	if medusaDebounce then return end
	if tick() - medusaLastUsed < MEDUSA_COOLDOWN then return end
	local char = Player.Character
	if not char then return end
	medusaDebounce = true
	local med = findMedusa()
	if not med then
	medusaDebounce = false
	return
	end
	if med.Parent ~= char then
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then pcall(function() hum:EquipTool(med) end) end
	task.wait(0.05)
	end
	pcall(function() med:Activate() end)
	medusaLastUsed = tick()
	medusaDebounce = false
	end

	local function onAnchorChanged(part)
	return part:GetPropertyChangedSignal("Anchored"):Connect(function()
	if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then
	useMedusa()
	end
	end)
	end

	local function setupMedusa(char)
	for _, c in pairs(medusaConns) do
	pcall(function() c:Disconnect() end)
	end
	medusaConns = {}
	if not char then return end
	for _, part in ipairs(char:GetDescendants()) do
	if part:IsA("BasePart") then
	table.insert(medusaConns, onAnchorChanged(part))
	end
	end
	table.insert(medusaConns, char.DescendantAdded:Connect(function(part)
	if part:IsA("BasePart") then
	table.insert(medusaConns, onAnchorChanged(part))
	end
	end))
	end

	local function startMedusaCounter()
	medusaCounterEnabled = true
	if Player.Character then
	setupMedusa(Player.Character)
	end
	end

local function stopMedusaCounter()
	medusaCounterEnabled = false
	for _, c in pairs(medusaConns) do
	pcall(function() c:Disconnect() end)
	end
medusaConns = {}
end
_G.__CrystalTrackStopper(stopMedusaCounter)
FeaturePostToggle["Medusa Counter"] = function(active)
if active then startMedusaCounter() else stopMedusaCounter() end
end

local MEDUSA_RANGE_STUDS = 20
local medusaRangeCirclePart = nil
local medusaRangeCircleConn = nil
local function getMedusaRangeCircleColor()
	-- Prefer the currently applied panel accent, then fall back to the legacy theme provider.
	local accent = typeof(_G.__CrystalThemeAccent) == "Color3" and _G.__CrystalThemeAccent or nil
	if not accent and type(_G.__SoundAccentColor) == "function" then
		local ok, color = pcall(_G.__SoundAccentColor)
		if ok and typeof(color) == "Color3" then accent = color end
	end
	if not accent then accent = Color3.fromRGB(168, 85, 247) end
	return accent
end
local function stopMedusaRangeCircle()
	if medusaRangeCircleConn then
		pcall(function() medusaRangeCircleConn:Disconnect() end)
		medusaRangeCircleConn = nil
	end
	if medusaRangeCirclePart then
		pcall(function() medusaRangeCirclePart:Destroy() end)
		medusaRangeCirclePart = nil
	end
end
local function startMedusaRangeCircle()
	stopMedusaRangeCircle()
	local circle = Instance.new("Part")
	circle.Name = "SoundMedusaRangeCircle"
	circle.Shape = Enum.PartType.Cylinder
	circle.Anchored = true
	circle.CanCollide = false
	circle.CanTouch = false
	circle.CanQuery = false
	circle.CastShadow = false
	circle.Material = Enum.Material.Neon
	circle.Transparency = 0.23
	circle.Parent = workspace
	medusaRangeCirclePart = circle
	local function updateCircle()
		if not toggleStates["Medusa Range Circle"] then
			stopMedusaRangeCircle()
			return
		end
		local character = Player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if not root or not root.Parent or (humanoid and humanoid.Health <= 0) then
			circle.Transparency = 1
			return
		end
		local diameter = math.clamp(MEDUSA_RANGE_STUDS * 0.7, 6, 14)
		circle.Size = Vector3.new(0.05, diameter, diameter)
		circle.Color = getMedusaRangeCircleColor()
		circle.Transparency = 0.23
		local groundY = root.Position.Y - (humanoid and humanoid.HipHeight or 0) - root.Size.Y * 0.5 + 0.05
		circle.CFrame = CFrame.new(root.Position.X, groundY, root.Position.Z)
			* CFrame.Angles(0, tick() * 1.6, math.rad(90))
	end
	medusaRangeCircleConn = RunService.Heartbeat:Connect(updateCircle)
	updateCircle()
end
FeaturePostToggle["Medusa Range Circle"] = function(active)
	if active then startMedusaRangeCircle() else stopMedusaRangeCircle() end
end
_G.__CrystalTrackStopper(stopMedusaRangeCircle)
if toggleStates["Medusa Range Circle"] then startMedusaRangeCircle() end

	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(newChar)
	task.wait(0.5)
	if medusaCounterEnabled then
	setupMedusa(newChar)
	end
	end))

if toggleStates["Medusa Counter"] then
	startMedusaCounter()
	end
	end

	do
	local antiBatConnection = nil
	local antiBatEnabled = false
	local antiBatGeneration = 0
	local antiBatOscillation = 10000
	local antiBatOscillationDirection = 1
	local antiBatPhase = 0
	local antiBatLastBaseXZ = nil

	local function stopAntiBat()
		antiBatGeneration += 1
		antiBatEnabled = false
		_G.WaveAntiBatEnabled = false
		if antiBatConnection then
			pcall(function() antiBatConnection:Disconnect() end)
			antiBatConnection = nil
		end
		local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
		if root and antiBatLastBaseXZ then
			local velocity = root.AssemblyLinearVelocity
			root.AssemblyLinearVelocity = Vector3.new(antiBatLastBaseXZ.X, velocity.Y, antiBatLastBaseXZ.Z)
		end
		antiBatOscillation = 10000
		antiBatOscillationDirection = 1
		antiBatPhase = 0
		antiBatLastBaseXZ = nil
		_G._WaveAntiBatDesiredXZ = nil
		_G._WaveAntiBatSpiking = false
	end

	local function startAntiBat()
		stopAntiBat()
		antiBatEnabled = true
		_G.WaveAntiBatEnabled = true
		local generation = antiBatGeneration
		antiBatConnection = RunService.Heartbeat:Connect(function()
			if generation ~= antiBatGeneration or not antiBatEnabled
				or not toggleStates["Anti Bat"] or not _G.WaveAntiBatEnabled then return end
			local character = Player.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			if not root or not root.Parent then return end
			local baseVelocity = root.AssemblyLinearVelocity
			antiBatLastBaseXZ = Vector3.new(baseVelocity.X, 0, baseVelocity.Z)
			_G._WaveAntiBatDesiredXZ = antiBatLastBaseXZ
			antiBatOscillation += 50 * antiBatOscillationDirection
			if antiBatOscillation >= 20000 then
				antiBatOscillation = 20000
				antiBatOscillationDirection = -1
			elseif antiBatOscillation <= 10000 then
				antiBatOscillation = 10000
				antiBatOscillationDirection = 1
			end
			antiBatPhase += math.random() * 0.5
			local magnitude = antiBatOscillation + math.random(-5000, 5000)
			local vx = math.cos(antiBatPhase) * magnitude
			local vz = math.sin(antiBatPhase) * magnitude
			_G._WaveAntiBatSpiking = true
			root.AssemblyLinearVelocity = Vector3.new(vx, baseVelocity.Y, vz)
			RunService.RenderStepped:Wait()
			if generation == antiBatGeneration and root.Parent then
				local desired = _G._WaveAntiBatDesiredXZ
				if typeof(desired) == "Vector3" then
					root.AssemblyLinearVelocity = Vector3.new(desired.X, root.AssemblyLinearVelocity.Y, desired.Z)
				else
					root.AssemblyLinearVelocity = Vector3.new(antiBatLastBaseXZ.X, root.AssemblyLinearVelocity.Y, antiBatLastBaseXZ.Z)
				end
				_G._WaveAntiBatSpiking = false
			end
		end)
	end

	FeaturePostToggle["Anti Bat"] = function(active)
		if active then startAntiBat() else stopAntiBat() end
	end
	_G.__CrystalTrackStopper(stopAntiBat)
	if toggleStates["Anti Bat"] then startAntiBat() else stopAntiBat() end
	_G.__SoundAntiBatActive = function() return antiBatEnabled end
	end

	-- Ambitious-style Anti Void core: local safe-position rescue plus teleport-origin
	-- tracking for enemies. It intentionally does not import Ambitious ESP objects.
	do
		local MAP_BOUNDS = {MinX = -535.7, MaxX = -422.0, MinY = -7.9, MaxY = 115.0, MinZ = -72.0, MaxZ = 193.3}
		local WINDOW, TP_TOTAL, TP_DELTA_Y = 0.07, 150, 100
		local WALK_CLEAR, STEP_MAX = 15, 50
		local antiVoid = {
			enabled = false, conn = nil, sampleAccumulator = 0, rescueAccumulator = 0,
			players = setmetatable({}, {__mode = "k"}),
			lastSafePosition = nil, spawnOrigin = nil,
		}
		local function withinSafeBounds(position)
			return typeof(position) == "Vector3"
				and position.X >= MAP_BOUNDS.MinX and position.X <= MAP_BOUNDS.MaxX
				and position.Y >= MAP_BOUNDS.MinY and position.Y <= MAP_BOUNDS.MaxY
				and position.Z >= MAP_BOUNDS.MinZ and position.Z <= MAP_BOUNDS.MaxZ
			end
		local function newPlayerRecord(character)
			return {character = character, history = {}, isOut = false, ghostPosition = nil, ghostCFrame = nil, lastPosition = nil, walked = 0}
		end
		local function getRecord(player, character)
			local record = antiVoid.players[player]
			if not record or record.character ~= character then
				record = newPlayerRecord(character)
				antiVoid.players[player] = record
			end
			return record
		end
		local function getAntiVoidPosition(player, rawPosition)
			if not antiVoid.enabled or not player then return rawPosition, false end
			local record = antiVoid.players[player]
			if record and record.isOut and record.ghostPosition then return record.ghostPosition, true end
			return rawPosition, false
		end
		_G.__CrystalAntiVoidPositionForPlayer = getAntiVoidPosition
		local function updateLocalRescue(dt)
			antiVoid.rescueAccumulator += dt or 0
			if antiVoid.rescueAccumulator < 0.1 then return end
			antiVoid.rescueAccumulator = 0
			local character = Player.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if not root or not humanoid or humanoid.Health <= 0 then return end
			local position = root.Position
			if not antiVoid.spawnOrigin and withinSafeBounds(position) then antiVoid.spawnOrigin = position end
			if humanoid.FloorMaterial ~= Enum.Material.Air and withinSafeBounds(position) then
				antiVoid.lastSafePosition = position
			end
			if withinSafeBounds(position) then return end
			local destination = antiVoid.lastSafePosition or antiVoid.spawnOrigin
			if destination and withinSafeBounds(destination) then
				pcall(function()
					root.AssemblyLinearVelocity = Vector3.zero
					root.AssemblyAngularVelocity = Vector3.zero
					root.CFrame = CFrame.new(destination + Vector3.new(0, 3, 0))
				end)
			end
		end
		local function sampleOtherPlayers()
			local now = os.clock()
			for _, otherPlayer in ipairs(Players:GetPlayers()) do
				if otherPlayer ~= Player then
					local character = otherPlayer.Character
					local root = character and character:FindFirstChild("HumanoidRootPart")
					local humanoid = character and character:FindFirstChildOfClass("Humanoid")
					if root and humanoid and humanoid.Health > 0 then
						local record = getRecord(otherPlayer, character)
						local currentCFrame, currentPosition = root.CFrame, root.Position
						if record.isOut then
							if record.lastPosition then
								local delta = currentPosition - record.lastPosition
								local horizontal = Vector3.new(delta.X, 0, delta.Z).Magnitude
								if horizontal < STEP_MAX and withinSafeBounds(currentPosition) then record.walked += horizontal end
							end
							record.lastPosition = currentPosition
							if record.walked >= WALK_CLEAR then
								record.isOut = false
								record.ghostPosition, record.ghostCFrame = currentPosition, currentCFrame
								record.history, record.walked = {}, 0
								record.lastPosition = nil
							end
						else
							record.lastPosition = currentPosition
							record.ghostPosition, record.ghostCFrame = currentPosition, currentCFrame
							table.insert(record.history, {time = now, cframe = currentCFrame})
							while #record.history > 0 and now - record.history[1].time > WINDOW do table.remove(record.history, 1) end
							local oldest = record.history[1]
							if oldest then
								local origin = oldest.cframe.Position
								local totalDistance = (currentPosition - origin).Magnitude
								local deltaY = math.abs(currentPosition.Y - origin.Y)
								if (totalDistance >= TP_TOTAL or deltaY >= TP_DELTA_Y) and withinSafeBounds(origin) then
									record.isOut = true
									record.ghostPosition, record.ghostCFrame = origin, oldest.cframe
									record.walked = 0
									record.lastPosition = currentPosition
									record.history = {}
								end
							end
						end
					else
						antiVoid.players[otherPlayer] = newPlayerRecord(character)
					end
				end
			end
		end
		local function startAntiVoid()
			if antiVoid.conn then return end
			antiVoid.enabled = true
			antiVoid.sampleAccumulator, antiVoid.rescueAccumulator = 0, 0
			antiVoid.conn = RunService.Heartbeat:Connect(function(dt)
				if not antiVoid.enabled or not toggleStates["Anti Void"] then return end
				updateLocalRescue(dt)
				antiVoid.sampleAccumulator += dt or 0
				if antiVoid.sampleAccumulator >= 0.05 then
					antiVoid.sampleAccumulator = 0
					sampleOtherPlayers()
				end
			end)
			_G.__CrystalTrackConn(antiVoid.conn)
		end
		local function stopAntiVoid()
			antiVoid.enabled = false
			if antiVoid.conn then pcall(function() antiVoid.conn:Disconnect() end); antiVoid.conn = nil end
			for _, record in pairs(antiVoid.players) do
				record.isOut = false
				record.history, record.walked, record.lastPosition = {}, 0, nil
			end
			antiVoid.lastSafePosition, antiVoid.spawnOrigin = nil, nil
		end
		FeaturePostToggle["Anti Void"] = function(active)
			if active then startAntiVoid() else stopAntiVoid() end
		end
		_G.__CrystalAntiVoid = {
			setEnabled = function(active)
				active = active == true
				toggleStates["Anti Void"] = active
				if active then startAntiVoid() else stopAntiVoid() end
				pcall(saveConfig)
			end,
			isEnabled = function() return antiVoid.enabled end,
			bounds = MAP_BOUNDS,
			posFor = getAntiVoidPosition,
			isOut = function(player) local record = antiVoid.players[player]; return record and record.isOut == true or false end,
			ghostOf = function(player) local record = antiVoid.players[player]; return record and record.ghostPosition or nil end,
		}
		_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function()
			antiVoid.lastSafePosition, antiVoid.spawnOrigin = nil, nil
			antiVoid.rescueAccumulator = 0
		end))
		_G.__CrystalTrackStopper(stopAntiVoid)
		if toggleStates["Anti Void"] then startAntiVoid() end
	end

	-- Screen blur REMOVED: the game is never blurred any more. The only idle
	-- effect left is the menu ghosting out on its own (MENU IDLE FADE, at the end
	-- of the modern GUI builder). Any BlurEffect that an older build of this hub
	-- parked in Lighting is cleaned up here, so upgrading mid-session does not
	-- leave the screen blurry. The toggle row on the Visual page is gone too.
	do
		local lighting = game:GetService("Lighting")
		pcall(function()
			for _, effect in ipairs(lighting:GetChildren()) do
				if effect:IsA("BlurEffect") and (effect.Name == "SoundHubMotionBlur" or effect.Name == "AmbitiousMotionBlur") then
					effect.Size = 0
					effect.Enabled = false
					effect:Destroy()
				end
			end
		end)
		toggleStates["Motion Blur"] = false
		FeatureToggles["Motion Blur"] = nil
		FeaturePostToggle["Motion Blur"] = nil
		toggleVisualUpdaters["Motion Blur"] = nil
	end

	-- Donor-style TP Ragdoll sequence, using Sound AutoPlay side detection and TP Down.
	do
		local ragdollTP = {
			enabled = false, connections = {}, generation = 0, wasDown = false, busy = false,
		}
		local RAGDOLL_TP_CFG = {
			BLOCK = 1.15, PIVOT = 1.25, STEP = 0.095,
			R = {{x = -461.00, z = 62.58}, {x = -459.24, z = -11.13}, {x = -484.88, z = 24.08}},
			L = {{x = -461.00, z = 62.58}, {x = -468.65, z = 133.95}, {x = -484.88, z = 96.05}},
		}
		local function clearRagdollTPConnections()
			for _, connection in ipairs(ragdollTP.connections) do pcall(function() connection:Disconnect() end) end
			table.clear(ragdollTP.connections)
		end
		local function cancelRagdollTP()
			ragdollTP.generation += 1
			ragdollTP.busy = false
			_G.__SoundRagdollTPBusy = false
		end
		local function enemyAlreadyDown()
			local character = Player.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			if not root then return false end
			local nearestDistance = math.huge
			local nearestDown = false
			for _, otherPlayer in ipairs(Players:GetPlayers()) do
				local otherCharacter = otherPlayer ~= Player and otherPlayer.Character
				local otherRoot = otherCharacter and otherCharacter:FindFirstChild("HumanoidRootPart")
				local otherHumanoid = otherCharacter and otherCharacter:FindFirstChildOfClass("Humanoid")
				if otherRoot and otherHumanoid and otherHumanoid.Health > 0 then
					local distance = (root.Position - otherRoot.Position).Magnitude
					if distance < nearestDistance then
						nearestDistance = distance
						local state = otherHumanoid:GetState()
						nearestDown = state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll
					end
				end
			end
			return nearestDown and nearestDistance <= 35
		end
		local function selectedRagdollSide()
			local side = _G.__CrystalForceAutoplaySide
			if side ~= "left" and side ~= "right" and type(_G.__CrystalGetAutoplaySide) == "function" then
				local ok, detected = pcall(_G.__CrystalGetAutoplaySide)
				if ok then side = detected end
			end
			if side == "left" then return "L" end
			if side == "right" then return "R" end
			return nil
		end
		local function runRagdollTP()
			local side = selectedRagdollSide()
			local points = side and RAGDOLL_TP_CFG[side]
			if not points then return end
			ragdollTP.generation += 1
			ragdollTP.wasDown = true
			local generation = ragdollTP.generation
			local character = Player.Character
			task.delay(RAGDOLL_TP_CFG.BLOCK, function()
				if generation ~= ragdollTP.generation or not ragdollTP.enabled or Player.Character ~= character then return end
				ragdollTP.busy = true
				_G.__SoundRagdollTPBusy = true
				if type(_G["ExecuteTPDown"]) == "function" then pcall(_G["ExecuteTPDown"]) end
			end)
			task.delay(RAGDOLL_TP_CFG.PIVOT, function()
				if generation ~= ragdollTP.generation or not ragdollTP.enabled then return end
				if Player.Character ~= character or not character then cancelRagdollTP(); return end
				if not ragdollTP.busy then ragdollTP.busy = true; _G.__SoundRagdollTPBusy = true end
				for _, point in ipairs(points) do
					if generation ~= ragdollTP.generation or Player.Character ~= character then return end
					pcall(function()
						local here = character:GetPivot().Position
						character:PivotTo(CFrame.new(point.x, here.Y, point.z))
					end)
					task.wait(RAGDOLL_TP_CFG.STEP)
				end
				if generation == ragdollTP.generation then
					ragdollTP.busy = false
					_G.__SoundRagdollTPBusy = false
				end
			end)
		end
		local function isDownState(state)
			return state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll
		end
		local function onLocalHumanoidState(humanoid, state)
			if not ragdollTP.enabled then return end
			local down = isDownState(state)
			if down and not ragdollTP.wasDown then
				ragdollTP.wasDown = true
				local alive = humanoid and humanoid.Health > 0
				local medusaHit = type(_G.__CrystalIsMedusaHit) == "function" and _G.__CrystalIsMedusaHit() or false
				if alive and not _G.__CrystalInstaResetBusy and not medusaHit and not enemyAlreadyDown() then runRagdollTP() end
			elseif not down then
				ragdollTP.wasDown = false
			end
		end
		local function bindRagdollTPCharacter(character)
			clearRagdollTPConnections()
			ragdollTP.wasDown = false
			local humanoid = character and (character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5))
			if not humanoid then return end
			local state = humanoid:GetState()
			ragdollTP.wasDown = isDownState(state)
			table.insert(ragdollTP.connections, humanoid.StateChanged:Connect(function(_, newState) onLocalHumanoidState(humanoid, newState) end))
			table.insert(ragdollTP.connections, humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
				if humanoid.PlatformStand then onLocalHumanoidState(humanoid, humanoid:GetState()) end
			end))
		end
		local function stopRagdollTP()
			ragdollTP.enabled = false
			clearRagdollTPConnections()
			cancelRagdollTP()
		end
		local function startRagdollTP()
			ragdollTP.enabled = true
			if Player.Character then bindRagdollTPCharacter(Player.Character) end
		end
		FeaturePostToggle["Ragdoll TP"] = function(active)
			if active then startRagdollTP() else stopRagdollTP() end
		end
		_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(character)
			cancelRagdollTP()
				if ragdollTP.enabled then task.delay(0.5, function() if ragdollTP.enabled then bindRagdollTPCharacter(character) end end) end
		end))
		_G.__CrystalTrackStopper(stopRagdollTP)
		if toggleStates["Ragdoll TP"] then startRagdollTP() end
	end

	do
	local LP = Player

	local function getBat()
	local char = LP.Character
	if char then
	local equippedTool = char:FindFirstChildOfClass("Tool")
	if equippedTool then
	local equippedName = equippedTool.Name:lower()
	if equippedName:find("bat", 1, true) or equippedName:find("slap", 1, true) then
	return equippedTool
	end
	end
	local backpack = LP:FindFirstChildOfClass("Backpack")
	if backpack then
	for _, tool in ipairs(backpack:GetChildren()) do
	if tool:IsA("Tool") then
	local toolName = tool.Name:lower()
	if toolName:find("bat", 1, true) or toolName:find("slap", 1, true) then
	return tool
	end
	end
	end
	end
	end
	return nil
	end

	local _cypherConn = nil

	_G.__CrystalAceNormalAimbot = _G.__CrystalAceNormalAimbot or {
	target = nil,
	swingCooldown = false,
	nextSwingAt = 0,
	}
	local function getEnemyRenderCFrame(root)
	if not root then return nil end
	local rendered = root.CFrame

	local ok, current = pcall(root.GetRenderCFrame, root)
	if ok and current then rendered = current end
	return rendered
	end

	_cypherStartFollowing = function(char)
	char = char or Player.Character
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not humanoid or not root then return end
	if _cypherConn then _cypherConn:Disconnect(); _cypherConn = nil end
	_G.__CrystalAceNormalAimbot.nextSwingAt = 0
	_G.__CrystalAceNormalAimbot.swingCooldown = false
	humanoid.AutoRotate = false
	local initialBat = char:FindFirstChildOfClass("Tool") or getBat()
	if initialBat and initialBat.Parent ~= char then
	pcall(humanoid.EquipTool, humanoid, initialBat)
	end

	_cypherConn = RunService.RenderStepped:Connect((function()
	if not toggleStates["Aimbot"] then return end
	local currentChar = Player.Character
	if not currentChar then return end
	local currentRoot = currentChar:FindFirstChild("HumanoidRootPart")
	local currentHumanoid = currentChar:FindFirstChildOfClass("Humanoid")
	if not currentRoot or not currentHumanoid then return end
	if currentHumanoid.AutoRotate then currentHumanoid.AutoRotate = false end

	local bat = currentChar:FindFirstChildOfClass("Tool") or getBat()
	if bat and bat.Parent ~= currentChar then
	pcall(currentHumanoid.EquipTool, currentHumanoid, bat)
	end

	local markerCFrame = nil
	if _G.__CrystalTPBatGetMarkerCFrame then
	local ok, result = pcall(_G.__CrystalTPBatGetMarkerCFrame)
	if ok then markerCFrame = result end
	end

	local visualTarget = nil
	local visualTargetCFrame = nil
	local visualEnemy = _G.__CrystalGetVisualEnemy and _G.__CrystalGetVisualEnemy()
	if visualEnemy and visualEnemy ~= Player and visualEnemy.Character then
	local visualRoot = visualEnemy.Character:FindFirstChild("HumanoidRootPart")
	local visualHumanoid = visualEnemy.Character:FindFirstChildOfClass("Humanoid")
	if visualRoot and visualHumanoid and visualHumanoid.Health > 0 then
	visualTarget = visualRoot
	visualTargetCFrame = getEnemyRenderCFrame(visualRoot)
	end
	end
	if not markerCFrame and (not visualTarget or not visualTargetCFrame) then return end
	_G.__CrystalAceNormalAimbot.target = markerCFrame or visualTarget

	local myPosition = currentRoot.Position
	local targetCFrame = markerCFrame or visualTargetCFrame
	local targetPosition = targetCFrame.Position
	local predictedChase = targetPosition
	local direction = predictedChase - myPosition
	local flatDirection = Vector3.new(direction.X, 0, direction.Z)

	local chaseSpeed = tonumber(speedValues.CypherAimbotApproachSpeed) or 55
	local horizontalVelocity = Vector3.zero
	if flatDirection.Magnitude >= 0.01 then
	horizontalVelocity = flatDirection.Unit * chaseSpeed
	end
	local verticalVelocity = (targetPosition.Y - myPosition.Y) * 19.5
	verticalVelocity = math.clamp(verticalVelocity, -70, 110)
	local desiredVelocity = Vector3.new(
	horizontalVelocity.X,
	verticalVelocity,
	horizontalVelocity.Z
	)
	currentRoot.AssemblyLinearVelocity = desiredVelocity

	local predictedPosition = targetPosition
	if (predictedPosition - myPosition).Magnitude > 0.1 then
	local goalCFrame = CFrame.lookAt(myPosition, predictedPosition)
	local difference = currentRoot.CFrame:Inverse() * goalCFrame
	local rx, ry, rz = difference:ToEulerAnglesXYZ()
	rx = math.clamp(rx, -2.5, 2.5)
	ry = math.clamp(ry, -2.5, 2.5)
	rz = math.clamp(rz, -2.5, 2.5)
	currentRoot.AssemblyAngularVelocity = currentRoot.CFrame:VectorToWorldSpace(
	Vector3.new(rx * 42, ry * 42, rz * 42)
	)
	end

	local swingNow = tick()
	if bat and swingNow >= (_G.__CrystalAceNormalAimbot.nextSwingAt or 0) then
	_G.__CrystalAceNormalAimbot.nextSwingAt = swingNow + 0.08
	pcall(bat.Activate, bat)
	end
	end))
	end

	_cypherStop = function()
	if _cypherConn then _cypherConn:Disconnect(); _cypherConn = nil end
	if _G.__CrystalAceNormalAimbot then
	_G.__CrystalAceNormalAimbot.target = nil
	_G.__CrystalAceNormalAimbot.swingCooldown = false
	_G.__CrystalAceNormalAimbot.nextSwingAt = 0
	end
	local char = Player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root then
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	end
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	if humanoid then humanoid.AutoRotate = true end
	end

	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	if toggleStates["Aimbot"] then _cypherStartFollowing(char) end
	end))

	FeaturePostToggle["Aimbot"] = function(active)
	if active then
	if _G.__stopSpeedBoost then _G.__stopSpeedBoost() end
	if autoplayActive or toggleStates["Autoplay"] then
	_G.__stopAutoplay()
	end
	deactivateOtherAimbots("Aimbot")
	if _G.__deactivateBatExclusive then _G.__deactivateBatExclusive("Aimbot") end
	_G.__checkAndAutoDrop(function()
	local char = Player.Character
	if char then _cypherStartFollowing(char) end
	end)
	else
	_cypherStop()
	if _G.__refreshSpeedBoost then _G.__refreshSpeedBoost() end
	end
	if _G.__CrystalRefreshMirrorTP then pcall(_G.__CrystalRefreshMirrorTP) end
	end

	-- Mirror TP: when enabled + Bat Aimbot on, snap under nearby players that drop in Y (Adapt-style)
	do
		local mirrorYTrack = {}
		local lastMirrorTpAt = 0
		local mirrorConn = nil

		local function mirrorTpActive()
			return toggleStates["Mirror TP"] == true and toggleStates["Aimbot"] == true
		end

		local function doMirrorSnap()
			local now = tick()
			if now - lastMirrorTpAt < 0.08 then return end
			lastMirrorTpAt = now
			local character = Player.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			local hum = character and character:FindFirstChildOfClass("Humanoid")
			if not root or not hum or hum.Health <= 0 then return end
			local _, yRot, _ = root.CFrame:ToEulerAnglesYXZ()
			root.CFrame = CFrame.new(root.Position.X, -7, root.Position.Z) * CFrame.Angles(0, yRot, 0)
			root.Velocity = Vector3.zero
			pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
		end

		local function stopMirrorWatch()
			if mirrorConn then
				pcall(function() mirrorConn:Disconnect() end)
				mirrorConn = nil
			end
			table.clear(mirrorYTrack)
			_G._AdaptTPMirrorEnabled = false
		end

		local function startMirrorWatch()
			stopMirrorWatch()
			if not mirrorTpActive() then return end
			_G._AdaptTPMirrorEnabled = true
			local nextScan = 0
			mirrorConn = RunService.Heartbeat:Connect(function()
				if not mirrorTpActive() then
					stopMirrorWatch()
					return
				end
				local now = tick()
				if now < nextScan then return end
				nextScan = now + 0.1

				local character = Player.Character
				local myRoot = character and character:FindFirstChild("HumanoidRootPart")
				if not myRoot then return end

				for _, other in ipairs(Players:GetPlayers()) do
					if other ~= Player and other.Character then
						local theirRoot = other.Character:FindFirstChild("HumanoidRootPart")
						local theirHum = other.Character:FindFirstChildOfClass("Humanoid")
						if theirRoot and theirHum and theirHum.Health > 0 then
							local dx = theirRoot.Position.X - myRoot.Position.X
							local dz = theirRoot.Position.Z - myRoot.Position.Z
							if dx * dx + dz * dz <= 64 then
								local y = theirRoot.Position.Y
								local prevY = mirrorYTrack[other.UserId]
								if prevY and (prevY - y) >= 3 then
									pcall(doMirrorSnap)
									table.clear(mirrorYTrack)
									break
								end
								mirrorYTrack[other.UserId] = y
							else
								mirrorYTrack[other.UserId] = nil
							end
						end
					end
				end
			end)
			if _G.__CrystalTrackConn then _G.__CrystalTrackConn(mirrorConn) end
		end

		_G.__CrystalRefreshMirrorTP = function()
			if mirrorTpActive() then startMirrorWatch() else stopMirrorWatch() end
		end

		FeaturePostToggle["Mirror TP"] = function(active)
			if active and toggleStates["Aimbot"] then
				startMirrorWatch()
			else
				stopMirrorWatch()
			end
		end

		if _G.__CrystalTrackStopper then
			_G.__CrystalTrackStopper(stopMirrorWatch)
		end

		if toggleStates["Mirror TP"] and toggleStates["Aimbot"] then
			task.defer(startMirrorWatch)
		end
	end

	do
	pcall(function()
	local oldSphere = workspace:FindFirstChild("PredictionSphere")
	if oldSphere then oldSphere:Destroy() end
	end)
	local Z = {
	targetPlayer = nil,
	lastTargetPos = nil,
	targetVelocity = Vector3.zero,
	smoothedVelocity = Vector3.zero,
	velocityHistory = {},
	accelerationHistory = {},
	aerialVelocityHistory = {},
	verticalVelocityHistory = {},
	previousDirection = nil,
	lastDirectionChangeTime = 0,
	airborneTime = 0,
	lastYVelocity = 0,
	lastJumpTime = 0,
	lastActivationTime = 0,
	currentPing = 0.1,
	realPingMs = 0,
	}
	local ZCFG = {
	FOLLOW_SPEED = 57,
	ACTIVATE_DISTANCE = 13,
	MIN_FOLLOW_DISTANCE = 1,
	PREDICTION_TIME = 0.22,
	PREDICT_AHEAD = 3,
	MAX_VELOCITY_CHANGE = 150,
	VELOCITY_SMOOTHING = 0.2,
	MAX_HORIZONTAL_VELOCITY = 80,
	SERVER_TICKRATE = 1 / 60,
	MIN_PING_COMPENSATION = 0.03,
	MAX_PING_COMPENSATION = 0.25,
	ACCELERATION_PREDICTION_WEIGHT = 0.3,
	DIRECTION_CHANGE_DETECTION_TIME = 0.12,
	QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
	GRAVITY = 196.2,
	AIR_CONTROL_FACTOR = 0.8,
	AERIAL_VELOCITY_DECAY = 0.95,
	MIN_AIRBORNE_TIME = 0.08,
	FALLING_SPEED_THRESHOLD = -15,
	}
	local zurichConn = nil
	local function averageVector(history)
	if #history == 0 then return Vector3.zero end
	local total = Vector3.zero
	for _, value in ipairs(history) do total += value end
	return total / #history
	end
	local function pushHistory(history, value, maximum)
	table.insert(history, value)
	if #history > maximum then table.remove(history, 1) end
	end
	local function resetZurichTarget()
	Z.targetPlayer = nil
	Z.lastTargetPos = nil
	Z.targetVelocity = Vector3.zero
	Z.smoothedVelocity = Vector3.zero
	Z.velocityHistory = {}
	Z.accelerationHistory = {}
	Z.aerialVelocityHistory = {}
	Z.verticalVelocityHistory = {}
	Z.previousDirection = nil
	Z.airborneTime = 0
	Z.lastYVelocity = 0
	end
	local function nearestZurichTarget(root)
	local nearest, nearestDistance = nil, math.huge
	for _, candidate in ipairs(Players:GetPlayers()) do
	if candidate ~= Player and candidate.Character then
	local targetRoot = candidate.Character:FindFirstChild("HumanoidRootPart")
	local targetHumanoid = candidate.Character:FindFirstChildOfClass("Humanoid")
	if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
	local distance = (root.Position - targetRoot.Position).Magnitude
	if distance < nearestDistance then nearest, nearestDistance = candidate, distance end
	end
	end
	end
	return nearest
	end
	local function rotateZurichRoot(root, direction)
	if direction.Magnitude < 0.01 then return end
	local axis = root.CFrame.LookVector:Cross(direction.Unit)
	local angle = math.asin(math.clamp(axis.Magnitude, -1, 1))
	root.AssemblyAngularVelocity = axis.Magnitude > 0.01 and axis.Unit * angle * 80 or Vector3.zero
	end
	-- Sound marker bridge.  The TP Bat marker is optional; when it
	-- does not exist, the nearest-player aimbot path runs.
	local function getImportedBatAimbotMarker()
		local markerGetter = _G.__SoundTPBatGetMarkerCFrame or _G.__CrystalTPBatGetMarkerCFrame or _G.__AkatsukiTPBatGetMarkerCFrame
		if type(markerGetter) ~= "function" then return nil end
		local ok, markerCFrame = pcall(markerGetter)
		return ok and markerCFrame or nil
	end
	local function sampleZurichPing()
	local ok, value = pcall(function()
	return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
	end)
	if ok and type(value) == "number" then Z.realPingMs = math.floor(value) end
	Z.currentPing = math.clamp(Z.realPingMs / 1000, ZCFG.MIN_PING_COMPENSATION, ZCFG.MAX_PING_COMPENSATION)
	end
	task.spawn(function()
	while _G.__CRYSTAL_STATE == crystalRuntimeState do
	pcall(sampleZurichPing)
	task.wait(0.5)
	end
	end)

	local function stopZurichAimbot()
	if zurichConn then zurichConn:Disconnect(); zurichConn = nil end
	local char = Player.Character
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if humanoid then humanoid.AutoRotate = true end
	if root then root.AssemblyAngularVelocity = Vector3.zero end
	resetZurichTarget()
	Z.lastActivationTime = 0
	end

	local function startZurichAimbot(char)
	char = char or Player.Character
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not humanoid or not root then return end
	stopZurichAimbot()
	humanoid.AutoRotate = false
	local bat = getBat()
	if bat and bat.Parent ~= char then pcall(humanoid.EquipTool, humanoid, bat) end
	zurichConn = RunService.RenderStepped:Connect(function(dt)
	if not toggleStates["Aimbot"] then stopZurichAimbot(); return end
	local currentChar = Player.Character
	local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
	local currentHumanoid = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
	if not currentRoot or not currentHumanoid or currentHumanoid.Health <= 0 then return end
	currentHumanoid.AutoRotate = false
	root, humanoid = currentRoot, currentHumanoid
	bat = currentChar:FindFirstChildOfClass("Tool") or getBat()
	if bat and bat.Parent ~= currentChar then pcall(currentHumanoid.EquipTool, currentHumanoid, bat) end

	local markerCFrame = getImportedBatAimbotMarker()
	if markerCFrame then
	local markedDirection = markerCFrame.Position - root.Position
	if markedDirection.Magnitude > 0.1 then rotateZurichRoot(root, markedDirection) end
	if markedDirection.Magnitude > ZCFG.MIN_FOLLOW_DISTANCE then
	local markedSpeed = tonumber(speedValues.CypherAimbotApproachSpeed) or ZCFG.FOLLOW_SPEED
	root.AssemblyLinearVelocity = markedDirection.Unit * math.clamp(markedSpeed, 1, 120)
	else
	root.AssemblyLinearVelocity = Vector3.zero
	end
	return
	end

	Z.targetPlayer = nearestZurichTarget(root)
	local targetChar = Z.targetPlayer and Z.targetPlayer.Character
	local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
	local targetHumanoid = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
	if not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0 then resetZurichTarget(); return end
	local targetPos = targetRoot.Position
	local safeDt = math.max(dt, 1 / 240)
	if Z.lastTargetPos then
	local rawVelocity = (targetPos - Z.lastTargetPos) / safeDt
	local velocityDelta = rawVelocity - Z.targetVelocity
	if velocityDelta.Magnitude > ZCFG.MAX_VELOCITY_CHANGE then
	rawVelocity = Z.targetVelocity + velocityDelta.Unit * ZCFG.MAX_VELOCITY_CHANGE
	end
	local horizontal = Vector3.new(rawVelocity.X, 0, rawVelocity.Z)
	if horizontal.Magnitude > ZCFG.MAX_HORIZONTAL_VELOCITY then
	horizontal = horizontal.Unit * ZCFG.MAX_HORIZONTAL_VELOCITY
	rawVelocity = Vector3.new(horizontal.X, rawVelocity.Y, horizontal.Z)
	end
	pushHistory(Z.accelerationHistory, (rawVelocity - Z.targetVelocity) / safeDt, 4)
	pushHistory(Z.velocityHistory, rawVelocity, 8)
	pushHistory(Z.verticalVelocityHistory, rawVelocity.Y, 5)
	Z.targetVelocity = rawVelocity
	Z.smoothedVelocity = Z.smoothedVelocity:Lerp(rawVelocity, ZCFG.VELOCITY_SMOOTHING)
	end
	Z.lastTargetPos = targetPos

	local airborne = targetHumanoid.FloorMaterial == Enum.Material.Air
	Z.airborneTime = airborne and (Z.airborneTime + safeDt) or 0
	if airborne and Z.airborneTime >= ZCFG.MIN_AIRBORNE_TIME then
	pushHistory(Z.aerialVelocityHistory, Z.targetVelocity, 6)
	elseif not airborne then
	Z.aerialVelocityHistory = {}
	end
	local predictionVelocity = Z.smoothedVelocity
	if airborne and #Z.aerialVelocityHistory > 0 then
	local aerial = averageVector(Z.aerialVelocityHistory)
	predictionVelocity = Vector3.new(aerial.X, Z.targetVelocity.Y, aerial.Z) * ZCFG.AIR_CONTROL_FACTOR
	end
	local quickTurn = false
	local horizontalVelocity = Vector3.new(Z.targetVelocity.X, 0, Z.targetVelocity.Z)
	if horizontalVelocity.Magnitude > 5 then
	local direction = horizontalVelocity.Unit
	if Z.previousDirection and Z.previousDirection:Dot(direction) < 0.5 then
	quickTurn = tick() - Z.lastDirectionChangeTime < ZCFG.DIRECTION_CHANGE_DETECTION_TIME
	Z.lastDirectionChangeTime = tick()
	end
	Z.previousDirection = direction
	end
	local serverDelay = Z.currentPing + ZCFG.SERVER_TICKRATE
	if quickTurn then serverDelay *= ZCFG.QUICK_DIRECTION_CHANGE_MULTIPLIER end
	local predicted = targetPos + predictionVelocity * serverDelay
	local acceleration = averageVector(Z.accelerationHistory)
	predicted += acceleration * ZCFG.ACCELERATION_PREDICTION_WEIGHT * (serverDelay * serverDelay * 0.5)
	local predictionTime = ZCFG.PREDICTION_TIME * 1.1
	if airborne then
	predicted += predictionVelocity * predictionTime
	predicted += Vector3.new(0, -0.5 * ZCFG.GRAVITY * predictionTime * predictionTime, 0)
	else
	predicted += predictionVelocity * predictionTime
	end
	local flatPrediction = Vector3.new(predictionVelocity.X, 0, predictionVelocity.Z)
	if flatPrediction.Magnitude > 1 then predicted += flatPrediction.Unit * ZCFG.PREDICT_AHEAD end
	local toTarget = predicted - root.Position
	rotateZurichRoot(root, toTarget)
	if (targetPos - root.Position).Magnitude <= ZCFG.ACTIVATE_DISTANCE and tick() - Z.lastActivationTime >= 0.3 then
	if bat then pcall(bat.Activate, bat) end
	Z.lastActivationTime = tick()
	end
	if toTarget.Magnitude > ZCFG.MIN_FOLLOW_DISTANCE then
	local speed = math.clamp(tonumber(speedValues.CypherAimbotApproachSpeed) or ZCFG.FOLLOW_SPEED or 55, 1, 120)
	root.AssemblyLinearVelocity = toTarget.Unit * speed
	else
	root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y * 0.5, 0)
	end
	end)
	end

	_cypherStartFollowing = startZurichAimbot
	_cypherStop = stopZurichAimbot
	FeaturePostToggle["Aimbot"] = function(active)
	if active then
	if _G.__stopSpeedBoost then _G.__stopSpeedBoost() end
	if autoplayActive or toggleStates["Autoplay"] then _G.__stopAutoplay() end
	deactivateOtherAimbots("Aimbot")
	if _G.__deactivateBatExclusive then _G.__deactivateBatExclusive("Aimbot") end
	_G.__checkAndAutoDrop(function() startZurichAimbot(Player.Character) end)
	else
	stopZurichAimbot()
	if _G.__refreshSpeedBoost then _G.__refreshSpeedBoost() end
	end
	end
	_G.__CrystalTrackStopper(stopZurichAimbot)
	end

	if toggleStates["Aimbot"] then
	task.defer(function()
	if toggleStates["Aimbot"] and FeaturePostToggle["Aimbot"] then
	FeaturePostToggle["Aimbot"](true)
	end
	end)
	end
	end

	-- Sound Bat Aimbot controller.  This is the donor's live controller
	-- adapted to Cursed's state, UI toggle, cleanup, and TP-Bat marker API.
	do
		local aimbotState = {
			targetPlayer = nil,
			lastTargetPos = nil,
			targetVelocity = Vector3.zero,
			smoothedVelocity = Vector3.zero,
			velocityHistory = {},
			accelerationHistory = {},
			aerialVelocityHistory = {},
			verticalVelocityHistory = {},
			previousDirection = nil,
			lastDirectionChangeTime = 0,
			airborneTime = 0,
			lastYVelocity = 0,
			lastActivationTime = 0,
			currentPing = 0.1,
			realPingMs = 0,
			-- Sound normal sticky target
			stickyTarget = nil,
			stickyUntil = 0,
			lastScan = 0,
		}
		local aimbotConfig = {
			FOLLOW_SPEED = 55,
			ACTIVATE_DISTANCE = 13,
			MIN_FOLLOW_DISTANCE = 1,
			PREDICTION_TIME = 0.22,
			PREDICT_AHEAD = 3,
			MAX_VELOCITY_CHANGE = 150,
			VELOCITY_SMOOTHING = 0.2,
			MAX_HORIZONTAL_VELOCITY = 80,
			SERVER_TICKRATE = 1 / 60,
			MIN_PING_COMPENSATION = 0.03,
			MAX_PING_COMPENSATION = 0.25,
			ACCELERATION_PREDICTION_WEIGHT = 0.3,
			DIRECTION_CHANGE_DETECTION_TIME = 0.12,
			QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
			GRAVITY = 196.2,
			AIR_CONTROL_FACTOR = 0.8,
			MIN_AIRBORNE_TIME = 0.08,
		}
		local aimbotConnection = nil

		local function getBatTool()
			local character = Player.Character
			if not character then return nil end
			local equipped = character:FindFirstChildOfClass("Tool")
			if equipped then
				local name = equipped.Name:lower()
				if name:find("bat", 1, true) or name:find("slap", 1, true) then return equipped end
			end
			local backpack = Player:FindFirstChildOfClass("Backpack")
			if backpack then
				for _, tool in ipairs(backpack:GetChildren()) do
					if tool:IsA("Tool") then
						local name = tool.Name:lower()
						if name:find("bat", 1, true) or name:find("slap", 1, true) then return tool end
					end
				end
			end
			return nil
		end

		local function averageVector(history)
			if #history == 0 then return Vector3.zero end
			local total = Vector3.zero
			for _, value in ipairs(history) do total += value end
			return total / #history
		end
		local function pushHistory(history, value, maximum)
			table.insert(history, value)
			if #history > maximum then table.remove(history, 1) end
		end
		local function resetTarget()
			aimbotState.targetPlayer = nil
			aimbotState.lastTargetPos = nil
			aimbotState.targetVelocity = Vector3.zero
			aimbotState.smoothedVelocity = Vector3.zero
			aimbotState.velocityHistory = {}
			aimbotState.accelerationHistory = {}
			aimbotState.aerialVelocityHistory = {}
			aimbotState.verticalVelocityHistory = {}
			aimbotState.previousDirection = nil
			aimbotState.airborneTime = 0
			aimbotState.lastYVelocity = 0
		end
		local function nearestTarget(root)
			local nearest, nearestDistance = nil, math.huge
			for _, candidate in ipairs(Players:GetPlayers()) do
				if candidate ~= Player and candidate.Character then
					local targetRoot = candidate.Character:FindFirstChild("HumanoidRootPart")
					local targetHumanoid = candidate.Character:FindFirstChildOfClass("Humanoid")
					if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
						local targetPosition = targetRoot.Position
						if type(_G.__CrystalAntiVoidPositionForPlayer) == "function" then
							local ok, position = pcall(_G.__CrystalAntiVoidPositionForPlayer, candidate, targetPosition)
							if ok and typeof(position) == "Vector3" then targetPosition = position end
						end
						local distance = (root.Position - targetPosition).Magnitude
						if distance < nearestDistance then nearest, nearestDistance = candidate, distance end
					end
				end
			end
			return nearest
		end
		local function rotateRoot(root, direction)
			if not root or direction.Magnitude < 0.05 then return end
			local flat = Vector3.new(direction.X, 0, direction.Z)
			if flat.Magnitude < 0.05 then return end
			local goalCF = CFrame.lookAt(root.Position, root.Position + flat)
			local diffCF = root.CFrame:Inverse() * goalCF
			local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
			rx = math.clamp(rx, -2.5, 2.5)
			ry = math.clamp(ry, -2.5, 2.5)
			rz = math.clamp(rz, -2.5, 2.5)
			root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 45, ry * 45, rz * 45))
		end
		local function runAimbotV3(currentCharacter, currentRoot, currentHumanoid, bat)
			-- Ace Duels normal Bat Aimbot port: nearest living root, velocity lead,
			-- controlled yaw, fixed contact offset, and the donor's vertical chase.
			local safeBlocked = false
			local safeMode = _G._RaVeSafeMode
			if safeMode and type(safeMode.IsLocked) == "function" then
				local ok, locked = pcall(safeMode.IsLocked)
				safeBlocked = ok and locked == true
			end
			if not safeBlocked and type(_G._CandySafeGateBlocked) == "function" then
				local ok, blocked = pcall(_G._CandySafeGateBlocked)
				safeBlocked = ok and blocked == true
			end
			if safeBlocked then
				aimbotState.targetPlayer = nil
				currentHumanoid.AutoRotate = true
				currentRoot.AssemblyAngularVelocity = Vector3.zero
				resetTarget()
				return
			end

			local targetPlayer = nearestTarget(currentRoot)
			local targetCharacter = targetPlayer and targetPlayer.Character
			local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
			local targetHumanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")
			if not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0 then
				aimbotState.targetPlayer = nil
				aimbotState.stickyTarget = nil
				currentHumanoid.AutoRotate = true
				currentRoot.AssemblyAngularVelocity = Vector3.zero
				resetTarget()
				return
			end
			aimbotState.targetPlayer = targetPlayer
			currentHumanoid.AutoRotate = false

			local targetPosition = targetRoot.Position
			local targetIsGhost = false
			if type(_G.__CrystalAntiVoidPositionForPlayer) == "function" then
				local ok, position, isGhost = pcall(_G.__CrystalAntiVoidPositionForPlayer, targetPlayer, targetPosition)
				if ok and typeof(position) == "Vector3" then targetPosition = position; targetIsGhost = isGhost == true end
			end
			local targetVelocity = targetIsGhost and Vector3.zero or (targetRoot.AssemblyLinearVelocity or Vector3.zero)
			local predictedTarget = targetPosition
				+ targetVelocity * math.clamp(targetVelocity.Magnitude / 130, 0.05, 0.15)
				+ Vector3.new(0, 1, 0) -- donor VERT_OFFSET
			local toTarget = predictedTarget - currentRoot.Position
			local flatDirection = Vector3.new(toTarget.X, 0, toTarget.Z)
			if toTarget.Magnitude > 0.01 and flatDirection.Magnitude > 0.01 then
				local heading = (((math.deg(math.atan2(-flatDirection.X, -flatDirection.Z))
					- currentRoot.Orientation.Y) + 180) % 360) - 180
				local turnRate = math.clamp(math.rad(heading) * 180, -16, 16)
				currentRoot.AssemblyAngularVelocity = Vector3.new(0, turnRate, 0)

				local offset = (predictedTarget + flatDirection.Unit * -2.8)
					+ Vector3.new(0, 4.75, 0) - currentRoot.Position
				local horizontal = Vector3.new(offset.X, 0, offset.Z)
				local laggerAimbot = selectedMode == "Lagger" or laggerEnabled
					or toggleStates["Lagger Aimbot"] == true
				local chaseSpeed = laggerAimbot
					and (tonumber(speedValues.LaggerBoost) or 40)
					or (tonumber(speedValues.CypherAimbotApproachSpeed) or aimbotConfig.FOLLOW_SPEED or 56)
				chaseSpeed = math.clamp(chaseSpeed, 1, 250)
				chaseSpeed = math.clamp(chaseSpeed, 1, 90)
				if horizontal.Magnitude < 6 then
					chaseSpeed = chaseSpeed * math.clamp(horizontal.Magnitude / 6, 0.35, 1)
				end
				local horizontalVelocity = horizontal.Magnitude > 0.2
					and horizontal.Unit * chaseSpeed or Vector3.zero
				local verticalVelocity = math.clamp(offset.Y * 1.35, -40, 42)
				if currentHumanoid.FloorMaterial ~= Enum.Material.Air and offset.Y < 2 then
					verticalVelocity = math.clamp(currentRoot.AssemblyLinearVelocity.Y, -12, 20)
				end
				local desired = Vector3.new(horizontalVelocity.X, verticalVelocity, horizontalVelocity.Z)
				currentRoot.AssemblyLinearVelocity = currentRoot.AssemblyLinearVelocity:Lerp(desired, 0.34)
				if horizontal.Magnitude > 0.5 then
					currentHumanoid:Move(horizontal.Unit, false)
				end
			end

			local tool = getBatTool()
			if not tool and bat and bat:IsA("Tool") then
				local name = tostring(bat.Name or ""):lower()
				if name:find("bat", 1, true) or name:find("slap", 1, true) then tool = bat end
			end
			if tool and tool.Parent ~= currentCharacter then
				pcall(currentHumanoid.EquipTool, currentHumanoid, tool)
			end
			local now = tick()
			if tool and tool.Parent == currentCharacter
				and now - (aimbotState.lastActivationTime or 0) >= 0.08 then
				aimbotState.lastActivationTime = now
				pcall(tool.Activate, tool)
			end
		end

		-- ===== Bat Aimbot V2 (NORMAL): logic ported from Vx7 normal aimbot =====
		local V2_ATT, V2_MOVER = "SoundAimbotV2Attachment", "SoundAimbotV2Velocity"
		local v2Pred = {}
		local function clearV2Mover(root)
			root = root or (Player.Character and Player.Character:FindFirstChild("HumanoidRootPart"))
			if not root then return end
			local m, a = root:FindFirstChild(V2_MOVER), root:FindFirstChild(V2_ATT)
			if m then m:Destroy() end
			if a then a:Destroy() end
		end
		local function ensureV2Mover(root, speed)
			local att = root:FindFirstChild(V2_ATT)
			if not att then
				att = Instance.new("Attachment")
				att.Name = V2_ATT
				att.Parent = root
			end
			local lv = root:FindFirstChild(V2_MOVER)
			if not lv then
				lv = Instance.new("LinearVelocity")
				lv.Name = V2_MOVER
				lv.Attachment0 = att
				lv.RelativeTo = Enum.ActuatorRelativeTo.World
				lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
				lv.ForceLimitsEnabled = true
				lv.ForceLimitMode = Enum.ForceLimitMode.PerAxis
				lv.VectorVelocity = Vector3.zero
				lv.Parent = root
			end
			local f = math.clamp(root.AssemblyMass * math.max(speed * 220, 6000), 1000000, 50000000)
			lv.MaxAxesForce = Vector3.new(f, f, f)
			lv.Enabled = true
			return lv
		end
		local function runAimbotV2Normal(currentCharacter, currentRoot, currentHumanoid, bat, deltaTime)
			local targetPlayer = nearestTarget(currentRoot)
			local tChar = targetPlayer and targetPlayer.Character
			local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
			if not tRoot then
				currentHumanoid.AutoRotate = true
				currentRoot.AssemblyAngularVelocity = Vector3.zero
				clearV2Mover(currentRoot)
				return
			end
			aimbotState.targetPlayer = targetPlayer
			local laggerAimbot = selectedMode == "Lagger" or laggerEnabled or toggleStates["Lagger Aimbot"] == true
			local speed = laggerAimbot and (tonumber(speedValues.LaggerBoost) or 40)
				or (tonumber(speedValues.CypherAimbotApproachSpeed) or 58)
			speed = math.clamp(speed, 1, 500)
			currentHumanoid.AutoRotate = false
			local now = tick()
			local tPos = tRoot.Position
			if type(_G.__CrystalAntiVoidPositionForPlayer) == "function" then
				local ok, p = pcall(_G.__CrystalAntiVoidPositionForPlayer, targetPlayer, tPos)
				if ok and typeof(p) == "Vector3" then tPos = p end
			end
			local rec = v2Pred[tRoot]
			local vel
			if not rec then
				v2Pred[tRoot] = { pos = tPos, time = now, vel = Vector3.zero }
				vel = Vector3.zero
			else
				local dt = math.clamp(now - rec.time, 1 / 120, 0.25)
				local raw = (tPos - rec.pos) / dt
				rec.vel = rec.vel:Lerp(raw.Magnitude > 80 and raw.Unit * 80 or raw, 0.25)
				rec.pos, rec.time = tPos, now
				vel = rec.vel
			end
			local aim = tPos + vel * math.clamp(vel.Magnitude / 130, 0.05, 0.12) + Vector3.new(0, 1, 0)
			local d = aim - currentRoot.Position
			local dirUnit = d.Magnitude > 0.01 and d.Unit or Vector3.zero
			local flat = Vector3.new(d.X, 0, d.Z)
			if d.Magnitude > 0.01 and flat.Magnitude > 0.01 then
				local yawErr = (math.deg(math.atan2(-flat.X, -flat.Z)) - currentRoot.Orientation.Y + 180) % 360 - 180
				local pitchErr = (math.deg(math.atan2(d.Y, flat.Magnitude)) - currentRoot.Orientation.X + 180) % 360 - 180
				local yawRate = math.clamp(math.rad(yawErr) * 285, -28, 28)
				local pitchRate = math.clamp(math.rad(pitchErr) * 285, -28, 28)
				local yawRad = math.rad(currentRoot.Orientation.Y)
				local axis = Vector3.new(math.cos(yawRad), 0, -math.sin(yawRad))
				currentRoot.AssemblyAngularVelocity = Vector3.new(0, yawRate, 0) + axis * pitchRate
			else
				currentRoot.AssemblyAngularVelocity = Vector3.zero
			end
			local off = aim + dirUnit * 2.8 + Vector3.new(0, 4.75, 0) - currentRoot.Position
			local hOff = Vector3.new(off.X, 0, off.Z)
			local hVel = hOff.Magnitude > 0.1 and hOff.Unit * speed or Vector3.zero
			local vVel = math.abs(off.Y) > 0.1 and Vector3.new(0, math.sign(off.Y) * 52, 0) or Vector3.new(0, -2, 0)
			local lv = ensureV2Mover(currentRoot, speed)
			local k = 1 - math.exp(-math.max(deltaTime or 1 / 60, 0) * 26)
			lv.VectorVelocity = lv.VectorVelocity:Lerp(hVel + vVel, k)
			if hOff.Magnitude > 0.5 then currentHumanoid:Move(hOff.Unit, false) end
			local tool = getBatTool()
			if not tool and bat and bat:IsA("Tool") then tool = bat end
			if tool and tool.Parent == currentCharacter and now - (aimbotState.lastActivationTime or 0) >= 0.08 then
				aimbotState.lastActivationTime = now
				pcall(tool.Activate, tool)
			end
		end

		local function stopSoundBatAimbot()
			if aimbotConnection then aimbotConnection:Disconnect(); aimbotConnection = nil end
			local character = Player.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			local root = character and character:FindFirstChild("HumanoidRootPart")
			if humanoid then humanoid.AutoRotate = true end
			if root then
				root.AssemblyAngularVelocity = Vector3.zero
				if root:FindFirstChild(V2_MOVER) then
					clearV2Mover(root)
					root.AssemblyLinearVelocity = Vector3.zero
				end
			end
			v2Pred = {}
			resetTarget()
			aimbotState.lastActivationTime = 0
		end

		
		task.spawn(function()
			while true do
				task.wait(0.5)
				local ok, value = pcall(function()
					return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
				end)
				if ok and type(value) == "number" then
					aimbotState.realPingMs = math.floor(value)
					aimbotState.currentPing = math.clamp(
						aimbotState.realPingMs / 1000,
						aimbotConfig.MIN_PING_COMPENSATION or 0.03,
						aimbotConfig.MAX_PING_COMPENSATION or 0.25
					)
				end
			end
		end)
local function startSoundBatAimbot(character)
			character = character or Player.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			local root = character and character:FindFirstChild("HumanoidRootPart")
			if not humanoid or not root then return end
			stopSoundBatAimbot()
			humanoid.AutoRotate = false
			local bat = getBatTool()
			if bat and bat.Parent ~= character then pcall(humanoid.EquipTool, humanoid, bat) end
			aimbotConnection = RunService.RenderStepped:Connect(function(deltaTime)
				if not toggleStates["Aimbot"] then stopSoundBatAimbot(); return end
				local currentCharacter = Player.Character
				local currentRoot = currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart")
				local currentHumanoid = currentCharacter and currentCharacter:FindFirstChildOfClass("Humanoid")
				if not currentRoot or not currentHumanoid or currentHumanoid.Health <= 0 then return end
				currentHumanoid.AutoRotate = false
				bat = currentCharacter:FindFirstChildOfClass("Tool") or getBatTool()
				if bat and bat.Parent ~= currentCharacter then pcall(currentHumanoid.EquipTool, currentHumanoid, bat) end

				if _G._AdaptBatMode ~= "BYPASS" and tonumber(_G._AdaptBatVersion) == 3 then
					clearV2Mover(currentRoot)
					runAimbotV3(currentCharacter, currentRoot, currentHumanoid, bat)
					return
				end
				if _G._AdaptBatMode ~= "BYPASS" and tonumber(_G._AdaptBatVersion) == 2 then
					runAimbotV2Normal(currentCharacter, currentRoot, currentHumanoid, bat, deltaTime)
					return
				end
				clearV2Mover(currentRoot)

				-- V2 removed: only NORMAL V1 / BYPASS C1 remain.
				if false and tonumber(_G._AdaptBatVersion) == 2 then
					local targetPlayer = nearestTarget(currentRoot)
					local targetCharacter = targetPlayer and targetPlayer.Character
					local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
					local targetHumanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")
					aimbotState.targetPlayer = targetPlayer
					if not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0 then resetTarget(); return end
					local myPos, targetPos = currentRoot.Position, targetRoot.Position
					local targetVel = targetRoot.AssemblyLinearVelocity or Vector3.zero
					if _G._AdaptBatMode ~= "BYPASS" then
						-- DEFAULT V2 = BloodHounds Adapt aimbot: velocity lead, height lock, strong lerp, range swing.
						local predicted = targetPos + targetVel * 0.14 + targetRoot.CFrame.LookVector * 0.3
						local delta = predicted - myPos
						local flat = Vector3.new(delta.X, 0, delta.Z)
						local flatUnit = flat.Magnitude > 0 and flat.Unit or Vector3.zero
						local yVel = (targetPos.Y + 3.7 - myPos.Y) * 19.5 + targetVel.Y * 0.8
						if currentHumanoid.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
						yVel = math.clamp(yVel, -70, 110)
						local chaseSpeed = math.clamp(tonumber(speedValues.CypherAimbotApproachSpeed) or 58, 1, 200)
						local desiredVel = Vector3.new(flatUnit.X * chaseSpeed, yVel, flatUnit.Z * chaseSpeed)
						currentRoot.AssemblyLinearVelocity = currentRoot.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
						local leadTime = math.clamp(targetVel.Magnitude / 150, 0.05, 0.2)
						local aimPos = targetPos + targetVel * leadTime
						local aimDelta = aimPos - myPos
						if aimDelta.Magnitude > 0.1 then
							local goalCF = CFrame.lookAt(myPos, aimPos)
							local diffCF = currentRoot.CFrame:Inverse() * goalCF
							local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
							rx = math.clamp(rx, -2.5, 2.5)
							ry = math.clamp(ry, -2.5, 2.5)
							rz = math.clamp(rz, -2.5, 2.5)
							currentRoot.AssemblyAngularVelocity = currentRoot.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
						end
						if (myPos - targetPos).Magnitude <= 8 and bat and bat.Parent == currentCharacter then pcall(bat.Activate, bat) end
					else
						-- BYPASS V2: use BloodHounds' V2 chase/offset/hit logic.
						local targetVel = targetRoot.AssemblyLinearVelocity or targetRoot.Velocity or Vector3.zero
						local moveDir = targetVel.Magnitude > 0.1 and targetVel.Unit or targetRoot.CFrame.LookVector
						local desiredPos = targetRoot.Position
							+ moveDir * 1.0
							+ Vector3.new(0, 1.5, 0)
						local toDesired = desiredPos - currentRoot.Position
						local chaseSpeed = math.clamp(tonumber(speedValues.CypherAimbotApproachSpeed) or 60, 1, 200)
						if toDesired.Magnitude > 0.5 then
							local moveVec = toDesired.Unit * chaseSpeed
							currentRoot.AssemblyLinearVelocity = Vector3.new(moveVec.X, moveVec.Y, moveVec.Z)
						else
							currentRoot.AssemblyLinearVelocity = currentRoot.AssemblyLinearVelocity * 0.95
							if currentRoot.AssemblyLinearVelocity.Magnitude < 1 then
								currentRoot.AssemblyLinearVelocity = Vector3.zero
							end
						end
						local distToTarget = (currentRoot.Position - targetRoot.Position).Magnitude
						if distToTarget <= 4.5 and bat and bat.Parent == currentCharacter then
							local nowSwing = tick()
						if nowSwing - (aimbotState.lastActivationTime or 0) >= 0.08 then
							pcall(bat.Activate, bat)
							aimbotState.lastActivationTime = nowSwing
						end
						end

					end
					return
				end

				-- Script 2 Bat Aimbot logic: DEFAULT and BYPASS are separate paths.
				if _G._AdaptBatMode == "BYPASS" then
					-- Crystal (Akatsuki) bat aimbot logic ported fully for BYPASS mode
					local function crystalRotateRoot(root, direction)
						if direction.Magnitude < 0.01 then return end
						local axis = root.CFrame.LookVector:Cross(direction.Unit)
						local angle = math.asin(math.clamp(axis.Magnitude, -1, 1))
						root.AssemblyAngularVelocity = axis.Magnitude > 0.01 and axis.Unit * angle * 80 or Vector3.zero
					end
local function getBypassAimbotSpeed()
						local speed
						if selectedMode == "Lagger" or laggerEnabled then
							speed = tonumber(speedValues.LaggerBoost) or 40
						else
							speed = tonumber(speedValues.CypherAimbotApproachSpeed) or aimbotConfig.FOLLOW_SPEED or 57
						end
						return math.clamp(speed, 1, 120)
					end

					local markerCFrame = nil
					do
						local getter = _G.__AkatsukiTPBatGetMarkerCFrame or _G.__CrystalTPBatGetMarkerCFrame
						if type(getter) == "function" then
							local ok, result = pcall(getter)
							if ok then markerCFrame = result end
						end
					end
					if markerCFrame then
						local markerDirection = markerCFrame.Position - currentRoot.Position
						crystalRotateRoot(currentRoot, markerDirection)
						if markerDirection.Magnitude > (aimbotConfig.MIN_FOLLOW_DISTANCE or 1) then
							local speed = getBypassAimbotSpeed()
							currentRoot.AssemblyLinearVelocity = markerDirection.Unit * speed
						else
							currentRoot.AssemblyLinearVelocity = Vector3.zero
						end
						return
					end

					aimbotState.targetPlayer = nearestTarget(currentRoot)
					local targetCharacter = aimbotState.targetPlayer and aimbotState.targetPlayer.Character
					local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
					local targetHumanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")
					if not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0 then resetTarget(); return end
					local targetPosition = targetRoot.Position
					if type(_G.__CrystalAntiVoidPositionForPlayer) == "function" then
						local ok, position = pcall(_G.__CrystalAntiVoidPositionForPlayer, aimbotState.targetPlayer, targetPosition)
						if ok and typeof(position) == "Vector3" then targetPosition = position end
					end
					local safeDelta = math.max(deltaTime or 0, 1 / 240)
					if aimbotState.lastTargetPos then
						local rawVelocity = (targetPosition - aimbotState.lastTargetPos) / safeDelta
						local velocityChange = rawVelocity - (aimbotState.targetVelocity or Vector3.zero)
						local maxChange = aimbotConfig.MAX_VELOCITY_CHANGE or 150
						if velocityChange.Magnitude > maxChange then
							rawVelocity = (aimbotState.targetVelocity or Vector3.zero) + velocityChange.Unit * maxChange
						end
						local horizontalVelocity = Vector3.new(rawVelocity.X, 0, rawVelocity.Z)
						local maxH = aimbotConfig.MAX_HORIZONTAL_VELOCITY or 80
						if horizontalVelocity.Magnitude > maxH then
							horizontalVelocity = horizontalVelocity.Unit * maxH
							rawVelocity = Vector3.new(horizontalVelocity.X, rawVelocity.Y, horizontalVelocity.Z)
						end
						aimbotState.targetVelocity = rawVelocity
						local smooth = aimbotConfig.VELOCITY_SMOOTHING or 0.2
						aimbotState.smoothedVelocity = ((aimbotState.smoothedVelocity or rawVelocity) * (1 - smooth)) + (rawVelocity * smooth)
						local function pushHistory(history, value, maximum)
							table.insert(history, value)
							while #history > maximum do table.remove(history, 1) end
						end
						local function averageVector(history)
							if #history == 0 then return Vector3.zero end
							local total = Vector3.zero
							for _, value in ipairs(history) do total = total + value end
							return total / #history
						end
						aimbotState.velocityHistory = aimbotState.velocityHistory or {}
						aimbotState.accelerationHistory = aimbotState.accelerationHistory or {}
						aimbotState.aerialVelocityHistory = aimbotState.aerialVelocityHistory or {}
						aimbotState.verticalVelocityHistory = aimbotState.verticalVelocityHistory or {}
						pushHistory(aimbotState.velocityHistory, aimbotState.smoothedVelocity, 8)
						local prev = aimbotState.velocityHistory[#aimbotState.velocityHistory - 1]
						if prev then
							pushHistory(aimbotState.accelerationHistory, (aimbotState.smoothedVelocity - prev) / safeDelta, 6)
						end
						local yVel = aimbotState.smoothedVelocity.Y
						if (aimbotState.lastYVelocity or 0) < -5 and yVel > 5 then
							aimbotState.airborneTime = 0
						end
						aimbotState.lastYVelocity = yVel
						if targetHumanoid.FloorMaterial == Enum.Material.Air or yVel > 2 then
							aimbotState.airborneTime = (aimbotState.airborneTime or 0) + safeDelta
							pushHistory(aimbotState.aerialVelocityHistory, Vector3.new(aimbotState.smoothedVelocity.X, 0, aimbotState.smoothedVelocity.Z), 6)
							pushHistory(aimbotState.verticalVelocityHistory, yVel, 6)
						else
							aimbotState.airborneTime = 0
							aimbotState.aerialVelocityHistory = {}
							aimbotState.verticalVelocityHistory = {}
						end
					end
					aimbotState.lastTargetPos = targetPosition

					local airborne = (aimbotState.airborneTime or 0) >= (aimbotConfig.MIN_AIRBORNE_TIME or 0.08)
					local predictionVelocity = aimbotState.smoothedVelocity or aimbotState.targetVelocity or Vector3.zero
					if airborne and aimbotState.aerialVelocityHistory and #aimbotState.aerialVelocityHistory > 0 then
						local total = Vector3.zero
						for _, value in ipairs(aimbotState.aerialVelocityHistory) do total = total + value end
						local aerialVelocity = total / #aimbotState.aerialVelocityHistory
						predictionVelocity = Vector3.new(aerialVelocity.X, (aimbotState.targetVelocity and aimbotState.targetVelocity.Y) or 0, aerialVelocity.Z) * (aimbotConfig.AIR_CONTROL_FACTOR or 0.8)
					end
					local quickTurn = false
					local horizontalVelocity = Vector3.new(predictionVelocity.X, 0, predictionVelocity.Z)
					if horizontalVelocity.Magnitude > 5 then
						local direction = horizontalVelocity.Unit
						if aimbotState.previousDirection and aimbotState.previousDirection:Dot(direction) < 0.5 then
							quickTurn = tick() - (aimbotState.lastDirectionChangeTime or 0) < (aimbotConfig.DIRECTION_CHANGE_DETECTION_TIME or 0.12)
							aimbotState.lastDirectionChangeTime = tick()
						end
						aimbotState.previousDirection = direction
					end
					local serverDelay = (aimbotState.currentPing or 0.1) + (aimbotConfig.SERVER_TICKRATE or (1 / 60))
					if quickTurn then serverDelay = serverDelay * (aimbotConfig.QUICK_DIRECTION_CHANGE_MULTIPLIER or 1.5) end
					local predicted = targetPosition + predictionVelocity * serverDelay
					if aimbotState.accelerationHistory and #aimbotState.accelerationHistory > 0 then
						local total = Vector3.zero
						for _, value in ipairs(aimbotState.accelerationHistory) do total = total + value end
						local acceleration = total / #aimbotState.accelerationHistory
						predicted = predicted + acceleration * (aimbotConfig.ACCELERATION_PREDICTION_WEIGHT or 0.3) * (serverDelay * serverDelay * 0.5)
					end
					local predictionTime = (aimbotConfig.PREDICTION_TIME or 0.22) * 1.1
					predicted = predicted + predictionVelocity * predictionTime
					if airborne then
						predicted = predicted + Vector3.new(0, -0.5 * (aimbotConfig.GRAVITY or 196.2) * predictionTime * predictionTime, 0)
					end
					local flatPredictionVelocity = Vector3.new(predictionVelocity.X, 0, predictionVelocity.Z)
					if flatPredictionVelocity.Magnitude > 1 then
						predicted = predicted + flatPredictionVelocity.Unit * (aimbotConfig.PREDICT_AHEAD or 3)
					end
					local toTarget = predicted - currentRoot.Position
					crystalRotateRoot(currentRoot, toTarget)
					if (targetPosition - currentRoot.Position).Magnitude <= (aimbotConfig.ACTIVATE_DISTANCE or 13)
						and tick() - (aimbotState.lastActivationTime or 0) >= 0.3 then
						if bat then pcall(bat.Activate, bat) end
						aimbotState.lastActivationTime = tick()
					end
					if toTarget.Magnitude > (aimbotConfig.MIN_FOLLOW_DISTANCE or 1) then
						local speed = getBypassAimbotSpeed()
						currentRoot.AssemblyLinearVelocity = toTarget.Unit * speed
					else
						currentRoot.AssemblyLinearVelocity = Vector3.new(0, currentRoot.AssemblyLinearVelocity.Y * 0.5, 0)
					end
					return
				end

				-- DEFAULT: Sound normal aimbot (sticky target + prediction + always swing). BYPASS path above stays original.
				local AIMBOT_STICKY_TIME = 1.25
				local AIMBOT_STICKY_MAX_DIST = 85
				local now = tick()
				local function stillValidTarget(plr)
					if not plr or not plr.Character then return false end
					local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
					local hum = plr.Character:FindFirstChildOfClass("Humanoid")
					if not tRoot or not hum or hum.Health <= 0 then return false end
					if (tRoot.Position - currentRoot.Position).Magnitude > AIMBOT_STICKY_MAX_DIST then return false end
					return true
				end
				local targetPlayer = nil
				if aimbotState.stickyTarget and now < (aimbotState.stickyUntil or 0) and stillValidTarget(aimbotState.stickyTarget) then
					targetPlayer = aimbotState.stickyTarget
				elseif now - (aimbotState.lastScan or 0) <= 0.08 and aimbotState.stickyTarget and stillValidTarget(aimbotState.stickyTarget) then
					targetPlayer = aimbotState.stickyTarget
				else
					aimbotState.lastScan = now
					targetPlayer = nearestTarget(currentRoot)
					aimbotState.stickyTarget = targetPlayer
					aimbotState.stickyUntil = now + AIMBOT_STICKY_TIME
				end
				local targetCharacter = targetPlayer and targetPlayer.Character
				local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
				local targetHumanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")
				aimbotState.targetPlayer = targetPlayer
				if not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0 then
					resetTarget()
					aimbotState.stickyTarget = nil
					currentHumanoid.AutoRotate = true
					currentRoot.AssemblyAngularVelocity = Vector3.zero
					return
				end
				currentHumanoid.AutoRotate = false
				local myPos = currentRoot.Position
				local targetPos = targetRoot.Position
				local targetVel = targetRoot.AssemblyLinearVelocity or Vector3.zero
				-- Prediction always on (Sound)
				local predictPos = targetPos + targetVel * 0.14 + targetRoot.CFrame.LookVector * 0.3
				local direction = predictPos - myPos
				local flatDir = Vector3.new(direction.X, 0, direction.Z)
				if flatDir.Magnitude > 0.01 then
					flatDir = flatDir.Unit
				else
					flatDir = Vector3.new(0, 0, 1)
				end
				local chaseSpeed = math.clamp(tonumber(speedValues.CypherAimbotApproachSpeed) or aimbotConfig.FOLLOW_SPEED or 58, 1, 200)
				if selectedMode == "Lagger" or laggerEnabled then
					chaseSpeed = math.clamp(tonumber(speedValues.LaggerBoost) or 40, 1, 200)
				end
				local desiredHeight = targetPos.Y + 3.7
				local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
				if currentHumanoid.FloorMaterial ~= Enum.Material.Air then
					yVel = math.max(yVel, 13)
				end
				yVel = math.clamp(yVel, -70, 110)
				local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
				currentRoot.AssemblyLinearVelocity = currentRoot.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)

				local speed3 = targetVel.Magnitude
				local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
				local predictedPos = targetPos + targetVel * predictTime
				local toPredict = predictedPos - myPos
				if toPredict.Magnitude > 0.1 then
					local goalCF = CFrame.lookAt(myPos, predictedPos)
					local diffCF = currentRoot.CFrame:Inverse() * goalCF
					local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
					rx = math.clamp(rx, -2.5, 2.5)
					ry = math.clamp(ry, -2.5, 2.5)
					rz = math.clamp(rz, -2.5, 2.5)
					currentRoot.AssemblyAngularVelocity = currentRoot.CFrame:VectorToWorldSpace(
						Vector3.new(rx * 42, ry * 42, rz * 42)
					)
				end

				-- Sound: free continuous swing (not distance-gated)
				local equipped = currentCharacter:FindFirstChild("Bat") or bat
				if equipped and equipped:IsA("Tool") and equipped.Parent == currentCharacter then
					local n = equipped.Name:lower()
					if n:find("bat", 1, true) or n:find("slap", 1, true) then
						pcall(function() equipped:Activate() end)
					end
				elseif bat and bat.Parent == currentCharacter then
					pcall(function() bat:Activate() end)
				end

			end)
		end

		_cypherStartFollowing = startSoundBatAimbot
		_cypherStop = stopSoundBatAimbot
		FeaturePostToggle["Aimbot"] = function(active)
			_G.__CrystalAimbotActive = active == true
			if active then
				if _G.__stopSpeedBoost then _G.__stopSpeedBoost() end
				if autoplayActive or toggleStates["Autoplay"] then _G.__stopAutoplay() end
				deactivateOtherAimbots("Aimbot")
				if _G.__deactivateBatExclusive then _G.__deactivateBatExclusive("Aimbot") end
				_G.__checkAndAutoDrop(function() startSoundBatAimbot(Player.Character) end)
			else
				stopSoundBatAimbot()
				if _G.__refreshSpeedBoost then _G.__refreshSpeedBoost() end
			end
		end
		_G.__CrystalTrackStopper(stopSoundBatAimbot)
		_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(character)
			task.wait(0.5)
			if toggleStates["Aimbot"] then startSoundBatAimbot(character) end
		end))
	end

	do
	local espEnabled = false
	local espActivePlayers = {}
	local espLoopConn = nil
	local Camera = workspace.CurrentCamera
	local GUI2_ESP_COLOR = Color3.fromRGB(70, 150, 240)
	local GUI2_ESP_TEXT_STROKE = Color3.fromRGB(16, 48, 92)
	local function getESPThemeColors(accent)
	-- ESP fill + tracers always follow the hub colour theme (purple / azure / green / halloween)
	local c = _G.__SoundAccentColor()
	return c, c
	end

	local function createESP()
	local currentFill, currentLine = getESPThemeColors()
	local esp = {
	Tracer = Drawing.new("Line"),
	Highlight = Instance.new("Highlight"),
	Lines = {}
	}

	esp.Tracer.Color = currentLine
	esp.Tracer.Thickness = 3
	esp.Tracer.Transparency = 1
	esp.Tracer.ZIndex = 2

	esp.Highlight.Name = "ESP_Highlight"
	esp.Highlight.FillColor = currentFill
	esp.Highlight.OutlineColor = _G.__SoundAccentColor()
	esp.Highlight.FillTransparency = 0.85
	esp.Highlight.OutlineTransparency = 0.35
	esp.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

	local parentGui
	local ok, robGui = pcall(function() return game:GetService("CoreGui"):FindFirstChild("RobloxGui") end)
	if ok and robGui then
	parentGui = robGui
	else
	parentGui = Player:FindFirstChildOfClass("PlayerGui")
	end
	if not parentGui then
	parentGui = game:GetService("CoreGui")
	end

	pcall(function() esp.Highlight.Parent = parentGui end)

	local nameBillboard = Instance.new("BillboardGui")
	nameBillboard.Name = "ESP_Name"
	nameBillboard.Size = UDim2.new(0, 170, 0, 28)
	nameBillboard.StudsOffset = Vector3.new(0, 1.3, 0)
	nameBillboard.AlwaysOnTop = true
	nameBillboard.Parent = parentGui

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0, 170, 0, 28)
	nameLabel.AnchorPoint = Vector2.new(0.5, 0)
	nameLabel.Position = UDim2.new(0.5, 0, 0, 2)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = tostring(currentPresetName or "")
	nameLabel.TextColor3 = _G.__SoundAccentColor()
	nameLabel.TextSize = 15
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextStrokeColor3 = _G.__CrystalGuiTheme == "GUI 2" and GUI2_ESP_TEXT_STROKE or Color3.fromRGB(0, 0, 0)
	nameLabel.TextStrokeTransparency = 0
	nameLabel.TextXAlignment = Enum.TextXAlignment.Center
	nameLabel.TextYAlignment = Enum.TextYAlignment.Center
	nameLabel.ZIndex = 5
	nameLabel.Parent = nameBillboard

	local nameOutline = Instance.new("UIStroke")
	nameOutline.Color = _G.__CrystalGuiTheme == "GUI 2" and GUI2_ESP_TEXT_STROKE or Color3.fromRGB(0, 0, 0)
	nameOutline.Thickness = 2.2
	nameOutline.Transparency = 0.12
	nameOutline.Parent = nameLabel
	for i = 1, 14 do
	local line = Drawing.new("Line")
	line.Color = currentLine
	line.Thickness = 2
	line.Transparency = 1
	line.ZIndex = 3
	table.insert(esp.Lines, line)
	end

	-- white belly dot, always on top so it shows through walls/bases
	local dotBillboard = Instance.new("BillboardGui")
	dotBillboard.Name = "ESP_BellyDot"
	dotBillboard.Size = UDim2.new(0, 12, 0, 12)
	dotBillboard.AlwaysOnTop = true
	dotBillboard.LightInfluence = 0
	dotBillboard.Enabled = false
	dotBillboard.Parent = parentGui
	local dotFrame = Instance.new("Frame")
	dotFrame.Size = UDim2.new(1, 0, 1, 0)
	dotFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	dotFrame.BorderSizePixel = 0
	dotFrame.Parent = dotBillboard
	Instance.new("UICorner", dotFrame).CornerRadius = UDim.new(1, 0)
	local dotStroke = Instance.new("UIStroke", dotFrame)
	dotStroke.Color = Color3.fromRGB(0, 0, 0)
	dotStroke.Thickness = 1
	esp.BellyDot = dotBillboard

	esp.NameTag = nameBillboard
	esp.NameLabel = nameLabel
	esp.NameOutline = nameOutline
	return esp
	end

	_G.__CrystalRefreshESPTheme = function(accent, outlineColor)
	local fillColor, lineColor = getESPThemeColors(accent)
	for _, data in pairs(espActivePlayers) do
	if type(data) == "table" and data.esp then
	local esp = data.esp
	if esp.Tracer then pcall(function() esp.Tracer.Color = lineColor end) end
	if esp.Highlight then
	esp.Highlight.FillColor = fillColor
	esp.Highlight.OutlineColor = _G.__SoundAccentColor()
	end
	if esp.NameLabel then
	esp.NameLabel.TextColor3 = _G.__SoundAccentColor()
	esp.NameLabel.TextStrokeColor3 = _G.__CrystalGuiTheme == "GUI 2" and GUI2_ESP_TEXT_STROKE or Color3.fromRGB(0, 0, 0)
	end
	if esp.NameOutline then
	esp.NameOutline.Color = _G.__CrystalGuiTheme == "GUI 2" and GUI2_ESP_TEXT_STROKE or Color3.fromRGB(0, 0, 0)
	end
	for _, line in ipairs(esp.Lines or {}) do pcall(function() line.Color = lineColor end) end
	end
	end
	end

	local function removeESP(plr)
	local data = espActivePlayers[plr]
	if data then
	if data.esp.Tracer then pcall(function() data.esp.Tracer:Remove() end) end
	if data.esp.Highlight then pcall(function() data.esp.Highlight:Destroy() end) end
	if data.esp.NameTag then pcall(function() data.esp.NameTag:Destroy() end) end
	if data.esp.BellyDot then pcall(function() data.esp.BellyDot:Destroy() end) end
	for _, line in ipairs(data.esp.Lines) do
	pcall(function() line:Remove() end)
	end
	if data.loopConn then pcall(function() data.loopConn:Disconnect() end) end
	espActivePlayers[plr] = nil
	end
	end

	local function updateESP(plr, esp)
	if not espEnabled then
	esp.Tracer.Visible = false
	esp.Highlight.Enabled = false
	if esp.BellyDot then pcall(function() esp.BellyDot.Enabled = false end) end
	for _, line in ipairs(esp.Lines) do line.Visible = false end
	return
	end

	local character = plr.Character
	local hum = character and character:FindFirstChildOfClass("Humanoid")
	local trackPart = character and (
	character:FindFirstChild("HumanoidRootPart")
	or character.PrimaryPart
	or character:FindFirstChild("UpperTorso")
	or character:FindFirstChild("Torso")
	or character:FindFirstChild("Head")
	)

	if character and trackPart and (not hum or hum.Health > 0) then
	esp.Highlight.Adornee = character
	esp.Highlight.Enabled = toggleStates["ESP Players"] or false

	local cam = workspace.CurrentCamera or Camera
	local _, onScreen = cam:WorldToViewportPoint(trackPart.Position)
	local themeNow = _G.__SoundAccentColor()
	esp.Highlight.FillColor = themeNow
	esp.Highlight.OutlineColor = themeNow

	esp.Tracer.Visible = false
	if onScreen and toggleStates["ESP Players"] then
		-- 2D box around the whole player (top of head to feet)
		local topV = cam:WorldToViewportPoint(trackPart.Position + Vector3.new(0, 3, 0))
		local botV = cam:WorldToViewportPoint(trackPart.Position - Vector3.new(0, 3.2, 0))
		local h = math.abs(botV.Y - topV.Y)
		local w = h * 0.6
		local cx = (topV.X + botV.X) / 2
		local x1, x2 = cx - w / 2, cx + w / 2
		local y1, y2 = math.min(topV.Y, botV.Y), math.max(topV.Y, botV.Y)
		local pts = {
			{Vector2.new(x1, y1), Vector2.new(x2, y1)},
			{Vector2.new(x2, y1), Vector2.new(x2, y2)},
			{Vector2.new(x2, y2), Vector2.new(x1, y2)},
			{Vector2.new(x1, y2), Vector2.new(x1, y1)},
		}
		for i, seg in ipairs(pts) do
			local line = esp.Lines[i]
			if line then
				line.From = seg[1]
				line.To = seg[2]
				line.Color = themeNow
				line.Thickness = 2
				line.Visible = true
			end
		end
		for i = 5, #esp.Lines do esp.Lines[i].Visible = false end
	else
		for _, line in ipairs(esp.Lines) do line.Visible = false end
	end

	if esp.BellyDot then
	pcall(function()
	esp.BellyDot.Adornee = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or trackPart
	esp.BellyDot.Enabled = toggleStates["ESP Players"] or false
	end)
	end
	if esp.NameTag and esp.NameLabel then
	pcall(function()
	esp.NameTag.Adornee = trackPart
	esp.NameTag.Enabled = toggleStates["ESP Players"] or false
	esp.NameLabel.Text = plr.Name or plr.DisplayName or ""
	local gui2Active = _G.__CrystalGuiTheme == "GUI 2"
	esp.NameLabel.TextColor3 = _G.__SoundAccentColor()
	esp.NameLabel.TextStrokeColor3 = gui2Active and GUI2_ESP_TEXT_STROKE or Color3.fromRGB(0, 0, 0)
	if esp.NameOutline then
	esp.NameOutline.Color = gui2Active and GUI2_ESP_TEXT_STROKE or Color3.fromRGB(0, 0, 0)
	end
	end)
	end
	else
	esp.Tracer.Visible = false
	esp.Highlight.Enabled = false
	esp.Highlight.Adornee = nil
	if esp.BellyDot then pcall(function() esp.BellyDot.Enabled = false end) end
	for _, line in ipairs(esp.Lines) do line.Visible = false end
	if esp.NameTag and esp.NameLabel then
	pcall(function()
	esp.NameTag.Enabled = false
	end)
	end
	end
	end

	local function createESPForPlayer(plr)
	if plr == Player then return end
	if espActivePlayers[plr] and espActivePlayers[plr].esp then
	if espActivePlayers[plr].esp.NameTag then
	pcall(function() espActivePlayers[plr].esp.NameTag.Enabled = toggleStates["ESP Players"] or false end)
	end
	if espActivePlayers[plr].esp.BellyDot then
	pcall(function() espActivePlayers[plr].esp.BellyDot.Enabled = toggleStates["ESP Players"] or false end)
	end
	return
	end
	removeESP(plr)
	local esp = createESP()
	espActivePlayers[plr] = {esp = esp}
	end

	local function enableESP()
	if espEnabled then return end; espEnabled = true
	for _, plr in pairs(Players:GetPlayers()) do
	if plr ~= Player then task.spawn(function() createESPForPlayer(plr) end) end
	end
	local espAccumulator = 0
	if espLoopConn then espLoopConn:Disconnect() end
	espLoopConn = RunService.Heartbeat:Connect((function(dt)
	espAccumulator = espAccumulator + (dt or 0)
	if espAccumulator < 0.50 then return end
	espAccumulator = 0
	for plr, data in pairs(espActivePlayers) do
	if typeof(plr) == "Instance" and plr:IsA("Player") and data and data.esp then
	pcall(function() updateESP(plr, data.esp) end)
	end
	end
	end))
	local joinConn = Players.PlayerAdded:Connect(function(plr)
	if not espEnabled or plr == Player then return end
	task.wait(0.3)
	createESPForPlayer(plr)
	end)
	local leaveConn = Players.PlayerRemoving:Connect(function(plr) removeESP(plr) end)
	espActivePlayers._joinConn = joinConn
	espActivePlayers._leaveConn = leaveConn
	end

local function disableESP()
	espEnabled = false
	if espLoopConn then espLoopConn:Disconnect(); espLoopConn = nil end
	if espActivePlayers._joinConn then pcall(function() espActivePlayers._joinConn:Disconnect() end); espActivePlayers._joinConn = nil end
	if espActivePlayers._leaveConn then pcall(function() espActivePlayers._leaveConn:Disconnect() end); espActivePlayers._leaveConn = nil end
	for plr in pairs(espActivePlayers) do
	if typeof(plr) == "Instance" and plr:IsA("Player") and plr ~= Player then removeESP(plr) end
end
end
_G.__CrystalTrackStopper(disableESP)
FeaturePostToggle["ESP Players"] = function(active)
if active then enableESP() else disableESP() end
end

if toggleStates["ESP Players"] then enableESP() end

	-- ==================== SKELETON ESP (FPS-safe Drawing bones) ====================
	do
		local skelOn = false
		local skelCache = {}
		local skelLoop, skelJoin, skelLeave = nil, nil, nil
		local skelFrame = 0
		local SKEL_COLOR = Color3.fromRGB(180, 220, 255)
		local SKEL_THICK = 1.4
		local R15_BONES = {
			{"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
			{"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
			{"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
			{"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
			{"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
		}
		local R6_BONES = {
			{"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
			{"Torso", "Left Leg"}, {"Torso", "Right Leg"},
		}

		local function makeLine()
			local ok, line = pcall(function() return Drawing.new("Line") end)
			if not ok or not line then return nil end
			line.Thickness = SKEL_THICK
			line.Color = SKEL_COLOR
			line.Transparency = 1
			line.Visible = false
			line.ZIndex = 2
			return line
		end

		local function clearPlayer(plr)
			local entry = skelCache[plr]
			if not entry then return end
			for _, line in ipairs(entry.lines or {}) do
				pcall(function() line.Visible = false; line:Remove() end)
			end
			for _, c in ipairs(entry.conns or {}) do pcall(function() c:Disconnect() end) end
			skelCache[plr] = nil
		end

		local function ensurePlayer(plr)
			if not plr or plr == Player or skelCache[plr] then return end
			local char = plr.Character
			local bones = R15_BONES
			if char and char:FindFirstChild("Torso") and not char:FindFirstChild("UpperTorso") then
				bones = R6_BONES
			end
			local lines = {}
			for _ = 1, #bones do
				local line = makeLine()
				if line then lines[#lines + 1] = line end
			end
			local entry = { lines = lines, bones = bones, conns = {} }
			skelCache[plr] = entry
			table.insert(entry.conns, plr.CharacterAdded:Connect(function()
				clearPlayer(plr)
				if skelOn then task.defer(function() ensurePlayer(plr) end) end
			end))
		end

		local function hideLines(entry)
			for _, line in ipairs(entry.lines) do
				if line.Visible then line.Visible = false end
			end
		end

		local function updateSkeleton()
			if not skelOn then return end
			skelFrame = skelFrame + 1
			if skelFrame % 2 ~= 0 then return end
			local cam = workspace.CurrentCamera
			if not cam then return end
			pcall(function()
				if type(_G.__SoundAccentColor) == "function" then
					local ok, col = pcall(_G.__SoundAccentColor)
					if ok and typeof(col) == "Color3" then SKEL_COLOR = col end
				end
			end)

			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= Player then
					if not skelCache[plr] then ensurePlayer(plr) end
					local entry = skelCache[plr]
					if entry then
						local char = plr.Character
						local hum = char and char:FindFirstChildOfClass("Humanoid")
						if not char or not hum or hum.Health <= 0 then
							hideLines(entry)
						else
							local bones = entry.bones or R15_BONES
							if char:FindFirstChild("Torso") and not char:FindFirstChild("UpperTorso") then
								if bones ~= R6_BONES or #entry.lines ~= #R6_BONES then
									for _, line in ipairs(entry.lines) do pcall(function() line:Remove() end) end
									entry.lines = {}
									entry.bones = R6_BONES
									bones = R6_BONES
									for _ = 1, #bones do
										local line = makeLine()
										if line then entry.lines[#entry.lines + 1] = line end
									end
								end
							end
							for i, pair in ipairs(bones) do
								local line = entry.lines[i]
								if line then
									local a = char:FindFirstChild(pair[1])
									local b = char:FindFirstChild(pair[2])
									if a and a:IsA("BasePart") and b and b:IsA("BasePart") then
										local p1, on1 = cam:WorldToViewportPoint(a.Position)
										local p2, on2 = cam:WorldToViewportPoint(b.Position)
										if p1.Z > 0 and p2.Z > 0 and (on1 or on2) then
											line.From = Vector2.new(p1.X, p1.Y)
											line.To = Vector2.new(p2.X, p2.Y)
											line.Color = SKEL_COLOR
											line.Visible = true
										else
											line.Visible = false
										end
									else
										line.Visible = false
									end
								end
							end
						end
					end
				end
			end
		end

		local function startSkeleton()
			if skelOn then return end
			skelOn = true
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= Player then ensurePlayer(plr) end
			end
			if skelJoin then pcall(function() skelJoin:Disconnect() end) end
			if skelLeave then pcall(function() skelLeave:Disconnect() end) end
			skelJoin = Players.PlayerAdded:Connect(function(plr)
				if skelOn then task.defer(function() ensurePlayer(plr) end) end
			end)
			skelLeave = Players.PlayerRemoving:Connect(function(plr) clearPlayer(plr) end)
			if skelLoop then pcall(function() skelLoop:Disconnect() end) end
			skelLoop = RunService.RenderStepped:Connect(updateSkeleton)
			if type(_G.__CrystalTrackConn) == "function" then
				pcall(_G.__CrystalTrackConn, skelLoop)
				pcall(_G.__CrystalTrackConn, skelJoin)
				pcall(_G.__CrystalTrackConn, skelLeave)
			end
		end

		local function stopSkeleton()
			skelOn = false
			if skelLoop then pcall(function() skelLoop:Disconnect() end); skelLoop = nil end
			if skelJoin then pcall(function() skelJoin:Disconnect() end); skelJoin = nil end
			if skelLeave then pcall(function() skelLeave:Disconnect() end); skelLeave = nil end
			for plr in pairs(skelCache) do clearPlayer(plr) end
		end

		FeaturePostToggle["Skeleton ESP"] = function(active)
			if active then startSkeleton() else stopSkeleton() end
		end
		_G.__CrystalTrackStopper(stopSkeleton)
		if toggleStates["Skeleton ESP"] then task.defer(startSkeleton) end
	end


	local oldTracer = _G.__CrystalPlayerTracerLine
	if oldTracer then pcall(function() oldTracer:Remove() end) end
	local tracerGui = Instance.new("ScreenGui")
	tracerGui.Name = "CrystalPlayerTracerOverlay"
	tracerGui.IgnoreGuiInset = true
	tracerGui.ResetOnSpawn = false
	tracerGui.DisplayOrder = 1000
	tracerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	tracerGui.Parent = Player:WaitForChild("PlayerGui")
	local playerTracer = Instance.new("Frame")
	playerTracer.Name = "ESPLine"
	playerTracer.AnchorPoint = Vector2.new(0.5, 0.5)
	playerTracer.BorderSizePixel = 0
	playerTracer.Active = false
	playerTracer.Visible = false
	playerTracer.ZIndex = 1
	playerTracer.Parent = tracerGui
	local tracerOutline = Instance.new("UIStroke", playerTracer)
	tracerOutline.Color = _G.__SoundAccentColor():Lerp(Color3.fromRGB(255, 255, 255), 0.5)
	tracerOutline.Thickness = 0.7
	tracerOutline.Transparency = 0.45
	_G.__CrystalPlayerTracerLine = {Remove = function() tracerGui:Destroy() end}
	_G.__CrystalTrackStopper(function() tracerGui:Destroy() end)
	local playerTracerState = { scanElapsed = math.huge, targetRoot = nil }

	_G.__CrystalTrackConn(RunService.RenderStepped:Connect((function(dt)
	if not toggleStates["Player Tracers"] then
	if playerTracer.Visible then playerTracer.Visible = false end
	playerTracerState.targetRoot = nil
	playerTracerState.scanElapsed = math.huge
	return
	end
	local ok = pcall(function()

	local activeCamera = workspace.CurrentCamera
	local myCharacter = Player.Character
	local myRoot = myCharacter and (myCharacter:FindFirstChild("LowerTorso") or myCharacter:FindFirstChild("HumanoidRootPart") or myCharacter:FindFirstChild("Torso"))
	if not activeCamera or not myRoot then
	playerTracer.Visible = false
	return
	end

	local myPosition = myRoot.Position
	playerTracerState.scanElapsed = playerTracerState.scanElapsed + (dt or 0)
	local cachedRoot = playerTracerState.targetRoot
	local cachedCharacter = cachedRoot and cachedRoot.Parent
	local cachedHumanoid = cachedCharacter and cachedCharacter:FindFirstChildOfClass("Humanoid")
	local cachedValid = cachedRoot and cachedRoot.Parent and (not cachedHumanoid or cachedHumanoid.Health > 0)

	if playerTracerState.scanElapsed >= 0.12 or not cachedValid then
	playerTracerState.scanElapsed = 0
	local closestRoot, closestDistanceSq = nil, math.huge
	for _, otherPlayer in ipairs(Players:GetPlayers()) do
	if otherPlayer ~= Player then
	local character = otherPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("LowerTorso") or character:FindFirstChild("Torso"))
	if root and root:IsA("BasePart") and (not humanoid or humanoid.Health > 0) then
	local delta = root.Position - myPosition
	local distanceSq = delta:Dot(delta)
	if distanceSq < closestDistanceSq then
	closestRoot, closestDistanceSq = root, distanceSq
	end
	end
	end
	end
	playerTracerState.targetRoot = closestRoot
	end

	local closestRoot = playerTracerState.targetRoot
	if not closestRoot or not closestRoot.Parent then
	playerTracer.Visible = false
	return
	end
	local closestPosition = closestRoot.Position

	local from = activeCamera:WorldToViewportPoint(myPosition - Vector3.new(0, myRoot.Size.Y * 0.35, 0))
	local to, targetOnScreen = activeCamera:WorldToViewportPoint(closestPosition)
	local viewport = activeCamera.ViewportSize
	local fromPoint = Vector2.new(from.X, from.Y)
	local targetPoint = Vector2.new(to.X, to.Y)

	if not targetOnScreen or to.Z <= 0 then
	local center = viewport * 0.5
	local direction = targetPoint - center
	if to.Z <= 0 then direction = -direction end
	if direction.Magnitude < 0.001 then direction = Vector2.new(0, -1) end
	local limit = Vector2.new(math.max(8, center.X - 8), math.max(8, center.Y - 8))
	local scaleX = limit.X / math.max(math.abs(direction.X), 0.001)
	local scaleY = limit.Y / math.max(math.abs(direction.Y), 0.001)
	targetPoint = center + direction * math.min(scaleX, scaleY)
	end

	if from.Z <= 0 or fromPoint.X < 0 or fromPoint.X > viewport.X or fromPoint.Y < 0 or fromPoint.Y > viewport.Y then
	fromPoint = Vector2.new(viewport.X * 0.5, viewport.Y - 8)
	end

	local delta = targetPoint - fromPoint
	local midpoint = (fromPoint + targetPoint) * 0.5
	playerTracer.Position = UDim2.fromOffset(midpoint.X, midpoint.Y)
	playerTracer.Size = UDim2.fromOffset(math.max(delta.Magnitude, 1), 2)
	playerTracer.Rotation = math.deg(math.atan2(delta.Y, delta.X))
	local _, tracerColor = getESPThemeColors()
	playerTracer.BackgroundColor3 = tracerColor
	playerTracer.Visible = true
	end)
	if not ok then pcall(function() playerTracer.Visible = false end) end
	end)))
	end

	local function makeToggleWithInput(parent, text, featureName, speedKey, fmtFn, parseFn)
	local container = Instance.new("Frame")
	container.Name = tostring(featureName or text or "Input") .. "Stub"
	container.BackgroundTransparency = 1
	container.Visible = false
	container.Parent = parent
	return {
	container = container,
	input = nil,
	activeRef = function() return toggleStates[featureName] == true end,
	}
	end

	local tabPages = {}
	local tabNames = {"Movement", "Combat", "Visuals"}

	local function createTabPage(name)
	local page = Instance.new("ScrollingFrame", ContentArea)
	page.Name = name .. "PageStub"
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 0
	page.Visible = false
	tabPages[name] = page
	end
	for _, name in ipairs(tabNames) do createTabPage(name) end

	local function selectSectionTab(selected)
	local selectedPage = tabPages[selected]
	if not selectedPage then return end
	for name, page in pairs(tabPages) do
	page.Visible = (name == selected)
	end
	end

	selectSectionTab("Movement")

	_speedCardRefs = _speedCardRefs or {}
	local function makeUraniumSpeedCard(parent, cardTitle, modeName, boostKey, stealKey, featureName)
	local container = Instance.new("Frame")
	container.Name = tostring(modeName or cardTitle or "Speed") .. "SpeedStub"
	container.BackgroundTransparency = 1
	container.Visible = false
	container.Parent = parent
	if featureName then
		if featureName == "SelectNormalMode" or featureName == "SelectLaggerMode" then
			FeatureToggles[featureName] = function()
				if toggleSpeedPair then return toggleSpeedPair(modeName) end
				return selectMode(modeName)
			end
		else
			FeatureToggles[featureName] = function() selectMode(modeName) end
		end
	end
	return container
	end

	local speedSection = makeUraniumSection(tabPages.Movement, "SPEED")
	makeUraniumSpeedCard(speedSection, "Normal Speed", "Normal", "NormalBoost", "NormalSteal", "SelectNormalMode")
	makeUraniumSpeedCard(speedSection, "Lagger Speed", "Lagger", "LaggerBoost", "LaggerSteal", "SelectLaggerMode")

	local function createCustomSpeedCard(cs)
	local featureName = "SelectCustomMode_" .. cs.name
	local boostKey = "CustomBoost_" .. cs.name
	local stealKey = "CustomSteal_" .. cs.name
	speedValues[boostKey] = cs.boost
	speedValues[stealKey] = cs.steal
	FeatureToggles[featureName] = function() selectMode(cs.name) end
	local card = makeUraniumSpeedCard(speedSection, cs.name, cs.name, boostKey, stealKey, featureName)
	local delBtn = Instance.new("TextButton", card)
	delBtn.Size = UDim2.new(0, 18, 0, 18)
	delBtn.AnchorPoint = Vector2.new(1, 1)
	delBtn.Position = UDim2.new(1, -8, 1, -8)
	delBtn.ZIndex = 30
	delBtn.BackgroundColor3 = Color3.fromRGB(240, 200, 200)
	delBtn.BorderSizePixel = 0
	delBtn.Text = "x"
	delBtn.TextColor3 = Color3.fromRGB(180, 60, 60)
	delBtn.TextSize = 11
	delBtn.Font = Enum.Font.GothamBold
	delBtn.AutoButtonColor = false
	delBtn.TextXAlignment = Enum.TextXAlignment.Center
	delBtn.TextYAlignment = Enum.TextYAlignment.Center
	Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 4)
	connectBtn(delBtn, function()
	for i = #customSpeeds, 1, -1 do
	if customSpeeds[i].name == cs.name then table.remove(customSpeeds, i) break end
	end
	if selectedMode == cs.name then selectMode("Normal") end
	pcall(function() card:Destroy() end)
	saveConfig()
	end)
	return card
	end

	for _, cs in ipairs(customSpeeds) do
	pcall(function() createCustomSpeedCard(cs) end)
	end

	do
	local addBtn = Instance.new("TextButton", speedSection)
	addBtn.Size = UDim2.new(1, -2, 0, 28)
	addBtn.BackgroundColor3 = Color3.fromRGB(235, 240, 245)
	addBtn.BackgroundTransparency = 0.55
	addBtn.BorderSizePixel = 0
	addBtn.Text = "+ Add Custom Speed"
	addBtn.Visible = false
	addBtn.TextColor3 = Color3.fromRGB(100, 140, 200)
	addBtn.TextSize = 11
	addBtn.Font = Enum.Font.GothamBold
	addBtn.AutoButtonColor = false
	Instance.new("UICorner", addBtn).CornerRadius = UDim.new(0, 6)
	local addStroke = Instance.new("UIStroke", addBtn)
	addStroke.Color = Color3.fromRGB(0, 0, 0)
	addStroke.Thickness = 1
	addStroke.Transparency = 0.3

	local formCard = nil
	connectBtn(addBtn, function()
	if formCard then pcall(function() formCard:Destroy() end) formCard = nil return end
	formCard = Instance.new("Frame", speedSection)
	formCard.Size = UDim2.new(1, -2, 0, 96)
	formCard.BackgroundColor3 = Color3.fromRGB(230, 238, 245)
	formCard.BorderSizePixel = 0
	Instance.new("UICorner", formCard).CornerRadius = UDim.new(0, 6)
	local formStroke = Instance.new("UIStroke", formCard)
	formStroke.Color = Color3.fromRGB(0, 0, 0)
	formStroke.Thickness = 1

	local nameLbl = Instance.new("TextLabel", formCard)
	nameLbl.Size = UDim2.new(0, 40, 0, 14)
	nameLbl.Position = UDim2.new(0, 8, 0, 6)
	nameLbl.BackgroundTransparency = 1
	nameLbl.Text = "Name"
	nameLbl.TextColor3 = Color3.fromRGB(100, 140, 190)
	nameLbl.TextSize = 9
	nameLbl.Font = Enum.Font.GothamBold
	nameLbl.TextXAlignment = Enum.TextXAlignment.Left
	local nameBox = Instance.new("TextBox", formCard)
	nameBox.Size = UDim2.new(0, 120, 0, 20)
	nameBox.Position = UDim2.new(0, 8, 0, 21)
	nameBox.BackgroundColor3 = Color3.fromRGB(245, 247, 250)
	nameBox.BorderSizePixel = 0
	nameBox.Text = ""
	nameBox.PlaceholderText = "My Speed"
	nameBox.Font = Enum.Font.GothamBold
	nameBox.TextSize = 11
	nameBox.TextColor3 = Color3.fromRGB(30, 90, 200)
	nameBox.ClearTextOnFocus = false
	Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 4)
	local nameStroke = Instance.new("UIStroke", nameBox)
	nameStroke.Color = Color3.fromRGB(0, 0, 0)
	nameStroke.Thickness = 1

	local boostLbl = Instance.new("TextLabel", formCard)
	boostLbl.Size = UDim2.new(0, 50, 0, 14)
	boostLbl.Position = UDim2.new(0, 140, 0, 6)
	boostLbl.BackgroundTransparency = 1
	boostLbl.Text = "Boost"
	boostLbl.TextColor3 = Color3.fromRGB(100, 140, 190)
	boostLbl.TextSize = 9
	boostLbl.Font = Enum.Font.GothamBold
	boostLbl.TextXAlignment = Enum.TextXAlignment.Left
	local boostBox = Instance.new("TextBox", formCard)
	boostBox.Size = UDim2.new(0, 56, 0, 20)
	boostBox.Position = UDim2.new(0, 140, 0, 21)
	boostBox.BackgroundColor3 = Color3.fromRGB(220, 238, 255)
	boostBox.BorderSizePixel = 0
	boostBox.Text = "59"
	boostBox.Font = Enum.Font.GothamBold
	boostBox.TextSize = 12
	boostBox.TextColor3 = Color3.fromRGB(30, 90, 200)
	boostBox.TextXAlignment = Enum.TextXAlignment.Center
	boostBox.ClearTextOnFocus = false
	Instance.new("UICorner", boostBox).CornerRadius = UDim.new(0, 5)
	local boostStroke2 = Instance.new("UIStroke", boostBox)
	boostStroke2.Color = Color3.fromRGB(0, 0, 0)
	boostStroke2.Thickness = 1

	local stealLbl = Instance.new("TextLabel", formCard)
	stealLbl.Size = UDim2.new(0, 50, 0, 14)
	stealLbl.Position = UDim2.new(0, 204, 0, 6)
	stealLbl.BackgroundTransparency = 1
	stealLbl.Text = "Steal"
	stealLbl.TextColor3 = Color3.fromRGB(100, 140, 190)
	stealLbl.TextSize = 9
	stealLbl.Font = Enum.Font.GothamBold
	stealLbl.TextXAlignment = Enum.TextXAlignment.Left
	local stealBox = Instance.new("TextBox", formCard)
	stealBox.Size = UDim2.new(0, 56, 0, 20)
	stealBox.Position = UDim2.new(0, 204, 0, 21)
	stealBox.BackgroundColor3 = Color3.fromRGB(220, 238, 255)
	stealBox.BorderSizePixel = 0
	stealBox.Text = "29"
	stealBox.Font = Enum.Font.GothamBold
	stealBox.TextSize = 12
	stealBox.TextColor3 = Color3.fromRGB(30, 90, 200)
	stealBox.TextXAlignment = Enum.TextXAlignment.Center
	stealBox.ClearTextOnFocus = false
	Instance.new("UICorner", stealBox).CornerRadius = UDim.new(0, 5)
	local stealStroke2 = Instance.new("UIStroke", stealBox)
	stealStroke2.Color = Color3.fromRGB(0, 0, 0)
	stealStroke2.Thickness = 1

	boostBox.InputChanged:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.TextInput then
	boostBox.Text = boostBox.Text:gsub("[^0-9]", "")
	end
	end)
	stealBox.InputChanged:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.TextInput then
	stealBox.Text = stealBox.Text:gsub("[^0-9]", "")
	end
	end)

	local confirmBtn = Instance.new("TextButton", formCard)
	confirmBtn.Size = UDim2.new(1, -16, 0, 24)
	confirmBtn.Position = UDim2.new(0, 8, 0, 50)
	confirmBtn.BackgroundColor3 = Color3.fromRGB(50, 130, 255)
	confirmBtn.BorderSizePixel = 0
	confirmBtn.Text = "Add Speed"
	confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	confirmBtn.TextSize = 11
	confirmBtn.Font = Enum.Font.GothamBold
	confirmBtn.AutoButtonColor = false
	Instance.new("UICorner", confirmBtn).CornerRadius = UDim.new(0, 5)

	local errLbl = Instance.new("TextLabel", formCard)
	errLbl.Size = UDim2.new(1, -16, 0, 14)
	errLbl.Position = UDim2.new(0, 8, 0, 78)
	errLbl.BackgroundTransparency = 1
	errLbl.Text = ""
	errLbl.TextColor3 = Color3.fromRGB(200, 60, 60)
	errLbl.TextSize = 9
	errLbl.Font = Enum.Font.GothamBold
	errLbl.TextXAlignment = Enum.TextXAlignment.Left

	connectBtn(confirmBtn, function()
	local cname = nameBox.Text:match("^%s*(.-)%s*$")
	local cboost = tonumber(boostBox.Text)
	local csteal = tonumber(stealBox.Text)
	if not cname or #cname < 1 then errLbl.Text = "Enter a name" return end
	if not cboost or cboost < 1 or cboost > 200 then errLbl.Text = "Boost: 1-200" return end
	if not csteal or csteal < 1 or csteal > 200 then errLbl.Text = "Steal: 1-200" return end
	for _, cs in ipairs(customSpeeds) do
	if cs.name == cname then errLbl.Text = "Name already exists" return end
	end
	if cname == "Normal" or cname == "Lagger" or cname == "Desync" then errLbl.Text = "Reserved name" return end
	local cs = { name = cname, boost = cboost, steal = csteal }
	table.insert(customSpeeds, cs)
	pcall(function() createCustomSpeedCard(cs) end)
	pcall(function() formCard:Destroy() end)
	formCard = nil
	saveConfig()
	end)
	end)
	end

	for _, ref in ipairs(_speedCardRefs) do if ref.updateVisual then pcall(ref.updateVisual) end end

	local movementSection = makeUraniumSection(tabPages.Movement, "MOVEMENT")
	local autoplayRow = makeToggle(movementSection, "Auto Play", "Autoplay")
	_G.__autoplayMode = "Semi"
	-- Legacy hidden placeholder; the real Auto Carry toggle is in the visible Speed tab below.
	do
	local carryRow = makeToggle(movementSection, "Carry Speed", "Carry Speed")

	local carryCard = nil
	for _, ch in ipairs(carryRow:GetChildren()) do
	if ch:IsA("TextButton") then carryCard = ch; break end
	end

	pcall(function() styleSmallToggle(carryRow) end)

	if carryCard then
	local vBtn = Instance.new("TextButton", carryCard)
	vBtn.Size = UDim2.new(0, 56, 0, 20)
	vBtn.Position = UDim2.new(1, -120, 0.5, -10)
	vBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	vBtn.BorderSizePixel = 0
	vBtn.Text = string.upper(carrySpeedMode)
	vBtn.TextColor3 = Color3.fromRGB(225,238,255)
	vBtn.TextSize = 10
	vBtn.Font = Enum.Font.GothamBold
	vBtn.AutoButtonColor = false
	vBtn.ZIndex = 10
	Instance.new("UICorner", vBtn).CornerRadius = UDim.new(0, 4)
	local vStroke = Instance.new("UIStroke", vBtn)
	vStroke.Color = Color3.fromRGB(255,255,255)
	vStroke.Thickness = 1
	vStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local function getBindPill()
	for _, c in ipairs(carryCard:GetChildren()) do
	if c:IsA("TextButton") and c ~= vBtn and c.Size.X.Offset == 48 and c.Position.X.Scale == 1 and c.Position.X.Offset == -54 then
	return c
	end
	end
	return nil
	end

	local function applyV1Mode()
	carrySpeedMode = "v1"
	vBtn.Text = "V1"
	vBtn.TextColor3 = Color3.fromRGB(225,238,255)
	vBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	vBtn.Position = UDim2.new(1, -120, 0.5, -10)
	local pill = getBindPill()
	if pill then pill.Visible = true end
	end

	local function applyV2Mode()
	carrySpeedMode = "v2"
	vBtn.Text = "V2"
	vBtn.TextColor3 = Color3.fromRGB(225,238,255)
	vBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	vBtn.Position = UDim2.new(1, -120, 0.5, -10)
	local pill = getBindPill()
	if pill then pill.Visible = true end
	end

	applyV2Mode()
	vBtn.Visible = false
	end
	end

	pcall(function()
	if _G and _G.__setNoPlayerCollision then _G.__setNoPlayerCollision(true) end
	end)

	local function styleSmallToggle(row)
	if not row then return end
	pcall(function()
	row.Size = UDim2.new(1, -2, 0, GUI_METRICS.compactCardH)
	for _, c in ipairs(row:GetChildren()) do
	if c:IsA("TextButton") then
	c.Size = UDim2.new(1, 0, 0, GUI_METRICS.compactCardH)
	c.BackgroundColor3 = Color3.fromRGB(25,31,42)
	c.BackgroundTransparency = 0.35
	c.BorderSizePixel = 0
	c.ZIndex = 21
	local corner = c:FindFirstChildOfClass("UICorner")
	if corner then corner.CornerRadius = UDim.new(0,5) else Instance.new("UICorner", c).CornerRadius = UDim.new(0,5) end
	local stroke = c:FindFirstChildOfClass("UIStroke")
	if stroke then stroke.Color = Color3.fromRGB(0,0,0); stroke.Thickness = 1; stroke.Transparency = 0 end
	break
	end
	end
	end)
	end

	pcall(function()
	local m = _featureToggleMap and _featureToggleMap["Autoplay"]
	if m and m.card and m.card.Parent then styleSmallToggle(m.card.Parent) end
	end)
	pcall(function()
	local m = _featureToggleMap and _featureToggleMap["Carry Speed"]
	if m and m.card and m.card.Parent then styleSmallToggle(m.card.Parent) end
	end)
	pcall(function()
	local m = _featureToggleMap and _featureToggleMap["TP Bat"]
	if m and m.card and m.card.Parent then styleSmallToggle(m.card.Parent) end
	end)

	_G.__CrystalInfJumpMode = _G.__CrystalInfJumpMode or "manual"
	makeToggleNoKeybind(movementSection, "Unwalk", "Unwalk")
	local infJumpToggleRow = makeToggleNoKeybind(movementSection, "Inf Jump", "Inf Jump")
	if infJumpToggleRow then
	local infJumpModeBtn = Instance.new("TextButton", infJumpToggleRow)
	infJumpModeBtn.Name = "InfJumpModeBtn"
	infJumpModeBtn.Size = UDim2.new(0, 66, 0, 20)
	infJumpModeBtn.Position = UDim2.new(1, -74, 0.5, -10)
	infJumpModeBtn.AnchorPoint = Vector2.new(0, 0)
	infJumpModeBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	infJumpModeBtn.BorderSizePixel = 0
	infJumpModeBtn.Text = (_G.__CrystalInfJumpMode == "hold") and "HOLD" or "MANUAL"
	infJumpModeBtn.TextColor3 = Color3.fromRGB(225,238,255)
	infJumpModeBtn.Font = Enum.Font.GothamBold
	infJumpModeBtn.TextSize = 10
	infJumpModeBtn.AutoButtonColor = false
	infJumpModeBtn.ZIndex = 30
	Instance.new("UICorner", infJumpModeBtn).CornerRadius = UDim.new(0, 4)
	local infJumpModeStroke = Instance.new("UIStroke", infJumpModeBtn)
	infJumpModeStroke.Color = Color3.fromRGB(255,255,255)
	infJumpModeStroke.Thickness = 1
	infJumpModeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local function updateInfJumpModeButton()
	local isHold = (_G.__CrystalInfJumpMode == "hold")
	infJumpModeBtn.Text = isHold and "HOLD" or "MANUAL"
	infJumpModeBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	infJumpModeBtn.TextColor3 = Color3.fromRGB(225,238,255)
	infJumpModeStroke.Color = Color3.fromRGB(255,255,255)
	infJumpModeStroke.Thickness = 1
	infJumpModeBtn.TextStrokeTransparency = 1
	end
	updateInfJumpModeButton()
	connectBtn(infJumpModeBtn, function()
	_G.__CrystalInfJumpMode = (_G.__CrystalInfJumpMode == "hold") and "manual" or "hold"
	updateInfJumpModeButton()
	if toggleStates["Inf Jump"] then
	if _G.__CrystalInfJumpMode == "hold" then
	startInfJump()
	else
	stopInfJump()
	end
	end
	end)
	end
	local tpDownRow = makeToggle(movementSection, "TP Down", "TP Down")
	pcall(function() styleSmallToggle(tpDownRow) end)
	makeToggleWithInput(movementSection, "Auto TP Down", "Auto TP Down", "AutoTPDownHeight",
	function(value) return tostring(math.floor((tonumber(value) or 20) + 0.5)) end,
	function(value) return math.clamp(math.floor((tonumber(value) or 20) + 0.5), 1, 1000) end)


	local combatSection = makeUraniumSection(tabPages.Combat, "COMBAT")
	makeToggleNoKeybind(combatSection, "Anti Ragdoll", "Anti Ragdoll")
	makeToggleNoKeybind(combatSection, "Ragdoll Counter", "Ragdoll Counter")
	makeToggleNoKeybind(combatSection, "Medusa Counter", "Medusa Counter")
	makeToggleNoKeybind(combatSection, "Medusa Range Circle", "Medusa Range Circle")
	makeToggleNoKeybind(combatSection, "Anti Bat", "Anti Bat")

	_G.__CrystalAntiDieGuiEnabled = function()
	return toggleStates["Anti Die"] == true
	end
	FeaturePostToggle["Anti Die"] = function(active)
	pcall(function() if _G.__CrystalAntiDieSource then _G.__CrystalAntiDieSource("toggle", active) end end)
	end
	makeToggleNoKeybind(combatSection, "Anti Die", "Anti Die")
	FeaturePostToggle["Anti Die"](toggleStates["Anti Die"] == true)


	do
	local aimbotRow = makeToggle(combatSection, "Aimbot", "Aimbot")
	pcall(function() styleSmallToggle(aimbotRow) end)
	end



;(function()
pcall(function()
local oldMarker = workspace:FindFirstChild("CrystalTPBatLastPosition")
if oldMarker then oldMarker:Destroy() end
end)
local tpBatState = {
enabled = false,
heartbeat = nil,
target = nil,
samples = {},
swingLocked = false,
nextSwingAt = 0,
lastSafeCFrame = nil,
lastPosition = nil,
lastSampleTime = 0,
recoverUntil = 0,
physicsPauseUntil = 0,
previousAutoRotate = nil,
lastTargetMarker = nil,
markerLocked = false,
markerTarget = nil,
markerBodyLock = nil,
markerBodyAttachment = nil,
}
_G.__batVersion = math.clamp(math.floor(tonumber(_G.__batVersion) or 1), 1, 2)
local getRig = (function()
local character = Player.Character
if not character then return nil, nil, nil end
return character, character:FindFirstChild("HumanoidRootPart"), character:FindFirstChildOfClass("Humanoid")
end)

local finiteVector = (function(vector)
return vector ~= nil
and vector.X == vector.X and vector.Y == vector.Y and vector.Z == vector.Z
and math.abs(vector.X) < 10000000
and math.abs(vector.Y) < 10000000
and math.abs(vector.Z) < 10000000
end)

local facingCFrame = (function(position, lookTargetPos, fallbackLook, keepCF)
local flat = Vector3.new(lookTargetPos.X - position.X, 0, lookTargetPos.Z - position.Z)
if flat.Magnitude > 0.05 then
return CFrame.lookAt(position, position + flat.Unit)
end
local flatFallback = fallbackLook and Vector3.new(fallbackLook.X, 0, fallbackLook.Z) or nil
if flatFallback and flatFallback.Magnitude >= 0.01 then
return CFrame.lookAt(position, position + flatFallback.Unit)
end
if keepCF then
local _, yaw = keepCF:ToEulerAnglesYXZ()
return CFrame.new(position) * CFrame.Angles(0, yaw, 0)
end
return CFrame.new(position)
end)

local TP_BAT_MARKER_DISTANCE = 3

local markerEngagementCFrame = (function(root, marker)
if not root or not marker then return nil end
local markerPosition = marker.Position
local away = Vector3.new(
root.Position.X - markerPosition.X,
0,
root.Position.Z - markerPosition.Z
)
if away.Magnitude <= 0.05 then
local look = marker.CFrame.LookVector
away = Vector3.new(-look.X, 0, -look.Z)
end
if away.Magnitude <= 0.05 then away = Vector3.new(0, 0, 1) end
local teleportPosition = markerPosition + away.Unit * TP_BAT_MARKER_DISTANCE
return facingCFrame(teleportPosition, markerPosition, marker.CFrame.LookVector, root.CFrame)
end)

local clearMarkerBodyLock = (function()
if tpBatState.markerBodyLock then
pcall(function() tpBatState.markerBodyLock:Destroy() end)
tpBatState.markerBodyLock = nil
end
if tpBatState.markerBodyAttachment then
pcall(function() tpBatState.markerBodyAttachment:Destroy() end)
tpBatState.markerBodyAttachment = nil
end
end)

local applyMarkerBodyLock = (function(root, marker)

clearMarkerBodyLock()
end)

_G.__CrystalTPBatApplyMarkerBodyLock = applyMarkerBodyLock
_G.__CrystalTPBatClearMarkerBodyLock = clearMarkerBodyLock

local safeTeleport = (function(root, targetCFrame)
	if not root or not targetCFrame then return false end
	local marker = tpBatState and tpBatState.lastTargetMarker
	if marker and marker.Parent and marker.Transparency and marker.Transparency < 1 then

		return false
	end
	local ok = pcall(function()
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		root.CFrame = targetCFrame
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
	end)
	return ok
end)

local TP_BAT_MIN_X, TP_BAT_MAX_X = -536.2, -422
local TP_BAT_MIN_Y, TP_BAT_MAX_Y = -10, 75
local TP_BAT_MIN_Z, TP_BAT_MAX_Z = -71.8, 192.9
local TP_BAT_MARKER_GROUND_Y = -7
local TP_BAT_MARKER_LOOKBACK = 0.2

local isInsideAllowedArea = (function(position)
if not position then return false end
return position.X >= TP_BAT_MIN_X and position.X <= TP_BAT_MAX_X
and position.Y >= TP_BAT_MIN_Y and position.Y <= TP_BAT_MAX_Y
and position.Z >= TP_BAT_MIN_Z and position.Z <= TP_BAT_MAX_Z
end)

_G.__CrystalTPBatIsInsideMap = isInsideAllowedArea

local updateLastTargetMarker = (function(targetCFrame)
if true then return end
if tpBatState.markerLocked then return end

	local tracked = tpBatState.markerTarget
	local character = tracked and tracked.Parent == Players and tracked.Character
	local targetRoot = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not targetRoot or not humanoid or humanoid.Health <= 0
	or not finiteVector(targetRoot.Position) or isInsideAllowedArea(targetRoot.Position) then return end
if not targetCFrame or not isInsideAllowedArea(targetCFrame.Position) then return end

local groundMarkerCFrame = CFrame.new(
targetCFrame.Position.X,
TP_BAT_MARKER_GROUND_Y,
targetCFrame.Position.Z
) * targetCFrame.Rotation
local marker = tpBatState.lastTargetMarker
if not marker or not marker.Parent then
marker = Instance.new("Part")
marker.Name = "CrystalTPBatLastPosition"
marker.Shape = Enum.PartType.Ball
marker.Size = Vector3.new(3, 3, 3)
marker.Color = Color3.fromRGB(0, 110, 255)
marker.Material = Enum.Material.Neon
marker.Anchored = true
marker.CanCollide = false
marker.CanTouch = false
marker.CanQuery = false
marker.CastShadow = false
marker.Parent = workspace

local overlaySphere = Instance.new("SphereHandleAdornment")
overlaySphere.Name = "AlwaysOnTopSphere"
overlaySphere.Adornee = marker
overlaySphere.Radius = 1.55
overlaySphere.Color3 = Color3.fromRGB(0, 125, 255)
overlaySphere.Transparency = 0.05
overlaySphere.AlwaysOnTop = true
overlaySphere.Visible = true
overlaySphere.ZIndex = 10
overlaySphere.Parent = marker

local highlight = Instance.new("Highlight")
highlight.Name = "LastPositionHighlight"
highlight.Adornee = marker
highlight.FillColor = Color3.fromRGB(0, 110, 255)
highlight.FillTransparency = 0.15
highlight.OutlineColor = Color3.fromRGB(120, 200, 255)
highlight.OutlineTransparency = 0
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.Enabled = true
highlight.Parent = marker

local billboard = Instance.new("BillboardGui")
billboard.Name = "LastPositionLabel"
billboard.Size = UDim2.new(0, 110, 0, 20)
billboard.StudsOffset = Vector3.new(0, 2.1, 0)
billboard.AlwaysOnTop = true
billboard.Adornee = marker
billboard.Parent = marker

local label = Instance.new("TextLabel")
label.Name = "Text"
label.Size = UDim2.fromScale(1, 1)
label.BackgroundTransparency = 1
label.Text = "ultima posicion"
label.TextColor3 = Color3.fromRGB(220, 235, 255)
label.TextStrokeColor3 = Color3.fromRGB(0, 35, 90)
label.TextStrokeTransparency = 0.25
label.TextSize = 11
label.Font = Enum.Font.GothamMedium
label.Parent = billboard

tpBatState.lastTargetMarker = marker
end
marker.Transparency = 0
local overlaySphere = marker:FindFirstChild("AlwaysOnTopSphere")
if overlaySphere then overlaySphere.Visible = true end
local highlight = marker:FindFirstChild("LastPositionHighlight")
if highlight then highlight.Enabled = true end
local billboard = marker:FindFirstChild("LastPositionLabel")
if billboard then billboard.Enabled = true end
marker.CFrame = groundMarkerCFrame
tpBatState.markerLocked = true
end)

local clearLastTargetMarker = (function()
tpBatState.markerLocked = false
clearMarkerBodyLock()
if tpBatState.lastTargetMarker then
pcall(function()
tpBatState.lastTargetMarker.Transparency = 1
local overlaySphere = tpBatState.lastTargetMarker:FindFirstChild("AlwaysOnTopSphere")
if overlaySphere then overlaySphere.Visible = false end
local highlight = tpBatState.lastTargetMarker:FindFirstChild("LastPositionHighlight")
if highlight then highlight.Enabled = false end
local billboard = tpBatState.lastTargetMarker:FindFirstChild("LastPositionLabel")
if billboard then billboard.Enabled = false end
end)
end
end)

_G.__CrystalTPBatGetMarkerCFrame = function()
local marker = tpBatState.lastTargetMarker
if tpBatState.markerLocked and marker and marker.Parent and marker.Transparency < 1 then
local tracked = tpBatState.markerTarget
local trackedRoot = tracked and tracked.Character and tracked.Character:FindFirstChild("HumanoidRootPart")
if trackedRoot and isInsideAllowedArea(trackedRoot.Position) then
clearLastTargetMarker()
return nil
end
local _, root = getRig()
return markerEngagementCFrame(root, marker) or marker.CFrame
end
return nil
end

_G.__CrystalTPBatTrackTarget = function(player)
if player and player ~= Player and player.Parent == Players then
tpBatState.markerTarget = player
return player
end
return nil
end
_G.__CrystalTPBatTrackTargetOld = function(player)
if tpBatState.markerLocked then return tpBatState.markerTarget end

local current = tpBatState.markerTarget
local currentCharacter = current and current.Parent == Players and current.Character
local currentHumanoid = currentCharacter and currentCharacter:FindFirstChildOfClass("Humanoid")
local currentRoot = currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart")
local currentSample = current and tpBatState.samples[current]
if current and current.Parent == Players then

if currentHumanoid and currentHumanoid.Health > 0
and ((currentRoot and isInsideAllowedArea(currentRoot.Position))
or (currentSample and currentSample.safeCFrame)) then return current end
if not currentHumanoid and currentSample and currentSample.safeCFrame then return current end
end
if player and player ~= Player and player.Parent == Players then
tpBatState.markerTarget = player
return player
end
return tpBatState.markerTarget
end

_G.__CrystalTPBatClearMarkerTracking = function()
tpBatState.target = nil

end

local targetAlive = (function(player, myRoot)
if not player or player.Parent ~= Players or not player.Character then return false end
local root = player.Character:FindFirstChild("HumanoidRootPart")
local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
if not root or not humanoid or humanoid.Health <= 0 or not isInsideAllowedArea(root.Position) then
return false
end
return true
end)

local getSnapshotBeforeExit = (function(sample, now)
if not sample or not sample.history or #sample.history == 0 then return nil end
local cutoff = now - TP_BAT_MARKER_LOOKBACK
local selected = nil
for _, entry in ipairs(sample.history) do
if entry.time <= cutoff then
selected = entry
else
break
end
end

return selected or sample.history[1]
end)

_G.__CrystalTPBatForceMarker = function(player, fallbackCFrame)
if player and player.Parent == Players then
tpBatState.markerTarget = player
end
local sample = player and tpBatState.samples[player]
local snapshot = getSnapshotBeforeExit(sample, tick())
local remembered = snapshot and snapshot.safeCFrame or (sample and sample.safeCFrame)
if not remembered and fallbackCFrame and isInsideAllowedArea(fallbackCFrame.Position) then
remembered = fallbackCFrame
end
if remembered then updateLastTargetMarker(remembered) end
return _G.__CrystalTPBatGetMarkerCFrame()
end

local monitorLastTarget = (function()
local _, myRoot = getRig()
if not myRoot then return end

local tracked = nil
	if false and tracked and tracked.Parent == Players then
local targetRoot = tracked.Character and tracked.Character:FindFirstChild("HumanoidRootPart")
local targetHumanoid = tracked.Character and tracked.Character:FindFirstChildOfClass("Humanoid")
local sample = tpBatState.samples[tracked] or {}
tpBatState.samples[tracked] = sample

if targetRoot and targetHumanoid and targetHumanoid.Health > 0 and finiteVector(targetRoot.Position) then
if isInsideAllowedArea(targetRoot.Position) then
local now = tick()
if tpBatState.markerLocked then
sample.history = {}
end
sample.history = sample.history or {}
table.insert(sample.history, {
time = now,
safePosition = targetRoot.Position,
safeCFrame = targetRoot.CFrame,
})

while sample.history[1] and now - sample.history[1].time > (TP_BAT_MARKER_LOOKBACK + 0.25) do
table.remove(sample.history, 1)
end
sample.safePosition = targetRoot.Position
sample.safeCFrame = targetRoot.CFrame
clearLastTargetMarker()
else
local snapshot = getSnapshotBeforeExit(sample, tick())
updateLastTargetMarker((snapshot and snapshot.safeCFrame) or sample.safeCFrame)
end
end
		if (targetHumanoid and targetHumanoid.Health <= 0)
		or (not targetRoot and not sample.safeCFrame) then
		tpBatState.markerTarget = nil
		clearLastTargetMarker()
		else
		return
		end
end

local closest, closestDistanceSq = nil, math.huge
for _, player in ipairs(Players:GetPlayers()) do
if player ~= Player and targetAlive(player) then
local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
local delta = targetRoot.Position - myRoot.Position
local distanceSq = delta:Dot(delta)
if distanceSq < closestDistanceSq then
closest = player
closestDistanceSq = distanceSq
end
end
end

if closest then
tpBatState.markerTarget = closest
local targetRoot = closest.Character:FindFirstChild("HumanoidRootPart")
local sample = tpBatState.samples[closest] or {}
tpBatState.samples[closest] = sample
sample.safePosition = targetRoot.Position
sample.safeCFrame = targetRoot.CFrame
sample.history = {
{ time = tick(), safePosition = targetRoot.Position, safeCFrame = targetRoot.CFrame }
}
end
end)

local markerMonitorAccumulator = 0
local TP_BAT_MARKER_INTERVAL = 1 / 60
local markerMonitor = RunService.Heartbeat:Connect((function(dt)

markerMonitorAccumulator = markerMonitorAccumulator + (dt or 0)
if markerMonitorAccumulator < TP_BAT_MARKER_INTERVAL then return end
markerMonitorAccumulator = markerMonitorAccumulator % TP_BAT_MARKER_INTERVAL
monitorLastTarget()
end))
_G.__CrystalTrackConn(markerMonitor)

local function followPreservedMarker(root)
local markerCFrame = _G.__CrystalTPBatGetMarkerCFrame()
if not markerCFrame then
clearMarkerBodyLock()
return false
end
pcall(function()
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
root.CFrame = markerCFrame
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
end)
local marker = tpBatState.lastTargetMarker
if marker then applyMarkerBodyLock(root, marker) end
return true
end
_G.__CrystalTrackStopper(function() pcall(clearLastTargetMarker) end)

	do
	local tpBatState = {
	enabled = false,
	heartbeat = nil,
	target = nil,
	samples = {},
	swingLocked = false,
	nextSwingAt = 0,
	lastSafeCFrame = nil,
	lastPosition = nil,
	lastSampleTime = 0,
	recoverUntil = 0,
	physicsPauseUntil = 0,
	previousAutoRotate = nil,
	lastTargetMarker = nil,
	markerLocked = false,
	markerTarget = nil,
	}
	_G.__batVersion = math.clamp(math.floor(tonumber(_G.__batVersion) or 1), 1, 2)
	local TP_BAT_RATE = 67
	local TP_BAT_COOLDOWN = 1 / TP_BAT_RATE

	local BAT_NAMES = {
	"Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap",
	"Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap",
	"Nuclear Slap", "Galaxy Slap", "Glitched Slap",
	}

	local function getRig()
	local character = Player.Character
	if not character then return nil, nil, nil end
	return character, character:FindFirstChild("HumanoidRootPart"), character:FindFirstChildOfClass("Humanoid")
	end

	local function findBat(equip)
	local character, _, humanoid = getRig()
	if not character then return nil end

	for _, name in ipairs(BAT_NAMES) do
	local tool = character:FindFirstChild(name)
	if tool and tool:IsA("Tool") then return tool end
	end
	for _, child in ipairs(character:GetChildren()) do
	if child:IsA("Tool") then
	local name = child.Name:lower()
	if name:find("bat", 1, true) or name:find("slap", 1, true) then
	return child
	end
	end
	end

	local backpack = Player:FindFirstChildOfClass("Backpack")
	if backpack then
	local found = nil
	for _, name in ipairs(BAT_NAMES) do
	local tool = backpack:FindFirstChild(name)
	if tool and tool:IsA("Tool") then found = tool; break end
	end
	if not found then
	for _, child in ipairs(backpack:GetChildren()) do
	if child:IsA("Tool") then
	local name = child.Name:lower()
	if name:find("bat", 1, true) or name:find("slap", 1, true) then
	found = child
	break
	end
	end
	end
	end
	if found and equip and humanoid then
	pcall(function() humanoid:EquipTool(found) end)
	end
	return found
	end
	return nil
	end

	local function finiteVector(vector)
	return vector.X == vector.X and vector.Y == vector.Y and vector.Z == vector.Z
	and math.abs(vector.X) < 10000000
	and math.abs(vector.Y) < 10000000
	and math.abs(vector.Z) < 10000000
	end

	local function facingCFrame(position, lookTargetPos, fallbackLook, keepCF)
	local flat = Vector3.new(lookTargetPos.X - position.X, 0, lookTargetPos.Z - position.Z)
	if flat.Magnitude > 0.05 then
	return CFrame.lookAt(position, position + flat.Unit)
	end
	local flatFallback = fallbackLook and Vector3.new(fallbackLook.X, 0, fallbackLook.Z) or nil
	if flatFallback and flatFallback.Magnitude >= 0.01 then
	return CFrame.lookAt(position, position + flatFallback.Unit)
	end
	if keepCF then
	local _, yaw = keepCF:ToEulerAnglesYXZ()
	return CFrame.new(position) * CFrame.Angles(0, yaw, 0)
	end
	return CFrame.new(position)
	end

	local function isInsideAllowedArea(position)
	return position ~= nil
	end

	local function clearLastTargetMarker() end
	local function targetAlive(player, myRoot)
	if not player or player.Parent ~= Players or not player.Character then return false end
	local root = player.Character:FindFirstChild("HumanoidRootPart")
	local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
	if not root or not humanoid or humanoid.Health <= 0 or not finiteVector(root.Position) then
	return false
	end
	local sample = tpBatState.samples[player]
	return _G.__CrystalTPBatIsInsideMap(root.Position)
	or (sample ~= nil and sample.safeCFrame ~= nil)
	end

	local function getRememberedTargetCFrame(player, myRoot)
	local sample = player and tpBatState.samples[player]
	local saved = sample and sample.safeCFrame
	if saved and isInsideAllowedArea(saved.Position)
	and (not myRoot or isInsideAllowedArea(saved.Position)) then
	return saved
	end
	return nil
	end

	local function closestTarget(myRoot)

	local closest = nil
	local closestDistance = math.huge
	for _, player in ipairs(Players:GetPlayers()) do
	if player ~= Player and targetAlive(player, myRoot) then
	local root = player.Character:FindFirstChild("HumanoidRootPart")
	if root then
	local distance = (root.Position - myRoot.Position).Magnitude
	if distance < closestDistance then
	closest = player
	closestDistance = distance
	end
	end
	end
	end
	if closest then
	tpBatState.target = closest
	_G.__CrystalTPBatTrackTarget(closest)
	end
	return closest
	end

	local function getTPBatDistance()
	return 3
	end

	local function swingBat()
	local now = tick()
	if tpBatState.swingLocked or now < tpBatState.nextSwingAt then return end
	tpBatState.swingLocked = true
	tpBatState.nextSwingAt = now + TP_BAT_COOLDOWN

	pcall(function()
	local character = Player.Character
	if not character then return end
	local tool = findBat(true)
	if not tool then return end
	if tool.Parent ~= character then
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then humanoid:EquipTool(tool) end
	end
	tool:Activate()
	local remote = tool:FindFirstChildWhichIsA("RemoteEvent", true)
	if remote then pcall(function() remote:FireServer() end) end
	end)

	task.delay(TP_BAT_COOLDOWN, function()
	tpBatState.swingLocked = false
	end)
	end

	local function resetPhysicsRoot(root)
	if sethiddenproperty then
	pcall(function() sethiddenproperty(root, "PhysicsRepRootPart", root) end)
	end
	end

	local function desktopHeartbeatStep()
	if not tpBatState.enabled then return end
	local character, root, humanoid = getRig()
	if not character or not root or not humanoid or humanoid.Health <= 0 then return end

	if followPreservedMarker(root) then
	swingBat()
	return
	end
	if tpBatState.previousAutoRotate == nil then tpBatState.previousAutoRotate = humanoid.AutoRotate end
	humanoid.AutoRotate = false

	findBat(true)
	local target = closestTarget(root)
	if target then
	local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
	local rememberedCFrame = getRememberedTargetCFrame(target, root)

	if not targetRoot or not finiteVector(targetRoot.Position) then return end
	if not _G.__CrystalTPBatIsInsideMap(targetRoot.Position) then
	_G.__CrystalTPBatForceMarker(target, rememberedCFrame)
	if followPreservedMarker(root) then swingBat() end
	return
	end
	local targetCFrame = targetRoot.CFrame
	local sample = tpBatState.samples[target] or {}
	tpBatState.samples[target] = sample
	sample.safeCFrame = targetRoot.CFrame
	sample.safePosition = targetRoot.Position
	local targetPos = targetCFrame.Position + Vector3.new(0, 0.9, 0)
	local targetLook = targetCFrame.LookVector
		if (root.Position - targetPos).Magnitude > getTPBatDistance() then

		safeTeleport(root, facingCFrame(targetPos, targetCFrame.Position, targetLook, root.CFrame))
		else

		safeTeleport(root, facingCFrame(root.Position, targetCFrame.Position, targetLook, root.CFrame))
		end

	if sethiddenproperty then
	pcall(function()
	if targetRoot then sethiddenproperty(root, "PhysicsRepRootPart", targetRoot) end
	end)
	end
	local cam = workspace.CurrentCamera
	if cam then
	pcall(function() cam.CFrame = CFrame.new(cam.CFrame.Position, targetCFrame.Position) end)
	end
	swingBat()
	end
	end

	local function zurichV2HeartbeatStep()
	if not tpBatState.enabled then return end
	local character, root, humanoid = getRig()
	if not character or not root or not humanoid or humanoid.Health <= 0 then return end

	if followPreservedMarker(root) then
	swingBat()
	return
	end
	if tpBatState.previousAutoRotate == nil then tpBatState.previousAutoRotate = humanoid.AutoRotate end
	humanoid.AutoRotate = false

	local target = closestTarget(root)
	if not target then return end
	local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
	local rememberedCFrame = getRememberedTargetCFrame(target, root)
	local targetCFrame = targetRoot and targetRoot.CFrame or rememberedCFrame
	local usingRememberedPosition = not targetRoot
	local markerTrigger = false

	if targetRoot then
	local sample = tpBatState.samples[target] or {}
	tpBatState.samples[target] = sample
	markerTrigger = targetRoot.Position.Y < -9
	or not _G.__CrystalTPBatIsInsideMap(targetRoot.Position)
	or not finiteVector(targetRoot.Position)
	local validSnapshot = finiteVector(targetRoot.Position)
	and _G.__CrystalTPBatIsInsideMap(targetRoot.Position)
	if validSnapshot then
	sample.safeCFrame = targetRoot.CFrame
	sample.safePosition = targetRoot.Position
	else
	targetCFrame = rememberedCFrame
	usingRememberedPosition = true
	end
	end

	if not targetCFrame then return end
	if usingRememberedPosition and markerTrigger then
	_G.__CrystalTPBatForceMarker(target, targetCFrame)
	if followPreservedMarker(root) then
	swingBat()
	return
	end
	end

	local targetPosition = targetCFrame.Position
	if not usingRememberedPosition then
	targetPosition = targetPosition + Vector3.new(0, 0.9, 0)
	end
	local engagement
	if (root.Position - targetPosition).Magnitude > getTPBatDistance() then
	engagement = facingCFrame(targetPosition, targetCFrame.Position, targetCFrame.LookVector, root.CFrame)
	else
	engagement = facingCFrame(root.Position, targetCFrame.Position, targetCFrame.LookVector, root.CFrame)
	end
	safeTeleport(root, engagement)

	if sethiddenproperty then
	pcall(function()
	if targetRoot then sethiddenproperty(root, "PhysicsRepRootPart", targetRoot) end
	end)
	end
	local camera = workspace.CurrentCamera
	if camera then
	pcall(function() camera.CFrame = CFrame.new(camera.CFrame.Position, targetCFrame.Position) end)
	end
	swingBat()
	end

	local function inspectMobileTarget(player, targetRoot, myRoot)
	if not targetAlive(player, myRoot) or not targetRoot then return true, nil end

	local now = tick()
	local position = targetRoot.Position
	local velocity = targetRoot.AssemblyLinearVelocity
	local sample = tpBatState.samples[player] or {}
	tpBatState.samples[player] = sample

	local destroyHeight = workspace.FallenPartsDestroyHeight or -500
	local voidFloor = math.max(destroyHeight + 90, -50)
	local deltaTime = sample.time and math.max(now - sample.time, 1 / 240) or math.huge
	local delta = sample.position and (position - sample.position) or Vector3.zero
	local impossibleStep = sample.position ~= nil and deltaTime < 0.4 and (delta.Magnitude > 90 or math.abs(delta.Y) > 38)
	local badVelocity = not finiteVector(velocity) or velocity.Magnitude > 100 or math.abs(velocity.Y) > 150
	local badPosition = not finiteVector(position) or position.Y <= voidFloor or position.Y > 650 or (myRoot and (position - myRoot.Position).Magnitude > 4000)

	if badPosition or badVelocity or impossibleStep then
	sample.suspiciousUntil = now + 1.35
	elseif now >= (sample.suspiciousUntil or 0) then
	sample.safePosition = position
	sample.safeCFrame = targetRoot.CFrame
	end
	sample.position = position
	sample.time = now
	return now < (sample.suspiciousUntil or 0), sample
	end

	local function guardMobileAgainstVoid(root, humanoid, targetRoot)
	local now = tick()
	local position = root.Position
	local velocity = root.AssemblyLinearVelocity
	local destroyHeight = workspace.FallenPartsDestroyHeight or -500
	local voidFloor = math.max(destroyHeight + 80, -55)
	local deltaTime = now - (tpBatState.lastSampleTime or now)
	local suddenDrop = tpBatState.lastPosition and deltaTime <= 0.35 and position.Y < tpBatState.lastPosition.Y - 40
	local suddenRise = tpBatState.lastPosition and deltaTime <= 0.35 and position.Y > tpBatState.lastPosition.Y + 25
	local forcedLaunch = math.abs(velocity.Y) > 90 or velocity.Magnitude > 450
	local invalidHeight = position.Y <= voidFloor or position.Y > 400
	local recovering = now < tpBatState.recoverUntil

	if invalidHeight or suddenDrop or suddenRise or forcedLaunch then
	resetPhysicsRoot(root)
	local recovery = tpBatState.lastSafeCFrame
	if targetRoot and targetRoot.Parent and targetRoot.Position.Y > voidFloor + 10 and targetRoot.Position.Y < 350 then
	local positionOnTarget = targetRoot.Position + Vector3.new(0, 0.9, 0)
	recovery = facingCFrame(positionOnTarget, targetRoot.Position, targetRoot.CFrame.LookVector)
	end
	pcall(function()
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	humanoid.PlatformStand = false
	humanoid.Sit = false
	humanoid.AutoRotate = true
	humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	if recovery then safeTeleport(root, recovery) end
	end)
	tpBatState.recoverUntil = now + 0.55
	tpBatState.physicsPauseUntil = now + 0.20
	recovering = true
	elseif not recovering and position.Y > voidFloor + 15 and math.abs(velocity.Y) < 85 and position.Y < 250 then
	tpBatState.lastSafeCFrame = root.CFrame
	end

	if recovering then
	pcall(function()
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	if targetRoot and targetRoot.Parent and targetRoot.Position.Y > voidFloor + 10 and targetRoot.Position.Y < 350 then
	safeTeleport(root, facingCFrame(targetRoot.Position + Vector3.new(0, 0.9, 0), targetRoot.Position, targetRoot.CFrame.LookVector))
	elseif tpBatState.lastSafeCFrame then
	safeTeleport(root, facingCFrame(root.Position, root.Position, nil, tpBatState.lastSafeCFrame))
	end
	end)
	resetPhysicsRoot(root)
	end

	tpBatState.lastPosition = root.Position
	tpBatState.lastSampleTime = now
	return recovering
	end

	local function mobileHeartbeatStep()
	if not tpBatState.enabled then return end
	local character, root, humanoid = getRig()
	if not character or not root or not humanoid or humanoid.Health <= 0 then return end

	if followPreservedMarker(root) then
	swingBat()
	return
	end
	if tpBatState.previousAutoRotate == nil then tpBatState.previousAutoRotate = humanoid.AutoRotate end
	humanoid.AutoRotate = false

	findBat(true)
	local target = closestTarget(root)
	if target then
	local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
	local rememberedCFrame = getRememberedTargetCFrame(target, root)
	local targetLeftMap = targetRoot and not _G.__CrystalTPBatIsInsideMap(targetRoot.Position)
	if targetLeftMap then targetRoot = nil end
	if targetRoot or rememberedCFrame then
	local suspicious, sample = false, tpBatState.samples[target]
	if targetRoot then suspicious, sample = inspectMobileTarget(target, targetRoot, root) end
	if guardMobileAgainstVoid(root, humanoid, suspicious and nil or targetRoot) then
	swingBat()
	return
	end

	local targetPosition
	if suspicious then
	targetPosition = sample and sample.safePosition
	if not targetPosition and tpBatState.lastSafeCFrame then targetPosition = tpBatState.lastSafeCFrame.Position end
	if not targetPosition then targetPosition = root.Position end
	elseif targetRoot then
	local velocity = targetRoot.AssemblyLinearVelocity
	local prediction = Vector3.new(velocity.X, 0, velocity.Z) * 0.05
	targetPosition = targetRoot.Position + Vector3.new(0, 0.9, 0) + prediction
	else
	targetPosition = rememberedCFrame.Position
	end

	if targetRoot and not suspicious and targetPosition.Y < -20 then
	targetPosition = Vector3.new(targetPosition.X, root.Position.Y, targetPosition.Z)
	end

	local targetCFrame = targetRoot and targetRoot.CFrame or rememberedCFrame
	local engagement = facingCFrame(targetPosition, targetCFrame.Position, targetCFrame.LookVector, tpBatState.lastSafeCFrame)
	safeTeleport(root, engagement)
	pcall(function()
	if targetRoot then
	local targetVelocity = targetRoot.AssemblyLinearVelocity
	root.AssemblyLinearVelocity = Vector3.new(targetVelocity.X, 0, targetVelocity.Z)
	end
	root.AssemblyAngularVelocity = Vector3.zero
	end)
	tpBatState.lastSafeCFrame = engagement

	if sethiddenproperty and tick() >= tpBatState.physicsPauseUntil then
	pcall(function()
	if targetRoot then sethiddenproperty(root, "PhysicsRepRootPart", targetRoot) end
	end)
	end

	local camera = workspace.CurrentCamera
	if camera then pcall(function() camera.CFrame = CFrame.new(camera.CFrame.Position, targetCFrame.Position) end) end
	swingBat()
	end
	end
	end

	local function selectedHeartbeatStep()
		return desktopHeartbeatStep()
	end

	local function stopTPBat()
	local wasEnabled = tpBatState.enabled
	local stopGeneration = tpBatState.returnGeneration
	clearMarkerBodyLock()
	tpBatState.enabled = false
	if tpBatState.heartbeat then
	tpBatState.heartbeat:Disconnect()
	tpBatState.heartbeat = nil
	end
	tpBatState.target = nil
	tpBatState.samples = {}
	tpBatState.swingLocked = false

	local _, root, humanoid = getRig()
	if root then

	local velocity = root.AssemblyLinearVelocity
	local horizontal = Vector3.new(velocity.X, 0, velocity.Z)
	if horizontal.Magnitude > 120 then horizontal = horizontal.Unit * 120 end
	root.AssemblyLinearVelocity = Vector3.new(horizontal.X, math.clamp(velocity.Y, -50, 50), horizontal.Z)
	root.AssemblyAngularVelocity = Vector3.zero
	resetPhysicsRoot(root)
	end
	if humanoid then
	humanoid.AutoRotate = tpBatState.previousAutoRotate == nil and true or tpBatState.previousAutoRotate
	pcall(function()
	humanoid.PlatformStand = false
	humanoid.Sit = false
	local state = humanoid:GetState()
	if state == Enum.HumanoidStateType.Physics
	or state == Enum.HumanoidStateType.Ragdoll
	or state == Enum.HumanoidStateType.FallingDown then
	humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	humanoid:ChangeState(Enum.HumanoidStateType.Running)
	end
	local camera = workspace.CurrentCamera
	if camera then camera.CameraSubject = humanoid end
	end)
	end
	tpBatState.previousAutoRotate = nil

	if wasEnabled and root then
	task.spawn(function()
	for _ = 1, 12 do
	RunService.Heartbeat:Wait()
	if tpBatState.enabled or tpBatState.returnGeneration ~= stopGeneration then return end
	if _G.__CRYSTAL_STATE ~= crystalRuntimeState then return end
	local _, currentRoot, currentHumanoid = getRig()
	if currentRoot ~= root or not currentHumanoid or currentHumanoid.Health <= 0 then return end
	local currentVelocity = currentRoot.AssemblyLinearVelocity
	local currentHorizontal = Vector3.new(currentVelocity.X, 0, currentVelocity.Z)
	if currentHorizontal.Magnitude > 120 then currentHorizontal = currentHorizontal.Unit * 120 end
	currentRoot.AssemblyLinearVelocity = Vector3.new(currentHorizontal.X, math.clamp(currentVelocity.Y, -50, 50), currentHorizontal.Z)
	currentRoot.AssemblyAngularVelocity = Vector3.zero
	resetPhysicsRoot(currentRoot)
	end
	end)
	end

	if wasEnabled then
	task.delay(0.4, function()
	if tpBatState.enabled or tpBatState.returnGeneration ~= stopGeneration then return end
	if _G.__CRYSTAL_STATE ~= crystalRuntimeState then return end
	pcall(function() if _G.__CrystalAntiDieSet then _G.__CrystalAntiDieSet(false) end end)
	end)
	else
	pcall(function() if _G.__CrystalAntiDieSet then _G.__CrystalAntiDieSet(false) end end)
	end
	end

	local function startTPBat()
	if tpBatState.enabled then return end
	tpBatState.returnGeneration = (tpBatState.returnGeneration or 0) + 1
	if toggleStates["Autoplay"] and _G.__stopAutoplay then _G.__stopAutoplay() end
	tpBatState.enabled = true

	pcall(function() if _G.__CrystalAntiDieSet then _G.__CrystalAntiDieSet(true) end end)
	tpBatState.target = nil
	tpBatState.samples = {}
	tpBatState.swingLocked = false
	tpBatState.nextSwingAt = 0
	tpBatState.lastPosition = nil
	tpBatState.lastSampleTime = tick()
		tpBatState.recoverUntil = 0
		tpBatState.physicsPauseUntil = 0

		tpBatState.startingUntil = tick() + 0.35
	local _, root, humanoid = getRig()
	if root then
	resetPhysicsRoot(root)
	if root.Position.Y > -30 then tpBatState.lastSafeCFrame = root.CFrame end
	end
	if humanoid then tpBatState.previousAutoRotate = humanoid.AutoRotate end
		if tpBatState.heartbeat then tpBatState.heartbeat:Disconnect() end
		tpBatState.heartbeat = RunService.Heartbeat:Connect(selectedHeartbeatStep)

		task.spawn(function() pcall(selectedHeartbeatStep) end)
	end

	-- The previous Crystal TP Bat engine is intentionally left disconnected.
	-- The toggle below now uses the direct Cursed TP Bat engine only; this does
	-- not create a second GUI and is controlled exclusively by the existing UI.
	local cursedDirectBat = {
		enabled = false,
		connection = nil,
		hitCooldown = false,
		antiDieConnections = {},
		orbitAngle = 0,
		orbitRadius = 4.2,
		orbitSpeed = 80,
		velocityHistory = setmetatable({}, {__mode = "k"}),
		currentTarget = nil,
	}

	local function cursedDisconnectAntiDie()
		for _, connection in ipairs(cursedDirectBat.antiDieConnections) do
			pcall(function() connection:Disconnect() end)
		end
		cursedDirectBat.antiDieConnections = {}
	end

	local function cursedHookAntiDie(character)
		cursedDisconnectAntiDie()
		if not cursedDirectBat.enabled or not character then return end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid then return end
		pcall(function()
			humanoid.BreakJointsOnDeath = false
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Dying, false)
		end)
		cursedDirectBat.antiDieConnections[#cursedDirectBat.antiDieConnections + 1] = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
			if cursedDirectBat.enabled and humanoid.Parent and humanoid.Health <= 0 then
				pcall(function()
					humanoid.Health = humanoid.MaxHealth
					humanoid:ChangeState(Enum.HumanoidStateType.Running)
				end)
			end
		end)
	end

	local function cursedFindBat()
		local character = Player.Character
		if not character then return nil end
		local function isBat(item)
			local name = item.Name:lower()
			return item:IsA("Tool") and (name:find("bat") or name:find("slap"))
		end
		for _, child in ipairs(character:GetChildren()) do
			if isBat(child) then return child end
		end
		local backpack = Player:FindFirstChildOfClass("Backpack")
		if backpack then
			for _, child in ipairs(backpack:GetChildren()) do
				if isBat(child) then
					local humanoid = character:FindFirstChildOfClass("Humanoid")
					if humanoid then pcall(function() humanoid:EquipTool(child) end) end
					return child
				end
			end
		end
		return nil
	end

	local function cursedNearestPlayerTarget(root)
		local target, distance = nil, math.huge
		for _, otherPlayer in ipairs(Players:GetPlayers()) do
			local character = otherPlayer ~= Player and otherPlayer.Character
			local otherRoot = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if otherRoot and humanoid and humanoid.Health > 0 then
				local candidatePosition = otherRoot.Position
				local antiVoidPosition = _G.__CrystalAntiVoidPositionForPlayer
				if type(antiVoidPosition) == "function" then
					local ok, position = pcall(antiVoidPosition, otherPlayer, candidatePosition)
					if ok and typeof(position) == "Vector3" then candidatePosition = position end
				end
				local candidateDistance = (root.Position - candidatePosition).Magnitude
				if candidateDistance < distance then
					target, distance = otherPlayer, candidateDistance
				end
			end
		end
		return target, distance
	end

	local function cursedSwing()
		if cursedDirectBat.hitCooldown then return end
		cursedDirectBat.hitCooldown = true
		pcall(function()
			local bat = cursedFindBat()
			if not bat then return end
			bat:Activate()
			local remote = bat:FindFirstChildWhichIsA("RemoteEvent")
			if remote then remote:FireServer() end
		end)
		task.delay(0.08, function() cursedDirectBat.hitCooldown = false end)
	end

	local function cursedTPBatTick(dt)
		if not cursedDirectBat.enabled then return end
		if _G.__SoundRagdollTPBusy or _G.__CrystalInstaResetBusy then return end
		local character = Player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if not root or not humanoid or humanoid.Health <= 0 then return end
		local bat = cursedFindBat()
		if bat and bat.Parent ~= character then pcall(function() humanoid:EquipTool(bat) end) end
		local target, distance = cursedNearestPlayerTarget(root)
		local targetRoot = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
		if not targetRoot or distance > 100 then return end

		local targetPosition = targetRoot.Position
		local targetIsGhost = false
		local antiVoidPosition = _G.__CrystalAntiVoidPositionForPlayer
		if type(antiVoidPosition) == "function" then
			local ok, position, isGhost = pcall(antiVoidPosition, target, targetPosition)
			if ok and typeof(position) == "Vector3" then
				targetPosition = position
				targetIsGhost = isGhost == true
			end
		end

		local selectedVersion = math.clamp(math.floor(tonumber(_G.__batVersion) or 1), 1, 2)
		if selectedVersion == 1 then
			-- V1 remains the original direct snap with the requested fixed 3-stud spacing.
			local targetOffset = targetRoot.CFrame.LookVector * 3
			root.CFrame = CFrame.new(targetPosition - targetOffset + Vector3.new(0, 0.9, 0), targetPosition)
			root.AssemblyLinearVelocity = targetIsGhost and Vector3.zero or targetRoot.AssemblyLinearVelocity
			root.AssemblyAngularVelocity = Vector3.zero
		else
			-- Donor TP Bat V2: filtered horizontal velocity lead, fixed 4.2-stud orbit,
			-- 80-rad/s angular motion, and a hard velocity reset on each snap.
			local frameDt = (type(dt) == "number" and dt > 0 and dt < 0.1) and dt or (1 / 60)
			local now = os.clock()
			local flatVelocity = Vector3.zero
			if not targetIsGhost then
				local velocity = targetRoot.AssemblyLinearVelocity or Vector3.zero
				local previous = cursedDirectBat.velocityHistory[targetRoot]
				if previous then
					local sampleDt = now - previous.time
					if sampleDt > 0.004 and sampleDt < 0.5 then
						local measured = (targetPosition - previous.position) / sampleDt
						if measured.Magnitude < 180 then
							local blend = math.clamp(sampleDt * 12, 0.2, 0.85)
							velocity = (previous.velocity or velocity):Lerp(measured, blend)
						end
					end
				end
				cursedDirectBat.velocityHistory[targetRoot] = {time = now, position = targetPosition, velocity = velocity}
				flatVelocity = Vector3.new(velocity.X, 0, velocity.Z)
				if flatVelocity.Magnitude > 110 then flatVelocity = flatVelocity.Unit * 110 end
			end
			if cursedDirectBat.currentTarget ~= targetRoot then
				cursedDirectBat.currentTarget = targetRoot
				cursedDirectBat.orbitAngle = 0
			end
			local predicted = targetPosition + Vector3.new(0, 0.9, 0) + flatVelocity * 0.05
			cursedDirectBat.orbitAngle = (cursedDirectBat.orbitAngle or 0) + cursedDirectBat.orbitSpeed * frameDt
			local angle = cursedDirectBat.orbitAngle
			local orbitPosition = predicted + Vector3.new(
				math.cos(angle) * cursedDirectBat.orbitRadius,
				0,
				math.sin(angle) * cursedDirectBat.orbitRadius
			)
			root.CFrame = CFrame.new(orbitPosition, predicted)
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
		end

		local camera = workspace.CurrentCamera
		if camera then camera.CFrame = CFrame.new(camera.CFrame.Position, targetPosition) end
		cursedSwing()
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = false end
		end
	end

	local function cursedSetTPBatEnabled(active)
		active = active == true
		cursedDirectBat.enabled = active
		if cursedDirectBat.connection then
			cursedDirectBat.connection:Disconnect()
			cursedDirectBat.connection = nil
		end
		cursedDisconnectAntiDie()
		if active then
			cursedHookAntiDie(Player.Character)
			cursedDirectBat.connection = RunService.Heartbeat:Connect(cursedTPBatTick)
		end
		return cursedDirectBat.enabled
	end

	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(character)
		if cursedDirectBat.enabled then
			task.wait(0.1)
			cursedHookAntiDie(character)
		end
	end))

	FeaturePostToggle["TP Bat"] = function(active)
		_G.__CrystalTPBatActive = active == true
		if active then
			deactivateOtherAimbots("TP Bat")
			_G.__deactivateBatExclusive("TP Bat")
		end
		local r = cursedSetTPBatEnabled(active)
		return r
	end

	_G.__CrystalSetTPBatVersion = function(version)
		_G.__batVersion = math.clamp(math.floor(tonumber(version) or 1), 1, 2)
		cursedDirectBat.orbitAngle = 0
		cursedDirectBat.currentTarget = nil
		table.clear(cursedDirectBat.velocityHistory)
		if cursedDirectBat.enabled then pcall(cursedTPBatTick, 1 / 60) end
		pcall(saveConfig)
		return _G.__batVersion
	end

	_G.__CrystalTrackStopper(function()
		pcall(cursedSetTPBatEnabled, false)
		pcall(stopTPBat)
		pcall(clearLastTargetMarker)
	end)

	_G.CrystalAutoBat = {
	GetVersion = function() return math.clamp(math.floor(tonumber(_G.__batVersion) or 1), 1, 2) end,
	SetVersion = function(version)
	return _G.__CrystalSetTPBatVersion(version)
	end,
	GetV2Distance = getTPBatDistance,
	SetV2Distance = function(_)
	_G.__tpBatV2Distance = 3
	return 3
	end,
	SetEnabled = function(active)
	active = active == true
	toggleStates["TP Bat"] = active
	if toggleStateSetters["TP Bat"] then pcall(toggleStateSetters["TP Bat"], active) end
	FeaturePostToggle["TP Bat"](active)
	if toggleVisualUpdaters["TP Bat"] then pcall(toggleVisualUpdaters["TP Bat"]) end
	saveConfig()
		return cursedDirectBat.enabled
	end,
	Toggle = function()
	return _G.CrystalAutoBat.SetEnabled(not (toggleStates["TP Bat"] == true))
	end,
	Stop = function() pcall(cursedSetTPBatEnabled, false) end,
	}
	end
end)()

	local farmingSection = combatSection

	local dropRow = makeToggle(farmingSection, "Drop", "Drop")
	pcall(function() styleSmallToggle(dropRow) end)
	local autoGrabRow = makeToggle(farmingSection, "Auto Grab", "auto steal")
	pcall(function() styleSmallToggle(autoGrabRow) end)

	-- Steal bar in own function scope (avoids 200 local register limit)
	;(function()
	local grabBarGui = Instance.new("Frame", ScreenGui)
	grabBarGui.Name = "SoundAutoGrabBar"
	grabBarGui.AnchorPoint = Vector2.new(0, 0)
	local defaultExpandedW = _G.__CrystalRealMobile and 320 or 360
	local defaultCollapsedW = _G.__CrystalRealMobile and 280 or 320
	local partialCollapsedW = math.floor((defaultExpandedW + defaultCollapsedW) / 2)
	local savedSize = _G["_SoundHub_UI_AutoGrabBarSize"]
	local grabBarExpanded = _G["_SoundHub_UI_AutoGrabExpanded"] ~= nil and _G["_SoundHub_UI_AutoGrabExpanded"] or true
	local savedWidth = tonumber(savedSize)
	local barStyle = "4"
	_G["_SoundHub_UI_AutoGrabBarStyle"] = "4"
	local initialBarScale = math.clamp(tonumber(_G["_SoundHub_UI_AutoGrabBarScale"] or 1) or 1, 0.6, 1.6)

	if savedWidth and savedWidth < defaultCollapsedW then savedWidth = nil end
	local currentW = savedWidth and math.clamp(savedWidth, defaultCollapsedW, defaultExpandedW) or defaultExpandedW
	if savedSize and tonumber(savedSize) and tonumber(savedSize) <= defaultCollapsedW then
	grabBarExpanded = false
	end
	_G["_SoundHub_UI_AutoGrabExpanded"] = grabBarExpanded
	local grabBarSize = UDim2.new(0, currentW, 0, isMobile and 52 or 64)
	grabBarGui.Size = grabBarSize
	local barUiScale = Instance.new("UIScale")
	barUiScale.Scale = initialBarScale
	barUiScale.Parent = grabBarGui
	_G["_SoundHub_UI_AutoGrabBarScale"] = initialBarScale

	local savedBarPos = _G["_SoundHub_UI_AutoGrabBarPos"]
	if savedBarPos and savedBarPos.x and savedBarPos.y then
	grabBarGui.Position = UDim2.fromOffset(savedBarPos.x, savedBarPos.y)
	else
	grabBarGui.Position = UDim2.new(0.5, -currentW / 2, 0.80, 0)
	end
	grabBarGui.BackgroundColor3 = Color3.fromRGB(4, 4, 6)
	grabBarGui.BackgroundTransparency = 0
	grabBarGui.BorderSizePixel = 0
	grabBarGui.ZIndex = 500
	grabBarGui.Active = true
	grabBarGui.Draggable = false
	grabBarGui.Visible = toggleStates["Steal Bar"] == true
	grabBarGui.ClipsDescendants = true
	Instance.new("UICorner", grabBarGui).CornerRadius = UDim.new(0, isMobile and 11 or 13)
	local barStrokeInst = Instance.new("UIStroke", grabBarGui)
	barStrokeInst.Color = Color3.fromRGB(55, 55, 60)
	barStrokeInst.Thickness = 1.2
	barStrokeInst.Transparency = 0.18
	barStrokeInst.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local outerReliefGradient = Instance.new("UIGradient", grabBarGui)
	outerReliefGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(13, 13, 17)),
	ColorSequenceKeypoint.new(0.55, Color3.fromRGB(5, 5, 8)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
	})
	outerReliefGradient.Rotation = 90

	local topRow = Instance.new("Frame", grabBarGui)
	topRow.Size = UDim2.new(0, isMobile and 70 or 82, 1, -4)
	topRow.Position = UDim2.new(1, isMobile and -72 or -84, 0, 2)
	topRow.BackgroundTransparency = 1
	topRow.Visible = false
	topRow.ZIndex = 504

	local statsDivider = Instance.new("Frame", topRow)
	statsDivider.Name = "Divider"
	statsDivider.Size = UDim2.new(0, 1, 1, -10)
	statsDivider.Position = UDim2.new(0, 0, 0, 5)
	statsDivider.BorderSizePixel = 0
	statsDivider.BackgroundColor3 = Color3.fromRGB(58, 58, 64)
	statsDivider.BackgroundTransparency = 0.25
	statsDivider.ZIndex = 505

	StatsRightFps = Instance.new("TextLabel", topRow)
	StatsRightFps.Size = UDim2.new(1, -10, 0, 14)
	StatsRightFps.Position = UDim2.new(0, isMobile and 7 or 9, 0, isMobile and 6 or 9)
	StatsRightFps.BackgroundTransparency = 1
	StatsRightFps.TextColor3 = Color3.fromRGB(245, 245, 248)
	StatsRightFps.Font = Enum.Font.GothamBold
	StatsRightFps.TextSize = isMobile and 8 or 9
	StatsRightFps.TextXAlignment = Enum.TextXAlignment.Left
	StatsRightFps.ZIndex = 506
	StatsRightFps.Visible = false

	StatsRightPing = Instance.new("TextLabel", topRow)
	StatsRightPing.Size = UDim2.new(1, -10, 0, 14)
	StatsRightPing.Position = UDim2.new(0, isMobile and 7 or 9, 0, isMobile and 23 or 27)
	StatsRightPing.BackgroundTransparency = 1
	StatsRightPing.TextColor3 = Color3.fromRGB(200, 200, 208)
	StatsRightPing.Font = Enum.Font.GothamBold
	StatsRightPing.TextSize = isMobile and 8 or 9
	StatsRightPing.TextXAlignment = Enum.TextXAlignment.Left
	StatsRightPing.ZIndex = 506
	StatsRightPing.Visible = false

	local percentLabel = Instance.new("TextLabel", topRow)
	percentLabel.Size = UDim2.new(0, 54, 1, 0)
	percentLabel.Position = UDim2.new(1, -84, 0, 0)
	percentLabel.BackgroundTransparency = 1
	percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	percentLabel.Font = Enum.Font.GothamBold
	percentLabel.TextSize = 11
	percentLabel.TextXAlignment = Enum.TextXAlignment.Right
	percentLabel.ZIndex = 502
	percentLabel.Visible = false

	local resizeBtn = Instance.new("TextButton", grabBarGui)
	resizeBtn.Size = UDim2.new(0, 16, 0, 16)
	resizeBtn.Position = UDim2.new(1, -22, 0, 3)
	resizeBtn.AnchorPoint = Vector2.new(0, 0)
	resizeBtn.BackgroundTransparency = 0.2
	resizeBtn.BackgroundColor3 = Color3.fromRGB(110, 110, 110)
	resizeBtn.TextColor3 = Color3.fromRGB(235, 240, 245)
	resizeBtn.Font = Enum.Font.GothamBold
	resizeBtn.TextSize = 10
	resizeBtn.Text = "−"
	resizeBtn.Visible = false
	Instance.new("UICorner", resizeBtn).CornerRadius = UDim.new(1,0)
	resizeBtn.ZIndex = 510

	local resizeUpBtn = Instance.new("TextButton", grabBarGui)
	resizeUpBtn.Name = "ResizeBarLarger"
	resizeUpBtn.Size = UDim2.fromOffset(16, 16)
	resizeUpBtn.Position = UDim2.new(1, -42, 0, 3)
	resizeUpBtn.BackgroundTransparency = 0.2
	resizeUpBtn.BackgroundColor3 = Color3.fromRGB(110, 110, 110)
	resizeUpBtn.TextColor3 = Color3.fromRGB(235, 240, 245)
	resizeUpBtn.Font = Enum.Font.GothamBold
	resizeUpBtn.TextSize = 10
	resizeUpBtn.Text = "+"
	resizeUpBtn.ZIndex = 510
	Instance.new("UICorner", resizeUpBtn).CornerRadius = UDim.new(1, 0)

	local barBg
	local function applyBarWidth(newW)
	if not newW or tonumber(newW) == nil then
	return
	end

	local ok, _ = pcall(function()
	if grabBarGui and grabBarGui.Size and grabBarGui.Size.Y then
	local yOffset = grabBarGui.Size.Y.Offset or (isMobile and 52 or 64)
	grabBarGui.Size = UDim2.new(0, tonumber(newW), 0, yOffset)
	end
	if barBg and barBg.Size then
	barBg.Size = UDim2.new(1, isMobile and -76 or -88, 1, -4)
	end
	end)
	if ok then
	_G["_SoundHub_UI_AutoGrabBarSize"] = tonumber(newW)
	pcall(saveConfig)
	end
	end
	if not grabBarExpanded then
	applyBarWidth(partialCollapsedW)
	end

	local function changeBarScale(delta)
		barUiScale.Scale = math.clamp(math.floor((barUiScale.Scale + delta) * 10 + 0.5) / 10, 0.6, 1.6)
		_G["_SoundHub_UI_AutoGrabBarScale"] = barUiScale.Scale
		pcall(saveConfig)
	end
	_G.__CrystalSetAutoGrabBarScale = function(value)
		local n = tonumber(value)
		if not n then return barUiScale.Scale end
		n = math.clamp(math.floor(n * 100 + 0.5) / 100, 0.6, 1.6)
		barUiScale.Scale = n
		_G["_SoundHub_UI_AutoGrabBarScale"] = n
		pcall(saveConfig)
		return n
	end
	resizeBtn.MouseButton1Click:Connect(function() changeBarScale(-0.1) end)
	resizeUpBtn.MouseButton1Click:Connect(function() changeBarScale(0.1) end)

	-- Screenshot-style Auto Grab bar (theme-aware)
	grabBarGui.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
	outerReliefGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 28)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 12)),
	})
	barStrokeInst.Color = Color3.fromRGB(55, 55, 65)
	barStrokeInst.Thickness = 1.4
	barStrokeInst.Transparency = 0.25

	-- Icon image on steal bar
	local sLetter = nil
	local sSub = nil
	local leftDivider = nil
	-- Full-bar theme image (red/blue)
	local stealBarIcon = Instance.new("ImageLabel", grabBarGui)
	stealBarIcon.Name = "StealBarIcon"
	stealBarIcon.Size = UDim2.new(1, 0, 1, 0)
	stealBarIcon.Position = UDim2.new(0, 0, 0, 0)
	stealBarIcon.BackgroundTransparency = 1
	stealBarIcon.BorderSizePixel = 0
	stealBarIcon.Image = ""
	stealBarIcon.ScaleType = Enum.ScaleType.Crop
	stealBarIcon.ImageTransparency = 0.1
	stealBarIcon.ZIndex = 501
	stealBarIcon.ClipsDescendants = true
		Instance.new("UICorner", stealBarIcon).CornerRadius = UDim.new(0, isMobile and 11 or 13)

	-- Compact style icon placeholder; the asset ID can be supplied later.
	local compactStyleIcon = Instance.new("ImageLabel", grabBarGui)
	compactStyleIcon.Name = "CompactStyleIcon"
	compactStyleIcon.Size = UDim2.fromOffset(24, 24)
	compactStyleIcon.Position = UDim2.new(0, 8, 0.5, -12)
	compactStyleIcon.BackgroundColor3 = Color3.fromRGB(55, 55, 62)
	compactStyleIcon.BackgroundTransparency = 0.05
	compactStyleIcon.BorderSizePixel = 0
	compactStyleIcon.Image = (_G.__CrystalSoundIntroImage or "rbxassetid://100534832091396")
	compactStyleIcon.ImageTransparency = 1
	compactStyleIcon.ScaleType = Enum.ScaleType.Crop
	compactStyleIcon.Visible = false
	compactStyleIcon.ZIndex = 506
	Instance.new("UICorner", compactStyleIcon).CornerRadius = UDim.new(0, 6)

	-- V1/V2 mode pill (clickable → switches Auto Steal version)
	local modePill = Instance.new("TextButton", grabBarGui)
	modePill.Size = UDim2.new(0, 28, 0, 16)
	modePill.Position = UDim2.new(0, 12, 0, isMobile and 8 or 10)
	modePill.BackgroundColor3 = Color3.fromRGB(140, 90, 220)
	modePill.BorderSizePixel = 0
	modePill.Text = ""
	modePill.Font = Enum.Font.GothamBlack
	modePill.TextSize = 9
	modePill.TextColor3 = Color3.fromRGB(255, 255, 255)
	modePill.ZIndex = 506
	modePill.AutoButtonColor = false
	Instance.new("UICorner", modePill).CornerRadius = UDim.new(0, 5)

	-- AUTO GRAB title
	local autoGrabTitle = Instance.new("TextLabel", grabBarGui)
	autoGrabTitle.Size = UDim2.new(1, -90, 0, 18)
	autoGrabTitle.Position = UDim2.new(0, 46, 0, isMobile and 7 or 9)
	autoGrabTitle.BackgroundTransparency = 1
	autoGrabTitle.Text = "AUTO GRAB"
	autoGrabTitle.Font = Enum.Font.GothamBlack
	autoGrabTitle.TextSize = isMobile and 11 or 12
	autoGrabTitle.TextColor3 = Color3.fromRGB(245, 245, 250)
	autoGrabTitle.TextXAlignment = Enum.TextXAlignment.Left
	autoGrabTitle.ZIndex = 506

	-- Percent (right)
	local percentLabel = Instance.new("TextLabel", grabBarGui)
	percentLabel.Size = UDim2.new(0, 52, 0, 18)
	percentLabel.Position = UDim2.new(1, -102, 0, isMobile and 7 or 9)
	percentLabel.BackgroundTransparency = 1
	percentLabel.Text = "0%"
	percentLabel.Font = Enum.Font.GothamBlack
	percentLabel.TextSize = isMobile and 14 or 16
	percentLabel.TextColor3 = Color3.fromRGB(245, 245, 250)
	percentLabel.TextXAlignment = Enum.TextXAlignment.Right
	percentLabel.ZIndex = 506

	-- Thin progress track
	barBg = Instance.new("Frame", grabBarGui)
	barBg.Size = UDim2.new(1, isMobile and -20 or -24, 0, 11)
	barBg.Position = UDim2.new(0, isMobile and 10 or 12, 1, isMobile and -18 or -20)
	barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	barBg.BorderSizePixel = 0
	barBg.ZIndex = 504
	Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)
	local barTrackStroke = Instance.new("UIStroke", barBg)
	barTrackStroke.Transparency = 1

	local barFill = Instance.new("Frame", barBg)
	barFill.Size = UDim2.new(0, 0, 1, 0)
	barFill.Position = UDim2.new(0, 0, 0, 0)
	barFill.BorderSizePixel = 0
	barFill.BackgroundColor3 = _G.__SoundAccentColor()
	barFill.ClipsDescendants = true
	barFill.ZIndex = 505
	Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)
	local fillGradient = Instance.new("UIGradient", barFill)
	-- White tracking shine: it is vertically centered and follows the live
	-- progress edge at exactly the same speed, while staying inside the frame.
	local fillGlow = Instance.new("Frame")
	fillGlow.Name = "ProgressInsetGlow"
	fillGlow.Size = UDim2.new(0, isMobile and 54 or 72, 1, -2)
	fillGlow.AnchorPoint = Vector2.new(0.5, 0.5)
	fillGlow.Position = UDim2.new(1, isMobile and -39 or -52, 0.5, 0)
	fillGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	fillGlow.BackgroundTransparency = 0.25
	fillGlow.BorderSizePixel = 0
	fillGlow.ZIndex = 505
	fillGlow.Parent = barFill
	Instance.new("UICorner", fillGlow).CornerRadius = UDim.new(1, 0)
	local glowStroke = Instance.new("UIStroke")
	glowStroke.Color = Color3.fromRGB(255, 255, 255)
	glowStroke.Thickness = isMobile and 2 or 3
	glowStroke.Transparency = 0.42
	glowStroke.Parent = fillGlow
	local glowGradient = Instance.new("UIGradient")
	glowGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.52, 0.02),
		NumberSequenceKeypoint.new(1, 1),
	})
	glowGradient.Parent = fillGlow
	local fillShine = Instance.new("Frame")
	fillShine.Name = "ProgressInsetShine"
	fillShine.Size = UDim2.new(0, isMobile and 32 or 42, 1, -4)
	fillShine.AnchorPoint = Vector2.new(0.5, 0.5)
	fillShine.Position = UDim2.new(1, isMobile and -28 or -37, 0.5, 0)
	fillShine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	fillShine.BackgroundTransparency = 0.06
	fillShine.BorderSizePixel = 0
	fillShine.ZIndex = 506
	fillShine.Parent = barFill
	Instance.new("UICorner", fillShine).CornerRadius = UDim.new(1, 0)
	local shineGradient = Instance.new("UIGradient")
	shineGradient.Rotation = 0
	shineGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.42, 0.05),
		NumberSequenceKeypoint.new(1, 1),
	})
	shineGradient.Parent = fillShine
	task.spawn(function()
		while fillGlow.Parent and fillShine.Parent do
			local glowIn = TweenService:Create(fillGlow, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0.02})
			local shineIn = TweenService:Create(fillShine, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
			glowIn:Play(); shineIn:Play(); glowIn.Completed:Wait()
			if not fillGlow.Parent or not fillShine.Parent then break end
			local glowOut = TweenService:Create(fillGlow, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0.32})
			local shineOut = TweenService:Create(fillShine, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0.16})
			glowOut:Play(); shineOut:Play(); glowOut.Completed:Wait()
		end
	end)

	local barThemeColor = _G.__SoundAccentColor()
	local function resolveAutoStealAccent()
		-- Always follow the hub color theme (purple / azure / green / halloween). Never fall back to red/blue by bg index.
		if type(_G.__SoundAccentColor) == "function" then
			local ok, c = pcall(_G.__SoundAccentColor)
			if ok and typeof(c) == "Color3" then return c end
		end
		local ct = "purple"
		if _G.__CrystalHalloweenMode == true or (toggleStates and toggleStates["Halloween Mode"] == true) then
			return Color3.fromRGB(255, 126, 26)
		end
		if ct == "azure" then return Color3.fromRGB(80, 170, 255) end
		if ct == "green" then return Color3.fromRGB(70, 210, 110) end
		return Color3.fromRGB(168, 85, 247) -- purple default
	end
	local STEAL_ICON_AZZURRO = (_G.__CrystalSoundIntroImage or "rbxassetid://100534832091396")
	local STEAL_ICON_HALLOWEEN = (getHalloweenBackground and getHalloweenBackground()) or "rbxassetid://110140566078462"

	-- Top status HUD: it uses the exact artwork selected for the Steal Bar.
	local oldTopHud = ScreenGui:FindFirstChild("SoundTopStatus")
	if oldTopHud then oldTopHud:Destroy() end
	local sx = {}
	local DISCORD_TAG = "discord.gg/Soundduel"
	local STYLE_ORANGE = Color3.fromRGB(255, 126, 26)
	local STYLE_AZZURRO = _G.__SoundAccentColor()
	local function styleIsHalloween()
	return (_G.__CrystalHalloweenMode == true) or (toggleStates and toggleStates["Halloween Mode"] == true)
	end
	local function styleAccent()
	return styleIsHalloween() and STYLE_ORANGE or STYLE_AZZURRO
	end
	local refreshStyleTexts
	do
		local layer = Instance.new("Frame", grabBarGui)
		layer.Name = "StyleLayer"
		layer.Size = UDim2.new(1, 0, 1, 0)
		layer.BackgroundTransparency = 1
		layer.ZIndex = 507
		layer.Visible = false
		sx.layer = layer
		local function mk(name, font, align)
			local label = Instance.new("TextLabel", layer)
			label.Name = name
			label.BackgroundTransparency = 1
			label.Font = font
			label.TextColor3 = Color3.fromRGB(245, 245, 250)
			label.TextXAlignment = align
			label.TextYAlignment = Enum.TextYAlignment.Center
			label.ZIndex = 508
			label.Text = ""
			label.Visible = false
			return label
		end
		sx.radius = mk("RadiusLabel", Enum.Font.GothamBlack, Enum.TextXAlignment.Right)
		sx.center = mk("InfoCenter", Enum.Font.GothamBold, Enum.TextXAlignment.Center)
		sx.left = mk("InfoLeft", Enum.Font.GothamBold, Enum.TextXAlignment.Left)
		sx.tag = mk("DiscordTag", Enum.Font.GothamBold, Enum.TextXAlignment.Right)
		sx.num = mk("RadiusNumber", Enum.Font.GothamBlack, Enum.TextXAlignment.Left)
		sx.fps = mk("FpsLabel", Enum.Font.GothamBlack, Enum.TextXAlignment.Left)
		sx.ms = mk("MsLabel", Enum.Font.GothamBlack, Enum.TextXAlignment.Right)
		sx.scale = mk("ScaleLabel", Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
		-- V2 (Sound.VS style) elements
		local v2Art = Instance.new("ImageLabel", layer)
		v2Art.Name = "V2Art"
		v2Art.Size = UDim2.new(1, 0, 1, 0)
		v2Art.BackgroundTransparency = 1
		v2Art.ScaleType = Enum.ScaleType.Crop
		v2Art.ImageTransparency = 0.45
		v2Art.ZIndex = 507
		v2Art.Visible = false
		Instance.new("UICorner", v2Art).CornerRadius = UDim.new(0, isMobile and 14 or 16)
		sx.v2Art = v2Art
		local v2Logo = Instance.new("Frame", layer)
		v2Logo.Name = "V2Logo"
		v2Logo.Size = UDim2.fromOffset(44, 44)
		v2Logo.Position = UDim2.new(0, 8, 0.5, -22)
		v2Logo.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
		v2Logo.BorderSizePixel = 0
		v2Logo.ZIndex = 508
		v2Logo.Visible = false
		Instance.new("UICorner", v2Logo).CornerRadius = UDim.new(0, 12)
		sx.v2Logo = v2Logo
		local v2LogoText = Instance.new("TextLabel", v2Logo)
		v2LogoText.Size = UDim2.new(1, 0, 1, 0)
		v2LogoText.BackgroundTransparency = 1
		v2LogoText.Text = "VH"
		v2LogoText.Font = Enum.Font.GothamBlack
		v2LogoText.TextSize = 22
		v2LogoText.TextColor3 = Color3.fromRGB(70, 150, 255)
		v2LogoText.ZIndex = 509
		local v2Title = mk("V2Title", Enum.Font.GothamBlack, Enum.TextXAlignment.Left)
		v2Title.Text = "Sound.VS"
		v2Title.TextColor3 = Color3.fromRGB(70, 150, 255)
		v2Title.Size = UDim2.new(1, -150, 0, 20)
		v2Title.Position = UDim2.fromOffset(62, 6)
		v2Title.TextSize = isMobile and 15 or 17
		sx.v2Title = v2Title
		local v2Sub = mk("V2Sub", Enum.Font.GothamBold, Enum.TextXAlignment.Left)
		v2Sub.Text = "discord.gg/Soundduel"
		v2Sub.TextColor3 = Color3.fromRGB(205, 210, 220)
		v2Sub.Size = UDim2.new(1, -150, 0, 14)
		v2Sub.Position = UDim2.fromOffset(62, 25)
		v2Sub.TextSize = isMobile and 10 or 11
		sx.v2Sub = v2Sub
		local v2Pill = Instance.new("Frame", layer)
		v2Pill.Name = "V2PercentPill"
		v2Pill.Size = UDim2.fromOffset(58, 22)
		v2Pill.Position = UDim2.new(1, -68, 0, 8)
		v2Pill.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
		v2Pill.BorderSizePixel = 0
		v2Pill.ZIndex = 508
		v2Pill.Visible = false
		Instance.new("UICorner", v2Pill).CornerRadius = UDim.new(1, 0)
		sx.v2Pill = v2Pill
		local line = Instance.new("Frame", layer)
		line.Name = "TitleLine"
		line.BorderSizePixel = 0
		line.ZIndex = 508
		line.Visible = false
		sx.line = line
	end

	local function themedBarIcon()
		local halloweenOn = (_G.__CrystalHalloweenMode == true) or (toggleStates and toggleStates["Halloween Mode"] == true)
		if halloweenOn then return (getHalloweenBackground and getHalloweenBackground()) or STEAL_ICON_HALLOWEEN end
		local index = tonumber(_G["_SoundHub_UI_BgIndex"]) or 1
		-- Prefer live theme background set (purple / azure / green)
		if type(backgroundIds) == "table" and backgroundIds[index] then
			return backgroundIds[index]
		end
		local ct = "purple"
		local fallback = {
			purple = {"rbxassetid://112180017939463", "rbxassetid://106344835483006", "rbxassetid://124053948669794", "rbxassetid://134260766475623", "rbxassetid://111228868353029", "rbxassetid://114100567839601"},
			azure = {"rbxassetid://83397490448717", "rbxassetid://98695754338509", "rbxassetid://100534832091396", "rbxassetid://119471188520315"},
			green = {"rbxassetid://82449880166911", "rbxassetid://111075252532269", "rbxassetid://125414142216061"},
		}
		local list = fallback[ct] or fallback.purple
		return list[math.clamp(index, 1, #list)] or STEAL_ICON_AZZURRO or "rbxassetid://100534832091396"
	end

	local function paintFill(accent)
		fillGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, accent:Lerp(Color3.fromRGB(255, 255, 255), 0.25)),
			ColorSequenceKeypoint.new(0.5, accent),
			ColorSequenceKeypoint.new(1, accent:Lerp(Color3.fromRGB(40, 0, 40), 0.2)),
		})
		barFill.BackgroundColor3 = accent
	end


	-- ==================== AUTO GRAB UI V1 / V2 (UI ONLY) ====================
	-- V1 = original layout (untouched). V2 = compact card (logo, name, discord, % pill, thin progress bar) in theme colours.
	local function currentGrabSkin()
		local sk = tostring(_G["_SoundHub_UI_AutoGrabSkin"] or "V1")
		if sk ~= "V1" then sk = "V1" end -- V2/V3 UI retired; migrate saved configs to V1
		return sk
	end
	local skinUi = {}
	do
		local function newFrame(parent, name, z)
			local f = Instance.new("Frame")
			f.Name = name
			f.BackgroundTransparency = 1
			f.BorderSizePixel = 0
			f.ZIndex = z or 508
			f.Parent = parent
			return f
		end
		local function newLabel(parent, name, font, size, color, align, z)
			local l = Instance.new("TextLabel")
			l.Name = name
			l.BackgroundTransparency = 1
			l.BorderSizePixel = 0
			l.Font = font
			l.TextSize = size
			l.TextColor3 = color
			l.TextXAlignment = align
			l.TextYAlignment = Enum.TextYAlignment.Center
			l.RichText = true
			l.Text = ""
			l.ZIndex = z or 510
			l.Parent = parent
			return l
		end
		local function round(obj, r)
			local c = Instance.new("UICorner")
			c.CornerRadius = r
			c.Parent = obj
			return c
		end
		local function outline(obj, color, thick, transp)
			local st = Instance.new("UIStroke")
			st.Color = color
			st.Thickness = thick
			st.Transparency = transp or 0
			st.Parent = obj
			return st
		end

		-- ---------- V2 : dark rounded bar (percent top-left, FPS | mode+radius | PING row, thick progress bar) ----------
		local v2 = newFrame(grabBarGui, "SkinV2", 508)
		v2.Size = UDim2.new(1, 0, 1, 0)
		v2.Visible = false
		local statY = isMobile and 31 or 34
		local topY = isMobile and 8 or 9
		local WHITE = Color3.fromRGB(255, 255, 255)
		-- FPS + PING: lower row, each centered in its half
		local fpsLbl = newLabel(v2, "V2Fps", Enum.Font.GothamMedium, isMobile and 8 or 9, WHITE, Enum.TextXAlignment.Center, 510)
		fpsLbl.RichText = false
		fpsLbl.Position = UDim2.new(0, 0, 0, statY)
		fpsLbl.Size = UDim2.new(0.5, 0, 0, 14)
		fpsLbl.Text = "FPS: 0"
		local pingLbl = newLabel(v2, "V2Ping", Enum.Font.GothamMedium, isMobile and 8 or 9, WHITE, Enum.TextXAlignment.Center, 510)
		pingLbl.RichText = false
		pingLbl.Position = UDim2.new(0.5, 0, 0, statY)
		pingLbl.Size = UDim2.new(0.5, 0, 0, 14)
		pingLbl.Text = "PING: 0ms"
		-- mode + radius: top row, same line as the percent, pure white
		local centerLbl = newLabel(v2, "V2Center", Enum.Font.GothamBold, isMobile and 9 or 10, WHITE, Enum.TextXAlignment.Right, 510)
		centerLbl.RichText = false
		centerLbl.AnchorPoint = Vector2.new(1, 0)
		centerLbl.Position = UDim2.new(1, -14, 0, topY)
		centerLbl.Size = UDim2.new(0.6, 0, 0, 16)
		centerLbl.Text = "NORMAL 65 RADIUS"
		skinUi.v2 = v2
		skinUi.v2Fps = fpsLbl
		skinUi.v2Center = centerLbl
		skinUi.v2Ping = pingLbl

		-- ---------- BUBBLE : white pill (title + % on the track, mode/radius + fps/ping panel on the right) ----------
		local bub = newFrame(grabBarGui, "SkinBubble", 508)
		bub.Size = UDim2.new(1, 0, 1, 0)
		bub.Visible = false
		local bubDark = Color3.fromRGB(245, 245, 250)
		local panelW = isMobile and 70 or 82
		local bubTitle = newLabel(bub, "BubbleTitle", Enum.Font.GothamBold, isMobile and 10 or 12, bubDark, Enum.TextXAlignment.Left, 510)
		bubTitle.RichText = false
		bubTitle.Position = UDim2.new(0, 16, 0, 0)
		bubTitle.Size = UDim2.new(0.5, 0, 1, 0)
		bubTitle.Text = "AUTO STEAL"
		local panel = newFrame(bub, "BubblePanel", 509)
		panel.Size = UDim2.new(0, panelW, 1, -4)
		panel.Position = UDim2.new(1, -(panelW + 2), 0, 2)
		panel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		panel.BackgroundTransparency = 0.45
		round(panel, UDim.new(1, 0))
		local div = newFrame(panel, "Divider", 510)
		div.Size = UDim2.new(0, 1, 1, -10)
		div.Position = UDim2.new(0, 0, 0, 5)
		div.BackgroundTransparency = 0
		div.BackgroundColor3 = Color3.fromRGB(110, 110, 120)
		local bubMode = newLabel(panel, "BubbleMode", Enum.Font.GothamBold, isMobile and 8 or 9, bubDark, Enum.TextXAlignment.Left, 511)
		bubMode.RichText = false
		bubMode.Position = UDim2.new(0, isMobile and 7 or 9, 0, isMobile and 6 or 9)
		bubMode.Size = UDim2.new(1, -10, 0, 14)
		bubMode.Text = "NORMAL 65"
		local bubStats = newLabel(panel, "BubbleStats", Enum.Font.GothamBold, isMobile and 8 or 9, bubDark, Enum.TextXAlignment.Left, 511)
		bubStats.RichText = false
		bubStats.Position = UDim2.new(0, isMobile and 7 or 9, 0, isMobile and 23 or 27)
		bubStats.Size = UDim2.new(1, -10, 0, 14)
		bubStats.Text = "0 FPS  0ms"
		-- ---------- V2 : black bar (centered "AUTO STEAL . %" on a themed track, FPS / PING panel on the right) ----------
		local v2b = newFrame(grabBarGui, "SkinV2Bar", 508)
		v2b.Size = UDim2.new(1, 0, 1, 0)
		v2b.Visible = false
		local v2PanelW = isMobile and 78 or 96
		local v2Title = newLabel(v2b, "V2BarTitle", Enum.Font.GrenzeGotisch, isMobile and 18 or 22, Color3.fromRGB(245, 245, 250), Enum.TextXAlignment.Left, 510)
		v2Title.RichText = false
		v2Title.Position = UDim2.new(0, 62, 0, 12)
		v2Title.Size = UDim2.new(1, -(v2PanelW + 150), 0, 28)
		v2Title.TextXAlignment = Enum.TextXAlignment.Left
		v2Title.Text = "Vicious"
		local v2Subtitle = newLabel(v2b, "V2BarSubtitle", Enum.Font.GothamBold, isMobile and 9 or 11, Color3.fromRGB(170, 170, 185), Enum.TextXAlignment.Left, 510)
		v2Subtitle.Position = UDim2.new(0, 62, 0, 40)
		v2Subtitle.Size = UDim2.new(1, -(v2PanelW + 150), 0, 16)
		v2Subtitle.Text = "discord.gg/vicioushub"
		local v2Pct = newLabel(v2b, "V2BarPercent", Enum.Font.GothamBlack, isMobile and 18 or 22, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Right, 510)
		v2Pct.AnchorPoint = Vector2.new(1, 0)
		v2Pct.Position = UDim2.new(1, -(v2PanelW + 12), 0, 10)
		v2Pct.Size = UDim2.new(0, 70, 0, 28)
		v2Pct.Text = "0%"
		local v2Logo = Instance.new("Frame")
		v2Logo.Name = "ViciousAutoGrabLogo"
		v2Logo.Size = UDim2.new(0, 42, 0, 42)
		v2Logo.Position = UDim2.new(0, 12, 0.5, -21)
		v2Logo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		v2Logo.BackgroundTransparency = 0.1
		v2Logo.BorderSizePixel = 0
		v2Logo.ZIndex = 510
		v2Logo.Parent = v2b
		round(v2Logo, UDim.new(0, 12))
		outline(v2Logo, Color3.fromRGB(230, 230, 240), 1, 0.25)
		local v2LogoText = newLabel(v2Logo, "LogoV", Enum.Font.GrenzeGotisch, 30, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Center, 511)
		v2LogoText.Size = UDim2.new(1, 0, 1, 0)
		v2LogoText.Text = "V"
		local v2Fps = newLabel(v2b, "V2BarFps", Enum.Font.GothamBold, isMobile and 9 or 10, Color3.fromRGB(245, 245, 250), Enum.TextXAlignment.Left, 510)
		v2Fps.RichText = false
		v2Fps.AnchorPoint = Vector2.new(0, 0.5)
		v2Fps.Position = UDim2.new(1, -(v2PanelW - 4), 0.5, isMobile and -8 or -10)
		v2Fps.Size = UDim2.new(0, v2PanelW - 8, 0, 16)
		v2Fps.Text = "FPS:0"
		local v2Ping = newLabel(v2b, "V2BarPing", Enum.Font.GothamBold, isMobile and 9 or 10, Color3.fromRGB(255, 120, 120), Enum.TextXAlignment.Left, 510)
		v2Ping.RichText = false
		v2Ping.AnchorPoint = Vector2.new(0, 0.5)
		v2Ping.Position = UDim2.new(1, -(v2PanelW - 4), 0.5, isMobile and 8 or 10)
		v2Ping.Size = UDim2.new(0, v2PanelW - 8, 0, 16)
		v2Ping.Text = "PING: 0ms"
		skinUi.v2bar = v2b
		skinUi.v2barTitle = v2Title
		skinUi.v2barPct = v2Pct
		skinUi.v2barSubtitle = v2Subtitle
		skinUi.v2barFps = v2Fps
		skinUi.v2barPing = v2Ping
		skinUi.v2barPanelW = v2PanelW
		skinUi.bubble = bub
		skinUi.bubMode = bubMode
		skinUi.bubStats = bubStats
		skinUi.bubPanelW = panelW
	end

	-- Runs at the end of applyAutoGrabBarStyle; V1 is left exactly as the base layout sets it.
	local function applyAutoGrabSkin()
		local skin = currentGrabSkin()
		skinUi.v2.Visible = false
		skinUi.v2bar.Visible = (skin == "V2")
		skinUi.bubble.Visible = (skin == "V3")
		fillGradient.Rotation = 0
		do
			local iconCorner = stealBarIcon:FindFirstChildOfClass("UICorner")
			if iconCorner then iconCorner.CornerRadius = (skin == "V3") and UDim.new(1, 0) or UDim.new(0, isMobile and 11 or 13) end
		end
		if skin == "V1" then return end

		local cam = workspace.CurrentCamera
		local vpx = cam and cam.ViewportSize.X or 800
		local previousPosition = grabBarGui.Position
		local height = isMobile and 76 or 84
		local width = isMobile and 320 or 360
		if skin == "V3" then
			height = isMobile and 44 or 56
			width = isMobile and 230 or 310
		elseif skin == "V2" then
			height = isMobile and 86 or 100
			width = isMobile and 340 or 380
		end
		width = math.min(width, math.max(200, vpx - 24))
		grabBarGui.Size = UDim2.fromOffset(width, height)
		if previousPosition.X.Scale == 0.5 then
			grabBarGui.Position = UDim2.new(0.5, -width / 2, previousPosition.Y.Scale, previousPosition.Y.Offset)
		end

		-- hide the V1 pieces
		sx.layer.Visible = false
		for _, item in ipairs({ sx.radius, sx.center, sx.left, sx.tag, sx.num, sx.fps, sx.ms, sx.scale, sx.line, sx.v2Art, sx.v2Logo, sx.v2Title, sx.v2Sub, sx.v2Pill }) do item.Visible = false end
		autoGrabTitle.Visible = false
		modePill.Visible = false
		topRow.Visible = false
		statsDivider.Visible = false
		stealBarIcon.Visible = false
		local particles = grabBarGui:FindFirstChild("ThemeParticles")
		if particles then particles.Visible = false end
		for _, child in ipairs(barFill:GetChildren()) do
			if child.Name == "ProgressInsetGlow" or child.Name == "ProgressInsetShine" then child.Visible = false end
		end
		local gbC = grabBarGui:FindFirstChildOfClass("UICorner")

		-- colours: progress = your colour theme (purple / azure / green / halloween); V3 + BUBBLE = white UI
		local accent = resolveAutoStealAccent()
		local isBubble = (skin == "V3")
		local isWhite = false
		local DARK = Color3.fromRGB(18, 18, 22)
		local softText = isWhite and DARK or Color3.fromRGB(245, 245, 250)
		local mutedText = accent:Lerp(Color3.fromRGB(190, 190, 205), 0.45)

		if isWhite then
			grabBarGui.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			grabBarGui.BackgroundTransparency = 0
			outerReliefGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(244, 244, 248))
			barStrokeInst.Color = Color3.fromRGB(205, 205, 214)
			barStrokeInst.Thickness = 1.4
			barStrokeInst.Transparency = 0.05
		else
			grabBarGui.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
			grabBarGui.BackgroundTransparency = 0.05
			outerReliefGradient.Color = ColorSequence.new(accent:Lerp(Color3.fromRGB(10, 10, 14), 0.9), Color3.fromRGB(4, 4, 8))
			barStrokeInst.Color = Color3.fromRGB(45, 45, 52)
			barStrokeInst.Thickness = 1.2
			barStrokeInst.Transparency = 0.1
		end
		if gbC then gbC.CornerRadius = isBubble and UDim.new(1, 0) or UDim.new(0, 16) end
		local isV2 = (skin == "V2")
		if isV2 then
			grabBarGui.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			grabBarGui.BackgroundTransparency = 0
			outerReliefGradient.Color = ColorSequence.new(Color3.fromRGB(6, 6, 8), Color3.fromRGB(0, 0, 0))
			barStrokeInst.Color = accent
			barStrokeInst.Thickness = 1.6
			barStrokeInst.Transparency = 0.1
			if gbC then gbC.CornerRadius = UDim.new(0, isMobile and 14 or 16) end
			if skinUi.v2barPing then skinUi.v2barPing.TextColor3 = accent:Lerp(Color3.fromRGB(255, 255, 255), 0.2) end
			-- V2: menu background image behind the whole card (same art as V3)
			stealBarIcon.Visible = true
			stealBarIcon.ScaleType = Enum.ScaleType.Crop
			stealBarIcon.ImageTransparency = 0.1
			stealBarIcon.Size = UDim2.new(1, 0, 1, 0)
			stealBarIcon.Position = UDim2.new(0, 0, 0, 0)
			do
				local ic = stealBarIcon:FindFirstChildOfClass("UICorner")
				if ic then ic.CornerRadius = UDim.new(0, isMobile and 14 or 16) end
			end
		end
		if isBubble then
			-- V3: pure black pill + menu background image, theme-coloured outline and progress
			grabBarGui.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			grabBarGui.BackgroundTransparency = 0
			outerReliefGradient.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0))
			barStrokeInst.Color = accent
			barStrokeInst.Thickness = 1.6
			barStrokeInst.Transparency = 0.2
			stealBarIcon.Visible = true
			stealBarIcon.ScaleType = Enum.ScaleType.Crop
			stealBarIcon.ImageTransparency = 0.3
			stealBarIcon.Size = UDim2.new(1, 0, 1, 0)
			stealBarIcon.Position = UDim2.new(0, 0, 0, 0)
		end

		-- V2 / V3 card text colours
		local cardText = isWhite and Color3.fromRGB(40, 40, 48) or Color3.fromRGB(255, 255, 255)
		if skinUi.v2Fps then skinUi.v2Fps.TextColor3 = cardText end
		if skinUi.v2Ping then skinUi.v2Ping.TextColor3 = cardText end
		if skinUi.v2Center then skinUi.v2Center.TextColor3 = cardText end

		-- progress bar (fill always = your theme colour)
		fillGradient.Rotation = 0
		fillGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, accent),
			ColorSequenceKeypoint.new(1, accent:Lerp(Color3.fromRGB(255, 255, 255), 0.25)),
		})
		barFill.BackgroundColor3 = accent
		sx.fillColor = accent
		barTrackStroke.Transparency = 1

		if isBubble then
			-- full-height pill track on the left, stats panel on the right
			local panelW = skinUi.bubPanelW or (isMobile and 70 or 82)
			barBg.Size = UDim2.new(1, -(panelW + 6), 1, -4)
			barBg.Position = UDim2.new(0, 2, 0, 2)
			barBg.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
			barBg.BackgroundTransparency = 0.25

			percentLabel.Visible = true
			percentLabel.ZIndex = 509
			percentLabel.Font = Enum.Font.GothamBold
			percentLabel.TextSize = isMobile and 10 or 12
			percentLabel.TextColor3 = Color3.fromRGB(245, 245, 250)
			percentLabel.TextXAlignment = Enum.TextXAlignment.Right
			percentLabel.Size = UDim2.new(1, -(panelW + 6 + 16), 1, 0)
			percentLabel.Position = UDim2.new(0, 0, 0, 0)
		elseif isV2 then
			-- rounded-rect track on the left (filled with the theme colour), FPS / PING panel on the right
			local pw = skinUi.v2barPanelW or (isMobile and 78 or 96)
			barBg.Size = UDim2.new(1, -(pw + 10), 1, -10)
			barBg.Position = UDim2.new(0, 5, 0, 5)
			barBg.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
			barBg.BackgroundTransparency = 0.3
			local bgC2 = barBg:FindFirstChildOfClass("UICorner")
			if bgC2 then bgC2.CornerRadius = UDim.new(0, isMobile and 10 or 12) end
			local flC2 = barFill:FindFirstChildOfClass("UICorner")
			if flC2 then flC2.CornerRadius = UDim.new(0, isMobile and 10 or 12) end
			fillGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, accent:Lerp(Color3.fromRGB(255, 255, 255), 0.08)),
				ColorSequenceKeypoint.new(1, accent:Lerp(Color3.fromRGB(0, 0, 0), 0.4)),
			})
			percentLabel.Visible = false
		else
			-- thick rounded progress bar along the bottom
			local barH = isMobile and 17 or 20
			barBg.Size = UDim2.new(1, -28, 0, barH)
			barBg.Position = UDim2.new(0, 14, 1, -(barH + 9))
			barBg.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
			barBg.BackgroundTransparency = 0

			-- percent (top left)
			percentLabel.Visible = true
			percentLabel.ZIndex = 509
			percentLabel.Font = Enum.Font.GothamBlack
			percentLabel.TextSize = isMobile and 12 or 14
			percentLabel.TextColor3 = softText
			percentLabel.TextXAlignment = Enum.TextXAlignment.Left
			percentLabel.Size = UDim2.fromOffset(70, 20)
			percentLabel.Position = UDim2.new(0, 14, 0, isMobile and 6 or 7)
		end
	end

	-- Auto Grab UI: V1 = original layout, V2 = Sound card.
	local function applyAutoGrabBarStyle(style, shouldSave)
	barStyle = "4"
	_G["_SoundHub_UI_AutoGrabBarStyle"] = barStyle
	local savedNormalWidth = tonumber(_G["_SoundHub_UI_AutoGrabBarSize"]) or currentW
	local width = savedNormalWidth
	-- V2 is wider than the other versions
	if barStyle == "2" or barStyle == "7" then
		width = width + (isMobile and 90 or 120)
		local cam = workspace.CurrentCamera
		if cam then width = math.min(width, math.max(savedNormalWidth, cam.ViewportSize.X - 24)) end
	end
	local previousPosition = grabBarGui.Position
	local heights = {
		["1"] = isMobile and 52 or 64,
		["2"] = isMobile and 66 or 74,
		["3"] = isMobile and 66 or 76,
		["4"] = isMobile and 58 or 60,
		["5"] = isMobile and 50 or 58,
		["6"] = isMobile and 62 or 72,
		["7"] = isMobile and 40 or 46,
	}
	grabBarGui.Size = UDim2.fromOffset(width, heights[barStyle])
	if previousPosition.X.Scale == 0.5 then
		grabBarGui.Position = UDim2.new(0.5, -width / 2, previousPosition.Y.Scale, previousPosition.Y.Offset)
	end
	grabBarGui.BackgroundTransparency = 0
	grabBarGui.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
	outerReliefGradient.Color = ColorSequence.new(Color3.fromRGB(22, 22, 28), Color3.fromRGB(8, 8, 12))
	barStrokeInst.Color = barThemeColor:Lerp(Color3.fromRGB(255, 255, 255), 0.15)
	barStrokeInst.Thickness = 1.4
	barStrokeInst.Transparency = 0.25

	-- Base = V1 (original layout). The other versions override from here.
	sx.fillColor = nil
	sx.layer.Visible = false
	for _, item in ipairs({ sx.radius, sx.center, sx.left, sx.tag, sx.num, sx.fps, sx.ms, sx.scale, sx.line, sx.v2Art, sx.v2Logo, sx.v2Title, sx.v2Sub, sx.v2Pill }) do item.Visible = false end
	do -- reset shared style labels and corners for the retained Auto Grab UI
		local dflt = Color3.fromRGB(245, 245, 250)
		for _, lb in ipairs({ sx.num, sx.fps, sx.ms }) do lb.RichText = false; lb.TextColor3 = dflt; lb.Font = Enum.Font.GothamBlack end
		sx.num.TextXAlignment = Enum.TextXAlignment.Left
		sx.fps.TextXAlignment = Enum.TextXAlignment.Left
		sx.ms.TextXAlignment = Enum.TextXAlignment.Right
		sx.v2Sub.Text = DISCORD_TAG
		sx.v2Sub.TextColor3 = Color3.fromRGB(205, 210, 220)
		sx.v2Sub.Font = Enum.Font.GothamBold
		sx.v2Sub.TextXAlignment = Enum.TextXAlignment.Left
		sx.v2Sub.TextSize = isMobile and 10 or 11
		sx.v2Sub.Size = UDim2.new(1, -150, 0, 14)
		sx.v2Sub.Position = UDim2.fromOffset(62, 25)
		local bgC = barBg:FindFirstChildOfClass("UICorner")
		if bgC then bgC.CornerRadius = UDim.new(1, 0) end
		local flC = barFill:FindFirstChildOfClass("UICorner")
		if flC then flC.CornerRadius = UDim.new(1, 0) end
		local gbC = grabBarGui:FindFirstChildOfClass("UICorner")
		if gbC then gbC.CornerRadius = UDim.new(0, isMobile and 11 or 13) end
	end
	stealBarIcon.Visible = true
	stealBarIcon.Image = themedBarIcon()
	stealBarIcon.ImageTransparency = 0.1
	compactStyleIcon.Visible = false
	modePill.Visible = false
	autoGrabTitle.Visible = true
	autoGrabTitle.Text = "AUTO GRAB"
	autoGrabTitle.Font = Enum.Font.GothamBlack
	autoGrabTitle.TextSize = isMobile and 11 or 12
	autoGrabTitle.TextXAlignment = Enum.TextXAlignment.Left
	autoGrabTitle.Size = UDim2.new(1, -90, 0, 18)
	autoGrabTitle.Position = UDim2.new(0, 46, 0, isMobile and 7 or 9)
	percentLabel.Visible = true
	percentLabel.Font = Enum.Font.GothamBlack
	percentLabel.TextColor3 = Color3.fromRGB(245, 245, 250)
	percentLabel.Size = UDim2.fromOffset(52, 18)
	percentLabel.Position = UDim2.new(1, -102, 0, isMobile and 7 or 9)
	percentLabel.TextSize = isMobile and 14 or 16
	percentLabel.TextXAlignment = Enum.TextXAlignment.Right
	percentLabel.ZIndex = 502
	topRow.Visible = false
	statsDivider.Visible = true
	StatsRightFps.Parent = topRow
	StatsRightFps.Visible = false
	StatsRightPing.Parent = topRow
	StatsRightPing.Visible = false
	barBg.Size = UDim2.new(1, isMobile and -20 or -24, 0, 11)
	barBg.Position = UDim2.new(0, isMobile and 10 or 12, 1, isMobile and -18 or -20)
	barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	barTrackStroke.Transparency = 1
	paintFill(barThemeColor)
	resizeBtn.Visible = false
	resizeUpBtn.Visible = false
	resizeBtn.Size = UDim2.fromOffset(16, 16)
	resizeBtn.Position = UDim2.new(1, -22, 0, 3)
	resizeUpBtn.Size = UDim2.fromOffset(16, 16)
	resizeUpBtn.Position = UDim2.new(1, -42, 0, 3)
	resizeUpBtn.TextSize = 10
	resizeBtn.TextSize = 10
	resizeBtn.BackgroundColor3 = Color3.fromRGB(110, 110, 110)
	resizeUpBtn.BackgroundColor3 = Color3.fromRGB(110, 110, 110)
	resizeBtn.BackgroundTransparency = 0.2
	resizeUpBtn.BackgroundTransparency = 0.2
	for _, child in ipairs(barFill:GetChildren()) do
		if child.Name == "ProgressInsetGlow" or child.Name == "ProgressInsetShine" then child.Visible = true end
	end
	local particles = grabBarGui:FindFirstChild("ThemeParticles")

	if barStyle ~= "1" then
		sx.layer.Visible = true
		stealBarIcon.Visible = false
		modePill.Visible = false
		autoGrabTitle.Visible = false
		percentLabel.ZIndex = 509
		if particles then particles.Visible = false end
		local small = isMobile and 8 or 9
		-- tiny scale buttons stay reachable in the top-right corner
		resizeBtn.Size = UDim2.fromOffset(12, 12)
		resizeBtn.Position = UDim2.new(1, -16, 0, 3)
		resizeUpBtn.Size = UDim2.fromOffset(12, 12)
		resizeUpBtn.Position = UDim2.new(1, -30, 0, 3)
		resizeBtn.TextSize = 8
		resizeUpBtn.TextSize = 8
		resizeBtn.BackgroundTransparency = 0.55
		resizeUpBtn.BackgroundTransparency = 0.55
		for _, child in ipairs(barFill:GetChildren()) do
			if child.Name == "ProgressInsetGlow" or child.Name == "ProgressInsetShine" then child.Visible = false end
		end
		local accent = styleAccent()
		local halloween = styleIsHalloween()
		if barStyle == "2" then
			-- V2: Sound.VS style. Translucent grey panel, VH logo, blue title, discord sub, % pill, light-blue bar
			grabBarGui.BackgroundColor3 = Color3.fromRGB(78, 84, 96)
			grabBarGui.BackgroundTransparency = 0.12
			outerReliefGradient.Color = ColorSequence.new(Color3.fromRGB(88, 94, 108), Color3.fromRGB(62, 68, 80))
			barStrokeInst.Transparency = 1
			-- Same artwork as the menu background (azzurro / halloween)
			local artId = tostring(_G.__CrystalAutoGrabV2ImageId or "")
			if artId == "" then
				artId = halloween and ((getHalloweenBackground and getHalloweenBackground()) or HALLOWEEN_BACKGROUND or "rbxassetid://110140566078462") or (_G.__CrystalSoundIntroImage or "rbxassetid://100534832091396")
			end
			sx.v2Art.ImageTransparency = 0.3
			sx.v2Art.Image = artId
			sx.v2Art.Visible = artId ~= ""
			sx.v2Logo.Visible = true
			sx.v2Title.Visible = true
			sx.v2Sub.Visible = true
			sx.v2Pill.Visible = true
			percentLabel.Font = Enum.Font.GothamBlack
			percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			percentLabel.Size = UDim2.fromOffset(58, 22)
			percentLabel.Position = UDim2.new(1, -68, 0, 8)
			percentLabel.TextSize = isMobile and 12 or 13
			percentLabel.TextXAlignment = Enum.TextXAlignment.Center
			barBg.Size = UDim2.new(1, -76, 0, 12)
			barBg.Position = UDim2.new(0, 62, 1, -19)
			barBg.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
			barTrackStroke.Transparency = 1
			local v2Fill = Color3.fromRGB(150, 210, 255)
			sx.fillColor = v2Fill
			barFill.BackgroundColor3 = v2Fill
			fillGradient.Color = ColorSequence.new(v2Fill)
		elseif barStyle == "3" then
			-- V3: compact screenshot-inspired card: dark art panel, progress bar, community tag, FPS and ping.
			local v3Accent = accent
			grabBarGui.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
			grabBarGui.BackgroundTransparency = 0.04
			outerReliefGradient.Color = ColorSequence.new(Color3.fromRGB(20, 18, 30), Color3.fromRGB(5, 5, 10))
			barStrokeInst.Color = v3Accent
			barStrokeInst.Thickness = 1.6
			barStrokeInst.Transparency = 0.15
			local artId = tostring(_G.__CrystalAutoGrabV2ImageId or "")
			if artId == "" then artId = tostring(_G.__CrystalSoundIntroImage or "rbxassetid://100534832091396") end
			sx.v2Art.Image = artId
			sx.v2Art.ImageTransparency = 0.58
			sx.v2Art.Visible = artId ~= ""
			sx.v2Logo.Visible = false
			sx.v2Title.Visible = false
			sx.v2Sub.Visible = true
			sx.v2Pill.Visible = false
			sx.v2Sub.Text = tostring(_G.__CrystalAutoGrabV3Subtitle or "..GG/SoundDUEL")
			sx.v2Sub.TextColor3 = v3Accent
			sx.v2Sub.Font = Enum.Font.GothamBold
			sx.v2Sub.TextSize = isMobile and 10 or 12
			sx.v2Sub.Size = UDim2.new(0.54, 0, 0, 18)
			sx.v2Sub.Position = UDim2.new(0.23, 0, 1, -20)
			sx.num.Visible = true
			sx.num.Text = "STEALING"
			sx.num.TextColor3 = Color3.fromRGB(245, 245, 250)
			sx.num.Font = Enum.Font.GothamBlack
			sx.num.TextXAlignment = Enum.TextXAlignment.Left
			sx.num.TextSize = isMobile and 8 or 10
			sx.num.Size = UDim2.new(0, isMobile and 72 or 94, 0, 14)
			sx.num.Position = UDim2.fromOffset(12, 6)
			percentLabel.Visible = true
			percentLabel.TextColor3 = Color3.fromRGB(250, 250, 255)
			percentLabel.Font = Enum.Font.GothamBlack
			percentLabel.TextSize = isMobile and 14 or 17
			percentLabel.TextXAlignment = Enum.TextXAlignment.Left
			percentLabel.Size = UDim2.new(0, isMobile and 72 or 88, 0, 20)
			percentLabel.Position = UDim2.fromOffset(12, isMobile and 18 or 20)
			sx.fps.Visible = true
			sx.fps.TextColor3 = v3Accent:Lerp(Color3.fromRGB(255,255,255), 0.25)
			sx.fps.Size = UDim2.fromOffset(isMobile and 42 or 52, 14)
			sx.fps.Position = UDim2.new(1, isMobile and -52 or -62, 0, 5)
			sx.fps.TextSize = isMobile and 8 or 10
			sx.ms.Visible = true
			sx.ms.TextColor3 = v3Accent:Lerp(Color3.fromRGB(255,255,255), 0.25)
			sx.ms.Size = UDim2.fromOffset(isMobile and 42 or 52, 14)
			sx.ms.Position = UDim2.new(1, isMobile and -52 or -62, 0, 20)
			sx.ms.TextSize = isMobile and 8 or 10
		barBg.Size = UDim2.new(1, isMobile and -116 or -140, 0, isMobile and 9 or 11)
		barBg.Position = UDim2.new(0, isMobile and 90 or 112, 0, isMobile and 20 or 22)
		barBg.BackgroundColor3 = Color3.fromRGB(24, 22, 34)
		barTrackStroke.Color = v3Accent
		barTrackStroke.Transparency = 0.72
		barTrackStroke.Thickness = 1
		paintFill(v3Accent)
		for _, child in ipairs(barFill:GetChildren()) do
			if child.Name == "ProgressInsetGlow" or child.Name == "ProgressInsetShine" then child.Visible = true end
		end
		stealBarIcon.Visible = false
		autoGrabTitle.Visible = false
		modePill.Visible = false
		sx.line.Visible = true
		sx.line.BackgroundColor3 = v3Accent
		sx.line.BackgroundTransparency = 0.78
		sx.line.Size = UDim2.new(1, -16, 0, 1)
		sx.line.Position = UDim2.new(0, 8, 1, -2)
		resizeBtn.Visible = false
		resizeUpBtn.Visible = false
		elseif barStyle == "4" then
		-- V4: Halloween art, radius/title/% row, line, orange bar, FPS and ping details
			grabBarGui.BackgroundColor3 = halloween and Color3.fromRGB(14, 6, 2) or Color3.fromRGB(2, 8, 14)
			outerReliefGradient.Color = halloween and ColorSequence.new(Color3.fromRGB(20, 8, 3), Color3.fromRGB(8, 3, 1)) or ColorSequence.new(Color3.fromRGB(3, 12, 20), Color3.fromRGB(1, 4, 8))
			barStrokeInst.Color = accent
			barStrokeInst.Transparency = 0.2
			stealBarIcon.Visible = true
			stealBarIcon.Image = themedBarIcon()
			autoGrabTitle.Visible = true
			autoGrabTitle.Size = UDim2.new(1, -130, 0, 18)
			autoGrabTitle.Position = UDim2.fromOffset(65, 7)
			autoGrabTitle.TextXAlignment = Enum.TextXAlignment.Center
			autoGrabTitle.TextSize = isMobile and 11 or 13
			percentLabel.Size = UDim2.fromOffset(64, 22)
			percentLabel.Position = UDim2.new(1, -78, 0, 5)
			percentLabel.TextSize = isMobile and 15 or 18
			percentLabel.TextXAlignment = Enum.TextXAlignment.Right
			sx.num.Visible = true
			sx.num.Size = UDim2.fromOffset(isMobile and 100 or 125, 18)
			sx.num.Position = UDim2.fromOffset(10, 7)
			sx.num.TextSize = isMobile and 8 or 9
			sx.line.Visible = true
			sx.line.Size = UDim2.new(1, -28, 0, 1)
			sx.line.Position = UDim2.fromOffset(14, 30)
			sx.line.BackgroundColor3 = accent
			sx.line.BackgroundTransparency = 0.55
			barBg.Size = UDim2.new(1, -28, 0, 10)
			barBg.Position = UDim2.fromOffset(14, 38)
			barBg.BackgroundColor3 = halloween and Color3.fromRGB(34, 14, 4) or Color3.fromRGB(4, 20, 30)
			barTrackStroke.Color = accent
			barTrackStroke.Thickness = 1
			barTrackStroke.Transparency = 0.6
			sx.fillColor = accent
			paintFill(accent)
			-- Compact stats replace the old Radius label; no extra text row at the bottom.
			sx.fps.Visible = false
			sx.ms.Visible = false
			sx.scale.Visible = false
			sx.scale.Size = UDim2.fromOffset(80, 14)
			sx.scale.Position = UDim2.new(0.5, -40, 1, -21)
			sx.scale.TextSize = isMobile and 8 or 9
			resizeBtn.Size = UDim2.fromOffset(16, 16)
			resizeBtn.Position = UDim2.new(0.5, -62, 1, -23)
			resizeUpBtn.Size = UDim2.fromOffset(16, 16)
			resizeUpBtn.Position = UDim2.new(0.5, 46, 1, -23)
			resizeBtn.TextSize = 10
			resizeUpBtn.TextSize = 10
			resizeBtn.BackgroundColor3 = (halloween and Color3.fromRGB(70, 38, 14) or Color3.fromRGB(10, 44, 62))
			resizeUpBtn.BackgroundColor3 = (halloween and Color3.fromRGB(70, 38, 14) or Color3.fromRGB(10, 44, 62))
			resizeBtn.BackgroundTransparency = 0.1
			resizeUpBtn.BackgroundTransparency = 0.1
			for _, child in ipairs(barFill:GetChildren()) do
				if child.Name == "ProgressInsetGlow" or child.Name == "ProgressInsetShine" then child.Visible = true end
			end
		elseif barStyle == "5" then
			-- V5: blue progress card (AUTO GRAB / % ) + dark FPS-ping panel on the right
			local R = isMobile and 80 or 98
			local blue = Color3.fromRGB(30, 110, 235)
			grabBarGui.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			grabBarGui.BackgroundTransparency = 0
			outerReliefGradient.Color = ColorSequence.new(Color3.fromRGB(6, 8, 14), Color3.fromRGB(0, 0, 0))
			barStrokeInst.Color = Color3.fromRGB(40, 130, 255)
			barStrokeInst.Thickness = 1.4
			barStrokeInst.Transparency = 0.1
			sx.v2Art.Visible = false
			barBg.Size = UDim2.new(1, -(R + 4), 1, -4)
			barBg.Position = UDim2.fromOffset(2, 2)
			barBg.BackgroundColor3 = Color3.fromRGB(6, 14, 34)
			barTrackStroke.Transparency = 1
			local bgC = barBg:FindFirstChildOfClass("UICorner")
			if bgC then bgC.CornerRadius = UDim.new(0, isMobile and 9 or 11) end
			local flC = barFill:FindFirstChildOfClass("UICorner")
			if flC then flC.CornerRadius = UDim.new(0, isMobile and 9 or 11) end
			sx.fillColor = blue
			paintFill(blue)
			autoGrabTitle.Visible = true
			autoGrabTitle.Text = "AUTO GRAB"
			autoGrabTitle.Font = Enum.Font.GothamBlack
			autoGrabTitle.TextSize = isMobile and 10 or 12
			autoGrabTitle.TextColor3 = Color3.fromRGB(215, 232, 248)
			autoGrabTitle.TextXAlignment = Enum.TextXAlignment.Left
			autoGrabTitle.Size = UDim2.new(0.5, 0, 0, 14)
			autoGrabTitle.Position = UDim2.fromOffset(12, isMobile and 10 or 13)
			sx.v2Sub.Visible = true
			sx.v2Sub.Text = "LIGHT"
			sx.v2Sub.TextColor3 = Color3.fromRGB(160, 200, 235)
			sx.v2Sub.TextSize = isMobile and 8 or 9
			sx.v2Sub.Size = UDim2.new(0.5, 0, 0, 12)
			sx.v2Sub.Position = UDim2.fromOffset(12, isMobile and 26 or 31)
			percentLabel.Visible = true
			percentLabel.Font = Enum.Font.GothamBlack
			percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			percentLabel.TextSize = isMobile and 12 or 14
			percentLabel.TextXAlignment = Enum.TextXAlignment.Right
			percentLabel.Size = UDim2.fromOffset(56, 18)
			percentLabel.Position = UDim2.new(1, -(R + 4) - 62, 0.5, -9)
			sx.line.Visible = true
			sx.line.BackgroundColor3 = Color3.fromRGB(80, 100, 130)
			sx.line.BackgroundTransparency = 0.3
			sx.line.Size = UDim2.new(0, 1, 1, -16)
			sx.line.Position = UDim2.new(1, -(R - 4), 0, 8)
			for _, lb in ipairs({ sx.fps, sx.ms }) do
				lb.Visible = true
				lb.Font = Enum.Font.GothamBold
				lb.TextXAlignment = Enum.TextXAlignment.Left
				lb.TextColor3 = Color3.fromRGB(225, 236, 250)
				lb.TextSize = isMobile and 8 or 9
				lb.Size = UDim2.fromOffset(R - 12, 14)
			end
			sx.fps.Position = UDim2.new(1, -(R - 10), 0.5, isMobile and -15 or -17)
			sx.ms.Position = UDim2.new(1, -(R - 10), 0.5, isMobile and 1 or 3)
		elseif barStyle == "6" then
			-- V6: black line-art panel: STEALING / % on the left, purple bar + discord tag, big FPS / MS on the right
			local purple = (typeof(_G.__CrystalCurtAccent) == "Color3" and _G.__CrystalCurtAccent) or (_G.__SoundAccentColor and _G.__SoundAccentColor()) or Color3.fromRGB(46, 136, 255)
			grabBarGui.BackgroundColor3 = Color3.fromRGB(6, 6, 10)
			grabBarGui.BackgroundTransparency = 0
			outerReliefGradient.Color = ColorSequence.new(Color3.fromRGB(8, 10, 16), Color3.fromRGB(0, 0, 0))
			barStrokeInst.Color = Color3.fromRGB(30, 100, 220)
			barStrokeInst.Thickness = 1.3
			barStrokeInst.Transparency = 0.2
			local artId = tostring(_G.__CrystalAutoGrabV6ImageId or "")
			sx.v2Art.Image = artId
			sx.v2Art.ImageTransparency = 0.7
			sx.v2Art.Visible = artId ~= ""
			sx.num.Visible = true
			sx.num.Text = "STEALING"
			sx.num.Font = Enum.Font.GothamBlack
			sx.num.TextColor3 = Color3.fromRGB(245, 245, 250)
			sx.num.TextSize = isMobile and 8 or 10
			sx.num.TextXAlignment = Enum.TextXAlignment.Left
			sx.num.Size = UDim2.fromOffset(84, 12)
			sx.num.Position = UDim2.fromOffset(12, isMobile and 10 or 12)
			percentLabel.Visible = true
			percentLabel.Font = Enum.Font.GothamBlack
			percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			percentLabel.TextSize = isMobile and 16 or 19
			percentLabel.TextXAlignment = Enum.TextXAlignment.Left
			percentLabel.Size = UDim2.fromOffset(84, 24)
			percentLabel.Position = UDim2.fromOffset(12, isMobile and 26 or 31)
			barBg.Size = UDim2.new(1, -(96 + 88), 0, isMobile and 11 or 13)
			barBg.Position = UDim2.fromOffset(96, isMobile and 12 or 14)
			barBg.BackgroundColor3 = Color3.fromRGB(8, 14, 30)
			barTrackStroke.Transparency = 1
			sx.fillColor = purple
			paintFill(purple)
			sx.v2Sub.Visible = true
			sx.v2Sub.Text = tostring(_G.__CrystalAutoGrabV6Subtitle or DISCORD_TAG)
			sx.v2Sub.Font = Enum.Font.GothamBlack
			sx.v2Sub.TextColor3 = purple
			sx.v2Sub.TextXAlignment = Enum.TextXAlignment.Center
			sx.v2Sub.TextSize = isMobile and 10 or 12
			sx.v2Sub.Size = UDim2.new(1, -(96 + 88), 0, 18)
			sx.v2Sub.Position = UDim2.fromOffset(96, isMobile and 30 or 36)
			for _, lb in ipairs({ sx.fps, sx.ms }) do
				lb.Visible = true
				lb.Font = Enum.Font.GothamBlack
				lb.TextXAlignment = Enum.TextXAlignment.Right
				lb.TextSize = isMobile and 12 or 14
				lb.Size = UDim2.fromOffset(78, 18)
			end
			sx.fps.TextColor3 = Color3.fromRGB(120, 185, 255)
			sx.ms.TextColor3 = Color3.fromRGB(120, 185, 255)
			sx.fps.Position = UDim2.new(1, -86, 0, isMobile and 10 or 12)
			sx.ms.Position = UDim2.new(1, -86, 0, isMobile and 32 or 38)
		elseif barStyle == "7" then
			-- V7: slim pill: STEAL bar with % inside, hub name, FPS and Ping
			local purple = (typeof(_G.__CrystalCurtAccent) == "Color3" and _G.__CrystalCurtAccent) or (_G.__SoundAccentColor and _G.__SoundAccentColor()) or Color3.fromRGB(34, 120, 255)
			local ph = isMobile and 26 or 30
			grabBarGui.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			grabBarGui.BackgroundTransparency = 0
			outerReliefGradient.Color = ColorSequence.new(Color3.fromRGB(6, 8, 14), Color3.fromRGB(0, 0, 0))
			barStrokeInst.Color = purple
			barStrokeInst.Thickness = 1.5
			barStrokeInst.Transparency = 0.1
			sx.v2Art.Visible = false
			local gbC = grabBarGui:FindFirstChildOfClass("UICorner")
			if gbC then gbC.CornerRadius = UDim.new(1, 0) end
			barBg.Size = UDim2.new(0.44, 0, 0, ph)
			barBg.Position = UDim2.new(0, 7, 0.5, -ph / 2)
			barBg.BackgroundColor3 = Color3.fromRGB(4, 8, 18)
			barTrackStroke.Color = Color3.fromRGB(120, 175, 255)
			barTrackStroke.Thickness = 1
			barTrackStroke.Transparency = 0.35
			sx.fillColor = purple
			paintFill(purple)
			sx.num.Visible = true
			sx.num.Text = "STEAL"
			sx.num.Font = Enum.Font.GothamMedium
			sx.num.TextColor3 = Color3.fromRGB(255, 255, 255)
			sx.num.TextSize = isMobile and 9 or 11
			sx.num.TextXAlignment = Enum.TextXAlignment.Left
			sx.num.Size = UDim2.fromOffset(60, 16)
			sx.num.Position = UDim2.new(0, 20, 0.5, -8)
			percentLabel.Visible = true
			percentLabel.Font = Enum.Font.Gotham
			percentLabel.TextColor3 = Color3.fromRGB(215, 215, 225)
			percentLabel.TextSize = isMobile and 9 or 10
			percentLabel.TextXAlignment = Enum.TextXAlignment.Right
			percentLabel.Size = UDim2.fromOffset(46, 18)
			percentLabel.Position = UDim2.new(0.44, -50, 0.5, -9)
			sx.v2Sub.Visible = true
			sx.v2Sub.Text = tostring(_G.__CrystalAutoGrabV7Name or "Sound HUB")
			sx.v2Sub.Font = Enum.Font.GothamBlack
			sx.v2Sub.TextColor3 = purple:Lerp(Color3.fromRGB(255, 255, 255), 0.2)
			sx.v2Sub.TextXAlignment = Enum.TextXAlignment.Left
			sx.v2Sub.TextSize = isMobile and 10 or 12
			sx.v2Sub.Size = UDim2.new(0.22, 0, 0, 18)
			sx.v2Sub.Position = UDim2.new(0.44, 10, 0.5, -9)
			sx.line.Visible = true
			sx.line.BackgroundColor3 = Color3.fromRGB(50, 100, 190)
			sx.line.BackgroundTransparency = 0.35
			sx.line.Size = UDim2.new(0, 1, 0, ph - 8)
			sx.line.Position = UDim2.new(0.67, 0, 0.5, -(ph - 8) / 2)
			for _, lb in ipairs({ sx.fps, sx.ms }) do
				lb.Visible = true
				lb.RichText = true
				lb.Font = Enum.Font.GothamBold
				lb.TextXAlignment = Enum.TextXAlignment.Center
				lb.TextColor3 = Color3.fromRGB(225, 236, 255)
				lb.TextSize = isMobile and 8 or 10
				lb.Size = UDim2.new(0.15, 0, 0, 18)
			end
			sx.fps.Position = UDim2.new(0.685, 0, 0.5, -9)
			sx.ms.Position = UDim2.new(0.84, 0, 0.5, -9)
		end
	end
	resizeBtn.Visible = false
	resizeUpBtn.Visible = false
	resizeBtn.Active = false
	resizeUpBtn.Active = false
	if refreshStyleTexts then refreshStyleTexts() end
	applyAutoGrabSkin()
	if shouldSave ~= false then pcall(saveConfig) end
	return barStyle
end
_G.__CrystalSetAutoGrabBarStyle = function(skin)
	skin = tostring(skin or "")
	_G["_SoundHub_UI_AutoGrabSkin"] = "V1"
	applyAutoGrabBarStyle("4", true)
	return "V1"
end
_G.__CrystalRefreshAutoGrabBarStyle = function()
	return applyAutoGrabBarStyle(barStyle, false)
end
local function applyAutoStealBarTheme(themeName)
		barThemeColor = resolveAutoStealAccent()
		fillGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, barThemeColor:Lerp(Color3.fromRGB(255, 255, 255), 0.25)),
			ColorSequenceKeypoint.new(0.5, barThemeColor),
			ColorSequenceKeypoint.new(1, barThemeColor:Lerp(Color3.fromRGB(0, 20, 50), 0.2)),
		})
		barFill.BackgroundColor3 = barThemeColor
		if currentGrabSkin() ~= "V1" then
			pcall(applyAutoGrabSkin)
		end
		if sLetter then sLetter.TextColor3 = barThemeColor end
		if sSub then sSub.TextColor3 = barThemeColor end
		if leftDivider then leftDivider.BackgroundColor3 = barThemeColor end
		modePill.BackgroundColor3 = barThemeColor:Lerp(Color3.fromRGB(20, 60, 120), 0.35)
		barStrokeInst.Color = barThemeColor:Lerp(Color3.fromRGB(255, 255, 255), 0.15)
		barStrokeInst.Transparency = 0.35
		if percentLabel then percentLabel.TextColor3 = Color3.fromRGB(245, 245, 250) end
		if StatsRightPing then StatsRightPing.TextColor3 = barThemeColor:Lerp(Color3.fromRGB(255, 255, 255), 0.28) end
		if statsDivider then statsDivider.BackgroundColor3 = barThemeColor:Lerp(Color3.fromRGB(0, 0, 0), 0.55) end
		-- Full-bar art = same image as the main menu background
		if stealBarIcon then
			local halloweenOn = (_G.__CrystalHalloweenMode == true) or (toggleStates and toggleStates["Halloween Mode"] == true)
			local index = tonumber(_G["_SoundHub_UI_BgIndex"]) or 1
			local menuBg
			if halloweenOn then
				menuBg = (getHalloweenBackground and getHalloweenBackground() or HALLOWEEN_BACKGROUND or STEAL_ICON_HALLOWEEN)
			elseif type(backgroundIds) == "table" and backgroundIds[index] then
				menuBg = backgroundIds[index]
			else
				menuBg = STEAL_ICON_AZZURRO or "rbxassetid://100534832091396"
			end
			stealBarIcon.Image = menuBg or ""
			stealBarIcon.Visible = true
			stealBarIcon.ScaleType = Enum.ScaleType.Crop
			stealBarIcon.ImageTransparency = 0.12
			stealBarIcon.Size = UDim2.new(1, 0, 1, 0)
			stealBarIcon.Position = UDim2.new(0, 0, 0, 0)
			if compactStyleIcon and menuBg then
				compactStyleIcon.Image = menuBg
			end
		end
		applyAutoGrabBarStyle(barStyle, false)
		-- V2 must re-paint last so theme accent + background image are not overwritten
		if currentGrabSkin() ~= "V1" then
			pcall(applyAutoGrabSkin)
		end
		do
			local idx = tonumber(themeName) or tonumber(_G["_SoundHub_UI_BgIndex"]) or 1
			if type(_G.__CrystalSetStealBarParticles) == "function" then
				pcall(_G.__CrystalSetStealBarParticles, idx == 2 and _G["_SoundHub_UI_ColorTheme"] == "azure", idx)
			elseif type(setThemeParticles) == "function" then
				pcall(setThemeParticles, idx == 2, idx)
			end
		end
	end

	-- Azzurro particles ONLY when azzurro theme (bgIndex == 2)
	local particleLayer = Instance.new("Frame", grabBarGui)
	particleLayer.Name = "ThemeParticles"
	particleLayer.Size = UDim2.new(1, 0, 1, 0)
	particleLayer.BackgroundTransparency = 1
	particleLayer.ZIndex = 520
	particleLayer.ClipsDescendants = true
	particleLayer.Visible = false
	local particlesOn = false
	local particleConn = nil
	local spawnAcc = 0

	local function clearParticles()
		for _, ch in ipairs(particleLayer:GetChildren()) do
			pcall(function() ch:Destroy() end)
		end
	end

	local function stopParticles()
		particlesOn = false
		particleLayer.Visible = false
		if particleConn then
			pcall(function() particleConn:Disconnect() end)
			particleConn = nil
		end
		clearParticles()
	end

	local function startAzzurroParticles()
		if particlesOn and particleConn then
			particleLayer.Visible = true
			return
		end
		stopParticles()
		particlesOn = true
		particleLayer.Visible = true
		spawnAcc = 0
		particleConn = RunService.Heartbeat:Connect(function(dt)
			if not particlesOn then return end
			if not grabBarGui.Parent or grabBarGui.Visible == false then return end
			spawnAcc = spawnAcc + (dt or 0)
			local barW = math.max(1, grabBarGui.AbsoluteSize.X)
			local barH = math.max(1, grabBarGui.AbsoluteSize.Y)
			while spawnAcc >= 0.055 do
				spawnAcc = spawnAcc - 0.055
				if #particleLayer:GetChildren() >= 36 then break end
				local p = Instance.new("Frame")
				local sz = math.random(3, 6)
				p.Size = UDim2.fromOffset(sz, sz)
				p.Position = UDim2.fromOffset(math.random(0, math.floor(barW)), -sz)
				p.BackgroundColor3 = Color3.fromRGB(math.random(70, 140), math.random(180, 230), 255)
				p.BackgroundTransparency = math.random(5, 25) / 100
				p.BorderSizePixel = 0
				p.ZIndex = 521
				Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
				p.Parent = particleLayer
				local speed = math.random(32, 62)
				local drift = math.random(-14, 14)
				local life = 0
				-- fade out near the bottom of the bar (not at the hard UI edge)
				local fadeStart = math.max(8, barH * 0.55)
				local fadeEnd = math.max(fadeStart + 6, barH * 0.92)
				local pConn
				pConn = RunService.Heartbeat:Connect(function(pdt)
					if not p.Parent then
						if pConn then pConn:Disconnect() end
						return
					end
					life = life + (pdt or 0)
					local y = life * speed
					local x = p.Position.X.Offset + drift * (pdt or 0)
					p.Position = UDim2.fromOffset(x, y - sz)
					local baseT = 0.08
					if y >= fadeEnd then
						if pConn then pConn:Disconnect() end
						p:Destroy()
						return
					elseif y >= fadeStart then
						local fadeT = (y - fadeStart) / math.max(1, fadeEnd - fadeStart)
						p.BackgroundTransparency = math.clamp(baseT + fadeT * 0.92, 0, 1)
					else
						p.BackgroundTransparency = baseT
					end
				end)
			end
		end)
		_G.__CrystalTrackConn(particleConn)
	end

	local function setThemeParticles(enabled, index)
		-- particles disabled (no pink particles on any theme)
		stopParticles()
	end

	local function setAzzurroParticles(enabled)
		local idx = tonumber(_G["_SoundHub_UI_BgIndex"]) or 1
		setThemeParticles(idx == 2 and _G["_SoundHub_UI_ColorTheme"] == "azure", idx)
	end

	_G.__CrystalApplyAutoStealBarTheme = applyAutoStealBarTheme
	_G.__CrystalSetStealBarParticles = setThemeParticles
	applyAutoStealBarTheme(_G.__CrystalGuiTheme or "GUI 1")
	do
		local idx = tonumber(_G["_SoundHub_UI_BgIndex"]) or 1
		setThemeParticles(idx == 2 and _G["_SoundHub_UI_ColorTheme"] == "azure", idx)
	end

	-- Keep aliases used by the update loop
	local barLabel = autoGrabTitle
	local statusLabel = autoGrabTitle
	local barPercentLabel = percentLabel
	local function autoGrabModeName(_mode)
		return ""
	end
	local titleLabel = modePill
	titleLabel.Text = ""
	local function refreshModePill()
		modePill.Text = ""
		modePill.Visible = false
	end
	refreshModePill()
	refreshStyleTexts = function()
		if barStyle == "1" then return end
		local fps = tostring(StatsRightFps and StatsRightFps.Text or ""):match("%d+") or "0"
		local ping = tostring(StatsRightPing and StatsRightPing.Text or ""):match("%d+") or "0"
		local radius = math.floor(tonumber(autoStealValues.Radius) or 65)
		if skinUi and skinUi.v2Fps then
			local okMode, modeName = pcall(function() return selectedMode end)
			modeName = (okMode and modeName) and string.upper(tostring(modeName)) or "NORMAL"
			skinUi.v2Fps.Text = "FPS: " .. fps
			skinUi.v2Center.Text = modeName .. " " .. tostring(radius) .. " RADIUS"
			skinUi.v2Ping.Text = "PING: " .. ping .. "ms"
			if skinUi.v2barTitle then
				skinUi.v2barTitle.Text = "Vicious"
				if skinUi.v2barPct then skinUi.v2barPct.Text = tostring(percentLabel.Text) end
				skinUi.v2barFps.Text = fps .. " FPS"
				skinUi.v2barPing.Text = ping .. " PING"
			end
			if skinUi.bubMode then
				skinUi.bubMode.Text = modeName .. " " .. tostring(radius)
				skinUi.bubStats.Text = fps .. " FPS  " .. ping .. "ms"
			end
		end
		if barStyle == "2" then
			-- static V2 text
		elseif barStyle == "4" then
			sx.num.Text = "PING " .. ping .. " / FPS " .. fps
			sx.fps.Visible = false
			sx.ms.Visible = false
		elseif barStyle == "5" then
			autoGrabTitle.Text = "AUTO GRAB"
			sx.v2Sub.Text = "LIGHT"
			sx.fps.Text = fps .. " FPS"
			sx.ms.Text = ping .. "ms PING"
		elseif barStyle == "6" then
			sx.num.Text = "STEALING"
			sx.fps.Text = fps .. " FPS"
			sx.ms.Text = ping .. " MS"
		elseif barStyle == "7" then
			sx.num.Text = "STEAL"
			sx.fps.Text = 'FPS <font color="rgb(90,170,255)">' .. fps .. '</font>'
			sx.ms.Text = 'Ping <font color="rgb(90,170,255)">' .. ping .. '</font>'
		else
			sx.num.Text = tostring(radius)
			sx.fps.Text = fps .. " FPS"
			sx.ms.Text = ping .. " MS"
			sx.scale.Text = ""
			sx.scale.Visible = false
			autoGrabTitle.Text = "AUTO GRAB"
		end
	end
	refreshStyleTexts()

	_G.__CrystalRefreshStealBarModePill = refreshModePill


	local _barDragging = false
	local _barDragStart = nil
	local _barDragInput = nil
	_G.__CrystalGuiPositionResetters.AutoGrab = function()
	_barDragging = false
	_barDragStart = nil
	_barDragInput = nil
	grabBarGui.AnchorPoint = Vector2.new(0, 0)
	grabBarGui.Position = UDim2.new(0.5, -currentW / 2, 0.80, 0)
	_G["_SoundHub_UI_AutoGrabBarPos"] = nil
	end
	grabBarGui.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
	_barDragging = true
	_barDragStart = { pointer = inp.Position, position = grabBarGui.Position }
	if inp.UserInputType == Enum.UserInputType.Touch then _barDragInput = inp end
	end
	end)
	grabBarGui.InputChanged:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
	_barDragInput = inp
	end
	end)
	_G.__CrystalTrackConn(UserInputService.InputChanged:Connect((function(inp)
	if not _barDragging or not _barDragStart or inp ~= _barDragInput then return end
	if inp.UserInputType ~= Enum.UserInputType.MouseMovement and inp.UserInputType ~= Enum.UserInputType.Touch then return end
	local delta = inp.Position - _barDragStart.pointer
	local nextX = _barDragStart.position.X.Offset + delta.X
	local nextY = _barDragStart.position.Y.Offset + delta.Y
	grabBarGui.Position = UDim2.fromOffset(nextX, nextY)
	end)))
	_G.__CrystalTrackConn(UserInputService.InputEnded:Connect(function(inp)
	if _barDragging and (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then
	-- Aplică și ultima poziție a cursorului la eliberare; ultimul InputChanged
	-- poate sosi înainte ca cursorul să ajungă chiar la marginea de jos.
	local delta = inp.Position - _barDragStart.pointer
	local finalX = _barDragStart.position.X.Offset + delta.X
	local finalY = _barDragStart.position.Y.Offset + delta.Y
	_barDragging = false
	grabBarGui.AnchorPoint = Vector2.new(0, 0)
	grabBarGui.Position = UDim2.fromOffset(finalX, finalY)
	_G["_SoundHub_UI_AutoGrabBarPos"] = { x = finalX, y = finalY }
	_barDragStart = nil
	_barDragInput = nil
	saveConfig()
	end
	end))

	local grabBarState = {
	displayProgress = 0,
	radiusProgress = 0,
	targetInRadius = false,
	radiusCheckElapsed = 0,
	uiElapsed = 0,
	lastVisible = nil,
	lastPercent = nil,
	lastActive = nil,
	lastMode = nil,
	}
	FeaturePostToggle["Steal Bar"] = function(active)
		local visible = active == true
		grabBarGui.Visible = visible
		grabBarState.lastVisible = visible
	end
	_G.__CrystalTrackConn(RunService.Heartbeat:Connect((function(dt)

	grabBarState.uiElapsed = grabBarState.uiElapsed + (dt or 0)
	if grabBarState.uiElapsed < (1 / 20) then return end
	dt = grabBarState.uiElapsed
	grabBarState.uiElapsed = 0
	if grabBarState.lastMode ~= autoStealMode then
	grabBarState.lastMode = autoStealMode
	if modePill then modePill.Text = ""; modePill.Visible = false end
	end

	if toggleStates["Steal Bar"] ~= true then
	if grabBarState.lastVisible ~= false then
	grabBarGui.Visible = false
	grabBarState.lastVisible = false
	end
	return
	end

	grabBarState.radiusCheckElapsed = grabBarState.radiusCheckElapsed + (dt or 0)
	local ragdollBlocked = _G.__CrystalAutoGrabRagdollBlocked == true
	if ragdollBlocked then
	grabBarState.targetInRadius = false
	grabBarState.radiusProgress = 0
	end
	if grabBarState.radiusCheckElapsed >= 0.25 then
	grabBarState.radiusCheckElapsed = 0
	grabBarState.targetInRadius = false
	local autoGrabBusy = (StealState and StealState.active)
		or (V2 and V2.busy) or (V3New and V3New.busy)

	if not ragdollBlocked and not autoGrabBusy and toggleStates["auto steal"] == true and _G.__CrystalAutoGrabTargetInRadius then
	local activeRadius = math.clamp(tonumber(autoStealValues.Radius) or 65, 10, 150)
	local ok, inRange = pcall(_G.__CrystalAutoGrabTargetInRadius, activeRadius)
	grabBarState.targetInRadius = ok and inRange == true
	end
	end

	local actualProgress = ragdollBlocked and 0 or math.clamp(v1Progress or 0, 0, 1)
	if grabBarState.targetInRadius then
	if actualProgress > 0 then
	grabBarState.radiusProgress = actualProgress
	else
	local fillDuration = math.max(0.1, tonumber(autoStealValues.Duration) or 1.3)
	grabBarState.radiusProgress = grabBarState.radiusProgress + (dt or 0) / fillDuration
	if grabBarState.radiusProgress >= 1 then grabBarState.radiusProgress = 0 end
	end
	else
	grabBarState.radiusProgress = 0
	end

	local progress = math.max(actualProgress, grabBarState.radiusProgress)
	local totalW = barBg.AbsoluteSize.X
	if totalW <= 0 then totalW = grabBarGui.AbsoluteSize.X - (isMobile and 76 or 88) end
	if totalW <= 0 then totalW = isMobile and 192 or 222 end
	local targetW = math.clamp(progress * totalW, 0, totalW)
	local currentW = grabBarState.displayProgress * totalW
	local lerpSpeed = progress > grabBarState.displayProgress and 18 or 22
	currentW = currentW + (targetW - currentW) * math.min(lerpSpeed * dt, 1)
	if math.abs(currentW - targetW) < 0.5 then currentW = targetW end
	grabBarState.displayProgress = totalW > 0 and math.clamp(currentW / totalW, 0, 1) or 0
	barFill.Size = UDim2.new(0, currentW, 1, 0)

	local shouldShowGrab = toggleStates["Steal Bar"] == true
	if shouldShowGrab ~= grabBarState.lastVisible then
	grabBarGui.Visible = shouldShowGrab
	grabBarState.lastVisible = shouldShowGrab
	end

	do
	local pct = math.floor(progress * 100)
	pct = math.clamp(pct, 0, 100)
	if pct ~= grabBarState.lastPercent then
	percentLabel.Text = tostring(pct) .. "%"
	if barPercentLabel then barPercentLabel.Text = tostring(pct) .. "%" end
	grabBarState.lastPercent = pct
	end
	end
	if barStyle ~= "1" and refreshStyleTexts then refreshStyleTexts() end
	local grabIsActive = progress > 0
	if grabIsActive and grabBarState.lastActive ~= true then
	barFill.BackgroundColor3 = sx.fillColor or barThemeColor
	if barStyle == "1" then
	barStrokeInst.Color = barThemeColor:Lerp(Color3.fromRGB(255, 255, 255), 0.12)
	barStrokeInst.Transparency = 0.12
	end
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	end
	grabBarState.lastActive = grabIsActive
	end)))
	end)()


	-- ==================== VIVID GRAPHICS + X-RAY (from Ambitious) ====================
	do
		_G._CrystalVivid = _G._CrystalVivid or {
			saturation = 0.6,
			bloomIntensity = 0.8,
			bloomSize = 24,
			dofFocus = 25,
			sunIntensity = 0.2,
		}
		local vividEnabled = false
		local vividContrastConn = nil

		local function enableVividGraphics()
			vividEnabled = true
			for _, child in ipairs(Lighting:GetChildren()) do
				if child:GetAttribute("_CrystalVivid") then pcall(function() child:Destroy() end) end
			end
			local color = Instance.new("ColorCorrectionEffect")
			color:SetAttribute("_CrystalVivid", true)
			color.Parent = Lighting
			color.Saturation = _G._CrystalVivid.saturation
			color.Contrast = 0.4
			color.Brightness = 0.05
			color.TintColor = Color3.fromRGB(255, 240, 220)

			local bloom = Instance.new("BloomEffect")
			bloom:SetAttribute("_CrystalVivid", true)
			bloom.Parent = Lighting
			bloom.Intensity = _G._CrystalVivid.bloomIntensity
			bloom.Size = _G._CrystalVivid.bloomSize
			bloom.Threshold = 1

			local atmosphere = Instance.new("Atmosphere")
			atmosphere:SetAttribute("_CrystalVivid", true)
			atmosphere.Parent = Lighting
			atmosphere.Density = 0.3
			atmosphere.Offset = 0.25
			atmosphere.Color = Color3.fromRGB(199, 199, 255)
			atmosphere.Decay = Color3.fromRGB(106, 112, 125)
			atmosphere.Glare = 0.2
			atmosphere.Haze = 1

			local sun = Instance.new("SunRaysEffect")
			sun:SetAttribute("_CrystalVivid", true)
			sun.Parent = Lighting
			sun.Intensity = _G._CrystalVivid.sunIntensity
			sun.Spread = 0.8

			local dof = Instance.new("DepthOfFieldEffect")
			dof:SetAttribute("_CrystalVivid", true)
			dof.Parent = Lighting
			dof.FocusDistance = _G._CrystalVivid.dofFocus
			dof.InFocusRadius = 10
			dof.NearIntensity = 0.2
			dof.FarIntensity = 0.4

			if vividContrastConn then pcall(function() task.cancel(vividContrastConn) end) vividContrastConn = nil end
			vividContrastConn = task.spawn(function()
				while vividEnabled do
					if color and color.Parent then
						color.Contrast = 0.35 + math.sin(tick() * 2) * 0.05
					end
					task.wait(0.12) -- FPS FIX: was 30 Lighting writes/sec forever
				end
			end)
		end

		local function disableVividGraphics()
			vividEnabled = false
			if _G.__CrystalReleaseGraphics then _G.__CrystalReleaseGraphics("Vivid Graphics") end
			if vividContrastConn then
				pcall(function() task.cancel(vividContrastConn) end)
				vividContrastConn = nil
			end
			for _, child in ipairs(Lighting:GetChildren()) do
				if child:GetAttribute("_CrystalVivid") then
					pcall(function() child:Destroy() end)
				end
			end
		end

		FeaturePostToggle["Vivid Graphics"] = function(active)
			if active then if _G.__CrystalExclusiveGraphics then _G.__CrystalExclusiveGraphics("Vivid Graphics") end enableVividGraphics() else disableVividGraphics() end
		end
		_G.__CrystalTrackStopper(disableVividGraphics)

		-- X-Ray: make plot structure semi-transparent
		_G._CrystalXRayFolders = {
			"Base", "PlotSign", "FriendPanel", "Cash", "Laser",
			"Decorations", "Skin", "Unlock", "Purchases",
		}
		_G._CrystalXRayOrigTrans = {}
		_G._CrystalXRayConns = {}
		_G._CrystalXRayLoopId = 0

		local function setXRayTargetTransparency(instance, alphaPercent, loopId)
			if not instance then return end
			if loopId and loopId ~= _G._CrystalXRayLoopId then return end
			local function apply(obj)
				if obj:IsA("BasePart") then
					if _G._CrystalXRayOrigTrans[obj] == nil then
						_G._CrystalXRayOrigTrans[obj] = obj.Transparency
					end
					local orig = _G._CrystalXRayOrigTrans[obj]
					if orig < 1 then
						local target = orig + (1 - orig) * alphaPercent
						if math.abs(obj.Transparency - target) > 0.01 then
							obj.Transparency = target
						end
					end
				elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
					if _G._CrystalXRayOrigTrans[obj] == nil then
						_G._CrystalXRayOrigTrans[obj] = { text = obj.TextTransparency, bg = obj.BackgroundTransparency }
					end
					local orig = _G._CrystalXRayOrigTrans[obj]
					if orig.text < 1 then
						local target = orig.text + (1 - orig.text) * alphaPercent
						if math.abs(obj.TextTransparency - target) > 0.01 then obj.TextTransparency = target end
					end
					if orig.bg < 1 then
						local target = orig.bg + (1 - orig.bg) * alphaPercent
						if math.abs(obj.BackgroundTransparency - target) > 0.01 then obj.BackgroundTransparency = target end
					end
				elseif obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
					if _G._CrystalXRayOrigTrans[obj] == nil then
						_G._CrystalXRayOrigTrans[obj] = obj.BackgroundTransparency
					end
					local orig = _G._CrystalXRayOrigTrans[obj]
					if orig < 1 then
						local target = orig + (1 - orig) * alphaPercent
						if math.abs(obj.BackgroundTransparency - target) > 0.01 then obj.BackgroundTransparency = target end
					end
				elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
					if _G._CrystalXRayOrigTrans[obj] == nil then
						_G._CrystalXRayOrigTrans[obj] = { img = obj.ImageTransparency, bg = obj.BackgroundTransparency }
					end
					local orig = _G._CrystalXRayOrigTrans[obj]
					if orig.img < 1 then
						local target = orig.img + (1 - orig.img) * alphaPercent
						if math.abs(obj.ImageTransparency - target) > 0.01 then obj.ImageTransparency = target end
					end
					if orig.bg < 1 then
						local target = orig.bg + (1 - orig.bg) * alphaPercent
						if math.abs(obj.BackgroundTransparency - target) > 0.01 then obj.BackgroundTransparency = target end
					end
				end
			end
			pcall(apply, instance)
			for _, d in ipairs(instance:GetDescendants()) do
				if loopId and loopId ~= _G._CrystalXRayLoopId then return end
				pcall(apply, d)
			end
		end

		local function trackXRaySubtree(root, alphaPercent, loopId)
			if not root then return end
			if loopId ~= _G._CrystalXRayLoopId then return end
			setXRayTargetTransparency(root, alphaPercent, loopId)
			if loopId ~= _G._CrystalXRayLoopId then return end
			table.insert(_G._CrystalXRayConns, root.DescendantAdded:Connect(function(obj)
				if loopId ~= _G._CrystalXRayLoopId then return end
				setXRayTargetTransparency(obj, alphaPercent, loopId)
			end))
		end

		local function processPlotXRay(plot, alphaPercent, loopId)
			if not plot then return end
			for _, fname in ipairs(_G._CrystalXRayFolders) do
				if loopId ~= _G._CrystalXRayLoopId then return end
				trackXRaySubtree(plot:FindFirstChild(fname), alphaPercent, loopId)
			end
			if loopId ~= _G._CrystalXRayLoopId then return end
			table.insert(_G._CrystalXRayConns, plot.ChildAdded:Connect(function(child)
				if loopId ~= _G._CrystalXRayLoopId then return end
				for _, fname in ipairs(_G._CrystalXRayFolders) do
					if child.Name == fname then
						trackXRaySubtree(child, alphaPercent, loopId)
						break
					end
				end
			end))
			local animalPodiums = plot:FindFirstChild("AnimalPodiums")
			if animalPodiums then
				local function processPodium(podium)
					for _, child in ipairs(podium:GetChildren()) do
						if child.Name == "Claim" then
							trackXRaySubtree(child, alphaPercent, loopId)
						elseif child.Name == "Base" then
							trackXRaySubtree(child:FindFirstChild("Decorations"), alphaPercent, loopId)
						elseif child:IsA("Model") and child.Name ~= "Decorations" then
							trackXRaySubtree(child, alphaPercent, loopId)
						end
					end
				end
				for _, podium in ipairs(animalPodiums:GetChildren()) do
					processPodium(podium)
				end
				table.insert(_G._CrystalXRayConns, animalPodiums.ChildAdded:Connect(function(podium)
					if loopId ~= _G._CrystalXRayLoopId then return end
					task.wait(0.1)
					if loopId ~= _G._CrystalXRayLoopId then return end
					processPodium(podium)
				end))
			end
		end

		local function applyTransparencyToAllPlotsXRay(alphaPercent, loopId)
			local plotsFolder = workspace:FindFirstChild("Plots")
			if not plotsFolder then return end
			for _, plot in ipairs(plotsFolder:GetChildren()) do
				if loopId ~= _G._CrystalXRayLoopId then return end
				processPlotXRay(plot, alphaPercent, loopId)
				task.wait()
			end
			table.insert(_G._CrystalXRayConns, plotsFolder.ChildAdded:Connect(function(plot)
				if loopId ~= _G._CrystalXRayLoopId then return end
				task.wait(0.2)
				processPlotXRay(plot, alphaPercent, loopId)
			end))
		end

		local function setXRay(enabled)
			for _, conn in ipairs(_G._CrystalXRayConns) do
				if typeof(conn) == "RBXScriptConnection" then pcall(function() conn:Disconnect() end) end
			end
			_G._CrystalXRayConns = {}
			_G._CrystalXRayLoopId = (_G._CrystalXRayLoopId or 0) + 1
			local currentLoopId = _G._CrystalXRayLoopId
			if enabled then
				local alphaPercent = 0.5
				task.spawn(function()
					while currentLoopId == _G._CrystalXRayLoopId and not workspace:FindFirstChild("Plots") do
						task.wait(0.5)
					end
					if currentLoopId ~= _G._CrystalXRayLoopId then return end
					pcall(applyTransparencyToAllPlotsXRay, alphaPercent, currentLoopId)
				end)
			else
				local snapshot = _G._CrystalXRayOrigTrans
				_G._CrystalXRayOrigTrans = {}
				for obj, orig in pairs(snapshot) do
					pcall(function()
						if obj:IsA("BasePart") then
							obj.Transparency = orig
						elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
							obj.TextTransparency = orig.text
							obj.BackgroundTransparency = orig.bg
						elseif obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
							obj.BackgroundTransparency = orig
						elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
							obj.ImageTransparency = orig.img
							obj.BackgroundTransparency = orig.bg
						end
					end)
				end
			end
		end

		FeaturePostToggle["X-Ray"] = function(active)
			pcall(setXRay, active == true)
		end
		_G.__CrystalTrackStopper(function()
			pcall(setXRay, false)
		end)
	end

	local visualSection = makeUraniumSection(tabPages.Visuals, "VISUALS")
	makeToggleNoKeybind(visualSection, "Vivid Graphics", "Vivid Graphics")
	makeToggleNoKeybind(visualSection, "X-Ray", "X-Ray")

	_G.__visualSection = visualSection

	makeToggleNoKeybind(visualSection, "ESP Players", "ESP Players")
	makeToggleNoKeybind(visualSection, "Skeleton ESP", "Skeleton ESP")
	makeToggleNoKeybind(visualSection, "Player Tracers", "Player Tracers")

	local optimizerMode = "Ultra"
	local optimizerModeRefreshers = {}
	local applySky
	local skyCurrentMode
	local function refreshOptimizerModeUI()
	for _, refresh in ipairs(optimizerModeRefreshers) do pcall(refresh, optimizerMode) end
	end
	local function setOptimizerMode(mode)
	if mode ~= "Normal" and mode ~= "Ultra" then mode = "Normal" end
	optimizerMode = mode
	_G.__optimizerMode = mode
	refreshOptimizerModeUI()
	pcall(saveConfig)
	if toggleStates["Optimizer"] and FeaturePostToggle["Optimizer"] then
	FeaturePostToggle["Optimizer"](false)
	FeaturePostToggle["Optimizer"](true)
	end
	end
	if _G.__optimizerMode == "Normal" or _G.__optimizerMode == "Ultra" then
	optimizerMode = _G.__optimizerMode
	else
	_G.__optimizerMode = optimizerMode
	end

	do
	local optimizerActive = false
	local optimizerConn = nil
	local optimizerLightingConn = nil
	local optimizerCharConn = nil
	local optimizerWalkCancel = nil
	local defLightBrightness, defLightClock, defLightAmbient
	local removeAccessoriesEnabled = false
	local lowHarshUntil = 0
	local lowFlagGeneration = 0
	local optimizerUltraOriginals = {}
	local optimizerProcessed = setmetatable({}, { __mode = "k" })
	local optimizerRestoreToken = 0

	local function rememberUltraState(obj, state)
	if optimizerUltraOriginals[obj] == nil then optimizerUltraOriginals[obj] = state end
	end

	local function restoreUltraState()
	-- FPS FIX: restoring every saved part in one synchronous loop froze the
	-- client on toggle-off. Snapshot, then restore in small chunks per frame.
	-- Aborts if Optimizer is turned back on or another graphics mode takes over.
	optimizerRestoreToken = optimizerRestoreToken + 1
	local token = optimizerRestoreToken
	local snapshot = {}
	for obj, original in pairs(optimizerUltraOriginals) do
	snapshot[#snapshot + 1] = {obj, original}
	end
	optimizerUltraOriginals = {}
	if #snapshot == 0 then return end
	task.spawn(function()
	for i, entry in ipairs(snapshot) do
	if optimizerRestoreToken ~= token or optimizerActive then return end
	local owner = _G.__CrystalDerenderOwner
	if owner and owner ~= "Optimizer" and owner ~= "Vivid Graphics" then return end
	local obj, original = entry[1], entry[2]
	pcall(function()
	if original.Parent ~= nil and obj.Parent == nil and original.Parent.Parent ~= nil then
	obj.Parent = original.Parent
	end
	if obj.Parent ~= nil then
	if original.Material ~= nil then obj.Material = original.Material end
	if original.Reflectance ~= nil then obj.Reflectance = original.Reflectance end
	if original.CastShadow ~= nil then obj.CastShadow = original.CastShadow end
	if original.Transparency ~= nil then obj.Transparency = original.Transparency end
	if original.Enabled ~= nil then obj.Enabled = original.Enabled end
	end
	end)
	if i % 150 == 0 then task.wait() end
	end
	end)
	end

	local lowFlags = {
	{"DFIntClusterSenderMaxJoinBandwidthBps", "2100000000"},
	{"DFIntClusterSenderMaxUpdateBandwidthBps", "2100000000"},
	{"DFIntServerFramesBetweenJoins", "1"},
	{"DFIntRaknetBandwidthInfluxHundredthsPercentageV2", "10000"},
	{"DFIntConnectionMTUSize", "1400"},
	{"FIntRakNetResendBufferArrayLength", "1024"},
	{"DFIntRakNetNakResendDelayMsMax", "1"},
	{"DFIntWaitOnUpdateNetworkLoopEndedMS", "100"},
	{"DFIntWaitOnRecvFromLoopEndedMS", "100"},
	{"DFIntLargePacketQueueSizeCutoffMB", "1000"},
	{"DFIntSendRakNetStatsInterval", "2147483647"},
	{"DFIntRakNetLoopMs", "1"},
	{"DFIntRakNetSelectTimeoutMs", "1"},
	{"DFIntNetworkClusterPacketCacheNumParallelTasks", "8"},
	{"DFIntReplicationDataCacheNumParallelTasks", "8"},
	{"DFIntMegaReplicatorNumParallelTasks", "16"},
	{"DFIntMegaReplicatorNetworkQualityProcessorUnit", "10"},
	{"DFIntMaxProcessPacketsStepsPerCyclic", "512"},
	{"DFIntMaxProcessPacketsStepsAccumulated", "0"},
	{"DFIntMaxProcessPacketsJobScaling", "1000"},
	{"DFIntClientPacketMaxFrameMicroseconds", "200000"},
	{"DFIntClientPacketExcessMicroseconds", "10000"},
	{"DFIntClientPacketMinMicroseconds", "1"},
	{"DFIntClientPacketMaxDelayMs", "1"},
	{"DFIntMaxWaitTimeBeforeForcePacketProcessMS", "1"},
	{"DFIntMaxFrameBufferSize", "4"},
	{"DFIntBufferCompressionThreshold", "100"},
	{"DFIntOverrideISRReplicatorStepBandwidthBytes", "131072"},
	{"DFIntTaskSchedulerJobInitThreads", "8"},
	{"DFIntTaskSchedulerJobInGameThreads", "8"},
	{"FIntTaskSchedulerAutoThreadLimit", "16"},
	{"FIntTaskSchedulerAsyncTasksMinimumThreadCount", "4"},
	{"DFIntRuntimeConcurrency", "16"},
	{"FIntSimWorldTaskQueueParallelTasks", "20"},
	{"DFIntHttpBatchLimit", "256"},
	{"FIntHttpBatchLimit", "256"},
	{"DFIntHttpCurlConnectionCacheSize", "512"},
	{"FIntDefaultMeshCacheSizeMB", "512"},
	{"DFIntMemCacheMaxCapacityMB", "256"},
	{"DFIntNumAssetsMaxToPreload", "1"},
	{"DFFlagEnableSoundPreloading", "false"},
	{"FFlagSlimContentProvider", "true"},
	{"DFFlagDebugSkipMeshVoxelizer", "true"},
	{"DFFlagTextureQualityOverrideEnabled", "true"},
	{"DFIntTextureQualityOverride", "0"},
	{"FIntDebugTextureManagerSkipMips", "7"},
	{"DFIntDebugLimitMinTextureResolutionWhenSkipMips", "8"},
	{"FFlagTM2SkipMipsForUnstreamable2", "true"},
	{"DFFlagDoNotSkipMipsBasedOnSystemMemoryPS", "true"},
	{"FFlagRenderUseTextureManager224", "false"},
	{"DFIntDebugFRMQualityLevelOverride", "1"},
	{"DFFlagDebugPauseVoxelizer", "true"},
	{"FFlagFastGPULightCulling3", "true"},
	{"FIntRenderLocalLightFadeInMs", "0"},
	{"FIntRenderLocalLightUpdatesMax", "1"},
	{"FIntRenderShadowmapBias", "0"},
	{"FIntSSAOMipLevels", "0"},
	{"FIntDebugForceMSAASamples", "1"},
	{"FIntDebugFRMOptionalMSAALevelOverride", "0"},
	{"FIntRobloxGuiBlurIntensity", "0"},
	{"FIntFRMMinGrassDistance", "0"},
	{"FIntFRMMaxGrassDistance", "0"},
	{"DFFlagCoreScriptTelemetry2", "false"},
	{"DFFlagBrowserTrackerIdTelemetryEnabled", "false"},
	{"FFlagPerfDataOnTelemetryV2", "false"},
	{"FFlagSendRenderFidelityTelemetry2", "false"},
	{"FFlagEnableTelemetryServiceMemoryCPUInfo", "false"},
	{"DFIntTelemetryProfilerHundredthsPercentage", "0"},
	{"FIntTelemetryProfilerFrequency", "0"},
	{"FIntPerformanceTelemetryQueueProcessLimit", "0"},
	{"DFIntContentProviderPreloadHangTelemetryHundredthsPercentage", "0"},
	}

	local function applyLowFlags()
	local env = (getgenv and getgenv()) or _G
	local setter = rawget(env, "setfflag") or rawget(_G, "set_fflag")
	local getter = rawget(env, "getfflag") or rawget(_G, "get_fflag")
	if type(setter) ~= "function" then return end
	task.spawn(function()
	for i, flag in ipairs(lowFlags) do
	local canSet = true
	if type(getter) == "function" then
	local ok, current = pcall(getter, flag[1])
	canSet = ok and current ~= nil
	end
	if canSet then pcall(setter, flag[1], tostring(flag[2])) end
	if i % 20 == 0 then task.wait() end
	end
	end)
	end

	local function applyLowPermanentSettings()
	pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
	pcall(function()
	UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
	end)
	pcall(function()
	Lighting.GlobalShadows = false
	Lighting.EnvironmentDiffuseScale = 0
	Lighting.EnvironmentSpecularScale = 0
	end)
	pcall(function()
	local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
	if atmosphere then
	atmosphere.Density = 0
	atmosphere.Glare = 0
	atmosphere.Haze = 0
	end
	end)
	pcall(function()
	local terrain = workspace:FindFirstChildOfClass("Terrain")
	if terrain then
	terrain.Decoration = false
	terrain.WaterWaveSize = 0
	terrain.WaterWaveSpeed = 0
	terrain.WaterReflectance = 0
	local clouds = terrain:FindFirstChildOfClass("Clouds")
	if clouds then clouds.Enabled = false end
	end
	end)
	end

	local applyOptimizerDerender = (function(obj)
	-- FPS FIX: no pcall wrapper and no undefined-global call per object.
	-- Callers that are not already protected wrap this in pcall. Class gate
	-- first, compare-before-write, and a weak done-set so character respawn
	-- re-walks do not re-save / re-write the same parts over and over.
	if not obj or optimizerProcessed[obj] then return end
	if optimizerMode ~= "Ultra" then
	if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke")
	or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("PostEffect") then
	optimizerProcessed[obj] = true
	if obj.Enabled then obj.Enabled = false end
	end
	if tick() <= lowHarshUntil then
	if obj:IsA("Decal") or obj:IsA("Texture") then
	optimizerProcessed[obj] = true
	if obj.Transparency ~= 1 then obj.Transparency = 1 end
	end
	end
	return
	end
	if type(_G.__CrystalPreserveOptimizerUI) == "function" and _G.__CrystalPreserveOptimizerUI(obj) then
	optimizerProcessed[obj] = true
	return
	end
	if obj:IsA("Accessory") or obj:IsA("Hat") or obj:IsA("Clothing")
	or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") then
	optimizerProcessed[obj] = true
	rememberUltraState(obj, {Parent = obj.Parent})
	obj.Parent = nil
	elseif obj:IsA("BasePart") then
	if obj.Material == Enum.Material.Plastic and obj.Reflectance == 0 and not obj.CastShadow then
	optimizerProcessed[obj] = true
	return
	end
	optimizerProcessed[obj] = true
	rememberUltraState(obj, {
	Material = obj.Material,
	Reflectance = obj.Reflectance,
	CastShadow = obj.CastShadow,
	})
	obj.Material = Enum.Material.Plastic
	obj.Reflectance = 0
	obj.CastShadow = false
	elseif obj:IsA("Decal") or obj:IsA("Texture") then
	optimizerProcessed[obj] = true
	if obj.Transparency ~= 1 then
	rememberUltraState(obj, {Transparency = obj.Transparency})
	obj.Transparency = 1
	end
	elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
	or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
	optimizerProcessed[obj] = true
	if obj.Enabled then
	rememberUltraState(obj, {Enabled = obj.Enabled})
	obj.Enabled = false
	end
	elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
	optimizerProcessed[obj] = true
	for _, track in ipairs(obj:GetPlayingAnimationTracks()) do
	pcall(function() track:Stop(0) end)
	end
	end
	end)

	local processAllDescendants = (function()
	local roots = optimizerMode == "Ultra" and {workspace} or {workspace, Lighting}
	if optimizerWalkCancel then optimizerWalkCancel() end
	optimizerWalkCancel = _G.__CrystalWalkDescendantsBatched(roots, applyOptimizerDerender, function()
	return optimizerActive
	end)
	end)

	local function applyOptimizerLighting()
	defLightBrightness = defLightBrightness or Lighting.Brightness
	defLightClock = defLightClock or Lighting.ClockTime
	defLightAmbient = defLightAmbient or Lighting.OutdoorAmbient
	if optimizerMode ~= "Ultra" then
	applyLowPermanentSettings()
	return
	end
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 1e10
	Lighting.Brightness = 1
	Lighting.EnvironmentDiffuseScale = 0
	Lighting.EnvironmentSpecularScale = 0
	for _, effect in ipairs(Lighting:GetChildren()) do
	pcall(function()
	if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect")
	or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect")
	or effect:IsA("DepthOfFieldEffect") then effect.Enabled = false end
	end)
	end
	end

	local function resetOptimizerLighting()
	pcall(function()
	if defLightBrightness then Lighting.Brightness = defLightBrightness end
	if defLightClock then Lighting.ClockTime = defLightClock end
	if defLightAmbient then Lighting.OutdoorAmbient = defLightAmbient end
	Lighting.ExposureCompensation = 0
	Lighting.GlobalShadows = true
	Lighting.FogEnd = 100000
	Lighting.EnvironmentDiffuseScale = 1
	Lighting.EnvironmentSpecularScale = 1
	end)
	end

	FeaturePostToggle["Optimizer"] = function(active)
	if active then
	if optimizerActive then return end
	if _G.__CrystalExclusiveGraphics then _G.__CrystalExclusiveGraphics("Optimizer") end

	removeAccessoriesEnabled = true
	optimizerActive = true
	optimizerProcessed = setmetatable({}, { __mode = "k" })
	if optimizerMode ~= "Ultra" then
	lowHarshUntil = tick() + 1
	lowFlagGeneration = lowFlagGeneration + 1
	local generation = lowFlagGeneration
	applyLowFlags()
	for _, delaySeconds in ipairs({2, 6, 12, 20}) do
	task.delay(delaySeconds, function()
	if optimizerActive and optimizerMode ~= "Ultra" and generation == lowFlagGeneration then
	applyLowFlags()
	end
	end)
	end
	pcall(function() game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen() end)
	end
	applyOptimizerLighting()
	if toggleStates["Sky Changer"] then
	applySky(skyCurrentMode)
	end
	processAllDescendants()

	if optimizerConn then optimizerConn:Disconnect() end
	optimizerConn = workspace.DescendantAdded:Connect(function(obj)
	if removeAccessoriesEnabled then pcall(applyOptimizerDerender, obj) end
	end)
	if optimizerLightingConn then optimizerLightingConn:Disconnect() end
	optimizerLightingConn = Lighting.DescendantAdded:Connect(function(obj)
	if removeAccessoriesEnabled then pcall(applyOptimizerDerender, obj) end
	end)

	if optimizerCharConn then optimizerCharConn:Disconnect() end
	optimizerCharConn = Player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	if optimizerActive then
	_G.__CrystalWalkDescendantsBatched(char, applyOptimizerDerender, function() return optimizerActive end)
	end
	end)

	print("[Optimizer] Anti Lag ACTIVATED - Mode " .. optimizerMode)
	else
	if not optimizerActive then return end

	removeAccessoriesEnabled = false
	optimizerActive = false
	if _G.__CrystalReleaseGraphics then _G.__CrystalReleaseGraphics("Optimizer") end
	if optimizerWalkCancel then optimizerWalkCancel(); optimizerWalkCancel = nil end
	lowFlagGeneration = lowFlagGeneration + 1
	restoreUltraState()
	optimizerProcessed = setmetatable({}, { __mode = "k" })

	if optimizerConn then
	optimizerConn:Disconnect()
	optimizerConn = nil
	end
	if optimizerLightingConn then
	optimizerLightingConn:Disconnect()
	optimizerLightingConn = nil
	end

	if optimizerCharConn then
	optimizerCharConn:Disconnect()
	optimizerCharConn = nil
	end

	if toggleStates["Sky Changer"] then
	applySky(skyCurrentMode)
	else
	resetOptimizerLighting()
	end
	print("[Optimizer] Anti Lag DEACTIVATED")
	end
	end
end
_G.__CrystalTrackStopper(function()
if optimizerActive and FeaturePostToggle["Optimizer"] then FeaturePostToggle["Optimizer"](false) end
end)

	makeToggleWithInput(visualSection, "FOV", "Custom FOV", "FOV",
	function(v) return tostring(v) end,
	function(n) return math.clamp(math.floor(n+0.5), 30, 120) end
	)

	do
	local fovActive = false
	local fovConn = nil
	local defaultFOV = 90
	local originalFOV = nil

	local function enableFOV()
	if fovActive then return end
	fovActive = true
	toggleStates["Custom FOV"] = true
	if fovConn then fovConn:Disconnect() end
	local cam = workspace.CurrentCamera
	if cam and originalFOV == nil then originalFOV = cam.FieldOfView end

	fovConn = RunService.RenderStepped:Connect((function()
	if not fovActive then return end
	local activeCamera = workspace.CurrentCamera
	local desiredFOV = speedValues.FOV or 90
	if activeCamera and math.abs(activeCamera.FieldOfView - desiredFOV) > 0.01 then
	activeCamera.FieldOfView = desiredFOV
	end
	end))
	if cam then cam.FieldOfView = speedValues.FOV or 90 end
	task.defer(saveConfig)
	end

	local function disableFOV()
	if not fovActive then return end
	fovActive = false
	toggleStates["Custom FOV"] = false
	if fovConn then
	fovConn:Disconnect()
	fovConn = nil
	end
	local cam = workspace.CurrentCamera
	if cam then cam.FieldOfView = originalFOV or defaultFOV end
	originalFOV = nil
	task.defer(saveConfig)
	end

	FeaturePostToggle["Custom FOV"] = function(active)
	if active then enableFOV() else disableFOV() end
	end
	_G.__CrystalTrackStopper(disableFOV)

	if toggleStates["Custom FOV"] then task.defer(enableFOV) end
	end

	makeToggleNoKeybind(visualSection, "Stretchz Res", "Stretchz Res")
	do
	local stretchRezEnabled = false
	local stretchRezConn = nil
	local STRETCH_FOV = 90
	local DEFAULT_FOV = 90

	local function applyStretchFOV(val)
	local cam = workspace.CurrentCamera
	if cam then
	pcall(function() cam.FieldOfView = val end)
	end
	end

	local function enableStretchRez()
	if stretchRezEnabled then return end
	stretchRezEnabled = true
	toggleStates["Stretchz Res"] = true

	local cam = workspace.CurrentCamera
	if not cam then return end

	if stretchRezConn then stretchRezConn:Disconnect() end
	stretchRezConn = RunService.RenderStepped:Connect((function()
	if not stretchRezEnabled then return end
	applyStretchFOV(STRETCH_FOV)
	pcall(function()
	local vp = cam.ViewportSize
	local curAspect = vp.X / math.max(vp.Y, 1)
	local scaleY = math.clamp((1420 / 1080) / curAspect, 0.3, 1.5)
	cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, scaleY, 0, 0, 0, 1)
	end)
	end))

	applyStretchFOV(STRETCH_FOV)
	task.defer(saveConfig)
	end

	local function disableStretchRez()
	stretchRezEnabled = false
	toggleStates["Stretchz Res"] = false
	if stretchRezConn then
	stretchRezConn:Disconnect()
	stretchRezConn = nil
	end
	local cam = workspace.CurrentCamera
	if cam then
	pcall(function() cam.FieldOfView = DEFAULT_FOV end)
	end
	task.defer(saveConfig)
	end

	FeaturePostToggle["Stretchz Res"] = function(active)
	if active then enableStretchRez() else disableStretchRez() end
	end
	_G.__CrystalTrackStopper(disableStretchRez)

	if toggleStates["Stretchz Res"] then task.defer(enableStretchRez) end
	end


	-- Violette custom skins: preset data and asset application.
	do
	local originals=setmetatable({}, {__mode="k"})
	local hiddenSkinParts=setmetatable({}, {__mode="k"})
	local generation=0
	local enabled=false
	local function restoreSkinParts(c)
		local saved=c and hiddenSkinParts[c]
		if not saved then return end
		for part,props in pairs(saved) do
			if part and part.Parent then pcall(function() part.Transparency=props.Transparency; part.LocalTransparencyModifier=props.LocalTransparencyModifier end) end
		end
		hiddenSkinParts[c]=nil
	end
	local function applySkinLegHides(c,skin)
		if not c then return end
		local names={}
		if skin.hideLeftLeg then for _,n in ipairs({"LeftUpperLeg","LeftLowerLeg","LeftFoot","Left Leg","LeftToe"}) do names[#names+1]=n end end
		if skin.hideRightLeg then for _,n in ipairs({"RightUpperLeg","RightLowerLeg","RightFoot","Right Leg","RightToe"}) do names[#names+1]=n end end
		if #names==0 then return end
		local saved={}; hiddenSkinParts[c]=saved
		for _,name in ipairs(names) do local part=c:FindFirstChild(name); if part and part:IsA("BasePart") and not saved[part] then saved[part]={Transparency=part.Transparency,LocalTransparencyModifier=part.LocalTransparencyModifier}; part.Transparency=1; part.LocalTransparencyModifier=1 end end
	end
	local function mark(o) pcall(function() o:SetAttribute("_CrystalVioletteSkin",true) end); return o end
	local function clearObjects(c)
		if not c then return end
		for _,o in ipairs(c:GetDescendants()) do if o:GetAttribute("_CrystalVioletteSkin") then pcall(function() o:Destroy() end) end end
	end
	local function clearAccessories(c)
		if not c then return end
		for _,o in ipairs(c:GetChildren()) do if o:IsA("Accessory") or o:IsA("Accoutrement") then pcall(function() o:Destroy() end) end end
	end
	local function attach(c,h,a)
		if not a or not a:IsA("Accessory") then return false end
		mark(a); pcall(function() h:AddAccessory(a) end); if a.Parent~=c then a.Parent=c end
		local handle=a:FindFirstChild("Handle"); if not handle or not handle:IsA("BasePart") then return a.Parent==c end
		local ha=handle:FindFirstChildWhichIsA("Attachment"); if not ha then return a.Parent==c end
		local ba
		for _,o in ipairs(c:GetDescendants()) do if o:IsA("Attachment") and o.Name==ha.Name and not o:IsDescendantOf(a) then ba=o; break end end
		local bp=ba and ba.Parent
		if bp and bp:IsA("BasePart") then
			handle.Anchored=false; handle.CanCollide=false; handle.CanTouch=false; handle.CanQuery=false; handle.Massless=true
			handle.CFrame=bp.CFrame*ba.CFrame*ha.CFrame:Inverse()
			local w=Instance.new("WeldConstraint"); w.Name="CrystalVioletteAccessoryWeld"; w.Part0=bp; w.Part1=handle; w.Parent=handle
		end
		return true
	end
	local function addAsset(c,h,id)
		local ok,objs=pcall(function() return game:GetObjects("rbxassetid://"..tostring(id)) end)
		if not ok or type(objs)~="table" or #objs==0 then local x; local q=pcall(function() x=game:GetService("InsertService"):LoadAsset(id) end); if q and x then objs={x} else return false end end
		local added=false
		for _,root in ipairs(objs) do
			local list={}
			if root:IsA("Accessory") or root:IsA("Shirt") or root:IsA("Pants") or root:IsA("ShirtGraphic") or root:IsA("CharacterMesh") then list={root} else for _,o in ipairs(root:GetDescendants()) do if o:IsA("Accessory") or o:IsA("Shirt") or o:IsA("Pants") or o:IsA("ShirtGraphic") or o:IsA("CharacterMesh") then table.insert(list,o) end end end
			for _,src in ipairs(list) do
				local x=mark(src:Clone())
				if x:IsA("Accessory") then attach(c,h,x) else for _,old in ipairs(c:GetChildren()) do if old.ClassName==x.ClassName then old:Destroy() end end; x.Parent=c end
				added=true
			end
			pcall(function() root:Destroy() end)
		end
		return added
	end
	local function headless(c,on)
		local head=c and c:FindFirstChild("Head"); if not head then return end
		local t=on and 1 or 0; head.Transparency=t; head.LocalTransparencyModifier=t
		for _,o in ipairs(head:GetChildren()) do if o:IsA("Decal") or o:IsA("Texture") then o.Transparency=t end end
	end
	local function apply(c)
		local h=c and c:FindFirstChildOfClass("Humanoid"); if not h then return false end
		generation=generation+1; local token=generation; clearObjects(c); restoreSkinParts(c)
		local old; pcall(function() old=h:GetAppliedDescription() end); if old and not originals[c] then originals[c]=old:Clone() end
		clearAccessories(c)
		if old then
			local d=old:Clone()
			for _,p in ipairs({"HatAccessory","HairAccessory","FaceAccessory","NeckAccessory","ShouldersAccessory","FrontAccessory","BackAccessory","WaistAccessory","ShirtAccessory","PantsAccessory","JacketAccessory","SweaterAccessory","ShortsAccessory","TShirtAccessory","DressSkirtAccessory"}) do pcall(function() d[p]="" end) end
			pcall(function() d.Shirt=0; d.Pants=0; d.GraphicTShirt=0 end)
			local skin=getVioletteSkinSet(violetteSkinMode) or VIOLETTE_SKIN_SETS["1"]
			pcall(function()
				d.HatAccessory=skin.hats or ""; d.HairAccessory=skin.hair or ""
				if skin.head then d.Head=skin.head end
				if skin.face then d.Face=skin.face end
				for property,value in pairs(skin.scales or {}) do d[property]=value end
				h:ApplyDescription(d)
			end); d:Destroy()
		end
		task.wait(); if not enabled or token~=generation or not c.Parent then return false end
		local skin=getVioletteSkinSet(violetteSkinMode) or VIOLETTE_SKIN_SETS["1"]
		for _,id in ipairs(skin.accessories or {}) do addAsset(c,h,id) end
		for _,id in ipairs(skin.clothing or {}) do addAsset(c,h,id) end
		headless(c,skin.headless==true); applySkinLegHides(c,skin); return true
	end
	local function clear(c)
		generation=generation+1; c=c or Player.Character; if not c then return end; clearObjects(c); restoreSkinParts(c)
		local h=c:FindFirstChildOfClass("Humanoid"); local old=originals[c]
		if h and old then pcall(function() h:ApplyDescription(old:Clone()) end) else headless(c,false) end
	end
	FeaturePostToggle["Violette Custom Skins"]=function(on) enabled=on==true; if enabled then task.spawn(apply,Player.Character) else clear(Player.Character) end end
	_G._KawatanSkinColor = violetteSkinMode
	_G.__CrystalVioletteSkinSet=function(mode)
		mode=tostring(mode); if not getVioletteSkinSet(mode) then return violetteSkinMode end
		violetteSkinMode=mode; _G._KawatanSkinColor=mode; if enabled then task.spawn(apply,Player.Character) end; saveConfig(); return mode
	end
	local lastSkinHalloweenMode = toggleStates["Halloween Mode"] == true
	_G.__CrystalRefreshVioletteSkinTheme = function()
		local halloweenActive = toggleStates["Halloween Mode"] == true
		if halloweenActive == lastSkinHalloweenMode then return false end
		lastSkinHalloweenMode = halloweenActive
		refreshVioletteSkinCatalog()
		if enabled and Player.Character then task.spawn(apply, Player.Character) end
		if _G.__CrystalRefreshSkinGalleryTheme then pcall(_G.__CrystalRefreshSkinGalleryTheme) end
		return true
	end
	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(c) if enabled then task.wait(.75); if enabled then task.spawn(apply,c) end end end))
	_G.__CrystalTrackStopper(function() enabled=false; clear(Player.Character) end)
	if toggleStates["Violette Custom Skins"] then
		enabled=true
		task.defer(apply, Player.Character)
	end
	end

	-- Sound Skin: face + head accessory put on every player's character (applied on this client).
	do
		local Sound_FACE_ID = 130358633870322
		local Sound_HAT_ID = 94521095218096
		local Sound_PANTS_ID = 6961229907
		local Sound_SHIRT_ID = 9039263987
		local enabled = false
		local assetCache = {}
		local function loadAsset(id)
			if assetCache[id] then return assetCache[id] end
			local root
			local ok, objs = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)
			if ok and type(objs) == "table" and objs[1] then
				root = objs[1]
			else
				pcall(function() root = game:GetService("InsertService"):LoadAsset(id) end)
			end
			if root then assetCache[id] = root end
			return root
		end
		local function findFirst(root, className)
			if not root then return nil end
			if root:IsA(className) then return root end
			return root:FindFirstChildWhichIsA(className, true)
		end
		local function mark(o) pcall(function() o:SetAttribute("_SoundSkin", true) end); return o end
		local function restoreChar(c)
			if not c then return end
			for _, o in ipairs(c:GetDescendants()) do
				if o:GetAttribute("_SoundSkin") then pcall(function() o:Destroy() end) end
			end
			-- Restore the original shirt and pants when Sound Skin is disabled/refreshed.
			for _, itemName in ipairs({"Shirt", "Pants"}) do
				local item = c:FindFirstChildOfClass(itemName)
				local saved = c:GetAttribute("_SoundOrig" .. itemName .. "Template")
				local hadItem = c:GetAttribute("_SoundOrigHad" .. itemName)
				if hadItem ~= nil then
					if hadItem then
						if not item then item = Instance.new(itemName); item.Parent = c end
						if saved then item.Template = saved end
					elseif item then item:Destroy() end
					c:SetAttribute("_SoundOrig" .. itemName .. "Template", nil)
					c:SetAttribute("_SoundOrigHad" .. itemName, nil)
				end
			end
			local head = c:FindFirstChild("Head")
			if head then
				local orig = head:GetAttribute("_SoundFaceOrig")
				if orig ~= nil then
					local face = head:FindFirstChild("face") or head:FindFirstChildWhichIsA("Decal")
					if face then pcall(function() face.Texture = orig end) end
					head:SetAttribute("_SoundFaceOrig", nil)
				end
			end
		end
		local function applyFace(c)
			local head = c:FindFirstChild("Head")
			local newDecal = findFirst(loadAsset(Sound_FACE_ID), "Decal")
			if not head or not newDecal then return end
			local face = head:FindFirstChild("face") or head:FindFirstChildWhichIsA("Decal")
			if face then
				if head:GetAttribute("_SoundFaceOrig") == nil then head:SetAttribute("_SoundFaceOrig", face.Texture) end
				face.Texture = newDecal.Texture
			else
				local d = mark(newDecal:Clone())
				d.Name = "face"
				d.Face = Enum.NormalId.Front
				d.Parent = head
			end
		end
		local function applyClothes(c)
			for _, spec in ipairs({
				{className = "Pants", assetId = Sound_PANTS_ID},
				{className = "Shirt", assetId = Sound_SHIRT_ID},
			}) do
				local clothing = c:FindFirstChildOfClass(spec.className)
				local hadItem = clothing ~= nil
				c:SetAttribute("_SoundOrigHad" .. spec.className, hadItem)
				if clothing then
					c:SetAttribute("_SoundOrig" .. spec.className .. "Template", clothing.Template)
				else
					clothing = Instance.new(spec.className)
					clothing.Name = spec.className
					clothing.Parent = c
					mark(clothing)
				end
				clothing.Template = "rbxassetid://" .. tostring(spec.assetId)
			end
		end
		local function applyHat(c, hum)
			local src = findFirst(loadAsset(Sound_HAT_ID), "Accessory")
			if not src then return end
			local a = mark(src:Clone())
			pcall(function() hum:AddAccessory(a) end)
			if a.Parent ~= c then a.Parent = c end
			local handle = a:FindFirstChild("Handle")
			if not handle or not handle:IsA("BasePart") then return end

			if handle:FindFirstChildWhichIsA("Weld") then return end
			local ha = handle:FindFirstChildWhichIsA("Attachment")
			if not ha then return end
			for _, o in ipairs(c:GetDescendants()) do
				if o:IsA("Attachment") and o.Name == ha.Name and not o:IsDescendantOf(a) and o.Parent:IsA("BasePart") then
					handle.Anchored = false; handle.CanCollide = false; handle.Massless = true
					handle.CFrame = o.Parent.CFrame * o.CFrame * ha.CFrame:Inverse()
					local w = Instance.new("WeldConstraint")
					w.Part0 = o.Parent; w.Part1 = handle; w.Parent = handle
					break
				end
			end
		end
		local function applyChar(c)
			if not c then return end
			local hum = c:WaitForChild("Humanoid", 5)
			local head = c:WaitForChild("Head", 5)
			if not hum or not head or not enabled or not c.Parent then return end
			restoreChar(c)
			pcall(applyClothes, c)
			pcall(applyFace, c)
			pcall(applyHat, c, hum)
		end
		local function applyAll()
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr.Character then task.spawn(applyChar, plr.Character) end
			end
		end
		local function restoreAll()
			for _, plr in ipairs(Players:GetPlayers()) do restoreChar(plr.Character) end
		end
		local function watchPlayer(plr)
			_G.__CrystalTrackConn(plr.CharacterAdded:Connect(function(c)
				if not enabled then return end
				task.wait(1)
				if enabled then task.spawn(applyChar, c) end
			end))
		end
		for _, plr in ipairs(Players:GetPlayers()) do watchPlayer(plr) end
		_G.__CrystalTrackConn(Players.PlayerAdded:Connect(watchPlayer))
		FeaturePostToggle["Sound Skin"] = function(on)
			enabled = on == true
			if enabled then task.spawn(applyAll) else restoreAll() end
		end
		_G.__CrystalTrackStopper(function() enabled = false; restoreAll() end)
		if toggleStates["Sound Skin"] then
			enabled = true
			task.defer(applyAll)
		end
	end

	-- Custom bat skins: integrated into the Visual tab and applied to Bat tools.
	do
		local BAT_SKIN_ASSET_ID = "rbxassetid://18566246244"
		local BAT_SKIN_COLORS = {
			["Abyss Blue"] = Color3.fromRGB(0, 40, 150),
			["Venom Green"] = Color3.fromRGB(20, 255, 50),
			["Royal Gold"] = Color3.fromRGB(255, 200, 0),
			["Velvet Rose"] = Color3.fromRGB(220, 20, 100),
			["Crimson Night"] = Color3.fromRGB(90, 0, 20),
		}
		local batSkinModes = { "Default", "Abyss Blue", "Venom Green", "Royal Gold", "Velvet Rose", "Crimson Night", "RGB" }
		batSkinMode = batSkinMode or "Default"
		local cachedBatVisual = nil
		local batVisualLoading = false
		local originalBatHandles = setmetatable({}, { __mode = "k" })
		local batSkinGeneration = 0

		local function getBatVisual()
			if cachedBatVisual then return cachedBatVisual end
			if batVisualLoading then return nil end
			batVisualLoading = true
			local ok, objects = pcall(function() return game:GetObjects(BAT_SKIN_ASSET_ID) end)
			if ok and type(objects) == "table" and #objects > 0 then
				local root = objects[1]
				cachedBatVisual = root:IsA("BasePart") and root or root:FindFirstChildWhichIsA("BasePart", true)
				-- Keep the asset container alive when the cached part is a descendant.
			end
			batVisualLoading = false
			return cachedBatVisual
		end

		local function tintBatVisual(visual, color)
			if not visual then return end
			visual.Color = color
			if visual:IsA("UnionOperation") then pcall(function() visual.UsePartColor = true end) end
			local mesh = visual:FindFirstChildWhichIsA("SpecialMesh")
			if mesh then mesh.VertexColor = Vector3.new(color.R, color.G, color.B) end
		end

		local function restoreBat(tool)
			if not tool then return end
			local handle = tool:FindFirstChild("Handle")
			local saved = handle and originalBatHandles[handle]
			local visual = tool:FindFirstChild("CustomUnionVisual")
			if visual then pcall(function() visual:Destroy() end) end
			if not handle or not saved then return end
			handle.Transparency = saved.transparency
			for object, transparency in pairs(saved.children) do
				if object and object.Parent then pcall(function() object.Transparency = transparency end) end
			end
		originalBatHandles[handle] = nil
		end

		local function applyBatSkin(tool, token)
			if not tool or tool.Name ~= "Bat" then return end
			local handle = tool:FindFirstChild("Handle") or tool:WaitForChild("Handle", 2)
			if not handle or not handle:IsA("BasePart") then return end
			if batSkinMode == "Default" then restoreBat(tool); return end
			if token and token ~= batSkinGeneration then return end
			if not originalBatHandles[handle] then
				local children = {}
				for _, child in ipairs(handle:GetChildren()) do
					if child:IsA("SpecialMesh") or child:IsA("Mesh") or child:IsA("Decal") then children[child] = child.Transparency end
				end
				originalBatHandles[handle] = { transparency = handle.Transparency, children = children }
			end
			local source = getBatVisual()
			if not source then
				task.delay(0.25, function() if tool.Parent and batSkinMode ~= "Default" then applyBatSkin(tool, token) end end)
				return
			end
			local old = tool:FindFirstChild("CustomUnionVisual")
			if old then old:Destroy() end
			handle.Transparency = 1
			for child in pairs(originalBatHandles[handle].children) do pcall(function() child.Transparency = 1 end) end
			local visual = source:Clone()
			visual.Name = "CustomUnionVisual"
			visual.CanCollide = false; visual.CanTouch = false; visual.CanQuery = false; visual.Massless = true; visual.Anchored = false
			local tempModel = Instance.new("Model")
			visual.Parent = tempModel; tempModel.PrimaryPart = visual; tempModel:ScaleTo(2); visual.Parent = nil; tempModel:Destroy()
			if batSkinMode == "RGB" then tintBatVisual(visual, Color3.fromHSV((tick() % 3) / 3, 1, 1)) elseif BAT_SKIN_COLORS[batSkinMode] then tintBatVisual(visual, BAT_SKIN_COLORS[batSkinMode]) end
			for _, child in ipairs(visual:GetChildren()) do if child:IsA("Weld") or child:IsA("WeldConstraint") then child:Destroy() end end
			visual.CFrame = handle.CFrame * CFrame.new(-0.02, -0.52, -0.2) * CFrame.Angles(math.rad(45), 0, math.rad(5))
			visual.Parent = tool
			local weld = Instance.new("WeldConstraint"); weld.Part0 = handle; weld.Part1 = visual; weld.Parent = visual
		end

		local function scanBatContainer(container)
			for _, child in ipairs(container:GetChildren()) do if child:IsA("Tool") and child.Name == "Bat" then task.spawn(applyBatSkin, child, batSkinGeneration) end end
		end
		local function hookBatContainer(container)
			if not container then return end
			scanBatContainer(container)
			_G.__CrystalTrackConn(container.ChildAdded:Connect(function(child) if child:IsA("Tool") and child.Name == "Bat" then task.defer(applyBatSkin, child, batSkinGeneration) end end))
		end
		local function clearAllBats()
			for _, container in ipairs({ Player.Character, Player:FindFirstChild("Backpack") }) do if container then for _, child in ipairs(container:GetChildren()) do if child:IsA("Tool") and child.Name == "Bat" then restoreBat(child) end end end end
		end
		local function setBatSkin(mode)
			mode = tostring(mode)
			for _, candidate in ipairs(batSkinModes) do if candidate == mode then batSkinMode = mode; break end end
			batSkinGeneration = batSkinGeneration + 1
			if batSkinMode == "Default" then clearAllBats() else
				for _, container in ipairs({ Player.Character, Player:FindFirstChild("Backpack") }) do if container then scanBatContainer(container) end end
			end
			saveConfig()
			return batSkinMode
		end
		_G.__CrystalBatSkinSet = setBatSkin
		_G.__CrystalBatSkinModes = batSkinModes
		_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(character)
			task.wait(0.5); hookBatContainer(character); hookBatContainer(Player:FindFirstChild("Backpack"))
		end))
		hookBatContainer(Player.Character)
		hookBatContainer(Player:FindFirstChild("Backpack"))
		_G.__CrystalTrackConn(RunService.RenderStepped:Connect(function()
			if batSkinMode ~= "RGB" then return end
			local character = Player.Character; local tool = character and character:FindFirstChild("Bat"); local visual = tool and tool:FindFirstChild("CustomUnionVisual")
			if visual then tintBatVisual(visual, Color3.fromHSV((tick() % 3) / 3, 1, 1)) end
		end))
		_G.__CrystalTrackStopper(function() batSkinGeneration = batSkinGeneration + 1; clearAllBats(); cachedBatVisual = nil end)
		if batSkinMode ~= "Default" then task.defer(function() setBatSkin(batSkinMode) end) end
	end

	_G._CrystalCustomSkinPicked = function(name)
		name = tostring(name)
		if _G.__CrystalVioletteSkinSet then pcall(_G.__CrystalVioletteSkinSet, name) end
		if not toggleStates["Violette Custom Skins"] then setFeature("Violette Custom Skins", true) end
	end


;(function()

    local LP  = Player
    local UIS = UserInputService

    if _G._CrystalCustomSkinsGalleryRuntime and _G._CrystalCustomSkinsGalleryRuntime.Destroy then
        pcall(_G._CrystalCustomSkinsGalleryRuntime.Destroy)
    end

    local _conns = {}
    local function hubConnect(signal, handler)
        local c = signal:Connect(handler)
        _conns[#_conns + 1] = c
        return c
    end
;(function()
    local function new(class, props, kids)
        local o = Instance.new(class)
        for k, v in pairs(props or {}) do o[k] = v end
        for _, c in ipairs(kids or {}) do c.Parent = o end
        return o
    end
    local function corner(r) return new("UICorner", {CornerRadius = UDim.new(0, r)}) end
    local function stroke(c, t, tr)
        return new("UIStroke", {Color = c, Thickness = t or 1, Transparency = tr or 0,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    end
    local Q = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local function tw(o, ti, p)
        if typeof(o) ~= "Instance" then return end
        TweenService:Create(o, ti, p):Play()
    end
    local CAT_ACCENT = Color3.fromRGB(254, 254, 254)
    local CAT_PANEL  = Color3.fromRGB(18, 18, 18)
    local CAT_PANEL2 = Color3.fromRGB(32, 32, 32)
    local CAT_CARD   = Color3.fromRGB(10, 10, 10)
    local CAT_EDGE   = Color3.fromRGB(28, 28, 34)
    local CAT_EDGE_H = Color3.fromRGB(48, 48, 56)
    local CAT_DARK   = Color3.fromRGB(0, 0, 0)
    local CAT_TEXT   = Color3.fromRGB(255, 255, 255)
    local CAT_DIM    = Color3.fromRGB(150, 150, 155)
    local function accent()
        local a = _G._VioletteAccent
        return (typeof(a) == "Color3") and a or CAT_ACCENT
    end

    for _, root in ipairs({game:GetService("CoreGui"), LP:FindFirstChild("PlayerGui")}) do
        if root then
            local old = root:FindFirstChild("CrystalCustomSkinsGallery")
            if old then pcall(function() old:Destroy() end) end
        end
    end

    local gui = new("ScreenGui", {
        Name = "CrystalCustomSkinsGallery", ResetOnSpawn = false, IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100001,
    })
    pcall(function() gui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
    if not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end
    gui.Archivable = false
    pcall(function() gui:SetAttribute("_VlonEProtected", true) end)

    local compact = UIS.TouchEnabled and not UIS.KeyboardEnabled
    local PANEL_W, PANEL_H = (compact and 424 or 616), (compact and 456 or 632)
    local CELL_W, CELL_H = (compact and 126 or 190), (compact and 184 or 272)
    local PAD_X, PAD_Y = (compact and 2 or 5), (compact and 3 or 6)
    local SPIN_SPEED = 0.8
    local CAM_DIST, CAM_HEIGHT = 9.6, 0.5
    local HOVER_ZOOM = 0.86
    local DOLLY_RESPONSE = 9

    local backdrop = new("TextButton", {
        Parent = gui, Name = "CatalogBackdrop", Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 1,
        Text = "", AutoButtonColor = false, BorderSizePixel = 0,
        Visible = false, ZIndex = 200,
    })

    local panel = new("Frame", {
        Parent = backdrop, Name = "CatalogPanel",
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(PANEL_W, PANEL_H),
        BackgroundColor3 = CAT_PANEL, BorderSizePixel = 0,
        Active = true, ZIndex = 201,
    }, {corner(14)})
    local panelEdge = stroke(accent(), 1.2, 0.55)
    panelEdge.Parent = panel
    local panelScale = new("UIScale", {Parent = panel, Scale = 1})
    new("UIGradient", {Parent = panel, Rotation = 35,
        Color = ColorSequence.new(CAT_PANEL, CAT_PANEL2)})

    local head = new("Frame", {
        Parent = panel, BackgroundTransparency = 1, Active = true,
        Position = UDim2.fromOffset(14, 8), Size = UDim2.new(1, -28, 0, 46), ZIndex = 202,
    })
    new("TextLabel", {
        Parent = head, Size = UDim2.new(1, -40, 0, 22), Position = UDim2.fromOffset(0, 2),
        BackgroundTransparency = 1, Text = "CUSTOM SKINS", Font = Enum.Font.GothamBlack,
        TextSize = compact and 16 or 18, TextColor3 = CAT_TEXT,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 203,
    })
    local subtitle = new("TextLabel", {
        Parent = head, Size = UDim2.new(1, -40, 0, 12), Position = UDim2.fromOffset(0, 24),
        BackgroundTransparency = 1, Text = "PICK A SKIN", Font = Enum.Font.GothamBold,
        TextSize = 9, TextColor3 = accent(), TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 203,
    })
    local closeBtn = new("TextButton", {
        Parent = head, Name = "CloseCatalog", BackgroundTransparency = 1,
        Text = "\u{00D7}", TextSize = 20, TextColor3 = CAT_TEXT,
        Font = Enum.Font.GothamMedium, AutoButtonColor = false,
        Position = UDim2.new(1, -30, 0, 2), Size = UDim2.fromOffset(30, 30), ZIndex = 204,
    })

    local scrolling = new("ScrollingFrame", {
        Parent = panel, Name = "SetCards", BackgroundTransparency = 1, BorderSizePixel = 0,
        Position = UDim2.fromOffset(14, 58), Size = UDim2.new(1, -28, 1, -72),
        CanvasSize = UDim2.new(), ScrollBarThickness = 0, ZIndex = 202,
    })
    new("UIPadding", {Parent = scrolling,
        PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4)})
    local grid = new("UIGridLayout", {
        Parent = scrolling, CellSize = UDim2.fromOffset(CELL_W, CELL_H),
        CellPadding = UDim2.fromOffset(PAD_X, PAD_Y),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrolling.CanvasSize = UDim2.fromOffset(0, grid.AbsoluteContentSize.Y + 12)
    end)

    local cards, shots = {}, {}
    local built, catalogOpen = false, false
    local panelDragging, panelDragEndedAt = false, 0
    local refreshCards
    local displayedSkinHalloweenMode = toggleStates["Halloween Mode"] == true

    local function dressPreview(rig, skin)
        rig.PrimaryPart = rig:FindFirstChild("HumanoidRootPart") or rig.PrimaryPart
        for _, object in ipairs(rig:GetDescendants()) do
            if object:IsA("BasePart") then
                object.CanCollide = false
                object.CastShadow = false
            elseif object:IsA("Script") or object:IsA("LocalScript") then
                object:Destroy()
            end
        end
        if skin.headless ~= false then
            local rigHead = rig:FindFirstChild("Head")
            if rigHead then
                rigHead.Transparency = 1
                for _, object in ipairs(rigHead:GetChildren()) do
                    if object:IsA("Decal") or object:IsA("Texture") then object.Transparency = 1 end
                end
            end
        end
        local mode = skin.korblox or "Off"
        for _, entry in ipairs({{"Left", "Left Leg"}, {"Right", "Right Leg"}}) do
            if mode == "Both" or mode == entry[1] then
                local config = _G._RaVeKorbloxAssets and _G._RaVeKorbloxAssets[entry[2]]
                local target = config and rig:FindFirstChild(config.targetBodyPart)
                if target then
                    for _, partName in ipairs(config.partsToHide) do
                        local limb = rig:FindFirstChild(partName)
                        if limb and limb:IsA("BasePart") then limb.Transparency = 1 end
                    end
                    local ok, objects = pcall(function() return game:GetObjects(config.id) end)
                    local source = ok and objects and objects[1]
                    local mesh = source and (source:IsA("BasePart") and source
                        or source:FindFirstChildWhichIsA("BasePart", true))
                    if mesh then
                        mesh.CanCollide = false
                        mesh.CastShadow = false
                        mesh.CFrame = target.CFrame * (config.offset or CFrame.new())
                        local weld = Instance.new("WeldConstraint")
                        weld.Part0, weld.Part1, weld.Parent = target, mesh, mesh
                        mesh.Parent = rig
                    end
                    if source and source ~= mesh and source.Parent ~= rig then
                        pcall(function() source:Destroy() end)
                    end
                end
            end
        end
    end

    local function seatStrays(rig)
        local root = rig:FindFirstChild("HumanoidRootPart")
        if not root then return end
        for _, accessory in ipairs(rig:GetChildren()) do
            if accessory:IsA("Accessory") then
                pcall(function()
                    local handle = accessory:FindFirstChild("Handle")
                    if not (handle and handle:IsA("BasePart")) then return end
                    if (handle.Position - root.Position).Magnitude <= 8 then return end

                    local handleAttachment = handle:FindFirstChildWhichIsA("Attachment")
                    local bodyAttachment
                    if handleAttachment then
                        for _, object in ipairs(rig:GetDescendants()) do
                            if object:IsA("Attachment") and object.Name == handleAttachment.Name
                                and not object:IsDescendantOf(accessory) then
                                bodyAttachment = object
                                break
                            end
                        end
                    end
                    local bodyPart = bodyAttachment and bodyAttachment.Parent
                    if bodyPart and bodyPart:IsA("BasePart") then
                        handle.CFrame = bodyPart.CFrame * bodyAttachment.CFrame
                            * handleAttachment.CFrame:Inverse()
                    else
                        local rigHead = rig:FindFirstChild("Head")
                        if rigHead then handle.CFrame = rigHead.CFrame end
                    end
                end)
            end
        end
    end

    local function loadCard(setName, card)
        card.loadGeneration = (card.loadGeneration or 0) + 1
        local loadGeneration = card.loadGeneration
        if card.shot.rig then pcall(function() card.shot.rig:Destroy() end); card.shot.rig = nil end
        card.loading.Visible = true
        card.loading.Text = "LOADING"
        task.spawn(function()
            local description = _G._KawatanBuildSetDescription
                and _G._KawatanBuildSetDescription(setName)
            if not description then
                if card.loadGeneration == loadGeneration then card.loading.Text = "N/A" end
                return
            end
            local rig
            local ok = pcall(function()
                rig = Players:CreateHumanoidModelFromDescriptionAsync(description, Enum.HumanoidRigType.R15)
            end)
            if not ok or not rig then
                pcall(function()
                    rig = Players:CreateHumanoidModelFromDescription(description, Enum.HumanoidRigType.R15)
                end)
            end
            pcall(function() description:Destroy() end)
            if card.loadGeneration ~= loadGeneration then
                if rig then pcall(function() rig:Destroy() end) end
                return
            end
            if not rig or not (rig:FindFirstChild("UpperTorso") or rig:FindFirstChild("Torso")) then
                if rig then pcall(function() rig:Destroy() end) end
                card.loading.Text = "N/A"
                return
            end

            pcall(dressPreview, rig, _G._KawatanSkinSets[setName])
            rig.Parent = card.world

            task.wait()
            pcall(seatStrays, rig)
            for _, object in ipairs(rig:GetDescendants()) do
                if object:IsA("BasePart") then object.Anchored = true end
            end
            pcall(function() rig:PivotTo(CFrame.new()) end)
            card.shot.rig = rig
            card.loading.Visible = false
        end)
    end

    local function selectSet(name)
        _G._KawatanSkinColor = name
        if _G._CrystalCustomSkinPicked then
            pcall(_G._CrystalCustomSkinPicked, name)
        end
        if refreshCards then refreshCards() end
    end

    for index, setName in ipairs(_G._KawatanSkinSetOrder or {}) do
        local card = new("TextButton", {
            Parent = scrolling, Name = setName .. "Preview", LayoutOrder = index,
            BackgroundColor3 = CAT_CARD, BackgroundTransparency = 0,
            BorderSizePixel = 0, Text = "", AutoButtonColor = false, ZIndex = 203,
            Visible = (_G._KawatanSkinSets or {})[setName] ~= nil,
        }, {corner(10)})
        local cardStroke = stroke(CAT_EDGE, 1, 0)
        cardStroke.Parent = card

        local viewport = new("ViewportFrame", {
            Parent = card, Name = "AvatarPreview",
            BackgroundColor3 = CAT_DARK, BackgroundTransparency = 0,
            BorderSizePixel = 0, Position = UDim2.fromOffset(7, 7),
            Size = UDim2.new(1, -14, 1, -34),
            Ambient = Color3.fromRGB(255, 255, 255), LightColor = Color3.fromRGB(255, 255, 255),
            LightDirection = Vector3.new(-0.25, -0.5, -0.83), ZIndex = 204,
        }, {corner(8)})

        local world = new("WorldModel", {Parent = viewport})
        local camera = new("Camera", {Parent = viewport, FieldOfView = 42,
            CFrame = CFrame.lookAt(Vector3.new(0, CAM_HEIGHT, CAM_DIST),
                Vector3.new(0, CAM_HEIGHT, 0))})
        viewport.CurrentCamera = camera

        local loading = new("TextLabel", {
            Parent = viewport, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
            Text = "LOADING", Font = Enum.Font.GothamBold, TextSize = 9,
            TextColor3 = CAT_DIM, ZIndex = 205,
        })

        local label = new("TextLabel", {
            Parent = card, Position = UDim2.new(0, 8, 1, -24),
            Size = UDim2.new(1, -16, 0, 19), BackgroundTransparency = 1, Text = ((_G._KawatanSkinSets or {})[setName] or {}).displayName or tostring(setName):gsub("_", " "),
            Font = Enum.Font.GothamBlack, TextSize = 10,
            TextColor3 = CAT_DIM,
            TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 204,
        })

        local shot = {camera = camera, rig = nil, phase = index * 0.47,
            distance = CAM_DIST, current = CAM_DIST, target = CAM_DIST}
        shots[#shots + 1] = shot

        card.Activated:Connect(function() selectSet(setName) end)
        card.MouseEnter:Connect(function()
            shot.target = shot.distance * HOVER_ZOOM
            if _G._KawatanSkinColor ~= setName then
                tw(cardStroke, Q, {Color = CAT_EDGE_H, Transparency = 0})
                tw(label, Q, {TextColor3 = CAT_TEXT})
            end
        end)
        card.MouseLeave:Connect(function()
            shot.target = shot.distance
            if refreshCards then refreshCards() end
        end)

        cards[setName] = {card = card, stroke = cardStroke, viewport = viewport,
            world = world, camera = camera, label = label, loading = loading,
            shot = shot}
    end

    refreshCards = function()
        local live = accent()
        panelEdge.Color = live
        subtitle.TextColor3 = live
        for setName, entry in pairs(cards) do
            local on = setName == _G._KawatanSkinColor
            tw(entry.stroke, Q, {
                Color = on and live or CAT_EDGE,
                Thickness = on and 2 or 1, Transparency = 0,
            })
            tw(entry.label, Q, {TextColor3 = on and CAT_TEXT or CAT_DIM})
        end
    end
    refreshCards()
    _G._KawatanRefreshGalleryCards = refreshCards
    _G.__CrystalRefreshSkinGalleryTheme = function()
        local halloweenActive = toggleStates["Halloween Mode"] == true
        refreshCards()
        local themeChanged = halloweenActive ~= displayedSkinHalloweenMode
        for setName, entry in pairs(cards) do
            local skin = (_G._KawatanSkinSets or {})[setName]
            entry.card.Parent = skin and scrolling or nil
            entry.card.Visible = skin ~= nil
            if skin and entry.label then entry.label.Text = skin.displayName or tostring(setName) end
            if themeChanged and skin and built and catalogOpen then loadCard(setName, entry) end
        end
        if not themeChanged then return end
        if not built then displayedSkinHalloweenMode = halloweenActive; return end
        if catalogOpen then displayedSkinHalloweenMode = halloweenActive end
    end
    _G.__CrystalRefreshSkinGalleryTheme()

    local elapsed = 0
    hubConnect(RunService.RenderStepped, LPH_NO_VIRTUALIZE(function(dt)
        if not catalogOpen then return end
        elapsed = elapsed + dt
        local ease = math.min(dt * DOLLY_RESPONSE, 1)
        for _, shot in ipairs(shots) do
            if shot.rig and shot.rig.Parent then
                local breath = math.cos(elapsed * 3 + shot.phase) * 0.035
                pcall(function()
                    shot.rig:PivotTo(CFrame.new(0, breath, 0)
                        * CFrame.Angles(0, math.pi + elapsed * SPIN_SPEED + shot.phase, 0))
                end)
            end
            if shot.camera.Parent then
                shot.current = shot.current + (shot.target - shot.current) * ease
                shot.camera.CFrame = CFrame.lookAt(
                    Vector3.new(0, CAM_HEIGHT, shot.current), Vector3.new(0, CAM_HEIGHT, 0))
            end
        end
    end))

    local function closeCatalog()
        catalogOpen = false
        tw(backdrop, Q, {BackgroundTransparency = 1})
        tw(panelScale, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Scale = 0.9})
        task.delay(0.16, function()
            if not catalogOpen then backdrop.Visible = false end
        end)
    end

    _G._KawatanOpenSkinGallery = function()
        catalogOpen = true
        refreshCards()
        if _G.__CrystalRefreshSkinGalleryTheme then pcall(_G.__CrystalRefreshSkinGalleryTheme) end
        for _, shot in ipairs(shots) do shot.target = shot.distance end
        backdrop.Visible = true
        backdrop.BackgroundTransparency = 1
        panelScale.Scale = 0.9
        tw(backdrop, TweenInfo.new(0.2), {BackgroundTransparency = 0.42})
        tw(panelScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Scale = 1})
        if built then return end
        built = true
        task.spawn(function()
            for _, setName in ipairs(_G._KawatanSkinSetOrder or {}) do
                local entry = cards[setName]
                if entry then loadCard(setName, entry) end
                task.wait(0.12)
            end
        end)
    end
    _G._KawatanCloseSkinGallery = closeCatalog

    closeBtn.Activated:Connect(closeCatalog)
    backdrop.MouseButton1Click:Connect(function()
        if panelDragging or (os.clock() - panelDragEndedAt) < 0.25 then return end
        closeCatalog()
    end)

    do
        local startInput, startPosition, dragInput
        head.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then return end
            panelDragging, startInput, startPosition, dragInput =
                true, input.Position, panel.Position, input
        end)
        head.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        hubConnect(UIS.InputChanged, function(input)
            if not panelDragging then return end
            if input ~= dragInput and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            local delta = input.Position - startInput
            panel.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end)
        hubConnect(UIS.InputEnded, function(input)
            if not panelDragging then return end
            if input == dragInput
                or input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                panelDragging, dragInput = false, nil
                panelDragEndedAt = os.clock()
            end
        end)
    end
end)()

    _G._CrystalCustomSkinsGalleryRuntime = {
        Destroy = function()
            for _, c in ipairs(_conns) do pcall(function() c:Disconnect() end) end
            _conns = {}
            pcall(function() gui:Destroy() end)
            _G._CrystalCustomSkinsGalleryRuntime = nil
        end,
    }
end)()
	do
	local appearanceState = _G.__CrystalVisualAppearanceState
	if type(appearanceState) ~= "table" or appearanceState.version ~= 2 then
		appearanceState = {
			version = 2,
			headless = setmetatable({}, {__mode = "k"}),
			korblox = setmetatable({}, {__mode = "k"}),
		}
		_G.__CrystalVisualAppearanceState = appearanceState
	end
	appearanceState.setHeadless = function(active, character)
		character = character or Player.Character
		local head = character and character:FindFirstChild("Head")
		if not head or not head:IsA("BasePart") then return false end
		if active then
			if not appearanceState.headless[character] then
				local saved = {headTransparency = head.Transparency, headLocalTransparency = head.LocalTransparencyModifier, faces = {}}
				for _, item in ipairs(head:GetChildren()) do
					if item:IsA("Decal") or item:IsA("Texture") then
						table.insert(saved.faces, {item = item, transparency = item.Transparency})
					end
				end
				appearanceState.headless[character] = saved
			end
			head.Transparency = 1
			head.LocalTransparencyModifier = 1
			for _, item in ipairs(head:GetChildren()) do
				if item:IsA("Decal") or item:IsA("Texture") then item.Transparency = 1 end
			end
			return true
		end
		local saved = appearanceState.headless[character]
		if not saved then return false end
		head.Transparency = saved.headTransparency
		head.LocalTransparencyModifier = saved.headLocalTransparency
		for _, face in ipairs(saved.faces) do
			if face.item and face.item.Parent then face.item.Transparency = face.transparency end
		end
		return true
	end
	appearanceState.setKorblox = function(active, character)
		character = character or Player.Character
		if not character then return false end
		local saved = appearanceState.korblox[character]
		if not active then
			local oldVisual = character:FindFirstChild("CrystalVisual_Korblox")
			if oldVisual then pcall(function() oldVisual:Destroy() end) end
			for _, child in ipairs(character:GetChildren()) do
				if child:IsA("CharacterMesh") and child.Name == "CrystalVisual_KorbloxCharacterMesh" then
					pcall(function() child:Destroy() end)
				end
			end
			if not saved then return false end
			for _, partState in ipairs(saved.parts) do
				if partState.part and partState.part.Parent then
					partState.part.Transparency = partState.transparency
					partState.part.LocalTransparencyModifier = partState.localTransparency
				end
			end
			return true
		end
		local target = character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg")
		if not target or not target:IsA("BasePart") then return false end
		local ok, objects = pcall(function() return game:GetObjects("rbxassetid://139607673") end)
		if not ok or not objects or not objects[1] then
			warn("Crystal Korblox: no se pudo cargar el asset 139607673")
			return false
		end
		local oldVisual = character:FindFirstChild("CrystalVisual_Korblox")
		if oldVisual then pcall(function() oldVisual:Destroy() end) end
		for _, child in ipairs(character:GetChildren()) do
			if child:IsA("CharacterMesh") and child.Name == "CrystalVisual_KorbloxCharacterMesh" then
				pcall(function() child:Destroy() end)
			end
		end
		local visual = Instance.new("Model")
		visual.Name = "CrystalVisual_Korblox"
		for _, object in ipairs(objects) do object.Parent = visual end
		local importedParts = {}
		for _, descendant in ipairs(visual:GetDescendants()) do
			if descendant:IsA("BasePart") then table.insert(importedParts, descendant) end
		end
		local characterMeshes = {}
		for _, descendant in ipairs(visual:GetDescendants()) do
			if descendant:IsA("CharacterMesh") then table.insert(characterMeshes, descendant) end
		end
		if #importedParts == 0 and #characterMeshes == 0 then
			visual:Destroy()
			warn("Crystal Korblox: el asset 139607673 no contiene piezas compatibles")
			return false
		end
		if not saved then
			saved = {parts = {}}
			for _, partName in ipairs({"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg"}) do
				local part = character:FindFirstChild(partName)
				if part and part:IsA("BasePart") then
					table.insert(saved.parts, {part = part, transparency = part.Transparency, localTransparency = part.LocalTransparencyModifier})
				end
			end
			appearanceState.korblox[character] = saved
		end
		visual.Parent = character
		local isR15 = character:FindFirstChild("LeftUpperLeg") ~= nil
		if isR15 then
			for _, partState in ipairs(saved.parts) do
				if partState.part and partState.part.Parent then
					partState.part.Transparency = 1
					partState.part.LocalTransparencyModifier = 1
				end
			end
		end
		for _, part in ipairs(importedParts) do
			local matchingTarget = character:FindFirstChild(part.Name)
			if not matchingTarget or not matchingTarget:IsA("BasePart") then matchingTarget = target end
			part.Anchored = false
			part.CanCollide = false
			part.Massless = true
			part.CFrame = matchingTarget.CFrame
			local weld = Instance.new("WeldConstraint")
			weld.Part0 = matchingTarget
			weld.Part1 = part
			weld.Parent = part
		end
		for _, mesh in ipairs(characterMeshes) do
			mesh.Name = "CrystalVisual_KorbloxCharacterMesh"
			mesh.Parent = character
		end
		return true
	end
	FeaturePostToggle["Headless Visual"] = function(active)
		appearanceState.setHeadless(active == true, Player.Character)
	end
	FeaturePostToggle["Korblox Visual"] = function(active)
		task.spawn(appearanceState.setKorblox, active == true, Player.Character)
	end
	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(character)
		task.wait(0.75)
		if toggleStates["Headless Visual"] then appearanceState.setHeadless(true, character) end
		if toggleStates["Korblox Visual"] then appearanceState.setKorblox(true, character) end
	end))
	if toggleStates["Headless Visual"] then task.delay(0.5, appearanceState.setHeadless, true, Player.Character) end
	if toggleStates["Korblox Visual"] then task.delay(0.5, appearanceState.setKorblox, true, Player.Character) end
	end

	do
	local skyOrigLighting = {
	Ambient = Lighting.Ambient,
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	FogColor = Lighting.FogColor,
	FogEnd = Lighting.FogEnd,
	GlobalShadows = Lighting.GlobalShadows,
	EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
	EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
	OutdoorAmbient = Lighting.OutdoorAmbient,
	}
	local skyActiveColorCorr = nil
	skyCurrentMode = _G.__CrystalSkyChangerMode or "blue"

	local skyActiveAtmos = nil
	_G.__SkyPresetOrder = { "blue", "sunset", "galaxy", "cherry", "aurora", "ocean", "dusk", "toxic" }
	local function clearSkyColorCorr()
	if skyActiveAtmos then
	pcall(function() skyActiveAtmos:Destroy() end)
	skyActiveAtmos = nil
	end
	if skyActiveColorCorr then
	pcall(function() skyActiveColorCorr:Destroy() end)
	skyActiveColorCorr = nil
	end
	end

	local function restoreSkyLighting()
	clearSkyColorCorr()
	pcall(function()
	Lighting.Ambient = skyOrigLighting.Ambient
	Lighting.Brightness = skyOrigLighting.Brightness
	Lighting.ClockTime = skyOrigLighting.ClockTime
	Lighting.FogColor = skyOrigLighting.FogColor
	Lighting.FogEnd = skyOrigLighting.FogEnd
	Lighting.GlobalShadows = skyOrigLighting.GlobalShadows
	Lighting.EnvironmentDiffuseScale = skyOrigLighting.EnvironmentDiffuseScale
	Lighting.EnvironmentSpecularScale = skyOrigLighting.EnvironmentSpecularScale
	Lighting.OutdoorAmbient = skyOrigLighting.OutdoorAmbient
	end)
	end

	function applySky(kind)
	if kind == nil or kind == "none" then
	restoreSkyLighting()
	return
	end

	clearSkyColorCorr()
	local cc = Instance.new("ColorCorrectionEffect")
	cc.Parent = Lighting
	skyActiveColorCorr = cc

	local P = {
	blue   = { clock = 14,  bright = 2,   amb = {30,60,120},  out = {70,110,190},  fog = {40,80,160},   tint = {140,180,255}, sat = 0.4,  con = 0.1,  atm = {{120,170,255},{80,130,220},0.25,0.3} },
	sunset = { clock = 17.8,bright = 2,   amb = {120,60,50},  out = {200,110,80},  fog = {255,140,90},   tint = {255,190,150}, sat = 0.45, con = 0.1,  atm = {{255,150,90},{200,90,80},0.35,0.4} },
	galaxy = { clock = 0,   bright = 1,   amb = {50,25,95},   out = {80,50,150},   fog = {35,15,70},     tint = {200,160,255}, sat = 0.5,  con = 0.15, atm = {{110,60,190},{60,30,120},0.4,0.1} },
	cherry = { clock = 16.5,bright = 2,   amb = {140,80,105}, out = {220,150,180}, fog = {255,175,205},  tint = {255,205,225}, sat = 0.35, con = 0.05, atm = {{255,170,205},{230,130,170},0.3,0.2} },
	aurora = { clock = 1,   bright = 1.2, amb = {20,80,70},   out = {40,150,120},  fog = {15,60,70},     tint = {170,255,220}, sat = 0.5,  con = 0.12, atm = {{60,220,170},{30,120,140},0.35,0.2} },
	ocean  = { clock = 13,  bright = 2,   amb = {20,90,110},  out = {60,160,190},  fog = {30,130,160},   tint = {160,235,255}, sat = 0.4,  con = 0.08, atm = {{80,200,230},{40,130,170},0.3,0.25} },
	dusk   = { clock = 18.5,bright = 1.5, amb = {70,50,110},  out = {120,90,170},  fog = {110,70,150},   tint = {215,180,255}, sat = 0.3,  con = 0.1,  atm = {{170,110,210},{100,60,150},0.35,0.3} },
	toxic  = { clock = 2,   bright = 1.3, amb = {50,100,30},  out = {90,170,50},   fog = {60,120,30},    tint = {190,255,150}, sat = 0.55, con = 0.15, atm = {{140,230,70},{70,130,40},0.4,0.2} },
	}
	local pr = P[kind] or P.blue
	local function c3(t) return Color3.fromRGB(t[1], t[2], t[3]) end
	Lighting.ClockTime = pr.clock
	Lighting.Brightness = pr.bright
	Lighting.Ambient = c3(pr.amb)
	Lighting.OutdoorAmbient = c3(pr.out)
	Lighting.FogColor = c3(pr.fog)
	cc.TintColor = c3(pr.tint)
	cc.Saturation = pr.sat
	cc.Contrast = pr.con
	pcall(function()
	local at = Instance.new("Atmosphere")
	at.Color = c3(pr.atm[1])
	at.Decay = c3(pr.atm[2])
	at.Density = pr.atm[3]
	at.Haze = pr.atm[4]
	at.Parent = Lighting
	skyActiveAtmos = at
	end)
	end

	FeaturePostToggle["Sky Changer"] = function(active)
	if active then
	applySky(skyCurrentMode)
	else
	restoreSkyLighting()
	end
	end

	local skyChangerToggle = makeToggleNoKeybind(visualSection, "Sky Changer", "Sky Changer")
	if skyChangerToggle then
	local skyModeBtn = Instance.new("TextButton", skyChangerToggle)
	skyModeBtn.Name = "SkyModeBtn"
	skyModeBtn.Size = UDim2.new(0, 66, 0, 20)
	skyModeBtn.Position = UDim2.new(1, -74, 0.5, -10)
	skyModeBtn.AnchorPoint = Vector2.new(0, 0)
	skyModeBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	skyModeBtn.BorderSizePixel = 0
	skyModeBtn.Text = "BLUE"
	skyModeBtn.TextColor3 = Color3.fromRGB(225,238,255)
	skyModeBtn.Font = Enum.Font.GothamBold
	skyModeBtn.TextSize = isMobile and 8 or 9
	skyModeBtn.AutoButtonColor = false
	skyModeBtn.ZIndex = 30
	Instance.new("UICorner", skyModeBtn).CornerRadius = UDim.new(0, 4)
	local skyModeStroke = Instance.new("UIStroke", skyModeBtn)
	skyModeStroke.Color = Color3.fromRGB(255,255,255)
	skyModeStroke.Thickness = 1
	skyModeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local function updateSkyModeBtn()
	local label = string.upper(skyCurrentMode or "blue")
	skyModeBtn.Text = label
	skyModeBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	skyModeBtn.TextColor3 = Color3.fromRGB(225,238,255)
	skyModeStroke.Color = Color3.fromRGB(255,255,255)
	skyModeStroke.Thickness = 1
	skyModeBtn.TextStrokeTransparency = 1
	end
	updateSkyModeBtn()
	connectBtn(skyModeBtn, function()
	local order = _G.__SkyPresetOrder
	local idx = 0
	for i, m in ipairs(order) do if m == skyCurrentMode then idx = i break end end
	skyCurrentMode = order[(idx % #order) + 1]
	_G.__CrystalSkyChangerMode = skyCurrentMode
	saveConfig()
	updateSkyModeBtn()
	if toggleStates["Sky Changer"] then
	applySky(skyCurrentMode)
	end
	end)
	end

	if toggleStates["Sky Changer"] then
	task.delay(0.2, function() applySky(skyCurrentMode) end)
	end
	end

	
	makeToggleNoKeybind(visualSection, "Show Buttons", "Show Buttons")
	-- Floating panel size + lock (uranium-style, safe here)
	do
		_G.__CrystalPanelScales = type(_G.__CrystalPanelScales) == "table" and _G.__CrystalPanelScales or { Bypass = 1, Lagger = 1, AntiLose = 1 }
		local function cycleScale(key, btn)
			local ps = _G.__CrystalPanelScales
			local cur = math.clamp(tonumber(ps[key]) or 1, 0.6, 1.8)
			cur = cur + 0.1
			if cur > 1.8 then cur = 0.6 end
			ps[key] = math.floor(cur * 10 + 0.5) / 10
			if btn then btn.Text = string.format("%s  %.1fx", key:upper(), ps[key]) end
			pcall(saveConfig)
		end
		local function makeScaleBtn(label, key)
			local row = Instance.new("Frame", visualSection)
			row.Size = UDim2.new(1, 0, 0, 32)
			row.BackgroundColor3 = Color3.fromRGB(20, 18, 28)
			row.BackgroundTransparency = 0.25
			row.BorderSizePixel = 0
			Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
			local name = Instance.new("TextLabel", row)
			name.Size = UDim2.new(0.55, 0, 1, 0)
			name.Position = UDim2.new(0, 8, 0, 0)
			name.BackgroundTransparency = 1
			name.Font = Enum.Font.GothamBold
			name.TextSize = 11
			name.TextXAlignment = Enum.TextXAlignment.Left
			name.TextColor3 = Color3.fromRGB(230, 225, 245)
			name.Text = label
			local btn = Instance.new("TextButton", row)
			btn.Size = UDim2.new(0.4, -10, 0, 24)
			btn.Position = UDim2.new(0.58, 0, 0.5, -12)
			btn.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
			btn.BorderSizePixel = 0
			btn.AutoButtonColor = false
			btn.Font = Enum.Font.GothamBold
			btn.TextSize = 11
			btn.TextColor3 = Color3.fromRGB(200, 160, 255)
			local sc = math.clamp(tonumber(_G.__CrystalPanelScales[key]) or 1, 0.6, 1.8)
			btn.Text = string.format("%.1fx", sc)
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
			btn.MouseButton1Click:Connect(function()
				cycleScale(key, btn)
				btn.Text = string.format("%.1fx", _G.__CrystalPanelScales[key])
			end)
		end
		makeToggleNoKeybind(visualSection, "Lock Panel Positions", "Lock Panel Positions")
		FeaturePostToggle["Lock Panel Positions"] = function(on)
			_G.__CrystalPanelsLocked = on == true
			pcall(saveConfig)
		end
		_G.__CrystalPanelsLocked = toggleStates["Lock Panel Positions"] == true or _G.__CrystalPanelsLocked == true
		toggleStates["Lock Panel Positions"] = _G.__CrystalPanelsLocked
	end


	-- Buttons visibility panel: choose which quick buttons are on screen
	do
		local BTN_LABELS = {
			"AUTO LEFT", "AUTO RIGHT", "TP BAT", "BAT AIMBOT", "DROP", "TP DOWN",
			"LAGGER MODE", "LAGGER CARRY", "INSTA RESET", "CARRY MODE",
			"AUTO PLAY", "CUSTOM SPEED",
		}
		if type(_G.__CrystalHiddenQuickButtons) ~= "table" then
			_G.__CrystalHiddenQuickButtons = {}
		end
		local panel = Instance.new("Frame")
		panel.Name = "QuickButtonsVisibilityPanel"
		panel.Size = UDim2.new(1, 0, 0, 8 + #BTN_LABELS * 28)
		panel.BackgroundColor3 = Color3.fromRGB(16, 14, 24)
		panel.BackgroundTransparency = 0.2
		panel.BorderSizePixel = 0
		panel.LayoutOrder = 50
		panel.Parent = visualSection
		Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)
		local title = Instance.new("TextLabel", panel)
		title.Size = UDim2.new(1, -12, 0, 22)
		title.Position = UDim2.new(0, 6, 0, 2)
		title.BackgroundTransparency = 1
		title.Font = Enum.Font.GothamBold
		title.TextSize = 11
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.TextColor3 = Color3.fromRGB(230, 225, 245)
		title.Text = "BUTTONS (TOGGLE ON / OFF)"
		local function refreshRow(rowBtn, label)
			local hidden = _G.__CrystalHiddenQuickButtons[label] == true
			-- default: AUTO PLAY / CUSTOM SPEED start hidden
			if _G.__CrystalHiddenQuickButtons[label] == nil and (label == "AUTO PLAY" or label == "CUSTOM SPEED") then
				hidden = true
			end
			rowBtn.Text = (hidden and "OFF  " or "ON   ") .. label
			rowBtn.BackgroundColor3 = hidden and Color3.fromRGB(42, 34, 52) or Color3.fromRGB(70, 120, 210)
			rowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		end
		for i, label in ipairs(BTN_LABELS) do
			local row = Instance.new("TextButton", panel)
			row.Name = "HideBtn_" .. label:gsub("%s+", "")
			row.Size = UDim2.new(1, -12, 0, 24)
			row.Position = UDim2.new(0, 6, 0, 24 + (i - 1) * 28)
			row.BackgroundColor3 = Color3.fromRGB(70, 120, 210)
			row.BorderSizePixel = 0
			row.AutoButtonColor = false
			row.Font = Enum.Font.GothamBold
			row.TextSize = 11
			row.TextXAlignment = Enum.TextXAlignment.Left
			Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)
			refreshRow(row, label)
			row.MouseButton1Click:Connect(function()
				local hidden = _G.__CrystalHiddenQuickButtons
				local currentlyHidden = hidden[label] == true
				if hidden[label] == nil and (label == "AUTO PLAY" or label == "CUSTOM SPEED") then
					currentlyHidden = true
				end
				if currentlyHidden then
					hidden[label] = false  -- force show
				else
					hidden[label] = true   -- hide
				end
				-- store explicit false as shown
				if hidden[label] == false then
					-- keep false so default-hidden ones can be shown
				end
				refreshRow(row, label)
				pcall(saveConfig)
				if type(_G.__CrystalRefreshQuickButtonTheme) == "function" then
					pcall(_G.__CrystalRefreshQuickButtonTheme)
				end
			end)
		end
	end
	makeToggleNoKeybind(visualSection, "Lock Buttons", "Lock Buttons")

	do
	local mainThemesBtnContainer = Instance.new("Frame", visualSection)
	mainThemesBtnContainer.Name = "MainThemesBtnContainer"
	mainThemesBtnContainer.Visible = true
	mainThemesBtnContainer.Size = UDim2.new(1, 0, 0, 30)
	mainThemesBtnContainer.BackgroundTransparency = 1
	mainThemesBtnContainer.BorderSizePixel = 0
	mainThemesBtnContainer.ZIndex = 12
	mainThemesBtnContainer.LayoutOrder = 20

	local mainThemesBtn = Instance.new("TextButton", mainThemesBtnContainer)
	mainThemesBtn.Name = "MainThemesBtn"
	mainThemesBtn.AnchorPoint = Vector2.new(0.5, 0)
	mainThemesBtn.Size = UDim2.new(0, 150, 0, 30)
	mainThemesBtn.Position = UDim2.new(0.5, 0, 0, 0)
	mainThemesBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	mainThemesBtn.BackgroundTransparency = 0.12
	mainThemesBtn.AutoButtonColor = false
	mainThemesBtn.Font = Enum.Font.GothamBold
	mainThemesBtn.Text = "Colors"
	mainThemesBtn.TextColor3 = Color3.fromRGB(235,240,245)
	mainThemesBtn.TextSize = 11
	mainThemesBtn.ZIndex = 12
	mainThemesBtn.TextXAlignment = Enum.TextXAlignment.Center
	mainThemesBtn.TextYAlignment = Enum.TextYAlignment.Center
	Instance.new("UICorner", mainThemesBtn).CornerRadius = UDim.new(0, 8)
	local mainThemesBtnStroke = Instance.new("UIStroke", mainThemesBtn)
	mainThemesBtnStroke.Color = Color3.fromRGB(255,255,255)
	mainThemesBtnStroke.Thickness = 1.2
	mainThemesBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	mainThemesBtnStroke.Transparency = 0.15

	local mainThemesFrame = Instance.new("Frame")
	mainThemesFrame.Name = "MainThemesPanel"
	mainThemesFrame.Size = UDim2.fromOffset(260, 268)
	mainThemesFrame.BackgroundColor3 = Color3.fromRGB(48, 92, 138)
	mainThemesFrame.BorderSizePixel = 0
	mainThemesFrame.Visible = false
	mainThemesFrame.ZIndex = 20
	mainThemesFrame.Parent = ScreenGui
	local themesGradient = Instance.new("UIGradient", mainThemesFrame)
	themesGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 75, 118)),
	ColorSequenceKeypoint.new(0.48, Color3.fromRGB(67, 120, 174)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(34, 67, 108)),
	})
	themesGradient.Rotation = 35

	local function positionMainThemesPanel()
	if Panel then
	local panelX = Panel.Position.X.Offset + Panel.Size.X.Offset
	mainThemesFrame.Position = UDim2.new(
	Panel.Position.X.Scale,
	panelX + 24,
	Panel.Position.Y.Scale,
	Panel.Position.Y.Offset + 6
	)
	end
	end
	if Panel then
	Panel:GetPropertyChangedSignal("Position"):Connect(function()
	if _G.__CrystalModernGuiActive or not mainThemesFrame.Parent then return end
	if mainThemesFrame.Visible then positionMainThemesPanel() end
	end)
	Panel:GetPropertyChangedSignal("Size"):Connect(function()
	if _G.__CrystalModernGuiActive or not mainThemesFrame.Parent then return end
	if mainThemesFrame.Visible then positionMainThemesPanel() end
	end)

	local mainThemesWasOpen = false
	Panel:GetPropertyChangedSignal("Visible"):Connect(function()
	if _G.__CrystalModernGuiActive or not mainThemesFrame.Parent then return end
	if not Panel.Visible then
	if mainThemesFrame.Visible then
	mainThemesWasOpen = true
	mainThemesFrame.Visible = false
	else
	mainThemesWasOpen = false
	end
	else
	if mainThemesWasOpen then
	positionMainThemesPanel()
	mainThemesFrame.Visible = true
	end
	end
	end)
	end
	Instance.new("UICorner", mainThemesFrame).CornerRadius = UDim.new(0, 12)
	local themesStroke = Instance.new("UIStroke", mainThemesFrame)
	themesStroke.Color = Color3.fromRGB(0, 0, 0)
	themesStroke.Thickness = 0
	themesStroke.Transparency = 1

	local pendingBackground = bgIndex or 1
	local themeCards = {}
	local function refreshMainThemeCards()
	for index, data in ipairs(themeCards) do
	local selected = index == pendingBackground
	local card = data.card
	local image = data.image
	local stroke = data.stroke
	local baseX, baseY = data.baseX, data.baseY
	local baseW, baseH = data.baseW, data.baseH

	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Thickness = selected and 2 or 1.5
	stroke.Transparency = selected and 0.25 or 0.7
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	card.Size = selected and UDim2.fromOffset(math.max(4, baseW - 6), math.max(4, baseH - 6)) or UDim2.fromOffset(baseW, baseH)
	card.Position = selected and UDim2.new(0, baseX + 3, 0, baseY + 3) or UDim2.new(0, baseX, 0, baseY)
	card.BackgroundTransparency = 1
	image.Size = UDim2.new(1, 0, 1, 0)
	image.Position = UDim2.new(0, 0, 0, 0)
	image.BackgroundTransparency = 1
	end
	end

	local function layoutMainThemeCards()
	if not mainThemesFrame or not themeCards then return end
	local frameW = mainThemesFrame.AbsoluteSize.X > 0 and mainThemesFrame.AbsoluteSize.X or mainThemesFrame.Size.X.Offset
	local frameH = mainThemesFrame.AbsoluteSize.Y > 0 and mainThemesFrame.AbsoluteSize.Y or mainThemesFrame.Size.Y.Offset
	local paddingX = 12
	local paddingY = 12
	local gapX = 10
	local gapY = 10
	local safeBottom = 36
	local usableW = math.max(0, frameW - paddingX * 2)
	local usableH = math.max(0, frameH - safeBottom - paddingY * 2)
	local cardW = math.floor((usableW - gapX) / 2)
	local cardH = math.floor((usableH - gapY) / 2)

	for index, data in ipairs(themeCards) do
	local col = ((index - 1) % 2)
	local row = math.floor((index - 1) / 2)
	local x = paddingX + col * (cardW + gapX)
	local y = paddingY + row * (cardH + gapY)
	data.baseX = x
	data.baseY = y
	data.baseW = cardW
	data.baseH = cardH
	data.card.Size = UDim2.fromOffset(cardW, cardH)
	data.card.Position = UDim2.new(0, x, 0, y)
	data.image.Size = UDim2.new(1, 0, 1, 0)
	data.image.Position = UDim2.new(0, 0, 0, 0)
	end
	end

	for index, imageId in ipairs(backgroundIds) do
	local card = Instance.new("TextButton", mainThemesFrame)
	card.BackgroundColor3 = Color3.fromRGB(30,30,38)
	card.BackgroundTransparency = 1
	card.BorderSizePixel = 0
	card.Text = ""
	card.AutoButtonColor = false
	card.ZIndex = 21
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 7)
	local cardImage = Instance.new("ImageLabel", card)
	cardImage.BackgroundTransparency = 1
	cardImage.Image = imageId
	cardImage.ScaleType = Enum.ScaleType.Crop
	cardImage.ZIndex = 21
	Instance.new("UICorner", cardImage).CornerRadius = UDim.new(0, 7)
	local cardLabel = Instance.new("TextLabel", card)
	cardLabel.Size = UDim2.new(1, -12, 0, 12)
	cardLabel.Position = UDim2.new(0, 6, 1, -14)
	cardLabel.BackgroundTransparency = 1
	cardLabel.Text = "BG " .. tostring(index)
	cardLabel.TextColor3 = Color3.fromRGB(235,240,245)
	cardLabel.TextSize = 8
	cardLabel.Font = Enum.Font.GothamBold
	cardLabel.ZIndex = 23
	cardLabel.TextStrokeColor3 = Color3.fromRGB(5, 12, 25)
	cardLabel.TextStrokeTransparency = 0.25
	local cardStroke = Instance.new("UIStroke", card)
	cardStroke.Color = Color3.fromRGB(255,255,255)
	cardStroke.Thickness = 0
	cardStroke.Transparency = 1
	cardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	table.insert(themeCards, {
	card = card,
	image = cardImage,
	stroke = cardStroke,
	baseX = 0,
	baseY = 0,
	baseW = 0,
	baseH = 0,
	})
	card.Activated:Connect(function()
	pendingBackground = index
	refreshMainThemeCards()
	end)
	end

	local saveThemeButton = Instance.new("TextButton", mainThemesFrame)
	saveThemeButton.Size = UDim2.new(1, -24, 0, 28)
	saveThemeButton.Position = UDim2.new(0, 12, 1, -44)

	pcall(function() layoutMainThemeCards() end)
	mainThemesFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	pcall(layoutMainThemeCards)
	end)
	saveThemeButton.BackgroundColor3 = Color3.fromRGB(120,180,240)
	saveThemeButton.BorderSizePixel = 0
	saveThemeButton.Text = "Apply Color"
	saveThemeButton.TextColor3 = Color3.fromRGB(235,240,245)
	saveThemeButton.TextSize = 11
	saveThemeButton.Font = Enum.Font.GothamBold
	saveThemeButton.ZIndex = 21
	Instance.new("UICorner", saveThemeButton).CornerRadius = UDim.new(0, 7)
	saveThemeButton.Activated:Connect(function()
	bgIndex = pendingBackground
	_G["_SoundHub_UI_BgPicked"] = true
	if BgImage then BgImage.Image = backgroundIds[bgIndex] end
	mainThemesFrame.Visible = false
	if HeaderBgBtn then pcall(function() HeaderBgBtn.Text = tostring(bgIndex) .. "/" .. tostring(#backgroundIds) end) end
	_G["_SoundHub_UI_BgIndex"] = bgIndex
	if _G.__CrystalApplyCurtVisualTheme then pcall(_G.__CrystalApplyCurtVisualTheme, bgIndex) end
	saveConfig()
	end)

	mainThemesBtn.Activated:Connect(function()
	pendingBackground = bgIndex
	positionMainThemesPanel()
	mainThemesFrame.Visible = not mainThemesFrame.Visible
	refreshMainThemeCards()
	end)

	if HeaderBgBtn then pcall(function() HeaderBgBtn.Visible = false end) end
	end

	;(function()
	local oldQuickButtons = _G.__CrystalQuickButtonsFrame
	if oldQuickButtons then pcall(function() oldQuickButtons:Destroy() end) end

	local quickButtons = Instance.new("Frame")
	quickButtons.Name = "CrystalQuickButtons"
	quickButtons.Size = UDim2.new(1, 0, 1, 0)
	quickButtons.Position = UDim2.new(0, 0, 0, 0)
	quickButtons.BackgroundTransparency = 1
	quickButtons.BorderSizePixel = 0
	quickButtons.Active = false
	quickButtons.ZIndex = 750
	quickButtons.Visible = toggleStates["Show Buttons"] == true
	quickButtons.Parent = ScreenGui
	_G.__CrystalQuickButtonsFrame = quickButtons

	local function quickAccent()
	if _G.__CrystalHalloweenMode == true or toggleStates["Halloween Mode"] == true then
	return Color3.fromRGB(255, 126, 26)
	end
	return _G.__SoundAccentColor()
	end

	-- Outline look: blue/thin normally, ORANGE/thicker in Halloween mode
	local function quickOutlineLook(pressed)
	local halloween = _G.__CrystalHalloweenMode == true or toggleStates["Halloween Mode"] == true
	if halloween then
	return Color3.fromRGB(255, 126, 26), (pressed and 8 or 6)
	end
	return Color3.fromRGB(0, 140, 255), 4
	end

	_G.__CrystalQuickBgSets = {
		purple = { "rbxassetid://121247637304646", "rbxassetid://76359284971264" },
		azure = { "rbxassetid://73988378894997", "rbxassetid://119151268411689" },
		green = { "rbxassetid://127305787467551", "rbxassetid://136516494660487" },
		halloween = { "rbxassetid://139782488960756" },
	}
	if _G.__CrystalQuickBgIndex == nil then _G.__CrystalQuickBgIndex = 1 end
	-- Buttons Panel Menu BG removed permanently: panel mode is always disabled.
	_G.__CrystalQuickPanel = false
	local quickBgItems = {}
	local function makeQuickButton(label, order)
	local button = Instance.new("TextButton")
	button.Name = label:gsub("%s+", "") .. "Button"
	local sizeScale = Instance.new("UIScale", button)
	sizeScale.Name = "QuickButtonSizeScale"
	sizeScale.Scale = _G.__CrystalButtonsSize or 1

	local BTN_W = 62
	local BTN_H = 62
	-- Slightly increase spacing so floating buttons no longer touch, keeping a consistent grid.
	local buttonGap = 14
	local shape = (_G.__CrystalButtonsShape == "Rectangle") and "Rectangle" or "Circle"
	local CORNER_R = (shape == "Circle") and 999 or 14
	button.Size = UDim2.new(0, BTN_W, 0, BTN_H)
	button:SetAttribute("QuickButtonShape", shape)

	local baseY = (isMobile and 62 or 71)
	local margin = isMobile and 12 or 16
	local col, row
	if order <= 10 then
	col = (order - 1) % 2
	row = math.floor((order - 1) / 2)
	else
	col = 2
	row = order - 11
	end
	local sc = _G.__CrystalButtonsSize or 1
	local camera = workspace.CurrentCamera
	local viewX = camera and camera.ViewportSize.X or 800
	local viewY = camera and camera.ViewportSize.Y or 450
	local fromRight = (col == 1) and 0 or ((col == 0) and 1 or 2)
	if _G.__CrystalRealMobile then
		-- Mobile grid: right column / middle column / staggered left column (x from the right, y in rows)
		local MOBILE_GRID = {
			["AUTO LEFT"] = {0, 0}, ["AUTO RIGHT"] = {0, 1}, ["CARRY MODE"] = {0, 2}, ["LAGGER CARRY"] = {0, 3},
			["DROP"] = {1, 0}, ["BAT AIMBOT"] = {1, 1}, ["TP DOWN"] = {1, 2}, ["LAGGER MODE"] = {1, 3},
			["TP BAT"] = {2, 0.68}, ["INSTA RESET"] = {2, 1.68}, ["CUSTOM SPEED"] = {2, 2.68}, ["AUTO PLAY"] = {2, 3.68},
		}
		local cell = MOBILE_GRID[label]
		if cell then
			fromRight = cell[1]
			row = cell[2]
			margin = 18
			baseY = math.floor(viewY * 0.12)
		end
	end
	local btnX = viewX - margin - BTN_W * sc - fromRight * (BTN_W * sc + buttonGap)
	button.Position = UDim2.new(0, math.max(0, math.floor(btnX)), 0, math.floor(baseY + row * (BTN_H + buttonGap)))
	button.LayoutOrder = order
	button:SetAttribute("OriginalPosition", button.Position)
	button.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
	button.BackgroundTransparency = 0
	button.BorderSizePixel = 0
	button.AutoButtonColor = false
	button.Active = true
	button.Draggable = false
	button.Font = Enum.Font.GothamBold
	button.Text = label
	button.TextScaled = true
	button.TextWrapped = true
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	button.TextStrokeTransparency = 1
	button.ZIndex = 751
	button.Parent = quickButtons
	-- dot removed
	local btnCorner = Instance.new("UICorner")
	btnCorner.Name = "QuickShapeCorner"
	if shape == "Circle" then
		btnCorner.CornerRadius = UDim.new(1, 0)
	else
		btnCorner.CornerRadius = UDim.new(0, CORNER_R)
	end
	btnCorner.Parent = button
	local textSizeConstraint = Instance.new("UITextSizeConstraint")
	textSizeConstraint.MinTextSize = 9
	textSizeConstraint.MaxTextSize = 13
	textSizeConstraint.Parent = button
	local textPad = Instance.new("UIPadding", button)
	textPad.PaddingLeft = UDim.new(0, 6)
	textPad.PaddingRight = UDim.new(0, 6)
	-- Double border: outer white thin + inner purple
	local strokeOuter = Instance.new("UIStroke")
	strokeOuter.Name = "QuickOuterStroke"
	strokeOuter.Color = Color3.fromRGB(255, 255, 255)
	strokeOuter.Thickness = 1
	strokeOuter.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	strokeOuter.Transparency = 0
	strokeOuter.Parent = button
	local strokeInner = Instance.new("UIStroke")
	strokeInner.Name = "QuickInnerStroke"
	strokeInner.Color = Color3.fromRGB(160, 60, 220)
	strokeInner.Thickness = 2
	strokeInner.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	strokeInner.Transparency = 0
	strokeInner.Parent = btnCorner
	-- keep stroke alias for InputBegan/InputEnded references below
	local stroke = strokeOuter
	button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			button:SetAttribute("QPressed", true)
			stroke.Transparency = 1
		end
	end)
	button.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			button:SetAttribute("QPressed", false)
			stroke.Transparency = 1
		end
	end)
	-- background image layer (theme art) + mirrored label so the text stays readable on top
	do
		local qimg = Instance.new("ImageLabel")
		qimg.Name = "QuickBgImage"
		qimg.BackgroundTransparency = 1
		qimg.Size = UDim2.new(1, 0, 1, 0)
		qimg.ScaleType = Enum.ScaleType.Crop
		qimg.ImageTransparency = 0.15
		qimg.ZIndex = 752
		qimg.Active = false
		qimg.Visible = false
		qimg.Parent = button
		local qcorner = Instance.new("UICorner", qimg)
		qcorner.CornerRadius = UDim.new(0, CORNER_R)
		local qlbl = Instance.new("TextLabel")
		qlbl.Name = "QuickBgLabel"
		qlbl.BackgroundTransparency = 1
		qlbl.Size = UDim2.new(1, 0, 1, 0)
		qlbl.Font = Enum.Font.GothamBold
		qlbl.TextScaled = true
		qlbl.TextWrapped = true
		qlbl.Text = button.Text
		qlbl.TextColor3 = button.TextColor3
		qlbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		qlbl.TextStrokeTransparency = 0.55
		qlbl.ZIndex = 753
		qlbl.Active = false
		qlbl.Visible = false
		qlbl.Parent = button
		local qc = Instance.new("UITextSizeConstraint", qlbl)
		qc.MinTextSize = 9
		qc.MaxTextSize = 13
		local qp = Instance.new("UIPadding", qlbl)
		qp.PaddingLeft = UDim.new(0, 6)
		qp.PaddingRight = UDim.new(0, 6)
		button:GetPropertyChangedSignal("Text"):Connect(function() qlbl.Text = button.Text end)
		button:GetPropertyChangedSignal("TextColor3"):Connect(function() qlbl.TextColor3 = button.TextColor3 end)
		local function syncActive()
			qimg.ImageTransparency = (button:GetAttribute("QActive") == true) and 0.65 or 0.15
		end
		button:GetAttributeChangedSignal("QActive"):Connect(syncActive)
		quickBgItems[#quickBgItems + 1] = { button = button, img = qimg, lbl = qlbl, corner = qcorner, sync = syncActive }
	end
	return button, stroke
	end

	local autoLeftButton, autoLeftStroke = makeQuickButton("AUTO LEFT", 1)
	local autoRightButton, autoRightStroke = makeQuickButton("AUTO RIGHT", 2)
	local tpBatButton, tpBatStroke = makeQuickButton("TP BAT", 3)
	local aimbotButton, aimbotStroke = makeQuickButton("BAT AIMBOT", 4)
	local dropButton, dropStroke = makeQuickButton("DROP", 5)
	local tpDownButton, tpDownStroke = makeQuickButton("TP DOWN", 6)
	local speedModeButton, speedModeStroke = makeQuickButton("LAGGER MODE", 7)
	local laggerCarryButton, laggerCarryStroke = makeQuickButton("LAGGER CARRY", 8)
	local instaResetButton, instaResetStroke = makeQuickButton("INSTA RESET", 9)
	local carrySpeedButton, carrySpeedStroke = makeQuickButton("CARRY MODE", 10)
	local autoplayButton, autoplayStroke = makeQuickButton("AUTO PLAY", 12)
	autoplayButton.Visible = false
	local quickTapBlocked = {}
	quickTapBlocked.custom = {}
	quickTapBlocked.custom.button, quickTapBlocked.custom.stroke = makeQuickButton("CUSTOM SPEED", 11)

	quickTapBlocked.custom.button.Visible = false

	-- Buttons background image: per theme set, cycled from the Visual tab ("Buttons Background")
	local quickBgKeyLast = nil
	-- Panel mode: all buttons sit inside ONE rounded panel that carries the theme background image
	local quickPanel = Instance.new("ImageLabel")
	quickPanel.Name = "QuickButtonsPanel"
	quickPanel.BackgroundColor3 = Color3.fromRGB(10, 6, 12)
	quickPanel.BackgroundTransparency = 0
	quickPanel.BorderSizePixel = 0
	quickPanel.ScaleType = Enum.ScaleType.Crop
	quickPanel.ImageTransparency = 0.25
	quickPanel.ZIndex = 745
	quickPanel.Active = false
	quickPanel.Visible = false
	quickPanel.Parent = quickButtons
	Instance.new("UICorner", quickPanel).CornerRadius = UDim.new(0, 22)
	local quickPanelStroke = Instance.new("UIStroke", quickPanel)
	quickPanelStroke.Thickness = 2
	quickPanelStroke.Transparency = 0.15
	quickPanelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	-- Panel layout (2 columns):
	--   AUTO LEFT   | AUTO RIGHT
	--   BAT AIMBOT  | TP BAT
	--   DROP        | TP DOWN
	--   INSTA RESET | LAGGER MODE
	--   LAGGER CARRY| CARRY MODE
	local PANEL_ROWS = {
		{ autoLeftButton, autoRightButton },
		{ aimbotButton, tpBatButton },
		{ dropButton, tpDownButton },
		{ instaResetButton, speedModeButton },
		{ laggerCarryButton, carrySpeedButton },
		{ autoplayButton, quickTapBlocked.custom.button },
	}
	local function layoutQuickPanelGrid()
		if _G.__CrystalQuickPanel ~= true then return end
		local sc = _G.__CrystalButtonsSize or 1
		local PANEL_SHRINK = 0.82
		local psc = sc * PANEL_SHRINK
		local gap = 5
		local cell = 62 * psc + gap
		local gridW = 2 * cell - gap
		for _, r in ipairs(PANEL_ROWS) do
			for col = 1, 2 do
				local b = r[col]
				local us = b and b:FindFirstChild("QuickButtonSizeScale")
				if us and us.Scale ~= psc then us.Scale = psc end
			end
		end
		local viewX = quickButtons.AbsoluteSize.X
		local viewY = quickButtons.AbsoluteSize.Y
		if viewX <= 0 or viewY <= 0 then
			local cam = workspace.CurrentCamera
			viewX = cam and cam.ViewportSize.X or 800
			viewY = cam and cam.ViewportSize.Y or 450
		end
		local origin = _G.__CrystalQuickPanelOrigin
		if typeof(origin) ~= "Vector2" then
			origin = Vector2.new(viewX - 30 - gridW, math.floor(viewY * 0.12) + 12)
		end
		local rowsShown = 0
		for _, r in ipairs(PANEL_ROWS) do
			if (r[1] and r[1].Visible) or (r[2] and r[2].Visible) then rowsShown = rowsShown + 1 end
		end
		local gridH = math.max(1, rowsShown) * cell - gap
		origin = Vector2.new(
			math.clamp(origin.X, 12, math.max(12, viewX - gridW - 12)),
			math.clamp(origin.Y, 12, math.max(12, viewY - gridH - 12))
		)
		_G.__CrystalQuickPanelOrigin = origin
		local rowIndex = 0
		for _, r in ipairs(PANEL_ROWS) do
			if (r[1] and r[1].Visible) or (r[2] and r[2].Visible) then
				for col = 1, 2 do
					local b = r[col]
					if b then
						b.Position = UDim2.fromOffset(math.floor(origin.X + (col - 1) * cell), math.floor(origin.Y + rowIndex * cell))
					end
				end
				rowIndex = rowIndex + 1
			end
		end
	end
	_G.__CrystalQuickPanelLayout = layoutQuickPanelGrid
	local function updateQuickPanel()
		layoutQuickPanelGrid()
		if _G.__CrystalQuickPanel ~= true then
			if quickPanel.Visible then quickPanel.Visible = false end
			local fullSc = _G.__CrystalButtonsSize or 1
			for _, item in ipairs(quickBgItems) do
				local us = item.button and item.button:FindFirstChild("QuickButtonSizeScale")
				if us and us.Scale ~= fullSc then us.Scale = fullSc end
			end
			return
		end
		local origin = quickButtons.AbsolutePosition
		local minX, minY, maxX, maxY
		for _, item in ipairs(quickBgItems) do
			local b = item.button
			if b and b.Parent and b.Visible then
				local pos = b.AbsolutePosition - origin
				local sz = b.AbsoluteSize
				minX = math.min(minX or pos.X, pos.X)
				minY = math.min(minY or pos.Y, pos.Y)
				maxX = math.max(maxX or (pos.X + sz.X), pos.X + sz.X)
				maxY = math.max(maxY or (pos.Y + sz.Y), pos.Y + sz.Y)
				if b.BackgroundTransparency ~= 0.3 then b.BackgroundTransparency = 0.3 end
			end
		end
		if not minX then
			if quickPanel.Visible then quickPanel.Visible = false end
			return
		end
		local pad = 8
		quickPanel.Position = UDim2.fromOffset(math.floor(minX - pad), math.floor(minY - pad))
		quickPanel.Size = UDim2.fromOffset(math.ceil(maxX - minX + pad * 2), math.ceil(maxY - minY + pad * 2))
		quickPanelStroke.Color = quickAccent()
		if not quickPanel.Visible then quickPanel.Visible = true end
	end
	local function quickBgThemeKey()
		if _G.__CrystalHalloweenMode == true or toggleStates["Halloween Mode"] == true then return "halloween" end
		local ct = "purple"
		if ct == "purple" or ct == "green" then return ct end
		return "azure"
	end
	local function applyQuickBg()
		local key = quickBgThemeKey()
		local list = _G.__CrystalQuickBgSets[key] or {}
		local idx = tonumber(_G.__CrystalQuickBgIndex) or 1
		if idx > #list then idx = (#list > 0) and ((idx - 1) % #list) + 1 or 0 end
		if idx < 0 then idx = 0 end
		local panelMode = false -- Buttons Panel Menu BG logic removed; never enable panel mode.
		local image = (panelMode and list[1]) or nil
		-- Panel mode (optional) uses the main MENU background so the buttons panel matches the menu
		if panelMode and type(_G.__SoundGetMenuBackgroundImage) == "function" then
			local okBg, menuImg = pcall(_G.__SoundGetMenuBackgroundImage)
			if okBg and type(menuImg) == "string" and menuImg ~= "" then image = menuImg end
		end
		quickPanel.Image = (panelMode and image) or ""
		for _, item in ipairs(quickBgItems) do
			if item.button and item.button.Parent then
				local on = image ~= nil and not panelMode
				if not panelMode and item.button.BackgroundTransparency ~= 0 then item.button.BackgroundTransparency = 0 end
				item.img.Visible = on
				item.lbl.Visible = on
				item.button.TextTransparency = on and 1 or 0
				if on then
					item.img.Image = image
					local sc = item.button:FindFirstChild("QuickShapeCorner")
					if sc then item.corner.CornerRadius = sc.CornerRadius end
					item.lbl.Text = item.button.Text
					item.lbl.TextColor3 = item.button.TextColor3
					item.sync()
				end
			end
		end
		quickBgKeyLast = key .. ":" .. tostring(_G.__CrystalQuickBgIndex) .. ":" .. tostring(_G.__CrystalButtonsShape) .. ":" .. tostring(_G.__CrystalQuickPanel)
		updateQuickPanel()
	end
	_G.__CrystalApplyQuickBg = applyQuickBg
	applyQuickBg()

	quickTapBlocked.custom.getByName = function(name)
	for _, customSpeed in ipairs(customSpeeds) do
	if customSpeed.name == name then return customSpeed end
	end
	return nil
	end

	quickTapBlocked.custom.getSelected = function()
	local selectedCustomSpeed = quickTapBlocked.custom.getByName(selectedMode)
	if selectedCustomSpeed then
	quickTapBlocked.custom.lastName = selectedCustomSpeed.name
	return selectedCustomSpeed
	end
	return quickTapBlocked.custom.getByName(quickTapBlocked.custom.lastName) or customSpeeds[1]
	end

	local function setQuickVisual(button, stroke, active)
	-- Dark rounded square + white text; when ON the button fills with the accent colour and the text turns dark.
	button:SetAttribute("QActive", active == true)
	button.BackgroundTransparency = 0
	local qDot = button:FindFirstChild("QuickDot")
	if qDot then
		-- accent dot on the black (OFF) button, black dot on the accent-filled (ON) button
		qDot.BackgroundColor3 = active and Color3.fromRGB(0, 0, 0) or quickAccent()
	end
	if active then
		button.BackgroundColor3 = quickAccent()
		button.TextColor3 = Color3.fromRGB(16, 10, 30)
	else
		button.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
		button.TextColor3 = Color3.fromRGB(255, 255, 255)
	end
	button.TextStrokeTransparency = 1
	stroke.Transparency = 1
	local shapeOutline = button:FindFirstChild("QuickShapeOutline")
	if shapeOutline then shapeOutline.Color = quickAccent() end
	end

	local function toggleQuickFeature(featureName)
	local blockedWhileStealing = {}
	local newState = not (toggleStates[featureName] == true)
	if newState and blockedWhileStealing[featureName] and Player:GetAttribute("Stealing") == true then
	return
	end
	toggleStates[featureName] = newState
	if toggleStateSetters[featureName] then pcall(toggleStateSetters[featureName], newState) end
	if FeaturePostToggle[featureName] then pcall(FeaturePostToggle[featureName], newState) end
	saveConfig()
	end

	local movableButtons = {
	autoLeftButton, autoRightButton, aimbotButton, tpBatButton, dropButton, tpDownButton,
	speedModeButton, laggerCarryButton, instaResetButton, carrySpeedButton, quickTapBlocked.custom.button,
	}

	task.defer(function()
	for _, button in ipairs(movableButtons) do
	local saved = quickButtonPositions[button.Name]
	if saved and saved.x and saved.y then
	local x, y = placeInsideViewport(button, 0, saved.x, 0, saved.y, _G.__CrystalButtonsSize or 1)
	button.Position = UDim2.new(0, x, 0, y)
	quickButtonPositions[button.Name] = { x = x, y = y }
	else
	local position = button.Position
	placeInsideViewport(button, position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset, _G.__CrystalButtonsSize or 1)
	end
	end
	end)

	local draggingQuickButton = nil
	local quickDragStart = nil
	local quickDragPosition = nil
	local quickDragInput = nil

	local quickDragMoved = false
	_G.__CrystalSetButtonsSize = function(value)
		local size = tonumber((tostring(value):gsub(",", ".")))
		if not size or size ~= size or math.abs(size) == math.huge then return _G.__CrystalButtonsSize end
		size = math.floor(math.clamp(size, 0.5, 2) * 100 + 0.5) / 100
		_G.__CrystalButtonsSize = size
		draggingQuickButton, quickDragStart, quickDragPosition, quickDragInput = nil, nil, nil, nil
		quickDragMoved = false
		for _, button in ipairs(movableButtons) do
			button.QuickButtonSizeScale.Scale = size
			local position = button.Position
			local x, y = placeInsideViewport(button, position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset, size)
			if quickButtonPositions[button.Name] then quickButtonPositions[button.Name] = {x = x, y = y} end
		end
		saveConfig()
		return size
	end
	local function applyQuickButtonShape(shape)
		shape = (shape == "Rectangle" or shape == "Rectangular" or shape == "Normal") and "Rectangle" or "Circle"
		_G.__CrystalButtonsShape = shape
		for _, button in ipairs(movableButtons) do
			if button and button.Parent then
				button:SetAttribute("QuickButtonShape", shape)
				local corner = button:FindFirstChild("QuickShapeCorner")
				if not corner then corner = button:FindFirstChildOfClass("UICorner") end
				if not corner then
					corner = Instance.new("UICorner")
					corner.Name = "QuickShapeCorner"
					corner.Parent = button
				end
				if shape == "Circle" then
					corner.CornerRadius = UDim.new(1, 0)
				else
					corner.CornerRadius = UDim.new(0, 14)
				end
				local bgImg = button:FindFirstChild("QuickBgImage")
				local bgCorner = bgImg and bgImg:FindFirstChildOfClass("UICorner")
				if bgCorner then bgCorner.CornerRadius = (shape == "Circle") and UDim.new(1, 0) or UDim.new(0, 14) end
				local qdot = button:FindFirstChild("QuickDot")
				if qdot then qdot.Position = UDim2.new(1, (shape == "Circle") and -10 or -6, 0, (shape == "Circle") and 10 or 6) end
				local oldFrame = button:FindFirstChild("QuickSquareFrame")
				if oldFrame then oldFrame:Destroy() end
				button.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
			end
		end
	end
	_G.__CrystalSetButtonsShape = function(shape)
		applyQuickButtonShape(shape)
		saveConfig()
		if toggleVisualUpdaters["ButtonsShapePicker"] then pcall(toggleVisualUpdaters["ButtonsShapePicker"]) end
		return _G.__CrystalButtonsShape
	end
	-- apply saved shape once buttons exist
	task.defer(function()
		applyQuickButtonShape(_G.__CrystalButtonsShape or "Circle")
	end)
	quickTapBlocked.resetPositions = function()

	if draggingQuickButton then
	local button = draggingQuickButton
	quickTapBlocked[button] = true
	task.delay(0.2, function() quickTapBlocked[button] = nil end)
	end
	draggingQuickButton = nil
	quickDragStart = nil
	quickDragPosition = nil
	quickDragInput = nil
	quickDragMoved = false
	table.clear(quickButtonPositions)
	_G.__CrystalQuickPanelOrigin = nil
	for _, button in ipairs(movableButtons) do
	local position = button:GetAttribute("OriginalPosition")
	placeInsideViewport(button, position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset, _G.__CrystalButtonsSize or 1)
	end
	_G.__CrystalGuiPositionsReset = true
	for _, resetPosition in pairs(_G.__CrystalGuiPositionResetters) do
	resetPosition()
	end
	saveConfig()
	end
	_G.__CrystalResetButtonPositions = quickTapBlocked.resetPositions
	local function quickButtonsAreLocked()
	return toggleStates["Lock Buttons"] == true
	end
	local function updateQuickButtonPosition(input)
	if not draggingQuickButton or not quickDragStart or not quickDragPosition then return end
	local delta = input.Position - quickDragStart
	if delta.Magnitude > 6 then
	quickDragMoved = true
	end
	if _G.__CrystalQuickPanel == true and typeof(_G.__CrystalQuickPanelDragOrigin) == "Vector2" then
	_G.__CrystalQuickPanelOrigin = _G.__CrystalQuickPanelDragOrigin + Vector2.new(delta.X, delta.Y)
	layoutQuickPanelGrid()
	return
	end
	local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(0, 0)
	local size = draggingQuickButton.AbsoluteSize
	local x = math.clamp(quickDragPosition.X.Offset + delta.X, 0, math.max(0, viewport.X - size.X))
	local y = math.clamp(quickDragPosition.Y.Offset + delta.Y, 0, math.max(0, viewport.Y - size.Y))
	draggingQuickButton.Position = UDim2.new(0, x, 0, y)
	end
	for _, button in ipairs(movableButtons) do
	button.InputBegan:Connect(function(input)
	if quickButtonsAreLocked() then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
	draggingQuickButton = button
	quickDragStart = input.Position
	quickDragPosition = button.Position
	quickDragInput = input
	quickDragMoved = false
	_G.__CrystalQuickPanelDragOrigin = (typeof(_G.__CrystalQuickPanelOrigin) == "Vector2") and _G.__CrystalQuickPanelOrigin or Vector2.new(button.Position.X.Offset, button.Position.Y.Offset)
	end
	end)
	end
	_G.__CrystalTrackConn(UserInputService.InputChanged:Connect((function(input)
	if not draggingQuickButton or quickButtonsAreLocked() then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement or input == quickDragInput then
	updateQuickButtonPosition(input)
	end
	end)))
	_G.__CrystalTrackConn(UserInputService.InputEnded:Connect(function(input)
	local isMouseRelease = quickDragInput and quickDragInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseButton1
	if draggingQuickButton and (input == quickDragInput or isMouseRelease) then
	local movedButton = draggingQuickButton
	draggingQuickButton = nil
	quickDragStart = nil
	quickDragPosition = nil
	quickDragInput = nil
	if quickDragMoved then
	if _G.__CrystalQuickPanel ~= true then
	quickButtonPositions[movedButton.Name] = {
	x = movedButton.Position.X.Offset,
	y = movedButton.Position.Y.Offset,
	}
	end
	saveConfig()

	quickTapBlocked[movedButton] = true
	task.delay(0.2, function()
	quickTapBlocked[movedButton] = nil
	end)
	end
	end
	end))

	local function connectQuickButton(button, callback)
	button.Activated:Connect(function()
	if quickTapBlocked[button] then
	quickTapBlocked[button] = nil
	return
	end
	callback()
	end)
	end
	connectQuickButton(aimbotButton, function() toggleQuickFeature("Aimbot") end)
	connectQuickButton(tpBatButton, function()
		if FeatureToggles["TP Bat"] then
			pcall(FeatureToggles["TP Bat"])
		else
			toggleQuickFeature("TP Bat")
		end
	end)
	connectQuickButton(tpDownButton, function()
	if FeatureToggles["TP Down"] then pcall(FeatureToggles["TP Down"]) end
	end)
	connectQuickButton(dropButton, function()
	if FeatureToggles["Drop"] then pcall(FeatureToggles["Drop"], "button") end
	end)
	local function toggleCarryQuick()

	if carrySpeedMode == "v2" then
	speedToggled = not speedToggled
	setActivePairManualChoice(speedToggled)
	toggleStates["Carry Speed"] = speedToggled

	toggleStates["Speed Boost"] = true
	if _G.__refreshSpeedBoost then pcall(_G.__refreshSpeedBoost) end
	if toggleVisualUpdaters["Carry Speed"] then toggleVisualUpdaters["Carry Speed"]() end
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	saveConfig()
	elseif FeatureToggles["Carry Speed"] then
	pcall(FeatureToggles["Carry Speed"])
	else
	toggleQuickFeature("Carry Speed")
	end
		end
	connectQuickButton(carrySpeedButton, toggleCarryQuick)
	connectQuickButton(speedModeButton, function()
	-- Lagger Mode and Carry Speed are mutually exclusive quick modes.
	if toggleStates["Carry Speed"] == true then
		toggleCarryQuick()
	end
	if selectedMode == "Lagger" then
		selectMode("Normal")
	else
		selectMode("Lagger")
	end
	end)
	-- Auto Left / Auto Right: Clean Hub logic. Walk to point 1, then point 2, stop, face the base.
	local sideRun = { conn = nil, side = nil, phase = 1 }
	local SIDE_AP = {
		left = {
			p1 = Vector3.new(-476.48, -6.28, 92.73),
			p2 = Vector3.new(-483.12, -4.95, 94.80),
			face = Vector3.new(-482.25, -4.96, 92.09),
		},
		right = {
			p1 = Vector3.new(-476.16, -6.52, 25.62),
			p2 = Vector3.new(-483.06, -5.03, 25.48),
			face = Vector3.new(-482.06, -6.93, 35.47),
		},
	}
	local function stopSideRun()
		local conn = sideRun.conn
		if conn then pcall(function() conn:Disconnect() end) end
		sideRun.conn, sideRun.side, sideRun.phase = nil, nil, 1
		_G.__CrystalSideRun = nil
		_G.__CrystalSideRunActive = false
		if not toggleStates["Autoplay"] then _G.__CrystalForceAutoplaySide = nil end
		local char = Player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then pcall(function() hum:Move(Vector3.zero, false) end) end
	end
	local function startSideRun(side)
		stopSideRun()
		local pts = SIDE_AP[side]
		if not pts then return end
		pcall(function() if _G.__stopAutoplay then _G.__stopAutoplay() end end)
		pcall(function() if _G.__deactivateBatExclusive then _G.__deactivateBatExclusive("AutoSide") end end)
		if toggleStates["TP Bat"] and _G.CrystalAutoBat then pcall(function() _G.CrystalAutoBat.SetEnabled(false) end) end
		sideRun.side, sideRun.phase = side, 1
		_G.__CrystalSideRun = side
		_G.__CrystalSideRunActive = true
		_G.__CrystalForceAutoplaySide = side
		pcall(function()
				local c0 = Player.Character
				local r0 = c0 and c0:FindFirstChild("HumanoidRootPart")
				if r0 then r0:SetNetworkOwner(Player) end
			end)
			sideRun.conn = RunService.Heartbeat:Connect(function(dt)
			local char = Player.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if not root or not hum or hum.Health <= 0 then stopSideRun(); return end
			local state = hum:GetState()
			if hum.PlatformStand or state == Enum.HumanoidStateType.Physics
				or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
				stopSideRun(); return
			end
			local speed = math.max(1, tonumber(speedValues.NormalBoost) or 60)
			local target = (sideRun.phase == 1) and pts.p1 or pts.p2
			local flat = Vector3.new(target.X - root.Position.X, 0, target.Z - root.Position.Z)
			if flat.Magnitude < 1.5 then
				if sideRun.phase == 1 then
					sideRun.phase = 2
					target = pts.p2
					flat = Vector3.new(target.X - root.Position.X, 0, target.Z - root.Position.Z)
				else
					root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
					root.AssemblyAngularVelocity = Vector3.zero
					local facePos = Vector3.new(pts.face.X, root.Position.Y, pts.face.Z)
					stopSideRun()
					if (facePos - root.Position).Magnitude > 0.01 then
						-- rotation only, keep position so server doesn't snap us back
						root.CFrame = CFrame.lookAt(root.Position, facePos)
					end
					return
				end
			end
			if flat.Magnitude < 0.001 then return end
			local move = flat.Unit
			-- clamp so we never overshoot the waypoint in one frame (prevents oscillation/rubberband)
			local step = math.max(dt or 1/60, 1/240)
			speed = math.min(speed, flat.Magnitude / step)
			root.AssemblyLinearVelocity = Vector3.new(move.X * speed, root.AssemblyLinearVelocity.Y, move.Z * speed)
		end)
	end
	_G.__CrystalTrackStopper(stopSideRun)
	_G.__CrystalTrackConn(Player.CharacterRemoving:Connect(stopSideRun))
	local function autoplaySideQuick(side)
		if sideRun.side == side then stopSideRun() else startSideRun(side) end
	end
	connectQuickButton(autoLeftButton, function() autoplaySideQuick("left") end)
	connectQuickButton(autoRightButton, function() autoplaySideQuick("right") end)
	connectQuickButton(instaResetButton, function()
	if FeatureToggles["Insta Reset"] then pcall(FeatureToggles["Insta Reset"]) end
	end)
	connectQuickButton(laggerCarryButton, function()
	if toggleStates["Carry Speed"] == true then
		toggleCarryQuick()
		if selectedMode == "Lagger" then selectMode("Normal") end
	else
		-- Lagger Carry replaces Lagger Mode instead of leaving both active.
		if selectedMode == "Lagger" then selectMode("Normal") end
		toggleCarryQuick()
	end
	end)
	_G.__CrystalAutoplaySideToggle = autoplaySideQuick
	connectQuickButton(quickTapBlocked.custom.button, function()
	local customSpeed = quickTapBlocked.custom.getSelected()
	if customSpeed and selectedMode ~= customSpeed.name then
	selectMode(customSpeed.name)
	end
	end)
	local quickUpdateAccumulator = 0
	local quickLast = {}
	_G.__CrystalRefreshQuickButtonTheme = function()
		quickLast = {}
	end
	_G.__CrystalTrackConn(RunService.Heartbeat:Connect((function(dt)
	quickUpdateAccumulator = quickUpdateAccumulator + (dt or 0)
	if quickUpdateAccumulator < 0.03 then return end
	quickUpdateAccumulator = 0
	local showButtons = toggleStates["Show Buttons"] == true
	if quickLast.show ~= showButtons then quickButtons.Visible = showButtons; quickLast.show = showButtons end
	do
		local bgKey = quickBgThemeKey() .. ":" .. tostring(_G.__CrystalQuickBgIndex) .. ":" .. tostring(_G.__CrystalButtonsShape) .. ":" .. tostring(_G.__CrystalQuickPanel)
			.. ":" .. tostring(_G["_SoundHub_UI_BgIndex"]) .. ":" .. tostring(_G["_SoundHub_UI_HalloweenBgIndex"])
		do
			local okA, accNow = pcall(quickAccent)
			local ak = okA and tostring(accNow) or "x"
			if quickLast.accentKey ~= ak then quickLast = {}; quickLast.accentKey = ak end
		end
		if bgKey ~= quickBgKeyLast then applyQuickBg() end
		updateQuickPanel()
	end
	if not showButtons then return end
	-- Per-button show/hide from Buttons panel
	do
		local hidden = type(_G.__CrystalHiddenQuickButtons) == "table" and _G.__CrystalHiddenQuickButtons or {}
		local map = {
			["AUTO LEFT"] = autoLeftButton,
			["AUTO RIGHT"] = autoRightButton,
			["TP BAT"] = tpBatButton,
			["BAT AIMBOT"] = aimbotButton,
			["DROP"] = dropButton,
			["TP DOWN"] = tpDownButton,
			["LAGGER MODE"] = speedModeButton,
			["LAGGER CARRY"] = laggerCarryButton,
			["INSTA RESET"] = instaResetButton,
			["CARRY MODE"] = carrySpeedButton,
			["AUTO PLAY"] = autoplayButton,
			["CUSTOM SPEED"] = quickTapBlocked.custom.button,
		}
		for label, btn in pairs(map) do
			if btn and btn.Parent then
				local want = hidden[label] ~= true
				-- AUTO PLAY / CUSTOM SPEED stay force-hidden by design unless user unhides
				if label == "AUTO PLAY" or label == "CUSTOM SPEED" then want = false end
				if btn.Visible ~= want then btn.Visible = want end
			end
		end
	end
	local aimbotActive = toggleStates["Aimbot"] == true
	local carryActive = toggleStates["Carry Speed"] == true
	local autoplayIsActive = toggleStates["Autoplay"] == true
	local activeCustomSpeed = quickTapBlocked.custom.getByName(selectedMode)
	local quickCustomSpeed = activeCustomSpeed or quickTapBlocked.custom.getSelected()
	if quickLast.carryVisible ~= true then carrySpeedButton.Visible = true; quickLast.carryVisible = true end
	if quickLast.aimbot ~= aimbotActive then setQuickVisual(aimbotButton, aimbotStroke, aimbotActive); quickLast.aimbot = aimbotActive end
	local tpBatActive = toggleStates["TP Bat"] == true
	if quickLast.tpBat ~= tpBatActive then setQuickVisual(tpBatButton, tpBatStroke, tpBatActive); quickLast.tpBat = tpBatActive end
	if quickLast.carry ~= carryActive then setQuickVisual(carrySpeedButton, carrySpeedStroke, carryActive); quickLast.carry = carryActive end
	if quickLast.autoplay ~= autoplayIsActive then setQuickVisual(autoplayButton, autoplayStroke, autoplayIsActive); quickLast.autoplay = autoplayIsActive end
	local forcedSide = _G.__CrystalSideRun
	local leftActive, rightActive = forcedSide == "left", forcedSide == "right"
	if quickLast.autoLeft ~= leftActive then setQuickVisual(autoLeftButton, autoLeftStroke, leftActive); quickLast.autoLeft = leftActive end
	if quickLast.autoRight ~= rightActive then setQuickVisual(autoRightButton, autoRightStroke, rightActive); quickLast.autoRight = rightActive end
	local laggerCarryActive = selectedMode == "Lagger" and carryActive
	if quickLast.laggerCarry ~= laggerCarryActive then setQuickVisual(laggerCarryButton, laggerCarryStroke, laggerCarryActive); quickLast.laggerCarry = laggerCarryActive end
	local customSpeedName = quickCustomSpeed and quickCustomSpeed.name or nil
	if quickLast.customName ~= customSpeedName or quickLast.customActive ~= (activeCustomSpeed ~= nil) then
	quickTapBlocked.custom.button.Text = customSpeedName and ("CUSTOM\n" .. string.upper(customSpeedName)) or "NO CUSTOM"
	setQuickVisual(quickTapBlocked.custom.button, quickTapBlocked.custom.stroke, activeCustomSpeed ~= nil)
	quickLast.customName = customSpeedName
	quickLast.customActive = activeCustomSpeed ~= nil
	end
	local isLaggerSpeed = selectedMode == "Lagger"
	if quickLast.lagger ~= isLaggerSpeed then
	speedModeButton.Text = isLaggerSpeed and "NORMAL MODE" or "LAGGER MODE"
	setQuickVisual(speedModeButton, speedModeStroke, isLaggerSpeed)
	quickLast.lagger = isLaggerSpeed
	end
	if quickLast.actionsInitialized ~= true then
	setQuickVisual(tpDownButton, tpDownStroke, false)
	setQuickVisual(dropButton, dropStroke, false)
	setQuickVisual(instaResetButton, instaResetStroke, false)
	quickLast.actionsInitialized = true
	end
	end)))
	end)()

	do
	local panelsSection = makeUraniumSection(tabPages.Visuals, "PANELS")
	local panelsPanel = Instance.new("Frame", panelsSection)
	panelsPanel.Size = UDim2.new(1, -10, 0, 58)
	panelsPanel.Position = UDim2.new(0, 5, 0, 28)
	panelsPanel.BackgroundColor3 = Color3.fromRGB(20, 22, 31)
	panelsPanel.BackgroundTransparency = 0.12
	panelsPanel.BorderSizePixel = 0
	Instance.new("UICorner", panelsPanel).CornerRadius = UDim.new(0, 8)
	local panelsPanelStroke = Instance.new("UIStroke", panelsPanel)
	panelsPanelStroke.Color = Color3.fromRGB(0, 0, 0)
	panelsPanelStroke.Thickness = 1.2
	panelsPanelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	panelsPanelStroke.Transparency = 0.15

	(function()
	-- ============================================================
	-- ANIMATION PACKS (Clean hub logic)
	-- Heartbeat rewrites Animate AnimationIds; "Off" restores originals.
	-- Packs: Off, Zombie, Ninja, Knight, Elder, Levitate, Astronaut,
	--        Pirate, Toy, Vampire, Werewolf, Rthro, Stylish
	-- ============================================================

	local ANIM_PACKS = {
		["Zombie"] = { idle1="rbxassetid://616158929", idle2="rbxassetid://616160636", walk="rbxassetid://616168032", run="rbxassetid://616163682", jump="rbxassetid://616161997", fall="rbxassetid://616157476", climb="rbxassetid://616156119", swim="rbxassetid://616165109", swimidle="rbxassetid://616166655" },
		["Ninja"] = { idle1="rbxassetid://656117400", idle2="rbxassetid://656117400", walk="rbxassetid://656121766", run="rbxassetid://656118852", jump="rbxassetid://656117878", fall="rbxassetid://656115606", climb="rbxassetid://656114359", swim="rbxassetid://656117400", swimidle="rbxassetid://656117400" },
		["Knight"] = { idle1="rbxassetid://657595757", idle2="rbxassetid://657595757", walk="rbxassetid://657552124", run="rbxassetid://657564596", jump="rbxassetid://658409194", fall="rbxassetid://657600338", climb="rbxassetid://658360781", swim="rbxassetid://657595757", swimidle="rbxassetid://657595757" },
		["Elder"] = { idle1="rbxassetid://845397899", idle2="rbxassetid://845397899", walk="rbxassetid://845403856", run="rbxassetid://845386501", jump="rbxassetid://845398858", fall="rbxassetid://845397673", climb="rbxassetid://845392038", swim="rbxassetid://845397899", swimidle="rbxassetid://845397899" },
		["Levitate"] = { idle1="rbxassetid://616006778", idle2="rbxassetid://616006778", walk="rbxassetid://616013216", run="rbxassetid://616013216", jump="rbxassetid://616008936", fall="rbxassetid://616005863", climb="rbxassetid://616003713", swim="rbxassetid://616006778", swimidle="rbxassetid://616006778" },
		["Astronaut"] = { idle1="rbxassetid://891621366", idle2="rbxassetid://891621366", walk="rbxassetid://891636393", run="rbxassetid://891636393", jump="rbxassetid://891627522", fall="rbxassetid://891617961", climb="rbxassetid://891609353", swim="rbxassetid://891621366", swimidle="rbxassetid://891621366" },
		["Pirate"] = { idle1="rbxassetid://750781874", idle2="rbxassetid://750781874", walk="rbxassetid://750785693", run="rbxassetid://750783738", jump="rbxassetid://750782230", fall="rbxassetid://750780242", climb="rbxassetid://750779899", swim="rbxassetid://750781874", swimidle="rbxassetid://750781874" },
		["Toy"] = { idle1="rbxassetid://782841498", idle2="rbxassetid://782841498", walk="rbxassetid://782843345", run="rbxassetid://782842708", jump="rbxassetid://782847020", fall="rbxassetid://782846423", climb="rbxassetid://782843869", swim="rbxassetid://782841498", swimidle="rbxassetid://782841498" },
		["Vampire"] = { idle1="rbxassetid://1083445855", idle2="rbxassetid://1083445855", walk="rbxassetid://1083473930", run="rbxassetid://1083462077", jump="rbxassetid://1083455352", fall="rbxassetid://1083443587", climb="rbxassetid://1083439238", swim="rbxassetid://1083445855", swimidle="rbxassetid://1083445855" },
		["Werewolf"] = { idle1="rbxassetid://1083195517", idle2="rbxassetid://1083195517", walk="rbxassetid://1083178339", run="rbxassetid://1083216690", jump="rbxassetid://1083218792", fall="rbxassetid://1083189019", climb="rbxassetid://1083182000", swim="rbxassetid://1083195517", swimidle="rbxassetid://1083195517" },
		["Rthro"] = { idle1="rbxassetid://2510196951", idle2="rbxassetid://2510196951", walk="rbxassetid://2510202577", run="rbxassetid://2510198475", jump="rbxassetid://2510197830", fall="rbxassetid://2510195892", climb="rbxassetid://2510192778", swim="rbxassetid://2510196951", swimidle="rbxassetid://2510196951" },
		["Stylish"] = { idle1="rbxassetid://616136790", idle2="rbxassetid://616136790", walk="rbxassetid://616146177", run="rbxassetid://616140816", jump="rbxassetid://616139451", fall="rbxassetid://616134815", climb="rbxassetid://616133594", swim="rbxassetid://616136790", swimidle="rbxassetid://616136790" },
	}

	local ANIM_PACK_ORDER = {
		"Off", "Zombie", "Ninja", "Knight", "Elder", "Levitate", "Astronaut",
		"Pirate", "Toy", "Vampire", "Werewolf", "Rthro", "Stylish",
	}

	local currentAnimPack = "Off"
	do
		local saved = tostring(_G.__CrystalAnimationPreset or _G.__CrystalAnimationPackPreset or "")
		if ANIM_PACKS[saved] then
			currentAnimPack = saved
		elseif saved == "Off" or saved == "NONE" or saved == "none" or saved == "" then
			currentAnimPack = "Off"
		end
	end
	_G.__CrystalAnimationPackPreset = currentAnimPack
	_G.__CrystalAnimationPackIndex = 1
	for i, name in ipairs(ANIM_PACK_ORDER) do
		if name == currentAnimPack then
			_G.__CrystalAnimationPackIndex = i
			break
		end
	end

	local originalTryardAnims = nil
	local tryardHeartbeatConn = nil
	local animSelectorLabel = nil
	local setAnimPackVisual = nil

	local function isPackAnim(id)
		if not id then return false end
		for _, pack in pairs(ANIM_PACKS) do
			for _, v in pairs(pack) do
				if v == id then return true end
			end
		end
		return false
	end

	local function saveOriginalAnims(char)
		if not char then return end
		local animate = char:FindFirstChild("Animate")
		if not animate then return end
		local function g(obj) return obj and obj.AnimationId or nil end
		local ids = {
			idle1 = g(animate.idle and animate.idle.Animation1),
			idle2 = g(animate.idle and animate.idle.Animation2),
			walk  = g(animate.walk and animate.walk.WalkAnim),
			run   = g(animate.run  and animate.run.RunAnim),
			jump  = g(animate.jump and animate.jump.JumpAnim),
			fall  = g(animate.fall and animate.fall.FallAnim),
			climb = g(animate.climb and animate.climb.ClimbAnim),
			swim  = g(animate.swim and animate.swim.Swim),
			swimidle = g(animate.swimidle and animate.swimidle.SwimIdle),
		}
		if not isPackAnim(ids.walk) then
			originalTryardAnims = ids
		end
	end

	local function writePackIds(animate, pack)
		if not animate or not pack then return end
		local function s(obj, id)
			if obj and id then pcall(function() obj.AnimationId = id end) end
		end
		s(animate:FindFirstChild("idle") and animate.idle:FindFirstChild("Animation1"), pack.idle1)
		s(animate:FindFirstChild("idle") and animate.idle:FindFirstChild("Animation2"), pack.idle2)
		s(animate:FindFirstChild("walk") and animate.walk:FindFirstChild("WalkAnim"), pack.walk)
		s(animate:FindFirstChild("run") and animate.run:FindFirstChild("RunAnim"), pack.run)
		s(animate:FindFirstChild("jump") and animate.jump:FindFirstChild("JumpAnim"), pack.jump)
		s(animate:FindFirstChild("fall") and animate.fall:FindFirstChild("FallAnim"), pack.fall)
		s(animate:FindFirstChild("climb") and animate.climb:FindFirstChild("ClimbAnim"), pack.climb)
		s(animate:FindFirstChild("swim") and animate.swim:FindFirstChild("Swim"), pack.swim)
		s(animate:FindFirstChild("swimidle") and animate.swimidle:FindFirstChild("SwimIdle"), pack.swimidle)
		-- Also walk any Animation objects under Animate (some games rename slots)
		for _, d in ipairs(animate:GetDescendants()) do
			if d:IsA("Animation") then
				local n = d.Name
				if n == "Animation1" and pack.idle1 then pcall(function() d.AnimationId = pack.idle1 end)
				elseif n == "Animation2" and pack.idle2 then pcall(function() d.AnimationId = pack.idle2 end)
				elseif n == "WalkAnim" and pack.walk then pcall(function() d.AnimationId = pack.walk end)
				elseif n == "RunAnim" and pack.run then pcall(function() d.AnimationId = pack.run end)
				elseif n == "JumpAnim" and pack.jump then pcall(function() d.AnimationId = pack.jump end)
				elseif n == "FallAnim" and pack.fall then pcall(function() d.AnimationId = pack.fall end)
				elseif n == "ClimbAnim" and pack.climb then pcall(function() d.AnimationId = pack.climb end)
				elseif n == "Swim" and pack.swim then pcall(function() d.AnimationId = pack.swim end)
				elseif n == "SwimIdle" and pack.swimidle then pcall(function() d.AnimationId = pack.swimidle end)
				end
			end
		end
	end

	local function forceRefreshAnims(char)
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hum then return end
		for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
			pcall(function() track:Stop(0) end)
		end
		-- Nudge Animate so it reloads the new AnimationIds
		local animate = char:FindFirstChild("Animate")
		if animate then
			pcall(function()
				animate.Disabled = true
				task.defer(function()
					if animate and animate.Parent then animate.Disabled = false end
				end)
			end)
		end
		pcall(function()
			if hum:GetState() ~= Enum.HumanoidStateType.Dead then
				hum:ChangeState(Enum.HumanoidStateType.Running)
			end
		end)
	end

	local function applyAnimPack(packName)
		currentAnimPack = packName or "Off"
		_G.__CrystalAnimationPackPreset = currentAnimPack
		_G.__CrystalAnimationPreset = currentAnimPack
		if animSelectorLabel then animSelectorLabel.Text = currentAnimPack end
		if setAnimPackVisual then pcall(setAnimPackVisual, currentAnimPack) end

		if tryardHeartbeatConn then
			pcall(function() tryardHeartbeatConn:Disconnect() end)
			tryardHeartbeatConn = nil
		end

		local char = Player.Character
		local animate = char and char:FindFirstChild("Animate")

		if currentAnimPack == "Off" then
			if originalTryardAnims and animate then
				writePackIds(animate, originalTryardAnims)
				forceRefreshAnims(char)
			end
			return
		end

		local pack = ANIM_PACKS[currentAnimPack]
		if not pack then return end

		-- Apply immediately once
		if animate then
			writePackIds(animate, pack)
			forceRefreshAnims(char)
		end

		-- Keep rewriting so server/default Animate cannot overwrite
		local packRef = pack
		local packNameRef = currentAnimPack
		tryardHeartbeatConn = RunService.Heartbeat:Connect(function()
			if currentAnimPack ~= packNameRef then return end
			local c = Player.Character
			if not c then return end
			local a = c:FindFirstChild("Animate")
			if not a then return end
			writePackIds(a, packRef)
		end)
		if type(_G.__CrystalTrackConn) == "function" then
			pcall(_G.__CrystalTrackConn, tryardHeartbeatConn)
		end
	end

	local function startAnimPack(packName)
		packName = tostring(packName or "Off")
		if packName ~= "Off" and not ANIM_PACKS[packName] then
			packName = "Off"
		end
		local char = Player.Character
		if char then
			saveOriginalAnims(char)
		end
		applyAnimPack(packName)
		currentAnimPack = packName
		_G.__CrystalAnimationPackPreset = packName
		for i, name in ipairs(ANIM_PACK_ORDER) do
			if name == packName then
				_G.__CrystalAnimationPackIndex = i
				break
			end
		end
		-- Second pass after Animate finishes loading (respawn / delayed children)
		task.delay(0.15, function()
			if currentAnimPack ~= packName then return end
			local c = Player.Character
			local a = c and c:FindFirstChild("Animate")
			local pack = ANIM_PACKS[packName]
			if a and pack then
				writePackIds(a, pack)
				forceRefreshAnims(c)
			end
		end)
		pcall(function() if type(saveConfig) == "function" then saveConfig() end end)
	end

	local function stopAnimPack()
		currentAnimPack = "Off"
		_G.__CrystalAnimationPackIndex = 1
		_G.__CrystalAnimationPackPreset = "Off"
		if animSelectorLabel then animSelectorLabel.Text = "Off" end
		applyAnimPack("Off")
		pcall(function() if type(saveConfig) == "function" then saveConfig() end end)
	end

	_G.__CrystalSetAnimPack = function(indexOrName)
		if type(indexOrName) == "number" then
			local idx = math.clamp(math.floor(indexOrName), 1, #ANIM_PACK_ORDER)
			local name = ANIM_PACK_ORDER[idx] or "Off"
			if name == "Off" then stopAnimPack() else startAnimPack(name) end
			return
		end
		local name = tostring(indexOrName or "Off")
		if name == "Off" or name == "NONE" or name == "none" or not ANIM_PACKS[name] then
			stopAnimPack()
		else
			startAnimPack(name)
		end
	end

	_G.__CrystalReloadCustomAnimPack = function() end

	-- Character respawn: re-apply active pack
	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(newChar)
		task.spawn(function()
			pcall(function() newChar:WaitForChild("Humanoid", 5) end)
			pcall(function() newChar:WaitForChild("Animate", 3) end)
			task.wait(0.3)
			if currentAnimPack and currentAnimPack ~= "Off" then
				startAnimPack(currentAnimPack)
			end
		end)
	end))

	-- Boot: apply saved pack
	if currentAnimPack ~= "Off" then
		local char = Player.Character
		if char then
			task.spawn(function()
				pcall(function() char:WaitForChild("Animate", 3) end)
				startAnimPack(currentAnimPack)
			end)
		end
	end

	-- ===================== UI (pack cycler) =====================
	local host = nil
	pcall(function()
		if animationsSection and animationsSection.Parent then host = animationsSection end
	end)
	if not host then
		pcall(function()
			if panelsPanel and panelsPanel.Parent then host = panelsPanel end
		end)
	end
	if host then
		local animSection = Instance.new("Frame")
		animSection.Name = "AnimPackSection"
		animSection.Size = UDim2.new(1, -10, 0, 70)
		animSection.BackgroundTransparency = 1
		animSection.Parent = host

		local titleLabel = Instance.new("TextLabel", animSection)
		titleLabel.Size = UDim2.new(1, -100, 0, 22)
		titleLabel.Position = UDim2.new(0, 50, 0, 6)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Text = currentAnimPack
		titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		titleLabel.Font = Enum.Font.GothamBold
		titleLabel.TextSize = 12
		titleLabel.TextXAlignment = Enum.TextXAlignment.Center
		animSelectorLabel = titleLabel

		local leftBtn = Instance.new("TextButton", animSection)
		leftBtn.Size = UDim2.new(0, 28, 0, 22)
		leftBtn.Position = UDim2.new(0, 8, 0, 6)
		leftBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
		leftBtn.Text = "<"
		leftBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		leftBtn.Font = Enum.Font.GothamBold
		leftBtn.TextSize = 12
		leftBtn.AutoButtonColor = false
		Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)

		local rightBtn = Instance.new("TextButton", animSection)
		rightBtn.Size = UDim2.new(0, 28, 0, 22)
		rightBtn.Position = UDim2.new(1, -36, 0, 6)
		rightBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
		rightBtn.Text = ">"
		rightBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		rightBtn.Font = Enum.Font.GothamBold
		rightBtn.TextSize = 12
		rightBtn.AutoButtonColor = false
		Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)

		local function changePreset(delta)
			local idx = 1
			for i, name in ipairs(ANIM_PACK_ORDER) do
				if name == currentAnimPack then idx = i; break end
			end
			local newIdx = idx + delta
			if newIdx < 1 then newIdx = #ANIM_PACK_ORDER end
			if newIdx > #ANIM_PACK_ORDER then newIdx = 1 end
			_G.__CrystalSetAnimPack(ANIM_PACK_ORDER[newIdx])
			titleLabel.Text = ANIM_PACK_ORDER[newIdx]
		end

		leftBtn.MouseButton1Click:Connect(function() changePreset(-1) end)
		rightBtn.MouseButton1Click:Connect(function() changePreset(1) end)

		local toggleBtn = Instance.new("TextButton", animSection)
		toggleBtn.Size = UDim2.new(0, 64, 0, 22)
		toggleBtn.Position = UDim2.new(0.5, -32, 0, 36)
		toggleBtn.BackgroundColor3 = (currentAnimPack ~= "Off") and Color3.fromRGB(82, 140, 220) or Color3.fromRGB(52, 58, 68)
		toggleBtn.Text = (currentAnimPack ~= "Off") and "ON" or "OFF"
		toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		toggleBtn.Font = Enum.Font.GothamBold
		toggleBtn.TextSize = 11
		toggleBtn.AutoButtonColor = false
		Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)

		toggleBtn.MouseButton1Click:Connect(function()
			if currentAnimPack ~= "Off" then
				stopAnimPack()
				toggleBtn.Text = "OFF"
				toggleBtn.BackgroundColor3 = Color3.fromRGB(52, 58, 68)
				titleLabel.Text = "Off"
			else
				startAnimPack("Zombie")
				toggleBtn.Text = "ON"
				toggleBtn.BackgroundColor3 = Color3.fromRGB(82, 140, 220)
				titleLabel.Text = "Zombie"
			end
		end)

		setAnimPackVisual = function(name)
			titleLabel.Text = tostring(name or currentAnimPack)
			local on = (tostring(name or currentAnimPack) ~= "Off")
			toggleBtn.Text = on and "ON" or "OFF"
			toggleBtn.BackgroundColor3 = on and Color3.fromRGB(82, 140, 220) or Color3.fromRGB(52, 58, 68)
		end
	end
	end)()

	-- Named Sound animations are applied by the Visual Animations toggle / CharacterAdded.
	-- Do not force Ambitious pack indices over named presets.





	local toggleUiRow = Instance.new("Frame", panelsPanel)
	toggleUiRow.Size = UDim2.new(1, -18, 0, 28)
	toggleUiRow.Position = UDim2.new(0, 9, 0, 10)
	toggleUiRow.BackgroundTransparency = 1
	toggleUiRow.Visible = true
	local toggleUiLabel = Instance.new("TextLabel", toggleUiRow)
	toggleUiLabel.Size = UDim2.new(1, -50, 0, 32)
	toggleUiLabel.Position = UDim2.new(0, 0, 0, 2)
	toggleUiLabel.BackgroundTransparency = 1
	toggleUiLabel.Text = "Toggle UI"
	toggleUiLabel.TextColor3 = Color3.fromRGB(40, 80, 150)
	toggleUiLabel.TextSize = 10
	toggleUiLabel.Font = Enum.Font.GothamBold
	toggleUiLabel.TextXAlignment = Enum.TextXAlignment.Left
	toggleUiLabel.TextYAlignment = Enum.TextYAlignment.Center

	local toggleUiBindBtn = Instance.new("TextButton", toggleUiRow)
	toggleUiBindBtn.Size = UDim2.new(0, 40, 0, 20)
	toggleUiBindBtn.Position = UDim2.new(1, -48, 0.5, -10)
	toggleUiBindBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	toggleUiBindBtn.BackgroundTransparency = 0.15
	toggleUiBindBtn.BorderSizePixel = 0
	toggleUiBindBtn.Text = FeatureKeybinds["Toggle UI"] and keybindDisplayName(FeatureKeybinds["Toggle UI"]) or "-"
	toggleUiBindBtn.TextColor3 = Color3.fromRGB(225,238,255)
	toggleUiBindBtn.TextSize = 9
	toggleUiBindBtn.Font = Enum.Font.GothamBold
	toggleUiBindBtn.AutoButtonColor = false
	Instance.new("UICorner", toggleUiBindBtn).CornerRadius = UDim.new(0, 4)
	local toggleUiStroke = Instance.new("UIStroke", toggleUiBindBtn)
	toggleUiStroke.Color = Color3.fromRGB(255,255,255)
	toggleUiStroke.Thickness = 1
	toggleUiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	connectBtn(toggleUiBindBtn, function()
	if listeningBindBtn then
	listeningBindBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	listeningBindBtn.BackgroundTransparency = 1
	listeningBindBtn.Text = "-"
	end
	listeningBindBtn = toggleUiBindBtn
	listeningFeature = "Toggle UI"
	toggleUiBindBtn.Text = "..."
	toggleUiBindBtn.BackgroundColor3 = Color3.fromRGB(4, 18, 42)
	toggleUiBindBtn.BackgroundTransparency = 0
	end)

	table.insert(_allBindBtns, toggleUiBindBtn); if _G.__CrystalRealMobile then toggleUiBindBtn.Visible = false end
	if toggleVisualUpdaters["Toggle UI"] == nil then
	toggleVisualUpdaters["Toggle UI"] = function()
	toggleUiBindBtn.Text = FeatureKeybinds["Toggle UI"] and keybindDisplayName(FeatureKeybinds["Toggle UI"]) or "-"
	toggleUiBindBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	toggleUiBindBtn.BackgroundTransparency = 0.15
	toggleUiBindBtn.TextColor3 = Color3.fromRGB(225,238,255)
	end
	end

	end

	local animationsSection = makeUraniumSection(tabPages.Visuals, "ANIMATIONS")
	local animationPresetOrder = {
	"Adidas Sports",
	"Adidas Community",
	"Adidas Aura",
	"Wicked Popular",
	"Elder",
	"Zombie",
	"Mage",
	"Catwalk Glam",
	"Astronaut",
	'Wicked "Dancing Through Life"',
	"Werewolf",
	"Superhero",
	"Toy",
	"No Boundaries",
	"NFL",
	"Amazon Unboxed",
	"Vampire",
	"Ninja",
	"Robot",
	"Levitation",
	"Stylish",
	"Bubbly",
	"Cartoon",
	}
	local animationPresets = {
	["Adidas Sports"]               = {WalkAnim=18537392113, RunAnim=18537384940, JumpAnim=18537380791, FallAnim=18537367238, SwimIdle=18537387180, Swim=18537389531, Animation1=18537376492, Animation2=18537371272, ClimbAnim=18537363391},
	["Adidas Community"]            = {WalkAnim=122150855457006, RunAnim=82598234841035, JumpAnim=75290611992385, FallAnim=98600215928904, SwimIdle=109346520324160, Swim=133308483266208, Animation1=122257458498464, Animation2=102357151005774, ClimbAnim=88763136693023},
	["Adidas Aura"]                 = {WalkAnim=83842218823011, RunAnim=118320322718866, JumpAnim=109996626521204, FallAnim=95603166884636, SwimIdle=94922130551805, Swim=134530128383903, Animation1=110211186840347, Animation2=114191137265065, ClimbAnim=97824616490448},
	["Wicked Popular"]              = {WalkAnim=92072849924640, RunAnim=72301599441680, JumpAnim=104325245285198, FallAnim=121152442762481, Animation1=118832222982049, ClimbAnim=131326830509784, SwimIdle=113199415118199, Swim=99384245425157, Animation2=76049494037641},
	["Elder"]                       = {WalkAnim=10921111375, RunAnim=10921104374, JumpAnim=10921107367, FallAnim=10921105765, SwimIdle=10921110146, Swim=10921108971, ClimbAnim=10921100400, Animation1=10921101664, Animation2=10921102574},
	["Zombie"]                      = {WalkAnim=10921355261, RunAnim=616163682, JumpAnim=10921351278, FallAnim=10921350320, SwimIdle=10921353442, Swim=10921352344, Animation1=10921344533, Animation2=10921345304, ClimbAnim=10921343576},
	["Mage"]                        = {WalkAnim=10921152678, RunAnim=10921148209, JumpAnim=10921149743, FallAnim=10921148939, SwimIdle=10921151661, Swim=10921150788, ClimbAnim=10921143404, Animation1=10921144709, Animation2=10921145797},
	["Catwalk Glam"]                = {WalkAnim=109168724482748, RunAnim=81024476153754, JumpAnim=116936326516985, FallAnim=92294537340807, SwimIdle=98854111361360, Swim=134591743181628, ClimbAnim=119377220967554, Animation1=133806214992291, Animation2=94970088341563},
	["Astronaut"]                   = {WalkAnim=10921046031, RunAnim=10921039308, JumpAnim=10921042494, FallAnim=10921040576, SwimIdle=10921045006, Swim=10921044000, ClimbAnim=10921032124, Animation1=10921034824, Animation2=10921036806},
	["Wicked \"Dancing Through Life\""] = {WalkAnim=73718308412641, RunAnim=135515454877967, JumpAnim=78508480717326, FallAnim=78147885297412, SwimIdle=129183123083281, Swim=110657013921774, ClimbAnim=129447497744818, Animation1=92849173543269, Animation2=132238900951109},
	["Werewolf"]                    = {WalkAnim=10921342074, RunAnim=10921336997, FallAnim=10921337907, SwimIdle=10921341319, Swim=10921340419, ClimbAnim=10921329322, Animation1=10921330408, Animation2=10921333667},
	["Superhero"]                   = {WalkAnim=10921298616, RunAnim=10921291831, JumpAnim=10921294559, FallAnim=10921293373, SwimIdle=10921297391, Swim=10921295495, ClimbAnim=10921286911, Animation1=10921288909, Animation2=10921290167},
	["Toy"]                         = {WalkAnim=10921312010, RunAnim=10921306285, JumpAnim=10921308158, FallAnim=10921307241, SwimIdle=10921310341, Swim=10921309319, ClimbAnim=10921300839, Animation1=10921301576},
	["No Boundaries"]               = {WalkAnim=18747074203, RunAnim=18747070484, JumpAnim=18747069148, FallAnim=18747062535, SwimIdle=18747071682, Swim=18747073181, ClimbAnim=18747060903, Animation1=18747067405, Animation2=18747063918},
	["NFL"]                         = {WalkAnim=110358958299415, RunAnim=117333533048078, JumpAnim=119846112151352, FallAnim=129773241321032, SwimIdle=79090109939093, Swim=132697394189921, ClimbAnim=134630013742019, Animation1=92080889861410, Animation2=74451233229259},
	["Amazon Unboxed"]              = {WalkAnim=90478085024465, RunAnim=134824450619865, JumpAnim=121454505477205, FallAnim=94788218468396, SwimIdle=129126268464847, Swim=105962919001086, ClimbAnim=121145883950231, Animation1=98281136301627},
	["Vampire"]                     = {WalkAnim=10921326949, RunAnim=10921320299, JumpAnim=10921322186, FallAnim=10921321317, SwimIdle=10921325443, Swim=10921324408, ClimbAnim=10921314188, Animation1=10921315373},
	["Ninja"]                       = {RunAnim=656118852, WalkAnim=656121766, JumpAnim=656117878, FallAnim=656115606, Swim=656119721, SwimIdle=656121397, ClimbAnim=656114359, Idle={656117400,656118341,886742569}},
	["Robot"]                       = {RunAnim=616091570, WalkAnim=616095330, JumpAnim=616090535, FallAnim=616087089, Swim=616092998, SwimIdle=616094091, ClimbAnim=616086039, Idle={616088211,616089559,885531463}},
	["Levitation"]                  = {RunAnim=616010382, WalkAnim=616013216, JumpAnim=616008936, FallAnim=616005863, Swim=616011509, SwimIdle=616012453, ClimbAnim=616003713, Idle={616006778,616008087,886862142}},
	["Stylish"]                     = {RunAnim=616140816, WalkAnim=616146177, JumpAnim=616139451, FallAnim=616134815, Swim=616143378, SwimIdle=616144772, ClimbAnim=616133594, Idle={616136790,616138447,886888594}},
	["Bubbly"]                      = {RunAnim=910025107, WalkAnim=910034870, JumpAnim=910016857, FallAnim=910001910, Swim=910028158, SwimIdle=910030921, ClimbAnim=909997997, Idle={910004836,910009958,1018536639}},
	["Cartoon"]                     = {RunAnim=742638842, WalkAnim=742640026, JumpAnim=742637942, FallAnim=742637151, Swim=742639220, SwimIdle=742639812, ClimbAnim=742636889, Idle={742637544,742638445,885477856}},
	}
	_G.__SoundNamedAnimationPresets = animationPresets
	_G.__SoundNamedAnimationOrder = animationPresetOrder

	local animationPropertyOrder = {"idle1", "idle2", "walk", "run", "jump", "fall", "climb", "swim", "swimidle"}
	local animationPropertyLabels = {
	idle1 = "Idle 1",
	idle2 = "Idle 2",
	walk = "Walk",
	run = "Run",
	jump = "Jump",
	fall = "Fall",
	climb = "Climb",
	swim = "Swim",
	swimidle = "Swim Idle",
	}
	local function normalizeAnimValue(value)
	if not value then return nil end
	if type(value) == "number" then
	return "rbxassetid://" .. tostring(value)
	end
	if type(value) == "string" then
	local trimmed = string.gsub(value, "^%s+", "")
	trimmed = string.gsub(trimmed, "%s+$", "")
	if trimmed == "" then return nil end
	if string.sub(trimmed, 1, 11) == "rbxassetid://" then return trimmed end
	if string.match(trimmed, "^%d+$") then return "rbxassetid://" .. trimmed end
	return trimmed
	end
	return nil
	end
	local function buildAnimPackFromPreset(preset)
	local idle = preset and preset.Idle
	return {
	idle1 = normalizeAnimValue(preset and (preset.Animation1 or (idle and idle[1]))),
	idle2 = normalizeAnimValue(preset and (preset.Animation2 or (idle and idle[2]))),
	walk = normalizeAnimValue(preset and (preset.WalkAnim or preset.Walk)),
	run = normalizeAnimValue(preset and (preset.RunAnim or preset.Run)),
	jump = normalizeAnimValue(preset and (preset.JumpAnim or preset.Jump)),
	fall = normalizeAnimValue(preset and (preset.FallAnim or preset.Fall)),
	climb = normalizeAnimValue(preset and (preset.ClimbAnim or preset.Climb)),
	swim = normalizeAnimValue(preset and (preset.Swim or preset.SwimAnim)),
	swimidle = normalizeAnimValue(preset and (preset.SwimIdle or preset.SwimIdleAnim)),
	}
	end
	local animationFieldRefs = {}
	local Anims = {
	idle1    = "rbxassetid://133806214992291",
	idle2    = "rbxassetid://94970088341563",
	walk     = "rbxassetid://707897309",
	run      = "rbxassetid://707861613",
	jump     = "rbxassetid://116936326516985",
	fall     = "rbxassetid://116936326516985",
	climb    = "rbxassetid://116936326516985",
	swim     = "rbxassetid://116936326516985",
	swimidle = "rbxassetid://116936326516985",
	}
	_G.__SoundHub_Anims = Anims

	-- Persist original Animate AnimationIds so packs can be restored cleanly.
	local _animOriginals = _G.__SoundUraniumAnimOriginals
	if type(_animOriginals) ~= "table" then
		_animOriginals = setmetatable({}, { __mode = "k" })
		_G.__SoundUraniumAnimOriginals = _animOriginals
	end
	local function getUraniumAnimTargets(character)
		if not character then return nil, nil end
		local animate = character:FindFirstChild("Animate")
		if not animate then return nil, nil end
		local idle = animate:FindFirstChild("idle")
		local walk = animate:FindFirstChild("walk")
		local run = animate:FindFirstChild("run")
		local jump = animate:FindFirstChild("jump")
		local fall = animate:FindFirstChild("fall")
		local climb = animate:FindFirstChild("climb")
		local swim = animate:FindFirstChild("swim")
		local swimIdle = animate:FindFirstChild("swimidle")
		local targets = {
			idle1 = idle and idle:FindFirstChild("Animation1"),
			idle2 = idle and idle:FindFirstChild("Animation2"),
			walk = walk and walk:FindFirstChild("WalkAnim"),
			run = run and run:FindFirstChild("RunAnim"),
			jump = jump and jump:FindFirstChild("JumpAnim"),
			fall = fall and fall:FindFirstChild("FallAnim"),
			climb = climb and climb:FindFirstChild("ClimbAnim"),
			swim = swim and swim:FindFirstChild("Swim"),
			swimidle = swimIdle and swimIdle:FindFirstChild("SwimIdle"),
		}
		return animate, targets
	end
	local function saveOriginalAnims(character)
		character = character or Player.Character
		if not character then return end
		local _, targets = getUraniumAnimTargets(character)
		if not targets then return end
		local saved = _animOriginals[character]
		if type(saved) ~= "table" then saved = {}; _animOriginals[character] = saved end
		for slot, target in pairs(targets) do
			if target and saved[slot] == nil then
				local ok, id = pcall(function() return target.AnimationId end)
				if ok then saved[slot] = id end
			end
		end
	end
	local function applyAnimPack(character)
		character = character or Player.Character
		if not character then return false end
		local animate, targets = getUraniumAnimTargets(character)
		if not targets then return false end
		saveOriginalAnims(character)
		-- Keep Animate enabled: we rewrite its AnimationIds (named-pack style).
		pcall(function() if animate then animate.Disabled = false end end)
		local values = {
			idle1 = Anims.idle1, idle2 = Anims.idle2,
			walk = Anims.walk, run = Anims.run,
			jump = Anims.jump, fall = Anims.fall,
			climb = Anims.climb, swim = Anims.swim, swimidle = Anims.swimidle,
		}
		for slot, id in pairs(values) do
			local target = targets[slot]
			if target and id and tostring(id) ~= "" then
				pcall(function() target.AnimationId = id end)
			end
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
				pcall(function() track:Stop(0) end)
			end
		end
		return true
	end
	local function restoreUraniumAnims(character)
		character = character or Player.Character
		if not character then return end
		local _, targets = getUraniumAnimTargets(character)
		if not targets then return end
		local saved = _animOriginals[character]
		if type(saved) == "table" then
			for slot, target in pairs(targets) do
				if target and saved[slot] ~= nil then
					pcall(function() target.AnimationId = saved[slot] end)
				end
			end
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
				pcall(function() track:Stop(0) end)
			end
		end
	end
	local animIdToName = {}
	local animNameToId = {}
	for presetName, preset in pairs(animationPresets) do
	local pack = buildAnimPackFromPreset(preset)
	for _, key in ipairs(animationPropertyOrder) do
	local id = pack[key]
	if id then
	local nm = presetName .. " " .. animationPropertyLabels[key]
	if not animNameToId[nm] then
	animNameToId[nm] = id
	animIdToName[id] = nm
	end
	end
	end
	end
	local function animDisplayName(id)
	if not id then return "" end
	if id == "rbxassetid://" then return "Custom" end
	return animIdToName[id] or id
	end
	local slotAnimationList = {}
	for _, key in ipairs(animationPropertyOrder) do slotAnimationList[key] = {} end
	for _, presetName in ipairs(animationPresetOrder) do
	local preset = animationPresets[presetName]
	if preset then
	local pack = buildAnimPackFromPreset(preset)
	for _, key in ipairs(animationPropertyOrder) do
	local id = pack[key]
	if id and not table.find(slotAnimationList[key], id) then
	table.insert(slotAnimationList[key], id)
	end
	end
	end
	end
	local function cycleSlotAnimation(key, box)
	local list = slotAnimationList[key]
	if not list or not box then return end
	local currentId = Anims[key]
	local nextIndex = 1
	for i, id in ipairs(list) do
	if id == currentId then
	nextIndex = i % #list + 1
	break
	end
	end
	Anims[key] = list[nextIndex]
	box.Text = animDisplayName(list[nextIndex])
	saveConfig()
	if toggleStates["Animations"] then
	local char = Player.Character
	if char then
	saveOriginalAnims(char)
	applyAnimPack(char)
	end
	end
	end
	local selectedAnimationPresetName = animationPresetOrder[1]
	do
		local saved = tostring(_G.__CrystalAnimationPreset or "")
		for _, name in ipairs(animationPresetOrder) do
			if name == saved then selectedAnimationPresetName = name break end
		end
	end
	local function applyAnimationPreset(name)
	local preset = animationPresets[name]
	if not preset then return end
	local pack = buildAnimPackFromPreset(preset)
	selectedAnimationPresetName = name
	_G.__CrystalAnimationPreset = name
	Anims.idle1 = pack.idle1 or Anims.idle1
	Anims.idle2 = pack.idle2 or Anims.idle2
	Anims.walk = pack.walk or Anims.walk
	Anims.run = pack.run or Anims.run
	Anims.jump = pack.jump or Anims.jump
	Anims.fall = pack.fall or Anims.fall
	Anims.climb = pack.climb or Anims.climb
	Anims.swim = pack.swim or Anims.swim
	Anims.swimidle = pack.swimidle or Anims.swimidle
	if toggleStates["Animations"] then
	local char = Player.Character
	if char then
	saveOriginalAnims(char)
	applyAnimPack(char)
	end
	end
	end
	local function loadAnimationPresetIntoFields(name)
	local preset = animationPresets[name]
	if not preset then return end
	local pack = buildAnimPackFromPreset(preset)
	for _, key in ipairs(animationPropertyOrder) do
	local box = animationFieldRefs[key]
	if box then
	local value = pack[key] or ""
	box.Text = animDisplayName(value)
	end
	end
	applyAnimationPreset(name)
	end
	makeToggleNoKeybind(animationsSection, "Animations (Master)", "Animations")
	FeaturePostToggle["Animations"] = function(active)
	active = active == true
	toggleStates["Animations"] = active
	if active then
		local char = Player.Character
		if char then
			saveOriginalAnims(char)
			applyAnimPack(char)
		end
	else
		restoreUraniumAnims(Player.Character)
	end
	saveConfig()
	end

	local presetButton = Instance.new("TextButton", animationsSection)
	presetButton.Size = UDim2.new(1, 0, 0, 34)
	presetButton.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
	presetButton.BorderSizePixel = 0
	presetButton.Text = "Preset: " .. selectedAnimationPresetName
	presetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	presetButton.TextSize = 11
	presetButton.Font = Enum.Font.GothamBold
	presetButton.AutoButtonColor = false
	Instance.new("UICorner", presetButton).CornerRadius = UDim.new(0, 8)
	connectBtn(presetButton, function()
	local currentIndex = 1
	for i, name in ipairs(animationPresetOrder) do
	if name == selectedAnimationPresetName then
	currentIndex = i
	break
	end
	end
	local nextIndex = currentIndex + 1
	if nextIndex > #animationPresetOrder then nextIndex = 1 end
	local nextName = animationPresetOrder[nextIndex]
	presetButton.Text = "Preset: " .. nextName
	loadAnimationPresetIntoFields(nextName)
	saveConfig()
	end)

	local fieldsContainer = Instance.new("Frame", animationsSection)
	fieldsContainer.Size = UDim2.new(1, -2, 0, 0)
	fieldsContainer.BackgroundTransparency = 1
	fieldsContainer.ClipsDescendants = false
	local fieldLayout = Instance.new("UIListLayout", fieldsContainer)
	fieldLayout.Padding = UDim.new(0, 6)
	fieldLayout.SortOrder = Enum.SortOrder.LayoutOrder
	fieldLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	fieldsContainer.Size = UDim2.new(1, -2, 0, fieldLayout.AbsoluteContentSize.Y)
	end)

	for _, key in ipairs(animationPropertyOrder) do
	local row = Instance.new("Frame", fieldsContainer)
	row.Size = UDim2.new(1, 0, 0, 30)
	row.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
	row.BackgroundTransparency = 0.25
	row.BorderSizePixel = 0
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(0.48, 0, 1, 0)
	label.Position = UDim2.new(0, 8, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = animationPropertyLabels[key]
	label.TextColor3 = Color3.fromRGB(220, 220, 230)
	label.TextSize = 11
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left

	local input = Instance.new("TextButton", row)
	input.Size = UDim2.new(0.5, -10, 0, 20)
	input.Position = UDim2.new(0.5, 0, 0.5, -10)
	input.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
	input.BorderSizePixel = 0
	input.Text = ""
	input.TextColor3 = Color3.fromRGB(255, 255, 255)
	input.TextSize = 10
	input.Font = Enum.Font.Gotham
	input.AutoButtonColor = false
	Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)

	input.Activated:Connect(function()
	cycleSlotAnimation(key, input)
	end)
	animationFieldRefs[key] = input
	end

	local infoLabel = Instance.new("TextLabel", animationsSection)
	infoLabel.Size = UDim2.new(1, 0, 0, 24)
	infoLabel.BackgroundTransparency = 1
	infoLabel.Text = "Master: turn all animations on or off. Click an animation to cycle to the next one."
	infoLabel.TextColor3 = Color3.fromRGB(120, 170, 220)
	infoLabel.TextSize = 10
	infoLabel.Font = Enum.Font.Gotham
	infoLabel.TextXAlignment = Enum.TextXAlignment.Left

	loadAnimationPresetIntoFields(selectedAnimationPresetName)
	if _G.__savedAnimations then
	for k, savedVal in pairs(_G.__savedAnimations) do
	if Anims[k] ~= nil then
	Anims[k] = savedVal
	local box = animationFieldRefs[k]
	if box then box.Text = animDisplayName(savedVal) end
	end
	end
	_G.__savedAnimations = nil
	end

    local toggleBtn = nil
    _G.__toggleBtn = nil

	local panelScale = Instance.new("UIScale", Panel)
	local function getGuiScale()
		return math.clamp(tonumber(_G.__CrystalGuiScale) or 1, 0.50, 1.50)
	end
	panelScale.Scale = getGuiScale()
	_G.__CrystalPanelScale = panelScale
	_G.__CrystalApplyGuiScale = function(value)
		local size = tonumber(value)
		if not size or size ~= size or math.abs(size) == math.huge then
			return getGuiScale()
		end
		size = math.clamp(math.floor(size * 100 + 0.5) / 100, 0.50, 1.50)
		_G.__CrystalGuiScale = size
		if panelScale and panelScale.Parent then
			panelScale.Scale = size
		end
		pcall(function()
			if type(saveConfig) == "function" then saveConfig() end
		end)
		return size
	end

	local panelVisible = toggleStates["Toggle UI"] ~= false
	if type(_G.__CrystalPanelVisible) == "boolean" then
	panelVisible = _G.__CrystalPanelVisible
	end
	if toggleStates["Toggle UI"] ~= panelVisible then toggleStates["Toggle UI"] = panelVisible end
	if toggleVisualUpdaters["Toggle UI"] then toggleVisualUpdaters["Toggle UI"]() end

	local _panelAnimating = false
	local _toggleUIDebounce = false
	local miniPanel = nil
	local miniSubtitle = nil
	function setPanelVisible(show)
	show = show == true
	_G.__CrystalPanelVisible = show
	toggleStates["Toggle UI"] = show
	if Panel.Visible == show then
	panelVisible = show
	if miniPanel then miniPanel.Visible = not show end
	if miniSubtitle then miniSubtitle.Visible = not show end
	saveConfig()
	return
	end
	if _panelAnimating or _toggleUIDebounce then return end

	_toggleUIDebounce = true
	task.delay(0.3, function() _toggleUIDebounce = false end)
	panelVisible = show
	if show then
	Panel.Visible = true
	if miniPanel then miniPanel.Visible = false end
	if miniSubtitle then miniSubtitle.Visible = false end
	local base = getGuiScale()
	panelScale.Scale = base * 0.92
	Panel.BackgroundTransparency = 1
	TweenService:Create(panelScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = base}):Play()
	TweenService:Create(Panel, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
	else
	_panelAnimating = true
	local base = getGuiScale()
	TweenService:Create(panelScale, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = base * 0.9}):Play()
	TweenService:Create(Panel, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
	task.delay(0.16, function()
	Panel.Visible = false
	if miniPanel then miniPanel.Visible = true end
	if miniSubtitle then miniSubtitle.Visible = true end
	panelScale.Scale = getGuiScale()
	Panel.BackgroundTransparency = 1
	_panelAnimating = false
	end)
	end
	if toggleVisualUpdaters["Toggle UI"] then toggleVisualUpdaters["Toggle UI"]() end
	saveConfig()
	end

	Panel.Visible = false
	_G.__setPanelVisible = setPanelVisible

	FeatureToggles["Toggle UI"] = function()

	setPanelVisible(not Panel.Visible)
	end

	-- Always start from the default LEFT position on every execution.
	_G["_SoundHub_UI_MenuPos"] = nil
	savedMenuPos = nil
	Panel.Position = UDim2.new(0, 20, 0.5, -PANEL_H/2)

	Panel.Visible = false
	toggleStates["Toggle UI"] = panelVisible
	_G.__CrystalPanelVisible = panelVisible
	if miniPanel then miniPanel.Visible = not panelVisible end
	if miniSubtitle then miniSubtitle.Visible = not panelVisible end

	;(function()
	_G.__CrystalModernGuiActive = true
	local themesPanel = ScreenGui:FindFirstChild("MainThemesPanel")
	if themesPanel then themesPanel:Destroy() end

	if FPSLabel then FPSLabel.Parent = ScreenGui end
	if PingLabel then PingLabel.Parent = ScreenGui end
	for _, child in ipairs(Panel:GetChildren()) do
	if child ~= panelScale then child:Destroy() end
	end
	if panelScale then panelScale.Scale = (type(getGuiScale)=="function" and getGuiScale()) or math.clamp(tonumber(_G.__CrystalGuiScale) or 1, 0.50, 1.50) end
	if toggleBtn then toggleBtn:Destroy(); toggleBtn = nil; _G.__toggleBtn = nil end
	if miniPanel then pcall(function() miniPanel:Destroy() end); miniPanel = nil; miniSubtitle = nil end

	Panel.Name = "EclipseModernPanel"
	local MODERN = {
	headerH = isMobile and 96 or 108,
	pageGap = isMobile and 5 or 8,
	sectionH = isMobile and 20 or 24,
	inputH = isMobile and 32 or 38,
	toggleH = isMobile and 32 or 38,
	toggleBindH = isMobile and 40 or 50,
	actionH = isMobile and 32 or 38,
	textSize = isMobile and 9 or 11,
	categoryH = isMobile and 28 or 34,
	}
	local modernViewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or vp
	-- Mobile portrait: big centred card (~80% of the width, ~79% of the height) like the reference screenshot
	local modernPortrait = _G.__CrystalRealMobile and modernViewport.Y > modernViewport.X
	local modernPanelW = modernPortrait and math.clamp(math.floor(modernViewport.X * 0.80), 260, 560)
		or (_G.__CrystalRealMobile and math.clamp(math.floor(modernViewport.X * 0.58), 240, 300) or 360)
	local modernPanelH = modernPortrait and math.clamp(math.floor(modernViewport.Y * 0.83), 450, 1000)
		or (_G.__CrystalRealMobile and math.clamp(math.floor(modernViewport.Y - 50), 450, 790) or 680)
	Panel.Size = UDim2.new(0, modernPanelW, 0, modernPanelH)
	-- Ignore any saved/dragged position: the GUI always starts on the LEFT.
	_G["_SoundHub_UI_MenuPos"] = nil
	local savedModernPosition = nil
	if modernPortrait then
	Panel.Position = UDim2.new(0, 8, 0.10, 0)
	elseif _G.__CrystalRealMobile then
	Panel.Position = UDim2.new(0, 8, 0, 10)
	else
	Panel.Position = UDim2.new(0, 12, 0.5, -modernPanelH / 2)
	end
	Panel.BackgroundTransparency = 1
	Panel.BorderSizePixel = 0
	Panel.ClipsDescendants = false
	Panel.Visible = panelVisible

	local CURT_WORD_IMAGE = "rbxassetid://135364804744286"
	local PURPLE_TITLE_DEFAULT = "rbxassetid://135364804744286"
	local PURPLE_TITLE_NEW = "rbxassetid://135364804744286"
	local PURPLE_TITLE_IMAGE = (_G["_SoundHub_UI_PurpleTitle"] == "New") and PURPLE_TITLE_NEW or PURPLE_TITLE_DEFAULT
	local TITLE_VARIANTS = {
		azure     = { V1 = "rbxassetid://135364804744286", V2 = "rbxassetid://135364804744286" },
		green     = { V1 = "rbxassetid://135364804744286", V2 = "rbxassetid://135364804744286" },
		halloween = { V1 = "rbxassetid://135364804744286",  V2 = "rbxassetid://135364804744286" },
	}
	TITLE_VARIANTS.of = function(key)
		return (_G["_SoundHub_UI_TitleVariant_" .. key] == "V2") and "V2" or "V1"
	end
	local AZURE_TITLE_IMAGE = TITLE_VARIANTS.azure[TITLE_VARIANTS.of("azure")]
	local GREEN_TITLE_IMAGE = TITLE_VARIANTS.green[TITLE_VARIANTS.of("green")]
	local HALLOWEEN_TITLE_IMAGE = TITLE_VARIANTS.halloween[TITLE_VARIANTS.of("halloween")]
	_G.__CrystalCurtWordImage = CURT_WORD_IMAGE
	_G.__CrystalGreenTitleImage = GREEN_TITLE_IMAGE
	_G.__CrystalHalloweenTitleImage = HALLOWEEN_TITLE_IMAGE
	local CURT_THEME_PRESETS = {
		azure = {
			bg = Color3.fromRGB(6, 12, 22),
			bgDark = Color3.fromRGB(0, 0, 0),
			row = Color3.fromRGB(12, 24, 42),
			accent = Color3.fromRGB(80, 170, 255),
			accentDim = Color3.fromRGB(28, 90, 160),
			activeRow = Color3.fromRGB(24, 70, 130),
			text = Color3.fromRGB(255, 255, 255),
			textDim = Color3.fromRGB(180, 215, 255),
			textMuted = Color3.fromRGB(120, 160, 210),
			divider = Color3.fromRGB(30, 70, 120),
		},
		purple = {
			bg = Color3.fromRGB(12, 6, 24),
			bgDark = Color3.fromRGB(0, 0, 0),
			row = Color3.fromRGB(30, 14, 56),
			accent = Color3.fromRGB(168, 85, 247),
			accentDim = Color3.fromRGB(104, 44, 184),
			activeRow = Color3.fromRGB(80, 32, 150),
			text = Color3.fromRGB(255, 255, 255),
			textDim = Color3.fromRGB(220, 195, 255),
			textMuted = Color3.fromRGB(155, 120, 210),
			divider = Color3.fromRGB(100, 56, 170),
		},
		green = {
			bg = Color3.fromRGB(4, 14, 8),
			bgDark = Color3.fromRGB(0, 0, 0),
			row = Color3.fromRGB(12, 32, 18),
			accent = Color3.fromRGB(70, 210, 110),
			accentDim = Color3.fromRGB(28, 120, 60),
			activeRow = Color3.fromRGB(22, 90, 48),
			text = Color3.fromRGB(255, 255, 255),
			textDim = Color3.fromRGB(180, 235, 195),
			textMuted = Color3.fromRGB(110, 170, 130),
			divider = Color3.fromRGB(36, 110, 60),
		},
	}
	local HALLOWEEN_THEME = {
		bg = Color3.fromRGB(10, 5, 1),
		bgDark = Color3.fromRGB(0, 0, 0),
		row = Color3.fromRGB(26, 12, 3),
		accent = Color3.fromRGB(255, 126, 26),
		accentDim = Color3.fromRGB(132, 54, 8),
		activeRow = Color3.fromRGB(102, 39, 4),
		text = Color3.fromRGB(255, 246, 226),
		textDim = Color3.fromRGB(255, 191, 112),
		textMuted = Color3.fromRGB(196, 126, 62),
		divider = Color3.fromRGB(82, 35, 8),
	}
	-- MENU UI V1 uses the original menu without an override.
	_G.__CrystalMenuUiThemes = {}
	_G.__CrystalGetMenuUiTheme = function()
		return _G.__CrystalMenuUiThemes[tostring(_G["_SoundHub_UI_MenuUi"] or "1")]
	end
	local function getCurtThemePreset(index)
		local ct = "purple"
		if ct == "azure" then return CURT_THEME_PRESETS.azure end
		if ct == "green" then return CURT_THEME_PRESETS.green end
		return CURT_THEME_PRESETS.purple
	end
	local _initialCurtTheme = getCurtThemePreset(bgIndex)
	local C = {
	bg = _initialCurtTheme.bg,
	bgDark = _initialCurtTheme.bgDark,
	row = _initialCurtTheme.row,
	accent = _initialCurtTheme.accent,
	accentDim = _initialCurtTheme.accentDim,
	activeRow = _initialCurtTheme.activeRow,
	text = _initialCurtTheme.text,
	textDim = _initialCurtTheme.textDim,
	textMuted = _initialCurtTheme.textMuted,
	divider = _initialCurtTheme.divider,
	}
	local function corner(parent, radius)
	local item = Instance.new("UICorner")
	item.CornerRadius = UDim.new(0, radius or 10)
	item.Parent = parent
	return item
	end
	local function stroke(parent, color, thickness)
	local item = Instance.new("UIStroke")
	item.Color = color or C.divider
	item.Thickness = thickness or 1
	item.Parent = parent
	return item
	end

	-- ===== AMBITIOUS-STYLE WINDOW OUTLINE =====
	-- Copied 1:1 from the AmbitiousTest source: corner(Main, 28) plus
	-- stroke(Main, COLORS.stroke, 1.1, 0.35), where COLORS.stroke is
	-- Color3.fromRGB(90, 90, 105) and the stroke carries a UIGradient that goes
	-- white -> (155, 160, 185) -> white while its own transparency goes
	-- 0.55 -> 0.1 -> 0.55. That gradient is what makes the middle of every edge
	-- read brighter than the corners, i.e. the crisp silver edge of that menu.
	-- Applied from this one place both at build time and on every theme change,
	-- and tagged with an attribute so the theme repaint loop leaves it alone
	-- instead of pulling it back to the accent color.
	_G.__SoundMenuCorner = 28
	_G.__SoundApplyAmbitiousOutline = function(host)
		if not host then return nil end
		local edge = host:FindFirstChild("UnifiedPanelAccentOutline")
		if not edge then return nil end
		edge.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		edge.LineJoinMode = Enum.LineJoinMode.Round
		edge.Color = Color3.fromRGB(90, 90, 105)
		edge.Thickness = 1.1
		edge.Transparency = 0.35
		edge:SetAttribute("AmbitiousOutlineLocked", true)
		local grad = edge:FindFirstChild("AmbitiousOutlineGradient")
		if not grad then
			grad = Instance.new("UIGradient")
			grad.Name = "AmbitiousOutlineGradient"
			grad.Rotation = 0
			grad.Parent = edge
		end
		grad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(155, 160, 185)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
		})
		grad.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.55),
			NumberSequenceKeypoint.new(0.5, 0.1),
			NumberSequenceKeypoint.new(1, 0.55),
		})
		return edge
	end
	-- ===== AMBITIOUS-STYLE WINDOW OUTLINE END =====

	local activeUiTweens = setmetatable({}, { __mode = "k" })
	local function tween(object, properties, duration, easingStyle, easingDirection)
	if not object or not object.Parent then return nil end
	local previous = activeUiTweens[object]
	if previous then pcall(function() previous:Cancel() end) end
	local animation = TweenService:Create(object, TweenInfo.new(
	duration or 0.16,
	easingStyle or Enum.EasingStyle.Quart,
	easingDirection or Enum.EasingDirection.Out
	), properties)
	activeUiTweens[object] = animation
	animation:Play()
	return animation
	end
	local function makeDraggable(handle, target)
	local dragging, dragInput, dragStart, startPosition = false, nil, nil, nil
	handle.Active = true
	_G.__CrystalGuiPositionResetters[target.Name] = function()
	dragging = false
	dragInput = nil
	dragStart = nil
	startPosition = nil
	target.Position = UDim2.fromOffset(6, 54)
	if target == Panel then
	_G["_SoundHub_UI_MenuPos"] = nil
	else
	_G["_SoundHub_UI_ModernMiniPos"] = nil
	end
	end
	handle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
	if dragging then return end
	dragInput = input
	dragging = true; dragStart = input.Position; startPosition = target.Position
	input.Changed:Connect(function()
	if input.UserInputState == Enum.UserInputState.End then
	dragging = false
	if target == Panel then
	_G["_SoundHub_UI_MenuPos"] = {
	x = target.Position.X.Offset,
	y = target.Position.Y.Offset,
	xs = target.Position.X.Scale,
	ys = target.Position.Y.Scale,
	}
	pcall(saveConfig)
	elseif target.Name == "EclipseRestoreButton" then
	_G["_SoundHub_UI_ModernMiniPos"] = {
	x = target.Position.X.Offset,
	y = target.Position.Y.Offset,
	}
	pcall(saveConfig)
	end
	end
	end)
	end
	end)
	handle.InputChanged:Connect(function(input)
	if dragging and dragInput.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
	end)

	_G.__CrystalTrackConn(UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
	local delta = input.Position - dragStart
	placeInsideViewport(target, startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
	end
	end))
	end

	local inner = Instance.new("Frame")
	inner.Name = "Inner"
	inner.Size = UDim2.new(1, 0, 1, 0)
	inner.BackgroundColor3 = C.bg
	inner.BorderSizePixel = 0
	inner.ClipsDescendants = true
	inner.Parent = Panel
	corner(inner, _G.__SoundMenuCorner or 28)
	local innerStroke = stroke(inner, Color3.fromRGB(45, 45, 45), 0)

	local background = Instance.new("ImageLabel")
	background.Name = "BackgroundImage"
	background.Size = UDim2.new(1, -2, 1, -2)
	background.Position = UDim2.fromOffset(1, 1)
	background.BackgroundTransparency = 1
	local GUI_THEME_IMAGES = { ["GUI 1"] = "rbxassetid://101955333228594" }
	local activeGuiTheme = "GUI 1"
	_G.__CrystalGuiTheme = activeGuiTheme
	local refreshCategoryTextColors
	local mainShade = _G.__CrystalAddUnifiedPanelShade(inner, _G.__SoundMenuCorner or 28, 1)
	local mainOutline = inner:FindFirstChild("UnifiedPanelAccentOutline")
	if mainOutline and _G.__SoundApplyAmbitiousOutline then _G.__SoundApplyAmbitiousOutline(inner) end
	for _, extraName in ipairs({"UnifiedPanelWhiteOutline", "UnifiedPanelWhiteGlow"}) do
		local extra = inner:FindFirstChild(extraName)
		if extra then extra:Destroy() end
	end
	if mainShade then
		mainShade.Position = UDim2.fromOffset(1, 1)
		mainShade.Size = UDim2.new(1, -2, 1, -2)
		local shadeCorner = mainShade:FindFirstChildOfClass("UICorner")
		if shadeCorner then shadeCorner.CornerRadius = UDim.new(0, (_G.__SoundMenuCorner or 28) - 1) end
	end
	local function applyGuiTheme(themeName)
	themeName = "GUI 1"
	activeGuiTheme = themeName
	_G.__CrystalGuiTheme = themeName
	if _G.__CrystalApplyTheme then _G.__CrystalApplyTheme() end
	background.Image = GUI_THEME_IMAGES[themeName]
	local backgroundShade = inner:FindFirstChild("UnifiedBackgroundShade")
	if backgroundShade then backgroundShade.Visible = themeName ~= "GUI 1" end
	innerStroke.Transparency = 1
	if _G.__CrystalApplyAutoStealBarTheme then
	pcall(_G.__CrystalApplyAutoStealBarTheme, themeName)
	end
	if _G.__CrystalRefreshESPTheme then
	pcall(_G.__CrystalRefreshESPTheme, _G.__CrystalThemeAccent, Color3.fromRGB(0, 0, 0))
	end
	if _G.__refreshSpeedBillboards then
	pcall(_G.__refreshSpeedBillboards)
	end
	if refreshCategoryTextColors then refreshCategoryTextColors() end
	end
	applyGuiTheme(activeGuiTheme)
	background.ImageTransparency = 0
	background.ScaleType = Enum.ScaleType.Crop
	-- sync color-theme backgrounds (red/azzurro/blue)
	do
		local bi = tonumber(_G["_SoundHub_UI_BgIndex"]) or 1
		if _G["_SoundHub_UI_BgPicked"] == true and backgroundIds and backgroundIds[bi] and backgroundIds[bi] ~= "" then
			background.Image = backgroundIds[bi]
		else
			background.Image = ""
		end
		if _G.__CrystalApplyMainBgFrame then pcall(_G.__CrystalApplyMainBgFrame, background, bi) end
	end
	background.ZIndex = 0
	background.Parent = inner
	background.Visible = true
	corner(background, (_G.__SoundMenuCorner or 28) - 1)

	local header = Instance.new("Frame")
	header.Name = "HeaderFrame"
	header.Size = UDim2.new(1, 0, 0, MODERN.headerH)
	header.BackgroundTransparency = 1
	header.ZIndex = 10
	header.Parent = inner
	makeDraggable(header, Panel)

	local statsPanel = Instance.new("Frame")
	statsPanel.Name = "HeaderStats"
	statsPanel.Position = UDim2.new(0, 14, 0, 8)
	statsPanel.Size = UDim2.new(0, 78, 0, 40)
	statsPanel.BackgroundColor3 = C.bgDark
	statsPanel:SetAttribute("CurtThemeRole", "BgDark")
	statsPanel.BackgroundTransparency = 0.35
	statsPanel.BorderSizePixel = 0
	statsPanel.ZIndex = 12
	statsPanel.Parent = header
	statsPanel.Visible = false
	corner(statsPanel, 8)
	stroke(statsPanel, Color3.fromRGB(45, 45, 45), 1)

	if FPSLabel then
	FPSLabel.Parent = statsPanel
	FPSLabel.Position = UDim2.new(0, 7, 0, 3)
	FPSLabel.Size = UDim2.new(1, -14, 0, 16)
	FPSLabel.BackgroundTransparency = 1
	FPSLabel.TextColor3 = C.text
	FPSLabel.TextSize = 9
	FPSLabel.Font = Enum.Font.GothamBold
	FPSLabel.TextXAlignment = Enum.TextXAlignment.Left
	FPSLabel.TextTransparency = 0
	FPSLabel.Visible = false
	FPSLabel.ZIndex = 13
	end
	if PingLabel then
	PingLabel.Parent = statsPanel
	PingLabel.Position = UDim2.new(0, 7, 0, 20)
	PingLabel.Size = UDim2.new(1, -14, 0, 16)
	PingLabel.BackgroundTransparency = 1
	PingLabel.TextColor3 = C.textDim
	PingLabel.TextSize = 9
	PingLabel.Font = Enum.Font.GothamBold
	PingLabel.TextXAlignment = Enum.TextXAlignment.Left
	PingLabel.TextTransparency = 0
	PingLabel.Visible = false
	PingLabel.ZIndex = 13
	end

	local title = Instance.new("TextLabel")
	title.Position = UDim2.new(0, 98, 0, 8)
	title.Size = UDim2.new(1, -146, 0, 22)
	title.BackgroundTransparency = 1
	title.Text = "Sound"
	title.TextColor3 = C.text
	title.TextSize = 17
	title.Font = Enum.Font.GothamBlack
	title.TextXAlignment = Enum.TextXAlignment.Center
	title.ZIndex = 11
	title.Parent = header

	local subtitle = Instance.new("TextLabel")
	subtitle.Position = UDim2.new(0, 98, 0, 32)
	subtitle.Size = UDim2.new(1, -146, 0, 14)
	subtitle.BackgroundTransparency = 1
	subtitle.Text = ""
	subtitle.TextColor3 = C.textDim
	subtitle.TextSize = 10
	subtitle.Font = Enum.Font.GothamBold
	subtitle.TextXAlignment = Enum.TextXAlignment.Center
	subtitle.ZIndex = 11
	subtitle.Parent = header
	subtitle.Visible = false

	local wordMark = Instance.new("ImageLabel")
	wordMark.Name = "CurtWordMark"
	wordMark.AnchorPoint = Vector2.new(0.5, 0.5)
	wordMark.Position = UDim2.new(0.5, 0, 0.5, 0)
	wordMark.Size = UDim2.fromOffset(isMobile and 380 or 480, isMobile and 100 or 124)
	wordMark.BackgroundTransparency = 1
	wordMark.Image = CURT_WORD_IMAGE
	wordMark.ScaleType = Enum.ScaleType.Fit
	wordMark.ImageColor3 = C.accent
	wordMark.ZIndex = 13
	wordMark.Parent = header

	local wordGlow = Instance.new("ImageLabel")
	wordGlow.Name = "CurtWordGlow"
	wordGlow.AnchorPoint = Vector2.new(0.5, 0.5)
	wordGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
	wordGlow.Size = UDim2.fromOffset(isMobile and 400 or 500, isMobile and 108 or 134)
	wordGlow.BackgroundTransparency = 1
	wordGlow.Image = CURT_WORD_IMAGE
	wordGlow.ImageTransparency = 0.74
	wordGlow.ScaleType = Enum.ScaleType.Fit
	wordGlow.ZIndex = 12
	wordGlow.Parent = header

	local closeButton = Instance.new("TextButton")
	closeButton.Size = UDim2.new(0, 96, 0, 28)
	closeButton.Position = UDim2.new(1, -106, 0, 8)
	closeButton.BackgroundColor3 = C.bgDark
	closeButton.BackgroundTransparency = 1
	closeButton.BorderSizePixel = 0
	closeButton.AutoButtonColor = false
	closeButton.Text = "--"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.Font = Enum.Font.GothamBlack
	closeButton.TextSize = 18
	closeButton.ZIndex = 12
	closeButton.Parent = header

	local separator = Instance.new("Frame")
	separator.Position = UDim2.new(0, 14, 0, MODERN.headerH)
	separator.Size = UDim2.new(1, -28, 0, 1)
	separator.BackgroundColor3 = C.accent
	separator:SetAttribute("CurtThemeRole", "Accent")
	separator.BackgroundTransparency = 0.7
	separator.BorderSizePixel = 0
	separator.ZIndex = 9
	separator.Parent = inner

	local categoryPanel = Instance.new("Frame")
	categoryPanel.Name = "LeftPanel"
	categoryPanel.Size = UDim2.new(0, 85, 1, -78)
	categoryPanel.Position = UDim2.new(1, -85, 0, 68)
	categoryPanel.BackgroundColor3 = C.bgDark
	categoryPanel:SetAttribute("CurtThemeRole", "BgDark")
	categoryPanel.BackgroundTransparency = 0.5
	categoryPanel.BorderSizePixel = 0
	categoryPanel.ZIndex = 5
	categoryPanel.Parent = inner
	corner(categoryPanel, 12)
	categoryPanel.Visible = false

	title.Text = ""
	title.Visible = false

	local bottomTabsH = isMobile and 40 or 48
	local bottomTabs = Instance.new("Frame")
	bottomTabs.Name = "SidebarTabs"
	bottomTabs.Size = UDim2.new(1, -12, 0, bottomTabsH)
	bottomTabs.Position = UDim2.new(0, 6, 1, -(bottomTabsH + 6))
	bottomTabs.BackgroundColor3 = C.bgDark
	bottomTabs:SetAttribute("CurtThemeRole", "BgDark")
	bottomTabs.BackgroundTransparency = 1
	bottomTabs.BorderSizePixel = 0
	bottomTabs.ZIndex = 10
	bottomTabs.Parent = inner
	corner(bottomTabs, 12)
	local bottomTabsStroke = stroke(bottomTabs, Color3.fromRGB(190, 120, 255), 1)
	bottomTabsStroke.Thickness = 1.5
	bottomTabsStroke.Transparency = 0

	-- Outer black-purple outline around the complete tabs container.
	local bottomTabsOuter = Instance.new("Frame")
	bottomTabsOuter.Name = "TabsOuterOutline"
	bottomTabsOuter.BackgroundTransparency = 1
	bottomTabsOuter.BorderSizePixel = 0
	bottomTabsOuter.Size = bottomTabs.Size + UDim2.new(0, 6, 0, 6)
	bottomTabsOuter.Position = bottomTabs.Position - UDim2.new(0, 3, 0, 3)
	bottomTabsOuter.ZIndex = bottomTabs.ZIndex - 1
	bottomTabsOuter.Parent = inner
	corner(bottomTabsOuter, 14)
	local bottomTabsOuterStroke = stroke(bottomTabsOuter, Color3.fromRGB(45, 12, 70), 1)
	bottomTabsOuterStroke.Thickness = 2
	bottomTabsOuterStroke.Transparency = 0

	local categoryList = Instance.new("ScrollingFrame")
	categoryList.BorderSizePixel = 0
	categoryList.ScrollBarThickness = 0
	categoryList.CanvasSize = UDim2.new(0, 0, 0, 0)
	categoryList.AutomaticCanvasSize = Enum.AutomaticSize.X
	categoryList.ScrollingDirection = Enum.ScrollingDirection.X
	categoryList.Size = UDim2.new(1, -12, 1, -8)
	categoryList.Position = UDim2.new(0, 6, 0, 4)
	categoryList.BackgroundTransparency = 1
	categoryList.ZIndex = 12
	categoryList.Parent = bottomTabs
	local categoryLayout = Instance.new("UIListLayout", categoryList)
	categoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
	categoryLayout.FillDirection = Enum.FillDirection.Horizontal
	categoryLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	categoryLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	categoryLayout.Padding = UDim.new(0, isMobile and 2 or 4)
	local categoryPadding = Instance.new("UIPadding", categoryList)
	categoryPadding.PaddingLeft = UDim.new(0, 0)
	categoryPadding.PaddingRight = UDim.new(0, 0)
	categoryPadding.PaddingTop = UDim.new(0, 0)

	local content = Instance.new("Frame")
	content.Name = "ContentFrame"
	content.Size = UDim2.new(1, -12, 1, -(MODERN.headerH + bottomTabsH + 20))
	content.Position = UDim2.new(0, 6, 0, MODERN.headerH + 8)
	content.BackgroundTransparency = 1
	content.ClipsDescendants = true
	content.ZIndex = 4
	content.Parent = inner

	local function applyMenuUiLayout(version)
		-- version kept for compatibility; tab placement is driven by __CrystalTabPosition
		version = (tostring(version) == "2" or tostring(version):lower() == "v2") and "2" or "1"
		local pos = "Top"
		_G.__CrystalTabPosition = "Top"
		_G["_SoundHub_UI_MenuUi"] = (pos == "Top") and "1" or "2"
		_G.__CrystalMenuUiVersion = _G["_SoundHub_UI_MenuUi"]
		local tabsH = isMobile and 38 or 44
		local sidebarWidth = isMobile and 72 or 86
		bottomTabs.BackgroundColor3 = C.bgDark
		bottomTabsStroke.Color = C.accent
		wordMark.Size = UDim2.new(1, -16, 1, -4)
		wordGlow.Size = UDim2.new(1, 0, 1, 4)

		local isTop = (pos == "Top")
		local isRight = (pos == "Right")

		if isTop then
			-- Top horizontal tab strip under the title art
			bottomTabs.Size = UDim2.new(1, -16, 0, tabsH)
			bottomTabs.Position = UDim2.new(0, 8, 0, MODERN.headerH - 10)
			bottomTabs.BackgroundTransparency = 0.45
			bottomTabsStroke.Transparency = 0.35
			categoryList.Size = UDim2.new(1, -10, 1, -6)
			categoryList.Position = UDim2.new(0, 5, 0, 3)
			categoryList.AutomaticCanvasSize = Enum.AutomaticSize.X
			categoryList.ScrollingDirection = Enum.ScrollingDirection.X
			categoryList.ScrollBarThickness = 0
			categoryLayout.FillDirection = Enum.FillDirection.Horizontal
			categoryLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
			categoryLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			categoryLayout.Padding = UDim.new(0, isMobile and 4 or 6)
			categoryPadding.PaddingTop = UDim.new(0, 0)
			content.Size = UDim2.new(1, -16, 1, -(MODERN.headerH + tabsH + 10))
			content.Position = UDim2.new(0, 8, 0, MODERN.headerH + tabsH + 2)
		else
			-- Vertical sidebar left or right
			bottomTabs.Size = UDim2.new(0, sidebarWidth, 1, -(MODERN.headerH + 16))
			if isRight then
				bottomTabs.Position = UDim2.new(1, -(sidebarWidth + 8), 0, MODERN.headerH + 8)
			else
				bottomTabs.Position = UDim2.new(0, 8, 0, MODERN.headerH + 8)
			end
			bottomTabs.BackgroundTransparency = 0.28
			bottomTabsStroke.Transparency = 0.18
			categoryList.Size = UDim2.new(1, -8, 1, -10)
			categoryList.Position = UDim2.new(0, 4, 0, 5)
			categoryList.AutomaticCanvasSize = Enum.AutomaticSize.Y
			categoryList.ScrollingDirection = Enum.ScrollingDirection.Y
			categoryList.ScrollBarThickness = 2
			categoryList.ScrollBarImageColor3 = C.accent
			categoryList.ScrollBarImageTransparency = 0.35
			categoryLayout.FillDirection = Enum.FillDirection.Vertical
			categoryLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			categoryLayout.VerticalAlignment = Enum.VerticalAlignment.Top
			categoryLayout.Padding = UDim.new(0, isMobile and 4 or 6)
			categoryPadding.PaddingTop = UDim.new(0, 2)
			content.Size = UDim2.new(1, -(sidebarWidth + 22), 1, -(MODERN.headerH + 16))
			if isRight then
				content.Position = UDim2.new(0, 8, 0, MODERN.headerH + 8)
			else
				content.Position = UDim2.new(0, sidebarWidth + 14, 0, MODERN.headerH + 8)
			end
		end
		-- Keep both outlines aligned with the tab box for every layout mode.
		bottomTabsOuter.Size = UDim2.new(bottomTabs.Size.X.Scale, bottomTabs.Size.X.Offset + 6, bottomTabs.Size.Y.Scale, bottomTabs.Size.Y.Offset + 6)
		bottomTabsOuter.Position = UDim2.new(bottomTabs.Position.X.Scale, bottomTabs.Position.X.Offset - 3, bottomTabs.Position.Y.Scale, bottomTabs.Position.Y.Offset - 3)
		categoryList.CanvasPosition = Vector2.zero
		for _, button in ipairs(categoryList:GetChildren()) do
			if button:IsA("TextButton") then
				local pad = button:FindFirstChild("TabPad")
				if not pad then
					pad = Instance.new("UIPadding")
					pad.Name = "TabPad"
					pad.Parent = button
				end
				button.Font = isTop and Enum.Font.GothamBlack or Enum.Font.GothamBold
				if isTop then
					button.AutomaticSize = Enum.AutomaticSize.X
					button.Size = UDim2.new(0, 0, 1, -2)
					button.TextWrapped = false
					button.TextSize = isMobile and 11 or 13
					button.TextXAlignment = Enum.TextXAlignment.Center
					pad.PaddingLeft = UDim.new(0, 10)
					pad.PaddingRight = UDim.new(0, 10)
				else
					button.AutomaticSize = Enum.AutomaticSize.None
					button.Size = UDim2.new(1, -6, 0, MODERN.categoryH)
					button.TextWrapped = true
					button.TextSize = isMobile and 9 or 10
					button.TextXAlignment = Enum.TextXAlignment.Center
					pad.PaddingLeft = UDim.new(0, 2)
					pad.PaddingRight = UDim.new(0, 2)
				end
			end
		end
		-- Side mini button keeps its avatar size/position (not the old header minimize control).
		for _, ch in ipairs(content:GetChildren()) do
			if ch:IsA("UICorner") then ch:Destroy() end
		end
		for _, object in ipairs(content:GetDescendants()) do
			if (object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox"))
				and object.Parent and object.Parent:GetAttribute("CurtThemeRole") == "Row" then
				object.TextWrapped = true
				object.TextSize = MODERN.textSize
			end
		end
		local selector = _G.__CrystalMenuUiButton
		if selector and selector.Parent then
			selector.Text = (pos == "Top") and "TOP" or ((pos == "Right") and "RIGHT" or "LEFT")
		end
		local tabSel = _G.__CrystalTabPositionButton
		if tabSel and tabSel.Parent then
			tabSel.Text = (pos == "Top") and "TOP" or ((pos == "Right") and "RIGHT" or "LEFT")
		end
		pcall(saveConfig)
		return pos
	end
	local function setTabPosition(position)
		-- Compatibility shim: every request keeps tabs at the top.
		_G.__CrystalTabPosition = "Top"
		return applyMenuUiLayout("1")
	end
	_G.__CrystalSetTabPosition = setTabPosition
	_G.__CrystalSetMenuUiVersion = applyMenuUiLayout

	local function keepOriginalText(object)
	object:SetAttribute("EclipseKeepBlackText", true)
	object.TextStrokeTransparency = 1
	return object
	end
	for _, object in ipairs(inner:GetDescendants()) do
	if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
	keepOriginalText(object)
	end
	end
	title.TextColor3 = C.text
	subtitle.TextColor3 = C.textDim
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	local pageScales = {}
	local function newPage(name)
	local page = Instance.new("ScrollingFrame")
	page.Name = name .. "Page"
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 2
	page.ScrollBarImageColor3 = C.accent
	page.ScrollBarImageTransparency = 0.28
	page.ElasticBehavior = Enum.ElasticBehavior.Always
	page.ScrollingDirection = Enum.ScrollingDirection.Y
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.Visible = name == "Main"
	page.ZIndex = 5
	page.Parent = content
	local pageScale = Instance.new("UIScale")
	pageScale.Name = "PageTransitionScale"
	pageScale.Scale = 1
	pageScale.Parent = page
	pageScales[name] = pageScale
	local layout = Instance.new("UIListLayout", page)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, MODERN.pageGap)
	local padding = Instance.new("UIPadding", page)
	padding.PaddingLeft = UDim.new(0, 6)
	padding.PaddingRight = UDim.new(0, 8)
	padding.PaddingTop = UDim.new(0, isMobile and 4 or 6)
	padding.PaddingBottom = UDim.new(0, isMobile and 4 or 6)
	return page
	end
	local pages = {
	Movement = newPage("Movement"),
	Combat = newPage("Combat"),
	Visual = newPage("Visual"),
	Main = newPage("Main"),
	Speed = newPage("Speed"),
	Sets = newPage("Sets"),
	Avatar = newPage("Avatar"),
	}

	local function setFeature(featureName, enabled)
	local current = toggleStates[featureName] == true
	if current == enabled then return end
	local toggler = FeatureToggles[featureName]
	if toggler then pcall(toggler) end
	if toggleStates[featureName] ~= enabled then
	toggleStates[featureName] = enabled
	local postToggle = FeaturePostToggle[featureName]
	if postToggle then pcall(postToggle, enabled) end
	end
	local updater = toggleVisualUpdaters[featureName]
	if updater then pcall(updater) end
	pcall(saveConfig)
	end
	local function beginKeybind(button, featureName)
	if listeningBindBtn then
	local previousFeature = listeningFeature
	local previousUpdater = previousFeature and toggleVisualUpdaters[previousFeature]
	if previousUpdater then
	pcall(previousUpdater)
	else
	local previousBind = FeatureKeybinds[previousFeature]
	listeningBindBtn.Text = previousBind and keybindDisplayName(previousBind) or "BIND"
	end
	end
	listeningBindBtn = button
	listeningFeature = featureName
	button.Text = "..."
	end
	local function sectionLabel(parent, text, order)
	local wrapper = Instance.new("Frame")
	wrapper.Size = UDim2.new(1, 0, 0, MODERN.sectionH + 10)
	wrapper.BackgroundColor3 = C.row
	wrapper:SetAttribute("CurtThemeRole", "Row")
	wrapper.BackgroundTransparency = 0.35
	wrapper.BorderSizePixel = 0
	wrapper.LayoutOrder = order
	wrapper:SetAttribute("SectionTitle", text)
	wrapper.Parent = parent
	corner(wrapper, 14); stroke(wrapper, C.accent, 1).Transparency = 0.7
	local label = keepOriginalText(Instance.new("TextLabel"))
	label.Name = "SectionLabel"
	label.Size = UDim2.new(1, -28, 1, 0)
	label.Position = UDim2.new(0, 18, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = string.upper(text)
	label.TextColor3 = C.text
	label.TextSize = isMobile and 10 or 12
	label.Font = Enum.Font.GothamBlack
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.Parent = wrapper
	local line = Instance.new("Frame")
	line.Name = "SectionLine"
	line.Size = UDim2.new(0, 3, 0.55, 0)
	line.Position = UDim2.new(0, 8, 0.225, 0)
	line.BackgroundColor3 = C.accent
	line:SetAttribute("CurtThemeRole", "Accent")
	line.BackgroundTransparency = 0
	line.BorderSizePixel = 0
	line.Parent = wrapper
	corner(line, 2)
	end
	local function inlineModeBind(parent, featureName, position)
	local bind = keepOriginalText(Instance.new("TextButton"))
	bind.Name = "ModeKeybind"
	bind.Size = UDim2.fromOffset(isMobile and 38 or 44, isMobile and 16 or 20)
	bind.Position = position
	bind.BackgroundColor3 = C.accentDim
	bind:SetAttribute("CurtThemeRole", "AccentDim")
	bind.BackgroundTransparency = 0.25
	bind.BorderSizePixel = 0
	bind.TextColor3 = C.text
	bind.TextSize = isMobile and 8 or 9
	bind.Font = Enum.Font.GothamBold
	bind.Text = FeatureKeybinds[featureName] and keybindDisplayName(FeatureKeybinds[featureName]) or "-"
	bind.ZIndex = 8
	bind.Parent = parent
	corner(bind, 5); stroke(bind, Color3.fromRGB(55, 55, 60), 1)
	bind.MouseButton1Click:Connect(function()
	beginKeybind(bind, featureName)
	end)
	table.insert(_allBindBtns, bind)

	local previousUpdater = toggleVisualUpdaters[featureName]
	toggleVisualUpdaters[featureName] = function()
	if previousUpdater then pcall(previousUpdater) end
	local key = FeatureKeybinds[featureName]
	bind.Text = key and keybindDisplayName(key) or "-"
	bind.BackgroundColor3 = C.accentDim
	bind:SetAttribute("CurtThemeRole", "AccentDim")
	bind.BackgroundTransparency = 0.25
	bind.TextColor3 = C.text
	end
	return bind
	end
	local function inputRow(parent, labelText, value, order, callback, bindFeatureName)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, MODERN.inputH)
	row.BackgroundColor3 = C.row
	row:SetAttribute("CurtThemeRole", "Row")
	row.BackgroundTransparency = 0.4
	row.BorderSizePixel = 0
	row.LayoutOrder = order
	row.Parent = parent
	corner(row, 14); stroke(row, C.accent, 1).Transparency = 0.8
	local label = keepOriginalText(Instance.new("TextLabel"))
	label.Size = bindFeatureName and UDim2.new(1, isMobile and -116 or -142, 1, 0) or UDim2.new(0.65, 0, 1, 0)
	label.Position = UDim2.new(0, isMobile and 8 or 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = C.text
	label.TextSize = MODERN.textSize
	label.TextWrapped = _G.__CrystalTabPosition == "Left"
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row
	if bindFeatureName then
	inlineModeBind(row, bindFeatureName, UDim2.new(1, isMobile and -94 or -116, 0.5, isMobile and -8 or -10))
	end
	local boxFrame = Instance.new("Frame")
	boxFrame.Size = UDim2.new(0, isMobile and 44 or 54, 0, isMobile and 18 or 22)
	boxFrame.Position = UDim2.new(1, isMobile and -51 or -64, 0.5, isMobile and -9 or -11)
	boxFrame.BackgroundColor3 = C.row
	boxFrame:SetAttribute("CurtThemeRole", "Row")
	boxFrame.BackgroundTransparency = 0.15
	boxFrame.BorderSizePixel = 0
	boxFrame.Parent = row
	corner(boxFrame, 6); stroke(boxFrame, Color3.fromRGB(55, 55, 60), 1)
	local box = keepOriginalText(Instance.new("TextBox"))
	box.Size = UDim2.new(1, 0, 1, 0)
	box.BackgroundTransparency = 1
	box.Text = tostring(value)
	box.TextColor3 = C.text
	box.TextSize = isMobile and 9 or 11
	box.Font = Enum.Font.GothamBold
	box.ClearTextOnFocus = false
	box.Parent = boxFrame
	box.FocusLost:Connect(function()
	local number = tonumber(box.Text)
	if number then callback(number); box.Text = tostring(number) else box.Text = tostring(value) end
	end)
	end
	local function customSpeedRow(parent, customSpeed, order)
	local row = Instance.new("Frame")
	row.Name = "CustomSpeed_" .. customSpeed.name
	row.Size = UDim2.new(1, 0, 0, 58)
	row.BackgroundColor3 = C.row
	row:SetAttribute("CurtThemeRole", "Row")
	row.BackgroundTransparency = 0.4
	row.BorderSizePixel = 0
	row.LayoutOrder = order
	row.Parent = parent
	corner(row, 14); stroke(row, C.accent, 1).Transparency = 0.8

	local selectedMarker = Instance.new("Frame")
	selectedMarker.Size = UDim2.new(0, 3, 0, 36)
	selectedMarker.Position = UDim2.new(0, 4, 0.5, -18)
	selectedMarker.BackgroundColor3 = C.accent
	selectedMarker:SetAttribute("CurtThemeRole", "Accent")
	selectedMarker.BorderSizePixel = 0
	selectedMarker.Parent = row
	corner(selectedMarker, 2)

	local selectButton = keepOriginalText(Instance.new("TextButton"))
	selectButton.Size = UDim2.new(0, 88, 1, 0)
	selectButton.Position = UDim2.new(0, 12, 0, 0)
	selectButton.BackgroundTransparency = 1
	selectButton.Text = customSpeed.name
	selectButton.TextColor3 = C.text
	selectButton.TextSize = 11
	selectButton.Font = Enum.Font.GothamBold
	selectButton.TextXAlignment = Enum.TextXAlignment.Left
	selectButton.Parent = row
	local customFeatureName = "SelectCustomMode_" .. customSpeed.name
	inlineModeBind(row, customFeatureName, UDim2.fromOffset(106, 19))

	local function speedBox(labelText, value, xPosition, onChanged)
	local label = keepOriginalText(Instance.new("TextLabel"))
	label.Size = UDim2.fromOffset(54, 14)
	label.Position = UDim2.fromOffset(xPosition, 5)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = C.textMuted
	label.TextSize = 8
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row
	local box = keepOriginalText(Instance.new("TextBox"))
	box.Size = UDim2.fromOffset(54, 22)
	box.Position = UDim2.fromOffset(xPosition, 24)
	box.BackgroundColor3 = C.bgDark
	box:SetAttribute("CurtThemeRole", "BgDark")
	box.BorderSizePixel = 0
	box.Text = tostring(value)
	box.TextColor3 = C.text
	box.TextSize = 10
	box.Font = Enum.Font.GothamBold
	box.ClearTextOnFocus = false
	box.Parent = row
	corner(box, 5); stroke(box, Color3.fromRGB(55, 55, 60), 1)
	box.FocusLost:Connect(function()
	local number = tonumber(box.Text)
	if not number then box.Text = tostring(value); return end
	number = math.clamp(math.floor(number + 0.5), 1, 200)
	value = number
	box.Text = tostring(number)
	onChanged(number)
	end)
	return box
	end

	speedBox("NORMAL", customSpeed.boost, 158, function(value)
	customSpeed.boost = value
	speedValues["CustomBoost_" .. customSpeed.name] = value
	saveConfig()
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	end)
	speedBox("CARRY", customSpeed.steal, 224, function(value)
	customSpeed.steal = value
	speedValues["CustomSteal_" .. customSpeed.name] = value
	saveConfig()
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	end)

	local deleteButton = keepOriginalText(Instance.new("TextButton"))
	deleteButton.Size = UDim2.fromOffset(30, 24)
	deleteButton.Position = UDim2.new(1, -40, 0.5, -12)
	deleteButton.BackgroundColor3 = Color3.fromRGB(72, 34, 34)
	deleteButton.BorderSizePixel = 0
	deleteButton.Text = "X"
	deleteButton.TextColor3 = Color3.fromRGB(255, 180, 180)
	deleteButton.TextSize = 10
	deleteButton.Font = Enum.Font.GothamBold
	deleteButton.Parent = row
	corner(deleteButton, 5)

	local function updateVisual()
	local active = selectedMode == customSpeed.name
	row.BackgroundTransparency = active and 0.3 or 0.55
	selectedMarker.Visible = active
	end
	selectButton.MouseButton1Click:Connect(function()
	selectMode(customSpeed.name)
	end)
	deleteButton.MouseButton1Click:Connect(function()
	for index = #customSpeeds, 1, -1 do
	if customSpeeds[index] == customSpeed then table.remove(customSpeeds, index); break end
	end
	speedValues["CustomBoost_" .. customSpeed.name] = nil
	speedValues["CustomSteal_" .. customSpeed.name] = nil
	FeatureKeybinds[customFeatureName] = nil
	FeatureToggles[customFeatureName] = nil
	if selectedMode == customSpeed.name then selectMode("Normal") end
	row:Destroy()
	saveConfig()
	end)
	FeatureToggles[customFeatureName] = function() selectMode(customSpeed.name) end
	table.insert(_speedCardRefs, { modeName = customSpeed.name, updateVisual = updateVisual })
	updateVisual()
	return row
	end

	local function customSpeedForm(parent, order, onCreated)
	local form = Instance.new("Frame")
	form.Name = "CustomSpeedForm"
	form.Size = UDim2.new(1, 0, 0, 112)
	form.BackgroundColor3 = C.row
	form:SetAttribute("CurtThemeRole", "Row")
	form.BackgroundTransparency = 0.2
	form.BorderSizePixel = 0
	form.LayoutOrder = order
	form.Parent = parent
	corner(form, 8); stroke(form, C.divider, 1)

	local function formLabel(text, x, width)
	local label = keepOriginalText(Instance.new("TextLabel"))
	label.Size = UDim2.fromOffset(width, 14)
	label.Position = UDim2.fromOffset(x, 8)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = C.textMuted
	label.TextSize = 8
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = form
	end
	local function formBox(defaultText, x, width)
	local box = keepOriginalText(Instance.new("TextBox"))
	box.Size = UDim2.fromOffset(width, 24)
	box.Position = UDim2.fromOffset(x, 24)
	box.BackgroundColor3 = C.bgDark
	box:SetAttribute("CurtThemeRole", "BgDark")
	box.BorderSizePixel = 0
	box.Text = defaultText
	box.TextColor3 = C.text
	box.TextSize = 10
	box.Font = Enum.Font.GothamBold
	box.ClearTextOnFocus = false
	box.Parent = form
	corner(box, 5); stroke(box, Color3.fromRGB(55, 55, 60), 1)
	return box
	end
	formLabel("NAME", 12, 150)
	formLabel("NORMAL", 174, 70)
	formLabel("CARRY", 256, 70)
	local nameBox = formBox("Custom " .. tostring(#customSpeeds + 1), 12, 150)
	local normalBox = formBox("59", 174, 70)
	local carryBox = formBox("29", 256, 70)
	local errorLabel = keepOriginalText(Instance.new("TextLabel"))
	errorLabel.Size = UDim2.new(1, -24, 0, 14)
	errorLabel.Position = UDim2.new(0, 12, 1, -20)
	errorLabel.BackgroundTransparency = 1
	errorLabel.Text = ""
	errorLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
	errorLabel.TextSize = 8
	errorLabel.Font = Enum.Font.GothamBold
	errorLabel.TextXAlignment = Enum.TextXAlignment.Left
	errorLabel.Parent = form
	local addButton = keepOriginalText(Instance.new("TextButton"))
	addButton.Size = UDim2.new(1, -24, 0, 26)
	addButton.Position = UDim2.new(0, 12, 0, 62)
	addButton.BackgroundColor3 = C.accentDim
	addButton:SetAttribute("CurtThemeRole", "AccentDim")
	addButton.BorderSizePixel = 0
	addButton.Text = "CREATE CUSTOM SPEED"
	addButton.TextColor3 = C.text
	addButton.TextSize = 10
	addButton.Font = Enum.Font.GothamBold
	addButton.Parent = form
	corner(addButton, 6)
	addButton.MouseButton1Click:Connect(function()
	local name = nameBox.Text:match("^%s*(.-)%s*$")
	local normal = tonumber(normalBox.Text)
	local carry = tonumber(carryBox.Text)
	if not name or #name < 1 then errorLabel.Text = "Escribe un nombre."; return end
	if name:find("[:,=]") then errorLabel.Text = "Names cannot contain : , or =."; return end
	if name == "Normal" or name == "Lagger" or name == "Desync" then errorLabel.Text = "That name is reserved."; return end
	for _, item in ipairs(customSpeeds) do if item.name == name then errorLabel.Text = "That name already exists."; return end end
	if not normal or normal < 1 or normal > 200 then errorLabel.Text = "Normal: elige un valor entre 1 y 200."; return end
	if not carry or carry < 1 or carry > 200 then errorLabel.Text = "Carry: elige un valor entre 1 y 200."; return end
	local customSpeed = { name = name, boost = math.floor(normal + 0.5), steal = math.floor(carry + 0.5) }
	table.insert(customSpeeds, customSpeed)
	speedValues["CustomBoost_" .. name] = customSpeed.boost
	speedValues["CustomSteal_" .. name] = customSpeed.steal
	saveConfig()
	form:Destroy()
	onCreated(customSpeed)
	end)
	return form
	end
	local function toggleRow(parent, labelText, featureName, initial, order, hasKeybind, callback, bindFeatureName)
	local row = Instance.new("Frame")
	row:SetAttribute("CrystalButtonThemeControl", true)
	row.Size = UDim2.new(1, 0, 0, hasKeybind and MODERN.toggleBindH or MODERN.toggleH)
	row.BackgroundColor3 = C.row
	row:SetAttribute("CurtThemeRole", "Row")
	row.BackgroundTransparency = 0.4
	row.BorderSizePixel = 0
	row.LayoutOrder = order
	row.Parent = parent
	corner(row, 14); stroke(row, C.accent, 1).Transparency = 0.8
	local rowScale = Instance.new("UIScale", row)
	rowScale.Scale = 1
	local label = keepOriginalText(Instance.new("TextLabel"))
	label.Size = UDim2.new(1, -70, 0, hasKeybind and (isMobile and 16 or 20) or MODERN.toggleH)
	label.Position = UDim2.new(0, isMobile and 8 or 12, 0, hasKeybind and (isMobile and 2 or 3) or 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = C.text
	label.TextSize = MODERN.textSize
	label.TextWrapped = _G.__CrystalTabPosition == "Left"
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row
	local activeMarker = Instance.new("Frame")
	activeMarker.Name = "ActiveMarker"
	activeMarker.Size = UDim2.new(0, 3, 0, isMobile and 18 or 24)
	activeMarker.Position = UDim2.new(0, 4, 0.5, isMobile and -9 or -12)
	activeMarker.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	activeMarker.BorderSizePixel = 0
	activeMarker.Visible = false
	activeMarker.Parent = row
	corner(activeMarker, 2)
	local switchTrack = Instance.new("Frame")
	switchTrack.Name = "ToggleSwitch"
	switchTrack.Size = UDim2.new(0, isMobile and 34 or 40, 0, isMobile and 16 or 20)
	switchTrack.Position = UDim2.new(1, isMobile and -42 or -50, 0.5, isMobile and -8 or -10)
	switchTrack.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
	switchTrack:SetAttribute("CurtThemeRole", "BgDark")
	switchTrack.BorderSizePixel = 0
	switchTrack.ZIndex = 8
	switchTrack.Parent = row
	corner(switchTrack, 20)
	stroke(switchTrack, C.divider, 1)
	local switchKnob = Instance.new("Frame")
	switchKnob.Name = "Knob"
	switchKnob.Size = UDim2.new(0, isMobile and 12 or 16, 0, isMobile and 12 or 16)
	switchKnob.Position = UDim2.new(0, 2, 0.5, isMobile and -6 or -8)
	switchKnob.BackgroundColor3 = Color3.fromRGB(210, 210, 215)
	switchKnob:SetAttribute("CurtThemeRole", "SwitchKnob")
	switchKnob.BorderSizePixel = 0
	switchKnob.ZIndex = 9
	switchKnob.Parent = switchTrack
	corner(switchKnob, 20)
	local keyFeatureName = bindFeatureName or featureName
	if hasKeybind and keyFeatureName then
	-- Keybind box to the LEFT of the toggle switch (always visible)
	local bind = keepOriginalText(Instance.new("TextButton"))
	bind.Name = tostring(keyFeatureName):gsub("%s+", "") .. "Keybind"
	bind.Size = UDim2.new(0, isMobile and 40 or 48, 0, isMobile and 18 or 22)
	bind.Position = UDim2.new(1, isMobile and -90 or -108, 0.5, isMobile and -9 or -11)
	bind.BackgroundColor3 = C.accentDim
	bind:SetAttribute("CurtThemeRole", "AccentDim")
	bind.BackgroundTransparency = 0.2
	bind.BorderSizePixel = 0
	bind.ZIndex = 10
	local key = FeatureKeybinds[keyFeatureName]
	bind.Text = key and keybindDisplayName(key) or "-"
	bind.TextColor3 = C.text
	bind.TextSize = isMobile and 9 or 10
	bind.Font = Enum.Font.GothamBold
	bind.AutoButtonColor = false
	bind.Parent = row
	corner(bind, 6)
	stroke(bind, C.divider, 1).Transparency = 0.4
	bind.MouseButton1Click:Connect(function() beginKeybind(bind, keyFeatureName) end)
	table.insert(_allBindBtns, bind)
	-- keep switch visual updater in sync with bind text
	local prev = toggleVisualUpdaters[keyFeatureName]
	toggleVisualUpdaters[keyFeatureName] = function()
		if prev then pcall(prev) end
		local k = FeatureKeybinds[keyFeatureName]
		bind.Text = k and keybindDisplayName(k) or "-"
	end
	end
	local active = initial == true
	local visualInitialized = false
	local function updateVisual(value)
	active = value == true
	local targetColor = C.row
	local targetTransparency = 0.55
	activeMarker.Visible = false
	local trackColor = active and C.accent or Color3.fromRGB(42, 42, 48)
	switchTrack:SetAttribute("SwitchActive", active)
	switchTrack:SetAttribute("CurtThemeRole", active and "Accent" or "BgDark")
	local knobPosition = active
		and UDim2.new(1, isMobile and -14 or -18, 0.5, isMobile and -6 or -8)
		or UDim2.new(0, 2, 0.5, isMobile and -6 or -8)
	if visualInitialized then
	tween(row, {
	BackgroundColor3 = targetColor,
	BackgroundTransparency = targetTransparency,
	}, 0.18)
	tween(switchTrack, { BackgroundColor3 = trackColor }, 0.18)
	tween(switchKnob, { Position = knobPosition }, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	else
	row.BackgroundColor3 = targetColor
	row.BackgroundTransparency = targetTransparency
	switchTrack.BackgroundColor3 = trackColor
	switchKnob.Position = knobPosition
	visualInitialized = true
	end
	end
	updateVisual(active)
	local button = Instance.new("TextButton")
	keepOriginalText(button)
	button.Size = UDim2.new(1, 0, 1, 0)
	button.Position = UDim2.new(0, 0, 0, 0)
	button.BackgroundTransparency = 1
	button.Text = ""
	button.ZIndex = 0
	button.Parent = row
	button.MouseButton1Click:Connect(function()
	rowScale.Scale = 0.985
	tween(rowScale, {Scale = 1}, 0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local desired = not active
	callback(desired)
	updateVisual(featureName and toggleStates[featureName] == true or desired)
	end)
	if featureName then
	toggleVisualUpdaters[featureName] = function() updateVisual(toggleStates[featureName] == true) end
	end
	return updateVisual, row
	end
	local function modeButton(row, initialText, callback)
	local button = keepOriginalText(Instance.new("TextButton"))
	button:SetAttribute("CrystalModeButton", true)
	-- A selector goes before an ON/OFF switch; standalone selectors stay right-aligned.
	local rowHasSwitch = row:FindFirstChild("ToggleSwitch") ~= nil
	button.Size = UDim2.new(0, isMobile and 46 or 56, 0, isMobile and 18 or 22)
	local selectorRightOffset = rowHasSwitch
		and (isMobile and 100 or 120)
		or (isMobile and 94 or 108)
	button.Position = UDim2.new(1, -selectorRightOffset, 0.5, isMobile and -9 or -11)
	button.BackgroundColor3 = C.accentDim
	button:SetAttribute("CurtThemeRole", "AccentDim")
	button.BackgroundTransparency = 0.25
	button.BorderSizePixel = 0
	button.Text = initialText
	button.TextColor3 = C.text
	button.TextSize = isMobile and 8 or 9
	button.Font = Enum.Font.GothamBold
	button.ZIndex = 8
	button.Parent = row
	corner(button, 9); stroke(button, C.accent, 1).Transparency = 0.6
	local buttonScale = Instance.new("UIScale", button)
	buttonScale.Scale = 1
	button.MouseButton1Click:Connect(function()
	buttonScale.Scale = 0.92
	tween(buttonScale, {Scale = 1}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local newText = callback()
	if newText then button.Text = tostring(newText) end
	end)
	return button
	end
	local function actionRow(parent, labelText, featureName, order, action)
	local row = Instance.new("Frame")
	row:SetAttribute("CrystalButtonThemeControl", true)
	row.Size = UDim2.new(1, 0, 0, MODERN.actionH)
	row.BackgroundColor3 = C.row
	row:SetAttribute("CurtThemeRole", "Row")
	row.BackgroundTransparency = 0.4
	row.BorderSizePixel = 0
	row.LayoutOrder = order
	row.Parent = parent
	corner(row, 14); stroke(row, C.accent, 1).Transparency = 0.8
	local rowScale = Instance.new("UIScale", row)
	rowScale.Scale = 1
	local label = keepOriginalText(Instance.new("TextButton"))
	label.Size = UDim2.new(1, featureName and -64 or -24, 1, 0)
	label.Position = UDim2.new(0, isMobile and 8 or 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = C.text
	label.TextSize = MODERN.textSize
	label.TextWrapped = _G.__CrystalTabPosition == "Left"
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row
	label.MouseButton1Click:Connect(function()
	rowScale.Scale = 0.985
	tween(rowScale, {Scale = 1}, 0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	action()
	end)
	if featureName then
	local bind = keepOriginalText(Instance.new("TextButton"))
	bind.Name = tostring(featureName):gsub("%s+", "") .. "Keybind"
	bind.Size = UDim2.new(0, isMobile and 40 or 48, 0, isMobile and 18 or 22)
	bind.Position = UDim2.new(1, isMobile and -48 or -58, 0.5, isMobile and -9 or -11)
	bind.BackgroundColor3 = C.accentDim
	bind:SetAttribute("CurtThemeRole", "AccentDim")
	bind.BackgroundTransparency = 0.2
	bind.BorderSizePixel = 0
	bind.ZIndex = 10
	local key = FeatureKeybinds[featureName]
	bind.Text = key and keybindDisplayName(key) or "-"
	bind.TextColor3 = C.text
	bind.TextSize = isMobile and 9 or 10
	bind.Font = Enum.Font.GothamBold
	bind.AutoButtonColor = false
	bind.Parent = row
	corner(bind, 6)
	stroke(bind, C.divider, 1).Transparency = 0.4
	bind.MouseButton1Click:Connect(function() beginKeybind(bind, featureName) end)
	table.insert(_allBindBtns, bind)
	local prev = toggleVisualUpdaters[featureName]
	toggleVisualUpdaters[featureName] = function()
		if prev then pcall(prev) end
		local k = FeatureKeybinds[featureName]
		bind.Text = k and keybindDisplayName(k) or "-"
	end
	end
	return row
	end

	local movement = pages.Movement

	sectionLabel(movement, "SPEED CONFIGURATION", 1)
	inputRow(movement, "Normal Speed", speedValues.NormalBoost, 1, function(value) speedValues.NormalBoost = math.max(1, math.floor(value)); normalSpeed = speedValues.NormalBoost; pcall(function() if _G.__refreshSpeedBoost then _G.__refreshSpeedBoost() end end); saveConfig() end, "SelectNormalMode")
	inputRow(movement, "Carry Speed", speedValues.NormalSteal, 2, function(value) speedValues.NormalSteal = math.max(1, math.floor(value)); carrySpeed = speedValues.NormalSteal; pcall(function() if _G.__refreshSpeedBoost then _G.__refreshSpeedBoost() end end); saveConfig() end, "SelectNormalMode")
	sectionLabel(movement, "LAGGER SPEED", 3)
	inputRow(movement, "Lagger Normal", speedValues.LaggerBoost, 4, function(value) speedValues.LaggerBoost = math.max(1, math.floor(value)); laggerSpeed = speedValues.LaggerBoost; saveConfig() end, "SelectLaggerMode")
	inputRow(movement, "Lagger Carry", speedValues.LaggerSteal, 5, function(value) speedValues.LaggerSteal = math.max(1, math.floor(value)); saveConfig() end, "SelectLaggerMode")
	-- Live speed mode indicator: Normal / Normal Carry / Lagger / Lagger Carry
	do
		local modeRow = actionRow(movement, "Mode: Normal", nil, 5.5, function() end)
		local function modeLabel()
			return modeRow and modeRow:FindFirstChildWhichIsA("TextButton", true)
		end
		local function currentSpeedModeText()
			local lagger = (selectedMode == "Lagger" or laggerEnabled == true)
			local as = _G.__SoundAutoCarryAS
			local carry = toggleStates["Carry Speed"] == true
				or Player:GetAttribute("Stealing") == true
				or (toggleStates["Auto Carry Speed"] == true and as ~= nil and as.locked == true)
			if lagger then return carry and "Lagger Carry" or "Lagger" end
			return carry and "Normal Carry" or "Normal"
		end
		local lastText, acc = nil, 0
		_G.__CrystalTrackConn(RunService.Heartbeat:Connect(function(dt)
			acc = acc + (dt or 0)
			if acc < 0.15 then return end
			acc = 0
			local lbl = modeLabel()
			if not lbl then return end
			local text = "Mode: " .. currentSpeedModeText()
			if text ~= lastText then
				lastText = text
				lbl.Text = text
			end
		end))
	end
	sectionLabel(movement, "CONTROLS", 60)
	actionRow(movement, "Auto Left", "Auto Left", 61, function()
	if _G.__CrystalAutoplaySideToggle then pcall(_G.__CrystalAutoplaySideToggle, "left") end
	end)
	actionRow(movement, "Auto Right", "Auto Right", 62, function()
	if _G.__CrystalAutoplaySideToggle then pcall(_G.__CrystalAutoplaySideToggle, "right") end
	end)
	toggleRow(movement, "Carry Speed", "Carry Speed", toggleStates["Carry Speed"], 63, true, function(on) setFeature("Carry Speed", on) end)
	toggleRow(movement, "Auto Carry", "Auto Carry Speed", toggleStates["Auto Carry Speed"], 63.5, false, function(on) setFeature("Auto Carry Speed", on) end)
	local autoCarryModeRow = actionRow(movement, "Auto Carry Mode", nil, 63.7, function() end)
	modeButton(autoCarryModeRow, (_G.__SoundAutoCarryMode == "SOFT") and "SOFT" or "NORMAL", function()
		_G.__SoundAutoCarryMode = (_G.__SoundAutoCarryMode == "SOFT") and "NORMAL" or "SOFT"
		saveConfig()
		return (_G.__SoundAutoCarryMode == "SOFT") and "SOFT" or "NORMAL"
	end)
	sectionLabel(movement, "MOVEMENT SETTINGS", 70)
	local _, infJumpUiRow = toggleRow(movement, "Infinite Jump", "Inf Jump", toggleStates["Inf Jump"], 71, false, function(on) setFeature("Inf Jump", on) end)
	modeButton(infJumpUiRow, string.upper(_G.__CrystalInfJumpMode or "manual"), function()
	_G.__CrystalInfJumpMode = (_G.__CrystalInfJumpMode or "manual") == "hold" and "manual" or "hold"
	if toggleStates["Inf Jump"] then
	if _G.__CrystalInfJumpMode == "hold" and startInfJump then
	pcall(startInfJump)
	elseif stopInfJump then
	pcall(stopInfJump)
	end
	end
	saveConfig()
	return string.upper(_G.__CrystalInfJumpMode)
	end)
	toggleRow(movement, "Unwalk", "Unwalk", toggleStates["Unwalk"], 72, false, function(on)
	setFeature("Unwalk", on)
	end)

	sectionLabel(movement, "TP DOWN", 73)
	toggleRow(movement, "Auto TP Down", "Auto TP Down", toggleStates["Auto TP Down"], 74, true, function(on)
	setFeature("Auto TP Down", on)
	end)
	inputRow(movement, "Height (studs)", speedValues.AutoTPDownHeight, 75, function(value)
	speedValues.AutoTPDownHeight = math.clamp(math.floor(value + 0.5), 1, 1000)
	saveConfig()
	end)

	local combat = pages.Combat
	sectionLabel(combat, "BAT CONTROLS", 0)
	toggleRow(combat, "Bat Aimbot", "Aimbot", toggleStates.Aimbot, 1, true, function(on) setFeature("Aimbot", on) end)
	local batAimbotModeRow = actionRow(combat, "Aimbot Mode", nil, 2, function() end)
	modeButton(batAimbotModeRow, _G._AdaptBatMode or "NORMAL", function()
		_G._AdaptBatMode = (_G._AdaptBatMode == "BYPASS") and "NORMAL" or "BYPASS"
		_G._AdaptBatVersion = 1
		batAimbotMode = _G._AdaptBatMode
		local label = batAimbotModeRow and batAimbotModeRow:FindFirstChildWhichIsA("TextLabel", true)
		if label then label.Text = _G._AdaptBatMode end
		if toggleStates["Aimbot"] and _cypherStop and _cypherStartFollowing then pcall(_cypherStop); task.defer(function() if toggleStates["Aimbot"] then pcall(_cypherStartFollowing, Player.Character) end end) end
		saveConfig()
		return _G._AdaptBatMode
	end)
	local batAimbotVersionRow = actionRow(combat, "Aimbot Version", nil, 2.5, function() end)
	local function batVersionLabel() return "V" .. tostring(math.clamp(math.floor(tonumber(_G._AdaptBatVersion) or 1), 1, 3)) end
	modeButton(batAimbotVersionRow, batVersionLabel(), function()
		if _G._AdaptBatMode ~= "NORMAL" then
			_G._AdaptBatVersion = 1
			return batVersionLabel()
		end
		local cur = math.clamp(math.floor(tonumber(_G._AdaptBatVersion) or 1), 1, 3)
		_G._AdaptBatVersion = (cur % 3) + 1
		saveConfig()
		return batVersionLabel()
	end)
	_G.__CrystalUpdateBatVersionUI = function() end
		toggleRow(combat, "Mirror TP", "Mirror TP", toggleStates["Mirror TP"], 3.5, false, function(on) setFeature("Mirror TP", on) end)
	toggleRow(combat, "Ragdoll Counter", "Ragdoll Counter", toggleStates["Ragdoll Counter"], 4, false, function(on) setFeature("Ragdoll Counter", on) end)
	sectionLabel(combat, "RAGDOLL", 5)
	toggleRow(combat, "Ragdoll TP", "Ragdoll TP", toggleStates["Ragdoll TP"], 5.5, false, function(on) setFeature("Ragdoll TP", on) end)
	toggleRow(combat, "Anti Ragdoll", "Anti Ragdoll", toggleStates["Anti Ragdoll"], 6, false, function(on) setFeature("Anti Ragdoll", on) end)
	toggleRow(combat, "Medusa Counter", "Medusa Counter", toggleStates["Medusa Counter"], 7, false, function(on) setFeature("Medusa Counter", on) end)
	toggleRow(combat, "Medusa Range Circle", "Medusa Range Circle", toggleStates["Medusa Range Circle"], 7.25, false, function(on) setFeature("Medusa Range Circle", on) end)
	toggleRow(combat, "Anti Bat", "Anti Bat", toggleStates["Anti Bat"], 7.5, false, function(on) setFeature("Anti Bat", on) end)
	toggleRow(combat, "Anti Die", "Anti Die", toggleStates["Anti Die"], 8, false, function(on) setFeature("Anti Die", on) end)
	toggleRow(combat, "Anti Void", "Anti Void", toggleStates["Anti Void"], 8.1, false, function(on) setFeature("Anti Void", on) end)
	toggleRow(combat, "Anti Anti Lose", "Anti Anti Lose", toggleStates["Anti Anti Lose"] == true, 8.36, false, function(on)
		setFeature("Anti Anti Lose", on)
	end)
	toggleRow(combat, "No Player Collision", "No Player Collision", toggleStates["No Player Collision"] == true, 8.5, false, function(on)
		on = on == true
		toggleStates["No Player Collision"] = on
		pcall(saveConfig)
		if _G.__SoundNoPlayerCollision then pcall(function() _G.__SoundNoPlayerCollision.SetEnabled(on) end) end
	end)


	sectionLabel(combat, "TP BAT", 9)
	local tpBatActionRow = actionRow(combat, "TP Bat", "TP Bat", 10, function() end)
	local tpBatVersionButton = modeButton(tpBatActionRow, "V" .. tostring(_G.__batVersion or 1), function()
		local nextVersion = (tonumber(_G.__batVersion) == 2) and 1 or 2
		if _G.__CrystalSetTPBatVersion then nextVersion = _G.__CrystalSetTPBatVersion(nextVersion) else _G.__batVersion = nextVersion end
		return "V" .. tostring(nextVersion)
	end)
	tpBatVersionButton.Name = "TPBatVersionSelector"

	toggleRow(combat, "Steal Bar", "Steal Bar", true, 11, false, function(on)
		setFeature("Steal Bar", on)
	end)
	sectionLabel(combat, "ACTIONS", 12)
	do
	actionRow(combat, "Drop Brainrot", "Drop", 13, function()
	if FeatureToggles.Drop then pcall(FeatureToggles.Drop, "button") end
	end)

	end
	local tpDownActionRow = actionRow(combat, "TP Down", "TP Down", 14, function() if FeatureToggles["TP Down"] then pcall(FeatureToggles["TP Down"]) end end)
	local tpDownKeybind = tpDownActionRow:FindFirstChild("TPDownKeybind")
	if tpDownKeybind then
	tpDownKeybind.Position = UDim2.new(1, isMobile and -39 or -48, 0.5, isMobile and -9 or -11)
	end
	actionRow(combat, "Insta Reset", "Insta Reset", 15, function() if FeatureToggles["Insta Reset"] then pcall(FeatureToggles["Insta Reset"]) end end)
	sectionLabel(combat, "AUTO STEAL", 16)
	local _, autoGrabUiRow = toggleRow(combat, "Auto Steal", "auto steal", toggleStates["auto steal"], 17, false, function(on) setFeature("auto steal", on) end)

	inputRow(combat, "Steal Radius", autoStealValues.Radius, 18, function(value) autoStealValues.Radius = math.clamp(math.floor(value), 10, 150); saveConfig() end)

	-- Auto Steal UI V2 selector removed; the original V1 UI is kept active.
	_G["_SoundHub_UI_AutoGrabSkin"] = "V1"

	-- Auto Steal Version selector: V1 (normal) / V2 (Kyz Duels V3 logic)
	local autoStealVersionRow = actionRow(combat, "Auto Steal Version", nil, 19, function() end)
	local autoStealVersionButton = modeButton(autoStealVersionRow, (function()
		local mode = tostring(autoStealMode or "v1")
		return (mode == "v2" and "V2") or "V1"
	end)(), function()
		if autoStealMode == "v1" then
			autoStealMode = "v2"
		else
			autoStealMode = "v1"
		end
		pcall(saveConfig)
		-- Restart auto steal with new mode
		if toggleStates["auto steal"] then
			setFeature("auto steal", false)
			task.wait(0.1)
			setFeature("auto steal", true)
		end
		return (autoStealMode == "v2" and "V2") or "V1"
	end)
	autoStealVersionButton.Name = "AutoStealVersionSelector"

	-- ============================================================
	-- V2 AUTO STEAL (from Kyz Duels Semi Auto Steal V3)
	-- ============================================================
	local kyzV3State = {
		enabled = false,
		conn = nil,
		active = false,
		holdMin = 1.3,
		holdMax = 2.6,
		entryDelay = 0.3,
		cooldown = 0.05,
		primeRange = 80,
		radius = 8,
		cache = {},
	}

	local function kyzV3FindNearestPrompt()
		local char = Player.Character
		local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
		if not root then return nil end
		local plotsFolder = workspace:FindFirstChild("Plots")
		if not plotsFolder or typeof(plotsFolder) ~= "Instance" then return nil end
		local best, bestDist = nil, math.huge
		for _, plot in ipairs(plotsFolder:GetChildren()) do
			if typeof(plot) ~= "Instance" then continue end
			local sign = plot:FindFirstChild("PlotSign")
			local yourBase = sign and sign:FindFirstChild("YourBase")
			local isMine = yourBase and typeof(yourBase) == "Instance" and yourBase:IsA("BillboardGui") and yourBase.Enabled == true
			if not isMine then
				local pods = plot:FindFirstChild("AnimalPodiums")
				if pods and typeof(pods) == "Instance" then
					for _, pod in ipairs(pods:GetChildren()) do
						if typeof(pod) ~= "Instance" then continue end
						local base = pod:FindFirstChild("Base")
						local spawn = base and base:FindFirstChild("Spawn")
						if spawn and typeof(spawn) == "Instance" then
							local d = (spawn.Position - root.Position).Magnitude
							if d < bestDist and d <= (kyzV3State.primeRange or 60) then
								local att = spawn:FindFirstChild("PromptAttachment")
								if att and typeof(att) == "Instance" then
									for _, ch in ipairs(att:GetChildren()) do
										if ch:IsA("ProximityPrompt") then
											local at = tostring(ch.ActionText or "")
											if at:find("Steal") or at:find("steal") then
												best, bestDist = ch, d
												break
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
		return best
	end

	local function kyzV3BuildCallbacks(prompt)
		if kyzV3State.cache[prompt] then return kyzV3State.cache[prompt] end
		local hold = {}
		local trigger = {}
		pcall(function()
			local c1 = prompt.PromptButtonHoldBegan:Connect(function() end)
			c1:Disconnect()
		end)
		local data = {
			hold = hold,
			trigger = trigger,
			ready = true,
			useFallback = true,
			prompt = prompt,
		}
		kyzV3State.cache[prompt] = data
		return data
	end

	local function kyzV3Execute(prompt)
		if not prompt or not prompt.Parent or kyzV3State.active then return end
		local data = kyzV3BuildCallbacks(prompt)
		if not data or not data.ready then return end
		data.ready = false
		kyzV3State.active = true
		task.spawn(function()
			local startTime = tick()
			-- Fire hold
			pcall(function() prompt:InputHoldBegin() end)

			while kyzV3State.enabled and autoStealMode == "v2" and toggleStates["auto steal"] and (tick() - startTime) < kyzV3State.holdMin do
				if _G.__CrystalAutoGrabRagdollBlocked == true then break end
				task.wait()
			end

			local spawnPart = prompt.Parent and prompt.Parent.Parent
			local alreadyInRange = false
			pcall(function()
				local char = Player.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if root and spawnPart and spawnPart:IsA("BasePart") then
					alreadyInRange = (root.Position - spawnPart.Position).Magnitude <= kyzV3State.radius
				end
			end)

			local fired = false
			while kyzV3State.enabled and autoStealMode == "v2" and toggleStates["auto steal"] and prompt.Parent do
				local elapsed = tick() - startTime
				if elapsed > kyzV3State.holdMax then break end

				local char = Player.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				local spawn = prompt.Parent and prompt.Parent.Parent
				if root and spawn and spawn:IsA("BasePart") then
					local dist = (root.Position - spawn.Position).Magnitude
					if dist <= kyzV3State.radius then
						if not alreadyInRange then
							task.wait(kyzV3State.entryDelay)
						end
						if kyzV3State.enabled and autoStealMode == "v2" and toggleStates["auto steal"] then
							pcall(function() prompt:InputHoldEnd() end)
							fired = true
						end
						break
					end
				else
					break
				end
				task.wait()
			end

			if fired then
				task.wait(0.12)
			end
			task.wait(kyzV3State.cooldown)
			data.ready = true
			kyzV3State.active = false
		end)
	end

	local function kyzV3Start()
		kyzV3State.enabled = true
		if kyzV3State.conn then pcall(function() kyzV3State.conn:Disconnect() end); kyzV3State.conn = nil end
		kyzV3State.conn = RunService.Heartbeat:Connect(function()
			if not toggleStates["auto steal"] or autoStealMode ~= "v2" then return end
			if kyzV3State.active then return end
			if _G.__CrystalAutoGrabRagdollBlocked == true then return end
			local prompt = kyzV3FindNearestPrompt()
			if prompt then kyzV3Execute(prompt) end
		end)
	end

	local function kyzV3Stop()
		kyzV3State.enabled = false
		kyzV3State.active = false
		if kyzV3State.conn then pcall(function() kyzV3State.conn:Disconnect() end); kyzV3State.conn = nil end
	end

	_G.__KyzV3AutoStealStart = kyzV3Start
	_G.__KyzV3AutoStealStop = kyzV3Stop

	local visual = pages.Visual
	sectionLabel(visual, "VISUAL", -2)
	toggleRow(visual, "Vivid Graphics", "Vivid Graphics", toggleStates["Vivid Graphics"], 0, false, function(on) setFeature("Vivid Graphics", on) end)
	toggleRow(visual, "Anti Lag", "Anti Lag", toggleStates["Anti Lag"], 0.25, false, function(on) setFeature("Anti Lag", on) end)
	toggleRow(visual, "FPS Boost", "FPS Boost", toggleStates["FPS Boost"], 0.35, false, function(on) setFeature("FPS Boost", on) end)
	toggleRow(visual, "X-Ray", "X-Ray", toggleStates["X-Ray"], 0.5, false, function(on) setFeature("X-Ray", on) end)
	toggleRow(visual, "ESP Players", "ESP Players", toggleStates["ESP Players"], 1, false, function(on)
	setFeature("ESP Players", on)
	end)
	toggleRow(visual, "Skeleton ESP", "Skeleton ESP", toggleStates["Skeleton ESP"], 1.5, false, function(on)
	setFeature("Skeleton ESP", on)
	end)
	toggleRow(visual, "ESP Line", "Player Tracers", toggleStates["Player Tracers"], 2, false, function(on)
	setFeature("Player Tracers", on)
	end)
	toggleRow(visual, "Stretch Rez", "Stretchz Res", toggleStates["Stretchz Res"], 4, false, function(on) setFeature("Stretchz Res", on) end)
	sectionLabel(visual, "FOV", 5)
	toggleRow(visual, "Custom FOV", "Custom FOV", toggleStates["Custom FOV"], 6, false, function(on)
	setFeature("Custom FOV", on)
	end)
	inputRow(visual, "FOV", speedValues.FOV, 7, function(value)
	speedValues.FOV = math.clamp(math.floor(value), 30, 120)
	setFeature("Custom FOV", true)
	if FeaturePostToggle["Custom FOV"] then pcall(FeaturePostToggle["Custom FOV"], true) end
	local camera = workspace.CurrentCamera; if camera then camera.FieldOfView = speedValues.FOV end
	saveConfig()
	end)
	sectionLabel(visual, "SKY", 8)
	local _, skyThemesUiRow = toggleRow(visual, "Sky Themes", "Sky Changer", toggleStates["Sky Changer"], 9, false, function(on)
	setFeature("Sky Changer", on)
	end)
	modeButton(skyThemesUiRow, string.upper(skyCurrentMode or "blue"), function()
	local order = _G.__SkyPresetOrder
	local idx = 0
	for i, m in ipairs(order) do if m == skyCurrentMode then idx = i break end end
	skyCurrentMode = order[(idx % #order) + 1]
	_G.__CrystalSkyChangerMode = skyCurrentMode
	if toggleStates["Sky Changer"] then applySky(skyCurrentMode) end
	saveConfig()
	return string.upper(skyCurrentMode)
	end)
	local batSkinRow = actionRow(visual, "Custom Bat Skin", nil, 9.5, function() end)
	local visualBatSkinLabels = { ["Default"] = "DEFAULT", ["Abyss Blue"] = "BLUE", ["Venom Green"] = "GREEN", ["Royal Gold"] = "GOLD", ["Velvet Rose"] = "ROSE", ["Crimson Night"] = "CRIMSON", ["RGB"] = "RGB" }
	local batSkinButton = modeButton(batSkinRow, visualBatSkinLabels[batSkinMode] or "DEFAULT", function()
		local current = 1
		for index, mode in ipairs(_G.__CrystalBatSkinModes or {}) do if mode == batSkinMode then current = index; break end end
		local modes = _G.__CrystalBatSkinModes or { "Default" }
		local nextMode = modes[(current % #modes) + 1]
		local selected = _G.__CrystalBatSkinSet and _G.__CrystalBatSkinSet(nextMode) or nextMode
		return visualBatSkinLabels[selected] or selected
	end)
	sectionLabel(visual, "APPEARANCE", 10)

	do
	local appearanceUi = {}
	appearanceUi.add = function(label, featureName, order)
		local ref = {}
		ref.update, ref.row = toggleRow(visual, label, featureName, toggleStates[featureName], order, false, function(on)
			setFeature(featureName, on)
		end)
		ref.refresh = function()
			ref.update(toggleStates[featureName] == true)
		end
		toggleVisualUpdaters[featureName] = ref.refresh
		ref.refresh()
	end
	appearanceUi.add("Sound Skin", "Sound Skin", 10.5)
	appearanceUi.add("Custom Skins", "Violette Custom Skins", 11)
	do
		local function skinLabel(mode)
			local set = (_G._KawatanSkinSets or {})[tostring(mode)]
			local name = set and set.displayName or ("Skin " .. tostring(mode))
			return string.upper(tostring(name))
		end
		local skinRow = actionRow(visual, "Choose Skin", nil, 12, function() end)
		modeButton(skinRow, skinLabel(violetteSkinMode), function()
			local list = {}
			for _, key in ipairs(_G._KawatanSkinSetOrder or {}) do
				if (_G._KawatanSkinSets or {})[key] ~= nil then list[#list + 1] = key end
			end
			if #list == 0 then return skinLabel(violetteSkinMode) end
			local current = 0
			for i, key in ipairs(list) do if key == tostring(violetteSkinMode) then current = i; break end end
			local nextKey = list[(current % #list) + 1]
			local chosen = nextKey
			if _G.__CrystalVioletteSkinSet then
				local ok, result = pcall(_G.__CrystalVioletteSkinSet, nextKey)
				if ok and result then chosen = result end
			end
			return skinLabel(chosen)
		end)
	end
	appearanceUi.add("Headless", "Headless Visual", 13)
	appearanceUi.add("Korblox", "Korblox Visual", 14)
	end


	do
		-- Custom Font picker (Ambitious-style menu)
		local _, fontRow = toggleRow(visual, "Custom Font", "Custom Font", toggleStates["Custom Font"], 15.1, false, function(on)
			setFeature("Custom Font", on)
			if _G.CrystalFonts and _G.CrystalFonts.set then
				pcall(_G.CrystalFonts.set, _G.CrystalFontChoice or "Default")
			end
		end)
		local fontPickerGui = nil
		local function closeFontPicker()
			if fontPickerGui and fontPickerGui.Parent then
				local frame = fontPickerGui:FindFirstChild("Frame")
				if frame then
					local tw = TweenService:Create(frame, TweenInfo.new(0.18), {BackgroundTransparency = 1})
					tw:Play()
					tw.Completed:Connect(function()
						pcall(function() if fontPickerGui then fontPickerGui:Destroy() end end)
						fontPickerGui = nil
					end)
				else
					pcall(function() fontPickerGui:Destroy() end)
					fontPickerGui = nil
				end
			end
		end
		_G.__CrystalFontPickerClose = closeFontPicker

		local pickBtn = modeButton(fontRow, "PICK", function()
			if fontPickerGui and fontPickerGui.Parent then
				closeFontPicker()
				return "PICK"
			end

			local parentGui = ScreenGui
			fontPickerGui = Instance.new("ScreenGui")
			fontPickerGui.Name = "CrystalHubFontPicker"
			fontPickerGui.ResetOnSpawn = false
			fontPickerGui.IgnoreGuiInset = true
			fontPickerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			fontPickerGui.DisplayOrder = 100000
			fontPickerGui.Parent = parentGui.Parent or parentGui

			local fpBack = Instance.new("TextButton")
			fpBack.Name = "Backdrop"
			fpBack.Size = UDim2.new(1, 0, 1, 0)
			fpBack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			fpBack.BackgroundTransparency = 0.45
			fpBack.BorderSizePixel = 0
			fpBack.Text = ""
			fpBack.ZIndex = 1
			fpBack.Parent = fontPickerGui
			fpBack.MouseButton1Click:Connect(closeFontPicker)

			local fpFrame = Instance.new("Frame")
			fpFrame.Name = "Frame"
			fpFrame.Size = UDim2.new(0, 380, 0, 520)
			fpFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
			fpFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
			fpFrame.BorderSizePixel = 0
			fpFrame.ZIndex = 2
			fpFrame.Parent = fontPickerGui
			Instance.new("UICorner", fpFrame).CornerRadius = UDim.new(0, 16)
			local fpStroke = Instance.new("UIStroke", fpFrame)
			fpStroke.Color = (typeof(C) == "table" and C.accent) or Color3.fromRGB(220, 40, 40)
			fpStroke.Thickness = 1.4
			fpStroke.Transparency = 0.25

			local fpBar = Instance.new("Frame")
			fpBar.Size = UDim2.new(1, 0, 0, 48)
			fpBar.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
			fpBar.BorderSizePixel = 0
			fpBar.ZIndex = 3
			fpBar.Parent = fpFrame
			Instance.new("UICorner", fpBar).CornerRadius = UDim.new(0, 16)

			local fpTitle = Instance.new("TextLabel")
			fpTitle.Size = UDim2.new(1, -60, 1, 0)
			fpTitle.Position = UDim2.new(0, 16, 0, 0)
			fpTitle.BackgroundTransparency = 1
			fpTitle.Text = "CUSTOM FONTS"
			fpTitle.TextColor3 = Color3.fromRGB(245, 245, 250)
			fpTitle.Font = Enum.Font.GothamBlack
			fpTitle.TextSize = 15
			fpTitle.TextXAlignment = Enum.TextXAlignment.Left
			fpTitle.ZIndex = 4
			fpTitle.Parent = fpBar
			fpTitle:SetAttribute("CrystalFontLock", true)

			local fpClose = Instance.new("TextButton")
			fpClose.Size = UDim2.new(0, 32, 0, 32)
			fpClose.Position = UDim2.new(1, -40, 0.5, -16)
			fpClose.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
			fpClose.BorderSizePixel = 0
			fpClose.Text = "X"
			fpClose.TextColor3 = Color3.fromRGB(255, 255, 255)
			fpClose.Font = Enum.Font.GothamBlack
			fpClose.TextSize = 14
			fpClose.ZIndex = 5
			fpClose.Parent = fpBar
			Instance.new("UICorner", fpClose).CornerRadius = UDim.new(0, 8)
			fpClose:SetAttribute("CrystalFontLock", true)
			fpClose.MouseButton1Click:Connect(closeFontPicker)

			local fpScroll = Instance.new("ScrollingFrame")
			fpScroll.Size = UDim2.new(1, -16, 1, -60)
			fpScroll.Position = UDim2.new(0, 8, 0, 52)
			fpScroll.BackgroundTransparency = 1
			fpScroll.BorderSizePixel = 0
			fpScroll.ScrollBarThickness = 4
			fpScroll.ScrollBarImageColor3 = (typeof(C) == "table" and C.accent) or Color3.fromRGB(220, 40, 40)
			fpScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
			fpScroll.ZIndex = 3
			fpScroll.Parent = fpFrame

			local FP_COLS, FP_CELL, FP_GAP = 3, 110, 8
			local FP_STEP = FP_CELL + FP_GAP
			local fpList = {}
			pcall(function()
				if _G.CrystalFonts and _G.CrystalFonts.list then
					fpList = _G.CrystalFonts.list()
				end
			end)
			if type(fpList) ~= "table" or #fpList == 0 then
				fpList = {{ key = "Default", label = "Default", font = nil }}
			end
			local fpRows = math.ceil(#fpList / FP_COLS)
			fpScroll.CanvasSize = UDim2.new(0, 0, 0, 16 + fpRows * FP_STEP)

			local fpPool = {}
			local function fpEntryOf(card)
				local idx = card:GetAttribute("FontIdx")
				return idx and fpList[idx] or nil
			end
			local function fpPaint()
				for _, c in ipairs(fpPool) do
					local e = fpEntryOf(c)
					local chosen = _G.CrystalFontChoice
					if chosen == "Starborn" then local d = _G.CrystalFonts.byKey("Starborn"); chosen = d and d.key or "Default" end
					local sel = e and (chosen == e.key)
					local st = c:FindFirstChildOfClass("UIStroke")
					if st then
						st.Color = sel and ((typeof(C) == "table" and C.accent) or Color3.fromRGB(220, 40, 40)) or Color3.fromRGB(60, 60, 70)
						st.Transparency = sel and 0 or 0.45
						st.Thickness = sel and 2.2 or 1.1
					end
				end
			end
			local function fpBind(card, idx)
				local e = fpList[idx]
				if not e then
					card:SetAttribute("FontIdx", nil)
					card.Visible = false
					return
				end
				local row = math.floor((idx - 1) / FP_COLS)
				local col = (idx - 1) % FP_COLS
				card.Position = UDim2.new(0, 6 + col * FP_STEP, 0, 6 + row * FP_STEP)
				card:SetAttribute("FontIdx", idx)
				local prv = card:FindFirstChild("Preview")
				if prv then
					if e.font then
						pcall(function() prv.FontFace = e.font end)
					else
						prv.Font = Enum.Font.GothamBlack
					end
				end
				local nl = card:FindFirstChild("FontName")
				if nl then nl.Text = e.label end
				card.Visible = true
			end

			local poolCount = (math.ceil(456 / FP_STEP) + 2) * FP_COLS
			for j = 1, poolCount do
				local card = Instance.new("TextButton")
				card.Name = "FontCard_" .. tostring(j)
				card.Size = UDim2.new(0, FP_CELL, 0, FP_CELL)
				card.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
				card.BorderSizePixel = 0
				card.Text = ""
				card.AutoButtonColor = false
				card.Visible = false
				card.ZIndex = 4
				card.ClipsDescendants = true
				card.Parent = fpScroll
				Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)
				local cardStroke = Instance.new("UIStroke", card)
				cardStroke.Color = Color3.fromRGB(60, 60, 70)
				cardStroke.Thickness = 1.1
				cardStroke.Transparency = 0.45

				local prv = Instance.new("TextLabel")
				prv.Name = "Preview"
				prv.Size = UDim2.new(1, -8, 0, 48)
				prv.Position = UDim2.new(0, 4, 0, 10)
				prv.BackgroundTransparency = 1
				prv.Text = "Aa"
				prv.TextColor3 = Color3.fromRGB(245, 245, 250)
				prv.Font = Enum.Font.GothamBlack
				prv.TextSize = 34
				prv.ZIndex = 5
				prv.Parent = card
				prv:SetAttribute("CrystalFontLock", true)

				local nameLbl = Instance.new("TextLabel")
				nameLbl.Name = "FontName"
				nameLbl.Size = UDim2.new(1, -8, 0, 28)
				nameLbl.Position = UDim2.new(0, 4, 1, -32)
				nameLbl.BackgroundTransparency = 1
				nameLbl.Text = ""
				nameLbl.TextColor3 = Color3.fromRGB(180, 180, 190)
				nameLbl.Font = Enum.Font.GothamBold
				nameLbl.TextSize = 9
				nameLbl.TextWrapped = true
				nameLbl.ZIndex = 5
				nameLbl.Parent = card
				nameLbl:SetAttribute("CrystalFontLock", true)

				card.MouseButton1Click:Connect(function()
					local e = fpEntryOf(card)
					if not e then return end
					if _G.CrystalFonts and _G.CrystalFonts.set then
						_G.CrystalFontChoice = e.key
						if not toggleStates["Custom Font"] then setFeature("Custom Font", true) end
						pcall(_G.CrystalFonts.set, e.key)
					else
						_G.CrystalFontChoice = e.key
						if not toggleStates["Custom Font"] then setFeature("Custom Font", true) end
					end
					pcall(function() if saveConfig then saveConfig() end end)
					fpPaint()
				end)
				fpPool[#fpPool + 1] = card
			end

			local fpFirstRow = -1
			local function fpRender()
				local first = math.max(0, math.floor((fpScroll.CanvasPosition.Y - 6) / FP_STEP) - 1)
				if first == fpFirstRow then return end
				fpFirstRow = first
				for j, card in ipairs(fpPool) do
					fpBind(card, first * FP_COLS + j)
				end
				fpPaint()
			end
			fpScroll:GetPropertyChangedSignal("CanvasPosition"):Connect(fpRender)
			fpRender()

			fpFrame.Size = UDim2.fromOffset(0, 0)
			fpFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
			TweenService:Create(fpFrame, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.fromOffset(380, 520),
				Position = UDim2.new(0.5, -190, 0.5, -260),
			}):Play()

			return "PICK"
		end)
		pickBtn.Name = "CustomFontMode"
		task.defer(function()
			task.wait(0.6)
			if _G.CrystalFonts and _G.CrystalFonts.set and toggleStates["Custom Font"] then
				pcall(_G.CrystalFonts.set, _G.CrystalFontChoice, true)
			elseif _G.CrystalFonts and _G.CrystalFonts.set then
				pcall(_G.CrystalFonts.set, _G.CrystalFontChoice or "Default", true)
			end
		end)
	end

	-- "Motion Blur" row removed: the screen is never blurred any more.
	-- Tabs Position control removed: sidebar-only UI

	-- Color selection removed; keep the interface locked to purple.
	_G["_SoundHub_UI_ColorTheme"] = "purple"
	_G.__CrystalHalloweenMode = false
	if toggleStates then toggleStates["Halloween Mode"] = false end

	toggleRow(visual, "Quick Buttons", "Show Buttons", toggleStates["Show Buttons"], 16, false, function(on)
	setFeature("Show Buttons", on)
	end)
	-- Choose which on-screen buttons you want (same list as the "<" arrow on screen)
	do
	local QB_MENU_LABELS = {
		"AUTO LEFT", "AUTO RIGHT", "TP BAT", "BAT AIMBOT", "DROP", "TP DOWN",
		"LAGGER MODE", "LAGGER CARRY", "INSTA RESET", "CARRY MODE",
	}
	if type(_G.__CrystalHiddenQuickButtons) ~= "table" then _G.__CrystalHiddenQuickButtons = {} end
	local function qbOff(label)
		local v = _G.__CrystalHiddenQuickButtons[label]
		if v == nil then return label == "AUTO PLAY" or label == "CUSTOM SPEED" end
		return v == true
	end
	for i, label in ipairs(QB_MENU_LABELS) do
		local qbRow = actionRow(visual, label, nil, 16.51 + i * 0.005, function() end)
		modeButton(qbRow, qbOff(label) and "OFF" or "ON", function()
			_G.__CrystalHiddenQuickButtons[label] = not qbOff(label)
			pcall(saveConfig)
			return qbOff(label) and "OFF" or "ON"
		end)
	end
	end
	sectionLabel(visual, "MENU", 16.5)
	do
	local sizeRow = actionRow(visual, "Buttons Size", nil, 16.5, function() end)
	local sizeBox = keepOriginalText(Instance.new("TextBox"))
	sizeBox.Name = "ButtonsSizeInput"
	sizeBox.Size = UDim2.fromOffset(64, isMobile and 22 or 26)
	sizeBox.AnchorPoint = Vector2.new(1, 0.5)
	sizeBox.Position = UDim2.new(1, -10, 0.5, 0)
	sizeBox.BackgroundColor3 = C.accentDim
	sizeBox:SetAttribute("CurtThemeRole", "AccentDim")
	sizeBox:SetAttribute("CurtThemeAccentInput", true)
	sizeBox.BorderSizePixel = 0
	sizeBox.TextColor3 = C.text
	sizeBox.Font = Enum.Font.GothamBold
	sizeBox.TextSize = 12
	sizeBox.Text = tostring(_G.__CrystalButtonsSize or 1)
	sizeBox.PlaceholderText = "0.5 - 2"
	sizeBox.ClearTextOnFocus = false
	sizeBox.ZIndex = 8
	sizeBox.Parent = sizeRow
	corner(sizeBox, 5)
	sizeBox.FocusLost:Connect(function()
		sizeBox.Text = tostring(_G.__CrystalSetButtonsSize(sizeBox.Text))
	end)
	end
	do
	local guiScaleRow = actionRow(visual, "GUI Scale", nil, 16.55, function() end)
	local guiScaleBox = keepOriginalText(Instance.new("TextBox"))
	guiScaleBox.Name = "GuiScaleInput"
	guiScaleBox.Size = UDim2.fromOffset(64, isMobile and 22 or 26)
	guiScaleBox.AnchorPoint = Vector2.new(1, 0.5)
	guiScaleBox.Position = UDim2.new(1, -10, 0.5, 0)
	guiScaleBox.BackgroundColor3 = C.accentDim
	guiScaleBox:SetAttribute("CurtThemeRole", "AccentDim")
	guiScaleBox:SetAttribute("CurtThemeAccentInput", true)
	guiScaleBox.BorderSizePixel = 0
	guiScaleBox.TextColor3 = C.text
	guiScaleBox.Font = Enum.Font.GothamBold
	guiScaleBox.TextSize = 12
	guiScaleBox.Text = string.format("%.2f", math.clamp(tonumber(_G.__CrystalGuiScale) or 1, 0.50, 1.50))
	guiScaleBox.PlaceholderText = "0.50 - 1.50"
	guiScaleBox.ClearTextOnFocus = false
	guiScaleBox.ZIndex = 8
	guiScaleBox.Parent = guiScaleRow
	corner(guiScaleBox, 5)
	guiScaleBox.FocusLost:Connect(function()
		local applied = 1
		if type(_G.__CrystalApplyGuiScale) == "function" then
			applied = _G.__CrystalApplyGuiScale(guiScaleBox.Text)
		else
			local n = tonumber(guiScaleBox.Text)
			if n then
				applied = math.clamp(n, 0.50, 1.50)
				_G.__CrystalGuiScale = applied
			else
				applied = math.clamp(tonumber(_G.__CrystalGuiScale) or 1, 0.50, 1.50)
			end
		end
		guiScaleBox.Text = string.format("%.2f", applied)
	end)
	end
	do
	local grabScaleRow = actionRow(visual, "Auto Grab Scale", nil, 16.56, function() end)
	local grabScaleBox = keepOriginalText(Instance.new("TextBox"))
	grabScaleBox.Name = "AutoGrabScaleInput"
	grabScaleBox.Size = UDim2.fromOffset(64, isMobile and 22 or 26)
	grabScaleBox.AnchorPoint = Vector2.new(1, 0.5)
	grabScaleBox.Position = UDim2.new(1, -10, 0.5, 0)
	grabScaleBox.BackgroundColor3 = C.accentDim
	grabScaleBox:SetAttribute("CurtThemeRole", "AccentDim")
	grabScaleBox:SetAttribute("CurtThemeAccentInput", true)
	grabScaleBox.BorderSizePixel = 0
	grabScaleBox.TextColor3 = C.text
	grabScaleBox.Font = Enum.Font.GothamBold
	grabScaleBox.TextSize = 12
	grabScaleBox.Text = string.format("%.2f", math.clamp(tonumber(_G["_SoundHub_UI_AutoGrabBarScale"]) or 1, 0.6, 1.6))
	grabScaleBox.PlaceholderText = "0.60 - 1.60"
	grabScaleBox.ClearTextOnFocus = false
	grabScaleBox.ZIndex = 8
	grabScaleBox.Parent = grabScaleRow
	corner(grabScaleBox, 5)
	grabScaleBox.FocusLost:Connect(function()
		local n = tonumber(grabScaleBox.Text)
		local applied = math.clamp(tonumber(_G["_SoundHub_UI_AutoGrabBarScale"]) or 1, 0.6, 1.6)
		if n and n == n and math.abs(n) < math.huge then
			applied = math.clamp(math.floor(n * 100 + 0.5) / 100, 0.6, 1.6)
		end
		_G["_SoundHub_UI_AutoGrabBarScale"] = applied
		if type(_G.__CrystalSetAutoGrabBarScale) == "function" then
			pcall(_G.__CrystalSetAutoGrabBarScale, applied)
		else
			pcall(function()
				local bar = ScreenGui:FindFirstChild("SoundAutoGrabBar", true)
				if bar then
					local sc = bar:FindFirstChildOfClass("UIScale")
					if sc then sc.Scale = applied end
				end
			end)
		end
		grabScaleBox.Text = string.format("%.2f", applied)
		pcall(saveConfig)
	end)
	end
	-- Tabs Position toggle removed; tabs are permanently fixed to Top.
	_G.__CrystalTabPosition = "Top"

	do
	local shapeHolder = Instance.new("Frame")
	shapeHolder.Name = "ButtonsShapePicker"
	shapeHolder.Size = UDim2.new(1, 0, 0, isMobile and 92 or 108)
	shapeHolder.BackgroundColor3 = C.row
	shapeHolder:SetAttribute("CurtThemeRole", "Row")
	shapeHolder.BackgroundTransparency = 0.4
	shapeHolder.BorderSizePixel = 0
	shapeHolder.LayoutOrder = 16.6
	shapeHolder.Parent = visual
	corner(shapeHolder, 14); stroke(shapeHolder, C.accent, 1).Transparency = 0.8
	local shTitle = keepOriginalText(Instance.new("TextLabel"))
	shTitle.Size = UDim2.new(1, -24, 0, 20)
	shTitle.Position = UDim2.new(0, isMobile and 8 or 12, 0, 4)
	shTitle.BackgroundTransparency = 1
	shTitle.Text = "Buttons Shape"
	shTitle.TextColor3 = C.text
	shTitle.TextSize = MODERN.textSize
	shTitle.Font = Enum.Font.GothamBold
	shTitle.TextXAlignment = Enum.TextXAlignment.Left
	shTitle.ZIndex = 8
	shTitle.Parent = shapeHolder
	local cards = {}
	local function refreshShapeCards()
		local cur = (_G.__CrystalButtonsShape == "Rectangle") and "Rectangle" or "Circle"
		for name, card in pairs(cards) do
			local on = (name == cur)
			card.frame.BackgroundColor3 = on and C.accent or C.accentDim
			card.frame.BackgroundTransparency = on and 0.35 or 0.7
			card.stroke.Transparency = on and 0 or 0.7
			card.stroke.Thickness = on and 2 or 1
			card.label.Text = (name == "Circle" and "CIRCLE" or "RECTANGULAR") .. (on and "  \226\156\147" or "")
		end
	end
	local function makeShapeCard(name, xScale)
		local card = keepOriginalText(Instance.new("TextButton"))
		card.Name = name .. "Card"
		card.Size = UDim2.new(0.5, -14, 1, -34)
		card.Position = UDim2.new(xScale, xScale == 0 and 8 or 6, 0, 26)
		card.BackgroundColor3 = C.accentDim
		card.BackgroundTransparency = 0.7
		card.BorderSizePixel = 0
		card.AutoButtonColor = false
		card.Text = ""
		card.ZIndex = 8
		card.Parent = shapeHolder
		corner(card, 12)
		local st = stroke(card, C.accent, 1)
		-- preview of the button shape
		local prev = Instance.new("Frame")
		prev.Size = UDim2.new(0, isMobile and 34 or 40, 0, isMobile and 34 or 40)
		prev.Position = UDim2.new(0.5, isMobile and -17 or -20, 0, 6)
		prev.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
		prev.BorderSizePixel = 0
		prev.ZIndex = 9
		prev.Parent = card
		local pc = Instance.new("UICorner", prev)
		pc.CornerRadius = (name == "Circle") and UDim.new(1, 0) or UDim.new(0, 8)
		local ps = Instance.new("UIStroke", prev)
		ps.Color = Color3.fromRGB(0, 140, 255)
		ps.Thickness = 2
		local lbl = Instance.new("TextLabel")
		lbl.BackgroundTransparency = 1
		lbl.Size = UDim2.new(1, 0, 0, 14)
		lbl.Position = UDim2.new(0, 0, 1, -16)
		lbl.TextColor3 = C.text
		lbl.TextSize = isMobile and 8 or 9
		lbl.Font = Enum.Font.GothamBold
		lbl.ZIndex = 9
		lbl.Parent = card
		cards[name] = { frame = card, stroke = st, label = lbl }
		card.MouseButton1Click:Connect(function()
			if _G.__CrystalSetButtonsShape then
				pcall(_G.__CrystalSetButtonsShape, name)
			else
				_G.__CrystalButtonsShape = name
				pcall(saveConfig)
			end
			refreshShapeCards()
		end)
	end
	makeShapeCard("Circle", 0)
	makeShapeCard("Rectangle", 0.5)
	refreshShapeCards()
	toggleVisualUpdaters["ButtonsShapePicker"] = refreshShapeCards
	end
	actionRow(visual, "Reset Panel Positions", nil, 16.8, function()
		local function centerFrame(frame, fallbackW, fallbackH)
			if not frame then return nil, nil end
			local cam = workspace.CurrentCamera
			local vp = cam and cam.ViewportSize or Vector2.new(800, 600)
			local w = (frame.AbsoluteSize and frame.AbsoluteSize.X > 0) and frame.AbsoluteSize.X or (fallbackW or 260)
			local h = (frame.AbsoluteSize and frame.AbsoluteSize.Y > 0) and frame.AbsoluteSize.Y or (fallbackH or 220)
			local x = math.max(0, math.floor((vp.X - w) / 2))
			local y = math.max(0, math.floor((vp.Y - h) / 2))
			frame.Position = UDim2.fromOffset(x, y)
			return x, y
		end

		-- Main menu → center
		pcall(function()
			if Panel then
				centerFrame(Panel, PANEL_W, PANEL_H)
				_G["_SoundHub_UI_MenuPos"] = nil
			end
		end)


		-- Other registered GUI resetters (AutoGrab, Enemy, mini buttons, etc.)
		if type(_G.__CrystalGuiPositionResetters) == "table" then
			for _, resetFn in pairs(_G.__CrystalGuiPositionResetters) do
				pcall(resetFn)
			end
		end

		_G.__CrystalGuiPositionsReset = true
		pcall(saveConfig)
	end)
	actionRow(visual, "reset butons pos.", nil, 17, function()
	_G.__CrystalResetButtonPositions()
	end)
	toggleRow(visual, "Lock Buttons", "Lock Buttons", toggleStates["Lock Buttons"], 18, false, function(on)
	setFeature("Lock Buttons", on)
	end)
	actionRow(visual, "Hide GUI Key", "Toggle UI", 19, function() Panel.Visible = false end)

	local animations = pages.Visual
	sectionLabel(animations, "ANIMATIONS", 22)

	-- Original Sound named animation presets + Custom (save/load by preset name)
	local animationChoiceNames = {}
	-- Prefer full named list from the Uranium animations section when present
	if type(animationPresets) == "table" then
		local order = {
			"Adidas Sports", "Adidas Community", "Adidas Aura", "Wicked Popular", "Elder", "Zombie", "Mage",
			"Catwalk Glam", "Astronaut", 'Wicked "Dancing Through Life"', "Werewolf", "Superhero", "Toy",
			"No Boundaries", "NFL", "Amazon Unboxed", "Vampire", "Ninja", "Robot", "Levitation", "Stylish", "Bubbly", "Cartoon",
		}
		for _, name in ipairs(order) do
			if animationPresets[name] then table.insert(animationChoiceNames, name) end
		end
		-- any extra presets not in default order
		for name, _ in pairs(animationPresets) do
			local found = false
			for _, n in ipairs(animationChoiceNames) do if n == name then found = true break end end
			if not found then table.insert(animationChoiceNames, name) end
		end
	end
	if #animationChoiceNames == 0 and type(animationPresetOrder) == "table" then
		for _, presetName in ipairs(animationPresetOrder) do
			if presetName ~= "NONE" and not tostring(presetName):match("^Pack%s+%d+$") and presetName ~= "CUSTOM" then
				table.insert(animationChoiceNames, presetName)
			end
		end
	end
	if #animationChoiceNames == 0 then
		animationChoiceNames = { "Cartoon", "Zombie", "Ninja", "Robot", "Superhero", "Stylish", "Bubbly" }
	end
	table.insert(animationChoiceNames, "Custom")
	local namedAnimationPresets = type(animationPresets) == "table" and animationPresets
		or (type(_G.__SoundNamedAnimationPresets) == "table" and _G.__SoundNamedAnimationPresets)
		or {}
	animationPresets = namedAnimationPresets
	local customAnimationIds = type(_G.__CrystalCustomAnimationIds) == "table" and _G.__CrystalCustomAnimationIds or {}
	_G.__CrystalCustomAnimationIds = customAnimationIds
	local selectedSourcePreset = tostring(_G.__CrystalAnimationPreset or "")
	local selectedChoiceIndex = 1
	for i, choice in ipairs(animationChoiceNames) do
		if choice == selectedSourcePreset then selectedChoiceIndex = i break end
	end
	if selectedSourcePreset == "" or (selectedChoiceIndex == 1 and animationChoiceNames[1] ~= selectedSourcePreset) then
		-- try exact match again; else default first named preset
		local matched = false
		for i, choice in ipairs(animationChoiceNames) do
			if choice == selectedSourcePreset then selectedChoiceIndex = i; matched = true; break end
		end
		if not matched then
			selectedChoiceIndex = 1
			selectedSourcePreset = animationChoiceNames[1]
		end
	else
		selectedSourcePreset = animationChoiceNames[selectedChoiceIndex]
	end
	_G.__CrystalAnimationPreset = selectedSourcePreset

	local sourceAnimationOriginals = _G.__SoundNamedAnimationOriginals
	if type(sourceAnimationOriginals) ~= "table" then
		sourceAnimationOriginals = setmetatable({}, {__mode = "k"})
		_G.__SoundNamedAnimationOriginals = sourceAnimationOriginals
	end
	local animationSlots = {"idle", "walk", "run", "jump", "fall"}
	local animationSlotTargets = {
		idle = {"idle1", "idle2"}, walk = {"walk"}, run = {"run"}, jump = {"jump"}, fall = {"fall"},
	}
	local presetLabel, customPanel
	local function sourceAssetId(value)
		if type(value) == "number" then return value > 0 and ("rbxassetid://" .. tostring(math.floor(value))) or nil end
		if type(value) ~= "string" then return nil end
		local digits = value:match("rbxassetid://(%d+)") or value:match("^%s*(%d+)%s*$")
		return digits and tonumber(digits) and tonumber(digits) > 0 and ("rbxassetid://" .. digits) or nil
	end
	local function getAnimationTargets(character)
		local animate = character and (character:FindFirstChild("Animate") or character:WaitForChild("Animate", 3))
		if not animate then return nil, nil end
		local idle = animate:FindFirstChild("idle")
		local walk = animate:FindFirstChild("walk")
		local run = animate:FindFirstChild("run")
		local jump = animate:FindFirstChild("jump")
		local fall = animate:FindFirstChild("fall")
		local climb = animate:FindFirstChild("climb")
		local swim = animate:FindFirstChild("swim")
		local swimIdle = animate:FindFirstChild("swimidle")
		local targets = {
			idle1 = idle and idle:FindFirstChild("Animation1"), idle2 = idle and idle:FindFirstChild("Animation2"),
			walk = walk and walk:FindFirstChild("WalkAnim"), run = run and run:FindFirstChild("RunAnim"),
			jump = jump and jump:FindFirstChild("JumpAnim"), fall = fall and fall:FindFirstChild("FallAnim"),
			climb = climb and climb:FindFirstChild("ClimbAnim"), swim = swim and swim:FindFirstChild("Swim"),
			swimidle = swimIdle and swimIdle:FindFirstChild("SwimIdle"),
		}
		return animate, targets
	end
	local function ensureOriginalAnimationIds(character, targets)
		local saved = sourceAnimationOriginals[character]
		if type(saved) ~= "table" then saved = {}; sourceAnimationOriginals[character] = saved end
		for slot, target in pairs(targets) do
			if target and saved[slot] == nil then
				local ok, id = pcall(function() return target.AnimationId end)
				if ok then saved[slot] = id end
			end
		end
		return saved
	end
	local function restoreNamedAnimationIds(character)
		if not character then return end
		local _, targets = getAnimationTargets(character)
		if not targets then return end
		local saved = sourceAnimationOriginals[character]
		if type(saved) == "table" then
			for slot, target in pairs(targets) do
				if target and saved[slot] ~= nil then pcall(function() target.AnimationId = saved[slot] end) end
			end
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do pcall(function() track:Stop(0) end) end
		end
	end
	local function buildSelectedAnimationValues()
		local values = {}
		if selectedSourcePreset == "Custom" then
			local idleId = sourceAssetId(customAnimationIds.idle)
			if idleId then values.idle1, values.idle2 = idleId, idleId end
			for _, slot in ipairs({"walk", "run", "jump", "fall"}) do
				local id = sourceAssetId(customAnimationIds[slot])
				if id then values[slot] = id end
			end
			return values
		end
		local preset = namedAnimationPresets[selectedSourcePreset]
		if type(preset) ~= "table" then return values end
		local idle = preset.Idle or {}
		local presetValues = {
			idle1 = preset.Animation1 or idle[1], idle2 = preset.Animation2 or idle[2],
			walk = preset.WalkAnim or preset.Walk, run = preset.RunAnim or preset.Run,
			jump = preset.JumpAnim or preset.Jump, fall = preset.FallAnim or preset.Fall,
			climb = preset.ClimbAnim or preset.Climb, swim = preset.Swim or preset.SwimAnim,
			swimidle = preset.SwimIdle or preset.SwimIdleAnim,
		}
		for slot, value in pairs(presetValues) do
			local id = sourceAssetId(value)
			if id then values[slot] = id end
		end
		return values
	end
	local function applySelectedAnimation(character)
		character = character or Player.Character
		if not character then return false end
		-- Clean-style packs own Animate ids while a named pack is active
		local packName = tostring(_G.__CrystalAnimationPackPreset or "Off")
		if packName ~= "Off" and packName ~= "NONE" and packName ~= "" then return false end
		local _, targets = getAnimationTargets(character)
		if not targets then return false end
		local saved = ensureOriginalAnimationIds(character, targets)
		for slot, target in pairs(targets) do
			if target and saved[slot] ~= nil then pcall(function() target.AnimationId = saved[slot] end) end
		end
		local values = buildSelectedAnimationValues()
		for slot, id in pairs(values) do
			local target = targets[slot]
			if target then pcall(function() target.AnimationId = id end) end
		end
		-- Force-refresh: stop tracks, toggle Animate, nudge humanoid state
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do pcall(function() track:Stop(0) end) end
		end
		local animate = character:FindFirstChild("Animate")
		if animate then
			pcall(function()
				animate.Disabled = true
				task.defer(function()
					if animate and animate.Parent then animate.Disabled = false end
				end)
			end)
		end
		if humanoid then
			pcall(function()
				if humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
					humanoid:ChangeState(Enum.HumanoidStateType.Running)
				end
			end)
		end
		return true
	end
	local function setAnimationChoice(index)
		selectedChoiceIndex = math.clamp(math.floor(tonumber(index) or 1), 1, #animationChoiceNames)
		selectedSourcePreset = animationChoiceNames[selectedChoiceIndex]
		_G.__CrystalAnimationPreset = selectedSourcePreset
		if presetLabel and presetLabel.Parent then presetLabel.Text = selectedSourcePreset end
		local isCustom = (selectedSourcePreset == "Custom" or selectedSourcePreset == "CUSTOM")
		if customPanel and customPanel.Parent then customPanel.Visible = isCustom end

		-- Original Sound: write AnimationIds into Animate script
		if toggleStates["Animations"] then
			applySelectedAnimation(Player.Character)
		else
			setFeature("Animations", true)
		end
		pcall(saveConfig)
		return selectedChoiceIndex
	end
	_G.__CrystalSetAnimationChoice = setAnimationChoice
	_G.__CrystalSetAnimationPack = setAnimationChoice
	_G.__CrystalGetAnimationPack = function() return selectedChoiceIndex, selectedSourcePreset end

	local presetSelector = Instance.new("Frame")
	presetSelector.Size = UDim2.new(1, 0, 0, 42)
	presetSelector.BackgroundColor3 = C.row
	presetSelector:SetAttribute("CurtThemeRole", "Row")
	presetSelector.BackgroundTransparency = 0.5
	presetSelector.BorderSizePixel = 0
	presetSelector.LayoutOrder = 23
	presetSelector.Parent = animations
	corner(presetSelector, 10); stroke(presetSelector, C.divider, 1)
	local previousPresetButton = keepOriginalText(Instance.new("TextButton"))
	previousPresetButton.Size = UDim2.new(0, 42, 1, -8)
	previousPresetButton.Position = UDim2.new(0, 4, 0, 4)
	previousPresetButton.BackgroundColor3 = C.accentDim
	previousPresetButton:SetAttribute("CurtThemeRole", "AccentDim")
	previousPresetButton.BackgroundTransparency = 0.2
	previousPresetButton.BorderSizePixel = 0
	previousPresetButton.Text = "<"
	previousPresetButton.TextColor3 = C.text
	previousPresetButton.TextSize = 18
	previousPresetButton.Font = Enum.Font.GothamBlack
	previousPresetButton.Parent = presetSelector
	corner(previousPresetButton, 7)
	presetLabel = keepOriginalText(Instance.new("TextLabel"))
	presetLabel.Size = UDim2.new(1, -100, 1, 0)
	presetLabel.Position = UDim2.new(0, 50, 0, 0)
	presetLabel.BackgroundTransparency = 1
	presetLabel.TextColor3 = C.text
	presetLabel.TextSize = 10
	presetLabel.TextWrapped = true
	presetLabel.Font = Enum.Font.GothamBold
	presetLabel.Text = selectedSourcePreset
	presetLabel.Parent = presetSelector
	local nextPresetButton = keepOriginalText(Instance.new("TextButton"))
	nextPresetButton.Size = UDim2.new(0, 42, 1, -8)
	nextPresetButton.Position = UDim2.new(1, -46, 0, 4)
	nextPresetButton.BackgroundColor3 = C.accentDim
	nextPresetButton:SetAttribute("CurtThemeRole", "AccentDim")
	nextPresetButton.BackgroundTransparency = 0.2
	nextPresetButton.BorderSizePixel = 0
	nextPresetButton.Text = ">"
	nextPresetButton.TextColor3 = C.text
	nextPresetButton.TextSize = 18
	nextPresetButton.Font = Enum.Font.GothamBlack
	nextPresetButton.Parent = presetSelector
	corner(nextPresetButton, 7)
	previousPresetButton.MouseButton1Click:Connect(function() setAnimationChoice(selectedChoiceIndex - 1) end)
	nextPresetButton.MouseButton1Click:Connect(function() setAnimationChoice(selectedChoiceIndex + 1) end)

	customPanel = Instance.new("Frame")
	customPanel.Name = "CustomAnimationPackEditor"
	customPanel.Size = UDim2.new(1, 0, 0, 150)
	customPanel.BackgroundColor3 = C.row
	customPanel:SetAttribute("CurtThemeRole", "Row")
	customPanel.BackgroundTransparency = 0.48
	customPanel.BorderSizePixel = 0
	customPanel.LayoutOrder = 24
	customPanel.Visible = (selectedSourcePreset == "Custom")
	customPanel.Parent = animations
	corner(customPanel, 10); stroke(customPanel, C.divider, 1).Transparency = 0.55
	local customTitle = keepOriginalText(Instance.new("TextLabel"))
	customTitle.Size = UDim2.new(1, -14, 0, 18)
	customTitle.Position = UDim2.new(0, 8, 0, 3)
	customTitle.BackgroundTransparency = 1
	customTitle.Text = "CUSTOM ASSET IDS (IDLE APPLIES TO BOTH IDLE SLOTS)"
	customTitle.TextColor3 = C.textDim
	customTitle.TextSize = 8
	customTitle.Font = Enum.Font.GothamBold
	customTitle.TextXAlignment = Enum.TextXAlignment.Left
	customTitle.Parent = customPanel
	for index, slot in ipairs(animationSlots) do
		local row = Instance.new("Frame")
		row.Name = "CustomAnimation_" .. slot
		row.Size = UDim2.new(1, -12, 0, 22)
		row.Position = UDim2.new(0, 6, 0, 23 + (index - 1) * 24)
		row.BackgroundColor3 = C.bgDark
		row:SetAttribute("CurtThemeRole", "BgDark")
		row.BackgroundTransparency = 0.35
		row.BorderSizePixel = 0
		row.Parent = customPanel
		corner(row, 6)
		local label = keepOriginalText(Instance.new("TextLabel"))
		label.Size = UDim2.new(0, 54, 1, 0)
		label.Position = UDim2.new(0, 7, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = string.upper(slot)
		label.TextColor3 = C.textMuted
		label.TextSize = 8
		label.Font = Enum.Font.GothamBold
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = row
		local box = keepOriginalText(Instance.new("TextBox"))
		box.Size = UDim2.new(1, -68, 1, -2)
		box.Position = UDim2.new(0, 62, 0, 1)
		box.BackgroundTransparency = 1
		box.Text = tostring(customAnimationIds[slot] or "")
		box.PlaceholderText = "asset id (blank uses original)"
		box.TextColor3 = C.text
		box.PlaceholderColor3 = C.textMuted
		box.TextSize = 9
		box.Font = Enum.Font.Gotham
		box.ClearTextOnFocus = false
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.Parent = row
		box.FocusLost:Connect(function()
			local digits = tostring(box.Text):match("(%d+)")
			local numericId = digits and tonumber(digits)
			customAnimationIds[slot] = (numericId and numericId > 0) and tostring(math.floor(numericId)) or ""
			_G.__CrystalCustomAnimationIds = customAnimationIds
			box.Text = customAnimationIds[slot]
			_G.__CrystalAnimationPreset = "Custom"
			if selectedSourcePreset == "Custom" and toggleStates["Animations"] then
				applySelectedAnimation(Player.Character)
			end
			pcall(saveConfig)
		end)
	end

	FeaturePostToggle["Animations"] = function(active)
		toggleStates["Harder Hit Anim"] = false
		if active then
			_G.__CrystalAnimationPreset = selectedSourcePreset
			applySelectedAnimation(Player.Character)
			pcall(saveConfig)
		else
			restoreNamedAnimationIds(Player.Character)
			pcall(saveConfig)
		end
		if toggleVisualUpdaters["Harder Hit Anim"] then pcall(toggleVisualUpdaters["Harder Hit Anim"]) end
	end
	local animationToggleUpdater, animationToggleRow = toggleRow(
		animations,
		"Animations",
		"Animations",
		toggleStates["Animations"],
		25,
		false,
		function(on) setFeature("Animations", on) end
	)
	animationToggleRow.Name = "AnimationsMasterToggle"
	toggleVisualUpdaters["Animations"] = function() animationToggleUpdater(toggleStates["Animations"] == true) end
	animationToggleUpdater(toggleStates["Animations"] == true)
	local animationInfo = keepOriginalText(Instance.new("TextLabel"))
	animationInfo.Size = UDim2.new(1, -8, 0, 34)
	animationInfo.BackgroundTransparency = 1
	animationInfo.LayoutOrder = 26
	animationInfo.Text = "Original named animations are restored; Custom is the last choice. Turn the switch off to return to your avatar's default animations."
	animationInfo.TextColor3 = C.textDim
	animationInfo.TextSize = 9
	animationInfo.Font = Enum.Font.Gotham
	animationInfo.TextWrapped = true
	animationInfo.TextXAlignment = Enum.TextXAlignment.Left
	animationInfo.Parent = animations

	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(character)
		-- Retry loop: apply animations once Animate script exists
		local function retryApply(attempts)
			for i = 1, attempts do
				task.wait(0.5)
				if not character.Parent then return end
				if character:FindFirstChild("Animate") and toggleStates["Animations"] then
					pcall(function() applySelectedAnimation(character) end)
					return
				end
			end
		end
		task.spawn(function() retryApply(8) end)
	end))
	_G.__CrystalTrackStopper(function() restoreNamedAnimationIds(Player.Character) end)
	if toggleStates["Animations"] then
		-- Initial load: retry applying until Animate exists
		task.spawn(function()
			for i = 1, 10 do
				task.wait(0.5)
				local char = Player.Character
				if not char then continue end
				local animate = char:FindFirstChild("Animate")
				if animate then
					-- On execution, cycle the saved-on feature once the character's Animate
					-- script exists, so animation IDs are reloaded instead of merely reusing
					-- a stale Animate state.
					if toggleStates["Animations"] then
						pcall(FeaturePostToggle["Animations"], false)
						task.wait(0.12)
						if not char.Parent or not toggleStates["Animations"] then return end
						pcall(FeaturePostToggle["Animations"], true)
					end
					pcall(function() applySelectedAnimation(char) end)
					-- Apply again after Animate has had time to rebuild its tracks.
					task.wait(0.5)
					if char and char.Parent and toggleStates["Animations"] then
						pcall(function() applySelectedAnimation(char) end)
					end
					return
				end
			end
		end)
	end

	do
		-- Route every section to its tab: Main / Speed / Combat / Visual / Sets.
		local SECTION_TARGET = {
			["CONTROLS"] = "Main", ["ACTIONS"] = "Main", ["AUTO STEAL"] = "Main",
			["SPEED CONFIGURATION"] = "Speed", ["LAGGER SPEED"] = "Speed", ["MOVEMENT SETTINGS"] = "Speed", ["TP DOWN"] = "Speed",
			["BAT CONTROLS"] = "Combat", ["RAGDOLL"] = "Combat", ["TP BAT"] = "Combat",
			["ANIMATIONS"] = "Sets", ["FOV"] = "Visual", ["SKY"] = "Visual", ["BACKGROUND IMAGE"] = "Visual",
			["GUI"] = "Sets", ["PANELS"] = "Sets",
			["APPEARANCE"] = "Sets", ["ANIMATION SOURCE"] = "Sets", ["ANIMATION PACKS"] = "Sets",
		}
		for _, sourceName in ipairs({"Movement", "Combat", "Visual"}) do
			local source = pages[sourceName]
			local items = {}
			for index, child in ipairs(source:GetChildren()) do
				if child:IsA("GuiObject") then table.insert(items, { child = child, index = index }) end
			end
			table.sort(items, function(a, b)
				if a.child.LayoutOrder ~= b.child.LayoutOrder then return a.child.LayoutOrder < b.child.LayoutOrder end
				return a.index < b.index
			end)
			local target
			for _, item in ipairs(items) do
				local title = item.child:GetAttribute("SectionTitle")
				if title and SECTION_TARGET[title] then target = SECTION_TARGET[title]; break end
			end
			for _, item in ipairs(items) do
				local title = item.child:GetAttribute("SectionTitle")
				if title and SECTION_TARGET[title] then target = SECTION_TARGET[title] end
				item.child.Parent = pages[target or sourceName]
			end
		end
		if pages.Movement then pages.Movement:Destroy(); pages.Movement = nil end
		pageScales.Movement = nil
	end

	;(function()
	-- =====================================================================
	-- AVATAR TAB + FLOATING AVATAR PANEL (preview, skin packs, swords, more)
	-- All visuals are client-side (only you see them).
	-- =====================================================================
	local openBtn
	local isOpen = false
	local vpSize = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(1280, 720)
	local PW = math.min(isMobile and 440 or 540, vpSize.X - 16)
	local PH = math.min(isMobile and 300 or 370, vpSize.Y - 24)

	local function mk(class, props, parent)
		local o = Instance.new(class)
		for k, v in pairs(props) do o[k] = v end
		if parent then o.Parent = parent end
		return o
	end

	local panel = mk("Frame", {
		Name = "SoundAvatarPanel", AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(PW, PH),
		BackgroundColor3 = C.bg, BackgroundTransparency = 0.04, BorderSizePixel = 0,
		Active = true, Visible = false, ClipsDescendants = true, ZIndex = 950,
	}, ScreenGui)
	corner(panel, 14)
	local panelStroke = stroke(panel, C.accent, 1.5)
	panelStroke.Transparency = 0.35
	local panelScale = mk("UIScale", {Scale = 0.9}, panel)

	local head = mk("Frame", {
		Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = C.bgDark,
		BackgroundTransparency = 0.25, BorderSizePixel = 0, ZIndex = 951,
	}, panel)
	mk("TextLabel", {
		Size = UDim2.new(1, -60, 1, 0), Position = UDim2.fromOffset(14, 0),
		BackgroundTransparency = 1, Text = "AVATAR", TextColor3 = C.text,
		Font = Enum.Font.GothamBlack, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 952,
	}, head)
	local closeBtn = mk("TextButton", {
		Size = UDim2.fromOffset(26, 26), Position = UDim2.new(1, -34, 0.5, -13),
		BackgroundColor3 = C.accentDim, BackgroundTransparency = 0.2, BorderSizePixel = 0,
		Text = "X", TextColor3 = C.text, Font = Enum.Font.GothamBlack, TextSize = 13,
		AutoButtonColor = false, ZIndex = 953,
	}, head)
	corner(closeBtn, 7)

	-- ---------- left: live avatar preview ----------
	local previewHolder = mk("Frame", {
		Position = UDim2.fromOffset(10, 46), Size = UDim2.new(0.38, -14, 1, -56),
		BackgroundColor3 = C.row, BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 951,
	}, panel)
	corner(previewHolder, 10)
	stroke(previewHolder, C.accent, 1).Transparency = 0.55
	local viewport = mk("ViewportFrame", {
		Size = UDim2.new(1, 0, 1, -28), BackgroundTransparency = 1,
		Ambient = Color3.fromRGB(190, 190, 190), LightColor = Color3.fromRGB(255, 255, 255),
		LightDirection = Vector3.new(-0.3, -0.5, -0.8), ZIndex = 952,
	}, previewHolder)
	local world = mk("WorldModel", {}, viewport)
	local cam = mk("Camera", {FieldOfView = 38}, viewport)
	cam.CFrame = CFrame.lookAt(Vector3.new(0, 0.4, 9.5), Vector3.new(0, 0.2, 0))
	viewport.CurrentCamera = cam
	local previewMsg = mk("TextLabel", {
		Size = UDim2.new(1, 0, 1, -28), BackgroundTransparency = 1, Text = "LOADING",
		TextColor3 = C.textDim, Font = Enum.Font.GothamBold, TextSize = 10, ZIndex = 953,
	}, previewHolder)
	mk("TextLabel", {
		Position = UDim2.new(0, 0, 1, -26), Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1,
		Text = Player.DisplayName, TextColor3 = C.text, Font = Enum.Font.GothamBold,
		TextSize = 11, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 953,
	}, previewHolder)

	local currentRig
	local function setRig(rig)
		if currentRig then pcall(function() currentRig:Destroy() end) end
		currentRig = rig
		if not rig then previewMsg.Text = "N/A"; previewMsg.Visible = true; return end
		for _, d in ipairs(rig:GetDescendants()) do
			if d:IsA("BasePart") then
				d.Anchored = true; d.CanCollide = false; d.CastShadow = false
			elseif d:IsA("LuaSourceContainer") or d:IsA("BillboardGui") or d:IsA("Highlight")
				or d:IsA("Sound") or d:IsA("Tool") then
				pcall(function() d:Destroy() end)
			end
		end
		pcall(function() rig.PrimaryPart = rig:FindFirstChild("HumanoidRootPart") end)
		local hum = rig:FindFirstChildOfClass("Humanoid")
		if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
		rig.Parent = world
		pcall(function() rig:PivotTo(CFrame.Angles(0, math.pi, 0)) end)
		previewMsg.Visible = false
	end

	local function refreshPreview()
		task.spawn(function()
			local rig
			local char = Player.Character
			if char then
				local prev = char.Archivable
				pcall(function() char.Archivable = true end)
				local ok, cl = pcall(function() return char:Clone() end)
				pcall(function() char.Archivable = prev end)
				if ok then rig = cl end
			end
			if not rig then
				pcall(function() rig = Players:CreateHumanoidModelFromUserId(Player.UserId) end)
			end
			setRig(rig)
		end)
	end

	local spinConn
	local angle = math.pi
	local function startSpin()
		if spinConn then return end
		spinConn = RunService.RenderStepped:Connect(function(dt)
			angle = angle + dt * 0.9
			if currentRig and currentRig.Parent then
				pcall(function() currentRig:PivotTo(CFrame.Angles(0, angle, 0)) end)
			end
		end)
		_G.__CrystalTrackConn(spinConn)
	end
	local function stopSpin()
		if spinConn then spinConn:Disconnect(); spinConn = nil end
	end

	-- ---------- right: tabs + bodies ----------
	local right = mk("Frame", {
		Position = UDim2.new(0.38, 4, 0, 46), Size = UDim2.new(0.62, -14, 1, -56),
		BackgroundTransparency = 1, ZIndex = 951,
	}, panel)
	local tabRow = mk("Frame", {Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, ZIndex = 951}, right)
	mk("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, tabRow)

	local CELL = isMobile and UDim2.fromOffset(78, 98) or UDim2.fromOffset(96, 120)
	local bodies, tabButtons = {}, {}
	local function newBody(name, grid)
		local sf = mk("ScrollingFrame", {
			Name = name, Position = UDim2.fromOffset(0, 34), Size = UDim2.new(1, 0, 1, -34),
			BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
			ScrollBarImageColor3 = C.accent, AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(), Visible = false, ZIndex = 952,
		}, right)
		mk("UIPadding", {PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 2), PaddingRight = UDim.new(0, 4)}, sf)
		if grid then
			mk("UIGridLayout", {CellSize = CELL, CellPadding = UDim2.fromOffset(6, 6), SortOrder = Enum.SortOrder.LayoutOrder}, sf)
		else
			mk("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, sf)
		end
		bodies[name] = sf
		return sf
	end
	local skinsBody = newBody("SKINS", true)
	local swordsBody = newBody("SWORDS", true)
	local moreBody = newBody("MORE", false)

	local refreshers = {}
	local function showTab(name)
		for n, body in pairs(bodies) do body.Visible = (n == name) end
		for n, b in pairs(tabButtons) do
			b.BackgroundTransparency = (n == name) and 0.15 or 0.65
			b.TextColor3 = (n == name) and C.text or C.textMuted
		end
		for _, fn in ipairs(refreshers) do pcall(fn) end
	end
	for i, name in ipairs({"SKINS", "SWORDS", "MORE"}) do
		local b = mk("TextButton", {
			LayoutOrder = i, Size = UDim2.new(1 / 3, -4, 1, 0), BackgroundColor3 = C.accentDim,
			BackgroundTransparency = 0.65, BorderSizePixel = 0, Text = name, TextColor3 = C.textMuted,
			Font = Enum.Font.GothamBlack, TextSize = isMobile and 10 or 11, AutoButtonColor = false, ZIndex = 953,
		}, tabRow)
		corner(b, 8)
		tabButtons[name] = b
		b.Activated:Connect(function() showTab(name) end)
	end

	-- small helper for a selectable card
	local function newCard(parent, order, labelText)
		local card = mk("TextButton", {
			LayoutOrder = order, BackgroundColor3 = C.row, BackgroundTransparency = 0.35,
			BorderSizePixel = 0, Text = "", AutoButtonColor = false, ZIndex = 953,
		}, parent)
		corner(card, 10)
		local st = stroke(card, C.accent, 1)
		st.Transparency = 0.75
		mk("TextLabel", {
			Position = UDim2.new(0, 4, 1, -22), Size = UDim2.new(1, -8, 0, 18), BackgroundTransparency = 1,
			Text = labelText, TextColor3 = C.text, Font = Enum.Font.GothamBold, TextSize = isMobile and 8 or 9,
			TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 956,
		}, card)
		return card, st
	end

	-- ---------- SKINS ----------
	local skinCards = {}
	local function refreshSkinCards()
		local active = toggleStates["Violette Custom Skins"] == true and tostring(_G._KawatanSkinColor or "")
		for key, entry in pairs(skinCards) do
			local on = (key == "NONE" and not active) or (key == active)
			entry.stroke.Transparency = on and 0.05 or 0.75
			entry.stroke.Thickness = on and 2.5 or 1
			entry.stroke.Color = C.accent
		end
	end
	table.insert(refreshers, refreshSkinCards)

	do -- default / remove skin
		local card, st = newCard(skinsBody, 0, "DEFAULT")
		mk("TextLabel", {
			Size = UDim2.new(1, 0, 1, -24), BackgroundTransparency = 1, Text = "NO\nSKIN",
			TextColor3 = C.textDim, Font = Enum.Font.GothamBlack, TextSize = 14, ZIndex = 955,
		}, card)
		skinCards["NONE"] = {card = card, stroke = st}
		card.Activated:Connect(function()
			if toggleStates["Violette Custom Skins"] then setFeature("Violette Custom Skins", false) end
			refreshSkinCards()
			task.delay(1.2, refreshPreview)
		end)
	end

	local function skinPic(skin)
		local id = skin.accessories and skin.accessories[1]
		if not id then id = tonumber(tostring(skin.hats or ""):match("%d+")) end
		return id and ("rbxthumb://type=Asset&id=" .. tostring(id) .. "&w=150&h=150") or ""
	end
	for index, key in ipairs(_G._KawatanSkinSetOrder or {}) do
		local skin = (_G._KawatanSkinSets or {})[key]
		if skin then
			local card, st = newCard(skinsBody, index, tostring(skin.displayName or key))
			local pic = mk("ImageLabel", {
				Position = UDim2.fromOffset(6, 6), Size = UDim2.new(1, -12, 1, -32),
				BackgroundColor3 = C.bgDark, BackgroundTransparency = 0.3, BorderSizePixel = 0,
				Image = skinPic(skin), ScaleType = Enum.ScaleType.Fit, ZIndex = 955,
			}, card)
			corner(pic, 8)
			skinCards[tostring(key)] = {card = card, stroke = st}
			card.Activated:Connect(function()
				if _G._CrystalCustomSkinPicked then pcall(_G._CrystalCustomSkinPicked, key) end
				refreshSkinCards()
				-- instant preview from the pack, then re-sync from the real character
				task.spawn(function()
					local desc
					pcall(function() desc = _G._KawatanBuildSetDescription and _G._KawatanBuildSetDescription(key) end)
					if desc then
						local rig
						pcall(function() rig = Players:CreateHumanoidModelFromDescription(desc, Enum.HumanoidRigType.R15) end)
						pcall(function() desc:Destroy() end)
						if rig then setRig(rig) end
					end
					task.wait(2)
					if isOpen then refreshPreview() end
				end)
			end)
		end
	end

	-- ---------- SWORDS (procedural, with pictures) ----------
	local SWORDS = {
		{name = "Steel Blade",  blade = Color3.fromRGB(205, 210, 222), mat = Enum.Material.Metal, guard = Color3.fromRGB(140, 105, 50), grip = Color3.fromRGB(70, 45, 28),  len = 4.2, w = 0.42},
		{name = "Frost Edge",   blade = Color3.fromRGB(150, 225, 255), mat = Enum.Material.Neon,  guard = Color3.fromRGB(210, 240, 255), grip = Color3.fromRGB(40, 70, 110), len = 4.6, w = 0.40},
		{name = "Inferno",      blade = Color3.fromRGB(255, 110, 30),  mat = Enum.Material.Neon,  guard = Color3.fromRGB(60, 20, 10),   grip = Color3.fromRGB(30, 12, 8),   len = 4.6, w = 0.48},
		{name = "Void Saber",   blade = Color3.fromRGB(170, 60, 255),  mat = Enum.Material.Neon,  guard = Color3.fromRGB(20, 10, 35),   grip = Color3.fromRGB(15, 8, 25),   len = 5.0, w = 0.36},
		{name = "Golden King",  blade = Color3.fromRGB(255, 215, 90),  mat = Enum.Material.Metal, guard = Color3.fromRGB(255, 190, 40), grip = Color3.fromRGB(110, 20, 20), len = 4.8, w = 0.55},
		{name = "Emerald Katana", blade = Color3.fromRGB(90, 255, 150), mat = Enum.Material.Neon, guard = Color3.fromRGB(20, 60, 40),  grip = Color3.fromRGB(15, 35, 25),  len = 5.2, w = 0.24},
		{name = "Plasma Beam",  blade = Color3.fromRGB(120, 255, 255), mat = Enum.Material.Neon,  guard = Color3.fromRGB(60, 65, 75),   grip = Color3.fromRGB(40, 42, 50),   len = 4.4, w = 0.28},
		{name = "Blood Reaper", blade = Color3.fromRGB(150, 15, 25),   mat = Enum.Material.Metal, guard = Color3.fromRGB(20, 20, 20),   grip = Color3.fromRGB(35, 8, 10),   len = 5.0, w = 0.5},
	}
	local function buildSword(def)
		local model = Instance.new("Model")
		model.Name = "SoundAvatarSword"
		local function part(name, size, cf, color, material, shape)
			local p = Instance.new("Part")
			p.Name = name; p.Size = size; p.CFrame = cf; p.Color = color
			p.Material = material or Enum.Material.SmoothPlastic
			if shape then p.Shape = shape end
			p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
			p.CanCollide = false; p.CanTouch = false; p.CanQuery = false; p.Massless = true
			p.Parent = model
			return p
		end
		local handle = part("Handle", Vector3.new(0.3, 1.2, 0.3), CFrame.new(), def.grip, Enum.Material.SmoothPlastic)
		local parts = {
			part("Pommel", Vector3.new(0.5, 0.5, 0.5), CFrame.new(0, -0.7, 0), def.guard, Enum.Material.Metal, Enum.PartType.Ball),
			part("Guard",  Vector3.new(1.5, 0.25, 0.45), CFrame.new(0, 0.72, 0), def.guard, Enum.Material.Metal),
		}
		local bladeBase = 0.845
		parts[#parts + 1] = part("Blade", Vector3.new(def.w, def.len, 0.14), CFrame.new(0, bladeBase + def.len / 2, 0), def.blade, def.mat)
		local s = def.w * 0.7071
		parts[#parts + 1] = part("Tip", Vector3.new(s, s, 0.14), CFrame.new(0, bladeBase + def.len, 0) * CFrame.Angles(0, 0, math.rad(45)), def.blade, def.mat)
		for _, p in ipairs(parts) do
			local weld = Instance.new("Weld")
			weld.Part0 = handle; weld.Part1 = p
			weld.C0 = handle.CFrame:ToObjectSpace(p.CFrame)
			weld.Parent = p
		end
		model.PrimaryPart = handle
		return model
	end

	local equippedSword
	local function removeSword()
		local c = Player.Character
		local old = c and c:FindFirstChild("SoundAvatarSword")
		if old then old:Destroy() end
	end
	local function equipSword(idx)
		removeSword()
		equippedSword = idx
		local c = Player.Character
		local def = idx and SWORDS[idx]
		if not (c and def) then return end
		local hand = c:FindFirstChild("RightHand") or c:FindFirstChild("Right Arm")
		if not hand then return end
		local sword = buildSword(def)
		local handle = sword.PrimaryPart
		local weld = Instance.new("Weld")
		weld.Part0 = hand; weld.Part1 = handle
		local yOff = (hand.Name == "RightHand") and -0.15 or -0.95
		weld.C0 = CFrame.new(0, yOff, -0.1) * CFrame.Angles(math.rad(-90), 0, 0)
		weld.Parent = handle
		sword.Parent = c
	end

	local swordCards = {}
	local function refreshSwordCards()
		for key, entry in pairs(swordCards) do
			local on = (key == "NONE" and not equippedSword) or (key == equippedSword)
			entry.stroke.Transparency = on and 0.05 or 0.75
			entry.stroke.Thickness = on and 2.5 or 1
			entry.stroke.Color = C.accent
		end
	end
	table.insert(refreshers, refreshSwordCards)

	do
		local card, st = newCard(swordsBody, 0, "NO SWORD")
		mk("TextLabel", {
			Size = UDim2.new(1, 0, 1, -24), BackgroundTransparency = 1, Text = "NONE",
			TextColor3 = C.textDim, Font = Enum.Font.GothamBlack, TextSize = 14, ZIndex = 955,
		}, card)
		swordCards["NONE"] = {card = card, stroke = st}
		card.Activated:Connect(function()
			removeSword(); equippedSword = nil
			refreshSwordCards()
			task.delay(0.3, refreshPreview)
		end)
	end
	for i, def in ipairs(SWORDS) do
		local card, st = newCard(swordsBody, i, def.name)
		local vf = mk("ViewportFrame", {
			Position = UDim2.fromOffset(6, 6), Size = UDim2.new(1, -12, 1, -32),
			BackgroundColor3 = C.bgDark, BackgroundTransparency = 0.3, BorderSizePixel = 0,
			Ambient = Color3.fromRGB(170, 170, 170), LightColor = Color3.fromRGB(255, 255, 255),
			LightDirection = Vector3.new(-0.3, -0.5, -0.8), ZIndex = 955,
		}, card)
		corner(vf, 8)
		local wm = mk("WorldModel", {}, vf)
		local vcam = mk("Camera", {FieldOfView = 40}, vf)
		vf.CurrentCamera = vcam
		local model = buildSword(def)
		for _, p in ipairs(model:GetDescendants()) do
			if p:IsA("BasePart") then p.Anchored = true end
		end
		model.Parent = wm
		local half = def.len / 2 + 0.2
		model:PivotTo(CFrame.Angles(0, math.rad(30), math.rad(-32)) * CFrame.new(0, -half, 0))
		vcam.CFrame = CFrame.lookAt(Vector3.new(0, 0, 8.5 + def.len * 0.25), Vector3.new(0, 0, 0))
		swordCards[i] = {card = card, stroke = st}
		card.Activated:Connect(function()
			equipSword(i)
			refreshSwordCards()
			task.delay(0.3, refreshPreview)
		end)
	end

	-- ---------- MORE ----------
	local outlineOn = false
	local function applyOutline()
		local c = Player.Character
		if not c then return end
		local h = c:FindFirstChild("SoundAvatarOutline")
		if outlineOn then
			if not h then
				h = Instance.new("Highlight")
				h.Name = "SoundAvatarOutline"
				h.FillTransparency = 1
				h.OutlineTransparency = 0
				h.Parent = c
			end
			h.OutlineColor = C.accent
		elseif h then
			h:Destroy()
		end
	end

	local function moreRow(text, stateFn, click)
		local row = mk("TextButton", {
			Size = UDim2.new(1, -6, 0, 36), BackgroundColor3 = C.row, BackgroundTransparency = 0.45,
			AutoButtonColor = false, Text = "", BorderSizePixel = 0, ZIndex = 953,
		}, moreBody)
		corner(row, 8)
		mk("TextLabel", {
			Size = UDim2.new(1, -74, 1, 0), Position = UDim2.fromOffset(10, 0), BackgroundTransparency = 1,
			Text = text, TextColor3 = C.text, Font = Enum.Font.GothamBold, TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 954,
		}, row)
		local st = mk("TextLabel", {
			Size = UDim2.fromOffset(52, 20), Position = UDim2.new(1, -60, 0.5, -10),
			BackgroundColor3 = C.accentDim, BackgroundTransparency = 0.3, Text = "",
			TextColor3 = C.text, Font = Enum.Font.GothamBold, TextSize = 10, ZIndex = 954,
		}, row)
		corner(st, 6)
		local function refresh()
			local v = stateFn and stateFn()
			st.Text = (v == nil) and "TAP" or (v and "ON" or "OFF")
			st.BackgroundColor3 = v and C.accent or C.accentDim
		end
		row.Activated:Connect(function() click(); refresh(); task.delay(0.6, function() if isOpen then refreshPreview() end end) end)
		table.insert(refreshers, refresh)
		refresh()
	end

	moreRow("Headless", function() return toggleStates["Headless Visual"] == true end, function()
		setFeature("Headless Visual", not (toggleStates["Headless Visual"] == true))
	end)
	moreRow("Korblox Leg", function() return toggleStates["Korblox Visual"] == true end, function()
		setFeature("Korblox Visual", not (toggleStates["Korblox Visual"] == true))
	end)
	moreRow("Neon Outline", function() return outlineOn end, function()
		outlineOn = not outlineOn
		applyOutline()
	end)
	moreRow("Reset Avatar", nil, function()
		removeSword(); equippedSword = nil
		outlineOn = false; applyOutline()
		if toggleStates["Headless Visual"] then setFeature("Headless Visual", false) end
		if toggleStates["Korblox Visual"] then setFeature("Korblox Visual", false) end
		if toggleStates["Violette Custom Skins"] then setFeature("Violette Custom Skins", false) end
		for _, fn in ipairs(refreshers) do pcall(fn) end
		task.delay(1.2, refreshPreview)
	end)

	-- re-apply sword / outline after respawn
	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(char)
		task.spawn(function()
			char:WaitForChild("Humanoid", 10)
			task.wait(1)
			if equippedSword then equipSword(equippedSword) end
			if outlineOn then applyOutline() end
			if isOpen then refreshPreview() end
		end)
	end))

	-- ---------- open / close ----------
	local function setOpen(open)
		isOpen = open
		if open then
			panel.Visible = true
			panelScale.Scale = 0.9
			tween(panelScale, {Scale = 1}, 0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			refreshPreview()
			startSpin()
			for _, fn in ipairs(refreshers) do pcall(fn) end
		else
			tween(panelScale, {Scale = 0.9}, 0.14)
			stopSpin()
			task.delay(0.16, function() if not isOpen then panel.Visible = false end end)
		end
		if openBtn then openBtn.Text = open and "CLOSE" or "OPEN" end
	end
	closeBtn.Activated:Connect(function() setOpen(false) end)
	_G.__SoundAvatarPanel = {
		Open = function() setOpen(true) end,
		Close = function() setOpen(false) end,
		Toggle = function() setOpen(not isOpen) end,
	}

	-- drag by header
	do
		local dragging, dragStart, startPos
		head.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true; dragStart = input.Position; startPos = panel.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then dragging = false end
				end)
			end
		end)
		_G.__CrystalTrackConn(UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local d = input.Position - dragStart
				panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
			end
		end))
	end

	showTab("SKINS")

	-- ---------- Avatar tab page ----------
	local avatarPage = pages.Sets
	if avatarPage then
		sectionLabel(avatarPage, "AVATAR PANEL", 900)
		local openRow = actionRow(avatarPage, "Avatar Panel", nil, 901, function()
			setOpen(not isOpen)
		end)
		openBtn = modeButton(openRow, "OPEN", function()
			setOpen(not isOpen)
			return isOpen and "CLOSE" or "OPEN"
		end)
		openBtn.Name = "AvatarPanelToggle"
	end
	end)()


	local activeCategory = "Main"
	for order, name in ipairs({"Main", "Speed", "Combat", "Visual", "Sets"}) do
	local button = keepOriginalText(Instance.new("TextButton"))
	button.Name = name .. "Button"
	-- Sidebar tabs (vertical)
	button.Size = UDim2.new(1, -4, 0, isMobile and 34 or 38)
	button.BackgroundColor3 = C.accentDim
	button:SetAttribute("CurtThemeRole", "AccentDim")
	button.BackgroundTransparency = name == activeCategory and 0.25 or 1
	button.BorderSizePixel = 0
	button.Text = string.upper(name)
	button.TextColor3 = name == activeCategory and C.text or C.textMuted
	button.TextSize = isMobile and 7 or 9
	button.Font = Enum.Font.GothamBold
	button.LayoutOrder = order
	button.Parent = categoryList
	corner(button, 10)
	local indicator = Instance.new("Frame")
	indicator.Name = "Indicator"
	indicator.Size = UDim2.new(0, name == activeCategory and 18 or 0, 0, 2)
	indicator.Position = UDim2.new(0.5, name == activeCategory and -9 or 0, 1, -4)
	indicator.BackgroundColor3 = C.accent
	indicator:SetAttribute("CurtThemeRole", "Accent")
	indicator.BackgroundTransparency = name == activeCategory and 0 or 1
	indicator.BorderSizePixel = 0
	indicator.Parent = button
	Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
	button.MouseButton1Click:Connect(function()
	if activeCategory == name then return end
	activeCategory = name
	for pageName, page in pairs(pages) do
	local selectedPage = pageName == name
	page.Visible = selectedPage
	if selectedPage then
	local pageScale = pageScales[pageName]
	if pageScale then
	pageScale.Scale = 0.975
	tween(pageScale, {Scale = 1}, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	end
	end
	end
	for _, other in ipairs(categoryList:GetChildren()) do
	if other:IsA("TextButton") then
	local selected = other.Name == name .. "Button"
	tween(other, {
	TextColor3 = selected and C.text or C.textMuted,
	BackgroundTransparency = selected and 0.25 or 1,
	}, 0.18)
	local mark = other:FindFirstChild("Indicator")
	if mark then
	tween(mark, {
	BackgroundTransparency = selected and 0 or 1,
	Size = UDim2.new(0, selected and 18 or 0, 0, 2),
	Position = UDim2.new(0.5, selected and -9 or 0, 1, -4),
	}, 0.2)
	end
	end
	end
	end)
	button.MouseEnter:Connect(function()
	if activeCategory ~= name then tween(button, {TextColor3 = C.text, BackgroundTransparency = 0.7}) end
	end)
	button.MouseLeave:Connect(function()
	if activeCategory ~= name then tween(button, {TextColor3 = C.textMuted, BackgroundTransparency = 1}) end
	end)
	end
	refreshCategoryTextColors = function()
	for _, categoryButton in ipairs(categoryList:GetChildren()) do
	if categoryButton:IsA("TextButton") then
	categoryButton.TextColor3 = (categoryButton.Name == activeCategory .. "Button") and C.text or C.textMuted
	end
	end
	end
	refreshCategoryTextColors()
	do
		_G.__CrystalTabPosition = "Top"
		applyMenuUiLayout("1")
	end
	if _G.__CrystalApplyCurtVisualTheme then pcall(_G.__CrystalApplyCurtVisualTheme, bgIndex) end

	-- Mini button (side): circular avatar logo that opens the menu
	local miniButton = Instance.new("ImageButton")
	miniButton.Name = "EclipseRestoreButton"
	-- Title-image only mini button (no avatar logo, no .GG tag)
	local miniW = _G.__CrystalRealMobile and 128 or 150
	local miniH = _G.__CrystalRealMobile and 42 or 48
	miniButton.Size = UDim2.new(0, miniW, 0, miniH)
	local savedMiniPos = _G["_SoundHub_UI_ModernMiniPos"]
	miniButton.Position = savedMiniPos and UDim2.fromOffset(savedMiniPos.x or 10, savedMiniPos.y or 120) or UDim2.new(0, 10, 0.5, -miniH / 2)
	miniButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	miniButton.BorderSizePixel = 0
	miniButton.AutoButtonColor = false
	miniButton.Image = ""
	miniButton.ImageTransparency = 1
	miniButton.ScaleType = Enum.ScaleType.Fit
	miniButton.Visible = not Panel.Visible
	miniButton.ZIndex = 900
	miniButton.ClipsDescendants = true
	miniButton.Parent = ScreenGui
	Instance.new("UICorner", miniButton).CornerRadius = UDim.new(1, 0)
	local miniStroke = Instance.new("UIStroke", miniButton)
	miniStroke.Color = C.accent
	miniStroke.Thickness = 1
	miniStroke.Transparency = 1 -- no outline: plain black pill
	-- Menu background image inside the mini button (same art as the main menu)
	local miniBg = Instance.new("ImageLabel")
	miniBg.Name = "MiniMenuBg"
	miniBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	miniBg.BackgroundTransparency = 0
	miniBg.BorderSizePixel = 0
	miniBg.Size = UDim2.new(1, 0, 1, 0)
	miniBg.ScaleType = Enum.ScaleType.Crop
	miniBg.ImageTransparency = 0
	miniBg.ZIndex = 901
	miniBg.Image = "rbxassetid://91655003484305"
	miniBg.Parent = miniButton
	Instance.new("UICorner", miniBg).CornerRadius = UDim.new(1, 0)
	miniBg.Image = "rbxassetid://91655003484305"
	do
		-- black pill: "Sound DUELS" text only, theme coloured (purple on the purple theme)
		local miniText = Instance.new("TextLabel")
		miniText.Name = "MiniHubText"
		miniText.BackgroundTransparency = 1
		miniText.AnchorPoint = Vector2.new(0, 0.5)
		miniText.Position = UDim2.new(0, 0, 0.5, 0)
		miniText.Size = UDim2.new(1, 0, 1, 0)
		miniText.Font = Enum.Font.GothamBlack
		miniText.Text = ""
		miniText.Visible = false
		miniText.ZIndex = 902
		miniText.Parent = miniButton
	end
	do
		local miniTitle = Instance.new("ImageLabel")
		miniTitle.Name = "MiniTitle"
		miniTitle.BackgroundTransparency = 1
		miniTitle.Size = UDim2.new(1, -10, 1, -8)
		miniTitle.Position = UDim2.new(0, 5, 0, 4)
		miniTitle.ScaleType = Enum.ScaleType.Fit
		miniTitle.Image = CURT_WORD_IMAGE
		miniTitle.ImageColor3 = Color3.fromRGB(255, 255, 255)
		miniTitle.Visible = false -- replaced by the dot + text pill
		miniTitle.ZIndex = 902
		miniTitle.Parent = miniButton

		local function syncMiniTitleImage()
			local titleImg = CURT_WORD_IMAGE
			pcall(function()
				if _G.__CrystalHalloweenMode == true then
					titleImg = (_G.HALLOWEEN_TITLE_IMAGE) or titleImg
				elseif type(_G.__CrystalCurtWordImage) == "string" and _G.__CrystalCurtWordImage ~= "" then
					titleImg = _G.__CrystalCurtWordImage
				end
			end)
			pcall(function()
				local ct = "purple"
				if _G.__CrystalHalloweenMode == true and type(HALLOWEEN_TITLE_IMAGE) == "string" then
					titleImg = HALLOWEEN_TITLE_IMAGE
				elseif ct == "purple" and type(PURPLE_TITLE_IMAGE) == "string" then
					titleImg = PURPLE_TITLE_IMAGE
				elseif ct == "green" and type(GREEN_TITLE_IMAGE) == "string" then
					titleImg = GREEN_TITLE_IMAGE
				elseif ct == "azure" and type(AZURE_TITLE_IMAGE) == "string" then
					titleImg = AZURE_TITLE_IMAGE
				end
			end)
			if miniTitle and miniTitle.Parent then
				miniTitle.Image = titleImg
			end
			_G.__CrystalCurrentTitleImage = titleImg
			pcall(function()
				local hubText = miniButton:FindFirstChild("MiniHubText")
				if hubText and type(_G.__SoundAccentColor) == "function" then hubText.TextColor3 = _G.__SoundAccentColor() end
			end)
		end
		pcall(syncMiniTitleImage)
		_G.__CrystalSyncMiniTitle = function() syncMiniTitleImage(); syncMiniBg() end
	end

	local function refreshHalloweenOptionLabels(enabled)
		for _, page in pairs(pages) do
			if page and page.Parent then
				for _, row in ipairs(page:GetChildren()) do
					if row:IsA("Frame") and row:GetAttribute("CurtThemeRole") == "Row" then
						for _, child in ipairs(row:GetChildren()) do
							if (child:IsA("TextLabel") or child:IsA("TextButton"))
								and child.TextXAlignment == Enum.TextXAlignment.Left
								and child.Text ~= "" then
								if row.Name == "HalloweenModeRow" then
									child.Text = "Halloween Mode"
									child:SetAttribute("HalloweenBaseText", nil)
								else
									local baseText = child:GetAttribute("HalloweenBaseText")
									if enabled then
										if not baseText then
											baseText = child.Text
											child:SetAttribute("HalloweenBaseText", baseText)
										end
										child.Text = tostring(baseText)
									elseif baseText then
										child.Text = tostring(baseText)
										child:SetAttribute("HalloweenBaseText", nil)
									end
								end
								break
							end
						end
					end
				end
			end
		end
	end

	-- PURPLE theme: live azure -> purple recolor (also catches colors set later by touch / toggle / tween)
	do
		local purpleActive = false
		local watched = setmetatable({}, {__mode = "k"})
		local rootsHooked = {}
		local ATTR = "SoundPurple_"
		local GUI_NAMES = {
			"SoundAutoGrabBar", "SoundMobileUI", "SoundEnemyWidget", "SoundLaggerGUI", "hyejuSpeedBypass", "K9RS",
			"CrystalAutoGrabBar", "CrystalMobileUI", "CrystalEnemyWidget", "CrystalLaggerGUI",
		}
		local function isAzure(c)
			local h, sat, val = c:ToHSV()
			return h >= 0.5 and h <= 0.68 and sat >= 0.25 and val >= 0.2
		end
		local function toPurple(c)
			local _, sat, val = c:ToHSV()
			return Color3.fromHSV(0.757, sat, val)
		end
		local function close(a, b)
			return math.abs(a.R - b.R) < 0.02 and math.abs(a.G - b.G) < 0.02 and math.abs(a.B - b.B) < 0.02
		end
		local function propsFor(inst)
			if inst:IsA("UIStroke") then return {"Color"} end
			if inst:IsA("GuiObject") then
				local t = {"BackgroundColor3", "BorderColor3"}
				if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
					t[#t + 1] = "TextColor3"; t[#t + 1] = "TextStrokeColor3"
				elseif inst:IsA("ImageLabel") or inst:IsA("ImageButton") then
					t[#t + 1] = "ImageColor3"
				elseif inst:IsA("ScrollingFrame") then
					t[#t + 1] = "ScrollBarImageColor3"
				end
				return t
			end
			return nil
		end
		local function fixProp(inst, prop)
			if not purpleActive then return end
			local ok, cur = pcall(function() return inst[prop] end)
			if not ok or typeof(cur) ~= "Color3" or not isAzure(cur) then return end
			if inst:GetAttribute(ATTR .. prop) == nil then inst:SetAttribute(ATTR .. prop, cur) end
			pcall(function() inst[prop] = toPurple(cur) end)
		end
		local function fixGradient(g)
			if not purpleActive then return end
			local changed, points = false, {}
			for _, point in ipairs(g.Color.Keypoints) do
				local v = point.Value
				if isAzure(v) then changed = true; v = toPurple(v) end
				table.insert(points, ColorSequenceKeypoint.new(point.Time, v))
			end
			if changed then
				if g:GetAttribute(ATTR .. "Gradient") == nil then g:SetAttribute(ATTR .. "Gradient", g.Color) end
				pcall(function() g.Color = ColorSequence.new(points) end)
			end
		end
		local function fixAll(inst)
			if inst:IsA("UIGradient") then fixGradient(inst); return end
			local list = propsFor(inst)
			if list then for _, prop in ipairs(list) do fixProp(inst, prop) end end
		end
		local function hook(inst)
			if watched[inst] then return end
			-- Roblox's built-in AutoButtonColor applies its own blue/azure press tint
			-- on touch. Disable that engine tint so the live purple recolor owns the
			-- button's pressed state instead of reverting to azure.
			if inst:IsA("GuiButton") then
				local autoKey = ATTR .. "AutoButtonColor"
				if inst:GetAttribute(autoKey) == nil then
					inst:SetAttribute(autoKey, inst.AutoButtonColor)
				end
				if purpleActive then inst.AutoButtonColor = false end
			end
			if inst:IsA("UIGradient") then
				watched[inst] = true
				fixGradient(inst)
				_G.__CrystalTrackConn(inst:GetPropertyChangedSignal("Color"):Connect(function() fixGradient(inst) end))
				return
			end
			local list = propsFor(inst)
			if not list then return end
			watched[inst] = true
			for _, prop in ipairs(list) do
				fixProp(inst, prop)
				_G.__CrystalTrackConn(inst:GetPropertyChangedSignal(prop):Connect(function() fixProp(inst, prop) end))
			end
		end
		local function hookRoot(root)
			if rootsHooked[root] then return end
			rootsHooked[root] = true
			task.spawn(function()
				local n = 0
				for _, d in ipairs(root:GetDescendants()) do
					pcall(hook, d)
					n = n + 1
					if n % 40 == 0 then task.wait() end
				end
			end)
			_G.__CrystalTrackConn(root.DescendantAdded:Connect(function(d) pcall(hook, d) end))
		end
		local nameSet = {}
		for _, n in ipairs(GUI_NAMES) do nameSet[n] = true end
		local function scanContainers()
			for _, container in ipairs({game:GetService("CoreGui"), Player:FindFirstChild("PlayerGui")}) do
				if container then
					pcall(function()
						for _, child in ipairs(container:GetChildren()) do
							if nameSet[child.Name] then hookRoot(child) end
						end
					end)
				end
			end
		end
		local containersWatched = false
		local function restoreAll()
			for inst in pairs(watched) do
				local ok, attrs = pcall(function() return inst:GetAttributes() end)
				if ok then
					for k, orig in pairs(attrs) do
						if k:sub(1, #ATTR) == ATTR then
							local prop = k:sub(#ATTR + 1)
							if prop == "AutoButtonColor" then
								pcall(function() if inst:IsA("GuiButton") then inst.AutoButtonColor = orig end end)
							elseif prop == "Gradient" then
								pcall(function() inst.Color = orig end)
							else
								local ok2, cur = pcall(function() return inst[prop] end)
								if ok2 and typeof(cur) == "Color3" and close(cur, toPurple(orig)) then
									pcall(function() inst[prop] = orig end)
								end
							end
							inst:SetAttribute(k, nil)
						end
					end
				end
			end
		end
		_G.__SoundPurpleRecolor = function(active)
			active = active == true
			-- perf: never hook the whole UI for a theme that was never active
			if not active and not containersWatched then return end
			if not containersWatched then
				containersWatched = true
				for _, container in ipairs({game:GetService("CoreGui"), Player:FindFirstChild("PlayerGui")}) do
					if container then
						pcall(function()
							_G.__CrystalTrackConn(container.ChildAdded:Connect(function(child)
								if nameSet[child.Name] then hookRoot(child) end
							end))
						end)
					end
				end
			end
			hookRoot(ScreenGui)
			scanContainers()
			if active == purpleActive then
				if active then task.spawn(function() for inst in pairs(watched) do pcall(fixAll, inst) end end) end
				return
			end
			purpleActive = active
			if active then
				task.spawn(function()
					local n = 0
					for inst in pairs(watched) do
						if inst:IsA("GuiButton") then pcall(function() inst.AutoButtonColor = false end) end
						pcall(fixAll, inst)
						n = n + 1
						if n % 300 == 0 then task.wait() end
					end
				end)
			else
				restoreAll()
			end
		end
	end


	-- GREEN theme: live azure -> green recolor (same idea as purple, no leftover azure)
	do
		local greenActive = false
		local watched = setmetatable({}, {__mode = "k"})
		local rootsHooked = {}
		local ATTR = "SoundGreen_"
		local GUI_NAMES = {
			"SoundAutoGrabBar", "SoundMobileUI", "SoundEnemyWidget", "SoundLaggerGUI", "hyejuSpeedBypass", "K9RS",
			"CrystalAutoGrabBar", "CrystalMobileUI", "CrystalEnemyWidget", "CrystalLaggerGUI",
			"SoundAvatarPanel", "CrystalAvatarPanel",
		}
		local function isAzure(c)
			local h, sat, val = c:ToHSV()
			-- classic azure/cyan-blue range used by default hub chrome
			return h >= 0.48 and h <= 0.70 and sat >= 0.22 and val >= 0.18
		end
		local function toGreen(c)
			local _, sat, val = c:ToHSV()
			return Color3.fromHSV(0.36, math.clamp(sat, 0.35, 1), math.clamp(val, 0.25, 1))
		end
		local function close(a, b)
			return math.abs(a.R - b.R) < 0.02 and math.abs(a.G - b.G) < 0.02 and math.abs(a.B - b.B) < 0.02
		end
		local function propsFor(inst)
			if inst:IsA("UIStroke") then return {"Color"} end
			if inst:IsA("GuiObject") then
				local t = {"BackgroundColor3", "BorderColor3"}
				if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
					t[#t + 1] = "TextColor3"; t[#t + 1] = "TextStrokeColor3"
				elseif inst:IsA("ImageLabel") or inst:IsA("ImageButton") then
					-- Only tint solid accent icons, never skin-pack thumbnails / photo previews
					if inst.Image and (inst.Image:find("rbxthumb://") or inst.Image:find("Thumbnail")) then
						return {"BackgroundColor3", "BorderColor3"}
					end
					t[#t + 1] = "ImageColor3"
				elseif inst:IsA("ScrollingFrame") then
					t[#t + 1] = "ScrollBarImageColor3"
				end
				return t
			end
			return nil
		end
		local function fixProp(inst, prop)
			if not greenActive then return end
			local ok, cur = pcall(function() return inst[prop] end)
			if not ok or typeof(cur) ~= "Color3" or not isAzure(cur) then return end
			if inst:GetAttribute(ATTR .. prop) == nil then inst:SetAttribute(ATTR .. prop, cur) end
			pcall(function() inst[prop] = toGreen(cur) end)
		end
		local function fixGradient(g)
			if not greenActive then return end
			local changed, points = false, {}
			for _, point in ipairs(g.Color.Keypoints) do
				local v = point.Value
				if isAzure(v) then changed = true; v = toGreen(v) end
				table.insert(points, ColorSequenceKeypoint.new(point.Time, v))
			end
			if changed then
				if g:GetAttribute(ATTR .. "Gradient") == nil then g:SetAttribute(ATTR .. "Gradient", g.Color) end
				pcall(function() g.Color = ColorSequence.new(points) end)
			end
		end
		local function fixAll(inst)
			if inst:IsA("UIGradient") then fixGradient(inst); return end
			local list = propsFor(inst)
			if list then for _, prop in ipairs(list) do fixProp(inst, prop) end end
		end
		local function hook(inst)
			if watched[inst] then return end
			watched[inst] = true
			if inst:IsA("UIGradient") then
				_G.__CrystalTrackConn(inst:GetPropertyChangedSignal("Color"):Connect(function() fixGradient(inst) end))
				fixAll(inst)
				return
			end
			local list = propsFor(inst)
			if not list then return end
			for _, prop in ipairs(list) do
				_G.__CrystalTrackConn(inst:GetPropertyChangedSignal(prop):Connect(function() fixProp(inst, prop) end))
			end
			if inst:IsA("GuiButton") and greenActive then
				pcall(function() inst.AutoButtonColor = false end)
			end
			fixAll(inst)
		end
		local function hookRoot(root)
			if not root or rootsHooked[root] then return end
			rootsHooked[root] = true
			hook(root)
			-- FPS: hook descendants in small batches instead of one frame-freezing loop
			task.spawn(function()
				local n = 0
				for _, d in ipairs(root:GetDescendants()) do
					pcall(hook, d)
					n = n + 1
					if n % 40 == 0 then task.wait() end
				end
			end)
			_G.__CrystalTrackConn(root.DescendantAdded:Connect(function(d) pcall(hook, d) end))
		end
		local nameSet = {}
		for _, name in ipairs(GUI_NAMES) do nameSet[name] = true end
		local function scanContainers()
			for _, container in ipairs({game:GetService("CoreGui"), Player:FindFirstChild("PlayerGui")}) do
				if container then
					pcall(function()
						for _, child in ipairs(container:GetChildren()) do
							if nameSet[child.Name] then hookRoot(child) end
						end
					end)
				end
			end
		end
		local containersWatched = false
		local function restoreAll()
			for inst in pairs(watched) do
				local ok, attrs = pcall(function() return inst:GetAttributes() end)
				if ok then
					for k, orig in pairs(attrs) do
						if k:sub(1, #ATTR) == ATTR then
							local prop = k:sub(#ATTR + 1)
							if prop == "Gradient" then
								pcall(function() inst.Color = orig end)
							else
								local ok2, cur = pcall(function() return inst[prop] end)
								if ok2 and typeof(cur) == "Color3" and close(cur, toGreen(orig)) then
									pcall(function() inst[prop] = orig end)
								end
							end
							inst:SetAttribute(k, nil)
						end
					end
				end
			end
		end
		_G.__SoundGreenRecolor = function(active)
			active = active == true
			-- perf: never hook the whole UI for a theme that was never active
			if not active and not containersWatched then return end
			if not containersWatched then
				containersWatched = true
				for _, container in ipairs({game:GetService("CoreGui"), Player:FindFirstChild("PlayerGui")}) do
					if container then
						pcall(function()
							_G.__CrystalTrackConn(container.ChildAdded:Connect(function(child)
								if nameSet[child.Name] then hookRoot(child) end
							end))
						end)
					end
				end
			end
			hookRoot(ScreenGui)
			scanContainers()
			if active == greenActive then
				if active then task.spawn(function() for inst in pairs(watched) do pcall(fixAll, inst) end end) end
				return
			end
			greenActive = active
			if active then
				task.spawn(function()
					local count = 0
					for inst in pairs(watched) do
						if inst:IsA("GuiButton") then pcall(function() inst.AutoButtonColor = false end) end
						pcall(fixAll, inst)
						count = count + 1
						if count % 300 == 0 then task.wait() end
					end
				end)
			else
				restoreAll()
			end
		end
	end

	_G.__SoundHalloweenRecolor = function(enabled)
		-- perf: skip the full-UI scan when Halloween was never turned on
		if enabled then _G.__SoundHalloweenTouched = true end
		if not enabled and not _G.__SoundHalloweenTouched then return end
		local function isAzzurro(color)
			local h, sat, val = color:ToHSV()
			return h >= 0.45 and h <= 0.84 and sat >= 0.25 and val >= 0.2
		end
		local function toOrange(color)
			local _, sat, val = color:ToHSV()
			return Color3.fromHSV(0.075, math.max(sat, 0.85), val)
		end
		local function close(a, b)
			return math.abs(a.R - b.R) < 0.02 and math.abs(a.G - b.G) < 0.02 and math.abs(a.B - b.B) < 0.02
		end
		local function handle(instance, property)
			local ok, current = pcall(function() return instance[property] end)
			if not ok or typeof(current) ~= "Color3" then return end
			local key = "SoundAzzurro_" .. property
			local original = instance:GetAttribute(key)
			if enabled then
				if original == nil and isAzzurro(current) then
					instance:SetAttribute(key, current)
					pcall(function() instance[property] = toOrange(current) end)
				end
			elseif original ~= nil then
				if close(current, toOrange(original)) then pcall(function() instance[property] = original end) end
				instance:SetAttribute(key, nil)
			end
		end
		local function handleGradient(gradient)
			local key = "SoundAzzurro_Gradient"
			local original = gradient:GetAttribute(key)
			if enabled then
				if original ~= nil then return end
				local changed, points = false, {}
				for _, point in ipairs(gradient.Color.Keypoints) do
					local value = point.Value
					if isAzzurro(value) then changed = true; value = toOrange(value) end
					table.insert(points, ColorSequenceKeypoint.new(point.Time, value))
				end
				if changed then
					gradient:SetAttribute(key, gradient.Color)
					pcall(function() gradient.Color = ColorSequence.new(points) end)
				end
			elseif original ~= nil then
				pcall(function() gradient.Color = original end)
				gradient:SetAttribute(key, nil)
			end
		end
		task.spawn(function()
			local count = 0
			for _, object in ipairs(ScreenGui:GetDescendants()) do
				if object:IsA("UIStroke") then
					handle(object, "Color")
				elseif object:IsA("UIGradient") then
					handleGradient(object)
				elseif object:IsA("GuiObject") then
					handle(object, "BackgroundColor3")
					handle(object, "BorderColor3")
					if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
						handle(object, "TextColor3")
						handle(object, "TextStrokeColor3")
					elseif object:IsA("ImageLabel") or object:IsA("ImageButton") then
						handle(object, "ImageColor3")
					elseif object:IsA("ScrollingFrame") then
						handle(object, "ScrollBarImageColor3")
					end
				end
				count = count + 1
				if count % 400 == 0 then task.wait() end
			end
		end)
	end

	local function applyCurtVisualTheme(selectedIndex)
		local halloweenEnabled = false
		local menuUiTheme = (not halloweenEnabled) and _G.__CrystalGetMenuUiTheme() or nil
		local palette = halloweenEnabled and HALLOWEEN_THEME or (menuUiTheme and menuUiTheme.palette) or getCurtThemePreset(selectedIndex)
		for key, value in pairs(palette) do C[key] = value end
		_G.__CrystalHalloweenMode = halloweenEnabled
		if _G.__CrystalRefreshVioletteSkinTheme then pcall(_G.__CrystalRefreshVioletteSkinTheme) end
		_G.__CrystalCurtAccent = C.accent
		_G.__CrystalThemeAccent = C.accent
		if mainOutline and mainOutline.Parent and _G.__SoundApplyAmbitiousOutline then
			_G.__SoundApplyAmbitiousOutline(inner)
		end
		if _G.__CrystalApplyAutoStealBarTheme then pcall(_G.__CrystalApplyAutoStealBarTheme, selectedIndex) end
		inner.BackgroundColor3 = C.bg
		local selectedBackground = halloweenEnabled and (getHalloweenBackground and getHalloweenBackground() or HALLOWEEN_BACKGROUND) or ((_G["_SoundHub_UI_BgPicked"] == true) and (backgroundIds[tonumber(selectedIndex) or 1] or backgroundIds[1]) or "")
		if menuUiTheme then
			selectedBackground = menuUiTheme.bgImage or ""
			if menuUiTheme.clean and _G.__CrystalCleanMenuImage then selectedBackground = tostring(_G.__CrystalCleanMenuImage) end
		end
		background.Image = selectedBackground
		if BgImage then BgImage.Image = selectedBackground end
		-- Push the same artwork to the auto-steal HUD.
		pcall(function()
			if type(_G.__CrystalApplyAutoStealBarTheme) == "function" then
				_G.__CrystalApplyAutoStealBarTheme(selectedIndex)
			end
		end)
		do -- corner radius per skin (Ambitious-style 28 / 27 unless a skin overrides it)
			local r = menuUiTheme and menuUiTheme.corner or (_G.__SoundMenuCorner or 28)
			local ic = inner:FindFirstChildOfClass("UICorner")
			if ic then ic.CornerRadius = UDim.new(0, r) end
			local bc = background:FindFirstChildOfClass("UICorner")
			if bc and not halloweenEnabled then bc.CornerRadius = UDim.new(0, r - 1) end
		end
		pcall(function()
			local ms = miniButton:FindFirstChildOfClass("UIStroke")
			if ms then ms.Color = C.accent end
		end)

		-- Halloween: the background reaches the real rounded edge so no gray corner pixels show.
		local backgroundCorner = background:FindFirstChildOfClass("UICorner")
		if halloweenEnabled then
			background.Size = UDim2.fromScale(1, 1)
			background.Position = UDim2.fromOffset(0, 0)
			if backgroundCorner then backgroundCorner.CornerRadius = UDim.new(0, _G.__SoundMenuCorner or 28) end
			innerStroke.Transparency = 1
			if mainShade then mainShade.Visible = false end
		else
			background.Size = UDim2.new(1, -2, 1, -2)
			background.Position = UDim2.fromOffset(1, 1)
			if backgroundCorner then backgroundCorner.CornerRadius = UDim.new(0, (_G.__SoundMenuCorner or 28) - 1) end
			innerStroke.Transparency = 1
			if mainShade then mainShade.Visible = activeGuiTheme ~= "GUI 1" end
		end

		statsPanel.BackgroundColor3 = C.bgDark
		statsPanel:SetAttribute("CurtThemeRole", "BgDark")
		closeButton.BackgroundTransparency = 1
		closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		miniButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		separator.BackgroundColor3 = C.accent
		separator:SetAttribute("CurtThemeRole", "Accent")
		bottomTabs.BackgroundColor3 = C.bgDark
		bottomTabs:SetAttribute("CurtThemeRole", "BgDark")
		bottomTabsStroke.Color = C.accent
		do -- Clean skin: see-through rows so the artwork shows, bright title, no dark shade
			local clean = menuUiTheme ~= nil and menuUiTheme.clean == true
			if clean and mainShade then mainShade.Visible = false end
			background.ImageTransparency = 0
			if wordGlow then wordGlow.ImageTransparency = clean and 0.45 or 0.74 end
			if wordMark then wordMark.ImageTransparency = 0 end
			for _, d in ipairs(inner:GetDescendants()) do
				if d:IsA("GuiObject") then
					local role = d:GetAttribute("CurtThemeRole")
					if role == "Row" or role == "BgDark" then
						if d:GetAttribute("CleanOrigT") == nil then d:SetAttribute("CleanOrigT", d.BackgroundTransparency) end
						local orig = d:GetAttribute("CleanOrigT")
						if clean then
							if d.BackgroundTransparency < 1 then d.BackgroundTransparency = math.max(orig, role == "Row" and 0.82 or 0.55) end
						else
							d.BackgroundTransparency = orig
						end
					end
				end
			end
		end
		for _, extraName in ipairs({"UnifiedPanelWhiteOutline", "UnifiedPanelWhiteGlow"}) do
			local extra = inner:FindFirstChild(extraName)
			if extra then extra:Destroy() end
		end
		do
			local titleImg = CURT_WORD_IMAGE
			local titleTint = C.accent
			if halloweenEnabled then
				titleImg = HALLOWEEN_TITLE_IMAGE or "rbxassetid://95866470022902"
				titleTint = Color3.fromRGB(255, 255, 255)
			elseif _G["_SoundHub_UI_ColorTheme"] == "purple" then
				titleImg = PURPLE_TITLE_IMAGE
				titleTint = Color3.new(1, 1, 1)
			elseif _G["_SoundHub_UI_ColorTheme"] == "green" then
				titleImg = GREEN_TITLE_IMAGE
				titleTint = Color3.new(1, 1, 1)
			elseif _G["_SoundHub_UI_ColorTheme"] == "azure" then
				titleImg = AZURE_TITLE_IMAGE
				titleTint = Color3.new(1, 1, 1)
			end
			if wordMark then
				wordMark.Image = titleImg
				wordMark.ImageColor3 = titleTint
			end
			if wordGlow then
				wordGlow.Image = titleImg
				wordGlow.ImageColor3 = halloweenEnabled and Color3.fromRGB(255, 180, 60) or titleTint
			end
			if miniButton then
				-- mini avatar kept
				miniButton.ImageColor3 = titleTint
			end
		end
		for _, descendant in ipairs(inner:GetDescendants()) do
			if descendant:IsA("GuiObject") then
				local role = descendant:GetAttribute("CurtThemeRole")
				if role == "AccentDim" then
					descendant.BackgroundColor3 = C.accentDim
				elseif role == "Accent" then
					descendant.BackgroundColor3 = C.accent
				elseif role == "Row" then
					descendant.BackgroundColor3 = C.row
				elseif role == "BgDark" then
					descendant.BackgroundColor3 = C.bgDark
				elseif role == "SwitchKnob" then
					descendant.BackgroundColor3 = C.text
				end
			end
			if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
				if descendant == FPSLabel or descendant == PingLabel then
					descendant.TextColor3 = descendant == FPSLabel and C.text or C.textDim
				elseif descendant ~= closeButton then
					pcall(function() descendant.TextColor3 = C.text end)
				end
				if descendant.Name == "SectionLabel" then pcall(function() descendant.TextColor3 = C.text end) end
				if descendant:IsA("TextBox") and descendant:GetAttribute("CurtThemeAccentInput") then
					descendant.BackgroundColor3 = C.accentDim
					descendant:SetAttribute("CurtThemeRole", "AccentDim")
				end
			end
			if descendant:IsA("Frame") then
				if descendant.Name == "Indicator" or descendant.Name == "ActiveMarker" then
					descendant.BackgroundColor3 = C.accent
					descendant:SetAttribute("CurtThemeRole", "Accent")
				elseif descendant:GetAttribute("CrystalButtonThemeControl") then
					descendant.BackgroundColor3 = C.row
					descendant:SetAttribute("CurtThemeRole", "Row")
				elseif descendant.Name == "BottomTabs" then
					descendant.BackgroundColor3 = C.bgDark
					descendant:SetAttribute("CurtThemeRole", "BgDark")
				end
			end
			if descendant:IsA("TextButton") then
				if descendant.Parent == categoryList then
					descendant.BackgroundColor3 = C.accentDim
					descendant:SetAttribute("CurtThemeRole", "AccentDim")
				elseif descendant ~= closeButton and descendant ~= miniButton and descendant.Text ~= "" then
					local alpha = descendant.BackgroundTransparency
					if alpha < 0.95 then
						descendant.BackgroundColor3 = descendant:GetAttribute("CrystalButtonThemeControl") and C.row or C.accentDim
					end
				end
			end
			if descendant:IsA("UIStroke") then
				if descendant:GetAttribute("AmbitiousOutlineLocked") then
					-- Ambitious silver edge: no theme ever repaints it
				elseif descendant.Parent and descendant.Parent.Name == "BottomTabs" then
					descendant.Color = C.divider
				elseif descendant.Parent and descendant.Parent:IsA("GuiObject") then
					if descendant.Parent:GetAttribute("CrystalButtonThemeControl") then
						descendant.Color = C.divider
					elseif descendant.Parent == closeButton or descendant.Parent == miniButton or descendant.Parent == statsPanel then
						descendant.Color = C.divider
					else
						descendant.Color = C.accentDim
					end
				end
			end
		end
		-- Repaint every active control immediately; changing a color must never
		-- require toggling a feature off and back on.
		for _, refreshToggle in pairs(toggleVisualUpdaters) do
			pcall(refreshToggle)
		end
		refreshHalloweenOptionLabels(halloweenEnabled)
		local halloweenLabel = inner:FindFirstChild("HalloweenModeLabel", true)
		if halloweenLabel then
			halloweenLabel.Text = "Halloween Mode"
			halloweenLabel.TextColor3 = halloweenEnabled and Color3.fromRGB(255, 174, 56) or Color3.fromRGB(255, 145, 35)
			halloweenLabel.TextStrokeColor3 = Color3.fromRGB(70, 24, 0)
			halloweenLabel.TextStrokeTransparency = halloweenEnabled and 0.35 or 0.55
		end
		if refreshCategoryTextColors then refreshCategoryTextColors() end
		local ctNow = "purple"
		pcall(_G.__SoundPurpleRecolor, (not halloweenEnabled) and ctNow == "purple")
		pcall(_G.__SoundGreenRecolor, (not halloweenEnabled) and ctNow == "green")
		pcall(_G.__SoundHalloweenRecolor, halloweenEnabled)
		if _G.__refreshSpeedBillboards then pcall(_G.__refreshSpeedBillboards) end
		if _G.__CrystalRefreshQuickButtonTheme then pcall(_G.__CrystalRefreshQuickButtonTheme) end
		if _G.__CrystalApplyAutoStealBarTheme then pcall(_G.__CrystalApplyAutoStealBarTheme, selectedIndex) end
		do -- Theme and styling refresh for the selected Menu UI version.
			local st = menuUiTheme
			do -- title image: purple theme uses the purple title; azure keeps the original; Halloween keeps its own title art
				if halloweenEnabled then
					local hid = HALLOWEEN_TITLE_IMAGE or "rbxassetid://95866470022902"
					wordMark.Image = hid
					wordGlow.Image = hid
					wordMark.ImageColor3 = Color3.fromRGB(255, 255, 255)
					wordGlow.ImageColor3 = Color3.fromRGB(255, 180, 60)
					pcall(function()
						local ms = miniButton:FindFirstChildOfClass("UIStroke")
						if ms then ms.Color = Color3.fromRGB(255, 145, 35) end
					end)
				else
					local ct = "purple"
					local titleId = CURT_WORD_IMAGE
					local tint = C.accent
					if ct == "purple" then
						titleId = PURPLE_TITLE_IMAGE
						tint = Color3.new(1, 1, 1)
					elseif ct == "green" then
						titleId = GREEN_TITLE_IMAGE
						tint = Color3.new(1, 1, 1)
					elseif ct == "azure" then
						titleId = AZURE_TITLE_IMAGE
						tint = Color3.new(1, 1, 1)
					end
					wordMark.Image = titleId
					wordGlow.Image = titleId
					wordMark.ImageColor3 = tint
					wordGlow.ImageColor3 = tint
					-- Mini side button keeps the player avatar; only restyle the ring
					pcall(function()
						local ms = miniButton:FindFirstChildOfClass("UIStroke")
						if ms then ms.Color = C.accent end
					end)
				end
			end
			local grad = inner:FindFirstChild("SoundStyleGradient")
			local frameStroke = inner:FindFirstChild("SoundStyleStroke")
			if st and st.styled then
				if not grad then
					grad = Instance.new("UIGradient"); grad.Name = "SoundStyleGradient"; grad.Rotation = 90; grad.Parent = inner
				end
				grad.Color = ColorSequence.new(C.accentDim:Lerp(C.bg, 0.6), C.bg:Lerp(C.bgDark, 0.5))
				inner.BackgroundColor3 = Color3.new(1, 1, 1)
				if not frameStroke then
					frameStroke = Instance.new("UIStroke"); frameStroke.Name = "SoundStyleStroke"
					frameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; frameStroke.Parent = inner
				end
				frameStroke.Color = C.accent
				frameStroke.Thickness = st.frameStroke or 2
				frameStroke.Transparency = st.frameStrokeT or 0.2
			else
				if grad then grad:Destroy() end
				if frameStroke then frameStroke:Destroy() end
				inner.BackgroundColor3 = C.bg
			end
			for _, d in ipairs(inner:GetDescendants()) do
				if d:IsA("GuiObject") and d:GetAttribute("CrystalButtonThemeControl") then
					local uc = d:FindFirstChildOfClass("UICorner")
					local us = d:FindFirstChildOfClass("UIStroke")
					if uc and d:GetAttribute("StyleOrigCorner") == nil then d:SetAttribute("StyleOrigCorner", uc.CornerRadius.Offset) end
					if us and d:GetAttribute("StyleOrigStrokeT") == nil then d:SetAttribute("StyleOrigStrokeT", us.Transparency) end
					if st and st.rowCorner then
						if uc then uc.CornerRadius = UDim.new(0, st.rowCorner) end
						if us then us.Color = C.accent; us.Transparency = st.rowStrokeT or 0.4 end
						if d.BackgroundTransparency < 1 and st.rowT then d.BackgroundTransparency = st.rowT end
					else
						local oc = d:GetAttribute("StyleOrigCorner")
						if uc and oc then uc.CornerRadius = UDim.new(0, oc) end
						local ot = d:GetAttribute("StyleOrigStrokeT")
						if us and ot then us.Transparency = ot; us.Color = C.divider end
					end
				end
			end
			for _, b in ipairs(categoryList:GetChildren()) do
				if b:IsA("TextButton") then
					local bc = b:FindFirstChildOfClass("UICorner")
					if bc then bc.CornerRadius = UDim.new(0, (st and st.tabCorner) or 10) end
				end
			end
		end
	end
	_G.__CrystalApplyCurtVisualTheme = applyCurtVisualTheme
	applyCurtVisualTheme(bgIndex)

	closeButton.MouseButton1Click:Connect(function()
	if _G.__setPanelVisible then _G.__setPanelVisible(false) else Panel.Visible = false end
	end)
	-- Mini button: own drag logic (touch + mouse). Tap opens the menu, drag moves it.
	miniButton.Active = true
	do
		local dragging, dragInput, startPointer, startPos, moved = false, nil, nil, nil, false
		_G.__CrystalGuiPositionResetters[miniButton.Name] = function()
			dragging = false
			miniButton.Position = UDim2.fromOffset(6, 54)
			_G["_SoundHub_UI_ModernMiniPos"] = nil
		end
		miniButton.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				moved = false
				dragInput = input
				startPointer = Vector2.new(input.Position.X, input.Position.Y)
				startPos = miniButton.Position
			end
		end)
		miniButton.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				if dragInput == nil or dragInput.UserInputType ~= Enum.UserInputType.Touch then dragInput = input end
			end
		end)
		_G.__CrystalTrackConn(UserInputService.InputChanged:Connect(function(input)
			if not dragging or not startPointer then return end
			local isMove = input.UserInputType == Enum.UserInputType.MouseMovement
			local isTouch = input.UserInputType == Enum.UserInputType.Touch and true
			if not (isMove or isTouch) then return end
			local delta = Vector2.new(input.Position.X, input.Position.Y) - startPointer
			if delta.Magnitude > 6 then moved = true end
			if moved then
				placeInsideViewport(miniButton, startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end))
		_G.__CrystalTrackConn(UserInputService.InputEnded:Connect(function(input)
			if not dragging then return end
			if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
			dragging = false
			if moved then
				_G["_SoundHub_UI_ModernMiniPos"] = { x = miniButton.Position.X.Offset, y = miniButton.Position.Y.Offset }
				pcall(saveConfig)
			else
				if _G.__setPanelVisible then _G.__setPanelVisible(true) else Panel.Visible = true end
			end
		end))
	end
	Panel:GetPropertyChangedSignal("Visible"):Connect(function()
	_G.__CrystalPanelVisible = Panel.Visible
	toggleStates["Toggle UI"] = Panel.Visible
	miniButton.Visible = not Panel.Visible
	saveConfig()
	end)

	local function keepNewPanelSize()
	local camera = workspace.CurrentCamera
	if not camera then return end
	local viewport = camera.ViewportSize
	if viewport.X <= 0 or viewport.Y <= 0 then return end
	local availableW = math.max(1, viewport.X - 12)
	local availableH = math.max(1, viewport.Y - 60)
	if _G.__CrystalRealMobile then
	Panel.Size = UDim2.new(0, math.min(availableW, math.clamp(math.floor(viewport.X * 0.58), 240, 300)), 0, math.min(availableH, math.clamp(math.floor(viewport.Y - 50), 450, 790)))
	else
	Panel.Size = UDim2.new(0, math.min(360, availableW), 0, math.min(660, availableH))
	end
	for _, target in ipairs({Panel, miniButton}) do
	local position = target.Position
	placeInsideViewport(target, position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset)
	end
	end
	keepNewPanelSize()
	local viewportConnection
	local function watchModernCamera()
	if viewportConnection then viewportConnection:Disconnect(); viewportConnection = nil end
	local camera = workspace.CurrentCamera
	if camera then
	viewportConnection = _G.__CrystalTrackConn(camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	task.defer(keepNewPanelSize)
	end))
	end
	task.defer(keepNewPanelSize)
	end
	_G.__CrystalTrackConn(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(watchModernCamera))
	watchModernCamera()
	-- ===== MENU IDLE FADE (same trick as the AmbitiousTest source, 2 seconds) =====
	-- Two seconds without touching the menu -> the content ghosts out to 0.7
	-- transparency, that soft "blurred" look. First contact brings it straight
	-- back. The window chrome (background art, dark shade, purple outline) is
	-- left alone, exactly like the Ambitious source leaves its own background.
	--
	-- HOW, and why this way: writing transparency on every single element would
	-- mean writing the SAME properties the row hover effect uses. The two would
	-- fight and the rows would stay stuck in their hover state. Here the content
	-- is moved inside a CanvasGroup and only its GroupTransparency is animated:
	-- one property, on the container. No child property is ever touched, so hover
	-- keeps working on its own and the restore is exact by definition.
	--
	-- NOTE: Roblox has no blur for GUI content (BlurEffect only touches the 3D
	-- world), so this is the very same soft ghost the Ambitious menu shows.
	-- Tweak _G.__SoundMenuIdleFade (delay / value / fadeOut / fadeIn) to taste.
	;(function()
		local IDLE = {
			delay   = 2,     -- seconds without contact before the menu ghosts out
			value   = 0.7,   -- transparency to reach
			fadeOut = 0.3,   -- how long the ghosting takes
			fadeIn  = 0.14,  -- how long the return takes: short, must feel instant
			last    = os.clock(),
			faded   = false,
			group   = nil,
			started = false,
			conns   = {},
		}
		_G.__SoundMenuIdleFade = IDLE

		local GROUP_NAME = "MenuIdleFadeGroup"
		-- What must NOT move into the group: the window chrome and every
		-- layout/appearance modifier, which have to stay direct children of inner.
		local STAYS = {
			BackgroundImage = true,
			UnifiedBackgroundShade = true,
			UnifiedPanelAccentOutline = true,
			UnifiedPanelWhiteOutline = true,
			UnifiedPanelWhiteGlow = true,
			SoundStyleGradient = true,
			SoundStyleStroke = true,
			MenuIdleFadeGroup = true,
		}
		local function stays(child)
			if STAYS[child.Name] then return true end
			if child:IsA("UICorner") or child:IsA("UIStroke") or child:IsA("UIScale")
				or child:IsA("UIPadding") or child:IsA("UIListLayout") or child:IsA("UIGradient")
				or child:IsA("UIGridLayout") or child:IsA("UIPageLayout") or child:IsA("UITableLayout")
				or child:IsA("UIAspectRatioConstraint") or child:IsA("UISizeConstraint") then
				return true
			end
			return false
		end

		local function track(connection)
			if not connection then return nil end
			if type(_G.__CrystalTrackConn) == "function" then pcall(_G.__CrystalTrackConn, connection) end
			IDLE.conns[#IDLE.conns + 1] = connection
			return connection
		end

		local function ensureGroup()
			if IDLE.group and IDLE.group.Parent then return IDLE.group end
			if not inner or not inner.Parent then return nil end
			local ok, group = pcall(function() return Instance.new("CanvasGroup") end)
			if not ok or not group then return nil end   -- old client: give up, better than breaking
			group.Name = GROUP_NAME
			group.BackgroundTransparency = 1
			group.BorderSizePixel = 0
			group.Size = UDim2.new(1, 0, 1, 0)
			group.Position = UDim2.new(0, 0, 0, 0)
			group.ZIndex = 2                -- above the background art (0) and the shade (1)
			group.GroupTransparency = 0
			group.Active = false            -- never sinks input: header drag and rows keep working
			group.Parent = inner

			for _, child in ipairs(inner:GetChildren()) do
				if child ~= group and not stays(child) then child.Parent = group end
			end

			-- Anything hung on inner later joins the group as well.
			track(inner.ChildAdded:Connect(function(child)
				if child == group or stays(child) then return end
				task.defer(function()
					if child.Parent == inner and not stays(child) then child.Parent = group end
				end)
			end))

			IDLE.group = group
			return group
		end

		local function setFade(fade)
			local group = ensureGroup()
			if not group then return end
			IDLE.faded = fade and true or false
			tween(group, { GroupTransparency = fade and IDLE.value or 0 },
				fade and IDLE.fadeOut or IDLE.fadeIn,
				Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		end

		local function busyWithMenu()
			-- Typing in a menu textbox or waiting for a keybind: never ghost out.
			if listeningBindBtn then return true end
			local focused = UserInputService:GetFocusedTextBox()
			if not focused then return false end
			local ok, inside = pcall(function() return focused:IsDescendantOf(Panel) end)
			return ok and inside == true
		end

		local function wake()
			IDLE.last = os.clock()
			if IDLE.faded then setFade(false) end
		end
		_G.__SoundMenuIdleWake = wake

		-- Input on a row button does not bubble up to Panel, so the pointer
		-- position is checked too: without this a tap on mobile (where every
		-- touch lands on a button) would never wake the menu.
		local function pointInsidePanel(point)
			if not point or not Panel or not Panel.Visible then return false end
			local ok, inside = pcall(function()
				local position, size = Panel.AbsolutePosition, Panel.AbsoluteSize
				return point.X >= position.X and point.X <= position.X + size.X
					and point.Y >= position.Y and point.Y <= position.Y + size.Y
			end)
			return ok and inside == true
		end
		local POINTER_INPUT = {
			[Enum.UserInputType.MouseButton1] = true,
			[Enum.UserInputType.MouseButton2] = true,
			[Enum.UserInputType.MouseButton3] = true,
			[Enum.UserInputType.Touch] = true,
		}

		local function start()
			if IDLE.started then return end
			if not ensureGroup() then return end
			IDLE.started = true
			IDLE.last = os.clock()

			-- mouse / touch / pen landing on the window itself
			track(Panel.InputBegan:Connect(wake))
			track(Panel.InputChanged:Connect(wake))
			track(Panel.MouseEnter:Connect(wake))
			track(inner.InputBegan:Connect(wake))
			track(inner.InputChanged:Connect(wake))
			track(inner.MouseEnter:Connect(wake))

			-- gamepad has no pointer: any pad input wakes the menu
			track(UserInputService.InputBegan:Connect(function(input)
				if tostring(input.UserInputType):match("Gamepad") then
					wake()
				elseif POINTER_INPUT[input.UserInputType] and pointInsidePanel(input.Position) then
					wake()
				end
			end))
			-- dragging the window or sliding a row: keep it solid for as long as
			-- the pointer moves inside the menu
			track(UserInputService.InputChanged:Connect(function(input)
				local kind = input.UserInputType
				if kind == Enum.UserInputType.MouseMovement or kind == Enum.UserInputType.Touch then
					if pointInsidePanel(input.Position) then wake() end
				end
			end))

			-- opening / closing resets the clock: the menu never opens ghosted
			track(Panel:GetPropertyChangedSignal("Visible"):Connect(wake))

			task.spawn(function()
				while IDLE.started do
					task.wait(0.1)
					if not IDLE.started then break end
					local state = _G.__CRYSTAL_STATE
					if state and state.alive == false then break end
					if Panel.Visible and not _panelAnimating and not busyWithMenu() then
						if not IDLE.faded and (os.clock() - IDLE.last) >= IDLE.delay then
							setFade(true)
						end
					elseif IDLE.faded then
						setFade(false)
						IDLE.last = os.clock()
					end
				end
			end)
		end

		if type(_G.__CrystalTrackStopper) == "function" then
			_G.__CrystalTrackStopper(function()
				IDLE.started = false
				for _, connection in ipairs(IDLE.conns) do pcall(function() connection:Disconnect() end) end
				table.clear(IDLE.conns)
				if IDLE.group and IDLE.group.Parent then
					pcall(function() IDLE.group.GroupTransparency = 0 end)
				end
				IDLE.faded = false
			end)
		end

		task.defer(function() pcall(start) end)
	end)()
	-- ===== MENU IDLE FADE END =====
	end)()
	_G.__CrystalRegisterThemeRoot(ScreenGui)

	task.spawn(function()
	local blackout = Instance.new("Frame")
	blackout.Size = UDim2.new(1, 0, 1, 0)
	blackout.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	blackout.BackgroundTransparency = 1
	blackout.BorderSizePixel = 0
	blackout.ZIndex = 10000
	blackout.Parent = ScreenGui
	TweenService:Create(blackout, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.45}):Play()
	task.wait(0.12)
	TweenService:Create(blackout, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
	task.wait(0.3)
	pcall(function() blackout:Destroy() end)
	end)

	;(function()
	local function keyDisplayName(kc)
	if not kc then return "..." end
	return keybindDisplayName(kc)
	end

	local function handleKeyInput(input, gameProcessed)

	if listeningBindBtn and listeningFeature then
	local updatedFeature = listeningFeature
	local boundButton = listeningBindBtn
	local isTouchOrClick = (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1)
	if isBindableInput(input) or isTouchOrClick or isMouseSideButton(input) then
	if isTouchOrClick or input.KeyCode == Enum.KeyCode.Escape or (isClearKeybindInput(input) and updatedFeature ~= "Toggle UI") then
	FeatureKeybinds[updatedFeature] = nil
	local emptyText = (boundButton.Size.X.Offset == 42 or boundButton:GetAttribute("MiniUIBind")) and "-" or "BIND"
	boundButton.Text = emptyText
	elseif isMouseSideButton(input) then
	local mbName = getMouseButtonBind(input)
	FeatureKeybinds[updatedFeature] = mbName
	boundButton.Text = mouseButtonDisplay[mbName] or mbName
	else
	FeatureKeybinds[updatedFeature] = input.KeyCode
	boundButton.Text = keyDisplayName(input.KeyCode)
	end
	listeningBindBtn = nil
	listeningFeature = nil
	saveConfig()
	if updatedFeature and toggleVisualUpdaters[updatedFeature] then toggleVisualUpdaters[updatedFeature]() end
	local mapped = _featureToggleMap[updatedFeature]
	if mapped and mapped.bindCircle then
	local k = FeatureKeybinds[updatedFeature]
	mapped.bindCircle.Text = k and keyDisplayName(k) or "-"
	end
	return
	end
	end

	if UserInputService:GetFocusedTextBox() then return end

	local function inputMatchesBind(boundKey)
		return boundKey ~= nil and (
			(isBindableInput(input) and input.KeyCode == boundKey)
			or (isMouseSideButton(input) and getMouseButtonBind(input) == boundKey)
		)
	end
	local normalPairKeyMatches = inputMatchesBind(FeatureKeybinds["SelectNormalMode"])
	local laggerPairKeyMatches = inputMatchesBind(FeatureKeybinds["SelectLaggerMode"])
	if normalPairKeyMatches or laggerPairKeyMatches then
		local pairMode
		if normalPairKeyMatches and laggerPairKeyMatches then
			pairMode = (selectedMode == "Lagger" or laggerEnabled) and "Lagger" or "Normal"
		elseif laggerPairKeyMatches then
			pairMode = "Lagger"
		else
			pairMode = "Normal"
		end
		if toggleSpeedPair then toggleSpeedPair(pairMode) end
		return
	end

	local dropKey = FeatureKeybinds["Drop"]
	local dropKeyMatches = dropKey ~= nil and (
	(isBindableInput(input) and input.KeyCode == dropKey)
	or (isMouseSideButton(input) and getMouseButtonBind(input) == dropKey)
	)
	if dropKeyMatches then
	if FeatureToggles["Drop"] then FeatureToggles["Drop"]("keybind") end
	return
	end
	if gameProcessed and not gamepadInputTypes[input.UserInputType] then return end

	if isBindableInput(input) then
	for feat, key in pairs(FeatureKeybinds) do
	if input.KeyCode == key then
	if FeatureToggles[feat] then
	if feat == "Drop" then FeatureToggles[feat]("keybind") else FeatureToggles[feat]() end
	else
	local active = not toggleStates[feat]
	toggleStates[feat] = active
	saveConfig()
	if FeaturePostToggle[feat] then FeaturePostToggle[feat](active) end
	if toggleVisualUpdaters[feat] then toggleVisualUpdaters[feat]() end
	end
	end
	end
	end

	if isMouseSideButton(input) then
	local mbBind = getMouseButtonBind(input)
	for feat, key in pairs(FeatureKeybinds) do
	if key == mbBind then
	if FeatureToggles[feat] then
	if feat == "Drop" then FeatureToggles[feat]("keybind") else FeatureToggles[feat]() end
	else
	local active = not toggleStates[feat]
	toggleStates[feat] = active
	saveConfig()
	if FeaturePostToggle[feat] then FeaturePostToggle[feat](active) end
	if toggleVisualUpdaters[feat] then toggleVisualUpdaters[feat]() end
	end
	end
	end
	end

	end

	_G.__CrystalTrackConn(UserInputService.InputBegan:Connect(handleKeyInput))
	end)()

	;(function()
	-- Inf Jump: Vx7 logic. Jump = set Y velocity to JUMP_POWER (network owner = us),
	-- gated by a short lock. JumpRequest fires one jump (keyboard/gamepad/mobile button).
	-- Hold mode additionally re-applies every PreSimulation while Space / ButtonA / touch is held.
	local infJumpState = _G.__CrystalInfJumpState or {}
	_G.__CrystalInfJumpState = infJumpState
	if infJumpState.conn then pcall(function() infJumpState.conn:Disconnect() end) end
	infJumpState.conn = nil
	infJumpState.canJump = true
	infJumpState.lastJump = 0
	infJumpState.gamepadHeld = false
	infJumpState.touchHeld = false
	local function getJumpPower()
	return tonumber(_G.__CrystalJumpPower) or 50
	end

	local function jumpBlocked()
	if UserInputService:GetFocusedTextBox() then return true end
	if _G.dropActive or _G.IsDropping or _G.__CrystalSideRunActive then return true end
	-- Vx7: no jumping while TP Bat is driving, while dropping, or during an insta reset
	if toggleStates["TP Bat"] or _G.__CrystalDropActive or _G.__CrystalInstaResetBusy then return true end
	return false
	end

	-- Vx7 clearInfinityJumpVelocity: clamp leftover vertical speed and unlock the next jump
	function clearInfinityJumpVelocity()
	local char = Player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if hrp then
	local v = hrp.AssemblyLinearVelocity
	hrp.AssemblyLinearVelocity = Vector3.new(v.X, math.clamp(v.Y, -20, 20), v.Z)
	end
	infJumpState.canJump = true
	end

	local function applyJumpVelocity(setHumJump)
	if not toggleStates["Inf Jump"] then return end
	if not infJumpState.canJump then return end
	if jumpBlocked() then return end
	local char = Player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp or hum.Health <= 0 then return end
	infJumpState.canJump = false
	infJumpState.lastJump = os.clock()
	infJumpState.lastJumpTime = tick()
	_G.__CrystalLastJumpTime = os.clock()
	pcall(function() hrp:SetNetworkOwner(Player) end)
	local v = hrp.AssemblyLinearVelocity
	hrp.AssemblyLinearVelocity = Vector3.new(v.X, getJumpPower(), v.Z)
	task.delay(0.08, function() infJumpState.canJump = true end)
	end

	_G.__CrystalTrackConn(UserInputService.JumpRequest:Connect(function()
	applyJumpVelocity(false)
	end))

	_G.__CrystalTrackConn(UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.ButtonA and not UserInputService:GetFocusedTextBox() then
	infJumpState.gamepadHeld = true
	end
	end))
	_G.__CrystalTrackConn(UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.ButtonA then
	infJumpState.gamepadHeld = false
	end
	end))

	-- Mobile jump button: track touch-held for hold mode, tap for manual mode.
	local function bindMobileJumpButton(btn)
	if not btn or not btn:IsA("GuiButton") then return end
	_G.__CrystalTrackConn(btn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then infJumpState.touchHeld = true end
	end))
	_G.__CrystalTrackConn(btn.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then infJumpState.touchHeld = false end
	end))
	_G.__CrystalTrackConn(btn.AncestryChanged:Connect(function(_, parent)
	if not parent then infJumpState.touchHeld = false end
	end))
	_G.__CrystalTrackConn(btn.Activated:Connect(function()
	if (_G.__CrystalInfJumpMode or "manual") ~= "hold" then applyJumpVelocity(true) end
	end))
	end
	if UserInputService.TouchEnabled then
	task.spawn(function()
	local pg = Player:FindFirstChildOfClass("PlayerGui") or Player:WaitForChild("PlayerGui")
	local jb = pg:FindFirstChild("JumpButton", true)
	if jb then bindMobileJumpButton(jb) end
	_G.__CrystalTrackConn(pg.DescendantAdded:Connect(function(d)
	if d.Name == "JumpButton" and d:IsA("GuiButton") then bindMobileJumpButton(d) end
	end))
	end)
	end

	function startInfJump()
	if infJumpState.conn then
	infJumpState.conn:Disconnect()
	infJumpState.conn = nil
	end
	infJumpState.conn = (RunService.PreSimulation or RunService.Stepped):Connect(function()
	if not toggleStates["Inf Jump"] or (_G.__CrystalInfJumpMode or "manual") ~= "hold" then return end
	local held = false
	pcall(function() held = UserInputService:IsKeyDown(Enum.KeyCode.Space) end)
	if not held then held = infJumpState.gamepadHeld or infJumpState.touchHeld end
	if held then applyJumpVelocity(false) end
	end)
	end

	function stopInfJump()
	if infJumpState.conn then
	infJumpState.conn:Disconnect()
	infJumpState.conn = nil
	end
	end
	_G.__CrystalTrackStopper(stopInfJump)
	FeaturePostToggle["Inf Jump"] = function(active)
	if active and (_G.__CrystalInfJumpMode or "manual") == "hold" then
	startInfJump()
	else
	stopInfJump()
	end
	end
	if toggleStates["Inf Jump"] and (_G.__CrystalInfJumpMode or "manual") == "hold" then startInfJump() end
	end)()


	-- ==================== FONT CHANGER (from Ambitious) ====================
	do
_G.CrystalFonts = _G.CrystalFonts or {}
_G.CrystalFonts.orig = _G.CrystalFonts.orig or {}
_G.CrystalFonts.conns = _G.CrystalFonts.conns or {}
-- TextSize di partenza di ogni elemento, per l'adattamento automatico.
-- Strong come orig: senza il valore originale il ripristino non tornerebbe.
_G.CrystalFonts.size = _G.CrystalFonts.size or {}
_G.CrystalFontChoice = _G.CrystalFontChoice or "Starborn"

-- Nome breve del peso, per l'etichetta della card.
_G.CrystalFonts.WEIGHT_LABEL = {
  Thin = "Thin", ExtraLight = "ExLight", Light = "Light", Regular = "",
  Medium = "Medium", SemiBold = "SemiBold", Bold = "Bold",
  ExtraBold = "ExBold", Heavy = "Heavy",
}

-- Catalogo completo, costruito una volta sola e tenuto in cache: sono
-- centinaia di voci, rifarle a ogni apertura del popup sarebbe sprecato.
function _G.CrystalFonts.list()
  local F = _G.CrystalFonts
  if F.cache then return F.cache end

  local out = {{ key = "Default", label = "Default", font = nil }}

  -- Famiglie uniche ricavate da Enum.Font. Si parte da li' perche' e'
  -- l'unico elenco che il motore garantisce: niente id inventati.
  local seen, families = {}, {}
  for _, item in ipairs(Enum.Font:GetEnumItems()) do
    if item.Name ~= "Unknown" then
      local ok, f = pcall(function() return Font.fromEnum(item) end)
      if ok and f and f.Family and not seen[f.Family] then
        seen[f.Family] = true
        -- Nome leggibile: dal percorso rbxasset si tiene solo il file.
        local nice = tostring(f.Family):match("([^/\\]+)%.json$")
                  or tostring(f.Family):match("([^/\\]+)$")
                  or item.Name
        families[#families + 1] = { family = f.Family, nice = nice }
      end
    end
  end

  for _, fam in ipairs(families) do
    for _, w in ipairs(Enum.FontWeight:GetEnumItems()) do
      for _, italic in ipairs({false, true}) do
        local ok, f = pcall(function()
          return Font.new(fam.family, w,
            italic and Enum.FontStyle.Italic or Enum.FontStyle.Normal)
        end)
        if ok and f then
          local wl = F.WEIGHT_LABEL[w.Name] or w.Name
          local label = fam.nice
          if wl ~= "" then label = label .. " " .. wl end
          if italic then label = label .. " Italic" end
          out[#out + 1] = {
            key = fam.family .. "|" .. w.Name .. "|" .. (italic and "i" or "n"),
            label = label,
            font = f,
          }
        end
      end
    end
  end

  F.cache = out
  return out
end

function _G.CrystalFonts.byKey(key)
  if key == "Starborn" then
    -- Default font: the Starborn family (Regular, non-italic) if the engine has it.
    local best
    for _, e in ipairs(_G.CrystalFonts.list()) do
      if e.label and string.find(string.lower(e.label), "starborn", 1, true) then
        if not best then best = e end
        if string.find(e.key, "|Regular|n", 1, true) then best = e break end
      end
    end
    return best
  end
  for _, e in ipairs(_G.CrystalFonts.list()) do
    if e.key == key then return e end
  end
  return nil
end

-- I contenitori da percorrere. HubGui copre tutte le ScreenGui della hub;
-- il billboard sopra la testa vive sulla Head e va aggiunto a mano.
function _G.CrystalFonts.roots()
  local list = {}
  local core = game:GetService("CoreGui")
  local pg = Player.PlayerGui
  local pgBillboard = pg:FindFirstChild("GreenDuelsBB")
  if pgBillboard then list[#list + 1] = pgBillboard end
  for _, container in ipairs({core, pg}) do
    pcall(function()
      local sg = container:FindFirstChild("EclipseHub")
      if sg then list[#list + 1] = sg end
    end)
  end
  local char = Player.Character
  local head = char and char:FindFirstChild("Head")
  if head then
    for _, n in ipairs({"Green22sBB", "22sSpeedBill", "SoundHubOverhead", "22sHubOverhead"}) do
      local oh = head:FindFirstChild(n)
      if oh then list[#list + 1] = oh end
    end
  end
  return list
end

function _G.CrystalFonts.isGlyph(obj)
  local t = obj.Text
  if t == nil then return false end
  -- Una lettera o una cifra sono scrittura anche da sole: la "Q" di una
  -- keybind o la "X" di un bottone sono caratteri normali, e devono
  -- seguire il font come tutto il resto. L'esenzione vale solo per i
  -- segni: ▲ ▼ ◀ ▶ - +.
  if string.match(t, "%w") then return false end
  local ok, n = pcall(function() return utf8.len(t) end)
  return ok and n ~= nil and n <= 1
end

function _G.CrystalFonts.applyOne(obj, font)
  if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then
    return
  end
  -- Elementi esenti: le anteprime del popup dei font devono mostrare
  -- CIASCUNA il proprio campione. Sono dentro la hub come tutto il resto,
  -- quindi senza questa uscita il font scelto le sovrascriverebbe e i
  -- campioni diventerebbero tutti uguali fra loro.
  if obj:GetAttribute("CrystalFontLock") then return end
  local F = _G.CrystalFonts
  -- Primo contatto: si conservano FontFace e TextSize di partenza.
  if F.orig[obj] == nil then
    F.orig[obj] = obj.FontFace
    F.size[obj] = obj.TextSize
  end
  if F.isGlyph(obj) then font = nil end   -- i simboli restano l'originale
  pcall(function()
    obj.FontFace = font or F.orig[obj]
    -- Si riparte SEMPRE dalla misura originale: l'adattamento sotto
    -- puo' solo rimpicciolire, mai ingrandire oltre com'era. Su Default
    -- questa riga e' anche il ripristino, e nessun adattamento segue.
    if F.size[obj] then obj.TextSize = F.size[obj] end
  end)
end

-- ADATTAMENTO AUTOMATICO DELLA MISURA
-- Ogni famiglia ha larghezze diverse: lo stesso testo che con Gotham sta
-- dentro la riga, con un font piu' largo esce dai margini.
--
-- La misura si CALCOLA, non si cerca a tentativi: GetTextBoundsAsync dice
-- quanto occuperebbe quel testo con quel font a quella misura, e con due
-- divisioni si ricava di quanto scalare. Ogni scritta e' a posto al primo
-- colpo, anche quelle che in quel momento non sono a schermo — le
-- dimensioni esistono comunque, mentre TextFits lo calcola il motore solo
-- su cio' che disegna, ed era per quello che si adattava la sola tab
-- aperta.
--
-- MARGIN: non basta che il testo "ci stia", deve anche non arrivare
-- appiccicato al bottone che ha accanto. Si toglie quel tanto di spazio
-- dai lati prima di fare il conto.
--
-- Su "Default" non gira affatto: le misure restano quelle di sempre.
_G.CrystalFonts.MIN_SIZE = 7    -- sotto e' illeggibile
_G.CrystalFonts.MARGIN   = 8    -- respiro ai lati, in pixel
_G.CrystalFonts.MAX_GROW = 1.35 -- quanto al massimo puo' crescere
-- Chiavi deboli: qui non si conserva niente da ripristinare, sono solo
-- appunti su chi e' gia' stato agganciato. Se l'oggetto sparisce dalla
-- GUI puo' sparire anche l'appunto.
_G.CrystalFonts.tconns = _G.CrystalFonts.tconns
  or setmetatable({}, {__mode = "k"})
-- Lunghezza del testo con cui ogni scritta e' stata adattata l'ultima
-- volta, per non rifare il conto a vuoto su un contatore che cambia cifra
-- restando lungo uguale.
_G.CrystalFonts.lastLen = _G.CrystalFonts.lastLen
  or setmetatable({}, {__mode = "k"})

function _G.CrystalFonts.params()
  local F = _G.CrystalFonts
  if F.gtbp == nil then
    local ok, p = pcall(function() return Instance.new("GetTextBoundsParams") end)
    F.gtbp = (ok and p) or false
  end
  return F.gtbp or nil
end

-- ------------------------------------------------------------
-- Il conto e' in DUE parti, e la differenza e' tutta qui.
--
-- 1) LA MISURA (costosa): quanto occupa quel testo col font nuovo e
--    quanto occupava col font originale. Da queste due nasce il rapporto
--    s0 — quanto scalare per avere lo stesso ingombro che la scritta
--    aveva su Default. Non c'entra niente con la casella, quindi si puo'
--    fare subito, anche su una scritta appena nata che non e' ancora
--    stata impaginata.
--
-- 2) IL CONTENIMENTO (gratis): il testo deve stare dentro la sua casella.
--    Qui serve la dimensione vera, ma NON serve rimisurare niente: le
--    dimensioni del testo sono gia' in cache, e ridurle allo spazio
--    disponibile sono due divisioni.
--
-- Separandole si risolve il problema di prima. Le scritte dei popup
-- nascono mentre il riquadro si sta ancora aprendo, e la loro casella in
-- quel momento e' piu' piccola di quella finale: con un conto solo o si
-- sbagliava, o bisognava aspettare e correggere dopo — ed era quello che
-- si vedeva cambiare sotto gli occhi. Adesso la parte 1 si applica
-- all'istante e la parte 2 si riapplica da sola a ogni variazione della
-- casella, quindi mentre il popup si ingrandisce il testo lo segue e
-- arriva gia' giusto. Stessa cosa per una freccetta o una riga dentro una
-- tendina chiusa: quando compare e prende una dimensione, si sistema da
-- se' senza che nessuno la tocchi.
-- ------------------------------------------------------------
_G.CrystalFonts.m = _G.CrystalFonts.m or setmetatable({}, {__mode = "k"})
_G.CrystalFonts.aconns = _G.CrystalFonts.aconns
  or setmetatable({}, {__mode = "k"})
_G.CrystalFonts.stamp = _G.CrystalFonts.stamp or 0

-- Parte 2: solo aritmetica sui numeri gia' in cache.
function _G.CrystalFonts.reclamp(obj)
  local F = _G.CrystalFonts
  local c = F.m[obj]
  if not c then return end
  -- Stessa esenzione di fitOne: un simbolo solo resta com'era.
  if F.isGlyph(obj) then
    if obj.TextSize ~= c.base then obj.TextSize = c.base end
    return
  end
  local s = c.s0
  local box = obj.AbsoluteSize
  if box.X > 1 and box.Y > 1 then
    -- AutomaticSize: su quell'asse la casella non e' un limite, e' il
    -- testo stesso a deciderla. Contenere il testo dentro una casella che
    -- lo insegue non ha senso e per di piu' si morde la coda: cambio la
    -- misura -> cambia la casella -> l'aggancio scatta -> ricontengo ->
    -- cambio di nuovo la misura, e si finisce dove capita. Il contatore
    -- degli MS e quello degli FPS sono gli unici due cosi' fatti nella
    -- barra, ed e' per questo che uno dei due si ritrovava con una misura
    -- che non c'entrava niente.
    local auto = obj.AutomaticSize
    local freeX = (auto == Enum.AutomaticSize.X or auto == Enum.AutomaticSize.XY)
    local freeY = (auto == Enum.AutomaticSize.Y or auto == Enum.AutomaticSize.XY)
    if not freeY then
      s = math.min(s, math.max(box.Y - 2, 1) / c.by)
    end
    -- Il respiro laterale e' in pixel, ma su una casella stretta 8px sono
    -- un quinto dello spazio: sotto una certa larghezza si accorcia con
    -- lei, se no le scritte piccole (FPS, MS, la percentuale) si
    -- ridurrebbero a niente.
    if not (freeX or c.wrapped) then
      s = math.min(s, math.max(box.X - math.min(F.MARGIN, box.X * 0.08), 1) / c.bx)
    end
  end
  local want = math.floor(c.base * s + 0.5)
  if want < F.MIN_SIZE then want = F.MIN_SIZE end
  if obj.TextSize ~= want then obj.TextSize = want end
end

-- Parte 1: le due misurazioni, e il rapporto con l'ingombro di Default.
function _G.CrystalFonts.measure(obj)
  local F = _G.CrystalFonts
  local font = F.current()
  if not font then return false end
  local prm = F.params()
  if not prm then return false end
  F.tsvc = F.tsvc or game:GetService("TextService")

  local base = F.size[obj]
  if not base then base = obj.TextSize; F.size[obj] = base end

  local txt = obj.Text
  if txt == nil or txt == "" then
    F.m[obj] = {base = base, bx = 1, by = 1, s0 = 1, stamp = F.stamp, text = txt}
    return true
  end

  -- Con TextWrapped la larghezza e' vincolata e quello che conta e'
  -- l'altezza; senza, si misura su una riga sola.
  local wrapped = obj.TextWrapped and obj.AbsoluteSize.X > 1
  prm.Text = txt
  prm.Size = base
  prm.Width = wrapped and obj.AbsoluteSize.X or 0

  prm.Font = font
  local ok, b = pcall(function() return F.tsvc:GetTextBoundsAsync(prm) end)
  if not (ok and b and b.X > 0 and b.Y > 0) then return false end

  -- L'ingombro col font ORIGINALE e' il riferimento: e' com'era la GUI su
  -- Default. Il font nuovo va portato li' — se disegna piu' largo si
  -- rimpicciolisce, se disegna piu' stretto si INGRANDISCE.
  local s0 = 1
  local of = F.orig[obj]
  if of then
    prm.Font = of
    local ok2, b2 = pcall(function() return F.tsvc:GetTextBoundsAsync(prm) end)
    if ok2 and b2 and b2.X > 0 and b2.Y > 0 then
      -- Il confronto e' sulla LARGHEZZA: l'altezza dei due riquadri e'
      -- quasi sempre la stessa (la misura del font e' gia' l'altezza
      -- della riga) e quel rapporto vale circa 1 sempre. Sul testo a capo
      -- vale l'opposto, li' la larghezza e' fissa per definizione.
      s0 = wrapped and (b2.Y / b.Y) or (b2.X / b.X)
    end
  end
  -- Tetto alla crescita: un font molto stretto non deve diventare enorme
  -- solo perche' la casella e' larga.
  if s0 > F.MAX_GROW then s0 = F.MAX_GROW end

  F.m[obj] = {base = base, bx = b.X, by = b.Y, s0 = s0,
              wrapped = wrapped, stamp = F.stamp, text = txt}
  return true
end

-- Misura se serve, poi contiene. noBox e' rimasto per compatibilita': la
-- casella ormai la guarda solo reclamp, che e' gratis.
function _G.CrystalFonts.fitOne(obj)
  local F = _G.CrystalFonts
  if not F.current() then return end
  if obj:GetAttribute("CrystalFontLock") then return end
  if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end
  if obj.TextScaled then return end

  -- I BOTTONI DI UN SEGNO SOLO NON SI TOCCANO, ne' nel font ne' nella
  -- misura: il criterio "stesso ingombro che aveva su Default" su un
  -- simbolo non vuol dire niente, e ricalcolarlo produceva solo quelle
  -- variazioni che sembravano un difetto quando li premevi.
  if F.isGlyph(obj) then return true end

  local c = F.m[obj]
  if not (c and c.stamp == F.stamp and c.text == obj.Text) then
    if not F.measure(obj) then return false end
  end
  F.reclamp(obj)
  return true
end

-- Aggancia una scritta: da qui in poi si tiene aggiornata da sola.
-- Un aggancio per oggetto, fatto una volta sola.
function _G.CrystalFonts.watch(obj)
  local F = _G.CrystalFonts
  if F.aconns[obj] then return end
  -- La casella cambia: durante l'apertura di un popup, con la GUI Scale,
  -- quando una tendina si apre. Qui non si rimisura niente, si ricontiene
  -- e basta.
  F.aconns[obj] = obj:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    local G = _G.CrystalFonts
    if not G.current() then return end
    if G.m[obj] then G.reclamp(obj) else pcall(G.fitOne, obj) end
  end)
  if F.tconns[obj] then return end
  -- Il testo cambia: LOCK che diventa UNLOCK, una keybind, un contatore.
  -- Un contatore che passa da 58 a 59 pero' occupa lo stesso spazio, e
  -- rimisurarlo a ogni cifra sarebbe lavoro buttato su roba che cambia
  -- anche piu' volte al secondo: si rifa il conto quando cambia la
  -- lunghezza.
  F.tconns[obj] = obj:GetPropertyChangedSignal("Text"):Connect(function()
    local G = _G.CrystalFonts
    if not G.current() then return end
    if G.lastLen[obj] == #obj.Text then return end
    G.lastLen[obj] = #obj.Text
    -- Anche il font va rideciso: una scritta puo' diventare un simbolo
    -- solo (o smettere di esserlo) e l'esenzione cambia con lei.
    pcall(G.applyOne, obj, G.current())
    pcall(G.fitOne, obj)
  end)
end

function _G.CrystalFonts.fit(pass)
  local F = _G.CrystalFonts
  F.fitToken = (F.fitToken or 0) + 1
  local myToken = F.fitToken
  if not F.current() then return end   -- Default: nessuna modifica
  F.tsvc = F.tsvc or game:GetService("TextService")

  task.spawn(function()
    local list = {}
    for _, root in ipairs(F.roots()) do
      for _, d in ipairs(root:GetDescendants()) do
        if (d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox"))
           and not d.TextScaled and not d:GetAttribute("CrystalFontLock") then
          list[#list + 1] = d
        end
      end
    end

    for _, o in ipairs(list) do
      if F.fitToken ~= myToken then return end   -- font cambiato nel frattempo
      if o.Parent then
        F.fitOne(o)
        F.lastLen[o] = #o.Text
        F.watch(o)
      end
    end

    -- Un ripasso comunque: un font appena scelto puo' non essere ancora
    -- stato caricato dal motore, e finche' non lo e' le misure che
    -- tornano sono quelle del ripiego. Il secondo giro cade a
    -- caricamento finito. La cache viene buttata apposta, se no si
    -- riuserebbero proprio i numeri sbagliati.
    pass = (tonumber(pass) or 0) + 1
    if pass < 3 then
      task.delay(pass == 1 and 0.35 or 1.5, function()
        if F.fitToken ~= myToken then return end
        F.stamp = F.stamp + 1
        F.fit(pass)
      end)
    end
  end)
end

-- Font attualmente scelto, oppure nil se siamo su "Default".
function _G.CrystalFonts.current()
  if toggleStates["Custom Font"] ~= true then return nil end
  local key = _G.CrystalFontChoice
  if not key or key == "Default" then return nil end
  local e = _G.CrystalFonts.byKey(key)
  return e and e.font or nil
end

function _G.CrystalFonts.applyAll()
  local F = _G.CrystalFonts
  local font = F.current()
  for _, root in ipairs(F.roots()) do
    F.applyOne(root, font)
    for _, d in ipairs(root:GetDescendants()) do
      F.applyOne(d, font)
    end
  end
  F.fit()
end

-- Aggancio a eventi, non a un loop: i popup e le righe create dopo
-- devono nascere gia' col font giusto, ma senza riscandire niente.
function _G.CrystalFonts.hook()
  local F = _G.CrystalFonts
  for _, c in ipairs(F.conns) do pcall(function() c:Disconnect() end) end
  F.conns = {}
  for _, root in ipairs(F.roots()) do
    F.conns[#F.conns + 1] = root.DescendantAdded:Connect(function(d)
      if not F.current() then return end
      F.applyOne(d, F.current())
      -- Subito, nello stesso istante in cui nasce: cosi' compare gia'
      -- della misura giusta invece di correggersi sotto gli occhi un
      -- attimo dopo. Il contenimento nella casella non serve aspettarlo,
      -- ci pensa l'aggancio qui sotto mentre il riquadro si apre.
      pcall(F.fitOne, d)
      pcall(F.watch, d)
    end)
  end
end

function _G.CrystalFonts.set(key, skipSave)
  _G.CrystalFontChoice = key or "Default"
  _G.CrystalFonts.stamp = (_G.CrystalFonts.stamp or 0) + 1
  _G.CrystalFonts.applyAll()
  _G.CrystalFonts.hook()
  -- Force overhead (discord + speed) to rebuild with new font
  pcall(function()
    if type(_G.__refreshSpeedBillboards) == "function" then
      -- re-apply style on existing labels
      local F = _G.CrystalFonts
      local font = F.current and F.current() or nil
      for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        local char = p.Character
        local head = char and char:FindFirstChild("Head")
        if head then
          for _, n in ipairs({"Green22sBB", "GreenDuelsBB", "22sSpeedBill"}) do
            local bb = head:FindFirstChild(n)
            if bb then
              for _, child in ipairs(bb:GetChildren()) do
                if child:IsA("TextLabel") then
                  F.applyOne(child, font)
                end
              end
            end
          end
        end
      end
    end
  end)
  if not skipSave and saveConfig then pcall(saveConfig) end
end

-- Il catalogo si costruisce una volta sola; farlo adesso in sottofondo
-- vuol dire che al primo click sul PICK e' gia' pronto in cache.
task.spawn(function() pcall(_G.CrystalFonts.list) end)


-- L'etichetta sopra la testa viene ricreata a ogni respawn: si riapplica
-- il font e si riaggancia il listener sul nuovo billboard.
if not _G.CrystalFonts.charConn then
  _G.CrystalFonts.charConn = Player.CharacterAdded:Connect(function()
    task.delay(1.5, function()
      if not _G.CrystalFonts.current() then return end
      pcall(_G.CrystalFonts.applyAll)
      pcall(_G.CrystalFonts.hook)
    end)
  end)
end

  
	end

	ScreenGui.Enabled = true

	task.defer(function()
	for _, feature in ipairs({ "FPS Boost", "Anti Lag", "Potato Graphics", "Vivid Graphics", "X-Ray" }) do
	if toggleStates[feature] and FeaturePostToggle[feature] then
	pcall(function() FeaturePostToggle[feature](true) end)
	end
	end
	end)

	end
	end)()



do
	local Players = game:GetService("Players")
	local LP = Players.LocalPlayer
	local NPC = { parts = {}, charConns = {}, connections = {}, running = false }

	local function lockPart(part, killTouch)
		if not part or not part:IsA("BasePart") then return end
		if NPC.parts[part] then return end
		local e = { cc = part.CanCollide, ct = part.CanTouch }
		NPC.parts[part] = e
		pcall(function() part.CanCollide = false end)
		if killTouch then pcall(function() part.CanTouch = false end) end
		e.conn = part:GetPropertyChangedSignal("CanCollide"):Connect(function()
			if not NPC.running then return end
			if part.CanCollide then pcall(function() part.CanCollide = false end) end
		end)
		e.destroy = part.AncestryChanged:Connect(function()
			if part:IsDescendantOf(game) then return end
			if e.conn then pcall(function() e.conn:Disconnect() end) end
			if e.destroy then pcall(function() e.destroy:Disconnect() end) end
			NPC.parts[part] = nil
		end)
	end

	local function unlockPart(part)
		local e = NPC.parts[part]
		if not e then return end
		if e.conn then pcall(function() e.conn:Disconnect() end) end
		if e.destroy then pcall(function() e.destroy:Disconnect() end) end
		NPC.parts[part] = nil
		if part and part.Parent then
			pcall(function() part.CanCollide = e.cc end)
			pcall(function() part.CanTouch = e.ct end)
		end
	end

	local function hookCharacter(char, isSelf)
		if not char or NPC.charConns[char] then return end
		NPC.charConns[char] = {}
		local function handle(obj)
			if not NPC.running then return end
			if not obj:IsA("BasePart") then return end
			if isSelf and obj.Name == "HumanoidRootPart" then return end
			lockPart(obj, not isSelf)
		end
		for _, obj in ipairs(char:GetDescendants()) do handle(obj) end
		table.insert(NPC.charConns[char], char.DescendantAdded:Connect(handle))
		table.insert(NPC.charConns[char], char.AncestryChanged:Connect(function(_, parent)
			if parent == nil then
				for _, c in ipairs(NPC.charConns[char] or {}) do pcall(function() c:Disconnect() end) end
				NPC.charConns[char] = nil
			end
		end))
	end

	local function startCore()
		if NPC.running then return end
		NPC.running = true
		for _, c in ipairs(NPC.connections) do pcall(function() c:Disconnect() end) end
		NPC.connections = {}
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr.Character then hookCharacter(plr.Character, plr == LP) end
			table.insert(NPC.connections, plr.CharacterAdded:Connect(function(ch)
				task.wait(0.1)
				if NPC.running then hookCharacter(ch, plr == LP) end
			end))
		end
		table.insert(NPC.connections, Players.PlayerAdded:Connect(function(plr)
			table.insert(NPC.connections, plr.CharacterAdded:Connect(function(ch)
				task.wait(0.1)
				if NPC.running then hookCharacter(ch, false) end
			end))
		end))
	end

	local function stopCore()
		NPC.running = false
		for _, c in ipairs(NPC.connections) do pcall(function() c:Disconnect() end) end
		NPC.connections = {}
		for char, list in pairs(NPC.charConns) do
			for _, c in ipairs(list) do pcall(function() c:Disconnect() end) end
			NPC.charConns[char] = nil
		end
		for part in pairs(NPC.parts) do unlockPart(part) end
		NPC.parts = {}
	end

	_G.__SoundNoPlayerCollision = {
		SetEnabled = function(on)
			if on then startCore() else stopCore() end
		end,
	}

	task.defer(function()
		local on = false
		pcall(function()
			if type(toggleStates) == "table" and toggleStates["No Player Collision"] == true then on = true end
		end)
		if not on then
			pcall(function()
				local data = readfile and readfile("SoundHub_UI_Config.txt")
				if type(data) == "string" and data:find("T:No Player Collision=true", 1, true) then on = true end
			end)
		end
		if on then _G.__SoundNoPlayerCollision.SetEnabled(true) end
	end)
end







-- ==================== ANTI ANTI LOSE (client harden vs enemy lag/crash flood) ====================
do
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local NetworkClient = game:GetService("NetworkClient")
	local SoundService = game:GetService("SoundService")
	local Debris = game:GetService("Debris")

	local aal = {
		enabled = false,
		conn = nil,
		hooked = false,
		oldNamecall = nil,
		lastShieldAt = 0,
		lastCleanupAt = 0,
		disabledConns = {},
		blockedRemoteNames = {
			SetPlayerBlockList = true,
			SetBlockList = true,
			BlockList = true,
			Crash = true,
			Lag = true,
			LagServer = true,
			Flood = true,
			Spam = true,
			Nuke = true,
			KickMe = true,
		},
	}

	local function resolveBlockListRemote()
		local rrs = game:FindFirstChild("RobloxReplicatedStorage")
		if not rrs then return nil end
		for _, name in ipairs({"SetPlayerBlockList", "SetBlockList"}) do
			local r = rrs:FindFirstChild(name)
			if r and (r:IsA("RemoteEvent") or r:IsA("UnreliableRemoteEvent")) then return r end
		end
		return nil
	end

	local function hardenNetwork()
		pcall(function() settings().Network.IncomingReplicationLag = 0 end)
		pcall(function() settings().Network.PhysicsSendRate = 20 end)
		pcall(function()
			if NetworkClient and NetworkClient.SetOutgoingKBPSLimit then
				NetworkClient:SetOutgoingKBPSLimit(15000)
			end
		end)
		pcall(function()
			settings().Rendering.QualityLevel = settings().Rendering.QualityLevel
		end)
	end

	local function stripRemoteClientHandlers()
		local remote = resolveBlockListRemote()
		if not remote then return end
		pcall(function()
			if type(getconnections) ~= "function" then return end
			local ev = remote.OnClientEvent
			if not ev then return end
			for _, c in ipairs(getconnections(ev)) do
				pcall(function()
					if c.Disable then c:Disable()
					elseif c.Disconnect then c:Disconnect()
					end
				end)
				if not aal.seenConns then aal.seenConns = setmetatable({}, {__mode = "k"}) end
				if not aal.seenConns[c] then
					aal.seenConns[c] = true
					table.insert(aal.disabledConns, c)
				end
			end
		end)
	end

	-- Clean crash/lag spam left by other players: excess sounds, particles, beams, trails
	local function cleanupCrashDebris()
		local char = LocalPlayer.Character
		-- Cap runaway sounds
		pcall(function()
			local sounds = SoundService:GetChildren()
			if #sounds > 40 then
				for i = 1, math.min(#sounds - 20, 30) do
					local s = sounds[i]
					if s and s:IsA("Sound") and s.Name ~= "SoundIntroSong" then
						pcall(function() s:Stop(); s:Destroy() end)
					end
				end
			end
		end)
		-- Strip extreme particle spam under workspace that is not characters
		-- perf: this walks the whole map, so only do it every ~8s
		local nowScan = os.clock()
		if (_G.__SoundLastDebrisScan or 0) + 8 <= nowScan then
		_G.__SoundLastDebrisScan = nowScan
		if not _G.__SoundDebrisScanBusy then
		_G.__SoundDebrisScanBusy = true
		task.spawn(function()
		pcall(function()
			local n = 0
			local descs = workspace:GetDescendants()
			for di = 1, #descs do
				local obj = descs[di]
				if di % 400 == 0 then task.wait() end
				if n > 80 then break end
				if obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
					if obj.Enabled and (obj.Rate or 0) > 200 then
						pcall(function() obj.Enabled = false; obj.Rate = 0 end)
						n = n + 1
					end
				elseif obj:IsA("Sound") and obj.Playing and obj.Volume > 2 then
					pcall(function() obj.Volume = math.min(obj.Volume, 1) end)
					n = n + 1
				end
			end
		end)
		_G.__SoundDebrisScanBusy = false
		end)
		end
		end
		-- Stabilize local character under lag-switch / crash desync
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			local root = char:FindFirstChild("HumanoidRootPart")
			if hum then
				pcall(function()
					if hum.Health <= 0 and type(_G.__CrystalAntiDieIsEnabled) == "function" then
						local ok, on = pcall(_G.__CrystalAntiDieIsEnabled)
						if ok and on then
							hum.Health = hum.MaxHealth
							hum.BreakJointsOnDeath = false
							hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
						end
					end
				end)
			end
			if root then
				pcall(function()
					local v = root.AssemblyLinearVelocity
					if v.Magnitude > 280 then
						root.AssemblyLinearVelocity = Vector3.new(
							math.clamp(v.X, -70, 70),
							math.clamp(v.Y, -70, 70),
							math.clamp(v.Z, -70, 70)
						)
					end
					if root.AssemblyAngularVelocity.Magnitude > 30 then
						root.AssemblyAngularVelocity = Vector3.zero
					end
				end)
			end
		end
		-- Request a light GC pass if available (executor)
		pcall(function()
			if type(gcinfo) == "function" then
				local kb = gcinfo()
				if type(kb) == "number" and kb > 350000 then
					if type(collectgarbage) == "function" then collectgarbage("collect") end
				end
			end
		end)
	end

	local function installNamecallShield()
		if aal.hooked then return end
		if type(hookmetamethod) ~= "function" or type(getnamecallmethod) ~= "function" then return end
		local ok, old = pcall(function()
			local handler = function(self, ...)
				local method = getnamecallmethod()
				if aal.enabled and (method == "FireServer" or method == "InvokeServer") then
					local name = ""
					pcall(function() name = tostring(self.Name or "") end)
					if aal.blockedRemoteNames[name] or name:lower():find("crash", 1, true) or name:lower():find("lag", 1, true) then
						local args = { ... }
						local payload = args[1]
						if type(payload) == "table" then
							local n = 0
							pcall(function() n = #payload end)
							if n > 2000 then return nil end
						end
						-- Drop absurd string payloads that freeze the VM
						if type(payload) == "string" and #payload > 50000 then return nil end
					end
					if name == "SetPlayerBlockList" or name == "SetBlockList" then
						local args = { ... }
						local payload = args[1]
						if type(payload) == "table" then
							local n = 0
							pcall(function() n = #payload end)
							if n > 2000 then return nil end
						end
					end
				end
				return old(self, ...)
			end
			if newcclosure then handler = newcclosure(handler) end
			return hookmetamethod(game, "__namecall", handler)
		end)
		if ok and old then
			aal.oldNamecall = old
			aal.hooked = true
		end
	end

	local function softStabilizeCharacter()
		local char = LocalPlayer.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		local root = char:FindFirstChild("HumanoidRootPart")
		if not hum or not root then return end
		if hum.Health <= 0 and type(_G.__CrystalAntiDieIsEnabled) == "function" then
			local ok, on = pcall(_G.__CrystalAntiDieIsEnabled)
			if ok and on then
				pcall(function()
					hum.Health = hum.MaxHealth
					hum.BreakJointsOnDeath = false
				end)
			end
		end
		local v = root.AssemblyLinearVelocity
		if v.Magnitude > 350 then
			root.AssemblyLinearVelocity = Vector3.new(
				math.clamp(v.X, -80, 80),
				math.clamp(v.Y, -80, 80),
				math.clamp(v.Z, -80, 80)
			)
		end
		if root.AssemblyAngularVelocity.Magnitude > 40 then
			root.AssemblyAngularVelocity = Vector3.zero
		end
	end

	local function startShield()
		if aal.enabled then return end
		aal.enabled = true
		hardenNetwork()
		stripRemoteClientHandlers()
		installNamecallShield()
		cleanupCrashDebris()
		pcall(function()
			if _G.__SoundAntiLosePanel and _G.__SoundAntiLosePanel.SetEnabled then
				_G.__SoundAntiLosePanel.SetEnabled(false)
			end
		end)
		if aal.conn then pcall(function() aal.conn:Disconnect() end) end
		aal.conn = RunService.Heartbeat:Connect(function()
			if not aal.enabled then return end
			local now = tick()
			if now - aal.lastShieldAt >= 0.15 then
				aal.lastShieldAt = now
				hardenNetwork()
				if now - (aal.lastStripAt or 0) >= 1 then
					aal.lastStripAt = now
					stripRemoteClientHandlers()
				end
				softStabilizeCharacter()
			end
			-- Deeper crash cleanup every ~0.75s
			if now - aal.lastCleanupAt >= 0.75 then
				aal.lastCleanupAt = now
				cleanupCrashDebris()
			end
		end)
		if type(_G.__CrystalTrackConn) == "function" and aal.conn then
			pcall(_G.__CrystalTrackConn, aal.conn)
		end
	end

	local function stopShield()
		aal.enabled = false
		if aal.conn then pcall(function() aal.conn:Disconnect() end) aal.conn = nil end
		for _, c in ipairs(aal.disabledConns) do
			pcall(function()
				if c.Enable then c:Enable() end
			end)
		end
		aal.disabledConns = {}
		pcall(function()
			if NetworkClient and NetworkClient.SetOutgoingKBPSLimit then
				NetworkClient:SetOutgoingKBPSLimit(math.huge)
			end
		end)
	end

	FeaturePostToggle["Anti Anti Lose"] = function(active)
		active = active == true
		toggleStates["Anti Anti Lose"] = active
		if active then startShield() else stopShield() end
	end

	_G.__SoundAntiAntiLose = {
		Start = startShield,
		Stop = stopShield,
		IsEnabled = function() return aal.enabled end,
		Cleanup = cleanupCrashDebris,
	}

	if toggleStates["Anti Anti Lose"] == true then
		task.defer(startShield)
	end
end



