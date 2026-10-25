--[[
	VØX Script  beta  —  LocalScript
	المكان: StarterPlayer > StarterPlayerScripts > LocalScript
]]

local CONFIG = {
	CustomFolder = nil,
	Keywords = {"ضب","ضبان","dhab","dhaban","lizard","سحلي"},
	ExcludeGroups = {
		Vehicles={"car","vehicle","truck","jeep","suv","bike","boat","heli","plane","wheel","seat","سيارة","سيارات","عربية","دباب"},
		Weapons={"gun","rifle","weapon","pistol","sniper","shotgun","smg","ammo","knife","sword","tool","bullet","turret","سلاح","اسلحة","أسلحة","بندقية","مسدس"},
		Structures={"trap","cage","shop","tank","antenna","rock","shell"},
	},
	IgnoreList = {"dhabcabshell","dhabezbashop","dhabcage","dhabwatertank","dhabantenna","dhabrock"},
	RarityAttributes = {"rarity","Rarity","tier","Tier","ندرة"},
	RarityOrder = {"Common","Uncommon","Rare","Epic","Legendary","Mythic","Secret"},
	RarityColors = {
		Common=Color3.fromRGB(255,255,255), Uncommon=Color3.fromRGB(60,220,90),
		Rare=Color3.fromRGB(60,140,255), Epic=Color3.fromRGB(170,80,255),
		Legendary=Color3.fromRGB(255,150,30), Mythic=Color3.fromRGB(255,50,50),
		Secret=Color3.fromRGB(255,100,200),
	},
	RarityAr = {Common="عادي",Uncommon="غير شائع",Rare="نادر",Epic="ملحمي",Legendary="أسطوري",Mythic="خرافي",Secret="سري"},
	ScanInterval = 20,
	UpdateInterval = 0.5,
	AlertSound = "rbxassetid://4590657391",
	Key = "vox4urtz", -- مفتاح التفعيل
	KeyFile = "3z_key.txt",
}

local S = {
	ESP=false, Fill=true, Outline=true, AlwaysOnTop=true, FillT=0.6, OutlineT=0,
	ShowName=true, ShowRarity=true, ShowDist=true, ShowHealth=false,
	TextSize=14, LabelHeight=3, MaxDist=1500, Tracers=false, TracerFrom="Bottom",
	Rarities={},
	Aim=false, AimMode="Hold", AimActive=false, Priority="Screen",
	FOV=150, ShowFOV=true, FOVColor=1, FOVThick=2, FOVTrans=0.3, FOVFilled=false,
	Strength=0.6, Smooth=0.3, AimDist=600, AimPart="Root", WallCheck=false,
	StickyTarget=true, AimRarities={}, ShowTargetInfo=true,
	FlySpeed=60, FlyStopDist=4, FlySafe=true, FlyActive=false,
	Notify=false, NotifyMin="Legendary", FlyMode="CFrame",
	Lang="ar", UIScale=1, UITrans=0, Accent=1, ToggleKey=Enum.KeyCode.RightShift,
	_fps=0, _ping=0,
	FlyCurve=false, FlyThroughWalls=false, FlyAvoid=true, FlySmooth=0.25, FlyArc=0.25, HUD=false,
	Prediction=true, PredTime=0.12, AutoFire=false, AutoFireAngle=2.5, Hysteresis=0.25,
	Chams=false, ChamsT=0.35, HealthBar=true, DistFade=true, OffScreen=true, Box=false,
	Theme="Light", Sort="Distance", ListTab="All", Search="",
	SoundAlert=true, Watermark=false,
	AutoFly=false, AntiAFK=false, Fullbright=false,
	ExVehicles=true, ExWeapons=true, ExStructures=true,
	FlyUpKey=Enum.KeyCode.Space, FlyDownKey=Enum.KeyCode.LeftShift, FlyFwdKey=Enum.KeyCode.W, FlyBackKey=Enum.KeyCode.S,
	FlyLeftKey=Enum.KeyCode.A, FlyRightKey=Enum.KeyCode.D, FlySprintKey=Enum.KeyCode.LeftControl, FlySprint=2.5, FlyVertMul=1,
	FlyDirMode="Camera", FlyPad=true, VehMode="Velocity", NoFog=false, FPSBoost=false, FPSExtreme=false, UnlockFPS=false,
	Lite=true, VehFace=true, Gravity=196, CamFOV=70, ClockTime=14, MaxZoom=128, InstantPrompt=false, AutoPrompt=false, ExtraGrav=false, ExtraFOV=false, ExtraTime=false, ExtraZoom=false, AutoFood=false, AutoWater=false, AutoThresh=50, VehFly=false, PadSize=1, VehFlySpeed=120, VehBoost=false, VehBoostSpeed=150,
	WallPierce=true, AmmoMode="Infinite", InfAmmo=false, AmmoValue=999, AmmoDeep=false, FastShot=false, FastRate=10, FastAlways=false, NoCooldown=false, SilentAim=false, MagicBullet=false, SilentFOV=200, SilentChance=100, MagicRange=20000, ShowSilentFOV=true,
	WalkSpeedOn=false, WalkSpeed=80, JumpOn=false, JumpPower=70, InfJump=false, Noclip=false, FreeFly=false, FreeFlySpeed=80,
	Radar=false, RadarRange=300, RadarSize=150, RadarRotate=true,
	AimKey=Enum.KeyCode.Unknown, FlyKey=Enum.KeyCode.Unknown, StopKey=Enum.KeyCode.Unknown,
}
for _,r in ipairs(CONFIG.RarityOrder) do S.Rarities[r]=true; S.AimRarities[r]=true end

local DEF = {}
for k,v in pairs(S) do if type(v)~="table" then DEF[k]=v end end

local OPTS = {
	AmmoMode={"Infinite","99999"},
	AmmoMode={"Infinite","99999"},
	AimMode={"Hold","Toggle","Always"}, Priority={"Screen","Closest","Rarity"}, AimPart={"Root","Head","Center"},
	TracerFrom={"Bottom","Center","Top"}, Sort={"Distance","Rarity","Name"}, Theme={"Dark","Light"},
	Lang={"ar","en"}, FlyMode={"CFrame","Velocity"}, FlyDirMode={"Camera","Flat"}, VehMode={"Velocity","CFrame"}, NotifyMin=CONFIG.RarityOrder, ListTab={"All",table.unpack(CONFIG.RarityOrder)},
}

local ACCENTS = {
	{name="Blue",c=Color3.fromRGB(35,105,255)}, {name="Rose",c=Color3.fromRGB(255,90,140)},
	{name="Cyan",c=Color3.fromRGB(50,205,240)}, {name="Emerald",c=Color3.fromRGB(70,225,130)},
	{name="Sky",c=Color3.fromRGB(85,145,255)}, {name="White",c=Color3.fromRGB(240,240,250)},
}

local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local HttpService=game:GetService("HttpService")
local TeleportService=game:GetService("TeleportService")
local StatsSvc=game:GetService("Stats")
local LP=Players.LocalPlayer
local Cam=workspace.CurrentCamera
local IsMobile=UIS.TouchEnabled and not UIS.KeyboardEnabled
local Lighting=game:GetService("Lighting")
local lightOrig
local function applyFB()
	if S.Fullbright then
		if not lightOrig then
			lightOrig={Brightness=Lighting.Brightness,ClockTime=Lighting.ClockTime,GlobalShadows=Lighting.GlobalShadows,Ambient=Lighting.Ambient,FogEnd=Lighting.FogEnd}
		end
		Lighting.Brightness=2; Lighting.ClockTime=14; Lighting.GlobalShadows=false
		Lighting.Ambient=Color3.fromRGB(190,190,190); Lighting.FogEnd=1e6
	elseif lightOrig then
		for k,v in pairs(lightOrig) do pcall(function() Lighting[k]=v end) end
		lightOrig=nil
	end
end
local U = {log={},logVer=0}
do
local fogOrig
U.applyFog=function()
	if S.NoFog then
		fogOrig=fogOrig or {FogEnd=Lighting.FogEnd,FogStart=Lighting.FogStart,atm={}}
		Lighting.FogEnd=1e9; Lighting.FogStart=1e9
		for _,a in ipairs(Lighting:GetChildren()) do
			if a:IsA("Atmosphere") then
				if not fogOrig.atm[a] then fogOrig.atm[a]={Density=a.Density,Haze=a.Haze} end
				a.Density=0; a.Haze=0
			end
		end
	elseif fogOrig then
		pcall(function() Lighting.FogEnd=fogOrig.FogEnd; Lighting.FogStart=fogOrig.FogStart end)
		for a,v in pairs(fogOrig.atm) do if a.Parent then a.Density=v.Density; a.Haze=v.Haze end end
		fogOrig=nil
	end
end
local fpsSaved
local fpsBusy=false
local function isEmitter(d)
	return d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Beam") or d:IsA("Smoke") or d:IsA("Fire") or d:IsA("Sparkles")
end
local function weakT() return setmetatable({},{__mode="k"}) end
U.applyFPS=function()
	if fpsBusy then return end
	fpsBusy=true
	if S.FPSBoost then
		fpsSaved=fpsSaved or {fx=weakT(),em=weakT(),mat=weakT(),dec=weakT(),sh=Lighting.GlobalShadows}
		Lighting.GlobalShadows=false
		for _,e in ipairs(Lighting:GetChildren()) do
			if e:IsA("PostEffect") then
				if fpsSaved.fx[e]==nil then fpsSaved.fx[e]=e.Enabled end
				e.Enabled=false
			end
		end
		pcall(function() local t=workspace.Terrain; t.WaterWaveSize=0; t.WaterReflectance=0 end)
		pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level01 end)
		if not S.FPSExtreme then
			for p,v in pairs(fpsSaved.mat) do if p.Parent then p.Material=v[1]; p.Reflectance=v[2] end; fpsSaved.mat[p]=nil end
			for d,v in pairs(fpsSaved.dec) do if d.Parent then d.Transparency=v end; fpsSaved.dec[d]=nil end
		end
		local n=0
		local ch=LP.Character
		for _,d in ipairs(workspace:GetDescendants()) do
			n+=1; if n%400==0 then task.wait() end
			if isEmitter(d) then
				if fpsSaved.em[d]==nil then fpsSaved.em[d]=d.Enabled end
				d.Enabled=false
			elseif S.FPSExtreme then
				if d:IsA("BasePart") and not d:IsA("Terrain") and not (ch and d:IsDescendantOf(ch)) then
					if fpsSaved.mat[d]==nil then fpsSaved.mat[d]={d.Material,d.Reflectance} end
					d.Material=Enum.Material.SmoothPlastic; d.Reflectance=0
				elseif d:IsA("Decal") or d:IsA("Texture") then
					if fpsSaved.dec[d]==nil then fpsSaved.dec[d]=d.Transparency end
					d.Transparency=1
				end
			end
		end
	elseif fpsSaved then
		Lighting.GlobalShadows=fpsSaved.sh
		for e,v in pairs(fpsSaved.fx) do if e.Parent then e.Enabled=v end end
		for d,v in pairs(fpsSaved.em) do if d.Parent then d.Enabled=v end end
		for p,v in pairs(fpsSaved.mat) do if p.Parent then p.Material=v[1]; p.Reflectance=v[2] end end
		for d,v in pairs(fpsSaved.dec) do if d.Parent then d.Transparency=v end end
		fpsSaved=nil
	end
	fpsBusy=false
end
workspace.DescendantAdded:Connect(function(d)
	if d:IsA("ProximityPrompt") then U.prompts[d]=true end
	if S.FPSBoost and fpsSaved and isEmitter(d) then pcall(function() fpsSaved.em[d]=d.Enabled; d.Enabled=false end) end
end)
end

LP.Idled:Connect(function()
	if not S.AntiAFK then return end
	pcall(function()
		local vu=game:GetService("VirtualUser")
		vu:CaptureController(); vu:ClickButton2(Vector2.new())
	end)
end)

local function L(t) if type(t)=="table" then return t[S.Lang] or t.en end return t end
local function RName(r) return S.Lang=="ar" and CONFIG.RarityAr[r] or r end
local function ACC() return ACCENTS[S.Accent].c end
local function lerp(a,b,t) return a+(b-a)*t end

--==================== أدوات مساعدة ====================
local lastClick = {}
function U.debounce(k)
	local n=os.clock()
	if lastClick[k] and n-lastClick[k]<0.2 then return false end
	lastClick[k]=n; return true
end
function U.setp(d,o,k,v)
	local c=d.c[o]; if not c then c={}; d.c[o]=c end
	if c[k]~=v then c[k]=v; pcall(function() o[k]=v end) end
end
function U.bez(a,b,c,t) local u=1-t; return a*(u*u)+b*(2*u*t)+c*(t*t) end
function U.getPing()
	local ok,v=pcall(function() return StatsSvc.Network.ServerStatsItem["Data Ping"]:GetValue() end)
	if ok and v then return math.floor(v) end
	local ok2,p=pcall(function() return LP:GetNetworkPing() end)
	if ok2 and p then return math.floor(p*1000) end
	return 0
end

--==================== نظام المفتاح (Key System) ====================
do
	local WHITE=Color3.fromRGB(18,24,56)
	local SUBC=Color3.fromRGB(150,158,188)
	local GOLD=ACCENTS[1].c
	local DARK=Color3.new(1,1,1)
	local RED=Color3.fromRGB(255,95,105)
	local GREEN=Color3.fromRGB(80,235,150)
	local IDLE=Color3.fromRGB(64,70,100)
	local CARD=Color3.fromRGB(22,25,38)
	local FIELD=Color3.fromRGB(32,36,54)
	local function norm(x) return string.lower((string.gsub(tostring(x or ""),"%s+",""))) end
	local SECRET="vox-s3cr3t-q7Lm29x"
	local function h32(str,seed)
		local h=seed
		for i=1,#str do h=(h*33+string.byte(str,i)+i*7)%4294967291 end
		return h
	end
	local function signedOK(x)
		local e,n,sg=string.match(string.upper(tostring(x)),"^VOX%-(%w+)%-(%w+)%-(%w+)$")
		if not e then return false end
		local msg=e.."-"..n
		local want=string.upper(string.format("%08x%08x",h32(msg,5381),h32(SECRET..msg,52711))):sub(1,10)
		if sg~=want then return false end
		local exp=tonumber(e,36)
		if not exp then return false end
		if exp==0 then return true end
		return os.time()/60<exp
	end
	local function isValid(x) return norm(x)==norm(CONFIG.Key) or signedOK(x) end
	local function tr(ar,en) return S.Lang=="ar" and ar or en end
	local passed,aborted=true,false
	pcall(function()
		if typeof(isfile)=="function" and typeof(readfile)=="function" and isfile(CONFIG.KeyFile) and isValid(readfile(CONFIG.KeyFile)) then passed=true end
	end)
	local function mk(cls,props,parent)
		local o=Instance.new(cls)
		if o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox") then o.TextStrokeTransparency=1 end
		for k,v in pairs(props or {}) do o[k]=v end
		o.Parent=parent; return o
	end
	local function rc(o,r) mk("UICorner",{CornerRadius=UDim.new(0,r)},o) end
	local function tw(o,p,t,style) pcall(function() TweenService:Create(o,TweenInfo.new(t or 0.25,style or Enum.EasingStyle.Quint,Enum.EasingDirection.Out),p):Play() end) end

	local kg=mk("ScreenGui",{Name="3zKeySystem",ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=1000,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},LP:WaitForChild("PlayerGui"))
	local blur
	pcall(function() blur=Instance.new("BlurEffect"); blur.Size=0; blur.Parent=game:GetService("Lighting"); tw(blur,{Size=22},0.7) end)
	local bd=mk("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(8,9,16),BackgroundTransparency=1},kg)
	tw(bd,{BackgroundTransparency=0.25},0.6)
	local bgg=mk("UIGradient",{Rotation=45,Color=ColorSequence.new(Color3.fromRGB(52,34,120),Color3.fromRGB(14,16,34))},bd)

	-- جسيمات خلفية متحركة
	for i=1,16 do
		local sz=math.random(3,8)
		local dot=mk("Frame",{Size=UDim2.fromOffset(sz,sz),Position=UDim2.fromScale(math.random(),math.random()),BackgroundColor3=GOLD,
			BackgroundTransparency=0.8,BorderSizePixel=0},kg)
		rc(dot,sz)
		task.spawn(function()
			while dot.Parent do
				local t=math.random(40,90)/10
				tw(dot,{Position=UDim2.fromScale(math.random(),math.random()),BackgroundTransparency=math.random(50,92)/100},t,Enum.EasingStyle.Sine)
				task.wait(t)
			end
		end)
	end

	local CW,CH=(IsMobile and 330 or 410),372
	local glow=mk("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,24),Size=UDim2.fromOffset(CW+26,CH+26),BackgroundColor3=GOLD,BackgroundTransparency=0.9},kg)
	rc(glow,30)
	local card=mk("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,24),Size=UDim2.fromOffset(CW,CH),BackgroundColor3=CARD},kg)
	rc(card,22)
	local cStroke=mk("UIStroke",{Color=GOLD,Thickness=1.8,Transparency=0.15},card)
	local sg=mk("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(60,40,140)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))}},cStroke)
	local cScale=mk("UIScale",{Scale=0.92},card)
	tw(cScale,{Scale=1},0.5,Enum.EasingStyle.Back); tw(card,{Position=UDim2.new(0.5,0,0.5,0)},0.5); tw(glow,{Position=UDim2.new(0.5,0,0.5,0)},0.5)
	local spin=RunService.RenderStepped:Connect(function(dt)
		bgg.Rotation=(bgg.Rotation+dt*12)%360
		sg.Rotation=(sg.Rotation+dt*90)%360
		glow.Position=card.Position; glow.Size=UDim2.fromOffset(CW*cScale.Scale+26,CH*cScale.Scale+26)
	end)

	local form=mk("Frame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1},card)
	local cx=mk("TextButton",{Size=UDim2.fromOffset(26,26),Position=UDim2.new(1,-38,0,12),BackgroundColor3=FIELD,Text="×",
		Font=Enum.Font.GothamBold,TextSize=16,TextColor3=SUBC,AutoButtonColor=false},form); rc(cx,13)
	local lgRing=mk("Frame",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,24),Size=UDim2.fromOffset(70,70),BackgroundTransparency=0.8,BackgroundColor3=GOLD},form); rc(lgRing,35)
	local lg=mk("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(56,56),BackgroundColor3=GOLD},lgRing); rc(lg,28)
	mk("UIGradient",{Rotation=90,Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromRGB(105,70,215))},lg)
	mk("TextLabel",{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Font=Enum.Font.GothamBlack,TextSize=22,Text="V",TextColor3=DARK},lg)
	task.spawn(function()
		while lgRing.Parent do
			tw(lgRing,{Size=UDim2.fromOffset(80,80),BackgroundTransparency=0.95},0.9,Enum.EasingStyle.Sine); task.wait(0.9)
			tw(lgRing,{Size=UDim2.fromOffset(70,70),BackgroundTransparency=0.8},0.9,Enum.EasingStyle.Sine); task.wait(0.9)
		end
	end)
	mk("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(0,106),Size=UDim2.new(1,0,0,28),Font=Enum.Font.GothamBlack,TextSize=23,
		TextColor3=WHITE,RichText=true,Text="VØX Script <font color='#2369ff'>beta</font>"},form)
	local sub=mk("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(0,136),Size=UDim2.new(1,0,0,18),Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=SUBC},form)

	local ib=mk("Frame",{Position=UDim2.new(0,30,0,172),Size=UDim2.new(1,-60,0,46),BackgroundColor3=FIELD},form); rc(ib,13)
	local ist=mk("UIStroke",{Color=IDLE,Thickness=1.5,Transparency=0},ib)
	local box=mk("TextBox",{BackgroundTransparency=1,Position=UDim2.fromOffset(16,0),Size=UDim2.new(1,-30,1,0),Font=Enum.Font.GothamBold,TextSize=15,
		TextColor3=WHITE,PlaceholderColor3=SUBC,ClearTextOnFocus=false,Text="",TextXAlignment=Enum.TextXAlignment.Left},ib)

	local vb=mk("TextButton",{Position=UDim2.new(0,30,0,230),Size=UDim2.new(1,-60,0,46),BackgroundColor3=GOLD,Font=Enum.Font.GothamBlack,TextSize=14,
		TextColor3=DARK,AutoButtonColor=false},form); rc(vb,13)
	mk("UIGradient",{Rotation=90,Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromRGB(115,80,230))},vb)
	local status=mk("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(30,284),Size=UDim2.new(1,-60,0,18),Font=Enum.Font.GothamBold,TextSize=12,TextColor3=SUBC},form)

	local remember=true
	local ck=mk("TextButton",{Position=UDim2.fromOffset(30,316),Size=UDim2.fromOffset(18,18),BackgroundColor3=GOLD,Text="",Font=Enum.Font.GothamBlack,
		TextSize=12,TextColor3=DARK,AutoButtonColor=false},form); rc(ck,5)
	local ckl=mk("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(56,314),Size=UDim2.fromOffset(150,22),Font=Enum.Font.GothamMedium,TextSize=12,
		TextColor3=SUBC,TextXAlignment=Enum.TextXAlignment.Left},form)
	local lb=mk("TextButton",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-30,0,314),Size=UDim2.fromOffset(78,22),BackgroundColor3=FIELD,
		Font=Enum.Font.GothamBold,TextSize=11,TextColor3=WHITE,AutoButtonColor=false},form); rc(lb,11)
	local foot=mk("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(0,346),Size=UDim2.new(1,0,0,16),Font=Enum.Font.GothamMedium,TextSize=10,TextColor3=SUBC},form)

	local function relang()
		sub.Text=tr("نظام التحقق • أدخل مفتاحك للمتابعة","Verification • Enter your key to continue")
		box.PlaceholderText=tr("أدخل المفتاح هنا","Enter key here")
		vb.Text=tr("تحقق من المفتاح","VERIFY KEY")
		ckl.Text=tr("تذكر المفتاح","Remember key")
		lb.Text=S.Lang=="ar" and "English" or "العربية"
		foot.Text=tr("VØX Script beta • وصول آمن ومحمي","VØX Script beta • Secure access")
	end
	relang()
	local function say(t,c) status.Text=t; status.TextColor3=c end

	local function shake()
		for i=1,6 do
			tw(card,{Position=UDim2.new(0.5,(i%2==0) and 9 or -9,0.5,0)},0.04); task.wait(0.045)
		end
		tw(card,{Position=UDim2.new(0.5,0,0.5,0)},0.06)
	end

	local attempts,lockUntil,verifying=0,0,false
	local function lockLoop()
		task.spawn(function()
			while os.clock()<lockUntil and not passed and kg.Parent do
				say(tr("محاولات كثيرة، انتظر ","Too many attempts, wait ")..math.ceil(lockUntil-os.clock()).."s",RED)
				task.wait(0.25)
			end
			if not passed then say("",SUBC) end
		end)
	end
	local function attempt()
		if verifying or passed or os.clock()<lockUntil then return end
		if box.Text=="" then say(tr("أدخل المفتاح أولاً","Enter your key first"),RED); return end
		verifying=true
		say(tr("جارٍ التحقق...","Verifying..."),SUBC); vb.Text="•••"
		task.wait(0.7)
		if isValid(box.Text) then
			passed=true; ist.Color=GREEN
			say(""..tr("تم التحقق بنجاح","Key verified"),GREEN)
			if remember then pcall(function() writefile(CONFIG.KeyFile,CONFIG.Key) end) end
		else
			attempts+=1; ist.Color=RED
			task.spawn(shake)
			if attempts>=5 then attempts=0; lockUntil=os.clock()+15; lockLoop()
			else say(tr("مفتاح غير صحيح","Invalid key").."  ("..attempts.."/5)",RED) end
			task.delay(1.2,function() if not passed and ist.Parent then ist.Color=IDLE end end)
		end
		relang(); verifying=false
	end

	vb.MouseEnter:Connect(function() tw(vb,{BackgroundColor3=Color3.fromRGB(170,140,255)},0.15) end)
	vb.MouseLeave:Connect(function() tw(vb,{BackgroundColor3=GOLD},0.15) end)
	vb.MouseButton1Click:Connect(function() task.spawn(attempt) end)
	box.Focused:Connect(function() if not passed then ist.Color=GOLD end end)
	box.FocusLost:Connect(function(enter) if not passed then ist.Color=IDLE end; if enter then task.spawn(attempt) end end)
	cx.MouseButton1Click:Connect(function() aborted=true end)
	ck.MouseButton1Click:Connect(function() remember=not remember; ck.Text=remember and "" or ""; tw(ck,{BackgroundColor3=remember and GOLD or FIELD},0.15) end)
	lb.MouseButton1Click:Connect(function() S.Lang=S.Lang=="ar" and "en" or "ar"; relang() end)

	if passed then form.Visible=false end
	while not passed and not aborted do task.wait(0.05) end
	local starConn
	local function cleanup()
		pcall(function() spin:Disconnect() end)
		if starConn then pcall(function() starConn:Disconnect() end) end
		if blur then pcall(function() blur:Destroy() end) end
		pcall(function() kg:Destroy() end)
	end
	if aborted then cleanup(); return end

	-- شاشة التحميل (ملء الشاشة)
	task.wait(0.35)
	local vs0=(workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(1280,720)
	local small=vs0.X<700
	local LIGHT=GOLD:Lerp(Color3.fromRGB(10,20,90),0.25)
	local cg=mk("CanvasGroup",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(246,248,255),BorderSizePixel=0,GroupTransparency=1,ZIndex=50},kg)
	tw(cg,{GroupTransparency=0},0.5)
	local g1=mk("Frame",{Size=UDim2.fromScale(1,0.65),BackgroundColor3=GOLD,BorderSizePixel=0},cg)
	mk("UIGradient",{Rotation=90,Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,0.72),NumberSequenceKeypoint.new(1,1)}},g1)
	local g2=mk("Frame",{AnchorPoint=Vector2.new(0,1),Position=UDim2.fromScale(0,1),Size=UDim2.fromScale(1,0.35),BackgroundColor3=GOLD,BorderSizePixel=0},cg)
	mk("UIGradient",{Rotation=90,Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0.86)}},g2)
	local lstars={}
	for i=1,0 do
		local sz=math.random(1,3)
		local f=mk("Frame",{Size=UDim2.fromOffset(sz,sz),Position=UDim2.fromScale(math.random(),math.random()),
			BackgroundColor3=(math.random()<0.3) and LIGHT or Color3.new(1,1,1),BorderSizePixel=0,BackgroundTransparency=1},cg)
		rc(f,sz)
		table.insert(lstars,{f=f,ph=math.random()*6.28,sp=0.6+math.random()*1.8,base=0.2+math.random()*0.7})
	end

	local col=mk("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(math.min(620,vs0.X-48),370),BackgroundTransparency=1},cg)
	local ringO=mk("Frame",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,0),Size=UDim2.fromOffset(132,132),BackgroundTransparency=1},col)
	rc(ringO,66)
	local ringS=mk("UIStroke",{Thickness=3,Color=Color3.new(1,1,1)},ringO)
	local ringG=mk("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,GOLD),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(20,20,40)),ColorSequenceKeypoint.new(1,GOLD)}},ringS)
	local core=mk("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(100,100),BackgroundColor3=GOLD},ringO)
	rc(core,50)
	mk("UIGradient",{Rotation=90,Color=ColorSequence.new(LIGHT,GOLD)},core)
	mk("TextLabel",{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Font=Enum.Font.GothamBlack,TextSize=40,Text="V",TextColor3=DARK},core)
	task.spawn(function()
		while ringO.Parent do
			tw(core,{Size=UDim2.fromOffset(108,108)},0.7,Enum.EasingStyle.Sine); task.wait(0.7)
			tw(core,{Size=UDim2.fromOffset(100,100)},0.7,Enum.EasingStyle.Sine); task.wait(0.7)
		end
	end)
	local ty=152
	local th=small and 40 or 62
	local title=mk("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(0,ty),Size=UDim2.new(1,0,0,th),Font=Enum.Font.GothamBlack,
		TextSize=small and 34 or 56,TextColor3=Color3.fromRGB(18,24,56),Text="VØX SCRIPT"},col)
	local tG=mk("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,GOLD),ColorSequenceKeypoint.new(0.5,LIGHT),ColorSequenceKeypoint.new(1,GOLD)}},title)
	mk("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(0,ty+th+4),Size=UDim2.new(1,0,0,18),Font=Enum.Font.GothamBold,TextSize=12,
		TextColor3=SUBC,Text="BETA   -   PROFESSIONAL EDITION"},col)
	local sy=ty+th+44
	local lstat=mk("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(0,sy),Size=UDim2.new(1,0,0,22),Font=Enum.Font.GothamMedium,TextSize=14,TextColor3=WHITE},col)
	local barW=math.min(560,vs0.X-80)
	local by=sy+34
	local barbg=mk("Frame",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,by),Size=UDim2.fromOffset(barW,8),BackgroundColor3=Color3.fromRGB(215,222,245),BorderSizePixel=0},col)
	rc(barbg,4)
	local barf=mk("Frame",{Size=UDim2.fromScale(0,1),BackgroundColor3=GOLD,BorderSizePixel=0},barbg)
	rc(barf,4)
	mk("UIGradient",{Color=ColorSequence.new(GOLD,LIGHT)},barf)
	local pct=mk("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(0,by+16),Size=UDim2.new(1,0,0,30),Font=Enum.Font.GothamBlack,TextSize=24,TextColor3=LIGHT,Text="0%"},col)

	local tipLbl=mk("TextLabel",{AnchorPoint=Vector2.new(0.5,1),Position=UDim2.new(0.5,0,1,-30),Size=UDim2.new(1,-40,0,20),BackgroundTransparency=1,
		Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=SUBC},cg)
	mk("TextLabel",{Position=UDim2.fromOffset(26,20),Size=UDim2.fromOffset(300,20),BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=12,TextColor3=SUBC,
		TextXAlignment=Enum.TextXAlignment.Left,Text=tr("أهلاً، ","Welcome, ")..LP.DisplayName},cg)
	mk("TextLabel",{AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-26,1,-20),Size=UDim2.fromOffset(200,18),BackgroundTransparency=1,Font=Enum.Font.GothamBold,
		TextSize=11,TextColor3=SUBC,TextXAlignment=Enum.TextXAlignment.Right,Text="VØX SCRIPT  BETA"},cg)

	local progT,progC=0,0
	starConn=RunService.RenderStepped:Connect(function(dt)
		local t=os.clock()
		for _,st in ipairs(lstars) do
			st.f.BackgroundTransparency=math.clamp(1-st.base*(0.5+0.5*math.sin(t*st.sp+st.ph)),0,1)
			local p=st.f.Position
			st.f.Position=UDim2.fromScale(p.X.Scale,(p.Y.Scale-dt*st.sp*0.006)%1)
		end
		ringG.Rotation=(t*140)%360
		tG.Offset=Vector2.new(math.sin(t*1.1)*0.6,0)
		progC=progC+(progT-progC)*math.min(1,dt*6)
		barf.Size=UDim2.fromScale(progC,1)
		pct.Text=math.floor(progC*100+0.5).."%"
	end)
	task.delay(0.6,function() card.Visible=false; glow.Visible=false; bd.Visible=false end)
	local tipsL={
		tr("نصيحة: زر الإظهار والإخفاء الافتراضي هو RightShift","Tip: the default show/hide key is RightShift"),
		tr("نصيحة: استخدم صفحة التجاهل لإخفاء أي شيء غير الضبان","Tip: use the Ignore page to hide anything that is not a dhab"),
		tr("نصيحة: احفظ إعداداتك من صفحة الملفات","Tip: save your settings from the Profiles page"),
	}
	local steps={
		{"تهيئة النواة","Initializing core"},{"تحميل الوحدات","Loading modules"},{"بناء الواجهة","Building interface"},
		{"تجهيز محرك الإضاءة","Preparing ESP engine"},{"تجهيز مساعد التصويب","Preparing aim assist"},
		{"تجهيز نظام الطيران","Setting up flight"},{"تطبيق الإعدادات","Applying settings"},{"جاهز","Ready"},
	}
	for i,st in ipairs(steps) do
		lstat.Text=tr(st[1],st[2]).."   ["..i.."/"..#steps.."]"
		progT=i/#steps
		tipLbl.Text=tipsL[(i-1)%#tipsL+1]
		task.wait(0.35+math.random()*0.3)
	end
	task.wait(0.5)
	tw(cg,{GroupTransparency=1},0.6)
	if blur then tw(blur,{Size=0},0.6) end
	task.wait(0.65)
	cleanup()
end

--==================== اكتشاف الضبان ====================
local Tracked = {}
local Muted = setmetatable({},{__mode="k"})
local Seen = setmetatable({},{__mode="k"})
local Stat = {discovered=0, flown=0}
local Counts = {total=0,inRange=0,alive=0,byRarity={}}
local notifyQueue = {}
local Flying = {active=false, target=nil, conn=nil, bv=nil, bg=nil, savedCollide=nil, died=nil, vel=Vector3.zero, speed=0, u=0, total=1, startPos=Vector3.zero, hudT=0}
local notify
local currentTarget
local hudFrame, hudText

local function isIgnoredName(n)
	n=string.lower(tostring(n))
	for _,k in ipairs(CONFIG.IgnoreList) do
		local kl=string.lower(k)
		if n==kl or string.find(n,kl,1,true) then return true end
	end
	return false
end
local function isIgnored(inst)
	local cur=inst
	while cur and cur~=workspace and cur~=game do
		if isIgnoredName(cur.Name) then return true end
		cur=cur.Parent
	end
	return false
end

local function hasExcluded(n)
	n=string.lower(tostring(n))
	for g,list in pairs(CONFIG.ExcludeGroups) do
		if S["Ex"..g] then
			for _,k in ipairs(list) do
				if string.find(n,string.lower(k),1,true) then return true end
			end
		end
	end
	return false
end

local BadCache=setmetatable({},{__mode="k"})
local function isBadModelRaw(m)
	if hasExcluded(m.Name) then return true end
	local a=m.Parent
	while a and a~=workspace and a~=game do
		if (S.ExWeapons and a:IsA("Tool")) or a:IsA("Accessory") or a:IsA("Backpack") then return true end
		if a:IsA("Model") and (hasExcluded(a.Name) or Players:GetPlayerFromCharacter(a)) then return true end
		a=a.Parent
	end
	for _,d in ipairs(m:GetDescendants()) do
		if S.ExVehicles and (d:IsA("VehicleSeat") or d:IsA("Seat")) then return true end
		if S.ExWeapons and d:IsA("Tool") then return true end
	end
	return false
end

local function isBadModel(m)
	if BadCache[m] then return true end
	local r=isBadModelRaw(m)
	if r then BadCache[m]=true end
	return r
end

local function matchesName(n)
	local low=string.lower(n)
	local hit=false
	for _,k in ipairs(CONFIG.Keywords) do
		if string.find(low,k,1,true) then hit=true break end
	end
	if not hit then return false end
	if isIgnoredName(n) or hasExcluded(n) then return false end
	for _,k in ipairs(CONFIG.IgnoreList) do
		if low==string.lower(k) then return false end
	end
	return true
end

local function normRarity(v)
	if typeof(v)=="number" then return CONFIG.RarityOrder[math.clamp(math.floor(v),1,#CONFIG.RarityOrder)] end
	if typeof(v)~="string" then return nil end
	local low=string.lower(v)
	for r,ar in pairs(CONFIG.RarityAr) do
		if string.find(low,string.lower(r),1,true) or string.find(v,ar,1,true) then return r end
	end
	return nil
end

local function getRarity(m)
	for _,a in ipairs(CONFIG.RarityAttributes) do
		local r=normRarity(m:GetAttribute(a)); if r then return r end
		local v=m:FindFirstChild(a)
		if v and (v:IsA("StringValue") or v:IsA("NumberValue") or v:IsA("IntValue")) then
			r=normRarity(v.Value); if r then return r end
		end
	end
	return normRarity(m.Name) or "Common"
end

local function rootOf(m)
	return m.PrimaryPart or m:FindFirstChild("HumanoidRootPart") or m:FindFirstChildWhichIsA("BasePart",true)
end

local function untrack(m)
	local d=Tracked[m]; if not d then return end
	Tracked[m]=nil; Muted[m]=nil
	for _,k in ipairs({"hl","bb","box","tracer","arrow"}) do
		local o=d[k]; if o then pcall(o.Destroy,o) end
	end
	if d.conn then pcall(function() d.conn:Disconnect() end) end
end

local tracerLayer
local function track(m, isNew)
	if Tracked[m] or not m:IsA("Model") or Players:GetPlayerFromCharacter(m) then return end
	if isIgnoredName(m.Name) or isIgnored(m) or isBadModel(m) then return end
	local root=rootOf(m); if not root then return end
	local rarity=getRarity(m)
	local ok,d=pcall(function()
		local hl=Instance.new("Highlight"); hl.Name="3zHL"; hl.Adornee=m; hl.Parent=m
		local bb=Instance.new("BillboardGui"); bb.Name="3zTag"; bb.Size=UDim2.fromOffset(220,60)
		bb.AlwaysOnTop=true; bb.Adornee=root; bb.Parent=m
		local lbl=Instance.new("TextLabel"); lbl.BackgroundTransparency=1; lbl.Size=UDim2.new(1,0,1,-10)
		lbl.Font=Enum.Font.GothamBold; lbl.TextStrokeTransparency=0.8; lbl.RichText=true; lbl.Parent=bb
		local bar=Instance.new("Frame"); bar.Size=UDim2.fromOffset(110,6); bar.AnchorPoint=Vector2.new(0.5,1)
		bar.Position=UDim2.new(0.5,0,1,-1); bar.BackgroundColor3=Color3.fromRGB(20,20,24); bar.BorderSizePixel=0; bar.Parent=bb
		Instance.new("UICorner",bar).CornerRadius=UDim.new(0,3)
		local bf=Instance.new("Frame"); bf.Size=UDim2.fromScale(1,1); bf.BorderSizePixel=0; bf.Parent=bar
		Instance.new("UICorner",bf).CornerRadius=UDim.new(0,3)
		local bx=Instance.new("BillboardGui"); bx.Name="3zBox"; bx.AlwaysOnTop=true; bx.LightInfluence=0
		bx.Size=UDim2.fromScale(4,6); bx.Adornee=root; bx.Enabled=false; bx.Parent=m
		local bxf=Instance.new("Frame"); bxf.Size=UDim2.fromScale(1,1); bxf.BackgroundTransparency=1; bxf.BorderSizePixel=0; bxf.Parent=bx
		local bxs=Instance.new("UIStroke"); bxs.Thickness=1.5; bxs.Parent=bxf
		local tr,ar
		if tracerLayer then
			tr=Instance.new("Frame"); tr.AnchorPoint=Vector2.new(0.5,0.5); tr.BorderSizePixel=0
			tr.Visible=false; tr.Parent=tracerLayer
			ar=Instance.new("TextLabel"); ar.AnchorPoint=Vector2.new(0.5,0.5); ar.Size=UDim2.fromOffset(26,26)
			ar.BackgroundTransparency=1; ar.Font=Enum.Font.GothamBlack; ar.TextSize=22; ar.Text=">"
			ar.TextStrokeTransparency=0.8; ar.Visible=false; ar.Parent=tracerLayer
		end
		return {hl=hl,bb=bb,label=lbl,bar=bar,barFill=bf,box=bx,boxStroke=bxs,rarity=rarity,root=root,tracer=tr,arrow=ar,
			hum=m:FindFirstChildOfClass("Humanoid"),c={},dist=0,vis=false}
	end)
	if not ok or not d then return end
	Tracked[m]=d
	d.conn=m.AncestryChanged:Connect(function(_,p) if not p then untrack(m) end end)
	if not Seen[m] then
		Seen[m]=true; Stat.discovered+=1
		if isNew then
			table.insert(U.log,1,{os.date("%H:%M:%S"),m.Name,rarity})
			if #U.log>60 then table.remove(U.log) end
			U.logVer+=1
		end
	end
	if isNew and (S.Notify or S.AutoFly) then
		local a=table.find(CONFIG.RarityOrder,rarity) or 1
		local b=table.find(CONFIG.RarityOrder,S.NotifyMin) or 5
		if a>=b then table.insert(notifyQueue,{m.Name,rarity,m}) end
	end
end

local Skip=setmetatable({},{__mode="k"})
local function resetSkip() Skip=setmetatable({},{__mode="k"}) end
U.prompts=setmetatable({},{__mode="k"})
local function scan()
	local c=(CONFIG.CustomFolder and workspace:FindFirstChild(CONFIG.CustomFolder)) or workspace
	if U.scanning then return end
	U.scanning=true
	local n=0
	for _,d in ipairs(c:GetDescendants()) do
		if d:IsA("Model") and not Tracked[d] and not Skip[d] then
			if CONFIG.CustomFolder or matchesName(d.Name) then track(d,false) else Skip[d]=true end
		end
		if d:IsA("ProximityPrompt") then U.prompts[d]=true end
		n+=1; if n%200==0 then task.wait() end
	end
	U.scanning=false
end
workspace.DescendantAdded:Connect(function(d)
	if d:IsA("Model") and matchesName(d.Name) then task.defer(track,d,true) end
end)

local function myRoot() local c=LP.Character; return c and c:FindFirstChild("HumanoidRootPart") end

--==================== نظام الطيران ====================
local flyRay=RaycastParams.new(); flyRay.FilterType=Enum.RaycastFilterType.Exclude

local landRay=RaycastParams.new(); landRay.FilterType=Enum.RaycastFilterType.Exclude
local function safeLand(char)
	local hrp=char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
	landRay.FilterDescendantsInstances={char}
	local hit=workspace:Raycast(hrp.Position+Vector3.new(0,6,0),Vector3.new(0,-60,0),landRay)
	if hit and hrp.Position.Y<hit.Position.Y+2.5 then
		hrp.CFrame=CFrame.new(hit.Position+Vector3.new(0,3.5,0))*(hrp.CFrame-hrp.CFrame.Position)
		hrp.AssemblyLinearVelocity=Vector3.zero
	end
end

local function stopFlight()
	local was=Flying.active
	Flying.active=false
	Flying.target=nil
	if Flying.conn then Flying.conn:Disconnect(); Flying.conn=nil end
	if Flying.died then Flying.died:Disconnect(); Flying.died=nil end
	if Flying.bv then
		local bv=Flying.bv; Flying.bv=nil
		pcall(function() bv.Velocity=Vector3.zero end); pcall(bv.Destroy,bv)
	end
	if Flying.bg then local bg=Flying.bg; Flying.bg=nil; pcall(bg.Destroy,bg) end
	Flying.vel=Vector3.zero; Flying.speed=0
	local char = LP.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hum then pcall(function() hum.PlatformStand=false end) end
		if was and hrp then
			pcall(function() hrp.AssemblyLinearVelocity=Vector3.zero; hrp.AssemblyAngularVelocity=Vector3.zero end)
		end
	end
	if Flying.savedCollide then
		for p, c in pairs(Flying.savedCollide) do
			if p.Parent then pcall(function() p.CanCollide=c end) end
		end
		Flying.savedCollide = nil
	end
	if was then pcall(safeLand, char) end
	if hudFrame then hudFrame.Visible=false end
end

local function flyTo(target)
	if not target or not Tracked[target] then return end
	stopFlight()
	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum or hum.Health <= 0 then return end
	local td = Tracked[target]
	if not td or not td.root.Parent then return end

	Flying.active = true
	Flying.target = target
	Flying.vel = Vector3.zero; Flying.speed = 0; Flying.u = 0
	Flying.capMul = 1; Flying.snaps = 0; Flying.expect = nil
	Flying.startPos = hrp.Position
	Flying.total = math.max((td.root.Position-hrp.Position).Magnitude,1)
	Stat.flown += 1

	local noclip = S.FlySafe or S.FlyThroughWalls
	if noclip then
		Flying.savedCollide = {}
		for _, p in ipairs(char:GetDescendants()) do
			if p:IsA("BasePart") then
				Flying.savedCollide[p] = p.CanCollide
				pcall(function() p.CanCollide = false end)
			end
		end
	end

	pcall(function() hum.PlatformStand = true end)

	local bv, bg
	local okc = true
	if S.FlyMode=="Velocity" then okc = pcall(function()
		bv = Instance.new("BodyVelocity")
		bv.Name = "3zFly"
		bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bv.Velocity = Vector3.zero
		bv.Parent = hrp
		bg = Instance.new("BodyGyro")
		bg.Name = "3zFlyGyro"
		bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bg.P = 200000
		bg.D = 2000
		bg.CFrame = hrp.CFrame
		bg.Parent = hrp
	end) end
	if not okc then stopFlight(); return end
	Flying.bv = bv; Flying.bg = bg
	Flying.died = hum.Died:Connect(function() stopFlight() end)

	local function step(dt)
		if not Flying.active then return end
		local curChar = LP.Character
		local curHrp = curChar and curChar:FindFirstChild("HumanoidRootPart")
		local curHum = curChar and curChar:FindFirstChildOfClass("Humanoid")
		if not curHrp or curHrp ~= hrp or not hrp.Parent or not curHum or curHum.Health <= 0 then stopFlight(); return end

		local tgt = Flying.target
		local curTd = tgt and Tracked[tgt]
		if not curTd or not curTd.root.Parent then
			stopFlight()
			notify(L({ar="فُقد الهدف",en="Target lost"}), Color3.fromRGB(230,60,60))
			return
		end

		local targetPos = curTd.root.Position + Vector3.new(0, S.FlyStopDist*0.5, 0)
		local myPos = hrp.Position
		if Flying.expect and (myPos - Flying.expect).Magnitude > 14 then
			Flying.snaps = (Flying.snaps or 0) + 1
			Flying.capMul = math.max(0.25, (Flying.capMul or 1)*0.7)
			Flying.vel = Vector3.zero; Flying.speed = 0
			if Flying.snaps <= 3 then notify(L({ar="تم رصد ارتداد من اللعبة، تم تخفيض السرعة",en="Rubber-band detected, speed reduced"}), Color3.fromRGB(240,110,110)) end
		end
		local delta = targetPos - myPos
		local dist = delta.Magnitude

		if dist <= S.FlyStopDist then
			local nm, col = tgt.Name, CONFIG.RarityColors[curTd.rarity]
			stopFlight()
			notify((S.Lang=="ar" and "وصلت: " or "Arrived: ").."<b>"..nm.."</b>", col)
			return
		end

		local goal = targetPos
		if S.FlyCurve then
			Flying.u = math.min(1, Flying.u + math.max(Flying.speed,10)*dt/Flying.total)
			local ctrl = (Flying.startPos+targetPos)/2 + Vector3.new(0, Flying.total*S.FlyArc+8, 0)
			goal = U.bez(Flying.startPos, ctrl, targetPos, math.min(1, Flying.u+0.06))
		end
		local gd = goal - myPos
		local dir = gd.Magnitude > 0.05 and gd.Unit or delta.Unit

		if S.FlyAvoid and not noclip then
			flyRay.FilterDescendantsInstances = {curChar, tgt}
			local look = math.clamp(Flying.speed*0.35, 8, 45)
			local hit = workspace:Raycast(myPos, dir*look, flyRay)
			if hit then dir = (dir + Vector3.new(0,1.6,0)).Unit end
		end

		local speed = S.FlySpeed*(Flying.capMul or 1)
		if dist < 20 then speed = math.max(speed*(dist/20), 15) end
		Flying.speed = lerp(Flying.speed, speed, 1-math.exp(-dt*4))
		local desired = dir*Flying.speed
		local err = desired - Flying.vel
		local maxStep = S.FlySpeed*(Flying.capMul or 1)*10*dt
		if err.Magnitude > maxStep then err = err.Unit*maxStep end
		Flying.vel = Flying.vel + err*(1-math.exp(-dt/math.max(S.FlySmooth,0.02)))

		if bv then
			bv.Velocity = Flying.vel
			bg.CFrame = CFrame.lookAt(myPos, myPos+dir)
		else
			local np = myPos + Flying.vel*dt
			hrp.CFrame = CFrame.lookAt(np, np+dir)
			hrp.AssemblyLinearVelocity = Vector3.zero
		end
		hrp.AssemblyAngularVelocity = Vector3.zero
		Flying.expect = bv and (myPos + Flying.vel*dt) or hrp.Position

		Flying.hudT += dt
		if hudFrame and Flying.hudT >= 0.05 then
			Flying.hudT = 0
			hudFrame.Visible = S.HUD
			hudText.Text = string.format("<b>%s</b>   %s <b>%d</b>m   %s <b>%d</b> m/s",
				tgt.Name, L({ar="المتبقي",en="Left"}), math.floor(dist), L({ar="السرعة",en="Speed"}), math.floor(Flying.vel.Magnitude))
		end
	end

	Flying.conn = RunService.Heartbeat:Connect(function(dt)
		local ok = pcall(step, dt)
		if not ok then stopFlight() end
	end)

	notify((S.Lang=="ar" and "طيران إلى " or "Flying to ").."<b>"..target.Name.."</b>", CONFIG.RarityColors[td.rarity])
end

local function nearestOf(filter)
	local r=myRoot(); if not r then return nil end
	local best,bd
	for m,d in pairs(Tracked) do
		if d.root.Parent and (not filter or filter(d)) then
			local dist=(d.root.Position-r.Position).Magnitude
			if not bd or dist<bd then best,bd=m,dist end
		end
	end
	return best
end

local function bestRarity()
	local best,bi
	for m,d in pairs(Tracked) do
		local i=table.find(CONFIG.RarityOrder,d.rarity) or 0
		if not bi or i>bi then best,bi=m,i end
	end
	return best
end

--==================== الثيمات والألوان ====================
local THEMES = {
	Dark={BG=Color3.fromRGB(10,11,19),BG2=Color3.fromRGB(14,15,26),SIDE=Color3.fromRGB(13,14,24),PANEL=Color3.fromRGB(20,22,37),
		PANEL2=Color3.fromRGB(29,32,53),PANEL3=Color3.fromRGB(50,55,90),TXT=Color3.fromRGB(240,243,255),SUB=Color3.fromRGB(140,148,182)},
	Light={BG=Color3.fromRGB(244,246,251),BG2=Color3.fromRGB(234,237,246),SIDE=Color3.fromRGB(236,239,248),PANEL=Color3.fromRGB(255,255,255),
		PANEL2=Color3.fromRGB(226,230,241),PANEL3=Color3.fromRGB(205,211,228),TXT=Color3.fromRGB(26,30,44),SUB=Color3.fromRGB(100,108,130)},
}
local Th = {}
for k,v in pairs(THEMES.Light) do Th[k]=v end
local BG,BG2,SIDE,PANEL,PANEL2,PANEL3,TXT,SUB
local function syncPal() BG,BG2,SIDE,PANEL,PANEL2,PANEL3,TXT,SUB=Th.BG,Th.BG2,Th.SIDE,Th.PANEL,Th.PANEL2,Th.PANEL3,Th.TXT,Th.SUB end
syncPal()
local curTheme="Light"

--==================== أدوات الواجهة ====================
local accentObjs = {}
local function accent(o,prop) table.insert(accentObjs,{o,prop}); o[prop]=ACC() end
local function repaint() for _,a in ipairs(accentObjs) do if a[1].Parent then a[1][a[2]]=ACC() end end end
local function new(cls,props,parent)
	local o=Instance.new(cls)
	if o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox") then o.TextStrokeTransparency=1 end -- نص حاد بدون ظل
	for k,v in pairs(props or {}) do o[k]=v end
	o.Parent=parent; return o
end
local function corner(p,r) new("UICorner",{CornerRadius=UDim.new(0,r or 12)},p) end
local function stroke(p,t,tr) local s=new("UIStroke",{Thickness=t or 1,Transparency=0.6+(tr or 0.4)*0.4},p); accent(s,"Color"); return s end
local function tween(o,p,t) pcall(function() TweenService:Create(o,TweenInfo.new(t or 0.2,Enum.EasingStyle.Quint),p):Play() end) end
local function gradient(p,rot,a,b)
	local g=new("UIGradient",{Rotation=rot or 90},p)
	g.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,a or Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,b or Color3.fromRGB(235,237,250))}
	return g
end
local texts = {}
local dyn = {}
local function reg(f) table.insert(texts,f); f() end

--==================== النجوم ====================
U.stars={}
function U.makeStars(parent,count)
	if S.Lite then count=0 end
	local set={parent=parent,list={}}
	for i=1,count do
		local sz=math.random(1,3)
		local f=new("Frame",{Size=UDim2.fromOffset(sz,sz),Position=UDim2.fromScale(math.random(),math.random()),BackgroundColor3=Color3.new(1,1,1),
			BorderSizePixel=0,BackgroundTransparency=1},parent)
		corner(f,sz)
		if math.random()<0.3 then accent(f,"BackgroundColor3") end
		table.insert(set.list,{f=f,ph=math.random()*6.28,sp=0.6+math.random()*1.8,base=0.2+math.random()*0.6})
	end
	table.insert(U.stars,set)
	return set
end
function U.shoot(parent)
	local f=new("Frame",{Size=UDim2.fromOffset(110,2),Position=UDim2.fromScale(math.random()*0.6,math.random()*0.35),BackgroundColor3=Color3.new(1,1,1),
		BorderSizePixel=0,Rotation=28,BackgroundTransparency=0.1},parent)
	new("UIGradient",{Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)}},f)
	local p=f.Position
	tween(f,{Position=UDim2.new(p.X.Scale+0.28,0,p.Y.Scale+0.2,0),BackgroundTransparency=1},0.9)
	task.delay(1,function() pcall(f.Destroy,f) end)
end
local nextShoot=os.clock()+2
local starF=0
RunService.RenderStepped:Connect(function(dt)
	local t=os.clock()
	starF+=1
	for _,set in ipairs(U.stars) do
		if starF%2~=0 then break end
		if set.parent.Parent and set.parent.Visible then
			for _,st in ipairs(set.list) do
				st.f.BackgroundTransparency=math.clamp(1-st.base*(0.5+0.5*math.sin(t*st.sp+st.ph)),0,1)
				local p=st.f.Position
				st.f.Position=UDim2.fromScale(p.X.Scale,(p.Y.Scale-dt*st.sp*0.006)%1)
			end
		end
	end
	local ov=U.welcome
	if ov and ov.Visible then
		if U.titleGrad then U.titleGrad.Offset=Vector2.new(math.sin(t*0.9)*0.6,0) end
		if not S.Lite and t>nextShoot then nextShoot=t+2+math.random()*3; U.shoot(ov) end
	end
end)

--==================== النافذة الرئيسية ====================
local gui=new("ScreenGui",{Name="3zScriptBeta",ResetOnSpawn=false,IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},LP:WaitForChild("PlayerGui"))
tracerLayer=new("Frame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1},gui)

local W,H = 800,480
if IsMobile then W,H = 580,320 end
local DEFAULT_POS=UDim2.new(0.5,-W/2,0.5,-H/2)

local shadow=new("Frame",{Size=UDim2.fromOffset(W+16,H+16),Position=UDim2.new(0.5,-W/2-8,0.5,-H/2-4),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.7,Visible=false},gui)
corner(shadow,24)

local main=new("Frame",{Size=UDim2.fromOffset(W,H),Position=DEFAULT_POS,BackgroundColor3=BG,ClipsDescendants=true},gui)
corner(main,18)
local mainStroke=stroke(main,1.6,0.2)
U.mg=new("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))}},mainStroke)
local scale=new("UIScale",{Scale=S.UIScale},main)
U.makeStars(main,16)

-- توهج علوي بلون الثيم
local topGlow=new("Frame",{Size=UDim2.new(1,0,0,120),BackgroundColor3=ACC(),BorderSizePixel=0,ZIndex=0},main)
accent(topGlow,"BackgroundColor3")
new("UIGradient",{Rotation=90,Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,0.86),NumberSequenceKeypoint.new(1,1)}},topGlow)

local top=new("Frame",{Size=UDim2.new(1,0,0,46),BackgroundColor3=SIDE,BackgroundTransparency=0.15},main)

local topAccentBar=new("Frame",{Size=UDim2.new(1,0,0,2),Position=UDim2.new(0,0,1,-2),BackgroundColor3=ACC(),BorderSizePixel=0},top)
accent(topAccentBar,"BackgroundColor3")
new("UIGradient",{Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.5,0),NumberSequenceKeypoint.new(1,1)}},topAccentBar)

local logoBadge=new("Frame",{Size=UDim2.fromOffset(28,28),Position=UDim2.fromOffset(12,9),BackgroundColor3=ACC()},top)
accent(logoBadge,"BackgroundColor3"); corner(logoBadge,9)
new("TextLabel",{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Font=Enum.Font.GothamBlack,TextSize=13,Text="V",TextColor3=Color3.new(1,1,1)},logoBadge)
local logo=new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(48,0),Size=UDim2.fromOffset(130,46),
	Font=Enum.Font.GothamBlack,TextSize=16,TextColor3=TXT,Text="VØX Script <font color='#8a8fa8' size='12'>beta</font>",RichText=true,TextXAlignment=Enum.TextXAlignment.Left},top)

local statusDot=new("Frame",{Size=UDim2.fromOffset(8,8),Position=UDim2.fromOffset(186,19),BackgroundColor3=Color3.fromRGB(60,220,90),BorderSizePixel=0},top)
corner(statusDot,4)

local topStats=new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(202,0),Size=UDim2.new(1,-300,1,0),
	Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=SUB,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd},top)

local function topBtn(txt,x,col)
	local b=new("TextButton",{Size=UDim2.fromOffset(14,14),Position=UDim2.new(1,x,0.5,-7),BackgroundColor3=col,
		Text="",AutoButtonColor=false},top)
	corner(b,7)
	b.MouseEnter:Connect(function() tween(b,{Size=UDim2.fromOffset(18,18),Position=UDim2.new(1,x-2,0.5,-9)},0.12) end)
	b.MouseLeave:Connect(function() tween(b,{Size=UDim2.fromOffset(14,14),Position=UDim2.new(1,x,0.5,-7)},0.12) end)
	return b
end
local closeBtn=topBtn("×",-28,Color3.fromRGB(255,95,87))
local minBtn=topBtn("–",-52,Color3.fromRGB(120,130,175))
local resetBtn=topBtn("",-76,Color3.fromRGB(40,200,64))

local SW = IsMobile and 120 or 150
local sideH = IsMobile and 0 or 62
local side=new("ScrollingFrame",{Size=UDim2.new(0,SW,1,-46-sideH),Position=UDim2.fromOffset(0,46),BackgroundColor3=SIDE,BackgroundTransparency=0.15,
	ScrollBarThickness=0,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),BorderSizePixel=0},main)
if sideH>0 then new("Frame",{Size=UDim2.new(0,SW,0,sideH),Position=UDim2.new(0,0,1,-sideH),BackgroundColor3=SIDE,BackgroundTransparency=0.15,BorderSizePixel=0},main) end
new("Frame",{Size=UDim2.new(0,1,1,-46),Position=UDim2.new(0,SW-1,0,46),BackgroundColor3=PANEL3,BackgroundTransparency=0.6,BorderSizePixel=0},main)
new("UIListLayout",{Padding=UDim.new(0,4),HorizontalAlignment=Enum.HorizontalAlignment.Center},side)
new("UIPadding",{PaddingTop=UDim.new(0,10),PaddingBottom=UDim.new(0,10)},side)
local content=new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Size=UDim2.new(1,-SW,1,-46),Position=UDim2.new(0.5,SW/2,0.5,23),BackgroundTransparency=1},main)
local pageScale=new("UIScale",{Scale=1},content)

U.avatars={}
function U.setAvatar(img) for _,a in ipairs(U.avatars) do pcall(function() a.Image=img end) end end
if not IsMobile then
	local prof=new("Frame",{Size=UDim2.new(0,SW-14,0,50),Position=UDim2.new(0,7,1,-57),BackgroundColor3=PANEL},main)
	corner(prof,12); new("UIStroke",{Color=PANEL3,Thickness=1,Transparency=0.5},prof)
	local pav=new("ImageLabel",{Size=UDim2.fromOffset(34,34),Position=UDim2.fromOffset(8,8),BackgroundColor3=PANEL2},prof); corner(pav,17)
	table.insert(U.avatars,pav)
	new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(49,7),Size=UDim2.new(1,-54,0,18),Font=Enum.Font.GothamBold,
		TextSize=11,TextColor3=TXT,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=LP.DisplayName},prof)
	local role=new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(49,25),Size=UDim2.new(1,-54,0,14),Font=Enum.Font.GothamBlack,
		TextSize=9,TextXAlignment=Enum.TextXAlignment.Left,Text="PREMIUM"},prof)
	accent(role,"TextColor3")
end
task.spawn(function()
	local ok,img=pcall(function() return Players:GetUserThumbnailAsync(LP.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100) end)
	if ok and img then U.setAvatar(img) end
end)

-- Tooltip
local TIPS = {}
do
	local function T(a,e) return {ar=a,en=e} end
	TIPS.ESP=T("تشغيل/إيقاف إضاءة الضبان","Enable or disable dhab ESP")
	TIPS.AlwaysOnTop=T("إظهار الإضاءة فوق الجدران","Show highlight through walls")
	TIPS.Fill=T("تعبئة جسم الضب بلون الندرة","Fill the body with rarity color")
	TIPS.Outline=T("حدود حول الضب","Outline around the dhab")
	TIPS.FillT=T("0 = معبأ بالكامل، 1 = شفاف","0 = solid, 1 = invisible")
	TIPS.OutlineT=T("شفافية خط الحدود","Outline transparency")
	TIPS.MaxDist=T("أبعد مسافة تظهر فيها الإضاءة","Farthest distance ESP is shown")
	TIPS.Tracers=T("خط من الشاشة إلى كل ضب","Line from screen to each dhab")
	TIPS.TracerFrom=T("نقطة بداية الخطوط","Where tracer lines start")
	TIPS.ShowName=T("إظهار اسم الضب","Show dhab name")
	TIPS.ShowRarity=T("إظهار الندرة","Show rarity")
	TIPS.ShowDist=T("إظهار المسافة","Show distance")
	TIPS.ShowHealth=T("إظهار الصحة كرقم","Show health as number")
	TIPS.TextSize=T("حجم نص العلامة","Label text size")
	TIPS.LabelHeight=T("ارتفاع العلامة فوق الضب","Label height above dhab")
	TIPS.Chams=T("تلوين الجسم بالكامل حسب الندرة","Full-body color by rarity")
	TIPS.ChamsT=T("شفافية التلوين الكامل","Chams transparency")
	TIPS.HealthBar=T("شريط صحة أفقي فوق الضب","Horizontal health bar")
	TIPS.DistFade=T("اختفاء تدريجي قرب أقصى مسافة","Fade out near max distance")
	TIPS.OffScreen=T("سهم يشير للضب خارج الشاشة","Arrow to off-screen dhabs")
	TIPS.Box=T("إطار حول الضب","Box around the dhab")
	TIPS.Aim=T("تشغيل مساعد التصويب","Enable aim assist")
	TIPS.AimMode=T("ضغط مستمر / تبديل / دائماً","Hold / Toggle / Always")
	TIPS.Priority=T("كيف يُختار الهدف","How the target is chosen")
	TIPS.AimPart=T("الجزء المستهدف من الضب","Body part to aim at")
	TIPS.Strength=T("قوة سحب الكاميرا","Camera pull strength")
	TIPS.Smooth=T("نعومة الحركة","Movement smoothness")
	TIPS.AimDist=T("أقصى مسافة للتصويب","Max aim distance")
	TIPS.WallCheck=T("تجاهل الأهداف خلف الجدران (3 أشعة)","Ignore targets behind walls (3 rays)")
	TIPS.StickyTarget=T("البقاء على الهدف حتى يختفي","Stay locked until target is gone")
	TIPS.ShowTargetInfo=T("بطاقة معلومات الهدف","Target info card")
	TIPS.FOV=T("نصف قطر دائرة التصويب","Aim circle radius")
	TIPS.ShowFOV=T("إظهار دائرة FOV","Show FOV circle")
	TIPS.FOVFilled=T("تعبئة الدائرة","Fill the circle")
	TIPS.FOVThick=T("سماكة الدائرة","Circle thickness")
	TIPS.FOVTrans=T("شفافية الدائرة","Circle transparency")
	TIPS.FOVColor=T("لون الدائرة","Circle color")
	TIPS.Prediction=T("توقع حركة الهدف","Predict target movement")
	TIPS.PredTime=T("زمن التوقع بالثواني","Prediction time in seconds")
	TIPS.AutoFire=T("ضغط الإطلاق عند التقاء الكاميرا بالهدف","Fire when crosshair reaches target")
	TIPS.AutoFireAngle=T("زاوية السماح للإطلاق","Auto-fire angle tolerance")
	TIPS.Hysteresis=T("حاجز تغيير الهدف (أعلى = أثبت)","Target-switch threshold (higher = stickier)")
	TIPS.FlySpeed=T("سرعة الطيران","Flight speed")
	TIPS.FlyStopDist=T("المسافة التي يتوقف عندها","Stop distance from target")
	TIPS.FlySafe=T("تعطيل التصادم أثناء الطيران","Disable collisions while flying")
	TIPS.FlyCurve=T("مسار منحني بدل خط مستقيم","Curved path instead of straight")
	TIPS.FlyThroughWalls=T("اختراق الجدران (عند إيقاف الوضع الآمن)","Pass through walls (when Safe is off)")
	TIPS.FlyAvoid=T("الارتفاع تلقائياً فوق العوائق","Auto-climb over obstacles")
	TIPS.FlySmooth=T("زمن تنعيم السرعة","Velocity smoothing time")
	TIPS.FlyArc=T("ارتفاع قوس المسار المنحني","Curve arc height")
	TIPS.HUD=T("لوحة صغيرة أثناء الطيران","Small flight HUD")
	TIPS.Notify=T("إشعار عند ظهور ضب نادر","Alert on rare spawn")
	TIPS.NotifyMin=T("أقل ندرة تُرسل إشعاراً","Minimum rarity for alerts")
	TIPS.SoundAlert=T("صوت عند ظهور نادر","Sound on rare spawn")
	TIPS.Accent=T("لون الواجهة","Interface accent color")
	TIPS.UIScale=T("حجم الواجهة","Interface scale")
	TIPS.UITrans=T("شفافية الخلفية","Background transparency")
	TIPS.Theme=T("مظهر داكن / فاتح","Dark / Light theme")
	TIPS.Watermark=T("شريط FPS والبنق في الزاوية","FPS/Ping watermark")
	TIPS.ToggleKey=T("زر إظهار/إخفاء الواجهة","Show/hide key")
	TIPS.AimKey=T("زر تصويب إضافي (بجانب الزر الأيمن)","Extra aim key (besides RMB)")
	TIPS.FlyKey=T("زر الطيران لأقرب ضب","Fly-to-nearest key")
	TIPS.StopKey=T("زر إيقاف الطيران","Stop-flight key")
end
local tipLabel=new("TextLabel",{AutomaticSize=Enum.AutomaticSize.XY,BackgroundColor3=PANEL3,TextColor3=TXT,Font=Enum.Font.GothamMedium,
	TextSize=12,Visible=false,ZIndex=60,Size=UDim2.fromOffset(0,0)},gui)
corner(tipLabel,8); new("UIPadding",{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),PaddingTop=UDim.new(0,5),PaddingBottom=UDim.new(0,5)},tipLabel)
stroke(tipLabel,1,0.4)
local function attachTip(f,key)
	if not key or not TIPS[key] then return end
	f.MouseEnter:Connect(function() tipLabel.Text=L(TIPS[key]); tipLabel.Visible=true end)
	f.MouseMoved:Connect(function(x,y)
		local vs=Cam.ViewportSize
		tipLabel.Position=UDim2.fromOffset(math.min(x+14,vs.X-tipLabel.AbsoluteSize.X-6),math.min(y+18,vs.Y-tipLabel.AbsoluteSize.Y-6))
	end)
	f.MouseLeave:Connect(function() tipLabel.Visible=false end)
end

local pages, tabs = {}, {}
local curPage="home"
local function showPage(id)
	curPage=id
	for k,p in pairs(pages) do p.Visible=(k==id) end
	for k,t in pairs(tabs) do
		tween(t.btn,{BackgroundColor3=(k==id) and ACC() or SIDE,BackgroundTransparency=(k==id) and 0.82 or 1},0.15)
		tween(t.btn,{TextColor3=(k==id) and ACC() or SUB},0.15)
		t.bar.Visible=(k==id)
	end
	pageScale.Scale=0.97; tween(pageScale,{Scale=1},0.2)
end

local function makePage(id,icon,label,listMode)
	local b=new("TextButton",{Size=UDim2.new(1,-16,0,IsMobile and 28 or 34),BackgroundColor3=SIDE,BackgroundTransparency=1,AutoButtonColor=false,
		Font=Enum.Font.GothamBold,TextSize=IsMobile and 12 or 13,TextColor3=SUB,TextXAlignment=Enum.TextXAlignment.Left},side)
	corner(b,10); new("UIPadding",{PaddingLeft=UDim.new(0,14)},b)
	local bar=new("Frame",{Size=UDim2.fromOffset(3,18),Position=UDim2.new(0,-6,0.5,-9),Visible=false,BackgroundColor3=ACC(),BorderSizePixel=0},b)
	accent(bar,"BackgroundColor3"); corner(bar,2)
	b.MouseEnter:Connect(function() if curPage~=id then tween(b,{BackgroundTransparency=0.6,BackgroundColor3=PANEL},0.12) end end)
	b.MouseLeave:Connect(function() if curPage~=id then tween(b,{BackgroundTransparency=1},0.12) end end)
	reg(function() b.Text=L(label) end)
	local p=new("ScrollingFrame",{Size=UDim2.new(1,-14,1,-12),Position=UDim2.fromOffset(7,6),BackgroundTransparency=1,
		ScrollBarThickness=3,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),Visible=false,BorderSizePixel=0},content)
	accent(p,"ScrollBarImageColor3")
	if listMode then
		new("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder},p)
	else
		new("UIListLayout",{Padding=UDim.new(0,16),SortOrder=Enum.SortOrder.LayoutOrder},p)
	end
	new("UIPadding",{PaddingRight=UDim.new(0,6),PaddingBottom=UDim.new(0,6)},p)
	pages[id]=p; tabs[id]={btn=b,bar=bar}
	b.MouseButton1Click:Connect(function() if U.debounce(b) then showPage(id) end end)
	return p
end

--==================== المكوّنات ====================
local order=0
local function nextOrder() order+=1; return order end
local curSec = setmetatable({},{__mode="k"})
local function makeSection(page,titleT)
	local sec=new("Frame",{Size=UDim2.new(1,-4,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,LayoutOrder=nextOrder()},page)
	new("UIListLayout",{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder},sec)
	if titleT then
		local row=new("Frame",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,LayoutOrder=0},sec)
		local dot=new("Frame",{Size=UDim2.fromOffset(4,14),Position=UDim2.fromOffset(0,3),BackgroundColor3=ACC(),BorderSizePixel=0},row)
		accent(dot,"BackgroundColor3"); corner(dot,2)
		local t=new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,0),Size=UDim2.new(1,-12,1,0),Font=Enum.Font.GothamBlack,TextSize=12,
			TextColor3=SUB,TextXAlignment=Enum.TextXAlignment.Left},row)
		reg(function() t.Text=string.upper(L(titleT)) end)
	end
	local g=new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,LayoutOrder=1},sec)
	new("UIGridLayout",{CellPadding=UDim2.fromOffset(8,8),CellSize=UDim2.new(0.5,-4,0,48),SortOrder=Enum.SortOrder.LayoutOrder},g)
	curSec[page]=g
	return g
end
local function host(page)
	return curSec[page] or makeSection(page,nil)
end
local function cell(page,full) local f=new("Frame",{BackgroundColor3=PANEL,LayoutOrder=nextOrder()},host(page)); corner(f,12); new("UIStroke",{Color=PANEL3,Thickness=1,Transparency=0.6},f);
	if full then f.Size=UDim2.new(1,-4,0,46) end
	return f
end

local function Toggle(page,label,field,cb)
	local f=cell(page)
	attachTip(f,field)
	local t=new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,0),Size=UDim2.new(1,-72,1,0),
		Font=Enum.Font.GothamMedium,TextSize=13,TextColor3=TXT,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd},f)
	reg(function() t.Text=L(label) end)
	local b=new("TextButton",{Size=UDim2.fromOffset(44,24),Position=UDim2.new(1,-54,0.5,-12),Text="",AutoButtonColor=false},f)
	corner(b,12)
	local k=new("Frame",{Size=UDim2.fromOffset(18,18),BackgroundColor3=TXT,BorderSizePixel=0},b); corner(k,9)
	local function draw()
		local on=S[field]
		tween(b,{BackgroundColor3=on and ACC() or PANEL2})
		tween(k,{Position=on and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3),BackgroundColor3=on and Color3.new(1,1,1) or SUB})
	end
	b.MouseButton1Click:Connect(function()
		if not U.debounce(b) then return end
		S[field]=not S[field]; draw(); if cb then cb(S[field]) end
	end)
	draw(); table.insert(texts,draw)
	return draw
end

local function Slider(page,label,field,min,max,step,suffix)
	local f=cell(page)
	attachTip(f,field)
	local t=new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,5),Size=UDim2.new(1,-20,0,18),
		Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=TXT,TextXAlignment=Enum.TextXAlignment.Left},f)
	local val=new("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(1,-84,0,5),Size=UDim2.fromOffset(72,18),
		Font=Enum.Font.GothamBold,TextSize=12,TextXAlignment=Enum.TextXAlignment.Right},f)
	accent(val,"TextColor3")
	local bar=new("Frame",{Size=UDim2.new(1,-24,0,6),Position=UDim2.new(0,12,1,-15),BackgroundColor3=PANEL2,BorderSizePixel=0},f); corner(bar,3)
	local fill=new("Frame",{Size=UDim2.fromScale(0,1),BackgroundColor3=ACC(),BorderSizePixel=0},bar); accent(fill,"BackgroundColor3"); corner(fill,3)
	local knob=new("Frame",{Size=UDim2.fromOffset(14,14),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0,0.5),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0},bar); corner(knob,7)
	stroke(knob,2,0.3)
	local function draw()
		local a=math.clamp((S[field]-min)/(max-min),0,1)
		fill.Size=UDim2.fromScale(a,1); knob.Position=UDim2.fromScale(a,0.5)
		t.Text=L(label)
		val.Text=(step<1 and string.format("%.2f",S[field]) or tostring(S[field]))..(suffix or "")
	end
	reg(draw)
	local drag=false
	local hit=new("TextButton",{BackgroundTransparency=1,Text="",Size=UDim2.new(1,0,0,24),Position=UDim2.new(0,0,1,-24)},f)
	local function set(x)
		local a=math.clamp((x-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
		S[field]=math.clamp(math.floor((min+a*(max-min))/step+0.5)*step,min,max)
		draw()
	end
	hit.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true; U.sliding=true; set(i.Position.X) end
	end)
	UIS.InputChanged:Connect(function(i)
		if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then set(i.Position.X) end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false; U.sliding=false end
	end)
	return draw
end

local function Cycle(page,label,field,options,display,cb)
	local f=cell(page)
	attachTip(f,field)
	local t=new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,0),Size=UDim2.new(0.5,0,1,0),
		Font=Enum.Font.GothamMedium,TextSize=13,TextColor3=TXT,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd},f)
	local b=new("TextButton",{Size=UDim2.new(0.5,-16,0,28),Position=UDim2.new(0.5,6,0.5,-14),BackgroundColor3=PANEL2,
		Font=Enum.Font.GothamBold,TextSize=12,AutoButtonColor=false},f)
	accent(b,"TextColor3"); corner(b,9)
	b.MouseEnter:Connect(function() tween(b,{BackgroundColor3=PANEL3}) end)
	b.MouseLeave:Connect(function() tween(b,{BackgroundColor3=PANEL2}) end)
	local function draw() t.Text=L(label); b.Text=display and display(S[field]) or tostring(S[field]) end
	reg(draw)
	b.MouseButton1Click:Connect(function()
		if not U.debounce(b) then return end
		local i=table.find(options,S[field]) or 0
		S[field]=options[i%#options+1]; draw()
		if cb then cb(S[field]) end
	end)
end

local function Button(page,label,cb,tip)
	local b=new("TextButton",{BackgroundColor3=PANEL,Font=Enum.Font.GothamBold,TextSize=13,AutoButtonColor=false,LayoutOrder=nextOrder()},host(page))
	accent(b,"TextColor3"); corner(b,12); new("UIStroke",{Color=PANEL3,Thickness=1,Transparency=0.6},b)
	local fn=function() b.Text=type(label)=="function" and label() or L(label) end
	reg(fn); if type(label)=="function" then table.insert(dyn,fn) end
	attachTip(b,tip)
	b.MouseEnter:Connect(function() tween(b,{BackgroundColor3=PANEL2},0.15) end)
	b.MouseLeave:Connect(function() tween(b,{BackgroundColor3=PANEL},0.15) end)
	b.MouseButton1Click:Connect(function()
		if not U.debounce(b) then return end
		tween(b,{BackgroundColor3=PANEL3},0.06); task.delay(0.12,function() tween(b,{BackgroundColor3=PANEL}) end)
		cb(b)
	end)
	return b
end

local function Header(page,label) makeSection(page,label) end

local function RarityPicker(page,tbl)
	for _,r in ipairs(CONFIG.RarityOrder) do
		local b=new("TextButton",{Font=Enum.Font.GothamBold,TextSize=12,AutoButtonColor=false,LayoutOrder=nextOrder()},host(page))
		corner(b,12)
		local function draw()
			local on=tbl[r]
			b.BackgroundColor3=on and CONFIG.RarityColors[r] or PANEL
			b.TextColor3=on and Color3.fromRGB(11,11,14) or SUB
			b.Text=(on and "" or "")..RName(r)
		end
		reg(draw)
		b.MouseEnter:Connect(function() if not tbl[r] then tween(b,{BackgroundColor3=PANEL2},0.15) end end)
		b.MouseLeave:Connect(function() if not tbl[r] then tween(b,{BackgroundColor3=PANEL},0.15) end end)
		b.MouseButton1Click:Connect(function() if U.debounce(b) then tbl[r]=not tbl[r]; draw() end end)
	end
end

local function TextBoxCell(page)
	local f=cell(page)
	local tb=new("TextBox",{Size=UDim2.new(1,-16,1,-14),Position=UDim2.fromOffset(8,7),BackgroundColor3=PANEL2,Font=Enum.Font.Code,TextSize=11,
		TextColor3=TXT,PlaceholderColor3=SUB,ClearTextOnFocus=false,TextTruncate=Enum.TextTruncate.AtEnd,TextXAlignment=Enum.TextXAlignment.Left,Text=""},f)
	corner(tb,8); new("UIPadding",{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8)},tb)
	return tb
end

--==================== الإشعارات ====================
local notifHolder=new("Frame",{Size=UDim2.fromOffset(290,400),Position=UDim2.new(1,-300,0,58),BackgroundTransparency=1,ZIndex=300},gui)
new("UIListLayout",{Padding=UDim.new(0,8)},notifHolder)

notify=function(text,color)
	local col=color or ACC()
	local n=new("Frame",{Size=UDim2.new(1,0,0,0),BackgroundColor3=PANEL,BackgroundTransparency=0.02,ClipsDescendants=true},notifHolder)
	corner(n,12)
	local s=new("UIStroke",{Color=col,Thickness=1.5,Transparency=0.45},n)
	local bar=new("Frame",{Size=UDim2.new(0,4,1,0),BackgroundColor3=col,BorderSizePixel=0},n)
	local ico=new("Frame",{Size=UDim2.fromOffset(26,26),Position=UDim2.fromOffset(14,10),BackgroundColor3=col,BackgroundTransparency=0.75},n); corner(ico,13)
	new("TextLabel",{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Font=Enum.Font.GothamBlack,TextSize=14,TextColor3=col,Text="!"},ico)
	local t=new("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(1,-56,1,-4),Position=UDim2.fromOffset(48,0),RichText=true,
		Font=Enum.Font.GothamBold,TextSize=13,TextColor3=TXT,Text=text,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left},n)
	local prog=new("Frame",{Size=UDim2.new(1,0,0,2),Position=UDim2.new(0,0,1,-2),BackgroundColor3=col,BorderSizePixel=0},n)
	tween(n,{Size=UDim2.new(1,0,0,46)},0.3)
	tween(prog,{Size=UDim2.new(0,0,0,2)},3.5)
	task.delay(3.5,function()
		tween(n,{Size=UDim2.new(1,0,0,0),BackgroundTransparency=1},0.3)
		tween(s,{Transparency=1},0.3); tween(t,{TextTransparency=1},0.3)
		task.wait(0.35); pcall(n.Destroy,n)
	end)
end

--==================== تبديل الثيم (Dark/Light) ====================
local function applyTheme(name)
	if not THEMES[name] or name==curTheme then return end
	local old={}; for k,v in pairs(Th) do old[k]=v end
	for k,v in pairs(THEMES[name]) do Th[k]=v end
	syncPal(); curTheme=name
	local map={}
	for k,v in pairs(old) do table.insert(map,{v,Th[k]}) end
	local function conv(c) for _,p in ipairs(map) do if c==p[1] then return p[2] end end return c end
	for _,o in ipairs(gui:GetDescendants()) do
		pcall(function()
			if o:IsA("GuiObject") then
				o.BackgroundColor3=conv(o.BackgroundColor3)
				if o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox") then
					o.TextColor3=conv(o.TextColor3)
					if o:IsA("TextBox") then o.PlaceholderColor3=conv(o.PlaceholderColor3) end
				end
			elseif o:IsA("UIStroke") then
				o.Color=conv(o.Color)
			end
		end)
	end
	for _,f in ipairs(texts) do pcall(f) end
	repaint()
	showPage(curPage)
end

--==================== الصفحات ====================
local PG={}
PG.home=makePage("home","",{ar="الرئيسية",en="Home"})
PG.esp=makePage("esp","",{ar="الإضاءة",en="ESP"})
PG.aim=makePage("aim","",{ar="التصويب",en="Aim"})
PG.silent=makePage("silent","",{ar="القوة الخارقة",en="Superpower"})
PG.tp=makePage("tp","",{ar="الطيران",en="Fly"})
PG.player=makePage("player","",{ar="اللاعب",en="Player"})
PG.list=makePage("list","",{ar="القائمة",en="Targets"},true)
PG.ign=makePage("ignore","",{ar="تجاهل",en="Ignore"})
PG.radar=makePage("radar","",{ar="الرادار",en="Radar"})
PG.log=makePage("log","",{ar="السجل",en="Log"},true)
PG.vis=makePage("vis","",{ar="المظهر",en="Visuals"})
PG.bind=makePage("bind","",{ar="المفاتيح",en="Keybinds"})
PG.prof=makePage("prof","",{ar="الملفات",en="Profiles"})
PG.set=makePage("set","",{ar="الإعدادات",en="Settings"})
PG.help=makePage("help","",{ar="مساعدة",en="Help"},true)

local badge=new("Frame",{Size=UDim2.fromOffset(22,16),Position=UDim2.new(1,-28,0.5,-8),BackgroundColor3=ACC(),BorderSizePixel=0,Visible=false},tabs.list.btn)
accent(badge,"BackgroundColor3"); corner(badge,8)
local badgeLbl=new("TextLabel",{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Font=Enum.Font.GothamBlack,TextSize=10,
	TextColor3=Color3.fromRGB(11,11,14),Text="0"},badge)

local function infoBox(page)
	local t=new("TextLabel",{BackgroundColor3=PANEL,Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=TXT,RichText=true,
		TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,LayoutOrder=nextOrder()},host(page))
	corner(t,12); new("UIPadding",{PaddingLeft=UDim.new(0,12),PaddingTop=UDim.new(0,8),PaddingRight=UDim.new(0,8),PaddingBottom=UDim.new(0,8)},t)
	new("UIStroke",{Color=PANEL3,Thickness=1,Transparency=0.6},t)
	return t
end

local homeInfo,homeTarget,statsBox,profileBox,targetListUpdate,welcomeUpdate

--==================== مفاتيح الاختصار ====================
local capturing=false
local RESERVED={Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.S,Enum.KeyCode.D,Enum.KeyCode.Space,Enum.KeyCode.Tab,Enum.KeyCode.Escape,Enum.KeyCode.Slash}
local BIND_FIELDS={"ToggleKey","AimKey","FlyKey","StopKey"}
function U.keyTaken(kc,except)
	for _,k in ipairs(RESERVED) do if k==kc then return true end end
	for _,f in ipairs(BIND_FIELDS) do if f~=except and S[f]==kc then return true end end
	return false
end
function U.reservedText()
	local t={}
	for _,k in ipairs(RESERVED) do table.insert(t,k.Name) end
	for _,f in ipairs(BIND_FIELDS) do if S[f]~=Enum.KeyCode.Unknown then table.insert(t,S[f].Name.."*") end end
	table.insert(t,"MouseButton2*")
	return table.concat(t,", ")
end
local function Keybind(page,label,field,relaxed)
	local f=cell(page)
	attachTip(f,field)
	local t=new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,0),Size=UDim2.new(0.5,0,1,0),
		Font=Enum.Font.GothamMedium,TextSize=13,TextColor3=TXT,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd},f)
	local b=new("TextButton",{Size=UDim2.new(0.5,-16,0,28),Position=UDim2.new(0.5,6,0.5,-14),BackgroundColor3=PANEL2,
		Font=Enum.Font.GothamBold,TextSize=12,AutoButtonColor=false},f)
	accent(b,"TextColor3"); corner(b,9)
	local function draw()
		t.Text=L(label)
		b.Text=(S[field]==Enum.KeyCode.Unknown) and L({ar="— بدون —",en="— None —"}) or S[field].Name
	end
	reg(draw)
	b.MouseButton1Click:Connect(function()
		if capturing or not U.debounce(b) then return end
		capturing=true
		b.Text=L({ar="اضغط زر... (Esc إلغاء)",en="Press key... (Esc cancel)"})
		local c; c=UIS.InputBegan:Connect(function(i)
			if i.UserInputType~=Enum.UserInputType.Keyboard then return end
			c:Disconnect()
			local kc=i.KeyCode
			if kc==Enum.KeyCode.Escape then
			elseif kc==Enum.KeyCode.Backspace and field~="ToggleKey" then S[field]=Enum.KeyCode.Unknown
			elseif (not relaxed) and U.keyTaken(kc,field) then
				notify(L({ar="الزر محجوز: ",en="Key reserved: "})..kc.Name,Color3.fromRGB(230,60,60))
			else S[field]=kc end
			task.delay(0.1,function() capturing=false end)
			for _,fn in ipairs(texts) do pcall(fn) end
		end)
	end)
end

--==================== الملفات الشخصية ====================
function U.serialize()
	local out={}
	for k,v in pairs(S) do
		if string.sub(k,1,1)~="_" and k~="AimActive" and k~="FlyActive" and k~="Search" then
			local t=typeof(v)
			if t=="number" or t=="boolean" or t=="string" then out[k]=v
			elseif t=="EnumItem" then out[k]="KC:"..v.Name
			elseif t=="table" then local c={}; for a,b in pairs(v) do c[a]=b end; out[k]=c end
		end
	end
	return HttpService:JSONEncode(out)
end
function U.deserialize(str)
	local ok,data=pcall(function() return HttpService:JSONDecode(str) end)
	if not ok or type(data)~="table" then return false end
	for k,v in pairs(data) do
		local cur=S[k]
		if cur~=nil and string.sub(k,1,1)~="_" then
			local ct=typeof(cur)
			if ct=="EnumItem" then
				if type(v)=="string" and string.sub(v,1,3)=="KC:" then
					local ok2,kc=pcall(function() return Enum.KeyCode[string.sub(v,4)] end)
					if ok2 and kc then S[k]=kc end
				end
			elseif ct=="table" then
				if type(v)=="table" then for a,b in pairs(v) do if cur[a]~=nil then cur[a]=(b==true) end end end
			elseif type(v)==ct then S[k]=v end
		end
	end
	for f,opts in pairs(OPTS) do if not table.find(opts,S[f]) then S[f]=DEF[f] end end
	S.Accent=math.clamp(math.floor(S.Accent),1,#ACCENTS)
	S.FOVColor=math.clamp(math.floor(S.FOVColor),1,#ACCENTS)
	S.UIScale=math.clamp(S.UIScale,0.6,1.4)
	scale.Scale=S.UIScale
	applyTheme(S.Theme); repaint()
	for _,fn in ipairs(texts) do pcall(fn) end
	return true
end

function U.rejoin()
	notify(L({ar="جارٍ إعادة الدخول...",en="Rejoining..."}))
	pcall(function()
		if #Players:GetPlayers()<=1 then TeleportService:Teleport(game.PlaceId,LP)
		else TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LP) end
	end)
end
function U.serverHop()
	notify(L({ar="جارٍ البحث عن سيرفر جديد...",en="Looking for a new server..."}))
	task.spawn(function()
		local found
		pcall(function()
			local url="https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
			local body
			local ok=pcall(function() body=game:HttpGet(url) end)
			if not ok or not body then body=HttpService:GetAsync(url) end
			local data=HttpService:JSONDecode(body)
			for _,sv in ipairs(data.data or {}) do
				if sv.id~=game.JobId and sv.playing and sv.maxPlayers and sv.playing<sv.maxPlayers then found=sv.id break end
			end
		end)
		if found then
			pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId,found,LP) end)
		else
			notify(L({ar="تعذر جلب السيرفرات، محاولة انتقال عادي",en="Server list unavailable, plain teleport"}),Color3.fromRGB(240,110,110))
			pcall(function() TeleportService:Teleport(game.PlaceId,LP) end)
		end
	end)
end

--==================== بناء الصفحات ====================
do
	-- Welcome (full screen)
	do
		local CWd=math.clamp(Cam.ViewportSize.X-48,300,720)
		local ov=new("Frame",{Name="Welcome",Size=UDim2.fromScale(1,1),BackgroundColor3=BG,ZIndex=200,Visible=false,Active=true},gui)
		U.welcome=ov
		local glow=new("Frame",{Size=UDim2.fromScale(1,0.6),BackgroundColor3=ACC(),BorderSizePixel=0},ov)
		accent(glow,"BackgroundColor3")
		new("UIGradient",{Rotation=90,Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,0.8),NumberSequenceKeypoint.new(1,1)}},glow)
		U.makeStars(ov,40)
		local sc=new("ScrollingFrame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ScrollBarThickness=3,AutomaticCanvasSize=Enum.AutomaticSize.Y,
			CanvasSize=UDim2.new(),BorderSizePixel=0},ov)
		accent(sc,"ScrollBarImageColor3")
		new("UIListLayout",{Padding=UDim.new(0,12),HorizontalAlignment=Enum.HorizontalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder},sc)
		new("UIPadding",{PaddingTop=UDim.new(0,IsMobile and 14 or 40),PaddingBottom=UDim.new(0,30)},sc)
		local wo=0
		local function wn() wo+=1; return wo end
		local function panel(h)
			local f=new("Frame",{Size=UDim2.fromOffset(CWd,h),BackgroundColor3=PANEL,LayoutOrder=wn()},sc)
			corner(f,14); new("UIStroke",{Color=PANEL3,Thickness=1,Transparency=0.55},f)
			return f
		end

		-- hero
		local hero=new("Frame",{Size=UDim2.fromOffset(CWd,IsMobile and 204 or 250),BackgroundTransparency=1,LayoutOrder=wn()},sc)
		local avs=IsMobile and 70 or 100
		local av=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,0),Size=UDim2.fromOffset(avs,avs),BackgroundColor3=PANEL2},hero)
		corner(av,avs/2); stroke(av,3,0.1); table.insert(U.avatars,av)
		local ty=avs+10
		local title=new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(0,ty),Size=UDim2.new(1,0,0,IsMobile and 34 or 44),
			Font=Enum.Font.GothamBlack,TextSize=IsMobile and 28 or 44,TextColor3=Color3.new(1,1,1)},hero)
		local greet=new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(0,ty+(IsMobile and 36 or 48)),Size=UDim2.new(1,0,0,22),
			Font=Enum.Font.GothamBold,TextSize=15,TextColor3=TXT},hero)
		local sub=new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(0,ty+(IsMobile and 60 or 72)),Size=UDim2.new(1,0,0,18),
			Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=SUB},hero)
		local tg=new("UIGradient",{},title); U.titleGrad=tg
		local hp=new("Frame",{BackgroundTransparency=1,AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,ty+(IsMobile and 86 or 100)),Size=UDim2.fromOffset(300,22)},hero)
		new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Center,Padding=UDim.new(0,8)},hp)
		for _,txt in ipairs({"BETA","PREMIUM","VERIFIED"}) do
			local pl=new("TextLabel",{Size=UDim2.fromOffset(#txt*8+22,22),BackgroundTransparency=0.8,Font=Enum.Font.GothamBlack,TextSize=10,Text=txt},hp)
			accent(pl,"BackgroundColor3"); accent(pl,"TextColor3"); corner(pl,11)
		end
		reg(function()
			tg.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,ACC()),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(15,45,160)),ColorSequenceKeypoint.new(1,ACC())}
			local h=tonumber(os.date("%H")) or 12
			local g=h<12 and L({ar="صباح الخير",en="Good morning"}) or (h<18 and L({ar="مساء الخير",en="Good afternoon"}) or L({ar="طاب مساؤك",en="Good evening"}))
			title.Text="VØX SCRIPT"
			greet.Text=g..", "..LP.DisplayName
			sub.Text=L({ar="أداة الضبان الاحترافية",en="The professional dhab toolkit"})
		end)

		-- stats
		local row=new("Frame",{Size=UDim2.fromOffset(CWd,76),BackgroundTransparency=1,LayoutOrder=wn()},sc)
		new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder},row)
		local sv,st={},{}
		for i=1,4 do
			local f=new("Frame",{Size=UDim2.new(0.25,-6,1,0),BackgroundColor3=PANEL,LayoutOrder=i},row)
			corner(f,14); new("UIStroke",{Color=PANEL3,Thickness=1,Transparency=0.55},f)
			sv[i]=new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(0,12),Size=UDim2.new(1,0,0,30),Font=Enum.Font.GothamBlack,
				TextSize=IsMobile and 20 or 26,Text="0"},f)
			accent(sv[i],"TextColor3")
			st[i]=new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(0,46),Size=UDim2.new(1,0,0,18),Font=Enum.Font.GothamMedium,
				TextSize=11,TextColor3=SUB},f)
		end
		reg(function()
			st[1].Text=L({ar="إجمالي الضبان",en="Total dhabs"}); st[2].Text=L({ar="ضمن المدى",en="In range"})
			st[3].Text=L({ar="أحياء",en="Alive"}); st[4].Text=L({ar="الإطارات",en="FPS"})
		end)

		-- rarity distribution
		local rb=panel(86)
		local rbt=new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(16,10),Size=UDim2.new(1,-32,0,16),Font=Enum.Font.GothamBold,
			TextSize=12,TextColor3=TXT,TextXAlignment=Enum.TextXAlignment.Left},rb)
		local rbar=new("Frame",{Position=UDim2.fromOffset(16,32),Size=UDim2.new(1,-32,0,10),BackgroundColor3=PANEL2,BorderSizePixel=0,ClipsDescendants=true},rb)
		corner(rbar,5)
		local segs={}
		for _,r in ipairs(CONFIG.RarityOrder) do
			segs[r]=new("Frame",{BackgroundColor3=CONFIG.RarityColors[r],BorderSizePixel=0,Size=UDim2.fromScale(0,1)},rbar)
		end
		local rbl=new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(16,48),Size=UDim2.new(1,-32,0,30),Font=Enum.Font.GothamMedium,TextSize=11,
			TextColor3=SUB,RichText=true,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top},rb)
		reg(function() rbt.Text=L({ar="توزيع الندرة",en="Rarity distribution"}) end)

		-- modules
		local modPills={}
		local mpn=panel(IsMobile and 110 or 100)
		local mg=new("Frame",{Size=UDim2.new(1,-24,1,-20),Position=UDim2.fromOffset(12,10),BackgroundTransparency=1},mpn)
		new("UIGridLayout",{CellPadding=UDim2.fromOffset(8,8),CellSize=UDim2.new(1/3,-6,0,34),SortOrder=Enum.SortOrder.LayoutOrder},mg)
		local modList={
			{{ar="الإضاءة",en="ESP"},function() return S.ESP end},
			{{ar="التصويب",en="Aim"},function() return S.Aim end},
			{{ar="الصامت",en="Silent"},function() return S.SilentAim end},
			{{ar="السحرية",en="Magic"},function() return S.MagicBullet end},
			{{ar="الرادار",en="Radar"},function() return S.Radar end},
			{{ar="طيران تلقائي",en="Auto-fly"},function() return S.AutoFly end},
		}
		for i,mo in ipairs(modList) do
			local pf=new("Frame",{BackgroundColor3=PANEL2,LayoutOrder=i},mg); corner(pf,10)
			local dot=new("Frame",{Size=UDim2.fromOffset(8,8),Position=UDim2.new(0,10,0.5,-4),BackgroundColor3=PANEL3,BorderSizePixel=0},pf); corner(dot,4)
			local lb=new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(26,0),Size=UDim2.new(1,-30,1,0),Font=Enum.Font.GothamBold,TextSize=11,
				TextColor3=SUB,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd},pf)
			table.insert(modPills,{name=mo[1],fn=mo[2],dot=dot,lbl=lb})
		end

		-- quick actions
		local qa=new("Frame",{Size=UDim2.fromOffset(CWd,46),BackgroundTransparency=1,LayoutOrder=wn()},sc)
		new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder},qa)
		local qb={}
		local function qbtn(i,cb)
			local b=new("TextButton",{Size=UDim2.new(0.25,-6,1,0),BackgroundColor3=PANEL,Font=Enum.Font.GothamBold,TextSize=IsMobile and 11 or 12,
				AutoButtonColor=false,LayoutOrder=i},qa)
			corner(b,12); new("UIStroke",{Color=PANEL3,Thickness=1,Transparency=0.55},b)
			b.MouseEnter:Connect(function() tween(b,{BackgroundColor3=PANEL2},0.15) end)
			b.MouseLeave:Connect(function() tween(b,{BackgroundColor3=PANEL},0.15) end)
			b.MouseButton1Click:Connect(function() if U.debounce(b) then cb() end end)
			qb[i]=b
		end
		qbtn(1,function() S.ESP=not S.ESP; for _,f in ipairs(texts) do pcall(f) end end)
		qbtn(2,function() S.Aim=not S.Aim; for _,f in ipairs(texts) do pcall(f) end end)
		qbtn(3,function() U.hideWelcome(); flyTo(nearestOf()) end)
		qbtn(4,function() U.hideWelcome(); flyTo(bestRarity()) end)

		-- tips
		local tp=panel(IsMobile and 150 or 140)
		local tt=new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(16,10),Size=UDim2.new(1,-32,1,-20),Font=Enum.Font.GothamMedium,
			TextSize=12,TextColor3=TXT,RichText=true,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top},tp)
		reg(function()
			tt.Text=table.concat({
				"<b>"..L({ar="بداية سريعة",en="Quick start"}).."</b>",
				L({ar="- اضغط <b>"..S.ToggleKey.Name.."</b> لإظهار أو إخفاء الواجهة",en="- Press <b>"..S.ToggleKey.Name.."</b> to show or hide the UI"}),
				L({ar="- <b>كليك يمين</b> لتفعيل التصويب (زر AIM على الجوال)",en="- <b>Right click</b> to aim (AIM button on mobile)"}),
				L({ar="- من صفحة <b>الطيران</b> اختر ضب واضغط Go",en="- Open <b>Fly</b> and press Go on any dhab"}),
				L({ar="- صفحة <b>الرادار</b> تعرض مواقع الضبان حولك",en="- The <b>Radar</b> page shows dhabs around you"}),
				L({ar="- احفظ إعداداتك من صفحة <b>الملفات</b>",en="- Save your settings in the <b>Profiles</b> page"}),
			},"\n")
		end)

		-- enter
		local go=new("TextButton",{Size=UDim2.fromOffset(CWd,54),BackgroundColor3=ACC(),Font=Enum.Font.GothamBlack,TextSize=16,
			TextColor3=Color3.new(1,1,1),AutoButtonColor=false,LayoutOrder=wn()},sc)
		accent(go,"BackgroundColor3"); corner(go,14)
		reg(function() go.Text=L({ar="دخول",en="ENTER"}) end)
		go.MouseButton1Click:Connect(function() if U.debounce(go) then U.hideWelcome() end end)

		-- language / theme
		local br=new("Frame",{Size=UDim2.fromOffset(CWd,36),BackgroundTransparency=1,LayoutOrder=wn()},sc)
		new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder},br)
		local function sbtn(i,cb)
			local b=new("TextButton",{Size=UDim2.new(0.5,-4,1,0),BackgroundColor3=PANEL,Font=Enum.Font.GothamBold,TextSize=12,TextColor3=SUB,
				AutoButtonColor=false,LayoutOrder=i},br)
			corner(b,10); new("UIStroke",{Color=PANEL3,Thickness=1,Transparency=0.55},b)
			b.MouseButton1Click:Connect(function() if U.debounce(b) then cb() end end)
			return b
		end
		local lb1=sbtn(1,function() S.Lang=S.Lang=="ar" and "en" or "ar"; for _,f in ipairs(texts) do pcall(f) end end)
		local lb2=sbtn(2,function() S.Theme=S.Theme=="Dark" and "Light" or "Dark"; applyTheme(S.Theme); for _,f in ipairs(texts) do pcall(f) end end)
		reg(function()
			lb1.Text=S.Lang=="ar" and "English" or "العربية"
			lb2.Text=L({ar="المظهر: ",en="Theme: "})..(S.Theme=="Dark" and L({ar="داكن",en="Dark"}) or L({ar="فاتح",en="Light"}))
		end)

		welcomeUpdate=function()
			sv[1].Text=tostring(Counts.total); sv[2].Text=tostring(Counts.inRange); sv[3].Text=tostring(Counts.alive); sv[4].Text=tostring(S._fps or 0)
			local on,off=L({ar="يعمل",en="ON"}),L({ar="متوقف",en="OFF"})
			qb[1].Text="ESP: "..(S.ESP and on or off); qb[1].TextColor3=S.ESP and ACC() or SUB
			qb[2].Text=L({ar="التصويب: ",en="Aim: "})..(S.Aim and on or off); qb[2].TextColor3=S.Aim and ACC() or SUB
			qb[3].Text=L({ar="طيران لأقرب ضب",en="Fly nearest"}); qb[3].TextColor3=ACC()
			qb[4].Text=L({ar="طيران لأندر ضب",en="Fly rarest"}); qb[4].TextColor3=ACC()
			local total,x,parts=Counts.total,0,{}
			for _,r in ipairs(CONFIG.RarityOrder) do
				local c=Counts.byRarity[r] or 0
				local w=total>0 and c/total or 0
				segs[r].Position=UDim2.fromScale(x,0); segs[r].Size=UDim2.fromScale(w,1); x+=w
				if c>0 then table.insert(parts,string.format("<font color='#%s'>%s %d</font>",CONFIG.RarityColors[r]:ToHex(),RName(r),c)) end
			end
			for _,mo in ipairs(modPills) do
				local isOn=mo.fn()
				mo.dot.BackgroundColor3=isOn and Color3.fromRGB(70,225,130) or PANEL3
				mo.lbl.Text=L(mo.name)..": "..(isOn and L({ar="يعمل",en="ON"}) or L({ar="متوقف",en="OFF"}))
				mo.lbl.TextColor3=isOn and TXT or SUB
			end
			rbl.Text=#parts>0 and table.concat(parts,"   ") or L({ar="لا يوجد ضبان",en="No dhabs found"})
		end
		welcomeUpdate()
		table.insert(texts,welcomeUpdate)

		U.showWelcome=function()
			ov.Visible=true; ov.BackgroundTransparency=1; sc.Position=UDim2.fromOffset(0,40)
			tween(ov,{BackgroundTransparency=0},0.35); tween(sc,{Position=UDim2.fromOffset(0,0)},0.4)
			pcall(welcomeUpdate)
			-- entrance: avatar pop, typewriter title, fade-in lines
			local avS=av:FindFirstChild("PopScale") or new("UIScale",{Name="PopScale"},av)
			avS.Scale=0.2; tween(avS,{Scale=1},0.55,Enum.EasingStyle.Back)
			for _,o in ipairs({greet,sub}) do o.TextTransparency=1; tween(o,{TextTransparency=0},0.7) end
			task.spawn(function()
				local n=utf8.len(title.Text) or 10
				for i=0,n do
					if not ov.Visible then break end
					title.MaxVisibleGraphemes=i; task.wait(0.045)
				end
				title.MaxVisibleGraphemes=-1
			end)
		end
		U.hideWelcome=function()
			tween(ov,{BackgroundTransparency=1},0.25); tween(sc,{Position=UDim2.fromOffset(0,30)},0.25)
			task.delay(0.26,function() ov.Visible=false end)
		end
	end

	homeInfo=infoBox(PG.home)
	homeTarget=infoBox(PG.home)
	Toggle(PG.home,{ar="تشغيل الإضاءة",en="Enable ESP"},"ESP")
	Toggle(PG.home,{ar="تشغيل التصويب",en="Enable Aim"},"Aim")
	Button(PG.home,{ar="طيران لأقرب ضب",en="Fly to nearest"},function() flyTo(nearestOf()) end)
	Button(PG.home,{ar="طيران لأندر ضب",en="Fly to rarest"},function() flyTo(bestRarity()) end)
	Button(PG.home,{ar="إيقاف الطيران",en="Stop flight"},function() stopFlight() end)
	Button(PG.home,{ar="شاشة الترحيب",en="Welcome screen"},function() U.showWelcome() end)

	-- الإضاءة
	Header(PG.esp,{ar="الإضاءة",en="Highlight"})
	Toggle(PG.esp,{ar="تشغيل",en="Enabled"},"ESP")
	Toggle(PG.esp,{ar="فوق الجدران",en="Always on top"},"AlwaysOnTop")
	Toggle(PG.esp,{ar="تعبئة",en="Fill"},"Fill")
	Toggle(PG.esp,{ar="حدود",en="Outline"},"Outline")
	Slider(PG.esp,{ar="شفافية التعبئة",en="Fill transparency"},"FillT",0,1,0.05)
	Slider(PG.esp,{ar="شفافية الحدود",en="Outline transparency"},"OutlineT",0,1,0.05)
	Slider(PG.esp,{ar="أقصى مسافة",en="Max distance"},"MaxDist",50,5000,50," m")
	Toggle(PG.esp,{ar="خطوط تتبع",en="Tracers"},"Tracers")
	Cycle(PG.esp,{ar="بداية الخط",en="Tracer from"},"TracerFrom",OPTS.TracerFrom,function(v)
		return L(({Bottom={ar="أسفل",en="Bottom"},Center={ar="وسط",en="Center"},Top={ar="أعلى",en="Top"}})[v]) end)
	Header(PG.esp,{ar="مؤثرات إضافية",en="Extra Effects"})
	Toggle(PG.esp,{ar="تلوين كامل (Chams)",en="Chams"},"Chams")
	Slider(PG.esp,{ar="شفافية Chams",en="Chams transparency"},"ChamsT",0,1,0.05)
	Toggle(PG.esp,{ar="شريط الصحة",en="Health bar"},"HealthBar")
	Toggle(PG.esp,{ar="تلاشي بالمسافة",en="Distance fade"},"DistFade")
	Toggle(PG.esp,{ar="سهم خارج الشاشة",en="Off-screen arrow"},"OffScreen")
	Toggle(PG.esp,{ar="إطار (Box)",en="Box ESP"},"Box")
	Header(PG.esp,{ar="العلامات",en="Labels"})
	Toggle(PG.esp,{ar="الاسم",en="Name"},"ShowName")
	Toggle(PG.esp,{ar="الندرة",en="Rarity"},"ShowRarity")
	Toggle(PG.esp,{ar="المسافة",en="Distance"},"ShowDist")
	Toggle(PG.esp,{ar="الصحة",en="Health"},"ShowHealth")
	Slider(PG.esp,{ar="حجم الخط",en="Text size"},"TextSize",8,28,1)
	Slider(PG.esp,{ar="ارتفاع العلامة",en="Label height"},"LabelHeight",0,10,0.5)
	Header(PG.esp,{ar="الندرات الظاهرة",en="Visible rarities"})
	RarityPicker(PG.esp,S.Rarities)

	-- التصويب
	Header(PG.aim,{ar="مساعد التصويب",en="Aim Assist"})
	Toggle(PG.aim,{ar="تشغيل",en="Enabled"},"Aim")
	Cycle(PG.aim,{ar="طريقة التفعيل",en="Activation"},"AimMode",OPTS.AimMode,function(v)
		return L(({Hold={ar="ضغط مستمر",en="Hold"},Toggle={ar="تبديل",en="Toggle"},Always={ar="دائماً",en="Always"}})[v]) end)
	Cycle(PG.aim,{ar="الأولوية",en="Priority"},"Priority",OPTS.Priority,function(v)
		return L(({Screen={ar="منتصف الشاشة",en="Screen"},Closest={ar="الأقرب",en="Closest"},Rarity={ar="الأندر",en="Rarest"}})[v]) end)
	Cycle(PG.aim,{ar="نقطة التصويب",en="Aim part"},"AimPart",OPTS.AimPart,function(v)
		return L(({Root={ar="الجسم",en="Body"},Head={ar="الرأس",en="Head"},Center={ar="المركز",en="Center"}})[v]) end)
	Slider(PG.aim,{ar="القوة",en="Strength"},"Strength",0.05,1,0.05)
	Slider(PG.aim,{ar="النعومة",en="Smoothness"},"Smooth",0.05,1,0.05)
	Slider(PG.aim,{ar="أقصى مسافة",en="Max distance"},"AimDist",50,5000,50," m")
	Toggle(PG.aim,{ar="فحص الجدران",en="Wall check"},"WallCheck")
	Toggle(PG.aim,{ar="تثبيت الهدف",en="Sticky target"},"StickyTarget")
	Toggle(PG.aim,{ar="معلومات الهدف",en="Target info"},"ShowTargetInfo")
	Header(PG.aim,{ar="تطويرات",en="Upgrades"})
	Toggle(PG.aim,{ar="توقع الحركة",en="Prediction"},"Prediction")
	Slider(PG.aim,{ar="زمن التوقع",en="Prediction time"},"PredTime",0,0.5,0.01," s")
	Toggle(PG.aim,{ar="إطلاق تلقائي",en="Auto-fire"},"AutoFire")
	Slider(PG.aim,{ar="زاوية الإطلاق",en="Fire angle"},"AutoFireAngle",0.5,10,0.5,"°")
	Slider(PG.aim,{ar="ثبات تغيير الهدف",en="Switch hysteresis"},"Hysteresis",0,1,0.05)
	Header(PG.aim,{ar="دائرة FOV",en="FOV Circle"})
	Slider(PG.aim,{ar="حجم FOV",en="FOV size"},"FOV",20,600,5," px")
	Toggle(PG.aim,{ar="إظهار الدائرة",en="Show circle"},"ShowFOV")
	Toggle(PG.aim,{ar="دائرة ممتلئة",en="Filled circle"},"FOVFilled")
	Slider(PG.aim,{ar="سماكة الدائرة",en="Thickness"},"FOVThick",1,6,0.5)
	Slider(PG.aim,{ar="شفافية الدائرة",en="Transparency"},"FOVTrans",0,1,0.05)
	Cycle(PG.aim,{ar="لون الدائرة",en="Circle color"},"FOVColor",{1,2,3,4,5,6},function(v) return ACCENTS[v].name end)
	Header(PG.aim,{ar="ندرات التصويب",en="Aim rarities"})
	RarityPicker(PG.aim,S.AimRarities)

	-- الطيران
	Header(PG.tp,{ar="نظام الطيران",en="Flight System"})
	Slider(PG.tp,{ar="سرعة الطيران",en="Fly speed"},"FlySpeed",20,600,10," m/s")
	Slider(PG.tp,{ar="مسافة التوقف",en="Stop distance"},"FlyStopDist",1,25,1," m")
	Toggle(PG.tp,{ar="وضع آمن (تعطيل التصادم)",en="Safe mode (no clip)"},"FlySafe")
	Toggle(PG.tp,{ar="مسار منحني",en="Curved path"},"FlyCurve")
	Slider(PG.tp,{ar="ارتفاع القوس",en="Arc height"},"FlyArc",0,1,0.05)
	Toggle(PG.tp,{ar="اختراق الجدران",en="Fly through walls"},"FlyThroughWalls")
	Toggle(PG.tp,{ar="تجنب العوائق",en="Obstacle avoid"},"FlyAvoid")
	Slider(PG.tp,{ar="تنعيم السرعة",en="Velocity smoothing"},"FlySmooth",0.05,1,0.05," s")
	Toggle(PG.tp,{ar="لوحة الطيران HUD",en="Flight HUD"},"HUD")
	Button(PG.tp,{ar="إيقاف الطيران",en="Stop flight"},function() stopFlight() end)

	Header(PG.tp,{ar="انتقال حسب الندرة",en="Fly by rarity"})
	for _,r in ipairs(CONFIG.RarityOrder) do
		local b=Button(PG.tp,function()
			return ""..RName(r).."  ("..(Counts.byRarity[r] or 0)..")"
		end,function()
			local m=nearestOf(function(d) return d.rarity==r end)
			if not m then notify((S.Lang=="ar" and "لا يوجد ضب " or "No ")..RName(r),Color3.fromRGB(230,60,60)) return end
			flyTo(m)
		end)
		for i,a in ipairs(accentObjs) do if a[1]==b and a[2]=="TextColor3" then table.remove(accentObjs,i) break end end
		b.TextColor3=CONFIG.RarityColors[r]
	end
	Header(PG.tp,{ar="سريع",en="Quick"})
	Button(PG.tp,{ar="أقرب ضب",en="Nearest"},function() flyTo(nearestOf()) end)
	Button(PG.tp,{ar="أندر ضب",en="Rarest"},function() flyTo(bestRarity()) end)
	local cycleIdx=0
	Button(PG.tp,{ar="الضب التالي",en="Next dhab"},function()
		local arr={}; for m in pairs(Tracked) do table.insert(arr,m) end
		if #arr==0 then notify(L({ar="لا يوجد ضبان",en="No dhabs"})) return end
		table.sort(arr,function(a,b) return a.Name<b.Name end)
		cycleIdx=cycleIdx%#arr+1; flyTo(arr[cycleIdx])
	end)
	Button(PG.tp,{ar="الطيران للهدف المحدد",en="Fly to aim target"},function() flyTo(currentTarget) end)

	--==================== قائمة الأهداف ====================
	do
		local page=PG.list
		local sbF=new("Frame",{Size=UDim2.new(1,-4,0,32),BackgroundColor3=PANEL,LayoutOrder=1},page); corner(sbF,10)
		new("UIStroke",{Color=PANEL3,Thickness=1,Transparency=0.55},sbF)
		local sb=new("TextBox",{Size=UDim2.new(1,-20,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Font=Enum.Font.GothamMedium,
			TextSize=12,TextColor3=TXT,PlaceholderColor3=SUB,ClearTextOnFocus=false,TextXAlignment=Enum.TextXAlignment.Left,Text=""},sbF)
		reg(function() sb.PlaceholderText=""..L({ar="ابحث عن ضب...",en="Search dhab..."}) end)

		local row2=new("Frame",{Size=UDim2.new(1,-4,0,28),BackgroundTransparency=1,LayoutOrder=2},page)
		local sortBtn=new("TextButton",{Size=UDim2.fromOffset(100,28),BackgroundColor3=PANEL2,Font=Enum.Font.GothamBold,TextSize=11,AutoButtonColor=false},row2)
		accent(sortBtn,"TextColor3"); corner(sortBtn,9)
		local tabsSF=new("ScrollingFrame",{Size=UDim2.new(1,-106,1,0),Position=UDim2.fromOffset(106,0),BackgroundTransparency=1,ScrollBarThickness=0,
			AutomaticCanvasSize=Enum.AutomaticSize.X,CanvasSize=UDim2.new(),ScrollingDirection=Enum.ScrollingDirection.X,BorderSizePixel=0},row2)
		new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder},tabsSF)
		local update
		local tabBtns={}
		for idx,id in ipairs(OPTS.ListTab) do
			local b=new("TextButton",{Size=UDim2.fromOffset(74,28),BackgroundColor3=PANEL2,Font=Enum.Font.GothamBold,TextSize=11,AutoButtonColor=false,LayoutOrder=idx},tabsSF)
			corner(b,9)
			tabBtns[id]=b
			b.MouseButton1Click:Connect(function()
				if not U.debounce(b) then return end
				S.ListTab=id
				for _,f in ipairs(texts) do pcall(f) end
				update()
			end)
		end
		reg(function()
			sortBtn.Text=L({ar="ترتيب: ",en="Sort: "})..L(({Distance={ar="المسافة",en="Distance"},Rarity={ar="الندرة",en="Rarity"},Name={ar="الاسم",en="Name"}})[S.Sort])
			for id,b in pairs(tabBtns) do
				local col=(id=="All") and ACC() or CONFIG.RarityColors[id]
				local on=(S.ListTab==id)
				b.BackgroundColor3=on and col or PANEL2
				b.TextColor3=on and Color3.fromRGB(11,11,14) or col
				b.Text=(id=="All") and L({ar="الكل",en="All"}) or RName(id)
			end
		end)
		sortBtn.MouseButton1Click:Connect(function()
			if not U.debounce(sortBtn) then return end
			local i=table.find(OPTS.Sort,S.Sort) or 0
			S.Sort=OPTS.Sort[i%#OPTS.Sort+1]
			for _,f in ipairs(texts) do pcall(f) end
			update()
		end)

		local sf=new("ScrollingFrame",{BackgroundColor3=PANEL,BorderSizePixel=0,LayoutOrder=3,
			Size=UDim2.new(1,-4,0,IsMobile and 150 or 220),ScrollBarThickness=4,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y},page)
		corner(sf,12); new("UIStroke",{Color=PANEL3,Thickness=1,Transparency=0.55},sf)
		new("UIListLayout",{Padding=UDim.new(0,3),SortOrder=Enum.SortOrder.LayoutOrder},sf)
		new("UIPadding",{PaddingTop=UDim.new(0,6),PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6),PaddingBottom=UDim.new(0,6)},sf)
		local entries={}
		local function makeRow()
			local e={}
			e.row=new("Frame",{Size=UDim2.new(1,0,0,30),BackgroundColor3=PANEL2},sf); corner(e.row,8)
			e.st=stroke(e.row,1.6,0.05); e.st.Transparency=0.05; e.st.Enabled=false
			e.lbl=new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(8,0),Size=UDim2.new(1,-100,1,0),Font=Enum.Font.GothamMedium,
				TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd},e.row)
			e.eye=new("TextButton",{Size=UDim2.fromOffset(40,22),Position=UDim2.new(1,-88,0.5,-11),BackgroundColor3=PANEL3,Text="Hide",Font=Enum.Font.GothamBold,TextSize=11,
				TextColor3=TXT,AutoButtonColor=false},e.row); corner(e.eye,6)
			e.go=new("TextButton",{Size=UDim2.fromOffset(38,22),Position=UDim2.new(1,-42,0.5,-11),BackgroundColor3=PANEL3,Text="Go",Font=Enum.Font.GothamBold,
				TextSize=11,AutoButtonColor=false},e.row); corner(e.go,6); accent(e.go,"TextColor3")
			e.eye.MouseButton1Click:Connect(function()
				if not U.debounce(e.eye) or not e.m then return end
				Muted[e.m]=not Muted[e.m] or nil; update()
			end)
			e.go.MouseButton1Click:Connect(function()
				if not U.debounce(e.go) then return end
				if e.m and Tracked[e.m] then flyTo(e.m) end
			end)
			return e
		end
		update=function()
			local r=myRoot(); if not r then return end
			local q=string.lower(S.Search or "")
			local list={}
			for m,d in pairs(Tracked) do
				if d.root.Parent and S.Rarities[d.rarity] and (S.ListTab=="All" or d.rarity==S.ListTab)
					and (q=="" or string.find(string.lower(m.Name),q,1,true)) then
					table.insert(list,{m=m,d=d,dist=(d.root.Position-r.Position).Magnitude,ri=table.find(CONFIG.RarityOrder,d.rarity) or 0})
				end
			end
			table.sort(list,function(a,b)
				if S.Sort=="Rarity" then if a.ri~=b.ri then return a.ri>b.ri end
				elseif S.Sort=="Name" then if a.m.Name~=b.m.Name then return a.m.Name<b.m.Name end end
				return a.dist<b.dist
			end)
			while #list>40 do table.remove(list) end
			while #entries>#list do
				local e=table.remove(entries); if e then pcall(e.row.Destroy,e.row) end
			end
			for i=1,#list do
				if not entries[i] then entries[i]=makeRow() end
				local e=entries[i]; local item=list[i]
				e.m=item.m
				local flyingTo=(Flying.target==item.m)
				e.lbl.Text=(flyingTo and "" or "")..string.format("%s  •  %s  •  %dm",item.m.Name,RName(item.d.rarity),math.floor(item.dist))
				e.lbl.TextColor3=CONFIG.RarityColors[item.d.rarity]
				e.lbl.TextTransparency=Muted[item.m] and 0.6 or 0
				e.eye.Text=Muted[item.m] and "Show" or "Hide"
				e.st.Enabled=flyingTo or (item.m==currentTarget)
				e.row.LayoutOrder=i
			end
		end
		sb:GetPropertyChangedSignal("Text"):Connect(function() S.Search=sb.Text; update() end)
		reg(update)
		targetListUpdate=update
	end

	-- المظهر
	Header(PG.vis,{ar="الإشعارات",en="Notifications"})
	Toggle(PG.vis,{ar="إشعار الضب النادر",en="Rare spawn alerts"},"Notify")
	Cycle(PG.vis,{ar="أقل ندرة للإشعار",en="Min rarity"},"NotifyMin",CONFIG.RarityOrder,RName)
	Toggle(PG.vis,{ar="تنبيه صوتي",en="Sound alert"},"SoundAlert")
	Header(PG.vis,{ar="الواجهة",en="Interface"})
	Cycle(PG.vis,{ar="لون الواجهة",en="Accent color"},"Accent",{1,2,3,4,5,6},function(v) return ACCENTS[v].name end)
	Cycle(PG.vis,{ar="الثيم",en="Theme"},"Theme",OPTS.Theme,function(v) return v=="Dark" and L({ar="داكن",en="Dark"}) or L({ar="فاتح",en="Light"}) end,applyTheme)
	Slider(PG.vis,{ar="حجم الواجهة",en="UI scale"},"UIScale",0.6,1.4,0.05)
	Slider(PG.vis,{ar="شفافية الخلفية",en="Background transparency"},"UITrans",0,0.6,0.05)
	Toggle(PG.vis,{ar="العلامة المائية",en="Watermark"},"Watermark")

	-- الإعدادات
	Header(PG.set,{ar="عام",en="General"})
	Button(PG.set,function() return S.Lang=="ar" and "Language: English" or "اللغة: العربية" end,function()
		S.Lang = S.Lang=="ar" and "en" or "ar"; for _,f in ipairs(texts) do f() end
	end)
	Button(PG.set,{ar="إعادة موضع الواجهة",en="Reset UI position"},function() tween(main,{Position=DEFAULT_POS},0.3) end)
	Button(PG.set,{ar="إعادة فحص الضبان",en="Rescan dhabs"},function() scan(); notify(L({ar="تم الفحص",en="Rescanned"})) end)
	Button(PG.set,{ar="مسح الإضاءة كلها",en="Clear all ESP"},function() for m in pairs(Tracked) do untrack(m) end end)
	Button(PG.set,{ar="إعادة الإعدادات",en="Reset settings"},function()
		S.FOV=150; S.Strength=0.6; S.Smooth=0.3; S.MaxDist=1500; S.AimDist=600; S.TextSize=14; S.UIScale=1; S.UITrans=0
		S.FlySpeed=60; S.FlyStopDist=4; S.FlySmooth=0.25; S.FlyArc=0.25; S.PredTime=0.12; S.AutoFireAngle=2.5; S.Hysteresis=0.25; S.ChamsT=0.35
		scale.Scale=1
		for _,f in ipairs(texts) do f() end; notify(L({ar="تمت الإعادة",en="Settings reset"}))
	end)
	Header(PG.bind,{ar="مفاتيح الاختصار",en="Keybinds"})
	Keybind(PG.bind,{ar="زر الإظهار",en="Toggle key"},"ToggleKey")
	Keybind(PG.bind,{ar="زر التصويب",en="Aim key"},"AimKey")
	Keybind(PG.bind,{ar="زر الطيران",en="Fly key"},"FlyKey")
	Keybind(PG.bind,{ar="زر الإيقاف",en="Stop key"},"StopKey")
	Header(PG.bind,{ar="مفاتيح الطيران الحر والسيارة",en="Free fly and vehicle keys"})
	Keybind(PG.bind,{ar="للأمام",en="Forward"},"FlyFwdKey",true)
	Keybind(PG.bind,{ar="للخلف",en="Back"},"FlyBackKey",true)
	Keybind(PG.bind,{ar="يسار",en="Left"},"FlyLeftKey",true)
	Keybind(PG.bind,{ar="يمين",en="Right"},"FlyRightKey",true)
	Keybind(PG.bind,{ar="صعود",en="Up"},"FlyUpKey",true)
	Keybind(PG.bind,{ar="هبوط",en="Down"},"FlyDownKey",true)
	Keybind(PG.bind,{ar="تسريع",en="Boost"},"FlySprintKey",true)
	local resBox=infoBox(PG.bind); resBox.TextSize=9
	new("UIPadding",{PaddingTop=UDim.new(0,2),PaddingBottom=UDim.new(0,2)},resBox)
	reg(function() resBox.Text="<b>"..L({ar="الأزرار المحجوزة",en="Reserved"}).."</b>: "..U.reservedText() end)
	Header(PG.prof,{ar="الملفات الشخصية",en="Profiles"})
	profileBox=TextBoxCell(PG.prof)
	reg(function() profileBox.PlaceholderText=L({ar="الصق/انسخ الإعدادات هنا",en="Paste/copy settings here"}) end)
	Button(PG.prof,{ar="تصدير الإعدادات",en="Export settings"},function()
		local s=U.serialize(); profileBox.Text=s
		notify(L({ar="تم التصدير",en="Exported"}))
	end)
	Button(PG.prof,{ar="استيراد الإعدادات",en="Import settings"},function()
		if U.deserialize(profileBox.Text) then notify(L({ar="تم الاستيراد",en="Imported"}))
		else notify(L({ar="نص غير صالح",en="Invalid text"}),Color3.fromRGB(230,60,60)) end
	end)
	Button(PG.prof,{ar="حفظ في ملف",en="Save to file"},function()
		local ok=pcall(function() writefile("3z_profile.json",U.serialize()) end)
		notify(ok and L({ar="تم الحفظ",en="Saved"}) or L({ar="الحفظ غير مدعوم",en="File save unsupported"}),ok and nil or Color3.fromRGB(230,60,60))
	end)
	Button(PG.prof,{ar="تحميل من ملف",en="Load from file"},function()
		local ok,str=pcall(function() return readfile("3z_profile.json") end)
		if ok and str and U.deserialize(str) then notify(L({ar="تم التحميل",en="Loaded"}))
		else notify(L({ar="لا يوجد ملف",en="No file found"}),Color3.fromRGB(230,60,60)) end
	end)
	Header(PG.set,{ar="السيرفر والإحصائيات",en="Server & Stats"})
	Button(PG.set,{ar="إعادة الدخول",en="Rejoin"},function() U.rejoin() end)
	Button(PG.set,{ar="تبديل السيرفر",en="Server hop"},function() U.serverHop() end)
	statsBox=infoBox(PG.set)

	-- Radar page
	TIPS.Radar={ar="رادار صغير يعرض مواقع الضبان حولك",en="Mini radar showing nearby dhabs"}
	TIPS.RadarRotate={ar="تدوير الرادار مع اتجاه الكاميرا",en="Rotate radar with camera direction"}
	TIPS.RadarRange={ar="المسافة التي يغطيها الرادار",en="Distance the radar covers"}
	TIPS.RadarSize={ar="حجم الرادار على الشاشة",en="Radar size on screen"}
	Header(PG.radar,{ar="الرادار",en="Radar"})
	Toggle(PG.radar,{ar="تشغيل الرادار",en="Enable radar"},"Radar")
	Toggle(PG.radar,{ar="تدوير مع الكاميرا",en="Rotate with camera"},"RadarRotate")
	Slider(PG.radar,{ar="مدى الرادار",en="Radar range"},"RadarRange",50,1500,10," m")
	Slider(PG.radar,{ar="حجم الرادار",en="Radar size"},"RadarSize",100,300,5," px")

	-- Spawn log page
	do
		local page=PG.log
		local hdr=new("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(1,-4,0,22),Font=Enum.Font.GothamBlack,TextSize=13,
			TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=1},page)
		accent(hdr,"TextColor3"); reg(function() hdr.Text=L({ar="سجل الظهور",en="Spawn log"}) end)
		local clr=new("TextButton",{Size=UDim2.new(1,-4,0,34),BackgroundColor3=PANEL,Font=Enum.Font.GothamBold,TextSize=12,AutoButtonColor=false,LayoutOrder=2},page)
		accent(clr,"TextColor3"); corner(clr,10); new("UIStroke",{Color=PANEL3,Thickness=1,Transparency=0.6},clr)
		reg(function() clr.Text=L({ar="مسح السجل",en="Clear log"}) end)
		local box=new("ScrollingFrame",{Size=UDim2.new(1,-4,0,IsMobile and 150 or 250),BackgroundColor3=PANEL,BorderSizePixel=0,ScrollBarThickness=4,
			AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),LayoutOrder=3},page)
		corner(box,12); new("UIStroke",{Color=PANEL3,Thickness=1,Transparency=0.6},box)
		new("UIListLayout",{Padding=UDim.new(0,3),SortOrder=Enum.SortOrder.LayoutOrder},box)
		new("UIPadding",{PaddingTop=UDim.new(0,6),PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6),PaddingBottom=UDim.new(0,6)},box)
		local empty=new("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,30),Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=SUB,LayoutOrder=0},box)
		reg(function() empty.Text=L({ar="لا توجد عمليات ظهور بعد",en="No spawns yet"}) end)
		local shown=-1
		U.logUpdate=function()
			if shown==U.logVer then return end
			shown=U.logVer
			for _,c in ipairs(box:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
			empty.Visible=#U.log==0
			for i,e in ipairs(U.log) do
				local row=new("Frame",{Size=UDim2.new(1,0,0,28),BackgroundColor3=PANEL2,LayoutOrder=i},box); corner(row,8)
				local col=CONFIG.RarityColors[e[3]]
				new("Frame",{Size=UDim2.new(0,3,1,-12),Position=UDim2.fromOffset(6,6),BackgroundColor3=col,BorderSizePixel=0},row)
				new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(18,0),Size=UDim2.new(1,-24,1,0),Font=Enum.Font.GothamMedium,TextSize=11,
					TextXAlignment=Enum.TextXAlignment.Left,TextColor3=col,TextTruncate=Enum.TextTruncate.AtEnd,
					Text=string.format("[%s]   %s   -   %s",e[1],e[2],RName(e[3]))},row)
			end
		end
		clr.MouseButton1Click:Connect(function() if U.debounce(clr) then U.log={}; U.logVer+=1; U.logUpdate() end end)
		U.logUpdate()
		table.insert(texts,function() shown=-1; U.logUpdate() end)
	end

	-- Help page
	do
		local page=PG.help
		local function sec(titleT,bodyT)
			local f=new("TextLabel",{Size=UDim2.new(1,-4,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=PANEL,Font=Enum.Font.GothamMedium,TextSize=12,
				TextColor3=TXT,RichText=true,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,LayoutOrder=nextOrder()},page)
			corner(f,12); new("UIStroke",{Color=PANEL3,Thickness=1,Transparency=0.6},f)
			new("UIPadding",{PaddingLeft=UDim.new(0,14),PaddingRight=UDim.new(0,12),PaddingTop=UDim.new(0,10),PaddingBottom=UDim.new(0,10)},f)
			reg(function() f.Text="<b><font color='#"..ACC():ToHex().."'>"..L(titleT).."</font></b>\n"..L(bodyT) end)
		end
		sec({ar="البداية",en="Getting started"},
			{ar="- زر الإظهار والإخفاء الافتراضي هو RightShift (قابل للتغيير من صفحة المفاتيح).\n- شاشة الترحيب تفتح من زر في الصفحة الرئيسية.",
			 en="- The default show/hide key is RightShift (change it in the Keybinds page).\n- Reopen the welcome screen from the Home page."})
		sec({ar="الإضاءة (ESP)",en="ESP"},
			{ar="- تلوّن كل ضب حسب ندرته وتعرض الاسم والمسافة.\n- Chams تلوّن الجسم كاملاً، وBox يرسم إطاراً، والسهم يشير للضب خارج الشاشة.\n- اختر الندرات الظاهرة من أسفل صفحة الإضاءة.",
			 en="- Colors every dhab by rarity and shows name and distance.\n- Chams colors the whole body, Box draws a frame, arrows point to off-screen dhabs.\n- Pick visible rarities at the bottom of the ESP page."})
		sec({ar="التصويب",en="Aim assist"},
			{ar="- كليك يمين للتصويب (زر AIM على الجوال).\n- دائرة FOV تحدد منطقة اختيار الهدف، وفحص الجدران يتجاهل الأهداف المحجوبة.\n- توقع الحركة يعوّض حركة الضب.",
			 en="- Right click to aim (AIM button on mobile).\n- The FOV circle limits target selection; wall check skips hidden targets.\n- Prediction compensates for movement."})
		sec({ar="الطيران",en="Flight"},
			{ar="- اختر ضب من القائمة أو صفحة الطيران، وزر الإيقاف يوقف الطيران فوراً.\n- الوضع الآمن يعطّل التصادم، والمسار المنحني يرفع الطيران فوق العوائق.",
			 en="- Pick a dhab from the list or Fly page; the stop button ends flight instantly.\n- Safe mode disables collisions; curved path arcs over obstacles."})
		sec({ar="الرادار والسجل",en="Radar and log"},
			{ar="- الرادار يعرض الضبان حولك، والنقطة الكبيرة هي الهدف الحالي.\n- السجل يحفظ آخر عمليات ظهور الضبان مع الوقت والندرة.",
			 en="- The radar shows dhabs around you; the large dot is the current target.\n- The log keeps the latest spawns with time and rarity."})
		sec({ar="حل المشاكل",en="Troubleshooting"},
			{ar="- لا يظهر شيء: افحص اسم الضب، ثم اضغط إعادة فحص الضبان من الإعدادات.\n- أخطاء حفظ الملفات تعني أن المشغّل لا يدعم الملفات، استخدم التصدير للنسخ.",
			 en="- Nothing shows: check the dhab name, then press Rescan in Settings.\n- File save errors mean your executor lacks file support; use Export to copy instead."})
	end


	TIPS.AutoFly={ar="يطير تلقائياً لأي ضب نادر يظهر (حسب أقل ندرة في الإشعارات)",en="Auto-fly to rare spawns (uses the notify minimum rarity)"}
	TIPS.AntiAFK={ar="يمنع الطرد بسبب الخمول",en="Prevents idle kick"}
	TIPS.Fullbright={ar="إضاءة كاملة للخريطة لرؤية أفضل",en="Full map brightness for better visibility"}
	Header(PG.tp,{ar="تلقائي",en="Automation"})
	Toggle(PG.tp,{ar="طيران تلقائي للنادر",en="Auto-fly to rare spawns"},"AutoFly")
	Cycle(PG.tp,{ar="أقل ندرة للتلقائي",en="Auto-fly min rarity"},"NotifyMin",CONFIG.RarityOrder,RName)
	Header(PG.set,{ar="أدوات",en="Utilities"})
	Toggle(PG.set,{ar="منع الطرد (Anti AFK)",en="Anti AFK"},"AntiAFK")
	Toggle(PG.set,{ar="إضاءة كاملة (Fullbright)",en="Fullbright"},"Fullbright")

	-- helpers for dynamic lists
	local function typeCounts()
		local c,names={},{}
		for m,d in pairs(Tracked) do
			if d.root.Parent then
				local n=m.Name
				if not c[n] then c[n]=0; table.insert(names,n) end
				c[n]+=1
			end
		end
		table.sort(names)
		return names,c
	end
	local function clearG(g) for _,c in ipairs(g:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end end
	local function mkBtn(g,text,col,cb)
		local b=new("TextButton",{BackgroundColor3=PANEL,Font=Enum.Font.GothamBold,TextSize=12,TextColor3=col or TXT,AutoButtonColor=false,Text=text,
			TextTruncate=Enum.TextTruncate.AtEnd,LayoutOrder=nextOrder()},g)
		corner(b,10); new("UIStroke",{Color=PANEL3,Thickness=1,Transparency=0.6},b)
		b.MouseEnter:Connect(function() tween(b,{BackgroundColor3=PANEL2},0.12) end)
		b.MouseLeave:Connect(function() tween(b,{BackgroundColor3=PANEL},0.12) end)
		b.MouseButton1Click:Connect(function() if U.debounce(b) then cb() end end)
		return b
	end

	-- Ignore page
	local function recheck()
		BadCache=setmetatable({},{__mode="k"}); resetSkip()
		for m in pairs(Tracked) do if isBadModel(m) then untrack(m) end end
	end
	TIPS.ExVehicles={ar="تجاهل أي شيء اسمه أو بداخله سيارة أو مقعد",en="Ignore anything vehicle-related"}
	TIPS.ExWeapons={ar="تجاهل أي شيء اسمه أو بداخله سلاح أو Tool",en="Ignore anything weapon/tool-related"}
	TIPS.ExStructures={ar="تجاهل الأقفاص والمحلات والصخور والخزانات والهوائيات",en="Ignore cages, shops, rocks, tanks, antennas"}
	Header(PG.ign,{ar="فئات التجاهل",en="Ignore groups"})
	Toggle(PG.ign,{ar="تجاهل السيارات",en="Ignore vehicles"},"ExVehicles",recheck)
	Toggle(PG.ign,{ar="تجاهل الأسلحة",en="Ignore weapons"},"ExWeapons",recheck)
	Toggle(PG.ign,{ar="تجاهل المباني والأغراض",en="Ignore structures"},"ExStructures",recheck)

	Header(PG.ign,{ar="إضافة اسم للتجاهل",en="Add a name to ignore"})
	local ignBox=TextBoxCell(PG.ign)
	reg(function() ignBox.PlaceholderText=L({ar="اكتب اسم أو جزء منه (مثال: car)",en="Type a name or part of it (e.g. car)"}) end)
	local function saveIgn() pcall(function() writefile("3z_ignore.json",HttpService:JSONEncode(CONFIG.IgnoreList)) end) end
	pcall(function()
		local d=HttpService:JSONDecode(readfile("3z_ignore.json"))
		for _,w in ipairs(d) do if type(w)=="string" and w~="" and not table.find(CONFIG.IgnoreList,w) then table.insert(CONFIG.IgnoreList,w) end end
	end)
	local function addIgnore(word)
		word=string.lower(tostring(word or "")):match("^%s*(.-)%s*$")
		if word=="" or table.find(CONFIG.IgnoreList,word) then return false end
		table.insert(CONFIG.IgnoreList,word)
		for m in pairs(Tracked) do if isIgnored(m) then untrack(m) end end
		saveIgn(); return true
	end
	Button(PG.ign,{ar="إضافة",en="Add"},function()
		if addIgnore(ignBox.Text) then ignBox.Text=""; notify(L({ar="تمت الإضافة",en="Added"}))
		else notify(L({ar="اسم غير صالح أو موجود",en="Invalid or already added"}),Color3.fromRGB(240,110,110)) end
		U.ignUpdate()
	end)
	Button(PG.ign,{ar="تجاهل الهدف الحالي",en="Ignore current target"},function()
		local m=currentTarget or nearestOf()
		if m and addIgnore(m.Name) then notify(L({ar="تم تجاهل: ",en="Ignored: "})..m.Name)
		else notify(L({ar="لا يوجد هدف",en="No target"}),Color3.fromRGB(240,110,110)) end
		U.ignUpdate()
	end)
	local seenG=makeSection(PG.ign,{ar="المكتشف الآن - اضغط للتجاهل",en="Detected now - tap to ignore"})
	local ignG=makeSection(PG.ign,{ar="قائمة التجاهل - اضغط للإزالة",en="Ignore list - tap to remove"})
	local sigS,sigI
	U.ignUpdate=function()
		local names,c=typeCounts()
		local parts={S.Lang}
		for _,n in ipairs(names) do table.insert(parts,n..c[n]) end
		local sg=table.concat(parts,"|")
		if sg~=sigS then
			sigS=sg; clearG(seenG)
			if #names==0 then mkBtn(seenG,L({ar="لا يوجد شيء",en="Nothing detected"}),SUB,function() end) end
			for _,n in ipairs(names) do
				mkBtn(seenG,n.."   x"..c[n],nil,function() if addIgnore(n) then U.ignUpdate() end end)
			end
		end
		local si=S.Lang.."|"..table.concat(CONFIG.IgnoreList,"|")
		if si~=sigI then
			sigI=si; clearG(ignG)
			for idx,w in ipairs(CONFIG.IgnoreList) do
				mkBtn(ignG,w.."   ("..L({ar="إزالة",en="remove"})..")",Color3.fromRGB(240,110,110),function()
					local i=table.find(CONFIG.IgnoreList,w)
					if i then table.remove(CONFIG.IgnoreList,i); saveIgn(); resetSkip(); sigI=nil; U.ignUpdate() end
				end)
			end
		end
	end
	U.ignUpdate()

	-- Fly by type
	TIPS.FlyMode={ar="CFrame: حركة مباشرة بدون سرعة. Velocity: طيران بالسرعة",en="CFrame: direct movement. Velocity: velocity flight"}
	Header(PG.tp,{ar="نمط الطيران",en="Fly mode"})
	Cycle(PG.tp,{ar="النمط",en="Mode"},"FlyMode",OPTS.FlyMode,function(v) return v end)
	local typeG=makeSection(PG.tp,{ar="طيران حسب النوع",en="Fly by type"})
	local sigT
	U.typeUpdate=function()
		local names,c=typeCounts()
		local parts={S.Lang}
		for _,n in ipairs(names) do table.insert(parts,n..c[n]) end
		local sg=table.concat(parts,"|")
		if sg==sigT then return end
		sigT=sg; clearG(typeG)
		if #names==0 then mkBtn(typeG,L({ar="لا يوجد",en="None found"}),SUB,function() end) end
		for _,n in ipairs(names) do
			mkBtn(typeG,n.."   ("..c[n]..")",nil,function()
				local r=myRoot(); if not r then return end
				local best,bd
				for m,d in pairs(Tracked) do
					if m.Name==n and d.root.Parent then
						local dist=(d.root.Position-r.Position).Magnitude
						if not bd or dist<bd then best,bd=m,dist end
					end
				end
				if best then flyTo(best) end
			end)
		end
	end
	U.typeUpdate()

	-- Silent aim page
	TIPS.SilentAim={ar="يوجّه الطلقات للضب داخل دائرة التصويب الصامت عند الإطلاق (تثبيت الكاميرا على الضب)",en="Redirects shots to dhabs inside the silent FOV by snapping the camera to the dhab while firing"}
	TIPS.MagicBullet={ar="الطلقة تصيب أقرب ضب ضمن المدى حتى لو خلف جدار أو خارج الدائرة",en="Shots hit the nearest dhab in range, even behind walls or outside the circle"}
	TIPS.SilentFOV={ar="نصف قطر دائرة التصويب الصامت",en="Silent aim circle radius"}
	TIPS.SilentChance={ar="نسبة نجاح التوجيه",en="Redirect hit chance"}
	TIPS.MagicRange={ar="أقصى مسافة للطلقة السحرية",en="Magic bullet max range"}
	TIPS.ShowSilentFOV={ar="إظهار دائرة التصويب الصامت",en="Show silent aim circle"}
	Header(PG.silent,{ar="التصويب الصامت",en="Silent Aim"})
	Toggle(PG.silent,{ar="تشغيل التصويب الصامت",en="Silent aim"},"SilentAim")
	Toggle(PG.silent,{ar="الطلقة السحرية",en="Magic bullet"},"MagicBullet")
	Slider(PG.silent,{ar="حجم الدائرة",en="Circle size"},"SilentFOV",20,800,5," px")
	Slider(PG.silent,{ar="نسبة الإصابة",en="Hit chance"},"SilentChance",1,100,1,"%")
	Slider(PG.silent,{ar="مدى الطلقة السحرية",en="Magic range"},"MagicRange",50,50000,50," m")
	Toggle(PG.silent,{ar="إظهار الدائرة",en="Show circle"},"ShowSilentFOV")
	TIPS.WallPierce={ar="يلغي الجدران بين سلاحك والهدف وقت الإطلاق (عندك فقط)",en="Removes walls between you and the target while firing (client side)"}
	Toggle(PG.silent,{ar="اختراق الجدران",en="Wall pierce"},"WallPierce")
	TIPS.InfAmmo={ar="يثبّت قيم الذخيرة في أسلحتك على رقم عالٍ (يعمل فقط إذا كانت الذخيرة محسوبة عند اللاعب)",en="Keeps ammo values on your tools high (only works if the game tracks ammo client-side)"}
	Header(PG.silent,{ar="ذخيرة لا نهائية",en="Infinite ammo"})
	Toggle(PG.silent,{ar="تثبيت الذخيرة",en="Ammo lock"},"InfAmmo")
	TIPS.AmmoMode={ar="لا نهائية = رقم ضخم، 99999 = رقم ثابت أصغر قد تقبله اللعبة أكثر",en="Infinite = huge number, 99999 = a smaller fixed value some games accept"}
	Cycle(PG.silent,{ar="قيمة الذخيرة",en="Ammo value"},"AmmoMode",OPTS.AmmoMode,function(v) return v=="Infinite" and L({ar="لا نهائية",en="Infinite"}) or "99999" end)
	TIPS.AmmoDeep={ar="بحث عميق في ذاكرة اللعبة عن قيم الذخيرة (يحتاج getgc في المشغّل)",en="Deep scan of game memory for ammo values (needs getgc)"}
	TIPS.FastShot={ar="إطلاق سريع متكرر أثناء الضغط على زر الإطلاق",en="Rapid repeated firing while holding fire"}
	TIPS.FastRate={ar="عدد الطلقات في الثانية",en="Shots per second"}
	TIPS.FastAlways={ar="إطلاق مستمر بدون ضغط (للجوال)",en="Fire continuously without holding (mobile)"}
	TIPS.NoCooldown={ar="يصفّر قيم الكول داون والتأخير في السلاح",en="Zeroes weapon cooldown and delay values"}
	Toggle(PG.silent,{ar="بحث عميق عن الذخيرة",en="Deep ammo scan"},"AmmoDeep")
	Header(PG.silent,{ar="إطلاق سريع",en="Fast shot"})
	Toggle(PG.silent,{ar="إطلاق سريع",en="Fast shot"},"FastShot")
	Slider(PG.silent,{ar="طلقات بالثانية",en="Shots per second"},"FastRate",2,30,1)
	Toggle(PG.silent,{ar="إطلاق مستمر",en="Always shooting"},"FastAlways")
	Toggle(PG.silent,{ar="إلغاء الكول داون",en="No cooldown"},"NoCooldown")
	Header(PG.silent,{ar="الحالة",en="Status"})
	U.hookInfo=infoBox(PG.silent)
	U.ammoInfo=infoBox(PG.silent)
	Header(PG.silent,{ar="ندرات الاستهداف",en="Target rarities"})
	RarityPicker(PG.silent,S.AimRarities)

	-- Player page
	TIPS.WalkSpeedOn={ar="تفعيل سرعة المشي المخصصة",en="Enable custom walk speed"}
	TIPS.WalkSpeed={ar="سرعة المشي",en="Walk speed"}
	TIPS.JumpOn={ar="تفعيل قوة القفز المخصصة",en="Enable custom jump power"}
	TIPS.JumpPower={ar="قوة القفز",en="Jump power"}
	TIPS.InfJump={ar="قفز لا نهائي في الهواء",en="Jump again in mid-air"}
	TIPS.Noclip={ar="المشي عبر الجدران",en="Walk through walls"}
	TIPS.FreeFly={ar="طيران حر: WASD + Space للأعلى + Shift للأسفل (على الجوال: عصا الحركة)",en="Free fly: WASD + Space up + Shift down (mobile: joystick)"}
	TIPS.FreeFlySpeed={ar="سرعة الطيران الحر",en="Free fly speed"}
	TIPS.AutoFood={ar="يأكل تلقائياً عندما ينزل الجوع عن النسبة (يبحث عن قيمة الجوع وأداة أكل)",en="Eats automatically when hunger drops below the threshold"}
	TIPS.AutoWater={ar="يشرب/يعبي الماء تلقائياً عندما ينزل العطش عن النسبة",en="Drinks/fills water automatically when thirst drops below the threshold"}
	TIPS.AutoThresh={ar="النسبة التي يبدأ عندها",en="Level at which it triggers"}
	TIPS.VehFace={ar="تدور السيارة باتجاه الكاميرا أثناء الطيران",en="Vehicle turns to face the camera while flying"}
	TIPS.Lite={ar="وضع خفيف: يلغي النجوم والحركات (يُطبّق عند التشغيل التالي)",en="Lite mode: removes stars and effects (applies on next run)"}
	TIPS.ExtraGrav={ar="تغيير الجاذبية",en="Change gravity"}
	TIPS.Gravity={ar="قيمة الجاذبية",en="Gravity value"}
	TIPS.ExtraFOV={ar="تغيير مجال رؤية الكاميرا",en="Change camera field of view"}
	TIPS.CamFOV={ar="مجال الرؤية",en="Field of view"}
	TIPS.ExtraTime={ar="تثبيت وقت اليوم",en="Lock time of day"}
	TIPS.ClockTime={ar="الساعة",en="Hour"}
	TIPS.ExtraZoom={ar="تحريك الكاميرا لمسافة أبعد",en="Allow farther camera zoom"}
	TIPS.MaxZoom={ar="أقصى بعد للكاميرا",en="Max zoom distance"}
	TIPS.InstantPrompt={ar="يلغي وقت الضغط المطوّل على أزرار التفاعل",en="Removes hold time on interaction prompts"}
	TIPS.AutoPrompt={ar="يضغط أزرار التفاعل القريبة تلقائياً",en="Auto-triggers nearby interaction prompts"}
	Header(PG.player,{ar="أوامر إضافية",en="Extra commands"})
	Toggle(PG.player,{ar="السيارة تواجه الكاميرا",en="Vehicle faces camera"},"VehFace")
	Toggle(PG.player,{ar="تفاعل فوري",en="Instant prompts"},"InstantPrompt")
	Toggle(PG.player,{ar="تفاعل تلقائي",en="Auto prompts"},"AutoPrompt")
	Toggle(PG.player,{ar="تغيير الجاذبية",en="Gravity"},"ExtraGrav")
	Slider(PG.player,{ar="الجاذبية",en="Gravity value"},"Gravity",10,300,2)
	Toggle(PG.player,{ar="مجال الرؤية",en="Camera FOV"},"ExtraFOV")
	Slider(PG.player,{ar="الدرجة",en="FOV"},"CamFOV",30,120,1)
	Toggle(PG.player,{ar="تثبيت الوقت",en="Lock time"},"ExtraTime")
	Slider(PG.player,{ar="الساعة",en="Hour"},"ClockTime",0,24,1)
	Toggle(PG.player,{ar="زووم أبعد",en="Far zoom"},"ExtraZoom")
	Slider(PG.player,{ar="أقصى بعد",en="Max zoom"},"MaxZoom",20,1000,10," m")
	Toggle(PG.player,{ar="وضع خفيف (يحتاج إعادة تشغيل)",en="Lite mode (rerun)"},"Lite")
	Button(PG.player,{ar="إعادة الشخصية",en="Reset character"},function() pcall(function() LP.Character:BreakJoints() end) end)
	Header(PG.player,{ar="البقاء",en="Survival"})
	Toggle(PG.player,{ar="أكل تلقائي",en="Auto food"},"AutoFood")
	Toggle(PG.player,{ar="شرب وتعبئة تلقائية",en="Auto water"},"AutoWater")
	Slider(PG.player,{ar="يبدأ عند",en="Trigger at"},"AutoThresh",5,95,5,"%")
	Header(PG.player,{ar="الحركة",en="Movement"})
	Toggle(PG.player,{ar="سرعة المشي",en="Walk speed"},"WalkSpeedOn")
	Slider(PG.player,{ar="قيمة السرعة",en="Speed value"},"WalkSpeed",16,1000,1," m/s")
	Toggle(PG.player,{ar="قوة القفز",en="Jump power"},"JumpOn")
	Slider(PG.player,{ar="قيمة القفز",en="Jump value"},"JumpPower",50,300,1)
	Toggle(PG.player,{ar="قفز لا نهائي",en="Infinite jump"},"InfJump")
	Toggle(PG.player,{ar="اختراق الجدران",en="Noclip"},"Noclip")
	TIPS.VehFly={ar="طيران السيارة: WASD + Space للأعلى + Shift للأسفل وأنت جالس فيها",en="Vehicle fly: WASD + Space up + Shift down while seated"}
	TIPS.VehBoost={ar="تسريع السيارة فوراً عند الضغط على الgas",en="Instant vehicle speed while throttling"}
	Header(PG.player,{ar="السيارات",en="Vehicles"})
	Toggle(PG.player,{ar="طيران السيارة",en="Vehicle fly"},"VehFly")
	Slider(PG.player,{ar="سرعة طيران السيارة",en="Vehicle fly speed"},"VehFlySpeed",20,600,5," m/s")
	Toggle(PG.player,{ar="تسريع السيارة",en="Vehicle boost"},"VehBoost")
	Slider(PG.player,{ar="سرعة التسريع",en="Boost speed"},"VehBoostSpeed",30,800,5," m/s")
	Header(PG.player,{ar="طيران حر",en="Free fly"})
	Toggle(PG.player,{ar="تشغيل الطيران الحر",en="Free fly"},"FreeFly")
	Slider(PG.player,{ar="سرعة الطيران الحر",en="Free fly speed"},"FreeFlySpeed",10,300,5," m/s")
	Cycle(PG.player,{ar="اتجاه الطيران",en="Fly direction"},"FlyDirMode",OPTS.FlyDirMode,function(v) return v=="Camera" and L({ar="حسب الكاميرا",en="Camera"}) or L({ar="أفقي",en="Flat"}) end)
	Slider(PG.player,{ar="سرعة الصعود والهبوط",en="Vertical speed x"},"FlyVertMul",0.2,3,0.1)
	Slider(PG.player,{ar="مضاعف التسريع",en="Boost multiplier"},"FlySprint",1,6,0.5)
	Toggle(PG.player,{ar="أزرار الطيران على الشاشة",en="On-screen fly buttons"},"FlyPad")
	TIPS.PadSize={ar="حجم أزرار الطيران على الشاشة",en="On-screen fly buttons size"}
	Slider(PG.player,{ar="حجم الأزرار",en="Buttons size"},"PadSize",0.5,1.8,0.1)
	Cycle(PG.player,{ar="نمط طيران السيارة",en="Vehicle fly mode"},"VehMode",OPTS.VehMode,function(v) return v end)

	TIPS.NoFog={ar="يلغي الضباب كلياً",en="Removes fog completely"}
	TIPS.FPSBoost={ar="يطفئ الظلال والمؤثرات والجزيئات لرفع الفريمات",en="Disables shadows, effects and particles to raise FPS"}
	TIPS.FPSExtreme={ar="يبسّط الخامات ويخفي الملصقات لأقصى فريمات (يغيّر شكل الماب)",en="Flattens materials and hides decals for max FPS (changes map look)"}
	TIPS.UnlockFPS={ar="يرفع حد الفريمات إلى 1000 (يحتاج setfpscap)",en="Raises the FPS cap to 1000 (needs setfpscap)"}
	Header(PG.vis,{ar="الأداء والرؤية",en="Performance and view"})
	Toggle(PG.vis,{ar="رفع الفريمات",en="FPS boost"},"FPSBoost")
	Toggle(PG.vis,{ar="رفع شديد (يبسّط الماب)",en="Extreme boost (flattens map)"},"FPSExtreme")
	Toggle(PG.vis,{ar="فك حد الفريمات",en="Unlock FPS cap"},"UnlockFPS")
	Toggle(PG.vis,{ar="إزالة الضباب",en="Remove fog"},"NoFog")
	Toggle(PG.vis,{ar="إضاءة كاملة",en="Fullbright"},"Fullbright")
end

showPage("home")

--==================== HUD الطيران + العلامة المائية ====================
hudFrame=new("Frame",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,92),Size=UDim2.fromOffset(310,30),BackgroundColor3=BG,
	BackgroundTransparency=0.1,Visible=false},gui)
corner(hudFrame,10); stroke(hudFrame,1.2,0.3)
hudText=new("TextLabel",{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=TXT,RichText=true},hudFrame)

local watermark=new("TextLabel",{Position=UDim2.new(0,10,0,10),Size=UDim2.fromOffset(260,22),BackgroundColor3=BG,BackgroundTransparency=0.15,
	Font=Enum.Font.GothamBold,TextSize=11,TextColor3=TXT,Text="VØX beta"},gui)
corner(watermark,8); stroke(watermark,1.2,0.4)

local alertSound=new("Sound",{SoundId=CONFIG.AlertSound,Volume=0.7},gui)

--==================== سحب / تصغير / إغلاق ====================
local function makeDraggable(handle,target,onClick)
	local drag,sp,si,moved
	handle.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			drag=true; moved=false; sp=target.Position; si=i.Position
			i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then drag=false end end)
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
			local d=i.Position-si; if d.Magnitude>6 then moved=true end
			target.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
		end
	end)
	if onClick then handle.MouseButton1Click:Connect(function() if not moved then onClick() end end) end
end
makeDraggable(top,main)
shadow.Active=false

local bubble=new("TextButton",{Size=UDim2.fromOffset(56,56),Position=UDim2.new(0,18,0,92),BackgroundColor3=BG,
	Text="V",Font=Enum.Font.GothamBlack,TextSize=20,Visible=false,AutoButtonColor=false},gui)
accent(bubble,"TextColor3"); corner(bubble,28); stroke(bubble,2.5,0.05)

local function openUI()
	bubble.Visible=false; main.Visible=true; shadow.Visible=true
	scale.Scale=S.UIScale*0.9; tween(scale,{Scale=S.UIScale},0.25)
end
local function minimize()
	tween(scale,{Scale=S.UIScale*0.9},0.15)
	task.wait(0.15)
	main.Visible=false; shadow.Visible=false
end
makeDraggable(bubble,bubble,openUI)

local topToggle=new("TextButton",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,10,0.5,0),Size=UDim2.fromOffset(64,64),BackgroundColor3=Color3.new(1,1,1),
	Font=Enum.Font.GothamBlack,TextSize=13,TextColor3=Color3.fromRGB(16,16,24),AutoButtonColor=false,ZIndex=250},gui)
corner(topToggle,10)
new("UIStroke",{Color=Color3.fromRGB(40,110,255),Thickness=1.5,Transparency=0.35},topToggle)
topToggle.MouseEnter:Connect(function() tween(topToggle,{Size=UDim2.fromOffset(70,70)},0.12) end)
topToggle.MouseLeave:Connect(function() tween(topToggle,{Size=UDim2.fromOffset(64,64)},0.12) end)
do
	local logoImg=new("ImageLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(3,3),Size=UDim2.new(1,-6,1,-6),ScaleType=Enum.ScaleType.Fit,Visible=false,ZIndex=251},topToggle)
	pcall(function()
		if typeof(writefile)~="function" or typeof(getcustomasset)~="function" then return end
		local parts={
			"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"
		}
		local data=table.concat(parts)
		local A="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
		local map={}
		for i=1,64 do map[string.byte(A,i)]=i-1 end
		local out,n={},0
		for i=1,#data,4 do
			local a,b,c,d=string.byte(data,i,i+3)
			local v=map[a]*262144+map[b]*4096+(map[c] or 0)*64+(map[d] or 0)
			local x,y,z=math.floor(v/65536)%256,math.floor(v/256)%256,v%256
			n+=1
			if c==61 then out[n]=string.char(x) elseif d==61 then out[n]=string.char(x,y) else out[n]=string.char(x,y,z) end
		end
		writefile("vox_logo.png",table.concat(out))
		logoImg.Image=getcustomasset("vox_logo.png")
		logoImg.Visible=true; U.logoOK=true
	end)
end
topToggle.MouseButton1Click:Connect(function()
	if not U.debounce(topToggle) then return end
	if U.welcome and U.welcome.Visible then U.hideWelcome()
	elseif main.Visible then task.spawn(minimize)
	else openUI() end
end)
minBtn.MouseButton1Click:Connect(function() if U.debounce(minBtn) then minimize() end end)
resetBtn.MouseButton1Click:Connect(function() if U.debounce(resetBtn) then tween(main,{Position=DEFAULT_POS},0.3) end end)
closeBtn.MouseButton1Click:Connect(function() if U.debounce(closeBtn) then stopFlight(); for m in pairs(Tracked) do untrack(m) end; S.Fullbright=false; pcall(applyFB); S.NoFog=false; pcall(U.applyFog); S.FPSBoost=false; S.FPSExtreme=false; task.spawn(function() pcall(U.applyFPS) end); gui:Destroy() end end)

local aimTouch
if UIS.TouchEnabled then
	aimTouch=new("TextButton",{Size=UDim2.fromOffset(66,66),Position=UDim2.new(1,-185,1,-245),BackgroundColor3=BG,
		Text="AIM",Font=Enum.Font.GothamBlack,TextSize=15,AutoButtonColor=false},gui)
	accent(aimTouch,"TextColor3"); corner(aimTouch,33); stroke(aimTouch,2.5,0.1)
	aimTouch.MouseButton1Down:Connect(function()
		if S.AimMode=="Hold" then S.AimActive=true elseif S.AimMode=="Toggle" then S.AimActive=not S.AimActive end
	end)
	aimTouch.MouseButton1Up:Connect(function() if S.AimMode=="Hold" then S.AimActive=false end end)
end

UIS.InputBegan:Connect(function(i,gp)
	if capturing then return end
	if i.KeyCode==S.ToggleKey and U.welcome and U.welcome.Visible then U.hideWelcome() return end
	if i.KeyCode==S.ToggleKey then if main.Visible then minimize() else openUI() end return end
	if gp then return end
	if i.KeyCode~=Enum.KeyCode.Unknown then
		if i.KeyCode==S.FlyKey then if U.debounce("flykey") then flyTo(nearestOf()) end return end
		if i.KeyCode==S.StopKey then stopFlight() return end
	end
	local isAim=(i.UserInputType==Enum.UserInputType.MouseButton2) or (S.AimKey~=Enum.KeyCode.Unknown and i.KeyCode==S.AimKey)
	if isAim then
		if S.AimMode=="Hold" then S.AimActive=true elseif S.AimMode=="Toggle" then S.AimActive=not S.AimActive end
	end
end)
UIS.InputEnded:Connect(function(i)
	local isAim=(i.UserInputType==Enum.UserInputType.MouseButton2) or (S.AimKey~=Enum.KeyCode.Unknown and i.KeyCode==S.AimKey)
	if isAim and S.AimMode=="Hold" then S.AimActive=false end
end)

--==================== مساعد التصويب ====================
local fov=new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),BackgroundTransparency=1},gui)
corner(fov,9999)
local fovStroke=new("UIStroke",{Thickness=2},fov)
local targetCard=new("TextLabel",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,52),Size=UDim2.fromOffset(290,34),
	BackgroundColor3=BG,BackgroundTransparency=0.1,Font=Enum.Font.GothamBold,TextSize=13,TextColor3=TXT,RichText=true,Visible=false},gui)
corner(targetCard,10); stroke(targetCard,1.2,0.3)

local rayParams=RaycastParams.new(); rayParams.FilterType=Enum.RaycastFilterType.Exclude

local function aimPoint(m,d)
	if S.AimPart=="Head" then local h=m:FindFirstChild("Head"); if h then return h.Position end
	elseif S.AimPart=="Center" then return (m:GetBoundingBox()).Position end
	return d.root.Position
end

local function predicted(d,p)
	if not S.Prediction then return p end
	local vel=d.root.AssemblyLinearVelocity
	if d.hum and vel.Magnitude<0.5 then vel=d.hum.MoveDirection*d.hum.WalkSpeed end
	return p+vel*S.PredTime
end

local function visiblePoint(m,d)
	local o=Cam.CFrame.Position
	rayParams.FilterDescendantsInstances={LP.Character,m}
	local rp=d.root.Position
	local hy=d.root.Size.Y/2
	local head=m:FindFirstChild("Head")
	local pts={head and head.Position or rp+Vector3.new(0,hy,0), rp, rp-Vector3.new(0,hy,0)}
	for _,p in ipairs(pts) do
		if not workspace:Raycast(o,p-o,rayParams) then return true end
	end
	return false
end

local function validTarget(m)
	local d=Tracked[m]; local r=myRoot()
	if not d or not r or not d.root.Parent or not S.AimRarities[d.rarity] then return false end
	if d.hum and d.hum.Health<=0 then return false end
	local p=aimPoint(m,d)
	if (p-r.Position).Magnitude>S.AimDist then return false end
	local sp,on=Cam:WorldToViewportPoint(p); if not on then return false end
	if (Vector2.new(sp.X,sp.Y)-Cam.ViewportSize/2).Magnitude>S.FOV then return false end
	if S.WallCheck and not visiblePoint(m,d) then return false end
	return true
end

local function scoreOf(m,d)
	local r=myRoot(); if not r then return math.huge end
	local p=aimPoint(m,d)
	local sp=Cam:WorldToViewportPoint(p)
	local sd=(Vector2.new(sp.X,sp.Y)-Cam.ViewportSize/2).Magnitude
	local wd=(p-r.Position).Magnitude
	return (S.Priority=="Screen" and sd) or (S.Priority=="Closest" and wd)
		or (-(table.find(CONFIG.RarityOrder,d.rarity) or 0)*100000+sd)
end

local function pickTarget()
	if not myRoot() then return nil end
	local best,bs
	for m,d in pairs(Tracked) do
		if validTarget(m) then
			local score=scoreOf(m,d)
			if not bs or score<bs then best,bs=m,score end
		end
	end
	return best,bs
end

local function tracerOrigin()
	local vs=Cam.ViewportSize
	if S.TracerFrom=="Top" then return Vector2.new(vs.X/2,0) end
	if S.TracerFrom=="Center" then return vs/2 end
	return Vector2.new(vs.X/2,vs.Y)
end

local lastFire=0
local function fireOnce()
	local ok=false
	if typeof(mouse1click)=="function" then ok=pcall(mouse1click) end
	if not ok then
		local ch=LP.Character; local tool=ch and ch:FindFirstChildOfClass("Tool")
		U.snapUntil=tick()+0.1
	if tool then pcall(function() tool:Activate() end) end
	end
end

local function updateArrow(d,vs)
	local a=d.arrow; if not a then return end
	if not (S.OffScreen and d.vis) then if a.Visible then a.Visible=false end return end
	local sp,on=Cam:WorldToViewportPoint(d.root.Position)
	if on and sp.X>0 and sp.X<vs.X and sp.Y>0 and sp.Y<vs.Y then if a.Visible then a.Visible=false end return end
	local rel=Cam.CFrame:PointToObjectSpace(d.root.Position)
	local dx,dy=rel.X,-rel.Y
	if math.abs(dx)<0.001 and math.abs(dy)<0.001 then dx=1 end
	local mag=math.max(math.abs(dx)/(vs.X/2-30),math.abs(dy)/(vs.Y/2-30))
	a.Position=UDim2.fromOffset(vs.X/2+dx/mag,vs.Y/2+dy/mag)
	a.Rotation=math.deg(math.atan2(dy,dx))
	a.TextColor3=CONFIG.RarityColors[d.rarity]
	a.Visible=true
end

--==================== FPS + حركة حدود الواجهة ====================
local fpsAccum={count=0,time=0}
RunService.RenderStepped:Connect(function(dt)
	fpsAccum.count+=1; fpsAccum.time+=dt
	if fpsAccum.time>=0.5 then
		S._fps=math.floor(fpsAccum.count/fpsAccum.time+0.5)
		fpsAccum.count=0; fpsAccum.time=0
	end
	if U.mg and main.Visible then U.mg.Rotation=(U.mg.Rotation+dt*60)%360 end
end)

--==================== الحلقة الرئيسية ====================
local mainF=0
RunService.RenderStepped:Connect(function(dt)
	if not gui.Parent then return end
	Cam=workspace.CurrentCamera or Cam
	local vs=Cam.ViewportSize
	fov.Visible=S.Aim and S.ShowFOV
	fov.Size=UDim2.fromOffset(S.FOV*2,S.FOV*2)
	local fc=ACCENTS[S.FOVColor].c
	fovStroke.Color=fc; fovStroke.Thickness=S.FOVThick; fovStroke.Transparency=S.FOVTrans
	fov.BackgroundColor3=fc; fov.BackgroundTransparency=S.FOVFilled and math.max(S.FOVTrans,0.85) or 1
	main.BackgroundTransparency=S.UITrans
	shadow.Position=UDim2.new(main.Position.X.Scale,main.Position.X.Offset-8,main.Position.Y.Scale,main.Position.Y.Offset-4)
	shadow.Size=UDim2.fromOffset((W+16)*scale.Scale,(H+16)*scale.Scale)
	if aimTouch then
		aimTouch.Visible=S.Aim and S.AimMode~="Always"
		aimTouch.BackgroundColor3=S.AimActive and PANEL2 or BG
	end

	mainF=(mainF or 0)+1
	local from=tracerOrigin()
	if mainF%3==0 or S.Aim then for _,d in pairs(Tracked) do
		if d.root.Parent then
			local tr=d.tracer
			if tr then
				if S.Tracers and d.vis then
					local sp,on=Cam:WorldToViewportPoint(d.root.Position)
					if on then
						local to=Vector2.new(sp.X,sp.Y); local mid=(from+to)/2
						tr.Position=UDim2.fromOffset(mid.X,mid.Y)
						tr.Size=UDim2.fromOffset((to-from).Magnitude,1.5)
						tr.Rotation=math.deg(math.atan2(to.Y-from.Y,to.X-from.X))
						tr.Visible=true
					elseif tr.Visible then tr.Visible=false end
				elseif tr.Visible then tr.Visible=false end
			end
			updateArrow(d,vs)
		end
	end end

	local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	local active=S.Aim and (S.AimMode=="Always" or S.AimActive) and hum and hum.Health>0
	if not active then currentTarget=nil; targetCard.Visible=false; return end

	if currentTarget and validTarget(currentTarget) then
		if not S.StickyTarget then
			local cand,cs=pickTarget()
			if cand and cand~=currentTarget and cs then
				local thr=(S.Priority=="Closest" and S.AimDist or S.FOV)*S.Hysteresis
				if cs<scoreOf(currentTarget,Tracked[currentTarget])-thr then currentTarget=cand end
			end
		end
	else
		currentTarget=pickTarget()
	end

	local d=currentTarget and Tracked[currentTarget]
	if not d then targetCard.Visible=false; return end
	local base=aimPoint(currentTarget,d)
	local p=predicted(d,base)
	local alpha=math.clamp(S.Strength*(1-math.pow(1-S.Smooth,dt*60)),0.005,1)
	Cam.CFrame=Cam.CFrame:Lerp(CFrame.lookAt(Cam.CFrame.Position,p),alpha)

	if S.AutoFire and os.clock()-lastFire>0.08 then
		local to=(p-Cam.CFrame.Position)
		if to.Magnitude>0.01 then
			local ang=math.deg(math.acos(math.clamp(Cam.CFrame.LookVector:Dot(to.Unit),-1,1)))
			if ang<=S.AutoFireAngle then lastFire=os.clock(); fireOnce() end
		end
	end

	if S.ShowTargetInfo then
		local r=myRoot()
		targetCard.Text=string.format("%s  <font color='#%s'>%s</font>  %dm",currentTarget.Name,
			CONFIG.RarityColors[d.rarity]:ToHex(),RName(d.rarity),r and math.floor((base-r.Position).Magnitude) or 0)
		targetCard.Visible=true
	else targetCard.Visible=false end
end)

--==================== تحديث الإضاءة ====================
local function refreshVisuals()
	local r=myRoot(); local pos=r and r.Position
	local total,inRange,alive,by=0,0,0,{}
	for m,d in pairs(Tracked) do
		if not m.Parent or not d.root.Parent then untrack(m) else
			total+=1
			by[d.rarity]=(by[d.rarity] or 0)+1
			local hum=d.hum
			if not hum or hum.Health>0 then alive+=1 end
			local dist=pos and (d.root.Position-pos).Magnitude or 0
			d.dist=dist
			local vis=S.ESP and S.Rarities[d.rarity] and dist<=S.MaxDist and not Muted[m]
			d.vis=vis and true or false
			if vis then inRange+=1 end
			local col=CONFIG.RarityColors[d.rarity]
			local isT=(m==currentTarget)
			local isF=(Flying.target==m)

			local fade=0
			if S.DistFade then
				local s0=S.MaxDist*0.7
				if dist>s0 then fade=math.clamp((dist-s0)/(S.MaxDist-s0),0,1) end
			end

			local fillT
			if S.Chams then fillT=S.ChamsT
			elseif S.Fill then fillT=S.FillT else fillT=1 end
			if (S.Chams or S.Fill) and (isT or isF) then fillT=fillT*0.5 end
			local outT=S.Outline and S.OutlineT or 1
			U.setp(d,d.hl,"Enabled",vis and (S.Fill or S.Outline or S.Chams) and true or false)
			U.setp(d,d.hl,"FillColor",col)
			U.setp(d,d.hl,"OutlineColor",isF and Color3.fromRGB(80,255,150) or (isT and Color3.new(1,1,1) or col))
			U.setp(d,d.hl,"FillTransparency",lerp(fillT,1,fade))
			U.setp(d,d.hl,"OutlineTransparency",lerp(outT,1,fade))
			U.setp(d,d.hl,"DepthMode",(S.AlwaysOnTop or S.Chams) and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded)

			U.setp(d,d.bb,"Enabled",vis and (S.ShowName or S.ShowRarity or S.ShowDist or S.ShowHealth or S.HealthBar) and true or false)
			U.setp(d,d.bb,"StudsOffset",Vector3.new(0,S.LabelHeight,0))
			local l1,l2={},{}
			if isF then table.insert(l1,"") end
			if S.ShowName then table.insert(l1,"<b>"..m.Name.."</b>") end
			if S.ShowRarity then table.insert(l1,"["..RName(d.rarity).."]") end
			if S.ShowDist then table.insert(l2,math.floor(dist).."m") end
			if S.ShowHealth and hum then table.insert(l2,"HP "..math.floor(hum.Health)) end
			U.setp(d,d.label,"Text",table.concat(l1," ")..(#l2>0 and "\n"..table.concat(l2,"  ") or ""))
			U.setp(d,d.label,"TextColor3",col)
			U.setp(d,d.label,"TextSize",S.TextSize)
			U.setp(d,d.label,"TextTransparency",fade)
			U.setp(d,d.label,"TextStrokeTransparency",lerp(0.8,1,fade))

			local showBar=S.HealthBar and hum and hum.MaxHealth>0
			U.setp(d,d.bar,"Visible",showBar and true or false)
			if showBar then
				local frac=math.clamp(hum.Health/hum.MaxHealth,0,1)
				U.setp(d,d.barFill,"Size",UDim2.fromScale(frac,1))
				U.setp(d,d.barFill,"BackgroundColor3",Color3.fromHSV(frac*0.33,0.85,1))
				U.setp(d,d.bar,"BackgroundTransparency",fade)
				U.setp(d,d.barFill,"BackgroundTransparency",fade)
			end

			local showBox=vis and S.Box
			U.setp(d,d.box,"Enabled",showBox and true or false)
			if showBox then
				local okb,cf,sz=pcall(function() return m:GetBoundingBox() end)
				if okb then
					U.setp(d,d.box,"Size",UDim2.fromScale(math.max(sz.X,sz.Z),sz.Y))
					U.setp(d,d.box,"StudsOffsetWorldSpace",cf.Position-d.root.Position)
					U.setp(d,d.boxStroke,"Color",col)
					U.setp(d,d.boxStroke,"Transparency",fade)
				end
			end

			if d.tracer then U.setp(d,d.tracer,"BackgroundColor3",col) end
		end
	end
	Counts.total,Counts.inRange,Counts.alive,Counts.byRarity=total,inRange,alive,by
end

do
--==================== Silent Aim / Magic Bullet ====================
local Silent={point=nil,model=nil,part=nil}
local Mouse=LP:GetMouse()
local silentFov=new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,Visible=false},gui)
corner(silentFov,9999)
local sfStroke=new("UIStroke",{Thickness=1.5,Transparency=0.3},silentFov); accent(sfStroke,"Color")

local function pickSilent()
	local r=myRoot(); if not r then return end
	local mp=Cam.ViewportSize/2
	local best,bs,bp,bpart
	for m,d in pairs(Tracked) do
		if d.root.Parent and S.AimRarities[d.rarity] and not Muted[m] and (not d.hum or d.hum.Health>0) then
			local p=predicted(d,aimPoint(m,d))
			if (p-r.Position).Magnitude<=S.AimDist then
				local sp,on=Cam:WorldToViewportPoint(p)
				if on then
					local sd=(Vector2.new(sp.X,sp.Y)-mp).Magnitude
					if sd<=S.SilentFOV and (not bs or sd<bs) then best,bs,bp,bpart=m,sd,p,d.root end
				end
			end
		end
	end
	if not best and S.MagicBullet then
		local bd
		for m,d in pairs(Tracked) do
			if d.root.Parent and S.AimRarities[d.rarity] and not Muted[m] and (not d.hum or d.hum.Health>0) then
				local dist=(d.root.Position-r.Position).Magnitude
				if dist<=S.MagicRange and (not bd or dist<bd) then best,bd,bp,bpart=m,dist,predicted(d,aimPoint(m,d)),d.root end
			end
		end
	end
	return best,bp,bpart
end

RunService.RenderStepped:Connect(function()
	if not gui.Parent then return end
	Silent.model,Silent.point,Silent.part=nil,nil,nil
	local on=S.SilentAim or S.MagicBullet
	silentFov.Visible=on and S.ShowSilentFOV
	if not on then return end
	silentFov.Position=UDim2.fromScale(0.5,0.5)
	silentFov.Size=UDim2.fromOffset(S.SilentFOV*2,S.SilentFOV*2)
	Silent.model,Silent.point,Silent.part=pickSilent()
end)

-- Delta-safe: no metamethod hooks. While firing, the camera snaps to the target.
local installHooks
local fireHeld=false
UIS.InputBegan:Connect(function(i,gp)
	if gp then return end
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then fireHeld=true end
end)
UIS.InputEnded:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then fireHeld=false end
end)
-- Wall pierce: while firing, parts between you and the target stop answering raycasts (client side only)
do
	local hidden={}
	local lastW=0
	local rp=RaycastParams.new(); rp.FilterType=Enum.RaycastFilterType.Exclude
	local function restore()
		for part,v in pairs(hidden) do if part.Parent then part.CanQuery=v end hidden[part]=nil end
	end
	RunService.Heartbeat:Connect(function()
		if not gui.Parent then return end
		local firing=(S.SilentAim or S.MagicBullet) and S.WallPierce and Silent.point and (fireHeld or tick()<(U.snapUntil or 0))
		if not firing then if next(hidden) and os.clock()>lastW+0.35 then restore() end return end
		local o=Cam.CFrame.Position
		local ex={LP.Character}
		if Silent.model then table.insert(ex,Silent.model) end
		for part in pairs(hidden) do table.insert(ex,part) end
		rp.FilterDescendantsInstances=ex
		local dir=Silent.point-o
		for _=1,8 do
			local hit=workspace:Raycast(o,dir,rp)
			if not hit or not hit.Instance then break end
			local part=hit.Instance
			if not hidden[part] then hidden[part]=part.CanQuery; part.CanQuery=false end
			table.insert(ex,part); rp.FilterDescendantsInstances=ex
		end
		lastW=os.clock()
	end)
end
RunService.RenderStepped:Connect(function()
	if not gui.Parent then return end
	if (S.SilentAim or S.MagicBullet) and not U.hookTried then U.hookTried=true; installHooks() end
	if not Silent.point then return end
	if not (S.SilentAim or S.MagicBullet) then return end
	if U.hookOK then return end
	if not (fireHeld or tick()<(U.snapUntil or 0)) then return end
	if math.random(1,100)>S.SilentChance then return end
	local pos=Cam.CFrame.Position
	if (Silent.point-pos).Magnitude>0.5 then Cam.CFrame=CFrame.lookAt(pos,Silent.point) end
end)

installHooks=function() pcall(function()
	if typeof(hookmetamethod)~="function" or typeof(getnamecallmethod)~="function" then
		-- tier 2: Mouse.Hit/Target only, via raw metatable (no namecall needed)
		if typeof(getrawmetatable)~="function" then return end
		local mt=getrawmetatable(game)
		local ro=(typeof(setreadonly)=="function" and setreadonly) or (typeof(make_writeable)=="function" and function(t,f) if not f then make_writeable(t) end end)
		if not mt or not ro then return end
		local wrap2=(typeof(newcclosure)=="function") and newcclosure or function(f) return f end
		local oldI=mt.__index
		ro(mt,false)
		mt.__index=wrap2(function(self,key)
			if self==Mouse and Silent.point and (S.SilentAim or S.MagicBullet) and (key=="Hit" or key=="Target") then
				if key=="Hit" then return CFrame.new(Silent.point) end
				return Silent.part
			end
			return oldI(self,key)
		end)
		pcall(ro,mt,true)
		U.hookOK=true; U.hookPartial=true
		return
	end
	local checker=(typeof(checkcaller)=="function") and checkcaller or function() return false end
	local wrap=(typeof(newcclosure)=="function") and newcclosure or function(f) return f end
	local oldNC
	oldNC=hookmetamethod(game,"__namecall",wrap(function(self,...)
		if Silent.point and self==workspace and (S.SilentAim or S.MagicBullet) and not checker() then
			local method=getnamecallmethod()
			if (method=="Raycast" or method=="FindPartOnRay" or method=="FindPartOnRayWithIgnoreList") and math.random(1,100)<=S.SilentChance then
				local n=select("#",...)
				local a={...}
				if method=="Raycast" and typeof(a[1])=="Vector3" and typeof(a[2])=="Vector3" then
					local to=Silent.point-a[1]
					a[2]=to.Unit*math.max(a[2].Magnitude,to.Magnitude+2)
					if S.MagicBullet and Silent.model then
						local rp=RaycastParams.new()
						rp.FilterType=Enum.RaycastFilterType.Include
						rp.FilterDescendantsInstances={Silent.model}
						a[3]=rp
					end
					return oldNC(self,table.unpack(a,1,math.max(n,3)))
				elseif method~="Raycast" and typeof(a[1])=="Ray" then
					local o=a[1].Origin; local to=Silent.point-o
					a[1]=Ray.new(o,to.Unit*math.max(a[1].Direction.Magnitude,to.Magnitude+2))
					return oldNC(self,table.unpack(a,1,n))
				end
			end
		end
		return oldNC(self,...)
	end))
	local oldIdx
	oldIdx=hookmetamethod(game,"__index",wrap(function(self,key)
		if self==Mouse and Silent.point and (S.SilentAim or S.MagicBullet) and not checker() then
			if key=="Hit" then return CFrame.new(Silent.point) end
			if key=="Target" then return Silent.part end
		end
		return oldIdx(self,key)
	end))
	U.hookOK=true
end) end


--==================== Auto food / water ====================
do
	local cache={}
	local function findStat(kind)
		local c=cache[kind]
		if c and c.i and c.i.Parent then return c end
		local words=kind=="food" and {"hunger","food","hungry"} or {"thirst","water","drink"}
		local function match(n) n=string.lower(n); for _,w in ipairs(words) do if string.find(n,w,1,true) then return true end end end
		local roots={LP,LP.Character}
		for _,r in ipairs(roots) do
			if r then
				for k,v in pairs(r:GetAttributes()) do
					if type(v)=="number" and match(k) then cache[kind]={i=r,attr=k}; return cache[kind] end
				end
				for _,d in ipairs(r:GetDescendants()) do
					if (d:IsA("NumberValue") or d:IsA("IntValue")) and match(d.Name) then cache[kind]={i=d}; return cache[kind] end
				end
			end
		end
	end
	local function readStat(c) if not c then return nil end if c.attr then return c.i:GetAttribute(c.attr) end return c.i.Value end
	local function useTool(words)
		local ch=LP.Character; local hum=ch and ch:FindFirstChildOfClass("Humanoid"); if not hum then return false end
		local bp=LP:FindFirstChildOfClass("Backpack")
		local function ok(t) local n=string.lower(t.Name); for _,w in ipairs(words) do if string.find(n,w,1,true) then return true end end end
		local tool
		for _,t in ipairs(ch:GetChildren()) do if t:IsA("Tool") and ok(t) then tool=t break end end
		if not tool and bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") and ok(t) then tool=t break end end end
		if not tool then return false end
		if tool.Parent~=ch then pcall(function() hum:EquipTool(tool) end); task.wait(0.15) end
		pcall(function() tool:Activate() end)
		return true
	end
	local function usePrompt(words)
		if typeof(fireproximityprompt)~="function" then return false end
		local r=myRoot(); if not r then return false end
		for pr in pairs(U.prompts) do
			if pr.Parent and pr.Enabled then
				local txt=string.lower((pr.ActionText or "").." "..(pr.ObjectText or "").." "..pr.Parent.Name)
				for _,w in ipairs(words) do
					if string.find(txt,w,1,true) then
						local part=pr.Parent
						local pos=part:IsA("BasePart") and part.Position or (part:IsA("Attachment") and part.WorldPosition)
						if pos and (pos-r.Position).Magnitude<=math.max(pr.MaxActivationDistance,8)+2 then
							pcall(fireproximityprompt,pr); return true
						end
					end
				end
			end
		end
		return false
	end
	local FW={"food","meat","bread","apple","eat","fruit","burger","steak","fish"}
	local WW={"water","drink","bottle","cup","juice"}
	local PW={"water","drink","fill","well","pump","food","eat"}
	task.spawn(function()
		while gui.Parent do
			task.wait(2)
			if S.AutoFood then
				local v=readStat(findStat("food"))
				if v and v<=S.AutoThresh then
					if not useTool(FW) then usePrompt({"food","eat"}) end
				end
			end
			if S.AutoWater then
				local v=readStat(findStat("water"))
				if v and v<=S.AutoThresh then
					if not useTool(WW) then usePrompt({"water","drink","fill"}) end
				end
			end
		end
	end)
end

--==================== Extra commands ====================
do
	local orig={}
	local function setOrig(k,get) if orig[k]==nil then orig[k]=get() end end
	task.spawn(function()
		while gui.Parent do
			task.wait(0.5)
			if S.ExtraGrav then setOrig("g",function() return workspace.Gravity end); workspace.Gravity=S.Gravity
			elseif orig.g then workspace.Gravity=orig.g; orig.g=nil end
			if S.ExtraTime then setOrig("t",function() return Lighting.ClockTime end); Lighting.ClockTime=S.ClockTime
			elseif orig.t then Lighting.ClockTime=orig.t; orig.t=nil end
			if S.ExtraZoom then setOrig("z",function() return LP.CameraMaxZoomDistance end); LP.CameraMaxZoomDistance=S.MaxZoom
			elseif orig.z then LP.CameraMaxZoomDistance=orig.z; orig.z=nil end
			if S.InstantPrompt or S.AutoPrompt then
				local r=myRoot()
				for pr in pairs(U.prompts) do
					if pr.Parent then
						if S.InstantPrompt and pr.HoldDuration~=0 then
							if not orig[pr] then orig[pr]=pr.HoldDuration end
							pr.HoldDuration=0
						end
						if S.AutoPrompt and r and typeof(fireproximityprompt)=="function" and pr.Enabled then
							local pt=pr.Parent
							local pos=pt:IsA("BasePart") and pt.Position or (pt:IsA("Attachment") and pt.WorldPosition)
							if pos and (pos-r.Position).Magnitude<=pr.MaxActivationDistance then pcall(fireproximityprompt,pr) end
						end
					end
				end
			elseif next(orig) then
				for k,v in pairs(orig) do if typeof(k)=="Instance" then pcall(function() k.HoldDuration=v end); orig[k]=nil end end
			end
		end
	end)
	RunService.RenderStepped:Connect(function()
		if S.ExtraFOV and Cam.FieldOfView~=S.CamFOV then Cam.FieldOfView=S.CamFOV end
	end)
end

--==================== Player ====================
local pOrig,ncParts={},{}
local function setNoclip(ch,on)
	if on then
		for _,p in ipairs(ch:GetDescendants()) do
			if p:IsA("BasePart") and p.CanCollide then ncParts[p]=true; p.CanCollide=false end
		end
	else
		for p in pairs(ncParts) do
			if p.Parent then p.CanCollide=true end
			ncParts[p]=nil
		end
	end
end
UIS.JumpRequest:Connect(function()
	if not S.InfJump then return end
	local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
end)
do
local function ammoName(n)
	n=string.lower(n)
	if n=="mag" or n=="bullets" or n=="rounds" then return true end
	for _,w in ipairs({"ammo","clip","magazine","reserve","ذخيرة","رصاص"}) do
		if string.find(n,w,1,true) then return true end
	end
	return false
end
local function cdName(n)
	n=string.lower(n)
	for _,w in ipairs({"cooldown","delay","interval","reloadtime","reload_time","firewait","firerate","fire_rate","rateoffire","debounce","equiptime"}) do
		if string.find(n,w,1,true) then return true end
	end
	return false
end
U.stat={vals=0,attrs=0,gc=0,mod=0}
local function cdTarget(k,v)
	if string.find(string.lower(k),"rate",1,true) then
		if v>20 then return 100000 elseif v>0.01 then return 0.01 end
		return nil
	end
	if v>0 then return 0 end
	return nil
end
local AMMO_MAX=999999999
RunService.Heartbeat:Connect(function() AMMO_MAX=(S.AmmoMode=="99999") and 99999 or 999999999 end)
local ammoHooked=setmetatable({},{__mode="k"})
local valOrig=setmetatable({},{__mode="k"})
local attrOrig=setmetatable({},{__mode="k"})
local gcOrig=setmetatable({},{__mode="k"})
local function patchTool(root,withSelf)
	local function fix(o)
		local isVal=o:IsA("IntValue") or o:IsA("NumberValue")
		if S.InfAmmo and isVal and ammoName(o.Name) then
			if o.Value<AMMO_MAX*0.9 then o.Value=AMMO_MAX; U.stat.vals+=1 end
			if not ammoHooked[o] then
				ammoHooked[o]=o.Changed:Connect(function()
					if S.InfAmmo and o.Value<AMMO_MAX*0.9 then o.Value=AMMO_MAX end
				end)
			end
		end
		if S.NoCooldown and isVal and cdName(o.Name) then
			local nv=cdTarget(o.Name,o.Value)
			if nv~=nil and nv~=o.Value then
				if valOrig[o]==nil then valOrig[o]=o.Value end
				o.Value=nv
			end
		end
		for k,v in pairs(o:GetAttributes()) do
			if type(v)=="number" then
				if S.InfAmmo and ammoName(k) then
					if v<AMMO_MAX*0.9 then o:SetAttribute(k,AMMO_MAX); U.stat.attrs+=1 end
					local hk=ammoHooked[o]
					if type(hk)~="table" then hk={}; ammoHooked[o]=hk end
					if not hk[k] then
						hk[k]=o:GetAttributeChangedSignal(k):Connect(function()
							local nv=o:GetAttribute(k)
							if S.InfAmmo and type(nv)=="number" and nv<AMMO_MAX*0.9 then o:SetAttribute(k,AMMO_MAX) end
						end)
					end
				end
				if S.NoCooldown and cdName(k) then
					local nv=cdTarget(k,v)
					if nv~=nil and nv~=v then
						attrOrig[o]=attrOrig[o] or {}
						if attrOrig[o][k]==nil then attrOrig[o][k]=v end
						o:SetAttribute(k,nv)
					end
				end
			end
		end
	end
	if withSelf then fix(root) end
	for _,d in ipairs(root:GetDescendants()) do fix(d) end
end
local function restoreCd()
	for o,v in pairs(valOrig) do if o.Parent then pcall(function() o.Value=v end) end; valOrig[o]=nil end
	for o,t in pairs(attrOrig) do
		if o.Parent then for k,v in pairs(t) do pcall(function() o:SetAttribute(k,v) end) end end
		attrOrig[o]=nil
	end
	for t,kv in pairs(gcOrig) do
		for k,v in pairs(kv) do pcall(rawset,t,k,v) end
		gcOrig[t]=nil
	end
end
local deepAmmo={"Ammo","ammo","CurrentAmmo","currentAmmo","Clip","clip","Magazine","magazine","ReserveAmmo","reserveAmmo"}
local cdKeys={"Cooldown","cooldown","FireRate","fireRate","Firerate","RateOfFire","ReloadTime","reloadTime","ReloadSpeed","Delay","delay","Debounce","debounce","ShotCooldown","FireCooldown","ShootCooldown","EquipTime"}
local function deepScan()
	if typeof(getgc)~="function" then return end
	local gc=getgc(true)
	local doAmmo=S.InfAmmo and S.AmmoDeep
	local doCd=S.NoCooldown and S.AmmoDeep
	for i=1,#gc do
		local t=gc[i]
		if type(t)=="table" then
			if doAmmo then
				for _,k in ipairs(deepAmmo) do
					local v=rawget(t,k)
					if type(v)=="number" and v>=0 and v<AMMO_MAX*0.9 then pcall(rawset,t,k,AMMO_MAX); U.stat.gc+=1 end
				end
			end
			if doCd then
				for _,k in ipairs(cdKeys) do
					local v=rawget(t,k)
					if type(v)=="number" then
						local nv=cdTarget(k,v)
						if nv~=nil and nv~=v then
							gcOrig[t]=gcOrig[t] or {}
							if gcOrig[t][k]==nil then gcOrig[t][k]=v end
							pcall(rawset,t,k,nv)
						end
					end
				end
			end
		end
	end
end
local function patchTableDeep(t,depth,seen)
	if depth>4 or seen[t] then return end
	seen[t]=true
	for k,v in pairs(t) do
		if type(k)=="string" then
			if type(v)=="number" then
				if S.InfAmmo and (ammoName(k) or string.find(string.lower(k),"capacity",1,true)) and v<AMMO_MAX*0.9 then
					if pcall(rawset,t,k,AMMO_MAX) then U.stat.mod+=1 end
				end
				if S.NoCooldown and cdName(k) then
					local nv=cdTarget(k,v)
					if nv~=nil and nv~=v then
						gcOrig[t]=gcOrig[t] or {}
						if gcOrig[t][k]==nil then gcOrig[t][k]=v end
						pcall(rawset,t,k,nv)
					end
				end
			elseif type(v)=="table" then
				patchTableDeep(v,depth+1,seen)
			end
		end
	end
end
local function patchModules()
	local mods={}
	local okL,loaded=pcall(function() return typeof(getloadedmodules)=="function" and getloadedmodules() or nil end)
	if okL and loaded then mods=loaded else
		for _,root in ipairs({LP.Character,LP:FindFirstChildOfClass("Backpack"),game:GetService("ReplicatedStorage")}) do
			if root then for _,d in ipairs(root:GetDescendants()) do if d:IsA("ModuleScript") then table.insert(mods,d) end end end
		end
	end
	local seen={}
	for _,m in ipairs(mods) do
		local nm=string.lower(m.Name)
		local weaponish=string.find(nm,"gun",1,true) or string.find(nm,"weapon",1,true) or string.find(nm,"ammo",1,true) or string.find(nm,"config",1,true)
			or string.find(nm,"setting",1,true) or string.find(nm,"stat",1,true) or string.find(nm,"tool",1,true) or string.find(nm,"fire",1,true)
			or string.find(nm,"shoot",1,true) or (m.Parent and m.Parent:IsA("Tool"))
		if weaponish then
			local ok,res=pcall(require,m)
			if ok and type(res)=="table" then patchTableDeep(res,0,seen) end
		end
	end
end
task.spawn(function()
	local lastNC,n=false,0
	while gui.Parent do
		if S.InfAmmo or S.NoCooldown then
			n+=1
			if not U.wasOn then U.wasOn=true; U.deepNeed=true end
			local ch=LP.Character
			if ch then for _,t in ipairs(ch:GetChildren()) do if t:IsA("Tool") then pcall(patchTool,t,true) end end end
			local bp=LP:FindFirstChildOfClass("Backpack")
			if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then pcall(patchTool,t,true) end end end
			if U.deepNeed and os.clock()>(U.deepLast or 0)+6 then
				U.deepNeed=false; U.deepLast=os.clock()
				if S.InfAmmo and S.AmmoDeep then pcall(patchTool,LP,false) end
				pcall(deepScan)
				pcall(patchModules)
			end
		end
		if not (S.InfAmmo or S.NoCooldown) then U.wasOn=false end
		if lastNC and not S.NoCooldown then restoreCd() end
		lastNC=S.NoCooldown
		task.wait(0.25)
	end
end)
LP.CharacterAdded:Connect(function(c) c.ChildAdded:Connect(function(t) if t:IsA("Tool") then U.deepNeed=true end end) end)
local fireT=0
RunService.Heartbeat:Connect(function(dt)
	if not S.FastShot or not gui.Parent then return end
	fireT+=dt
	if fireT<1/math.max(S.FastRate,1) then return end
	if not (S.FastAlways or UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)) then return end
	fireT=0
	local ch=LP.Character
	local tool=ch and ch:FindFirstChildOfClass("Tool")
	if tool then pcall(function() tool:Activate() end) end
end)
end

local adapt={}
local function adaptCap(key,root,dt)
	local a=adapt[key]
	if not a then a={cap=1,exp=nil}; adapt[key]=a end
	if a.exp then
		local off=(root.Position-a.exp).Magnitude
		if off>10 then a.cap=math.max(0.3,a.cap*0.6); a.exp=nil end
	end
	a.cap=math.min(1,a.cap+dt*0.08)
	return a
end
local function flyInput(hum,seat)
	local cf=Cam.CFrame
	local look,right=cf.LookVector,cf.RightVector
	local fl=Vector3.new(look.X,0,look.Z); fl=fl.Magnitude>0.001 and fl.Unit or Vector3.zero
	local fr=Vector3.new(right.X,0,right.Z); fr=fr.Magnitude>0.001 and fr.Unit or Vector3.zero
	if S.FlyDirMode=="Flat" then look,right=fl,fr end
	local function dn(k) return k~=Enum.KeyCode.Unknown and UIS:IsKeyDown(k) end
	local h=Vector3.zero
	if dn(S.FlyFwdKey) or U.padFwd then h+=look end
	if dn(S.FlyBackKey) or U.padBack then h-=look end
	if dn(S.FlyRightKey) or U.padRight then h+=right end
	if dn(S.FlyLeftKey) or U.padLeft then h-=right end
	if h.Magnitude<0.01 and seat and seat:IsA("VehicleSeat") then
		local th,st=seat.ThrottleFloat,seat.SteerFloat
		if th~=0 or st~=0 then h=look*th+right*st end
	end
	if h.Magnitude<0.01 and not U.padUp then
		local md=hum.MoveDirection
		if md.Magnitude>0.01 then h=look*md:Dot(fl)+right*md:Dot(fr) end
	end
	if h.Magnitude>1 then h=h.Unit end
	local v=0
	if dn(S.FlyUpKey) or U.padUp then v+=1 end
	if dn(S.FlyDownKey) or U.padDown then v-=1 end
	if UIS.TouchEnabled and hum.Jump then v=1 end
	local mult=(dn(S.FlySprintKey) or U.padBoost) and S.FlySprint or 1
	return h,v*S.FlyVertMul,mult
end
local pad=new("Frame",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-16,0,60),Size=UDim2.fromOffset(190,190),BackgroundColor3=BG,BackgroundTransparency=0.35,Visible=false},gui)
corner(pad,18); stroke(pad,2,0.3)
local padScale=new("UIScale",{Scale=1},pad)
local lpad=new("Frame",{AnchorPoint=Vector2.new(0,0),Position=UDim2.new(0,16,0,60),Size=UDim2.fromOffset(190,190),BackgroundColor3=BG,BackgroundTransparency=0.35,Visible=false},gui)
corner(lpad,18); stroke(lpad,2,0.3)
local lpadScale=new("UIScale",{Scale=1},lpad)
local function padBtn(parent,x,y,w,h,text,key,onTap)
	local b=new("TextButton",{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),BackgroundColor3=PANEL,BackgroundTransparency=0.1,
		Font=Enum.Font.GothamBlack,TextSize=13,TextColor3=TXT,AutoButtonColor=false},parent)
	corner(b,12); stroke(b,1.5,0.35)
	reg(function() b.Text=type(text)=="table" and L(text) or text end)
	local function isP(i) return i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch end
	b.InputBegan:Connect(function(i)
		if isP(i) then
			if key then U[key]=true end
			if onTap then onTap() end
			tween(b,{BackgroundColor3=PANEL3},0.08)
		end
	end)
	b.InputEnded:Connect(function(i)
		if isP(i) then if key then U[key]=false end; tween(b,{BackgroundColor3=PANEL},0.08) end
	end)
	return b
end
-- right box: movement cross (like Minecraft)
padBtn(pad,65,10,60,56,{ar="أمام",en="W"},"padFwd")
padBtn(pad,3+0,67,60,56,{ar="يسار",en="A"},"padLeft")
padBtn(pad,127,67,60,56,{ar="يمين",en="D"},"padRight")
padBtn(pad,65,124,60,56,{ar="خلف",en="S"},"padBack")
padBtn(pad,65,67,60,56,{ar="تسريع",en="x2"},"padBoost")
-- left box: up / speed / down
padBtn(lpad,15,10,160,50,{ar="صعود",en="UP"},"padUp")
local spdLbl=new("TextLabel",{Position=UDim2.fromOffset(15,70),Size=UDim2.fromOffset(160,24),BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=13,TextColor3=TXT},lpad)
local function spdField() return S.VehFly and "VehFlySpeed" or "FreeFlySpeed" end
local function stepSpeed(d)
	local f=spdField()
	S[f]=math.clamp(S[f]+d,10,f=="VehFlySpeed" and 600 or 300)
end
padBtn(lpad,15,98,76,40,"-",nil,function() stepSpeed(-10) end)
padBtn(lpad,99,98,76,40,"+",nil,function() stepSpeed(10) end)
padBtn(lpad,15,142,160,40,{ar="هبوط",en="DOWN"},"padDown")
RunService.RenderStepped:Connect(function()
	local show=S.FlyPad and (S.FreeFly or S.VehFly)
	pad.Visible=show; lpad.Visible=show
	if show then
		if padScale.Scale~=S.PadSize then padScale.Scale=S.PadSize; lpadScale.Scale=S.PadSize end
		spdLbl.Text=L({ar="السرعة ",en="Speed "})..S[spdField()].." m/s"
	elseif U.padFwd or U.padBack or U.padLeft or U.padRight or U.padUp or U.padDown or U.padBoost then
		U.padFwd,U.padBack,U.padLeft,U.padRight,U.padUp,U.padDown,U.padBoost=false,false,false,false,false,false,false
	end
end)

RunService.Heartbeat:Connect(function(dt)
	if not (S.VehFly or S.VehBoost) then U.vv=Vector3.zero end
	if not gui.Parent or not (S.VehFly or S.VehBoost) then return end
	local ch=LP.Character
	local hum=ch and ch:FindFirstChildOfClass("Humanoid")
	local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return end
	local seat=hum.SeatPart
	local root=seat and (seat.AssemblyRootPart or seat)
	if not root and hum.Sit and hrp.AssemblyRootPart and hrp.AssemblyRootPart~=hrp then root=hrp.AssemblyRootPart end
	if not root then return end
	if S.VehFly then
		local h,v,m=flyInput(hum,seat)
		local ad=adaptCap('veh',root,dt)
		local want=(h*S.VehFlySpeed+Vector3.yAxis*v*S.VehFlySpeed)*m*ad.cap
		U.vv=(U.vv or Vector3.zero):Lerp(want,1-math.exp(-dt*8))
		local vel=U.vv
		local pos=root.Position
		local look=Cam.CFrame.LookVector
		local yaw=Vector3.new(look.X,0,look.Z)
		local face=S.VehFace and yaw.Magnitude>0.01
		if S.VehMode=="Velocity" then
			if face then root.CFrame=CFrame.lookAt(pos,pos+yaw) end
			root.AssemblyLinearVelocity=vel
		else
			local np=pos+vel*dt
			root.CFrame=face and CFrame.lookAt(np,np+yaw) or (root.CFrame+vel*dt)
			root.AssemblyLinearVelocity=Vector3.zero
		end
		ad.exp=pos+vel*dt
		root.AssemblyAngularVelocity=Vector3.zero
	elseif S.VehBoost and seat and seat:IsA("VehicleSeat") then
		local thr=seat.ThrottleFloat
		if thr~=0 then
			local f=seat.CFrame.LookVector
			local v=root.AssemblyLinearVelocity
			root.AssemblyLinearVelocity=Vector3.new(f.X*S.VehBoostSpeed*thr,v.Y,f.Z*S.VehBoostSpeed*thr)
		end
	end
end)
local ffActive=false
RunService.Heartbeat:Connect(function(dt)
	if not gui.Parent then return end
	local ch=LP.Character
	local hum=ch and ch:FindFirstChildOfClass("Humanoid")
	local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return end
	if S.WalkSpeedOn then
		if not pOrig.ws then pOrig.ws=hum.WalkSpeed end
		hum.WalkSpeed=S.WalkSpeed
	elseif pOrig.ws then hum.WalkSpeed=pOrig.ws; pOrig.ws=nil end
	if S.JumpOn then
		if not pOrig.jp then pOrig.jp=hum.JumpPower end
		hum.UseJumpPower=true; hum.JumpPower=S.JumpPower
	elseif pOrig.jp then hum.JumpPower=pOrig.jp; pOrig.jp=nil end
	if S.WalkSpeedOn and not Flying.active and not S.FreeFly then
		local md=hum.MoveDirection
		if md.Magnitude>0.01 then
			local v=hrp.AssemblyLinearVelocity
			hrp.AssemblyLinearVelocity=Vector3.new(md.X*S.WalkSpeed,v.Y,md.Z*S.WalkSpeed)
		end
	end
	if Flying.active then return end
	local ff=S.FreeFly
	if S.Noclip or ff then setNoclip(ch,true) elseif next(ncParts) then setNoclip(ch,false); pcall(safeLand,ch) end
	if ff then
		ffActive=true
		hum.PlatformStand=true
		local h,v,m=flyInput(hum)
		local ad=adaptCap('free',hrp,dt)
		U.fv=(U.fv or Vector3.zero):Lerp((h*S.FreeFlySpeed+Vector3.yAxis*v*S.FreeFlySpeed)*m*ad.cap,1-math.exp(-dt*8))
		local vel=U.fv
		ad.exp=hrp.Position+vel*dt
		if vel.Magnitude>0 then hrp.CFrame=hrp.CFrame+vel*dt end
		hrp.AssemblyLinearVelocity=Vector3.zero; hrp.AssemblyAngularVelocity=Vector3.zero
	elseif ffActive then
		U.fv=Vector3.zero
		ffActive=false; hum.PlatformStand=false; pcall(safeLand,ch)
	end
end)

--==================== الرادار ====================
local radar=new("Frame",{Name="Radar",AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,16,1,-16),Size=UDim2.fromOffset(S.RadarSize,S.RadarSize),BackgroundColor3=BG,
	BackgroundTransparency=0.2,Visible=false},gui)
corner(radar,9999); stroke(radar,2,0.2)
new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.new(1,0,0,1),BackgroundColor3=PANEL3,BackgroundTransparency=0.5,BorderSizePixel=0},radar)
new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.new(0,1,1,0),BackgroundColor3=PANEL3,BackgroundTransparency=0.5,BorderSizePixel=0},radar)
local ringMid=new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromScale(0.5,0.5),BackgroundTransparency=1},radar)
corner(ringMid,9999); new("UIStroke",{Color=PANEL3,Thickness=1,Transparency=0.5},ringMid)
local radarMe=new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(8,8),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=3},radar)
corner(radarMe,4)
local rdots={}
RunService.RenderStepped:Connect(function()
	if not gui.Parent then return end
	radar.Visible=S.Radar
	if not S.Radar then return end
	local sz=S.RadarSize
	radar.Size=UDim2.fromOffset(sz,sz)
	for m,dot in pairs(rdots) do
		if not Tracked[m] then pcall(dot.Destroy,dot); rdots[m]=nil end
	end
	local r=myRoot(); if not r then return end
	local radius=sz/2-6
	local look=Cam.CFrame.LookVector
	local f=Vector2.new(look.X,look.Z)
	f=f.Magnitude>0.001 and f.Unit or Vector2.new(0,-1)
	local rt=Vector2.new(-f.Y,f.X)
	for m,d in pairs(Tracked) do
		local dot=rdots[m]
		if not dot then
			dot=new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),BorderSizePixel=0,Size=UDim2.fromOffset(7,7),ZIndex=2},radar)
			corner(dot,5); rdots[m]=dot
		end
		if d.root.Parent and S.Rarities[d.rarity] and not Muted[m] then
			local rel=d.root.Position-r.Position
			local v2=Vector2.new(rel.X,rel.Z)
			local p
			if S.RadarRotate then p=Vector2.new(v2:Dot(rt),-v2:Dot(f)) else p=v2 end
			p=p/S.RadarRange*radius
			local dim=false
			if p.Magnitude>radius then p=p.Unit*radius; dim=true end
			dot.Position=UDim2.new(0.5,p.X,0.5,p.Y)
			dot.BackgroundColor3=CONFIG.RarityColors[d.rarity]
			dot.BackgroundTransparency=dim and 0.55 or 0
			local big=(m==currentTarget) or (Flying.target==m)
			dot.Size=big and UDim2.fromOffset(11,11) or UDim2.fromOffset(7,7)
			dot.Visible=true
		else
			dot.Visible=false
		end
	end
end)

end

--==================== التشغيل ====================
task.spawn(function() while gui.Parent do pcall(scan); task.wait(CONFIG.ScanInterval) end end)

LP.CharacterAdded:Connect(function() stopFlight(); pOrig.ws=nil; pOrig.jp=nil end)
do
	local function keepMove()
		if not gui.Parent then return end
		local ch=LP.Character
		local hum=ch and ch:FindFirstChildOfClass("Humanoid")
		if not hum then return end
		if S.WalkSpeedOn and hum.WalkSpeed~=S.WalkSpeed then hum.WalkSpeed=S.WalkSpeed end
		if S.JumpOn then
			if not hum.UseJumpPower then hum.UseJumpPower=true end
			if hum.JumpPower~=S.JumpPower then hum.JumpPower=S.JumpPower end
		end
	end
	RunService.Stepped:Connect(keepMove)
end
LP.CharacterRemoving:Connect(function() stopFlight() end)

local lastAccent, lastScale = S.Accent, S.UIScale
local lastFB,lastFog,lastFPS,lastFPSX,lastUF=false,false,false,false,false
local tk=0
local wmT=0
task.spawn(function()
	while gui.Parent do
		pcall(refreshVisuals)
		tk+=1
		while #notifyQueue>0 do
			local n=table.remove(notifyQueue,1)
			if S.Notify then
				notify((S.Lang=="ar" and "ظهر ضب " or "Spawned: ").."<b>"..n[1].."</b>  ["..RName(n[2]).."]",CONFIG.RarityColors[n[2]])
				if S.SoundAlert then pcall(function() alertSound:Play() end) end
			end
			if S.AutoFly and n[3] and Tracked[n[3]] and not Flying.active then flyTo(n[3]) end
		end
		if lastFB~=S.Fullbright then lastFB=S.Fullbright; pcall(applyFB) end
		if S.NoFog or lastFog then pcall(U.applyFog) end
		lastFog=S.NoFog
		if lastFPS~=S.FPSBoost or lastFPSX~=S.FPSExtreme then lastFPS=S.FPSBoost; lastFPSX=S.FPSExtreme; task.spawn(function() pcall(U.applyFPS) end) end
		if lastUF~=S.UnlockFPS then
			lastUF=S.UnlockFPS
			pcall(function() if typeof(setfpscap)=="function" then setfpscap(S.UnlockFPS and 1000 or 60) end end)
		end
		if lastAccent~=S.Accent then
			lastAccent=S.Accent; repaint()
			for _,f in ipairs(texts) do pcall(f) end
			showPage(curPage)
		end
		if lastScale~=S.UIScale and main.Visible and not U.sliding then lastScale=S.UIScale; scale.Scale=S.UIScale end
		local fpsTxt = tostring(S._fps or 0).." FPS"
		topStats.Text=(S.Lang=="ar" and "الإجمالي " or "Total ")..Counts.total.."  •  "
			..(S.Lang=="ar" and "المدى " or "Range ")..Counts.inRange.."  •  "..fpsTxt
		if Flying.active then
			statusDot.BackgroundColor3=Color3.fromRGB(80,255,150)
			topStats.Text=topStats.Text.."  •  "..math.floor(S.FlySpeed)
		else
			statusDot.BackgroundColor3=Color3.fromRGB(60,220,90)
		end

		badge.Visible=Counts.alive>0
		badgeLbl.Text=tostring(math.min(Counts.alive,99))

		local isOpen=main.Visible or (U.welcome and U.welcome.Visible)
		topToggle.Text=U.logoOK and "" or (isOpen and L({ar="اغلاق",en="Close"}) or L({ar="فتح",en="Open"}))
		watermark.Visible=S.Watermark
		wmT+=CONFIG.UpdateInterval
		if S.Watermark and wmT>=0.5 then
			wmT=0; S._ping=U.getPing()
			watermark.Text=string.format("VØX beta | %d FPS | %dms | Dhab %d",S._fps or 0,S._ping or 0,Counts.total)
		end

		if U.welcome and U.welcome.Visible and welcomeUpdate then pcall(welcomeUpdate) end
		if pages.log.Visible and U.logUpdate then pcall(U.logUpdate) end
		if pages.silent.Visible and U.ammoInfo then
			local st=U.stat
			U.ammoInfo.Text=L({ar="قيم: ",en="Values: "})..st.vals.."  |  "..L({ar="خصائص: ",en="Attrs: "})..st.attrs.."  |  "..L({ar="جداول: ",en="Tables: "})..st.gc.."  |  "..L({ar="وحدات: ",en="Modules: "})..st.mod
		end
		if pages.silent.Visible and U.hookInfo then U.hookInfo.Text=U.hookOK and (U.hookPartial and L({ar="الوضع: صامت جزئي (Mouse.Hit)",en="Mode: partial silent (Mouse.Hit)"}) or L({ar="الوضع: صامت حقيقي (الربط يعمل)",en="Mode: true silent (hook OK)"})) or L({ar="الوضع: تثبيت الكاميرا عند الإطلاق (المشغّل لا يدعم الربط)",en="Mode: camera snap on fire (hook unsupported)"}) end
		if pages.ignore.Visible and U.ignUpdate then pcall(U.ignUpdate) end
		if pages.tp.Visible and U.typeUpdate then pcall(U.typeUpdate) end
		if pages.home.Visible then
			local lines={"<b>"..L({ar="الإحصائيات",en="Stats"}).."</b>"}
			for _,r in ipairs(CONFIG.RarityOrder) do
				if Counts.byRarity[r] then
					table.insert(lines,string.format("<font color='#%s'>%s</font>: %d",CONFIG.RarityColors[r]:ToHex(),RName(r),Counts.byRarity[r]))
				end
			end
			if #lines==1 then table.insert(lines,L({ar="لا يوجد ضبان",en="No dhabs found"})) end
			homeInfo.Text=table.concat(lines,"   ")
			local d=currentTarget and Tracked[currentTarget]
			local flyTargetName = Flying.active and Flying.target and Flying.target.Name
			local tgtTxt = d and (currentTarget.Name.." ["..RName(d.rarity).."]") or L({ar="لا يوجد",en="None"})
			local flyTxt = flyTargetName and ("  "..flyTargetName) or ""
			homeTarget.Text="<b>"..L({ar="الهدف",en="Target"}).."</b>: "..tgtTxt..flyTxt
		end
		if pages.set.Visible then
			statsBox.Text="<b>"..L({ar="إحصائيات الجلسة",en="Session stats"}).."</b>\n"
				..L({ar="اكتُشف: ",en="Discovered: "})..Stat.discovered.."  |  "..L({ar="طيران: ",en="Flights: "})..Stat.flown
		end
		if pages.tp.Visible then for _,f in ipairs(dyn) do pcall(f) end end
		if pages.list.Visible and tk%3==0 and targetListUpdate then pcall(targetListUpdate) end
		task.wait(CONFIG.UpdateInterval)
	end
end)

openUI()
U.showWelcome()
notify("<b>VØX Script beta</b> "..L({ar="جاهز",en="loaded"}))
