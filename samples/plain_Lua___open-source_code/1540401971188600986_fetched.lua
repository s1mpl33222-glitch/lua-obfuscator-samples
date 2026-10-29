print("ricks on top on very top")
print("ricks on top on very top")
print("ricks on top on very top")
print("ricks on top on very top")
print("ricks on top on very top")
print("ricks on top on very top")
print("ricks on top on very top")

if _G.S2HubLoaded then
    print("[S2 HUB] Already running — execution blocked.")
    return
end
_G.S2HubLoaded = true

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local player = Players.LocalPlayer
-- reglages intro geres depuis l'onglet Settings

local _gethui = typeof(gethui)=="function" and gethui or nil
local function protectGui(gui)
    if not gui then return end
    pcall(function()
        if typeof(protect_gui)=="function" then protect_gui(gui)
        elseif syn and syn.protect_gui then syn.protect_gui(gui)
        elseif typeof(hide_in_gcoregui)=="function" then hide_in_gcoregui(gui)
        end
    end)
end
local function parentGui(gui)
    if not gui then return end
    protectGui(gui)
    local ok=false
    if _gethui then
        ok=pcall(function() gui.Parent=_gethui() end)
    end
    if not ok or not gui.Parent then
        ok=pcall(function() gui.Parent=game:GetService("CoreGui") end)
    end
    if not gui.Parent then
        pcall(function()
            local plr=Players.LocalPlayer
            if plr then gui.Parent=plr:WaitForChild("PlayerGui") end
        end)
    end
end
local _isfile = (typeof(isfile)=="function" and isfile)
    or (syn and syn.isfile)
    or (getgenv and getgenv().isfile)
    or function(p)
        local ok, data = pcall(function() return readfile(p) end)
        return ok and data ~= nil
    end
local _readfile = (typeof(readfile)=="function" and readfile)
    or (syn and syn.readfile)
    or (getgenv and getgenv().readfile)
    or function() return nil end
local _writefile = (typeof(writefile)=="function" and writefile)
    or (syn and syn.writefile)
    or (getgenv and getgenv().writefile)
    or function() end
isfile, readfile, writefile = _isfile, _readfile, _writefile
local function destroyOldGui(name)
    if not name then return end
    pcall(function()
        if _gethui then
            local h=_gethui(); local o=h and h:FindFirstChild(name); if o then o:Destroy() end
        end
    end)
    pcall(function()
        local cg=game:GetService("CoreGui"); local o=cg:FindFirstChild(name); if o then o:Destroy() end
    end)
    pcall(function()
        local plr=Players.LocalPlayer
        if plr then
            local pg=plr:FindFirstChild("PlayerGui")
            if pg then local o=pg:FindFirstChild(name); if o then o:Destroy() end end
        end
    end)
end

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

currentGuiTheme = "Cyber"
GUI_THEME_ORDER = {"Midnight","Neon Pink","Cyber","Emerald","Blood","Sakura","Gold","Ocean","Purple Haze","Toxic"}
GUI_THEMES = {
    ["Midnight"] = {
        BG=Color3.fromRGB(12,12,14), BG2=Color3.fromRGB(18,18,20), ROW_BG=Color3.fromRGB(22,22,24),
        ROW_BORDER=Color3.fromRGB(40,40,44), WHITE=Color3.fromRGB(220,220,225), GRAY=Color3.fromRGB(140,140,150),
        INP=Color3.fromRGB(16,16,18), ACCENT=Color3.fromRGB(180,180,190), ACCENT2=Color3.fromRGB(150,150,160),
        ACCENT3=Color3.fromRGB(50,50,55), OFF=Color3.fromRGB(28,28,32), SECT=Color3.fromRGB(160,160,170),
        MOB_ON=Color3.fromRGB(180,180,190), MOB_OFF=Color3.fromRGB(22,22,24), MOB_BORDER_OFF=Color3.fromRGB(45,45,50),
        MOB_TEXT_OFF=Color3.fromRGB(170,170,180), MOB_TEXT_ON=Color3.fromRGB(20,20,22),
        STEAL_BG=Color3.fromRGB(14,14,16), STEAL_FILL=Color3.fromRGB(160,160,170), STEAL_ACCENT=Color3.fromRGB(180,180,190),
        PARTICLE=Color3.fromRGB(180,180,190),
    },
    ["Neon Pink"] = {
        BG=Color3.fromRGB(14,10,14), BG2=Color3.fromRGB(20,14,20), ROW_BG=Color3.fromRGB(26,16,26),
        ROW_BORDER=Color3.fromRGB(55,35,55), WHITE=Color3.fromRGB(230,215,230), GRAY=Color3.fromRGB(150,130,150),
        INP=Color3.fromRGB(18,12,18), ACCENT=Color3.fromRGB(180,100,150), ACCENT2=Color3.fromRGB(160,110,145),
        ACCENT3=Color3.fromRGB(55,30,50), OFF=Color3.fromRGB(30,20,30), SECT=Color3.fromRGB(170,130,160),
        MOB_ON=Color3.fromRGB(180,100,150), MOB_OFF=Color3.fromRGB(26,16,26), MOB_BORDER_OFF=Color3.fromRGB(55,35,55),
        MOB_TEXT_OFF=Color3.fromRGB(180,150,175), MOB_TEXT_ON=Color3.fromRGB(25,10,20),
        STEAL_BG=Color3.fromRGB(16,12,16), STEAL_FILL=Color3.fromRGB(170,95,140), STEAL_ACCENT=Color3.fromRGB(180,100,150),
        PARTICLE=Color3.fromRGB(180,120,160),
    },
    ["Cyber"] = {
        BG=Color3.fromRGB(12,16,28), BG2=Color3.fromRGB(18,24,40), ROW_BG=Color3.fromRGB(26,34,54),
        ROW_BORDER=Color3.fromRGB(120,175,255), WHITE=Color3.fromRGB(245,250,255), GRAY=Color3.fromRGB(160,195,240),
        INP=Color3.fromRGB(16,22,38), ACCENT=Color3.fromRGB(130,190,255), ACCENT2=Color3.fromRGB(100,165,255),
        ACCENT3=Color3.fromRGB(50,100,180), OFF=Color3.fromRGB(32,40,60), SECT=Color3.fromRGB(150,200,255),
        MOB_ON=Color3.fromRGB(130,190,255), MOB_OFF=Color3.fromRGB(26,34,54), MOB_BORDER_OFF=Color3.fromRGB(120,175,255),
        MOB_TEXT_OFF=Color3.fromRGB(190,220,255), MOB_TEXT_ON=Color3.fromRGB(12,20,40),
        STEAL_BG=Color3.fromRGB(16,22,38), STEAL_FILL=Color3.fromRGB(120,185,255), STEAL_ACCENT=Color3.fromRGB(130,190,255),
        PARTICLE=Color3.fromRGB(150,200,255),
    },
    ["Emerald"] = {
        BG=Color3.fromRGB(10,14,12), BG2=Color3.fromRGB(14,20,16), ROW_BG=Color3.fromRGB(18,26,20),
        ROW_BORDER=Color3.fromRGB(30,55,40), WHITE=Color3.fromRGB(215,235,220), GRAY=Color3.fromRGB(120,160,135),
        INP=Color3.fromRGB(12,18,14), ACCENT=Color3.fromRGB(70,160,110), ACCENT2=Color3.fromRGB(90,150,115),
        ACCENT3=Color3.fromRGB(25,55,35), OFF=Color3.fromRGB(20,32,24), SECT=Color3.fromRGB(110,170,130),
        MOB_ON=Color3.fromRGB(70,160,110), MOB_OFF=Color3.fromRGB(18,26,20), MOB_BORDER_OFF=Color3.fromRGB(30,55,40),
        MOB_TEXT_OFF=Color3.fromRGB(140,185,155), MOB_TEXT_ON=Color3.fromRGB(5,25,12),
        STEAL_BG=Color3.fromRGB(12,18,14), STEAL_FILL=Color3.fromRGB(65,150,105), STEAL_ACCENT=Color3.fromRGB(70,160,110),
        PARTICLE=Color3.fromRGB(90,160,120),
    },
    ["Blood"] = {
        BG=Color3.fromRGB(14,10,10), BG2=Color3.fromRGB(20,14,14), ROW_BG=Color3.fromRGB(26,16,16),
        ROW_BORDER=Color3.fromRGB(55,30,30), WHITE=Color3.fromRGB(235,215,215), GRAY=Color3.fromRGB(160,130,130),
        INP=Color3.fromRGB(18,12,12), ACCENT=Color3.fromRGB(170,70,70), ACCENT2=Color3.fromRGB(160,90,90),
        ACCENT3=Color3.fromRGB(55,25,25), OFF=Color3.fromRGB(30,20,20), SECT=Color3.fromRGB(175,120,120),
        MOB_ON=Color3.fromRGB(170,70,70), MOB_OFF=Color3.fromRGB(26,16,26), MOB_BORDER_OFF=Color3.fromRGB(55,30,30),
        MOB_TEXT_OFF=Color3.fromRGB(190,150,150), MOB_TEXT_ON=Color3.fromRGB(25,8,8),
        STEAL_BG=Color3.fromRGB(16,12,12), STEAL_FILL=Color3.fromRGB(160,65,65), STEAL_ACCENT=Color3.fromRGB(170,70,70),
        PARTICLE=Color3.fromRGB(170,90,90),
    },
    ["Sakura"] = {
        BG=Color3.fromRGB(14,12,14), BG2=Color3.fromRGB(20,16,20), ROW_BG=Color3.fromRGB(26,20,24),
        ROW_BORDER=Color3.fromRGB(55,40,50), WHITE=Color3.fromRGB(235,220,230), GRAY=Color3.fromRGB(155,140,155),
        INP=Color3.fromRGB(18,14,16), ACCENT=Color3.fromRGB(175,120,150), ACCENT2=Color3.fromRGB(165,130,155),
        ACCENT3=Color3.fromRGB(55,40,50), OFF=Color3.fromRGB(30,24,28), SECT=Color3.fromRGB(170,140,160),
        MOB_ON=Color3.fromRGB(175,120,150), MOB_OFF=Color3.fromRGB(26,20,24), MOB_BORDER_OFF=Color3.fromRGB(55,40,50),
        MOB_TEXT_OFF=Color3.fromRGB(185,160,175), MOB_TEXT_ON=Color3.fromRGB(30,15,22),
        STEAL_BG=Color3.fromRGB(16,14,16), STEAL_FILL=Color3.fromRGB(165,115,145), STEAL_ACCENT=Color3.fromRGB(175,120,150),
        PARTICLE=Color3.fromRGB(180,140,165),
    },
    ["Gold"] = {
        BG=Color3.fromRGB(12,16,28), BG2=Color3.fromRGB(18,24,40), ROW_BG=Color3.fromRGB(26,34,54),
        ROW_BORDER=Color3.fromRGB(120,175,255), WHITE=Color3.fromRGB(245,250,255), GRAY=Color3.fromRGB(160,195,240),
        INP=Color3.fromRGB(16,22,38), ACCENT=Color3.fromRGB(130,190,255), ACCENT2=Color3.fromRGB(100,165,255),
        ACCENT3=Color3.fromRGB(50,100,180), OFF=Color3.fromRGB(32,40,60), SECT=Color3.fromRGB(150,200,255),
        MOB_ON=Color3.fromRGB(130,190,255), MOB_OFF=Color3.fromRGB(26,34,54), MOB_BORDER_OFF=Color3.fromRGB(120,175,255),
        MOB_TEXT_OFF=Color3.fromRGB(190,220,255), MOB_TEXT_ON=Color3.fromRGB(12,20,40),
        STEAL_BG=Color3.fromRGB(16,22,38), STEAL_FILL=Color3.fromRGB(120,185,255), STEAL_ACCENT=Color3.fromRGB(130,190,255),
        PARTICLE=Color3.fromRGB(150,200,255),
    },
    ["Ocean"] = {
        BG=Color3.fromRGB(10,12,16), BG2=Color3.fromRGB(12,16,22), ROW_BG=Color3.fromRGB(14,20,28),
        ROW_BORDER=Color3.fromRGB(30,48,70), WHITE=Color3.fromRGB(215,225,235), GRAY=Color3.fromRGB(120,150,175),
        INP=Color3.fromRGB(12,16,22), ACCENT=Color3.fromRGB(70,120,175), ACCENT2=Color3.fromRGB(90,135,170),
        ACCENT3=Color3.fromRGB(25,45,70), OFF=Color3.fromRGB(18,26,35), SECT=Color3.fromRGB(110,155,185),
        MOB_ON=Color3.fromRGB(70,120,175), MOB_OFF=Color3.fromRGB(14,20,28), MOB_BORDER_OFF=Color3.fromRGB(30,48,70),
        MOB_TEXT_OFF=Color3.fromRGB(140,170,195), MOB_TEXT_ON=Color3.fromRGB(5,15,30),
        STEAL_BG=Color3.fromRGB(12,16,22), STEAL_FILL=Color3.fromRGB(65,115,165), STEAL_ACCENT=Color3.fromRGB(70,120,175),
        PARTICLE=Color3.fromRGB(90,130,175),
    },
    ["Purple Haze"] = {
        BG=Color3.fromRGB(12,10,16), BG2=Color3.fromRGB(16,14,22), ROW_BG=Color3.fromRGB(22,18,30),
        ROW_BORDER=Color3.fromRGB(45,35,65), WHITE=Color3.fromRGB(225,220,235), GRAY=Color3.fromRGB(145,140,170),
        INP=Color3.fromRGB(14,12,20), ACCENT=Color3.fromRGB(120,95,165), ACCENT2=Color3.fromRGB(130,110,160),
        ACCENT3=Color3.fromRGB(40,30,60), OFF=Color3.fromRGB(26,22,35), SECT=Color3.fromRGB(140,125,170),
        MOB_ON=Color3.fromRGB(120,95,165), MOB_OFF=Color3.fromRGB(22,18,30), MOB_BORDER_OFF=Color3.fromRGB(45,35,65),
        MOB_TEXT_OFF=Color3.fromRGB(160,150,185), MOB_TEXT_ON=Color3.fromRGB(15,10,25),
        STEAL_BG=Color3.fromRGB(14,12,20), STEAL_FILL=Color3.fromRGB(115,90,160), STEAL_ACCENT=Color3.fromRGB(120,95,165),
        PARTICLE=Color3.fromRGB(130,110,165),
    },
    ["Toxic"] = {
        BG=Color3.fromRGB(12,14,10), BG2=Color3.fromRGB(16,20,12), ROW_BG=Color3.fromRGB(20,26,16),
        ROW_BORDER=Color3.fromRGB(40,55,30), WHITE=Color3.fromRGB(220,235,215), GRAY=Color3.fromRGB(140,165,130),
        INP=Color3.fromRGB(14,18,12), ACCENT=Color3.fromRGB(120,160,70), ACCENT2=Color3.fromRGB(130,155,90),
        ACCENT3=Color3.fromRGB(35,50,25), OFF=Color3.fromRGB(24,30,20), SECT=Color3.fromRGB(140,170,110),
        MOB_ON=Color3.fromRGB(120,160,70), MOB_OFF=Color3.fromRGB(20,26,16), MOB_BORDER_OFF=Color3.fromRGB(40,55,30),
        MOB_TEXT_OFF=Color3.fromRGB(160,185,140), MOB_TEXT_ON=Color3.fromRGB(10,20,5),
        STEAL_BG=Color3.fromRGB(14,18,12), STEAL_FILL=Color3.fromRGB(115,155,65), STEAL_ACCENT=Color3.fromRGB(120,160,70),
        PARTICLE=Color3.fromRGB(130,160,90),
    },
}
function getTheme()
    return GUI_THEMES[currentGuiTheme] or GUI_THEMES["Midnight"]
end

TS=TweenService
LP=Players.LocalPlayer
NS,CS=60,30
LAGGER_SPEED=15
LAGGER_CARRY_SPEED=24.5
carrySpeedActive = false
laggerModeEnabled = false
laggerCarryActive = false
autoCarryEnabled = false
setAutoCarryVisual = nil

antiRagdollEnabled,infJumpEnabled=false,false
medusaCounterEnabled,batCounterEnabled,unwalkEnabled=false,false,false
medusaResetEnabled = false
medusaDebounce,medusaLastUsed,dropActive=false,0,false
autoLeftEnabled,autoRightEnabled=false,false
local autoPlayEnabled=false
local autoPlaySetVisual=nil
autoLeftSetVisual,autoRightSetVisual=nil,nil
speedLabel=nil
autoBatEnabled=false
aimbotV2Enabled=false
autoSwingEnabled=true
autoMoveSwingEnabled=false
autoMoveSwingInterval=0.3
_alSwingDebounce=false
_arSwingDebounce=false
autoBatSetVisual=nil
resetAutoBatMotion=nil
setBatCounterVisual=nil
startBatCounter,stopBatCounter=nil,nil
antiLagEnabled,removeAccessoriesEnabled,antiLagDescConn=false,false,nil
unwalkSavedAnimate,_anyKeyListening=false,nil
autoTPEnabled,autoTPHeight,autoTPConn,setAutoTPVisual=false,20,nil,nil
cursedResetRemote=nil
CURSED_RESET_GUID="f888ee6e-c86d-46e1-93d7-0639d6635d42"
guiTransparencyEnabled,mobileButtonsEnabled,mobileButtonsLocked=false,true,false
mobileButtonsSize=90
circleButtonsEnabled=false
stealBarFrame=nil
progressFill=nil
setStealStatusText=nil
mobBtnRefs={}
mobGuiRef=nil
fovValue=80
fovOptions={80,120,180}
fovIndex=1
laggerModePillRef=nil
carryModePillRef=nil
autoSwitchSpeedEnabled=false
mobBtnTransparencyEnabled=false
perButtonDragEnabled=true
antiKickEnabled=false
antiKickSetVisual=nil
brainrotDetected=false
activeBatBillboard=nil
activeMedusaBillboard=nil
ragdollGuiEnabled=false
introEnabled=true
introMusicEnabled=true
selectedIntroMusic=1
persistentRagdollGui=nil
uiLocked=false
infJumpMode="manual"
holdInfJumpConn=nil
DROP_ASCEND_DURATION=0.2
DROP_ASCEND_SPEED=150

MOB_POS_FILE="moveeduels_btnpos.json"
forceDefaultBtnPos=false
activeMobDrag=nil
local function loadBtnPositions()
    local data={}
    pcall(function()
        local raw=readfile(MOB_POS_FILE)
        if raw and #raw>2 then
            local decoded=HS:JSONDecode(raw)
            if type(decoded)=="table" then data=decoded end
        end
    end)
    if not data or next(data)==nil then
        pcall(function()
            local raw=readfile("S2.json")
            if raw then
                local cfg=HS:JSONDecode(raw)
                if type(cfg)=="table" and type(cfg.btnPositions)=="table" and next(cfg.btnPositions)~=nil then
                    data=cfg.btnPositions
                end
            end
        end)
    end
    return data or {}
end
local function saveBtnPositions()
    if not mobGuiRef then return end
    local out={}
    for _,child in ipairs(mobGuiRef:GetDescendants()) do
        if child:IsA("Frame") and child:GetAttribute("BtnKey") then
            local key=child:GetAttribute("BtnKey")
            out[key]={xs=0,xo=child.Position.X.Offset,ys=0,yo=child.Position.Y.Offset}
        end
    end
    if next(out)==nil then return end
    if writefile then
        pcall(function() writefile(MOB_POS_FILE,HS:JSONEncode(out)) end)
    end
    if writefile and isfile and isfile("S2.json") then
        pcall(function()
            local cfg=HS:JSONDecode(readfile("S2.json"))
            if type(cfg)=="table" then
                cfg.btnPositions=out
                writefile("S2.json",HS:JSONEncode(cfg))
            end
        end)
    end
end
task.spawn(function()
    while true do
        task.wait(2)
        pcall(saveBtnPositions)
    end
end)

refreshSpeedModeLabel,saveConfig=nil,nil
startUnwalk,stopUnwalk,setupMedusa,stopMedusaCounter=nil,nil,nil,nil
startAntiRagdoll,stopAntiRagdoll,startAutoLeft,stopAutoLeft,startAutoRight,stopAutoRight=nil,nil,nil,nil,nil,nil
startAutoTP,stopAutoTP,enableAntiLag,disableAntiLag=nil,nil,nil,nil
startBatAimbot,stopBatAimbot,queueAutoBatStart,runDrop,runTPFloor,cursedInstaReset=nil,nil,nil,nil,nil,nil
startAutoSteal,stopAutoSteal,enableAntiKick,disableAntiKick,toggleCarryMode,toggleLaggerMode,toggleLaggerCarryMode=nil,nil,nil,nil,nil,nil,nil

local function addShimmerToLabel(lbl,color1,color2)
    local gr=Instance.new("UIGradient",lbl)
    gr.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,color1 or Color3.fromRGB(160,80,255)),ColorSequenceKeypoint.new(0.5,color2 or Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,color1 or Color3.fromRGB(160,80,255))})
    gr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,0.3,0)})
    return gr
end
fovConn=nil
local function applyFOV()
    if fovConn then fovConn:Disconnect() end
    fovConn=RunService.RenderStepped:Connect(function() local cam=workspace.CurrentCamera;if cam then cam.FieldOfView=fovValue end end)
end
applyFOV()

do
    local timerBillboard = nil
    local timerLabel = nil
    local timerActive = false
    local timerConn = nil
    local ragdollCheckConn = nil
    local lastRagdollState = false

    local function createTimerBillboard()
        if timerBillboard then timerBillboard:Destroy() end
        
        local char = LP.Character
        if not char then return end
        
        local head = char:FindFirstChild("Head")
        if not head then return end
        
        timerBillboard = Instance.new("BillboardGui")
        timerBillboard.Name = "S2RagdollTimer"
        timerBillboard.Size = UDim2.new(0, 120, 0, 50)
        timerBillboard.StudsOffset = Vector3.new(0, 5.8, 0)
        timerBillboard.AlwaysOnTop = true
        timerBillboard.MaxDistance = 100
        timerBillboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        timerBillboard.Parent = head
        
        local bgFrame = Instance.new("Frame")
        bgFrame.Size = UDim2.new(1, 0, 1, 0)
        bgFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        bgFrame.BackgroundTransparency = 0.4
        bgFrame.BorderSizePixel = 0
        bgFrame.Parent = timerBillboard
        Instance.new("UICorner", bgFrame).CornerRadius = UDim.new(0, 10)
        
        local stroke = Instance.new("UIStroke", bgFrame)
        stroke.Color = Color3.fromRGB(0, 255, 100)
        stroke.Thickness = 2
        stroke.Transparency = 0.3

        timerLabel = Instance.new("TextLabel")
        timerLabel.Size = UDim2.new(1, 0, 1, 0)
        timerLabel.BackgroundTransparency = 1
        timerLabel.Text = "3.00"
        timerLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        timerLabel.Font = Enum.Font.GothamBlack
        timerLabel.TextSize = 28
        timerLabel.TextScaled = true
        timerLabel.ZIndex = 2
        timerLabel.Parent = bgFrame
        
        timerBillboard.Enabled = false
    end

    local function updateTimerDisplay(time, isReady)
        if not timerLabel or not timerBillboard then return end
        
        if isReady then
            timerLabel.Text = "READY TO STEAL!"
            timerLabel.TextColor3 = Color3.fromRGB(0, 255, 50)
            timerLabel.TextSize = 18
            timerLabel.TextScaled = false
            local bg = timerLabel.Parent
            if bg then
                local stroke = bg:FindFirstChildOfClass("UIStroke")
                if stroke then
                    stroke.Color = Color3.fromRGB(0, 255, 50)
                    stroke.Thickness = 3
                    stroke.Transparency = 0
                end
                bg.BackgroundTransparency = 0.2
                bg.BackgroundColor3 = Color3.fromRGB(0, 30, 10)
            end
        else
            timerLabel.Text = string.format("%.2f", time)
            timerLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
            timerLabel.TextSize = 28
            timerLabel.TextScaled = true
            local bg = timerLabel.Parent
            if bg then
                local stroke = bg:FindFirstChildOfClass("UIStroke")
                if stroke then
                    stroke.Color = Color3.fromRGB(0, 255, 100)
                    stroke.Thickness = 2
                    stroke.Transparency = 0.3
                end
                bg.BackgroundTransparency = 0.4
                bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            end
        end
    end

    local function startRagdollTimer()
        if timerActive then return end
        
        if not timerBillboard or not timerBillboard.Parent then
            createTimerBillboard()
            if not timerBillboard then return end
        end
        
        timerActive = true
        timerBillboard.Enabled = true
        local startTime = tick()
        local duration = 3.0
        
        if timerConn then timerConn:Disconnect() end
        timerConn = RunService.Heartbeat:Connect(function()
            if not timerActive then 
                timerConn:Disconnect()
                timerConn = nil
                return 
            end
            
            local char = LP.Character
            if not char then
                timerActive = false
                if timerBillboard then timerBillboard.Enabled = false end
                if timerConn then timerConn:Disconnect(); timerConn = nil end
                return
            end
            
            local elapsed = tick() - startTime
            local remaining = math.max(duration - elapsed, 0)
            
            if remaining <= 0 then
                timerActive = false
                updateTimerDisplay(0, true)
                
                if timerConn then timerConn:Disconnect(); timerConn = nil end
                
                task.delay(1.5, function()
                    if timerBillboard then timerBillboard.Enabled = false end
                    timerActive = false
                end)
                return
            end
            
            updateTimerDisplay(remaining, false)
        end)
    end

    local function checkRagdoll()
        if ragdollCheckConn then return end
        
        ragdollCheckConn = RunService.Heartbeat:Connect(function()
            local char = LP.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            local state = hum:GetState()
            
            local isRagdolled = state == Enum.HumanoidStateType.Physics or 
                               state == Enum.HumanoidStateType.Ragdoll or 
                               state == Enum.HumanoidStateType.FallingDown
            
            if isRagdolled and not lastRagdollState and not timerActive then
                if not timerBillboard or not timerBillboard.Parent then
                    createTimerBillboard()
                end
                startRagdollTimer()
            end
            
            lastRagdollState = isRagdolled
        end)
    end
    
    task.spawn(checkRagdoll)
    
    playIntroAnimation = function()
        if introEnabled == false then return end
        local _th = (type(getTheme)=="function" and getTheme()) or nil
        C = C or {}
        if _th then
            C.accent = _th.ACCENT or _th.PINK or Color3.fromRGB(110,175,255)
            C.accentDim = _th.ACCENT2 or _th.GRAY or Color3.fromRGB(90,150,230)
            C.topTitle = _th.WHITE or C.accent
            C.topSub = _th.GRAY or C.accentDim
        end
        local Themes = Themes or { [1] = { gradA = C.accent, gradB = C.accentDim, gradC = C.accent } }
        local currentThemeIdx = currentThemeIdx or 1
        local Players2 = game:GetService("Players")
        local TweenService2 = game:GetService("TweenService")
        local SoundService2 = game:GetService("SoundService")
        local Debris2 = game:GetService("Debris")
        local LP2 = Players2.LocalPlayer
        local guiParent = LP2:WaitForChild("PlayerGui")
        pcall(function()
            local old = guiParent:FindFirstChild("S2Intro")
            if old then old:Destroy() end
            local old2 = (gethui and gethui() or nil)
            if old2 then
                local o = old2:FindFirstChild("S2Intro")
                if o then o:Destroy() end
            end
        end)

        local themeAccent = (C and C.accent) or Color3.fromRGB(0, 255, 100)
        local themeDim = (C and C.accentDim) or (C and C.topSub) or Color3.fromRGB(0, 200, 80)
        local themeText = (C and C.topTitle) or themeAccent
        local themeGradA = (Themes and Themes[currentThemeIdx] and Themes[currentThemeIdx].gradA) or themeAccent
        local themeGradB = (Themes and Themes[currentThemeIdx] and Themes[currentThemeIdx].gradC) or themeText
        local themeGradC = (Themes and Themes[currentThemeIdx] and Themes[currentThemeIdx].gradB) or themeDim

        local splashGui = Instance.new("ScreenGui")
        splashGui.Name = "S2Intro"
        splashGui.ResetOnSpawn = false
        splashGui.DisplayOrder = 9999
        splashGui.IgnoreGuiInset = true
        splashGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        local parented = false
        pcall(function()
            if gethui then
                splashGui.Parent = gethui()
                parented = true
            end
        end)
        if not parented then
            parented = pcall(function() splashGui.Parent = game:GetService("CoreGui") end)
        end
        if not parented then
            splashGui.Parent = guiParent
        end

        local overlay = Instance.new("Frame", splashGui)
        overlay.Size = UDim2.new(1, 0, 1, 0)
        overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        overlay.BackgroundTransparency = 0
        overlay.BorderSizePixel = 0
        overlay.ZIndex = 1

        local SCOPE_D = 220
        local TUBE = 90

        local housing = Instance.new("Frame", splashGui)
        housing.Size = UDim2.new(0, SCOPE_D + TUBE * 2, 0, SCOPE_D + TUBE * 2)
        housing.Position = UDim2.new(0.5, -(SCOPE_D/2 + TUBE), 0.5, -(SCOPE_D/2 + TUBE))
        housing.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        housing.BorderSizePixel = 0
        housing.ZIndex = 2
        Instance.new("UICorner", housing).CornerRadius = UDim.new(1, 0)

        local bevel = Instance.new("Frame", splashGui)
        bevel.Size = UDim2.new(0, SCOPE_D + 14, 0, SCOPE_D + 14)
        bevel.Position = UDim2.new(0.5, -(SCOPE_D + 14)/2, 0.5, -(SCOPE_D + 14)/2)
        bevel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        bevel.BorderSizePixel = 0
        bevel.ZIndex = 3
        Instance.new("UICorner", bevel).CornerRadius = UDim.new(1, 0)
        do
            local s = Instance.new("UIStroke", bevel)
            s.Color = Color3.fromRGB(55, 55, 55)
            s.Thickness = 2
            s.Transparency = 0.3
        end

        local scopeClip = Instance.new("Frame", splashGui)
        scopeClip.Name = "ScopeClip"
        scopeClip.Size = UDim2.new(0, SCOPE_D, 0, SCOPE_D)
        scopeClip.Position = UDim2.new(0.5, -SCOPE_D/2, 0.5, -SCOPE_D/2)
        scopeClip.BackgroundColor3 = Color3.fromRGB(18, 22, 20)
        scopeClip.BackgroundTransparency = 0
        scopeClip.BorderSizePixel = 0
        scopeClip.ClipsDescendants = true
        scopeClip.ZIndex = 4
        Instance.new("UICorner", scopeClip).CornerRadius = UDim.new(1, 0)

        local scopeTint = Instance.new("Frame", scopeClip)
        scopeTint.Size = UDim2.new(1, 0, 1, 0)
        scopeTint.BackgroundColor3 = Color3.fromRGB(30, 50, 35)
        scopeTint.BackgroundTransparency = 0.9
        scopeTint.BorderSizePixel = 0
        scopeTint.ZIndex = 4
        Instance.new("UICorner", scopeTint).CornerRadius = UDim.new(1, 0)

        local vignette = Instance.new("Frame", scopeClip)
        vignette.Size = UDim2.new(1, 0, 1, 0)
        vignette.BackgroundTransparency = 1
        vignette.ZIndex = 5
        do
            local s = Instance.new("UIStroke", vignette)
            s.Color = Color3.fromRGB(0, 0, 0)
            s.Thickness = 28
            s.Transparency = 0.15
        end
        Instance.new("UICorner", vignette).CornerRadius = UDim.new(1, 0)

        local scopeRing2 = Instance.new("Frame", splashGui)
        scopeRing2.Size = UDim2.new(0, SCOPE_D + 3, 0, SCOPE_D + 3)
        scopeRing2.Position = UDim2.new(0.5, -(SCOPE_D + 3)/2, 0.5, -(SCOPE_D + 3)/2)
        scopeRing2.BackgroundTransparency = 1
        scopeRing2.ZIndex = 6
        do
            local s = Instance.new("UIStroke", scopeRing2)
            s.Color = Color3.fromRGB(90, 90, 90)
            s.Thickness = 2
            s.Transparency = 0.2
        end
        Instance.new("UICorner", scopeRing2).CornerRadius = UDim.new(1, 0)

        local scopeRing = housing

        local function hair(w, h, x, y, color, z)
            local f = Instance.new("Frame", scopeClip)
            f.Size = UDim2.new(0, w, 0, h)
            f.Position = UDim2.new(0.5, x, 0.5, y)
            f.BackgroundColor3 = color
            f.BackgroundTransparency = 0
            f.BorderSizePixel = 0
            f.ZIndex = z or 8
            return f
        end

        local BLACK = Color3.fromRGB(8, 8, 8)
        local GREEN = Color3.fromRGB(55, 160, 70)

        local span = SCOPE_D * 0.48
        hair(span * 2, 2, -span, -1, BLACK, 8)
        hair(2, span * 2, -1, -span, BLACK, 8)

        local stub = 18
        local thick = 5
        local rim = SCOPE_D * 0.42
        hair(stub, thick, -rim, -thick/2, BLACK, 8)
        hair(stub, thick, rim - stub, -thick/2, BLACK, 8)
        hair(thick, stub, -thick/2, -rim, BLACK, 8)
        hair(thick, stub, -thick/2, rim - stub, BLACK, 8)

        hair(28, 1, -14, -0.5, GREEN, 9)
        hair(1, 28, -0.5, -14, GREEN, 9)

        local centerDot = Instance.new("Frame", scopeClip)
        centerDot.Size = UDim2.new(0, 5, 0, 5)
        centerDot.AnchorPoint = Vector2.new(0.5, 0.5)
        centerDot.Position = UDim2.new(0.5, 0, 0.5, 0)
        centerDot.BackgroundColor3 = GREEN
        centerDot.BorderSizePixel = 0
        centerDot.ZIndex = 9
        Instance.new("UICorner", centerDot).CornerRadius = UDim.new(1, 0)

        for i = 1, 4 do
            local y = 16 + i * 14
            local d = Instance.new("Frame", scopeClip)
            d.Size = UDim2.new(0, 4, 0, 4)
            d.Position = UDim2.new(0.5, -2, 0.5, y - 2)
            d.BackgroundColor3 = GREEN
            d.BackgroundTransparency = 0.1
            d.BorderSizePixel = 0
            d.ZIndex = 9
            Instance.new("UICorner", d).CornerRadius = UDim.new(1, 0)
        end

        for i = 1, 3 do
            local x = 16 + i * 16
            for _, sign in ipairs({-1, 1}) do
                local d = Instance.new("Frame", scopeClip)
                d.Size = UDim2.new(0, 4, 0, 4)
                d.Position = UDim2.new(0.5, sign * x - 2, 0.5, -2)
                d.BackgroundColor3 = GREEN
                d.BackgroundTransparency = 0.15
                d.BorderSizePixel = 0
                d.ZIndex = 9
                Instance.new("UICorner", d).CornerRadius = UDim.new(1, 0)
            end
        end

        local glare = Instance.new("Frame", scopeClip)
        glare.Size = UDim2.new(0, SCOPE_D * 0.7, 0, 10)
        glare.AnchorPoint = Vector2.new(0.5, 0.5)
        glare.Position = UDim2.new(0.5, 0, 0.35, 0)
        glare.Rotation = -28
        glare.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        glare.BackgroundTransparency = 0.92
        glare.BorderSizePixel = 0
        glare.ZIndex = 5
        Instance.new("UICorner", glare).CornerRadius = UDim.new(1, 0)

        -- === Intro FX ameliores ===
        -- scanlines CRT
        for i = 1, 14 do
            local sl = Instance.new("Frame", scopeClip)
            sl.Size = UDim2.new(1, 0, 0, 1)
            sl.Position = UDim2.new(0, 0, 0, i * 16)
            sl.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sl.BackgroundTransparency = 0.95
            sl.BorderSizePixel = 0
            sl.ZIndex = 6
        end

        -- balayage radar
        local sweep = Instance.new("Frame", scopeClip)
        sweep.Size = UDim2.new(0, SCOPE_D, 0, 2)
        sweep.AnchorPoint = Vector2.new(0.5, 0.5)
        sweep.Position = UDim2.new(0.5, 0, 0.5, 0)
        sweep.BackgroundColor3 = themeAccent
        sweep.BackgroundTransparency = 0.55
        sweep.BorderSizePixel = 0
        sweep.ZIndex = 6
        do
            local g = Instance.new("UIGradient", sweep)
            g.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.5, 0.2),
                NumberSequenceKeypoint.new(1, 1)
            })
        end

        -- anneaux de pulsation
        local function spawnPulseRing()
            local r = Instance.new("Frame", scopeClip)
            r.AnchorPoint = Vector2.new(0.5, 0.5)
            r.Position = UDim2.new(0.5, 0, 0.5, 0)
            r.Size = UDim2.new(0, 30, 0, 30)
            r.BackgroundTransparency = 1
            r.ZIndex = 6
            Instance.new("UICorner", r).CornerRadius = UDim.new(1, 0)
            local st = Instance.new("UIStroke", r)
            st.Color = themeAccent
            st.Thickness = 2
            st.Transparency = 0.2
            TweenService2:Create(r, TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, SCOPE_D, 0, SCOPE_D)}):Play()
            TweenService2:Create(st, TweenInfo.new(1.4), {Transparency = 1, Thickness = 0.5}):Play()
            Debris2:AddItem(r, 1.5)
        end

        -- entree animee (zoom + fade)
        local introScales = {}
        for _, obj in ipairs({housing, bevel, scopeClip, scopeRing2}) do
            local sc = Instance.new("UIScale", obj)
            sc.Scale = 0.55
            table.insert(introScales, sc)
            TweenService2:Create(sc, TweenInfo.new(0.75, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        end

        task.spawn(function()
            local t = 0
            local lastRing = 0
            while splashGui and splashGui.Parent do
                t = t + 0.03
                if sweep and sweep.Parent then
                    sweep.Rotation = (t * 90) % 360
                end
                if glare and glare.Parent then
                    glare.BackgroundTransparency = 0.9 + math.sin(t * 2) * 0.04
                end
                if t - lastRing > 1.2 then
                    lastRing = t
                    pcall(spawnPulseRing)
                end
                task.wait(0.03)
            end
        end)

        local loadingLbl = Instance.new("TextLabel", splashGui)
        loadingLbl.Size = UDim2.new(1, 0, 0, 16)
        loadingLbl.Position = UDim2.new(0, 0, 0.5, SCOPE_D/2 + TUBE + 8)
        loadingLbl.BackgroundTransparency = 1
        loadingLbl.Text = "loading music..."
        loadingLbl.TextColor3 = themeDim
        loadingLbl.Font = Enum.Font.Gotham
        loadingLbl.TextSize = 11
        loadingLbl.ZIndex = 12
        loadingLbl.TextXAlignment = Enum.TextXAlignment.Center
        task.spawn(function()
            local dots = 0
            while loadingLbl and loadingLbl.Parent do
                dots = (dots % 3) + 1
                loadingLbl.Text = "loading" .. string.rep(".", dots)
                task.wait(0.35)
            end
        end)

        local tapHint = Instance.new("TextLabel", splashGui)
        tapHint.Size = UDim2.new(1, 0, 0, 16)
        tapHint.Position = UDim2.new(0, 0, 1, -22)
        tapHint.BackgroundTransparency = 1
        tapHint.Text = "tap to skip"
        tapHint.TextColor3 = themeDim
        tapHint.Font = Enum.Font.Gotham
        tapHint.TextSize = 11
        tapHint.ZIndex = 12
        tapHint.TextXAlignment = Enum.TextXAlignment.Center
        tapHint.TextTransparency = 0.25
        task.spawn(function()
            while tapHint and tapHint.Parent do
                TweenService2:Create(tapHint, TweenInfo.new(0.8), {TextTransparency = 0.75}):Play()
                task.wait(0.85)
                if not (tapHint and tapHint.Parent) then break end
                TweenService2:Create(tapHint, TweenInfo.new(0.8), {TextTransparency = 0.15}):Play()
                task.wait(0.85)
            end
        end)

        local skipZone = Instance.new("TextButton", splashGui)
        skipZone.Size = UDim2.new(1, 0, 1, 0)
        skipZone.BackgroundTransparency = 1
        skipZone.Text = ""
        skipZone.ZIndex = 11

        local wordH = 36

        local orb = Instance.new("Frame", scopeClip)
        orb.Name = "IntroOrb"
        orb.Size = UDim2.new(0, 26, 0, 26)
        orb.AnchorPoint = Vector2.new(0.5, 0.5)
        orb.Position = UDim2.new(0.5, 0, 0.5, 0)
        orb.BackgroundColor3 = themeAccent
        orb.BackgroundTransparency = 0.05
        orb.BorderSizePixel = 0
        orb.ZIndex = 7
        Instance.new("UICorner", orb).CornerRadius = UDim.new(1, 0)
        do
            local s = Instance.new("UIStroke", orb)
            s.Color = Color3.fromRGB(255, 255, 255)
            s.Thickness = 1.2
            s.Transparency = 0.45
        end

        local orbGlow = Instance.new("Frame", scopeClip)
        orbGlow.Size = UDim2.new(0, 42, 0, 42)
        orbGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        orbGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
        orbGlow.BackgroundColor3 = themeAccent
        orbGlow.BackgroundTransparency = 0.82
        orbGlow.BorderSizePixel = 0
        orbGlow.ZIndex = 6
        Instance.new("UICorner", orbGlow).CornerRadius = UDim.new(1, 0)

        local calciumLbl = Instance.new("TextLabel", scopeClip)
        calciumLbl.Size = UDim2.new(0, 130, 0, wordH)
        calciumLbl.AnchorPoint = Vector2.new(0.5, 0.5)
        calciumLbl.Position = UDim2.new(0.5, -140, 0.5, 0)
        calciumLbl.BackgroundTransparency = 1
        calciumLbl.Text = "S2"
        calciumLbl.TextColor3 = themeText
        calciumLbl.Font = Enum.Font.GothamBlack
        calciumLbl.TextSize = 22
        calciumLbl.TextTransparency = 0
        calciumLbl.TextStrokeTransparency = 0.2
        calciumLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        calciumLbl.ZIndex = 50
        do
            local g = Instance.new("UIGradient", calciumLbl)
            g.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, themeGradA),
                ColorSequenceKeypoint.new(1, themeGradB)
            })
        end

        local duelsLbl = Instance.new("TextLabel", scopeClip)
        duelsLbl.Size = UDim2.new(0, 100, 0, wordH)
        duelsLbl.AnchorPoint = Vector2.new(0.5, 0.5)
        duelsLbl.Position = UDim2.new(0.5, 140, 0.5, 0)
        duelsLbl.BackgroundTransparency = 1
        duelsLbl.Text = "Duels"
        duelsLbl.TextColor3 = themeText
        duelsLbl.Font = Enum.Font.GothamBlack
        duelsLbl.TextSize = 22
        duelsLbl.TextTransparency = 0
        duelsLbl.TextStrokeTransparency = 0.2
        duelsLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        duelsLbl.ZIndex = 50
        do
            local g = Instance.new("UIGradient", duelsLbl)
            g.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, themeGradB),
                ColorSequenceKeypoint.new(1, themeGradC)
            })
        end

        calciumLbl.Parent = scopeClip
        duelsLbl.Parent = scopeClip

        local orbitR = 70
        local calciumExit = UDim2.new(0.5, -160, 0.5, 0)
        local duelsExit = UDim2.new(0.5, 160, 0.5, 0)

        local animConn = nil
        local orbitAngle = 0
        local orbitActive = false

        local function stopIntroAnim()
            orbitActive = false
            if animConn then
                pcall(function() animConn:Disconnect() end)
                animConn = nil
            end
        end

        local function posOnOrbit(angle)
            local ox = math.cos(angle) * orbitR
            local oy = math.sin(angle) * (orbitR * 0.85)
            return UDim2.new(0.5, ox, 0.5, oy)
        end

        local function startHoldAnimations()
            stopIntroAnim()
            orbitActive = true
            orbitAngle = math.pi
            local t0 = tick()

            animConn = RunService.RenderStepped:Connect(function(dt)
                if introFinished or not orbitActive then
                    stopIntroAnim()
                    return
                end
                local t = tick() - t0
                orbitAngle = orbitAngle + dt * 0.85

                calciumLbl.Position = posOnOrbit(orbitAngle)
                duelsLbl.Position = posOnOrbit(orbitAngle + math.pi)

                local pulse = 26 + math.sin(t * 4) * 3
                orb.Size = UDim2.new(0, pulse, 0, pulse)
                local gPulse = 42 + math.sin(t * 4) * 6
                orbGlow.Size = UDim2.new(0, gPulse, 0, gPulse)
                orbGlow.BackgroundTransparency = 0.78 + math.sin(t * 3) * 0.08
            end)
        end

        local introSound = nil
        local introFinished = false
        local introCompleteEvent = Instance.new("BindableEvent")
        local INTRO_DURATION = 15

        local function playSfx(id, pitch, vol, parent, delay)
            task.delay(delay or 0, function()
                if introFinished then return end
                local s = Instance.new("Sound")
                s.SoundId = id
                s.PlaybackSpeed = pitch
                s.Volume = vol
                s.Parent = parent
                s.RollOffMaxDistance = 0
                s:Play()
                Debris2:AddItem(s, 3)
            end)
        end

        local function playWhistle()
            local WHISTLE_ID = "rbxassetid://4612414100"
            playSfx(WHISTLE_ID, 2.2, 0.7, SoundService2, 0)
            playSfx(WHISTLE_ID, 1.7, 0.8, SoundService2, 0.07)
            playSfx(WHISTLE_ID, 1.2, 0.9, SoundService2, 0.15)
            playSfx(WHISTLE_ID, 0.85, 0.9, SoundService2, 0.24)
            playSfx(WHISTLE_ID, 0.55, 0.7, SoundService2, 0.34)
            playSfx(WHISTLE_ID, 0.3, 1.0, SoundService2, 0.5)
        end

        local function stopIntroMusic()
            pcall(function()
                if introSound then
                    introSound:Stop()
                    introSound:Destroy()
                    introSound = nil
                end
            end)
        end

        local function finishIntro()
            if introFinished then return end
            introFinished = true
            stopIntroAnim()
            pcall(function()
                if introSound then
                    TweenService2:Create(introSound, TweenInfo.new(0.35), {Volume = 0}):Play()
                    task.delay(0.45, function() stopIntroMusic() end)
                end
            end)
            pcall(function()
                TweenService2:Create(calciumLbl, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Position = calciumExit, TextTransparency = 1
                }):Play()
                TweenService2:Create(duelsLbl, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Position = duelsExit, TextTransparency = 1
                }):Play()
                TweenService2:Create(orb, TweenInfo.new(0.35), {BackgroundTransparency = 1, Size = UDim2.new(0, 6, 0, 6)}):Play()
                TweenService2:Create(orbGlow, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
                local closeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                for _, fr in ipairs({scopeClip, housing, bevel, scopeRing2}) do
                    TweenService2:Create(fr, closeInfo, {
                        Size = UDim2.new(0, 0, 0, 0),
                        Position = UDim2.new(0.5, 0, 0.5, 0)
                    }):Play()
                end
                TweenService2:Create(overlay, TweenInfo.new(0.55), {BackgroundTransparency = 1}):Play()
                TweenService2:Create(tapHint, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
                TweenService2:Create(loadingLbl, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
            end)
            task.delay(0.65, function()
                pcall(function() if splashGui and splashGui.Parent then splashGui:Destroy() end end)
                pcall(function() introCompleteEvent:Fire() end)
            end)
        end

        skipZone.MouseButton1Click:Connect(function() finishIntro() end)

        task.spawn(function()
            local intros = {
                "https://files.catbox.moe/8oogdu.mp3",
                "https://files.catbox.moe/8ch5qz.mp3",
                "https://files.catbox.moe/gm26vl.mp3",
                "https://files.catbox.moe/m5kxm3.mp3",
                "https://files.catbox.moe/zuid5n.mp3",
                "https://files.catbox.moe/z6eqnt.mp3",
                "https://files.catbox.moe/t0nlhv.mp3",
                "https://files.catbox.moe/mthg31.mp3",
                "https://files.catbox.moe/ddnbup.mp3",
            }
            local selectedMusic = math.clamp(tonumber(selectedIntroMusic) or 1, 1, #intros)
            local url = intros[selectedMusic]
            local cacheName = "S2HubIntro_" .. tostring(selectedMusic) .. ".mp3"

            local function getRequestFn()
                return (syn and syn.request)
                    or (http and http.request)
                    or (fluxus and fluxus.request)
                    or request
                    or http_request
                    or (http and http.Request)
                    or (getgenv and (getgenv().request or getgenv().http_request))
            end

            local function tryGetCustomAsset(path)
                local asset = nil
                pcall(function()
                    if getcustomasset then
                        asset = getcustomasset(path)
                    end
                end)
                if asset and asset ~= "" then return asset end
                pcall(function()
                    if syn and syn.getcustomasset then
                        asset = syn.getcustomasset(path)
                    end
                end)
                if asset and asset ~= "" then return asset end
                pcall(function()
                    if getcustomasset then
                        asset = getcustomasset(path, true)
                    end
                end)
                if asset and asset ~= "" then return asset end
                return nil
            end

            local function getAssetId()
                local hasCache = false
                pcall(function()
                    if isfile(cacheName) then hasCache = true end
                end)
                if hasCache then
                    local asset = tryGetCustomAsset(cacheName)
                    if asset then return asset end
                end

                local content = nil
                pcall(function()
                    local req = getRequestFn()
                    if req then
                        local res = req({
                            Url = url,
                            Method = "GET",
                            Headers = { ["User-Agent"] = "Mozilla/5.0" }
                        })
                        if type(res) == "table" then
                            content = res.Body or res.body or res.Data or res.data
                        elseif type(res) == "string" then
                            content = res
                        end
                    end
                end)
                if (not content or #content == 0) then
                    pcall(function()
                        content = game:HttpGet(url)
                    end)
                end
                if (not content or #content == 0) then
                    pcall(function()
                        if game.HttpGetAsync then
                            content = game:HttpGetAsync(url)
                        end
                    end)
                end

                if content and #content > 0 then
                    pcall(function()
                        writefile(cacheName, content)
                    end)
                    task.wait(0.05)
                    local asset = tryGetCustomAsset(cacheName)
                    if asset then return asset end
                    task.wait(0.15)
                    asset = tryGetCustomAsset(cacheName)
                    if asset then return asset end
                end
                return nil
            end

            -- Musique d'intro Roblox (demarre a 5s)
            local INTRO_MUSIC_ID = "rbxassetid://92674033980537"
            local INTRO_MUSIC_START = 5
            local assetId = INTRO_MUSIC_ID

            if introFinished then return end

            if introMusicEnabled ~= false and assetId and type(assetId) == "string" and #assetId > 0 then
                pcall(function()
                    introSound = Instance.new("Sound")
                    introSound.Name = "S2IntroMusic"
                    introSound.SoundId = assetId
                    introSound.PlaybackSpeed = 1
                    introSound.Volume = 1
                    introSound.Looped = false
                    local parentOk = pcall(function() introSound.Parent = SoundService2 end)
                    if not parentOk then
                        pcall(function() introSound.Parent = workspace end)
                    end
                    local t0 = tick()
                    while introSound and introSound.Parent and not introSound.IsLoaded and (tick() - t0) < 3 do
                        task.wait(0.05)
                        if introFinished then return end
                    end
                end)
            end

            if introFinished then return end

            pcall(function()
                loadingLbl.Text = ""
                loadingLbl.Visible = false
                if introSound and introSound.Parent then
                    introSound.TimePosition = INTRO_MUSIC_START
                    introSound:Play()
                end
            end)

            pcall(playWhistle)

            local function zeroScope(frame)
                frame.Size = UDim2.new(0, 0, 0, 0)
                frame.Position = UDim2.new(0.5, 0, 0.5, 0)
            end
            zeroScope(scopeClip)
            zeroScope(housing)
            zeroScope(bevel)
            zeroScope(scopeRing2)

            local openInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            TweenService2:Create(housing, openInfo, {
                Size = UDim2.new(0, SCOPE_D + TUBE * 2, 0, SCOPE_D + TUBE * 2),
                Position = UDim2.new(0.5, -(SCOPE_D/2 + TUBE), 0.5, -(SCOPE_D/2 + TUBE))
            }):Play()
            TweenService2:Create(bevel, openInfo, {
                Size = UDim2.new(0, SCOPE_D + 14, 0, SCOPE_D + 14),
                Position = UDim2.new(0.5, -(SCOPE_D + 14)/2, 0.5, -(SCOPE_D + 14)/2)
            }):Play()
            TweenService2:Create(scopeClip, openInfo, {
                Size = UDim2.new(0, SCOPE_D, 0, SCOPE_D),
                Position = UDim2.new(0.5, -SCOPE_D/2, 0.5, -SCOPE_D/2)
            }):Play()
            TweenService2:Create(scopeRing2, openInfo, {
                Size = UDim2.new(0, SCOPE_D + 3, 0, SCOPE_D + 3),
                Position = UDim2.new(0.5, -(SCOPE_D + 3)/2, 0.5, -(SCOPE_D + 3)/2)
            }):Play()

            local landA = posOnOrbit(math.pi)
            local landB = posOnOrbit(0)
            TweenService2:Create(calciumLbl, TweenInfo.new(0.65, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = landA
            }):Play()
            TweenService2:Create(duelsLbl, TweenInfo.new(0.65, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = landB
            }):Play()

            task.delay(0.7, function()
                if introFinished then return end
                startHoldAnimations()
            end)

            local lockedCalcium = UDim2.new(0.5, -58, 0.5, 0)
            local lockedDuels   = UDim2.new(0.5, 54, 0.5, 0)

            local function screenShake(duration, magnitude)
                task.spawn(function()
                    local targets = {housing, bevel, scopeClip, scopeRing2}
                    local origins = {}
                    for _, fr in ipairs(targets) do
                        origins[fr] = fr.Position
                    end
                    local t0 = tick()
                    while tick() - t0 < duration and not introFinished do
                        local decay = 1 - ((tick() - t0) / duration)
                        local ox = (math.random() - 0.5) * 2 * magnitude * decay
                        local oy = (math.random() - 0.5) * 2 * magnitude * decay
                        for _, fr in ipairs(targets) do
                            local o = origins[fr]
                            fr.Position = UDim2.new(o.X.Scale, o.X.Offset + ox, o.Y.Scale, o.Y.Offset + oy)
                        end
                        task.wait()
                    end
                    for _, fr in ipairs(targets) do
                        fr.Position = origins[fr]
                    end
                end)
            end

            local function fireSniperShot()
                if introFinished then return end
                stopIntroAnim()

                TweenService2:Create(calciumLbl, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = lockedCalcium
                }):Play()
                TweenService2:Create(duelsLbl, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = lockedDuels
                }):Play()

                local flash = Instance.new("Frame", scopeClip)
                flash.Size = UDim2.new(1, 0, 1, 0)
                flash.BackgroundColor3 = Color3.fromRGB(255, 255, 240)
                flash.BackgroundTransparency = 0.25
                flash.BorderSizePixel = 0
                flash.ZIndex = 12
                Instance.new("UICorner", flash).CornerRadius = UDim.new(1, 0)
                TweenService2:Create(flash, TweenInfo.new(0.18), {BackgroundTransparency = 1}):Play()
                Debris2:AddItem(flash, 0.3)

                local hit = Instance.new("Frame", scopeClip)
                hit.Size = UDim2.new(0, 14, 0, 2)
                hit.AnchorPoint = Vector2.new(0.5, 0.5)
                hit.Position = UDim2.new(0.5, 0, 0.5, 0)
                hit.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
                hit.BorderSizePixel = 0
                hit.ZIndex = 13
                local hit2 = Instance.new("Frame", scopeClip)
                hit2.Size = UDim2.new(0, 2, 0, 14)
                hit2.AnchorPoint = Vector2.new(0.5, 0.5)
                hit2.Position = UDim2.new(0.5, 0, 0.5, 0)
                hit2.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
                hit2.BorderSizePixel = 0
                hit2.ZIndex = 13
                TweenService2:Create(hit, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
                TweenService2:Create(hit2, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
                Debris2:AddItem(hit, 0.4)
                Debris2:AddItem(hit2, 0.4)

                pcall(function()
                    local SHOT_ID = "rbxassetid://9125892370"
                    local function bang(pitch, vol, delay)
                        task.delay(delay or 0, function()
                            if introFinished then return end
                            local s = Instance.new("Sound")
                            s.SoundId = SHOT_ID
                            s.Volume = vol
                            s.PlaybackSpeed = pitch
                            s.Parent = SoundService2
                            s:Play()
                            Debris2:AddItem(s, 3)
                        end)
                    end
                    bang(0.85, 1.0, 0)
                    bang(0.7, 0.7, 0.03)
                end)

                screenShake(0.45, 14)
            end

            local playStart = tick()
            local shotFired = false
            local exitTriggered = false
            while not introFinished and (tick() - playStart) < INTRO_DURATION do
                task.wait(0.05)
                pcall(function()
                    if introSound and introSound.Parent and not introSound.IsPlaying and introSound.TimeLength > 0 then
                        if introSound.TimePosition < math.min(INTRO_DURATION, introSound.TimeLength) - 0.2 then
                            introSound:Play()
                        end
                    end
                end)
                local elapsed = tick() - playStart
                local remaining = INTRO_DURATION - elapsed

                if (not shotFired) and remaining <= 5 then
                    shotFired = true
                    fireSniperShot()
                end

                if (not exitTriggered) and elapsed >= (INTRO_DURATION - 1.0) then
                    exitTriggered = true
                    stopIntroAnim()
                    pcall(function()
                        TweenService2:Create(calciumLbl, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            Position = calciumExit, TextTransparency = 1
                        }):Play()
                        TweenService2:Create(duelsLbl, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            Position = duelsExit, TextTransparency = 1
                        }):Play()
                        TweenService2:Create(orb, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
                        local closeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                        for _, fr in ipairs({scopeClip, housing, bevel, scopeRing2}) do
                            TweenService2:Create(fr, closeInfo, {
                                Size = UDim2.new(0, 0, 0, 0),
                                Position = UDim2.new(0.5, 0, 0.5, 0)
                            }):Play()
                        end
                    end)
                end
            end

            if not introFinished then
                finishIntro()
            end
        end)

        introCompleteEvent.Event:Wait()
        pcall(function() introCompleteEvent:Destroy() end)
    end

    LP.CharacterAdded:Connect(function(char)
        if ragdollCheckConn then 
            ragdollCheckConn:Disconnect()
            ragdollCheckConn = nil
        end
        timerActive = false
        lastRagdollState = false
        if timerConn then timerConn:Disconnect(); timerConn = nil end
        if timerBillboard then timerBillboard:Destroy(); timerBillboard = nil end
        
        task.wait(0.5)
        createTimerBillboard()
        checkRagdoll()
    end)
    
    task.spawn(function()
        task.wait(0.5)
        createTimerBillboard()
    end)
end

local function createRagdollBillboard(duration,labelText,color)
    if not ragdollGuiEnabled then return nil end
    local PINK  = color or Color3.fromRGB(160,80,255)
    local BG    = Color3.fromRGB(6,4,14)
    local WHITE = Color3.fromRGB(255,255,255)
    local W,H   = 210,80
    local guiName="MoveeRagdollTimer_"..labelText
    pcall(function()
        local cg=game:GetService("CoreGui");local old=cg:FindFirstChild(guiName);if old then old:Destroy() end
        local pg=LP:FindFirstChild("PlayerGui");if pg then local o=pg:FindFirstChild(guiName);if o then o:Destroy() end end
    end)
    local sg=Instance.new("ScreenGui")
    sg.Name=guiName;sg.ResetOnSpawn=false;sg.IgnoreGuiInset=true;sg.DisplayOrder=25
    parentGui(sg)
    local card=Instance.new("Frame",sg)
    card.Size=UDim2.new(0,W,0,H);card.Position=UDim2.new(0.5,-W/2,0,58)
    card.BackgroundColor3=BG;card.BackgroundTransparency=0.05
    card.BorderSizePixel=0;card.ZIndex=30;card.Active=true
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,14)
    local stroke=Instance.new("UIStroke",card)
    stroke.Color=PINK;stroke.Thickness=1;stroke.Transparency=0.6
    local titleLbl=Instance.new("TextLabel",card)
    titleLbl.Size=UDim2.new(1,-16,0,28);titleLbl.Position=UDim2.new(0,8,0,6)
    titleLbl.BackgroundTransparency=1
    titleLbl.Text=(labelText=="RAGDOLL" and "RAGDOLL TIMER" or (labelText=="STONE" and "STONE TIMER" or labelText.." TIMER"))
    titleLbl.TextColor3=PINK;titleLbl.Font=Enum.Font.GothamBlack;titleLbl.TextSize=13
    titleLbl.TextXAlignment=Enum.TextXAlignment.Center;titleLbl.ZIndex=32
    local divider=Instance.new("Frame",card)
    divider.Size=UDim2.new(1,-20,0,1);divider.Position=UDim2.new(0,10,0,34)
    divider.BackgroundColor3=PINK;divider.BackgroundTransparency=0.5;divider.BorderSizePixel=0;divider.ZIndex=31
    local timerLbl=Instance.new("TextLabel",card)
    timerLbl.Size=UDim2.new(1,0,0,H-38);timerLbl.Position=UDim2.new(0,0,0,36)
    timerLbl.BackgroundTransparency=1;timerLbl.Text=string.format("%.1f",duration).."s"
    timerLbl.TextColor3=PINK;timerLbl.Font=Enum.Font.GothamBlack;timerLbl.TextSize=24
    timerLbl.TextXAlignment=Enum.TextXAlignment.Center;timerLbl.ZIndex=32
    local shimmer=addShimmerToLabel(timerLbl,PINK,WHITE)
    task.spawn(function() local t=0;while timerLbl and timerLbl.Parent do t=t+0.04;shimmer.Offset=Vector2.new(math.sin(t)*0.5,0);task.wait(0.04) end end)
    local dragStart,dragStartPos,dragging=nil,nil,false
    card.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            dragging=true;dragStart=inp.Position;dragStartPos=card.Position
            inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
            local d=inp.Position-dragStart
            card.Position=UDim2.new(dragStartPos.X.Scale,dragStartPos.X.Offset+d.X,dragStartPos.Y.Scale,dragStartPos.Y.Offset+d.Y)
        end
    end)
    local startTime=tick();local conn
    conn=RunService.Heartbeat:Connect(function()
        local remaining=math.max(0,duration-(tick()-startTime))
        if remaining<=0 then conn:Disconnect();pcall(function() sg:Destroy() end)
        elseif timerLbl and timerLbl.Parent then timerLbl.Text=string.format("%.1f",remaining).."s" end
    end)
    return sg
end
local function onHumanoidStateChanged(old,new)
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid");if not hum then return end
    local isRag=(new==Enum.HumanoidStateType.Physics or new==Enum.HumanoidStateType.Ragdoll or new==Enum.HumanoidStateType.FallingDown)
    if isRag and not hum.PlatformStand and not activeBatBillboard then
        activeBatBillboard=createRagdollBillboard(2.5,"RAGDOLL",Color3.fromRGB(160,80,255))
        task.delay(2.6,function() if activeBatBillboard then pcall(function() activeBatBillboard:Destroy() end);activeBatBillboard=nil end end)
    end
end
local function onMedusaStateChanged()
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum and hum.PlatformStand and not activeMedusaBillboard then
        activeMedusaBillboard=createRagdollBillboard(4.5,"STONE",Color3.fromRGB(255,255,255))
        task.delay(4.5,function() if activeMedusaBillboard then pcall(function() activeMedusaBillboard:Destroy() end);activeMedusaBillboard=nil end end)
    end
end
local function setupRagdollTriggers()
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum then hum.StateChanged:Connect(onHumanoidStateChanged);hum:GetPropertyChangedSignal("PlatformStand"):Connect(onMedusaStateChanged) end
end
local function getSpeedThemeColors()
    local th=getTheme()
    local accent=th and th.ACCENT or Color3.fromRGB(255,255,255)
    local accent2=th and th.ACCENT2 or Color3.fromRGB(220,220,220)
    local gray=th and th.GRAY or Color3.fromRGB(200,200,210)
    return accent,accent2,gray
end
local function applySpeedIndicatorTheme()
    local char=LP.Character;if not char then return end
    local head=char:FindFirstChild("Head");if not head then return end
    local bb=head:FindFirstChild("MoveeSpeedBB");if not bb then return end
    local accent,accent2,gray=getSpeedThemeColors()
    for _,lbl in ipairs(bb:GetChildren()) do
        if lbl:IsA("TextLabel") then
            if string.find(lbl.Text or "", "S2HUB", 1, true) or lbl.Name=="DiscordLbl" then
                lbl.TextColor3=gray
                local gr=lbl:FindFirstChildOfClass("UIGradient")
                if gr then gr.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,gray),ColorSequenceKeypoint.new(0.5,accent),ColorSequenceKeypoint.new(1,gray)}) end
            else
                lbl.TextColor3=accent
                local gr=lbl:FindFirstChildOfClass("UIGradient")
                if gr then gr.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,accent2),ColorSequenceKeypoint.new(0.5,accent),ColorSequenceKeypoint.new(1,accent2)}) end
            end
        end
    end
end
local function setupSpeedIndicator(char)
    local head=char:WaitForChild("Head",5);if not head then return end
    if head:FindFirstChild("MoveeSpeedBB") then head.MoveeSpeedBB:Destroy() end
    local accent,accent2,gray=getSpeedThemeColors()
    local bb=Instance.new("BillboardGui",head);bb.Name="MoveeSpeedBB";bb.Size=UDim2.new(0,220,0,92);bb.StudsOffset=Vector3.new(0,3.25,0);bb.AlwaysOnTop=true;bb.LightInfluence=0
    local titleLabel=Instance.new("TextLabel",bb);titleLabel.Name="TitleLbl";titleLabel.Size=UDim2.new(1,-8,0,24);titleLabel.Position=UDim2.new(0,4,0,0);titleLabel.BackgroundTransparency=1;titleLabel.Text="BEST FREE DUEL SCRIPT"
    titleLabel.TextColor3=accent;titleLabel.Font=Enum.Font.GothamBold;titleLabel.TextSize=14;titleLabel.TextScaled=false;titleLabel.TextWrapped=false;titleLabel.TextStrokeTransparency=0
    local discordLabel=Instance.new("TextLabel",bb);discordLabel.Name="DiscordLbl";discordLabel.Size=UDim2.new(1,-8,0,22);discordLabel.Position=UDim2.new(0,4,0,25);discordLabel.BackgroundTransparency=1;discordLabel.Text="Discord.gg//S2HUB"
    discordLabel.TextColor3=gray;discordLabel.Font=Enum.Font.GothamBold;discordLabel.TextSize=13;discordLabel.TextScaled=false;discordLabel.TextWrapped=false;discordLabel.TextStrokeTransparency=0
    speedLabel=Instance.new("TextLabel",bb);speedLabel.Name="SpeedLbl";speedLabel.Size=UDim2.new(1,-8,0,28);speedLabel.Position=UDim2.new(0,4,0,49);speedLabel.BackgroundTransparency=1;speedLabel.Text="SPEED: 0"
    speedLabel.TextColor3=accent;speedLabel.Font=Enum.Font.GothamBold;speedLabel.TextSize=15;speedLabel.TextScaled=false;speedLabel.TextWrapped=false;speedLabel.TextStrokeTransparency=0
    local gr0=addShimmerToLabel(titleLabel,accent2,accent)
    local gr1=addShimmerToLabel(speedLabel,accent2,accent)
    local gr2=addShimmerToLabel(discordLabel,gray,accent)
    task.spawn(function() local t=0;while bb and bb.Parent do t=t+0.03;local o=Vector2.new(math.sin(t)*0.4,0);gr0.Offset=o;gr1.Offset=o;gr2.Offset=o;task.wait(0.04) end end)
end
local function getActiveMoveSpeed()
    if laggerCarryActive then return LAGGER_CARRY_SPEED
    elseif laggerModeEnabled then return LAGGER_SPEED
    elseif carrySpeedActive then return CS
    else return NS end
end
local function getAutoPathSpeed()
    if laggerModeEnabled then return LAGGER_SPEED
    else return NS end
end

local function applyVel(part, targetVel)
    if not part or not part.Parent then return end
    local mass = part.AssemblyMass
    if mass and mass > 0 then
        local delta = targetVel - part.AssemblyLinearVelocity
        part:ApplyImpulse(delta * mass)
    else
        part.AssemblyLinearVelocity = targetVel
    end
end

local function applyAngVel(part, targetAng)
    if not part or not part.Parent then return end
    part.AssemblyAngularVelocity = targetAng
end

local function manualJumpBoost(boost)
    if not infJumpEnabled or infJumpMode~="manual" then return end
    local char=LP.Character;if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart");if root then applyVel(root, Vector3.new(root.AssemblyLinearVelocity.X,boost,root.AssemblyLinearVelocity.Z)) end
end
local function startHoldInfJump()
    if holdInfJumpConn then holdInfJumpConn:Disconnect() end
    holdInfJumpConn=RunService.Heartbeat:Connect(function()
        if not infJumpEnabled or infJumpMode~="hold" then return end
        local char=LP.Character;if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart");local hum=char:FindFirstChildOfClass("Humanoid");if not root or not hum then return end
        local isJumpHeld=UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump==true)
        local cv=root.AssemblyLinearVelocity
        if isJumpHeld and cv.Y<35 then applyVel(root, Vector3.new(cv.X,55,cv.Z)) end
        cv=root.AssemblyLinearVelocity
        if cv.Y<-120 then applyVel(root, Vector3.new(cv.X,-120,cv.Z)) end
    end)
end
loadstring(game:HttpGet("https://raw.githubusercontent.com/Argian-dotcom/Jdkffkfo/refs/heads/main/Coding"))()
local function stopHoldInfJump() if holdInfJumpConn then holdInfJumpConn:Disconnect();holdInfJumpConn=nil end end
UIS.JumpRequest:Connect(function() manualJumpBoost(50) end)
UIS.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Keyboard and input.KeyCode==Enum.KeyCode.Space and not UIS:GetFocusedTextBox() then
        task.delay(0.12,function() if UIS:IsKeyDown(Enum.KeyCode.Space) then manualJumpBoost(50) end end)
    end
end)
RunService.Heartbeat:Connect(function() if UIS:IsKeyDown(Enum.KeyCode.Space) then manualJumpBoost(50) end end)
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
_antiKickConns={}
enableAntiKick=function()
    antiKickEnabled=true
    task.spawn(function()
        while antiKickEnabled do
            task.wait(0.5);local char=LP.Character
            if char then
                for _,tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        local n=tool.Name:lower()
                        if n:find("brainrot") or n:find("skibidi") or n:find("toilet") then
                            brainrotDetected=true
                            if autoBatEnabled then autoBatEnabled=false;if resetAutoBatMotion then resetAutoBatMotion() end;if autoBatSetVisual then autoBatSetVisual(false) end end
                            if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end end
                            if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end end
                        else brainrotDetected=false end
                    end
                end
            end
        end
    end)
end
disableAntiKick=function()
    antiKickEnabled=false;brainrotDetected=false
    for _,c in ipairs(_antiKickConns) do pcall(function() c:Disconnect() end) end;_antiKickConns={}
end
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
    local wasAntiRagEnabled=antiRagdollEnabled
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
        task.wait(0.7)
        if wasAntiRagEnabled and not antiRagdollEnabled then antiRagdollEnabled=true;startAntiRagdoll() end
    end)
end

KB={DropBrainrot={kb=nil,gp=nil},AutoLeft={kb=nil,gp=nil},AutoRight={kb=nil,gp=nil},AutoBat={kb=nil,gp=nil},AimbotV2={kb=nil,gp=nil},TPFloor={kb=nil,gp=nil},InstaReset={kb=nil,gp=nil},GuiHide={kb=nil,gp=nil},SpeedToggle={kb=nil,gp=nil},LaggerToggle={kb=nil,gp=nil},LaggerCarry={kb=nil,gp=nil},AntiDesync={kb=nil,gp=nil},LaggerPanel={kb=nil,gp=nil},TPBat={kb=nil,gp=nil}}
AP_L1,AP_L2=Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81)
AP_R1,AP_R2=Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48)
Steal={AutoStealEnabled=false,StealRadius=8,PrimeRange=8,StealDuration=0.3,Mode="half",HalfFireRange=8,HalfHoldMin=1.3,HalfHoldMax=2.6,HalfEntryDelay=0.3,Data={},plotCache={},plotCacheTime={},cachedPrompts={},promptCacheTime=0}
lastStealTick=0
isStealing,stealStartTime=false,nil
Conns={autoSteal=nil,antiRag=nil,batCounter=nil,anchor={}}
MEDUSA_COOLDOWN=25;batCounterDebounce=false
modeValLbl=nil;lastMoveDir=Vector3.new(0,0,0)
MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,[Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}
local function isRagdollState(hum)
    if not hum then return true end;local st=hum:GetState()
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
end
local function isMyPlotByName(plotName)
    local ct=tick()
    if Steal.plotCache[plotName] ~= nil and (ct-(Steal.plotCacheTime[plotName] or 0)) < 2 then
        return Steal.plotCache[plotName]
    end
    local plots=workspace:FindFirstChild("Plots"); if not plots then Steal.plotCache[plotName]=false; Steal.plotCacheTime[plotName]=ct; return false end
    local plot=plots:FindFirstChild(plotName); if not plot then Steal.plotCache[plotName]=false; Steal.plotCacheTime[plotName]=ct; return false end
    local sign=plot:FindFirstChild("PlotSign")
    if sign then
        local yb=sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then
            local r = yb.Enabled==true
            Steal.plotCache[plotName]=r; Steal.plotCacheTime[plotName]=ct
            return r
        end
    end
    Steal.plotCache[plotName]=false; Steal.plotCacheTime[plotName]=ct
    return false
end

local function collectPromptFromSpawn(sp)
    if not sp then return nil end
    local att = sp:FindFirstChild("PromptAttachment")
    if att then
        for _,child in ipairs(att:GetChildren()) do
            if child:IsA("ProximityPrompt") then return child end
        end
    end
    for _,child in ipairs(sp:GetDescendants()) do
        if child:IsA("ProximityPrompt") then return child end
    end
    return nil
end

local function isNearPodiumWithPrompt()
    local char=LP.Character
    local hrpL=char and char:FindFirstChild("HumanoidRootPart")
    if not hrpL then return false end
    local plots=workspace:FindFirstChild("Plots")
    if not plots then return false end
    for _,plot in ipairs(plots:GetChildren()) do
        if not isMyPlotByName(plot.Name) then
            local podiums=plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _,podium in ipairs(podiums:GetChildren()) do
                    local base=podium:FindFirstChild("Base")
                    local sp=base and base:FindFirstChild("Spawn")
                    if sp then
                        local d=(hrpL.Position-sp.Position).Magnitude
                        if d <= (Steal.PrimeRange or Steal.StealRadius or 60) then
                            if collectPromptFromSpawn(sp) then return true end
                        end
                    end
                end
            end
        end
    end
    return false
end

local function findNearestPrompt()
	local char=LP.Character; if not char then return nil end
	local root=char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
	if not root then return nil end
	local plots=workspace:FindFirstChild("Plots"); if not plots then return nil end
	local nearest,dist=nil,math.huge
	for _,plot in ipairs(plots:GetChildren()) do
		if plot:IsA("Model") and not isMyPlotByName(plot.Name) then
			local pods=plot:FindFirstChild("AnimalPodiums")
			if pods then
				for _,pod in ipairs(pods:GetChildren()) do
					local base=pod:FindFirstChild("Base")
					local sp=base and base:FindFirstChild("Spawn")
					if sp then
						local d=(sp.Position-root.Position).Magnitude
if d<=(Steal.PrimeRange or Steal.StealRadius or 60) and d<dist then
							local found=nil
							local att=sp:FindFirstChild("PromptAttachment")
							if att then for _,pr in ipairs(att:GetChildren()) do if pr:IsA("ProximityPrompt") and pr.ActionText and pr.ActionText:find("Steal") then found=pr end end end
							if not found then for _,pr in ipairs(sp:GetDescendants()) do if pr:IsA("ProximityPrompt") and pr.ActionText and pr.ActionText:find("Steal") then found=pr end end end
							if found then nearest,dist=found,d end
						end
					end
				end
			end
		end
	end
	return nearest
end

local function _promptDist(prompt)
	local char=LP.Character; if not char then return math.huge end
	local root=char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
	if not root then return math.huge end
	local part=prompt.Parent
	if part and part:IsA("Attachment") then part=part.Parent end
	if part and part:IsA("BasePart") then return (part.Position-root.Position).Magnitude end
	local ok,cf=pcall(function() return prompt.Parent and prompt.Parent.WorldPosition end)
	if ok and cf then return (cf-root.Position).Magnitude end
	return math.huge
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
	local data=Steal.Data[prompt]; if not data.ready then return end
	data.ready=false; isStealing=true; stealStartTime=tick()
	if Steal.Mode=="half" then
		task.spawn(function()
			for _,fn in ipairs(data.hold) do task.spawn(fn) end
			task.wait(Steal.HalfHoldMin)
			local inRange=_promptDist(prompt)<=Steal.HalfFireRange
			while true do
				local el=tick()-stealStartTime
				if el>Steal.HalfHoldMax or not prompt.Parent then break end
				if _promptDist(prompt)<=Steal.HalfFireRange then
					if not inRange then task.wait(Steal.HalfEntryDelay) end
					for _,fn in ipairs(data.trigger) do task.spawn(fn) end; break
				end
				task.wait()
			end
			task.wait(0.05); data.ready=true; isStealing=false
		end)
	else
		task.spawn(function()
			for _,fn in ipairs(data.hold) do task.spawn(fn) end
			local el=0; while el<Steal.StealDuration do el=el+task.wait() end
			for _,fn in ipairs(data.trigger) do task.spawn(fn) end
			task.wait(0.05); data.ready=true; isStealing=false
		end)
	end
end

startAutoSteal=function()
	if Conns.autoSteal then return end
	Conns.autoSteal=RunService.Heartbeat:Connect(function()
		if not Steal.AutoStealEnabled or isStealing then return end
		local p=findNearestPrompt(); if p then executeSteal(p) end
	end)
end

stopAutoSteal=function()
	if Conns.autoSteal then Conns.autoSteal:Disconnect(); Conns.autoSteal=nil end
	isStealing=false
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
        if md.Magnitude>0 then lastMoveDir=md;applyVel(hrp, Vector3.new(md.X*spd,hrp.AssemblyLinearVelocity.Y,md.Z*spd))
        elseif antiRagdollEnabled and lastMoveDir.Magnitude>0 then
            local anyHeld=false;for key in pairs(MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld=true;break end end
            if anyHeld then applyVel(hrp, Vector3.new(lastMoveDir.X*spd,hrp.AssemblyLinearVelocity.Y,lastMoveDir.Z*spd)) end
        end
    end
    if speedLabel then speedLabel.Text="SPEED: "..string.format("%.1f",Vector3.new(hrp.AssemblyLinearVelocity.X,0,hrp.AssemblyLinearVelocity.Z).Magnitude) end
end)
LP.CharacterAdded:Connect(function(char)
    task.wait(0.5);setupSpeedIndicator(char);setupRagdollTriggers()
    if medusaCounterEnabled then setupMedusa(char) end
    if batCounterEnabled then startBatCounter() end
    if unwalkEnabled then task.wait(0.5);startUnwalk() end
end)
if LP.Character then setupSpeedIndicator(LP.Character);setupRagdollTriggers() end
alConn,arConn=nil,nil;alPhase,arPhase=1,1
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
            if (tgt-hrp.Position).Magnitude<1 then alPhase=2;local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);applyVel(hrp, Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd));return end
            local d=AP_L1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);applyVel(hrp, Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd))
        elseif alPhase==2 then
            local tgt=Vector3.new(AP_L2.X,hrp.Position.Y,AP_L2.Z)
            if (tgt-hrp.Position).Magnitude<1 then hum:Move(Vector3.zero,false);applyVel(hrp, Vector3.zero);autoLeftEnabled=false;if alConn then alConn:Disconnect();alConn=nil end;alPhase=1;if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end;return end
            local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);applyVel(hrp, Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd))
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
            if (tgt-hrp.Position).Magnitude<1 then arPhase=2;local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);applyVel(hrp, Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd));return end
            local d=AP_R1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);applyVel(hrp, Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd))
        elseif arPhase==2 then
            local tgt=Vector3.new(AP_R2.X,hrp.Position.Y,AP_R2.Z)
            if (tgt-hrp.Position).Magnitude<1 then hum:Move(Vector3.zero,false);applyVel(hrp, Vector3.zero);autoRightEnabled=false;if arConn then arConn:Disconnect();arConn=nil end;arPhase=1;if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end;return end
            local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);applyVel(hrp, Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd))
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
runDrop=function()
    if dropActive then return end
    local char=LP.Character;if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart");if not root then return end
    dropActive=true;local t0=tick();local dc
    dc=RunService.Heartbeat:Connect(function()
        local r=char and char:FindFirstChild("HumanoidRootPart")
        if not r then dc:Disconnect();dropActive=false;return end
        if tick()-t0>=DROP_ASCEND_DURATION then
            dc:Disconnect()
            local rp=RaycastParams.new();rp.FilterDescendantsInstances={char};rp.FilterType=Enum.RaycastFilterType.Exclude
            local rr=workspace:Raycast(r.Position,Vector3.new(0,-2000,0),rp)
            if rr then local hum2=char:FindFirstChildOfClass("Humanoid");local off=(hum2 and hum2.HipHeight or 2)+(r.Size.Y/2);r.CFrame=CFrame.new(r.Position.X,rr.Position.Y+off,r.Position.Z);applyVel(r, Vector3.zero) end
            dropActive=false;return end
        applyVel(r, Vector3.new(r.AssemblyLinearVelocity.X,DROP_ASCEND_SPEED,r.AssemblyLinearVelocity.Z))
    end)
end
local function doAutoTPDown(force)
    local char=LP.Character;if not char then return end;local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end
    local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
    if not force then if hum2.FloorMaterial~=Enum.Material.Air then return end;if not(hrp.Position.Y>=autoTPHeight) then return end end
    hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)*CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0);applyVel(hrp, Vector3.zero)
end
startAutoTP=function()
    if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end
    autoTPConn=task.spawn(function() while autoTPEnabled do task.wait(0.1);pcall(function() doAutoTPDown(false) end) end end)
end
stopAutoTP=function() autoTPEnabled=false;if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end end
runTPFloor=function() pcall(function() doAutoTPDown(true) end) end
defLightBrightness,defLightClock,defLightAmbient=nil,nil,nil
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
            if medusaResetEnabled then
                cursedInstaReset()
            elseif medusaCounterEnabled then
                useMedusaCounter()
            end
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
BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
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
aimbotConn=nil
aimbotV2Conn=nil
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
local function getClosestPlayerAim(maxDist)
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart");if not root then return nil,math.huge end
    local closest,minDist=nil,maxDist or math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local tRoot=plr.Character:FindFirstChild("HumanoidRootPart");local hum=plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health>0 then local dist=(tRoot.Position-root.Position).Magnitude;if dist<minDist then minDist=dist;closest=plr end end
        end
    end
    return closest,minDist
end
_predBall=nil
startBatAimbot=function()
    if aimbotConn then aimbotConn:Disconnect() end;autoBatEnabled=true
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
    
    local char=LP.Character;if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart");local hum0=char:FindFirstChildOfClass("Humanoid")
    if not root or not hum0 then return end;hum0.AutoRotate=false
    
    local AIMBOT_SPEED=58.5;local MELEE_OFFSET=3;local velHistory={};local MAX_HIST=6;local lastTargetPos=nil
    
    aimbotConn=RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        local c=LP.Character;if not c then return end
        local hrp=c:FindFirstChild("HumanoidRootPart");if not hrp then return end
        local hum=c:FindFirstChildOfClass("Humanoid");if not hum then return end
        
        local bat=findBat();if bat and bat.Parent~=c then pcall(function() hum:EquipTool(bat) end) end
        
        local target=getClosestTarget()
        if not target then swingCurrentBat();if _predBall then _predBall:Destroy();_predBall=nil end;velHistory={};lastTargetPos=nil;return end
        
        local targetVel=target.AssemblyLinearVelocity;local targetPos=target.Position
        
        if lastTargetPos and (targetPos-lastTargetPos).Magnitude>20 then velHistory={} end
        lastTargetPos=targetPos
        
        table.insert(velHistory,targetVel);if #velHistory>MAX_HIST then table.remove(velHistory,1) end
        local smoothVel=Vector3.zero;local totalW=0
        for i,v in ipairs(velHistory) do local w=i/#velHistory;smoothVel=smoothVel+v*w;totalW=totalW+w end
        if totalW>0 then smoothVel=smoothVel/totalW end
        
        local speed=smoothVel.Magnitude
        local predictTime=#velHistory<2 and 0 or math.clamp(speed/150,0.05,0.2)
        local predictedPos=targetPos+smoothVel*predictTime
        
        pcall(function()
            if not _predBall then
                _predBall=Instance.new("Part")
                _predBall.Name="PredictionBall"
                _predBall.Shape=Enum.PartType.Ball
                _predBall.Size=Vector3.new(3,3,3)
                _predBall.Color=(getTheme() and getTheme().ACCENT) or Color3.fromRGB(192,192,192)
                _predBall.Material=Enum.Material.Neon
                _predBall.CanCollide=false
                _predBall.CastShadow=false
                _predBall.TopSurface=Enum.SurfaceType.Smooth
                _predBall.BottomSurface=Enum.SurfaceType.Smooth
                _predBall.Parent=workspace
            end
            if _predBall and _predBall.Parent then
                _predBall.CFrame=CFrame.new(predictedPos)
                _predBall.Transparency=0.1
                local accent=(getTheme() and getTheme().ACCENT) or Color3.fromRGB(192,192,192)
                if _predBall.Color ~= accent then _predBall.Color = accent end
            end
        end)
        
        local toTarget=predictedPos-hrp.Position
        if toTarget.Magnitude>0.5 then
            local goalCF=CFrame.lookAt(hrp.Position,hrp.Position+toTarget)
            local diffCF=hrp.CFrame:Inverse()*goalCF
            local rx,ry,rz=diffCF:ToEulerAnglesXYZ()
            rx=math.clamp(rx,-3,3);ry=math.clamp(ry,-3,3);rz=math.clamp(rz,-3,3)
            hrp.AssemblyAngularVelocity=hrp.CFrame:VectorToWorldSpace(Vector3.new(rx*50,ry*50,rz*50))
        end
        
        local dirToTarget=predictedPos-hrp.Position;local targetStandPos=predictedPos
        if dirToTarget.Magnitude>0 then targetStandPos=predictedPos-(dirToTarget.Unit*MELEE_OFFSET) end
        
        local moveDir=targetStandPos-hrp.Position
        if moveDir.Magnitude>1 then
            applyVel(hrp, moveDir.Unit*AIMBOT_SPEED)
        else
            applyVel(hrp, smoothVel)
        end
        swingCurrentBat()
    end)
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
end
stopBatAimbot=function()
    if aimbotConn then aimbotConn:Disconnect();aimbotConn=nil end;autoBatEnabled=false
    if _predBall then _predBall:Destroy();_predBall=nil end
    local char=LP.Character;local root=char and char:FindFirstChild("HumanoidRootPart")
    if root then applyVel(root, Vector3.zero);applyAngVel(root, Vector3.zero) end
    local hum2=char and char:FindFirstChildOfClass("Humanoid");if hum2 then hum2.AutoRotate=true end
    if autoTPEnabled then startAutoTP() end
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
end
startAimbotV2=function()
    if aimbotV2Conn then aimbotV2Conn:Disconnect() end;aimbotV2Enabled=true
    if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
    local char=LP.Character;if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart");local hum0=char:FindFirstChildOfClass("Humanoid")
    if not root or not hum0 then return end
    hum0.AutoRotate=false

    local FACE_OFFSET=3;local VYSE_HIT_DIST=12;local AIMBOT_SPD=55
    local velHistory={};local MAX_HIST=6;local lastTargetPos=nil

    aimbotV2Conn=RunService.RenderStepped:Connect(function()
        if not aimbotV2Enabled then return end
        local char2=LP.Character;if not char2 then return end
        local root2=char2:FindFirstChild("HumanoidRootPart");if not root2 then return end
        local hum2=char2:FindFirstChildOfClass("Humanoid");if not hum2 then return end

        local bat=findBat();if bat and bat.Parent~=char2 then pcall(function() hum2:EquipTool(bat) end) end

        local target,dist=getClosestPlayerAim()
        if not target or not target.Character then
            applyVel(root2, Vector3.new(0,root2.AssemblyLinearVelocity.Y,0))
            applyAngVel(root2, Vector3.zero)
            if _predBall then _predBall:Destroy();_predBall=nil end
            velHistory={};lastTargetPos=nil
            return
        end

        local tr=target.Character:FindFirstChild("HumanoidRootPart")
        if not tr then return end

        local head=target.Character:FindFirstChild("Head")
        local targetPos=head and head.Position or tr.Position
        local targetVel=tr.AssemblyLinearVelocity

        if lastTargetPos and (targetPos-lastTargetPos).Magnitude>20 then velHistory={} end
        lastTargetPos=targetPos

        table.insert(velHistory,targetVel);if #velHistory>MAX_HIST then table.remove(velHistory,1) end
        local smoothVel=Vector3.zero;local totalW=0
        for i,v in ipairs(velHistory) do local w=i/#velHistory;smoothVel=smoothVel+v*w;totalW=totalW+w end
        if totalW>0 then smoothVel=smoothVel/totalW end

        local speed=smoothVel.Magnitude
        local predictTime=#velHistory<2 and 0 or math.clamp(speed/150,0.05,0.2)
        local predictedPos=targetPos+smoothVel*predictTime

        pcall(function()
            if not _predBall then
                _predBall=Instance.new("Part")
                _predBall.Name="PredictionBall"
                _predBall.Shape=Enum.PartType.Ball
                _predBall.Size=Vector3.new(3,3,3)
                _predBall.Color=(getTheme() and getTheme().ACCENT) or Color3.fromRGB(192,192,192)
                _predBall.Material=Enum.Material.Neon
                _predBall.CanCollide=false
                _predBall.CastShadow=false
                _predBall.TopSurface=Enum.SurfaceType.Smooth
                _predBall.BottomSurface=Enum.SurfaceType.Smooth
                _predBall.Parent=workspace
            end
            if _predBall and _predBall.Parent then
                _predBall.CFrame=CFrame.new(predictedPos)
                _predBall.Transparency=0.1
                local accent=(getTheme() and getTheme().ACCENT) or Color3.fromRGB(192,192,192)
                if _predBall.Color ~= accent then _predBall.Color = accent end
            end
        end)

        local toTarget=predictedPos-root2.Position
        if toTarget.Magnitude>0.5 then
            local goalCF=CFrame.lookAt(root2.Position,root2.Position+toTarget)
            local diffCF=root2.CFrame:Inverse()*goalCF
            local rx,ry,rz=diffCF:ToEulerAnglesXYZ()
            rx=math.clamp(rx,-3,3);ry=math.clamp(ry,-3,3);rz=math.clamp(rz,-3,3)
            root2.AssemblyAngularVelocity=root2.CFrame:VectorToWorldSpace(Vector3.new(rx*50,ry*50,rz*50))
        end

        local aimPoint=predictedPos+tr.CFrame.LookVector*FACE_OFFSET
        local direction=(aimPoint-root2.Position)
        if direction.Magnitude>0.5 then
            applyVel(root2, direction.Unit*AIMBOT_SPD)
        else
            applyVel(root2, Vector3.new(smoothVel.X,root2.AssemblyLinearVelocity.Y,smoothVel.Z))
        end

        if dist<=VYSE_HIT_DIST and autoSwingEnabled then swingCurrentBat() end
    end)
    if mobBtnRefs.aimbotV2 then mobBtnRefs.aimbotV2(true) end
end
stopAimbotV2=function()
    if aimbotV2Conn then aimbotV2Conn:Disconnect();aimbotV2Conn=nil end;aimbotV2Enabled=false
    if _predBall then _predBall:Destroy();_predBall=nil end
    local char=LP.Character;local root=char and char:FindFirstChild("HumanoidRootPart")
    if root then
        applyVel(root, Vector3.new(0,root.AssemblyLinearVelocity.Y,0))
        applyAngVel(root, Vector3.zero)
    end
    local hum2=char and char:FindFirstChildOfClass("Humanoid");if hum2 then hum2.AutoRotate=true end
    if mobBtnRefs.aimbotV2 then mobBtnRefs.aimbotV2(false) end
end

-- ── Bat TP / Anti Desync (Ace portée S2) ─────────────────────────────
_G.S2AntiDesync = _G.S2AntiDesync or {
    conn = nil,
    hittingCooldown = false,
    h = nil,
    hrp = nil,
    diedConn = nil
}
_G.S2AntiDesyncAimbotOn = false

function _G.S2AntiDesyncGetBat()
    local char = LP.Character
    if not char then return nil end
    local tool = char:FindFirstChild("Bat")
    if tool then return tool end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        tool = bp:FindFirstChild("Bat")
        if tool then
            tool.Parent = char
            return tool
        end
    end
    return nil
end

function _G.S2AntiDesyncTrySwing()
    if not _G.S2AntiDesync or _G.S2AntiDesync.hittingCooldown then return end
    _G.S2AntiDesync.hittingCooldown = true
    pcall(function()
        local bat = _G.S2AntiDesyncGetBat()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(0.08, function()
        if _G.S2AntiDesync then _G.S2AntiDesync.hittingCooldown = false end
    end)
end

function _G.S2AntiDesyncGetClosestPlayer()
    local hrp = _G.S2AntiDesync and _G.S2AntiDesync.hrp
    if not hrp then return nil, math.huge end
    local cp, cd = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local d = (hrp.Position - tr.Position).Magnitude
                if d < cd then cd = d; cp = p end
            end
        end
    end
    return cp, cd
end

function _G.S2AntiDesyncSetupChar(char)
    task.wait(0.1)
    if not _G.S2AntiDesync then return end
    _G.S2AntiDesync.h = char and char:WaitForChild("Humanoid", 5) or nil
    _G.S2AntiDesync.hrp = char and char:WaitForChild("HumanoidRootPart", 5) or nil
    batTP.h = _G.S2AntiDesync.h
    batTP.hrp = _G.S2AntiDesync.hrp
    if _G.S2AntiDesync.diedConn then
        pcall(function() _G.S2AntiDesync.diedConn:Disconnect() end)
        _G.S2AntiDesync.diedConn = nil
    end
    if _G.S2AntiDesync.h and _G.S2AntiDesyncAimbotOn then
        _G.S2AntiDesync.diedConn = _G.S2AntiDesync.h.Died:Connect(function()
            _G.S2StopAntiDesyncAimbot()
            if batTP.setVisual then batTP.setVisual(false) end
            if mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
        end)
    end
end

LP.CharacterAdded:Connect(function(char)
    pcall(function() _G.S2AntiDesyncSetupChar(char) end)
end)
if LP.Character then
    task.spawn(function()
        pcall(function() _G.S2AntiDesyncSetupChar(LP.Character) end)
    end)
end

function _G.S2StartAntiDesyncAimbot()
    _G.S2AntiDesyncAimbotOn = true
    batTP.enabled = true
    if _G.S2AntiDesync.conn then
        _G.S2AntiDesync.conn:Disconnect()
        _G.S2AntiDesync.conn = nil
    end
    if LP.Character then
        pcall(function() _G.S2AntiDesyncSetupChar(LP.Character) end)
    end
    _G.S2AntiDesync.conn = RunService.Heartbeat:Connect(function()
        if not (_G.S2AntiDesyncAimbotOn and _G.S2AntiDesync.h and _G.S2AntiDesync.hrp) then return end
        local target, dist = _G.S2AntiDesyncGetClosestPlayer()
        if target and target.Character then
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                pcall(function()
                    if sethiddenproperty then
                        sethiddenproperty(_G.S2AntiDesync.hrp, "PhysicsRepRootPart", tr)
                    end
                end)
                local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
                if (_G.S2AntiDesync.hrp.Position - targetPos).Magnitude > 8 then
                    _G.S2AntiDesync.hrp.CFrame = CFrame.new(targetPos)
                end
                local cam = workspace.CurrentCamera
                if cam then
                    cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position)
                end
                if autoSwingEnabled then
                    _G.S2AntiDesyncTrySwing()
                end
            end
        end
    end)
    batTP.conn = _G.S2AntiDesync.conn
    if batTP.setVisual then batTP.setVisual(true) end
    if mobBtnRefs.tpBat then mobBtnRefs.tpBat(true) end
    saveConfig()
end

function _G.S2StopAntiDesyncAimbot()
    _G.S2AntiDesyncAimbotOn = false
    batTP.enabled = false
    if _G.S2AntiDesync and _G.S2AntiDesync.conn then
        _G.S2AntiDesync.conn:Disconnect()
        _G.S2AntiDesync.conn = nil
    end
    batTP.conn = nil
    if _G.S2AntiDesync then _G.S2AntiDesync.hittingCooldown = false end
    if _G.S2AntiDesync and _G.S2AntiDesync.diedConn then
        _G.S2AntiDesync.diedConn:Disconnect()
        _G.S2AntiDesync.diedConn = nil
    end
    batTP.hrp = nil
    batTP.h = nil
    if batTP.setVisual then batTP.setVisual(false) end
    if mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
    saveConfig()
end

function _G.S2ToggleAntiDesyncAimbot()
    if _G.S2AntiDesyncAimbotOn then
        _G.S2StopAntiDesyncAimbot()
    else
        _G.S2StartAntiDesyncAimbot()
    end
end

-- Wrapper for existing UI
batTP = batTP or {}
batTP.start = function() _G.S2StartAntiDesyncAimbot() end
batTP.stop = function() _G.S2StopAntiDesyncAimbot() end
batTP.toggle = function() _G.S2ToggleAntiDesyncAimbot() end
batTP.enabled = false
batTP.setVisual = nil  -- will be set by the UI code

startAutoPlay=function()
    autoPlayEnabled=true
    stopAutoLeft();stopAutoRight()
    autoLeftEnabled=false;autoRightEnabled=false
    local side = "left"
    pcall(function()
        local plots=workspace:FindFirstChild("Plots")
        local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not plots or not hrp then return end
        for _,p in ipairs(plots:GetChildren()) do
            local sign=p:FindFirstChild("PlotSign")
            local yb=sign and sign:FindFirstChild("YourBase")
            if yb and ((yb:IsA("BillboardGui") and yb.Enabled) or (typeof(yb.Enabled)=="boolean" and yb.Enabled)) then
                local o=p:GetAttribute("Order")
                if o==1 or o=="1" then side="right" else side="left" end
                return
            end
        end
        local AP_L = Vector3.new(-352, -6, 7)
        local AP_R = Vector3.new(-352, -6, 113)
        if (hrp.Position-AP_R).Magnitude < (hrp.Position-AP_L).Magnitude then side="right" else side="left" end
    end)
    if side=="left" then
        autoLeftEnabled=true
        if type(startAutoLeft)=="function" then startAutoLeft() end
    else
        autoRightEnabled=true
        if type(startAutoRight)=="function" then startAutoRight() end
    end
    if autoPlaySetVisual then autoPlaySetVisual(true) end
    if mobBtnRefs.autoPlay then mobBtnRefs.autoPlay(true) end
end
stopAutoPlay=function()
    autoPlayEnabled=false
    autoLeftEnabled=false;autoRightEnabled=false
    if type(stopAutoLeft)=="function" then stopAutoLeft() end
    if type(stopAutoRight)=="function" then stopAutoRight() end
    if autoPlaySetVisual then autoPlaySetVisual(false) end
    if mobBtnRefs.autoPlay then mobBtnRefs.autoPlay(false) end
end

queueAutoBatStart=function()
    if antiKickEnabled and brainrotDetected then return end
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
    startBatAimbot()
end
resetAutoBatMotion=function()
    local char=LP.Character;local hrp=char and char:FindFirstChild("HumanoidRootPart");local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hrp then applyVel(hrp, hrp.AssemblyLinearVelocity*0.3);applyAngVel(hrp, Vector3.zero) end
    if hum then hum.AutoRotate=true end
end
saveConfig=function()
    local ok, err = pcall(function()
        local function ks(e)
            if type(e)~="table" then return {kb=nil,gp=nil} end
            if e.kb then return {kb=e.kb.Name,gp=e.gp and e.gp.Name}
            elseif e.gp then return {gp=e.gp.Name}
            else return {kb=nil,gp=nil} end
        end
        local btnPos = {}
        pcall(function() btnPos = loadBtnPositions() or {} end)
        local cfg = {
            normalSpeed=NS, carrySpeed=CS,
            dropBrainrotKey=ks(KB.DropBrainrot), autoLeftKey=ks(KB.AutoLeft), autoRightKey=ks(KB.AutoRight),
            autoBatKey=ks(KB.AutoBat), aimbotV2Key=ks(KB.AimbotV2), laggerToggleKey=ks(KB.LaggerToggle),
            laggerCarryKey=ks(KB.LaggerCarry), tpFloorKey=ks(KB.TPFloor), instaResetKey=ks(KB.InstaReset),
            guiHideKey=ks(KB.GuiHide), speedToggleKey=ks(KB.SpeedToggle), antiDesyncKey=ks(KB.AntiDesync),
            tpBatKey=ks(KB.TPBat), autoCarryEnabled=autoCarryEnabled==true,
            grabRadius=Steal.StealRadius, primeRange=Steal.PrimeRange, stealDuration=Steal.StealDuration,
            antiRagdoll=antiRagdollEnabled==true,
            autoStealEnabled=Steal.AutoStealEnabled==true,
            infiniteJump=infJumpEnabled==true, infJumpMode=infJumpMode,
            medusaCounter=medusaCounterEnabled==true, batCounter=batCounterEnabled==true,
            carrySpeedActive=carrySpeedActive==true, laggerModeEnabled=laggerModeEnabled==true,
            laggerCarryActive=laggerCarryActive==true,
            laggerSpeed=LAGGER_SPEED, laggerCarrySpeed=LAGGER_CARRY_SPEED,
            autoBat=autoBatEnabled==true, aimbotV2=aimbotV2Enabled==true,
            autoSwing=autoSwingEnabled==true, unwalkEnabled=unwalkEnabled==true,
            antiLag=antiLagEnabled==true, autoTPEnabled=autoTPEnabled==true, autoTPHeight=autoTPHeight,
            guiTransparencyEnabled=guiTransparencyEnabled==true,
            mobileButtonsEnabled=mobileButtonsEnabled==true, mobileButtonsLocked=mobileButtonsLocked==true,
            mobileButtonsSize=mobileButtonsSize, circleButtonsEnabled=circleButtonsEnabled==true,
            antiKick=antiKickEnabled==true, fovValue=fovValue, perButtonDrag=true,
            skyTheme=currentSkyTheme, guiTheme=currentGuiTheme,
            autoMoveSwing=autoMoveSwingEnabled==true, autoMoveSwingInterval=autoMoveSwingInterval,
            ragdollGui=ragdollGuiEnabled==true, introEnabled=introEnabled~=false,
            introMusicEnabled=introMusicEnabled~=false,
            espBox=espBoxEnabled==true, espHighlight=espHighlightEnabled==true,
            espTracer=espTracerEnabled==true, espSpeed=espSpeedEnabled==true,
            espRagdollCD=espRagdollCDEnabled==true,
            selectedIntroMusic=selectedIntroMusic, btnPositions=btnPos,
        }
        local encoded = HS:JSONEncode(cfg)
        local wrote = false
        pcall(function()
            writefile("S2.json", encoded)
            wrote = true
        end)
        pcall(function() writefile("S2HubConfig.json", encoded) end)
        pcall(function()
            if getgenv then
                getgenv()._S2HubCfg = cfg
                getgenv()._S2IntroEnabled = cfg.introEnabled
            end
        end)
        if not wrote then
            warn("[S2Hub] writefile did not succeed — using getgenv session backup")
        end
    end)
    if not ok then
        warn("[S2Hub] saveConfig failed: ", err)
    end
end
task.spawn(function() while task.wait(5) do saveConfig() end end)
local function resetAllSettings()
    NS=60;CS=30;LAGGER_SPEED=15;LAGGER_CARRY_SPEED=24.5;carrySpeedActive=false;laggerModeEnabled=false;laggerCarryActive=false
    antiRagdollEnabled=false;infJumpEnabled=false;infJumpMode="manual"
    medusaCounterEnabled=false;batCounterEnabled=false;unwalkEnabled=false
    autoLeftEnabled=false;autoRightEnabled=false;autoBatEnabled=false;autoSwingEnabled=true;autoMoveSwingEnabled=false
    autoTPEnabled=false;autoTPHeight=20;antiLagEnabled=false
    Steal.AutoStealEnabled=false;Steal.StealRadius=8;Steal.PrimeRange=8;Steal.StealDuration=1.4
    guiTransparencyEnabled=false;mobileButtonsEnabled=true;mobileButtonsSize=90
    circleButtonsEnabled=false;antiKickEnabled=false;uiLocked=false;fovValue=80;fovIndex=1
    KB.DropBrainrot={kb=nil,gp=nil};KB.AutoLeft={kb=nil,gp=nil};KB.AutoRight={kb=nil,gp=nil}
    KB.AutoBat={kb=nil,gp=nil};KB.TPFloor={kb=nil,gp=nil};KB.InstaReset={kb=nil,gp=nil}
    KB.GuiHide={kb=nil,gp=nil};KB.SpeedToggle={kb=nil,gp=nil};KB.LaggerToggle={kb=nil,gp=nil}
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerCarryActive) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
    stopBatAimbot();stopAutoSteal();stopAutoLeft();stopAutoRight();stopAntiRagdoll();stopAutoTP();stopHoldInfJump()
    if antiLagEnabled then disableAntiLag() end;saveConfig()
end
setInstaGrab,setInfJumpVisual,setAntiRagVisual,setMedusaVisual,setUnwalkVisual,setAntiLagVisual,setAutoSwingVisual=nil,nil,nil,nil,nil,nil,nil
setTranspVisual,setLockVisual,setMobVisual,setCircleBtnsVisual,setMedusaResetVisual=nil,nil,nil,nil,nil
normalBox,carryBox,laggerBox,laggerCarryBox,radInput,autoTPHeightBox,durationBox,primeRangeBox=nil,nil,nil,nil,nil,nil,nil,nil
mainFrame=nil
mainGuiRef=nil
_persistentConns={}
local function trackConn(conn) table.insert(_persistentConns,conn);return conn end
local function clearPersistentConns() for _,c in ipairs(_persistentConns) do pcall(function() c:Disconnect() end) end;_persistentConns={} end

refreshSpeedModeLabel=function()
    if modeValLbl then
        if laggerCarryActive then modeValLbl.Text="Lagger Carry"
        elseif laggerModeEnabled then modeValLbl.Text="Lagger"
        elseif carrySpeedActive then modeValLbl.Text="Carry"
        else modeValLbl.Text="Normal" end
    end
    if laggerModePillRef and laggerModePillRef.pill and laggerModePillRef.dot then
        local pill=laggerModePillRef.pill;local dot=laggerModePillRef.dot;local on=laggerModeEnabled
        local PINK2=Color3.fromRGB(130,60,220);local OFF=Color3.fromRGB(20,14,38);local WHITE=Color3.fromRGB(255,255,255);local GRAY=Color3.fromRGB(180,150,165)
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and PINK2 or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5),BackgroundColor3=on and WHITE or GRAY}):Play()
    end
    if carryModePillRef and carryModePillRef.pill and carryModePillRef.dot then
        local pill=carryModePillRef.pill;local dot=carryModePillRef.dot;local on=carrySpeedActive
        local PINK2=Color3.fromRGB(130,60,220);local OFF=Color3.fromRGB(20,14,38);local WHITE=Color3.fromRGB(255,255,255);local GRAY=Color3.fromRGB(180,150,165)
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and PINK2 or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5),BackgroundColor3=on and WHITE or GRAY}):Play()
    end
end
toggleCarryMode=function()
    if laggerModeEnabled or laggerCarryActive then
        laggerCarryActive = not laggerCarryActive
        laggerModeEnabled = not laggerCarryActive
        carrySpeedActive = false
    else
        carrySpeedActive = not carrySpeedActive
    end
    refreshSpeedModeLabel()
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive or laggerCarryActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled or laggerCarryActive) end
end
toggleLaggerMode=function()
    if laggerModeEnabled or laggerCarryActive then
        local wasCarry = laggerCarryActive
        laggerModeEnabled = false
        laggerCarryActive = false
        carrySpeedActive = wasCarry
    else
        local wasCarry = carrySpeedActive
        carrySpeedActive = false
        laggerModeEnabled = not wasCarry
        laggerCarryActive = wasCarry
    end
    refreshSpeedModeLabel()
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive or laggerCarryActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled or laggerCarryActive) end
end
toggleLaggerCarryMode=function()
    toggleCarryMode()
end
antiRagdollCached = {}

local function cacheCharacterAntiRag()
    local char = LP.Character
    if not char then return false end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    if not hum or not root then return false end

    antiRagdollCached = {
        character = char,
        humanoid = hum,
        root = root
    }

    local camera = workspace.CurrentCamera
    if camera then
        camera.CameraSubject = hum
    end

    return true
end

local function isRagdolledAntiRag()
    local hum = antiRagdollCached.humanoid
    if not hum then return false end

    local state = hum:GetState()

    if state == Enum.HumanoidStateType.Physics
    or state == Enum.HumanoidStateType.Ragdoll
    or state == Enum.HumanoidStateType.FallingDown then
        return true
    end

    local endTime = LP:GetAttribute("RagdollEndTime")
    if endTime then
        local now = workspace:GetServerTimeNow()
        if (endTime - now) > 0 then
            return true
        end
    end

    return false
end

local function removeRagdollConstraints()
    for _, v in ipairs(antiRagdollCached.character:GetDescendants()) do
        if v:IsA("BallSocketConstraint") or 
           (v:IsA("Attachment") and v.Name:find("RagdollAttachment")) then
            pcall(function()
                v:Destroy()
            end)
        end
    end
end

local function forceExitRagdoll()
    local hum = antiRagdollCached.humanoid
    local root = antiRagdollCached.root

    if not hum or not root then return end
    if hum.Health <= 0 then return end

    pcall(function()
        LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
    end)

    hum:ChangeState(Enum.HumanoidStateType.Running)

    root.Anchored = false
    applyVel(root, Vector3.zero)
    applyAngVel(root, Vector3.zero)

    root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(root.Orientation.Y), 0)

    local camera = workspace.CurrentCamera
    if camera and hum.Health > 0 and camera.CameraSubject ~= hum then
        camera.CameraSubject = hum
    end
end

startAntiRagdoll = function()
    if Conns.antiRag then return end
    local _arLastReset = 0
    Conns.antiRag = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
            or state == Enum.HumanoidStateType.Dead
            or hum.PlatformStand == true
            or hum.Sit == true then
            local now = tick()
            if now - _arLastReset >= 0.03 then
                _arLastReset = now
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root or hum.Health <= 0 then return end
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                    applyVel(root, Vector3.zero)
                    root.AssemblyAngularVelocity = Vector3.zero
                    hum.PlatformStand = false
                    hum.Sit = false
                    hum.AutoRotate = true
                    if hum.JumpPower and hum.JumpPower <= 0 then hum.JumpPower = 50 end
                    if hum.WalkSpeed and hum.WalkSpeed <= 0 then hum.WalkSpeed = 16 end
                    for _, obj in ipairs(char:GetDescendants()) do
                        if obj:IsA("Motor6D") then
                            obj.Enabled = true
                        elseif obj:IsA("Constraint") or obj:IsA("BallSocketConstraint") or obj:IsA("HingeConstraint") then
                            obj.Enabled = true
                        elseif obj:IsA("BasePart") then
                            obj.CanCollide = true
                            pcall(function() applyVel(obj, Vector3.zero) end)
                            pcall(function() obj.AssemblyAngularVelocity = Vector3.zero end)
                        end
                    end
                    local cam = workspace.CurrentCamera
                    if cam then cam.CameraSubject = hum end
                    local PM = LP:FindFirstChild("PlayerScripts") and LP.PlayerScripts:FindFirstChild("PlayerModule")
                    if PM then
                        local CM = PM:FindFirstChild("ControlModule")
                        if CM then
                            local okm, module = pcall(require, CM)
                            if okm and module and module.Enable then pcall(function() module:Enable() end) end
                        end
                    end
                end)
            else
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    hum.PlatformStand = false
                    hum.Sit = false
                end)
            end
        end
    end)
end

stopAntiRagdoll = function()
    if Conns.antiRag then
        Conns.antiRag:Disconnect()
        Conns.antiRag = nil
    end
end

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and workspace.CurrentCamera then
        workspace.CurrentCamera.CameraSubject = hum
    end
    if antiRagdollEnabled then
        stopAntiRagdoll()
        startAntiRagdoll()
    end
end)

startUnwalk=function()
    local c=LP.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate");if anim then unwalkSavedAnimate=anim:Clone();anim:Destroy() end
end
stopUnwalk=function() local c=LP.Character;if c and unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent=c;unwalkSavedAnimate=nil end end

local function createStealBar()
    pcall(function()
        if destroyOldGui then destroyOldGui("S2InfoBar") end
        if destroyOldGui then destroyOldGui("MoveeStealBar") end
        local cg=game:GetService("CoreGui")
        for _,n in ipairs({"S2InfoBar","MoveeStealBar"}) do
            local o=cg:FindFirstChild(n); if o then o:Destroy() end
        end
        local pg=LP:FindFirstChild("PlayerGui")
        if pg then
            for _,n in ipairs({"S2InfoBar","MoveeStealBar"}) do
                local o=pg:FindFirstChild(n); if o then o:Destroy() end
            end
        end
    end)

    local th = (type(getTheme)=="function" and getTheme()) or {}
    C = C or {}
    C.infoBg = th.STEAL_BG or th.BG or Color3.fromRGB(12,16,28)
    C.infoBrd = th.STEAL_ACCENT or th.ACCENT or Color3.fromRGB(110,175,255)
    C.infoVal = th.WHITE or Color3.fromRGB(110,175,255)
    C.infoTxt = th.GRAY or Color3.fromRGB(0,130,50)
    C.accent = th.STEAL_FILL or th.ACCENT or Color3.fromRGB(110,175,255)
    C.pillOff = th.BG2 or Color3.fromRGB(16,22,38)
    C.winBg = th.BG or C.infoBg
    C.winBorder = C.infoBrd
    C.topTitle = C.infoVal

    local function mkCorner(p,r) local c=Instance.new("UICorner",p); c.CornerRadius=UDim.new(0,r or 6); return c end
    local function mkStroke(p,col,thk)
        local s=Instance.new("UIStroke",p); s.Color=col; s.Thickness=thk or 1
        s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; return s
    end
    local function makeDraggable(frame,handle)
        local src=handle or frame
        local dragging,dragStart,startPos=false,nil,nil
        src.InputBegan:Connect(function(inp)
            if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
                dragging=true; dragStart=inp.Position; startPos=frame.Position
                inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then dragging=false end end)
            end
        end)
        UIS.InputChanged:Connect(function(inp)
            if dragging and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
                local dx=inp.Position.X-dragStart.X; local dy=inp.Position.Y-dragStart.Y
                frame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+dx,startPos.Y.Scale,startPos.Y.Offset+dy)
            end
        end)
    end

local infoBarGui = Instance.new("ScreenGui")
infoBarGui.Name = "S2InfoBar"
infoBarGui.ResetOnSpawn = false
infoBarGui.IgnoreGuiInset = true
infoBarGui.DisplayOrder = 12
if parentGui then parentGui(infoBarGui) else infoBarGui.Parent = LP:FindFirstChild("PlayerGui") or game:GetService("CoreGui") end
local infoBar = Instance.new("Frame", infoBarGui)
infoBar.Size = UDim2.new(0, 300, 0, 72)
infoBar.Position = UDim2.new(0.5, -150, 1, -90)
infoBar.BackgroundColor3 = Color3.fromRGB(12, 16, 28)
infoBar.BackgroundTransparency = 0.15
infoBar.BorderSizePixel = 0
infoBar.Active = true
infoBar.ClipsDescendants = true
mkCorner(infoBar, 16)
local ibStroke = Instance.new("UIStroke", infoBar)
ibStroke.Color = Color3.fromRGB(130, 190, 255)
ibStroke.Thickness = 1.2
ibStroke.Transparency = 0.35
makeDraggable(infoBar)
local ibGrad = Instance.new("UIGradient", infoBar)
ibGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18,24,40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10,14,24)),
})

local stealLbl = Instance.new("TextLabel", infoBar)
stealLbl.Size = UDim2.new(1, -28, 0, 18); stealLbl.Position = UDim2.new(0, 14, 0, 3)
stealLbl.BackgroundTransparency = 1; stealLbl.Text = "S2'JR HUB"; stealLbl.TextColor3 = Color3.fromRGB(200,220,255)
stealLbl.Font = Enum.Font.GothamBold; stealLbl.TextSize = 12
stealLbl.TextXAlignment = Enum.TextXAlignment.Center; stealLbl.ZIndex = 5

local stealPctLbl = Instance.new("TextLabel", infoBar)
stealPctLbl.Size = UDim2.new(0, 82, 0, 16); stealPctLbl.Position = UDim2.new(1, -96, 0, 51)
stealPctLbl.BackgroundTransparency = 1; stealPctLbl.Text = "0%"; stealPctLbl.TextColor3 = Color3.fromRGB(130,190,255)
stealPctLbl.Font = Enum.Font.GothamBlack; stealPctLbl.TextSize = 12
stealPctLbl.TextXAlignment = Enum.TextXAlignment.Right; stealPctLbl.ZIndex = 5

local barFpsLbl = Instance.new("TextLabel", infoBar)
barFpsLbl.Size = UDim2.new(0, 82, 0, 16); barFpsLbl.Position = UDim2.new(0, 14, 0, 51)
barFpsLbl.BackgroundTransparency = 1; barFpsLbl.Text = "FPS: --"
barFpsLbl.TextColor3 = Color3.fromRGB(160,190,230)
barFpsLbl.Font = Enum.Font.GothamBold; barFpsLbl.TextSize = 10
barFpsLbl.TextXAlignment = Enum.TextXAlignment.Left; barFpsLbl.ZIndex = 5

local barPingLbl = Instance.new("TextLabel", infoBar)
barPingLbl.Size = UDim2.new(0, 82, 0, 16); barPingLbl.Position = UDim2.new(0.5, -41, 0, 51)
barPingLbl.BackgroundTransparency = 1; barPingLbl.Text = "MS: --"
barPingLbl.TextColor3 = Color3.fromRGB(160,190,230)
barPingLbl.Font = Enum.Font.GothamBold; barPingLbl.TextSize = 10
barPingLbl.TextXAlignment = Enum.TextXAlignment.Center; barPingLbl.ZIndex = 5
task.spawn(function()
    local frames = 0
    local t0 = tick()
    while barPingLbl and barPingLbl.Parent do
        frames = frames + 1
        local ms = 0
        pcall(function()
            local ok,v = pcall(function() return math.floor(LP:GetNetworkPing()*1000+0.5) end)
            if ok and type(v)=="number" then ms = v end
        end)
        local now = tick()
        if now - t0 >= 0.5 then
            barFpsLbl.Text = "FPS: " .. tostring(math.floor(frames / (now - t0) + 0.5))
            barPingLbl.Text = "MS: " .. tostring(ms)
            frames = 0
            t0 = now
        end
        task.wait()
    end
end)

function getPingMs()
    local ms = 0
    pcall(function()
        local Stats = game:GetService("Stats")
        local item = Stats.Network.ServerStatsItem:FindFirstChild("Data Ping")
            or Stats.Network.ServerStatsItem["Data Ping"]
        if item then
            local v = item:GetValue()
            if type(v) == "number" then
                ms = math.floor(v + 0.5)
            elseif type(v) == "string" then
                ms = math.floor(tonumber((v:match("[%d%.]+")) or 0) + 0.5)
            end
        end
    end)
    if ms <= 0 then
        pcall(function()
            ms = math.floor(((LP:GetNetworkPing() or 0) * 1000) + 0.5)
        end)
    end
    return math.max(0, ms)
end

function formatStealPct(prog)
    local pct = math.floor((prog or 0) * 100)
    return pct .. "%"
end

function formatRadDurPing()
    return "S2'JR HUB"
end

function setStealStatusText(status, extra)
    if status == "SEARCHING" then
        stealPctLbl.Text = "SEARCHING"
    elseif status == "STEALING" then
        stealPctLbl.Text = formatStealPct(extra or 0)
    elseif status == "STOLE" then
        stealPctLbl.Text = "STOLE!"
    else
        stealPctLbl.Text = tostring(status)
    end
end

progressFill = progressFill
do
    local pTrack = Instance.new("Frame", infoBar)
    pTrack.Size = UDim2.new(1, -24, 0, 14); pTrack.Position = UDim2.new(0, 12, 0, 27)
    pTrack.BackgroundColor3 = Color3.fromRGB(28, 36, 55)
    pTrack.BorderSizePixel = 0
    pTrack.ClipsDescendants = true
    mkCorner(pTrack, 20)
    local trSt = Instance.new("UIStroke", pTrack)
    trSt.Color = Color3.fromRGB(80, 130, 200)
    trSt.Thickness = 1
    trSt.Transparency = 0.6
    progressFill = Instance.new("Frame", pTrack)
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(110, 175, 255)
    progressFill.BorderSizePixel = 0
    mkCorner(progressFill, 20)
    local fillG = Instance.new("UIGradient", progressFill)
    fillG.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 160, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(160, 210, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 160, 255)),
    })
end

local _lastProgressPct=0
RunService.RenderStepped:Connect(function()
	if not progressFill or not stealPctLbl then return end
	local pct=0
	if isStealing and stealStartTime then
		pct=math.clamp((tick()-stealStartTime)/math.max(Steal.HalfHoldMin,0.01),0,1)
	elseif Steal.AutoStealEnabled then
		pct=(findNearestPrompt() and 1 or 0)
	end
	_lastProgressPct=_lastProgressPct+(pct-_lastProgressPct)*0.2
	local f=math.clamp(_lastProgressPct,0,1)
	progressFill.Size=UDim2.new(f,0,1,0)
	if _lastProgressPct>=0.87 then stealPctLbl.Text="READY";stealPctLbl.TextColor3=Color3.fromRGB(200,150,255)
	else stealPctLbl.Text="UNREADY";stealPctLbl.TextColor3=Color3.fromRGB(230,210,255) end
end)

radTB = Instance.new("TextBox", infoBar)
radTB.Size = UDim2.new(0, 0, 0, 0); radTB.Position = UDim2.new(0, 0, 0, 0)
radTB.BackgroundTransparency = 1; radTB.TextTransparency = 1; radTB.Text = tostring(Steal.StealRadius)
radTB.ClearTextOnFocus = false; radTB.ZIndex = -1; radTB.Active = false
radTB.FocusLost:Connect(function()
    local n = tonumber(radTB.Text)
    if n and n >= 5 and n <= 300 then Steal.StealRadius = math.floor(n); Steal.cachedPrompts = {}; Steal.promptCacheTime = 0 end
    radTB.Text = tostring(Steal.StealRadius)
    if stealRadBox and not stealRadBox:IsFocused() then stealRadBox.Text = tostring(Steal.HalfFireRange) end
    stealLbl.Text = formatRadDurPing()
end)

do
    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                if stealRadBox and not stealRadBox:IsFocused() then stealRadBox.Text = tostring(Steal.HalfFireRange) end
                stealLbl.Text = formatRadDurPing()
                if not isStealing then
                    if Steal.AutoStealEnabled then
                        -- Display is handled by RenderStepped progress update
                    else
                        stealPctLbl.Text = "UNREADY"
                    end
                end
            end)
        end
    end)
end

function resetProgressBar()
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    if Steal.AutoStealEnabled then
        stealPctLbl.Text = "UNREADY"
    else
        stealPctLbl.Text = "UNREADY"
    end
end

    stealBarFrame = infoBar
end

local function destroyMobileButtons()
    pcall(saveBtnPositions)
    if mobGuiRef then pcall(function() mobGuiRef:Destroy() end);mobGuiRef=nil end
    for _,n in ipairs({"MoveeMobileButtons"}) do
        local old=game:GetService("CoreGui"):FindFirstChild(n);if old then old:Destroy() end
        local pgui=LP:FindFirstChild("PlayerGui");if pgui then local o=pgui:FindFirstChild(n);if o then o:Destroy() end end
    end
    mobBtnRefs={}
end
local function buildMobileButtons()
    destroyMobileButtons();if not mobileButtonsEnabled then return end
    perButtonDragEnabled=true
    local savedPositions=loadBtnPositions()

    local BTN_SIZE=math.floor(mobileButtonsSize*0.55)
    local BTN_GAP=12
    local CORNER_R=circleButtonsEnabled and BTN_SIZE or math.max(8,math.floor(BTN_SIZE*0.22))
    local fontSize=math.max(7,math.floor(mobileButtonsSize*0.10))

    local buttons={
        {key="drop",        label="DROP\nBR",       toggle=false, exclusive=false},
        {key="autoPlay",    label="AUTO\nPLAY",     toggle=true,  exclusive=true},
        {key="autoBat",     label="AIMBOT",        toggle=true,  exclusive=true},
        {key="tpBat",       label="TP\nBAT",        toggle=true,  exclusive=true},
        {key="tpDown",      label="TP\nDOWN",       toggle=false, exclusive=false},
        {key="carrySpeed",  label="CARRY",          toggle=true,  exclusive=false},
        {key="lagger",      label="NORMAL\nLAGGER", toggle=true,  exclusive=false},
        {key="instaReset",  label="INSTA\nRESET",   toggle=false, exclusive=false},
    }

    local COLS=2
    local totalW=(COLS*(BTN_SIZE+BTN_GAP))-BTN_GAP
    local totalH=(math.ceil(#buttons/COLS)*(BTN_SIZE+BTN_GAP))-BTN_GAP

    local PAD=10

    local vp=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
    local savedPanel=savedPositions["_panel"]
    local defPanelX=vp.X-totalW-PAD*2-18
    local defPanelY=math.max(10,vp.Y/2-(totalH+PAD*2)/2)
    local panelXO=savedPanel and savedPanel.xo or defPanelX
    local panelYO=savedPanel and savedPanel.yo or defPanelY

    local mobGui=Instance.new("ScreenGui")
    mobGui.Name="S2MobileButtons";mobGui.ResetOnSpawn=false;mobGui.DisplayOrder=15;mobGui.IgnoreGuiInset=true
    parentGui(mobGui)
    mobGuiRef=mobGui

    local th = getTheme()
    local PINK_ON      = th.MOB_ON
    local BTN_BG_OFF   = th.MOB_OFF
    local PANEL_BG     = th.BG
    local BORDER_OFF   = th.MOB_BORDER_OFF
    local BORDER_ON    = th.MOB_ON
    local TEXT_OFF     = th.MOB_TEXT_OFF
    local TEXT_ON      = th.MOB_TEXT_ON
    local STROKE_W     = 1

    local panel
    if not perButtonDragEnabled then
        panel=Instance.new("Frame",mobGui)
        panel.Name="MobPanel"
        panel.Size=UDim2.new(0,totalW+PAD*2,0,totalH+PAD*2)
        panel.Position=UDim2.new(0,panelXO,0,panelYO)
        panel.BackgroundColor3=PANEL_BG
        panel.BackgroundTransparency=1
        panel.BorderSizePixel=0;panel.Active=true;panel.ZIndex=99
        local panelStroke=Instance.new("UIStroke",panel)
        panelStroke.Color=Color3.fromRGB(80,80,80);panelStroke.Thickness=1;panelStroke.Transparency=0.7

        local gDragStart,gDragStartPos,gDragDown=nil,nil,false
        panel.InputBegan:Connect(function(input)
            if uiLocked then return end
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                gDragDown=true;gDragStart=input.Position;gDragStartPos=panel.Position
                input.Changed:Connect(function()
                    if input.UserInputState==Enum.UserInputState.End then
                        gDragDown=false
                        if writefile then
                            local posData=loadBtnPositions()
                            posData["_panel"]={xo=panel.Position.X.Offset,yo=panel.Position.Y.Offset}
                            pcall(function() writefile(MOB_POS_FILE,HS:JSONEncode(posData)) end)
                        end
                    end
                end)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if gDragDown and not uiLocked and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
                local delta=input.Position-gDragStart
                panel.Position=UDim2.new(0,gDragStartPos.X.Offset+delta.X,0,gDragStartPos.Y.Offset+delta.Y)
            end
        end)
    end

    for i,def in ipairs(buttons) do
        local col=(i-1)%COLS
        local rowN=math.floor((i-1)/COLS)
        local localX=PAD+col*(BTN_SIZE+BTN_GAP)
        local localY=PAD+rowN*(BTN_SIZE+BTN_GAP)

        local frameParent=perButtonDragEnabled and mobGui or panel
        local frame=Instance.new("Frame",frameParent)
        frame.Name="MobBtn_"..def.key
        frame.Size=UDim2.new(0,BTN_SIZE,0,BTN_SIZE)
        local sp = (not forceDefaultBtnPos) and savedPositions[def.key] or nil
        local cam = workspace.CurrentCamera
        local vpX = (cam and cam.ViewportSize.X) or 800
        local vpY = (cam and cam.ViewportSize.Y) or 600
        if sp and tonumber(sp.xo)~=nil and tonumber(sp.yo)~=nil and tonumber(sp.xo) > vpX*0.35 then
            frame.Position = UDim2.new(0,tonumber(sp.xo),0,tonumber(sp.yo))
        else
            local xo = vpX - (totalW + PAD + 18) + localX
            local yo = math.max(10, vpY/2 - (totalH+PAD*2)/2) + localY
            frame.Position = UDim2.new(0,xo,0,yo)
        end
        frame.BackgroundColor3=BTN_BG_OFF
        frame.BackgroundTransparency=0
        frame.BorderSizePixel=0;frame.Active=true;frame.ZIndex=102
        frame:SetAttribute("BtnKey",def.key)

        local uic=Instance.new("UICorner",frame)
        uic.CornerRadius=circleButtonsEnabled and UDim.new(1,0) or UDim.new(0,CORNER_R)

        local fstroke=Instance.new("UIStroke",frame)
        fstroke.Color=BORDER_OFF;fstroke.Thickness=STROKE_W;fstroke.Transparency=0.45

        local btn=Instance.new("TextButton",frame)
        btn.Size=UDim2.new(1,0,1,0);btn.BackgroundTransparency=1
        btn.Text=def.label
        btn.TextColor3=TEXT_OFF
        btn.Font=Enum.Font.GothamBlack
        btn.TextSize=fontSize
        btn.LineHeight=1.1
        btn.TextWrapped=true;btn.AutoButtonColor=false;btn.ZIndex=105
        btn.TextStrokeTransparency=1

        local isOn=false

        local function setOn(v)
            isOn=v
            if v then
                frame:SetAttribute("BtnIsOn",true)
                TweenService:Create(frame,TweenInfo.new(0.12,Enum.EasingStyle.Quad),{BackgroundColor3=PINK_ON}):Play()
                TweenService:Create(fstroke,TweenInfo.new(0.12),{Color=BORDER_ON,Thickness=STROKE_W+1}):Play()
                TweenService:Create(btn,TweenInfo.new(0.12),{TextColor3=TEXT_ON}):Play()
            else
                frame:SetAttribute("BtnIsOn",false)
                TweenService:Create(frame,TweenInfo.new(0.12,Enum.EasingStyle.Quad),{BackgroundColor3=BTN_BG_OFF}):Play()
                TweenService:Create(fstroke,TweenInfo.new(0.12),{Color=BORDER_OFF,Thickness=STROKE_W}):Play()
                TweenService:Create(btn,TweenInfo.new(0.12),{TextColor3=TEXT_OFF}):Play()
            end
        end

        mobBtnRefs[def.key]=setOn

        local function flash()
            TweenService:Create(frame,TweenInfo.new(0.06),{BackgroundColor3=Color3.fromRGB(240,240,240)}):Play()
            task.delay(0.18,function()
                TweenService:Create(frame,TweenInfo.new(0.1),{BackgroundColor3=BTN_BG_OFF}):Play()
            end)
        end

        -- Akai-style per-button drag: axis threshold, viewport clamp, justDragged guard
        local _fdn,_fds,_fsp,_fdDragging,_justDragged=false,nil,nil,false,false
        btn.InputBegan:Connect(function(input)
            if uiLocked then return end
            if activeMobDrag and activeMobDrag~=frame then return end
            if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
            _fdn=true; _fds=input.Position; _fsp=frame.Position; _fdDragging=false; _justDragged=false
            activeMobDrag=frame
        end)
        btn.InputChanged:Connect(function(input)
            if not _fdn or uiLocked then return end
            if input.UserInputType~=Enum.UserInputType.MouseMovement and input.UserInputType~=Enum.UserInputType.Touch then return end
            local d=input.Position-_fds
            if not _fdDragging then
                if math.abs(d.X)>8 or math.abs(d.Y)>8 then _fdDragging=true else return end
            end
            local vp=(workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(800,600)
            local rawX=_fsp.X.Scale*vp.X+_fsp.X.Offset+d.X
            local rawY=_fsp.Y.Scale*vp.Y+_fsp.Y.Offset+d.Y
            frame.Position=UDim2.new(0,math.clamp(rawX,0,vp.X-BTN_SIZE),0,math.clamp(rawY,0,vp.Y-BTN_SIZE))
            _justDragged=true
        end)
        UIS.InputEnded:Connect(function(input)
            if not _fdn or activeMobDrag~=frame then return end
            if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
            _fdn=false; activeMobDrag=nil
            if _fdDragging then pcall(saveBtnPositions) end
            _fdDragging=false
            task.delay(0.08,function() _justDragged=false end)
        end)

        btn.Activated:Connect(function()
            if _justDragged then return end

            if def.key=="tpDown" then runTPFloor();flash();return end
            if def.key=="drop" then runDrop();flash();return end
            if def.key=="instaReset" then cursedInstaReset();flash();return end

            if def.exclusive then
                local alreadyOn=(def.key=="autoPlay" and autoPlayEnabled) or (def.key=="autoBat" and autoBatEnabled) or (def.key=="aimbotV2" and aimbotV2Enabled) or (def.key=="tpBat" and _G.S2AntiDesyncAimbotOn)
                if alreadyOn then
                    if def.key=="autoPlay" then autoPlayEnabled=false;if type(stopAutoPlay)=="function" then stopAutoPlay() end;setOn(false)
                    elseif def.key=="autoBat" then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;setOn(false)
                    elseif def.key=="aimbotV2" then stopAimbotV2();setOn(false)
                    elseif def.key=="tpBat" then _G.S2StopAntiDesyncAimbot();if batTP.setVisual then batTP.setVisual(false) end;setOn(false) end
                    return
                end
                if autoPlayEnabled and def.key~="autoPlay" then autoPlayEnabled=false;if type(stopAutoPlay)=="function" then stopAutoPlay() end;if mobBtnRefs.autoPlay then mobBtnRefs.autoPlay(false) end end
                if autoBatEnabled and def.key~="autoBat" then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                if aimbotV2Enabled and def.key~="aimbotV2" then stopAimbotV2();if mobBtnRefs.aimbotV2 then mobBtnRefs.aimbotV2(false) end end
                if _G.S2AntiDesyncAimbotOn and def.key~="tpBat" then _G.S2StopAntiDesyncAimbot();if batTP.setVisual then batTP.setVisual(false) end;if mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end end
                if def.key=="autoPlay" then autoPlayEnabled=true;if type(startAutoPlay)=="function" then startAutoPlay() end;setOn(true)
                elseif def.key=="autoBat" then
                    if _G._S2_AimMode=="bypass" or antiBatBypassEnabled then startAimbotV2() else queueAutoBatStart() end
                    if autoBatSetVisual then autoBatSetVisual(true) end;setOn(true)
                elseif def.key=="tpBat" then _G.S2StartAntiDesyncAimbot();if batTP.setVisual then batTP.setVisual(true) end;setOn(true) end
                return
            end

            if def.key=="carrySpeed" then toggleCarryMode();setOn(carrySpeedActive or laggerCarryActive);saveConfig();return end
            if def.key=="lagger" then toggleLaggerMode();setOn(laggerModeEnabled or laggerCarryActive);saveConfig();return end
        end)
    end

    if mobBtnRefs.autoPlay then mobBtnRefs.autoPlay(autoPlayEnabled) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(autoBatEnabled) end
    if mobBtnRefs.aimbotV2 then mobBtnRefs.aimbotV2(aimbotV2Enabled) end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive or laggerCarryActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled or laggerCarryActive) end
    if mobBtnRefs.tpBat then mobBtnRefs.tpBat(_G.S2AntiDesyncAimbotOn) end
end

espBoxEnabled=false
espHighlightEnabled=false
espTracerEnabled=false
espSpeedEnabled=false
espRagdollCDEnabled=false
setEspBoxVisual,setEspHighlightVisual,setEspTracerVisual=nil,nil,nil
setEspSpeedVisual,setEspRagdollCDVisual=nil,nil

ESP_ACCENT=Color3.fromRGB(0,140,255)
ESP_RAGDOLL_CD=4.5
PlayerESP=PlayerESP or {enabled=false,playerData={},conns={}}
BoxedESPOptions=BoxedESPOptions or {box=false,tracer=false}
BoxedESPData=BoxedESPData or {}
BoxedESPConn=BoxedESPConn or nil
espRagLast=espRagLast or {}
espRagConns=espRagConns or {}

local function espTrackRagdoll(plr)
    if espRagConns[plr] then return end
    espRagConns[plr]={}
    local function hook(char)
        local hum=char and (char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid",5))
        if not hum then return end
        if espRagConns[plr] and espRagConns[plr].state then pcall(function() espRagConns[plr].state:Disconnect() end) end
        local was=isRagdollState(hum)
        espRagConns[plr].state=hum.StateChanged:Connect(function()
            local now=isRagdollState(hum)
            if was and not now then espRagLast[plr]=tick() end
            was=now
        end)
    end
    espRagConns[plr].added=plr.CharacterAdded:Connect(function(c) task.defer(hook,plr,c) end)
    if plr.Character then task.defer(hook,plr.Character) end
end

local function espUntrackRagdoll(plr)
    local t=espRagConns[plr]
    if t then for _,c in pairs(t) do pcall(function() c:Disconnect() end) end;espRagConns[plr]=nil end
    espRagLast[plr]=nil
end

local function espRagText(plr,hum)
    if not espRagdollCDEnabled then return nil end
    if hum and isRagdollState(hum) then return "ragdoll" end
    local last=espRagLast[plr]
    local left=last and (ESP_RAGDOLL_CD-(tick()-last)) or 0
    if left>0 then return string.format("cd %.1fs",left) end
    return "ready"
end

function startPlayerESP()
    if PlayerESP.enabled then return end
    PlayerESP.enabled=true
    local function cleanup(plr)
        local d=PlayerESP.playerData[plr];if not d then return end
        pcall(function() if d.highlight then d.highlight:Destroy() end end)
        pcall(function() if d.billboard then d.billboard:Destroy() end end)
        if d.conns then for _,c in ipairs(d.conns) do pcall(function() c:Disconnect() end) end end
        PlayerESP.playerData[plr]=nil
    end
    local function setup(plr,char)
        if not PlayerESP.enabled or plr==LP then return end
        cleanup(plr)
        local hrp=char and (char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart",5))
        local head=char and (char:FindFirstChild("Head") or char:WaitForChild("Head",5))
        if not hrp or not head then return end
        local hl=Instance.new("Highlight")
        hl.Name="S2ESP";hl.Adornee=char;hl.FillColor=ESP_ACCENT;hl.FillTransparency=0.6
        hl.OutlineColor=Color3.fromRGB(245,245,245);hl.OutlineTransparency=0
        hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;hl.Enabled=espHighlightEnabled==true;hl.Parent=char
        local bb=Instance.new("BillboardGui")
        bb.Name="S2ESPTag";bb.Adornee=head;bb.Size=UDim2.new(0,130,0,36);bb.StudsOffset=Vector3.new(0,2.7,0)
        bb.AlwaysOnTop=true;bb.LightInfluence=0;bb.Parent=head
        local box=Instance.new("Frame",bb);box.Size=UDim2.new(1,0,1,0);box.BackgroundTransparency=1;box.BorderSizePixel=0
        local n=Instance.new("TextLabel",box);n.Size=UDim2.new(1,-10,0,17);n.Position=UDim2.new(0,5,0,2)
        n.BackgroundTransparency=1;n.TextColor3=Color3.fromRGB(255,255,255);n.Font=Enum.Font.GothamBlack;n.TextSize=15;n.TextStrokeTransparency=0.38;n.Text=plr.Name
        local sub=Instance.new("TextLabel",box);sub.Size=UDim2.new(1,-10,0,12);sub.Position=UDim2.new(0,5,0,19)
        sub.BackgroundTransparency=1;sub.TextColor3=ESP_ACCENT;sub.Font=Enum.Font.GothamBold;sub.TextSize=10;sub.TextStrokeTransparency=0.58;sub.Text=""
        local conn=RunService.Heartbeat:Connect(function()
            if not PlayerESP.enabled or not hrp.Parent then return end
            local d=PlayerESP.playerData[plr]
            if d and d.highlight then d.highlight.Enabled=espHighlightEnabled==true end
            local parts={}
            if espSpeedEnabled then
                local v=hrp.AssemblyLinearVelocity or hrp.Velocity
                table.insert(parts,string.format("%d speed",math.floor(Vector3.new(v.X,0,v.Z).Magnitude+0.5)))
            end
            local rt=espRagText(plr,char:FindFirstChildOfClass("Humanoid"))
            if rt then table.insert(parts,rt) end
            sub.Text=table.concat(parts," | ")
            local show=(#parts>0) or espHighlightEnabled
            n.Visible=show;sub.Visible=#parts>0
        end)
        PlayerESP.playerData[plr]={highlight=hl,billboard=bb,conns={conn}}
    end
    PlayerESP.cleanup=cleanup
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP then
            if plr.Character then setup(plr,plr.Character) end
            table.insert(PlayerESP.conns, plr.CharacterAdded:Connect(function(c) task.defer(setup,plr,c) end))
        end
    end
    table.insert(PlayerESP.conns, Players.PlayerAdded:Connect(function(plr)
        if plr~=LP then table.insert(PlayerESP.conns, plr.CharacterAdded:Connect(function(c) task.defer(setup,plr,c) end)) end
    end))
    table.insert(PlayerESP.conns, Players.PlayerRemoving:Connect(function(plr) if PlayerESP.cleanup then PlayerESP.cleanup(plr) end end))
end

function stopPlayerESP()
    PlayerESP.enabled=false
    for _,c in ipairs(PlayerESP.conns or {}) do pcall(function() c:Disconnect() end) end
    PlayerESP.conns={}
    for _,d in pairs(PlayerESP.playerData or {}) do
        pcall(function() if d.highlight then d.highlight:Destroy() end end)
        pcall(function() if d.billboard then d.billboard:Destroy() end end)
        if d.conns then for _,c in ipairs(d.conns) do pcall(function() c:Disconnect() end) end end
    end
    PlayerESP.playerData={}
end

local function _safeDrawing(kind,props)
    if not Drawing or not Drawing.new then return nil end
    local ok,obj=pcall(function() return Drawing.new(kind) end)
    if not ok or not obj then return nil end
    for k,v in pairs(props or {}) do pcall(function() obj[k]=v end) end
    return obj
end

function _cleanupBoxedESPPlayer(player)
    local data=BoxedESPData[player]
    if not data then return end
    for _,obj in pairs(data) do
        pcall(function()
            obj.Visible=false
            if obj.Remove then obj:Remove() end
        end)
    end
    BoxedESPData[player]=nil
end

function _cleanupBoxedESP()
    for player,_ in pairs(BoxedESPData) do _cleanupBoxedESPPlayer(player) end
end

function _updateBoxedESP()
    local cam=workspace.CurrentCamera
    if not cam then return end
    local anyOn=BoxedESPOptions.box or BoxedESPOptions.tracer
    if not anyOn then _cleanupBoxedESP();return end
    for _,player in ipairs(Players:GetPlayers()) do
        if player~=LP then
            local char=player.Character
            local root=char and char:FindFirstChild("HumanoidRootPart")
            local head=char and char:FindFirstChild("Head")
            if not root or not head then
                _cleanupBoxedESPPlayer(player)
            else
                local rootPos,onScreen=cam:WorldToViewportPoint(root.Position)
                local headPos=cam:WorldToViewportPoint(head.Position+Vector3.new(0,0.55,0))
                local data=BoxedESPData[player]
                if not data then
                    data={
                        box=_safeDrawing("Square",{Thickness=2,Filled=false,Transparency=1,Color=ESP_ACCENT}),
                        tracer=_safeDrawing("Line",{Thickness=2,Transparency=1,Color=ESP_ACCENT}),
                    }
                    BoxedESPData[player]=data
                end
                local height=math.abs(headPos.Y-rootPos.Y)*2.15
                if height<20 or height~=height then height=65 end
                local width=height/2.15
                local view=cam.ViewportSize
                local centerX,centerY=view.X/2,view.Y/2
                local targetX,targetY=rootPos.X,rootPos.Y+height/2
                local targetVisible=onScreen and rootPos.Z>0
                if not targetVisible then
                    local dx=rootPos.X-centerX
                    local dy=rootPos.Y-centerY
                    if rootPos.Z<=0 then dx=-dx;dy=-dy end
                    if math.abs(dx)<1 and math.abs(dy)<1 then
                        local rel=cam.CFrame:PointToObjectSpace(root.Position)
                        dx=rel.X;dy=-rel.Y
                        if rootPos.Z<=0 then dx=-dx;dy=-dy end
                    end
                    local edgePad=10
                    local scaleX=(dx~=0) and ((view.X/2-edgePad)/math.abs(dx)) or math.huge
                    local scaleY=(dy~=0) and ((view.Y/2-edgePad)/math.abs(dy)) or math.huge
                    local scale=math.min(scaleX,scaleY)
                    if scale==math.huge or scale~=scale then scale=1 end
                    targetX=math.clamp(centerX+dx*scale,edgePad,view.X-edgePad)
                    targetY=math.clamp(centerY+dy*scale,edgePad,view.Y-edgePad)
                end
                if data.box then
                    data.box.Color=ESP_ACCENT
                    data.box.Size=Vector2.new(width,height)
                    data.box.Position=Vector2.new(rootPos.X-width/2,rootPos.Y-height/2)
                    data.box.Visible=BoxedESPOptions.box==true and targetVisible
                end
                if data.tracer then
                    data.tracer.Color=ESP_ACCENT
                    local localChar=LP.Character
                    local localRoot=localChar and localChar:FindFirstChild("HumanoidRootPart")
                    local fromX,fromY
                    if localRoot then
                        local localScreen=cam:WorldToViewportPoint(localRoot.Position)
                        fromX=localScreen.X;fromY=localScreen.Y+15
                    end
                    if not fromX or not fromY then
                        fromX=view.X/2;fromY=view.Y-88
                    end
                    data.tracer.From=Vector2.new(fromX,fromY)
                    data.tracer.To=Vector2.new(targetX,targetY)
                    data.tracer.Visible=BoxedESPOptions.tracer==true
                end
            end
        end
    end
end

function refreshBoxedESP()
    local anyOn=BoxedESPOptions.box or BoxedESPOptions.tracer
    if anyOn and not BoxedESPConn then
        BoxedESPConn=RunService.RenderStepped:Connect(_updateBoxedESP)
    elseif (not anyOn) and BoxedESPConn then
        BoxedESPConn:Disconnect()
        BoxedESPConn=nil
        _cleanupBoxedESP()
    end
end

Players.PlayerRemoving:Connect(function(plr) _cleanupBoxedESPPlayer(plr);espUntrackRagdoll(plr) end)
Players.PlayerAdded:Connect(function(plr) if espRagdollCDEnabled then espTrackRagdoll(plr) end end)

function espApply()
    BoxedESPOptions.box=espBoxEnabled==true
    BoxedESPOptions.tracer=espTracerEnabled==true
    refreshBoxedESP()
    if espRagdollCDEnabled then
        for _,plr in ipairs(Players:GetPlayers()) do if plr~=LP then espTrackRagdoll(plr) end end
    else
        for plr,_ in pairs(espRagConns) do espUntrackRagdoll(plr) end
    end
    if espHighlightEnabled or espSpeedEnabled or espRagdollCDEnabled then
        startPlayerESP()
    else
        stopPlayerESP()
    end
end


local function buildGui()
    currentGuiTheme="Cyber"
    clearPersistentConns()
    pcall(createStealBar)

    local th = getTheme() or GUI_THEMES["Midnight"]
    local BG, BG2, ROW_BG, ROW_BORDER = th.BG, th.BG2, th.ROW_BG, th.ROW_BORDER
    local WHITE, GRAY, INP = th.WHITE, th.GRAY, th.INP
    local PINK, PINK2, PINK3 = th.ACCENT, th.ACCENT2, th.ACCENT3
    local OFF, TAB_ACTIVE, TAB_INACT, SECT_LBL = th.OFF, th.ACCENT, th.GRAY, th.SECT

    pcall(function()
        if mainGuiRef then mainGuiRef:Destroy() end
    end)
    mainGuiRef = nil
    pcall(function() destroyOldGui("S2Hub") end)
    pcall(function()
        local cg=game:GetService("CoreGui")
        local o=cg:FindFirstChild("S2Hub"); if o then o:Destroy() end
        local pg=LP:FindFirstChild("PlayerGui")
        if pg then local o2=pg:FindFirstChild("S2Hub"); if o2 then o2:Destroy() end end
    end)

    local gui=Instance.new("ScreenGui");gui.Name="S2Hub";gui.ResetOnSpawn=false;gui.DisplayOrder=10;gui.IgnoreGuiInset=true
    parentGui(gui)
    mainGuiRef = gui

    local W, H = 300, 340
    local outer=Instance.new("Frame",gui)
    outer.Name="OuterBorder"
    outer.Size=UDim2.new(0,W,0,H)
    outer.Position=UDim2.new(0.5,-W/2,0.5,-H/2)
    outer.BackgroundColor3=Color3.fromRGB(10,14,24)
    outer.BackgroundTransparency=0
    outer.BorderSizePixel=0
    outer.ZIndex=4
    outer.ClipsDescendants=true
    Instance.new("UICorner",outer).CornerRadius=UDim.new(0,18)

    local bgImage=Instance.new("ImageLabel",outer)
    bgImage.Name="HubBG"
    bgImage.Size=UDim2.new(1,0,1,0)
    bgImage.BackgroundTransparency=1
    bgImage.BorderSizePixel=0
    bgImage.Image="rbxassetid://118131424737973"
    bgImage.ScaleType=Enum.ScaleType.Crop
    bgImage.ImageTransparency=1
    bgImage.ZIndex=4
    bgImage.ImageColor3=Color3.fromRGB(255,255,255)
    bgImage.Visible=false
    Instance.new("UICorner",bgImage).CornerRadius=UDim.new(0,18)
    _G._MoveeDuels_bgImage=bgImage

    mainFrame=Instance.new("Frame",outer)
    mainFrame.Name="Main"
    mainFrame.Size=UDim2.new(1,0,1,0)
    mainFrame.Position=UDim2.new(0,0,0,0)
    mainFrame.BackgroundColor3=Color3.fromRGB(10,14,24)
    mainFrame.BackgroundTransparency=0
    mainFrame.BorderSizePixel=0
    mainFrame.ClipsDescendants=true
    mainFrame.ZIndex=5
    Instance.new("UICorner",mainFrame).CornerRadius=UDim.new(0,18)

    local mfStroke=Instance.new("UIStroke",mainFrame)
    mfStroke.Color=Color3.fromRGB(110,175,255)
    mfStroke.Thickness=1
    mfStroke.Transparency=0.5

    local function applyTransparencyToGui(transparent)
        if transparent then
            mainFrame.BackgroundTransparency=0
            if bgImage then bgImage.ImageTransparency=1;bgImage.Visible=false end
        else
            mainFrame.BackgroundTransparency=0
            if bgImage then bgImage.ImageTransparency=1;bgImage.Visible=false end
        end
    end

local function dragHandle(handle)
        local dn,ds,sp,di=false
        handle.InputBegan:Connect(function(i)
            if uiLocked then return end
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                dn=true;ds=i.Position;sp=(mainFrame.Parent and mainFrame.Parent.Name=="OuterBorder" and mainFrame.Parent or mainFrame).Position
                i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dn=false end end)
            end
        end)
        handle.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end end)
        trackConn(UIS.InputChanged:Connect(function(i)
            if i==di and dn and not uiLocked then
                local target=(mainFrame.Parent and mainFrame.Parent.Name=="OuterBorder" and mainFrame.Parent) or mainFrame
                target.Position=UDim2.new(sp.X.Scale,sp.X.Offset+(i.Position.X-ds.X),sp.Y.Scale,sp.Y.Offset+(i.Position.Y-ds.Y))
            end
        end))
    end

    local headerH = 36
    local header=Instance.new("Frame",mainFrame)
    header.Size=UDim2.new(1,0,0,headerH)
    header.BackgroundColor3=BG2;header.BackgroundTransparency=0.75;header.BorderSizePixel=0;header.ZIndex=6
    Instance.new("UICorner",header).CornerRadius=UDim.new(0,18)
    local headerFix=Instance.new("Frame",mainFrame)
    headerFix.Size=UDim2.new(1,0,0,12);headerFix.Position=UDim2.new(0,0,0,headerH-10)
    headerFix.BackgroundColor3=BG2;headerFix.BackgroundTransparency=0.7;headerFix.BorderSizePixel=0;headerFix.ZIndex=5
    local hDivider=Instance.new("Frame",mainFrame)
    hDivider.Size=UDim2.new(1,0,0,1);hDivider.Position=UDim2.new(0,0,0,headerH)
    hDivider.BackgroundColor3=PINK;hDivider.BackgroundTransparency=0.85;hDivider.BorderSizePixel=0;hDivider.ZIndex=7

    dragHandle(header)

    local titleLbl=Instance.new("TextLabel",header)
    titleLbl.Size=UDim2.new(1,-80,1,0);titleLbl.Position=UDim2.new(0,12,0,0)
    titleLbl.BackgroundTransparency=1;titleLbl.Text="S2 HUB"
    titleLbl.TextColor3=PINK;titleLbl.Font=Enum.Font.GothamBlack
    titleLbl.TextSize=16;titleLbl.TextXAlignment=Enum.TextXAlignment.Left;titleLbl.ZIndex=8

    local discSmall=Instance.new("TextLabel",header)
    discSmall.Size=UDim2.new(0,120,0,12);discSmall.Position=UDim2.new(0,12,1,-14)
    discSmall.BackgroundTransparency=1;discSmall.Text="discord.gg/S2HUB"
    discSmall.TextColor3=PINK;discSmall.Font=Enum.Font.GothamBold
    discSmall.TextSize=8;discSmall.TextXAlignment=Enum.TextXAlignment.Left;discSmall.ZIndex=8

    local pingFpsLbl=Instance.new("TextLabel",header)
    pingFpsLbl.Size=UDim2.new(0,100,0,14);pingFpsLbl.Position=UDim2.new(1,-136,0,6)
    pingFpsLbl.BackgroundTransparency=1;pingFpsLbl.Text="-- ms - -- fps"
    pingFpsLbl.TextColor3=GRAY;pingFpsLbl.Font=Enum.Font.GothamBold
    pingFpsLbl.TextSize=8;pingFpsLbl.TextXAlignment=Enum.TextXAlignment.Right;pingFpsLbl.ZIndex=8
    task.spawn(function()
        local frames=0;local t0=tick()
        while pingFpsLbl and pingFpsLbl.Parent do
            frames=frames+1;local now=tick()
            if now-t0>=0.5 then
                local fps=math.floor(frames/(now-t0)+0.5)
                local ok,ms=pcall(function() return LP:GetNetworkPing()*1000 end)
                pingFpsLbl.Text=(ok and math.floor(ms+0.5) or "--").."ms - "..fps.."fps"
                frames=0;t0=now
            end
            task.wait()
        end
    end)

    local closeBtn=Instance.new("TextButton",header)
    closeBtn.Size=UDim2.new(0,26,0,26);closeBtn.Position=UDim2.new(1,-34,0.5,-13)
    closeBtn.BackgroundColor3=PINK3;closeBtn.BorderSizePixel=0
    closeBtn.Text="−";closeBtn.TextColor3=WHITE
    closeBtn.Font=Enum.Font.GothamBlack;closeBtn.TextSize=16;closeBtn.ZIndex=10
    Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,10)

    local miniBtn=Instance.new("TextButton",gui)
    local miniBtnSize=math.floor(mobileButtonsSize*0.55)
    miniBtn.Size=UDim2.new(0,miniBtnSize,0,miniBtnSize)
    miniBtn.Position=UDim2.new(0,20,0.5,-miniBtnSize/2)
    miniBtn.BackgroundColor3=Color3.fromRGB(0,0,0);miniBtn.BorderSizePixel=0
    miniBtn.Text="MENU";miniBtn.TextColor3=PINK
    miniBtn.Font=Enum.Font.GothamBlack;miniBtn.TextSize=math.max(7,math.floor(mobileButtonsSize*0.10));miniBtn.ZIndex=20;miniBtn.Visible=false
    Instance.new("UICorner",miniBtn).CornerRadius=UDim.new(0,math.max(8,math.floor(miniBtnSize*0.22)))
    local miniStroke=Instance.new("UIStroke",miniBtn)
    miniStroke.Color=PINK;miniStroke.Thickness=1;miniStroke.Transparency=0.7
    do
        local mdn,mds,msp=false,nil,nil
        miniBtn.InputBegan:Connect(function(i)
            if uiLocked then return end
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                mdn=true;mds=i.Position;msp=miniBtn.Position
                i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then mdn=false end end)
            end
        end)
        trackConn(UIS.InputChanged:Connect(function(i)
            if mdn and not uiLocked and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                miniBtn.Position=UDim2.new(msp.X.Scale,msp.X.Offset+(i.Position.X-mds.X),msp.Y.Scale,msp.Y.Offset+(i.Position.Y-mds.Y))
            end
        end))
    end
    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible=false
        if outer then outer.Visible=false end
        miniBtn.Visible=true
    end)
    miniBtn.MouseButton1Click:Connect(function()
        if outer then outer.Visible=true end
        mainFrame.Visible=true
        miniBtn.Visible=false
    end)

    local tabBarH = 30
    local contentFrameY = headerH + tabBarH + 2
    local contentH = H - contentFrameY

    local tabBar = Instance.new("Frame", mainFrame)
    tabBar.Size = UDim2.new(1, -12, 0, tabBarH)
    tabBar.Position = UDim2.new(0, 6, 0, headerH + 2)
    tabBar.BackgroundTransparency = 1
    tabBar.ZIndex = 12

    local tabLay = Instance.new("UIListLayout", tabBar)
    tabLay.FillDirection = Enum.FillDirection.Horizontal
    tabLay.Padding = UDim.new(0, 4)
    tabLay.HorizontalAlignment = Enum.HorizontalAlignment.Left
    tabLay.VerticalAlignment = Enum.VerticalAlignment.Center

    local tabNames = {"Movement", "Combat", "Auto", "Visual", "Settings"}
    local tabPages = {}
    local tabButtons = {}
    local activeTabName = "Movement"

    local function makePage(name)
        local sf = Instance.new("ScrollingFrame", mainFrame)
        sf.Name = name .. "Page"
        sf.Size = UDim2.new(1, 0, 0, contentH)
        sf.Position = UDim2.new(0, 0, 0, contentFrameY)
        sf.BackgroundTransparency = 1
        sf.BorderSizePixel = 0
        sf.ScrollBarThickness = 2
        sf.ScrollBarImageColor3 = PINK
        sf.CanvasSize = UDim2.new(0, 0, 0, 0)
        sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
        sf.ScrollingDirection = Enum.ScrollingDirection.Y
        sf.Visible = (name == "Movement")
        sf.ZIndex = 10
        sf.Active = true
        local ll = Instance.new("UIListLayout", sf)
        ll.SortOrder = Enum.SortOrder.LayoutOrder
        ll.Padding = UDim.new(0, 2)
        local pd = Instance.new("UIPadding", sf)
        pd.PaddingLeft = UDim.new(0, 10)
        pd.PaddingRight = UDim.new(0, 10)
        pd.PaddingTop = UDim.new(0, 6)
        pd.PaddingBottom = UDim.new(0, 8)
        return sf
    end

    for _, name in ipairs(tabNames) do
        tabPages[name] = makePage(name)
    end
    tabPages["Speed"] = tabPages["Movement"]
    tabPages["Steal"] = tabPages["Auto"]
    tabPages["Visuals"] = tabPages["Visual"]

    local function switchTab(name)
        activeTabName = name
        _G._S2_ActiveTab = name
        local showPage = tabPages[name]
        local unique = {}
        for _, tn in ipairs(tabNames) do
            local pg = tabPages[tn]
            if pg then unique[pg] = (pg == showPage)
            end
        end
        for pg, show in pairs(unique) do
            pg.Visible = show
        end
        for n, btn in pairs(tabButtons) do
            local on = (n == name)
            btn.BackgroundColor3 = on and PINK or Color3.fromRGB(20,26,40)
            btn.BackgroundTransparency = on and 0.05 or 0.25
            btn.TextColor3 = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(160,190,230)
            local st = btn:FindFirstChildOfClass("UIStroke")
            if st then st.Transparency = on and 0.3 or 0.7 end
        end
    end

    for i, name in ipairs(tabNames) do
        local b = Instance.new("TextButton", tabBar)
        b.Size = UDim2.new(0, 54, 0, 26)
        b.BackgroundColor3 = (name == "Movement") and PINK or Color3.fromRGB(20,26,40)
        b.BackgroundTransparency = (name == "Movement") and 0.05 or 0.25
        b.BorderSizePixel = 0
        b.Text = name:upper()
        b.TextColor3 = (name == "Movement") and Color3.fromRGB(255,255,255) or Color3.fromRGB(160,190,230)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 10
        b.AutoButtonColor = false
        b.ZIndex = 13
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
        local bst = Instance.new("UIStroke", b)
        bst.Color = PINK
        bst.Thickness = 1
        bst.Transparency = (name == "Movement") and 0.3 or 0.7
        b.MouseButton1Click:Connect(function() switchTab(name) end)
        tabButtons[name] = b
    end
    _G._S2_SwitchTab = switchTab
    if _G._S2_ActiveTab and tabPages[_G._S2_ActiveTab] then
        switchTab(_G._S2_ActiveTab)
    end

    local contentFrame = tabPages["Movement"]
    

    do
        local thank = Instance.new("Frame", contentFrame)
        thank.Name = "ThankCard"
        thank.Size = UDim2.new(1, 0, 0, 36)
        thank.BackgroundColor3 = ROW_BG
        thank.BackgroundTransparency = 0.2
        thank.BorderSizePixel = 0
        thank.LayoutOrder = 0
        thank.ZIndex = 8
        Instance.new("UICorner", thank).CornerRadius = UDim.new(0, 8)
        local ts = Instance.new("UIStroke", thank)
        ts.Color = PINK
        ts.Thickness = 1
        ts.Transparency = 0.65

        local av = Instance.new("ImageLabel", thank)
        av.Size = UDim2.new(0, 26, 0, 26)
        av.Position = UDim2.new(1, -32, 0.5, -13)
        av.BackgroundColor3 = BG2
        av.BorderSizePixel = 0
        av.ScaleType = Enum.ScaleType.Crop
        av.ZIndex = 9
        Instance.new("UICorner", av).CornerRadius = UDim.new(1, 0)
        pcall(function()
            av.Image = Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        end)

        local lbl = Instance.new("TextLabel", thank)
        lbl.Size = UDim2.new(1, -44, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Thank you for using S2"
        lbl.TextColor3 = PINK
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 9
    end

    local function mkSectionLbl(parent, txt)
        local spacer=Instance.new("Frame",parent)
        spacer.Size=UDim2.new(1,0,0,3);spacer.BackgroundTransparency=1;spacer.LayoutOrder=#parent:GetChildren()

        local row=Instance.new("Frame",parent)
        row.Size=UDim2.new(1,0,0,14);row.BackgroundTransparency=1;row.LayoutOrder=#parent:GetChildren()
        local l=Instance.new("TextLabel",row)
        l.Size=UDim2.new(1,0,1,0);l.BackgroundTransparency=1
        l.Text=txt:upper();l.TextColor3=SECT_LBL
        l.Font=Enum.Font.GothamBold;l.TextSize=9
        l.TextXAlignment=Enum.TextXAlignment.Left;l.ZIndex=9

        local div=Instance.new("Frame",parent)
        div.Size=UDim2.new(1,0,0,1);div.BackgroundColor3=ROW_BORDER
        div.BackgroundTransparency=0.4;div.BorderSizePixel=0;div.LayoutOrder=#parent:GetChildren()
        local sp2=Instance.new("Frame",parent)
        sp2.Size=UDim2.new(1,0,0,2);sp2.BackgroundTransparency=1;sp2.LayoutOrder=#parent:GetChildren()
    end

    -- PC only: hover animations (souris presente et pas tactile)
    local IS_PC = (UIS.MouseEnabled and not UIS.TouchEnabled)

    local function addHoverFX(frame, stroke)
        if not IS_PC or not frame then return end
        local scale=frame:FindFirstChildOfClass("UIScale") or Instance.new("UIScale",frame)
        scale.Scale=1
        local baseStrokeT = stroke and stroke.Transparency or 0.6
        local baseStrokeC = stroke and stroke.Color or ROW_BORDER
        local ti=TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
        frame.MouseEnter:Connect(function()
            TweenService:Create(scale,TweenInfo.new(0.18,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1.03}):Play()
            if stroke then
                TweenService:Create(stroke,ti,{Transparency=0.05,Color=PINK,Thickness=1.5}):Play()
            end
        end)
        frame.MouseLeave:Connect(function()
            TweenService:Create(scale,ti,{Scale=1}):Play()
            if stroke then
                TweenService:Create(stroke,ti,{Transparency=baseStrokeT,Color=baseStrokeC,Thickness=1}):Play()
            end
        end)
    end

    local function addHoverPop(guiObj, pop)
        if not IS_PC or not guiObj then return end
        local scale=guiObj:FindFirstChildOfClass("UIScale") or Instance.new("UIScale",guiObj)
        scale.Scale=1
        guiObj.MouseEnter:Connect(function()
            TweenService:Create(scale,TweenInfo.new(0.16,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=pop or 1.12}):Play()
        end)
        guiObj.MouseLeave:Connect(function()
            TweenService:Create(scale,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{Scale=1}):Play()
        end)
    end

    -- Effet de clic: enfoncement + onde
    local function addClickFX(button, visual)
        if not button then return end
        local target = visual or button
        local scale = target:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", target)
        local base = scale.Scale
        local function down()
            TweenService:Create(scale, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {Scale = base * 0.88}):Play()
        end
        local function up()
            TweenService:Create(scale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = base}):Play()
        end
        button.MouseButton1Down:Connect(down)
        button.MouseButton1Up:Connect(up)
        button.MouseLeave:Connect(up)
        button.Activated:Connect(function()
            local ring = Instance.new("Frame", target)
            ring.AnchorPoint = Vector2.new(0.5, 0.5)
            ring.Position = UDim2.new(0.5, 0, 0.5, 0)
            ring.Size = UDim2.new(1, 0, 1, 0)
            ring.BackgroundTransparency = 1
            ring.ZIndex = 20
            Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)
            local st = Instance.new("UIStroke", ring)
            st.Color = PINK
            st.Thickness = 2
            st.Transparency = 0.15
            TweenService:Create(ring, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1.9, 0, 1.9, 0)}):Play()
            TweenService:Create(st, TweenInfo.new(0.35), {Transparency = 1, Thickness = 0.5}):Play()
            task.delay(0.4, function() pcall(function() ring:Destroy() end) end)
        end)
    end

    local function mkRow(parent, h)
        local f=Instance.new("Frame",parent)
        f.Size=UDim2.new(1,0,0,h or 30)
        f.BackgroundColor3=ROW_BG;f.BorderSizePixel=0;f.ZIndex=8
        f.LayoutOrder=#parent:GetChildren()
        local stroke=Instance.new("UIStroke",f)
        stroke.Color=ROW_BORDER;stroke.Thickness=1;stroke.Transparency=0.6
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,10)
        addHoverFX(f,stroke)
        local spacer=Instance.new("Frame",parent)
        spacer.Size=UDim2.new(1,0,0,1);spacer.BackgroundTransparency=1
        spacer.LayoutOrder=#parent:GetChildren()+1
        return f
    end

    local function mkLabel(row, txt)
        local l=Instance.new("TextLabel",row)
        l.Size=UDim2.new(0.6,0,1,0);l.Position=UDim2.new(0,10,0,0)
        l.BackgroundTransparency=1;l.Text=txt
        l.TextColor3=WHITE;l.Font=Enum.Font.GothamBold
        l.TextSize=10;l.TextXAlignment=Enum.TextXAlignment.Left;l.ZIndex=9
        return l
    end

    local function mkPill(row)
        local pill=Instance.new("Frame",row)
        pill.Size=UDim2.new(0,30,0,16);pill.Position=UDim2.new(1,-40,0.5,-8)
        pill.BackgroundColor3=OFF;pill.BorderSizePixel=0;pill.ZIndex=9
        Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
        local dot=Instance.new("Frame",pill)
        dot.Size=UDim2.new(0,10,0,10);dot.Position=UDim2.new(0,3,0.5,-5)
        dot.BackgroundColor3=GRAY;dot.BorderSizePixel=0;dot.ZIndex=10
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
        addHoverPop(pill,1.15)
        return pill,dot
    end

    local function animPill(pill, dot, on)
        TweenService:Create(pill,TweenInfo.new(0.15,Enum.EasingStyle.Quad),{BackgroundColor3=on and PINK2 or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.15,Enum.EasingStyle.Back),{
            Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5),
            BackgroundColor3=on and WHITE or GRAY
        }):Play()
    end

    local function mkToggle(parent, txt, cb)
        local row=mkRow(parent,30);mkLabel(row,txt)
        local pill,dot=mkPill(row)
        local on=false
        local function sv(state) on=state; animPill(pill,dot,state) end
        local clk=Instance.new("TextButton",pill)
        clk.Size=UDim2.new(1,0,1,0)
        clk.BackgroundTransparency=1
        clk.Text=""
        clk.ZIndex=11
        addClickFX(clk, pill)
        clk.Activated:Connect(function()
            on = not on
            sv(on)
            if cb then
                local ok, err = pcall(cb, on)
                if not ok then warn("[S2Hub] toggle error ("..tostring(txt).."): ", err) end
            end
        end)
        return sv
    end

    local function mkBoxRow(parent, txt, default, cb)
        local row=mkRow(parent,30);mkLabel(row,txt)
        local tb=Instance.new("TextBox",row)
        tb.Size=UDim2.new(0,54,0,18);tb.Position=UDim2.new(1,-62,0.5,-9)
        tb.BackgroundColor3=INP;tb.BorderSizePixel=0
        tb.Text=tostring(default);tb.TextColor3=PINK
        tb.Font=Enum.Font.GothamBold;tb.TextSize=11
        tb.ClearTextOnFocus=false;tb.ZIndex=9
        Instance.new("UICorner",tb).CornerRadius=UDim.new(0,5)
        addHoverPop(tb,1.08)
        tb.FocusLost:Connect(function()
            if cb then local n=tonumber(tb.Text);if n then cb(n) else tb.Text=tostring(default) end end
        end)
        return tb
    end

    local GAMEPAD_KEYS={[Enum.KeyCode.ButtonA]=true,[Enum.KeyCode.ButtonB]=true,[Enum.KeyCode.ButtonX]=true,[Enum.KeyCode.ButtonY]=true,[Enum.KeyCode.ButtonL1]=true,[Enum.KeyCode.ButtonR1]=true,[Enum.KeyCode.ButtonL2]=true,[Enum.KeyCode.ButtonR2]=true,[Enum.KeyCode.ButtonL3]=true,[Enum.KeyCode.ButtonR3]=true,[Enum.KeyCode.ButtonStart]=true,[Enum.KeyCode.ButtonSelect]=true,[Enum.KeyCode.DPadUp]=true,[Enum.KeyCode.DPadDown]=true,[Enum.KeyCode.DPadLeft]=true,[Enum.KeyCode.DPadRight]=true}
    local function isGamepadInput(inp) return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad")~=nil end
    local function isBindableInput(inp)
        if not inp or inp.KeyCode==Enum.KeyCode.Unknown then return false end
        if inp.UserInputType==Enum.UserInputType.Keyboard then return true end
        return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode]==true
    end
    local function kbMatch(entry,kc) return kc and (kc==entry.kb or (entry.gp and kc==entry.gp)) end

    local function mkKBButton(row, kbEntry, cb)
        local function getLabel()
            if kbEntry.kb then return kbEntry.kb.Name
            elseif kbEntry.gp then return kbEntry.gp.Name
            else return "..." end
        end
        local btn=Instance.new("TextButton",row)
        btn.Size=UDim2.new(0,66,0,18);btn.Position=UDim2.new(1,-74,0.5,-9)
        btn.BackgroundColor3=INP;btn.BorderSizePixel=0
        btn.Text=getLabel();btn.TextColor3=PINK
        btn.Font=Enum.Font.GothamBold;btn.TextSize=10
        btn.AutoButtonColor=false;btn.ZIndex=9
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,5)
        addHoverPop(btn,1.08)
        addClickFX(btn)
        local li=false;local lc;local pv=btn.Text;local ls=0
        btn.Activated:Connect(function()
            if li then li=false;_anyKeyListening=false;if lc then lc:Disconnect();lc=nil end;btn.Text=pv;btn.TextColor3=PINK;return end
            pv=btn.Text;li=true;_anyKeyListening=true;ls=tick();btn.Text="...";btn.TextColor3=WHITE
            lc=UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode==Enum.KeyCode.Escape then li=false;_anyKeyListening=false;if lc then lc:Disconnect();lc=nil end;btn.Text=pv;btn.TextColor3=PINK;return end
                local isGp=isGamepadInput(inp);if isGp and not(tick()-ls>=0.15) then return end
                if not isBindableInput(inp) then return end
                btn.Text=inp.KeyCode.Name;pv=inp.KeyCode.Name;li=false;_anyKeyListening=false;if lc then lc:Disconnect();lc=nil end
                btn.TextColor3=PINK
                if isGp then kbEntry.gp=inp.KeyCode;kbEntry.kb=nil else kbEntry.kb=inp.KeyCode;kbEntry.gp=nil end
                if cb then cb(inp.KeyCode,isGp) end
            end)
        end)
        return btn
    end

    local function mkToggleKB(parent, txt, kbEntry, onToggle, onKB)
        local row=mkRow(parent,30);mkLabel(row,txt)
        mkKBButton(row,kbEntry,function(k,isGp) if onKB then onKB(k,isGp) end end)
        local pill=Instance.new("Frame",row);pill.Size=UDim2.new(0,30,0,16);pill.Position=UDim2.new(1,-40,0.5,-8)
        pill:Destroy()
        local pill2=Instance.new("Frame",row);pill2.Size=UDim2.new(0,34,0,18);pill2.Position=UDim2.new(1,-44,0.5,-9)
        pill2.BackgroundColor3=OFF;pill2.BorderSizePixel=0;pill2.ZIndex=9
        Instance.new("UICorner",pill2).CornerRadius=UDim.new(1,0)
        local dot2=Instance.new("Frame",pill2);dot2.Size=UDim2.new(0,12,0,12);dot2.Position=UDim2.new(0,3,0.5,-6)
        dot2.BackgroundColor3=GRAY;dot2.BorderSizePixel=0;dot2.ZIndex=10
        Instance.new("UICorner",dot2).CornerRadius=UDim.new(1,0)
        addHoverPop(pill2,1.15)
        local kbb=row:FindFirstChildOfClass("TextButton")
        if kbb then kbb.Position=UDim2.new(1,-122,0.5,-11);kbb.Size=UDim2.new(0,70,0,22) end
        local on=false
        local function sv(s) on=s;animPill(pill2,dot2,s) end
        local clk=Instance.new("TextButton",pill2);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=11
        addClickFX(clk, pill2)
        clk.Activated:Connect(function() if _anyKeyListening then return end;on=not on;sv(on);if onToggle then onToggle(on) end end)
        return sv
    end

    local function mkKBRow(parent, txt, kbEntry, onKB)
        local row=mkRow(parent,30);mkLabel(row,txt)
        mkKBButton(row,kbEntry,function(k,isGp) if onKB then onKB(k,isGp) end end)
        return row
    end

    local function mkActionRow(parent, txt, onActivate)
        local row=mkRow(parent,30);mkLabel(row,txt)
        local btn=Instance.new("TextButton",row)
        btn.Size=UDim2.new(0,50,0,18);btn.Position=UDim2.new(1,-58,0.5,-9)
        btn.BackgroundColor3=PINK3;btn.BorderSizePixel=0
        btn.Text="▶";btn.TextColor3=WHITE;btn.Font=Enum.Font.GothamBlack;btn.TextSize=11
        btn.AutoButtonColor=false;btn.ZIndex=9
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,5)
        addHoverPop(btn,1.1)
        addClickFX(btn)
        btn.Activated:Connect(function()
            TweenService:Create(btn,TweenInfo.new(0.06),{BackgroundColor3=Color3.fromRGB(90,160,255)}):Play()
            task.delay(0.12,function() TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=PINK3}):Play() end)
            if onActivate then onActivate() end
        end)
        return row,btn
    end

    local pg=tabPages["Speed"]
    mkSectionLbl(pg,"Speed Configuration")
    mkSectionLbl(pg,"Normal Mode")
    normalBox=mkBoxRow(pg,"Normal Speed",NS,function(v) if v>0 and v<=500 then NS=v end;saveConfig() end)
    carryBox=mkBoxRow(pg,"Carry Speed",CS,function(v) if v>0 and v<=500 then CS=v end;saveConfig() end)
    mkSectionLbl(pg,"Lagger Mode")
    laggerBox=mkBoxRow(pg,"Lagger Speed",LAGGER_SPEED,function(v) if v>0 and v<=500 then LAGGER_SPEED=v end;saveConfig() end)
    laggerCarryBox=mkBoxRow(pg,"Lagger Carry Speed",LAGGER_CARRY_SPEED,function(v) if v>0 and v<=500 then LAGGER_CARRY_SPEED=v end;saveConfig() end)

    pg=tabPages["Combat"]
    mkSectionLbl(pg,"Combat")
    setAntiRagVisual=mkToggle(pg,"Anti Ragdoll",function(on) antiRagdollEnabled=on;if on then startAntiRagdoll() else stopAntiRagdoll() end;saveConfig() end)
    setMedusaVisual=mkToggle(pg,"Medusa Counter",function(on) medusaCounterEnabled=on;if on then setupMedusa(LP.Character) else stopMedusaCounter() end;saveConfig() end)
    setUnwalkVisual=mkToggle(pg,"Unwalk",function(on) unwalkEnabled=on;if on then startUnwalk() else stopUnwalk() end;saveConfig() end)

    mkSectionLbl(pg,"Bat System")
    do
        if _G._S2_AimMode==nil then _G._S2_AimMode="normal" end
        if _G._S2_AimDist==nil then _G._S2_AimDist=12 end
        if _G._S2_AimSpeed==nil then _G._S2_AimSpeed=aimbotSpeedValue or 50 end
        local modeRow=mkRow(pg,30);mkLabel(modeRow,"Aim Mode")
        local nBtn=Instance.new("TextButton",modeRow)
        nBtn.Size=UDim2.new(0,52,0,22);nBtn.Position=UDim2.new(1,-110,0.5,-11)
        nBtn.BackgroundColor3=(_G._S2_AimMode=="normal") and PINK or OFF
        nBtn.BorderSizePixel=0;nBtn.Text="Normal";nBtn.TextColor3=WHITE
        nBtn.Font=Enum.Font.GothamBold;nBtn.TextSize=9;nBtn.AutoButtonColor=false;nBtn.ZIndex=12
        Instance.new("UICorner",nBtn).CornerRadius=UDim.new(0,6)
        local bBtn=Instance.new("TextButton",modeRow)
        bBtn.Size=UDim2.new(0,52,0,22);bBtn.Position=UDim2.new(1,-54,0.5,-11)
        bBtn.BackgroundColor3=(_G._S2_AimMode=="bypass") and PINK or OFF
        bBtn.BorderSizePixel=0;bBtn.Text="Bypass";bBtn.TextColor3=WHITE
        bBtn.Font=Enum.Font.GothamBold;bBtn.TextSize=9;bBtn.AutoButtonColor=false;bBtn.ZIndex=12
        Instance.new("UICorner",bBtn).CornerRadius=UDim.new(0,6)
        nBtn.Activated:Connect(function()
            _G._S2_AimMode="normal";nBtn.BackgroundColor3=PINK;bBtn.BackgroundColor3=OFF;antiBatBypassEnabled=false;saveConfig()
        end)
        bBtn.Activated:Connect(function()
            _G._S2_AimMode="bypass";bBtn.BackgroundColor3=PINK;nBtn.BackgroundColor3=OFF;antiBatBypassEnabled=true;saveConfig()
        end)
    end
    do
        local row=mkRow(pg,30);mkLabel(row,"Aimbot Speed")
        local box=Instance.new("TextBox",row)
        box.Size=UDim2.new(0,58,0,22);box.Position=UDim2.new(1,-66,0.5,-11)
        box.BackgroundColor3=INP;box.BorderSizePixel=0
        box.Text=tostring(_G._S2_AimSpeed or aimbotSpeedValue or 50);box.TextColor3=PINK
        box.Font=Enum.Font.GothamBold;box.TextSize=11;box.ClearTextOnFocus=false;box.ZIndex=11
        Instance.new("UICorner",box).CornerRadius=UDim.new(0,5)
        box.FocusLost:Connect(function()
            local n=tonumber(box.Text)
            if n and n>0 and n<=500 then _G._S2_AimSpeed=n;aimbotSpeedValue=n;saveConfig()
            else box.Text=tostring(_G._S2_AimSpeed or 50) end
        end)
    end
    do
        local row=mkRow(pg,30);mkLabel(row,"Hit Distance")
        local box=Instance.new("TextBox",row)
        box.Size=UDim2.new(0,58,0,22);box.Position=UDim2.new(1,-66,0.5,-11)
        box.BackgroundColor3=INP;box.BorderSizePixel=0
        box.Text=tostring(_G._S2_AimDist or 12);box.TextColor3=PINK
        box.Font=Enum.Font.GothamBold;box.TextSize=11;box.ClearTextOnFocus=false;box.ZIndex=11
        Instance.new("UICorner",box).CornerRadius=UDim.new(0,5)
        box.FocusLost:Connect(function()
            local n=tonumber(box.Text)
            if n and n>=1 and n<=50 then _G._S2_AimDist=n;saveConfig()
            else box.Text=tostring(_G._S2_AimDist or 12) end
        end)
    end
    autoBatSetVisual=mkToggle(pg,"Aimbot",function(on)
        if on then
            if _G.S2AntiDesyncAimbotOn then _G.S2StopAntiDesyncAimbot();if batTP.setVisual then batTP.setVisual(false) end;if mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end end
            if aimbotV2Enabled then stopAimbotV2() end
            if _G._S2_AimMode=="bypass" or antiBatBypassEnabled then
                antiBatBypassEnabled=true
                startAimbotV2()
            else
                antiBatBypassEnabled=false
                queueAutoBatStart()
            end
        else
            stopBatAimbot()
            stopAimbotV2()
        end
        saveConfig()
    end)
    tpBatSetVisual = mkToggle(pg, "TP Bat", function(on)
        if on then
            if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            if aimbotV2Enabled then stopAimbotV2();if mobBtnRefs.aimbotV2 then mobBtnRefs.aimbotV2(false) end end
            if autoPlayEnabled then stopAutoPlay();if autoPlaySetVisual then autoPlaySetVisual(false) end;if mobBtnRefs.autoPlay then mobBtnRefs.autoPlay(false) end end
            _G.S2StartAntiDesyncAimbot()
        else
            _G.S2StopAntiDesyncAimbot()
        end
        saveConfig()
    end)
    batTP.setVisual = tpBatSetVisual
    setBatCounterVisual=mkToggle(pg,"Bat Counter",function(on) batCounterEnabled=on;if on then startBatCounter() else stopBatCounter() end;saveConfig() end)

    do
        local row=mkRow(pg,30);mkLabel(row,"Anti Kick")
        local pill=Instance.new("Frame",row);pill.Size=UDim2.new(0,30,0,16);pill.Position=UDim2.new(1,-40,0.5,-8)
        pill.BackgroundColor3=OFF;pill.BorderSizePixel=0;pill.ZIndex=9
        Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
        local dot=Instance.new("Frame",pill);dot.Size=UDim2.new(0,10,0,10);dot.Position=UDim2.new(0,3,0.5,-5)
        dot.BackgroundColor3=GRAY;dot.BorderSizePixel=0;dot.ZIndex=10
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
        local on=false
        local function sv(s) on=s;animPill(pill,dot,s) end;antiKickSetVisual=sv
        local clk=Instance.new("TextButton",pill);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=11
        clk.Activated:Connect(function() on=not on;sv(on);antiKickEnabled=on;if on then enableAntiKick() else disableAntiKick() end;saveConfig() end)
    end
    setInfJumpVisual=mkToggle(pg,"Infinite Jump",function(on) infJumpEnabled=on;if infJumpEnabled then if infJumpMode=="hold" then startHoldInfJump() end else stopHoldInfJump() end;saveConfig() end)
    do
        local row=mkRow(pg,30);mkLabel(row,"Jump Mode")
        local manualBtn=Instance.new("TextButton",row)
        manualBtn.Size=UDim2.new(0,50,0,22);manualBtn.Position=UDim2.new(1,-110,0.5,-11)
        manualBtn.BackgroundColor3=(infJumpMode=="manual") and PINK2 or Color3.fromRGB(50,30,40)
        manualBtn.BorderSizePixel=0;manualBtn.Text="Manual"
        manualBtn.TextColor3=WHITE;manualBtn.Font=Enum.Font.GothamBold;manualBtn.TextSize=9
        manualBtn.AutoButtonColor=false;manualBtn.ZIndex=12
        Instance.new("UICorner",manualBtn).CornerRadius=UDim.new(0,5)
        local holdBtn=Instance.new("TextButton",row)
        holdBtn.Size=UDim2.new(0,46,0,22);holdBtn.Position=UDim2.new(1,-57,0.5,-11)
        holdBtn.BackgroundColor3=(infJumpMode=="hold") and PINK2 or Color3.fromRGB(50,30,40)
        holdBtn.BorderSizePixel=0;holdBtn.Text="Hold"
        holdBtn.TextColor3=WHITE;holdBtn.Font=Enum.Font.GothamBold;holdBtn.TextSize=9
        holdBtn.AutoButtonColor=false;holdBtn.ZIndex=12
        Instance.new("UICorner",holdBtn).CornerRadius=UDim.new(0,5)
        manualBtn.Activated:Connect(function() infJumpMode="manual";manualBtn.BackgroundColor3=PINK2;holdBtn.BackgroundColor3=Color3.fromRGB(50,30,40);stopHoldInfJump();saveConfig() end)
        holdBtn.Activated:Connect(function() infJumpMode="hold";holdBtn.BackgroundColor3=PINK2;manualBtn.BackgroundColor3=Color3.fromRGB(50,30,40);if infJumpEnabled then startHoldInfJump() end;saveConfig() end)
    end

    pg=tabPages["Auto"]
    mkSectionLbl(pg,"Auto")
    autoPlaySetVisual=mkToggle(pg,"Auto Play",function(on)
        autoPlayEnabled=on
        if on then
            if _G.S2AntiDesyncAimbotOn then _G.S2StopAntiDesyncAimbot();if batTP.setVisual then batTP.setVisual(false) end;if mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end end
            if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end end
            if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end end
            if type(startAutoPlay)=="function" then startAutoPlay() end
        else
            if type(stopAutoPlay)=="function" then stopAutoPlay() end
            stopAutoLeft();stopAutoRight()
            autoLeftEnabled=false;autoRightEnabled=false
        end
        saveConfig()
    end)
    setAutoCarryVisual=mkToggle(pg,"Auto Carry Speed",function(on) autoCarryEnabled=on;saveConfig() end)
    if setAutoCarryVisual then setAutoCarryVisual(autoCarryEnabled) end
    setAutoSwingVisual=mkToggle(pg,"Auto Swing",function(on) autoSwingEnabled=on;saveConfig() end)
    if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled) end
    setAutoTPVisual=mkToggle(pg,"Auto TP",function(on) autoTPEnabled=on;if on then startAutoTP() else stopAutoTP() end;saveConfig() end)
    autoTPHeightBox=mkBoxRow(pg,"TP Height",autoTPHeight,function(v) if v>=0 and v<=500 then autoTPHeight=v end;saveConfig() end)
    --radInput=mkBoxRow(pg,"Steal Radius",Steal.StealRadius,function(v) if v>=0.5 and v<=300 then Steal.StealRadius=v end;saveConfig() end)
    --durationBox=mkBoxRow(pg,"Steal Duration",Steal.StealDuration,function(v) if v>=0.1 and v<=10 then Steal.StealDuration=v else durationBox.Text=tostring(Steal.StealDuration) end;saveConfig() end)
    do
        local row=mkRow(pg,30);mkLabel(row,"Instant Steal")
        local pill=Instance.new("Frame",row);pill.Size=UDim2.new(0,30,0,16);pill.Position=UDim2.new(1,-40,0.5,-8)
        pill.BackgroundColor3=OFF;pill.BorderSizePixel=0;pill.ZIndex=9
        Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
        local dot=Instance.new("Frame",pill);dot.Size=UDim2.new(0,10,0,10);dot.Position=UDim2.new(0,3,0.5,-5)
        dot.BackgroundColor3=GRAY;dot.BorderSizePixel=0;dot.ZIndex=10
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
        local on=false
        local function sv(s) on=s;animPill(pill,dot,s) end
        setInstaGrab=sv
        local function toggleSteal()
            on = not on
            sv(on)
            Steal.AutoStealEnabled = on
            if on then
                if Conns.autoSteal then pcall(function() Conns.autoSteal:Disconnect() end); Conns.autoSteal=nil end
                startAutoSteal()
            else
                stopAutoSteal()
                Steal.AutoStealEnabled = false
            end
            saveConfig()
        end
        local clk=Instance.new("TextButton",pill)
        clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=11
        clk.Activated:Connect(toggleSteal)
    end
    stealRadBox=mkBoxRow(pg,"Steal Range",Steal.HalfFireRange,function(v)
        if v>=1 and v<=300 then
            Steal.HalfFireRange=math.floor(v)
        end
        if stealRadBox then stealRadBox.Text=tostring(Steal.HalfFireRange) end
        saveConfig()
    end)
    primeRangeBox=mkBoxRow(pg,"Prime Range",Steal.PrimeRange,function(v)
        if v>=1 and v<=300 then
            Steal.PrimeRange=math.floor(v)
            Steal.cachedPrompts={}
            Steal.promptCacheTime=0
        end
        if primeRangeBox then primeRangeBox.Text=tostring(Steal.PrimeRange) end
        saveConfig()
    end)

    pg=tabPages["Visual"]
    mkSectionLbl(pg,"Visual")

    setAntiLagVisual=mkToggle(pg,"Anti Lag",function(on) if on then enableAntiLag() else disableAntiLag() end;saveConfig() end)

    mkSectionLbl(pg,"ESP Players")
    setEspBoxVisual=mkToggle(pg,"Box ESP",function(on) espBoxEnabled=on;espApply();saveConfig() end)
    setEspHighlightVisual=mkToggle(pg,"Highlight Skin",function(on) espHighlightEnabled=on;espApply();saveConfig() end)
    setEspTracerVisual=mkToggle(pg,"Tracers",function(on) espTracerEnabled=on;espApply();saveConfig() end)
    setEspSpeedVisual=mkToggle(pg,"Speed ESP",function(on) espSpeedEnabled=on;espApply();saveConfig() end)
    setEspRagdollCDVisual=mkToggle(pg,"Ragdoll Cooldown",function(on) espRagdollCDEnabled=on;espApply();saveConfig() end)

    mkSectionLbl(pg,"Camera")
    do
        local row=mkRow(pg,30);mkLabel(row,"FOV")
        local fovBtn=Instance.new("TextButton",row)
        fovBtn.Size=UDim2.new(0,58,0,22);fovBtn.Position=UDim2.new(1,-66,0.5,-11)
        fovBtn.BackgroundColor3=INP;fovBtn.BorderSizePixel=0
        fovBtn.Text=tostring(fovValue);fovBtn.TextColor3=PINK
        fovBtn.Font=Enum.Font.GothamBold;fovBtn.TextSize=11;fovBtn.ZIndex=11
        Instance.new("UICorner",fovBtn).CornerRadius=UDim.new(0,5)
        for idx,v in ipairs(fovOptions) do if v==fovValue then fovIndex=idx end end
        fovBtn.Activated:Connect(function()
            fovIndex=fovIndex%#fovOptions+1;fovValue=fovOptions[fovIndex]
            fovBtn.Text=tostring(fovValue);applyFOV();saveConfig()
        end)
    end

    pg=tabPages["Settings"]
    mkSectionLbl(pg,"Settings")
    setLockVisual=mkToggle(pg,"Lock UI",function(on) uiLocked=on;saveConfig() end)
    setIntroVisual=mkToggle(pg,"Intro Animation",function(on) introEnabled=on;saveConfig() end)
    if introEnabled~=false then setIntroVisual(true) end
    setIntroMusicVisual=mkToggle(pg,"Intro Music",function(on) introMusicEnabled=on;saveConfig() end)
    if introMusicEnabled~=false then setIntroMusicVisual(true) end
    setMobVisual=mkToggle(pg,"Mobile Buttons",function(on) mobileButtonsEnabled=on;if on then buildMobileButtons() else destroyMobileButtons() end;saveConfig() end)
    if mobileButtonsEnabled then setMobVisual(true) end
    do
        local row=mkRow(pg,30);mkLabel(row,"Btn Size")
        local sizeBox=Instance.new("TextBox",row)
        sizeBox.Size=UDim2.new(0,58,0,22);sizeBox.Position=UDim2.new(1,-66,0.5,-11)
        sizeBox.BackgroundColor3=INP;sizeBox.BorderSizePixel=0
        sizeBox.Text=tostring(mobileButtonsSize);sizeBox.TextColor3=PINK
        sizeBox.Font=Enum.Font.GothamBold;sizeBox.TextSize=10;sizeBox.ClearTextOnFocus=false;sizeBox.ZIndex=9
        Instance.new("UICorner",sizeBox).CornerRadius=UDim.new(0,5)
        sizeBox.FocusLost:Connect(function()
            local n=tonumber(sizeBox.Text)
            if n and n>=40 and n<=150 then mobileButtonsSize=n;if mobileButtonsEnabled then buildMobileButtons() end;saveConfig()
            else sizeBox.Text=tostring(mobileButtonsSize) end
        end)
    end
    do
        local row=mkRow(pg,30);mkLabel(row,"Reset Btn Pos")
        local resetPosBtn=Instance.new("TextButton",row)
        resetPosBtn.Size=UDim2.new(0,58,0,22);resetPosBtn.Position=UDim2.new(1,-66,0.5,-11)
        resetPosBtn.BackgroundColor3=PINK3;resetPosBtn.BorderSizePixel=0
        resetPosBtn.Text="Reset";resetPosBtn.TextColor3=WHITE
        resetPosBtn.Font=Enum.Font.GothamBold;resetPosBtn.TextSize=9;resetPosBtn.ZIndex=9
        Instance.new("UICorner",resetPosBtn).CornerRadius=UDim.new(0,5)
        resetPosBtn.Activated:Connect(function()
            pcall(function() if writefile then writefile(MOB_POS_FILE,"{}") end end)
            pcall(function()
                local raw=readfile("S2.json")
                if raw and writefile then
                    local cfg=HS:JSONDecode(raw)
                    if type(cfg)=="table" then cfg.btnPositions={}; writefile("S2.json",HS:JSONEncode(cfg)) end
                end
            end)
            forceDefaultBtnPos=true
            if mobileButtonsEnabled then buildMobileButtons() end
            forceDefaultBtnPos=false
            pcall(saveBtnPositions)
        end)
    end
    mkSectionLbl(pg,"Keybinds")
    mkKBRow(pg,"Speed Toggle",KB.SpeedToggle,function() saveConfig() end)
    mkKBRow(pg,"Lagger Mode",KB.LaggerToggle,function() saveConfig() end)
    mkKBRow(pg,"TP Bat",KB.TPBat,function() saveConfig() end)
    mkKBRow(pg,"Hide UI",KB.GuiHide,function() saveConfig() end)
    mkKBRow(pg,"Auto Play",KB.AutoLeft,function() saveConfig() end)
    mkKBRow(pg,"Aimbot",KB.AutoBat,function() saveConfig() end)
    mkKBRow(pg,"Drop Brainrot",KB.DropBrainrot,function() saveConfig() end)
    mkKBRow(pg,"TP Floor",KB.TPFloor,function() saveConfig() end)
    mkKBRow(pg,"Insta Reset",KB.InstaReset,function() saveConfig() end)

    trackConn(UIS.InputBegan:Connect(function(input,gpe)
        if _anyKeyListening then return end
        if input.UserInputType==Enum.UserInputType.Keyboard then if gpe or UIS:GetFocusedTextBox() then return end elseif not isGamepadInput(input) then return end
        if not isBindableInput(input) then return end
        local kc=input.KeyCode
        if kbMatch(KB.LaggerToggle,kc) then toggleLaggerMode();saveConfig()
        elseif kbMatch(KB.TPBat,kc) then
            if _G.S2AntiDesyncAimbotOn then
                _G.S2StopAntiDesyncAimbot()
                if batTP.setVisual then batTP.setVisual(false) end
                if mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
            else
                if autoBatEnabled then
                    stopBatAimbot()
                    if autoBatSetVisual then autoBatSetVisual(false) end
                    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
                end
                if aimbotV2Enabled then
                    stopAimbotV2()
                    if mobBtnRefs.aimbotV2 then mobBtnRefs.aimbotV2(false) end
                end
                if autoPlayEnabled then
                    stopAutoPlay()
                    if autoPlaySetVisual then autoPlaySetVisual(false) end
                    if mobBtnRefs.autoPlay then mobBtnRefs.autoPlay(false) end
                end
                _G.S2StartAntiDesyncAimbot()
                if batTP.setVisual then batTP.setVisual(true) end
                if mobBtnRefs.tpBat then mobBtnRefs.tpBat(true) end
            end
            saveConfig()
        elseif kbMatch(KB.SpeedToggle,kc) then toggleCarryMode();saveConfig()
        elseif kbMatch(KB.DropBrainrot,kc) then runDrop()
        elseif kbMatch(KB.TPFloor,kc) then runTPFloor()
        elseif kbMatch(KB.InstaReset,kc) then cursedInstaReset()
        elseif kbMatch(KB.AutoLeft,kc) or kbMatch(KB.AutoRight,kc) then
            autoPlayEnabled=not autoPlayEnabled
            if autoPlayEnabled then
                if _G.S2AntiDesyncAimbotOn then
                    _G.S2StopAntiDesyncAimbot()
                    if batTP.setVisual then batTP.setVisual(false) end
                    if mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
                end
                if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                if aimbotV2Enabled then stopAimbotV2() end
                startAutoPlay()
            else
                stopAutoPlay()
            end
            saveConfig()
        elseif kbMatch(KB.AutoBat,kc) then
            if not autoBatEnabled then
                if _G.S2AntiDesyncAimbotOn then
                    _G.S2StopAntiDesyncAimbot()
                    if batTP.setVisual then batTP.setVisual(false) end
                    if mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
                end
                if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                queueAutoBatStart();if autoBatSetVisual then autoBatSetVisual(true) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
            else stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
        elseif kbMatch(KB.AimbotV2,kc) then
            local on = not (autoBatEnabled or aimbotV2Enabled)
            if on then
                if _G.S2AntiDesyncAimbotOn then
                    _G.S2StopAntiDesyncAimbot()
                    if batTP.setVisual then batTP.setVisual(false) end
                    if mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
                end
                if autoPlayEnabled then stopAutoPlay() end
                if _G._S2_AimMode=="bypass" or antiBatBypassEnabled then startAimbotV2() else queueAutoBatStart() end
                if autoBatSetVisual then autoBatSetVisual(true) end
                if mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
            else
                stopBatAimbot();stopAimbotV2()
                if autoBatSetVisual then autoBatSetVisual(false) end
                if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
            end
        elseif kbMatch(KB.GuiHide,kc) then
            local outerRef = mainFrame and mainFrame.Parent
            if mainFrame.Visible then
                mainFrame.Visible=false
                if outerRef and outerRef.Name=="OuterBorder" then outerRef.Visible=false end
                miniBtn.Visible=true
            else
                if outerRef and outerRef.Name=="OuterBorder" then outerRef.Visible=true end
                mainFrame.Visible=true
                miniBtn.Visible=false
            end
        end
    end))
end

_savedCfg=nil
local function loadConfigKeys()
    local cfg = nil
    pcall(function()
        if getgenv and type(getgenv()._S2HubCfg)=="table" then
            cfg = getgenv()._S2HubCfg
        end
    end)
    if not cfg then
        local raw = nil
        pcall(function()
            if isfile("S2.json") then raw = readfile("S2.json") end
        end)
        if not raw then
            pcall(function()
                if isfile("S2HubConfig.json") then raw = readfile("S2HubConfig.json") end
            end)
        end
        if not raw then
            pcall(function() raw = readfile("S2.json") end)
        end
        if raw then
            local ok, decoded = pcall(function() return HS:JSONDecode(raw) end)
            if ok and type(decoded)=="table" then cfg = decoded end
        end
    end
    if not cfg then return end
    _savedCfg = cfg
    introEnabled = true
    local function lk(e,d)
        if type(d)~="table" then return end
        if d.kb and Enum.KeyCode[d.kb] then e.kb=Enum.KeyCode[d.kb] else e.kb=nil end
        if d.gp and Enum.KeyCode[d.gp] then e.gp=Enum.KeyCode[d.gp] else e.gp=nil end
    end
    lk(KB.DropBrainrot,cfg.dropBrainrotKey);lk(KB.AutoLeft,cfg.autoLeftKey);lk(KB.AutoRight,cfg.autoRightKey)
    lk(KB.AutoBat,cfg.autoBatKey);lk(KB.AimbotV2,cfg.aimbotV2Key);lk(KB.LaggerToggle,cfg.laggerToggleKey);lk(KB.LaggerCarry,cfg.laggerCarryKey);lk(KB.TPFloor,cfg.tpFloorKey)
    lk(KB.InstaReset,cfg.instaResetKey);lk(KB.GuiHide,cfg.guiHideKey);lk(KB.SpeedToggle,cfg.speedToggleKey)
    lk(KB.AntiDesync,cfg.antiDesyncKey);lk(KB.TPBat,cfg.tpBatKey)
    if cfg.autoCarryEnabled~=nil then autoCarryEnabled=cfg.autoCarryEnabled==true end
    if cfg.normalSpeed then NS=cfg.normalSpeed end;if cfg.carrySpeed then CS=cfg.carrySpeed end
    if cfg.laggerSpeed then LAGGER_SPEED=cfg.laggerSpeed end;if cfg.laggerCarrySpeed then LAGGER_CARRY_SPEED=cfg.laggerCarrySpeed end
    if cfg.grabRadius then Steal.StealRadius=cfg.grabRadius end
    if cfg.primeRange then Steal.PrimeRange=cfg.primeRange
    elseif cfg.grabRadius then Steal.PrimeRange=cfg.grabRadius end
    if cfg.stealDuration then Steal.StealDuration=cfg.stealDuration end
    if cfg.autoTPHeight then autoTPHeight=cfg.autoTPHeight end
    if cfg.autoSwing~=nil then autoSwingEnabled=cfg.autoSwing==true end
    if cfg.guiTransparencyEnabled~=nil then guiTransparencyEnabled=cfg.guiTransparencyEnabled end
    if cfg.mobileButtonsEnabled~=nil then mobileButtonsEnabled=cfg.mobileButtonsEnabled end
    if cfg.mobileButtonsSize~=nil then mobileButtonsSize=cfg.mobileButtonsSize end
    if cfg.circleButtonsEnabled~=nil then circleButtonsEnabled=cfg.circleButtonsEnabled==true end
    if cfg.antiKick~=nil then antiKickEnabled=cfg.antiKick==true end
    if cfg.carrySpeedActive~=nil then carrySpeedActive=cfg.carrySpeedActive end
    if cfg.laggerModeEnabled~=nil then laggerModeEnabled=cfg.laggerModeEnabled end
    if cfg.laggerCarryActive~=nil then laggerCarryActive=cfg.laggerCarryActive end
    if cfg.infJumpMode then infJumpMode=cfg.infJumpMode end
    if cfg.fovValue then fovValue=cfg.fovValue;for idx,v in ipairs(fovOptions) do if v==fovValue then fovIndex=idx end end end
    if cfg.chromeImageVisible~=nil then _G._MoveeDuels_bgImageVisible=cfg.chromeImageVisible==true end
    perButtonDragEnabled=true
    if cfg.autoMoveSwing~=nil then autoMoveSwingEnabled=cfg.autoMoveSwing==true end
    if cfg.autoMoveSwingInterval then autoMoveSwingInterval=cfg.autoMoveSwingInterval end
    if cfg.skyTheme then currentSkyTheme=cfg.skyTheme;CandyApplyCustomSky(currentSkyTheme) end
    currentGuiTheme="Cyber"
    if type(cfg.btnPositions)=="table" and next(cfg.btnPositions)~=nil and writefile then
        pcall(function() writefile(MOB_POS_FILE,HS:JSONEncode(cfg.btnPositions)) end)
    end
    if cfg.medusaReset~=nil then medusaResetEnabled=cfg.medusaReset==true end
    if cfg.ragdollGui~=nil then ragdollGuiEnabled=cfg.ragdollGui==true end
    if cfg.introEnabled~=nil then introEnabled=cfg.introEnabled~=false end
    if cfg.introMusicEnabled~=nil then introMusicEnabled=cfg.introMusicEnabled~=false end
    if cfg.selectedIntroMusic~=nil then selectedIntroMusic=cfg.selectedIntroMusic end
end
local function loadConfigState()
    local cfg=_savedCfg;if not cfg then return end
    
    if normalBox then normalBox.Text=tostring(NS) end;if carryBox then carryBox.Text=tostring(CS) end
    if primeRangeBox then primeRangeBox.Text=tostring(Steal.PrimeRange) end
    if radInput then radInput.Text=tostring(Steal.StealRadius) end;if durationBox then durationBox.Text=tostring(Steal.StealDuration) end
    if laggerBox then laggerBox.Text=tostring(LAGGER_SPEED) end
    if laggerCarryBox then laggerCarryBox.Text=tostring(LAGGER_CARRY_SPEED) end
    if autoTPHeightBox then autoTPHeightBox.Text=tostring(autoTPHeight) end
    task.spawn(function()
        task.wait(0.15)
        if cfg.antiRagdoll then antiRagdollEnabled=true;if setAntiRagVisual then setAntiRagVisual(true) end;startAntiRagdoll() end
        if cfg.autoStealEnabled then Steal.AutoStealEnabled=true;if setInstaGrab then setInstaGrab(true) end;pcall(startAutoSteal) end
        if cfg.infiniteJump then infJumpEnabled=true;if setInfJumpVisual then setInfJumpVisual(true) end;if infJumpMode=="hold" then startHoldInfJump() end end
        if cfg.medusaCounter then medusaCounterEnabled=true;if setMedusaVisual then setMedusaVisual(true) end;setupMedusa(LP.Character) end

        if cfg.batCounter then batCounterEnabled=true;if setBatCounterVisual then setBatCounterVisual(true) end;startBatCounter() end
        refreshSpeedModeLabel()
        if cfg.autoTPEnabled then autoTPEnabled=true;if setAutoTPVisual then setAutoTPVisual(true) end;startAutoTP() end
        if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled) end
        if cfg.autoBat then
            autoBatEnabled=true;if autoBatSetVisual then autoBatSetVisual(true) end
            if mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
            queueAutoBatStart()
        end
        if cfg.aimbotV2 then
            aimbotV2Enabled=true;if aimbotV2SetVisual then aimbotV2SetVisual(true) end
            if mobBtnRefs.aimbotV2 then mobBtnRefs.aimbotV2(true) end
            startAimbotV2()
        end
        if cfg.unwalkEnabled then unwalkEnabled=true;if setUnwalkVisual then setUnwalkVisual(true) end;task.spawn(function() task.wait(0.5);startUnwalk() end) end
        if cfg.antiLag then enableAntiLag();if setAntiLagVisual then setAntiLagVisual(true) end end
        if cfg.espBox then espBoxEnabled=true;if setEspBoxVisual then setEspBoxVisual(true) end end
        if cfg.espHighlight then espHighlightEnabled=true;if setEspHighlightVisual then setEspHighlightVisual(true) end end
        if cfg.espTracer then espTracerEnabled=true;if setEspTracerVisual then setEspTracerVisual(true) end end
        if cfg.espSpeed then espSpeedEnabled=true;if setEspSpeedVisual then setEspSpeedVisual(true) end end
        if cfg.espRagdollCD then espRagdollCDEnabled=true;if setEspRagdollCDVisual then setEspRagdollCDVisual(true) end end
        if espApply then espApply() end
        if cfg.antiKick then enableAntiKick();if antiKickSetVisual then antiKickSetVisual(true) end end
        if circleButtonsEnabled and setCircleBtnsVisual then setCircleBtnsVisual(true) end
        if cfg.skyTheme then CandyApplyCustomSky(cfg.skyTheme) end
    end)
end

local _okInit, _errInit = pcall(function()
    loadConfigKeys()
    buildGui()
    if mobileButtonsEnabled then buildMobileButtons() end
    loadConfigState()
    CandyApplyCustomSky(currentSkyTheme)
end)
if not _okInit then
    warn("[S2Hub] init error: ", _errInit)
    print("[S2Hub] init error: ", _errInit)
end

task.spawn(function()
    task.wait(0.4)
    if introEnabled == false then return end
    pcall(function()
        local guiParent = (LP and LP:FindFirstChild("PlayerGui")) or game:GetService("CoreGui")
        for _,n in ipairs({"S2Intro","CalciumIntro"}) do
            local o = guiParent:FindFirstChild(n) or game:GetService("CoreGui"):FindFirstChild(n)
            if o then o:Destroy() end
        end
        local sg = Instance.new("ScreenGui")
        sg.Name = "S2Intro"
        sg.ResetOnSpawn = false
        sg.DisplayOrder = 9999
        sg.IgnoreGuiInset = true
        pcall(function() sg.Parent = game:GetService("CoreGui") end)
        if not sg.Parent then sg.Parent = guiParent end
        local bg = Instance.new("Frame", sg)
        bg.Size = UDim2.new(1,0,1,0)
        bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
        bg.BackgroundTransparency = 0.2
        bg.BorderSizePixel = 0
        local t1 = Instance.new("TextLabel", bg)
        t1.Size = UDim2.new(1,0,0,52)
        t1.Position = UDim2.new(0,0,0.4,0)
        t1.BackgroundTransparency = 1
        t1.Text = "S2 HUB"
        t1.TextColor3 = Color3.fromRGB(140,195,255)
        t1.Font = Enum.Font.GothamBlack
        t1.TextSize = 44
        t1.TextTransparency = 1
        local t2 = Instance.new("TextLabel", bg)
        t2.Size = UDim2.new(1,0,0,28)
        t2.Position = UDim2.new(0,0,0.4,52)
        t2.BackgroundTransparency = 1
        t2.Text = "MOG ALL SCRIPT"
        t2.TextColor3 = Color3.fromRGB(210,230,255)
        t2.Font = Enum.Font.GothamBold
        t2.TextSize = 18
        t2.TextTransparency = 1
        TweenService:Create(t1, TweenInfo.new(0.4), {TextTransparency=0}):Play()
        TweenService:Create(t2, TweenInfo.new(0.5), {TextTransparency=0}):Play()
        task.wait(1.5)
        TweenService:Create(t1, TweenInfo.new(0.3), {TextTransparency=1}):Play()
        TweenService:Create(t2, TweenInfo.new(0.3), {TextTransparency=1}):Play()
        TweenService:Create(bg, TweenInfo.new(0.35), {BackgroundTransparency=1}):Play()
        task.wait(0.4)
        sg:Destroy()
    end)
end)

-- ===== Auto Carry Speed (auto switch to carry mode while carrying a brainrot) =====
do
    local RS = game:GetService("RunService")
    local _acApplied = false
    local _acReturn = nil
    local _acGrace = 0
    local _acStealWas = false

    local function isCarryName(name)
        local n = tostring(name or ""):lower()
        return n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") or n:find("hold")
    end
    local function isIgnoredCarryTool(name)
        local n = tostring(name or ""):lower()
        return n:find("bat") or n:find("slap") or n:find("medusa") or n:find("head") or n:find("stone")
    end
    local function isCarryingBrainrot(char)
        if not char then return false end
        for _, name in ipairs({"Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab"}) do
            local v = char:FindFirstChild(name, true)
            if v then
                if v:IsA("BoolValue") and v.Value then return true end
                if v:IsA("ObjectValue") and v.Value then return true end
                if v:IsA("StringValue") and v.Value ~= "" then return true end
            end
        end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
                if child:FindFirstChildOfClass("Humanoid") and child:FindFirstChild("HumanoidRootPart") then return true end
                if isCarryName(child.Name) then return true end
            elseif child:IsA("Tool") and not isIgnoredCarryTool(child.Name) then
                return true
            end
        end
        return false
    end
    local function refreshBtns()
        if refreshSpeedModeLabel then pcall(refreshSpeedModeLabel) end
        if mobBtnRefs then
            if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive or laggerCarryActive) end
            if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled or laggerCarryActive) end
        end
    end
    local function applyCarry()
        if _acApplied then return end
        if laggerCarryActive then _acReturn="LaggerCarry"
        elseif laggerModeEnabled then _acReturn="Lagger"
        elseif carrySpeedActive then _acReturn="Carry"
        else _acReturn="Normal" end
        _acApplied = true
        _acGrace = tick() + 0.75
        if _acReturn=="Lagger" or _acReturn=="LaggerCarry" then
            laggerModeEnabled=false;laggerCarryActive=true;carrySpeedActive=false
        else
            laggerModeEnabled=false;laggerCarryActive=false;carrySpeedActive=true
        end
        refreshBtns()
    end
    local function restore()
        if not _acApplied then return end
        _acApplied = false
        _acGrace = 0
        local r = _acReturn; _acReturn = nil
        if r=="Lagger" then laggerModeEnabled=true;laggerCarryActive=false;carrySpeedActive=false
        elseif r=="LaggerCarry" then laggerModeEnabled=false;laggerCarryActive=true;carrySpeedActive=false
        elseif r=="Carry" then laggerModeEnabled=false;laggerCarryActive=false;carrySpeedActive=true
        else laggerModeEnabled=false;laggerCarryActive=false;carrySpeedActive=false end
        refreshBtns()
    end

    RS.RenderStepped:Connect(function()
        if autoCarryEnabled ~= true then
            if _acApplied then restore() end
            _acStealWas=false
            return
        end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hum then if _acApplied then restore() end;_acStealWas=false;return end
        local st = hum:GetState()
        local gotHit = st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
        local stealing = LP:GetAttribute("Stealing")==true
        local carrying = isCarryingBrainrot(char)
        if stealing and not _acStealWas then _acStealWas=true;applyCarry()
        elseif not stealing then _acStealWas=false end
        if carrying and not _acApplied then applyCarry() end
        if _acApplied then
            local graceDone = tick() > _acGrace
            if gotHit or (graceDone and not carrying and not stealing) then restore() end
        end
    end)
end

-- half autograb always on
Steal.AutoStealEnabled=true
pcall(startAutoSteal)