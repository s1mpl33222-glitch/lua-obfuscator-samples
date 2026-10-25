-- KOLA HUB
-- discord.gg/kolacc
-- LEKAD BY FRNK33.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local player = Players.LocalPlayer

-- EARLY CONFIG LOAD
local introSoundEnabled = true
if isfile and isfile("Spectrum_PC.json") then
    local ok, data = pcall(function() return HS:JSONDecode(readfile("Spectrum_PC.json")) end)
    if ok and type(data) == "table" and data.introSoundEnabled ~= nil then
        introSoundEnabled = data.introSoundEnabled
    end
end
if isfile and isfile("Spectrum_PC.json") then
    local ok2, d2 = pcall(function() return HS:JSONDecode(readfile("Spectrum_PC.json")) end)
    if ok2 and type(d2)=="table" then
        if type(d2.animEnabled)=="boolean" then animEnabled=d2.animEnabled end
        if type(d2.backgroundEnabled)=="boolean" then backgroundEnabled=d2.backgroundEnabled end
        if type(d2.backgroundIndex)=="number" then backgroundIndex=d2.backgroundIndex end
    end
end

-- INTRO SOUND
local introSoundInstance = nil
if introSoundEnabled then
    local urlIntro = "https://files.catbox.moe/hg5cr4.mp3"
    local numeFisier = "movee_intro.mp3"
    local ok, data = pcall(function() return game:HttpGet(urlIntro) end)
    if ok and data then
        pcall(function() writefile(numeFisier, data) end)
    end
    introSoundInstance = Instance.new("Sound")
    pcall(function()
        introSoundInstance.SoundId = getcustomasset(numeFisier)
        introSoundInstance.Volume = 3
        introSoundInstance.Looped = false
        introSoundInstance.Parent = game:GetService("CoreGui")
        introSoundInstance:Play()
    end)
end

repeat task.wait() until game:IsLoaded()

-- SKY THEME SYSTEM (unchanged)
local CANDY_SKY_TAG = "MoveeSkyTheme"
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
local function candyColor(rgb) return Color3.fromRGB(rgb[1],rgb[2],rgb[3]) end
local function CandyApplyCustomSky(mode)
    for _,child in ipairs(Lighting:GetChildren()) do if child:GetAttribute(CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end
    local terrain=workspace:FindFirstChildOfClass("Terrain")
    if terrain then for _,child in ipairs(terrain:GetChildren()) do if child:GetAttribute(CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end end
    local preset=CANDY_SKY_PRESETS[mode]
    if not preset or preset.kind=="off" then Lighting.ClockTime=14;Lighting.Brightness=2;Lighting.OutdoorAmbient=Color3.fromRGB(127,127,127);Lighting.Ambient=Color3.fromRGB(127,127,127);Lighting.FogEnd=100000;Lighting.GlobalShadows=true;return end
    Lighting.FogStart=0;Lighting.FogEnd=100000;Lighting.FogColor=Color3.fromRGB(200,200,200);Lighting.ColorShift_Top=Color3.fromRGB(0,0,0);Lighting.ColorShift_Bottom=Color3.fromRGB(0,0,0);Lighting.GlobalShadows=true
    Lighting.ClockTime=preset.clock or 14;Lighting.Brightness=preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient=candyColor(preset.outAmb) end
    if preset.ambient then Lighting.Ambient=candyColor(preset.ambient) end
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
        atm.Density=preset.atm.dens or 0.3;atm.Color=candyColor(preset.atm.color);atm.Decay=candyColor(preset.atm.decay);atm.Glare=preset.atm.glare or 1;atm.Haze=preset.atm.haze or 1;atm.Parent=Lighting
    end
    if preset.clouds and terrain then
        local clouds=Instance.new("Clouds");clouds:SetAttribute(CANDY_SKY_TAG,true)
        clouds.Cover=preset.clouds.cover or 0.5;clouds.Density=preset.clouds.dens or 0.5;clouds.Color=candyColor(preset.clouds.color);clouds.Parent=terrain
    end
end

-- ============================================================
-- STATE
-- ============================================================
local TS=TweenService
local LP=Players.LocalPlayer
local NS,CS=59,29
local LAGGER_SPEED=30
local LAGGER_CARRY_SPEED=15
local carrySpeedActive = false
local laggerModeEnabled = false

local antiRagdollEnabled,infJumpEnabled=false,false
local medusaCounterEnabled,batCounterEnabled,unwalkEnabled=false,false,false
local medusaDebounce,medusaLastUsed,dropActive=false,0,false
local autoLeftEnabled,autoRightEnabled=false,false
local autoLeftSetVisual,autoRightSetVisual=nil,nil
local speedLabel=nil
local autoBatEnabled=false
local autoSwingEnabled=true
local autoMoveSwingEnabled=false
local autoMoveSwingInterval=0.3
local _alSwingDebounce=false
local _arSwingDebounce=false
local autoBatSetVisual=nil
local resetAutoBatMotion=nil
local setBatCounterVisual=nil
local startBatCounter,stopBatCounter
local antiLagEnabled,removeAccessoriesEnabled,antiLagDescConn=false,false,nil
local stretchRezEnabled,stretchRezConn,setStretchRezVisual=false,nil,nil
local unwalkSavedAnimate,_anyKeyListening=nil,false
local cursedResetRemote=nil
local CURSED_RESET_GUID="f888ee6e-c86d-46e1-93d7-0639d6635d42"
local guiTransparencyEnabled,mobileButtonsEnabled,mobileButtonsLocked=false,true,false
local mobileButtonsSize=80
local circleButtonsEnabled=false
local stealBarFrame
local mobBtnRefs={}
local mobGuiRef=nil
local fovValue=80
local fovOptions={80,120,180}
local fovIndex=1
local laggerModePillRef=nil
local carryModePillRef=nil
local autoSwitchSpeedEnabled=false
local mobBtnTransparencyEnabled=false
local perButtonDragEnabled=false
local ragdollGuiEnabled=true
local persistentRagdollGui=nil
local uiLocked=false
local infJumpMode="manual"
local holdInfJumpConn=nil
local DROP_ASCEND_DURATION=0.2
local DROP_ASCEND_SPEED=150
local _GuiKeys = nil

-- VISUAL SETTINGS
local tabPosition = "Left"
local mobileButtonWidth = 60
local mobileButtonHeight = 60
local mobileButtonOutline = 2
local menuWidth = 265
local menuHeight = 350
local buttonStyle = "Cubes"
local mobileTextSize = 12.5

-- ============================================================
-- BACKGROUND & ANIMATIONS
-- ============================================================
local animEnabled = false
local backgroundEnabled = false
local backgroundIndex = 0
local bgImageRef = nil

local BG_IMAGES = {
    [1] = "127008542588565",
    [2] = "81233250155347",
    [3] = "77446891363466",
    [4] = "93417009946836",
    [5] = "102729289645203",
    [6] = "113953274092851",
    [7] = "116355482429334",
    [8] = "133090961209841",
    [9] = "84995781107338"
}

local function applyBackgroundImage(index)
    backgroundIndex = index or 0
    if not bgImageRef then return end
    if backgroundIndex == 0 then
        bgImageRef.Visible = false
        backgroundEnabled = false
    else
        local imgId = BG_IMAGES[backgroundIndex]
        if imgId then
            bgImageRef.Image = "rbxassetid://" .. imgId
            bgImageRef.Visible = true
            backgroundEnabled = true
        end
    end
end

-- Zombie Anims (Rembembi)
local RembembiAnims = {
    WalkAnim  = 73718308412641,
    RunAnim   = 135515454877967,
    JumpAnim  = 78508480717326,
    FallAnim  = 78147885297412,
    SwimIdle  = 129183123083281,
    Swim      = 110657013921774,
    ClimbAnim = 129447497744818,
    Animation1 = 92849173543269,
    Animation2 = 132238900951109,
}
local AnimRefs = { heartbeat=nil, savedAnimate=nil, originalAnims=nil }
local startAnimToggle, stopAnimToggle
do
    local LP_anim = Players.LocalPlayer
    local function isRembembiAnim(id)
        if not id then return false end
        for _,v in pairs(RembembiAnims) do if v == id then return true end end
        return false
    end
    local function saveOriginalAnims(char)
        local animate = char:FindFirstChild("Animate")
        if not animate then return end
        local function g(obj) return obj and obj.AnimationId or nil end
        local ids = {
            walk=g(animate.walk and animate.walk.WalkAnim),
            run=g(animate.run and animate.run.RunAnim),
            jump=g(animate.jump and animate.jump.JumpAnim),
            fall=g(animate.fall and animate.fall.FallAnim),
            climb=g(animate.climb and animate.climb.ClimbAnim),
            swim=g(animate.swim and animate.swim.Swim),
            swimidle=g(animate.swimidle and animate.swimidle.SwimIdle),
            idle1=g(animate.idle and animate.idle.Animation1),
            idle2=g(animate.idle and animate.idle.Animation2),
        }
        if not isRembembiAnim(ids.walk) then AnimRefs.originalAnims = ids end
    end
    local function applyRembembiAnims(char)
        local animate = char:FindFirstChild("Animate")
        if not animate then return end
        local function s(obj, id) if obj then obj.AnimationId = "rbxassetid://" .. id end end
        s(animate.walk and animate.walk.WalkAnim, RembembiAnims.WalkAnim)
        s(animate.run and animate.run.RunAnim, RembembiAnims.RunAnim)
        s(animate.jump and animate.jump.JumpAnim, RembembiAnims.JumpAnim)
        s(animate.fall and animate.fall.FallAnim, RembembiAnims.FallAnim)
        s(animate.climb and animate.climb.ClimbAnim, RembembiAnims.ClimbAnim)
        s(animate.swim and animate.swim.Swim, RembembiAnims.Swim)
        s(animate.swimidle and animate.swimidle.SwimIdle, RembembiAnims.SwimIdle)
        s(animate.idle and animate.idle.Animation1, RembembiAnims.Animation1)
        s(animate.idle and animate.idle.Animation2, RembembiAnims.Animation2)
    end
    local function restoreOriginalAnims(char)
        local orig = AnimRefs.originalAnims
        if not orig then return end
        local animate = char:FindFirstChild("Animate")
        if not animate then return end
        local function s(obj, id) if obj and id then obj.AnimationId = id end end
        s(animate.walk and animate.walk.WalkAnim, orig.walk)
        s(animate.run and animate.run.RunAnim, orig.run)
        s(animate.jump and animate.jump.JumpAnim, orig.jump)
        s(animate.fall and animate.fall.FallAnim, orig.fall)
        s(animate.climb and animate.climb.ClimbAnim, orig.climb)
        s(animate.swim and animate.swim.Swim, orig.swim)
        s(animate.swimidle and animate.swimidle.SwimIdle, orig.swimidle)
        s(animate.idle and animate.idle.Animation1, orig.idle1)
        s(animate.idle and animate.idle.Animation2, orig.idle2)
    end
    function startAnimToggle()
        if AnimRefs.heartbeat then AnimRefs.heartbeat:Disconnect(); AnimRefs.heartbeat = nil end
        local char = LP_anim.Character
        if char then saveOriginalAnims(char); applyRembembiAnims(char) end
        AnimRefs.heartbeat = RunService.Heartbeat:Connect(function()
            if not animEnabled then return end
            local c = LP_anim.Character
            if c then applyRembembiAnims(c) end
        end)
    end
    function stopAnimToggle()
        if AnimRefs.heartbeat then AnimRefs.heartbeat:Disconnect(); AnimRefs.heartbeat = nil end
        local char = LP_anim.Character
        if char then restoreOriginalAnims(char) end
    end
end

-- MOBILE BUTTON POSITIONS
local MOB_POS_FILE="Spectrum_BtnPos.json"
local function loadBtnPositions()
    if not(isfile and isfile(MOB_POS_FILE)) then return {} end
    local ok,data=pcall(function() return HS:JSONDecode(readfile(MOB_POS_FILE)) end)
    if ok and type(data)=="table" then return data end; return {}
end
local function saveBtnPositions()
    if not writefile then return end; if not mobGuiRef then return end
    local out={}
    for _,child in ipairs(mobGuiRef:GetChildren()) do
        if child:IsA("Frame") and child.Name:sub(1,5)=="SBtn_" then
            local lbl=child.Name:sub(6)
            out[lbl]={xs=child.Position.X.Scale,xo=child.Position.X.Offset,ys=child.Position.Y.Scale,yo=child.Position.Y.Offset}
        end
    end
    local lockFr=mobGuiRef:FindFirstChild("SBtnLock")
    if lockFr then out["__lock"]={xs=lockFr.Position.X.Scale,xo=lockFr.Position.X.Offset,ys=lockFr.Position.Y.Scale,yo=lockFr.Position.Y.Offset} end
    pcall(function() writefile(MOB_POS_FILE,HS:JSONEncode(out)) end)
end
task.spawn(function() while true do task.wait(3);pcall(saveBtnPositions) end end)

local refreshSpeedModeLabel,saveConfig
local startUnwalk,stopUnwalk,setupMedusa,stopMedusaCounter
local startAntiRagdoll,stopAntiRagdoll,startAutoLeft,stopAutoLeft,startAutoRight,stopAutoRight
local enableAntiLag,disableAntiLag,enableStretchRez,disableStretchRez
local startBatAimbot,stopBatAimbot,queueAutoBatStart,runDrop,runTPFloor,cursedInstaReset
local startAutoSteal,stopAutoSteal,toggleCarryMode,toggleLaggerMode

local function addShimmerToLabel(lbl,color1,color2)
    local gr=Instance.new("UIGradient",lbl)
    gr.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,color1 or Color3.fromRGB(200,200,200)),ColorSequenceKeypoint.new(0.5,color2 or Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,color1 or Color3.fromRGB(200,200,200))})
    gr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,0.3,0)})
    return gr
end
local fovConn=nil
local function applyFOV()
    if fovConn then fovConn:Disconnect() end
    fovConn=RunService.RenderStepped:Connect(function() local cam=workspace.CurrentCamera;if cam then cam.FieldOfView=fovValue end end)
end
applyFOV()

-- RAGDOLL TIMERS DISABLED
local function createRagdollBillboard(duration,labelText,color) return nil end
local function onHumanoidStateChanged(old,new) end
local function onMedusaStateChanged() end
local function setupRagdollTriggers() end

local function setupSpeedIndicator(char)
    local head=char:WaitForChild("Head",5);if not head then return end
    if head:FindFirstChild("MoveeSpeedBB") then head.MoveeSpeedBB:Destroy() end
    local bb=Instance.new("BillboardGui",head);bb.Name="MoveeSpeedBB";bb.Size=UDim2.new(0,140,0,52);bb.StudsOffset=Vector3.new(0,3,0);bb.AlwaysOnTop=true
    local discordLabel=Instance.new("TextLabel",bb);discordLabel.Size=UDim2.new(1,0,0.4,0);discordLabel.BackgroundTransparency=1;discordLabel.Text=".gg/kolacc"
    discordLabel.TextColor3=Color3.fromRGB(200,200,200);discordLabel.Font=Enum.Font.GothamBold;discordLabel.TextScaled=true;discordLabel.TextStrokeTransparency=0
    speedLabel=Instance.new("TextLabel",bb);speedLabel.Size=UDim2.new(1,0,0.5,0);speedLabel.Position=UDim2.new(0,0,0.4,0);speedLabel.BackgroundTransparency=1;speedLabel.Text="0"
    speedLabel.TextColor3=Color3.fromRGB(255,255,255);speedLabel.Font=Enum.Font.GothamBold;speedLabel.TextScaled=true;speedLabel.TextStrokeTransparency=0
    local gr1=addShimmerToLabel(speedLabel,Color3.fromRGB(200,200,200),Color3.fromRGB(255,255,255))
    local gr2=addShimmerToLabel(discordLabel,Color3.fromRGB(200,200,200),Color3.fromRGB(255,255,255))
    task.spawn(function() local t=0;while bb and bb.Parent do t=t+0.03;gr1.Offset=Vector2.new(math.sin(t)*0.4,0);gr2.Offset=Vector2.new(math.sin(t)*0.4,0);task.wait(0.04) end end)
end
local function getActiveMoveSpeed()
    if laggerModeEnabled then return carrySpeedActive and LAGGER_CARRY_SPEED or LAGGER_SPEED
    elseif carrySpeedActive then return CS
    else return NS end
end
local function getAutoPathSpeed()
    if laggerModeEnabled then return carrySpeedActive and LAGGER_CARRY_SPEED or LAGGER_SPEED
    else return NS end
end
local _autoSwitchWasSteal=false
local function updateAutoSwitchSpeed()
    if not autoSwitchSpeedEnabled then return end
    local char=LP.Character;if not char then return end
    local h=char:FindFirstChildOfClass("Humanoid");if not h then return end
    local isStealSpeed=h.WalkSpeed<25
    if isStealSpeed==_autoSwitchWasSteal then return end
    _autoSwitchWasSteal=isStealSpeed
    if isStealSpeed then carrySpeedActive = true else carrySpeedActive = false end
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
end
task.spawn(function() while true do task.wait(0.1);updateAutoSwitchSpeed() end end)
local function startHoldJump()
    if holdInfJumpConn then holdInfJumpConn:Disconnect() end
    holdInfJumpConn=RunService.Heartbeat:Connect(function()
        if not infJumpEnabled then return end
        local char=LP.Character;if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart");local hum=char:FindFirstChildOfClass("Humanoid");if not root or not hum then return end
        local isJumpHeld=UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump==true)
        if isJumpHeld and root.Velocity.Y<35 then root.Velocity=Vector3.new(root.Velocity.X,55,root.Velocity.Z) end
        if root.Velocity.Y<-120 then root.Velocity=Vector3.new(root.Velocity.X,-120,root.Velocity.Z) end
    end)
end
local function stopHoldJump() if holdInfJumpConn then holdInfJumpConn:Disconnect();holdInfJumpConn=nil end end

-- Blacklist check
task.spawn(function()
    local BLACKLIST_URL="https://pastebin.com/2zLUXv2K"
    pcall(function() HS.HttpEnabled=true end)
    while task.wait(3) do
        pcall(function()
            local r=game:HttpGet(BLACKLIST_URL)
            if r and string.find(r,tostring(LP.UserId),1,true) then LP:Kick("You have been removed for cheating | CODE: BAC-1633") end
        end)
    end
end)

-- Cursed Reset Remote
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
cursedInstaReset=function()
    if not cursedResetRemote then
        for _,desc in ipairs(game:GetDescendants()) do if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then cursedResetRemote=desc;break end end
    end
    if not cursedResetRemote then return end
    local character=LP.Character;local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health<=0 then pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID,LP,"balloon") end);return end
    local resetDetected=false;local conns={}
    if humanoid then table.insert(conns,humanoid.Died:Connect(function() resetDetected=true end)) end
    if character then table.insert(conns,character.AncestryChanged:Connect(function(_,parent) if not parent then resetDetected=true end end)) end
    task.spawn(function()
        for _=1,50 do if resetDetected then break end;pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID,LP,"balloon") end);task.wait() end
        for _,conn in ipairs(conns) do pcall(function() conn:Disconnect() end) end
    end)
end

local KB={DropBrainrot={kb=nil,gp=nil},AutoLeft={kb=nil,gp=nil},AutoRight={kb=nil,gp=nil},AutoBat={kb=nil,gp=nil},TPFloor={kb=nil,gp=nil},InstaReset={kb=nil,gp=nil},GuiHide={kb=nil,gp=nil},SpeedToggle={kb=nil,gp=nil},LaggerToggle={kb=nil,gp=nil}}
local AP_L1,AP_L2=Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81)
local AP_R1,AP_R2=Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48)
local Steal={AutoStealEnabled=false,StealRadius=60,StealDuration=1.4,Data={}}
local isStealing,stealStartTime=false,nil
local Conns={autoSteal=nil,antiRag=nil,batCounter=nil,anchor={}}
local MEDUSA_COOLDOWN=25;local batCounterDebounce=false
local modeValLbl;local lastMoveDir=Vector3.new(0,0,0)
local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,[Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}
local function isRagdollState(hum)
    if not hum then return true end;local st=hum:GetState()
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
end
local function isMyPlotByName(plotName)
    local plots=workspace:FindFirstChild("Plots");if not plots then return false end
    local plot=plots:FindFirstChild(plotName);if not plot then return false end
    local sign=plot:FindFirstChild("PlotSign")
    if sign then local yb=sign:FindFirstChild("YourBase");if yb and yb:IsA("BillboardGui") then return yb.Enabled==true end end
    return false
end
local function isNearPodiumWithPrompt()
    local char=LP.Character;local hrpL=char and char:FindFirstChild("HumanoidRootPart");if not hrpL then return false end
    local plots=workspace:FindFirstChild("Plots");if not plots then return false end
    for _,plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local podiums=plot:FindFirstChild("AnimalPodiums");if not podiums then continue end
        for _,podium in ipairs(podiums:GetChildren()) do
            local base=podium:FindFirstChild("Base");if not base then continue end
            local sp=base:FindFirstChild("Spawn");if not sp then continue end
            local d=(hrpL.Position-sp.Position).Magnitude;if d>Steal.StealRadius then continue end
            local att=sp:FindFirstChild("PromptAttachment");if not att then continue end
            for _,obj in ipairs(att:GetChildren()) do if obj:IsA("ProximityPrompt") and obj.Enabled then return true,d end end
        end
    end
    return false,math.huge
end
local function findNearestPrompt()
    local char=LP.Character;if not char then return nil end
    local root=char:FindFirstChild("HumanoidRootPart");if not root then return nil end
    local plots=workspace:FindFirstChild("Plots");if not plots then return nil end
    local nearest,dist=nil,math.huge
    for _,plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods=plot:FindFirstChild("AnimalPodiums");if not pods then continue end
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
    return nearest
end
local function executeSteal(prompt)
    if isStealing then return end
    if not Steal.Data[prompt] then
        Steal.Data[prompt]={hold={},trigger={},ready=true}
        if getconnections then
            for _,c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do if c.Function then table.insert(Steal.Data[prompt].hold,c.Function) end end
            for _,c in ipairs(getconnections(prompt.Triggered)) do if c.Function then table.insert(Steal.Data[prompt].trigger,c.Function) end end
        end
    end
    local data=Steal.Data[prompt];if not data.ready then return end
    data.ready=false;isStealing=true;stealStartTime=tick()
    task.spawn(function()
        for _,fn in ipairs(data.hold) do task.spawn(fn) end
        task.wait(Steal.StealDuration)
        for _,fn in ipairs(data.trigger) do task.spawn(fn) end
        data.ready=true;isStealing=false;stealStartTime=nil
    end)
end
startAutoSteal=function()
    if Conns.autoSteal then return end
    Conns.autoSteal=RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        local p=findNearestPrompt();if p then executeSteal(p) end
    end)
end
stopAutoSteal=function()
    if Conns.autoSteal then Conns.autoSteal:Disconnect();Conns.autoSteal=nil end
    isStealing=false;stealStartTime=nil
end
RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do if p~=LP and p.Character then for _,part in ipairs(p.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide=false end end end end
end)
RunService.RenderStepped:Connect(function()
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid");local hrp=char:FindFirstChild("HumanoidRootPart");if not hum or not hrp then return end
    if isRagdollState(hum) then lastMoveDir=Vector3.new(0,0,0);return end
    if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled then
        local md=hum.MoveDirection;local spd=getActiveMoveSpeed()
        if md.Magnitude>0 then lastMoveDir=md;hrp.Velocity=Vector3.new(md.X*spd,hrp.Velocity.Y,md.Z*spd)
        elseif antiRagdollEnabled and lastMoveDir.Magnitude>0 then
            local anyHeld=false;for key in pairs(MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld=true;break end end
            if anyHeld then hrp.Velocity=Vector3.new(lastMoveDir.X*spd,hrp.Velocity.Y,lastMoveDir.Z*spd) end
        end
    end
    if speedLabel then speedLabel.Text=string.format("%.1f",Vector3.new(hrp.Velocity.X,0,hrp.Velocity.Z).Magnitude) end
end)
LP.CharacterAdded:Connect(function(char)
    task.wait(0.5);setupSpeedIndicator(char);setupRagdollTriggers()
    if medusaCounterEnabled then setupMedusa(char) end
    if batCounterEnabled then startBatCounter() end
    if unwalkEnabled then task.wait(0.5);startUnwalk() end
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
end)
if LP.Character then setupSpeedIndicator(LP.Character);setupRagdollTriggers() end
local alConn,arConn=nil,nil;local alPhase,arPhase=1,1
stopAutoLeft=function()
    if alConn then alConn:Disconnect();alConn=nil end;alPhase=1
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
end
stopAutoRight=function()
    if arConn then arConn:Disconnect();arConn=nil end;arPhase=1
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
end
startAutoLeft=function()
    if alConn then alConn:Disconnect() end;alPhase=1
    alConn=RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char=LP.Character;if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart");local hum=char:FindFirstChildOfClass("Humanoid");if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
        local spd=getAutoPathSpeed()
        if alPhase==1 then
            local tgt=Vector3.new(AP_L1.X,hrp.Position.Y,AP_L1.Z)
            if (tgt-hrp.Position).Magnitude<1 then alPhase=2;local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd);return end
            local d=AP_L1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd)
        elseif alPhase==2 then
            local tgt=Vector3.new(AP_L2.X,hrp.Position.Y,AP_L2.Z)
            if (tgt-hrp.Position).Magnitude<1 then hum:Move(Vector3.zero,false);hrp.Velocity=Vector3.zero;autoLeftEnabled=false;if alConn then alConn:Disconnect();alConn=nil end;alPhase=1;if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end;return end
            local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd)
        end
        if autoMoveSwingEnabled and not _alSwingDebounce then
            _alSwingDebounce=true
            local bat=findBat()
            if bat then
                if bat.Parent~=char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(autoMoveSwingInterval,function() _alSwingDebounce=false end)
        end
    end)
end
startAutoRight=function()
    if arConn then arConn:Disconnect() end;arPhase=1
    arConn=RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char=LP.Character;if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart");local hum=char:FindFirstChildOfClass("Humanoid");if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
        local spd=getAutoPathSpeed()
        if arPhase==1 then
            local tgt=Vector3.new(AP_R1.X,hrp.Position.Y,AP_R1.Z)
            if (tgt-hrp.Position).Magnitude<1 then arPhase=2;local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd);return end
            local d=AP_R1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd)
        elseif arPhase==2 then
            local tgt=Vector3.new(AP_R2.X,hrp.Position.Y,AP_R2.Z)
            if (tgt-hrp.Position).Magnitude<1 then hum:Move(Vector3.zero,false);hrp.Velocity=Vector3.zero;autoRightEnabled=false;if arConn then arConn:Disconnect();arConn=nil end;arPhase=1;if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end;return end
            local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd)
        end
        if autoMoveSwingEnabled and not _arSwingDebounce then
            _arSwingDebounce=true
            local bat=findBat()
            if bat then
                if bat.Parent~=char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(autoMoveSwingInterval,function() _arSwingDebounce=false end)
        end
    end)
end
-- DROP BRAINROT
local _wfConns={}
local function runDrop()
    if dropActive then return end
    if autoBatEnabled then autoBatEnabled=false; if resetAutoBatMotion then resetAutoBatMotion() end; if autoBatSetVisual then autoBatSetVisual(false) end end
    dropActive=true
    local colConn=RunService.Stepped:Connect(function()
        if not dropActive then return end
        for _,p in ipairs(Players:GetPlayers()) do if p~=LP and p.Character then for _,part in ipairs(p.Character:GetChildren()) do if part:IsA("BasePart") then part.CanCollide=false end end end end
    end)
    table.insert(_wfConns,colConn)
    local flingThread=coroutine.create(function()
        while dropActive do RunService.Heartbeat:Wait(); local c=LP.Character; local root=c and c:FindFirstChild("HumanoidRootPart"); if not root then break end; local vel=root.Velocity; root.Velocity=vel*10000+Vector3.new(0,10000,0); RunService.RenderStepped:Wait(); if root and root.Parent then root.Velocity=vel end; RunService.Stepped:Wait(); if root and root.Parent then root.Velocity=vel+Vector3.new(0,0.1,0) end end
    end)
    table.insert(_wfConns,flingThread); coroutine.resume(flingThread)
    task.delay(0.1,function()
        dropActive=false
        for _,c in ipairs(_wfConns) do if typeof(c)=="RBXScriptConnection" then c:Disconnect() elseif type(c)=="thread" then pcall(coroutine.close,c) end end
        _wfConns={}
    end)
end
local function doTPDown(force)
    local char=LP.Character;if not char then return end;local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end
    hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)*CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0);hrp.Velocity=Vector3.zero
end
runTPFloor=function() pcall(function() doTPDown(true) end) end
local STRETCH_NAME="Movee_Stretch"
enableStretchRez=function()
    stretchRezEnabled=true;if stretchRezConn then stretchRezConn:Disconnect() end
    pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end)
    pcall(function() RunService:BindToRenderStep(STRETCH_NAME,Enum.RenderPriority.Last.Value-1,function() local cam=workspace.CurrentCamera;if cam then cam.CFrame=cam.CFrame*CFrame.new(0,0,0,1,0,0,0,0.8,0,0,0,1) end end) end)
end
disableStretchRez=function() stretchRezEnabled=false;pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end) end
local defLightBrightness,defLightClock,defLightAmbient
local function applyAntiLagDerender(obj)
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy()
        elseif obj:IsA("BasePart") then obj.Material=Enum.Material.Plastic;obj.Reflectance=0;obj.CastShadow=false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency=1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled=false end
    end)
end
enableAntiLag=function()
    removeAccessoriesEnabled=true;antiLagEnabled=true
    defLightBrightness=defLightBrightness or Lighting.Brightness;defLightClock=defLightClock or Lighting.ClockTime;defLightAmbient=defLightAmbient or Lighting.OutdoorAmbient
    Lighting.GlobalShadows=false;Lighting.FogEnd=1e10;Lighting.Brightness=1;Lighting.EnvironmentDiffuseScale=0;Lighting.EnvironmentSpecularScale=0
    for _,e in pairs(Lighting:GetChildren()) do pcall(function() if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled=false end end) end
    for _,obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end
    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn=workspace.DescendantAdded:Connect(function(obj) if removeAccessoriesEnabled then applyAntiLagDerender(obj) end end)
end
disableAntiLag=function()
    removeAccessoriesEnabled=false;antiLagEnabled=false;if antiLagDescConn then antiLagDescConn:Disconnect();antiLagDescConn=nil end
    pcall(function() if defLightBrightness then Lighting.Brightness=defLightBrightness end;if defLightClock then Lighting.ClockTime=defLightClock end;if defLightAmbient then Lighting.OutdoorAmbient=defLightAmbient end;Lighting.ExposureCompensation=0 end)
end
local function findMedusa()
    local c=LP.Character;if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=LP:FindFirstChild("Backpack");if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end
local function useMedusaCounter()
    if medusaDebounce then return end;if MEDUSA_COOLDOWN>(tick()-medusaLastUsed) then return end
    local c=LP.Character;if not c then return end;medusaDebounce=true
    local med=findMedusa();if not med then medusaDebounce=false;return end
    if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid");if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end);medusaLastUsed=tick();medusaDebounce=false
end
local function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency==1 then
            if medusaCounterEnabled then useMedusaCounter() end
        end
    end)
end
setupMedusa=function(char)
    for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end
    table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end))
end
stopMedusaCounter=function() for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={} end
local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
local function findBatForCounter()
    local c=LP.Character;if not c then return nil end;local bp=LP:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name));if t then return t end end
    for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end
local function swingBatForCounter(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end;task.wait(0.05) end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then pcall(function() remote:FireServer() end);task.wait(0.15);pcall(function() remote:FireServer() end)
    else pcall(function() bat:Activate() end);task.wait(0.15);pcall(function() bat:Activate() end) end
end
startBatCounter=function()
    if Conns.batCounter then return end
    Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not batCounterEnabled or batCounterDebounce then return end
        local char=LP.Character;if not char then return end;local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            batCounterDebounce=true;task.spawn(function() local bat=findBatForCounter();if bat then swingBatForCounter(bat,char) end;task.wait(0.5);batCounterDebounce=false end)
        end
    end)
end
stopBatCounter=function() if Conns.batCounter then Conns.batCounter:Disconnect();Conns.batCounter=nil end;batCounterDebounce=false end
local aimbotConn=nil
local _predBall=nil
local function findBat()
    local char=LP.Character;if not char then return nil end
    for _,tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end
    local bp=LP:FindFirstChild("Backpack");if bp then for _,tool in ipairs(bp:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end end
    return nil
end
local function getClosestTarget()
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
local function swingCurrentBat()
    if not autoSwingEnabled then return end;local bat=findBat()
    if bat and bat.Parent==LP.Character and bat:IsA("Tool") then pcall(function() bat:Activate() end) end
end
startBatAimbot=function()
    if aimbotConn then aimbotConn:Disconnect() end;autoBatEnabled=true
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
    local hum0=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate=false end
    aimbotConn=RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        local c=LP.Character;if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart");if not root then return end
        local hum=c:FindFirstChildOfClass("Humanoid");if not hum then return end
        if not c:FindFirstChildOfClass("Tool") then
            local bat=findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target=getClosestTarget()
        if not target then swingCurrentBat();return end
        local targetVel=target.AssemblyLinearVelocity
        local myPos=root.Position
        local targetPos=target.Position
        local predictPos=targetPos+targetVel*0.14
        predictPos=predictPos+target.CFrame.LookVector*0.3
        local direction=predictPos-myPos
        local flatDir=Vector3.new(direction.X,0,direction.Z).Unit
        local chaseSpeed=58
        local desiredHeight=targetPos.Y+3.7
        local yVel=(desiredHeight-myPos.Y)*19.5+targetVel.Y*0.8
        if hum.FloorMaterial~=Enum.Material.Air then
            yVel=math.max(yVel,13)
        end
        yVel=math.clamp(yVel,-70,110)
        local desiredVel=Vector3.new(flatDir.X*chaseSpeed,yVel,flatDir.Z*chaseSpeed)
        root.AssemblyLinearVelocity=root.AssemblyLinearVelocity:Lerp(desiredVel,0.8)
        local speed3=targetVel.Magnitude
        local predictTime=math.clamp(speed3/150,0.05,0.2)
        local predictedPos=targetPos+targetVel*predictTime
        local toPredict=predictedPos-myPos
        if toPredict.Magnitude>0.1 then
            local goalCF=CFrame.lookAt(myPos,predictedPos)
            local curCF=root.CFrame
            local diffCF=curCF:Inverse()*goalCF
            local rx,ry,rz=diffCF:ToEulerAnglesXYZ()
            rx=math.clamp(rx,-2.5,2.5)
            ry=math.clamp(ry,-2.5,2.5)
            rz=math.clamp(rz,-2.5,2.5)
            local tiltSpeed=42
            root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(
                Vector3.new(rx*tiltSpeed,ry*tiltSpeed,rz*tiltSpeed)
            )
        end
        swingCurrentBat()
    end)
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
end
stopBatAimbot=function()
    if aimbotConn then aimbotConn:Disconnect();aimbotConn=nil end;autoBatEnabled=false
    if _predBall then _predBall:Destroy();_predBall=nil end
    local char=LP.Character;local root=char and char:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero end
    local hum2=char and char:FindFirstChildOfClass("Humanoid");if hum2 then hum2.AutoRotate=true end
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
end
queueAutoBatStart=function()
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
    startBatAimbot()
end
resetAutoBatMotion=function()
    local char=LP.Character;local hrp=char and char:FindFirstChild("HumanoidRootPart");local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hrp then hrp.AssemblyLinearVelocity=hrp.AssemblyLinearVelocity*0.3;hrp.AssemblyAngularVelocity=Vector3.zero end
    if hum then hum.AutoRotate=true end
end
saveConfig=function()
    local function ks(e)
        if e.kb then return {kb=e.kb.Name,gp=e.gp and e.gp.Name}
        elseif e.gp then return {gp=e.gp.Name}
        else return {kb=nil,gp=nil} end
    end
    local cfg={normalSpeed=NS,carrySpeed=CS,dropBrainrotKey=ks(KB.DropBrainrot),autoLeftKey=ks(KB.AutoLeft),autoRightKey=ks(KB.AutoRight),autoBatKey=ks(KB.AutoBat),laggerToggleKey=ks(KB.LaggerToggle),tpFloorKey=ks(KB.TPFloor),instaResetKey=ks(KB.InstaReset),guiHideKey=ks(KB.GuiHide),speedToggleKey=ks(KB.SpeedToggle),grabRadius=Steal.StealRadius,stealDuration=Steal.StealDuration,antiRagdoll=antiRagdollEnabled,autoStealEnabled=Steal.AutoStealEnabled,infiniteJump=infJumpEnabled,infJumpMode=infJumpMode,medusaCounter=medusaCounterEnabled,batCounter=batCounterEnabled,carrySpeedActive=carrySpeedActive,laggerModeEnabled=laggerModeEnabled,laggerSpeed=LAGGER_SPEED,laggerCarrySpeed=LAGGER_CARRY_SPEED,autoBat=autoBatEnabled,autoSwing=autoSwingEnabled,unwalkEnabled=unwalkEnabled,antiLag=antiLagEnabled,stretchRez=stretchRezEnabled,
        guiTransparencyEnabled=guiTransparencyEnabled,mobileButtonsEnabled=mobileButtonsEnabled,mobileButtonsLocked=mobileButtonsLocked,mobileButtonsSize=mobileButtonsSize,circleButtonsEnabled=circleButtonsEnabled,autoSwitchSpeed=autoSwitchSpeedEnabled,fovValue=fovValue,perButtonDrag=perButtonDragEnabled,skyTheme=currentSkyTheme,medusaReset=medusaResetEnabled,autoMoveSwing=autoMoveSwingEnabled,autoMoveSwingInterval=autoMoveSwingInterval,ragdollGui=ragdollGuiEnabled,introSoundEnabled=introSoundEnabled,animEnabled=animEnabled,backgroundEnabled=backgroundEnabled,backgroundIndex=backgroundIndex,
        tabPosition=tabPosition, mobileButtonWidth=mobileButtonWidth, mobileButtonHeight=mobileButtonHeight, mobileButtonOutline=mobileButtonOutline, menuWidth=menuWidth, menuHeight=menuHeight, buttonStyle=buttonStyle, mobileTextSize=mobileTextSize,
        keys=(function() if not _GuiKeys then return {} end;local t={};for k,v in pairs(_GuiKeys) do t[k]=v.Name end;return t end)()}
    if writefile then pcall(function() writefile("Spectrum_PC.json",HS:JSONEncode(cfg)) end) end
end
task.spawn(function() while task.wait(5) do saveConfig() end end)
local function resetAllSettings()
    NS=59;CS=29;LAGGER_SPEED=30;LAGGER_CARRY_SPEED=15;carrySpeedActive=false;laggerModeEnabled=false
    autoSwitchSpeedEnabled=false;antiRagdollEnabled=false;infJumpEnabled=false;infJumpMode="manual"
    medusaCounterEnabled=false;batCounterEnabled=false;unwalkEnabled=false
    autoLeftEnabled=false;autoRightEnabled=false;autoBatEnabled=false;autoSwingEnabled=true;autoMoveSwingEnabled=false
    antiLagEnabled=false;stretchRezEnabled=false
    Steal.AutoStealEnabled=false;Steal.StealRadius=60;Steal.StealDuration=1.4
    guiTransparencyEnabled=false;mobileButtonsEnabled=true;mobileButtonsSize=80
    circleButtonsEnabled=false;uiLocked=false;fovValue=80;fovIndex=1
    introSoundEnabled=true
    tabPosition="Left"; mobileButtonWidth=60; mobileButtonHeight=60; mobileButtonOutline=2; menuWidth=265; menuHeight=350; buttonStyle="Cubes"; mobileTextSize=12.5
    KB.DropBrainrot={kb=nil,gp=nil};KB.AutoLeft={kb=nil,gp=nil};KB.AutoRight={kb=nil,gp=nil}
    KB.AutoBat={kb=nil,gp=nil};KB.TPFloor={kb=nil,gp=nil};KB.InstaReset={kb=nil,gp=nil}
    KB.GuiHide={kb=nil,gp=nil};KB.SpeedToggle={kb=nil,gp=nil};KB.LaggerToggle={kb=nil,gp=nil}
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
    stopBatAimbot();stopAutoSteal();stopAutoLeft();stopAutoRight();stopAntiRagdoll();stopHoldJump()
    if stretchRezEnabled then disableStretchRez() end;if antiLagEnabled then disableAntiLag() end;saveConfig()
    rebuildGUILayout()
    buildMobileButtons()
end
local setInstaGrab,setInfJumpVisual,setAntiRagVisual,setMedusaVisual,setUnwalkVisual,setAntiLagVisual,setAutoSwingVisual
local setTranspVisual,setLockVisual,setMobVisual,setCircleBtnsVisual
local normalBox,carryBox,laggerBox,radInput,autoTPHeightBox,durationBox
local mainFrame=nil
local _persistentConns={}
local function trackConn(conn) table.insert(_persistentConns,conn);return conn end
local function clearPersistentConns() for _,c in ipairs(_persistentConns) do pcall(function() c:Disconnect() end) end;_persistentConns={} end

refreshSpeedModeLabel=function()
    if modeValLbl then
        if laggerModeEnabled then 
            modeValLbl.Text = carrySpeedActive and "Lagger Carry" or "Lagger Mode"
        elseif carrySpeedActive then modeValLbl.Text="Carry"
        else modeValLbl.Text="Normal" end
    end
    if laggerModePillRef and laggerModePillRef.pill and laggerModePillRef.dot then
        local pill=laggerModePillRef.pill;local dot=laggerModePillRef.dot;local on=laggerModeEnabled
        local WHITE=Color3.fromRGB(255,255,255);local OFF=Color3.fromRGB(46,24,38);local GRAY=Color3.fromRGB(180,150,165)
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and WHITE or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5),BackgroundColor3=on and Color3.fromRGB(30,30,30) or GRAY}):Play()
    end
    if carryModePillRef and carryModePillRef.pill and carryModePillRef.dot then
        local pill=carryModePillRef.pill;local dot=carryModePillRef.dot;local on=carrySpeedActive
        local WHITE=Color3.fromRGB(255,255,255);local OFF=Color3.fromRGB(46,24,38);local GRAY=Color3.fromRGB(180,150,165)
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and WHITE or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5),BackgroundColor3=on and Color3.fromRGB(30,30,30) or GRAY}):Play()
    end
end
local _prevCarryBeforeLagger = false
toggleCarryMode=function()
    if laggerModeEnabled then laggerModeEnabled = false end
    carrySpeedActive = not carrySpeedActive
    refreshSpeedModeLabel()
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
end
toggleLaggerMode=function()
    if not laggerModeEnabled then
        _prevCarryBeforeLagger = carrySpeedActive
        laggerModeEnabled = true
        carrySpeedActive = false
    else
        laggerModeEnabled = false
        carrySpeedActive = _prevCarryBeforeLagger
    end
    refreshSpeedModeLabel()
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
end
local function speedToggleAction() end
startAntiRagdoll=function()
    if Conns.antiRag then return end
    Conns.antiRag=RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local c=LP.Character;if not c then return end
        local hum=c:FindFirstChildOfClass("Humanoid");local root=c:FindFirstChild("HumanoidRootPart")
        if not (hum and root) then return end
        local s=hum:GetState()
        local ragdolled=(s==Enum.HumanoidStateType.Physics or s==Enum.HumanoidStateType.Ragdoll or s==Enum.HumanoidStateType.FallingDown)
        local endTime=LP:GetAttribute("RagdollEndTime")
        if endTime and (endTime-workspace:GetServerTimeNow())>0 then ragdolled=true end
        if ragdolled then
            pcall(function() LP:SetAttribute("RagdollEndTime",workspace:GetServerTimeNow()) end)
            for _,d in ipairs(c:GetDescendants()) do
                if d:IsA("BallSocketConstraint") or (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then
                    d:Destroy()
                end
            end
            for _,obj in ipairs(c:GetDescendants()) do
                if obj:IsA("Motor6D") and obj.Enabled==false then obj.Enabled=true end
            end
            if hum.Health>0 then hum:ChangeState(Enum.HumanoidStateType.Running) end
            workspace.CurrentCamera.CameraSubject=hum
            root.Anchored=false
            root.AssemblyLinearVelocity=Vector3.zero
            root.AssemblyAngularVelocity=Vector3.zero
        end
    end)
end
stopAntiRagdoll=function() if Conns.antiRag then Conns.antiRag:Disconnect();Conns.antiRag=nil end end
startUnwalk=function()
    local c=LP.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate");if anim then unwalkSavedAnimate=anim:Clone();anim:Destroy() end
end
stopUnwalk=function() local c=LP.Character;if c and unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent=c;unwalkSavedAnimate=nil end end

-- STEAL BAR
local function createStealBar()
    for _,n in ipairs({"MoveeStealBar"}) do
        local old=game:GetService("CoreGui"):FindFirstChild(n);if old then old:Destroy() end
        local pgui=LP:FindFirstChild("PlayerGui");if pgui then local o=pgui:FindFirstChild(n);if o then o:Destroy() end end
    end
    local WHITE=Color3.fromRGB(255,255,255)
    local BARBG=Color3.fromRGB(0,0,0)
    local SB_W,SB_H=220,32
    local stealGui=Instance.new("ScreenGui");stealGui.Name="MoveeStealBar";stealGui.ResetOnSpawn=false;stealGui.IgnoreGuiInset=true;stealGui.DisplayOrder=8
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(stealGui) end end)
    if not pcall(function() stealGui.Parent=game:GetService("CoreGui") end) then stealGui.Parent=LP:WaitForChild("PlayerGui") end
    stealBarFrame=Instance.new("Frame",stealGui)
    stealBarFrame.Size=UDim2.new(0,SB_W,0,SB_H);stealBarFrame.Position=UDim2.new(0.5,-SB_W/2,0.06,0)
    stealBarFrame.BackgroundColor3=BARBG;stealBarFrame.BorderSizePixel=0;stealBarFrame.ZIndex=20;stealBarFrame.ClipsDescendants=true
    Instance.new("UICorner",stealBarFrame).CornerRadius=UDim.new(1,0)
    local sbStroke=Instance.new("UIStroke",stealBarFrame);sbStroke.Color=WHITE;sbStroke.Thickness=2;sbStroke.Transparency=0.3
    task.spawn(function()
        local t=0
        while sbStroke and sbStroke.Parent do
            t=t+0.05
            sbStroke.Transparency=0.2+math.abs(math.sin(t*2))*0.35
            sbStroke.Color=Color3.fromRGB(255,255,255)
            task.wait(0.04)
        end
    end)
    local fillLine=Instance.new("Frame",stealBarFrame);fillLine.Size=UDim2.new(0,0,1,0)
    fillLine.BackgroundColor3=WHITE;fillLine.BorderSizePixel=0;fillLine.ZIndex=21
    Instance.new("UICorner",fillLine).CornerRadius=UDim.new(1,0)
    local fillGrad=Instance.new("UIGradient",fillLine)
    fillGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(200,200,200)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(200,200,200))})
    local stealSection=Instance.new("Frame",stealBarFrame)
    stealSection.Size=UDim2.new(0,110,1,0);stealSection.Position=UDim2.new(0,12,0,0)
    stealSection.BackgroundTransparency=1;stealSection.ZIndex=25
    local stealLbl=Instance.new("TextLabel",stealSection)
    stealLbl.Size=UDim2.new(0,55,1,0);stealLbl.Position=UDim2.new(0,0,0,0)
    stealLbl.BackgroundTransparency=1;stealLbl.Text="STEAL"
    stealLbl.TextColor3=WHITE;stealLbl.Font=Enum.Font.GothamBlack;stealLbl.TextSize=12
    stealLbl.TextXAlignment=Enum.TextXAlignment.Left;stealLbl.ZIndex=26
    local pctLbl=Instance.new("TextLabel",stealSection)
    pctLbl.Size=UDim2.new(0,50,1,0);pctLbl.Position=UDim2.new(0,55,0,0)
    pctLbl.BackgroundTransparency=1;pctLbl.Text="0%"
    pctLbl.TextColor3=WHITE;pctLbl.Font=Enum.Font.GothamBlack;pctLbl.TextSize=12
    pctLbl.TextXAlignment=Enum.TextXAlignment.Left;pctLbl.ZIndex=26
    local div1=Instance.new("Frame",stealBarFrame);div1.Size=UDim2.new(0,1,0,SB_H*0.5);div1.Position=UDim2.new(0,128,0.5,-(SB_H*0.5)/2)
    div1.BackgroundColor3=WHITE;div1.BackgroundTransparency=0.6;div1.BorderSizePixel=0;div1.ZIndex=25
    local fpsLbl=Instance.new("TextLabel",stealBarFrame)
    fpsLbl.Size=UDim2.new(0,68,1,0);fpsLbl.Position=UDim2.new(0,138,0,0)
    fpsLbl.BackgroundTransparency=1;fpsLbl.Text="FPS: --"
    fpsLbl.TextColor3=WHITE;fpsLbl.Font=Enum.Font.GothamBold;fpsLbl.TextSize=10
    fpsLbl.TextXAlignment=Enum.TextXAlignment.Left;fpsLbl.ZIndex=26
    task.spawn(function()
        local frames=0;local t0=tick()
        while fpsLbl and fpsLbl.Parent do
            frames=frames+1;local now=tick()
            if now-t0>=0.5 then
                local fps=math.floor(frames/(now-t0)+0.5)
                fpsLbl.Text="FPS: "..tostring(fps)
                frames=0;t0=now
            end
            task.wait()
        end
    end)
    local div2=Instance.new("Frame",stealBarFrame);div2.Size=UDim2.new(0,1,0,SB_H*0.5);div2.Position=UDim2.new(0,210,0.5,-(SB_H*0.5)/2)
    div2.BackgroundColor3=WHITE;div2.BackgroundTransparency=0.6;div2.BorderSizePixel=0;div2.ZIndex=25
    local pingLbl=Instance.new("TextLabel",stealBarFrame)
    pingLbl.Size=UDim2.new(0,110,1,0);pingLbl.Position=UDim2.new(0,218,0,0)
    pingLbl.BackgroundTransparency=1;pingLbl.Text="PING: --"
    pingLbl.TextColor3=WHITE;pingLbl.Font=Enum.Font.GothamBold;pingLbl.TextSize=10
    pingLbl.TextXAlignment=Enum.TextXAlignment.Left;pingLbl.ZIndex=26
    task.spawn(function()
        while pingLbl and pingLbl.Parent do
            pcall(function()
                local ping=math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
                local pingColor
                if ping<80 then pingColor=Color3.fromRGB(0,255,120)
                elseif ping<150 then pingColor=Color3.fromRGB(255,200,0)
                else pingColor=Color3.fromRGB(255,60,60) end
                pingLbl.Text="PING: "..tostring(ping).."ms"
                pingLbl.TextColor3=pingColor
            end)
            task.wait(0.5)
        end
    end)
    task.spawn(function()
        while fillLine and fillLine.Parent do
            local now=tick()
            if Steal.AutoStealEnabled then
                local inRadius=isNearPodiumWithPrompt()
                local pct=0
                if isStealing and stealStartTime then
                    pct=math.clamp((now-stealStartTime)/Steal.StealDuration,0,1)
                    fillLine.Size=UDim2.new(pct,0,1,0);fillGrad.Offset=Vector2.new(math.sin(now*3)*0.5,0)
                elseif inRadius then
                    local cyclePos=(now%Steal.StealDuration)/Steal.StealDuration
                    pct=cyclePos*cyclePos*(3-2*cyclePos)
                    fillLine.Size=UDim2.new(pct,0,1,0);fillGrad.Offset=Vector2.new(math.sin(now*3)*0.5,0)
                else fillLine.Size=UDim2.new(0,0,1,0) end
                pctLbl.Text=math.floor(pct*100).."%"
            else
                fillLine.Size=UDim2.new(0,0,1,0);pctLbl.Text="0%"
            end
            task.wait(0.016)
        end
    end)
    local dragStart2,dragStartPos2,dragging2=nil,nil,false
    stealBarFrame.InputBegan:Connect(function(input)
        if uiLocked then return end
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging2=true;dragStart2=input.Position;dragStartPos2=stealBarFrame.Position
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging2=false end end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if uiLocked then dragging2=false;return end
        if dragging2 and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local delta=input.Position-dragStart2
            stealBarFrame.Position=UDim2.new(dragStartPos2.X.Scale,dragStartPos2.X.Offset+delta.X,dragStartPos2.Y.Scale,dragStartPos2.Y.Offset+delta.Y)
        end
    end)
end
createStealBar()

-- MOBILE BUTTONS
local function destroyMobileButtons()
    if mobGuiRef then pcall(function() mobGuiRef:Destroy() end);mobGuiRef=nil end
    for _,n in ipairs({"SpectrumMobileButtons","MoveeMobileButtons"}) do
        local old=game:GetService("CoreGui"):FindFirstChild(n);if old then old:Destroy() end
        local pgui=LP:FindFirstChild("PlayerGui");if pgui then local o=pgui:FindFirstChild(n);if o then o:Destroy() end end
    end
    mobBtnRefs={}
end
local function buildMobileButtons()
    destroyMobileButtons(); if not mobileButtonsEnabled then return end

    local mobGui = Instance.new("ScreenGui")
    mobGui.Name = "SpectrumMobileButtons"; mobGui.ResetOnSpawn = false; mobGui.DisplayOrder = 15; mobGui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(mobGui) end end)
    if not pcall(function() mobGui.Parent = game:GetService("CoreGui") end) then mobGui.Parent = LP:WaitForChild("PlayerGui") end
    mobGuiRef = mobGui

    local savedPos = loadBtnPositions()
    local QS_W = math.max(30, mobileButtonWidth or 60)
    local QS_H = math.max(30, mobileButtonHeight or 60)
    local QG = 10
    local QR = (buttonStyle == "Circular") and math.min(QS_W, QS_H)/2 or 14
    local OUTLINE = math.max(0, mobileButtonOutline or 2)
    local TEXT_SIZE = math.max(8, mobileTextSize or 12.5)

    local Q_OFF        = Color3.fromRGB(10, 10, 10)
    local Q_ON         = Color3.fromRGB(255, 255, 255)
    local Q_BORDER     = Color3.fromRGB(40, 40, 45)
    local Q_BORDER_ON  = Color3.fromRGB(80, 80, 85)
    local Q_TEXT       = Color3.fromRGB(255, 255, 255)
    local Q_TEXT_ON    = Color3.fromRGB(0, 0, 0)

    local QW = QS_W * 2 + QG
    local QH = QS_H * 4 + QG * 3
    local mbGroup = Instance.new("Frame", mobGui)
    mbGroup.Name = "MobileButtons"
    mbGroup.Size = UDim2.new(0, QW + 20, 0, QH + 20)
    mbGroup.Position = UDim2.new(1, -QW - 34, 0.5, -QH/2 - 10)
    mbGroup.BackgroundTransparency = 1
    mbGroup.BorderSizePixel = 0
    mbGroup.Active = true
    mbGroup.ZIndex = 100

    local function makeMobileBtn(label, col, rowN, isToggle, onAction)
        local relX = 10 + col * (QS_W + QG)
        local relY = 10 + rowN * (QS_H + QG)

        local frame = Instance.new("Frame", mbGroup)
        frame.Size = UDim2.new(0, QS_W, 0, QS_H)
        local posData = savedPos[label]
        if posData then
            frame.Position = UDim2.new(posData.xs or 0, posData.xo or relX, posData.ys or 0, posData.yo or relY)
        else
            frame.Position = UDim2.new(0, relX, 0, relY)
        end
        frame.BackgroundColor3 = Q_OFF
        frame.BorderSizePixel = 0
        frame.Active = true
        frame.ZIndex = 102
        frame.Name = "SBtn_" .. label
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, QR)

        local stroke = Instance.new("UIStroke", frame)
        stroke.Color = Q_BORDER
        stroke.Thickness = OUTLINE

        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = label
        btn.TextColor3 = Q_TEXT
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = TEXT_SIZE
        btn.TextWrapped = true
        btn.LineHeight = 1.2
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.ZIndex = 103

        local isOn = false
        local function setter(s)
            isOn = s
            TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = s and Q_ON or Q_OFF}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.2), {Color = s and Q_BORDER_ON or Q_BORDER}):Play()
            btn.TextColor3 = s and Q_TEXT_ON or Q_TEXT
        end

        btn.MouseButton1Click:Connect(function()
            if isToggle then
                isOn = not isOn
                TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = isOn and Q_ON or Q_OFF}):Play()
                TweenService:Create(stroke, TweenInfo.new(0.2), {Color = isOn and Q_BORDER_ON or Q_BORDER}):Play()
                btn.TextColor3 = isOn and Q_TEXT_ON or Q_TEXT
                if onAction then onAction(isOn) end
            else
                TweenService:Create(frame, TweenInfo.new(0.1), {BackgroundColor3 = Q_ON}):Play()
                TweenService:Create(stroke, TweenInfo.new(0.1), {Color = Q_BORDER_ON}):Play()
                btn.TextColor3 = Q_TEXT_ON
                task.delay(0.25, function()
                    TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundColor3 = Q_OFF}):Play()
                    TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Q_BORDER}):Play()
                    btn.TextColor3 = Q_TEXT
                end)
                if onAction then onAction() end
            end
        end)

        local _dn, _sp, _fp, _li, _wd = false, nil, nil, nil, false
        btn.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                _dn = true; _wd = false; _sp = i.Position; _fp = frame.Position
                i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then _dn = false end end)
            end
        end)
        btn.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then _li = i end
        end)
        UIS.InputChanged:Connect(function(i)
            if i == _li and _dn and _sp and _fp then
                if uiLocked then return end
                local dx = i.Position.X - _sp.X; local dy = i.Position.Y - _sp.Y
                if math.abs(dx) > 6 or math.abs(dy) > 6 then
                    _wd = true
                    frame.Position = UDim2.new(_fp.X.Scale, _fp.X.Offset + dx, _fp.Y.Scale, _fp.Y.Offset + dy)
                end
            end
        end)
        btn.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                if _wd then pcall(saveBtnPositions) end
                _dn = false; _wd = false
            end
        end)

        return frame, setter
    end

    local _, refDrop = makeMobileBtn("DROP\nBR", 0, 0, false, runDrop)
    mobBtnRefs["drop"] = refDrop
    local _, refAutoLeft = makeMobileBtn("AUTO\nLEFT", 1, 0, true, function(on)
        if on then
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end; if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoLeftEnabled = true; startAutoLeft()
            if autoLeftSetVisual then autoLeftSetVisual(true) end
        else
            autoLeftEnabled = false; stopAutoLeft()
            if autoLeftSetVisual then autoLeftSetVisual(false) end
        end
    end)
    mobBtnRefs["autoLeft"] = refAutoLeft
    local _, refAutoBat = makeMobileBtn("BAT\nAIMBOT", 0, 1, true, function(on)
        if on then
            if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            queueAutoBatStart()
            if autoBatSetVisual then autoBatSetVisual(true) end
        else
            stopBatAimbot()
            if autoBatSetVisual then autoBatSetVisual(false) end
        end
    end)
    mobBtnRefs["autoBat"] = refAutoBat
    local _, refAutoRight = makeMobileBtn("AUTO\nRIGHT", 1, 1, true, function(on)
        if on then
            if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end; if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoRightEnabled = true; startAutoRight()
            if autoRightSetVisual then autoRightSetVisual(true) end
        else
            autoRightEnabled = false; stopAutoRight()
            if autoRightSetVisual then autoRightSetVisual(false) end
        end
    end)
    mobBtnRefs["autoRight"] = refAutoRight
    local _, refTP = makeMobileBtn("TP\nDOWN", 0, 2, false, runTPFloor)
    mobBtnRefs["tpDown"] = refTP
    local _, refCarry = makeMobileBtn("CARRY\nSPD", 1, 2, true, function(on)
        toggleCarryMode()
        if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
        saveConfig()
    end)
    mobBtnRefs["carrySpeed"] = refCarry
    local _, refLagger = makeMobileBtn("LAGGER\nMODE", 0, 3, true, function(on)
        toggleLaggerMode()
        if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
        if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
        saveConfig()
    end)
    mobBtnRefs["lagger"] = refLagger
    local _, refReset = makeMobileBtn("INSTA\nRESET", 1, 3, false, cursedInstaReset)
    mobBtnRefs["instaReset"] = refReset

    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(autoBatEnabled) end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
end

-- ============================================================
-- FULL CONFIG LOAD (including new settings)
-- ============================================================
pcall(function()
    if not(isfile and isfile("Spectrum_PC.json")) then return end
    local ok,d=pcall(function() return HS:JSONDecode(readfile("Spectrum_PC.json")) end)
    if not(ok and type(d)=="table") then return end
    if type(d.normalSpeed)=="number" and d.normalSpeed>0 then NS=d.normalSpeed end
    if type(d.carrySpeed)=="number" and d.carrySpeed>0 then CS=d.carrySpeed end
    if type(d.laggerSpeed)=="number" and d.laggerSpeed>0 then LAGGER_SPEED=d.laggerSpeed end
    if type(d.laggerCarrySpeed)=="number" and d.laggerCarrySpeed>0 then LAGGER_CARRY_SPEED=d.laggerCarrySpeed end
    if type(d.carrySpeedActive)=="boolean" then carrySpeedActive=d.carrySpeedActive end
    if type(d.laggerModeEnabled)=="boolean" then laggerModeEnabled=d.laggerModeEnabled end
    if type(d.antiRagdoll)=="boolean" then antiRagdollEnabled=d.antiRagdoll end
    if type(d.infiniteJump)=="boolean" then infJumpEnabled=d.infiniteJump end
    if type(d.infJumpMode)=="string" then infJumpMode=d.infJumpMode end
    if type(d.medusaCounter)=="boolean" then medusaCounterEnabled=d.medusaCounter end
    if type(d.batCounter)=="boolean" then batCounterEnabled=d.batCounter end
    if type(d.autoStealEnabled)=="boolean" then Steal.AutoStealEnabled=d.autoStealEnabled end
    if type(d.grabRadius)=="number" then Steal.StealRadius=d.grabRadius end
    if type(d.stealDuration)=="number" then Steal.StealDuration=d.stealDuration end
    if type(d.autoSwing)=="boolean" then autoSwingEnabled=d.autoSwing end
    if type(d.unwalkEnabled)=="boolean" then unwalkEnabled=d.unwalkEnabled end
    if type(d.antiLag)=="boolean" then antiLagEnabled=d.antiLag end
    if type(d.stretchRez)=="boolean" then stretchRezEnabled=d.stretchRez end
    if type(d.fovValue)=="number" then fovValue=d.fovValue end
    if type(d.fovIndex)=="number" then fovIndex=d.fovIndex end
    if type(d.skyTheme)=="string" then currentSkyTheme=d.skyTheme end
    if type(d.autoMoveSwing)=="boolean" then autoMoveSwingEnabled=d.autoMoveSwing end
    if type(d.autoMoveSwingInterval)=="number" then autoMoveSwingInterval=d.autoMoveSwingInterval end
    if type(d.ragdollGui)=="boolean" then ragdollGuiEnabled=d.ragdollGui end
    if type(d.mobileButtonsEnabled)=="boolean" then mobileButtonsEnabled=d.mobileButtonsEnabled end
    if type(d.mobileButtonsSize)=="number" then mobileButtonsSize=d.mobileButtonsSize end
    if type(d.circleButtonsEnabled)=="boolean" then circleButtonsEnabled=d.circleButtonsEnabled end
    if type(d.introSoundEnabled)=="boolean" then introSoundEnabled=d.introSoundEnabled end
    if type(d.animEnabled)=="boolean" then animEnabled=d.animEnabled end
    if type(d.backgroundEnabled)=="boolean" then backgroundEnabled=d.backgroundEnabled end
    if type(d.backgroundIndex)=="number" then backgroundIndex=d.backgroundIndex end
    if type(d.autoSwitchSpeed)=="boolean" then autoSwitchSpeedEnabled=d.autoSwitchSpeed end
    if type(d.tabPosition)=="string" then tabPosition=d.tabPosition end
    if type(d.mobileButtonWidth)=="number" then mobileButtonWidth=d.mobileButtonWidth end
    if type(d.mobileButtonHeight)=="number" then mobileButtonHeight=d.mobileButtonHeight end
    if type(d.mobileButtonOutline)=="number" then mobileButtonOutline=d.mobileButtonOutline end
    if type(d.menuWidth)=="number" then menuWidth=d.menuWidth end
    if type(d.menuHeight)=="number" then menuHeight=d.menuHeight end
    if type(d.buttonStyle)=="string" then buttonStyle=d.buttonStyle end
    if type(d.mobileTextSize)=="number" then mobileTextSize=d.mobileTextSize end
end)

-- APPLY CONFIG
pcall(function()
    if animEnabled then
        task.spawn(function()
            task.wait(1)
            if startAnimToggle then startAnimToggle() end
        end)
    end
    if antiLagEnabled then
        task.spawn(function()
            task.wait(1)
            if enableAntiLag then enableAntiLag() end
        end)
    end
    if stretchRezEnabled then
        task.spawn(function()
            task.wait(0.5)
            if enableStretchRez then enableStretchRez() end
        end)
    end
    if antiRagdollEnabled then
        task.spawn(function()
            task.wait(0.5)
            if startAntiRagdoll then startAntiRagdoll() end
        end)
    end
    if infJumpEnabled then
        task.spawn(function()
            task.wait(0.5)
            startHoldJump()
        end)
    end
    if Steal.AutoStealEnabled then
        task.spawn(function()
            task.wait(1)
            if startAutoSteal then startAutoSteal() end
        end)
    end
    if batCounterEnabled then
        task.spawn(function()
            task.wait(1)
            if startBatCounter then startBatCounter() end
        end)
    end
    if medusaCounterEnabled then
        task.spawn(function()
            task.wait(1)
            local char = LP.Character
            if char and setupMedusa then setupMedusa(char) end
        end)
    end
    if currentSkyTheme and currentSkyTheme ~= "" then
        task.spawn(function()
            task.wait(1)
            if CandyApplyCustomSky then CandyApplyCustomSky(currentSkyTheme) end
        end)
    end
end)

-- ============================================================
-- KOLA HUB GUI (with rebuildGUILayout inside the closure)
-- ============================================================
;(function()

local PlayerGui = LP:WaitForChild("PlayerGui")

local function makeDraggable_cyber(dragTarget, moveTarget)
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
            local delta=input.Position-dragStart
            moveTarget.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)
end

local C={
    bg=Color3.fromRGB(6,6,6), bgDark=Color3.fromRGB(3,3,3), row=Color3.fromRGB(16,16,16),
    input=Color3.fromRGB(16,16,16), blue=Color3.fromRGB(210,210,210), blueDim=Color3.fromRGB(70,70,70),
    blueDark=Color3.fromRGB(22,22,22), text=Color3.fromRGB(255,255,255), textDim=Color3.fromRGB(160,160,160),
    textMuted=Color3.fromRGB(100,100,100), white=Color3.fromRGB(255,255,255), divider=Color3.fromRGB(32,32,32),
    green=Color3.fromRGB(80,220,120),
}
local function guiCorner(p,r) local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 10);c.Parent=p;return c end
local function guiStroke(p,col,t) local s=Instance.new("UIStroke");s.Color=col or Color3.fromRGB(60,60,70);s.Thickness=t or 1;s.Parent=p;return s end
local function tw(obj,props,ti) TweenService:Create(obj,ti or TweenInfo.new(0.12),props):Play() end

local GuiToggleSetters={}
local GuiRefs={}
local LeftPanel=nil

local Keys={
    circle=Enum.KeyCode.E,
    speed=Enum.KeyCode.Q,
    carryMode=Enum.KeyCode.C,
    laggerToggle=Enum.KeyCode.K,
    guiHide=Enum.KeyCode.RightControl,
    dropBrainrot=Enum.KeyCode.H,
    tpDown=Enum.KeyCode.T,
    instaReset=Enum.KeyCode.B,
    autoLeft=Enum.KeyCode.J,
    autoRight=Enum.KeyCode.L,
}
pcall(function()
    if not(isfile and isfile("Spectrum_PC.json")) then return end
    local ok,d=pcall(function() return HS:JSONDecode(readfile("Spectrum_PC.json")) end)
    if ok and type(d)=="table" and type(d.keys)=="table" then
        for k,v in pairs(d.keys) do
            local ok2,kc=pcall(function() return Enum.KeyCode[v] end)
            if ok2 and kc and kc~=Enum.KeyCode.Unknown then Keys[k]=kc end
        end
    end
end)
_GuiKeys = Keys

-- ===== rebuildGUILayout (now inside closure) =====
local function rebuildGUILayout()
    if not GuiRefs or not GuiRefs.outer then return end
    local Outer = GuiRefs.outer
    local mw = math.max(200, menuWidth or 265)
    local mh = math.max(200, menuHeight or 350)
    Outer.Size = UDim2.new(0, mw, 0, mh)

    local Inner = GuiRefs.inner
    local LeftPanel = GuiRefs.leftPanel
    local ContentFrame = GuiRefs.contentFrame
    local TopTabs = GuiRefs.topTabs

    if not LeftPanel or not ContentFrame then return end

    if TopTabs then TopTabs:Destroy(); GuiRefs.topTabs = nil end

    LeftPanel.Visible = true
    local CatList = LeftPanel:FindFirstChild("CategoryList")
    if CatList then CatList.Visible = true end

    if tabPosition == "Left" then
        LeftPanel.Size = UDim2.new(0, 85, 1, -118)
        LeftPanel.Position = UDim2.new(0, 0, 0, 63)
        ContentFrame.Size = UDim2.new(1, -85, 1, -118)
        ContentFrame.Position = UDim2.new(0, 85, 0, 63)
    elseif tabPosition == "Right" then
        LeftPanel.Size = UDim2.new(0, 85, 1, -118)
        LeftPanel.Position = UDim2.new(1, -85, 0, 63)
        ContentFrame.Size = UDim2.new(1, -85, 1, -118)
        ContentFrame.Position = UDim2.new(0, 0, 0, 63)
    elseif tabPosition == "Top" then
        LeftPanel.Visible = false
        local topBar = Instance.new("Frame")
        topBar.Name = "TopTabs"
        topBar.Size = UDim2.new(1, 0, 0, 40)
        topBar.Position = UDim2.new(0, 0, 0, 63)
        topBar.BackgroundColor3 = C.bgDark
        topBar.BackgroundTransparency = 0.5
        topBar.BorderSizePixel = 0
        topBar.Parent = Inner
        guiCorner(topBar, 8)
        GuiRefs.topTabs = topBar

        local tabLayout = Instance.new("UIListLayout")
        tabLayout.FillDirection = Enum.FillDirection.Horizontal
        tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        tabLayout.Padding = UDim.new(0, 8)
        tabLayout.Parent = topBar

        local categories = {"Speed","Combat","Steal","Movement","Visual"}
        for i, name in ipairs(categories) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 70, 0, 28)
            btn.BackgroundColor3 = (name == CategoryRefs.active) and C.blue or C.blueDark
            btn.BackgroundTransparency = 0.3
            btn.Text = name
            btn.TextColor3 = (name == CategoryRefs.active) and C.white or C.textMuted
            btn.TextSize = 10
            btn.Font = Enum.Font.GothamBold
            btn.BorderSizePixel = 0
            btn.Parent = topBar
            guiCorner(btn, 6)
            btn.MouseButton1Click:Connect(function()
                for _, f in pairs(CategoryRefs.contents) do f.Visible = false end
                local selectedPage = CategoryRefs.contents[name]
                if selectedPage then selectedPage.Visible = true end
                CategoryRefs.active = name
                for _, b in ipairs(topBar:GetChildren()) do
                    if b:IsA("TextButton") then
                        local isActive = (b.Text == name)
                        b.BackgroundColor3 = isActive and C.blue or C.blueDark
                        b.TextColor3 = isActive and C.white or C.textMuted
                    end
                end
            end)
        end

        ContentFrame.Size = UDim2.new(1, 0, 1, -118 - 40)
        ContentFrame.Position = UDim2.new(0, 0, 0, 63 + 40)
    end

    -- Ensure the inner frame updates
    task.wait()
    Inner.Size = UDim2.new(1, 0, 1, 0)
end

-- BUILD HUB GUI
;(function()
    local GuiHub=Instance.new("ScreenGui")
    GuiHub.Name="SpectrumHub"; GuiHub.ResetOnSpawn=false
    GuiHub.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; GuiHub.Parent=PlayerGui
    GuiRefs.hub=GuiHub

    local Outer=Instance.new("Frame")
    Outer.Name="Outer"; Outer.Size=UDim2.new(0, menuWidth, 0, menuHeight)
    Outer.Position=UDim2.new(0,20,0,110)
    Outer.BackgroundTransparency=1; Outer.BorderSizePixel=0; Outer.ClipsDescendants=false; Outer.Parent=GuiHub
    GuiRefs.outer=Outer

    local Inner=Instance.new("Frame")
    Inner.Name="Inner"; Inner.ClipsDescendants=true
    Inner.Size=UDim2.new(1,0,1,0)
    Inner.BackgroundColor3=C.bg; Inner.BackgroundTransparency=0; Inner.BorderSizePixel=0; Inner.Parent=Outer
    guiCorner(Inner,24); guiStroke(Inner,Color3.fromRGB(45,45,45),1.5); GuiRefs.inner=Inner

    local bgDecal = Instance.new("ImageLabel", Inner)
    bgDecal.Size = UDim2.new(1, 0, 1, 0)
    bgDecal.Position = UDim2.new(0, 0, 0, 0)
    bgDecal.BackgroundTransparency = 1
    bgDecal.Image = "rbxassetid://113953274092851"
    bgDecal.ZIndex = 1
    bgDecal.ScaleType = Enum.ScaleType.Crop
    guiCorner(bgDecal, 24)
    GuiRefs.bgDecal = bgDecal
    bgImageRef = bgDecal

    -- Header
    local HF=Instance.new("Frame")
    HF.Name="HeaderFrame"; HF.Size=UDim2.new(1,0,0,62); HF.BackgroundTransparency=1
    HF.BorderSizePixel=0; HF.Parent=Inner; HF.ZIndex=2
    makeDraggable_cyber(HF, Outer)

    local TL=Instance.new("TextLabel")
    TL.Position=UDim2.new(0,14,0,8); TL.Size=UDim2.new(1,-90,0,22); TL.BackgroundTransparency=1
    TL.Text="KOLA HUB"
    TL.TextColor3=C.text; TL.TextSize=17; TL.Font=Enum.Font.GothamBlack
    TL.TextXAlignment=Enum.TextXAlignment.Left; TL.Parent=HF; TL.ZIndex=3

    local titleShimmer = Instance.new("UIGradient", TL)
    titleShimmer.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80,80,80)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,0,0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80,80,80))
    })
    titleShimmer.Rotation = 45
    task.spawn(function()
        local t = 0
        while TL and TL.Parent do
            t = t + 0.02
            titleShimmer.Offset = Vector2.new(math.sin(t * 0.8) * 0.4, 0)
            task.wait(0.02)
        end
    end)

    local ML=Instance.new("TextLabel")
    ML.Position=UDim2.new(0,14,0,32); ML.Size=UDim2.new(0,200,0,14); ML.BackgroundTransparency=1
    ML.Text="discord.gg/kolacc"
    ML.TextColor3=C.textDim; ML.TextSize=10; ML.Font=Enum.Font.GothamBold
    ML.TextXAlignment=Enum.TextXAlignment.Left; ML.Parent=HF; ML.ZIndex=3

    local CloseBtn=Instance.new("TextButton")
    CloseBtn.Size=UDim2.new(0,28,0,28); CloseBtn.Position=UDim2.new(1,-38,0,8)
    CloseBtn.BackgroundColor3=C.bgDark; CloseBtn.BorderSizePixel=0
    CloseBtn.Text="-"; CloseBtn.TextColor3=C.textMuted; CloseBtn.Font=Enum.Font.GothamBlack; CloseBtn.TextSize=22
    CloseBtn.ZIndex=5; CloseBtn.Parent=HF
    guiCorner(CloseBtn,7); guiStroke(CloseBtn,Color3.fromRGB(45,45,45),1)
    CloseBtn.MouseEnter:Connect(function() tw(CloseBtn,{BackgroundColor3=Color3.fromRGB(28,28,28),TextColor3=C.text}) end)
    CloseBtn.MouseLeave:Connect(function() tw(CloseBtn,{BackgroundColor3=C.bgDark,TextColor3=C.textMuted}) end)

    local MiniBtn=Instance.new("TextButton")
    MiniBtn.Size=UDim2.new(0,110,0,28); MiniBtn.Position=Outer.Position
    MiniBtn.BackgroundColor3=C.bgDark; MiniBtn.BorderSizePixel=0
    MiniBtn.Text="KOLA HUB"
    MiniBtn.TextColor3=C.text; MiniBtn.Font=Enum.Font.GothamBlack; MiniBtn.TextSize=11
    MiniBtn.ZIndex=20; MiniBtn.Visible=false; MiniBtn.Parent=GuiRefs.hub
    guiCorner(MiniBtn,8); guiStroke(MiniBtn,Color3.fromRGB(45,45,45),1.2)
    makeDraggable_cyber(MiniBtn, MiniBtn)
    MiniBtn.MouseEnter:Connect(function() tw(MiniBtn,{BackgroundColor3=Color3.fromRGB(22,22,22)}) end)
    MiniBtn.MouseLeave:Connect(function() tw(MiniBtn,{BackgroundColor3=C.bgDark}) end)

    local function showGui() Outer.Visible=true; MiniBtn.Visible=false end
    local function hideGui() Outer.Visible=false; MiniBtn.Visible=true end
    CloseBtn.MouseButton1Click:Connect(hideGui)
    MiniBtn.MouseButton1Click:Connect(showGui)

    local HSep=Instance.new("Frame")
    HSep.Position=UDim2.new(0,14,0,62); HSep.Size=UDim2.new(1,-28,0,1); HSep.BackgroundColor3=C.blue
    HSep.BackgroundTransparency=0.7; HSep.BorderSizePixel=0; HSep.Parent=Inner; HSep.ZIndex=2

    LeftPanel=Instance.new("Frame")
    LeftPanel.Name="LeftPanel"; LeftPanel.Size=UDim2.new(0,85,1,-118); LeftPanel.Position=UDim2.new(0,0,0,63)
    LeftPanel.BackgroundColor3=C.bgDark; LeftPanel.BackgroundTransparency=0.5; LeftPanel.BorderSizePixel=0
    LeftPanel.Parent=Inner; guiCorner(LeftPanel,12); LeftPanel.ZIndex=2
    GuiRefs.leftPanel = LeftPanel

    local CatList=Instance.new("ScrollingFrame")
    CatList.Name="CategoryList"; CatList.Size=UDim2.new(1,0,1,0); CatList.BackgroundTransparency=1
    CatList.BorderSizePixel=0; CatList.ScrollBarThickness=2; CatList.ScrollBarImageColor3=C.blue
    CatList.CanvasSize=UDim2.new(0,0,0,0); CatList.AutomaticCanvasSize=Enum.AutomaticSize.Y; CatList.Active=true; CatList.Parent=LeftPanel
    local CatLay=Instance.new("UIListLayout"); CatLay.SortOrder=Enum.SortOrder.LayoutOrder; CatLay.Padding=UDim.new(0,4); CatLay.Parent=CatList
    CatLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() CatList.CanvasSize = UDim2.new(0, 0, 0, CatLay.AbsoluteContentSize.Y + 25) end)
    local CatPad=Instance.new("UIPadding"); CatPad.PaddingLeft=UDim.new(0,6); CatPad.PaddingRight=UDim.new(0,6)
    CatPad.PaddingTop=UDim.new(0,10); CatPad.PaddingBottom=UDim.new(0,10); CatPad.Parent=CatList
    GuiRefs.categoryList=CatList

    local CF=Instance.new("ScrollingFrame")
    CF.Name="ContentFrame"; CF.Size=UDim2.new(1,-85,1,-118); CF.Position=UDim2.new(0,85,0,63)
    CF.BackgroundTransparency=1; CF.BorderSizePixel=0; CF.ScrollBarThickness=6; CF.ScrollBarImageColor3=C.blue
    CF.CanvasSize=UDim2.new(0,0,0,0); CF.AutomaticCanvasSize=Enum.AutomaticSize.Y
    CF.ScrollingDirection=Enum.ScrollingDirection.Y; CF.ScrollingEnabled=true; CF.Active=true
    CF.ElasticBehavior=Enum.ElasticBehavior.Never; CF.Parent=Inner; GuiRefs.contentFrame=CF
    local CLay=Instance.new("UIListLayout"); CLay.SortOrder=Enum.SortOrder.LayoutOrder; CLay.Padding=UDim.new(0,6); CLay.Parent=CF
    CLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() CF.CanvasSize = UDim2.new(0, 0, 0, CLay.AbsoluteContentSize.Y + 25) end)
    local CPad=Instance.new("UIPadding"); CPad.PaddingLeft=UDim.new(0,12); CPad.PaddingRight=UDim.new(0,12)
    CPad.PaddingTop=UDim.new(0,10); CPad.PaddingBottom=UDim.new(0,8); CPad.Parent=CF

    local BotSep=Instance.new("Frame")
    BotSep.Position=UDim2.new(0,8,1,-54); BotSep.Size=UDim2.new(1,-16,0,1); BotSep.BackgroundColor3=C.blue
    BotSep.BackgroundTransparency=0.65; BotSep.BorderSizePixel=0; BotSep.Parent=Inner; BotSep.ZIndex=2

    rebuildGUILayout()
end)()

-- KEYBIND SYSTEM
local KeyListen={cb=nil,label=nil,active=false}
local KEY_ALIASES={
    ButtonA="A",ButtonB="B",ButtonX="X",ButtonY="Y",ButtonR1="RB",ButtonR2="RT",ButtonL1="LB",ButtonL2="LT",
    DPadUp="D↑",DPadDown="D↓",DPadLeft="D←",DPadRight="D→",ButtonStart="▶",ButtonSelect="◀",
    LeftShift="LShift",RightShift="RShift",LeftControl="LCtrl",RightControl="RCtrl",LeftAlt="LAlt",RightAlt="RAlt",
    LeftSuper="LSuper",RightSuper="RSuper",Return="Enter",BackSpace="Backspace",Tab="Tab",CapsLock="CapsLock",
    Escape="Esc",Space="Space",PageUp="PgUp",PageDown="PgDn",End="End",Home="Home",Insert="Ins",Delete="Del",
    Up="↑",Down="↓",Left="←",Right="→",F1="F1",F2="F2",F3="F3",F4="F4",F5="F5",F6="F6",F7="F7",F8="F8",
    F9="F9",F10="F10",F11="F11",F12="F12",Print="PrtScn",ScrollLock="ScrLk",Pause="Pause",
    Minus="-",Equals="=",LeftBracket="[",RightBracket="]",BackSlash="\\",Semicolon=";",Quote="'",
    Comma=",",Period=".",Slash="/",Backquote="`"
}
local function prettyKey(kc) return KEY_ALIASES[kc.Name] or kc.Name end
local function cancelKL()
    if KeyListen.label then KeyListen.label.BackgroundColor3=C.blue; KeyListen.label.BackgroundTransparency=0.5 end
    KeyListen.cb=nil; KeyListen.label=nil; KeyListen.active=false
end
local function startKL(lbl,onSet)
    cancelKL(); KeyListen.cb=onSet; KeyListen.label=lbl; KeyListen.active=true
    lbl.Text="..."; lbl.BackgroundColor3=Color3.fromRGB(80,220,120); lbl.BackgroundTransparency=0.3
    local cap=lbl; task.delay(8,function() if KeyListen.label==cap and KeyListen.active then cancelKL(); if lbl and lbl.Parent then lbl.Text=prettyKey(Keys.guiHide); lbl.BackgroundColor3=C.blue; lbl.BackgroundTransparency=0.5 end end end)
end
UIS.InputBegan:Connect(function(inp,gp)
    if not KeyListen.active then return end; if gp then return end
    local ut=inp.UserInputType
    if ut~=Enum.UserInputType.Keyboard and ut~=Enum.UserInputType.Gamepad1 then return end
    local k=inp.KeyCode
    if k==Enum.KeyCode.Unknown then return end
    if k==Enum.KeyCode.Escape then cancelKL(); return end
    local cb=KeyListen.cb; local lb=KeyListen.label; cancelKL()
    if lb and lb.Parent then lb.Text=prettyKey(k); lb.BackgroundColor3=C.blue; lb.BackgroundTransparency=0.5 end
    if cb then task.spawn(cb,k) end
end)

-- ROW BUILDERS
local function addSectLbl(parent,text,order)
    local w=Instance.new("Frame",parent); w.Size=UDim2.new(1,0,0,22); w.BackgroundTransparency=1; w.LayoutOrder=order
    local L=Instance.new("TextLabel",w); L.Size=UDim2.new(1,0,0,16); L.BackgroundTransparency=1
    L.Text=text; L.TextColor3=C.textDim; L.TextSize=10; L.Font=Enum.Font.GothamBold; L.TextXAlignment=Enum.TextXAlignment.Left
    return L
end
local function addInputRow(parent,label,value,order,cb)
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,36); Row.BackgroundColor3=C.row
    Row.BackgroundTransparency=0.5; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,10); guiStroke(Row,C.divider,1)
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.6,0,0,16); Lb.Position=UDim2.new(0,12,0,6)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=C.text; Lb.TextSize=11; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    local BC=Instance.new("Frame",Row); BC.ZIndex=6; BC.Position=UDim2.new(1,-58,0.5,-10); BC.Size=UDim2.new(0,48,0,20)
    BC.BackgroundColor3=C.input; BC.BackgroundTransparency=0.5; BC.BorderSizePixel=0; guiCorner(BC,6); guiStroke(BC,Color3.fromRGB(55,55,60),1)
    local Box=Instance.new("TextBox",BC); Box.ZIndex=7; Box.Size=UDim2.new(1,0,1,0); Box.BackgroundTransparency=1
    Box.Text=tostring(value); Box.TextColor3=C.text; Box.TextSize=11; Box.Font=Enum.Font.GothamBold; Box.ClearTextOnFocus=false
    Box.FocusLost:Connect(function() local n=tonumber(Box.Text); if n and n>0 then cb(n) else Box.Text=tostring(value) end end)
    local hov=Instance.new("TextButton",Row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
    hov.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end); hov.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.5}) end)
    return Row,Box
end
local function addToggleRow(parent,label,enabled,order,kbKey,onToggle)
    local hasKB=kbKey~=nil
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,hasKB and 50 or 38); Row.BackgroundColor3=C.row
    Row.BackgroundTransparency=0.5; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,10); guiStroke(Row,C.divider,1)
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.6,0,0,16); Lb.Position=UDim2.new(0,12,0,6)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=C.text; Lb.TextSize=11; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    if hasKB and Keys[kbKey] then
        local KB2=Instance.new("TextButton",Row); KB2.Size=UDim2.new(0,35,0,16); KB2.Position=UDim2.new(0,12,1,-20)
        KB2.BackgroundColor3=C.blue; KB2.BackgroundTransparency=0.5; KB2.BorderSizePixel=0; KB2.Text=prettyKey(Keys[kbKey])
        KB2.TextColor3=C.white; KB2.TextSize=9; KB2.Font=Enum.Font.GothamBold; guiCorner(KB2,5)
        KB2.MouseButton1Click:Connect(function() startKL(KB2,function(nk) Keys[kbKey]=nk; KB2.Text=prettyKey(nk); saveConfig() end) end)
    end
    local Track=Instance.new("Frame",Row); Track.Size=UDim2.new(0,36,0,18); Track.Position=UDim2.new(1,-46,0,10)
    Track.BackgroundColor3=C.blueDark; Track.BackgroundTransparency=0.5; Track.BorderSizePixel=0; guiCorner(Track,10); guiStroke(Track,C.blueDim,1)
    local Knob=Instance.new("Frame",Track); Knob.Size=UDim2.new(0,14,0,14)
    Knob.Position=enabled and UDim2.new(0.5,2,0.5,-7) or UDim2.new(0,2,0.5,-7)
    Knob.BackgroundColor3=C.blue; Knob.BackgroundTransparency=enabled and 0.3 or 0.5; Knob.BorderSizePixel=0; guiCorner(Knob,7)
    local st=enabled
    local function setV(on) st=on; tw(Knob,{Position=on and UDim2.new(0.5,2,0.5,-7) or UDim2.new(0,2,0.5,-7)}); tw(Knob,{BackgroundTransparency=on and 0.3 or 0.5}) end
    local Btn=Instance.new("TextButton",Row); Btn.Size=UDim2.new(0,36,0,18); Btn.Position=UDim2.new(1,-46,0,10); Btn.BackgroundTransparency=1; Btn.Text=""
    Btn.MouseButton1Click:Connect(function() st=not st; setV(st); if onToggle then onToggle(st) end end)
    local hov=Instance.new("TextButton",Row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
    hov.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end); hov.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.5}) end)
    if kbKey then GuiToggleSetters[kbKey]=setV end
    return Row,setV
end
local function addActionRow(parent,label,kbKey,onAction,order)
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,42); Row.BackgroundColor3=C.row
    Row.BackgroundTransparency=0.5; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,10); guiStroke(Row,C.divider,1)
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.55,0,0,16); Lb.Position=UDim2.new(0,12,0,8)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=C.text; Lb.TextSize=11; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    if kbKey and Keys[kbKey] then
        local KB2=Instance.new("TextButton",Row); KB2.Size=UDim2.new(0,40,0,22); KB2.Position=UDim2.new(1,-48,0.5,-11)
        KB2.BackgroundColor3=C.blue; KB2.BackgroundTransparency=0.5; KB2.BorderSizePixel=0; KB2.Text=prettyKey(Keys[kbKey])
        KB2.TextColor3=C.white; KB2.TextSize=9; KB2.Font=Enum.Font.GothamBold; guiCorner(KB2,5)
        KB2.MouseButton1Click:Connect(function() startKL(KB2,function(nk) Keys[kbKey]=nk; KB2.Text=prettyKey(nk); saveConfig() end) end)
    end
    local AB=Instance.new("TextButton",Row); AB.Size=UDim2.new(0.55,0,1,0); AB.BackgroundTransparency=1; AB.Text=""; AB.MouseButton1Click:Connect(onAction)
    local hov=Instance.new("TextButton",Row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
    hov.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end); hov.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.5}) end)
    return Row
end
local function addCycleRow(parent,label,value,order,onCycle)
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,38); Row.BackgroundColor3=C.row
    Row.BackgroundTransparency=0.5; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,10); guiStroke(Row,C.divider,1)
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.6,0,0,16); Lb.Position=UDim2.new(0,12,0,6)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=C.text; Lb.TextSize=11; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    local CB=Instance.new("TextButton",Row); CB.Size=UDim2.new(0,60,0,22); CB.Position=UDim2.new(1,-72,0.5,-11)
    CB.BackgroundColor3=C.blue; CB.BackgroundTransparency=0.5; CB.BorderSizePixel=0; CB.Text=value
    CB.TextColor3=C.white; CB.TextSize=10; CB.Font=Enum.Font.GothamBold; guiCorner(CB,5)
    CB.MouseButton1Click:Connect(function() local nv=onCycle(); CB.Text=nv end)
    local hov=Instance.new("TextButton",Row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
    hov.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end); hov.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.5}) end)
    return Row,CB
end

-- CATEGORY SETUP
local Categories={"Speed","Combat","Steal","Movement","Visual"}
local CategoryRefs={contents={},btnsSide={},active="Speed"}
;(function()
    for _,name in pairs(Categories) do
        local page=Instance.new("Frame"); page.Size=UDim2.new(1,0,1,0); page.BackgroundTransparency=1
        page.Visible=(name=="Speed"); page.Parent=GuiRefs.contentFrame; CategoryRefs.contents[name]=page
        local lay=Instance.new("UIListLayout"); lay.SortOrder=Enum.SortOrder.LayoutOrder; lay.Padding=UDim.new(0,6); lay.Parent=page
    end
    for i,name in ipairs(Categories) do
        local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,0,32); btn.BackgroundColor3=C.blueDark
        btn.BackgroundTransparency=0.3; btn.Text=name; btn.TextColor3=(name=="Speed") and C.white or C.textMuted
        btn.TextSize=10; btn.Font=Enum.Font.GothamBold; btn.BorderSizePixel=0; btn.LayoutOrder=i; btn.Parent=GuiRefs.categoryList; guiCorner(btn,6)
        local ind=Instance.new("Frame"); ind.Name="indicator"; ind.Size=UDim2.new(0,2,0,16); ind.Position=UDim2.new(1,-2,0.5,-8)
        ind.BackgroundColor3=C.blue; ind.BackgroundTransparency=(name=="Speed") and 0.3 or 1; ind.BorderSizePixel=0; ind.Parent=btn
        CategoryRefs.btnsSide[name]=btn
        btn.MouseButton1Click:Connect(function()
            for _,f in pairs(CategoryRefs.contents) do f.Visible=false end
            local selectedPage = CategoryRefs.contents[name]
            selectedPage.Visible=true; CategoryRefs.active=name
            for n,b in pairs(CategoryRefs.btnsSide) do
                local ac=(n==name); b.TextColor3=ac and C.white or C.textMuted; b.BackgroundTransparency=ac and 0.2 or 0.3
                local i2=b:FindFirstChild("indicator"); if i2 then i2.BackgroundTransparency=ac and 0.3 or 1 end
            end
            local lay = selectedPage:FindFirstChildOfClass("UIListLayout")
            if lay then GuiRefs.contentFrame.CanvasSize = UDim2.new(0, 0, 0, lay.AbsoluteContentSize.Y + 25) end
        end)
        btn.MouseEnter:Connect(function() if CategoryRefs.active~=name then btn.TextColor3=C.textDim; btn.BackgroundTransparency=0.25 end end)
        btn.MouseLeave:Connect(function() if CategoryRefs.active~=name then btn.TextColor3=C.textMuted; btn.BackgroundTransparency=0.3 end end)
    end
    local spBtn=CategoryRefs.btnsSide["Speed"]
    if spBtn then spBtn.TextColor3=C.white; spBtn.BackgroundTransparency=0.2; local i2=spBtn:FindFirstChild("indicator"); if i2 then i2.BackgroundTransparency=0.3 end end
end)()

-- SPEED PAGE
;(function()
    local sp=CategoryRefs.contents["Speed"]
    addSectLbl(sp,"SPEED CONFIGURATION",0)
    addInputRow(sp,"Normal Speed",NS,1,function(v) NS=v; saveConfig() end)
    addInputRow(sp,"Carry Speed",CS,2,function(v) CS=v; saveConfig() end)
    addSectLbl(sp,"LAGGER MODE",3)
    addInputRow(sp,"Lagger Normal",LAGGER_SPEED,4,function(v) LAGGER_SPEED=v; saveConfig() end)
    addInputRow(sp,"Lagger Carry",LAGGER_CARRY_SPEED,5,function(v) LAGGER_CARRY_SPEED=v; saveConfig() end)
    addSectLbl(sp,"CONTROLS",6)
    addToggleRow(sp,"Carry Mode",carrySpeedActive,7,"carryMode",function(on)
        carrySpeedActive = on
        if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
        if refreshSpeedModeLabel then refreshSpeedModeLabel() end
        saveConfig()
    end)
    addToggleRow(sp,"Lagger Mode",laggerModeEnabled,8,"laggerToggle",function(on)
        laggerModeEnabled=on; if mobBtnRefs.lagger then mobBtnRefs.lagger(on) end
        if refreshSpeedModeLabel then refreshSpeedModeLabel() end; saveConfig()
    end)
end)()

-- COMBAT PAGE
;(function()
    local cp=CategoryRefs.contents["Combat"]
    addSectLbl(cp,"BAT CONTROLS",0)
    local _,svAutoBat=addToggleRow(cp,"Bat Aimbot",autoBatEnabled,1,"circle",function(on)
        if on then
            if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            queueAutoBatStart();if mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
        else stopBatAimbot();if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
        saveConfig()
    end)
    autoBatSetVisual=svAutoBat
    local _,svAutoSwing=addToggleRow(cp,"Auto Swing",autoSwingEnabled,2,nil,function(on) autoSwingEnabled=on;saveConfig() end)
    local _,svBatCounter=addToggleRow(cp,"Bat Counter",batCounterEnabled,3,nil,function(on) batCounterEnabled=on;if on then startBatCounter() else stopBatCounter() end;saveConfig() end)
    setBatCounterVisual=svBatCounter
    addSectLbl(cp,"RAGDOLL",4)
    local _,svRagdoll=addToggleRow(cp,"Anti Ragdoll",antiRagdollEnabled,5,nil,function(on) antiRagdollEnabled=on;if on then startAntiRagdoll() else stopAntiRagdoll() end;saveConfig() end)
    setAntiRagVisual=svRagdoll
    if antiRagdollEnabled then svRagdoll(true) end
    local _,svMedusa=addToggleRow(cp,"Medusa Counter",medusaCounterEnabled,6,nil,function(on) medusaCounterEnabled=on;if on then setupMedusa(LP.Character) else stopMedusaCounter() end;saveConfig() end)
    setMedusaVisual=svMedusa
    local _,svUnwalk=addToggleRow(cp,"Unwalk",unwalkEnabled,7,nil,function(on) unwalkEnabled=on;if on then startUnwalk() else stopUnwalk() end;saveConfig() end)
    setUnwalkVisual=svUnwalk
    addSectLbl(cp,"ACTIONS",9)
    addActionRow(cp,"Drop Brainrot","dropBrainrot",function() runDrop() end,10)
    addActionRow(cp,"Insta Reset","instaReset",function() cursedInstaReset() end,11)
    addActionRow(cp,"TP Down","tpDown",function() runTPFloor() end,12)
end)()

-- STEAL PAGE
;(function()
    local st=CategoryRefs.contents["Steal"]
    addSectLbl(st,"AUTO STEAL",0)
    addToggleRow(st,"Auto Steal",Steal.AutoStealEnabled,1,nil,function(on)
        Steal.AutoStealEnabled=on
        if on then startAutoSteal() else stopAutoSteal() end
        saveConfig()
    end)
    addInputRow(st,"Steal Radius",Steal.StealRadius,2,function(v) Steal.StealRadius=tonumber(v) or 60; saveConfig() end)
    addInputRow(st,"Steal Duration",Steal.StealDuration,3,function(v) Steal.StealDuration=tonumber(v) or 1.4; saveConfig() end)
end)()

-- MOVEMENT PAGE
;(function()
    local mv=CategoryRefs.contents["Movement"]
    addSectLbl(mv,"AUTO PATHS",0)
    local _,svAutoLeft=addToggleRow(mv,"Auto Left",autoLeftEnabled,1,"autoLeft",function(on)
        if on then
            if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoLeftEnabled=true;startAutoLeft();if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(true) end
        else autoLeftEnabled=false;stopAutoLeft();if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
        saveConfig()
    end)
    autoLeftSetVisual=svAutoLeft
    local _,svAutoRight=addToggleRow(mv,"Auto Right",autoRightEnabled,2,"autoRight",function(on)
        if on then
            if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoRightEnabled=true;startAutoRight();if mobBtnRefs.autoRight then mobBtnRefs.autoRight(true) end
        else autoRightEnabled=false;stopAutoRight();if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
        saveConfig()
    end)
    autoRightSetVisual=svAutoRight
    addSectLbl(mv,"SETTINGS",3)
    local _,svHoldJump=addToggleRow(mv,"Hold Jump",infJumpEnabled,4,nil,function(on)
        infJumpEnabled=on; if on then startHoldJump() else stopHoldJump() end; saveConfig()
    end)
    setInfJumpVisual=svHoldJump
end)()

-- VISUAL PAGE (with all new settings)
;(function()
    local vi=CategoryRefs.contents["Visual"]

    addSectLbl(vi,"VISUAL",0)
    addToggleRow(vi,"Zombie Anims (Rembembi)",animEnabled,1,nil,function(on)
        animEnabled=on; if on then startAnimToggle() else stopAnimToggle() end; saveConfig()
    end)
    addToggleRow(vi,"Intro Song",introSoundEnabled,2,nil,function(on)
        introSoundEnabled=on
        if not on and introSoundInstance and introSoundInstance.IsPlaying then pcall(function() introSoundInstance:Stop() end) end
        saveConfig()
    end)
    addToggleRow(vi,"Anti Lag",antiLagEnabled,3,nil,function(on) if on then enableAntiLag() else disableAntiLag() end;saveConfig() end)
    addToggleRow(vi,"Stretch Rez",stretchRezEnabled,4,nil,function(on) if on then enableStretchRez() else disableStretchRez() end;saveConfig() end)
    addToggleRow(vi,"Ragdoll GUI",ragdollGuiEnabled,5,nil,function(on) ragdollGuiEnabled=on;saveConfig() end)

    -- TAB CHANGER
    addSectLbl(vi,"TAB CHANGER",6)
    local tabPositions = {"Left","Right","Top"}
    local tabIdx = 1
    for i, v in ipairs(tabPositions) do if v == tabPosition then tabIdx = i break end end
    local _, tabCycle = addCycleRow(vi, "Tab Position", tabPosition, 7, function()
        tabIdx = tabIdx % #tabPositions + 1
        tabPosition = tabPositions[tabIdx]
        rebuildGUILayout()
        saveConfig()
        return tabPosition
    end)

    -- BUTTON STYLE
    addSectLbl(vi,"MOBILE BUTTONS",8)
    local styles = {"Cubes","Circular"}
    local styleIdx = 1
    for i, v in ipairs(styles) do if v == buttonStyle then styleIdx = i break end end
    local _, styleCycle = addCycleRow(vi, "Button Style", buttonStyle, 9, function()
        styleIdx = styleIdx % #styles + 1
        buttonStyle = styles[styleIdx]
        buildMobileButtons()
        saveConfig()
        return buttonStyle
    end)

    -- BUTTON WIDTH
    local _, wBox = addInputRow(vi, "W Button Size", mobileButtonWidth, 10, function(v)
        if v and v >= 30 then mobileButtonWidth = v; buildMobileButtons(); saveConfig() end
    end)
    -- BUTTON HEIGHT
    local _, hBox = addInputRow(vi, "H Button Size", mobileButtonHeight, 11, function(v)
        if v and v >= 30 then mobileButtonHeight = v; buildMobileButtons(); saveConfig() end
    end)
    -- OUTLINE SIZE
    local _, outBox = addInputRow(vi, "Outline Size", mobileButtonOutline, 12, function(v)
        if v and v >= 0 then mobileButtonOutline = v; buildMobileButtons(); saveConfig() end
    end)

    -- TEXT SIZER
    addSectLbl(vi,"TEXT SIZER",13)
    local tsRow=Instance.new("Frame"); tsRow.Size=UDim2.new(1,0,0,38); tsRow.BackgroundColor3=C.row
    tsRow.BackgroundTransparency=0.5; tsRow.BorderSizePixel=0; tsRow.LayoutOrder=14; tsRow.Parent=vi
    guiCorner(tsRow,10); guiStroke(tsRow,C.divider,1)
    local tsLbl=Instance.new("TextLabel",tsRow); tsLbl.Size=UDim2.new(0.4,0,0,16); tsLbl.Position=UDim2.new(0,12,0,6)
    tsLbl.BackgroundTransparency=1; tsLbl.Text="Text Sizer"; tsLbl.TextColor3=C.text; tsLbl.TextSize=11; tsLbl.Font=Enum.Font.GothamBold; tsLbl.TextXAlignment=Enum.TextXAlignment.Left

    local minusBtn=Instance.new("TextButton",tsRow); minusBtn.Size=UDim2.new(0,28,0,22); minusBtn.Position=UDim2.new(1,-102,0.5,-11)
    minusBtn.BackgroundColor3=C.blue; minusBtn.BackgroundTransparency=0.5; minusBtn.BorderSizePixel=0; minusBtn.Text="-"
    minusBtn.TextColor3=C.white; minusBtn.TextSize=14; minusBtn.Font=Enum.Font.GothamBold; guiCorner(minusBtn,5)
    local tsPct=Instance.new("TextLabel",tsRow); tsPct.Size=UDim2.new(0,40,0,22); tsPct.Position=UDim2.new(1,-64,0.5,-11)
    tsPct.BackgroundTransparency=1; tsPct.Text="100%"; tsPct.TextColor3=C.text; tsPct.TextSize=11; tsPct.Font=Enum.Font.GothamBold; tsPct.TextXAlignment=Enum.TextXAlignment.Center
    local plusBtn=Instance.new("TextButton",tsRow); plusBtn.Size=UDim2.new(0,28,0,22); plusBtn.Position=UDim2.new(1,-28,0.5,-11)
    plusBtn.BackgroundColor3=C.blue; plusBtn.BackgroundTransparency=0.5; plusBtn.BorderSizePixel=0; plusBtn.Text="+"
    plusBtn.TextColor3=C.white; plusBtn.TextSize=14; plusBtn.Font=Enum.Font.GothamBold; guiCorner(plusBtn,5)

    local function updateTextSizePercent()
        local base = 12.5
        local pct = math.round((mobileTextSize / base) * 100)
        tsPct.Text = tostring(pct) .. "%"
    end
    updateTextSizePercent()

    minusBtn.MouseButton1Click:Connect(function()
        local step = 0.5
        mobileTextSize = math.max(8, mobileTextSize - step)
        buildMobileButtons()
        updateTextSizePercent()
        saveConfig()
    end)
    plusBtn.MouseButton1Click:Connect(function()
        local step = 0.5
        mobileTextSize = math.min(30, mobileTextSize + step)
        buildMobileButtons()
        updateTextSizePercent()
        saveConfig()
    end)

    -- MENU SIZE
    addSectLbl(vi,"MENU SIZE",15)
    local _, mwBox = addInputRow(vi, "W Menu Size", menuWidth, 16, function(v)
        if v and v >= 200 then menuWidth = v; rebuildGUILayout(); saveConfig() end
    end)
    local _, mhBox = addInputRow(vi, "H Menu Size", menuHeight, 17, function(v)
        if v and v >= 200 then menuHeight = v; rebuildGUILayout(); saveConfig() end
    end)

    -- BACKGROUND IMAGES
    addSectLbl(vi,"BACKGROUND IMAGE",18)
    local BgRow=Instance.new("Frame"); BgRow.Size=UDim2.new(1,0,0,195); BgRow.BackgroundColor3=C.row
    BgRow.BackgroundTransparency=0.5; BgRow.BorderSizePixel=0; BgRow.LayoutOrder=19; BgRow.ZIndex=2; BgRow.Parent=vi
    guiCorner(BgRow,10); guiStroke(BgRow,C.divider,1)

    local ImgContainer=Instance.new("ScrollingFrame", BgRow)
    ImgContainer.Size=UDim2.new(1,-32,1,-24); ImgContainer.Position=UDim2.new(0,16,0,12)
    ImgContainer.BackgroundTransparency=1; ImgContainer.BorderSizePixel=0
    ImgContainer.ScrollBarThickness=4; ImgContainer.ScrollBarImageColor3=C.blue
    ImgContainer.CanvasSize=UDim2.new(0,0,0,0); ImgContainer.AutomaticCanvasSize=Enum.AutomaticSize.Y
    ImgContainer.ScrollingDirection=Enum.ScrollingDirection.Y
    ImgContainer.ElasticBehavior=Enum.ElasticBehavior.Never; ImgContainer.Active=true
    guiCorner(ImgContainer,6)

    local UGL=Instance.new("UIGridLayout", ImgContainer)
    UGL.CellSize=UDim2.new(0,84,0,48); UGL.CellPadding=UDim2.new(0,8,0,8); UGL.SortOrder=Enum.SortOrder.LayoutOrder
    UGL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ImgContainer.CanvasSize=UDim2.new(0,0,0,UGL.AbsoluteContentSize.Y+8)
    end)

    local Ss={}
    for i=1,#BG_IMAGES do
        local Prev=Instance.new("Frame",ImgContainer); Prev.LayoutOrder=i
        Prev.BackgroundColor3=Color3.fromRGB(25,25,30); Prev.BorderSizePixel=0; guiCorner(Prev,7)
        Ss[i]=guiStroke(Prev,backgroundIndex==i and C.blue or C.divider,1.5)
        local Img=Instance.new("ImageLabel",Prev); Img.Size=UDim2.new(1,0,1,0); Img.BackgroundTransparency=1
        Img.Image="rbxassetid://"..BG_IMAGES[i]; Img.ScaleType=Enum.ScaleType.Crop; guiCorner(Img,7)
        local B=Instance.new("TextButton",Prev); B.Size=UDim2.new(1,0,1,0); B.BackgroundTransparency=1; B.Text=""
        B.MouseButton1Click:Connect(function()
            backgroundIndex=i; backgroundEnabled=true
            if GuiRefs.bgDecal then GuiRefs.bgDecal.Image="rbxassetid://"..BG_IMAGES[i]; GuiRefs.bgDecal.Visible=true end
            updBg(i); saveConfig()
        end)
    end
    local function updBg(idx)
        for i=1,#BG_IMAGES do Ss[i].Color=idx==i and C.blue or C.divider end
    end
    BgRow.MouseEnter:Connect(function() tw(BgRow,{BackgroundTransparency=0.3}) end)
    BgRow.MouseLeave:Connect(function() tw(BgRow,{BackgroundTransparency=0.5}) end)

    -- SKY THEME
    addSectLbl(vi,"SKY THEME",20)
    local skyIdx=1; for i,t in ipairs(SkyOrder) do if t==currentSkyTheme then skyIdx=i;break end end
    local skyRow=Instance.new("Frame"); skyRow.Size=UDim2.new(1,0,0,38); skyRow.BackgroundColor3=C.row
    skyRow.BackgroundTransparency=0.5; skyRow.BorderSizePixel=0; skyRow.LayoutOrder=21; skyRow.Parent=vi
    guiCorner(skyRow,10); guiStroke(skyRow,C.divider,1)
    local skyLbl=Instance.new("TextLabel",skyRow); skyLbl.Size=UDim2.new(0.45,0,0,16); skyLbl.Position=UDim2.new(0,12,0,6)
    skyLbl.BackgroundTransparency=1; skyLbl.Text="Sky Theme"; skyLbl.TextColor3=C.text; skyLbl.TextSize=11; skyLbl.Font=Enum.Font.GothamBold; skyLbl.TextXAlignment=Enum.TextXAlignment.Left
    local skyVal=Instance.new("TextLabel",skyRow); skyVal.Size=UDim2.new(0,80,0,16); skyVal.Position=UDim2.new(1,-130,0,6)
    skyVal.BackgroundTransparency=1; skyVal.Text=currentSkyTheme; skyVal.TextColor3=C.textDim; skyVal.TextSize=9; skyVal.Font=Enum.Font.GothamBold; skyVal.TextXAlignment=Enum.TextXAlignment.Right
    local skyBtn=Instance.new("TextButton",skyRow); skyBtn.Size=UDim2.new(0,44,0,22); skyBtn.Position=UDim2.new(1,-52,0.5,-11)
    skyBtn.BackgroundColor3=C.blue; skyBtn.BackgroundTransparency=0.5; skyBtn.BorderSizePixel=0; skyBtn.Text="Next"
    skyBtn.TextColor3=C.white; skyBtn.TextSize=9; skyBtn.Font=Enum.Font.GothamBold; guiCorner(skyBtn,5)
    skyBtn.MouseButton1Click:Connect(function()
        skyIdx=skyIdx%#SkyOrder+1; currentSkyTheme=SkyOrder[skyIdx]; skyVal.Text=currentSkyTheme; CandyApplyCustomSky(currentSkyTheme); saveConfig()
    end)
    local hov2=Instance.new("TextButton",skyRow); hov2.Size=UDim2.new(1,0,1,0); hov2.BackgroundTransparency=1; hov2.Text=""; hov2.ZIndex=0
    hov2.MouseEnter:Connect(function() tw(skyRow,{BackgroundTransparency=0.3}) end); hov2.MouseLeave:Connect(function() tw(skyRow,{BackgroundTransparency=0.5}) end)

    -- FOV
    addSectLbl(vi,"FOV",22)
    local fovRow=Instance.new("Frame"); fovRow.Size=UDim2.new(1,0,0,38); fovRow.BackgroundColor3=C.row
    fovRow.BackgroundTransparency=0.5; fovRow.BorderSizePixel=0; fovRow.LayoutOrder=23; fovRow.Parent=vi
    guiCorner(fovRow,10); guiStroke(fovRow,C.divider,1)
    local fovLbl=Instance.new("TextLabel",fovRow); fovLbl.Size=UDim2.new(0.5,0,0,16); fovLbl.Position=UDim2.new(0,12,0,6)
    fovLbl.BackgroundTransparency=1; fovLbl.Text="FOV"; fovLbl.TextColor3=C.text; fovLbl.TextSize=11; fovLbl.Font=Enum.Font.GothamBold; fovLbl.TextXAlignment=Enum.TextXAlignment.Left
    local fovBtn=Instance.new("TextButton",fovRow); fovBtn.Size=UDim2.new(0,52,0,22); fovBtn.Position=UDim2.new(1,-60,0.5,-11)
    fovBtn.BackgroundColor3=C.blue; fovBtn.BackgroundTransparency=0.5; fovBtn.BorderSizePixel=0
    fovBtn.Text=tostring(fovValue); fovBtn.TextColor3=C.white; fovBtn.TextSize=11; fovBtn.Font=Enum.Font.GothamBold; guiCorner(fovBtn,5)
    fovBtn.MouseButton1Click:Connect(function()
        fovIndex=fovIndex%#fovOptions+1; fovValue=fovOptions[fovIndex]; fovBtn.Text=tostring(fovValue); applyFOV(); saveConfig()
    end)
    local hov3=Instance.new("TextButton",fovRow); hov3.Size=UDim2.new(1,0,1,0); hov3.BackgroundTransparency=1; hov3.Text=""; hov3.ZIndex=0
    hov3.MouseEnter:Connect(function() tw(fovRow,{BackgroundTransparency=0.3}) end); hov3.MouseLeave:Connect(function() tw(fovRow,{BackgroundTransparency=0.5}) end)

    -- GUI HIDE KEY
    addSectLbl(vi,"GUI",24)
    local gRow=Instance.new("Frame"); gRow.Size=UDim2.new(1,0,0,42); gRow.BackgroundColor3=C.row
    gRow.BackgroundTransparency=0.5; gRow.BorderSizePixel=0; gRow.LayoutOrder=25; gRow.Parent=vi
    guiCorner(gRow,10); guiStroke(gRow,C.divider,1)
    local gLbl=Instance.new("TextLabel",gRow); gLbl.Size=UDim2.new(0.6,0,0,16); gLbl.Position=UDim2.new(0,12,0,8)
    gLbl.BackgroundTransparency=1; gLbl.Text="Hide GUI Key"; gLbl.TextColor3=C.text; gLbl.TextSize=11; gLbl.Font=Enum.Font.GothamBold; gLbl.TextXAlignment=Enum.TextXAlignment.Left
    local gKB=Instance.new("TextButton",gRow); gKB.Size=UDim2.new(0,45,0,22); gKB.Position=UDim2.new(1,-52,0.5,-11)
    gKB.BackgroundColor3=C.blue; gKB.BackgroundTransparency=0.5; gKB.BorderSizePixel=0; gKB.Text=prettyKey(Keys.guiHide)
    gKB.TextColor3=C.white; gKB.TextSize=9; gKB.Font=Enum.Font.GothamBold; guiCorner(gKB,5)
    gKB.MouseButton1Click:Connect(function() startKL(gKB,function(nk) Keys.guiHide=nk; gKB.Text=prettyKey(nk); saveConfig() end) end)

    -- RESET
    addSectLbl(vi,"RESET",26)
    local resetRow=Instance.new("Frame"); resetRow.Size=UDim2.new(1,0,0,38); resetRow.BackgroundColor3=C.row
    resetRow.BackgroundTransparency=0.5; resetRow.BorderSizePixel=0; resetRow.LayoutOrder=27; resetRow.Parent=vi
    guiCorner(resetRow,10); guiStroke(resetRow,C.divider,1)
    local resetLbl=Instance.new("TextLabel",resetRow); resetLbl.Size=UDim2.new(0.55,0,0,16); resetLbl.Position=UDim2.new(0,12,0,6)
    resetLbl.BackgroundTransparency=1; resetLbl.Text="Reset Settings"; resetLbl.TextColor3=C.text; resetLbl.TextSize=11; resetLbl.Font=Enum.Font.GothamBold; resetLbl.TextXAlignment=Enum.TextXAlignment.Left
    local resetBtn=Instance.new("TextButton",resetRow); resetBtn.Size=UDim2.new(0,52,0,22); resetBtn.Position=UDim2.new(1,-60,0.5,-11)
    resetBtn.BackgroundColor3=Color3.fromRGB(150,30,40); resetBtn.BackgroundTransparency=0.2; resetBtn.BorderSizePixel=0
    resetBtn.Text="RESET"; resetBtn.TextColor3=C.white; resetBtn.TextSize=9; resetBtn.Font=Enum.Font.GothamBold; guiCorner(resetBtn,5)
    resetBtn.MouseButton1Click:Connect(function() resetAllSettings() end)
    local hov4=Instance.new("TextButton",resetRow); hov4.Size=UDim2.new(1,0,1,0); hov4.BackgroundTransparency=1; hov4.Text=""; hov4.ZIndex=0
    hov4.MouseEnter:Connect(function() tw(resetRow,{BackgroundTransparency=0.3}) end); hov4.MouseLeave:Connect(function() tw(resetRow,{BackgroundTransparency=0.5}) end)
end)()

-- KEYBOARD SHORTCUTS
UIS.InputBegan:Connect(function(inp,gp)
    if gp then return end
    if UIS:GetFocusedTextBox() then return end
    if inp.KeyCode==Keys.guiHide then if GuiRefs.outer then GuiRefs.outer.Visible=not GuiRefs.outer.Visible end
    elseif inp.KeyCode==Keys.speed then speedToggleAction(); saveConfig()
    elseif inp.KeyCode==Keys.carryMode then toggleCarryMode(); saveConfig()
    elseif inp.KeyCode==Keys.laggerToggle then toggleLaggerMode(); saveConfig()
    elseif inp.KeyCode==Keys.circle then autoBatEnabled=not autoBatEnabled; if autoBatEnabled then startBatAimbot() else stopBatAimbot() end; saveConfig()
    elseif inp.KeyCode==Keys.dropBrainrot then runDrop()
    elseif inp.KeyCode==Keys.tpDown then runTPFloor()
    elseif inp.KeyCode==Keys.instaReset then cursedInstaReset()
    elseif inp.KeyCode==Keys.autoLeft then
        if autoLeftEnabled then
            autoLeftEnabled=false; stopAutoLeft()
        else
            if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoLeftEnabled=true; startAutoLeft()
        end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
        if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end
    elseif inp.KeyCode==Keys.autoRight then
        if autoRightEnabled then
            autoRightEnabled=false; stopAutoRight()
        else
            if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoRightEnabled=true; startAutoRight()
        end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
        if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end
    end
end)

-- STARTUP
if infJumpEnabled then startHoldJump() end
if antiRagdollEnabled then startAntiRagdoll() end
if medusaCounterEnabled then setupMedusa(LP.Character) end
if animEnabled then startAnimToggle() end
if backgroundIndex>0 then applyBackgroundImage(backgroundIndex) end
CandyApplyCustomSky(currentSkyTheme)
buildMobileButtons()

end)() -- end GUI function

print("KOLA HUB")
print("LEKAD BY FRNK33.")
print("discord.gg/kolacc")