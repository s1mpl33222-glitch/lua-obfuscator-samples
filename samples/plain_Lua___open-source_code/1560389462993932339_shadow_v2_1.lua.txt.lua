--[[LFWM1_XFYgxFhwlXshNr89c7mk9e7UnYTV0AVw]]
do
  local lfwm_7e97626092df4313 = "LFWM1_XFYgxFhwlXshNr89c7mk9e7UnYTV0AVw"
  if false then error(lfwm_7e97626092df4313) end
end

-- [[ Shadow ]] - Menu ribassato, barra furto bianca, pulsanti mobili trascinabili singolarmente
-- No background image, infinite jump (BodyVelocity anti-kick), smooth page scrolling

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local player = Players.LocalPlayer

-- Master table
local M = {}

-- ------------------------------------------------------------
-- EARLY CONFIG LOAD
-- ------------------------------------------------------------
M.introSoundEnabled = true
M.introSongChoice = 3
M.introGUIEnabled = true
-- Fixed intro track (Shadow.VS / SHADOW 2.1 style) — not changeable
M.INTRO_MUSIC_URL = "https://files.catbox.moe/qhpfe5.mp3"
M.INTRO_MUSIC_FILE = "ShadowIntro_Music.mp3"
introSoundInstance = nil
if isfile and isfile("CherryConfig.json") then
    local ok, data = pcall(function() return HS:JSONDecode(readfile("CherryConfig.json")) end)
    if ok and type(data) == "table" then
        if data.introSoundEnabled ~= nil then M.introSoundEnabled = data.introSoundEnabled end
        if data.introSongChoice then M.introSongChoice = data.introSongChoice end
        if data.introGUIEnabled ~= nil then M.introGUIEnabled = data.introGUIEnabled end
        if type(data.Theme) == "string" then M._savedTheme = data.Theme end
        if type(data.colorScheme) == "string" then M._savedTheme = data.colorScheme end
    end
end

-- ============================================================
-- SKY THEME (unchanged)
-- ============================================================
M.CANDY_SKY_TAG = "MoveeSkyTheme"
M.currentSkyTheme = "Night"
M.CANDY_SKY_PRESETS = {
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
    ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.55,dens=0.55,color={200,150,255}}},
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
M.SkyOrder = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}

local function candyColor(rgb) return Color3.fromRGB(rgb[1],rgb[2],rgb[3]) end
function M.CandyApplyCustomSky(mode)
    for _,child in ipairs(Lighting:GetChildren()) do if child:GetAttribute(M.CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end
    local terrain=workspace:FindFirstChildOfClass("Terrain")
    if terrain then for _,child in ipairs(terrain:GetChildren()) do if child:GetAttribute(M.CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end end
    local preset=M.CANDY_SKY_PRESETS[mode]
    if not preset or preset.kind=="off" then Lighting.ClockTime=14;Lighting.Brightness=2;Lighting.OutdoorAmbient=Color3.fromRGB(127,127,127);Lighting.Ambient=Color3.fromRGB(127,127,127);Lighting.FogEnd=100000;Lighting.GlobalShadows=true;return end
    Lighting.FogStart=0;Lighting.FogEnd=100000;Lighting.FogColor=Color3.fromRGB(40, 40, 40);Lighting.ColorShift_Top=Color3.fromRGB(0,0,0);Lighting.ColorShift_Bottom=Color3.fromRGB(0,0,0);Lighting.GlobalShadows=true
    Lighting.ClockTime=preset.clock or 14;Lighting.Brightness=preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient=candyColor(preset.outAmb) end
    if preset.ambient then Lighting.Ambient=candyColor(preset.ambient) end
    if preset.sky then
        local skyInst=Instance.new("Sky");skyInst:SetAttribute(M.CANDY_SKY_TAG,true)
        if preset.sky.stars then skyInst.StarCount=preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize=preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize=preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId="rbxasset://sky/moon.jpg" end
        skyInst.Parent=Lighting
    end
    if preset.atm then
        local atm=Instance.new("Atmosphere");atm:SetAttribute(M.CANDY_SKY_TAG,true)
        atm.Density=preset.atm.dens or 0.3;atm.Color=candyColor(preset.atm.color);atm.Decay=candyColor(preset.atm.decay);atm.Glare=preset.atm.glare or 1;atm.Haze=preset.atm.haze or 1;atm.Parent=Lighting
    end
    if preset.clouds and terrain then
        local clouds=Instance.new("Clouds");clouds:SetAttribute(M.CANDY_SKY_TAG,true)
        clouds.Cover=preset.clouds.cover or 0.5;clouds.Density=preset.clouds.dens or 0.5;clouds.Color=candyColor(preset.clouds.color);clouds.Parent=terrain
    end
end

-- ============================================================
-- ANIMATION PACKS (unchanged)
-- ============================================================
M.PACKS = {
    ["Adidas Sports"] = {
        WalkAnim = 18537392113,
        RunAnim  = 18537384940,
        JumpAnim = 18537380791,
        FallAnim = 18537367238,
        SwimIdle = 18537387180,
        Swim     = 18537389531,
        Animation1 = 18537376492,
        Animation2 = 18537371272,
        ClimbAnim = 18537363391,
    },
    ["Adidas Community"] = {
        WalkAnim = 122150855457006,
        RunAnim  = 82598234841035,
        JumpAnim = 75290611992385,
        FallAnim = 98600215928904,
        SwimIdle = 109346520324160,
        Swim     = 133308483266208,
        Animation1 = 122257458498464,
        Animation2 = 102357151005774,
        ClimbAnim = 88763136693023,
    },
    ["Adidas Aura"] = {
        WalkAnim = 83842218823011,
        RunAnim  = 118320322718866,
        JumpAnim = 109996626521204,
        FallAnim = 95603166884636,
        SwimIdle = 94922130551805,
        Swim     = 134530128383903,
        Animation1 = 110211186840347,
        Animation2 = 114191137265065,
        ClimbAnim = 97824616490448,
    },
    ["Wicked Popular"] = {
        WalkAnim = 92072849924640,
        RunAnim = 72301599441680,
        JumpAnim = 104325245285198,
        FallAnim = 121152442762481,
        Animation1 = 118832222982049,
        ClimbAnim = 131326830509784,
        SwimIdle = 113199415118199,
        Swim = 99384245425157,
        Animation2 = 76049494037641,
    },
    Elder = {
        WalkAnim = 10921111375,
        RunAnim  = 10921104374,
        JumpAnim = 10921107367,
        FallAnim = 10921105765,
        SwimIdle = 10921110146,
        Swim     = 10921108971,
        ClimbAnim = 10921100400,
        Animation1 = 10921101664,
        Animation2 = 10921102574,
    },
    Zombie = {
        WalkAnim = 10921355261,
        RunAnim  = 616163682,
        JumpAnim = 10921351278,
        FallAnim = 10921350320,
        SwimIdle = 10921353442,
        Swim     = 10921352344,
        Animation1 = 10921344533,
        Animation2 = 10921345304,
        ClimbAnim = 10921343576,
    },
    Mage = {
        WalkAnim = 10921152678,
        RunAnim  = 10921148209,
        JumpAnim = 10921149743,
        FallAnim = 10921148939,
        SwimIdle = 10921151661,
        Swim     = 10921150788,
        ClimbAnim = 10921143404,
        Animation1 = 10921144709,
        Animation2 = 10921145797,
    },
    ["Catwalk Glam"] = {
        WalkAnim = 109168724482748,
        RunAnim  = 81024476153754,
        JumpAnim = 116936326516985,
        FallAnim = 92294537340807,
        SwimIdle = 98854111361360,
        Swim     = 134591743181628,
        ClimbAnim = 119377220967554,
        Animation1 = 133806214992291,
        Animation2 = 94970088341563,
    },
    Astronaut = {
        WalkAnim = 10921046031,
        RunAnim  = 10921039308,
        JumpAnim = 10921042494,
        FallAnim = 10921040576,
        SwimIdle = 10921045006,
        Swim     = 10921044000,
        ClimbAnim = 10921032124,
        Animation1 = 10921034824,
        Animation2 = 10921036806,
    },
    ['Wicked "Dancing Through Life"'] = {
        WalkAnim = 73718308412641,
        RunAnim  = 135515454877967,
        JumpAnim = 78508480717326,
        FallAnim = 78147885297412,
        SwimIdle = 129183123083281,
        Swim     = 110657013921774,
        ClimbAnim = 129447497744818,
        Animation1 = 92849173543269,
        Animation2 = 132238900951109,
    },
    Werewolf = {
        WalkAnim = 10921342074,
        RunAnim  = 10921336997,
        JumpAnim = nil,
        FallAnim = 10921337907,
        SwimIdle = 10921341319,
        Swim     = 10921340419,
        ClimbAnim = 10921329322,
        Animation1 = 10921330408,
        Animation2 = 10921333667,
    },
    Superhero = {
        WalkAnim = 10921298616,
        RunAnim  = 10921291831,
        JumpAnim = 10921294559,
        FallAnim = 10921293373,
        SwimIdle = 10921297391,
        Swim     = 10921295495,
        ClimbAnim = 10921286911,
        Animation1 = 10921288909,
        Animation2 = 10921290167,
    },
    Toy = {
        WalkAnim = 10921312010,
        RunAnim  = 10921306285,
        JumpAnim = 10921308158,
        FallAnim = 10921307241,
        SwimIdle = 10921310341,
        Swim     = 10921309319,
        ClimbAnim = 10921300839,
        Animation1 = 10921301576,
        Animation2 = nil,
    },
    ["No Boundaries"] = {
        WalkAnim = 18747074203,
        RunAnim  = 18747070484,
        JumpAnim = 18747069148,
        FallAnim = 18747062535,
        SwimIdle = 18747071682,
        Swim     = 18747073181,
        ClimbAnim = 18747060903,
        Animation1 = 18747067405,
        Animation2 = 18747063918,
    },
    NFL = {
        WalkAnim = 110358958299415,
        RunAnim  = 117333533048078,
        JumpAnim = 119846112151352,
        FallAnim = 129773241321032,
        SwimIdle = 79090109939093,
        Swim     = 132697394189921,
        ClimbAnim = 134630013742019,
        Animation1 = 92080889861410,
        Animation2 = 74451233229259,
    },
    ["Amazon Unboxed"] = {
        WalkAnim = 90478085024465,
        RunAnim  = 134824450619865,
        JumpAnim = 121454505477205,
        FallAnim = 94788218468396,
        SwimIdle = 129126268464847,
        Swim     = 105962919001086,
        ClimbAnim = 121145883950231,
        Animation1 = 98281136301627,
        Animation2 = nil,
    },
    Vampire = {
        WalkAnim = 10921326949,
        RunAnim  = 10921320299,
        JumpAnim = 10921322186,
        FallAnim = 10921321317,
        SwimIdle = 10921325443,
        Swim     = 10921324408,
        ClimbAnim = 10921314188,
        Animation1 = 10921315373,
        Animation2 = nil,
    },
    Ninja = {
        Run=656118852, Walk=656121766, Jump=656117878, Fall=656115606,
        Swim=656119721, SwimIdle=656121397, Climb=656114359,
        Idle={656117400,656118341,886742569}
    },
    Robot = {
        Run=616091570, Walk=616095330, Jump=616090535, Fall=616087089,
        Swim=616092998, SwimIdle=616094091, Climb=616086039,
        Idle={616088211,616089559,885531463}
    },
    Levitation = {
        Run=616010382, Walk=616013216, Jump=616008936, Fall=616005863,
        Swim=616011509, SwimIdle=616012453, Climb=616003713,
        Idle={616006778,616008087,886862142}
    },
    Stylish = {
        Run=616140816, Walk=616146177, Jump=616139451, Fall=616134815,
        Swim=616143378, SwimIdle=616144772, Climb=616133594,
        Idle={616136790,616138447,886888594}
    },
    Bubbly = {
        Run=910025107, Walk=910034870, Jump=910016857, Fall=910001910,
        Swim=910028158, SwimIdle=910030921, Climb=909997997,
        Idle={910004836,910009958,1018536639}
    },
    Cartoon = {
        Run=742638842, Walk=742640026, Jump=742637942, Fall=742637151,
        Swim=742639220, SwimIdle=742639812, Climb=742636889,
        Idle={742637544,742638445,885477856}
    },
}
M.animPack = "Bubbly" -- girl-style default for SHADOW users
M.animPackEnabled = true
M.savedAnimate = nil
M.shadowBlackSkinEnabled = true -- black body skin for SHADOW users

-- ============================================================
-- CHARTER FEATURES (Headless & Korblox)
-- ============================================================
M.headlessEnabled = false
M.korbloxEnabled = true -- ON by default, toggle off in Utility

local HEADLESS_MESH_ID = "rbxassetid://1095708"
local KORBLOX_MESH_ID = "rbxassetid://101851696"
local KORBLOX_TEXTURE_ID = "rbxassetid://101851254"
local DARK_GREY_COLOR = Color3.fromRGB(64, 64, 64)

local function removeFace(head)
    local face = head:FindFirstChild("face")
    if face then face:Destroy() end
end

function M.applyHeadlessToChar(char, enabled)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    if enabled then
        head.Transparency = 1
        head.CanCollide = false
        removeFace(head)

        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("SpecialMesh") and child.MeshId == HEADLESS_MESH_ID then
                child:Destroy()
            end
        end

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = HEADLESS_MESH_ID
        mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
        mesh.Name = "HeadlessMesh"
        mesh.Parent = head

        head:GetPropertyChangedSignal("Transparency"):Connect(function()
            if head.Transparency ~= 1 then
                head.Transparency = 1
            end
        end)
        head.ChildAdded:Connect(function(child)
            if child.Name == "face" and child:IsA("Decal") then
                child:Destroy()
            end
        end)
    else
        head.Transparency = 0
        head.CanCollide = true
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("SpecialMesh") and child.Name == "HeadlessMesh" then
                child:Destroy()
            end
        end
        removeFace(head)
    end
end

function M.applyKorbloxToChar(char, enabled)
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if enabled then
        if humanoid.RigType == Enum.HumanoidRigType.R6 then
            local rightLeg = char:FindFirstChild("Right Leg")
            if rightLeg then
                for _, child in ipairs(rightLeg:GetChildren()) do
                    if child:IsA("SpecialMesh") or child:IsA("CharacterMesh") then
                        child:Destroy()
                    end
                end
                rightLeg.Color = DARK_GREY_COLOR
                rightLeg:GetPropertyChangedSignal("Color"):Connect(function()
                    if rightLeg.Color ~= DARK_GREY_COLOR then
                        rightLeg.Color = DARK_GREY_COLOR
                    end
                end)
                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = KORBLOX_MESH_ID
                mesh.TextureId = KORBLOX_TEXTURE_ID
                mesh.Scale = Vector3.new(1, 1, 1)
                mesh.Name = "KorbloxMesh"
                mesh.Parent = rightLeg
            end
        elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
            local rightUpperLeg = char:FindFirstChild("RightUpperLeg")
            if rightUpperLeg then
                rightUpperLeg.Transparency = 1
                local rightLowerLeg = char:FindFirstChild("RightLowerLeg")
                local rightFoot = char:FindFirstChild("RightFoot")
                if rightLowerLeg then rightLowerLeg.Transparency = 1 end
                if rightFoot then rightFoot.Transparency = 1 end

                local oldKorblox = char:FindFirstChild("KorbloxLeg")
                if oldKorblox then oldKorblox:Destroy() end

                local korbloxLeg = Instance.new("Part")
                korbloxLeg.Name = "KorbloxLeg"
                korbloxLeg.Size = Vector3.new(1, 2, 1)
                korbloxLeg.Anchored = false
                korbloxLeg.CanCollide = false
                korbloxLeg.Color = DARK_GREY_COLOR
                korbloxLeg.Parent = char

                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = KORBLOX_MESH_ID
                mesh.TextureId = KORBLOX_TEXTURE_ID
                mesh.Scale = Vector3.new(1, 1, 1)
                mesh.Name = "KorbloxMesh"
                mesh.Parent = korbloxLeg

                local weld = Instance.new("Weld")
                weld.Part0 = rightUpperLeg
                weld.Part1 = korbloxLeg
                weld.C0 = CFrame.new(0, -0.8, 0)
                weld.Name = "KorbloxWeld"
                weld.Parent = korbloxLeg
            end
        end
    else
        if humanoid.RigType == Enum.HumanoidRigType.R6 then
            local rightLeg = char:FindFirstChild("Right Leg")
            if rightLeg then
                for _, child in ipairs(rightLeg:GetChildren()) do
                    if child:IsA("SpecialMesh") and child.Name == "KorbloxMesh" then
                        child:Destroy()
                    end
                end
                rightLeg.Color = Color3.fromRGB(255, 255, 255)
            end
        elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
            local rightUpperLeg = char:FindFirstChild("RightUpperLeg")
            if rightUpperLeg then
                rightUpperLeg.Transparency = 0
                local rightLowerLeg = char:FindFirstChild("RightLowerLeg")
                local rightFoot = char:FindFirstChild("RightFoot")
                if rightLowerLeg then rightLowerLeg.Transparency = 0 end
                if rightFoot then rightFoot.Transparency = 0 end
                local korbloxLeg = char:FindFirstChild("KorbloxLeg")
                if korbloxLeg then korbloxLeg:Destroy() end
            end
        end
    end
end

function M.applyCharterToChar(char)
    if not char then return end
    M.applyHeadlessToChar(char, M.headlessEnabled)
    M.applyKorbloxToChar(char, M.korbloxEnabled)
    if M.shadowBlackSkinEnabled then
        M.applyShadowBlackSkin(char)
    end
end

-- Full black body + no accessories/clothes + SHADOW torso chip (visible all sides)
function M.stripShadowClothing(char)
    if not char then return end
    for _, c in ipairs(char:GetChildren()) do
        if c:IsA("Accessory") or c:IsA("Hat") or c:IsA("Shirt") or c:IsA("Pants")
            or c:IsA("ShirtGraphic") or c:IsA("Clothing")
            or c.ClassName == "LayeredClothing" then
            if not c:GetAttribute("ShadowChip") then
                pcall(function() c:Destroy() end)
            end
        end
    end
    -- layered clothing under humanoid
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function()
            for _, a in ipairs(hum:GetAccessories()) do
                if not a:GetAttribute("ShadowChip") then pcall(function() a:Destroy() end) end
            end
        end)
        for _, d in ipairs(hum:GetDescendants()) do
            if d:IsA("Accessory") or d.ClassName == "LayeredClothing" then
                if not d:GetAttribute("ShadowChip") then pcall(function() d:Destroy() end) end
            end
        end
    end
    -- clear description clothing slots if possible
    pcall(function()
        if not hum then return end
        local desc = hum:GetAppliedDescription()
        if not desc then return end
        desc.Shirt = 0
        desc.Pants = 0
        desc.GraphicTShirt = 0
        for _, slot in ipairs({
            "HatAccessory","HairAccessory","FaceAccessory","NeckAccessory",
            "ShouldersAccessory","FrontAccessory","BackAccessory","WaistAccessory"
        }) do
            pcall(function() desc[slot] = "" end)
        end
        -- keep body black via body colors after apply
        pcall(function() hum:ApplyDescription(desc) end)
    end)
end

function M.attachShadowTorsoChip(char)
    if not char then return end
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not torso then return end
    -- remove old chips
    for _, c in ipairs(torso:GetChildren()) do
        if c.Name == "ShadowTorsoChipBB" or c:GetAttribute("ShadowChip") then
            pcall(function() c:Destroy() end)
        end
    end
    -- Billboard always faces camera → visible from all sides
    local bb = Instance.new("BillboardGui")
    bb.Name = "ShadowTorsoChipBB"
    bb:SetAttribute("ShadowChip", true)
    bb.Size = UDim2.new(0, 72, 0, 28)
    bb.StudsOffset = Vector3.new(0, 0.15, 0)
    bb.AlwaysOnTop = false
    bb.MaxDistance = 80
    bb.Adornee = torso
    bb.Parent = torso

    local chip = Instance.new("Frame")
    chip.Name = "Chip"
    chip:SetAttribute("ShadowChip", true)
    chip.Size = UDim2.new(1, 0, 1, 0)
    chip.BackgroundColor3 = Color3.fromRGB(0, 78, 210)
    chip.BorderSizePixel = 0
    chip.Parent = bb
    Instance.new("UICorner", chip).CornerRadius = UDim.new(0, 8)
    do
        local st = Instance.new("UIStroke")
        st.Color = Color3.fromRGB(255, 255, 255)
        st.Thickness = 1.2
        st.Transparency = 0.2
        st.Parent = chip
    end
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "SHADOW"
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 14
    lbl.Parent = chip

    -- Also surface guis on front + back of torso for close-up look
    for _, face in ipairs({Enum.NormalId.Front, Enum.NormalId.Back}) do
        local sg = Instance.new("SurfaceGui")
        sg.Name = "ShadowTorsoChipSG"
        sg:SetAttribute("ShadowChip", true)
        sg.Face = face
        sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        sg.PixelsPerStud = 50
        sg.Parent = torso
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0.55, 0, 0.28, 0)
        f.Position = UDim2.new(0.225, 0, 0.36, 0)
        f.BackgroundColor3 = Color3.fromRGB(0, 78, 210)
        f.BorderSizePixel = 0
        f.Parent = sg
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(1, 0, 1, 0)
        t.BackgroundTransparency = 1
        t.Text = "SHADOW"
        t.TextColor3 = Color3.fromRGB(255, 255, 255)
        t.Font = Enum.Font.GothamBlack
        t.TextScaled = true
        t.Parent = f
    end
end

function M.applyShadowBlackSkin(char)
    char = char or player.Character
    if not char then return end
    if not M.shadowBlackSkinEnabled then return end

    M.stripShadowClothing(char)

    local black = Color3.fromRGB(15, 15, 17)
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
            pcall(function()
                p.Color = black
                p.Material = Enum.Material.SmoothPlastic
                if p:IsA("MeshPart") then
                    p.TextureID = ""
                end
            end)
        elseif p:IsA("SpecialMesh") then
            pcall(function()
                p.TextureId = ""
            end)
        elseif p:IsA("Decal") or p:IsA("Texture") then
            -- keep face-less pure black look
            if p.Name == "face" or p.Name == "Face" then
                pcall(function() p:Destroy() end)
            end
        end
    end
    local bc = char:FindFirstChildOfClass("BodyColors")
    if bc then
        pcall(function()
            bc.HeadColor3 = black
            bc.LeftArmColor3 = black
            bc.RightArmColor3 = black
            bc.LeftLegColor3 = black
            bc.RightLegColor3 = black
            bc.TorsoColor3 = black
        end)
    end

    M.attachShadowTorsoChip(char)

    -- keep stripping clothes that get re-added
    if M._shadowBlackChildConn then
        pcall(function() M._shadowBlackChildConn:Disconnect() end)
        M._shadowBlackChildConn = nil
    end
    M._shadowBlackChildConn = char.ChildAdded:Connect(function(c)
        if not M.shadowBlackSkinEnabled then return end
        if c:GetAttribute("ShadowChip") then return end
        if c:IsA("Accessory") or c:IsA("Hat") or c:IsA("Shirt") or c:IsA("Pants")
            or c:IsA("ShirtGraphic") or c:IsA("Clothing") then
            task.defer(function() pcall(function() c:Destroy() end) end)
        end
    end)
end

-- VYNC SKIN toggle — asset 116358759349760
M.VYNC_SKIN_ID = 116358759349760
M.vyncSkinEnabled = false

local function vyncStrip(char)
    if not char then return end
    for _, c in ipairs(char:GetChildren()) do
        if c:IsA("Accessory") or c:IsA("Hat") then pcall(function() c:Destroy() end) end
    end
    pcall(function()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then for _, a in ipairs(hum:GetAccessories()) do pcall(function() a:Destroy() end) end end
    end)
end

local function vyncFindAcc(obj)
    if not obj then return nil end
    if obj:IsA("Accessory") or obj:IsA("Hat") then return obj end
    local a = obj:FindFirstChildOfClass("Accessory") or obj:FindFirstChildOfClass("Hat")
    if a then return a end
    for _, d in ipairs(obj:GetDescendants()) do
        if d:IsA("Accessory") or d:IsA("Hat") then return d end
    end
    return nil
end

local function vyncLoad(id)
    id = tonumber(id) or 0
    if id <= 0 then return nil end
    local url = "rbxassetid://" .. tostring(id)
    local bag = {}
    pcall(function()
        if typeof(getobjects) == "function" then
            local t = getobjects(url)
            if type(t) == "table" then for _, o in ipairs(t) do table.insert(bag, o) end end
        elseif game.GetObjects then
            local t = game:GetObjects(url)
            if type(t) == "table" then for _, o in ipairs(t) do table.insert(bag, o) end end
        end
    end)
    pcall(function()
        local m = game:GetService("InsertService"):LoadAsset(id)
        if m then table.insert(bag, m) end
    end)
    pcall(function()
        local IS = game:GetService("InsertService")
        if IS.LoadLocalAsset then
            local o = IS:LoadLocalAsset(url)
            if o then table.insert(bag, o) end
        end
    end)
    for _, o in ipairs(bag) do
        local acc = vyncFindAcc(o)
        if acc then
            local cl = acc:Clone()
            cl:SetAttribute("ShadowSkin", true)
            cl.Name = "ShadowSkin"
            for _, x in ipairs(bag) do pcall(function() x:Destroy() end) end
            return cl
        end
    end
    for _, x in ipairs(bag) do pcall(function() x:Destroy() end) end
    return nil
end

function M.applyVyncSkin(char)
    if not M.vyncSkinEnabled then return end
    char = char or player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 6)
    if not hum then return end
    vyncStrip(char)
    for _, c in ipairs(char:GetChildren()) do
        if (c:IsA("Accessory") or c:IsA("Hat")) and c:GetAttribute("ShadowSkin") then return end
    end
    local id = tonumber(M.VYNC_SKIN_ID) or 116358759349760
    local acc = vyncLoad(id)
    if acc then
        pcall(function() hum:AddAccessory(acc) end)
        if not acc.Parent then acc.Parent = char end
        return
    end
    pcall(function()
        local desc = hum:GetAppliedDescription()
        if not desc then return end
        local idStr = tostring(id)
        for _, slot in ipairs({"HatAccessory","HairAccessory","FaceAccessory","NeckAccessory","ShouldersAccessory","FrontAccessory","BackAccessory","WaistAccessory"}) do
            pcall(function() desc[slot] = "" end)
        end
        for _, slot in ipairs({"HatAccessory","HairAccessory","BackAccessory","FrontAccessory","FaceAccessory","NeckAccessory","ShouldersAccessory","WaistAccessory"}) do
            pcall(function() desc[slot] = idStr end)
        end
        pcall(function() hum:ApplyDescription(desc) end)
        task.wait(0.12)
        local kept = false
        for _, c in ipairs(char:GetChildren()) do
            if c:IsA("Accessory") or c:IsA("Hat") then
                if not kept then
                    kept = true
                    c:SetAttribute("ShadowSkin", true)
                    c.Name = "ShadowSkin"
                else
                    pcall(function() c:Destroy() end)
                end
            end
        end
        if not kept then
            local a2 = vyncLoad(id)
            if a2 then
                pcall(function() hum:AddAccessory(a2) end)
                if not a2.Parent then a2.Parent = char end
            end
        end
    end)
end

function M.clearVyncSkin(char)
    char = char or player.Character
    if not char then return end
    for _, c in ipairs(char:GetChildren()) do
        if (c:IsA("Accessory") or c:IsA("Hat")) and (c:GetAttribute("ShadowSkin") or c.Name == "ShadowSkin") then
            pcall(function() c:Destroy() end)
        end
    end
end

function M.setVyncSkin(on)
    M.vyncSkinEnabled = on == true
    if M.vyncSkinEnabled then
        M.applyVyncSkin(player.Character)
        task.delay(0.8, function() if M.vyncSkinEnabled then M.applyVyncSkin(player.Character) end end)
    else
        M.clearVyncSkin(player.Character)
    end
    if M.setVyncSkinVisual then pcall(function() M.setVyncSkinVisual(M.vyncSkinEnabled) end) end
    pcall(function() if saveCherryConfig then saveCherryConfig() end end)
end

function M.startVyncSkinWatch()
    if M._vyncCharConn then pcall(function() M._vyncCharConn:Disconnect() end); M._vyncCharConn = nil end
    M._vyncCharConn = player.CharacterAdded:Connect(function(char)
        if not M.vyncSkinEnabled then return end
        task.wait(0.45)
        M.applyVyncSkin(char)
        task.delay(1.2, function() if M.vyncSkinEnabled and player.Character == char then M.applyVyncSkin(char) end end)
        task.delay(2.5, function() if M.vyncSkinEnabled and player.Character == char then M.applyVyncSkin(char) end end)
    end)
    if M.vyncSkinEnabled and player.Character then
        task.defer(function() M.applyVyncSkin(player.Character) end)
    end
end

player.CharacterAdded:Connect(function(char)
    task.wait(0.35)
    if M.headlessEnabled or M.korbloxEnabled then
        M.applyCharterToChar(char)
    end
end)

task.spawn(function()
    task.wait(0.2)
    pcall(M.startVyncSkinWatch)
end)

-- ============================================================
-- STATE
-- ============================================================
M.NS = 60
M.CS = 30
M.LAGGER_SPEED = 22
M.LAGGER_CARRY_SPEED = 22
M.BYPASS_SPEED = 40
M.BYPASS_CARRY_SPEED = 22
M.speedMethod = "Velocity"
M.speedMethodList = {
    "Velocity", "AssemblyLinearVelocity", "Velocity Lerp", "AssemblyLinearVelocity Lerp",
    "CFrame", "CFrame Lerp", "Hyper CFrame", "Anchored CFrame", "PivotTo", "Model PivotTo", "Tween CFrame",
    "WalkSpeed", "Humanoid Move", "Humanoid MoveTo",
    "BodyVelocity", "BodyPosition", "BodyForce", "BodyThrust",
    "LinearVelocity", "VectorForce", "AlignPosition",
    "ApplyImpulse", "RocketPropulsion",
}
M.hyperMult = 4
M._lastSpeedMethod = nil
M._speedHRP = nil
M._anchoredBySpeed = nil
M._bodyVel = nil
M._bodyPosition = nil
M._bodyForce = nil
M._bodyThrust = nil
M._linearVel = nil
M._vectorForce = nil
M._alignPos = nil
M._rocket = nil
M._rocketTarget = nil
M._attLinVel = nil
M._attVecForce = nil
M._attAlign = nil
M._speedTween = nil
M.carrySpeedActive = false
M.laggerModeEnabled = false
M.laggerCarryActive = false

M.antiRagdollEnabled = false
M.hardHitEnabled = false
M.hardHitRadius = 10
M.antiRagdollMode = "Splatter"
M.infJumpEnabled = false
M.infJumpMode = "manual"
M.medusaCounterEnabled = false
M.batCounterEnabled = false
M.unwalkEnabled = false
M.medusaResetEnabled = false -- completely removed
M.medusaDebounce = false
M.medusaLastUsed = 0
M.dropActive = false
M.autoLeftEnabled = false
M.autoRightEnabled = false
M.autoBatEnabled = false
M.autoSwingEnabled = true
M.autoMoveSwingEnabled = false
M.autoMoveSwingInterval = 0.3
M._alSwingDebounce = false
M._arSwingDebounce = false
M.antiLagEnabled = false
M.antiSummerBaseEnabled = false
M.antiSummerBaseConn = nil
M._antiSummerCleaned = {}

M.removeAccessoriesEnabled = false
M.antiLagDescConn = nil
M.stretchRezEnabled = false
M.stretchRezConn = nil
M.unwalkSavedAnimate = nil
M._anyKeyListening = false
M.autoTPEnabled = false
M.autoTPHeight = 20
M.autoTPConn = nil
M.cursedResetRemote = nil
M.CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
M.guiTransparencyEnabled = false
M.mobileButtonsEnabled = true
M.mobileButtonsLocked = false
M.mobileButtonsSize = 100
M.circleButtonsEnabled = false
M.mobBtnRefs = {}
M.mobGuiRef = nil
M.fovValue = 80
M.fovOptions = {80,120,180}
M.fovIndex = 1
M.laggerModePillRef = nil
M.carryModePillRef = nil
M.autoSwitchSpeedEnabled = false
M.autoTurnOffSpeedEnabled = false
M.autoSwitchLaggerSpeedEnabled = false
M.autoCarryEnemyBaseEnabled = false
M.autoCarryEnemyBaseRange = 35
M._autoCarryEnemyBaseConn = nil
M.setAutoCarryEnemyBaseVisual = nil
M.AUTO_SWITCH_THRESHOLD = 25
M._autoSwitchSpeedConn = nil
M.customFontSelected = "None"
M._fontOrig = {}
M._fontConn = nil
M._fontMy = nil
M.FONT_NAMES = {"None", "Coding Font", "Summer", "Beachy", "Scary", "Bangers"}
M.mobBtnTransparencyEnabled = false
M.perButtonDragEnabled = true
M.antiKickEnabled = false
M.brainrotDetected = false
M.safeModeEnabled = false
M.activeBatBillboard = nil
M.activeMedusaBillboard = nil
M.ragdollGuiEnabled = true
M.persistentRagdollGui = nil
M.uiLocked = false
M.holdInfJumpConn = nil
M.DROP_ASCEND_DURATION = 0.2
M.DROP_ASCEND_SPEED = 150
M.autoResetOnDeath = false -- completely removed
M.bypassAimbotEnabled = false
M.bypassAimbotConn = nil
M._bypassGodConn = nil
M._bypassGodHealthConn = nil
M._bypassGodDiedConn = nil
M._bypassGodCharConn = nil
M.bypassPrevAutoRotate = nil
M.bypassHitCD = false
M.bypassSwingCD = 0.35
M.bypassHitDist = 8
M._bypassTarget = nil

M.stealMode = "V2"
M.stealBarSize = 460
M.Steal = {
    AutoStealEnabled = false,
    StealRadius = 60,
    StealDuration = 1.4,
    StopTime = 0.35,
}
M.V3 = {
    enabled = false,
    conn = nil,
    progress = 0,
    lastInRange = 0,
    currentUid = nil,
    holding = false,
    holdPrompt = nil,
    cooldownUntil = 0,
}
M.autoRadiusEnabled = false
function M.getAutoRadius()
    local radius = math.clamp((tonumber(M.NS) or 60) + 1, 1, 500)
    return math.floor(radius * 10 + 0.5) / 10
end
function M.getActiveStealRadius()
    if M.stealMode == "Semi" then
        return math.min(tonumber(M.Semi.radius) or 10, 10)
    end
    -- V2 uses main steal radius
    return M.autoRadiusEnabled and M.getAutoRadius() or M.Steal.StealRadius
end
M.Semi = {
    enabled = false,
    holdMin = 1.3,
    holdMax = 2.6,
    entryDelay = 0.3,
    cooldown = 0.05,
    primeRange = 80,
    radius = 10, -- STEAL_RANGE from auto-grabber
    conn = nil,
    scanThread = nil,
    plotSync = {caches = {}, connections = {}},
    animals = {},
    promptCache = {},
    internalCache = {},
    state = {active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0},
    plots = nil,
    syncReady = false,
}
M.isStealing = false
M.stealStartTime = 0
M.stealConn = nil
M.progressConn = nil
M.animalCache = {}
M.promptCache = {}
M.stealCache = {}
M.playerESPEnabled = true -- circular enemy avatars on by default
M.espList = {}
M.pingPopupActive = false
M.pingPopupGui = nil
M.pingCycleTimer = nil
M.pingPanelPos = nil
M.pingPanelOpen = false
M.pingGui = nil
M.pingMain = nil
M.pingSettings = nil
M.pingActive = false
M.pingPower = 100000
M.pingInterval = 0.125
M.pingKeybindKb = "T"
M.pingKeybindGp = "ButtonR2"
M.pingAutoBrainrot = true
M.pingRemote = nil
M.pingBrainrotMode = false
M.pingLastBrainrot = false
M.pingManualOverride = false
M.pingListening = nil
M.pingLoopRunning = false
M.setPingPanelVisual = nil

-- Shadow Bypass panel state
M.bypassPanelOpen = false
M.bypassPanelGui = nil
M.bypassPanelMain = nil
M.bypassPanelMini = nil
M.bypassActive = false
M.bypassAutoBrainrot = false
M.bypassBillboardOn = false
M.bypassKeybind = "V"
M.bypassPower = 97000
M._bypassSpamRunning = false
M._bypassSpamThread = nil
M._bypassBomb = nil
M._bypassBillboard = nil
M.setBypassPanelVisual = nil

M.Conns = {autoSteal=nil, antiRag=nil, batCounter=nil, anchor={}}
M._persistentConns = {}
M.alConn = nil
M.arConn = nil
M.alPhase = 1
M.arPhase = 1
M.aimbotConn = nil
M.lastMoveDir = Vector3.new(0,0,0)
M.batCounterDebounce = false
M.speedLabel = nil

-- Keybinds
M.KB = {
    DropBrainrot={kb=nil,gp=nil},
    AutoLeft={kb=nil,gp=nil},
    AutoRight={kb=nil,gp=nil},
    AutoBat={kb=nil,gp=nil},
    TPFloor={kb=nil,gp=nil},
    InstaReset={kb=nil,gp=nil},
    GuiHide={kb=nil,gp=nil},
    SpeedToggle={kb=nil,gp=nil},
    LaggerToggle={kb=nil,gp=nil},
    BypassAimbot={kb=nil,gp=nil},
    PingLagger={kb=Enum.KeyCode.T,gp=nil},
}
M.AP_L1 = Vector3.new(-476.47,-6.28,92.73)
M.AP_L2 = Vector3.new(-483.12,-4.95,94.81)
M.AP_R1 = Vector3.new(-476.16,-6.52,25.62)
M.AP_R2 = Vector3.new(-483.06,-5.03,25.48)
M.MEDUSA_COOLDOWN = 25
M.BAT_COUNTER_SLAP_LIST = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
M.fovConn = nil
M.defLightBrightness = nil
M.defLightClock = nil
M.defLightAmbient = nil
M.mainFrame = nil
M.normalBox = nil
M.carryBox = nil
M.laggerBox = nil
M.radInput = nil
M.autoTPHeightBox = nil
M.durationBox = nil
M.modeValLbl = nil
M.setInstaGrab = nil
M.setInfJumpVisual = nil
M.setAntiRagVisual = nil
M.setMedusaVisual = nil
M.setUnwalkVisual = nil
M.setAntiLagVisual = nil
M.setAutoSwingVisual = nil
M.setTranspVisual = nil
M.setLockVisual = nil
M.setMobVisual = nil
M.setCircleBtnsVisual = nil
M.setMedusaResetVisual = nil
M.antiKickSetVisual = nil
M.autoLeftSetVisual = nil
M.autoRightSetVisual = nil
M.autoBatSetVisual = nil
M.setAutoTPVisual = nil
M.setStretchRezVisual = nil
M.setAutoResetOnDeath = nil
M.setBypassVisual = nil
M._autoSwitchWasSteal = false

M.MOB_POS_FILE = "moveeduels_btnpos.json"
function M.themeDarkFromAccent(accent, amount)
    amount = math.clamp(tonumber(amount) or 0.12, 0, 1)
    if typeof(accent) ~= "Color3" then accent = Color3.fromRGB(0, 100, 220) end
    return Color3.new(
        math.clamp(accent.R * amount, 0, 1),
        math.clamp(accent.G * amount, 0, 1),
        math.clamp(accent.B * amount, 0, 1)
    )
end
M.MOVE_KEYS = {
    [Enum.KeyCode.W]=true,
    [Enum.KeyCode.A]=true,
    [Enum.KeyCode.S]=true,
    [Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,
    [Enum.KeyCode.Left]=true,
    [Enum.KeyCode.Down]=true,
    [Enum.KeyCode.Right]=true
}

M.showPlayerSpeeds = false
M.playerSpeedGuis = {}
M.playerSpeedUpdateConn = nil
M.removeAccEnabled = false
M.removeAccConn = nil
M.removedAccessories = {}
M.uiScale = 0.60
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
    M.uiScale = 0.60
end
M.uiScaleSliderRef = nil
M.uiScaleLabelRef = nil
M.uiScaleBoxRef = nil
M.lineESPEnabled = false
M.menuOpen = true
M.speedESPEnabled = false

M.statusGui = nil
M.statusFill = nil
M.statusPctLbl = nil
M.statusRadiusLbl = nil
M.statusDot = nil
M.statusMain = nil
M.statusFpsLbl = nil

-- ============================================================
-- UTILITY FUNCTIONS
-- ============================================================
function M.addShimmerToLabel(lbl,color1,color2)
    local gr=Instance.new("UIGradient",lbl)
    gr.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,color1 or Color3.fromRGB(100,100,100)),ColorSequenceKeypoint.new(0.5,color2 or Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,color1 or Color3.fromRGB(100,100,100))})
    gr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,0.3,0)})
    return gr
end

function M.applyFOV()
    if M.fovConn then M.fovConn:Disconnect() end
    M.fovConn=RunService.RenderStepped:Connect(function() local cam=workspace.CurrentCamera;if cam then cam.FieldOfView=M.fovValue end end)
end

-- ============================================================
-- RAGDOLL TIMER
-- ============================================================
M.ragdollTimerThread = nil
M.ragdollTimerRemaining = 0
M.isRagdollActive = false

function M.updateRagdollTimer(duration)
    if M.ragdollTimerThread then
        task.cancel(M.ragdollTimerThread)
        M.ragdollTimerThread = nil
    end
    if duration <= 0 then
        M.isRagdollActive = false
        if M.headIndicator and M.headIndicator.ragdollTimer then
            M.headIndicator.ragdollTimer.Text = ""
        end
        return
    end
    M.isRagdollActive = true
    local startTime = tick()
    M.ragdollTimerRemaining = duration
    M.ragdollTimerThread = task.spawn(function()
        while M.isRagdollActive and M.ragdollTimerRemaining > 0 do
            local elapsed = tick() - startTime
            local remaining = math.max(0, duration - elapsed)
            M.ragdollTimerRemaining = remaining
            if M.headIndicator and M.headIndicator.ragdollTimer then
                M.headIndicator.ragdollTimer.Text = string.format("%.1fs", remaining)
            end
            if remaining <= 0 then
                M.isRagdollActive = false
                if M.headIndicator and M.headIndicator.ragdollTimer then
                    M.headIndicator.ragdollTimer.Text = ""
                end
                break
            end
            task.wait(0.05)
        end
        M.ragdollTimerThread = nil
    end)
end

function M.onHumanoidStateChanged(old,new)
    local char=player.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid");if not hum then return end
    local isRag=(new==Enum.HumanoidStateType.Physics or new==Enum.HumanoidStateType.Ragdoll or new==Enum.HumanoidStateType.FallingDown)
    if isRag and not hum.PlatformStand then
        M.updateRagdollTimer(2.6)
    end
end

function M.onMedusaStateChanged()
    local char=player.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum and hum.PlatformStand then
        M.updateRagdollTimer(4.5)
    end
end

function M.setupRagdollTriggers()
    local char=player.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.StateChanged:Connect(M.onHumanoidStateChanged)
        hum:GetPropertyChangedSignal("PlatformStand"):Connect(M.onMedusaStateChanged)
    end
end

-- ============================================================
-- ANIMATION FUNCTIONS (unchanged)
-- ============================================================
function M.waitForAnimate(char)
    for _ = 1, 40 do
        local a = char:FindFirstChild("Animate")
        if a and a:FindFirstChild("idle") and a:FindFirstChild("run") and a:FindFirstChild("walk") then
            return a
        end
        task.wait(0.1)
    end
    return nil
end

function M.setAnim(animObj, id)
    if animObj and id then
        animObj.AnimationId = "rbxassetid://" .. tostring(id)
    end
end

function M.stopAllTracks(hum)
    if not hum then return end
    for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
        pcall(function() t:Stop(0) end)
    end
end

function M.ensureAnim(folder, name)
    if not folder then return nil end
    local a = folder:FindFirstChild(name)
    if not a then
        a = Instance.new("Animation")
        a.Name = name
        a.Parent = folder
    end
    return a
end

function M.ensureIdleSlots(idleFolder, n)
    if not idleFolder then return end
    n = n or 2
    for i=1,n do
        M.ensureAnim(idleFolder, "Animation" .. i)
    end
end

function M.pick(pack, ...)
    for i = 1, select("#", ...) do
        local k = select(i, ...)
        local v = pack[k]
        if v ~= nil then return v end
    end
    return nil
end

function M.saveOriginalAnimate(char)
    if not char then return end
    if M.savedAnimate then return end
    local animate = char:FindFirstChild("Animate")
    if animate then
        M.savedAnimate = animate:Clone()
    end
end

function M.restoreOriginalAnimate(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        M.stopAllTracks(hum)
    end
    local currentAnimate = char:FindFirstChild("Animate")
    if currentAnimate then
        currentAnimate:Destroy()
    end
    if M.savedAnimate then
        local newAnimate = M.savedAnimate:Clone()
        newAnimate.Parent = char
        newAnimate.Disabled = true
        task.wait(0.06)
        newAnimate.Disabled = false
    end
end

function M.resetAnimations(char)
    if not char then return end
    M.restoreOriginalAnimate(char)
end

local applyingAnim = false
function M.applyAnimPack(packName)
    if not M.animPackEnabled then
        local char = player.Character
        if char then
            M.resetAnimations(char)
        end
        return false
    end
    if applyingAnim then return false end
    applyingAnim = true

    local pack = M.PACKS[packName]
    if not pack then
        applyingAnim = false
        return false
    end

    local char = player.Character or player.CharacterAdded:Wait()
    M.saveOriginalAnimate(char)

    local animate = M.waitForAnimate(char)
    if not animate then
        applyingAnim = false
        return false
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    M.stopAllTracks(hum)

    local runObj   = M.ensureAnim(animate:FindFirstChild("run"),   "RunAnim")
    local walkObj  = M.ensureAnim(animate:FindFirstChild("walk"),  "WalkAnim")
    local jumpObj  = M.ensureAnim(animate:FindFirstChild("jump"),  "JumpAnim")
    local fallObj  = M.ensureAnim(animate:FindFirstChild("fall"),  "FallAnim")
    local climbObj = M.ensureAnim(animate:FindFirstChild("climb"), "ClimbAnim")
    local swimObj  = M.ensureAnim(animate:FindFirstChild("swim"),     "Swim")
    local swimIdleObj = M.ensureAnim(animate:FindFirstChild("swimidle"), "SwimIdle")
    local idleFolder = animate:FindFirstChild("idle")

    M.setAnim(walkObj,  M.pick(pack, "WalkAnim", "Walk"))
    M.setAnim(runObj,   M.pick(pack, "RunAnim", "Run"))
    M.setAnim(jumpObj,  M.pick(pack, "JumpAnim", "Jump"))
    M.setAnim(fallObj,  M.pick(pack, "FallAnim", "Fall"))
    M.setAnim(climbObj, M.pick(pack, "ClimbAnim", "Climb"))
    M.setAnim(swimObj,      M.pick(pack, "Swim"))
    M.setAnim(swimIdleObj,  M.pick(pack, "SwimIdle") or M.pick(pack, "Swim"))

    if idleFolder then
        local a1 = M.pick(pack, "Animation1")
        local a2 = M.pick(pack, "Animation2")
        if a1 or a2 then
            M.ensureIdleSlots(idleFolder, 2)
            local id1 = a1 or a2
            local id2 = a2 or a1 or id1
            M.setAnim(idleFolder:FindFirstChild("Animation1"), id1)
            M.setAnim(idleFolder:FindFirstChild("Animation2"), id2)
        elseif pack.Idle and #pack.Idle > 0 then
            M.ensureIdleSlots(idleFolder, math.max(2, #pack.Idle))
            M.setAnim(idleFolder:FindFirstChild("Animation1"), pack.Idle[1])
            M.setAnim(idleFolder:FindFirstChild("Animation2"), pack.Idle[2] or pack.Idle[1])
            for i = 3, #pack.Idle do
                local a = idleFolder:FindFirstChild("Animation" .. i)
                if a then M.setAnim(a, pack.Idle[i]) end
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

    M.animPack = packName
    applyingAnim = false
    return true
end

-- ============================================================
-- PLAYER SPEED DISPLAY
-- ============================================================
function M.createPlayerSpeedGui(plr)
    if plr == player then return end
    if M.playerSpeedGuis[plr] then return end
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local old = head:FindFirstChild("MoveePlayerSpeedBB")
    if old then old:Destroy() end
    local bb = Instance.new("BillboardGui")
    bb.Name = "MoveePlayerSpeedBB"
    bb.Size = UDim2.new(0, 80, 0, 24)
    bb.StudsOffset = Vector3.new(0, 2.2, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = head
    bb.Parent = head
    local label = Instance.new("TextLabel", bb)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = "0"
    label.TextColor3 = CHERRY_ACCENT or Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.TextStrokeTransparency = 0
    M.addShimmerToLabel(label, CHERRY_ACCENT or Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255))
    local conn
    conn = char.AncestryChanged:Connect(function(_, parent)
        if not parent then
            M.removePlayerSpeedGui(plr)
            if conn then conn:Disconnect() end
        end
    end)
    M.playerSpeedGuis[plr] = {gui = bb, label = label, conn = conn}
end

function M.removePlayerSpeedGui(plr)
    local data = M.playerSpeedGuis[plr]
    if data then
        if data.conn then data.conn:Disconnect() end
        if data.gui then data.gui:Destroy() end
        M.playerSpeedGuis[plr] = nil
    end
end

function M.updatePlayerSpeed(plr)
    if not M.showPlayerSpeeds then return end
    local data = M.playerSpeedGuis[plr]
    if not data then return end
    local char = plr.Character
    if not char then M.removePlayerSpeedGui(plr); return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local speed = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude
    data.label.Text = string.format("%.1f", speed)
end

function M.updateAllPlayerSpeeds()
    for plr, _ in pairs(M.playerSpeedGuis) do M.updatePlayerSpeed(plr) end
end

function M.startPlayerSpeedUpdates()
    if M.playerSpeedUpdateConn then return end
    M.playerSpeedUpdateConn = RunService.Heartbeat:Connect(function() M.updateAllPlayerSpeeds() end)
end

function M.stopPlayerSpeedUpdates()
    if M.playerSpeedUpdateConn then M.playerSpeedUpdateConn:Disconnect(); M.playerSpeedUpdateConn = nil end
end

function M.togglePlayerSpeeds(on)
    M.showPlayerSpeeds = on
    if on then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then M.createPlayerSpeedGui(plr) end
        end
        M.startPlayerSpeedUpdates()
    else
        for plr, _ in pairs(M.playerSpeedGuis) do M.removePlayerSpeedGui(plr) end
        M.stopPlayerSpeedUpdates()
    end
end

-- ============================================================
-- PLAYER ESP
-- ============================================================
function M.addESP(plr)
    if plr == player then return end
    if M.espList[plr] then M.removeESP(plr) end
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    -- Large circular avatar billboard above enemy
    local avatarBB = Instance.new("BillboardGui")
    avatarBB.Name = "ShadowEnemyAvatar"
    avatarBB.Size = UDim2.new(0, 90, 0, 90)
    avatarBB.StudsOffset = Vector3.new(0, 3.6, 0)
    avatarBB.AlwaysOnTop = true
    avatarBB.MaxDistance = 500
    avatarBB.Adornee = head
    avatarBB.Parent = head

    local ring = Instance.new("Frame")
    ring.Size = UDim2.new(1, 0, 1, 0)
    ring.BackgroundColor3 = Color3.fromRGB(0, 78, 210)
    ring.BorderSizePixel = 0
    ring.Parent = avatarBB
    Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)
    do
        local st = Instance.new("UIStroke")
        st.Color = Color3.fromRGB(255, 255, 255)
        st.Thickness = 2
        st.Transparency = 0.15
        st.Parent = ring
    end

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(1, -8, 1, -8)
    img.Position = UDim2.new(0, 4, 0, 4)
    img.BackgroundTransparency = 1
    img.ScaleType = Enum.ScaleType.Crop
    img.Parent = ring
    Instance.new("UICorner", img).CornerRadius = UDim.new(1, 0)
    pcall(function()
        local ok, content = pcall(function()
            return Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        end)
        if ok and content then
            img.Image = content
        else
            img.Image = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=150&height=150&format=png", plr.UserId)
        end
    end)

    local nameBB = Instance.new("BillboardGui")
    nameBB.Size = UDim2.new(0, 140, 0, 22)
    nameBB.StudsOffset = Vector3.new(0, 5.4, 0)
    nameBB.AlwaysOnTop = true
    nameBB.Adornee = head
    nameBB.Parent = head
    local nameLbl = Instance.new("TextLabel", nameBB)
    nameLbl.Size = UDim2.new(1,0,1,0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = plr.DisplayName or plr.Name
    nameLbl.TextColor3 = Color3.fromRGB(255,255,255)
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextScaled = true
    nameLbl.TextStrokeTransparency = 0
    nameLbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)

    local highlight = Instance.new("Highlight")
    highlight.Adornee = char
    highlight.FillTransparency = 0.8
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(0, 100, 220)
    highlight.FillColor = Color3.fromRGB(0, 100, 220)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char

    M.espList[plr] = {nameBB = nameBB, avatarBB = avatarBB, highlight = highlight}
end

function M.removeESP(plr)
    local data = M.espList[plr]
    if data then
        if data.nameBB then pcall(function() data.nameBB:Destroy() end) end
        if data.avatarBB then pcall(function() data.avatarBB:Destroy() end) end
        if data.highlight then pcall(function() data.highlight:Destroy() end) end
        M.espList[plr] = nil
    end
end

function M.clearESP()
    for plr, _ in pairs(M.espList) do M.removeESP(plr) end
end

function M.toggleESP(on)
    M.playerESPEnabled = on
    if on then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then M.addESP(plr) end
        end
        if not M._espPlayerAdded then
            M._espPlayerAdded = Players.PlayerAdded:Connect(function(p)
                if p ~= player and M.playerESPEnabled then
                    p.CharacterAdded:Connect(function()
                        task.wait(0.5)
                        M.addESP(p)
                    end)
                    if p.Character then task.wait(0.5); M.addESP(p) end
                end
            end)
            M.trackConn(M._espPlayerAdded)
        end
        if not M._espPlayerRemoved then
            M._espPlayerRemoved = Players.PlayerRemoving:Connect(function(p)
                M.removeESP(p)
            end)
            M.trackConn(M._espPlayerRemoved)
        end
    else
        M.clearESP()
        if M._espPlayerAdded then M._espPlayerAdded:Disconnect(); M._espPlayerAdded = nil end
        if M._espPlayerRemoved then M._espPlayerRemoved:Disconnect(); M._espPlayerRemoved = nil end
    end
end

-- ============================================================
-- OVER-HEAD INDICATOR
-- ============================================================
M.headIndicator = nil

function M.setupHeadIndicator(char)
    if not char then return end
    local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 8)
    if not head then return end
    local old = head:FindFirstChild("MoveeHeadIndicator")
    if old then old:Destroy() end

    local bb = Instance.new("BillboardGui")
    bb.Name = "MoveeHeadIndicator"
    bb.Size = UDim2.new(0, 320, 0, 100)
    bb.StudsOffset = Vector3.new(0, 3.6, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 200
    bb.LightInfluence = 0
    bb.ResetOnSpawn = false
    bb.Adornee = head
    bb.Parent = head

    local red = Color3.fromRGB(0, 100, 220)
    local black = Color3.fromRGB(0, 0, 0)

    local discordLbl = Instance.new("TextLabel")
    discordLbl.Name = "DiscordTag"
    discordLbl.Size = UDim2.new(1, 0, 0, 22)
    discordLbl.Position = UDim2.new(0, 0, 0, 0)
    discordLbl.BackgroundTransparency = 1
    discordLbl.Text = "discord.gg/shadowduels"
    discordLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordLbl.Font = Enum.Font.GothamBold
    discordLbl.TextSize = 16
    discordLbl.TextScaled = false
    discordLbl.TextStrokeTransparency = 0
    discordLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    discordLbl.Parent = bb
    do
        local g = Instance.new("UIGradient")
        g.Name = "HalfBlackRed"
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, black),
            ColorSequenceKeypoint.new(0.5, black),
            ColorSequenceKeypoint.new(0.5, red),
            ColorSequenceKeypoint.new(1, red),
        })
        g.Rotation = 0
        g.Parent = discordLbl
    end

    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Size = UDim2.new(0, 140, 0, 2)
    divider.Position = UDim2.new(0.5, -70, 0, 24)
    divider.BackgroundColor3 = red
    divider.BorderSizePixel = 0
    divider.Parent = bb
    Instance.new("UICorner", divider).CornerRadius = UDim.new(1, 0)

    local ragdollLbl = Instance.new("TextLabel")
    ragdollLbl.Name = "RagdollTimer"
    ragdollLbl.Size = UDim2.new(1, 0, 0, 18)
    ragdollLbl.Position = UDim2.new(0, 0, 0, 28)
    ragdollLbl.BackgroundTransparency = 1
    ragdollLbl.Text = ""
    ragdollLbl.TextColor3 = red
    ragdollLbl.Font = Enum.Font.GothamBold
    ragdollLbl.TextSize = 14
    ragdollLbl.TextScaled = false
    ragdollLbl.TextStrokeTransparency = 0
    ragdollLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    ragdollLbl.Parent = bb

    local speedLbl = Instance.new("TextLabel")
    speedLbl.Name = "Speed"
    speedLbl.Size = UDim2.new(1, 0, 0, 42)
    speedLbl.Position = UDim2.new(0, 0, 0, 48)
    speedLbl.BackgroundTransparency = 1
    speedLbl.Text = "0.0"
    speedLbl.TextColor3 = Color3.fromRGB(0, 0, 0)
    speedLbl.Font = Enum.Font.GothamBlack
    speedLbl.TextSize = 32
    speedLbl.TextScaled = false
    speedLbl.TextStrokeTransparency = 0
    speedLbl.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    speedLbl.Parent = bb

    M.headIndicator = {bb = bb, discord = discordLbl, speed = speedLbl, ragdollTimer = ragdollLbl, divider = divider}
    pcall(M.updateHeadTheme)
end

function M.updateHeadTheme()
    if not M.headIndicator then return end
    local red = Color3.fromRGB(0, 100, 220)
    local black = Color3.fromRGB(0, 0, 0)
    if M.headIndicator.discord then
        M.headIndicator.discord.TextColor3 = Color3.fromRGB(255, 255, 255)
        local g = M.headIndicator.discord:FindFirstChild("HalfBlackRed")
        if not g then
            g = Instance.new("UIGradient")
            g.Name = "HalfBlackRed"
            g.Parent = M.headIndicator.discord
        end
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, black),
            ColorSequenceKeypoint.new(0.5, black),
            ColorSequenceKeypoint.new(0.5, red),
            ColorSequenceKeypoint.new(1, red),
        })
        g.Rotation = 0
    end
    if M.headIndicator.speed then
        M.headIndicator.speed.TextColor3 = Color3.fromRGB(0, 0, 0)
    end
    if M.headIndicator.ragdollTimer then
        M.headIndicator.ragdollTimer.TextColor3 = red
    end
    if M.headIndicator.divider then
        M.headIndicator.divider.BackgroundColor3 = red
    end
end

local speedUpdateConn = nil
function M.startHeadSpeedUpdates()
    if speedUpdateConn then return end
    local _headAcc = 0
    speedUpdateConn = RunService.Heartbeat:Connect(function(dt)
        _headAcc = _headAcc + (dt or 0.016)
        if _headAcc < 0.12 then return end
        _headAcc = 0
        local char = player.Character
        if char and M.headIndicator and M.headIndicator.speed then
            local displaySpeed
            if M.autoLeftEnabled or M.autoRightEnabled then
                displaySpeed = M.NS
            else
                displaySpeed = M.getActiveMoveSpeed()
            end
            if type(displaySpeed) ~= "number" then displaySpeed = 0 end
            M.headIndicator.speed.Text = string.format("%.1f", displaySpeed)
            if M.headIndicator.discord and M.headIndicator.discord.Text == "" then
                M.headIndicator.discord.Text = "discord.gg/shadowduels"
            end
        end
    end)
end

function M.stopHeadSpeedUpdates()
    if speedUpdateConn then
        speedUpdateConn:Disconnect()
        speedUpdateConn = nil
    end
end

-- ============================================================
-- Shadow STATUS UI (Steal Bar)
-- ============================================================

-- Steal bar green splash background (from reference HUD)
local function _shadowB64decode(data)
    local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    data = data:gsub("[^"..b.."=]", "")
    return (data:gsub(".", function(x)
        if x == "=" then return "" end
        local r, f = "", (b:find(x) - 1)
        for i = 6, 1, -1 do r = r .. (f % 2^i - f % 2^(i - 1) > 0 and "1" or "0") end
        return r
    end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
        if #x ~= 8 then return "" end
        local c = 0
        for i = 1, 8 do c = c + (x:sub(i, i) == "1" and 2^(8 - i) or 0) end
        return string.char(c)
    end))
end

local SHADOW_STEAL_SPLASH_B64 = "iVBORw0KGgoAAAANSUhEUgAAAgAAAABMCAMAAAAso//2AAAAkFBMVEUezjcb0jUcmC9U+2FH9Vgu1ENT+2APUhksz0Iv5kYdnS8Yry0QaBwHMg06s0Mo0D8WzS1BvkohtzgAAwAitzkx6EgDFgYiuDk58FAGJgs48E9m/3IKORFm/3IXeyY48E8OURkTZyA58VBm/3IgqzUv5UYblS9Z/mYv5UYv10QmxD1Y/mUdojIw5kdl/3EiujmKkBZiAAAAMHRSTlNfnB4kYliKHCiPYZNUKWkuwW4PACptB1BQCi8uDhIcERQYak8jTyFxLy4xTyISbmgKcCVHAAAK9klEQVR42u2dC1caORiGMwLCDFB3VxGxWFYKi4Na/v+/2yQzk3y5fLkBSmvec3qzPWWS55kkk0kiGbMUxV80hTVleS2y6/LapN9mOxjUo9Fof5eSf75yEuprs3mjqWgIUTiVENUvkJ8w8C/ovyMN/wKhz/9fL3+Kv84CfJQAd0AAggmA4dcUkAIUuAAY/+7ur+sGfwr/f3LiJeBNQNUaQNz8f9ojFSBe/qXOX7n9a4E/ln8Gn2zBhmVOQ5qg/H/iEQIURTr/noA/2u/3mf3HtgXAAEIg/wD8UgESyf9V8u+9iHs/0/8UB6QCg4HB/6c/XgFw/q+9HuPf0M8t/6e3AoPBrI/y/65GVcAqQNezSAE0/j0Wfv/vc8//yWPCOeffCWDg/24LUIAg9Nt+xcG/l/Tkl/me/KGg5d/fmfy/40EEIDAI/16vl1uASxKA8h/QMRklFIxfKkBQ/GSmCaDxz2OAy+C/T+TfGkAw/EwAJ/9e4lNAVuCk+PesAdh6+T81MRUgGH4y6wTA+De9QDcRkC34+FlhWuVE5//L5P+kRlWAIPiZAJYGoKenhg7EWpA9SH4fwOAz/JL/DuH/ZAYaQBD8lP/M2wA0odwNC/LM0BnhN+RJNwW0nZkdgAu/qgCx42cCrAMaACCBZkGcBxl+0KyPhZPK/1cYf2AAwTLrppaCBGgtqOta16DxINSErw5+IwPm+qzk1QYgkr80IFCA1xABwKDA9EBtEbRSfgkTQqi/gWzu3Oy7BmBN+V9bBXh68hsQJUAvPHWNmLBvS9wWUskf6IIXOaD+nxL2xt+Hn5Bt0wBcW0cAJxFglyaA6sEAhpVfKal0Xs9va4KLt3Kjw4q4gvlPrPjwCLA2BAji3xlwZgFY2lVjIvPNRimpFqUVtOYChUBRGw27XtyuGoY/2jw/Pw9proIE2H6sAK/J/Pty+eBgXtHiDmlBf8igOmhGOLRQDTkPZO8nG9dqKY8oKyj/Mw/l/i8P/c2E8UdnaXUBfp1egMGJBOj3dQO+VVddSemvz11+KHEZYdcixpDUuD4Uu1Abb4EcUme1IcMEGBeFR4GzCtAYsDvSAHX9MDOgqpSSdsVXdTCMCNMi0JCEBHwiglrlrSCX0Jcii8Vy2Qigrtb8cAEGAzYV2EADS4FeU/i/thqx/+sbF4AVdLEEMXQwjcC0SDQkNi6+CGqDtxU5r4su9/f0p+lwMtH4uwXYnUUAtsoASRp/LtS3akJLz0p6v1CyVGMzAtUi2JCj4/po5GoN3ipyTl1JggC7k88DkHbM3ncmSoBrIcBUL/K9oYNphFuLcEOS4/9YG2oLbxP5/a0ME4DzD+oBOgF4YiYCLALwmQc59Sie22b9fqIGBv/r/t+sB1guYInbYvuNQLWINCQpLr4u1FbeKnK9JqbTkAZg22TdBwbwrloaEDEVXFWHuRJoAJNAZE3zAIN78GoRoG0Abr25R7LwZXnOeD8du+zb4FABzB7AQr4J5WEYwEZqHgXUl0GUvoaf5YA6AEIvQdOg7+QfLkCcFjGGHJOAz789Ml0PYGsAZK2rAvSlBHKw7lAAvA5m8G34IyTgl6RK0JdPDZB/0wAMF0dX0lGGHJfbcwftASw3X9MiK/2xsnbbvyKEHFz8LRLMHGF9g6HAzhBgujh/Lf6+sfYABcHrXDdA1n2nwHfHmjDiwy8cEBbMZm4J1spl7GwNQBbA0wNMVP6ls77XDgmMZkBfFUoM2HAdgjTgAByQvRB2TX21W+r45wYgaQhQliXe7T48rJUYDohmwL4unJjs1Z1nNgW2ahzNgMr/+lvFBMgNQMwQoLTw157DulgscCjQbgxB6esOOAywSQAV6PiXtAGYDHMDECEA3/dfqvfWgzuaBK0C6NYwJ37FgUOrgN0AwwFpgDi3oKxyDxAggBwDlir/tZ++IoHaE9h3hxIf/ggDdAeaK5DnFpVFFiBYAOP2D6cPHFAGhNYN4sTPXyoADKC0X1g8CgD812U5zkOAGAEgfyv+R5gQBSxHRBANP7KuzRwHvIDgCsgTJmhRivF4wgTIkIMEAPxN/I/24D2BxYDmiBjXqkvUACpA/fKCOaAIUEr+WYB4AWz4H93BWgHNgO6QKPeiW9wATQDFAUUAqgD/mfGnAkyzAGECdPzXKv/HkNgbgZ00ABwT51l0jRpQmwZYFChFCiZAlQUIFODQPv+n4FcVAE+FcuGIRQDviucAAYAChgFZgKhXAQdi4f8YkzADrol3jb29CWgFeA81oGh7gEl+CvTOBLMFoQc+4+7hv4KJN4DP0BD/Hgt7E1BTA9553AYI/p0A+SkwTgAE/8oWRAHNAOqAnKEnAXtsVAOkAO9d7ApAA4oP6wF+9/UArQDEzX+FJdAA+Y4mXgBqwFwTQFPALsD4JAL86SuC7u+XbE+AaACs/FeuhBrQzhCRkE12fgEUBSxNQMIQ4GuuCWQNwFD2ADb+K188BojwryQJcLAIgBsAnwHwieC8KriphQXfFORoAFarGAP0N8WQPqdzshbg3dkJMAGqpgcQRc/7AgwdaCUsWQMwxxuA1eo4A9qIqbojBBi9vwd3Ai3/4VQpet4ZpOvA+AsB5JLrSP7QAJsAcqaWgkwfBOoCvKNNwKAsyIELMFxiyE+8N/CcOePeQF4NrAcYwMXftEKTBXjUBYDwSYoABy7APkgAbgBbPkC4AGqxj9kdfNlJ3h1M/4IdDTHnAmyhAG1CBUCbAI1+J0D8RFCIAGA/ARegMraEB5wPYIl+msqlxHNd3vMBmhq5agQY2Pi/NHNvxwtAdAGipoJZD3DjEkA/FYjyJ/OKnwsxBNSRbd36Du+3t7dIEmc7CSbyOsCxAjZJLDow/q0ATTT+L7K2jxGAmALEvAxChgDvnHxtngvFPmY+r2jRKXuDecAZQR/F9+SGRJwRxOtkyKpjczeHu7Ga6rQY4LQgXoC418FmDyBPiZQGgI+ZzzdvQH7/KWFXzWE/f8T5gKI87lPCmrBSi004Wp3WhgGIBOggUBOgKBIWhJg9wEicFNvmZt+dZSwEYN/tzoR+8cd/fcRhYlIGXiPiKGh5uKJ26KLfgbAGgO85i1sS1o4A9uAy1Gts0WvpSm1Q/4pnxXqOjQSHgXfRPeB/cCnwGCJAu+kwalEoeBXYXAG8tBsUvVbSfFp0+FnRmAcjQ4Jw/jPAv4haFt7xv9HOAbaxz9804KQHhhseCAKmAejLIMBfbjuO2Bgi9gUo/G/SyefvGBF7arxqgdYZeF8Ginl5uO88fGsY5F9rh8HHo8/gkz1QJQAKeJYDwNU5hgD+zaFyX5AQ4CYNfoZ9OguaIUGrgHtBkJV/Ebw9XO4KEs8j+c6/iB6hGRU2rwpci0Kt/AvzhBDrARHi9idyciJ3+RegwF1nwItuwIN+/5c2/kXAGUEQP+BfJ/DPApxcANUAdGMIXJ9vEcDtwAHy5xsCxGP/XRbgswW4swjwgDT/Jn8pAOLAAdAng5Z/Y0BuAS6zBTC3B8sNWhr98XhM6I/xwW5B9yXl9GDxwjdpDJAVOP39r4wBbIfFIPzHPKT97QGLdnh093oaPAVkAz5zBCifAsQKQm0RmLI/U8NfVUT+2UVf4O8WKChvfu5yM/AZN39z948kGeuJYfjtz1ZpTojyNYQ/WJ4i0nxllKpAtuA49h1/hYwF/7rE+HP8igCGARp/7TSgbrVPsgDZgWPoc/4qGRt/x/3P+Q9JgRrg5i/WfB5jQGafLoDBf+vibzYAHP90+j+1eD9IBGZwiwAAAABJRU5ErkJggg=="
local SHADOW_STEAL_SPLASH_FILE = "shadow_steal_splash.png"
local function _shadowEnsureStealSplash()
    local ok, asset = pcall(function()
        if not isfile or not writefile or not getcustomasset then return nil end
        if not isfile(SHADOW_STEAL_SPLASH_FILE) then
            writefile(SHADOW_STEAL_SPLASH_FILE, _shadowB64decode(SHADOW_STEAL_SPLASH_B64))
        end
        return getcustomasset(SHADOW_STEAL_SPLASH_FILE)
    end)
    if ok and asset and asset ~= "" then return asset end
    return nil
end

function M.buildStatusUI()
    if M.statusGui then
        pcall(function() M.statusGui:Destroy() end)
        M.statusGui = nil
    end
    if M._stealBarStatsConn then
        pcall(function() M._stealBarStatsConn:Disconnect() end)
        M._stealBarStatsConn = nil
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "StealProgressWindow"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 5

    do
        local ok = false
        if gethui then
            ok = pcall(function() gui.Parent = gethui() end)
        elseif syn and syn.protect_gui then
            ok = pcall(function()
                syn.protect_gui(gui)
                gui.Parent = game:GetService("CoreGui")
            end)
        end
        if not ok then
            gui.Parent = player:WaitForChild("PlayerGui")
        end
    end

    for _, v in ipairs(gui.Parent:GetChildren()) do
        if v ~= gui and v:IsA("ScreenGui") and (v.Name == gui.Name or v.Name == "ShadowStatusUI" or v.Name == "K7_StatusUI") then
            pcall(function() v:Destroy() end)
        end
    end

    -- 7UP-style bottom auto-grab bar: outer black (+ optional bg image), inner red fill
    local barW = math.clamp(tonumber(M.stealBarSize) or 460, 280, 720)
    local barH = 34

    local holder = Instance.new("Frame")
    holder.Name = "StealBarHolder"
    holder.Size = UDim2.new(0, barW, 0, barH)
    holder.Position = UDim2.new(0.5, -math.floor(barW / 2), 1, -58)
    holder.BackgroundTransparency = 1
    holder.BorderSizePixel = 0
    holder.ClipsDescendants = false
    holder.Parent = gui

    -- OUTER shell (black)
    local frame = Instance.new("Frame")
    frame.Name = "StealBar"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.ZIndex = 2
    frame.Parent = holder
    Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
    do
        local st = Instance.new("UIStroke")
        st.Name = "BarContour"
        st.Color = Color3.fromRGB(40, 40, 40)
        st.Thickness = 1.2
        st.Transparency = 0.25
        st.Parent = frame
    end

    -- Optional background image on OUTER shell only
    do
        local bgId = tonumber(M.customBgId) or 0
        if bgId > 0 then
            local bg = Instance.new("ImageLabel")
            bg.Name = "BarBgImage"
            bg.BackgroundTransparency = 1
            bg.Image = "rbxassetid://" .. tostring(bgId)
            bg.ImageTransparency = math.clamp(tonumber(M.customBgOpacity) or 0.35, 0.15, 0.7)
            bg.ScaleType = Enum.ScaleType.Crop
            bg.Size = UDim2.fromScale(1, 1)
            bg.ZIndex = 2
            bg.Parent = frame
            Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
            M.statusBgImg = bg
        else
            M.statusBgImg = nil
        end
    end

    -- LEFT brand chip (SHADOW) — same solid red style as mobile buttons
    local brand = Instance.new("Frame")
    brand.Name = "BrandSide"
    brand.Size = UDim2.new(0, 52, 1, -8)
    brand.Position = UDim2.new(0, 4, 0, 4)
    brand.BackgroundColor3 = Color3.fromRGB(0, 78, 210)
    brand.BackgroundTransparency = 0
    brand.BorderSizePixel = 0
    brand.ZIndex = 4
    brand.Parent = frame
    Instance.new("UICorner", brand).CornerRadius = UDim.new(0, 8)
    local brandLbl = Instance.new("TextLabel")
    brandLbl.Size = UDim2.new(1, 0, 1, 0)
    brandLbl.BackgroundTransparency = 1
    brandLbl.Text = "SHADOW"
    brandLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    brandLbl.Font = Enum.Font.GothamBlack
    brandLbl.TextSize = 11
    brandLbl.TextXAlignment = Enum.TextXAlignment.Center
    brandLbl.ZIndex = 6
    brandLbl.Parent = brand

    -- CENTER progress track (black outside of fill)
    local track = Instance.new("Frame")
    track.Name = "StealTrack"
    track.Size = UDim2.new(1, -190, 1, -10)
    track.Position = UDim2.new(0, 60, 0, 5)
    track.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    track.BackgroundTransparency = 0.08
    track.BorderSizePixel = 0
    track.ClipsDescendants = true
    track.ZIndex = 4
    track.Parent = frame
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    M._stealBadgeMaxW = math.max(40, barW - 210)

    -- RED fill inside track
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 60, 220)
    fill.BorderSizePixel = 0
    fill.ZIndex = 5
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    do
        local g = Instance.new("UIGradient")
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 255)),
            ColorSequenceKeypoint.new(0.55, Color3.fromRGB(0, 60, 200)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 60, 140)),
        })
        g.Parent = fill
    end

    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.new(0, 10, 0, 10)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(1, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 7
    knob.Visible = false
    knob.Parent = fill
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    M.statusKnob = knob

    local shine = Instance.new("Frame")
    shine.Name = "Shine"
    shine.Size = UDim2.new(0.28, 0, 1, 0)
    shine.Position = UDim2.new(-0.4, 0, 0, 0)
    shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    shine.BackgroundTransparency = 1
    shine.BorderSizePixel = 0
    shine.ZIndex = 6
    shine.Parent = fill
    Instance.new("UICorner", shine).CornerRadius = UDim.new(1, 0)
    M.statusFill = fill
    M.statusShine = shine
    M._stealShineTween = nil
    M._stealShineActive = false

    local stealLbl = Instance.new("TextLabel")
    stealLbl.Name = "StealLabel"
    stealLbl.Size = UDim2.new(1, -12, 1, 0)
    stealLbl.Position = UDim2.new(0, 8, 0, 0)
    stealLbl.BackgroundTransparency = 1
    stealLbl.Text = "BRAINROT  0%"
    stealLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    stealLbl.Font = Enum.Font.GothamBold
    stealLbl.TextSize = 11
    stealLbl.TextXAlignment = Enum.TextXAlignment.Left
    stealLbl.ZIndex = 8
    stealLbl.Parent = track
    M.statusStealLbl = stealLbl
    M.statusBarPctLbl = stealLbl
    M.statusPctLbl = stealLbl

    -- RIGHT side pieces (mode + fps) — black outer
    local rightSide = Instance.new("Frame")
    rightSide.Name = "RightSide"
    rightSide.Size = UDim2.new(0, 120, 1, -8)
    rightSide.Position = UDim2.new(1, -124, 0, 4)
    rightSide.BackgroundTransparency = 1
    rightSide.ZIndex = 4
    rightSide.Parent = frame

    local modePill = Instance.new("Frame")
    modePill.Size = UDim2.new(0, 54, 1, 0)
    modePill.Position = UDim2.new(0, 0, 0, 0)
    modePill.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    modePill.BackgroundTransparency = 0.2
    modePill.BorderSizePixel = 0
    modePill.ZIndex = 5
    modePill.Parent = rightSide
    Instance.new("UICorner", modePill).CornerRadius = UDim.new(1, 0)
    local modeLbl = Instance.new("TextLabel")
    modeLbl.Size = UDim2.new(1, 0, 1, 0)
    modeLbl.BackgroundTransparency = 1
    modeLbl.Text = "NORMAL"
    modeLbl.TextColor3 = Color3.fromRGB(230, 230, 235)
    modeLbl.Font = Enum.Font.GothamBlack
    modeLbl.TextSize = 9
    modeLbl.ZIndex = 6
    modeLbl.Parent = modePill
    M.statusModePill = modePill
    M.statusModeLbl = modeLbl

    local statsPill = Instance.new("Frame")
    statsPill.Size = UDim2.new(0, 60, 1, 0)
    statsPill.Position = UDim2.new(0, 58, 0, 0)
    statsPill.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    statsPill.BackgroundTransparency = 0.2
    statsPill.BorderSizePixel = 0
    statsPill.ZIndex = 5
    statsPill.Parent = rightSide
    Instance.new("UICorner", statsPill).CornerRadius = UDim.new(1, 0)
    local statsLbl = Instance.new("TextLabel")
    statsLbl.Size = UDim2.new(1, -4, 1, 0)
    statsLbl.Position = UDim2.new(0, 2, 0, 0)
    statsLbl.BackgroundTransparency = 1
    statsLbl.Text = "-- FPS\n--ms"
    statsLbl.TextColor3 = Color3.fromRGB(210, 210, 215)
    statsLbl.Font = Enum.Font.GothamBold
    statsLbl.TextSize = 8
    statsLbl.TextYAlignment = Enum.TextYAlignment.Center
    statsLbl.ZIndex = 6
    statsLbl.Parent = statsPill
    M.statusFpsLbl = statsLbl

    M.statusEqIcon = nil
    M.statusRadiusLbl = nil
    M.statusDot = nil
    M.statusRadiusMarker = nil
    M.statusRadiusMarkerLbl = nil
    M.updateRadiusMarker = function() end
    M.statusGui = gui
    M.statusMain = frame
    M.statusHolder = holder

    function M.updateStatusModeBadge() end

    do
        local last = tick()
        local frames = 0
        local fps = 60
        M._stealBarStatsConn = RunService.RenderStepped:Connect(function()
            frames = frames + 1
            local now = tick()
            if now - last >= 0.4 then
                fps = math.floor(frames / (now - last) + 0.5)
                frames = 0
                last = now
                if M.statusFpsLbl and M.statusFpsLbl.Parent then
                    local ping = 0
                    pcall(function()
                        ping = math.floor(player:GetNetworkPing() * 1000 + 0.5)
                    end)
                    M.statusFpsLbl.Text = string.format("%d FPS\n%dms", fps, ping)
                end
            end
        end)
    end
end


function M.updateStealProgress(progress, label)
    progress = math.clamp(progress or 0, 0, 1)
    local pct = math.floor(progress * 100 + 0.5)
    if M.statusFill then
        M.statusFill.Size = UDim2.new(progress, 0, 1, 0)
        -- Stage colors: 0–50% white → 50–75% yellow/orange → 75%+ red
        local col
        if progress < 0.5 then
            col = Color3.fromRGB(255, 255, 255)
        elseif progress < 0.75 then
            local t = (progress - 0.5) / 0.25
            col = Color3.fromRGB(255, 230, 40):Lerp(Color3.fromRGB(0, 160, 255), t)
        else
            local t = math.clamp((progress - 0.75) / 0.25, 0, 1)
            col = Color3.fromRGB(0, 100, 230):Lerp(Color3.fromRGB(0, 60, 200), t)
        end
        M.statusFill.BackgroundColor3 = col
        local grad = M.statusFill:FindFirstChildOfClass("UIGradient")
        if grad then
            if progress < 0.5 then
                grad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 230, 235)),
                })
            elseif progress < 0.75 then
                grad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 240, 80)),
                    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(0, 160, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 160, 255)),
                })
            else
                grad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 110, 255)),
                    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(0, 60, 210)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 60, 140)),
                })
            end
        end
    end
    if M.statusKnob then
        M.statusKnob.Visible = progress > 0.02
    end
    local text
    if type(label) == "string" and label ~= "" and not tostring(label):match("^%d") then
        text = string.format("%s  %d%%", string.upper(label), pct)
    else
        text = string.format("BRAINROT  %d%%", pct)
    end
    if M.statusBarPctLbl then M.statusBarPctLbl.Text = text end
    if M.statusPctLbl and M.statusPctLbl ~= M.statusBarPctLbl then
        M.statusPctLbl.Text = text
    end
    if M.statusStealLbl and M.statusStealLbl ~= M.statusBarPctLbl then
        M.statusStealLbl.Text = text
    end
    if progress > 0.02 and progress < 1 then
        if not M._stealShineActive and M.statusShine then
            M._stealShineActive = true
            M.statusShine.BackgroundTransparency = 0.55
            local function loopShine()
                if not M._stealShineActive or not M.statusShine or not M.statusShine.Parent then
                    M._stealShineActive = false
                    return
                end
                M.statusShine.Position = UDim2.new(-0.45, 0, 0, 0)
                local tw = TweenService:Create(M.statusShine, TweenInfo.new(0.85, Enum.EasingStyle.Linear), {
                    Position = UDim2.new(1.1, 0, 0, 0)
                })
                M._stealShineTween = tw
                tw:Play()
                tw.Completed:Connect(function()
                    if M._stealShineActive then
                        task.delay(0.15, loopShine)
                    end
                end)
            end
            loopShine()
        end
    else
        M._stealShineActive = false
        if M._stealShineTween then pcall(function() M._stealShineTween:Cancel() end) end
        if M.statusShine then
            M.statusShine.BackgroundTransparency = 1
            M.statusShine.Position = UDim2.new(-0.4, 0, 0, 0)
        end
        if progress <= 0 and M.statusKnob then
            M.statusKnob.Visible = false
        end
    end
end


function M.updateStatusRadius()
    if M.statusRadiusLbl then
        M.statusRadiusLbl.Text = "Radius: " .. tostring(M.getActiveStealRadius())
    end
    if M.headerRadiusLbl then
        M.headerRadiusLbl.Text = tostring(M.getActiveStealRadius())
    end
    if M.updateRadiusMarker then
        M.updateRadiusMarker()
    end
end

-- ============================================================
-- AUTO STEAL (unchanged)
-- ============================================================
if not fireproximityprompt then
    fireproximityprompt = (getgenv and getgenv().fireproximityprompt)
        or (genv and genv().fireproximityprompt)
        or function(prompt)
            pcall(function()
                prompt:InputHoldBegin()
                task.wait(0.05)
                prompt:InputHoldEnd()
            end)
        end
end

local function isMyPlot(plotName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
    end
    return false
end

local function scanPlotNormal(plot)
    if not plot or not plot:IsA("Model") then return end
    if isMyPlot(plot.Name) then return end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return end
    for _, pod in ipairs(podiums:GetChildren()) do
        if pod:IsA("Model") and pod:FindFirstChild("Base") then
            local uid = plot.Name .. "_" .. pod.Name
            for _, ex in ipairs(M.animalCache) do if ex.uid == uid then return end end
            table.insert(M.animalCache, {
                name = pod.Name,
                plot = plot.Name,
                slot = pod.Name,
                worldPosition = pod:GetPivot().Position,
                uid = uid,
            })
        end
    end
end

local function findPromptNormal(ad)
    if not ad then return nil end
    local cp = M.promptCache[ad.uid]
    if cp and cp.Parent then return cp end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local plot = plots:FindFirstChild(ad.plot)
    if not plot then return nil end
    local pods = plot:FindFirstChild("AnimalPodiums")
    if not pods then return nil end
    local pod = pods:FindFirstChild(ad.slot)
    if not pod then return nil end
    local base = pod:FindFirstChild("Base")
    if not base then return nil end
    local spawn = base:FindFirstChild("Spawn")
    if not spawn then return nil end
    local att = spawn:FindFirstChild("PromptAttachment")
    local prompt = nil
    if att then
        for _, p in ipairs(att:GetChildren()) do
            if p:IsA("ProximityPrompt") then prompt = p; break end
        end
    end
    if not prompt then
        for _, obj in ipairs(spawn:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then prompt = obj; break end
        end
    end
    if prompt then M.promptCache[ad.uid] = prompt end
    return prompt
end

local function nearestAnimalNormal()
    local char = player.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
    if not hrp then return nil end
    local best, bestD = nil, math.huge
    for _, ad in ipairs(M.animalCache) do
        if not isMyPlot(ad.plot) and ad.worldPosition then
            local d = (hrp.Position - ad.worldPosition).Magnitude
            if d < bestD then bestD = d; best = ad end
        end
    end
    return best, bestD
end

local function buildCallbacks(prompt)
    if M.stealCache[prompt] then return end
    local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
    local ok1, c1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if ok1 and type(c1) == "table" then
        for _, conn in ipairs(c1) do
            if type(conn.Function) == "function" then
                table.insert(data.holdCallbacks, conn.Function)
            end
        end
    end
    local ok2, c2 = pcall(getconnections, prompt.Triggered)
    if ok2 and type(c2) == "table" then
        for _, conn in ipairs(c2) do
            if type(conn.Function) == "function" then
                table.insert(data.triggerCallbacks, conn.Function)
            end
        end
    end
    if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then
        M.stealCache[prompt] = data
    end
end

local function execStealNormal(prompt, animalName)
    local data = M.stealCache[prompt]
    if not data or not data.ready then return false end
    data.ready = false
    M.isStealing = true
    M.stealStartTime = tick()
    M.updateStealProgress(0.1)

    if M.progressConn then M.progressConn:Disconnect() end
    M.progressConn = RunService.Heartbeat:Connect(function()
        if not M.isStealing then
            M.progressConn:Disconnect()
            M.progressConn = nil
            return
        end
        local prog = math.clamp((tick() - M.stealStartTime) / M.Steal.StealDuration, 0, 1)
        M.updateStealProgress(prog)
    end)

    task.spawn(function()
        for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
        local elapsed = 0
        while elapsed < M.Steal.StealDuration do elapsed = elapsed + task.wait() end
        for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
        task.wait(0.01)
        if M.progressConn then M.progressConn:Disconnect(); M.progressConn = nil end
        M.isStealing = false
        M.updateStealProgress(0)
        data.ready = true
    end)
    return true
end

function M.startNormalSteal()
    if M.stealConn then return end
    M.stealConn = RunService.Heartbeat:Connect(function()
        if not M.Steal.AutoStealEnabled or (M.stealMode ~= "Normal" and M.stealMode ~= "V1") or M.isStealing then return end
        local target, dist = nearestAnimalNormal()
        if not target then return end
        if dist > M.getActiveStealRadius() then return end
        local prompt = M.promptCache[target.uid]
        if not prompt or not prompt.Parent then
            prompt = findPromptNormal(target)
        end
        if prompt then
            buildCallbacks(prompt)
            execStealNormal(prompt, target.name)
        end
    end)
end

function M.stopNormalSteal()
    if M.stealConn then
        M.stealConn:Disconnect()
        M.stealConn = nil
    end
    M.isStealing = false
    if M.progressConn then M.progressConn:Disconnect(); M.progressConn = nil end
    M.updateStealProgress(0)
end

-- ============================================================
-- V2 AUTO-STEAL (from SHADOW — pause at 75%, finish when close)
-- ============================================================
do
    local V2 = M.V2 or {}
    M.V2 = V2
    V2.enabled = false
    V2.isStealing = false
    V2.data = V2.data or {}
    V2.conn = nil
    V2.progressConn = nil
    V2.stealStartTime = 0
    V2.paused = false
    V2.pauseStarted = nil
    V2.pausedDuration = 0
    local function barSet(p, label)
        local progress = math.clamp(tonumber(p) or 0, 0, 1)
        local pct = math.floor(progress * 100 + 0.5)
        local text = nil
        if type(label) == "string" and label ~= "" then
            text = string.upper(label)
            if progress > 0 then text = text .. "  " .. tostring(pct) .. "%" end
        end
        M.updateStealProgress(progress, text)
    end
    local function barReset()
        M.updateStealProgress(0)
    end
    local function execStealV2(prompt)
        if V2.isStealing then return end
        if not prompt then return end
        buildCallbacks(prompt)
        local data = M.stealCache[prompt]
        if not data or not data.ready then return end
        data.ready = false
        V2.isStealing = true
        M.isStealing = true
        V2.stealStartTime = tick()
        V2.paused = false
        V2.pauseStarted = nil
        V2.pausedDuration = 0
        local duration = math.max(tonumber(M.Steal.StealDuration) or 1.4, 0.05)
        local pauseFraction = 0.75 -- always pause / hold bar at 75%
        local finishFraction = 1 - pauseFraction
        local targetPart = prompt:FindFirstAncestorWhichIsA("BasePart")
        local restarting = false
        local function modeStillActive()
            return V2.enabled and M.stealMode == "V2" and V2.isStealing
        end
        local function isTargetInCurrentRadius()
            local char = player.Character
            local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
            local radius = M.getActiveStealRadius()
            return root and targetPart and targetPart.Parent and (root.Position - targetPart.Position).Magnitude <= radius
        end
        local function isCloseEnoughToGrab()
            -- While auto left/right pathing, don't require tight range — steal must continue
            if M.autoLeftEnabled or M.autoRightEnabled then
                return isTargetInCurrentRadius()
            end
            local char = player.Character
            local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
            local closeRange = math.min(M.getActiveStealRadius(), 12)
            return root and targetPart and targetPart.Parent and (root.Position - targetPart.Position).Magnitude <= closeRange
        end
        local function canStillGrab()
            if not prompt or not prompt.Parent or not targetPart or not targetPart.Parent then return false end
            -- Keep grab alive during auto left/right even if prompt briefly disables
            if M.autoLeftEnabled or M.autoRightEnabled then
                return isTargetInCurrentRadius() or true
            end
            if not prompt.Enabled then return false end
            if not tostring(prompt.ActionText):lower():find("steal", 1, true) then return false end
            return isTargetInCurrentRadius()
        end
        local function restartFromZero()
            if restarting then return end
            restarting = true
            V2.paused = false
            V2.pauseStarted = nil
            V2.pausedDuration = 0
            if V2.progressConn then V2.progressConn:Disconnect(); V2.progressConn = nil end
            barReset()
            data.ready = true
            V2.isStealing = false
            M.isStealing = false
        end
        if V2.progressConn then V2.progressConn:Disconnect() end
        V2.progressConn = RunService.Heartbeat:Connect(function()
            if not V2.isStealing then
                if V2.progressConn then V2.progressConn:Disconnect(); V2.progressConn = nil end
                return
            end
            if not modeStillActive() or not canStillGrab() then
                restartFromZero()
                return
            end
            local elapsed = tick() - V2.stealStartTime - (V2.pausedDuration or 0)
            if V2.paused and V2.pauseStarted then
                -- freeze bar exactly at 75% while waiting to finish
                barSet(pauseFraction, "BRAINROT")
            else
                -- never show past 75% until finish phase resumes
                local p = math.clamp(elapsed / duration, 0, 1)
                if p > pauseFraction then p = pauseFraction end
                barSet(p)
            end
        end)
        task.spawn(function()
            for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
            if #data.holdCallbacks == 0 and #data.triggerCallbacks == 0 and fireproximityprompt then
                pcall(function()
                    fireproximityprompt(prompt, duration)
                end)
            end
            local holdStart = tick()
            while tick() - holdStart < duration * pauseFraction do
                if not modeStillActive() or not canStillGrab() then
                    restartFromZero()
                    return
                end
                task.wait()
            end
            V2.paused = true
            V2.pauseStarted = tick()
            barSet(pauseFraction, "BRAINROT") -- hard stop display at 75%
            local wasAbleToGrab = false
            local waitStart = tick()
            while modeStillActive() do
                if not canStillGrab() then
                    restartFromZero()
                    return
                end
                if isCloseEnoughToGrab() then
                    wasAbleToGrab = true
                    break
                end
                if tick() - waitStart >= 0.95 then
                    wasAbleToGrab = true
                    break
                end
                task.wait()
            end
            if not modeStillActive() or not canStillGrab() then
                restartFromZero()
                return
            end
            if wasAbleToGrab then
                V2.pausedDuration = (V2.pausedDuration or 0) + (tick() - V2.pauseStarted)
                V2.paused = false
                V2.pauseStarted = nil
                local finishStart = tick()
                while tick() - finishStart < duration * finishFraction do
                    if not modeStillActive() or not canStillGrab() then
                        restartFromZero()
                        return
                    end
                    task.wait()
                end
                for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
                pcall(function() if _G.AutoCarrySpeed and _G.AutoCarrySpeed.WatchPickup then _G.AutoCarrySpeed.WatchPickup(1.25) end end)
                if V2.progressConn then V2.progressConn:Disconnect(); V2.progressConn = nil end
                barSet(1, "SUCCESS")
                task.wait(0.05)
                barReset()
                data.ready = true
                V2.isStealing = false
                M.isStealing = false
            else
                restartFromZero()
            end
        end)
    end
    function M.startV2Steal()
        V2.enabled = true
        V2.isStealing = false
        if V2.conn then V2.conn:Disconnect(); V2.conn = nil end
        V2.conn = RunService.Heartbeat:Connect(function()
            if not V2.enabled then return end
            if not M.Steal.AutoStealEnabled then return end
            if M.stealMode ~= "V2" then M.stopV2Steal(); return end
            if V2.isStealing then return end
            local target, dist = nearestAnimalNormal()
            if not target then return end
            if dist > M.getActiveStealRadius() then return end
            local prompt = M.promptCache[target.uid]
            if not prompt or not prompt.Parent then
                prompt = findPromptNormal(target)
            end
            if prompt then
                execStealV2(prompt)
            end
        end)
    end
    function M.stopV2Steal()
        V2.enabled = false
        V2.isStealing = false
        V2.paused = false
        V2.pauseStarted = nil
        V2.pausedDuration = 0
        if V2.conn then V2.conn:Disconnect(); V2.conn = nil end
        if V2.progressConn then V2.progressConn:Disconnect(); V2.progressConn = nil end
        M.isStealing = false
        barReset()
    end
end

-- ============================================================
-- SEMI AUTO-STEAL (unchanged)
-- ============================================================
do
    local A = M.Semi
    if A.conn then pcall(function() A.conn:Disconnect() end); A.conn = nil end
    A.enabled = false
    A.holdMin = tonumber(A.holdMin) or 1.3
    A.holdMax = tonumber(A.holdMax) or 2.6
    A.entryDelay = tonumber(A.entryDelay) or 0.3
    A.cooldown = tonumber(A.cooldown) or 0.05
    A.primeRange = tonumber(A.primeRange) or 80
    A.radius = math.min(tonumber(A.radius) or 10, 10)
    A.plotSync = A.plotSync or {caches = {}, connections = {}}
    A.animals = A.animals or {}
    A.promptCache = A.promptCache or {}
    A.internalCache = A.internalCache or {}
    A.state = A.state or {active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0}

    local function barSet(p, label)
        local progress = math.clamp(tonumber(p) or 0, 0, 1)
        local pct = math.floor(progress * 100 + 0.5)
        local text = nil
        if type(label) == "string" and label ~= "" then
            text = string.upper(label)
            if progress > 0 then
                text = text .. "  " .. tostring(pct) .. "%"
            end
        end
        M.updateStealProgress(progress, text)
    end
    local function barReset()
        M.updateStealProgress(0)
    end
    local function rootPart()
        local char = player.Character
        return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")) or nil
    end
    local function splitPath(path)
        if typeof(path) == "table" then return path end
        local out = {}
        for part in string.gmatch(tostring(path), "[^%.]+") do
            table.insert(out, tonumber(part) or part)
        end
        return out
    end
    local function resolvePath(path, root)
        local current, parent, key = root, nil, nil
        for _, part in ipairs(splitPath(path)) do
            parent = current
            key = part
            current = current and current[part] or nil
        end
        return current, parent, key
    end
    local function applySyncDiff(channelName, packet)
        local cache = A.plotSync.caches[channelName]
        if typeof(cache) ~= "table" then return end
        local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
        local current, parent, key = resolvePath(path, cache)
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
    local function attachPlotChannel(remote, plots, requestData)
        if A.plotSync.connections[remote] then return end
        local channelName = tostring(remote.Name)
        if not plots:FindFirstChild(channelName) then return end
        if requestData and A.plotSync.caches[channelName] == nil then
            local ok, data = pcall(function() return requestData:InvokeServer(channelName) end)
            A.plotSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
        elseif A.plotSync.caches[channelName] == nil then
            A.plotSync.caches[channelName] = {}
        end
        A.plotSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
            for _, packet in ipairs(queue) do applySyncDiff(channelName, packet) end
        end)
    end

    function M.initSemiSync()
        if A.syncReady then return true end
        local ok = pcall(function()
            local rs = game:GetService("ReplicatedStorage")
            A.packages = rs:WaitForChild("Packages", 10)
            A.datas = rs:WaitForChild("Datas", 10)
            A.plots = workspace:WaitForChild("Plots", 10)
            if not (A.packages and A.datas and A.plots) then return end
            A.animalsData = require(A.datas:WaitForChild("Animals", 10))
            local sync = A.packages:WaitForChild("Synchronizer", 10)
            A.channelFolder = sync:WaitForChild("Channel", 10)
            A.routeRemote = sync:WaitForChild("CommunicationRoute", 10)
            A.requestData = sync:FindFirstChild("RequestData")
            for _, child in ipairs(A.channelFolder:GetChildren()) do
                if child:IsA("RemoteEvent") then attachPlotChannel(child, A.plots, A.requestData) end
            end
            A.channelFolder.ChildAdded:Connect(function(child)
                if child:IsA("RemoteEvent") then attachPlotChannel(child, A.plots, A.requestData) end
            end)
            A.routeRemote.OnClientEvent:Connect(function(actions)
                for _, action in ipairs(actions) do
                    local kind, channelName = action[1], tostring(action[2])
                    if A.plots and A.plots:FindFirstChild(channelName) then
                        if kind == "ListenerAdded" then
                            local remote = A.channelFolder and A.channelFolder:FindFirstChild(channelName)
                            if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote, A.plots, A.requestData) end
                        elseif kind == "ListenerRemoved" then
                            for remote, conn in pairs(A.plotSync.connections) do
                                if tostring(remote.Name) == channelName then
                                    pcall(function() conn:Disconnect() end)
                                    A.plotSync.connections[remote] = nil
                                    A.plotSync.caches[channelName] = nil
                                    break
                                end
                            end
                        end
                    end
                end
            end)
            A.syncReady = true
        end)
        return ok and A.syncReady == true
    end

    local function getPlotOwner(plot)
        local sign = plot and plot:FindFirstChild("PlotSign")
        local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
        local label = frame and frame:FindFirstChild("TextLabel")
        if not label or label.Text == "Empty Base" then return nil end
        return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
    end
    local function isMyBaseAnimal(animalData)
        if not animalData or not animalData.plot or not A.plots then return false end
        local plot = A.plots:FindFirstChild(animalData.plot)
        if not plot then return false end
        local owner = getPlotOwner(plot)
        return owner == player.DisplayName or owner == player.Name
    end
    local function podiumFor(animalData)
        local plot = A.plots and A.plots:FindFirstChild(animalData.plot)
        local podiums = plot and plot:FindFirstChild("AnimalPodiums")
        return podiums and podiums:FindFirstChild(animalData.slot) or nil
    end
    local function animalPos(animalData)
        local podium = podiumFor(animalData)
        return podium and podium:GetPivot().Position or nil
    end
    local function distToAnimal(animalData)
        local root = rootPart()
        local pos = animalPos(animalData)
        return root and pos and (root.Position - pos).Magnitude or math.huge
    end
    local function findPromptForAnimal(animalData)
        if not animalData then return nil end
        local cached = A.promptCache[animalData.uid]
        if cached and cached.Parent then return cached end
        local podium = podiumFor(animalData)
        local base = podium and podium:FindFirstChild("Base")
        local spawn = base and base:FindFirstChild("Spawn")
        local attach = spawn and spawn:FindFirstChild("PromptAttachment")
        if not attach then return nil end
        for _, prompt in ipairs(attach:GetChildren()) do
            if prompt:IsA("ProximityPrompt") then
                A.promptCache[animalData.uid] = prompt
                return prompt
            end
        end
        return nil
    end

    function M.scanAllPlotsSemi()
        if not M.initSemiSync() then return 0 end
        local newCache = {}
        for _, plot in ipairs(A.plots:GetChildren()) do
            local cache = A.plotSync.caches[plot.Name]
            local animalList = cache and cache.AnimalList
            if typeof(animalList) == "table" then
                for slot, animalData in pairs(animalList) do
                    if type(animalData) == "table" then
                        local animalName = animalData.Index
                        local info = A.animalsData and A.animalsData[animalName]
                        if info then
                            table.insert(newCache, {
                                name = info.DisplayName or animalName,
                                plot = plot.Name,
                                slot = tostring(slot),
                                uid = plot.Name .. "_" .. tostring(slot),
                            })
                        end
                    end
                end
            end
        end
        A.animals = newCache
        return #newCache
    end

    local function pickClosest()
        local root = rootPart()
        if not root then return nil end
        local best, bestDist = nil, math.huge
        for _, animalData in ipairs(A.animals) do
            if not isMyBaseAnimal(animalData) then
                local pos = animalPos(animalData)
                local dist = pos and (root.Position - pos).Magnitude or math.huge
                if dist <= (A.primeRange or 80) and dist < bestDist then
                    best, bestDist = animalData, dist
                end
            end
        end
        return best
    end
    local function buildCallbacks(prompt)
        if A.internalCache[prompt] then return end
        local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
        local okHold, holds = pcall(getconnections, prompt.PromptButtonHoldBegan)
        if okHold and type(holds) == "table" then
            for _, conn in ipairs(holds) do
                if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end
            end
        end
        local okTrigger, triggers = pcall(getconnections, prompt.Triggered)
        if okTrigger and type(triggers) == "table" then
            for _, conn in ipairs(triggers) do
                if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end
            end
        end
        if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then A.internalCache[prompt] = data end
    end
    local function executeSemi(prompt, animalData)
        if not prompt or not prompt.Parent or not animalData then return false end
        buildCallbacks(prompt)
        local data = A.internalCache[prompt]
        if not data or not data.ready then return false end
        data.ready = false
        A.state.active = true
        A.state.startTime = tick()
        A.state.phase = "holding"
        A.state.label = animalData.name or "Animal"
        M.isStealing = true
        M.stealStartTime = A.state.startTime
        task.spawn(function()
            local startTime = A.state.startTime
            for _, fn in ipairs(data.holdCallbacks) do task.spawn(function() pcall(fn) end) end
            while A.enabled and M.stealMode == "Semi" and tick() - startTime < (A.holdMin or 1.3) do
                local elapsed = tick() - startTime
                A.state.phase = "holding"
                barSet(elapsed / (A.holdMax or 2.6), "HOLDING " .. tostring(A.state.label))
                task.wait()
            end
            A.state.phase = "waitingRange"
            local alreadyInRange = distToAnimal(animalData) <= (tonumber(A.radius) or 10)
            local fired = false
            while A.enabled and M.stealMode == "Semi" and prompt.Parent do
                local elapsed = tick() - startTime
                if elapsed > (A.holdMax or 2.6) then break end
                barSet(elapsed / (A.holdMax or 2.6), "MOVE CLOSER  " .. tostring(A.state.label))
                if distToAnimal(animalData) <= (tonumber(A.radius) or 10) then
                    if not alreadyInRange then task.wait(A.entryDelay or 0.3) end
                    if A.enabled and M.stealMode == "Semi" then
                        for _, fn in ipairs(data.triggerCallbacks) do task.spawn(function() pcall(fn) end) end
                        pcall(function() if _G.AutoCarrySpeed and _G.AutoCarrySpeed.WatchPickup then _G.AutoCarrySpeed.WatchPickup(1.25) end end)
                        fired = true
                    end
                    break
                end
                task.wait()
            end
            A.state.lastResult = fired and ("Stole " .. tostring(A.state.label)) or ("Missed window: " .. tostring(A.state.label))
            A.state.active = false
            A.state.phase = "idle"
            A.state.lastResultTime = tick()
            if fired then
                barSet(1, "STOLE " .. tostring(A.state.label))
            else
                barSet(0, A.state.lastResult)
            end
            task.wait(A.cooldown or 0.05)
            data.ready = true
            M.isStealing = false
            barReset()
        end)
        return true
    end

    function M.stopSemiSteal()
        A.enabled = false
        if A.conn then A.conn:Disconnect(); A.conn = nil end
        A.state.active = false
        A.state.phase = "idle"
        M.isStealing = false
        barReset()
    end

    function M.startSemiSteal()
        A.radius = math.min(tonumber(A.radius) or 10, 10)
        A.enabled = true
        M.initSemiSync()
        pcall(M.scanAllPlotsSemi)
        if A.conn then A.conn:Disconnect(); A.conn = nil end
        A.conn = RunService.Heartbeat:Connect(function()
            if not A.enabled then return end
            if not M.Steal.AutoStealEnabled then return end
            if M.stealMode ~= "Semi" then M.stopSemiSteal(); return end
            if A.state.active then return end
            local target = pickClosest()
            if not target then return end
            local prompt = findPromptForAnimal(target)
            if prompt then executeSemi(prompt, target) end
        end)
    end
end

local function v3ReleasePrompt(prompt)
    if not prompt then return end
    pcall(function()
        if prompt.InputHoldEnd then prompt:InputHoldEnd() end
    end)
end

local function v3HoldPrompt(prompt)
    if not prompt or not prompt.Parent then return false end
    -- Native hold (works without getconnections)
    local ok = pcall(function()
        if prompt.InputHoldBegin then
            prompt:InputHoldBegin()
        end
    end)
    if not ok then
        pcall(function()
            if fireproximityprompt then
                fireproximityprompt(prompt)
            end
        end)
    end
    -- Also fire hooked hold callbacks if available
    buildCallbacks(prompt)
    local data = M.stealCache[prompt]
    if data then
        for _, fn in ipairs(data.holdCallbacks) do
            task.spawn(function() pcall(fn) end)
        end
    end
    return true
end

local function v3TriggerPrompt(prompt)
    if not prompt then return end
    buildCallbacks(prompt)
    local data = M.stealCache[prompt]
    if data then
        for _, fn in ipairs(data.triggerCallbacks) do
            task.spawn(function() pcall(fn) end)
        end
    end
    pcall(function()
        if prompt.InputHoldEnd then prompt:InputHoldEnd() end
    end)
    pcall(function()
        if fireproximityprompt then
            fireproximityprompt(prompt)
        end
    end)
end

local function v3LiveDist(ad, hrp)
    if not ad or not hrp then return math.huge end
    -- Prefer live podium position so cache doesn't go stale
    local plots = workspace:FindFirstChild("Plots")
    local plot = plots and plots:FindFirstChild(ad.plot)
    local pods = plot and plot:FindFirstChild("AnimalPodiums")
    local pod = pods and pods:FindFirstChild(ad.slot)
    if pod then
        local ok, pos = pcall(function() return pod:GetPivot().Position end)
        if ok and pos then
            ad.worldPosition = pos
            return (hrp.Position - pos).Magnitude
        end
    end
    if ad.worldPosition then
        return (hrp.Position - ad.worldPosition).Magnitude
    end
    return math.huge
end

function M.startV3Steal()
    if M.V3.conn then return end
    M.V3.enabled = true
    M.V3.progress = 0
    M.V3.currentUid = nil
    M.V3.lastInRange = 0
    M.V3.holding = false
    M.V3.holdPrompt = nil
    M.V3.cooldownUntil = 0
    M.V3.lastHoldPulse = 0

    M.V3.conn = RunService.Heartbeat:Connect(function(dt)
        if not M.Steal.AutoStealEnabled or M.stealMode ~= "V3" or not M.V3.enabled then
            if M.V3.holdPrompt then v3ReleasePrompt(M.V3.holdPrompt) end
            if M.V3.progress > 0 or M.V3.holding or M.isStealing then
                M.V3.progress = 0
                M.V3.currentUid = nil
                M.V3.holding = false
                M.V3.holdPrompt = nil
                M.isStealing = false
                M.updateStealProgress(0)
            end
            return
        end

        local stopT = math.max(tonumber(M.Steal.StopTime) or 0.35, 0.05)
        local holdT = math.max(tonumber(M.Steal.StealDuration) or 1.4, 0.05)

        if tick() < (M.V3.cooldownUntil or 0) then
            M.updateStealProgress(0)
            return
        end

        local char = player.Character
        local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
        if not hrp then return end

        local target = nearestAnimalNormal()
        local dist = target and v3LiveDist(target, hrp) or math.huge
        local radius = M.getActiveStealRadius()
        local inRange = target ~= nil and dist <= radius

        if inRange then
            M.V3.lastInRange = tick()

            if M.V3.currentUid ~= target.uid then
                -- switched pet: release old hold, keep some progress only if same fill preferred restart
                if M.V3.holdPrompt then v3ReleasePrompt(M.V3.holdPrompt) end
                M.V3.currentUid = target.uid
                M.V3.progress = 0
                M.V3.holding = false
                M.V3.holdPrompt = nil
            end

            local prompt = M.promptCache[target.uid]
            if not prompt or not prompt.Parent then
                prompt = findPromptNormal(target)
            end
            if not prompt then
                -- still show proximity progress so bar matches video feel
                M.V3.progress = math.clamp(M.V3.progress + (dt / holdT), 0, 1)
                M.updateStealProgress(M.V3.progress)
                M.isStealing = M.V3.progress > 0
                return
            end

            -- Keep hold alive: pulse InputHoldBegin ~10x/sec while in range
            M.V3.holdPrompt = prompt
            M.isStealing = true
            local now = tick()
            if (not M.V3.holding) or (now - (M.V3.lastHoldPulse or 0) > 0.1) then
                M.V3.holding = true
                M.V3.lastHoldPulse = now
                v3HoldPrompt(prompt)
            end

            M.V3.progress = math.clamp(M.V3.progress + (dt / holdT), 0, 1)
            M.updateStealProgress(M.V3.progress)

            if M.V3.progress >= 1 then
                v3TriggerPrompt(prompt)
                M.V3.progress = 0
                M.V3.currentUid = nil
                M.V3.holding = false
                M.V3.holdPrompt = nil
                M.isStealing = false
                M.updateStealProgress(0)
                M.V3.cooldownUntil = tick() + math.max(stopT, 0.25)
            end
        else
            -- Out of range: release hold, decay progress over Stop Time (video-style drop)
            if M.V3.holding or M.V3.holdPrompt then
                v3ReleasePrompt(M.V3.holdPrompt)
                M.V3.holding = false
                M.V3.holdPrompt = nil
            end

            if M.V3.progress > 0 then
                local decay = dt / stopT
                M.V3.progress = math.max(0, M.V3.progress - decay)
                M.updateStealProgress(M.V3.progress)
                if M.V3.progress <= 0 then
                    M.V3.currentUid = nil
                    M.isStealing = false
                    M.updateStealProgress(0)
                else
                    M.isStealing = true
                end
            else
                M.isStealing = false
            end
        end
    end)
end

function M.stopV3Steal()
    M.V3.enabled = false
    if M.V3.holdPrompt then
        v3ReleasePrompt(M.V3.holdPrompt)
    end
    if M.V3.conn then
        pcall(function() M.V3.conn:Disconnect() end)
        M.V3.conn = nil
    end
    M.V3.progress = 0
    M.V3.currentUid = nil
    M.V3.holding = false
    M.V3.holdPrompt = nil
    M.V3.cooldownUntil = 0
    M.V3.lastInRange = 0
    M.V3.lastHoldPulse = 0
    M.isStealing = false
    M.updateStealProgress(0)
end

function M.startAutoSteal()
    if M.statusGui then M.statusGui.Enabled = true end
    local mode = M.stealMode
    if mode == "Semi" then
        M.startSemiSteal()
    else
        -- V2 (default)
        M.stealMode = "V2"
        M.startV2Steal()
    end
end

function M.stopAutoSteal()
    if M.statusGui then M.statusGui.Enabled = true end
    M.stopNormalSteal()
    M.stopSemiSteal()
    if M.stopV2Steal then M.stopV2Steal() end
    if M.stopV3Steal then M.stopV3Steal() end
    M.isStealing = false
    M.updateStealProgress(0)
end

function M.setStealRadius(radius)
    M.Steal.StealRadius = radius
    M.updateStatusRadius()
end

-- ============================================================
-- OTHER CORE FUNCTIONS (unchanged - abbreviate per spazio)
-- ============================================================
function M.findBat()
    local char=player.Character;if not char then return nil end
    for _,tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end
    local bp=player:FindFirstChild("Backpack");if bp then for _,tool in ipairs(bp:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end end
    return nil
end

function M.findMedusa()
    local c=player.Character;if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=player:FindFirstChild("Backpack");if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end

function M.useMedusaCounter()
    if M.medusaDebounce then return end;if M.MEDUSA_COOLDOWN>(tick()-M.medusaLastUsed) then return end
    local c=player.Character;if not c then return end;M.medusaDebounce=true
    local med=M.findMedusa();if not med then M.medusaDebounce=false;return end
    if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid");if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end);M.medusaLastUsed=tick();M.medusaDebounce=false
end

function M.onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if not part.Anchored then return end
        if M._isInstaResetting then return end
        -- Medusa Reset / insta-reset removed — only counter remains
        if M.medusaCounterEnabled and part.Transparency == 1 then
            pcall(function() M.useMedusaCounter() end)
        end
    end)
end

function M.setupMedusa(char)
    for _,c in pairs(M.Conns.anchor) do pcall(function() c:Disconnect() end) end;M.Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(M.Conns.anchor,M.onAnchorChanged(part)) end end
    table.insert(M.Conns.anchor,char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(M.Conns.anchor,M.onAnchorChanged(part)) end end))
end

function M.stopMedusaCounter() for _,c in pairs(M.Conns.anchor) do pcall(function() c:Disconnect() end) end;M.Conns.anchor={} end

function M.findBatForCounter()
    local c=player.Character;if not c then return nil end;local bp=player:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(M.BAT_COUNTER_SLAP_LIST) do local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name));if t then return t end end
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

function M.startBatCounter()
    if M.Conns.batCounter then return end
    M.Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not M.batCounterEnabled or M.batCounterDebounce then return end
        local char=player.Character;if not char then return end;local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            M.batCounterDebounce=true;task.spawn(function() local bat=M.findBatForCounter();if bat then M.swingBatForCounter(bat,char) end;task.wait(0.5);M.batCounterDebounce=false end)
        end
    end)
end

function M.stopBatCounter() if M.Conns.batCounter then M.Conns.batCounter:Disconnect();M.Conns.batCounter=nil end;M.batCounterDebounce=false end

-- ============================================================
-- NORMAL AIMBOT (Shadow logic)
-- ============================================================
M.aimbotSpeed = M.aimbotSpeed or 58
M.laggerAimbotSpeed = M.laggerAimbotSpeed or 40
M._aimbotSwingCooldown = false


M.aimbotSpeed = M.aimbotSpeed or 57
M.laggerAimbotSpeed = M.laggerAimbotSpeed or 40
M.aimbotHitRange = M.aimbotHitRange or 9.5
M.aimbotSwingCD = M.aimbotSwingCD or 0.12
M.aimbotRotationSpeed = M.aimbotRotationSpeed or 0.55
M.aimbotRotationEnabled = true
M.aimbotHeightOffset = M.aimbotHeightOffset or 1.6

function M.findBatForAimbot()
    local char = player.Character
    if not char then return nil end
    local bp = player:FindFirstChild("Backpack")
    -- Prefer exact names from slap list first
    if M.BAT_COUNTER_SLAP_LIST then
        for _, name in ipairs(M.BAT_COUNTER_SLAP_LIST) do
            local t = char:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
            if t and t:IsA("Tool") then return t end
        end
    end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local n = tool.Name:lower()
            if n:find("bat") or n:find("slap") then return tool end
        end
    end
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") then
                local n = tool.Name:lower()
                if n:find("bat") or n:find("slap") then return tool end
            end
        end
    end
    return nil
end

function M.getClosestTargetAimbot()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                end
            end
        end
    end
    return closest
end

-- Sticky target: hold same enemy ~1.25s
M.AIMBOT_STICKY_TIME = M.AIMBOT_STICKY_TIME or 1.25
M.AIMBOT_STICKY_MAX_DIST = M.AIMBOT_STICKY_MAX_DIST or 85
M._aimbotStickyUntil = 0
M._aimbotStickyTarget = nil

function M.getAutoBatTarget()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local now = tick()
    local function stillValid(tRoot)
        if not tRoot or not tRoot.Parent then return false end
        local hum = tRoot.Parent:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return false end
        if (tRoot.Position - root.Position).Magnitude > (M.AIMBOT_STICKY_MAX_DIST or 85) then return false end
        return true
    end
    local sticky = M._aimbotStickyTarget
    if sticky and now < (M._aimbotStickyUntil or 0) and stillValid(sticky) then
        M._aimbotTarget = sticky
        return sticky
    end
    if now - (M._aimbotLastScan or 0) <= 0.08 and M._aimbotTarget and stillValid(M._aimbotTarget) then
        return M._aimbotTarget
    end
    M._aimbotLastScan = now
    local closest = M.getClosestTargetAimbot and M.getClosestTargetAimbot() or nil
    M._aimbotTarget = closest
    M._aimbotStickyTarget = closest
    M._aimbotStickyUntil = now + (tonumber(M.AIMBOT_STICKY_TIME) or 1.25)
    return closest
end

function M.getNormalAimbotSpeed()
    -- Shadow/S2hub: Lagger modes use lagger aimbot speed, else normal aimbot speed
    if M.laggerModeEnabled or M.laggerCarryActive then
        return tonumber(M.laggerAimbotSpeed) or 40
    end
    return tonumber(M.aimbotSpeed) or 58
end

function M._aimbotSwingBat(char, bat)
    if not bat or not bat.Parent then return end
    if bat.Parent ~= char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum:EquipTool(bat) end) end
        return
    end
    pcall(function() bat:Activate() end)
end

function M.startBatAimbot()
    if not M.safeModeTryStart() then return end
    if M.aimbotConn then
        pcall(function() M.aimbotConn:Disconnect() end)
        M.aimbotConn = nil
    end
    pcall(function() RunService:UnbindFromRenderStep("ShadowAimbotRotCam") end)

    if M.autoLeftEnabled then
        M.autoLeftEnabled = false
        if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
        M.stopAutoLeft()
    end
    if M.autoRightEnabled then
        M.autoRightEnabled = false
        if M.autoRightSetVisual then M.autoRightSetVisual(false) end
        M.stopAutoRight()
    end

    M._autoTPWasEnabledForBat = false
    if M.autoTPEnabled then
        M._autoTPWasEnabledForBat = true
        M.stopAutoTP()
        if M.setAutoTPVisual then M.setAutoTPVisual(false) end
    end
    pcall(function()
        if M.stopAutoTPForAction then M.stopAutoTPForAction() end
    end)

    M.autoBatEnabled = true
    M.autoSwingEnabled = true
    M.autoBatEquippedThisRun = false
    pcall(function() M.syncCombatAntiDie() end)
    M._aimbotTarget = nil
    M._aimbotLastScan = 0

    -- SCYTHE VS aimbot: Heartbeat + prediction + angular velocity + sticky
    M.aimbotConn = RunService.Heartbeat:Connect(function()
        if not M.autoBatEnabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        if not char:FindFirstChildOfClass("Tool") then
            local bat = M.findBatForAimbot and M.findBatForAimbot() or nil
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end

        local target = (M.getAutoBatTarget and M.getAutoBatTarget()) or (M.getClosestTargetAimbot and M.getClosestTargetAimbot())
        if not target then
            hum.AutoRotate = true
            root.AssemblyAngularVelocity = Vector3.zero
            return
        end
        M._aimbotTarget = target
        hum.AutoRotate = false

        local targetVel = target.AssemblyLinearVelocity or Vector3.zero
        local myPos = root.Position
        local targetPos = target.Position
        -- Prediction always on
        local predictPos = targetPos + targetVel * 0.14 + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0.01 then flatDir = flatDir.Unit else flatDir = Vector3.new(0, 0, 1) end

        local chaseSpeed = M.getNormalAimbotSpeed and M.getNormalAimbotSpeed() or (tonumber(M.aimbotSpeed) or 58)
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
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

        if M.autoSwingEnabled ~= false then
            local bat = char:FindFirstChild("Bat") or (M.findBatForAimbot and M.findBatForAimbot())
            if bat and bat:IsA("Tool") then pcall(function() bat:Activate() end) end
        end
    end)

    if M.autoBatSetVisual then M.autoBatSetVisual(true) end
    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(true) end
end

function M.stopBatAimbot()
    if M.aimbotConn then
        pcall(function() M.aimbotConn:Disconnect() end)
        M.aimbotConn = nil
    end
    pcall(function() RunService:UnbindFromRenderStep("ShadowAimbotRotCam") end)
    do
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if root then
            pcall(function()
                root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.3
                root.AssemblyAngularVelocity = Vector3.zero
            end)
        end
        if hum then pcall(function() hum.AutoRotate = true end) end
    end
    M._aimbotStickyTarget = nil
    M._aimbotLookPos = nil
    M._aimbotTarget = nil
    M._aimbotSwingCooldown = false
    M._aimbotLastSwing = 0
    M._aimbotTargetLockUntil = 0
    M.autoBatEnabled = false
    M.autoBatEquippedThisRun = false
    pcall(function() M.syncCombatAntiDie() end)

    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
    local hum2 = char and char:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate = true end

    if M._autoTPWasEnabledForBat then
        M._autoTPWasEnabledForBat = false
        M.autoTPEnabled = true
        if M.setAutoTPVisual then M.setAutoTPVisual(true) end
        M.startAutoTP()
    end

    if M.autoBatSetVisual then M.autoBatSetVisual(false) end
    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(false) end
end

function M.queueAutoBatStart()
    if not M.safeModeTryStart() then return end
    if M.antiKickEnabled and M.brainrotDetected then return end
    if M.autoLeftEnabled then M.autoLeftEnabled=false; if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end; M.stopAutoLeft() end
    if M.autoRightEnabled then M.autoRightEnabled=false; if M.autoRightSetVisual then M.autoRightSetVisual(false) end; M.stopAutoRight() end
    M.startBatAimbot()
end

function M.swingCurrentBatAimbot(char)
    if not M.autoSwingEnabled then return end
    local bat = M.findBatForAimbot()
    if bat then
        M._aimbotSwingBat(char or player.Character, bat)
    end
end

-- ============================================================
-- BAT TP (Green Duels V2 style – hard CFrame TP + camera + dual swing loops)
-- ============================================================
M._bypassTarget = nil
M._bypassHRP = nil
M._bypassHum = nil
M.tpBatRange = M.tpBatRange or 1e9 -- unlimited: always nearest enemy
M.tpBatClose = M.tpBatClose or 5 -- Green Duels threshold
M.tpBatOffset = M.tpBatOffset or 0
M.tpBatHitMode = M.tpBatHitMode or "Sure" -- "Sure" | "Normal"
M.tpBatSureHitEnabled = true
M._tpBatLastSwing = 0
M._bypassSwingCooldown = false
M._sureHitCD = false
M._normalHitCD = false
M._bypassRenderConn = nil -- Green-style RenderStepped twin

-- Find / equip any bat tool (exact or name contains "bat")
function M._bypassFindBat()
    local char = player.Character
    if not char then return nil end
    local function isBat(t)
        if not t or not t:IsA("Tool") then return false end
        local n = string.lower(t.Name)
        return n == "bat" or n:find("bat", 1, true) ~= nil
    end
    for _, t in ipairs(char:GetChildren()) do
        if isBat(t) then return t end
    end
    local bp = player:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if isBat(t) then
                pcall(function() t.Parent = char end)
                return t
            end
        end
    end
    return nil
end

-- Sure Hit — auto-swing multi-fire
function M._bypassTryHitBat()
    if M.tpBatAutoSwing == false and M.autoSwingEnabled == false then return end
    if M._sureHitCD then return end
    M._sureHitCD = true
    pcall(function()
        local bat = M._bypassFindBat()
        if bat then
            for _ = 1, 3 do
                pcall(function() bat:Activate() end)
                local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
                if ev then pcall(function() ev:FireServer() end) end
            end
            local rf = bat:FindFirstChildWhichIsA("RemoteFunction")
            if rf then pcall(function() rf:InvokeServer() end) end
        end
    end)
    task.delay(0.045, function() M._sureHitCD = false end)
end

-- Normal Hit — auto-swing multi-fire
function M._bypassTryHitBatNormal()
    if M.tpBatAutoSwing == false and M.autoSwingEnabled == false then return end
    if M._normalHitCD then return end
    M._normalHitCD = true
    pcall(function()
        local bat = M._bypassFindBat()
        if bat then
            for _ = 1, 3 do
                pcall(function() bat:Activate() end)
                local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
                if ev then pcall(function() ev:FireServer() end) end
            end
            local rf = bat:FindFirstChildWhichIsA("RemoteFunction")
            if rf then pcall(function() rf:InvokeServer() end) end
        end
    end)
    task.delay(0.045, function() M._normalHitCD = false end)
end

-- Prefer enemy in camera view / where you aim (shiftlock look), then nearest
function M._bypassGetClosest()
    local root = M._bypassHRP or (player.Character and player.Character:FindFirstChild("HumanoidRootPart"))
    if not root then return nil, math.huge end
    local cam = workspace.CurrentCamera
    local closest, bestScore = nil, math.huge
    local bestDist = math.huge
    local camPos = cam and cam.CFrame.Position or root.Position
    local look = cam and cam.CFrame.LookVector or root.CFrame.LookVector
    local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
    local cx, cy = vp.X * 0.5, vp.Y * 0.5
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local tHum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and tHum and tHum.Health > 0 then
                local dist = (root.Position - tRoot.Position).Magnitude
                local score = dist
                if cam then
                    local screen, onScreen = cam:WorldToViewportPoint(tRoot.Position)
                    if onScreen and screen.Z > 0 then
                        local sd = (Vector2.new(screen.X, screen.Y) - Vector2.new(cx, cy)).Magnitude
                        -- Prefer who you are looking at (center of screen)
                        score = sd * 0.85 + dist * 0.25
                    else
                        local toT = (tRoot.Position - camPos)
                        if toT.Magnitude > 0.1 then
                            local dot = look:Dot(toT.Unit)
                            if dot > 0.15 then
                                score = dist * (1.6 - math.clamp(dot, 0, 1))
                            else
                                score = dist * 3.5 -- behind camera = low priority
                            end
                        end
                    end
                end
                if score < bestScore then
                    bestScore = score
                    bestDist = dist
                    closest = plr
                end
            end
        end
    end
    return closest, bestDist
end

-- Flat look from camera (shiftlock-aware) for placement
function M._bypassCamLookFlat()
    local cam = workspace.CurrentCamera
    local root = M._bypassHRP
    local look
    if cam then
        look = cam.CFrame.LookVector
    elseif root then
        look = root.CFrame.LookVector
    else
        look = Vector3.new(0, 0, -1)
    end
    look = Vector3.new(look.X, 0, look.Z)
    if look.Magnitude < 0.05 then
        look = Vector3.new(0, 0, -1)
    else
        look = look.Unit
    end
    return look
end

-- Smooth body face + place near target along camera direction (does NOT lock camera)
function M._bypassSmoothToTarget(tr)
    local hrp = M._bypassHRP
    if not hrp or not tr then return end
    local look = M._bypassCamLookFlat()
    local tVel = tr.AssemblyLinearVelocity or Vector3.zero
    -- light prediction
    local pred = tr.Position + Vector3.new(tVel.X, 0, tVel.Z) * 0.08
    -- stand slightly in front of target relative to where YOU are looking
    local standDist = 2.0
    local standPos = pred - look * standDist + Vector3.new(0, 0.55, 0)
    local faceAt = Vector3.new(pred.X, standPos.Y, pred.Z)
    local goal = CFrame.lookAt(standPos, faceAt)
    -- smooth lerp (more success, less jitter)
    local alpha = 0.62
    hrp.CFrame = hrp.CFrame:Lerp(goal, alpha)
    -- kill sideways drift
    local v = hrp.AssemblyLinearVelocity
    hrp.AssemblyLinearVelocity = Vector3.new(v.X * 0.35, v.Y, v.Z * 0.35)
end


-- ============================================================
-- ANTI-BYPASS GODMODE (immune while bypass aimbot is on)
-- ============================================================
function M._bypassClearGodConns()
    for _, key in ipairs({"_bypassGodConn", "_bypassGodHealthConn", "_bypassGodDiedConn", "_bypassGodCharConn", "_bypassGodStateConn"}) do
        local c = M[key]
        if c then pcall(function() c:Disconnect() end); M[key] = nil end
    end
end

function M._bypassProtectCharacter(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    pcall(function()
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum.BreakJointsOnDeath = false
        hum.RequiresNeck = false
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        hum.PlatformStand = false
        hum.Sit = false
    end)
    if M._bypassGodHealthConn then pcall(function() M._bypassGodHealthConn:Disconnect() end) end
    M._bypassGodHealthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not M.bypassAimbotEnabled then return end
        pcall(function()
            if hum.Health < (hum.MaxHealth or 100) or hum.Health <= 0 then
                hum.Health = hum.MaxHealth or 100
                hum.PlatformStand = false
                hum.Sit = false
            end
        end)
    end)
    if M._bypassGodDiedConn then pcall(function() M._bypassGodDiedConn:Disconnect() end) end
    M._bypassGodDiedConn = hum.Died:Connect(function()
        if not M.bypassAimbotEnabled then return end
        -- NO insta reset — only try to stay alive client-side
        pcall(function()
            hum.BreakJointsOnDeath = false
            hum.Health = hum.MaxHealth or 100
            hum.PlatformStand = false
            hum.Sit = false
            hum:ChangeState(Enum.HumanoidStateType.Running)
            task.defer(function()
                if not M.bypassAimbotEnabled then return end
                pcall(function()
                    hum.Health = hum.MaxHealth or 100
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end)
        end)
    end)
    pcall(function()
        if M._bypassGodStateConn then pcall(function() M._bypassGodStateConn:Disconnect() end) end
        M._bypassGodStateConn = hum.StateChanged:Connect(function(_, new)
            if not M.bypassAimbotEnabled then return end
            if new == Enum.HumanoidStateType.Dead
                or new == Enum.HumanoidStateType.Ragdoll
                or new == Enum.HumanoidStateType.FallingDown
                or new == Enum.HumanoidStateType.Physics then
                pcall(function()
                    hum.Health = hum.MaxHealth or 100
                    hum.PlatformStand = false
                    hum.Sit = false
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end
        end)
    end)
end

-- ============================================================
-- ANTI DIE
-- ============================================================
function M._adClearConns()
    for _, key in ipairs({"_antiDieConn", "antiDieConn", "_antiDieCharConn", "_antiDieHealthConn", "_antiDieDiedConn", "_antiDieRenderConn", "_antiDieStateConn"}) do
        local c = M[key]
        if c then pcall(function() c:Disconnect() end); M[key] = nil end
    end
end

function M._adProtectCharacter(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    pcall(function()
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum.BreakJointsOnDeath = false
        hum.RequiresNeck = false
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end)
    if M._antiDieHealthConn then pcall(function() M._antiDieHealthConn:Disconnect() end) end
    M._antiDieHealthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not M.antiDieEnabled then return end
        pcall(function()
            if hum.Health < hum.MaxHealth or hum.Health <= 0 then
                hum.Health = math.huge
                hum.MaxHealth = math.huge
                hum.PlatformStand = false
                hum.Sit = false
            end
        end)
    end)
    if M._antiDieDiedConn then pcall(function() M._antiDieDiedConn:Disconnect() end) end
    M._antiDieDiedConn = hum.Died:Connect(function()
        if not M.antiDieEnabled then return end
        pcall(function()
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            hum.BreakJointsOnDeath = false
            hum.MaxHealth = math.huge
            hum.Health = math.huge
            hum.PlatformStand = false
            hum.Sit = false
            hum:ChangeState(Enum.HumanoidStateType.Running)
            task.defer(function()
                if not M.antiDieEnabled then return end
                pcall(function()
                    hum.MaxHealth = math.huge
                    hum.Health = math.huge
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end)
        end)
    end)
    if M._antiDieStateConn then pcall(function() M._antiDieStateConn:Disconnect() end) end
    M._antiDieStateConn = hum.StateChanged:Connect(function(_, new)
        if not M.antiDieEnabled then return end
        if new == Enum.HumanoidStateType.Dead then
            pcall(function()
                hum.Health = math.huge
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end
    end)
end

function M.startAntiDie()
    M._adClearConns()
    M.antiDieEnabled = true
    local function forceAlive(char)
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum then return end
        pcall(function()
            hum.BreakJointsOnDeath = false
            hum.RequiresNeck = false
            if hum.MaxHealth < 100 then hum.MaxHealth = 100 end
            if hum.Health < hum.MaxHealth or hum.Health <= 0 then
                hum.Health = hum.MaxHealth
            end
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Dead
                or st == Enum.HumanoidStateType.FallingDown
                or st == Enum.HumanoidStateType.Ragdoll
                or st == Enum.HumanoidStateType.Physics
                or hum.Health <= 0 then
                hum.Health = hum.MaxHealth
                hum.PlatformStand = false
                hum.Sit = false
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            end
            -- never call any reset remote from anti-die
            if hrp and not M.dropActive and not M.bypassAimbotEnabled then
                local v = hrp.AssemblyLinearVelocity
                local maxMove = math.max(tonumber(M.NS) or 60, tonumber(M.CS) or 30, tonumber(M.LAGGER_CARRY_SPEED) or 25, 80) * 2.5
                if v ~= v then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                elseif v.Magnitude > math.max(maxMove, 500) then
                    hrp.AssemblyLinearVelocity = v.Unit * math.min(v.Magnitude, maxMove)
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end)
    end
    if player.Character then
        M._adProtectCharacter(player.Character)
        forceAlive(player.Character)
    end
    M._antiDieCharConn = player.CharacterAdded:Connect(function(c)
        if not M.antiDieEnabled then return end
        task.wait(0.05)
        M._adProtectCharacter(c)
        forceAlive(c)
        -- Explicitly: do NOT call cursedInstaReset on new character / death
        local hum = c:FindFirstChildOfClass("Humanoid") or c:WaitForChild("Humanoid", 3)
        if hum then
            pcall(function()
                hum.BreakJointsOnDeath = false
                hum.Died:Connect(function()
                    -- stay alive attempt only — no reset
                    pcall(function()
                        hum.Health = hum.MaxHealth or 100
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                    end)
                end)
            end)
        end
    end)
    M.antiDieConn = RunService.Heartbeat:Connect(function()
        if not M.antiDieEnabled then return end
        forceAlive(player.Character)
    end)
    if M._antiDieRenderConn then pcall(function() M._antiDieRenderConn:Disconnect() end) end
    M._antiDieRenderConn = RunService.RenderStepped:Connect(function()
        if not M.antiDieEnabled then return end
        forceAlive(player.Character)
    end)
end

function M.stopAntiDie()
    M.antiDieEnabled = false
    M._adClearConns()
    if M._antiDieRenderConn then
        pcall(function() M._antiDieRenderConn:Disconnect() end)
        M._antiDieRenderConn = nil
    end
end

-- ============================================================
-- ANTI FLING / GLITCH DIE (global — not only aimbot)
-- Caps insane physics that often cause random death
-- ============================================================
M.antiFlingEnabled = true -- always default ON (stops fling deaths)
M.antiFlingMaxSpeed = M.antiFlingMaxSpeed or 120
M.antiFlingMaxY = M.antiFlingMaxY or 70
M.antiFlingMaxAng = M.antiFlingMaxAng or 25
M._antiFlingConn = nil

function M.startAntiFling()
    if M._antiFlingConn then
        pcall(function() M._antiFlingConn:Disconnect() end)
        M._antiFlingConn = nil
    end
    M.antiFlingEnabled = true
    M._antiFlingConn = RunService.Heartbeat:Connect(function()
        if not M.antiFlingEnabled then return end
        if M.bypassAimbotEnabled or M.dropActive then return end
        if M.dropActive then return end -- let drop fling work
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root then return end

        local cfgMax = math.max(tonumber(M.NS) or 60, tonumber(M.CS) or 30, tonumber(M.LAGGER_CARRY_SPEED) or 25)
        local maxSpd = math.max(tonumber(M.antiFlingMaxSpeed) or 140, cfgMax * 2.2, 200)
        local maxY = math.max(tonumber(M.antiFlingMaxY) or 90, 120)
        local maxAng = tonumber(M.antiFlingMaxAng) or 40

        pcall(function()
            local v = root.AssemblyLinearVelocity
            local bad = false
            if v.Magnitude > maxSpd or math.abs(v.Y) > maxY then
                root.AssemblyLinearVelocity = Vector3.new(
                    math.clamp(v.X, -maxSpd, maxSpd),
                    math.clamp(v.Y, -maxY, maxY),
                    math.clamp(v.Z, -maxSpd, maxSpd)
                )
                bad = true
            end
            local ang = root.AssemblyAngularVelocity
            if ang.Magnitude > maxAng then
                root.AssemblyAngularVelocity = Vector3.zero
                bad = true
            end
            -- Nan / inf guards (rare but lethal)
            if v ~= v or ang ~= ang then
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                bad = true
            end
            if hum then
                if bad then
                    hum.PlatformStand = false
                    hum.Sit = false
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                end
                local st = hum:GetState()
                if st == Enum.HumanoidStateType.Flying
                    or st == Enum.HumanoidStateType.Ragdoll
                    or st == Enum.HumanoidStateType.FallingDown
                    or st == Enum.HumanoidStateType.Physics then
                    if bad or v.Magnitude > maxSpd * 0.7 then
                        pcall(function()
                            hum:ChangeState(Enum.HumanoidStateType.Running)
                            hum.PlatformStand = false
                            hum.Sit = false
                        end)
                    end
                end
            end
        end)
    end)
end

function M.stopAntiFling()
    M.antiFlingEnabled = false
    if M._antiFlingConn then
        pcall(function() M._antiFlingConn:Disconnect() end)
        M._antiFlingConn = nil
    end
end



-- Keep Anti Die active while TP Bat (bypass) OR Auto Bat aimbot is on
function M.syncCombatAntiDie()
    local need = (M.bypassAimbotEnabled == true) or (M.autoBatEnabled == true)
    if need then
        M.antiDieEnabled = true
        if not M.antiDieConn then
            pcall(function() M.startAntiDie() end)
        end
        -- refresh protection on current char
        pcall(function()
            if player.Character then M._adProtectCharacter(player.Character) end
        end)
    else
        -- only stop when neither combat aim mode is active
        pcall(function() M.stopAntiDie() end)
    end
end

function M.enableBypassGodmode()
    M.antiDieEnabled = true
    pcall(function() if not M.antiDieConn then M.startAntiDie() end end)
    M._bypassClearGodConns()
    local char = player.Character
    if char then M._bypassProtectCharacter(char) end
    M._bypassGodCharConn = player.CharacterAdded:Connect(function(c)
        if not M.bypassAimbotEnabled then return end
        task.wait(0.05)
        M._bypassProtectCharacter(c)
    end)
    -- ANTI-DIE while TP lock ON: every Heartbeat (no throttle) so you cannot die
    M._bypassGodConn = RunService.Heartbeat:Connect(function()
        if not M.bypassAimbotEnabled then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum then return end
        pcall(function()
            hum.BreakJointsOnDeath = false
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            hum.MaxHealth = math.huge
            if hum.Health < hum.MaxHealth or hum.Health <= 0 then
                hum.Health = math.huge
            end
            hum.PlatformStand = false
            hum.Sit = false
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Dead
                or st == Enum.HumanoidStateType.Ragdoll
                or st == Enum.HumanoidStateType.FallingDown
                or st == Enum.HumanoidStateType.Physics then
                hum.Health = hum.MaxHealth
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            -- void / fling safety while locked
            if root then
                local p = root.Position
                if p.Y < -40 or p ~= p or math.abs(p.X) > 1e5 or math.abs(p.Z) > 1e5 then
                    root.CFrame = CFrame.new(p.X, 30, p.Z)
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                    hum.Health = hum.MaxHealth
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end
        end)
    end)
end

function M.disableBypassGodmode()
    M._bypassClearGodConns()
end

function M.startBypassAimbot()
    if not M.safeModeTryStart() then return end
    if M.bypassAimbotConn then
        pcall(function() M.bypassAimbotConn:Disconnect() end)
        M.bypassAimbotConn = nil
    end
    if M._bypassRenderConn then
        pcall(function() M._bypassRenderConn:Disconnect() end)
        M._bypassRenderConn = nil
    end

    -- Mutual exclusive: TP Bat / Bypass OFFS ping lagger
    pcall(function()
        if M.pingActive and M.setPingActive then M.setPingActive(false, true) end
        M.pingActive = false
        M.pingLoopRunning = false
    end)
    -- Force auto-swing ON for TP Bat
    M.autoSwingEnabled = true
    M.tpBatAutoSwing = true

    -- Stop left/right & pause auto TP
    if M.autoLeftEnabled then
        M.autoLeftEnabled = false
        if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
        M.stopAutoLeft()
    end
    if M.autoRightEnabled then
        M.autoRightEnabled = false
        if M.autoRightSetVisual then M.autoRightSetVisual(false) end
        M.stopAutoRight()
    end

    M._autoTPWasEnabledForBypass = false
    if M.autoTPEnabled then
        M._autoTPWasEnabledForBypass = true
        M.stopAutoTP()
        if M.setAutoTPVisual then M.setAutoTPVisual(false) end
    end

    M.bypassAimbotEnabled = true
    M.enableBypassGodmode()
    -- force global anti-die ON while TP lock / aimbot is active
    M.antiDieEnabled = true
    pcall(function()
        if not M.antiDieConn then M.startAntiDie() end
    end)
    pcall(function() M.syncCombatAntiDie() end)
    M._bypassTarget = nil
    M._bypassSwingCooldown = false
    M._tpBatLastSwing = 0
    M._sureHitCD = false
    M._normalHitCD = false

    local char0 = player.Character
    if char0 then
        M._bypassHRP = char0:FindFirstChild("HumanoidRootPart")
        M._bypassHum = char0:FindFirstChildOfClass("Humanoid")
        if M._bypassHum then
            M.bypassPrevAutoRotate = M._bypassHum.AutoRotate
            M._bypassHum.AutoRotate = false
        end
    end

    local hitMode = (M.tpBatHitMode == "Normal") and "Normal" or "Sure"

    if hitMode == "Sure" then
        -- SURE HIT — camera/shiftlock aware (does NOT hard-lock camera)
        M.bypassAimbotConn = RunService.Heartbeat:Connect(function()
            if not M.bypassAimbotEnabled then return end
            local char = player.Character
            if not char then return end
            M._bypassHum = char:FindFirstChildOfClass("Humanoid")
            M._bypassHRP = char:FindFirstChild("HumanoidRootPart")
            if not M._bypassHum or not M._bypassHRP then return end

            local target = select(1, M._bypassGetClosest())
            if not (target and target.Character) then return end
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if not tr then return end
            M._bypassTarget = tr

            if sethiddenproperty then
                pcall(function()
                    sethiddenproperty(M._bypassHRP, "PhysicsRepRootPart", tr)
                end)
            end

            -- Smooth place relative to YOUR look direction (shiftlock rotate works)
            M._bypassSmoothToTarget(tr)
            M._bypassTryHitBat()
        end)
        -- RenderStepped twin for smoother body follow + hit rate
        M._bypassRenderConn = RunService.RenderStepped:Connect(function()
            if not M.bypassAimbotEnabled then return end
            if not M._bypassHRP then return end
            local target = select(1, M._bypassGetClosest())
            if not (target and target.Character) then return end
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if not tr then return end
            M._bypassSmoothToTarget(tr)
            M._bypassTryHitBat()
        end)
    else
        -- NORMAL HIT — same camera-aware placement
        M.bypassAimbotConn = RunService.Heartbeat:Connect(function()
            if not M.bypassAimbotEnabled then return end
            local char = player.Character
            if not char then return end
            M._bypassHum = char:FindFirstChildOfClass("Humanoid")
            M._bypassHRP = char:FindFirstChild("HumanoidRootPart")
            if not M._bypassHum or not M._bypassHRP then return end

            local target = select(1, M._bypassGetClosest())
            if not (target and target.Character) then return end
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if not tr then return end
            M._bypassTarget = tr

            if sethiddenproperty then
                pcall(function()
                    sethiddenproperty(M._bypassHRP, "PhysicsRepRootPart", tr)
                end)
            end

            M._bypassSmoothToTarget(tr)
            M._bypassTryHitBatNormal()
        end)

        M._bypassRenderConn = RunService.RenderStepped:Connect(function()
            if not M.bypassAimbotEnabled then return end
            if not M._bypassHRP then return end
            local target = select(1, M._bypassGetClosest())
            if not (target and target.Character) then return end
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if not tr then return end
            M._bypassSmoothToTarget(tr)
            M._bypassTryHitBatNormal()
        end)
    end

    if M.setBypassVisual then M.setBypassVisual(true) end
    if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(true) end
end

function M.stopBypassAimbot()
    if M.bypassAimbotConn then
        pcall(function() M.bypassAimbotConn:Disconnect() end)
        M.bypassAimbotConn = nil
    end
    if M._bypassRenderConn then
        pcall(function() M._bypassRenderConn:Disconnect() end)
        M._bypassRenderConn = nil
    end
    pcall(function() RunService:UnbindFromRenderStep("ShadowBypassRotCam") end)
    M._bypassLookPos = nil

    M.bypassAimbotEnabled = false
    M.disableBypassGodmode()
    pcall(function() M.syncCombatAntiDie() end)
    M._bypassTarget = nil
    M._bypassSwingCooldown = false
    M.bypassHitCD = false
    M._sureHitCD = false
    M._normalHitCD = false
    M._bypassHRP = nil
    M._bypassHum = nil

    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end

    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (M.bypassPrevAutoRotate == nil) and true or M.bypassPrevAutoRotate
    end

    if M._autoTPWasEnabledForBypass then
        M._autoTPWasEnabledForBypass = false
        M.autoTPEnabled = true
        if M.setAutoTPVisual then M.setAutoTPVisual(true) end
        M.startAutoTP()
    end

    if M.setBypassVisual then M.setBypassVisual(false) end
    if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(false) end
end

function M.toggleBypassAimbot()
    M.bypassAimbotEnabled = not M.bypassAimbotEnabled
    if M.bypassAimbotEnabled then
        M.startBypassAimbot()
    else
        M.stopBypassAimbot()
    end
    if M.setBypassVisual then
        M.setBypassVisual(M.bypassAimbotEnabled)
    end
    if M.mobBtnRefs.bypass then
        M.mobBtnRefs.bypass(M.bypassAimbotEnabled)
    end
    saveCherryConfig()
    return M.bypassAimbotEnabled
end

-- ============================================================
-- REST OF CORE FUNCTIONS
-- ============================================================
function M.doAutoTPDown(force)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum2 = char:FindFirstChildOfClass("Humanoid")
    if not hum2 then return end
    -- auto-TP loop only checks height/air; manual TP Down (force) always works — no cooldown
    if not force then
        if hum2.FloorMaterial ~= Enum.Material.Air then return end
        if not (hrp.Position.Y >= (tonumber(M.autoTPHeight) or 20)) then return end
    end
    local yaw = select(2, hrp.CFrame:ToEulerAnglesYXZ())
    hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z) * CFrame.Angles(0, yaw, 0)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    pcall(function() hrp.Velocity = Vector3.zero end)
    pcall(function() hrp.RotVelocity = Vector3.zero end)
end

function M.startAutoTP()
    if M.autoTPConn then task.cancel(M.autoTPConn);M.autoTPConn=nil end
    M.autoTPConn=task.spawn(function() while M.autoTPEnabled do task.wait(0.1);pcall(function() M.doAutoTPDown(false) end) end end)
end

function M.stopAutoTP() M.autoTPEnabled=false;if M.autoTPConn then task.cancel(M.autoTPConn);M.autoTPConn=nil end end

function M.runTPFloor()
    -- instant TP down, no cooldown / no debounce
    pcall(function() M.doAutoTPDown(true) end)
end

function M.enableStretchRez()
    M.stretchRezEnabled = true
    if M.stretchRezConn then pcall(function() M.stretchRezConn:Disconnect() end); M.stretchRezConn = nil end
    pcall(function() RunService:UnbindFromRenderStep("Movee_Stretch") end)
    -- Wide View: stretch aspect + FOV boost (Pulse-style)
    pcall(function()
        RunService:BindToRenderStep("Movee_Stretch", Enum.RenderPriority.Last.Value - 1, function()
            local cam = workspace.CurrentCamera
            if not cam then return end
            cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.8, 0, 0, 0, 1)
            if not M._fovLockedByUser then
                cam.FieldOfView = tonumber(M.wideViewFOV) or 120
            end
        end)
    end)
end

function M.disableStretchRez()
    M.stretchRezEnabled = false
    if M.stretchRezConn then pcall(function() M.stretchRezConn:Disconnect() end); M.stretchRezConn = nil end
    pcall(function() RunService:UnbindFromRenderStep("Movee_Stretch") end)
end

M.wideViewFOV = 120

--------------------------------------------------------------------------------
-- ANTI SUMMER BASE (ONLY remove blocking Anchor parts — never wipe bases)
--------------------------------------------------------------------------------
function M.isSummerBaseName(name)
    if not name then return false end
    local n = tostring(name):lower()
    -- strict: only explicit summer base names (not beach/palm/prop — those kill enemy bases)
    return n == "summerbase"
        or n == "summer_base"
        or n:find("summerbase", 1, true) ~= nil
        or n:find("summer_base", 1, true) ~= nil
end

function M.isAnchorName(name)
    if not name then return false end
    local n = tostring(name):lower()
    return n == "anchor" or n == "anchors"
end

function M.stripBlockingAnchor(obj)
    if not obj or not obj.Parent then return end
    local key = tostring(obj:GetFullName())
    if M._antiSummerCleaned[key] then return end
    M._antiSummerCleaned[key] = true
    pcall(function()
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            obj.CanCollide = false
            obj.CanQuery = false
            obj.CanTouch = false
            obj.Transparency = 1
        end
        obj:Destroy()
    end)
end

function M.cleanSummerBaseAnchors()
    if not M.antiSummerBaseEnabled then return end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end

    -- Only scan Plots (not whole workspace — was causing lag + wiping bases)
    for _, plot in ipairs(plots:GetChildren()) do
        local isSummer = M.isSummerBaseName(plot.Name)
        if not isSummer then
            for _, d in ipairs(plot:GetDescendants()) do
                if M.isSummerBaseName(d.Name) then
                    isSummer = true
                    break
                end
            end
        end
        if not isSummer then continue end
        -- ONLY strip objects literally named Anchor / Anchors
        for _, d in ipairs(plot:GetDescendants()) do
            if M.isAnchorName(d.Name) then
                M.stripBlockingAnchor(d)
            end
        end
    end
end


-- ============================================================
-- HARD HIT (range ring like VOID.CC)
-- ============================================================
M._hardHitRing = nil
M._hardHitConn = nil

function M.hideHardHitRing()
    if M._hardHitRing then
        pcall(function() M._hardHitRing:Destroy() end)
        M._hardHitRing = nil
    end
end

function M.showHardHitRing()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if M._hardHitRing and M._hardHitRing.Parent then return end
    local cyl = Instance.new("CylinderHandleAdornment")
    cyl.Name = "ShadowHardHitRing"
    cyl.Adornee = hrp
    cyl.Color3 = Color3.fromRGB(0, 0, 0)
    cyl.AlwaysOnTop = true
    cyl.ZIndex = 5
    cyl.Transparency = 0.1
    local r = tonumber(M.hardHitRadius) or 10
    cyl.Radius = r
    cyl.InnerRadius = math.max(0.1, r - 0.35)
    cyl.Height = 0.15
    cyl.CFrame = CFrame.new(0, -3, 0)
    cyl.Parent = hrp
    M._hardHitRing = cyl
end

function M.startHardHit()
    M.hardHitEnabled = true
    if M._hardHitConn then return end
    M._hardHitConn = RunService.Heartbeat:Connect(function()
        if not M.hardHitEnabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        if not M._hardHitRing or not M._hardHitRing.Parent then
            M.showHardHitRing()
        end
        if M._hardHitRing then
            local r = tonumber(M.hardHitRadius) or 10
            M._hardHitRing.Radius = r
            M._hardHitRing.InnerRadius = math.max(0.1, r - 0.35)
            if M._hardHitRing.Adornee ~= root then
                M._hardHitRing.Adornee = root
                M._hardHitRing.Parent = root
            end
        end
    end)
    M.showHardHitRing()
end

function M.stopHardHit()
    M.hardHitEnabled = false
    if M._hardHitConn then
        pcall(function() M._hardHitConn:Disconnect() end)
        M._hardHitConn = nil
    end
    M.hideHardHitRing()
end

function M.enableAntiSummerBase()
    M.antiSummerBaseEnabled = true
    M._antiSummerCleaned = {}
    M.cleanSummerBaseAnchors()
    if M.antiSummerBaseConn then
        pcall(function() M.antiSummerBaseConn:Disconnect() end)
        M.antiSummerBaseConn = nil
    end
    M.antiSummerBaseConn = workspace.DescendantAdded:Connect(function(obj)
        if not M.antiSummerBaseEnabled then return end
        if not M.isAnchorName(obj.Name) then return end
        task.defer(function()
            if not M.antiSummerBaseEnabled or not obj.Parent then return end
            -- only if under Plots and near a summer-named container
            local p = obj
            local underPlots, nearSummer = false, false
            while p and p ~= workspace do
                if p.Name == "Plots" or (p.Parent and p.Parent.Name == "Plots") then underPlots = true end
                if M.isSummerBaseName(p.Name) then nearSummer = true end
                p = p.Parent
            end
            if underPlots and nearSummer then
                M.stripBlockingAnchor(obj)
            end
        end)
    end)
    task.spawn(function()
        while M.antiSummerBaseEnabled do
            M.cleanSummerBaseAnchors()
            task.wait(5) -- slower scan = less lag
        end
    end)
end

function M.disableAntiSummerBase()
    M.antiSummerBaseEnabled = false
    if M.antiSummerBaseConn then
        pcall(function() M.antiSummerBaseConn:Disconnect() end)
        M.antiSummerBaseConn = nil
    end
end

function M._isUnderPlots(obj)
    local p = obj
    while p and p ~= workspace do
        if p.Name == "Plots" then return true end
        p = p.Parent
    end
    return false
end

function M.applyAntiLagDerender(obj)
    if not obj then return end
    -- NEVER touch enemy/player bases (Plots) — was making them transparent
    if M._isUnderPlots(obj) then return end
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then
            -- only strip accessories on characters, not map models
            local char = obj:FindFirstAncestorOfClass("Model")
            if char and Players:GetPlayerFromCharacter(char) then
                obj:Destroy()
            end
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
            or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("BasePart") or obj:IsA("MeshPart") then
            -- light optim only — do NOT force Transparency / wipe textures
            obj.CastShadow = false
            if obj.Reflectance and obj.Reflectance > 0 then
                obj.Reflectance = 0
            end
        end
        -- Decals/Textures on map intentionally left alone so bases stay visible
    end)
end

function M.enableAntiLag()
    M.removeAccessoriesEnabled = true
    M.antiLagEnabled = true
    M.defLightBrightness = M.defLightBrightness or Lighting.Brightness
    M.defLightClock = M.defLightClock or Lighting.ClockTime
    M.defLightAmbient = M.defLightAmbient or Lighting.OutdoorAmbient
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    for _, e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect")
                or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                e.Enabled = false
            end
        end)
    end
    -- Only process characters + effects, skip Plots entirely
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character then
            for _, obj in ipairs(plr.Character:GetDescendants()) do
                M.applyAntiLagDerender(obj)
            end
        end
    end
    if M.antiLagDescConn then M.antiLagDescConn:Disconnect() end
    M.antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if not M.antiLagEnabled then return end
        if M._isUnderPlots(obj) then return end
        M.applyAntiLagDerender(obj)
    end)
end

function M.disableAntiLag()
    M.removeAccessoriesEnabled=false;M.antiLagEnabled=false;if M.antiLagDescConn then M.antiLagDescConn:Disconnect();M.antiLagDescConn=nil end
    pcall(function() if M.defLightBrightness then Lighting.Brightness=M.defLightBrightness end;if M.defLightClock then Lighting.ClockTime=M.defLightClock end;if M.defLightAmbient then Lighting.OutdoorAmbient=M.defLightAmbient end;Lighting.ExposureCompensation=0 end)
end

-- ============================================================
-- ANTI-RAGDOLL
-- ============================================================
M.antiRagdollNoSplatterCooldown = 0

function M.forceNoSplatterReset()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end

    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then obj.Enabled = true end
            if obj:IsA("Constraint") then obj.Enabled = true end
        end

        workspace.CurrentCamera.CameraSubject = hum

        local PM = player.PlayerScripts:FindFirstChild("PlayerModule")
        if PM then
            local CM = require(PM:FindFirstChild("ControlModule"))
            if CM then CM:Enable() end
        end

        hum.AutoRotate = true
        hum.PlatformStand = false
        hum.Sit = false
    end)
end

function M.startAntiRagdoll()
    if M.Conns.antiRag then return end
    M.Conns.antiRag = RunService.Heartbeat:Connect(function()
        if not M.antiRagdollEnabled then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health <= 0 then return end

        local state = hum:GetState()
        local ragdolled = (state == Enum.HumanoidStateType.Physics or
                          state == Enum.HumanoidStateType.Ragdoll or
                          state == Enum.HumanoidStateType.FallingDown)

        if M.antiRagdollMode == "No Splatter" then
            if ragdolled then
                local now = tick()
                if now - (M.antiRagdollNoSplatterCooldown or 0) > 0.15 then
                    M.antiRagdollNoSplatterCooldown = now
                    M.forceNoSplatterReset()
                end
            end
            return
        end

        if not root then return end
        local endTime = player:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then
            ragdolled = true
        end
        if ragdolled then
            pcall(function()
                player:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
            end)
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("BallSocketConstraint") or
                   (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then
                    d:Destroy()
                end
            end
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") and obj.Enabled == false then
                    obj.Enabled = true
                end
            end
            if hum.Health > 0 then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            workspace.CurrentCamera.CameraSubject = hum
            root.Anchored = false
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end

function M.stopAntiRagdoll()
    if M.Conns.antiRag then
        M.Conns.antiRag:Disconnect()
        M.Conns.antiRag = nil
    end
end

-- ============================================================
-- INFINITE JUMP (BodyVelocity, anti-TPBack / anti-kick safe)
-- ============================================================
M.jumpHeld = false
M.infJumpThread = nil
M._infJumpBoosting = false
M._infJumpLastBoost = 0
M.INF_JUMP_BOOST_FORCE = 25
M.INF_JUMP_BOOST_FRAMES = 2
M.INF_JUMP_BOOST_COOLDOWN = 0.12

local function M_applyInfJumpBoost(root)
    if not root or M._infJumpBoosting then return end
    local now = tick()
    if now - M._infJumpLastBoost < M.INF_JUMP_BOOST_COOLDOWN then return end
    M._infJumpLastBoost = now
    M._infJumpBoosting = true

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(0, math.huge, 0)
    bv.P = 1250
    bv.Velocity = Vector3.new(root.Velocity.X, M.INF_JUMP_BOOST_FORCE, root.Velocity.Z)
    bv.Parent = root

    local frameCount = 0
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if frameCount < M.INF_JUMP_BOOST_FRAMES then
            frameCount = frameCount + 1
            if bv and bv.Parent then
                bv.Velocity = bv.Velocity + Vector3.new(0, 0.01, 0)
            end
        else
            if bv then pcall(function() bv:Destroy() end) end
            if conn then conn:Disconnect() end
            M._infJumpBoosting = false
        end
    end)
end

task.spawn(function()
    local pg = player:WaitForChild("PlayerGui", 10)
    if pg then
        local function hookJumpButton(btn)
            if btn:IsA("GuiButton") and btn.Name == "JumpButton" and not btn:GetAttribute("InfJumpHooked") then
                btn:SetAttribute("InfJumpHooked", true)
                btn.MouseButton1Down:Connect(function()
                    if M.infJumpEnabled then
                        M.jumpHeld = true
                    end
                end)
                btn.MouseButton1Up:Connect(function() M.jumpHeld = false end)
                btn.MouseLeave:Connect(function() M.jumpHeld = false end)
            end
        end
        for _, d in ipairs(pg:GetDescendants()) do hookJumpButton(d) end
        pg.DescendantAdded:Connect(hookJumpButton)
    end
end)

UIS.JumpRequest:Connect(function()
    if M.infJumpEnabled and M.infJumpMode == "manual" then
        M.jumpHeld = true
        task.delay(0.08, function() M.jumpHeld = false end)
    end
end)

UIS.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if M.infJumpEnabled
        and inp.UserInputType == Enum.UserInputType.Keyboard
        and inp.KeyCode == Enum.KeyCode.Space then
        M.jumpHeld = true
    end
end)

UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == Enum.KeyCode.Space then
        M.jumpHeld = false
    end
end)

function M.startManualInfJumpLoop()
    if M.infJumpThread then M.infJumpThread:Disconnect() end
    M.infJumpThread = RunService.Heartbeat:Connect(function()
        if not M.infJumpEnabled or M.infJumpMode ~= "manual" then return end
        if not M.jumpHeld then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end
        M_applyInfJumpBoost(root)
    end)
end

function M.stopManualInfJumpLoop()
    if M.infJumpThread then
        M.infJumpThread:Disconnect()
        M.infJumpThread = nil
    end
    M.jumpHeld = false
    M._infJumpBoosting = false
end

function M.startHoldInfJump()
    if M.holdInfJumpConn then M.holdInfJumpConn:Disconnect() end
    M.holdInfJumpConn = RunService.Heartbeat:Connect(function()
        if not M.infJumpEnabled or M.infJumpMode ~= "hold" then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        -- Hold logic from original Shadow: continuous Velocity boost while Space/Jump held
        local isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or M.jumpHeld or (hum.Jump == true)
        local vel = root.AssemblyLinearVelocity
        if isJumpHeld and vel.Y < 35 then
            root.AssemblyLinearVelocity = Vector3.new(vel.X, 55, vel.Z)
        end
        -- Cap fall speed
        vel = root.AssemblyLinearVelocity
        if vel.Y < -120 then
            root.AssemblyLinearVelocity = Vector3.new(vel.X, -120, vel.Z)
        end
    end)
end

function M.stopHoldInfJump()
    if M.holdInfJumpConn then
        M.holdInfJumpConn:Disconnect()
        M.holdInfJumpConn = nil
    end
end

-- ============================================================
function M.startUnwalk()
    local c=player.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate");if anim then M.unwalkSavedAnimate=anim:Clone();anim:Destroy() end
end

function M.stopUnwalk() local c=player.Character;if c and M.unwalkSavedAnimate then M.unwalkSavedAnimate:Clone().Parent=c;M.unwalkSavedAnimate=nil end end

-- Bugra-style instant reset: lock cam + TP far away to force respawn
M._instaResetTP = CFrame.new(2000.5, 9911.9, 4000.2)
M._isInstaResetting = false

function M.cursedInstaReset()
    -- removed
    return
end

function M.hasBrainrotInHand()
    local char = player.Character
    if not char then return false end
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") then
            local name = item.Name:lower()
            if name:find("brainrot", 1, true) or name:find("skibidi", 1, true) or name:find("toilet", 1, true) then
                return true
            end
        end
    end
    return false
end

function M.forceLaggerCarryWhileHolding()
    -- Disabled: normal mode keeps manual carry; lagger/bypass auto-switch via getActiveMoveSpeed
    return false
end

function M.toggleCarryMode()
    if M.forceLaggerCarryWhileHolding() then
        M.refreshSpeedModeLabel()
        if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
        if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
        if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
        if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
        if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
        if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
        saveCherryConfig()
        return
    end
    M.carrySpeedActive = not M.carrySpeedActive
    -- mutual exclusive: carry mode OFFS lagger carry (and vice versa handled in toggleLaggerCarry)
    if M.carrySpeedActive then
        M.laggerCarryActive = false
    end
    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.carryModeBtn then
        M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
    end
    if M.laggerCarryBtn then
        M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off"
    end
    saveCherryConfig()
end

function M.toggleLaggerMode()
    if M.forceLaggerCarryWhileHolding() then
        M.refreshSpeedModeLabel()
        if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
        if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
        if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
        if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
        saveCherryConfig()
        return
    end
    M.laggerModeEnabled = not M.laggerModeEnabled
    if M.laggerModeEnabled then M.laggerCarryActive = false end
    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.laggerModeBtn then
        M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off"
    end
    if M.laggerCarryBtn then
        M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off"
    end
    saveCherryConfig()
end

function M.cycleLaggerModeBind()
    if M.forceLaggerCarryWhileHolding() then
        M.refreshSpeedModeLabel()
        if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
        if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
        if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
        if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
        if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
        if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
        saveCherryConfig()
        return
    end
    if not M.laggerCarryActive and not M.laggerModeEnabled then
        M.laggerCarryActive = true
        M.laggerModeEnabled = false
        M.carrySpeedActive = false
    elseif M.laggerCarryActive then
        M.laggerCarryActive = false
        M.laggerModeEnabled = true
    else
        M.laggerModeEnabled = false
        M.laggerCarryActive = true
        M.carrySpeedActive = false
    end

    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.carryModeBtn then M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off" end
    saveCherryConfig()
end

function M.toggleLaggerCarry()
    M.laggerCarryActive = not M.laggerCarryActive
    -- mutual exclusive with normal carry mode
    if M.laggerCarryActive then
        M.laggerModeEnabled = false
        M.carrySpeedActive = false
    end
    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.laggerModeBtn then
        M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off"
    end
    if M.carryModeBtn then
        M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
    end
    if M.laggerCarryBtn then
        M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off"
    end
    saveCherryConfig()
end
M.toggleLaggerCarryMode = M.toggleLaggerCarry

function M.stopAutoLeft()
    M.autoLeftEnabled = false
    if M.alConn then M.alConn:Disconnect(); M.alConn = nil end
    M.alPhase = 1
    local char = player.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then h:Move(Vector3.zero, false) end
    end
    if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
    if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(false) end
end

function M.stopAutoRight()
    M.autoRightEnabled = false
    if M.arConn then M.arConn:Disconnect(); M.arConn = nil end
    M.arPhase = 1
    local char = player.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then h:Move(Vector3.zero, false) end
    end
    if M.autoRightSetVisual then M.autoRightSetVisual(false) end
    if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(false) end
end

-- Original fixed-path Auto Left / Right (as before)
function M.startAutoLeft()
    if M.alConn then M.alConn:Disconnect() end
    M.alPhase = 1
    M.autoLeftEnabled = true
    M.alConn = RunService.Heartbeat:Connect(function()
        if not M.autoLeftEnabled then return end
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        local spd = (M.getAutoPathSpeed and M.getAutoPathSpeed()) or (M.NS or 60)
        if M.alPhase == 1 then
            local tgt = Vector3.new(M.AP_L1.X, hrp.Position.Y, M.AP_L1.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                M.alPhase = 2
                local d = M.AP_L2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z)
                if mv.Magnitude > 0.01 then mv = mv.Unit end
                hum:Move(mv, false)
                hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = M.AP_L1 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            hum:Move(mv, false)
            hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif M.alPhase == 2 then
            local tgt = Vector3.new(M.AP_L2.X, hrp.Position.Y, M.AP_L2.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                hrp.AssemblyLinearVelocity = Vector3.zero
                M.autoLeftEnabled = false
                if M.alConn then M.alConn:Disconnect(); M.alConn = nil end
                M.alPhase = 1
                if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
                if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(false) end
                return
            end
            local d = M.AP_L2 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            hum:Move(mv, false)
            hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
        if M.autoMoveSwingEnabled and not M._alSwingDebounce then
            M._alSwingDebounce = true
            local bat = M.findBat and M.findBat() or (M.findBatForAimbot and M.findBatForAimbot())
            if bat then
                if bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(M.autoMoveSwingInterval or 0.3, function() M._alSwingDebounce = false end)
        end
    end)
end

function M.startAutoRight()
    if M.arConn then M.arConn:Disconnect() end
    M.arPhase = 1
    M.autoRightEnabled = true
    M.arConn = RunService.Heartbeat:Connect(function()
        if not M.autoRightEnabled then return end
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        local spd = (M.getAutoPathSpeed and M.getAutoPathSpeed()) or (M.NS or 60)
        if M.arPhase == 1 then
            local tgt = Vector3.new(M.AP_R1.X, hrp.Position.Y, M.AP_R1.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                M.arPhase = 2
                local d = M.AP_R2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z)
                if mv.Magnitude > 0.01 then mv = mv.Unit end
                hum:Move(mv, false)
                hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = M.AP_R1 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            hum:Move(mv, false)
            hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif M.arPhase == 2 then
            local tgt = Vector3.new(M.AP_R2.X, hrp.Position.Y, M.AP_R2.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                hrp.AssemblyLinearVelocity = Vector3.zero
                M.autoRightEnabled = false
                if M.arConn then M.arConn:Disconnect(); M.arConn = nil end
                M.arPhase = 1
                if M.autoRightSetVisual then M.autoRightSetVisual(false) end
                if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(false) end
                return
            end
            local d = M.AP_R2 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            hum:Move(mv, false)
            hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
        if M.autoMoveSwingEnabled and not M._arSwingDebounce then
            M._arSwingDebounce = true
            local bat = M.findBat and M.findBat() or (M.findBatForAimbot and M.findBatForAimbot())
            if bat then
                if bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(M.autoMoveSwingInterval or 0.3, function() M._arSwingDebounce = false end)
        end
    end)
end

function M.enableAntiKick()
    M.antiKickEnabled = true
    task.spawn(function()
        while M.antiKickEnabled do
            task.wait(0.5)
            local char = player.Character
            if char then
                local found = false
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        local n = tool.Name:lower()
                        if n:find("brainrot") or n:find("skibidi") or n:find("toilet") then
                            found = true
                            break
                        end
                    end
                end
                M.brainrotDetected = found
                if found then
                    if M.autoBatEnabled then M.stopBatAimbot() end
                    if M.autoLeftEnabled then M.autoLeftEnabled=false; if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end; M.stopAutoLeft() end
                    if M.autoRightEnabled then M.autoRightEnabled=false; if M.autoRightSetVisual then M.autoRightSetVisual(false) end; M.stopAutoRight() end
                end
            end
        end
    end)
end

function M.disableAntiKick()
    M.antiKickEnabled = false
    M.brainrotDetected = false
end

--------------------------------------------------------------------------------
-- SAFE MODE (locks combat during duel countdown / while holding brainrot)
--------------------------------------------------------------------------------
function M.safeModeGetCountdownLabel()
    local ok, label = pcall(function()
        local pg = player:FindFirstChild("PlayerGui")
        if not pg then return nil end
        local top = pg:FindFirstChild("DuelsMachineTopFrame")
        if not top then return nil end
        local inner = top:FindFirstChild("DuelsMachineTopFrame")
        if not inner then return nil end
        local timer = inner:FindFirstChild("Timer")
        if not timer then return nil end
        return timer:FindFirstChild("Label")
    end)
    return (ok and label) or nil
end

function M.safeModeCountdownNumber(text)
    local t = tostring(text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
    if t == "GO" or t == "START" or t == "READY" then return true end
    local n = tonumber(t)
    return n ~= nil and n >= 0 and n <= 10
end

function M.safeModeInDuelCountdown()
    local label = M.safeModeGetCountdownLabel()
    return label and M.safeModeCountdownNumber(label.Text) or false
end

M.SAFE_MODE_BLOCKED_TOOLS = {
    bat=true, slap=true, sword=true, gun=true, pistol=true, rifle=true,
    medusa=true, hammer=true, axe=true, knife=true, katana=true, blade=true, fist=true,
}

function M.safeModeIsCarryableTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local name = tool.Name:lower()
    for word in pairs(M.SAFE_MODE_BLOCKED_TOOLS) do
        if name:find(word, 1, true) then return false end
    end
    return true
end

function M.safeModeHoldingBrainrot()
    local ok, val = pcall(function() return player:GetAttribute("Stealing") end)
    if ok and val == true then return true end
    local ok2, val2 = pcall(function() return player:GetAttribute("AntiKick") end)
    if ok2 and val2 == true then return true end
    local char = player.Character
    if not char then return false end
    local ok3, val3 = pcall(function() return char:GetAttribute("Stealing") end)
    if ok3 and val3 == true then return true end
    if M.brainrotDetected then return true end
    if M.hasBrainrotInHand and M.hasBrainrotInHand() then return true end
    for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
        local v = char:FindFirstChild(name, true)
        if v then
            if v:IsA("BoolValue") and v.Value then return true end
            if v:IsA("ObjectValue") and v.Value then return true end
            if v:IsA("StringValue") and v.Value ~= "" then return true end
        end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
            local n = child.Name:lower()
            if n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") or n:find("hold") then
                return true
            end
        end
    end
    return false
end

function M.safeModeIsLocked()
    if not M.safeModeEnabled then return false end
    return M.safeModeInDuelCountdown() or M.safeModeHoldingBrainrot()
end

function M.safeModeForceStop(reason)
    local stopped = false
    if M.autoBatEnabled then
        M.stopBatAimbot()
        stopped = true
    end
    if M.bypassAimbotEnabled then
        M.stopBypassAimbot()
        stopped = true
    end
    if M.autoLeftEnabled then
        M.autoLeftEnabled = false
        if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
        M.stopAutoLeft()
        stopped = true
    end
    if M.autoRightEnabled then
        M.autoRightEnabled = false
        if M.autoRightSetVisual then M.autoRightSetVisual(false) end
        M.stopAutoRight()
        stopped = true
    end
    if stopped then
        -- optional toast; silent if no notifier
        pcall(function()
            if type(showActionNotification) == "function" then
                showActionNotification(reason or "SAFE MODE LOCK")
            end
        end)
    end
end

function M.safeModeTryStart()
    if M.safeModeIsLocked() then
        M.safeModeForceStop("SAFE MODE LOCK")
        return false
    end
    return true
end

function M.enableSafeMode()
    M.safeModeEnabled = true
end

function M.disableSafeMode()
    M.safeModeEnabled = false
end

if not M._safeModeMonitorStarted then
    M._safeModeMonitorStarted = true
    RunService.Heartbeat:Connect(function()
        if M.safeModeEnabled and M.safeModeIsLocked() then
            M.safeModeForceStop("SAFE MODE LOCK")
        end
    end)
end


function M.isStealState()
    -- Match auto-switch carry script: WalkSpeed drops while carrying / stealing
    local char = player.Character
    if not char then return false end
    if M.hasBrainrotInHand() then return true end
    local h = char:FindFirstChildOfClass("Humanoid")
    if h and h.WalkSpeed < 25 then return true end
    local ok, val = pcall(function() return player:GetAttribute("Stealing") end)
    if ok and val == true then return true end
    local ok2, val2 = pcall(function() return char:GetAttribute("Stealing") end)
    if ok2 and val2 == true then return true end
    return false
end

function M.getActiveMoveSpeed()
    local holding = M.hasBrainrotInHand() or M.isStealState()

    -- LAGGER: auto normal/carry on brainrot
    if M.laggerModeEnabled or M.laggerCarryActive then
        if holding then
            return tonumber(M.LAGGER_CARRY_SPEED) or 22
        end
        return tonumber(M.LAGGER_SPEED) or 22
    end

    -- NORMAL: manual carry mode only
    if M.carrySpeedActive then
        return tonumber(M.CS) or 30
    end
    return tonumber(M.NS) or 60
end

function M.getAutoPathSpeed()
    if M.laggerModeEnabled or M.laggerCarryActive then return M.LAGGER_SPEED
    else return M.NS end
end

function M.setModeNormalFlags()
    M.carrySpeedActive = false
    M.laggerModeEnabled = false
    M.laggerCarryActive = false
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(false) end
    if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry Off" end
    if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
end

function M.setModeCarryFlags()
    M.carrySpeedActive = true
    M.laggerModeEnabled = false
    M.laggerCarryActive = false
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(true) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(false) end
    if M.carryModeBtn then M.carryModeBtn.Text = "Carry On" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry Off" end
    if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
end

function M.setModeLaggerCarryFlags()
    M.carrySpeedActive = false
    M.laggerModeEnabled = false
    M.laggerCarryActive = true
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
    if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
    if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
end

function M.stopWalkSpeedAutoSwitch()
    if M._autoSwitchSpeedConn then
        pcall(function() M._autoSwitchSpeedConn:Disconnect() end)
        M._autoSwitchSpeedConn = nil
    end
end

function M.startWalkSpeedAutoSwitch()
    if M._autoSwitchSpeedConn then return end
    M._autoSwitchSpeedConn = RunService.Heartbeat:Connect(function()
        if not M.autoSwitchSpeedEnabled then
            M.stopWalkSpeedAutoSwitch()
            return
        end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local ws = hum.WalkSpeed or 16
        local thr = tonumber(M.AUTO_SWITCH_THRESHOLD) or 25

        -- Auto Carry Speed only
        if M.autoSwitchSpeedEnabled and ws <= thr and not M.carrySpeedActive and not M.laggerCarryActive then
            M.setModeCarryFlags()
        end
    end)
end


function M.isNearEnemyBase(range)
    range = tonumber(range) or M.autoCarryEnemyBaseRange or 35
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local myPos = hrp.Position
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") and not isMyPlot(plot.Name) then
            local pos
            local ok, pivot = pcall(function() return plot:GetPivot().Position end)
            if ok and pivot then pos = pivot
            else
                local sign = plot:FindFirstChild("PlotSign")
                if sign and sign:IsA("BasePart") then pos = sign.Position
                elseif sign then
                    local pp = sign:FindFirstChildWhichIsA("BasePart", true)
                    if pp then pos = pp.Position end
                end
            end
            if pos then
                local flat = Vector3.new(myPos.X - pos.X, 0, myPos.Z - pos.Z)
                if flat.Magnitude <= range then return true end
            end
        end
    end
    return false
end
function M.enableCarryModeOnly()
    if M.carrySpeedActive then return end
    M.carrySpeedActive = true
    if M.carryModeBtn then M.carryModeBtn.Text = "Carry On" end
    if M.mobBtnRefs.carrySpeed then pcall(function() M.mobBtnRefs.carrySpeed(true) end) end
    if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
end
function M.startAutoCarryEnemyBase()
    if M._autoCarryEnemyBaseConn then return end
    local acc = 0
    M._autoCarryEnemyBaseConn = RunService.Heartbeat:Connect(function(dt)
        if not M.autoCarryEnemyBaseEnabled then return end
        acc = acc + (dt or 0.016)
        if acc < 0.2 then return end
        acc = 0
        if M.carrySpeedActive then return end
        if M.isNearEnemyBase(M.autoCarryEnemyBaseRange) then M.enableCarryModeOnly() end
    end)
end
function M.stopAutoCarryEnemyBase()
    if M._autoCarryEnemyBaseConn then pcall(function() M._autoCarryEnemyBaseConn:Disconnect() end); M._autoCarryEnemyBaseConn = nil end
end
function M.setAutoCarryEnemyBase(on)
    M.autoCarryEnemyBaseEnabled = on and true or false
    if M.autoCarryEnemyBaseEnabled then M.startAutoCarryEnemyBase() else M.stopAutoCarryEnemyBase() end
    if M.setAutoCarryEnemyBaseVisual then pcall(function() M.setAutoCarryEnemyBaseVisual(M.autoCarryEnemyBaseEnabled) end) end
end
function M.refreshWalkSpeedAutoSwitch()
    if M.autoSwitchSpeedEnabled then
        M.startWalkSpeedAutoSwitch()
    else
        M.stopWalkSpeedAutoSwitch()
    end
end

function M.updateAutoSwitchSpeed()
    -- Steal-based auto carry (existing)
    if M.autoSwitchSpeedEnabled then
        local isSteal = M.isStealState()
        if isSteal ~= M._autoSwitchWasSteal then
            M._autoSwitchWasSteal = isSteal
            local inLagger = M.laggerModeEnabled or M.laggerCarryActive
            if isSteal then
                if inLagger then
                    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
                    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
                    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
                    if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
                else
                    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(true) end
                    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(false) end
                    if M.carryModeBtn then M.carryModeBtn.Text = "Carry On" end
                    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry Off" end
                end
            else
                if inLagger then
                    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
                    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
                    if M.laggerCarryBtn then M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off" end
                    if M.laggerModeBtn then M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off" end
                    if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
                else
                    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
                    if M.carryModeBtn then M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off" end
                end
            end
            if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
        end
    end
end

function M.isRagdollState(hum)
    if not hum then return true end;local st=hum:GetState()
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
end

-- Drop Brainrot (Xray.Vs style — ascend then snap to ground)
M.lastDropTime = M.lastDropTime or 0
M.dropConnections = M.dropConnections or {}

function M.stopDropBrainrot()
    M.dropActive = false
    if M._dropConn then
        pcall(function() M._dropConn:Disconnect() end)
        M._dropConn = nil
    end
    for _, t in ipairs(M.dropConnections or {}) do
        if type(t) == "thread" then
            pcall(task.cancel, t)
        elseif typeof(t) == "RBXScriptConnection" then
            pcall(function() t:Disconnect() end)
        end
    end
    M.dropConnections = {}
    local c = player.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

function M.runDrop()
    if M.dropActive then return end
    -- anti accidental: short global debounce
    local now = tick()
    if M._lastDropInvoke and (now - M._lastDropInvoke) < 0.35 then return end
    M._lastDropInvoke = now
    -- never auto-drop while TP bat / steal active
    if M.bypassAimbotEnabled or M.isStealing then return end
    pcall(function() M.stopAutoTPForAction() end)
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    M.dropActive = true
    local startTime = tick()
    local dropConn
    dropConn = RunService.Heartbeat:Connect(function()
        local currentChar = player.Character
        local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
        if not currentChar or not currentRoot then
            if dropConn then pcall(function() dropConn:Disconnect() end) end
            M.dropActive = false
            return
        end
        if tick() - startTime >= (tonumber(M.DROP_ASCEND_DURATION) or 0.2) then
            if dropConn then pcall(function() dropConn:Disconnect() end) end
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {currentChar}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            local rayResult = workspace:Raycast(currentRoot.Position, Vector3.new(0, -2000, 0), rayParams)
            if rayResult then
                local hum = currentChar:FindFirstChildOfClass("Humanoid")
                local offset = (hum and hum.HipHeight or 2) + (currentRoot.Size.Y / 2)
                currentRoot.CFrame = CFrame.new(currentRoot.Position.X, rayResult.Position.Y + offset, currentRoot.Position.Z)
                    * CFrame.Angles(0, select(2, currentRoot.CFrame:ToEulerAnglesYXZ()), 0)
                currentRoot.AssemblyLinearVelocity = Vector3.zero
                currentRoot.AssemblyAngularVelocity = Vector3.zero
            end
            M.dropActive = false
            return
        end
        -- Xray.Vs: push upward during ascend window
        local v = currentRoot.AssemblyLinearVelocity
        local up = tonumber(M.DROP_ASCEND_SPEED) or 150
        pcall(function()
            currentRoot.AssemblyLinearVelocity = Vector3.new(v.X, up, v.Z)
            currentRoot.Velocity = Vector3.new(v.X, up, v.Z)
        end)
    end)
    task.delay(1.0, function()
        if M.dropActive then
            M.dropActive = false
            if dropConn then pcall(function() dropConn:Disconnect() end) end
        end
    end)
end

M.runDropBrainrot = M.runDrop

function M.executeDropWithToggle(setVisual)
    if M.dropActive then return end
    task.spawn(function()
        if setVisual then pcall(setVisual, true) end
        M.runDrop()
        while M.dropActive do task.wait() end
        task.wait(0.1)
        if setVisual then pcall(setVisual, false) end
    end)
end

function M.stopAutoTPForAction()
    if M.autoTPEnabled then
        M.stopAutoTP()
        pcall(function() if M.setAutoTPVisual then M.setAutoTPVisual(false) end end)
        pcall(function() if M.saveConfig then M.saveConfig() end end)
    end
end


local function setupDeathReset()
    -- Insta reset on death completely removed
    if M._deathResetConn then
        pcall(function() M._deathResetConn:Disconnect() end)
        M._deathResetConn = nil
    end
    M.autoResetOnDeath = false
end

function M.startRemoveAcc()
    if M.removeAccEnabled then return end
    M.removeAccEnabled = true
    local function removeAccDo()
        if not M.removeAccEnabled then return end
        local char = player.Character
        if not char then return end
        for _,obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Accessory") or obj:IsA("Hat") then
                if not M.removedAccessories[obj] then
                    M.removedAccessories[obj] = true
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end
    removeAccDo()
    M.removeAccConn = player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if M.removeAccEnabled then removeAccDo() end
    end)
end

function M.stopRemoveAcc()
    M.removeAccEnabled = false
    if M.removeAccConn then
        M.removeAccConn:Disconnect()
        M.removeAccConn = nil
    end
    M.removedAccessories = {}
end

-- ============================================================
-- MOBILE BUTTONS (trascinabili singolarmente)
-- ============================================================
function M.destroyMobileButtons()
    if M.mobGuiRef then
        pcall(function() M.mobGuiRef:Destroy() end)
        M.mobGuiRef = nil
    end
    for _,n in ipairs({"MoveeMobileButtons"}) do
        local old = game:GetService("CoreGui"):FindFirstChild(n); if old then old:Destroy() end
        local pgui = player:FindFirstChild("PlayerGui"); if pgui then local o = pgui:FindFirstChild(n); if o then o:Destroy() end end
    end
    M.mobBtnRefs = {}
    M.mobBtnFrames = {}
end

function M.loadBtnPositions()
    local out = {}
    -- Primary: dedicated positions file
    if isfile and isfile(M.MOB_POS_FILE) then
        local ok, data = pcall(function() return HS:JSONDecode(readfile(M.MOB_POS_FILE)) end)
        if ok and type(data) == "table" then
            for k, v in pairs(data) do
                if type(v) == "table" then
                    out[k] = v
                end
            end
        end
    end
    -- Backup: CherryConfig.btnPos
    if M._btnPosCache and type(M._btnPosCache) == "table" then
        for k, v in pairs(M._btnPosCache) do
            if not out[k] and type(v) == "table" and type(v.x) == "number" and type(v.y) == "number" then
                out[k] = {x = v.x, y = v.y}
            end
        end
    end
    return out
end

function M.saveBtnPositions()
    if not M.mobGuiRef or not M.mobGuiRef.Parent then return end
    local out = {}
    -- Prefer explicit frame map (Green Duels stack)
    if M.mobBtnFrames then
        for key, child in pairs(M.mobBtnFrames) do
            if child and child.Parent then
                out[key] = {
                    x = child.AbsolutePosition.X,
                    y = child.AbsolutePosition.Y,
                    sx = child.Position.X.Scale,
                    sy = child.Position.Y.Scale,
                    ox = child.Position.X.Offset,
                    oy = child.Position.Y.Offset,
                }
            end
        end
    end
    for _, child in ipairs(M.mobGuiRef:GetChildren()) do
        local key = child:GetAttribute("BtnKey")
        if key and not out[key] then
            out[key] = {
                x = child.AbsolutePosition.X,
                y = child.AbsolutePosition.Y,
                sx = child.Position.X.Scale,
                sy = child.Position.Y.Scale,
                ox = child.Position.X.Offset,
                oy = child.Position.Y.Offset,
            }
        end
    end
    M._btnPosCache = out
    if writefile then
        pcall(function() writefile(M.MOB_POS_FILE, HS:JSONEncode(out)) end)
    end
    -- Also persist via main config when available
    pcall(function()
        if saveCherryConfig then saveCherryConfig() end
    end)
end

function M.resetMobilePositions()
    -- Clear saved positions (os.remove often missing in executors)
    pcall(function()
        if type(delfile) == "function" then
            delfile(M.MOB_POS_FILE)
        elseif type(writefile) == "function" then
            writefile(M.MOB_POS_FILE, "{}")
        end
    end)
    pcall(function()
        if isfile and isfile(M.MOB_POS_FILE) and type(writefile) == "function" then
            writefile(M.MOB_POS_FILE, "{}")
        end
    end)
    M._forceDefaultMobPos = true
    M.buildMobileButtons()
    M._forceDefaultMobPos = false
    -- Snap any leftover to defaults again after build
    pcall(function()
        if not M.mobGuiRef then return end
        local out = {}
        for _, child in ipairs(M.mobGuiRef:GetDescendants()) do
            if child:IsA("TextButton") and child:GetAttribute("BtnKey") then
                local key = child:GetAttribute("BtnKey")
                local dx = child:GetAttribute("DefaultX")
                local dy = child:GetAttribute("DefaultY")
                if typeof(dx) == "number" and typeof(dy) == "number" then
                    child.Position = UDim2.new(0, dx, 0, dy)
                    out[key] = {x = dx, y = dy}
                end
            end
        end
        if writefile then
            writefile(M.MOB_POS_FILE, HS:JSONEncode(out))
        end
    end)
end


-- Apply chosen UI colour + bg image tint to live mobile buttons
function M.refreshMobileButtonTheme()
    if not M.mobGuiRef or not M.mobGuiRef.Parent then return end
    local accent = UI_ACCENT or CHERRY_ACCENT or Color3.fromRGB(0, 100, 220)
    local dim = UI_ACCENT_DIM or accent:Lerp(Color3.new(0,0,0), 0.4)
    local offTop = M.themeDarkFromAccent(accent, 0.28)
    local offBot = M.themeDarkFromAccent(accent, 0.10)
    for _, child in ipairs(M.mobGuiRef:GetDescendants()) do
        if child:IsA("ImageLabel") and child.Name == "BtnBgImage" then
            child.ImageColor3 = Color3.fromRGB(255, 255, 255) -- no red tint on bg image
        end
        if child:IsA("UIStroke") and (child.Name == "BtnStroke" or child.Parent and child.Parent:IsA("TextButton")) then
            local btn = child.Parent
            local on = btn and btn:GetAttribute("MB_On") == true
            if on then
                child.Color = accent
                child.Transparency = 0
                child.Thickness = 2
            else
                child.Color = dim
                child.Transparency = 0.25
                child.Thickness = 1.5
            end
        end
        if child:IsA("UIGradient") and child.Name == "BtnGrad" then
            local btn = child.Parent
            local on = btn and btn:GetAttribute("MB_On") == true
            if on then
                child.Color = ColorSequence.new(accent:Lerp(Color3.new(1,1,1), 0.35), accent)
            else
                child.Color = ColorSequence.new(offTop, offBot)
            end
        end
        if child:IsA("UIGradient") and child.Parent and child.Parent.Name:find("MobCont_", 1, true) then
            child.Color = ColorSequence.new(offTop, offBot)
        end
        if child:IsA("UIStroke") and child.Parent and child.Parent.Name:find("MobCont_", 1, true) then
            child.Color = dim
        end
    end
    -- Re-apply setOn visuals for each known ref
    for key, setOn in pairs(M.mobBtnRefs or {}) do
        if type(setOn) == "function" then
            -- preserve current on state via attribute if possible
            pcall(function()
                local cont = M.mobGuiRef:FindFirstChild("MobCont_" .. key)
                local btn = cont and cont:FindFirstChild("Btn_" .. key)
                if btn then
                    setOn(btn:GetAttribute("MB_On") == true)
                end
            end)
        end
    end
end

function M.buildMobileButtons()
    M.destroyMobileButtons()
    if not M.mobileButtonsEnabled then return end

    local LAYOUT_VER = 2
    if M._mobLayoutVer ~= LAYOUT_VER then
        M._mobLayoutVer = LAYOUT_VER
        M._forceDefaultMobPos = true
        pcall(function()
            if type(writefile) == "function" then writefile(M.MOB_POS_FILE, "{}") end
        end)
    end

    local savedPositions = M._forceDefaultMobPos and {} or (M.loadBtnPositions and M.loadBtnPositions() or {})

    -- 2-column grid:
    -- Auto left | Auto right
    -- TP bat    | Bat aimbot
    -- Drop      | TP down
    -- Lagger    | Carry
    local BTN_W, BTN_H, BTN_GAP, COLS = 58, 58, 8, 2
    local scale = math.max(0.7, math.min(1.4, (tonumber(M.mobileButtonsSize) or 100) / 100))
    BTN_W = math.floor(58 * scale)
    BTN_H = math.floor(58 * scale)
    BTN_GAP = math.floor(8 * scale)

    local mobGui = Instance.new("ScreenGui")
    mobGui.Name = "MoveeMobileButtons"
    mobGui.ResetOnSpawn = false
    mobGui.DisplayOrder = 100
    mobGui.IgnoreGuiInset = true
    mobGui.Enabled = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(mobGui) end end)
    if not pcall(function() mobGui.Parent = game:GetService("CoreGui") end) then
        mobGui.Parent = player:WaitForChild("PlayerGui")
    end
    M.mobGuiRef = mobGui
    M.mobBtnRefs = M.mobBtnRefs or {}
    M.mobBtnFrames = {}

    -- Shadow colours: off = black/white, on = red/white
    local accent = UI_ACCENT or Color3.fromRGB(0, 100, 220)
    local C = {
        stackBg = Color3.fromRGB(0, 0, 0),
        stackBrd = Color3.fromRGB(40, 40, 40),
        stackTxt = Color3.fromRGB(255, 255, 255),
        stackActBg = accent,
        stackActBrd = accent,
        stackActTxt = Color3.fromRGB(255, 255, 255),
    }

    -- User layout (2 columns)
    local stackDefs = {
        {key = "autoLeft",    label = "AUTO\nLEFT",     toggle = true},
        {key = "autoRight",   label = "AUTO\nRIGHT",    toggle = true},
        {key = "bypass",      label = "TP\nBAT",        toggle = true},
        {key = "autoBat",     label = "BAT\nAIMBOT",    toggle = true},
        {key = "drop",        label = "DROP",           toggle = false},
        {key = "tpDown",      label = "TP\nDOWN",       toggle = false},
        {key = "lagger",      label = "LAGGER",         toggle = true},
        {key = "carrySpeed",  label = "CARRY",          toggle = true},
    }

    local function getDefaultStackPos(i)
        local col = (i - 1) % COLS
        local row = math.floor((i - 1) / COLS)
        local totalRows = math.ceil(#stackDefs / COLS)
        return UDim2.new(
            1, -(COLS * (BTN_W + BTN_GAP) - BTN_GAP + 14) + col * (BTN_W + BTN_GAP),
            0.5, -(totalRows * (BTN_H + BTN_GAP) - BTN_GAP) / 2 + row * (BTN_H + BTN_GAP)
        )
    end

    for i, def in ipairs(stackDefs) do
        local key = def.key
        local btnFrame = Instance.new("TextButton")
        btnFrame.Name = "StackBtn_" .. key
        btnFrame.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        local saved = savedPositions and savedPositions[key]
        if saved and type(saved.sx) == "number" then
            btnFrame.Position = UDim2.new(saved.sx, saved.ox or 0, saved.sy or 0, saved.oy or 0)
        elseif saved and type(saved.x) == "number" and type(saved.y) == "number" then
            btnFrame.Position = UDim2.new(0, saved.x, 0, saved.y)
        else
            btnFrame.Position = getDefaultStackPos(i)
        end
        btnFrame.BackgroundColor3 = C.stackBg
        btnFrame.BorderSizePixel = 0
        btnFrame.AutoButtonColor = false
        btnFrame.Text = def.label
        btnFrame.TextColor3 = C.stackTxt
        btnFrame.TextScaled = false
        btnFrame.TextSize = math.max(9, math.floor(11 * scale))
        btnFrame.Font = Enum.Font.GothamBold
        btnFrame.TextWrapped = true
        btnFrame.LineHeight = 1.2
        btnFrame.ZIndex = 15
        btnFrame:SetAttribute("BtnKey", key)
        btnFrame.Parent = mobGui
        Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 12)
        local bStroke = Instance.new("UIStroke")
        bStroke.Name = "BtnStroke"
        bStroke.Color = C.stackBrd
        bStroke.Thickness = 1
        bStroke.Parent = btnFrame

        -- LED branco animado nas laterais do botão móvel
        local ledStroke = Instance.new("UIStroke")
        ledStroke.Name = "MovingWhiteLED"
        ledStroke.Color = Color3.fromRGB(255, 255, 255)
        ledStroke.Thickness = 2.2
        ledStroke.Transparency = 0.08
        ledStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        ledStroke.Parent = btnFrame

        local ledGradient = Instance.new("UIGradient")
        ledGradient.Name = "MovingWhiteLEDGradient"
        ledGradient.Rotation = 0
        ledGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        ledGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.92),
            NumberSequenceKeypoint.new(0.30, 0.82),
            NumberSequenceKeypoint.new(0.44, 0.05),
            NumberSequenceKeypoint.new(0.50, 0),
            NumberSequenceKeypoint.new(0.56, 0.05),
            NumberSequenceKeypoint.new(0.70, 0.82),
            NumberSequenceKeypoint.new(1, 0.92),
        })
        ledGradient.Parent = ledStroke

        -- Movimento contínuo do brilho branco pelas laterais
        task.spawn(function()
            while ledStroke.Parent and btnFrame.Parent do
                ledGradient.Offset = Vector2.new(-1, 0)
                local tween = TweenService:Create(
                    ledGradient,
                    TweenInfo.new(1.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
                    {Offset = Vector2.new(1, 0)}
                )
                tween:Play()
                tween.Completed:Wait()
            end
        end)


        M.mobBtnFrames[key] = btnFrame

        local btnState = false
        local function setOn(on)
            btnState = on == true
            btnFrame:SetAttribute("MB_On", btnState)
            TweenService:Create(btnFrame, TweenInfo.new(0.15), {
                BackgroundColor3 = btnState and C.stackActBg or C.stackBg,
                TextColor3 = btnState and C.stackActTxt or C.stackTxt,
            }):Play()
            TweenService:Create(bStroke, TweenInfo.new(0.15), {
                Color = btnState and C.stackActBrd or C.stackBrd,
            }):Play()
        end
        M.mobBtnRefs[key] = setOn

        local function fireAction()
            if key == "tpDown" then
                -- instant, no cooldown
                pcall(function()
                    if M.runTPFloor then M.runTPFloor()
                    elseif M.doAutoTPDown then M.doAutoTPDown(true) end
                end)
                setOn(true)
                task.defer(function() setOn(false) end)
                return
            end
            if key == "drop" then
                task.spawn(function()
                    setOn(true)
                    if M.executeDropWithToggle then
                        M.executeDropWithToggle(function(v) setOn(v) end)
                    elseif M.runDrop then
                        pcall(M.runDrop)
                    elseif M.runDropBrainrot then
                        pcall(M.runDropBrainrot)
                    end
                    local t0 = tick()
                    while M.dropActive and (tick() - t0) < 1.5 do task.wait() end
                    setOn(false)
                end)
                return
            end
            if key == "reset" then
                task.spawn(function()
                    setOn(true)
                    if M.cursedInstaReset then pcall(M.cursedInstaReset) end
                    task.wait(0.15)
                    setOn(false)
                end)
                return
            end
            if key == "bypass" then
                M.toggleBypassAimbot()
                setOn(M.bypassAimbotEnabled)
                if M.setBypassVisual then pcall(M.setBypassVisual, M.bypassAimbotEnabled) end
                pcall(saveCherryConfig)
                return
            end
            if key == "autoLeft" then
                if M.autoRightEnabled then
                    M.autoRightEnabled = false
                    if M.stopAutoRight then M.stopAutoRight() end
                    if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(false) end
                end
                M.autoLeftEnabled = not M.autoLeftEnabled
                if M.autoLeftEnabled then
                    if M.startAutoLeft then M.startAutoLeft() end
                else
                    if M.stopAutoLeft then M.stopAutoLeft() end
                end
                setOn(M.autoLeftEnabled)
                pcall(saveCherryConfig)
                return
            end
            if key == "autoRight" then
                if M.autoLeftEnabled then
                    M.autoLeftEnabled = false
                    if M.stopAutoLeft then M.stopAutoLeft() end
                    if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(false) end
                end
                M.autoRightEnabled = not M.autoRightEnabled
                if M.autoRightEnabled then
                    if M.startAutoRight then M.startAutoRight() end
                else
                    if M.stopAutoRight then M.stopAutoRight() end
                end
                setOn(M.autoRightEnabled)
                pcall(saveCherryConfig)
                return
            end
            if key == "autoBat" then
                if not M.autoBatEnabled then
                    if M.queueAutoBatStart then M.queueAutoBatStart() else if M.startBatAimbot then M.startBatAimbot() end end
                else
                    if M.stopBatAimbot then M.stopBatAimbot() end
                end
                setOn(M.autoBatEnabled)
                if M.autoBatSetVisual then pcall(M.autoBatSetVisual, M.autoBatEnabled) end
                pcall(saveCherryConfig)
                return
            end
            if key == "lagger" then
                M.laggerCarryActive = false
                if M.toggleLaggerMode then M.toggleLaggerMode() end
                setOn(M.laggerModeEnabled)
                if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
                if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
                pcall(saveCherryConfig)
                return
            end
            if key == "laggerCarry" then
                if M.toggleLaggerCarryMode then
                    M.toggleLaggerCarryMode()
                else
                    -- fallback: toggle flag + reuse toggleCarry if needed
                    M.laggerCarryActive = not M.laggerCarryActive
                    if M.laggerCarryActive and M.laggerModeEnabled then
                        M.laggerModeEnabled = false
                    end
                end
                setOn(M.laggerCarryActive)
                if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
                pcall(saveCherryConfig)
                return
            end
            if key == "carrySpeed" then
                if M.toggleCarryMode then M.toggleCarryMode() end
                setOn(M.carrySpeedActive)
                if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
                pcall(saveCherryConfig)
                return
            end
        end

        -- Green Duels drag + tap logic
        local dragStartPos, startPos = nil, nil
        local isDragging, movedEnough, wasPressed = false, false, false
        local pressTime = 0

        btnFrame.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            if M.mobileButtonsLocked then return end
            wasPressed = true
            pressTime = tick()
            dragStartPos = input.Position
            startPos = btnFrame.Position
            isDragging = true
            movedEnough = false
        end)
        btnFrame.InputChanged:Connect(function(input)
            if not isDragging or M.mobileButtonsLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStartPos
                if delta.Magnitude > 8 then movedEnough = true end
                if movedEnough then
                    btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end
        end)
        btnFrame.InputEnded:Connect(function(input)
            if not isDragging then return end
            isDragging = false
            if movedEnough then
                if M.saveBtnPositions then pcall(M.saveBtnPositions) end
            elseif wasPressed and not movedEnough then
                -- no time-window cooldown — any short tap fires
                fireAction()
            end
            wasPressed = false
        end)
        btnFrame.MouseButton1Click:Connect(function()
            -- backup click path (no time-window / no cooldown)
            if movedEnough then return end
            if wasPressed then return end -- InputEnded already fired
            fireAction()
        end)
    end

    if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(M.autoLeftEnabled) end
    if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(M.autoRightEnabled) end
    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(M.autoBatEnabled) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(M.bypassAimbotEnabled) end
end



-- ============================================================
-- CONFIG SAVE/LOAD
-- ============================================================
local CHERRY_CONFIG_NAME = "CherryConfig.json"
local CherryConfig = { Theme="Red" }
local CHERRY_THEMES = {
    Default  = { Accent=Color3.fromRGB(0, 100, 220), AccentDim=Color3.fromRGB(0, 85, 160), Bg=Color3.fromRGB(0,0,0), Row=Color3.fromRGB(14,10,10) },
    Red      = { Accent=Color3.fromRGB(0, 85, 220), AccentDim=Color3.fromRGB(0, 80, 160), Bg=Color3.fromRGB(0,0,0), Row=Color3.fromRGB(14,10,10) },
    Purple   = { Accent=Color3.fromRGB(150,40,255), AccentDim=Color3.fromRGB(100,20,180), Bg=Color3.fromRGB(0,0,0), Row=Color3.fromRGB(12,8,16) },
    Blue     = { Accent=Color3.fromRGB(90,160,255),  AccentDim=Color3.fromRGB(60,120,200),  Bg=Color3.fromRGB(6,10,18),   Row=Color3.fromRGB(12,18,30) },
    Yellow   = { Accent=Color3.fromRGB(255,214,0),   AccentDim=Color3.fromRGB(200,170,0),   Bg=Color3.fromRGB(12,12,4),   Row=Color3.fromRGB(20,18,8) },
    Grey     = { Accent=Color3.fromRGB(255, 255, 255), AccentDim=Color3.fromRGB(140,140,150), Bg=Color3.fromRGB(10,10,12),  Row=Color3.fromRGB(18,18,22) },
    Forest   = { Accent=Color3.fromRGB(46,200,120),  AccentDim=Color3.fromRGB(30,140,80),   Bg=Color3.fromRGB(4,12,8),    Row=Color3.fromRGB(10,22,14) },
    Cyan     = { Accent=Color3.fromRGB(0,220,255),   AccentDim=Color3.fromRGB(0,160,190),   Bg=Color3.fromRGB(4,12,16),   Row=Color3.fromRGB(8,20,26) },
    Orange   = { Accent=Color3.fromRGB(0, 160, 255),  AccentDim=Color3.fromRGB(0, 160, 200),  Bg=Color3.fromRGB(14,10,6),   Row=Color3.fromRGB(24,16,10) },
}
if M._savedTheme and CHERRY_THEMES[M._savedTheme] then
    CherryConfig.Theme = M._savedTheme
end
M.colorScheme = CherryConfig.Theme
M.bgImageColor = Color3.fromRGB(255, 255, 255) -- no color tint on background image
M.customBgId = 88039161387070 -- custom background image
M.customBgOpacity = 0.15
M.mobBtnBgId = 0 -- mobile button images removed


local function loadCherryConfig()
    if type(readfile)~="function" or type(isfile)~="function" then return end
    local ok,d = pcall(function()
        if not isfile(CHERRY_CONFIG_NAME) then return nil end
        return HS:JSONDecode(readfile(CHERRY_CONFIG_NAME))
    end)
    if ok and type(d)=="table" then
        local themeName = nil
        if type(d.Theme)=="string" and CHERRY_THEMES[d.Theme] then themeName = d.Theme end
        if themeName == "Pink" then themeName = "Red" end
        if type(d.colorScheme)=="string" and CHERRY_THEMES[d.colorScheme] then themeName = d.colorScheme end
        if themeName then
            CherryConfig.Theme = themeName
            M.colorScheme = themeName
            M._savedTheme = themeName
        end
        if type(d.normalSpeed)=="number" then M.NS=d.normalSpeed end
        if type(d.carrySpeed)=="number" then M.CS=d.carrySpeed end
        if type(d.laggerSpeed)=="number" then M.LAGGER_SPEED=d.laggerSpeed end
        if type(d.laggerCarrySpeed)=="number" then M.LAGGER_CARRY_SPEED=d.laggerCarrySpeed end
        if type(d.bypassSpeed)=="number" then M.BYPASS_SPEED=d.bypassSpeed end
        if type(d.bypassCarrySpeed)=="number" then M.BYPASS_CARRY_SPEED=d.bypassCarrySpeed end
        if type(d.speedMethod)=="string" then
            for _,sm in ipairs(M.speedMethodList) do if sm==d.speedMethod then M.speedMethod=sm; break end end
        end
        if type(d.grabRadius)=="number" then M.Steal.StealRadius=d.grabRadius end
        if type(d.stealDuration)=="number" then M.Steal.StealDuration=d.stealDuration end
        if type(d.stealStopTime)=="number" then M.Steal.StopTime=d.stealStopTime end
        if type(d.stealMode)=="string" then
            if d.stealMode == "Semi" or d.stealMode == "V2" then
                M.stealMode=d.stealMode
            end
        end
        if type(d.autoTPHeight)=="number" then M.autoTPHeight=d.autoTPHeight end
        if type(d.fovValue)=="number" then M.fovValue=d.fovValue end
        if type(d.uiScale)=="number" then M.uiScale=math.min(d.uiScale, 0.60) end
        if type(d.infJumpMode)=="string" then M.infJumpMode=d.infJumpMode end
        if type(d.mobileButtonsSize)=="number" then M.mobileButtonsSize=d.mobileButtonsSize end
        if type(d.skyTheme)=="string" then M.currentSkyTheme=d.skyTheme end
        if type(d.stealBarSize)=="number" then M.stealBarSize=d.stealBarSize end
        if d.carrySpeedActive~=nil then M.carrySpeedActive=d.carrySpeedActive end
        if d.laggerModeEnabled~=nil then M.laggerModeEnabled=d.laggerModeEnabled end
        if d.autoSwing~=nil then M.autoSwingEnabled=d.autoSwing==true end
        if d.introSoundEnabled~=nil then M.introSoundEnabled=d.introSoundEnabled==true end
        if d.introSongChoice then M.introSongChoice=d.introSongChoice end
        if d.introGUIEnabled~=nil then M.introGUIEnabled=d.introGUIEnabled==true end
        if d.ragdollGui~=nil then M.ragdollGuiEnabled=d.ragdollGui==true end
        if d.circleButtonsEnabled~=nil then M.circleButtonsEnabled=d.circleButtonsEnabled==true end
        if d.perButtonDrag~=nil then M.perButtonDragEnabled=d.perButtonDrag==true end
        if d.mobileButtonsEnabled~=nil then M.mobileButtonsEnabled=d.mobileButtonsEnabled end
        M.medusaResetEnabled = false -- feature removed
        if d.autoMoveSwing~=nil then M.autoMoveSwingEnabled=d.autoMoveSwing==true end
        if d.autoSwitchSpeed~=nil then M.autoSwitchSpeedEnabled=d.autoSwitchSpeed==true end
        if d.autoCarryEnemyBase~=nil then M.autoCarryEnemyBaseEnabled=d.autoCarryEnemyBase==true end
        if type(d.autoCarryEnemyBaseRange)=="number" then M.autoCarryEnemyBaseRange=d.autoCarryEnemyBaseRange end
        if d.pingPanelOpen~=nil then M.pingPanelOpen=d.pingPanelOpen==true end
        if type(d.killLaggerNivel)=="string" then M.killLaggerNivel=d.killLaggerNivel end
        if d.killLaggerOpen~=nil then M.killLaggerOpen=d.killLaggerOpen==true end
        if type(d.killLaggerKey)=="string" then M.killLaggerKey=d.killLaggerKey end
        if d.killLaggerLocked~=nil then M.killLaggerLocked=d.killLaggerLocked==true end
        if type(d.pingPower)=="number" then M.pingPower=d.pingPower end
        if type(d.pingInterval)=="number" then M.pingInterval=d.pingInterval end
        if type(d.pingKeybindKb)=="string" then M.pingKeybindKb=d.pingKeybindKb end
        if type(d.pingKeybindGp)=="string" then M.pingKeybindGp=d.pingKeybindGp end
        if d.pingAutoBrainrot~=nil then M.pingAutoBrainrot=d.pingAutoBrainrot==true end
        if type(d.pingBackground)=="number" then M.pingBackground=d.pingBackground end
        if d.pingLocked~=nil then M.pingLocked=d.pingLocked==true end
        if d.pingMinimized~=nil then M.pingMinimized=d.pingMinimized==true end
        if d.bypassPanelOpen~=nil then M.bypassPanelOpen=d.bypassPanelOpen==true end
        if d.bypassAutoBrainrot~=nil then M.bypassAutoBrainrot=d.bypassAutoBrainrot==true end
        if d.bypassBillboardOn~=nil then M.bypassBillboardOn=d.bypassBillboardOn~=false end
        if type(d.bypassKeybind)=="string" then M.bypassKeybind=d.bypassKeybind end
        if type(d.bypassPower)=="number" then M.bypassPower=d.bypassPower end
        if d.mobileButtonsLocked~=nil then M.mobileButtonsLocked=d.mobileButtonsLocked==true end
        if type(d.mobLayoutVer)=="number" then M._mobLayoutVer=d.mobLayoutVer end
        M.autoTurnOffSpeedEnabled=false
        M.autoSwitchLaggerSpeedEnabled=false
        if type(d.customFont)=="string" then M.customFontSelected=d.customFont end
        if d.showPlayerSpeeds~=nil then M.showPlayerSpeeds=d.showPlayerSpeeds==true end
        if d.removeAcc~=nil then M.removeAccEnabled=d.removeAcc end
        if d.playerESPEnabled~=nil then M.playerESPEnabled=d.playerESPEnabled end
        if d.antiRagdoll~=nil then M.antiRagdollEnabled=d.antiRagdoll end
        if d.hardHitEnabled~=nil then M.hardHitEnabled=d.hardHitEnabled==true end
        if type(d.hardHitRadius)=="number" then M.hardHitRadius=d.hardHitRadius end
        if type(d.antiRagdollMode)=="string" and (d.antiRagdollMode=="Splatter" or d.antiRagdollMode=="No Splatter") then M.antiRagdollMode=d.antiRagdollMode end
        if d.autoStealEnabled~=nil then M.Steal.AutoStealEnabled=d.autoStealEnabled end
        if d.autoRadiusEnabled~=nil then M.autoRadiusEnabled=d.autoRadiusEnabled==true end

        if d.infiniteJump~=nil then M.infJumpEnabled=d.infiniteJump end
        if d.medusaCounter~=nil then M.medusaCounterEnabled=d.medusaCounter end
        if d.batCounter~=nil then M.batCounterEnabled=d.batCounter end
        if d.unwalkEnabled~=nil then M.unwalkEnabled=d.unwalkEnabled end
        if d.antiLag~=nil then M.antiLagEnabled=d.antiLag end
        if d.antiSummerBase~=nil then M.antiSummerBaseEnabled=d.antiSummerBase end
        M.uiLocked = false
        if d.stretchRez~=nil then M.stretchRezEnabled=d.stretchRez end
        if d.autoTPEnabled~=nil then M.autoTPEnabled=d.autoTPEnabled end
        if d.antiKick~=nil then M.antiKickEnabled=d.antiKick end
        if d.safeMode~=nil then M.safeModeEnabled=d.safeMode end
        if d.vyncSkin~=nil then M.vyncSkinEnabled=d.vyncSkin==true end
        if type(d.btnPos)=="table" then M._btnPosCache=d.btnPos end
        if d.autoBat~=nil then M.autoBatEnabled=d.autoBat end
        if d.semiHoldMin then M.Semi.holdMin=d.semiHoldMin end
        if d.semiHoldMax then M.Semi.holdMax=d.semiHoldMax end
        if d.semiEntryDelay then M.Semi.entryDelay=d.semiEntryDelay end
        if d.semiPrimeRange then M.Semi.primeRange=d.semiPrimeRange end
        if type(d.semiRadius)=="number" then M.Semi.radius=math.min(d.semiRadius, 10) end
        if d.lineESPEnabled~=nil then M.lineESPEnabled=d.lineESPEnabled end
        if d.highlightESPEnabled~=nil then M.highlightESPEnabled=d.highlightESPEnabled==true end
        if d.menuOpen~=nil then M.menuOpen=d.menuOpen~=false end
        -- theme already applied above; keep M._savedTheme in sync
        if type(d.Theme)=="string" and CHERRY_THEMES[d.Theme] then M._savedTheme=d.Theme; M.colorScheme=d.Theme end
        if type(d.colorScheme)=="string" and CHERRY_THEMES[d.colorScheme] then M._savedTheme=d.colorScheme; M.colorScheme=d.colorScheme end
        if d.speedESPEnabled~=nil then M.speedESPEnabled=d.speedESPEnabled end
        M.autoResetOnDeath = false -- feature removed
        if type(d.animPack)=="string" then M.animPack=d.animPack end
        if type(M.animPack) ~= "string" or not M.PACKS[M.animPack] then M.animPack = "Bubbly" end
        if d.headlessEnabled~=nil then M.headlessEnabled=d.headlessEnabled end
        if d.korbloxEnabled~=nil then M.korbloxEnabled=d.korbloxEnabled end
        if d.shadowBlackSkinEnabled~=nil then M.shadowBlackSkinEnabled=d.shadowBlackSkinEnabled==true end
        if d.bypassAimbotEnabled~=nil then M.bypassAimbotEnabled=d.bypassAimbotEnabled end
        if type(d.tpBatHitMode)=="string" then
            local m = tostring(d.tpBatHitMode):lower()
            if m == "normal" or m == "normal hit" then
                M.tpBatHitMode = "Normal"
            else
                M.tpBatHitMode = "Sure"
            end
        end
        if d.animPackEnabled~=nil then M.animPackEnabled=d.animPackEnabled end
        local function lk(e,d2)
            if type(d2)~="table" then return end
            if d2.kb and Enum.KeyCode[d2.kb] then e.kb=Enum.KeyCode[d2.kb] else e.kb=nil end
            if d2.gp and Enum.KeyCode[d2.gp] then e.gp=Enum.KeyCode[d2.gp] else e.gp=nil end
        end
        if d.dropBrainrotKey then lk(M.KB.DropBrainrot,d.dropBrainrotKey) end
        if d.autoLeftKey then lk(M.KB.AutoLeft,d.autoLeftKey) end
        if d.autoRightKey then lk(M.KB.AutoRight,d.autoRightKey) end
        if d.autoBatKey then lk(M.KB.AutoBat,d.autoBatKey) end
        if d.laggerToggleKey then lk(M.KB.LaggerToggle,d.laggerToggleKey) end
        if d.tpFloorKey then lk(M.KB.TPFloor,d.tpFloorKey) end
        if M.KB.InstaReset then M.KB.InstaReset.kb=nil; M.KB.InstaReset.gp=nil else M.KB.InstaReset={kb=nil,gp=nil} end -- removed
        if d.guiHideKey then lk(M.KB.GuiHide,d.guiHideKey) end
        if d.speedToggleKey then lk(M.KB.SpeedToggle,d.speedToggleKey) end
        if d.bypassAimbotKey then lk(M.KB.BypassAimbot,d.bypassAimbotKey) end
        if d.pingLaggerKey then lk(M.KB.PingLagger,d.pingLaggerKey) end
        if M.KB.PingLagger and M.KB.PingLagger.kb then M.pingKeybindKb = M.KB.PingLagger.kb.Name end
        if M.KB.PingLagger and M.KB.PingLagger.gp then M.pingKeybindGp = M.KB.PingLagger.gp.Name end
        -- Dedupe shared keys after load (each keycode only on one bind)
        do
            local seenKb, seenGp = {}, {}
            local order = {
                M.KB.BypassAimbot, M.KB.AutoBat, M.KB.DropBrainrot, M.KB.SpeedToggle,
                M.KB.LaggerToggle, M.KB.AutoLeft, M.KB.AutoRight, M.KB.TPFloor,
                M.KB.PingLagger, M.KB.GuiHide, M.KB.InstaReset,
            }
            for _, e in ipairs(order) do
                if type(e) == "table" then
                    if e.kb then
                        if seenKb[e.kb] then e.kb = nil else seenKb[e.kb] = true end
                    end
                    if e.gp then
                        if seenGp[e.gp] then e.gp = nil else seenGp[e.gp] = true end
                    end
                end
            end
        end
    end
end

local function saveCherryConfig()
    if type(writefile)~="function" then return end
    local function ks(e)
        if type(e) ~= "table" then return {kb=nil,gp=nil} end
        return {
            kb = (e.kb and e.kb.Name) or nil,
            gp = (e.gp and e.gp.Name) or nil,
        }
    end
    local cfg = {
        Theme=CherryConfig.Theme, colorScheme=M.colorScheme or CherryConfig.Theme, menuOpen=M.menuOpen~=false,
        normalSpeed=M.NS, carrySpeed=M.CS, laggerSpeed=M.LAGGER_SPEED,
        laggerCarrySpeed=M.LAGGER_CARRY_SPEED, bypassSpeed=M.BYPASS_SPEED, bypassCarrySpeed=M.BYPASS_CARRY_SPEED, speedMethod=M.speedMethod, grabRadius=M.Steal.StealRadius,
        stealDuration=M.Steal.StealDuration, stealStopTime=M.Steal.StopTime, stealMode=M.stealMode,
        autoTPHeight=M.autoTPHeight, fovValue=M.fovValue, uiScale=M.uiScale,
        infJumpMode=M.infJumpMode,
        mobileButtonsSize=M.mobileButtonsSize, skyTheme=M.currentSkyTheme,
        customBgId=tonumber(M.customBgId) or 0, customBgOpacity=tonumber(M.customBgOpacity) or 0.35,
        mobBtnBgId=tonumber(M.mobBtnBgId) or 0, btnPos=M._btnPosCache,
        stealBarSize=M.stealBarSize,
        carrySpeedActive=M.carrySpeedActive, laggerModeEnabled=M.laggerModeEnabled,
        autoSwing=M.autoSwingEnabled, introSoundEnabled=M.introSoundEnabled,
        introSongChoice=M.introSongChoice,
        introGUIEnabled=M.introGUIEnabled,
        ragdollGui=M.ragdollGuiEnabled, circleButtonsEnabled=M.circleButtonsEnabled,
        perButtonDrag=M.perButtonDragEnabled, mobileButtonsEnabled=M.mobileButtonsEnabled,
        medusaReset=M.medusaResetEnabled, autoMoveSwing=M.autoMoveSwingEnabled,
        autoSwitchSpeed=M.autoSwitchSpeedEnabled, autoTurnOffSpeed=M.autoTurnOffSpeedEnabled, autoSwitchLaggerSpeed=M.autoSwitchLaggerSpeedEnabled, autoCarryEnemyBase=M.autoCarryEnemyBaseEnabled, autoCarryEnemyBaseRange=M.autoCarryEnemyBaseRange, pingPanelOpen=M.pingPanelOpen==true, killLaggerNivel=M.killLaggerNivel or "low", killLaggerOpen=M.killLaggerOpen~=false, killLaggerKey=M.killLaggerKey or "E", killLaggerLocked=M.killLaggerLocked==true, pingPower=M.pingPower, pingInterval=M.pingInterval, pingKeybindKb=(M.KB.PingLagger and M.KB.PingLagger.kb and M.KB.PingLagger.kb.Name) or M.pingKeybindKb, pingKeybindGp=(M.KB.PingLagger and M.KB.PingLagger.gp and M.KB.PingLagger.gp.Name) or M.pingKeybindGp, pingAutoBrainrot=M.pingAutoBrainrot==true, pingBackground=M.pingBackground or 0, pingLocked=M.pingLocked==true, pingMinimized=M.pingMinimized==true, bypassPanelOpen=M.bypassPanelOpen==true, bypassAutoBrainrot=M.bypassAutoBrainrot==true, bypassBillboardOn=M.bypassBillboardOn~=false, bypassKeybind=M.bypassKeybind, bypassPower=M.bypassPower, mobileButtonsLocked=M.mobileButtonsLocked==true, mobLayoutVer=M._mobLayoutVer or 2, customFont=M.customFontSelected, showPlayerSpeeds=M.showPlayerSpeeds,
        removeAcc=M.removeAccEnabled,
        playerESPEnabled=M.playerESPEnabled,
        autoStealEnabled=M.Steal.AutoStealEnabled,
        autoRadiusEnabled=M.autoRadiusEnabled,
        antiRagdoll=M.antiRagdollEnabled, hardHitEnabled=M.hardHitEnabled, hardHitRadius=M.hardHitRadius, antiRagdollMode=M.antiRagdollMode, infiniteJump=M.infJumpEnabled,
        medusaCounter=M.medusaCounterEnabled, batCounter=M.batCounterEnabled,
        unwalkEnabled=M.unwalkEnabled, antiLag=M.antiLagEnabled, antiSummerBase=M.antiSummerBaseEnabled, uiLocked=M.uiLocked,
        stretchRez=M.stretchRezEnabled, autoTPEnabled=M.autoTPEnabled,
        antiKick=M.antiKickEnabled, safeMode=M.safeModeEnabled, autoBat=M.autoBatEnabled, vyncSkin=M.vyncSkinEnabled==true,
        semiHoldMin=M.Semi.holdMin, semiHoldMax=M.Semi.holdMax,
        semiEntryDelay=M.Semi.entryDelay,
        semiPrimeRange=M.Semi.primeRange,
        semiRadius=math.min(M.Semi.radius, 10),
        lineESPEnabled=M.lineESPEnabled, highlightESPEnabled=M.highlightESPEnabled,
        speedESPEnabled=M.speedESPEnabled,
        autoResetOnDeath=M.autoResetOnDeath,
        animPack=M.animPack,
        headlessEnabled=M.headlessEnabled,
        korbloxEnabled=M.korbloxEnabled,
        shadowBlackSkinEnabled=M.shadowBlackSkinEnabled~=false,
        bypassAimbotEnabled=M.bypassAimbotEnabled,
        tpBatHitMode=M.tpBatHitMode or "Sure",
        animPackEnabled=M.animPackEnabled,
        dropBrainrotKey=ks(M.KB.DropBrainrot), autoLeftKey=ks(M.KB.AutoLeft),
        autoRightKey=ks(M.KB.AutoRight), autoBatKey=ks(M.KB.AutoBat),
        laggerToggleKey=ks(M.KB.LaggerToggle), tpFloorKey=ks(M.KB.TPFloor),
        instaResetKey=ks(M.KB.InstaReset), guiHideKey=ks(M.KB.GuiHide),
        speedToggleKey=ks(M.KB.SpeedToggle), bypassAimbotKey=ks(M.KB.BypassAimbot),
        pingLaggerKey=ks(M.KB.PingLagger),
    }
    pcall(function() writefile(CHERRY_CONFIG_NAME, HS:JSONEncode(cfg)) end)
end

M.saveConfig = saveCherryConfig

-- ============================================================
-- CHERRY ESP
-- ============================================================
local RunService2 = game:GetService("RunService")
local cherryESPState = { LineESP=false, SpeedESP=false, HighlightESP=(M.highlightESPEnabled==true) }
local cherryESPObjects = {}
local DrawingAvailable = false
pcall(function() DrawingAvailable = Drawing and type(Drawing.new)=="function" end)

local function cherryRemoveESP(p)
    local r = cherryESPObjects[p]
    if not r then return end
    for _,o in pairs(r) do pcall(function()
        if typeof(o)=="Instance" then o:Destroy()
        elseif o.Remove then o:Remove() end
    end) end
    cherryESPObjects[p]=nil
end

local function cherryGetSpeed(root)
    local v
    pcall(function() v=root.AssemblyLinearVelocity end)
    if not v then pcall(function() v=root.Velocity end) end
    if not v then return 0 end
    return Vector3.new(v.X,0,v.Z).Magnitude
end

local function cherryCreateESP(p)
    if cherryESPObjects[p] then return cherryESPObjects[p] end
    local r={}
    local hl=Instance.new("Highlight")
    hl.FillTransparency=0.55; hl.OutlineTransparency=0
    hl.FillColor=Color3.fromRGB(0, 100, 220)
    hl.OutlineColor=Color3.fromRGB(0, 100, 220)
    hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
    hl.Enabled=false; hl.Parent=workspace
    r.Highlight=hl
    local bb=Instance.new("BillboardGui")
    bb.Size=UDim2.fromOffset(150,32); bb.StudsOffset=Vector3.new(0,3.25,0)
    bb.AlwaysOnTop=true; bb.Enabled=false; bb.ResetOnSpawn=false
    bb.Parent=player:WaitForChild("PlayerGui")
    local sl=Instance.new("TextLabel",bb)
    sl.Size=UDim2.fromScale(1,1); sl.BackgroundTransparency=1; sl.Text="0.0 spd"
    sl.TextStrokeColor3=Color3.new(0,0,0); sl.TextStrokeTransparency=0
    sl.Font=Enum.Font.GothamBlack; sl.TextSize=18
    sl.TextXAlignment=Enum.TextXAlignment.Center; sl.TextYAlignment=Enum.TextYAlignment.Center
    r.Billboard=bb; r.SpeedText=sl
    if DrawingAvailable then
        local ln=Drawing.new("Line")
        ln.Visible=false; ln.Thickness=2.75; ln.Transparency=1
        r.Line=ln
    end
    cherryESPObjects[p]=r
    return r
end

Players.PlayerRemoving:Connect(function(p) cherryRemoveESP(p) end)

-- Build dark UI colours from a chosen accent (every "black" becomes that colour family)
local function themeDarkFromAccent(accent, amount)
    return M.themeDarkFromAccent(accent, amount)
end

local function isNearBlack(c, threshold)
    if typeof(c) ~= "Color3" then return false end
    threshold = threshold or 0.14
    return c.R <= threshold and c.G <= threshold and c.B <= threshold
end

local function applyAccentFromTheme()
    local name = "Red"
    CherryConfig.Theme = "Red"
    M.colorScheme = "Red"
    M._savedTheme = "Red"
    -- Pure black UI + red accents
    local accent = Color3.fromRGB(0, 100, 220)
    local dim = Color3.fromRGB(0, 85, 160)
    local bg  = Color3.fromRGB(0, 0, 0)
    local row = Color3.fromRGB(12, 12, 14)
    local btn = Color3.fromRGB(18, 18, 20)
    local gradTop = Color3.fromRGB(20, 20, 22)
    local gradBot = Color3.fromRGB(0, 0, 0)

    CHERRY_ACCENT = accent
    UI_ACCENT = accent
    M.bgImageColor = Color3.fromRGB(255, 255, 255) -- keep BG untinted
    UI_ACCENT_DIM = dim
    UI_BG_DARK = bg
    UI_ROW_BG = row
    UI_BTN_BG = btn
    UI_TOGGLE_OFF = Color3.fromRGB(0, 0, 0)
    UI_TOGGLE_KNOB = Color3.fromRGB(255, 255, 255)
    UI_KNOB_ON = Color3.fromRGB(255, 255, 255)
    UI_TEXT_PRIMARY = Color3.fromRGB(255, 255, 255)
    UI_TEXT_WHITE = Color3.fromRGB(255, 255, 255)
    UI_TEXT_DIM = Color3.fromRGB(140, 140, 150)
    UI_TEXT_SECTION = accent
    UI_CARD_STROKE = Color3.fromRGB(40, 40, 44)
    UI_GRAD_TOP = gradTop
    UI_GRAD_BOT = gradBot

    M.Theme = {
        Name = name,
        Accent = accent,
        AccentDim = dim,
        Bg = bg,
        Row = row,
    }
end

-- Walk any GUI tree and replace near-black BackgroundColor3 / stroke blacks with theme colours
function M.recolorBlacksToTheme(root)
    if not root then return end
    local bg = UI_BG_DARK or themeDarkFromAccent(UI_ACCENT or Color3.new(1,1,1), 0.10)
    local row = UI_ROW_BG or themeDarkFromAccent(UI_ACCENT or Color3.new(1,1,1), 0.18)
    local btn = UI_BTN_BG or themeDarkFromAccent(UI_ACCENT or Color3.new(1,1,1), 0.22)
    local accent = UI_ACCENT or Color3.new(1,1,1)
    local dim = UI_ACCENT_DIM or accent

    local function recolor(obj)
        if obj:IsA("GuiObject") then
            local n = obj.Name or ""
            if n == "StealBar" or n == "StealBadge" or n == "Fill" then return end
            local ok, col = pcall(function() return obj.BackgroundColor3 end)
            if ok and isNearBlack(col) then
                -- Main frames stay darkest; smaller elements get row/btn tint
                if obj:IsA("Frame") and (obj.Name == "Main" or obj.Name == "MainFrame" or obj.Size.X.Scale >= 0.9) then
                    obj.BackgroundColor3 = bg
                elseif obj:IsA("TextButton") or obj:IsA("ImageButton") then
                    obj.BackgroundColor3 = btn
                else
                    obj.BackgroundColor3 = row
                end
            end
        end
        if obj:IsA("UIStroke") then
            local ok, col = pcall(function() return obj.Color end)
            if ok and isNearBlack(col, 0.25) then
                obj.Color = dim
            end
        end
        if obj:IsA("UIGradient") then
            pcall(function()
                obj.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, UI_GRAD_TOP or gradTop or row),
                    ColorSequenceKeypoint.new(1, UI_GRAD_BOT or bg),
                })
            end)
        end
    end

    recolor(root)
    for _, d in ipairs(root:GetDescendants()) do
        recolor(d)
    end
end

local CHERRY_ACCENT = CHERRY_THEMES[CherryConfig.Theme].Accent

local _espFrameSkip = 0
RunService2.Heartbeat:Connect(function()
    -- only when ESP features on
    if not (cherryESPState.LineESP or cherryESPState.SpeedESP or cherryESPState.HighlightESP) then
        -- hide any existing
        for p,r in pairs(cherryESPObjects) do
            if r.Line then r.Line.Visible=false end
            if r.Highlight then r.Highlight.Enabled=false end
            if r.Billboard then r.Billboard.Enabled=false end
        end
        return
    end
    _espFrameSkip = _espFrameSkip + 1
    if _espFrameSkip < 2 then return end -- every 2nd frame
    _espFrameSkip = 0
    local cam=workspace.CurrentCamera; if not cam then return end
    local lc=player.Character
    local lr=lc and lc:FindFirstChild("HumanoidRootPart")
    local lineStart=Vector2.new(cam.ViewportSize.X*0.5, cam.ViewportSize.Y*0.82)
    if lr then
        local rp,rv=cam:WorldToViewportPoint(lr.Position)
        if rv and rp.Z>0 then lineStart=Vector2.new(rp.X,rp.Y) end
    end
    for _,p in ipairs(Players:GetPlayers()) do
        if p==player then continue end
        local r=cherryCreateESP(p)
        local ch=p.Character
        local hum=ch and ch:FindFirstChildOfClass("Humanoid")
        local root=ch and ch:FindFirstChild("HumanoidRootPart")
        local head=ch and ch:FindFirstChild("Head")
        local alive=ch and hum and root and hum.Health>0
        if not alive then
            if r.Line then r.Line.Visible=false end
            r.Highlight.Enabled=false; r.Billboard.Enabled=false
            r.Highlight.Adornee=nil; r.Billboard.Adornee=nil
            continue
        end
        local liveAccent = Color3.fromRGB(0, 100, 220) -- red tracers/box
        local showHL = cherryESPState.HighlightESP or cherryESPState.LineESP
        r.Highlight.Adornee=ch; r.Highlight.Enabled=showHL
        r.Highlight.OutlineColor=liveAccent
        r.Highlight.FillColor=liveAccent
        r.Highlight.FillTransparency=0.55
        r.Highlight.OutlineTransparency=0
        if r.Line then
            local tp,tv=cam:WorldToViewportPoint(root.Position)
            if cherryESPState.LineESP and tv and tp.Z>0 then
                r.Line.From=lineStart; r.Line.To=Vector2.new(tp.X,tp.Y)
                r.Line.Color=liveAccent; r.Line.Thickness=3; r.Line.Visible=true
            else r.Line.Visible=false end
        end
        if cherryESPState.SpeedESP and head then
            r.Billboard.Adornee=head; r.Billboard.Enabled=true
            r.SpeedText.Text=string.format("%.1f spd",cherryGetSpeed(root))
            r.SpeedText.TextColor3=liveAccent
        else r.Billboard.Enabled=false; r.Billboard.Adornee=nil end
    end
end)

function M.trackConn(conn) table.insert(M._persistentConns,conn); return conn end
function M.clearPersistentConns()
    for _,c in ipairs(M._persistentConns) do pcall(function() c:Disconnect() end) end
    M._persistentConns={}
end

function M.makeNumberCallback(tbl,key,min,max)
    return function(v)
        if min and v<min then return end
        if max and v>max then return end
        tbl[key]=v
        if key=="mobileButtonsSize" and M.mobileButtonsEnabled then M.buildMobileButtons() end
        if key=="stealBarSize" then M.buildStatusUI() end
        saveCherryConfig()
    end
end

-- ============================================================
-- Shadow DUELS UI (ORIZZONTALE TABS + MENU PIÙ BASSO)
-- ============================================================

local UI_ACCENT       = Color3.fromRGB(0, 100, 220)
local UI_ACCENT_DIM   = Color3.fromRGB(0, 85, 160)
local UI_BG_DARK      = Color3.fromRGB(0, 0, 0)
local UI_ROW_BG       = Color3.fromRGB(12, 12, 14)
local UI_CARD_STROKE  = Color3.fromRGB(40, 40, 44)
local UI_TEXT_WHITE   = Color3.fromRGB(255, 255, 255)
local UI_TEXT_PRIMARY = Color3.fromRGB(255, 255, 255)
local UI_TEXT_DIM     = Color3.fromRGB(140, 140, 150)
local UI_TEXT_SECTION = Color3.fromRGB(0, 100, 220)
local UI_BTN_BG       = Color3.fromRGB(18, 18, 20)
local UI_TOGGLE_OFF   = Color3.fromRGB(0, 0, 0)
local UI_TOGGLE_KNOB  = Color3.fromRGB(255, 255, 255)
local UI_KNOB_ON      = Color3.fromRGB(255, 255, 255)
local UI_GRAD_TOP     = Color3.fromRGB(20, 20, 22)
local UI_GRAD_BOT     = Color3.fromRGB(0, 0, 0)


-- Apply saved colour scheme before any UI is built
pcall(applyAccentFromTheme)

local UI_TWEEN_FAST = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local UI_TWEEN_MED  = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- UI STYLE HELPERS
local function uiCardStyle(f)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,14); c.Parent = f
    local s = Instance.new("UIStroke"); s.Thickness = 1; s.Color = UI_ACCENT or Color3.fromRGB(255,255,255); s.Transparency = 0.72; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = f
    local g = Instance.new("UIGradient"); g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, (UI_ROW_BG or Color3.fromRGB(22,12,24)):Lerp(Color3.fromRGB(30,18,36), 0.5)),
        ColorSequenceKeypoint.new(1, UI_BG_DARK or Color3.fromRGB(12,6,14))
    }); g.Rotation = 90; g.Parent = f
end

local function uiSmallBtn(p)
    local b = Instance.new("TextButton")
    b.Position = p.Pos or UDim2.new(0,0,0,0); b.Size = p.Size or UDim2.new(0,40,0,23)
    b.BackgroundColor3 = p.Bg or UI_BTN_BG; b.BorderSizePixel = 0
    b.Text = p.Text or ""; b.TextColor3 = p.Col or UI_TEXT_DIM; b.TextSize = p.TS or 11
    b.Font = Enum.Font.GothamBold; b.AutoButtonColor = false; b.ZIndex = p.Z or 1; b.Parent = p.Parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,p.CR or 6); c.Parent = b
    return b
end

local function uiAccentBar(parent, on)
    local b = Instance.new("Frame")
    b.Position = UDim2.new(0,0,0.5,-11); b.Size = UDim2.new(0,3,0,22)
    b.BackgroundColor3 = on and UI_ACCENT or UI_TEXT_WHITE
    b.BackgroundTransparency = on and 0 or 1; b.BorderSizePixel = 0; b.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,2); c.Parent = b
    return b
end

local function uiAutoCanvas(scroll)
    local lay = scroll:FindFirstChildOfClass("UIListLayout"); if not lay then return end
    local pad = scroll:FindFirstChildOfClass("UIPadding")
    local function upd()
        local padBottom = (pad and pad.PaddingBottom.Offset or 0)
        local padTop = (pad and pad.PaddingTop.Offset or 0)
        local h = lay.AbsoluteContentSize.Y + padBottom + padTop + 24
        scroll.CanvasSize = UDim2.new(0, 0, 0, math.max(h, 1))
    end
    lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(upd)
    task.defer(upd)
    task.delay(0.15, upd)
    task.delay(0.5, upd)
end

local function uiSectionHeader(parent, text)
    local r = Instance.new("Frame"); r.Size = UDim2.new(1,0,0,28); r.BackgroundTransparency = 1; r.Parent = parent
    local b = Instance.new("Frame"); b.Position = UDim2.new(0,2,0.5,-8); b.Size = UDim2.new(0,4,0,16)
    b.BackgroundColor3 = UI_ACCENT; b.BorderSizePixel = 0; b.Parent = r
    Instance.new("UICorner",b).CornerRadius = UDim.new(1,0)
    local l = Instance.new("TextLabel"); l.Position = UDim2.new(0,14,0,0); l.Size = UDim2.new(1,-14,1,0)
    l.BackgroundTransparency = 1; l.Text = string.upper(tostring(text or "")); l.TextColor3 = UI_ACCENT; l.TextSize = 12
    l.Font = Enum.Font.GothamBlack; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = r
    return r
end

local function uiInputRow(parent, label, def, hidden)
    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,44)
    r.BackgroundColor3 = UI_ROW_BG; r.BackgroundTransparency = 0.1; r.BorderSizePixel = 0
    if hidden then r.Visible = false end; r.Parent = parent; uiCardStyle(r)
    local l = Instance.new("TextLabel"); l.Position = UDim2.new(0,13,0,0); l.Size = UDim2.new(1,-84,1,0)
    l.BackgroundTransparency = 1; l.Text = label; l.TextColor3 = UI_TEXT_PRIMARY; l.TextSize = 13
    l.Font = Enum.Font.GothamMedium; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = r
    local bx = Instance.new("TextBox"); bx.Position = UDim2.new(1,-66,0.5,-12); bx.Size = UDim2.new(0,56,0,25)
    bx.BackgroundColor3 = UI_BTN_BG; bx.BorderSizePixel = 0; bx.Text = tostring(def); bx.TextColor3 = UI_ACCENT
    bx.TextSize = 13; bx.Font = Enum.Font.GothamBold; bx.Parent = r
    Instance.new("UICorner",bx).CornerRadius = UDim.new(0,6)
    return r, bx
end

local function uiToggleRow(parent, label, on, callback)
    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,46)
    r.BackgroundColor3 = UI_ROW_BG; r.BackgroundTransparency = 0.1; r.BorderSizePixel = 0; r.Parent = parent; uiCardStyle(r)
    local bar = uiAccentBar(r, on)
    local l = Instance.new("TextLabel"); l.Position = UDim2.new(0,14,0,0); l.Size = UDim2.new(1,-74,1,0)
    l.BackgroundTransparency = 1; l.Text = label; l.TextColor3 = UI_TEXT_PRIMARY; l.TextSize = 14
    l.Font = Enum.Font.GothamMedium; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = r

    local tb = Instance.new("TextButton"); tb.Position = UDim2.new(1,-54,0.5,-11); tb.Size = UDim2.new(0,44,0,22)
    tb.BackgroundColor3 = on and UI_ACCENT or UI_TOGGLE_OFF; tb.BorderSizePixel = 0; tb.Text = ""; tb.AutoButtonColor = false; tb.Parent = r
    Instance.new("UICorner",tb).CornerRadius = UDim.new(0,11)
    local knob = Instance.new("Frame"); knob.Size = UDim2.new(0,16,0,16); knob.BorderSizePixel = 0
    knob.Position = on and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)
    knob.BackgroundColor3 = on and UI_KNOB_ON or UI_TOGGLE_KNOB; knob.Parent = tb
    Instance.new("UICorner",knob)

    local state = on
    local function set(v)
        state = v
        TweenService:Create(tb, UI_TWEEN_FAST, {BackgroundColor3 = v and UI_ACCENT or UI_TOGGLE_OFF}):Play()
        TweenService:Create(knob, UI_TWEEN_FAST, {Position = v and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8), BackgroundColor3 = v and UI_KNOB_ON or UI_TOGGLE_KNOB}):Play()
        TweenService:Create(bar, UI_TWEEN_FAST, {BackgroundTransparency = v and 0 or 1}):Play()
        bar.BackgroundColor3 = UI_ACCENT
    end
    tb.MouseButton1Click:Connect(function()
        set(not state)
        if callback then callback(state) end
        saveCherryConfig()
    end)
    return r, set
end

local function uiActionRow(parent, label, callback)
    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,42)
    r.BackgroundColor3 = UI_ROW_BG; r.BackgroundTransparency = 0.1; r.BorderSizePixel = 0; r.Parent = parent; uiCardStyle(r)
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1
    btn.Text = label; btn.TextColor3 = UI_TEXT_PRIMARY; btn.TextSize = 14; btn.Font = Enum.Font.GothamBold; btn.Parent = r
    local bar = uiAccentBar(r, false)

    btn.MouseButton1Click:Connect(function()
        bar.BackgroundColor3 = UI_ACCENT
        TweenService:Create(bar, UI_TWEEN_FAST, {BackgroundTransparency = 0}):Play()
        task.delay(0.3, function() TweenService:Create(bar, UI_TWEEN_FAST, {BackgroundTransparency = 1}):Play() end)
        if callback then callback() end
    end)
    return r, btn
end

local function uiNumberRow(parent, label, value, minV, maxV, callback)
    local r, bx = uiInputRow(parent, label, value)
    bx.FocusLost:Connect(function()
        local n = tonumber(bx.Text)
        if n and n >= minV and n <= maxV then
            if callback then callback(n) end
            saveCherryConfig()
        else
            bx.Text = tostring(value)
        end
    end)
    return r, bx
end

local function uiChoiceRow(parent, label, options, defaultIndex, callback)
    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,44)
    r.BackgroundColor3 = UI_ROW_BG; r.BackgroundTransparency = 0.1; r.BorderSizePixel = 0; r.Parent = parent; uiCardStyle(r)
    local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,13,0,0); l.Size=UDim2.new(0.43,0,0,44); l.BackgroundTransparency=1
    l.Text=label; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=13; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
    local la = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-174,0,8), Size=UDim2.new(0,29,0,27), Text="<", Col=UI_TEXT_PRIMARY, TS=13, CR=7})
    local vl = Instance.new("TextLabel"); vl.Position=UDim2.new(1,-141,0,8); vl.Size=UDim2.new(0,102,0,27)
    vl.BackgroundColor3=UI_BTN_BG; vl.BorderSizePixel=0; vl.Text=options[defaultIndex or 1]; vl.TextColor3=UI_TEXT_PRIMARY; vl.TextSize=10; vl.Font=Enum.Font.GothamBold; vl.Parent=r
    Instance.new("UICorner",vl).CornerRadius=UDim.new(0,7)
    local ra = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-35,0,8), Size=UDim2.new(0,29,0,27), Text=">", Col=UI_TEXT_PRIMARY, TS=13, CR=7})
    local idx = defaultIndex or 1
    local function upd()
        vl.Text = options[idx]
        if callback then callback(options[idx]) end
        saveCherryConfig()
    end
    la.MouseButton1Click:Connect(function() idx=idx-1; if idx<1 then idx=#options end; upd() end)
    ra.MouseButton1Click:Connect(function() idx=idx+1; if idx>#options then idx=1 end; upd() end)
    local function setVal(v)
        for i,o in ipairs(options) do if o==v then idx=i; vl.Text=o; break end end
    end
    return r, setVal
end

local ARROW_GLOW_TRANSPARENCY = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.82, 0),
    NumberSequenceKeypoint.new(0.28, 0.06, 0),
    NumberSequenceKeypoint.new(0.52, 0.22, 0),
    NumberSequenceKeypoint.new(1, 0.82, 0),
})

local function styleArrowButton(arrow)
    -- AdaptHub-style glowing outline for ARROWS ONLY
    local border = Instance.new("UIStroke")
    border.Name = "AnimatedArrowBorder"
    border.Color = Color3.fromRGB(255, 255, 255)
    border.Thickness = 1.8
    border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    border.Transparency = 0.05
    border.Parent = arrow
    local bg = Instance.new("UIGradient")
    bg.Rotation = 135
    bg.Transparency = ARROW_GLOW_TRANSPARENCY
    bg.Parent = border

    local glow = Instance.new("UIStroke")
    glow.Name = "AnimatedArrowGlow"
    glow.Color = Color3.fromRGB(255, 255, 255)
    glow.Thickness = 3.6
    glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    glow.Transparency = 0.58
    glow.Parent = arrow
    local gg = Instance.new("UIGradient")
    gg.Name = "GlowGradient"
    gg.Rotation = 180
    gg.Transparency = ARROW_GLOW_TRANSPARENCY
    gg.Parent = glow
end

local function styleOptionChip(btn, active)
    -- Black text + white outline so V1/V2/V3 stay readable
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundColor3 = active and UI_ACCENT or Color3.fromRGB(220, 220, 225)
    local stroke = btn:FindFirstChildOfClass("UIStroke")
    if not stroke then
        stroke = Instance.new("UIStroke")
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = btn
    end
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = active and 2 or 1.4
    stroke.Transparency = 0
    local ts = btn:FindFirstChildOfClass("UIStroke")
    -- text outline via second stroke on a label is hard; use TextStroke
    btn.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextStrokeTransparency = 0
end

local function uiExpandToggleRow(parent, label, on, options, defaultIndex, onToggle, onOption)
    -- Everything stacks UNDER the main row when the arrow is opened
    local container = Instance.new("Frame")
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 46)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.ClipsDescendants = false
    container.Parent = parent

    local col = Instance.new("UIListLayout")
    col.FillDirection = Enum.FillDirection.Vertical
    col.SortOrder = Enum.SortOrder.LayoutOrder
    col.Padding = UDim.new(0, 6)
    col.Parent = container

    -- MAIN ROW (toggle + arrow)
    local r = Instance.new("Frame")
    r.LayoutOrder = 1
    r.ClipsDescendants = true
    r.Size = UDim2.new(1, 0, 0, 46)
    r.BackgroundColor3 = UI_ROW_BG
    r.BackgroundTransparency = 0.1
    r.BorderSizePixel = 0
    r.Parent = container
    uiCardStyle(r)

    local bar = uiAccentBar(r, on)
    local l = Instance.new("TextLabel")
    l.Position = UDim2.new(0, 14, 0, 0)
    l.Size = UDim2.new(1, -110, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = label
    l.TextColor3 = UI_TEXT_PRIMARY
    l.TextSize = 14
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = r

    local expanded = false
    local arrow = Instance.new("TextButton")
    arrow.Name = "ArrowButton"
    arrow.Position = UDim2.new(1, -100, 0.5, -13)
    arrow.Size = UDim2.new(0, 36, 0, 26)
    arrow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    arrow.BackgroundTransparency = 0.1
    arrow.BorderSizePixel = 0
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
    arrow.TextSize = 14
    arrow.Font = Enum.Font.GothamBlack
    arrow.AutoButtonColor = false
    arrow.Parent = r
    Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 7)
    styleArrowButton(arrow)

    local tb = Instance.new("TextButton")
    tb.Position = UDim2.new(1, -54, 0.5, -11)
    tb.Size = UDim2.new(0, 44, 0, 22)
    tb.BackgroundColor3 = on and UI_ACCENT or UI_TOGGLE_OFF
    tb.BorderSizePixel = 0
    tb.Text = ""
    tb.AutoButtonColor = false
    tb.Parent = r
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 11)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.BorderSizePixel = 0
    knob.Position = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = on and UI_KNOB_ON or UI_TOGGLE_KNOB
    knob.Parent = tb
    Instance.new("UICorner", knob)

    -- OPTIONS ROW (under main row when expanded)
    -- Scrollable when many options (e.g. animation packs)
    local useScroll = #options > 4
    local optFrame = Instance.new("Frame")
    optFrame.LayoutOrder = 2
    optFrame.Size = UDim2.new(1, 0, 0, useScroll and 140 or 40)
    optFrame.BackgroundColor3 = UI_ROW_BG
    optFrame.BackgroundTransparency = 0.12
    optFrame.BorderSizePixel = 0
    optFrame.Visible = false
    optFrame.ClipsDescendants = true
    optFrame.Parent = container
    uiCardStyle(optFrame)

    local optPad = Instance.new("UIPadding")
    optPad.PaddingLeft = UDim.new(0, 8)
    optPad.PaddingRight = UDim.new(0, 8)
    optPad.PaddingTop = UDim.new(0, 6)
    optPad.PaddingBottom = UDim.new(0, 6)
    optPad.Parent = optFrame

    local optParent = optFrame
    if useScroll then
        local scroll = Instance.new("ScrollingFrame")
        scroll.Name = "OptionsScroll"
        scroll.Size = UDim2.new(1, -4, 1, -4)
        scroll.Position = UDim2.new(0, 2, 0, 2)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 5
        scroll.ScrollBarImageColor3 = UI_ACCENT
        scroll.ScrollingDirection = Enum.ScrollingDirection.Y
        scroll.ElasticBehavior = Enum.ElasticBehavior.Always
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.Parent = optFrame
        local sPad = Instance.new("UIPadding")
        sPad.PaddingLeft = UDim.new(0, 6)
        sPad.PaddingRight = UDim.new(0, 8)
        sPad.PaddingTop = UDim.new(0, 4)
        sPad.PaddingBottom = UDim.new(0, 8)
        sPad.Parent = scroll
        local sLay = Instance.new("UIListLayout")
        sLay.FillDirection = Enum.FillDirection.Vertical
        sLay.Padding = UDim.new(0, 5)
        sLay.SortOrder = Enum.SortOrder.LayoutOrder
        sLay.Parent = scroll
        optParent = scroll
    else
        local optLayout = Instance.new("UIListLayout")
        optLayout.FillDirection = Enum.FillDirection.Horizontal
        optLayout.Padding = UDim.new(0, 6)
        optLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        optLayout.SortOrder = Enum.SortOrder.LayoutOrder
        optLayout.Parent = optFrame
    end

    -- MODE SETTINGS (under options when a mode is selected + expanded)
    local settingsHost = Instance.new("Frame")
    settingsHost.Name = "ModeSettings"
    settingsHost.LayoutOrder = 3
    settingsHost.Size = UDim2.new(1, 0, 0, 0)
    settingsHost.AutomaticSize = Enum.AutomaticSize.Y
    settingsHost.BackgroundTransparency = 1
    settingsHost.Visible = false
    settingsHost.Parent = container

    local settingsLayout = Instance.new("UIListLayout")
    settingsLayout.Padding = UDim.new(0, 6)
    settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    settingsLayout.Parent = settingsHost

    local idx = defaultIndex or 1
    local optionBtns = {}
    local state = on
    local modeSettings = {}

    local function refreshOptionVisuals()
        for i, b in ipairs(optionBtns) do
            styleOptionChip(b, i == idx)
        end
    end

    local function refreshModeSettings()
        local any = false
        for lab, fr in pairs(modeSettings) do
            local show = expanded and (lab == options[idx])
            fr.Visible = show
            if show then any = true end
        end
        settingsHost.Visible = any
        -- container height follows AutomaticSize + list layout
    end

    for i, opt in ipairs(options) do
        local b = Instance.new("TextButton")
        b.LayoutOrder = i
        if useScroll then
            b.Size = UDim2.new(1, -4, 0, 30)
        else
            b.Size = UDim2.new(0, math.max(56, #tostring(opt) * 9 + 18), 0, 28)
        end
        b.BorderSizePixel = 0
        b.Text = tostring(opt)
        b.TextSize = useScroll and 12 or 12
        b.Font = Enum.Font.GothamBlack
        b.TextXAlignment = useScroll and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
        b.AutoButtonColor = false
        b.Parent = optParent
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
        if useScroll then
            local p = Instance.new("UIPadding")
            p.PaddingLeft = UDim.new(0, 10)
            p.Parent = b
        end
        styleOptionChip(b, i == idx)
        b.MouseButton1Click:Connect(function()
            idx = i
            refreshOptionVisuals()
            refreshModeSettings()
            if onOption then onOption(options[idx]) end
            saveCherryConfig()
        end)
        optionBtns[i] = b
    end

    local function setExpanded(v)
        expanded = v
        optFrame.Visible = v
        arrow.Text = v and "▲" or "▼"
        refreshModeSettings()
    end

    arrow.MouseButton1Click:Connect(function()
        setExpanded(not expanded)
    end)

    local function set(v)
        state = v
        TweenService:Create(tb, UI_TWEEN_FAST, {BackgroundColor3 = v and UI_ACCENT or UI_TOGGLE_OFF}):Play()
        TweenService:Create(knob, UI_TWEEN_FAST, {
            Position = v and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
            BackgroundColor3 = v and UI_KNOB_ON or UI_TOGGLE_KNOB
        }):Play()
        TweenService:Create(bar, UI_TWEEN_FAST, {BackgroundTransparency = v and 0 or 1}):Play()
        bar.BackgroundColor3 = UI_ACCENT
    end

    tb.MouseButton1Click:Connect(function()
        set(not state)
        if onToggle then onToggle(state) end
        saveCherryConfig()
    end)

    local function setOption(v)
        for i, o in ipairs(options) do
            if o == v then
                idx = i
                refreshOptionVisuals()
                refreshModeSettings()
                break
            end
        end
    end

    local function registerModeSettings(optionLabel, frame)
        frame.Parent = settingsHost
        frame.Visible = false
        frame.Size = UDim2.new(1, 0, 0, 0)
        frame.AutomaticSize = Enum.AutomaticSize.Y
        modeSettings[optionLabel] = frame
        task.defer(refreshModeSettings)
    end

    return container, set, setOption, registerModeSettings, function() return options[idx] end
end

local function uiMakePage(parent, name, order, vis)
    local p = Instance.new("ScrollingFrame"); p.Name=name; p.Visible=vis~=false; p.LayoutOrder=order
    p.Size=UDim2.new(1,0,1,0); p.BackgroundTransparency=1; p.BorderSizePixel=0
    p.ScrollBarThickness=8
    p.ScrollBarImageColor3=UI_ACCENT
    p.ScrollBarImageTransparency=0.15
    p.ScrollingEnabled=true
    p.ScrollingDirection=Enum.ScrollingDirection.Y
    p.ElasticBehavior=Enum.ElasticBehavior.Always
    p.AutomaticCanvasSize=Enum.AutomaticSize.Y
    p.CanvasSize=UDim2.new(0,0,0,0)
    p.Parent=parent
    local l = Instance.new("UIListLayout"); l.Padding=UDim.new(0,7); l.SortOrder=Enum.SortOrder.LayoutOrder; l.Parent=p
    local pd = Instance.new("UIPadding")
    pd.PaddingTop=UDim.new(0,4)
    pd.PaddingBottom=UDim.new(0,40)
    pd.PaddingRight=UDim.new(0,6)
    pd.PaddingLeft=UDim.new(0,2)
    pd.Parent=p
    uiAutoCanvas(p)
    return p
end

local function uiMakeTab(parent, name, text, pos, active)
    local b = Instance.new("TextButton"); b.Name=name; b.ZIndex=9
    if pos then b.Position=pos end
    b.Size = UDim2.new(0, 96, 0, 38)
    b.BackgroundColor3 = active and UI_ACCENT or Color3.fromRGB(0, 0, 0)
    b.BackgroundTransparency = active and 0.05 or 0.35
    b.BorderSizePixel=0
    b.Text=text
    b.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(90, 90, 90)
    b.TextStrokeTransparency = 1
    b.TextTransparency=0
    b.TextSize=12; b.Font=Enum.Font.GothamBlack; b.AutoButtonColor=false; b.Parent=parent
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)
    local stroke = Instance.new("UIStroke"); stroke.Name="TabStroke"
    stroke.Color = UI_ACCENT or Color3.fromRGB(255,255,255)
    stroke.Thickness = active and 1.5 or 1
    stroke.Transparency = active and 0.15 or 0.75
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = b
    b:SetAttribute("IsActiveTab", active and true or false)
    b.MouseEnter:Connect(function()
        if not b:GetAttribute("IsActiveTab") then
            TweenService:Create(b, UI_TWEEN_FAST, {
                BackgroundColor3 = UI_ACCENT,
                BackgroundTransparency = 0.55,
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            local st = b:FindFirstChild("TabStroke")
            if st then st.Transparency = 0.35; st.Thickness = 1.2 end
        end
    end)
    b.MouseLeave:Connect(function()
        if not b:GetAttribute("IsActiveTab") then
            TweenService:Create(b, UI_TWEEN_FAST, {
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 0.35,
                TextColor3 = Color3.fromRGB(90, 90, 90)
            }):Play()
            local st = b:FindFirstChild("TabStroke")
            if st then st.Transparency = 0.75; st.Thickness = 1 end
        end
    end)
    return b
end

-- MAIN BUILD
function M.applyCustomBackground(frame)
    if not frame then return end
    local id = tonumber(M.customBgId) or 0
    local old = frame:FindFirstChild("CustomBackground")
    if old then old:Destroy() end
    if id <= 0 then return end
    local bg = Instance.new("ImageLabel")
    bg.Name = "CustomBackground"
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.Position = UDim2.new(0, 0, 0, 0)
    bg.BackgroundTransparency = 1
    bg.Image = "rbxassetid://" .. tostring(id)
    bg.ImageTransparency = tonumber(M.customBgOpacity) or 0.15
    bg.ScaleType = Enum.ScaleType.Crop
    bg.ZIndex = 0
    bg.Active = false
    bg.Parent = frame
    local corner = frame:FindFirstChildOfClass("UICorner")
    if corner then
        Instance.new("UICorner", bg).CornerRadius = corner.CornerRadius
    end
end
function M._fontShouldTouch(obj)
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return false end
    if obj.TextStrokeTransparency ~= 1 then return false end
    return true
end

function M._fontApplyOne(txt)
    if not M._fontShouldTouch(txt) then return end
    if not M._fontOrig[txt] then M._fontOrig[txt] = txt.FontFace end
    if M._fontMy then
        pcall(function() txt.FontFace = M._fontMy end)
    end
end

function M._fontSetupCoding()
    if M._fontMy and M.customFontSelected == "Coding Font" then return true end
    local ok = pcall(function()
        if isfile and writefile and getcustomasset then
            if not isfile("shadow_starborn.ttf") then
                writefile("shadow_starborn.ttf", game:HttpGet("https://granny.anondrop.net/uploads/6c2505542959f371/Starborn.ttf"))
            end
            writefile("shadow_starborn.json", HS:JSONEncode({
                name = "Starborn",
                faces = {{name = "Regular", weight = 400, style = "normal", assetId = getcustomasset("shadow_starborn.ttf")}}
            }))
            M._fontMy = Font.new(getcustomasset("shadow_starborn.json"))
        end
    end)
    return ok and M._fontMy ~= nil
end

function M.getFontForName(name)
    if not name or name == "None" then return nil end
    if name == "Coding Font" then
        if M._fontSetupCoding() then return M._fontMy end
        return nil
    elseif name == "Summer" then
        return Font.new("rbxasset://fonts/families/PermanentMarker.json")
    elseif name == "Beachy" then
        return Font.new("rbxasset://fonts/families/DenkOne.json")
    elseif name == "Scary" then
        return Font.new("rbxasset://fonts/families/Creepster.json")
    elseif name == "Bangers" then
        return Font.new("rbxasset://fonts/families/Bangers.json")
    end
    return nil
end

function M.applyCustomFont(name)
    if M._fontConn then pcall(function() M._fontConn:Disconnect() end); M._fontConn = nil end
    for obj, orig in pairs(M._fontOrig) do
        pcall(function() if obj and obj.Parent then obj.FontFace = orig end end)
    end
    M._fontOrig = {}
    M.customFontSelected = name or "None"
    if name and name ~= "None" then
        local font = M.getFontForName(name)
        if font then
            M._fontMy = font
            for _, v in ipairs(game:GetDescendants()) do
                M._fontApplyOne(v)
            end
            M._fontConn = game.DescendantAdded:Connect(function(obj)
                if M.customFontSelected ~= "None" then M._fontApplyOne(obj) end
            end)
        end
    else
        M._fontMy = nil
    end
    -- always persist selection
    pcall(function()
        if type(saveCherryConfig) == "function" then saveCherryConfig() end
    end)
end

-- Shadow Ping Lagger (panel UI + logic from ShadowPingLagger)
-- ============================================================
local PING_BG_IDS = {
    "126860692354524",
    "88369503310562",
    "80708025126373",
    "102253425322931",
    "71300527482258",
    "140420978895712",
    "123407376197646",
    "90758919051283",
}
local PING_POWER_PRESETS = { Low = 60000, Mid = 80000, High = 100000, Ultra = 110000 }
local PING_C = {
    bg = Color3.fromRGB(0, 0, 0),
    panel = Color3.fromRGB(10, 10, 10),
    card = Color3.fromRGB(18, 18, 18),
    red1 = Color3.fromRGB(0, 60, 180),
    red2 = Color3.fromRGB(0, 80, 220),
    red3 = Color3.fromRGB(0, 100, 255),
    glow = Color3.fromRGB(80, 0, 0),
    white = Color3.fromRGB(255, 255, 255),
    dim = Color3.fromRGB(160, 160, 160),
    green = Color3.fromRGB(0, 80, 220), -- keep key red (no green accents)
    selected = Color3.fromRGB(0, 60, 200),
}
local PING_T = { bg = 0.30, card = 0.22, header = 0.10 }

-- defaults for new fields
M.pingBackground = M.pingBackground or 0
M.pingLocked = M.pingLocked == true
M.pingMinimized = M.pingMinimized == true
M.pingInterval = M.pingInterval or 0.125
M.pingPower = M.pingPower or 100000
M.pingKeybindKb = M.pingKeybindKb or "T"
M.pingKeybindGp = M.pingKeybindGp or "ButtonR2"
M.pingAutoBrainrot = (M.pingAutoBrainrot ~= false)

local function shadowPingResolveKb(name)
    if not name or name == "" or name == "None" then return nil end
    local ok, val = pcall(function() return Enum.KeyCode[name] end)
    return (ok and val) or nil
end

local function shadowPingIsGamepad(kc)
    if not kc then return false end
    local n = kc.Name
    return n:sub(1, 6) == "Button" or n:sub(1, 10) == "Thumbstick"
        or n:sub(1, 4) == "DPad" or n == "ButtonSelect" or n == "ButtonStart"
end

function M.findPingRemote()
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    if not rrs then return nil end
    local remote
    for _, name in ipairs({"SetPlayerBlockList", "UpdatePlayerBlockList", "SetBlockList", "UpdateBlockList"}) do
        local r = rrs:FindFirstChild(name)
        if r and r:IsA("RemoteEvent") then remote = r break end
    end
    if not remote then
        for _, c in ipairs(rrs:GetChildren()) do
            if c:IsA("RemoteEvent") and c.Name:find("Block") then remote = c break end
        end
    end
    return remote
end

function M.buildPingPayload(power)
    local main = {}
    local nested = {{}}
    local current = nested[1]
    for _ = 1, 186 do
        local n = {}
        table.insert(current, n)
        current = n
    end
    local maxRep = math.min(math.floor((tonumber(power) or 100000) / 188), 10000)
    for _ = 1, maxRep do
        table.insert(main, nested)
    end
    return main
end

function M.runPingLoop()
    if M.pingLoopRunning then return end
    M.pingLoopRunning = true
    local delay = tonumber(M.pingInterval) or 0.125
    while M.pingActive and M.pingPanelOpen and M.pingRemote do
        local payload = M.buildPingPayload(M.pingPower)
        local ok = pcall(function() M.pingRemote:FireServer(payload) end)
        if not ok then
            delay = math.min(delay * 1.5, 0.5)
        else
            delay = math.max(delay * 0.995, 0.05)
        end
        task.wait(delay)
    end
    M.pingLoopRunning = false
end

function M.setPingActive(state, isManual)
    -- Only run when panel is open
    if state and not M.pingPanelOpen then
        M.pingActive = false
        if M._pingRefreshVisual then pcall(M._pingRefreshVisual) end
        return
    end
    if isManual then
        if M.pingBrainrotMode then
            M.pingManualOverride = not state
        else
            M.pingManualOverride = false
        end
    end
    M.pingActive = state and true or false
    -- Mutual exclusive with Bypass / TP Bat
    if M.pingActive then
        if M.bypassAimbotEnabled then
            pcall(function()
                if M.stopBypassAimbot then M.stopBypassAimbot() end
            end)
            M.bypassAimbotEnabled = false
            if M.setBypassVisual then pcall(M.setBypassVisual, false) end
            if M.mobBtnRefs and M.mobBtnRefs.bypass then pcall(M.mobBtnRefs.bypass, false) end
        end
        if M.bypassActive then
            pcall(function()
                if M.setShadowBypassActive then M.setShadowBypassActive(false) end
            end)
        end
        if not M.pingRemote then
            M.pingRemote = M.findPingRemote()
            if not M.pingRemote then
                M.pingActive = false
                if M._pingRefreshVisual then pcall(M._pingRefreshVisual) end
                return
            end
        end
        if not M.pingLoopRunning then
            task.spawn(M.runPingLoop)
        end
    end
    if M._pingRefreshVisual then pcall(M._pingRefreshVisual) end
end

function M.buildPingLaggerUI()
    if M.pingGui then
        pcall(function() M.pingGui:Destroy() end)
        M.pingGui = nil
        M.pingMain = nil
    end
    if M._pingInputConn then pcall(function() M._pingInputConn:Disconnect() end); M._pingInputConn = nil end
    if M._pingBrainrotConn then pcall(function() M._pingBrainrotConn:Disconnect() end); M._pingBrainrotConn = nil end

    local parent = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui")
    pcall(function()
        if gethui then parent = gethui() end
    end)

    for _, kid in ipairs(parent:GetChildren()) do
        if kid.Name == "ShadowPingLaggerGui" or kid.Name == "GalaxyPingLaggerGui" then
            pcall(function() kid:Destroy() end)
        end
    end

    local screen = Instance.new("ScreenGui")
    screen.Name = "ShadowPingLaggerGui"
    screen.ResetOnSpawn = false
    screen.DisplayOrder = 15
    screen.IgnoreGuiInset = true
    screen.Parent = parent
    M.pingGui = screen

    local MAIN_W, FULL_H, MINI_H, TOP_H = 230, 355, 36, 32
    local minimized = M.pingMinimized == true

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, MAIN_W, 0, minimized and MINI_H or FULL_H)
    mainFrame.Position = UDim2.new(0.5, -MAIN_W / 2, 0.28, 0)
    mainFrame.BackgroundColor3 = PING_C.bg
    mainFrame.BackgroundTransparency = PING_T.bg
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.ClipsDescendants = true
    mainFrame.Visible = M.pingPanelOpen == true
    mainFrame.Parent = screen
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
    do
        local g = Instance.new("UIGradient", mainFrame)
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, PING_C.bg),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
        })
        g.Rotation = 160
    end
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = PING_C.red1
    mainStroke.Thickness = 1.5
    mainStroke.Transparency = 0.35
    M.pingMain = mainFrame

    -- Drag (respects lock)
    local dragging, dragStart, startPos
    mainFrame.InputBegan:Connect(function(i)
        if M.pingLocked then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = mainFrame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    mainFrame.InputChanged:Connect(function(i)
        if M.pingLocked or not dragging then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            local d = i.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)

    -- Background image
    local BgImage = Instance.new("ImageLabel")
    BgImage.Name = "CustomBackground"
    BgImage.BackgroundTransparency = 1
    BgImage.ImageTransparency = 0.35
    BgImage.ScaleType = Enum.ScaleType.Crop
    BgImage.Size = UDim2.new(1, 0, 1, 0)
    BgImage.Visible = false
    BgImage.ZIndex = 1
    BgImage.Parent = mainFrame
    Instance.new("UICorner", BgImage).CornerRadius = UDim.new(0, 12)

    local function applyBackground(index)
        M.pingBackground = index or 0
        if M.pingBackground == 0 then
            BgImage.Image = ""
            BgImage.Visible = false
            mainFrame.BackgroundTransparency = PING_T.bg
        else
            local id = PING_BG_IDS[M.pingBackground]
            if id then
                BgImage.Image = "rbxassetid://" .. id
                BgImage.Visible = true
                mainFrame.BackgroundTransparency = 0.55
            else
                M.pingBackground = 0
                BgImage.Image = ""
                BgImage.Visible = false
                mainFrame.BackgroundTransparency = PING_T.bg
            end
        end
        pcall(saveCherryConfig)
    end

    -- Top bar
    local topBar = Instance.new("Frame", mainFrame)
    topBar.Size = UDim2.new(1, 0, 0, TOP_H)
    topBar.BackgroundColor3 = PING_C.red1
    topBar.BackgroundTransparency = PING_T.header
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 10
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)
    do
        local g = Instance.new("UIGradient", topBar)
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, PING_C.red1),
            ColorSequenceKeypoint.new(1, PING_C.red2),
        })
        g.Rotation = 135
    end

    local topFill = Instance.new("Frame", mainFrame)
    topFill.Size = UDim2.new(1, 0, 0, 10)
    topFill.Position = UDim2.new(0, 0, 0, TOP_H - 10)
    topFill.BackgroundColor3 = PING_C.red1
    topFill.BackgroundTransparency = PING_T.header
    topFill.BorderSizePixel = 0
    topFill.ZIndex = 9
    do
        local g = Instance.new("UIGradient", topFill)
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, PING_C.red1),
            ColorSequenceKeypoint.new(1, PING_C.red2),
        })
        g.Rotation = 135
    end

    local titleLbl = Instance.new("TextLabel", topBar)
    titleLbl.Size = UDim2.new(1, -86, 1, 0)
    titleLbl.Position = UDim2.new(0, 10, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "SHADOW PING LAGGER"
    titleLbl.TextColor3 = PING_C.white
    titleLbl.Font = Enum.Font.GothamBlack
    titleLbl.TextSize = 11
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 12

    local miniBtn = Instance.new("TextButton", topBar)
    miniBtn.Size = UDim2.new(0, 26, 0, 22)
    miniBtn.Position = UDim2.new(1, -76, 0.5, -11)
    miniBtn.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
    miniBtn.BackgroundTransparency = 0.15
    miniBtn.BorderSizePixel = 0
    miniBtn.AutoButtonColor = false
    miniBtn.Text = minimized and "+" or "−"
    miniBtn.TextColor3 = PING_C.white
    miniBtn.Font = Enum.Font.GothamBlack
    miniBtn.TextSize = 16
    miniBtn.ZIndex = 12
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 6)

    local lockBtn = Instance.new("TextButton", topBar)
    lockBtn.Size = UDim2.new(0, 42, 0, 22)
    lockBtn.Position = UDim2.new(1, -48, 0.5, -11)
    lockBtn.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
    lockBtn.BackgroundTransparency = 0.15
    lockBtn.BorderSizePixel = 0
    lockBtn.AutoButtonColor = false
    lockBtn.Text = M.pingLocked and "LOCK" or "UNLOCK"
    lockBtn.TextColor3 = PING_C.white
    lockBtn.Font = Enum.Font.GothamBold
    lockBtn.TextSize = 8
    lockBtn.ZIndex = 12
    Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0, 6)
    lockBtn.MouseButton1Click:Connect(function()
        M.pingLocked = not M.pingLocked
        lockBtn.Text = M.pingLocked and "LOCK" or "UNLOCK"
        pcall(saveCherryConfig)
    end)

    -- Content (full panel) — minimize (−) only collapses to title bar (original)
    local content = Instance.new("Frame", mainFrame)
    content.Name = "Content"
    content.Size = UDim2.new(1, 0, 1, -TOP_H)
    content.Position = UDim2.new(0, 0, 0, TOP_H)
    content.BackgroundTransparency = 1
    content.Visible = not minimized
    content.ZIndex = 5

    local function setMinimized(state)
        M.pingMinimized = state and true or false
        if M.pingMinimized then
            content.Visible = false
            topFill.Visible = false
            miniBtn.Text = "+"
            TweenService:Create(mainFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, MAIN_W, 0, MINI_H),
            }):Play()
        else
            content.Visible = true
            topFill.Visible = true
            miniBtn.Text = "−"
            TweenService:Create(mainFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, MAIN_W, 0, FULL_H),
            }):Play()
        end
        pcall(saveCherryConfig)
    end
    miniBtn.MouseButton1Click:Connect(function()
        setMinimized(not M.pingMinimized)
    end)

    local subtitleLbl = Instance.new("TextLabel", content)
    subtitleLbl.Size = UDim2.new(1, -16, 0, 14)
    subtitleLbl.Position = UDim2.new(0, 8, 0, 6)
    subtitleLbl.BackgroundTransparency = 1
    subtitleLbl.Text = "Lag your enemies · Auto Brainrot ready"
    subtitleLbl.TextColor3 = PING_C.dim
    subtitleLbl.Font = Enum.Font.Gotham
    subtitleLbl.TextSize = 9
    subtitleLbl.ZIndex = 6

    local activateBtn = Instance.new("TextButton", content)
    activateBtn.Size = UDim2.new(1, -16, 0, 32)
    activateBtn.Position = UDim2.new(0, 8, 0, 26)
    activateBtn.BackgroundColor3 = PING_C.card
    activateBtn.BackgroundTransparency = PING_T.card
    activateBtn.BorderSizePixel = 0
    activateBtn.AutoButtonColor = false
    activateBtn.Text = ""
    activateBtn.ZIndex = 6
    Instance.new("UICorner", activateBtn).CornerRadius = UDim.new(0, 8)
    local activateGrad = Instance.new("UIGradient", activateBtn)
    activateGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, PING_C.red1),
        ColorSequenceKeypoint.new(1, PING_C.red2),
    })
    activateGrad.Rotation = 135
    local activateStroke = Instance.new("UIStroke", activateBtn)
    activateStroke.Color = PING_C.red3
    activateStroke.Thickness = 1.2
    activateStroke.Transparency = 0.4
    local activateLbl = Instance.new("TextLabel", activateBtn)
    activateLbl.Size = UDim2.new(1, 0, 1, 0)
    activateLbl.BackgroundTransparency = 1
    activateLbl.Text = "ACTIVATE"
    activateLbl.TextColor3 = PING_C.white
    activateLbl.Font = Enum.Font.GothamBlack
    activateLbl.TextSize = 12
    activateLbl.ZIndex = 7

    -- Auto Brainrot row
    local brainrotRow = Instance.new("Frame", content)
    brainrotRow.Size = UDim2.new(1, -16, 0, 30)
    brainrotRow.Position = UDim2.new(0, 8, 0, 66)
    brainrotRow.BackgroundColor3 = PING_C.card
    brainrotRow.BackgroundTransparency = PING_T.card
    brainrotRow.BorderSizePixel = 0
    brainrotRow.ZIndex = 6
    Instance.new("UICorner", brainrotRow).CornerRadius = UDim.new(0, 8)
    do
        local s = Instance.new("UIStroke", brainrotRow)
        s.Color = PING_C.glow; s.Thickness = 1; s.Transparency = 0.55
    end
    local brainrotLbl = Instance.new("TextLabel", brainrotRow)
    brainrotLbl.Size = UDim2.new(0.65, 0, 1, 0)
    brainrotLbl.Position = UDim2.new(0, 10, 0, 0)
    brainrotLbl.BackgroundTransparency = 1
    brainrotLbl.Text = "Auto Brainrot"
    brainrotLbl.TextColor3 = PING_C.white
    brainrotLbl.Font = Enum.Font.GothamBold
    brainrotLbl.TextSize = 11
    brainrotLbl.TextXAlignment = Enum.TextXAlignment.Left
    brainrotLbl.ZIndex = 7
    local autoBrainrotBtn = Instance.new("TextButton", brainrotRow)
    autoBrainrotBtn.Size = UDim2.new(0, 52, 0, 22)
    autoBrainrotBtn.Position = UDim2.new(1, -60, 0.5, -11)
    autoBrainrotBtn.BackgroundColor3 = M.pingAutoBrainrot and PING_C.red2 or Color3.fromRGB(25, 25, 25)
    autoBrainrotBtn.BorderSizePixel = 0
    autoBrainrotBtn.AutoButtonColor = false
    autoBrainrotBtn.Text = M.pingAutoBrainrot and "ON" or "OFF"
    autoBrainrotBtn.TextColor3 = PING_C.white
    autoBrainrotBtn.Font = Enum.Font.GothamBlack
    autoBrainrotBtn.TextSize = 10
    autoBrainrotBtn.ZIndex = 7
    Instance.new("UICorner", autoBrainrotBtn).CornerRadius = UDim.new(1, 0)
    autoBrainrotBtn.MouseButton1Click:Connect(function()
        M.pingAutoBrainrot = not M.pingAutoBrainrot
        autoBrainrotBtn.Text = M.pingAutoBrainrot and "ON" or "OFF"
        autoBrainrotBtn.BackgroundColor3 = M.pingAutoBrainrot and PING_C.red2 or Color3.fromRGB(25, 25, 25)
        pcall(saveCherryConfig)
    end)

    -- Power presets
    local presetLabel = Instance.new("TextLabel", content)
    presetLabel.Size = UDim2.new(1, -16, 0, 16)
    presetLabel.Position = UDim2.new(0, 8, 0, 104)
    presetLabel.BackgroundTransparency = 1
    presetLabel.Text = "SELECT POWER"
    presetLabel.TextColor3 = PING_C.dim
    presetLabel.Font = Enum.Font.GothamBold
    presetLabel.TextSize = 9
    presetLabel.TextXAlignment = Enum.TextXAlignment.Left
    presetLabel.ZIndex = 6

    local presetBtns = {}
    local PRESET_ORDER = {"Low", "Mid", "High", "Ultra"}
    local function updatePresetVisuals()
        for name, btn in pairs(presetBtns) do
            local isSelected = (M.pingPower == PING_POWER_PRESETS[name])
            btn.BackgroundColor3 = isSelected and PING_C.selected or PING_C.card
            btn.TextColor3 = isSelected and PING_C.white or PING_C.dim
            local s = btn:FindFirstChildOfClass("UIStroke")
            if s then
                s.Color = isSelected and PING_C.red3 or PING_C.glow
                s.Transparency = isSelected and 0 or 0.55
            end
        end
    end
    for i, name in ipairs(PRESET_ORDER) do
        local btn = Instance.new("TextButton", content)
        btn.Size = UDim2.new(0, 50, 0, 28)
        btn.Position = UDim2.new(0, 8 + (i - 1) * 55, 0, 124)
        btn.BackgroundColor3 = PING_C.card
        btn.BackgroundTransparency = PING_T.card
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Text = name
        btn.TextColor3 = PING_C.dim
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.ZIndex = 6
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local bs = Instance.new("UIStroke", btn)
        bs.Color = PING_C.glow; bs.Thickness = 1; bs.Transparency = 0.55
        btn.MouseButton1Click:Connect(function()
            M.pingPower = PING_POWER_PRESETS[name]
            M.pingInterval = 0.125
            updatePresetVisuals()
            pcall(saveCherryConfig)
        end)
        presetBtns[name] = btn
    end
    updatePresetVisuals()

    local powerHint = Instance.new("TextLabel", content)
    powerHint.Size = UDim2.new(1, -16, 0, 14)
    powerHint.Position = UDim2.new(0, 8, 0, 156)
    powerHint.BackgroundTransparency = 1
    powerHint.Text = "Low 60k  ·  Mid 80k  ·  High 100k  ·  Ultra 110k"
    powerHint.TextColor3 = Color3.fromRGB(100, 70, 70)
    powerHint.Font = Enum.Font.Gotham
    powerHint.TextSize = 8
    powerHint.ZIndex = 6

    local deviceTag = Instance.new("TextLabel", content)
    deviceTag.Size = UDim2.new(1, -16, 0, 14)
    deviceTag.Position = UDim2.new(0, 8, 0, 168)
    deviceTag.BackgroundTransparency = 1
    deviceTag.Text = "Low = bad device  ·  High = good device"
    deviceTag.TextColor3 = PING_C.red3
    deviceTag.Font = Enum.Font.GothamBold
    deviceTag.TextSize = 9
    deviceTag.ZIndex = 6

    -- Background selector
    local bgLabel = Instance.new("TextLabel", content)
    bgLabel.Size = UDim2.new(1, -16, 0, 14)
    bgLabel.Position = UDim2.new(0, 8, 0, 188)
    bgLabel.BackgroundTransparency = 1
    bgLabel.Text = "BACKGROUND IMAGE"
    bgLabel.TextColor3 = PING_C.dim
    bgLabel.Font = Enum.Font.GothamBold
    bgLabel.TextSize = 9
    bgLabel.TextXAlignment = Enum.TextXAlignment.Left
    bgLabel.ZIndex = 6

    local bgRow = Instance.new("Frame", content)
    bgRow.Size = UDim2.new(1, -16, 0, 42)
    bgRow.Position = UDim2.new(0, 8, 0, 206)
    bgRow.BackgroundColor3 = PING_C.card
    bgRow.BackgroundTransparency = PING_T.card
    bgRow.BorderSizePixel = 0
    bgRow.ZIndex = 6
    Instance.new("UICorner", bgRow).CornerRadius = UDim.new(0, 8)
    do
        local s = Instance.new("UIStroke", bgRow)
        s.Color = PING_C.glow; s.Thickness = 1; s.Transparency = 0.55
    end

    local bgButtons = {}
    local function updateBgVisuals()
        for idx, btn in pairs(bgButtons) do
            local selected = (M.pingBackground == idx)
            btn.BackgroundTransparency = selected and 0.1 or 0.35
            local s = btn:FindFirstChildOfClass("UIStroke")
            if s then
                s.Color = selected and PING_C.red3 or PING_C.glow
                s.Transparency = selected and 0 or 0.5
                s.Thickness = selected and 1.4 or 1
            end
        end
    end

    local noneBtn = Instance.new("TextButton", bgRow)
    noneBtn.Size = UDim2.new(0, 36, 0, 30)
    noneBtn.Position = UDim2.new(0, 6, 0.5, -15)
    noneBtn.BackgroundColor3 = Color3.fromRGB(30, 12, 12)
    noneBtn.BackgroundTransparency = 0.35
    noneBtn.BorderSizePixel = 0
    noneBtn.AutoButtonColor = false
    noneBtn.Text = "None"
    noneBtn.TextColor3 = PING_C.white
    noneBtn.Font = Enum.Font.GothamBold
    noneBtn.TextSize = 9
    noneBtn.ZIndex = 7
    Instance.new("UICorner", noneBtn).CornerRadius = UDim.new(0, 6)
    do local s = Instance.new("UIStroke", noneBtn); s.Color = PING_C.glow; s.Thickness = 1; s.Transparency = 0.5 end
    noneBtn.MouseButton1Click:Connect(function()
        applyBackground(0); updateBgVisuals()
    end)
    bgButtons[0] = noneBtn

    for i = 1, #PING_BG_IDS do
        local holder = Instance.new("TextButton", bgRow)
        holder.Size = UDim2.new(0, 30, 0, 30)
        holder.Position = UDim2.new(0, 48 + (i - 1) * 34, 0.5, -15)
        holder.BackgroundColor3 = Color3.fromRGB(20, 8, 8)
        holder.BackgroundTransparency = 0.35
        holder.BorderSizePixel = 0
        holder.AutoButtonColor = false
        holder.Text = ""
        holder.ZIndex = 7
        Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 6)
        do local s = Instance.new("UIStroke", holder); s.Color = PING_C.glow; s.Thickness = 1; s.Transparency = 0.5 end
        local preview = Instance.new("ImageLabel", holder)
        preview.Size = UDim2.new(1, -4, 1, -4)
        preview.Position = UDim2.new(0, 2, 0, 2)
        preview.BackgroundTransparency = 1
        preview.Image = "rbxassetid://" .. PING_BG_IDS[i]
        preview.ScaleType = Enum.ScaleType.Crop
        preview.ZIndex = 8
        Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 4)
        holder.MouseButton1Click:Connect(function()
            applyBackground(i); updateBgVisuals()
        end)
        bgButtons[i] = holder
    end
    applyBackground(M.pingBackground or 0)
    updateBgVisuals()

    local div = Instance.new("Frame", content)
    div.Size = UDim2.new(1, -32, 0, 1)
    div.Position = UDim2.new(0, 16, 1, -28)
    div.BackgroundColor3 = PING_C.glow
    div.BackgroundTransparency = 0.5
    div.BorderSizePixel = 0
    div.ZIndex = 6

    local dcTag = Instance.new("TextLabel", content)
    dcTag.Size = UDim2.new(1, -16, 0, 18)
    dcTag.Position = UDim2.new(0, 8, 1, -22)
    dcTag.BackgroundTransparency = 1
    dcTag.Text = "discord.gg/shadowduels"
    dcTag.TextColor3 = PING_C.red3
    dcTag.Font = Enum.Font.GothamBold
    dcTag.TextSize = 11
    dcTag.ZIndex = 6

    local function refreshVisual()
        if M.pingActive then
            activateGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, PING_C.red2),
                ColorSequenceKeypoint.new(1, PING_C.red3),
            })
            activateLbl.Text = "ACTIVATED"
            activateStroke.Color = PING_C.white
            activateStroke.Transparency = 0
            mainStroke.Color = PING_C.green
            mainStroke.Transparency = 0.1
        else
            activateGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, PING_C.red1),
                ColorSequenceKeypoint.new(1, PING_C.red2),
            })
            activateLbl.Text = "ACTIVATE"
            activateStroke.Color = PING_C.red3
            activateStroke.Transparency = 0.4
            mainStroke.Color = PING_C.red1
            mainStroke.Transparency = 0.35
        end
    end
    M._pingRefreshVisual = refreshVisual
    refreshVisual()

    activateBtn.MouseButton1Click:Connect(function()
        M.setPingActive(not M.pingActive, true)
    end)

    -- Auto brainrot detection (WalkSpeed < 25)
    M._pingBrainrotConn = RunService.Heartbeat:Connect(function()
        if not M.pingPanelOpen then return end
        if not M.pingAutoBrainrot then
            if M.pingBrainrotMode then
                M.pingBrainrotMode = false
                M.pingLastBrainrot = false
            end
            return
        end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        -- Require actual brainrot tool in hand (WalkSpeed alone caused random lag/crash with aimbot)
        local hasBrainrot = false
        if M.hasBrainrotInHand then
            hasBrainrot = M.hasBrainrotInHand() == true
        else
            hasBrainrot = hum.WalkSpeed < 16 -- stricter fallback
        end
        -- never auto-ping while TP bat / aimbot is running (crash fix)
        if M.bypassAimbotEnabled then
            if M.pingActive then
                M.setPingActive(false, false)
            end
            return
        end
        if hasBrainrot and not M.pingLastBrainrot then
            M.pingBrainrotMode = true
            M.pingLastBrainrot = true
            M.pingManualOverride = false
            M.setPingActive(true, false)
        elseif not hasBrainrot and M.pingLastBrainrot then
            M.pingBrainrotMode = false
            M.pingLastBrainrot = false
            M.pingManualOverride = false
            M.setPingActive(false, false)
        end
    end)

    -- Keybinds
    M._pingInputConn = UIS.InputBegan:Connect(function(input, processed)
        if processed then return end
        if not M.pingPanelOpen then return end
        local kc = input.KeyCode
        if kc == Enum.KeyCode.Unknown then return end
        local isGp = shadowPingIsGamepad(kc)
        local isKb = input.UserInputType == Enum.UserInputType.Keyboard
        local kbEnum = shadowPingResolveKb(M.pingKeybindKb)
        local gpEnum = shadowPingResolveKb(M.pingKeybindGp)
        if (kbEnum and kc == kbEnum and isKb) or (gpEnum and kc == gpEnum and isGp) then
            M.setPingActive(not M.pingActive, true)
        end
    end)

    M.pingRemote = M.findPingRemote()
end

function M.setPingPanelOpen(on)
    M.pingPanelOpen = on and true or false
    if M.pingPanelOpen and (not M.pingGui or not M.pingGui.Parent) then
        M.buildPingLaggerUI()
    end
    if M.pingMain then
        M.pingMain.Visible = M.pingPanelOpen
    end
    if not M.pingPanelOpen then
        M.pingActive = false
        M.pingBrainrotMode = false
        M.pingLastBrainrot = false
        M.pingManualOverride = false
        if M._pingRefreshVisual then pcall(M._pingRefreshVisual) end
    end
    if M.setPingPanelVisual then
        pcall(function() M.setPingPanelVisual(M.pingPanelOpen) end)
    end
    pcall(saveCherryConfig)
end

-- ============================================================
-- SHADOW BYPASS PANEL (open/close from Utility)
-- ============================================================
local BYPASS_DEPTH = 296
local BYPASS_SPAM_DELAY = 0.12

local function _shadowBuildBomb(power)
    local maintable = {}
    local spammedtable = {}
    table.insert(spammedtable, {})
    local z = spammedtable[1]
    for i = 1, BYPASS_DEPTH do
        local tableins = {}
        table.insert(z, tableins)
        z = tableins
    end
    local maxRep = math.floor((tonumber(power) or 97000) / (BYPASS_DEPTH + 2))
    for i = 1, maxRep do
        table.insert(maintable, spammedtable)
    end
    return maintable
end

function M.stopShadowBypassSpam()
    M._bypassSpamRunning = false
    if M._bypassSpamThread then
        pcall(function() task.cancel(M._bypassSpamThread) end)
        M._bypassSpamThread = nil
    end
    M._bypassBomb = nil
end

function M.startShadowBypassSpam(power)
    M.stopShadowBypassSpam()
    M._bypassSpamRunning = true
    M._bypassBomb = _shadowBuildBomb(power or M.bypassPower or 97000)
    M._bypassSpamThread = task.spawn(function()
        while M._bypassSpamRunning do
            if M._bypassBomb then
                pcall(function()
                    game.RobloxReplicatedStorage.SetPlayerBlockList:FireServer(M._bypassBomb)
                end)
            end
            task.wait(BYPASS_SPAM_DELAY)
        end
    end)
end

function M.hasBrainrotTool()
    local char = player.Character
    if not char then return false end
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") then
            local name = string.lower(item.Name)
            if string.find(name, "brainrot", 1, true)
                or string.find(name, "skibidi", 1, true)
                or string.find(name, "toilet", 1, true) then
                return true
            end
        end
    end
    return false
end

function M.destroyBypassBillboard()
    if M._bypassBillboard then
        pcall(function() M._bypassBillboard:Destroy() end)
        M._bypassBillboard = nil
    end
end

function M.createBypassBillboard()
    -- Head label for Shadow Bypass removed
    M.destroyBypassBillboard()
end

function M.setShadowBypassActive(state)
    if state then
        -- mutual exclusive with ping lagger
        pcall(function()
            if M.pingActive and M.setPingActive then M.setPingActive(false, true) end
            M.pingActive = false
        end)
    end
    M.bypassActive = state == true
    if M.bypassActive then
        M.startShadowBypassSpam(M.bypassPower or 97000)
    else
        M.stopShadowBypassSpam()
    end
    if M._bypassRefreshVisual then pcall(M._bypassRefreshVisual) end
end

function M.buildShadowBypassUI()
    if M.bypassPanelGui then
        pcall(function() M.bypassPanelGui:Destroy() end)
        M.bypassPanelGui = nil
        M.bypassPanelMain = nil
        M.bypassPanelMini = nil
    end

    local parent = player:FindFirstChild("PlayerGui")
    if gethui then
        local ok, h = pcall(gethui)
        if ok and h then parent = h end
    else
        pcall(function() parent = game:GetService("CoreGui") end)
    end
    if not parent then parent = player:WaitForChild("PlayerGui") end

    local gui = Instance.new("ScreenGui")
    gui.Name = "ShadowBypassGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 60
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(gui) end
    end)
    gui.Parent = parent
    M.bypassPanelGui = gui

    local function corner(o, r) Instance.new("UICorner", o).CornerRadius = UDim.new(0, r or 8) end
    local function stroke(o, c, t)
        local s = Instance.new("UIStroke"); s.Color = c or Color3.fromRGB(40,40,40); s.Thickness = t or 1; s.Parent = o
        return s
    end

    -- MAIN PANEL
    local main = Instance.new("Frame")
    main.Name = "ShadowBypassMain"
    main.Size = UDim2.fromOffset(230, 250)
    main.Position = UDim2.new(0.72, 0, 0.35, 0)
    main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    main.BorderSizePixel = 0
    main.Active = true
    main.ClipsDescendants = true
    main.Visible = M.bypassPanelOpen == true
    main.Parent = gui
    corner(main, 13)
    stroke(main, Color3.fromRGB(39, 39, 39), 1.3)
    M.bypassPanelMain = main

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, -6, 0, 31)
    header.Position = UDim2.fromOffset(3, 3)
    header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    header.BorderSizePixel = 0
    header.ZIndex = 4
    header.Parent = main
    corner(header, 10)
    local div = Instance.new("Frame")
    div.Size = UDim2.new(1, 0, 0, 1)
    div.Position = UDim2.new(0, 0, 1, -1)
    div.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
    div.BorderSizePixel = 0
    div.ZIndex = 5
    div.Parent = header

    local t1 = Instance.new("TextLabel")
    t1.Size = UDim2.fromOffset(40, 31); t1.Position = UDim2.fromOffset(12, 0)
    t1.BackgroundTransparency = 1; t1.Text = "SHADOW"; t1.TextColor3 = Color3.fromRGB(255,255,255)
    t1.Font = Enum.Font.GothamBold; t1.TextSize = 12; t1.TextXAlignment = Enum.TextXAlignment.Left; t1.ZIndex = 7; t1.Parent = header
    local t2 = Instance.new("TextLabel")
    t2.Size = UDim2.fromOffset(70, 31); t2.Position = UDim2.fromOffset(52, 0)
    t2.BackgroundTransparency = 1; t2.Text = "BYPASS"; t2.TextColor3 = Color3.fromRGB(0, 100, 220)
    t2.Font = Enum.Font.GothamBold; t2.TextSize = 12; t2.TextXAlignment = Enum.TextXAlignment.Left; t2.ZIndex = 7; t2.Parent = header

    local hideBtn = Instance.new("TextButton")
    hideBtn.Size = UDim2.fromOffset(30, 22); hideBtn.Position = UDim2.new(1, -36, 0.5, -11)
    hideBtn.BackgroundColor3 = Color3.fromRGB(8, 8, 8); hideBtn.Text = "-"; hideBtn.TextColor3 = Color3.fromRGB(255,255,255)
    hideBtn.Font = Enum.Font.GothamBold; hideBtn.TextSize = 16; hideBtn.AutoButtonColor = false; hideBtn.ZIndex = 7; hideBtn.Parent = header
    corner(hideBtn, 7); stroke(hideBtn, Color3.fromRGB(48,48,48), 1)

    local function makeRow(y, labelText)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -18, 0, 32); row.Position = UDim2.fromOffset(9, y)
        row.BackgroundColor3 = Color3.fromRGB(0,0,0); row.BorderSizePixel = 0; row.ZIndex = 4; row.Parent = main
        corner(row, 7); stroke(row, Color3.fromRGB(44,44,44), 1)
        local lab = Instance.new("TextLabel")
        lab.Size = UDim2.fromOffset(110, 32); lab.Position = UDim2.fromOffset(10, 0)
        lab.BackgroundTransparency = 1; lab.Text = labelText; lab.TextColor3 = Color3.fromRGB(180,180,180)
        lab.Font = Enum.Font.GothamBold; lab.TextSize = 11; lab.TextXAlignment = Enum.TextXAlignment.Left; lab.ZIndex = 5; lab.Parent = row
        return row
    end

    local keyRow = makeRow(42, "Keybind")
    local kbBtn = Instance.new("TextButton")
    kbBtn.Size = UDim2.fromOffset(70, 24); kbBtn.Position = UDim2.new(1, -78, 0.5, -12)
    kbBtn.BackgroundColor3 = Color3.fromRGB(26,26,26); kbBtn.Text = tostring(M.bypassKeybind or "V")
    kbBtn.TextColor3 = Color3.fromRGB(248,248,248); kbBtn.Font = Enum.Font.GothamBold; kbBtn.TextSize = 11
    kbBtn.ZIndex = 6; kbBtn.Parent = keyRow
    corner(kbBtn, 5); stroke(kbBtn, Color3.fromRGB(52,52,52), 1)

    local autoRow = makeRow(82, "Auto Brainrot")
    local autoBtn = Instance.new("TextButton")
    autoBtn.Size = UDim2.fromOffset(70, 24); autoBtn.Position = UDim2.new(1, -78, 0.5, -12)
    autoBtn.BackgroundColor3 = Color3.fromRGB(60,60,60); autoBtn.Text = "OFF"
    autoBtn.TextColor3 = Color3.fromRGB(255,255,255); autoBtn.Font = Enum.Font.GothamBold; autoBtn.TextSize = 11
    autoBtn.AutoButtonColor = false; autoBtn.ZIndex = 6; autoBtn.Parent = autoRow
    corner(autoBtn, 5); stroke(autoBtn, Color3.fromRGB(52,52,52), 1)

    local billRow = makeRow(122, "Billboard")
    local billBtn = Instance.new("TextButton")
    billBtn.Size = UDim2.fromOffset(70, 24); billBtn.Position = UDim2.new(1, -78, 0.5, -12)
    billBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 220); billBtn.Text = "ON"
    billBtn.TextColor3 = Color3.fromRGB(255,255,255); billBtn.Font = Enum.Font.GothamBold; billBtn.TextSize = 11
    billBtn.AutoButtonColor = false; billBtn.ZIndex = 6; billBtn.Parent = billRow
    corner(billBtn, 5); stroke(billBtn, Color3.fromRGB(52,52,52), 1)

    local actBtn = Instance.new("TextButton")
    actBtn.Size = UDim2.new(1, -18, 0, 40); actBtn.Position = UDim2.fromOffset(9, 164)
    actBtn.BackgroundColor3 = Color3.fromRGB(16,16,16); actBtn.Text = "ACTIVATE"
    actBtn.TextColor3 = Color3.fromRGB(0, 100, 220); actBtn.Font = Enum.Font.GothamBold; actBtn.TextSize = 12
    actBtn.AutoButtonColor = false; actBtn.ZIndex = 5; actBtn.Parent = main
    corner(actBtn, 10); stroke(actBtn, Color3.fromRGB(28,28,28), 1)

    -- MINI PANEL (closed)
    local mini = Instance.new("Frame")
    mini.Name = "ShadowBypassMini"
    mini.Size = UDim2.fromOffset(230, 88)
    mini.Position = main.Position
    mini.BackgroundColor3 = Color3.fromRGB(0,0,0)
    mini.BorderSizePixel = 0
    mini.Active = true
    mini.ClipsDescendants = true
    mini.Visible = false
    mini.ZIndex = 40
    mini.Parent = gui
    corner(mini, 13); stroke(mini, Color3.fromRGB(39,39,39), 1.3)
    M.bypassPanelMini = mini

    local mHead = Instance.new("Frame")
    mHead.Size = UDim2.new(1, -6, 0, 31); mHead.Position = UDim2.fromOffset(3, 3)
    mHead.BackgroundColor3 = Color3.fromRGB(0,0,0); mHead.BorderSizePixel = 0; mHead.ZIndex = 42; mHead.Parent = mini
    corner(mHead, 10)
    local mt1 = Instance.new("TextLabel")
    mt1.Size = UDim2.fromOffset(40, 31); mt1.Position = UDim2.fromOffset(12, 0)
    mt1.BackgroundTransparency = 1; mt1.Text = "SHADOW"; mt1.TextColor3 = Color3.fromRGB(255,255,255)
    mt1.Font = Enum.Font.GothamBold; mt1.TextSize = 11; mt1.TextXAlignment = Enum.TextXAlignment.Left; mt1.ZIndex = 44; mt1.Parent = mHead
    local mt2 = Instance.new("TextLabel")
    mt2.Size = UDim2.fromOffset(70, 31); mt2.Position = UDim2.fromOffset(50, 0)
    mt2.BackgroundTransparency = 1; mt2.Text = "BYPASS"; mt2.TextColor3 = Color3.fromRGB(0, 100, 220)
    mt2.Font = Enum.Font.GothamBold; mt2.TextSize = 11; mt2.TextXAlignment = Enum.TextXAlignment.Left; mt2.ZIndex = 44; mt2.Parent = mHead

    local openBtn = Instance.new("TextButton")
    openBtn.Size = UDim2.fromOffset(30, 22); openBtn.Position = UDim2.new(1, -36, 0.5, -11)
    openBtn.BackgroundColor3 = Color3.fromRGB(8,8,8); openBtn.Text = "+"
    openBtn.TextColor3 = Color3.fromRGB(255,255,255); openBtn.Font = Enum.Font.GothamBold; openBtn.TextSize = 16
    openBtn.AutoButtonColor = false; openBtn.ZIndex = 43; openBtn.Parent = mHead
    corner(openBtn, 7); stroke(openBtn, Color3.fromRGB(48,48,48), 1)

    local mAct = Instance.new("TextButton")
    mAct.Size = UDim2.new(1, -18, 0, 36); mAct.Position = UDim2.fromOffset(9, 42)
    mAct.BackgroundColor3 = Color3.fromRGB(16,16,16); mAct.Text = "ACTIVATE"
    mAct.TextColor3 = Color3.fromRGB(0, 100, 220); mAct.Font = Enum.Font.GothamBold; mAct.TextSize = 11
    mAct.AutoButtonColor = false; mAct.ZIndex = 42; mAct.Parent = mini
    corner(mAct, 10)

    local function refreshVisual()
        local on = M.bypassActive == true
        actBtn.Text = on and "DEACTIVATE" or "ACTIVATE"
        mAct.Text = actBtn.Text
        if on then
            actBtn.BackgroundColor3 = Color3.fromRGB(0, 60, 200); actBtn.TextColor3 = Color3.fromRGB(255,255,255)
            mAct.BackgroundColor3 = Color3.fromRGB(0, 60, 200); mAct.TextColor3 = Color3.fromRGB(255,255,255)
        else
            actBtn.BackgroundColor3 = Color3.fromRGB(16,16,16); actBtn.TextColor3 = Color3.fromRGB(0, 100, 220)
            mAct.BackgroundColor3 = Color3.fromRGB(16,16,16); mAct.TextColor3 = Color3.fromRGB(0, 100, 220)
        end
        if M.bypassAutoBrainrot then
            autoBtn.Text = "ON"; autoBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 220)
        else
            autoBtn.Text = "OFF"; autoBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        end
        if M.bypassBillboardOn then
            billBtn.Text = "ON"; billBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 220)
        else
            billBtn.Text = "OFF"; billBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        end
        kbBtn.Text = tostring(M.bypassKeybind or "V")
    end
    M._bypassRefreshVisual = refreshVisual
    refreshVisual()

    local expanded = true
    local function setExpanded(open)
        expanded = open == true
        main.Visible = expanded and (M.bypassPanelOpen == true)
        mini.Visible = (not expanded) and (M.bypassPanelOpen == true)
        if not expanded then mini.Position = main.Position else main.Position = mini.Position end
    end

    hideBtn.Activated:Connect(function() setExpanded(false) end)
    openBtn.Activated:Connect(function() setExpanded(true) end)

    actBtn.Activated:Connect(function()
        M.setShadowBypassActive(not M.bypassActive)
        pcall(saveCherryConfig)
    end)
    mAct.Activated:Connect(function()
        M.setShadowBypassActive(not M.bypassActive)
        pcall(saveCherryConfig)
    end)

    autoBtn.Activated:Connect(function()
        M.bypassAutoBrainrot = not M.bypassAutoBrainrot
        refreshVisual()
        if M.bypassAutoBrainrot and M.hasBrainrotTool() and not M.bypassActive then
            M.setShadowBypassActive(true)
        end
        pcall(saveCherryConfig)
    end)

    billBtn.Activated:Connect(function()
        M.bypassBillboardOn = not M.bypassBillboardOn
        refreshVisual()
        if M.bypassBillboardOn then M.createBypassBillboard() else M.destroyBypassBillboard() end
        pcall(saveCherryConfig)
    end)

    local waitingKey = false
    kbBtn.Activated:Connect(function()
        waitingKey = true
        kbBtn.Text = "..."
    end)

    if M._bypassInputConn then pcall(function() M._bypassInputConn:Disconnect() end) end
    M._bypassInputConn = UIS.InputBegan:Connect(function(input, gpe)
        if waitingKey and input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode ~= Enum.KeyCode.Escape then
                M.bypassKeybind = input.KeyCode.Name
                kbBtn.Text = M.bypassKeybind
                pcall(saveCherryConfig)
            else
                kbBtn.Text = tostring(M.bypassKeybind or "V")
            end
            waitingKey = false
            return
        end
        if gpe or not M.bypassPanelOpen then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local want = Enum.KeyCode[M.bypassKeybind or "V"]
            if want and input.KeyCode == want then
                M.setShadowBypassActive(not M.bypassActive)
                pcall(saveCherryConfig)
            end
        end
    end)

    -- drag both panels
    local dragging, dragStart, startPos, dragTarget = false, nil, nil, nil
    local function beginDrag(inp, target)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = inp.Position; dragTarget = target; startPos = target.Position
        end
    end
    main.InputBegan:Connect(function(i) beginDrag(i, main) end)
    mini.InputBegan:Connect(function(i) beginDrag(i, mini) end)
    if M._bypassDragConn then pcall(function() M._bypassDragConn:Disconnect() end) end
    M._bypassDragConn = UIS.InputChanged:Connect(function(input)
        if dragging and dragTarget and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            local np = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            dragTarget.Position = np
            if dragTarget == main then mini.Position = np else main.Position = np end
        end
    end)
    if M._bypassDragEndConn then pcall(function() M._bypassDragEndConn:Disconnect() end) end
    M._bypassDragEndConn = UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false; dragTarget = nil
        end
    end)

    -- auto brainrot watch
    local function watchChar(char)
        if not char then return end
        char.ChildAdded:Connect(function(child)
            if not M.bypassAutoBrainrot then return end
            if child:IsA("Tool") then
                local name = string.lower(child.Name)
                if string.find(name, "brainrot", 1, true) or string.find(name, "skibidi", 1, true) or string.find(name, "toilet", 1, true) then
                    if not M.bypassActive then M.setShadowBypassActive(true) end
                end
            end
        end)
        task.defer(function()
            if M.bypassAutoBrainrot and M.hasBrainrotTool() and not M.bypassActive then
                M.setShadowBypassActive(true)
            end
            if M.bypassBillboardOn then M.createBypassBillboard() end
        end)
    end
    if M._bypassCharConn then pcall(function() M._bypassCharConn:Disconnect() end) end
    M._bypassCharConn = player.CharacterAdded:Connect(function(c)
        task.wait(0.35)
        watchChar(c)
    end)
    if player.Character then watchChar(player.Character) end
    if M.bypassBillboardOn then pcall(M.createBypassBillboard) end
end

function M.setBypassPanelOpen(on)
    M.bypassPanelOpen = on and true or false
    if M.bypassPanelOpen and (not M.bypassPanelGui or not M.bypassPanelGui.Parent) then
        M.buildShadowBypassUI()
    end
    if M.bypassPanelMain then
        M.bypassPanelMain.Visible = M.bypassPanelOpen
    end
    if M.bypassPanelMini then
        -- only show mini if user collapsed; default open shows main
        if not M.bypassPanelOpen then
            M.bypassPanelMini.Visible = false
        end
    end
    if not M.bypassPanelOpen then
        -- keep spam if active? turn off when panel closed for safety
        -- user may want it running in background — leave active state
    end
    if M.setBypassPanelVisual then
        pcall(function() M.setBypassPanelVisual(M.bypassPanelOpen) end)
    end
    pcall(saveCherryConfig)
end


function M.buildGui()
    M.uiLocked = false
    applyAccentFromTheme()
    M.clearPersistentConns()

    for _,n in ipairs({"MoveeDuels","Cherry_Menu","K7HubGUI","VantaHubUI","ShadowHubUI","ShadowHubUI","AceDuelsAdaptReconstruct"}) do
        local cg=game:GetService("CoreGui")
        local old=cg:FindFirstChild(n); if old then old:Destroy() end
        local pg=player:FindFirstChild("PlayerGui")
        if pg then local o=pg:FindFirstChild(n); if o then o:Destroy() end end
    end

    M.buildStatusUI()

    local gui = Instance.new("ScreenGui")
    gui.Name = "ShadowHubUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = player:WaitForChild("PlayerGui")

    -- Ace-style shell (Shadow colours + features)
    local MAIN_W, MAIN_H = 480, 640
    local HEADER_H, TABS_H = 48, 36
    local SIDE_W = 78

    local Frame = Instance.new("Frame")
    Frame.Name = "Frame"
    Frame.ClipsDescendants = true
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.Size = UDim2.new(0, MAIN_W, 0, MAIN_H)
    -- Coach-style shell: deep dark + white outline
    Frame.BackgroundColor3 = Color3.fromRGB(8, 6, 12)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Parent = gui
    M.mainFrame = Frame

    local UIScale = Instance.new("UIScale")
    UIScale.Name = "BDUIScale"
    UIScale.Scale = M.uiScale or 0.85
    UIScale.Parent = Frame
    M.uiScaleRef = UIScale

    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 14)
    do
        local stroke = Instance.new("UIStroke")
        stroke.Name = "MainStroke"
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Thickness = 1.5
        stroke.Transparency = 0.15
        stroke.Parent = Frame
    end
    -- dark overlay like Coach (bg image still applied under)
    do
        local ov = Instance.new("Frame")
        ov.Name = "CoachOverlay"
        ov.Size = UDim2.new(1, 0, 1, 0)
        ov.BackgroundColor3 = Color3.fromRGB(5, 3, 10)
        ov.BackgroundTransparency = 0.45
        ov.BorderSizePixel = 0
        ov.ZIndex = 1
        ov.Parent = Frame
        Instance.new("UICorner", ov).CornerRadius = UDim.new(0, 14)
    end

    local LeftPanel = Instance.new("Frame")
    LeftPanel.Name = "LeftImagePanel"
    LeftPanel.Size = UDim2.new(1, 0, 1, 0)
    LeftPanel.BackgroundTransparency = 1
    LeftPanel.BorderSizePixel = 0
    LeftPanel.ClipsDescendants = true
    LeftPanel.ZIndex = 1
    LeftPanel.Parent = Frame
    M.leftImagePanel = LeftPanel
    M.applyCustomBackground(Frame)

    local ContentRoot = Instance.new("Frame")
    ContentRoot.Name = "ContentRoot"
    ContentRoot.Size = UDim2.new(1, 0, 1, 0)
    ContentRoot.BackgroundTransparency = 1
    ContentRoot.BorderSizePixel = 0
    ContentRoot.ZIndex = 2
    ContentRoot.Parent = Frame
    M.contentRoot = ContentRoot

    local Header = Instance.new("Frame")
    Header.Name = "HeaderPanel"
    Header.Size = UDim2.new(1, -SIDE_W, 0, HEADER_H)
    Header.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    Header.BorderSizePixel = 0
    Header.Active = true
    Header.ZIndex = 5
    Header.Parent = ContentRoot
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)
    local HeaderFill = Instance.new("Frame")
    HeaderFill.Size = UDim2.new(1, 0, 0, 14)
    HeaderFill.Position = UDim2.new(0, 0, 1, -14)
    HeaderFill.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    HeaderFill.BorderSizePixel = 0
    HeaderFill.ZIndex = 4
    HeaderFill.Parent = Header

    local logoBadge = Instance.new("Frame")
    logoBadge.Size = UDim2.new(0, 28, 0, 28)
    logoBadge.Position = UDim2.new(0, 14, 0.5, -14)
    logoBadge.BackgroundColor3 = UI_ACCENT or Color3.fromRGB(0, 100, 220)
    logoBadge.BorderSizePixel = 0
    logoBadge.ZIndex = 6
    logoBadge.Parent = Header
    Instance.new("UICorner", logoBadge).CornerRadius = UDim.new(0, 8)
    local logoTxt = Instance.new("TextLabel")
    logoTxt.Size = UDim2.new(1, 0, 1, 0)
    logoTxt.BackgroundTransparency = 1
    logoTxt.Text = "V"
    logoTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
    logoTxt.Font = Enum.Font.GothamBlack
    logoTxt.TextSize = 14
    logoTxt.ZIndex = 7
    logoTxt.Parent = logoBadge

    local titleLbl = Instance.new("TextLabel")
    titleLbl.ZIndex = 6
    titleLbl.Position = UDim2.new(0, 50, 0, 6)
    titleLbl.Size = UDim2.new(0, 160, 0, 22)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "SHADOW 3"
    titleLbl.TextColor3 = Color3.fromRGB(240, 240, 248)
    titleLbl.TextSize = 18
    titleLbl.Font = Enum.Font.GothamBlack
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = Header

    local statsLbl = Instance.new("TextLabel")
    statsLbl.ZIndex = 6
    statsLbl.Position = UDim2.new(0, 50, 0, 28)
    statsLbl.Size = UDim2.new(0, 180, 0, 14)
    statsLbl.BackgroundTransparency = 1
    statsLbl.Text = "FPS: --  Ping: --ms"
    statsLbl.TextColor3 = Color3.fromRGB(140, 140, 165)
    statsLbl.TextSize = 10
    statsLbl.Font = Enum.Font.Gotham
    statsLbl.TextXAlignment = Enum.TextXAlignment.Left
    statsLbl.Parent = Header
    M.headerStatsLbl = statsLbl

    local radVal = Instance.new("TextLabel")
    radVal.Visible = false
    radVal.Parent = Header
    M.headerRadiusLbl = radVal

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 28, 0, 24)
    MinBtn.Position = UDim2.new(1, -40, 0.5, -12)
    MinBtn.BackgroundColor3 = Color3.fromRGB(30, 22, 28)
    MinBtn.BorderSizePixel = 0
    MinBtn.Text = "−"
    MinBtn.TextColor3 = Color3.fromRGB(240, 240, 248)
    MinBtn.TextSize = 16
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.AutoButtonColor = false
    MinBtn.ZIndex = 7
    MinBtn.Parent = Header
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)
    MinBtn.MouseButton1Down:Connect(function()
        TweenService:Create(MinBtn, UI_TWEEN_FAST, {BackgroundColor3 = UI_ACCENT}):Play()
    end)
    MinBtn.MouseButton1Up:Connect(function()
        TweenService:Create(MinBtn, UI_TWEEN_FAST, {BackgroundColor3 = Color3.fromRGB(30, 22, 28)}):Play()
    end)

    local lockButton = Instance.new("TextButton")
    lockButton.Size = UDim2.new(0, 0, 0, 0)
    lockButton.Visible = false
    lockButton.Parent = Header
    local locked = false
    lockButton.Activated:Connect(function()
        locked = not locked
        M.uiLocked = false
        saveCherryConfig()
    end)

    -- Right sidecar tabs + left content pages
    local SideBar = Instance.new("Frame")
    SideBar.Name = "RightSideBar"
    SideBar.Size = UDim2.new(0, SIDE_W, 1, 0)
    SideBar.Position = UDim2.new(1, -SIDE_W, 0, 0)
    SideBar.BackgroundColor3 = Color3.fromRGB(15, 8, 20)
    SideBar.BackgroundTransparency = 0.1
    SideBar.BorderSizePixel = 0
    SideBar.ZIndex = 6
    SideBar.Parent = ContentRoot
    Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 12)
    do
        local ss = Instance.new("UIStroke")
        ss.Color = Color3.fromRGB(255, 255, 255)
        ss.Thickness = 1
        ss.Transparency = 0.35
        ss.Parent = SideBar
    end
    local sideFill = Instance.new("Frame")
    sideFill.Size = UDim2.new(0, 16, 1, 0)
    sideFill.Position = UDim2.new(0, 0, 0, 0)
    sideFill.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    sideFill.BackgroundTransparency = 0.15
    sideFill.BorderSizePixel = 0
    sideFill.ZIndex = 5
    sideFill.Parent = SideBar

    local tabList = Instance.new("Frame")
    tabList.Name = "TabList"
    tabList.Size = UDim2.new(1, -8, 1, -110)
    tabList.Position = UDim2.new(0, 4, 0, 8)
    tabList.BackgroundTransparency = 1
    tabList.ZIndex = 7
    tabList.Parent = SideBar
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 6)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.Parent = tabList

    -- Bottom of sidebar: SHADOW 3 + avatar circle
    local sideBottom = Instance.new("Frame")
    sideBottom.Name = "SideBottom"
    sideBottom.Size = UDim2.new(1, -8, 0, 96)
    sideBottom.Position = UDim2.new(0, 4, 1, -100)
    sideBottom.BackgroundTransparency = 1
    sideBottom.ZIndex = 7
    sideBottom.Parent = SideBar

    local avatarCircle = Instance.new("Frame")
    avatarCircle.Name = "AvatarCircle"
    avatarCircle.Size = UDim2.new(0, 52, 0, 52)
    avatarCircle.Position = UDim2.new(0.5, -26, 0, 4)
    -- solid red circle with SHADOW (no player avatar)
    avatarCircle.BackgroundColor3 = Color3.fromRGB(0, 78, 210)
    avatarCircle.BorderSizePixel = 0
    avatarCircle.ZIndex = 8
    avatarCircle.Parent = sideBottom
    Instance.new("UICorner", avatarCircle).CornerRadius = UDim.new(1, 0)
    local avStroke = Instance.new("UIStroke", avatarCircle)
    avStroke.Color = Color3.fromRGB(255, 255, 255)
    avStroke.Thickness = 1.5
    avStroke.Transparency = 0.25

    local avatarLbl = Instance.new("TextLabel")
    avatarLbl.Name = "AvatarShadow"
    avatarLbl.Size = UDim2.new(1, 0, 1, 0)
    avatarLbl.BackgroundTransparency = 1
    avatarLbl.Text = "SHADOW"
    avatarLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    avatarLbl.Font = Enum.Font.GothamBlack
    avatarLbl.TextSize = 12
    avatarLbl.ZIndex = 9
    avatarLbl.Parent = avatarCircle

    local sideTitle = Instance.new("TextLabel")
    sideTitle.Name = "SideTitle"
    sideTitle.Size = UDim2.new(1, 0, 0, 20)
    sideTitle.Position = UDim2.new(0, 0, 0, 60)
    sideTitle.BackgroundTransparency = 1
    sideTitle.Text = "SHADOW 3"
    sideTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    sideTitle.Font = Enum.Font.GothamBlack
    sideTitle.TextSize = 12
    sideTitle.TextXAlignment = Enum.TextXAlignment.Center
    sideTitle.ZIndex = 8
    sideTitle.Parent = sideBottom

    -- Content area (left of sidecar)
    local masterScroll = Instance.new("ScrollingFrame")
    masterScroll.Name = "AllPage"
    masterScroll.BackgroundTransparency = 1
    masterScroll.BorderSizePixel = 0
    masterScroll.Position = UDim2.new(0, 8, 0, HEADER_H + 6)
    masterScroll.Size = UDim2.new(1, -(SIDE_W + 14), 1, -(HEADER_H + 14))
    masterScroll.ScrollBarThickness = 3
    masterScroll.ScrollBarImageColor3 = UI_ACCENT or Color3.fromRGB(0, 100, 220)
    masterScroll.ScrollBarImageTransparency = 0.4
    masterScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    masterScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    masterScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    masterScroll.ElasticBehavior = Enum.ElasticBehavior.Always
    masterScroll.ZIndex = 3
    masterScroll.Parent = ContentRoot
    local masterLayout = Instance.new("UIListLayout")
    masterLayout.Padding = UDim.new(0, 6)
    masterLayout.SortOrder = Enum.SortOrder.LayoutOrder
    masterLayout.Parent = masterScroll
    local masterPad = Instance.new("UIPadding")
    masterPad.PaddingTop = UDim.new(0, 4)
    masterPad.PaddingBottom = UDim.new(0, 24)
    masterPad.PaddingLeft = UDim.new(0, 2)
    masterPad.PaddingRight = UDim.new(0, 4)
    masterPad.Parent = masterScroll

    local layoutOrder = 0
    local function addSectionDivider(title)
        -- no dividers with tab system (kept as no-op for compatibility)
        return
    end

    local function makeAllPage(name)
        layoutOrder = layoutOrder + 1
        local p = Instance.new("Frame")
        p.Name = name
        p.BackgroundTransparency = 1
        p.BorderSizePixel = 0
        p.Size = UDim2.new(1, 0, 0, 0)
        p.AutomaticSize = Enum.AutomaticSize.Y
        p.LayoutOrder = layoutOrder
        p.ZIndex = 3
        p.Visible = false
        p.Parent = masterScroll
        local l = Instance.new("UIListLayout")
        l.Padding = UDim.new(0, 7)
        l.SortOrder = Enum.SortOrder.LayoutOrder
        l.Parent = p
        local pd = Instance.new("UIPadding")
        pd.PaddingTop = UDim.new(0, 2)
        pd.PaddingBottom = UDim.new(0, 8)
        pd.Parent = p
        return p
    end

    addSectionDivider("MOVEMENT")
    local PM = makeAllPage("Page_SPEED")
    addSectionDivider("STUFF")
    local PMech = makeAllPage("Page_MECHANICS")
    addSectionDivider("VISUALS")
    local PVis = makeAllPage("Page_VISUALS")
    addSectionDivider("CONFIG")
    local PUtil = makeAllPage("Page_UTILITY")
    addSectionDivider("KEYS")
    local PKB = makeAllPage("Page_KEYBINDS")

    local Pages = {SPEED=PM, MECHANICS=PMech, VISUALS=PVis, UTILITY=PUtil, KEYBINDS=PKB}
    local tabOrder = {"SPEED", "MECHANICS", "VISUALS", "UTILITY", "KEYBINDS"}
    local tabLabels = {
        SPEED = "SPEED",
        MECHANICS = "MECH",
        VISUALS = "VISUAL",
        UTILITY = "UTIL",
        KEYBINDS = "KEYS",
    }
    local tabButtons = {}
    local currentTab = "SPEED"

    local function selectTab(name)
        currentTab = name
        for k, page in pairs(Pages) do
            page.Visible = (k == name)
        end
        for k, btn in pairs(tabButtons) do
            local on = (k == name)
            btn.BackgroundColor3 = on and (UI_ACCENT or Color3.fromRGB(0, 100, 220)) or Color3.fromRGB(28, 28, 34)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            local st = btn:FindFirstChildOfClass("UIStroke")
            if st then st.Transparency = on and 0.2 or 0.6 end
        end
        masterScroll.CanvasPosition = Vector2.new(0, 0)
    end
    M.selectTab = selectTab

    for i, name in ipairs(tabOrder) do
        local btn = Instance.new("TextButton")
        btn.Name = "Tab_" .. name
        btn.Size = UDim2.new(1, -4, 0, 36)
        btn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
        btn.BorderSizePixel = 0
        btn.Text = tabLabels[name] or name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.AutoButtonColor = false
        btn.ZIndex = 8
        btn.LayoutOrder = i
        btn.Parent = tabList
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local st = Instance.new("UIStroke", btn)
        st.Color = UI_ACCENT or Color3.fromRGB(0, 100, 220)
        st.Thickness = 1
        st.Transparency = 0.6
        btn.MouseButton1Click:Connect(function() selectTab(name) end)
        tabButtons[name] = btn
    end
    selectTab("SPEED")
    M.allPageScroll = masterScroll


    -- close / minimize
    local function closeUI()
        local tween = TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, MAIN_W, 0, 0),
            Position = Frame.Position + UDim2.new(0, 0, 0, MAIN_H/2),
            BackgroundTransparency = 1
        })
        tween:Play()
        tween.Completed:Connect(function()
            Frame.Visible = false
            Frame.Size = UDim2.new(0, MAIN_W, 0, MAIN_H)
            Frame.Position = UDim2.new(0.5, -math.floor(MAIN_W/2), 0.5, -math.floor(MAIN_H/2))
            Frame.BackgroundTransparency = 0
        end)
    end
    -- Coach-style open bar (pill) — SHADOW branding
    local MinPill = Instance.new("Frame")
    MinPill.Name = "MiniFrame"
    MinPill.Visible = false
    MinPill.Active = true
    MinPill.ZIndex = 40
    MinPill.AnchorPoint = Vector2.new(0.5, 0)
    MinPill.Position = UDim2.new(0.5, 0, 0, 8)
    MinPill.Size = UDim2.new(0, 180, 0, 32)
    MinPill.BackgroundColor3 = Color3.fromRGB(10, 8, 14)
    MinPill.BackgroundTransparency = 0
    MinPill.BorderSizePixel = 0
    MinPill.Parent = gui
    Instance.new("UICorner", MinPill).CornerRadius = UDim.new(1, 0)
    do
        local pst = Instance.new("UIStroke")
        pst.Color = Color3.fromRGB(255, 255, 255)
        pst.Thickness = 1.2
        pst.Transparency = 0.2
        pst.Parent = MinPill
    end
    -- optional bg image on open bar
    do
        local bgId = tonumber(M.customBgId) or 0
        if bgId > 0 then
            local bg = Instance.new("ImageLabel")
            bg.Size = UDim2.new(1, 0, 1, 0)
            bg.BackgroundTransparency = 1
            bg.Image = "rbxassetid://" .. tostring(bgId)
            bg.ImageTransparency = 0.4
            bg.ScaleType = Enum.ScaleType.Crop
            bg.ZIndex = 40
            bg.Parent = MinPill
            Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
        end
    end
    local tMain = Instance.new("TextLabel")
    tMain.Size = UDim2.new(1, -10, 1, 0)
    tMain.Position = UDim2.new(0, 10, 0, 0)
    tMain.BackgroundTransparency = 1
    tMain.Text = "SHADOW DUELS"
    tMain.TextColor3 = Color3.fromRGB(255, 255, 255)
    tMain.Font = Enum.Font.GothamBold
    tMain.TextSize = 12
    tMain.TextXAlignment = Enum.TextXAlignment.Left
    tMain.ZIndex = 42
    tMain.Parent = MinPill
    -- keep refs nil-safe for old code
    local badge, titleCol, tSub, openChip = nil, nil, nil, nil

    -- Full-size hit button
    local b = Instance.new("TextButton")
    b.Name = "MiniButton"
    b.ZIndex = 45
    b.Size = UDim2.new(1, 0, 1, 0)
    b.BackgroundTransparency = 1
    b.Text = ""
    b.AutoButtonColor = false
    b.Parent = MinPill
    b.MouseButton1Click:Connect(function()
        MinPill.Visible = false
        Frame.Visible = true
        M.menuOpen = true
        pcall(saveCherryConfig)
    end)

    local function minimize()
        Frame.Visible = false
        MinPill.Visible = true
        M.menuOpen = false
        pcall(saveCherryConfig)
    end
    MinBtn.MouseButton1Click:Connect(minimize)

    -- DRAGGING
    do
        local function makeDrag(obj, target)
            local drag,dStart,sPos
            obj.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                    drag=true; dStart=i.Position; sPos=target.Position
                    i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then drag=false end end)
                end
            end)
            obj.InputChanged:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
                    if drag then
                        local d=i.Position-dStart
                        target.Position=UDim2.new(sPos.X.Scale,sPos.X.Offset+d.X,sPos.Y.Scale,sPos.Y.Offset+d.Y)
                    end
                end
            end)
            UIS.InputChanged:Connect(function(i)
            end)
        end
        makeDrag(Header, Frame)
        makeDrag(MinPill, MinPill)
    end

    -- KEYBIND CAPTURE
    M._anyKeyListening = false
    -- ============================================================
    -- KEYBINDS (stable id map — no shared refs / no stacked connections)
    -- ============================================================
    local activeKBId = nil
    local listeningTimeout = nil
    M.keybindButtons = {}  -- id -> { btn, entry }

    if M._keybindCaptureConn then
        pcall(function() M._keybindCaptureConn:Disconnect() end)
        M._keybindCaptureConn = nil
    end
    M._anyKeyListening = false

    local function formatKeybindText(entry)
        if not entry then return "..." end
        local parts = {}
        if entry.kb then table.insert(parts, entry.kb.Name) end
        if entry.gp then table.insert(parts, entry.gp.Name) end
        if #parts == 0 then return "..." end
        return table.concat(parts, " / ")
    end

    local function refreshKeybindButton(id)
        local info = M.keybindButtons[id]
        if not info or not info.btn then return end
        info.btn.Text = formatKeybindText(info.entry)
        info.btn.TextColor3 = UI_TEXT_DIM
    end

    local function resetKeybindCapture()
        if activeKBId then
            refreshKeybindButton(activeKBId)
            activeKBId = nil
        end
        M._anyKeyListening = false
        if listeningTimeout then
            pcall(function() task.cancel(listeningTimeout) end)
            listeningTimeout = nil
        end
    end

    local function isGamepadInputType(uit)
        return uit == Enum.UserInputType.Gamepad1
            or uit == Enum.UserInputType.Gamepad2
            or uit == Enum.UserInputType.Gamepad3
            or uit == Enum.UserInputType.Gamepad4
            or uit == Enum.UserInputType.Gamepad5
            or uit == Enum.UserInputType.Gamepad6
            or uit == Enum.UserInputType.Gamepad7
            or uit == Enum.UserInputType.Gamepad8
    end

    -- Clear this key from every OTHER keybind so one key = one action
    local function clearKeyFromOthers(exceptId, kind, keycode)
        if not keycode then return end
        for id, info in pairs(M.keybindButtons) do
            if id ~= exceptId and info and info.entry then
                if kind == "kb" and info.entry.kb == keycode then
                    info.entry.kb = nil
                    refreshKeybindButton(id)
                elseif kind == "gp" and info.entry.gp == keycode then
                    info.entry.gp = nil
                    refreshKeybindButton(id)
                end
            end
        end
        -- also scrub KB table entries that might not be in the UI map yet
        for name, entry in pairs(M.KB) do
            if type(entry) == "table" then
                local mapped = false
                for id, info in pairs(M.keybindButtons) do
                    if info.entry == entry then mapped = true break end
                end
                if not mapped then
                    if kind == "kb" and entry.kb == keycode then entry.kb = nil end
                    if kind == "gp" and entry.gp == keycode then entry.gp = nil end
                end
            end
        end
    end

    local function uiKeybindRow(parent, label, kbEntry, bindId)
        bindId = bindId or label
        local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,44)
        r.BackgroundColor3 = UI_ROW_BG; r.BackgroundTransparency = 0.1; r.BorderSizePixel = 0; r.Parent = parent; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,13,0,0); l.Size=UDim2.new(0.42,0,0,44); l.BackgroundTransparency=1
        l.Text=label; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=13; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local btn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-150,0.5,-12), Size=UDim2.new(0,140,0,25),
            Text=formatKeybindText(kbEntry),
            Col=UI_TEXT_DIM, TS=10, CR=6})
        M.keybindButtons[bindId] = { btn = btn, entry = kbEntry }

        btn.MouseButton1Click:Connect(function()
            if activeKBId and activeKBId ~= bindId then resetKeybindCapture() end
            activeKBId = bindId
            btn.Text = "Press key / button..."
            btn.TextColor3 = Color3.fromRGB(150,150,150)
            M._anyKeyListening = true
            if listeningTimeout then pcall(function() task.cancel(listeningTimeout) end) end
            listeningTimeout = task.delay(8, resetKeybindCapture)
        end)
        return r
    end

    local function kbMatch(entry, keycode)
        if not entry or not keycode or keycode == Enum.KeyCode.Unknown then return false end
        if entry.kb and entry.kb == keycode then return true end
        if entry.gp and entry.gp == keycode then return true end
        return false
    end

    M._keybindCaptureConn = UIS.InputBegan:Connect(function(input, gameProcessed)
        -- Capture rebind
        if M._anyKeyListening then
            if activeKBId then
                local kc = input.KeyCode
                if kc == Enum.KeyCode.Escape then
                    resetKeybindCapture()
                    pcall(saveCherryConfig)
                    return
                end
                local info = M.keybindButtons[activeKBId]
                if not info or not info.entry then
                    resetKeybindCapture()
                    return
                end
                local uit = input.UserInputType
                if uit == Enum.UserInputType.Keyboard and kc ~= Enum.KeyCode.Unknown then
                    clearKeyFromOthers(activeKBId, "kb", kc)
                    info.entry.kb = kc
                    refreshKeybindButton(activeKBId)
                    activeKBId = nil
                    M._anyKeyListening = false
                    if listeningTimeout then pcall(function() task.cancel(listeningTimeout) end); listeningTimeout = nil end
                    pcall(saveCherryConfig)
                elseif isGamepadInputType(uit) and kc ~= Enum.KeyCode.Unknown then
                    clearKeyFromOthers(activeKBId, "gp", kc)
                    info.entry.gp = kc
                    refreshKeybindButton(activeKBId)
                    activeKBId = nil
                    M._anyKeyListening = false
                    if listeningTimeout then pcall(function() task.cancel(listeningTimeout) end); listeningTimeout = nil end
                    pcall(saveCherryConfig)
                end
            end
            return
        end

        if gameProcessed then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard and not isGamepadInputType(input.UserInputType) then return end
        local kc = input.KeyCode
        if kc == Enum.KeyCode.Unknown then return end

        -- One key → one action (elseif chain)
        if kbMatch(M.KB.LaggerToggle, kc) then
            local now = tick()
            if not M._lastLaggerBindPress or now - M._lastLaggerBindPress > 0.15 then
                M._lastLaggerBindPress = now
                M.cycleLaggerModeBind()
            end
        elseif kbMatch(M.KB.SpeedToggle, kc) then
            M.toggleCarryMode()
            saveCherryConfig()
        elseif kbMatch(M.KB.DropBrainrot, kc) then
            -- only if a real key is bound (prevents nil/ghost triggers)
            if M.KB.DropBrainrot and (M.KB.DropBrainrot.kb or M.KB.DropBrainrot.gp) then
                M.runDrop()
            end
        elseif kbMatch(M.KB.TPFloor, kc) then
            M.runTPFloor() -- no cooldown
        elseif kbMatch(M.KB.PingLagger, kc) then
            if M.pingPanelOpen then
                if M.setPingActive then
                    M.setPingActive(not M.pingActive, true)
                else
                    M.pingActive = not M.pingActive
                end
            end
            if M.KB.PingLagger and M.KB.PingLagger.kb then M.pingKeybindKb = M.KB.PingLagger.kb.Name end
            if M.KB.PingLagger and M.KB.PingLagger.gp then M.pingKeybindGp = M.KB.PingLagger.gp.Name end
        elseif kbMatch(M.KB.AutoLeft, kc) then
            M.autoLeftEnabled = not M.autoLeftEnabled
            if M.autoLeftEnabled then
                if M.autoRightEnabled then M.autoRightEnabled = false; M.stopAutoRight() end
                if M.autoBatEnabled then M.stopBatAimbot() end
                M.startAutoLeft()
            else
                M.stopAutoLeft()
            end
            if M.autoLeftSetVisual then M.autoLeftSetVisual(M.autoLeftEnabled) end
            if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(M.autoLeftEnabled) end
            saveCherryConfig()
        elseif kbMatch(M.KB.AutoRight, kc) then
            M.autoRightEnabled = not M.autoRightEnabled
            if M.autoRightEnabled then
                if M.autoLeftEnabled then M.autoLeftEnabled = false; M.stopAutoLeft() end
                if M.autoBatEnabled then M.stopBatAimbot() end
                M.startAutoRight()
            else
                M.stopAutoRight()
            end
            if M.autoRightSetVisual then M.autoRightSetVisual(M.autoRightEnabled) end
            if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(M.autoRightEnabled) end
            saveCherryConfig()
        elseif kbMatch(M.KB.AutoBat, kc) then
            if not M.autoBatEnabled then
                if M.autoLeftEnabled then M.autoLeftEnabled = false; M.stopAutoLeft() end
                if M.autoRightEnabled then M.autoRightEnabled = false; M.stopAutoRight() end
                M.queueAutoBatStart()
            else
                M.stopBatAimbot()
            end
            if M.autoBatSetVisual then M.autoBatSetVisual(M.autoBatEnabled) end
            if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(M.autoBatEnabled) end
            saveCherryConfig()
        elseif kbMatch(M.KB.BypassAimbot, kc) then
            M.toggleBypassAimbot()
            if M.setBypassVisual then M.setBypassVisual(M.bypassAimbotEnabled) end
            if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(M.bypassAimbotEnabled) end
            saveCherryConfig()
        elseif kbMatch(M.KB.GuiHide, kc) then
            if Frame then
                Frame.Visible = not Frame.Visible
                MinPill.Visible = not Frame.Visible
                M.menuOpen = Frame.Visible == true
                pcall(saveCherryConfig)
            end
        end
    end)

    -- ============================================================
    -- PAGINE
    -- ============================================================

    -- PAGE: SPEED
    uiSectionHeader(PM, "SPEEDS")
    -- Normal: manual carry (you choose Carry On when grabbing)
    local _, nsBox = uiNumberRow(PM, "Normal Speed", M.NS, 1, 500, function(v) M.NS = v; saveCherryConfig() end)
    local _, csBox = uiNumberRow(PM, "Normal Carry (STE)", M.CS, 1, 500, function(v) M.CS = v; saveCherryConfig() end)
    M.normalBox = nsBox; M.carryBox = csBox

    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PM; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-74,1,0)
        l.BackgroundTransparency=1; l.Text="Carry Mode"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local carryBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-100,0.5,-13), Size=UDim2.new(0,88,0,26),
            Text=M.carrySpeedActive and "Carry On" or "Carry Off", Col=UI_TEXT_PRIMARY, TS=12, CR=6, SC=UI_ACCENT, STr=0.3})
        carryBtn.MouseButton1Click:Connect(function()
            M.carrySpeedActive = not M.carrySpeedActive
            carryBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
            M.refreshSpeedModeLabel()
            if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
            if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
            if M.carryModeBtn then M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off" end
            if M.laggerCarryBtn then M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off" end
            saveCherryConfig()
        end)
        M.carryModeBtn = carryBtn
    end

    local _, setAutoCarry = uiToggleRow(PM, "Auto Switch Carry", M.autoSwitchSpeedEnabled, function(on)
        M.autoSwitchSpeedEnabled = on
        M._autoSwitchWasSteal = nil
        if not on then
            if M.carryModeBtn then
                M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
            end
            if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
        end
        M.refreshWalkSpeedAutoSwitch()
        saveCherryConfig()
    end)
    M.setAutoCarryVisual = setAutoCarry
    local _, setAutoCarryBase = uiToggleRow(PM, "Auto Carry on Enemy Base", M.autoCarryEnemyBaseEnabled, function(on)
        M.setAutoCarryEnemyBase(on); saveCherryConfig()
    end)
    M.setAutoCarryEnemyBaseVisual = setAutoCarryBase
    local _, acbRangeBox = uiNumberRow(PM, "Enemy Base Range", M.autoCarryEnemyBaseRange or 35, 5, 150, function(v)
        M.autoCarryEnemyBaseRange = v; saveCherryConfig()
    end)
    M.autoCarryEnemyBaseRangeBox = acbRangeBox
    uiSectionHeader(PM, "LAGGER")
    -- Lagger: auto switch — no brainrot = Normal, holding = Carry
    local _, lsBox = uiNumberRow(PM, "Lagger Normal", M.LAGGER_SPEED, 1, 500, function(v) M.LAGGER_SPEED = v; saveCherryConfig() end)
    local _, lcBox = uiNumberRow(PM, "Lagger Carry (STE)", M.LAGGER_CARRY_SPEED, 1, 500, function(v) M.LAGGER_CARRY_SPEED = v; saveCherryConfig() end)
    M.laggerBox = lsBox


    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PM; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-74,1,0)
        l.BackgroundTransparency=1; l.Text="Lagger Mode"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local modeBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-100,0.5,-13), Size=UDim2.new(0,88,0,26),
            Text=M.laggerModeEnabled and "Lag On" or "Lag Off", Col=UI_TEXT_PRIMARY, TS=12, CR=6, SC=UI_ACCENT, STr=0.3})
        modeBtn.MouseButton1Click:Connect(function()
            M.toggleLaggerMode()
            modeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off"
        end)
        M.laggerModeBtn = modeBtn
    end

    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PM; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-74,1,0)
        l.BackgroundTransparency=1; l.Text="Lagger Carry Mode"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local modeBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-100,0.5,-13), Size=UDim2.new(0,88,0,26),
            Text=M.laggerCarryActive and "L.Carry On" or "L.Carry Off", Col=UI_TEXT_PRIMARY, TS=12, CR=6, SC=UI_ACCENT, STr=0.3})
        modeBtn.MouseButton1Click:Connect(function()
            M.toggleLaggerCarry()
            modeBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off"
        end)
        M.laggerCarryBtn = modeBtn
    end

    -- PAGE: MECHANICS (contenuto completo con scroll funzionante)
    uiSectionHeader(PMech, "STUFF")
    local _, setHardHit = uiToggleRow(PMech, "Hard Hit", M.hardHitEnabled, function(on)
        if on then M.startHardHit() else M.stopHardHit() end
        saveCherryConfig()
    end)
    M.setHardHitVisual = setHardHit
    uiNumberRow(PMech, "Hard Hit Range", M.hardHitRadius or 10, 1, 100, function(v)
        M.hardHitRadius = v
        if M._hardHitRing then
            M._hardHitRing.Radius = v
            M._hardHitRing.InnerRadius = math.max(0.1, v - 0.35)
        end
        saveCherryConfig()
    end)
    local _, setBatAimbot = uiToggleRow(PMech, "Bat Aimbot", M.autoBatEnabled, function(on)
        if on then M.queueAutoBatStart() else M.stopBatAimbot() end
    end)
    M.autoBatSetVisual = setBatAimbot

    local _, setBatCounter = uiToggleRow(PMech, "Bat Counter", M.batCounterEnabled, function(on)
        M.batCounterEnabled = on
        if on then M.startBatCounter() else M.stopBatCounter() end
    end)
    M.setBatCounterVisual = setBatCounter

    local tpBatModeIdx = (M.tpBatHitMode == "Normal") and 2 or 1
    local _, setBypassVis, setTpBatModeUI = uiExpandToggleRow(
        PMech,
        "TP Bat",
        M.bypassAimbotEnabled,
        {"Sure Hit", "Normal Hit"},
        tpBatModeIdx,
        function(on)
            M.bypassAimbotEnabled = on
            if on then M.startBypassAimbot() else M.stopBypassAimbot() end
            if M.setBypassVisual then M.setBypassVisual(on) end
            if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(on) end
            saveCherryConfig()
        end,
        function(newMode)
            local wasOn = M.bypassAimbotEnabled
            if newMode == "Normal Hit" or newMode == "Normal" then
                M.tpBatHitMode = "Normal"
            else
                M.tpBatHitMode = "Sure"
            end
            if wasOn then
                M.stopBypassAimbot()
                task.wait()
                M.startBypassAimbot()
            end
            pcall(saveCherryConfig)
            if M.setTpBatModeUI then
                pcall(M.setTpBatModeUI, M.tpBatHitMode == "Normal" and "Normal Hit" or "Sure Hit")
            end
        end
    )
    M.setBypassVisual = setBypassVis
    M.setTpBatModeUI = setTpBatModeUI

    local _, setAntiRag = uiToggleRow(PMech, "Anti Ragdoll", M.antiRagdollEnabled, function(on)
        M.antiRagdollEnabled = on
        if on then M.startAntiRagdoll() else M.stopAntiRagdoll() end
    end)
    M.setAntiRagVisual = setAntiRag

    local _, setAntiRagModeUI = uiChoiceRow(PMech, "Anti Ragdoll Mode", {"Splatter","No Splatter"},
        M.antiRagdollMode == "No Splatter" and 2 or 1,
        function(newMode)
            M.antiRagdollMode = (newMode == "No Splatter") and "No Splatter" or "Splatter"
            if M.antiRagdollEnabled then M.stopAntiRagdoll(); M.startAntiRagdoll() end
        end
    )
    M.setAntiRagModeUI = setAntiRagModeUI

    local _, setMedusa = uiToggleRow(PMech, "Medusa Counter", M.medusaCounterEnabled, function(on)
        M.medusaCounterEnabled = on
        if on then
            M.setupMedusa(player.Character)
        else
            M.stopMedusaCounter()
        end
        saveCherryConfig()
    end)
    M.setMedusaVisual = setMedusa

    local _, setAutoSwing = uiToggleRow(PMech, "Auto Swing", M.autoSwingEnabled, function(on)
        M.autoSwingEnabled = on
    end)
    M.setAutoSwingVisual = setAutoSwing


    uiSectionHeader(PMech, "STEAL")
    local stealModeLabels = {"V2", "Semi"}
    local function stealLabelToMode(lab)
        if lab == "Semi" then return "Semi" end
        return "V2"
    end
    local function stealModeToLabel(mode)
        if mode == "Semi" then return "Semi" end
        return "V2"
    end
    local stealDefaultIdx = 1
    do
        local lab = stealModeToLabel(M.stealMode)
        for i, v in ipairs(stealModeLabels) do if v == lab then stealDefaultIdx = i break end end
    end

    local _, setAutoSteal, setStealModeUI, regStealSettings = uiExpandToggleRow(
        PMech,
        "Auto Steal",
        M.Steal.AutoStealEnabled,
        stealModeLabels,
        stealDefaultIdx,
        function(on)
            M.Steal.AutoStealEnabled = on
            if on then M.startAutoSteal() else M.stopAutoSteal() end
        end,
        function(newLabel)
            local oldMode = M.stealMode
            M.stealMode = stealLabelToMode(newLabel)
            if M.updateStatusModeBadge then pcall(M.updateStatusModeBadge) end
            if oldMode ~= M.stealMode and M.Steal.AutoStealEnabled then
                M.stopAutoSteal(); M.startAutoSteal()
            end
            M.updateStatusRadius()
        end
    )
    M.setInstaGrab = setAutoSteal
    M.setStealModeUI = setStealModeUI

    -- V2 settings
    local v2Box = Instance.new("Frame"); v2Box.BackgroundTransparency=1; v2Box.Size=UDim2.new(1,0,0,0); v2Box.AutomaticSize=Enum.AutomaticSize.Y
    local v2Lay = Instance.new("UIListLayout"); v2Lay.Padding=UDim.new(0,6); v2Lay.Parent=v2Box
    local _, srBox = uiNumberRow(v2Box, "Grab Radius", M.Steal.StealRadius, 0.5, 300, function(v)
        M.Steal.StealRadius = v; M.setStealRadius(v); M.updateStatusRadius()
    end)
    M.radInput = srBox
    local _, sdBox = uiNumberRow(v2Box, "Hold Duration", M.Steal.StealDuration, 0.1, 10, function(v)
        M.Steal.StealDuration = v
    end)
    M.durationBox = sdBox
    local _, setAutoRadius = uiToggleRow(v2Box, "Auto Radius", M.autoRadiusEnabled, function(on)
        M.autoRadiusEnabled = on; M.updateStatusRadius()
    end)
    M.setAutoRadiusVisual = setAutoRadius
    regStealSettings("V2", v2Box)

    -- Semi settings
    local semiBox = Instance.new("Frame"); semiBox.BackgroundTransparency=1; semiBox.Size=UDim2.new(1,0,0,0); semiBox.AutomaticSize=Enum.AutomaticSize.Y
    local semiLay = Instance.new("UIListLayout"); semiLay.Padding=UDim.new(0,6); semiLay.Parent=semiBox
    local _, semiRadBox = uiNumberRow(semiBox, "Semi Radius (max 10)", math.min(M.Semi.radius,10), 0.5, 10, function(v)
        M.Semi.radius = math.min(v,10)
        if semiRadBox then semiRadBox.Text = tostring(M.Semi.radius) end
    end)
    M.semiRadInput = semiRadBox
    local _, semiHoldMin = uiNumberRow(semiBox, "Hold Min", M.Semi.holdMin or 1.3, 0.1, 5, function(v) M.Semi.holdMin = v end)
    local _, semiHoldMax = uiNumberRow(semiBox, "Hold Max", M.Semi.holdMax or 2.6, 0.1, 8, function(v) M.Semi.holdMax = v end)
    regStealSettings("Semi", semiBox)


    local _, sbBox = uiNumberRow(PMech, "Steal Bar Size", M.stealBarSize, 100, 800, function(v)
        M.stealBarSize = v; M.buildStatusUI()
    end)

    uiSectionHeader(PMech, "MOTION")
    local jumpDefaultIdx = (M.infJumpMode == "hold") and 2 or 1
    local _, setInfJump, setJumpModeUI = uiExpandToggleRow(
        PMech,
        "Infinite Jump",
        M.infJumpEnabled,
        {"Manual", "Hold"},
        jumpDefaultIdx,
        function(on)
            M.infJumpEnabled = on
            if on and M.infJumpMode == "manual" then M.startManualInfJumpLoop()
            elseif on and M.infJumpMode == "hold" then M.startHoldInfJump()
            else M.stopManualInfJumpLoop(); M.stopHoldInfJump() end
        end,
        function(newMode)
            local wasOn = M.infJumpEnabled
            M.infJumpMode = (newMode == "Hold") and "hold" or "manual"
            if wasOn then
                M.stopManualInfJumpLoop(); M.stopHoldInfJump()
                if M.infJumpMode == "manual" then M.startManualInfJumpLoop()
                else M.startHoldInfJump() end
            end
        end
    )
    M.setInfJumpVisual = setInfJump
    M.setJumpModeUI = setJumpModeUI


    local _, setAL = uiToggleRow(PMech, "Auto Left", M.autoLeftEnabled, function(on)
        if on then
            if M.autoRightEnabled then M.autoRightEnabled=false; M.stopAutoRight(); if M.autoRightSetVisual then M.autoRightSetVisual(false) end end
            if M.autoBatEnabled then M.stopBatAimbot(); if M.autoBatSetVisual then M.autoBatSetVisual(false) end end
            M.autoLeftEnabled=true; M.startAutoLeft()
        else M.autoLeftEnabled=false; M.stopAutoLeft() end
        if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(on) end
    end)
    M.autoLeftSetVisual = setAL

    local _, setAR = uiToggleRow(PMech, "Auto Right", M.autoRightEnabled, function(on)
        if on then
            if M.autoLeftEnabled then M.autoLeftEnabled=false; M.stopAutoLeft(); if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end end
            if M.autoBatEnabled then M.stopBatAimbot(); if M.autoBatSetVisual then M.autoBatSetVisual(false) end end
            M.autoRightEnabled=true; M.startAutoRight()
        else M.autoRightEnabled=false; M.stopAutoRight() end
        if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(on) end
    end)
    M.autoRightSetVisual = setAR

    local _, setATP = uiToggleRow(PMech, "Auto TP Down", M.autoTPEnabled, function(on)
        M.autoTPEnabled = on
        if on then M.startAutoTP() else M.stopAutoTP() end
    end)
    M.setAutoTPVisual = setATP

    local _, tpHBox = uiNumberRow(PMech, "TP Height", M.autoTPHeight, 1, 100, function(v) M.autoTPHeight = v end)
    M.autoTPHeightBox = tpHBox

    -- PAGE: VISUALS
    uiSectionHeader(PVis, "SKY & VISION")
    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PVis; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,13,0,0); l.Size=UDim2.new(0.55,0,1,0)
        l.BackgroundTransparency=1; l.Text="Sky Theme"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=13; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local skyLbl = Instance.new("TextLabel"); skyLbl.Position=UDim2.new(0.55,0,0,0); skyLbl.Size=UDim2.new(0.45,-10,1,0)
        skyLbl.BackgroundTransparency=1; skyLbl.Text=M.currentSkyTheme; skyLbl.TextColor3=UI_ACCENT; skyLbl.Font=Enum.Font.GothamBold; skyLbl.TextSize=12; skyLbl.TextXAlignment=Enum.TextXAlignment.Right; skyLbl.Parent=r
        local skyIdx = 1
        for i,t in ipairs(M.SkyOrder) do if t == M.currentSkyTheme then skyIdx = i; break end end
        local btn = Instance.new("TextButton",r); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""
        btn.Activated:Connect(function()
            skyIdx = skyIdx % #M.SkyOrder + 1
            local t = M.SkyOrder[skyIdx]
            skyLbl.Text = t; M.currentSkyTheme = t; M.CandyApplyCustomSky(t); saveCherryConfig()
        end)
    end
    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PVis; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,13,0,0); l.Size=UDim2.new(0.55,0,1,0)
        l.BackgroundTransparency=1; l.Text="FOV"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=13; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local fovLbl = Instance.new("TextLabel"); fovLbl.Position=UDim2.new(0.55,0,0,0); fovLbl.Size=UDim2.new(0.45,-10,1,0)
        fovLbl.BackgroundTransparency=1; fovLbl.Text=tostring(M.fovValue); fovLbl.TextColor3=UI_ACCENT; fovLbl.Font=Enum.Font.GothamBold; fovLbl.TextSize=12; fovLbl.TextXAlignment=Enum.TextXAlignment.Right; fovLbl.Parent=r
        local fovIdx = 1
        local btn = Instance.new("TextButton",r); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""
        btn.Activated:Connect(function()
            fovIdx = fovIdx % #M.fovOptions + 1
            M.fovValue = M.fovOptions[fovIdx]; fovLbl.Text = tostring(M.fovValue); M.applyFOV(); saveCherryConfig()
        end)
    end

    uiSectionHeader(PVis, "COLOUR THEMES")
    do
        local themeNames = {}
        for name in pairs(CHERRY_THEMES) do table.insert(themeNames, name) end
        table.sort(themeNames)
        local cur = CherryConfig.Theme or M.colorScheme or "Purple"
        local idx = 1
        for i,n in ipairs(themeNames) do if n == cur then idx = i break end end

        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PVis; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,13,0,0); l.Size=UDim2.new(0.4,0,1,0)
        l.BackgroundTransparency=1; l.Text="Theme"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=13
        l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local themeLbl = Instance.new("TextLabel"); themeLbl.Position=UDim2.new(0.4,0,0,0); themeLbl.Size=UDim2.new(0.6,-10,1,0)
        themeLbl.BackgroundTransparency=1; themeLbl.Text=cur; themeLbl.TextColor3=UI_ACCENT
        themeLbl.Font=Enum.Font.GothamBold; themeLbl.TextSize=12; themeLbl.TextXAlignment=Enum.TextXAlignment.Right; themeLbl.Parent=r

        local sw = Instance.new("Frame"); sw.Size=UDim2.new(1,0,0,36); sw.BackgroundTransparency=1; sw.Parent=PVis
        local swLay = Instance.new("UIListLayout"); swLay.FillDirection=Enum.FillDirection.Horizontal
        swLay.Padding=UDim.new(0,6); swLay.VerticalAlignment=Enum.VerticalAlignment.Center; swLay.Parent=sw

        local function applyTheme(name)
            local t = CHERRY_THEMES[name]; if not t then return end
            CherryConfig.Theme = name
            M.colorScheme = name
            M._savedTheme = name
            applyAccentFromTheme()
            -- bg image stays untinted (no theme color on background)
            themeLbl.Text = name
            themeLbl.TextColor3 = t.Accent
            if M.mainFrame then
                M.mainFrame.BackgroundColor3 = UI_BG_DARK
                local st = M.mainFrame:FindFirstChild("MainStroke")
                if st then st.Color = t.Accent end
                M.applyCustomBackground(M.mainFrame)
            end
            pcall(function()
                if M.applyStealBarTheme then M.applyStealBarTheme(t.Accent) end
                if M.updateHeadTheme then M.updateHeadTheme() end
                -- Mobile buttons follow chosen UI colour + image tint
                if M.refreshMobileButtonTheme then M.refreshMobileButtonTheme() end
            end)
            saveCherryConfig()
        end

        for _, name in ipairs(themeNames) do
            local t = CHERRY_THEMES[name]
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0, 28, 0, 16)
            b.BackgroundColor3 = t.Accent
            b.Text = ""
            b.AutoButtonColor = false
            b.Parent = sw
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
            local st = Instance.new("UIStroke"); st.Color = Color3.fromRGB(255,255,255); st.Transparency = 0.4; st.Parent = b
            b.MouseButton1Click:Connect(function() applyTheme(name) end)
        end
        local btn = Instance.new("TextButton", r); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""
        btn.Activated:Connect(function()
            idx = idx % #themeNames + 1
            applyTheme(themeNames[idx])
        end)
        -- apply current tint to bg image on build
        pcall(function()
            local t = CHERRY_THEMES[cur]
            -- background image not tinted by theme
            if M.mainFrame then M.applyCustomBackground(M.mainFrame) end
        end)
    end

    uiSectionHeader(PVis, "ESP")
    local _, setLineESP = uiToggleRow(PVis, "Line ESP", M.lineESPEnabled, function(on)
        M.lineESPEnabled = on; cherryESPState.LineESP = on
        saveCherryConfig()
    end)
    local _, setHighlightESP = uiToggleRow(PVis, "Highlight ESP", cherryESPState.HighlightESP, function(on)
        cherryESPState.HighlightESP = on
        M.highlightESPEnabled = on
        saveCherryConfig()
    end)
    M.setHighlightESPVisual = setHighlightESP
    local _, setSpeedESP = uiToggleRow(PVis, "Speed ESP", M.speedESPEnabled, function(on)
        M.speedESPEnabled = on; cherryESPState.SpeedESP = on
        saveCherryConfig()
    end)

    -- PAGE: UTILITY
    uiSectionHeader(PUtil, "MISC")
    local _, setUnwalk = uiToggleRow(PUtil, "Unwalk", M.unwalkEnabled, function(on)
        M.unwalkEnabled = on
        if on then M.startUnwalk() else M.stopUnwalk() end
    end)
    M.setUnwalkVisual = setUnwalk

    local _, setAntiLag = uiToggleRow(PUtil, "Performance Mode", M.antiLagEnabled, function(on)
        M.antiLagEnabled = on
        if on then M.enableAntiLag() else M.disableAntiLag() end
        saveCherryConfig()
    end)
    M.setAntiLagVisual = setAntiLag

    local _, setAntiSummer = uiToggleRow(PUtil, "Anti Summer Base", M.antiSummerBaseEnabled, function(on)
        M.antiSummerBaseEnabled = on
        if on then M.enableAntiSummerBase() else M.disableAntiSummerBase() end
        saveCherryConfig()
    end)
    M.setAntiSummerVisual = setAntiSummer

    local _, setStretch = uiToggleRow(PUtil, "Wide View", M.stretchRezEnabled, function(on)
        M.stretchRezEnabled = on
        if on then M.enableStretchRez() else M.disableStretchRez() end
        saveCherryConfig()
    end)
    M.setStretchRezVisual = setStretch

    local _, setRemoveAcc = uiToggleRow(PUtil, "Remove Accessories", M.removeAccEnabled, function(on)
        M.removeAccEnabled = on
        if on then M.startRemoveAcc() else M.stopRemoveAcc() end
    end)

    local _, setAntiKick = uiToggleRow(PUtil, "Anti-Kick", M.antiKickEnabled, function(on)
        M.antiKickEnabled = on
        if on then M.enableAntiKick() else M.disableAntiKick() end
        saveCherryConfig()
    end)
    M.antiKickSetVisual = setAntiKick

    local _, setSafeMode = uiToggleRow(PUtil, "Safe Mode", M.safeModeEnabled, function(on)
        M.safeModeEnabled = on
        if on then M.enableSafeMode() else M.disableSafeMode() end
        saveCherryConfig()
    end)
    M.setSafeModeVisual = setSafeMode

    do
        local fontIdx = 1
        for i, n in ipairs(M.FONT_NAMES) do
            if n == (M.customFontSelected or "None") then fontIdx = i break end
        end
        local _, setFontUI = uiChoiceRow(PUtil, "Custom Font", M.FONT_NAMES, fontIdx, function(v)
            M.applyCustomFont(v)
            saveCherryConfig()
        end)
    end

    local _, setIntro = uiToggleRow(PUtil, "Intro Song", M.introSoundEnabled, function(on)
        M.introSoundEnabled = on
        if not on and introSoundInstance and introSoundInstance.IsPlaying then
            pcall(function() introSoundInstance:Stop() end)
        end
    end)

    local _, setIntroSongUI = uiChoiceRow(PUtil, "Intro Song Choice", {"Song 1","Song 2","Song 3"},
        M.introSongChoice or 3,
        function(v)
            local map = {["Song 1"]=1, ["Song 2"]=2, ["Song 3"]=3}
            M.introSongChoice = map[v] or 3
        end
    )

    local _, setIntroGUI = uiToggleRow(PUtil, "Intro GUI", M.introGUIEnabled, function(on)
        M.introGUIEnabled = on
    end)

    local _, setMobBtns = uiToggleRow(PUtil, "Mobile Buttons", M.mobileButtonsEnabled, function(on)
        M.mobileButtonsEnabled = on
        if on then M.buildMobileButtons() else M.destroyMobileButtons() end
        saveCherryConfig()
    end)

    local _, setCircleBtns = uiToggleRow(PUtil, "Circle Buttons", M.circleButtonsEnabled, function(on)
        M.circleButtonsEnabled = on
        if M.mobileButtonsEnabled then M.buildMobileButtons() end
        saveCherryConfig()
    end)
    M.setCircleBtnsVisual = setCircleBtns

    local _, setLockMob = uiToggleRow(PUtil, "TRAVAR MENU", M.mobileButtonsLocked == true, function(on)
        M.mobileButtonsLocked = on and true or false
        saveCherryConfig()
    end)
    M.setLockMobVisual = setLockMob

    local _, btnSzBox = uiNumberRow(PUtil, "Button Size", M.mobileButtonsSize, 40, 150, function(v)
        M.mobileButtonsSize = v
        if M.mobileButtonsEnabled then M.buildMobileButtons() end
    end)

    local _, menuScaleBox = uiNumberRow(PUtil, "Menu Scale", M.uiScale, 0.5, 2.0, function(v)
        M.uiScale = v
        if M.uiScaleRef then M.uiScaleRef.Scale = v end
        saveCherryConfig()
    end)

    uiActionRow(PUtil, "Reset Mobile Positions", function() M.resetMobilePositions() end)

    uiSectionHeader(PUtil, "CHARTER")
    local function setAnimToggle(packName, on)
        if on then
            M.animPackEnabled = true
            M.animPack = packName
            M.applyAnimPack(packName)
            if packName == "Vampire" and M.setAmazonAnimVisual then M.setAmazonAnimVisual(false) end
            if packName == "Amazon Unboxed" and M.setVampireAnimVisual then M.setVampireAnimVisual(false) end
        else
            if M.animPack == packName then
                M.animPackEnabled = false
                local char = player.Character
                if char then M.resetAnimations(char) end
            end
        end
        saveCherryConfig()
    end

    local _, setVampireAnim = uiToggleRow(PUtil, "Vampire Animation",
        M.animPackEnabled and M.animPack == "Vampire",
        function(on) setAnimToggle("Vampire", on) end)
    M.setVampireAnimVisual = setVampireAnim

    local _, setAmazonAnim = uiToggleRow(PUtil, "Amazon Unboxed Animation",
        M.animPackEnabled and M.animPack == "Amazon Unboxed",
        function(on) setAnimToggle("Amazon Unboxed", on) end)
    M.setAmazonAnimVisual = setAmazonAnim

    local _, setVyncSkin = uiToggleRow(PUtil, "Vync Skin", M.vyncSkinEnabled == true, function(on)
        M.setVyncSkin(on)
    end)
    M.setVyncSkinVisual = setVyncSkin

    local _, setHeadless = uiToggleRow(PUtil, "Headless", M.headlessEnabled, function(on)
        M.headlessEnabled = on
        M.applyHeadlessToChar(player.Character, on)
        saveCherryConfig()
    end)
    local _, setKorblox = uiToggleRow(PUtil, "Korblox", M.korbloxEnabled, function(on)
        M.korbloxEnabled = on
        M.applyKorbloxToChar(player.Character, on)
        saveCherryConfig()
    end)
    local _, setBlackSkin = uiToggleRow(PUtil, "SHADOW Black Skin", M.shadowBlackSkinEnabled ~= false, function(on)
        M.shadowBlackSkinEnabled = on
        if on and player.Character then M.applyShadowBlackSkin(player.Character) end
        saveCherryConfig()
    end)
    local _, setGirlAnim = uiToggleRow(PUtil, "Girl Animation (Bubbly)", M.animPackEnabled and M.animPack == "Bubbly", function(on)
        if on then
            M.animPackEnabled = true
            M.animPack = "Bubbly"
            M.applyAnimPack("Bubbly")
            if M.setVampireAnimVisual then M.setVampireAnimVisual(false) end
            if M.setAmazonAnimVisual then M.setAmazonAnimVisual(false) end
        else
            if M.animPack == "Bubbly" then
                M.animPackEnabled = false
                if player.Character then M.resetAnimations(player.Character) end
            end
        end
        saveCherryConfig()
    end)

    uiSectionHeader(PUtil, "PANELS")

    local _, setBypassPanel = uiToggleRow(PUtil, "Shadow Bypass", M.bypassPanelOpen == true, function(on)
        if M.setBypassPanelOpen then
            M.setBypassPanelOpen(on)
        else
            M.bypassPanelOpen = on and true or false
            if on and M.buildShadowBypassUI then
                M.buildShadowBypassUI()
                if M.bypassPanelMain then M.bypassPanelMain.Visible = true end
            elseif M.bypassPanelMain then
                M.bypassPanelMain.Visible = false
                if M.bypassPanelMini then M.bypassPanelMini.Visible = false end
            end
        end
        pcall(saveCherryConfig)
    end)
    M.setBypassPanelVisual = setBypassPanel
    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PUtil; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-74,1,0)
        l.BackgroundTransparency=1; l.Text="Save Config"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local sBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-80,0.5,-13), Size=UDim2.new(0,68,0,26),
            Text="SAVE", Col=Color3.fromRGB(40, 40, 40), TS=12, CR=6, SC=Color3.fromRGB(0, 0, 0), STr=0.2})
        sBtn.Activated:Connect(function()
            saveCherryConfig()
            sBtn.Text = "OK"
            task.delay(0.8, function() if sBtn and sBtn.Parent then sBtn.Text = "SAVE" end end)
        end)
    end
    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PUtil; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-74,1,0)
        l.BackgroundTransparency=1; l.Text="Reset All Settings"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local rBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-80,0.5,-13), Size=UDim2.new(0,68,0,26),
            Text="RESET", Col=Color3.fromRGB(40, 40, 40), TS=12, CR=6, SC=Color3.fromRGB(0, 0, 0), STr=0.2})
        rBtn.Activated:Connect(function() M.resetAllSettings() end)
    end

    -- PAGE: KEYBINDS
    uiSectionHeader(PKB, "KEYBINDS")
    uiKeybindRow(PKB, "Hide GUI", M.KB.GuiHide, "GuiHide")
    uiKeybindRow(PKB, "Carry Mode", M.KB.SpeedToggle, "SpeedToggle")
    uiKeybindRow(PKB, "Lagger Mode", M.KB.LaggerToggle, "LaggerToggle")
    uiKeybindRow(PKB, "Bat Aimbot", M.KB.AutoBat, "AutoBat")
    uiKeybindRow(PKB, "TP Bat", M.KB.BypassAimbot, "BypassAimbot")
    uiKeybindRow(PKB, "Auto Left", M.KB.AutoLeft, "AutoLeft")
    uiKeybindRow(PKB, "Auto Right", M.KB.AutoRight, "AutoRight")
    uiKeybindRow(PKB, "Drop Brainrot", M.KB.DropBrainrot, "DropBrainrot")
    uiKeybindRow(PKB, "TP Down", M.KB.TPFloor, "TPFloor")
    uiKeybindRow(PKB, "Ping Lagger", M.KB.PingLagger, "PingLagger")
    uiKeybindRow(PKB, "Insta Reset", M.KB.InstaReset, "InstaReset")


    -- Restore menu open/closed from config
    do
        local open = M.menuOpen ~= false
        Frame.Visible = open
        MinPill.Visible = not open
        M.menuOpen = open
    end

    -- APPLY INITIAL STATES
    M.applyStealBarTheme(CHERRY_ACCENT)
    M.updateHeadTheme()
    M.applyFOV()

    -- FPS / Ping header updater
    task.spawn(function()
        local last = tick()
        local frames = 0
        local fps = 60
        RunService.RenderStepped:Connect(function()
            frames = frames + 1
            local now = tick()
            if now - last >= 0.5 then
                fps = math.floor(frames / (now - last) + 0.5)
                frames = 0
                last = now
                if M.headerStatsLbl then
                    local ping = 0
                    pcall(function()
                        ping = math.floor(player:GetNetworkPing() * 1000 + 0.5)
                    end)
                    M.headerStatsLbl.Text = string.format("FPS: %d  Ping: %dms", fps, ping)
                end
                if M.headerRadiusLbl and M.getActiveStealRadius then
                    M.headerRadiusLbl.Text = tostring(M.getActiveStealRadius())
                end
            end
        end)
    end)

    M.autoTPHeightBox = tpHBox
    M.radInput = srBox
    M.durationBox = sdBox
    M.btnSzBox = btnSzBox
    M.sbBox = sbBox

    if M.setAntiRagVisual then M.setAntiRagVisual(M.antiRagdollEnabled) end
        if M.setSafeModeVisual then M.setSafeModeVisual(M.safeModeEnabled) end
    if M.setAutoCarryVisual then M.setAutoCarryVisual(M.autoSwitchSpeedEnabled) end
if M.setCircleBtnsVisual then M.setCircleBtnsVisual(M.circleButtonsEnabled) end
    -- re-apply saved font after GUI rebuild
    if M.customFontSelected and M.customFontSelected ~= "None" then
        task.defer(function() pcall(function() M.applyCustomFont(M.customFontSelected) end) end)
    end
    if M.safeModeEnabled then M.enableSafeMode() end
    if M.antiKickEnabled then M.enableAntiKick() end

    if M.setAntiRagModeUI then M.setAntiRagModeUI(M.antiRagdollMode == "No Splatter" and "No Splatter" or "Splatter") end
    if M.setInfJumpVisual then M.setInfJumpVisual(M.infJumpEnabled) end
    if M.setMedusaVisual then M.setMedusaVisual(M.medusaCounterEnabled) end
    if M.setMedusaResetVisual then M.setMedusaResetVisual(M.medusaResetEnabled) end
    if M.setBatCounterVisual then M.setBatCounterVisual(M.batCounterEnabled) end
    if M.setUnwalkVisual then M.setUnwalkVisual(M.unwalkEnabled) end
    if M.setAntiLagVisual then M.setAntiLagVisual(M.antiLagEnabled) end
    if M.setAntiSummerVisual then M.setAntiSummerVisual(M.antiSummerBaseEnabled) end
    if M.setStretchRezVisual then M.setStretchRezVisual(M.stretchRezEnabled) end
    if M.setAutoTPVisual then M.setAutoTPVisual(M.autoTPEnabled) end
    if M.antiKickSetVisual then M.antiKickSetVisual(M.antiKickEnabled) end
    if M.setInstaGrab then M.setInstaGrab(M.Steal.AutoStealEnabled) end
    if M.setAutoRadiusVisual then M.setAutoRadiusVisual(M.autoRadiusEnabled) end
    if M.autoBatSetVisual then M.autoBatSetVisual(M.autoBatEnabled) end
    if M.autoLeftSetVisual then M.autoLeftSetVisual(M.autoLeftEnabled) end
    if M.autoRightSetVisual then M.autoRightSetVisual(M.autoRightEnabled) end
    if M.setAutoSwingVisual then M.setAutoSwingVisual(M.autoSwingEnabled) end
    if M.setBypassVisual then M.setBypassVisual(M.bypassAimbotEnabled) end
    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(M.autoBatEnabled) end
    if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(M.autoLeftEnabled) end
    if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(M.autoRightEnabled) end
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(M.bypassAimbotEnabled) end
    if M.setAutoResetOnDeath then M.setAutoResetOnDeath(M.autoResetOnDeath) end
    if M.headlessEnabled then M.applyHeadlessToChar(player.Character, true) end
    if M.korbloxEnabled then M.applyKorbloxToChar(player.Character, true) end
    if M.setStealModeUI then
        local lab = (M.stealMode == "Semi") and "Semi" or "V2"
        M.setStealModeUI(lab)
    end
    if M.setJumpModeUI then M.setJumpModeUI(M.infJumpMode == "hold" and "Hold" or "Manual") end
    if M.setTpBatModeUI then M.setTpBatModeUI(M.tpBatHitMode == "Normal" and "Normal Hit" or "Sure Hit") end
    if M.setVampireAnimVisual then M.setVampireAnimVisual(M.animPackEnabled and M.animPack == "Vampire") end
    if M.setAmazonAnimVisual then M.setAmazonAnimVisual(M.animPackEnabled and M.animPack == "Amazon Unboxed") end
    if M.animPackEnabled then
        task.wait(0.5); M.applyAnimPack(M.animPack)
    else
        local char = player.Character; if char then M.resetAnimations(char) end
    end

    cherryESPState.LineESP = M.lineESPEnabled
    cherryESPState.SpeedESP = M.speedESPEnabled
    cherryESPState.HighlightESP = M.highlightESPEnabled == true

    M.updateStatusRadius()
    M.startHeadSpeedUpdates()
end

function M.applyStealBarTheme(accentColor)
    local red = Color3.fromRGB(0, 60, 220)
    if M.statusFill then
        M.statusFill.BackgroundColor3 = red
        local grad = M.statusFill:FindFirstChild("FillColorGrad")
        if grad and grad:IsA("UIGradient") then
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 80, 255)),
                ColorSequenceKeypoint.new(0.5, red),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 60, 140)),
            })
        end
    end
    if M.statusMain then
        M.statusMain.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        M.statusMain.BackgroundTransparency = 0.08
    end
    if M.statusBgImg then
        M.statusBgImg.Visible = false
    end
end


function M.resetAllSettings()
    M.NS = 60
    M.CS = 30
    M.LAGGER_SPEED = 22
    M.LAGGER_CARRY_SPEED = 22
    M.BYPASS_SPEED = 40
    M.BYPASS_CARRY_SPEED = 22
    M.speedMethod = "Velocity"
    M.hyperMult = 4
    M._lastSpeedMethod = nil
    M._anchoredBySpeed = nil
    M.carrySpeedActive = false
    M.laggerModeEnabled = false
    M.laggerCarryActive = false
    M.antiRagdollEnabled = false
M.hardHitEnabled = false
M.hardHitRadius = 10
    M.antiRagdollMode = "Splatter"
    M.infJumpEnabled = false
    M.infJumpMode = "manual"
    M.medusaCounterEnabled = false
    M.batCounterEnabled = false
    M.unwalkEnabled = false
    M.medusaResetEnabled = false
    M.medusaDebounce = false
    M.medusaLastUsed = 0
    M.autoLeftEnabled = false
    M.autoRightEnabled = false
    M.autoBatEnabled = false
    M.autoSwingEnabled = true
    M.autoMoveSwingEnabled = false
    M.antiLagEnabled = false
    M.removeAccessoriesEnabled = false
    M.stretchRezEnabled = false
    M.autoTPEnabled = false
    M.autoTPHeight = 20
    M.guiTransparencyEnabled = false
    M.mobileButtonsEnabled = true
    M.mobileButtonsSize = 100
    M.circleButtonsEnabled = false
    M.fovValue = 80
    M.fovIndex = 1
    M.autoSwitchSpeedEnabled = false
    M.antiKickEnabled = false
    M.brainrotDetected = false
    M.ragdollGuiEnabled = true
    M.introSoundEnabled = true
    M.introSongChoice = 3
    M.introGUIEnabled = true
    M.Steal.AutoStealEnabled = false
    M.autoRadiusEnabled = false
    M.Steal.StealRadius = 60
    M.Steal.StealDuration = 1.4
    M.Steal.StopTime = 0.35
    M.stealMode = "V2"
    M.Semi.holdMin = 1.3
    M.Semi.holdMax = 2.6
    M.Semi.entryDelay = 0.3
    M.Semi.radius = 10
    M.Semi.primeRange = 80
    M.removeAccEnabled = false
    M.playerESPEnabled = false
    M.showPlayerSpeeds = false
    M.uiScale = 0.60
    M.perButtonDragEnabled = true
    M.stealBarSize = 460
    M.lineESPEnabled = false
    M.speedESPEnabled = false
    M.autoResetOnDeath = false
    M.animPack = "Vampire"
    M.headlessEnabled = false
    M.korbloxEnabled = false
    M.bypassAimbotEnabled = false
    M.animPackEnabled = false

    M.stopAutoSteal()
    M.stopBatAimbot()
    M.stopAutoLeft()
    M.stopAutoRight()
    M.stopAntiRagdoll()
    M.stopHoldInfJump()
    M.stopManualInfJumpLoop()
    M.stopMedusaCounter()
    M.stopBatCounter()
    M.stopUnwalk()
    M.disableAntiLag()
    M.disableStretchRez()
    M.stopAutoTP()
    M.disableAntiKick()
    M.stopBypassAimbot()
    M.stopRemoveAcc()
    M.toggleESP(false)
    M.togglePlayerSpeeds(false)
    M.autoResetOnDeath = false
    setupDeathReset()

    saveCherryConfig()
    M.buildGui()
end

-- ============================================================
-- INITIALIZATION
-- ============================================================
repeat task.wait() until game:IsLoaded()
task.wait(0.5)
loadCherryConfig()
if M._savedTheme and CHERRY_THEMES[M._savedTheme] then
    CherryConfig.Theme = M._savedTheme
    M.colorScheme = M._savedTheme
elseif M.colorScheme and CHERRY_THEMES[M.colorScheme] then
    CherryConfig.Theme = M.colorScheme
    M._savedTheme = M.colorScheme
end
applyAccentFromTheme()
pcall(saveCherryConfig)
M.buildGui() -- applies M.menuOpen (closed stays closed)
pcall(function()
    if M.applyStealBarTheme then M.applyStealBarTheme(UI_ACCENT) end
    if M.updateHeadTheme then M.updateHeadTheme() end
    if M.mainFrame then M.recolorBlacksToTheme(M.mainFrame) end
    -- keep auto steal pure black
end)
if M.mobileButtonsEnabled then M.buildMobileButtons() end
if M.antiRagdollEnabled then M.startAntiRagdoll() end
    if M.hardHitEnabled then M.startHardHit() end
    if M.setHardHitVisual then M.setHardHitVisual(M.hardHitEnabled) end
if M.infJumpEnabled then
    if M.infJumpMode=="manual" then M.startManualInfJumpLoop()
    elseif M.infJumpMode=="hold" then M.startHoldInfJump() end
end
if M.medusaCounterEnabled then M.setupMedusa(player.Character) end
if M.batCounterEnabled then M.startBatCounter() end
if M.unwalkEnabled then M.startUnwalk() end
if M.autoTPEnabled then M.startAutoTP() end
if M.autoBatEnabled then M.queueAutoBatStart() end
if M.autoLeftEnabled then M.startAutoLeft() end
if M.autoRightEnabled then M.startAutoRight() end
if M.Steal.AutoStealEnabled then M.startAutoSteal() end
if M.bypassAimbotEnabled then M.startBypassAimbot() end
if M.antiKickEnabled then M.enableAntiKick() end
if M.antiLagEnabled then M.enableAntiLag() end
if M.antiSummerBaseEnabled then M.enableAntiSummerBase() end
if M.stretchRezEnabled then M.enableStretchRez() end
if M.removeAccEnabled then M.startRemoveAcc() end
-- autoResetOnDeath removed

if M.playerESPEnabled and M.toggleESP then
    task.defer(function() pcall(function() M.toggleESP(true) end) end)
end
if M.animPackEnabled and M.animPack and M.PACKS[M.animPack] then
    task.wait(0.5)
    M.applyAnimPack(M.animPack)
else
    local char = player.Character
    if char then
        M.resetAnimations(char)
    end
end

if M.headlessEnabled or M.korbloxEnabled then
    task.wait(0.3)
    M.applyCharterToChar(player.Character)
end

M.CandyApplyCustomSky(M.currentSkyTheme)
if M.showPlayerSpeeds then M.togglePlayerSpeeds(true) end
if M.playerESPEnabled then M.toggleESP(true) end

M.updateStatusRadius()
M.startHeadSpeedUpdates()

if player.Character then
    M.setupHeadIndicator(player.Character)
    M.setupRagdollTriggers()
end
player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    M.setupHeadIndicator(char)
    if M.hardHitEnabled then task.defer(function() M.hideHardHitRing(); M.showHardHitRing() end) end
    M.setupRagdollTriggers()
    if M.medusaCounterEnabled then M.setupMedusa(char) end
    if M.batCounterEnabled then M.startBatCounter() end
    if M.unwalkEnabled then task.wait(0.5); M.startUnwalk() end
    -- autoResetOnDeath removed
    if M.animPackEnabled and M.animPack and M.PACKS[M.animPack] then
        task.wait(0.2)
        M.applyAnimPack(M.animPack)
    else
        M.resetAnimations(char)
    end
    if M.headlessEnabled or M.korbloxEnabled then
        task.wait(0.2)
        M.applyCharterToChar(char)
    end
    if M.bypassAimbotEnabled then
        task.wait(0.2)
        M.startBypassAimbot()
    end
end)

-- Lightweight no-collide (no GetDescendants every frame — avoids lag/ping spikes)
do
    local _ncAcc = 0
    RunService.Heartbeat:Connect(function(dt)
        _ncAcc = _ncAcc + dt
        if _ncAcc < 0.35 then return end
        _ncAcc = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CanCollide = false end
                local head = p.Character:FindFirstChild("Head")
                if head then head.CanCollide = false end
            end
        end
    end)
end

local function destroySpeedObjects()
    if M._anchoredBySpeed then pcall(function() M._anchoredBySpeed.Anchored = false end); M._anchoredBySpeed = nil end
    if M._bodyVel then pcall(function() M._bodyVel:Destroy() end); M._bodyVel = nil end
    if M._bodyPosition then pcall(function() M._bodyPosition:Destroy() end); M._bodyPosition = nil end
    if M._bodyForce then pcall(function() M._bodyForce:Destroy() end); M._bodyForce = nil end
    if M._bodyThrust then pcall(function() M._bodyThrust:Destroy() end); M._bodyThrust = nil end
    if M._linearVel then pcall(function() M._linearVel:Destroy() end); M._linearVel = nil end
    if M._vectorForce then pcall(function() M._vectorForce:Destroy() end); M._vectorForce = nil end
    if M._alignPos then pcall(function() M._alignPos:Destroy() end); M._alignPos = nil end
    if M._rocket then pcall(function() M._rocket:Destroy() end); M._rocket = nil end
    if M._rocketTarget then pcall(function() M._rocketTarget:Destroy() end); M._rocketTarget = nil end
    if M._attLinVel then pcall(function() M._attLinVel:Destroy() end); M._attLinVel = nil end
    if M._attVecForce then pcall(function() M._attVecForce:Destroy() end); M._attVecForce = nil end
    if M._attAlign then pcall(function() M._attAlign:Destroy() end); M._attAlign = nil end
    if M._speedTween then pcall(function() M._speedTween:Cancel() end); M._speedTween = nil end
end

local function ensureSpeedAttachment(hrp, key, name)
    local att = M[key]
    if not att or att.Parent ~= hrp then
        if att then pcall(function() att:Destroy() end) end
        att = Instance.new("Attachment")
        att.Name = name or "MoveeSpeedAtt"
        att.Parent = hrp
        M[key] = att
    end
    return att
end

local function applySpeedMethod(hrp, hum, dir, spd, dt)
    local step = dt or 1/60
    local m = M.speedMethod
    if M._lastSpeedMethod ~= m then
        destroySpeedObjects()
        if m ~= "WalkSpeed" and hum.WalkSpeed ~= 16 then hum.WalkSpeed = 16 end
        M._lastSpeedMethod = m
    end
    local char = hrp.Parent
    local targetPos = hrp.Position + (dir * spd * step)

    local function massImpulse(direction, targetSpeed)
        local mass = hrp.AssemblyMass or 1
        local current = hrp.AssemblyLinearVelocity
        local desired = Vector3.new(direction.X * targetSpeed, current.Y, direction.Z * targetSpeed)
        local delta = desired - current
        pcall(function() hrp:ApplyImpulse(Vector3.new(delta.X, 0, delta.Z) * mass) end)
    end

    if m == "Velocity" then
        massImpulse(dir, spd)
    elseif m == "AssemblyLinearVelocity" then
        massImpulse(dir, spd)
    elseif m == "Velocity Lerp" then
        local current = hrp.AssemblyLinearVelocity
        local desired = Vector3.new(dir.X*spd, current.Y, dir.Z*spd)
        local blended = current:Lerp(desired, 0.6)
        local mass = hrp.AssemblyMass or 1
        pcall(function() hrp:ApplyImpulse(Vector3.new(blended.X - current.X, 0, blended.Z - current.Z) * mass) end)
    elseif m == "AssemblyLinearVelocity Lerp" then
        local current = hrp.AssemblyLinearVelocity
        local desired = Vector3.new(dir.X*spd, current.Y, dir.Z*spd)
        local blended = current:Lerp(desired, 0.6)
        local mass = hrp.AssemblyMass or 1
        pcall(function() hrp:ApplyImpulse(Vector3.new(blended.X - current.X, 0, blended.Z - current.Z) * mass) end)
    elseif m == "CFrame" then
        hrp.CFrame = hrp.CFrame + (dir * spd * step)
    elseif m == "CFrame Lerp" then
        hrp.CFrame = hrp.CFrame:Lerp(hrp.CFrame + (dir * spd * step), 0.5)
    elseif m == "Hyper CFrame" then
        hrp.CFrame = hrp.CFrame + (dir * spd * (M.hyperMult or 4) * step)
    elseif m == "Anchored CFrame" then
        if not hrp.Anchored then
            hrp.Anchored = true
            M._anchoredBySpeed = hrp
        end
        hrp.CFrame = hrp.CFrame + (dir * spd * step)
    elseif m == "PivotTo" then
        hrp:PivotTo(hrp.CFrame + (dir * spd * step))
    elseif m == "Model PivotTo" then
        if char and char:IsA("Model") then
            char:PivotTo(char:GetPivot() + (dir * spd * step))
        else
            hrp:PivotTo(hrp.CFrame + (dir * spd * step))
        end
    elseif m == "Tween CFrame" then
        if M._speedTween then pcall(function() M._speedTween:Cancel() end) end
        M._speedTween = TweenService:Create(hrp, TweenInfo.new(step, Enum.EasingStyle.Linear), {CFrame = hrp.CFrame + (dir * spd * step)})
        M._speedTween:Play()
    elseif m == "WalkSpeed" then
        hum.WalkSpeed = spd
    elseif m == "Humanoid Move" then
        hum.WalkSpeed = spd
        hum:Move(dir)
    elseif m == "Humanoid MoveTo" then
        hum:MoveTo(targetPos, hrp)
    elseif m == "BodyVelocity" then
        if not M._bodyVel or M._bodyVel.Parent ~= hrp then
            if M._bodyVel then pcall(function() M._bodyVel:Destroy() end) end
            M._bodyVel = Instance.new("BodyVelocity")
            M._bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            M._bodyVel.Parent = hrp
        end
        M._bodyVel.Velocity = Vector3.new(dir.X*spd, M._bodyVel.Velocity.Y, dir.Z*spd)
    elseif m == "BodyPosition" then
        if not M._bodyPosition or M._bodyPosition.Parent ~= hrp then
            if M._bodyPosition then pcall(function() M._bodyPosition:Destroy() end) end
            M._bodyPosition = Instance.new("BodyPosition")
            M._bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            M._bodyPosition.P = 500
            M._bodyPosition.D = 50
            M._bodyPosition.Parent = hrp
        end
        M._bodyPosition.Position = targetPos
    elseif m == "BodyForce" then
        if not M._bodyForce or M._bodyForce.Parent ~= hrp then
            if M._bodyForce then pcall(function() M._bodyForce:Destroy() end) end
            M._bodyForce = Instance.new("BodyForce")
            M._bodyForce.Parent = hrp
        end
        M._bodyForce.Force = Vector3.new(dir.X*spd, 0, dir.Z*spd) * 100
    elseif m == "BodyThrust" then
        if not M._bodyThrust or M._bodyThrust.Parent ~= hrp then
            if M._bodyThrust then pcall(function() M._bodyThrust:Destroy() end) end
            M._bodyThrust = Instance.new("BodyThrust")
            M._bodyThrust.Force = Vector3.new(math.huge, math.huge, math.huge)
            M._bodyThrust.Parent = hrp
        end
        M._bodyThrust.Force = Vector3.new(dir.X*spd, 0, dir.Z*spd) * 100
    elseif m == "LinearVelocity" then
        if not M._linearVel or M._linearVel.Parent ~= hrp then
            if M._linearVel then pcall(function() M._linearVel:Destroy() end) end
            local att = ensureSpeedAttachment(hrp, "_attLinVel", "MoveeLinVelAtt")
            M._linearVel = Instance.new("LinearVelocity")
            M._linearVel.Attachment0 = att
            M._linearVel.MaxForce = 1e8
            M._linearVel.RelativeTo = Enum.ActuatorRelativeTo.World
            M._linearVel.Parent = hrp
        end
        M._linearVel.VectorVelocity = Vector3.new(dir.X*spd, M._linearVel.VectorVelocity.Y, dir.Z*spd)
    elseif m == "VectorForce" then
        if not M._vectorForce or M._vectorForce.Parent ~= hrp then
            if M._vectorForce then pcall(function() M._vectorForce:Destroy() end) end
            local att = ensureSpeedAttachment(hrp, "_attVecForce", "MoveeVecForceAtt")
            M._vectorForce = Instance.new("VectorForce")
            M._vectorForce.Attachment0 = att
            M._vectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
            M._vectorForce.Parent = hrp
        end
        M._vectorForce.Force = Vector3.new(dir.X*spd, 0, dir.Z*spd) * 100
    elseif m == "AlignPosition" then
        if not M._alignPos or M._alignPos.Parent ~= hrp then
            if M._alignPos then pcall(function() M._alignPos:Destroy() end) end
            local att = ensureSpeedAttachment(hrp, "_attAlign", "MoveeAlignAtt")
            M._alignPos = Instance.new("AlignPosition")
            M._alignPos.Attachment0 = att
            M._alignPos.Mode = Enum.PositionAlignmentMode.OneAttachment
            M._alignPos.MaxForce = math.huge
            M._alignPos.Responsiveness = 15
            M._alignPos.RigidityEnabled = false
            M._alignPos.Parent = hrp
        end
        M._alignPos.Position = targetPos
    elseif m == "ApplyImpulse" then
        local mass = hrp.AssemblyMass or 1
        local current = hrp.AssemblyLinearVelocity
        local desired = Vector3.new(dir.X * spd, current.Y, dir.Z * spd)
        local delta = desired - current
        pcall(function() hrp:ApplyImpulse(Vector3.new(delta.X, 0, delta.Z) * mass) end)
    elseif m == "RocketPropulsion" then
        if not M._rocket or M._rocket.Parent ~= hrp or not M._rocketTarget then
            if M._rocket then pcall(function() M._rocket:Destroy() end) end
            if M._rocketTarget then pcall(function() M._rocketTarget:Destroy() end) end
            M._rocketTarget = Instance.new("Part")
            M._rocketTarget.Name = "MoveeRocketTarget"
            M._rocketTarget.Anchored = true
            M._rocketTarget.CanCollide = false
            M._rocketTarget.Transparency = 1
            M._rocketTarget.Size = Vector3.new(1,1,1)
            M._rocketTarget.Parent = workspace
            M._rocket = Instance.new("RocketPropulsion")
            M._rocket.MaxThrust = 3000
            M._rocket.MaxTorque = 1000
            M._rocket.ThrustP = 100
            M._rocket.ThrustD = 20
            M._rocket.TurnP = 100
            M._rocket.TurnD = 10
            M._rocket.Target = M._rocketTarget
            M._rocket.Parent = hrp
        end
        M._rocketTarget.Position = targetPos
        pcall(function() M._rocket:Fire() end)
    end
end

RunService.RenderStepped:Connect(function(dt)
    local char=player.Character; if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid"); local hrp=char:FindFirstChild("HumanoidRootPart"); if not hum or not hrp then return end
    if M.isRagdollState(hum) then M.lastMoveDir=Vector3.new(0,0,0); destroySpeedObjects(); return end
    if not M.autoBatEnabled and not M.autoLeftEnabled and not M.autoRightEnabled then
        M.updateAutoSwitchSpeed()
        local md=hum.MoveDirection; local spd=M.getActiveMoveSpeed()
        local dir = Vector3.new(0,0,0)
        if md.Magnitude>0 then
            M.lastMoveDir=md; dir=md
        elseif M.antiRagdollEnabled and M.lastMoveDir.Magnitude>0 then
            local anyHeld=false; for key in pairs(M.MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld=true; break end end
            if anyHeld then dir=M.lastMoveDir end
        end
        if dir.Magnitude>0 then
            applySpeedMethod(hrp, hum, dir, spd, dt)
        else
            destroySpeedObjects()
        end
    end
end)

task.spawn(function()
    local BLACKLIST_URL="https://pastebin.com/2zLUXv2K"
    pcall(function() HS.HttpEnabled=true end)
    while task.wait(30) do
        pcall(function()
            local r=game:HttpGet(BLACKLIST_URL)
            if r and string.find(r,tostring(player.UserId),1,true) then player:Kick("You have been removed for cheating | CODE: BAC-1633") end
        end)
    end
end)

pcall(function()
    if hookfunction and newcclosure then
        local oldFire
        oldFire=hookfunction(Instance.new("RemoteEvent").FireServer,newcclosure(function(self,...)
            if not M.cursedResetRemote and typeof(self)=="Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3)=="RE/" then M.cursedResetRemote=self end
            return oldFire(self,...)
        end))
    end
end)
task.spawn(function()
    task.wait(2); if M.cursedResetRemote then return end
    for _,desc in ipairs(game:GetDescendants()) do
        if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then M.cursedResetRemote=desc; break end
    end
end)

task.spawn(function()
    while task.wait(5) do saveCherryConfig() end
end)

M.applyFOV()
task.spawn(function()
    while true do
        task.wait(2)
        pcall(M.saveBtnPositions)
    end
end)

task.spawn(function()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then plots = workspace:WaitForChild("Plots",10) end
    if plots then
        for _,plot in ipairs(plots:GetChildren()) do
            if plot:IsA("Model") then scanPlotNormal(plot) end
        end
        plots.ChildAdded:Connect(function(plot)
            if plot:IsA("Model") then task.wait(0.5); scanPlotNormal(plot) end
        end)
        while true do
            task.wait(5)
            M.animalCache={}; M.promptCache={}; M.stealCache={}
            for _,plot in ipairs(plots:GetChildren()) do
                if plot:IsA("Model") then scanPlotNormal(plot) end
            end
        end
    end
end)

task.spawn(function()
    M.initSemiSync()
    while true do
        task.wait(5)
        if M.Semi.enabled or M.stealMode == "Semi" then
            pcall(M.scanAllPlotsSemi)
        end
    end
end)

function M.refreshSpeedModeLabel()
    -- not used
end

pcall(function()
    M.refreshWalkSpeedAutoSwitch()
    if M.customFontSelected and M.customFontSelected ~= "None" then
        task.spawn(function()
            task.wait(0.4)
            pcall(function() M.applyCustomFont(M.customFontSelected) end)
        end)
    end
end)

-- ============================================================
-- INTRO (red + black contours)
-- ============================================================
function M.playIntro()
    if M.introGUIEnabled == false and M.introSoundEnabled == false then
        return
    end

    -- ============================================================
    -- SHADOW DUELS INTRO (Shadow.VS-style) — fixed song, ~4 seconds
    -- ============================================================
    local TweenService = game:GetService("TweenService")
    local SoundService = game:GetService("SoundService")
    local player = Players.LocalPlayer
    local PlayerGui = player:WaitForChild("PlayerGui")

    local MUSIC_URL = M.INTRO_MUSIC_URL or "https://files.catbox.moe/qhpfe5.mp3"
    local MUSIC_FILE = M.INTRO_MUSIC_FILE or "ShadowIntro_Music.mp3"
    local MUSIC_VOLUME = 0.75
    local BPM = 100
    local BEAT = 60 / BPM

    local DEFAULT_BG = tonumber(M.customBgId) or tonumber(M.DEFAULT_BG_ID) or 88039161387070
    local IMAGE_ID = "rbxassetid://" .. tostring(DEFAULT_BG)

    for _, name in ipairs({"ShadowVSIntro", "ShadowDuelsIntro", "ShadowIntro"}) do
        pcall(function()
            local old = PlayerGui:FindFirstChild(name)
            if old then old:Destroy() end
        end)
        pcall(function()
            if gethui then
                local h = gethui()
                local old = h and h:FindFirstChild(name)
                if old then old:Destroy() end
            end
        end)
        pcall(function()
            local cg = game:GetService("CoreGui")
            local old = cg:FindFirstChild(name)
            if old then old:Destroy() end
        end)
    end

    local function loadFixedIntroMusic()
        local asset
        pcall(function()
            if isfile and isfile(MUSIC_FILE) and getcustomasset then
                asset = getcustomasset(MUSIC_FILE)
            end
        end)
        if not asset then
            local ok, data = pcall(function()
                return game:HttpGet(MUSIC_URL)
            end)
            if ok and data and #data > 1000 then
                pcall(function()
                    if writefile then writefile(MUSIC_FILE, data) end
                end)
                pcall(function()
                    if getcustomasset then asset = getcustomasset(MUSIC_FILE) end
                end)
            end
        end
        return asset
    end

    local function playFixedSong()
        if M.introSoundEnabled == false then return nil end
        if introSoundInstance then
            pcall(function() introSoundInstance:Stop() end)
            pcall(function() introSoundInstance:Destroy() end)
            introSoundInstance = nil
        end
        local asset = loadFixedIntroMusic()
        if not asset then return nil end
        local snd = Instance.new("Sound")
        snd.Name = "ShadowIntroMusic"
        snd.SoundId = asset
        snd.Volume = MUSIC_VOLUME
        snd.Looped = false
        snd.Parent = SoundService
        pcall(function() snd:Play() end)
        introSoundInstance = snd
        return snd
    end

    if M.introGUIEnabled == false then
        playFixedSong()
        return
    end

    local introActive = true
    local introFinished = false
    local introSound = nil

    local gui = Instance.new("ScreenGui")
    gui.Name = "ShadowDuelsIntro"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local parented = false
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(gui) end
    end)
    if gethui then
        parented = pcall(function() gui.Parent = gethui() end)
    end
    if not parented then
        parented = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    end
    if not parented or not gui.Parent then
        gui.Parent = PlayerGui
    end

    local background = Instance.new("Frame")
    background.Size = UDim2.fromScale(1, 1)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BorderSizePixel = 0
    background.ClipsDescendants = true
    background.Parent = gui

    local image = Instance.new("ImageLabel")
    image.AnchorPoint = Vector2.new(0.5, 0.5)
    image.Position = UDim2.fromScale(0.5, 0.5)
    image.Size = UDim2.fromScale(1.06, 1.06)
    image.BackgroundTransparency = 1
    image.Image = IMAGE_ID
    image.ImageTransparency = 1
    image.ScaleType = Enum.ScaleType.Crop
    image.ZIndex = 1
    image.Parent = background

    local dark = Instance.new("Frame")
    dark.Size = UDim2.fromScale(1, 1)
    dark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    dark.BackgroundTransparency = 0.25
    dark.BorderSizePixel = 0
    dark.ZIndex = 2
    dark.Parent = background

    local skip = Instance.new("TextButton")
    skip.AnchorPoint = Vector2.new(1, 0)
    skip.Position = UDim2.new(1, -14, 0, 14)
    skip.Size = UDim2.fromOffset(105, 36)
    skip.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    skip.BackgroundTransparency = 0.15
    skip.BorderSizePixel = 0
    skip.Text = "SKIP INTRO"
    skip.TextColor3 = Color3.fromRGB(255, 255, 255)
    skip.TextSize = 12
    skip.Font = Enum.Font.GothamBold
    skip.AutoButtonColor = false
    skip.ZIndex = 500
    skip.Parent = gui
    Instance.new("UICorner", skip).CornerRadius = UDim.new(0, 7)
    do
        local skipStroke = Instance.new("UIStroke")
        skipStroke.Color = Color3.fromRGB(255, 255, 255)
        skipStroke.Transparency = 0.75
        skipStroke.Thickness = 1
        skipStroke.Parent = skip
    end

    local flash = Instance.new("Frame")
    flash.Size = UDim2.fromScale(1, 1)
    flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    flash.BackgroundTransparency = 1
    flash.BorderSizePixel = 0
    flash.ZIndex = 400
    flash.Parent = gui

    local introTitle = Instance.new("TextLabel")
    introTitle.AnchorPoint = Vector2.new(0.5, 0.5)
    introTitle.Position = UDim2.fromScale(0.5, 0.5)
    introTitle.Size = UDim2.fromScale(1.0, 0.20)
    introTitle.BackgroundTransparency = 1
    introTitle.Text = "SHADOW DUELSSS"
    introTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    introTitle.TextTransparency = 1
    introTitle.TextScaled = true
    introTitle.Font = Enum.Font.GothamBlack
    introTitle.ZIndex = 20
    introTitle.Parent = background
    local titleStroke = Instance.new("UIStroke")
    titleStroke.Color = Color3.fromRGB(0, 0, 0)
    titleStroke.Thickness = 3
    titleStroke.Transparency = 1
    titleStroke.Parent = introTitle

    local introSubtitle = Instance.new("TextLabel")
    introSubtitle.AnchorPoint = Vector2.new(0.5, 0.5)
    introSubtitle.Position = UDim2.fromScale(0.5, 0.59)
    introSubtitle.Size = UDim2.fromScale(0.7, 0.05)
    introSubtitle.BackgroundTransparency = 1
    introSubtitle.Text = "[ RECCOMMENDED ]"
    introSubtitle.TextColor3 = Color3.fromRGB(205, 205, 205)
    introSubtitle.TextTransparency = 1
    introSubtitle.TextScaled = true
    introSubtitle.Font = Enum.Font.GothamBold
    introSubtitle.ZIndex = 20
    introSubtitle.Parent = background

    task.spawn(function()
        introSound = playFixedSong()
    end)

    local function finishIntro()
        if introFinished then return end
        introFinished = true
        introActive = false
        if introSound then
            pcall(function()
                TweenService:Create(introSound, TweenInfo.new(0.25), {Volume = 0}):Play()
            end)
            task.delay(0.3, function()
                pcall(function()
                    introSound:Stop()
                    introSound:Destroy()
                end)
                if introSoundInstance == introSound then introSoundInstance = nil end
            end)
        end
        pcall(function() gui:Destroy() end)
    end

    skip.MouseButton1Click:Connect(finishIntro)
    skip.MouseEnter:Connect(function()
        TweenService:Create(skip, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        }):Play()
    end)
    skip.MouseLeave:Connect(function()
        TweenService:Create(skip, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        }):Play()
    end)

    -- Compressed ~4 second intro
    task.spawn(function()
        TweenService:Create(image, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            ImageTransparency = 0
        }):Play()
        TweenService:Create(image, TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Size = UDim2.fromScale(1.12, 1.12)
        }):Play()

        task.spawn(function()
            while introActive and gui.Parent do
                flash.BackgroundTransparency = 0.85
                TweenService:Create(flash, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 1
                }):Play()
                task.wait(BEAT)
            end
        end)

        task.wait(0.25)
        if not introActive then return end

        TweenService:Create(introTitle, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.fromScale(0.9, 0.16),
            TextTransparency = 0
        }):Play()
        TweenService:Create(titleStroke, TweenInfo.new(0.25), {Transparency = 0}):Play()
        TweenService:Create(introSubtitle, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            TextTransparency = 0
        }):Play()

        -- short shake
        for i = 1, 8 do
            if not introActive then return end
            introTitle.Position = UDim2.fromScale(
                0.5 + math.random(-6, 6) / 1000,
                0.5 + math.random(-6, 6) / 1000
            )
            task.wait(0.02)
        end
        introTitle.Position = UDim2.fromScale(0.5, 0.5)

        task.wait(2.4)
        if not introActive then return end

        -- quick final flashes
        for i = 1, 4 do
            if not introActive then return end
            flash.BackgroundTransparency = 0.2
            task.wait(0.03)
            flash.BackgroundTransparency = 1
            task.wait(0.04)
        end

        TweenService:Create(introTitle, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            TextTransparency = 1
        }):Play()
        TweenService:Create(introSubtitle, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            TextTransparency = 1
        }):Play()
        TweenService:Create(titleStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
        TweenService:Create(image, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            ImageTransparency = 1
        }):Play()
        TweenService:Create(dark, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        if introSound and introSound.Parent then
            TweenService:Create(introSound, TweenInfo.new(0.35), {Volume = 0}):Play()
        end

        local finalFade = Instance.new("Frame")
        finalFade.Size = UDim2.fromScale(1, 1)
        finalFade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        finalFade.BackgroundTransparency = 1
        finalFade.BorderSizePixel = 0
        finalFade.ZIndex = 1000
        finalFade.Parent = gui
        TweenService:Create(finalFade, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            BackgroundTransparency = 0
        }):Play()

        task.wait(0.4)
        finishIntro()
    end)
end


-- ============================================================
-- SHADOW LAGGER V3 (Kill Hub style panel + open/close)
-- Powers: Low 18 / Mid 27 / High 32 / Ultra 80
-- ============================================================
M.killLaggerNivel = M.killLaggerNivel or "low"
M.killLaggerOpen = M.killLaggerOpen ~= false
M.killLaggerKey = M.killLaggerKey or "E"
M.killLaggerLocked = M.killLaggerLocked == true
M.killLaggerActive = false

function M.buildKillLaggerPanel()
    local UIS = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local CoreGui = game:GetService("CoreGui")
    local player = Players.LocalPlayer
    -- local alias (was nil before → keybind capture never connected)
    local function trackConn(conn)
        if M.trackConn then return M.trackConn(conn) end
        table.insert(M._persistentConns, conn)
        return conn
    end

    local NIVELES = {
        low   = { poder = 18, texto = "SPEED RECOMMENDED 50-25" },
        mid   = { poder = 27, texto = "SPEED RECOMMENDED 42-20" },
        high  = { poder = 32, texto = "SPEED RECOMMENDED 40-17" },
        ultra = { poder = 80, texto = "EXTREME POWER - USE WITH CAUTION" },
    }
    local COLORES = {
        low   = Color3.fromRGB(0, 255, 80),
        mid   = Color3.fromRGB(255, 200, 0),
        high  = Color3.fromRGB(255, 100, 200),
        ultra = Color3.fromRGB(160, 80, 255),
    }

    pcall(function()
        if M.killLaggerGui then M.killLaggerGui:Destroy() end
        for _, parent in ipairs({CoreGui, player:FindFirstChild("PlayerGui"), gethui and gethui() or nil}) do
            if parent then
                local o = parent:FindFirstChild("ShadowLaggerV3")
                if o then o:Destroy() end
            end
        end
    end)

    local nivelActual = (NIVELES[M.killLaggerNivel] and M.killLaggerNivel) or "low"
    local keybind = Enum.KeyCode[M.killLaggerKey] or Enum.KeyCode.E
    local panelOpen = true
    local laggerActive = false
    local lagThread = nil
    local listeningForInput = false
    local _bgId = tonumber(M.customBgId) or 0
    local SHADOW_BG = (_bgId > 0) and ("rbxassetid://" .. tostring(_bgId)) or "" 

    local function bomb(poder)
        local main, spam = {}, {{}}
        local z = spam[1]
        for _ = 1, 25 do local t = {} table.insert(z, t) z = t end
        local max = math.min(12000, poder * 50)
        for _ = 1, max do table.insert(main, spam) end
        pcall(function()
            game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(main)
        end)
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ShadowLaggerV3"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 55
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(screenGui) end end)
    local parented = false
    if gethui then parented = pcall(function() screenGui.Parent = gethui() end) end
    if not parented then parented = pcall(function() screenGui.Parent = CoreGui end) end
    if not parented then screenGui.Parent = player:WaitForChild("PlayerGui") end
    M.killLaggerGui = screenGui

    local PANEL_W, PANEL_H = 280, 110
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    mainFrame.BorderSizePixel = 0
    mainFrame.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
    mainFrame.Position = UDim2.new(0.12, 0, 0.45, 0)
    mainFrame.ClipsDescendants = true
    mainFrame.Active = true
    mainFrame.Parent = screenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", mainFrame)
    stroke.Color = Color3.fromRGB(0, 100, 220)
    stroke.Thickness = 1.2
    stroke.Transparency = 0.35

    if SHADOW_BG ~= "" then
        local bgImage = Instance.new("ImageLabel", mainFrame)
        bgImage.Size = UDim2.new(1, 0, 1, 0)
        bgImage.BackgroundTransparency = 1
        bgImage.Image = SHADOW_BG
        bgImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
        bgImage.ImageTransparency = 0.25
        bgImage.ScaleType = Enum.ScaleType.Crop
        bgImage.ZIndex = 0
        bgImage.Active = false
        Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 10)
    end

    local dim = Instance.new("Frame", mainFrame)
    dim.Size = UDim2.new(1, 0, 1, 0)
    dim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    dim.BackgroundTransparency = 0.4
    dim.BorderSizePixel = 0
    dim.ZIndex = 1
    dim.Active = false
    Instance.new("UICorner", dim).CornerRadius = UDim.new(0, 10)

    -- Full-width drag header (always draggable)
    local dragBar = Instance.new("TextButton", mainFrame)
    dragBar.Name = "DragBar"
    dragBar.Size = UDim2.new(1, -95, 0, 24)
    dragBar.Position = UDim2.new(0, 0, 0, 0)
    dragBar.BackgroundTransparency = 1
    dragBar.Text = ""
    dragBar.AutoButtonColor = false
    dragBar.ZIndex = 8
    dragBar.Active = true

    local titleLabel = Instance.new("TextLabel", mainFrame)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 10, 0, 4)
    titleLabel.Size = UDim2.new(0, 160, 0, 18)
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.Text = "SHADOW LAGGER V3"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 9
    titleLabel.Active = false

    local keybindButton = Instance.new("TextButton", mainFrame)
    keybindButton.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    keybindButton.Position = UDim2.new(1, -48, 0, 5)
    keybindButton.Size = UDim2.new(0, 40, 0, 16)
    keybindButton.Font = Enum.Font.GothamBold
    keybindButton.Text = "[" .. (keybind.Name:gsub("Button","")) .. "]"
    keybindButton.TextColor3 = Color3.fromRGB(220, 220, 230)
    keybindButton.TextSize = 10
    keybindButton.AutoButtonColor = false
    keybindButton.Active = true
    keybindButton.ZIndex = 25
    Instance.new("UICorner", keybindButton).CornerRadius = UDim.new(0, 5)

    -- No X / mini — drag from top bar only

    local toggleContainer = Instance.new("Frame", mainFrame)
    toggleContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    toggleContainer.Position = UDim2.new(1, -70, 0, 26)
    toggleContainer.Size = UDim2.new(0, 60, 0, 22)
    toggleContainer.ZIndex = 5
    Instance.new("UICorner", toggleContainer).CornerRadius = UDim.new(1, 0)

    local toggleBall = Instance.new("Frame", toggleContainer)
    toggleBall.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
    toggleBall.Size = UDim2.new(0, 16, 0, 16)
    toggleBall.Position = UDim2.new(0, 3, 0.5, -8)
    toggleBall.ZIndex = 6
    Instance.new("UICorner", toggleBall).CornerRadius = UDim.new(1, 0)

    local toggleClick = Instance.new("TextButton", toggleContainer)
    toggleClick.BackgroundTransparency = 1
    toggleClick.Size = UDim2.new(1, 0, 1, 0)
    toggleClick.ZIndex = 7
    toggleClick.Font = Enum.Font.GothamBlack
    toggleClick.Text = "OFF"
    toggleClick.TextSize = 10
    toggleClick.TextColor3 = Color3.fromRGB(0, 140, 255)
    toggleClick.AutoButtonColor = false

    local btnY, btnW, btnH, gap, leftM = 28, 58, 24, 4, 8
    local function makeLvl(name, x)
        local b = Instance.new("TextButton", mainFrame)
        b.Size = UDim2.new(0, btnW, 0, btnH)
        b.Position = UDim2.new(0, x, 0, btnY)
        b.Font = Enum.Font.GothamBlack
        b.Text = name
        b.TextColor3 = Color3.fromRGB(200, 200, 220)
        b.TextSize = 11
        b.AutoButtonColor = false
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        b.BorderSizePixel = 0
        b.ZIndex = 5
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        return b
    end
    local btnLow = makeLvl("LOW", leftM)
    local btnMid = makeLvl("MID", leftM + btnW + gap)
    local btnHigh = makeLvl("HIGH", leftM + (btnW + gap) * 2)
    local btnUltra = makeLvl("ULTRA", leftM + (btnW + gap) * 3)

    local infoLabel = Instance.new("TextLabel", mainFrame)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Position = UDim2.new(0, 10, 0, 58)
    infoLabel.Size = UDim2.new(1, -20, 0, 18)
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.Text = NIVELES[nivelActual].texto
    infoLabel.TextColor3 = COLORES[nivelActual]
    infoLabel.TextSize = 11
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.ZIndex = 5
    infoLabel.Active = false

    local statsLabel = Instance.new("TextLabel", mainFrame)
    statsLabel.BackgroundTransparency = 1
    statsLabel.Position = UDim2.new(0, 10, 0, 78)
    statsLabel.Size = UDim2.new(1, -20, 0, 16)
    statsLabel.Font = Enum.Font.Gotham
    statsLabel.Text = "FPS: --   Ping: -- ms"
    statsLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
    statsLabel.TextSize = 11
    statsLabel.TextXAlignment = Enum.TextXAlignment.Left
    statsLabel.ZIndex = 5
    statsLabel.Active = false

    -- No open-pill / mini button
    local function persist()
        M.killLaggerNivel = nivelActual
        M.killLaggerOpen = true
        M.killLaggerKey = keybind.Name
        pcall(saveCherryConfig)
    end

    local function actualizarBotonesNivel()
        local map = { low = btnLow, mid = btnMid, high = btnHigh, ultra = btnUltra }
        for name, btn in pairs(map) do
            if nivelActual == name then
                btn.BackgroundColor3 = COLORES[name]
                btn.TextColor3 = (name == "ultra") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
            else
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
                btn.TextColor3 = Color3.fromRGB(200, 200, 220)
            end
        end
        infoLabel.Text = NIVELES[nivelActual].texto
        infoLabel.TextColor3 = COLORES[nivelActual]
    end

    local function actualizarSwitch()
        if laggerActive then
            toggleBall.Position = UDim2.new(1, -19, 0.5, -8)
            toggleClick.Text = "ON"
            toggleClick.TextColor3 = Color3.fromRGB(0, 255, 100)
            toggleContainer.BackgroundColor3 = Color3.fromRGB(30, 80, 50)
        else
            toggleBall.Position = UDim2.new(0, 3, 0.5, -8)
            toggleClick.Text = "OFF"
            toggleClick.TextColor3 = Color3.fromRGB(0, 140, 255)
            toggleContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        end
    end

    local function toggleLagger()
        laggerActive = not laggerActive
        M.killLaggerActive = laggerActive
        local targetPos = laggerActive and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        TweenService:Create(toggleBall, TweenInfo.new(0.2), { Position = targetPos }):Play()
        actualizarSwitch()
        if laggerActive then
            if lagThread then task.cancel(lagThread) end
            lagThread = task.spawn(function()
                while laggerActive do
                    pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(80000) end)
                    bomb(NIVELES[nivelActual].poder)
                    task.wait(0.18)
                end
            end)
        else
            if lagThread then task.cancel(lagThread); lagThread = nil end
        end
    end

    local function setPanelOpen(open)
        panelOpen = open == true
        mainFrame.Visible = panelOpen
        persist()
    end

    M.setKillLaggerOpen = function(on)
        if on then
            if not screenGui or not screenGui.Parent then
                pcall(M.buildKillLaggerPanel)
                return
            end
            setPanelOpen(true)
            M.killLaggerOpen = true
            persist()
        else
            laggerActive = false
            M.killLaggerActive = false
            if lagThread then pcall(function() task.cancel(lagThread) end); lagThread = nil end
            M.killLaggerOpen = false
            if screenGui and screenGui.Parent then pcall(function() screenGui:Destroy() end) end
            M.killLaggerGui = nil
            M.setKillLaggerOpen = nil
            pcall(saveCherryConfig)
        end
    end

    toggleClick.MouseButton1Click:Connect(toggleLagger)
    btnLow.MouseButton1Click:Connect(function() nivelActual = "low"; actualizarBotonesNivel(); persist() end)
    btnMid.MouseButton1Click:Connect(function() nivelActual = "mid"; actualizarBotonesNivel(); persist() end)
    btnHigh.MouseButton1Click:Connect(function() nivelActual = "high"; actualizarBotonesNivel(); persist() end)
    btnUltra.MouseButton1Click:Connect(function() nivelActual = "ultra"; actualizarBotonesNivel(); persist() end)

    keybindButton.MouseButton1Click:Connect(function()
        if listeningForInput then return end
        listeningForInput = true
        keybindButton.Text = "[?]"
        keybindButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        keybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        -- auto-cancel after 8s
        task.delay(8, function()
            if listeningForInput then
                listeningForInput = false
                keybindButton.Text = "[" .. (keybind.Name:gsub("Button","")) .. "]"
                keybindButton.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
            end
        end)
    end)

    trackConn(UIS.InputBegan:Connect(function(input, gp)
        if not screenGui or not screenGui.Parent then return end
        if listeningForInput then
            -- IMPORTANT: do NOT require gameProcessed=false — keys often arrive as processed while playing
            local kc = input.KeyCode
            if kc == Enum.KeyCode.Unknown then return end
            if kc == Enum.KeyCode.Escape then
                listeningForInput = false
                keybindButton.Text = "[" .. (keybind.Name:gsub("Button","")) .. "]"
                keybindButton.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
                return
            end
            -- only accept keyboard / gamepad keys (not mouse)
            local uit = input.UserInputType
            local isKb = uit == Enum.UserInputType.Keyboard
            local isGp = uit == Enum.UserInputType.Gamepad1 or uit == Enum.UserInputType.Gamepad2
                or uit == Enum.UserInputType.Gamepad3 or uit == Enum.UserInputType.Gamepad4
            if not (isKb or isGp) then return end
            keybind = kc
            M.killLaggerKey = kc.Name
            keybindButton.Text = "[" .. kc.Name:gsub("Button","") .. "]"
            keybindButton.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
            keybindButton.TextColor3 = Color3.fromRGB(220, 220, 230)
            listeningForInput = false
            persist()
            return
        end
        if gp then return end
        if input.KeyCode == keybind then toggleLagger() end
    end))

    -- Always-draggable: dragBar + openPill via UIS
    do
        local dragging, dragStart, startPos, dragTarget = false, nil, nil, nil
        local function beginDrag(target, input)
            dragging = true
            dragStart = input.Position
            startPos = target.Position
            dragTarget = target
        end
        dragBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                beginDrag(mainFrame, input)
            end
        end)
        mainFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                -- only start drag if click is in top 28px (header area)
                local y = input.Position.Y
                local abs = mainFrame.AbsolutePosition
                if y >= abs.Y and y <= abs.Y + 28 then
                    beginDrag(mainFrame, input)
                end
            end
        end)
        trackConn(UIS.InputChanged:Connect(function(input)
            if not dragging or not dragTarget then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local d = input.Position - dragStart
                dragTarget.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end))
        trackConn(UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                dragTarget = nil
            end
        end))
    end

    do
        local last, frames = tick(), 0
        trackConn(RunService.RenderStepped:Connect(function()
            if not screenGui or not screenGui.Parent then return end
            frames += 1
            local now = tick()
            if now - last >= 1 then
                local fps = math.floor(frames / (now - last))
                local ping = math.floor(player:GetNetworkPing() * 1000)
                statsLabel.Text = string.format("FPS: %d   Ping: %d ms", fps, ping)
                frames = 0; last = now
            end
        end))
    end

    actualizarBotonesNivel()
    actualizarSwitch()
    setPanelOpen(true)
    M.killLaggerOpen = true
end


pcall(function() if M.killLaggerOpen ~= false then M.buildKillLaggerPanel() end end)
task.spawn(function() task.wait(0.35); pcall(M.playIntro) end)
pcall(function()
    if M.buildPingLaggerUI then M.buildPingLaggerUI() end
    if M.pingPanelOpen then
        if M.setPingPanelOpen then M.setPingPanelOpen(true) end
        if M.pingMain then M.pingMain.Visible = true end
    elseif M.pingMain then M.pingMain.Visible = false end
    if M.buildShadowBypassUI then M.buildShadowBypassUI() end
    if M.bypassPanelOpen then
        if M.setBypassPanelOpen then M.setBypassPanelOpen(true) end
        if M.bypassPanelMain then M.bypassPanelMain.Visible = true end
    elseif M.bypassPanelMain then
        M.bypassPanelMain.Visible = false
        if M.bypassPanelMini then M.bypassPanelMini.Visible = false end
    end
    if M.autoCarryEnemyBaseEnabled then M.startAutoCarryEnemyBase() end
end)
print("Shadow loaded successfully!")
return M