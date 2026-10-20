local Players = game:GetService("Players")
local M = {}
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local player = Players.LocalPlayer
local currentlyDragging = nil

-- Colore principale della GUI (selezionabile dall'utente). Dichiarato qui in cima
-- così è già disponibile per colorare l'intro prima che il resto della GUI venga costruito.
local guiAccentColor = Color3.fromRGB(220, 0, 0)

-- ------------------------------------------------------------
-- EARLY CONFIG LOAD (for intro sound setting + intro accent color)
-- ------------------------------------------------------------
local introSoundEnabled = false
if isfile and isfile("aspecthub.json") then
    local ok, data = pcall(function() return HS:JSONDecode(readfile("aspecthub.json")) end)
    if ok and type(data) == "table" then
        if data.introSoundEnabled ~= nil then
            introSoundEnabled = data.introSoundEnabled
        end
        if type(data.guiAccent) == "table" and data.guiAccent.r and data.guiAccent.g and data.guiAccent.b then
            guiAccentColor = Color3.fromRGB(
                math.clamp(tonumber(data.guiAccent.r) or 176, 0, 255),
                math.clamp(tonumber(data.guiAccent.g) or 148, 0, 255),
                math.clamp(tonumber(data.guiAccent.b) or 255, 0, 255)
            )
        end
    end
end

-- ------------------------------------------------------------
-- INTRO SOUND (only if enabled) – scarica/prepara il suono, ma la riproduzione
-- viene avviata dalla sequenza INTRO SEQUENCE, sincronizzata con l'animazione
-- ------------------------------------------------------------
local introSoundInstance = nil
local introSoundReady = false
if introSoundEnabled then
    task.spawn(function()
        local urlIntro = "https://files.catbox.moe/hg5cr4.mp3"   -- <-- this is the one you want
        local numeFisier = "aspect_intro.mp3"                     -- <-- NEW FILENAME to avoid old cache

        -- Always download and overwrite the file (we use pcall to avoid errors)
        local ok, data = pcall(function() return game:HttpGet(urlIntro) end)
        if ok and data then
            pcall(function() writefile(numeFisier, data) end)
        end

        introSoundInstance = Instance.new("Sound")
        introSoundInstance.Volume = 3
        introSoundInstance.Looped = false
        -- Parent impostato per primo e separatamente: se getcustomasset fallisce
        -- (executor che non lo supporta, download fallito, ecc.) il suono resta
        -- comunque parentato e diagnosticabile, invece di sparire silenziosamente
        if not pcall(function() introSoundInstance.Parent = game:GetService("CoreGui") end) then
            pcall(function() introSoundInstance.Parent = game:GetService("SoundService") end)
        end
        pcall(function() introSoundInstance.SoundId = getcustomasset(numeFisier) end)
        introSoundReady = true
    end)
end

repeat task.wait() until game:IsLoaded()

-- ============================================================
-- SKY THEME SYSTEM
-- ============================================================
local CANDY_SKY_TAG = "AspectSkyTheme"
local currentSkyTheme = "Night"
local CANDY_SKY_PRESETS = {
    ["Off"]={kind="off"},
    ["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.5,dens=0.55,color={200,150,255}}},
    ["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
    ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
    ["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
    ["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
    ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}
local SkyOrder={"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}
function M.candyColor(rgb) return Color3.fromRGB(rgb[1],rgb[2],rgb[3]) end
function M.CandyApplyCustomSky(mode)
    for _,child in ipairs(Lighting:GetChildren()) do if child:GetAttribute(CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end
    local terrain=workspace:FindFirstChildOfClass("Terrain")
    if terrain then for _,child in ipairs(terrain:GetChildren()) do if child:GetAttribute(CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end end
    local preset=CANDY_SKY_PRESETS[mode]
    if not preset or preset.kind=="off" then Lighting.ClockTime=14;Lighting.Brightness=2;Lighting.OutdoorAmbient=Color3.fromRGB(127,127,127);Lighting.Ambient=Color3.fromRGB(127,127,127);Lighting.FogEnd=100000;Lighting.GlobalShadows=true;return end
    Lighting.FogStart=0;Lighting.FogEnd=100000;Lighting.FogColor=Color3.fromRGB(200,200,200);Lighting.ColorShift_Top=Color3.fromRGB(0,0,0);Lighting.ColorShift_Bottom=Color3.fromRGB(0,0,0);Lighting.GlobalShadows=true
    Lighting.ClockTime=preset.clock or 14;Lighting.Brightness=preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient=M.candyColor(preset.outAmb) end
    if preset.ambient then Lighting.Ambient=M.candyColor(preset.ambient) end
    if preset.sky then
        local skyInst=Instance.new("Sky");skyInst:SetAttribute(CANDY_SKY_TAG,true)
        if preset.sky.stars then skyInst.StarCount=preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize=preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize=preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId="rbxasset://sky/moon.jpg" end
        skyInst.Parent=Lighting
    end
    if preset.atm then
        local atm=Instance.new("Atmosphere");atm:SetAttribute(CANDY_SKY_TAG,true)
        atm.Density=preset.atm.dens or 0.3;atm.Color=M.candyColor(preset.atm.color);atm.Decay=M.candyColor(preset.atm.decay);atm.Glare=preset.atm.glare or 1;atm.Haze=preset.atm.haze or 1;atm.Parent=Lighting
    end
    if preset.clouds and terrain then
        local clouds=Instance.new("Clouds");clouds:SetAttribute(CANDY_SKY_TAG,true)
        clouds.Cover=preset.clouds.cover or 0.5;clouds.Density=preset.clouds.dens or 0.5;clouds.Color=M.candyColor(preset.clouds.color);clouds.Parent=terrain
    end
end

-- ============================================================================
-- INTRO SEQUENCE (portata da Vortex Hub, colorata in base all'accent color scelto)
-- ============================================================================
task.spawn(function()
    local IntroTween     = TweenService
    local CoreGui        = game:GetService("CoreGui")
    local INTRO_DURATION = 1.0 -- ridotta da 3.2s su richiesta
    local BLINK_INTERVAL = 0.15

    local function shade(c, m)
        return Color3.new(
            math.clamp(c.R*m, 0, 1),
            math.clamp(c.G*m, 0, 1),
            math.clamp(c.B*m, 0, 1)
        )
    end

    local blur = Instance.new("BlurEffect")
    blur.Size   = 56
    blur.Parent = Lighting

    local introGui = Instance.new("ScreenGui")
    introGui.Name           = "AspectIntro"
    introGui.ResetOnSpawn   = false
    introGui.IgnoreGuiInset = true
    introGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    if not pcall(function() introGui.Parent = CoreGui end) then
        introGui.Parent = player:WaitForChild("PlayerGui")
    end

    local overlay = Instance.new("Frame", introGui)
    overlay.Size = UDim2.new(1,0,1,0)
    overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
    overlay.BackgroundTransparency = 0.55
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 100

    local tag = Instance.new("TextLabel", introGui)
    tag.Size                   = UDim2.new(0, 520, 0, 94)
    tag.Position               = UDim2.new(0.5, -260, 0.5, -56)
    tag.BackgroundTransparency = 1
    tag.Text                   = "MANUXS HUB"
    tag.Font                   = Enum.Font.GothamBlack
    tag.TextSize               = 62
    tag.TextColor3             = guiAccentColor
    tag.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
    tag.TextStrokeTransparency = 0.7
    tag.TextXAlignment         = Enum.TextXAlignment.Center
    tag.TextTransparency       = 0
    tag.ZIndex                 = 110

    local line = Instance.new("Frame", introGui)
    line.Size = UDim2.new(0, 340, 0, 1)
    line.Position = UDim2.new(0.5, -170, 0.5, 36)
    line.BackgroundColor3 = guiAccentColor
    line.BackgroundTransparency = 0.2
    line.BorderSizePixel = 0
    line.ZIndex = 110

    local sub = Instance.new("TextLabel", introGui)
    sub.Size                   = UDim2.new(0, 520, 0, 30)
    sub.Position               = UDim2.new(0.5, -260, 0.5, 42)
    sub.BackgroundTransparency = 1
    sub.Text                   = "H  U  B"
    sub.Font                   = Enum.Font.GothamBold
    sub.TextSize               = 18
    sub.TextColor3             = shade(guiAccentColor, 0.8)
    sub.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
    sub.TextStrokeTransparency = 0.5
    sub.TextXAlignment         = Enum.TextXAlignment.Center
    sub.TextTransparency       = 0
    sub.ZIndex                 = 110

    local blinkActive = true
    local visible     = true
    task.spawn(function()
        while blinkActive do
            task.wait(BLINK_INTERVAL)
            visible = not visible
            tag.TextTransparency  = visible and 0 or 1
            sub.TextTransparency  = visible and 0 or 0.5
            line.BackgroundTransparency = visible and 0.4 or 0.85
        end
    end)

    -- Avvia la musica selezionata in sincronia con la comparsa dell'intro
    -- (se il file è ancora in download, aspetta al massimo 2.5s prima di rinunciare)
    if introSoundEnabled then
        local waited = 0
        while not introSoundReady and waited < 0.6 do
            task.wait(0.1)
            waited = waited + 0.1
        end
        if introSoundInstance then
            if not introSoundInstance.IsLoaded then
                local loaded = false
                local loadedConn
                loadedConn = introSoundInstance.Loaded:Connect(function() loaded = true end)
                local lw = 0
                while not loaded and lw < 1.5 do
                    task.wait(INT.HEAD_COUNTDOWN_INTERVAL)
                    lw = lw + 0.05
                end
                if loadedConn then loadedConn:Disconnect() end
            end
            pcall(function() introSoundInstance:Play() end)
        end
    end

    task.wait(INTRO_DURATION)

    blinkActive = false
    local fadeInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    tag.TextTransparency = 0
    IntroTween:Create(tag,     fadeInfo, {TextTransparency = 1}):Play()
    IntroTween:Create(sub,     fadeInfo, {TextTransparency = 1}):Play()
    IntroTween:Create(line,    fadeInfo, {BackgroundTransparency = 1}):Play()
    IntroTween:Create(overlay, fadeInfo, {BackgroundTransparency = 1}):Play()
    IntroTween:Create(blur,    fadeInfo, {Size = 0}):Play()
    if introSoundInstance and introSoundInstance.IsPlaying then
        IntroTween:Create(introSoundInstance, TweenInfo.new(0.6), {Volume = 0}):Play()
    end
    task.wait(0.35)

    pcall(function() blur:Destroy() end)
    pcall(function() introGui:Destroy() end)
    pcall(function()
        if introSoundInstance then
            introSoundInstance:Stop()
            introSoundInstance:Destroy()
        end
    end)

    -- Costruzione della GUI principale dopo la fine dell'intro
    M.loadConfigKeys()
    M.buildGui()
    M.bindLayoutCycler()
    M.bindGlobalKeybinds()
    M.loadConfigState()
    M.buildMobileButtons()
    M.createStealBar()
    M.CandyApplyCustomSky(currentSkyTheme)
end)

-- ============================================================
-- STATE
-- ============================================================
local TS=TweenService
local LP=Players.LocalPlayer
local NS,CS=60,30
local LAGGER_SPEED=15
local LAGGER_CARRY_SPEED=24.5
local St = {} -- tabella di stato per ridurre il numero di local variables top-level (limite Luau 200)
St.carrySpeedActive= false
St.laggerModeEnabled= false
local FX={espHighlightCache={},espBillboardCache={},espTracerCache={},espEnabled=false,fpsBoostEnabled=false,removedAccessories={}}

St.configLoaded=false -- blocca l'autosave finché loadConfigKeys() non ha ripristinato lo stato salvato
St.antiRagdollEnabled,St.infJumpEnabled=false,false
St.medusaCounterEnabled,St.batCounterEnabled,St.unwalkEnabled=false,false,false
St.medusaResetEnabled= false
St.medusaDebounce,St.medusaLastUsed,St.dropActive=false,0,false
St.autoLeftEnabled,St.autoRightEnabled=false,false
St.autoBatEnabled=false
St.batAimbotMode="Normal"
St.normalBatSpeed=58
St.bypassBatSpeed=58
St.bypassLaggerBatSpeed=40
St.autoSwingEnabled=true
_G._batPredEnabled=false
St.autoMoveSwingEnabled=false
St.autoMoveSwingInterval=0.3
St._alSwingDebounce=false
St._arSwingDebounce=false
St.resetAutoBatMotion=nil

St.antiLagEnabled,St.removeAccessoriesEnabled,St.antiLagDescConn=false,false,nil
St.stretchRezEnabled,St.stretchRezConn=false,nil
St.unwalkSavedAnimate,St._anyKeyListening=nil,false
St.autoTPEnabled,St.autoTPHeight,St.autoTPConn=false,20,nil
_G._tpBatEnabled=false
_G._tpBatConn=nil
_G._tpBatCooldown=false
local cursedResetRemote=nil
local CURSED_RESET_GUID="f888ee6e-c86d-46e1-93d7-0639d6635d42"
St.guiTransparencyEnabled,St.mobileButtonsEnabled,St.mobileButtonsLocked=false,true,false
St.guiBackgroundEnabled=false
St.guiBackgroundIndex=0
-- guiAccentColor è già dichiarato in cima al file (serve anche per l'intro)
St.mobileButtonsSize=60
St.circleButtonsEnabled=false
local mobBtnRefs={}

-- ============================================================
-- PERFORMANCE: shared FPS/Ping updater
-- One Heartbeat connection services every stats label, instead
-- of running a separate task.wait() loop for each GUI layout.
-- ============================================================
local PerfStats = {
    labels = {},
    conn = nil,
    nextUpdate = 0,
    frameCount = 0,
    windowStart = nil,
}

local function bindStatsLabel(label, multiline)
    if not label then return end
    PerfStats.labels[label] = multiline == true
    if PerfStats.conn then return end

    PerfStats.conn = RunService.Heartbeat:Connect(function()
        local now = tick()
        PerfStats.frameCount = PerfStats.frameCount + 1
        if now < PerfStats.nextUpdate then return end

        local elapsed = now - (PerfStats.windowStart or now)
        if elapsed <= 0 then elapsed = 0.5 end
        local fps = math.floor((PerfStats.frameCount / elapsed) + 0.5)
        PerfStats.frameCount = 0
        PerfStats.windowStart = now
        PerfStats.nextUpdate = now + 0.5

        local ok, ms = pcall(function()
            return LP:GetNetworkPing() * 1000
        end)
        local ping = ok and math.floor(ms + 0.5) or "--"

        local alive = false
        for lbl, multi in pairs(PerfStats.labels) do
            if lbl and lbl.Parent then
                alive = true
                if lbl:GetAttribute("HeaderStats") then
                    lbl.Text = string.format("Ping: %sms | FPS: %s", ping, fps)
                elseif multi then
                    lbl.Text = string.format("%sfps\n%sms", fps, ping)
                else
                    lbl.Text = string.format("FPS %s | %sms", fps, ping)
                end
            else
                PerfStats.labels[lbl] = nil
            end
        end

        if not alive then
            PerfStats.conn:Disconnect()
            PerfStats.conn = nil
            PerfStats.frameCount = 0
            PerfStats.windowStart = nil
            PerfStats.nextUpdate = 0
        end
    end)
end
St.mobGuiRef=nil
St.fovValue=80
local fovOptions={80,120,180}
St.fovIndex=1
local UIRefs = {}
UIRefs.laggerModePillRef = nil
UIRefs.carryModePillRef = nil
UIRefs.modeValLbl = nil
UIRefs.speedLabel = nil
UIRefs.activeBatBillboard = nil
UIRefs.activeMedusaBillboard = nil
UIRefs.stealBarFrame = nil
UIRefs.stealBarStroke = nil
UIRefs.stealBarFill = nil
UIRefs.stealBarPct = nil
UIRefs.stealBarRadius = nil
UIRefs.stealBarTitle = nil
UIRefs.autoBatSetVisual = nil
UIRefs.setBatCounterVisual = nil
UIRefs.setStretchRezVisual = nil
UIRefs.setAutoTPVisual = nil
UIRefs.autoLeftSetVisual = nil
UIRefs.autoRightSetVisual = nil
UIRefs.antiKickSetVisual = nil
UIRefs.persistentRagdollGui = nil
UIRefs.speedTopLabel = nil
UIRefs.speedBillboard = nil
UIRefs.bgGrad = nil

local function applyBackgroundImage(index)
    St.guiBackgroundEnabled=false
    St.guiBackgroundIndex=0
end
UIRefs.ragdollStatusLabel = nil
UIRefs.stealBarShadow = nil
UIRefs.setTryhardAnimVisual = nil
UIRefs.animPackUpdateDisplay = nil
UIRefs.standDropBtn = nil
UIRefs.jumpDropBtn = nil
UIRefs.refreshDropTypeButtons = nil
St.autoSwitchSpeedEnabled=false
local DROP_TYPES={STAND="Stand Drop",JUMP="Jump Drop"}
St.currentDropType=DROP_TYPES.STAND
local _wfConns={}
St.mobBtnTransparencyEnabled=false
St.perButtonDragEnabled=true
St.antiKickEnabled=false
St.brainrotDetected=false
-- Body Lock (Blossom)
St.bodyLockEnabled=false
St.bodyLockRange=20
St._bodyLockConn=nil
St._bodyLockSuppressed=false
UIRefs.bodyLockSetVisual=nil
St.ragdollGuiEnabled=true   -- always show ragdoll timer gui by default
St.tryhardAnimEnabled=false

-- Animation Pack state
St.animPackEnabled=false
St.animPackIndex=1
St.animPackApplying=false
local ANIM_ATTR_LAST="AspectAnimPack_Last"

St._tryhardHeartbeatConn=nil
St._tryhardOriginalAnims=nil
St.activeHeadCountdownToken=0
St.uiLocked=false
St.infJumpMode="manual"
St.holdInfJumpConn=nil
local DROP_ASCEND_DURATION=0.2
local DROP_ASCEND_SPEED=150
St.stealBarSavedPos=nil
-- Consolidate interval constants into one table to stay under Luau's 200-local
-- limit per chunk (the script was crashing at startup because this file had
-- crossed that limit by a handful of variables).
local INT = {
    AUTO_STEAL_INTERVAL=0.12,
    AUTOSWITCH_INTERVAL=0.2,
    MANUAL_JUMP_INTERVAL=0.08,
    SPEED_LABEL_REFRESH_INTERVAL=0.1,
    BAT_COUNTER_INTERVAL=0.08,
    AIMBOT_TARGET_REFRESH_INTERVAL=0.08,
    AIMBOT_EQUIP_INTERVAL=0.2,
    TPBAT_TARGET_REFRESH_INTERVAL=0.08,
    ANTIRAGDOLL_FIX_INTERVAL=0.2,
    TRYHARD_REFRESH_INTERVAL=1.5,
    FOV_REFRESH_INTERVAL=0.15,
    STEAL_BAR_RADIUS_INTERVAL=0.15,
}
St._tryhardRefreshToken=0
St._manualJumpNextAt=0
St._nextAutoStealAt=0
St._nextSpeedLabelAt=0
St._nextBatCounterAt=0
St._nextAimbotTargetAt=0
St._nextAimbotEquipAt=0
St._cachedAimbotTarget=nil
St._nextTpBatTargetAt=0
St._cachedTpBatTarget=nil
St._nextAntiRagFixAt=0
St._nextFovApplyAt=0
St._nextStealBarRadiusCheckAt=0
St._cachedStealBarInRadius=false
St._noCollidePlayerConns={}
St._antiRagControlModule=nil
INT.BTN_POS_SAVE_INTERVAL=10
INT.HEAD_COUNTDOWN_INTERVAL=0.1
INT.STEAL_BAR_VISUAL_INTERVAL=0.033
INT.SHIMMER_VISUAL_INTERVAL=0.06

local function getAspectControlModule()
    if St._antiRagControlModule ~= nil then
        return St._antiRagControlModule or nil
    end
    local playerScripts = LP:FindFirstChild("PlayerScripts")
    local PM = playerScripts and playerScripts:FindFirstChild("PlayerModule")
    local CM = PM and PM:FindFirstChild("ControlModule")
    if not CM then
        St._antiRagControlModule = false
        return nil
    end
    local ok, mod = pcall(require, CM)
    St._antiRagControlModule = ok and mod or false
    return ok and mod or nil
end

-- ============================================================
-- TRYHARD ANIM (from Radiant)
-- ============================================================
local TRYHARD_ANIMS = {
    idle1="rbxassetid://133806214992291", idle2="rbxassetid://94970088341563",
    walk="rbxassetid://707897309",        run="rbxassetid://707861613",
    jump="rbxassetid://116936326516985",  fall="rbxassetid://116936326516985",
    climb="rbxassetid://116936326516985", swim="rbxassetid://116936326516985",
    swimidle="rbxassetid://116936326516985",
}

function M._isTryhardId(id)
    if not id then return false end
    for _,v in pairs(TRYHARD_ANIMS) do
        if v == id then return true end
    end
    return false
end

function M._saveOriginalAnims(char)
    local anim = char and char:FindFirstChild("Animate")
    if not anim then return end
    local function g(o) return o and o.AnimationId or nil end
    local ids = {
        idle1=g(anim.idle and anim.idle.Animation1), idle2=g(anim.idle and anim.idle.Animation2),
        walk=g(anim.walk and anim.walk.WalkAnim),    run=g(anim.run and anim.run.RunAnim),
        jump=g(anim.jump and anim.jump.JumpAnim),    fall=g(anim.fall and anim.fall.FallAnim),
        climb=g(anim.climb and anim.climb.ClimbAnim),swim=g(anim.swim and anim.swim.Swim),
        swimidle=g(anim.swimidle and anim.swimidle.SwimIdle),
    }
    -- salva solo se non è già un pack (evita di salvare "il pack" come originale)
    if not M._isTryhardId(ids.walk) then
        St._tryhardOriginalAnims = ids
    end
end

function M._applyTryhardPack(char)
    local anim = char and char:FindFirstChild("Animate")
    if not anim then return end
    local function s(o,id) if o and id then o.AnimationId = id end end
    s(anim.idle and anim.idle.Animation1, TRYHARD_ANIMS.idle1)
    s(anim.idle and anim.idle.Animation2, TRYHARD_ANIMS.idle2)
    s(anim.walk and anim.walk.WalkAnim,   TRYHARD_ANIMS.walk)
    s(anim.run and anim.run.RunAnim,      TRYHARD_ANIMS.run)
    s(anim.jump and anim.jump.JumpAnim,   TRYHARD_ANIMS.jump)
    s(anim.fall and anim.fall.FallAnim,   TRYHARD_ANIMS.fall)
    s(anim.climb and anim.climb.ClimbAnim,TRYHARD_ANIMS.climb)
    s(anim.swim and anim.swim.Swim,       TRYHARD_ANIMS.swim)
    s(anim.swimidle and anim.swimidle.SwimIdle, TRYHARD_ANIMS.swimidle)
end

function M._restoreOriginalAnims(char)
    if not St._tryhardOriginalAnims then return end
    local anim = char and char:FindFirstChild("Animate")
    if not anim then return end
    local o = St._tryhardOriginalAnims
    local function s(obj, id) if obj and id then obj.AnimationId = id end end
    s(anim.idle and anim.idle.Animation1, o.idle1)
    s(anim.idle and anim.idle.Animation2, o.idle2)
    s(anim.walk and anim.walk.WalkAnim,   o.walk)
    s(anim.run and anim.run.RunAnim,      o.run)
    s(anim.jump and anim.jump.JumpAnim,   o.jump)
    s(anim.fall and anim.fall.FallAnim,   o.fall)
    s(anim.climb and anim.climb.ClimbAnim,o.climb)
    s(anim.swim and anim.swim.Swim,       o.swim)
    s(anim.swimidle and anim.swimidle.SwimIdle, o.swimidle)

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        for _,t in ipairs(hum:GetPlayingAnimationTracks()) do
            pcall(function() t:Stop(0) end)
        end
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
end

function M.startTryhardAnim()
    St.tryhardAnimEnabled = true
    St._tryhardRefreshToken = St._tryhardRefreshToken + 1
    local myToken = St._tryhardRefreshToken
    local char = LP.Character
    if char then
        M._saveOriginalAnims(char)
        M._applyTryhardPack(char)
    end
    if St._tryhardHeartbeatConn then St._tryhardHeartbeatConn:Disconnect(); St._tryhardHeartbeatConn=nil end
    task.spawn(function()
        while St.tryhardAnimEnabled and St._tryhardRefreshToken == myToken do
            local c = LP.Character
            if c then pcall(M._applyTryhardPack, c) end
            task.wait(INT.TRYHARD_REFRESH_INTERVAL)
        end
    end)
end

function M.stopTryhardAnim()
    St.tryhardAnimEnabled = false
    St._tryhardRefreshToken = St._tryhardRefreshToken + 1
    if St._tryhardHeartbeatConn then St._tryhardHeartbeatConn:Disconnect(); St._tryhardHeartbeatConn=nil end
    local char = LP.Character
    if char then pcall(M._restoreOriginalAnims, char) end
end

LP.CharacterAdded:Connect(function(char)
    task.wait(0.25)
    if St.tryhardAnimEnabled then
        pcall(function()
            M._saveOriginalAnims(char)
            M._applyTryhardPack(char)
        end)
    end
end)

local MOB_POS_FILE="aspecthub_btnpos.json"

-- ============================================================
-- ANIMATION PACK SYSTEM (integrated from ANIMATION.txt)
-- ============================================================
local ANIM_PACKS = {
	["Adidas Sports"] = {
		WalkAnim = 18537392113, RunAnim = 18537384940, JumpAnim = 18537380791,
		FallAnim = 18537367238, SwimIdle = 18537387180, Swim = 18537389531,
		Animation1 = 18537376492, Animation2 = 18537371272, ClimbAnim = 18537363391,
	},
	["Adidas Community"] = {
		WalkAnim = 122150855457006, RunAnim = 82598234841035, JumpAnim = 75290611992385,
		FallAnim = 98600215928904, SwimIdle = 109346520324160, Swim = 133308483266208,
		Animation1 = 122257458498464, Animation2 = 102357151005774, ClimbAnim = 88763136693023,
	},
	["Adidas Aura"] = {
		WalkAnim = 83842218823011, RunAnim = 118320322718866, JumpAnim = 109996626521204,
		FallAnim = 95603166884636, SwimIdle = 94922130551805, Swim = 134530128383903,
		Animation1 = 110211186840347, Animation2 = 114191137265065, ClimbAnim = 97824616490448,
	},
	["Wicked Popular"] = {
		WalkAnim = 92072849924640, RunAnim = 72301599441680, JumpAnim = 104325245285198,
		FallAnim = 121152442762481, Animation1 = 118832222982049, ClimbAnim = 131326830509784,
		SwimIdle = 113199415118199, Swim = 99384245425157, Animation2 = 76049494037641,
	},
	Elder = {
		WalkAnim = 10921111375, RunAnim = 10921104374, JumpAnim = 10921107367,
		FallAnim = 10921105765, SwimIdle = 10921110146, Swim = 10921108971,
		ClimbAnim = 10921100400, Animation1 = 10921101664, Animation2 = 10921102574,
	},
	Zombie = {
		WalkAnim = 10921355261, RunAnim = 616163682, JumpAnim = 10921351278,
		FallAnim = 10921350320, SwimIdle = 10921353442, Swim = 10921352344,
		Animation1 = 10921344533, Animation2 = 10921345304, ClimbAnim = 10921343576,
	},
	Mage = {
		WalkAnim = 10921152678, RunAnim = 10921148209, JumpAnim = 10921149743,
		FallAnim = 10921148939, SwimIdle = 10921151661, Swim = 10921150788,
		ClimbAnim = 10921143404, Animation1 = 10921144709, Animation2 = 10921145797,
	},
	["Catwalk Glam"] = {
		WalkAnim = 109168724482748, RunAnim = 81024476153754, JumpAnim = 116936326516985,
		FallAnim = 92294537340807, SwimIdle = 98854111361360, Swim = 134591743181628,
		ClimbAnim = 119377220967554, Animation1 = 133806214992291, Animation2 = 94970088341563,
	},
	Astronaut = {
		WalkAnim = 10921046031, RunAnim = 10921039308, JumpAnim = 10921042494,
		FallAnim = 10921040576, SwimIdle = 10921045006, Swim = 10921044000,
		ClimbAnim = 10921032124, Animation1 = 10921034824, Animation2 = 10921036806,
	},
	['Wicked "Dancing Through Life"'] = {
		WalkAnim = 73718308412641, RunAnim = 135515454877967, JumpAnim = 78508480717326,
		FallAnim = 78147885297412, SwimIdle = 129183123083281, Swim = 110657013921774,
		ClimbAnim = 129447497744818, Animation1 = 92849173543269, Animation2 = 132238900951109,
	},
	Werewolf = {
		WalkAnim = 10921342074, RunAnim = 10921336997, JumpAnim = nil,
		FallAnim = 10921337907, SwimIdle = 10921341319, Swim = 10921340419,
		ClimbAnim = 10921329322, Animation1 = 10921330408, Animation2 = 10921333667,
	},
	Superhero = {
		WalkAnim = 10921298616, RunAnim = 10921291831, JumpAnim = 10921294559,
		FallAnim = 10921293373, SwimIdle = 10921297391, Swim = 10921295495,
		ClimbAnim = 10921286911, Animation1 = 10921288909, Animation2 = 10921290167,
	},
	Toy = {
		WalkAnim = 10921312010, RunAnim = 10921306285, JumpAnim = 10921308158,
		FallAnim = 10921307241, SwimIdle = 10921310341, Swim = 10921309319,
		ClimbAnim = 10921300839, Animation1 = 10921301576, Animation2 = nil,
	},
	["No Boundaries"] = {
		WalkAnim = 18747074203, RunAnim = 18747070484, JumpAnim = 18747069148,
		FallAnim = 18747062535, SwimIdle = 18747071682, Swim = 18747073181,
		ClimbAnim = 18747060903, Animation1 = 18747067405, Animation2 = 18747063918,
	},
	NFL = {
		WalkAnim = 110358958299415, RunAnim = 117333533048078, JumpAnim = 119846112151352,
		FallAnim = 129773241321032, SwimIdle = 79090109939093, Swim = 132697394189921,
		ClimbAnim = 134630013742019, Animation1 = 92080889861410, Animation2 = 74451233229259,
	},
	["Amazon Unboxed"] = {
		WalkAnim = 90478085024465, RunAnim = 134824450619865, JumpAnim = 121454505477205,
		FallAnim = 94788218468396, SwimIdle = 129126268464847, Swim = 105962919001086,
		ClimbAnim = 121145883950231, Animation1 = 98281136301627, Animation2 = nil,
	},
	Vampire = {
		WalkAnim = 10921326949, RunAnim = 10921320299, JumpAnim = 10921322186,
		FallAnim = 10921321317, SwimIdle = 10921325443, Swim = 10921324408,
		ClimbAnim = 10921314188, Animation1 = 10921315373, Animation2 = nil,
	},
	["Ninja"] = {
		Run=656118852, Walk=656121766, Jump=656117878, Fall=656115606,
		Swim=656119721, SwimIdle=656121397, Climb=656114359,
		Idle={656117400,656118341,886742569}
	},
	["Robot"] = {
		Run=616091570, Walk=616095330, Jump=616090535, Fall=616087089,
		Swim=616092998, SwimIdle=616094091, Climb=616086039,
		Idle={616088211,616089559,885531463}
	},
	["Levitation"] = {
		Run=616010382, Walk=616013216, Jump=616008936, Fall=616005863,
		Swim=616011509, SwimIdle=616012453, Climb=616003713,
		Idle={616006778,616008087,886862142}
	},
	["Stylish"] = {
		Run=616140816, Walk=616146177, Jump=616139451, Fall=616134815,
		Swim=616143378, SwimIdle=616144772, Climb=616133594,
		Idle={616136790,616138447,886888594}
	},
	["Bubbly"] = {
		Run=910025107, Walk=910034870, Jump=910016857, Fall=910001910,
		Swim=910028158, SwimIdle=910030921, Climb=909997997,
		Idle={910004836,910009958,1018536639}
	},
	["Cartoon"] = {
		Run=742638842, Walk=742640026, Jump=742637942, Fall=742637151,
		Swim=742639220, SwimIdle=742639812, Climb=742636889,
		Idle={742637544,742638445,885477856}
	},
}

local function _animWaitForAnimate(char)
	for _ = 1, 40 do
		local a = char:FindFirstChild("Animate")
		if a and a:FindFirstChild("idle") and a:FindFirstChild("run") and a:FindFirstChild("walk") then
			return a
		end
		task.wait(0.1)
	end
	return nil
end

local function _animSetAnim(animObj, id)
	if animObj and id then
		animObj.AnimationId = "rbxassetid://" .. tostring(id)
	end
end

local function _animStopAllTracks(hum)
	if not hum then return end
	for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
		pcall(function() t:Stop(0) end)
	end
end

local function _animEnsureAnim(folder, name)
	if not folder then return nil end
	local a = folder:FindFirstChild(name)
	if not a then
		a = Instance.new("Animation")
		a.Name = name
		a.Parent = folder
	end
	return a
end

local function _animEnsureIdleSlots(idleFolder, n)
	if not idleFolder then return end
	n = n or 2
	for i=1,n do
		_animEnsureAnim(idleFolder, "Animation" .. i)
	end
end

local function _animPick(pack, ...)
	for i = 1, select("#", ...) do
		local k = select(i, ...)
		local v = pack[k]
		if v ~= nil then return v end
	end
	return nil
end

function M.applyAnimPack(packName)
	if St.animPackApplying then return false end
	St.animPackApplying = true

	local pack = ANIM_PACKS[packName]
	if not pack then
		warn("Unknown anim pack:", packName)
		St.animPackApplying = false
		return false
	end

	local char = LP.Character or LP.CharacterAdded:Wait()
	local animate = _animWaitForAnimate(char)
	if not animate then
		warn("Animate not found")
		St.animPackApplying = false
		return false
	end

	local hum = char:FindFirstChildOfClass("Humanoid")
	_animStopAllTracks(hum)

	local runObj   = _animEnsureAnim(animate:FindFirstChild("run"),   "RunAnim")
	local walkObj  = _animEnsureAnim(animate:FindFirstChild("walk"),  "WalkAnim")
	local jumpObj  = _animEnsureAnim(animate:FindFirstChild("jump"),  "JumpAnim")
	local fallObj  = _animEnsureAnim(animate:FindFirstChild("fall"),  "FallAnim")
	local climbObj = _animEnsureAnim(animate:FindFirstChild("climb"), "ClimbAnim")
	local swimObj  = _animEnsureAnim(animate:FindFirstChild("swim"),     "Swim")
	local swimIdleObj = _animEnsureAnim(animate:FindFirstChild("swimidle"), "SwimIdle")
	local idleFolder = animate:FindFirstChild("idle")

	_animSetAnim(walkObj,  _animPick(pack, "WalkAnim", "Walk"))
	_animSetAnim(runObj,   _animPick(pack, "RunAnim", "Run"))
	_animSetAnim(jumpObj,  _animPick(pack, "JumpAnim", "Jump"))
	_animSetAnim(fallObj,  _animPick(pack, "FallAnim", "Fall"))
	_animSetAnim(climbObj, _animPick(pack, "ClimbAnim", "Climb"))
	_animSetAnim(swimObj,      _animPick(pack, "Swim"))
	_animSetAnim(swimIdleObj,  _animPick(pack, "SwimIdle") or _animPick(pack, "Swim"))

	if idleFolder then
		local a1 = _animPick(pack, "Animation1")
		local a2 = _animPick(pack, "Animation2")

		if a1 or a2 then
			_animEnsureIdleSlots(idleFolder, 2)
			local id1 = a1 or a2
			local id2 = a2 or a1 or id1
			_animSetAnim(idleFolder:FindFirstChild("Animation1"), id1)
			_animSetAnim(idleFolder:FindFirstChild("Animation2"), id2)
		elseif pack.Idle and #pack.Idle > 0 then
			_animEnsureIdleSlots(idleFolder, math.max(2, #pack.Idle))
			_animSetAnim(idleFolder:FindFirstChild("Animation1"), pack.Idle[1])
			_animSetAnim(idleFolder:FindFirstChild("Animation2"), pack.Idle[2] or pack.Idle[1])
			for i = 3, #pack.Idle do
				local a = idleFolder:FindFirstChild("Animation" .. i)
				if a then _animSetAnim(a, pack.Idle[i]) end
			end
		end
	end

	animate.Disabled = true
	task.wait(0.06)
	animate.Disabled = false

	if hum then
		pcall(function()
			hum:ChangeState(Enum.HumanoidStateType.Landed)
			task.wait(0.03)
			hum:ChangeState(Enum.HumanoidStateType.Running)
		end)
	end

	pcall(function() LP:SetAttribute(ANIM_ATTR_LAST, packName) end)

	St.animPackApplying = false
	return true
end

function M.stopAnimPack()
	St.animPackEnabled = false
	pcall(function() LP:SetAttribute(ANIM_ATTR_LAST, "") end)
end

-- Reapply on respawn
LP.CharacterAdded:Connect(function(char)
	task.wait(0.6)
	if St.animPackEnabled then
		local saved = LP:GetAttribute(ANIM_ATTR_LAST)
		if type(saved) == "string" and saved ~= "" and ANIM_PACKS[saved] then
			M.applyAnimPack(saved)
		end
	end
end)

-- Ordering: Adidas packs always top, then alphabetical
local _animAdidasTop = { "Adidas Sports", "Adidas Community", "Adidas Aura" }
local _animAdidasRank = {}
for i, n in ipairs(_animAdidasTop) do _animAdidasRank[n] = i end

local _animAllNames = {}
for name in pairs(ANIM_PACKS) do table.insert(_animAllNames, name) end
table.sort(_animAllNames, function(a, b)
	local ra, rb = _animAdidasRank[a], _animAdidasRank[b]
	if ra and rb then return ra < rb end
	if ra then return true end
	if rb then return false end
	return a:lower() < b:lower()
end)

function M.getAnimPackNameByIndex(idx)
	return _animAllNames[idx] or "Off"
end

function M.getAnimPackIndexByName(name)
	for i, n in ipairs(_animAllNames) do
		if n == name then return i end
	end
	return 1
end

function M.getAnimPackCount()
	return #_animAllNames
end

function M.getAnimPackNames()
	return _animAllNames
end

function M.loadBtnPositions()
    if not(isfile and isfile(MOB_POS_FILE)) then return {} end
    local ok,data=pcall(function() return HS:JSONDecode(readfile(MOB_POS_FILE)) end)
    if ok and type(data)=="table" then return data end; return {}
end
function M.saveBtnPositions()
    if not writefile then return end; if not St.mobGuiRef then return end
    local out={}
    for _,child in ipairs(St.mobGuiRef:GetDescendants()) do
        if child:IsA("Frame") and child:GetAttribute("BtnKey") then
            local key=child:GetAttribute("BtnKey")
            out[key]={xs=child.Position.X.Scale,xo=child.Position.X.Offset,ys=child.Position.Y.Scale,yo=child.Position.Y.Offset}
        end
    end
    pcall(function() writefile(MOB_POS_FILE,HS:JSONEncode(out)) end)
end
function M.resetMobileButtonPositions()
    if writefile then pcall(function() writefile(MOB_POS_FILE,HS:JSONEncode({})) end) end
    if isfile and isfile(MOB_POS_FILE) then pcall(function() writefile(MOB_POS_FILE,"{}") end) end
    if St.mobGuiRef then M.buildMobileButtons() end
end
task.spawn(function() while true do task.wait(INT.BTN_POS_SAVE_INTERVAL);pcall(M.saveBtnPositions) end end)








function M.addShimmerToLabel(lbl,color1,color2)
    local gr=Instance.new("UIGradient",lbl)
    gr.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,color1 or Color3.fromRGB(220,0,0)),ColorSequenceKeypoint.new(0.5,color2 or Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,color1 or Color3.fromRGB(220,0,0))})
    gr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,0.3,0)})
    return gr
end

St.fovConn=nil
function M.applyFOV()
    if St.fovConn then St.fovConn:Disconnect() end
    local function applyCurrentFOV()
        local cam=workspace.CurrentCamera
        if cam and math.abs(cam.FieldOfView-St.fovValue) > 0.01 then
            cam.FieldOfView=St.fovValue
        end
    end
    applyCurrentFOV()
    St.fovConn=RunService.Heartbeat:Connect(function()
        local now=tick()
        if now < St._nextFovApplyAt then return end
        St._nextFovApplyAt = now + INT.FOV_REFRESH_INTERVAL
        applyCurrentFOV()
    end)
end
M.applyFOV()

function M.clearOldRagdollTimerGuis()
    pcall(function()
        local cg=game:GetService("CoreGui")
        for _,name in ipairs({"AspectRagdollTimer_RAGDOLL","AspectRagdollTimer_STONE"}) do
            local old=cg:FindFirstChild(name)
            if old then old:Destroy() end
        end
        local pg=LP:FindFirstChild("PlayerGui")
        if pg then
            for _,name in ipairs({"AspectRagdollTimer_RAGDOLL","AspectRagdollTimer_STONE"}) do
                local old=pg:FindFirstChild(name)
                if old then old:Destroy() end
            end
        end
    end)
end
function M.ensureHeadStatusLabel()
    local char=LP.Character
    if not char then return nil end
    local head=char:FindFirstChild("Head")
    if not head then return nil end
    if not UIRefs.speedBillboard or UIRefs.speedBillboard.Parent~=head or not UIRefs.ragdollStatusLabel or not UIRefs.ragdollStatusLabel.Parent then
        M.setupSpeedIndicator(char)
    end
    return UIRefs.ragdollStatusLabel
end
function M.applyHeadBillboardMode(mode,countdownText)
    local accent=guiAccentColor or Color3.fromRGB(210,35,45)
    local green=Color3.fromRGB(0,255,120)
    if UIRefs.ragdollStatusLabel and UIRefs.ragdollStatusLabel.Parent then
        local isReady=(mode=="ready")
        local isCountdown=(mode=="countdown")
        UIRefs.ragdollStatusLabel.Visible=(isCountdown or isReady)
        UIRefs.ragdollStatusLabel.Text=countdownText or ""
        UIRefs.ragdollStatusLabel.TextColor3=isReady and green or accent
        UIRefs.ragdollStatusLabel.TextSize=isReady and 16 or 18
    end
    UIRefs.headBillboardMode=mode
end
function M.showHeadStealCountdown(duration)
    if not St.ragdollGuiEnabled then return end
    M.clearOldRagdollTimerGuis()
    St.activeHeadCountdownToken=St.activeHeadCountdownToken+1
    local myToken=St.activeHeadCountdownToken
    local lbl=M.ensureHeadStatusLabel()
    if not lbl then return end
    local startTime=tick()
    M.applyHeadBillboardMode("countdown","3")
    task.spawn(function()
        while St.activeHeadCountdownToken==myToken and lbl and lbl.Parent do
            local elapsed=tick()-startTime
            local remaining=duration-elapsed
            if remaining<=0 then break end
            local progress=math.clamp(elapsed/math.max(duration,0.001),0,0.999)
            local step=3-math.floor(progress*3)
            M.applyHeadBillboardMode("countdown",tostring(math.clamp(step,1,3)))
            task.wait(0.05)
        end
        if St.activeHeadCountdownToken~=myToken or not lbl or not lbl.Parent then return end
        M.applyHeadBillboardMode("ready","ready to steal")
        task.wait(1)
        if St.activeHeadCountdownToken~=myToken or not lbl or not lbl.Parent then return end
        M.applyHeadBillboardMode("idle","")
    end)
end
function M.createRagdollBillboard(duration,labelText,color)
    M.showHeadStealCountdown(duration)
    return nil
end
function M.onHumanoidStateChanged(old,new)
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid");if not hum then return end
    local isRag=(new==Enum.HumanoidStateType.Physics or new==Enum.HumanoidStateType.Ragdoll or new==Enum.HumanoidStateType.FallingDown)
    if isRag and not hum.PlatformStand and not UIRefs.activeBatBillboard then
        UIRefs.activeBatBillboard=true
        M.showHeadStealCountdown(2.6)
        task.delay(2.6,function() UIRefs.activeBatBillboard=nil end)
    end
end
function M.onMedusaStateChanged()
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum and hum.PlatformStand and not UIRefs.activeMedusaBillboard then
        UIRefs.activeMedusaBillboard=true
        M.showHeadStealCountdown(4.5)
        task.delay(4.5,function() UIRefs.activeMedusaBillboard=nil end)
    end
end
function M.setupRagdollTriggers()
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum then hum.StateChanged:Connect(M.onHumanoidStateChanged);hum:GetPropertyChangedSignal("PlatformStand"):Connect(M.onMedusaStateChanged) end
end
function M.setupSpeedIndicator(char)
    local head=char:WaitForChild("Head",5);if not head then return end
    if head:FindFirstChild("AspectSpeedBB") then head.AspectSpeedBB:Destroy() end
    local accent=guiAccentColor or Color3.fromRGB(210,35,45)
    local bb=Instance.new("BillboardGui",head)
    UIRefs.speedBillboard=bb
    bb.Name="AspectSpeedBB"
    bb.Size=UDim2.new(0,280,0,70)
    bb.StudsOffset=Vector3.new(0,3.2,0)
    bb.AlwaysOnTop=true

    -- TOP: Countdown / Status
    local statusLabel=Instance.new("TextLabel",bb)
    UIRefs.ragdollStatusLabel=statusLabel
    statusLabel.Size=UDim2.new(1,-8,0,22)
    statusLabel.Position=UDim2.new(0,4,0,2)
    statusLabel.BackgroundTransparency=1
    statusLabel.Text=""
    statusLabel.TextColor3=accent
    statusLabel.Font=Enum.Font.GothamBlack
    statusLabel.TextScaled=false
    statusLabel.TextSize=18
    statusLabel.TextStrokeTransparency=0.5
    statusLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)
    statusLabel.TextXAlignment=Enum.TextXAlignment.Center
    statusLabel.Visible=false

    -- MIDDLE: Speed value with mode
    local speedLabel=Instance.new("TextLabel",bb)
    UIRefs.speedLabel=speedLabel
    speedLabel.Size=UDim2.new(1,-8,0,24)
    speedLabel.Position=UDim2.new(0,4,0,24)
    speedLabel.BackgroundTransparency=1
    speedLabel.Text="Speed: 0.0 | Normal"
    speedLabel.TextColor3=Color3.fromRGB(255,255,255)
    speedLabel.Font=Enum.Font.GothamBlack
    speedLabel.TextScaled=false
    speedLabel.TextSize=18
    speedLabel.TextStrokeTransparency=0.4
    speedLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)
    speedLabel.TextXAlignment=Enum.TextXAlignment.Center
end


-- Aggiorna il label modo sopra la testa (stile Revive)
function St.updateModeDisplay()
    if not UIRefs.modeLabel then return end
    local name
    if St.laggerModeEnabled and St.carrySpeedActive then name="LAGGER CARRY"
    elseif St.laggerModeEnabled then name="LAGGER"
    elseif St.carrySpeedActive then name="CARRY"
    else name="NORMAL" end
    UIRefs.modeLabel.Text=name
end
St.refreshSpeedModeLabel=St.updateModeDisplay

function M.applySafeSpeed(spd)
    return spd
end
function M.getActiveMoveSpeed()
    local spd
    if St.laggerModeEnabled then spd=LAGGER_CARRY_SPEED
    elseif St.carrySpeedActive then spd=CS
    else spd=NS end
    return M.applySafeSpeed(spd)
end
function M.getAutoPathSpeed()
    return M.applySafeSpeed(NS)
end
St._autoSwitchWasSteal=false
function M.updateAutoSwitchSpeed()
    if not St.autoSwitchSpeedEnabled then return end
    if St.laggerModeEnabled then return end
    local char=LP.Character;if not char then return end
    local h=char:FindFirstChildOfClass("Humanoid");if not h then return end
    local isStealSpeed=h.WalkSpeed<25
    if isStealSpeed==St._autoSwitchWasSteal then return end
    St._autoSwitchWasSteal=isStealSpeed
    if isStealSpeed then
        St.carrySpeedActive = true
    else
        St.carrySpeedActive = false
    end
    if St.refreshSpeedModeLabel then St.refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(St.carrySpeedActive) end
end
task.spawn(function() while true do task.wait(0.3);M.updateAutoSwitchSpeed() end end)
function M.manualJumpBoost(boost)
    if not St.infJumpEnabled or St.infJumpMode~="manual" then return end
    local char=LP.Character;if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart");if root then root.Velocity=Vector3.new(root.Velocity.X,boost,root.Velocity.Z) end
end
function M.startHoldInfJump()
    if St.holdInfJumpConn then St.holdInfJumpConn:Disconnect() end
    St.holdInfJumpConn=RunService.Heartbeat:Connect(function()
        if not St.infJumpEnabled or St.infJumpMode~="hold" then return end
        local char=LP.Character;if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart");local hum=char:FindFirstChildOfClass("Humanoid");if not root or not hum then return end
        local isJumpHeld=UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump==true)
        if isJumpHeld and root.Velocity.Y<35 then root.Velocity=Vector3.new(root.Velocity.X,55,root.Velocity.Z) end
        if root.Velocity.Y<-120 then root.Velocity=Vector3.new(root.Velocity.X,-120,root.Velocity.Z) end
    end)
end
function M.stopHoldInfJump() if St.holdInfJumpConn then St.holdInfJumpConn:Disconnect();St.holdInfJumpConn=nil end end
UIS.JumpRequest:Connect(function() M.manualJumpBoost(50) end)
UIS.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Keyboard and input.KeyCode==Enum.KeyCode.Space and not UIS:GetFocusedTextBox() then
        task.delay(0.12,function() if UIS:IsKeyDown(Enum.KeyCode.Space) then M.manualJumpBoost(50) end end)
    end
end)
RunService.Heartbeat:Connect(function()
    if not UIS:IsKeyDown(Enum.KeyCode.Space) then return end
    local now=tick()
    if now < St._manualJumpNextAt then return end
    St._manualJumpNextAt = now + INT.MANUAL_JUMP_INTERVAL
    M.manualJumpBoost(50)
end)
local _antiKickConns={}
function M.refreshAntiKickState()
    if not St.antiKickEnabled then
        St.brainrotDetected=false
        return
    end
    local found=false
    local function scanContainer(container)
        if not container then return end
        for _,tool in ipairs(container:GetChildren()) do
            if tool:IsA("Tool") then
                local n=tool.Name:lower()
                if n:find("brainrot") or n:find("skibidi") or n:find("toilet") then
                    found=true
                    return
                end
            end
        end
    end
    local char=LP.Character
    if char then scanContainer(char) end
    if not found then
        local bp=LP:FindFirstChild("Backpack")
        if bp then scanContainer(bp) end
    end
    St.brainrotDetected=found
    if found then
        if St.autoBatEnabled then St.autoBatEnabled=false;if St.resetAutoBatMotion then St.resetAutoBatMotion() end;if UIRefs.autoBatSetVisual then UIRefs.autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
        if St.autoLeftEnabled then St.autoLeftEnabled=false;St.stopAutoLeft();if UIRefs.autoLeftSetVisual then UIRefs.autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
        if St.autoRightEnabled then St.autoRightEnabled=false;St.stopAutoRight();if UIRefs.autoRightSetVisual then UIRefs.autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
    end
end
St.enableAntiKick=function()
    St.antiKickEnabled=true
    for _,c in ipairs(_antiKickConns) do pcall(function() c:Disconnect() end) end;_antiKickConns={}
    local function hookContainer(container)
        if not container then return end
        table.insert(_antiKickConns,container.ChildAdded:Connect(M.refreshAntiKickState))
        table.insert(_antiKickConns,container.ChildRemoved:Connect(M.refreshAntiKickState))
    end
    local function bindCharacter(char)
        hookContainer(char)
        M.refreshAntiKickState()
    end
    if LP.Character then bindCharacter(LP.Character) end
    local bp=LP:FindFirstChild("Backpack")
    if bp then hookContainer(bp) end
    table.insert(_antiKickConns,LP.CharacterAdded:Connect(bindCharacter))
    table.insert(_antiKickConns,LP.ChildAdded:Connect(function(child) if child.Name=="Backpack" then hookContainer(child);M.refreshAntiKickState() end end))
    M.refreshAntiKickState()
end
St.disableAntiKick=function()
    St.antiKickEnabled=false;St.brainrotDetected=false
    for _,c in ipairs(_antiKickConns) do pcall(function() c:Disconnect() end) end;_antiKickConns={}
end

-- ── BODY LOCK (Blossom) ───────────────────────────────────────────────────────
local function _bodyLockTick()
    local char=LP.Character;if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart");if not root then return end
    local hum=char:FindFirstChildOfClass("Humanoid");if not hum then return end
    local target=M.getClosestTarget()
    if not target then
        if not hum.AutoRotate then hum.AutoRotate=true end
        return
    end
    local dist=(target.Position-root.Position).Magnitude
    if dist>St.bodyLockRange then
        if not hum.AutoRotate then hum.AutoRotate=true end
        return
    end
    if hum.AutoRotate then hum.AutoRotate=false end
    local targetVel=target.AssemblyLinearVelocity
    local speed3=targetVel.Magnitude
    local predictTime=math.clamp(speed3/150,0.05,0.2)
    local predictedPos=target.Position+targetVel*predictTime
    local flatTarget=Vector3.new(predictedPos.X,root.Position.Y,predictedPos.Z)
    local toPredict=flatTarget-root.Position
    if toPredict.Magnitude>0.1 then
        local goalCF=CFrame.lookAt(root.Position,flatTarget)
        local diffCF=root.CFrame:Inverse()*goalCF
        local _,ry,_=diffCF:ToEulerAnglesXYZ()
        ry=math.clamp(ry,-2.5,2.5)
        root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(Vector3.new(0,ry*42,0))
    end
end
St.startBodyLock=function()
    if St._bodyLockConn then St._bodyLockConn:Disconnect() end
    St._bodyLockConn=RunService.RenderStepped:Connect(function()
        if not St.bodyLockEnabled then return end
        _bodyLockTick()
    end)
end
St.stopBodyLock=function()
    if St._bodyLockConn then St._bodyLockConn:Disconnect();St._bodyLockConn=nil end
    local c=LP.Character
    local root=c and c:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyAngularVelocity=Vector3.zero end
    local hum2=c and c:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate=true end
end
-- avvia subito il loop (il toggle interno lo controlla)
St.startBodyLock()
-- ── End Body Lock ─────────────────────────────────────────────────────────────

pcall(function()
    if hookfunction and newcclosure then
        local oldFire
        oldFire=hookfunction(Instance.new("RemoteEvent").FireServer,newcclosure(function(self,...)
            if not cursedResetRemote and typeof(self)=="Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3)=="RE/" then cursedResetRemote=self end
            return oldFire(self,...)
        end))
    end
end)
task.spawn(function()
    task.wait(2);if cursedResetRemote then return end
    for _,desc in ipairs(game:GetDescendants()) do
        if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then cursedResetRemote=desc;break end
    end
end)
St.cursedInstaReset=function()
    if not cursedResetRemote then
        for _,desc in ipairs(game:GetDescendants()) do if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then cursedResetRemote=desc;break end end
    end
    if not cursedResetRemote then
        -- Fallback: nessun remote trovato, forziamo comunque il respawn azzerando la vita
        local character=LP.Character;local humanoid=character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then pcall(function() humanoid.Health=0 end) end
        return
    end
    local character=LP.Character;local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health<=0 then pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID,LP,"balloon") end);return end
    local resetDetected=false;local conns={}
    if humanoid then
        table.insert(conns,humanoid.Died:Connect(function() resetDetected=true end))
        table.insert(conns,humanoid:GetPropertyChangedSignal("Health"):Connect(function() if humanoid.Health<=0 then resetDetected=true end end))
    end
    if character then table.insert(conns,character.AncestryChanged:Connect(function(_,parent) if not parent then resetDetected=true end end)) end
    task.spawn(function()
        for _=1,50 do if resetDetected then break end;pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID,LP,"balloon") end);task.wait() end
        for _,conn in ipairs(conns) do pcall(function() conn:Disconnect() end) end
    end)
end

local KB={DropBrainrot={kb=nil,gp=nil,mouse=nil},AutoLeft={kb=nil,gp=nil,mouse=nil},AutoRight={kb=nil,gp=nil,mouse=nil},AutoBat={kb=nil,gp=nil,mouse=nil},TPFloor={kb=nil,gp=nil,mouse=nil},InstaReset={kb=nil,gp=nil,mouse=nil},GuiHide={kb=nil,gp=nil,mouse=nil},SpeedToggle={kb=nil,gp=nil,mouse=nil},LaggerToggle={kb=nil,gp=nil,mouse=nil},
InfJump={kb=nil,gp=nil,mouse=nil},AutoTP={kb=nil,gp=nil,mouse=nil},AntiRagdoll={kb=nil,gp=nil,mouse=nil},BatCounter={kb=nil,gp=nil,mouse=nil},MedusaCounter={kb=nil,gp=nil,mouse=nil},MedusaReset={kb=nil,gp=nil,mouse=nil},Unwalk={kb=nil,gp=nil,mouse=nil},AutoSwing={kb=nil,gp=nil,mouse=nil},TryhardAnim={kb=nil,gp=nil,mouse=nil},AntiLag={kb=nil,gp=nil,mouse=nil},StretchRez={kb=nil,gp=nil,mouse=nil},RagdollGui={kb=nil,gp=nil,mouse=nil},GuiTransparent={kb=nil,gp=nil,mouse=nil},LockUi={kb=nil,gp=nil,mouse=nil},AutoSwitchSpeed={kb=nil,gp=nil,mouse=nil},TpBat={kb=nil,gp=nil,mouse=nil}}
local AP_L1,AP_L2=Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81)
local AP_R1,AP_R2=Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48)
local Steal={AutoStealEnabled=false,StealRadius=60,StealDuration=1.4,Data={},Method=1,StealRadius2=9,HoldMin2=1.3}
St.isStealing,St.stealStartTime=false,nil
St._activeStealDuration=1.4
local Conns={autoSteal=nil,antiRag=nil,batCounter=nil,anchor={}}
St.MEDUSA_COOLDOWN=25;St.batCounterDebounce=false
St.lastMoveDir=Vector3.new(0,0,0)
local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,[Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}
function M.isRagdollState(hum)
    if not hum then return true end;local st=hum:GetState()
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
end
function M.isMyPlotByName(plotName)
    local plots=workspace:FindFirstChild("Plots");if not plots then return false end
    local plot=plots:FindFirstChild(plotName);if not plot then return false end
    local sign=plot:FindFirstChild("PlotSign")
    if sign then local yb=sign:FindFirstChild("YourBase");if yb and yb:IsA("BillboardGui") then return yb.Enabled==true end end
    return false
end
function M.isNearPodiumWithPrompt()
    local char=LP.Character;local hrpL=char and char:FindFirstChild("HumanoidRootPart");if not hrpL then return false end
    local plots=workspace:FindFirstChild("Plots");if not plots then return false end
    for _,plot in ipairs(plots:GetChildren()) do
        if not M.isMyPlotByName(plot.Name) then
            local podiums=plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _,podium in ipairs(podiums:GetChildren()) do
                    local base=podium:FindFirstChild("Base")
                    if base then
                        local sp=base:FindFirstChild("Spawn")
                        if sp then
                            local d=(hrpL.Position-sp.Position).Magnitude
                            if d<=Steal.StealRadius then
                                local att=sp:FindFirstChild("PromptAttachment")
                                if att then
                                    for _,obj in ipairs(att:GetChildren()) do if obj:IsA("ProximityPrompt") and obj.Enabled then return true,d end end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return false,math.huge
end
function M.findNearestPrompt()
    local char=LP.Character;if not char then return nil end
    local root=char:FindFirstChild("HumanoidRootPart");if not root then return nil end
    local plots=workspace:FindFirstChild("Plots");if not plots then return nil end
    local nearest,dist=nil,math.huge
    for _,plot in ipairs(plots:GetChildren()) do
        if not M.isMyPlotByName(plot.Name) then
            local pods=plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _,pod in ipairs(pods:GetChildren()) do
                    local base=pod:FindFirstChild("Base");local sp=base and base:FindFirstChild("Spawn")
                    if sp then
                        local d=(sp.Position-root.Position).Magnitude
                        if d<=Steal.StealRadius and dist>d then
                            local att=sp:FindFirstChild("PromptAttachment")
                            if att then for _,prompt in ipairs(att:GetChildren()) do if prompt:IsA("ProximityPrompt") and prompt.ActionText:find("Steal") then nearest,dist=prompt,d end end end
                        end
                    end
                end
            end
        end
    end
    return nearest
end
function M.executeSteal(prompt)
    if St.isStealing then return end
    if not Steal.Data[prompt] then
        Steal.Data[prompt]={hold={},trigger={},ready=true}
        if getconnections then
            for _,c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do if c.Function then table.insert(Steal.Data[prompt].hold,c.Function) end end
            for _,c in ipairs(getconnections(prompt.Triggered)) do if c.Function then table.insert(Steal.Data[prompt].trigger,c.Function) end end
        end
    end
    local data=Steal.Data[prompt];if not data.ready then return end
    data.ready=false;St.isStealing=true;St.stealStartTime=tick();St._activeStealDuration=Steal.StealDuration
    task.spawn(function()
        for _,fn in ipairs(data.hold) do task.spawn(fn) end
        task.wait(Steal.StealDuration)
        for _,fn in ipairs(data.trigger) do task.spawn(fn) end
        data.ready=true;St.isStealing=false;St.stealStartTime=nil
    end)
end
do
St.startAutoStealM1=function()
    if Conns.autoSteal then return end
    Conns.autoSteal=RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or St.isStealing then return end
        local now=tick()
        if now < St._nextAutoStealAt then return end
        St._nextAutoStealAt = now + INT.AUTO_STEAL_INTERVAL
        local p=M.findNearestPrompt();if p then M.executeSteal(p) end
    end)
end
St.stopAutoStealM1=function()
    if Conns.autoSteal then Conns.autoSteal:Disconnect();Conns.autoSteal=nil end
    St.isStealing=false;St.stealStartTime=nil
end

-- ===================== AUTO GRAB METODO 2 (sync sui dati animali, default 9 radius / 1.3s) =====================
St.CONFIG2= { ENTRY_DELAY = 0.3, COOLDOWN = 0.05, PRIME_RANGE = 80 }
St.AnimalsData2= {}
St.syncRemotes2= nil
St.plotAnimalSync2= {caches = {}, connections = {}}
St.allAnimalsCache2= {}
St.PromptMemoryCache2= {}
St.InternalStealCache2= {}
St.stealConnection2= nil
St.syncStarted2= false
St.scanLoop2Started= false

St.initAutoGrab2Sync = function()
    local ok = pcall(function()
        local RS = game:GetService("ReplicatedStorage")
        local Packages = RS:WaitForChild("Packages", 10)
        local Datas = RS:WaitForChild("Datas", 10)
        if not Packages or not Datas then return end
        St.AnimalsData2 = require(Datas:WaitForChild("Animals"))
        local folder = Packages:WaitForChild("Synchronizer")
        St.syncRemotes2 = {
            channelFolder = folder:WaitForChild("Channel"),
            routeRemote = folder:WaitForChild("CommunicationRoute"),
            requestData = folder:FindFirstChild("RequestData"),
        }
    end)
    return ok and St.syncRemotes2 ~= nil
end

St.splitSyncPath2 = function(path)
    if typeof(path) == "table" then return path end
    local out = {}
    for part in string.gmatch(tostring(path), "[^%.]+") do
        table.insert(out, tonumber(part) or part)
    end
    return out
end

St.resolveSyncPath2 = function(path, root)
    local current = root
    local parent = nil
    local key = nil
    for _, part in ipairs(St.splitSyncPath2(path)) do
        parent = current
        key = part
        current = current and current[part] or nil
    end
    return current, parent, key
end

St.applyPlotSyncDiff2 = function(channelName, packet)
    local cache = St.plotAnimalSync2.caches[channelName]
    if typeof(cache) ~= "table" then return end
    local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
    local current, parent, key = St.resolveSyncPath2(path, cache)
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

St.attachPlotChannel2 = function(remote)
    local plotsFolder = workspace:FindFirstChild("Plots")
    if not St.syncRemotes2 or St.plotAnimalSync2.connections[remote] or not plotsFolder then return end
    local channelName = tostring(remote.Name)
    if not plotsFolder:FindFirstChild(channelName) then return end
    if St.syncRemotes2.requestData and St.plotAnimalSync2.caches[channelName] == nil then
        local ok, data = pcall(function() return St.syncRemotes2.requestData:InvokeServer(channelName) end)
        St.plotAnimalSync2.caches[channelName] = (ok and typeof(data) == "table") and data or {}
    elseif St.plotAnimalSync2.caches[channelName] == nil then
        St.plotAnimalSync2.caches[channelName] = {}
    end
    St.plotAnimalSync2.connections[remote] = remote.OnClientEvent:Connect(function(queue)
        for _, packet in ipairs(queue) do
            St.applyPlotSyncDiff2(channelName, packet)
        end
    end)
end

St.detachPlotChannel2 = function(channelName)
    for remote, conn in pairs(St.plotAnimalSync2.connections) do
        if tostring(remote.Name) == tostring(channelName) then
            conn:Disconnect()
            St.plotAnimalSync2.connections[remote] = nil
            St.plotAnimalSync2.caches[tostring(channelName)] = nil
            break
        end
    end
end

St.startAutoGrab2Sync = function()
    if St.syncStarted2 then return true end
    if not St.initAutoGrab2Sync() then return false end
    St.syncStarted2 = true
    for _, child in ipairs(St.syncRemotes2.channelFolder:GetChildren()) do
        if child:IsA("RemoteEvent") then St.attachPlotChannel2(child) end
    end
    St.syncRemotes2.channelFolder.ChildAdded:Connect(function(child)
        if child:IsA("RemoteEvent") then St.attachPlotChannel2(child) end
    end)
    St.syncRemotes2.routeRemote.OnClientEvent:Connect(function(actions)
        local plotsFolder = workspace:FindFirstChild("Plots")
        for _, action in ipairs(actions) do
            local kind, channelName = action[1], tostring(action[2])
            if not plotsFolder or not plotsFolder:FindFirstChild(channelName) then continue end
            if kind == "ListenerAdded" then
                local remote = St.syncRemotes2.channelFolder:FindFirstChild(channelName)
                if remote and remote:IsA("RemoteEvent") then St.attachPlotChannel2(remote) end
            elseif kind == "ListenerRemoved" then
                St.detachPlotChannel2(channelName)
            end
        end
    end)
    return true
end

St.getPlotOwner2 = function(plot)
    local sign = plot:FindFirstChild("PlotSign")
    local surfaceGui = sign and sign:FindFirstChild("SurfaceGui")
    local frame = surfaceGui and surfaceGui:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text == "Empty Base" then return nil end
    return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end

St.isMyBaseAnimal2 = function(animalData)
    if not animalData or not animalData.plot then return false end
    local plotsFolder = workspace:FindFirstChild("Plots")
    local plot = plotsFolder and plotsFolder:FindFirstChild(animalData.plot)
    if not plot then return false end
    return St.getPlotOwner2(plot) == LP.DisplayName
end

St.getAnimalPosition2 = function(animalData)
    local plotsFolder = workspace:FindFirstChild("Plots")
    local plot = plotsFolder and plotsFolder:FindFirstChild(animalData.plot)
    if not plot then return nil end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local podium = podiums:FindFirstChild(animalData.slot)
    if not podium then return nil end
    return podium:GetPivot().Position
end

St.findPromptForAnimal2 = function(animalData)
    if not animalData then return nil end
    local cached = St.PromptMemoryCache2[animalData.uid]
    if cached and cached.Parent then return cached end
    local plotsFolder = workspace:FindFirstChild("Plots")
    local plot = plotsFolder and plotsFolder:FindFirstChild(animalData.plot)
    if not plot then return nil end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local podium = podiums:FindFirstChild(animalData.slot)
    if not podium then return nil end
    local base = podium:FindFirstChild("Base")
    if not base then return nil end
    local spawn = base:FindFirstChild("Spawn")
    if not spawn then return nil end
    local attach = spawn:FindFirstChild("PromptAttachment")
    if not attach then return nil end
    for _, p in ipairs(attach:GetChildren()) do
        if p:IsA("ProximityPrompt") then
            St.PromptMemoryCache2[animalData.uid] = p
            return p
        end
    end
    return nil
end

St.distToAnimal2 = function(animalData)
    local character = LP.Character
    if not character then return math.huge end
    local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
    if not hrp then return math.huge end
    local pos = St.getAnimalPosition2(animalData)
    if not pos then return math.huge end
    return (hrp.Position - pos).Magnitude
end

St.pickClosest2 = function()
    local character = LP.Character
    if not character then return nil end
    local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
    if not hrp then return nil end
    local best, bestDist = nil, math.huge
    for _, animalData in ipairs(St.allAnimalsCache2) do
        if St.isMyBaseAnimal2(animalData) then continue end
        local pos = St.getAnimalPosition2(animalData)
        if not pos then continue end
        local dist = (hrp.Position - pos).Magnitude
        if dist > St.CONFIG2.PRIME_RANGE then continue end
        if dist < bestDist then bestDist = dist; best = animalData end
    end
    return best
end

St.buildStealCallbacks2 = function(prompt)
    if St.InternalStealCache2[prompt] then return end
    local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
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
    if (#data.holdCallbacks > 0) or (#data.triggerCallbacks > 0) then
        St.InternalStealCache2[prompt] = data
    end
end

St.executeSteal2Async = function(prompt, animalData)
    local data = St.InternalStealCache2[prompt]
    if not data or not data.ready then return false end
    data.ready = false
    St.isStealing = true
    St.stealStartTime = tick()
    local holdMin = Steal.HoldMin2
    local holdMax = holdMin + 1.3
    St._activeStealDuration = holdMax
    task.spawn(function()
        for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
        task.wait(holdMin)
        local alreadyInRange = St.distToAnimal2(animalData) <= Steal.StealRadius2
        local fired = false
        while true do
            local elapsed = tick() - St.stealStartTime
            if elapsed > holdMax then break end
            if not prompt.Parent then break end
            if St.distToAnimal2(animalData) <= Steal.StealRadius2 then
                if not alreadyInRange then task.wait(St.CONFIG2.ENTRY_DELAY) end
                for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
                fired = true
                break
            end
            task.wait()
        end
        St.isStealing = false
        St.stealStartTime = nil
        task.wait(St.CONFIG2.COOLDOWN)
        data.ready = true
    end)
    return true
end

St.attemptSteal2 = function(prompt, animalData)
    if not prompt or not prompt.Parent then return false end
    St.buildStealCallbacks2(prompt)
    if not St.InternalStealCache2[prompt] then return false end
    return St.executeSteal2Async(prompt, animalData)
end

St.scanAllPlots2 = function()
    local plotsFolder = workspace:FindFirstChild("Plots")
    if not plotsFolder then return 0 end
    local newCache = {}
    for _, plot in ipairs(plotsFolder:GetChildren()) do
        local cache = St.plotAnimalSync2.caches[plot.Name]
        if not cache then continue end
        local animalList = cache.AnimalList
        if typeof(animalList) ~= "table" then continue end
        for slot, animalData in pairs(animalList) do
            if type(animalData) == "table" then
                local animalName = animalData.Index
                local animalInfo = St.AnimalsData2[animalName]
                if not animalInfo then continue end
                table.insert(newCache, {
                    name = animalInfo.DisplayName or animalName,
                    plot = plot.Name,
                    slot = tostring(slot),
                    uid = plot.Name .. "_" .. tostring(slot),
                })
            end
        end
    end
    St.allAnimalsCache2 = newCache
    return #St.allAnimalsCache2
end

St.startAutoStealM2=function()
    if St.stealConnection2 then return end
    if not St.startAutoGrab2Sync() then return end
    if not St.scanLoop2Started then
        St.scanLoop2Started = true
        task.spawn(function()
            St.scanAllPlots2()
            while task.wait(5) do
                St.scanAllPlots2()
            end
        end)
    end
    St.stealConnection2 = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or Steal.Method~=2 or St.isStealing then return end
        local target = St.pickClosest2()
        if not target then return end
        local prompt = St.PromptMemoryCache2[target.uid]
        if not prompt or not prompt.Parent then prompt = St.findPromptForAnimal2(target) end
        if prompt then St.attemptSteal2(prompt, target) end
    end)
end
St.stopAutoStealM2=function()
    if St.stealConnection2 then St.stealConnection2:Disconnect();St.stealConnection2=nil end
    St.isStealing=false;St.stealStartTime=nil
end

St.startAutoSteal=function()
    if Steal.Method==2 then St.startAutoStealM2() else St.startAutoStealM1() end
end
St.stopAutoSteal=function()
    St.stopAutoStealM1();St.stopAutoStealM2()
end
end -- fine blocco locale Metodo 1/2 (evita di sforare il limite di local variabili di Luau)
function M.applyNoCollideToCharacter(char)
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide=false end end
end
function M.clearNoCollidePlayer(plr)
    local bundle=St._noCollidePlayerConns[plr]
    if not bundle then return end
    for _,conn in pairs(bundle) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    St._noCollidePlayerConns[plr]=nil
end
function M.bindNoCollidePlayer(plr)
    if plr==LP then return end
    M.clearNoCollidePlayer(plr)
    local bundle={charConn=nil,descConn=nil}
    local function bindCharacter(char)
        if bundle.descConn then pcall(function() bundle.descConn:Disconnect() end) end
        M.applyNoCollideToCharacter(char)
        bundle.descConn=char.DescendantAdded:Connect(function(part)
            if part:IsA("BasePart") then part.CanCollide=false end
        end)
    end
    if plr.Character then bindCharacter(plr.Character) end
    bundle.charConn=plr.CharacterAdded:Connect(bindCharacter)
    St._noCollidePlayerConns[plr]=bundle
end
for _,plr in ipairs(Players:GetPlayers()) do
    if plr~=LP then M.bindNoCollidePlayer(plr) end
end
Players.PlayerAdded:Connect(function(plr)
    if plr~=LP then M.bindNoCollidePlayer(plr) end
end)
Players.PlayerRemoving:Connect(function(plr)
    M.clearNoCollidePlayer(plr)
end)
RunService.RenderStepped:Connect(function()
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid");local hrp=char:FindFirstChild("HumanoidRootPart");if not hum or not hrp then return end
    if M.isRagdollState(hum) then St.lastMoveDir=Vector3.new(0,0,0);return end
    if not St.autoBatEnabled and not St.autoLeftEnabled and not St.autoRightEnabled then
        local md=hum.MoveDirection;local spd=M.getActiveMoveSpeed()
        if md.Magnitude>0 then
            St.lastMoveDir=md
            hrp.Velocity=Vector3.new(md.X*spd,hrp.Velocity.Y,md.Z*spd)
        elseif St.antiRagdollEnabled and St.lastMoveDir.Magnitude>0 then
            local anyHeld=false;for key in pairs(MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld=true;break end end
            -- also check gamepad thumbstick
            if not anyHeld then
                local gpState=UIS:GetGamepadState(Enum.UserInputType.Gamepad1)
                for _,inputObj in ipairs(gpState) do
                    if inputObj.KeyCode==Enum.KeyCode.Thumbstick1 and inputObj.Position.Magnitude>0.2 then anyHeld=true;break end
                end
            end
            if anyHeld then
                hrp.Velocity=Vector3.new(St.lastMoveDir.X*spd,hrp.Velocity.Y,St.lastMoveDir.Z*spd)
            end
        end
    end
    if UIRefs.speedLabel then
        local now=tick()
        if now >= St._nextSpeedLabelAt then
            St._nextSpeedLabelAt = now + INT.SPEED_LABEL_REFRESH_INTERVAL
            local modeName
        if St.laggerModeEnabled and St.carrySpeedActive then modeName="Lagger Carry"
        elseif St.laggerModeEnabled then modeName="Lagger"
        elseif St.carrySpeedActive then modeName="Carry"
        else modeName="Normal" end
            UIRefs.speedLabel.Text=string.format("Speed: %.1f | %s",Vector3.new(hrp.Velocity.X,0,hrp.Velocity.Z).Magnitude,modeName)
        end
    end
end)
LP.CharacterAdded:Connect(function(char)
    task.wait(0.5);M.setupSpeedIndicator(char);M.setupRagdollTriggers()
    if St.medusaCounterEnabled then St.setupMedusa(char) end
    if St.batCounterEnabled then St.startBatCounter() end
    if St.unwalkEnabled then task.wait(0.5);St.startUnwalk() end
end)
if LP.Character then M.setupSpeedIndicator(LP.Character);M.setupRagdollTriggers() end
St.alConn,St.arConn=nil,nil;St.alPhase,St.arPhase=1,1
St.stopAutoLeft=function()
    if St.alConn then St.alConn:Disconnect();St.alConn=nil end;St.alPhase=1
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
    if UIRefs.autoLeftSetVisual then UIRefs.autoLeftSetVisual(false) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
end
St.stopAutoRight=function()
    if St.arConn then St.arConn:Disconnect();St.arConn=nil end;St.arPhase=1
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
    if UIRefs.autoRightSetVisual then UIRefs.autoRightSetVisual(false) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
end
St.startAutoLeft=function()
    if St.alConn then St.alConn:Disconnect() end;St.alPhase=1
    St.alConn=RunService.Heartbeat:Connect(function()
        if not St.autoLeftEnabled then return end
        local char=LP.Character;if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart");local hum=char:FindFirstChildOfClass("Humanoid");if not hrp or not hum then return end
        if M.isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
        local spd=M.getAutoPathSpeed()
        if St.alPhase==1 then
            local tgt=Vector3.new(AP_L1.X,hrp.Position.Y,AP_L1.Z)
            if (tgt-hrp.Position).Magnitude<1 then St.alPhase=2;local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd);hrp.Velocity=hrp.AssemblyLinearVelocity;return end
            local d=AP_L1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd);hrp.Velocity=hrp.AssemblyLinearVelocity
        elseif St.alPhase==2 then
            local tgt=Vector3.new(AP_L2.X,hrp.Position.Y,AP_L2.Z)
            if (tgt-hrp.Position).Magnitude<1 then hum:Move(Vector3.zero,false);hrp.AssemblyLinearVelocity=Vector3.zero;hrp.Velocity=Vector3.zero;St.autoLeftEnabled=false;if St.alConn then St.alConn:Disconnect();St.alConn=nil end;St.alPhase=1;if UIRefs.autoLeftSetVisual then UIRefs.autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end;return end
            local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd);hrp.Velocity=hrp.AssemblyLinearVelocity
        end
        if St.autoMoveSwingEnabled and not St._alSwingDebounce then
            St._alSwingDebounce=true
            local bat=M.findBat()
            if bat then
                if bat.Parent~=char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(St.autoMoveSwingInterval,function() St._alSwingDebounce=false end)
        end
    end)
end
St.startAutoRight=function()
    if St.arConn then St.arConn:Disconnect() end;St.arPhase=1
    St.arConn=RunService.Heartbeat:Connect(function()
        if not St.autoRightEnabled then return end
        local char=LP.Character;if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart");local hum=char:FindFirstChildOfClass("Humanoid");if not hrp or not hum then return end
        if M.isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
        local spd=M.getAutoPathSpeed()
        if St.arPhase==1 then
            local tgt=Vector3.new(AP_R1.X,hrp.Position.Y,AP_R1.Z)
            if (tgt-hrp.Position).Magnitude<1 then St.arPhase=2;local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd);hrp.Velocity=hrp.AssemblyLinearVelocity;return end
            local d=AP_R1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd);hrp.Velocity=hrp.AssemblyLinearVelocity
        elseif St.arPhase==2 then
            local tgt=Vector3.new(AP_R2.X,hrp.Position.Y,AP_R2.Z)
            if (tgt-hrp.Position).Magnitude<1 then hum:Move(Vector3.zero,false);hrp.AssemblyLinearVelocity=Vector3.zero;hrp.Velocity=Vector3.zero;St.autoRightEnabled=false;if St.arConn then St.arConn:Disconnect();St.arConn=nil end;St.arPhase=1;if UIRefs.autoRightSetVisual then UIRefs.autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end;return end
            local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd);hrp.Velocity=hrp.AssemblyLinearVelocity
        end
        if St.autoMoveSwingEnabled and not St._arSwingDebounce then
            St._arSwingDebounce=true
            local bat=M.findBat()
            if bat then
                if bat.Parent~=char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(St.autoMoveSwingInterval,function() St._arSwingDebounce=false end)
        end
    end)
end
function M.runStandDrop()
    if St.dropActive then return end
    St.dropActive = true
    local flingThread = coroutine.create(function()
        while St.dropActive do
            RunService.Heartbeat:Wait()
            local c = LP.Character
            local root = c and c:FindFirstChild("HumanoidRootPart")
            if not root then break end
            local vel = root.AssemblyLinearVelocity
            root.AssemblyLinearVelocity = vel * 10000 + Vector3.new(0, 10000, 0)
            root.Velocity = root.AssemblyLinearVelocity
            RunService.RenderStepped:Wait()
            if root and root.Parent then
                root.AssemblyLinearVelocity = vel
                root.Velocity = vel
            end
            RunService.Stepped:Wait()
            if root and root.Parent then
                local finalVel = vel + Vector3.new(0, 0.1, 0)
                root.AssemblyLinearVelocity = finalVel
                root.Velocity = finalVel
            end
        end
    end)
    table.insert(_wfConns, flingThread)
    coroutine.resume(flingThread)
    task.delay(0.1,function()
        St.dropActive = false
        for _, c in ipairs(_wfConns) do
            if type(c) == "thread" then
                pcall(coroutine.close, c)
            end
        end
        _wfConns = {}
    end)
end
function M.runJumpDrop()
    if St.dropActive then return end
    local char=LP.Character;if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart");if not root then return end
    St.dropActive=true;local t0=tick();local dc
    dc=RunService.Heartbeat:Connect(function()
        local r=char and char:FindFirstChild("HumanoidRootPart")
        if not r then dc:Disconnect();St.dropActive=false;return end
        if tick()-t0>=DROP_ASCEND_DURATION then
            dc:Disconnect()
            local rp=RaycastParams.new();rp.FilterDescendantsInstances={char};rp.FilterType=Enum.RaycastFilterType.Exclude
            local rr=workspace:Raycast(r.Position,Vector3.new(0,-2000,0),rp)
            if rr then local hum2=char:FindFirstChildOfClass("Humanoid");local off=(hum2 and hum2.HipHeight or 2)+(r.Size.Y/2);r.CFrame=CFrame.new(r.Position.X,rr.Position.Y+off,r.Position.Z);r.AssemblyLinearVelocity=Vector3.new(0,0,0);r.Velocity=Vector3.new(0,0,0) end
            St.dropActive=false;return end
        r.AssemblyLinearVelocity=Vector3.new(r.AssemblyLinearVelocity.X,DROP_ASCEND_SPEED,r.AssemblyLinearVelocity.Z)
        r.Velocity=r.AssemblyLinearVelocity
    end)
end
St.runDrop=function()
    if St.currentDropType==DROP_TYPES.STAND then
        M.runStandDrop()
    else
        M.runJumpDrop()
    end
end
LP.CharacterRemoving:Connect(function()
    St.dropActive=false
    for _, c in ipairs(_wfConns) do
        if type(c)=="thread" then pcall(coroutine.close,c) end
    end
    _wfConns={}
end)
function M.doAutoTPDown(force)
    local char=LP.Character;if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end
    local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
    if not force then
        if hum2.FloorMaterial~=Enum.Material.Air then return end
        if hrp.Position.Y < St.autoTPHeight then return end
    end
    hrp.CFrame=CFrame.new(hrp.Position.X,-7,hrp.Position.Z)*CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0)
    hrp.AssemblyLinearVelocity=Vector3.zero
end
St.startAutoTP=function()
    if St.autoTPConn then task.cancel(St.autoTPConn);St.autoTPConn=nil end
    St.autoTPConn=task.spawn(function() while St.autoTPEnabled do task.wait(0.1);pcall(function() M.doAutoTPDown(false) end) end end)
end
St.stopAutoTP=function() St.autoTPEnabled=false;if St.autoTPConn then task.cancel(St.autoTPConn);St.autoTPConn=nil end end
St.runTPFloor=function() pcall(function() M.doAutoTPDown(true) end) end
local STRETCH_NAME="Aspect_Stretch"
St.enableStretchRez=function()
    St.stretchRezEnabled=true;if St.stretchRezConn then St.stretchRezConn:Disconnect() end
    pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end)
    pcall(function() RunService:BindToRenderStep(STRETCH_NAME,Enum.RenderPriority.Last.Value-1,function() local cam=workspace.CurrentCamera;if cam then cam.CFrame=cam.CFrame*CFrame.new(0,0,0,1,0,0,0,0.8,0,0,0,1) end end) end)
end
St.disableStretchRez=function() St.stretchRezEnabled=false;pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end) end

function M.applyAntiLagDerender(obj)
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy()
        elseif obj:IsA("BasePart") then obj.Material=Enum.Material.Plastic;obj.Reflectance=0;obj.CastShadow=false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency=1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled=false end
    end)
end
St.enableAntiLag=function()
    St.removeAccessoriesEnabled=true;St.antiLagEnabled=true
    St.defLightBrightness=St.defLightBrightness or Lighting.Brightness;St.defLightClock=St.defLightClock or Lighting.ClockTime;St.defLightAmbient=St.defLightAmbient or Lighting.OutdoorAmbient
    Lighting.GlobalShadows=false;Lighting.FogEnd=1e10;Lighting.Brightness=1;Lighting.EnvironmentDiffuseScale=0;Lighting.EnvironmentSpecularScale=0
    for _,e in pairs(Lighting:GetChildren()) do pcall(function() if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled=false end end) end
    for _,obj in ipairs(workspace:GetDescendants()) do M.applyAntiLagDerender(obj) end
    if St.antiLagDescConn then St.antiLagDescConn:Disconnect() end
    St.antiLagDescConn=workspace.DescendantAdded:Connect(function(obj) if St.removeAccessoriesEnabled then M.applyAntiLagDerender(obj) end end)
end
St.disableAntiLag=function()
    St.removeAccessoriesEnabled=false;St.antiLagEnabled=false;if St.antiLagDescConn then St.antiLagDescConn:Disconnect();St.antiLagDescConn=nil end
    pcall(function() if St.defLightBrightness then Lighting.Brightness=St.defLightBrightness end;if St.defLightClock then Lighting.ClockTime=St.defLightClock end;if St.defLightAmbient then Lighting.OutdoorAmbient=St.defLightAmbient end;Lighting.ExposureCompensation=0 end)
end
function M.findMedusa()
    local c=LP.Character;if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=LP:FindFirstChild("Backpack");if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end
function M.useMedusaCounter()
    if St.medusaDebounce then return end;if St.MEDUSA_COOLDOWN>(tick()-St.medusaLastUsed) then return end
    local c=LP.Character;if not c then return end;St.medusaDebounce=true
    local med=M.findMedusa();if not med then St.medusaDebounce=false;return end
    if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid");if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end);St.medusaLastUsed=tick();St.medusaDebounce=false
end
function M.onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency==1 then
            if St.medusaResetEnabled then
                St.cursedInstaReset()
            elseif St.medusaCounterEnabled then
                M.useMedusaCounter()
            end
        end
    end)
end
St.setupMedusa=function(char)
    for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor,M.onAnchorChanged(part)) end end
    table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor,M.onAnchorChanged(part)) end end))
end
St.stopMedusaCounter=function() for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={} end
local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
function M.findBatForCounter()
    local c=LP.Character;if not c then return nil end;local bp=LP:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name));if t then return t end end
    for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end
function M.swingBatForCounter(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end;task.wait(0.05) end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then pcall(function() remote:FireServer() end);task.wait(0.15);pcall(function() remote:FireServer() end)
    else pcall(function() bat:Activate() end);task.wait(0.15);pcall(function() bat:Activate() end) end
end
St.startBatCounter=function()
    if Conns.batCounter then return end
    Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not St.batCounterEnabled or St.batCounterDebounce then return end
        local now=tick()
        if now < St._nextBatCounterAt then return end
        St._nextBatCounterAt = now + INT.BAT_COUNTER_INTERVAL
        local char=LP.Character;if not char then return end;local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            St.batCounterDebounce=true;task.spawn(function() local bat=M.findBatForCounter();if bat then M.swingBatForCounter(bat,char) end;task.wait(0.5);St.batCounterDebounce=false end)
        end
    end)
end
St.stopBatCounter=function() if Conns.batCounter then Conns.batCounter:Disconnect();Conns.batCounter=nil end;St.batCounterDebounce=false end
St.aimbotConn=nil
function M.findBat()
    local char=LP.Character;if not char then return nil end
    for _,tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end
    local bp=LP:FindFirstChild("Backpack");if bp then for _,tool in ipairs(bp:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end end
    return nil
end
function M.getClosestTarget()
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart");if not root then return nil end
    local closest,minDist=nil,math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local tRoot=plr.Character:FindFirstChild("HumanoidRootPart");local hum=plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health>0 then local dist=(tRoot.Position-root.Position).Magnitude;if dist<minDist then minDist=dist;closest=tRoot end end
        end
    end
    return closest
end
function M.swingCurrentBat()
    if not St.autoSwingEnabled then return end;local bat=M.findBat()
    if bat and bat.Parent==LP.Character and bat:IsA("Tool") then pcall(function() bat:Activate() end) end
end
St.startBatAimbot=function()
    if St.aimbotConn then St.aimbotConn:Disconnect() end
    St.autoBatEnabled=true
    St._cachedAimbotTarget=nil
    St._nextAimbotTargetAt=0
    St._nextAimbotEquipAt=0
    if St.autoLeftEnabled then St.autoLeftEnabled=false;if UIRefs.autoLeftSetVisual then UIRefs.autoLeftSetVisual(false) end;St.stopAutoLeft() end
    if St.autoRightEnabled then St.autoRightEnabled=false;if UIRefs.autoRightSetVisual then UIRefs.autoRightSetVisual(false) end;St.stopAutoRight() end
    -- Auto-disabilita body lock durante l'aimbot (Blossom)
    if St.bodyLockEnabled then
        St._bodyLockSuppressed=true;St.bodyLockEnabled=false;St.stopBodyLock()
        if UIRefs.bodyLockSetVisual then UIRefs.bodyLockSetVisual(false) end
    end

    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate=false end

    St.aimbotConn=RunService.RenderStepped:Connect(function()
        if not St.autoBatEnabled then return end
        local char=LP.Character;if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart");if not root then return end
        local hum=char:FindFirstChildOfClass("Humanoid");if not hum then return end

        local now=tick()
        if now >= St._nextAimbotEquipAt then
            St._nextAimbotEquipAt = now + INT.AIMBOT_EQUIP_INTERVAL
            if not char:FindFirstChildOfClass("Tool") then
                local bat=M.findBat()
                if bat then pcall(function() hum:EquipTool(bat) end) end
            end
        end

        if now >= St._nextAimbotTargetAt or not St._cachedAimbotTarget or not St._cachedAimbotTarget.Parent then
            St._nextAimbotTargetAt = now + INT.AIMBOT_TARGET_REFRESH_INTERVAL
            St._cachedAimbotTarget=M.getClosestTarget()
        end
        local target=St._cachedAimbotTarget
        if not target then return end

        if St.batAimbotMode=="Bypass" then
            -- Modalità BYPASS (Vision Hub): sethiddenproperty + CFrame teleport
            if sethiddenproperty then
                pcall(function() sethiddenproperty(root,"PhysicsRepRootPart",target) end)
            end
            local targetPos = target.Position + Vector3.new(0,0.9,0)
            if (root.Position - targetPos).Magnitude > 8 then
                root.CFrame = CFrame.new(targetPos)
            end
            local cam = workspace.CurrentCamera
            cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position)
            M.swingCurrentBat()
            return
        end

        local targetVel=target.AssemblyLinearVelocity
        local myPos=root.Position
        local targetPos=target.Position

        local predictPos
        if _G._batPredEnabled then
            predictPos = targetPos + (targetVel * math.clamp(targetVel.Magnitude/130, 0.05, 0.15))
        else
            predictPos = targetPos + targetVel * 0.14
            predictPos = predictPos + target.CFrame.LookVector * 0.3
        end

        local direction = predictPos - myPos
        if direction.Magnitude < 0.01 then return end
        local flatDir = Vector3.new(direction.X,0,direction.Z)
        if flatDir.Magnitude < 0.01 then return end
        flatDir = flatDir.Unit

        local chaseSpeed = St.normalBatSpeed or 58
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then
            yVel = math.max(yVel, 13)
        end
        yVel = math.clamp(yVel, -70, 110)

        local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)

        local speed3 = targetVel.Magnitude
        local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, predictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
        end

        M.swingCurrentBat()
    end)
    if UIRefs.autoBatSetVisual then UIRefs.autoBatSetVisual(true) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
end
St.stopBatAimbot=function()
    if St.aimbotConn then St.aimbotConn:Disconnect();St.aimbotConn=nil end;St.autoBatEnabled=false
    St._cachedAimbotTarget=nil
    St._nextAimbotTargetAt=0
    St._nextAimbotEquipAt=0
    local char=LP.Character;local root=char and char:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero end
    local hum2=char and char:FindFirstChildOfClass("Humanoid");if hum2 then hum2.AutoRotate=true end
    if St.autoTPEnabled then St.startAutoTP() end
    -- Ripristina body lock se era stato soppresso (Blossom)
    if St._bodyLockSuppressed then
        St._bodyLockSuppressed=false;St.bodyLockEnabled=true;St.startBodyLock()
        if UIRefs.bodyLockSetVisual then UIRefs.bodyLockSetVisual(true) end
    end
    if UIRefs.autoBatSetVisual then UIRefs.autoBatSetVisual(false) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
end
St.queueAutoBatStart=function()
    if St.antiKickEnabled and St.brainrotDetected then return end
    if St.autoLeftEnabled then St.autoLeftEnabled=false;if UIRefs.autoLeftSetVisual then UIRefs.autoLeftSetVisual(false) end;St.stopAutoLeft() end
    if St.autoRightEnabled then St.autoRightEnabled=false;if UIRefs.autoRightSetVisual then UIRefs.autoRightSetVisual(false) end;St.stopAutoRight() end
    St.startBatAimbot()
end
function _G._startTpBat()
    if _G._tpBatConn then _G._tpBatConn:Disconnect();_G._tpBatConn=nil end
    _G._tpBatEnabled=true
    St._cachedTpBatTarget=nil
    St._nextTpBatTargetAt=0
    _G._tpBatConn=RunService.Heartbeat:Connect(function()
        if not _G._tpBatEnabled then return end
        local char=LP.Character;if not char then return end
        local myHrp=char:FindFirstChild("HumanoidRootPart");if not myHrp then return end
        local now=tick()
        if now >= St._nextTpBatTargetAt or not St._cachedTpBatTarget or not St._cachedTpBatTarget.Parent then
            St._nextTpBatTargetAt = now + INT.TPBAT_TARGET_REFRESH_INTERVAL
            local cp,cd=nil,math.huge
            for _,p in pairs(Players:GetPlayers()) do
                if p~=LP and p.Character then
                    local tr=p.Character:FindFirstChild("HumanoidRootPart")
                    local hm=p.Character:FindFirstChildOfClass("Humanoid")
                    if tr and hm and hm.Health>0 then
                        local d=(myHrp.Position-tr.Position).Magnitude
                        if d<cd then cd=d;cp=tr end
                    end
                end
            end
            St._cachedTpBatTarget=cp
        end
        local cp=St._cachedTpBatTarget
        if not cp then return end
        if (myHrp.Position-(cp.Position+Vector3.new(0,0.9,0))).Magnitude>8 then
            myHrp.CFrame=CFrame.new(cp.Position+Vector3.new(0,0.9,0))
        end
        if sethiddenproperty then pcall(function() sethiddenproperty(myHrp,"PhysicsRepRootPart",cp) end) end
        local cam=workspace.CurrentCamera
        if cam then cam.CFrame=CFrame.new(cam.CFrame.Position,cp.Position) end
        if not _G._tpBatCooldown then
            _G._tpBatCooldown=true
            pcall(function()
                local bat=nil
                local ch=LP.Character
                if ch then
                    for _,t in ipairs(ch:GetChildren()) do
                        if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap")) then bat=t;break end
                    end
                    if not bat then
                        local bp=LP:FindFirstChild("Backpack")
                        if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap")) then t.Parent=ch;bat=t;break end end end
                    end
                    if bat then
                        bat:Activate()
                        local ev=bat:FindFirstChildWhichIsA("RemoteEvent")
                        if ev then ev:FireServer() end
                    end
                end
            end)
            task.delay(0.08,function() _G._tpBatCooldown=false end)
        end
    end)
end
function _G._stopTpBat()
    if _G._tpBatConn then _G._tpBatConn:Disconnect();_G._tpBatConn=nil end
    St._cachedTpBatTarget=nil
    St._nextTpBatTargetAt=0
    _G._tpBatEnabled=false
    if mobBtnRefs and mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
end
St.resetAutoBatMotion=function()
    local char=LP.Character;local hrp=char and char:FindFirstChild("HumanoidRootPart");local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hrp then hrp.AssemblyLinearVelocity=hrp.AssemblyLinearVelocity*0.3;hrp.AssemblyAngularVelocity=Vector3.zero end
    if hum then hum.AutoRotate=true end
end
-- GUI_LAYOUT deve essere dichiarato QUI (prima di saveConfig) affinché
-- saveConfig lo catturi come upvalue. buildGui, cycleGuiLayout e loadConfigKeys
-- (tutti definiti dopo questa riga) lo condividono correttamente.
local GUI_LAYOUT = 2   -- MANUXS HUB: fixed to the second GUI layout

St.saveConfig=function()
    local function ks(e)
        if e.kb or e.gp or e.mouse then
            return {
                kb=e.kb and e.kb.Name or nil,
                gp=e.gp and e.gp.Name or nil,
                mouse=e.mouse and e.mouse.Name or nil
            }
        end
        return {kb=nil,gp=nil,mouse=nil}
    end
    local cfg={
        normalSpeed=NS,carrySpeed=CS,
        dropBrainrotKey=ks(KB.DropBrainrot),autoLeftKey=ks(KB.AutoLeft),autoRightKey=ks(KB.AutoRight),autoBatKey=ks(KB.AutoBat),
        laggerToggleKey=ks(KB.LaggerToggle),tpFloorKey=ks(KB.TPFloor),instaResetKey=ks(KB.InstaReset),guiHideKey=ks(KB.GuiHide),speedToggleKey=ks(KB.SpeedToggle),
        infJumpKey=ks(KB.InfJump),autoTPKey=ks(KB.AutoTP),antiRagdollKey=ks(KB.AntiRagdoll),batCounterKey=ks(KB.BatCounter),
        medusaCounterKey=ks(KB.MedusaCounter),medusaResetKey=ks(KB.MedusaReset),unwalkKey=ks(KB.Unwalk),autoSwingKey=ks(KB.AutoSwing),tryhardAnimKey=ks(KB.TryhardAnim),
        antiLagKey=ks(KB.AntiLag),stretchRezKey=ks(KB.StretchRez),ragdollGuiKey=ks(KB.RagdollGui),guiTransparentKey=ks(KB.GuiTransparent),lockUiKey=ks(KB.LockUi),
        autoSwitchSpeedKey=ks(KB.AutoSwitchSpeed),tpBatKey=ks(KB.TpBat),tpBatEnabled=_G._tpBatEnabled,
        grabRadius=Steal.StealRadius,stealDuration=Steal.StealDuration,
        grabMethod=Steal.Method,grabRadius2=Steal.StealRadius2,holdMin2=Steal.HoldMin2,
        antiRagdoll=St.antiRagdollEnabled,autoStealEnabled=Steal.AutoStealEnabled,infiniteJump=St.infJumpEnabled,infJumpMode=St.infJumpMode,
        medusaCounter=St.medusaCounterEnabled,batCounter=St.batCounterEnabled,
        espEnabled=FX.espEnabled,fpsBoostEnabled=FX.fpsBoostEnabled,
        carrySpeedActive=St.carrySpeedActive,laggerModeEnabled=St.laggerModeEnabled,laggerSpeed=LAGGER_SPEED,laggerCarrySpeed=LAGGER_CARRY_SPEED,
        autoBat=St.autoBatEnabled,autoSwing=St.autoSwingEnabled,unwalkEnabled=St.unwalkEnabled,
        batAimbotMode=St.batAimbotMode,normalBatSpeed=St.normalBatSpeed,bypassBatSpeed=St.bypassBatSpeed,bypassLaggerBatSpeed=St.bypassLaggerBatSpeed,
        antiLag=St.antiLagEnabled,stretchRez=St.stretchRezEnabled,
        autoTPEnabled=St.autoTPEnabled,autoTPHeight=St.autoTPHeight,
        guiTransparencyEnabled=St.guiTransparencyEnabled,
        backgroundEnabled=St.guiBackgroundEnabled,
        backgroundIndex=St.guiBackgroundIndex,
        backgroundColored=St.guiBackgroundColored,
        mobileButtonsEnabled=St.mobileButtonsEnabled,mobileButtonsLocked=St.mobileButtonsLocked,mobileButtonsSize=St.mobileButtonsSize,
        circleButtonsEnabled=St.circleButtonsEnabled,
        autoSwitchSpeed=St.autoSwitchSpeedEnabled,
        dropType=St.currentDropType,
        uiScalePercent=St.uiScalePercent,
        fovValue=St.fovValue,
        perButtonDrag=St.perButtonDragEnabled,
        skyTheme=currentSkyTheme,
        medusaReset=St.medusaResetEnabled,
        autoMoveSwing=St.autoMoveSwingEnabled,autoMoveSwingInterval=St.autoMoveSwingInterval,
        ragdollGui=St.ragdollGuiEnabled,
        introSoundEnabled=introSoundEnabled,
        tryhardAnim=St.tryhardAnimEnabled,
        animPackEnabled=St.animPackEnabled,
        animPackIndex=St.animPackIndex,
        guiAccent={r=math.floor(guiAccentColor.R*255+0.5),g=math.floor(guiAccentColor.G*255+0.5),b=math.floor(guiAccentColor.B*255+0.5)},
        guiLayout=2,
        uiLocked=St.uiLocked,
        bodyLockEnabled=St.bodyLockEnabled,bodyLockRange=St.bodyLockRange,
    }
    if writefile then pcall(function() writefile("aspecthub.json",HS:JSONEncode(cfg)) end) end
end
task.spawn(function() while task.wait(5) do if St.configLoaded then St.saveConfig() end end end)
function M.resetAllSettings()
    NS=60;CS=30;LAGGER_SPEED=15;LAGGER_CARRY_SPEED=24.5;St.carrySpeedActive=false;St.laggerModeEnabled=false
    St.autoSwitchSpeedEnabled=false;St.antiRagdollEnabled=false;St.infJumpEnabled=false;St.infJumpMode="manual"
    St.medusaCounterEnabled=false;St.batCounterEnabled=false;St.unwalkEnabled=false;St.medusaResetEnabled=false
    FX.espEnabled=false;FX.fpsBoostEnabled=false;pcall(M.stopESPLoop);pcall(M.stopFPSBoost)
    St.autoLeftEnabled=false;St.autoRightEnabled=false;St.autoBatEnabled=false;St.autoSwingEnabled=true;St.autoMoveSwingEnabled=false
    St.autoTPEnabled=false;St.autoTPHeight=20;St.antiLagEnabled=false;St.stretchRezEnabled=false
    Steal.AutoStealEnabled=false;Steal.StealRadius=60;Steal.StealDuration=1.4
    Steal.Method=1;Steal.StealRadius2=9;Steal.HoldMin2=1.3
    St.guiTransparencyEnabled=false
    St.guiBackgroundEnabled=false
    St.guiBackgroundIndex=0
    St.guiBackgroundColored=false
    guiAccentColor = Color3.fromRGB(210, 35, 45)
    -- Script totalmente per PC: i pulsanti mobile restano sempre disattivati
    St.mobileButtonsEnabled = false
    St.mobileButtonsSize=80
    St.circleButtonsEnabled=false;St.antiKickEnabled=false;St.uiLocked=false;St.fovValue=80;St.fovIndex=1
    St.currentDropType=DROP_TYPES.STAND
    St.uiScalePercent=90
    introSoundEnabled=true
    St.tryhardAnimEnabled=false
    pcall(M.stopTryhardAnim)
    St.animPackEnabled=false
    St.animPackIndex=1
    pcall(M.stopAnimPack)
    KB.DropBrainrot={kb=nil,gp=nil,mouse=nil};KB.AutoLeft={kb=nil,gp=nil,mouse=nil};KB.AutoRight={kb=nil,gp=nil,mouse=nil}
    KB.AutoBat={kb=nil,gp=nil,mouse=nil};KB.TPFloor={kb=nil,gp=nil,mouse=nil};KB.InstaReset={kb=nil,gp=nil,mouse=nil}
    KB.GuiHide={kb=nil,gp=nil,mouse=nil};KB.SpeedToggle={kb=nil,gp=nil,mouse=nil};KB.LaggerToggle={kb=nil,gp=nil,mouse=nil}
    KB.InfJump={kb=nil,gp=nil,mouse=nil};KB.AutoTP={kb=nil,gp=nil,mouse=nil};KB.AntiRagdoll={kb=nil,gp=nil,mouse=nil};KB.BatCounter={kb=nil,gp=nil,mouse=nil}
    KB.MedusaCounter={kb=nil,gp=nil,mouse=nil};KB.MedusaReset={kb=nil,gp=nil,mouse=nil};KB.Unwalk={kb=nil,gp=nil,mouse=nil}
    KB.AutoSwing={kb=nil,gp=nil,mouse=nil};KB.TryhardAnim={kb=nil,gp=nil,mouse=nil};KB.AntiLag={kb=nil,gp=nil,mouse=nil};KB.StretchRez={kb=nil,gp=nil,mouse=nil}
    KB.RagdollGui={kb=nil,gp=nil,mouse=nil};KB.GuiTransparent={kb=nil,gp=nil,mouse=nil};KB.LockUi={kb=nil,gp=nil,mouse=nil};KB.AutoSwitchSpeed={kb=nil,gp=nil,mouse=nil};KB.TpBat={kb=nil,gp=nil,mouse=nil}
    if St.refreshSpeedModeLabel then St.refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(St.carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(St.laggerModeEnabled) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
    if _G._tpBatEnabled then _G._stopTpBat() end
    if UIRefs.refreshGrabMethodButtons then UIRefs.refreshGrabMethodButtons() end
    if St.radInput then St.radInput.Text=tostring(Steal.StealRadius) end;if St.durationBox then St.durationBox.Text=tostring(Steal.StealDuration) end
    St.stopBatAimbot();St.stopAutoSteal();St.stopAutoLeft();St.stopAutoRight();St.stopAntiRagdoll();St.stopAutoTP();M.stopHoldInfJump()
    if St.stretchRezEnabled then St.disableStretchRez() end;if St.antiLagEnabled then St.disableAntiLag() end;St.saveConfig()
end
local Visuals = {}
Visuals.setInstaGrab = nil
Visuals.setInfJumpVisual = nil
Visuals.setAntiRagVisual = nil
Visuals.setMedusaVisual = nil
Visuals.setUnwalkVisual = nil
Visuals.setAntiLagVisual = nil
Visuals.setAutoSwingVisual = nil
Visuals.setTryhardAnimVisual = nil
Visuals.setAnimPackVisual = nil
Visuals.setTranspVisual = nil
Visuals.setLockVisual = nil
Visuals.setMobVisual = nil
Visuals.setCircleBtnsVisual = nil
Visuals.setMedusaResetVisual = nil


St.mainFrame=nil
St.mainUIScale=nil
St.uiScalePercent=90

do
    local _persistentConns = {}
    function trackConn(conn) 
        table.insert(_persistentConns, conn)
        return conn 
    end
    function clearPersistentConns() 
        for _,c in ipairs(_persistentConns) do 
            pcall(function() c:Disconnect() end) 
        end
        _persistentConns = {}
    end
end

St.refreshSpeedModeLabel=function()
    if UIRefs.carryModeSetVisual then UIRefs.carryModeSetVisual(St.carrySpeedActive) end
    if UIRefs.laggerModeSetVisual then UIRefs.laggerModeSetVisual(St.laggerModeEnabled) end
end
St.toggleCarryMode=function()
    if St.laggerModeEnabled then
        St.laggerModeEnabled = false
        St.carrySpeedActive = true
    else
        St.carrySpeedActive = not St.carrySpeedActive
    end
    St.refreshSpeedModeLabel()
    St.updateModeDisplay()
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(St.carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(St.laggerModeEnabled) end
    if mobBtnRefs.tpBat then mobBtnRefs.tpBat(_G._tpBatEnabled == true) end
end
St.toggleLaggerMode=function()
    if St.carrySpeedActive then
        St.carrySpeedActive = false
    end
    St.laggerModeEnabled = not St.laggerModeEnabled
    St.refreshSpeedModeLabel()
    St.updateModeDisplay()
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(St.carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(St.laggerModeEnabled) end
end
St.startAntiRagdoll=function()
    if Conns.antiRag then return end
    Conns.antiRag=RunService.Heartbeat:Connect(function()
        if not St.antiRagdollEnabled then return end
        local char=LP.Character
        if not char then return end

        local hum=char:FindFirstChildOfClass("Humanoid")
        local root=char:FindFirstChild("HumanoidRootPart")
        if not (hum and root) then return end
        if hum.Health<=0 then return end

        local s=hum:GetState()
        if s==Enum.HumanoidStateType.Dead then return end

        local ragdolled=(s==Enum.HumanoidStateType.Physics or s==Enum.HumanoidStateType.Ragdoll or s==Enum.HumanoidStateType.FallingDown)

        local endTime=LP:GetAttribute("RagdollEndTime")
        if endTime and (endTime-workspace:GetServerTimeNow())>0 then
            ragdolled=true
        end

        if ragdolled then
            pcall(function()
                LP:SetAttribute("RagdollEndTime",workspace:GetServerTimeNow())
            end)

            local now=tick()
            if now < St._nextAntiRagFixAt then return end
            St._nextAntiRagFixAt = now + INT.ANTIRAGDOLL_FIX_INTERVAL

            for _,d in ipairs(char:GetDescendants()) do
                if d:IsA("BallSocketConstraint") or (d:IsA("Attachment") and tostring(d.Name):find("RagdollAttachment")) then
                    pcall(function() d:Destroy() end)
                end
            end

            for _,obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") and obj.Enabled==false then
                    pcall(function() obj.Enabled=true end)
                end
            end

            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            pcall(function() workspace.CurrentCamera.CameraSubject=hum end)
            pcall(function()
                local CM=getAspectControlModule()
                if CM then CM:Enable() end
            end)
            pcall(function()
                root.Anchored=false
                root.AssemblyLinearVelocity=Vector3.zero
                root.AssemblyAngularVelocity=Vector3.zero
            end)
        end
    end)
end
St.stopAntiRagdoll=function() if Conns.antiRag then Conns.antiRag:Disconnect();Conns.antiRag=nil end end
St.startUnwalk=function()
    local c=LP.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate");if anim then St.unwalkSavedAnimate=anim:Clone();anim:Destroy() end
end
St.stopUnwalk=function() local c=LP.Character;if c and St.unwalkSavedAnimate then St.unwalkSavedAnimate:Clone().Parent=c;St.unwalkSavedAnimate=nil end end

-- ============================================================
-- STEAL BAR (stile message_12: card rossa con puntino pulsante + shimmer)
-- ============================================================
function M.createStealBar()
    if UIRefs.stealBarFrame and UIRefs.stealBarFrame.Parent then
        St.stealBarSavedPos=UIRefs.stealBarFrame.Position
    end
    for _,n in ipairs({"AspectStealBar"}) do
        local old=game:GetService("CoreGui"):FindFirstChild(n);if old then old:Destroy() end
        local pgui=LP:FindFirstChild("PlayerGui");if pgui then local o=pgui:FindFirstChild(n);if o then o:Destroy() end end
    end

    local stealGui=Instance.new("ScreenGui")
    stealGui.Name="AspectStealBar"; stealGui.ResetOnSpawn=false
    stealGui.DisplayOrder=9997; stealGui.IgnoreGuiInset=false
    stealGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(stealGui) end end)
    if not pcall(function() stealGui.Parent=game:GetService("CoreGui") end) then stealGui.Parent=LP:WaitForChild("PlayerGui") end

    -- Get accent color
    local accent = guiAccentColor or Color3.fromRGB(210, 35, 45)
    local accentDark = Color3.new(math.clamp(accent.R*0.35, 0, 1), math.clamp(accent.G*0.35, 0, 1), math.clamp(accent.B*0.35, 0, 1))
    local accentMid = Color3.new(math.clamp(accent.R*0.65, 0, 1), math.clamp(accent.G*0.65, 0, 1), math.clamp(accent.B*0.65, 0, 1))
    local accentBright = Color3.new(math.clamp(accent.R*1.35, 0, 1), math.clamp(accent.G*1.35, 0, 1), math.clamp(accent.B*1.35, 0, 1))
    local accentGlow = Color3.new(math.clamp(accent.R*1.6, 0, 1), math.clamp(accent.G*1.6, 0, 1), math.clamp(accent.B*1.6, 0, 1))

    local CARD_W = 280
    local CARD_H = 44
    local BAR_W = 248
    local BAR_H = 6

    local card=Instance.new("Frame",stealGui)
    UIRefs.stealBarFrame=card
    card.Name="StealCard"
    card.AnchorPoint=Vector2.new(0.5,1)
    card.Position=St.stealBarSavedPos or UDim2.new(0.5,0,1,-106)
    card.Size=UDim2.fromOffset(CARD_W, CARD_H)
    card.BackgroundColor3=Color3.fromRGB(12,10,14)
    card.BackgroundTransparency=0.08
    card.BorderSizePixel=0; card.ZIndex=10; card.Visible=true
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,14)
    St.stealBarUIScale = Instance.new("UIScale", card)
    St.stealBarUIScale.Scale = (St.uiScalePercent or 90) / 100

    -- Card gradient overlay
    local cardGrad=Instance.new("UIGradient",card)
    cardGrad.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(20,16,22)),
        ColorSequenceKeypoint.new(0.5,Color3.fromRGB(12,10,14)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(18,14,20)),
    })
    cardGrad.Rotation=90

    -- Outer glow stroke
    local cStroke=Instance.new("UIStroke",card)
    UIRefs.stealBarStroke=cStroke
    cStroke.Color=accent; cStroke.Thickness=1.6; cStroke.Transparency=0.15
    cStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Inner shadow frame for depth
    local innerShadow=Instance.new("Frame",card)
    innerShadow.Size=UDim2.new(1,-6,1,-6)
    innerShadow.Position=UDim2.new(0,3,0,3)
    innerShadow.BackgroundTransparency=1
    innerShadow.BorderSizePixel=0; innerShadow.ZIndex=10
    Instance.new("UICorner",innerShadow).CornerRadius=UDim.new(0,11)
    local innerStroke=Instance.new("UIStroke",innerShadow)
    innerStroke.Color=Color3.fromRGB(255,255,255)
    innerStroke.Thickness=0.8
    innerStroke.Transparency=0.92

    -- Pulsing dot with glow ring
    local dotGlow=Instance.new("Frame",card)
    UIRefs.stealBarDotGlow=dotGlow
    dotGlow.AnchorPoint=Vector2.new(0.5,0.5)
    dotGlow.Position=UDim2.fromOffset(16, 16)
    dotGlow.Size=UDim2.fromOffset(14, 14)
    dotGlow.BackgroundColor3=accent
    dotGlow.BackgroundTransparency=0.85
    dotGlow.BorderSizePixel=0; dotGlow.ZIndex=11
    Instance.new("UICorner",dotGlow).CornerRadius=UDim.new(1,0)

    local dot=Instance.new("Frame",card)
    UIRefs.stealBarDot=dot
    dot.AnchorPoint=Vector2.new(0.5,0.5)
    dot.Position=UDim2.fromOffset(16, 16)
    dot.Size=UDim2.fromOffset(8, 8)
    dot.BackgroundColor3=accent
    dot.BackgroundTransparency=0; dot.BorderSizePixel=0; dot.ZIndex=12
    Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)

    -- Dot pulse animation
    task.spawn(function()
        while dot and dot.Parent do
            TweenService:Create(dot, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                BackgroundTransparency=0.55,
                Size=UDim2.fromOffset(6, 6),
                Position=UDim2.fromOffset(17, 17)
            }):Play()
            TweenService:Create(dotGlow, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                BackgroundTransparency=0.92,
                Size=UDim2.fromOffset(18, 18),
                Position=UDim2.fromOffset(11, 11)
            }):Play()
            task.wait(0.55)
            TweenService:Create(dot, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                BackgroundTransparency=0,
                Size=UDim2.fromOffset(8, 8),
                Position=UDim2.fromOffset(16, 16)
            }):Play()
            TweenService:Create(dotGlow, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                BackgroundTransparency=0.78,
                Size=UDim2.fromOffset(14, 14),
                Position=UDim2.fromOffset(13, 13)
            }):Play()
            task.wait(0.55)
        end
    end)

    -- Title label
    local stealLbl=Instance.new("TextLabel",card)
    UIRefs.stealBarTitle=stealLbl
    stealLbl.AnchorPoint=Vector2.new(0,0.5)
    stealLbl.Position=UDim2.fromOffset(28, 16)
    stealLbl.Size=UDim2.fromOffset(100, 18)
    stealLbl.BackgroundTransparency=1
    stealLbl.Font=Enum.Font.GothamBlack; stealLbl.Text="STEALING"
    stealLbl.TextColor3=Color3.fromRGB(230,230,230)
    stealLbl.TextSize=11; stealLbl.TextXAlignment=Enum.TextXAlignment.Left
    stealLbl.ZIndex=11
    local titleStroke=Instance.new("UIStroke",stealLbl)
    titleStroke.Color=accent; titleStroke.Thickness=0.3; titleStroke.Transparency=0.7

    -- Percentage label
    local pctLbl=Instance.new("TextLabel",card)
    UIRefs.stealBarPct=pctLbl
    pctLbl.AnchorPoint=Vector2.new(1,0.5)
    pctLbl.Position=UDim2.fromOffset(CARD_W - 14, 16)
    pctLbl.Size=UDim2.fromOffset(50, 16)
    pctLbl.BackgroundTransparency=1
    pctLbl.Font=Enum.Font.GothamBlack; pctLbl.Text="0%"
    pctLbl.TextColor3=accent
    pctLbl.TextSize=12; pctLbl.TextXAlignment=Enum.TextXAlignment.Right
    pctLbl.ZIndex=11

    -- Bar background
    local barBg=Instance.new("Frame",card)
    barBg.AnchorPoint=Vector2.new(0.5,1)
    barBg.Position=UDim2.fromOffset(CARD_W/2, CARD_H - 8)
    barBg.Size=UDim2.fromOffset(BAR_W, BAR_H)
    barBg.BackgroundColor3=Color3.fromRGB(25, 20, 28)
    barBg.BackgroundTransparency=0.25; barBg.BorderSizePixel=0; barBg.ZIndex=11
    Instance.new("UICorner",barBg).CornerRadius=UDim.new(1,0)
    local barBgStroke=Instance.new("UIStroke",barBg)
    barBgStroke.Color=Color3.fromRGB(40, 35, 45)
    barBgStroke.Thickness=0.6
    barBgStroke.Transparency=0.4

    -- Bar fill with accent color
    local barFill=Instance.new("Frame",barBg)
    UIRefs.stealBarFill=barFill
    barFill.Size=UDim2.new(0,0,1,0)
    barFill.BackgroundColor3=accent
    barFill.BackgroundTransparency=0; barFill.BorderSizePixel=0; barFill.ZIndex=12
    Instance.new("UICorner",barFill).CornerRadius=UDim.new(1,0)

    -- Bar fill gradient (accent-based)
    local bG=Instance.new("UIGradient",barFill)
    UIRefs.stealBarGradient=bG
    bG.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0, accentDark),
        ColorSequenceKeypoint.new(0.45, accent),
        ColorSequenceKeypoint.new(0.55, accentBright),
        ColorSequenceKeypoint.new(1, accentMid),
    })
    bG.Rotation=0

    -- Bar fill glow overlay
    local barGlow=Instance.new("Frame",barFill)
    UIRefs.stealBarGlow=barGlow
    barGlow.Size=UDim2.new(1,0,1,0)
    barGlow.BackgroundColor3=accentGlow
    barGlow.BackgroundTransparency=0.75
    barGlow.BorderSizePixel=0; barGlow.ZIndex=13
    Instance.new("UICorner",barGlow).CornerRadius=UDim.new(1,0)

    -- Shimmer effect (white shine sliding across)
    local shimmer=Instance.new("Frame",barFill)
    shimmer.Size=UDim2.fromOffset(24, BAR_H)
    shimmer.Position=UDim2.new(-0.3,0,0,0)
    shimmer.BackgroundColor3=Color3.fromRGB(255,255,255)
    shimmer.BackgroundTransparency=0.55; shimmer.BorderSizePixel=0; shimmer.ZIndex=14
    Instance.new("UICorner",shimmer).CornerRadius=UDim.new(1,0)
    local shimmerGrad=Instance.new("UIGradient",shimmer)
    shimmerGrad.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(255,255,255)),
    })
    shimmerGrad.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,1),
        NumberSequenceKeypoint.new(0.3,0.35),
        NumberSequenceKeypoint.new(0.7,0.35),
        NumberSequenceKeypoint.new(1,1),
    })

    -- Shimmer animation
    task.spawn(function()
        while shimmer and shimmer.Parent do
            if card.Visible and St.isStealing then
                shimmer.Position=UDim2.new(-0.35,0,0,0)
                TweenService:Create(shimmer, TweenInfo.new(0.7, Enum.EasingStyle.Sine), {Position=UDim2.new(1.15,0,0,0)}):Play()
                task.wait(0.85)
            else
                task.wait(0.25)
            end
        end
    end)

    -- Status update loop
    task.spawn(function()
        while barFill and barFill.Parent do
            local now=tick()
            if Steal.AutoStealEnabled then
                if now >= St._nextStealBarRadiusCheckAt then
                    St._nextStealBarRadiusCheckAt = now + INT.STEAL_BAR_RADIUS_INTERVAL
                    St._cachedStealBarInRadius = M.isNearPodiumWithPrompt()
                end
                local inRadius=St._cachedStealBarInRadius
                local pct=0
                if St.isStealing and St.stealStartTime then
                    pct=math.clamp((now-St.stealStartTime)/St._activeStealDuration,0,1)
                elseif inRadius and Steal.StealDuration>0 then
                    local cyclePos=(now%Steal.StealDuration)/Steal.StealDuration
                    pct=cyclePos*cyclePos*(3-2*cyclePos)
                end
                barFill.Size=UDim2.new(pct,0,1,0)
                pctLbl.Text=math.floor(pct*100).."%"
                -- Dynamic color intensity based on progress
                if pct > 0.8 then
                    pctLbl.TextColor3 = accentBright
                else
                    pctLbl.TextColor3 = accent
                end
            else
                barFill.Size=UDim2.new(0,0,1,0)
                pctLbl.Text="0%"
                pctLbl.TextColor3 = accent
            end
            task.wait(INT.STEAL_BAR_VISUAL_INTERVAL)
        end
    end)

    -- Drag functionality
    local dragStart2,dragStartPos2,dragging2=nil,nil,false
    card.InputBegan:Connect(function(input)
        if St.uiLocked then return end
        if currentlyDragging ~= nil then return end
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            currentlyDragging=card
            dragging2=true;dragStart2=input.Position;dragStartPos2=card.Position
            input.Changed:Connect(function()
                if input.UserInputState==Enum.UserInputState.End then
                    dragging2=false
                    St.stealBarSavedPos=card.Position
                    if currentlyDragging==card then currentlyDragging=nil end
                end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if St.uiLocked then dragging2=false;return end
        if dragging2 and currentlyDragging==card and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local delta=input.Position-dragStart2
            card.Position=UDim2.new(
                dragStartPos2.X.Scale, dragStartPos2.X.Offset+delta.X,
                dragStartPos2.Y.Scale, dragStartPos2.Y.Offset+delta.Y
            )
            St.stealBarSavedPos=card.Position
        end
    end)
end
-- ============================================================
-- MOBILE BUTTONS
-- MOBILE BUTTONS
-- ============================================================
local C_BTN_OFF_TRANSPARENCY_GLOBAL=0.15

function M.destroyMobileButtons()
    currentlyDragging=nil
    if St.mobGuiRef then pcall(function() St.mobGuiRef:Destroy() end);St.mobGuiRef=nil end
    for _,n in ipairs({"AspectMobileButtons"}) do
        local old=game:GetService("CoreGui"):FindFirstChild(n);if old then old:Destroy() end
        local pgui=LP:FindFirstChild("PlayerGui");if pgui then local o=pgui:FindFirstChild(n);if o then o:Destroy() end end
    end
    mobBtnRefs={}
end
function M.buildMobileButtons()
    M.destroyMobileButtons()
    local isMobile = UIS.TouchEnabled
    if not St.mobileButtonsEnabled and not isMobile then return end

    local savedPositions=M.loadBtnPositions()
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920,1080)

    local isPC = not isMobile
    if not isMobile then
        pcall(function()
            local platform = UIS:GetPlatform()
            isPC = (platform == Enum.Platform.Windows or platform == Enum.Platform.OSX or platform == Enum.Platform.Linux)
        end)
        if not isPC and vp.X > 900 then isPC = true end
    end

    local function darken(c,m)
        return Color3.fromRGB(
            math.clamp(math.floor(c.R*255*m+0.5),0,255),
            math.clamp(math.floor(c.G*255*m+0.5),0,255),
            math.clamp(math.floor(c.B*255*m+0.5),0,255)
        )
    end

    local ACCENT=guiAccentColor or Color3.fromRGB(120,180,255)
    local ACCENT_SOFT=darken(ACCENT,0.78)
    local ACCENT_DEEP=darken(ACCENT,0.38)
    local BTN_OFF_BG=Color3.fromRGB(10,12,18)
    local BTN_ON_BG=ACCENT
    local BTN_BORDER_OFF=Color3.fromRGB(48,54,70)
    local BTN_BORDER_ON=ACCENT
    local TXT_OFF=ACCENT
    local TXT_ON=Color3.fromRGB(0,0,0)
    local SHINE=Color3.fromRGB(255,255,255)

    local BASE_SIZE = isPC and math.max(56, math.floor(St.mobileButtonsSize*0.72)) or math.max(44,math.floor(St.mobileButtonsSize*0.52))
    local BTN_SIZE = BASE_SIZE
    local BTN_GAP = isPC and 8 or 6
    local PAD = isPC and 8 or 6
    local COLS=2
    local ROWS=5
    local PANEL_W=PAD*2+COLS*BTN_SIZE+(COLS-1)*BTN_GAP
    local PANEL_H=PAD*2+ROWS*BTN_SIZE+(ROWS-1)*BTN_GAP
    local GRID_X=vp.X-PANEL_W-(isPC and 44 or 24)
    local GRID_Y=math.floor((vp.Y-PANEL_H)/2)
    local CORNER_R=St.circleButtonsEnabled and BTN_SIZE or (isPC and 16 or 12)
    local FONT_SIZE=math.max(isPC and 10 or 8,math.floor(BTN_SIZE*(isPC and 0.14 or 0.16)))

    local function clampPos(x,y)
        local maxX=math.max(0,vp.X-BTN_SIZE)
        local maxY=math.max(0,vp.Y-BTN_SIZE)
        return math.clamp(math.floor(x+0.5),0,maxX),math.clamp(math.floor(y+0.5),0,maxY)
    end

    local mobGui=Instance.new("ScreenGui")
    mobGui.Name="AspectMobileButtons";mobGui.ResetOnSpawn=false;mobGui.DisplayOrder=15;mobGui.IgnoreGuiInset=true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(mobGui) end end)
    if not pcall(function() mobGui.Parent=game:GetService("CoreGui") end) then mobGui.Parent=LP:WaitForChild("PlayerGui") end
    St.mobGuiRef=mobGui

    local panel=Instance.new("Frame",mobGui)
    panel.Name="MobPanel"
    panel.Size=UDim2.new(0,PANEL_W,0,PANEL_H)
    panel.Position=UDim2.new(0,GRID_X,0,GRID_Y)
    panel.BackgroundTransparency=1
    panel.BorderSizePixel=0
    panel.Visible=false
    panel.Active=false
    panel.ZIndex=94

    local NL=string.char(10)
    -- MANUXS HUB floating buttons: matched to the supplied 9-button layout.
    local buttons={
        {key="tpDown",label="TP"..NL.."DOWN",toggle=false,row=0,col=0},
        {key="autoLeft",label="AUTO"..NL.."LEFT",toggle=true,row=0,col=1},
        {key="autoRight",label="AUTO"..NL.."RIGHT",toggle=true,row=1,col=0},
        {key="drop",label="DROP"..NL.."BR",toggle=false,row=1,col=1},
        {key="carrySpeed",label="CARRY"..NL.."SPD",toggle=true,row=2,col=0},
        {key="autoBat",label="AUTO"..NL.."BAT",toggle=true,row=2,col=1},
        {key="instaReset",label="INSTANT"..NL.."RESET",toggle=false,row=3,col=0},
        {key="lagger",label="LAGGER"..NL.."MODE",toggle=true,row=3,col=1},
        {key="tpBat",label="BAT"..NL.."TP",toggle=false,row=4,col=0},
    }

    for _,def in ipairs(buttons) do
        local xPos=GRID_X+PAD+def.col*(BTN_SIZE+BTN_GAP)
        local yPos=GRID_Y+PAD+def.row*(BTN_SIZE+BTN_GAP)
        local sp=savedPositions[def.key]
        local initX=sp and sp.xo or xPos
        local initY=sp and sp.yo or yPos
        initX,initY=clampPos(initX,initY)

        local shadow=Instance.new("Frame",mobGui)
        shadow.Name="MobShadow_"..def.key
        shadow.Size=UDim2.new(0,BTN_SIZE,0,BTN_SIZE)
        shadow.Position=UDim2.new(0,initX,0,initY+4)
        shadow.BackgroundColor3=Color3.fromRGB(0,0,0)
        shadow.BackgroundTransparency=0.84
        shadow.BorderSizePixel=0
        shadow.ZIndex=100
        Instance.new("UICorner",shadow).CornerRadius=St.circleButtonsEnabled and UDim.new(1,0) or UDim.new(0,CORNER_R)

        local frame=Instance.new("Frame",mobGui)
        frame.Name="MobBtn_"..def.key
        frame.Size=UDim2.new(0,BTN_SIZE,0,BTN_SIZE)
        frame.Position=UDim2.new(0,initX,0,initY)
        frame.BackgroundColor3=BTN_OFF_BG
        frame.BorderSizePixel=0
        frame.Active=true
        frame.ZIndex=102
        frame:SetAttribute("BtnKey",def.key)

        local uic=Instance.new("UICorner",frame)
        uic.CornerRadius=St.circleButtonsEnabled and UDim.new(1,0) or UDim.new(0,CORNER_R)

        local frameGrad=Instance.new("UIGradient",frame)
        frameGrad.Rotation=45
        frameGrad.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,Color3.fromRGB(14,16,22)),
            ColorSequenceKeypoint.new(1,Color3.fromRGB(6,7,10)),
        })

        local btnStroke=Instance.new("UIStroke",frame)
        btnStroke.Color=BTN_BORDER_OFF
        btnStroke.Thickness=isPC and 2 or 1.6
        btnStroke.Transparency=0
        btnStroke.LineJoinMode=Enum.LineJoinMode.Round

        local shine=Instance.new("Frame",frame)
        shine.Size=UDim2.new(1,0,0,1)
        shine.Position=UDim2.new(0,0,0,0)
        shine.BackgroundColor3=SHINE
        shine.BackgroundTransparency=0.84
        shine.BorderSizePixel=0
        shine.ZIndex=103

        local btn=Instance.new("TextButton",frame)
        btn.Size=UDim2.new(1,0,1,0)
        btn.BackgroundTransparency=1
        btn.Text=def.label
        btn.TextColor3=TXT_OFF
        btn.Font=Enum.Font.GothamBlack
        btn.TextScaled=true
        btn.TextWrapped=true
        btn.LineHeight=1.05
        btn.TextStrokeTransparency=0.88
        btn.AutoButtonColor=false
        btn.ZIndex=105
        local textPadding=Instance.new("UIPadding",btn)
        textPadding.PaddingLeft=UDim.new(0,6)
        textPadding.PaddingRight=UDim.new(0,6)
        textPadding.PaddingTop=UDim.new(0,6)
        textPadding.PaddingBottom=UDim.new(0,6)
        local textConstraint=Instance.new("UITextSizeConstraint",btn)
        textConstraint.MinTextSize=8
        textConstraint.MaxTextSize=FONT_SIZE

        frame.Size=UDim2.new(0,0,0,0)
        shadow.Size=UDim2.new(0,0,0,0)
        frame.BackgroundTransparency=1
        shadow.BackgroundTransparency=1
        task.delay(0.04 * (def.row*2+def.col), function()
            if not frame or not frame.Parent then return end
            TweenService:Create(frame,TweenInfo.new(0.32,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
                Size=UDim2.new(0,BTN_SIZE,0,BTN_SIZE),
                BackgroundTransparency=0
            }):Play()
            TweenService:Create(shadow,TweenInfo.new(0.32,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
                Size=UDim2.new(0,BTN_SIZE,0,BTN_SIZE),
                BackgroundTransparency=0.72
            }):Play()
        end)

        local isOn=false
        local function setOn(v)
            isOn=v
            TweenService:Create(frame,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{BackgroundColor3=v and BTN_ON_BG or BTN_OFF_BG}):Play()
            TweenService:Create(btn,TweenInfo.new(0.2),{TextColor3=v and TXT_ON or TXT_OFF}):Play()
            TweenService:Create(btnStroke,TweenInfo.new(0.2),{
                Color=v and BTN_BORDER_ON or BTN_BORDER_OFF,
                Transparency=0
            }):Play()
            frameGrad.Color = v and ColorSequence.new({
                ColorSequenceKeypoint.new(0,ACCENT_DEEP),
                ColorSequenceKeypoint.new(0.55,ACCENT),
                ColorSequenceKeypoint.new(1,Color3.fromRGB(245,250,255)),
            }) or ColorSequence.new({
                ColorSequenceKeypoint.new(0,Color3.fromRGB(14,16,22)),
                ColorSequenceKeypoint.new(1,Color3.fromRGB(6,7,10)),
            })
            TweenService:Create(shadow,TweenInfo.new(0.2),{
                BackgroundTransparency=v and 0.76 or 0.84
            }):Play()
            if v then
                TweenService:Create(frame,TweenInfo.new(0.08,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(0,BTN_SIZE*1.06,0,BTN_SIZE*1.06)}):Play()
                TweenService:Create(shadow,TweenInfo.new(0.08,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(0,BTN_SIZE*1.06,0,BTN_SIZE*1.06)}):Play()
                task.delay(0.08,function()
                    if frame and frame.Parent then
                        TweenService:Create(frame,TweenInfo.new(0.12,Enum.EasingStyle.Back),{Size=UDim2.new(0,BTN_SIZE,0,BTN_SIZE)}):Play()
                        TweenService:Create(shadow,TweenInfo.new(0.12,Enum.EasingStyle.Back),{Size=UDim2.new(0,BTN_SIZE,0,BTN_SIZE)}):Play()
                    end
                end)
            end
        end
        mobBtnRefs[def.key]=setOn

        local function syncShadow()
            shadow.Position=UDim2.new(0,frame.Position.X.Offset,0,frame.Position.Y.Offset+4)
        end
        syncShadow()

        local function flash()
            TweenService:Create(frame,TweenInfo.new(0.07),{BackgroundColor3=ACCENT_SOFT}):Play()
            TweenService:Create(btn,TweenInfo.new(0.07),{TextColor3=Color3.fromRGB(0,0,0)}):Play()
            TweenService:Create(btnStroke,TweenInfo.new(0.07),{Color=ACCENT,Transparency=0}):Play()
            TweenService:Create(frame,TweenInfo.new(0.06),{Size=UDim2.new(0,BTN_SIZE*0.92,0,BTN_SIZE*0.92)}):Play()
            TweenService:Create(shadow,TweenInfo.new(0.06),{Size=UDim2.new(0,BTN_SIZE*0.92,0,BTN_SIZE*0.92)}):Play()
            task.delay(0.1,function()
                if frame and frame.Parent then
                    TweenService:Create(frame,TweenInfo.new(0.18,Enum.EasingStyle.Back),{Size=UDim2.new(0,BTN_SIZE,0,BTN_SIZE)}):Play()
                    TweenService:Create(shadow,TweenInfo.new(0.18,Enum.EasingStyle.Back),{Size=UDim2.new(0,BTN_SIZE,0,BTN_SIZE)}):Play()
                    TweenService:Create(frame,TweenInfo.new(0.18),{BackgroundColor3=isOn and BTN_ON_BG or BTN_OFF_BG}):Play()
                    TweenService:Create(btn,TweenInfo.new(0.18),{TextColor3=isOn and TXT_ON or TXT_OFF}):Play()
                    TweenService:Create(btnStroke,TweenInfo.new(0.18),{Color=isOn and BTN_BORDER_ON or BTN_BORDER_OFF,Transparency=0}):Play()
                end
            end)
        end

        local dragStart2,dragStartPos2,dragMoved,dragDown=nil,nil,false,false
        btn.MouseButton1Down:Connect(function()
            if not def.toggle then
                TweenService:Create(frame,TweenInfo.new(0.08),{BackgroundColor3=ACCENT}):Play()
                TweenService:Create(btn,TweenInfo.new(0.08),{TextColor3=Color3.fromRGB(0,0,0)}):Play()
            end
        end)
        btn.MouseButton1Up:Connect(function()
            if not def.toggle and not dragMoved then
                TweenService:Create(frame,TweenInfo.new(0.1),{BackgroundColor3=BTN_OFF_BG}):Play()
                TweenService:Create(btn,TweenInfo.new(0.1),{TextColor3=TXT_OFF}):Play()
            end
        end)

        btn.InputBegan:Connect(function(input)
            if St.uiLocked or not St.perButtonDragEnabled then return end
            if currentlyDragging ~= nil then return end
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                currentlyDragging=frame
                dragMoved=false;dragDown=true;dragStart2=input.Position;dragStartPos2=frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState==Enum.UserInputState.End then
                        dragDown=false
                        if currentlyDragging==frame then currentlyDragging=nil end
                        if dragMoved then
                            pcall(M.saveBtnPositions)
                            if not def.toggle then
                                TweenService:Create(frame,TweenInfo.new(0.1),{BackgroundColor3=BTN_OFF_BG}):Play()
                                TweenService:Create(btn,TweenInfo.new(0.1),{TextColor3=TXT_OFF}):Play()
                            end
                        elseif not def.toggle then
                            TweenService:Create(frame,TweenInfo.new(0.1),{BackgroundColor3=BTN_OFF_BG}):Play()
                            TweenService:Create(btn,TweenInfo.new(0.1),{TextColor3=TXT_OFF}):Play()
                        end
                    end
                end)
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if dragDown and currentlyDragging==frame and not St.uiLocked and St.perButtonDragEnabled and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
                local delta=input.Position-dragStart2
                if delta.Magnitude>4 then dragMoved=true end
                if dragMoved then
                    local nx,ny=clampPos(dragStartPos2.X.Offset+delta.X,dragStartPos2.Y.Offset+delta.Y)
                    frame.Position=UDim2.new(0,nx,0,ny)
                    syncShadow()
                end
            end
        end)

        btn.Activated:Connect(function()
            if dragMoved then return end
            if def.key=="tpDown" then St.runTPFloor();flash();return end
            if def.key=="drop" then St.runDrop();flash();return end
            if def.key=="instaReset" then St.cursedInstaReset();flash();return end
            if def.key=="tpBat" then
                if _G._tpBatEnabled then
                    if _G._stopTpBat then _G._stopTpBat() end
                else
                    if _G._startTpBat then _G._startTpBat() end
                end
                flash()
                return
            end

            if def.key=="autoLeft" then
                St.autoLeftEnabled=not St.autoLeftEnabled
                if St.autoLeftEnabled then St.startAutoLeft() else St.stopAutoLeft() end
                if UIRefs.autoLeftSetVisual then UIRefs.autoLeftSetVisual(St.autoLeftEnabled) end
                setOn(St.autoLeftEnabled)
                return
            end
            if def.key=="autoRight" then
                St.autoRightEnabled=not St.autoRightEnabled
                if St.autoRightEnabled then St.startAutoRight() else St.stopAutoRight() end
                if UIRefs.autoRightSetVisual then UIRefs.autoRightSetVisual(St.autoRightEnabled) end
                setOn(St.autoRightEnabled)
                return
            end
            if def.key=="autoBat" then
                if St.autoBatEnabled then
                    St.stopBatAimbot()
                    if UIRefs.autoBatSetVisual then UIRefs.autoBatSetVisual(false) end
                    setOn(false)
                else
                    St.queueAutoBatStart()
                    if UIRefs.autoBatSetVisual then UIRefs.autoBatSetVisual(true) end
                    setOn(true)
                end
                return
            end
            if def.key=="carrySpeed" then
                St.toggleCarryMode();setOn(St.carrySpeedActive);St.saveConfig();return
            end
            if def.key=="lagger" then
                St.toggleLaggerMode();setOn(St.laggerModeEnabled);St.saveConfig();return
            end
        end)
    end

    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(St.autoLeftEnabled) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(St.autoRightEnabled) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(St.autoBatEnabled) end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(St.carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(St.laggerModeEnabled) end

end

-- ============================================================
-- MAIN GUI-- ============================================================
-- MAIN GUI — Blossom Hub style: horizontal tabs, section labels, bordered rows
-- ============================================================
-- ===== PLAYER ESP =====
function M.removeESPForPlayer(plr)
    if FX.espHighlightCache[plr] then pcall(function() FX.espHighlightCache[plr]:Destroy() end);FX.espHighlightCache[plr]=nil end
    if FX.espBillboardCache[plr] then pcall(function() FX.espBillboardCache[plr]:Destroy() end);FX.espBillboardCache[plr]=nil end
    if FX.espTracerCache[plr] then
        for _,ln in ipairs(FX.espTracerCache[plr]) do pcall(function() ln.Visible=false;ln:Remove() end) end
        FX.espTracerCache[plr]=nil
    end
end
function M.clearESP()
    for plr in pairs(FX.espHighlightCache) do pcall(function() FX.espHighlightCache[plr]:Destroy() end) end
    for plr in pairs(FX.espBillboardCache) do pcall(function() FX.espBillboardCache[plr]:Destroy() end) end
    for plr in pairs(FX.espTracerCache) do
        for _,ln in ipairs(FX.espTracerCache[plr]) do pcall(function() ln.Visible=false;ln:Remove() end) end
    end
    FX.espHighlightCache={};FX.espBillboardCache={};FX.espTracerCache={}
end
local function makeESPBillboard(tHead)
    local bb=Instance.new("BillboardGui")
    bb.Name="AspectESPBB";bb.Size=UDim2.new(0,100,0,16);bb.StudsOffset=Vector3.new(0,3.0,0)
    bb.AlwaysOnTop=true;bb.LightInfluence=0;bb.Adornee=tHead;bb.Parent=tHead
    local lbl=Instance.new("TextLabel",bb)
    lbl.Size=UDim2.new(1,0,1,0);lbl.BackgroundTransparency=1;lbl.Font=Enum.Font.GothamBold
    lbl.TextSize=11;lbl.TextColor3=Color3.fromRGB(255,255,255);lbl.TextStrokeTransparency=0.3
    lbl.TextStrokeColor3=Color3.fromRGB(0,0,0);lbl.TextXAlignment=Enum.TextXAlignment.Center
    lbl.TextTruncate=Enum.TextTruncate.AtEnd
    return bb,lbl
end
local function makeESPTracers()
    if not (Drawing and type(Drawing.new)=="function") then return nil end
    local outer=Drawing.new("Line");outer.Color=Color3.fromRGB(255,30,30);outer.Thickness=4;outer.Transparency=0.90;outer.Visible=false
    local mid=Drawing.new("Line");mid.Color=Color3.fromRGB(255,75,75);mid.Thickness=2;mid.Transparency=0.74;mid.Visible=false
    local core=Drawing.new("Line");core.Color=Color3.fromRGB(255,215,215);core.Thickness=0.9;core.Transparency=0.10;core.Visible=false
    return {outer,mid,core}
end
St._espFrameCount=0
function M.updateESP()
    if not FX.espEnabled then M.clearESP();return end
    St._espFrameCount=St._espFrameCount+1
    if St._espFrameCount%3~=0 then return end
    local myChar=LP.Character
    local myRoot=myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local camera=workspace.CurrentCamera
    local myScreenPos,myOnScreen=camera:WorldToViewportPoint(myRoot.Position)
    local myVec=Vector2.new(myScreenPos.X,myScreenPos.Y)
    local currentPlayers=Players:GetPlayers()
    local plrSet={}
    for _,p in ipairs(currentPlayers) do plrSet[p]=true end
    for plr in pairs(FX.espHighlightCache) do if not plrSet[plr] then M.removeESPForPlayer(plr) end end
    for plr in pairs(FX.espTracerCache) do if not plrSet[plr] then M.removeESPForPlayer(plr) end end
    for _,plr in ipairs(currentPlayers) do
        if plr~=LP then
            local char=plr.Character
            if not char then
                M.removeESPForPlayer(plr)
            else
                local tRoot=char:FindFirstChild("HumanoidRootPart")
                local tHead=char:FindFirstChild("Head")
                local tHum=char:FindFirstChildOfClass("Humanoid")
                local alive=tRoot and tHead and tHum and tHum.Health>0
                if alive then
                    local hl=FX.espHighlightCache[plr]
                    if not hl or not hl.Parent or hl.Parent~=char then
                        if hl then pcall(function() hl:Destroy() end) end
                        hl=Instance.new("Highlight");hl.Name="AspectESP"
                        hl.FillColor=Color3.fromRGB(200,0,0);hl.FillTransparency=0.72
                        hl.OutlineColor=Color3.fromRGB(255,70,70);hl.OutlineTransparency=0.05
                        hl.Adornee=char;hl.Parent=char
                        FX.espHighlightCache[plr]=hl
                    end
                    local bb=FX.espBillboardCache[plr]
                    if not bb or not bb.Parent or bb.Adornee~=tHead then
                        if bb then pcall(function() bb:Destroy() end) end
                        local newBB,lbl=makeESPBillboard(tHead)
                        lbl.Text=plr.DisplayName
                        FX.espBillboardCache[plr]=newBB
                    end
                    local lines=FX.espTracerCache[plr]
                    if not lines then lines=makeESPTracers();FX.espTracerCache[plr]=lines or {} end
                    if lines and #lines>0 then
                        local footPos=tRoot.Position-Vector3.new(0,2.5,0)
                        local pos,onScreen=camera:WorldToViewportPoint(footPos)
                        if onScreen and pos.Z>0 and myOnScreen then
                            local tVec=Vector2.new(pos.X,pos.Y)
                            for _,ln in ipairs(lines) do ln.From=myVec;ln.To=tVec;ln.Visible=true end
                        else
                            for _,ln in ipairs(lines) do ln.Visible=false end
                        end
                    end
                else
                    if FX.espHighlightCache[plr] then pcall(function() FX.espHighlightCache[plr]:Destroy() end);FX.espHighlightCache[plr]=nil end
                    if FX.espBillboardCache[plr] then pcall(function() FX.espBillboardCache[plr]:Destroy() end);FX.espBillboardCache[plr]=nil end
                    if FX.espTracerCache[plr] then for _,ln in ipairs(FX.espTracerCache[plr]) do pcall(function() ln.Visible=false end) end end
                end
            end
        end
    end
end

function M.startESPLoop()
    if St.espConn then St.espConn:Disconnect() end
    St.espConn=RunService.RenderStepped:Connect(M.updateESP)
end
function M.stopESPLoop()
    if St.espConn then St.espConn:Disconnect();St.espConn=nil end
    M.clearESP()
end
function M.toggleESP(on)
    FX.espEnabled=on
    if on then M.startESPLoop() else M.stopESPLoop() end
end

-- ===== FPS BOOST =====
local function safeSetfpscap(v) if type(setfpscap)=="function" then pcall(setfpscap,v) end end
local function safeSethiddenproperty(obj,prop,val) if type(sethiddenproperty)=="function" then pcall(sethiddenproperty,obj,prop,val) end end
local function removeCharacterAccessories()
    local char=LP.Character
    if not char then return end
    for _,child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") or (child:IsA("Model") and child:FindFirstChild("Handle")) then
            table.insert(FX.removedAccessories,{parent=child.Parent,acc=child})
            child.Parent=nil
        end
    end
end
local function restoreAccessories()
    for _,item in ipairs(FX.removedAccessories) do
        if item.acc and not item.acc.Parent then item.acc.Parent=item.parent end
    end
    FX.removedAccessories={}
end
function M.applyFPSBoost()
    safeSetfpscap(999999999)
    removeCharacterAccessories()
    local function pO(v)
        pcall(function()
            if v:IsA("Model") then
                v.LevelOfDetail=Enum.ModelLevelOfDetail.Disabled
                pcall(function() v.ModelStreamingMode=Enum.ModelStreamingMode.Nonatomic end)
            elseif v:IsA("MeshPart") then
                v.CastShadow=false;v.DoubleSided=false;v.RenderFidelity=Enum.RenderFidelity.Performance
            elseif v:IsA("BasePart") then
                v.CastShadow=false;v.Material=Enum.Material.Plastic;v.Reflectance=0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency=1
            elseif v:IsA("SpecialMesh") then
                v.TextureId=""
            elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                v.Enabled=false
            elseif v:IsA("SurfaceAppearance") or v:IsA("MaterialVariant") then
                v:Destroy()
            elseif v:IsA("Attachment") then
                v.Visible=false
            end
        end)
    end
    for _,v in pairs(workspace:GetDescendants()) do pO(v) end
    pcall(function()
        local L=Lighting
        for _,v in pairs(L:GetDescendants()) do
            pcall(function()
                if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Clouds") or v:IsA("PostEffect") or v:IsA("ColorCorrectionEffect") then
                    v:Destroy()
                end
            end)
        end
        safeSethiddenproperty(L,"Technology",Enum.Technology.Legacy)
        L.GlobalShadows=false;L.FogEnd=9e9;L.Brightness=0
        local ter=workspace:FindFirstChildOfClass("Terrain")
        if ter then
            safeSethiddenproperty(ter,"Decoration",false)
            ter.WaterReflectance=0;ter.WaterTransparency=0.7;ter.WaterWaveSize=0;ter.WaterWaveSpeed=0
        end
    end)
    workspace.DescendantAdded:Connect(function(v) if FX.fpsBoostEnabled then task.spawn(pO,v) end end)
end
function M.stopFPSBoost()
    FX.fpsBoostEnabled=false
    restoreAccessories()
end

-- (GUI_LAYOUT è dichiarato prima di saveConfig — vedi sopra)

-- ============================================================
-- Sostituisce completamente M.buildGui() nel tuo script:
-- ============================================================
function M.buildGui()
    -- Remove stale stats-label references left by previous GUI rebuilds.
    if St._statsLabels then
        for lbl in pairs(St._statsLabels) do
            if not lbl or not lbl.Parent then
                St._statsLabels[lbl] = nil
            end
        end
    end
    clearPersistentConns(); M.createStealBar()

    local isMobile = UIS.TouchEnabled

    -- ── Palette base ─────────────────────────────────────────
    local BG         = Color3.fromRGB(5, 5, 5)
    local WHITE      = Color3.fromRGB(255, 255, 255)
    local GRAY       = Color3.fromRGB(160, 160, 160)
    local TAB_ACTIVE = Color3.fromRGB(255, 255, 255)
    local TAB_INACT  = Color3.fromRGB(155, 155, 165)
    local TAB_ON_BG  = Color3.fromRGB(38, 38, 44)

    -- Normalizza sempre guiAccentColor prima di usarlo, per evitare crash
    if typeof(guiAccentColor) ~= "Color3" then
        guiAccentColor = Color3.fromRGB(176, 148, 255)
    end

    local function _darken(c, m)
        m = m or 0.55
        return Color3.new(math.clamp(c.R*m,0,1), math.clamp(c.G*m,0,1), math.clamp(c.B*m,0,1))
    end

    local PINK  = guiAccentColor
    local PINK2 = _darken(PINK, 0.55)
    local PINK3 = _darken(PINK, 0.28)

    local _themeRefs = {
        tabIndicators={}, tabStrokes={}, boxStrokes={}, accentTexts={},
        colorSwatches={}, toggleRefs={}, sectionBars={}, rowDots={},
        sectionLabels={}, guiScaleParts={},
    }

    -- Riapplica il colore del tema a tutto ciò che viene creato UNA SOLA VOLTA
    -- (barre/etichette di sezione, testi accent, GUI scale, selettori NORMAL/BYPASS
    -- ecc) e che quindi non si aggiornerebbe da solo
    -- quando l'utente cambia colore tema.
    local function refreshThemeRegistries(newAccent)
        -- ricalcola le shade derivate dal nuovo accento
        local newPINK2 = _darken(newAccent, 0.55)
        local newPINK3 = _darken(newAccent, 0.28)
        PINK  = newAccent
        PINK2 = newPINK2
        PINK3 = newPINK3

        for _,bar in ipairs(_themeRefs.sectionBars) do
            if bar and bar.Parent then bar.BackgroundColor3=newAccent end
        end
        for _,lbl in ipairs(_themeRefs.sectionLabels) do
            if lbl and lbl.Parent then lbl.TextColor3=newAccent end
        end
        for _,t in ipairs(_themeRefs.accentTexts) do
            if t and t.Parent then t.TextColor3=newAccent end
        end
        for _,gp in ipairs(_themeRefs.guiScaleParts) do
            if gp.minus and gp.minus.Parent then gp.minus.BackgroundColor3=newPINK3 end
            if gp.plus and gp.plus.Parent then gp.plus.BackgroundColor3=newPINK3 end
            if gp.val and gp.val.Parent then gp.val.TextColor3=newAccent end
        end
        -- Ricolora tutte le pill toggle: quelle ON prendono il nuovo accent,
        -- quelle OFF restano TOGGLE_OFF_BG
        for _,ref in ipairs(_themeRefs.toggleRefs) do
            if ref and ref.pill and ref.pill.Parent then
                if ref.on then
                    ref.pill.BackgroundColor3 = newAccent
                end
            end
        end
        if UIRefs.refreshBatMode then pcall(UIRefs.refreshBatMode) end
        if UIRefs.refreshDropTypeButtons then pcall(UIRefs.refreshDropTypeButtons) end
        if UIRefs.refreshGrabMethodButtons then pcall(UIRefs.refreshGrabMethodButtons) end
        if UIRefs.refreshJumpModeButtons then pcall(UIRefs.refreshJumpModeButtons) end
    end

    -- Rimuovi GUI precedenti
    for _, n in ipairs({"AspectHub"}) do
        local old = game:GetService("CoreGui"):FindFirstChild(n); if old then old:Destroy() end
        local pg  = LP:FindFirstChild("PlayerGui"); if pg then local o=pg:FindFirstChild(n); if o then o:Destroy() end end
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "AspectHub"; gui.ResetOnSpawn = false
    gui.DisplayOrder = 10; gui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then
        gui.Parent = LP:WaitForChild("PlayerGui")
    end

    -- ── Dimensioni ────────────────────────────────────────────
    local W = (GUI_LAYOUT == 3 or GUI_LAYOUT == 4) and 420 or 310
    local H = 470

    St.mainFrame = Instance.new("Frame", gui)
    St.mainFrame.Name = "Main"
    St.mainFrame.Size = UDim2.new(0, 0, 0, 0)
    St.mainFrame.AnchorPoint = Vector2.new(0, 0.5)
    St.mainFrame.Position = UDim2.new(0, 14, 0.5, 0)
    St.mainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    St.mainFrame.BackgroundTransparency = 1
    St.mainFrame.Active = true
    St.mainFrame.BorderSizePixel = 0
    St.mainFrame.ClipsDescendants = true
    St.mainFrame.ZIndex = 5
    Instance.new("UICorner", St.mainFrame).CornerRadius = UDim.new(0, 22)
    St.mainUIScale = Instance.new("UIScale", St.mainFrame)
    St.mainUIScale.Scale = St.uiScalePercent / 100
    if St.stealBarUIScale then St.stealBarUIScale.Scale = St.uiScalePercent / 100 end

    local mfStroke = Instance.new("UIStroke", St.mainFrame)
    mfStroke.Color = Color3.fromRGB(55, 25, 30); mfStroke.Thickness = 1.4
    mfStroke.Transparency = 0.2; mfStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- ── Background / overlay ─────────────────────────────────

    local bgGrad = Instance.new("Frame", St.mainFrame)
    bgGrad.Name = "BackgroundGradient"; bgGrad.Size = UDim2.new(1,0,1,0)
    bgGrad.BackgroundColor3 = Color3.fromRGB(5,5,5); bgGrad.BackgroundTransparency = 0.18
    bgGrad.BorderSizePixel = 0; bgGrad.ZIndex = 0
    Instance.new("UICorner", bgGrad).CornerRadius = UDim.new(0, 22)
    local bgGradFx = Instance.new("UIGradient", bgGrad); bgGradFx.Rotation = 180
    bgGradFx.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.12),
        NumberSequenceKeypoint.new(0.4, 0.35),
        NumberSequenceKeypoint.new(1, 0.6),
    })
    UIRefs.bgGrad = bgGrad

    local bgOverlay = Instance.new("Frame", St.mainFrame)
    bgOverlay.Name = "BackgroundOverlay"; UIRefs.bgOverlay = bgOverlay
    bgOverlay.Size = UDim2.new(1,0,1,0); bgOverlay.BackgroundColor3 = Color3.fromRGB(5,5,5)
    bgOverlay.BackgroundTransparency = 0.35; bgOverlay.BorderSizePixel = 0; bgOverlay.ZIndex = 3
    bgOverlay.Active = true
    Instance.new("UICorner", bgOverlay).CornerRadius = UDim.new(0, 22)

    -- ── Drag ─────────────────────────────────────────────────
    local function dragHandle(handle)
        local dn, ds, sp, di = false
        handle.InputBegan:Connect(function(i)
            if St.uiLocked then return end
            if currentlyDragging ~= nil then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                currentlyDragging = handle; dn = true; ds = i.Position; sp = St.mainFrame.Position
                i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dn = false; currentlyDragging = nil end end)
            end
        end)
        handle.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end end)
        trackConn(UIS.InputChanged:Connect(function(i)
            if i == di and dn and currentlyDragging == handle and not St.uiLocked then
                St.mainFrame.Position = UDim2.new(sp.X.Scale, sp.X.Offset+(i.Position.X-ds.X), sp.Y.Scale, sp.Y.Offset+(i.Position.Y-ds.Y))
            end
        end))
    end
    -- Drag da qualsiasi punto vuoto del pannello (non solo dall'header)
    dragHandle(St.mainFrame)
    dragHandle(bgOverlay)

    task.defer(function()
        TweenService:Create(St.mainFrame, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, W, 0, H),
            BackgroundTransparency = St.guiTransparencyEnabled and 0.72 or 0.62
        }):Play()
    end)

    -- ============================================================
    -- LAYOUT 1: TAB in ALTO – titolo piccolo "MANUXS" sopra
    -- ============================================================

    -- ── Helper funzioni per costruire il contenuto dei tab ──────────
    -- applyTransparencyToGui: rende tutti i frame figli semitrasparenti
    local _transpOriginals = nil
    local function applyTransparencyToGui(on)
        if not St.mainFrame or not St.mainFrame.Parent then return end
        if not on then
            if _transpOriginals then
                for obj, val in pairs(_transpOriginals) do
                    if obj and obj.Parent then obj.BackgroundTransparency = val end
                end
            end
            St.mainFrame.BackgroundTransparency = 0
            return
        end
        if not _transpOriginals then
            _transpOriginals = {}
            local function snap(parent)
                for _, child in ipairs(parent:GetChildren()) do
                    if child:IsA("Frame") or child:IsA("ScrollingFrame") then
                        _transpOriginals[child] = child.BackgroundTransparency
                        snap(child)
                    end
                end
            end
            snap(St.mainFrame)
        end
        St.mainFrame.BackgroundTransparency = 0.88
        for obj, _ in pairs(_transpOriginals) do
            if obj and obj.Parent then obj.BackgroundTransparency = 0.88 end
        end
    end

    local function _buildTabContent(tabPages, _themeRefs, PINK, PINK2, PINK3, WHITE, GRAY, isMobile)
        -- Colori locali derivati usati dai mk* helpers
        local BG2        = Color3.fromRGB(8, 8, 8)
        local ROW_BG     = Color3.fromRGB(20, 15, 16)
        local ROW_BORDER = Color3.fromRGB(42, 30, 32)
        local INP        = Color3.fromRGB(22, 22, 26)
        local OFF        = Color3.fromRGB(28, 28, 32)
        local TAB_ACTIVE = Color3.fromRGB(255, 255, 255)
        local TAB_INACT  = Color3.fromRGB(155, 155, 165)
        local TAB_ON_BG  = Color3.fromRGB(38, 38, 44)
        local SECT_LBL   = PINK
        local TOGGLE_OFF_BG     = Color3.fromRGB(32, 32, 36)
        local TOGGLE_OFF_DOT    = Color3.fromRGB(80, 80, 88)
        local TOGGLE_OFF_STROKE = Color3.fromRGB(55, 55, 62)
        local TOGGLE_ON_DOT     = Color3.fromRGB(255, 255, 255)
        local topLockButtonSync = nil
    local function mkSectionLbl(parent, txt)
        -- Sezione: barra accento a sinistra, titolo in grassetto, divisore sottile sotto
        local wrapper=Instance.new("Frame",parent)
        wrapper.Size=UDim2.new(1,0,0,34);wrapper.BackgroundTransparency=1;wrapper.LayoutOrder=#parent:GetChildren()

        local bar=Instance.new("Frame",wrapper)
        bar.Size=UDim2.new(0,3,0,14);bar.Position=UDim2.new(0,2,0,9)
        bar.BackgroundColor3=PINK;bar.BorderSizePixel=0;bar.ZIndex=9
        Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0)
        table.insert(_themeRefs.sectionBars,bar)

        local l=Instance.new("TextLabel",wrapper)
        l.Size=UDim2.new(1,-16,0,16);l.Position=UDim2.new(0,12,0,8)
        l.BackgroundTransparency=1;l.Text=txt:upper()
        l.TextColor3=PINK;l.Font=Enum.Font.GothamBlack
        l.TextSize=11;l.TextXAlignment=Enum.TextXAlignment.Left;l.ZIndex=9
        table.insert(_themeRefs.sectionLabels,l)

        local sep=Instance.new("Frame",wrapper)
        sep.Size=UDim2.new(1,-4,0,1);sep.Position=UDim2.new(0,2,0,29)
        sep.BackgroundColor3=ROW_BORDER;sep.BackgroundTransparency=0.35;sep.BorderSizePixel=0;sep.ZIndex=8
    end

    local function mkRow(parent, h)
        -- Card in stile REVIVE.GG: sfondo scuro compatto, bordo sottile, gradiente diagonale leggero
        local f=Instance.new("Frame",parent)
        f.Size=UDim2.new(1,0,0,h or 36)
        f.BackgroundColor3=ROW_BG;f.BackgroundTransparency=0.15
        f.BorderSizePixel=0;f.ZIndex=8;f.LayoutOrder=#parent:GetChildren();f.Active=true
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,12)
        local stroke=Instance.new("UIStroke",f)
        stroke.Color=ROW_BORDER;stroke.Thickness=1;stroke.Transparency=0.3
        stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border

        local cardGrad=Instance.new("UIGradient",f)
        cardGrad.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0, _darken(ROW_BG,1.35)),
            ColorSequenceKeypoint.new(0.5, ROW_BG),
            ColorSequenceKeypoint.new(1, _darken(ROW_BG,1.15)),
        })
        cardGrad.Rotation=135

        f.MouseEnter:Connect(function()
            TweenService:Create(f,TweenInfo.new(0.12,Enum.EasingStyle.Quad),{BackgroundColor3=_darken(ROW_BG,1.7)}):Play()
        end)
        f.MouseLeave:Connect(function()
            TweenService:Create(f,TweenInfo.new(0.15,Enum.EasingStyle.Quad),{BackgroundColor3=ROW_BG}):Play()
        end)

        local spacer=Instance.new("Frame",parent)
        spacer.Size=UDim2.new(1,0,0,4);spacer.BackgroundTransparency=1
        spacer.LayoutOrder=#parent:GetChildren()+1
        return f
    end

    local function mkLabel(row, txt)
        -- Label in stile REVIVE.GG: solo testo bianco Gotham Bold, senza pallino accento
        local l=Instance.new("TextLabel",row)
        l.Size=UDim2.new(0.6,-12,1,0);l.Position=UDim2.new(0,12,0,0)
        l.BackgroundTransparency=1;l.Text=txt
        l.TextColor3=WHITE;l.Font=Enum.Font.GothamBold
        l.TextSize=11;l.TextXAlignment=Enum.TextXAlignment.Left;l.ZIndex=10
        return l
    end

    local function mkPill(row)
        -- Toggle in stile REVIVE.GG: pill compatta 30x16 con knob bianco 12x12
        local pill=Instance.new("Frame",row)
        pill.Size=UDim2.new(0,30,0,16);pill.Position=UDim2.new(1,-38,0.5,-8)
        pill.BackgroundColor3=TOGGLE_OFF_BG;pill.BorderSizePixel=0;pill.ZIndex=9
        Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)

        local dot=Instance.new("Frame",pill)
        dot.Size=UDim2.new(0,12,0,12);dot.Position=UDim2.new(0,2,0.5,-6)
        dot.BackgroundColor3=TOGGLE_ON_DOT;dot.BorderSizePixel=0;dot.ZIndex=10
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)

        local ref={pill=pill,dot=dot,stroke=nil,on=false}
        table.insert(_themeRefs.toggleRefs,ref)
        return pill,dot,nil,ref
    end

    local function animPill(pill, dot, on, stroke)
        local onColor = guiAccentColor or PINK
        TweenService:Create(pill,TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{
            BackgroundColor3=on and onColor or TOGGLE_OFF_BG
        }):Play()
        TweenService:Create(dot,TweenInfo.new(0.18,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
            Position=on and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6),
        }):Play()
    end

    local function mkToggle(parent, txt, cb)
        local row=mkRow(parent,36);local cardStroke=row:FindFirstChildOfClass("UIStroke")
        mkLabel(row,txt)
        local pill,dot,stroke,pillRef=mkPill(row);local on=false
        local function sv(s)
            on=s;if pillRef then pillRef.on=s end;animPill(pill,dot,s,stroke)
            if cardStroke then
                -- Bordo neutro fisso: non cambia colore quando il toggle è attivo
                TweenService:Create(cardStroke,TweenInfo.new(0.18),{Color=ROW_BORDER,Transparency=0.3}):Play()
            end
        end
        local clk=Instance.new("TextButton",row);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=11
        clk.Activated:Connect(function()
            if St._anyKeyListening then return end
            on=not on;sv(on);pcall(cb,on)
        end)
        return sv
    end

    -- Riga con "triangolino" espandibile (stile Vision Hub / trubl): tocchi la freccetta
    -- e si apre un pannello con opzioni extra (modalità, campi numerici, keybind, ecc).
    local function mkChevron(row)
        local btn=Instance.new("TextButton",row)
        btn.Size=UDim2.new(0,28,0,28);btn.Position=UDim2.new(1,-32,0.5,-14)
        btn.BackgroundTransparency=1;btn.Text="";btn.AutoButtonColor=false;btn.ZIndex=12
        local arrow=Instance.new("TextLabel",btn)
        arrow.Size=UDim2.new(1,0,1,0);arrow.BackgroundTransparency=1
        arrow.Text="▾";arrow.TextColor3=Color3.fromRGB(150,145,150);arrow.Font=Enum.Font.GothamBold
        arrow.TextSize=13;arrow.ZIndex=12
        return btn,arrow
    end

    local function mkChevronRow(parent, txt, subH, hasToggle, cb)
        local BASE_H=36
        local row=mkRow(parent,BASE_H);row.ClipsDescendants=true
        local cardStroke=row:FindFirstChildOfClass("UIStroke")
        mkLabel(row,txt)
        local sv=nil
        if hasToggle then
            local pill,dot,stroke,pillRef=mkPill(row);local on=false
            pill.Position=UDim2.new(1,-70,0.5,-8)
            sv=function(s)
                on=s;if pillRef then pillRef.on=s end;animPill(pill,dot,s,stroke)
                if cardStroke then
                    -- Bordo neutro fisso: non cambia colore quando il toggle è attivo
                TweenService:Create(cardStroke,TweenInfo.new(0.18),{Color=ROW_BORDER,Transparency=0.3}):Play()
                end
            end
            local clk=Instance.new("TextButton",row);clk.Size=UDim2.new(1,-64,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=11
            clk.Activated:Connect(function() on=not on;sv(on);if cb then pcall(cb,on) end end)
        end
        local chevBtn,arrow=mkChevron(row)
        local subPanel=Instance.new("Frame",row)
        subPanel.Name="SubPanel";subPanel.Visible=false
        subPanel.Position=UDim2.new(0,0,0,BASE_H)
        subPanel.Size=UDim2.new(1,0,0,subH)
        subPanel.BackgroundTransparency=1;subPanel.BorderSizePixel=0;subPanel.ZIndex=9
        local open=false
        chevBtn.Activated:Connect(function()
            open=not open
            subPanel.Visible=open
            row.Size=open and UDim2.new(1,0,0,BASE_H+subH+6) or UDim2.new(1,0,0,BASE_H)
            arrow.Text=open and "▴" or "▾"
        end)
        return row,subPanel,sv
    end

    local function mkBoxRow(parent, txt, default, cb)
        -- Box numerico in stile REVIVE.GG: sfondo quasi nero, arrotondato, glow rosso al focus
        local row=mkRow(parent,36);mkLabel(row,txt)
        local tb=Instance.new("TextBox",row)
        tb.Size=UDim2.new(0,64,0,26);tb.Position=UDim2.new(1,-74,0.5,-13)
        tb.BackgroundColor3=Color3.fromRGB(18,18,18);tb.BorderSizePixel=0
        tb.Text=tostring(default);tb.TextColor3=WHITE
        tb.Font=Enum.Font.GothamBlack;tb.TextSize=11
        tb.TextXAlignment=Enum.TextXAlignment.Center
        tb.ClearTextOnFocus=false;tb.ZIndex=11
        Instance.new("UICorner",tb).CornerRadius=UDim.new(0,8)
        local stroke=Instance.new("UIStroke",tb)
        stroke.Color=Color3.fromRGB(38,30,32);stroke.Thickness=1
        table.insert(_themeRefs.boxStrokes,stroke)
        tb.Focused:Connect(function()
            TweenService:Create(stroke,TweenInfo.new(0.15),{Color=PINK}):Play()
        end)
        tb.FocusLost:Connect(function()
            TweenService:Create(stroke,TweenInfo.new(0.15),{Color=Color3.fromRGB(38,30,32)}):Play()
            if cb then local n=tonumber(tb.Text);if n then cb(n) else tb.Text=tostring(default) end end
        end)
        return tb
    end


    local GAMEPAD_KEYS={[Enum.KeyCode.ButtonA]=true,[Enum.KeyCode.ButtonB]=true,[Enum.KeyCode.ButtonX]=true,[Enum.KeyCode.ButtonY]=true,[Enum.KeyCode.ButtonL1]=true,[Enum.KeyCode.ButtonR1]=true,[Enum.KeyCode.ButtonL2]=true,[Enum.KeyCode.ButtonR2]=true,[Enum.KeyCode.ButtonL3]=true,[Enum.KeyCode.ButtonR3]=true,[Enum.KeyCode.ButtonStart]=true,[Enum.KeyCode.ButtonSelect]=true,[Enum.KeyCode.DPadUp]=true,[Enum.KeyCode.DPadDown]=true,[Enum.KeyCode.DPadLeft]=true,[Enum.KeyCode.DPadRight]=true}
    local MOUSE_BIND_INPUTS={[Enum.UserInputType.MouseButton1]="Mouse1",[Enum.UserInputType.MouseButton2]="Mouse2",[Enum.UserInputType.MouseButton3]="Mouse3"}
    local function isGamepadInput(inp) return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad")~=nil end
    local function isMouseBindableInput(inp)
        return inp and MOUSE_BIND_INPUTS[inp.UserInputType]~=nil
    end
    local function getBindLabel(entry)
        if entry.kb then return entry.kb.Name end
        if entry.gp then return entry.gp.Name end
        if entry.mouse then return MOUSE_BIND_INPUTS[entry.mouse] or entry.mouse.Name end
        return "..."
    end
    local function isBindableInput(inp)
        if not inp then return false end
        if inp.UserInputType==Enum.UserInputType.Keyboard then return inp.KeyCode~=Enum.KeyCode.Unknown end
        if isMouseBindableInput(inp) then return true end
        return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode]==true
    end
    local function kbMatch(entry,inp)
        if not entry or not inp then return false end
        if entry.mouse and inp.UserInputType==entry.mouse then return true end
        local kc=inp.KeyCode
        return kc and (kc==entry.kb or (entry.gp and kc==entry.gp))
    end

    local function mkKBButton(row, kbEntry, cb)
        local function getLabel()
            return getBindLabel(kbEntry)
        end
        local btn=Instance.new("TextButton",row)
        btn.Size=UDim2.new(0,50,0,22)
        btn.Position=UDim2.new(1,-58,0.5,-11)
        btn.BackgroundColor3=Color3.fromRGB(18,18,18)
        btn.BorderSizePixel=0
        btn.Text=getLabel()
        btn.TextColor3=Color3.fromRGB(155,150,150)
        btn.Font=Enum.Font.GothamBold
        btn.TextSize=9
        btn.AutoButtonColor=false
        btn.ZIndex=11
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,7)
        local btnStroke=Instance.new("UIStroke",btn)
        btnStroke.Color=ROW_BORDER
        btnStroke.Thickness=0.8
        table.insert(_themeRefs.boxStrokes,btnStroke)
        local li=false;local lc;local pv=btn.Text;local ls=0
        btn.Activated:Connect(function()
            if li then li=false;St._anyKeyListening=false;if lc then lc:Disconnect();lc=nil end;btn.Text=pv;btn.TextColor3=Color3.fromRGB(155,150,150);return end
            pv=btn.Text;li=true;St._anyKeyListening=true;ls=tick();btn.Text="···";btn.TextColor3=PINK
            lc=UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode==Enum.KeyCode.Escape then li=false;St._anyKeyListening=false;if lc then lc:Disconnect();lc=nil end;btn.Text=pv;btn.TextColor3=Color3.fromRGB(155,150,150);return end
                local isGp=isGamepadInput(inp);if isGp and not(tick()-ls>=0.15) then return end
                if not isBindableInput(inp) then return end
                local capturedLabel=isGp and inp.KeyCode.Name or (isMouseBindableInput(inp) and (MOUSE_BIND_INPUTS[inp.UserInputType] or inp.UserInputType.Name) or inp.KeyCode.Name)
                btn.Text=capturedLabel;pv=capturedLabel;li=false;St._anyKeyListening=false;if lc then lc:Disconnect();lc=nil end
                btn.TextColor3=Color3.fromRGB(155,150,150)
                if isGp then
                    kbEntry.gp=inp.KeyCode;kbEntry.kb=nil;kbEntry.mouse=nil
                elseif isMouseBindableInput(inp) then
                    kbEntry.mouse=inp.UserInputType;kbEntry.kb=nil;kbEntry.gp=nil
                else
                    kbEntry.kb=inp.KeyCode;kbEntry.gp=nil;kbEntry.mouse=nil
                end
                if cb then cb(inp.KeyCode,isGp) end
                if St.saveConfig then pcall(St.saveConfig) end
            end)
        end)
        return btn
    end

    local function mkToggleKB(parent, txt, kbEntry, onToggle, onKB)
        local row=mkRow(parent,36);local cardStroke=row:FindFirstChildOfClass("UIStroke")
        mkLabel(row,txt)
        mkKBButton(row,kbEntry,function(k,isGp) if onKB then onKB(k,isGp) end end)
        local pill2=Instance.new("Frame",row);pill2.Size=UDim2.new(0,30,0,16);pill2.Position=UDim2.new(1,-38,0.5,-8)
        pill2.BackgroundColor3=TOGGLE_OFF_BG;pill2.BorderSizePixel=0;pill2.ZIndex=9
        Instance.new("UICorner",pill2).CornerRadius=UDim.new(1,0)
        local dot2=Instance.new("Frame",pill2);dot2.Size=UDim2.new(0,12,0,12);dot2.Position=UDim2.new(0,2,0.5,-6)
        dot2.BackgroundColor3=TOGGLE_ON_DOT;dot2.BorderSizePixel=0;dot2.ZIndex=10
        Instance.new("UICorner",dot2).CornerRadius=UDim.new(1,0)
        local kbb=row:FindFirstChildOfClass("TextButton")
        if kbb then kbb.Position=UDim2.new(1,-94,0.5,-11);kbb.Size=UDim2.new(0,50,0,22) end
        local pillRef2={pill=pill2,dot=dot2,stroke=nil,on=false}
        table.insert(_themeRefs.toggleRefs, pillRef2)
        local on=false
        local function sv(s)
            on=s;pillRef2.on=s;animPill(pill2,dot2,s,nil)
            if cardStroke then
                -- Bordo neutro fisso: non cambia colore quando il toggle è attivo
                TweenService:Create(cardStroke,TweenInfo.new(0.18),{Color=ROW_BORDER,Transparency=0.3}):Play()
            end
        end
        local clk=Instance.new("TextButton",pill2);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=11
        clk.Activated:Connect(function() if St._anyKeyListening then return end;on=not on;sv(on);if onToggle then onToggle(on) end end)
        return sv
    end

    local function mkKBRow(parent, txt, kbEntry, onKB)
        local row=mkRow(parent,36);mkLabel(row,txt)
        mkKBButton(row,kbEntry,function(k,isGp) if onKB then onKB(k,isGp) end end)
        return row
    end

    local function mkActionRow(parent, txt, onActivate)
        local row=mkRow(parent,36);mkLabel(row,txt)
        local btn=Instance.new("TextButton",row)
        btn.Size=UDim2.new(0,50,0,22)
        btn.Position=UDim2.new(1,-58,0.5,-11)
        btn.BackgroundColor3=Color3.fromRGB(18,18,18)
        btn.BorderSizePixel=0
        btn.Text="RUN"
        btn.TextColor3=Color3.fromRGB(155,150,150)
        btn.Font=Enum.Font.GothamBold
        btn.TextSize=9
        btn.AutoButtonColor=false
        btn.ZIndex=11
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,7)
        local actionStroke=Instance.new("UIStroke",btn)
        actionStroke.Color=ROW_BORDER
        actionStroke.Thickness=0.8
        btn.Activated:Connect(function()
            TweenService:Create(btn,TweenInfo.new(0.06),{BackgroundColor3=PINK}):Play()
            task.delay(0.12,function() TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(18,18,18)}):Play() end)
            if onActivate then onActivate() end
        end)
        return row,btn
    end

    -- ===== SPEED TAB =====
    local pg=tabPages["Speed"]
    mkSectionLbl(pg,"Auto Speed")
    Visuals.setAutoSwitchSpeedVisual=mkToggle(pg,"Auto Carry Speed",function(on) St.autoSwitchSpeedEnabled=on;St.saveConfig() end)

    mkSectionLbl(pg,"Normal Speed")
    St.normalBox=mkBoxRow(pg,"Normal Speed",NS,function(v) if v>0 and v<=500 then NS=v end;St.saveConfig() end)
    St.carryBox=mkBoxRow(pg,"Carry Speed",CS,function(v) if v>0 and v<=500 then CS=v end;St.saveConfig() end)

    mkSectionLbl(pg,"Lagger Speed")
    St.laggerBox=mkBoxRow(pg,"Lagger Speed",LAGGER_SPEED,function(v) if v>0 and v<=500 then LAGGER_SPEED=v end;St.saveConfig() end)
    mkBoxRow(pg,"Lagger Carry Speed",LAGGER_CARRY_SPEED,function(v) if v>0 and v<=500 then LAGGER_CARRY_SPEED=v end;St.saveConfig() end)

    mkSectionLbl(pg,"Modes")
    -- Carry Mode e Lagger Mode: due toggle indipendenti (stile REVIVE), non un singolo bottone che cicla
    local carryModeSetVisual, laggerModeSetVisual
    carryModeSetVisual=mkToggle(pg,"Carry Mode",function(on)
        if on and St.laggerModeEnabled then
            St.laggerModeEnabled=false
            if laggerModeSetVisual then laggerModeSetVisual(false) end
        end
        St.carrySpeedActive=on
        if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(St.carrySpeedActive) end
        if mobBtnRefs.lagger then mobBtnRefs.lagger(St.laggerModeEnabled) end
        St.saveConfig()
    end)
    UIRefs.carryModeSetVisual=carryModeSetVisual
    do
        local _lastLaggerClickT = 0
        laggerModeSetVisual=mkToggle(pg,"Lagger Mode",function(on)
            local now = tick()
            local wasDouble = (now - _lastLaggerClickT) < 0.35
            _lastLaggerClickT = now
            if wasDouble then
                -- Doppio click: attiva Lagger Carry (lagger + carry entrambi accesi)
                St.laggerModeEnabled = true
                St.carrySpeedActive = true
                if laggerModeSetVisual then laggerModeSetVisual(true) end
                if carryModeSetVisual then carryModeSetVisual(true) end
                if mobBtnRefs.lagger then mobBtnRefs.lagger(true) end
                if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(true) end
                St.saveConfig()
                return
            end
            if on and St.carrySpeedActive then
                St.carrySpeedActive=false
                if carryModeSetVisual then carryModeSetVisual(false) end
            end
            St.laggerModeEnabled=on
            if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(St.carrySpeedActive) end
            if mobBtnRefs.lagger then mobBtnRefs.lagger(St.laggerModeEnabled) end
            St.saveConfig()
        end)
        UIRefs.laggerModeSetVisual=laggerModeSetVisual
    end



    -- ===== COMBAT TAB =====
    pg=tabPages["Mechanics"]
    mkSectionLbl(pg,"Combat")
    Visuals.setESPVisual=mkToggle(pg,"Player ESP",function(on) M.toggleESP(on);St.saveConfig() end)
    Visuals.setAntiRagVisual=mkToggle(pg,"Anti Ragdoll",function(on) St.antiRagdollEnabled=on;if on then St.startAntiRagdoll() else St.stopAntiRagdoll() end;St.saveConfig() end)
    UIRefs.setBatCounterVisual=mkToggle(pg,"Bat Counter",function(on) St.batCounterEnabled=on;if on then St.startBatCounter() else St.stopBatCounter() end;St.saveConfig() end)
    Visuals.setMedusaVisual=mkToggle(pg,"Medusa Counter",function(on) St.medusaCounterEnabled=on;if on then St.setupMedusa(LP.Character) else St.stopMedusaCounter() end;St.saveConfig() end)
    Visuals.setMedusaResetVisual=mkToggle(pg,"Medusa Reset",function(on) St.medusaResetEnabled=on;St.saveConfig() end)
    Visuals.setUnwalkVisual=mkToggle(pg,"Unwalk",function(on) St.unwalkEnabled=on;if on then St.startUnwalk() else St.stopUnwalk() end;St.saveConfig() end)
    do
        local sv=mkToggle(pg,"Body Lock",function(on)
            St.bodyLockEnabled=on
            if on then St.startBodyLock() else St.stopBodyLock() end
            St.saveConfig()
        end)
        UIRefs.bodyLockSetVisual=sv
        Visuals.setBodyLockVisual=sv
        if St.bodyLockEnabled and sv then sv(true) end
    end
    mkBoxRow(pg,"Body Lock Range",St.bodyLockRange,function(v) if v>0 and v<=500 then St.bodyLockRange=v end;St.saveConfig() end)
    do
        -- Bat Aimbot toggle senza triangolino: il pannello NORMAL/BYPASS è sempre visibile
        local sv=mkToggle(pg,"Bat Aimbot",function(on)
            if St._anyKeyListening then return end
            if on then
                if St.autoLeftEnabled then St.autoLeftEnabled=false;St.stopAutoLeft();if UIRefs.autoLeftSetVisual then UIRefs.autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if St.autoRightEnabled then St.autoRightEnabled=false;St.stopAutoRight();if UIRefs.autoRightSetVisual then UIRefs.autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                St.queueAutoBatStart();if mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
            else St.stopBatAimbot();if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            St.saveConfig()
        end)
        UIRefs.autoBatSetVisual=sv

        -- Sottopannello NORMAL / BYPASS sempre visibile (no triangolino)
        local subPanel=Instance.new("Frame",pg)
        subPanel.Size=UDim2.new(1,0,0,34);subPanel.BackgroundTransparency=1;subPanel.BorderSizePixel=0
        subPanel.LayoutOrder=#pg:GetChildren();subPanel.ZIndex=9
        -- Pill NORMAL / BYPASS
        local modeRow=Instance.new("Frame",subPanel)
        modeRow.Position=UDim2.new(0,10,0,2);modeRow.Size=UDim2.new(1,-20,0,26)
        modeRow.BackgroundColor3=Color3.fromRGB(14,14,14);modeRow.BorderSizePixel=0;modeRow.ZIndex=10
        Instance.new("UICorner",modeRow).CornerRadius=UDim.new(0,8)
        local normalBtn=Instance.new("TextButton",modeRow)
        normalBtn.Size=UDim2.new(0.5,0,1,0);normalBtn.Position=UDim2.new(0,0,0,0)
        normalBtn.BackgroundTransparency=1;normalBtn.Text="NORMAL";normalBtn.Font=Enum.Font.GothamBlack
        normalBtn.TextSize=10;normalBtn.AutoButtonColor=false;normalBtn.ZIndex=11
        local bypassBtn=Instance.new("TextButton",modeRow)
        bypassBtn.Size=UDim2.new(0.5,0,1,0);bypassBtn.Position=UDim2.new(0.5,0,0,0)
        bypassBtn.BackgroundTransparency=1;bypassBtn.Text="BYPASS";bypassBtn.Font=Enum.Font.GothamBlack
        bypassBtn.TextSize=10;bypassBtn.AutoButtonColor=false;bypassBtn.ZIndex=11
        local modePill=Instance.new("Frame",modeRow)
        modePill.Size=UDim2.new(0.5,-2,1,-2);modePill.Position=UDim2.new(0,1,0,1);modePill.ZIndex=10
        modePill.BorderSizePixel=0
        Instance.new("UICorner",modePill).CornerRadius=UDim.new(0,7)
        local function refreshBatMode()
            local isB=St.batAimbotMode=="Bypass"
            local curAccent = guiAccentColor or PINK
            modePill.BackgroundColor3=curAccent
            TweenService:Create(modePill,TweenInfo.new(0.15),{Position=isB and UDim2.new(0.5,1,0,1) or UDim2.new(0,1,0,1)}):Play()
            normalBtn.TextColor3=isB and Color3.fromRGB(140,140,140) or WHITE
            bypassBtn.TextColor3=isB and WHITE or Color3.fromRGB(140,140,140)
        end
        refreshBatMode()
        UIRefs.refreshBatMode=refreshBatMode  -- esposto per loadConfigState
        normalBtn.Activated:Connect(function() St.batAimbotMode="Normal";refreshBatMode();St.saveConfig() end)
        bypassBtn.Activated:Connect(function() St.batAimbotMode="Bypass";refreshBatMode();St.saveConfig() end)
    end
    Visuals.setAutoSwingVisual=mkToggle(pg,"Auto Swing",function(on) St.autoSwingEnabled=on;St.saveConfig() end)
    if Visuals.setAutoSwingVisual then Visuals.setAutoSwingVisual(St.autoSwingEnabled) end
    mkToggle(pg,"Prediction",function(on) _G._batPredEnabled=on;St.saveConfig() end)
    do
        local sv=mkToggle(pg,"Auto Left",function(on)
            if St._anyKeyListening then return end
            if on then
                if St.autoRightEnabled then St.autoRightEnabled=false;St.stopAutoRight();if UIRefs.autoRightSetVisual then UIRefs.autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                if St.autoBatEnabled then St.stopBatAimbot();if UIRefs.autoBatSetVisual then UIRefs.autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                St.autoLeftEnabled=true;St.startAutoLeft();if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(true) end
            else St.autoLeftEnabled=false;St.stopAutoLeft();if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            St.saveConfig()
        end)
        UIRefs.autoLeftSetVisual=sv
    end
    do
        local sv=mkToggle(pg,"Auto Right",function(on)
            if St._anyKeyListening then return end
            if on then
                if St.autoLeftEnabled then St.autoLeftEnabled=false;St.stopAutoLeft();if UIRefs.autoLeftSetVisual then UIRefs.autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if St.autoBatEnabled then St.stopBatAimbot();if UIRefs.autoBatSetVisual then UIRefs.autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                St.autoRightEnabled=true;St.startAutoRight();if mobBtnRefs.autoRight then mobBtnRefs.autoRight(true) end
            else St.autoRightEnabled=false;St.stopAutoRight();if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            St.saveConfig()
        end)
        UIRefs.autoRightSetVisual=sv
    end
    mkActionRow(pg,"Drop Brainrot",function() St.runDrop() end)
    do
        local row=mkRow(pg,44);mkLabel(row,"Drop Type")
        local function styleDropButtons()
            local curA = guiAccentColor or PINK
            local curA2 = Color3.new(math.clamp(curA.R*0.55,0,1),math.clamp(curA.G*0.55,0,1),math.clamp(curA.B*0.55,0,1))
            if UIRefs.standDropBtn then
                UIRefs.standDropBtn.BackgroundColor3=(St.currentDropType==DROP_TYPES.STAND) and curA2 or INP
                UIRefs.standDropBtn.TextColor3=(St.currentDropType==DROP_TYPES.STAND) and WHITE or Color3.fromRGB(210,210,210)
            end
            if UIRefs.jumpDropBtn then
                UIRefs.jumpDropBtn.BackgroundColor3=(St.currentDropType==DROP_TYPES.JUMP) and curA2 or INP
                UIRefs.jumpDropBtn.TextColor3=(St.currentDropType==DROP_TYPES.JUMP) and WHITE or Color3.fromRGB(210,210,210)
            end
        end
        UIRefs.refreshDropTypeButtons=styleDropButtons
        UIRefs.standDropBtn=Instance.new("TextButton",row)
        UIRefs.standDropBtn.Size=UDim2.new(0,62,0,18);UIRefs.standDropBtn.Position=UDim2.new(1,-130,0.5,-9)
        UIRefs.standDropBtn.BackgroundColor3=INP;UIRefs.standDropBtn.BorderSizePixel=0;UIRefs.standDropBtn.Text="Stand"
        UIRefs.standDropBtn.TextColor3=WHITE;UIRefs.standDropBtn.Font=Enum.Font.GothamBold;UIRefs.standDropBtn.TextSize=9;UIRefs.standDropBtn.ZIndex=12;UIRefs.standDropBtn.AutoButtonColor=false
        Instance.new("UICorner",UIRefs.standDropBtn).CornerRadius=UDim.new(1,0)
        UIRefs.jumpDropBtn=Instance.new("TextButton",row)
        UIRefs.jumpDropBtn.Size=UDim2.new(0,56,0,18);UIRefs.jumpDropBtn.Position=UDim2.new(1,-64,0.5,-9)
        UIRefs.jumpDropBtn.BackgroundColor3=INP;UIRefs.jumpDropBtn.BorderSizePixel=0;UIRefs.jumpDropBtn.Text="Jump"
        UIRefs.jumpDropBtn.TextColor3=WHITE;UIRefs.jumpDropBtn.Font=Enum.Font.GothamBold;UIRefs.jumpDropBtn.TextSize=9;UIRefs.jumpDropBtn.ZIndex=12;UIRefs.jumpDropBtn.AutoButtonColor=false
        Instance.new("UICorner",UIRefs.jumpDropBtn).CornerRadius=UDim.new(1,0)
        UIRefs.standDropBtn.Activated:Connect(function() St.currentDropType=DROP_TYPES.STAND;styleDropButtons();St.saveConfig() end)
        UIRefs.jumpDropBtn.Activated:Connect(function() St.currentDropType=DROP_TYPES.JUMP;styleDropButtons();St.saveConfig() end)
        styleDropButtons()
    end
    mkActionRow(pg,"Insta Reset",function() St.cursedInstaReset() end)
    UIRefs.setAutoTPVisual=mkToggle(pg,"Auto TP",function(on) St.autoTPEnabled=on;if on then St.startAutoTP() else St.stopAutoTP() end;St.saveConfig() end)
    St.autoTPHeightBox=mkBoxRow(pg,"TP Height",St.autoTPHeight,function(v) if v>=0 and v<=500 then St.autoTPHeight=v end;St.saveConfig() end)
    mkActionRow(pg,"TP Down",function() St.runTPFloor() end)
    Visuals.setInfJumpVisual=mkToggle(pg,"Infinite Jump",function(on) St.infJumpEnabled=on;if St.infJumpEnabled then if St.infJumpMode=="hold" then M.startHoldInfJump() end else M.stopHoldInfJump() end;St.saveConfig() end)
    do
        local row=mkRow(pg,36);mkLabel(row,"Jump Mode")
        local manualBtn=Instance.new("TextButton",row)
        manualBtn.Size=UDim2.new(0,50,0,18);manualBtn.Position=UDim2.new(1,-110,0.5,-9)
        manualBtn.BackgroundColor3=(St.infJumpMode=="manual") and (guiAccentColor or PINK2) or Color3.fromRGB(50,30,40)
        manualBtn.BorderSizePixel=0;manualBtn.Text="Manual"
        manualBtn.TextColor3=WHITE;manualBtn.Font=Enum.Font.GothamBold;manualBtn.TextSize=9
        manualBtn.AutoButtonColor=false;manualBtn.ZIndex=12
        Instance.new("UICorner",manualBtn).CornerRadius=UDim.new(1,0)
        local holdBtn=Instance.new("TextButton",row)
        holdBtn.Size=UDim2.new(0,46,0,18);holdBtn.Position=UDim2.new(1,-57,0.5,-9)
        holdBtn.BackgroundColor3=(St.infJumpMode=="hold") and (guiAccentColor or PINK2) or Color3.fromRGB(50,30,40)
        holdBtn.BorderSizePixel=0;holdBtn.Text="Hold"
        holdBtn.TextColor3=WHITE;holdBtn.Font=Enum.Font.GothamBold;holdBtn.TextSize=9
        holdBtn.AutoButtonColor=false;holdBtn.ZIndex=12
        Instance.new("UICorner",holdBtn).CornerRadius=UDim.new(1,0)
        local function refreshJumpModeButtons()
            local curA2 = (function() local c=guiAccentColor or PINK; return Color3.new(math.clamp(c.R*0.55,0,1),math.clamp(c.G*0.55,0,1),math.clamp(c.B*0.55,0,1)) end)()
            local off = Color3.fromRGB(50,30,40)
            manualBtn.BackgroundColor3=(St.infJumpMode=="manual") and curA2 or off
            holdBtn.BackgroundColor3=(St.infJumpMode=="hold") and curA2 or off
        end
        UIRefs.refreshJumpModeButtons=refreshJumpModeButtons
        manualBtn.Activated:Connect(function() St.infJumpMode="manual";refreshJumpModeButtons();M.stopHoldInfJump();St.saveConfig() end)
        holdBtn.Activated:Connect(function() St.infJumpMode="hold";refreshJumpModeButtons();if St.infJumpEnabled then M.startHoldInfJump() end;St.saveConfig() end)
    end

    -- ===== STEAL TAB =====
    pg=tabPages["Mechanics"]
    mkSectionLbl(pg,"Steal")
    local refreshGrabMethodButtons
    do
        local row=mkRow(pg,36);mkLabel(row,"Grab Method")
        local m1Btn=Instance.new("TextButton",row)
        m1Btn.Size=UDim2.new(0,50,0,18);m1Btn.Position=UDim2.new(1,-110,0.5,-9)
        m1Btn.BorderSizePixel=0;m1Btn.Text="Method 1"
        m1Btn.TextColor3=WHITE;m1Btn.Font=Enum.Font.GothamBold;m1Btn.TextSize=9
        m1Btn.AutoButtonColor=false;m1Btn.ZIndex=12
        Instance.new("UICorner",m1Btn).CornerRadius=UDim.new(1,0)
        local m2Btn=Instance.new("TextButton",row)
        m2Btn.Size=UDim2.new(0,50,0,18);m2Btn.Position=UDim2.new(1,-57,0.5,-9)
        m2Btn.BorderSizePixel=0;m2Btn.Text="Method 2"
        m2Btn.TextColor3=WHITE;m2Btn.Font=Enum.Font.GothamBold;m2Btn.TextSize=9
        m2Btn.AutoButtonColor=false;m2Btn.ZIndex=12
        Instance.new("UICorner",m2Btn).CornerRadius=UDim.new(1,0)
        refreshGrabMethodButtons=function()
            local curA2 = (function() local c=guiAccentColor or PINK; return Color3.new(math.clamp(c.R*0.55,0,1),math.clamp(c.G*0.55,0,1),math.clamp(c.B*0.55,0,1)) end)()
            local off = Color3.fromRGB(50,30,40)
            m1Btn.BackgroundColor3=(Steal.Method==1) and curA2 or off
            m2Btn.BackgroundColor3=(Steal.Method==2) and curA2 or off
            if St.radInput then St.radInput.Text=tostring(Steal.Method==2 and Steal.StealRadius2 or Steal.StealRadius) end
            if St.durationBox then St.durationBox.Text=tostring(Steal.Method==2 and Steal.HoldMin2 or Steal.StealDuration) end
        end
        UIRefs.refreshGrabMethodButtons=refreshGrabMethodButtons
        local function switchMethod(m)
            if Steal.Method==m then return end
            Steal.Method=m
            refreshGrabMethodButtons()
            St.saveConfig()
            if Steal.AutoStealEnabled then St.stopAutoSteal();pcall(St.startAutoSteal) end
        end
        m1Btn.Activated:Connect(function() switchMethod(1) end)
        m2Btn.Activated:Connect(function() switchMethod(2) end)
    end
    St.radInput=mkBoxRow(pg,"Steal Radius",Steal.Method==2 and Steal.StealRadius2 or Steal.StealRadius,function(v)
        if Steal.Method==2 then
            if v>=0.5 and v<=300 then Steal.StealRadius2=v else St.radInput.Text=tostring(Steal.StealRadius2) end
        else
            if v>=0.5 and v<=300 then Steal.StealRadius=v else St.radInput.Text=tostring(Steal.StealRadius) end
        end
        St.saveConfig()
    end)
    St.durationBox=mkBoxRow(pg,"Steal Duration",Steal.Method==2 and Steal.HoldMin2 or Steal.StealDuration,function(v)
        if Steal.Method==2 then
            if v>=0.1 and v<=10 then Steal.HoldMin2=v else St.durationBox.Text=tostring(Steal.HoldMin2) end
        else
            if v>=0.1 and v<=10 then Steal.StealDuration=v else St.durationBox.Text=tostring(Steal.StealDuration) end
        end
        St.saveConfig()
    end)
    if refreshGrabMethodButtons then refreshGrabMethodButtons() end
    do
        local row=mkRow(pg,36);mkLabel(row,"Auto Steal")
        local pill=Instance.new("Frame",row);pill.Size=UDim2.new(0,34,0,18);pill.Position=UDim2.new(1,-44,0.5,-9)
        pill.BackgroundColor3=OFF;pill.BorderSizePixel=0;pill.ZIndex=9
        Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
        local dot=Instance.new("Frame",pill);dot.Size=UDim2.new(0,12,0,12);dot.Position=UDim2.new(0,3,0.5,-6)
        dot.BackgroundColor3=GRAY;dot.BorderSizePixel=0;dot.ZIndex=10
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
        local on=false
        local autoStealPillRef={pill=pill,dot=dot,stroke=nil,on=false}
        table.insert(_themeRefs.toggleRefs, autoStealPillRef)
        local function sv(s)
            on=s;autoStealPillRef.on=s
            local onColor=guiAccentColor or PINK
            TweenService:Create(pill,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=on and onColor or OFF}):Play()
            TweenService:Create(dot,TweenInfo.new(0.22,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
                Position=on and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6),
                BackgroundColor3=on and WHITE or GRAY,
            }):Play()
        end
        Visuals.setInstaGrab=sv
        local clk=Instance.new("TextButton",pill);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=11
        clk.Activated:Connect(function()
            on=not on;sv(on);Steal.AutoStealEnabled=on
            if on then if not pcall(St.startAutoSteal) then Steal.AutoStealEnabled=false;sv(false) end else St.stopAutoSteal() end
            St.saveConfig()
        end)
    end

    -- ===== VISUAL TAB =====
    pg=tabPages["Utils"]
    mkSectionLbl(pg,"Visual")
    Visuals.setFPSBoostVisual=mkToggle(pg,"FPS Boost",function(on)
        FX.fpsBoostEnabled=on
        if on then M.applyFPSBoost() else M.stopFPSBoost() end
        St.saveConfig()
    end)

    -- TRYHARD ANIMATION (Radiant)
    Visuals.setTryhardAnimVisual = mkToggle(pg,"Tryhard Anim",function(on)
        St.tryhardAnimEnabled = on
        if on then
            pcall(M.startTryhardAnim)
        else
            pcall(M.stopTryhardAnim)
        end
        St.saveConfig()
    end)
    if St.tryhardAnimEnabled and Visuals.setTryhardAnimVisual then
        Visuals.setTryhardAnimVisual(true)
    end


    -- ANIMATION PACK (with < > arrows like the screenshot)
    do
        local row=mkRow(pg,40)
        local animLbl=Instance.new("TextLabel",row)
        animLbl.Size=UDim2.new(0,90,1,0)
        animLbl.Position=UDim2.new(0,12,0,0)
        animLbl.BackgroundTransparency=1
        animLbl.Text="Anim Pack"
        animLbl.TextColor3=WHITE
        animLbl.Font=Enum.Font.GothamBold
        animLbl.TextSize=11
        animLbl.TextXAlignment=Enum.TextXAlignment.Left
        animLbl.ZIndex=10

        -- Left arrow button
        local leftBtn=Instance.new("TextButton",row)
        leftBtn.Size=UDim2.new(0,28,0,22)
        leftBtn.Position=UDim2.new(1,-140,0.5,-11)
        leftBtn.BackgroundColor3=INP
        leftBtn.BorderSizePixel=0
        leftBtn.Text="<"
        leftBtn.TextColor3=PINK
        leftBtn.Font=Enum.Font.GothamBlack
        leftBtn.TextSize=12
        leftBtn.AutoButtonColor=false
        leftBtn.ZIndex=11
        Instance.new("UICorner",leftBtn).CornerRadius=UDim.new(0,6)
        local leftStroke=Instance.new("UIStroke",leftBtn)
        leftStroke.Color=ROW_BORDER
        leftStroke.Thickness=0.8

        -- Pack name display
        local packNameLbl=Instance.new("TextLabel",row)
        packNameLbl.Size=UDim2.new(0,80,0,22)
        packNameLbl.Position=UDim2.new(1,-108,0.5,-11)
        packNameLbl.BackgroundColor3=INP
        packNameLbl.BorderSizePixel=0
        packNameLbl.Text="Off"
        packNameLbl.TextColor3=PINK
        packNameLbl.Font=Enum.Font.GothamBold
        packNameLbl.TextSize=9
        packNameLbl.TextXAlignment=Enum.TextXAlignment.Center
        packNameLbl.ZIndex=11
        Instance.new("UICorner",packNameLbl).CornerRadius=UDim.new(0,6)
        local nameStroke=Instance.new("UIStroke",packNameLbl)
        nameStroke.Color=ROW_BORDER
        nameStroke.Thickness=0.8

        -- Right arrow button
        local rightBtn=Instance.new("TextButton",row)
        rightBtn.Size=UDim2.new(0,28,0,22)
        rightBtn.Position=UDim2.new(1,-36,0.5,-11)
        rightBtn.BackgroundColor3=INP
        rightBtn.BorderSizePixel=0
        rightBtn.Text=">"
        rightBtn.TextColor3=PINK
        rightBtn.Font=Enum.Font.GothamBlack
        rightBtn.TextSize=12
        rightBtn.AutoButtonColor=false
        rightBtn.ZIndex=11
        Instance.new("UICorner",rightBtn).CornerRadius=UDim.new(0,6)
        local rightStroke=Instance.new("UIStroke",rightBtn)
        rightStroke.Color=ROW_BORDER
        rightStroke.Thickness=0.8

        local function updateAnimPackDisplay()
            local name = M.getAnimPackNameByIndex(St.animPackIndex)
            packNameLbl.Text = name
            if St.animPackEnabled then
                packNameLbl.TextColor3 = PINK
                leftBtn.TextColor3 = PINK
                rightBtn.TextColor3 = PINK
                nameStroke.Color = PINK
                leftStroke.Color = PINK
                rightStroke.Color = PINK
            else
                packNameLbl.TextColor3 = Color3.fromRGB(120,120,120)
                leftBtn.TextColor3 = Color3.fromRGB(120,120,120)
                rightBtn.TextColor3 = Color3.fromRGB(120,120,120)
                nameStroke.Color = ROW_BORDER
                leftStroke.Color = ROW_BORDER
                rightStroke.Color = ROW_BORDER
            end
        end

        local function cycleAnimPack(dir)
            local count = M.getAnimPackCount()
            if dir < 0 then
                St.animPackIndex = St.animPackIndex - 1
                if St.animPackIndex < 1 then St.animPackIndex = count end
            else
                St.animPackIndex = St.animPackIndex + 1
                if St.animPackIndex > count then St.animPackIndex = 1 end
            end
            local packName = M.getAnimPackNameByIndex(St.animPackIndex)
            St.animPackEnabled = true
            M.applyAnimPack(packName)
            updateAnimPackDisplay()
            St.saveConfig()
        end

        leftBtn.Activated:Connect(function()
            cycleAnimPack(-1)
        end)
        rightBtn.Activated:Connect(function()
            cycleAnimPack(1)
        end)

        -- Click on label to toggle off
        local toggleBtn=Instance.new("TextButton",row)
        toggleBtn.Size=UDim2.new(1,0,1,0)
        toggleBtn.BackgroundTransparency=1
        toggleBtn.Text=""
        toggleBtn.ZIndex=5
        toggleBtn.Activated:Connect(function()
            St.animPackEnabled = not St.animPackEnabled
            if St.animPackEnabled then
                local packName = M.getAnimPackNameByIndex(St.animPackIndex)
                M.applyAnimPack(packName)
            else
                M.stopAnimPack()
            end
            updateAnimPackDisplay()
            St.saveConfig()
        end)

        -- Store ref for config loading
        UIRefs.animPackUpdateDisplay = updateAnimPackDisplay

        -- Init display
        updateAnimPackDisplay()
    end

    Visuals.setAntiLagVisual=mkToggle(pg,"Anti Lag",function(on) if on then St.enableAntiLag() else St.disableAntiLag() end;St.saveConfig() end)
    UIRefs.setStretchRezVisual=mkToggle(pg,"Stretch Rez",function(on) if on then St.enableStretchRez() else St.disableStretchRez() end;St.saveConfig() end)
    Visuals.setRagdollGuiVisual=mkToggle(pg,"Ragdoll GUI",function(on) St.ragdollGuiEnabled=on;St.saveConfig() end)
    Visuals.setRagdollGuiVisual(St.ragdollGuiEnabled)
    do
        local row=mkRow(pg,36);mkLabel(row,"Sky Theme")
        local skyIndex=1
        for i,theme in ipairs(SkyOrder) do if theme==currentSkyTheme then skyIndex=i;break end end
        local skyVal=Instance.new("TextLabel",row)
        skyVal.Size=UDim2.new(0,70,0,22);skyVal.Position=UDim2.new(1,-120,0.5,-11)
        skyVal.BackgroundTransparency=1;skyVal.Text=currentSkyTheme
        skyVal.TextColor3=PINK;skyVal.Font=Enum.Font.GothamBold;skyVal.TextSize=9
        skyVal.TextXAlignment=Enum.TextXAlignment.Right;skyVal.ZIndex=9
        table.insert(_themeRefs.accentTexts, skyVal)
        local cycleBtn=Instance.new("TextButton",row)
        cycleBtn.Size=UDim2.new(0,40,0,18);cycleBtn.Position=UDim2.new(1,-48,0.5,-9)
        cycleBtn.BackgroundColor3=PINK3;cycleBtn.BorderSizePixel=0
        cycleBtn.Text="Next";cycleBtn.TextColor3=WHITE
        cycleBtn.Font=Enum.Font.GothamBold;cycleBtn.TextSize=9
        cycleBtn.AutoButtonColor=false;cycleBtn.ZIndex=10
        Instance.new("UICorner",cycleBtn).CornerRadius=UDim.new(1,0)
        cycleBtn.Activated:Connect(function()
            if St._anyKeyListening then return end
            skyIndex=skyIndex%#SkyOrder+1
            local newTheme=SkyOrder[skyIndex]
            skyVal.Text=newTheme;currentSkyTheme=newTheme
            M.CandyApplyCustomSky(newTheme);St.saveConfig()
        end)
    end
    do
        local row=mkRow(pg,36);mkLabel(row,"FOV")
        local fovBtn=Instance.new("TextButton",row)
        fovBtn.Size=UDim2.new(0,58,0,22);fovBtn.Position=UDim2.new(1,-66,0.5,-11)
        fovBtn.BackgroundColor3=INP;fovBtn.BorderSizePixel=0
        fovBtn.Text=tostring(St.fovValue);fovBtn.TextColor3=PINK
        fovBtn.Font=Enum.Font.GothamBold;fovBtn.TextSize=11;fovBtn.ZIndex=11
        table.insert(_themeRefs.accentTexts, fovBtn)
        Instance.new("UICorner",fovBtn).CornerRadius=UDim.new(0,5)
        for idx,v in ipairs(fovOptions) do if v==St.fovValue then St.fovIndex=idx end end
        fovBtn.Activated:Connect(function()
            St.fovIndex=St.fovIndex%#fovOptions+1;St.fovValue=fovOptions[St.fovIndex]
            fovBtn.Text=tostring(St.fovValue);M.applyFOV();St.saveConfig()
        end)
    end
    do
        local row=mkRow(pg,36);mkLabel(row,"Reset Settings")
        local resetBtn=Instance.new("TextButton",row)
        resetBtn.Size=UDim2.new(0,58,0,22);resetBtn.Position=UDim2.new(1,-66,0.5,-11)
        resetBtn.BackgroundColor3=Color3.fromRGB(140,25,65);resetBtn.BorderSizePixel=0
        resetBtn.Text="RESET";resetBtn.TextColor3=WHITE
        resetBtn.Font=Enum.Font.GothamBold;resetBtn.TextSize=9;resetBtn.ZIndex=9
        Instance.new("UICorner",resetBtn).CornerRadius=UDim.new(0,5)
        resetBtn.Activated:Connect(function() M.resetAllSettings() end)
    end
    do
        local row=mkRow(pg,36);mkLabel(row,"Reset Mobile Pos")
        local resetPosBtn=Instance.new("TextButton",row)
        resetPosBtn.Size=UDim2.new(0,58,0,22);resetPosBtn.Position=UDim2.new(1,-66,0.5,-11)
        resetPosBtn.BackgroundColor3=Color3.fromRGB(140,25,65);resetPosBtn.BorderSizePixel=0
        resetPosBtn.Text="RESET";resetPosBtn.TextColor3=WHITE
        resetPosBtn.Font=Enum.Font.GothamBold;resetPosBtn.TextSize=9;resetPosBtn.ZIndex=9
        Instance.new("UICorner",resetPosBtn).CornerRadius=UDim.new(0,5)
        resetPosBtn.Activated:Connect(function() M.resetMobileButtonPositions() end)
    end

    -- ===== INTERFACE TAB =====
    pg=tabPages["Settings"]
    mkSectionLbl(pg,"Theme")
    do
        local row=mkRow(pg,36);mkLabel(row,"Color")
        local holder=Instance.new("Frame",row)
        holder.Size=UDim2.new(0,140,0,18)
        holder.Position=UDim2.new(1,-150,0.5,-9)
        holder.BackgroundTransparency=1
        holder.BorderSizePixel=0
        holder.ZIndex=11
        local ll=Instance.new("UIListLayout",holder)
        ll.FillDirection=Enum.FillDirection.Horizontal
        ll.HorizontalAlignment=Enum.HorizontalAlignment.Right
        ll.VerticalAlignment=Enum.VerticalAlignment.Center
        ll.SortOrder=Enum.SortOrder.LayoutOrder
        ll.Padding=UDim.new(0,6)

        local colors={
            {name="Purple", c=Color3.fromRGB(220,0,0)},
            {name="Blue",   c=Color3.fromRGB(120,180,255)},
            {name="Pink",   c=Color3.fromRGB(255,120,200)},
            {name="Red",    c=Color3.fromRGB(255,95,95)},
            {name="Green",  c=Color3.fromRGB(120,255,170)},
            {name="Orange", c=Color3.fromRGB(255,185,110)},
        }

        for i,def in ipairs(colors) do
            local sw=Instance.new("TextButton",holder)
            sw.Name="Swatch_"..def.name
            sw.Size=UDim2.new(0,14,0,14)
            sw.BackgroundColor3=def.c
            sw.BorderSizePixel=0
            sw.Text=""
            sw.AutoButtonColor=false
            sw.LayoutOrder=i
            sw.ZIndex=12
            Instance.new("UICorner",sw).CornerRadius=UDim.new(1,0)
            local st=Instance.new("UIStroke",sw)
            st.Color=WHITE
            st.Thickness=1.5
            st.Transparency=1
            table.insert(_themeRefs.colorSwatches,{stroke=st,color=def.c})

            sw.Activated:Connect(function()
                if St._anyKeyListening then return end
                M._applyAccentColor(def.c)
                St.saveConfig()
            end)
        end

        -- applica il colore salvato e aggiorna selezione cerchietti
        M._applyAccentColor(guiAccentColor)
    end

    mkSectionLbl(pg,"Interface")
    Visuals.setTranspVisual=mkToggle(pg,"GUI Transparent",function(on) St.guiTransparencyEnabled=on;pcall(applyTransparencyToGui,on);St.saveConfig() end)
    if St.guiTransparencyEnabled then Visuals.setTranspVisual(true);pcall(applyTransparencyToGui,true) end
    Visuals.setLockVisual=mkToggle(pg,"Lock UI",function(on) St.uiLocked=on;if topLockButtonSync then topLockButtonSync(on) end;St.saveConfig() end)
    if St.uiLocked and Visuals.setLockVisual then Visuals.setLockVisual(true) end
    do
        local row=mkRow(pg,36);mkLabel(row,"GUI Scale")
        local minusBtn=Instance.new("TextButton",row)
        minusBtn.Size=UDim2.new(0,22,0,22);minusBtn.Position=UDim2.new(1,-140,0.5,-11)
        minusBtn.BackgroundColor3=PINK3;minusBtn.BorderSizePixel=0
        minusBtn.Text="-";minusBtn.TextColor3=WHITE
        minusBtn.Font=Enum.Font.GothamBold;minusBtn.TextSize=13
        minusBtn.AutoButtonColor=false;minusBtn.ZIndex=11
        Instance.new("UICorner",minusBtn).CornerRadius=UDim.new(0,5)
        local valLbl=Instance.new("TextLabel",row)
        valLbl.Size=UDim2.new(0,60,0,22);valLbl.Position=UDim2.new(1,-112,0.5,-11)
        valLbl.BackgroundColor3=INP;valLbl.BorderSizePixel=0
        valLbl.Text=string.format("%.2f",St.uiScalePercent/100)
        valLbl.TextColor3=PINK;valLbl.Font=Enum.Font.GothamBold;valLbl.TextSize=10;valLbl.ZIndex=11
        Instance.new("UICorner",valLbl).CornerRadius=UDim.new(0,5)
        local plusBtn=Instance.new("TextButton",row)
        plusBtn.Size=UDim2.new(0,22,0,22);plusBtn.Position=UDim2.new(1,-48,0.5,-11)
        plusBtn.BackgroundColor3=PINK3;plusBtn.BorderSizePixel=0
        plusBtn.Text="+";plusBtn.TextColor3=WHITE
        plusBtn.Font=Enum.Font.GothamBold;plusBtn.TextSize=13
        plusBtn.AutoButtonColor=false;plusBtn.ZIndex=11
        Instance.new("UICorner",plusBtn).CornerRadius=UDim.new(0,5)
        local function applyScale()
            valLbl.Text=string.format("%.2f",St.uiScalePercent/100)
            if St.mainUIScale then St.mainUIScale.Scale=St.uiScalePercent/100 end
            if St.stealBarUIScale then St.stealBarUIScale.Scale=St.uiScalePercent/100 end
            St.saveConfig()
        end
        minusBtn.Activated:Connect(function() St.uiScalePercent=math.clamp(St.uiScalePercent-5,60,130);applyScale() end)
        plusBtn.Activated:Connect(function() St.uiScalePercent=math.clamp(St.uiScalePercent+5,60,130);applyScale() end)
        UIRefs.guiScaleValLbl=valLbl
        table.insert(_themeRefs.guiScaleParts,{minus=minusBtn,plus=plusBtn,val=valLbl})
    end

    -- Floating button size controls: these resize the 9-button floating panel,
    -- not the main GUI. Controls stay inside the Interface section.
    do
        local row=mkRow(pg,36);mkLabel(row,"Floating Buttons Size")
        local minusFloat=Instance.new("TextButton",row)
        minusFloat.Size=UDim2.new(0,22,0,22);minusFloat.Position=UDim2.new(1,-140,0.5,-11)
        minusFloat.BackgroundColor3=PINK3;minusFloat.BorderSizePixel=0
        minusFloat.Text="-";minusFloat.TextColor3=WHITE
        minusFloat.Font=Enum.Font.GothamBold;minusFloat.TextSize=13
        minusFloat.AutoButtonColor=false;minusFloat.ZIndex=11
        Instance.new("UICorner",minusFloat).CornerRadius=UDim.new(0,5)

        local floatSizeLbl=Instance.new("TextLabel",row)
        floatSizeLbl.Size=UDim2.new(0,60,0,22);floatSizeLbl.Position=UDim2.new(1,-112,0.5,-11)
        floatSizeLbl.BackgroundColor3=INP;floatSizeLbl.BorderSizePixel=0
        floatSizeLbl.Text=tostring(math.clamp(tonumber(St.mobileButtonsSize) or 60,40,120))
        floatSizeLbl.TextColor3=PINK;floatSizeLbl.Font=Enum.Font.GothamBold;floatSizeLbl.TextSize=10;floatSizeLbl.ZIndex=11
        Instance.new("UICorner",floatSizeLbl).CornerRadius=UDim.new(0,5)

        local plusFloat=Instance.new("TextButton",row)
        plusFloat.Size=UDim2.new(0,22,0,22);plusFloat.Position=UDim2.new(1,-48,0.5,-11)
        plusFloat.BackgroundColor3=PINK3;plusFloat.BorderSizePixel=0
        plusFloat.Text="+";plusFloat.TextColor3=WHITE
        plusFloat.Font=Enum.Font.GothamBold;plusFloat.TextSize=13
        plusFloat.AutoButtonColor=false;plusFloat.ZIndex=11
        Instance.new("UICorner",plusFloat).CornerRadius=UDim.new(0,5)

        local function applyFloatingButtonSize()
            St.mobileButtonsSize=math.clamp(math.floor(tonumber(St.mobileButtonsSize) or 60),40,120)
            floatSizeLbl.Text=tostring(St.mobileButtonsSize)
            pcall(St.saveConfig)
            pcall(M.buildMobileButtons)
        end
        minusFloat.Activated:Connect(function()
            St.mobileButtonsSize=math.max(40,(tonumber(St.mobileButtonsSize) or 60)-10)
            applyFloatingButtonSize()
        end)
        plusFloat.Activated:Connect(function()
            St.mobileButtonsSize=math.min(120,(tonumber(St.mobileButtonsSize) or 60)+10)
            applyFloatingButtonSize()
        end)
    end

    mkSectionLbl(pg,"Extra")
    mkToggle(pg,"Auto Swing (Move)",function(on) St.autoMoveSwingEnabled=on;St.saveConfig() end)
    mkBoxRow(pg,"Swing Speed (s)",St.autoMoveSwingInterval,function(v) if v>=0.05 and v<=2 then St.autoMoveSwingInterval=v end;St.saveConfig() end)
    -- ===== KEYBIND TAB (tutte le funzioni sono configurabili qui) =====
    pg=tabPages["Keybinds"]
    mkSectionLbl(pg,"Movement & Speed")
    mkKBRow(pg,"Speed Toggle",KB.SpeedToggle,function() St.saveConfig() end)
    mkKBRow(pg,"Lagger Toggle",KB.LaggerToggle,function() St.saveConfig() end)
    mkKBRow(pg,"Auto Switch Speed",KB.AutoSwitchSpeed,function() St.saveConfig() end)
    mkKBRow(pg,"Infinite Jump",KB.InfJump,function() St.saveConfig() end)
    mkKBRow(pg,"Auto TP",KB.AutoTP,function() St.saveConfig() end)
    mkKBRow(pg,"TP Floor",KB.TPFloor,function() St.saveConfig() end)
    mkKBRow(pg,"Unwalk",KB.Unwalk,function() St.saveConfig() end)

    mkSectionLbl(pg,"Combat")
    mkKBRow(pg,"Aimbot",KB.AutoBat,function() St.saveConfig() end)
    mkKBRow(pg,"Auto Left",KB.AutoLeft,function() St.saveConfig() end)
    mkKBRow(pg,"Auto Right",KB.AutoRight,function() St.saveConfig() end)
    mkKBRow(pg,"Auto Swing",KB.AutoSwing,function() St.saveConfig() end)
    mkKBRow(pg,"Anti Ragdoll",KB.AntiRagdoll,function() St.saveConfig() end)
    mkKBRow(pg,"Bat Counter",KB.BatCounter,function() St.saveConfig() end)
    mkKBRow(pg,"Medusa Counter",KB.MedusaCounter,function() St.saveConfig() end)
    mkKBRow(pg,"Medusa Reset",KB.MedusaReset,function() St.saveConfig() end)
    mkKBRow(pg,"Drop Brainrot",KB.DropBrainrot,function() St.saveConfig() end)
    mkKBRow(pg,"Insta Reset",KB.InstaReset,function() St.saveConfig() end)

    mkSectionLbl(pg,"Visual & Interface")
    mkKBRow(pg,"Tryhard Anim",KB.TryhardAnim,function() St.saveConfig() end)
    mkKBRow(pg,"Anti Lag",KB.AntiLag,function() St.saveConfig() end)
    mkKBRow(pg,"Stretch Rez",KB.StretchRez,function() St.saveConfig() end)
    mkKBRow(pg,"Ragdoll GUI",KB.RagdollGui,function() St.saveConfig() end)
    mkKBRow(pg,"GUI Transparent",KB.GuiTransparent,function() St.saveConfig() end)
    mkKBRow(pg,"Lock UI",KB.LockUi,function() St.saveConfig() end)
    mkKBRow(pg,"Hide UI",KB.GuiHide,function() St.saveConfig() end)

    end  -- fine _buildTabContent

    if GUI_LAYOUT == 1 then

        local TAB_BAR_H = 46
        local HDR_H     = 32  -- header sottile: solo titolo + pulsanti

        -- ── HEADER compatto ───────────────────────────────────
        local header = Instance.new("Frame", St.mainFrame)
        header.Size = UDim2.new(1, 0, 0, HDR_H)
        header.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
        header.BackgroundTransparency = 0.15
        header.Active = true; header.BorderSizePixel = 0; header.ZIndex = 6
        Instance.new("UICorner", header).CornerRadius = UDim.new(0, 22)
        dragHandle(header); dragHandle(St.mainFrame)

        -- Titolo piccolo in alto – colore = guiAccentColor
        local titleLbl = Instance.new("TextLabel", header)
        titleLbl.Size = UDim2.new(0, 0, 1, 0)
        titleLbl.AutomaticSize = Enum.AutomaticSize.X
        titleLbl.AnchorPoint = Vector2.new(0.5, 0.5)
        titleLbl.Position = UDim2.new(0.5, 0, 0.5, 0)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = "MANUXS"
        titleLbl.TextColor3 = guiAccentColor   -- ← colore accent
        titleLbl.Font = Enum.Font.GothamBlack
        titleLbl.TextSize = isMobile and 13 or 15
        titleLbl.ZIndex = 8
        local titleStroke = Instance.new("UIStroke", titleLbl)
        titleStroke.Color = PINK; titleStroke.Thickness = 0.3; titleStroke.Transparency = 0.6

        -- FPS/Ping
        local discSmall = Instance.new("TextLabel", header)
        discSmall.Size = UDim2.new(0, 90, 1, 0); discSmall.Position = UDim2.new(0, 8, 0, 0)
        discSmall.BackgroundTransparency = 1; discSmall.Text = ""
        discSmall.TextColor3 = Color3.fromRGB(110, 110, 118); discSmall.Font = Enum.Font.Gotham
        discSmall.TextSize = 8; discSmall.TextXAlignment = Enum.TextXAlignment.Left; discSmall.ZIndex = 8
        bindStatsLabel(discSmall, false)

        -- Pulsante T (cambia layout GUI), L (lock) e – (chiudi)
        local layoutBtn = Instance.new("TextButton", header)
        layoutBtn.Size = UDim2.new(0, 28, 0, 20); layoutBtn.Position = UDim2.new(1, -90, 0.5, -10)
        layoutBtn.BackgroundColor3 = Color3.fromRGB(24, 18, 20); layoutBtn.BorderSizePixel = 0
        layoutBtn.Text = "T"; layoutBtn.TextColor3 = WHITE; layoutBtn.Font = Enum.Font.GothamBlack
        layoutBtn.TextSize = 10; layoutBtn.AutoButtonColor = false; layoutBtn.ZIndex = 10
        Instance.new("UICorner", layoutBtn).CornerRadius = UDim.new(0, 8)
        local layoutStroke = Instance.new("UIStroke", layoutBtn)
        layoutStroke.Color = Color3.fromRGB(50, 35, 38); layoutStroke.Thickness = 1
        layoutBtn.Visible = false
        layoutBtn.Active = false

        local lockBtn = Instance.new("TextButton", header)
        lockBtn.Size = UDim2.new(0, 28, 0, 20); lockBtn.Position = UDim2.new(1, -60, 0.5, -10)
        lockBtn.BackgroundColor3 = Color3.fromRGB(24, 18, 20); lockBtn.BorderSizePixel = 0
        lockBtn.Text = "L"; lockBtn.TextColor3 = WHITE; lockBtn.Font = Enum.Font.GothamBlack
        lockBtn.TextSize = 10; lockBtn.AutoButtonColor = false; lockBtn.ZIndex = 10
        Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0, 8)
        local lockStroke = Instance.new("UIStroke", lockBtn)
        lockStroke.Color = Color3.fromRGB(50, 35, 38); lockStroke.Thickness = 1
        lockBtn.Activated:Connect(function()
            St.uiLocked = not St.uiLocked
            lockBtn.BackgroundColor3 = St.uiLocked and Color3.fromRGB(60,20,24) or Color3.fromRGB(24,18,20)
            lockBtn.TextColor3 = St.uiLocked and PINK or WHITE
            lockStroke.Color = St.uiLocked and PINK or Color3.fromRGB(50,35,38)
            St.saveConfig()
        end)

        local closeBtn = Instance.new("TextButton", header)
        closeBtn.Size = UDim2.new(0, 28, 0, 20); closeBtn.Position = UDim2.new(1, -30, 0.5, -10)
        closeBtn.BackgroundColor3 = Color3.fromRGB(24, 18, 20); closeBtn.BorderSizePixel = 0
        closeBtn.Text = "−"; closeBtn.TextColor3 = Color3.fromRGB(120, 100, 105); closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 14; closeBtn.AutoButtonColor = false; closeBtn.ZIndex = 10
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

        -- ── TAB BAR in ALTO, subito sotto l'header ─────────────
        local TABS        = {"Speed","Mechanics","Keybinds","Utils","Settings"}
        local TAB_DISPLAY = {Speed="MOVE", Mechanics="COMBAT", Keybinds="KEYS", Utils="UTIL", Settings="SET"}
        local tabPages = {}; local tabWrappers = {}; local tabBtnRefs = {}; local activeTab = nil

        local BODY_Y = HDR_H + TAB_BAR_H + 2
        local BODY_H = H - BODY_Y

        local tabBar = Instance.new("ScrollingFrame", St.mainFrame)
        tabBar.Name = "TabBar"
        tabBar.Position = UDim2.new(0, 6, 0, HDR_H + 2)
        tabBar.Size = UDim2.new(1, -12, 0, TAB_BAR_H)
        tabBar.BackgroundTransparency = 1; tabBar.BorderSizePixel = 0
        tabBar.ScrollBarThickness = 0; tabBar.ScrollingDirection = Enum.ScrollingDirection.X
        tabBar.CanvasSize = UDim2.new(0,0,0,0); tabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
        tabBar.ElasticBehavior = Enum.ElasticBehavior.Never; tabBar.ZIndex = 6

        local tabLayout = Instance.new("UIListLayout", tabBar)
        tabLayout.FillDirection = Enum.FillDirection.Horizontal
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.Padding = UDim.new(0, 2)
        tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        local tabPad = Instance.new("UIPadding", tabBar)
        tabPad.PaddingLeft = UDim.new(0, 6); tabPad.PaddingRight = UDim.new(0, 6)
        tabPad.PaddingTop = UDim.new(0, 5); tabPad.PaddingBottom = UDim.new(0, 5)

        -- Separatore sotto la tab bar
        local topSep = Instance.new("Frame", St.mainFrame)
        topSep.Size = UDim2.new(1, -14, 0, 1)
        topSep.Position = UDim2.new(0, 7, 0, HDR_H + TAB_BAR_H + 2)
        topSep.BackgroundColor3 = PINK; topSep.BackgroundTransparency = 0.45
        topSep.BorderSizePixel = 0; topSep.ZIndex = 6
        Instance.new("UICorner", topSep).CornerRadius = UDim.new(1, 0)

        -- Content area
        local contentArea = Instance.new("Frame", St.mainFrame)
        contentArea.Name = "ContentArea"
        contentArea.Size = UDim2.new(1, 0, 0, BODY_H)
        contentArea.Position = UDim2.fromOffset(0, BODY_Y)
        contentArea.BackgroundTransparency = 1; contentArea.BorderSizePixel = 0
        contentArea.ZIndex = 5; contentArea.ClipsDescendants = true

        for _, name in ipairs(TABS) do
            local wrapper = Instance.new("Frame", contentArea)
            wrapper.Name = "Page_"..name.."_Wrapper"
            wrapper.Size = UDim2.new(1,0,1,0); wrapper.Position = UDim2.new(10,0,0,0)
            wrapper.BackgroundTransparency = 1; wrapper.BorderSizePixel = 0
            wrapper.Visible = false; wrapper.Active = false; wrapper.ZIndex = 5; wrapper.ClipsDescendants = true
            local sf = Instance.new("ScrollingFrame", wrapper)
            sf.Name = "Page_"..name
            sf.Size = UDim2.new(1,0,1,0); sf.BackgroundTransparency = 1; sf.BorderSizePixel = 0
            sf.ScrollBarThickness = 2; sf.ScrollBarImageColor3 = PINK3
            sf.CanvasSize = UDim2.new(0,0,0,0); sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
            sf.ScrollingDirection = Enum.ScrollingDirection.Y; sf.ZIndex = 5
            local ll = Instance.new("UIListLayout", sf); ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Padding = UDim.new(0, 3)
            local pd = Instance.new("UIPadding", sf)
            pd.PaddingLeft = UDim.new(0,10); pd.PaddingRight = UDim.new(0,10)
            pd.PaddingTop = UDim.new(0,8); pd.PaddingBottom = UDim.new(0,8)
            tabWrappers[name] = wrapper; tabPages[name] = sf
        end

        local function switchTab(name, force)
            if activeTab == name and not force then return end
            for _, n in ipairs(TABS) do
                local w = tabWrappers[n]; if w then w.Visible=false; w.Active=false; w.Position=UDim2.new(10,0,0,0) end
            end
            local newPg = tabWrappers[name]; if newPg then newPg.Active=true; newPg.Visible=true; newPg.Position=UDim2.new(0,0,0,0) end
            local sfp = tabPages[name]; if sfp then sfp.CanvasPosition = Vector2.zero end
            for _, n in ipairs(TABS) do
                local bd = tabBtnRefs[n]
                if bd then
                    local isActive = (n == name)
                    TweenService:Create(bd.stroke, TweenInfo.new(0.15), {Transparency = isActive and 0 or 1}):Play()
                    if bd.indicator then
                        TweenService:Create(bd.indicator, TweenInfo.new(0.15), {BackgroundTransparency = isActive and 0 or 1}):Play()
                    end
                    bd.lbl.TextColor3 = isActive and guiAccentColor or TAB_INACT  -- ← testo tab attivo = colore accent
                    bd.lbl.Font = isActive and Enum.Font.GothamBlack or Enum.Font.GothamBold
                end
            end
            activeTab = name
        end

        for idx, name in ipairs(TABS) do
            local wrapper = Instance.new("Frame", tabBar)
            wrapper.Size = UDim2.fromOffset(0, 36)
            wrapper.AutomaticSize = Enum.AutomaticSize.X
            wrapper.BackgroundTransparency = 1; wrapper.LayoutOrder = idx

            local fill = Instance.new("Frame", wrapper)
            fill.Size = UDim2.fromOffset(0, 28)
            fill.AutomaticSize = Enum.AutomaticSize.X
            fill.Position = UDim2.fromOffset(0, 4)
            fill.BackgroundColor3 = Color3.fromRGB(24, 18, 20)
            fill.BackgroundTransparency = 1; fill.BorderSizePixel = 0; fill.ZIndex = 7
            local st = Instance.new("UIStroke", fill); st.Color = guiAccentColor; st.Thickness = 1; st.Transparency = 1
            Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 8)
            table.insert(_themeRefs.tabStrokes, st)

            -- Indicatore sotto il tab attivo (linea accent)
            local indicator = Instance.new("Frame", wrapper)
            indicator.AnchorPoint = Vector2.new(0.5, 0)
            indicator.Position = UDim2.new(0.5, 0, 0, 0)
            indicator.Size = UDim2.new(0.7, 0, 0, 2.5)
            indicator.BackgroundColor3 = guiAccentColor; indicator.BackgroundTransparency = 1
            indicator.BorderSizePixel = 0; indicator.ZIndex = 8
            Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

            local btn = Instance.new("TextButton", fill)
            btn.Size = UDim2.fromOffset(0, 28); btn.AutomaticSize = Enum.AutomaticSize.X
            btn.BackgroundTransparency = 1; btn.BorderSizePixel = 0
            btn.Text = TAB_DISPLAY[name] or name; btn.TextColor3 = TAB_INACT
            btn.Font = Enum.Font.GothamBold; btn.TextSize = isMobile and 10 or 11
            btn.AutoButtonColor = false; btn.ZIndex = 8
            local btnPad = Instance.new("UIPadding", btn)
            btnPad.PaddingLeft = UDim.new(0, 8); btnPad.PaddingRight = UDim.new(0, 8)

            tabBtnRefs[name] = {btn=btn, fill=fill, stroke=st, lbl=btn, indicator=indicator}
            table.insert(_themeRefs.tabIndicators, indicator)
            btn.MouseButton1Click:Connect(function() switchTab(name) end)
        end

        -- Close / mini button
        local miniBtn = Instance.new("TextButton", gui)
        miniBtn.Size = UDim2.new(0,100,0,26); miniBtn.Position = UDim2.new(0,20,0,20)
        miniBtn.BackgroundColor3 = guiAccentColor; miniBtn.BorderSizePixel = 0
        miniBtn.Text = "MANUXS"; miniBtn.TextColor3 = WHITE
        miniBtn.Font = Enum.Font.GothamBlack; miniBtn.TextSize = 11; miniBtn.ZIndex = 20; miniBtn.Visible = false
        Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0,10)
        Instance.new("UIStroke", miniBtn).Color = guiAccentColor
        dragHandle(miniBtn)
        closeBtn.MouseButton1Click:Connect(function()
            TweenService:Create(St.mainFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size=UDim2.new(0,0,0,0), BackgroundTransparency=1}):Play()
            task.delay(0.2, function() St.mainFrame.Visible=false; St.mainFrame.Size=UDim2.new(0,W,0,H); St.mainFrame.BackgroundTransparency=St.guiTransparencyEnabled and 0.72 or 0.62 end)
            miniBtn.Visible=true; miniBtn.Size=UDim2.new(0,0,0,26)
            TweenService:Create(miniBtn, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size=UDim2.new(0,100,0,26)}):Play()
        end)
        miniBtn.MouseButton1Click:Connect(function()
            miniBtn.Visible=false; St.mainFrame.Size=UDim2.new(0,0,0,0); St.mainFrame.BackgroundTransparency=1; St.mainFrame.Visible=true
            TweenService:Create(St.mainFrame, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size=UDim2.new(0,W,0,H), BackgroundTransparency=St.guiTransparencyEnabled and 0.72 or 0.62}):Play()
        end)

        switchTab(TABS[1])

        -- ── applyAccentColor (Layout 1) ──────────────────────
        local function applyAccentColor(newAccent)
            if typeof(newAccent) ~= "Color3" then return end
            guiAccentColor = newAccent; PINK = newAccent; PINK2 = _darken(PINK,0.55); PINK3 = _darken(PINK,0.28)
            titleLbl.TextColor3 = guiAccentColor
            titleStroke.Color   = guiAccentColor
            if miniBtn and miniBtn.Parent then miniBtn.BackgroundColor3 = guiAccentColor end
            for _,sf in pairs(tabPages) do if sf and sf.Parent then sf.ScrollBarImageColor3=PINK3 end end
            for _,ind in ipairs(_themeRefs.tabIndicators) do if ind and ind.Parent then ind.BackgroundColor3=guiAccentColor end end
            for _,ts in ipairs(_themeRefs.tabStrokes) do if ts and ts.Parent then ts.Color=guiAccentColor end end
            -- aggiorna i testi del tab attivo
            if activeTab then switchTab(activeTab, true) end
            for _,ref in ipairs(_themeRefs.toggleRefs) do
                if ref.pill and ref.pill.Parent and ref.on then ref.pill.BackgroundColor3=guiAccentColor end
            end
            pcall(M.createStealBar)
            pcall(M.buildMobileButtons)
            refreshThemeRegistries(newAccent)
        end
        -- Esponi applyAccentColor per le color swatch nel tab Settings
        M._applyAccentColor = applyAccentColor

        -- ── Costruisci il contenuto dei tab (identico a tutti i layout) ──────
        -- (richiama le stesse funzioni helper mkRow/mkToggle/mkSection del tuo script)
        _buildTabContent(tabPages, _themeRefs, PINK, PINK2, PINK3, WHITE, GRAY, isMobile)

    -- ============================================================
    -- LAYOUT 2: TAB in BASSO – titolo GRANDE in alto
    -- ============================================================
    elseif GUI_LAYOUT == 2 then

        local HDR_H     = 110  -- header alto per il titolo grande
        local TAB_BAR_H = 48

        -- ── Header con titolo GRANDE ─────────────────────────
        local header = Instance.new("Frame", St.mainFrame)
        header.Size = UDim2.new(1, 0, 0, HDR_H)
        header.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
        header.BackgroundTransparency = 0.1
        header.Active = true; header.BorderSizePixel = 0; header.ZIndex = 6
        Instance.new("UICorner", header).CornerRadius = UDim.new(0, 22)
        dragHandle(header); dragHandle(St.mainFrame)

        -- Pulsante T (cambia layout), L (lock) e – (chiudi)
        local layoutBtn = Instance.new("TextButton", header)
        layoutBtn.Size = UDim2.new(0, 26, 0, 20); layoutBtn.Position = UDim2.new(1, -92, 0, 6)
        layoutBtn.BackgroundColor3 = Color3.fromRGB(24, 18, 20); layoutBtn.BorderSizePixel = 0
        layoutBtn.Text = "T"; layoutBtn.TextColor3 = WHITE; layoutBtn.Font = Enum.Font.GothamBlack
        layoutBtn.TextSize = 10; layoutBtn.AutoButtonColor = false; layoutBtn.ZIndex = 10
        Instance.new("UICorner", layoutBtn).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", layoutBtn).Color = Color3.fromRGB(50, 35, 38)
        layoutBtn.Visible = false
        layoutBtn.Active = false

        local lockBtn = Instance.new("TextButton", header)
        lockBtn.Size = UDim2.new(0, 26, 0, 20); lockBtn.Position = UDim2.new(1, -62, 0, 6)
        lockBtn.BackgroundColor3 = Color3.fromRGB(24, 18, 20); lockBtn.BorderSizePixel = 0
        lockBtn.Text = "L"; lockBtn.TextColor3 = WHITE; lockBtn.Font = Enum.Font.GothamBlack
        lockBtn.TextSize = 10; lockBtn.AutoButtonColor = false; lockBtn.ZIndex = 10
        Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0, 8)
        local lockStroke2 = Instance.new("UIStroke", lockBtn)
        lockStroke2.Color = Color3.fromRGB(50, 35, 38); lockStroke2.Thickness = 1
        lockBtn.Activated:Connect(function()
            St.uiLocked = not St.uiLocked
            lockBtn.BackgroundColor3 = St.uiLocked and Color3.fromRGB(60,20,24) or Color3.fromRGB(24,18,20)
            lockBtn.TextColor3 = St.uiLocked and PINK or WHITE
            lockStroke2.Color = St.uiLocked and PINK or Color3.fromRGB(50,35,38)
            St.saveConfig()
        end)
        local titleBg = Instance.new("Frame", header)
        titleBg.Size = UDim2.new(1, 0, 1, 0)
        titleBg.BackgroundColor3 = Color3.fromRGB(6, 4, 6)
        titleBg.BackgroundTransparency = 0; titleBg.BorderSizePixel = 0; titleBg.ZIndex = 6
        Instance.new("UICorner", titleBg).CornerRadius = UDim.new(0, 22)
        local titleBgGrad = Instance.new("UIGradient", titleBg)
        titleBgGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 18, 24)),
            ColorSequenceKeypoint.new(0.4, Color3.fromRGB(10, 8, 14)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 10, 16)),
        })
        titleBgGrad.Rotation = 135

        -- Titolo GRANDE – colore = guiAccentColor (come richiesto)
        local bigTitle = Instance.new("TextLabel", header)
        bigTitle.Size = UDim2.new(1, -80, 1, -10)
        bigTitle.Position = UDim2.new(0, 12, 0, 5)
        bigTitle.BackgroundTransparency = 1
        bigTitle.Text = "MANUXS"
        bigTitle.TextColor3 = guiAccentColor   -- ← colore accent
        bigTitle.Font = Enum.Font.GothamBlack
        bigTitle.TextSize = isMobile and 54 or 62
        bigTitle.TextXAlignment = Enum.TextXAlignment.Left
        bigTitle.TextYAlignment = Enum.TextYAlignment.Center
        bigTitle.ZIndex = 8
        -- Stroke drammatico per l'effetto bold
        local bigStroke = Instance.new("UIStroke", bigTitle)
        bigStroke.Color = Color3.new(
            math.clamp(guiAccentColor.R * 0.25, 0, 1),
            math.clamp(guiAccentColor.G * 0.25, 0, 1),
            math.clamp(guiAccentColor.B * 0.25, 0, 1)
        )
        bigStroke.Thickness = 4; bigStroke.Transparency = 0.2

        -- Aggiorno il colore del bigStroke al cambio accent
        local function updateBigTitleColor(accent)
            bigTitle.TextColor3 = accent
            bigStroke.Color = Color3.new(
                math.clamp(accent.R * 0.25, 0, 1),
                math.clamp(accent.G * 0.25, 0, 1),
                math.clamp(accent.B * 0.25, 0, 1)
            )
        end

        -- FPS/Ping in alto a destra
        local discSmall = Instance.new("TextLabel", header)
        discSmall.Size = UDim2.new(0, 80, 0, 18); discSmall.Position = UDim2.new(1, -84, 0, 30)
        discSmall.BackgroundTransparency = 1; discSmall.Text = ""
        discSmall.TextColor3 = Color3.fromRGB(110,110,118); discSmall.Font = Enum.Font.Gotham
        discSmall.TextSize = 8; discSmall.TextXAlignment = Enum.TextXAlignment.Right; discSmall.ZIndex = 9
        bindStatsLabel(discSmall, false)

        -- Pulsante miniaturizza (stile IMG_3113: "O" piccolo)
        local miniOpenBtn = Instance.new("TextButton", header)
        miniOpenBtn.Size = UDim2.new(0, 26, 0, 26); miniOpenBtn.Position = UDim2.new(1, -32, 0, 8)
        miniOpenBtn.BackgroundColor3 = Color3.fromRGB(24,18,20); miniOpenBtn.BorderSizePixel = 0
        miniOpenBtn.Text = "−"; miniOpenBtn.TextColor3 = WHITE; miniOpenBtn.Font = Enum.Font.GothamBold
        miniOpenBtn.TextSize = 14; miniOpenBtn.AutoButtonColor = false; miniOpenBtn.ZIndex = 10
        Instance.new("UICorner", miniOpenBtn).CornerRadius = UDim.new(0, 9)
        Instance.new("UIStroke", miniOpenBtn).Color = Color3.fromRGB(50,35,38)

        -- ── TAB BAR in BASSO ─────────────────────────────────
        local TABS        = {"Speed","Mechanics","Keybinds","Utils","Settings"}
        local TAB_DISPLAY = {Speed="MOVE", Mechanics="COMBAT", Keybinds="KEYS", Utils="UTIL", Settings="SET"}
        local tabPages = {}; local tabWrappers = {}; local tabBtnRefs = {}; local activeTab = nil

        local BODY_Y = HDR_H + 2
        local BODY_H = H - BODY_Y - TAB_BAR_H

        local contentArea = Instance.new("Frame", St.mainFrame)
        contentArea.Name = "ContentArea"
        contentArea.Size = UDim2.new(1, 0, 0, BODY_H)
        contentArea.Position = UDim2.fromOffset(0, BODY_Y)
        contentArea.BackgroundTransparency = 1; contentArea.BorderSizePixel = 0
        contentArea.ZIndex = 5; contentArea.ClipsDescendants = true

        -- Separatore sopra la tab bar
        local bottomSep = Instance.new("Frame", St.mainFrame)
        bottomSep.Size = UDim2.new(1, -14, 0, 1)
        bottomSep.Position = UDim2.new(0, 7, 1, -(TAB_BAR_H + 1))
        bottomSep.BackgroundColor3 = guiAccentColor; bottomSep.BackgroundTransparency = 0.4
        bottomSep.BorderSizePixel = 0; bottomSep.ZIndex = 6
        Instance.new("UICorner", bottomSep).CornerRadius = UDim.new(1, 0)

        -- Tab bar in basso
        local tabBar = Instance.new("ScrollingFrame", St.mainFrame)
        tabBar.Name = "TabBar"
        tabBar.Position = UDim2.new(0, 8, 1, -(TAB_BAR_H - 3))
        tabBar.Size = UDim2.new(1, -16, 0, TAB_BAR_H - 6)
        tabBar.BackgroundTransparency = 1; tabBar.BorderSizePixel = 0
        tabBar.ScrollBarThickness = 0; tabBar.ScrollingDirection = Enum.ScrollingDirection.X
        tabBar.CanvasSize = UDim2.new(0,0,0,0); tabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
        tabBar.ElasticBehavior = Enum.ElasticBehavior.Never; tabBar.ZIndex = 6

        local tabLayout = Instance.new("UIListLayout", tabBar)
        tabLayout.FillDirection = Enum.FillDirection.Horizontal
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.Padding = UDim.new(0, 2)
        tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        local tabPad = Instance.new("UIPadding", tabBar)
        tabPad.PaddingLeft = UDim.new(0, 6); tabPad.PaddingRight = UDim.new(0, 6)
        tabPad.PaddingTop = UDim.new(0, 5); tabPad.PaddingBottom = UDim.new(0, 5)

        for _, name in ipairs(TABS) do
            local wrapper = Instance.new("Frame", contentArea)
            wrapper.Name = "Page_"..name.."_Wrapper"
            wrapper.Size = UDim2.new(1,0,1,0); wrapper.Position = UDim2.new(10,0,0,0)
            wrapper.BackgroundTransparency = 1; wrapper.BorderSizePixel = 0
            wrapper.Visible = false; wrapper.Active = false; wrapper.ZIndex = 5; wrapper.ClipsDescendants = true
            local sf = Instance.new("ScrollingFrame", wrapper)
            sf.Name = "Page_"..name
            sf.Size = UDim2.new(1,0,1,0); sf.BackgroundTransparency = 1; sf.BorderSizePixel = 0
            sf.ScrollBarThickness = 2; sf.ScrollBarImageColor3 = PINK3
            sf.CanvasSize = UDim2.new(0,0,0,0); sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
            sf.ScrollingDirection = Enum.ScrollingDirection.Y; sf.ZIndex = 5
            local ll = Instance.new("UIListLayout", sf); ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Padding = UDim.new(0, 3)
            local pd = Instance.new("UIPadding", sf)
            pd.PaddingLeft = UDim.new(0,10); pd.PaddingRight = UDim.new(0,10)
            pd.PaddingTop = UDim.new(0,8); pd.PaddingBottom = UDim.new(0,8)
            tabWrappers[name] = wrapper; tabPages[name] = sf
        end

        local function switchTab(name, force)
            if activeTab == name and not force then return end
            for _, n in ipairs(TABS) do
                local w = tabWrappers[n]; if w then w.Visible=false; w.Active=false; w.Position=UDim2.new(10,0,0,0) end
            end
            local newPg = tabWrappers[name]; if newPg then newPg.Active=true; newPg.Visible=true; newPg.Position=UDim2.new(0,0,0,0) end
            local sfp = tabPages[name]; if sfp then sfp.CanvasPosition = Vector2.zero end
            for _, n in ipairs(TABS) do
                local bd = tabBtnRefs[n]
                if bd then
                    local isActive = (n == name)
                    TweenService:Create(bd.stroke, TweenInfo.new(0.18), {Transparency = isActive and 0 or 1}):Play()
                    if bd.indicator then
                        TweenService:Create(bd.indicator, TweenInfo.new(0.18), {BackgroundTransparency = isActive and 0 or 1}):Play()
                    end
                    bd.lbl.TextColor3 = isActive and WHITE or TAB_INACT
                    bd.lbl.Font = isActive and Enum.Font.GothamBlack or Enum.Font.GothamBold
                end
            end
            activeTab = name
        end

        for idx, name in ipairs(TABS) do
            local wrapper = Instance.new("Frame", tabBar)
            wrapper.Size = UDim2.fromOffset(0, 40)
            wrapper.AutomaticSize = Enum.AutomaticSize.X
            wrapper.BackgroundTransparency = 1; wrapper.LayoutOrder = idx

            local fill = Instance.new("Frame", wrapper)
            fill.Size = UDim2.fromOffset(0, 30)
            fill.AutomaticSize = Enum.AutomaticSize.X
            fill.Position = UDim2.fromOffset(0, 2)
            fill.BackgroundColor3 = Color3.fromRGB(24, 18, 20)
            fill.BackgroundTransparency = 1; fill.BorderSizePixel = 0; fill.ZIndex = 7
            Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 8)
            local st = Instance.new("UIStroke", fill); st.Color = guiAccentColor; st.Thickness = 1; st.Transparency = 1
            table.insert(_themeRefs.tabStrokes, st)

            local indicator = Instance.new("Frame", wrapper)
            indicator.AnchorPoint = Vector2.new(0.5, 1)
            indicator.Position = UDim2.new(0.5, 0, 1, 0)
            indicator.Size = UDim2.new(0.6, 0, 0, 2.5)
            indicator.BackgroundColor3 = guiAccentColor; indicator.BackgroundTransparency = 1
            indicator.BorderSizePixel = 0; indicator.ZIndex = 8
            Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

            local btn = Instance.new("TextButton", fill)
            btn.Size = UDim2.fromOffset(0, 30); btn.AutomaticSize = Enum.AutomaticSize.X
            btn.BackgroundTransparency = 1; btn.BorderSizePixel = 0
            btn.Text = TAB_DISPLAY[name] or name; btn.TextColor3 = TAB_INACT
            btn.Font = Enum.Font.GothamBold; btn.TextSize = isMobile and 11 or 12
            btn.AutoButtonColor = false; btn.ZIndex = 8
            local btnPad = Instance.new("UIPadding", btn)
            btnPad.PaddingLeft = UDim.new(0,8); btnPad.PaddingRight = UDim.new(0,8)

            tabBtnRefs[name] = {btn=btn, fill=fill, stroke=st, lbl=btn, indicator=indicator}
            table.insert(_themeRefs.tabIndicators, indicator)
            btn.MouseButton1Click:Connect(function() switchTab(name) end)
        end

        -- Mini button
        local miniBtn = Instance.new("TextButton", gui)
        miniBtn.Size = UDim2.new(0,100,0,28); miniBtn.Position = UDim2.new(0,20,0,20)
        miniBtn.BackgroundColor3 = guiAccentColor; miniBtn.BorderSizePixel = 0
        miniBtn.Text = "MANUXS"; miniBtn.TextColor3 = WHITE
        miniBtn.Font = Enum.Font.GothamBlack; miniBtn.TextSize = 11; miniBtn.ZIndex = 20; miniBtn.Visible = false
        Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0,10)
        Instance.new("UIStroke", miniBtn).Color = guiAccentColor
        dragHandle(miniBtn)
        miniOpenBtn.MouseButton1Click:Connect(function()
            TweenService:Create(St.mainFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size=UDim2.new(0,0,0,0), BackgroundTransparency=1}):Play()
            task.delay(0.2, function() St.mainFrame.Visible=false; St.mainFrame.Size=UDim2.new(0,W,0,H); St.mainFrame.BackgroundTransparency=St.guiTransparencyEnabled and 0.72 or 0.62 end)
            miniBtn.Visible=true; miniBtn.Size=UDim2.new(0,0,0,28)
            TweenService:Create(miniBtn, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size=UDim2.new(0,100,0,28)}):Play()
        end)
        miniBtn.MouseButton1Click:Connect(function()
            miniBtn.Visible=false; St.mainFrame.Size=UDim2.new(0,0,0,0); St.mainFrame.BackgroundTransparency=1; St.mainFrame.Visible=true
            TweenService:Create(St.mainFrame, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size=UDim2.new(0,W,0,H), BackgroundTransparency=St.guiTransparencyEnabled and 0.72 or 0.62}):Play()
        end)

        switchTab(TABS[1])

        -- applyAccentColor Layout 2
        local function applyAccentColor(newAccent)
            if typeof(newAccent) ~= "Color3" then return end
            guiAccentColor = newAccent; PINK = newAccent; PINK2 = _darken(PINK,0.55); PINK3 = _darken(PINK,0.28)
            updateBigTitleColor(newAccent)
            bottomSep.BackgroundColor3 = newAccent
            if miniBtn and miniBtn.Parent then miniBtn.BackgroundColor3 = newAccent end
            for _,sf in pairs(tabPages) do if sf and sf.Parent then sf.ScrollBarImageColor3=PINK3 end end
            for _,ind in ipairs(_themeRefs.tabIndicators) do if ind and ind.Parent then ind.BackgroundColor3=newAccent end end
            for _,ts in ipairs(_themeRefs.tabStrokes) do if ts and ts.Parent then ts.Color=newAccent end end
            if activeTab then switchTab(activeTab, true) end
            for _,ref in ipairs(_themeRefs.toggleRefs) do
                if ref.pill and ref.pill.Parent and ref.on then ref.pill.BackgroundColor3=newAccent end
            end
            pcall(M.createStealBar)
            pcall(M.buildMobileButtons)
            refreshThemeRegistries(newAccent)
        end
        M._applyAccentColor = applyAccentColor

        _buildTabContent(tabPages, _themeRefs, PINK, PINK2, PINK3, WHITE, GRAY, isMobile)

    -- ============================================================
    -- LAYOUT 3: TAB a DESTRA – pannello "Welcome" al centro
    -- ============================================================
    elseif GUI_LAYOUT == 3 then

        local SIDEBAR_W = 90   -- larghezza colonna tab destra
        local CENTER_W  = W - SIDEBAR_W

        -- ── Frame principale ─────────────────────────────────
        dragHandle(St.mainFrame)

        -- ── SIDEBAR DESTRA con i tab verticali ───────────────
        local sidebar = Instance.new("Frame", St.mainFrame)
        sidebar.Name = "Sidebar"
        sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, 0)
        sidebar.Position = UDim2.new(1, -SIDEBAR_W, 0, 0)
        sidebar.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
        sidebar.BackgroundTransparency = 0.1; sidebar.BorderSizePixel = 0; sidebar.ZIndex = 6
        Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 22)

        -- Divisore verticale tra contenuto e sidebar
        local vDivider = Instance.new("Frame", St.mainFrame)
        vDivider.Size = UDim2.new(0, 1, 1, -20)
        vDivider.Position = UDim2.new(1, -SIDEBAR_W - 1, 0, 10)
        vDivider.BackgroundColor3 = guiAccentColor; vDivider.BackgroundTransparency = 0.5
        vDivider.BorderSizePixel = 0; vDivider.ZIndex = 6

        -- ── Cerchio profilo nella sidebar ─────────────────────
        -- Bordo colorato (guiAccentColor) + immagine del profilo Roblox
        local profileRing = Instance.new("Frame", sidebar)
        profileRing.Size = UDim2.new(0, 62, 0, 62)
        profileRing.AnchorPoint = Vector2.new(0.5, 0)
        profileRing.Position = UDim2.new(0.5, 0, 0, 20)
        profileRing.BackgroundColor3 = guiAccentColor   -- ← anello colore accent
        profileRing.BorderSizePixel = 0; profileRing.ZIndex = 7
        Instance.new("UICorner", profileRing).CornerRadius = UDim.new(1, 0)

        local profileImg = Instance.new("ImageLabel", profileRing)
        profileImg.Size = UDim2.new(1, -6, 1, -6)
        profileImg.AnchorPoint = Vector2.new(0.5, 0.5); profileImg.Position = UDim2.new(0.5, 0, 0.5, 0)
        profileImg.BackgroundColor3 = Color3.fromRGB(20, 20, 24); profileImg.BorderSizePixel = 0; profileImg.ZIndex = 8
        profileImg.Image = "rbxthumb://type=AvatarHeadShot&id="..tostring(LP.UserId).."&w=150&h=150"
        Instance.new("UICorner", profileImg).CornerRadius = UDim.new(1, 0)

        -- Pulsante chiudi (−) in alto nella sidebar
        local closeBtn = Instance.new("TextButton", sidebar)
        closeBtn.Size = UDim2.new(0, 26, 0, 26); closeBtn.Position = UDim2.new(1, -32, 0, 8)
        closeBtn.BackgroundColor3 = Color3.fromRGB(24,18,20); closeBtn.BorderSizePixel = 0
        closeBtn.Text = "−"; closeBtn.TextColor3 = WHITE; closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 14; closeBtn.AutoButtonColor = false; closeBtn.ZIndex = 10
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 9)
        Instance.new("UIStroke", closeBtn).Color = Color3.fromRGB(50,35,38)

        -- Pulsante T (cambia layout) sotto al pulsante chiudi
        local layoutBtn = Instance.new("TextButton", sidebar)
        layoutBtn.Size = UDim2.new(0, 26, 0, 22); layoutBtn.Position = UDim2.new(1, -32, 0, 38)
        layoutBtn.BackgroundColor3 = Color3.fromRGB(24, 18, 20); layoutBtn.BorderSizePixel = 0
        layoutBtn.Text = "T"; layoutBtn.TextColor3 = WHITE; layoutBtn.Font = Enum.Font.GothamBlack
        layoutBtn.TextSize = 10; layoutBtn.AutoButtonColor = false; layoutBtn.ZIndex = 10
        Instance.new("UICorner", layoutBtn).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", layoutBtn).Color = Color3.fromRGB(50, 35, 38)
        layoutBtn.Visible = false
        layoutBtn.Active = false

        -- Pulsante L (lock) sotto al pulsante T
        local lockBtn = Instance.new("TextButton", sidebar)
        lockBtn.Size = UDim2.new(0, 26, 0, 22); lockBtn.Position = UDim2.new(1, -32, 0, 68)
        lockBtn.BackgroundColor3 = Color3.fromRGB(24, 18, 20); lockBtn.BorderSizePixel = 0
        lockBtn.Text = "L"; lockBtn.TextColor3 = WHITE; lockBtn.Font = Enum.Font.GothamBlack
        lockBtn.TextSize = 10; lockBtn.AutoButtonColor = false; lockBtn.ZIndex = 10
        Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0, 8)
        local lockStroke3 = Instance.new("UIStroke", lockBtn)
        lockStroke3.Color = Color3.fromRGB(50, 35, 38); lockStroke3.Thickness = 1
        lockBtn.Activated:Connect(function()
            St.uiLocked = not St.uiLocked
            lockBtn.BackgroundColor3 = St.uiLocked and Color3.fromRGB(60,20,24) or Color3.fromRGB(24,18,20)
            lockBtn.TextColor3 = St.uiLocked and PINK or WHITE
            lockStroke3.Color = St.uiLocked and PINK or Color3.fromRGB(50,35,38)
            St.saveConfig()
        end)

        -- ── Tab verticali nella sidebar ───────────────────────
        local TABS        = {"Speed","Mechanics","Keybinds","Utils","Settings"}
        local TAB_DISPLAY = {Speed="SPEED", Mechanics="COMBAT", Keybinds="KEYS", Utils="VISUAL", Settings="MISC"}
        local tabPages = {}; local tabWrappers = {}; local tabBtnRefs = {}; local activeTab = nil

        local tabList = Instance.new("Frame", sidebar)
        tabList.Name = "TabList"
        tabList.Size = UDim2.new(1, -8, 0, 0)
        tabList.AutomaticSize = Enum.AutomaticSize.Y
        tabList.AnchorPoint = Vector2.new(0.5, 0)
        tabList.Position = UDim2.new(0.5, 0, 0, 95)
        tabList.BackgroundTransparency = 1; tabList.BorderSizePixel = 0; tabList.ZIndex = 6
        local tabListLayout = Instance.new("UIListLayout", tabList)
        tabListLayout.FillDirection = Enum.FillDirection.Vertical
        tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabListLayout.Padding = UDim.new(0, 4)
        tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        -- FPS/Ping in basso nella sidebar
        local discSmall = Instance.new("TextLabel", sidebar)
        discSmall.Size = UDim2.new(1, -8, 0, 18); discSmall.AnchorPoint = Vector2.new(0.5, 1)
        discSmall.Position = UDim2.new(0.5, 0, 1, -8)
        discSmall.BackgroundTransparency = 1; discSmall.Text = ""
        discSmall.TextColor3 = Color3.fromRGB(90,90,100); discSmall.Font = Enum.Font.Gotham
        discSmall.TextSize = 7; discSmall.TextXAlignment = Enum.TextXAlignment.Center; discSmall.ZIndex = 8
        task.spawn(function()
            local frames=0; local t0=tick()
            while discSmall and discSmall.Parent do
                frames=frames+1; local now=tick()
                if now-t0>=0.5 then
                    local fps=math.floor(frames/(now-t0)+0.5)
                    local ok,ms=pcall(function() return LP:GetNetworkPing()*1000 end)
                    discSmall.Text=string.format("FPS %s\n%sms", fps, ok and math.floor(ms+0.5) or "--")
                    frames=0; t0=now
                end
                task.wait()
            end
        end)

        -- ── Area contenuto (sinistra/centro) ─────────────────
        local contentArea = Instance.new("Frame", St.mainFrame)
        contentArea.Name = "ContentArea"
        contentArea.Size = UDim2.new(1, -SIDEBAR_W, 1, 0)
        contentArea.Position = UDim2.new(0, 0, 0, 0)
        contentArea.BackgroundTransparency = 1; contentArea.BorderSizePixel = 0
        contentArea.ZIndex = 5; contentArea.ClipsDescendants = true

        -- ── Pannello "Welcome" nella schermata principale ─────
        -- Visibile solo quando NON è selezionato nessun tab di contenuto
        local welcomePanel = Instance.new("Frame", contentArea)
        welcomePanel.Name = "WelcomePanel"
        welcomePanel.Size = UDim2.new(1, 0, 1, 0)
        welcomePanel.BackgroundTransparency = 1; welcomePanel.BorderSizePixel = 0; welcomePanel.ZIndex = 5
        welcomePanel.Visible = true

        -- "Welcome to" + username centrato verticalmente
        local welcomeTitle = Instance.new("TextLabel", welcomePanel)
        welcomeTitle.Size = UDim2.new(1, -20, 0, 22)
        welcomeTitle.AnchorPoint = Vector2.new(0.5, 0.5)
        welcomeTitle.Position = UDim2.new(0.5, 0, 0.45, 0)
        welcomeTitle.BackgroundTransparency = 1
        welcomeTitle.Text = "welcome to"
        welcomeTitle.TextColor3 = Color3.fromRGB(180, 175, 185)
        welcomeTitle.Font = Enum.Font.GothamBold
        welcomeTitle.TextSize = isMobile and 13 or 15
        welcomeTitle.TextXAlignment = Enum.TextXAlignment.Center; welcomeTitle.ZIndex = 8

        local welcomeUser = Instance.new("TextLabel", welcomePanel)
        welcomeUser.Size = UDim2.new(1, -16, 0, 28)
        welcomeUser.AnchorPoint = Vector2.new(0.5, 0.5)
        welcomeUser.Position = UDim2.new(0.5, 0, 0.55, 0)
        welcomeUser.BackgroundTransparency = 1
        welcomeUser.Text = string.upper(LP.Name)
        welcomeUser.TextColor3 = WHITE
        welcomeUser.Font = Enum.Font.GothamBlack
        welcomeUser.TextSize = isMobile and 16 or 18
        welcomeUser.TextXAlignment = Enum.TextXAlignment.Center; welcomeUser.ZIndex = 8
        -- Stroke sul nome per renderlo leggibile
        local userStroke = Instance.new("UIStroke", welcomeUser)
        userStroke.Color = guiAccentColor; userStroke.Thickness = 0.8; userStroke.Transparency = 0.4

        -- Logo / titolo ASPECT piccolo in cima all'area
        local centerTitle = Instance.new("TextLabel", welcomePanel)
        centerTitle.Size = UDim2.new(1, -20, 0, 20)
        centerTitle.AnchorPoint = Vector2.new(0.5, 0)
        centerTitle.Position = UDim2.new(0.5, 0, 0, 14)
        centerTitle.BackgroundTransparency = 1
        centerTitle.Text = "MANUXS"
        centerTitle.TextColor3 = guiAccentColor   -- ← colore accent
        centerTitle.Font = Enum.Font.GothamBlack
        centerTitle.TextSize = isMobile and 14 or 16
        centerTitle.TextXAlignment = Enum.TextXAlignment.Center; centerTitle.ZIndex = 8

        -- Pagine per ogni tab
        for _, name in ipairs(TABS) do
            local wrapper = Instance.new("Frame", contentArea)
            wrapper.Name = "Page_"..name.."_Wrapper"
            wrapper.Size = UDim2.new(1,0,1,0); wrapper.Position = UDim2.new(10,0,0,0)
            wrapper.BackgroundTransparency = 1; wrapper.BorderSizePixel = 0
            wrapper.Visible = false; wrapper.Active = false; wrapper.ZIndex = 5; wrapper.ClipsDescendants = true
            local sf = Instance.new("ScrollingFrame", wrapper)
            sf.Name = "Page_"..name
            sf.Size = UDim2.new(1,0,1,0); sf.BackgroundTransparency = 1; sf.BorderSizePixel = 0
            sf.ScrollBarThickness = 2; sf.ScrollBarImageColor3 = PINK3
            sf.CanvasSize = UDim2.new(0,0,0,0); sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
            sf.ScrollingDirection = Enum.ScrollingDirection.Y; sf.ZIndex = 5
            local ll = Instance.new("UIListLayout", sf); ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Padding = UDim.new(0, 3)
            local pd = Instance.new("UIPadding", sf)
            pd.PaddingLeft = UDim.new(0,10); pd.PaddingRight = UDim.new(0,10)
            pd.PaddingTop = UDim.new(0,8); pd.PaddingBottom = UDim.new(0,8)
            tabWrappers[name] = wrapper; tabPages[name] = sf
        end

        local function switchTab(name, force)
            if activeTab == name and not force then return end
            welcomePanel.Visible = false  -- nasconde il pannello welcome
            for _, n in ipairs(TABS) do
                local w = tabWrappers[n]; if w then w.Visible=false; w.Active=false; w.Position=UDim2.new(10,0,0,0) end
            end
            local newPg = tabWrappers[name]; if newPg then newPg.Active=true; newPg.Visible=true; newPg.Position=UDim2.new(0,0,0,0) end
            local sfp = tabPages[name]; if sfp then sfp.CanvasPosition = Vector2.zero end
            for _, n in ipairs(TABS) do
                local bd = tabBtnRefs[n]
                if bd then
                    local isActive = (n == name)
                    TweenService:Create(bd.fill, TweenInfo.new(0.15), {
                        BackgroundTransparency = isActive and 0 or 1,
                    }):Play()
                    TweenService:Create(bd.stroke, TweenInfo.new(0.15), {
                        Transparency = isActive and 0 or 1,
                    }):Play()
                    bd.lbl.TextColor3 = isActive and WHITE or TAB_INACT
                    bd.lbl.Font = isActive and Enum.Font.GothamBlack or Enum.Font.GothamBold
                end
            end
            activeTab = name
        end

        -- Costruisci i bottoni tab verticali
        for idx, name in ipairs(TABS) do
            local fill = Instance.new("Frame", tabList)
            fill.Size = UDim2.new(1, 0, 0, 36)
            fill.BackgroundColor3 = Color3.fromRGB(24, 18, 20)
            fill.BackgroundTransparency = 1; fill.BorderSizePixel = 0
            fill.LayoutOrder = idx; fill.ZIndex = 7
            Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 10)
            local st = Instance.new("UIStroke", fill); st.Color = guiAccentColor; st.Thickness = 1; st.Transparency = 1
            table.insert(_themeRefs.tabStrokes, st)

            local btn = Instance.new("TextButton", fill)
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1; btn.BorderSizePixel = 0
            btn.Text = TAB_DISPLAY[name] or name; btn.TextColor3 = TAB_INACT
            btn.Font = Enum.Font.GothamBold; btn.TextSize = isMobile and 8 or 9
            btn.AutoButtonColor = false; btn.ZIndex = 8
            btn.TextWrapped = true

            tabBtnRefs[name] = {btn=btn, fill=fill, stroke=st, lbl=btn}
            btn.MouseButton1Click:Connect(function() switchTab(name) end)
        end

        -- Mini button
        local miniBtn = Instance.new("TextButton", gui)
        miniBtn.Size = UDim2.new(0,100,0,28); miniBtn.Position = UDim2.new(0,20,0,20)
        miniBtn.BackgroundColor3 = guiAccentColor; miniBtn.BorderSizePixel = 0
        miniBtn.Text = "MANUXS"; miniBtn.TextColor3 = WHITE
        miniBtn.Font = Enum.Font.GothamBlack; miniBtn.TextSize = 11; miniBtn.ZIndex = 20; miniBtn.Visible = false
        Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0,10)
        Instance.new("UIStroke", miniBtn).Color = guiAccentColor
        dragHandle(miniBtn)
        closeBtn.MouseButton1Click:Connect(function()
            TweenService:Create(St.mainFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size=UDim2.new(0,0,0,0), BackgroundTransparency=1}):Play()
            task.delay(0.2, function() St.mainFrame.Visible=false; St.mainFrame.Size=UDim2.new(0,W,0,H); St.mainFrame.BackgroundTransparency=St.guiTransparencyEnabled and 0.72 or 0.62 end)
            miniBtn.Visible=true; miniBtn.Size=UDim2.new(0,0,0,28)
            TweenService:Create(miniBtn, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size=UDim2.new(0,100,0,28)}):Play()
        end)
        miniBtn.MouseButton1Click:Connect(function()
            miniBtn.Visible=false; St.mainFrame.Size=UDim2.new(0,0,0,0); St.mainFrame.BackgroundTransparency=1; St.mainFrame.Visible=true
            TweenService:Create(St.mainFrame, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size=UDim2.new(0,W,0,H), BackgroundTransparency=St.guiTransparencyEnabled and 0.72 or 0.62}):Play()
        end)

        -- applyAccentColor Layout 3
        local function applyAccentColor(newAccent)
            if typeof(newAccent) ~= "Color3" then return end
            guiAccentColor = newAccent; PINK = newAccent; PINK2 = _darken(PINK,0.55); PINK3 = _darken(PINK,0.28)
            profileRing.BackgroundColor3 = newAccent
            centerTitle.TextColor3 = newAccent
            userStroke.Color = newAccent
            vDivider.BackgroundColor3 = newAccent
            if miniBtn and miniBtn.Parent then miniBtn.BackgroundColor3 = newAccent end
            for _,sf in pairs(tabPages) do if sf and sf.Parent then sf.ScrollBarImageColor3=PINK3 end end
            for _,ts in ipairs(_themeRefs.tabStrokes) do if ts and ts.Parent then ts.Color=newAccent end end
            if activeTab then switchTab(activeTab, true) end
            for _,ref in ipairs(_themeRefs.toggleRefs) do
                if ref.pill and ref.pill.Parent and ref.on then ref.pill.BackgroundColor3=newAccent end
            end
            pcall(M.createStealBar)
            pcall(M.buildMobileButtons)
            refreshThemeRegistries(newAccent)
        end
        M._applyAccentColor = applyAccentColor

        _buildTabContent(tabPages, _themeRefs, PINK, PINK2, PINK3, WHITE, GRAY, isMobile)


    -- ============================================================
    -- LAYOUT 4: Stile "Soruna" – header in alto, tab verticali a destra
    -- (uguale alla screenshot fornita dall'utente)
    -- ============================================================
    elseif GUI_LAYOUT == 4 then

        local SIDEBAR_W = 76   -- larghezza sidebar destra (tab verticali)
        local HDR_H     = 38   -- header top con nome server e fps/ping
        local CENTER_W  = W - SIDEBAR_W

        dragHandle(St.mainFrame)

        -- ── SIDEBAR DESTRA con tab verticali ─────────────────
        local sidebar = Instance.new("Frame", St.mainFrame)
        sidebar.Name = "Sidebar"
        sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, 0)
        sidebar.Position = UDim2.new(1, -SIDEBAR_W, 0, 0)
        sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        sidebar.BackgroundTransparency = 0.05
        sidebar.BorderSizePixel = 0; sidebar.ZIndex = 6
        Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 20)

        -- Divisore verticale
        local vDiv = Instance.new("Frame", St.mainFrame)
        vDiv.Size = UDim2.new(0, 1, 1, -16)
        vDiv.Position = UDim2.new(1, -SIDEBAR_W - 1, 0, 8)
        vDiv.BackgroundColor3 = guiAccentColor; vDiv.BackgroundTransparency = 0.55
        vDiv.BorderSizePixel = 0; vDiv.ZIndex = 6

        -- Pulsante CLOSE in cima alla sidebar
        local closeBtnL4 = Instance.new("TextButton", sidebar)
        closeBtnL4.Size = UDim2.new(1, -10, 0, 30)
        closeBtnL4.Position = UDim2.new(0, 5, 0, 6)
        closeBtnL4.BackgroundColor3 = Color3.fromRGB(210, 35, 45)
        closeBtnL4.BackgroundTransparency = 0; closeBtnL4.BorderSizePixel = 0; closeBtnL4.ZIndex = 10
        closeBtnL4.Text = "Close"; closeBtnL4.TextColor3 = WHITE
        closeBtnL4.Font = Enum.Font.GothamBlack; closeBtnL4.TextSize = isMobile and 9 or 10
        closeBtnL4.AutoButtonColor = false
        Instance.new("UICorner", closeBtnL4).CornerRadius = UDim.new(0, 8)

        -- Pulsante T (cambia layout) sotto Close
        local layoutBtnL4 = Instance.new("TextButton", sidebar)
        layoutBtnL4.Size = UDim2.new(1, -10, 0, 22)
        layoutBtnL4.Position = UDim2.new(0, 5, 0, 40)
        layoutBtnL4.BackgroundColor3 = Color3.fromRGB(24, 18, 20); layoutBtnL4.BorderSizePixel = 0
        layoutBtnL4.Text = "T"; layoutBtnL4.TextColor3 = WHITE; layoutBtnL4.Font = Enum.Font.GothamBlack
        layoutBtnL4.TextSize = 9; layoutBtnL4.AutoButtonColor = false; layoutBtnL4.ZIndex = 10
        Instance.new("UICorner", layoutBtnL4).CornerRadius = UDim.new(0, 7)
        Instance.new("UIStroke", layoutBtnL4).Color = Color3.fromRGB(50, 35, 38)
        layoutBtnL4.Visible = false
        layoutBtnL4.Active = false

        -- Pulsante L (lock) sotto T
        local lockBtnL4 = Instance.new("TextButton", sidebar)
        lockBtnL4.Size = UDim2.new(1, -10, 0, 22)
        lockBtnL4.Position = UDim2.new(0, 5, 0, 66)
        lockBtnL4.BackgroundColor3 = Color3.fromRGB(24, 18, 20); lockBtnL4.BorderSizePixel = 0
        lockBtnL4.Text = "L"; lockBtnL4.TextColor3 = WHITE; lockBtnL4.Font = Enum.Font.GothamBlack
        lockBtnL4.TextSize = 9; lockBtnL4.AutoButtonColor = false; lockBtnL4.ZIndex = 10
        Instance.new("UICorner", lockBtnL4).CornerRadius = UDim.new(0, 7)
        local lockStL4 = Instance.new("UIStroke", lockBtnL4)
        lockStL4.Color = Color3.fromRGB(50, 35, 38); lockStL4.Thickness = 1
        lockBtnL4.Activated:Connect(function()
            St.uiLocked = not St.uiLocked
            lockBtnL4.BackgroundColor3 = St.uiLocked and Color3.fromRGB(60,20,24) or Color3.fromRGB(24,18,20)
            lockBtnL4.TextColor3 = St.uiLocked and PINK or WHITE
            lockStL4.Color = St.uiLocked and PINK or Color3.fromRGB(50,35,38)
            St.saveConfig()
        end)

        -- ── Tab verticali nella sidebar (stesso mapping di Layout 3) ─
        local TABS        = {"Speed","Mechanics","Keybinds","Utils","Settings"}
        local TAB_DISPLAY = {Speed="Speed", Mechanics="Combat", Keybinds="Move", Utils="Auto", Settings="Misc"}
        local tabPages = {}; local tabWrappers = {}; local tabBtnRefs = {}; local activeTab = nil

        local tabList = Instance.new("Frame", sidebar)
        tabList.Name = "TabList"
        tabList.Size = UDim2.new(1, -10, 0, 0)
        tabList.AutomaticSize = Enum.AutomaticSize.Y
        tabList.AnchorPoint = Vector2.new(0.5, 0)
        tabList.Position = UDim2.new(0.5, 0, 0, 96)
        tabList.BackgroundTransparency = 1; tabList.BorderSizePixel = 0; tabList.ZIndex = 6
        local tabListLayout = Instance.new("UIListLayout", tabList)
        tabListLayout.FillDirection = Enum.FillDirection.Vertical
        tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabListLayout.Padding = UDim.new(0, 3)
        tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        -- FPS/Ping in fondo alla sidebar
        local fpsPingL4 = Instance.new("TextLabel", sidebar)
        fpsPingL4.Size = UDim2.new(1, -6, 0, 22); fpsPingL4.AnchorPoint = Vector2.new(0.5, 1)
        fpsPingL4.Position = UDim2.new(0.5, 0, 1, -6)
        fpsPingL4.BackgroundTransparency = 1; fpsPingL4.Text = ""
        fpsPingL4.TextColor3 = Color3.fromRGB(110,110,120); fpsPingL4.Font = Enum.Font.Gotham
        fpsPingL4.TextSize = 7; fpsPingL4.TextXAlignment = Enum.TextXAlignment.Center
        fpsPingL4.TextWrapped = true; fpsPingL4.ZIndex = 8
        bindStatsLabel(fpsPingL4, true)

        -- ── Area contenuto (sinistra) ─────────────────────────
        local contentArea = Instance.new("Frame", St.mainFrame)
        contentArea.Name = "ContentArea"
        contentArea.Size = UDim2.new(1, -SIDEBAR_W, 1, 0)
        contentArea.Position = UDim2.new(0, 0, 0, 0)
        contentArea.BackgroundTransparency = 1; contentArea.BorderSizePixel = 0
        contentArea.ZIndex = 5; contentArea.ClipsDescendants = true

        -- ── Header info in cima all'area contenuto ────────────
        local hdrContent = Instance.new("Frame", contentArea)
        hdrContent.Size = UDim2.new(1, 0, 0, HDR_H)
        hdrContent.Position = UDim2.new(0, 0, 0, 0)
        hdrContent.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
        hdrContent.BackgroundTransparency = 0.2; hdrContent.BorderSizePixel = 0; hdrContent.ZIndex = 6
        Instance.new("UICorner", hdrContent).CornerRadius = UDim.new(0, 14)
        dragHandle(hdrContent)

        -- Nome server/gioco (es. "Soruna | Duels")
        local serverLbl = Instance.new("TextLabel", hdrContent)
        serverLbl.Size = UDim2.new(1, -8, 0, 16)
        serverLbl.Position = UDim2.new(0, 8, 0, 3)
        serverLbl.BackgroundTransparency = 1
        local ok4, placeN = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
        serverLbl.Text = (ok4 and placeN or "MANUXS HUB") .. " | " .. LP.Name
        serverLbl.TextColor3 = guiAccentColor
        serverLbl.Font = Enum.Font.GothamBlack; serverLbl.TextSize = isMobile and 9 or 10
        serverLbl.TextXAlignment = Enum.TextXAlignment.Left; serverLbl.ZIndex = 8
        serverLbl.TextTruncate = Enum.TextTruncate.AtEnd

        -- Ping/FPS nella header contenuto
        local hdrStats = Instance.new("TextLabel", hdrContent)
        hdrStats.Size = UDim2.new(1, -8, 0, 14)
        hdrStats.Position = UDim2.new(0, 8, 0, 20)
        hdrStats.BackgroundTransparency = 1; hdrStats.Text = ""
        hdrStats.TextColor3 = Color3.fromRGB(180, 75, 255)
        hdrStats.Font = Enum.Font.GothamBold; hdrStats.TextSize = isMobile and 8 or 9
        hdrStats.TextXAlignment = Enum.TextXAlignment.Left; hdrStats.ZIndex = 8
        bindStatsLabel(hdrStats, false); hdrStats:SetAttribute("HeaderStats", true)

        -- ── Pagine per ogni tab ────────────────────────────────
        for _, name in ipairs(TABS) do
            local wrapper = Instance.new("Frame", contentArea)
            wrapper.Name = "Page_"..name.."_Wrapper"
            wrapper.Size = UDim2.new(1,0,1,-HDR_H-2); wrapper.Position = UDim2.new(10,0,0,HDR_H+2)
            wrapper.BackgroundTransparency = 1; wrapper.BorderSizePixel = 0
            wrapper.Visible = false; wrapper.Active = false; wrapper.ZIndex = 5; wrapper.ClipsDescendants = true
            local sf = Instance.new("ScrollingFrame", wrapper)
            sf.Name = "Page_"..name
            sf.Size = UDim2.new(1,0,1,0); sf.BackgroundTransparency = 1; sf.BorderSizePixel = 0
            sf.ScrollBarThickness = 2; sf.ScrollBarImageColor3 = PINK3
            sf.CanvasSize = UDim2.new(0,0,0,0); sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
            sf.ScrollingDirection = Enum.ScrollingDirection.Y; sf.ZIndex = 5
            local ll = Instance.new("UIListLayout", sf); ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Padding = UDim.new(0, 3)
            local pd = Instance.new("UIPadding", sf)
            pd.PaddingLeft = UDim.new(0,10); pd.PaddingRight = UDim.new(0,10)
            pd.PaddingTop = UDim.new(0,8); pd.PaddingBottom = UDim.new(0,8)
            tabWrappers[name] = wrapper; tabPages[name] = sf
        end

        local function switchTab(name, force)
            if activeTab == name and not force then return end
            for _, n in ipairs(TABS) do
                local w = tabWrappers[n]; if w then w.Visible=false; w.Active=false; w.Position=UDim2.new(10,0,0,HDR_H+2) end
            end
            local newPg = tabWrappers[name]; if newPg then newPg.Active=true; newPg.Visible=true; newPg.Position=UDim2.new(0,0,0,HDR_H+2) end
            local sfp = tabPages[name]; if sfp then sfp.CanvasPosition = Vector2.zero end
            for _, n in ipairs(TABS) do
                local bd = tabBtnRefs[n]
                if bd then
                    local isActive = (n == name)
                    bd.fill.BackgroundTransparency = isActive and 0 or 1
                    bd.fill.BackgroundColor3 = isActive and guiAccentColor or Color3.fromRGB(24,18,20)
                    TweenService:Create(bd.stroke, TweenInfo.new(0.15), {Transparency = isActive and 0 or 1}):Play()
                    bd.lbl.TextColor3 = isActive and WHITE or TAB_INACT
                    bd.lbl.Font = isActive and Enum.Font.GothamBlack or Enum.Font.GothamBold
                end
            end
            activeTab = name
        end

        -- Costruisci bottoni tab verticali nella sidebar
        for idx, name in ipairs(TABS) do
            local fill = Instance.new("Frame", tabList)
            fill.Size = UDim2.new(1, 0, 0, 34)
            fill.BackgroundColor3 = guiAccentColor
            fill.BackgroundTransparency = 1; fill.BorderSizePixel = 0
            fill.LayoutOrder = idx; fill.ZIndex = 7
            Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 8)
            local st = Instance.new("UIStroke", fill); st.Color = guiAccentColor; st.Thickness = 1; st.Transparency = 1
            table.insert(_themeRefs.tabStrokes, st)

            local btn = Instance.new("TextButton", fill)
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1; btn.BorderSizePixel = 0
            btn.Text = TAB_DISPLAY[name] or name; btn.TextColor3 = TAB_INACT
            btn.Font = Enum.Font.GothamBold; btn.TextSize = isMobile and 8 or 9
            btn.AutoButtonColor = false; btn.ZIndex = 8
            btn.TextWrapped = true

            tabBtnRefs[name] = {btn=btn, fill=fill, stroke=st, lbl=btn}
            btn.MouseButton1Click:Connect(function() switchTab(name) end)
        end

        -- Mini button (per riaprire dopo chiusura)
        local miniBtnL4 = Instance.new("TextButton", gui)
        miniBtnL4.Size = UDim2.new(0,100,0,26); miniBtnL4.Position = UDim2.new(0,20,0,20)
        miniBtnL4.BackgroundColor3 = guiAccentColor; miniBtnL4.BorderSizePixel = 0
        miniBtnL4.Text = "MANUXS"; miniBtnL4.TextColor3 = WHITE
        miniBtnL4.Font = Enum.Font.GothamBlack; miniBtnL4.TextSize = 11; miniBtnL4.ZIndex = 20; miniBtnL4.Visible = false
        Instance.new("UICorner", miniBtnL4).CornerRadius = UDim.new(0,10)
        Instance.new("UIStroke", miniBtnL4).Color = guiAccentColor
        dragHandle(miniBtnL4)

        closeBtnL4.Activated:Connect(function()
            TweenService:Create(St.mainFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size=UDim2.new(0,0,0,0), BackgroundTransparency=1}):Play()
            task.delay(0.2, function() St.mainFrame.Visible=false; St.mainFrame.Size=UDim2.new(0,W,0,H); St.mainFrame.BackgroundTransparency=St.guiTransparencyEnabled and 0.72 or 0.62 end)
            miniBtnL4.Visible=true; miniBtnL4.Size=UDim2.new(0,0,0,26)
            TweenService:Create(miniBtnL4, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size=UDim2.new(0,100,0,26)}):Play()
        end)
        miniBtnL4.MouseButton1Click:Connect(function()
            miniBtnL4.Visible=false; St.mainFrame.Size=UDim2.new(0,0,0,0); St.mainFrame.BackgroundTransparency=1; St.mainFrame.Visible=true
            TweenService:Create(St.mainFrame, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size=UDim2.new(0,W,0,H), BackgroundTransparency=St.guiTransparencyEnabled and 0.72 or 0.62}):Play()
        end)

        switchTab(TABS[1])

        -- applyAccentColor Layout 4
        local function applyAccentColor(newAccent)
            if typeof(newAccent) ~= "Color3" then return end
            guiAccentColor = newAccent; PINK = newAccent; PINK2 = _darken(PINK,0.55); PINK3 = _darken(PINK,0.28)
            closeBtnL4.BackgroundColor3 = newAccent
            vDiv.BackgroundColor3 = newAccent
            serverLbl.TextColor3 = newAccent
            if miniBtnL4 and miniBtnL4.Parent then miniBtnL4.BackgroundColor3 = newAccent end
            for _,sf in pairs(tabPages) do if sf and sf.Parent then sf.ScrollBarImageColor3=PINK3 end end
            for _,ts in ipairs(_themeRefs.tabStrokes) do if ts and ts.Parent then ts.Color=newAccent end end
            if activeTab then switchTab(activeTab, true) end
            for _,ref in ipairs(_themeRefs.toggleRefs) do
                if ref.pill and ref.pill.Parent and ref.on then ref.pill.BackgroundColor3=newAccent end
            end
            pcall(M.createStealBar)
            pcall(M.buildMobileButtons)
            refreshThemeRegistries(newAccent)
        end
        M._applyAccentColor = applyAccentColor

        _buildTabContent(tabPages, _themeRefs, PINK, PINK2, PINK3, WHITE, GRAY, isMobile)

    end  -- fine if GUI_LAYOUT

end  -- fine M.buildGui()

-- ============================================================
-- CICLA LAYOUT GUI (usato dal pulsante T in ogni layout e dal tasto T)
-- ============================================================
function M.cycleGuiLayout()
    GUI_LAYOUT = 2
end

local _layoutCyclerBound=false
function M.bindLayoutCycler()
    GUI_LAYOUT = 2
end

-- ============================================================
-- KEYBIND GLOBALE: legge la tabella KB e attiva davvero le funzioni
-- (prima i tasti si salvavano ma non facevano nulla quando premuti)
-- ============================================================
local _globalKBBound=false
function M.bindGlobalKeybinds()
    if _globalKBBound then return end
    _globalKBBound=true
    -- Per-keybind gamepad debounce: prevents double-fire on controller buttons
    local _gpLastFire={}
    local function kbMatchG(entry,inp)
        if not entry or not inp then return false end
        if entry.mouse and inp.UserInputType==entry.mouse then return true end
        local kc=inp.KeyCode
        if not kc then return false end
        local matched = kc==entry.kb or (entry.gp and kc==entry.gp)
        if matched and entry.gp and kc==entry.gp then
            -- Gamepad debounce: ignore repeat fires within 220ms
            local now=tick()
            local key=tostring(kc.Value)
            if _gpLastFire[key] and (now-_gpLastFire[key])<0.22 then return false end
            _gpLastFire[key]=now
        end
        return matched
    end
    UIS.InputBegan:Connect(function(input,gpe)
        if St._anyKeyListening then return end
        if input.UserInputType==Enum.UserInputType.Keyboard then
            if gpe or UIS:GetFocusedTextBox() then return end
        end

        if kbMatchG(KB.DropBrainrot,input) then St.runDrop();return end
        if kbMatchG(KB.TPFloor,input) then St.runTPFloor();return end
        if kbMatchG(KB.InstaReset,input) then St.cursedInstaReset();return end

        if kbMatchG(KB.AutoLeft,input) then
            St.autoLeftEnabled=not St.autoLeftEnabled
            if St.autoLeftEnabled then St.startAutoLeft() else St.stopAutoLeft() end
            if UIRefs.autoLeftSetVisual then UIRefs.autoLeftSetVisual(St.autoLeftEnabled) end
            St.saveConfig();return
        end
        if kbMatchG(KB.AutoRight,input) then
            St.autoRightEnabled=not St.autoRightEnabled
            if St.autoRightEnabled then St.startAutoRight() else St.stopAutoRight() end
            if UIRefs.autoRightSetVisual then UIRefs.autoRightSetVisual(St.autoRightEnabled) end
            St.saveConfig();return
        end
        if kbMatchG(KB.AutoBat,input) then
            if St.autoBatEnabled then
                St.stopBatAimbot();if UIRefs.autoBatSetVisual then UIRefs.autoBatSetVisual(false) end
            else
                St.queueAutoBatStart();if UIRefs.autoBatSetVisual then UIRefs.autoBatSetVisual(true) end
            end
            St.saveConfig();return
        end
        if kbMatchG(KB.LaggerToggle,input) then
            -- Premi di nuovo per disattivare (toggle vero, non solo "accendi")
            St.toggleLaggerMode()
            if UIRefs.laggerModeSetVisual then UIRefs.laggerModeSetVisual(St.laggerModeEnabled) end
            St.saveConfig();return
        end
        if kbMatchG(KB.SpeedToggle,input) then
            St.toggleCarryMode()
            St.saveConfig();return
        end
        if kbMatchG(KB.GuiHide,input) then
            if St.mainFrame then St.mainFrame.Visible = not St.mainFrame.Visible end
            return
        end
        if kbMatchG(KB.InfJump,input) then
            St.infJumpEnabled = not St.infJumpEnabled
            if St.infJumpEnabled then if St.infJumpMode=="hold" then M.startHoldInfJump() end else M.stopHoldInfJump() end
            if Visuals.setInfJumpVisual then Visuals.setInfJumpVisual(St.infJumpEnabled) end
            St.saveConfig();return
        end
        if kbMatchG(KB.AutoTP,input) then
            St.autoTPEnabled = not St.autoTPEnabled
            if St.autoTPEnabled then St.startAutoTP() else St.stopAutoTP() end
            if UIRefs.setAutoTPVisual then UIRefs.setAutoTPVisual(St.autoTPEnabled) end
            St.saveConfig();return
        end
        if kbMatchG(KB.AntiRagdoll,input) then
            St.antiRagdollEnabled = not St.antiRagdollEnabled
            if St.antiRagdollEnabled then St.startAntiRagdoll() else St.stopAntiRagdoll() end
            if Visuals.setAntiRagVisual then Visuals.setAntiRagVisual(St.antiRagdollEnabled) end
            St.saveConfig();return
        end
        if kbMatchG(KB.BatCounter,input) then
            St.batCounterEnabled = not St.batCounterEnabled
            if St.batCounterEnabled then St.startBatCounter() else St.stopBatCounter() end
            if UIRefs.setBatCounterVisual then UIRefs.setBatCounterVisual(St.batCounterEnabled) end
            St.saveConfig();return
        end
        if kbMatchG(KB.MedusaCounter,input) then
            St.medusaCounterEnabled = not St.medusaCounterEnabled
            if St.medusaCounterEnabled then St.setupMedusa(LP.Character) else St.stopMedusaCounter() end
            if Visuals.setMedusaVisual then Visuals.setMedusaVisual(St.medusaCounterEnabled) end
            St.saveConfig();return
        end
        if kbMatchG(KB.MedusaReset,input) then
            St.medusaResetEnabled = not St.medusaResetEnabled
            if Visuals.setMedusaResetVisual then Visuals.setMedusaResetVisual(St.medusaResetEnabled) end
            St.saveConfig();return
        end
        if kbMatchG(KB.Unwalk,input) then
            St.unwalkEnabled = not St.unwalkEnabled
            if St.unwalkEnabled then St.startUnwalk() else St.stopUnwalk() end
            if Visuals.setUnwalkVisual then Visuals.setUnwalkVisual(St.unwalkEnabled) end
            St.saveConfig();return
        end
        if kbMatchG(KB.AutoSwing,input) then
            St.autoSwingEnabled = not St.autoSwingEnabled
            if Visuals.setAutoSwingVisual then Visuals.setAutoSwingVisual(St.autoSwingEnabled) end
            St.saveConfig();return
        end
        if kbMatchG(KB.TryhardAnim,input) then
            St.tryhardAnimEnabled = not St.tryhardAnimEnabled
            if St.tryhardAnimEnabled then pcall(M.startTryhardAnim) else pcall(M.stopTryhardAnim) end
            if Visuals.setTryhardAnimVisual then Visuals.setTryhardAnimVisual(St.tryhardAnimEnabled) end
            St.saveConfig();return
        end
        if kbMatchG(KB.AntiLag,input) then
            St.antiLagEnabled = not St.antiLagEnabled
            if St.antiLagEnabled then St.enableAntiLag() else St.disableAntiLag() end
            if Visuals.setAntiLagVisual then Visuals.setAntiLagVisual(St.antiLagEnabled) end
            St.saveConfig();return
        end
        if kbMatchG(KB.StretchRez,input) then
            St.stretchRezEnabled = not St.stretchRezEnabled
            if St.stretchRezEnabled then St.enableStretchRez() else St.disableStretchRez() end
            if UIRefs.setStretchRezVisual then UIRefs.setStretchRezVisual(St.stretchRezEnabled) end
            St.saveConfig();return
        end
        if kbMatchG(KB.RagdollGui,input) then
            St.ragdollGuiEnabled = not St.ragdollGuiEnabled
            if Visuals.setRagdollGuiVisual then Visuals.setRagdollGuiVisual(St.ragdollGuiEnabled) end
            St.saveConfig();return
        end
        if kbMatchG(KB.GuiTransparent,input) then
            St.guiTransparencyEnabled = not St.guiTransparencyEnabled
            pcall(applyTransparencyToGui,St.guiTransparencyEnabled)            if Visuals.setTranspVisual then Visuals.setTranspVisual(St.guiTransparencyEnabled) end
            St.saveConfig();return
        end
        if kbMatchG(KB.LockUi,input) then
            St.uiLocked = not St.uiLocked
            if Visuals.setLockVisual then Visuals.setLockVisual(St.uiLocked) end
            St.saveConfig();return
        end
        if kbMatchG(KB.AutoSwitchSpeed,input) then
            St.autoSwitchSpeedEnabled = not St.autoSwitchSpeedEnabled
            if Visuals.setAutoSwitchSpeedVisual then Visuals.setAutoSwitchSpeedVisual(St.autoSwitchSpeedEnabled) end
            St.saveConfig();return
        end
        if kbMatchG(KB.TpBat,input) then
            _G._tpBatEnabled = not _G._tpBatEnabled
            if _G._tpBatEnabled then pcall(_G._startTpBat) else pcall(_G._stopTpBat) end
            if Visuals.setTpBatVisual then Visuals.setTpBatVisual(_G._tpBatEnabled) end
            St.saveConfig();return
        end
    end)
end

local _savedCfg=nil
function M.loadConfigKeys()
    if not(isfile and isfile("aspecthub.json")) then St.configLoaded=true;return end
    local ok,cfg=pcall(function() return HS:JSONDecode(readfile("aspecthub.json")) end)
    if not ok or not cfg then St.configLoaded=true;return end;_savedCfg=cfg
    local function lk(e,d)
        if type(d)~="table" then return end
        if d.kb and Enum.KeyCode[d.kb] then e.kb=Enum.KeyCode[d.kb] else e.kb=nil end
        if d.gp and Enum.KeyCode[d.gp] then e.gp=Enum.KeyCode[d.gp] else e.gp=nil end
        if d.mouse and Enum.UserInputType[d.mouse] then e.mouse=Enum.UserInputType[d.mouse] else e.mouse=nil end
    end
    lk(KB.DropBrainrot,cfg.dropBrainrotKey);lk(KB.AutoLeft,cfg.autoLeftKey);lk(KB.AutoRight,cfg.autoRightKey)
    lk(KB.AutoBat,cfg.autoBatKey);lk(KB.LaggerToggle,cfg.laggerToggleKey);lk(KB.TPFloor,cfg.tpFloorKey)
    lk(KB.InstaReset,cfg.instaResetKey);lk(KB.GuiHide,cfg.guiHideKey);lk(KB.SpeedToggle,cfg.speedToggleKey)
    lk(KB.InfJump,cfg.infJumpKey);lk(KB.AutoTP,cfg.autoTPKey);lk(KB.AntiRagdoll,cfg.antiRagdollKey);lk(KB.BatCounter,cfg.batCounterKey)
    lk(KB.MedusaCounter,cfg.medusaCounterKey);lk(KB.MedusaReset,cfg.medusaResetKey);lk(KB.Unwalk,cfg.unwalkKey)
    lk(KB.AutoSwing,cfg.autoSwingKey);lk(KB.TryhardAnim,cfg.tryhardAnimKey);lk(KB.AntiLag,cfg.antiLagKey);lk(KB.StretchRez,cfg.stretchRezKey)
    lk(KB.RagdollGui,cfg.ragdollGuiKey);lk(KB.GuiTransparent,cfg.guiTransparentKey);lk(KB.LockUi,cfg.lockUiKey);lk(KB.AutoSwitchSpeed,cfg.autoSwitchSpeedKey);lk(KB.TpBat,cfg.tpBatKey)
    if cfg.normalSpeed then NS=cfg.normalSpeed end;if cfg.carrySpeed then CS=cfg.carrySpeed end
    if cfg.laggerSpeed then LAGGER_SPEED=cfg.laggerSpeed end;if cfg.laggerCarrySpeed then LAGGER_CARRY_SPEED=cfg.laggerCarrySpeed end
    if cfg.grabRadius then Steal.StealRadius=cfg.grabRadius end;if cfg.stealDuration then Steal.StealDuration=cfg.stealDuration end
    if cfg.grabMethod==1 or cfg.grabMethod==2 then Steal.Method=cfg.grabMethod end
    if cfg.grabRadius2 then Steal.StealRadius2=cfg.grabRadius2 end
    if cfg.holdMin2 then Steal.HoldMin2=cfg.holdMin2 end
    if cfg.autoTPHeight then St.autoTPHeight=cfg.autoTPHeight end
    if cfg.autoSwing~=nil then St.autoSwingEnabled=cfg.autoSwing==true end
    if cfg.guiTransparencyEnabled~=nil then St.guiTransparencyEnabled=cfg.guiTransparencyEnabled end
    if cfg.backgroundEnabled~=nil then St.guiBackgroundEnabled=cfg.backgroundEnabled==true end
    if type(cfg.backgroundIndex)=="number" then St.guiBackgroundIndex=math.clamp(math.floor(cfg.backgroundIndex+0.5),0,4) end
    if cfg.backgroundColored~=nil then St.guiBackgroundColored=cfg.backgroundColored==true end
    if type(cfg.guiAccent)=="table" and cfg.guiAccent.r and cfg.guiAccent.g and cfg.guiAccent.b then
        guiAccentColor = Color3.fromRGB(
            math.clamp(tonumber(cfg.guiAccent.r) or 176,0,255),
            math.clamp(tonumber(cfg.guiAccent.g) or 148,0,255),
            math.clamp(tonumber(cfg.guiAccent.b) or 255,0,255)
        )
    end
    if cfg.mobileButtonsEnabled~=nil then St.mobileButtonsEnabled=cfg.mobileButtonsEnabled==true else St.mobileButtonsEnabled=true end
    if cfg.mobileButtonsSize~=nil then St.mobileButtonsSize=cfg.mobileButtonsSize end
    if cfg.circleButtonsEnabled~=nil then St.circleButtonsEnabled=cfg.circleButtonsEnabled==true end
    if cfg.autoSwitchSpeed~=nil then St.autoSwitchSpeedEnabled=cfg.autoSwitchSpeed==true end
    if cfg.dropType==DROP_TYPES.STAND or cfg.dropType==DROP_TYPES.JUMP then St.currentDropType=cfg.dropType end
    if cfg.uiScalePercent then St.uiScalePercent=math.clamp(math.floor((tonumber(cfg.uiScalePercent) or St.uiScalePercent)+0.5),60,130) end
    St.antiKickEnabled=false
    if cfg.carrySpeedActive~=nil then St.carrySpeedActive=cfg.carrySpeedActive end
    if cfg.laggerModeEnabled~=nil then St.laggerModeEnabled=cfg.laggerModeEnabled end
    if St.laggerModeEnabled then St.carrySpeedActive=false end
    if cfg.infJumpMode then St.infJumpMode=cfg.infJumpMode end
    if cfg.fovValue then St.fovValue=cfg.fovValue;for idx,v in ipairs(fovOptions) do if v==St.fovValue then St.fovIndex=idx end end end
    if cfg.chromeImageVisible~=nil then _G._AspectHub_bgImageVisible=cfg.chromeImageVisible==true end
    if cfg.perButtonDrag~=nil then St.perButtonDragEnabled=cfg.perButtonDrag==true end
    if cfg.autoMoveSwing~=nil then St.autoMoveSwingEnabled=cfg.autoMoveSwing==true end
    if cfg.autoMoveSwingInterval then St.autoMoveSwingInterval=cfg.autoMoveSwingInterval end
    if cfg.skyTheme then currentSkyTheme=cfg.skyTheme;M.CandyApplyCustomSky(currentSkyTheme) end
    if cfg.medusaReset~=nil then St.medusaResetEnabled=cfg.medusaReset==true end
    if cfg.ragdollGui~=nil then St.ragdollGuiEnabled=cfg.ragdollGui==true end
    if cfg.introSoundEnabled~=nil then introSoundEnabled=cfg.introSoundEnabled==true end
    if cfg.bodyLockRange then St.bodyLockRange=math.max(1,tonumber(cfg.bodyLockRange) or 20) end
    if cfg.bodyLockEnabled then St.bodyLockEnabled=true end
    if cfg.tryhardAnim~=nil then St.tryhardAnimEnabled=cfg.tryhardAnim==true end
    if cfg.animPackEnabled~=nil then St.animPackEnabled=cfg.animPackEnabled==true end
    if type(cfg.animPack)=="string" and ANIM_PACKS[cfg.animPack] then
        St.animPackIndex=M.getAnimPackIndexByName(cfg.animPack)
    elseif type(cfg.animPackIndex)=="number" then
        St.animPackIndex=math.clamp(math.floor(cfg.animPackIndex+0.5),1,M.getAnimPackCount())
    end
    -- Ripristina layout GUI salvato (deve avvenire PRIMA di buildGui)
    GUI_LAYOUT = 2
    -- Ripristina stato Lock UI
    if cfg.uiLocked~=nil then St.uiLocked=cfg.uiLocked==true end
    St.configLoaded=true -- da qui in poi l'autosave può scrivere in sicurezza
end
function M.loadConfigState()
    local cfg=_savedCfg;if not cfg then return end
    if St.normalBox then St.normalBox.Text=tostring(NS) end;if St.carryBox then St.carryBox.Text=tostring(CS) end
    if St.radInput then St.radInput.Text=tostring(Steal.Method==2 and Steal.StealRadius2 or Steal.StealRadius) end;if St.durationBox then St.durationBox.Text=tostring(Steal.Method==2 and Steal.HoldMin2 or Steal.StealDuration) end
    if UIRefs.refreshGrabMethodButtons then UIRefs.refreshGrabMethodButtons() end
    if St.laggerBox then St.laggerBox.Text=tostring(LAGGER_SPEED) end;if St.autoTPHeightBox then St.autoTPHeightBox.Text=tostring(St.autoTPHeight) end
    if UIRefs.guiScaleValLbl then UIRefs.guiScaleValLbl.Text=string.format("%.2f",St.uiScalePercent/100) end
    if St.mainUIScale then St.mainUIScale.Scale=St.uiScalePercent/100 end
    if St.stealBarUIScale then St.stealBarUIScale.Scale=St.uiScalePercent/100 end
    if UIRefs.refreshDropTypeButtons then UIRefs.refreshDropTypeButtons() end
    St.guiBackgroundEnabled=false
    St.guiBackgroundIndex=0
    applyBackgroundImage(0)
    task.spawn(function()
        task.wait(0.15)
        if cfg.antiRagdoll then St.antiRagdollEnabled=true;if Visuals.setAntiRagVisual then Visuals.setAntiRagVisual(true) end;St.startAntiRagdoll() end
        if cfg.autoStealEnabled then Steal.AutoStealEnabled=true;if Visuals.setInstaGrab then Visuals.setInstaGrab(true) end;pcall(St.startAutoSteal) end
        if cfg.infiniteJump then St.infJumpEnabled=true;if Visuals.setInfJumpVisual then Visuals.setInfJumpVisual(true) end;if St.infJumpMode=="hold" then M.startHoldInfJump() end end
        if cfg.medusaCounter then St.medusaCounterEnabled=true;if Visuals.setMedusaVisual then Visuals.setMedusaVisual(true) end;St.setupMedusa(LP.Character) end
        if cfg.medusaReset then St.medusaResetEnabled=true;if Visuals.setMedusaResetVisual then Visuals.setMedusaResetVisual(true) end end
        if cfg.batCounter then St.batCounterEnabled=true;if UIRefs.setBatCounterVisual then UIRefs.setBatCounterVisual(true) end;St.startBatCounter() end
        if cfg.espEnabled then task.spawn(function() M.toggleESP(true);if Visuals.setESPVisual then Visuals.setESPVisual(true) end end) end
        if cfg.fpsBoostEnabled then task.spawn(function() FX.fpsBoostEnabled=true;M.applyFPSBoost();if Visuals.setFPSBoostVisual then Visuals.setFPSBoostVisual(true) end end) end
        St.refreshSpeedModeLabel()
        if cfg.autoTPEnabled then St.autoTPEnabled=true;if UIRefs.setAutoTPVisual then UIRefs.setAutoTPVisual(true) end;St.startAutoTP() end
        if Visuals.setAutoSwingVisual then Visuals.setAutoSwingVisual(St.autoSwingEnabled) end
        if cfg.batAimbotMode then St.batAimbotMode=cfg.batAimbotMode end
        if cfg.normalBatSpeed then St.normalBatSpeed=cfg.normalBatSpeed end
        if cfg.bypassBatSpeed then St.bypassBatSpeed=cfg.bypassBatSpeed end
        if cfg.bypassLaggerBatSpeed then St.bypassLaggerBatSpeed=cfg.bypassLaggerBatSpeed end
        if cfg.autoBat then
            St.autoBatEnabled=true;if UIRefs.autoBatSetVisual then UIRefs.autoBatSetVisual(true) end
            if mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
            St.queueAutoBatStart()
        end
        if cfg.unwalkEnabled then St.unwalkEnabled=true;if Visuals.setUnwalkVisual then Visuals.setUnwalkVisual(true) end;task.spawn(function() task.wait(0.5);St.startUnwalk() end) end
        if cfg.antiLag then St.enableAntiLag();if Visuals.setAntiLagVisual then Visuals.setAntiLagVisual(true) end end
        if cfg.stretchRez then St.enableStretchRez();if UIRefs.setStretchRezVisual then UIRefs.setStretchRezVisual(true) end end
        if cfg.tryhardAnim then
            St.tryhardAnimEnabled=true
            if Visuals.setTryhardAnimVisual then Visuals.setTryhardAnimVisual(true) end
            pcall(M.startTryhardAnim)
        end
        if cfg.animPackEnabled then
            St.animPackEnabled=true
            local packName=M.getAnimPackNameByIndex(St.animPackIndex)
            task.spawn(function() task.wait(0.8); M.applyAnimPack(packName) end)
        end
        if cfg.tpBatEnabled then
            _G._tpBatEnabled=true;if Visuals.setTpBatVisual then Visuals.setTpBatVisual(true) end;pcall(_G._startTpBat)
        end
        if St.circleButtonsEnabled and Visuals.setCircleBtnsVisual then Visuals.setCircleBtnsVisual(true) end
        if cfg.ragdollGui~=nil and Visuals.setRagdollGuiVisual then Visuals.setRagdollGuiVisual(St.ragdollGuiEnabled) end
        if cfg.uiLocked and Visuals.setLockVisual then Visuals.setLockVisual(true) end
        if cfg.guiTransparencyEnabled and Visuals.setTranspVisual then
            Visuals.setTranspVisual(true)
            pcall(applyTransparencyToGui, true)
        end
        if cfg.backgroundColored and UIRefs.setBackgroundColoredVisual then
            UIRefs.setBackgroundColoredVisual(true)
        end
        if cfg.bodyLockEnabled and Visuals.setBodyLockVisual then Visuals.setBodyLockVisual(true) end
        if cfg.introSoundEnabled ~= nil then introSoundEnabled = cfg.introSoundEnabled end
        -- Ripristino visual mancanti -------------------------------------------
        -- Auto Carry Speed toggle
        if Visuals.setAutoSwitchSpeedVisual then Visuals.setAutoSwitchSpeedVisual(St.autoSwitchSpeedEnabled) end
        -- Pill NORMAL / BYPASS del Bat Aimbot
        if UIRefs.refreshBatMode then UIRefs.refreshBatMode() end
        -- Label carry / lagger mode (refreshSpeedModeLabel già chiamata sopra,
        -- ma rilanciamo i visual setter direttamente per sicurezza)
        if UIRefs.carryModeSetVisual then UIRefs.carryModeSetVisual(St.carrySpeedActive) end
        if UIRefs.laggerModeSetVisual then UIRefs.laggerModeSetVisual(St.laggerModeEnabled) end
        -- Mobile carry/lagger buttons
        if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(St.carrySpeedActive) end
        if mobBtnRefs.lagger then mobBtnRefs.lagger(St.laggerModeEnabled) end
    end)
end

-- La costruzione della GUI ora avviene automaticamente alla fine della
-- sequenza intro (vedi task.spawn dell'INTRO SEQUENCE più in alto nel file).
