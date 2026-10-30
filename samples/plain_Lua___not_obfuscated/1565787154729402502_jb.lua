-- Static deobfuscation pass: decoded arithmetic-encoded string literals.
-- Original variable names and runtime-dependent behavior are not recoverable automatically.

--[[

     ██╗██████╗    ██╗  ██╗██╗   ██╗██████╗
     ██║██╔══██╗   ██║  ██║██║   ██║██╔══██╗
     ██║██████╔╝   ███████║██║   ██║██████╔╝
██   ██║██╔══██╗   ██╔══██║██║   ██║██╔══██╗
╚█████╔╝██████╔╝   ██║  ██║╚██████╔╝██████╔╝
 ╚════╝ ╚═════╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝

 ─────────────  made by uhq7k  ─────────────

]]

return(
function(...)
local Z=606849621

local I=245662005

local j,p=pcall(
function()
return game.PlaceId end)
local o,r=pcall(
function()
return game.GameId end)
if not(((j and p==Z)or(o and r==I)))
then

local Z="[JB Hub] Wrong game (PlaceId "..(tostring(p)..")")
if not pcall(warn,Z)
then print(Z)end pcall(
function()notify("Wrong game, JB Hub not loaded","[JB Hub]",5)end)
return end _G.JB_gen=((_G.JB_gen or 0))+1

local u=_G.JB_gen

local z="_"..tostring(math.floor(tick()*1000))
local

function S(Z)
return Z..z end SPLASH={BASE="https://raw.githubusercontent.com/Sayf199/JB-Hub/main/assets/",FILES={"logo.png";
"glow_red.png","glow_blue.png","vignette.png";
"bar.png"};
VERSION="v2.4";
DOWNLOAD_TIMEOUT=6,MIN_TIME=3;
STEP_TIME=.32;
TIMEOUT=25;
ROWS=4;
TAGS={ok={"[  OK  ]";
Color3.fromRGB(90,220,130)};
warn={"[ WARN ]",Color3.fromRGB(255,190,70)},fail={"[ FAIL ]",Color3.fromRGB(255,85,85)}},objects={},queue={},log={};
info={};
target=0;
shown=0,labelAt=0,finishing=false,started=false;
done=false}
function SPLASH.clear()
for Z,I in ipairs(SPLASH.objects)
do pcall(
function()I:Remove()end)end SPLASH.objects={}_G.JB_SPLASH=nil SPLASH.done=true end

function SPLASH.ease(Z)Z=math.clamp(Z,0,1)
return 1-((1-Z))^3 end

function SPLASH.strobe(Z,I)
local j=((Z+I))%1.4

local p=0

for Z,I in ipairs({0,.18})
do

local o=j-I

if o>=0 and o<.16

then p=math.max(p,math.sin((o/.16)*math.pi))end end

return p end

function SPLASH.new(Z,I)
local j=Drawing.new(Z)
for Z,I in pairs(I)
do j[Z]=I end SPLASH.objects[#SPLASH.objects+1]=j

return j end

function SPLASH.download()
local Z,I={},#SPLASH.FILES+1

for j,p in ipairs(SPLASH.FILES)
do task.spawn(
function()
local j,o=pcall(
function()
return game:HttpGet(SPLASH.BASE..p)end)
if j and(type(o)=="string"and o:sub(2,4)=="PNG")
then Z[p]=o end I=I-1 end)end task.spawn(
function()pcall(
function()
local Z=(game:GetService("Players")).LocalPlayer.UserId

local I=(game:GetService("HttpService")):JSONDecode(game:HttpGet("https://users.roblox.com/v1/users/"..tostring(Z)))
if type(I)=="table"
then SPLASH.account=I end end)I=I-1 end)
local j=tick()
while I>0 and tick()-j<SPLASH.DOWNLOAD_TIMEOUT

do task.wait(.05)end

return Z end

function SPLASH.userName()
local Z=SPLASH.account

local I=type(Z)=="table"and Z.name or nil

local j=type(Z)=="table"and Z.displayName or nil

if not I

then

local Z=(game:GetService("Players")).LocalPlayer I=Z and Z.Name or"player"end

if type(j)=="string"and(#j>0 and j~=I)
then

return j..(" ("..(I..")"))end

return I end

function SPLASH.start()
if _G.JB_SPLASH

then

for Z,I in ipairs(_G.JB_SPLASH)
do pcall(
function()I:Remove()end)end end

local Z=SPLASH.download()
if not Z["logo.png"]
then

return end _G.JB_SPLASH=SPLASH.objects

local I=workspace.CurrentCamera.ViewportSize

local j=I.Y/1080

local p=SPLASH.new

local o={}
local r=Drawing.Fonts.ProximaSoftBold or 0

local u=Drawing.Fonts.Monospace or r

if Z["vignette.png"]
then o.vignette=p("Image",{Data=Z["vignette.png"];
Position=Vector2.new(0,0);
Size=I,Transparency=0;
ZIndex=1;
Visible=true})
else o.vignette=p("Square",{Position=Vector2.new(0,0),Size=I,Color=Color3.fromRGB(4,6,10);
Filled=true;
Transparency=0;
ZIndex=1,Visible=true})end

local z=1000*j

if Z["glow_red.png"]
then o.red=p("Image",{Data=Z["glow_red.png"],Position=Vector2.new(-z*.5,-z*.4);
Size=Vector2.new(z,z);
Transparency=0,ZIndex=2;
Visible=true})end

if Z["glow_blue.png"]
then o.blue=p("Image",{Data=Z["glow_blue.png"];
Position=Vector2.new(I.X-z*.5,-z*.4);
Size=Vector2.new(z,z),Transparency=0;
ZIndex=2;
Visible=true})end o.logo=p("Image",{Data=Z["logo.png"];
Position=Vector2.new(0,0),Size=Vector2.new(1,1);
Transparency=0;
ZIndex=5;
Visible=true})o.welcome=p("Text",{Text="";
Font=r;
Size=20,Center=true,Outline=false,Color=Color3.fromRGB(225,229,238);
Transparency=0;
ZIndex=6;
Visible=true})
local S,b=440*j,3

local x,g=((I.X-S))/2,I.Y/2+95*j o.track=p("Square",{Position=Vector2.new(x,g);
Size=Vector2.new(S,b);
Color=Color3.fromRGB(34,38,48);
Filled=true,Transparency=0;
ZIndex=6;
Visible=true})
if Z["bar.png"]
then o.fill=p("Image",{Data=Z["bar.png"];
Position=Vector2.new(x,g);
Size=Vector2.new(1,b);
Transparency=0;
ZIndex=7,Visible=true})
else o.fill=p("Square",{Position=Vector2.new(x,g);
Size=Vector2.new(1,b);
Color=Color3.fromRGB(30,110,255);
Filled=true;
Transparency=0,ZIndex=7;
Visible=true})end o.pct=p("Text",{Text="0%";
Font=u,Size=14;
Center=false,Outline=false;
Color=Color3.fromRGB(120,128,142),Position=Vector2.new((x+S)+10,g-5);
Transparency=0;
ZIndex=7,Visible=true})o.rows={}
for Z=1,SPLASH.ROWS,1

do o.rows[Z]={tag=p("Text",{Text="";
Font=u,Size=14,Center=false;
Outline=false;
Color=Color3.fromRGB(90,220,130);
Transparency=0;
ZIndex=7;
Visible=true}),msg=p("Text",{Text="";
Font=u;
Size=14;
Center=false,Outline=false;
Color=Color3.fromRGB(200,205,215);
Transparency=0;
ZIndex=7;
Visible=true})}end

local m=p("Text",{Text="[ WARN ]",Font=u,Size=14;
Center=false,Outline=false;
Transparency=0,ZIndex=1,Visible=true})task.wait()task.wait()SPLASH.tagW=m.TextBounds.X>0 and m.TextBounds.X or 64 m.Text=string.rep("0",40)task.wait()task.wait()SPLASH.charW=m.TextBounds.X>0 and m.TextBounds.X/40 or SPLASH.tagW/8 m.Visible=false o.left=p("Text",{Text="JB HUB  "..SPLASH.VERSION;
Font=u;
Size=14;
Center=false;
Outline=false;
Color=Color3.fromRGB(110,118,132),Position=Vector2.new(28*j,I.Y-40*j);
Transparency=0,ZIndex=7,Visible=true})o.right=p("Text",{Text="",Font=u,Size=14,Center=false;
Outline=false;
Color=Color3.fromRGB(110,118,132);
Position=Vector2.new(I.X-300,I.Y-40*j);
Transparency=0;
ZIndex=7,Visible=true})SPLASH.o,SPLASH.vp,SPLASH.s=o,I,j SPLASH.bx,SPLASH.by,SPLASH.bw,SPLASH.bh=x,g,S,b SPLASH.info.user=SPLASH.userName()SPLASH.info.exec="Matcha"pcall(
function()SPLASH.info.exec=identifyexecutor()end)SPLASH.info.hybrid="Hybrid --"SPLASH.started=true end

function SPLASH.step(Z,I,j)
local p="[JB] "..Z

if j=="fail"or j=="warn"
then

if not pcall(warn,p)
then print(p)end

else print(p)end

if SPLASH.done

then

return end SPLASH.queue[#SPLASH.queue+1]={label=Z;
pct=I,state=j or"ok"}end

function SPLASH.reportInterface()
if SPLASH.uiOk

then SPLASH.step("Interface ready",100)
else SPLASH.step("Interface failed to build",100,"fail")end SPLASH.finishing=true end

function SPLASH.run()
if not SPLASH.started

then

local Z=tick()
while not SPLASH.uiDone and tick()-Z<5

do task.wait(.05)end SPLASH.done=true SPLASH.reportInterface()
return end SPLASH.t0=tick()
local Z,I=pcall(SPLASH.loop)
if not Z

then print("[JB Splash] error: "..tostring(I))end SPLASH.clear()end

function SPLASH.loop()
local Z,I,j=SPLASH.o,SPLASH.vp,SPLASH.s

local p,o=SPLASH.ease,SPLASH.strobe

local r,u=tick(),nil

local z,S=560*j,.346875

local b="Welcome back, "..SPLASH.info.user

while true

do

local x=tick()
local g=math.min(x-r,.1)r=x

local m=x-SPLASH.t0

if not SPLASH.finishing and((SPLASH.uiDone or m>6))
then SPLASH.reportInterface()end

if#SPLASH.queue>0 and(m>.7 and x-SPLASH.labelAt>=SPLASH.STEP_TIME)
then

local Z=table.remove(SPLASH.queue,1)Z.at=x table.insert(SPLASH.log,1,Z)SPLASH.log[SPLASH.ROWS+1]=nil SPLASH.labelAt=x SPLASH.target=math.max(SPLASH.target,Z.pct)end SPLASH.shown=SPLASH.shown+((SPLASH.target-SPLASH.shown))*math.min(1,g*5)
if SPLASH.target-SPLASH.shown<.3

then SPLASH.shown=SPLASH.target end

if SPLASH.finishing and(not u and(#SPLASH.queue==0 and(SPLASH.shown>=99.9 and m>=SPLASH.MIN_TIME)))
then u=x+.5 end

local U=u and(1-p(((x-u))/.45))or 1

local A=p(m/.5)*U

local a=u and(p(((x-u))/.45)*30)*j or 0 Z.vignette.Transparency=A

if Z.red

then Z.red.Transparency=A*((.12+.55*o(m,0)))end

if Z.blue

then Z.blue.Transparency=A*((.12+.55*o(m,.7)))end

local k=z*((1.06-.06*p(m/1.1)))
local J=k*S

local X,O=I.X/2,(I.Y/2-70*j)-a Z.logo.Size=Vector2.new(k,J)Z.logo.Position=Vector2.new(X-k/2,O-J/2)Z.logo.Transparency=p(((m-.05))/.8)*U

local R=p(((m-.5))/.6)*U

local i=math.clamp(math.floor(((m-.5))*38),0,#b)Z.welcome.Text=b:sub(1,i)Z.welcome.Position=Vector2.new(X,(O+J/2)+6*j)Z.welcome.Transparency=R

local v=p(((m-.6))/.5)*U

local E=SPLASH.by-a Z.track.Position=Vector2.new(SPLASH.bx,E)Z.track.Transparency=v*.9 Z.fill.Position=Vector2.new(SPLASH.bx,E)Z.fill.Size=Vector2.new(math.max(1,(SPLASH.bw*SPLASH.shown)/100),SPLASH.bh)Z.fill.Transparency=v Z.pct.Text=math.floor(SPLASH.shown+.5).."%"Z.pct.Position=Vector2.new((SPLASH.bx+SPLASH.bw)+10*j,E-5)Z.pct.Transparency=v

local e=E+18*j

for I=1,SPLASH.ROWS,1

do

local o,r=Z.rows[I],SPLASH.log[I]
if r

then

local Z=SPLASH.TAGS[r.state]or SPLASH.TAGS.ok

local u=p(((x-r.at))/.25)
local z=(({1,.55,.32;
.18}))[I]or.15

local S=(e+(((I-1))*18)*j)+((I==1 and((1-u))*6 or 0))o.tag.Text=Z[1]o.tag.Color=Z[2]o.tag.Position=Vector2.new(SPLASH.bx,S)o.tag.Transparency=(v*z)*((I==1 and u or 1))o.msg.Text=r.label o.msg.Position=Vector2.new((SPLASH.bx+SPLASH.tagW)+10,S)o.msg.Transparency=(v*z)*((I==1 and u or 1))
else o.tag.Transparency,o.msg.Transparency=0,0 end end Z.left.Transparency=v

local h=SPLASH.info.exec..("  /  "..(SPLASH.info.hybrid..((SPLASH.info.online and("  /  "..(SPLASH.info.online.." online"))or""))))
if h~=SPLASH.rightText

then SPLASH.rightText=h Z.right.Text=h end

local N=SPLASH.charW or((SPLASH.tagW or 64))/8 Z.right.Position=Vector2.new((I.X-36*j)-#h*N,I.Y-40*j)Z.right.Transparency=v

if u and x-u>=.45

then break end

if m>SPLASH.TIMEOUT

then break end task.wait()end end SPLASH.start()SPLASH.step("Jailbreak detected",10)
local b=388

local x=467

local g="NoRagdollNoFallDamage"
local m={"Zone Follow","Pulse"}
local U=Vector3.new(2048,2048,2048)
local A=.1

local a=.01

local k=15

local J=.04

local X=-2

local O=466

local R=376

local i=228

local v={"Nitro","NitroMax"}
local E={Nitro=999999;
NitroMax=999999}
local e=.5

local h=600

local N=1

local t=180

local d=100

local F=101

local B=102

local T={TITLE="[JB Hub] Auto Vault",START_RANGE=20;
START_DELAY=2;
TICK=.01;
PRESS_GAP=.3;
RESTART_AFTER=6,MAX_RESTARTS=5;
WHITES_NEEDED=3}
local G={TITLE="[JB Hub] Auto Collect Loot",RANGE=40;
TICK=.25;
PER_GAP=1,RESCAN=2,IDLE=.5;
BAG_SCAN=1;
BAG_LABEL={"RobberyMoneyGui","Frame","Container","Bottom","Progress","Amount"}}
local w={FLY_TITLE="[JB Hub] Vehicle Fly";
FLY_KEY=97;
FLY_DEFAULT_SPEED=300,FLY_VERTICAL_SPEED=80;
FLY_ACCEL=6;
FLY_TURN_GAIN=4;
FLY_KEYS={fwd=87;
back=83;
left=81,right=68,up=16,down=17};
BOOST_TITLE="[JB Hub] Engine Boost",BOOST_KEY=98;
BOOST_DEFAULT=1.05;
BOOST_MAX=2;
BOOST_PAIR_RANGE=4096;
BOOST_RESCAN=3,ROOT_PARTS={"Weight";
"Engine"};
FLY_LOST_GRACE=1.5;
FIND_RADIUS=40;
TIRE_TITLE="[JB Hub] Anti Tires Pop",TIRE_SPIKE_SCAN=.5;
TIRE_MIN_WIDTH=5;
BRAKE_TITLE="[JB Hub] Instant Brake",BRAKE_KEY=99,BRAKE_KEYS={83,40};
BRAKE_MIN_SPEED=2;
FLIP_TITLE="[JB Hub] Anti Flip";
FLIP_ANG=236;
FLIP_TRIGGER=.5;
FLIP_DONE=.9;
FLIP_GAIN=5;
FLIP_LIFT=8,FLIP_TICK=.03}
local C={TITLE="[JB Hub] Auto Glass";
RANGE=40;
TICK=.25;
PER_GAP=1;
RESCAN=2;
IDLE=.5}
local K={SIGNS={-1,1},ESP_SCAN_CHUNK=60,ESP_PARENT_CHECK=.2,LASER_YIELD_EVERY=100,PLASMA_TARGET_REFRESH=.3,PLASMA_CACHE_TIME=1,LASER_ANCHOR_EVERY=15;
LASER_NEAR_RANGE=400,LASER_NEAR_CHECK=1,TURRET_RECHECK=3;
FLY_RECHECK=1,flying=false,NFD_ZONE_CHECK=2;
TOMB_TICK=.5;
TOMB_SPIKE_REFRESH=10,TOMB_RECHECK=10;
NFD_ZONE_MARGIN=200;
LASER_NEAR_REFRESH=3;
LASER_ROTATE_REFRESH=8;
LASER_FULL_EVERY=6,LASER_EXTRA_EVERY=1,LASER_RECHECK_EVERY=10;
MIL_RESCAN_MAX=300;
solving=false,JOB_SAFETY_RESCAN=1000000000,NEAR_MILITARY=1500;
NEAR_CARGO=800;
KILL_NPC_KEY=104,ceoGuards={},bountyColor=Color3.fromRGB(255,60,60),SLOT_TITLE="[JB Hub] Unlock Weapons Slots",SLOT_ATTR="InventoryItemLocked",SLOT_TICK=.25;
SLOT_WATCH=5;
SKY_TITLE="[JB Hub] Sky Color";
WORLD_TICK=.25;
WORLD_REAPPLY=1,ATMOS={Color=160;
Decay=172,Density=184;
Glare=188,Haze=192;
Offset=196};
SKY_NAMES={"Purple";
"Pink","Sunset";
"Blood Red";
"Night Blue";
"Toxic Green";
"Ocean"},SKY_PRESETS={{Color={.8,.3,1},Decay={.5,.1,.9};
Density=.3;
Glare=4,Haze=6,Offset=.6},{Color={1;
.55;
.85};
Decay={1;
.3,.65},Density=.3;
Glare=4,Haze=6,Offset=.6},{Color={1;
.6,.3},Decay={.9;
.3,.15},Density=.3,Glare=6;
Haze=5,Offset=.5};
{Color={.9;
.15;
.1},Decay={.5;
0,0};
Density=.35;
Glare=3;
Haze=7;
Offset=.6};
{Color={.25,.35,.85},Decay={.05,.1,.4},Density=.35;
Glare=1,Haze=7,Offset=.6},{Color={.4;
1;
.45};
Decay={.1;
.55,.25},Density=.3;
Glare=3;
Haze=6;
Offset=.6},{Color={.3;
.85,1},Decay={.05,.4,.7},Density=.3;
Glare=3,Haze=6;
Offset=.6}};
TASER_TITLE="[JB Hub] Anti Taser";
TASER_STUN_KEY="k53q14u3";
TASER_DECOY_KEY="Stunned",TASER_KEY_PTR=16,TASER_CHECK=2;
NERF_TITLE="[JB Hub] Nerf Skins",NERF_TICK=.25,NERF_HELD_RANGE=25;
NERF_UNLOAD_WAIT=15,NERF_NAME=104,NERF_DATA=0,NERF_SIZE=16;
NERF_CAP=24,NERF_REF=40,NERF_ICON_ATTR="HotbarImageSrc";
NERF_SWAPS={Revolver="NerfRevolver",Pistol="NerfPistol"};
NERF_BACK={NerfRevolver="Revolver";
NerfPistol="Pistol"};
NERF_ICONS={Revolver="rbxassetid://16647917031";
Pistol="rbxassetid://16647913398";
NerfRevolver="rbxassetid://6930017845";
NerfPistol="rbxassetid://6930018123"},WORLD_CHUNK_NPC=20,WORLD_CHUNK_SPIKE=50,npcFolders={};
spikeModels={},homeModels={},guardFlag={};
ownerCache={};
ceoNext={},GUARD_RECHECK=2;
GUARD_PER_TICK=3,CEO_RECHECK=.6;
BOUNTY_EVERY=1;
NPC_TICK=.05,GUARD_NEW_PER_TICK=4;
GUARD_MAINTAIN=.5;
WORLD_CHUNK_FIRST=80,worldReady=false;
profile=false,offsetDebug=false,PROFILE_EVERY=5,equipVersion=0,equipSeen={},equipRaw=0,JOB_BATCH_DELAY=1.5,EQUIP_WATCH_TICK=.15;
stats={};
SHOOT_TITLE="[JB Hub] Auto Shoot",SHOOT_TRIES=1;
SHOOT_REAPPLY=2;
SHOOT_BOOL_TAG=1}
local V={TITLE="[JB Hub] Cosmetics";
KEY=70,requested=false,lastFlip=0,bindActive=false,bindNotify=false;
leftAt=nil,EXIT_GRACE=.1;
PLATE={id="cosPlate";
props={"LicensePlate"}},PLATE_TEXT="JB Hub",SLOTS={{id="cosColor",label="Color",props={"BodyColor";
"SecondBodyColor","WheelColor","SpoilerColor"};
list={"None";
"Black","HyperShift","HyperBlueLvl5","HyperDiamondLvl5";
"HyperPinkLvl5";
"HyperPurpleLvl5","HyperOrangeLvl5";
"HyperYellowLvl5";
"HyperRedLvl5","HyperGreenLvl5","Vantablack"}};
{id="cosTexture";
label="Texture",props={"Texture";
"SecondTexture"};
list={"None","Checker","Drip";
"Snowstorm","GalacticCarbon","Earthquake","BlackIce","BluePixel";
"Fire","Manga";
"Tiger";
"OrangePixel";
"Pixel","Armor"}},{id="cosHorn",label="Horn";
props={"Horn"};
list={"None","Original";
"Cucaracha","ChampionTrumpets","Winner","Injan"}},{id="cosRim";
label="Rim";
props={"Rim"},list={"None","Void";
"LaserCannon";
"RTX","Radar","Storm";
"BluePortal","Retrowave","Live2024","Live2026";
"Pixeltary","INF1N1TY"}},{id="cosSpoiler",label="Spoiler";
props={"Spoiler"},list={"None";
"Thrusters";
"CashSpitter","OG Rocket Thrusters";
"DualRockets","Ghost Catcher";
"Afterburner"}},{id="cosTire",label="Tire Style";
props={"TireMesh"},list={"None";
"Brickset","Spiked";
"SnowTrail","Snowchain","Voltline","Glacier"}},{id="cosTireSticker";
label="Tire Sticker",props={"TireSticker"};
list={"None";
"Blue50";
"JailbreakArmy","Red50";
"Japanese","3Billion";
"Lightning"}}}}
local l=71

local Y="GuardNPC"
local L=Vector3.new(.001,.001,.001)
local f=2

local W=.25

local H={{"Banks";
sub="Lasers"};
{"MansionRobbery";
"LaserTraps"},{"MansionDetails";
only="BarbedWire"};
{"Museum";
"CaseLasers"};
{"Museum","Lights";
only="Light"};
{"OilRig";
"MovingLasers"};
{"Casino";
"VaultLaserControl"};
{"Casino","LasersMoving"},{"Casino","LaserCarousel"},{"Casino","Lasers"};
{"Casino";
"CamerasMoving"};
{"MilitaryIsland";
"MilitaryLasers"};
{"Interior_MaxSecurity",only="BarbedWire"};
{"PowerPlant",only="BarbedWire"},{"TombRocks1";
only="BarbedWire"};
{"TombRocks2",only="BarbedWire"};
{"Jewelrys"};
{"Jewelry"}}
local P={TouchToEnter=true,HatchTouch=true;
TriggerDoor=true}
local y={{"OilRig";
"Turrets"}}
local M={{"CargoShip";
"TurretFront"};
{"CargoShip","TurretBack"}}
local c=1

local q="[JB Hub] No Turret Damage"
local n=6

local D={FREEZE=1e+15,RESCAN=15,PAIR_RANGE=1024,RESCAN_SLOW=120;
HOME_RESCAN=5}
local s={"TURRET_DAMAGE";
"FIRE_RATE"}
local Q={TURRET_DAMAGE=0;
FIRE_RATE=1000000000}
local Zz={TURRET_DAMAGE=6;
FIRE_RATE=.1}
local Iz=5

local jz=-10000

local pz=.0001

local oz=1000000000

local rz=3

local uz=4

local zz="PlasmaPistol"
local Sz=20

local bz=190

local xz=.05

local gz=.5

local mz=.6

local Uz=.4

local Az=.02

local az={"FireFreq","ReloadTime","MagSize";
"Range";
"Damage"}
local kz={FireFreq=60,ReloadTime=.1}
local Jz=512

local Xz=6

local Oz=.25

local Rz=103

local iz=2

local vz=1.25

local Ez=.06

local ez=.06

local hz=4

local Nz=.015

local tz=.03

local dz=.08

local Fz=3

local Bz=6

local Tz=.25

local Gz={Color3.fromRGB(255,0,0);
Color3.fromRGB(0,120,255),Color3.fromRGB(189,0,255);
Color3.fromRGB(255,154,0),Color3.fromRGB(1,255,31)}
local wz={Key={id="keycardEsp",label="KEYCARD",title="[JB Hub] Keycard ESP",color=Color3.fromRGB(0,140,255);
parts={"Handle"}};
CrimeKey={id="crimekeyEsp";
label="CRIMEKEY";
title="[JB Hub] Crimekey ESP",color=Color3.fromRGB(255,210,0);
parts={"Handle"}},Drop={id="airdropEsp";
label="AIRDROP";
title="[JB Hub] Airdrop ESP";
color=Color3.fromRGB(148,96,69);
parts={"Particles","Root","Handle"};
colorFrom="Top"};
Cash={id="cashEsp";
label="CASH";
title="[JB Hub] Cash Dropped ESP",color=Color3.fromRGB(0,220,90);
parts={"BoundingBox";
"Part"},container="DroppedCash",amountFrom="Amount"},Bounty={id="bountyEsp",label="BOUNTY";
title="[JB Hub] Bounty ESP";
color=Color3.fromRGB(255,60,60),parts={},container="__players",modes={"Color Based","Custom Color"},gameColor=Color3.fromRGB(255,0,0);
gameOutline=Color3.fromRGB(47,0,0);
up=Vector3.new(0,3,0);
down=Vector3.new(0,-3.2,0)}}
local Cz=3

local Kz=10

local Vz=.15

local lz=3

local Yz=8

local Lz=16

local fz=10

local Wz=30

local Hz=500

local Pz=1080

local yz={"puzzleSolve";
"puzzlePath";
"nofall","nolaser";
"noturret";
"noForcefield";
"antiTaser";
"nosit";
"casino","casinoOpen","autoVault";
"autoGlass","autoLoot","autoHack";
"keycardEsp","crimekeyEsp";
"airdropEsp";
"cashEsp","bountyEsp","killNpcs","guards","attackCeo";
"npcHitbox";
"swordNoCd";
"swordLunge","punchNoCd","rocketLock","instant";
"plasma","norecoil","nospread","autoShoot";
"nitro";
"jetpack","unlockSlots","nerfSkins";
"plasmaKillaura","cosmeticsBind";
"cosmeticsLoop","cosPlate","carFly","engineBoost","instantBrake";
"antiTirePop";
"antiFlip","tombDarts";
"tombSpikes","tombBridge";
"tombCart","skyColor";
"skinChanger","hitSound","autoTaser","autoCuff","waterCustom"}K.SKIN_IDS={"Drip","Aurora","BlackIce","CircuitBoard","WhiteMarble"}K.SKIN_WEAPONS={"AK47","Rifle";
"Pistol";
"Revolver","PlasmaPistol","PlasmaShotgun","RocketLauncher"}K.SKIN_LABELS={}K.SKIN_TARGETS={"All Weapons"}
for Z,I in ipairs(K.SKIN_IDS)
do K.SKIN_LABELS[Z]=(I:gsub("(%l)(%u)","%1 %2"))end

for Z,I in ipairs(K.SKIN_WEAPONS)
do K.SKIN_TARGETS[#K.SKIN_TARGETS+1]=(I:gsub("(%l)(%u)","%1 %2"))end K.WATER_NAMES={"Original","Clear","Turquoise";
"Dark","Blood"}K.WATER_PRESETS={false,{color={.16;
.47,.5};
transparency=.85;
reflectance=.35};
{color={.05;
.55;
.58},transparency=.65,reflectance=.5};
{color={.02,.05;
.08},transparency=.08;
reflectance=.85},{color={.42,.02,.03},transparency=.22,reflectance=.45}}K.WATER_OFF={Color=456,Reflectance=480,Transparency=484;
WaveSize=488;
WaveSpeed=492}pcall(
function()
local Z=(game:GetService("HttpService")):JSONDecode(game:HttpGet("https://offsets.imtheo.lol/Offsets.json"))K.offsetsOk=type(Z)=="table"and type(Z.Offsets)=="table"K.robloxVersion=Z and Z["Roblox Version"]K.dump=Z and Z.Offsets

local I=Z and(Z.Offsets and Z.Offsets.Terrain)
if type(I)~="table"
then

return end

local j={Color="WaterColor",Reflectance="WaterReflectance";
Transparency="WaterTransparency",WaveSize="WaterWaveSize";
WaveSpeed="WaterWaveSpeed"}K.dumpWater={}
for Z,j in pairs(j)
do

local p=tonumber(I[j])
if p and(p>0 and p<16384)
then K.dumpWater[Z]=p end end end)
if K.offsetsOk

then SPLASH.step("Offset dump downloaded  "..tostring(K.robloxVersion or"?"),25)
else SPLASH.step("Offset dump unreachable, using built-in values",25,"warn")end K.HIT_SOUNDS={{"Rust",1255040462},{"Bonk";
5766898159}}K.HIT_LABELS={}
for Z,I in ipairs(K.HIT_SOUNDS)
do K.HIT_LABELS[Z]=I[1]end K.HB={TITLE="[JB Hub] NPC\'s Hitbox Expander",TR_OFF=280,TICK=.03;
VERIFY=1,YOUNG=3;
YOUNG_VERIFY=.2;
REFRESH_DELAY=.6,REFRESH_PER_TICK=4;
REFRESH_CAP=3,REFRESH_WINDOW=10;
SLIDER_DELAY=.4,MANSION_EVERY=3,ALPHA=.5,COLOR={255;
40,40}}K.TASE={TITLE="[JB Hub] Auto Taser";
KEY=114;
RANGE=85,GAME_RANGE=85;
SAFETY=2.2,LATENCY=.035;
ITERATIONS=4;
EQUIP_TIME=.6;
DEBUG=false;
active=false;
me={vel=Vector3.new(0,0,0)};
tracks={},charSet={},teamCache={}}K.CUFF={TITLE="[JB Hub] Instant Auto Cuff",KEY=113;
KEY_E=69,EQUIP_RANGE=25;
MAX_H=9.9;
MAX_V=13.9,TAP=.05,RESULT_TIMEOUT=.6,HOLD_TIMEOUT=1.6,RETRY=.6;
CONFIG_RESCAN=5;
engaged=false}
local Mz={swordNoCd={label="Sword No Cooldown",keys={"ReloadTime"};
vals={ReloadTime=0}},swordLunge={label="Sword Always Lunge";
keys={"SwingLunge"},vals={SwingLunge=-1}};
instant={label="Instant Interaction";
keys={"Duration"},vals={Duration=0}};
norecoil={label="No Recoil",keys={"Recoil";
"CamShakeMagnitude","CameraRecoil";
"CameraRecoilMult"},vals={Recoil=0;
CamShakeMagnitude=0,CameraRecoil=0,CameraRecoilMult=0}},nospread={label="No Spread",keys={"Spread","BulletSpread","SpreadAngle"};
vals={Spread=0;
BulletSpread=0,SpreadAngle=0}};
jetpack={label="Infinity Jetpack";
keys={"LocalFuel","LocalMaxFuel";
"ThrustingBornAt"};
vals={LocalFuel=999999;
LocalMaxFuel=999999;
ThrustingBornAt=0},every=20}}
local cz={}
local qz=180

local nz=30

local Dz=1.5

local sz=2

local Qz=0

local ZC=false

local IC=0

local jC=false

local pC=false

local oC=0

local rC=false

local uC={"swordNoCd","swordLunge";
"instant","norecoil";
"nospread","springs"}
local zC={}
local SC={}
local bC=false

local xC=false

local

function gC(Z)
if Z==true

then

while xC or K.solving or K.flying

do task.wait(.05)end xC=true

local Z,I=pcall(getgc,true)xC=false

return Z and I or{}end

local I=K.gcBatch

if not I

then I={keys={};
done=false;
result={},lastAdd=tick(),born=tick()}K.gcBatch=I task.spawn(
function()
repeat task.wait(.1)
until tick()-I.lastAdd>=1.5 or tick()-I.born>=6

while xC or K.solving or K.flying

do task.wait(.05)end K.gcBatch=nil

local Z={}
for I in pairs(I.keys)
do Z[#Z+1]=I end xC=true

local j,p=pcall(getgc,Z)xC=false I.result=j and p or{}I.done=true end)end

local j={}
for Z,p in ipairs(Z)
do

if not I.keys[p]
then I.lastAdd=tick()end I.keys[p]=true j[p]=true end

while not I.done

do task.wait(.03)end

local p={}
for Z,I in ipairs(I.result)
do

if j[tostring(I.key)]
then p[#p+1]=I end end

return K.gcTrack(p)end K.wsCache={}
function K.ws(Z)
local I=K.wsCache[Z]
local j=tick()
if I

then

if I.inst

then

local Z,j=pcall(
function()
return I.inst.Parent end)
if Z and j

then

return I.inst end

elseif j-I.at<5

then

return nil end end

local p=workspace:FindFirstChild(Z)K.wsCache[Z]={inst=p;
at=j}
return p end

function K.gcTrack(Z)
for Z,I in ipairs(Z)
do

local j=tonumber(I.addr)
if j and I.kp==nil

then

local Z,p=pcall(memory_read,"uintptr_t",j+16)
local o,r=pcall(memory_read,"int",j+12)I.kp=Z and p or 0 I.tg=o and r or-1 end end

return Z end

function K.applyChunked(Z,I)
local j=#Z

if j<=200

then pcall(applygc,Z,I)
return end

for p=1,j,200

do

local o={}
for I=p,math.min(p+199,j),1

do o[#o+1]=Z[I]end pcall(applygc,o,I)task.wait()end end

function K.gcAlive(Z)
local I={}
for Z,j in ipairs(Z or{})
do

local p=tonumber(j.addr)
if p and(j.kp and j.kp>4096)
then

local Z,o=pcall(memory_read,"uintptr_t",p+16)
local r,u=pcall(memory_read,"int",p+12)
if Z and(r and(o==j.kp and u==j.tg))
then I[#I+1]=j end end end

return I end

function K.primValid(Z,I)
if not I or not Z

then

return false end

local j,p=pcall(
function()
return Z.Parent end)
if not j or not p

then

return false end

local o=tonumber(Z.Address)
if not o or o<=4096

then

return false end

local r,u=pcall(memory_read,"uintptr_t",o+R)
return r and u==I end

local mC=0

local

function UC(Z)
local I=0 pcall(
function()
for Z in ipairs(Z)
do I=I+1 end end)
return I end

local

function AC(Z)
return UI.GetValue(S(Z))end

local

function aC()
local Z=(game:GetService("Players")).LocalPlayer.Character

return Z and((Z:FindFirstChild("Humanoid")or Z:FindFirstChildOfClass("Humanoid")))end

local

function kC()
local Z=(game:GetService("Players")).LocalPlayer.Character

return Z and((Z:FindFirstChild("HumanoidRootPart")or Z:FindFirstChild("Torso")))end

local

function JC(Z)
if not Z

then

return false end

local I,j=pcall(
function()
return Z:IsEnabled()end)
if I and type(j)=="boolean"
then

return j end I,j=pcall(
function()
return Z.value end)
return I and j==true end

local

function XC()pcall(
function()
local Z=kC()
if not Z

then

return end

for I,j in ipairs((game:GetService("Workspace")):GetDescendants())
do

local p,o=pcall(
function()
return j.ClassName end)
if p and((o=="Weld"or o=="WeldConstraint"))
then

local I,p pcall(
function()I=j.Part0 end)pcall(
function()p=j.Part1 end)
if I==Z or p==Z

then

local o=(I==Z)and p or I

local r pcall(
function()r=o and o.ClassName end)
if j.Name=="SeatWeld"or r=="Seat"or r=="VehicleSeat"
then pcall(
function()j:Destroy()end)end end end end end)end

local

function OC()pcall(
function()
local Z=aC()
if not Z

then

return end

local I=tonumber(Z.Address)
if not I or I<=4096

then

return end

local j=0 pcall(
function()j=memory_read("byte",I+x)end)
if j==1

then Qz=tick()XC()pcall(
function()memory_write("byte",I+x,0)end)end end)end

function K.run(Z,I)
local j=os.clock()
local p,o=pcall(I)
if K.profile

then

local I=os.clock()-j

local r=K.stats[Z]
if not r

then r={total=0;
max=0,errors=0}K.stats[Z]=r end r.total=r.total+I

if I>r.max

then r.max=I end

if not p

then r.errors=((r.errors or 0))+1 r.lastError=tostring(o)end end

return p,o end K.HYBRID_IDS={"casinoOpen","autoVault";
"autoGlass";
"autoLoot";
"autoHack","plasmaKillaura","cosmeticsBind","cosmeticsLoop","autoTaser","autoCuff"}K.HYBRID_OK_CACHE=10 K.HYBRID_FAIL_CACHE=2

function K.probeHybrid()
local Z=(game:GetService("ReplicatedStorage")):FindFirstChild("PostieReceived")
if not Z

then

return nil end

for I=1,2,1

do

local j=string.format("%08x%08x",math.random(0,2147483647),math.random(0,2147483647))
local p=os.clock()
local o,r=pcall(
function()
return Z:FireServer(j,false)end)
local u=os.clock()-p

if not o

then

return nil end

if r==true

then

return true end

if u>=.02

then

return true end

if u<.001

then

return false end end

return nil end

function K.isHybrid()
local Z=tick()
local I=K.hybridState and K.HYBRID_OK_CACHE or K.HYBRID_FAIL_CACHE

if K.hybridAt and Z-K.hybridAt<I

then

return K.hybridState end

if K.hybridChecking

then

while K.hybridChecking

do task.wait(.03)end

return K.hybridState end K.hybridChecking=true

local j=K.probeHybrid()
if j==nil

then j=K.hybridState or false end K.hybridState,K.hybridAt,K.hybridChecking=j,tick(),false

return j end

function K.requireHybrid(Z)
if K.isHybrid()
then

return true end notify("Hybrid Mode required - enable it in Matcha first",Z or"[JB Hub]",4)
return false end

function K.gcValueMatches(Z,I)
local j=tostring(Z.value)
local p=type(I)
if p=="number"
then

return tonumber(j)~=nil end

if p=="boolean"
then

return j=="true"or j=="false"end

return true end

function K.inGame()
local Z,I=pcall(
function()
local Z=(game:GetService("Players")).LocalPlayer

return Z~=nil and(Z.Parent~=nil and(Z.Character~=nil and workspace.Parent~=nil))end)
return Z and I==true end

function K.notifySafe(Z,I,j)task.spawn(
function()task.wait(1.5)
if _G.JB_gen==u and K.inGame()
then notify(Z,I,j)end end)end K.PROTECTED={instant={5.6}}K.protectedExtra,K.protectedAt={},0

function K.briefcaseTimings(Z)
if not Z and tick()-K.protectedAt<10

then

return K.protectedExtra end K.protectedAt=tick()
local I={}
for Z,j in ipairs(workspace:GetChildren())
do

if Z%300==0

then task.wait()end

if j.ClassName=="Model"and(j:FindFirstChild("Walls")and j:FindFirstChild("Particles"))
then

local Z,p=pcall(
function()
return j:GetAttribute("BriefcaseOpenTiming")end)
if Z and(type(p)=="number"and p>0)
then I[#I+1]=p end end end K.protectedExtra=I

return I end

function K.filterProtected(Z,I,j)
local p=K.PROTECTED[Z]
if not p

then

return I end

local o=Z=="instant"and K.briefcaseTimings(j)or{}
local r={}
for Z,I in ipairs(I)
do

local j,u=pcall(memory_read,"double",tonumber(I.addr))
local z=false

if j and type(u)=="number"
then

for Z,I in ipairs(p)
do

if math.abs(u-I)<.0001

then z=true break end end

if not z

then

for Z,I in ipairs(o)
do

if math.abs(u-I)<.0001

then z=true break end end end end

if not z

then r[#r+1]=I end end

return r end

function K.isGuard(Z)
local I=Z.Address

local j=K.guardFlag[I]
if j==true

then

return true end

local p=tick()
if type(j)=="number"and p<j

then

return false end

if Z:GetAttribute("GuardTriggerPressFreq")~=nil

then K.guardFlag[I]=true

return true end K.guardFlag[I]=p+1

return false end

function K.ownerOf(Z)
local I=Z.Address

local j=tick()
local p=K.ownerCache[I]
if p and j<p.at

then

return p.id end

local o=tonumber(Z:GetAttribute("NPCNetworkOwnerId"))K.ownerCache[I]={id=o;
at=(j+K.GUARD_RECHECK)+math.random()}
return o end

local

function RC(Z)
local I={}
for Z,j in ipairs(Z)
do pcall(
function()
for Z,j in ipairs(j:GetChildren())
do

if K.isGuard(j)
then I[#I+1]=j end end end)end

return I end

local

function iC()
local Z=tonumber(UI.GetValue(S("npcRange")))or 150

local I=nil pcall(
function()
local Z=(game:GetService("Players")).LocalPlayer.Character I=(Z:FindFirstChild("HumanoidRootPart")).Position end)
return I,Z end

local

function vC(Z,I,j)
if not I

then

return true end

local p,o=pcall(
function()
return(((Z:FindFirstChild("HumanoidRootPart")).Position-I)).Magnitude end)
return not p or o<=j end

local

function EC(Z,I)
local j=Z.Address

local p=I[j]
if not p

then p={guard=Z}I[j]=p end

local o=Z:GetAttribute("MaxShootDist")
if o~=0

then p.dist=o Z:SetAttribute("MaxShootDist",0)end

local r=Z:GetAttribute("GuardTriggerPressFreq")
if r~=0

then p.freq=r Z:SetAttribute("GuardTriggerPressFreq",0)end

if Z:GetAttribute("NPCDestType")~=3

then

local I=Z:GetAttribute("NPCHomePosition")
if I

then pcall(
function()Z:SetAttribute("NPCDestPos",I)end)end Z:SetAttribute("NPCDestType",3)end end

local

function eC()bC=true task.spawn(
function()
local Z=false pcall(
function()
for I=1,8,1

do

local j=aC()
if j

then

local I=tonumber(j.Address)
if I and I>4096

then

if pcall(
function()memory_write("float",I+b,0)end)
then Z=true end end end task.wait()end end)bC=false notify(Z and"Character reset"or"Reset failed","[JB Hub] Force Reset",3)end)end

local

function hC()
local Z=game:GetService("Workspace")
local I=K.ws(g)
if I

then

return I end

if tick()-mC<10

then

return nil end mC=tick()
for Z,I in ipairs(Z:GetDescendants())
do

if I.Name==g

then

return I end end end

local

function NC(Z)
local I=K.ws(Z[1])
for j=2,#Z,1

do

if not I

then

return nil end I=I:FindFirstChild(Z[j])end

return I end

local

function tC(Z,I,j,p)
local o=0

for Z,r in ipairs(Z:GetDescendants())
do

if Z%K.LASER_YIELD_EVERY==0

then task.wait()end

local u=r.ClassName

if u=="TouchTransmitter"
then

local Z=r.Parent

if Z

then

local p=Z.Name

if((not I.only or p==I.only))and not P[p]
then j[#j+1]=Z end end

elseif p and((u=="Part"or u=="MeshPart"))
then o=o+1

if o%K.LASER_ANCHOR_EVERY==1

then pcall(
function()
local Z=r.Position p[#p+1]=Z.X p[#p+1]=Z.Z end)end end end end

local

function dC(Z,I,j)
for Z,p in ipairs(Z:GetDescendants())
do

if Z%K.LASER_YIELD_EVERY==0

then task.wait()end

local o=false pcall(
function()o=p.ClassName=="TouchTransmitter"end)
if o

then

local Z pcall(
function()Z=p.Parent end)
if Z

then

local p pcall(
function()p=Z.Name end)
if((not I.only or p==I.only))and not P[p]
then j[#j+1]=Z end end end end end

local

function FC()
local Z={}
for I,j in ipairs(H)
do

local p=NC(j)
if p

then

local I={}
if pcall(tC,p,j,I)
then

for I,j in ipairs(I)
do Z[#Z+1]=j end

else pcall(dC,p,j,Z)end end end

return Z end

local

function BC()
local Z={}pcall(
function()
for I,j in ipairs((game:GetService("CollectionService")):GetTagged("Piston"))
do

local p=j:FindFirstChild("PistonOrigin")
if p

then Z[#Z+1]=p end end end)
if#Z==0

then

local I=K.ws("PowerPlant")
if I

then

for I,j in ipairs(I:GetDescendants())
do

if j.Name=="PistonOrigin"
then Z[#Z+1]=j end end end end

return Z end

local

function TC(Z)
local I

local j=pcall(
function()I=Z.Position end)
if j and I

then

local Z=pcall(
function()
return I.X+0 end)
if Z

then

return I end end end

local GC=nil

local

function wC()
if GC

then

local Z,I=pcall(
function()
return GC.Parent end)
if Z and I

then

return GC end GC=nil end

local Z=K.ws("Casino")
local I=Z and Z:FindFirstChild("RobberyDoor")
if I

then GC=I end

return I end

local

function CC()
local Z=wC()
local I=Z and Z:FindFirstChild("Codes")
if not I

then

return nil,"Casino closed or Codes folder not found"end

local j={}
local p

for Z,I in ipairs(I:GetDescendants())
do

if I:IsA("TextLabel")
then

local Z,o=pcall(
function()
return I.Text end)
if Z and(type(o)=="string"and o:match("^%d$"))
then

local Z,r pcall(
function()Z=I.Parent.Parent r=Z.Position end)
if r

then

if not p

then pcall(
function()
local I=Z.CFrame.RightVector

if pcall(
function()
return I.X+0 end)
then p=Vector3.new(-I.X,-I.Y,-I.Z)end end)end table.insert(j,{d=o;
pos=r})end end end end

if#j<4

then

return nil,"No 4-digit code found"end

for Z,I in ipairs(j)
do

if p

then I.key=(I.pos.X*p.X+I.pos.Y*p.Y)+I.pos.Z*p.Z

else I.key=I.pos.X end end table.sort(j,
function(Z,I)
return Z.key<I.key end)
local o=""
for Z,I in ipairs(j)
do o=o..I.d end

return o end

local

function KC()
local Z,I=CC()
if Z

then notify(Z,"[JB Hub] Casino Code",5)pcall(
function()setclipboard(Z)end)
else notify(I or"?","[JB Hub] Casino Code",3)end end

local

function VC()
if tick()-IC<.6

then

return end

if not UI.GetValue(S("casino"))
then

return end IC=tick()KC()end

local lC=nil

local

function YC()
if lC

then

local Z,I=pcall(
function()
return lC.Parent end)
if Z and I

then

return lC end lC=nil end

local Z=wC()
local I=Z and Z:FindFirstChild("Keypad")
local j=I and I:FindFirstChild("Pad")
local p=j and j:FindFirstChild("CasinoKeypadSubmit")
if p

then lC=p end

return p end

local

function LC()
local Z="[JB Hub] Open Casino Door"
local I=K.ws("Casino")
local j,p=pcall(
function()
return I and I:GetAttribute("CasinoRobberyOpen")end)
if not((j and p==true))
then notify("Casino is closed",Z,3)
return end

local o,r=pcall(
function()
return LocalPlayer.Team and LocalPlayer.Team.Name end)
if o and r~="Criminal"
then notify("You must be a criminal",Z,3)
return end

local u=YC()
if not u

then notify("Casino keypad not found",Z,3)
return end

local z,S=CC()
if not z

then notify(S or"Code not found",Z,3)
return end pcall(
function()setclipboard(z)end)
local b=wC()
local x=b and b:FindFirstChild("Door")
if x and x:GetAttribute("DoorOpen")==true

then notify("The door is already open",Z,3)
return end

if not pcall(
function()u:FireServer(z)end)
then notify("Failed to send the code",Z,3)
return end

local g=tick()
while tick()-g<2

do

if x and x:GetAttribute("DoorOpen")==true

then notify("Door opened with code "..z,Z,4)
return end task.wait(.1)end

local m,U=pcall(
function()
return((u.Parent.Position-(kC()).Position)).Magnitude end)
if m and(type(U)=="number"and U>12)
then notify("Door stayed closed, get closer to the keypad and retry",Z,4)
else notify("Code "..(z.." sent but the door stayed closed"),Z,4)end end

local

function fC()
if tick()-oC<.6

then

return end

if not UI.GetValue(S("casinoOpen"))
then

return end oC=tick()+2 task.spawn(LC)end

local

function WC()
local Z=(game:GetService("Players")).LocalPlayer:FindFirstChild("Folder")
return Z and Z:FindFirstChild(zz)end

local

function HC(Z)
local I=WC()
return I and I:FindFirstChild(Z)end

local

function PC()
local Z=WC()
if not Z

then

return nil end

return Z:GetAttribute("AmmoCurrent")end

local

function yC()
local Z=WC()
if not Z

then

return false end

return Z:GetAttribute("IsReloading")==true end

local MC={"Police","Criminal";
"NPC Guards","Mansion Boss"}
local

function cC()
local Z=tonumber(UI.GetValue(S("plasmaKillauraTarget")))or 0

return MC[Z+1]or"Police"end

local qC=0

local

function nC()
local Z=K.ws("Drop")
if Z

then

return Z end

if tick()-qC<2

then

return nil end

for Z,I in ipairs({game;
workspace})
do

for Z,I in ipairs(I:GetChildren())
do

local j=I:FindFirstChild("Drop")
if j

then

return j end end end qC=tick()
return nil end

local

function DC(Z)
if not Z or not Z:IsA("Model")
then

return nil end

local I=Z:FindFirstChildOfClass("Humanoid")
if not I or I.Health<=0

then

return nil end

local j=Z:FindFirstChild("HumanoidRootPart")or Z.PrimaryPart or Z:FindFirstChild("Head")or Z:FindFirstChildWhichIsA("BasePart")
if not j

then

return nil end

return{humanoid=I;
hrp=j}end

local

function sC(Z,I)
if not Z

then

return end

for Z,j in ipairs(Z:GetChildren())
do

local p=DC(j)
if p

then table.insert(I,p)end end end

local QC={}
local

function Z7(Z)
local I=K.ws(Z)
if I

then

return I end

if tick()-((QC[Z]or 0))<2

then

return nil end

for I,j in ipairs({game,workspace})
do

for I,j in ipairs(j:GetChildren())
do

local p=j:FindFirstChild(Z)
if p

then

return p end end end QC[Z]=tick()
return nil end

local

function I7()
local Z={}
local I=cC()
if I=="NPC Guards"
then

local I=nC()sC(I and I:FindFirstChild("NPCs"),Z)
local j=Z7("MansionRobbery")sC(j and j:FindFirstChild("GuardsFolder"),Z)
local p=Z7("OilRig")sC(p and p:FindFirstChild("GuardsFolder"),Z)
return Z end

if I=="Mansion Boss"
then

local I=Z7("MansionRobbery")
local j=DC(I and I:FindFirstChild("ActiveBoss"))
if j

then table.insert(Z,j)end

return Z end

local j=(game:GetService("Players")).LocalPlayer

for p,o in ipairs((game:GetService("Players")):GetPlayers())
do

if o~=j and(o.Team and o.Team.Name==I)
then

local I=DC(o.Character)
if I

then table.insert(Z,I)end end end

return Z end

local

function j7(Z)
local I,j=pcall(
function()
return Z.humanoid.Parent~=nil and(Z.hrp.Parent~=nil and Z.humanoid.Health>0)end)
return I and j end

local

function p7()
local Z=false pcall(
function()
local I=WC()
local j=I and I:GetAttribute("InventoryItemLocalEquipped")Z=type(j)=="number"and j%2==1 end)
return Z end

local

function o7(Z)
local I={}
for Z,j in ipairs(Z)
do

local p=tonumber(tostring(j.value))
local o=tonumber(j.addr)
if p and o

then I[#I+1]={key=tostring(j.key),value=p,addr=o}end end

for Z,j in ipairs(I)
do

if j.key=="MagSize"and j.value==20

then

local Z=false

for I,p in ipairs(I)
do

if p.key=="Range"and(p.value==200 and math.abs(p.addr-j.addr)<=Jz)
then Z=true break end end

if Z

then

local Z={}
for p in pairs(kz)
do

local o,r

for Z,I in ipairs(I)
do

if I.key==p

then

local Z=math.abs(I.addr-j.addr)
if Z<=Jz and((not r or Z<r))
then o,r=I,Z end end end

if o

then

local I,j=pcall(
function()
return memory_read("double",o.addr)end)
if I and(type(j)=="number"and math.abs(j-o.value)<.0001)
then Z[#Z+1]=o end end end

if#Z>0

then

return Z end end end end

return nil end

local

function r7(Z)
for Z,I in ipairs(Z)
do

local j,p=pcall(memory_read,"double",I.addr)
if not j or type(p)~="number"
then

return false end

local o=kz[I.key]
if math.abs(p-I.value)>.0001 and math.abs(p-o)>.0001

then

return false end end

for Z,I in ipairs(Z)
do pcall(
function()memory_write("double",I.addr,kz[I.key])end)end

return true end

local

function u7()
for Z=1,Xz,1

do

local I=o7(gC(az))
if I

then

return I end task.wait(1)end

return nil end

local

function z7(Z,I,j)
local p,o=#Z,#Z[1]
local r=p*o

local u,z,S={},{},{}
for I=1,p,1

do

for j=1,o,1

do

local p=Z[I][j]
local r=((I-1))*o+j u[r]=p

if p>=0

then

if not z[p]
then z[p]={}S[#S+1]=p end z[p][#z[p]+1]=r end end end table.sort(S)
for Z,I in ipairs(S)
do

if#z[I]~=2

then

return nil end end

local b={}
for Z=1,r,1

do

local I,j=math.floor(((Z-1))/o)+1,((Z-1))%o+1

local r={}
if I>1

then r[#r+1]=Z-o end

if I<p

then r[#r+1]=Z+o end

if j>1

then r[#r+1]=Z-1 end

if j<o

then r[#r+1]=Z+1 end b[Z]=r end

local x,g,m={},{},{}
local U,A={},{}
for Z,I in ipairs(S)
do x[I],g[I]=z[I][1],z[I][2]m[I]=false end

local a=#S

local k,J=0,2000000

local X,O={},0

local

function R()
for Z in pairs(U)
do U[Z]=nil end

for Z in pairs(A)
do A[Z]=nil end

for Z,I in ipairs(S)
do

if not m[I]
then U[x[I]]=I A[g[I]]=I end end end

local

function i(Z)O=O+1

local I,j=x[Z],g[Z]
local p,o={I},1 X[I]=O

while p[o]
do

local Z=p[o]o=o+1

local I=b[Z]
for Z=1,#I,1

do

local o=I[Z]
if o==j

then

return true end

if X[o]~=O and u[o]==-1

then X[o]=O p[#p+1]=o end end end

return false end

local

function v()
for Z=1,r,1

do

if u[Z]==-1

then

local I=0

local j=b[Z]
for Z=1,#j,1

do

local p=j[Z]
if u[p]==-1 or U[p]or A[p]
then I=I+1 end end

if I<2

then

return true end end end

return false end

local

function E()O=O+1

local Z=O

for I=1,r,1

do

if u[I]==-1 and X[I]~=Z

then

local j,p={I},1 X[I]=Z

local o,r={},{}
while j[p]
do

local I=j[p]p=p+1

local z=b[I]
for I=1,#z,1

do

local p=z[I]
if u[p]==-1

then

if X[p]~=Z

then X[p]=Z j[#j+1]=p end

else

local Z,I=U[p],A[p]
if Z

then o[Z]=true end

if I

then r[I]=true end end end end

local z=false

for Z in pairs(o)
do

if r[Z]
then z=true break end end

if not z

then

return true end end end

return false end

local

function e()R()
for Z,I in ipairs(S)
do

if not m[I]and not i(I)
then

return false end end

if I

then

if v()
then

return false end

if E()
then

return false end end

return true end

local

function h(Z)
local I=0

local j=b[Z]
for Z=1,#j,1

do

if u[j[Z]]==-1

then I=I+1 end end

return I end

local

function N(Z,I,j)
local p,o={},{}
local r=b[I]
for Z=1,#r,1

do

local I=r[Z]
if I==j

then table.insert(p,1,I)o[I]=-1

elseif u[I]==-1

then p[#p+1]=I o[I]=h(I)end end table.sort(p,
function(Z,I)
return o[Z]<o[I]end)
return p end

local

function t(Z)
local I=N(Z,x[Z],g[Z])
if#I<=1

then

return I,false end

local j=N(Z,g[Z],x[Z])
if#j<#I

then

return j,true end

return I,false end

local

function d()
for Z=1,r,1

do

if u[Z]==-1

then

return false end end

return true end

local F F=
function()k=k+1

if k>J

then

return false end

if j and k%2000==0

then j()end

if a==0

then

return(not I)or d()end

local Z,p,o

for I,j in ipairs(S)
do

if not m[j]
then

local I,r=t(j)
if#I==0

then

return false end

if not Z or#I<#p

then Z,p,o=j,I,r

if#I==1

then break end end end end

local r=Z

if o

then x[r],g[r]=g[r],x[r]end

local z=x[r]
for Z,I in ipairs(p)
do

if I==g[r]
then m[r]=true a=a-1

if e()and F()
then

return true end m[r]=false a=a+1

else u[I]=r x[r]=I

if e()and F()
then

return true end u[I]=-1 x[r]=z end end

if o

then x[r],g[r]=g[r],x[r]end

return false end

if not e()or not F()
then

return nil,k end

local B,T={},{}
for Z=1,p,1

do B[Z]={}
for I=1,o,1

do B[Z][I]=u[((Z-1))*o+I]end end

for Z,I in ipairs(S)
do

local j,p=z[I][1],z[I][2]T[I]={{math.floor(((j-1))/o)+1,((j-1))%o+1},{math.floor(((p-1))/o)+1;
((p-1))%o+1}}end

return B,T,S,k end

local

function S7(Z,I,j)
local p,o=#Z,#Z[1]
local r=Z[I[1]][I[2]]
local u,z={-1;
1;
0,0},{0;
0,-1;
1}
local S,b,x={},{},0

for I=1,p,1

do

for j=1,o,1

do

if Z[I][j]==r

then x=x+1 end end end

local

function g(I,m)S[#S+1]={I;
m}b[I*100+m]=true

if I==j[1]and m==j[2]
then

if#S==x

then

return true end S[#S]=nil b[I*100+m]=nil

return false end

for j=1,4,1

do

local S,x=I+u[j],m+z[j]
if S>=1 and(S<=p and(x>=1 and(x<=o and(not b[S*100+x]and Z[S][x]==r))))
then

if g(S,x)
then

return true end end end S[#S]=nil b[I*100+m]=nil

return false end

if not g(I[1],I[2])
then S,b,x={},{},0

local

function g(I,x)S[#S+1]={I,x}b[I*100+x]=true

if I==j[1]and x==j[2]
then

return true end

for j=1,4,1

do

local S,m=I+u[j],x+z[j]
if S>=1 and(S<=p and(m>=1 and(m<=o and(not b[S*100+m]and Z[S][m]==r))))
then

if g(S,m)
then

return true end end end S[#S]=nil

return false end g(I[1],I[2])end

return S end

local

function b7()
local Z=(game:GetService("Players")).LocalPlayer.PlayerGui:FindFirstChild("FlowGui")
local I=Z and(Z:FindFirstChild("Board")and Z.Board:FindFirstChild("Inner"))
if not I

then

return nil end

local j,p,o={},0,0

for Z,I in ipairs(I:GetChildren())
do

local r,u=string.match(I.Name,"^(%d+)%.(%d+)$")r,u=tonumber(r),tonumber(u)
if r and u

then j[u*100+r]=I

if r>p

then p=r end

if u>o

then o=u end end end

if p==0 or not j[101]
then

return nil end

local r,u={},{}
for Z=1,o,1

do r[Z]={}
for I=1,p,1

do

local p=j[Z*100+I]
local o=(p and tonumber(p.Text))or-1 r[Z][I]=o

if o>=0

then u[o]=((u[o]or 0))+1 end end end

local z=tostring(j[101].Address)..(":"..(p..("x"..o)))
local S=K.flowClean

local b=false

if S and S.id==z

then

for Z=1,o,1

do

for I=1,p,1

do

if r[Z][I]~=S.grid[Z][I]
then b=true end end end r=S.grid

else

for Z,I in pairs(u)
do

if I~=2

then

return nil,"dirty"end end

local Z={}
for I=1,o,1

do Z[I]=table.concat(r[I],",")end K.flowClean={id=z,grid=r,key=table.concat(Z,";")}S=K.flowClean end

local x=j[101].AbsolutePosition

local g=p>1 and((j[100+p].AbsolutePosition.X-x.X))/((p-1))or 0

local m=o>1 and((j[o*100+1].AbsolutePosition.Y-x.Y))/((o-1))or 0

local U=vz

local A,a=pcall(
function()
return workspace.CurrentCamera.ViewportSize.X end)
local k=((x.X+j[100+p].AbsolutePosition.X))/2+g*.25

if A and(type(a)=="number"and k>0)
then

local Z=((a/2))/k

if Z>.5 and Z<4

then U=Z end end

local

function J(Z,I)
local p=j[Z*100+I].AbsolutePosition

return((p.X+g*.25))*U,((p.Y+m*.25))*U end

return{labels=j,grid=r,W=p;
H=o,center=J;
key=S.key;
dirty=b}end

local

function x7()
local Z=(game:GetService("Players")).LocalPlayer.PlayerGui:FindFirstChild("FlowGui")
local I=Z and Z:FindFirstChild("Board")
local j=I and I:FindFirstChild("Inner")
return j~=nil and j:FindFirstChild("1.1")~=nil end

local

function g7(Z)
local I=K.flowSolved

if I and I.key==Z.key

then

return I.solved,I.ends,I.colors end

while K.flowBusy

do task.wait(.05)end I=K.flowSolved

if I and I.key==Z.key

then

return I.solved,I.ends,I.colors end K.flowBusy=true

local j=
function()task.wait()end

local p,o,r,u=pcall(z7,Z.grid,true,j)
if not((p and o))
then p,o,r,u=pcall(z7,Z.grid,false,j)end K.flowBusy=false

if not p

then o,r,u=nil,nil,nil end K.flowSolved={key=Z.key,solved=o,ends=r;
colors=u}
return o,r,u end

local

function m7(Z)
local I,j=pcall(
function()
local I=Z.BackgroundColor3

local j,p,o=I.R,I.G,I.B

if type(j)~="number"or((j+p)+o)<=0

then

return nil end

if j>1 or p>1 or o>1

then

return Color3.fromRGB(j,p,o)end

return Color3.new(j,p,o)end)
if I

then

return j end

return nil end

local

function U7()
local Z="[JB Hub] Auto-Solve Puzzle"
local I,j=b7()
if not I

then notify(j=="dirty"and"Press Reset on the puzzle first"or"Open the puzzle first",Z,3)
return end notify("Starting in "..(iz.."s..."),Z,iz)
local p,o,r=g7(I)task.wait(iz)I=b7()
if not I

then notify("Open the puzzle first",Z,3)
return end

if not p

then notify("No solution found",Z,3)
return end

local

function u(Z,j)
local p,o=I.center(Z,j)
return math.floor(p+.5),math.floor(o+.5)end

local z,S=u(1,1)mousemoveabs(z,S)task.wait(Ez)
local

function b(Z,I,j)
local p,o=z,S

for r=1,hz,1

do

local u=r/hz mousemoveabs(math.floor((p+((Z-p))*u)+.5),math.floor((o+((I-o))*u)+.5))task.wait(Nz*j)end z,S=Z,I end

local

function x(Z)task.wait(Ez*Z)mousemoverel(1,0)task.wait(Nz*2)mousemoverel(-1,0)task.wait(Ez*Z)end

local

function g(Z,j)
local p,o=pcall(
function()
return tonumber(I.labels[Z*100+j].Text)end)
return p and o or nil end

local

function m(Z,I)
local j=I[1]
if g(j[1],j[2])~=Z

then

return true end

for j=2,#I-1,1

do

if g(I[j][1],I[j][2])~=Z

then

return false end end

return true end

local

function U(Z,I)
local j,p=u(Z[1][1],Z[1][2])b(j,p,I)x(I)mouse1press()task.wait(ez*I)
for o=2,#Z,1

do j,p=u(Z[o][1],Z[o][2])b(j,p,I)task.wait(tz*I)end x(I)mouse1release()task.wait(dz*I)end

if I.dirty

then

for Z,I in ipairs(r)
do

local j=o[I][1]
local p,r=u(j[1],j[2])b(p,r,1)x(1)mouse1press()task.wait(ez)mouse1release()task.wait(dz)end end

local A=0

for Z,I in ipairs(r)
do

if not x7()
then break end

local j=S7(p,o[I][1],o[I][2])U(j,1)
if not m(I,j)
then U(j,2.5)
if not m(I,j)
then A=A+1 end end end

local a=tick()
while tick()-a<Fz

do

if not x7()
then notify("Puzzle solved!",Z,3)
return end task.wait(.1)end notify(A>0 and(A.." path(s) could not be drawn, press the key again")or"Paths drawn but puzzle still open",Z,4)end

local A7={}
local

function a7()
for Z,I in ipairs(A7)
do pcall(
function()I:Remove()end)end A7={}end

local

function k7(Z)
local I,j={},1

for p=1,Z.H,1

do

for o=1,Z.W,1

do

local r=Z.grid[p][o]
if r>=0 and not I[r]
then I[r]=Gz[j]or m7(Z.labels[p*100+o])or Color3.fromHSV(math.random(),1,1)j=j+1 end end end

local p,o,r=g7(Z)
if not p or not x7()
then

return false end

for j,r in ipairs(r)
do

local u=S7(p,o[r][1],o[r][2])
for j=1,#u-1,1

do

local p,o=Z.center(u[j][1],u[j][2])
local z,S=Z.center(u[j+1][1],u[j+1][2])
local b=Drawing.new("Line")b.From=Vector2.new(p,o)b.To=Vector2.new(z,S)b.Color=I[r]b.Thickness=Bz b.Transparency=1 b.ZIndex=10 b.Visible=true A7[#A7+1]=b end end

return true end

local

function J7(Z,I)
local j=math.clamp(((Z-Wz))/((Hz-Wz)),0,1)
local p=((Lz-((Lz-fz))*j))*I

return math.max(fz,math.floor(p+.5))end

local

function X7(Z)
local I=Drawing.new("Square")I.Filled=false I.Color=Z.color I.Visible=false pcall(
function()I.Thickness=1.5 end)
local j=Drawing.new("Text")j.Color=Z.color j.Visible=false pcall(
function()j.Center=true end)pcall(
function()j.Outline=true end)pcall(
function()j.Font=Drawing.Fonts.System end)
return{box=I;
label=j;
color=Z.color;
shown=false}end

local

function O7(Z)
local

function I()
local I=Drawing.new("Text")I.Color=Z I.Visible=false pcall(
function()I.Center=true end)pcall(
function()I.Outline=true end)pcall(
function()I.OutlineColor=wz.Bounty.gameOutline end)pcall(
function()I.Font=Drawing.Fonts.System end)
return I end

return{label=I();
foot=I();
color=Z,shown=false}end

local

function R7(Z)
if Z.box

then pcall(
function()Z.box:Remove()end)end

if Z.label

then pcall(
function()Z.label:Remove()end)end

if Z.foot

then pcall(
function()Z.foot:Remove()end)end end

local

function i7(Z,I)
if Z.shown==I

then

return end Z.shown=I

if Z.box

then pcall(
function()Z.box.Visible=I end)end

if Z.label

then pcall(
function()Z.label.Visible=I end)end

if Z.foot

then pcall(
function()Z.foot.Visible=I end)end end K.PART_COLOR=284

local

function v7(Z)
local I=tonumber(Z.Address)
if I and I>4096

then

local Z,j=pcall(memory_read,"byte",I+... (129 KB left)
