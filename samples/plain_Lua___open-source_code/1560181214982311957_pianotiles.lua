





















_G.__PIANOGOD_COMPILEOK=true
_G.__PIANOGOD_LOADERR=nil
_G.__PIANOGOD_VERSION="v1.0-virtuoso"
if _G.__PIANOGOD and type(_G.__PIANOGOD.Unload)=="function"then
pcall(_G.__PIANOGOD.Unload)
_G.__PIANOGOD=nil
end




local a,aa=pcall(function()

local a=game:GetService"Players"
local b=game:GetService"RunService"
local c=game:GetService"TweenService"
local d=game:GetService"UserInputService"
local e=game:GetService"ReplicatedStorage"

local f=a.LocalPlayer
if not f then
repeat task.wait()until a.LocalPlayer
f=a.LocalPlayer
end

local g=f:WaitForChild("PlayerScripts",10)
local h=g and g:WaitForChild("Client",10)
local i=e:WaitForChild("Shared",10)

if not(h and i)then
f:Kick"Piano God: Game engine scripts not found (game updated?)"
return
end

local function safeReq(j,k)
local l=j:FindFirstChild(k)
if not l then return nil end
local m,n=pcall(require,l)
return m and n or nil
end

local j=safeReq(h,"Engine")
local k=safeReq(h,"Board")
safeReq(i,"Songs")
local l=safeReq(i:FindFirstChild"UI"or i,"Store")
safeReq(i,"Config")

if not(j and k)then
f:Kick"Piano God: Core Engine/Board modules failed to load."
return
end




local m={

AutoPlay=true,
AccuracyMode="God",
CustomFallRatio=0.80,
HoldFraction=0.96,
SkipCountdown=true,
InstantGate=true,


AutoRevive=true,


AutoReplay=false,
ReplayDelay=1.2,


ScrollSpeed=1.0,
Upscroll=false,
VisualFlash=true,
}




local n={
Bg=Color3.fromRGB(11,14,26),
BgCard=Color3.fromRGB(18,22,40),
BgSub=Color3.fromRGB(25,31,56),
Border=Color3.fromRGB(45,54,94),
Text=Color3.fromRGB(240,244,255),
TextDim=Color3.fromRGB(138,146,182),
Cyan=Color3.fromRGB(0,240,255),
Purple=Color3.fromRGB(168,85,247),
Gold=Color3.fromRGB(250,204,21),
Green=Color3.fromRGB(34,197,94),
Red=Color3.fromRGB(244,63,94),
White=Color3.fromRGB(255,255,255),
}




local o:{RBXScriptConnection}={}
local p:{[string]:any}={}
local q:(title:string,body:string,col:Color3?)->()

local function onConn(r)
table.insert(o,r)
return r
end




local r=1
local s={}
local t=-1
local u=false

local function resetPlaybackState()
r=1
table.clear(s)
u=false
end

local function autoStep()
if not m.AutoPlay then return end

local v=j.phase()
local w=j.chart()
local x=j.songTime()
local y=os.clock()


local z=j.runId()
if z~=t then
t=z
resetPlaybackState()
end


if v=="countdown"and m.SkipCountdown then
if w and w.tiles and w.tiles[1]then
j.press(w.tiles[1].lane,y)
end
return
end


if v=="gated"and m.InstantGate then
local A=j.gate()
if A and w and w.tiles then
while r<=#w.tiles and w.tiles[r].t<=A.t+1e-5 do
local B=w.tiles[r]
r+=1
j.press(B.lane,y)
if B.hold then
table.insert(s,{
at=x+B.hold*m.HoldFraction,
lane=B.lane
})
end
end
end
return
end


if v=="playing"and w and w.tiles then

local A=0.80
if m.AccuracyMode=="Humanized"then

A=0.795+(math.random()-0.5)*0.03
elseif m.AccuracyMode=="Custom"then
A=math.clamp(m.CustomFallRatio,0.5,1.0)
end

while r<=#w.tiles do
local B=w.tiles[r]
local C=j.fallAt(B,A)

if x<C then
break
end

r+=1
j.press(B.lane,y)

if m.VisualFlash and k and k.flashLane then
pcall(k.flashLane,B.lane)
end

if B.hold then
local D=x+B.hold*math.clamp(m.HoldFraction,0.82,1.0)
table.insert(s,{
at=D,
lane=B.lane
})
end
end


for B=#s,1,-1 do
local C=s[B]
if x>=C.at then
table.remove(s,B)
j.release(C.lane,y)
end
end
end


if v=="failed"and m.AutoRevive then
pcall(j.revive)
end


if v=="finished"and m.AutoReplay and not u then
u=true
task.delay(math.max(m.ReplayDelay or 1.2,0.5),function()
if j.phase()=="finished"then
local A=j.currentSong()
if A and l then
pcall(function()
l.set{screen="play",song=A.id}
end)
end
end
u=false
end)
end
end

onConn(b.Heartbeat:Connect(autoStep))




local v=Instance.new"ScreenGui"
v.Name="PianoGodToasts"
v.ResetOnSpawn=false
v.IgnoreGuiInset=true
v.DisplayOrder=100050
v.Parent=f:WaitForChild"PlayerGui"

local w=Instance.new"Frame"
w.Name="Container"
w.AnchorPoint=Vector2.new(0.5,0)
w.Position=UDim2.new(0.5,0,0,50)
w.Size=UDim2.new(0,310,0,180)
w.BackgroundTransparency=1
w.Parent=v

local x={}

q=function(y,z,A)
local B=Instance.new"Frame"
B.BackgroundColor3=n.BgCard
B.BorderSizePixel=0
B.Size=UDim2.new(1,0,0,48)
B.BackgroundTransparency=1
B.Parent=w

local C=Instance.new("UICorner",B)
C.CornerRadius=UDim.new(0,10)
local D=Instance.new("UIStroke",B)
D.Color=A or n.Cyan
D.Transparency=0.35
D.Thickness=1.2

local E=Instance.new("Frame",B)
E.Size=UDim2.new(0,4,1,-12)
E.Position=UDim2.new(0,8,0,6)
E.BackgroundColor3=A or n.Cyan
E.BorderSizePixel=0
Instance.new("UICorner",E).CornerRadius=UDim.new(1,0)

local F=Instance.new("TextLabel",B)
F.BackgroundTransparency=1
F.Position=UDim2.new(0,20,0,6)
F.Size=UDim2.new(1,-26,0,18)
F.Font=Enum.Font.GothamBold
F.TextSize=13
F.TextColor3=n.Text
F.TextXAlignment=Enum.TextXAlignment.Left
F.Text=y

local G=Instance.new("TextLabel",B)
G.BackgroundTransparency=1
G.Position=UDim2.new(0,20,0,24)
G.Size=UDim2.new(1,-26,0,16)
G.Font=Enum.Font.Gotham
G.TextSize=11
G.TextColor3=n.TextDim
G.TextXAlignment=Enum.TextXAlignment.Left
G.Text=z

table.insert(x,B)
for H,I in ipairs(x)do
I.Position=UDim2.new(0,0,0,(H-1)*54)
end
c:Create(B,TweenInfo.new(0.24,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{BackgroundTransparency=0.08}):Play()

task.delay(2.6,function()
c:Create(B,TweenInfo.new(0.28),{BackgroundTransparency=1}):Play()
for H,I in ipairs(B:GetChildren())do
if I:IsA"TextLabel"then
c:Create(I,TweenInfo.new(0.28),{TextTransparency=1}):Play()
elseif I:IsA"Frame"then
c:Create(I,TweenInfo.new(0.28),{BackgroundTransparency=1}):Play()
elseif I:IsA"UIStroke"then
c:Create(I,TweenInfo.new(0.28),{Transparency=1}):Play()
end
end
task.delay(0.32,function()
local H=table.find(x,B)
if H then table.remove(x,H)end
B:Destroy()
for I,J in ipairs(x)do
J.Position=UDim2.new(0,0,0,(I-1)*54)
end
end)
end)
end




local function make(y,z)
local A=Instance.new(y)
for B,C in pairs(z)do
if B~="Parent"then A[B]=C end
end
if z.Parent then A.Parent=z.Parent end
return A
end

local function addCorner(y,z)
return make("UICorner",{CornerRadius=UDim.new(0,z or 10),Parent=y})
end

local function addStroke(y,z,A,B)
return make("UIStroke",{Color=z or n.Border,Thickness=A or 1,Transparency=B or 0.3,Parent=y})
end

local function makeToggle(y,z,A,B)
local C=make("Frame",{
BackgroundColor3=n.BgCard,
Size=UDim2.new(1,0,0,50),
BorderSizePixel=0,
})
addCorner(C,10)
addStroke(C,n.Border,1,0.5)

local D=A
local E=make("Frame",{
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(1,-12,0.5,0),
Size=UDim2.fromOffset(46,24),
BackgroundColor3=D and n.Cyan or n.BgSub,
BorderSizePixel=0,
Parent=C,
})
addCorner(E,12)
local F=addStroke(E,D and n.Cyan or n.Border,1.2,0.3)

local G=make("Frame",{
AnchorPoint=Vector2.new(0.5,0.5),
Position=D and UDim2.new(1,-13,0.5,0)or UDim2.new(0,13,0.5,0),
Size=UDim2.fromOffset(16,16),
BackgroundColor3=D and n.Bg or n.White,
BorderSizePixel=0,
Parent=E,
})
addCorner(G,8)

make("TextLabel",{
BackgroundTransparency=1,
Position=UDim2.new(0,14,0,8),
Size=UDim2.new(1,-75,0,18),
Font=Enum.Font.GothamBold,
TextSize=13,
TextColor3=n.Text,
TextXAlignment=Enum.TextXAlignment.Left,
Text=y,
Parent=C,
})
make("TextLabel",{
BackgroundTransparency=1,
Position=UDim2.new(0,14,0,26),
Size=UDim2.new(1,-75,0,14),
Font=Enum.Font.Gotham,
TextSize=10,
TextColor3=n.TextDim,
TextXAlignment=Enum.TextXAlignment.Left,
Text=z or"",
Parent=C,
})

local H=make("TextButton",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
Text="",
Parent=C,
})

onConn(H.Activated:Connect(function()
D=not D
c:Create(E,TweenInfo.new(0.2),{BackgroundColor3=D and n.Cyan or n.BgSub}):Play()
F.Color=D and n.Cyan or n.Border
c:Create(G,TweenInfo.new(0.22,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
Position=D and UDim2.new(1,-13,0.5,0)or UDim2.new(0,13,0.5,0),
BackgroundColor3=D and n.Bg or n.White,
}):Play()
task.spawn(B,D)
end))

return C
end

local function makeSlider(y,z,A,B,C,D,E)
local F=make("Frame",{
BackgroundColor3=n.BgCard,
Size=UDim2.new(1,0,0,56),
BorderSizePixel=0,
})
addCorner(F,10)
addStroke(F,n.Border,1,0.5)

local G=B
make("TextLabel",{
BackgroundTransparency=1,
Position=UDim2.new(0,14,0,7),
Size=UDim2.new(0.6,0,0,16),
Font=Enum.Font.GothamBold,
TextSize=12,
TextColor3=n.Text,
TextXAlignment=Enum.TextXAlignment.Left,
Text=y,
Parent=F,
})
local H=make("TextLabel",{
BackgroundTransparency=1,
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,-14,0,7),
Size=UDim2.new(0.35,0,0,16),
Font=Enum.Font.GothamBold,
TextSize=12,
TextColor3=n.Cyan,
TextXAlignment=Enum.TextXAlignment.Right,
Text=tostring(B)..(D or""),
Parent=F,
})

local I=make("Frame",{
Position=UDim2.new(0,14,0,32),
Size=UDim2.new(1,-28,0,6),
BackgroundColor3=n.BgSub,
BorderSizePixel=0,
Parent=F,
})
addCorner(I,3)

local J=math.clamp((G-z)/(A-z),0,1)
local K=make("Frame",{
Size=UDim2.new(J,0,1,0),
BackgroundColor3=n.Cyan,
BorderSizePixel=0,
Parent=I,
})
addCorner(K,3)

local L=make("Frame",{
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(J,0,0.5,0),
Size=UDim2.fromOffset(14,14),
BackgroundColor3=n.White,
BorderSizePixel=0,
Parent=I,
})
addCorner(L,7)

local M=function(M)
local N=10^(C or 0)
return tostring(math.floor(M*N+0.5)/N)
end

local N=false
local function setX(O)
local P=math.clamp((O-I.AbsolutePosition.X)/math.max(I.AbsoluteSize.X,1),0,1)
G=z+(A-z)*P
local Q=(G-z)/(A-z)
K.Size=UDim2.new(Q,0,1,0)
L.Position=UDim2.new(Q,0,0.5,0)
H.Text=M(G)..(D or"")
E(G)
end

local O=make("TextButton",{
BackgroundTransparency=1,
Position=UDim2.new(0,0,0,22),
Size=UDim2.new(1,0,0,36),
Text="",
Parent=F,
})
onConn(O.InputBegan:Connect(function(P)
if P.UserInputType==Enum.UserInputType.MouseButton1 or P.UserInputType==Enum.UserInputType.Touch then
N=true
setX(P.Position.X)
end
end))
onConn(O.InputEnded:Connect(function(P)
if P.UserInputType==Enum.UserInputType.MouseButton1 or P.UserInputType==Enum.UserInputType.Touch then
N=false
end
end))
onConn(d.InputChanged:Connect(function(P)
if N and(P.UserInputType==Enum.UserInputType.MouseMovement or P.UserInputType==Enum.UserInputType.Touch)then
setX(P.Position.X)
end
end))

return F
end

local function makeBtn(y,z,A,B,C)
local D=make("TextButton",{
Size=C or UDim2.new(1,0,0,A or 38),
BackgroundColor3=z or n.BgCard,
Font=Enum.Font.GothamBold,
TextSize=12,
TextColor3=n.Text,
Text=y,
BorderSizePixel=0,
})
addCorner(D,10)
addStroke(D,n.Border,1,0.4)
onConn(D.Activated:Connect(function()task.spawn(B)end))
return D
end

local function makeSec(y,z)
local A=make("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,24)})
make("TextLabel",{
BackgroundTransparency=1,
Position=UDim2.new(0,4,0,4),
Size=UDim2.new(1,-8,1,0),
Font=Enum.Font.GothamBold,
TextSize=11,
TextColor3=z or n.Cyan,
TextXAlignment=Enum.TextXAlignment.Left,
Text="▍ "..y:upper(),
Parent=A,
})
return A
end




do
local y=make("ScreenGui",{
Name="PianoGodUI",
ResetOnSpawn=false,
IgnoreGuiInset=true,
DisplayOrder=100000,
ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
Parent=f:WaitForChild"PlayerGui",
})
p.Gui=y


local z=make("TextButton",{
Name="PianoOrb",
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0,42,0.75,0),
Size=UDim2.fromOffset(58,58),
BackgroundColor3=n.BgCard,
Text="🎹",
TextSize=24,
Font=Enum.Font.GothamBold,
TextColor3=n.Cyan,
BorderSizePixel=0,
Parent=y,
})
addCorner(z,29)
addStroke(z,n.Cyan,2,0.1)

local A=make("Frame",{
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.fromScale(0.5,0.5),
Size=UDim2.fromOffset(58,58),
BackgroundTransparency=1,
Parent=z,
})
addCorner(A,29)
local B=addStroke(A,n.Purple,3,0.3)

task.spawn(function()
while z.Parent do
c:Create(B,TweenInfo.new(1.3,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=0.8,Thickness=6}):Play()
task.wait(1.3)
c:Create(B,TweenInfo.new(1.3,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=0.3,Thickness=2.5}):Play()
task.wait(1.3)
end
end)

local C=workspace.CurrentCamera
local D=C and C.ViewportSize or Vector2.new(1280,720)
local E=math.clamp(D.X-20,300,370)
local F=math.clamp(D.Y-50,400,560)

local G=make("CanvasGroup",{
Name="MainPanel",
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Size=UDim2.fromOffset(E,F),
BackgroundColor3=n.Bg,
BorderSizePixel=0,
GroupTransparency=1,
Visible=false,
Parent=y,
})
addCorner(G,14)
addStroke(G,n.Border,1.2,0.2)
p.Panel=G

local H=false
p.isOpen=function()return H end
p.setOpen=function(I)
H=I
if I then
G.Visible=true
G.Position=UDim2.new(0.5,0,0.5,30)
c:Create(G,TweenInfo.new(0.28,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{
Position=UDim2.new(0.5,0,0.5,0),
GroupTransparency=0,
}):Play()
else
c:Create(G,TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{
Position=UDim2.new(0.5,0,0.5,30),
GroupTransparency=1,
}):Play()
task.delay(0.24,function()
if not H then G.Visible=false end
end)
end
end


local I=make("Frame",{
Size=UDim2.new(1,0,0,54),
BackgroundColor3=n.BgCard,
BorderSizePixel=0,
Parent=G,
})
addCorner(I,14)
make("Frame",{
Position=UDim2.new(0,0,1,-14),
Size=UDim2.new(1,0,0,14),
BackgroundColor3=n.BgCard,
BorderSizePixel=0,
Parent=I,
})

make("TextLabel",{
BackgroundTransparency=1,
Position=UDim2.new(0,16,0,8),
Size=UDim2.new(1,-70,0,20),
Font=Enum.Font.GothamBold,
TextSize=17,
TextColor3=n.Cyan,
TextXAlignment=Enum.TextXAlignment.Left,
Text="🎹 PIANO GOD",
Parent=I,
})
make("TextLabel",{
BackgroundTransparency=1,
Position=UDim2.new(0,16,0,28),
Size=UDim2.new(1,-70,0,14),
Font=Enum.Font.Gotham,
TextSize=10,
TextColor3=n.TextDim,
TextXAlignment=Enum.TextXAlignment.Left,
Text="Virtuoso Edition • All Perfect Autoplayer",
Parent=I,
})

local J=make("TextButton",{
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(1,-12,0.5,0),
Size=UDim2.fromOffset(28,28),
BackgroundColor3=n.BgSub,
Text="✕",
TextSize=12,
Font=Enum.Font.GothamBold,
TextColor3=n.Red,
BorderSizePixel=0,
Parent=I,
})
addCorner(J,8)
onConn(J.Activated:Connect(function()p.setOpen(false)end))


local K=make("Frame",{
Position=UDim2.new(0,12,0,60),
Size=UDim2.new(1,-24,0,28),
BackgroundTransparency=1,
Parent=G,
})
make("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,6),Parent=K})
local function mkChip()
local L=make("Frame",{
Size=UDim2.new(0.333,-4,1,0),
BackgroundColor3=n.BgCard,
BorderSizePixel=0,
Parent=K,
})
addCorner(L,8)
addStroke(L,n.Border,1,0.5)
return make("TextLabel",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
Font=Enum.Font.GothamBold,
TextSize=10,
TextColor3=n.TextDim,
Text="—",
Parent=L,
})
end
p.ChipSong=mkChip()
p.ChipPhase=mkChip()
p.ChipCombo=mkChip()


local L=make("Frame",{
Position=UDim2.new(0,12,0,94),
Size=UDim2.new(1,-24,0,32),
BackgroundTransparency=1,
Parent=G,
})
make("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,4),Parent=L})
p.TabBtns={}
p.TabPages={}

local M="Auto"
local function switchTab(N)
M=N
for O,P in pairs(p.TabBtns)do
P.BackgroundColor3=(O==N)and n.Cyan or n.BgCard
P.TextColor3=(O==N)and n.Bg or n.TextMain
end
for O,P in pairs(p.TabPages)do
P.Visible=(O==N)
end
end

local function mkTabBtn(N,O)
local P=make("TextButton",{
Size=UDim2.new(0.25,-3,1,0),
BackgroundColor3=(M==N)and n.Cyan or n.BgCard,
Font=Enum.Font.GothamBold,
TextSize=10,
TextColor3=(M==N)and n.Bg or n.Text,
Text=O,
BorderSizePixel=0,
Parent=L,
})
addCorner(P,8)
addStroke(P,n.Border,1,0.4)
onConn(P.Activated:Connect(function()switchTab(N)end))
p.TabBtns[N]=P
return P
end
mkTabBtn("Auto","⚡ AUTO")
mkTabBtn("God","🛡 GOD")
mkTabBtn("Songs","🎵 SONGS")
mkTabBtn("Stats","📊 STATS")


local N=make("Frame",{
Position=UDim2.new(0,12,0,132),
Size=UDim2.new(1,-24,1,-170),
BackgroundTransparency=1,
BorderSizePixel=0,
Parent=G,
})

local function mkTabPage(O)
local P=make("ScrollingFrame",{
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
BorderSizePixel=0,
ScrollBarThickness=3,
ScrollBarImageColor3=n.Cyan,
CanvasSize=UDim2.new(0,0,0,0),
AutomaticCanvasSize=Enum.AutomaticSize.Y,
ElasticBehavior=Enum.ElasticBehavior.Always,
Visible=(M==O),
Parent=N,
})
make("UIListLayout",{Padding=UDim.new(0,6),Parent=P})
make("UIPadding",{PaddingRight=UDim.new(0,4),Parent=P})
p.TabPages[O]=P
return P
end




local O=mkTabPage"Auto"
local function addAuto(P)P.Parent=O end

addAuto(makeSec("⚡ All Perfect Autoplayer",n.Cyan))
addAuto(makeToggle("God Autoplayer","Strikes notes with 100% accuracy",m.AutoPlay,function(P)
m.AutoPlay=P
q("⚡ Autoplayer",P and"Active • All Perfect Mode"or"Disabled",P and n.Green or n.TextDim)
end))


local P=make("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,32)})
make("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,5),Parent=P})
p.AccBtns={}
local function mkAccBtn(Q,R)
local S=make("TextButton",{
Size=UDim2.new(0.333,-4,1,0),
BackgroundColor3=(m.AccuracyMode==Q)and n.Cyan or n.BgCard,
Font=Enum.Font.GothamBold,
TextSize=10,
TextColor3=(m.AccuracyMode==Q)and n.Bg or n.Text,
Text=R,
BorderSizePixel=0,
Parent=P,
})
addCorner(S,8)
addStroke(S,n.Border,1,0.4)
onConn(S.Activated:Connect(function()
m.AccuracyMode=Q
for T,U in pairs(p.AccBtns)do
U.BackgroundColor3=(T==Q)and n.Cyan or n.BgCard
U.TextColor3=(T==Q)and n.Bg or n.Text
end
q("🎯 Accuracy Mode",R.." activated",n.Cyan)
end))
p.AccBtns[Q]=S
return S
end
mkAccBtn("God","★ 100% PERFECT")
mkAccBtn("Humanized","PRO HUMAN")
mkAccBtn("Custom","CUSTOM")
addAuto(P)

addAuto(makeSlider("Custom Timing Ratio",0.60,1.00,m.CustomFallRatio,2,"x",function(Q)
m.CustomFallRatio=Q
end))
addAuto(makeSlider("Hold Note Release Fraction",0.85,1.00,m.HoldFraction,2,"x",function(Q)
m.HoldFraction=Q
end))
addAuto(makeToggle("Skip Countdown","Instantly starts song at 0s",m.SkipCountdown,function(Q)
m.SkipCountdown=Q
end))
addAuto(makeToggle("Instant Gate Clear","Instantly passes pause gates",m.InstantGate,function(Q)
m.InstantGate=Q
end))




local Q=mkTabPage"God"
local function addGod(R)R.Parent=Q end

addGod(makeSec("🛡 Survival & Never Fail",n.Purple))
addGod(makeToggle("Auto Revive (Never Lose)","Instantly revives if song fails",m.AutoRevive,function(R)
m.AutoRevive=R
q("🛡 Godmode",R and"Auto Revive Enabled"or"Disabled",R and n.Green or n.TextDim)
end))

local R=makeBtn("⚡ TRIGGER INSTANT REVIVE",n.BgCard,36,function()
pcall(j.revive)
q("🛡 Revive","Revive signal sent!",n.Purple)
end)
addGod(R)

addGod(makeSec("🎚 Song Modifiers",n.Gold))
addGod(makeSlider("Scroll Speed Multiplier",0.5,3.0,m.ScrollSpeed,1,"x",function(S)
m.ScrollSpeed=S
pcall(function()j.setScroll(S)end)
end))
addGod(makeToggle("Upscroll Mode","Notes travel bottom-to-top",m.Upscroll,function(S)
m.Upscroll=S
pcall(function()j.setUpscroll(S)end)
end))
addGod(makeToggle("Neon Lane Flash FX","Visual glow and particle splash",m.VisualFlash,function(S)
m.VisualFlash=S
end))




local S=mkTabPage"Songs"
local function addSongs(T)T.Parent=S end

addSongs(makeSec("🔄 AFK Endless Coin Farm",n.Green))
addSongs(makeToggle("Auto Replay Song","Continuously farm coins AFK",m.AutoReplay,function(T)
m.AutoReplay=T
q("🔄 AFK Farm",T and"Auto Replay Active"or"Disabled",T and n.Green or n.TextDim)
end))
addSongs(makeSlider("Replay Delay",0.5,4.0,m.ReplayDelay,1,"s",function(T)
m.ReplayDelay=T
end))

addSongs(makeSec("🚀 Quick Launch Top Songs",n.Cyan))
local T={
{id="rushe",name="Rush E 🔥"},
{id="crabrave",name="Crab Rave 🦀"},
{id="goldenhour",name="Golden Hour ✨"},
{id="pokemoncenter",name="Pokemon Center ⚡"},
{id="everlong",name="Everlong 🎸"},
}
for U,V in ipairs(T)do
local W=makeBtn(V.name,n.BgCard,34,function()
if l then
pcall(function()
l.set{screen="play",song=V.id}
q("🎵 Launched",V.name,n.Cyan)
end)
end
end)
addSongs(W)
end




local U=mkTabPage"Stats"
local function addStats(V)V.Parent=U end

addStats(makeSec("📊 Live Performance",n.Cyan))
local function mkStatRow(V,W)
local X=make("Frame",{
BackgroundColor3=n.BgCard,
Size=UDim2.new(1,0,0,36),
BorderSizePixel=0,
})
addCorner(X,8)
addStroke(X,n.Border,1,0.4)
make("TextLabel",{
BackgroundTransparency=1,
Position=UDim2.new(0,12,0,0),
Size=UDim2.new(0.5,0,1,0),
Font=Enum.Font.GothamBold,
TextSize=12,
TextColor3=n.TextDim,
TextXAlignment=Enum.TextXAlignment.Left,
Text=V,
Parent=X,
})
local Y=make("TextLabel",{
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0,0),
Size=UDim2.new(0.5,-12,1,0),
Font=Enum.Font.GothamBold,
TextSize=12,
TextColor3=n.Cyan,
TextXAlignment=Enum.TextXAlignment.Right,
Text=W or"—",
Parent=X,
})
addStats(X)
return Y
end

p.StatScore=mkStatRow("Current Score","0")
p.StatAccuracy=mkStatRow("Accuracy Rating","100.0%")
p.StatCombo=mkStatRow("Combo / Max Streak","0 / 0")
p.StatPerfects=mkStatRow("Perfect Hits","0")
p.StatMisses=mkStatRow("Miss Count","0")


local V=make("Frame",{
AnchorPoint=Vector2.new(0.5,1),
Position=UDim2.new(0.5,0,1,-8),
Size=UDim2.new(1,-24,0,26),
BackgroundTransparency=1,
Parent=G,
})
make("TextLabel",{
BackgroundTransparency=1,
Position=UDim2.new(0,0,0,0),
Size=UDim2.new(1,-85,1,0),
Font=Enum.Font.GothamBold,
TextSize=11,
TextColor3=n.TextDim,
TextXAlignment=Enum.TextXAlignment.Left,
Text="made with 💜 by doinieate",
Parent=V,
})
local W=makeBtn("UNLOAD",n.BgSub,26,function()
if _G.__PIANOGOD and _G.__PIANOGOD.Unload then
_G.__PIANOGOD.Unload()
end
end,UDim2.new(0,75,1,0))
W.AnchorPoint=Vector2.new(1,0.5)
W.Position=UDim2.new(1,0,0.5,0)
W.TextColor3=n.Red
W.TextSize=10
W.Parent=V


local function enableDrag(X,Y)
local Z,_,aa=false
onConn(X.InputBegan:Connect(function(ab)
if ab.UserInputType==Enum.UserInputType.MouseButton1 or ab.UserInputType==Enum.UserInputType.Touch then
Z=true;_=ab.Position;aa=Y.Position
end
end))
onConn(d.InputChanged:Connect(function(ab)
if Z and(ab.UserInputType==Enum.UserInputType.MouseMovement or ab.UserInputType==Enum.UserInputType.Touch)then
local ac=ab.Position-_
Y.Position=UDim2.new(aa.X.Scale,aa.X.Offset+ac.X,aa.Y.Scale,aa.Y.Offset+ac.Y)
end
end))
onConn(d.InputEnded:Connect(function(ab)
if ab.UserInputType==Enum.UserInputType.MouseButton1 or ab.UserInputType==Enum.UserInputType.Touch then
Z=false
end
end))
end
enableDrag(I,G)
enableDrag(z,z)

onConn(z.Activated:Connect(function()
p.setOpen(not p.isOpen())
end))
end




local function updateDashboard()
if not p.ChipSong then return end

local aa=j.phase()
local ab=j.currentSong()
local ac=(ab and ab.title)or j.currentSongId()or"Menu"

p.ChipSong.Text=string.sub(ac,1,14)
p.ChipPhase.Text=string.upper(aa)
p.ChipPhase.TextColor3=(aa=="playing")and n.Green or(aa=="failed"and n.Red or n.Gold)

local y,z=pcall(j.stats)
if y and z then
local A=z.combo or 0
local B=z.maxCombo or 0
local C=z.hits or 0
local D=z.misses or 0
local E=z.perfects or 0
local F=C+D

p.ChipCombo.Text=string.format("x%d COMBO",A)
p.ChipCombo.TextColor3=A>0 and n.Cyan or n.TextDim

if p.StatScore then
p.StatScore.Text=tostring(z.score or 0)
p.StatCombo.Text=string.format("%d / %d",A,B)
p.StatPerfects.Text=tostring(E)
p.StatMisses.Text=tostring(D)
local G=F>0 and(E/F*100)or 100.0
p.StatAccuracy.Text=string.format("%.1f%%",G)
end
end
end

onConn(b.Heartbeat:Connect(function()
pcall(updateDashboard)
end))




onConn(d.InputBegan:Connect(function(aa,ab)
if ab then return end
if aa.KeyCode==Enum.KeyCode.RightShift then
p.setOpen(not p.isOpen())
end
end))




local aa=false
local function Unload()
if aa then return end
aa=true
for ab,ac in ipairs(o)do pcall(function()ac:Disconnect()end)end
if p.Gui then pcall(function()p.Gui:Destroy()end)end
if v then pcall(function()v:Destroy()end)end
_G.__PIANOGOD=nil
print"[Piano God] Successfully Unloaded."
end

_G.__PIANOGOD={
Unload=Unload,
Settings=m,
Engine=j,
Board=k,
UI=p,
}

q("🎹 Piano God v1.0","All Perfect Autoplayer Ready!",n.Cyan)

end)
if not a then
_G.__PIANOGOD_LOADERR=tostring(aa)
warn("[Piano God] Load Error: "..tostring(aa))
end