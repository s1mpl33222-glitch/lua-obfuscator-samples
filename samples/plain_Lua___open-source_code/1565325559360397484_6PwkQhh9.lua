local Players=game:GetService("Players")
local LP=Players.LocalPlayer
local UIS=game:GetService("UserInputService")
local TS=game:GetService("TweenService")
local RS=game:GetService("RunService")
local MS=game:GetService("MarketplaceService")
local LG=game:GetService("Lighting")

_G.SavedCheckpoint=nil
_G.AutoRespawnEnabled=true
local lockedDN=false
local lockedTime=12
local draggingSlider=false

local function saveCP()
local c=LP.Character
if c and c:FindFirstChild("HumanoidRootPart") then
_G.SavedCheckpoint={CFrame=c.HumanoidRootPart.CFrame}
return true end return false end

local function goCP()
if not _G.SavedCheckpoint then return false end
local c=LP.Character
if c and c:FindFirstChild("HumanoidRootPart") then
c.HumanoidRootPart.CFrame=_G.SavedCheckpoint.CFrame
return true end return false end

local function hookChar(ch)
local h=ch:WaitForChild("Humanoid")
h.Died:Connect(function()
if _G.AutoRespawnEnabled and _G.SavedCheckpoint then
task.wait(0.5)
local n=LP.Character
if not n or not n:FindFirstChild("HumanoidRootPart") then
n=LP.CharacterAdded:Wait() end
task.wait(0.5)
if n and n:FindFirstChild("HumanoidRootPart") then
n.HumanoidRootPart.CFrame=_G.SavedCheckpoint.CFrame end
end end) end

if LP.Character then hookChar(LP.Character) end
LP.CharacterAdded:Connect(hookChar)

local old=LP:WaitForChild("PlayerGui"):FindFirstChild("ZolehubCP")
if old then old:Destroy() end

-- ============================================================
-- TRANSLATIONS
-- ============================================================
local TR={
ID={name="Indonesia",
title="CHECKPOINT",
save_cp="Simpan Checkpoint",go_cp="Ke Checkpoint",
auto_on="Auto-Respawn : ON",auto_off="Auto-Respawn : OFF",
players="👥  PEMAIN DI GAME",time="☀️  WAKTU HARI",
lock_on="🔒 KUNCI : ON",lock_off="🔓 KUNCI : OFF",
morning="Pagi",noon="Siang",evening="Sore",night="Malam",
ready="Siap...",saved="✓  Checkpoint disimpan!",
save_fail="✕  Gagal simpan",
tp_ok="→  Teleport ke checkpoint!",no_cp="✕  Belum ada checkpoint",
auto_on_msg="●  Auto-respawn aktif",auto_off_msg="●  Auto-respawn mati",
tp_to="→  Teleport ke ",target_bad="✕  Target tidak tersedia",
self_msg="●  Ini kamu sendiri",
lock_on_msg="🔒  Waktu dikunci",lock_off_msg="🔓  Kunci dibuka",
m_am="🌅  Waktu → Pagi",m_no="☀️  Waktu → Siang",
m_ev="🌇  Waktu → Sore",m_ni="🌙  Waktu → Malam",
saved_short="TERSIMPAN!",success_short="BERHASIL!",
lang_switched="🌐  Bahasa: ",you="YOU"},
EN={name="English",
title="CHECKPOINT",
save_cp="Save Checkpoint",go_cp="Go to Checkpoint",
auto_on="Auto-Respawn : ON",auto_off="Auto-Respawn : OFF",
players="👥  PLAYERS IN GAME",time="☀️  TIME OF DAY",
lock_on="🔒 LOCK : ON",lock_off="🔓 LOCK : OFF",
morning="Morning",noon="Noon",evening="Evening",night="Night",
ready="Ready...",saved="✓  Checkpoint saved!",
save_fail="✕  Failed to save",
tp_ok="→  Teleported to checkpoint!",no_cp="✕  No checkpoint saved",
auto_on_msg="●  Auto-respawn enabled",auto_off_msg="●  Auto-respawn disabled",
tp_to="→  Teleport to ",target_bad="✕  Target unavailable",
self_msg="●  This is you",
lock_on_msg="🔒  Time locked",lock_off_msg="🔓  Lock released",
m_am="🌅  Time → Morning",m_no="☀️  Time → Noon",
m_ev="🌇  Time → Evening",m_ni="🌙  Time → Night",
saved_short="SAVED!",success_short="SUCCESS!",
lang_switched="🌐  Language: ",you="YOU"},
JP={name="日本語",
title="チェックポイント",
save_cp="セーブポイント保存",go_cp="セーブポイントへ",
auto_on="自動復活 : ON",auto_off="自動復活 : OFF",
players="👥  ゲーム内プレイヤー",time="☀️  時刻",
lock_on="🔒 ロック : ON",lock_off="🔓 ロック : OFF",
morning="朝",noon="昼",evening="夕",night="夜",
ready="準備完了...",saved="✓  セーブポイント保存!",
save_fail="✕  保存失敗",
tp_ok="→  セーブポイントに移動!",no_cp="✕  セーブポイントなし",
auto_on_msg="●  自動復活ON",auto_off_msg="●  自動復活OFF",
tp_to="→  移動: ",target_bad="✕  ターゲット無効",
self_msg="●  自分自身です",
lock_on_msg="🔒  時刻ロック",lock_off_msg="🔓  ロック解除",
m_am="🌅  時刻 → 朝",m_no="☀️  時刻 → 昼",
m_ev="🌇  時刻 → 夕",m_ni="🌙  時刻 → 夜",
saved_short="保存完了!",success_short="成功!",
lang_switched="🌐  言語: ",you="自分"},
KR={name="한국어",
title="체크포인트",
save_cp="체크포인트 저장",go_cp="체크포인트로",
auto_on="자동 부활 : ON",auto_off="자동 부활 : OFF",
players="👥  게임 내 플레이어",time="☀️  시간",
lock_on="🔒 잠금 : ON",lock_off="🔓 잠금 : OFF",
morning="아침",noon="낮",evening="저녁",night="밤",
ready="준비 완료...",saved="✓  체크포인트 저장!",
save_fail="✕  저장 실패",
tp_ok="→  체크포인트로 이동!",no_cp="✕  체크포인트 없음",
auto_on_msg="●  자동 부활 켜짐",auto_off_msg="●  자동 부활 꺼짐",
tp_to="→  이동: ",target_bad="✕  대상 없음",
self_msg="●  자신입니다",
lock_on_msg="🔒  시간 잠금",lock_off_msg="🔓  잠금 해제",
m_am="🌅  시간 → 아침",m_no="☀️  시간 → 낮",
m_ev="🌇  시간 → 저녁",m_ni="🌙  시간 → 밤",
saved_short="저장됨!",success_short="성공!",
lang_switched="🌐  언어: ",you="나"},
ES={name="Español",
title="CHECKPOINT",
save_cp="Guardar Punto",go_cp="Ir al Punto",
auto_on="Auto-Renacer : ON",auto_off="Auto-Renacer : OFF",
players="👥  JUGADORES",time="☀️  HORA DEL DÍA",
lock_on="🔒 BLOQUEAR : ON",lock_off="🔓 BLOQUEAR : OFF",
morning="Mañana",noon="Mediodía",evening="Tarde",night="Noche",
ready="Listo...",saved="✓  Punto guardado!",
save_fail="✕  Error al guardar",
tp_ok="→  ¡Teletransportado!",no_cp="✕  Sin punto guardado",
auto_on_msg="●  Auto-renacer activado",auto_off_msg="●  Auto-renacer desactivado",
tp_to="→  Teletransporte a ",target_bad="✕  Objetivo no disponible",
self_msg="●  Este eres tú",
lock_on_msg="🔒  Hora bloqueada",lock_off_msg="🔓  Bloqueo liberado",
m_am="🌅  Hora → Mañana",m_no="☀️  Hora → Mediodía",
m_ev="🌇  Hora → Tarde",m_ni="🌙  Hora → Noche",
saved_short="¡GUARDADO!",success_short="¡ÉXITO!",
lang_switched="🌐  Idioma: ",you="TÚ"},
CN={name="中文",
title="检查点",
save_cp="保存检查点",go_cp="前往检查点",
auto_on="自动复活 : ON",auto_off="自动复活 : OFF",
players="👥  游戏内玩家",time="☀️  时间",
lock_on="🔒 锁定 : ON",lock_off="🔓 锁定 : OFF",
morning="早晨",noon="中午",evening="傍晚",night="夜晚",
ready="准备就绪...",saved="✓  检查点已保存!",
save_fail="✕  保存失败",
tp_ok="→  已传送到检查点!",no_cp="✕  无检查点",
auto_on_msg="●  自动复活已开启",auto_off_msg="●  自动复活已关闭",
tp_to="→  传送到 ",target_bad="✕  目标不可用",
self_msg="●  这是你自己",
lock_on_msg="🔒  时间已锁定",lock_off_msg="🔓  锁定已解除",
m_am="🌅  时间 → 早晨",m_no="☀️  时间 → 中午",
m_ev="🌇  时间 → 傍晚",m_ni="🌙  时间 → 夜晚",
saved_short="已保存!",success_short="成功!",
lang_switched="🌐  语言: ",you="你"}
}

local LangOrder={"ID","EN","JP","KR","ES","CN"}
local LangIdx=1

local function L(key)
local lang=TR[LangOrder[LangIdx]]
return lang[key] or key
end

local C={
BG=Color3.fromRGB(14,14,22),
BG2=Color3.fromRGB(24,24,38),
BG3=Color3.fromRGB(36,36,54),
A1=Color3.fromRGB(100,170,255),
A2=Color3.fromRGB(180,120,255),
A3=Color3.fromRGB(255,100,200),
OK=Color3.fromRGB(90,230,140),
WARN=Color3.fromRGB(255,200,90),
BAD=Color3.fromRGB(255,100,120),
TXT=Color3.fromRGB(240,240,250),
DIM=Color3.fromRGB(150,150,175)}

local PW,PH=480,280

local SG=Instance.new("ScreenGui")
SG.Name="ZolehubCP"
SG.ResetOnSpawn=false
SG.IgnoreGuiInset=true
SG.DisplayOrder=999999
SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
SG.Parent=LP:WaitForChild("PlayerGui")

-- ============ TOGGLE ★ ============
local TB=Instance.new("TextButton")
TB.Size=UDim2.new(0,50,0,50)
TB.Position=UDim2.new(0,20,0,180)
TB.BackgroundColor3=C.BG2
TB.Text=""
TB.AutoButtonColor=false
TB.BorderSizePixel=0
TB.ZIndex=50
TB.Parent=SG

local tbc=Instance.new("UICorner")
tbc.CornerRadius=UDim.new(1,0)
tbc.Parent=TB

local tbs=Instance.new("UIStroke")
tbs.Color=C.A1
tbs.Thickness=2
tbs.Transparency=0.3
tbs.Parent=TB

local tbsg=Instance.new("UIGradient")
tbsg.Color=ColorSequence.new({
ColorSequenceKeypoint.new(0,C.A1),
ColorSequenceKeypoint.new(0.33,C.A2),
ColorSequenceKeypoint.new(0.66,C.A3),
ColorSequenceKeypoint.new(1,C.A1)})
tbsg.Parent=tbs

local tbgl=Instance.new("UIStroke")
tbgl.Color=C.A2
tbgl.Thickness=6
tbgl.Transparency=0.85
tbgl.Parent=TB

local TL=Instance.new("TextLabel")
TL.Size=UDim2.new(1,0,1,0)
TL.BackgroundTransparency=1
TL.Text="★"
TL.TextColor3=C.WARN
TL.TextSize=28
TL.Font=Enum.Font.GothamBold
TL.ZIndex=51
TL.Parent=TB

task.spawn(function()
while TB.Parent do
for i=0,360,3 do
if not TB.Parent then break end
tbsg.Rotation=i
task.wait(0.04)
end end end)

task.spawn(function()
while TB.Parent do
TS:Create(tbgl,TweenInfo.new(1.6,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Thickness=11,Transparency=0.65}):Play()
task.wait(1.6)
TS:Create(tbgl,TweenInfo.new(1.6,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Thickness=6,Transparency=0.88}):Play()
task.wait(1.6)
end end)

task.spawn(function()
local cols={C.WARN,C.A1,C.A2,C.A3,C.OK}
local i=1
while TL.Parent do
i=i%#cols+1
TS:Create(TL,TweenInfo.new(1.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{TextColor3=cols[i]}):Play()
task.wait(1.8)
end end)

task.spawn(function()
while TL.Parent do
TS:Create(TL,TweenInfo.new(4,Enum.EasingStyle.Linear),{Rotation=TL.Rotation+360}):Play()
task.wait(4)
end end)

task.spawn(function()
while TL.Parent do
TS:Create(TL,TweenInfo.new(1.4,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{TextSize=32}):Play()
task.wait(1.4)
TS:Create(TL,TweenInfo.new(1.4,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{TextSize=24}):Play()
task.wait(1.4)
end end)

local tDrag,tStart,tPos,tMoved=false,nil,nil,false
TB.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
tDrag=true tMoved=false tStart=i.Position tPos=TB.Position end end)

UIS.InputChanged:Connect(function(i)
if tDrag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
local d=i.Position-tStart
if math.abs(d.X)>3 or math.abs(d.Y)>3 then tMoved=true end
TB.Position=UDim2.new(tPos.X.Scale,tPos.X.Offset+d.X,tPos.Y.Scale,tPos.Y.Offset+d.Y) end end)

UIS.InputEnded:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
tDrag=false end end)

-- ============ MAIN PANEL ============
local MF=Instance.new("Frame")
MF.Size=UDim2.new(0,PW,0,PH)
MF.Position=UDim2.new(0,20,0,80)
MF.BackgroundColor3=C.BG
MF.BorderSizePixel=0
MF.ClipsDescendants=true
MF.Visible=false
MF.ZIndex=10
MF.Parent=SG

local mc=Instance.new("UICorner")
mc.CornerRadius=UDim.new(0,14)
mc.Parent=MF

local bgGrad=Instance.new("Frame")
bgGrad.Size=UDim2.new(2,0,2,0)
bgGrad.Position=UDim2.new(-0.5,0,-0.5,0)
bgGrad.BackgroundColor3=C.BG2
bgGrad.BorderSizePixel=0
bgGrad.ZIndex=0
bgGrad.Parent=MF

local bgGradG=Instance.new("UIGradient")
bgGradG.Color=ColorSequence.new({
ColorSequenceKeypoint.new(0,C.BG),
ColorSequenceKeypoint.new(0.25,C.BG3),
ColorSequenceKeypoint.new(0.5,C.BG2),
ColorSequenceKeypoint.new(0.75,C.BG3),
ColorSequenceKeypoint.new(1,C.BG)})
bgGradG.Rotation=45
bgGradG.Transparency=NumberSequence.new({
NumberSequenceKeypoint.new(0,0.2),
NumberSequenceKeypoint.new(0.5,0.5),
NumberSequenceKeypoint.new(1,0.2)})
bgGradG.Parent=bgGrad

local bgCorner=Instance.new("UICorner")
bgCorner.CornerRadius=UDim.new(0,14)
bgCorner.Parent=bgGrad

task.spawn(function()
while bgGrad.Parent do
TS:Create(bgGradG,TweenInfo.new(6,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Offset=Vector2.new(1,1)}):Play()
task.wait(6)
TS:Create(bgGradG,TweenInfo.new(6,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Offset=Vector2.new(0,0)}):Play()
task.wait(6)
end end)

local particles={}
for i=1,10 do
local p=Instance.new("Frame")
local sz=math.random(2,3)
p.Size=UDim2.new(0,sz,0,sz)
p.Position=UDim2.new(math.random(),1,0,0)
p.BackgroundColor3=i%2==0 and C.A1 or C.A2
p.BackgroundTransparency=0.5
p.BorderSizePixel=0
p.ZIndex=1
p.Parent=MF
local pc=Instance.new("UICorner")
pc.CornerRadius=UDim.new(1,0)
pc.Parent=p
table.insert(particles,{f=p,spd=math.random(30,70)/1000})
end

RS.RenderStepped:Connect(function(dt)
if not MF.Visible then return end
for _,p in ipairs(particles) do
local ny=p.f.Position.Y.Scale-p.spd*dt*60
if ny<-0.05 then
ny=1.05
p.f.Position=UDim2.new(math.random(),0,0,ny)
else
p.f.Position=UDim2.new(p.f.Position.X.Scale,0,0,ny)
end
end end)

for i=1,6 do
local line=Instance.new("Frame")
line.Size=UDim2.new(0,1,2,0)
line.Position=UDim2.new(i/7,-1,0,0)
line.BackgroundColor3=C.A1
line.BackgroundTransparency=0.92
line.BorderSizePixel=0
line.ZIndex=0
line.Rotation=20
line.Parent=MF
task.spawn(function()
while line.Parent do
local t1=TS:Create(line,TweenInfo.new(8,Enum.EasingStyle.Linear),{Position=UDim2.new(line.Position.X.Scale,0,0,-PH*2)})
t1:Play()
t1.Completed:Wait()
line.Position=UDim2.new(line.Position.X.Scale,0,0,0)
task.wait(0.1)
end end)
end

local gridHolder=Instance.new("Frame")
gridHolder.Size=UDim2.new(1,0,1,0)
gridHolder.BackgroundTransparency=1
gridHolder.ZIndex=1
gridHolder.ClipsDescendants=true
gridHolder.Parent=MF

for x=0,20 do
local vl=Instance.new("Frame")
vl.Size=UDim2.new(0,1,1,0)
vl.Position=UDim2.new(0,x*25,0,0)
vl.BackgroundColor3=C.A2
vl.BackgroundTransparency=0.94
vl.BorderSizePixel=0
vl.ZIndex=1
vl.Parent=gridHolder
end
for y=0,12 do
local hl=Instance.new("Frame")
hl.Size=UDim2.new(1,0,0,1)
hl.Position=UDim2.new(0,0,0,y*25)
hl.BackgroundColor3=C.A2
hl.BackgroundTransparency=0.94
hl.BorderSizePixel=0
hl.ZIndex=1
hl.Parent=gridHolder
end

task.spawn(function()
while gridHolder.Parent do
TS:Create(gridHolder,TweenInfo.new(3,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Position=UDim2.new(0,0,0,12)}):Play()
task.wait(3)
TS:Create(gridHolder,TweenInfo.new(3,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Position=UDim2.new(0,0,0,0)}):Play()
task.wait(3)
end end)

local ms=Instance.new("UIStroke")
ms.Color=C.A1
ms.Thickness=1.5
ms.Transparency=0.2
ms.Parent=MF

local msg=Instance.new("UIGradient")
msg.Color=ColorSequence.new({
ColorSequenceKeypoint.new(0,C.A1),
ColorSequenceKeypoint.new(0.33,C.A2),
ColorSequenceKeypoint.new(0.66,C.A3),
ColorSequenceKeypoint.new(1,C.A1)})
msg.Parent=ms

local mgl=Instance.new("UIStroke")
mgl.Color=C.A2
mgl.Thickness=6
mgl.Transparency=0.88
mgl.Parent=MF

task.spawn(function()
while MF.Parent do
for i=0,360,3 do
if not MF.Parent then break end
msg.Rotation=i
task.wait(0.03)
end end end)

task.spawn(function()
while MF.Parent do
TS:Create(mgl,TweenInfo.new(2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Thickness=11,Transparency=0.78}):Play()
task.wait(2)
TS:Create(mgl,TweenInfo.new(2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Thickness=6,Transparency=0.92}):Play()
task.wait(2)
end end)

local orb=Instance.new("Frame")
orb.Size=UDim2.new(1,0,1,0)
orb.BackgroundTransparency=1
orb.ZIndex=20
orb.Parent=MF

local dots={}
for i=1,10 do
local d=Instance.new("Frame")
d.Size=UDim2.new(0,5,0,5)
d.BackgroundColor3=C.A1
d.BorderSizePixel=0
d.ZIndex=21
d.Parent=orb
local dc=Instance.new("UICorner")
dc.CornerRadius=UDim.new(1,0)
dc.Parent=d
local dg=Instance.new("UIStroke")
dg.Color=C.A2
dg.Thickness=3
dg.Transparency=0.5
dg.Parent=d
table.insert(dots,{dot=d,ang=(i-1)*(math.pi*2/10),glow=dg})
end

task.spawn(function()
local cols={C.A1,C.A2,C.A3,C.OK,C.WARN}
while MF.Parent do
for _,it in ipairs(dots) do
local col=cols[math.random(1,#cols)]
TS:Create(it.dot,TweenInfo.new(1.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundColor3=col}):Play()
TS:Create(it.glow,TweenInfo.new(1.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Color=col}):Play()
end
task.wait(1.2)
end end)

RS.RenderStepped:Connect(function(dt)
if not MF.Visible then return end
for _,it in ipairs(dots) do
it.ang=it.ang+dt*1.2
local rx=PW/2+4
local ry=PH/2+4
local x=math.cos(it.ang)*rx
local y=math.sin(it.ang)*ry
it.dot.Position=UDim2.new(0.5,x-2.5,0.5,y-2.5)
end end)

-- ============ HEADER ============
local HD=Instance.new("Frame")
HD.Size=UDim2.new(1,0,0,34)
HD.BackgroundColor3=C.BG2
HD.BackgroundTransparency=0.2
HD.BorderSizePixel=0
HD.ZIndex=15
HD.Parent=MF

local hdc=Instance.new("UICorner")
hdc.CornerRadius=UDim.new(0,14)
hdc.Parent=HD

local hdf=Instance.new("Frame")
hdf.Size=UDim2.new(1,0,0,14)
hdf.Position=UDim2.new(0,0,1,-14)
hdf.BackgroundColor3=C.BG2
hdf.BackgroundTransparency=0.2
hdf.BorderSizePixel=0
hdf.ZIndex=15
hdf.Parent=HD

local SD=Instance.new("Frame")
SD.Size=UDim2.new(0,7,0,7)
SD.Position=UDim2.new(0,12,0.5,-3.5)
SD.BackgroundColor3=C.OK
SD.BorderSizePixel=0
SD.ZIndex=16
SD.Parent=HD

local sdc=Instance.new("UICorner")
sdc.CornerRadius=UDim.new(1,0)
sdc.Parent=SD

local sdg=Instance.new("UIStroke")
sdg.Color=C.OK
sdg.Thickness=3
sdg.Transparency=0.6
sdg.Parent=SD

task.spawn(function()
while SD.Parent do
TS:Create(sdg,TweenInfo.new(1.4,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Thickness=7,Transparency=0.85}):Play()
TS:Create(SD,TweenInfo.new(1.4,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Size=UDim2.new(0,9,0,9),Position=UDim2.new(0,11,0.5,-4.5)}):Play()
task.wait(1.4)
TS:Create(sdg,TweenInfo.new(1.4,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Thickness=3,Transparency=0.6}):Play()
TS:Create(SD,TweenInfo.new(1.4,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Size=UDim2.new(0,7,0,7),Position=UDim2.new(0,12,0.5,-3.5)}):Play()
task.wait(1.4)
end end)

local TitleLbl=Instance.new("TextLabel")
TitleLbl.Size=UDim2.new(0,100,1,0)
TitleLbl.Position=UDim2.new(0,24,0,0)
TitleLbl.BackgroundTransparency=1
TitleLbl.Text="CHECKPOINT"
TitleLbl.TextColor3=C.TXT
TitleLbl.TextSize=13
TitleLbl.TextXAlignment=Enum.TextXAlignment.Left
TitleLbl.Font=Enum.Font.GothamBold
TitleLbl.TextTruncate=Enum.TextTruncate.AtEnd
TitleLbl.ZIndex=16
TitleLbl.Parent=HD

local tg=Instance.new("UIGradient")
tg.Color=ColorSequence.new({
ColorSequenceKeypoint.new(0,C.A1),
ColorSequenceKeypoint.new(0.5,C.A2),
ColorSequenceKeypoint.new(1,C.A1)})
tg.Parent=TitleLbl

task.spawn(function()
while TitleLbl.Parent do
for i=0,360,4 do
tg.Rotation=i
task.wait(0.04)
end end end)

local Z=Instance.new("TextLabel")
Z.Size=UDim2.new(0,90,1,0)
Z.Position=UDim2.new(0,128,0,0)
Z.BackgroundTransparency=1
Z.Text=""
Z.TextColor3=C.WARN
Z.TextSize=11
Z.TextXAlignment=Enum.TextXAlignment.Left
Z.Font=Enum.Font.GothamBold
Z.ZIndex=16
Z.Parent=HD

task.spawn(function()
local s="ZOLEHUB"
task.wait(0.5)
while Z.Parent do
for i=1,#s do
Z.Text="·"..string.sub(s,1,i)
task.wait(0.09)
end
Z.Text="·"..s
task.wait(2)
for i=#s,0,-1 do
Z.Text="·"..string.sub(s,1,i)
task.wait(0.05)
end
task.wait(0.6)
end end)

-- Language flag button
local FlagBtn=Instance.new("TextButton")
FlagBtn.Size=UDim2.new(0,24,0,22)
FlagBtn.Position=UDim2.new(1,-58,0.5,-11)
FlagBtn.BackgroundColor3=C.BG3
FlagBtn.Text="ID"
FlagBtn.TextColor3=C.TXT
FlagBtn.TextSize=10
FlagBtn.Font=Enum.Font.GothamBold
FlagBtn.AutoButtonColor=false
FlagBtn.BorderSizePixel=0
FlagBtn.ZIndex=17
FlagBtn.Parent=HD

local fbc=Instance.new("UICorner")
fbc.CornerRadius=UDim.new(0,5)
fbc.Parent=FlagBtn

local fbs=Instance.new("UIStroke")
fbs.Color=C.A1
fbs.Thickness=1
fbs.Transparency=0.4
fbs.Parent=FlagBtn

local fbg=Instance.new("UIGradient")
fbg.Color=ColorSequence.new({
ColorSequenceKeypoint.new(0,C.A1),
ColorSequenceKeypoint.new(0.5,C.A2),
ColorSequenceKeypoint.new(1,C.A3)})
fbg.Parent=fbs

task.spawn(function()
while FlagBtn.Parent do
for i=0,360,5 do
if not FlagBtn.Parent then break end
fbg.Rotation=i
task.wait(0.05)
end end end)

FlagBtn.MouseEnter:Connect(function()
TS:Create(FlagBtn,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{BackgroundTransparency=-0.3,TextSize=11}):Play()
TS:Create(fbs,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Thickness=1.8,Transparency=0}):Play()
end)
FlagBtn.MouseLeave:Connect(function()
TS:Create(FlagBtn,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{BackgroundTransparency=0,TextSize=10}):Play()
TS:Create(fbs,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Thickness=1,Transparency=0.4}):Play()
end)

local CB=Instance.new("TextButton")
CB.Size=UDim2.new(0,22,0,22)
CB.Position=UDim2.new(1,-30,0.5,-11)
CB.BackgroundColor3=C.BG
CB.BackgroundTransparency=0.5
CB.Text="✕"
CB.TextColor3=C.DIM
CB.TextSize=12
CB.Font=Enum.Font.GothamBold
CB.AutoButtonColor=false
CB.BorderSizePixel=0
CB.ZIndex=17
CB.Parent=HD

local cbc=Instance.new("UICorner")
cbc.CornerRadius=UDim.new(1,0)
cbc.Parent=CB

CB.MouseEnter:Connect(function()
TS:Create(CB,TweenInfo.new(0.35,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{BackgroundColor3=C.BAD,BackgroundTransparency=0.3,TextColor3=C.TXT,Rotation=90}):Play()
end)
CB.MouseLeave:Connect(function()
TS:Create(CB,TweenInfo.new(0.35,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{BackgroundColor3=C.BG,BackgroundTransparency=0.5,TextColor3=C.DIM,Rotation=0}):Play()
end)

-- ============ STATUS (early) ============
local SL=Instance.new("TextLabel")
SL.Size=UDim2.new(1,-16,0,22)
SL.Position=UDim2.new(0,8,0,PH-30)
SL.BackgroundColor3=C.BG2
SL.BackgroundTransparency=0.4
SL.Text="Siap..."
SL.TextColor3=C.DIM
SL.TextSize=10
SL.Font=Enum.Font.Gotham
SL.ZIndex=15
SL.Parent=MF

local slc=Instance.new("UICorner")
slc.CornerRadius=UDim.new(0,6)
slc.Parent=SL

local sls=Instance.new("UIStroke")
sls.Color=C.A1
sls.Thickness=1
sls.Transparency=0.5
sls.Parent=SL

task.spawn(function()
local i=0
local cs={C.A1,C.A2,C.A3}
while SL.Parent do
i=i%#cs+1
TS:Create(sls,TweenInfo.new(2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Color=cs[i]}):Play()
task.wait(2)
end end)

local lastKey="ready"
local lastParams=nil

local function setStat(key,color,param)
lastKey=key
lastParams=param
local txt=L(key)
if param then txt=txt..param end
SL.Text=txt
SL.TextColor3=color or C.DIM
SL.TextTransparency=0.6
TS:Create(SL,TweenInfo.new(0.5,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{TextTransparency=0}):Play()
end

-- ============ PROFILE ============
local LX=8
local LW=190

local ProfCard=Instance.new("Frame")
ProfCard.Size=UDim2.new(0,LW,0,52)
ProfCard.Position=UDim2.new(0,LX,0,40)
ProfCard.BackgroundColor3=C.BG2
ProfCard.BackgroundTransparency=0.5
ProfCard.BorderSizePixel=0
ProfCard.ZIndex=15
ProfCard.Parent=MF

local pcC=Instance.new("UICorner")
pcC.CornerRadius=UDim.new(0,10)
pcC.Parent=ProfCard

local pcS=Instance.new("UIStroke")
pcS.Color=C.A1
pcS.Thickness=1
pcS.Transparency=0.6
pcS.Parent=ProfCard

local pcGrad=Instance.new("UIGradient")
pcGrad.Color=ColorSequence.new({
ColorSequenceKeypoint.new(0,C.A1),
ColorSequenceKeypoint.new(0.5,C.A2),
ColorSequenceKeypoint.new(1,C.A1)})
pcGrad.Parent=pcS

task.spawn(function()
while ProfCard.Parent do
for i=0,360,5 do
if not ProfCard.Parent then break end
pcGrad.Rotation=i
task.wait(0.05)
end end end)

local AvFrame=Instance.new("Frame")
AvFrame.Size=UDim2.new(0,38,0,38)
AvFrame.Position=UDim2.new(0,7,0.5,-19)
AvFrame.BackgroundColor3=C.BG3
AvFrame.BorderSizePixel=0
AvFrame.ZIndex=16
AvFrame.Parent=ProfCard

local avC=Instance.new("UICorner")
avC.CornerRadius=UDim.new(1,0)
avC.Parent=AvFrame

local AvImg=Instance.new("ImageLabel")
AvImg.Size=UDim2.new(1,-4,1,-4)
AvImg.Position=UDim2.new(0,2,0,2)
AvImg.BackgroundTransparency=1
AvImg.Image=""
AvImg.ZIndex=17
AvImg.Parent=AvFrame

local avIC=Instance.new("UICorner")
avIC.CornerRadius=UDim.new(1,0)
avIC.Parent=AvImg

local AvGlow=Instance.new("UIStroke")
AvGlow.Color=C.A1
AvGlow.Thickness=2
AvGlow.Parent=AvFrame

task.spawn(function()
while AvFrame.Parent do
TS:Create(AvGlow,TweenInfo.new(1.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Thickness=3.5}):Play()
task.wait(1.5)
TS:Create(AvGlow,TweenInfo.new(1.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Thickness=2}):Play()
task.wait(1.5)
end end)

local DName=Instance.new("TextLabel")
DName.Size=UDim2.new(1,-56,0,13)
DName.Position=UDim2.new(0,50,0,7)
DName.BackgroundTransparency=1
DName.Text="..."
DName.TextColor3=C.TXT
DName.TextSize=11
DName.TextXAlignment=Enum.TextXAlignment.Left
DName.Font=Enum.Font.GothamBold
DName.TextTruncate=Enum.TextTruncate.AtEnd
DName.ZIndex=16
DName.Parent=ProfCard

local DNameGrad=Instance.new("UIGradient")
DNameGrad.Color=ColorSequence.new(C.A1,C.A2)
DNameGrad.Parent=DName

local UName=Instance.new("TextLabel")
UName.Size=UDim2.new(1,-56,0,11)
UName.Position=UDim2.new(0,50,0,21)
UName.BackgroundTransparency=1
UName.Text="@..."
UName.TextColor3=C.DIM
UName.TextSize=9
UName.TextXAlignment=Enum.TextXAlignment.Left
UName.Font=Enum.Font.Gotham
UName.TextTruncate=Enum.TextTruncate.AtEnd
UName.ZIndex=16
UName.Parent=ProfCard

local GName=Instance.new("TextLabel")
GName.Size=UDim2.new(1,-56,0,11)
GName.Position=UDim2.new(0,50,0,34)
GName.BackgroundTransparency=1
GName.Text="🎮 ..."
GName.TextColor3=C.WARN
GName.TextSize=9
GName.TextXAlignment=Enum.TextXAlignment.Left
GName.Font=Enum.Font.GothamBold
GName.TextTruncate=Enum.TextTruncate.AtEnd
GName.ZIndex=16
GName.Parent=ProfCard

DName.Text=LP.DisplayName or LP.Name
UName.Text="@"..LP.Name
task.spawn(function()
local ok,thumb=pcall(function()
return Players:GetUserThumbnailAsync(LP.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100)
end)
if ok and thumb then AvImg.Image=thumb end
end)
task.spawn(function()
local ok,info=pcall(function()
return MS:GetProductInfo(game.PlaceId)
end)
if ok and info and info.Name then
GName.Text="🎮 "..info.Name
else
GName.Text="🎮 "..game.Name
end
end)

-- ============ BUTTONS ============
local function mkBtn(txt,y,c1,c2,iconTxt)
local b=Instance.new("TextButton")
b.Size=UDim2.new(0,LW,0,26)
b.Position=UDim2.new(0,LX,0,y)
b.BackgroundColor3=c1
b.Text=""
b.AutoButtonColor=false
b.BorderSizePixel=0
b.ZIndex=15
b.Parent=MF

local bc=Instance.new("UICorner")
bc.CornerRadius=UDim.new(0,8)
bc.Parent=b

local gr=Instance.new("UIGradient")
gr.Color=ColorSequence.new({
ColorSequenceKeypoint.new(0,c1),
ColorSequenceKeypoint.new(0.5,c2),
ColorSequenceKeypoint.new(1,c1)})
gr.Parent=b

local st=Instance.new("UIStroke")
st.Color=c2
st.Thickness=1
st.Transparency=0.3
st.Parent=b

local gl=Instance.new("UIStroke")
gl.Color=c2
gl.Thickness=4
gl.Transparency=0.88
gl.Parent=b

local icon=Instance.new("TextLabel")
icon.Size=UDim2.new(0,22,1,0)
icon.Position=UDim2.new(0,5,0,0)
icon.BackgroundTransparency=1
icon.Text=iconTxt
icon.TextColor3=C.TXT
icon.TextSize=13
icon.Font=Enum.Font.GothamBold
icon.ZIndex=17
icon.Parent=b

local lb=Instance.new("TextLabel")
lb.Size=UDim2.new(1,-30,1,0)
lb.Position=UDim2.new(0,27,0,0)
lb.BackgroundTransparency=1
lb.Text=txt
lb.TextColor3=C.TXT
lb.TextSize=10
lb.TextXAlignment=Enum.TextXAlignment.Left
lb.Font=Enum.Font.GothamBold
lb.TextTruncate=Enum.TextTruncate.AtEnd
lb.ZIndex=17
lb.Parent=b

return {btn=b,gr=gr,st=st,gl=gl,icon=icon,lb=lb,c1=c1,c2=c2,baseY=y}
end

local SB=mkBtn("",96,Color3.fromRGB(28,80,50),C.OK,"💾")
local GB=mkBtn("",126,Color3.fromRGB(30,60,110),C.A1,"🚀")
local AB=mkBtn("",156,Color3.fromRGB(60,40,100),C.A2,"🔁")

for _,it in ipairs({SB,GB,AB}) do
task.spawn(function()
while it.btn.Parent do
for i=0,360,3 do
if not it.btn.Parent then break end
it.gr.Rotation=i
task.wait(0.04)
end end end)
end

local function bindHover(it)
local by=it.baseY
it.btn.MouseEnter:Connect(function()
TS:Create(it.btn,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Size=UDim2.new(0,LW+4,0,28),Position=UDim2.new(0,LX-2,0,by-1)}):Play()
TS:Create(it.st,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Transparency=0,Thickness=1.5}):Play()
end)
it.btn.MouseLeave:Connect(function()
TS:Create(it.btn,TweenInfo.new(0.35,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Size=UDim2.new(0,LW,0,26),Position=UDim2.new(0,LX,0,by)}):Play()
TS:Create(it.st,TweenInfo.new(0.35,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Transparency=0.3,Thickness=1}):Play()
end)
it.btn.MouseButton1Down:Connect(function()
TS:Create(it.btn,TweenInfo.new(0.15,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Size=UDim2.new(0,LW-4,0,24),Position=UDim2.new(0,LX+2,0,by+1)}):Play()
end)
it.btn.MouseButton1Up:Connect(function()
TS:Create(it.btn,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Size=UDim2.new(0,LW+4,0,28),Position=UDim2.new(0,LX-2,0,by-1)}):Play()
end)
end
bindHover(SB) bindHover(GB) bindHover(AB)

-- ============ PLAYER LIST ============
local RX=206
local RW=266

local PLabel=Instance.new("TextLabel")
PLabel.Size=UDim2.new(0,RW-60,0,12)
PLabel.Position=UDim2.new(0,RX,0,40)
PLabel.BackgroundTransparency=1
PLabel.Text=""
PLabel.TextColor3=C.TXT
PLabel.TextSize=10
PLabel.TextXAlignment=Enum.TextXAlignment.Left
PLabel.Font=Enum.Font.GothamBold
PLabel.TextTruncate=Enum.TextTruncate.AtEnd
PLabel.ZIndex=15
PLabel.Parent=MF

local PLabelGrad=Instance.new("UIGradient")
PLabelGrad.Color=ColorSequence.new({
ColorSequenceKeypoint.new(0,C.A1),
ColorSequenceKeypoint.new(0.5,C.A2),
ColorSequenceKeypoint.new(1,C.A3)})
PLabelGrad.Parent=PLabel

task.spawn(function()
while PLabel.Parent do
for i=0,360,5 do
if not PLabel.Parent then break end
PLabelGrad.Rotation=i
task.wait(0.05)
end end end)

local CountLbl=Instance.new("TextLabel")
CountLbl.Size=UDim2.new(0,50,0,12)
CountLbl.Position=UDim2.new(0,RX+RW-50,0,40)
CountLbl.BackgroundTransparency=1
CountLbl.Text="0/0"
CountLbl.TextColor3=C.DIM
CountLbl.TextSize=10
CountLbl.TextXAlignment=Enum.TextXAlignment.Right
CountLbl.Font=Enum.Font.GothamBold
CountLbl.ZIndex=15
CountLbl.Parent=MF

local Scroll=Instance.new("ScrollingFrame")
Scroll.Size=UDim2.new(0,RW,0,126)
Scroll.Position=UDim2.new(0,RX,0,56)
Scroll.BackgroundColor3=C.BG2
Scroll.BackgroundTransparency=0.5
Scroll.BorderSizePixel=0
Scroll.ScrollBarThickness=3
Scroll.ScrollBarImageColor3=C.A1
Scroll.CanvasSize=UDim2.new(0,0,0,0)
Scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
Scroll.ZIndex=15
Scroll.Parent=MF

local scrollC=Instance.new("UICorner")
scrollC.CornerRadius=UDim.new(0,8)
scrollC.Parent=Scroll

local scrollS=Instance.new("UIStroke")
scrollS.Color=C.A1
scrollS.Thickness=1
scrollS.Transparency=0.6
scrollS.Parent=Scroll

local listLay=Instance.new("UIListLayout")
listLay.SortOrder=Enum.SortOrder.LayoutOrder
listLay.Padding=UDim.new(0,2)
listLay.Parent=Scroll

local listPad=Instance.new("UIPadding")
listPad.PaddingTop=UDim.new(0,4)
listPad.PaddingBottom=UDim.new(0,4)
listPad.PaddingLeft=UDim.new(0,4)
listPad.PaddingRight=UDim.new(0,4)
listPad.Parent=Scroll

local function tpToPlayer(target)
if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return false end
if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return false end
local myPos=LP.Character.HumanoidRootPart
local tgt=target.Character.HumanoidRootPart
myPos.CFrame=CFrame.new(tgt.Position+Vector3.new(0,0,4),tgt.Position)
return true
end

local function makePlayerRow(plr)
local row=Instance.new("TextButton")
row.Size=UDim2.new(1,-8,0,24)
row.BackgroundColor3=C.BG3
row.BackgroundTransparency=0.4
row.Text=""
row.AutoButtonColor=false
row.BorderSizePixel=0
row.ZIndex=16
row.Parent=Scroll

local rc=Instance.new("UICorner")
rc.CornerRadius=UDim.new(0,5)
rc.Parent=row

local rs=Instance.new("UIStroke")
rs.Color=C.A1
rs.Thickness=1
rs.Transparency=0.7
rs.Parent=row

local icon=Instance.new("TextLabel")
icon.Size=UDim2.new(0,14,1,0)
icon.Position=UDim2.new(0,3,0,0)
icon.BackgroundTransparency=1
icon.Text="▸"
icon.TextColor3=C.A1
icon.TextSize=11
icon.Font=Enum.Font.GothamBold
icon.ZIndex=17
icon.Parent=row

local nm=Instance.new("TextLabel")
nm.Size=UDim2.new(1,-56,1,0)
nm.Position=UDim2.new(0,18,0,0)
nm.BackgroundTransparency=1
nm.Text=plr.DisplayName or plr.Name
nm.TextColor3=C.TXT
nm.TextSize=10
nm.TextXAlignment=Enum.TextXAlignment.Left
nm.Font=Enum.Font.Gotham
nm.TextTruncate=Enum.TextTruncate.AtEnd
nm.ZIndex=17
nm.Parent=row

local status=Instance.new("TextLabel")
status.Size=UDim2.new(0,36,1,0)
status.Position=UDim2.new(1,-38,0,0)
status.BackgroundTransparency=1
status.Text="●"
status.TextColor3=C.OK
status.TextSize=10
status.Font=Enum.Font.GothamBold
status.ZIndex=17
status.Parent=row

if plr==LP then
icon.Text="★"
icon.TextColor3=C.WARN
nm.TextColor3=C.WARN
status.Text=L("you")
status.TextColor3=C.WARN
status.TextSize=8
else
task.spawn(function()
while status.Parent and plr.Parent do
local hasChar=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
pcall(function()
TS:Create(status,TweenInfo.new(0.5),{TextColor3=hasChar and C.OK or C.BAD}):Play()
end)
task.wait(0.5)
end end)
end

row.MouseEnter:Connect(function()
if plr==LP then return end
TS:Create(row,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{BackgroundTransparency=0.1}):Play()
TS:Create(rs,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Transparency=0,Thickness=1.5,Color=C.A2}):Play()
end)

row.MouseLeave:Connect(function()
TS:Create(row,TweenInfo.new(0.35,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{BackgroundTransparency=0.4}):Play()
TS:Create(rs,TweenInfo.new(0.35,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Transparency=0.7,Thickness=1,Color=C.A1}):Play()
end)

row.MouseButton1Down:Connect(function()
TS:Create(row,TweenInfo.new(0.15,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{BackgroundColor3=C.A1}):Play()
end)

row.MouseButton1Up:Connect(function()
TS:Create(row,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{BackgroundColor3=C.BG3}):Play()
end)

if plr==LP then
row.MouseButton1Click:Connect(function()
setStat("self_msg",C.DIM)
end)
else
row.MouseButton1Click:Connect(function()
if tpToPlayer(plr) then
setStat("tp_to",C.OK,plr.DisplayName or plr.Name)
else
setStat("target_bad",C.BAD)
end
end)
end
end

local refreshList
refreshList=function()
for _,ch in ipairs(Scroll:GetChildren()) do
if ch:IsA("TextButton") then ch:Destroy() end
end
local plrs=Players:GetPlayers()
for _,p in ipairs(plrs) do
makePlayerRow(p)
end
CountLbl.Text=#plrs.."/"..#plrs
end

refreshList()
Players.PlayerAdded:Connect(function() task.wait(0.2) refreshList() end)
Players.PlayerRemoving:Connect(function() task.wait(0.2) refreshList() end)

-- ============ DAY / NIGHT ============
local DN=Instance.new("Frame")
DN.Size=UDim2.new(0,464,0,52)
DN.Position=UDim2.new(0,8,0,190)
DN.BackgroundColor3=C.BG2
DN.BackgroundTransparency=0.5
DN.BorderSizePixel=0
DN.ZIndex=15
DN.Parent=MF

local dnc=Instance.new("UICorner")
dnc.CornerRadius=UDim.new(0,10)
dnc.Parent=DN

local dns=Instance.new("UIStroke")
dns.Color=C.WARN
dns.Thickness=1
dns.Transparency=0.5
dns.Parent=DN

local dnsg=Instance.new("UIGradient")
dnsg.Color=ColorSequence.new({
ColorSequenceKeypoint.new(0,C.WARN),
ColorSequenceKeypoint.new(0.33,C.A3),
ColorSequenceKeypoint.new(0.66,C.A2),
ColorSequenceKeypoint.new(1,C.A1)})
dnsg.Parent=dns

task.spawn(function()
while DN.Parent do
for i=0,360,4 do
if not DN.Parent then break end
dnsg.Rotation=i
task.wait(0.05)
end end end)

local DNLabel=Instance.new("TextLabel")
DNLabel.Size=UDim2.new(0,120,0,14)
DNLabel.Position=UDim2.new(0,6,0,4)
DNLabel.BackgroundTransparency=1
DNLabel.Text=""
DNLabel.TextColor3=C.TXT
DNLabel.TextSize=10
DNLabel.TextXAlignment=Enum.TextXAlignment.Left
DNLabel.Font=Enum.Font.GothamBold
DNLabel.ZIndex=17
DNLabel.Parent=DN

local TimeLbl=Instance.new("TextLabel")
TimeLbl.Size=UDim2.new(0,60,0,14)
TimeLbl.Position=UDim2.new(0,120,0,4)
TimeLbl.BackgroundTransparency=1
TimeLbl.Text="12:00"
TimeLbl.TextColor3=C.WARN
TimeLbl.TextSize=11
TimeLbl.TextXAlignment=Enum.TextXAlignment.Left
TimeLbl.Font=Enum.Font.GothamBold
TimeLbl.ZIndex=17
TimeLbl.Parent=DN

local LockBtn=Instance.new("TextButton")
LockBtn.Size=UDim2.new(0,110,0,16)
LockBtn.Position=UDim2.new(0,350,0,3)
LockBtn.BackgroundColor3=C.BG3
LockBtn.Text=""
LockBtn.TextColor3=C.DIM
LockBtn.TextSize=9
LockBtn.Font=Enum.Font.GothamBold
LockBtn.AutoButtonColor=false
LockBtn.BorderSizePixel=0
LockBtn.ZIndex=17
LockBtn.Parent=DN

local lbc=Instance.new("UICorner")
lbc.CornerRadius=UDim.new(0,5)
lbc.Parent=LockBtn

local lbs=Instance.new("UIStroke")
lbs.Color=C.A1
lbs.Thickness=1
lbs.Transparency=0.5
lbs.Parent=LockBtn

LockBtn.MouseEnter:Connect(function()
TS:Create(LockBtn,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{BackgroundTransparency=-0.2,TextSize=10}):Play()
end)
LockBtn.MouseLeave:Connect(function()
TS:Create(LockBtn,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{BackgroundTransparency=0,TextSize=9}):Play()
end)

local function mkDNBtn(x,iconT)
local b=Instance.new("TextButton")
b.Size=UDim2.new(0,52,0,24)
b.Position=UDim2.new(0,x,0,24)
b.BackgroundColor3=C.BG3
b.Text=""
b.AutoButtonColor=false
b.BorderSizePixel=0
b.ZIndex=17
b.Parent=DN

local bc=Instance.new("UICorner")
bc.CornerRadius=UDim.new(0,5)
bc.Parent=b

local st=Instance.new("UIStroke")
st.Color=C.A1
st.Thickness=1
st.Transparency=0.5
st.Parent=b

local icon=Instance.new("TextLabel")
icon.Size=UDim2.new(0,18,1,0)
icon.Position=UDim2.new(0,3,0,0)
icon.BackgroundTransparency=1
icon.Text=iconT
icon.TextColor3=C.TXT
icon.TextSize=11
icon.Font=Enum.Font.GothamBold
icon.ZIndex=18
icon.Parent=b

local lb=Instance.new("TextLabel")
lb.Size=UDim2.new(1,-22,1,0)
lb.Position=UDim2.new(0,20,0,0)
lb.BackgroundTransparency=1
lb.Text=""
lb.TextColor3=C.TXT
lb.TextSize=8
lb.TextXAlignment=Enum.TextXAlignment.Left
lb.Font=Enum.Font.GothamBold
lb.TextTruncate=Enum.TextTruncate.AtEnd
lb.ZIndex=18
lb.Parent=b

b.MouseEnter:Connect(function()
TS:Create(b,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{BackgroundTransparency=-0.2}):Play()
TS:Create(st,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Transparency=0,Color=C.WARN}):Play()
end)
b.MouseLeave:Connect(function()
TS:Create(b,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{BackgroundTransparency=0}):Play()
TS:Create(st,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Transparency=0.5,Color=C.A1}):Play()
end)

return {btn=b,lb=lb}
end

local PBtn=mkDNBtn(4,"🌅")
local SBtn=mkDNBtn(60,"☀️")
local SoBtn=mkDNBtn(116,"🌇")
local MBtn=mkDNBtn(172,"🌙")

local SliderBar=Instance.new("TextButton")
SliderBar.Size=UDim2.new(0,234,0,14)
SliderBar.Position=UDim2.new(0,228,0,29)
SliderBar.BackgroundColor3=C.BG3
SliderBar.Text=""
SliderBar.AutoButtonColor=false
SliderBar.BorderSizePixel=0
SliderBar.ZIndex=17
SliderBar.Parent=DN

local sbc=Instance.new("UICorner")
sbc.CornerRadius=UDim.new(1,0)
sbc.Parent=SliderBar

local sbs=Instance.new("UIStroke")
sbs.Color=C.A1
sbs.Thickness=1
sbs.Transparency=0.5
sbs.Parent=SliderBar

local SliderFill=Instance.new("Frame")
SliderFill.Size=UDim2.new(0.5,0,1,0)
SliderFill.BackgroundColor3=C.A1
SliderFill.BorderSizePixel=0
SliderFill.ZIndex=18
SliderFill.Parent=SliderBar

local sfc=Instance.new("UICorner")
sfc.CornerRadius=UDim.new(1,0)
sfc.Parent=SliderFill

local sfg=Instance.new("UIGradient")
sfg.Color=ColorSequence.new({
ColorSequenceKeypoint.new(0,C.A1),
ColorSequenceKeypoint.new(0.5,C.A2),
ColorSequenceKeypoint.new(1,C.A3)})
sfg.Parent=SliderFill

task.spawn(function()
while SliderFill.Parent do
for i=0,360,5 do
if not SliderFill.Parent then break end
sfg.Rotation=i
task.wait(0.05)
end end end)

local SliderHandle=Instance.new("Frame")
SliderHandle.Size=UDim2.new(0,12,0,12)
SliderHandle.Position=UDim2.new(0.5,-6,0.5,-6)
SliderHandle.BackgroundColor3=C.TXT
SliderHandle.BorderSizePixel=0
SliderHandle.ZIndex=19
SliderHandle.Parent=SliderBar

local shc=Instance.new("UICorner")
shc.CornerRadius=UDim.new(1,0)
shc.Parent=SliderHandle

local shg=Instance.new("UIStroke")
shg.Color=C.WARN
shg.Thickness=2
shg.Parent=SliderHandle

task.spawn(function()
while SliderHandle.Parent do
TS:Create(shg,TweenInfo.new(1.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Thickness=4,Color=C.A3}):Play()
task.wait(1.2)
TS:Create(shg,TweenInfo.new(1.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Thickness=2,Color=C.WARN}):Play()
task.wait(1.2)
end end)

local function fmtTime(t)
local h=math.floor(t)%24
local m=math.floor((t%1)*60)
return string.format("%02d:%02d",h,m)
end

local function applyTime(t)
t=math.clamp(t,0,24)
if t>=24 then t=0 end
pcall(function()
LG.ClockTime=t
LG.TimeOfDay=string.format("%02d:%02d:00",math.floor(t)%24,math.floor((t%1)*60))
end)
if lockedDN then lockedTime=t end
TimeLbl.Text=fmtTime(t)
local rel=t/24
SliderFill.Size=UDim2.new(rel,0,1,0)
SliderHandle.Position=UDim2.new(rel,-6,0.5,-6)
end

local function updateSliderUI(t)
TimeLbl.Text=fmtTime(t)
local rel=t/24
SliderFill.Size=UDim2.new(rel,0,1,0)
SliderHandle.Position=UDim2.new(rel,-6,0.5,-6)
end

local function setFromX(x)
local rel=(x-SliderBar.AbsolutePosition.X)/SliderBar.AbsoluteSize.X
rel=math.clamp(rel,0,1)
applyTime(rel*24)
end

SliderBar.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
draggingSlider=true
setFromX(i.Position.X)
end end)

UIS.InputChanged:Connect(function(i)
if draggingSlider and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
setFromX(i.Position.X)
end end)

UIS.InputEnded:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
draggingSlider=false
end end)

PBtn.btn.MouseButton1Click:Connect(function() applyTime(6) setStat("m_am",C.WARN) end)
SBtn.btn.MouseButton1Click:Connect(function() applyTime(12) setStat("m_no",C.WARN) end)
SoBtn.btn.MouseButton1Click:Connect(function() applyTime(18) setStat("m_ev",C.A3) end)
MBtn.btn.MouseButton1Click:Connect(function() applyTime(0) setStat("m_ni",C.A2) end)

LockBtn.MouseButton1Click:Connect(function()
lockedDN=not lockedDN
if lockedDN then
lockedTime=LG.ClockTime
LockBtn.TextColor3=C.OK
lbs.Color=C.OK
setStat("lock_on_msg",C.OK)
else
LockBtn.TextColor3=C.DIM
lbs.Color=C.A1
setStat("lock_off_msg",C.WARN)
end
LockBtn.Text=L(lockedDN and "lock_on" or "lock_off")
end)

task.spawn(function()
while true do
if lockedDN then
pcall(function()
LG.ClockTime=lockedTime
LG.TimeOfDay=string.format("%02d:%02d:00",math.floor(lockedTime)%24,math.floor((lockedTime%1)*60))
end)
end
task.wait(0.15)
end end)

task.spawn(function()
while true do
if not draggingSlider and not lockedDN then
local t=0
pcall(function() t=LG.ClockTime end)
updateSliderUI(t)
end
task.wait(0.4)
end end)

-- ============ FOOTER ============
local F=Instance.new("TextLabel")
F.Size=UDim2.new(1,0,0,10)
F.Position=UDim2.new(0,0,0,PH-10)
F.BackgroundTransparency=1
F.Text=""
F.TextColor3=C.DIM
F.TextSize=9
F.Font=Enum.Font.GothamBold
F.ZIndex=15
F.Parent=MF

task.spawn(function()
local s="◆  BY ZOLEHUB  ◆"
task.wait(1)
while F.Parent do
for i=1,#s do
F.Text=string.sub(s,1,i)
task.wait(0.06)
end
task.wait(1.8)
local tw=TS:Create(F,TweenInfo.new(0.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{TextTransparency=0.7})
tw:Play() tw.Completed:Wait()
TS:Create(F,TweenInfo.new(0.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{TextTransparency=0}):Play()
task.wait(0.5)
for i=#s,0,-1 do
F.Text=string.sub(s,1,i)
task.wait(0.03)
end
task.wait(0.6)
end end)

-- ============================================================
-- APPLY LANGUAGE
-- ============================================================
local function applyLang()
TitleLbl.Text=L("title")
PLabel.Text=L("players")
DNLabel.Text=L("time")
SB.lb.Text=L("save_cp")
GB.lb.Text=L("go_cp")
AB.lb.Text=L(_G.AutoRespawnEnabled and "auto_on" or "auto_off")
AB.lb.TextColor3=_G.AutoRespawnEnabled and C.TXT or C.BAD
LockBtn.Text=L(lockedDN and "lock_on" or "lock_off")
PBtn.lb.Text=L("morning")
SBtn.lb.Text=L("noon")
SoBtn.lb.Text=L("evening")
MBtn.lb.Text=L("night")
FlagBtn.Text=LangOrder[LangIdx]
local txt=L(lastKey)
if lastParams then txt=txt..lastParams end
SL.Text=txt
refreshList()
end

FlagBtn.MouseButton1Click:Connect(function()
LangIdx=LangIdx%#LangOrder+1
applyLang()
setStat("lang_switched",C.A1,TR[LangOrder[LangIdx]].name)
end)

-- ============ OPEN / CLOSE ============
local savedPos=UDim2.new(0,20,0,80)
local isOpen=false

local function getToggleCenter()
local tp=TB.Position
return tp.X.Offset+25,tp.Y.Offset+25
end

local function openP()
if isOpen then return end
isOpen=true
MF.Visible=true
local cx,cy=getToggleCenter()
local sS=28
MF.Size=UDim2.new(0,sS,0,sS)
MF.Position=UDim2.new(0,cx-sS/2,0,cy-sS/2)
MF.BackgroundTransparency=1

TS:Create(MF,TweenInfo.new(0.7,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
Size=UDim2.new(0,PW,0,PH),
Position=savedPos,
BackgroundTransparency=0}):Play()

TS:Create(ms,TweenInfo.new(0.7,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Transparency=0.2}):Play()
TS:Create(mgl,TweenInfo.new(0.85,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Transparency=0.88}):Play()
TS:Create(TL,TweenInfo.new(0.7,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Rotation=180}):Play()

ProfCard.Position=UDim2.new(0,LX,0,80)
TS:Create(ProfCard,TweenInfo.new(0.55,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Position=UDim2.new(0,LX,0,40)}):Play()

DN.Position=UDim2.new(0,8,0,240)
TS:Create(DN,TweenInfo.new(0.55,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Position=UDim2.new(0,8,0,190)}):Play()

for i,it in ipairs({SB,GB,AB}) do
local op=UDim2.new(0,LX,0,it.baseY)
it.btn.Position=UDim2.new(0,-120,0,it.baseY)
it.icon.TextTransparency=1
it.lb.TextTransparency=1
task.delay(0.3+(i-1)*0.08,function()
TS:Create(it.btn,TweenInfo.new(0.5,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Position=op}):Play()
TS:Create(it.icon,TweenInfo.new(0.45,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{TextTransparency=0}):Play()
TS:Create(it.lb,TweenInfo.new(0.45,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{TextTransparency=0}):Play()
end)
end

TitleLbl.TextTransparency=1
task.delay(0.3,function() TS:Create(TitleLbl,TweenInfo.new(0.6),{TextTransparency=0}):Play() end)
SL.TextTransparency=1
task.delay(0.35,function() TS:Create(SL,TweenInfo.new(0.6),{TextTransparency=0}):Play() end)
F.TextTransparency=1
task.delay(0.35,function() TS:Create(F,TweenInfo.new(0.6),{TextTransparency=0}):Play() end)
PLabel.TextTransparency=1
task.delay(0.3,function() TS:Create(PLabel,TweenInfo.new(0.6),{TextTransparency=0}):Play() end)
end

local function closeP()
if not isOpen then return end
isOpen=false
savedPos=MF.Position

for i,it in ipairs({SB,GB,AB}) do
local op=it.btn.Position
task.delay((3-i)*0.05,function()
TS:Create(it.btn,TweenInfo.new(0.35,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{Position=UDim2.new(0,-120,0,op.Y.Offset)}):Play()
TS:Create(it.icon,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{TextTransparency=1}):Play()
TS:Create(it.lb,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{TextTransparency=1}):Play()
end)
end

TS:Create(TitleLbl,TweenInfo.new(0.3),{TextTransparency=1}):Play()
TS:Create(SL,TweenInfo.new(0.3),{TextTransparency=1}):Play()
TS:Create(F,TweenInfo.new(0.3),{TextTransparency=1}):Play()
TS:Create(PLabel,TweenInfo.new(0.3),{TextTransparency=1}):Play()
TS:Create(ProfCard,TweenInfo.new(0.35,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{Position=UDim2.new(0,LX,0,80)}):Play()
TS:Create(DN,TweenInfo.new(0.35,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{Position=UDim2.new(0,8,0,240)}):Play()
TS:Create(TL,TweenInfo.new(0.6,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Rotation=0}):Play()

task.wait(0.25)
local cx,cy=getToggleCenter()
local sS=28
TS:Create(MF,TweenInfo.new(0.55,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{
Size=UDim2.new(0,sS,0,sS),
Position=UDim2.new(0,cx-sS/2,0,cy-sS/2),
BackgroundTransparency=1}):Play()
TS:Create(ms,TweenInfo.new(0.55,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Transparency=1}):Play()
TS:Create(mgl,TweenInfo.new(0.55,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Transparency=1}):Play()

task.wait(0.6)
if not isOpen then
MF.Visible=false
MF.Size=UDim2.new(0,PW,0,PH)
MF.Position=savedPos
MF.BackgroundTransparency=0
ms.Transparency=0.2
mgl.Transparency=0.88
end
end

TB.MouseButton1Click:Connect(function()
if tMoved then return end
if isOpen then closeP() else openP() end
end)
CB.MouseButton1Click:Connect(closeP)

-- ============ ACTIONS ============
SB.btn.MouseButton1Click:Connect(function()
if saveCP() then
setStat("saved",C.OK)
SB.lb.Text=L("saved_short")
SB.lb.TextColor3=C.OK
SB.icon.Text="✓"
task.wait(1.4)
SB.lb.Text=L("save_cp")
SB.lb.TextColor3=C.TXT
SB.icon.Text="💾"
else
setStat("save_fail",C.BAD)
end end)

GB.btn.MouseButton1Click:Connect(function()
if goCP() then
setStat("tp_ok",C.A1)
GB.lb.Text=L("success_short")
GB.icon.Text="✓"
task.wait(1.4)
GB.lb.Text=L("go_cp")
GB.icon.Text="🚀"
else
setStat("no_cp",C.BAD)
end end)

AB.btn.MouseButton1Click:Connect(function()
_G.AutoRespawnEnabled=not _G.AutoRespawnEnabled
if _G.AutoRespawnEnabled then
AB.lb.Text=L("auto_on")
AB.lb.TextColor3=C.TXT
AB.st.Color=C.A2
setStat("auto_on_msg",C.OK)
else
AB.lb.Text=L("auto_off")
AB.lb.TextColor3=C.BAD
AB.st.Color=C.BAD
setStat("auto_off_msg",C.BAD)
end end)

-- ============ HOTKEYS ============
UIS.InputBegan:Connect(function(i,p)
if p then return end
if i.KeyCode==Enum.KeyCode.K then
if saveCP() then setStat("saved",C.OK) end
elseif i.KeyCode==Enum.KeyCode.L then
if goCP() then setStat("tp_ok",C.A1) end
elseif i.KeyCode==Enum.KeyCode.P then
if isOpen then closeP() else openP() end
end end)

-- ============ DRAG ============
local d,ds,sp
HD.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
d=true ds=i.Position sp=MF.Position end end)

UIS.InputChanged:Connect(function(i)
if d and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
local dl=i.Position-ds
MF.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dl.X,sp.Y.Scale,sp.Y.Offset+dl.Y)
savedPos=MF.Position end end)

UIS.InputEnded:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
d=false end end)

-- ============ INIT ============
task.wait(0.1)
local initT=12
pcall(function() initT=LG.ClockTime end)
updateSliderUI(initT)

task.wait(0.2)
applyLang()
setStat("ready",C.DIM)
openP()