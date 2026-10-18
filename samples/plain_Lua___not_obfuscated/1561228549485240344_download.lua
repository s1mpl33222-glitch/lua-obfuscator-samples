-- onhub · UI de key para o Jinkie (colar no campo UI-Source do dashboard)
-- PREENCHA os 3 valores abaixo com os dados do seu dashboard Jinkie:
--   SERVICE     = nome do Service (o mesmo selecionado no script)
--   IDENTIFIER  = seu user ID no dashboard (aparece no snippet/SDK)
--   PROVIDER    = nome do provider ("onhub")

local SERVICE = "Onhub"
local IDENTIFIER = "1196003"
local PROVIDER = "onhub"

local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = SERVICE
Junkie.identifier = IDENTIFIER
Junkie.provider = PROVIDER

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local lp = Players.LocalPlayer

local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

local C = {
	bg0 = Color3.fromRGB(8, 14, 10),
	bg1 = Color3.fromRGB(12, 22, 16),
	bg2 = Color3.fromRGB(16, 30, 21),
	bg3 = Color3.fromRGB(20, 38, 27),
	bg4 = Color3.fromRGB(24, 46, 32),
	brd = Color3.fromRGB(18, 36, 25),
	brd2 = Color3.fromRGB(26, 64, 42),
	acc = Color3.fromRGB(64, 226, 128),
	accDark = Color3.fromRGB(26, 110, 64),
	accGlow = Color3.fromRGB(100, 255, 160),
	grn = Color3.fromRGB(64, 226, 128),
	txt = Color3.fromRGB(220, 240, 226),
	txt2 = Color3.fromRGB(126, 158, 138),
	txt3 = Color3.fromRGB(80, 105, 92),
	white = Color3.fromRGB(255, 255, 255),
	black = Color3.fromRGB(0, 0, 0),
	danger = Color3.fromRGB(228, 86, 86),
}

local MSGS = {
	KEY_INVALID = "Invalid key. Try again or get a new one.",
	KEY_EXPIRED = "Key expired — get a new one.",
	KEY_INVALIDATED = "Key was manually disabled.",
	ALREADY_USED = "One-time key already used.",
	HWID_BANNED = "Hardware banned.",
	HWID_MISMATCH = "HWID limit reached.",
	SERVICE_NOT_FOUND = "Service not found.",
	SERVICE_MISMATCH = "Key is for a different service.",
	PREMIUM_REQUIRED = "Premium key required.",
	ERROR = "Network error — try again.",
}

local KEY_FILE = "onhub_key.txt"

local function fsSave(key)
	if writefile then pcall(writefile, KEY_FILE, key) end
end
local function fsLoad()
	if readfile then
		local ok, v = pcall(readfile, KEY_FILE)
		if ok and v and v ~= "" then
			v = v:gsub("^%s+", ""):gsub("%s+$", "")
			if #v > 0 then return v end
		end
	end
	return nil
end
local function fsClear()
	if (delfile or isfile) and isfile and isfile(KEY_FILE) then
		pcall(function() delfile(KEY_FILE) end)
	end
end

getgenv().UI_CLOSED = false
getgenv().SCRIPT_KEY = nil

local function guiParent()
	local ok, ui = pcall(function()
		if gethui then return gethui() end
		return game:GetService("CoreGui")
	end)
	if ok and ui then return ui end
	return lp:WaitForChild("PlayerGui")
end

local GUI = Instance.new("ScreenGui")
GUI.Name = "Onhub_KeySystem"
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.IgnoreGuiInset = true
GUI.Parent = guiParent()

local blur = Instance.new("BlurEffect")
blur.Size = 16; blur.Name = "onhub_KeyBlur"; blur.Parent = Lighting

local function Tw(obj, t, g)
	TweenService:Create(obj, TweenInfo.new(t), g):Play()
end
local function TwE(obj, t, es, ed, g)
	TweenService:Create(obj, TweenInfo.new(t, es, ed), g):Play()
end
local function TwLoop(obj, t, es, g)
	TweenService:Create(obj,
		TweenInfo.new(t, es, Enum.EasingDirection.InOut, -1, true), g):Play()
end

local function MkFrame(parent, size, pos, bg, r, z)
	local f = Instance.new("Frame", parent)
	f.Size = size; f.Position = pos
	f.BackgroundColor3 = bg or C.bg1
	f.BorderSizePixel = 0
	if r then Instance.new("UICorner", f).CornerRadius = UDim.new(0, r) end
	if z then f.ZIndex = z end
	return f
end

local function MkStroke(parent, col, thick, trans)
	local s = Instance.new("UIStroke", parent)
	s.Color = col or C.brd; s.Thickness = thick or 1; s.Transparency = trans or 0
	return s
end

local function MkLbl(parent, text, sz, col, font, xa)
	local l = Instance.new("TextLabel", parent)
	l.Size = UDim2.new(1,0,1,0); l.Position = UDim2.new(0,0,0,0)
	l.BackgroundTransparency = 1; l.Text = text
	l.TextSize = sz or 13; l.TextColor3 = col or C.txt
	l.Font = font or Enum.Font.GothamMedium
	l.TextXAlignment = xa or Enum.TextXAlignment.Left
	l.TextYAlignment = Enum.TextYAlignment.Center
	l.TextWrapped = false
	return l
end

local function MkBtn(parent, size, pos, bg, r, z)
	local b = Instance.new("TextButton", parent)
	b.Size = size; b.Position = pos
	b.BackgroundColor3 = bg or C.bg3
	b.BorderSizePixel = 0; b.Text = ""; b.AutoButtonColor = false
	if r then Instance.new("UICorner", b).CornerRadius = UDim.new(0, r) end
	if z then b.ZIndex = z end
	return b
end

local function Hover(btn, norm, hot)
	btn.MouseEnter:Connect(function() Tw(btn, 0.14, {BackgroundColor3 = hot}) end)
	btn.MouseLeave:Connect(function() Tw(btn, 0.14, {BackgroundColor3 = norm}) end)
end

local function Press(btn, size, pos)
	btn.MouseButton1Down:Connect(function()
		Tw(btn, 0.07, {
			Size = UDim2.new(size.X.Scale, size.X.Offset-2, size.Y.Scale, size.Y.Offset-2),
			Position = UDim2.new(pos.X.Scale, pos.X.Offset+1, pos.Y.Scale, pos.Y.Offset+1),
		})
	end)
	btn.MouseButton1Up:Connect(function()
		Tw(btn, 0.07, {Size = size, Position = pos})
	end)
end

local PW = isMobile and math.min(330, workspace.CurrentCamera.ViewportSize.X - 16) or 490
local PH = isMobile and 380 or 360

local Backdrop = MkFrame(GUI, UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), C.black, 0, 1)
Backdrop.BackgroundTransparency = 1

local GlowBg = MkFrame(GUI, UDim2.new(0,PW+80,0,PH+60), UDim2.new(0.5,0,0.5,0), C.acc, 40, 0)
GlowBg.AnchorPoint = Vector2.new(0.5,0.5)
GlowBg.BackgroundTransparency = 0.92
TweenService:Create(GlowBg,
	TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
	{BackgroundTransparency = 0.87, Size = UDim2.new(0,PW+120,0,PH+100)}):Play()

local Panel = MkFrame(GUI, UDim2.new(0,PW,0,PH), UDim2.new(0.5,0,0.5,0), C.bg1, 12, 2)
Panel.AnchorPoint = Vector2.new(0.5,0.5)
Panel.ClipsDescendants = true
MkStroke(Panel, C.brd2, 1)

local Sheen = MkFrame(Panel, UDim2.new(1,0,0.5,0), UDim2.new(0,0,0,0), C.white, 0, 3)
Sheen.BackgroundTransparency = 0.97
local sheenG = Instance.new("UIGradient", Sheen)
sheenG.Rotation = 90
sheenG.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 0.93),
	NumberSequenceKeypoint.new(1, 1),
}

local TBH = isMobile and 44 or 38
local TopBar = MkFrame(Panel, UDim2.new(1,0,0,TBH), UDim2.new(0,0,0,0), C.bg0, 0, 4)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)
MkFrame(TopBar, UDim2.new(1,0,0,12), UDim2.new(0,0,1,-12), C.bg0, 0, 4)
MkFrame(TopBar, UDim2.new(1,0,0,2), UDim2.new(0,0,1,-2), C.acc, 0, 5)

local BrandLbl = MkLbl(TopBar, '<font color="#40E280">on</font>hub',
	isMobile and 14 or 14, C.white, Enum.Font.GothamBold, Enum.TextXAlignment.Left)
BrandLbl.Size = UDim2.new(0, 90, 1, -4)
BrandLbl.Position = UDim2.new(0, isMobile and 14 or 12, 0, 2)
BrandLbl.RichText = true; BrandLbl.ZIndex = 6

local BadgeF = MkFrame(TopBar, UDim2.new(0,78,0,isMobile and 18 or 16),
	UDim2.new(0, isMobile and 100 or 92, 0.5, isMobile and -9 or -8), C.bg3, 4, 6)
MkStroke(BadgeF, C.brd2, 1)
MkLbl(BadgeF, "Key System", 8, C.txt2, Enum.Font.GothamMedium, Enum.TextXAlignment.Center).ZIndex = 7

local cSz = isMobile and 30 or 26
local CloseBtn = MkBtn(TopBar, UDim2.new(0,cSz,0,cSz),
	UDim2.new(1,-(cSz+6),0.5,-cSz/2), C.bg2, 6, 6)
local cLbl = MkLbl(CloseBtn, "X", isMobile and 13 or 12,
	C.danger, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
cLbl.ZIndex = 7
Hover(CloseBtn, C.bg2, C.accDark)
CloseBtn.MouseEnter:Connect(function() cLbl.TextColor3 = C.white end)
CloseBtn.MouseLeave:Connect(function() cLbl.TextColor3 = C.danger end)

local PAD = 18
local Cont = MkFrame(Panel,
	UDim2.new(1,-PAD*2,1,-(TBH+14)),
	UDim2.new(0,PAD,0,TBH+8),
	C.bg1, 0, 3)
Cont.BackgroundTransparency = 1

local logoSz = isMobile and 62 or 70
local LogoWrap = MkFrame(Cont,
	UDim2.new(0,logoSz,0,logoSz),
	UDim2.new(0.5,-logoSz/2,0,2),
	C.bg2, 16, 4)
MkStroke(LogoWrap, C.acc, 2, 0.3)

local rStroke = LogoWrap:FindFirstChildOfClass("UIStroke")
local rGrad = Instance.new("UIGradient")
rGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, C.acc),
	ColorSequenceKeypoint.new(0.5, C.accGlow),
	ColorSequenceKeypoint.new(1, C.accDark),
}
rGrad.Parent = rStroke
TweenService:Create(rGrad,
	TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
	{Rotation = 360}):Play()

local LOGO_THUMB = "rbxthumb://type=Asset&id=109941029950733&w=420&h=420"
local LOGO_ASSET = "rbxassetid://109941029950733"

local logoFallback = Instance.new("TextLabel", LogoWrap)
logoFallback.Size = UDim2.new(1,0,1,0)
logoFallback.BackgroundTransparency = 1
logoFallback.Text = "OH"
logoFallback.TextColor3 = C.acc
logoFallback.Font = Enum.Font.GothamBold
logoFallback.TextSize = isMobile and 18 or 20
logoFallback.TextXAlignment = Enum.TextXAlignment.Center
logoFallback.TextYAlignment = Enum.TextYAlignment.Center
logoFallback.ZIndex = 4

local LogoImg = Instance.new("ImageLabel", LogoWrap)
LogoImg.Size = UDim2.new(1,-8,1,-8)
LogoImg.Position = UDim2.new(0,4,0,4)
LogoImg.BackgroundTransparency = 1
LogoImg.Image = LOGO_THUMB
LogoImg.ScaleType = Enum.ScaleType.Fit
LogoImg.ImageTransparency = 1
LogoImg.ZIndex = 5
Instance.new("UICorner", LogoImg).CornerRadius = UDim.new(0,12)

local logoDone = false
local function showLogo()
	if logoDone then return end
	logoDone = true
	logoFallback.Visible = false
	Tw(LogoImg, 0.3, {ImageTransparency = 0})
end

local function tryLogo(url, onFail)
	task.spawn(function()
		LogoImg.Image = url
		local status
		local ok = pcall(function()
			game:GetService("ContentProvider"):PreloadAsync({LogoImg},
				function(_, s) status = s end)
		end)
		if ok and status == Enum.AssetFetchStatus.Success then
			showLogo()
		elseif onFail then
			onFail()
		end
	end)
end

LogoImg:GetPropertyChangedSignal("IsLoaded"):Connect(function()
	if LogoImg.IsLoaded then showLogo() end
end)
task.delay(0.1, function() if LogoImg.IsLoaded then showLogo() end end)

tryLogo(LOGO_THUMB, function()
	tryLogo(LOGO_ASSET)
end)

TwLoop(LogoWrap, 2.2, Enum.EasingStyle.Sine, {BackgroundColor3 = C.bg3})

local titleY = logoSz + 12

local TitleLbl = MkLbl(Cont, "Verify Your Key",
	isMobile and 18 or 20, C.white, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
TitleLbl.Size = UDim2.new(1,0,0,isMobile and 26 or 28)
TitleLbl.Position = UDim2.new(0,0,0,titleY); TitleLbl.ZIndex = 4

local SubLbl = MkLbl(Cont, "Enter your key below to access onhub",
	isMobile and 11 or 12, C.txt2, Enum.Font.Gotham, Enum.TextXAlignment.Center)
SubLbl.Size = UDim2.new(1,0,0,isMobile and 16 or 18)
SubLbl.Position = UDim2.new(0,0,0,titleY+(isMobile and 28 or 30)); SubLbl.ZIndex = 4

local inputY = titleY+(isMobile and 54 or 60)
local inputH = isMobile and 42 or 38

local InputWrap = MkFrame(Cont, UDim2.new(1,0,0,inputH), UDim2.new(0,0,0,inputY), C.bg2, 8, 4)
local inputStroke = MkStroke(InputWrap, C.brd2, 1, 0.25)

local keyTagW = isMobile and 38 or 34
local keyTagF = MkFrame(InputWrap, UDim2.new(0,keyTagW,1,-8), UDim2.new(0,6,0,4), C.bg3, 6, 5)
MkLbl(keyTagF, "KEY", 8, C.acc, Enum.Font.GothamBold, Enum.TextXAlignment.Center).ZIndex = 6
MkFrame(InputWrap, UDim2.new(0,1,1,-12), UDim2.new(0,keyTagW+10,0,6), C.brd2, 0, 5)

local KeyInput = Instance.new("TextBox", InputWrap)
KeyInput.Size = UDim2.new(1,-(keyTagW+18),1,0)
KeyInput.Position = UDim2.new(0,keyTagW+14,0,0)
KeyInput.BackgroundTransparency = 1
KeyInput.PlaceholderText = "Enter your verification key..."
KeyInput.PlaceholderColor3 = C.txt3
KeyInput.Text = ""; KeyInput.TextColor3 = C.txt
KeyInput.TextSize = isMobile and 12 or 13
KeyInput.Font = Enum.Font.GothamMedium
KeyInput.TextXAlignment = Enum.TextXAlignment.Left
KeyInput.ClearTextOnFocus = false; KeyInput.ZIndex = 5
Instance.new("UIPadding", KeyInput).PaddingLeft = UDim.new(0,2)

KeyInput.Focused:Connect(function()
	Tw(inputStroke, 0.16, {Color=C.acc, Thickness=1.5, Transparency=0})
	Tw(InputWrap, 0.16, {BackgroundColor3=C.bg3})
end)
KeyInput.FocusLost:Connect(function()
	Tw(inputStroke, 0.16, {Color=C.brd2, Thickness=1, Transparency=0.25})
	Tw(InputWrap, 0.16, {BackgroundColor3=C.bg2})
end)

local statusY = inputY+inputH+5
local StatusLbl = MkLbl(Cont, "", isMobile and 10 or 11,
	C.txt2, Enum.Font.Gotham, Enum.TextXAlignment.Center)
StatusLbl.Size = UDim2.new(1,0,0,14)
StatusLbl.Position = UDim2.new(0,0,0,statusY); StatusLbl.ZIndex = 4

local function SetStatus(msg, col, dur)
	StatusLbl.Text = msg
	StatusLbl.TextColor3 = col or C.txt2
	if dur and dur > 0 then
		task.delay(dur, function()
			if StatusLbl.Text == msg then StatusLbl.Text = "" end
		end)
	end
end

local function ShakeInput()
	local orig = InputWrap.Position
	for _ = 1, 3 do
		Tw(InputWrap, 0.05, {Position=UDim2.new(orig.X.Scale,orig.X.Offset-7,orig.Y.Scale,orig.Y.Offset)})
		task.wait(0.05)
		Tw(InputWrap, 0.05, {Position=UDim2.new(orig.X.Scale,orig.X.Offset+7,orig.Y.Scale,orig.Y.Offset)})
		task.wait(0.05)
	end
	InputWrap.Position = orig
end

local btnY = inputY+inputH+(isMobile and 24 or 20)
local btnH = isMobile and 40 or 36
local btnGap = 8

local GKSz = UDim2.new(0.5,-btnGap/2,0,btnH)
local GKPos = UDim2.new(0,0,0,btnY)
local GKBtn = MkBtn(Cont, GKSz, GKPos, C.bg3, 8, 4)
MkStroke(GKBtn, C.brd2, 1, 0.3)
local gkGrad = Instance.new("UIGradient", GKBtn)
gkGrad.Rotation = 90
gkGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, C.bg4),
	ColorSequenceKeypoint.new(1, C.bg3),
}
local gkLbl = MkLbl(GKBtn, "Get Key",
	isMobile and 12 or 13, C.txt, Enum.Font.GothamSemibold, Enum.TextXAlignment.Center)
gkLbl.ZIndex = 5
Hover(GKBtn, C.bg3, C.bg4)
GKBtn.MouseEnter:Connect(function() gkLbl.TextColor3 = C.white end)
GKBtn.MouseLeave:Connect(function() gkLbl.TextColor3 = C.txt end)
Press(GKBtn, GKSz, GKPos)

local VKSz = UDim2.new(0.5,-btnGap/2,0,btnH)
local VKPos = UDim2.new(0.5,btnGap/2,0,btnY)
local VKBtn = MkBtn(Cont, VKSz, VKPos, C.acc, 8, 4)
local vkGrad = Instance.new("UIGradient", VKBtn)
vkGrad.Rotation = 90
vkGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, C.accGlow),
	ColorSequenceKeypoint.new(1, C.accDark),
}
local vkLbl = MkLbl(VKBtn, "Verify",
	isMobile and 12 or 13, C.black, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
vkLbl.ZIndex = 5
Hover(VKBtn, C.acc, C.accGlow)
Press(VKBtn, VKSz, VKPos)

local divY = btnY+btnH+(isMobile and 14 or 12)
MkFrame(Cont, UDim2.new(1,0,0,1), UDim2.new(0,0,0,divY), C.brd, 0, 3)

local FooterLbl = MkLbl(Cont, "onhub · key system",
	isMobile and 10 or 10, C.txt3, Enum.Font.Gotham, Enum.TextXAlignment.Center)
FooterLbl.Size = UDim2.new(1,0,0,18)
FooterLbl.Position = UDim2.new(0,0,0,divY+(isMobile and 12 or 10)); FooterLbl.ZIndex = 4

task.spawn(function()
	while Panel and Panel.Parent do
		local p = MkFrame(Panel,
			UDim2.new(0,math.random(2,4),0,math.random(2,4)),
			UDim2.new(math.random(),0,1,0),
			C.acc, 2, 6)
		p.BackgroundTransparency = 0.65
		TweenService:Create(p,
			TweenInfo.new(math.random(9,15), Enum.EasingStyle.Linear),
			{Position=UDim2.new(p.Position.X.Scale,0,-0.08,0), BackgroundTransparency=1}):Play()
		task.delay(16, function() if p and p.Parent then p:Destroy() end end)
		task.wait(math.random(2,4))
	end
end)

local LoadOv = MkFrame(Panel, UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), C.bg1, 12, 20)
LoadOv.Visible = false

local SpinH = MkFrame(LoadOv, UDim2.new(0,64,0,64), UDim2.new(0.5,-32,0.5,-52), C.bg1, 0, 21)
SpinH.BackgroundTransparency = 1

local TrCirc = MkFrame(SpinH, UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), C.bg1, 0, 21)
TrCirc.BackgroundTransparency = 1
MkStroke(TrCirc, C.brd2, 4, 0.6)
Instance.new("UICorner", TrCirc).CornerRadius = UDim.new(1,0)

local ArcCirc = MkFrame(SpinH, UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), C.bg1, 0, 22)
ArcCirc.BackgroundTransparency = 1
local arcS = MkStroke(ArcCirc, C.acc, 4, 0)
Instance.new("UICorner", ArcCirc).CornerRadius = UDim.new(1,0)
local arcG = Instance.new("UIGradient", arcS)
arcG.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0,0),
	NumberSequenceKeypoint.new(0.45,0.1),
	NumberSequenceKeypoint.new(0.75,0.6),
	NumberSequenceKeypoint.new(1,1),
}
TweenService:Create(SpinH,
	TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
	{Rotation=360}):Play()

local LoadTxt = MkLbl(LoadOv, "Checking key",
	isMobile and 14 or 15, C.txt, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
LoadTxt.Size = UDim2.new(1,0,0,22); LoadTxt.Position = UDim2.new(0,0,0.5,22); LoadTxt.ZIndex = 22

local LoadSub = MkLbl(LoadOv, "Please wait a moment",
	isMobile and 10 or 11, C.txt2, Enum.Font.Gotham, Enum.TextXAlignment.Center)
LoadSub.Size = UDim2.new(1,0,0,16); LoadSub.Position = UDim2.new(0,0,0.5,48); LoadSub.ZIndex = 22

task.spawn(function()
	local base = "Checking key"; local d = 0
	while LoadOv and LoadOv.Parent do
		if LoadOv.Visible then
			d = (d%3)+1
			LoadTxt.Text = base..string.rep(".",d)
		end
		task.wait(0.5)
	end
end)

local function ShowLoading(show, msg)
	if msg then LoadTxt.Text = msg end
	LoadOv.Visible = show
end

local function ShowSuccess(msg)
	local Ov = MkFrame(Panel, UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), C.bg1, 12, 30)
	Ov.BackgroundTransparency = 1
	Tw(Ov, 0.22, {BackgroundTransparency=0.05})

	local cSz2 = 82
	local Circ = MkFrame(Ov,
		UDim2.new(0,cSz2,0,cSz2),
		UDim2.new(0.5,-cSz2/2,0.5,-70),
		C.grn, cSz2/2, 31)
	Circ.BackgroundTransparency = 0.15
	TwE(Circ, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out,
		{Size=UDim2.new(0,90,0,90), Position=UDim2.new(0.5,-45,0.5,-74)})

	local ckL = MkLbl(Circ, "v", 44, C.black, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
	ckL.TextSize = 0; ckL.ZIndex = 32
	TwE(ckL, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {TextSize=48})

	TwLoop(Circ, 0.9, Enum.EasingStyle.Sine, {Size=UDim2.new(0,92,0,92)})

	local sT = MkLbl(Ov, msg or "Key Verified!",
		isMobile and 17 or 19, C.grn, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
	sT.Size = UDim2.new(1,0,0,26); sT.Position = UDim2.new(0,0,0.5,30); sT.ZIndex = 31

	local sS = MkLbl(Ov, "Starting onhub...",
		isMobile and 11 or 12, C.txt2, Enum.Font.Gotham, Enum.TextXAlignment.Center)
	sS.Size = UDim2.new(1,0,0,16); sS.Position = UDim2.new(0,0,0.5,60); sS.ZIndex = 31

	task.wait(1.3)
end

Panel.BackgroundTransparency = 1
Panel.Position = UDim2.new(0.5,0,0.5,36)
TwE(Panel, 0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out,
	{BackgroundTransparency=0, Position=UDim2.new(0.5,0,0.5,0)})
Tw(Backdrop, 0.22, {BackgroundTransparency=0.35})

local function CloseUI()
	getgenv().UI_CLOSED = true
	local b = Lighting:FindFirstChild("onhub_KeyBlur")
	Tw(Panel, 0.18, {BackgroundTransparency=1, Position=UDim2.new(0.5,0,0.5,28)})
	Tw(Backdrop, 0.18, {BackgroundTransparency=1})
	Tw(blur, 0.18, {Size = 0})
	task.wait(0.20)
	if b then b:Destroy() end
	if GUI and GUI.Parent then GUI:Destroy() end
end

CloseBtn.MouseButton1Click:Connect(CloseUI)

GKBtn.MouseButton1Click:Connect(function()
	gkLbl.Text = "..."
	task.spawn(function()
		local link, err
		pcall(function() link, err = Junkie.get_key_link() end)
		if link then
			if setclipboard then pcall(setclipboard, link) end
			SetStatus("Link copied! Complete the checkpoints, then paste your key here.", C.grn, 6)
			gkLbl.Text = "Copied!"
			task.delay(2.5, function() gkLbl.Text = "Get Key" end)
		elseif err == "RATE_LIMITED" then
			SetStatus("Rate limited! Wait 5 minutes before requesting another link.", C.danger, 5)
			gkLbl.Text = "Get Key"
		else
			SetStatus("Failed to get link: " .. tostring(err or "ERROR"), C.danger, 5)
			gkLbl.Text = "Get Key"
		end
	end)
end)

local verifying = false

local function DoVerify(rawKey)
	if verifying then return end
	local key = tostring(rawKey or ""):gsub("%s+","")
	if key == "" then
		SetStatus("Please enter a key first.", C.danger, 3)
		task.spawn(ShakeInput); return
	end

	verifying = true
	vkLbl.Text = "Checking..."; VKBtn.Active = false

	local result
	local ok = pcall(function() result = Junkie.check_key(key) end)

	if ok and result and result.valid then
		fsSave(key)
		ShowLoading(false)
		ShowSuccess(result.message == "KEYLESS" and "Keyless Mode!" or "Key Verified!")
		getgenv().SCRIPT_KEY = key
		verifying = false
		CloseUI()
	else
		local err = (result and (result.error or result.message)) or (ok and "KEY_INVALID" or "ERROR")
		if err == "HWID_BANNED" then
			SetStatus("Hardware banned.", C.danger, 5)
			pcall(function() lp:Kick("onhub · hardware banned") end)
			return
		end
		SetStatus(MSGS[err] or ("Invalid key: " .. tostring(err)), C.danger, 5)
		task.spawn(ShakeInput)
		Tw(InputWrap, 0.09, {BackgroundColor3=Color3.fromRGB(46,20,20)})
		task.delay(0.38, function()
			Tw(InputWrap, 0.18, {BackgroundColor3=C.bg2})
		end)
		Tw(inputStroke, 0.12, {Color=C.danger, Thickness=1.5, Transparency=0})
		task.delay(1.2, function()
			Tw(inputStroke, 0.18, {Color=C.brd2, Thickness=1, Transparency=0.25})
		end)
		vkLbl.Text = "Verify"; VKBtn.Active = true
		verifying = false
	end
end

VKBtn.MouseButton1Click:Connect(function() DoVerify(KeyInput.Text) end)
KeyInput.FocusLost:Connect(function(enter)
	if enter then DoVerify(KeyInput.Text) end
end)

task.spawn(function()
	local savedKey = fsLoad()

	if not savedKey then
		ShowLoading(false)
		return
	end

	ShowLoading(true, "Checking saved key")

	local result
	local ok = pcall(function() result = Junkie.check_key(savedKey) end)

	if ok and result and result.valid then
		if result.message == "KEYLESS" then
			ShowLoading(false)
			ShowSuccess("Keyless Mode!")
			getgenv().SCRIPT_KEY = "KEYLESS"
			CloseUI(); return
		end
		if result.message == "KEY_VALID" then
			ShowLoading(false)
			ShowSuccess("Saved Key Verified!")
			getgenv().SCRIPT_KEY = savedKey
			CloseUI(); return
		end
	end
	if savedKey then fsClear() end

	ShowLoading(false)
	SetStatus("Saved key invalid or expired — get a new one.", C.danger, 6)
end)

while not getgenv().UI_CLOSED do
	task.wait(0.1)
end

do ("JNKIE Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local k=getgenv().SCRIPT_KEY or SCRIPT_KEY;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table" and type(syn.request)=="function" and syn.request)or(type(request)=="function" and request)or(type(http_request)=="function" and http_request)or(type(http)=="table" and type(http.request)=="function" and http.request);if type(k)~="string" then v("No key provided. Get a key from the script provider, enter it, then try again.");return end;if type(r)~="function" then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/e9a718c4aa67afa3cc466239affd6d4da2b07b8154f7d006668a4aaf114c4932?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table" and type(x.Body)=="string" and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if a and type(x)=="table" and x.StatusCode==200 and type(x.Body)=="string" and (string.sub(x.Body,1,8)=="https://") then a,x=q({Url=x.Body,Method="GET"})end;if a and type(x)=="table" and(x.StatusCode==302 or x.StatusCode==303)then local h=x.Headers or x.headers;local l=type(h)=="table" and(h.Location or h.location);if type(l)=="string" and (string.sub(l,1,8)=="https://") then a,x=q({Url=l,Method="GET"})end end;if not a or type(x)~="table" or x.StatusCode~=200 or type(x.Body)~="string" or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function" then warn(m);return end;f()end