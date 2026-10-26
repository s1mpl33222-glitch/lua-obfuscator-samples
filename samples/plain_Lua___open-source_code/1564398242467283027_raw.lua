--by discord.gg/32e4 hes goated lollllllll
local function geniter(f, s, c)
if type(f) ~= "function" then
local mt = getmetatable(f)
if type(mt) == "table" and mt.__iter then
f, s, c = mt.__iter(f)
elseif type(f) == "table" then
f, s, c = next, f, nil
end
end
return function()
local r = table.pack(f(s, c))
if r[1] == nil then
return false
end
c = r[1]
return true, table.unpack(r, 1, r.n)
end
end
repeat
task.wait()
until game:IsLoaded()
local n1, n2, n4 = 104592110, 557240548, 616969873
local v194, v195, now2, v197, v198, v199, v200, v201, u202, u203
local u204, u205, u206, u207, u208, u209, u210, u211, u212, u213
local u214, u215, Players, RunService, UserInputService, HttpService, LocalPlayer, t15, v222, color3
local uDim2New, v225, v226, v227, v228, v229, v230, v231, v232, v233
local v234, v235, v236, v237, v238, v239, v240, v241, v242, v243
local v244, v245, v246, v247, v248, v249, v250, v251, v252, v253
local v254, v255, v256, u257, u258, u259, u260, u261, u262, u263
local u264, u265, u266
local function runApplication()
local function v7345()
local n677 = 429390507
local u7347 = false
local n678 = 1061454987
pcall(function()
if type(readfile) == "function" then
local data
if type(isfile) == "function" then
if isfile("sxe_ui_config.json") then
data = game:GetService("HttpService"):JSONDecode(readfile("sxe_ui_config.json"))
local v7350 = type(data) == "table" and data.Optimizer == true
u7347 = v7350
end
else
data = game:GetService("HttpService"):JSONDecode(readfile("sxe_ui_config.json"))
u7347 = type(data) == "table" and data.Optimizer == true
end
end
end)
if not u7347 or rawget(_G, "__SXE_KillQ") ~= nil then
return
end
_G.__SXE_OptiOn = true
_G.__SXE_KillQ = {}
local n679
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t276 = {
CustomProximityPromptController = true,
InteractController = true,
PlotController = true,
AnimalController = true,
PetController = true,
WorldBrainrotController = true,
EquipBrainrotsController = true,
EquipBrainrotsRenderController = true,
SelectBrainrotsController = true,
BrainrotPreloadingController = true,
AssetStreamController = true,
AdminPanelController = true,
NotificationController = true,
}
local t277 = {}
local Controllers
local function v7356(child)
if t277 ~= nil then
if typeof(child) == "Instance" then
if not t276[child.Name] and child.Parent == Controllers then
t277[#t277 + 1] = child
if not pcall(function()
child.Parent = nil
end) then
task.defer(function()
local n680 = 342819689
if t277 ~= nil then
if child.Parent == Controllers then
pcall(function()
child.Parent = nil
if n2 == n680 then
n677 += 1695
n1 = 455508504
n2 -= 2007
n678 = 908520807
n680 -= 1937
end
end)
end
end
end)
end
return
end
end
end
end
local connection
if n1 == n2 then
n677 += 921
n4 -= 1091
n678 -= 331
n1 += 809
n2 = 548336725
bit32.bxor(nil, nil)
return nil
end
task.spawn(function(...)
Controllers = ReplicatedStorage:WaitForChild("Controllers", 30)
if not Controllers or t277 == nil then
return
end
connection = Controllers.ChildAdded:Connect(v7356)
local children = Controllers:GetChildren()
local n681 = 1051418735
for i = 1, #children do
v7356(children[i])
end
if not (n1 < n681) then
n1 += 208
n677 -= 1217
n678 = 988851267
n4 += 1488
n2 -= 1301
(403 + (select("#", ...) - 0 - 1))[(select("#", ...) - 0 - 1)[select("#", ...) + 0 + 0]]()
end
end)
task.delay(6, function()
local v7362
n679 = 756316387
local v7363 = t277
local n682 = 92106050
t277 = nil
local u7365
if connection then
u7365 = connection
connection.Disconnect(u7365)
end
local u7366, v7367
if n679 == 756316387 then
if not Controllers then
return
end
u7366 = nil
u7365 = nil
else
n677 = 211927793
n4 -= 1353
u7366 = n1 + 297
n1 = u7366
n2 = 988293264
n679 = 95977660
n682 -= 1731
n678 = 243695131
v7362[2] = 42
v7367 = v7363[t8]
pcall(function()
u7366 = 801644196
u7365 = 564969499
if v7367.Parent == nil then
v7367.Parent = Controllers
end
end)
end
for i = 1, #v7363 do
v7367 = v7363[i]
pcall(function()
u7366 = 801644196
u7365 = 564969499
if v7367.Parent == nil then
v7367.Parent = Controllers
end
end)
end
end)
local n683
task.spawn(function()
local n684 = 742151336
n683 = 455574234
local n685 = 413312565
local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
local n686 = 533320541
local t278 = {
RNGMachineVFX = true,
LuckIcons = true,
GlossaryBackground = true,
AnimationGraphEditor = true,
ML = true,
PlayWaveEvents = true,
}
local function v7375(p1011)
local n687 = 101342915
if not p1011 then
return
end
if n1 == 104592110 then
pcall(function()
p1011:Destroy()
if n685 == 413314601 then
n685 -= 515
n684 -= 647
n687 -= 1941
n2 += 1359
bit32.band(nil, nil)
bit32.rshift(nil, nil)
end
end)
else
n1 += 566
n683 += 272
n685 -= 267
n2 -= 501
n684 -= 582
n686 = 584719346
end
end
local function v7377(child)
if child then
if t278[child.Name] then
v7375(child)
end
end
if n686 == n4 then
n2 -= 1994
n678 -= 1563
n4 = 185400159
n684 += 1875
n686 = 331913889
n685 = 852196101
local v7378 = (nil)(nil);
(nil)(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
v7378,
}, 1, 376))
n684[nil] = nil
end
end
local children = ReplicatedStorage2:GetChildren()
for i = 1, #children do
v7377(children[i])
end
ReplicatedStorage2.ChildAdded:Connect(v7377)
end)
local n688
local function v7382()
n688 = 680654124
if n677 ~= 429390888 then
return _G.__SXE_VelFlying == true
end
n688 += 1751
n678 = 870809312
n677 -= 1160
n4 = 616776357
n2 -= 921
n1 = 217251583
end
_G.SXE_Kill = function(p1012)
if not p1012 then
return
end
if not v7382() then
pcall(function()
p1012:Destroy()
end)
return
end
_G.__SXE_KillQ[#_G.__SXE_KillQ + 1] = p1012
end
_G.SXE_FlushKills = function()
_G.__SXE_KillQ = {}
for i = 1, #_G.__SXE_KillQ do
local v7384 = _G.__SXE_KillQ[i]
if v7384 and v7384.Parent then
pcall(function()
v7384:Destroy()
end)
end
end
end
local function v7385()
local n689 = 207698086
local Players2 = game:GetService("Players")
local n690 = 797251569
local Lighting = game:GetService("Lighting")
local LocalPlayer2 = Players2.LocalPlayer
local n691 = 1006355248
local function v7392(p1013)
_G.SXE_Kill(p1013)
end
pcall(function()
workspace.Terrain.Decoration = false
end)
local t279 = {
FriendPanel = true,
Cash = true,
Unlock = true,
Purchases = true,
PlotSign = true,
CashPad = true,
InvisibleWalls = true,
Multiplier = true,
Slope = true,
IncubatorMachine = true,
FuseMachine = true,
RobuxShop = true,
AdminBoard = true,
SoccerScoreBoard = true,
CrystalSpinWheel = true,
Beehive = true,
CraftingMachine = true,
Shop = true,
Road = true,
EventBoard = true,
TradePlazaPortal = true,
LosTraders = true,
RNGMachine = true,
Present = true,
StPatricksPot = true,
ShopNPCRobuxIdle = true,
RoadPanel = true,
Honey = true,
Trap = true,
Events = true,
Sounds = true,
rods = true,
Dev = true,
ToolsAdds = true,
__PROJECTILES = true,
CrystalMap = true,
SpawnLocation = true,
UFO = true,
Interacts = true,
}
local t280 = {
Skin = true,
Laser = true,
AnimalPodiums = true,
DeliveryHitbox = true,
StealHitbox = true,
AnimalTarget = true,
MainRoot = true,
Floor = true,
Spawn = true,
Door = true,
Hitbox = true,
Base = true,
Wall = true,
Roof = true,
SecondFloor = true,
ThirdFloor = true,
["structure base home"] = true,
Unlock = true,
}
local t281 = {
FriendPanel = true,
Cash = true,
Purchases = true,
PlotSign = true,
CashPad = true,
InvisibleWalls = true,
Multiplier = true,
Events = true,
Sounds = true,
Slope = true,
}
local t282 = {
HumanoidRootPart = true,
Head = true,
Torso = true,
UpperTorso = true,
LowerTorso = true,
LeftUpperArm = true,
LeftLowerArm = true,
LeftHand = true,
RightUpperArm = true,
RightLowerArm = true,
RightHand = true,
LeftUpperLeg = true,
LeftLowerLeg = true,
LeftFoot = true,
RightUpperLeg = true,
RightLowerLeg = true,
RightFoot = true,
["Left Arm"] = true,
["Right Arm"] = true,
["Left Leg"] = true,
["Right Leg"] = true,
}
local t283 = {
Humanoid = true,
Animator = true,
Attachment = true,
Motor6D = true,
AnimationConstraint = true,
BallSocketConstraint = true,
Weld = true,
WeldConstraint = true,
}
local t284 = {
Ground = true,
Ground_Left = true,
Ground_Right = true,
}
local t285 = {
Part = true,
MeshPart = true,
UnionOperation = true,
WedgePart = true,
CornerWedgePart = true,
TrussPart = true,
SpawnLocation = true,
Seat = true,
VehicleSeat = true,
}
local n692
local function v7401(p1014)
n692 = 210177387
local Parent = p1014
for i = 1, 12 do
if not Parent then
return false
end
if Parent.Name == "Unlock" then
return true
end
if Parent == workspace then
return false
end
Parent = Parent.Parent
end
if n689 < n692 then
return false
end
n1 += 1635
n2 -= 1344
n692 = 553028802
n689 += 775
n690 += 923
n691 -= 903
n4 = 174343896
end
local function v7404(p1015)
if not LocalPlayer2 or not p1015 then
return false
end
local n693 = 126025026
if p1015 == LocalPlayer2.Character or p1015.Name == LocalPlayer2.Name then
if n1 ~= n693 then
return true
end
n690 -= 1794
n2 = 981123920
n4 = 750894591
n691 = 203609753
n1 -= 1550
n689 += 875
end
return false
end
local function v7406(p1016)
local ClassName = p1016.ClassName
local v7408 = ClassName == "Beam"
or ClassName == "Trail"
or ClassName == "ParticleEmitter"
or ClassName == "PointLight"
or ClassName == "SpotLight"
or ClassName == "SurfaceLight"
or ClassName == "Fire"
or ClassName == "Smoke"
v7408 = v7408 or ClassName == "Sparkles" or ClassName == "BillboardGui"
return v7408
or ClassName == "SurfaceGui"
or ClassName == "Highlight"
or ClassName == "Decal"
or ClassName == "Texture"
end
local function v7409(p1017)
if not p1017 then
return false
end
if v7406(p1017) then
return true
end
return t285[p1017.ClassName] == true and not p1017.CanCollide
end
local function v7410(p1018)
if p1018 and p1018.ClassName == "Model" then
return p1018:FindFirstChild("FakeRootPart") ~= nil or p1018:FindFirstChild("RootPart") ~= nil
end
return false
end
local function v7411(p1019)
if not p1019 or not p1019.Parent then
return
end
local descendants = p1019:GetDescendants()
local t286 = {}
for i = 1, #descendants do
if v7409(descendants[i]) then
t286[#t286 + 1] = descendants[i]
end
end
for i = 1, #t286 do
v7392(t286[i])
end
end
local function v7416(p1020)
if _G.__SXE_KeepPlot then
return p1020 and tostring(p1020.Name) == tostring(_G.__SXE_KeepPlot)
end
return true
end
local function v7417(p1021)
return v7416(p1021)
end
local function v7418(p1022)
local v7419 = p1022
for i = 1, 16 do
if not v7419 then
return nil
end
local Parent = v7419.Parent
if Parent and Parent.Name == "Plots" then
return v7419
end
v7419 = Parent
end
return nil
end
local function v7422(p1023)
if not p1023 then
return false
end
local n694 = 56496018
local Parent = p1023
local n695 = 664851020
local v7426
for i = 1, 16 do
if not Parent then
break
end
if n690 == n694 then
n4 -= 658
n678 += 1013
n695 += 1656
n690 = 438559205
n694 += 1232
n2 = 216569688
n689 -= 1549
n691 = 777979390
(nil)()
v7426 = v7426()
elseif Parent.Name == "RemainingTime" then
return true
end
Parent = Parent.Parent
end
local ClassName = p1023.ClassName
if ClassName == "BillboardGui" or ClassName == "SurfaceGui" then
local RemainingTime
pcall(function()
RemainingTime = p1023:FindFirstChild("RemainingTime", true)
end)
if RemainingTime then
return true
end
end
return false
end
local function v7430(p1024)
if not p1024 or not p1024.Parent then
return
end
local children = p1024:GetChildren()
local v7432 = #children
local n696, exitTo4, v7435, descendants, v7437, n697, v7439, v7440, exitTo3, v7442, ClassName, exitTo2, exitTo, v7446, ClassName2, v7448
if true then
if v7432 >= 1 then
n696 = 1
exitTo4 = nil
while true do
v7435 = children[n696]
if v7435.Name == "PlotBlock" then
descendants = v7435:GetDescendants()
v7437 = #descendants
n697 = 1
v7439 = v7437 + 0
v7440 = 1 - n697
exitTo3 = nil
for i = 1, v7437 do
v7442 = descendants[i]
ClassName = v7442.ClassName
if ClassName == "BillboardGui" or ClassName == "SurfaceGui" then
exitTo2 = nil
while not v7422(v7442) do
v7392(v7442)
exitTo = nil
while true do
v7440 += n697
if not (n697 <= 0) then
if v7440 <= v7439 then
v7446 = v7440
v7442 = descendants[v7446]
ClassName2 = v7442.ClassName
if
ClassName2 ~= "BillboardGui"
and ClassName2 ~= "SurfaceGui"
then
continue
end
else
exitTo = 1
break
end
break
elseif v7440 >= v7439 then
v7446 = v7440
v7442 = descendants[v7446]
ClassName2 = v7442.ClassName
if ClassName2 == "BillboardGui" or ClassName2 == "SurfaceGui" then
break
end
else
exitTo = 1
break
end
end
if exitTo == 1 then
exitTo2 = 1
break
end
end
if exitTo2 == 1 then
exitTo3 = 1
break
end
end
end
if exitTo3 == 1 then
v7448 += nil
if not (nil <= 0) then
if v7448 <= nil then
n696 = v7448
continue
end
exitTo4 = 1
break
end
if v7448 >= nil then
n696 = v7448
continue
end
exitTo4 = 1
break
end
v7448 += nil
if not (nil <= 0) then
if v7448 <= nil then
n696 = v7448
continue
end
elseif v7448 >= nil then
n696 = v7448
continue
end
break
end
v7392(v7435)
v7448 += nil
if not (nil <= 0) then
if v7448 <= nil then
n696 = v7448
continue
end
elseif v7448 >= nil then
n696 = v7448
continue
end
break
end
if exitTo4 == 1 then
if n4 == n691 then
n2 = 623234293
n691 = 526439547
n4 = 51793766
n690 = 1018447204
n677 += 240
n689 = 679818334
if true then
end
end
elseif n4 == n691 then
n2 = 623234293
n691 = 526439547
n4 = 51793766
n690 = 1018447204
n677 += 240
n689 = 679818334
if true then
end
end
elseif n4 == n691 then
n2 = 623234293
n691 = 526439547
n4 = 51793766
n690 = 1018447204
n677 += 240
n689 = 679818334
if true then
end
end
elseif v7432 <= 1 then
n696 = 1
exitTo4 = nil
while true do
v7435 = children[n696]
if v7435.Name == "PlotBlock" then
descendants = v7435:GetDescendants()
v7437 = #descendants
n697 = 1
v7439 = v7437 + 0
v7440 = 1 - n697
exitTo3 = nil
for i = 1, v7437 do
v7442 = descendants[i]
ClassName = v7442.ClassName
if ClassName == "BillboardGui" or ClassName == "SurfaceGui" then
exitTo2 = nil
while not v7422(v7442) do
v7392(v7442)
exitTo = nil
while true do
v7440 += n697
if not (n697 <= 0) then
if v7440 <= v7439 then
v7446 = v7440
v7442 = descendants[v7446]
ClassName2 = v7442.ClassName
if ClassName2 ~= "BillboardGui" and ClassName2 ~= "SurfaceGui" then
continue
end
else
exitTo = 1
break
end
break
elseif v7440 >= v7439 then
v7446 = v7440
v7442 = descendants[v7446]
ClassName2 = v7442.ClassName
if ClassName2 == "BillboardGui" or ClassName2 == "SurfaceGui" then
break
end
else
exitTo = 1
break
end
end
if exitTo == 1 then
exitTo2 = 1
break
end
end
if exitTo2 == 1 then
exitTo3 = 1
break
end
end
end
if exitTo3 == 1 then
v7448 += nil
if not (nil <= 0) then
if v7448 <= nil then
n696 = v7448
continue
end
exitTo4 = 1
break
end
if v7448 >= nil then
n696 = v7448
continue
end
exitTo4 = 1
break
end
v7448 += nil
if not (nil <= 0) then
if v7448 <= nil then
n696 = v7448
continue
end
elseif v7448 >= nil then
n696 = v7448
continue
end
break
end
v7392(v7435)
v7448 += nil
if not (nil <= 0) then
if v7448 <= nil then
n696 = v7448
continue
end
elseif v7448 >= nil then
n696 = v7448
continue
end
break
end
if exitTo4 == 1 then
if n4 == n691 then
n2 = 623234293
n691 = 526439547
n4 = 51793766
n690 = 1018447204
n677 += 240
n689 = 679818334
if true then
end
end
elseif n4 == n691 then
n2 = 623234293
n691 = 526439547
n4 = 51793766
n690 = 1018447204
n677 += 240
n689 = 679818334
if true then
end
end
elseif n4 == n691 then
n2 = 623234293
n691 = 526439547
n4 = 51793766
n690 = 1018447204
n677 += 240
n689 = 679818334
if true then
end
end
end
local function sxeStripPetVfx(p1025)
if not p1025 then
return
end
local n698 = 49119229
local descendants = p1025:GetDescendants()
local t287 = {}
local n699 = 855151177
for i = 1, #descendants do
local v7457 = descendants[i]
local Name = v7457.Name
local ClassName = v7457.ClassName
if
Name == "VfxInstance"
or Name == "_VfxInstance"
or Name == "AnimationController"
or ClassName == "ParticleEmitter"
or ClassName == "Beam"
or ClassName == "Trail"
or ClassName == "Fire"
or ClassName == "Smoke"
or ClassName == "Sparkles"
or ClassName == "Animator"
or ClassName == "AnimationController"
or ClassName == "Bone"
or ClassName == "BillboardGui"
or ClassName == "SurfaceGui"
then
t287[#t287 + 1] = v7457
end
end
local n700 = 955849591
for i = 1, #t287 do
if n689 == 207698086 then
v7392(t287[i])
else
n1 = 18702860
n691 += 198
n698 += 911
n690 = 819804516
n699 -= 1646
n678 += 367
n2 -= 1771
n689 -= 1624
n700 -= 3
(nil)()
end
end
end
_G.SXE_StripPetVfx = sxeStripPetVfx
local function v7462(p1026)
if not p1026 then
return false
end
local v7463
local ClassName = p1026.ClassName
if ClassName == "PathfindingModifier" then
return false
end
if ClassName == "WrapTarget" or ClassName == "WrapLayer" then
return true
end
if ClassName == "Shirt" or ClassName == "ShirtGraphic" then
return true
end
if ClassName == "NoCollisionConstraint" then
return true
end
local n701 = 217881160
local Name = p1026.Name
if Name == "__HITBOX" or Name == "OriginalPosition" or Name == "OriginalSize" then
return true
end
if t283[ClassName] then
return false
end
if t282[Name] then
return false
end
local n702 = 243178214
if n677 == 429390507 then
return true
end
n677 -= 780
n2 = 169222864
n690 += 1273
local v7468 = n701 + 1280
n678 -= 1087
n689 -= 84
n691 += 1403
local v7469 = n702 - 1527
while true do
v7463[55] = 108
n677 -= 780
n2 = 169222864
n690 += 1273
v7468 += 1280
n678 -= 1087
n689 -= 84
n691 += 1403
v7469 -= 1527
end
end
local function v7470(p1027)
return type(p1027) == "string"
and #p1027 == 36
and string.match(
p1027,
"^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$"
)
~= nil
end
local function v7471(p1028)
if not p1028 or p1028.ClassName ~= "Model" then
return false
end
if v7404(p1028) then
return false
end
if v7410(p1028) then
return false
end
local Name = p1028.Name
if type(Name) == "string" then
if string.sub(Name, -6) == "_Clone" then
return false
end
end
if Players2:GetPlayerFromCharacter(p1028) then
return true
end
if Players2:FindFirstChild(Name) then
return true
end
return p1028:FindFirstChildOfClass("Humanoid") ~= nil
end
local t288 = {}
local function v7474(character)
local n703 = 523054471
if _G.__SXE_VelFlying then
return
end
if character and character.Parent and not v7404(character) then
if v7471(character) then
local n704 = 339859976
local n705 = 138153012
local function v7478()
local descendants = character:GetDescendants()
local t289 = {}
local n706 = 1
local v7482 = #descendants
local v7483, exitTo, v7485, v7486, v7487, n707, v7489, v7490, n708, v7492, v7493, exitTo2, exitTo5
if true then
if n706 <= v7482 then
repeat
v7485 = n706
exitTo = nil
while true do
if v7462(descendants[v7485]) then
v7486 = #t289 + 1
t289[v7486] = descendants[v7485]
end
v7483 += nil
if not (nil <= 0) then
exitTo = 1
break
elseif v7483 >= nil then
v7485 = n706
continue
end
break
end
until exitTo ~= 1 or not (v7483 <= nil)
v7487 = #t289
n707 = 1
for i = 1, v7487 do
if n703 == 523054471 then
v7392(t289[i])
else
n703 -= 590
n690 -= 912
n704 += 1945
n705 += 1256
n677 -= 1974
n2 += 1451
upv420[nil] = nil
upv420[upv420[1]]()
end
end
else
v7490 = #t289
n708 = 1
v7492 = v7490 + 0
v7493 = 1 - v7490
exitTo2 = nil
local exitTo4
while true do
v7493 += n708
if not (n708 <= 0) then
exitTo4 = 1
break
end
if not (v7493 >= v7492) then
break
end
v7489 = v7493
if n703 == 523054471 then
exitTo4 = 2
break
end
n703 -= 590
n690 -= 912
n704 += 1945
n705 += 1256
n677 -= 1974
n2 += 1451
upv420[nil] = nil
upv420[upv420[1]]()
end
if exitTo4 == 1 then
if v7493 <= v7492 then
v7489 = v7493
local exitTo7
while true do
if n703 == 523054471 then
exitTo7 = 1
break
end
n703 -= 590
n690 -= 912
n704 += 1945
n705 += 1256
n677 -= 1974
n2 += 1451
upv420[nil] = nil
upv420[upv420[1]]()
exitTo5 = nil
while true do
v7493 += n708
if not (n708 <= 0) then
exitTo5 = 1
break
end
if not (v7493 >= v7492) then
break
end
v7489 = v7493
if n703 == 523054471 then
exitTo5 = 2
break
end
n703 -= 590
n690 -= 912
n704 += 1945
n705 += 1256
n677 -= 1974
n2 += 1451
upv420[nil] = nil
upv420[upv420[1]]()
end
if exitTo5 ~= 1 then
break
end
if v7493 <= v7492 then
v7489 = v7493
continue
end
exitTo7 = 2
break
end
if exitTo7 == 1 then
exitTo2 = 1
if exitTo2 == 1 then
v7392(t289[v7489])
for i = 1, v7487 do
if n703 == 523054471 then
v7392(t289[i])
else
n703 -= 590
n690 -= 912
n704 += 1945
n705 += 1256
n677 -= 1974
n2 += 1451
upv420[nil] = nil
upv420[upv420[1]]()
end
end
end
elseif exitTo7 == 2 then
if exitTo2 == 1 then
v7392(t289[v7489])
for i = 1, v7487 do
if n703 == 523054471 then
v7392(t289[i])
else
n703 -= 590
n690 -= 912
n704 += 1945
n705 += 1256
n677 -= 1974
n2 += 1451
upv420[nil] = nil
upv420[upv420[1]]()
end
end
end
elseif exitTo5 == 2 then
exitTo2 = 1
if exitTo2 == 1 then
v7392(t289[v7489])
for i = 1, v7487 do
if n703 == 523054471 then
v7392(t289[i])
else
n703 -= 590
n690 -= 912
n704 += 1945
n705 += 1256
n677 -= 1974
n2 += 1451
upv420[nil] = nil
upv420[upv420[1]]()
end
end
end
elseif exitTo2 == 1 then
v7392(t289[v7489])
for i = 1, v7487 do
if n703 == 523054471 then
v7392(t289[i])
else
n703 -= 590
n690 -= 912
n704 += 1945
n705 += 1256
n677 -= 1974
n2 += 1451
upv420[nil] = nil
upv420[upv420[1]]()
end
end
end
elseif exitTo2 == 1 then
v7392(t289[v7489])
for i = 1, v7487 do
if n703 == 523054471 then
v7392(t289[i])
else
n703 -= 590
n690 -= 912
n704 += 1945
n705 += 1256
n677 -= 1974
n2 += 1451
upv420[nil] = nil
upv420[upv420[1]]()
end
end
end
elseif exitTo4 == 2 then
exitTo2 = 1
if exitTo2 == 1 then
v7392(t289[v7489])
for i = 1, v7487 do
if n703 == 523054471 then
v7392(t289[i])
else
n703 -= 590
n690 -= 912
n704 += 1945
n705 += 1256
n677 -= 1974
n2 += 1451
upv420[nil] = nil
upv420[upv420[1]]()
end
end
end
elseif exitTo2 == 1 then
v7392(t289[v7489])
for i = 1, v7487 do
if n703 == 523054471 then
v7392(t289[i])
else
n703 -= 590
n690 -= 912
n704 += 1945
n705 += 1256
n677 -= 1974
n2 += 1451
upv420[nil] = nil
upv420[upv420[1]]()
end
end
end
end
elseif n706 >= v7482 then
local exitTo3
while true do
v7485 = n706
if v7462(descendants[v7485]) then
v7486 = #t289 + 1
t289[v7486] = descendants[v7485]
end
v7483 += nil
if not (nil <= 0) then
exitTo3 = 1
break
elseif v7483 >= nil then
continue
end
break
end
if exitTo3 == 1 and v7483 <= nil then
repeat
v7485 = n706
exitTo = nil
while true do
if v7462(descendants[v7485]) then
v7486 = #t289 + 1
t289[v7486] = descendants[v7485]
end
v7483 += nil
if not (nil <= 0) then
exitTo = 1
break
elseif v7483 >= nil then
v7485 = n706
continue
end
break
end
until exitTo ~= 1 or not (v7483 <= nil)
v7487 = #t289
n707 = 1
else
v7487 = #t289
n707 = 1
end
for i = 1, v7487 do
if n703 == 523054471 then
v7392(t289[i])
else
n703 -= 590
n690 -= 912
n704 += 1945
n705 += 1256
n677 -= 1974
n2 += 1451
upv420[nil] = nil
upv420[upv420[1]]()
end
end
else
v7490 = #t289
n708 = 1
v7492 = v7490 + 0
v7493 = 1 - v7490
exitTo2 = nil
local exitTo6
while true do
v7493 += n708
if not (n708 <= 0) then
exitTo6 = 1
break
end
if not (v7493 >= v7492) then
break
end
v7489 = v7493
if n703 == 523054471 then
exitTo6 = 2
break
end
n703 -= 590
n690 -= 912
n704 += 1945
n705 += 1256
n677 -= 1974
n2 += 1451
upv420[nil] = nil
upv420[upv420[1]]()
end
if exitTo6 == 1 then
if v7493 <= v7492 then
v7489 = v7493
local exitTo8
while true do
if n703 == 523054471 then
exitTo8 = 1
break
end
n703 -= 590
n690 -= 912
n704 += 1945
n705 += 1256
n677 -= 1974
n2 += 1451
upv420[nil] = nil
upv420[upv420[1]]()
exitTo5 = nil
while true do
v7493 += n708
if not (n708 <= 0) then
exitTo5 = 1
break
end
if not (v7493 >= v7492) then
break
end
v7489 = v7493
if n703 == 523054471 then
exitTo5 = 2
break
end
n703 -= 590
n690 -= 912
n704 += 1945
n705 += 1256
n677 -= 1974
n2 += 1451
upv420[nil] = nil
upv420[upv420[1]]()
end
if exitTo5 ~= 1 then
break
end
if v7493 <= v7492 then
v7489 = v7493
continue
end
exitTo8 = 2
break
end
if exitTo8 == 1 then
exitTo2 = 1
if exitTo2 == 1 then
v7392(t289[v7489])
for i = 1, v7487 do
if n703 == 523054471 then
v7392(t289[i])
else
n703 -= 590
n690 -= 912
n704 += 1945
n705 += 1256
n677 -= 1974
n2 += 1451
upv420[nil] = nil
upv420[upv420[1]]()
end
end
end
elseif exitTo8 == 2 then
if exitTo2 == 1 then
v7392(t289[v7489])
for i = 1, v7487 do
if n703 == 523054471 then
v7392(t289[i])
else
n703 -= 590
n690 -= 912
n704 += 1945
n705 += 1256
n677 -= 1974
n2 += 1451
upv420[nil] = nil
upv420[upv420[1]]()
end
end
end
elseif exitTo5 == 2 then
exitTo2 = 1
if exitTo2 == 1 then
v7392(t289[v7489])
for i = 1, v7487 do
if n703 == 523054471 then
v7392(t289[i])
else
n703 -= 590
n690 -= 912
n704 += 1945
n705 += 1256
n677 -= 1974
n2 += 1451
upv420[nil] = nil
upv420[upv420[1]]()
end
end
end
elseif exitTo2 == 1 then
v7392(t289[v7489])
for i = 1, v7487 do
if n703 == 523054471 then
v7392(t289[i])
else
n703 -= 590
n690 -= 912
n704 += 1945
n705 += 1256
n677 -= 1974
n2 += 1451
upv420[nil] = nil
upv420[upv420[1]]()
end
end
end
elseif exitTo2 == 1 then
v7392(t289[v7489])
for i = 1, v7487 do
if n703 == 523054471 then
v7392(t289[i])
else
n703 -= 590
n690 -= 912
n704 += 1945
n705 += 1256
n677 -= 1974
n2 += 1451
upv420[nil] = nil
upv420[upv420[1]]()
end
end
end
elseif exitTo6 == 2 then
exitTo2 = 1
if exitTo2 == 1 then
v7392(t289[v7489])
for i = 1, v7487 do
if n703 == 523054471 then
v7392(t289[i])
else
n703 -= 590
n690 -= 912
n704 += 1945
n705 += 1256
n677 -= 1974
n2 += 1451
upv420[nil] = nil
upv420[upv420[1]]()
end
end
end
elseif exitTo2 == 1 then
v7392(t289[v7489])
for i = 1, v7487 do
if n703 == 523054471 then
v7392(t289[i])
else
n703 -= 590
n690 -= 912
n704 += 1945
n705 += 1256
n677 -= 1974
n2 += 1451
upv420[nil] = nil
upv420[upv420[1]]()
end
end
end
end
end
v7478()
if t288[character] then
return
end
t288[character] = true
if n677 == n704 then
n1 = 722747347
n689 = 419608104
n705 += 1624
n691 -= 975
n690 = 611687052
n704 -= 1875
n703 += 1680
n2 = 616482230
n677 -= 1567
(nil)[nil] = nil
(nil)[nil] = nil
else
character.DescendantAdded:Connect(function(descendant)
if _G.__SXE_VelFlying then
return
end
if descendant and descendant.Parent and not v7404(character) then
if v7462(descendant) then
v7392(descendant)
end
end
end)
end
return
end
end
end
local t290 = {}
_G.__SXE_StrippedPlots = t290
local function v7518(p1029, p1030)
return math.abs(p1029 - p1030) < 0.2
end
local function v7519(p1031)
if not p1031 or t285[p1031.ClassName] ~= true then
return false
end
if p1031.Name == "structure base home" or p1031.Name == "Spawn" then
return false
end
local Size = p1031.Size
if v7518(Size.X, 4) then
if v7518(Size.Y, 1) and v7518(Size.Z, 4) then
return true
end
end
if v7518(Size.X, 2) and v7518(Size.Y, 0.5) and v7518(Size.Z, 2) then
return true
end
return false
end
local function v7521(p1032)
if not p1032 or t285[p1032.ClassName] ~= true then
return false
end
if p1032.Name == "Spawn" then
return false
end
local Size = p1032.Size
if v7518(Size.X, 6) and v7518(Size.Y, 0.2) then
if v7518(Size.Z, 6) then
return true
end
end
if v7518(Size.X, 4) and v7518(Size.Y, 0.2) and v7518(Size.Z, 4) then
return true
end
if n2 < n678 then
return false
end
n2 = 202939096
n690 = 11710187
n689 = 61190389
n1 = 45822869
n691 += 923
n678 = 782327838
end
local n709
local function v7524(p1033)
n709 = 624381610
if not p1033 or not p1033.Parent then
return
end
local t291 = {}
local n710 = 12342150
local n711
local function v7528(p1034)
n711 = 854822418
local children = p1034:GetChildren()
for i = 1, #children do
local v7531 = children[i]
local ClassName = v7531.ClassName
local Name = v7531.Name
if
Name ~= "Spawn"
and Name ~= "PromptAttachment"
and ClassName ~= "ProximityPrompt"
and (ClassName ~= "Model" or not v7410(v7531))
then
if ClassName == "Beam" or ClassName == "PointLight" then
t291[#t291 + 1] = v7531
elseif v7519(v7531) then
t291[#t291 + 1] = v7531
else
v7528(v7531)
end
end
end
if not (n710 < n4) then
n711 += 1057
n709 -= 1542
n2 = 506700058
n710 = 45220076
n4 += 1551
n689 += 753
upv332 = nil
(nil)()
upv332[32]()
end
end
v7528(p1033)
for i = 1, #t291 do
v7392(t291[i])
end
end
local n712
local function v7536(p1035)
n712 = 402455977
local n713 = 630222156
if not p1035 or not p1035.Parent then
return
end
local t292 = {}
local n714
local function v7540(p1036)
local v7541
local v7542 = p1036
n714 = 627913712
if not v7542 then
return
end
local descendants = v7542:GetDescendants()
if n712 == 402455977 then
for i = 1, #descendants do
local v7545 = descendants[i]
if
v7545.Name ~= "Spawn"
and v7545.Name ~= "PromptAttachment"
and v7545.ClassName ~= "ProximityPrompt"
and v7521(v7545)
then
t292[#t292 + 1] = v7545
end
end
else
n712 += 873
n678 += 263
n689 = 279173486
n714 -= 253
n2 = 148904365
repeat
n713 = 695416138
until true
n713[34]()
v7541()
end
end
local children = p1035:GetChildren()
for i = 1, #children do
local v7548 = children[i]
local Base = v7548:FindFirstChild("Base")
if Base then
v7540(Base:FindFirstChild("Decorations"))
end
v7540(v7548:FindFirstChild("Decorations"))
end
for i = 1, #t292 do
v7392(t292[i])
end
end
local n715
local n716
local function v7553(p1037, p1038)
n715 = 817197400
n716 = 845905138
if p1038 then
if p1038.Parent then
local Name = p1038.Name
if Name == "Skin" then
v7411(p1038)
return
end
if Name == "Laser" then
return
end
if Name == "AnimalPodiums" then
v7536(p1038)
return
end
if Name == "Decorations" then
v7524(p1038)
return
end
if Name == "Purchases" then
if v7417(p1037) then
v7430(p1038)
else
v7392(p1038)
end
if n677 ~= n2 then
return
end
n677 -= 1125
n2 -= 1605
n716 -= 291
n691 -= 884
n690 -= 1794
n1 += 483
n689 -= 980
n715 = 112905258
(nil)()
n715[n691[1]] = n691[3] + nil
end
if t280[Name] then
return
end
if t281[Name] then
v7392(p1038)
return
end
if not v7410(p1038) then
return
end
local SXE_PrioSet = _G.SXE_PrioSet
if type(SXE_PrioSet) == "table" and SXE_PrioSet[string.lower(Name)] ~= true then
v7392(p1038)
else
sxeStripPetVfx(p1038)
end
return
end
end
end
local n717
local function v7557(p1039)
n717 = 253411256
if not p1039 or not p1039.Parent then
return
end
if _G.__SXE_MyPlot then
if p1039.Name == _G.__SXE_MyPlot then
return
end
end
if n690 == 797251569 then
t290[p1039.Name] = true
else
n717 += 1050
n677 += 363
n691 -= 184
n2 = 738258000
n690 += 792
n689 = 852517404
n678 -= 1131
end
local children = p1039:GetChildren()
for i = 1, #children do
local v7560 = children[i]
if v7560 and v7560.Parent then
local Name = v7560.Name
if Name ~= "Skin" and Name ~= "Laser" and Name ~= "AnimalPodiums" and Name ~= "Decorations" then
if Name == "Purchases" then
if v7417(p1039) then
v7430(v7560)
continue
end
end
if not t280[Name] then
if t281[Name] then
v7392(v7560)
elseif v7410(v7560) then
local SXE_PrioSet = _G.SXE_PrioSet
if type(SXE_PrioSet) == "table" and SXE_PrioSet[string.lower(Name)] ~= true then
v7392(v7560)
end
end
end
end
end
end
end
local function v7563(p1040)
local n718 = 526286583
if p1040 then
if p1040.Parent then
local n719 = 241626664
if _G.__SXE_MyPlot and p1040.Name == _G.__SXE_MyPlot then
return
end
local Skin = p1040:FindFirstChild("Skin")
if Skin then
v7411(Skin)
end
local AnimalPodiums = p1040:FindFirstChild("AnimalPodiums")
if AnimalPodiums then
v7536(AnimalPodiums)
end
local Decorations = p1040:FindFirstChild("Decorations")
if Decorations then
v7524(Decorations)
end
local children = p1040:GetChildren()
for i = 1, #children do
local v7571 = children[i]
if v7410(v7571) then
if n678 == 1061454987 then
sxeStripPetVfx(v7571)
else
n678 = 150610286
n677 += 703
n690 -= 1413
n718 -= 525
n2 -= 2008
n691 = 982375074
n689 = 490423658
n719 += 1695
end
end
end
return
end
end
end
local function v7572(p1041)
v7557(p1041)
v7563(p1041)
if n4 ~= 616969873 then
n690 = 375464043
n691 += 1005
n1 = 295753941
n4 = 440089675
n2 += 1288
n689 = 886149068
(nil)(nil, nil)
end
end
local function v7573(p1042)
if p1042 then
if p1042.Parent then
local n720 = 734745620
local n721 = 337843928
p1042.ChildAdded:Connect(function(child)
if _G.__SXE_VelFlying then
return
end
v7553(p1042, child)
end)
p1042.DescendantAdded:Connect(function(descendant)
if _G.__SXE_VelFlying then
return
end
local n722 = 443402833
if not descendant then
return
end
if v7401(descendant) then
return
end
local ClassName = descendant.ClassName
if ClassName == "BillboardGui" or ClassName == "SurfaceGui" then
if v7417(p1042) and v7422(descendant) then
return
end
v7392(descendant)
return
end
if
descendant.Name == "Spawn"
or descendant.Name == "PromptAttachment"
or ClassName == "ProximityPrompt"
then
return
end
if descendant.Name == "Decorations" and descendant.Parent == p1042 then
v7524(descendant)
return
end
local Parent = descendant.Parent
if not Parent then
return
end
if t285[descendant.ClassName] then
if v7519(descendant) then
local Parent2 = Parent
local v7580 = false
local v7581 = false
while Parent2 and Parent2 ~= p1042 do
if
v7410(Parent2)
or Parent2.Name == "Spawn"
or Parent2.Name == "AnimalPodiums"
then
v7581 = true
break
else
if Parent2.Name == "Decorations" and Parent2.Parent == p1042 then
v7580 = true
end
Parent2 = Parent2.Parent
end
end
if v7580 and not v7581 then
v7392(descendant)
return
end
elseif v7521(descendant) then
local Parent2 = Parent
local v7583 = false
local exitTo
while true do
if not Parent2 or Parent2 == p1042 then
exitTo = 1
break
end
if Parent2.Name == "Spawn" then
exitTo = 2
break
end
if Parent2.Name == "Decorations" then
v7583 = true
end
if Parent2.Name ~= "AnimalPodiums" then
Parent2 = Parent2.Parent
continue
end
break
end
if exitTo ~= 1 then
if exitTo ~= 2 then
if v7583 then
v7392(descendant)
end
return
end
end
end
end
local Parent2 = Parent
while Parent2 and Parent2 ~= p1042 do
if Parent2.Name == "Skin" then
if v7409(descendant) then
v7392(descendant)
end
return
end
Parent2 = Parent2.Parent
end
if n722 < n4 then
return
end
n720 += 271
n2 = 313786813
n4 -= 2006
n721 += 1752
end)
return
end
end
end
local function v7586(p1043)
if not p1043 then
return false
end
if _G.__SXE_MyPlot then
return true
end
local u7587
pcall(function()
if _G.XenSyncGet then
u7587 = _G.XenSyncGet(p1043.Name)
end
end)
if u7587 and _G.SXE_IsMyPlot and _G.SXE_IsMyPlot(u7587) then
_G.__SXE_MyPlot = p1043.Name
return true
end
return false
end
local function v7588(p1044)
if not p1044 then
return false
end
if v7586(p1044) then
return false
end
if _G.__SXE_KeepPlot and p1044.Name == _G.__SXE_KeepPlot then
return false
end
if _G.__SXE_MyPlot then
return p1044.Name ~= _G.__SXE_MyPlot
end
return false
end
local u7589
local function v7590(p1045)
if v7586(p1045) then
return
end
v7572(p1045)
v7573(p1045)
if n677 ~= 429390507 then
n678 -= 283
n677 += 1903
n690 += 443
n2 = 792090837
n689 = 1016757510
n691 -= 832
(nil)();
(nil)[30] = nil
end
end
local function v7591(p1046)
local n723 = 962384983
if not p1046 or u7589 == p1046 then
return
end
local n724 = 416798807
local n725 = 878813324
u7589 = p1046
local children = p1046:GetChildren()
local n726 = 892775674
for i = 1, #children do
if not v7586(children[i]) then
v7572(children[i])
if n2 < n725 then
v7573(children[i])
else
n2 += 1454
n723 = 819053885
n678 += 605
n1 += 1429
n690 = 792363760
n726 += 257
n724 += 456
n725 -= 1630
n689 += 1862
n691 = 217881434
end
end
end
p1046.ChildAdded:Connect(function(child)
v7590(child)
local n727 = 263685779
if v7588(child) then
if n727 < n2 then
v7392(child)
else
n2 -= 45
n725 -= 1476
n726 = 546975706
n724 = 539919489
n723 -= 46
n689 = 280313715
(nil)(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 364))
end
end
end)
end
_G.SXE_LockPrioPlot = function(p1047)
if not p1047 then
return
end
_G.__SXE_KeepPlot = tostring(p1047)
local Plots = workspace:FindFirstChild("Plots")
if not Plots then
return
end
local children = Plots:GetChildren()
for i = 1, #children do
local v7602 = children[i]
if v7588(v7602) then
v7392(v7602)
end
end
local _G__SXE_MyPlot = _G.__SXE_MyPlot and Plots:FindFirstChild(_G.__SXE_MyPlot)
if _G__SXE_MyPlot and _G.SXE_NukePlotPodiums then
pcall(_G.SXE_NukePlotPodiums, _G__SXE_MyPlot)
end
local _G__SXE_KeepPlot = _G.__SXE_KeepPlot and Plots:FindFirstChild(_G.__SXE_KeepPlot)
if _G__SXE_KeepPlot and _G.SXE_StripNonPrioPodiums then
pcall(_G.SXE_StripNonPrioPodiums, _G__SXE_KeepPlot)
end
end
local function v7605(p1048)
local function v7606(child)
if _G.__SXE_VelFlying then
return
end
if child and not t284[child.Name] then
v7392(child)
end
end
local children = p1048:GetChildren()
for i = 1, #children do
v7606(children[i])
end
p1048.ChildAdded:Connect(v7606)
end
local u7609
local u7610 = false
local function v7611(p1049)
if not p1049 then
return
end
if u7610 then
v7392(p1049)
return
end
if u7609 == p1049 then
return
end
u7609 = p1049
local function v7612()
if _G.__SXE_VelFlying then
return
end
if u7610 then
return
end
u7610 = true
v7392(p1049)
end
if #p1049:GetChildren() > 0 then
v7612()
else
p1049.ChildAdded:Connect(v7612)
end
end
local function v7613(child)
if not child then
return
end
if _G.__SXE_VelFlying then
return
end
local Name = child.Name
if child.ClassName == "Camera" or child.ClassName == "Terrain" then
return
end
if Name == "Plots" then
v7591(child)
return
end
if Name == "RenderedMovingAnimals" then
v7611(child)
return
end
if Name == "Map" then
v7605(child)
return
end
if v7404(child) then
return
end
if v7470(Name) then
v7392(child)
return
end
if v7471(child) then
v7474(child)
return
end
if child.ClassName == "Model" then
child.ChildAdded:Connect(function()
if v7471(child) then
v7474(child)
end
end)
end
if string.sub(Name, 1, 7) == "BeeHive" or string.sub(Name, 1, 7) == "Sentry_" then
v7392(child)
return
end
if not t279[Name] and child.ClassName ~= "Highlight" then
if child.ClassName == "Model" and string.find(Name, "'s Rainbow", 1, true) then
v7392(child)
end
return
end
v7392(child)
end
local children = workspace:GetChildren()
local v7616
local v7617
local v7618
local t293 = {}
for i = 1, #children do
local v7621 = children[i]
local Name = v7621.Name
if Name == "Plots" then
v7616 = v7621
elseif Name == "Map" then
v7617 = v7621
elseif Name == "RenderedMovingAnimals" then
v7618 = v7621
else
t293[#t293 + 1] = v7621
end
end
if v7617 then
v7605(v7617)
end
if v7618 then
v7611(v7618)
end
for i = 1, #t293 do
v7613(t293[i])
end
if v7616 then
v7591(v7616)
end
workspace.ChildAdded:Connect(v7613)
local function v7624(player)
if not player or player == LocalPlayer2 then
return
end
if player.Character then
v7474(player.Character)
end
player.CharacterAdded:Connect(v7474)
end
local players = Players2:GetPlayers()
for i = 1, #players do
v7624(players[i])
end
Players2.PlayerAdded:Connect(v7624)
local function v7627(child)
if _G.__SXE_VelFlying then
return
end
if not child then
return
end
local ClassName = child.ClassName
if n690 == 797252690 then
n677 += 1228
n678 += 1511
n691 = 47680036
n690 = 963619046
n2 -= 1117
n689 -= 514
elseif
ClassName == "Sky"
or ClassName == "Atmosphere"
or ClassName == "Clouds"
or ClassName == "SunRaysEffect"
or ClassName == "ColorCorrectionEffect"
then
v7392(child)
end
end
local children2 = Lighting:GetChildren()
for i = 1, #children2 do
v7627(children2[i])
end
Lighting.ChildAdded:Connect(v7627)
local function v7631(child)
if not child then
return
end
local ClassName = child.ClassName
if ClassName == "ColorCorrectionEffect" or ClassName == "BlurEffect" then
v7392(child)
end
end
local u7633
local function v7634(p1050)
if p1050 then
if u7633 ~= p1050 then
u7633 = p1050
local children3 = p1050:GetChildren()
for i = 1, #children3 do
v7631(children3[i])
end
p1050.ChildAdded:Connect(v7631)
return
end
end
end
v7634(workspace.CurrentCamera)
local n728
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
n728 = 927510422
if n677 < n690 then
v7634(workspace.CurrentCamera)
else
n678 += 391
n689 = 299279726
n690 -= 1300
n2 -= 669
n677 = 918209291
n728 -= 1453
n691 -= 833
end
end)
workspace.DescendantAdded:Connect(function(descendant)
if not descendant then
return
end
if _G.__SXE_VelFlying then
return
end
local ClassName = descendant.ClassName
if
ClassName == "BillboardGui"
or ClassName == "SurfaceGui"
or ClassName == "Decal"
or ClassName == "Texture"
then
if v7401(descendant) then
return
end
if
(ClassName == "BillboardGui" or ClassName == "SurfaceGui")
and v7417(v7418(descendant))
and v7422(descendant)
then
return
end
v7392(descendant)
end
end)
if v7617 and v7617.Parent then
local descendants = v7617:GetDescendants()
for i = 1, #descendants do
local ClassName = descendants[i].ClassName
if ClassName == "Decal" or ClassName == "Texture" then
v7392(descendants[i])
end
end
end
pcall(function()
workspace.Terrain.Decoration = false
end)
pcall(function()
workspace.Terrain:Clear()
end)
local children3 = workspace.Terrain:GetChildren()
for i = 1, #children3 do
v7392(children3[i])
end
workspace.Terrain.ChildAdded:Connect(function(child)
if _G.__SXE_VelFlying then
return
end
v7392(child)
end)
workspace.Terrain.DescendantAdded:Connect(function(descendant)
if _G.__SXE_VelFlying then
return
end
if descendant then
v7392(descendant)
end
end)
_G.__SXE_StripDone = true
end
task.spawn(function()
if not game:IsLoaded() then
game.Loaded:Wait()
end
local Players2 = game:GetService("Players")
local LocalPlayer2 = Players2.LocalPlayer or Players2.PlayerAdded:Wait()
if not LocalPlayer2.Character then
LocalPlayer2.CharacterAdded:Wait()
end
if not workspace:FindFirstChild("Plots") then
workspace:WaitForChild("Plots", 10)
end
task.spawn(function()
pcall(v7385)
end)
end)
end
v7345()
if not game:IsLoaded() then
game.Loaded:Wait()
end
Players = game:GetService("Players")
RunService = game:GetService("RunService")
UserInputService = game:GetService("UserInputService")
do
local TweenService = game:GetService("TweenService")
HttpService = game:GetService("HttpService")
LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
task.wait()
LocalPlayer = Players.LocalPlayer
end
t15 = {
frames = {},
scaleFns = {},
LOGO = "rbxthumb://type=Asset&id=76017686426016&w=150&h=150",
}
local value = rawget(_G, "__SXEUI_Conns")
if type(value) == "table" then
for _, v in ipairs(value) do
pcall(function()
local n729 = 958068943
v:Disconnect()
if n729 ~= n2 then
return
end
n4 -= 1731
n1 = 429140111
n2 = 567463079
end)
end
end
pcall(function()
u260 = 854335425
u261 = 128430464
local value2 = rawget(_G, "__SXEUI_Stop")
if type(value2) == "function" then
value2()
end
end)
local t294 = {}
_G.__SXEUI_Conns = t294
v222 = function(p1051, p1052)
local connection = p1051:Connect(p1052)
t294[#t294 + 1] = connection
return connection
end
color3 = Color3.fromRGB
uDim2New = UDim2.new
local layoutOrder = 0
v225 = function(p1053, p1054, p1055)
u264 = 333057546
local instance = Instance.new(p1053)
if instance:IsA("GuiObject") then
layoutOrder += 1
instance.LayoutOrder = layoutOrder
end
if p1054 then
for k, v in pairs(p1054) do
instance[k] = v
end
end
if p1055 then
instance.Parent = p1055
end
return instance
end
v226 = function(p1056, p1057)
u257 = 394597096
return v225("UICorner", {
CornerRadius = UDim.new(0, p1057),
}, p1056)
end
v227 = function(p1058, p1059, p1060, p1061)
u258 = 556244
u259 = 202791452
return v225("UIStroke", {
Color = p1059,
Thickness = p1060 or 1,
Transparency = p1061 or 0,
ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
}, p1058)
end
v228 = function(p1062, p1063, p1064, p1065, p1066)
u262 = 631225409
u263 = 195695103
return v225("UIPadding", {
PaddingLeft = UDim.new(0, p1063),
PaddingRight = UDim.new(0, p1064),
PaddingTop = UDim.new(0, p1065),
PaddingBottom = UDim.new(0, p1066),
}, p1062)
end
v229 = function(p1067, p1068, p1069)
if n4 == 616969873 then
return v225("UIListLayout", {
Padding = UDim.new(0, p1068 or 0),
SortOrder = Enum.SortOrder.LayoutOrder,
FillDirection = p1069 and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical,
}, p1067)
end
n1 -= 140
n4 = 96203435
n2 = 1067934872
end
v230 = function(p1070, p1071, p1072)
local n730 = 989611849
local n731 = 825301958
local n732 = 853869070
local n733 = 344980431
local ok, result = pcall(function()
local spilled = {}
if n733 < n4 then
return TweenService:Create(
p1070,
TweenInfo.new(p1072 or 0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
p1071
)
end
n730 -= 1336
n731 -= 1951
n4 = 171741375
n732 -= 102
n2 += 856
n733 = 7322969
(nil)[84] = nil
(nil)[85] = nil
(nil)[86] = nil
(nil)[87] = nil
(nil)[88] = nil
(nil)[89] = nil
(nil)[90] = nil
(nil)[91] = nil
(nil)[92] = nil
(nil)[93] = nil
(nil)[94] = nil
(nil)[95] = nil
(nil)[96] = nil
(nil)[97] = nil
(nil)[98] = nil
(nil)[99] = nil
(nil)[100] = nil
(nil)[101] = nil
(nil)[102] = nil
(nil)[103] = nil
(nil)[104] = nil
(nil)[105] = nil
(nil)[106] = nil
(nil)[107] = nil
(nil)[108] = nil
(nil)[109] = nil
(nil)[110] = nil
(nil)[111] = nil
(nil)[112] = nil
(nil)[113] = nil
(nil)[114] = nil
(nil)[115] = nil
(nil)[116] = nil
(nil)[117] = nil
(nil)[118] = nil
(nil)[119] = nil
(nil)[120] = nil
(nil)[121] = nil
(nil)[122] = nil
(nil)[123] = nil
(nil)[124] = nil
(nil)[125] = nil
(nil)[126] = nil
(nil)[127] = nil
(nil)[128] = nil
(nil)[129] = nil
(nil)[130] = nil
(nil)[131] = nil
(nil)[132] = nil
(nil)[133] = nil
(nil)[134] = nil
(nil)[135] = nil
(nil)[136] = nil
(nil)[137] = nil
(nil)[138] = nil
(nil)[139] = nil
(nil)[140] = nil
(nil)[141] = nil
(nil)[142] = nil
(nil)[143] = nil
(nil)[144] = nil
(nil)[145] = nil
(nil)[146] = nil
(nil)[147] = nil
(nil)[148] = nil
(nil)[149] = nil
(nil)[150] = nil
(nil)[151] = nil
(nil)[152] = nil
(nil)[153] = nil
(nil)[154] = nil
(nil)[155] = nil
(nil)[156] = nil
(nil)[157] = nil
(nil)[158] = nil
(nil)[159] = nil
(nil)[160] = nil
(nil)[161] = nil
(nil)[162] = nil
(nil)[163] = nil
(nil)[164] = nil
(nil)[165] = nil
(nil)[166] = nil
(nil)[167] = nil
(nil)[168] = nil
(nil)[169] = nil
(nil)[170] = nil
(nil)[171] = nil
(nil)[172] = nil
(nil)[173] = nil
(nil)[174] = nil
(nil)[175] = nil
(nil)[176] = nil
(nil)[177] = nil
(nil)[178] = nil
(nil)[179] = nil
(nil)[180] = nil
(nil)[181] = nil
(nil)[182] = nil
(nil)[183] = nil
(nil)[184] = nil
(nil)[185] = nil
(nil)[186] = nil
(nil)[187] = nil
(nil)[188] = nil
(nil)[189] = nil
(nil)[190] = nil
(nil)[191] = nil
(nil)[192] = nil
(nil)[193] = nil
(nil)[194] = nil
(nil)[195] = nil
(nil)[196] = nil
(nil)[197] = nil
(nil)[198] = nil
(nil)[199] = nil
(nil)[200] = nil
(nil)[201] = nil
(nil)[202] = nil
(nil)[203] = nil
(nil)[204] = nil
(nil)[205] = nil
(nil)[206] = nil
(nil)[207] = nil
(nil)[208] = nil
(nil)[209] = nil
(nil)[210] = nil
(nil)[211] = nil
(nil)[212] = nil
(nil)[213] = nil
(nil)[214] = nil
(nil)[215] = nil
(nil)[216] = nil
(nil)[217] = nil
(nil)[218] = nil
(nil)[219] = nil
(nil)[220] = nil
(nil)[221] = nil
(nil)[222] = nil
(nil)[223] = nil
(nil)[224] = nil
(nil)[225] = nil
(nil)[226] = nil
(nil)[227] = nil
(nil)[228] = nil
(nil)[229] = nil
(nil)[230] = nil
(nil)[231] = nil
(nil)[232] = nil
(nil)[233] = nil
(nil)[234] = nil
(nil)[235] = nil
(nil)[236] = nil
(nil)[237] = nil
(nil)[238] = nil
(nil)[239] = nil
(nil)[240] = nil
(nil)[241] = nil
(nil)[242] = nil
(nil)[243] = nil
(nil)[244] = nil
(nil)[245] = nil
(nil)[246] = nil
(nil)[247] = nil
(nil)[248] = nil
(nil)[249] = nil
(nil)[250] = nil
(nil)[251] = nil
(nil)[252] = nil
(nil)[253] = nil
(nil)[254] = nil
(nil)[255] = nil
(nil)[256] = nil
(nil)[257] = nil
(nil)[258] = nil
(nil)[259] = nil
(nil)[260] = nil
(nil)[261] = nil
(nil)[262] = nil
(nil)[263] = nil
(nil)[264] = nil
(nil)[265] = nil
(nil)[266] = nil
(nil)[267] = nil
(nil)[268] = nil
(nil)[269] = nil
(nil)[270] = nil
(nil)[271] = nil
(nil)[272] = nil
(nil)[273] = nil
(nil)[274] = nil
(nil)[275] = nil
(nil)[276] = nil
(nil)[277] = nil
(nil)[278] = nil
(nil)[279] = nil
(nil)[280] = nil
(nil)[281] = nil
(nil)[282] = nil
(nil)[283] = nil
(nil)[284] = nil
(nil)[285] = nil
(nil)[286] = nil
(nil)[287] = nil
(nil)[288] = nil
(nil)[289] = nil
(nil)[290] = nil
(nil)[291] = nil
(nil)[292] = nil
(nil)[293] = nil
(nil)[294] = nil
(nil)[295] = nil
(nil)[296] = nil
(nil)[297] = nil
(nil)[298] = nil
(nil)[299] = nil
(nil)[300] = nil
(nil)[301] = nil
(nil)[302] = nil
(nil)[303] = nil
(nil)[304] = nil
(nil)[305] = nil
(nil)[306] = nil
(nil)[307] = nil
(nil)[308] = nil
(nil)[309] = nil
(nil)[310] = nil
(nil)[311] = nil
(nil)[312] = nil
(nil)[313] = nil
(nil)[314] = nil
(nil)[315] = nil
(nil)[316] = nil
(nil)[317] = nil
(nil)[318] = nil
(nil)[319] = nil
(nil)[320] = nil
(nil)[321] = nil
(nil)[322] = nil
(nil)[323] = nil
(nil)[324] = nil
(nil)[325] = nil
(nil)[326] = nil
(nil)[327] = nil
(nil)[328] = nil
(nil)[329] = nil
(nil)[330] = nil
(nil)[331] = nil
(nil)[332] = nil
(nil)[333] = nil
(nil)[334] = nil
(nil)[335] = nil
(nil)[336] = nil
(nil)[337] = nil
(nil)[338] = nil
(nil)[339] = nil
(nil)[340] = nil
(nil)[341] = nil
(nil)[342] = nil
(nil)[343] = nil
(nil)[344] = nil
(nil)[345] = nil
(nil)[346] = nil
(nil)[347] = nil
(nil)[348] = nil
(nil)[349] = nil
(nil)[350] = nil
(nil)[351] = nil
(nil)[352] = nil
(nil)[353] = nil
(nil)[354] = nil
(nil)[355] = nil
(nil)[356] = nil
(nil)[357] = nil
(nil)[358] = nil
(nil)[359] = nil
(nil)[360] = nil
(nil)[361] = nil
(nil)[362] = nil
(nil)[363] = nil
(nil)[364] = nil
(nil)[365] = nil
(nil)[366] = nil
(nil)[367] = nil
(nil)[368] = nil
(nil)[369] = nil
(nil)[370] = nil
(nil)[371] = nil
(nil)[372] = nil
(nil)[373] = nil
(nil)[374] = nil
(nil)[375] = nil
(nil)[376] = nil
(nil)[377] = nil
(nil)[378] = nil
(nil)[379] = nil
(nil)[380] = nil
(nil)[381] = nil
(nil)[382] = nil
(nil)[383] = nil
(nil)[384] = nil
(nil)[385] = nil
(nil)[386] = nil
(nil)[387] = nil
(nil)[388] = nil
(nil)[389] = nil
(nil)[390] = nil
(nil)[391] = nil
(nil)[392] = nil
(nil)[393] = nil
(nil)[394] = nil
(nil)[395] = nil
(nil)[396] = nil
(nil)[397] = nil
(nil)[398] = nil
(nil)[399] = nil
(nil)[400] = nil
(nil)[401] = nil
(nil)[402] = nil
(nil)[403] = nil
(nil)[404] = nil
(nil)[405] = nil
(nil)[406] = nil
(nil)[407] = nil
(nil)[408] = nil
(nil)[409] = nil
(nil)[410] = nil
(nil)[411] = nil
(nil)[412] = nil
(nil)[413] = nil
(nil)[414] = nil
(nil)[415] = nil
(nil)[416] = nil
(nil)[417] = nil
(nil)[418] = nil
(nil)[419] = nil
(nil)[420] = nil
(nil)[421] = nil
(nil)[422] = nil
(nil)[423] = nil
(nil)[424] = nil
(nil)[425] = nil
(nil)[426] = nil
(nil)[427] = nil
(nil)[428] = nil
(nil)[429] = nil
(nil)[430] = nil
(nil)[431] = nil
(nil)[432] = nil
(nil)[433] = nil
(nil)[434] = nil
(nil)[435] = nil
(nil)[436] = nil
(nil)[437] = nil
(nil)[438] = nil
(nil)[439] = nil
local _
(nil)(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 441))
end)
if ok and result then
result:Play()
end
end
end
v231 = function(p1073, p1074, p1075, p1076, p1077, p1078)
u265 = 596570658
u266 = 1056121922
local TextLabel = v225("TextLabel", {
BackgroundTransparency = 1,
Text = p1074,
TextSize = p1075 or 12,
TextColor3 = p1076,
Font = p1077 or Enum.Font.GothamMedium,
TextXAlignment = Enum.TextXAlignment.Left,
})
if p1078 then
for k, v in pairs(p1078) do
TextLabel[k] = v
end
end
TextLabel.Parent = p1073
return TextLabel
end
local function v7847()
local n734 = 638641455
local ap = {
"balloon",
"inverse",
"jail",
"jumpscare",
"morph",
"nightvision",
"ragdoll",
"rocket",
"tiny",
}
t15.AP = ap
t15.EMO = {
balloon = "🎈",
inverse = "🔄",
jail = "🔒",
jumpscare = "👻",
morph = "🎭",
nightvision = "🌙",
ragdoll = "🌀",
rocket = "🚀",
tiny = "🐜",
}
local n735 = 812206103
local function copy(p1079)
if type(p1079) ~= "table" then
return p1079
end
local t295 = {}
for k, v in pairs(p1079) do
t295[k] = copy(v)
end
return t295
end
t15.copy = copy
local function v7855(p1080)
local t296 = {}
for _, v in ipairs(ap) do
t296[v] = p1080
end
return t296
end
local c = {
positions = {},
sizes = {},
keybinds = {},
locked = false,
Accent = "Pink",
LastTab = "Auto TP",
Visibilities = {
["Invisible Steal Panel"] = true,
["Command Cooldowns"] = true,
Actions = true,
["Steal Panel"] = true,
["Steal Target"] = true,
["Bottom Bar"] = true,
},
actions = {
["Ragdoll Self (R)"] = true,
["Rejoin PS"] = true,
["Rejoin Job ID (J)"] = true,
["Kick (Y)"] = true,
["Kick To Private"] = true,
["Reset (X)"] = true,
Teleport = true,
["Spam Best Owner"] = true,
Menu = true,
["Anti Ragdoll"] = true,
["Infinite Jump"] = true,
Float = true,
["Carpet Speed"] = true,
["Auto Turret"] = true,
WalkSpeed = true,
["FPS Boost"] = false,
Xray = false,
["Player ESP"] = false,
["Brainrot ESP"] = false,
["Base Owner ESP"] = false,
["Remote Sell Panel"] = false,
Unwalk = false,
["Admin Panel UI"] = false,
},
AutoTPPriority = true,
AutoTPHighestGen = false,
AutoTPHighestValue = false,
TpSettings = {
Tool = "Waverider",
TpOnLoad = true,
TpOnLoadDelay = 0,
GrabbleTP = false,
ApproachFloor2From1 = false,
GrabbleTPSpeed = 450,
WalkTPSpeed = 190,
CloneDelayVal = 0.25,
MinGenForTp = "",
MinGenForGrab = "",
},
PlayerESP = true,
BrainrotESP = true,
TimerESP = false,
SubspaceMineESP = false,
BaseOwnerESP = false,
LineToBase = false,
LineToBrainrot = false,
InstantClone = true,
AutoUnlockOnSteal = false,
InvisibleSteal = false,
Unwalk = false,
OpenBase = false,
AntiRagdoll = false,
InfiniteJump = false,
Float = false,
CarpetSpeed = false,
AutoKickOnSteal = false,
KickToPrivateServer = false,
PrivateServerCode = "",
AutoResetBalloon = false,
AntiFlasher = false,
AntiBeeDisco = false,
AntiKnockback = false,
AntiAdmin = false,
AntiBodySwap = false,
AntiBee = false,
AntiBoogie = false,
AntiGummy = false,
InvisTrueView = false,
InvisAutoAngle = false,
RemoteSellEnabled = false,
AdminPanelUI = true,
CleanErrorGUIs = false,
AutoCloseOnExec = false,
PrioritySoundAlert = false,
PrioritySoundID = "",
FPSBoost = false,
Optimizer = false,
XRay = false,
FOV = 70,
AutoStealEnabled = true,
StealMode = "Priority",
StealHighest = false,
StealPriority = true,
StealNearest = false,
AutoBuyEnabled = false,
AutoDestroyTurrets = false,
InvisStealAngle = 225,
SinkSliderValue = 7,
AutoInvisDuringSteal = false,
WalkSpeedEnabled = false,
WalkSpeedValue = 16,
ClickToAP = false,
ProximityAP = false,
ProximityRange = 15,
ClickToAPSingleCommand = false,
ClickToAPRadius = 8,
SonEspTag = false,
FmlyEspTag = false,
SonApiEnabled = true,
GriefSafeGood = false,
SpamBaseOwnerSingleCommand = false,
AutoSellDeliver = false,
EspIncoming = false,
EspBestHighlight = true,
EspPlayerStealing = true,
EspPlayerInBase = true,
AdminPanelButtons = {
ragdoll = true,
jail = true,
rocket = true,
balloon = true,
},
ClickToAPCommands = v7855(true),
SpamBaseOwnerCommands = v7855(true),
AdminPanelOrder = copy(ap),
ClickToAPOrder = copy(ap),
}
local v7860 = copy
local v7861
while true do
c.SpamBaseOwnerOrder = v7860(ap)
c.apBlacklist = {}
c.apBlacklistNames = {}
c.MutationPriorityOn = true
c.MutOrder = {
"Phantom",
"Bloodrot",
"Cyber",
"Yin Yang",
"Radioactive",
"Crystal",
"Divine",
"Cursed",
"Galaxy",
"Lava",
"Rainbow",
"Candy",
"Diamond",
"Gold",
"Eclipse",
}
c.PriorityList = {
"Headless Horseman",
"Strawberry Elephant",
"Hydra Bunny Egg",
"Polaroidini",
"Signore Carapace",
"Meowl",
"Orchidox",
"Plant Bros",
"John Pork",
"Skibidi Toilet",
"Los Dragons",
"Arcadragon",
"Elefanto Frigo",
"Phoenix",
"Griffin",
"Dragon Skeletonini",
"Love Love Bear",
"Antonio",
"Dragon Gingerini",
"Dragon Aquanini",
"Kalika Bros",
"La Supreme Combinasion",
"Digi Narwhal",
"Kraken",
"Fishino Clownino",
"Tirilikalika Tirilikalako",
"Ginger Gerat",
"Moby Bros",
"Hydra Bunny",
"Jelly Moby",
"Hydra Dragon Cannelloni",
"Pancake and Syrup",
"Grabatron",
"Draculino",
"Bunny and Eggy",
"Cola Cat",
"Dragon Cannelloni",
"Hydra Serpent",
"Venuspino",
"Ketupat Bros",
"Popcuru and Fizzuru",
"La Casa Boo",
"Sammyni Cakini",
"Foxini Lanternini",
"Pizza and Ranch",
"Rico Dinero",
"Globa Steppa",
"Bumbatron",
"Guest 666",
"Rubiko and Kubiko",
"Rubrikiko",
"Cooki and Milki",
"Fragrama and Chocrama",
"Spooky and Pumpky",
"Lazy Ducky",
"Capitano Moby",
"Burguro and Fryuro",
"Reinito Sleighito",
"Examen Bros",
"Gym Bros",
"Los Tictacs",
"Garama and Madundung",
"La Secret Combinasion",
"Cash or Card",
"Celestial Pegasus",
"Fragola La La La",
}
c.RemovedFromPriority = {}
t15.C = c
t15.defaults = copy(c)
v7860 = {
PriorityList = true,
RemovedFromPriority = true,
MutOrder = true,
apBlacklistNames = true,
AdminPanelOrder = true,
ClickToAPOrder = true,
SpamBaseOwnerOrder = true,
}
t15.merge = function(p1081)
for k, v in pairs(p1081) do
if type(v) == "table" then
if type(c[k]) == "table" and not v7860[k] then
for k2, v2 in pairs(v) do
c[k][k2] = v2
end
continue
end
end
c[k] = v
end
for k, default in pairs(t15.defaults) do
if type(default) == "table" and type(c[k]) ~= "table" then
c[k] = copy(default)
end
end
if #c.MutOrder == 0 then
c.MutOrder = copy(t15.defaults.MutOrder)
end
if #c.PriorityList == 0 then
c.PriorityList = copy(t15.defaults.PriorityList)
end
local n736 = 721250017
local t297 = {}
local priorityList = {}
local v7871, v7872, v7873 = ipairs(c.PriorityList)
for _, v in v7871, v7872, v7873 do
if type(v) == "string" and not t297[v] then
t297[v] = true
if n4 == n2 then
n4 += 1934
n736 += 511
n1 -= 1602
n2 -= 262
n735 = 1071754465
n734 = 985504051
local v7876, v7877
v7871, v7876, v7877 = v7871(c.PriorityList)
else
priorityList[#priorityList + 1] = v
end
end
end
c.PriorityList = priorityList
end
v7861 = type(readfile) == "function" and type(writefile) == "function" and type(isfile) == "function"
if v7861 then
pcall(function()
if isfile("sxe_ui_config.json") then
local data = HttpService:JSONDecode(readfile("sxe_ui_config.json"))
if type(data) == "table" then
t15.merge(data)
end
end
end)
end
if (tonumber(c.PrioListV) or 0) < 1 then
c.PrioListV = 1
c.PriorityList = copy(t15.defaults.PriorityList)
c.RemovedFromPriority = {}
end
if not ((tonumber(c.TpEngine) or 0) < 2) then
break
end
if n2 ~= n735 then
c.TpEngine = 2
c.TpSettings.GrabbleTPSpeed = 450
c.TpSettings.CloneDelayVal = 0.25
c.TpSettings.Tool = "Waverider"
c.TpSettings.TpOnLoad = true
break
end
n4 += 78
n1 = 516966574
n2 = 468970845
n735 -= 986
n734 -= 1270
if false then
c.TpSettings.GrabbleTPSpeed = 450
c.TpSettings.CloneDelayVal = 0.25
c.TpSettings.Tool = "Waverider"
c.TpSettings.TpOnLoad = true
break
end
end
t15.normalize = function()
c.Accent = "Pink"
if c.StealMode ~= "Nearest" then
c.StealMode = "Priority"
end
c.StealHighest = false
c.StealPriority = c.StealMode == "Priority"
c.StealNearest = c.StealMode == "Nearest"
c.AutoTPHighestGen = false
c.AutoTPHighestValue = false
c.WalkSpeedValue = math.clamp(tonumber(c.WalkSpeedValue) or 16, 16, 28)
c.SinkSliderValue = math.clamp(tonumber(c.SinkSliderValue) or 7, 0.5, 10)
c.InvisStealAngle = math.clamp(tonumber(c.InvisStealAngle) or 225, 0, 360)
for _, v in ipairs({
"ESPTag",
"DisableClickAPOn",
"DisableProxAPOn",
"DisableAPPanelOn",
}) do
c[v .. "WNotifier"] = nil
end
c.AntiPaintball = nil
c.AntiWeb = nil
c.InfiniteFPS = nil
local t298 = {}
for _, v in ipairs(c.MutOrder) do
if type(v) == "string" then
t298[v:lower():gsub("%s+", "")] = true
end
end
for _, v in ipairs(t15.defaults.MutOrder) do
if not t298[v:lower():gsub("%s+", "")] then
c.MutOrder[#c.MutOrder + 1] = v
end
end
end
t15.normalize()
c.ClickToAP = false
c.ProximityAP = false
c.InvisibleSteal = false
c.CarpetSpeed = false
c.AutoBuyEnabled = false
local u7886 = false
t15.save = function()
u7886 = true
end
t15.flush = function()
u7886 = false
local n737 = 260919403
local n738 = 36980007
local n739 = 705801300
local n740 = 638911565
local n741
if v7861 then
pcall(function()
n741 = 810669080
if n2 ~= n740 then
writefile("sxe_ui_config.json", HttpService:JSONEncode(c))
return
end
n737 += 103
n2 = 672669163
n739 += 1779
n740 -= 1487
n738 -= 1482
n741 -= 868
n4 = 202818176
local v7892 = (nil)(nil);
(nil)(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
v7892,
}, 1, 318))
return (nil)()
end)
end
end
task.spawn(function()
while t15.sg == nil or t15.sg.Parent do
task.wait(0.5)
if u7886 then
t15.flush()
end
end
end)
local t299 = {}
local function v7894(p1082)
local v7895 = t299[p1082]
if not v7895 then
v7895 = {}
for match in string.gmatch(p1082, "[^%.]+") do
v7895[#v7895 + 1] = match
end
t299[p1082] = v7895
end
return v7895
end
t15.get = function(p1083)
local v7897 = c
local v7898 = v7894(p1083)
for i = 1, #v7898 - 1 do
v7897 = v7897[v7898[i]]
if type(v7897) == "table" then
continue
end
return nil
end
return v7897[v7898[#v7898]]
end
local function v7900(p1084, p1085)
local v7901 = c
local v7902 = v7894(p1084)
for i = 1, #v7902 - 1 do
local v7904 = v7901[v7902[i]]
if type(v7904) ~= "table" then
v7904 = {}
v7901[v7902[i]] = v7904
end
v7901 = v7904
end
v7901[v7902[#v7902]] = p1085
end
local t300 = {}
t15.bind = function(p1086, p1087)
local v7906 = t300[p1086]
if not v7906 then
v7906 = {}
t300[p1086] = v7906
end
v7906[#v7906 + 1] = p1087
local newBinds = t15.newBinds
if newBinds then
newBinds[#newBinds + 1] = {
p1086,
p1087,
}
end
end
t15.notify = function(p1088)
local v7908 = t15.get(p1088)
local v7909 = t300[p1088] or {}
for _, v in ipairs(v7909) do
pcall(v, v7908)
end
end
t15.refreshAll = function()
for k, v in pairs(t300) do
local v7914 = t15.get(k)
for _, v2 in ipairs(v) do
pcall(v2, v7914)
end
end
if n734 == 638641986 then
n2 = 527350940
n1 = 828318517
n4 -= 2016
n735 -= 344
n734 = 369349380
upv482 = nil
end
end
t15.queue = {}
t15.equeue = {}
local n742
local n743
t15.later = function(p1089)
n742 = 153265763
n743 = 189042070
if n4 == n742 then
n734 += 1849
n743 += 1456
n735 += 300
n1 -= 1456
n4 += 1077
n2 = 385899871
n742 -= 414
else
t15.queue[#t15.queue + 1] = p1089
end
end
t15.lateEngine = function(p1090)
t15.equeue[#t15.equeue + 1] = p1090
end
t15.yield = function()
if t15.building then
task.wait()
end
end
t15.set = function(p1091, p1092, p1093)
v7900(p1091, p1092)
t15.save()
t15.notify(p1091)
if p1093 then
t15.hook(p1093, p1092)
end
t15.hook("Changed", p1091, p1092)
end
local function v7919(p1094)
local value = rawget(_G, p1094)
return type(value) == "function" and value or nil
end
local function v7921(p1095, ...)
local v7922 = v7919(p1095)
if v7922 then
v7922(...)
end
end
local t301 = {
Antiflasher = function(p1096)
v7921("SXE_setAntiFlasher", p1096)
end,
["Auto Steal"] = function(p1097)
local v7924
while true do
local v7925
local v7926
local v7927 = p1097
v7921("SXEAutoSteal", v7927)
if n4 ~= n1 then
return
end
n735 = 386167746
n734 = 631327100
n2 = 521088854
n1 -= 1666
n4 += 1294
v7924 = v7924(nil, nil)
local v7928 = table.pack(__0())
if not v7928[1] then
break
end
v7925[82] = 151
v7926[105] = 81
end
end,
["Steal Mode"] = function(p1098)
v7921("SXEStealMode", p1098)
if n2 ~= 557240548 then
n1 = 428002113
n4 = 244728476
n734 = 109682138
n2 = 425089665
n735 = 604262239
(nil)();
(nil)[nil] = p1098
end
end,
["Grabble TP Speed"] = function(p1099)
v7921("SXESetCarpetSpeed", p1099)
end,
["Grabble TP"] = function(p1100)
v7921("SXEAutoSteal", p1100 and c.AutoStealEnabled == true)
end,
Teleport = function()
_G.SXEForceGrappleTP = true
v7921("SXE_ExecuteManualTP")
if not (n2 < 895382577) then
n1 = 243841232
n734 = 949995015
n735 -= 604
n2 -= 1656
n4 = 912304094
bit32.band(nil, nil)
end
end,
["Manual TP"] = function()
_G.SXEForceGrappleTP = true
v7921("SXE_ExecuteManualTP")
end,
}
t15.NATIVE = {}
t15.NASK = {}
local n744
local n745
local function v7931()
n744 = 766488634
n745 = 769062272
local value = rawget(_G, "SXE_UI_Hooks")
if type(value) == "table" then
if not (n2 < n4) then
n735 -= 1632
n2 = 521930644
local v7933 = n744 - 1441
n744 = v7933
n1 = 740750276
n734 = 147245253
n4 += 2002
n745 += 424
return
end
else
if type(getgenv) == "function" then
local ok, result = pcall(getgenv)
if ok and type(result) == "table" then
value = rawget(result, "SXE_UI_Hooks")
end
end
if not (n2 < n4) then
n735 -= 1632
n2 = 521930644
n744 -= 1441
n1 = 740750276
n734 = 147245253
n4 += 2002
n745 += 424
return
end
end
return type(value) == "table" and value or nil
end
t15.hook = function(p1101, ...)
local v7936 = v7931()
local v7937 = v7936 and v7936[p1101]
local n746 = 131831258
if type(v7937) ~= "function" then
v7937 = t15.NATIVE[p1101]
end
if type(v7937) ~= "function" then
v7937 = t301[p1101]
end
if type(v7937) ~= "function" then
return false
end
local v7939 = table.pack(...)
if n746 == n1 then
n735 += 1290
n2 = 931168177
n734 = 797987995
n4 = 140481891
n1 = 808407111
getfenv()[nil] = nil
else
task.spawn(function()
local ok, result = pcall(v7937, table.unpack(v7939, 1, v7939.n))
if not ok then
warn("[SXE UI] " .. tostring(p1101) .. ": " .. tostring(result))
end
end)
end
return true
end
t15.ask = function(p1102, ...)
local v7942 = v7931()
local v7943 = v7942 and v7942[p1102]
if type(v7943) ~= "function" then
v7943 = t15.NASK[p1102]
end
if type(v7943) == "function" then
local ok, result, result2 = pcall(v7943, ...)
if ok then
return result, result2
end
end
return nil
end
end
v7847()
local function v7947()
local n747 = 850151237
t15.T = {
Bg = color3(14, 14, 19),
Card = color3(21, 21, 28),
Row = color3(29, 29, 38),
RowH = color3(38, 38, 50),
Line = color3(45, 45, 58),
Text = color3(241, 241, 245),
Dim = color3(157, 157, 171),
Off = color3(59, 59, 72),
Ok = color3(56, 214, 110),
Bad = color3(235, 87, 87),
Warn = color3(255, 216, 77),
Blue = color3(79, 182, 240),
White = color3(255, 255, 255),
}
local acc = {
Pink = {
color3(232, 111, 177),
color3(42, 15, 31),
},
White = {
color3(242, 242, 245),
color3(20, 20, 24),
},
Cream = {
color3(232, 220, 198),
color3(36, 30, 22),
},
Blue = {
color3(127, 180, 240),
color3(12, 26, 43),
},
}
t15.ACC = acc
t15.ACCORDER = {
"Pink",
"White",
"Cream",
"Blue",
}
local obj = setmetatable({}, {
__mode = "k",
})
local t302 = {}
local Pink = acc[t15.C.Accent] or acc.Pink
local v7953 = Pink[2]
t15.A = Pink[1]
t15.I = v7953
local n748 = 761569049
t15.paint = function(p1103, p1104, p1105)
local v7955 = obj[p1103]
if not v7955 then
v7955 = {}
obj[p1103] = v7955
end
v7955[p1104] = p1105
p1103[p1104] = p1105 == "i" and t15.I or t15.A
return p1103
end
if n4 == n1 then
n4 = 816296669
n748 += 1226
n2 = 1022972188
n1 = 962721006
n747 += 1541
(nil)[304] = nil
(nil)[305] = nil
(nil)[306] = nil
(nil)[307] = nil
(nil)[308] = nil
(nil)[309] = nil
(nil)[310] = nil
(nil)[311] = nil
(nil)[312] = nil
(nil)[313] = nil
(nil)[314] = nil
(nil)[315] = nil
(nil)[316] = nil
(nil)[317] = nil
(nil)[318] = nil
(nil)[319] = nil
(nil)[320] = nil
(nil)[321] = nil
(nil)[322] = nil
(nil)[323] = nil
(nil)[324] = nil
(nil)[325] = nil
(nil)[326] = nil
(nil)[327] = nil
(nil)[328] = nil
(nil)[329] = nil
(nil)[330] = nil
(nil)[331] = nil
(nil)[332] = nil
(nil)[333] = nil
(nil)[334] = nil
(nil)[335] = nil
(nil)[336] = nil
(nil)[337] = nil
(nil)[338] = nil
(nil)[339] = nil
(nil)[340] = nil
(nil)[341] = nil
(nil)[342] = nil
(nil)[343] = nil
(nil)[344] = nil
(nil)[345] = nil
(nil)[346] = nil
(nil)[347] = nil
(nil)[348] = nil
(nil)[349] = nil
(nil)[350] = nil
(nil)[351] = nil
(nil)[352] = nil
(nil)[353] = nil
(nil)[354] = nil
(nil)[355] = nil
(nil)[356] = nil
(nil)[357] = nil
(nil)[358] = nil
(nil)[359] = nil
(nil)[360] = nil
(nil)[361] = nil
(nil)[362] = nil
(nil)[363] = nil
(nil)[364] = nil
(nil)[365] = nil
(nil)[366] = nil
(nil)[367] = nil
(nil)[368] = nil
(nil)[369] = nil
(nil)[370] = nil
(nil)[371] = nil
(nil)[372] = nil
(nil)[373] = nil
(nil)[374] = nil
(nil)[375] = nil
(nil)[376] = nil
(nil)[377] = nil
(nil)[378] = nil
(nil)[379] = nil
(nil)[380] = nil
(nil)[381] = nil
(nil)[382] = nil
(nil)[383] = nil
(nil)[384] = nil
(nil)[385] = nil
(nil)[386] = nil
(nil)[387] = nil
(nil)[388] = nil
(nil)[389] = nil
(nil)[390] = nil
(nil)[391] = nil
(nil)[392] = nil
(nil)[393] = nil
(nil)[394] = nil
(nil)[395] = nil
(nil)[396] = nil
(nil)[397] = nil
(nil)[398] = nil
(nil)[399] = nil
(nil)[400] = nil
(nil)[401] = nil
(nil)[402] = nil
(nil)[403] = nil
(nil)[404] = nil
(nil)[405] = nil
(nil)[406] = nil
(nil)[407] = nil
(nil)[408] = nil
(nil)[409] = nil
(nil)[410] = nil
(nil)[411] = nil
(nil)[412] = nil
(nil)[413] = nil
(nil)[414] = nil
(nil)[415] = nil
(nil)[416] = nil
(nil)[417] = nil
(nil)[418] = nil
(nil)[419] = nil
(nil)[420] = nil
(nil)[421] = nil
(nil)[422] = nil
(nil)[423] = nil
(nil)[424] = nil
(nil)[425] = nil
(nil)[426] = nil
(nil)[427] = nil
(nil)[428] = nil
(nil)[429] = nil
(nil)[430] = nil
(nil)[431] = nil
(nil)[432] = nil
(nil)[433] = nil
(nil)[434] = nil
(nil)[435] = nil
(nil)[436] = nil
(nil)[437] = nil
(nil)[438] = nil
(nil)[439] = nil
(nil)[440] = nil
(nil)[441] = nil
(nil)[442] = nil
(nil)[443] = nil
(nil)[444] = nil
(nil)[445] = nil
(nil)[446] = nil
(nil)[447] = nil
(nil)[448] = nil
(nil)[449] = nil
(nil)[450] = nil
(nil)[451] = nil
(nil)[452] = nil
(nil)[453] = nil
(nil)[454] = nil
(nil)[455] = nil
(nil)[456] = nil
(nil)[457] = nil
(nil)[458] = nil
(nil)[459] = nil
(nil)[460] = nil
(nil)[461] = nil
(nil)[462] = nil
(nil)[463] = nil
(nil)[464] = nil
(nil)[465] = nil
(nil)[466] = nil
(nil)[467] = nil
(nil)[468] = nil
(nil)[469] = nil
(nil)[470] = nil
(nil)[471] = nil
(nil)[472] = nil
(nil)[473] = nil
(nil)[474] = nil
(nil)[475] = nil
(nil)[476] = nil
(nil)[477] = nil
(nil)[478] = nil
(nil)[479] = nil
(nil)[480] = nil
(nil)[481] = nil
(nil)[482] = nil
(nil)[483] = nil
(nil)[484] = nil
(nil)[485] = nil
(nil)[486] = nil
(nil)[487] = nil
(nil)[488] = nil
(nil)[489] = nil
(nil)[490] = nil
(nil)[491] = nil
(nil)[492] = nil
(nil)[493] = nil
(nil)[494] = nil
(nil)[495] = nil
(nil)[496] = nil
(nil)[497] = nil
(nil)[498] = nil
(nil)[499] = nil
(nil)[500] = nil
(nil)[501] = nil
(nil)[502] = nil
(nil)[503] = nil
(nil)[504] = nil
(nil)[505] = nil
(nil)[506] = nil
(nil)[507] = nil
(nil)[508] = nil
(nil)[509] = nil
(nil)[510] = nil
(nil)[511] = nil
(nil)[512] = nil
(nil)[513] = nil
(nil)[514] = nil
(nil)[515] = nil
(nil)[516] = nil
(nil)[517] = nil
(nil)[518] = nil
(nil)[519] = nil
(nil)[520] = nil
(nil)[521] = nil
(nil)[522] = nil
(nil)[523] = nil
(nil)[524] = nil
(nil)[525] = nil
(nil)[526] = nil
(nil)[527] = nil
(nil)[528] = nil
(nil)[529] = nil
(nil)[530] = nil
(nil)[531] = nil
(nil)[532] = nil
(nil)[533] = nil
(nil)[534] = nil
(nil)[535] = nil
(nil)[536] = nil
(nil)[537] = nil
(nil)[538] = nil
(nil)[539] = nil
(nil)[540] = nil
(nil)[541] = nil
(nil)[542] = nil
(nil)[543] = nil
(nil)[544] = nil
(nil)[545] = nil
(nil)[546] = nil
(nil)[547] = nil
(nil)[548] = nil
(nil)[549] = nil
(nil)[550] = nil
(nil)[551] = nil
(nil)[552] = nil
(nil)[553] = nil
(nil)[554] = nil
(nil)[555] = nil
(nil)[556] = nil
(nil)[557] = nil
(nil)[558] = nil
(nil)[559] = nil
(nil)[560] = nil
(nil)[561] = nil
(nil)[562] = nil
(nil)[563] = nil
(nil)[564] = nil
(nil)[565] = nil
(nil)[566] = nil
(nil)[567] = nil
(nil)[568] = nil
(nil)[569] = nil
(nil)[570] = nil
(nil)[571] = nil
(nil)[572] = nil
(nil)[573] = nil
(nil)[574] = nil
(nil)[575] = nil
(nil)[576] = nil
(nil)[577] = nil
(nil)[578] = nil
(nil)[579] = nil
(nil)[580] = nil
(nil)[581] = nil
(nil)[582] = nil
(nil)[583] = nil
(nil)[584] = nil
(nil)[585] = nil
(nil)[586] = nil
(nil)[587] = nil
(nil)[588] = nil
(nil)[589] = nil
(nil)[590] = nil
(nil)[591] = nil
(nil)[592] = nil
(nil)[593] = nil
(nil)[594] = nil
(nil)[595] = nil
(nil)[596] = nil
(nil)[597] = nil
(nil)[598] = nil
(nil)[599] = nil
(nil)[600] = nil
(nil)[601] = nil
(nil)[602] = nil
(nil)[603] = nil
(nil)[604] = nil
(nil)[605] = nil
(nil)[606] = nil
(nil)[607] = nil
(nil)[608] = nil
(nil)[609] = nil
(nil)[610] = nil
(nil)[611] = nil
(nil)[612] = nil
(nil)[613] = nil
(nil)[614] = nil
(nil)[615] = nil
(nil)[616] = nil
(nil)[617] = nil
(nil)[618] = nil
(nil)[619] = nil
(nil)[620] = nil
(nil)[621] = nil
(nil)[622] = nil
(nil)[623] = nil
(nil)[624] = nil
(nil)[625] = nil
(nil)[626] = nil
(nil)[627] = nil
(nil)[628] = nil
(nil)[629] = nil
(nil)[630] = nil
(nil)[631] = nil
(nil)[632] = nil
(nil)[633] = nil
(nil)[634] = nil
(nil)[635] = nil
(nil)[636] = nil
(nil)[637] = nil
(nil)[638] = nil
(nil)[639] = nil
(nil)[640] = nil
(nil)[641] = nil
(nil)[642] = nil
(nil)[643] = nil
(nil)[644] = nil
(nil)[645] = nil
(nil)[646] = nil
(nil)[647] = nil
(nil)[648] = nil
(nil)[649] = nil
(nil)[650] = nil
(nil)[651] = nil
(nil)[652] = nil
(nil)[653] = nil
(nil)[654] = nil
(nil)[655] = nil
(nil)[656] = nil
(nil)[657] = nil
(nil)[658] = nil
(nil)[659] = nil
(nil)[660] = nil
(nil)[661] = nil
(nil)[662] = nil
(nil)[663] = nil
(nil)[664] = nil
(nil)[665] = nil
(nil)[666] = nil
(nil)[667] = nil
(nil)[668] = nil
(nil)[669] = nil
(nil)[670] = nil
(nil)[671] = nil
(nil)[672] = nil
(nil)[673] = nil
(nil)[674] = nil
(nil)[675] = nil
(nil)[676] = nil
(nil)[677] = nil
(nil)[678] = nil
(nil)[679] = nil
(nil)[680] = nil
(nil)[681] = nil
(nil)[682] = nil
(nil)[683] = nil
(nil)[684] = nil
(nil)[685] = nil
(nil)[686] = nil
(nil)[687] = nil
(nil)[688] = nil
(nil)[689] = nil
(nil)[690] = nil
(nil)[691] = nil
(nil)[692] = nil
(nil)[693] = nil
(nil)[694] = nil
(nil)[695] = nil
end
t15.onAccent = function(p1106)
t302[#t302 + 1] = p1106
end
t15.setAccent = function(p1107)
local v7956 = acc[p1107]
if not v7956 then
return
end
t15.C.Accent = p1107
t15.save()
local v7957 = v7956[2]
t15.A = v7956[1]
t15.I = v7957
for k, v in pairs(obj) do
for k2, v2 in pairs(v) do
pcall(function()
k[k2] = v2 == "i" and t15.I or t15.A
end)
end
end
for _, v in ipairs(t302) do
pcall(v)
end
end
end
v7947()
local function v7964()
local n749 = 856696722
local hui
local n750 = 874734750
local n751 = 949831829
pcall(function()
if type(gethui) == "function" then
hui = gethui()
end
end)
if not hui then
pcall(function()
hui = game:GetService("CoreGui")
end)
end
hui = hui or LocalPlayer:WaitForChild("PlayerGui")
pcall(function()
local SXEHubUI = hui:FindFirstChild("SXEHubUI")
if SXEHubUI then
SXEHubUI:Destroy()
end
end)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SXEHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 9999990
if not pcall(function()
ScreenGui.Parent = hui
end) then
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end
local Frame = Instance.new("Frame")
Frame.Name = "Root"
Frame.BackgroundTransparency = 1
Frame.BorderSizePixel = 0
Frame.Size = UDim2.fromScale(1, 1)
Frame.Parent = ScreenGui
local UIScale = Instance.new("UIScale")
UIScale.Parent = Frame
t15.sg = ScreenGui
t15.root = Frame
t15.scale = 1
local u7973
local function v7974()
if not workspace.CurrentCamera then
return
end
local Y = workspace.CurrentCamera.ViewportSize.Y
local TouchEnabled = UserInputService.TouchEnabled
TouchEnabled = TouchEnabled and math.clamp(Y / 1000, 0.4, 0.58) or math.clamp(Y / 800, 0.65, 1)
t15.scale = TouchEnabled
UIScale.Scale = TouchEnabled
Frame.Size = UDim2.fromScale(1 / TouchEnabled, 1 / TouchEnabled)
for _, scaleFn in ipairs(t15.scaleFns) do
pcall(scaleFn)
end
end
t15.onScale = function(p1108)
t15.scaleFns[#t15.scaleFns + 1] = p1108
end
local n752
local function v7980()
n752 = 422265298
if u7973 then
u7973:Disconnect()
end
local n753 = 977568305
if workspace.CurrentCamera then
u7973 = v222(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), v7974)
v7974()
end
if n753 == n1 then
n750 = 603212748
n1 = 797048687
n751 = 845460
n2 += 325
n752 += 1466
n4 += 1525
n749 -= 477
upv405[nil] = nil
(nil)()
end
end
v222(workspace:GetPropertyChangedSignal("CurrentCamera"), v7980)
v7980()
local t303
local function v7983(p1109)
if n1 == 104592110 then
return p1109.UserInputType == Enum.UserInputType.MouseButton1
or p1109.UserInputType == Enum.UserInputType.Touch
end
n750 += 2002
n749 += 1594
n2 = 770169592
n4 += 862
n751 = 619545969
n1 = 623256918
LPH_CRASH()
end
t15.drag = function(p1110, p1111, p1112)
p1111.InputBegan:Connect(function(input)
if not t15.C.locked then
if v7983(input) then
t303 = {
f = p1110,
s = input.Position,
p = p1110.Position,
n = p1112,
}
return
end
end
end)
end
t15.resizer = function(p1113, p1114, p1115, p1116)
p1113:SetAttribute("SXEResize", true)
local n754 = 587477665
local TextButton = v225("TextButton", {
AutoButtonColor = false,
BackgroundTransparency = 1,
Text = "◢",
TextSize = 11,
Font = Enum.Font.GothamBold,
TextColor3 = t15.T.Dim,
Size = uDim2New(0, 16, 0, 16),
Position = uDim2New(1, -17, 1, -17),
ZIndex = 30,
}, p1113)
local n755 = 540632721
local n756 = 502469803
TextButton.InputBegan:Connect(function(input)
if not t15.C.locked then
if v7983(input) then
t303 = {
f = p1113,
s = input.Position,
z = p1113.AbsoluteSize / t15.scale,
mx = p1114,
my = p1115,
n = p1116,
r = true,
}
return
end
end
end)
if n756 ~= n751 then
return TextButton
end
n1 -= 1053
n751 -= 1395
n2 = 241806356
n754 += 36
n749 += 1121
n750 -= 457
n755 += 466
n4 -= 735
n756 += 989
bit32.bxor(nil, nil);
(nil)()
end
v222(UserInputService.InputChanged, function(p1117)
if not t303 then
return
end
if
p1117.UserInputType ~= Enum.UserInputType.MouseMovement
and p1117.UserInputType ~= Enum.UserInputType.Touch
then
return
end
local v7988 = (p1117.Position - t303.s) / t15.scale
if t303.r then
t303.f.Size =
uDim2New(0, math.max(t303.mx, t303.z.X + v7988.X), 0, math.max(t303.my, t303.z.Y + v7988.Y))
else
t303.f.Position =
uDim2New(t303.p.X.Scale, t303.p.X.Offset + v7988.X, t303.p.Y.Scale, t303.p.Y.Offset + v7988.Y)
end
end)
v222(UserInputService.InputEnded, function(p1118)
if not t303 or not v7983(p1118) then
return
end
local v7989 = t303
t303 = nil
if not v7989.n then
return
end
if v7989.r then
t15.C.sizes[v7989.n] = {
x = v7989.f.Size.X.Offset,
y = v7989.f.Size.Y.Offset,
}
else
local Position = v7989.f.Position
t15.C.positions[v7989.n] = {
xs = Position.X.Scale,
xo = Position.X.Offset,
ys = Position.Y.Scale,
yo = Position.Y.Offset,
}
end
t15.save()
end)
t15.place = function(p1119, p1120)
local v7991 = t15.C.positions[p1120]
if type(v7991) == "table" then
p1119.Position = uDim2New(v7991.xs or 0, v7991.xo or 0, v7991.ys or 0, v7991.yo or 0)
end
local v7992 = t15.C.sizes[p1120]
if
type(v7992) == "table"
and p1119:GetAttribute("SXEResize")
and tonumber(v7992.x)
and tonumber(v7992.y)
then
p1119.Size = uDim2New(0, v7992.x, 0, v7992.y)
end
end
local n757
t15.resetPositions = function()
n757 = 368137661
t15.C.positions = {}
t15.C.sizes = {}
if n751 ~= 949831829 then
n750 -= 1928
n749 -= 1235
n751 -= 1403
n4 -= 811
n757 -= 1325
n1 += 127
n2 -= 1665
(nil)()
return nil
end
t15.save()
for _, frame in pairs(t15.frames) do
frame.f.Position = frame.def
if frame.size then
frame.f.Size = frame.size
end
end
end
end
v7964()
v232 = function()
local n758 = 96156991
local T = t15.T
local Y = Enum.AutomaticSize.Y
local n759 = 654751335
t15.tag = function(p1121, p1122)
p1121:SetAttribute("SXELabel", string.lower(p1122))
return p1121
end
t15.hide = function(p1123, p1124)
local v8000 = p1123
local SetAttribute = p1123.SetAttribute
local s30 = "SXEHidden"
local v8003 = p1124
SetAttribute(v8000, s30, v8003 and true or nil)
p1123.Visible = not p1124
end
t15.card = function(p1125, p1126)
local Frame = v225("Frame", {
BackgroundColor3 = T.Card,
BorderSizePixel = 0,
Size = uDim2New(1, 0, 0, 0),
AutomaticSize = Y,
}, p1125)
v226(Frame, 10)
v227(Frame, T.Line, 1, 0)
v228(Frame, 10, 10, 4, 6)
v229(Frame, 2)
Frame:SetAttribute("SXECard", true)
local Frame2 = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 24),
}, Frame)
v231(Frame2, p1126, 11, T.Dim, Enum.Font.GothamBold, {
Size = uDim2New(1, -48, 1, 0),
TextTruncate = Enum.TextTruncate.AtEnd,
})
return Frame, Frame2
end
t15.grid = function(
p1127,
p1128,
p1129,
p1130,
p1131,
p1132,
p1133,
p1134,
p1135,
p1136,
p1137,
p1138,
p1139,
p1140
)
local n760 = 263651970
local v8007 = tonumber(p1128) or 30
local v8008 = tonumber(p1129) or 2
local v8009 = tonumber(p1130) or 14
local v8010 = tonumber(p1131) or 0
local n761 = 146713777
local Frame = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 0),
}, p1127)
Frame:SetAttribute("SXEGrid", true)
local n762 = 301334224
local u8014 = false
local function v8015()
u8014 = false
local t304 = {}
for _, child in ipairs(Frame:GetChildren()) do
if child:IsA("GuiObject") and child.Visible then
t304[#t304 + 1] = child
end
end
table.sort(t304, function(p1141, p1142)
return p1141.LayoutOrder < p1142.LayoutOrder
end)
local v8019 = v8009 * (v8008 - 1) / v8008
for i, v in ipairs(t304) do
local v8022 = (i - 1) % v8008
local v8023 = math.floor((i - 1) / v8008)
v.Size = uDim2New(1 / v8008, -v8019, 0, v8007)
v.Position = uDim2New(v8022 / v8008, v8022 * v8009 / v8008, 0, v8023 * (v8007 + v8010))
end
local v8024 = math.ceil(#t304 / v8008)
Frame.Size = uDim2New(1, 0, 0, v8024 > 0 and v8024 * v8007 + (v8024 - 1) * v8010 or 0)
end
local n763
local n764
local function v8027()
n763 = 312464621
n764 = 773091282
if not u8014 then
u8014 = true
task.defer(v8015)
end
end
local n765
if n1 == n759 then
n762 += 1010
n760 += 947
n4 += 422
n1 -= 1083
n759 += 1791
n758 = 1027526675
n761 += 288
n2 = 959721404
(nil)[40] = 10 + nil
v8007 = p1128
v8008 = p1129
v8009 = p1130
v8010 = p1131
n760 = p1132
n761 = p1133
Frame = p1134
n762 = p1135
u8014 = p1136
n763 = p1138
n764 = p1139
v8027 = p1140
else
Frame.ChildAdded:Connect(function(child)
local n766 = 743915795
n765 = 77086093
if child:IsA("GuiObject") then
child:GetPropertyChangedSignal("Visible"):Connect(v8027)
end
v8027()
if n761 < n766 then
return
end
n4 = 475340086
n759 += 178
n2 -= 1010
n765 -= 106
n761 += 1045
n762 += 450
n760 = 517273442
return nil
end)
end
Frame.ChildRemoved:Connect(v8027)
return Frame
end
t15.switch = function(p1143, p1144, p1145, p1146)
local Frame = p1146
and v225("Frame", {
Size = uDim2New(0, 34, 0, 18),
BackgroundColor3 = T.Off,
BorderSizePixel = 0,
}, p1143)
Frame = Frame
or v225("TextButton", {
AutoButtonColor = false,
Text = "",
Size = uDim2New(0, 34, 0, 18),
BackgroundColor3 = T.Off,
BorderSizePixel = 0,
}, p1143)
v226(Frame, 9)
local Frame2 = v225("Frame", {
Size = uDim2New(0, 14, 0, 14),
Position = uDim2New(0, 2, 0.5, -7),
BackgroundColor3 = T.White,
BorderSizePixel = 0,
}, Frame)
v226(Frame2, 7)
local function v8032(p1147)
local v8033 = p1144() == true
local A = v8033 and t15.A or T.Off
local v8035 = v8033 and uDim2New(0, 18, 0.5, -7) or uDim2New(0, 2, 0.5, -7)
if p1147 then
Frame.BackgroundColor3 = A
Frame2.Position = v8035
else
v230(Frame, {
BackgroundColor3 = A,
}, 0.15)
v230(Frame2, {
Position = v8035,
}, 0.15)
end
end
if not p1146 then
Frame.MouseButton1Click:Connect(function()
p1145()
end)
end
t15.onAccent(function()
v8032(true)
end)
v8032(true)
return Frame, v8032
end
t15.paintPill = function(p1148, p1149)
local text = p1149
text = text and "ON"
p1148.Text = text or "OFF"
p1148.BackgroundColor3 = p1149 and t15.A or T.Row
p1148.TextColor3 = p1149 and t15.I or T.Dim
end
t15.pill = function(p1150, p1151, p1152, p1153)
local v8037 = v225
local v8038 = p1153 and "TextLabel"
local v8039 = v8037(v8038 or "TextButton", {
Size = uDim2New(0, 50, 0, 22),
BorderSizePixel = 0,
Font = Enum.Font.GothamBlack,
TextSize = 11,
}, p1150)
if not p1153 then
v8039.AutoButtonColor = false
end
v226(v8039, 7)
local function v8040()
t15.paintPill(v8039, p1151() == true)
end
if not p1153 then
v8039.MouseButton1Click:Connect(function()
p1152()
v8040()
end)
end
t15.onAccent(v8040)
v8040()
return v8039, v8040
end
t15.toggle = function(p1154, p1155, p1156, p1157, p1158)
local v8041 = p1158 or {}
local TextButton = v225("TextButton", {
AutoButtonColor = false,
Text = "",
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 30),
}, p1154)
t15.tag(TextButton, p1155)
local n767 = 925282831
local n768 = 385556258
v231(TextButton, p1155, 12, T.Text, Enum.Font.GothamMedium, {
Size = uDim2New(1, v8041.pill and -60 or -44, 1, 0),
TextTruncate = Enum.TextTruncate.AtEnd,
})
local function v8045()
local v8046 = t15.get(p1156) ~= true
t15.set(p1156, v8046, p1157)
if v8041.cb then
v8041.cb(v8046)
end
end
local v8047
if n768 == n2 then
n4 = 157142786
n758 = 886431064
n768 -= 42
n2 = 777728142
n1 = 995438565
n767 = 792606982
n759 -= 768
(nil)[nil] = nil
bit32.band(nil, nil)
elseif v8041.pill then
local v8048 = t15.pill(TextButton, function()
return t15.get(p1156)
end, nil, true)
v8048.AnchorPoint = Vector2.new(1, 0.5)
v8048.Position = uDim2New(1, 0, 0.5, 0)
v8047 = function()
local paintPill = t15.paintPill
local v8050 = v8048
local get = t15.get
local v8052 = p1156
while true do
paintPill(v8050, get(v8052) == true)
local n769 = 667253853
v8052 = n758
if n4 ~= v8052 then
break
end
n768 -= 1314
n1 -= 889
n2 = 1033611222
n4 -= 679
n758 = 239123585
paintPill = n769 - 1399
v8050 = 97001246
get = n767 - 45
n767 = get
end
end
else
local v8054
v8054, v8047 = t15.switch(TextButton, function()
return t15.get(p1156)
end, v8045, true)
v8054.AnchorPoint = Vector2.new(1, 0.5)
v8054.Position = uDim2New(1, 0, 0.5, 0)
end
t15.bind(p1156, function()
v8047()
end)
TextButton.MouseButton1Click:Connect(v8045)
return TextButton
end
local function v8055(p1159, p1160)
if p1160 < 1 then
return string.format(p1160 < 0.1 and "%.2f" or "%.1f", p1159)
end
return tostring(math.floor(p1159 + 0.5))
end
t15.slider = function(p1161, p1162, p1163, p1164, p1165, p1166, p1167, p1168)
local v8056 = p1168 or ""
local Frame = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 46),
}, p1161)
t15.tag(Frame, p1162)
v231(Frame, p1162, 12, T.Text, Enum.Font.GothamMedium, {
Size = uDim2New(1, -76, 0, 22),
TextTruncate = Enum.TextTruncate.AtEnd,
})
local TextBox = v225("TextBox", {
Size = uDim2New(0, 68, 0, 20),
Position = uDim2New(1, -68, 0, 1),
BackgroundTransparency = 0.86,
BorderSizePixel = 0,
Text = "",
Font = Enum.Font.GothamBold,
TextSize = 11,
ClearTextOnFocus = false,
}, Frame)
v226(TextBox, 7)
t15.paint(TextBox, "BackgroundColor3", "a")
t15.paint(TextBox, "TextColor3", "a")
local TextButton = v225("TextButton", {
AutoButtonColor = false,
Text = "",
BackgroundTransparency = 1,
Size = uDim2New(1, -18, 0, 22),
Position = uDim2New(0, 9, 0, 24),
ZIndex = 3,
}, Frame)
local n770 = 524342560
local Frame2 = v225("Frame", {
Size = uDim2New(1, 0, 0, 8),
Position = uDim2New(0, 0, 0.5, -4),
BackgroundColor3 = T.Line,
BorderSizePixel = 0,
}, TextButton)
v226(Frame2, 4)
local Frame3 = v225("Frame", {
Size = uDim2New(0, 0, 1, 0),
BackgroundColor3 = T.White,
BorderSizePixel = 0,
}, Frame2)
v226(Frame3, 4)
v225("UIGradient", {
Color = ColorSequence.new(t15.A, color3(255, 159, 207)),
}, Frame3)
local Frame4 = v225("Frame", {
Size = uDim2New(0, 12, 0, 12),
AnchorPoint = Vector2.new(0.5, 0.5),
Position = uDim2New(0, 0, 0.5, 0),
BackgroundColor3 = T.Bg,
BorderSizePixel = 0,
}, Frame2)
v226(Frame4, 6)
t15.paint(v227(Frame4, t15.A, 3, 0), "Color", "a")
local UIScale = v225("UIScale", {}, Frame4)
local TextLabel = v225("TextLabel", {
AnchorPoint = Vector2.new(0.5, 1),
Position = uDim2New(0.5, 0, 0, -6),
Size = uDim2New(0, 0, 0, 18),
AutomaticSize = Enum.AutomaticSize.X,
BorderSizePixel = 0,
Font = Enum.Font.GothamBold,
TextSize = 11,
Text = "",
Visible = false,
}, Frame4)
v226(TextLabel, 6)
v228(TextLabel, 6, 6, 0, 0)
t15.paint(TextLabel, "BackgroundColor3", "a")
if n1 == 104592415 then
n759 += 828
n1 = 997222883
n2 = 428159875
n4 = 204941352
n758 = 968908939
return table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 311)
end
t15.paint(TextLabel, "TextColor3", "i")
local u8066 = false
local v8067 = false
local function v8068(p1169, p1170)
local v8069 = math.clamp(p1169, 0, 1)
if p1170 then
v230(Frame3, {
Size = uDim2New(v8069, 0, 1, 0),
}, 0.14)
v230(Frame4, {
Position = uDim2New(v8069, 0, 0.5, 0),
}, 0.14)
else
Frame3.Size = uDim2New(v8069, 0, 1, 0)
Frame4.Position = uDim2New(v8069, 0, 0.5, 0)
end
end
local function v8070(p1171)
local v8071 = tonumber(p1171) or p1163
if not u8066 then
v8068((v8071 - p1163) / (p1164 - p1163), v8067)
end
local text = v8055(v8071, p1165) .. v8056
TextLabel.Text = text
if not TextBox:IsFocused() then
TextBox.Text = text
end
end
local function v8073(p1172)
local v8074 = math.clamp(math.floor((p1172 - p1163) / p1165 + 0.5) * p1165 + p1163, p1163, p1164)
local v8075 = tonumber(v8055(v8074, p1165)) or v8074
if v8075 == t15.get(p1166) then
v8070(v8075)
else
t15.set(p1166, v8075, p1167)
end
end
v8070(t15.get(p1166))
t15.bind(p1166, v8070)
v8067 = true
local function v8076(p1173)
local v8077 = math.clamp((p1173 - Frame2.AbsolutePosition.X) / math.max(Frame2.AbsoluteSize.X, 1), 0, 1)
v8068(v8077, false)
v8073(p1163 + (p1164 - p1163) * v8077)
end
local function v8078(p1174)
TextLabel.Visible = p1174
v230(UIScale, {
Scale = p1174 and 1.15 or 1,
}, 0.12)
if 672993240 ~= n770 then
return
end
n2 = 163328420
n770 = 929922538
n4 = 744646341
return (nil)()
end
TextButton.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
u8066 = true
v8078(true)
v8076(input.Position.X)
return
elseif input.UserInputType == Enum.UserInputType.Touch then
u8066 = true
v8078(true)
v8076(input.Position.X)
end
end)
v222(UserInputService.InputChanged, function(p1175)
if u8066 then
if p1175.UserInputType == Enum.UserInputType.MouseMovement then
v8076(p1175.Position.X)
return
elseif p1175.UserInputType == Enum.UserInputType.Touch then
v8076(p1175.Position.X)
end
end
end)
v222(UserInputService.InputEnded, function(p1176)
if u8066 then
if
p1176.UserInputType == Enum.UserInputType.MouseButton1
or p1176.UserInputType == Enum.UserInputType.Touch
then
u8066 = false
v8078(false)
v8070(t15.get(p1166))
end
end
end)
TextBox.FocusLost:Connect(function()
local v8079 = TextBox.Text:gsub("[^%d%.%-]", "")
local v8080 = tonumber(v8079)
if v8080 then
v8073(v8080)
end
v8070(t15.get(p1166))
end)
return Frame
end
local n771
t15.dropdown = function(p1177, p1178, p1179, p1180, p1181)
n771 = 15842237
local Frame = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 30),
AutomaticSize = Y,
}, p1177)
t15.tag(Frame, p1178)
v229(Frame, 4)
local n772 = 973146050
local v8084 = v225
local s31 = "Frame"
local t305 = {
BackgroundTransparency = 1,
}
local v8087 = uDim2New
local n773 = 1
local n774 = 0
local n775 = 0
while true do
t305.Size = v8087(n773, n774, n775, 30)
v8084 = v8084(s31, t305, Frame)
local n776 = 502233270
v231(v8084, p1178, 12, T.Text, Enum.Font.GothamMedium, {
Size = uDim2New(1, -160, 1, 0),
TextTruncate = Enum.TextTruncate.AtEnd,
})
n775 = 1
t305 = v225("TextButton", {
AutoButtonColor = false,
Text = "",
Size = uDim2New(0, 150, 0, 24),
AnchorPoint = Vector2.new(1, 0.5),
Position = uDim2New(n775, 0, 0.5, 0),
BackgroundColor3 = T.Row,
BorderSizePixel = 0,
}, v8084)
n774 = 6
v226(t305, n774)
local n777 = 120434423
if n759 ~= 654751335 then
n759 += 2028
n758 += 1445
s31 = 1037803901
n771 = 556197340
v8087 = n777 - 1688
n2 += 54
n773 = n1 + 1471
n1 = n773
n772 -= 1660
n4 = 114184365
if nil <= nil then
break
end
end
v227(t305, T.Line, 1, 0)
local v8093 = v231(t305, "", 11, T.Text, Enum.Font.GothamBold, {
Size = uDim2New(1, -28, 1, 0),
Position = uDim2New(0, 8, 0, 0),
TextTruncate = Enum.TextTruncate.AtEnd,
})
local v8094 = v231(t305, "▾", 12, T.Dim, Enum.Font.GothamBold, {
Size = uDim2New(0, 16, 1, 0),
Position = uDim2New(1, -20, 0, 0),
TextXAlignment = Enum.TextXAlignment.Center,
})
local Frame2 = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 0),
Visible = false,
ClipsDescendants = true,
}, Frame)
v229(Frame2, 3)
local v8096 = #p1179 * 26 + math.max(#p1179 - 1, 0) * 3
local t306 = {}
local t307 = {}
local u8099 = false
local function v8100()
local v8101 = t15.get(p1180)
v8093.Text = tostring(v8101 or "")
for k, v in pairs(t306) do
local v8104 = k == v8101
v.BackgroundColor3 = v8104 and t15.A or T.Row
v.TextColor3 = v8104 and t15.I or T.Text
end
end
for _, v in ipairs(p1179) do
local TextButton = v225("TextButton", {
AutoButtonColor = false,
Size = uDim2New(1, 0, 0, 26),
BackgroundColor3 = T.Row,
BorderSizePixel = 0,
Text = v,
TextSize = 11,
Font = Enum.Font.GothamMedium,
TextColor3 = T.Text,
}, Frame2)
v226(TextButton, 6)
t306[v] = TextButton
t307[#t307 + 1] = TextButton
end
local function v8108(p1182)
u8099 = p1182
local n778 = 523901915
v230(v8094, {
Rotation = p1182 and 180 or 0,
}, 0.2)
if p1182 then
Frame2.Visible = true
v230(Frame2, {
Size = uDim2New(1, 0, 0, v8096),
}, 0.22)
for i, v in ipairs(t307) do
v.BackgroundTransparency = 1
v.TextTransparency = 1
task.delay((i - 1) * 0.035, function()
if u8099 then
v230(v, {
BackgroundTransparency = 0,
TextTransparency = 0,
}, 0.16)
end
if not (n771 < n778) then
n2 += 1966
n771 += 510
local v8112 = n759 - 829
repeat
n759 = v8112
n778 = 312800578
n777 = 623360214
until true
end
end)
end
else
v230(Frame2, {
Size = uDim2New(1, 0, 0, 0),
}, 0.16)
task.delay(0.17, function()
local v8113
local v8114
local v8115
local v8116
local v8117
if not u8099 then
Frame2.Visible = false
end
if n772 ~= n759 then
return
end
n759 = 582948672
n772 -= 1747
n771 = 625282875
n778 -= 213
n2 = 108799386
return nil, v8113, v8114, v8115, v8116, v8117, nil
end)
end
end
for k, v in pairs(t306) do
v.MouseButton1Click:Connect(function()
v8108(false)
t15.set(p1180, k, p1181)
end)
end
t305.MouseButton1Click:Connect(function()
v8108(not u8099)
if not (n776 > 77617916) then
n1 = 195360094
n777 = 921901030
n772 += 1805
n776 = 751672888
n758 = 933976106
n2 = 643356595
upv325[324] = nil
end
end)
v8100()
t15.bind(p1180, v8100)
t15.onAccent(v8100)
return Frame
end
return (nil)()
end
t15.textbox = function(p1183, p1184, p1185)
local v8120 = v225
local s32 = "TextBox"
local v8122 = v8120(s32, {
BackgroundColor3 = T.Row,
BorderSizePixel = 0,
Text = "",
PlaceholderText = p1184 or "",
PlaceholderColor3 = T.Dim,
TextColor3 = T.Text,
Font = Enum.Font.GothamMedium,
TextSize = 11,
ClearTextOnFocus = false,
TextXAlignment = Enum.TextXAlignment.Left,
TextTruncate = Enum.TextTruncate.AtEnd,
}, p1183)
if p1185 then
for k, v in pairs(p1185) do
v8122[k] = v
end
end
v226(v8122, 6)
v227(v8122, T.Line, 1, 0)
v228(v8122, 8, 8, 0, 0)
return v8122
end
t15.input = function(p1186, p1187, p1188, p1189, p1190, p1191)
local n779 = 160419578
local v8126 = p1191 or {}
local n780 = 117817942
local Frame = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 30),
}, p1186)
local n781 = 834546343
t15.tag(Frame, p1187)
v231(Frame, p1187, 12, T.Text, Enum.Font.GothamMedium, {
Size = uDim2New(1, -156, 1, 0),
TextTruncate = Enum.TextTruncate.AtEnd,
})
local v8130 = t15.textbox(Frame, p1188, {
Size = uDim2New(0, 146, 0, 24),
AnchorPoint = Vector2.new(1, 0.5),
Position = uDim2New(1, 0, 0.5, 0),
Text = tostring(t15.get(p1189) or ""),
})
v8130.FocusLost:Connect(function()
local text = v8130.Text:gsub("%s", "")
if v8126.clean then
text = v8126.clean(text)
v8130.Text = text
end
t15.set(p1189, text, p1190)
end)
t15.bind(p1189, function(p1192)
if not v8130:IsFocused() then
v8130.Text = tostring(p1192 or "")
end
end)
if v8126.secret then
v8130.Size = uDim2New(0, 116, 0, 24)
v8130.Position = uDim2New(1, -30, 0.5, 0)
local v8132 = v231(v8130, "", 11, T.Text, Enum.Font.GothamBold, {
Name = "Dots",
Size = uDim2New(1, 0, 1, 0),
ZIndex = 2,
TextTruncate = Enum.TextTruncate.AtEnd,
})
local TextButton = v225("TextButton", {
Name = "Eye",
AutoButtonColor = false,
Size = uDim2New(0, 24, 0, 24),
AnchorPoint = Vector2.new(1, 0.5),
Position = uDim2New(1, 0, 0.5, 0),
BackgroundColor3 = T.Row,
BorderSizePixel = 0,
Text = "👁",
TextSize = 12,
Font = Enum.Font.GothamBold,
TextColor3 = T.Dim,
}, Frame)
v226(TextButton, 6)
local v8134 = v227(TextButton, T.Line, 1, 0)
local u8135 = false
local function v8136()
local visible = not u8135 and #v8130.Text > 0
v8130.TextTransparency = visible and 1 or 0
v8132.Visible = visible
local A
if visible then
v8132.Text = string.rep("•", math.min(#v8130.Text, 24))
TextButton.TextColor3 = u8135 and t15.A or T.Dim
if n779 == 160419578 then
A = u8135 and t15.A
A = A or T.Line
v8134.Color = A
else
n779 += 1857
n1 = 198887732
n781 += 304
n780 = 1004692721
local v8139 = n2 - 959
n2 = v8139;
(nil)()
end
else
TextButton.TextColor3 = u8135 and t15.A or T.Dim
if n779 == 160419578 then
A = u8135 and t15.A
v8134.Color = A or T.Line
else
n779 += 1857
n1 = 198887732
n781 += 304
n780 = 1004692721
n2 -= 959
(nil)()
return
end
end
end
v8130:GetPropertyChangedSignal("Text"):Connect(v8136)
TextButton.MouseButton1Click:Connect(function()
local v8140
while true do
u8135 = not u8135
v8136()
if not (n780 < n2) then
n781 = 389208364
n780 += 1667
n758 -= 1972
n759 -= 270
n2 += 2034
n779 = 576157353
if false then
break
end
v8140[104] = 14
v8140[3] = 46
continue
end
break
end
end)
t15.onAccent(v8136)
v8136()
end
return Frame, v8130
end
local n782
t15.seg = function(p1193, p1194, p1195, p1196, p1197)
n782 = 750861967
local v8142 = v225
local s33 = "Frame"
local t308 = {
BackgroundColor3 = T.Row,
BorderSizePixel = 0,
}
local v8145 = uDim2New
local n783 = 1
local v8147
while true do
local v8148
t308.Size = v8145(n783, 0, 0, 30)
v8142 = v8142(s33, t308, p1193)
v226(v8142, 8)
v227(v8142, T.Line, 1, 0)
v228(v8142, 2, 2, 2, 2)
s33 = 516751212
v8145 = v8142
n783 = 2
v229(v8145, n783, true)
if not p1197 then
break
end
if n4 == 616969873 then
t15.tag(v8142, p1197)
break
end
n758 -= 990
n1 += 1974
n2 = 538435283
n759 += 497
n4 -= 1733
t308 = n782 + 1305
n782 = t308
s33 -= 1310
v8147 += W_0
if not (W_0 <= 0) then
if v8147 <= I_0 then
v8148[271] = nil
v8148[279] = 186
v8148[2] = 288
else
upv341 = nil
break
end
elseif v8147 >= I_0 then
v8148[271] = nil
v8148[279] = 186
v8148[2] = 288
else
upv341 = nil
break
end
end
local t309 = {}
local function v8150()
local v8151
local v8152
local v8153 = p1195()
for i, v in ipairs(t309) do
local v8156 = i == v8153
v.BackgroundTransparency = v8156 and 0 or 1
v.BackgroundColor3 = t15.A
v.TextColor3 = v8156 and t15.I or T.Dim
end
end
for i, v in ipairs(p1194) do
local TextButton = v225("TextButton", {
AutoButtonColor = false,
Size = uDim2New(1 / #p1194, -2, 1, 0),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Text = v,
TextSize = 11,
Font = Enum.Font.GothamBold,
TextColor3 = T.Dim,
}, v8142)
v226(TextButton, 6)
t309[i] = TextButton
TextButton.MouseButton1Click:Connect(function()
p1196(i)
v8150()
end)
end
v8150()
t15.onAccent(v8150)
return v8142, v8150
end
local n785
t15.button = function(p1198, p1199, p1200, p1201, p1202)
local n786 = 956282833
n785 = 1072178834
local TextButton = v225("TextButton", {
AutoButtonColor = false,
Size = p1202 or uDim2New(1, 0, 0, 30),
BackgroundColor3 = T.Row,
BorderSizePixel = 0,
Text = p1199,
TextSize = 12,
Font = Enum.Font.GothamBold,
TextColor3 = T.Text,
}, p1198)
v226(TextButton, 8)
if p1201 then
t15.paint(TextButton, "BackgroundColor3", "a")
t15.paint(TextButton, "TextColor3", "i")
else
v227(TextButton, T.Line, 1, 0)
TextButton.MouseEnter:Connect(function()
v230(TextButton, {
BackgroundColor3 = T.RowH,
}, 0.12)
local n787 = 203413050
if n785 == n787 then
n786 += 1111
n785 += 1892
n758 = 112630545
n2 = 672046505
end
end)
TextButton.MouseLeave:Connect(function()
v230(TextButton, {
BackgroundColor3 = T.Row,
}, 0.12)
end)
end
TextButton.MouseButton1Click:Connect(function()
if p1200 then
p1200(TextButton)
end
end)
return TextButton
end
t15.buttons = function(p1203, p1204)
local Frame = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 30),
}, p1203)
v229(Frame, 6, true)
local t310 = {}
for _, v in ipairs(p1204) do
t310[#t310 + 1] = v[1]
t15.button(Frame, v[1], v[2], v[3], uDim2New(1 / #p1204, -6 * (#p1204 - 1) / #p1204, 1, 0))
end
t15.tag(Frame, table.concat(t310, " "))
return Frame
end
t15.chip = function(p1205, p1206, p1207, p1208)
local TextLabel = v225("TextLabel", {
BackgroundColor3 = T.Row,
BorderSizePixel = 0,
Size = uDim2New(0, 0, 0, 20),
AutomaticSize = Enum.AutomaticSize.X,
Text = p1206,
TextColor3 = p1207 or T.Dim,
Font = Enum.Font.GothamBold,
TextSize = 11,
}, p1205)
if p1208 then
for k, v in pairs(p1208) do
TextLabel[k] = v
end
end
v226(TextLabel, 6)
v228(TextLabel, 7, 7, 0, 0)
return TextLabel
end
t15.KEYS = {
{
"Kick",
"Y",
},
{
"Rejoin Job ID",
"J",
},
{
"Clone",
"F",
},
{
"Manual TP",
"T",
},
{
"Invisible Steal",
"U",
},
{
"WalkSpeed",
"NONE",
},
{
"Proximity",
"P",
},
{
"Carpet Boost",
"Q",
},
{
"Open Menu",
"LeftControl",
},
{
"Ragdoll Self",
"R",
},
{
"Drop Brainrot",
"G",
},
{
"Float",
"Z",
},
{
"Reset",
"X",
},
{
"Auto Buy",
"K",
},
{
"Click to AP",
"NONE",
},
}
local t311 = {
LeftControl = "LCtrl",
RightControl = "RCtrl",
LeftShift = "LShift",
RightShift = "RShift",
LeftAlt = "LAlt",
RightAlt = "RAlt",
NONE = "None",
}
t15.keyListeners = {}
t15.key = function(p1209)
local v8177 = t15.C.keybinds[p1209]
if type(v8177) == "string" then
return v8177
end
for _, key in ipairs(t15.KEYS) do
if key[1] == p1209 then
return key[2]
end
end
return "NONE"
end
t15.keyText = function(p1210)
return t311[p1210] or p1210
end
t15.setKey = function(p1211, p1212)
t15.C.keybinds[p1211] = p1212
t15.save()
for _, keyListener in ipairs(t15.keyListeners) do
pcall(keyListener)
end
if n2 ~= n4 then
return
end
n1 = 637749461
n2 -= 1211
n4 += 1581
n759 = 913452900
n758 += 1925
end
t15.keychip = function(p1213, p1214, p1215)
local TextButton = v225("TextButton", {
AutoButtonColor = false,
BorderSizePixel = 0,
Text = "",
TextSize = 11,
Font = Enum.Font.GothamBold,
BackgroundTransparency = 0.84,
}, p1213)
if p1215 then
for k, v in pairs(p1215) do
TextButton[k] = v
end
end
v226(TextButton, 6)
t15.paint(TextButton, "TextColor3", "a")
t15.paint(TextButton, "BackgroundColor3", "a")
local function v8185()
TextButton.Text = t15.keyText(t15.key(p1214))
end
v8185()
table.insert(t15.keyListeners, v8185)
return TextButton, v8185
end
t15.keyrow = function(p1216, p1217)
local Frame = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 30),
}, p1216)
t15.tag(Frame, p1217)
v231(Frame, p1217, 12, T.Text, Enum.Font.GothamMedium, {
Size = uDim2New(1, -104, 1, 0),
TextTruncate = Enum.TextTruncate.AtEnd,
})
local TextButton = v225("TextButton", {
AutoButtonColor = false,
Size = uDim2New(0, 20, 0, 20),
AnchorPoint = Vector2.new(1, 0.5),
Position = uDim2New(1, 0, 0.5, 0),
BackgroundTransparency = 1,
Text = "X",
TextSize = 11,
Font = Enum.Font.GothamBold,
TextColor3 = T.Dim,
}, Frame)
local v8188, v8189 = t15.keychip(Frame, p1217, {
Size = uDim2New(0, 70, 0, 22),
AnchorPoint = Vector2.new(1, 0.5),
Position = uDim2New(1, -24, 0.5, 0),
})
local n788 = 985397363
TextButton.MouseButton1Click:Connect(function()
t15.setKey(p1217, "NONE")
end)
v8188.MouseButton1Click:Connect(function()
if t15.capturing then
return
end
t15.capturing = true
v8188.Text = "..."
local connection
if n2 < n788 then
connection = UserInputService.InputBegan:Connect(function(input)
if input.UserInputType ~= Enum.UserInputType.Keyboard then
return
end
connection:Disconnect()
task.defer(function()
t15.capturing = false
end)
if input.KeyCode ~= Enum.KeyCode.Escape then
t15.setKey(p1217, input.KeyCode.Name)
return
end
v8189()
end)
else
n788 -= 1722
n2 -= 1410
n1 -= 1025
upv138 = nil
end
end)
return Frame
end
t15.panel = function(p1218, p1219, p1220, p1221, p1222)
local v8192 = p1222 or {}
local n789 = 152257311
local Frame = v225("Frame", {
Name = p1218,
BackgroundColor3 = T.Bg,
BackgroundTransparency = 0.04,
BorderSizePixel = 0,
Size = uDim2New(0, p1220, 0, v8192.h or 0),
Position = p1221,
Visible = false,
}, t15.root)
v226(Frame, 12)
v227(Frame, T.Line, 1, 0)
if not v8192.h then
Frame.AutomaticSize = Y
v229(Frame, 0)
end
local Frame2 = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 40),
Active = true,
}, Frame)
v231(Frame2, "SXE HUB", 14, T.Text, Enum.Font.GothamBlack, {
Size = uDim2New(1, -90, 0, 16),
Position = uDim2New(0, 12, 0, 6),
})
v231(Frame2, p1219, 11, T.Dim, Enum.Font.GothamMedium, {
Size = uDim2New(1, -90, 0, 13),
Position = uDim2New(0, 12, 0, 22),
TextTruncate = Enum.TextTruncate.AtEnd,
})
local n790
if v8192.icon then
v225("TextButton", {
AutoButtonColor = false,
Size = uDim2New(0, 40, 0, 26),
AnchorPoint = Vector2.new(1, 0.5),
Position = uDim2New(1, -4, 0.5, 0),
BackgroundTransparency = 1,
Text = v8192.icon,
TextSize = 12,
Font = Enum.Font.GothamBold,
TextColor3 = T.Dim,
}, Frame2).MouseButton1Click:Connect(function()
n790 = 869978129
local n791 = 777195967
if v8192.onIcon then
if n759 == n791 then
n759 -= 1678
n2 = 5528945
n790 -= 854
n789 -= 1581
n4 = 344507266
return (nil)()
end
v8192.onIcon(Frame)
end
end)
end
local Frame3
if v8192.h then
Frame3 = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 1, -40),
Position = uDim2New(0, 0, 0, 40),
}, Frame)
else
Frame3 = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 0),
AutomaticSize = Y,
}, Frame)
v228(Frame3, 10, 10, 0, 10)
v229(Frame3, 4)
end
t15.drag(Frame, Frame2, p1218)
if v8192.resize then
t15.resizer(Frame, v8192.minW or p1220, v8192.minH or 160, p1218)
end
t15.place(Frame, p1218)
t15.frames[p1218] = {
f = Frame,
def = p1221,
size = v8192.h and uDim2New(0, p1220, 0, v8192.h) or nil,
}
return Frame, Frame3, Frame2
end
t15.chipToggle = function(p1223, p1224, p1225, p1226)
local n792 = 265435271
local TextButton = v225("TextButton", {
AutoButtonColor = false,
BorderSizePixel = 0,
Text = p1224,
TextSize = 12,
Font = Enum.Font.GothamBold,
BackgroundColor3 = T.Row,
TextColor3 = T.Text,
}, p1223)
v226(TextButton, 8)
local n793 = 940429075
local v8202 = v227(TextButton, T.Line, 1, 0)
t15.tag(TextButton, p1224)
local function v8203()
local v8204 = t15.get(p1225) == true
TextButton.BackgroundColor3 = v8204 and t15.A or T.Row
TextButton.BackgroundTransparency = v8204 and 0.84 or 0
TextButton.TextColor3 = v8204 and t15.A or T.Text
v8202.Color = v8204 and t15.A or T.Line
end
TextButton.MouseButton1Click:Connect(function()
t15.set(p1225, t15.get(p1225) ~= true, p1226)
if not (n792 < n793) then
n758 = 947933454
n792 = 640383327
n2 = 995248684
n793 = 127967234
end
end)
t15.bind(p1225, v8203)
t15.onAccent(v8203)
v8203()
return TextButton
end
local v8205 = color3(58, 26, 30)
local v8206 = color3(90, 42, 48)
local v8207 = color3(255, 138, 138)
t15.statusChip = function(p1227, p1228, p1229, p1230, p1231)
local TextButton = v225("TextButton", {
AutoButtonColor = false,
BorderSizePixel = 0,
Text = "",
BackgroundColor3 = T.Row,
}, p1227)
v226(TextButton, 8)
local v8209 = v227(TextButton, T.Line, 1, 0)
local Frame = v225("Frame", {
Size = uDim2New(0, 7, 0, 7),
Position = uDim2New(0, 10, 0.5, -3),
BorderSizePixel = 0,
}, TextButton)
v226(Frame, 4)
local v8211 = v231(TextButton, p1228, 12, T.Text, Enum.Font.GothamBold, {
Size = uDim2New(1, -28, 1, 0),
Position = uDim2New(0, 23, 0, 0),
TextTruncate = Enum.TextTruncate.AtEnd,
})
t15.tag(TextButton, p1231 or p1228)
local function v8212()
local v8213 = t15.get(p1229) == true
local Row = v8213 and T.Row
TextButton.BackgroundColor3 = Row or v8205
v8209.Color = v8213 and t15.A or v8206
Frame.BackgroundColor3 = v8213 and t15.A or T.Bad
v8211.TextColor3 = v8213 and T.Text or v8207
end
TextButton.MouseButton1Click:Connect(function()
t15.set(p1229, t15.get(p1229) ~= true, p1230)
end)
t15.bind(p1229, v8212)
t15.onAccent(v8212)
v8212()
return TextButton
end
t15.stepper = function(p1232, p1233, p1234, p1235, p1236, p1237, p1238, p1239)
local Frame = v225("Frame", {
BackgroundColor3 = T.Card,
BorderSizePixel = 0,
}, p1232)
v226(Frame, 10)
v227(Frame, T.Line, 1, 0)
t15.tag(Frame, p1233)
v231(Frame, p1233, 12, T.Text, Enum.Font.GothamMedium, {
Size = uDim2New(1, -16, 0, 16),
Position = uDim2New(0, 8, 0, 5),
})
local TextButton = v225("TextButton", {
AutoButtonColor = false,
Size = uDim2New(0, 24, 0, 24),
Position = uDim2New(0, 8, 0, 25),
BackgroundColor3 = T.Row,
BorderSizePixel = 0,
Text = "-",
TextSize = 16,
Font = Enum.Font.GothamBold,
}, Frame)
local TextButton2 = v225("TextButton", {
AutoButtonColor = false,
Size = uDim2New(0, 24, 0, 24),
Position = uDim2New(1, -32, 0, 25),
BackgroundColor3 = T.Row,
BorderSizePixel = 0,
Text = "+",
TextSize = 16,
Font = Enum.Font.GothamBold,
}, Frame)
v226(TextButton, 6)
v226(TextButton2, 6)
t15.paint(TextButton, "TextColor3", "a")
t15.paint(TextButton2, "TextColor3", "a")
local TextBox = v225("TextBox", {
Size = uDim2New(1, -80, 0, 24),
Position = uDim2New(0, 40, 0, 25),
BackgroundColor3 = T.Row,
BorderSizePixel = 0,
Text = "",
TextColor3 = T.Text,
Font = Enum.Font.GothamBold,
TextSize = 12,
ClearTextOnFocus = false,
}, Frame)
v226(TextBox, 6)
local function v8219(p1240)
local v8220 = tonumber(p1240)
local v8221 =
math.clamp(math.floor(((v8220 or p1236) - p1236) / p1238 + 0.5) * p1238 + p1236, p1236, p1237)
return tonumber(string.format(p1239, v8221)) or v8221
end
local function v8222(p1241)
local v8223 = v8219(p1241)
TextBox.Text = string.format(p1239, v8223)
local textTransparency = v8223 <= p1236 and 0.6
TextButton.TextTransparency = textTransparency or 0
TextButton2.TextTransparency = v8223 >= p1237 and 0.6 or 0
end
local function v8225(p1242)
local v8226 = v8219(p1242)
if v8226 == t15.get(p1234) then
v8222(v8226)
else
t15.set(p1234, v8226, p1235)
end
end
TextButton.MouseButton1Click:Connect(function()
v8225((tonumber(t15.get(p1234)) or p1236) - p1238)
end)
TextButton2.MouseButton1Click:Connect(function()
v8225((tonumber(t15.get(p1234)) or p1236) + p1238)
end)
TextBox.FocusLost:Connect(function()
v8225(tonumber(TextBox.Text) or t15.get(p1234))
v8222(t15.get(p1234))
end)
t15.bind(p1234, v8222)
v8222(t15.get(p1234))
return Frame
end
t15.section = function(p1243, p1244)
return v231(p1243, p1244, 11, T.Dim, Enum.Font.GothamBold, {
Size = uDim2New(1, 0, 0, 22),
})
end
end
v232()
t15.later(function()
local T = t15.T
local C = t15.C
local v8229 = uDim2New(0.5, -320, 0.5, -235)
local Frame = v225("Frame", {
Name = "Main",
BackgroundColor3 = T.Bg,
BackgroundTransparency = 0.04,
BorderSizePixel = 0,
Size = uDim2New(0, 640, 0, 470),
Position = v8229,
Visible = false,
}, t15.root)
v226(Frame, 14)
v227(Frame, T.Line, 1, 0)
t15.main = Frame
local Frame2 = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 46),
Active = true,
}, Frame)
v225("Frame", {
BackgroundColor3 = T.Line,
BorderSizePixel = 0,
Size = uDim2New(1, 0, 0, 1),
Position = uDim2New(0, 0, 1, -1),
}, Frame2)
v226(
v225("ImageLabel", {
Size = uDim2New(0, 30, 0, 30),
Position = uDim2New(0, 10, 0.5, -15),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Image = t15.LOGO,
ScaleType = Enum.ScaleType.Fit,
}, Frame2),
8
)
v231(Frame2, "SXE HUB", 15, T.Text, Enum.Font.GothamBlack, {
Size = uDim2New(0, 120, 1, 0),
Position = uDim2New(0, 48, 0, 0),
})
local v8232 = t15.textbox(Frame2, "Search settings", {
Size = uDim2New(0, 200, 0, 28),
AnchorPoint = Vector2.new(1, 0.5),
Position = uDim2New(1, -72, 0.5, 0),
TextSize = 12,
})
local TextButton = v225("TextButton", {
AutoButtonColor = false,
Size = uDim2New(0, 26, 0, 26),
AnchorPoint = Vector2.new(1, 0.5),
Position = uDim2New(1, -38, 0.5, 0),
BackgroundTransparency = 1,
Text = "–",
TextColor3 = T.Dim,
Font = Enum.Font.GothamBold,
TextSize = 18,
}, Frame2)
local TextButton2 = v225("TextButton", {
AutoButtonColor = false,
Size = uDim2New(0, 26, 0, 26),
AnchorPoint = Vector2.new(1, 0.5),
Position = uDim2New(1, -8, 0.5, 0),
BackgroundTransparency = 1,
Text = "X",
TextColor3 = T.Dim,
Font = Enum.Font.GothamBold,
TextSize = 14,
}, Frame2)
t15.drag(Frame, Frame2, "Main")
local Frame3 = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 1, -46),
Position = uDim2New(0, 0, 0, 46),
ClipsDescendants = true,
}, Frame)
local n794 = 601296063
local Frame4 = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(0, 150, 1, 0),
}, Frame3)
v225("Frame", {
BackgroundColor3 = T.Line,
BorderSizePixel = 0,
Size = uDim2New(0, 1, 1, 0),
Position = uDim2New(1, -1, 0, 0),
}, Frame4)
local Frame5 = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, -16, 1, -72),
Position = uDim2New(0, 8, 0, 8),
}, Frame4)
v229(Frame5, 3)
local Frame6 = v225("Frame", {
BackgroundColor3 = T.Card,
BorderSizePixel = 0,
Size = uDim2New(1, -16, 0, 46),
Position = uDim2New(0, 8, 1, -54),
}, Frame4)
v226(Frame6, 10)
local n795 = 687763389
v227(Frame6, T.Line, 1, 0)
v226(
v225("ImageLabel", {
Size = uDim2New(0, 30, 0, 30),
Position = uDim2New(0, 8, 0.5, -15),
BackgroundColor3 = T.Row,
BorderSizePixel = 0,
Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer.UserId) .. "&w=150&h=150",
}, Frame6),
15
)
v231(Frame6, LocalPlayer.DisplayName, 12, T.Text, Enum.Font.GothamBold, {
Size = uDim2New(1, -48, 0, 15),
Position = uDim2New(0, 44, 0, 8),
TextTruncate = Enum.TextTruncate.AtEnd,
})
v231(Frame6, "@" .. LocalPlayer.Name, 11, T.Dim, Enum.Font.GothamMedium, {
Size = uDim2New(1, -48, 0, 13),
Position = uDim2New(0, 44, 0, 24),
TextTruncate = Enum.TextTruncate.AtEnd,
})
local Frame7 = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, -150, 1, 0),
Position = uDim2New(0, 150, 0, 0),
}, Frame3)
t15.resizer(Frame, 520, 360, "Main")
t15.place(Frame, "Main")
t15.frames.Main = {
f = Frame,
def = v8229,
size = uDim2New(0, 640, 0, 470),
}
local tabs = {
{ "Auto TP" },
{ "Priority" },
{ "ESP" },
{ "Misc" },
{ "Keybinds" },
{ "UI" },
{ "Performance" },
}
t15.TABS = tabs
local n796 = 674020526
local pages = {}
local t312 = {}
local t313 = {}
local u8247
local function v8248()
local ScrollingFrame = v225("ScrollingFrame", {
Visible = false,
BackgroundTransparency = 1,
BorderSizePixel = 0,
Size = uDim2New(1, 0, 1, 0),
CanvasSize = uDim2New(0, 0, 0, 0),
AutomaticCanvasSize = Enum.AutomaticSize.Y,
ScrollBarThickness = 3,
ScrollingDirection = Enum.ScrollingDirection.Y,
ScrollBarImageColor3 = T.Line,
}, Frame7)
v228(ScrollingFrame, 12, 14, 10, 12)
v229(ScrollingFrame, 8)
return ScrollingFrame
end
local function v8250(p1245)
for k, v in pairs(t312) do
local v8253 = k == p1245
v.BackgroundColor3 = t15.A
v.BackgroundTransparency = v8253 and 0.84 or 1
v.TextColor3 = v8253 and t15.A or T.Dim
end
end
local v8254
local function pickTab(p1246)
if not pages[p1246] then
p1246 = "Auto TP"
end
u8247 = p1246
if v8254 then
v8254.Visible = false
end
for k, page in pairs(pages) do
page.Visible = k == p1246
end
v8250(p1246)
if C.LastTab ~= p1246 then
C.LastTab = p1246
t15.save()
end
end
t15.pickTab = pickTab
for _, tab in ipairs(tabs) do
local TextButton3 = v225("TextButton", {
AutoButtonColor = false,
Size = uDim2New(1, 0, 0, 34),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Text = "   " .. tab[1],
TextXAlignment = Enum.TextXAlignment.Left,
Font = Enum.Font.GothamBold,
TextSize = 12,
TextColor3 = T.Dim,
}, Frame5)
v226(TextButton3, 8)
t313[tab[1]] = v231(TextButton3, "", 11, T.Dim, Enum.Font.GothamBold, {
Size = uDim2New(0, 24, 1, 0),
Position = uDim2New(1, -28, 0, 0),
TextXAlignment = Enum.TextXAlignment.Right,
})
t312[tab[1]] = TextButton3
TextButton3.MouseButton1Click:Connect(function()
if v8232.Text == "" then
pickTab(tab[1])
else
u8247 = tab[1]
v8232.Text = ""
end
end)
pages[tab[1]] = v8248()
end
v8254 = v8248()
t15.pages = pages
t15.results = v8254
t15.onAccent(function()
if v8254.Visible then
v8250(nil)
elseif u8247 then
pickTab(u8247)
end
end)
local t314 = {}
local t315 = {}
local function v8263()
for i = #t314, 1, -1 do
local v8265 = t314[i]
v8265.c.Parent = v8265.p
v8265.c.LayoutOrder = v8265.o
end
table.clear(t314)
for _, v in ipairs(t315) do
v:Destroy()
end
table.clear(t315)
if n794 == n795 then
n794 = 704019788
n796 += 1509
n4 = 124726279
n795 = 444553097
n2 -= 1847
(nil)[nil] = nil
end
end
local function applySearch()
local v8269 = v8232.Text:gsub("^%s+", ""):gsub("%s+$", "")
local v8270 = string.lower(v8269)
v8263()
local layoutOrder = 0
local n797 = 0
for _, tab in ipairs(tabs) do
local v8275 = pages[tab[1]]
local n798 = 0
for _, descendant in ipairs(v8275:GetDescendants()) do
local attribute = descendant:GetAttribute("SXELabel")
if attribute and not descendant:GetAttribute("SXEHidden") then
local visible = v8270 == "" or string.find(attribute, v8270, 1, true) ~= nil
descendant.Visible = visible
if visible and v8270 ~= "" then
n798 += 1
end
end
end
local t316 = {}
for _, child in ipairs(v8275:GetChildren()) do
if child:GetAttribute("SXECard") and not child:GetAttribute("SXEHidden") then
if v8270 == "" then
child.Visible = true
else
local visible = false
for _, descendant in ipairs(child:GetDescendants()) do
if descendant:GetAttribute("SXELabel") and descendant.Visible then
visible = true
break
end
end
child.Visible = visible
if visible then
t316[#t316 + 1] = child
end
end
end
end
local v8287 = t313[tab[1]]
local v8288 = v8270 ~= "" and n798 > 0
v8287.Text = v8288 and tostring(n798) or ""
if #t316 > 0 then
table.sort(t316, function(p1247, p1248)
return p1247.LayoutOrder < p1248.LayoutOrder
end)
layoutOrder += 1
t315[#t315 + 1] = v231(v8254, tab[1], 12, t15.A, Enum.Font.GothamBold, {
Size = uDim2New(1, 0, 0, 18),
LayoutOrder = layoutOrder,
})
for _, v in ipairs(t316) do
layoutOrder += 1
t314[#t314 + 1] = {
c = v,
p = v8275,
o = v.LayoutOrder,
}
v.LayoutOrder = layoutOrder
v.Parent = v8254
end
n797 += n798
end
end
if v8270 == "" then
pickTab(u8247 or "Auto TP")
return
end
if n797 == 0 then
t315[#t315 + 1] =
v231(v8254, 'No settings match "' .. v8270 .. '"', 12, T.Dim, Enum.Font.GothamMedium, {
Size = uDim2New(1, 0, 0, 30),
TextXAlignment = Enum.TextXAlignment.Center,
LayoutOrder = 1,
})
end
for _, page in pairs(pages) do
page.Visible = false
end
v8254.Visible = true
v8250(nil)
end
t15.applySearch = applySearch
v8232:GetPropertyChangedSignal("Text"):Connect(applySearch)
local u8293 = false
local Offset
TextButton.MouseButton1Click:Connect(function()
u8293 = not u8293
if u8293 then
Offset = Frame.Size.Y.Offset
Frame3.Visible = false
Frame.Size = uDim2New(0, Frame.Size.X.Offset, 0, 46)
else
Frame3.Visible = true
Frame.Size = uDim2New(0, Frame.Size.X.Offset, 0, Offset or 470)
end
end)
t15.showMain = function(p1249)
Frame.Visible = p1249 and true or false
end
t15.toggleMain = function()
t15.showMain(not Frame.Visible)
end
TextButton2.MouseButton1Click:Connect(function()
t15.showMain(false)
end)
t15.yield()
local autoTp = pages["Auto TP"]
t15.toggle(t15.card(autoTp, "Target"), "Priority mode", "AutoTPPriority", "Auto TP Priority Mode")
local v8296 = t15.card(autoTp, "On load")
t15.toggle(v8296, "TP on load", "TpSettings.TpOnLoad", "TP on Load")
t15.slider(v8296, "TP on load delay", 0, 30, 0.1, "TpSettings.TpOnLoadDelay", "TP on Load Delay", "s")
local v8297 = t15.card(autoTp, "Travel")
t15.dropdown(v8297, "Teleport tool", {
"Flying Carpet",
"Cupid's Wings",
"Santa's Sleigh",
"Witch's Broom",
"Waverider",
}, "TpSettings.Tool", "Teleport Tool")
t15.toggle(v8297, "Grabble TP", "TpSettings.GrabbleTP", "Grabble TP")
t15.toggle(v8297, "Approach floor 2 from 1", "TpSettings.ApproachFloor2From1", "Approach Floor 2 From 1")
local v8298 = t15.card(autoTp, "Speed")
t15.slider(v8298, "Grabble TP speed", 100, 550, 10, "TpSettings.GrabbleTPSpeed", "Grabble TP Speed")
t15.slider(v8298, "Clone delay", 0, 2, 0.01, "TpSettings.CloneDelayVal", "Clone Delay", "s")
t15.input(
t15.card(autoTp, "Filters"),
"Min gen for auto TP",
"50k, 1m, 10b",
"TpSettings.MinGenForTp",
"Min Gen For TP"
)
t15.yield()
local ESP = pages.ESP
local function v8300(p1250, p1251, p1252, p1253, p1254)
t15.tag(t15.chipToggle(p1250, p1251, p1253, p1254), p1252)
end
local v8301 = t15.card(ESP, "Brainrots (priority list)")
t15.toggle(v8301, "Brainrot ESP", "BrainrotESP", "Brainrot ESP")
local v8302 = t15.grid(v8301, 28, 2, 6, 6)
v8300(v8302, "Highlight best", "highlight best brainrot", "EspBestHighlight", "Esp Best Highlight")
v8300(v8302, "Line to best", "line to best brainrot", "LineToBrainrot", "Line To Best Brainrot")
local v8303 = t15.card(ESP, "Players")
t15.toggle(v8303, "Player ESP", "PlayerESP", "Player ESP")
local v8304 = t15.grid(v8303, 28, 3, 6, 6)
v8300(v8304, "Stealing", "player stealing", "EspPlayerStealing", "Esp Player Stealing")
v8300(v8304, "In your base", "player in your base", "EspPlayerInBase", "Esp Player In Base")
v8300(v8304, "Incoming steals", "incoming steals", "EspIncoming", "Esp Incoming")
local grid = t15.grid
local v8306 = t15.card(ESP, "Bases and more")
local v8307 = grid(v8306)
t15.toggle(v8307, "Timer ESP", "TimerESP", "Timer ESP")
t15.toggle(v8307, "Base owner ESP", "BaseOwnerESP", "Base Owner ESP")
t15.toggle(v8307, "Subspace mine ESP", "SubspaceMineESP", "Subspace Mine ESP")
t15.toggle(v8307, "Line to base", "LineToBase", "Line To Base")
t15.yield()
local Misc = pages.Misc
local grid2 = t15.grid
local v8310 = t15.card(Misc, "Steal")
local v8311 = grid2(v8310)
t15.toggle(v8311, "Instant clone", "InstantClone", "Instant Clone")
t15.toggle(v8311, "Auto unlock during steal", "AutoUnlockOnSteal", "Auto Unlock During Steal")
t15.toggle(v8311, "Invisible steal", "InvisibleSteal", "Invisible Steal")
t15.toggle(v8311, "Unwalk", "Unwalk", "Unwalk")
t15.toggle(v8311, "Open base", "OpenBase", "Open Base")
local grid3 = t15.grid
local v8313 = t15.card(Misc, "Movement")
local v8314 = grid3(v8313)
t15.toggle(v8314, "Infinite jump", "InfiniteJump", "Infinite Jump")
t15.toggle(v8314, "Float", "Float", "Float")
t15.toggle(v8314, "Carpet speed", "CarpetSpeed", "Carpet Speed")
local v8315 = t15.card(Misc, "Kick")
t15.toggle(v8315, "Auto kick on steal", "AutoKickOnSteal", "Auto Kick")
t15.toggle(v8315, "Kick to private server", "KickToPrivateServer", "Kick To Private Server")
local v8316 = t15.input(v8315, "Private server code", "ABC123XYZ", "PrivateServerCode", "Private Server Code", {
secret = true,
clean = function(p1255)
return p1255:match("privateServerLinkCode=([%w%-_]+)") or p1255
end,
})
local function v8317(p1256)
t15.hide(v8316, p1256 ~= true)
t15.applySearch()
end
t15.bind("KickToPrivateServer", v8317)
v8317(C.KickToPrivateServer)
local v8318 = t15.grid(t15.card(Misc, "Protection"), 30, 3, 6, 6)
for _, v in ipairs({
{
"Ragdoll",
"AntiRagdoll",
"Anti Ragdoll",
},
{
"Knockback",
"AntiKnockback",
"Anti Knockback",
},
{
"Admin panel",
"AntiAdmin",
"Anti Admin Panel",
},
{
"Body swap",
"AntiBodySwap",
"Anti Body Swap",
},
{
"Bee",
"AntiBee",
"Anti Bee",
},
{
"Boogie bomb",
"AntiBoogie",
"Anti Boogie Bomb",
},
{
"Gummy bear",
"AntiGummy",
"Anti Gummy Bear",
},
{
"Balloon reset",
"AutoResetBalloon",
"Auto Reset Balloon",
"auto reset balloon",
},
{
"Bee and disco",
"AntiBeeDisco",
"Anti-Bee & Anti-Disco",
"anti bee and disco",
},
}) do
t15.statusChip(v8318, v[1], v[2], v[3], v[4] or "anti " .. string.lower(v[1]))
end
t15.input(
t15.card(Misc, "Filters"),
"Min gen for nearest grab",
"10k, 500k, 1m",
"TpSettings.MinGenForGrab",
"Min Gen For Grab"
)
t15.yield()
local grid4 = t15.grid
local v8322 = t15.card(pages.Keybinds, "Click a key to rebind it  ·  X clears it  ·  Esc cancels")
local v8323 = grid4(v8322)
for _, key in ipairs(t15.KEYS) do
t15.keyrow(v8323, key[1])
end
t15.yield()
local v8326 = t15.card(pages.Performance, "Graphics")
t15.toggle(v8326, "FPS boost", "FPSBoost", "FPS Boost")
t15.toggle(v8326, "Optimizer", "Optimizer", "Optimizer")
t15.toggle(v8326, "Xray", "XRay", "Xray")
t15.slider(v8326, "Field of view", 50, 120, 1, "FOV", "FOV")
t15.bind("FOV", function(p1257)
if n2 == 557240548 then
pcall(function()
if p1257 and workspace.CurrentCamera then
workspace.CurrentCamera.FieldOfView = p1257
end
end)
return
end
n1 = 426846341
n796 = 341005587
n2 = 889623725
n794 += 144
n795 = 793792943
return (nil)(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 210))
end)
end)
t15.later(function()
u204 = 864345928
u205 = 733319354
local n799 = 272149665
local T = t15.T
local C = t15.C
local Y = Enum.AutomaticSize.Y
local GuiService = game:GetService("GuiService")
local n800 = 352998081
local function v8333(p1258)
if 689749826 ~= n800 then
return p1258.UserInputType == Enum.UserInputType.MouseButton1
or p1258.UserInputType == Enum.UserInputType.Touch
end
n2 = 552446904
n800 -= 659
n799 += 502
n1 -= 594
n4 = 663132153
u205 = 1009039317
upv208[nil] = nil
return (nil)(nil)
end
local function v8334(p1259)
return p1259.UserInputType == Enum.UserInputType.MouseMovement
or p1259.UserInputType == Enum.UserInputType.Touch
end
t15.pointer = function(p1260)
if not p1260 or p1260.UserInputType ~= Enum.UserInputType.Touch then
return UserInputService:GetMouseLocation()
end
local ok, result = pcall(function()
return GuiService:GetGuiInset()
end)
local vector2 = Vector2.new(p1260.Position.X, p1260.Position.Y)
local vector22 = ok and result or Vector2.new()
return vector2 + vector22
end
local function v8339(p1261, p1262)
local AbsolutePosition = p1261.AbsolutePosition
local AbsoluteSize = p1261.AbsoluteSize
return p1262.X >= AbsolutePosition.X
and p1262.X <= AbsolutePosition.X + AbsoluteSize.X
and p1262.Y >= AbsolutePosition.Y
and p1262.Y <= AbsolutePosition.Y + AbsoluteSize.Y
end
local function v8342(p1263, p1264)
local AbsolutePosition = t15.root.AbsolutePosition
return uDim2New(
0,
(p1263.X - AbsolutePosition.X) / t15.scale,
0,
(p1263.Y - AbsolutePosition.Y) / t15.scale + (p1264 or 0)
)
end
local Priority = t15.pages.Priority
local v8345, v8346 = t15.card(Priority, "Mutation priority  ·  drag a chip onto another, or tap two")
local v8347, v8348 = t15.switch(v8346, function()
return C.MutationPriorityOn ~= false
end, function()
t15.set("MutationPriorityOn", C.MutationPriorityOn == false, "Mutation Priority")
end)
v8347.AnchorPoint = Vector2.new(1, 0.5)
v8347.Position = uDim2New(1, 0, 0.5, 0)
local v8349 = t15.grid(v8345, 26, 4, 6, 6)
local t317 = {}
local t318 = {}
local u8352
local t319
local n801 = 0
local v8355
local function v8356(p1265, p1266)
if p1265 == p1266 then
return
end
local v8357 = table.remove(C.MutOrder, p1265)
table.insert(C.MutOrder, p1266, v8357)
t15.save()
t15.hook("Mutation Order", C.MutOrder)
end
local function v8358(p1267)
for i, v in ipairs(t318) do
local v8361 = i == u8352 or i == p1267
v.Color = v8361 and t15.A or T.Line
v.Thickness = v8361 and 2 or 1
end
end
v8355 = function()
local mutationIteration
local _
local state = 1
local n802, v8368, v8369, v8370, forIter, forState, forControl, table_, u8375, table_2, Destroy, v8378, v8379, v8380, v8381, v8382, TextButton
while true do
if state == 1 then
n802 = 334104733
v8368, v8369, v8370 = ipairs(t317)
state = 2
elseif state == 2 then
forIter, forState, forControl = v8368, v8369, v8370
if type(forIter) == "table" then
local forMeta = getmetatable(forIter)
if type(forMeta) == "table" and forMeta["__iter"] then
forIter, forState, forControl = (forMeta["__iter"](forIter))
else
forIter, forState, forControl = next, forIter, nil
end
end
state = 3
elseif state == 3 then
table_, u8375 = (forIter(forState, forControl))
if table_ == nil then
state = 4
else
forControl = table_
state = 12
end
elseif state == 4 then
table_2 = table
table_2 = table_2.clear
table_ = t317
table_2(table_)
table_2 = 364238519
table_ = table
table_ = table_.clear
u8375 = t318
table_(u8375)
table_ = nil
u8375 = nil
local v8385, v8386
Destroy, v8385, v8386 = ipairs(C.MutOrder)
v8378 = geniter(Destroy, v8385, v8386)
state = 5
elseif state == 5 then
mutationIteration = table.pack(v8378())
if mutationIteration[1] then
state = 6
else
state = 11
end
elseif state == 6 then
v8379 = mutationIteration[2]
v8380 = mutationIteration[3]
v8381 = mutationIteration[2]
v8382 = mutationIteration[1]
TextButton = v225("TextButton", {
AutoButtonColor = false,
BorderSizePixel = 0,
Text = v8379 .. "  " .. tostring(v8380),
TextSize = 11,
Font = Enum.Font.GothamBold,
BackgroundColor3 = T.Row,
TextColor3 = T.Text,
TextTruncate = Enum.TextTruncate.AtEnd,
}, v8349)
if n2 == 557240548 then
state = 10
else
state = 7
end
elseif state == 7 then
n2 = 856850761
n4 -= 1368
u205 -= 1134
n800 += 1127
n802 += 531
n1 = 216863354
table_2 += 1192
n799 += 764
upv387[nil] = nil
upv387[v8382] = v8381[204]
upv387[v8382]()
local v8388 = table.pack(v8378())
if v8388[1] then
state = 8
else
state = 9
end
elseif state == 8 then
state = 13
else
if state == 9 then
return v8379
end
if state == 10 then
v226(TextButton, 6)
t318[v8379] = v227(TextButton, T.Line, 1, 0)
t15.tag(TextButton, tostring(v8380))
TextButton.MouseButton1Click:Connect(function()
if os.clock() - n801 < 0.3 then
return
end
if u8352 ~= nil then
v8356(u8352, v8379)
u8352 = nil
v8355()
return
end
u8352 = v8379
v8358()
end)
TextButton.InputBegan:Connect(function(input)
table_ = 919594685
u8375 = 319564744
if v8333(input) and not t319 then
t319 = {
from = v8379,
start = t15.pointer(input),
}
end
if n802 ~= table_2 then
return
end
n802 -= 222
n2 = 305050863
n4 = 428114579
table_ -= 796
n1 = 76597754
u8375 = 193668193
n800 -= 1941
table_2 += 1960
LPH_CRASH()
end)
t317[v8379] = TextButton
state = 5
elseif state == 11 then
v8358()
return
elseif state == 12 then
v8379 = u8375
Destroy = u8375.Destroy
state = 13
elseif state == 13 then
Destroy(v8379)
state = 3
end
end
end
end
local function v8389(p1268)
for i, v in ipairs(t317) do
if v.Visible then
if v8339(v, p1268) then
return i
end
end
end
if n2 ~= n1 then
return nil
end
u204 = 904712769
n1 -= 812
n799 = 779217895
n800 += 1954
n2 += 1958
n4 = 191638632
upv260[nil] = nil
end
v222(UserInputService.InputChanged, function(p1269)
if not t319 or not v8334(p1269) then
return
end
local v8392 = t15.pointer(p1269)
local v8393 = v8392.X - t319.start.X
local v8394 = v8392.Y - t319.start.Y
if not t319.ghost then
if math.abs(v8393) + math.abs(v8394) < 6 then
return
end
local v8395 = t317[t319.from]
if not v8395 then
t319 = nil
return
end
local AbsoluteSize = v8395.AbsoluteSize
t319.abs = v8395.AbsolutePosition
t319.size = AbsoluteSize
local TextLabel = v225("TextLabel", {
BackgroundColor3 = T.Row,
BorderSizePixel = 0,
Size = uDim2New(0, t319.size.X / t15.scale, 0, t319.size.Y / t15.scale),
Text = v8395.Text,
TextColor3 = T.Text,
Font = Enum.Font.GothamBold,
TextSize = 11,
ZIndex = 60,
}, t15.root)
v226(TextLabel, 6)
v227(TextLabel, t15.A, 1.5, 0)
t319.ghost = TextLabel
v8395.TextTransparency = 0.6
end
local vector2 = Vector2.new(t319.abs.X + v8393, t319.abs.Y + v8394)
t319.ghost.Position = v8342(vector2)
t319.target = v8389(vector2 + t319.size / 2)
v8358(t319.target ~= t319.from and t319.target or nil)
end)
v222(UserInputService.InputEnded, function(p1270)
if t319 then
if v8333(p1270) then
local v8399 = t319
t319 = nil
if not v8399.ghost then
return
end
local ghost = v8399.ghost
local v8401 = ghost
local Destroy = ghost.Destroy
local v8403 = Destroy
Destroy(v8401)
n801 = os.clock()
if v8399.target and v8399.target ~= v8399.from then
if n4 == n2 then
n2 = 308671980
n4 = 682660020
n800 = 5095327
n1 += 1023
u205 += 1296
n799 -= 669
bit32.bxor(nil, nil)
v8403[nil] = n799[nil]
else
u8352 = nil
end
v8356(v8399.from, v8399.target)
end
v8355()
return
end
end
end)
local function v8404()
v8349.Visible = C.MutationPriorityOn ~= false
v8348()
end
t15.bind("MutationPriorityOn", v8404)
t15.yield()
local v8405 = t15.card(Priority, "Priority list  ·  drag :: to reorder")
local Frame = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 32),
}, v8405)
t15.tag(Frame, "add a brainrot priority")
local v8407 = t15.textbox(Frame, "Add a brainrot...", {
Size = uDim2New(1, -76, 0, 28),
Position = uDim2New(0, 0, 0, 2),
TextSize = 12,
})
local v8408 = t15.button(Frame, "Add", nil, true, uDim2New(0, 68, 0, 28))
v8408.Position = uDim2New(1, -68, 0, 2)
local Frame2 = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 0),
AutomaticSize = Y,
Visible = false,
}, v8405)
v229(Frame2, 3)
local Frame3 = v225("Frame", {
BackgroundColor3 = T.Row,
BorderSizePixel = 0,
Size = uDim2New(1, 0, 0, 30),
}, v8405)
v226(Frame3, 8)
local v8411 = v231(Frame3, "", 12, T.Text, Enum.Font.GothamMedium, {
Size = uDim2New(1, -90, 1, 0),
Position = uDim2New(0, 10, 0, 0),
})
local TextButton = v225("TextButton", {
AutoButtonColor = false,
BackgroundTransparency = 1,
Text = "Restore",
TextSize = 12,
Font = Enum.Font.GothamBold,
Size = uDim2New(0, 70, 1, 0),
Position = uDim2New(1, -76, 0, 0),
}, Frame3)
t15.paint(TextButton, "TextColor3", "a")
local Frame4 = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 0),
AutomaticSize = Y,
}, v8405)
v229(Frame4, 0)
local t320 = {}
local t321
local u8416
local n803
local function v8418()
n803 = 905504495
if u8416 then
return u8416
end
local n804 = 76434233
local t322 = {}
pcall(function()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Animations = ReplicatedStorage:FindFirstChild("Animations")
local Animals = Animations and Animations:FindFirstChild("Animals")
if not Animals then
local Models = ReplicatedStorage:FindFirstChild("Models")
Animals = Models and Models:FindFirstChild("Animals")
end
if Animals then
local t323 = {}
for _, child in ipairs(Animals:GetChildren()) do
if not t323[child.Name] then
t323[child.Name] = true
if n800 ~= 352999099 then
t322[#t322 + 1] = child.Name
continue
end
u205 += 1198
n803 -= 1371
n2 = 905358431
n1 += 1945
n800 = 97833039
n804 += 1185
return (nil)(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
{},
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 460))
end
end
table.sort(t322, function(p1271, p1272)
return p1271:lower() < p1272:lower()
end)
end
end)
if #t322 > 0 then
u8416 = t322
end
if n799 < u205 then
return t322
end
n2 -= 1814
n800 = 418593001
n803 = 346551689
u205 = 829590579
u204 -= 877
n1 = 839554736
n804 = 218892964
n799 -= 1735
(nil)(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil + nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 491))
end
local v8428
local function v8429()
t15.save()
t15.hook("Priority List", C.PriorityList)
v8428()
end
local function v8430(p1273)
local v8431 = tostring(p1273 or ""):gsub("^%s+", ""):gsub("%s+$", "")
v8407.Text = ""
Frame2.Visible = false
if v8431 == "" then
return
end
for _, v in ipairs(C.PriorityList) do
if v == v8431 then
return
end
end
table.insert(C.PriorityList, v8431)
for i = #C.RemovedFromPriority, 1, -1 do
if C.RemovedFromPriority[i] == v8431 then
table.remove(C.RemovedFromPriority, i)
end
end
v8429()
end
local function v8435(p1274)
for _, child in ipairs(Frame2:GetChildren()) do
if child:IsA("GuiObject") then
child:Destroy()
end
end
local v8438 = string.lower(p1274 or "")
if v8438 == "" then
Frame2.Visible = false
return
end
local t324 = {}
for _, v in ipairs(C.PriorityList) do
t324[v] = true
end
local n805 = 0
for _, v in ipairs(v8418()) do
if not t324[v] and string.find(v:lower(), v8438, 1, true) then
n805 += 1
local TextButton2 = v225("TextButton", {
AutoButtonColor = false,
Size = uDim2New(1, 0, 0, 26),
BackgroundColor3 = T.Row,
BorderSizePixel = 0,
Text = "   " .. v,
TextXAlignment = Enum.TextXAlignment.Left,
TextSize = 11,
Font = Enum.Font.GothamMedium,
TextColor3 = T.Text,
}, Frame2)
v226(TextButton2, 6)
TextButton2.MouseButton1Click:Connect(function()
v8430(v)
end)
if not (n805 >= 6) then
continue
end
else
continue
end
break
end
Frame2.Visible = n805 > 0
end
local n806
v8407:GetPropertyChangedSignal("Text"):Connect(function()
n806 = 204347633
v8435(v8407.Text)
if u205 ~= n4 then
return
end
n2 = 1003537131
n799 = 536426747
n800 -= 1912
n4 += 1410
u205 = 713429288
n806 += 1416
u204 = 768987042
(nil)(nil)
return (nil)(nil)
end)
v8407.FocusLost:Connect(function(enterPressed)
local n807 = 1025632179
local n808 = 955738890
if enterPressed then
v8430(v8407.Text)
elseif u205 == 733319406 then
u205 -= 39
n807 -= 1811
n1 = 533123488
n799 += 260
n2 = 557615107
n800 -= 630
n808 += 126
u204 = 217053164
if nil < nil then
task.delay(0.25, function()
if not v8407:IsFocused() then
Frame2.Visible = false
end
end)
end
else
task.delay(0.25, function()
if not v8407:IsFocused() then
Frame2.Visible = false
end
end)
return
end
end)
v8408.MouseButton1Click:Connect(function()
v8430(v8407.Text)
end)
TextButton.MouseButton1Click:Connect(function()
for _, v in ipairs(C.RemovedFromPriority) do
local v8451 = false
for _, v2 in ipairs(C.PriorityList) do
if v2 == v then
v8451 = true
break
end
end
if not v8451 then
table.insert(C.PriorityList, v)
end
end
C.RemovedFromPriority = {}
v8429()
end)
local n809
local n810
local function v8456(p1275)
n809 = 310081679
n810 = 658966546
local v8457
if n4 == n810 then
n809 -= 179
n799 = 585447737
n810 = 883617556
u204 += 1083
n4 = 146400638
n800 = 556077459
n1 = 714393033
n2 -= 1911
bit32.band(nil, nil)
else
for i, v in ipairs(t320) do
if v.Visible then
v8457 = i
if p1275 < v.AbsolutePosition.Y + v.AbsoluteSize.Y / 2 then
return i
end
end
end
end
return (v8457 or 0) + 1
end
local function v8460()
local k = t321.k
local v8462 = t320[k]
local v8463 = false
local AbsolutePosition, AbsoluteSize, line, v8467, vector2New, X, Y2
if v8462 and v8462.Visible then
if not v8462 then
t321.line.Visible = false
return
end
AbsolutePosition = v8462.AbsolutePosition
AbsoluteSize = v8462.AbsoluteSize
t321.line.Visible = true
line = t321.line
v8467 = v8342
vector2New = Vector2.new
X = AbsolutePosition.X
Y2 = v8463 and AbsolutePosition.Y + AbsoluteSize.Y or AbsolutePosition.Y
line.Position = v8467(vector2New(X, Y2), -1)
else
v8462 = nil
v8463 = true
local v8471 = math.min(k - 1, #t320)
local n811 = 1
local v8473, v8474, v8475, AbsolutePosition2, line2, v8478, vector2New2, X2
if false then
if v8471 <= n811 then
v8473 = v8471
v8474 = t320[v8473]
while true do
if v8474.Visible then
v8462 = t320[v8473]
break
end
v8475 += nil
if not (nil <= 0) then
if v8475 <= nil then
v8473 = v8475
v8474 = t320[v8473]
continue
end
elseif v8475 >= nil then
v8473 = v8475
v8474 = t320[v8473]
continue
end
break
end
if not v8462 then
t321.line.Visible = false
return
end
AbsolutePosition2 = v8462.AbsolutePosition
AbsoluteSize = v8462.AbsoluteSize
t321.line.Visible = true
line2 = t321.line
v8478 = v8342
vector2New2 = Vector2.new
X2 = AbsolutePosition2.X
local Y3 = AbsolutePosition2.Y + AbsoluteSize.Y or AbsolutePosition2.Y
line2.Position = v8478(vector2New2(X2, Y3), -1)
else
if not v8462 then
t321.line.Visible = false
return
end
AbsolutePosition = v8462.AbsolutePosition
AbsoluteSize = v8462.AbsoluteSize
t321.line.Visible = true
line = t321.line
v8467 = v8342
vector2New = Vector2.new
X = AbsolutePosition.X
Y2 = v8463 and AbsolutePosition.Y + AbsoluteSize.Y or AbsolutePosition.Y
line.Position = v8467(vector2New(X, Y2), -1)
end
elseif v8471 >= n811 then
v8473 = v8471
v8474 = t320[v8473]
while true do
if v8474.Visible then
v8462 = t320[v8473]
break
end
v8475 += nil
if not (nil <= 0) then
if v8475 <= nil then
v8473 = v8475
v8474 = t320[v8473]
continue
end
elseif v8475 >= nil then
v8473 = v8475
v8474 = t320[v8473]
continue
end
break
end
if not v8462 then
t321.line.Visible = false
return
end
AbsolutePosition2 = v8462.AbsolutePosition
AbsoluteSize = v8462.AbsoluteSize
t321.line.Visible = true
line2 = t321.line
v8478 = v8342
vector2New2 = Vector2.new
X2 = AbsolutePosition2.X
line2.Position =
v8478(vector2New2(X2, AbsolutePosition2.Y + AbsoluteSize.Y or AbsolutePosition2.Y), -1)
else
if not v8462 then
t321.line.Visible = false
return
end
AbsolutePosition = v8462.AbsolutePosition
AbsoluteSize = v8462.AbsoluteSize
t321.line.Visible = true
t321.line.Position = v8342(
Vector2.new(
AbsolutePosition.X,
v8463 and AbsolutePosition.Y + AbsoluteSize.Y or AbsolutePosition.Y
),
-1
)
end
end
t321.line.Size = uDim2New(0, AbsoluteSize.X / t15.scale, 0, 2)
end
local function v8482(p1276)
local vector2 = Vector2.new(t321.abs.X + p1276.X - t321.start.X, t321.abs.Y + p1276.Y - t321.start.Y)
local n812 = 596485415
t321.ghost.Position = v8342(vector2)
t321.y = vector2.Y + t321.size.Y / 2
t321.k = v8456(t321.y)
if n1 == n812 then
u205 -= 601
n800 = 156049049
n799 -= 591
n1 -= 1389
n2 -= 1763
n4 = 853572502
else
v8460()
end
end
local function v8485(p1277, p1278, p1279, p1280)
local scale = t15.scale
local AbsolutePosition = p1278.AbsolutePosition
local AbsoluteSize = p1278.AbsoluteSize
local n813 = 393342505
local Frame5 = v225("Frame", {
BackgroundColor3 = T.Row,
BorderSizePixel = 0,
Size = uDim2New(0, AbsoluteSize.X / scale, 0, AbsoluteSize.Y / scale),
ZIndex = 60,
}, t15.root)
v226(Frame5, 8)
v227(Frame5, t15.A, 1.5, 0)
v231(Frame5, "   " .. tostring(p1277) .. "   " .. p1279, 12, T.Text, Enum.Font.GothamBold, {
Size = uDim2New(1, 0, 1, 0),
ZIndex = 61,
TextTruncate = Enum.TextTruncate.AtEnd,
})
local n814 = 211004959
local Frame6 = v225("Frame", {
BackgroundColor3 = t15.A,
BorderSizePixel = 0,
ZIndex = 62,
Visible = false,
}, t15.root)
v226(Frame6, 1)
p1278.BackgroundTransparency = 0.5
t321 = {
from = p1277,
row = p1278,
ghost = Frame5,
line = Frame6,
start = t15.pointer(p1280),
abs = AbsolutePosition,
size = AbsoluteSize,
}
local n815 = 261721776
local n816
t321.hb = RunService.Heartbeat:Connect(function()
n816 = 34420726
if t321 then
if t321.y then
pcall(function()
local Visible = t15.results and t15.results.Visible
Visible = Visible and t15.results or Priority
local Y2 = Visible.AbsolutePosition.Y
local v8497 = t321.y < Y2 and -5 or t321.y > Y2 + Visible.AbsoluteSize.Y and 5 or 0
if v8497 ~= 0 then
local v8498 =
math.max(0, (Visible.AbsoluteCanvasSize.Y - Visible.AbsoluteWindowSize.Y) / scale)
Visible.CanvasPosition =
Vector2.new(0, math.clamp(Visible.CanvasPosition.Y + v8497, 0, v8498))
t321.k = v8456(t321.y)
v8460()
end
end)
return
end
end
if n1 ~= 104592297 then
return
end
n816 -= 461
n813 += 1121
n815 += 75
n814 += 382
n1 -= 1295
n2 += 1608
n799 = 1050020531
end)
v8482(t321.start)
end
v222(UserInputService.InputChanged, function(p1281)
if t321 and v8334(p1281) then
v8482(t15.pointer(p1281))
end
end)
v222(UserInputService.InputEnded, function(p1282)
if t321 then
if v8333(p1282) then
local v8499 = t321
t321 = nil
if v8499.hb then
v8499.hb:Disconnect()
end
v8499.ghost:Destroy()
v8499.line:Destroy()
if v8499.row.Parent then
v8499.row.BackgroundTransparency = 1
end
local k = v8499.k or v8499.from
if k ~= v8499.from and k ~= v8499.from + 1 then
local PriorityList = C.PriorityList
local v8502 = table.remove(PriorityList, v8499.from)
if v8499.from < k then
k -= 1
end
table.insert(PriorityList, k, v8502)
v8429()
end
return
end
end
end)
v8428 = function()
for _, v in ipairs(t320) do
v:Destroy()
end
table.clear(t320)
local v8505 = #C.RemovedFromPriority
v8411.Text = v8505 .. " removed brainrot" .. (v8505 == 1 and "" or "s")
Frame3.Visible = v8505 > 0
for i, v in ipairs(C.PriorityList) do
local Frame5 = v225("Frame", {
BackgroundTransparency = 1,
BackgroundColor3 = T.Row,
BorderSizePixel = 0,
Size = uDim2New(1, 0, 0, 30),
}, Frame4)
t15.tag(Frame5, v)
v225("Frame", {
BackgroundColor3 = T.Line,
BorderSizePixel = 0,
Size = uDim2New(1, 0, 0, 1),
}, Frame5)
local TextButton2 = v225("TextButton", {
AutoButtonColor = false,
BackgroundTransparency = 1,
Text = "::",
TextSize = 12,
Font = Enum.Font.GothamBold,
TextColor3 = T.Dim,
Size = uDim2New(0, 22, 1, 0),
}, Frame5)
v231(Frame5, tostring(i), 11, T.Dim, Enum.Font.GothamBold, {
Size = uDim2New(0, 24, 1, 0),
Position = uDim2New(0, 24, 0, 0),
})
v231(Frame5, v, 12, T.Text, Enum.Font.GothamMedium, {
Size = uDim2New(1, -136, 1, 0),
Position = uDim2New(0, 50, 0, 0),
TextTruncate = Enum.TextTruncate.AtEnd,
})
local function v8510(p1283, p1284, p1285, p1286)
v225("TextButton", {
AutoButtonColor = false,
BackgroundTransparency = 1,
Text = p1283,
TextSize = 12,
Font = Enum.Font.GothamBold,
TextColor3 = p1285,
Size = uDim2New(0, 24, 0, 24),
Position = uDim2New(1, p1284, 0.5, -12),
}, Frame5).MouseButton1Click:Connect(p1286)
end
v8510("▲", -78, T.Dim, function()
local PriorityList = C.PriorityList
if i > 1 then
local v8512 = i - 1
local v8513 = PriorityList[i]
PriorityList[i] = PriorityList[i - 1]
PriorityList[v8512] = v8513
v8429()
end
end)
v8510("▼", -52, T.Dim, function()
local PriorityList = C.PriorityList
if i < #PriorityList then
local v8515 = i + 1
local v8516 = PriorityList[i]
PriorityList[i] = PriorityList[i + 1]
PriorityList[v8515] = v8516
v8429()
end
end)
v8510("X", -26, T.Bad, function()
local v8517 = table.remove(C.PriorityList, i)
local v8518 = false
for _, v2 in ipairs(C.RemovedFromPriority) do
if v2 == v8517 then
v8518 = true
end
end
if v8517 and not v8518 then
table.insert(C.RemovedFromPriority, v8517)
end
v8429()
end)
TextButton2.InputBegan:Connect(function(input)
if v8333(input) then
if not t321 then
v8485(i, Frame5, v, input)
end
end
end)
t320[i] = Frame5
end
t15.applySearch()
end
t15.yield()
v8355()
v8428()
v8404()
t15.rebuildPriority = function()
u8352 = nil
v8355()
v8428()
v8404()
end
t15.yield()
local UI = t15.pages.UI
local grid = t15.grid
local v8523 = t15.card(UI, "Panels")
local v8524 = grid(v8523)
for _, v in ipairs({
{
"Invisible steal",
"Visibilities.Invisible Steal Panel",
},
{
"Command cooldowns",
"Visibilities.Command Cooldowns",
},
{
"Actions",
"Visibilities.Actions",
},
{
"Steal panel",
"Visibilities.Steal Panel",
},
{
"Steal target",
"Visibilities.Steal Target",
},
{
"Remote sell",
"RemoteSellEnabled",
"Remote Sell Panel",
},
{
"Admin panel",
"AdminPanelUI",
"Admin Panel UI",
},
{
"Bottom bar",
"Visibilities.Bottom Bar",
},
}) do
t15.toggle(v8524, v[1], v[2], v[3])
end
local v8528, v8529, v8530, v8531
if n2 == u205 then
local v8527 = t39_535_1[1]
n4 += 1040
u204 = 193759419
n800 = 521530769
u205 += 183
n2 += 1485
n799 += 1515
n1 = 250757415
if nil < nil then
n1[v8527]()
t15.toggle(v8524, "Clear error popups", "CleanErrorGUIs", "Clear Error Popups")
t15.toggle(v8524, "Auto close on execute", "AutoCloseOnExec", "Auto Close On Execute")
v8528 = function(p1287)
local v8532 = p1287:gsub("[^ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=]", "")
local t325 = {}
for i = 1, 64 do
t325[("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):sub(i, i)] = i - 1
end
local t326 = {}
local n817 = 1
while n817 <= #v8532 do
local v8537 = t325[v8532:sub(n817, n817)]
local v8538 = t325[v8532:sub(n817 + 1, n817 + 1)]
local v8539 = v8532:sub(n817 + 2, n817 + 2)
local v8540 = v8532:sub(n817 + 3, n817 + 3)
if not v8537 or not v8538 then
break
end
local v8541 = v8537 * 262144 + v8538 * 4096 + (t325[v8539] or 0) * 64 + (t325[v8540] or 0)
t326[#t326 + 1] = string.char(math.floor(v8541 / 65536))
if v8539 ~= "=" and v8539 ~= "" then
t326[#t326 + 1] = string.char(math.floor(v8541 / 256) % 256)
end
if v8540 ~= "=" and v8540 ~= "" then
t326[#t326 + 1] = string.char(v8541 % 256)
end
n817 += 4
end
return table.concat(t326)
end
t15.importConfig = function(p1288)
local v8542 = tostring(p1288 or "")
local n818 = 192108839
local n819 = 303876472
local n820 = 839561499
if v8542 == "" then
return false
end
local ok, result = pcall(function()
return HttpService:JSONDecode(v8542)
end)
if not ok or type(result) ~= "table" then
local pcall_ = pcall
local v8549 = v8528
local v8550 = v8542:gsub("%s", "")
local ok2, result2 = pcall_(v8549, v8550)
if ok2 and result2 then
ok, result = pcall(function()
return HttpService:JSONDecode(result2)
end)
end
end
if not ok or type(result) ~= "table" then
return false
end
t15.merge(result)
t15.normalize()
t15.save()
t15.setAccent("Pink")
t15.refreshAll()
for _, keyListener in ipairs(t15.keyListeners) do
pcall(keyListener)
end
if t15.rebuildPriority then
t15.rebuildPriority()
end
if t15.actionsRebuild then
if n800 == n4 then
n2 = 51020849
n820 += 1776
n799 = 45833357
u204 += 923
n1 = 658979402
n819 -= 758
n800 = 314848957
n4 = 177313531
n818 -= 1509
else
t15.actionsRebuild()
end
end
if t15.adminRebuild then
t15.adminRebuild()
end
return true
end
v8529 = t15.card(UI, "Config")
v8530 = t15.textbox(v8529, "Paste a config here to import it", {
Size = uDim2New(1, 0, 0, 28),
})
t15.tag(v8530, "config export import share")
t15.buttons(v8529, {
{
"Export config",
function()
local n821 = 506534391
local n822 = 106675780
local ok, text = pcall(function()
return HttpService:JSONEncode(C)
end)
local n823
if ok then
v8530.Text = text
pcall(function()
n823 = 955508587
if type(setclipboard) == "function" then
setclipboard(text)
end
if u204 > 275346037 then
return
end
n821 += 269
n823 += 1781
n822 += 407
n2 = 830641689
n799 = 739026564
n1 = 803996174
u204 += 239
return nil
end)
end
end,
},
{
"Import config",
function(p1289)
local n824 = 356603744
p1289.Text = t15.importConfig(v8530.Text) and "Imported" or "Invalid config"
if n799 ~= 272151569 then
task.delay(1.5, function()
p1289.Text = "Import config"
end)
return
end
u205 = 932699150
n800 += 228
n2 = 368074261
n4 -= 1071
n1 -= 1230
n799 = 536747901
upv278 = nil
return (n824 + 745)(1070252863)
end,
},
})
v8531 = t15.card(UI, "Layout")
t15.buttons(
v8531,
{ {
"Reset positions",
function()
t15.resetPositions()
end,
} }
)
t15.toggle(v8531, "Lock panels", "locked", "Lock UI")
end
else
local grid2 = t15.grid
local v8562 = t15.card(UI, "Behavior")
v8524 = grid2(v8562)
t15.toggle(v8524, "Clear error popups", "CleanErrorGUIs", "Clear Error Popups")
t15.toggle(v8524, "Auto close on execute", "AutoCloseOnExec", "Auto Close On Execute")
v8528 = function(p1290)
local v8563 = p1290:gsub("[^ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=]", "")
local t327 = {}
for i = 1, 64 do
t327[("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):sub(i, i)] = i - 1
end
local t328 = {}
local n825 = 1
while n825 <= #v8563 do
local v8568 = t327[v8563:sub(n825, n825)]
local v8569 = t327[v8563:sub(n825 + 1, n825 + 1)]
local v8570 = v8563:sub(n825 + 2, n825 + 2)
local v8571 = v8563:sub(n825 + 3, n825 + 3)
if not v8568 or not v8569 then
break
end
local v8572 = v8568 * 262144 + v8569 * 4096 + (t327[v8570] or 0) * 64 + (t327[v8571] or 0)
t328[#t328 + 1] = string.char(math.floor(v8572 / 65536))
if v8570 ~= "=" and v8570 ~= "" then
t328[#t328 + 1] = string.char(math.floor(v8572 / 256) % 256)
end
if v8571 ~= "=" and v8571 ~= "" then
t328[#t328 + 1] = string.char(v8572 % 256)
end
n825 += 4
end
return table.concat(t328)
end
local s34 = "importConfig"
t15[s34] = function(p1291)
local v8574 = tostring(p1291 or "")
local n826 = 192108839
local n827 = 303876472
local n828 = 839561499
if v8574 == "" then
return false
end
local ok, result = pcall(function()
return HttpService:JSONDecode(v8574)
end)
if not ok or type(result) ~= "table" then
local pcall_ = pcall
local v8581 = v8528
local v8582 = v8574:gsub("%s", "")
local ok2, result2 = pcall_(v8581, v8582)
if ok2 and result2 then
ok, result = pcall(function()
return HttpService:JSONDecode(result2)
end)
end
end
if not ok or type(result) ~= "table" then
return false
end
t15.merge(result)
t15.normalize()
t15.save()
t15.setAccent("Pink")
t15.refreshAll()
for _, keyListener in ipairs(t15.keyListeners) do
pcall(keyListener)
end
if t15.rebuildPriority then
t15.rebuildPriority()
end
if t15.actionsRebuild then
if n800 == n4 then
n2 = 51020849
n828 += 1776
n799 = 45833357
u204 += 923
n1 = 658979402
n827 -= 758
n800 = 314848957
n4 = 177313531
n826 -= 1509
else
t15.actionsRebuild()
end
end
if t15.adminRebuild then
t15.adminRebuild()
end
return true
end
v8529 = t15.card(UI, "Config")
v8530 = t15.textbox(v8529, "Paste a config here to import it", {
Size = uDim2New(1, 0, 0, 28),
})
t15.tag(v8530, "config export import share")
t15.buttons(v8529, {
{
"Export config",
function()
local n829 = 506534391
local n830 = 106675780
local ok, text = pcall(function()
return HttpService:JSONEncode(C)
end)
local n831
if ok then
v8530.Text = text
pcall(function()
n831 = 955508587
if type(setclipboard) == "function" then
setclipboard(text)
end
if u204 > 275346037 then
return
end
n829 += 269
n831 += 1781
n830 += 407
n2 = 830641689
n799 = 739026564
n1 = 803996174
u204 += 239
return nil
end)
end
end,
},
{
"Import config",
function(p1292)
local n832 = 356603744
p1292.Text = t15.importConfig(v8530.Text) and "Imported" or "Invalid config"
if n799 ~= 272151569 then
task.delay(1.5, function()
p1292.Text = "Import config"
end)
return
end
u205 = 932699150
n800 += 228
n2 = 368074261
n4 -= 1071
n1 -= 1230
n799 = 536747901
upv278 = nil
return (n832 + 745)(1070252863)
end,
},
})
v8531 = t15.card(UI, "Layout")
t15.buttons(v8531, { {
"Reset positions",
function()
t15.resetPositions()
end,
} })
t15.toggle(v8531, "Lock panels", "locked", "Lock UI")
end
local v8593 = t15.card(UI, "Alerts")
t15.toggle(v8593, "Priority sound alert", "PrioritySoundAlert", "Priority Sound Alert")
t15.input(v8593, "Custom sound ID", "123456789", "PrioritySoundID", "Priority Sound ID")
t15.buttons(v8593, {
{
"Test alert",
function()
if t15.showAlert then
t15.showAlert("Headless Horseman", "1.2B/s", "Rainbow", LocalPlayer.Name)
end
end,
},
})
end)
v233 = function()
local T = t15.T
local n833 = 554483857
local n834 = 1003485839
local C = t15.C
local Y = Enum.AutomaticSize.Y
local function v8599(p1293, p1294)
t15.bind(p1293, function(p1295)
p1294.Visible = p1295 == true
end)
end
t15.rejoinPS = function()
pcall(function()
game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)
end
t15.rejoinJob = function()
pcall(function()
game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)
end
t15.kickToPrivate = function()
local v8600 = tostring(C.PrivateServerCode or "")
if v8600 == "" then
return
end
task.delay(0.2, function()
pcall(function()
game:GetService("ExperienceService"):LaunchExperience({
placeId = game.PlaceId,
linkCode = v8600,
})
end)
end)
end
t15.kick = function()
if t15.hook("Kick") then
return
end
if C.KickToPrivateServer then
t15.kickToPrivate()
end
task.delay(0.05, function()
pcall(function()
LocalPlayer:Kick("You have been kicked.")
end)
end)
end
local n835
local v8602, v8603, v8604 = t15.panel("Steal Target", "Steal target", 330, uDim2New(1, -345, 0, 80), {
h = 410,
resize = true,
minW = 280,
minH = 240,
})
v8599("Visibilities.Steal Target", v8602)
local v8605 = t15.chip(v8604, "0 found", T.Dim, {
AnchorPoint = Vector2.new(1, 0.5),
Position = uDim2New(1, -12, 0.5, 0),
})
local ScrollingFrame = v225("ScrollingFrame", {
BackgroundTransparency = 1,
BorderSizePixel = 0,
Size = uDim2New(1, -12, 1, -74),
Position = uDim2New(0, 8, 0, 0),
CanvasSize = uDim2New(0, 0, 0, 0),
AutomaticCanvasSize = Y,
ScrollBarThickness = 3,
ScrollBarImageColor3 = T.Line,
ScrollingDirection = Enum.ScrollingDirection.Y,
}, v8603)
v229(ScrollingFrame, 5)
v228(ScrollingFrame, 0, 6, 0, 4)
local v8607 = v231(ScrollingFrame, "Waiting for targets...", 12, T.Dim, Enum.Font.GothamMedium, {
Size = uDim2New(1, 0, 0, 40),
TextXAlignment = Enum.TextXAlignment.Center,
})
local Frame = v225("Frame", {
BackgroundColor3 = T.Card,
BorderSizePixel = 0,
Size = uDim2New(1, -16, 0, 56),
Position = uDim2New(0, 8, 1, -64),
}, v8603)
v226(Frame, 10)
v227(Frame, T.Line, 1, 0)
local v8609 = v231(Frame, "Searching...", 12, T.Text, Enum.Font.GothamBold, {
Name = "GrabName",
Size = uDim2New(1, -20, 0, 18),
Position = uDim2New(0, 10, 0, 6),
TextTruncate = Enum.TextTruncate.AtEnd,
})
local Frame2 = v225("Frame", {
Name = "GrabBar",
BackgroundColor3 = color3(42, 42, 54),
BorderSizePixel = 0,
Size = uDim2New(1, -20, 0, 20),
Position = uDim2New(0, 10, 0, 28),
ClipsDescendants = true,
}, Frame)
v226(Frame2, 10)
local Frame3 = v225("Frame", {
Name = "GrabFill",
BorderSizePixel = 0,
Size = uDim2New(0, 0, 1, 0),
BackgroundColor3 = t15.A,
}, Frame2)
v226(Frame3, 10)
local v8612 = v231(Frame2, "", 11, T.White, Enum.Font.GothamBold, {
Name = "GrabState",
Size = uDim2New(1, -20, 1, 0),
Position = uDim2New(0, 10, 0, 0),
ZIndex = 2,
TextTruncate = Enum.TextTruncate.AtEnd,
})
local v8613 = v231(Frame2, "", 11, T.White, Enum.Font.GothamBold, {
Name = "GrabTime",
Size = uDim2New(0, 70, 1, 0),
Position = uDim2New(1, -80, 0, 0),
ZIndex = 2,
TextXAlignment = Enum.TextXAlignment.Right,
})
local function v8614(p1296, p1297, p1298, p1299)
v8612.Text = p1296
v8613.Text = p1297
Frame3.Size = uDim2New(math.clamp(p1298, 0, 1), 0, 1, 0)
if p1299 then
Frame3.BackgroundColor3 = p1299
end
end
local u8615
local s35 = ""
local function v8617(p1300)
local v8618 = tonumber(p1300)
if not v8618 then
return nil
end
for _, v in ipairs({
{
1e12,
"T",
},
{
1e9,
"B",
},
{
1000000,
"M",
},
{
1000,
"K",
},
}) do
if v[1] <= v8618 then
return string.format("%.1f", v8618 / v[1]):gsub("%.0$", "") .. v[2] .. "/s"
end
end
return tostring(math.floor(v8618)) .. "/s"
end
local t329 = {}
local u8622
local function v8623(p1301)
local v8624 = tostring(p1301)
if t329[v8624] ~= nil then
local v8625 = t329[v8624] or nil
return v8625
end
if u8622 == nil then
u8622 = false
pcall(function()
local Datas = game:GetService("ReplicatedStorage"):FindFirstChild("Datas")
local Traits = Datas and Datas:FindFirstChild("Traits")
if Traits then
u8622 = require(Traits)
end
end)
end
local v8628 = false
if type(u8622) == "table" then
local v8629 = u8622[v8624]
if type(v8629) == "table" then
local Icon = v8629.Icon
or v8629.Image
or v8629.ImageId
or v8629.Texture
or v8629.IconId
or v8629.Decal
if type(Icon) == "number" then
v8628 = "rbxassetid://" .. Icon
elseif type(Icon) == "string" and Icon ~= "" then
v8628 = Icon:match("^%d+$") and "rbxassetid://" .. Icon or Icon
end
end
end
t329[v8624] = v8628
local v8631 = v8628 or nil
return v8631
end
local v8632
local function v8633(p1302, p1303)
n835 = 266972670
local uid = p1302.uid or p1302.name
local v8635
if p1302.selected == nil then
v8635 = u8615 ~= nil and u8615 == uid
else
v8635 = p1302.selected == true
end
local v8636 = p1302.taken == true
local v8637 = p1302.priority == false
local TextButton = v225("TextButton", {
AutoButtonColor = false,
Text = "",
Size = uDim2New(1, 0, 0, 46),
BorderSizePixel = 0,
BackgroundColor3 = v8636 and T.Bad or v8635 and t15.A or T.Card,
BackgroundTransparency = (v8636 or v8635) and 0.86 or 0,
}, ScrollingFrame)
v226(TextButton, 9)
v227(TextButton, v8636 and T.Bad or v8635 and t15.A or T.Line, 1, 0)
local v8639 = v225
local s36 = "TextLabel"
local v8641 = v8639(s36, {
Size = uDim2New(0, 22, 0, 20),
Position = uDim2New(0, 8, 0.5, -10),
BackgroundColor3 = T.Row,
BorderSizePixel = 0,
Text = tostring(p1303),
TextColor3 = v8637 and T.Dim or T.Text,
Font = Enum.Font.GothamBold,
TextSize = 11,
}, TextButton)
v226(v8641, 5)
local v8642 = (v8636 or v8635) and 70 or 10
v231(TextButton, tostring(p1302.name or "?"), 13, v8637 and T.Dim or T.Text, Enum.Font.GothamBold, {
Size = uDim2New(1, -(38 + v8642), 0, 18),
Position = uDim2New(0, 38, 0, 5),
TextTruncate = Enum.TextTruncate.AtEnd,
})
local Frame4 = v225("Frame", {
Name = "Info",
BackgroundTransparency = 1,
ClipsDescendants = true,
Size = uDim2New(1, -(38 + v8642), 0, 14),
Position = uDim2New(0, 38, 0, 24),
}, TextButton)
v229(Frame4, 4, true).VerticalAlignment = Enum.VerticalAlignment.Center
local v8644 = '<font color="#38D66E">' .. tostring(p1302.mpsText or v8617(p1302.mps) or "?") .. "</font>"
if p1302.mutation and p1302.mutation ~= "" and p1302.mutation ~= "None" then
v8644 ..= "  ·  " .. tostring(p1302.mutation)
end
v231(Frame4, v8644, 11, T.Dim, Enum.Font.GothamMedium, {
RichText = true,
AutomaticSize = Enum.AutomaticSize.X,
Size = uDim2New(0, 0, 1, 0),
})
local n836, Bad
if type(p1302.traits) == "table" then
local n837 = 0
local v8648, v8649, v8650 = ipairs(p1302.traits)
local v8651 = geniter(v8648, v8649, v8650)
local v8652, v8653, v8654
while true do
local v8655 = table.pack(v8651())
if not v8655[1] then
v8652 = v8655[2]
v8653 = v8655[1]
v8654 = v8655[3]
break
end
local v8656 = v8655[3]
v8652 = v8655[2]
v8653 = v8655[1]
v8654 = v8655[3]
local v8657 = v8623(v8656)
if v8657 then
v225("ImageLabel", {
Name = tostring(v8656),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Size = uDim2New(0, 13, 0, 13),
Image = v8657,
ScaleType = Enum.ScaleType.Fit,
}, Frame4)
n837 += 1
if not (n837 >= 6) then
continue
end
else
continue
end
break
end
if p1302.owner then
v231(Frame4, "·  @" .. tostring(p1302.owner), 11, T.Dim, Enum.Font.GothamMedium, {
AutomaticSize = Enum.AutomaticSize.X,
Size = uDim2New(0, 0, 1, 0),
})
end
n836 = 781876995
if v8636 or v8635 then
Bad = v8636 and T.Bad or t15.A
local chip = t15.chip
local v8659 = TextButton
local v8660 = v8636 and "Taken" or "Target"
local exitTo2
local v8662
while true do
v8662 = chip(v8659, v8660, Bad, {
AnchorPoint = Vector2.new(1, 0.5),
Position = uDim2New(1, -8, 0.5, 0),
BackgroundTransparency = 1,
})
if n4 ~= 616971097 then
exitTo2 = 1
break
end
n834 += 1653
n2 += 1684
n835 -= 1243
n836 += 1393
n833 += 1273
n4 = 399474680
n1 += 736
upv448 = nil
local v8663 = v8652[v8654]()
upv448[v8653] = v8663 + v8654
v8652 = v8663 + v8654
if nil < nil then
exitTo2 = 2
break
end
Frame4.TextColor3 = T.Text
Frame4.Font = Enum.Font.GothamBold
Frame4.TextSize = 11
v8641 = v8641(v8642, Frame4, TextButton)
v226(v8641, 5)
v8642 = (v8636 or v8635) and 70 or 10
v231(
TextButton,
tostring(p1302.name or "?"),
13,
v8637 and T.Dim or T.Text,
Enum.Font.GothamBold,
{
Size = uDim2New(1, -(38 + v8642), 0, 18),
Position = uDim2New(0, 38, 0, 5),
TextTruncate = Enum.TextTruncate.AtEnd,
}
)
Frame4 = v225("Frame", {
Name = "Info",
BackgroundTransparency = 1,
ClipsDescendants = true,
Size = uDim2New(1, -(38 + v8642), 0, 14),
Position = uDim2New(0, 38, 0, 24),
}, TextButton)
v229(Frame4, 4, true).VerticalAlignment = Enum.VerticalAlignment.Center
local v8664 = '<font color="#38D66E">'
.. tostring(p1302.mpsText or v8617(p1302.mps) or "?")
.. "</font>"
if p1302.mutation and p1302.mutation ~= "" and p1302.mutation ~= "None" then
v8664 ..= "  ·  " .. tostring(p1302.mutation)
end
v231(Frame4, v8664, 11, T.Dim, Enum.Font.GothamMedium, {
RichText = true,
AutomaticSize = Enum.AutomaticSize.X,
Size = uDim2New(0, 0, 1, 0),
})
if type(p1302.traits) ~= "table" then
if p1302.owner then
v231(Frame4, "·  @" .. tostring(p1302.owner), 11, T.Dim, Enum.Font.GothamMedium, {
AutomaticSize = Enum.AutomaticSize.X,
Size = uDim2New(0, 0, 1, 0),
})
end
n836 = 781876995
if not v8636 and not v8635 then
break
end
Bad = v8636 and T.Bad or t15.A
chip = t15.chip
v8659 = TextButton
v8660 = v8636 and "Taken" or "Target"
continue
end
local n838 = 0
local v8666, v8667, v8668 = ipairs(p1302.traits)
local exitTo
for _, v in v8666, v8667, v8668 do
local v8672 = v8623(v)
if v8672 then
v225("ImageLabel", {
Name = tostring(v),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Size = uDim2New(0, 13, 0, 13),
Image = v8672,
ScaleType = Enum.ScaleType.Fit,
}, Frame4)
n838 += 1
if n838 >= 6 then
exitTo = 1
break
end
end
end
if exitTo == 1 then
exitTo2 = 3
break
end
v8652 = t199_655_1[2]
v8653 = t199_655_1[1]
v8654 = t199_655_1[3]
if p1302.owner then
v231(Frame4, "·  @" .. tostring(p1302.owner), 11, T.Dim, Enum.Font.GothamMedium, {
AutomaticSize = Enum.AutomaticSize.X,
Size = uDim2New(0, 0, 1, 0),
})
end
n836 = 781876995
if v8636 or v8635 then
Bad = v8636 and T.Bad or t15.A
chip = t15.chip
v8659 = TextButton
v8660 = v8636 and "Taken" or "Target"
continue
end
break
end
if exitTo2 == 1 then
v227(v8662, Bad, 1, 0)
elseif exitTo2 == 2 then
(nil)()
elseif exitTo2 == 3 then
if p1302.owner then
v231(Frame4, "·  @" .. tostring(p1302.owner), 11, T.Dim, Enum.Font.GothamMedium, {
AutomaticSize = Enum.AutomaticSize.X,
Size = uDim2New(0, 0, 1, 0),
})
end
n836 = 781876995
if v8636 or v8635 then
Bad = v8636 and T.Bad or t15.A
local chip2 = t15.chip
local v8674 = TextButton
local v8675 = v8636 and "Taken" or "Target"
v8662 = chip2(v8674, v8675, Bad, {
AnchorPoint = Vector2.new(1, 0.5),
Position = uDim2New(1, -8, 0.5, 0),
BackgroundTransparency = 1,
})
v227(v8662, Bad, 1, 0)
TextButton.MouseButton1Click:Connect(function()
local v8676
if p1302.selected == nil then
v8676 = u8615 == uid
else
v8676 = p1302.selected == true
end
if v8676 then
u8615 = nil
else
u8615 = uid
end
s35 = ""
t15.hook("Target Click", p1302, u8615 ~= nil)
v8632()
end)
return
end
end
end
else
if p1302.owner then
v231(Frame4, "·  @" .. tostring(p1302.owner), 11, T.Dim, Enum.Font.GothamMedium, {
AutomaticSize = Enum.AutomaticSize.X,
Size = uDim2New(0, 0, 1, 0),
})
end
n836 = 781876995
if v8636 or v8635 then
Bad = v8636 and T.Bad or t15.A
v227(
t15.chip(TextButton, v8636 and "Taken" or "Target", Bad, {
AnchorPoint = Vector2.new(1, 0.5),
Position = uDim2New(1, -8, 0.5, 0),
BackgroundTransparency = 1,
}),
Bad,
1,
0
)
TextButton.MouseButton1Click:Connect(function()
local v8677
if p1302.selected == nil then
v8677 = u8615 == uid
else
v8677 = p1302.selected == true
end
if v8677 then
u8615 = nil
else
u8615 = uid
end
s35 = ""
t15.hook("Target Click", p1302, u8615 ~= nil)
v8632()
end)
return
end
end
TextButton.MouseButton1Click:Connect(function()
local v8678
if p1302.selected == nil then
v8678 = u8615 == uid
else
v8678 = p1302.selected == true
end
if v8678 then
u8615 = nil
else
u8615 = uid
end
s35 = ""
t15.hook("Target Click", p1302, u8615 ~= nil)
v8632()
end)
end
v8632 = function()
local v8679 = t15.ask("Get Targets")
if type(v8679) ~= "table" then
v8679 = {}
end
v8605.Text = #v8679 .. " found"
local t330 = {}
for i, v in ipairs(v8679) do
t330[i] = tostring(v.uid or v.name)
.. ":"
.. tostring(v.taken)
.. ":"
.. tostring(v.mpsText or v.mps)
.. ":"
.. tostring(v.selected)
.. ":"
.. tostring(v.owner)
.. ":"
.. tostring(v.mutation)
.. ":"
.. (type(v.traits) == "table" and table.concat(v.traits, ",") or "")
end
local v8683 = table.concat(t330, "|") .. tostring(u8615)
if v8683 == s35 then
return
end
s35 = v8683
for _, child in ipairs(ScrollingFrame:GetChildren()) do
if child:IsA("GuiObject") and child ~= v8607 then
child:Destroy()
end
end
v8607.Visible = #v8679 == 0
for i, v in ipairs(v8679) do
if type(v) == "table" then
v8633(v, i)
end
end
end
t15.onAccent(function()
s35 = ""
end)
task.spawn(function()
while t15.sg.Parent do
if v8602.Visible then
pcall(v8632)
end
task.wait(0.4)
end
end)
local u8688
local u8689
v222(RunService.RenderStepped, function()
if not v8602.Visible then
return
end
local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
local attribute = Humanoid and LocalPlayer:GetAttribute("RagdollEndTime")
local v8692 = type(attribute) == "number" and attribute - workspace:GetServerTimeNow() or nil
local state = Humanoid and Humanoid:GetState()
local value = rawget(_G, "SXE_StealStatus")
local name = type(value) == "table"
and type(value.target) == "table"
and (value.target.name or value.target.petName)
or nil
if
Humanoid
and (
state == Enum.HumanoidStateType.Physics
or state == Enum.HumanoidStateType.Ragdoll
or state == Enum.HumanoidStateType.FallingDown
or state == Enum.HumanoidStateType.GettingUp
or v8692 and v8692 > 0
)
then
v8609.Text = tostring(name or "Ragdoll")
if v8692 and v8692 > 0 then
if attribute ~= u8688 then
u8688 = attribute
u8689 = v8692
end
v8614("Ragdoll", string.format("%.1fs", v8692), v8692 / math.max(u8689 or v8692, 0.1), T.Bad)
else
v8614("Ragdoll", "", 1, T.Bad)
end
return
end
u8688 = nil
u8689 = nil
if not C.AutoStealEnabled then
v8609.Text = "Auto steal is off"
v8614("", "", 0, t15.A)
return
end
local attribute2 = LocalPlayer:GetAttribute("Stealing")
if attribute2 ~= nil and attribute2 ~= false then
local text = type(attribute2) == "string" and attribute2
if not text then
text = tostring(name or "Brainrot")
end
v8609.Text = text
v8614("Carrying", "", 1, T.Ok)
return
end
if type(value) == "table" and value.active then
local v8698 = tonumber(value.duration) or 1.3
local v8699 = math.max(tick() - (tonumber(value.start) or tick()), 0)
v8609.Text = tostring(name or "...")
if v8699 < v8698 then
v8614("Grabbing", string.format("%.1fs", v8698 - v8699), v8699 / v8698, t15.A)
else
v8614("Holding", string.format("+%.1fs", v8699 - v8698), 1, t15.A)
end
elseif name then
v8609.Text = tostring(name)
local v8700 = type(value) == "table"
if v8700 then
v8700 = tostring(value.status or "")
end
v8614((v8700 or ""):find("^Waiting") and "Waiting" or "", "", 0, t15.A)
else
v8609.Text = "Searching..."
v8614("", "", 0, t15.A)
end
end)
local n839
local v8702, v8703 = t15.panel("Steal Panel", "Steal", 240, uDim2New(1, -600, 0, 80))
v8599("Visibilities.Steal Panel", v8702)
t15.chipToggle(v8703, "Auto steal", "AutoStealEnabled", "Auto Steal").Size = uDim2New(1, 0, 0, 30)
t15.section(v8703, "Steal mode")
local t331 = {
"Priority",
"Nearest",
}
local _, v8706 = t15.seg(v8703, t331, function()
return C.StealMode == "Nearest" and 2 or 1
end, function(p1304)
local v8707 = t331[p1304]
C.StealMode = v8707
C.StealHighest = false
C.StealPriority = v8707 == "Priority"
local n840 = 657036851
C.StealNearest = v8707 == "Nearest"
t15.save()
t15.notify("StealMode")
t15.hook("Steal Mode", v8707)
if not (n833 < n840) then
n1 -= 1389
n834 = 518254776
n4 = 530869735
n833 += 691
n2 = 726280155
(nil)[nil] = nil
end
end)
t15.bind("StealMode", v8706)
v225("Frame", {
Name = "Gap",
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 2),
}, v8703)
local v8709 = t15.grid(v8703, 30, 2, 6, 0)
t15.chipToggle(v8709, "Auto buy", "AutoBuyEnabled", "Auto Buy")
t15.chipToggle(v8709, "Auto kick", "AutoKickOnSteal", "Auto Kick")
if n2 < n4 then
v225("Frame", {
Name = "AJGap",
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 8),
}, v8703)
else
n2 = 633905595
n1 = 860880690
n834 = 49900524
n833 = 213985126
n4 = 157500308
end
local Frame4 = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 30),
}, v8703)
local v8711 = t15.button(Frame4, "Execute AJ", nil, false, uDim2New(1, -62, 1, 0))
local v8712 = t15.button(Frame4, "Edit", nil, false, uDim2New(0, 56, 1, 0))
v8712.Position = uDim2New(1, -56, 0, 0)
t15.paint(v8712, "TextColor3", "a")
local UIStroke = v8711:FindFirstChildOfClass("UIStroke")
local s37 = ""
pcall(function()
if type(readfile) == "function" and (type(isfile) ~= "function" or isfile("EXEC_AJ_SCRIPT.txt")) then
local txt = readfile("EXEC_AJ_SCRIPT.txt")
if type(txt) == "string" then
s37 = txt
end
end
end)
local v8716, v8717 = t15.panel("AJ Editor", "Execute AJ script", 360, uDim2New(1, -980, 0, 80), {
h = 250,
icon = "X",
onIcon = function(p1305)
n839 = 805281168
if n1 == n839 then
n1 = 322462407
n2 -= 165
n834 = 267513001
n839 = 882388601
n4 -= 1406
n833 -= 199
else
p1305.Visible = false
end
end,
})
local ScrollingFrame2 = v225("ScrollingFrame", {
BackgroundColor3 = T.Row,
BorderSizePixel = 0,
Size = uDim2New(1, -20, 1, -58),
Position = uDim2New(0, 10, 0, 2),
CanvasSize = uDim2New(0, 0, 0, 0),
AutomaticCanvasSize = Y,
ScrollBarThickness = 3,
ScrollBarImageColor3 = T.Line,
ScrollingDirection = Enum.ScrollingDirection.Y,
}, v8717)
v226(ScrollingFrame2, 8)
v227(ScrollingFrame2, T.Line, 1, 0)
local TextBox = v225("TextBox", {
BackgroundTransparency = 1,
Size = uDim2New(1, -14, 0, 150),
Position = uDim2New(0, 7, 0, 6),
AutomaticSize = Y,
Text = s37,
PlaceholderText = "Paste your AJ script here, save it, then press Execute AJ",
PlaceholderColor3 = T.Dim,
TextColor3 = T.Text,
Font = Enum.Font.Code,
TextSize = 11,
MultiLine = true,
ClearTextOnFocus = false,
TextWrapped = true,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
}, ScrollingFrame2)
local v8720 = v231(
v8717,
s37:match("%S") and "AJ script ready" or "Add your AJ script and save it",
11,
T.Dim,
Enum.Font.GothamMedium,
{
Size = uDim2New(1, -114, 0, 30),
Position = uDim2New(0, 10, 1, -44),
TextWrapped = true,
}
)
local v8721 = t15.button(v8717, "Save", nil, true, uDim2New(0, 84, 0, 30))
v8721.Position = uDim2New(1, -94, 1, -46)
local s38 = "idle"
local u8723 = false
local function v8724()
v8711.Text = s38 == "loading" and "Starting..."
or s38 == "active" and "AJ active"
or s38 == "error" and "Retry AJ"
or "Execute AJ"
v8711.TextColor3 = s38 == "error" and T.Bad or s38 == "active" and t15.A or T.Text
if UIStroke then
UIStroke.Color = s38 == "error" and T.Bad or s38 == "active" and t15.A or T.Line
end
end
local function v8725(p1306, p1307)
v8720.Text = p1306
v8720.TextColor3 = p1307 and T.Bad or T.Dim
end
v8712.MouseButton1Click:Connect(function()
v8716.Visible = not v8716.Visible
end)
v8721.MouseButton1Click:Connect(function()
local n841 = 1040715054
local Text = TextBox.Text
if not Text:match("%S") then
v8725("Script is empty", true)
return
end
s37 = Text
local ok = pcall(function()
if type(writefile) ~= "function" then
error("no writefile")
end
writefile("EXEC_AJ_SCRIPT.txt", Text)
end)
if n833 == 554485071 then
n2 += 948
n1 = 151110673
n841 += 123
n833 += 61
n4 = 30210408
n834 -= 215
return (nil)()
end
v8725(ok and "Script saved" or "Saved for this session only", false)
end)
v8711.MouseButton1Click:Connect(function()
if u8723 or s38 == "active" then
return
end
if not s37:match("%S") then
v8716.Visible = true
v8725("Paste and save your AJ script first", true)
return
end
u8723 = true
s38 = "loading"
v8724()
v8725("Starting Auto Join...")
task.spawn(function()
local ok, result = pcall(function()
if type(loadstring) ~= "function" then
error("loadstring is unavailable", 0)
end
local chunk, v8732 = loadstring(s37)
if type(chunk) ~= "function" then
error(v8732 or "Could not compile the script", 0)
end
chunk()
end)
u8723 = false
if ok then
s38 = "active"
v8725("Auto Join is active")
else
s38 = "error"
v8725(tostring(result), true)
v8716.Visible = true
end
v8724()
end)
end)
t15.onAccent(v8724)
v8724()
local n842
t15.later(function()
n842 = 679046779
local n843 = 227994444
local n844 = 461655076
local n845
local n846
local t332 = {
{
"Ragdoll Self (R)",
"btn",
function()
n845 = 516449572
n846 = 420169706
if n833 ~= n846 then
t15.hook("Ragdoll Self")
return
end
n833 = 530189198
n2 += 1095
n843 = 393644554
n4 += 587
n1 -= 916
n845 -= 1461
n844 += 50
n846 = 195401482
bit32.band(nil, nil)
return (nil)()
end,
"Ragdoll Self",
"Ragdoll",
},
{
"Rejoin PS",
"btn",
function()
t15.rejoinPS()
end,
nil,
"Rejoin PS",
},
{
"Rejoin Job ID (J)",
"btn",
function()
t15.rejoinJob()
end,
"Rejoin Job ID",
"Rejoin job",
},
{
"Kick (Y)",
"btn",
function()
t15.kick()
if not (n843 < 626048771) then
n843 += 457
n2 = 126528910
n1 -= 1861
n833 = 903543339
n844 += 122
n834 -= 47
local v8739 = nil + W_0
if not (W_0 <= 0) then
if v8739 <= I_0 then
end
elseif v8739 >= I_0 then
end
end
end,
"Kick",
"Kick",
},
{
"Kick To Private",
"btn",
function()
t15.kickToPrivate()
end,
nil,
"Kick to PS",
},
{
"Reset (X)",
"btn",
function()
t15.hook("Reset")
end,
"Reset",
"Reset",
},
{
"Spam Best Owner",
"btn",
function()
t15.hook("Spam Best Owner")
end,
nil,
"Spam best owner",
},
{
"Teleport",
"btn",
function()
if n843 == 227994523 then
n842 += 1005
n2 = 249001259
n834 -= 350
n844 = 561225879
n1 -= 1232
n843 += 983
bit32.band(nil, nil)
else
t15.hook("Teleport")
end
end,
"Manual TP",
"Teleport",
},
{
"Menu",
"btn",
function()
t15.toggleMain()
if n834 == 315660150 then
n4 = 314800042
n843 += 329
n844 = 461328714
n2 = 934171605
n834 -= 2004
n833 = 747383402
end
end,
"Open Menu",
"Menu",
},
{
"Anti Ragdoll",
"tg",
"AntiRagdoll",
"Anti Ragdoll",
"Anti ragdoll",
},
{
"Infinite Jump",
"tg",
"InfiniteJump",
"Infinite Jump",
"Infinite jump",
},
{
"Float",
"tg",
"Float",
"Float",
"Float",
},
{
"Carpet Speed",
"tg",
"CarpetSpeed",
"Carpet Speed",
"Carpet speed",
},
{
"Auto Turret",
"tg",
"AutoDestroyTurrets",
"Auto Turret",
"Auto turret",
},
{
"WalkSpeed",
"tg",
"WalkSpeedEnabled",
"WalkSpeed",
"WalkSpeed",
},
{
"FPS Boost",
"tg",
"FPSBoost",
"FPS Boost",
"FPS boost",
},
{
"Xray",
"tg",
"XRay",
"Xray",
"Xray",
},
{
"Player ESP",
"tg",
"PlayerESP",
"Player ESP",
"Player ESP",
},
{
"Brainrot ESP",
"tg",
"BrainrotESP",
"Brainrot ESP",
"Brainrot ESP",
},
{
"Base Owner ESP",
"tg",
"BaseOwnerESP",
"Base Owner ESP",
"Base owner ESP",
},
{
"Remote Sell Panel",
"tg",
"RemoteSellEnabled",
"Remote Sell Panel",
"Remote sell",
},
{
"Unwalk",
"tg",
"Unwalk",
"Unwalk",
"Unwalk",
},
{
"Admin Panel UI",
"tg",
"AdminPanelUI",
"Admin Panel UI",
"Admin panel",
},
}
local Actions, v8741 = t15.panel("Actions", "Actions", 250, uDim2New(0.5, 120, 1, -520), {
icon = "Edit",
onIcon = function()
t15.actionSettings()
end,
})
if n843 < n834 then
v8599("Visibilities.Actions", Actions)
else
n4 += 943
n844 += 874
n2 = 464350309
n842 += 154
n833 = 177079799
n843 = 889275301
n1 = 115932183
n834 += 1069
(nil)()
end
local v8742 = t15.grid(v8741, 30, 2, 6, 6)
local v8743 = t15.grid(v8741, 30, 2, 6, 6)
t15.actionsRebuild = function()
for _, child in ipairs(v8742:GetChildren()) do
if child:IsA("GuiObject") then
child:Destroy()
end
end
local n847 = 728382358
for _, child in ipairs(v8743:GetChildren()) do
if child:IsA("GuiObject") then
child:Destroy()
end
end
local visible = false
local visible2 = false
local n848 = 782591783
local n849 = 415613120
local n850
for _, v in ipairs(t332) do
if C.actions[v[1]] then
if v[2] ~= "btn" then
visible2 = true
t15.chipToggle(v8743, v[5], v[3], v[4])
continue
end
visible = true
local v8756 = t15.button(v8742, v[5], v[3])
v8756.TextSize = 11
if not v[4] then
continue
end
local TextLabel = v225("TextLabel", {
BorderSizePixel = 0,
BackgroundTransparency = 0.84,
Size = uDim2New(0, 0, 0, 18),
AutomaticSize = Enum.AutomaticSize.X,
AnchorPoint = Vector2.new(1, 0.5),
Position = uDim2New(1, -6, 0.5, 0),
Font = Enum.Font.GothamBold,
TextSize = 10,
}, v8756)
v226(TextLabel, 5)
v228(TextLabel, 5, 5, 0, 0)
t15.paint(TextLabel, "TextColor3", "a")
t15.paint(TextLabel, "BackgroundColor3", "a")
local function v8758()
n850 = 186304521
local v8759 = t15.key(v[4])
TextLabel.Text = t15.keyText(v8759)
TextLabel.Visible = v8759 ~= "NONE"
v8756.Text = v8759 ~= "NONE" and v[5] .. "      " or v[5]
if n2 < n848 then
return
end
n844 = 782382785
n1 = 861723711
n2 = 993472050
n848 = 122850656
n850 -= 959
n847 -= 1266
n849 = 963035819
return nil
end
v8758()
if n1 < n2 then
table.insert(t15.keyListeners, v8758)
continue
end
n844 = 438625261
n1 -= 1800
n2 -= 1086
n849 -= 653
n843 = 368630841
n848 = 166659782
n833 = 734701407
n847 -= 1188
n834 -= 298
return
end
end
v8742.Visible = visible
v8743.Visible = visible2
end
local u8760
t15.actionSettings = function()
if u8760 then
u8760.Visible = not u8760.Visible
return
end
local v8761, v8762 = t15.panel("Action Settings", "Action settings", 250, uDim2New(0.5, 380, 1, -560), {
icon = "X",
onIcon = function(p1308)
p1308.Visible = false
end,
})
u8760 = v8761
local v8763 = v8762
for _, v in ipairs(t332) do
t15.toggle(v8763, v[1], "actions." .. v[1], nil, {
cb = function()
t15.actionsRebuild()
end,
})
end
u8760.Visible = true
end
end)
t15.later(function()
local v8766, v8767 = t15.panel("Invisible Steal Panel", "Invisible Steal", 310, uDim2New(0, 20, 0.5, -220))
v8599("Visibilities.Invisible Steal Panel", v8766)
t15.section(v8767, "Invisible steal")
local v8768 = t15.grid(v8767, 30, 2, 6, 6)
t15.chipToggle(v8768, "Invisible", "InvisibleSteal", "Invisible Steal")
t15.chipToggle(v8768, "Auto invis", "AutoInvisDuringSteal", "Auto Invis")
t15.chipToggle(v8768, "Real position", "InvisTrueView", "Real Position")
t15.chipToggle(v8768, "Auto rotate", "InvisAutoAngle", "Auto Rotate")
local v8769 = t15.grid(v8767, 56, 2, 6, 0)
t15.stepper(v8769, "Rotation", "InvisStealAngle", "Invis Angle", 0, 360, 5, "%.0f")
t15.stepper(v8769, "Depth", "SinkSliderValue", "Invis Depth", 0.5, 10, 0.1, "%.1f")
local Frame5 = v225("Frame", {
BackgroundColor3 = T.Card,
BorderSizePixel = 0,
Size = uDim2New(1, 0, 0, 62),
}, v8767)
v226(Frame5, 10)
v227(Frame5, T.Line, 1, 0)
v228(Frame5, 10, 10, 8, 8)
t15.tag(Frame5, "walkspeed panel")
local v8771 = t15.slider(Frame5, "Walkspeed", 16, 28, 1, "WalkSpeedValue", "Walk Speed")
t15.tag(v8771, "walkspeed slider")
local TextBox2 = v8771:FindFirstChildOfClass("TextBox")
TextBox2.Size = uDim2New(0, 44, 0, 20)
TextBox2.Position = uDim2New(1, -100, 0, 1)
v8771:FindFirstChildOfClass("TextLabel").Size = uDim2New(1, -106, 0, 22)
local v8773 = t15.pill(v8771, function()
return t15.get("WalkSpeedEnabled")
end, function()
t15.set("WalkSpeedEnabled", t15.get("WalkSpeedEnabled") ~= true, "WalkSpeed")
end)
v8773.Position = uDim2New(1, -50, 0, 0)
t15.tag(v8773, "walkspeed toggle")
t15.bind("WalkSpeedEnabled", function(p1309)
t15.paintPill(v8773, p1309 == true)
end)
end)
t15.later(function()
local v8774, v8775 = t15.panel("Command Cooldowns", "Cooldowns", 220, uDim2New(0.5, -130, 1, -400))
v8599("Visibilities.Command Cooldowns", v8774)
local t333 = {}
for _, v in ipairs({
"jail",
"rocket",
"inverse",
"ragdoll",
"jumpscare",
"tiny",
"balloon",
"morph",
"nightvision",
}) do
local Frame5 = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 24),
}, v8775)
local v8780 = v231
local v8781 = Frame5
local v8782 = v == "nightvision" and "Night vision"
if not v8782 then
v8782 = v:sub(1, 1):upper() .. v:sub(2)
end
v8780(v8781, v8782, 12, T.Text, Enum.Font.GothamMedium, {
Size = uDim2New(0.65, 0, 1, 0),
})
t333[v] = v231(Frame5, "Ready", 12, T.Ok, Enum.Font.GothamBold, {
Size = uDim2New(0.35, 0, 1, 0),
Position = uDim2New(0.65, 0, 0, 0),
TextXAlignment = Enum.TextXAlignment.Right,
})
end
local function v8783(p1310)
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
local AdminPanel = PlayerGui and PlayerGui:FindFirstChild("AdminPanel")
if not AdminPanel then
return nil
end
local n851 = 771573225
local ok, result = pcall(function()
local n852 = 579285642
local n853 = 252330800
if n834 ~= 317430439 then
return AdminPanel.AdminPanel.Content.ScrollingFrame
end
local v8791
while true do
local v8792
local v8793
n2 += 509
n851 -= 769
n834 = 421576098
n852 -= 1806
n1 = 537995451
n853 += 97
v8791 += W_0
if not (W_0 <= 0) then
if not (v8791 <= I_0) then
break
end
v8792[26] = nil
v8793[25] = 14
continue
end
if not (v8791 >= I_0) then
break
end
v8792[26] = nil
v8793[25] = 14
end
upv353 = nil
end)
if not ok or not result then
return nil
end
local v8794 = result:FindFirstChild(p1310)
local Timer = v8794 and v8794:FindFirstChild("Timer")
if not Timer or not Timer.Visible then
return 0
end
local v8796 = tonumber(tostring(Timer.Text):match("%d+")) or 0
return v8796
end
task.spawn(function()
while t15.sg.Parent do
task.wait(0.5)
if v8774.Visible then
for k, v in pairs(t333) do
local Cooldown = t15.ask("Cooldown", k)
if type(Cooldown) ~= "number" then
Cooldown = v8783(k) or 0
end
if Cooldown > 0 then
v.Text = math.ceil(Cooldown) .. "s"
v.TextColor3 = T.Bad
else
v.Text = "Ready"
v.TextColor3 = T.Ok
end
end
end
end
end)
end)
local n854
local n855
t15.later(function()
n854 = 820649391
n855 = 1061139002
local v8802, v8803 = t15.panel("Remote Sell", "Remote sell", 230, uDim2New(0, 280, 1, -380))
v8599("RemoteSellEnabled", v8802)
local n856 = 808729583
local n857 = -10
t15.buttons(v8803, {
{
"Sell all",
function(p1311)
if os.clock() - n857 > 2 then
n857 = os.clock()
p1311.Text = "Confirm"
task.delay(2, function()
if os.clock() - n857 >= 2 then
if p1311.Text == "Confirm" then
p1311.Text = "Sell all"
end
end
end)
return
end
n857 = -10
p1311.Text = "Selling..."
t15.hook("Remote Sell All")
task.delay(1, function()
p1311.Text = "Sell all"
end)
end,
true,
},
{
"Sell random",
function()
t15.hook("Sell Random")
end,
},
})
t15.toggle(v8803, "Auto sell before delivering", "AutoSellDeliver", "Auto Sell Deliver")
local n858
local function v8807(p1312)
n858 = 380194017
local v8808 = tonumber(p1312)
if not v8808 then
return nil
end
for _, v in ipairs({
{
1e12,
"T",
},
{
1e9,
"B",
},
{
1000000,
"M",
},
{
1000,
"K",
},
}) do
if v[1] <= v8808 then
return string.format("%.1f", v8808 / v[1]):gsub("%.0$", "") .. v[2] .. "/s"
end
end
if n834 == 1003485839 then
return tostring(math.floor(v8808)) .. "/s"
end
n1 = 967780986
n858 -= 1050
n833 = 480447407
n2 = 423530584
n834 -= 359
n856 -= 693
local v8811
local v8812
n855 += 286
while true do
v8811[5] = nil
v8812[36] = 1
n855 += 286
end
end
local v8813 = v231(v8803, "Loading...", 11, T.Dim, Enum.Font.GothamMedium, {
Size = uDim2New(1, 0, 0, 18),
})
local Frame5 = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 0),
AutomaticSize = Y,
}, v8803)
v229(Frame5, 4)
local s39 = ""
local n859
task.spawn(function()
n859 = 822433728
while true do
if t15.sg.Parent then
task.wait(0.5)
if n4 == 616970130 then
n4 -= 1403
n854 -= 1588
n859 -= 1566
n834 -= 332
n2 = 633003965
n1 += 861
n856 = 483190457
end
if v8802.Visible then
break
end
else
return
end
end
local exitTo
repeat
pcall(function()
local v8818 = t15.ask("Remote Sell Scan")
if type(v8818) ~= "table" then
v8813.Text = "Loading..."
return
end
v8813.Text = #v8818 == 0 and "Nothing to sell" or #v8818 .. " brainrot(s) ready"
local t334 = {}
for i, v in ipairs(v8818) do
t334[i] = tostring(v.slot) .. ":" .. tostring(v.name) .. ":" .. tostring(v.mutation)
end
local v8822 = table.concat(t334, "|")
if v8822 == s39 then
return
end
s39 = v8822
for _, child in ipairs(Frame5:GetChildren()) do
if child:IsA("GuiObject") then
child:Destroy()
end
end
for _, v in ipairs(v8818) do
local t335 = {}
if v.mutation and v.mutation ~= "" then
t335[#t335 + 1] = tostring(v.mutation)
end
if v8807(v.income) then
t335[#t335 + 1] = v8807(v.income)
end
local v8828 = #t335 > 0
local Frame6 = v225("Frame", {
BackgroundColor3 = T.Card,
BorderSizePixel = 0,
Size = uDim2New(1, 0, 0, v8828 and 36 or 30),
}, Frame5)
v226(Frame6, 7)
local v8830 = v231
local v8831 = Frame6
local v8832 = tostring(v.name or "Slot " .. tostring(v.slot))
local n860 = 12
local Text = T.Text
local GothamBold = Enum.Font.GothamBold
local v8837 = uDim2New
local n861 = 1
local n862 = -64
local n863 = 0
local t336 = {
Size = v8837(n861, n862, n863, v8828 and 16 or 30),
Position = uDim2New(0, 8, n863, v8828 and 3 or 0),
TextTruncate = Enum.TextTruncate.AtEnd,
}
v8830(v8831, v8832, n860, Text, GothamBold, t336)
if v8828 then
v231(Frame6, table.concat(t335, "  ·  "), 10, T.Dim, Enum.Font.GothamMedium, {
Size = uDim2New(1, -64, 0, 13),
Position = uDim2New(0, 8, 0, 19),
TextTruncate = Enum.TextTruncate.AtEnd,
})
end
local v8841 = t15.button(Frame6, "Sell", nil, true, uDim2New(0, 48, 0, 22))
v8841.Position = uDim2New(1, -54, 0.5, -11)
v8841.TextSize = 11
v8841.MouseButton1Click:Connect(function()
t15.hook("Remote Sell", v)
v8841.Text = "Sold"
task.delay(0.5, function()
s39 = ""
end)
end)
end
end)
exitTo = nil
while t15.sg.Parent do
task.wait(0.5)
if v8802.Visible then
exitTo = 1
break
end
end
until exitTo ~= 1
end)
end)
local n864
t15.later(function()
n864 = 336846980
local v8843, v8844 = t15.panel("Open Base", "Open base", 170, uDim2New(0, 30, 0, 220))
v8599("OpenBase", v8843)
local Frame5 = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 40),
}, v8844)
local v8846 = v229(Frame5, 8, true)
local n865 = 712354331
if n2 < n4 then
v8846.HorizontalAlignment = Enum.HorizontalAlignment.Center
else
n864 = 516907614
n833 -= 578
n865 -= 831
n4 += 567
n1 = 568104626
n2 += 135
n834 = 1064343645
upv187[nil] = nil
bit32.band(nil, nil)
end
for i = 1, 3 do
t15.button(Frame5, tostring(i), function(p1313)
t15.hook("Open Base", i)
local n866 = 124693673
if n4 == 616969873 then
v230(p1313, {
BackgroundColor3 = T.Ok,
}, 0.08)
else
n865 += 1900
n1 -= 442
n2 += 1563
n866 += 1511
n4 -= 810
n864 += 963
n833 += 906
upv16[nil] = nil
(nil)[nil] = nil
upv272[nil] = nil
upv80[nil] = nil
end
task.delay(0.18, function()
v230(p1313, {
BackgroundColor3 = T.Row,
}, 0.18)
end)
end, false, uDim2New(0, 40, 0, 40))
end
end)
end
v233()
v234 = function()
local n867 = 34986070
local n868 = 775975586
local T = t15.T
local C = t15.C
local Y = Enum.AutomaticSize.Y
local n869 = 137872696
local function v8856(p1314)
if C.apBlacklist[tostring(p1314.UserId)] == true then
return true
end
local v8857 = p1314.Name:lower()
for _, apBlacklistName in ipairs(C.apBlacklistNames) do
if tostring(apBlacklistName):lower() == v8857 then
return true
end
end
return false
end
local function v8860(p1315)
local X = t15.X
local value = rawget(_G, "SXE_repList")
if 493846259 == n867 then
n867 = 26569678
n2 += 887
n868 = 96990264
n869 = 487684210
n1 -= 1960
n4 += 117
upv179[nil] = nil
return
end
return X and X.IsFmly and X.IsFmly(p1315)
or type(value) == "table" and type(value.fmlyGood) == "table" and value.fmlyGood[p1315.Name:lower()] == true
or false
end
local function v8863(p1316)
local X = t15.X
local value = rawget(_G, "SXE_repList")
if n869 == 938901305 then
n869 -= 310
n2 -= 1390
n4 += 1614
n867 = 1001183003
n1 -= 1877
n868 = 259152981
bit32.bxor(nil, nil)
return
end
local IsSon = X and X.IsSon and X.IsSon(p1316)
if not IsSon then
IsSon = type(value) == "table"
and type(value.sonGood) == "table"
and value.sonGood[p1316.Name:lower()] == true
end
return IsSon or false
end
local function v8867(p1317)
if C.GriefSafeGood == true then
return false
end
local value = rawget(_G, "SXE_repList")
if n867 == 34987357 then
n868 += 1549
n1 = 345573917
n2 += 672
n869 = 461857396
n867 = 514651570
n4 = 212879418
return
end
return v8860(p1317)
or v8863(p1317)
or type(value) == "table" and type(value.good) == "table" and value.good[p1317.Name:lower()] == true
end
t15.apBlocked = function(p1318)
return v8856(p1318) or v8867(p1318)
end
local n870
local n871
t15.later(function()
n870 = 55021122
n871 = 310341202
local v8871, v8872, v8873 = t15.panel("Admin Panel", "Admin panel", 350, uDim2New(0, 20, 1, -430), {
h = 390,
resize = true,
minW = 320,
minH = 240,
})
local n872 = 820156303
t15.bind("AdminPanelUI", function(p1319)
v8871.Visible = p1319 == true
end)
local v8875 = v231(v8873, "", 11, T.Dim, Enum.Font.GothamMedium, {
Size = uDim2New(0, 90, 1, 0),
Position = uDim2New(1, -104, 0, 0),
TextXAlignment = Enum.TextXAlignment.Right,
})
local t337 = {}
for i = 1, 3 do
t337[i] = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, -16, 1, -82),
Position = uDim2New(0, 8, 0, 76),
Visible = i == 1,
}, v8872)
end
local n873 = 1
local n874
t15.seg(
v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, -16, 0, 30),
Position = uDim2New(0, 8, 0, 2),
}, v8872),
{
"Players",
"Blacklist",
"Settings",
},
function()
n874 = 460346035
if n867 == 34986070 then
return n873
end
n870 += 1525
n2 = 254248794
n868 -= 163
n867 = 181007975
n874 += 1395
n4 -= 1611
n872 = 139559039
(nil)[110] = nil
(nil)[111] = nil
(nil)[112] = nil
(nil)[113] = nil
(nil)[114] = nil
(nil)[115] = nil
(nil)[116] = nil
(nil)[117] = nil
(nil)[118] = nil
(nil)[119] = nil
(nil)[120] = nil
(nil)[121] = nil
(nil)[122] = nil
(nil)[123] = nil
(nil)[124] = nil
(nil)[125] = nil
(nil)[126] = nil
(nil)[127] = nil
(nil)[128] = nil
(nil)[129] = nil
(nil)[130] = nil
(nil)[131] = nil
(nil)[132] = nil
(nil)[133] = nil
(nil)[134] = nil
(nil)[135] = nil
(nil)[136] = nil
(nil)[137] = nil
(nil)[138] = nil
(nil)[139] = nil
(nil)[140] = nil
(nil)[141] = nil
(nil)[142] = nil
(nil)[143] = nil
(nil)[144] = nil
(nil)[145] = nil
(nil)[146] = nil
(nil)[147] = nil
(nil)[148] = nil
(nil)[149] = nil
(nil)[150] = nil
(nil)[151] = nil
(nil)[152] = nil
(nil)[153] = nil
(nil)[154] = nil
(nil)[155] = nil
(nil)[156] = nil
(nil)[157] = nil
(nil)[158] = nil
(nil)[159] = nil
(nil)[160] = nil
(nil)[161] = nil
(nil)[162] = nil
(nil)[163] = nil
(nil)[164] = nil
(nil)[165] = nil
(nil)[166] = nil
(nil)[167] = nil
(nil)[168] = nil
(nil)[169] = nil
(nil)[170] = nil
(nil)[171] = nil
(nil)[172] = nil
(nil)[173] = nil
(nil)[174] = nil
(nil)[175] = nil
(nil)[176] = nil
(nil)[177] = nil
(nil)[178] = nil
(nil)[179] = nil
(nil)[180] = nil
(nil)[181] = nil
(nil)[182] = nil
(nil)[183] = nil
(nil)[184] = nil
(nil)[185] = nil
(nil)[186] = nil
(nil)[187] = nil
(nil)[188] = nil
(nil)[189] = nil
(nil)[190] = nil
(nil)[191] = nil
(nil)[192] = nil
(nil)[193] = nil
(nil)[194] = nil
(nil)[195] = nil
(nil)[196] = nil
end,
function(p1320)
n873 = p1320
for i = 1, 3 do
t337[i].Visible = i == p1320
end
end
)
local v8881 = t15.grid(
v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, -16, 0, 30),
Position = uDim2New(0, 8, 0, 38),
}, v8872),
30,
3,
6,
0
)
t15.statusChip(v8881, "Click to AP", "ClickToAP", "Click to AP")
t15.statusChip(v8881, "Proximity", "ProximityAP", "Proximity")
t15.button(v8881, "Spam base owner", function()
t15.hook("Spam Base Owner")
end, true).TextSize = 11
local function v8882(p1321, p1322)
local ScrollingFrame = v225("ScrollingFrame", {
BackgroundTransparency = 1,
BorderSizePixel = 0,
Size = uDim2New(1, 0, 1, 0),
CanvasSize = uDim2New(0, 0, 0, 0),
AutomaticCanvasSize = Y,
ScrollBarThickness = 3,
ScrollBarImageColor3 = T.Line,
ScrollingDirection = Enum.ScrollingDirection.Y,
}, p1321)
v229(ScrollingFrame, p1322 or 5)
v228(ScrollingFrame, 0, 6, 0, 6)
return ScrollingFrame
end
local v8884 = v8882(t337[1], 5)
local t338 = {
["Boogie Bomb"] = true,
["Medusa's Head"] = true,
["Body Swap Potion"] = true,
["Laser Cape"] = true,
["Rainbowrath Sword"] = true,
["Gummy Bear"] = true,
}
local t339 = {}
local function v8887(p1323)
local value = rawget(_G, "SXE_repList")
local v8889 = p1323.Name:lower()
local s40 = ""
local function v8891(p1324)
return type(value) == "table" and type(p1324) == "table" and p1324[v8889] == true
end
if C.FmlyEspTag and v8860(p1323) then
s40 ..= '  <font color="#FFD84D">FMLY</font>'
end
if C.SonEspTag and v8863(p1323) then
s40 ..= '  <font color="#4FB6F0">SON</font>'
end
if C.FmlyEspTag then
if v8891(value and value.fmlyBad) then
s40 ..= '  <font color="#EB5757">Griefer</font>'
elseif C.SonEspTag then
local v8892 = v8891
local sonBad = value and value.sonBad
if v8892(sonBad) then
s40 ..= '  <font color="#EB5757">Griefer</font>'
end
end
elseif C.SonEspTag then
if v8891(value and value.sonBad) then
s40 ..= '  <font color="#EB5757">Griefer</font>'
end
end
local X = t15.X
if C.ESPTagBraintopia and X and X.IsBT and X.IsBT(p1323) then
s40 ..= '  <font color="#AA50FF">BT</font>'
end
local Character = p1323.Character
if C.ESPTagKawaifu and Character and Character:FindFirstChild("KaWaifu_NeonHighlight") then
s40 ..= '  <font color="#FFD84D">KAWAIFU</font>'
end
return s40
end
local function v8896()
local t340 = {}
local AdminPanelOrder = C.AdminPanelOrder or t15.AP
for _, v in ipairs(AdminPanelOrder) do
if C.AdminPanelButtons[v] then
t340[#t340 + 1] = v
end
end
if #t340 == 0 then
t340 = {
"ragdoll",
"jail",
"rocket",
"balloon",
}
end
return t340
end
local function v8901(p1325)
v230(p1325, {
BackgroundColor3 = T.Bad,
}, 0.08)
task.delay(0.3, function()
v230(p1325, {
BackgroundColor3 = T.Card,
}, 0.2)
end)
end
local function v8902(p1326)
if p1326 == LocalPlayer or t339[p1326] then
return
end
local Frame = v225("Frame", {
Active = true,
BackgroundColor3 = T.Card,
BorderSizePixel = 0,
Size = uDim2New(1, 0, 0, 56),
}, v8884)
v226(Frame, 10)
local v8904 = v227(Frame, T.Line, 1, 0)
local ImageLabel = v225("ImageLabel", {
Size = uDim2New(0, 34, 0, 34),
Position = uDim2New(0, 8, 0.5, -17),
BackgroundColor3 = T.Row,
BorderSizePixel = 0,
Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(p1326.UserId) .. "&w=150&h=150",
}, Frame)
v226(ImageLabel, 17)
local v8906 = v8896()
local v8907 = (#v8906 + 1) * 27
local v8908 = v231(Frame, p1326.DisplayName, 13, T.Text, Enum.Font.GothamBold, {
Size = uDim2New(1, -(v8907 + 62), 0, 16),
Position = uDim2New(0, 50, 0, 6),
TextTruncate = Enum.TextTruncate.AtEnd,
})
local v8909 = v231(Frame, "@" .. p1326.Name .. v8887(p1326), 11, T.Dim, Enum.Font.GothamMedium, {
RichText = true,
Size = uDim2New(1, -(v8907 + 62), 0, 14),
Position = uDim2New(0, 50, 0, 22),
TextTruncate = Enum.TextTruncate.AtEnd,
})
local v8910 = v231(Frame, "", 11, T.Dim, Enum.Font.GothamBold, {
Size = uDim2New(1, -(v8907 + 62), 0, 14),
Position = uDim2New(0, 50, 0, 37),
TextTruncate = Enum.TextTruncate.AtEnd,
})
local Frame2 = v225("Frame", {
BackgroundTransparency = 1,
AnchorPoint = Vector2.new(1, 0.5),
Position = uDim2New(1, -8, 0.5, 0),
Size = uDim2New(0, v8907, 0, 24),
}, Frame)
v229(Frame2, 3, true)
for _, v in ipairs(v8906) do
local TextButton = v225("TextButton", {
AutoButtonColor = false,
Size = uDim2New(0, 24, 0, 24),
BackgroundColor3 = T.Row,
BorderSizePixel = 0,
Text = t15.EMO[v] or "⚡",
TextSize = 13,
Font = Enum.Font.GothamBold,
TextColor3 = T.Text,
}, Frame2)
v226(TextButton, 7)
TextButton.MouseEnter:Connect(function()
TextButton.BackgroundColor3 = T.RowH
end)
TextButton.MouseLeave:Connect(function()
TextButton.BackgroundColor3 = T.Row
end)
TextButton.MouseButton1Click:Connect(function()
if not v8867(p1326) then
if not v8856(p1326) then
t15.hook("Admin Command", p1326, v)
return
end
end
v8901(Frame)
end)
end
local TextButton = v225("TextButton", {
AutoButtonColor = false,
Size = uDim2New(0, 24, 0, 24),
BorderSizePixel = 0,
Text = "X",
TextSize = 12,
Font = Enum.Font.GothamBold,
}, Frame2)
v226(TextButton, 7)
local function v8916()
local v8917 = v8856(p1326)
TextButton.BackgroundColor3 = v8917 and color3(255, 60, 60) or color3(58, 26, 30)
TextButton.TextColor3 = v8917 and T.White or color3(255, 90, 90)
Frame.BackgroundTransparency = v8917 and 0.6 or 0
ImageLabel.ImageTransparency = v8917 and 0.7 or 0
v8908.TextTransparency = v8917 and 0.5 or 0
v8909.Text = "@" .. p1326.Name .. v8887(p1326)
end
TextButton.MouseButton1Click:Connect(function()
local v8918 = v8856(p1326)
if v8918 then
C.apBlacklist[tostring(p1326.UserId)] = nil
local v8919 = p1326.Name:lower()
local v8920 = p1326.DisplayName:lower()
for i = #C.apBlacklistNames, 1, -1 do
local v8922 = tostring(C.apBlacklistNames[i]):lower()
if v8922 == v8919 or v8922 == v8920 then
table.remove(C.apBlacklistNames, i)
end
end
else
C.apBlacklist[tostring(p1326.UserId)] = true
end
t15.save()
v8916()
if t15.refreshBlacklist then
t15.refreshBlacklist()
end
t15.hook("Blacklist", p1326, not v8918)
end)
Frame.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton2 then
t15.hook("Admin Mark", p1326)
return
end
if
input.UserInputType ~= Enum.UserInputType.MouseButton1
and input.UserInputType ~= Enum.UserInputType.Touch
then
return
end
local v8923 = t15.pointer(input)
local AbsolutePosition = Frame2.AbsolutePosition
local AbsoluteSize = Frame2.AbsoluteSize
if
AbsolutePosition.X <= v8923.X
and v8923.X <= AbsolutePosition.X + AbsoluteSize.X
and AbsolutePosition.Y <= v8923.Y
and v8923.Y <= AbsolutePosition.Y + AbsoluteSize.Y
then
return
end
if v8867(p1326) or v8856(p1326) then
v8901(Frame)
return
end
if not t15.hook("Admin Fire All", p1326) then
for _, v in ipairs(t15.AP) do
t15.hook("Admin Command", p1326, v)
end
end
end)
v8916()
t339[p1326] = {
r = Frame,
st = v8910,
nm = v8908,
rs = v8904,
paint = v8916,
}
end
t15.adminRepaint = function()
for _, v in pairs(t339) do
pcall(v.paint)
end
end
t15.adminRebuild = function()
for _, v in pairs(t339) do
v.r:Destroy()
end
table.clear(t339)
for _, player in ipairs(Players:GetPlayers()) do
v8902(player)
end
end
t15.adminRebuild()
local n875
v222(Players.PlayerAdded, function(p1327)
n875 = 66104078
task.defer(v8902, p1327)
if n875 ~= n869 then
return
end
n871 += 1434
n869 = 739380580
n875 -= 1803
n872 = 540068516
n867 -= 908
n2 += 1903
n4 -= 1945
return (nil)()
end)
local n876
v222(Players.PlayerRemoving, function(p1328)
n876 = 4331793
local v8936 = t339[p1328]
if v8936 then
v8936.r:Destroy()
t339[p1328] = nil
end
if not (n876 < n2) then
n868 += 1998
n872 -= 1734
n876 -= 1800
n2 -= 800
n867 = 936894228
n871 = 47727192
n869 = 207063408
upv51 = nil
end
end)
task.spawn(function()
local n877 = 666514222
local n878 = 299485985
while t15.sg.Parent do
task.wait(0.5)
v8875.Text = tostring(math.max(#Players:GetPlayers() - 1, 0)) .. " players"
if v8871.Visible and t337[1].Visible then
local u8939
local value = rawget(_G, "__getCurrentBaseOwnerId")
if type(value) == "function" then
pcall(function()
u8939 = value()
end)
end
for k, v in pairs(t339) do
pcall(v.paint)
local v8943, v8944 = t15.ask("Stealing Info", k)
local attribute = k:GetAttribute("Stealing")
if not v8943 and attribute ~= nil and attribute ~= false then
v8943 = type(attribute) == "string" and attribute or "a brainrot"
end
if v8943 then
v.st.Text = "● Stealing "
.. tostring(v8943)
.. (v8944 and " from " .. tostring(v8944) or "")
v.st.TextColor3 = T.Bad
elseif u8939 and u8939 == k.UserId then
v.st.Text = "● Base owner"
if n2 ~= 557240548 then
n870 = 445713253
n869 += 2040
n2 += 695
n877 -= 1382
n868 = 1058008293
n872 += 746
n1 += 1648
n878 -= 808
(nil)[nil] = nil
return (nil)()
end
v.st.TextColor3 = T.Ok
elseif k:GetAttribute("AdminCommands") == true then
v.st.Text = "Has AP"
v.st.TextColor3 = T.Warn
else
v.st.Text = ""
end
local v8946 = t15.ask("Admin Marked", k) == true
v.rs.Color = v8946 and T.Bad or T.Line
v.rs.Thickness = v8946 and 1.5 or 1
if v8946 and v.st.Text == "" then
v.st.Text = "● Marked for spam"
v.st.TextColor3 = T.Bad
end
local Character = k.Character
local Tool = Character and Character:FindFirstChildOfClass("Tool")
v.nm.TextColor3 = Tool and t338[Tool.Name] and color3(255, 60, 60) or T.Text
end
end
end
end)
local Frame = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 30),
}, t337[2])
local v8950 = t15.textbox(Frame, "Roblox username", {
Size = uDim2New(1, -74, 1, 0),
TextSize = 12,
})
local v8951 = t15.button(Frame, "Add", nil, true, uDim2New(0, 66, 1, 0))
v8951.Position = uDim2New(1, -66, 0, 0)
local v8952 = v8882(
v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 1, -38),
Position = uDim2New(0, 0, 0, 38),
}, t337[2]),
4
)
t15.refreshBlacklist = function()
for _, child in ipairs(v8952:GetChildren()) do
if child:IsA("GuiObject") then
child:Destroy()
end
end
if #C.apBlacklistNames == 0 then
v231(v8952, "Nobody is blacklisted", 12, T.Dim, Enum.Font.GothamMedium, {
Size = uDim2New(1, 0, 0, 30),
TextXAlignment = Enum.TextXAlignment.Center,
})
end
for i, apBlacklistName in ipairs(C.apBlacklistNames) do
local Frame2 = v225("Frame", {
BackgroundColor3 = T.Card,
BorderSizePixel = 0,
Size = uDim2New(1, 0, 0, 30),
}, v8952)
v226(Frame2, 8)
v231(Frame2, tostring(apBlacklistName), 12, T.Text, Enum.Font.GothamMedium, {
Size = uDim2New(1, -44, 1, 0),
Position = uDim2New(0, 10, 0, 0),
TextTruncate = Enum.TextTruncate.AtEnd,
})
local TextButton = v225("TextButton", {
AutoButtonColor = false,
Size = uDim2New(0, 24, 0, 22),
Position = uDim2New(1, -30, 0.5, -11),
BackgroundColor3 = color3(58, 26, 30),
BorderSizePixel = 0,
Text = "X",
TextColor3 = color3(255, 90, 90),
TextSize = 11,
Font = Enum.Font.GothamBold,
}, Frame2)
v226(TextButton, 6)
TextButton.MouseButton1Click:Connect(function()
table.remove(C.apBlacklistNames, i)
t15.save()
t15.refreshBlacklist()
t15.adminRepaint()
end)
end
end
local function v8959()
local v8960 = v8950.Text:gsub("%s", "")
v8950.Text = ""
if v8960 == "" then
return
end
for _, apBlacklistName in ipairs(C.apBlacklistNames) do
if tostring(apBlacklistName):lower() == v8960:lower() then
return
end
end
table.insert(C.apBlacklistNames, v8960)
t15.save()
t15.refreshBlacklist()
t15.adminRepaint()
end
v8951.MouseButton1Click:Connect(v8959)
v8950.FocusLost:Connect(function(enterPressed)
if enterPressed then
v8959()
end
end)
t15.refreshBlacklist()
local n879
local v8964 = v8882(t337[3], 2)
local function v8965(p1329, p1330, p1331, p1332, p1333)
local v8966 = p1333 or {}
v8966.pill = true
return t15.toggle(p1329, p1330, p1331, p1332, v8966)
end
local function v8967()
t15.adminRepaint()
end
t15.section(v8964, "Auto AP")
t15.slider(v8964, "Proximity distance", 1, 50, 1, "ProximityRange", "Proximity Range", " studs")
v8965(v8964, "Single command click AP", "ClickToAPSingleCommand", "Click AP Single Command")
local t341 = {
"Kawaifu",
"Braintopia",
}
t15.section(v8964, "ESP tags")
v8965(v8964, "SON ESP tag", "SonEspTag", "SON ESP Tag", {
cb = v8967,
})
v8965(v8964, "FMLY ESP tag", "FmlyEspTag", "FMLY ESP Tag", {
cb = v8967,
})
for _, v in ipairs(t341) do
v8965(v8964, v .. " ESP tag", "ESPTag" .. v, "ESPTag" .. v)
end
if not (n870 < n872) then
n872 -= 20
n868 -= 1117
n870 = 388261198
n1 -= 1046
n4 -= 1891
n2 = 989688851
n871 = 1071932317
n867 = 593164363
n869 = 488196258
(nil)()
upv269[nil] = nil
return nil
end
t15.section(v8964, "FMLY / SON")
v8965(v8964, "Grief FMLY/SON players", "GriefSafeGood", "Grief Safe Good")
local t342 = {
{
"Click AP",
"DisableClickAPOn",
},
{
"Prox AP",
"DisableProxAPOn",
},
{
"AP panel",
"DisableAPPanelOn",
},
}
local function v8972(p1334)
return uDim2New(1, (p1334 - 4) * 56 + 6, 0.5, 0)
end
local Frame2 = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 22),
}, v8964)
v231(Frame2, "Skip hub users", 11, T.Dim, Enum.Font.GothamBold, {
Size = uDim2New(1, -168, 1, 0),
})
for i, v in ipairs(t342) do
v231(Frame2, v[1], 10, T.Dim, Enum.Font.GothamBold, {
Size = uDim2New(0, 50, 1, 0),
AnchorPoint = Vector2.new(0, 0.5),
Position = v8972(i),
TextXAlignment = Enum.TextXAlignment.Center,
})
end
for _, v in ipairs(t341) do
local Frame3 = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 30),
}, v8964)
v231(Frame3, v, 12, T.Text, Enum.Font.GothamMedium, {
Size = uDim2New(1, -168, 1, 0),
TextTruncate = Enum.TextTruncate.AtEnd,
})
for i, v2 in ipairs(t342) do
local v8981 = v2[2] .. v
local v8982, v8983 = t15.pill(Frame3, function()
return t15.get(v8981)
end, function()
t15.set(v8981, t15.get(v8981) ~= true, v8981)
end)
v8982.AnchorPoint = Vector2.new(0, 0.5)
v8982.Position = v8972(i)
t15.tag(v8982, v .. " " .. v2[1])
t15.bind(v8981, function()
v8983()
if not (n4 < n872) then
n869 = 898644133
n867 += 194
n871 = 286602262
n4 = 445243019
n872 = 1036856150
n2 = 764655310
end
end)
end
end
t15.section(v8964, "Command config")
t15.buttons(v8964, {
{
"Admin panel",
function()
t15.cmdConfig("AdminPanelCmds")
end,
},
{
"Click to AP",
function()
t15.cmdConfig("ClickToAPCmds")
end,
},
{
"Spam owner",
function()
local v8984
local v8985
n879 = 536503198
if n4 == 616970838 then
n872 += 1960
n870 -= 411
n879 += 1621
n871 = 851499392
n867 -= 1624
n4 = 457086520
n2 = 236870758
v8984(v8985)
else
t15.cmdConfig("SpamBaseOwnerCmds")
end
end,
},
})
local t343 = {
AdminPanelCmds = {
"Admin panel commands",
"AdminPanelButtons",
"AdminPanelOrder",
},
ClickToAPCmds = {
"Click to AP commands",
"ClickToAPCommands",
"ClickToAPOrder",
},
SpamBaseOwnerCmds = {
"Spam base owner commands",
"SpamBaseOwnerCommands",
"SpamBaseOwnerOrder",
},
}
local t344 = {}
local n880
t15.cmdConfig = function(p1335)
n880 = 709579851
if t344[p1335] then
t344[p1335].Visible = not t344[p1335].Visible
return
end
local n881 = 928555276
local v8990 = t343[p1335]
if not v8990 then
return
end
local n882 = 722921671
if type(C[v8990[3]]) ~= "table" or #C[v8990[3]] == 0 then
C[v8990[3]] = t15.copy(t15.AP)
end
if type(C[v8990[2]]) ~= "table" then
C[v8990[2]] = {}
end
local v8992, v8993 = t15.panel(p1335, v8990[1], 260, uDim2New(0.5, 140, 0.5, -220), {
icon = "X",
onIcon = function(p1336)
p1336.Visible = false
end,
})
t344[p1335] = v8992
local Frame3 = v225("Frame", {
BackgroundTransparency = 1,
Size = uDim2New(1, 0, 0, 0),
AutomaticSize = Y,
}, v8993)
v229(Frame3, 3)
local v8995
local function v8996()
t15.save()
t15.hook("Command Config", p1335, C[v8990[2]], C[v8990[3]])
if p1335 == "AdminPanelCmds" then
t15.adminRebuild()
end
v8995()
end
v8995 = function()
local n883 = 193436740
for _, child in ipairs(Frame3:GetChildren()) do
if child:IsA("GuiObject") then
child:Destroy()
end
end
local n884 = 682543179
local v9001 = C[v8990[3]]
local n885
local n886
for i, v in ipairs(v9001) do
local Frame4 = v225("Frame", {
BackgroundColor3 = T.Card,
BorderSizePixel = 0,
Size = uDim2New(1, 0, 0, 30),
}, Frame3)
v226(Frame4, 7)
v231(Frame4, tostring(i), 11, T.Dim, Enum.Font.GothamBold, {
Size = uDim2New(0, 16, 1, 0),
Position = uDim2New(0, 6, 0, 0),
})
local TextButton = v225("TextButton", {
AutoButtonColor = false,
BackgroundTransparency = 1,
Text = "▲",
TextSize = 9,
Font = Enum.Font.GothamBold,
TextColor3 = T.Dim,
Size = uDim2New(0, 18, 0, 14),
Position = uDim2New(0, 22, 0, 1),
}, Frame4)
local TextButton2 = v225("TextButton", {
AutoButtonColor = false,
BackgroundTransparency = 1,
Text = "▼",
TextSize = 9,
Font = Enum.Font.GothamBold,
TextColor3 = T.Dim,
Size = uDim2New(0, 18, 0, 14),
Position = uDim2New(0, 22, 0, 15),
}, Frame4)
local v9009 = v231
local v9010 = Frame4
local v9011 = v == "nightvision" and "Night vision"
if not v9011 then
v9011 = tostring(v):sub(1, 1):upper() .. tostring(v):sub(2)
end
v9009(v9010, v9011, 12, T.Text, Enum.Font.GothamMedium, {
Size = uDim2New(1, -100, 1, 0),
Position = uDim2New(0, 46, 0, 0),
})
local v9012 = t15.pill(Frame4, function()
return C[v8990[2]][v] == true
end, function()
n885 = 683449401
n886 = 496389769
C[v8990[2]][v] = C[v8990[2]][v] ~= true
if n884 < n885 then
v8996()
return
end
n886 -= 72
n882 -= 887
n884 = 340947898
n869 += 934
n885 = 407443502
n2 = 895311770
n883 = 608106406
(nil)(nil, nil)
return (nil)()
end)
v9012.AnchorPoint = Vector2.new(1, 0.5)
if n871 == 310342166 then
n884 -= 282
n883 += 1139
n881 = 565507799
n868 = 246025161
n882 += 1188
n871 = 140336447
n869 -= 461
n2 += 594
v226[nil] = nil
else
v9012.Position = uDim2New(1, -8, 0.5, 0)
end
TextButton.MouseButton1Click:Connect(function()
if i > 1 then
local v9013 = i - 1
local v9014 = v9001[i]
v9001[i] = v9001[i - 1]
v9001[v9013] = v9014
v8996()
end
end)
TextButton2.MouseButton1Click:Connect(function()
if i < #v9001 then
local v9015 = i + 1
local v9016 = v9001[i]
v9001[i] = v9001[i + 1]
v9001[v9015] = v9016
v8996()
end
end)
end
end
v8995()
if p1335 == "ClickToAPCmds" then
if n871 < n2 then
t15.slider(v8993, "Click radius", 1, 50, 1, "ClickToAPRadius", "Click AP Radius", " studs")
else
n871 += 1134
n870 = 49016551
n882 += 571
n872 += 1302
n2 = 616151218
n881 += 839
n880 += 934
n868 += 1920
n869 += 1256
end
end
if p1335 == "SpamBaseOwnerCmds" then
t15.toggle(
v8993,
"Single command",
"SpamBaseOwnerSingleCommand",
"Spam Base Owner Single Command",
{
pill = true,
}
)
end
v8992.Visible = true
end
end)
end
v234()
v235 = function()
u208 = 784084929
u209 = 221235670
local x = {
Running = true,
Silent = 0,
Conns = {},
Loops = {},
Tracked = {},
Features = {},
Sources = {},
Owners = {},
LogLines = {},
StopFns = {},
}
t15.X = x
local n887 = 984017860
local n888
x.Live = function()
local spilled = {}
n888 = 569203164
if n4 == 616969873 then
return x.Running == true and t15.sg ~= nil and t15.sg.Parent ~= nil
end
n887 -= 1770
n1 -= 498
u208 += 564
n888 += 303
n2 += 360
u209 += 1025
n4 -= 1823
local _
(nil)(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 242))
end
x.Log = function(...)
local v9200 = table.pack(...)
for i = 1, v9200.n do
v9200[i] = tostring(v9200[i])
end
local v9202 = table.concat(v9200, " ", 1, v9200.n)
x.LogLines[#x.LogLines + 1] = v9202
if #x.LogLines > 200 then
table.remove(x.LogLines, 1)
end
if type(getgenv) == "function" and getgenv().SXEDebugLog == true and type(appendfile) == "function" then
pcall(appendfile, "sxe_debug.log", os.date("%H:%M:%S") .. " " .. v9202 .. "\n")
end
if n2 ~= n1 then
return
end
n2 += 640
u209 = 852073198
n887 -= 1019
n1 += 1618
n4 = 283047113
u208 = 990186762
return (nil)(nil)
end
x.Connect = function(p1337, p1338)
local connection = p1337:Connect(p1338)
x.Conns[#x.Conns + 1] = connection
return connection
end
x.Track = function(p1339)
x.Tracked[#x.Tracked + 1] = p1339
return p1339
end
x.OnStop = function(p1340)
x.StopFns[#x.StopFns + 1] = p1340
end
x.Loop = function(p1341, p1342)
local t345 = {
Alive = true,
}
t345.Stop = function()
t345.Alive = false
end
x.Loops[#x.Loops + 1] = t345
task.spawn(function()
while t345.Alive and x.Live() do
if p1341 <= 0 then
RunService.Heartbeat:Wait()
else
task.wait(p1341)
end
if not t345.Alive or not x.Live() then
break
end
local ok, result = pcall(p1342)
if not ok then
x.Log("Loop error", result)
end
end
end)
return t345
end
local Frame
local n889
x.Notify = function(p1343, p1344)
n889 = 21565106
local v9209 = tostring(p1343)
local v9210 = string.lower(v9209)
local v9211 = p1344
or (v9210:find("fail") or v9210:find("not ") or v9210:find("^no ") or v9210:find("error") or v9210:find(
"couldn"
) or v9210:find("can't")) and "Bad"
or "Info"
local T = t15.T
if not Frame or not Frame.Parent then
Frame = v225("Frame", {
Name = "SxeToasts",
BackgroundTransparency = 1,
AnchorPoint = Vector2.new(1, 0),
Position = uDim2New(1, -16, 0, 16),
Size = uDim2New(0, 250, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
}, t15.root)
v229(Frame, 6).HorizontalAlignment = Enum.HorizontalAlignment.Right
end
local t346 = {}
for _, child in ipairs(Frame:GetChildren()) do
if child:IsA("GuiObject") then
t346[#t346 + 1] = child
end
end
if #t346 >= 4 then
t346[1]:Destroy()
end
local Frame2 = v225("Frame", {
BackgroundColor3 = T.Bg,
BackgroundTransparency = 0.04,
BorderSizePixel = 0,
Size = uDim2New(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
}, Frame)
v226(Frame2, 10)
v227(Frame2, v9211 == "Bad" and T.Bad or v9211 == "Good" and T.Ok or t15.A, 1, 0)
v228(Frame2, 12, 12, 7, 8)
v229(Frame2, 1)
v231(Frame2, "SXE HUB", 11, t15.A, Enum.Font.GothamBlack, {
Size = uDim2New(1, 0, 0, 14),
})
v231(Frame2, v9209, 12, T.Text, Enum.Font.GothamMedium, {
Size = uDim2New(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
TextWrapped = true,
})
if n4 == 616969873 then
task.delay(math.clamp(2.4 + #v9209 / 30, 2.6, 6), function()
if Frame2.Parent then
Frame2:Destroy()
end
end)
return
end
n889 += 1156
n887 += 1411
u209 -= 735
n4 = 983383891
n2 -= 999
u208 += 1658
n1 = 540109552
(nil)[nil] = nil
return (nil)()
end
x.NewLine = function(p1345)
local n890 = 912673518
local t347 = {}
local n891 = 1020728655
local u9220
local u9221
local u9222
local u9223
local n892 = 399858284
local function v9225(p1346, p1347, p1348)
local Beam = Instance.new("Beam")
Beam.Name = p1345
Beam.FaceCamera = true
Beam.Segments = 1
Beam.LightInfluence = 0
Beam.LightEmission = 0
Beam.Texture = ""
Beam.Color = ColorSequence.new(p1346)
Beam.Transparency = NumberSequence.new(0)
Beam.Width0 = p1347
Beam.Width1 = p1347
Beam.ZOffset = p1348
return x.Track(Beam)
end
t347.Set = function(p1349, p1350, p1351)
if not p1349 or not p1350 or not p1349.Parent or not p1350.Parent then
t347.Hide()
return
end
if not u9220 or u9220.Parent ~= p1349 then
if u9220 then
u9220:Destroy()
end
u9220 = x.Track(Instance.new("Attachment"))
u9220.Name = p1345
u9220.Parent = p1349
end
if not u9221 or u9221.Parent ~= p1350 then
if u9221 then
u9221:Destroy()
end
u9221 = x.Track(Instance.new("Attachment"))
u9221.Name = p1345
u9221.Parent = p1350
end
if p1351 and u9221.Position ~= p1351 then
u9221.Position = p1351
end
if not u9222 or not u9222.Parent or not u9223 or not u9223.Parent then
if u9222 then
u9222:Destroy()
end
if u9223 then
u9223:Destroy()
end
local v9227 = v9225(Color3.new(0, 0, 0), 0.5, 0)
local v9228 = v9225(t15.A, 0.24, 0.05)
u9222 = v9227
u9223 = v9228
end
for _, v in ipairs({
u9222,
u9223,
}) do
if v.Attachment0 ~= u9220 then
v.Attachment0 = u9220
end
if v.Attachment1 ~= u9221 then
v.Attachment1 = u9221
end
if v.Parent ~= p1349 then
v.Parent = p1349
end
if not v.Enabled then
v.Enabled = true
end
end
end
t347.Hide = function()
if u9222 then
u9222.Enabled = false
end
if u9223 then
u9223.Enabled = false
end
if n892 ~= 399858284 then
n2 -= 674
n891 -= 159
u208 = 602067499
n892 += 1396
n890 -= 1606
n887 = 518818224
(nil)(nil, nil);
(nil)(nil, nil)
end
end
return t347
end
x.OptiActive = function()
return rawget(_G, "SXE_Kill") ~= nil
end
x.MAP = {
InvisActive = "InvisibleSteal",
InvisAutoOnSteal = "AutoInvisDuringSteal",
InvisAngle = "InvisStealAngle",
InvisDepth = "SinkSliderValue",
FlyTool = "TpSettings.Tool",
EspBrainrots = "BrainrotESP",
EspPlayers = "PlayerESP",
EspBestTracer = "LineToBrainrot",
EspBaseXray = "XRay",
}
x.CONV = {}
local s41 = "Path"
local function v9232(p1352)
return x.MAP[p1352] or p1352
end
x[s41] = v9232
x.Quiet = function(p1353, p1354)
if t15.get(p1353) == p1354 then
return
end
x.Silent += 1
pcall(t15.set, p1353, p1354)
x.Silent -= 1
end
x.Config = setmetatable({}, {
__index = function(p1355, p1356)
local v9233 = t15.get(x.Path(p1356))
local v9234 = x.CONV[p1356]
if v9234 then
v9233 = v9234(v9233)
end
return v9233
end,
__newindex = function(p1357, p1358, p1359)
if x.CONV[p1358] then
return
end
x.Quiet(x.Path(p1358), p1359)
end,
})
local function v9235(p1360)
local ok, result = pcall(function()
return Font.fromEnum(p1360)
end)
local v9238 = ok and result or nil
return v9238
end
local v9239 = v9235(Enum.Font.GothamBold)
local v9240 = v9235(Enum.Font.GothamMedium)
x.Ctx = {
Players = Players,
RunService = RunService,
ReplicatedStorage = game:GetService("ReplicatedStorage"),
Workspace = workspace,
UserInputService = UserInputService,
Lighting = game:GetService("Lighting"),
HttpService = HttpService,
TeleportService = game:GetService("TeleportService"),
CollectionService = game:GetService("CollectionService"),
LocalPlayer = LocalPlayer,
Config = x.Config,
Log = x.Log,
Drawing = type(Drawing) == "table" and Drawing or nil,
Fonts = v9239 and v9240 and {
Bold = v9239,
Semi = v9240,
} or nil,
Connect = x.Connect,
Track = x.Track,
Running = x.Live,
Loop = x.Loop,
Notify = x.Notify,
NewLine = x.NewLine,
Set = function(p1361, p1362)
pcall(t15.set, x.Path(p1361), p1362)
end,
}
_G.__SXEUI_Stop = function()
if not x.Running then
return
end
local n893 = 835013514
x.Running = false
local n894 = 663080424
for _, feature in pairs(x.Features) do
if type(feature.Stop) == "function" then
pcall(feature.Stop)
end
end
local n895 = 79684756
if x.Walk then
if not (n895 < n893) then
n2 += 1215
n4 = 266571175
n887 += 135
n1 -= 2029
u208 += 1504
u209 = 484975944
return (nil)()
end
pcall(x.Walk.Stop)
end
for _, stopFn in ipairs(x.StopFns) do
pcall(stopFn)
end
for _, loop in ipairs(x.Loops) do
pcall(loop.Stop)
end
for _, conn in ipairs(x.Conns) do
pcall(function()
conn:Disconnect()
end)
end
for _, v in ipairs(x.Tracked) do
pcall(function()
v:Destroy()
if n895 < n894 then
return
end
n895 += 317
n894 = 269096671
n893 = 744253965
n4 += 1258
n2 = 39291903
return (nil)(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
getfenv()[nil],
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 285))
end)
end
end
v222(t15.sg.AncestryChanged, function()
if not t15.sg.Parent then
_G.__SXEUI_Stop()
end
end)
end
v235()
v236 = function()
local X = t15.X
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local n896 = 772973197
local v9257 = LocalPlayer
local Log = X.Log
local snap = {
Plots = {},
}
local u9260
local n897 = 986938822
local u9262 = false
local n898 = 457898528
local u9264
local u9265
local u9266
local u9267
local u9268
local function v9269(p1363, ...)
Log("FAIL", p1363, ...)
return false
end
local function gameRequire(p1364, p1365)
if not p1364 then
return false, "missing module"
end
local n899 = 281507427
local n900 = 853252931
local n901
if type(getloadedmodules) == "function" then
local v9274 = os.clock() + (p1365 or 20)
local v9275 = false
local function v9276()
n901 = 905142718
local ClientToolScripts = ReplicatedStorage:FindFirstChild("ClientToolScripts")
local v9278 = false
local children
if ClientToolScripts then
children = ClientToolScripts:GetChildren()
else
children = {}
end
for _, v in children, nil, nil do
if v:IsA("Script") then
if not v.Enabled then
return false
end
v9278 = true
end
end
if n900 ~= 853253963 then
return v9278
end
n901 -= 1606
n899 += 479
n4 -= 1700
n900 += 1050
n898 -= 1055
n1 = 19549987
n2 = 710011106
end
repeat
local ok, result = pcall(getloadedmodules)
if not ok or type(result) ~= "table" or table.find(result, p1364) then
break
end
if v9276() then
Log("GameRequire: game loader finished without", p1364:GetFullName())
break
end
if not v9275 then
v9275 = true
Log("GameRequire: waiting for the game to load", p1364:GetFullName())
end
task.wait(0.25)
until v9274 < os.clock() or not X.Live()
end
return pcall(require, p1364)
end
local function v9284()
local Datas = ReplicatedStorage:WaitForChild("Datas", 30)
local Controllers = ReplicatedStorage:WaitForChild("Controllers", 30)
if not Datas or not Controllers then
return v9269(
"LoadModules: missing folder",
"Datas=" .. tostring(Datas),
"Controllers=" .. tostring(Controllers)
)
end
if not u9260 and not u9262 then
u9262 = true
task.spawn(function()
local v9287, v9288 = gameRequire(Controllers:WaitForChild("PlotController", 30), 30)
if v9287 then
u9260 = v9288
u9264 = nil
Log("LoadModules: PlotController ready")
else
Log("LoadModules: PlotController require failed", v9288)
end
u9262 = false
end)
end
local v9289, v9290 = gameRequire(Datas:WaitForChild("Animals", 10))
local v9291, v9292 = gameRequire(Datas:WaitForChild("Mutations", 10))
local v9293, v9294 = gameRequire(Datas:WaitForChild("Traits", 10))
local v9295, v9296 = gameRequire(Datas:WaitForChild("Game", 10))
if v9289 and v9291 and v9293 and v9295 then
Log("LoadModules ok")
u9265 = v9290
u9266 = v9292
u9267 = v9294
u9268 = v9296
return true
end
local v9297 = v9269
local s42 = "LoadModules: require failed"
local v9299 = v9289
local v9300 = v9291
local v9301 = v9293
local v9302 = v9295
local v9303 = v9289 and "" or v9290
local v9304 = v9295 and "" or v9296
return v9297(s42, v9299, v9300, v9301, v9302, v9303, v9304)
end
local n902
local t348 = {
1116352408,
1899447441,
3049323471,
3921009573,
961987163,
1508970993,
2453635748,
2870763221,
3624381080,
310598401,
607225278,
1426881987,
1925078388,
2162078206,
2614888103,
3248222580,
3835390401,
4022224774,
264347078,
604807628,
770255983,
1249150122,
1555081692,
1996064986,
2554220882,
2821834349,
2952996808,
3210313671,
3336571891,
3584528711,
113926993,
338241895,
666307205,
773529912,
1294757372,
1396182291,
1695183700,
1986661051,
2177026350,
2456956037,
2730485921,
2820302411,
3259730800,
3345764771,
3516065817,
3600352804,
4094571909,
275423344,
430227734,
506948616,
659060556,
883997877,
958139571,
1322822218,
1537002063,
1747873779,
1955562222,
2024104815,
2227730452,
2361852424,
2428436474,
2756734187,
3204031479,
3329325298,
}
local v9307 = table.create(64, 0)
local function v9308(p1366, p1367, p1368, p1369)
n902 = 521662270
local v9309 = p1366[1]
local v9310 = p1366[2]
local v9311 = p1366[3]
local v9312 = p1366[4]
local v9313 = p1366[5]
local v9314 = p1366[6]
local v9315 = p1366[7]
local v9316 = p1366[8]
for i = p1368, p1369, 64 do
local v9318 = i
for i2 = 1, 16 do
local v9320, v9321, v9322, v9323 = string.byte(p1367, v9318, v9318 + 3)
v9307[i2] =
bit32.bor(bit32.lshift(v9320, 24), bit32.lshift(v9321, 16), bit32.lshift(v9322, 8), v9323)
v9318 += 4
end
for i2 = 17, 64 do
local v9325 = v9307[i2 - 2]
local v9326 = v9307[i2 - 15]
local v9327 = bit32.bxor(bit32.rrotate(v9326, 7), bit32.rrotate(v9326, 18), bit32.rshift(v9326, 3))
v9307[i2] = bit32.bxor(bit32.rrotate(v9325, 17), bit32.rrotate(v9325, 19), bit32.rshift(v9325, 10))
+ v9307[i2 - 7]
+ v9327
+ v9307[i2 - 16]
end
local v9328 = v9309
local v9329 = v9310
local v9330 = v9311
local v9331 = v9312
local v9332 = v9313
local v9333 = v9314
local v9334 = v9315
local v9335 = v9316
for i2 = 1, 64 do
local bxor = bit32.bxor
local band = bit32.band
local v9339 = v9335
+ bit32.bxor(bit32.rrotate(v9332, 6), bit32.rrotate(v9332, 11), bit32.rrotate(v9332, 25))
+ bxor(bit32.band(v9332, v9333), band(bit32.bnot(v9332), v9334))
+ t348[i2]
+ v9307[i2]
local bxor2 = bit32.bxor
local v9341 = bit32.bxor(
bit32.rrotate(v9328, 2),
bit32.rrotate(v9328, 13),
bit32.rrotate(v9328, 22)
) + bxor2(bit32.band(v9328, v9329), bit32.band(v9328, v9330), bit32.band(v9329, v9330))
v9335 = v9334
v9334 = v9333
v9333 = v9332
v9332 = v9331 + v9339
v9331 = v9330
v9330 = v9329
v9329 = v9328
v9328 = v9339 + v9341
end
v9309 = bit32.bor(v9309 + v9328, 0)
v9310 = bit32.bor(v9310 + v9329, 0)
v9311 = bit32.bor(v9311 + v9330, 0)
v9312 = bit32.bor(v9312 + v9331, 0)
v9313 = bit32.bor(v9313 + v9332, 0)
v9314 = bit32.bor(v9314 + v9333, 0)
v9315 = bit32.bor(v9315 + v9334, 0)
v9316 = bit32.bor(v9316 + v9335, 0)
end
if n2 ~= n902 then
p1366[1] = v9309
p1366[2] = v9310
p1366[3] = v9311
p1366[4] = v9312
p1366[5] = v9313
p1366[6] = v9314
p1366[7] = v9315
p1366[8] = v9316
return
end
n902 = 556279526
n4 = 427638965
n896 += 1655
n897 = 1055907789
n1 += 181
n2 -= 86
local v9342 = n898 + 988
n898 = v9342
while true do
n898 = v9342
end
end
local function v9343(p1370)
local t349 = {
1779033703,
3144134277,
1013904242,
2773480762,
1359893119,
2600822924,
528734635,
1541459225,
}
local v9345 = #p1370
local v9346 = v9345 % 64
if v9345 >= 64 then
v9308(t349, p1370, 1, v9345 - v9346)
end
local v9347 = bit32.band(v9346 + 32, 4294967232)
local v9348 = table.concat({
v9346 == 0 and "" or string.sub(p1370, -v9346),
"\128",
string.rep("\0", (v9347 - v9346 - 9) % 64),
string.pack(">L", v9345 * 8),
})
v9308(t349, v9348, 1, #v9348)
local v9349 = table.create(8)
if 785256428 ~= n2 then
for i = 1, 8 do
v9349[i] = string.format("%08x", t349[i])
end
return table.concat(v9349)
end
n2 = 12495344
n898 = 585528570
n1 = 1011455547
n4 -= 692
n896 -= 761
n897 = 950741563
return nil
end
local JobId = game.JobId
local t350 = {}
local function resolveRemote(p1371, p1372)
if #JobId == 0 then
JobId = game.JobId
end
if #JobId == 0 then
return nil
end
local s43
if p1372 then
s43 = "RF/"
else
s43 = "RE/"
end
local v9355 = t350[s43 .. p1371]
if not v9355 then
local v9356 = table.create(#p1371)
local n903 = 0
for i = 1, #p1371 do
local v9359 = string.byte(p1371, i)
if v9359 == 47 then
v9356[i] = "/"
else
v9356[i] = string.char(32 + (v9359 - 32 + string.byte(JobId, n903 % #JobId + 1) % 95) % 95)
n903 += 1
end
end
local v9360 = "36bc48de-ccc6-4666-af4b-7d3bd46d6aa7" .. JobId
v9355 = s43 .. v9343(table.concat(v9356) .. v9360)
t350[s43 .. p1371] = v9355
end
local Packages = ReplicatedStorage:FindFirstChild("Packages")
local Net = Packages and Packages:FindFirstChild("Net")
local v9363 = Net and Net:FindFirstChild(v9355)
local v9364 = v9363
if v9364 then
local v9365 = v9363
local IsA = v9363.IsA
local s44
if p1372 then
s44 = "RemoteFunction"
else
s44 = "RemoteEvent"
end
v9364 = IsA(v9365, s44)
end
return v9364 and v9363 or nil
end
local function v9368()
return resolveRemote("UseItem")
end
local function getPlotCaches()
if type(u9264) == "table" and next(u9264) ~= nil then
return u9264
end
local function v9370(p1373)
if type(p1373) ~= "table" then
return false
end
local n904 = 0
for _, v in next, p1373, nil do
if type(v) ~= "table" or rawget(v, "Channel") == nil then
return false
end
n904 += 1
if n904 >= 2 then
break
end
end
return n904 > 0
end
local function v9374(p1374, p1375)
if type(p1374) ~= "function" or type(debug.getupvalue) ~= "function" then
return nil
end
local ok, result, result2 = pcall(debug.getupvalue, p1374, p1375)
if ok then
return type(result) == "table" and result or type(result2) == "table" and result2 or nil
end
return nil
end
local v9378 = u9260 and v9374(rawget(u9260, "GetPlots"), 1)
if u9260 and not v9370(v9378) then
v9378 = nil
for i = 1, 24 do
local v9380 = v9374(rawget(u9260, "Start"), i)
if v9370(v9380) then
v9378 = v9380
break
end
end
end
if v9370(v9378) then
u9264 = v9378
return v9378
end
local Plots = next(snap.Plots) ~= nil and snap.Plots or nil
return Plots
end
snap.Cache = function(p1376, p1377)
local value = type(p1377) == "table" and p1377.Channel and rawget(p1377.Channel, "CacheTable")
local v9383 = snap.Plots[tostring(p1376)]
if v9383 and value == v9383.Channel.CacheTable then
return os.clock() - (v9383.At or 0) < 30 and value or nil
end
if type(value) == "table" and next(value) ~= nil then
return value
end
if v9383 then
if os.clock() - (v9383.At or 0) < 30 then
return v9383.Channel.CacheTable
end
end
return value
end
local n905
snap.Fetch = function()
n905 = 512629595
local now3 = os.clock()
local v9386 = now3 + 30
local t351 = {}
local plots = 0
local n906 = 985329692
local n907 = 28196407
local RequestData
local function v9392(p1378)
local n908 = 297388579
if t351[p1378] or not string.match(p1378, "^%x+%-%x+%-%x+%-%x+%-%x+$") then
return
end
local n909 = 1015788076
t351[p1378] = true
if n2 < n909 then
plots += 1
else
n2 += 1320
n4 = 534241704
n908 = 618252391
n906 += 2005
n1 = 1063610635
n905 -= 1970
n907 -= 752
n909 += 43
end
local v9395 = RequestData
local n910
task.spawn(function()
n910 = 907443452
local ok, result = pcall(v9395.InvokeServer, v9395, p1378)
if not X.Live() then
if n907 ~= 28197990 then
return
end
n910 += 1285
n4 = 1016171261
n2 = 566238233
n907 -= 994
n909 = 793132917
n908 -= 1242
n905 -= 853
(nil)()
end
if ok and type(result) == "table" then
snap.Plots[p1378] = {
Channel = {
CacheTable = result,
},
At = os.clock(),
}
local brainrots = 0
local AnimalList = type(result.AnimalList) == "table" and result.AnimalList or {}
for _, v in AnimalList, nil, nil do
if type(v) == "table" then
brainrots += 1
end
end
Log(
"PlotSnapshot",
p1378,
"owner=" .. tostring(result.Owner),
"brainrots=" .. brainrots,
"took=" .. os.clock() - now3
)
else
Log("PlotSnapshot failed", p1378, "ok=" .. tostring(ok), result)
end
end)
end
local v9403 = false
while X.Live() and os.clock() < v9386 do
local Packages = ReplicatedStorage:FindFirstChild("Packages")
local Synchronizer = Packages and Packages:FindFirstChild("Synchronizer")
RequestData = RequestData or Synchronizer and Synchronizer:FindFirstChild("RequestData")
if RequestData then
local Channel = Synchronizer and Synchronizer:FindFirstChild("Channel")
local children = Channel and Channel:GetChildren() or {}
for _, v in children, nil, nil do
v9392(v.Name)
end
local Plots = workspace:FindFirstChild("Plots")
local children2 = Plots and Plots:GetChildren() or {}
for _, v in children2, nil, nil do
v9392(v.Name)
end
if plots > 0 and not v9403 then
v9403 = true
Log("Snap.Plots requested", "plots=" .. plots)
end
if #children2 > 0 then
local v9414 = true
for _, v in children2, nil, nil do
if not t351[v.Name] then
v9414 = false
break
end
end
if v9414 then
return
end
end
end
RunService.Heartbeat:Wait()
end
end
local function v9417(p1379)
local MainRoot = p1379:FindFirstChild("MainRoot")
if MainRoot and MainRoot:IsA("BasePart") then
return MainRoot.CFrame
end
return p1379:GetPivot()
end
local function v9419(p1380)
local t352 = {}
local t353 = {}
for _, v in p1380:GetChildren() do
local ok, result = pcall(v.GetPivot, v)
if ok then
local v9426 = math.round(result.Position.Y / 4)
local v9427 = t352[v9426]
if not v9427 or result.Position.Y < v9427 then
t352[v9426] = result.Position.Y
end
end
end
for _, v in pairs(t352) do
t353[#t353 + 1] = v - 0.2
end
table.sort(t353)
return t353
end
local function v9430(p1381, p1382)
for i = #p1382, 1, -1 do
if not (p1382[i] <= p1381) then
continue
end
local v9432 = p1382[i]
local v9433 = p1382[i + 1]
return v9432, v9433 or p1382[i] + 20, i
end
return p1382[1], p1382[2] or p1382[1] + 20, 1
end
local function v9434(p1383, p1384, p1385, p1386)
local vector3 = Vector3.new(math.huge, 0, math.huge)
local vector32 = Vector3.new(-math.huge, 0, -math.huge)
local n911 = 0
for _, v in p1383:GetChildren() do
local ok, result = pcall(v.GetPivot, v)
if ok and p1385 <= result.Y and result.Y < p1386 then
local v9442 = p1384:PointToObjectSpace(result.Position)
vector3 = Vector3.new(math.min(vector3.X, v9442.X), 0, math.min(vector3.Z, v9442.Z))
vector32 = Vector3.new(math.max(vector32.X, v9442.X), 0, math.max(vector32.Z, v9442.Z))
n911 += 1
end
end
if n911 < 2 then
return nil
end
return {
Min = vector3,
Max = vector32,
}
end
local obj = setmetatable({}, {
__mode = "k",
})
local n912
local function rankTargets()
n912 = 102788569
local v9446 = getPlotCaches()
local Plots = workspace:FindFirstChild("Plots")
if not (type(v9446) == "table" and Plots) then
return {}
end
local function v9448(p1387)
local v9449 = u9265[p1387.Index]
if type(v9449) ~= "table" then
return 0
end
local Generation = v9449.Generation
if type(Generation) ~= "number" then
local AnimalGanerationModifier = u9268 and u9268.Game and u9268.Game.AnimalGanerationModifier
Generation = type(v9449.Price) == "number"
and type(AnimalGanerationModifier) == "number"
and v9449.Price * AnimalGanerationModifier
or 0
end
local n913 = 1
local v9453 = false
local Mutation = p1387.Mutation and u9266[p1387.Mutation]
if type(Mutation) == "table" and type(Mutation.Modifier) == "number" then
n913 += Mutation.Modifier
end
local Traits = p1387.Traits or {}
for _, v in Traits, nil, nil do
local v9458 = u9267[v]
if v == "Sleepy" then
v9453 = true
elseif type(v9458) == "table" and type(v9458.MultiplierModifier) == "number" then
n913 += v9458.MultiplierModifier
end
end
return math.round(Generation * n913 * (v9453 and 0.5 or 1))
end
local t354 = {}
for k, v in pairs(v9446) do
local v9462 = snap.Cache(k, v)
local Owner = type(v9462) == "table" and v9462.Owner
local v9464 = Plots:FindFirstChild(tostring(k))
local AnimalPodiums = v9464 and v9464:FindFirstChild("AnimalPodiums")
local v9466 = Owner == v9257
or Owner == v9257.UserId
or Owner == tostring(v9257.UserId)
or Owner == v9257.Name
if Owner ~= nil and not v9466 and AnimalPodiums and type(v9462.AnimalList) == "table" then
local v9467 = #AnimalPodiums:GetChildren()
local v9468 = obj[v9464]
if not (n912 < n896) then
n898 += 1427
n2 = 698310858
n1 = 806098106
n4 -= 244
n912 += 1076
n897 += 828
n896 = 747427796
return (nil)()
end
if not v9468 or v9468.Count ~= v9467 or v9468.Podiums ~= AnimalPodiums then
v9468 = {
Count = v9467,
Podiums = AnimalPodiums,
Bands = v9419(AnimalPodiums),
Frame = v9417(v9464),
Interiors = {},
Slots = {},
}
obj[v9464] = v9468
end
local Bands = v9468.Bands
local Frame = v9468.Frame
local Interiors = v9468.Interiors
for k2, v2 in pairs(v9462.AnimalList) do
local v9474 = v9468.Slots[k2]
if not v9474 or v9474.Podium.Parent ~= AnimalPodiums then
local v9475 = AnimalPodiums:FindFirstChild(tostring(k2))
v9474 = v9475
and {
Podium = v9475,
Spot = v9475:GetPivot().Position,
}
or nil
v9468.Slots[k2] = v9474
end
local Podium = #Bands > 0 and type(v2) == "table" and v2.Index and v9474 and v9474.Podium
if Podium then
local Spot = v9474.Spot
local _, _, v9480 = v9430(Spot.Y, Bands)
local v9481 = math.max(1, v9480 - 1)
local v9482 = Bands[v9481]
local v9483 = Bands[v9481 + 1] or v9482 + 20
local v9484 = Interiors[v9481] or v9434(AnimalPodiums, Frame, v9482, v9483)
if v9484 then
Interiors[v9481] = v9484
t354[#t354 + 1] = {
Name = tostring(v2.Index),
Income = v9448(v2),
Podium = Spot,
PodiumModel = Podium,
Low = v9482,
High = v9483,
Owner = tostring(Owner),
Frame = Frame,
Floor = v9480,
EntryFloor = v9481,
Model = v9464,
Interior = v9484,
Slot = tonumber(k2),
Mutation = type(v2.Mutation) == "string" and v2.Mutation or nil,
Order = tonumber(v9464:GetAttribute("Order")),
Carried = v2.Steal ~= nil and v2.Steal ~= false,
}
end
end
end
end
end
table.sort(t354, function(p1388, p1389)
return p1388.Income > p1389.Income
end)
return t354
end
local function repairRig(p1390)
local PrimaryPart = p1390 and p1390.PrimaryPart
if not p1390 or not PrimaryPart then
return
end
local RootRigAttachment = PrimaryPart:FindFirstChild("RootRigAttachment")
for _, v in p1390:GetDescendants() do
if
RootRigAttachment
and v:IsA("AnimationConstraint")
and v.Name == "Root"
and (v.Attachment0 == nil or v.Attachment0.Parent ~= PrimaryPart)
then
v.Attachment0 = RootRigAttachment
Log("RepairRig: relinked Root constraint")
end
end
local __HITBOX = p1390:FindFirstChild("__HITBOX")
local WeldConstraint = __HITBOX and __HITBOX:FindFirstChildOfClass("WeldConstraint")
if
__HITBOX
and __HITBOX:IsA("BasePart")
and (not WeldConstraint or WeldConstraint.Part1 ~= PrimaryPart)
then
__HITBOX.CFrame = PrimaryPart.CFrame * CFrame.new(0, -0.1995, 0)
local WeldConstraint2 = WeldConstraint or Instance.new("WeldConstraint")
WeldConstraint2.Part0 = __HITBOX
WeldConstraint2.Part1 = PrimaryPart
WeldConstraint2.Parent = __HITBOX
Log("RepairRig: rewelded hitbox")
end
if n2 ~= 557240548 then
n1 -= 237
n2 = 977807263
n898 += 1006
n4 += 1598
n896 = 425170487
n897 += 645
if p1390 > nil then
upv131[nil] = nil
end
end
end
X.GameRequire = gameRequire
X.ResolveRemote = resolveRemote
X.GetPlotCaches = getPlotCaches
X.Snap = snap
X.RankTargets = rankTargets
X.RepairRig = repairRig
X.Data = function()
return u9265, u9266, u9267, u9268
end
X.Targets = function()
local ok, result = pcall(rankTargets)
return ok and result or {}
end
X.MyPlot = function()
local Plots = workspace:FindFirstChild("Plots")
local _, result = pcall(getPlotCaches)
local children = Plots and Plots:GetChildren() or {}
for _, v in children, nil, nil do
local v9501 = snap.Cache(v.Name, type(result) == "table" and result[v.Name])
local Owner = type(v9501) == "table" and v9501.Owner
if
Owner == v9257
or Owner == v9257.Name
or Owner == v9257.UserId
or Owner == tostring(v9257.UserId)
then
return v
end
end
return nil
end
X.Character = function()
local Character = v9257.Character
return Character,
Character and Character.PrimaryPart,
Character and Character:FindFirstChildWhichIsA("Humanoid")
end
local Ctx = X.Ctx
Ctx.Remote = function(p1391)
local ok, result = pcall(resolveRemote, p1391)
return ok and result or nil
end
local u9507
Ctx.UseItem = function()
u9507 = u9507 or v9368()
return u9507
end
Ctx.Require = function(p1392)
if not p1392 then
return nil
end
local v9508, v9509 = gameRequire(p1392, 10)
return v9508 and v9509 or nil
end
X.PriorityTargets = function()
local C = t15.C
local t355 = {}
local t356 = {}
local PriorityList = C.PriorityList or {}
for i, v in ipairs(PriorityList) do
if type(v) == "string" and t355[string.lower(v)] == nil then
t355[string.lower(v)] = i
end
end
if C.MutationPriorityOn ~= false then
local ipairs_ = ipairs
local MutOrder = C.MutOrder or {}
for k, v in ipairs_(MutOrder) do
if type(v) == "string" then
t356[string.gsub(string.lower(v), "%s+", "")] = k
end
end
end
local t357 = {}
for _, v in ipairs(X.Targets()) do
local v9523 = t355[string.lower(v.Name)]
if v9523 then
v.Rank = v9523
local Mutation = v.Mutation and t356[string.gsub(string.lower(v.Mutation), "%s+", "")]
v.MutRank = Mutation or math.huge
t357[#t357 + 1] = v
end
end
table.sort(t357, function(p1393, p1394)
if p1393.Rank ~= p1394.Rank then
return p1393.Rank < p1394.Rank
end
if p1393.MutRank == p1394.MutRank then
return p1393.Income > p1394.Income
end
return p1393.MutRank < p1394.MutRank
end)
return t357
end
local PriorityTargets = X.PriorityTargets
local Character = X.Character
local MyPlot = X.MyPlot
Ctx.Targets = X.Targets
Ctx.SortedTargets = PriorityTargets
Ctx.Character = Character
Ctx.MyPlot = MyPlot
Ctx.RepairRig = repairRig
t15.lateEngine(function()
task.spawn(snap.Fetch)
task.spawn(function()
while X.Live() and not v9284() do
task.wait(0.5)
end
X.Booted = X.Live()
end)
end)
end
v236()
v237 = function()
u214 = 193795955
u215 = 899665139
local Sources = t15.X.Sources
local n914 = 791268844
local function v9530()
local n915 = 510500452
local n916 = 963561185
local n917
local function v9534(p1395)
n917 = 51633376
local RunService2 = p1395.RunService
local Players2 = p1395.Players
local Workspace = p1395.Workspace
local LocalPlayer2 = p1395.LocalPlayer
local Config = p1395.Config
local t358 = {
Defaults = {
InvisAutoOnSteal = false,
InvisAngle = 180,
InvisAutoAngle = true,
InvisDepth = 4.2,
InvisActive = false,
InvisTrueView = true,
},
}
local n918 = 244225947
local Dead = Enum.HumanoidStateType.Dead
local FallingDown = Enum.HumanoidStateType.FallingDown
local n919 = 558672941
local Ragdoll = Enum.HumanoidStateType.Ragdoll
local u9546 = false
local n920 = 180
local u9548 = true
local n921 = 4.2
local u9550 = false
local u9551 = true
local u9552
local t359 = {}
local t360 = {}
local t361 = {}
local t362 = {}
local u9557 = false
local function v9558(p1396)
for _, v in p1396, nil, nil do
pcall(function()
v:Disconnect()
end)
end
table.clear(p1396)
end
local function v9561()
return Workspace.CurrentCamera
end
local function v9562()
return 0.01 + math.clamp(tonumber(n921) or 4.2, 0, 10) / 10 * 0.19
end
local function v9563()
return math.clamp(tonumber(n920) or 180, 0, 360)
end
local function v9564()
local attribute = LocalPlayer2:GetAttribute("Stealing")
return attribute ~= nil and attribute ~= false
end
local t363 = {}
local u9567
local n922 = 0
local Position
local function v9570()
n922 += 1
v9558(t363)
if u9567 then
pcall(function()
u9567:Destroy()
end)
u9567 = nil
end
end
local function v9571(p1397)
n922 += 1
local v9572 = n922
v9558(t363)
local Humanoid = p1397:FindFirstChildOfClass("Humanoid")
if not Humanoid then
return
end
Humanoid.BreakJointsOnDeath = false
Humanoid:SetStateEnabled(Dead, false)
if u9567 then
pcall(function()
u9567:Destroy()
end)
end
local ForceField = Instance.new("ForceField")
ForceField.Visible = false
ForceField.Parent = p1397
u9567 = ForceField
table.insert(
t363,
p1395.Connect(Humanoid:GetPropertyChangedSignal("Health"), function()
if Humanoid.Health <= 0 then
task.wait(0.05 + math.random() * 0.1)
if v9572 ~= n922 then
return
end
Humanoid.Health = Humanoid.MaxHealth
end
end)
)
table.insert(
t363,
p1395.Connect(Humanoid.Died, function()
task.wait(0.1)
if not (v9572 == n922 and p1397.Parent) then
return
end
local WalkSpeed = Humanoid.WalkSpeed
local JumpPower = Humanoid.JumpPower
local Humanoid2 = Instance.new("Humanoid")
Humanoid2.Name = Humanoid.Name
Humanoid2.Parent = p1397
Humanoid2.Health = Humanoid2.MaxHealth
Humanoid2.WalkSpeed = WalkSpeed
Humanoid2.JumpPower = JumpPower
local v9578 = v9561()
if v9578 then
v9578.CameraSubject = Humanoid2
end
Humanoid:Destroy()
task.wait(0.1)
if v9572 ~= n922 then
return
end
v9571(p1397)
end)
)
local HumanoidRootPart = p1397:FindFirstChild("HumanoidRootPart")
if HumanoidRootPart then
Position = HumanoidRootPart.Position
table.insert(
t363,
p1395.Connect(RunService2.Heartbeat, function()
if not HumanoidRootPart.Parent then
return
end
local Position2 = HumanoidRootPart.Position
if Position2.Y < -500 or Position and (Position2 - Position).Magnitude > 100 then
if Position then
HumanoidRootPart.CFrame = CFrame.new(Position)
end
else
Position = Position2
end
end)
)
end
end
local u9581 = false
local u9582 = false
local u9583 = false
local u9584 = false
local u9585 = false
local t364 = {}
local u9587
local u9588
local u9589
local u9590
local u9591
local u9592
local HipHeight
local CanCollide
local u9595
local u9596
local function v9597(p1398, p1399, p1400, p1401)
for _, v in p1398:GetDescendants() do
if not v:IsA("Weld") then
if not v:IsA("Motor6D") then
continue
end
end
local Part1
if v.Part0 == p1399 then
Part1 = v.Part1
elseif v.Part1 == p1399 then
Part1 = v.Part0
else
Part1 = nil
end
if not p1401 or Part1 and Part1.Parent == p1398 then
if v.Part0 == p1399 then
v.Part0 = p1400
end
if v.Part1 == p1399 then
v.Part1 = p1400
end
end
end
if n2 ~= 557241737 then
return
end
u214 += 117
n918 -= 1217
n2 -= 1394
n1 = 61008084
n919 -= 1945
n917 += 1416
end
local function v9601()
if u9552 then
local v9602 = u9552
u9552 = nil
pcall(function()
v9602:Destroy()
end)
end
table.clear(t359)
table.clear(t360)
table.clear(t361)
table.clear(t362)
end
local function v9603(p1402)
local n923 = 589934214
v9601()
if not u9551 then
return
end
local Model = Instance.new("Model")
Model.Name = "SxeTrueView"
for _, v in p1402:GetDescendants() do
if v:IsA("BasePart") and v ~= u9591 and v.Name ~= "__HITBOX" and v.Transparency < 1 then
local ok, result = pcall(function()
local Archivable = v.Archivable
v.Archivable = true
local clone = v:Clone()
v.Archivable = Archivable
return clone
end)
if not ok then
continue
end
if not result then
continue
end
if not (n917 < u215) then
u215 -= 948
n2 += 215
n915 += 750
n919 = 515036961
n918 = 640294855
n923 += 326
n917 = 917494695
return
end
for _, v2 in result:GetDescendants() do
if
not v2:IsA("Decal")
and not v2:IsA("DataModelMesh")
and not v2:IsA("SurfaceAppearance")
then
pcall(v2.Destroy, v2)
end
end
result.Anchored = true
result.CanCollide = false
result.CanQuery = false
result.CanTouch = false
result.CastShadow = false
result.Massless = true
result.LocalTransparencyModifier = 0
result.Parent = Model
t359[#t359 + 1] = result
t360[#t360 + 1] = v
t362[result] = true
end
end
Model.Parent = v9561()
u9552 = Model
end
local n924
local function v9615()
n924 = 202488114
v9601()
u9581 = false
u9585 = false
v9570()
local n925 = 295012078
local v9617 = u9589
local v9618 = u9590
local v9619 = u9591
if u9592 then
local v9620 = u9592
u9592 = nil
if v9617 and v9617.Parent == v9620 then
pcall(function()
v9617.Parent = Workspace
end)
end
pcall(function()
v9620:Destroy()
end)
end
if u9595 then
for k, v in u9595, nil, nil do
if k.Parent then
pcall(function()
k.LocalTransparencyModifier = v
end)
end
end
u9595 = nil
end
if u9587 then
local v9623 = u9587
u9587 = nil
pcall(function()
v9623:Stop()
end)
pcall(function()
v9623:Destroy()
end)
end
v9558(t364)
if u9588 then
local v9624 = u9588
u9588 = nil
pcall(function()
v9624:Destroy()
end)
end
local n926
if
v9617
and v9618
and v9619
and v9617.Parent
and v9618.Parent
and v9617:FindFirstChildOfClass("Humanoid")
then
local ok, result = pcall(function()
local Model = Instance.new("Model")
Model.Parent = game
v9617.Parent = Model
v9618.Parent = v9617
v9617.PrimaryPart = v9618
v9617.Parent = Workspace
local canCollide
if CanCollide == nil then
canCollide = true
else
canCollide = CanCollide
end
v9618.CanCollide = canCollide
v9597(v9617, v9619, v9618)
local CFrame_ = v9619.CFrame
v9619:Destroy()
local n927 = 427638868
v9618.CFrame = CFrame_
local Humanoid = v9617:FindFirstChildOfClass("Humanoid")
if Humanoid then
Humanoid.HipHeight = HipHeight or 0
end
if n917 < n927 then
Model:Destroy()
else
n919 = 299637758
n1 -= 1151
n916 += 1488
n917 = 26310653
n925 -= 148
n2 = 911895881
end
end)
if not ok then
p1395.Log("InvisibleSteal restore failed:", result)
end
elseif v9618 and v9618.Parent and v9618.Parent == v9561() and (not v9617 or not v9617.Parent) then
pcall(function()
n926 = 1024966777
if n924 == 202488776 then
n926 += 472
n918 = 154288112
n919 = 1016981269
n2 = 46319940
n917 += 1683
n924 -= 1138
n925 -= 1066
(nil)[489]();
(nil)(nil, nil)
else
v9618:Destroy()
end
end)
end
if v9617 and u9596 then
local Humanoid = v9617:FindFirstChildOfClass("Humanoid")
local v9634 = u9596
if Humanoid then
pcall(function()
Humanoid.BreakJointsOnDeath = v9634.BreakJointsOnDeath
Humanoid:SetStateEnabled(Dead, v9634.Dead)
Humanoid:SetStateEnabled(FallingDown, v9634.FallingDown)
Humanoid:SetStateEnabled(Ragdoll, v9634.Ragdoll)
end)
end
end
u9596 = nil
u9589 = nil
u9590 = nil
u9591 = nil
HipHeight = nil
CanCollide = nil
if v9617 and type(p1395.RepairRig) == "function" then
pcall(p1395.RepairRig, v9617)
end
end
local function v9635(p1403, p1404)
if not u9581 or p1404.Parent ~= p1403 or p1404.Health <= 0 then
return
end
local Animation = Instance.new("Animation")
Animation.AnimationId = "http://www.roblox.com/asset/?id=18537363391"
local Animator = p1404:FindFirstChildOfClass("Animator")
if not Animator then
Animator = Instance.new("Animator")
Animator.Parent = p1404
u9588 = Animator
end
local v9638 = Animator:LoadAnimation(Animation)
u9587 = v9638
v9638.Priority = Enum.AnimationPriority.Action4
v9638.Looped = true
v9638:Play(0, 1, 0)
Animation:Destroy()
table.insert(
t364,
p1395.Connect(v9638.Stopped, function()
if u9581 and u9587 == v9638 then
v9635(p1403, p1404)
end
end)
)
task.delay(0, function()
if u9587 ~= v9638 then
return
end
v9638.TimePosition = 0.7
task.delay(0.1, function()
if u9587 == v9638 then
v9638:AdjustSpeed(math.huge)
end
end)
end)
end
local v9639
local n928
local n929
local function v9642()
n928 = 533232112
n929 = 699065267
if u9584 then
return
end
local n930 = 282366693
if n1 < u215 then
u9584 = true
else
u215 = 62066241
n918 += 1969
n919 = 333884541
n2 = 391764
n929 -= 1732
n930 = 675806566
u214 = 569057659
n1 = 61333238
n928 = 466673742
(nil)();
(nil)(nil, nil);
(nil)(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil % nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 465))
end
local v9644 = u9583
local n931
local n932
task.spawn(function()
n931 = 332915195
n932 = 383540701
v9615()
task.wait(0.5)
u9584 = false
if u9550 or not p1395.Running() or not u9582 or u9581 then
return
end
if u214 == 193795955 then
if not v9639(v9644) then
u9582 = false
u9583 = false
Config.InvisActive = false
end
else
n928 -= 897
n931 -= 2020
n930 -= 120
n929 = 261305522
n2 += 156
u214 = 184250403
u215 += 889
n932 += 188
bit32.band(nil, nil)
end
end)
end
local n933
local function v9648(p1405)
n933 = 586956347
local Character = LocalPlayer2.Character
if not Character then
return false
end
local n934 = 242315430
local Humanoid = Character:FindFirstChildOfClass("Humanoid")
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
if not Humanoid or not HumanoidRootPart or not HumanoidRootPart.Parent then
return false
end
local v9653 = v9561()
if not v9653 then
return false
end
local n935 = 601430291
u9589 = Character
u9596 = {
BreakJointsOnDeath = Humanoid.BreakJointsOnDeath,
Dead = Humanoid:GetStateEnabled(Dead),
FallingDown = Humanoid:GetStateEnabled(FallingDown),
Ragdoll = Humanoid:GetStateEnabled(Ragdoll),
}
v9571(Character)
local n936 = 249312102
local LocalPlayer2Name = Workspace:FindFirstChild(LocalPlayer2.Name)
local n937
if LocalPlayer2Name then
local DoubleRig = LocalPlayer2Name:FindFirstChild("DoubleRig")
if DoubleRig then
DoubleRig:Destroy()
end
local Constraints = LocalPlayer2Name:FindFirstChild("Constraints")
if Constraints then
Constraints:Destroy()
end
table.insert(
t364,
p1395.Connect(LocalPlayer2Name.ChildAdded, function(p1406)
n937 = 870872884
local n938 = 999253551
if p1406.Name == "DoubleRig" or p1406.Name == "Constraints" then
p1406:Destroy()
end
if not (n2 < n938) then
n1 += 1559
n937 -= 532
u215 += 992
n935 += 1923
n936 = 1030816280
n934 -= 750
n2 = 947585837
bit32.bxor(nil, nil)
if false then
upv204[nil] = nil
end
end
end)
)
end
Humanoid:SetStateEnabled(Dead, false)
Humanoid:SetStateEnabled(FallingDown, false)
Humanoid:SetStateEnabled(Ragdoll, false)
HipHeight = Humanoid.HipHeight
CanCollide = HumanoidRootPart.CanCollide
local Model = Instance.new("Model")
u9592 = Model
Model.Parent = game
Character.Parent = Model
local clone = HumanoidRootPart:Clone()
for _, v in clone:GetDescendants() do
if v:IsA("JointInstance") or v:IsA("WeldConstraint") or v:IsA("Constraint") then
v:Destroy()
end
end
clone.Parent = Character
u9590 = HumanoidRootPart
u9591 = clone
HumanoidRootPart.Parent = v9653
clone.CFrame = HumanoidRootPart.CFrame
Character.PrimaryPart = clone
if n918 < n935 then
Character.Parent = Workspace
else
n933 -= 1731
n934 -= 539
n935 += 782
u215 += 1823
n2 -= 604
n1 -= 457
n919 = 474658187
n936 -= 920
n916 -= 1292
n918 += 462
upv126[nil] = nil
end
v9597(Character, HumanoidRootPart, clone, true)
u9592 = nil
Model:Destroy()
u9581 = true
u9583 = p1405
v9635(Character, Humanoid)
local t365 = {}
u9595 = t365
for _, v in Character:GetDescendants() do
if v:IsA("BasePart") then
t365[v] = v.LocalTransparencyModifier
v.LocalTransparencyModifier = 1
end
end
table.insert(
t364,
p1395.Connect(Character.DescendantAdded, function(p1407)
if u9581 and p1407:IsA("BasePart") then
if t365[p1407] == nil then
t365[p1407] = p1407.LocalTransparencyModifier
end
pcall(function()
p1407.LocalTransparencyModifier = 1
end)
u9557 = true
end
end)
)
v9603(Character)
table.insert(
t364,
p1395.Connect(RunService2.RenderStepped, function()
if not u9581 or not u9551 then
return
end
if u9557 then
u9557 = false
v9603(Character)
end
for k in t365, nil, nil do
if k.LocalTransparencyModifier ~= 1 and k.Parent then
k.LocalTransparencyModifier = 1
end
end
if not u9552 or not HumanoidRootPart.Parent or not clone.Parent then
return
end
local v9669 = HumanoidRootPart.CFrame * clone.CFrame:Inverse()
for k, v in t360, nil, nil do
local v9672 = t359[k]
local v9673 = v:IsDescendantOf(Character)
if t362[v9672] ~= v9673 then
t362[v9672] = v9673
local localTransparencyModifier
if v9673 then
localTransparencyModifier = 0
else
localTransparencyModifier = 1
end
v9672.LocalTransparencyModifier = localTransparencyModifier
end
t361[k] = v9669 * v.CFrame
end
if n934 == 242315430 then
Workspace:BulkMoveTo(t359, t361, Enum.BulkMoveMode.FireCFrameChanged)
return
end
n919 += 964
n934 = 175920897
n2 -= 1145
n936 += 574
u215 = 542131800
n935 += 214
return (nil)(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 290))
end)
)
table.insert(
t364,
p1395.Connect(RunService2.Heartbeat, function()
local Humanoid2 = Character:FindFirstChildOfClass("Humanoid")
if not Humanoid2 then
return
end
Humanoid2.Health = Humanoid2.MaxHealth
Humanoid2:SetStateEnabled(Dead, false)
local state = Humanoid2:GetState()
if state == Dead or state == FallingDown or state == Ragdoll then
Humanoid2:ChangeState(Enum.HumanoidStateType.Running)
end
end)
)
local n939 = 60
local LowerTorso = Character:FindFirstChild("LowerTorso")
local Root = LowerTorso and LowerTorso:FindFirstChild("Root")
local UpperTorso = Character:FindFirstChild("UpperTorso")
local Position2
table.insert(
t364,
p1395.Connect(RunService2.PreSimulation, function()
if not u9581 then
return
end
local Humanoid2 = Character:FindFirstChildOfClass("Humanoid")
if not Humanoid2 or Humanoid2.Health <= 0 then
return
end
local PrimaryPart = Character.PrimaryPart or Character:FindFirstChild("HumanoidRootPart")
if not PrimaryPart then
return
end
local s45
if not HumanoidRootPart.Parent then
s45 = "real root destroyed"
elseif
Root
and Root.Parent
and Root:IsA("AnimationConstraint")
and (Root.Attachment0 == nil or Root.Attachment0.Parent == nil)
then
s45 = "root joint unhooked"
elseif
UpperTorso
and UpperTorso:IsA("BasePart")
and UpperTorso.Parent
and (UpperTorso.Position - HumanoidRootPart.Position).Magnitude > 12
then
s45 = "body drifted from root"
else
s45 = nil
end
if s45 then
if not u9585 then
u9585 = true
p1395.Log("InvisibleSteal desync:", s45, "restoring rig and restarting")
v9642()
end
return
end
if n939 > 0 then
n939 -= 1
elseif
not u9585
and Position2
and (HumanoidRootPart.Position - Position2).Magnitude > 2.25
then
u9585 = true
p1395.Log(
"InvisibleSteal drift",
(HumanoidRootPart.Position - Position2).Magnitude,
"restarting"
)
v9642()
return
end
local v9685 = PrimaryPart.CFrame
- Vector3.new(0, Humanoid2.HipHeight + PrimaryPart.Size.Y / 2 - 1 + v9562(), 0)
HumanoidRootPart.CFrame = v9685 * CFrame.Angles(math.rad(v9563()), 0, 0)
HumanoidRootPart.AssemblyLinearVelocity = PrimaryPart.AssemblyLinearVelocity
HumanoidRootPart.CanCollide = false
local v9686 = v9561()
if v9686 and HumanoidRootPart.Parent ~= v9686 then
HumanoidRootPart.Parent = v9686
end
Position2 = v9685.Position
end)
)
return true
end
v9639 = function(p1408)
local ok, result = pcall(v9648, p1408)
if ok and result then
return true
end
if not ok then
p1395.Log("InvisibleSteal start failed:", result)
end
v9615()
return false
end
local function v9689()
u9582 = false
u9583 = false
v9615()
Config.InvisActive = false
end
local function v9690(p1409)
if not u9550 then
if p1395.Running() then
if u9581 or u9584 then
if not p1409 then
u9583 = false
end
u9582 = true
Config.InvisActive = true
return
end
u9582 = true
if v9639(p1409) then
Config.InvisActive = true
else
u9582 = false
u9583 = false
Config.InvisActive = false
end
return
end
end
end
local u9691 = false
local function v9692()
if u9550 then
return
end
local v9693 = v9564()
if not v9693 or u9691 then
if not v9693 then
u9691 = false
if u9583 and (u9581 or u9584) then
v9689()
end
end
else
u9691 = true
if not u9581 then
task.delay(0.3, function()
if u9550 or not p1395.Running() or not u9546 or not v9564() or u9581 or u9584 then
return
end
v9690(true)
end)
end
end
end
local t366 = {}
table.insert(t366, p1395.Connect(LocalPlayer2:GetAttributeChangedSignal("Stealing"), v9692))
table.insert(
t366,
p1395.Connect(LocalPlayer2.CharacterAdded, function()
if u9581 or u9584 or u9582 then
v9689()
end
end)
)
task.defer(v9692)
t358.Set = function(p1410, p1411)
if p1410 == "InvisActive" then
if p1411 then
v9690(false)
else
v9689()
end
elseif p1410 == "InvisAutoOnSteal" then
u9546 = p1411 == true
if not u9546 and u9583 and (u9581 or u9584) then
v9689()
end
elseif p1410 == "InvisAngle" then
n920 = tonumber(p1411) or 180
elseif p1410 == "InvisAutoAngle" then
u9548 = p1411 == true
elseif p1410 == "InvisDepth" then
n921 = tonumber(p1411) or 4.2
elseif p1410 == "InvisTrueView" then
u9551 = p1411 == true
if u9581 and u9589 then
if u9551 then
v9603(u9589)
else
v9601()
end
end
end
end
local t367 = {
Params = OverlapParams.new(),
Rays = RaycastParams.new(),
Exposure = -1,
Cells = {},
CellsAt = 0,
Cast = 0,
StillSince = nil,
}
t367.Params.FilterType = Enum.RaycastFilterType.Exclude
t367.Rays.FilterType = Enum.RaycastFilterType.Exclude
local t368 = {
Vector3.new(8, 0, 0),
Vector3.new(-8, 0, 0),
Vector3.new(0, 0, 8),
Vector3.new(0, 0, -8),
}
local function v9697(p1412, p1413)
local Magnitude = p1413.Magnitude
local Unit = p1413.Unit
for i = 1, 4 do
t367.Cast += 1
local hit = Workspace:Raycast(p1412, Unit * Magnitude, t367.Rays)
if not hit then
return true
end
if hit.Instance.Transparency < 0.3 then
return false
end
local v9702 = (hit.Position - p1412).Magnitude + 0.05
Magnitude -= v9702
if Magnitude <= 0 then
return true
end
p1412 += Unit * v9702
end
if n916 ~= n2 then
return false
end
n916 -= 632
n918 += 787
n2 += 1214
u215 += 2009
n1 = 961205682
n919 = 849873098
return table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 381)
end
local function v9703(p1414, p1415, p1416)
t367.Params.FilterDescendantsInstances = p1416
local t369 = {}
for _, v in Workspace:GetPartBoundsInBox(CFrame.new(p1414), Vector3.one * p1415 * 2, t367.Params) do
if v.Transparency < 0.3 then
local Model = v:FindFirstAncestorOfClass("Model")
if not Model or not Model:FindFirstChildOfClass("Humanoid") then
local CFrame_ = v.CFrame
local v9709 = v.Size * 0.5
local XVector = CFrame_.XVector
local YVector = CFrame_.YVector
local ZVector = CFrame_.ZVector
local vector3 = Vector3.new(
math.abs(XVector.X) * v9709.X
+ math.abs(YVector.X) * v9709.Y
+ math.abs(ZVector.X) * v9709.Z,
math.abs(XVector.Y) * v9709.X
+ math.abs(YVector.Y) * v9709.Y
+ math.abs(ZVector.Y) * v9709.Z,
math.abs(XVector.Z) * v9709.X
+ math.abs(YVector.Z) * v9709.Y
+ math.abs(ZVector.Z) * v9709.Z
)
t369[#t369 + 1] = {
Inv = CFrame_:Inverse(),
Half = v9709,
Min = CFrame_.Position - vector3,
Max = CFrame_.Position + vector3,
}
end
end
end
return t369
end
local function v9714(p1417, p1418)
for _, v in p1417, nil, nil do
local Min = v.Min
local Max = v.Max
if
not (Min.X <= p1418.X)
or not (p1418.X <= Max.X)
or not (Min.Y <= p1418.Y)
or not (p1418.Y <= Max.Y)
or not (Min.Z <= p1418.Z)
or not (p1418.Z <= Max.Z)
then
continue
end
local v9719 = v.Inv * p1418
local Half = v.Half
if
math.abs(v9719.X) <= Half.X
and math.abs(v9719.Y) <= Half.Y
and math.abs(v9719.Z) <= Half.Z
then
return true
end
end
return false
end
local function v9721()
local v9722 = u9589
local v9723 = u9590
local v9724 = u9591
if not u9581 or not v9722 or not v9723 or not v9724 or not v9723.Parent or not v9724.Parent then
return nil
end
local Humanoid = v9722:FindFirstChildOfClass("Humanoid")
if not Humanoid then
return nil
end
local t370 = {}
local n940 = 4
for _, v in v9722:GetDescendants() do
if
v:IsA("BasePart")
and v ~= v9724
and v ~= v9723
and v.Transparency < 1
and v.Name ~= "__HITBOX"
then
local v9730 = v9724.CFrame:ToObjectSpace(v.CFrame)
t370[#t370 + 1] = {
Offset = v9730,
Size = v.Size,
Weight = 1,
Carried = false,
}
n940 = math.max(n940, v9730.Position.Magnitude + v.Size.Magnitude * 0.5)
end
end
local t371 = {
v9722,
v9723,
}
local CurrentCamera = Workspace.CurrentCamera
if CurrentCamera then
t371[#t371 + 1] = CurrentCamera
end
local t372 = {}
for _, v in v9723:GetConnectedParts(true) do
if v ~= v9723 and not v:IsDescendantOf(v9722) then
local Model = v:FindFirstAncestorOfClass("Model")
if Model and not table.find(t371, Model) then
t371[#t371 + 1] = Model
end
if v.Transparency < 1 then
t372[#t372 + 1] = v
end
end
end
table.sort(t372, function(p1419, p1420)
return p1419.Size.X * p1419.Size.Y * p1419.Size.Z > p1420.Size.X * p1420.Size.Y * p1420.Size.Z
end)
for i = 1, math.min(#t372, 16) do
local v9738 = t372[i]
local v9739 = v9723.CFrame:ToObjectSpace(v9738.CFrame)
t370[#t370 + 1] = {
Offset = v9739,
Size = v9738.Size,
Weight = 4,
Carried = true,
}
n940 = math.max(n940, v9739.Position.Magnitude + v9738.Size.Magnitude * 0.5)
end
if #t370 == 0 then
return nil
end
local v9740 = v9724.CFrame - Vector3.new(0, Humanoid.HipHeight + v9724.Size.Y / 2 - 1 + v9562(), 0)
local v9741 = v9703(v9740.Position, n940 + 1, t371)
local t373 = { Vector3.zero }
for _, v in
{
-0.45,
0.45,
},
nil,
nil
do
for _, v2 in
{
-0.45,
0.45,
},
nil,
nil
do
for _, v3 in
{
-0.45,
0.45,
},
nil,
nil
do
t373[#t373 + 1] = Vector3.new(v, v2, v3)
end
end
end
local v9749 = table.clone(t371)
for _, v in Players2:GetPlayers() do
if v.Character then
v9749[#v9749 + 1] = v.Character
end
end
t367.Rays.FilterDescendantsInstances = v9749
if os.clock() - t367.CellsAt > 1.5 then
table.clear(t367.Cells)
t367.CellsAt = os.clock()
end
local function v9752(p1421)
local v9753 = math.floor(p1421.X)
local v9754 = math.floor(p1421.Y)
local v9755 = math.floor(p1421.Z)
local v9756 = ((v9753 + 4096) * 8192 + (v9754 + 4096)) * 8192 + (v9755 + 4096)
local v9757 = t367.Cells[v9756]
if v9757 ~= nil then
return v9757
end
local vector3 = Vector3.new(v9753 + 0.5, v9754 + 0.5, v9755 + 0.5)
local v9759 = false
if not v9714(v9741, vector3) then
if v9697(vector3, Vector3.new(0, 60, 0)) then
v9759 = true
elseif not v9697(vector3, Vector3.new(0, -20, 0)) then
for _, v in t368, nil, nil do
if v9697(vector3, v) then
v9759 = true
break
end
end
end
end
t367.Cells[v9756] = v9759
return v9759
end
local n941 = 0
for _, v in t370, nil, nil do
v.Weight *= math.clamp((v.Size.X * v.Size.Y * v.Size.Z) ^ 0.33333333333333331, 0.3, 4)
n941 += v.Weight * #t373
end
local v9765 = v9563()
local t374 = {}
for i = 0, 350, 10 do
t374[#t374 + 1] = i
end
if v9765 % 10 ~= 0 then
t374[#t374 + 1] = v9765
end
local v9768 = v9765
local huge = math.huge
local v9770
local n942 = 0
for k, v in t374, nil, nil do
local v9774 = v9740 * CFrame.Angles(math.rad(v), 0, 0)
local n943 = 0
local n944 = 0
for _, v2 in t370, nil, nil do
if t367.Cast > 200 then
t367.Cast = 0
RunService2.Heartbeat:Wait()
if not u9581 or u9590 ~= v9723 then
return nil
end
end
local v9779 = v9774 * v2.Offset
for _, v3 in t373, nil, nil do
if v9752(v9779:PointToWorldSpace(v3 * v2.Size)) then
n943 += v2.Weight
if v2.Carried then
n944 += v2.Weight
end
end
end
end
if v == v9765 then
v9770 = n943
end
if n943 < huge - 0.01 then
v9768 = v
huge = n943
n942 = n944
end
if k % 6 == 0 or t367.Cast > 200 then
t367.Cast = 0
RunService2.Heartbeat:Wait()
if u9581 and u9590 == v9723 then
continue
end
return nil
end
end
return v9768, huge, v9770, n941, n942
end
local function v9782()
local v9783 = u9589
local v9784 = u9591
local Humanoid = v9783
local ok = not Humanoid
if not ok then
Humanoid = v9783:FindFirstChildOfClass("Humanoid")
ok = not (not not v9784 and Humanoid)
end
if ok then
if u215 == 899665139 then
return 0
end
n2 += 1791
n919 = 318877715
n918 += 425
u215 += 547
n1 = 736798300
n917 += 1914
(nil)[nil] = nil
(nil)(nil)
end
if
Humanoid.MoveDirection.Magnitude > 0.05
or (v9784.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude > 0.5
or math.abs(v9784.AssemblyLinearVelocity.Y) > 2
then
t367.StillSince = nil
return 0
end
t367.StillSince = t367.StillSince or os.clock()
return os.clock() - t367.StillSince
end
task.spawn(function()
while not u9550 and p1395.Running() do
if u9548 and u9581 and v9782() < 0.3 then
task.wait(0.05)
elseif u9548 and u9581 then
local ok, result, result2, result3, result4, result5 = pcall(v9721)
if ok and result and result2 and result4 and result4 > 0 then
local huge = result3 or math.huge
if
result ~= v9563()
and result2 < huge - math.max(0.5, huge * 0.05)
and v9782() >= 0.3
then
n920 = result
if type(p1395.Set) == "function" then
p1395.Set("InvisAngle", result)
end
p1395.Log(
"InvisibleSteal angle",
result,
string.format(
"exposed=%.0f%% brainrot=%.0f%% was=%.0f%%",
result2 / result4 * 100,
(result5 or 0) / result4 * 100,
math.min(huge, result4) / result4 * 100
)
)
end
local exposure = math.floor(math.min(result2, huge) / result4 * 100 + 0.5)
if exposure ~= t367.Exposure then
t367.Exposure = exposure
p1395.Log("InvisibleSteal exposure", exposure .. "%", "angle=" .. v9563())
end
elseif not ok then
p1395.Log("InvisibleSteal angle scan failed", result)
end
task.wait(0.1)
else
t367.Exposure = -1
task.wait(0.25)
end
end
end)
local n945
t358.Toggle = function()
n945 = 855471940
if u9581 or u9584 and u9582 then
v9689()
elseif n1 < u215 then
v9690(false)
else
u215 += 949
n2 = 285855728
n918 -= 1167
n945 -= 436
n917 = 531383320
n1 -= 219
n919 = 553499641
end
end
t358.IsActive = function()
if u215 ~= 899666392 then
return u9581
end
n915 = 1002509150
u215 = 416298991
n916 = 1015068822
n918 = 442840248
n2 -= 1646
n919 -= 1653
return nil
end
t358.Stop = function()
v9689()
u9550 = true
v9558(t366)
end
return t358
end
return v9534
end
Sources.Invisible = v9530()
local n946
local function v9797()
n946 = 621997047
local n947 = 847377127
local n948
if n2 == 557240548 then
local function v9800(p1422)
n948 = 403850867
local Players2 = p1422.Players
local ReplicatedStorage = p1422.ReplicatedStorage
local Workspace = p1422.Workspace
local Lighting = p1422.Lighting
local n949 = 17673598
local LocalPlayer2 = p1422.LocalPlayer
local Config = p1422.Config
local t375 = {
Defaults = {
AntiRagdoll = false,
AntiKnockback = false,
AntiBee = false,
AntiBoogie = false,
AntiGummy = false,
AntiAdmin = false,
AntiBodySwap = false,
AntiBeeDisco = false,
},
}
local n950 = 353673678
local getconstants_ = getconstants or debug and debug.getconstants
local genv = getgenv and getgenv() or _G
local v9812 = game.PlaceId == 99606176102979
local u9813 = false
local t376 = {}
local t377 = {}
local function v9816(p1423)
return not u9813
and p1422.Running()
and (
Config[p1423] == true
or (p1423 == "AntiBee" or p1423 == "AntiBoogie") and Config.AntiBeeDisco == true
)
end
local function v9817(p1424)
local n951 = 369422612
if n951 < n946 then
local function v9819(...)
local ok, result = pcall(p1424, ...)
if not ok then
p1422.Log("protection", result)
end
end
return v9819
end
n914 = 682404287
u214 = 913968837
n2 = 924601480
n950 += 124
n946 += 1985
n949 += 603
(nil)()
end
local function v9822(p1425, p1426)
local v9823
local v9824 = p1426
local v9825 = p1422.Connect(p1425, v9817(v9824))
if n2 < 1044273654 then
table.insert(t376, v9825)
return v9825
end
u214 = 260963309
n2 -= 1130
n914 = 650903635
n950 -= 353
n946 = 159756384
n949 += 1253
return v9823()
end
local n952
local function v9827(p1427, p1428, p1429)
n952 = 414602365
if t377[p1427] or u9813 then
return
end
if 692375327 == n949 then
n946 -= 1352
n950 = 275451339
n949 += 1445
n2 += 1200
n914 += 1678
n952 += 1406
n1 -= 736
bit32.rshift(nil, nil)
else
t377[p1427] = p1422.Loop(p1428, p1429)
end
end
local function v9828(p1430)
local v9829 = t377[p1430]
if not v9829 then
return
end
t377[p1430] = nil
pcall(v9829.Stop)
end
local function v9830(...)
local v9831 = ReplicatedStorage
for _, v in ipairs({ ... }) do
v9831 = v9831 and v9831:FindFirstChild(v)
end
if not v9831 or not v9831:IsA("ModuleScript") then
return nil
end
local v9834 = p1422.Require(v9831)
if type(v9834) == "table" then
return v9834
end
return nil
end
local u9835
local function v9836()
if u9835 then
return u9835
end
local PlayerScripts = LocalPlayer2:FindFirstChild("PlayerScripts")
local PlayerModule = PlayerScripts and PlayerScripts:FindFirstChild("PlayerModule")
if not PlayerModule then
return nil
end
local v9839 = p1422.Require(PlayerModule)
if not v9839 then
return nil
end
local ok, result = pcall(function()
return v9839:GetControls()
end)
if ok and result then
u9835 = result
end
return u9835
end
local Controllers
local function v9843()
if not Controllers then
Controllers = v9830("Controllers", "CharacterController")
end
return Controllers
end
local function v9844(p1431, p1432, p1433)
local v9845 = v9843()
if v9845 then
v9845:RequestMove(p1431, p1432, p1433)
end
end
local function v9846()
local v9847 = v9843()
if not v9847 then
return
end
local v9848 = v9836()
if not v9848 then
return
end
local originalMoveFunction = v9847.originalMoveFunction or v9844
if v9848.moveFunction ~= originalMoveFunction then
v9848.moveFunction = originalMoveFunction
end
end
local function v9850()
local v9851 = v9836()
if v9851 then
pcall(function()
v9851:Enable()
end)
end
end
local t378 = {}
local t379 = {}
local u9854
local function v9855()
for _, v in ipairs(t378) do
v:Disconnect()
end
table.clear(t378)
for _, v in pairs(t379) do
v:Disconnect()
end
table.clear(t379)
u9854 = nil
end
local function v9860(p1434)
if u9813 or not p1434:IsA("BasePart") or t379[p1434] then
return
end
local v9861 = p1434
if v9861.Anchored then
v9861.Anchored = false
end
t379[v9861] = v9861:GetPropertyChangedSignal("Anchored"):Connect(v9817(function()
if not u9813 and v9861.Anchored then
v9861.Anchored = false
end
end))
end
local function v9862(p1435)
if u9813 or not p1435 or p1435 ~= LocalPlayer2.Character or u9854 == p1435 then
return
end
v9855()
u9854 = p1435
table.insert(t378, p1435.ChildAdded:Connect(v9817(v9860)))
table.insert(
t378,
p1435.ChildRemoved:Connect(v9817(function(p1436)
local v9863 = t379[p1436]
if v9863 then
v9863:Disconnect()
t379[p1436] = nil
end
end))
)
for _, child in ipairs(p1435:GetChildren()) do
v9860(child)
end
end
local t380 = {
Base = setmetatable({}, {
__mode = "k",
}),
BaseCount = 0,
Character = nil,
Dirty = true,
Constraints = {},
Healthy = setmetatable({}, {
__mode = "k",
}),
}
local function v9867(p1437)
if u9813 or not p1437 or p1437 ~= LocalPlayer2.Character then
return
end
if t380.Character == p1437 and (not t380.Dirty or t380.BaseCount >= 10) then
return
end
if t380.Character ~= p1437 then
t380.Healthy = setmetatable({}, {
__mode = "k",
})
end
local base = setmetatable({}, {
__mode = "k",
})
local baseCount = 0
local constraints = {}
for _, descendant in ipairs(p1437:GetDescendants()) do
local ClassName = descendant.ClassName
if ClassName == "BallSocketConstraint" or ClassName == "HingeConstraint" then
base[descendant] = true
baseCount += 1
elseif ClassName == "AnimationConstraint" then
table.insert(constraints, descendant)
end
end
t380.Base = base
t380.BaseCount = baseCount
t380.Character = p1437
t380.Constraints = constraints
t380.Dirty = false
end
local function v9874()
for _, constraint in ipairs(t380.Constraints) do
if constraint.Parent and constraint.Enabled and constraint.MaxTorque > 0 then
t380.Healthy[constraint] = constraint.MaxTorque
end
end
end
local function v9877()
for _, constraint in ipairs(t380.Constraints) do
if constraint.Parent and (not constraint.Enabled or constraint.MaxTorque == 0) then
return true
end
end
return false
end
local function v9880()
for _, constraint in ipairs(t380.Constraints) do
if constraint.Parent then
if not constraint.Enabled then
constraint.Enabled = true
end
if constraint.MaxTorque == 0 then
constraint.MaxTorque = t380.Healthy[constraint] or 3000
end
end
end
if u214 == 193795955 then
return
end
n947 = 574668250
n949 = 195890656
n2 = 672761302
u214 = 416156767
n914 += 349
n950 = 85893535
upv364[nil] = nil
return (nil)()
end
local function v9883(...)
local v9884 = ...
if t380.Base[v9884] then
return true
end
if v9884:FindFirstAncestorOfClass("Tool") then
return true
end
local Name = v9884.Name
if n948 < n947 then
return Name:sub(-10) == "BallSocket" or Name:sub(-6) == "Socket"
end
n947 += 1181
n950 = 509914296
n2 = 102020833
n948 += 497
n914 = 1053984981
n949 = 413411279
return (nil)({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
bit32.rshift(nil, nil),
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
-nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil + nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
...,
})
end
local t381 = {
Until = 0,
Window = -math.huge,
Deep = false,
DeepAt = 0,
Cleaned = false,
}
local function v9887()
local attribute = LocalPlayer2:GetAttribute("RagdollEndTime")
local Until = t381.Until
return math.max(
0,
math.max(Until, type(attribute) == "number" and attribute or 0)
- Workspace:GetServerTimeNow()
)
end
local function v9890(p1438)
if v9887() > 0 then
return true
end
if LocalPlayer2:GetAttribute("Ragdoll") == true then
return true
end
local state = p1438:GetState()
if
state == Enum.HumanoidStateType.Physics
or state == Enum.HumanoidStateType.Ragdoll
or state == Enum.HumanoidStateType.FallingDown
then
return true
end
if n1 < n946 then
return v9877()
end
n946 -= 1273
n950 = 858346119
n949 += 712
n2 += 1542
n948 -= 307
n1 += 1516
local v9892 = nil + nil
upv98[nil] = nil
end
local function v9893(p1439)
local Character = LocalPlayer2.Character
if not Character then
return
end
local Humanoid = Character:FindFirstChildOfClass("Humanoid")
v9880()
for _, child in ipairs(Character:GetChildren()) do
if child:IsA("BasePart") and child.Anchored then
child.Anchored = false
end
end
if p1439 then
for _, descendant in ipairs(Character:GetDescendants()) do
local ClassName = descendant.ClassName
if ClassName == "BallSocketConstraint" or ClassName == "HingeConstraint" then
if not v9883(descendant) then
descendant:Destroy()
end
elseif descendant:IsA("BasePart") and descendant.Anchored then
descendant.Anchored = false
end
end
end
if not Humanoid then
return
end
local state = Humanoid:GetState()
if
Humanoid.PlatformStand
or state == Enum.HumanoidStateType.Physics
or state == Enum.HumanoidStateType.Ragdoll
or state == Enum.HumanoidStateType.FallingDown
or state == Enum.HumanoidStateType.PlatformStanding
then
if Humanoid.PlatformStand then
Humanoid.PlatformStand = false
end
pcall(function()
Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
end)
pcall(function()
Humanoid:ChangeState(Enum.HumanoidStateType.Running)
end)
end
local CurrentCamera = Workspace.CurrentCamera
if CurrentCamera and not (type(getgenv) == "function" and getgenv().SxeCameraHeld) then
if CurrentCamera.CameraType ~= Enum.CameraType.Custom then
CurrentCamera.CameraType = Enum.CameraType.Custom
end
if CurrentCamera.CameraSubject ~= Humanoid then
CurrentCamera.CameraSubject = Humanoid
end
end
if LocalPlayer2.CameraMode == Enum.CameraMode.LockFirstPerson then
LocalPlayer2.CameraMode = Enum.CameraMode.Classic
end
v9850()
end
local t382 = {}
local function v9904(p1440)
local t383 = {}
local Packages = ReplicatedStorage:FindFirstChild("Packages")
local Net = Packages and Packages:FindFirstChild("Net")
if not Net or type(getconnections) ~= "function" then
return t383
end
for _, child in ipairs(Net:GetChildren()) do
if child:IsA("RemoteEvent") then
local ok, result = pcall(getconnections, child.OnClientEvent)
if ok and type(result) == "table" then
for _, v in ipairs(result) do
local Function = v.Function
if Function then
local ok2, result2 = pcall(debug.info, Function, "s")
if ok2 and type(result2) == "string" and result2:find(p1440, 1, true) then
table.insert(t383, v)
end
end
end
end
end
end
return t383
end
local function v9917(p1441)
local n953 = 260520654
local v9919 = t382[p1441]
local n954 = 772158410
if v9919 then
if #v9919 > 0 then
local v9921 = true
for _, v in ipairs(v9919) do
local ok, result = pcall(function()
return v.Function
end)
if not (n1 < u214) then
u214 += 470
n949 = 460903015
n954 += 1915
repeat
n953 -= 960
n946 = 240747105
n1 = 1022571841
n2 -= 1741
n950 -= 443
until not (nil <= nil)
n953 = 3
elseif not ok or not result then
v9921 = false
break
end
end
if v9921 then
return v9919
end
end
end
local v9926 = v9904(p1441)
t382[p1441] = v9926
return v9926
end
local t384 = {}
local function v9928(p1442, p1443)
if not p1443 and not t384[p1442] then
return true
end
local v9929 = v9917(p1442)
if #v9929 == 0 then
return false
end
for _, v in ipairs(v9929) do
pcall(function()
if p1443 then
v:Disable()
else
v:Enable()
end
end)
end
t384[p1442] = p1443 or nil
return true
end
local function v9932()
return v9830("Controllers", "CombatController")
end
local function v9933(p1444, p1445, p1446)
local v9934 = v9843()
if not v9934 then
return
end
local _, _, v9937 = v9934:GetCharacter()
if not v9937 then
return
end
local v9938 = os.clock() + 1
while (v9937.Anchored or v9937:GetAttribute("NetworkOwnerSet")) and not (v9938 <= os.clock()) do
task.wait()
end
pcall(function()
v9937:ApplyImpulse(p1446 * p1445)
end)
end
local function v9939(p1447)
return p1447 == genv.__SxeApplyImpulseStub
or type(p1447) == "function" and debug.info(p1447, "a") == 0
end
local function v9940()
local n955 = 741606461
if v9928("CombatController", true) then
return
end
local v9942 = v9932()
if not v9942 or type(v9942.ApplyImpulse) ~= "function" then
return
end
if not (type(genv.__SxeApplyImpulseOrig) == "function" or v9939(v9942.ApplyImpulse)) then
genv.__SxeApplyImpulseOrig = v9942.ApplyImpulse
end
if not genv.__SxeApplyImpulseStub then
genv.__SxeApplyImpulseStub = function()
if n950 ~= 353673678 then
n946 += 307
n948 += 920
n955 += 1700
n950 = 158051541
n2 = 662846189
(nil)(nil, nil)
end
end
end
v9942.ApplyImpulse = genv.__SxeApplyImpulseStub
end
local function v9943()
v9928("CombatController", false)
local v9944 = v9932()
if not v9944 then
return
end
local ApplyImpulse = v9944.ApplyImpulse
if type(ApplyImpulse) == "function" and not v9939(ApplyImpulse) then
return
end
local __SxeApplyImpulseOrig = genv.__SxeApplyImpulseOrig
if n946 == 621997047 then
pcall(function()
v9944.ApplyImpulse = type(__SxeApplyImpulseOrig) == "function" and __SxeApplyImpulseOrig
or v9933
end)
else
n2 -= 955
u214 += 900
n948 += 1028
n950 = 906652402
n949 = 287996004
n946 -= 1075
(nil)[nil] = nil
getfenv()[nil] = nil
end
end
local function v9947()
if not v9816("AntiRagdoll") then
return
end
local Character = LocalPlayer2.Character
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
local state = Humanoid and Humanoid:GetState()
local attribute = LocalPlayer2:GetAttribute("RagdollEndTime")
local serverTimeNow = Workspace:GetServerTimeNow()
if type(attribute) == "number" and serverTimeNow < attribute then
t381.Until = math.max(t381.Until, attribute)
if type(getgenv) == "function" then
getgenv().SxeRagdollUntil = t381.Until
end
end
if
not (
type(attribute) == "number" and attribute > serverTimeNow
or LocalPlayer2:GetAttribute("Ragdoll") == true
or state == Enum.HumanoidStateType.Physics
or state == Enum.HumanoidStateType.Ragdoll
)
then
return
end
t381.Window = os.clock() + 2
t381.Cleaned = false
t381.Deep = true
v9893(true)
end
local function v9953()
local attribute = LocalPlayer2:GetAttribute("RagdollEndTime")
if type(attribute) == "number" and Workspace:GetServerTimeNow() < attribute then
t381.Until = math.max(t381.Until, attribute)
if type(getgenv) == "function" then
getgenv().SxeRagdollUntil = t381.Until
end
LocalPlayer2:SetAttribute("RagdollEndTime", 0)
t381.Window = os.clock() + 2
end
if os.clock() < t381.Window then
v9893(false)
end
if n2 == 557240548 then
return
end
n946 = 340003343
n948 -= 1015
n2 -= 1764
n949 -= 278
n950 -= 801
n947 = 798564411
upv229[nil] = nil
return (nil)(nil)
end
local function v9955()
local Character = LocalPlayer2.Character
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
if not Humanoid or not Character:FindFirstChild("HumanoidRootPart") then
return
end
local now3 = os.clock()
if v9890(Humanoid) then
t381.Window = now3 + 1
end
if now3 < t381.Window + 0.7 then
local Deep = t381.Deep or now3 - t381.DeepAt > 0.5
if Deep then
t381.Deep = false
t381.DeepAt = now3
end
v9893(Deep)
else
v9874()
if not t381.Cleaned then
t381.Cleaned = true
v9867(Character)
end
end
end
local function v9960()
if v9816("AntiRagdoll") then
v9928("RagdollController", true)
end
if v9816("AntiKnockback") then
v9940()
end
end
local exitTo
local t385, t386, v9964, t387, v9966, v9967, u9968, v9969, t388, t389, obj, t390, v9974, v9975, u9976, u9977, v9978, u9979, u9980, u9981, u9982, u9983, v9984, u9985, u9986, u9987, v9988, u9989, u9990, v9991, t391, u9993, u9994, v9995, t392, u9997, u9998, u9999, u10000, u10001, u10002, u10003, s46, u10005
repeat
t385 = {}
t386 = {
__mode = "k",
}
local t393 = {
Character = nil,
Hip = nil,
Size = setmetatable(t385, t386),
}
t385 = {}
t386 = {
__mode = "k",
}
t393.Offset = setmetatable(t385, t386)
v9964 = function(p1448)
if u9813 or not p1448 or p1448 ~= LocalPlayer2.Character or t393.Character == p1448 then
return
end
local Humanoid = p1448:FindFirstChildOfClass("Humanoid")
if not Humanoid then
return
end
t393.Hip = Humanoid.HipHeight
t393.Size = setmetatable({}, {
__mode = "k",
})
t393.Offset = setmetatable({}, {
__mode = "k",
})
for _, descendant in ipairs(p1448:GetDescendants()) do
if descendant:IsA("BasePart") then
t393.Size[descendant] = descendant.Size
elseif descendant:IsA("Attachment") then
t393.Offset[descendant] = descendant.CFrame
end
end
t393.Character = p1448
end
t385 = nil
t386 = nil
t387 = {
VectorForceDirty = false,
MorphSeen = nil,
SlowAt = 0,
VictimOriginal = nil,
VictimStub = function()
t385 = 520519654
t386 = 488427337
end,
Modifier = setmetatable({}, {
__mode = "k",
}),
Transparency = setmetatable({}, {
__mode = "k",
}),
}
local function v10010(p1449, p1450)
if not v9812 then
p1449.AssemblyLinearVelocity = p1450
return
end
pcall(function()
p1449:ApplyImpulse(p1449.AssemblyMass * (p1450 - p1449.AssemblyLinearVelocity))
end)
end
v9966 = function()
local Character = LocalPlayer2.Character
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
if not Humanoid then
return
end
v9846()
local Datas = v9830("Datas", "AdminCommands", "jumpscare")
local effects = Datas
effects = effects and Datas.effects
if type(effects) == "table" and effects.Victim and effects.Victim ~= t387.VictimStub then
t387.VictimOriginal = effects.Victim
effects.Victim = t387.VictimStub
end
local CurrentCamera = Workspace.CurrentCamera
if CurrentCamera and CurrentCamera.CameraSubject ~= Humanoid then
if n950 < n948 then
CurrentCamera.CameraSubject = Humanoid
else
n948 = 829058679
n949 -= 862
n2 -= 1382
n950 = 955310075
n914 = 942587858
n947 = 543263197
end
end
end
local function v10016(p1451, p1452)
local v10017
local v10018, v10019, v10020 = ipairs(p1451:GetChildren())
local v10021 = geniter(v10018, v10019, v10020)
while true do
local v10022 = table.pack(v10021())
if not v10022[1] then
break
end
local v10023 = v10022[3]
if v10023:IsA("Model") then
v10017 = v10023
break
end
end
if v10017 then
t387.MorphSeen = p1452
local v10024, v10025, v10026 = ipairs(v10017:GetDescendants())
for _, v in v10024, v10025, v10026 do
local v10029 = v
if
(v:IsA("BasePart") or v:IsA("Decal"))
and v10029.LocalTransparencyModifier ~= 1
then
if t387.Modifier[v] == nil then
t387.Modifier[v] = v10029.LocalTransparencyModifier
end
v10029.LocalTransparencyModifier = 1
end
end
end
if not t387.MorphSeen or not (p1452 - t387.MorphSeen < 3) then
return
end
local v10030, v10031, v10032 = ipairs(p1451:GetDescendants())
for _, v in v10030, v10031, v10032 do
if v:IsA("BasePart") and (not v10017 or not v:IsDescendantOf(v10017)) then
local transparency = (v.Name == "HumanoidRootPart" or v.Name == "__HITBOX") and 1
or 0
if v.Transparency ~= transparency then
if t387.Transparency[v] == nil then
t387.Transparency[v] = v.Transparency
end
v.Transparency = transparency
end
end
end
end
v9967 = function()
local n956 = 692198074
local Character = LocalPlayer2.Character
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
if not Character or not Humanoid then
return
end
local n957 = 203548921
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
local n958
if
HumanoidRootPart
and (
Humanoid.PlatformStand
or Humanoid:GetState() == Enum.HumanoidStateType.PlatformStanding
)
then
Humanoid.PlatformStand = false
local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity
if AssemblyLinearVelocity.Y > 5 then
v10010(
HumanoidRootPart,
Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z)
)
end
pcall(function()
n958 = 1066228309
if n949 == 17673598 then
Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
else
n957 = 210317148
n2 = 1030531027
n958 -= 260
n956 -= 326
n949 = 80841436
bit32.bxor(nil, nil)
end
end)
end
local now3
if LocalPlayer2:GetAttribute("GiantPotion") == nil and t393.Character == Character then
if t393.Hip and Humanoid.HipHeight ~= t393.Hip then
Humanoid.HipHeight = t393.Hip
end
for k, v in pairs(t393.Size) do
if k.Parent and k.Size ~= v then
k.Size = v
end
end
for k, v in pairs(t393.Offset) do
if k.Parent and k.CFrame ~= v then
k.CFrame = v
end
end
now3 = os.clock()
if
not t387.VectorForceDirty
and not (t387.MorphSeen ~= nil and now3 - t387.MorphSeen < 3)
and not (now3 - t387.SlowAt >= 0.4)
then
if n956 == 692198074 then
return
end
n2 -= 1283
n946 = 535135109
n949 += 573
n950 = 733774687
n957 += 1699
n956 = 1049753483
n1 = 788905879
n947 = 727047607
end
else
now3 = os.clock()
if
not t387.VectorForceDirty
and not (t387.MorphSeen ~= nil and now3 - t387.MorphSeen < 3)
and not (now3 - t387.SlowAt >= 0.4)
then
return
end
end
t387.SlowAt = now3
t387.VectorForceDirty = false
for _, descendant in ipairs(Character:GetDescendants()) do
if descendant.ClassName == "VectorForce" then
pcall(function()
descendant:Destroy()
if n956 == 692200048 then
n950 += 752
n2 = 349557976
n957 = 379188008
n956 = 543562200
upv186[nil] = nil
end
end)
end
end
v10016(Character, now3)
end
u9968 = nil
v9969 = function()
u9968 = 774504739
local n959 = 606616875
local Datas = v9830("Datas", "AdminCommands", "jumpscare")
local effects = Datas and Datas.effects
if
type(effects) == "table"
and effects.Victim == t387.VictimStub
and t387.VictimOriginal
then
effects.Victim = t387.VictimOriginal
end
local n960
for k, v in pairs(t387.Modifier) do
local v10056 = k
if k.Parent then
pcall(function()
n960 = 1011529751
if n959 == 606618322 then
n2 = 488187633
n959 = 81761443
u214 += 1985
n960 += 1958
n950 += 1444
n1 += 1026
n947 = 587344937
upv45[nil] = nil
(nil)[56] = nil
(nil)[57] = nil
(nil)[58] = nil
(nil)[59] = nil
(nil)[60] = nil
(nil)[61] = nil
(nil)[62] = nil
(nil)[63] = nil
(nil)[64] = nil
(nil)[65] = nil
(nil)[66] = nil
(nil)[67] = nil
(nil)[68] = nil
(nil)[69] = nil
(nil)[70] = nil
(nil)[71] = nil
(nil)[72] = nil
(nil)[73] = nil
(nil)[74] = nil
(nil)[75] = nil
(nil)[76] = nil
(nil)[77] = nil
(nil)[78] = nil
(nil)[79] = nil
(nil)[80] = nil
(nil)[81] = nil
(nil)[82] = nil
(nil)[83] = nil
(nil)[84] = nil
(nil)[85] = nil
(nil)[86] = nil
(nil)[87] = nil
(nil)[88] = nil
(nil)[89] = nil
(nil)[90] = nil
(nil)[91] = nil
(nil)[92] = nil
(nil)[93] = nil
(nil)[94] = nil
(nil)[95] = nil
(nil)[96] = nil
(nil)[97] = nil
(nil)[98] = nil
(nil)[99] = nil
(nil)[100] = nil
(nil)[101] = nil
(nil)[102] = nil
(nil)[103] = nil
(nil)[104] = nil
(nil)[105] = nil
(nil)[106] = nil
(nil)[107] = nil
(nil)[108] = nil
(nil)[109] = nil
(nil)[110] = nil
(nil)[111] = nil
(nil)[112] = nil
(nil)[113] = nil
(nil)[114] = nil
(nil)[115] = nil
(nil)[116] = nil
(nil)[117] = nil
(nil)[118] = nil
(nil)[119] = nil
(nil)[120] = nil
(nil)[121] = nil
(nil)[122] = nil
(nil)[123] = nil
(nil)[124] = nil
(nil)[125] = nil
(nil)[126] = nil
(nil)[127] = nil
(nil)[128] = nil
(nil)[129] = nil
(nil)[130] = nil
(nil)[131] = nil
(nil)[132] = nil
(nil)[133] = nil
(nil)[134] = nil
(nil)[135] = nil
(nil)[136] = nil
(nil)[137] = nil
(nil)[138] = nil
(nil)[139] = nil
(nil)[140] = false
(nil)[141] = nil
(nil)[142] = nil
(nil)[143] = nil
(nil)[144] = nil
(nil)[145] = nil
(nil)[146] = nil
(nil)[147] = nil
(nil)[148] = nil
(nil)[149] = nil
(nil)[150] = nil
(nil)[151] = nil
(nil)[152] = nil
(nil)[153] = nil
(nil)[154] = nil
(nil)[155] = nil
(nil)[156] = nil
(nil)[157] = nil
(nil)[158] = nil
(nil)[159] = nil
else
v10056.LocalTransparencyModifier = v
end
end)
end
end
table.clear(t387.Modifier)
local Character = LocalPlayer2.Character
if Character and Character:FindFirstChildWhichIsA("Model") then
for k, v in pairs(t387.Transparency) do
if k:IsDescendantOf(Character) then
k.Transparency = v
end
end
end
table.clear(t387.Transparency)
t387.MorphSeen = nil
end
t388 = {
["Bee Attack"] = "AntiBee",
Boogie = "AntiBoogie",
}
t389 = {
__mode = "k",
}
obj = setmetatable({}, t389)
t390 = {
BeeUntil = 0,
BoogieUntil = 0,
}
t389 = nil
v9974 = nil
v9975 = function()
local v10060 = t389
local n961 = 227520292
if
not v10060
or type(getconnections) ~= "function"
or type(getconstants_) ~= "function"
then
return
end
local ok, result = pcall(getconnections, v10060.OnClientEvent)
if not ok or type(result) ~= "table" then
return
end
local n962 = 3045440
for _, v in ipairs(result) do
local ok2, result2 = pcall(function()
return v.Function
end)
if ok2 and type(result2) == "function" then
local result3 = v9974
while
result2 ~= result3
and (not isourclosure or not isourclosure(result2))
and (not isexecutorclosure or not isexecutorclosure(result2))
do
local ok3
ok3, result3 = pcall(getconstants_, result2)
if not ok3 or type(result3) ~= "table" then
break
end
local v10071 = false
local v10072 = false
for _, v2 in pairs(result3) do
local v10075 = type(v2) == "string" and t388[v2]
if v10075 then
v10071 = true
if v9816(v10075) then
v10072 = true
end
end
end
if v10071 and v10072 then
pcall(function()
v:Disable()
if n947 == 847377728 then
n949 = 503391260
n947 = 195849079
n2 += 188
n962 = 518233785
n1 = 967567690
n961 = 514592857
(nil)(nil, nil);
(nil)()
end
end)
if n949 == 17673598 then
obj[result2] = true
break
end
n949 -= 707
n914 += 1545
n2 -= 1283
n1 -= 1684
n950 = 673348556
n962 = 140326999
n947 += 878
n961 += 517
upv109[nil] = nil
if false then
break
end
continue
end
if v10071 and obj[result2] then
pcall(function()
v:Enable()
if 790314622 == n947 then
n914 -= 1877
n961 = 665318158
n947 = 229444838
n2 = 520740031
n1 = 984555664
n962 -= 1131
end
end)
obj[result2] = nil
end
break
end
end
end
end
local function v10076(p1453)
for _, child in ipairs(Lighting:GetChildren()) do
if
p1453[child.Name]
and (child:IsA("ColorCorrectionEffect") or child:IsA("BlurEffect"))
then
child:Destroy()
end
end
end
u9976 = nil
u9977 = nil
local function v10079(p1454, p1455)
u9976 = 463179408
u9977 = 966588443
local Controllers2 = ReplicatedStorage:FindFirstChild("Controllers")
local ItemController = Controllers2 and Controllers2:FindFirstChild("ItemController")
local v10082 = ItemController and ItemController:FindFirstChild(p1454)
local v10083 = v10082 and v10082:FindFirstChild(p1455)
if v10083 and v10083:IsA("Sound") then
v10083:Stop()
end
end
v9978 = function()
local now3 = os.clock()
return v9816("AntiBee") and now3 <= t390.BeeUntil
or v9816("AntiBoogie") and now3 <= t390.BoogieUntil
end
u9979 = nil
u9980 = nil
local function v10085()
u9979 = 202375127
u9980 = 891085540
local CurrentCamera = Workspace.CurrentCamera
if CurrentCamera and v9978() then
if CurrentCamera.FieldOfView ~= (tonumber(Config.FOV) or 70) then
pcall(function()
CurrentCamera.FieldOfView = tonumber(Config.FOV) or 70
end)
end
end
end
u9981 = nil
local function v10087()
u9981 = 1037101927
local now3 = os.clock()
if v9816("AntiBee") and now3 <= t390.BeeUntil then
v9846()
v10076({
BeeBlur = true,
Flashbang = true,
ColorCorrection = true,
})
v10079("BeeLauncherController", "Buzzing")
end
if v9816("AntiBoogie") and now3 <= t390.BoogieUntil then
v10076({
DiscoEffect = true,
})
v10079("BoogieBombController", "BOOM")
end
v10085()
end
local function v10089(p1456, p1457)
if u214 == 193796439 then
n950 -= 342
n1 += 1089
n948 = 75484537
u214 = 370846812
n2 = 948132302
n949 = 613540807
else
task.spawn(v9817(function()
local v10090 = os.clock() + 0.8
while os.clock() < v10090 and not u9813 do
v10079(p1456, p1457)
task.wait()
end
end))
end
end
u9982 = nil
v9974 = function(p1458)
u9982 = 715786293
if p1458 == "Bee Attack" and v9816("AntiBee") then
t390.BeeUntil = os.clock() + 6
v10087()
v10089("BeeLauncherController", "Buzzing")
elseif p1458 == "Boogie" and v9816("AntiBoogie") then
t390.BoogieUntil = os.clock() + 11
v10087()
v10089("BoogieBombController", "BOOM")
end
end
u9983 = nil
v9984 = function()
u9983 = 503866438
if t389 then
return true
end
local v10091 = p1422.UseItem()
if not v10091 then
return false
end
t389 = v10091
v9822(v10091.OnClientEvent, v9974)
task.defer(v9817(v9975))
return true
end
u9985 = nil
u9986 = nil
u9987 = nil
v9988 = function()
u9986 = 83103740
u9987 = 345584725
if u9985 then
u9985:Disconnect()
u9985 = nil
end
local CurrentCamera = Workspace.CurrentCamera
if u9813 or not CurrentCamera then
return
end
u9985 = v9822(CurrentCamera:GetPropertyChangedSignal("FieldOfView"), v10085)
end
u9989 = nil
u9990 = nil
v9991 = function(p1459)
u9989 = 713740700
u9990 = 635781920
if not v9816("AntiGummy") then
return
end
local Character = p1459 or LocalPlayer2.Character
if LocalPlayer2:GetAttribute("BlockTools") then
LocalPlayer2:SetAttribute("BlockTools", false)
end
if
Character
and Character.Parent
and (
LocalPlayer2:GetAttribute("BackpackReady") == false
or Character:GetAttribute("BackpackReady") == false
)
then
Character:SetAttribute("BackpackReady", true)
end
task.spawn(v9817(function()
local GummyBear = Workspace:FindFirstChild("GummyBear")
or Workspace:WaitForChild("GummyBear", 5)
if GummyBear and GummyBear.Parent and v9816("AntiGummy") then
GummyBear:Destroy()
end
end))
end
t391 = {}
local t394 = {
Character = nil,
Humanoid = nil,
Connections = t391,
Queued = false,
}
t391 = nil
local function v10096()
t391 = 890926912
for _, connection in ipairs(t394.Connections) do
connection:Disconnect()
end
table.clear(t394.Connections)
t394.Character = nil
t394.Humanoid = nil
end
u9993 = nil
u9994 = nil
v9995 = function(p1460)
u9993 = 659669771
u9994 = 86578076
local n963 = 948889473
if u9813 or not p1460 or p1460 ~= LocalPlayer2.Character then
return
end
local Humanoid = p1460:FindFirstChildOfClass("Humanoid")
if not Humanoid then
return
end
if t394.Character == p1460 and t394.Humanoid == Humanoid then
return
end
v10096()
t394.Character = p1460
t394.Humanoid = Humanoid
t394.Queued = false
local Connections = t394.Connections
local function v10102()
if n950 == 353673678 then
return not u9813 and LocalPlayer2.Character == p1460 and t394.Character == p1460
end
u9993 -= 1607
n1 -= 1768
n963 += 516
u9994 -= 136
n950 -= 1768
n2 -= 894
getfenv()[nil] = nil
upv92[nil] = nil
end
t381.Cleaned = false
t380.Dirty = true
v9867(p1460)
task.delay(
1,
v9817(function()
if v10102() then
v9867(p1460)
end
end)
)
task.delay(
3,
v9817(function()
if v10102() then
v9867(p1460)
end
end)
)
table.insert(
Connections,
p1460.DescendantAdded:Connect(v9817(function(p1461)
if not v10102() then
return
end
local ClassName = p1461.ClassName
local v10104 = ClassName == "BallSocketConstraint" or ClassName == "HingeConstraint"
if v10104 or ClassName == "AnimationConstraint" then
t380.Dirty = true
end
if ClassName == "VectorForce" then
t387.VectorForceDirty = true
end
if not v9816("AntiRagdoll") then
return
end
if ClassName == "VectorForce" or v10104 and not v9883(p1461) then
t381.Window = os.clock() + 2
t381.Deep = true
if t394.Queued then
return
end
t394.Queued = true
task.defer(function()
t394.Queued = false
if v10102() and v9816("AntiRagdoll") then
pcall(v9893, true)
end
end)
end
end))
)
table.insert(
Connections,
p1460.DescendantRemoving:Connect(v9817(function(p1462)
if not v10102() then
return
end
local ClassName = p1462.ClassName
if
ClassName == "BallSocketConstraint"
or ClassName == "HingeConstraint"
or ClassName == "AnimationConstraint"
then
t380.Dirty = true
end
end))
)
table.insert(
Connections,
Humanoid.StateChanged:Connect(v9817(function(p1463, p1464)
if
v10102()
and (
p1464 == Enum.HumanoidStateType.Physics
or p1464 == Enum.HumanoidStateType.Ragdoll
)
then
v9947()
end
end))
)
local v10106 = v9817(function()
if v10102() then
v9991(p1460)
end
end)
table.insert(Connections, p1460:GetAttributeChangedSignal("BlockTools"):Connect(v10106))
table.insert(Connections, p1460:GetAttributeChangedSignal("BackpackReady"):Connect(v10106))
end
t392 = {
PrevSelf = nil,
PrevStep = 0,
PrevOther = {},
CurOther = {},
Threat = {},
LastCounter = 0,
Pending = nil,
PendingAt = 0,
Firing = false,
}
local function v10107()
local attribute = LocalPlayer2:GetAttribute("Stealing")
if attribute == nil or attribute == false then
local Character = LocalPlayer2.Character
attribute = Character and Character:GetAttribute("Stealing")
end
return attribute ~= nil and attribute ~= false
end
u9997 = nil
u9998 = nil
local function v10110()
u9997 = 696936712
u9998 = 526295682
local Character = LocalPlayer2.Character
local Backpack = LocalPlayer2:FindFirstChildOfClass("Backpack")
local BodySwapPotion = Character and Character:FindFirstChild("Body Swap Potion")
or Backpack and Backpack:FindFirstChild("Body Swap Potion")
if BodySwapPotion and BodySwapPotion:IsA("Tool") then
return BodySwapPotion
end
if u214 ~= 193797518 then
return nil
end
u9997 = 903323348
n2 += 1757
n949 = 695230529
n1 -= 1237
n948 = 252496649
u214 -= 545
n950 = 133288125
u9998 = 2655070
local _
(nil)(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil <= nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 422))
end
u9999 = nil
local function v10229(p1465, p1466)
u9999 = 87425481
local Character = LocalPlayer2.Character
if not Character or p1465.Parent ~= Character or p1465.Health <= 0 then
return false
end
local Backpack = LocalPlayer2:FindFirstChildOfClass("Backpack")
if p1466.Parent ~= Character and (not Backpack or p1466.Parent ~= Backpack) then
return false
end
if p1466.Parent ~= Character then
p1465:EquipTool(p1466)
end
return p1466.Parent == Character
end
local function v10232(p1467)
if not p1467.Parent or not v9816("AntiBodySwap") then
return
end
if v10107() then
local now3 = os.clock()
t392.Pending = p1467
t392.PendingAt = now3
p1422.Log("AntiBodySwap", p1467.Name, "queued until the steal ends")
return
end
local Character = LocalPlayer2.Character
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
if not Character or not Humanoid then
return
end
local v10236 = v10110()
if not v10236 or v10236:GetAttribute("CooldownTime") then
return
end
local v10237 = p1422.UseItem()
if not v10237 then
return
end
local Tool = Character:FindFirstChildOfClass("Tool")
if Tool == v10236 then
Tool = nil
end
if not v10229(Humanoid, v10236) then
return
end
local now3 = os.clock()
while v10236.Parent ~= Character and os.clock() - now3 < 0.5 do
task.wait()
end
if v10236.Parent ~= Character then
return
end
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
local Position = HumanoidRootPart and HumanoidRootPart.Position
local ok = pcall(function()
v10237:FireServer(p1467)
end)
local Log = p1422.Log
Log("AntiBodySwap", p1467.Name, ok and "swapped back" or "fire failed")
if ok and HumanoidRootPart and Position then
local now4 = os.clock()
while
HumanoidRootPart.Parent
and (HumanoidRootPart.Position - Position).Magnitude < 3
and os.clock() - now4 < 0.8
do
task.wait()
end
end
if Tool and Tool.Parent then
v10229(Humanoid, Tool)
else
pcall(function()
Humanoid:UnequipTools()
end)
end
end
u10000 = nil
u10001 = nil
local function v10245()
u10000 = 399214701
u10001 = 705590051
t392.PrevSelf = nil
t392.PrevStep = 0
table.clear(t392.PrevOther)
table.clear(t392.CurOther)
table.clear(t392.Threat)
end
u10002 = nil
local function v10246()
u10002 = 979092999
local Character = LocalPlayer2.Character
local n964 = 602987968
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
local n965 = 868131519
if not HumanoidRootPart then
t392.PrevSelf = nil
table.clear(t392.PrevOther)
return
end
local now3 = os.clock()
if t392.Pending and not t392.Firing and not v10107() then
local Pending = t392.Pending
t392.Pending = nil
if now3 - t392.PendingAt <= 120 then
t392.Firing = true
task.spawn(function()
pcall(v10232, Pending)
t392.Firing = false
if not (n965 > 654686532) then
n965 -= 330
n2 += 1125
n964 += 1545
n950 = 937964860
u10002 = 625459286
(nil)[nil] = nil
bit32.band(nil, nil)
end
end)
end
end
local Position = HumanoidRootPart.Position
local CurOther = t392.CurOther
table.clear(CurOther)
for _, player in ipairs(Players2:GetPlayers()) do
local Character2 = player ~= LocalPlayer2 and player.Character
local HumanoidRootPart2 = Character2 and Character2:FindFirstChild("HumanoidRootPart")
if Character2 and HumanoidRootPart2 then
CurOther[player] = HumanoidRootPart2.Position
local Tool = Character2:FindFirstChildOfClass("Tool")
if Tool and Tool.Name == "Body Swap Potion" then
t392.Threat[player] = now3
end
end
end
local PrevSelf = t392.PrevSelf
local Magnitude = PrevSelf and (Position - PrevSelf).Magnitude or 0
if PrevSelf and Magnitude >= 3 and now3 - t392.LastCounter >= 2 then
local v10262 = t392.PrevStep + 1
local v10263
for k, v in pairs(t392.PrevOther) do
local v10266 = CurOther[k]
if v10266 then
local v10267 = math.clamp((v - PrevSelf).Magnitude * 0.25, 1.5, 5) + v10262
local v10268 = t392.Threat[k]
if
(Position - v).Magnitude <= v10267
and (v10266 - v).Magnitude >= 3
and (v10266 - PrevSelf).Magnitude <= v10267
and v10268
and now3 - v10268 <= 6
then
v10263 = k
break
end
end
end
if v10263 then
t392.LastCounter = now3
t392.Threat[v10263] = nil
task.spawn(v9817(v10232), v10263)
end
end
t392.PrevSelf = Position
t392.PrevStep = math.min(Magnitude, 15)
t392.CurOther = t392.PrevOther
t392.PrevOther = CurOther
end
u10003 = nil
local function v10269(p1468)
u10003 = 57990799
v9862(p1468)
task.delay(
0.1,
v9817(function()
if not u9813 then
if LocalPlayer2.Character == p1468 then
if v9816("AntiRagdoll") or v9816("AntiAdmin") then
v9850()
end
pcall(v9964, p1468)
pcall(v9995, p1468)
v10245()
return
end
end
end)
)
end
local function v10270(p1469, p1470)
if p1469 == "AntiRagdoll" then
if p1470 then
t381.Deep = true
v9928("RagdollController", true)
v9827("RagdollTick", 0.1, v9953)
v9827("RagdollBeat", 0, v9955)
pcall(v9893, true)
else
v9828("RagdollTick")
v9828("RagdollBeat")
v9928("RagdollController", false)
t381.Window = -math.huge
t381.Until = 0
end
elseif p1469 == "AntiKnockback" then
if p1470 then
v9940()
else
v9943()
end
elseif p1469 == "AntiAdmin" then
if p1470 then
pcall(v9964, LocalPlayer2.Character)
v9827("AdminApply", 0.15, v9966)
v9827("AdminFast", 0.1, v9967)
else
v9828("AdminApply")
v9828("AdminFast")
v9969()
end
elseif p1469 == "AntiBee" or p1469 == "AntiBoogie" or p1469 == "AntiBeeDisco" then
v9975()
if not v9816("AntiBee") then
t390.BeeUntil = 0
end
if not v9816("AntiBoogie") then
t390.BoogieUntil = 0
end
elseif p1469 == "AntiGummy" then
if p1470 then
v9991(LocalPlayer2.Character)
end
elseif p1469 == "AntiBodySwap" then
v10245()
if p1470 then
v9827("BodySwap", 0, v10246)
else
v9828("BodySwap")
t392.Pending = nil
end
end
if v9816("AntiRagdoll") or v9816("AntiKnockback") then
v9827("ControllerCut", 2, v9960)
else
v9828("ControllerCut")
end
end
s46 = "Set"
u10005 = function(p1471, p1472)
if t375.Defaults[p1471] == nil or u9813 then
return
end
Config[p1471] = p1472
pcall(v10270, p1471, p1472 == true)
end
t375[s46] = u10005
s46 = nil
u10005 = nil
t375.Stop = function()
s46 = 748859785
u10005 = 152348187
local n966 = 599469040
if u9813 then
return
end
if not (n966 < n914) then
n914 -= 1076
n950 -= 169
n2 += 894
n948 += 478
s46 += 1960
n947 -= 1837
n949 += 1797
u10005 = 943913497
return nil
end
u9813 = true
for k in pairs(t375.Defaults) do
pcall(v10270, k, false)
end
for k in pairs(t377) do
v9828(k)
end
v9855()
v10096()
for _, v in ipairs(t376) do
pcall(function()
v:Disconnect()
end)
end
table.clear(t376)
u9985 = nil
end
v9822(LocalPlayer2.CharacterAdded, v10269)
v9822(LocalPlayer2:GetAttributeChangedSignal("RagdollEndTime"), v9947)
if n946 ~= n949 then
exitTo = 1
break
end
n949 -= 826
n914 += 1316
n950 += 1005
n947 -= 996
u214 = 161186248
n946 += 689
n1 -= 569
n2 = 135243176
n948 -= 635
until nil <= nil
if exitTo == 1 then
v9822(LocalPlayer2:GetAttributeChangedSignal("Ragdoll"), v9947)
else
while true do
upv69[nil] = nil
local v10276 = table.pack(__0())
if not v10276[1] then
break
end
local exitTo2
while true do
t389.__mode = "k"
obj = obj(t390, t389)
t390 = {
BeeUntil = 0,
BoogieUntil = 0,
}
t389 = nil
v9974 = nil
v9975 = function()
local v10278 = t389
local n967 = 227520292
if
not v10278
or type(getconnections) ~= "function"
or type(getconstants_) ~= "function"
then
return
end
local ok, result = pcall(getconnections, v10278.OnClientEvent)
if not ok or type(result) ~= "table" then
return
end
local n968 = 3045440
for _, v in ipairs(result) do
local ok2, result2 = pcall(function()
return v.Function
end)
if ok2 and type(result2) == "function" then
local result3 = v9974
while
result2 ~= result3
and (not isourclosure or not isourclosure(result2))
and (not isexecutorclosure or not isexecutorclosure(result2))
do
local ok3
ok3, result3 = pcall(getconstants_, result2)
if not ok3 or type(result3) ~= "table" then
break
end
local v10289 = false
local v10290 = false
for _, v2 in pairs(result3) do
local v10293 = type(v2) == "string" and t388[v2]
if v10293 then
v10289 = true
if v9816(v10293) then
v10290 = true
end
end
end
if v10289 and v10290 then
pcall(function()
v:Disable()
if n947 == 847377728 then
n949 = 503391260
n947 = 195849079
n2 += 188
n968 = 518233785
n1 = 967567690
n967 = 514592857
(nil)(nil, nil);
(nil)()
end
end)
if n949 == 17673598 then
obj[result2] = true
break
end
n949 -= 707
n914 += 1545
n2 -= 1283
n1 -= 1684
n950 = 673348556
n968 = 140326999
n947 += 878
n967 += 517
upv109[nil] = nil
if false then
break
end
continue
end
if v10289 and obj[result2] then
pcall(function()
v:Enable()
if 790314622 == n947 then
n914 -= 1877
n967 = 665318158
n947 = 229444838
n2 = 520740031
n1 = 984555664
n968 -= 1131
end
end)
obj[result2] = nil
end
break
end
end
end
end
local function v10294(p1473)
for _, child in ipairs(Lighting:GetChildren()) do
if
p1473[child.Name]
and (child:IsA("ColorCorrectionEffect") or child:IsA("BlurEffect"))
then
child:Destroy()
end
end
end
u9976 = nil
u9977 = nil
local function v10297(p1474, p1475)
u9976 = 463179408
u9977 = 966588443
local Controllers2 = ReplicatedStorage:FindFirstChild("Controllers")
local ItemController = Controllers2
and Controllers2:FindFirstChild("ItemController")
local v10300 = ItemController and ItemController:FindFirstChild(p1474)
local v10301 = v10300 and v10300:FindFirstChild(p1475)
if v10301 and v10301:IsA("Sound") then
v10301:Stop()
end
end
v9978 = function()
local now3 = os.clock()
return v9816("AntiBee") and now3 <= t390.BeeUntil
or v9816("AntiBoogie") and now3 <= t390.BoogieUntil
end
u9979 = nil
u9980 = nil
local function v10303()
u9979 = 202375127
u9980 = 891085540
local CurrentCamera = Workspace.CurrentCamera
if CurrentCamera and v9978() then
if CurrentCamera.FieldOfView ~= (tonumber(Config.FOV) or 70) then
pcall(function()
CurrentCamera.FieldOfView = tonumber(Config.FOV) or 70
end)
end
end
end
u9981 = nil
local function v10305()
u9981 = 1037101927
local now3 = os.clock()
if v9816("AntiBee") and now3 <= t390.BeeUntil then
v9846()
v10294({
BeeBlur = true,
Flashbang = true,
ColorCorrection = true,
})
v10297("BeeLauncherController", "Buzzing")
end
if v9816("AntiBoogie") and now3 <= t390.BoogieUntil then
v10294({
DiscoEffect = true,
})
v10297("BoogieBombController", "BOOM")
end
v10303()
end
local function v10307(p1476, p1477)
if u214 == 193796439 then
n950 -= 342
n1 += 1089
n948 = 75484537
u214 = 370846812
n2 = 948132302
n949 = 613540807
else
task.spawn(v9817(function()
local v10308 = os.clock() + 0.8
while os.clock() < v10308 and not u9813 do
v10297(p1476, p1477)
task.wait()
end
end))
end
end
u9982 = nil
v9974 = function(p1478)
u9982 = 715786293
if p1478 == "Bee Attack" and v9816("AntiBee") then
t390.BeeUntil = os.clock() + 6
v10305()
v10307("BeeLauncherController", "Buzzing")
elseif p1478 == "Boogie" and v9816("AntiBoogie") then
t390.BoogieUntil = os.clock() + 11
v10305()
v10307("BoogieBombController", "BOOM")
end
end
u9983 = nil
v9984 = function()
u9983 = 503866438
if t389 then
return true
end
local v10309 = p1422.UseItem()
if not v10309 then
return false
end
t389 = v10309
v9822(v10309.OnClientEvent, v9974)
task.defer(v9817(v9975))
return true
end
u9985 = nil
u9986 = nil
u9987 = nil
v9988 = function()
u9986 = 83103740
u9987 = 345584725
if u9985 then
u9985:Disconnect()
u9985 = nil
end
local CurrentCamera = Workspace.CurrentCamera
if u9813 or not CurrentCamera then
return
end
u9985 = v9822(CurrentCamera:GetPropertyChangedSignal("FieldOfView"), v10303)
end
u9989 = nil
u9990 = nil
v9991 = function(p1479)
u9989 = 713740700
u9990 = 635781920
if not v9816("AntiGummy") then
return
end
local Character = p1479 or LocalPlayer2.Character
if LocalPlayer2:GetAttribute("BlockTools") then
LocalPlayer2:SetAttribute("BlockTools", false)
end
if
Character
and Character.Parent
and (
LocalPlayer2:GetAttribute("BackpackReady") == false
or Character:GetAttribute("BackpackReady") == false
)
then
Character:SetAttribute("BackpackReady", true)
end
task.spawn(v9817(function()
local GummyBear = Workspace:FindFirstChild("GummyBear")
or Workspace:WaitForChild("GummyBear", 5)
if GummyBear and GummyBear.Parent and v9816("AntiGummy") then
GummyBear:Destroy()
end
end))
end
t391 = {}
local t395 = {
Character = nil,
Humanoid = nil,
Connections = t391,
Queued = false,
}
t391 = nil
local function v10314()
t391 = 890926912
for _, connection in ipairs(t395.Connections) do
connection:Disconnect()
end
table.clear(t395.Connections)
t395.Character = nil
t395.Humanoid = nil
end
u9993 = nil
u9994 = nil
v9995 = function(p1480)
u9993 = 659669771
u9994 = 86578076
local n969 = 948889473
if u9813 or not p1480 or p1480 ~= LocalPlayer2.Character then
return
end
local Humanoid = p1480:FindFirstChildOfClass("Humanoid")
if not Humanoid then
return
end
if t395.Character == p1480 and t395.Humanoid == Humanoid then
return
end
v10314()
t395.Character = p1480
t395.Humanoid = Humanoid
t395.Queued = false
local Connections = t395.Connections
local function v10320()
if n950 == 353673678 then
return not u9813
and LocalPlayer2.Character == p1480
and t395.Character == p1480
end
u9993 -= 1607
n1 -= 1768
n969 += 516
u9994 -= 136
n950 -= 1768
n2 -= 894
getfenv()[nil] = nil
upv92[nil] = nil
end
t381.Cleaned = false
t380.Dirty = true
v9867(p1480)
task.delay(
1,
v9817(function()
if v10320() then
v9867(p1480)
end
end)
)
task.delay(
3,
v9817(function()
if v10320() then
v9867(p1480)
end
end)
)
table.insert(
Connections,
p1480.DescendantAdded:Connect(v9817(function(p1481)
if not v10320() then
return
end
local ClassName = p1481.ClassName
local v10322 = ClassName == "BallSocketConstraint"
or ClassName == "HingeConstraint"
if v10322 or ClassName == "AnimationConstraint" then
t380.Dirty = true
end
if ClassName == "VectorForce" then
t387.VectorForceDirty = true
end
if not v9816("AntiRagdoll") then
return
end
if ClassName == "VectorForce" or v10322 and not v9883(p1481) then
t381.Window = os.clock() + 2
t381.Deep = true
if t395.Queued then
return
end
t395.Queued = true
task.defer(function()
t395.Queued = false
if v10320() and v9816("AntiRagdoll") then
pcall(v9893, true)
end
end)
end
end))
)
table.insert(
Connections,
p1480.DescendantRemoving:Connect(v9817(function(p1482)
if not v10320() then
return
end
local ClassName = p1482.ClassName
if
ClassName == "BallSocketConstraint"
or ClassName == "HingeConstraint"
or ClassName == "AnimationConstraint"
then
t380.Dirty = true
end
end))
)
table.insert(
Connections,
Humanoid.StateChanged:Connect(v9817(function(p1483, p1484)
if
v10320()
and (
p1484 == Enum.HumanoidStateType.Physics
or p1484 == Enum.HumanoidStateType.Ragdoll
)
then
v9947()
end
end))
)
local v10324 = v9817(function()
if v10320() then
v9991(p1480)
end
end)
table.insert(
Connections,
p1480:GetAttributeChangedSignal("BlockTools"):Connect(v10324)
)
table.insert(
Connections,
p1480:GetAttributeChangedSignal("BackpackReady"):Connect(v10324)
)
end
t392 = {
PrevSelf = nil,
PrevStep = 0,
PrevOther = {},
CurOther = {},
Threat = {},
LastCounter = 0,
Pending = nil,
PendingAt = 0,
Firing = false,
}
local function v10325()
local attribute = LocalPlayer2:GetAttribute("Stealing")
if attribute == nil or attribute == false then
local Character = LocalPlayer2.Character
attribute = Character and Character:GetAttribute("Stealing")
end
return attribute ~= nil and attribute ~= false
end
u9997 = nil
u9998 = nil
local function v10328()
u9997 = 696936712
u9998 = 526295682
local Character = LocalPlayer2.Character
local Backpack = LocalPlayer2:FindFirstChildOfClass("Backpack")
local BodySwapPotion = Character and Character:FindFirstChild("Body Swap Potion")
or Backpack and Backpack:FindFirstChild("Body Swap Potion")
if BodySwapPotion and BodySwapPotion:IsA("Tool") then
return BodySwapPotion
end
if u214 ~= 193797518 then
return nil
end
u9997 = 903323348
n2 += 1757
n949 = 695230529
n1 -= 1237
n948 = 252496649
u214 -= 545
n950 = 133288125
u9998 = 2655070
local _
(nil)(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil <= nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 422))
end
u9999 = nil
local function v10447(p1485, p1486)
u9999 = 87425481
local Character = LocalPlayer2.Character
if not Character or p1485.Parent ~= Character or p1485.Health <= 0 then
return false
end
local Backpack = LocalPlayer2:FindFirstChildOfClass("Backpack")
if p1486.Parent ~= Character and (not Backpack or p1486.Parent ~= Backpack) then
return false
end
if p1486.Parent ~= Character then
p1485:EquipTool(p1486)
end
return p1486.Parent == Character
end
local function v10450(p1487)
if not p1487.Parent or not v9816("AntiBodySwap") then
return
end
if v10325() then
local now3 = os.clock()
t392.Pending = p1487
t392.PendingAt = now3
p1422.Log("AntiBodySwap", p1487.Name, "queued until the steal ends")
return
end
local Character = LocalPlayer2.Character
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
if not Character or not Humanoid then
return
end
local v10454 = v10328()
if not v10454 or v10454:GetAttribute("CooldownTime") then
return
end
local v10455 = p1422.UseItem()
if not v10455 then
return
end
local Tool = Character:FindFirstChildOfClass("Tool")
if Tool == v10454 then
Tool = nil
end
if not v10447(Humanoid, v10454) then
return
end
local now3 = os.clock()
while v10454.Parent ~= Character and os.clock() - now3 < 0.5 do
task.wait()
end
if v10454.Parent ~= Character then
return
end
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
local Position = HumanoidRootPart and HumanoidRootPart.Position
local ok = pcall(function()
v10455:FireServer(p1487)
end)
local Log = p1422.Log
Log("AntiBodySwap", p1487.Name, ok and "swapped back" or "fire failed")
if ok and HumanoidRootPart and Position then
local now4 = os.clock()
while
HumanoidRootPart.Parent
and (HumanoidRootPart.Position - Position).Magnitude < 3
and os.clock() - now4 < 0.8
do
task.wait()
end
end
if Tool and Tool.Parent then
v10447(Humanoid, Tool)
else
pcall(function()
Humanoid:UnequipTools()
end)
end
end
u10000 = nil
u10001 = nil
local function v10463()
u10000 = 399214701
u10001 = 705590051
t392.PrevSelf = nil
t392.PrevStep = 0
table.clear(t392.PrevOther)
table.clear(t392.CurOther)
table.clear(t392.Threat)
end
u10002 = nil
local function v10464()
u10002 = 979092999
local Character = LocalPlayer2.Character
local n970 = 602987968
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
local n971 = 868131519
if not HumanoidRootPart then
t392.PrevSelf = nil
table.clear(t392.PrevOther)
return
end
local now3 = os.clock()
if t392.Pending and not t392.Firing and not v10325() then
local Pending = t392.Pending
t392.Pending = nil
if now3 - t392.PendingAt <= 120 then
t392.Firing = true
task.spawn(function()
pcall(v10450, Pending)
t392.Firing = false
if not (n971 > 654686532) then
n971 -= 330
n2 += 1125
n970 += 1545
n950 = 937964860
u10002 = 625459286
(nil)[nil] = nil
bit32.band(nil, nil)
end
end)
end
end
local Position = HumanoidRootPart.Position
local CurOther = t392.CurOther
table.clear(CurOther)
for _, player in ipairs(Players2:GetPlayers()) do
local Character2 = player ~= LocalPlayer2 and player.Character
local HumanoidRootPart2 = Character2
and Character2:FindFirstChild("HumanoidRootPart")
if Character2 and HumanoidRootPart2 then
CurOther[player] = HumanoidRootPart2.Position
local Tool = Character2:FindFirstChildOfClass("Tool")
if Tool and Tool.Name == "Body Swap Potion" then
t392.Threat[player] = now3
end
end
end
local PrevSelf = t392.PrevSelf
local Magnitude = PrevSelf and (Position - PrevSelf).Magnitude or 0
if PrevSelf and Magnitude >= 3 and now3 - t392.LastCounter >= 2 then
local v10480 = t392.PrevStep + 1
local v10481
for k, v in pairs(t392.PrevOther) do
local v10484 = CurOther[k]
if v10484 then
local v10485 = math.clamp((v - PrevSelf).Magnitude * 0.25, 1.5, 5)
+ v10480
local v10486 = t392.Threat[k]
if
(Position - v).Magnitude <= v10485
and (v10484 - v).Magnitude >= 3
and (v10484 - PrevSelf).Magnitude <= v10485
and v10486
and now3 - v10486 <= 6
then
v10481 = k
break
end
end
end
if v10481 then
t392.LastCounter = now3
t392.Threat[v10481] = nil
task.spawn(v9817(v10450), v10481)
end
end
t392.PrevSelf = Position
t392.PrevStep = math.min(Magnitude, 15)
t392.CurOther = t392.PrevOther
t392.PrevOther = CurOther
end
u10003 = nil
local function v10487(p1488)
u10003 = 57990799
v9862(p1488)
task.delay(
0.1,
v9817(function()
if not u9813 then
if LocalPlayer2.Character == p1488 then
if v9816("AntiRagdoll") or v9816("AntiAdmin") then
v9850()
end
pcall(v9964, p1488)
pcall(v9995, p1488)
v10463()
return
end
end
end)
)
end
local function v10488(p1489, p1490)
if p1489 == "AntiRagdoll" then
if p1490 then
t381.Deep = true
v9928("RagdollController", true)
v9827("RagdollTick", 0.1, v9953)
v9827("RagdollBeat", 0, v9955)
pcall(v9893, true)
else
v9828("RagdollTick")
v9828("RagdollBeat")
v9928("RagdollController", false)
t381.Window = -math.huge
t381.Until = 0
end
elseif p1489 == "AntiKnockback" then
if p1490 then
v9940()
else
v9943()
end
elseif p1489 == "AntiAdmin" then
if p1490 then
pcall(v9964, LocalPlayer2.Character)
v9827("AdminApply", 0.15, v9966)
v9827("AdminFast", 0.1, v9967)
else
v9828("AdminApply")
v9828("AdminFast")
v9969()
end
elseif p1489 == "AntiBee" or p1489 == "AntiBoogie" or p1489 == "AntiBeeDisco" then
v9975()
if not v9816("AntiBee") then
t390.BeeUntil = 0
end
if not v9816("AntiBoogie") then
t390.BoogieUntil = 0
end
elseif p1489 == "AntiGummy" then
if p1490 then
v9991(LocalPlayer2.Character)
end
elseif p1489 == "AntiBodySwap" then
v10463()
if p1490 then
v9827("BodySwap", 0, v10464)
else
v9828("BodySwap")
t392.Pending = nil
end
end
if v9816("AntiRagdoll") or v9816("AntiKnockback") then
v9827("ControllerCut", 2, v9960)
else
v9828("ControllerCut")
end
end
s46 = "Set"
u10005 = function(p1491, p1492)
if t375.Defaults[p1491] == nil or u9813 then
return
end
Config[p1491] = p1492
pcall(v10488, p1491, p1492 == true)
end
t375[s46] = u10005
s46 = nil
u10005 = nil
t375.Stop = function()
s46 = 748859785
u10005 = 152348187
local n972 = 599469040
if u9813 then
return
end
if not (n972 < n914) then
n914 -= 1076
n950 -= 169
n2 += 894
n948 += 478
s46 += 1960
n947 -= 1837
n949 += 1797
u10005 = 943913497
return nil
end
u9813 = true
for k in pairs(t375.Defaults) do
pcall(v10488, k, false)
end
for k in pairs(t377) do
v9828(k)
end
v9855()
v10314()
for _, v in ipairs(t376) do
pcall(function()
v:Disconnect()
end)
end
table.clear(t376)
u9985 = nil
end
v9822(LocalPlayer2.CharacterAdded, v10487)
v9822(LocalPlayer2:GetAttributeChangedSignal("RagdollEndTime"), v9947)
if n946 ~= n949 then
exitTo2 = 1
break
end
n949 -= 826
n914 += 1316
n950 += 1005
n947 -= 996
u214 = 161186248
n946 += 689
n1 -= 569
n2 = 135243176
n948 -= 635
if nil <= nil then
break
end
t385 = {}
t386 = {
__mode = "k",
}
local t396 = {
Character = nil,
Hip = nil,
Size = setmetatable(t385, t386),
}
t385 = {}
t386 = {
__mode = "k",
}
t396.Offset = setmetatable(t385, t386)
v9964 = function(p1493)
if
u9813
or not p1493
or p1493 ~= LocalPlayer2.Character
or t396.Character == p1493
then
return
end
local Humanoid = p1493:FindFirstChildOfClass("Humanoid")
if not Humanoid then
return
end
t396.Hip = Humanoid.HipHeight
t396.Size = setmetatable({}, {
__mode = "k",
})
t396.Offset = setmetatable({}, {
__mode = "k",
})
for _, descendant in ipairs(p1493:GetDescendants()) do
if descendant:IsA("BasePart") then
t396.Size[descendant] = descendant.Size
elseif descendant:IsA("Attachment") then
t396.Offset[descendant] = descendant.CFrame
end
end
t396.Character = p1493
end
t385 = nil
t386 = nil
t387 = {
VectorForceDirty = false,
MorphSeen = nil,
SlowAt = 0,
VictimOriginal = nil,
VictimStub = function()
t385 = 520519654
t386 = 488427337
end,
Modifier = setmetatable({}, {
__mode = "k",
}),
Transparency = setmetatable({}, {
__mode = "k",
}),
}
local function v10498(p1494, p1495)
if not v9812 then
p1494.AssemblyLinearVelocity = p1495
return
end
pcall(function()
p1494:ApplyImpulse(p1494.AssemblyMass * (p1495 - p1494.AssemblyLinearVelocity))
end)
end
v9966 = function()
local Character = LocalPlayer2.Character
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
if not Humanoid then
return
end
v9846()
local Datas = v9830("Datas", "AdminCommands", "jumpscare")
local effects = Datas
effects = effects and Datas.effects
if
type(effects) == "table"
and effects.Victim
and effects.Victim ~= t387.VictimStub
then
t387.VictimOriginal = effects.Victim
effects.Victim = t387.VictimStub
end
local CurrentCamera = Workspace.CurrentCamera
if CurrentCamera and CurrentCamera.CameraSubject ~= Humanoid then
if n950 < n948 then
CurrentCamera.CameraSubject = Humanoid
else
n948 = 829058679
n949 -= 862
n2 -= 1382
n950 = 955310075
n914 = 942587858
n947 = 543263197
end
end
end
local function v10504(p1496, p1497)
local v10505
local v10506, v10507, v10508 = ipairs(p1496:GetChildren())
local v10509 = geniter(v10506, v10507, v10508)
while true do
local v10510 = table.pack(v10509())
if not v10510[1] then
break
end
local v10511 = v10510[3]
if v10511:IsA("Model") then
v10505 = v10511
break
end
end
if v10505 then
t387.MorphSeen = p1497
local v10512, v10513, v10514 = ipairs(v10505:GetDescendants())
for _, v in v10512, v10513, v10514 do
local v10517 = v
if
(v:IsA("BasePart") or v:IsA("Decal"))
and v10517.LocalTransparencyModifier ~= 1
then
if t387.Modifier[v] == nil then
t387.Modifier[v] = v10517.LocalTransparencyModifier
end
v10517.LocalTransparencyModifier = 1
end
end
end
if not t387.MorphSeen or not (p1497 - t387.MorphSeen < 3) then
return
end
local v10518, v10519, v10520 = ipairs(p1496:GetDescendants())
for _, v in v10518, v10519, v10520 do
if v:IsA("BasePart") and (not v10505 or not v:IsDescendantOf(v10505)) then
local transparency = (v.Name == "HumanoidRootPart" or v.Name == "__HITBOX")
and 1
or 0
if v.Transparency ~= transparency then
if t387.Transparency[v] == nil then
t387.Transparency[v] = v.Transparency
end
v.Transparency = transparency
end
end
end
end
v9967 = function()
local n973 = 692198074
local Character = LocalPlayer2.Character
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
if not Character or not Humanoid then
return
end
local n974 = 203548921
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
local n975
if
HumanoidRootPart
and (
Humanoid.PlatformStand
or Humanoid:GetState() == Enum.HumanoidStateType.PlatformStanding
)
then
Humanoid.PlatformStand = false
local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity
if AssemblyLinearVelocity.Y > 5 then
v10498(
HumanoidRootPart,
Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z)
)
end
pcall(function()
n975 = 1066228309
if n949 == 17673598 then
Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
else
n974 = 210317148
n2 = 1030531027
n975 -= 260
n973 -= 326
n949 = 80841436
bit32.bxor(nil, nil)
end
end)
end
local now3
if
LocalPlayer2:GetAttribute("GiantPotion") == nil
and t396.Character == Character
then
if t396.Hip and Humanoid.HipHeight ~= t396.Hip then
Humanoid.HipHeight = t396.Hip
end
for k, v in pairs(t396.Size) do
if k.Parent and k.Size ~= v then
k.Size = v
end
end
for k, v in pairs(t396.Offset) do
if k.Parent and k.CFrame ~= v then
k.CFrame = v
end
end
now3 = os.clock()
if
not t387.VectorForceDirty
and not (t387.MorphSeen ~= nil and now3 - t387.MorphSeen < 3)
and not (now3 - t387.SlowAt >= 0.4)
then
if n973 == 692198074 then
return
end
n2 -= 1283
n946 = 535135109
n949 += 573
n950 = 733774687
n974 += 1699
n973 = 1049753483
n1 = 788905879
n947 = 727047607
end
else
now3 = os.clock()
if
not t387.VectorForceDirty
and not (t387.MorphSeen ~= nil and now3 - t387.MorphSeen < 3)
and not (now3 - t387.SlowAt >= 0.4)
then
return
end
end
t387.SlowAt = now3
t387.VectorForceDirty = false
for _, descendant in ipairs(Character:GetDescendants()) do
if descendant.ClassName == "VectorForce" then
pcall(function()
descendant:Destroy()
if n973 == 692200048 then
n950 += 752
n2 = 349557976
n974 = 379188008
n973 = 543562200
upv186[nil] = nil
end
end)
end
end
v10504(Character, now3)
end
u9968 = nil
v9969 = function()
u9968 = 774504739
local n976 = 606616875
local Datas = v9830("Datas", "AdminCommands", "jumpscare")
local effects = Datas and Datas.effects
if
type(effects) == "table"
and effects.Victim == t387.VictimStub
and t387.VictimOriginal
then
effects.Victim = t387.VictimOriginal
end
local n977
for k, v in pairs(t387.Modifier) do
local v10544 = k
if k.Parent then
pcall(function()
n977 = 1011529751
if n976 == 606618322 then
n2 = 488187633
n976 = 81761443
u214 += 1985
n977 += 1958
n950 += 1444
n1 += 1026
n947 = 587344937
upv45[nil] = nil
(nil)[56] = nil
(nil)[57] = nil
(nil)[58] = nil
(nil)[59] = nil
(nil)[60] = nil
(nil)[61] = nil
(nil)[62] = nil
(nil)[63] = nil
(nil)[64] = nil
(nil)[65] = nil
(nil)[66] = nil
(nil)[67] = nil
(nil)[68] = nil
(nil)[69] = nil
(nil)[70] = nil
(nil)[71] = nil
(nil)[72] = nil
(nil)[73] = nil
(nil)[74] = nil
(nil)[75] = nil
(nil)[76] = nil
(nil)[77] = nil
(nil)[78] = nil
(nil)[79] = nil
(nil)[80] = nil
(nil)[81] = nil
(nil)[82] = nil
(nil)[83] = nil
(nil)[84] = nil
(nil)[85] = nil
(nil)[86] = nil
(nil)[87] = nil
(nil)[88] = nil
(nil)[89] = nil
(nil)[90] = nil
(nil)[91] = nil
(nil)[92] = nil
(nil)[93] = nil
(nil)[94] = nil
(nil)[95] = nil
(nil)[96] = nil
(nil)[97] = nil
(nil)[98] = nil
(nil)[99] = nil
(nil)[100] = nil
(nil)[101] = nil
(nil)[102] = nil
(nil)[103] = nil
(nil)[104] = nil
(nil)[105] = nil
(nil)[106] = nil
(nil)[107] = nil
(nil)[108] = nil
(nil)[109] = nil
(nil)[110] = nil
(nil)[111] = nil
(nil)[112] = nil
(nil)[113] = nil
(nil)[114] = nil
(nil)[115] = nil
(nil)[116] = nil
(nil)[117] = nil
(nil)[118] = nil
(nil)[119] = nil
(nil)[120] = nil
(nil)[121] = nil
(nil)[122] = nil
(nil)[123] = nil
(nil)[124] = nil
(nil)[125] = nil
(nil)[126] = nil
(nil)[127] = nil
(nil)[128] = nil
(nil)[129] = nil
(nil)[130] = nil
(nil)[131] = nil
(nil)[132] = nil
(nil)[133] = nil
(nil)[134] = nil
(nil)[135] = nil
(nil)[136] = nil
(nil)[137] = nil
(nil)[138] = nil
(nil)[139] = nil
(nil)[140] = false
(nil)[141] = nil
(nil)[142] = nil
(nil)[143] = nil
(nil)[144] = nil
(nil)[145] = nil
(nil)[146] = nil
(nil)[147] = nil
(nil)[148] = nil
(nil)[149] = nil
(nil)[150] = nil
(nil)[151] = nil
(nil)[152] = nil
(nil)[153] = nil
(nil)[154] = nil
(nil)[155] = nil
(nil)[156] = nil
(nil)[157] = nil
(nil)[158] = nil
(nil)[159] = nil
else
v10544.LocalTransparencyModifier = v
end
end)
end
end
table.clear(t387.Modifier)
local Character = LocalPlayer2.Character
if Character and Character:FindFirstChildWhichIsA("Model") then
for k, v in pairs(t387.Transparency) do
if k:IsDescendantOf(Character) then
k.Transparency = v
end
end
end
table.clear(t387.Transparency)
t387.MorphSeen = nil
end
t388 = {
["Bee Attack"] = "AntiBee",
Boogie = "AntiBoogie",
}
obj = setmetatable
t390 = {}
t389 = {}
end
if exitTo2 == 1 then
v9822(LocalPlayer2:GetAttributeChangedSignal("Ragdoll"), v9947)
break
end
end
end
v9822(LocalPlayer2:GetAttributeChangedSignal("BlockTools"), function()
v9991(LocalPlayer2.Character)
end)
v9822(Players2.PlayerRemoving, function(p1498)
t392.Threat[p1498] = nil
t392.PrevOther[p1498] = nil
end)
v9822(Lighting.ChildAdded, function(p1499)
if
not ((p1499:IsA("ColorCorrectionEffect") or not not p1499:IsA("BlurEffect")) and v9978())
then
return
end
task.defer(v9817(function()
if p1499.Parent then
p1499:Destroy()
end
end))
end)
v9822(Workspace:GetPropertyChangedSignal("CurrentCamera"), v9988)
v9988()
if LocalPlayer2.Character then
local Character = LocalPlayer2.Character
v9862(Character)
task.delay(
0.2,
v9817(function()
if u9813 or LocalPlayer2.Character ~= Character then
return
end
v9995(Character)
end)
)
task.delay(
0.5,
v9817(function()
if not u9813 then
v9964(LocalPlayer2.Character)
end
end)
)
end
if not v9984() then
v9827("UseItemWait", 1, function()
if v9984() then
v9828("UseItemWait")
end
end)
end
task.delay(
1,
v9817(function()
if not u9813 then
v9975()
end
end)
)
return t375
end
return v9800
end
n946 = 322557008
u214 -= 1851
n1 = 296562563
n2 = 999352979
n914 -= 1573
u215 += 1319
n4 += 1144
bit32.band(nil, nil)
end
Sources.Protection = v9797()
local function v10549()
local n978 = 53160677
local n979 = 37012668
if n1 == 104592110 then
local function v10552(p1500)
local n980 = 223680645
local n981 = 474113361
local RunService2 = p1500.RunService
local UserInputService2 = p1500.UserInputService
local n982 = 258418506
local LocalPlayer2 = p1500.LocalPlayer
local Config = p1500.Config
local n983 = 639077403
local u10561 = false
local t397 = {}
local v10563 = game.PlaceId == 99606176102979
local t398 = {
[Enum.HumanoidStateType.Physics] = true,
[Enum.HumanoidStateType.Ragdoll] = true,
[Enum.HumanoidStateType.FallingDown] = true,
[Enum.HumanoidStateType.Freefall] = true,
[Enum.HumanoidStateType.Jumping] = true,
}
local function v10565(p1501, p1502)
local n984 = 704799611
if p1501 then
if p1501.Parent then
local n985 = 969157710
if not v10563 then
if n981 < n984 then
return (
pcall(function()
p1501.AssemblyLinearVelocity = p1502
end)
)
end
n984 += 1932
n982 = 794622169
n985 += 1762
n981 = 51416586
n2 = 995481788
n983 = 1021726863
n979 += 385
n980 += 1417
end
local n986
local n987
return (
pcall(function()
n986 = 261637791
n987 = 659257314
p1501:ApplyImpulse(p1501.AssemblyMass * (p1502 - p1501.AssemblyLinearVelocity))
if n981 == n982 then
n2 = 213438295
n984 -= 89
n985 += 1262
n982 -= 1513
n981 = 894725929
n980 += 1438
n986 -= 1744
n987 += 1111
upv204[nil] = nil
end
end)
)
end
end
return false
end
local function v10570()
local t399 = {}
local FlyTool = Config.FlyTool
if type(FlyTool) == "string" and FlyTool ~= "" and FlyTool ~= "Auto" then
table.insert(t399, FlyTool)
end
return t399
end
local function v10573(p1503)
if not p1503 then
return nil
end
for _, v in ipairs(v10570()) do
local v10576 = p1503:FindFirstChild(v)
if v10576 and v10576:IsA("Tool") then
return v10576
end
end
return nil
end
local function v10577()
local v10578, _, v10580 = p1500.Character()
local Backpack = LocalPlayer2:FindFirstChildOfClass("Backpack")
if not v10578 or not v10580 or not Backpack or v10580.Health <= 0 then
return
end
if v10573(v10578) then
return
end
for _, v in ipairs(v10570()) do
local v10584 = Backpack:FindFirstChild(v)
if v10584 and v10584:IsA("Tool") then
v10580:EquipTool(v10584)
return
end
end
if not (n982 < n981) then
n979 += 230
n982 = 748420620
n980 -= 68
n983 = 244216394
n981 += 594
n2 = 1046503682
(nil)(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 434))
local v10585 = bit32.band(nil, nil);
(nil)(nil);
(nil)(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
v10585,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 221));
(nil)(table.unpack({
nil,
nil,
v10585,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 383))
end
end
local u10586
local u10587
local u10588 = false
local u10589 = false
local n988 = 0
local n989 = 0
local n990 = 0
local n991 = 0
local n992 = 0
local u10595 = false
local function v10596(p1504)
if Config.__FlashBusy == true then
return
end
local _, v10598 = p1500.Character()
if not v10598 then
return
end
local Y = v10598.AssemblyLinearVelocity.Y
v10565(v10598, Vector3.new(0, p1504 and math.min(Y, 0) or Y, 0))
if n980 ~= 223680645 then
n983 -= 1158
n2 += 1230
n978 = 171974992
n981 += 972
n980 -= 1165
n982 = 177703810
end
end
local function v10600()
local now3 = os.clock()
local v10602 = math.clamp(now3 - n989, 0, 0.033333333333333333)
n989 = now3
if Config.__FlashBusy == true then
u10588 = false
u10589 = false
n988 = 0
return
end
local v10603, v10604, v10605 = p1500.Character()
if v10603 ~= u10587 then
u10587 = v10603
u10588 = false
u10589 = false
n988 = 0
n990 = 0
n991 = 0
n992 = 0
end
if not v10603 or not v10603.Parent or not v10604 or not v10605 or v10605.Health <= 0 then
u10588 = false
return
end
local MoveDirection = v10605.MoveDirection
local v10607 = MoveDirection.Magnitude >= 0.05
if u10589 and not v10607 then
n988 = now3 + 0.08
end
u10589 = v10607
if now3 < n988 then
u10588 = false
v10565(v10604, Vector3.new(0, v10604.AssemblyLinearVelocity.Y, 0))
return
end
local state = v10605:GetState()
if not v10607 and t398[state] ~= true then
local AssemblyLinearVelocity = v10604.AssemblyLinearVelocity
if
AssemblyLinearVelocity.X * AssemblyLinearVelocity.X
+ AssemblyLinearVelocity.Z * AssemblyLinearVelocity.Z
> 1
and not u10588
then
v10565(v10604, Vector3.new(0, AssemblyLinearVelocity.Y, 0))
end
end
local v10610 = LocalPlayer2:GetAttribute("Stealing") ~= nil
local v10611 = v10573(v10603)
if Config.CarpetSpeed ~= true or v10610 or v10611 then
n990 = 0
n991 = 0
n992 = 0
elseif n992 <= now3 then
if n991 == 0 or n990 >= 0.4 then
n990 = 0
n991 += 1
pcall(v10577)
if n991 >= 3 then
n991 = 0
n992 = now3 + 6
end
v10611 = v10573(v10603)
else
n990 += v10602
end
end
local n993 = 0
local v10613 = false
if v10611 and not v10610 then
v10613 = Config.CarpetSpeed == true
n993 = 140
end
if not v10613 then
u10588 = false
return
end
local Y = v10604.AssemblyLinearVelocity.Y
if v10607 then
local Unit = MoveDirection.Unit
u10588 = v10565(v10604, Vector3.new(Unit.X * n993, Y, Unit.Z * n993))
return
end
u10588 = false
if state ~= Enum.HumanoidStateType.Freefall and state ~= Enum.HumanoidStateType.Jumping then
v10565(v10604, Vector3.new(0, Y, 0))
end
end
local function v10616()
local n994 = 464046489
if not u10561 and p1500.Running() and Config.CarpetSpeed == true then
if not u10586 then
n989 = os.clock()
u10587 = nil
u10588 = false
u10589 = false
n988 = 0
u10586 = p1500.Loop(0.03, v10600)
end
elseif u10586 then
u10586:Stop()
u10586 = nil
if u10588 then
v10596(false)
end
u10588 = false
end
if n983 == n994 then
n981 += 272
n979 = 583765387
n982 += 1254
n980 = 869368220
n983 = 1059899372
n2 = 860134106
end
end
local t400 = {}
local u10619 = false
local function v10620()
if not p1500.Running() or Config.InfiniteJump ~= true then
u10619 = false
return
end
local _, v10622, v10623 = p1500.Character()
if not v10622 or not v10623 or v10623.Health <= 0 then
u10619 = false
return
end
if UserInputService2:GetFocusedTextBox() ~= nil then
u10619 = false
return
end
local Jump = u10619 or v10623.Jump
u10619 = false
if not (Jump or UserInputService2:IsKeyDown(Enum.KeyCode.Space)) then
return
end
if v10623.PlatformStand then
v10623.PlatformStand = false
end
local AssemblyRootPart = v10622.AssemblyRootPart or v10622
local AssemblyLinearVelocity = AssemblyRootPart.AssemblyLinearVelocity
v10565(AssemblyRootPart, Vector3.new(AssemblyLinearVelocity.X, 40, AssemblyLinearVelocity.Z))
end
local function v10627()
for _, v in ipairs(t400) do
v:Disconnect()
end
table.clear(t400)
u10619 = false
end
local function v10630(p1505)
v10627()
if not p1505 or u10561 then
return
end
table.insert(
t400,
p1500.Connect(UserInputService2.JumpRequest, function()
if Config.InfiniteJump == true then
u10619 = true
end
end)
)
table.insert(
t400,
p1500.Connect(RunService2.Heartbeat, function()
pcall(v10620)
end)
)
end
local n995
return {
Defaults = {
CarpetSpeed = false,
InfiniteJump = false,
},
Set = function(p1506, p1507)
if u10561 then
return
end
Config[p1506] = p1507
if n981 == n983 then
n983 -= 1766
n2 -= 519
n981 = 330850603
n980 = 554252994
u215 -= 1165
n982 = 351550351
(nil)[nil] = nil
elseif p1506 == "CarpetSpeed" then
local v10632 = p1507 == true
if u10595 and not v10632 then
v10596(true)
u10588 = false
end
u10595 = v10632
v10616()
elseif p1506 == "InfiniteJump" then
v10630(p1507 == true)
end
end,
Stop = function()
n995 = 539976507
if u10561 then
return
end
u10561 = true
if u10586 then
u10586:Stop()
u10586 = nil
end
if u10588 or u10595 then
v10596(u10595)
end
u10588 = false
u10595 = false
v10627()
for _, v in ipairs(t397) do
v:Disconnect()
end
table.clear(t397)
if n995 ~= n2 then
return
end
n980 = 426161814
n978 += 1190
n995 -= 1042
n983 = 293200824
n981 += 1323
n982 -= 1411
n2 = 855657710
end,
}
end
return v10552
end
n914 = 640605901
u214 += 244
n1 -= 195
n4 -= 109
u215 = 178870478
n2 -= 1272
(nil)[nil] = nil
end
Sources.Movement = v10549()
local function v10635()
local n996 = 542324370
local n997 = 255742242
local n998 = 223043681
local function v10639(p1508)
local n999 = 24482587
local Players2 = p1508.Players
local Workspace = p1508.Workspace
local LocalPlayer2 = p1508.LocalPlayer
local TweenService = game:GetService("TweenService")
local t401 = {
Defaults = {
EspBrainrots = false,
EspBestHighlight = true,
EspBestTracer = false,
EspPlayers = false,
EspPlayerStealing = true,
EspPlayerInBase = true,
EspBaseXray = false,
},
}
local t402 = {}
for k, default in pairs(t401.Defaults) do
local Config = p1508.Config and p1508.Config[k]
local v10650
if Config == nil then
v10650 = default
else
v10650 = Config
end
t402[k] = v10650
end
local t403 = {
Back = Color3.fromRGB(14, 14, 19),
Text = Color3.fromRGB(238, 240, 248),
Gold = Color3.fromRGB(255, 205, 80),
Red = Color3.fromRGB(255, 92, 108),
Green = Color3.fromRGB(96, 226, 150),
Amber = Color3.fromRGB(255, 184, 76),
Cyan = Color3.fromRGB(96, 196, 255),
Accent = Color3.fromRGB(232, 111, 177),
Accent2 = Color3.fromRGB(255, 170, 210),
Dim = Color3.fromRGB(140, 146, 168),
}
local t404 = {
Green = "#" .. t403.Green:ToHex(),
Amber = "#" .. t403.Amber:ToHex(),
Red = "#" .. t403.Red:ToHex(),
Dim = "#" .. t403.Dim:ToHex(),
Money = "#" .. t403.Accent2:ToHex(),
Gold = "#" .. t403.Gold:ToHex(),
}
local t405 = {
Accent = {
Seq = ColorSequence.new(t403.Accent, t403.Accent2),
Text = t403.Text,
Fill = Color3.fromRGB(200, 80, 150),
},
Gold = {
Seq = ColorSequence.new(t403.Gold, Color3.fromRGB(255, 136, 56)),
Text = t403.Gold,
Fill = Color3.fromRGB(240, 170, 30),
},
Red = {
Seq = ColorSequence.new(t403.Red, Color3.fromRGB(255, 60, 150)),
Text = t403.Red,
Fill = Color3.fromRGB(226, 52, 70),
},
Amber = {
Seq = ColorSequence.new(t403.Amber, t403.Gold),
Text = t403.Amber,
Fill = Color3.fromRGB(240, 140, 30),
},
Green = {
Seq = ColorSequence.new(t403.Green, Color3.fromRGB(80, 220, 220)),
Text = t403.Green,
Fill = Color3.fromRGB(46, 190, 100),
},
Cyan = {
Seq = ColorSequence.new(t403.Cyan, t403.Accent),
Text = t403.Text,
Fill = Color3.fromRGB(40, 150, 230),
},
Dim = {
Seq = ColorSequence.new(t403.Dim, Color3.fromRGB(90, 96, 118)),
Text = t403.Dim,
Fill = Color3.fromRGB(90, 96, 118),
},
}
local n1000 = 34296736
local t406 = {
gold = "#FFCF4A",
diamond = "#7FE3FF",
rainbow = "#FF7AD9",
lava = "#FF7A3D",
bloodrot = "#FF4A5E",
celestial = "#A9C8FF",
candy = "#FF9CD6",
galaxy = "#B18CFF",
yinyang = "#E6E6E6",
radioactive = "#9DFF5A",
cursed = "#C04AFF",
divine = "#FFF1A8",
eclipse = "#FF8C3C",
cyber = "#79DBFF",
}
local Bold
if p1508.Fonts then
Bold = p1508.Fonts.Bold
else
Bold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
end
local t407 = {
Bold = Bold,
}
local Semi
if p1508.Fonts then
Semi = p1508.Fonts.Semi
else
Semi = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
end
t407.Medium = Semi
local t408 = {
Clean = {
Back = t403.Back,
Alpha = 0.15,
Edge = "Tone",
EdgeAlpha = 0.2,
Thick = 1.2,
Round = 0.6,
Title = "Tone",
SubColor = t403.Dim,
TextStroke = 1,
},
}
local t409 = {
"K",
"M",
"B",
"T",
"Qa",
"Qi",
"Sx",
"Sp",
}
local t410 = {
["&"] = "&amp;",
["<"] = "&lt;",
[">"] = "&gt;",
['"'] = "&quot;",
["'"] = "&apos;",
}
local t411 = {
"Decorations",
"Skin",
}
local n1001 = 567886709
local t412 = {
Holder = nil,
UseHui = typeof(gethui) == "function",
Loop = nil,
Ticks = 0,
XrayDue = 0,
}
local obj = setmetatable({}, {
__mode = "k",
})
local t413 = {}
local t414 = {
Highlight = nil,
Pulse = nil,
Podium = nil,
Name = nil,
Adornee = nil,
}
local t415 = {
Loop = nil,
Line = nil,
Dot = nil,
Target = nil,
}
local t416 = {}
local function v10670(p1509, p1510, p1511, p1512, p1513, p1514)
return {
Active = {},
Free = {},
Seen = {},
MaxDistance = p1509,
TextSize = p1510,
Width = p1511,
Height = p1512,
MinWidth = p1513,
Glyph = p1514 == true,
}
end
local t417 = {
Brainrot = v10670(100000, 13, 320, 70, 0),
Player = v10670(100000, 13, 320, 70, 0),
}
local function v10672(p1515)
if p1515 then
pcall(function()
p1515:Destroy()
end)
end
end
local function v10673(p1516, p1517, p1518)
local instance = Instance.new(p1516)
for k, v in pairs(p1517) do
instance[k] = v
end
if p1518 then
instance.Parent = p1518
end
return instance
end
local function v10677(p1519)
return (string.gsub(p1519, "[&<>\"']", t410))
end
local n1002
local function v10679(p1520, p1521)
n1002 = 6663887
if n999 == 24482587 then
return '<font color="' .. p1521 .. '">' .. p1520 .. "</font>"
end
n2 = 581361368
n1001 -= 908
n1 += 718
u214 += 322
n999 = 567871839
n1002 += 1184
n1000 += 936
end
local function v10680(p1522)
return p1522 ~= nil and p1522 ~= false
end
local function v10681()
return math.clamp(tonumber(t402.EspXrayTransparency) or 0.6, 0, 1)
end
local function v10682(p1523)
if p1523 < 1000 then
return string.format("%d/s", math.floor(p1523))
end
local n1003 = 0
if p1523 >= 999.95 then
while n1003 < #t409 do
p1523 /= 1000
n1003 += 1
if not (p1523 >= 999.95) then
break
end
end
end
local v10684 = string.format("%.1f", p1523)
if string.sub(v10684, -2) == ".0" then
v10684 = string.sub(v10684, 1, -3)
end
return v10684 .. t409[n1003] .. "/s"
end
local function v10685(p1524)
local v10686 = obj[p1524]
if v10686 and v10686.Parent then
return v10686
end
local PrimaryPart
if p1524:IsA("BasePart") then
PrimaryPart = p1524
if PrimaryPart then
obj[p1524] = PrimaryPart
end
else
local Base = p1524:FindFirstChild("Base")
local Spawn = Base and Base:FindFirstChild("Spawn")
local Claim = p1524:FindFirstChild("Claim")
local Main = Claim and Claim:FindFirstChild("Main")
if Spawn and Spawn:IsA("BasePart") then
PrimaryPart = Spawn
if PrimaryPart then
obj[p1524] = PrimaryPart
end
elseif Main and Main:IsA("BasePart") then
PrimaryPart = Main
if PrimaryPart then
obj[p1524] = PrimaryPart
end
elseif p1524:IsA("Model") and p1524.PrimaryPart then
if u214 < n2 then
PrimaryPart = p1524.PrimaryPart
if PrimaryPart then
obj[p1524] = PrimaryPart
end
else
u214 -= 349
n1001 -= 1534
n996 = 250086695
n999 -= 943
n1000 = 570204352
n2 += 510
bit32.band(nil, nil)
end
else
PrimaryPart = p1524:FindFirstChildWhichIsA("BasePart", true)
if PrimaryPart then
obj[p1524] = PrimaryPart
end
end
end
return PrimaryPart
end
local function v10692(p1525)
local BillboardGui = v10673("BillboardGui", {
Name = "Tag",
AlwaysOnTop = true,
LightInfluence = 0,
ResetOnSpawn = false,
ClipsDescendants = false,
MaxDistance = p1525.MaxDistance,
Size = UDim2.fromOffset(p1525.Width, p1525.Height),
Enabled = false,
})
local Clean = t408[t402.EspStyle] or t408.Clean
local v10695 = p1525.TextSize > 16
local v10696 = math.floor(p1525.TextSize * Clean.Round)
local v10697 = v10673
local s47 = "Frame"
local t418 = {
AnchorPoint = Vector2.new(0.5, 1),
Position = UDim2.fromScale(0.5, 1),
Size = UDim2.new(),
AutomaticSize = Enum.AutomaticSize.XY,
}
local Back
if typeof(Clean.Back) == "Color3" then
Back = Clean.Back
else
Back = t405.Accent.Fill
end
t418.BackgroundColor3 = Back
t418.BackgroundTransparency = Clean.Alpha
t418.BorderSizePixel = 0
local v10701 = v10697(s47, t418, BillboardGui)
v10673("UICorner", {
CornerRadius = UDim.new(0, v10696),
}, v10701)
if p1525.MinWidth > 0 then
v10673("UISizeConstraint", {
MinSize = Vector2.new(p1525.MinWidth, 0),
}, v10701)
end
if Clean.Frost then
v10673("UIGradient", {
Rotation = 90,
Transparency = NumberSequence.new(0, 0.55),
}, v10701)
end
if Clean.Sheen then
local Frame = v10673("Frame", {
Size = UDim2.fromScale(1, 0.52),
BackgroundColor3 = Color3.new(1, 1, 1),
BorderSizePixel = 0,
ZIndex = 1,
}, v10701)
v10673("UICorner", {
CornerRadius = UDim.new(0, v10696),
}, Frame)
v10673("UIGradient", {
Rotation = 90,
Transparency = NumberSequence.new(Clean.Sheen, 1),
}, Frame)
end
local v10703 = v10673
local s48 = "UIStroke"
local color32
if Clean.Edge == "Black" then
color32 = Color3.new(0, 0, 0)
else
color32 = Color3.new(1, 1, 1)
end
local t419 = {
Color = color32,
}
local thickness
if v10695 then
thickness = Clean.Thick * 1.6
else
thickness = Clean.Thick
end
t419.Thickness = thickness
t419.Transparency = Clean.EdgeAlpha
t419.Enabled = Clean.Edge ~= "None"
t419.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
local v10708 = v10703(s48, t419, v10701)
local UIGradient = v10673("UIGradient", {
Color = t405.Accent.Seq,
Rotation = 20,
Enabled = Clean.Edge == "Tone",
}, v10708)
local UIScale = v10673("UIScale", {}, v10701)
local Frame = v10673("Frame", {
Size = UDim2.new(),
AutomaticSize = Enum.AutomaticSize.XY,
BackgroundTransparency = 1,
ZIndex = 2,
}, v10701)
local n1004
if Clean.Alpha >= 1 then
n1004 = 0
else
n1004 = math.floor(p1525.TextSize * 0.38)
end
v10673("UIPadding", {
PaddingTop = UDim.new(0, n1004),
PaddingBottom = UDim.new(0, n1004 + 1),
PaddingLeft = UDim.new(0, n1004 + 5),
PaddingRight = UDim.new(0, n1004 + 5),
}, Frame)
v10673("UIListLayout", {
SortOrder = Enum.SortOrder.LayoutOrder,
FillDirection = Enum.FillDirection.Horizontal,
VerticalAlignment = Enum.VerticalAlignment.Center,
Padding = UDim.new(0, math.floor(p1525.TextSize * 0.5)),
}, Frame)
v10673("UISizeConstraint", {
MinSize = Vector2.new(p1525.MinWidth, 0),
}, Frame)
local Frame2
if p1525.Glyph then
Frame2 = v10673("Frame", {
Size = UDim2.fromOffset(math.floor(p1525.TextSize * 1.6), math.floor(p1525.TextSize * 1.6)),
BackgroundTransparency = 1,
Visible = false,
LayoutOrder = 0,
}, Frame)
else
Frame2 = nil
end
local Frame3 = v10673("Frame", {
Size = UDim2.new(),
AutomaticSize = Enum.AutomaticSize.XY,
BackgroundTransparency = 1,
LayoutOrder = 1,
}, Frame)
local v10715 = v10673
local s49 = "UIListLayout"
local t420 = {
SortOrder = Enum.SortOrder.LayoutOrder,
}
local Left
if p1525.Glyph then
Left = Enum.HorizontalAlignment.Left
else
Left = Enum.HorizontalAlignment.Center
end
t420.HorizontalAlignment = Left
t420.Padding = UDim.new(0, 1)
v10715(s49, t420, Frame3)
local v10719 = v10673
local s50 = "TextLabel"
local t421 = {
BackgroundTransparency = 1,
Size = UDim2.new(),
AutomaticSize = Enum.AutomaticSize.XY,
}
local Cartoon
if Clean.Cartoon then
Cartoon = t407.Cartoon
else
Cartoon = t407.Bold
end
t421.FontFace = Cartoon
local textSize
if Clean.Cartoon then
textSize = p1525.TextSize + 2
else
textSize = p1525.TextSize
end
t421.TextSize = textSize
t421.RichText = true
t421.TextColor3 = t403.Text
t421.TextStrokeColor3 = Color3.new(0, 0, 0)
t421.TextStrokeTransparency = Clean.TextStroke
t421.Text = ""
t421.LayoutOrder = 1
local v10724 = v10719(s50, t421, Frame3)
local v10725 = v10673
local s51 = "TextLabel"
local t422 = {
BackgroundTransparency = 1,
Size = UDim2.new(),
AutomaticSize = Enum.AutomaticSize.XY,
}
local Cartoon2
if Clean.Cartoon then
Cartoon2 = t407.Cartoon
else
Cartoon2 = t407.Medium
end
t422.FontFace = Cartoon2
local textSize2
if v10695 then
textSize2 = p1525.TextSize - 8
else
textSize2 = p1525.TextSize - 2
end
t422.TextSize = textSize2
t422.RichText = true
t422.TextColor3 = Clean.SubColor
t422.TextStrokeColor3 = Color3.new(0, 0, 0)
t422.TextStrokeTransparency = Clean.TextStroke
t422.Text = ""
t422.Visible = false
t422.LayoutOrder = 2
local v10730 = v10725(s51, t422, Frame3)
BillboardGui.Parent = t412.Holder
return {
Gui = BillboardGui,
Card = v10701,
Edge = v10708,
Shine = UIGradient,
Pop = UIScale,
Title = v10724,
Sub = v10730,
Style = Clean,
Glyph = Frame2,
}
end
local function v10731(p1526, p1527)
p1526.Seen[p1527] = true
local spilled = {
n1005 = 113548063,
v10732 = p1526.Active[p1527],
}
if spilled.v10732 then
return spilled.v10732
end
spilled.v10733 = table.remove(p1526.Free) or v10692(p1526)
if n1 == 104592110 then
p1526.Active[p1527] = spilled.v10733
else
n1 = 716300662
n1000 += 412
n2 = 87443468
n997 = 430043065
n1001 -= 568
n999 += 1666
local _
(nil)(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 309))
upv497[nil] = spilled.v10911
end
return spilled.v10733
end
local function v10912(p1528, p1529)
if #p1528.Free >= 32 then
v10672(p1529.Gui)
return
end
pcall(function()
p1529.Gui.Enabled = false
p1529.Gui.Adornee = nil
end)
p1529.Anchor = nil
table.insert(p1528.Free, p1529)
end
local n1006
local n1007
local function v10913(p1530)
n1006 = 1041336849
n1007 = 567863850
for k, v in pairs(p1530.Active) do
if not p1530.Seen[k] then
p1530.Active[k] = nil
v10912(p1530, v)
end
end
if n999 < n996 then
table.clear(p1530.Seen)
else
n1001 += 1301
n2 = 322038343
n1007 += 1397
n999 = 190755854
n996 = 265412038
n1000 -= 755
n1006 -= 1302
end
end
local function v10916(p1531)
for _, v in pairs(p1531.Active) do
v10672(v.Gui)
end
for _, v in ipairs(p1531.Free) do
v10672(v.Gui)
end
table.clear(p1531.Active)
table.clear(p1531.Free)
table.clear(p1531.Seen)
end
local function v10921(p1532, p1533, p1534, p1535, p1536, p1537, p1538)
local Gui = p1532.Gui
if p1532.Anchor ~= p1533 then
p1532.Anchor = p1533
Gui.Adornee = p1533
end
if p1532.Offset ~= p1534 then
p1532.Offset = p1534
Gui.StudsOffsetWorldSpace = p1534
end
if p1532.TitleText ~= p1535 then
p1532.TitleText = p1535
p1532.Title.Text = p1535
end
local subText = p1536 or ""
if p1532.SubText ~= subText then
p1532.SubText = subText
p1532.Sub.Text = subText
p1532.Sub.Visible = subText ~= ""
end
local Style = p1532.Style
if p1532.Tone ~= p1537 then
p1532.Tone = p1537
p1532.Shine.Color = p1537.Seq
local Title = p1532.Title
local Text
if Style.Title == "White" then
Text = t403.Text
else
Text = p1537.Text
end
Title.TextColor3 = Text
if Style.Back == "Tone" then
p1532.Card.BackgroundColor3 = p1537.Fill
end
end
if p1532.Fade ~= p1538 then
p1532.Fade = p1538
p1532.Title.TextTransparency = p1538
p1532.Sub.TextTransparency = p1538
p1532.Card.BackgroundTransparency = Style.Alpha + (1 - Style.Alpha) * p1538 * 0.7
p1532.Edge.Transparency = Style.EdgeAlpha + (1 - Style.EdgeAlpha) * p1538 * 0.7
end
if not Gui.Enabled then
Gui.Enabled = true
p1532.Pop.Scale = 0.6
TweenService
:Create(p1532.Pop, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
Scale = 1,
})
:Play()
end
end
local function createHighlight(p1539, p1540)
local Highlight = Instance.new("Highlight")
Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
Highlight.FillColor = p1539
Highlight.OutlineColor = p1539
Highlight.FillTransparency = p1540
Highlight.OutlineTransparency = 0
Highlight.Parent = t412.Holder
return Highlight
end
local function v10929()
for _, v in pairs(t413) do
v10672(v)
end
table.clear(t413)
end
local function v10932()
if t414.Pulse then
t414.Pulse:Cancel()
t414.Pulse = nil
end
v10672(t414.Highlight)
t414.Highlight = nil
t414.Podium = nil
t414.Name = nil
t414.Adornee = nil
t415.Target = nil
end
local function v10933()
if t415.Beam then
t415.Beam.Hide()
end
end
local function v10934()
v10916(t417.Brainrot)
v10916(t417.Player)
v10929()
v10932()
v10933()
v10672(t412.Holder)
t412.Holder = nil
end
local function createScreenGui()
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = p1508.HttpService:GenerateGUID(false)
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
return ScreenGui
end
local function v10937()
local n1008 = 939833062
if t412.UseHui then
local v10939 = createScreenGui()
if
pcall(function()
v10939.Parent = gethui()
local Folder = Instance.new("Folder")
Folder.Parent = v10939
Folder.Name = "Probe"
if u214 < n1001 then
Folder:Destroy()
else
n2 = 446519753
u214 = 497119573
n999 = 560337923
n1001 = 119460616
n1008 = 82414011
upv199[nil] = nil
getfenv()[nil] = nil
(nil)(nil)
upv499[nil] = nil
end
end)
then
return (p1508.Track(v10939))
end
t412.UseHui = false
v10672(v10939)
end
local PlayerGui = LocalPlayer2:FindFirstChildOfClass("PlayerGui")
if u214 < n1001 then
if not PlayerGui then
return nil
end
local v10942 = createScreenGui()
v10942.Parent = PlayerGui
return (p1508.Track(v10942))
end
n1001 = 393327267
n1008 += 1750
n2 -= 1581
n1000 = 16611720
u214 -= 427
n999 = 354026789
end
local function v10943(p1541)
local PlotSign = p1541:FindFirstChild("PlotSign")
local SurfaceGui = PlotSign and PlotSign:FindFirstChild("SurfaceGui")
local Frame = SurfaceGui and SurfaceGui:FindFirstChild("Frame")
local TextLabel = Frame and Frame:FindFirstChild("TextLabel")
if TextLabel and TextLabel:IsA("TextLabel") then
local Text = TextLabel.Text
if Text == "" or Text == "Empty Base" then
return nil
end
return (string.gsub(Text, "'s [Bb]ase%s*$", ""))
end
return nil
end
local function v10949(p1542)
local t423 = {}
local Plots = Workspace:FindFirstChild("Plots")
if not Plots then
return t423
end
for _, child in ipairs(Plots:GetChildren()) do
local v10954 = v10943(child)
local v10955
if p1542 then
v10955 = child == p1542
else
v10955 = v10954 ~= nil
and (v10954 == LocalPlayer2.DisplayName or v10954 == LocalPlayer2.Name)
end
table.insert(t423, {
Plot = child,
Owner = v10954,
Mine = v10955,
})
end
return t423
end
local function v10956(p1543)
local Model = p1543.Model
local Podium = p1543.Podium
if not Model or not Model.Parent or typeof(Podium) ~= "Vector3" then
return nil
end
local v10959
local n1009 = 14
for _, child in ipairs(Model:GetChildren()) do
if child:IsA("Model") and child.Name == p1543.Name then
local Magnitude = (child:GetPivot().Position - Podium).Magnitude
if Magnitude < n1009 then
v10959 = child
n1009 = Magnitude
end
end
end
return v10959
end
local function v10964(p1544)
if type(p1544) ~= "string" or p1544 == "" or p1544 == "Normal" then
return nil
end
local v10965 = string.gsub(p1544, "[^%a]", "")
local v10966 = string.lower(v10965)
if n997 < n2 then
return "<b>" .. v10679(v10677(p1544), t406[v10966] or "#" .. t403.Accent:ToHex()) .. "</b>"
end
n1000 = 857610596
n999 -= 174
n997 = 646497966
n1001 += 1882
u214 = 776101920
n2 -= 864
end
local function v10967(p1545, p1546, p1547, p1548)
local Brainrot = t417.Brainrot
local n1010 = 0
for _, v in ipairs(p1545) do
if n1010 >= 48 then
break
end
local v10972 = tonumber(v.Income) or 0
local Model = v.Model
local PodiumModel = v.PodiumModel
if Model and Model.Parent and Model ~= p1548 and PodiumModel and PodiumModel.Parent then
local v10975 = v10685(PodiumModel)
if v10975 then
local Podium
if typeof(v.Podium) == "Vector3" then
Podium = v.Podium
else
Podium = v10975.Position
end
local v10977 = v10677(tostring(v.Name))
local t424 = {}
local v10979 = v10964(v.Mutation)
if v10979 then
table.insert(t424, v10979)
end
table.insert(t424, v10679(v10682(v10972), t404.Green))
if v10977 == "" and #t424 > 0 then
v10977 = table.remove(t424, 1)
end
if v10977 ~= "" then
n1010 += 1
local v10980 = v10921
local v10981 = v10731(Brainrot, PodiumModel)
local v10982 = v10975
local v10983 = Podium - v10975.Position + Vector3.new(0, 7.5, 0)
local v10984 = v10977
local v10985 = table.concat(t424, "   ")
local Gold
if p1546 and p1546.PodiumModel == PodiumModel and p1546.Name == v.Name then
Gold = t405.Gold
else
Gold = t405.Accent
end
v10980(v10981, v10982, v10983, v10984, v10985, Gold, 0)
end
end
end
end
v10913(Brainrot)
end
local function v10987(p1549, p1550)
if
not (
t402.EspBrainrots
and p1549 ~= nil
and p1549.Model ~= nil
and p1549.Model ~= p1550
and (t402.EspBestHighlight or t402.EspBestTracer)
)
then
v10932()
return
end
local PodiumModel = p1549.PodiumModel
if
t414.Podium ~= PodiumModel
or t414.Name ~= p1549.Name
or not t414.Adornee
or not t414.Adornee.Parent
then
t414.Podium = PodiumModel
t414.Name = p1549.Name
t414.Adornee = v10956(p1549) or PodiumModel
end
local Adornee = t414.Adornee
if not Adornee then
v10932()
return
end
local PrimaryPart
if Adornee:IsA("BasePart") then
PrimaryPart = Adornee
else
PrimaryPart = Adornee.PrimaryPart or Adornee:FindFirstChildWhichIsA("BasePart", true)
end
t415.Target = PrimaryPart
if not t402.EspBestHighlight then
if t414.Highlight then
if t414.Pulse then
t414.Pulse:Cancel()
t414.Pulse = nil
end
v10672(t414.Highlight)
t414.Highlight = nil
end
return
end
local Highlight = t414.Highlight
if not Highlight then
Highlight = createHighlight(t403.Accent, 1)
t414.Highlight = Highlight
end
if Highlight.Adornee ~= Adornee then
Highlight.Adornee = Adornee
end
end
local function v10992()
local Target = t415.Target
local _, v10995 = p1508.Character()
if Target and Target.Parent and v10995 then
if type(p1508.NewLine) == "function" then
t415.Beam = t415.Beam or p1508.NewLine("SxeLineToBest")
t415.Beam.Set(v10995, Target, Vector3.new(0, 2, 0))
return
end
end
if t415.Beam then
t415.Beam.Hide()
end
end
local function v10996(p1551, p1552)
local v10997 = p1551.CFrame:PointToObjectSpace(p1552)
local Size = p1551.Size
return math.abs(v10997.X) <= Size.X * 0.5 and math.abs(v10997.Z) <= Size.Z * 0.5
end
local function v10999(p1553, p1554)
local Player = t417.Player
local t425 = {}
local n1011 = 0
for _, player in ipairs(Players2:GetPlayers()) do
local Character
if player == LocalPlayer2 then
Character = nil
else
Character = player.Character
end
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
if Character and HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
local v11007 = t402.EspPlayerInBase
and p1554 ~= nil
and v10996(p1554, HumanoidRootPart.Position)
local EspPlayerStealing = t402.EspPlayerStealing
local v11009, v11010, v11011, vector3, v11013, v11014, Red
if EspPlayerStealing then
EspPlayerStealing = v10680(player:GetAttribute("Stealing"))
or v10680(Character:GetAttribute("Stealing"))
local v11016 = v10677(player.DisplayName)
.. ' <font size="11" color="'
.. t404.Dim
.. '">@'
.. v10677(player.Name)
.. "</font>"
local t426 = {}
if v11007 then
table.insert(t426, "<b>" .. v10679("IN YOUR BASE", t404.Red) .. "</b>")
end
if EspPlayerStealing then
table.insert(t426, "<b>" .. v10679("STEALING", t404.Amber) .. "</b>")
end
if
p1508.Config.ESPTagKawaifu == true
and Character:FindFirstChild("KaWaifu_NeonHighlight")
then
table.insert(t426, "<b>" .. v10679("KAWAIFU", t404.Gold) .. "</b>")
end
if
p1508.Config.ESPTagBraintopia == true
and type(p1508.IsBT) == "function"
and p1508.IsBT(player)
then
table.insert(t426, "<b>" .. v10679("BT", "#AA50FF") .. "</b>")
end
if
p1508.Config.FmlyEspTag == true
and type(p1508.IsFmly) == "function"
and p1508.IsFmly(player)
then
table.insert(t426, "<b>" .. v10679("FMLY", "#FFD84D") .. "</b>")
end
if
p1508.Config.SonEspTag == true
and type(p1508.IsSon) == "function"
and p1508.IsSon(player)
then
table.insert(t426, "<b>" .. v10679("SON", "#4FB6F0") .. "</b>")
end
if v11016 == "" and #t426 > 0 then
v11016 = table.remove(t426, 1)
end
if v11016 ~= "" then
local Head = Character:FindFirstChild("Head")
local v11019
if Head and Head:IsA("BasePart") then
v11019 = Head
else
v11019 = HumanoidRootPart
end
v11009 = v10921
v11010 = v10731(Player, player)
v11011 = v11019
vector3 = Vector3.new(0, 3, 0)
v11013 = v11016
v11014 = table.concat(t426, "   ")
if v11007 then
Red = t405.Red
v11009(v11010, v11011, vector3, v11013, v11014, Red, 0)
elseif EspPlayerStealing then
Red = t405.Amber
v11009(v11010, v11011, vector3, v11013, v11014, Red, 0)
else
Red = t405.Accent
v11009(v11010, v11011, vector3, v11013, v11014, Red, 0)
end
end
else
local v11020 = v10677(player.DisplayName)
.. ' <font size="11" color="'
.. t404.Dim
.. '">@'
.. v10677(player.Name)
.. "</font>"
local t427 = {}
if v11007 then
table.insert(t427, "<b>" .. v10679("IN YOUR BASE", t404.Red) .. "</b>")
end
if
p1508.Config.ESPTagKawaifu == true
and Character:FindFirstChild("KaWaifu_NeonHighlight")
then
table.insert(t427, "<b>" .. v10679("KAWAIFU", t404.Gold) .. "</b>")
end
if
p1508.Config.ESPTagBraintopia == true
and type(p1508.IsBT) == "function"
and p1508.IsBT(player)
then
table.insert(t427, "<b>" .. v10679("BT", "#AA50FF") .. "</b>")
end
if
p1508.Config.FmlyEspTag == true
and type(p1508.IsFmly) == "function"
and p1508.IsFmly(player)
then
table.insert(t427, "<b>" .. v10679("FMLY", "#FFD84D") .. "</b>")
end
if
p1508.Config.SonEspTag == true
and type(p1508.IsSon) == "function"
and p1508.IsSon(player)
then
table.insert(t427, "<b>" .. v10679("SON", "#4FB6F0") .. "</b>")
end
if v11020 == "" and #t427 > 0 then
v11020 = table.remove(t427, 1)
end
if v11020 ~= "" then
local Head = Character:FindFirstChild("Head")
local v11023
if Head and Head:IsA("BasePart") then
v11023 = Head
else
v11023 = HumanoidRootPart
end
v11009 = v10921
v11010 = v10731(Player, player)
v11011 = v11023
vector3 = Vector3.new(0, 3, 0)
v11013 = v11020
v11014 = table.concat(t427, "   ")
if v11007 then
Red = t405.Red
v11009(v11010, v11011, vector3, v11013, v11014, Red, 0)
else
Red = t405.Accent
v11009(v11010, v11011, vector3, v11013, v11014, Red, 0)
end
end
end
if n1011 < 28 then
n1011 += 1
t425[player] = true
local Red2
if v11007 then
Red2 = t403.Red
elseif EspPlayerStealing then
Red2 = t403.Amber
else
Red2 = t403.Accent
end
local v11025 = t413[player]
if not v11025 then
v11025 = createHighlight(Red2, 0.7)
t413[player] = v11025
end
if v11025.Adornee ~= Character then
v11025.Adornee = Character
end
if v11025.FillColor ~= Red2 then
v11025.FillColor = Red2
v11025.OutlineColor = Red2
end
end
end
end
v10913(Player)
for k, v in pairs(t413) do
if not t425[k] then
v10672(v)
t413[k] = nil
end
end
end
local function v11028(p1555, p1556)
local v11029 = t416[p1555]
if not v11029 then
v11029 = {}
t416[p1555] = v11029
end
for k in pairs(v11029) do
if not k.Parent then
v11029[k] = nil
end
end
for _, v in ipairs(t411) do
local v11033 = p1555:FindFirstChild(v)
if v11033 then
local descendants = v11033:GetDescendants()
table.insert(descendants, v11033)
for _, descendant in ipairs(descendants) do
if descendant:IsA("BasePart") then
if v11029[descendant] == nil then
v11029[descendant] = descendant.LocalTransparencyModifier
end
if descendant.LocalTransparencyModifier ~= p1556 then
descendant.LocalTransparencyModifier = p1556
end
end
end
end
end
if n996 ~= 332514347 then
return
end
n996 += 347
n1 = 734890147
n999 += 620
n1001 = 52156624
n1000 += 308
n2 -= 1715
return table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 322)
end
local function v11037(p1557)
local v11038 = t416[p1557]
if not v11038 then
return
end
t416[p1557] = nil
for k, v in pairs(v11038) do
if k.Parent then
pcall(function()
k.LocalTransparencyModifier = v
end)
end
end
end
local function v11041()
for k in pairs(t416) do
v11037(k)
end
table.clear(t416)
if not (n998 < n1001) then
n1001 = 144435743
n2 = 140943042
n998 += 2007
n1000 = 428824640
n1 -= 1845
n999 -= 1010
upv16[nil] = nil
end
end
local function v11043()
local v11044 = v10681()
for _, v in pairs(t416) do
for k in pairs(v) do
if k.Parent then
k.LocalTransparencyModifier = v11044
end
end
end
end
local function v11048(p1558)
local v11049 = v10681()
local t428 = {}
for _, v in ipairs(p1558) do
t428[v.Plot] = true
if v.Owner and not v.Mine then
v11028(v.Plot, v11049)
else
v11037(v.Plot)
end
end
for k in pairs(t416) do
if not t428[k] then
v11037(k)
end
end
if u214 == 193796328 then
n2 = 497781270
n999 = 570472511
n1 += 304
u214 = 271258713
n1000 = 926587902
n1001 += 851
end
end
local function v11054()
local v11055 = p1508.MyPlot()
local v11056
if t402.EspBrainrots then
if type(p1508.SortedTargets) == "function" then
v11056 = p1508.SortedTargets()
else
v11056 = p1508.Targets()
end
v11056 = v11056 or {}
else
v11056 = {}
end
local v11057 = t402.EspBrainrots and type(p1508.Picked) == "function" and p1508.Picked()
or v11056[1]
local _, v11059 = p1508.Character()
local CurrentCamera = Workspace.CurrentCamera
local Position
if v11059 then
Position = v11059.Position
elseif CurrentCamera then
Position = CurrentCamera.CFrame.Position
else
Position = nil
end
local v11062 = t402.EspBaseXray and t412.Ticks >= t412.XrayDue
if t402.EspBrainrots then
v10967(v11056, v11057, Position, v11055)
end
v10987(v11057, v11055)
if t402.EspPlayers then
local StealHitbox = v11055 and v11055:FindFirstChild("StealHitbox")
local v11064 = v10999
local v11065 = Position
local v11066
if StealHitbox and StealHitbox:IsA("BasePart") then
v11066 = StealHitbox
else
v11066 = nil
end
v11064(v11065, v11066)
end
if v11062 then
t412.XrayDue = t412.Ticks + 10
v11048(v10949(v11055))
end
end
local function v11067()
t412.Ticks += 1
if t412.Ticks < 2 then
return
end
local Holder = t412.Holder
if Holder and not Holder.Parent then
t412.UseHui = false
v10934()
Holder = nil
end
if not Holder then
local v11069 = v10937()
t412.Holder = v11069
if not v11069 then
return
end
end
local ok, result = pcall(v11054)
if not ok then
p1508.Log("[visuals] render failed:", result)
if t412.UseHui and string.find(tostring(result), "apabilit", 1, true) then
t412.UseHui = false
v10934()
end
end
end
local function v11072()
return (t402.EspBrainrots or t402.EspPlayers or t402.EspBaseXray) and true or false
end
local function v11073(p1559)
if not t402.EspBrainrots then
v10916(t417.Brainrot)
end
if not t402.EspBrainrots or not t402.EspBestHighlight and not t402.EspBestTracer then
v10932()
end
if not t402.EspPlayers then
v10916(t417.Player)
end
if not t402.EspPlayers then
v10929()
end
if p1559 == "EspBaseXray" then
if t402.EspBaseXray then
v11043()
t412.XrayDue = 0
else
v11041()
end
end
if v11072() then
if not t412.Loop then
t412.Ticks = 0
t412.XrayDue = 0
t412.Loop = p1508.Loop(0.1, v11067)
end
elseif t412.Loop then
t412.Loop:Stop()
t412.Loop = nil
v10934()
end
if t402.EspBrainrots and t402.EspBestTracer then
if not t415.Loop then
t415.Loop = p1508.Loop(0, v10992)
end
elseif t415.Loop then
t415.Loop:Stop()
t415.Loop = nil
v10933()
end
end
t401.Set = function(p1560, p1561)
if t401.Defaults[p1560] == nil then
return
end
t402[p1560] = p1561
if n996 < 1027816381 then
v11073(p1560)
return
end
n996 = 75492727
n1000 += 292
n2 += 1056
n1001 += 1800
n999 += 1972
return nil
end
t401.Stop = function()
if t412.Loop then
t412.Loop:Stop()
t412.Loop = nil
end
if t415.Loop then
t415.Loop:Stop()
t415.Loop = nil
end
v10934()
v11041()
end
return t401
end
return v10639
end
Sources.Visuals = v10635()
end
v237()
v238 = function()
u202 = 435332279
u203 = 661876357
local function v11074()
local n1012 = 1048167457
local n1013
local n1014
local function v11078(p1562)
n1013 = 159288391
n1014 = 348531618
local LocalPlayer2 = p1562.LocalPlayer
local Config = p1562.Config
local u11082 = false
local connection
local n1015 = 0
local n1016 = 0
local u11086
local u11087
local u11088
local u11089
local u11090 = false
local n1017 = 0
local n1018 = 922700533
local v11093 = p1562.PlaceId == 99606176102979
local function v11094(p1563)
local v11095 = tonumber(p1563)
if v11095 == nil or v11095 ~= v11095 or v11095 == math.huge or v11095 == -math.huge then
return 28
end
return math.clamp(v11095, 16, 28)
end
Config.WalkSpeed = v11094(Config.WalkSpeed)
Config.WalkSpeedEnabled = Config.WalkSpeedEnabled == true
local function v11096()
local Character = LocalPlayer2.Character
if Character then
if Character.Parent then
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
or Character.PrimaryPart
local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
if n1014 == 348531618 then
if
HumanoidRootPart
and HumanoidRootPart.Parent
and HumanoidRootPart:IsA("BasePart")
and HumanoidRootPart:IsDescendantOf(Character)
and not HumanoidRootPart.Anchored
and Humanoid
and not (Humanoid.Health <= 0)
then
return Character, HumanoidRootPart, Humanoid
end
return nil
end
n2 += 1397
n1014 += 1187
n1013 -= 1792
u203 = 783919360
n1018 = 943410425
LPH_CRASH()
end
end
return nil
end
local t429 = {
IsStealing = function()
local attribute = LocalPlayer2:GetAttribute("Stealing")
if attribute == nil or attribute == false then
local Character = LocalPlayer2.Character
attribute = Character and Character:GetAttribute("Stealing")
end
return attribute ~= nil and attribute ~= false
end,
}
local function v11102()
return p1562.Busy and p1562.Busy() == true
end
local function v11103(p1564)
local v11104 = t429.IsStealing()
return not v11104 and p1562.CarpetActive and p1562.CarpetActive(p1564, v11104) == true
end
local function v11105()
u11086 = nil
u11087 = nil
u11088 = nil
u11089 = nil
u11090 = false
n1017 = 0
end
local function v11106(p1565, p1566, p1567)
local v11107, v11108 = v11096()
if v11107 == p1565 then
if v11108 == p1566 and not v11102() and not v11103(p1565) then
local function v11109()
if v11093 then
p1566:ApplyImpulse(p1566.AssemblyMass * (p1567 - p1566.AssemblyLinearVelocity))
else
p1566.AssemblyLinearVelocity = p1567
end
end
return pcall(v11109)
end
end
return false
end
local n1019
local function v11111()
n1019 = 763519201
if not u11089 or v11102() then
return
end
local v11112, v11113 = v11096()
if v11112 ~= u11088 or v11113 ~= u11089 or v11103(v11112) then
return
end
v11106(v11112, v11113, Vector3.new(0, v11113.AssemblyLinearVelocity.Y, 0))
if n2 ~= n1012 then
return
end
n1013 += 1184
n1012 = 444495374
n1018 -= 809
n1019 += 424
n2 = 466301361
return (nil)()
end
local function v11114(p1568)
if p1562.Log then
pcall(p1562.Log, "Walkspeed: " .. tostring(p1568))
end
end
local function v11115()
if u11082 then
return
end
if Config.WalkSpeedEnabled ~= true then
v11111()
v11105()
return
end
if v11102() then
v11105()
return
end
local v11116, v11117, v11118 = v11096()
if not v11116 or v11103(v11116) then
v11105()
return
end
if v11116 ~= u11086 or v11117 ~= u11087 then
v11105()
u11086 = v11116
u11087 = v11117
end
local v11119 = v11118.MoveDirection.Magnitude >= 0.05
if u11090 and not v11119 then
n1017 = n1015 + 0.08
end
u11090 = v11119
v11106(v11116, v11117, Vector3.new(0, v11117.AssemblyLinearVelocity.Y, 0))
end
local function v11120()
if connection then
connection:Disconnect()
connection = nil
end
end
local function v11121()
if connection or u11082 then
return
end
n1015 = 0
n1016 = 0
connection = p1562.RunService.Heartbeat:Connect(function(dt)
if u11082 then
return
end
n1015 += dt
n1016 += dt
if n1016 < 0.03 then
return
end
n1016 %= 0.03
local ok, result = pcall(v11115)
if not ok then
v11114(result)
end
end)
end
t429.SetSpeed = function(p1569)
local v11124 = v11094(p1569)
if not u11082 then
Config.WalkSpeed = v11124
end
return v11124
end
t429.SetEnabled = function(p1570)
if u11082 then
return false
end
Config.WalkSpeedEnabled = p1570 == true
if Config.WalkSpeedEnabled then
v11121()
else
v11120()
local ok, result = pcall(v11111)
v11105()
if not ok then
v11114(result)
end
end
return Config.WalkSpeedEnabled
end
t429.IsEnabled = function()
if u203 == 661876357 then
return not u11082 and Config.WalkSpeedEnabled == true
end
n1014 += 1997
u203 -= 367
n2 -= 1706
n1018 = 623477048
n1013 += 1049
end
t429.Stop = function()
if u11082 then
return
end
u11082 = true
Config.WalkSpeedEnabled = false
v11120()
local ok, result = pcall(v11111)
v11105()
if not ok then
v11114(result)
end
end
if Config.WalkSpeedEnabled then
v11121()
end
return t429
end
return v11078
end
t15.X.WalkFactory = v11074()
end
v238()
v239 = function()
local X = t15.X
local function v11130(p1571)
local ok, result = pcall(X.Sources[p1571], X.Ctx)
if ok and type(result) == "table" then
X.Features[p1571] = result
local pairs_ = pairs
local Defaults = result.Defaults or {}
for k, Default in pairs_(Defaults) do
local v11137 = X.Path(k)
if X.CONV[k] == nil and t15.get(v11137) == nil then
X.Quiet(v11137, Default)
end
X.Owners[k] = result
t15.bind(v11137, function(p1572)
if X.Silent > 0 or not X.Live() then
return
end
local v11138 = X.CONV[k]
if v11138 then
p1572 = v11138(p1572)
end
local ok2, result2 = pcall(result.Set, k, p1572)
if not ok2 then
X.Log("Feature Set error", k, result2)
end
end)
end
else
X.Log("Module failed to load", p1571, result)
end
end
v11130("Invisible")
v11130("Protection")
v11130("Movement")
t15.lateEngine(function()
v11130("Visuals")
end)
end
v239()
v240 = function()
local n1020 = 646912218
local X = t15.X
local n1021 = 612699341
local n1022 = 727050760
X.FlyHeld = function(p1573)
if not p1573 then
return nil
end
local Tool = t15.get("TpSettings.Tool")
if type(Tool) ~= "string" or Tool == "" then
Tool = "Flying Carpet"
end
local v11146 = p1573:FindFirstChild(Tool)
return v11146 and v11146:IsA("Tool") and v11146 or nil
end
local t430 = {
WalkSpeed = "WalkSpeedValue",
WalkSpeedEnabled = "WalkSpeedEnabled",
}
local ok, walk = pcall(X.WalkFactory, {
LocalPlayer = LocalPlayer,
RunService = RunService,
Config = setmetatable({}, {
__index = function(p1574, p1575)
local v11150 = t430[p1575]
if v11150 then
return t15.get(v11150)
end
return nil
end,
__newindex = function(p1576, p1577, p1578)
local v11151 = t430[p1577]
if v11151 then
X.Quiet(v11151, p1578)
end
end,
}),
PlaceId = game.PlaceId,
Busy = function()
return X.Dropping == true or X.Resetting == true
end,
CarpetActive = function(p1579, p1580)
if not p1580 then
if t15.get("CarpetSpeed") == true then
return X.FlyHeld(p1579) ~= nil
end
end
return false
end,
Log = X.Log,
})
if not ok then
X.Log("Walkspeed failed to load", walk)
return
end
X.Walk = walk
if n2 == 557240548 then
t15.bind("WalkSpeedEnabled", function(p1581)
if X.Silent > 0 or not X.Live() then
return
end
walk.SetEnabled(p1581 == true)
end)
else
n1 += 920
n1021 += 569
n2 -= 935
n1022 = 607722374
n1020 -= 956
n4 += 172
upv323 = nil
bit32.bxor(nil, nil)
end
t15.bind("WalkSpeedValue", function(p1582)
if X.Silent > 0 or not X.Live() then
return
end
if n4 < n1022 then
walk.SetSpeed(p1582)
else
n2 -= 827
n4 += 1143
n1022 = 402743511
n1 += 876
n1020 = 122899473
n1021 = 978959378
(nil)[407] = nil
(nil)[408] = nil
(nil)[409] = nil
(nil)[410] = nil
(nil)[411] = nil
(nil)[412] = nil
(nil)[413] = nil
(nil)[414] = nil
(nil)[415] = nil
(nil)[416] = nil
(nil)[417] = nil
(nil)[418] = nil
(nil)[419] = nil
(nil)[420] = nil
(nil)[421] = nil
(nil)[422] = nil
(nil)[423] = nil
(nil)[424] = nil
(nil)[425] = nil
(nil)[426] = nil
(nil)[427] = nil
(nil)[428] = nil
(nil)[429] = nil
(nil)[430] = nil
(nil)[431] = nil
(nil)[432] = nil
(nil)[433] = nil
(nil)[434] = nil
(nil)[435] = nil
(nil)[436] = nil
(nil)[437] = nil
(nil)[438] = nil
(nil)[439] = nil
(nil)[440] = nil
(nil)[441] = nil
(nil)[442] = nil
(nil)[443] = nil
(nil)[444] = nil
(nil)[445] = nil
(nil)[446] = nil
(nil)[447] = nil
(nil)[448] = nil
(nil)[449] = nil
(nil)[450] = nil
(nil)[451] = nil
(nil)[452] = nil
(nil)[453] = nil
(nil)[454] = nil
(nil)[455] = nil
(nil)[456] = nil
(nil)[457] = nil
(nil)[458] = nil
(nil)[459] = nil
(nil)[460] = nil
(nil)[461] = nil
(nil)[462] = nil
(nil)[463] = nil
(nil)[464] = nil
(nil)[465] = nil
(nil)[466] = nil
(nil)[467] = nil
(nil)[468] = nil
(nil)[469] = nil
(nil)[470] = nil
(nil)[471] = nil
(nil)[472] = nil
(nil)[473] = nil
(nil)[474] = nil
(nil)[475] = nil
(nil)[476] = nil
(nil)[477] = nil
(nil)[478] = nil
(nil)[479] = nil
(nil)[480] = nil
(nil)[481] = nil
(nil)[482] = nil
(nil)[483] = nil
(nil)[484] = nil
(nil)[485] = nil
(nil)[486] = nil
(nil)[487] = nil
(nil)[488] = nil
(nil)[489] = nil
(nil)[490] = nil
(nil)[491] = nil
(nil)[492] = nil
(nil)[493] = nil
(nil)[494] = nil
(nil)[495] = nil
(nil)[496] = nil
(nil)[497] = nil
(nil)[498] = nil
(nil)[499] = nil
(nil)[500] = nil
(nil)[501] = nil
(nil)[502] = nil
(nil)[503] = nil
(nil)[504] = nil
(nil)[505] = nil
(nil)[506] = nil
(nil)[507] = nil
(nil)[508] = nil
(nil)[509] = nil
(nil)[510] = nil
(nil)[511] = nil
(nil)[512] = nil
(nil)[513] = nil
(nil)[514] = nil
(nil)[515] = nil
(nil)[516] = nil
(nil)[517] = nil
(nil)[518] = nil
(nil)[519] = nil
(nil)[520] = nil
(nil)[521] = nil
(nil)[522] = nil
(nil)[523] = nil
(nil)[524] = nil
(nil)[525] = nil
(nil)[526] = nil
(nil)[527] = nil
(nil)[528] = nil
(nil)[529] = nil
(nil)[530] = nil
(nil)[531] = nil
(nil)[532] = nil
(nil)[533] = nil
(nil)[534] = nil
(nil)[535] = nil
(nil)[536] = nil
(nil)[537] = nil
(nil)[538] = nil
(nil)[539] = nil
(nil)[540] = nil
(nil)[541] = nil
(nil)[542] = nil
(nil)[543] = nil
(nil)[544] = nil
(nil)[545] = nil
(nil)[546] = nil
(nil)[547] = nil
(nil)[548] = nil
(nil)[549] = nil
(nil)[550] = nil
(nil)[551] = nil
(nil)[552] = nil
(nil)[553] = nil
(nil)[554] = nil
(nil)[555] = nil
(nil)[556] = nil
(nil)[557] = nil
(nil)[558] = nil
(nil)[559] = nil
(nil)[560] = nil
(nil)[561] = nil
(nil)[562] = nil
(nil)[563] = nil
(nil)[564] = nil
(nil)[565] = nil
(nil)[566] = nil
(nil)[567] = nil
(nil)[568] = nil
(nil)[569] = nil
(nil)[570] = nil
(nil)[571] = nil
(nil)[572] = nil
(nil)[573] = nil
(nil)[574] = nil
(nil)[575] = nil
(nil)[576] = nil
(nil)[577] = nil
(nil)[578] = nil
(nil)[579] = nil
(nil)[580] = nil
(nil)[581] = nil
(nil)[582] = nil
(nil)[583] = nil
(nil)[584] = nil
(nil)[585] = nil
(nil)[586] = nil
(nil)[587] = nil
(nil)[588] = nil
(nil)[589] = nil
(nil)[590] = nil
(nil)[591] = nil
(nil)[592] = nil
(nil)[593] = nil
(nil)[594] = nil
(nil)[595] = nil
(nil)[596] = nil
(nil)[597] = nil
(nil)[598] = nil
(nil)[599] = nil
(nil)[600] = nil
(nil)[601] = nil
(nil)[602] = nil
(nil)[603] = nil
(nil)[604] = nil
(nil)[605] = nil
(nil)[606] = nil
(nil)[607] = nil
(nil)[608] = nil
(nil)[609] = nil
(nil)[610] = nil
(nil)[611] = nil
(nil)[612] = nil
(nil)[613] = nil
(nil)[614] = nil
(nil)[615] = nil
(nil)[616] = nil
(nil)[617] = nil
(nil)[618] = nil
(nil)[619] = nil
(nil)[620] = nil
(nil)[621] = nil
(nil)[622] = nil
(nil)[623] = nil
(nil)[624] = nil
(nil)[625] = nil
(nil)[626] = nil
(nil)[627] = nil
(nil)[628] = nil
(nil)[629] = nil
(nil)[630] = nil
(nil)[631] = nil
(nil)[632] = nil
(nil)[633] = nil
(nil)[634] = nil
(nil)[635] = nil
(nil)[636] = nil
(nil)[637] = nil
(nil)[638] = nil
(nil)[639] = nil
(nil)[640] = nil
(nil)[641] = nil
(nil)[642] = nil
(nil)[643] = nil
(nil)[644] = nil
(nil)[645] = nil
(nil)[646] = nil
(nil)[647] = nil
(nil)[648] = nil
(nil)[649] = nil
(nil)[650] = nil
(nil)[651] = nil
(nil)[652] = nil
(nil)[653] = nil
(nil)[654] = nil
(nil)[655] = nil
(nil)[656] = nil
(nil)[657] = nil
(nil)[658] = nil
(nil)[659] = nil
(nil)[660] = nil
(nil)[661] = nil
(nil)[662] = nil
(nil)[663] = nil
(nil)[664] = nil
(nil)[665] = nil
(nil)[666] = nil
(nil)[667] = nil
(nil)[668] = nil
(nil)[669] = nil
(nil)[670] = nil
(nil)[671] = nil
(nil)[672] = nil
(nil)[673] = nil
(nil)[674] = nil
(nil)[675] = nil
(nil)[676] = nil
(nil)[677] = nil
(nil)[678] = nil
(nil)[679] = nil
(nil)[680] = nil
(nil)[681] = nil
(nil)[682] = nil
(nil)[683] = nil
(nil)[684] = nil
(nil)[685] = nil
(nil)[686] = nil
(nil)[687] = nil
(nil)[688] = nil
(nil)[689] = nil
(nil)[690] = nil
(nil)[691] = nil
(nil)[692] = nil
(nil)[693] = nil
(nil)[694] = nil
(nil)[695] = nil
(nil)[696] = nil
(nil)[697] = nil
(nil)[698] = nil
(nil)[699] = nil
(nil)[700] = nil
(nil)[701] = nil
(nil)[702] = nil
(nil)[703] = nil
(nil)[704] = nil
(nil)[705] = nil
(nil)[706] = nil
(nil)[707] = nil
(nil)[708] = nil
(nil)[709] = nil
(nil)[710] = nil
(nil)[711] = nil
(nil)[712] = nil
(nil)[713] = nil
(nil)[714] = nil
(nil)[715] = nil
(nil)[716] = nil
(nil)[717] = nil
(nil)[718] = nil
(nil)[719] = nil
(nil)[720] = nil
(nil)[721] = nil
(nil)[722] = nil
(nil)[723] = nil
(nil)[724] = nil
(nil)[725] = nil
(nil)[726] = nil
(nil)[727] = nil
(nil)[728] = nil
(nil)[729] = nil
(nil)[730] = nil
(nil)[731] = nil
(nil)[732] = nil
(nil)[733] = nil
(nil)[734] = nil
(nil)[735] = nil
(nil)[736] = nil
(nil)[737] = nil
(nil)[738] = nil
(nil)[739] = nil
(nil)[740] = nil
(nil)[741] = nil
(nil)[742] = nil
(nil)[743] = nil
(nil)[744] = nil
(nil)[745] = nil
(nil)[746] = nil
(nil)[747] = nil
(nil)[748] = nil
(nil)[749] = nil
(nil)[750] = nil
(nil)[751] = nil
(nil)[752] = nil
(nil)[753] = nil
(nil)[754] = nil
(nil)[755] = nil
(nil)[756] = nil
(nil)[757] = nil
(nil)[758] = nil
(nil)[759] = nil
(nil)[760] = nil
(nil)[761] = nil
(nil)[762] = nil
(nil)[763] = nil
(nil)[764] = nil
(nil)[765] = nil
(nil)[766] = nil
(nil)[767] = nil
(nil)[768] = nil
(nil)[769] = nil
(nil)[770] = nil
(nil)[771] = nil
(nil)[772] = nil
(nil)[773] = nil
(nil)[774] = nil
(nil)[775] = nil
(nil)[776] = nil
(nil)[777] = nil
(nil)[778] = nil
(nil)[779] = nil
(nil)[780] = nil
(nil)[781] = nil
(nil)[782] = nil
(nil)[783] = nil
(nil)[784] = nil
(nil)[785] = nil
(nil)[786] = nil
(nil)[787] = nil
(nil)[788] = nil
(nil)[789] = nil
(nil)[790] = nil
(nil)[791] = nil
(nil)[792] = nil
(nil)[793] = nil
(nil)[794] = nil
(nil)[795] = nil
(nil)[796] = nil
(nil)[797] = nil
(nil)[798] = nil
(nil)[799] = nil
(nil)[800] = nil
(nil)[801] = nil
(nil)[802] = nil
(nil)[803] = nil
(nil)[804] = nil
(nil)[805] = nil ^ nil
(nil)[806] = nil
(nil)[807] = nil
(nil)[808] = nil
(nil)[809] = nil
(nil)[810] = nil
(nil)[811] = nil
(nil)[812] = nil
(nil)[813] = nil
(nil)[814] = nil
(nil)[815] = nil
(nil)[816] = nil
(nil)[817] = nil
(nil)[818] = nil
(nil)[819] = nil
(nil)[820] = nil
end
end)
end
v240()
v241 = function()
local X = t15.X
local C = t15.C
local n1023 = 784869159
local NATIVE = t15.NATIVE
local NASK = t15.NASK
local v11157 = LocalPlayer
local n1024 = 927054735
local n1025 = 799731919
local admin = {
Data = nil,
Until = {},
LastHit = {},
Busy = false,
Marked = {},
Pending = {},
Done = {},
Near = {},
NearLights = {},
Spin = 0,
ClickIdx = 0,
UserCooldown = 10,
Remote = nil,
Key = nil,
WarnAt = -math.huge,
}
X.Admin = admin
admin.Content = function()
local AdminPanel = v11157:FindFirstChildOfClass("PlayerGui")
and v11157.PlayerGui:FindFirstChild("AdminPanel")
local GuiObject = AdminPanel and AdminPanel:FindFirstChildWhichIsA("GuiObject")
return GuiObject
and GuiObject:FindFirstChild("Content")
and GuiObject.Content:FindFirstChild("ScrollingFrame")
end
admin.Resolve = function()
if admin.Remote and admin.Remote.Parent and admin.Key then
return admin.Remote, admin.Key
end
local Controllers = game:GetService("ReplicatedStorage"):FindFirstChild("Controllers")
local v11164, v11165 = X.GameRequire(Controllers and Controllers:FindFirstChild("AdminPanelController"), 10)
if not v11164 or type(v11165) ~= "table" then
return nil, nil
end
local t431 = {}
local t432 = {}
local function v11168(p1583, p1584)
if p1584 > 5 or t431[p1583] or #t432 > 0 then
return
end
t431[p1583] = true
local ok, result = pcall(debug.getconstants, p1583)
local ok2, result2 = pcall(debug.getupvalues, p1583)
local v11173 = ok2 and result2 or {}
if not ok or not table.find(result, "InvokeServer") then
for _, v in v11173, nil, nil do
if type(v) == "function" then
v11168(v, p1584 + 1)
elseif type(v) == "table" then
for _, v2 in v, nil, nil do
if type(v2) == "function" then
v11168(v2, p1584 + 1)
end
end
end
end
return
end
for _, v in result, nil, nil do
if type(v) == "string" and string.match(v, "^%x+%-%x+%-%x+%-%x+%-%x+$") then
t432[#t432 + 1] = v
end
end
for _, v in v11173, nil, nil do
if type(v) == "table" then
local _, v11183 = next(v)
if type(v11183) == "table" and type(rawget(v11183, "cooldown")) == "number" then
admin.Data = v
end
end
end
end
for _, v in v11165, nil, nil do
if n1024 == 927054996 then
n1024 += 1699
n4 = 67104652
n1 = 754530275
n1025 = 550230878
n2 += 144
n1023 = 288593002
upv148 = nil
upv288[nil] = nil
(nil)()
elseif type(v) == "function" then
v11168(v, 0)
end
end
local v11186
local v11187
for _, v in t432, nil, nil do
local ok, result = pcall(X.ResolveRemote, v, true)
if ok and result then
v11186 = result
else
v11187 = v11187 or v
end
end
admin.Remote = v11186
admin.Key = v11187
X.Log(
"Admin resolve",
"ids=" .. #t432,
"remote=" .. tostring(v11186),
"key=" .. tostring(v11187 ~= nil),
"data=" .. tostring(admin.Data ~= nil)
)
return v11186, v11187
end
admin.Left = function(p1585)
local v11192 = admin.Until[p1585]
if not v11192 then
return 0, 1
end
local v11193 = v11192[1] - workspace:GetServerTimeNow()
if v11193 <= 0 then
admin.Until[p1585] = nil
return 0, 1
end
return v11193, v11192[2]
end
admin.Hold = function(p1586, p1587, p1588)
local v11194 = admin.Until[p1586]
if v11194 then
if p1587 - 0.5 <= v11194[1] then
return
end
end
admin.Until[p1586] = {
p1587,
math.max(p1588, 0.1),
}
end
admin.Banned = function(p1589)
local Data = admin.Data and admin.Data[p1589]
local v11196 = string.lower(p1589 .. " " .. tostring(Data and Data.name or ""))
if n2 ~= n1024 then
return string.find(v11196, "control", 1, true) ~= nil
end
n1025 = 903913249
n2 -= 1266
n1023 -= 409
n1024 += 1509
n4 += 971
n1 = 443042808
(nil)(nil, nil)
end
local function v11197(p1590)
local function v11198()
if type(firesignal) == "function" then
pcall(firesignal, p1590.MouseButton1Click)
pcall(firesignal, p1590.MouseButton1Down)
pcall(firesignal, p1590.MouseButton1Up)
pcall(firesignal, p1590.Activated)
else
local VirtualInputManager = game:GetService("VirtualInputManager")
local v11200 = p1590.AbsolutePosition.X + p1590.AbsoluteSize.X / 2
local v11201 = p1590.AbsolutePosition.Y + p1590.AbsoluteSize.Y / 2 + 58
VirtualInputManager:SendMouseButtonEvent(v11200, v11201, 0, true, game, 0)
VirtualInputManager:SendMouseButtonEvent(v11200, v11201, 0, false, game, 0)
end
end
return pcall(v11198)
end
local function v11202(p1591, p1592)
local PlayerGui = v11157:FindFirstChildOfClass("PlayerGui")
local AdminPanel = PlayerGui and PlayerGui:FindFirstChild("AdminPanel")
if not AdminPanel then
return false
end
local Enabled = AdminPanel.Enabled
AdminPanel.Enabled = true
local ok, result = pcall(function()
return AdminPanel.AdminPanel.Content.ScrollingFrame
end)
local v11208 = ok and result and result:FindFirstChild(p1592)
if not v11208 then
AdminPanel.Enabled = Enabled
return false
end
v11197(v11208)
task.wait(0.01)
local ok2, result2 = pcall(function()
return AdminPanel.AdminPanel.Profiles.ScrollingFrame
end)
if not ok2 or not result2 then
AdminPanel.Enabled = Enabled
return false
end
local v11211 = result2:FindFirstChild(p1591.Name)
if not v11211 then
for _, child in ipairs(result2:GetChildren()) do
if child:IsA("GuiButton") then
local TextLabel = child:FindFirstChildWhichIsA("TextLabel")
if TextLabel and (TextLabel.Text == p1591.Name or TextLabel.Text == p1591.DisplayName) then
v11211 = child
break
end
end
end
end
if not v11211 then
AdminPanel.Enabled = Enabled
return false
end
v11197(v11211)
local n1026
task.delay(0.05, function()
n1026 = 948117802
if AdminPanel.Parent then
AdminPanel.Enabled = Enabled
end
if n1024 == 927054897 then
n1024 = 858105281
n1026 -= 1137
n4 = 591007987
n2 += 1190
end
end)
return true
end
admin.Ready = function()
return admin.Remote ~= nil and admin.Key ~= nil or admin.Content() ~= nil
end
local n1027
admin.Run = function(p1593, p1594)
n1027 = 89567471
if admin.Pending[p1594] or admin.Left(p1594) > 0 or admin.Left(p1593) > 0 then
return false
end
local v11217, v11218 = admin.Resolve()
if not v11217 or not v11218 then
admin.Pending[p1594] = true
local v11219 = v11202(p1593, p1594)
admin.Pending[p1594] = nil
if v11219 then
local Data = admin.Data and admin.Data[p1594]
local v11221 = Data and tonumber(Data.cooldown)
if v11221 then
admin.Hold(p1594, workspace:GetServerTimeNow() + v11221, v11221)
end
elseif os.clock() - admin.WarnAt > 10 then
admin.WarnAt = os.clock()
X.Notify("Admin remote not found on this server")
end
return v11219
end
admin.Pending[p1594] = true
local ok, result, result2 = pcall(v11217.InvokeServer, v11217, v11218, p1593, p1594)
admin.Pending[p1594] = nil
if not ok then
X.Log("Admin invoke failed", p1594, p1593.Name, result)
return false
end
if not result then
local serverTimeNow = workspace:GetServerTimeNow()
local v11226 = admin.LastHit[p1593]
if v11226 and serverTimeNow - v11226 < admin.UserCooldown then
admin.Hold(p1593, v11226 + admin.UserCooldown, admin.UserCooldown)
else
local Data = admin.Data and admin.Data[p1594]
local v11228 = Data and tonumber(Data.cooldown)
if v11228 then
admin.Hold(p1594, serverTimeNow + v11228, v11228)
end
end
return false
end
local serverTimeNow
if type(result2) == "number" then
serverTimeNow = result2
else
serverTimeNow = workspace:GetServerTimeNow()
end
admin.LastHit[p1593] = serverTimeNow
local Data = admin.Data and admin.Data[p1594]
local v11231 = Data and tonumber(Data.cooldown)
if v11231 then
admin.Hold(p1594, serverTimeNow + v11231, v11231)
end
if n1027 == 89567471 then
return true
end
n1025 = 961311752
n1024 += 1647
n2 -= 697
n1023 = 279460861
n1027 += 960
n4 = 186287136
n1 = 421152057
end
admin.Sync = function()
local v11232 = admin.Content()
if not v11232 then
return
end
for _, v in ipairs(t15.AP) do
local v11235 = v11232:FindFirstChild(v)
local CooldownFrame = v11235 and v11235:FindFirstChild("CooldownFrame")
local Timer = v11235 and v11235:FindFirstChild("Timer")
if
CooldownFrame
and CooldownFrame:IsA("GuiObject")
and CooldownFrame.Visible
and Timer
and Timer:IsA("TextLabel")
then
local v11238 = tonumber(string.match(Timer.Text, "%d+"))
local Data = admin.Data and admin.Data[v]
if v11238 and v11238 > 0 then
admin.Hold(v, workspace:GetServerTimeNow() + v11238, Data and tonumber(Data.cooldown) or v11238)
end
end
end
end
local function v11240(p1595)
local Character = p1595.Character
if Character then
if Character:FindFirstChild("KaWaifu_NeonHighlight") then
return "Kawaifu"
end
end
if X.IsBT and X.IsBT(p1595) then
return "Braintopia"
end
return nil
end
local function apBlocked(p1596, p1597)
if not p1596 or p1596 == v11157 or p1596.Parent ~= Players then
return true
end
if t15.apBlocked and t15.apBlocked(p1596) then
return true
end
local v11243 = v11240(p1596)
return v11243 ~= nil and p1597 ~= nil and C["Disable" .. p1597 .. "On" .. v11243] == true
end
X.APBlocked = apBlocked
local function v11244()
return 0.25
end
local n1028
local function v11246()
n1028 = 772524740
local AdminPanelOrder = C.AdminPanelOrder
if type(AdminPanelOrder) ~= "table" or #AdminPanelOrder == 0 then
AdminPanelOrder = t15.AP
end
if n4 == 616969873 then
return AdminPanelOrder
end
n2 = 764927004
n1024 += 1277
n4 = 428954142
n1025 = 376059980
n1028 -= 934
n1 -= 1690
n1023 -= 183
(nil)()
LPH_CRASH()
end
local function v11248(p1598, p1599)
local t433 = {}
local v11250 = C[p1598]
local AP = C[p1599]
if type(AP) ~= "table" or #AP == 0 then
AP = t15.AP
end
for _, v in ipairs(AP) do
if type(v11250) ~= "table" or v11250[v] == true then
t433[#t433 + 1] = v
end
end
return t433
end
X.AdminRunList = function(p1600, p1601, p1602)
local n1029 = 0
for _, v in ipairs(p1601) do
if X.Live() and p1600.Parent == Players and not (admin.Left(p1600) > 0) then
if admin.Banned(v) or not (admin.Left(v) <= 0) then
continue
end
if admin.Run(p1600, v) then
n1029 += 1
if not p1602 then
task.wait(v11244())
continue
end
else
task.wait(v11244())
continue
end
end
break
end
return n1029
end
local function v11257(p1603, p1604)
local v11258 = X.Track(Instance.new("Highlight"))
v11258.FillColor = p1603
v11258.OutlineColor = p1603
v11258.FillTransparency = p1604
v11258.OutlineTransparency = 0
v11258.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
v11258.Parent = t15.sg
return v11258
end
NATIVE["Admin Command"] = function(p1605, p1606)
if not apBlocked(p1605, "APPanel") then
if not (admin.Left(p1606) > 0) then
if not admin.Run(p1605, p1606) then
X.Notify(p1606 .. " on " .. p1605.DisplayName .. " did not go through")
end
return
end
X.Notify(p1606 .. " is on cooldown")
return
end
X.Notify((p1605 and p1605.DisplayName or "Player") .. " is skipped")
end
NATIVE["Admin Fire All"] = function(p1607)
local n1030 = 314376212
if apBlocked(p1607, "APPanel") then
return
end
if X.AdminRunList(p1607, v11246(), false) == 0 then
X.Notify("All commands on cooldown")
end
if n4 == n1030 then
n1023 = 130571145
n4 += 692
n1024 = 395934346
n1 += 1889
n2 = 866910302
n1025 -= 976
(nil)[144] = nil
(nil)[145] = nil
(nil)[146] = nil
(nil)[147] = nil
(nil)[148] = nil
(nil)[149] = nil
(nil)[150] = nil
(nil)[151] = nil
(nil)[152] = nil
(nil)[153] = nil
(nil)[154] = nil
(nil)[155] = nil
(nil)[156] = nil
(nil)[157] = nil
(nil)[158] = nil
(nil)[159] = nil
(nil)[160] = nil
(nil)[161] = nil
(nil)[162] = nil
(nil)[163] = nil
(nil)[164] = nil
(nil)[165] = nil
(nil)[166] = nil
(nil)[167] = nil
(nil)[168] = nil
(nil)[169] = nil
(nil)[170] = nil
(nil)[171] = nil
(nil)[172] = nil
(nil)[173] = nil
(nil)[174] = nil
(nil)[175] = nil
(nil)[176] = nil
(nil)[177] = nil
(nil)[178] = nil
(nil)[179] = nil
(nil)[180] = nil
(nil)[181] = nil
(nil)[182] = nil
(nil)[183] = nil
(nil)[184] = nil
(nil)[185] = nil
(nil)[186] = nil
(nil)[187] = nil
end
end
NATIVE["Ragdoll Self"] = function()
if admin.Left("ragdoll") > 0 then
X.Notify("ragdoll is on cooldown")
return
end
if not admin.Run(v11157, "ragdoll") then
X.Notify("Ragdoll self did not go through")
end
end
admin.Toggle = function(p1608)
if not p1608 or p1608 == v11157 then
return
end
admin.Done[p1608] = nil
local v11260 = admin.Marked[p1608]
if v11260 then
v11260:Destroy()
admin.Marked[p1608] = nil
X.Notify("Stopped spamming " .. p1608.DisplayName)
elseif apBlocked(p1608, nil) then
X.Notify(p1608.DisplayName .. " is protected or blacklisted")
else
local v11261 = v11257(t15.T.Bad, 0.75)
v11261.Adornee = p1608.Character
admin.Marked[p1608] = v11261
X.Notify("Spamming " .. p1608.DisplayName, "Good")
end
end
NATIVE["Admin Mark"] = function(p1609)
admin.Toggle(p1609)
end
NASK["Admin Marked"] = function(p1610)
return admin.Marked[p1610] ~= nil
end
NASK.Cooldown = function(p1611)
local v11262 = admin.Left(p1611)
if n1024 ~= n1025 then
return v11262 > 0 and math.ceil(v11262) or 0
end
n1025 = 532065186
n1 = 575152662
n4 = 808211158
n1023 -= 1168
n1024 -= 904
n2 += 182
end
local function who(p1612)
if typeof(p1612) == "Instance" and p1612:IsA("Player") then
return p1612
end
if type(p1612) == "number" then
return Players:GetPlayerByUserId(p1612)
end
if type(p1612) == "string" then
return Players:FindFirstChild(p1612)
or tonumber(p1612) and Players:GetPlayerByUserId(tonumber(p1612))
or nil
end
if type(p1612) == "table" and p1612.Name then
return Players:FindFirstChild(p1612.Name)
end
return nil
end
X.Who = who
local function plotOwner(p1613)
local ok, result = pcall(X.GetPlotCaches)
local v11267 = X.Snap.Cache(p1613.Name, ok and type(result) == "table" and result[p1613.Name] or nil)
local v11268 = type(v11267) == "table" and who(v11267.Owner) or nil
local n1031 = 727175794
if v11268 then
return v11268
end
local PlotSign = p1613:FindFirstChild("PlotSign")
local SurfaceGui = PlotSign and PlotSign:FindFirstChild("SurfaceGui")
local n1032 = 276423226
local Frame = SurfaceGui and SurfaceGui:FindFirstChild("Frame")
local TextLabel = Frame and Frame:FindFirstChild("TextLabel")
local match = TextLabel and (TextLabel.Text:match("^(.-)'") or TextLabel.Text)
if not match then
return nil
end
local v11276, v11277, v11278 = ipairs(Players:GetPlayers())
local v11279 = geniter(v11276, v11277, v11278)
local v11280
repeat
local v11281 = table.pack(v11279())
if not v11281[1] then
return nil
end
v11280 = v11281[3]
until v11280.DisplayName == match or v11280.Name == match
if n1025 == n1032 then
local n1033
repeat
n1 = 17247255
n1033 = 555501886
n1025 = 457289047
n1024 = 436979262
n1031 -= 1228
n4 = 1050375420
n1023 = 60636033
n2 += 698
repeat
local v11283 = table.pack(v11279())
if not v11283[1] then
return nil
end
v11280 = v11283[3]
until v11280.DisplayName == match or v11280.Name == match
until n1025 ~= n1033
end
return v11280
end
X.PlotOwner = plotOwner
local function v11284()
local Character = v11157.Character
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
local Plots = workspace:FindFirstChild("Plots")
if not HumanoidRootPart or not Plots then
return nil
end
local v11288 = X.MyPlot()
local v11289
local huge = math.huge
for _, child in ipairs(Plots:GetChildren()) do
local PlotSign = child ~= v11288 and child:FindFirstChild("PlotSign")
if n1024 == n1 then
n1025 = 390132809
n1 = 267791860
n4 -= 1016
n1023 += 1252
n1024 -= 998
n2 = 164564273
elseif not PlotSign and child ~= v11288 and X.OptiActive() then
PlotSign = child:FindFirstChild("DeliveryHitbox")
end
local YourBase = PlotSign and PlotSign:FindFirstChild("YourBase")
if PlotSign and (not YourBase or not YourBase.Enabled) then
local isBasePart = PlotSign:IsA("BasePart") and PlotSign
or PlotSign:FindFirstChildWhichIsA("BasePart", true)
if isBasePart then
local Magnitude = (HumanoidRootPart.Position - isBasePart.Position).Magnitude
if Magnitude < huge then
huge = Magnitude
v11289 = child
end
end
end
end
return v11289 and plotOwner(v11289) or nil
end
local function v11297(p1614)
if not p1614 or p1614 == v11157 then
X.Notify("Owner not found")
return
end
if apBlocked(p1614, nil) then
X.Notify(p1614.DisplayName .. " is protected or blacklisted")
return
end
X.Notify("Spamming " .. p1614.DisplayName)
local v11298 = X.AdminRunList(
p1614,
v11248("SpamBaseOwnerCommands", "SpamBaseOwnerOrder"),
C.SpamBaseOwnerSingleCommand == true
)
X.Notify(
"Sent " .. v11298 .. " command" .. (v11298 == 1 and "" or "s") .. " to " .. p1614.DisplayName,
v11298 > 0 and "Good" or nil
)
end
NATIVE["Spam Base Owner"] = function()
v11297(v11284())
end
local n1034
NATIVE["Spam Best Owner"] = function()
n1034 = 691978688
local v11300 = X.PriorityTargets()
if #v11300 == 0 then
v11300 = X.Targets()
end
for _, v in ipairs(v11300) do
local v11303 = who(v.Owner)
if v11303 and v11303 ~= v11157 then
v11297(v11303)
return
end
end
local v11304 = t6_29_1[2]
local v11305 = t6_29_1[1]
X.Notify("No brainrots found in this server yet")
if n4 == 61765716 then
n1023 = 434717771
n2 = 174822011
n1025 = 203487352
n1 = 852660279
n4 -= 516
n1024 = 380103105
n1034 -= 182
v11305[v11304] = nil
(nil)[nil] = nil
end
end
t15.lateEngine(function()
local n1035 = 198463388
local n1036 = 231543067
local function v11308(p1615, p1616, p1617, p1618)
local v11309 = p1618 / 2
local v11310 = p1617 - Vector3.new(v11309, v11309, v11309)
local v11311 = p1617 + Vector3.new(v11309, v11309, v11309)
local X2 = p1616.X == 0 and 0.0001 or p1616.X
local Y = p1616.Y == 0 and 0.0001 or p1616.Y
local Z = p1616.Z == 0 and 0.0001 or p1616.Z
local v11315 = (v11310.X - p1615.X) / X2
local v11316 = (v11311.X - p1615.X) / X2
if v11316 < v11315 then
local v11317 = v11315
v11315 = v11316
v11316 = v11317
end
local v11318 = (v11310.Y - p1615.Y) / Y
local v11319 = (v11311.Y - p1615.Y) / Y
if v11319 < v11318 then
local v11320 = v11318
v11318 = v11319
v11319 = v11320
end
if v11319 < v11315 or v11316 < v11318 then
return false
end
if v11315 < v11318 then
v11315 = v11318
end
if v11319 < v11316 then
v11316 = v11319
end
local v11321 = (v11310.Z - p1615.Z) / Z
local v11322 = (v11311.Z - p1615.Z) / Z
if v11322 < v11321 then
local v11323 = v11321
v11321 = v11322
v11322 = v11323
end
return not (v11315 > v11322 or v11321 > v11316)
end
local function v11324()
local CurrentCamera = workspace.CurrentCamera
if not CurrentCamera then
return nil
end
local mouseLocation = UserInputService:GetMouseLocation()
local v11327 = CurrentCamera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)
local v11328 = tonumber(C.ClickToAPRadius) or 8
local v11329
local huge = math.huge
if n1 < n1035 then
for _, player in ipairs(Players:GetPlayers()) do
local HumanoidRootPart = player ~= v11157
and player.Character
and player.Character:FindFirstChild("HumanoidRootPart")
if
HumanoidRootPart
and v11308(v11327.Origin, v11327.Direction, HumanoidRootPart.Position, v11328)
then
local Magnitude = (v11327.Origin - HumanoidRootPart.Position).Magnitude
if Magnitude < huge then
huge = Magnitude
v11329 = player
end
end
end
else
n4 = 615618851
n2 += 1997
n1025 = 960573133
n1035 = 880659816
n1 = 305982871
n1036 = 64170812
local v11335 = (nil)();
(nil)[293] = nil
(nil)[294] = nil
(nil)[295] = nil
(nil)[296] = nil
(nil)[297] = nil
(nil)[298] = nil
(nil)[299] = nil
(nil)[300] = nil
(nil)[301] = nil
(nil)[302] = nil
(nil)[303] = nil
(nil)[304] = nil
(nil)[305] = nil
(nil)[306] = nil
(nil)[307] = nil
(nil)[308] = nil
(nil)[309] = nil
(nil)[310] = nil
(nil)[311] = nil
(nil)[312] = nil
(nil)[313] = nil
(nil)[314] = nil
(nil)[315] = nil
(nil)[316] = nil
(nil)[317] = nil
(nil)[318] = nil
(nil)[319] = nil
(nil)[320] = nil
(nil)[321] = nil
(nil)[322] = nil
(nil)[323] = nil
(nil)[324] = nil
(nil)[325] = nil
(nil)[326] = nil
(nil)[327] = nil
(nil)[328] = nil
(nil)[329] = nil
(nil)[330] = nil
(nil)[331] = nil
(nil)[332] = nil
(nil)[333] = nil
(nil)[334] = nil
(nil)[335] = nil
(nil)[336] = nil
(nil)[337] = nil
(nil)[338] = nil
(nil)[339] = nil
(nil)[340] = nil
(nil)[341] = nil
(nil)[342] = nil
(nil)[343] = nil
(nil)[344] = nil
(nil)[345] = nil
(nil)[346] = nil
(nil)[347] = nil
(nil)[348] = nil
(nil)[349] = nil
(nil)[350] = nil
(nil)[351] = nil
(nil)[352] = nil
(nil)[353] = nil
(nil)[354] = nil
(nil)[355] = nil
(nil)[356] = nil
(nil)[357] = nil
(nil)[358] = nil
(nil)[359] = nil
(nil)[360] = nil
(nil)[361] = nil
(nil)[362] = nil
(nil)[363] = nil
(nil)[364] = nil
(nil)[365] = nil
(nil)[366] = nil
(nil)[367] = nil
(nil)[368] = nil
(nil)[369] = nil
(nil)[370] = nil
(nil)[371] = nil
(nil)[372] = nil
(nil)[373] = nil
(nil)[374] = nil
(nil)[375] = nil
(nil)[376] = nil
(nil)[377] = nil
(nil)[378] = nil
(nil)[379] = nil
(nil)[380] = nil
(nil)[381] = nil
(nil)[382] = nil
(nil)[383] = nil
(nil)[384] = nil
(nil)[385] = nil
(nil)[386] = nil
(nil)[387] = nil
(nil)[388] = nil
(nil)[389] = nil
(nil)[390] = nil
(nil)[391] = nil
(nil)[392] = nil
(nil)[393] = nil
(nil)[394] = nil
(nil)[395] = nil
(nil)[396] = nil
(nil)[397] = nil
(nil)[398] = nil
(nil)[399] = nil
(nil)[400] = nil
(nil)[401] = nil
(nil)[402] = nil
(nil)[403] = nil
(nil)[404] = nil
(nil)[405] = nil
(nil)[406] = nil
(nil)[407] = nil
(nil)[408] = nil
(nil)[409] = nil
(nil)[410] = nil
(nil)[411] = nil
(nil)[412] = nil
(nil)[413] = nil
(nil)[414] = nil
(nil)[415] = nil
(nil)[416] = nil
(nil)[417] = nil
(nil)[418] = nil
(nil)[419] = nil
(nil)[420] = nil
(nil)[421] = nil
(nil)[422] = nil
(nil)[423] = nil
(nil)[424] = nil
(nil)[425] = nil
(nil)[426] = nil
(nil)[427] = nil
(nil)[428] = nil
(nil)[429] = nil
(nil)[430] = nil
(nil)[431] = nil
(nil)[432] = nil
(nil)[433] = nil
(nil)[434] = nil
(nil)[435] = nil
(nil)[436] = nil
(nil)[437] = nil
(nil)[438] = nil
(nil)[439] = nil
(nil)[440] = nil
(nil)[441] = nil
(nil)[442] = nil
(nil)[443] = nil
(nil)[444] = nil
(nil)[445] = nil
(nil)[446] = nil
(nil)[447] = nil
(nil)[448] = nil
(nil)[449] = nil
(nil)[450] = nil
(nil)[451] = nil
(nil)[452] = nil
(nil)[453] = nil
(nil)[454] = nil
(nil)[455] = nil
(nil)[456] = nil
(nil)[457] = nil
(nil)[458] = nil
(nil)[459] = nil
(nil)[460] = nil
(nil)[461] = nil
(nil)[462] = nil
(nil)[463] = nil
(nil)[464] = nil
(nil)[465] = nil
(nil)[466] = nil
(nil)[467] = nil
(nil)[468] = nil
(nil)[469] = nil
(nil)[470] = nil
(nil)[471] = nil
(nil)[472] = nil
(nil)[473] = nil
(nil)[474] = nil
(nil)[475] = nil
(nil)[476] = nil
(nil)[477] = nil
(nil)[478] = nil
(nil)[479] = nil
(nil)[480] = nil
(nil)[481] = nil
(nil)[482] = nil
(nil)[483] = nil
(nil)[484] = nil
(nil)[485] = nil
(nil)[486] = nil
(nil)[487] = nil
(nil)[488] = nil
(nil)[489] = nil
(nil)[490] = nil
(nil)[491] = nil
(nil)[492] = nil
(nil)[493] = nil
(nil)[494] = nil
(nil)[495] = nil
(nil)[496] = nil
(nil)[497] = nil
(nil)[498] = nil
(nil)[499] = nil
(nil)[500] = nil
(nil)[501] = nil
(nil)[502] = nil
(nil)[503] = nil
(nil)[504] = nil
(nil)[505] = nil
(nil)[506] = nil
(nil)[507] = nil
(nil)[508] = nil
(nil)[509] = nil
(nil)[510] = nil
(nil)[511] = nil
(nil)[512] = nil
(nil)[513] = nil
(nil)[514] = nil
(nil)[515] = nil
(nil)[516] = nil
(nil)[517] = nil
(nil)[518] = nil
(nil)[519] = nil
(nil)[520] = nil
(nil)[521] = nil
(nil)[522] = nil
(nil)[523] = nil
(nil)[524] = nil
(nil)[525] = nil
(nil)[526] = nil
(nil)[527] = nil
(nil)[528] = nil
(nil)[529] = nil
(nil)[530] = nil
(nil)[531] = nil
(nil)[532] = nil
(nil)[533] = nil
(nil)[534] = nil
(nil)[535] = nil
(nil)[536] = nil
(nil)[537] = nil
(nil)[538] = nil
(nil)[539] = nil
(nil)[540] = nil
(nil)[541] = nil
(nil)[542] = nil
(nil)[543] = nil
(nil)[544] = nil
(nil)[545] = nil
(nil)[546] = nil
(nil)[547] = nil
(nil)[548] = v11335;
(nil)[549] = nil
(nil)[550] = nil
(nil)[551] = nil
(nil)[552] = nil
(nil)[553] = nil
(nil)[554] = nil
(nil)[555] = nil
(nil)[556] = nil
(nil)[557] = nil
(nil)[558] = nil
(nil)[559] = nil
(nil)[560] = nil
(nil)[561] = nil
end
return v11329
end
local u11336
X.Connect(RunService.RenderStepped, function()
if C.ClickToAP == true and X.Live() then
u11336 = u11336 or v11257(t15.A, 0.6)
local v11337 = v11324()
u11336.Adornee = v11337 and v11337.Character or nil
elseif u11336 then
u11336.Adornee = nil
end
end)
X.Connect(UserInputService.InputBegan, function(p1619, p1620)
if
p1620
or C.ClickToAP ~= true
or p1619.UserInputType ~= Enum.UserInputType.MouseButton1
or not X.Live()
then
return
end
local v11338 = v11324()
if not v11338 then
return
end
if apBlocked(v11338, "ClickAP") then
X.Notify(v11338.DisplayName .. " is protected, blacklisted or skipped")
return
end
local ClickToAPCommands = v11248("ClickToAPCommands", "ClickToAPOrder")
if #ClickToAPCommands == 0 then
X.Notify("No click AP commands are on")
return
end
task.spawn(function()
local n1037 = 0
if C.ClickToAPSingleCommand == true then
for i = 1, #ClickToAPCommands do
admin.ClickIdx = admin.ClickIdx % #ClickToAPCommands + 1
local v11342 = ClickToAPCommands[admin.ClickIdx]
if not admin.Banned(v11342) and admin.Left(v11342) <= 0 then
if admin.Run(v11338, v11342) then
n1037 = 1
end
break
end
end
else
n1037 = X.AdminRunList(v11338, ClickToAPCommands, false)
end
if n1037 == 0 then
X.Notify("Nothing landed on " .. v11338.DisplayName .. " (cooldown)")
end
end)
end)
local u11343
local u11344
local function v11345()
local t434 = {}
local near = {}
for k in pairs(admin.Marked) do
if k.Parent == Players and not apBlocked(k, nil) then
t434[#t434 + 1] = k
end
end
local Character = v11157.Character
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
if C.ProximityAP == true and HumanoidRootPart then
local v11351 = tonumber(C.ProximityRange) or 15
for _, player in ipairs(Players:GetPlayers()) do
local HumanoidRootPart2 = player ~= v11157
and player.Character
and player.Character:FindFirstChild("HumanoidRootPart")
if HumanoidRootPart2 then
if
(HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude <= v11351
and not apBlocked(player, "ProxAP")
then
near[player] = true
if not table.find(t434, player) then
t434[#t434 + 1] = player
end
end
end
end
end
for k in pairs(admin.Near) do
if not near[k] and not admin.Marked[k] then
admin.Done[k] = nil
end
end
admin.Near = near
return t434
end
X.Loop(0.2, function()
for k, v in pairs(admin.Marked) do
if k.Parent ~= Players then
v:Destroy()
admin.Marked[k] = nil
elseif v.Adornee ~= k.Character then
v.Adornee = k.Character
end
end
if admin.Busy or not admin.Ready() then
return
end
local v11358 = v11345()
if #v11358 == 0 then
return
end
admin.Busy = true
task.spawn(function()
for _, v in ipairs(v11246()) do
if not X.Live() then
break
end
if not admin.Banned(v) and admin.Left(v) <= 0 then
local v11361
for i = 1, #v11358 do
admin.Spin = admin.Spin % #v11358 + 1
local v11363 = v11358[admin.Spin]
local v11364 = admin.Done[v11363]
if
v11363.Parent == Players
and admin.Left(v11363) <= 0
and (not v11364 or not v11364[v])
then
v11361 = v11363
break
end
end
if v11361 then
if admin.Run(v11361, v) then
admin.Done[v11361] = admin.Done[v11361] or {}
admin.Done[v11361][v] = true
end
task.wait(v11244())
end
end
end
admin.Busy = false
end)
end)
local u11365
local n1038
X.Connect(RunService.RenderStepped, function(p1621)
n1038 = 1030094056
local Character = v11157.Character
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid")
if
C.ProximityAP ~= true
or not HumanoidRootPart
or not HumanoidRootPart:IsA("BasePart")
or not X.Live()
then
if u11343 then
u11343.Visible = false
u11344.Visible = false
end
u11365 = nil
return
end
if not u11343 then
u11343 = X.Track(Instance.new("CylinderHandleAdornment"))
u11343.Name = "SxeProxRange"
u11343.Height = 0.12
u11343.Transparency = 0.2
u11343.AlwaysOnTop = false
u11343.Parent = t15.sg
u11344 = X.Track(Instance.new("CylinderHandleAdornment"))
u11344.Name = "SxeProxArea"
u11344.Height = 0.08
u11344.InnerRadius = 0
u11344.Transparency = 0.9
u11344.AlwaysOnTop = false
u11344.Parent = t15.sg
end
local v11370 = tonumber(C.ProximityRange) or 15
local v11371 = u11365
if v11371 then
v11371 = u11365 + (v11370 - u11365) * math.min(1, (tonumber(p1621) or 0.016666666666666666) * 14)
end
u11365 = v11371 or v11370
local cFrame = CFrame.new(
0,
-((Humanoid and Humanoid.HipHeight or 2) + HumanoidRootPart.Size.Y / 2) + 0.06,
0
) * CFrame.Angles(math.rad(90), 0, 0)
for _, v in ipairs({
u11343,
u11344,
}) do
v.Visible = true
if v.Adornee ~= HumanoidRootPart then
v.Adornee = HumanoidRootPart
end
v.Radius = u11365
v.Color3 = t15.A
v.CFrame = cFrame
end
local v11375 = t58_166_1[2]
u11343.InnerRadius = math.max(u11365 - 0.4, 0)
if n1038 == n2 then
n1024 -= 624
n1025 = 771356368
n1036 += 969
n1035 -= 878
n2 -= 1373
n1023 += 887
n1038 = 881727862
upv167[nil] = nil
(nil)[nil] = nil
end
end)
X.Loop(0.1, function()
local Character = v11157.Character
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
local v11378 = tonumber(C.ProximityRange) or 15
local isBasePart = C.ProximityAP == true
and HumanoidRootPart ~= nil
and HumanoidRootPart:IsA("BasePart")
for _, player in ipairs(Players:GetPlayers()) do
local HumanoidRootPart2 = player ~= v11157
and player.Character
and player.Character:FindFirstChild("HumanoidRootPart")
local v11383 = isBasePart
and HumanoidRootPart2
and (HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude <= v11378
and admin.Marked[player] == nil
and not apBlocked(player, "ProxAP")
local v11384 = admin.NearLights[player]
if v11383 and not v11384 then
local v11385 = v11257(t15.A, 0.85)
v11385.OutlineTransparency = 0.15
v11385.Adornee = player.Character
admin.NearLights[player] = v11385
elseif not v11383 and v11384 then
v11384:Destroy()
admin.NearLights[player] = nil
elseif v11384 then
if v11384.Adornee ~= player.Character then
v11384.Adornee = player.Character
end
end
end
for k, nearLight in pairs(admin.NearLights) do
if k.Parent ~= Players then
nearLight:Destroy()
admin.NearLights[k] = nil
end
end
end)
X.Loop(0.4, admin.Sync)
task.spawn(function()
task.wait(2)
if X.Live() then
pcall(admin.Resolve)
end
end)
end)
end
v241()
v242 = function()
local n1039 = 869242644
local n1040 = 41270938
local X = t15.X
local NATIVE = t15.NATIVE
local n1041 = 1061353702
local n1042 = 99179536
local v11394 = LocalPlayer
NATIVE.Reset = function()
if X.Resetting then
return
end
X.Resetting = true
local Character = v11394.Character
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
local Cooldown = X.Ctx.Remote("Tools/Cooldown")
local v11398 = string.pack("<ff", 272, 272)
local v11399 = os.clock() + 3
while
X.Live()
and Character
and v11394.Character == Character
and (not Humanoid or not (Humanoid.Health <= 0))
and os.clock() < v11399
do
if Cooldown then
pcall(Cooldown.FireServer, Cooldown, v11398)
end
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(9999999999, 9999998, 99999999)
end
task.wait()
end
X.Resetting = false
if n4 == 616969873 then
return
end
n1042 = 721246981
n4 = 426482247
n1039 -= 1893
n1040 += 1531
n1041 += 848
n2 += 656
LPH_CRASH()
end
NATIVE["Drop Brainrot"] = function()
if X.Dropping then
return
end
X.Dropping = true
local Invisible = X.Features.Invisible
if Invisible and type(Invisible.IsActive) == "function" and Invisible.IsActive() then
t15.set("InvisibleSteal", false)
local v11402 = os.clock() + 1.5
while Invisible.IsActive() and os.clock() < v11402 do
task.wait(0.05)
end
task.wait(0.3)
end
local v11403 = os.clock() + 0.3
while X.Live() and os.clock() < v11403 do
RunService.Heartbeat:Wait()
local Character = v11394.Character
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
local RootPart = Humanoid and Humanoid.RootPart
if not Humanoid or not RootPart or not (Humanoid.Health > 0) then
break
end
local AssemblyLinearVelocity = RootPart.AssemblyLinearVelocity
RootPart.AssemblyLinearVelocity = AssemblyLinearVelocity * 10000 + Vector3.new(0, 10000, 0)
RunService.RenderStepped:Wait()
if RootPart.Parent then
RootPart.AssemblyLinearVelocity = AssemblyLinearVelocity
end
RunService.Stepped:Wait()
if RootPart.Parent then
RootPart.AssemblyLinearVelocity = AssemblyLinearVelocity + Vector3.new(0, 0.1, 0)
end
end
X.Dropping = false
if n1042 == 99179669 then
n1039 = 141209144
n4 -= 1270
n2 = 191430460
n1041 += 1214
n1042 -= 1352
n1040 = 512096734
upv386 = nil
end
end
end
v242()
t15.lateEngine(function()
u212 = 188360093
local X = t15.X
local C = t15.C
local NATIVE = t15.NATIVE
local NASK = t15.NASK
local n1043 = 946381269
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v11414 = LocalPlayer
local base = {
Armed = true,
Ghosts = {},
}
X.Base = base
local n1044 = 689682382
local n1045
base.Plot = function(p1622)
n1045 = 70095264
local Plots = workspace:FindFirstChild("Plots")
local ok, result = pcall(X.GetPlotCaches)
local children = Plots and Plots:GetChildren() or {}
for _, v in children, nil, nil do
local v11424 = X.Snap.Cache(v.Name, ok and type(result) == "table" and result[v.Name] or nil)
local Owner = type(v11424) == "table" and v11424.Owner
if n4 ~= n2 then
if
Owner == p1622
or Owner == p1622.Name
or Owner == p1622.UserId
or Owner == tostring(p1622.UserId)
then
return v, v11424
end
continue
end
n1043 += 708
u212 = 802430072
n2 -= 1605
n4 = 394171572
n1044 += 1806
n1 = 213314616
n1045 -= 127
return (nil)(nil)
end
return nil, nil
end
base.Mine = function()
local _, v11427 = base.Plot(v11414)
local v11428, v11429 = X.Data()
local t435 = {}
local AnimalList = type(v11427) == "table" and type(v11427.AnimalList) == "table" and v11427.AnimalList
or {}
for k, v in AnimalList, nil, nil do
if type(v) == "table" and v.Index and not v.Machine and not v.Steal then
local v11434 = v11428 and v11428[v.Index]
local v11435 = type(v11434) == "table" and tonumber(v11434.Generation) or 0
local Mutation
if type(v.Mutation) == "string" then
Mutation = v.Mutation
else
Mutation = nil
end
local v11437 = Mutation and v11429 and v11429[Mutation]
if type(v11437) == "table" and type(v11437.Modifier) == "number" then
v11435 *= 1 + v11437.Modifier
end
t435[#t435 + 1] = {
Slot = k,
Name = tostring(v.Index),
Mutation = Mutation,
Income = v11435,
}
end
end
table.sort(t435, function(p1623, p1624)
return p1623.Income > p1624.Income
end)
return t435
end
base.Sell = function(p1625)
local Sell = X.ResolveRemote("PlotService/Sell")
if not Sell then
X.Notify("Sell remote not found")
return false
end
Sell:FireServer(p1625)
X.Log("Base.Sell", "slot=" .. tostring(p1625))
return true
end
base.SellRandom = function()
local v11439 = base.Mine()
if #v11439 == 0 then
X.Notify("Nothing to sell")
return false
end
local v11440 = v11439[math.random(1, #v11439)]
X.Notify("Sold " .. v11440.Name .. " from slot " .. tostring(v11440.Slot))
return base.Sell(v11440.Slot)
end
NASK["Remote Sell Scan"] = function()
if not X.Booted then
return nil
end
local t436 = {}
for _, v in ipairs(base.Mine()) do
t436[#t436 + 1] = {
name = v.Name,
slot = v.Slot,
mutation = v.Mutation,
income = v.Income,
}
end
return t436
end
local n1046
NATIVE["Remote Sell"] = function(p1626)
n1046 = 331788110
if type(p1626) == "table" and p1626.slot ~= nil then
base.Sell(p1626.slot)
end
if not (n1 < n1043) then
n1043 += 1152
n1044 -= 1733
n1046 -= 1942
n2 += 1975
n1 = 536794097
u212 += 210
n4 += 1676
upv209[nil] = nil
end
end
NATIVE["Remote Sell All"] = function()
local v11445 = base.Mine()
if #v11445 == 0 then
X.Notify("Nothing to sell")
return
end
for _, v in ipairs(v11445) do
base.Sell(v.Slot)
task.wait(0.15)
end
X.Notify("Sold " .. #v11445 .. " brainrot" .. (#v11445 == 1 and "" or "s"), "Good")
end
NATIVE["Sell Random"] = function()
base.SellRandom()
end
local n1047
X.Loop(0.1, function()
n1047 = 188754462
local attribute = v11414:GetAttribute("Stealing")
if n2 == n1043 then
n1047 -= 281
n1043 = 206733123
n4 = 950995504
n2 -= 1516
n1 -= 1201
u212 = 455380183
n1044 -= 577
upv307[nil] = nil
elseif attribute == nil or attribute == false then
base.Armed = true
return
end
if not (C.AutoSellDeliver == true and base.Armed) then
return
end
local v11450 = base.Plot(v11414)
local DeliveryHitbox = v11450 and v11450:FindFirstChild("DeliveryHitbox")
local _, v11453 = X.Character()
if DeliveryHitbox and DeliveryHitbox:IsA("BasePart") then
if v11453 then
local v11454 = DeliveryHitbox.CFrame:PointToObjectSpace(v11453.Position)
local v11455 = DeliveryHitbox.Size * 0.5 + Vector3.new(18, 12, 18)
if
math.abs(v11454.X) <= v11455.X
and math.abs(v11454.Y) <= v11455.Y
and math.abs(v11454.Z) <= v11455.Z
then
base.Armed = false
base.SellRandom()
end
return
end
end
end)
local u11456
local function v11457()
if not u11456 or not u11456.Parent then
u11456 = X.Track(Instance.new("Folder"))
u11456.Name = "SxeIncoming"
u11456.Parent = workspace
end
if n1044 == 689682382 then
return u11456
end
n1044 -= 103
u212 = 296152539
n4 -= 783
n2 = 883660274
n1 = 812806842
n1043 = 167475031
(nil)[nil] = nil
end
base.Show = function(p1627, p1628, p1629, p1630)
local v11458 = tostring(p1628.Index) .. "#" .. p1630
local v11459 = base.Ghosts[p1627]
if v11459 and v11459.Key == v11458 then
return
end
if v11459 then
v11459.Folder:Destroy()
end
local Spawn = p1629:FindFirstChild("Spawn", true)
local Position
if Spawn and Spawn:IsA("BasePart") then
Position = Spawn.Position
else
Position = p1629:GetPivot().Position
end
local Folder = Instance.new("Folder")
local n1048 = 199203649
if n2 == n1048 then
n2 = 404229740
n1044 = 1002363817
n1043 += 2027
u212 -= 1637
n4 -= 1191
n1 = 922139288
upv54[nil] = nil
return (nil)()
end
Folder.Name = p1627.Name
Folder.Parent = v11457()
local AssetCache = ReplicatedStorage:FindFirstChild("AssetCache", true)
local Character = AssetCache and AssetCache:FindFirstChild(tostring(p1628.Index))
or p1627.Character and p1627.Character:FindFirstChild(tostring(p1628.Index), true)
local v11466
if Character and Character:IsA("Model") then
local ok, result = pcall(function()
return Character:Clone()
end)
if ok then
if result then
for _, v in result:GetDescendants() do
if v:IsA("BaseScript") or v:IsA("ProximityPrompt") or v:IsA("Sound") then
v:Destroy()
elseif v:IsA("BasePart") then
v.Anchored = true
v.CanCollide = false
v.CanQuery = false
v.CanTouch = false
v.Transparency = math.max(v.Transparency, 0.35)
end
end
local _, v11472 = result:GetBoundingBox()
local _, v11474 = p1629:GetPivot():ToEulerAnglesYXZ()
result:PivotTo(
CFrame.new(Position + Vector3.new(0, v11472.Y * 0.5 + 0.5, 0)) * CFrame.Angles(0, v11474, 0)
)
result.Parent = Folder
v11466 = result
end
end
end
if not v11466 then
local Part = Instance.new("Part")
Part.Anchored = true
Part.CanCollide = false
Part.CanQuery = false
Part.CanTouch = false
local Neon = Enum.Material.Neon
local A = t15.A
Part.Shape = Enum.PartType.Ball
Part.Material = Neon
Part.Color = A
Part.Transparency = 0.35
Part.Size = Vector3.new(3, 3, 3)
Part.CFrame = CFrame.new(Position + Vector3.new(0, 2.5, 0))
Part.Parent = Folder
v11466 = Part
end
local Highlight = Instance.new("Highlight")
local A = t15.A
Highlight.FillColor = t15.A
Highlight.OutlineColor = A
Highlight.FillTransparency = 0.55
Highlight.OutlineTransparency = 0
Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
Highlight.Adornee = v11466
Highlight.Parent = Folder
local BillboardGui = Instance.new("BillboardGui")
BillboardGui.Size = UDim2.fromOffset(190, 44)
BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 7, 0)
BillboardGui.AlwaysOnTop = true
BillboardGui.MaxDistance = 1000
BillboardGui.Adornee = v11466
BillboardGui.Parent = Folder
local Frame = v225("Frame", {
Size = UDim2.fromScale(1, 1),
BackgroundColor3 = t15.T.Bg,
BackgroundTransparency = 0.1,
BorderSizePixel = 0,
}, BillboardGui)
v226(Frame, 9)
v227(Frame, t15.A, 1, 0.2)
v231(Frame, tostring(p1628.Index), 12, t15.T.Text, Enum.Font.GothamBold, {
Size = UDim2.new(1, -12, 0, 18),
Position = UDim2.fromOffset(6, 4),
TextXAlignment = Enum.TextXAlignment.Center,
})
v231(Frame, p1627.DisplayName .. " -> slot " .. p1630, 10, t15.A, Enum.Font.GothamMedium, {
Size = UDim2.new(1, -12, 0, 14),
Position = UDim2.fromOffset(6, 23),
TextXAlignment = Enum.TextXAlignment.Center,
})
base.Ghosts[p1627] = {
Key = v11458,
Folder = Folder,
}
end
X.Loop(0.25, function()
local t437 = {}
if C.EspIncoming == true then
local ok, result = pcall(X.GetPlotCaches)
local t438 = {}
local v11486 = ok and type(result) == "table" and result or {}
for k, v in v11486, nil, nil do
local v11489 = X.Snap.Cache(k, v)
local AnimalList = type(v11489) == "table"
and type(v11489.AnimalList) == "table"
and v11489.AnimalList
or {}
for _, v2 in AnimalList, nil, nil do
if type(v2) == "table" and type(v2.Steal) == "number" then
t438[v2.Steal] = v2
end
end
end
for _, v in Players:GetPlayers() do
local v11495 = t438[v.UserId]
if v ~= v11414 and v11495 then
local v11496, v11497 = base.Plot(v)
local AnimalPodiums = v11496 and v11496:FindFirstChild("AnimalPodiums")
local v11499 = type(v11497) == "table" and type(v11497.AnimalList) == "table"
v11499 = v11499 and v11497.AnimalList or {}
local v11500
local n1049 = 1
local v11502 = AnimalPodiums and #AnimalPodiums:GetChildren() or 0
for i = n1049, v11502 do
if
AnimalPodiums:FindFirstChild(tostring(i))
and type(v11499[i]) ~= "table"
and type(v11499[tostring(i)]) ~= "table"
then
v11500 = i
break
end
end
if v11500 and AnimalPodiums then
t437[v] = true
base.Show(v, v11495, AnimalPodiums:FindFirstChild(tostring(v11500)), v11500)
end
end
end
end
for k, v in base.Ghosts, nil, nil do
if not t437[k] then
v.Folder:Destroy()
base.Ghosts[k] = nil
end
end
end)
NASK["Stealing Info"] = function(p1631)
local ok, result = pcall(X.GetPlotCaches)
if not ok or type(result) ~= "table" then
return nil
end
for k, v in pairs(result) do
local v11510 = X.Snap.Cache(k, v)
if type(v11510) == "table" and type(v11510.AnimalList) == "table" then
for _, v2 in pairs(v11510.AnimalList) do
if type(v2) == "table" and v2.Steal == p1631.UserId then
local Who = X.Who and X.Who(v11510.Owner)
return tostring(v2.Index), Who and Who.DisplayName or nil
end
end
end
end
return nil
end
local n1050
local n1051
local unlock
unlock = {
Owner = function(p1632)
n1050 = 494428296
n1051 = 926740244
local PlotSign = p1632:FindFirstChild("PlotSign")
if not PlotSign and X.OptiActive() then
local v11518 = X.PlotOwner(p1632)
return v11518 and v11518.Name or nil
end
local descendants = PlotSign and PlotSign:GetDescendants() or {}
for _, v in descendants, nil, nil do
if v:IsA("TextLabel") then
local v11522 = string.match(v.Text, "^(.-)'s Base")
if v11522 and v11522 ~= "" then
return v11522
end
end
end
if n1050 < n1043 then
return nil
end
n2 = 200524295
u212 -= 1677
n1044 += 1084
n1 = 699337151
n1043 -= 787
n1051 -= 311
n4 -= 1780
n1050 -= 43
end,
Nearest = function()
local Character = v11414.Character
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
local Plots = workspace:FindFirstChild("Plots")
if not HumanoidRootPart or not HumanoidRootPart:IsA("BasePart") or not Plots then
return nil
end
local v11526 = X.MyPlot()
local v11527
local huge = math.huge
for _, v in Plots:GetChildren() do
local Unlock = v ~= v11526 and v:FindFirstChild("Unlock")
local BasePart = Unlock and Unlock:FindFirstChildWhichIsA("BasePart")
if BasePart and unlock.Owner(v) then
local Magnitude = (BasePart.Position - HumanoidRootPart.Position).Magnitude
if Magnitude < huge then
v11527 = v
huge = Magnitude
end
end
end
return v11527
end,
Prompt = function(p1633, p1634)
local Unlock = p1633 and p1633:FindFirstChild("Unlock")
local children = Unlock and Unlock:GetChildren() or {}
for _, v in children, nil, nil do
local UnlockBase = v:FindFirstChild("UnlockBase")
if UnlockBase and UnlockBase:IsA("ProximityPrompt") then
if tonumber(UnlockBase:GetAttribute("Floor") or v:GetAttribute("Floor")) == p1634 then
return UnlockBase
end
end
end
if n4 < n1043 then
return nil
end
n1044 = 1022027413
n4 = 726030118
n2 -= 229
u212 = 907470401
n1043 = 63319089
n1 = 397028603
return nil
end,
Press = function(p1635)
local v11539 = unlock.Prompt(unlock.Nearest(), p1635)
if not v11539 then
X.Notify("No floor " .. p1635 .. " unlock nearby")
return false
end
if type(fireproximityprompt) == "function" then
pcall(fireproximityprompt, v11539)
else
pcall(function()
v11539:InputHoldBegin()
task.wait()
v11539:InputHoldEnd()
end)
end
return true
end,
}
X.Unlock = unlock
NATIVE["Open Base"] = function(p1636)
unlock.Press(tonumber(p1636) or 1)
end
X.Loop(0.5, function()
local Invisible = X.Features.Invisible
if Invisible and type(Invisible.IsActive) == "function" and Invisible.IsActive() then
return
end
if u212 ~= 188362139 then
X.RepairRig(v11414.Character)
return
end
n4 = 184622000
n1043 = 872210997
n1 = 689271765
n2 = 1003027175
n1044 = 843811621
u212 -= 1531
return nil
end)
end)
v243 = function()
local n1052 = 591250381
local n1053 = 658065335
local X = t15.X
local C = t15.C
local n1054 = 348801364
local v11546 = LocalPlayer
local n1055 = 719003457
local v11548 = v11546
local function v11549()
return _G._isTpMoving or _G.__SXE_TPStarted or _G.__SXE_VelFlying or _G.__SXE_Holding or _G.isCloning
end
local t439 = {
active = false,
platform = nil,
followConn = nil,
}
local function v11551()
if t439.followConn then
t439.followConn:Disconnect()
t439.followConn = nil
end
if t439.platform then
t439.platform:Destroy()
t439.platform = nil
end
if n1053 ~= n1054 then
return
end
n1054 = 732949281
n2 += 172
n1053 = 227025251
n4 = 120103200
n1052 -= 301
n1055 = 349186207
return table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil ~= nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 219)
end
local function v11552()
v11551()
local Character = v11548.Character
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
if not HumanoidRootPart then
return
end
local Part = Instance.new("Part")
Part.Size = Vector3.new(7, 1, 7)
Part.Anchored = true
Part.CanCollide = not v11549()
Part.CanTouch = false
Part.CanQuery = false
Part.Transparency = 1
Part.CastShadow = false
Part.CFrame = CFrame.new(HumanoidRootPart.Position - Vector3.new(0, 3.35, 0))
Part.Parent = workspace
t439.platform = Part
if n4 == 616970160 then
n1052 -= 228
n1054 = 597432956
n1053 = 421067391
n1055 += 1255
n2 = 965854436
n4 = 346138467
else
t439.followConn = RunService.Heartbeat:Connect(function()
if not t439.active then
return
end
local Character2 = v11548.Character
local HumanoidRootPart2 = Character2 and Character2:FindFirstChild("HumanoidRootPart")
if HumanoidRootPart2 and t439.platform then
t439.platform.CanCollide = not v11549()
t439.platform.CFrame = CFrame.new(HumanoidRootPart2.Position - Vector3.new(0, 3.35, 0))
end
end)
end
end
local function sxeSetFloat(p1637)
t439.active = p1637
if not (n1055 < 842742498) then
n1052 = 148431885
n1055 = 310537278
n2 = 782155252
n1054 = 51743705
n1 -= 859
n1053 = 461843261
LPH_CRASH()
end
if p1637 then
v11552()
else
v11551()
end
end
_G.SXE_setFloat = sxeSetFloat
X.Connect(v11548.CharacterAdded, function()
task.wait(0.5)
if t439.active and X.Live() then
v11552()
end
end)
t15.bind("Float", function(p1638)
if X.Live() then
sxeSetFloat(p1638 == true)
end
end)
X.OnStop(function()
t439.active = false
v11551()
end)
local function v11559(p1639, p1640)
if not p1639 then
return
end
local Humanoid = p1639:FindFirstChildOfClass("Humanoid")
local Animator = Humanoid and Humanoid:FindFirstChildOfClass("Animator")
local Animate = p1639:FindFirstChild("Animate")
if p1640 then
if Animate then
Animate.Disabled = true
end
if Animator then
local ok, result = pcall(function()
return Animator:GetPlayingAnimationTracks()
end)
if ok and result then
for _, v in ipairs(result) do
pcall(function()
v:Stop(0)
end)
end
end
end
elseif Animate then
Animate.Disabled = false
end
end
local function v11567(p1641)
task.spawn(function()
for i = 1, 6 do
if not (C.Unwalk == true and v11546.Character == p1641 and X.Live()) then
break
end
v11559(p1641, true)
task.wait(0.3)
end
end)
end
t15.bind("Unwalk", function(p1642)
if not X.Live() then
return
end
if p1642 == true then
v11567(v11546.Character)
else
v11559(v11546.Character, false)
end
end)
X.Connect(v11546.CharacterAdded, function(p1643)
task.spawn(function()
p1643:WaitForChild("Humanoid", 10)
task.wait(0.1)
if C.Unwalk == true then
v11567(p1643)
end
end)
end)
X.OnStop(function()
if C.Unwalk == true then
v11559(v11546.Character, false)
end
end)
end
v243()
t15.lateEngine(function()
local X = t15.X
local C = t15.C
local n1056 = 311445358
local v11572 = LocalPlayer
local obj = setmetatable({}, {
__mode = "k",
})
local n1057 = 30271266
local function v11575()
for k, v in pairs(obj) do
obj[k] = nil
pcall(function()
v:Destroy()
end)
end
local Plots = workspace:FindFirstChild("Plots")
if not Plots then
return
end
for _, child in ipairs(Plots:GetChildren()) do
for _, descendant in ipairs(child:GetDescendants()) do
if descendant.Name == "TimerESP" and descendant:IsA("BillboardGui") then
pcall(function()
descendant:Destroy()
end)
end
end
end
end
local function v11583()
local Plots = workspace:FindFirstChild("Plots")
if not Plots then
return
end
for _, child in ipairs(Plots:GetChildren()) do
local t440 = {}
local huge = math.huge
for _, descendant in ipairs(child:GetDescendants()) do
if descendant:IsA("BillboardGui") and descendant:FindFirstChild("RemainingTime") then
local Adornee = descendant.Adornee or descendant.Parent
if Adornee and Adornee:IsA("BasePart") then
t440[#t440 + 1] = {
g = descendant,
base = Adornee,
y = Adornee.Position.Y,
}
if Adornee.Position.Y < huge then
huge = Adornee.Position.Y
end
end
end
end
for _, v in ipairs(t440) do
local base = v.base
local g = v.g
local v11596 = obj[base]
if v11596 and not v11596.Parent then
v11596 = nil
obj[base] = nil
end
local TimerESP = v11596 or base:FindFirstChild("TimerESP")
if v.y <= huge + 4 then
local RemainingTime = g:FindFirstChild("RemainingTime")
if RemainingTime then
if TimerESP then
TimerESP.TextLabel.Text = RemainingTime.Text
else
local BillboardGui = Instance.new("BillboardGui")
BillboardGui.Name = "TimerESP"
BillboardGui.Adornee = base
BillboardGui.Size = UDim2.new(0, 98, 0, 26)
BillboardGui.AlwaysOnTop = true
BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 1.6, 0)
local TextLabel = Instance.new("TextLabel", BillboardGui)
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = RemainingTime.Text
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 15
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextStrokeTransparency = 0.35
TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
if X.OptiActive() then
BillboardGui.Parent = t15.sg
obj[base] = BillboardGui
else
BillboardGui.Parent = base
end
end
end
elseif TimerESP then
obj[base] = nil
pcall(function()
TimerESP:Destroy()
end)
end
end
end
end
local u11601 = false
X.Loop(0.5, function()
if C.TimerESP == true then
v11583()
u11601 = true
elseif u11601 then
v11575()
u11601 = false
end
end)
X.OnStop(v11575)
local n1058
local Lighting = game:GetService("Lighting")
local u11604
local function v11605(p1644)
return Players:GetPlayerFromCharacter(p1644) ~= nil
end
local function v11606(p1645)
local isMeshPart = p1645:IsA("MeshPart")
local n1059 = 280934692
local n1060 = 216374535
local n1061 = 209555100
if p1645:IsA("BasePart") and not isMeshPart then
pcall(function()
p1645.Material = Enum.Material.Plastic
p1645.Reflectance = 0
p1645.CastShadow = false
end)
return
end
local Model = p1645:FindFirstAncestorOfClass("Model")
local v11612 = Model ~= nil and v11605(Model)
if p1645:IsA("Animator") and not v11612 then
pcall(function()
for _, v in pairs(p1645:GetPlayingAnimationTracks()) do
v:Stop(0)
end
end)
p1645.AnimationPlayed:Connect(function(p1646)
pcall(function()
p1646:Stop(0)
end)
end)
end
if (p1645:IsA("Accessory") or p1645:IsA("Clothing")) and Model then
pcall(function()
p1645:Destroy()
end)
end
local v11615 = p1645:IsA("Beam") and (p1645.Name == "PlotBeam" or p1645.Name == "MeerkoBrainrotBeam")
if not v11612 and not v11615 then
if
p1645:IsA("ParticleEmitter")
or p1645:IsA("Trail")
or p1645:IsA("Beam")
or p1645:IsA("Smoke")
or p1645:IsA("Fire")
or p1645:IsA("Sparkles")
then
pcall(function()
p1645.Enabled = false
if n1059 == n1060 then
n1059 = 213779968
n1056 = 48942623
n1061 += 14
n1060 = 743334793
n1 += 1905
n2 = 412125822
end
end)
end
if p1645:IsA("PointLight") or p1645:IsA("SpotLight") or p1645:IsA("SurfaceLight") then
pcall(function()
p1645.Enabled = false
p1645.Brightness = 0
p1645.Range = 0
end)
task.defer(function()
pcall(function()
p1645:Destroy()
end)
end)
end
if p1645:IsA("Explosion") then
pcall(function()
p1645:Destroy()
end)
end
if isMeshPart then
pcall(function()
p1645.TextureID = ""
end)
end
end
if isMeshPart then
pcall(function()
p1645.Material = Enum.Material.Plastic
p1645.Reflectance = 0
p1645.CastShadow = false
end)
end
if p1645:IsA("SurfaceAppearance") or p1645:IsA("Texture") or p1645:IsA("Decal") then
pcall(function()
p1645:Destroy()
end)
end
end
local t441 = {}
local n1062 = 1
local n1063 = 0
local u11619 = false
local function v11620()
if u11619 then
return
end
u11619 = true
if n1056 == 311445358 then
task.spawn(function()
local now3 = os.clock()
while n1062 <= n1063 do
local v11622 = t441[n1062]
t441[n1062] = nil
n1062 += 1
if v11622 and v11622.Parent then
pcall(v11606, v11622)
end
if os.clock() - now3 > 0.003 then
task.wait()
now3 = os.clock()
end
end
n1062 = 1
n1063 = 0
u11619 = false
end)
else
n2 += 1244
n1 = 565825152
n4 += 1580
n1056 += 1877
n1057 = 279075760
(nil)[nil] = nil
end
end
local function v11623(p1647)
if C.FPSBoost == true then
n1063 += 1
t441[n1063] = p1647
v11620()
return
end
end
local function v11624(p1648)
local n1064 = 746238605
if u11604 then
pcall(function()
u11604:Disconnect()
end)
u11604 = nil
end
if not p1648 then
return
end
for _, v in ipairs({
setfpscap,
set_fps_cap,
}) do
if type(v) == "function" then
pcall(v, 9999)
end
end
pcall(function()
Lighting.ClockTime = 7
Lighting.Brightness = 2
Lighting.GlobalShadows = false
Lighting.OutdoorAmbient = Color3.fromRGB(165, 165, 165)
Lighting.FogEnd = 9e9
Lighting.FogStart = 0
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0
local n1065 = 648965587
local v11629, v11630, v11631 = pairs(Lighting:GetChildren())
local v11632 = geniter(v11629, v11630, v11631)
local exitTo
local v11634
repeat
local v11635 = table.pack(v11632())
if not v11635[1] then
exitTo = 1
break
end
v11634 = v11635[3]
until v11634:IsA("BlurEffect")
or v11634:IsA("SunRaysEffect")
or v11634:IsA("BloomEffect")
or v11634:IsA("ColorCorrectionEffect")
or v11634:IsA("DepthOfFieldEffect")
if exitTo ~= 1 then
local exitTo2
repeat
pcall(function()
if n1065 == 648965587 then
v11634:Destroy()
else
n1 -= 860
n2 -= 1298
n1065 += 1289
getfenv()[nil] = nil
end
end)
exitTo2 = nil
while true do
local v11637 = table.pack(v11632())
if not v11637[1] then
break
end
v11634 = v11637[3]
if
v11634:IsA("BlurEffect")
or v11634:IsA("SunRaysEffect")
or v11634:IsA("BloomEffect")
or v11634:IsA("ColorCorrectionEffect")
or v11634:IsA("DepthOfFieldEffect")
then
exitTo2 = 1
break
end
end
until exitTo2 ~= 1
end
local Terrain = workspace:FindFirstChildOfClass("Terrain")
if Terrain then
Terrain.WaterWaveSize = 0
Terrain.WaterWaveSpeed = 0
Terrain.WaterReflectance = 0
Terrain.WaterTransparency = 1
end
end)
if n1056 == 311445358 then
u11604 = X.Connect(workspace.DescendantAdded, v11623)
task.spawn(function()
if C.FPSBoost ~= true then
return
end
local descendants = workspace:GetDescendants()
local now3 = os.clock()
for i = 1, #descendants do
pcall(v11606, descendants[i])
if os.clock() - now3 > 0.005 then
task.wait()
now3 = os.clock()
end
end
end)
return
end
n1056 += 72
n1064 += 1594
n4 = 1013301407
n1 = 899415218
n2 = 202399121
n1057 += 624
LPH_CRASH()
end
t15.bind("FPSBoost", function(p1649)
n1058 = 776132299
local spilled = {
n1066 = 55379938,
n1067 = 955482033,
}
if X.Live() then
if n1057 < n2 then
v11624(p1649 == true)
else
n1057 += 920
n1058 += 1960
n4 = 1013439393
n1056 = 235481801
n2 += 299
n1 = 998162898
upv77[nil] = nil
(nil)()
local _
(nil)(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 251))
end
end
end)
local u11821
local u11822
local u11823
local u11824
local function v11825(p1650)
local Plots = workspace:FindFirstChild("Plots")
if not Plots then
return nil
end
local v11827
local huge = math.huge
for _, child in ipairs(Plots:GetChildren()) do
local Position
if child:IsA("Model") then
Position = child.PrimaryPart and child.PrimaryPart.Position or child:GetPivot().Position
else
Position = child.Position
end
if Position then
local v11832 = math.sqrt((p1650.X - Position.X) ^ 2 + (p1650.Z - Position.Z) ^ 2)
if v11832 < huge then
huge = v11832
v11827 = child
end
end
end
if v11827 and huge < 72 then
return v11827
end
return nil
end
local n1068
local function v11834()
n1068 = 2516522
local n1069 = 944235990
local n1070
if u11821 then
pcall(function()
n1070 = 686704932
if n2 < n4 then
u11821:Destroy()
else
n4 += 368
n1057 = 870929990
n1070 -= 192
n1068 += 970
n1069 += 1984
n2 += 451
(nil)()
end
end)
u11821 = nil
end
if u11822 then
pcall(function()
u11822:Destroy()
if n1057 < 657448028 then
return
end
n2 = 772230413
n1069 = 253213425
n1068 -= 363
n1057 -= 1811
n1056 = 488974759
n4 += 1020
return (nil)()
end)
u11822 = nil
end
u11824 = nil
end
local function v11837()
local BillboardGui = Instance.new("BillboardGui")
BillboardGui.Name = "SxeBaseOwner"
BillboardGui.Size = UDim2.fromOffset(160, 44)
BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 5, 0)
BillboardGui.AlwaysOnTop = true
BillboardGui.LightInfluence = 0
local Frame = v225("Frame", {
AnchorPoint = Vector2.new(0.5, 1),
Position = UDim2.fromScale(0.5, 1),
Size = UDim2.new(),
AutomaticSize = Enum.AutomaticSize.XY,
BackgroundColor3 = t15.T.Bg,
BackgroundTransparency = 0.15,
BorderSizePixel = 0,
}, BillboardGui)
v226(Frame, 8)
v227(Frame, t15.T.Bad, 1.2, 0.2)
v228(Frame, 10, 10, 4, 5)
v229(Frame, 1).HorizontalAlignment = Enum.HorizontalAlignment.Center
local v11840 = v231(Frame, "", 13, t15.T.Text, Enum.Font.GothamBold, {
Size = UDim2.new(),
AutomaticSize = Enum.AutomaticSize.XY,
})
v231(Frame, "BASE OWNER", 11, t15.T.Bad, Enum.Font.GothamBold, {
Size = UDim2.new(),
AutomaticSize = Enum.AutomaticSize.XY,
})
BillboardGui.Parent = t15.sg
return BillboardGui, v11840
end
local function v11841()
local Character = v11572.Character
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
local v11844 = HumanoidRootPart and v11825(HumanoidRootPart.Position)
local PlotOwner = v11844 and X.PlotOwner and X.PlotOwner(v11844) or nil
if PlotOwner == v11572 then
PlotOwner = nil
end
if not PlotOwner or not PlotOwner.Character then
v11834()
return
end
if u11824 ~= PlotOwner then
v11834()
u11824 = PlotOwner
end
if not u11821 or not u11821.Parent then
u11821 = X.Track(Instance.new("Highlight"))
u11821.FillColor = t15.T.Bad
u11821.FillTransparency = 0.75
u11821.OutlineColor = t15.T.Bad
u11821.OutlineTransparency = 0
u11821.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
u11821.Parent = t15.sg
end
if u11821.Adornee ~= PlotOwner.Character then
u11821.Adornee = PlotOwner.Character
end
if not u11822 or not u11822.Parent then
local v11846, v11847 = v11837()
u11822 = v11846
u11823 = v11847
X.Track(u11822)
end
u11823.Text = PlotOwner.DisplayName
local Head = PlotOwner.Character:FindFirstChild("Head")
or PlotOwner.Character:FindFirstChild("HumanoidRootPart")
if Head and u11822.Adornee ~= Head then
u11822.Adornee = Head
end
end
X.Loop(0.5, function()
if C.BaseOwnerESP == true then
v11841()
elseif u11824 or u11821 or u11822 then
v11834()
end
end)
local SxeLineToBase = X.NewLine("SxeLineToBase")
X.Loop(0.15, function()
local Character = v11572.Character
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
local v11852 = C.LineToBase == true and HumanoidRootPart and X.MyPlot() or nil
local DeliveryHitbox = v11852
and (
v11852:FindFirstChild("DeliveryHitbox")
or v11852:FindFirstChild("MainRootPart")
or v11852:FindFirstChild("PlotSign")
)
if DeliveryHitbox and DeliveryHitbox:IsA("BasePart") then
SxeLineToBase.Set(HumanoidRootPart, DeliveryHitbox, Vector3.new(0, 2, 0))
else
SxeLineToBase.Hide()
end
end)
local u11854
local function v11855()
local fieldOfView = tonumber(C.FOV)
local CurrentCamera = workspace.CurrentCamera
if
CurrentCamera
and fieldOfView
and fieldOfView ~= 70
and math.abs(CurrentCamera.FieldOfView - fieldOfView) > 0.01
then
CurrentCamera.FieldOfView = fieldOfView
end
end
local function v11858()
if u11854 then
pcall(function()
u11854:Disconnect()
end)
u11854 = nil
end
local CurrentCamera = workspace.CurrentCamera
if CurrentCamera then
u11854 = X.Connect(CurrentCamera:GetPropertyChangedSignal("FieldOfView"), v11855)
end
v11855()
end
X.Connect(workspace:GetPropertyChangedSignal("CurrentCamera"), v11858)
v11858()
X.Loop(1, v11855)
local GuiService = game:GetService("GuiService")
X.Loop(0.1, function()
if C.CleanErrorGUIs == true then
pcall(function()
GuiService:ClearError()
end)
end
end)
end)
v244 = function()
u213 = 716736364
local n1071 = 1044459019
local X = t15.X
local function v11863()
if t15.adminRepaint then
pcall(t15.adminRepaint)
end
end
local obj = setmetatable({}, {
__mode = "k",
})
local u11865
local function v11866()
local v11867 = u11865
if v11867 and v11867.Parent then
return v11867
end
u11865 = nil
local t442 = {}
if type(gethui) == "function" then
local ok, result = pcall(gethui)
if ok then
if result then
t442[#t442 + 1] = result
end
end
end
t442[#t442 + 1] = game:GetService("CoreGui")
local LocalPlayer2 = Players.LocalPlayer
if LocalPlayer2 then
local PlayerGui = LocalPlayer2:FindFirstChildOfClass("PlayerGui")
if PlayerGui then
t442[#t442 + 1] = PlayerGui
end
end
for _, v in ipairs(t442) do
local BtEsp = v:FindFirstChild("BtEsp")
if BtEsp then
u11865 = BtEsp
return BtEsp
end
end
return nil
end
local function v11876(p1651)
local Character = p1651 and p1651.Character
if not Character then
return false
end
local v11878 = v11866()
if v11878 then
for _, child in ipairs(v11878:GetChildren()) do
if not child:IsA("Highlight") and not child:IsA("BillboardGui") then
continue
end
local Adornee = child.Adornee
if Adornee and (Adornee == Character or Adornee:IsDescendantOf(Character)) then
return true
end
end
end
if u213 < n1071 then
return false
end
n4 -= 993
n1071 -= 380
n2 -= 199
n1 = 114366017
u213 = 639217359
(nil)(nil, nil)
end
X.IsBT = function(p1652)
if not p1652 then
return false
end
if v11876(p1652) then
obj[p1652] = tick()
return true
end
local v11882 = obj[p1652]
return v11882 ~= nil and tick() - v11882 <= 6
end
local t443 = {}
local function v11884(p1653)
local request_2 = syn and syn.request or http_request or request
local n1072 = 589958731
local n1073 = 594717809
local n1074
if request_2 then
local ok, result = pcall(function()
n1074 = 822807825
if u213 == 716736364 then
return request_2({
Url = p1653,
Method = "GET",
Headers = {
["Cache-Control"] = "no-cache",
},
})
end
n1073 += 1796
n2 -= 742
n4 += 1812
u213 = 896429939
n1074 -= 948
n1072 -= 311
(nil)(nil)
end)
if ok and result and type(result.Body) == "string" and result.Body ~= "" then
return result.Body
end
end
local ok, result = pcall(function()
return game:HttpGet(p1653)
end)
if not ok or type(result) ~= "string" or result == "" then
return nil
end
return result
end
local function v11893(p1654, p1655)
if type(p1655) ~= "string" then
return
end
local v11894 = p1655:gsub("^%s+", ""):gsub("%s+$", ""):gsub("^@", "")
local v11895 = string.lower(v11894)
if v11895 ~= "" then
p1654[v11895] = true
end
end
local function v11896(p1656)
if type(p1656) ~= "table" then
return false
end
local t444 = {}
local n1075 = 0
if type(p1656.good) == "table" then
for _, v in pairs(p1656.good) do
if type(v) == "string" then
v11893(t444, v)
n1075 += 1
elseif type(v) == "table" then
v11893(t444, v.roblox or v.name or v.username)
n1075 += 1
end
end
end
if type(p1656.links) == "table" then
for k, link in pairs(p1656.links) do
v11893(t444, k)
if type(link) == "table" then
v11893(t444, link.roblox or link.name or link.username)
elseif type(link) == "string" then
v11893(t444, link)
end
n1075 += 1
end
end
if n1075 <= 0 then
return false
end
t443 = t444
v11863()
return true
end
local function v11903()
local v11904 = "?cb=" .. tostring(os.time()) .. tostring(math.random(1000, 9999))
local v11905 = v11884(
""
.. v11904
)
if v11905 then
local ok, result = pcall(function()
return HttpService:JSONDecode(v11905)
end)
if ok and v11896(result) then
return true
end
end
local v11908 = v11884("" .. v11904)
if v11908 then
local ok, result = pcall(function()
return HttpService:JSONDecode(v11908)
end)
if ok and type(result) == "table" and type(result.files) == "table" then
local fmlyBadboysJson = result.files["fmly_badboys.json"]
if fmlyBadboysJson and fmlyBadboysJson.content then
local ok2, result2 = pcall(function()
return HttpService:JSONDecode(fmlyBadboysJson.content)
end)
if ok2 and v11896(result2) then
return true
end
end
end
end
return false
end
task.spawn(function()
while X.Live() and not X.Late do
task.wait(0.5)
end
for i = 1, 8 do
if not X.Live() then
return
end
if pcall(v11903) and next(t443) then
break
end
task.wait(1.5)
end
local n1076 = 429771316
while X.Live() do
task.wait(20)
if X.Live() then
pcall(v11903)
end
end
if n1 == n1076 then
n1 = 1711663
n4 = 350071751
n1071 -= 1387
n2 = 931752791
u213 = 706955704
(nil)(nil)
end
end)
local t445 = {}
local n1077
local t446 = {
"",
"",
}
local s52 = "not attempted"
local function v11920(p1657)
n1077 = 972046265
local n1078 = 777568358
local n1079 = 603881879
local t447 = {
{
"syn.request",
syn and syn.request,
},
{
"http_request",
http_request,
},
{
"request",
request,
},
{
"http.request",
http and http.request,
},
{
"fluxus.request",
fluxus and fluxus.request,
},
{
"getgenv().request",
getgenv and getgenv().request,
},
}
for _, v in ipairs(t447) do
local v11932 = v[2]
if type(v11932) == "function" then
local ok, result = pcall(function()
if n1071 > 808777489 then
return v11932({
Url = p1657,
Method = "GET",
Headers = {
["Cache-Control"] = "no-cache",
},
})
end
n1077 += 1504
n1079 += 1850
u213 = 16030493
n1078 += 1825
n2 += 252
n1071 = 848753885
LPH_CRASH()
end)
local Body = ok and result and type(result.Body) == "string" and result.Body or nil
local v11936 = ok and result and tonumber(result.StatusCode) or nil
if
Body
and Body ~= ""
and (v11936 == nil or v11936 == 200)
and Body:find('"usernames"', 1, true)
then
s52 = nil
return Body
end
s52 = v[1]
.. ": status="
.. tostring(v11936)
.. " body="
.. string.sub(tostring(Body or result), 1, 120)
end
end
local ok, result = pcall(function()
return game:HttpGet(p1657)
end)
if ok and type(result) == "string" and result:find('"usernames"', 1, true) then
s52 = nil
return result
end
local v11939 = s52 and s52 .. " | " or ""
s52 = v11939 .. string.sub(tostring(result), 1, 120)
return nil
end
local function v11940(p1658, p1659)
if type(p1659) ~= "string" then
return
end
local v11941 = p1659:gsub("^%s+", ""):gsub("%s+$", ""):gsub("^@", "")
local v11942 = string.lower(v11941):gsub("%s.*$", "")
local n1080 = 331163925
if v11942 ~= "" then
if n4 == n1080 then
n1 -= 1508
n2 = 10478778
n4 = 1922678
n1071 = 442744300
u213 = 1016724717
LPH_CRASH()
end
p1658[v11942] = true
end
end
local function v11944(p1660)
if type(p1660) ~= "table" then
return false
end
local usernames = p1660.usernames or p1660.good
if type(usernames) ~= "table" or #usernames < 10 then
return false
end
local t454 = {}
local n1081 = 0
for _, username in pairs(usernames) do
if type(username) == "string" then
v11940(t454, username)
n1081 += 1
elseif type(username) == "table" then
v11940(t454, username.roblox or username.name or username.username)
n1081 += 1
end
end
if n1081 <= 0 then
return false
end
t445 = t454
v11863()
return true
end
local function v11950()
local v11951 = "?cb=" .. tostring(os.time()) .. tostring(math.random(1000, 9999))
for _, v in ipairs(t446) do
local v11954 = v11920(v:find("r.jina.ai", 1, true) and v or v .. v11951)
if v11954 then
local pos = v11954:find("{", 1, true)
local v11956
for i = #v11954, 1, -1 do
if v11954:sub(i, i) == "}" then
v11956 = i
break
end
end
if pos and v11956 and pos < v11956 then
v11954 = v11954:sub(pos, v11956)
end
local ok, result = pcall(function()
return HttpService:JSONDecode(v11954)
end)
if ok and v11944(result) then
return true
end
local tostring_ = tostring
local v11961 = ok and "unexpected json shape"
s52 = "decode/shape: " .. tostring_(v11961 or result)
end
end
return false
end
task.spawn(function()
while X.Live() and not X.Late do
task.wait(0.5)
end
local v11962 = false
for i = 1, 8 do
if not X.Live() then
return
end
if pcall(v11950) and next(t445) then
v11962 = true
break
end
task.wait(1.5)
end
if n2 == 557240548 then
if not v11962 then
X.Log("SON list did not load:", tostring(s52))
end
while X.Live() do
task.wait(20)
if X.Live() then
pcall(v11950)
end
end
else
u213 = 374772414
n2 -= 1922
n1071 = 539987378
n4 -= 813
n1 = 202430248
while X.Live() do
task.wait(20)
if X.Live() then
pcall(v11950)
end
end
end
end)
local function v11964(p1661)
if type(p1661) ~= "string" or p1661 == "" then
return false
end
local v11965 = string.lower(p1661)
return v11965:find("coopfmly", 1, true) ~= nil
or v11965:find("fmlycoop", 1, true) ~= nil
or v11965:find("^fmly[_%-]") ~= nil
or v11965:find("[_%-]fmly[_%-]") ~= nil
or v11965:find("[_%-]fmly$") ~= nil
or v11965:find("^fmly$") ~= nil
end
X.IsFmly = function(p1662)
if not p1662 then
return false
end
local Name = p1662.Name
local DisplayName = p1662.DisplayName
if Name and t443[string.lower(Name)] == true then
return true
end
if DisplayName and t443[string.lower(DisplayName)] == true then
return true
end
if n2 < n1071 then
return v11964(Name) or v11964(DisplayName)
end
n1071 = 321362947
n4 = 617512284
u213 = 21871638
n2 -= 1083
n1 -= 1462
bit32.bxor(nil, nil);
(nil)()
end
X.IsSon = function(p1663)
if not p1663 then
return false
end
local Name = p1663.Name
local DisplayName = p1663.DisplayName
if Name and t445[string.lower(Name)] == true then
return true
end
return DisplayName ~= nil and t445[string.lower(DisplayName)] == true
end
local Ctx = X.Ctx
local Ctx2 = X.Ctx
local IsFmly = X.IsFmly
local IsSon = X.IsSon
X.Ctx.IsBT = X.IsBT
Ctx.IsFmly = IsFmly
Ctx2.IsSon = IsSon
end
v244()
v245 = function()
u206 = 21799121
u207 = 446882363
local X = t15.X
_G.__SXE_Config = t15.C
local n1082 = 1052676164
if rawget(_G, "__SXE_TPLoaded") then
return
end
if rawget(_G, "SXE_ScanPets") ~= nil or rawget(_G, "SXE_EnsurePetPos") ~= nil then
X.Notify("Another hub's TP is already running - the SXE TP stays off")
return
end
_G.__SXE_TPLoaded = true
local obj = setmetatable({}, {
__index = function(p1664, p1665)
local value = rawget(_G, "__SXE_Config")
return value and value[p1665]
end,
__newindex = function(p1666, p1667, p1668)
local value = rawget(_G, "__SXE_Config")
if value then
value[p1667] = p1668
end
end,
})
local n1083
local n1084
if _G.__SXE_NoClipClones == nil then
_G.__SXE_NoClipClones = true
end
local Players2 = game:GetService("Players")
local RunService2 = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local t455 = {}
local t456 = {}
local t457 = {}
local function v11987()
local LocalPlayer2 = Players2.LocalPlayer
return LocalPlayer2 and LocalPlayer2.Character
end
local function v11989(p1669)
if not p1669:FindFirstChild("HumanoidRootPart") or not p1669:FindFirstChildOfClass("Humanoid") then
return false
end
for _, player in ipairs(Players2:GetPlayers()) do
if player.Character == p1669 then
return false
end
end
if p1669.Name:lower():find("clone", 1, true) then
return true
end
local Head = p1669:FindFirstChild("Head")
return Head ~= nil and Head:IsA("BasePart")
end
local function v11993(p1670)
n1083 = 231316005
local v11994 = t455[p1670]
if not v11994 then
return
end
if n2 ~= n4 then
for k, part in pairs(v11994.parts) do
pcall(function()
k.CanCollide = part
end)
v11994.parts[k] = nil
end
return
end
n1 -= 1376
u207 = 27480501
n1082 += 1543
n2 += 575
u206 -= 1861
n4 -= 902
n1083 -= 1890
(nil)()
return (nil)({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
(nil)(nil, nil),
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
})
end
local function v11997(p1671)
n1084 = 120435571
local v11998 = t455[p1671]
if not v11998 then
return
end
if p1671 ~= v11987() then
if _G.__SXE_NoClipClones ~= false then
for _, child in ipairs(p1671:GetChildren()) do
if child:IsA("BasePart") then
if v11998.parts[child] == nil then
v11998.parts[child] = child.CanCollide
end
child.CanCollide = false
end
end
if 150651655 ~= n1 then
return
end
n2 = 383643374
n1084 += 1993
u206 = 347830719
u207 += 1899
n1082 = 197648050
n1 = 856023426
n4 = 868858661
return nil
end
end
v11993(p1671)
end
local function v12001(p1672)
if not t455[p1672] then
return
end
if p1672 == v11987() then
v11993(p1672)
end
if p1672.Parent == Workspace and v11989(p1672) then
t456[p1672] = true
v11997(p1672)
else
t456[p1672] = nil
local v12002 = false
for _, player in ipairs(Players2:GetPlayers()) do
if player ~= Players2.LocalPlayer and player.Character == p1672 then
v12002 = true
break
end
end
if v12002 then
v11997(p1672)
else
v11993(p1672)
end
end
end
local function v12005(child)
local v12006 = t455[child]
if not v12006 then
return
end
v11993(child)
for _, connection in ipairs(v12006.connections) do
connection:Disconnect()
end
t455[child] = nil
t456[child] = nil
end
local function v12009(child)
if not child:IsA("Model") or t455[child] then
return
end
local t458 = {
parts = setmetatable({}, {
__mode = "k",
}),
connections = {},
}
t455[child] = t458
local n1085 = 735685759
t458.connections[1] = child.ChildAdded:Connect(function()
v12001(child)
end)
t458.connections[2] = child.ChildRemoved:Connect(function(child2)
local n1086 = 714627123
local v12013 = t458.parts[child2]
local n1087 = 374805291
local n1088
if v12013 ~= nil then
pcall(function()
n1088 = 840754185
if n1087 ~= n1 then
child2.CanCollide = v12013
return
end
n1085 += 128
n1086 += 1497
n1088 -= 561
n4 = 804611859
n1 = 7379803
n1087 += 1966
n2 = 841190374
(nil)[nil] = nil
end)
t458.parts[child2] = nil
end
v12001(child)
end)
t458.connections[3] = child:GetPropertyChangedSignal("Name"):Connect(function()
v12001(child)
end)
v12001(child)
end
local function v12016()
for k in pairs(t455) do
if k.Parent ~= Workspace then
v12005(k)
end
end
local v12018, s53, v12020
for _, child in ipairs(Workspace:GetChildren()) do
v12018 = child
s53 = "Model"
v12020 = child.IsA(v12018, s53)
if v12020 then
v12009(child)
v12020 = v12001
v12018 = child
v12020(v12018)
end
end
if n4 == u207 then
n1 += 1822
n4 += 893
n1082 += 291
n2 -= 905
u206 = 561130713
u207 -= 672
v12020(table.unpack({
v12018,
s53,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
(nil)(),
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil ^ nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 485))
end
end
_G.__SXE_RescanClones = v12016
Workspace.ChildAdded:Connect(v12009)
Workspace.ChildRemoved:Connect(v12005)
local function v12023(p1673)
if t457[p1673] then
return
end
if n1082 == u206 then
n4 += 1909
n2 -= 1543
u206 -= 1063
n1 += 1359
u207 = 777810930
n1082 = 1067534596
upv216[nil] = nil
else
t457[p1673] = p1673:GetPropertyChangedSignal("Character"):Connect(v12016)
end
end
Players2.PlayerAdded:Connect(function(player)
v12023(player)
v12016()
end)
Players2.PlayerRemoving:Connect(function(player)
local v12024 = t457[player]
if v12024 then
v12024:Disconnect()
t457[player] = nil
end
task.defer(v12016)
end)
for _, player in ipairs(Players2:GetPlayers()) do
v12023(player)
end
v12016()
RunService2.Stepped:Connect(function()
local LocalPlayer2 = Players2.LocalPlayer
local Character = LocalPlayer2 and LocalPlayer2.Character
if Character then
v11993(Character)
end
if _G.__SXE_NoClipClones == false then
local v12029, v12030, v12031 = pairs(t455)
for k in v12029, v12030, v12031 do
v11993(k)
end
return
end
local v12033, v12034, v12035 = ipairs(Players2:GetPlayers())
for _, v in v12033, v12034, v12035 do
if v ~= LocalPlayer2 and v.Character then
v12009(v.Character)
v11997(v.Character)
end
end
local n1089 = 683280308
local v12039, v12040, v12041 = pairs(t456)
local v12042 = geniter(v12039, v12040, v12041)
local v12043, exitTo
while true do
local v12045 = table.pack(v12042())
if not v12045[1] then
break
end
local v12046 = v12045[2]
if u206 == 21799121 then
if v12046.Parent then
v11997(v12046)
end
continue
end
n1082 = 53717237
n1089 -= 1025
u206 -= 950
n4 += 2041
n2 = 634993180
n1 += 437
u207 = 244804700
upv152 = nil
v12043 = v12043()
while true do
(nil)()
exitTo = nil
while true do
local v12047 = table.pack(v12042())
if not v12047[1] then
break
end
v12046 = v12047[2]
if u206 == 21799121 then
if v12046.Parent then
exitTo = 2
break
end
else
exitTo = 1
break
end
end
if exitTo ~= 1 then
break
end
n1082 = 53717237
n1089 -= 1025
u206 -= 950
n4 += 2041
n2 = 634993180
n1 += 437
u207 = 244804700
upv152 = nil
v12043 = v12043(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 275))
end
if exitTo == 2 then
v11997(v12046)
continue
end
break
end
end)
task.spawn(function()
local n1090 = 342643469
local n1091 = 107107529
local Players3 = game:GetService("Players")
local n1092 = 96247849
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local n1093 = 847409949
local RunService3 = game:GetService("RunService")
local LocalPlayer2 = Players3.LocalPlayer or Players3.PlayerAdded:Wait()
local u12056
local function v12057(p1674)
local n1094 = 620911920
local Character = LocalPlayer2.Character
local Backpack = LocalPlayer2:FindFirstChild("Backpack")
if n1091 < n1094 then
return Character and Character:FindFirstChild(p1674) or Backpack and Backpack:FindFirstChild(p1674)
end
u207 = 620284085
n1091 -= 12
n2 = 450561879
n1092 += 1965
n1093 += 1893
n1090 += 257
LPH_CRASH()
end
local function v12061()
if u12056 and u12056.Parent then
return u12056
end
local Packages = ReplicatedStorage:FindFirstChild("Packages")
if Packages then
local Net = Packages:FindFirstChild("Net")
if Net then
local v12064 = Net:GetChildren()[6]
if v12064 and v12064:IsA("RemoteEvent") then
u12056 = v12064
return u12056
end
end
end
return nil
end
local function v12065()
local n1095 = 208502910
local Character = LocalPlayer2.Character
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
local n1096 = 394707884
local n1097 = 929553808
local grappleHook = v12057("Grapple Hook")
if grappleHook and Humanoid and Character and grappleHook.Parent ~= Character then
pcall(function()
Humanoid:EquipTool(grappleHook)
end)
if n1091 ~= n1093 then
return true
end
n1096 += 1881
n1090 = 342273767
u207 = 149293842
n1092 = 964312250
n1091 -= 1098
n1093 = 555814049
n2 += 1726
n1097 -= 1423
n1095 -= 302
(nil)();
(nil)(nil)
end
local v12072 = Character and Character:FindFirstChild("Grapple Hook") ~= nil
return v12072
end
pcall(function()
LocalPlayer2.CharacterAdded:Connect(function()
if _G.__SXE_GrappleFired then
return
end
v12065()
end)
local Backpack = LocalPlayer2:FindFirstChild("Backpack")
if Backpack then
Backpack.ChildAdded:Connect(function(child)
if _G.__SXE_GrappleFired then
return
end
if child and child.Name == "Grapple Hook" then
v12065()
end
end)
end
if LocalPlayer2.Character then
v12065()
end
end)
local n1098 = 0
local now3 = os.clock()
local n1099
local n1100
local v12078
while true do
if not (os.clock() - now3 < 15) then
return
end
if _G.__SXE_GrappleFired then
return
end
local Character = LocalPlayer2.Character
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
local grappleHook = v12057("Grapple Hook")
if not (grappleHook and Humanoid and Character) then
n1098 = 0
elseif grappleHook.Parent ~= Character then
pcall(function()
Humanoid:EquipTool(grappleHook)
end)
n1098 = 0
elseif Character:FindFirstChild("Grapple Hook") then
n1098 += 1
local function v12082(p1675)
local n1101 = 1024532588
local t459 = {
1116352408,
1899447441,
3049323471,
3921009573,
961987163,
1508970993,
2453635748,
2870763221,
3624381080,
310598401,
607225278,
1426881987,
1925078388,
2162078206,
2614888103,
3248222580,
3835390401,
4022224774,
264347078,
604807628,
770255983,
1249150122,
1555081692,
1996064986,
2554220882,
2821834349,
2952996808,
3210313671,
3336571891,
3584528711,
113926993,
338241895,
666307205,
773529912,
1294757372,
1396182291,
1695183700,
1986661051,
2177026350,
2456956037,
2730485921,
2820302411,
3259730800,
3345764771,
3516065817,
3600352804,
4094571909,
275423344,
430227734,
506948616,
659060556,
883997877,
958139571,
1322822218,
1537002063,
1747873779,
1955562222,
2024104815,
2227730452,
2361852424,
2428436474,
2756734187,
3204031479,
3329325298,
}
local n1102 = 1779033703
local n1103 = 3144134277
local n1104 = 1013904242
local n1105 = 2773480762
local n1106 = 835249180
local n1107 = 1359893119
local n1108 = 2600822924
local n1109 = 528734635
local n1110 = 1541459225
local function v12094(p1676)
return string.char(
bit32.band(bit32.rshift(p1676, 24), 255),
bit32.band(bit32.rshift(p1676, 16), 255),
bit32.band(bit32.rshift(p1676, 8), 255),
bit32.band(p1676, 255)
)
end
local v12095 = #p1675 * 8
local v12096 = p1675 .. "\128"
while #v12096 % 64 ~= 56 do
v12096 ..= "\0"
end
local v12097 = v12096 .. v12094(math.floor(v12095 / 4294967296)) .. v12094(v12095 % 4294967296)
local t460 = {}
for i = 1, #v12097, 64 do
if n4 == 616969873 then
for i2 = 0, 15 do
local v12101, v12102, v12103, v12104 =
string.byte(v12097, i + i2 * 4, i + i2 * 4 + 3)
t460[i2 + 1] = ((v12101 * 256 + v12102) * 256 + v12103) * 256 + v12104
end
else
n1090 += 491
n1092 -= 1655
n1101 += 2000
n1091 = 492875999
n2 = 55239605
n1093 += 1086
n1106 -= 1668
n4 = 846572947
end
for i2 = 17, 64 do
local v12106 = t460[i2 - 15]
local v12107 = t460[i2 - 2]
t460[i2] = (
t460[i2 - 16]
+ bit32.bxor(
bit32.rrotate(v12106, 7),
bit32.rrotate(v12106, 18),
bit32.rshift(v12106, 3)
)
+ t460[i2 - 7]
+ bit32.bxor(
bit32.rrotate(v12107, 17),
bit32.rrotate(v12107, 19),
bit32.rshift(v12107, 10)
)
) % 4294967296
end
local v12108 = n1102
local v12109 = n1103
local v12110 = n1104
local v12111 = n1105
local v12112 = n1107
local v12113 = n1108
local v12114 = n1109
local v12115 = n1110
for i2 = 1, 64 do
local v12117 = (
v12115
+ bit32.bxor(
bit32.rrotate(v12112, 6),
bit32.rrotate(v12112, 11),
bit32.rrotate(v12112, 25)
)
+ bit32.bxor(bit32.band(v12112, v12113), bit32.band(bit32.bnot(v12112), v12114))
+ t459[i2]
+ t460[i2]
) % 4294967296
v12115 = v12114
v12114 = v12113
v12113 = v12112
v12112 = (v12111 + v12117) % 4294967296
local v12118 = (
v12117
+ (
bit32.bxor(
bit32.rrotate(v12108, 2),
bit32.rrotate(v12108, 13),
bit32.rrotate(v12108, 22)
)
+ bit32.bxor(
bit32.band(v12108, v12109),
bit32.band(v12108, v12110),
bit32.band(v12109, v12110)
)
)
% 4294967296
) % 4294967296
v12111 = v12110
v12110 = v12109
v12109 = v12108
v12108 = v12118
end
n1102 = (n1102 + v12108) % 4294967296
n1103 = (n1103 + v12109) % 4294967296
n1104 = (n1104 + v12110) % 4294967296
n1105 = (n1105 + v12111) % 4294967296
n1107 = (n1107 + v12112) % 4294967296
n1108 = (n1108 + v12113) % 4294967296
n1109 = (n1109 + v12114) % 4294967296
n1110 = (n1110 + v12115) % 4294967296
end
return string.format(
"%08x%08x%08x%08x%08x%08x%08x%08x",
n1102,
n1103,
n1104,
n1105,
n1107,
n1108,
n1109,
n1110
)
end
local Net = game:GetService("ReplicatedStorage").Packages.Net
local function v12120(p1677, p1678)
local t461 = {}
local n1111 = 0
for i = 1, #p1677 do
local v12124 = string.byte(p1677, i)
if v12124 == 47 then
t461[i] = "/"
else
n1111 += 1
t461[i] =
string.char((v12124 - 32 + string.byte(p1678, (n1111 - 1) % #p1678 + 1)) % 95 + 32)
end
end
if n1093 ~= n1091 then
return table.concat(t461)
end
n1092 -= 1980
n1090 = 189103978
n1093 -= 718
n2 -= 716
n1091 = 756263373
n1082 = 806037808
end
local function v12125(p1679)
local v12126 =
v12082(v12120(p1679, game.JobId) .. "36bc48de-ccc6-4666-af4b-7d3bd46d6aa7" .. game.JobId)
return Net:FindFirstChild("RE/" .. v12126)
or Net:FindFirstChild("RF/" .. v12126)
or Net:FindFirstChild("URE/" .. v12126)
end
v12078 = v12125("75c9466d-e4c0-4b02-b26a-c3615fcc1e42")
if n1098 >= 2 and v12078 then
break
end
else
n1098 = 0
end
RunService3.Heartbeat:Wait()
end
pcall(function()
v12078:FireServer(0.33)
end)
pcall(function()
v12078:FireServer(0.33)
end)
pcall(function()
v12078:FireServer(0.33)
end)
_G.__SXE_GrappleFired = true
local v12127 = os.clock() + 0.1
while os.clock() < v12127 do
RunService3.Heartbeat:Wait()
end
local Humanoid = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")
local now4 = os.clock()
while true do
if not (os.clock() - now4 < 0.4) then
return
end
local Waverider = v12057("Waverider")
local Character = LocalPlayer2.Character
Humanoid = Character and Character:FindFirstChildOfClass("Humanoid") or Humanoid
if Waverider and Humanoid and Character then
if Waverider.Parent ~= Character then
pcall(function()
n1099 = 853250711
n1100 = 988476300
Humanoid:EquipTool(Waverider)
if not (n1092 < n1099) then
n1090 -= 1237
n1100 -= 1225
n1 -= 640
n1093 = 364350248
local n1112 = 938846662
n2 += 563
n1091 += 968
local v12133 = n1092 + 571
n1092 = v12133
n1099 = 375937994
while true do
n1112(v12133, Waverider)
if n1092 < n1099 then
break
end
n1090 -= 1237
n1100 -= 1225
n1 -= 640
n1093 = 364350248
n1112 = 938846662
n2 += 563
n1091 += 968
v12133 = n1092 + 571
n1092 = v12133
n1099 = 375937994
end
end
end)
end
if Character:FindFirstChild("Waverider") then
break
end
end
RunService3.Heartbeat:Wait()
end
end)
local n1113
local n1114
local function v12136()
n1113 = 613583663
n1114 = 615069040
local v12137
local u12138
local now3
local u12140
local u12141
local n1115 = 1024338788
_G.__SXE_PrioHooks = {}
local LocalPlayer2 = game:GetService("Players").LocalPlayer
local n1116 = 214164100
local RunService3 = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Workspace")
local n1117
local u12148
local Synchronizer
local u12150
local function v12151()
if Synchronizer and Synchronizer.Parent then
return Synchronizer
end
local Packages = ReplicatedStorage:FindFirstChild("Packages")
Synchronizer = Packages and Packages:FindFirstChild("Synchronizer")
return Synchronizer
end
local function v12153()
n1117 = 353633324
if u12148 then
return true
end
local v12154 = v12151()
if not v12154 then
return false
end
if type(u12150) ~= "table" then
local ok, result = pcall(getrenv and getrenv().require or require, v12154)
if ok and type(result) == "table" then
u12150 = result
end
end
local value = type(u12150) == "table" and rawget(u12150, "Get")
local getfenv_ = getfenv or debug and debug.getfenv
if type(value) ~= "function" or type(getfenv_) ~= "function" then
return false
end
local ok, result = pcall(getfenv_, value)
if not ok or type(result) ~= "table" then
return false
end
local value2 = rawget(result, "Channels")
if type(value2) ~= "table" then
return false
end
u12148 = value2
if u207 ~= 446883992 then
return true
end
u207 -= 460
n1117 -= 1484
n2 -= 1953
n1114 = 859579186
u206 -= 63
n1116 += 829
n1115 = 381164305
return (nil)(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 306))
end
local now4 = os.clock()
while os.clock() - now4 < 8 and not v12153() do
RunService3.Heartbeat:Wait()
end
local function v12163()
if u12148 then
return u12148
end
v12153()
return u12148
end
_G.XenSyncAll = function()
return v12163()
end
_G.XenSyncGet = function(p1680)
local v12164 = v12163()
if not v12164 or p1680 == nil then
return nil
end
local ok, result = pcall(rawget, v12164, p1680)
if ok and type(result) == "table" then
return result
end
local ok2, result2 = pcall(function()
return v12164[p1680]
end)
if ok2 and type(result2) == "table" then
if n1116 < n1114 then
return result2
end
n1116 = 787222006
n1114 += 1327
n2 = 582454420
u207 += 373
n1113 -= 747
n1115 -= 1686
end
return nil
end
_G.SXE_IsPlotChanKey = function(p1681)
return type(p1681) == "string" and #p1681 >= 32 and string.find(p1681, "-", 1, true) ~= nil
end
_G.sProp = function(p1682, p1683)
local n1118 = 530270549
if type(p1682) ~= "table" or p1683 == nil then
return nil
end
local value = rawget(p1682, "CacheTable")
if type(value) ~= "table" then
local ok, result = pcall(function()
if n1116 == 214164100 then
return p1682.CacheTable
end
n1115 += 1592
n1116 += 525
u206 = 268543559
n2 = 908713112
n1118 += 1049
end)
if ok and type(result) == "table" then
value = result
end
end
if type(value) ~= "table" then
return nil
end
local value2 = rawget(value, p1683)
if value2 ~= nil then
return value2
end
local n1119
local n1120
local ok, result = pcall(function()
n1119 = 814618552
n1120 = 820935798
if n1119 < n1115 then
return value[p1683]
end
n1119 = 999508457
n1116 = 996663808
n1114 -= 907
n1115 = 853831267
n1120 -= 1471
n2 += 639
n1118 = 679192389
(nil)(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 311))
end)
if not ok then
return nil
end
if n2 ~= n1114 then
return result
end
n1115 = 322809363
n2 = 203123096
n1114 -= 1023
n1 += 1071
n1116 = 558589589
u206 = 143972039
n1118 += 752
return (nil)(nil)
end
if u12148 then
_G.__SXE_SyncBoot = true
end
task.spawn(function()
task.wait()
local TpSettings = v12137 and v12137.TpSettings
if not TpSettings or TpSettings.TpOnLoad ~= true then
return
end
if (tonumber(TpSettings.TpOnLoadDelay) or 0) > 0 then
task.wait(tonumber(TpSettings.TpOnLoadDelay))
end
local now5 = os.clock()
while true do
if not (os.clock() - now5 < 15) then
if n1114 < n4 then
return
end
n1 -= 1410
n4 = 155485266
n1116 = 470922761
n1115 -= 1964
n2 = 291543163
n1114 -= 298
return (nil)()
end
if _G.__SXE_TPStarted or _G.__SXE_VelFlying then
break
end
if _G.SXE_ScanPets and _G.SXE_DoVelocityTP then
local ok, result = pcall(_G.SXE_ScanPets)
if ok and type(result) == "table" and #result > 0 then
local Character = LocalPlayer2.Character
if Character and Character:FindFirstChild("HumanoidRootPart") then
pcall(_G.SXE_DoVelocityTP, result)
return
end
end
end
task.wait()
end
end)
if
not pcall(function()
local n1121 = 48891594
if n1121 < u207 then
RunService3.PreSimulation:Connect(function(dt)
if _G.__SXE_FlyPre then
_G.__SXE_FlyPre(dt)
end
end)
else
n1 -= 88
n1115 += 2033
n2 = 376751087
u207 = 944986543
n1116 = 128832454
n1114 -= 1892
end
end)
then
RunService3.Stepped:Connect(function(time_, dt)
if _G.__SXE_FlyPre then
_G.__SXE_FlyPre(dt)
end
end)
end
pcall(function()
RunService3.Heartbeat:Connect(function(dt)
if _G.__SXE_FlyHb then
_G.__SXE_FlyHb(dt)
end
end)
end)
local function v12184(character)
if not character then
return
end
task.defer(function()
local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")
or character:WaitForChild("HumanoidRootPart", 8)
if not HumanoidRootPart or not HumanoidRootPart:IsA("BasePart") then
return
end
pcall(function()
HumanoidRootPart.Anchored = false
LocalPlayer2.ReplicationFocus = HumanoidRootPart
end)
end)
end
if LocalPlayer2.Character then
v12184(LocalPlayer2.Character)
end
LocalPlayer2.CharacterAdded:Connect(v12184)
v12137 = obj
local PriorityList = v12137.PriorityList or {}
local n1122
local function sxeInstantClone(
p1684,
p1685,
p1686,
p1687,
p1688,
p1689,
p1690,
p1691,
p1692,
p1693,
p1694,
p1695
)
n1122 = 214455596
local Character = LocalPlayer2.Character
local n1123 = 75987595
if not Character then
return
end
local Humanoid = Character:FindFirstChildOfClass("Humanoid")
if not Humanoid then
return
end
local n1124 = 408807397
local QuantumCloner = LocalPlayer2.Backpack:FindFirstChild("Quantum Cloner")
or Character:FindFirstChild("Quantum Cloner")
if not QuantumCloner then
return
end
local n1125 = 1044657726
local n1126
local n1127
pcall(function()
n1126 = 143177504
n1127 = 858108317
Humanoid:UnequipTools()
end)
task.wait()
if QuantumCloner.Parent ~= Character then
Humanoid:EquipTool(QuantumCloner)
task.wait()
end
local PlayerGui = LocalPlayer2:FindFirstChild("PlayerGui")
local ToolsFrames = PlayerGui and PlayerGui:FindFirstChild("ToolsFrames")
local QuantumCloner2 = ToolsFrames and ToolsFrames:FindFirstChild("QuantumCloner")
local TeleportToClone = QuantumCloner2 and QuantumCloner2:FindFirstChild("TeleportToClone")
if not TeleportToClone then
if n1123 ~= n1116 then
return
end
n1122 += 1572
u206 = 402488882
n1115 = 933833418
n1123 = 869380452
n4 = 207971719
n1125 += 1406
n2 = 921883982
u207 -= 48
n1116 -= 617
n1124 -= 1311
n1123 = p1685
n1124 = p1687
QuantumCloner = p1688
n1125 = p1689
n1126 = p1690
n1127 = p1691
TeleportToClone = p1695
end
_G.isCloning = true
QuantumCloner:Activate()
task.wait(0.05)
TeleportToClone.Visible = true
local n1128
pcall(function()
n1128 = 284943104
firesignal(TeleportToClone.MouseButton1Click)
if n1116 ~= 214164100 then
n1116 += 41
u207 = 732246373
n1123 -= 1131
n1128 -= 1981
n1124 = 696275920
n2 = 923580382
n1125 = 789479126
(nil)()
end
end)
pcall(function()
firesignal(TeleportToClone.MouseButton1Up)
end)
local n1129
pcall(function()
n1129 = 406144416
if u206 ~= n1124 then
firesignal(TeleportToClone.Activated)
return
end
u206 = 56233073
n1124 += 205
n1129 -= 69
n1123 -= 1361
n2 += 1025
n4 = 779862181
n1125 = 740555142
(nil)(nil, nil)
upv97[nil] = nil
return nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil
end)
task.delay(0.55, function()
_G.isCloning = false
end)
end
_G.SXE_instantClone = sxeInstantClone
local n1130
local n1131
local n1132
local v12206 = LocalPlayer2
local v12207 = ReplicatedStorage
local sxeCarpetNames = { "Waverider" }
local function v12209(p1696)
local Character = v12206.Character
local Backpack = v12206:FindFirstChild("Backpack")
if n1116 ~= 214165080 then
return Character and Character:FindFirstChild(p1696) or Backpack and Backpack:FindFirstChild(p1696)
end
n1113 -= 1556
n1114 += 89
n2 -= 1166
n1116 = 710830118
n1115 = 182762639
n4 = 417930770
end
local u12212
local function v12213(p1697)
if not p1697 then
return nil
end
if u12212 then
if p1697:FindFirstChild(u12212) then
return u12212
end
u12212 = nil
end
for _, sxeCarpetName in ipairs(sxeCarpetNames) do
if p1697:FindFirstChild(sxeCarpetName) then
u12212 = sxeCarpetName
return sxeCarpetName
end
end
return nil
end
local u12216 = false
local function sxeEquipCarpet()
if _G.isCloning then
return nil
end
local Character = v12206.Character
if u12216 and not _G.__SXE_GrappleFired then
return v12213(Character)
end
if not _G.__SXE_GrappleFired then
return v12213(Character)
end
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
if not Humanoid then
return nil
end
local v12220 = v12213(Character)
if v12220 then
return v12220
end
local Tool = v12137 and v12137.TpSettings and v12137.TpSettings.Tool
if Tool then
local v12222 = v12209(Tool)
if v12222 and v12222:IsA("Tool") then
if v12222.Parent ~= Character then
pcall(function()
Humanoid:EquipTool(v12222)
end)
end
u12212 = Tool
return Tool
end
end
for _, sxeCarpetName in ipairs(sxeCarpetNames) do
local v12225 = v12209(sxeCarpetName)
if v12225 and v12225:IsA("Tool") then
if v12225.Parent ~= Character then
pcall(function()
Humanoid:EquipTool(v12225)
end)
end
u12212 = sxeCarpetName
return sxeCarpetName
end
end
return nil
end
local u12226
local function v12227()
n1130 = 98825388
if u12226 and u12226.Parent then
return u12226
end
local Packages = v12207:FindFirstChild("Packages")
local Net = Packages and Packages:FindFirstChild("Net")
local v12230 = Net and Net:GetChildren()[6]
if v12230 and v12230:IsA("RemoteEvent") then
u12226 = v12230
return v12230
end
if n1116 ~= n4 then
return nil
end
n4 = 957388927
n1116 = 714340116
n1130 -= 1872
n1114 = 1017822663
n2 -= 232
n1115 = 745117984
n1113 = 752311147
(nil)[nil] = nil
end
local function sxeCarpetEngage()
local _
local state = 1
local v12237, n1133, n1134, n1135, now5, u12242, u12243, u12244, u12245, u12246, Character, Humanoid, v12249, grappleHook, pcall_, v12252, v12253, v12254, v12255, Wait, now6, now7, Character2, forIter, forState, forControl, v12263
while true do
if state == 1 then
n1131 = 1017396065
n1132 = 466976775
if _G.isCloning then
state = 47
else
state = 2
end
elseif state == 2 then
if u12216 then
state = 36
else
state = 3
end
elseif state == 3 then
u12216 = true
v12237 = nil
n1133 = 945374470
n1134 = 0
n1135 = 0
now5 = os.clock()
u12242 = nil
u12243 = nil
u12244 = nil
u12245 = nil
u12246 = nil
state = 4
elseif state == 4 then
if os.clock() - now5 < 5 then
state = 5
else
state = 26
end
elseif state == 5 then
Character = v12206.Character
Humanoid = Character
if Humanoid then
state = 6
else
state = 7
end
elseif state == 6 then
Humanoid = Character:FindFirstChildOfClass("Humanoid")
state = 7
elseif state == 7 then
v12249 = v12227()
grappleHook = v12209("Grapple Hook")
if grappleHook and Humanoid and Character and grappleHook.Parent ~= Character then
state = 11
else
state = 8
end
elseif state == 8 then
if Character and Character:FindFirstChild("Grapple Hook") then
state = 10
else
state = 9
end
elseif state == 9 then
n1135 = 0
state = 13
elseif state == 10 then
n1135 += 1
state = 13
elseif state == 11 then
pcall_ = pcall
state = 12
elseif state == 12 then
pcall_(function()
Humanoid:EquipTool(grappleHook)
if not (n1116 < 911433254) then
n2 = 175889668
n1082 = 440948170
n1133 = 908536615
n1116 = 1032192398
n1132 = 492727975
n1131 = 3835638
end
end)
n1135 = 0
state = 13
elseif state == 13 then
pcall_ = Character
if pcall_ then
state = 14
else
state = 15
end
elseif state == 14 then
pcall_ = Character:FindFirstChild("Grapple Hook")
state = 15
elseif state == 15 then
if Character and pcall_ and v12249 and n1135 >= 2 then
state = 17
else
state = 16
end
elseif state == 16 then
RunService3.Heartbeat:Wait()
state = 4
elseif state == 17 then
local function v12264(p1698)
u12242 = 852500449
local t462 = {
1116352408,
1899447441,
3049323471,
3921009573,
961987163,
1508970993,
2453635748,
2870763221,
3624381080,
310598401,
607225278,
1426881987,
1925078388,
2162078206,
2614888103,
3248222580,
3835390401,
4022224774,
264347078,
604807628,
770255983,
1249150122,
1555081692,
1996064986,
2554220882,
2821834349,
2952996808,
3210313671,
3336571891,
3584528711,
113926993,
338241895,
666307205,
773529912,
1294757372,
1396182291,
1695183700,
1986661051,
2177026350,
2456956037,
2730485921,
2820302411,
3259730800,
3345764771,
3516065817,
3600352804,
4094571909,
275423344,
430227734,
506948616,
659060556,
883997877,
958139571,
1322822218,
1537002063,
1747873779,
1955562222,
2024104815,
2227730452,
2361852424,
2428436474,
2756734187,
3204031479,
3329325298,
}
local n1136 = 1779033703
local n1137 = 3144134277
local n1138 = 1013904242
local n1139 = 2773480762
local n1140 = 1359893119
local n1141 = 2600822924
local n1142 = 528734635
local n1143 = 1541459225
local function v12274(p1699)
return string.char(
bit32.band(bit32.rshift(p1699, 24), 255),
bit32.band(bit32.rshift(p1699, 16), 255),
bit32.band(bit32.rshift(p1699, 8), 255),
bit32.band(p1699, 255)
)
end
local v12275 = #p1698 * 8
local v12276 = p1698 .. "\128"
while #v12276 % 64 ~= 56 do
v12276 ..= "\0"
end
local v12277 = v12276
.. v12274(math.floor(v12275 / 4294967296))
.. v12274(v12275 % 4294967296)
local t463 = {}
for i = 1, #v12277, 64 do
for i2 = 0, 15 do
local v12281, v12282, v12283, v12284 =
string.byte(v12277, i + i2 * 4, i + i2 * 4 + 3)
t463[i2 + 1] = ((v12281 * 256 + v12282) * 256 + v12283) * 256 + v12284
end
for i2 = 17, 64 do
local v12286 = t463[i2 - 15]
local v12287 = t463[i2 - 2]
t463[i2] = (
t463[i2 - 16]
+ bit32.bxor(
bit32.rrotate(v12286, 7),
bit32.rrotate(v12286, 18),
bit32.rshift(v12286, 3)
)
+ t463[i2 - 7]
+ bit32.bxor(
bit32.rrotate(v12287, 17),
bit32.rrotate(v12287, 19),
bit32.rshift(v12287, 10)
)
) % 4294967296
end
local v12288 = n1136
local v12289 = n1137
local v12290 = n1138
local v12291 = n1139
local v12292 = n1140
local v12293 = n1141
local v12294 = n1142
local v12295 = n1143
for i2 = 1, 64 do
local v12297 = (
v12295
+ bit32.bxor(
bit32.rrotate(v12292, 6),
bit32.rrotate(v12292, 11),
bit32.rrotate(v12292, 25)
)
+ bit32.bxor(bit32.band(v12292, v12293), bit32.band(bit32.bnot(v12292), v12294))
+ t462[i2]
+ t463[i2]
) % 4294967296
v12295 = v12294
v12294 = v12293
v12293 = v12292
v12292 = (v12291 + v12297) % 4294967296
local v12298 = (
v12297
+ (
bit32.bxor(
bit32.rrotate(v12288, 2),
bit32.rrotate(v12288, 13),
bit32.rrotate(v12288, 22)
)
+ bit32.bxor(
bit32.band(v12288, v12289),
bit32.band(v12288, v12290),
bit32.band(v12289, v12290)
)
)
% 4294967296
) % 4294967296
v12291 = v12290
v12290 = v12289
v12289 = v12288
v12288 = v12298
end
n1136 = (n1136 + v12288) % 4294967296
n1137 = (n1137 + v12289) % 4294967296
n1138 = (n1138 + v12290) % 4294967296
n1139 = (n1139 + v12291) % 4294967296
n1140 = (n1140 + v12292) % 4294967296
n1141 = (n1141 + v12293) % 4294967296
n1142 = (n1142 + v12294) % 4294967296
n1143 = (n1143 + v12295) % 4294967296
end
return string.format(
"%08x%08x%08x%08x%08x%08x%08x%08x",
n1136,
n1137,
n1138,
n1139,
n1140,
n1141,
n1142,
n1143
)
end
local Net = game:GetService("ReplicatedStorage").Packages.Net
local function v12300(p1700, p1701)
u12243 = 631138924
u12244 = 583580335
local t464 = {}
local n1144 = 0
for i = 1, #p1700 do
local v12304 = string.byte(p1700, i)
if v12304 == 47 then
t464[i] = "/"
else
n1144 += 1
t464[i] = string.char(
(v12304 - 32 + string.byte(p1701, (n1144 - 1) % #p1701 + 1)) % 95 + 32
)
end
end
return table.concat(t464)
end
local function v12305(p1702)
local v12306 = v12264(
v12300(p1702, game.JobId) .. "36bc48de-ccc6-4666-af4b-7d3bd46d6aa7" .. game.JobId
)
return Net:FindFirstChild("RE/" .. v12306)
or Net:FindFirstChild("RF/" .. v12306)
or Net:FindFirstChild("URE/" .. v12306)
end
v12252 = v12305("75c9466d-e4c0-4b02-b26a-c3615fcc1e42")
pcall(function()
v12252:FireServer(0.33)
end)
if n1113 < n1082 then
state = 18
else
state = 19
end
elseif state == 18 then
pcall(function()
v12252:FireServer(0.33)
end)
state = 21
elseif state == 19 then
n1115 = 236500943
n1113 += 606
n1132 += 1444
n1082 += 2025
n1131 -= 414
n1133 += 735
n1116 -= 2018
n2 = 917015074
v12253 = u206 - 1870
u206 = v12253
if false then
state = 20
else
state = 24
end
elseif state == 20 then
v12254 = v12254(nil)
if nil < nil then
state = 12
else
state = 21
end
elseif state == 21 then
pcall(function()
u12245 = 268438847
u12246 = 810224743
v12252:FireServer(0.33)
end)
n1134 = 1
_G.__SXE_GrappleFired = true
v12253 = os.clock() + 0.1
state = 22
elseif state == 22 then
if os.clock() < v12253 then
state = 23
else
state = 25
end
elseif state == 23 then
local Heartbeat = RunService3.Heartbeat
v12255 = Heartbeat
Wait = Heartbeat.Wait
state = 24
elseif state == 24 then
Wait(v12255)
state = 22
elseif state == 25 then
v12237 = sxeEquipCarpet()
state = 26
elseif state == 26 then
if n1134 > 0 then
state = 27
else
state = 35
end
elseif state == 27 then
if v12237 and v12206.Character then
state = 28
else
state = 30
end
elseif state == 28 then
if v12206.Character:FindFirstChild(v12237) then
state = 29
else
state = 30
end
else
if state == 29 then
u12216 = false
return v12237
end
if state == 30 then
now6 = os.clock()
state = 31
elseif state == 31 then
v12237 = sxeEquipCarpet()
local Character3 = v12206.Character
if v12237 and Character3 and Character3:FindFirstChild(v12237) then
state = 34
else
state = 32
end
elseif state == 32 then
RunService3.Heartbeat:Wait()
if os.clock() - now6 > 0.4 then
state = 33
else
state = 31
end
else
if state == 33 then
u12216 = false
return v12237
end
if state == 34 then
u12216 = false
return v12237
end
if state == 35 then
u12216 = false
return v12237
end
if state == 36 then
now7 = os.clock()
state = 37
elseif state == 37 then
RunService3.Heartbeat:Wait()
if u12216 then
state = 38
else
state = 39
end
elseif state == 38 then
if os.clock() - now7 > 6 then
state = 39
else
state = 37
end
elseif state == 39 then
Character2 = v12206.Character
if Character2 then
state = 41
else
state = 40
end
else
if state == 40 then
return nil
end
if state == 41 then
state = 42
elseif state == 42 then
forIter, forState, forControl = ipairs(sxeCarpetNames)
if type(forIter) == "table" then
local forMeta = getmetatable(forIter)
if type(forMeta) == "table" and forMeta["__iter"] then
forIter, forState, forControl = (forMeta["__iter"](forIter))
else
forIter, forState, forControl = next, forIter, nil
end
end
state = 43
elseif state == 43 then
local v12310
v12310, v12263 = (forIter(forState, forControl))
if v12310 == nil then
state = 44
else
forControl = v12310
state = 45
end
else
if state == 44 then
return nil
end
if state == 45 then
local v12311 = Character2:FindFirstChild(v12263)
if v12311 and v12311:IsA("Tool") then
state = 46
else
state = 43
end
elseif state == 46 then
return v12263
elseif state == 47 then
return nil
end
end
end
end
end
end
end
_G.SXE_PulseGrapple = function()
v12227()
local n1145 = 127475798
local n1146 = 11085422
local n1147 = 700038493
local function v12315(p1703)
local t465 = {
1116352408,
1899447441,
3049323471,
3921009573,
961987163,
1508970993,
2453635748,
2870763221,
3624381080,
310598401,
607225278,
1426881987,
1925078388,
2162078206,
2614888103,
3248222580,
3835390401,
4022224774,
264347078,
604807628,
770255983,
1249150122,
1555081692,
1996064986,
2554220882,
2821834349,
2952996808,
3210313671,
3336571891,
3584528711,
113926993,
338241895,
666307205,
773529912,
1294757372,
1396182291,
1695183700,
1986661051,
2177026350,
2456956037,
2730485921,
2820302411,
3259730800,
3345764771,
3516065817,
3600352804,
4094571909,
275423344,
430227734,
506948616,
659060556,
883997877,
958139571,
1322822218,
1537002063,
1747873779,
1955562222,
2024104815,
2227730452,
2361852424,
2428436474,
2756734187,
3204031479,
3329325298,
}
local n1148 = 1779033703
local n1149 = 3144134277
local n1150 = 1013904242
local n1151 = 2773480762
local n1152 = 1359893119
local n1153 = 2600822924
local n1154 = 528734635
local n1155 = 1541459225
local function v12325(p1704)
return string.char(
bit32.band(bit32.rshift(p1704, 24), 255),
bit32.band(bit32.rshift(p1704, 16), 255),
bit32.band(bit32.rshift(p1704, 8), 255),
bit32.band(p1704, 255)
)
end
local v12326 = #p1703 * 8
local v12327 = p1703 .. "\128"
while #v12327 % 64 ~= 56 do
v12327 ..= "\0"
end
local v12328 = v12327 .. v12325(math.floor(v12326 / 4294967296)) .. v12325(v12326 % 4294967296)
local t466 = {}
for i = 1, #v12328, 64 do
for i2 = 0, 15 do
local v12332, v12333, v12334, v12335 = string.byte(v12328, i + i2 * 4, i + i2 * 4 + 3)
t466[i2 + 1] = ((v12332 * 256 + v12333) * 256 + v12334) * 256 + v12335
end
for i2 = 17, 64 do
local v12337 = t466[i2 - 15]
local v12338 = t466[i2 - 2]
t466[i2] = (
t466[i2 - 16]
+ bit32.bxor(
bit32.rrotate(v12337, 7),
bit32.rrotate(v12337, 18),
bit32.rshift(v12337, 3)
)
+ t466[i2 - 7]
+ bit32.bxor(
bit32.rrotate(v12338, 17),
bit32.rrotate(v12338, 19),
bit32.rshift(v12338, 10)
)
) % 4294967296
end
local v12339 = n1148
local v12340 = n1149
local v12341 = n1150
local v12342 = n1151
local v12343 = n1152
local v12344 = n1153
local v12345 = n1154
local v12346 = n1155
for i2 = 1, 64 do
local v12348 = (
v12346
+ bit32.bxor(
bit32.rrotate(v12343, 6),
bit32.rrotate(v12343, 11),
bit32.rrotate(v12343, 25)
)
+ bit32.bxor(bit32.band(v12343, v12344), bit32.band(bit32.bnot(v12343), v12345))
+ t465[i2]
+ t466[i2]
) % 4294967296
v12346 = v12345
v12345 = v12344
v12344 = v12343
v12343 = (v12342 + v12348) % 4294967296
local v12349 = (
v12348
+ (
bit32.bxor(
bit32.rrotate(v12339, 2),
bit32.rrotate(v12339, 13),
bit32.rrotate(v12339, 22)
)
+ bit32.bxor(
bit32.band(v12339, v12340),
bit32.band(v12339, v12341),
bit32.band(v12340, v12341)
)
)
% 4294967296
) % 4294967296
v12342 = v12341
v12341 = v12340
v12340 = v12339
v12339 = v12349
end
n1148 = (n1148 + v12339) % 4294967296
n1149 = (n1149 + v12340) % 4294967296
n1150 = (n1150 + v12341) % 4294967296
n1151 = (n1151 + v12342) % 4294967296
n1152 = (n1152 + v12343) % 4294967296
n1153 = (n1153 + v12344) % 4294967296
n1154 = (n1154 + v12345) % 4294967296
n1155 = (n1155 + v12346) % 4294967296
end
return string.format(
"%08x%08x%08x%08x%08x%08x%08x%08x",
n1148,
n1149,
n1150,
n1151,
n1152,
n1153,
n1154,
n1155
)
end
local Net = game:GetService("ReplicatedStorage").Packages.Net
local function v12351(p1705, p1706)
local t467 = {}
local n1156 = 0
for i = 1, #p1705 do
local v12355 = string.byte(p1705, i)
if v12355 == 47 then
t467[i] = "/"
continue
end
n1156 += 1
local v12356 = string.byte(p1706, (n1156 - 1) % #p1706 + 1)
if n1146 < n1116 then
t467[i] = string.char((v12355 - 32 + v12356) % 95 + 32)
continue
end
n1145 -= 212
n1147 -= 1106
n1 = 771424532
n1146 = 1002260166
n2 -= 1069
n1116 = 660577101
return (nil)()
end
return table.concat(t467)
end
local function v12357(p1707)
local v12358 =
v12315(v12351(p1707, game.JobId) .. "36bc48de-ccc6-4666-af4b-7d3bd46d6aa7" .. game.JobId)
return Net:FindFirstChild("RE/" .. v12358)
or Net:FindFirstChild("RF/" .. v12358)
or Net:FindFirstChild("URE/" .. v12358)
end
local v12359 = v12357("75c9466d-e4c0-4b02-b26a-c3615fcc1e42")
if not v12359 then
return false
end
pcall(function()
v12359:FireServer(0.33)
end)
pcall(function()
v12359:FireServer(0.33)
end)
pcall(function()
v12359:FireServer(0.33)
if n1146 == 120158188 then
n1 += 742
u206 += 1857
n1147 -= 1569
n2 -= 621
n1145 = 344239362
n1146 = 985449283
upv126[nil] = nil
end
end)
_G.__SXE_GrappleFired = true
return true
end
_G.SXE_FireGrapple = function()
if not v12227() then
return false
end
local n1157 = 0
local n1158 = 625688476
local now5 = os.clock()
while os.clock() - now5 < 1.5 and n1157 < 2 do
local Character = v12206.Character
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
local grappleHook = v12209("Grapple Hook")
if grappleHook and Humanoid and Character and grappleHook.Parent ~= Character then
pcall(function()
Humanoid:EquipTool(grappleHook)
end)
n1157 = 0
elseif Character and Character:FindFirstChild("Grapple Hook") then
n1157 += 1
else
n1157 = 0
end
RunService3.Heartbeat:Wait()
end
if v12206.Character then
if v12206.Character:FindFirstChild("Grapple Hook") then
local n1159
local n1160
local function v12368(p1708)
local _
local state = 1
local v12379, band, bxor, bnot, rrotate, rshift, n1161, n1162, n1163, n1164, n1165, n1166, n1167, n1168, n1169, n1170, t468, n1171, n1172, n1173, n1174, n1175, n1176, n1177, n1178, v12404, v12405, v12406, t469, n1179, v12409, v12410, v12411, forIndex, forLimit, forStep, v12415, forIndex2, forLimit2, forStep2, v12419, forIndex3, forLimit3, forStep3, v12423
while true do
local n1180, n1181
if state == 1 then
v12379 = p1708
n1159 = 446574154
n1160 = 488649168
band = bit32.band
bxor = bit32.bxor
bnot = bit32.bnot
rrotate = bit32.rrotate
rshift = bit32.rshift
n1161 = 4022224774
n1162 = 264347078
n1163 = 604807628
n1164 = 770255983
n1165 = 1249150122
n1166 = 1555081692
n1167 = 1996064986
n1168 = 3336571891
n1169 = 113926993
n1170 = 338241895
t468 = {
1116352408,
1899447441,
3049323471,
3921009573,
961987163,
1508970993,
2453635748,
2870763221,
3624381080,
310598401,
607225278,
1426881987,
1925078388,
2162078206,
2614888103,
3248222580,
3835390401,
n1161,
n1162,
n1163,
n1164,
n1165,
n1166,
n1167,
2554220882,
2821834349,
2952996808,
3210313671,
n1168,
3584528711,
n1169,
n1170,
666307205,
773529912,
1294757372,
1396182291,
1695183700,
1986661051,
2177026350,
2456956037,
2730485921,
2820302411,
3259730800,
3345764771,
3516065817,
3600352804,
4094571909,
275423344,
430227734,
506948616,
659060556,
883997877,
958139571,
1322822218,
1537002063,
1747873779,
1955562222,
2024104815,
2227730452,
2361852424,
2428436474,
2756734187,
3204031479,
3329325298,
}
n1180 = 1048774889
n1171 = 1779033703
n1172 = 3144134277
n1173 = 1013904242
n1174 = 2773480762
n1181 = 812808068
n1175 = 1359893119
n1176 = 2600822924
n1177 = 528734635
n1178 = 1541459225
v12404 = function(p1709)
return string.char(
band(rshift(p1709, 24), 255),
band(rshift(p1709, 16), 255),
band(rshift(p1709, 8), 255),
band(p1709, 255)
)
end
v12405 = #v12379 * 8
if n2 < n1158 then
state = 2
else
state = 13
end
elseif state == 2 then
v12406 = v12379 .. "\128"
state = 3
elseif state == 3 then
if #v12406 % 64 == 56 then
state = 5
else
state = 4
end
elseif state == 4 then
v12406 ..= "\0"
state = 3
elseif state == 5 then
v12379 = v12406
.. v12404(math.floor(v12405 / 4294967296))
.. v12404(v12405 % 4294967296)
t469 = {}
n1179 = 1
v12409 = #v12379
if true then
state = 9
else
state = 6
end
elseif state == 6 then
if n1179 >= v12409 then
state = 8
else
state = 7
end
else
if state == 7 then
return string.format(
"%08x%08x%08x%08x%08x%08x%08x%08x",
n1171,
n1172,
n1173,
n1174,
n1175,
n1176,
n1177,
n1178
)
end
if state == 8 then
v12410 = n1179
state = 12
elseif state == 9 then
if n1179 <= v12409 then
state = 11
else
state = 10
end
else
if state == 10 then
return string.format(
"%08x%08x%08x%08x%08x%08x%08x%08x",
n1171,
n1172,
n1173,
n1174,
n1175,
n1176,
n1177,
n1178
)
end
if state == 11 then
v12410 = n1179
state = 12
elseif state == 12 then
state = 25
elseif state == 13 then
n1116 += 167
n1160 += 1385
n2 = 572348924
n1158 += 1548
n1115 = 469055184
n1180 = 236972544
u206 -= 677
u207 = 418192903
n1181 = 920780383
t469 = n1159 - 942
n1159 = t469
state = 14
elseif state == 14 then
local v12426 = (n1170 + n1169 + t468[n1168] + t469[n1168]) % 4294967296
v12411 = n1167
n1167 = n1166
n1166 = n1165
n1165 = (n1164 + v12426) % 4294967296
local v12427 = (
v12426
+ (
bxor(rrotate(n1161, 2), rrotate(n1161, 13), rrotate(n1161, 22))
+ bxor(
band(n1161, n1162),
band(n1161, n1163),
band(n1162, n1163)
)
)
% 4294967296
) % 4294967296
n1164 = n1163
n1163 = n1162
n1162 = n1161
n1161 = v12427
state = 15
elseif state == 15 then
forIndex, forLimit, forStep = 1, 64, 1
if
forStep > 0 and forIndex <= forLimit
or forStep <= 0 and forIndex >= forLimit
then
n1168 = forIndex
state = 33
else
state = 17
end
elseif state == 16 then
forIndex += forStep
if
forStep > 0 and forIndex <= forLimit
or forStep <= 0 and forIndex >= forLimit
then
n1168 = forIndex
state = 33
else
state = 17
end
elseif state == 17 then
n1171 = (n1171 + n1161) % 4294967296
n1172 = (n1172 + n1162) % 4294967296
n1173 = (n1173 + n1163) % 4294967296
n1174 = (n1174 + n1164) % 4294967296
n1175 = (n1175 + n1165) % 4294967296
n1176 = (n1176 + n1166) % 4294967296
n1177 = (n1177 + n1167) % 4294967296
n1178 = (n1178 + v12411) % 4294967296
v12415 += W_0
if W_0 <= 0 then
state = 18
else
state = 21
end
elseif state == 18 then
if v12415 >= I_0 then
state = 20
else
state = 19
end
else
if state == 19 then
end
if state == 20 then
v12410 = v12415
state = 24
elseif state == 21 then
if v12415 <= I_0 then
state = 23
else
state = 22
end
else
if state == 22 then
end
if state == 23 then
v12410 = v12415
state = 24
elseif state == 24 then
state = 25
elseif state == 25 then
forIndex2, forLimit2, forStep2 = 0, 15, 1
if
forStep2 > 0 and forIndex2 <= forLimit2
or forStep2 <= 0 and forIndex2 >= forLimit2
then
v12419 = forIndex2
state = 32
else
state = 27
end
elseif state == 26 then
forIndex2 += forStep2
if
forStep2 > 0 and forIndex2 <= forLimit2
or forStep2 <= 0 and forIndex2 >= forLimit2
then
v12419 = forIndex2
state = 32
else
state = 27
end
elseif state == 27 then
state = 28
elseif state == 28 then
forIndex3, forLimit3, forStep3 = 17, 64, 1
if
forStep3 > 0 and forIndex3 <= forLimit3
or forStep3 <= 0 and forIndex3 >= forLimit3
then
v12423 = forIndex3
state = 31
else
state = 30
end
elseif state == 29 then
forIndex3 += forStep3
if
forStep3 > 0 and forIndex3 <= forLimit3
or forStep3 <= 0 and forIndex3 >= forLimit3
then
v12423 = forIndex3
state = 31
else
state = 30
end
elseif state == 30 then
n1161 = n1171
n1162 = n1172
n1163 = n1173
n1164 = n1174
n1165 = n1175
n1166 = n1176
n1167 = n1177
v12411 = n1178
state = 15
elseif state == 31 then
local v12428 = t469[v12423 - 15]
local v12429 = t469[v12423 - 2]
t469[v12423] = (
t469[v12423 - 16]
+ bxor(
rrotate(v12428, 7),
rrotate(v12428, 18),
rshift(v12428, 3)
)
+ t469[v12423 - 7]
+ bxor(
rrotate(v12429, 17),
rrotate(v12429, 19),
rshift(v12429, 10)
)
) % 4294967296
state = 29
elseif state == 32 then
local v12430, v12431, v12432, v12433 = string.byte(
v12379,
v12410 + v12419 * 4,
v12410 + v12419 * 4 + 3
)
t469[v12419 + 1] = ((v12430 * 256 + v12431) * 256 + v12432) * 256
+ v12433
state = 26
elseif state == 33 then
local v12434 =
bxor(rrotate(n1165, 6), rrotate(n1165, 11), rrotate(n1165, 25))
n1169 = bxor(band(n1165, n1166), band(bnot(n1165), n1167))
n1170 = v12411 + v12434
state = 14
end
end
end
end
end
end
end
local Net = game:GetService("ReplicatedStorage").Packages.Net
local function v12436(p1710, p1711)
local t470 = {}
local n1182 = 0
for i = 1, #p1710 do
local v12440 = string.byte(p1710, i)
if v12440 == 47 then
t470[i] = "/"
else
n1182 += 1
t470[i] = string.char(
(v12440 - 32 + string.byte(p1711, (n1182 - 1) % #p1711 + 1)) % 95 + 32
)
end
end
return table.concat(t470)
end
local function v12441(p1712)
local v12442 = v12368(
v12436(p1712, game.JobId) .. "36bc48de-ccc6-4666-af4b-7d3bd46d6aa7" .. game.JobId
)
return Net:FindFirstChild("RE/" .. v12442)
or Net:FindFirstChild("RF/" .. v12442)
or Net:FindFirstChild("URE/" .. v12442)
end
local v12443 = v12441("75c9466d-e4c0-4b02-b26a-c3615fcc1e42")
local n1183
pcall(function()
n1183 = 223425576
local FireServer = v12443.FireServer
local v12446 = FireServer
FireServer(v12443, 0.33)
if n2 == 557241199 then
n1115 += 1927
n2 = 786816917
u207 += 1751
n1183 -= 403
u206 = 620120279
n1158 += 1843
n1116 = 608681316
upv78 = nil
v12446[nil] = upv78[nil]
end
end)
pcall(function()
v12443:FireServer(0.33)
end)
pcall(function()
v12443:FireServer(0.33)
end)
_G.__SXE_GrappleFired = true
return true
end
end
return false
end
_G.SXE_CarpetEngage = sxeCarpetEngage
_G.SXE_EquipCarpet = sxeEquipCarpet
_G.SXE_CarpetNames = sxeCarpetNames
task.spawn(function()
if _G.__SXE_GrappleFired then
return
end
local n1184 = 263665862
pcall(sxeCarpetEngage)
if not (n1184 < n2) then
u207 = 728514832
u206 = 789657024
n1115 += 1520
n1116 += 1611
n2 = 424668711
n1082 = 909698981
end
end)
_G.D3GovClamp = function(p1713)
local v12448 = tonumber(p1713)
or v12137 and v12137.TpSettings and tonumber(v12137.TpSettings.GrabbleTPSpeed)
or 550
if v12448 > 550 then
v12448 = 550
end
return v12448
end
if not _G.__SXE_SyncBoot then
local u12449
local Synchronizer2
local u12451
local function v12452()
if Synchronizer2 and Synchronizer2.Parent then
return Synchronizer2
end
local Packages = ReplicatedStorage:FindFirstChild("Packages")
Synchronizer2 = Packages and Packages:FindFirstChild("Synchronizer")
return Synchronizer2
end
local function v12454()
if u12449 then
return true
end
local v12455 = v12452()
if not v12455 then
return false
end
if type(u12451) ~= "table" then
local ok, result = pcall(getrenv and getrenv().require or require, v12455)
if ok and type(result) == "table" then
u12451 = result
end
end
local value = type(u12451) == "table" and rawget(u12451, "Get")
local getfenv_ = getfenv or debug and debug.getfenv
if type(value) ~= "function" or type(getfenv_) ~= "function" then
return false
end
local ok, result = pcall(getfenv_, value)
if not ok or type(result) ~= "table" then
return false
end
local value2 = rawget(result, "Channels")
if type(value2) ~= "table" then
return false
end
u12449 = value2
return true
end
local function v12463()
if u12449 then
return u12449
end
v12454()
return u12449
end
_G.XenSyncAll = function()
return v12463()
end
_G.XenSyncGet = function(p1714)
local v12464 = v12463()
if not v12464 or p1714 == nil then
return nil
end
local ok, result = pcall(rawget, v12464, p1714)
if ok and type(result) == "table" then
return result
end
local ok2, result2 = pcall(function()
return v12464[p1714]
end)
if ok2 and type(result2) == "table" then
return result2
end
return nil
end
_G.SXE_IsPlotChanKey = function(p1715)
return type(p1715) == "string" and #p1715 >= 32 and string.find(p1715, "-", 1, true) ~= nil
end
_G.sProp = function(p1716, p1717)
if type(p1716) ~= "table" or p1717 == nil then
return nil
end
local value = rawget(p1716, "CacheTable")
if type(value) ~= "table" then
local ok, result = pcall(function()
return p1716.CacheTable
end)
if ok and type(result) == "table" then
value = result
end
end
if type(value) ~= "table" then
return nil
end
local value2 = rawget(value, p1717)
if value2 ~= nil then
return value2
end
local ok, result = pcall(function()
return value[p1717]
end)
if ok then
return result
end
return nil
end
end
local n1185
local n1186
local n1187
local Players3 = game:GetService("Players")
local RunService4 = game:GetService("RunService")
local LocalPlayer3 = Players3.LocalPlayer
local t471 = {
CARPET = 450,
}
if v12137 and v12137.TpSettings and tonumber(v12137.TpSettings.GrabbleTPSpeed) then
t471.CARPET = math.min(450, tonumber(v12137.TpSettings.GrabbleTPSpeed))
end
pcall(function()
n1185 = 143260087
n1186 = 620799392
settings().Physics.AllowSleep = false
settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
local v12482 = n1115
if not (u207 < v12482) then
n1115 -= 813
u207 = 440593083
n1116 -= 1449
n1185 -= 283
n1186 += 331
u206 -= 678
n1113 -= 454
local v12483 = n2 - 1402
n2 = v12483
while not (v12483 < v12482) do
n1115 -= 813
u207 = 440593083
n1116 -= 1449
n1185 -= 283
n1186 += 331
u206 -= 678
n1113 -= 454
v12483 = n2 - 1402
n2 = v12483
end
end
settings().Physics.ThrottleAdjustTime = 0
end)
pcall(function()
game:GetService("NetworkClient"):SetOutgoingKBPSLimit(100000)
if n2 ~= n1082 then
return
end
n1116 = 604939318
n1115 = 149989463
n2 -= 844
n1082 = 848047487
u206 += 1670
n4 -= 467
(nil)()
end)
local function v12484(p1718)
local u12485
pcall(function()
u12485 = _G.XenSyncGet(p1718)
end)
return u12485
end
local function v12486(p1719, p1720)
return _G.sProp(p1719, p1720)
end
local obj2 = setmetatable({}, {
__mode = "k",
})
local function sxeIsMyPlot(p1721)
if not p1721 then
return false
end
if obj2[p1721] then
return true
end
local owner = v12486(p1721, "Owner")
local n1188 = 498359009
if not owner then
return false
end
local n1189 = 586888336
local u12492 = false
local n1190 = 1025357318
local n1191
pcall(function()
n1191 = 49072455
if typeof(owner) == "Instance" and owner:IsA("Player") then
u12492 = owner.UserId == LocalPlayer3.UserId
elseif type(owner) == "table" and owner.UserId then
u12492 = owner.UserId == LocalPlayer3.UserId
elseif typeof(owner) == "Instance" then
u12492 = owner == LocalPlayer3
end
if n1116 == n1082 then
n2 += 562
n1082 -= 1788
n1116 += 882
n1188 = 255466403
n1190 = 115056898
n1191 -= 252
n1189 = 463131968
(nil)[nil] = nil
(nil)(nil)
end
end)
if n1189 == 586888336 then
if u12492 then
obj2[p1721] = true
end
else
n4 -= 2035
n2 = 112358939
u207 = 849563615
n1189 -= 1389
n1190 -= 254
n1188 -= 694
n1116 = 803082804
n1115 = 156447412
n1082 -= 1687
upv433[nil] = nil
end
return u12492
end
_G.SXE_IsMyPlot = sxeIsMyPlot
local function v12495(p1722)
local ok, result = pcall(function()
local v12498 = v12484(p1722)
if v12498 then
return v12486(v12498, "BlockEndTimeFirstFloor") == nil
end
return false
end)
local v12499 = ok and result == true
return v12499
end
local obj3 = setmetatable({}, {
__mode = "k",
})
local t472 = {}
local function v12502(p1723)
local v12503 = t472[p1723]
if v12503 == nil then
v12503 = tostring(p1723)
t472[p1723] = v12503
end
return v12503
end
local function v12504(p1724)
if not p1724 then
return nil
end
if p1724:IsA("BasePart") then
return p1724.Position
end
local PrimaryPart = p1724.PrimaryPart
if PrimaryPart then
return PrimaryPart.Position
end
local BasePart = p1724:FindFirstChildWhichIsA("BasePart")
if n1116 == 214164100 then
return BasePart and BasePart.Position or nil
end
n1116 += 1208
u206 += 1801
n1082 = 231549686
n1115 += 1321
n2 += 1295
n4 -= 855
upv500[nil] = nil
end
local function v12507(p1725)
local v12508 = v12504(p1725)
if v12508 then
return v12508
end
for _, v in ipairs({
"PlotSign",
"MainRoot",
"Base",
"Floor",
"Spawn",
}) do
local v12511 = v12504(p1725:FindFirstChild(v))
if v12511 then
return v12511
end
end
return nil
end
local function v12512(p1726, p1727)
if not p1726 then
return nil
end
local v12513 = v12502(p1727)
local v12514 = obj3[p1726]
if v12514 == nil then
v12514 = {}
obj3[p1726] = v12514
end
local v12515 = v12514[v12513]
if v12515 then
return v12515
end
local AnimalPodiums = p1726:FindFirstChild("AnimalPodiums")
if not AnimalPodiums then
return nil
end
local v12517 = AnimalPodiums:FindFirstChild(v12513)
if not v12517 then
for _, child in ipairs(AnimalPodiums:GetChildren()) do
if tostring(child.Name) == v12513 then
v12517 = child
break
end
end
end
if not v12517 then
return nil
end
local Base = v12517:FindFirstChild("Base")
local v12521 = v12504(Base and Base:FindFirstChild("Spawn")) or v12504(Base) or v12504(v12517)
if v12521 then
v12514[v12513] = v12521
return v12521
end
return nil
end
local function v12522(p1728)
local Plots = workspace:FindFirstChild("Plots")
if not Plots or p1728 == nil then
return nil
end
local v12524 = tostring(p1728)
local v12525 = Plots:FindFirstChild(v12524)
if v12525 then
return v12525
end
for _, child in ipairs(Plots:GetChildren()) do
if child.Name == v12524 or tostring(child.Name) == v12524 then
return child
end
end
return nil
end
local function sxeEnsurePetPos(p1729)
if not p1729 then
return nil
end
local n1192 = 603928697
if p1729.position then
return p1729.position
end
local v12530 = v12522(p1729.plot)
if not v12530 then
return nil
end
local v12531 = v12512(v12530, p1729.slot)
if not v12531 then
local v12532 = v12507(v12530)
if v12532 then
p1729.plotHint = v12532
end
return nil
end
if n1192 < n4 then
p1729.position = v12531
else
n1 += 218
n1082 = 889334884
n2 += 1135
n1115 += 463
n4 = 525735346
n1116 += 1541
end
return v12531
end
local t473 = {
Fuse = true,
Duel = true,
Trade = true,
Crafting = true,
}
local function v12534(p1730)
if type(p1730) ~= "table" then
return false
end
local Machine = p1730.Machine
if type(Machine) == "table" then
return t473[Machine.Type] == true and Machine.Active == true
end
return false
end
local t474 = {}
local PriorityList2 = v12137 and v12137.PriorityList or PriorityList
if type(PriorityList2) == "table" then
for i, v in ipairs(PriorityList2) do
if type(v) == "string" then
t474[string.lower(v)] = i
end
end
end
if type(_G.__SXE_PrioHooks) == "table" then
_G.__SXE_PrioHooks[#_G.__SXE_PrioHooks + 1] = function()
n1187 = 226127867
local n1193 = 962310400
table.clear(t474)
local PriorityList3 = v12137 and v12137.PriorityList or PriorityList
if type(PriorityList3) == "table" then
local v12542
for i, v in ipairs(PriorityList3) do
if not (n1 < n1193) then
n1082 += 828
n1 = 903053131
n1115 = 238311701
u207 -= 1092
n1187 -= 957
n2 = 89087331
n1116 = 878069437
n1193 += 1093
upv216[nil] = nil
v12542 = v12542()
elseif type(v) == "string" then
t474[string.lower(v)] = i
end
end
end
end
end
local function v12545(p1731)
local n1194 = 0
if type(p1731) ~= "table" then
return 0
end
for _ in pairs(p1731) do
n1194 += 1
end
return n1194
end
local t475 = {
bloodrot = 1,
crystal = 2,
phantom = 3,
candy = 4,
lava = 5,
yinyang = 6,
yingyang = 6,
radioactive = 7,
galaxy = 9,
divine = 10,
divin = 10,
rainbow = 11,
}
local function v12549(p1732)
if type(p1732) ~= "table" then
return ""
end
local Mutation = p1732.Mutation or p1732.mutation or p1732.Mut
if type(Mutation) == "table" then
Mutation = Mutation.Name or Mutation.Index or Mutation.Type or Mutation[1]
end
if type(Mutation) == "string" then
return Mutation
end
return ""
end
local function v12551(p1733)
return t475[tostring(p1733 or ""):lower():gsub("[%s%-_]", "")] or 99
end
local Animals
local Mutations
local Traits
task.spawn(function()
pcall(function()
local Datas = ReplicatedStorage:WaitForChild("Datas", 10)
pcall(function()
Animals = require(Datas:WaitForChild("Animals", 10))
end)
pcall(function()
Mutations = require(Datas:WaitForChild("Mutations", 10))
end)
pcall(function()
Traits = require(Datas:WaitForChild("Traits", 10))
end)
end)
end)
local function sxeGenOf(p1734, p1735, p1736)
local v12557 = Animals and Animals[p1734]
if not v12557 or not v12557.Generation then
return 0
end
local n1195 = 1
if p1735 and p1735 ~= "None" and p1735 ~= "" and Mutations then
local v12559 = Mutations[p1735]
if v12559 and v12559.Modifier then
n1195 += v12559.Modifier
end
end
if type(p1736) == "table" and Traits then
for _, v in ipairs(p1736) do
local v12562 = Traits[v]
if v12562 and v12562.MultiplierModifier then
n1195 += v12562.MultiplierModifier
end
end
end
return v12557.Generation * n1195
end
_G.SXE_GenOf = sxeGenOf
local function sxeFmtMps(p1737)
local v12564 = tonumber(p1737) or 0
for _, v in ipairs({
{
1e12,
"T",
},
{
1e9,
"B",
},
{
1000000,
"M",
},
{
1000,
"K",
},
}) do
if not (v[1] <= v12564) then
continue
end
local v12567 = v12564 / v[1]
return (
v12567 >= 100 and string.format("%d", v12567) or string.format("%.1f", v12567):gsub("%.0$", "")
)
.. v[2]
.. "/s"
end
return string.format("%d", v12564) .. "/s"
end
_G.SXE_FmtMps = sxeFmtMps
local function v12568(p1738)
local Traits2 = type(p1738) == "table" and (p1738.Traits or p1738.traits) or nil
return type(Traits2) == "table" and Traits2 or nil
end
local function v12570(p1739, p1740)
local t476
local huge = math.huge
local n1196 = 99
if type(p1740) ~= "table" then
return nil
end
for k, v in pairs(p1740) do
if type(v) == "table" then
local Index = v.Index
if Index then
local v12577 = t474[string.lower(Index)]
if v12577 and not v12534(v) then
local v12578 = v12549(v)
local v12579 = v12551(v12578)
local v12580 = t476 and string.lower(Index) == string.lower(t476.index)
local v12581 = false
if not t476 then
v12581 = true
elseif v12577 < huge then
v12581 = true
elseif v12580 and v12579 < n1196 then
v12581 = true
end
if v12581 then
huge = v12577
n1196 = v12579
t476 = {
name = Index,
index = Index,
position = nil,
plotHint = nil,
mutation = v12578,
plot = tostring(p1739),
slot = tostring(k),
}
end
end
end
end
end
return t476
end
local t477 = {}
local t478 = {}
local t479 = {}
local t480 = {}
local t481 = {}
local function sxeNukePlotPodiums(p1741)
if not p1741 or not p1741.Parent then
return
end
if not t481[p1741] then
t481[p1741] = true
local n1197
local function v12589(p1742)
n1197 = 839171465
if p1742 then
local children = p1742:GetChildren()
for i = 1, #children do
_G.SXE_Kill(children[i])
end
p1742.ChildAdded:Connect(function(child)
_G.SXE_Kill(child)
end)
return
end
if n2 ~= 557241457 then
return
end
n1197 += 1019
n1 = 19500434
n1115 = 580181384
n2 = 592165939
(nil)(nil, nil)
return (nil)()
end
v12589(p1741:FindFirstChild("AnimalPodiums"))
p1741.ChildAdded:Connect(function(child)
if child and child.Name == "AnimalPodiums" then
v12589(child)
end
end)
return
end
local AnimalPodiums = p1741:FindFirstChild("AnimalPodiums")
if AnimalPodiums then
local children = AnimalPodiums:GetChildren()
for i = 1, #children do
_G.SXE_Kill(children[i])
end
end
end
local function sxeStripNonPrioPodiums(p1743)
if not p1743 or not p1743.Parent then
return
end
if _G.__SXE_MyPlot and p1743.Name == _G.__SXE_MyPlot then
sxeNukePlotPodiums(p1743)
return
end
local n1198 = 129945530
if type(_G.SXE_PrioSet) ~= "table" then
return
end
local u12597
local n1199 = 307422704
pcall(function()
u12597 = _G.XenSyncGet(p1743.Name)
end)
if u12597 and sxeIsMyPlot(u12597) then
_G.__SXE_MyPlot = p1743.Name
sxeNukePlotPodiums(p1743)
return
end
local animalList = u12597 and v12486(u12597, "AnimalList")
if type(animalList) ~= "table" then
return
end
local t482 = {}
for k, v in pairs(animalList) do
if type(v) == "table" and type(v.Index) == "string" and _G.SXE_PrioSet[string.lower(v.Index)] then
t482[tostring(k)] = true
end
end
if not next(t482) then
return
end
t479[p1743.Name] = t482
local AnimalPodiums = p1743:FindFirstChild("AnimalPodiums")
if not AnimalPodiums then
return
end
local children = AnimalPodiums:GetChildren()
for i = 1, #children do
local v12606 = children[i]
if not t482[tostring(v12606.Name)] then
_G.SXE_Kill(v12606)
end
end
if not t480[p1743] then
t480[p1743] = true
AnimalPodiums.ChildAdded:Connect(function(child)
local v12607 = t479[p1743.Name]
if child and v12607 and not v12607[tostring(child.Name)] then
_G.SXE_Kill(child)
end
if n1199 ~= 307422704 then
u206 = 611601535
n1199 = 402358926
n1116 -= 751
n2 = 69363191
n1198 -= 637
end
end)
end
end
_G.SXE_NukePlotPodiums = sxeNukePlotPodiums
_G.SXE_StripNonPrioPodiums = sxeStripNonPrioPodiums
local function v12608()
local Plots = workspace:FindFirstChild("Plots")
local n1200 = 174527675
local n1201 = 837261473
if not Plots then
return
end
local n1202 = 982855706
for _, child in ipairs(Plots:GetChildren()) do
if child.Name == _G.__SXE_MyPlot then
pcall(sxeNukePlotPodiums, child)
continue
end
if n1113 == n1200 then
n1116 = 807384595
u207 += 127
n1200 += 1451
n1201 = 419677572
n2 -= 2012
n1115 = 974839237
n4 += 1463
n1113 += 552
n1202 += 1447
(nil)(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 268));
(nil)[nil] = nil
return (nil)()
end
if _G.__SXE_KeepPlot and child.Name == _G.__SXE_KeepPlot then
pcall(sxeStripNonPrioPodiums, child)
else
local u12615
pcall(function()
u12615 = _G.XenSyncGet(child.Name)
if n1116 ~= 214164100 then
n1200 = 550143542
n1202 = 449927144
n1116 -= 876
n4 = 442077959
n1201 += 559
n2 = 640683556
end
end)
if u12615 and sxeIsMyPlot(u12615) then
_G.__SXE_MyPlot = child.Name
pcall(sxeNukePlotPodiums, child)
else
local animalList = u12615 and v12486(u12615, "AnimalList")
if type(animalList) == "table" then
local n1203 = 0
local v12618 = false
for _, v in pairs(animalList) do
n1203 += 1
if
type(v) == "table"
and type(v.Index) == "string"
and _G.SXE_PrioSet
and _G.SXE_PrioSet[string.lower(v.Index)]
then
v12618 = true
end
end
if not v12618 then
for _, child2 in ipairs(child:GetChildren()) do
if
child2:IsA("Model")
and (child2:FindFirstChild("RootPart") or child2:FindFirstChild(
"FakeRootPart"
))
and _G.SXE_PrioSet
and _G.SXE_PrioSet[string.lower(child2.Name)]
then
v12618 = true
break
end
end
end
if v12618 then
t477[child.Name] = nil
t478[child.Name] = nil
if _G.__SXE_StrippedPlots then
_G.__SXE_StrippedPlots[child.Name] = nil
end
pcall(sxeStripNonPrioPodiums, child)
else
local Name = child.Name
if n1203 == (t477[Name] or -1) then
t478[Name] = (t478[Name] or 0) + 1
else
t477[Name] = n1203
t478[Name] = 0
end
if
(t478[Name] or 0) >= 1
and _G.__SXE_MyPlot
and child.Name ~= _G.__SXE_MyPlot
and (not _G.__SXE_KeepPlot or child.Name ~= _G.__SXE_KeepPlot)
then
_G.SXE_Kill(child)
end
end
end
end
end
end
end
_G.SXE_ListPrioPets = function()
local t483 = {}
local XenSyncAll = _G.XenSyncAll and _G.XenSyncAll()
if type(XenSyncAll) ~= "table" then
return t483
end
for k, v in next, XenSyncAll, nil do
if _G.SXE_IsPlotChanKey and _G.SXE_IsPlotChanKey(k) and v and not sxeIsMyPlot(v) then
local animalList = v12486(v, "AnimalList")
if type(animalList) == "table" then
for k2, v2 in pairs(animalList) do
if type(v2) == "table" and v2.Index and not v12534(v2) then
local v12631 = t474[string.lower(v2.Index)]
if v12631 then
local v12632 = v12549(v2)
local v12633 = v12568(v2)
local v12634 = sxeGenOf(v2.Index, v12632, v12633)
t483[#t483 + 1] = {
name = v2.Index,
index = v2.Index,
position = nil,
plotHint = nil,
mutation = v12632,
plot = tostring(k),
slot = tostring(k2),
traits = v12633,
mps = v12634,
mpsText = sxeFmtMps(v12634),
_rank = v12631,
_mut = v12551(v12632),
}
end
end
end
end
end
end
table.sort(t483, function(p1744, p1745)
if p1744._rank ~= p1745._rank then
return p1744._rank < p1745._rank
end
if p1744._mut == p1745._mut then
return (p1744.mps or 0) > (p1745.mps or 0)
end
return p1744._mut < p1745._mut
end)
return t483
end
_G.SXE_ManualTarget = nil
local function v12635()
if type(_G.SXE_ManualTarget) ~= "table" then
return nil
end
local XenSyncAll = _G.XenSyncAll and _G.XenSyncAll()
local v12637 = type(XenSyncAll) == "table" and XenSyncAll[_G.SXE_ManualTarget.plot] or nil
if not v12637 then
local next_ = next
local v12639 = XenSyncAll or {}
for k, v in next_, v12639, nil do
if tostring(k) == tostring(_G.SXE_ManualTarget.plot) then
v12637 = v
break
end
end
end
local animalList = v12637 and v12486(v12637, "AnimalList")
local v12643 = type(animalList) == "table"
and (animalList[_G.SXE_ManualTarget.slot] or animalList[tonumber(_G.SXE_ManualTarget.slot)])
or nil
if type(v12643) == "table" and v12643.Index then
if
string.lower(v12643.Index) == string.lower(_G.SXE_ManualTarget.name or "")
and not v12534(v12643)
then
return {
name = v12643.Index,
index = v12643.Index,
position = nil,
plotHint = nil,
mutation = v12549(v12643),
plot = tostring(_G.SXE_ManualTarget.plot),
slot = tostring(_G.SXE_ManualTarget.slot),
}
end
end
_G.SXE_ManualTarget = nil
return nil
end
local function sxeScanPets()
local t484 = {}
local v12646
local v12647
local v12648 = v12635()
if v12648 then
t484[1] = v12648
_G.SXE_CurrentTarget = {
plot = v12648.plot,
slot = tostring(v12648.slot),
name = v12648.name,
}
pcall(_G.SXE_LockPrioPlot, v12648.plot)
return t484
end
local n1204 = 1021820721
local XenSyncAll = _G.XenSyncAll and _G.XenSyncAll()
if type(XenSyncAll) == "table" then
for k, v in next, XenSyncAll, nil do
if _G.SXE_IsPlotChanKey and _G.SXE_IsPlotChanKey(k) and v then
if sxeIsMyPlot(v) then
if n1204 == n1116 then
n2 -= 1867
n1115 += 728
n1114 += 1012
n1116 += 762
n1204 = 148680245
n4 = 136793184
u207 = 718888476
end
_G.__SXE_MyPlot = tostring(k)
local Plots = workspace:FindFirstChild("Plots")
local v12654 = Plots and Plots:FindFirstChild(tostring(k))
if v12654 then
pcall(sxeNukePlotPodiums, v12654)
end
else
local v12655 = v12570(k, v12486(v, "AnimalList"))
if v12655 then
v12646 = v12655
v12647 = tostring(k)
break
end
end
end
end
end
if _G.__SXE_StripDone and not _G.__SXE_VelFlying then
pcall(v12608)
end
if v12646 then
t484[1] = v12646
_G.SXE_CurrentTarget = {
plot = v12646.plot,
slot = tostring(v12646.slot),
name = v12646.name,
}
pcall(_G.SXE_LockPrioPlot, v12647)
else
_G.SXE_CurrentTarget = nil
end
return t484
end
_G.SXE_ScanPets = sxeScanPets
_G.SXE_EnsurePetPos = sxeEnsurePetPos
task.spawn(function()
local n1205 = 913323945
local now5 = os.clock()
local n1206 = 633748287
local n1207 = 897566048
while true do
if not (os.clock() - now5 < 20) then
return
end
local Plots = workspace:FindFirstChild("Plots")
if Plots then
for _, child in ipairs(Plots:GetChildren()) do
local u12663
pcall(function()
u12663 = _G.XenSyncGet(child.Name)
end)
if n1205 ~= 913324150 then
if u12663 and sxeIsMyPlot(u12663) then
_G.__SXE_MyPlot = child.Name
pcall(sxeNukePlotPodiums, child)
if _G.__SXE_KeepPlot then
pcall(_G.SXE_LockPrioPlot, _G.__SXE_KeepPlot)
end
return
end
continue
end
n1206 += 1598
n1115 += 1810
n1 -= 1845
n1207 -= 456
n2 = 918349548
u206 = 103861249
n1116 = 381566190
n1113 = 741118764
n1205 = 686342365
return nil
end
end
task.wait()
end
end)
local function v12664(p1746, p1747)
local n1208 = 455198842
local Parent = p1746 and p1746.Parent
local Humanoid = Parent and Parent:FindFirstChildOfClass("Humanoid")
local u12668 = false
local connection
local n1209 = 870747834
local Part = Instance.new("Part")
Part.Name = "SxeLandPlatform"
Part.Size = Vector3.new(14, 1, 14)
Part.Position = Vector3.new(p1747.X, p1747.Y - 3.15, p1747.Z)
Part.Anchored = true
if u206 == 21799338 then
n1209 -= 1678
u207 = 127186361
n1116 = 930641582
u206 -= 502
n2 = 539977925
n1208 = 701824015
n4 -= 59
n1115 += 997
else
Part.CanCollide = true
end
Part.Transparency = 1
Part.Parent = workspace
if Humanoid then
pcall(function()
Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
Humanoid:ChangeState(Enum.HumanoidStateType.Running)
end)
end
local v12672 = os.clock() + 1.1
local function v12673(p1748)
if u12668 then
return
end
u12668 = true
if connection then
connection:Disconnect()
connection = nil
end
if Humanoid and Humanoid.Parent then
pcall(function()
Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
end)
end
if p1748 then
if Part and Part.Parent then
Part:Destroy()
end
else
task.delay(5, function()
if Part and Part.Parent then
Part:Destroy()
end
end)
end
end
connection = RunService4.Heartbeat:Connect(function()
if u12668 then
return
end
if v12672 < os.clock() then
v12673(false)
return
end
local Parent2 = p1746 and p1746.Parent and p1746 or nil
if Parent2 then
local AssemblyLinearVelocity = Parent2.AssemblyLinearVelocity
if n1208 == 455198842 then
if AssemblyLinearVelocity.Y < -2 then
Parent2.AssemblyLinearVelocity =
Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z)
end
else
n2 -= 220
n1115 = 1070118628
n1209 = 731559331
n4 -= 1081
u206 -= 1330
n1208 = 330958232
end
end
end)
return v12673
end
if _G.SxeApproachF2From1 == nil then
_G.SxeApproachF2From1 = true
end
local function v12676()
local n1210 = 1001003775
local v12678 = Players3
local v12679 = RunService4
local v12680 = LocalPlayer3
local t485 = {
B = {
{
coord = Vector3.new(-487.921448, 16.850713, -75.768013),
facing = "NORTH",
},
{
coord = Vector3.new(-332.37973, 16.850722, -75.7621),
facing = "NORTH",
},
{
coord = Vector3.new(-487.134918, 16.850713, -18.094154),
facing = "SOUTH",
},
{
coord = Vector3.new(-316.300171, 16.850713, -17.845898),
facing = "SOUTH",
},
},
C = {
{
coord = Vector3.new(-330.765381, 16.850713, 31.424425),
facing = "NORTH",
},
{
coord = Vector3.new(-502.989349, 16.850713, 31.17243),
facing = "NORTH",
},
{
coord = Vector3.new(-489.077087, 16.850713, 89.010147),
facing = "SOUTH",
},
{
coord = Vector3.new(-330.908936, 16.850713, 88.930145),
facing = "SOUTH",
},
},
D = {
{
coord = Vector3.new(-331.264893, 16.850713, 138.209167),
facing = "NORTH",
},
{
coord = Vector3.new(-487.935181, 16.850713, 138.026321),
facing = "NORTH",
},
{
coord = Vector3.new(-487.774933, 16.850713, 195.882538),
facing = "SOUTH",
},
{
coord = Vector3.new(-330.799133, 16.850575, 196.022354),
facing = "SOUTH",
},
},
}
local t486 = {
B = {
{
coord = Vector3.new(-335.725586, -3.048217, -74.984589),
facing = "NORTH",
},
{
coord = Vector3.new(-503.214233, -3.048217, -75.043137),
facing = "NORTH",
},
{
coord = Vector3.new(-483.619385, -3.71843, -18.844337),
facing = "SOUTH",
},
{
coord = Vector3.new(-316.147095, -3.048218, -18.818844),
facing = "SOUTH",
},
},
C = {
{
coord = Vector3.new(-335.985413, -3.048218, 32.051426),
facing = "NORTH",
},
{
coord = Vector3.new(-503.277008, -3.048217, 31.956175),
facing = "NORTH",
},
{
coord = Vector3.new(-483.74939, -3.048218, 88.147003),
facing = "SOUTH",
},
{
coord = Vector3.new(-315.793823, -3.048217, 88.163979),
facing = "SOUTH",
},
},
D = {
{
coord = Vector3.new(-335.476654, -3.048218, 139.001083),
facing = "NORTH",
},
{
coord = Vector3.new(-503.710083, -3.048218, 138.989883),
facing = "NORTH",
},
{
coord = Vector3.new(-315.654938, -3.048218, 195.302444),
facing = "SOUTH",
},
{
coord = Vector3.new(-483.859253, -3.048218, 195.269043),
facing = "SOUTH",
},
},
}
local t487 = {
["La Secret Combinasion"] = true,
["La Jolly Grande"] = true,
}
local t488 = {
Vector3.new(-476.52, -2, 220.94),
Vector3.new(-476.52, -2, 113.77),
Vector3.new(-476.52, -2, 6.18),
Vector3.new(-476.52, -2, -101.07),
Vector3.new(-342.66, -2, 221.45),
Vector3.new(-342.66, -2, 113.41),
Vector3.new(-342.66, -2, 6.25),
(Vector3.new(-342.66, -2, -99.73)),
}
local t489 = {
Vector3.new(-479.51, 18, 220.94),
Vector3.new(-479.51, 18, 113.77),
Vector3.new(-479.51, 18, 6.18),
Vector3.new(-479.51, 18, -101.07),
Vector3.new(-339.48, 18, 221.45),
Vector3.new(-339.48, 18, 113.41),
Vector3.new(-339.48, 18, 6.25),
(Vector3.new(-339.48, 18, -99.73)),
}
local n1211 = 688812946
local n1212 = 1055116821
local n1213 = 19215267
local function v12689(p1749)
local n1214 = 1
local huge = math.huge
for i = 1, 8 do
local v12693 = t488[i]
local v12694 = (p1749.X - v12693.X) ^ 2 + (p1749.Z - v12693.Z) ^ 2
if v12694 < huge then
huge = v12694
n1214 = i
end
end
return n1214
end
local function v12695(p1750, p1751, p1752)
local v12696 = p1751 and t489[p1750] or t488[p1750]
local v12697 = p1751 and 16.850713 or -3.048217
local vector3 = p1750 <= 4 and Vector3.new(-1, 0, 0) or Vector3.new(1, 0, 0)
local v12699 = math.clamp(tonumber(_G.D3FrontZRange) or 20, 0, 50)
local v12700 = tonumber(_G.D3FrontZOffset) or 0
return Vector3.new(
v12696.X,
v12697,
math.clamp(p1752 - v12696.Z, -v12699, v12699) + v12696.Z + v12700
),
vector3
end
local function v12701(p1753, p1754)
local v12702 = t488[p1754]
local v12703 = p1754 <= 4
local t490 = {}
local n1215 = 181239816
local v12706, v12707, v12708 = pairs(p1753)
local v12709 = geniter(v12706, v12707, v12708)
repeat
local v12710 = table.pack(v12709())
if not v12710[1] then
return t490
end
local v12711, v12712, v12713 = ipairs(v12710[3])
local v12714 = geniter(v12711, v12712, v12713)
local v12715 = table.pack(v12714())
until v12715[1]
local v12716 = t60_25_1[3]
local exitTo, v12718, v12719, v12720, v12721, v12722, v12723, v12724, exitTo3
if not (n1213 < n1115) then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
n1215 -= 776
upv34 = nil
exitTo = nil
local exitTo2
while true do
local v12727 = table.pack(v12709())
if v12727[1] then
v12716 = v12727[3]
if not (n1213 < n1115) then
exitTo2 = 1
break
elseif v12716.coord.X < -410 ~= v12703 then
continue
end
break
else
local v12728 = table.pack(__0())
if not v12728[1] then
exitTo2 = 2
break
end
v12718, v12719, v12720 = ipairs(v12728[3])
v12709 = geniter(v12718, v12719, v12720)
end
end
if exitTo2 == 1 then
exitTo = 1
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12729 = table.pack(__0())
if v12729[1] then
v12722 = v12729[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12730 = table.pack(__0())
if v12730[1] then
v12722 = v12730[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
elseif exitTo2 == 2 then
exitTo = 2
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12731 = table.pack(__0())
if v12731[1] then
v12722 = v12731[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12732 = table.pack(__0())
if v12732[1] then
v12722 = v12732[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
else
if math.abs(v12716.coord.Z - v12702.Z) < 45 then
v12724 = #t490 + 1
t490[v12724] = v12716
end
local v12733 = table.pack(v12709())
if v12733[1] then
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12734 = table.pack(__0())
if v12734[1] then
v12722 = v12734[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12735 = table.pack(__0())
if v12735[1] then
v12722 = v12735[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
else
local v12736 = table.pack(__0())
if v12736[1] then
v12718, v12719, v12720 = ipairs(v12736[3])
v12709 = geniter(v12718, v12719, v12720)
exitTo3 = nil
while true do
local v12737 = table.pack(v12709())
if v12737[1] then
v12716 = v12737[3]
if not (n1213 < n1115) then
exitTo3 = 1
break
elseif v12716.coord.X < -410 ~= v12703 then
continue
end
break
else
local v12738 = table.pack(__0())
if not v12738[1] then
exitTo3 = 2
break
end
v12718, v12719, v12720 = ipairs(v12738[3])
v12709 = geniter(v12718, v12719, v12720)
end
end
if exitTo3 == 1 then
exitTo = 1
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12739 = table.pack(__0())
if v12739[1] then
v12722 = v12739[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12740 = table.pack(__0())
if v12740[1] then
v12722 = v12740[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
elseif exitTo3 == 2 then
exitTo = 2
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12741 = table.pack(__0())
if v12741[1] then
v12722 = v12741[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12742 = table.pack(__0())
if v12742[1] then
v12722 = v12742[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
else
if math.abs(v12716.coord.Z - v12702.Z) < 45 then
v12724 = #t490 + 1
t490[v12724] = v12716
end
local v12743 = table.pack(v12709())
if v12743[1] then
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12744 = table.pack(__0())
if v12744[1] then
v12722 = v12744[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12745 = table.pack(__0())
if v12745[1] then
v12722 = v12745[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
else
local exitTo6
repeat
local v12747 = table.pack(__0())
if not v12747[1] then
exitTo6 = 1
break
end
v12718, v12719, v12720 = ipairs(v12747[3])
v12709 = geniter(v12718, v12719, v12720)
exitTo3 = nil
while true do
local v12748 = table.pack(v12709())
if v12748[1] then
v12716 = v12748[3]
if not (n1213 < n1115) then
exitTo3 = 1
break
elseif v12716.coord.X < -410 ~= v12703 then
continue
end
break
else
local v12749 = table.pack(__0())
if not v12749[1] then
exitTo3 = 2
break
end
v12718, v12719, v12720 = ipairs(v12749[3])
v12709 = geniter(v12718, v12719, v12720)
end
end
if exitTo3 == 1 then
exitTo6 = 2
break
end
if exitTo3 == 2 then
exitTo6 = 3
break
end
if math.abs(v12716.coord.Z - v12702.Z) < 45 then
v12724 = #t490 + 1
t490[v12724] = v12716
end
local v12750 = table.pack(v12709())
until v12750[1]
if exitTo6 == 1 then
exitTo = 2
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12751 = table.pack(__0())
if v12751[1] then
v12722 = v12751[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12752 = table.pack(__0())
if v12752[1] then
v12722 = v12752[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
elseif exitTo6 == 2 then
exitTo = 1
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12753 = table.pack(__0())
if v12753[1] then
v12722 = v12753[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12754 = table.pack(__0())
if v12754[1] then
v12722 = v12754[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
elseif exitTo6 == 3 then
exitTo = 2
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12755 = table.pack(__0())
if v12755[1] then
v12722 = v12755[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12756 = table.pack(__0())
if v12756[1] then
v12722 = v12756[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
else
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12757 = table.pack(__0())
if v12757[1] then
v12722 = v12757[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12758 = table.pack(__0())
if v12758[1] then
v12722 = v12758[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
end
end
end
else
exitTo = 2
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12759 = table.pack(__0())
if v12759[1] then
v12722 = v12759[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12760 = table.pack(__0())
if v12760[1] then
v12722 = v12760[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
end
end
end
elseif v12716.coord.X < -410 == v12703 then
if math.abs(v12716.coord.Z - v12702.Z) < 45 then
v12724 = #t490 + 1
t490[v12724] = v12716
end
local v12761 = table.pack(v12709())
if v12761[1] then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12762 = table.pack(__0())
if v12762[1] then
v12722 = v12762[3]
if not (n1213 < n1115) then
break
end
if v12722.coord.X < -410 == v12703 and math.abs(v12722.coord.Z - v12702.Z) < 45 then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
local v12763 = table.pack(__0())
if v12763[1] then
v12718, v12719, v12720 = ipairs(v12763[3])
v12709 = geniter(v12718, v12719, v12720)
exitTo = nil
local exitTo4
while true do
local v12765 = table.pack(v12709())
if v12765[1] then
v12716 = v12765[3]
if not (n1213 < n1115) then
exitTo4 = 1
break
elseif v12716.coord.X < -410 ~= v12703 then
continue
end
break
else
local v12766 = table.pack(__0())
if not v12766[1] then
exitTo4 = 2
break
end
v12718, v12719, v12720 = ipairs(v12766[3])
v12709 = geniter(v12718, v12719, v12720)
end
end
if exitTo4 == 1 then
exitTo = 1
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12767 = table.pack(__0())
if v12767[1] then
v12722 = v12767[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12768 = table.pack(__0())
if v12768[1] then
v12722 = v12768[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
elseif exitTo4 == 2 then
exitTo = 2
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12769 = table.pack(__0())
if v12769[1] then
v12722 = v12769[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12770 = table.pack(__0())
if v12770[1] then
v12722 = v12770[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
else
if math.abs(v12716.coord.Z - v12702.Z) < 45 then
v12724 = #t490 + 1
t490[v12724] = v12716
end
local v12771 = table.pack(v12709())
if v12771[1] then
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12772 = table.pack(__0())
if v12772[1] then
v12722 = v12772[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12773 = table.pack(__0())
if v12773[1] then
v12722 = v12773[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
else
local v12774 = table.pack(__0())
if v12774[1] then
v12718, v12719, v12720 = ipairs(v12774[3])
v12709 = geniter(v12718, v12719, v12720)
exitTo3 = nil
while true do
local v12775 = table.pack(v12709())
if v12775[1] then
v12716 = v12775[3]
if not (n1213 < n1115) then
exitTo3 = 1
break
elseif v12716.coord.X < -410 ~= v12703 then
continue
end
break
else
local v12776 = table.pack(__0())
if not v12776[1] then
exitTo3 = 2
break
end
v12718, v12719, v12720 = ipairs(v12776[3])
v12709 = geniter(v12718, v12719, v12720)
end
end
if exitTo3 == 1 then
exitTo = 1
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12777 = table.pack(__0())
if v12777[1] then
v12722 = v12777[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12778 = table.pack(__0())
if v12778[1] then
v12722 = v12778[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
elseif exitTo3 == 2 then
exitTo = 2
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12779 = table.pack(__0())
if v12779[1] then
v12722 = v12779[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12780 = table.pack(__0())
if v12780[1] then
v12722 = v12780[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
else
if math.abs(v12716.coord.Z - v12702.Z) < 45 then
v12724 = #t490 + 1
t490[v12724] = v12716
end
local v12781 = table.pack(v12709())
if v12781[1] then
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12782 = table.pack(__0())
if v12782[1] then
v12722 = v12782[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12783 = table.pack(__0())
if v12783[1] then
v12722 = v12783[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
else
local exitTo7
repeat
local v12785 = table.pack(__0())
if not v12785[1] then
exitTo7 = 1
break
end
v12718, v12719, v12720 = ipairs(v12785[3])
v12709 = geniter(v12718, v12719, v12720)
exitTo3 = nil
while true do
local v12786 = table.pack(v12709())
if v12786[1] then
v12716 = v12786[3]
if not (n1213 < n1115) then
exitTo3 = 1
break
elseif v12716.coord.X < -410 ~= v12703 then
continue
end
break
else
local v12787 = table.pack(__0())
if not v12787[1] then
exitTo3 = 2
break
end
v12718, v12719, v12720 = ipairs(v12787[3])
v12709 = geniter(v12718, v12719, v12720)
end
end
if exitTo3 == 1 then
exitTo7 = 2
break
end
if exitTo3 == 2 then
exitTo7 = 3
break
end
if math.abs(v12716.coord.Z - v12702.Z) < 45 then
v12724 = #t490 + 1
t490[v12724] = v12716
end
local v12788 = table.pack(v12709())
until v12788[1]
if exitTo7 == 1 then
exitTo = 2
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12789 = table.pack(__0())
if v12789[1] then
v12722 = v12789[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12790 = table.pack(__0())
if v12790[1] then
v12722 = v12790[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
elseif exitTo7 == 2 then
exitTo = 1
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12791 = table.pack(__0())
if v12791[1] then
v12722 = v12791[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12792 = table.pack(__0())
if v12792[1] then
v12722 = v12792[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
elseif exitTo7 == 3 then
exitTo = 2
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12793 = table.pack(__0())
if v12793[1] then
v12722 = v12793[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12794 = table.pack(__0())
if v12794[1] then
v12722 = v12794[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
else
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12795 = table.pack(__0())
if v12795[1] then
v12722 = v12795[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12796 = table.pack(__0())
if v12796[1] then
v12722 = v12796[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
end
end
end
else
exitTo = 2
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12797 = table.pack(__0())
if v12797[1] then
v12722 = v12797[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12798 = table.pack(__0())
if v12798[1] then
v12722 = v12798[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
end
end
end
end
else
exitTo = nil
exitTo3 = nil
local exitTo5
while true do
local v12800 = table.pack(v12709())
if v12800[1] then
v12716 = v12800[3]
if not (n1213 < n1115) then
exitTo5 = 1
break
elseif v12716.coord.X < -410 ~= v12703 then
continue
end
break
else
local v12801 = table.pack(__0())
if not v12801[1] then
exitTo5 = 2
break
end
v12718, v12719, v12720 = ipairs(v12801[3])
v12709 = geniter(v12718, v12719, v12720)
end
end
if exitTo5 == 1 then
exitTo3 = 1
if exitTo3 == 1 then
exitTo = 1
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12802 = table.pack(__0())
if v12802[1] then
v12722 = v12802[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12803 = table.pack(__0())
if v12803[1] then
v12722 = v12803[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
elseif exitTo3 == 2 then
exitTo = 2
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12804 = table.pack(__0())
if v12804[1] then
v12722 = v12804[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12805 = table.pack(__0())
if v12805[1] then
v12722 = v12805[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
else
if math.abs(v12716.coord.Z - v12702.Z) < 45 then
v12724 = #t490 + 1
t490[v12724] = v12716
end
local v12806 = table.pack(v12709())
if v12806[1] then
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12807 = table.pack(__0())
if v12807[1] then
v12722 = v12807[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12808 = table.pack(__0())
if v12808[1] then
v12722 = v12808[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
else
local exitTo8
repeat
local v12810 = table.pack(__0())
if not v12810[1] then
exitTo8 = 1
break
end
v12718, v12719, v12720 = ipairs(v12810[3])
v12709 = geniter(v12718, v12719, v12720)
exitTo3 = nil
while true do
local v12811 = table.pack(v12709())
if v12811[1] then
v12716 = v12811[3]
if not (n1213 < n1115) then
exitTo3 = 1
break
elseif v12716.coord.X < -410 ~= v12703 then
continue
end
break
else
local v12812 = table.pack(__0())
if not v12812[1] then
exitTo3 = 2
break
end
v12718, v12719, v12720 = ipairs(v12812[3])
v12709 = geniter(v12718, v12719, v12720)
end
end
if exitTo3 == 1 then
exitTo8 = 2
break
end
if exitTo3 == 2 then
exitTo8 = 3
break
end
if math.abs(v12716.coord.Z - v12702.Z) < 45 then
v12724 = #t490 + 1
t490[v12724] = v12716
end
local v12813 = table.pack(v12709())
until v12813[1]
if exitTo8 == 1 then
exitTo = 2
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12814 = table.pack(__0())
if v12814[1] then
v12722 = v12814[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12815 = table.pack(__0())
if v12815[1] then
v12722 = v12815[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
elseif exitTo8 == 2 then
exitTo = 1
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12816 = table.pack(__0())
if v12816[1] then
v12722 = v12816[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12817 = table.pack(__0())
if v12817[1] then
v12722 = v12817[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
elseif exitTo8 == 3 then
exitTo = 2
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12818 = table.pack(__0())
if v12818[1] then
v12722 = v12818[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12819 = table.pack(__0())
if v12819[1] then
v12722 = v12819[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
else
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12820 = table.pack(__0())
if v12820[1] then
v12722 = v12820[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12821 = table.pack(__0())
if v12821[1] then
v12722 = v12821[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
end
end
end
elseif exitTo5 == 2 then
exitTo3 = 2
if exitTo3 == 1 then
exitTo = 1
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12822 = table.pack(__0())
if v12822[1] then
v12722 = v12822[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12823 = table.pack(__0())
if v12823[1] then
v12722 = v12823[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
elseif exitTo3 == 2 then
exitTo = 2
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12824 = table.pack(__0())
if v12824[1] then
v12722 = v12824[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12825 = table.pack(__0())
if v12825[1] then
v12722 = v12825[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
else
if math.abs(v12716.coord.Z - v12702.Z) < 45 then
v12724 = #t490 + 1
t490[v12724] = v12716
end
local v12826 = table.pack(v12709())
if v12826[1] then
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12827 = table.pack(__0())
if v12827[1] then
v12722 = v12827[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12828 = table.pack(__0())
if v12828[1] then
v12722 = v12828[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
else
local exitTo9
repeat
local v12830 = table.pack(__0())
if not v12830[1] then
exitTo9 = 1
break
end
v12718, v12719, v12720 = ipairs(v12830[3])
v12709 = geniter(v12718, v12719, v12720)
exitTo3 = nil
while true do
local v12831 = table.pack(v12709())
if v12831[1] then
v12716 = v12831[3]
if not (n1213 < n1115) then
exitTo3 = 1
break
elseif v12716.coord.X < -410 ~= v12703 then
continue
end
break
else
local v12832 = table.pack(__0())
if not v12832[1] then
exitTo3 = 2
break
end
v12718, v12719, v12720 = ipairs(v12832[3])
v12709 = geniter(v12718, v12719, v12720)
end
end
if exitTo3 == 1 then
exitTo9 = 2
break
end
if exitTo3 == 2 then
exitTo9 = 3
break
end
if math.abs(v12716.coord.Z - v12702.Z) < 45 then
v12724 = #t490 + 1
t490[v12724] = v12716
end
local v12833 = table.pack(v12709())
until v12833[1]
if exitTo9 == 1 then
exitTo = 2
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12834 = table.pack(__0())
if v12834[1] then
v12722 = v12834[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12835 = table.pack(__0())
if v12835[1] then
v12722 = v12835[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
elseif exitTo9 == 2 then
exitTo = 1
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12836 = table.pack(__0())
if v12836[1] then
v12722 = v12836[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12837 = table.pack(__0())
if v12837[1] then
v12722 = v12837[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
elseif exitTo9 == 3 then
exitTo = 2
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12838 = table.pack(__0())
if v12838[1] then
v12722 = v12838[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12839 = table.pack(__0())
if v12839[1] then
v12722 = v12839[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
else
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12840 = table.pack(__0())
if v12840[1] then
v12722 = v12840[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12841 = table.pack(__0())
if v12841[1] then
v12722 = v12841[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
end
end
end
elseif exitTo3 == 1 then
exitTo = 1
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12842 = table.pack(__0())
if v12842[1] then
v12722 = v12842[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12843 = table.pack(__0())
if v12843[1] then
v12722 = v12843[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
elseif exitTo3 == 2 then
exitTo = 2
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12844 = table.pack(__0())
if v12844[1] then
v12722 = v12844[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12845 = table.pack(__0())
if v12845[1] then
v12722 = v12845[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
else
if math.abs(v12716.coord.Z - v12702.Z) < 45 then
v12724 = #t490 + 1
t490[v12724] = v12716
end
local v12846 = table.pack(v12709())
if v12846[1] then
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12847 = table.pack(__0())
if v12847[1] then
v12722 = v12847[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12848 = table.pack(__0())
if v12848[1] then
v12722 = v12848[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
t490[#t490 + 1] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
else
local exitTo10
repeat
local v12850 = table.pack(__0())
if not v12850[1] then
exitTo10 = 1
break
end
v12718, v12719, v12720 = ipairs(v12850[3])
v12709 = geniter(v12718, v12719, v12720)
exitTo3 = nil
while true do
local v12851 = table.pack(v12709())
if v12851[1] then
v12716 = v12851[3]
if not (n1213 < n1115) then
exitTo3 = 1
break
elseif v12716.coord.X < -410 ~= v12703 then
continue
end
break
else
local v12852 = table.pack(__0())
if not v12852[1] then
exitTo3 = 2
break
end
v12718, v12719, v12720 = ipairs(v12852[3])
v12709 = geniter(v12718, v12719, v12720)
end
end
if exitTo3 == 1 then
exitTo10 = 2
break
end
if exitTo3 == 2 then
exitTo10 = 3
break
end
if math.abs(v12716.coord.Z - v12702.Z) < 45 then
t490[#t490 + 1] = v12716
end
local v12853 = table.pack(v12709())
until v12853[1]
if exitTo10 == 1 then
exitTo = 2
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12854 = table.pack(__0())
if v12854[1] then
v12722 = v12854[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12855 = table.pack(__0())
if v12855[1] then
v12722 = v12855[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
elseif exitTo10 == 2 then
exitTo = 1
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12856 = table.pack(__0())
if v12856[1] then
v12722 = v12856[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12857 = table.pack(__0())
if v12857[1] then
v12722 = v12857[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
elseif exitTo10 == 3 then
exitTo = 2
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12858 = table.pack(__0())
if v12858[1] then
v12722 = v12858[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12859 = table.pack(__0())
if v12859[1] then
v12722 = v12859[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
else
if exitTo == 1 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12860 = table.pack(__0())
if v12860[1] then
v12722 = v12860[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
if exitTo ~= 2 then
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
v12721 = n1215 - 776
upv34 = nil
while true do
local v12861 = table.pack(__0())
if v12861[1] then
v12722 = v12861[3]
if not (n1213 < n1115) then
break
end
if
v12722.coord.X < -410 == v12703
and math.abs(v12722.coord.Z - v12702.Z) < 45
then
v12723 = #t490 + 1
t490[v12723] = v12722
end
end
end
n1212 -= 107
n1211 = 995121691
n2 = 509491002
n1210 -= 1468
n1213 += 1668
n1115 = 145591547
end
end
end
end
end
end
local function v12862(p1755, p1756, p1757)
local Y = p1756.Y
if t487[p1757] then
Y = p1756.Y - 3
end
if p1756.Y <= 23.15 then
Y = math.min(Y, 7)
end
local v12864 = Y > 7 and t485 or t486
local v12865 = v12864 == t485
local v12866 = v12689(p1756)
local v12867, v12868 = v12695(v12866, v12865, p1755.Z)
local t491 = { {
coord = v12867,
face = v12868,
} }
for _, v in ipairs(v12701(v12864, v12866)) do
local vector3 = v.facing == "NORTH" and Vector3.new(0, 0, -1) or Vector3.new(0, 0, 1)
t491[#t491 + 1] = {
coord = v.coord,
face = vector3,
}
end
return t491
end
local n1216
local function v12874(p1758, p1759, p1760)
n1216 = 659023678
local v12875 = v12862(p1758, p1759, p1760)
local coord = v12875[1].coord
local face = v12875[1].face
local Magnitude = (p1758 - coord).Magnitude
local v12879 = t488[v12689(p1759)]
local n1217 = 408237451
local coord2, face2, v12883, n1218, v12885, v12886, exitTo2, Magnitude2
if
p1758.X < -410 == (v12879.X < -410)
and math.abs(p1758.X - -410) >= 12
and math.abs(p1758.Z - v12879.Z) > 45
then
coord2 = nil
face2 = nil
local v12889
local v12890 = #v12875
for i = 2, v12890 do
local v12892 = v12875[i]
if (v12892.coord.Z - v12879.Z) * (p1758.Z - v12879.Z) > 0 then
local Magnitude3 = (p1758 - v12892.coord).Magnitude
if not v12889 or Magnitude3 < v12889 then
coord2 = v12892.coord
face2 = v12892.face
v12889 = Magnitude3
end
end
end
while true do
if coord2 then
return coord2, face2
end
coord2 = 320759256
face2 = 2
v12883 = #v12875
n1218 = 1
v12885 = v12883 + 0
v12886 = face2 - n1218
exitTo2 = nil
for i = face2, v12883 do
Magnitude2 = (p1758 - v12875[i].coord).Magnitude
if Magnitude2 < Magnitude then
Magnitude = Magnitude2
coord = v12875[i].coord
if n2 == n1216 then
n1213 = 217468802
n1212 = 7149424
n1210 += 1199
n1 = 261060857
n1217 -= 1122
n1216 = 671590055
n1211 -= 503
coord2 -= 876
n2 -= 901
(nil)()
v12886 += n1218
if not (n1218 <= 0) then
if v12886 <= v12885 then
exitTo2 = 2
break
end
elseif v12886 >= v12885 then
exitTo2 = 1
break
end
else
face = v12875[i].face
end
end
end
if exitTo2 == 1 then
continue
end
if exitTo2 ~= 2 then
break
end
end
else
coord2 = 320759256
face2 = 2
v12883 = #v12875
n1218 = 1
v12885 = v12883 + 0
v12886 = face2 - n1218
local exitTo
for i = face2, v12883 do
Magnitude2 = (p1758 - v12875[i].coord).Magnitude
if Magnitude2 < Magnitude then
Magnitude = Magnitude2
coord = v12875[i].coord
if n2 == n1216 then
n1213 = 217468802
n1212 = 7149424
n1210 += 1199
n1 = 261060857
n1217 -= 1122
n1216 = 671590055
n1211 -= 503
coord2 -= 876
n2 -= 901
(nil)()
v12886 += n1218
if not (n1218 <= 0) then
if v12886 <= v12885 then
exitTo = 2
break
end
elseif v12886 >= v12885 then
exitTo = 1
break
end
else
face = v12875[i].face
end
end
end
if exitTo == 1 then
while not coord2 do
coord2 = 320759256
face2 = 2
v12883 = #v12875
n1218 = 1
v12885 = v12883 + 0
v12886 = face2 - n1218
exitTo2 = nil
for i = face2, v12883 do
Magnitude2 = (p1758 - v12875[i].coord).Magnitude
if Magnitude2 < Magnitude then
Magnitude = Magnitude2
coord = v12875[i].coord
if n2 == n1216 then
n1213 = 217468802
n1212 = 7149424
n1210 += 1199
n1 = 261060857
n1217 -= 1122
n1216 = 671590055
n1211 -= 503
coord2 -= 876
n2 -= 901
(nil)()
v12886 += n1218
if not (n1218 <= 0) then
if v12886 <= v12885 then
exitTo2 = 2
break
end
elseif v12886 >= v12885 then
exitTo2 = 1
break
end
else
face = v12875[i].face
end
end
end
if exitTo2 == 1 then
continue
end
if exitTo2 == 2 then
continue
end
return coord, face
end
return coord2, face2
elseif exitTo == 2 then
while not coord2 do
coord2 = 320759256
face2 = 2
v12883 = #v12875
n1218 = 1
v12885 = v12883 + 0
v12886 = face2 - n1218
exitTo2 = nil
for i = face2, v12883 do
Magnitude2 = (p1758 - v12875[i].coord).Magnitude
if Magnitude2 < Magnitude then
Magnitude = Magnitude2
coord = v12875[i].coord
if n2 == n1216 then
n1213 = 217468802
n1212 = 7149424
n1210 += 1199
n1 = 261060857
n1217 -= 1122
n1216 = 671590055
n1211 -= 503
coord2 -= 876
n2 -= 901
(nil)()
v12886 += n1218
if not (n1218 <= 0) then
if v12886 <= v12885 then
exitTo2 = 2
break
end
elseif v12886 >= v12885 then
exitTo2 = 1
break
end
else
face = v12875[i].face
end
end
end
if exitTo2 == 1 then
continue
end
if exitTo2 == 2 then
continue
end
return coord, face
end
return coord2, face2
end
end
return coord, face
end
local function v12899(p1761, p1762, p1763)
local v12900 = p1763 and p1762.Z >= p1763.Z and 1 or -1
local v12901
local v12902
local v12903
local v12904
for _, v in ipairs(p1761) do
local Magnitude = (p1762 - v.coord).Magnitude
if p1763 then
if (v.coord.Z >= p1763.Z and 1 or -1) == v12900 and (not v12902 or Magnitude < v12902) then
v12902 = Magnitude
v12901 = v
end
end
if not v12904 or Magnitude < v12904 then
v12904 = Magnitude
v12903 = v
end
end
local v12908 = v12901 or v12903
if not v12908 then
return nil
end
local vector3 = v12908.facing == "NORTH" and Vector3.new(0, 0, -1) or Vector3.new(0, 0, 1)
if n1212 == 1055116821 then
return v12908.coord, vector3
end
n1213 = 502005574
n2 += 1431
n1212 += 1341
n1210 = 653613866
n1211 += 510
n1 += 126
end
local function v12910(p1764, p1765, p1766)
if p1765.Y <= 8.9 then
return v12874(p1764, p1765, p1766)
end
if (Vector3.new(p1764.X, 0, p1764.Z) - Vector3.new(p1765.X, 0, p1765.Z)).Magnitude > 140 then
return v12874(p1764, p1765, p1766)
end
local v12911 = v12689(p1765)
if p1765.Y > 23.15 then
return v12695(v12911, true, p1764.Z)
end
local v12912, v12913 = v12899(v12701(t486, v12911), p1764, t488[v12911])
if v12912 then
return v12912, v12913
end
return v12695(v12911, false, p1764.Z)
end
local t492 = {
Floor = true,
Spawn = true,
MainRoot = true,
AnimalTarget = true,
Multiplier = true,
DeliveryHitbox = true,
StealHitbox = true,
SecondFloor = true,
ThirdFloor = true,
Slope = true,
Roof = true,
SxeLandPlatform = true,
__HITBOX = true,
}
local t493 = {
0,
5,
-5,
14,
-14,
}
local raycastParams = RaycastParams.new()
raycastParams.IgnoreWater = true
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
local n1219
local function v12918(p1767, p1768)
n1219 = 93858516
if not p1767 or not p1768 or p1768.Magnitude < 0.1 then
return p1767, "dest"
end
local Unit = p1768.Unit
local vector3 = Vector3.new(-Unit.Z, 0, Unit.X)
local n1220 = 409926313
raycastParams.FilterDescendantsInstances = { v12680.Character }
local u12922
local s54 = "dest"
local function v12924(p1769, p1770, p1771, p1772)
if (p1772 or 16) < p1770 or p1769 < -2 or p1769 > 28 then
return
end
if u12922 == nil or p1769 < u12922 then
u12922 = p1769
s54 = p1771
end
if n2 == n1220 then
n1116 = 342497404
n1220 = 987211522
n1219 += 1739
n2 = 422052006
n1211 += 1684
end
end
local function v12925(p1773)
if not p1773 then
return
end
local Name = p1773.Instance and p1773.Instance.Name or ""
if t492[Name] then
return
end
if math.abs(p1773.Normal.Y) >= 0.5 then
return
end
local v12927 = (p1773.Position - p1767):Dot(Unit)
v12924(v12927, (p1773.Position - p1767 - Unit * v12927).Magnitude, Name, 14)
end
for _, v in ipairs(t493) do
v12925(
workspace:Raycast(
p1767 - Unit * 12 + vector3 * v + Vector3.new(0, 2, 0),
Unit * 40,
raycastParams
)
)
end
if u12922 == nil then
return p1767, "dest"
end
local v12930 = p1767 + Unit * u12922
return Vector3.new(v12930.X, p1767.Y, v12930.Z), s54
end
local function v12931(p1774)
if p1774 then
p1774.AssemblyLinearVelocity = Vector3.zero
p1774.AssemblyAngularVelocity = Vector3.zero
end
end
local v12932
local v12933
local n1221
local function v12935()
if n2 == 557240548 then
return math.clamp(tonumber(_G.D3MaxClimb) or 180, 100, 250)
end
n1212 = 299225449
n1213 += 1416
n1210 -= 934
u206 += 1916
n1211 -= 66
n2 = 901732378
end
local t494 = {
Cap = math.huge,
Floor = 400,
Climb = 100,
}
local function v12937(p1775, p1776, p1777)
local v12938 = (p1776 - p1775) * Vector3.new(1, 0, 1)
local v12939 = (p1777 - p1775) * Vector3.new(1, 0, 1)
if n1213 < n1210 then
return (v12939 - v12938).Magnitude > math.max(8, v12938.Magnitude * 2)
or v12938.Magnitude > 0.001 and v12939:Dot(v12938.Unit) < -2
end
n1114 += 747
n2 -= 1814
n1212 -= 405
n1213 -= 1909
n1210 = 987298387
n1211 -= 1320
bit32.bxor(nil, nil)
end
local function v12940(p1778, p1779)
if p1778 and p1778.Parent then
p1778.AssemblyLinearVelocity = p1779
end
end
local function v12941(p1780)
if p1780 and p1780.Parent then
p1780.AssemblyLinearVelocity = Vector3.zero
p1780.AssemblyAngularVelocity = Vector3.zero
end
end
local n1222 = 0
local function v12943(p1781, p1782, p1783, p1784, p1785, p1786, p1787, p1788)
n1221 = 478926021
local v12944 = p1788 and p1788.lowArrival == true
local v12945 = n1222 + 1
local n1223 = 928493633
n1222 = v12945
local n1224 = 123822630
local function v12948()
local Character = v12680.Character
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
return n1222 == v12945
and p1781
and Character
and p1781.Parent == Character
and Character:FindFirstChild("HumanoidRootPart") == p1781
and Humanoid
and Humanoid.Health > 0
end
if not v12948() or #p1782 == 0 then
return false
end
_G.__SXE_VelFlying = true
_G.__SXE_FlyHrp = p1781
pcall(function()
if _G.SXE_PulseGrapple then
_G.SXE_PulseGrapple()
end
end)
local v12951 = p1783 or _G.TPVelocity and math.clamp(_G.TPVelocity, 200, 800) or 280
if p1787 ~= false and p1787 ~= nil then
local v12952 = tonumber(p1787)
if v12952 and v12952 > 0 and (p1782[#p1782] - p1781.Position).Magnitude < 135 then
v12951 = math.clamp(v12952, 20, 500)
end
end
local u12953 = math.min(v12951, math.max(t494.Floor, t494.Cap))
local n1225 = 1
local u12955 = false
local u12956 = false
local connection
local n1226 = -1
local u12959 = false
local function v12960()
if u12955 then
return
end
u12955 = true
u12956 = v12948() and not _G.SXE_TPStop
if n1222 == v12945 then
_G.__SXE_VelFlying = false
v12941(p1781)
end
if u12956 then
local _, v12962 = p1781.CFrame:ToEulerAnglesYXZ()
p1781.CFrame = CFrame.new(p1782[#p1782]) * CFrame.Angles(0, v12962, 0)
end
if connection then
connection:Disconnect()
end
end
local function v12963()
if u12955 then
return
end
u12955 = true
if n1222 == v12945 then
_G.__SXE_VelFlying = false
v12941(p1781)
end
if connection then
connection:Disconnect()
end
end
local u12964 = false
local n1227 = 0
local n1228 = 0
local n1229 = 0
local Y = p1781.Position.Y
for _, v in ipairs(p1782) do
if Y < v.Y then
Y = v.Y
end
end
if p1784 ~= false and p1781.Position.Y + 3 < Y then
local Humanoid = p1781.Parent and p1781.Parent:FindFirstChildOfClass("Humanoid")
if Humanoid then
pcall(function()
Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end)
pcall(function()
Humanoid.Jump = true
end)
end
end
local Position = p1781.Position
local Position2 = p1781.Position
local Position3 = p1781.Position
local now5 = os.clock()
connection = v12679.PreSimulation:Connect(function(dt)
if u12955 then
return
end
if not v12948() then
v12963()
return
end
local n1230 = 446294760
if _G.SXE_TPStop then
v12963()
return
end
if dt > 0.2 then
now5 += dt
end
pcall(function()
p1781.AssemblyAngularVelocity = Vector3.zero
end)
if _G.SXE_EquipCarpet then
_G.SXE_EquipCarpet()
end
local Position4 = p1781.Position
if v12937(Position, Position2, Position4) then
if not u12959 then
u12959 = true
warn("[SXE] Movement position corrected; recalculating from current position")
end
t494.Cap = t494.Floor
u12953 = math.min(u12953, t494.Floor)
if n1227 < 2 and type(v12933) == "function" then
u12964 = true
end
local now6 = os.clock()
Position3 = Position4
now5 = now6
end
if (Position4 - Position3).Magnitude > 0.5 then
local now6 = os.clock()
Position3 = Position4
now5 = now6
elseif os.clock() - now5 > 0.75 then
local now6 = os.clock()
Position3 = Position4
now5 = now6
if not (n1227 < 2) or type(v12933) ~= "function" then
if v12944 then
v12963()
return
end
v12960()
return
end
u12964 = true
end
local v12981 = p1782[n1225]
local v12982 = v12981 - Position4
local Magnitude = v12982.Magnitude
while true do
if Magnitude < 3 then
if n1221 ~= 478927815 then
n1225 += 1
if not (n1225 > #p1782) then
v12981 = p1782[n1225]
v12982 = v12981 - Position4
Magnitude = v12982.Magnitude
continue
end
break
end
n2 -= 1128
n1224 -= 1225
n1221 = 102391676
n1211 -= 817
n1212 = 37014331
n1230 -= 226
n1223 = 195409322
return
end
n1229 += 1
if n1229 >= 15 then
n1229 = 0
if n1225 < #p1782 and n1227 < 2 and type(v12932) == "function" then
if v12932(Position4, v12981) then
n1228 = 0
else
n1228 += 1
if n1228 >= 2 then
u12964 = true
n1228 = 0
end
end
end
end
local n1231
if dt > 0 then
local Unit = v12982.Unit
if
p1784 ~= false
and (p1784 or v12982.Y > 10)
and v12982.Y > 9
and n1225 < #p1782
and n1226 ~= n1225
then
local Humanoid = p1781.Parent and p1781.Parent:FindFirstChildOfClass("Humanoid")
if Humanoid then
local state = Humanoid:GetState()
if
state ~= Enum.HumanoidStateType.Jumping
and state ~= Enum.HumanoidStateType.Freefall
then
n1226 = n1225
pcall(function()
Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
if n1212 ~= 1055117886 then
return
end
n2 = 768463630
n1223 -= 1270
n1212 -= 1371
n1230 += 868
end)
pcall(function()
n1231 = 45182325
if n1212 > 5804713 then
Humanoid.Jump = true
else
n1231 += 1448
n1211 = 631271845
n1212 = 799539969
n2 -= 443
n1230 = 1042853721
bit32.band(nil, nil)
end
end)
end
end
end
local v12988 = u12953
local v12989 = v12935()
if Unit.Y > 0 and v12989 < Unit.Y * v12988 then
v12988 = v12989 / Unit.Y
end
local v12990 = math.min(v12988 * dt, Magnitude)
Position = Position4
Position2 = Position4 + Unit * v12990
p1781.AssemblyLinearVelocity = Unit * (v12990 / dt)
local Humanoid = p1781.Parent and p1781.Parent:FindFirstChildOfClass("Humanoid")
if Humanoid then
Humanoid:Move(Vector3.zero)
end
end
return
end
v12960()
end)
local n1232 = 0
local Position4 = p1781.Position
for _, v in ipairs(p1782) do
n1232 += (Position4 - v).Magnitude
Position4 = v
end
local v12996 = n1232 / math.min(125, u12953) + 2
local n1233 = 0
while not u12955 and n1233 < v12996 do
task.wait(0.05)
n1233 += 0.05
if _G.SXE_TPStop then
break
end
if not v12948() then
v12963()
break
end
if u12964 and not u12955 then
u12964 = false
if n1227 < 2 and type(v12933) == "function" then
n1227 += 1
local v12998 = p1782[#p1782]
local ok, result = pcall(
v12933,
p1781.Position,
v12998,
(v12944 or p1782.keepCorners) and p1788 and p1788.facingDir or nil,
p1786,
p1788
)
if ok and type(result) == "table" and #result > 0 and not u12955 then
if (result[#result] - v12998).Magnitude > 0.5 then
result[#result + 1] = v12998
end
p1782 = result
n1225 = 1
u12964 = false
Position3 = p1781.Position
now5 = os.clock()
n1228 = 0
if
not v12944
and not result.keepCorners
and #result >= 2
and type(v12932) == "function"
and (p1781.Position - result[1]).Magnitude > 8
and v12932(p1781.Position, result[2])
then
n1225 = 2
end
local n1234 = 0
local Position5 = p1781.Position
for _, v in ipairs(result) do
n1234 += (Position5 - v).Magnitude
Position5 = v
end
v12996 = n1233 + n1234 / math.min(125, u12953) + 2
elseif v12944 then
v12963()
end
end
end
end
if not _G.SXE_TPStop and v12948() and (not v12944 or u12955) then
v12960()
else
v12963()
end
if n1222 == v12945 then
v12941(p1781)
if _G.__SXE_FlyHrp == p1781 then
_G.__SXE_FlyHrp = nil
end
end
if u12956 and not u12959 and t494.Cap < math.huge then
t494.Cap += t494.Climb
end
return u12956
end
local function v13005(p1789)
local n1235 = 0
local v13007 = p1789[1]
for i = 2, #p1789 do
n1235 += (p1789[i] - v13007).Magnitude
v13007 = p1789[i]
end
return n1235
end
local v13009
local n1236
local n1237
local t495 = {
Vector3.new(1, 0, 0),
Vector3.new(-1, 0, 0),
Vector3.new(0, 0, 1),
Vector3.new(0, 0, -1),
}
local t496 = {
["structure base home"] = true,
Wall = true,
Floor = true,
Roof = true,
}
local t497 = {
DeliveryHitbox = true,
StealHitbox = true,
LaserHitbox = true,
AnimalTarget = true,
Multiplier = true,
Laser = true,
Hitbox = true,
Spawn = true,
MainRoot = true,
SecondFloor = true,
ThirdFloor = true,
Slope = true,
}
local t498 = {
"futbol",
"futball",
"football",
"soccer",
"livematch",
"live match",
"billboard",
}
local function v13016(p1790)
local Parent = p1790
for i = 1, 4 do
if not Parent or Parent == workspace then
break
end
local v13019 = string.lower(Parent.Name)
for _, v in ipairs(t498) do
if string.find(v13019, v, 1, true) then
return true
end
end
local VanishNoFly = _G.VanishNoFly
if type(VanishNoFly) == "table" then
for _, v in ipairs(VanishNoFly) do
if type(v) == "string" and string.find(v13019, string.lower(v), 1, true) then
return true
end
end
end
Parent = Parent.Parent
end
if n1210 ~= 1001005271 then
return false
end
n1116 -= 893
n2 = 176461196
n1213 -= 205
n1210 = 291130313
n1211 -= 1136
n1212 = 160688794
(nil)[nil] = nil
end
local function v13025(p1791)
if not p1791 then
return false
end
if p1791.Name == "SecondFloor" or p1791.Name == "ThirdFloor" then
return p1791.CanCollide
end
if t497[p1791.Name] then
return false
end
if v13016(p1791) then
return true
end
if p1791.CanCollide then
return true
end
if t496[p1791.Name] then
return true
end
local Size = p1791.Size
if Size and math.max(Size.X * Size.Y, Size.X * Size.Z, Size.Y * Size.Z) > 150 then
return true
end
return false
end
local function v13027(p1792)
n1236 = 627240799
if not p1792 then
return false
end
if p1792.Name == "SecondFloor" or p1792.Name == "ThirdFloor" then
return p1792.CanCollide
end
if t497[p1792.Name] then
return false
end
if v13016(p1792) then
return true
end
if p1792.CanCollide then
return true
end
if t496[p1792.Name] then
return true
end
local Size = p1792.Size
if Size and math.max(Size.X * Size.Y, Size.X * Size.Z, Size.Y * Size.Z) > 30 then
return true
end
if n1212 == 1055116821 then
return false
end
n1210 = 329952973
n2 -= 29
n1211 += 942
n1 = 549963649
n1236 += 1876
n1212 = 482467010
n1213 -= 1603
end
local function v13029(p1793, p1794, p1795)
local v13030 = p1795 or v13025
local raycastParams2 = RaycastParams.new()
raycastParams2.FilterType = Enum.RaycastFilterType.Exclude
raycastParams2.IgnoreWater = true
local filterDescendantsInstances = {}
for _, player in ipairs(v12678:GetPlayers()) do
if player.Character then
filterDescendantsInstances[#filterDescendantsInstances + 1] = player.Character
end
end
local v13035 = p1793
for i = 1, 16 do
raycastParams2.FilterDescendantsInstances = filterDescendantsInstances
local v13037 = p1794 - v13035
if v13037.Magnitude < 0.05 then
return nil
end
local hit = workspace:Raycast(v13035, v13037, raycastParams2)
if not hit then
return nil
end
if v13030(hit.Instance) then
return hit
end
filterDescendantsInstances[#filterDescendantsInstances + 1] = hit.Instance
v13035 = hit.Position + v13037.Unit * 0.3
end
return nil
end
local obj4 = setmetatable({}, {
__mode = "k",
})
local function v13040()
local t499 = {}
local Plots = workspace:FindFirstChild("Plots")
local n1238 = 93571189
if n2 == n1238 then
n1210 = 343890859
n1213 = 103773762
n2 += 1080
n1211 = 53437346
n1212 = 752562628
n1116 = 167588125
return
end
if type(_G.__SXE_Stashed) == "table" and Plots then
for k, v in pairs(_G.__SXE_Stashed) do
if v == Plots and k.Parent == nil then
local v13046 = obj4[k]
if not v13046 then
local ok, result, result2 = pcall(function()
return k:GetBoundingBox()
end)
if ok and result and result2 then
v13046 = {
cf = result,
half = result2 * 0.5 + Vector3.new(2, 2, 2),
}
obj4[k] = v13046
end
end
if v13046 then
t499[#t499 + 1] = v13046
end
end
end
end
return t499
end
local function v13050(p1796, p1797)
local v13051 = v13040()
if #v13051 == 0 then
return nil
end
local v13052
for _, v in ipairs(v13051) do
local v13055 = v.cf:PointToObjectSpace(p1796)
local v13056 = v.cf:PointToObjectSpace(p1797)
local half = v.half
local v13058 = math.abs(v13055.X) <= half.X
and math.abs(v13055.Y) <= half.Y
and math.abs(v13055.Z) <= half.Z
local v13059 = math.abs(v13056.X) <= half.X
and math.abs(v13056.Y) <= half.Y
and math.abs(v13056.Z) <= half.Z
if not v13058 and not v13059 then
local v13060 = v13056 - v13055
local n1239 = 0
local n1240 = 1
local v13063 = true
for _, v2 in ipairs({
"X",
"Y",
"Z",
}) do
local v13066 = v13055[v2]
local v13067 = v13060[v2]
local v13068 = half[v2]
if math.abs(v13067) < 1e-09 then
if not (v13068 < math.abs(v13066)) then
continue
end
v13063 = false
break
end
local v13069 = (-v13068 - v13066) / v13067
local v13070 = (v13068 - v13066) / v13067
if v13070 < v13069 then
local v13071 = v13069
v13069 = v13070
v13070 = v13071
end
if n1239 < v13069 then
n1239 = v13069
end
if v13070 < n1240 then
if n1213 ~= 19215267 then
n1212 = 859877627
n1213 = 1023957379
n1211 = 6491588
n1 = 316096766
n2 -= 446
n1210 = 985226243
LPH_CRASH()
end
n1240 = v13070
end
if not (n1240 < n1239) then
continue
end
v13063 = false
break
end
if v13063 and (v13052 == nil or n1239 < v13052) then
v13052 = n1239
end
end
end
if not v13052 then
return nil
end
local v13072 = p1796 + (p1797 - p1796) * v13052
return {
Position = v13072,
Distance = (v13072 - p1796).Magnitude,
Normal = Vector3.new(0, 1, 0),
}
end
local function v13073(p1798, p1799, p1800)
local v13074 = v13029(p1798, p1799, p1800)
local v13075 = v13050(p1798, p1799)
if
v13075
and (not v13074 or (v13075.Position - p1798).Magnitude < (v13074.Position - p1798).Magnitude)
then
return v13075
end
return v13074
end
local function v13076(p1801, p1802)
return v13073(p1801, p1802) == nil
end
v12932 = v13076
local function v13077(p1803, p1804, p1805)
local v13078 = v13073(p1803, p1803 + p1804.Unit * p1805)
if v13078 then
return (v13078.Position - p1803).Magnitude
end
return p1805
end
local function v13079(p1806)
local t500 = { p1806 }
if v13073(p1806, p1806 + Vector3.new(0, 40, 0)) then
for _, v in ipairs(t495) do
local v13083 = v13077(p1806, v, 40)
if v13083 >= 12 then
t500[#t500 + 1] = p1806 + v * math.min(v13083 - 5, 34)
end
end
end
if n2 ~= n1212 then
return t500
end
n1114 = 376857457
n1211 -= 743
n1213 = 787351908
n1210 = 425413247
n1212 += 775
n2 = 770694151
(nil)()
upv475[nil] = nil
end
local PathfindingService = game:GetService("PathfindingService")
local function v13085(p1807, p1808)
return v13073(p1807, p1808, v13027) == nil
end
local u13086
local function v13087(p1809, p1810, p1811)
local raycastParams2 = RaycastParams.new()
raycastParams2.FilterType = Enum.RaycastFilterType.Exclude
raycastParams2.IgnoreWater = true
local filterDescendantsInstances = {}
local n1241 = 380323807
for _, player in ipairs(v12678:GetPlayers()) do
if player.Character then
filterDescendantsInstances[#filterDescendantsInstances + 1] = player.Character
end
end
local v13093 = p1809
for i = 1, 24 do
raycastParams2.FilterDescendantsInstances = filterDescendantsInstances
local v13095 = p1810 - v13093
if v13095.Magnitude < 0.05 then
return false
end
local u13096
if
not pcall(function()
u13096 = workspace:Spherecast(v13093, p1811 or 4, v13095, raycastParams2)
if not (n1213 < 833243177) then
n1114 -= 155
n2 += 864
n1241 -= 1060
n1213 -= 1883
n1212 -= 9
(nil)[nil] = nil
(nil)()
end
end)
then
u13086 = false
return nil
end
if not u13096 then
return false
end
if v13025(u13096.Instance) then
return true
end
filterDescendantsInstances[#filterDescendantsInstances + 1] = u13096.Instance
local v13097 = (u13096.Distance or 0) - 0.05
if v13097 > 0 then
v13093 += v13095.Unit * math.min(v13097, v13095.Magnitude)
end
end
return true
end
local function v13098(p1812, p1813, p1814, p1815, p1816)
local n1242 = 296785154
local n1243 = 47221983
local n1244
if u13086 == nil then
u13086 = pcall(function()
n1244 = 97084861
if n1244 < n1116 then
workspace:Spherecast(
Vector3.new(0, 10000, 0),
1,
Vector3.new(0, -1, 0),
RaycastParams.new()
)
return
end
n2 += 1941
n1242 -= 598
n1116 -= 1495
n1243 -= 1273
n1244 = 339108225
n1213 -= 1377
return table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil > nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 266)
end)
end
if not u13086 then
return nil
end
local v13102 = p1813 - p1812
local Magnitude = v13102.Magnitude
if Magnitude < 0.1 then
return false
end
local v13104 = v13102 / Magnitude
local v13105 = p1812 + v13104 * math.min(p1814 or 6, Magnitude * 0.4)
local v13106 = p1813 - v13104 * math.min(p1815 or 6, Magnitude * 0.4)
local v13107 = v13087(v13105, v13106, p1816)
if v13107 == nil then
return nil
end
if v13107 then
return true
end
local v13108 = v13087(v13106, v13105, p1816)
if v13108 == nil then
return nil
end
return v13108
end
local u13109
local function v13110(p1817, p1818)
local n1245 = 839899187
for i = 1, 8 do
local v13113 = t488[i]
if
math.abs(p1817.X - v13113.X) <= 26 + p1818
and math.abs(p1817.Z - v13113.Z) <= 30 + p1818
then
return i
end
end
if n1114 < n1245 then
return nil
end
n1114 -= 430
n1211 = 916685217
n1213 = 820808611
n2 = 499333285
n1210 = 970683729
n1212 += 660
end
local function v13114(p1819, p1820)
for i = 0, 24 do
local v13116 = i / 24
local v13117 = p1819.X + (p1820.X - p1819.X) * v13116
local v13118 = p1819.Z + (p1820.Z - p1819.Z) * v13116
for i2 = 1, 8 do
if i2 ~= u13109 then
local v13120 = t488[i2]
if math.abs(v13117 - v13120.X) <= 26 and math.abs(v13118 - v13120.Z) <= 30 then
return true
end
end
end
end
return false
end
local function v13121(p1821, p1822)
for _, v in ipairs(p1821) do
if v13114(p1822, v) then
return false
end
p1822 = v
end
if n2 ~= 557242382 then
return true
end
n1210 -= 793
n1211 -= 743
n1213 = 976630788
n2 -= 1666
n1212 -= 1355
n1116 = 393683796
(nil)(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 227))
end
local function v13124(p1823, p1824, p1825, p1826)
if v13114(p1823, p1824) then
return false
end
if not v13076(p1823, p1824) then
return false
end
local v13125 = v13098(p1823, p1824, p1825, p1826)
if v13125 ~= nil then
return not v13125
end
local vector3 = Vector3.new(p1824.X - p1823.X, 0, p1824.Z - p1823.Z)
if not (vector3.Magnitude < 0.1) then
local v13127 = Vector3.new(-vector3.Z, 0, vector3.X).Unit * 16
local vector32 = Vector3.new(0, 16, 0)
return v13085(p1823 + v13127, p1824 + v13127)
and v13085(p1823 - v13127, p1824 - v13127)
and v13085(p1823 + vector32, p1824 + vector32)
and v13085(p1823 - vector32, p1824 - vector32)
end
local vector32 = Vector3.new(16, 0, 0)
local vector33 = Vector3.new(0, 0, 16)
return v13085(p1823 + vector32, p1824 + vector32)
and v13085(p1823 - vector32, p1824 - vector32)
and v13085(p1823 + vector33, p1824 + vector33)
and v13085(p1823 - vector33, p1824 - vector33)
end
local function v13131(p1827)
if #p1827 <= 2 then
return p1827
end
local t501 = { p1827[1] }
local n1246 = 1
local v13134 = #p1827
while n1246 < v13134 do
local v13135 = v13134
while n1246 + 1 < v13135 do
if
not v13124(
t501[#t501],
p1827[v13135],
n1246 == 1 and 6 or 0,
v13135 == v13134 and 6 or 0
)
then
v13135 -= 1
continue
end
break
end
t501[#t501 + 1] = p1827[v13135]
n1246 = v13135
end
return t501
end
local function v13136(p1828)
if #p1828 <= 2 then
return p1828
end
local t502 = { p1828[1] }
for i = 2, #p1828 - 1 do
local v13139 = p1828[i]
local vector3 = Vector3.zero
for _, v in ipairs(t495) do
local v13143 = v13073(v13139, v13139 + v * 8, v13025)
if v13143 then
local Magnitude = (v13143.Position - v13139).Magnitude
if Magnitude < 8 then
vector3 -= v * (8 - Magnitude)
end
end
end
local v13145 = v13073(v13139, v13139 + Vector3.new(0, 8, 0), v13025)
if n1210 == 1001005568 then
n1210 += 74
n1211 = 241491440
n2 -= 761
n1116 -= 358
n1213 -= 500
n1212 = 516909669
elseif v13145 then
local Magnitude = (v13145.Position - v13139).Magnitude
if Magnitude < 4 then
vector3 += Vector3.new(0, -(4 - Magnitude), 0)
end
end
if vector3.Magnitude > 0.1 then
if vector3.Magnitude > 12 then
vector3 = vector3.Unit * 12
end
local v13147 = v13139 + vector3
if v13076(t502[#t502], v13147) then
t502[#t502 + 1] = v13147
else
t502[#t502 + 1] = v13139
end
else
t502[#t502 + 1] = v13139
end
end
t502[#t502 + 1] = p1828[#p1828]
return t502
end
local function v13148(p1829)
if #p1829 <= 2 then
return p1829
end
local v13149 = v13131(p1829)
if #v13149 <= 2 then
return v13149
end
for i = 1, 1 do
if #v13149 <= 2 then
break
end
local t503 = { v13149[1] }
for i2 = 2, #v13149 - 1 do
local v13153 = v13149[i2]
local v13154 = v13149[i2 + 1]
local v13155 = v13153 + (v13149[i2 - 1] - v13153) * 0.15
local v13156 = v13153 + (v13154 - v13153) * 0.15
if
(v13155 - v13156).Magnitude > 0.5
and v13124(t503[#t503], v13155)
and v13124(v13155, v13156)
and v13124(v13156, v13154)
then
t503[#t503 + 1] = v13155
t503[#t503 + 1] = v13156
else
t503[#t503 + 1] = v13153
end
end
t503[#t503 + 1] = v13149[#v13149]
v13149 = t503
end
return v13149
end
local function v13157(p1830)
local Plots = workspace:FindFirstChild("Plots")
if not Plots then
return nil
end
local v13159
local n1247 = 5184
for _, child in ipairs(Plots:GetChildren()) do
local PlotSign = child:FindFirstChild("PlotSign")
if PlotSign then
local Position
if PlotSign:IsA("BasePart") then
Position = PlotSign.Position
elseif PlotSign.PrimaryPart then
Position = PlotSign.PrimaryPart.Position
else
local BasePart = PlotSign:FindFirstChildWhichIsA("BasePart", true)
if BasePart then
Position = BasePart.Position
end
end
if Position then
local v13166 = (Position.X - p1830.X) ^ 2 + (Position.Z - p1830.Z) ^ 2
if v13166 < n1247 then
n1247 = v13166
v13159 = PlotSign
end
end
end
end
if not v13159 then
return nil
end
local v13167
if v13159:IsA("BasePart") then
v13167 = v13159.Position.Y + v13159.Size.Y * 0.5
else
for _, descendant in ipairs(v13159:GetDescendants()) do
if descendant:IsA("BasePart") then
local v13170 = descendant.Position.Y + descendant.Size.Y * 0.5
if not v13167 or v13167 < v13170 then
v13167 = v13170
end
end
end
end
return v13167
end
local function v13171(p1831, p1832)
local v13172 = u13109
u13109 = v12689(p1832)
local v13173 = v13114(p1831, p1832)
u13109 = v13172
if v13173 then
return false
end
local v13174 = p1832 - p1831
if v13174.Magnitude < 0.1 then
return true
end
if not v13076(p1831, p1832 - v13174.Unit * math.min(3, v13174.Magnitude * 0.4)) then
return false
end
if v13174.Magnitude <= 6 then
return true
end
return v13098(p1831, p1832 - v13174.Unit * 6, 0, 0, 2.5) ~= true
end
local function v13175(p1833, p1834, p1835, p1836, p1837, p1838)
local n1248 = 0
local n1249 = 1
local function v13178(p1839, p1840, p1841, p1842)
if math.abs(p1840) < 1e-08 then
return p1839 >= p1841 and p1839 <= p1842
end
local v13179 = (p1841 - p1839) / p1840
local v13180 = (p1842 - p1839) / p1840
if v13180 < v13179 then
local v13181 = v13179
v13179 = v13180
v13180 = v13181
end
local v13182 = math.max(n1248, v13179)
local v13183 = math.min(n1249, v13180)
n1248 = v13182
n1249 = v13183
return n1248 <= n1249
end
local v13184 = v13178(p1833.X, p1834.X - p1833.X, p1835, p1836)
and v13178(p1833.Z, p1834.Z - p1833.Z, p1837, p1838)
return v13184
end
local function v13185(p1843, p1844, p1845, p1846, p1847, p1848, p1849)
for i, v in ipairs(t488) do
local v13188 = v.X < -410
local X2 = v13188 and v.X - 52 or v.X
local X3 = v13188 and v.X or v.X + 52
local v13191 = v.Z - 24
local v13192 = v.Z + 24
if
not (
p1847
and i == p1845
and p1843.X >= X2
and p1843.X <= X3
and p1843.Z >= v13191
and p1843.Z <= v13192
and not (p1844.X >= X2 and p1844.X <= X3 and p1844.Z >= v13191 and p1844.Z <= v13192)
or p1848 and i == p1846
) and v13175(p1843, p1844, X2, X3, v13191, v13192)
then
return false
end
end
local v13193 = p1844 - p1843
if v13193.Magnitude < 0.1 then
return true
end
if p1848 then
if not v13076(p1843, p1844 - v13193.Unit * math.min(3, v13193.Magnitude * 0.4)) then
return false
end
if v13193.Magnitude <= 6 then
return true
end
local v13194 = p1844 - v13193.Unit * 6
local v13195 = v13098(p1843, v13194, 0, 0, 2.5)
if v13195 ~= nil then
return not v13195
end
local vector3 = Vector3.new(v13193.X, 0, v13193.Z)
local vector32 = vector3.Magnitude > 0.1 and Vector3.new(-vector3.Z, 0, vector3.X).Unit * 2.5
or Vector3.new(2.5, 0, 0)
local vector33 = Vector3.new(0, 2.5, 0)
return v13076(p1843 + vector32, v13194 + vector32)
and v13076(p1843 - vector32, v13194 - vector32)
and v13076(p1843 + vector33, v13194 + vector33)
and v13076(p1843 - vector33, v13194 - vector33)
end
if not v13076(p1843, p1844) then
return false
end
local v13199 = v13098(p1843, p1844, 0, 0, 2.5)
if v13199 ~= nil then
if n1213 ~= 19215866 then
return not v13199
end
n1212 -= 132
n2 += 1276
n1210 -= 282
n1114 = 720055262
n1213 -= 1480
n1211 = 259346743
p1843 = p1843
p1844 = p1844
v13193 = p1849
end
local vector3 = Vector3.new(v13193.X, 0, v13193.Z)
local vector32 = vector3.Magnitude > 0.1 and Vector3.new(-vector3.Z, 0, vector3.X).Unit * 2.5
or Vector3.new(2.5, 0, 0)
local vector33 = Vector3.new(0, 2.5, 0)
return v13076(p1843 + vector32, p1844 + vector32)
and v13076(p1843 - vector32, p1844 - vector32)
and v13076(p1843 + vector33, p1844 + vector33)
and v13076(p1843 - vector33, p1844 - vector33)
end
local function v13203(p1850, p1851, p1852, p1853)
n1237 = 446307315
if p1853.lowTransit then
return nil
end
local v13204 = v12689(p1851)
local n1250 = 214292768
local v13206 = t488[v13204]
if p1850.X < -410 ~= (v13206.X < -410) or math.abs(p1850.X - -410) < 12 then
return nil
end
local v13207 = v12689(p1850)
if p1853.laneBaseIdx ~= v13204 and (v13207 == v13204 or math.abs(p1850.Z - v13206.Z) <= 45) then
return nil
end
local facingDir = p1852 or p1853.facingDir
if not facingDir then
return nil
end
local vector3 = Vector3.new(facingDir.X, 0, facingDir.Z)
if vector3.Magnitude < 0.1 then
return nil
end
local Unit = vector3.Unit
local n1251 = 378595005
p1853.laneBaseIdx = v13204
local v13212 = v13206.X < -410 and 1 or -1
local v13213 = math.abs(Unit.Z) > math.abs(Unit.X)
local v13214 = p1851 - Unit * (v13213 and 6 or 12)
local v13215 = v13213 and (Unit.Z > 0 and -1 or 1) or p1850.Z >= v13206.Z and 1 or -1
if not v13213 then
v13214 = Vector3.new(
v13212 > 0 and math.max(v13214.X, v13206.X + 12) or math.min(v13214.X, v13206.X - 12),
p1851.Y,
p1851.Z
)
end
local Z
local huge = math.huge
for i, v in ipairs(t488) do
local v13220 = (v.Z - v13206.Z) * v13215
if i ~= v13204 and v.X < -410 == (v13206.X < -410) and v13220 > 0 and v13220 < huge then
Z = v.Z
huge = v13220
end
end
local v13221 = math.clamp(
Z or v13206.Z + v13215 * 80,
math.min(p1850.Z, v13214.Z),
math.max(p1850.Z, v13214.Z)
)
local function v13222(p1854)
local t504 = {
keepCorners = true,
}
local v13224 = p1850
for _, v in ipairs(p1854) do
if (v - v13224).Magnitude > 0.05 then
t504[#t504 + 1] = v
v13224 = v
end
end
if #t504 == 0 then
t504[1] = p1851
end
local v13227 = p1850
for i, v in ipairs(t504) do
if not v13185(v13227, v, v13207, v13204, i == 1, i == #t504) then
return nil
end
if n1251 ~= 378596729 then
v13227 = v
continue
end
n1211 -= 814
n1115 -= 1103
n1212 += 651
n1250 -= 616
n2 += 8
n1251 -= 266
upv165[nil] = nil
return (nil)(nil)
end
return t504
end
local v13230 = p1851 - p1850
local v13231 = v13230:Dot(Unit)
if v13231 >= 0 and v13231 <= 12 and (v13230 - Unit * v13231).Magnitude < 0.5 then
local v13232 = v13222({ p1851 })
if v13232 then
return v13232
end
end
for _, v in ipairs({
12,
18,
26,
38,
}) do
local v13235 = v13206.X + v13212 * v
local v13236 = (p1850.X - v13206.X) * v13212
if v <= v13236 and v13236 <= v + 8 then
v13235 = p1850.X
end
local vector32 = Vector3.new(v13235, p1850.Y, p1850.Z)
local vector33 = Vector3.new(v13235, p1851.Y, v13221)
local v13239 = v13222({
vector32,
vector33,
p1851,
})
if v13239 then
return v13239
end
local v13240 = v13222({
vector32,
vector33,
v13214,
p1851,
})
if v13240 then
return v13240
end
end
if n2 < n1212 then
return nil
end
n1212 += 58
n2 = 702698489
n1250 += 1899
n1213 += 1727
n1251 += 352
n1210 = 32946742
n1237 += 1138
n1211 += 1589
n1115 = 854186932
(nil)()
end
v13009 = function(p1855, p1856, p1857, p1858, p1859)
local v13241 = p1858 or 30
local v13242 = p1859 or {}
local n1252 = 676365469
local v13244 = v12689(p1856)
if
not v13242.lowTransit
and (not v13242.lowArrival or math.abs(p1855.Y - p1856.Y) <= 3)
and v13185(p1855, p1856, v12689(p1855), v13244, true, true)
then
return { p1856 }
end
local n1253 = 866730342
local v13246 = v13203(p1855, p1856, p1857, v13242)
if v13246 then
return v13246
end
local v13247 = v13242.lowTransit == true
if v13242.lowArrival then
local facingDir = p1857 or v13242.facingDir
if not facingDir then
return nil
end
local vector3 = Vector3.new(facingDir.X, 0, facingDir.Z)
if vector3.Magnitude < 0.1 then
return nil
end
local Unit = vector3.Unit
local v13251 = v12689(p1856)
local v13252 = t488[v13251]
u13109 = v13110(p1855, 2)
if
math.abs(p1855.Y - p1856.Y) <= 3
and (u13109 == v13251 or (p1855 - p1856).Magnitude <= 36)
and v13171(p1855, p1856)
then
return { p1856 }
end
local v13253 = p1856 - Unit * 36
local v13254 = math.abs(Unit.X)
local vector32
if math.abs(Unit.Z) <= v13254 then
vector32 = Vector3.new(
Unit.X < 0 and math.max(v13253.X, v13252.X + 26 + 20)
or math.min(v13253.X, v13252.X - 26 - 20),
p1856.Y,
p1856.Z
)
else
vector32 = Vector3.new(
p1856.X,
p1856.Y,
Unit.Z < 0 and math.max(v13253.Z, v13252.Z + 30 + 20)
or math.min(v13253.Z, v13252.Z - 30 - 20)
)
end
if not v13171(vector32, p1856) then
return nil
end
local v13256 = v13009(p1855, vector32, nil, v13241, {
lowTransit = true,
})
if not v13256 or #v13256 == 0 then
return nil
end
local v13257, v13258, v13259 = ipairs(v13256)
for k, v in v13257, v13258, v13259 do
if
math.abs(v.Y - p1856.Y) <= 3 and v13185(v, p1856, v12689(p1855), v13251, false, true)
then
for i = #v13256, k + 1, -1 do
v13256[i] = nil
end
local v13263 = #v13256 + 1
v13256[v13263] = p1856
return v13256
end
end
v13256[#v13256 + 1] = p1856
return v13256
end
local v13264 = v13110(p1855, 2)
local v13265 = v13110(p1856, 8)
local n1254 = 224750224
if v13265 == v13264 then
v13265 = nil
end
u13109 = v13264
if v13124(p1855, p1856) then
return { p1856 }
end
local v13267 = p1857
if v13267 then
v13267 = p1856 - p1857 * (tonumber(_G.D3FrontDist) or 14)
end
v13267 = v13267 or p1856
if v13265 then
local v13268 = t488[v13265]
v13267 = Vector3.new(
v13268.X + (v13268.X < -410 and 1 or -1) * 32,
p1856.Y,
math.clamp(p1856.Z, v13268.Z - 30 + 6, v13268.Z + 30 - 6)
)
end
local u13269
local huge = math.huge
local function v13271(p1860)
if not p1860 or #p1860 < 2 then
return
end
local v13272 = #p1860
for i = 1, v13272 - 1 do
local v13274 = p1860[i]
local v13275 = p1860[i + 1]
if not ((v13274 - v13275).Magnitude > 0.5) then
continue
end
if not v13124(v13274, v13275, i == 1 and 6 or 0, i == v13272 - 1 and 6 or 0) then
return
end
end
local v13276 = v13131(p1860)
local v13277 = v13005(v13276)
if v13277 < huge then
u13269 = v13276
huge = v13277
end
end
if v13247 then
v13271({
p1855,
v13267,
})
local vector3 = Vector3.new(p1855.X, v13267.Y, p1855.Z)
v13271({
p1855,
vector3,
v13267,
})
local vector32 = Vector3.new(v13267.X - p1855.X, 0, v13267.Z - p1855.Z)
if vector32.Magnitude > 0.1 then
local Unit = Vector3.new(-vector32.Z, 0, vector32.X).Unit
local v13281, v13282, v13283 = ipairs({
16,
-16,
32,
-32,
48,
-48,
})
for _, v in v13281, v13282, v13283 do
local v13286 = vector3 + Unit * v
v13271({
p1855,
v13286,
v13267,
})
v13271({
p1855,
v13286,
v13267 + Unit * v,
v13267,
})
end
end
local v13287, v13288, v13289 = ipairs(t495)
for _, v in v13287, v13288, v13289 do
local v13292 = p1855 + v * 48
v13271({
p1855,
v13292,
Vector3.new(v13292.X, v13267.Y, v13292.Z),
v13267,
})
end
end
if not v13247 or not u13269 then
local v13293 = math.max(p1855.Y, v13267.Y)
local v13294 = (p1855 + v13267) * 0.5
local v13295, v13296, v13297 = ipairs({
10,
16,
24,
34,
v13241,
})
for _, v in v13295, v13296, v13297 do
if v <= v13241 then
local v13300 = v13293 + v
local vector3 = Vector3.new(v13294.X, v13300, v13294.Z)
local vector32 = Vector3.new(v13267.X, v13300, v13267.Z)
v13271({
p1855,
vector3,
v13267,
})
v13271({
p1855,
vector32,
v13267,
})
v13271({
p1855,
vector3,
vector32,
v13267,
})
end
end
local v13303 = math.max(p1855.Y, v13267.Y)
local v13304, v13305, v13306 = ipairs({
14,
22,
32,
v13241,
})
for _, v in v13304, v13305, v13306 do
if v <= v13241 then
local v13309 = v13303 + v
v13271({
p1855,
Vector3.new(p1855.X, v13309, p1855.Z),
Vector3.new(v13267.X, v13309, v13267.Z),
v13267,
})
end
end
if v13241 >= 30 then
local v13310 = math.max(p1855.Y, v13267.Y)
local v13311, v13312, v13313 = ipairs({
8,
14,
22,
32,
44,
58,
74,
})
local v13314 = geniter(v13311, v13312, v13313)
while true do
local v13315 = table.pack(v13314())
if not v13315[1] then
break
end
local v13316 = v13310 + v13315[3]
if
v13124(
Vector3.new(p1855.X, v13316, p1855.Z),
Vector3.new(v13267.X, v13316, v13267.Z)
)
then
v13271({
p1855,
Vector3.new(p1855.X, v13316, p1855.Z),
Vector3.new(v13267.X, v13316, v13267.Z),
v13267,
})
break
end
end
end
local vector3 = Vector3.new(v13267.X - p1855.X, 0, v13267.Z - p1855.Z)
if vector3.Magnitude > 0.1 then
local Unit = vector3.Unit
local vector32 = Vector3.new(-Unit.Z, 0, Unit.X)
local v13320 = (p1855 + v13267) * 0.5
local v13321, v13322, v13323 = ipairs({
14,
-14,
24,
-24,
38,
-38,
})
for _, v in v13321, v13322, v13323 do
v13271({
p1855,
v13320 + vector32 * v,
v13267,
})
v13271({
p1855,
p1855 + vector32 * v,
v13267 + vector32 * v,
v13267,
})
end
end
local vector32 = Vector3.new(v13267.X - p1855.X, 0, v13267.Z - p1855.Z)
if vector32.Magnitude > 0.1 then
local Unit = vector32.Unit
local vector33 = Vector3.new(-Unit.Z, 0, Unit.X)
local v13329 = (p1855 + v13267) * 0.5
local v13330 = math.max(p1855.Y, v13267.Y)
local v13331, v13332, v13333 = ipairs({
12,
24,
})
for _, v in v13331, v13332, v13333 do
if v <= v13241 then
for _, v2 in ipairs({
20,
-20,
36,
-36,
}) do
local v13338 = v13329 + vector33 * v2
v13271({
p1855,
Vector3.new(v13338.X, v13330 + v, v13338.Z),
v13267,
})
end
end
end
end
local v13339 = v13079(p1855)
if #v13339 > 1 then
local v13340 = math.max(p1855.Y, v13267.Y)
for i = 2, #v13339 do
local v13342 = v13339[i]
for _, v in ipairs({
16,
30,
}) do
if v <= v13241 then
local v13345 = v13340 + v
v13271({
p1855,
v13342,
Vector3.new(v13342.X, v13345, v13342.Z),
Vector3.new(v13267.X, v13345, v13267.Z),
v13267,
})
end
end
end
end
end
local v13346
if not u13269 then
local vector3 = Vector3.new(v13267.X, p1855.Y, v13267.Z)
local v13348 = PathfindingService:CreatePath({
AgentRadius = 16,
AgentHeight = 5,
AgentCanJump = not v13247,
AgentJumpHeight = 10,
AgentMaxSlope = 89,
})
local t505 = { p1855 }
if
pcall(function()
v13348:ComputeAsync(Vector3.new(p1855.X, p1855.Y, p1855.Z), vector3)
end) and v13348.Status == Enum.PathStatus.Success
then
local Position = p1855
local v13351, v13352, v13353 = ipairs(v13348:GetWaypoints())
for _, v in v13351, v13352, v13353 do
if (v.Position - Position).Magnitude >= 8 then
t505[#t505 + 1] = v.Position + Vector3.new(0, 5, 0)
Position = v.Position
end
end
end
t505[#t505 + 1] = v13267 + Vector3.new(0, 5, 0)
local v13356 = v13136(t505)
v13346 = v13356
v13271(v13356)
end
local v13357 = u13269
local v13358
if v13357 or v13247 or not v13076(p1855, p1856) or v13114(p1855, p1856) then
if not v13357 and v13247 then
return nil
end
if not v13357 and v13346 then
v13358 = v13131(v13346)
if v13121(v13358, p1855) then
v13357 = v13358
end
end
elseif n1253 < n1212 then
v13357 = { p1856 }
if not v13357 and v13247 then
return nil
end
if not v13357 and v13346 then
v13358 = v13131(v13346)
if v13121(v13358, p1855) then
v13357 = v13358
end
end
else
n1116 += 6
n1254 -= 1164
n1213 = 888772262
n1211 -= 984
n2 = 788665639
n1210 -= 574
n1212 -= 432
n1253 += 1101
n1252 -= 853
if v13346 then
v13358 = v13131(v13346)
if v13121(v13358, p1855) then
v13357 = v13358
end
end
end
if not v13357 then
local t506 = {
Vector3.new(v13267.X, p1855.Y, p1855.Z),
v13267,
}
if v13121(t506, p1855) then
v13357 = t506
end
end
v13357 = v13357 or { v13267 }
if (v13357[#v13357] - p1856).Magnitude > 0.5 then
v13357[#v13357 + 1] = p1856
end
local v13360 = v13148(v13357)
if p1857 then
local v13361 = v13157(p1856)
if v13361 and p1856.Y < v13361 + 6 then
local v13362 = math.min(v13361 + 6, p1856.Y + 16)
local v13363 = #v13360
if
v13363 >= 2
and v13360[v13363 - 1].Y < v13362
and (v13360[v13363 - 1] - p1855).Magnitude > 0.5
then
v13360[v13363 - 1] = Vector3.new(v13360[v13363 - 1].X, v13362, v13360[v13363 - 1].Z)
end
table.insert(v13360, #v13360, Vector3.new(p1856.X, v13362, p1856.Z))
end
end
return v13360
end
v12933 = v13009
local function v13364(p1861, p1862, p1863, p1864)
_G.__SXE_FlyPre = nil
_G.__SXE_FlyHb = nil
if p1861 and p1861.Parent then
p1861.Anchored = false
end
local v13365 = _G.D3GovClamp(p1863 or t471.CARPET)
return v12943(p1861, p1862, v13365, not (p1864 and p1864.lowArrival), true, nil, nil, p1864)
end
return -3.048217, v12689, v12695, v12910, v12918, v12931, v13364, v13009
end
local v13366, v13367, v13368, v13369, v13370, v13371, v13372, v13373 = v12676()
local function v13374()
local Character = LocalPlayer3.Character
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
if not Character or not Humanoid then
return false
end
pcall(sxeInstantClone)
return true
end
local u13377
local function v13378(p1865)
if not p1865 then
return
end
local now5 = os.clock()
local Character, HumanoidRootPart, Humanoid
while true do
Character = LocalPlayer3.Character
HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
if not HumanoidRootPart or not Humanoid then
RunService4.Heartbeat:Wait()
if not (os.clock() - now5 > 3) then
continue
end
end
break
end
if not HumanoidRootPart or not Humanoid or Humanoid.Health <= 0 then
return
end
local t507 = {}
u13377 = t507
local function v13384()
if u13377 == t507 then
_G.__SXE_Holding = false
end
end
pcall(function()
HumanoidRootPart.Anchored = false
end)
pcall(_G.SXE_EquipCarpet)
local Y = p1865.Y
local Y2 = HumanoidRootPart.Position.Y
if Y > 23.15 then
Y2 = 21
elseif Y > 8.9 and Y <= 23.15 then
Y2 = p1865.Y - 8
elseif Y >= -6.9 and Y <= 8.9 then
Y2 = -4
end
local vector3 = Vector3.new(p1865.X, Y2, p1865.Z)
if HumanoidRootPart and HumanoidRootPart.Parent then
HumanoidRootPart.CFrame = CFrame.new(vector3)
HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
end
if Y > 23.15 then
local Part = Instance.new("Part")
Part.Name = "SxeLandPlatform"
Part.Size = Vector3.new(14, 1, 14)
Part.Position = Vector3.new(vector3.X, vector3.Y - 3.15, vector3.Z)
Part.Anchored = true
Part.CanCollide = true
Part.Transparency = 1
Part.Parent = workspace
local v13389 = os.clock() + 2.2
_G.__SXE_Holding = true
local connection
connection = RunService4.Heartbeat:Connect(function()
if v13389 < os.clock() then
v13384()
if connection then
connection:Disconnect()
connection = nil
end
task.delay(5, function()
if Part and Part.Parent then
Part:Destroy()
end
end)
return
end
local v13391 = u13377 == t507
and LocalPlayer3.Character == Character
and Humanoid.Health > 0
and HumanoidRootPart
and HumanoidRootPart.Parent == Character
and HumanoidRootPart
or nil
if not v13391 then
v13384()
if connection then
connection:Disconnect()
connection = nil
end
task.delay(5, function()
if Part and Part.Parent then
Part:Destroy()
end
end)
return
end
local AssemblyLinearVelocity = v13391.AssemblyLinearVelocity
if AssemblyLinearVelocity.Y < -2 then
v13391.AssemblyLinearVelocity =
Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z)
end
if v13391.Position.Y < 18 then
v13391.CFrame = CFrame.new(v13391.Position.X, 21, v13391.Position.Z)
v13391.AssemblyLinearVelocity = Vector3.zero
v13391.AssemblyAngularVelocity = Vector3.zero
end
end)
elseif Y > 8.9 and Y <= 23.15 then
local Y3 = vector3.Y
local v13394 = os.clock() + 2.5
_G.__SXE_Holding = true
local connection
connection = RunService4.Heartbeat:Connect(function()
if v13394 < os.clock() or LocalPlayer3:GetAttribute("Stealing") then
v13384()
if connection then
connection:Disconnect()
connection = nil
end
return
end
local v13396 = u13377 == t507
and LocalPlayer3.Character == Character
and Humanoid.Health > 0
and HumanoidRootPart
and HumanoidRootPart.Parent == Character
and HumanoidRootPart
or nil
if not v13396 then
v13384()
if connection then
connection:Disconnect()
connection = nil
end
return
end
local AssemblyLinearVelocity = v13396.AssemblyLinearVelocity
if AssemblyLinearVelocity.Y < -2 then
v13396.AssemblyLinearVelocity =
Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z)
end
if v13396.Position.Y < Y3 - 3 then
v13396.CFrame = CFrame.new(v13396.Position.X, Y3, v13396.Position.Z)
v13396.AssemblyLinearVelocity = Vector3.zero
v13396.AssemblyAngularVelocity = Vector3.zero
end
end)
end
end
_G.SXE_GoToBrainrot = function(p1866, p1867)
if typeof(p1866) ~= "Vector3" then
return false
end
if
_G.__SXE_TPStarted
or _G.__SXE_VelFlying
or _G.__SXE_Holding
or _G.isCloning
or _G.__SXE_ClickGoBusy
then
return false
end
local Character = LocalPlayer3.Character
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
if
not Humanoid
or Humanoid.Health <= 0
or not HumanoidRootPart
or HumanoidRootPart.Parent ~= Character
then
return false
end
local t508 = {}
_G.__SXE_ClickGoBusy = t508
_G.__SXE_TPStarted = t508
local ok, result = pcall(function()
if type(p1867) == "table" then
_G.SXE_ManualTarget = {
plot = p1867.plot,
slot = p1867.slot,
name = p1867.name,
}
if _G.SXE_ArmSteal then
pcall(_G.SXE_ArmSteal, p1867)
end
end
v13378(p1866)
end)
if _G.__SXE_ClickGoBusy == t508 then
_G.__SXE_ClickGoBusy = nil
end
if _G.__SXE_TPStarted == t508 then
_G.__SXE_TPStarted = nil
end
if not ok then
warn("[SXE] Go to brainrot: " .. tostring(result))
end
return ok
end
local function v13404()
local Players4 = game:GetService("Players")
local n1255 = 730826453
local RunService5 = game:GetService("RunService")
local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
local n1256 = 517276544
local Workspace2 = game:GetService("Workspace")
local LocalPlayer4 = Players4.LocalPlayer
local function v13412() end
local function v13413()
return ""
end
local t509 = {
1116352408,
1899447441,
3049323471,
3921009573,
961987163,
1508970993,
2453635748,
2870763221,
3624381080,
310598401,
607225278,
1426881987,
1925078388,
2162078206,
2614888103,
3248222580,
3835390401,
4022224774,
264347078,
604807628,
770255983,
1249150122,
1555081692,
1996064986,
2554220882,
2821834349,
2952996808,
3210313671,
3336571891,
3584528711,
113926993,
338241895,
666307205,
773529912,
1294757372,
1396182291,
1695183700,
1986661051,
2177026350,
2456956037,
2730485921,
2820302411,
3259730800,
3345764771,
3516065817,
3600352804,
4094571909,
275423344,
430227734,
506948616,
659060556,
883997877,
958139571,
1322822218,
1537002063,
1747873779,
1955562222,
2024104815,
2227730452,
2361852424,
2428436474,
2756734187,
3204031479,
3329325298,
}
local v13415 = table.create(64, 0)
local function v13416(p1868, p1869, p1870, p1871)
local v13417 = p1868[1]
local v13418 = p1868[2]
local v13419 = p1868[3]
local v13420 = p1868[4]
local v13421 = p1868[5]
local v13422 = p1868[6]
local v13423 = p1868[7]
local v13424 = p1868[8]
for i = p1870, p1871, 64 do
local v13426 = i
for i2 = 1, 16 do
local v13428, v13429, v13430, v13431 = string.byte(p1869, v13426, v13426 + 3)
v13415[i2] = bit32.bor(
bit32.lshift(v13428, 24),
bit32.lshift(v13429, 16),
bit32.lshift(v13430, 8),
v13431
)
v13426 += 4
end
for i2 = 17, 64 do
local v13433 = v13415[i2 - 2]
local v13434 = v13415[i2 - 15]
local v13435 =
bit32.bxor(bit32.rrotate(v13434, 7), bit32.rrotate(v13434, 18), bit32.rshift(v13434, 3))
v13415[i2] = bit32.bxor(
bit32.rrotate(v13433, 17),
bit32.rrotate(v13433, 19),
bit32.rshift(v13433, 10)
) + v13415[i2 - 7] + v13435 + v13415[i2 - 16]
end
local v13436 = v13417
local v13437 = v13418
local v13438 = v13419
local v13439 = v13420
local v13440 = v13421
local v13441 = v13422
local v13442 = v13423
local v13443 = v13424
for i2 = 1, 64 do
local bxor = bit32.bxor
local band = bit32.band
local v13447 = v13443
+ bit32.bxor(
bit32.rrotate(v13440, 6),
bit32.rrotate(v13440, 11),
bit32.rrotate(v13440, 25)
)
+ bxor(bit32.band(v13440, v13441), band(bit32.bnot(v13440), v13442))
+ t509[i2]
+ v13415[i2]
local bxor2 = bit32.bxor
local v13449 = bit32.bxor(
bit32.rrotate(v13436, 2),
bit32.rrotate(v13436, 13),
bit32.rrotate(v13436, 22)
) + bxor2(
bit32.band(v13436, v13437),
bit32.band(v13436, v13438),
bit32.band(v13437, v13438)
)
v13443 = v13442
v13442 = v13441
v13441 = v13440
v13440 = v13439 + v13447
v13439 = v13438
v13438 = v13437
v13437 = v13436
v13436 = v13447 + v13449
end
v13417 = bit32.bor(v13417 + v13436, 0)
v13418 = bit32.bor(v13418 + v13437, 0)
v13419 = bit32.bor(v13419 + v13438, 0)
v13420 = bit32.bor(v13420 + v13439, 0)
v13421 = bit32.bor(v13421 + v13440, 0)
v13422 = bit32.bor(v13422 + v13441, 0)
v13423 = bit32.bor(v13423 + v13442, 0)
v13424 = bit32.bor(v13424 + v13443, 0)
end
p1868[1] = v13417
p1868[2] = v13418
p1868[3] = v13419
p1868[4] = v13420
p1868[5] = v13421
p1868[6] = v13422
p1868[7] = v13423
p1868[8] = v13424
end
local function v13450(p1872)
local t510 = {
1779033703,
3144134277,
1013904242,
2773480762,
1359893119,
2600822924,
528734635,
1541459225,
}
local v13452 = #p1872
local v13453 = v13452 % 64
if v13452 >= 64 then
v13416(t510, p1872, 1, v13452 - v13453)
end
local v13454 = bit32.band(v13453 + 32, 4294967232)
local v13455 = table.concat({
v13453 == 0 and "" or string.sub(p1872, -v13453),
"\128",
string.rep("\0", (v13454 - v13453 - 9) % 64),
string.pack(">L", v13452 * 8),
})
v13416(t510, v13455, 1, #v13455)
local v13456 = table.create(8)
if 817353306 == n1 then
n1115 -= 1937
n2 += 1162
n1 = 918247749
n1256 -= 1919
u206 = 692556267
n1255 = 548529530
else
for i = 1, 8 do
v13456[i] = string.format("%08x", t510[i])
end
end
return table.concat(v13456)
end
local JobId = game.JobId
local t511 = {}
if n1255 == n2 then
n1256 = 419956765
n1082 += 758
n1255 = 676059093
n2 += 276
n1 = 258442852
n1116 -= 146
n1115 += 390
u206 += 1283
return
end
local function v13460(p1873, p1874)
if #JobId == 0 then
JobId = game.JobId
end
if #JobId == 0 then
return nil
end
local s55
if p1874 then
s55 = "RF/"
else
s55 = "RE/"
end
local v13462 = t511[s55 .. p1873]
if not v13462 then
local v13463 = table.create(#p1873)
local n1257 = 0
for i = 1, #p1873 do
local v13466 = string.byte(p1873, i)
if v13466 == 47 then
v13463[i] = "/"
else
v13463[i] =
string.char(32 + (v13466 - 32 + string.byte(JobId, n1257 % #JobId + 1) % 95) % 95)
n1257 += 1
end
end
local v13467 = "36bc48de-ccc6-4666-af4b-7d3bd46d6aa7" .. JobId
v13462 = s55 .. v13450(table.concat(v13463) .. v13467)
t511[s55 .. p1873] = v13462
end
local Packages = ReplicatedStorage2:FindFirstChild("Packages")
local Net = Packages and Packages:FindFirstChild("Net")
local v13470 = Net and Net:FindFirstChild(v13462)
if n2 ~= 557240548 then
n1082 += 19
u206 -= 1388
n1256 += 1821
n1255 = 507116184
n1 = 986417926
n2 += 548
local _
(nil)(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 325))
return (nil)()
end
local v13512 = v13470
if v13512 then
local v13513 = v13470
local IsA = v13470.IsA
local s56
if p1874 then
s56 = "RemoteFunction"
else
s56 = "RemoteEvent"
end
v13512 = IsA(v13513, s56)
end
return v13512 and v13470 or nil
end
local function v13516(p1875)
if typeof(p1875) == "Instance" then
return p1875.Name
end
if type(p1875) == "table" then
return tostring(p1875.Name or p1875.UserId)
end
return tostring(p1875)
end
local function v13517(p1876)
if not p1876.Slot then
return false
end
local XenSyncGet = _G.XenSyncGet and _G.XenSyncGet(p1876.Model.Name)
local v13519 = XenSyncGet and _G.sProp(XenSyncGet, "AnimalList")
local v13520 = type(v13519) == "table" and (v13519[p1876.Slot] or v13519[tostring(p1876.Slot)])
return type(v13520) == "table" and v13520.Steal ~= nil and v13520.Steal ~= false
end
local t512 = {
State = {
Enabled = false,
Active = false,
Name = "",
Started = 0,
HoldDuration = 1.3,
Status = "Idle",
GummyRemaining = 0,
RagdollRemaining = 0,
},
}
local n1258
local n1259
local function v13524()
n1258 = 209985815
n1259 = 206858595
local State = t512.State
local n1260 = 662954909
local u13527
local u13528 = tonumber(v12137 and v12137.AutoGrabRadius) or 125
State.MaxHold = 2.6
t512.SetRange = function(p1877)
local v13529 = tonumber(p1877)
local n1261 = 112157621
if v13529 then
if n1261 < n1115 then
u13528 = math.clamp(v13529, 10, 300)
else
n1260 += 867
n1 = 555760674
n1115 = 978948197
n1082 = 380858028
n1255 = 64039937
n2 += 271
local _
(nil)(table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil + nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
bit32.bxor(nil, nil),
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 354))
end
end
end
t512.GetRange = function()
return u13528
end
local obj4 = setmetatable({}, {
__mode = "k",
})
local function v13574(p1878)
return u13527 == p1878 and not p1878.Closed and true
end
local function v13575(p1879)
local v13576 = coroutine.running()
for _, callbackThread in ipairs(p1879.CallbackThreads) do
if callbackThread ~= v13576 and coroutine.status(callbackThread) ~= "dead" then
pcall(task.cancel, callbackThread)
end
end
table.clear(p1879.CallbackThreads)
end
local function v13579(p1880, p1881)
if p1880.Closed then
return
end
p1880.Closed = true
local n1262 = 462128956
for _, connection in ipairs(p1880.Connections) do
connection:Disconnect()
end
local v13583 = t23_14_1[1]
table.clear(p1880.Connections)
v13575(p1880)
p1880.Attempt = nil
local n1263 = 352532986
if u13527 == p1880 then
u13527 = nil
State.Enabled = false
State.Active = false
if n1255 < n1115 then
State.GummyRemaining = 0
State.RagdollRemaining = 0
else
n1263 += 1216
n1258 += 1704
n1260 = 656665583
n1262 += 1649
n1115 -= 1236
n1 += 242
n1255 -= 113
n2 = 74648100
upv121 = nil
upv121[v13583] = nil
end
State.Status = p1881
task.delay(2.5, function()
if u13527 == nil and State.Status == p1881 then
State.Status = "Idle"
end
end)
end
end
local function v13585(p1882, p1883, p1884)
local connection = p1883:Connect(p1884)
p1882.Connections[#p1882.Connections + 1] = connection
return connection
end
local function v13587(p1885)
local Parent = p1885 and p1885.Parent
if not Parent then
return nil
end
if Parent:IsA("Attachment") then
return Parent.WorldPosition
end
if Parent:IsA("BasePart") then
return Parent.Position
end
if Parent:IsA("Model") and Parent.PrimaryPart then
return Parent.PrimaryPart.Position
end
return nil
end
local function v13589(p1886)
local Base = p1886.PodiumModel:FindFirstChild("Base")
local v13591 = Base
local ProximityPrompt
if v13591 then
local Spawn = Base:FindFirstChild("Spawn")
local v13594 = Spawn
if v13594 then
local PromptAttachment = Spawn:FindFirstChild("PromptAttachment")
ProximityPrompt = PromptAttachment
and PromptAttachment:FindFirstChildWhichIsA("ProximityPrompt")
else
ProximityPrompt = v13594
end
else
ProximityPrompt = v13591
end
return ProximityPrompt
and (ProximityPrompt.ActionText == "Steal" or ProximityPrompt:GetAttribute("State") ~= nil)
and ProximityPrompt
or nil
end
local n1264
local function v13597(p1887)
local spilled = {
n1265 = 508358999,
}
n1264 = 603876535
spilled.Target = p1887.Target
do
if spilled.n1265 < n1082 then
return spilled.Target.Model:IsDescendantOf(Workspace2)
and spilled.Target.PodiumModel:IsDescendantOf(spilled.Target.Model)
and (
not p1887.Prompt
or v13589(spilled.Target) == p1887.Prompt
and (p1887.Prompt.ObjectText == p1887.PromptText or v13517(spilled.Target))
)
end
end
n1082 = 473198480
n1 += 730
n1258 += 1044
n2 -= 347
n1260 = 484079327
n1256 += 1877
n1264 -= 459
do
local _, _, _, _, _, _, _, _, _, _, _, _, _, _, v13613, v13614, v13615, v13616, v13617, v13618, v13619, v13620, v13621, v13622, v13623, v13624, v13625, v13626, v13627, v13628, v13629, v13630, v13631, v13632, v13633, v13634, v13635, v13636, v13637, v13638, v13639, v13640, v13641, v13642, v13643, v13644, v13645, v13646, v13647, v13648, v13649, v13650, v13651, v13652, v13653, v13654, v13655, v13656, v13657, v13658, v13659, v13660, v13661, v13662, v13663, v13664, v13665, v13666, v13667, v13668, v13669, v13670, v13671, v13672, v13673, v13674, v13675, v13676, v13677, v13678, v13679, v13680, v13681, v13682, v13683, v13684, v13685, v13686, v13687, v13688, v13689, v13690, v13691, v13692, v13693, v13694, v13695, v13696, v13697, v13698, v13699, v13700, v13701, v13702, v13703, v13704, v13705, v13706, v13707, v13708, v13709, v13710, v13711, v13712, v13713, v13714, v13715, v13716, v13717, v13718, v13719, v13720, v13721, v13722, v13723, v13724, v13725, v13726, v13727, v13728, v13729, v13730, v13731, v13732, v13733, v13734, v13735, v13736, v13737, v13738, v13739, v13740, v13741, v13742, v13743, v13744, v13745, v13746, v13747, v13748, v13749, v13750, v13751, v13752, v13753, v13754, v13755, v13756, v13757, v13758, v13759, v13760, v13761, v13762, v13763, v13764, v13765, v13766, v13767, v13768, v13769, v13770, v13771
(nil)()
return table.unpack({
v13613,
v13614,
v13615,
v13616,
v13617,
v13618,
v13619,
v13620,
v13621,
v13622,
v13623,
v13624,
v13625,
v13626,
v13627,
v13628,
v13629,
v13630,
v13631,
v13632,
v13633,
v13634,
v13635,
v13636,
v13637,
v13638,
v13639,
v13640,
v13641,
v13642,
v13643,
v13644,
v13645,
v13646,
v13647,
v13648,
v13649,
v13650,
v13651,
v13652,
v13653,
v13654,
v13655,
v13656,
v13657,
v13658,
v13659,
v13660,
v13661,
v13662,
v13663,
v13664,
v13665,
v13666,
v13667,
v13668,
v13669,
v13670,
v13671,
v13672,
v13673,
v13674,
v13675,
v13676,
v13677,
v13678,
v13679,
v13680,
v13681,
v13682,
v13683,
v13684,
v13685,
v13686,
v13687,
v13688,
v13689,
v13690,
v13691,
v13692,
v13693,
v13694,
v13695,
v13696,
v13697,
v13698,
v13699,
v13700,
v13701,
v13702,
v13703,
v13704,
v13705,
v13706,
v13707,
v13708,
v13709,
v13710,
v13711,
v13712,
v13713,
v13714,
v13715,
v13716,
v13717,
v13718,
v13719,
v13720,
v13721,
v13722,
v13723,
v13724,
v13725,
v13726,
v13727,
v13728,
v13729,
v13730,
v13731,
v13732,
v13733,
v13734,
v13735,
v13736,
v13737,
v13738,
v13739,
v13740,
v13741,
v13742,
v13743,
v13744,
v13745,
v13746,
v13747,
v13748,
v13749,
v13750,
v13751,
v13752,
v13753,
v13754,
v13755,
v13756,
v13757,
v13758,
v13759,
v13760,
v13761,
v13762,
v13763,
v13764,
v13765,
v13766,
v13767,
v13768,
v13769,
v13770,
v13771,
spilled.v13777,
spilled.v13778,
spilled.v13779,
spilled.v13780,
spilled.v13781,
spilled.v13782,
spilled.v13783,
spilled.v13784,
spilled.v13785,
spilled.v13786,
spilled.v13787,
spilled.v13788,
spilled.v13789,
spilled.v13790,
spilled.v13791,
spilled.v13792,
spilled.v13793,
spilled.v13794,
spilled.v13795,
spilled.v13796,
spilled.v13797,
spilled.v13798,
spilled.v13799,
spilled.v13800,
spilled.v13801,
spilled.v13802,
spilled.v13803,
spilled.v13804,
spilled.v13805,
spilled.v13806,
spilled.v13807,
spilled.v13808,
spilled.v13809,
spilled.v13810,
spilled.v13811,
spilled.v13812,
spilled.v13813,
spilled.v13814,
spilled.v13815,
spilled.v13816,
spilled.v13817,
spilled.v13818,
spilled.v13819,
spilled.v13820,
spilled.v13821,
spilled.v13822,
spilled.v13823,
spilled.v13824,
spilled.v13825,
spilled.v13826,
spilled.v13827,
spilled.v13828,
spilled.v13829,
spilled.v13830,
spilled.v13831,
spilled.v13832,
spilled.v13833,
spilled.v13834,
spilled.v13835,
spilled.v13836,
spilled.v13837,
spilled.v13838,
spilled.v13839,
spilled.v13840,
spilled.v13841,
spilled.v13842,
spilled.v13843,
spilled.v13844,
spilled.v13845,
spilled.v13846,
spilled.v13847,
spilled.v13848,
spilled.v13849,
spilled.v13850,
spilled.v13851,
spilled.v13852,
spilled.v13853,
spilled.v13854,
spilled.v13855,
spilled.v13856,
spilled.v13857,
spilled.v13858,
spilled.v13859,
spilled.v13860,
spilled.v13861,
spilled.v13862,
spilled.v13863,
spilled.v13864,
spilled.v13865,
spilled.v13866,
spilled.v13867,
spilled.v13868,
spilled.v13869,
spilled.v13870,
spilled.v13871,
spilled.v13872,
spilled.v13873,
spilled.v13874,
spilled.v13875,
spilled.v13876,
spilled.v13877,
spilled.v13878,
spilled.v13879,
spilled.v13880,
spilled.v13881,
spilled.v13882,
spilled.v13883,
spilled.v13884,
spilled.v13885,
spilled.v13886,
spilled.v13887,
spilled.v13888,
spilled.v13889,
spilled.v13890,
spilled.v13891,
spilled.v13892,
spilled.v13893,
spilled.v13894,
spilled.v13895,
spilled.v13896,
}, 1, 279)
end
end
local n1266
local n1267
local function v13897(p1888)
n1266 = 524355308
n1267 = 101650113
if not (LocalPlayer4.Character == p1888.Character and p1888.Character.Parent) then
return nil, nil, "Character changed"
end
local n1268 = 447783343
local Humanoid = p1888.Character:FindFirstChildOfClass("Humanoid")
local HumanoidRootPart = p1888.Character:FindFirstChild("HumanoidRootPart")
if
not Humanoid
or Humanoid.Health <= 0
or not HumanoidRootPart
or not HumanoidRootPart:IsA("BasePart")
then
return nil, nil, "Character unavailable"
end
if n1268 < n1115 then
p1888.LostSince = nil
else
n2 += 215
n1267 += 628
n1115 = 724057703
n1256 = 142828875
n1258 += 1601
n1259 = 77897520
n1260 -= 1115
n1266 -= 843
(nil)[nil] = nil
end
return HumanoidRootPart, Humanoid
end
local function v13898(p1889, p1890)
if p1890 == "Character changed" then
return true
end
p1889.LostSince = p1889.LostSince or os.clock()
State.Active = false
State.Status = "Waiting for character"
return os.clock() - p1889.LostSince > 3
end
local function v13899(p1891)
local gummyObserved = LocalPlayer4:GetAttribute("BlockTools") == true
if gummyObserved and not p1891.GummyObserved then
p1891.GummyUntil = os.clock() + 3.05
end
p1891.GummyObserved = gummyObserved
if n1255 == 730827893 then
n1259 += 1309
n1256 += 1620
n1115 -= 727
n1255 += 1127
n2 -= 1293
n1260 -= 1817
end
end
local function v13900(p1892)
local v13901 = tonumber(LocalPlayer4:GetAttribute("RagdollEndTime")) or 0
p1892.RagdollUntil = math.max(
p1892.RagdollUntil,
v13901,
type(getgenv) == "function" and tonumber(getgenv().SXERagdollUntil) or 0
)
end
local function v13902(p1893, p1894)
v13899(p1893)
v13900(p1893)
State.GummyRemaining = math.max(0, p1893.GummyUntil - os.clock())
State.RagdollRemaining = math.max(0, p1893.RagdollUntil - Workspace2:GetServerTimeNow())
if LocalPlayer4:GetAttribute("BlockTools") == true or State.GummyRemaining > 0 then
return "Gummy blocked"
end
if LocalPlayer4:GetAttribute("GiantPotion") ~= nil then
return nil
end
local state = p1894:GetState()
if
State.RagdollRemaining > 0
or LocalPlayer4:GetAttribute("Ragdoll") == true
or state == Enum.HumanoidStateType.Physics
or state == Enum.HumanoidStateType.Ragdoll
or state == Enum.HumanoidStateType.FallingDown
then
return "Ragdolled"
end
for k in pairs(p1893.AnimationConstraints) do
if k.Parent and (not k.Enabled or k.MaxTorque == 0) then
return "Ragdolled"
end
end
return nil
end
local function v13903(p1895, p1896)
local StealHitbox = p1895.Model:FindFirstChild("StealHitbox")
if not StealHitbox or not StealHitbox:IsA("BasePart") then
return true
end
local v13904 = StealHitbox.CFrame:PointToObjectSpace(p1896)
local v13905 = StealHitbox.Size * 0.5
return math.abs(v13904.X) <= v13905.X
and math.abs(v13904.Y) <= v13905.Y
and math.abs(v13904.Z) <= v13905.Z
end
local function v13906(p1897, p1898)
if not v13574(p1897) or not v13597(p1897) or v13589(p1897.Target) ~= p1898 then
return false
end
local v13907 = v13897(p1897)
local v13908 = v13587(p1898)
return v13907 ~= nil and v13908 ~= nil and (v13907.Position - v13908).Magnitude <= u13528
end
local function v13909(p1899, p1900)
if not v13574(p1899) or not v13597(p1899) or v13589(p1899.Target) ~= p1900.Prompt then
return false
end
local v13910, v13911 = v13897(p1899)
local v13912 = v13587(p1900.Prompt)
local v13913 = v13910 ~= nil
and v13912 ~= nil
and ((v13912 - v13910.Position) * Vector3.new(1, 0, 1)).Magnitude <= 4
and v13912.Y - v13910.Position.Y >= 0
and v13912.Y - v13910.Position.Y <= 16
if
not v13910
or not v13912
or not v13913
and ((v13910.Position - v13912).Magnitude > 10 or not v13903(
p1899.Target,
v13910.Position
))
then
p1900.SkipDwell = false
p1900.ReadySince = nil
return false
end
if p1900.FlashDestination then
if p1900.FlashExpires < os.clock() then
p1900.FlashDestination = nil
else
local v13914 = v13910.Position
- Vector3.new(0, v13911.HipHeight + v13910.Size.Y * 0.5, 0)
if
(v13910.Position - p1900.FlashDestination).Magnitude <= 0.5
or (v13914 - p1900.FlashDestination).Magnitude <= 0.5
then
p1900.SkipDwell = true
p1900.FlashDestination = nil
end
end
end
return true
end
local n1269
local function v13915(p1901)
n1269 = 789096294
if obj4[p1901] then
return obj4[p1901]
end
local n1270 = 619263349
if type(getconnections) ~= "function" then
return nil, "getconnections unavailable"
end
local t513 = {
Hold = {},
Trigger = {},
}
for _, v in ipairs({
{
p1901.PromptButtonHoldBegan,
t513.Hold,
},
{
p1901.Triggered,
t513.Trigger,
},
}) do
local ok, result = pcall(getconnections, v[1])
if ok and type(result) == "table" then
for _, v2 in ipairs(result) do
local ok2, result2 = pcall(function()
if n1 ~= n1269 then
return v2.Function
end
n1270 -= 95
n2 += 1926
n1 = 981232865
n1258 = 501639021
n1269 = 101780448
n1256 = 665114152
LPH_CRASH()
end)
if ok2 and type(result2) == "function" then
v[2][#v[2] + 1] = result2
end
end
end
end
if #t513.Trigger == 0 then
return nil, "Steal callbacks unavailable"
end
obj4[p1901] = t513
return t513
end
local function v13916(p1902, p1903)
if not v13574(p1902) or p1902.Attempt ~= p1903 then
return false
end
local n1271 = 448304535
local v13917 = os.clock() - p1903.Started
if v13917 < 1.3 or v13917 > 2.6 or not v13909(p1902, p1903) then
return false
end
local _, v13919 = v13897(p1902)
if n1 < n1271 then
return v13919 ~= nil and v13902(p1902, v13919) == nil
end
n1082 = 41516793
n1258 += 1853
n1260 -= 1322
n1 = 948459232
n2 = 198042525
n1259 = 96945298
end
local function v13920(p1904, p1905, p1906, p1907)
local thread = coroutine.create(function()
if not v13574(p1904) or p1904.Attempt ~= p1905 then
return
end
if p1907 then
if not v13916(p1904, p1905) then
return
end
p1904.Triggered = true
p1905.Fired = true
end
local ok, result = pcall(p1906)
if not ok and v13574(p1904) and p1904.Attempt == p1905 then
p1905.CallbackError = tostring(result)
end
end)
p1904.CallbackThreads[#p1904.CallbackThreads + 1] = thread
task.spawn(thread)
end
local u13921
local function v13922()
if u13921 ~= nil then
return u13921
end
local t514 = {
Remote = "f1a4d3a5-b97a-4622-8fd6-232663ff697e",
Offset = 50,
Codes = {
"ba10cc43-8b93-4b7d-93b8-e1935730ebe3",
"ed327974-0c39-423a-b9c7-467b8fdac46d",
},
}
pcall(function()
if type(decompile) ~= "function" then
return
end
local Classes = ReplicatedStorage2:FindFirstChild("Classes")
local PlotClient = Classes and Classes:FindFirstChild("PlotClient")
local AnimalPrompt = PlotClient and PlotClient:FindFirstChild("AnimalPrompt")
if not AnimalPrompt then
return
end
local v13923 = decompile(AnimalPrompt)
if type(v13923) ~= "string" then
return
end
local v13924 = string.match(v13923, 'RemoteEvent%(%s*"([%x%-]+)"%s*%)')
local v13925
local t515 = {}
for match, match2 in
string.gmatch(v13923, 'GetServerTimeNow%(%)%s*%+%s*(%d+)%s*,%s*"([%x%-]+)"')
do
v13925 = tonumber(match)
t515[#t515 + 1] = match2
end
if v13924 and v13925 and #t515 >= 2 then
t514 = {
Remote = v13924,
Offset = v13925,
Codes = {
t515[1],
t515[2],
},
}
end
end)
u13921 = t514
v13412("AutoGrab steal codes", t514.Remote, t514.Offset)
return t514
end
local function v13926(p1908)
local attribute = p1908:GetAttribute("State")
if attribute == nil or attribute == "Steal" then
return false
end
local v13927 = v13922()
local v13928 = v13460(v13927.Remote)
if not v13928 then
return false
end
local v13929 = Workspace2:GetServerTimeNow() + v13927.Offset
for _, v in v13927.Codes, nil, nil do
pcall(v13928.FireServer, v13928, v13929, v)
end
return true
end
local function v13930(p1909)
local v13931
while v13574(p1909) do
local _, v13933, v13934 = v13897(p1909)
if not v13933 then
if v13898(p1909, v13934) then
v13579(p1909, v13934)
return
end
task.wait(0.1)
continue
end
local attribute = LocalPlayer4:GetAttribute("Stealing")
or p1909.Character:GetAttribute("Stealing")
if attribute ~= nil and attribute ~= false then
v13579(p1909, "Carrying a brainrot")
return
end
p1909.Confirmed = false
p1909.Triggered = false
if not v13597(p1909) then
v13575(p1909)
p1909.Attempt = nil
p1909.Prompt = nil
p1909.PromptText = nil
State.Active = false
State.Status = "Waiting for target"
v13902(p1909, v13933)
task.wait(0.25)
continue
end
local v13935 = v13589(p1909.Target)
if not v13935 then
State.Active = false
State.Status = "Waiting for steal prompt"
v13902(p1909, v13933)
task.wait(0.25)
continue
end
local v13936, v13937 = v13915(v13935)
if not v13936 then
State.Active = false
State.Status = v13937
v13902(p1909, v13933)
if type(getconnections) == "function" then
task.wait(0.25)
continue
end
v13579(p1909, v13937)
return
end
p1909.Prompt = p1909.Prompt or v13935
p1909.PromptText = p1909.PromptText or v13935.ObjectText
State.Name = v13935.ObjectText ~= "" and v13935.ObjectText or p1909.Target.Name
if not v13906(p1909, v13935) then
State.Active = false
State.Status = "Waiting for target range"
v13902(p1909, v13933)
task.wait(0.05)
continue
end
local attempt = {
Prompt = v13935,
Started = os.clock(),
ReadySince = nil,
SkipDwell = false,
Fired = false,
}
p1909.Attempt = attempt
local Started = attempt.Started
State.Active = true
State.Started = Started
State.Status = "Holding"
attempt.SkipDwell = v13909(p1909, attempt)
for _, v in ipairs(v13936.Hold) do
v13920(p1909, attempt, v, false)
end
if v13926(v13935) then
v13412("AutoGrab pre-hold", State.Name)
end
local exitTo
while true do
if not v13574(p1909) or not (os.clock() - attempt.Started <= 2.6) then
exitTo = 1
break
end
local v13938, v13939
v13938, v13939, v13931 = v13897(p1909)
if not v13939 then
if v13898(p1909, v13931) then
exitTo = 3
break
end
task.wait(0.05)
continue
end
if p1909.Confirmed or not v13597(p1909) or v13589(p1909.Target) ~= v13935 then
exitTo = 1
break
end
local attribute2 = LocalPlayer4:GetAttribute("Stealing")
or p1909.Character:GetAttribute("Stealing")
if attribute2 ~= nil and attribute2 ~= false then
exitTo = 1
break
end
local v13940 = v13902(p1909, v13939)
if not v13906(p1909, v13935) then
exitTo = 1
break
end
local v13941 = v13909(p1909, attempt)
local now5 = os.clock()
if v13941 then
attempt.ReadySince = attempt.ReadySince or now5
else
attempt.ReadySince = nil
end
State.Status = v13940
or not v13941 and "Waiting for target range"
or v13517(p1909.Target) and "Someone is carrying it, holding"
or "Holding"
if attempt.CallbackError then
exitTo = 2
break
elseif
v13940
or not v13941
or not (now5 - attempt.Started >= 1.3)
or not attempt.SkipDwell and not (now5 - attempt.ReadySince >= 0.3)
then
task.wait(0.03)
continue
end
break
end
if exitTo ~= 1 then
if exitTo == 2 then
State.Status = "Steal callback failed: " .. attempt.CallbackError
else
if exitTo == 3 then
v13579(p1909, v13931)
return
end
for _, v in ipairs(v13936.Trigger) do
v13920(p1909, attempt, v, true)
end
end
end
if not v13574(p1909) then
return
end
if attempt.Fired then
local v13942 = os.clock() + 0.15
local exitTo2
while true do
local attribute2 = LocalPlayer4:GetAttribute("Stealing")
or p1909.Character:GetAttribute("Stealing")
if p1909.Confirmed or attribute2 ~= nil and attribute2 ~= false then
break
end
local v13943 = false
for _, callbackThread in ipairs(p1909.CallbackThreads) do
if coroutine.status(callbackThread) ~= "dead" then
v13943 = true
break
end
end
if not v13943 then
exitTo2 = 1
break
end
RunService5.Heartbeat:Wait()
if not v13574(p1909) then
exitTo2 = 2
break
end
if not (v13942 <= os.clock()) then
continue
end
exitTo2 = 1
break
end
if exitTo2 ~= 1 then
if exitTo2 == 2 then
return
end
v13579(p1909, "Grabbed " .. State.Name)
return
end
end
local v13944 = v13587(v13935)
local HumanoidRootPart = p1909.Character:FindFirstChild("HumanoidRootPart")
v13412(
"AutoGrab retry",
State.Name,
"fired=" .. tostring(attempt.Fired),
"held=" .. os.clock() - attempt.Started,
"promptGap="
.. tostring(
v13944 and HumanoidRootPart and (v13944 - HumanoidRootPart.Position).Magnitude
),
"holdDuration=" .. v13935.HoldDuration,
"error=" .. tostring(attempt.CallbackError),
v13413()
)
v13575(p1909)
p1909.Attempt = nil
State.Active = false
State.Status = attempt.CallbackError and "Steal callback failed: " .. attempt.CallbackError
or "Retrying grab"
RunService5.Heartbeat:Wait()
end
v13579(p1909, "Stopped")
end
t512.Stop = function()
if u13527 then
v13579(u13527, "Stopped")
end
end
t512.Target = function()
local Target
if u13527 and not u13527.Closed then
Target = u13527.Target
else
Target = nil
end
return Target
end
local n1272
local n1273
t512.Start = function(p1910)
n1272 = 423843240
n1273 = 546408799
if
u13527
and v13574(u13527)
and u13527.Character == LocalPlayer4.Character
and u13527.Target.PodiumModel == p1910.PodiumModel
then
u13527.Target = p1910
return
end
t512.Stop()
State.Name = p1910.Name
State.Started = os.clock()
State.HoldDuration = 1.3
State.GummyRemaining = 0
State.RagdollRemaining = 0
State.Enabled = false
State.Active = false
State.Status = "Target unavailable"
if not p1910.Model or not p1910.PodiumModel then
return
end
if p1910.Owner == LocalPlayer4.Name then
State.Status = "Cannot steal own target"
return
end
local Character = LocalPlayer4.Character
if not Character then
State.Status = "Character unavailable"
return
end
local t516 = {
Target = p1910,
Character = Character,
Connections = {},
CallbackThreads = {},
AnimationConstraints = {},
Closed = false,
Confirmed = false,
Triggered = false,
GummyObserved = false,
GummyUntil = 0,
RagdollUntil = 0,
}
if n1258 < n1272 then
u13527 = t516
else
n1258 += 952
n1082 += 1616
n1273 -= 1602
n1272 += 1393
n1259 += 650
n1 = 135791407
n2 -= 1524
n1260 -= 1668
end
State.Enabled = true
State.Status = "Waiting for steal prompt"
local ok, result = pcall(function()
local function v13945(p1911)
if p1911.ClassName == "AnimationConstraint" then
t516.AnimationConstraints[p1911] = true
end
end
for _, descendant in ipairs(Character:GetDescendants()) do
v13945(descendant)
end
v13585(t516, Character.DescendantAdded, v13945)
v13585(t516, Character.DescendantRemoving, function(p1912)
t516.AnimationConstraints[p1912] = nil
end)
v13585(t516, LocalPlayer4:GetAttributeChangedSignal("BlockTools"), function()
if v13574(t516) then
v13899(t516)
end
end)
v13585(t516, LocalPlayer4:GetAttributeChangedSignal("RagdollEndTime"), function()
if v13574(t516) then
v13900(t516)
end
end)
v13899(t516)
v13900(t516)
local attribute = LocalPlayer4:GetAttribute("Stealing")
v13585(t516, LocalPlayer4:GetAttributeChangedSignal("Stealing"), function()
local attribute2 = LocalPlayer4:GetAttribute("Stealing")
if v13574(t516) and LocalPlayer4.Character == Character then
if attribute2 == nil or attribute2 == false then
t516.Confirmed = false
t516.Triggered = false
elseif t516.Triggered and attribute2 ~= attribute then
t516.Confirmed = true
end
end
attribute = attribute2
end)
v13585(t516, LocalPlayer4.CharacterRemoving, function(p1913)
if p1913 == Character then
v13579(t516, "Character changed")
end
end)
v13585(t516, Players4.PlayerRemoving, function(p1914)
local Attempt = t516.Attempt
if v13574(t516) and p1914.Name == p1910.Owner and Attempt and v13909(t516, Attempt) then
Attempt.SkipDwell = true
end
end)
local Effects = v13460("Tools/Flash/Effects")
if Effects then
v13585(t516, Effects.OnClientEvent, function(p1915, p1916, p1917)
local Attempt = t516.Attempt
if
not v13574(t516)
or LocalPlayer4.Character ~= Character
or p1915 ~= LocalPlayer4
or not Attempt
or typeof(p1916) ~= "CFrame"
or typeof(p1917) ~= "CFrame"
or (p1917.Position - p1916.Position).Magnitude <= 0.5
then
return
end
local Position = p1917.Position
local flashExpires = os.clock() + 0.3
Attempt.FlashDestination = Position
Attempt.FlashExpires = flashExpires
v13909(t516, Attempt)
end)
end
end)
if not ok then
v13579(t516, "Auto grab unavailable: " .. tostring(result))
return
end
task.spawn(function()
local ok2, result2 = pcall(v13930, t516)
if not ok2 then
v13579(t516, "Auto grab failed: " .. tostring(result2))
end
end)
end
end
v13524()
local function v13946(p1918)
if type(p1918) ~= "table" or p1918.plot == nil or p1918.slot == nil then
return nil
end
local Plots = Workspace2:FindFirstChild("Plots")
if Plots then
local v13947 = Plots:FindFirstChild(tostring(p1918.plot))
local AnimalPodiums = v13947 and v13947:FindFirstChild("AnimalPodiums")
if AnimalPodiums then
local v13948 = AnimalPodiums:FindFirstChild(tostring(p1918.slot))
if v13948 then
local XenSyncGet = _G.XenSyncGet and _G.XenSyncGet(v13947.Name)
return {
Name = tostring(p1918.name or p1918.index or v13948.Name),
Podium = v13948:GetPivot().Position,
PodiumModel = v13948,
Owner = v13516(XenSyncGet and _G.sProp(XenSyncGet, "Owner")),
Model = v13947,
Slot = tonumber(p1918.slot),
}
end
end
end
return nil
end
local function v13949(p1919)
return tostring(p1919.plot) .. "|" .. tostring(p1919.slot)
end
local u13950
local n1274 = 0
local u13951
local u13952
local n1275 = 0
local function sxeArmSteal(p1920)
if type(p1920) ~= "table" then
return
end
u13950 = p1920
u13951 = v13949(p1920)
local v13953 = v13946(p1920)
if v13953 then
n1275 = os.clock()
t512.State.Enabled = true
t512.Start(v13953)
end
end
local n1276
RunService5.Heartbeat:Connect(function()
n1276 = 897851209
local now5 = os.clock()
if v12137.AutoStealEnabled == false then
return
end
if LocalPlayer4:GetAttribute("Stealing") then
return
end
if
(not u13950 or u13951 ~= nil and u13951 ~= u13952 or now5 - n1274 >= 1.5)
and now5 - n1274 >= 0.05
then
n1274 = now5
local ok, result = pcall(sxeScanPets)
if ok and type(result) == "table" and #result > 0 then
local v13954
if u13951 then
local v13955, v13956, v13957 = ipairs(result)
local v13958 = geniter(v13955, v13956, v13957)
while true do
local v13959 = table.pack(v13958())
if not v13959[1] then
break
end
local v13960 = v13959[3]
if not v13960.conveyor and v13949(v13960) == u13951 then
v13954 = v13960
break
end
end
end
if not v13954 then
local v13961, v13962, v13963 = ipairs(result)
for _, v in v13961, v13962, v13963 do
if not v.conveyor then
v13954 = v
break
end
end
end
u13950 = v13954 or result[1]
u13952 = u13951
end
end
if not u13950 then
return
end
local v13964 = t512.Target()
local Name, n1277, n1278, v13965
if v13964 then
Name = v13964.Model.Name
while true do
if Name == tostring(u13950.plot) and tostring(v13964.Slot) == tostring(u13950.slot) then
return
end
n1277 = 961681612
if now5 - n1275 < 0.25 then
break
end
n1275 = now5
n1278 = 453430860
v13965 = v13946(u13950)
if not v13965 then
return
end
if n1 ~= 104593839 then
t512.State.Enabled = true
t512.Start(v13965)
return
end
n1 = 884072409
Name = n1277 + 1641
u206 += 497
n1116 = 249632760
n1276 -= 864
n1256 -= 1105
n2 = 1018500139
n1255 = 258158049
if not (nil < nil) then
t512.Start(v13965)
return
end
end
else
n1277 = 961681612
if not (now5 - n1275 < 0.25) then
n1275 = now5
n1278 = 453430860
v13965 = v13946(u13950)
if not v13965 then
return
end
if n1 ~= 104593839 then
t512.State.Enabled = true
t512.Start(v13965)
return
end
n1 = 884072409
Name = n1277 + 1641
u206 += 497
n1116 = 249632760
n1276 -= 864
n1256 -= 1105
n2 = 1018500139
n1255 = 258158049
if not (nil < nil) then
t512.Start(v13965)
return
end
while Name ~= tostring(u13950.plot) or tostring(v13964.Slot) ~= tostring(u13950.slot) do
n1277 = 961681612
if now5 - n1275 < 0.25 then
return
end
n1275 = now5
n1278 = 453430860
v13965 = v13946(u13950)
if not v13965 then
return
end
if n1 ~= 104593839 then
t512.State.Enabled = true
t512.Start(v13965)
return
end
n1 = 884072409
Name = n1277 + 1641
u206 += 497
n1116 = 249632760
n1276 -= 864
n1256 -= 1105
n2 = 1018500139
n1255 = 258158049
if not (nil < nil) then
t512.Start(v13965)
return
end
end
return
end
end
end)
_G.SXE_ArmSteal = sxeArmSteal
_G.SXE_DisarmSteal = function()
u13950 = nil
u13951 = nil
t512.Stop()
if n1082 ~= 1052677094 then
return
end
n1082 += 1935
u206 += 140
n1116 += 84
n2 = 319504717
n1256 = 338475059
n1255 = 59539518
(nil)()
end
_G.SXE_TPApi = {
State = t512.State,
Stop = function()
t512.Stop()
end,
}
local function v13966(p1921)
if type(p1921) ~= "table" or #p1921 == 0 then
return nil
end
if n1256 < n1255 then
return p1921[1]
end
n2 = 9484491
u206 = 153070355
n1256 -= 746
n1255 += 797
n1115 -= 481
n1 = 477669059
return (nil)()
end
local function v13967(p1922)
if p1922 then
pcall(_G.SXE_LockPrioPlot, p1922)
end
if not (n1 < 998361414) then
n2 -= 1724
n1255 -= 1662
n1256 -= 2048
n1115 -= 470
n1 += 866
u206 = 31268703
(nil)(nil, nil);
(nil)()
end
end
return v13966, sxeArmSteal, v13967
end
local v13968, v13969, v13970 = v13404()
local function v13971(...)
local v13972 = ...
if u12138 and os.clock() - now3 < 30 then
return
end
u12138 = true
_G.__SXE_TPStarted = true
now3 = os.clock()
local Character = LocalPlayer3.Character
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
local n1279 = 681121527
if not HumanoidRootPart or not Humanoid then
u12138 = false
_G.__SXE_TPStarted = nil
return
end
local t517
if type(v13972) == "table" and (v13972.plot or v13972.name or v13972.index) then
t517 = { v13972 }
elseif type(v13972) == "table" and #v13972 > 0 then
t517 = v13972
else
t517 = sxeScanPets()
if #t517 == 0 then
local now5 = os.clock()
while #t517 == 0 and os.clock() - now5 < 2 do
task.wait(0.1)
t517 = sxeScanPets()
end
end
end
if #t517 == 0 then
u12138 = false
return
end
local v13973 = v13968(t517) or t517[1]
v13969(v13973)
pcall(sxeEnsurePetPos, v13973)
local position = v13973.position or v13973.plotHint
if not position then
local now5 = os.clock()
repeat
RunService4.Heartbeat:Wait()
pcall(sxeEnsurePetPos, v13973)
position = v13973.position or v13973.plotHint
if not position then
for i = 1, #t517 do
local v13974 = t517[i]
pcall(sxeEnsurePetPos, v13974)
local position2 = v13974.position or v13974.plotHint
if position2 then
v13973 = v13974
position = position2
v13969(v13973)
break
end
end
end
until position or os.clock() - now5 > 2
end
local v13975 = _G.D3GovClamp(v12137 and v12137.TpSettings and v12137.TpSettings.GrabbleTPSpeed)
local name = v13973.name
if not position then
u12138 = false
_G.__SXE_TPStarted = nil
return
end
if position.Y <= 8.9 and v12495(v13973.plot) then
pcall(_G.SXE_EquipCarpet)
local vector3 = Vector3.new(position.X, v13366, position.Z)
local _, v13977 = v13368(v13367(position), false, HumanoidRootPart.Position.Z)
v13970(v13973.plot)
_G.__SXE_VelFlying = true
local t518 = {
lowArrival = true,
facingDir = v13977,
}
local v13978 = v13373(HumanoidRootPart.Position, vector3, v13977, nil, t518)
if not v13978 or #v13978 == 0 then
warn("[SXE] No clear first-floor path; flying straight there.")
v13978 = { vector3 }
end
if not v13372(HumanoidRootPart, v13978, v13975, t518) then
return false
end
if HumanoidRootPart.Parent then
HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
end
u12138 = false
return
end
pcall(_G.SXE_EquipCarpet)
local v13979, v13980 = v13369(HumanoidRootPart.Position, position, name)
local v13981 = v13980 and math.abs(v13980.Z) > math.abs(v13980.X)
if v13980 and v13980.Magnitude > 0.1 and not v13981 then
v13979 = v13370(v13979, v13980)
end
v13970(v13973.plot)
_G.__SXE_VelFlying = true
local t519 = {
lowArrival = position.Y <= 8.9,
facingDir = v13980,
}
local v13982 = v13373(HumanoidRootPart.Position, v13979, v13980, nil, t519)
if not v13982 or #v13982 == 0 then
warn("[SXE] No clear path; flying straight there.")
v13982 = { v13979 }
end
if not v13372(HumanoidRootPart, v13982, v13975, t519) then
return false
end
local vector3 = Vector3.new(0, 0, -1)
if v13980 and v13980.Magnitude > 0.1 then
local vector32 = Vector3.new(v13980.X, 0, v13980.Z)
if vector32.Magnitude < 0.1 then
vector3 = Vector3.new(0, 0, -1)
else
vector3 = vector32.Unit
end
end
if not v13981 then
local v13983, v13984 = v13370(v13979, v13980)
local n1280 = 0.45
if string.find(string.lower(v13984 or ""), "laser", 1, true) then
n1280 = 0
end
v13979 = v13983 + vector3 * n1280
end
HumanoidRootPart.Anchored = false
local n1281 = 996011148
local n1282
local function v13985()
n1282 = 574040399
if vector3.Magnitude > 0.1 and HumanoidRootPart and HumanoidRootPart.Parent then
HumanoidRootPart.CFrame =
CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + vector3)
end
end
v13985()
v13371(HumanoidRootPart)
local v13986 = v12664(HumanoidRootPart, v13979)
v13969(v13973)
local v13987 = tonumber(v12137 and v12137.TpSettings and v12137.TpSettings.CloneDelayVal) or 0.27
if v13987 > 0 then
task.wait(v13987)
end
local Character2 = LocalPlayer3.Character
local HumanoidRootPart2 = Character2 and Character2:FindFirstChild("HumanoidRootPart")
local Position = HumanoidRootPart2 and HumanoidRootPart2.Parent and HumanoidRootPart2.Position or v13979
local u13988 = false
local connection = LocalPlayer3.CharacterAdded:Connect(function()
u13988 = true
end)
local v13989 = v13374()
if v13986 then
pcall(v13986, false)
end
if v13989 then
local now5 = os.clock()
while not u13988 and LocalPlayer3.Character == Character2 do
local HumanoidRootPart3 = LocalPlayer3.Character
and LocalPlayer3.Character:FindFirstChild("HumanoidRootPart")
if not (n1116 < n1115) then
n1281 = 567695648
u207 = 601235440
n1115 -= 687
n1082 -= 1262
u206 += 635
n1116 -= 1953
n2 = 731122743
n1279 += 851
n1279 = select(5, ...)
vector3 = select(16, ...)
n1281 = select(18, ...)
n1282 = select(19, ...)
u13988 = select(26, ...)
upv34[nil] = select(361, ...)
end
if HumanoidRootPart3 then
local v13990 = HumanoidRootPart3.Position.X - Position.X
local v13991 = HumanoidRootPart3.Position.Z - Position.Z
if v13990 * v13990 + v13991 * v13991 > 4 then
break
end
end
RunService4.Heartbeat:Wait()
if os.clock() - now5 > 3 then
break
end
end
end
connection:Disconnect()
if v13989 then
_G.isCloning = false
v13378(position)
end
end
_G.SXE_DoVelocityTP = function(p1923)
pcall(v13971, p1923)
u12138 = false
_G.__SXE_TPStarted = nil
_G.__SXE_VelFlying = false
task.delay(1.2, function()
if not _G.__SXE_VelFlying and not _G.__SXE_TPStarted then
pcall(_G.SXE_FlushKills)
end
end)
end
_G.SXE_StealNearestPrio = function()
local Character = LocalPlayer3.Character
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
if not HumanoidRootPart then
return
end
local Position = HumanoidRootPart.Position
local t520 = {}
local v13992
local huge = math.huge
local XenSyncAll = _G.XenSyncAll and _G.XenSyncAll()
if type(XenSyncAll) ~= "table" then
return
end
for k, v in next, XenSyncAll, nil do
if _G.SXE_IsPlotChanKey and _G.SXE_IsPlotChanKey(k) and v and not sxeIsMyPlot(v) then
local animalList = v12486(v, "AnimalList")
if type(animalList) == "table" then
local t521 = {}
for k2, v2 in pairs(animalList) do
if type(v2) == "table" then
local Index = v2.Index
if type(Index) == "string" and t474[string.lower(Index)] and not v12534(v2) then
local v13993 = v12549(v2)
local v13994 = string.lower(Index)
local v13995 = t521[v13994]
if not v13995 or v12551(v13993) < v12551(v13995.mutation) then
t521[v13994] = {
name = Index,
index = Index,
mutation = v13993,
plot = tostring(k),
slot = tostring(k2),
}
end
end
end
end
for _, v2 in pairs(t521) do
sxeEnsurePetPos(v2)
local position = v2.position or v2.plotHint
if position then
t520[#t520 + 1] = {
pet = v2,
pos = position,
}
local Magnitude = (position - Position).Magnitude
if Magnitude < huge then
huge = Magnitude
v13992 = v2
end
end
end
end
end
end
if not v13992 then
return
end
u12140 = t520
u12141 = Position
v13969(v13992)
pcall(_G.SXE_LockPrioPlot, v13992.plot);
(nil)(true)
end
task.spawn(function()
task.wait()
local TpSettings = v12137 and v12137.TpSettings
if not TpSettings or TpSettings.TpOnLoad ~= true then
return
end
if (tonumber(TpSettings.TpOnLoadDelay) or 0) > 0 then
task.wait(tonumber(TpSettings.TpOnLoadDelay))
end
local now5 = os.clock()
while true do
if not (os.clock() - now5 < 12) then
return
end
if _G.__SXE_TPStarted or _G.__SXE_VelFlying then
break
end
local ok, result = pcall(_G.SXE_ScanPets)
if ok and type(result) == "table" and #result > 0 then
local Character = LocalPlayer2.Character
if Character and Character:FindFirstChild("HumanoidRootPart") and _G.SXE_DoVelocityTP then
pcall(_G.SXE_DoVelocityTP, result)
return
end
end
RunService3.Heartbeat:Wait()
end
end)
local n1283
local LocalPlayer4 = game:GetService("Players").LocalPlayer
local u14007 = false
local u14008
local n1284 = 0
local u14010 = LocalPlayer4:GetAttribute("Stealing") == true
LocalPlayer4:GetAttributeChangedSignal("Stealing"):Connect(function()
u14010 = LocalPlayer4:GetAttribute("Stealing") == true
end)
local function v14011()
if n1115 == 1024338788 then
return _G.__SXE_VelFlying or _G.__SXE_TPStarted or _G.isCloning or u14010 or _G.__SXE_Holding
end
n1116 = 558012576
n2 = 781976579
n4 = 495294779
n1115 += 702
u207 += 910
u206 += 1038
return nil
end
RunService3.PreSimulation:Connect(function()
n1283 = 618527083
local n1285 = 210437794
if not v14011() then
if u14007 then
u14007 = false
local v14013 = u14008
if v14013 and v14013.Parent then
if n1285 == 210438251 then
u207 = 989676773
n1082 += 1466
n4 -= 1544
n2 += 401
n1116 = 464472867
n1283 += 1335
n1115 += 472
upv73[nil] = nil
else
pcall(function()
v14013:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
v14013:SetStateEnabled(
Enum.HumanoidStateType.Ragdoll,
_G.AntiRagdollEnabled ~= true
)
v14013:SetStateEnabled(
Enum.HumanoidStateType.FallingDown,
_G.AntiRagdollEnabled ~= true
)
end)
end
end
u14008 = nil
end
return
end
n1284 += 1
local Humanoid = u14008
if not Humanoid or not Humanoid.Parent then
local Character = LocalPlayer4.Character
Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
if not Humanoid then
return
end
u14008 = Humanoid
end
if not u14007 then
u14007 = true
pcall(function()
Humanoid.BreakJointsOnDeath = false
Humanoid.RequiresNeck = false
Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
end)
end
if n1284 % 3 ~= 0 then
return
end
if Humanoid.Health < Humanoid.MaxHealth then
Humanoid.Health = Humanoid.MaxHealth
end
end)
LocalPlayer4.CharacterAdded:Connect(function()
u14007 = false
u14008 = nil
if not (n1115 < n1082) then
n1 += 1380
n1116 += 1842
n1082 += 193
n1115 = 505593761
u207 = 957516778
n2 = 929928331
upv450[nil] = nil
upv450[216] = nil
end
end)
end
task.spawn(function()
local n1286 = 998702030
local Players3 = game:GetService("Players")
local LocalPlayer2 = Players3.LocalPlayer or Players3.PlayerAdded:Wait()
if not LocalPlayer2.Character then
LocalPlayer2.CharacterAdded:Wait()
end
if not workspace:FindFirstChild("Plots") then
workspace:WaitForChild("Plots", 10)
end
if rawget(_G, "__SXE_OptiOn") == true then
local now3 = os.clock()
while not _G.__SXE_StripDone and os.clock() - now3 < 15 do
task.wait(0.05)
end
end
local n1287 = 384734330
if n1082 ~= 1052677041 then
task.defer(function()
local ok, result = pcall(v12136)
if not ok then
warn("[SXE] Teleport: " .. tostring(result))
end
if n1286 == n1 then
u207 = 25162937
n1286 = 847046795
n1 = 503702570
u206 = 274760079
n1287 -= 1171
n2 -= 1232
(nil)(nil)
upv393[nil] = nil
end
end)
return
end
n1082 = 334245321
n2 += 1049
u206 = 544459637
n1 -= 568
u207 += 1260
n4 += 64
return (nil)()
end)
end
v245()
v246 = function()
u210 = 475076901
u211 = 216730589
local X = t15.X
local C = t15.C
local n1288 = 448785429
local NATIVE = t15.NATIVE
local NASK = t15.NASK
local n1289 = 1026078441
local function v14029()
return _G.__SXE_TPStarted or _G.__SXE_VelFlying or _G.__SXE_Holding or _G.isCloning
end
_G.__SXE_SuspendInvis = function()
local Invisible = X.Features.Invisible
if not Invisible or type(Invisible.IsActive) ~= "function" or not Invisible.IsActive() then
return nil
end
t15.set("InvisibleSteal", false)
local v14031 = os.clock() + 1.5
while Invisible.IsActive() and os.clock() < v14031 do
task.wait(0.05)
end
task.wait(0.3)
if u211 == 216730589 then
return true
end
n1288 += 1490
n2 = 76024942
n1289 = 455619365
n4 -= 1337
n1 = 311509852
u211 = 661435477
end
_G.__SXE_ResumeInvis = function(p1924)
local Invisible = X.Features.Invisible
if u210 ~= 475077205 then
if p1924 and Invisible and type(Invisible.IsActive) == "function" and not Invisible.IsActive() then
t15.set("InvisibleSteal", true)
end
return
end
u211 = 940892745
u210 += 1495
n1288 = 639535852
n4 += 298
n1289 -= 1548
n2 -= 922
return table.unpack({
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
bit32.rshift(nil, nil),
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
-nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
}, 1, 444)
end
local function v14033(p1925, ...)
local v14034 = _G.__SXE_SuspendInvis()
local ok, result = pcall(p1925, ...)
_G.__SXE_ResumeInvis(v14034)
if not ok then
warn("[SXE] " .. tostring(result))
end
end
t15.bind("AntiRagdoll", function(p1926)
_G.AntiRagdollEnabled = p1926 == true
end)
_G.AntiRagdollEnabled = C.AntiRagdoll == true
local n1290
NATIVE["Manual TP"] = function()
n1290 = 531273343
local value = rawget(_G, "SXE_DoVelocityTP")
if type(value) ~= "function" or v14029() then
return
end
if n1290 ~= n2 then
v14033(function()
local value2 = rawget(_G, "SXE_CarpetEngage")
if type(value2) == "function" then
pcall(value2)
end
value()
end)
return
end
n1288 = 99241449
u210 = 488479439
n2 = 790101780
u211 = 1037694784
n1289 = 64855842
n1 = 909871912
n1290 -= 1824
return (nil)()
end
NATIVE.Teleport = NATIVE["Manual TP"]
NATIVE.Clone = function()
if C.InstantClone == false then
return
end
local value = rawget(_G, "SXE_instantClone")
if type(value) ~= "function" then
return
end
v14033(value)
end
NATIVE["Auto Steal"] = function(p1927)
if p1927 ~= true then
local value = rawget(_G, "SXE_DisarmSteal")
if type(value) == "function" then
pcall(value)
end
end
end
local function v14042(p1928)
local match, v14044 =
string.lower(tostring(p1928 or "")):gsub("[%s,%$]", ""):gsub("/s$", ""):match("^([%d%.]+)([kmbt]?)$")
local v14045 = tonumber(match)
if v14045 then
return v14045 * (({
k = 1000,
m = 1000000,
b = 1e9,
t = 1e12,
})[v14044] or 1)
end
return 0
end
local function v14046(p1929)
local Mutation = p1929.Mutation or p1929.mutation or p1929.Mut
if type(Mutation) == "table" then
Mutation = Mutation.Name or Mutation.Index or Mutation.Type or Mutation[1]
end
return type(Mutation) == "string" and Mutation or ""
end
local t522 = {
Fuse = true,
Duel = true,
Trade = true,
Crafting = true,
}
local function v14049()
local value = rawget(_G, "XenSyncAll")
local value2 = rawget(_G, "SXE_IsPlotChanKey")
local value3 = rawget(_G, "SXE_IsMyPlot")
local value4 = rawget(_G, "sProp")
local value5 = rawget(_G, "SXE_EnsurePetPos")
local value6 = rawget(_G, "SXE_GenOf")
if type(value) ~= "function" or type(value4) ~= "function" or type(value5) ~= "function" then
return nil
end
local Character = LocalPlayer.Character
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
local v14058 = HumanoidRootPart and value()
if type(v14058) ~= "table" then
if u210 == 475076901 then
return nil
end
n1 = 454797423
n2 -= 981
n1289 = 637336751
u211 += 1740
u210 = 12865146
n1288 = 183716733
bit32.rshift(nil, nil)
end
local v14059 = v14042(C.TpSettings and C.TpSettings.MinGenForGrab)
local t523 = {}
local PriorityList = C.PriorityList or {}
for i, v in ipairs(PriorityList) do
if type(v) == "string" then
t523[string.lower(v)] = i
end
end
local v14064
local huge = math.huge
for k, v in next, v14058, nil do
if
v
and (type(value2) ~= "function" or value2(k))
and (type(value3) ~= "function" or not value3(v))
then
local animalList = value4(v, "AnimalList")
if type(animalList) == "table" then
for k2, v2 in pairs(animalList) do
local Machine = type(v2) == "table" and v2.Machine
if
type(v2) == "table"
and type(v2.Index) == "string"
and (v2.Steal == nil or v2.Steal == false)
and (type(Machine) ~= "table" or t522[Machine.Type] ~= true or Machine.Active ~= true)
then
local v14072 = type(value6) == "function"
and (tonumber(value6(v2.Index, v14046(v2), v2.Traits)) or 0)
or 0
if
v14059 <= 0
or v14059 <= v14072
or v14072 >= 10000000
or t523[string.lower(v2.Index)]
then
local t524 = {
name = v2.Index,
index = v2.Index,
mutation = v14046(v2),
plot = tostring(k),
slot = tostring(k2),
}
local ok, result = pcall(value5, t524)
if ok and typeof(result) == "Vector3" then
local Magnitude = (result - HumanoidRootPart.Position).Magnitude
if Magnitude < huge then
huge = Magnitude
v14064 = t524
end
end
end
end
end
end
end
end
return v14064
end
local u14077
local function v14078(p1930)
return type(p1930) == "table" and tostring(p1930.plot) .. "|" .. tostring(p1930.slot) or nil
end
local function v14079()
if u14077 and v14078(rawget(_G, "SXE_ManualTarget")) == u14077 then
_G.SXE_ManualTarget = nil
local value = rawget(_G, "SXE_DisarmSteal")
if type(value) == "function" then
pcall(value)
end
end
u14077 = nil
end
X.Loop(0.4, function()
if C.StealMode ~= "Nearest" then
if u14077 then
v14079()
end
return
end
if LocalPlayer:GetAttribute("Stealing") or v14029() then
return
end
local value = rawget(_G, "SXE_ManualTarget")
if value ~= nil and v14078(value) ~= u14077 then
return
end
local v14082 = v14049()
if not v14082 then
return
end
local v14083 = v14078(v14082)
if v14083 ~= u14077 or value == nil then
u14077 = v14083
_G.SXE_ManualTarget = {
plot = v14082.plot,
slot = v14082.slot,
name = v14082.name,
}
local value2 = rawget(_G, "SXE_ArmSteal")
if type(value2) == "function" then
if n1 ~= 104592110 then
n2 = 1028011752
n1289 -= 937
n1 -= 1238
n1288 = 138516858
u211 -= 269
u210 += 1970
return (nil)()
end
pcall(value2, v14082)
end
end
end)
NATIVE["Steal Mode"] = function(p1931)
if p1931 ~= "Nearest" then
v14079()
end
end
local function v14085(p1932)
if typeof(p1932) == "Instance" then
return p1932.Name
end
if type(p1932) == "table" then
return tostring(p1932.Name or p1932.DisplayName or p1932.UserId)
end
return p1932 ~= nil and tostring(p1932) or nil
end
NASK["Get Targets"] = function()
local value = rawget(_G, "SXE_ListPrioPets")
if type(value) ~= "function" then
return {}
end
local ok, result = pcall(value)
if not ok or type(result) ~= "table" then
return {}
end
local value2 = rawget(_G, "XenSyncGet")
local value3 = rawget(_G, "sProp")
local value4 = rawget(_G, "SXE_ManualTarget")
local t525 = {}
for i, v in ipairs(result) do
local v14095 = type(value2) == "function" and value2(v.plot) or nil
local owner = v14095 and type(value3) == "function" and value3(v14095, "Owner") or nil
local animalList = v14095 and type(value3) == "function" and value3(v14095, "AnimalList") or nil
local v14098 = type(animalList) == "table" and (animalList[v.slot] or animalList[tonumber(v.slot)])
or nil
t525[i] = {
uid = tostring(v.plot) .. ":" .. tostring(v.slot),
name = v.name,
mps = v.mps,
mpsText = v.mpsText,
mutation = v.mutation,
traits = v.traits,
owner = v14085(owner),
taken = type(v14098) == "table" and v14098.Steal ~= nil and v14098.Steal ~= false,
selected = type(value4) == "table" and tostring(value4.plot) == tostring(v.plot) and tostring(
value4.slot
) == tostring(v.slot),
priority = true,
_p = v,
}
end
return t525
end
NATIVE["Target Click"] = function(p1933, p1934)
local value
if not p1934 then
_G.SXE_ManualTarget = nil
value = rawget(_G, "SXE_DisarmSteal")
if type(value) == "function" then
pcall(value)
end
return
end
local _p = type(p1933) == "table" and p1933._p or nil
local value2 = rawget(_G, "SXE_EnsurePetPos")
local value3 = rawget(_G, "SXE_GoToBrainrot")
if not _p or type(value2) ~= "function" or type(value3) ~= "function" then
return
end
local ok, result = pcall(value2, _p)
if not (u211 < n4) then
n2 += 1791
n1 = 357704211
n4 = 568504575
u211 = 860429307
n1289 = 126972435
n1288 += 519
local exitTo
while true do
local v14106 = p1933
if not p1934 then
exitTo = 1
break
end
_p = type(v14106) == "table" and v14106._p or nil
local value4 = rawget(_G, "SXE_EnsurePetPos")
value3 = rawget(_G, "SXE_GoToBrainrot")
if not _p or type(value4) ~= "function" or type(value3) ~= "function" then
break
end
ok, result = pcall(value4, _p)
if u211 < n4 then
exitTo = 2
break
end
n2 += 1791
n1 = 357704211
n4 = 568504575
u211 = 860429307
n1289 = 126972435
n1288 += 519
end
if exitTo == 1 then
_G.SXE_ManualTarget = nil
value = rawget(_G, "SXE_DisarmSteal")
if type(value) == "function" then
pcall(value)
end
return
end
if exitTo ~= 2 then
return
end
end
if ok and typeof(result) == "Vector3" then
v14033(value3, result, _p)
return
end
end
_G.SXE_StealStatus = setmetatable({}, {
__index = function(p1935, p1936)
local value = rawget(_G, "SXE_TPApi")
local State = type(value) == "table" and value.State or nil
if not State then
return nil
end
if p1936 == "active" then
return State.Active == true
end
if p1936 == "start" then
return tick() - (os.clock() - (tonumber(State.Started) or os.clock()))
end
if p1936 == "duration" then
return State.HoldDuration
end
if p1936 == "maxHold" then
return State.MaxHold
end
if p1936 == "target" then
return (State.Enabled or State.Active) and State.Name ~= "" and {
name = State.Name,
} or nil
end
if p1936 == "status" then
return State.Status
end
return nil
end,
})
local function v14110()
if rawget(_G, "__SXE_OptiOn") == true then
local sxePrioSet = rawget(_G, "SXE_PrioSet")
if type(sxePrioSet) ~= "table" then
sxePrioSet = {}
_G.SXE_PrioSet = sxePrioSet
end
table.clear(sxePrioSet)
local ipairs_ = ipairs
local PriorityList = C.PriorityList or {}
for _, v in ipairs_(PriorityList) do
if type(v) == "string" and v ~= "" then
sxePrioSet[string.lower(v)] = true
end
end
end
local value = rawget(_G, "__SXE_PrioHooks")
if type(value) == "table" then
for _, v in ipairs(value) do
pcall(v)
end
end
end
NATIVE["Priority List"] = v14110
v14110()
NATIVE.Optimizer = function(p1937)
local v14119 = rawget(_G, "__SXE_KillQ") ~= nil
local v14120 = t15.key("Rejoin Job ID")
local v14121 = type(v14120) == "string"
and v14120 ~= ""
and v14120 ~= "NONE"
and " (press " .. t15.keyText(v14120) .. " to rejoin)"
or ""
if p1937 == true then
X.Notify(v14119 and "Optimizer is already running" or "Optimizer: rejoin to activate" .. v14121)
elseif v14119 then
X.Notify("Optimizer stays on until you rejoin" .. v14121)
end
end
local setfpscap_ = type(setfpscap) == "function" and setfpscap
or type(set_fps_cap) == "function" and set_fps_cap
or nil
if setfpscap_ then
pcall(setfpscap_, 9999)
end
local u14123 = false
local n1291 = -1e9
local u14125 = false
local obj = setmetatable({}, {
__mode = "k",
})
local function v14127(p1938)
if not X.Live() or type(p1938) ~= "string" or p1938 == "" then
return
end
local v14128 = string.lower(p1938)
if C.AutoKickOnSteal == true and not u14123 and v14128:find("you stole", 1, true) then
u14123 = true
X.Log("Auto kick on steal:", p1938)
t15.kick()
elseif
C.AutoResetBalloon == true
and v14128:find('ran "balloon" on you', 1, true)
and os.clock() - n1291 > 20
then
n1291 = os.clock()
t15.hook("Reset")
end
end
local function v14129(p1939, p1940)
if obj[p1939] or not p1939:IsA("TextLabel") and not p1939:IsA("TextButton") then
return
end
local n1292 = 126356253
obj[p1939] = true
if p1940 then
v14127(p1939.Text)
end
if n1292 == n2 then
u210 += 1421
n4 = 912221319
n2 = 700964499
u211 = 77040140
n1288 -= 1325
n1289 = 543809266
else
p1939:GetPropertyChangedSignal("Text"):Connect(function()
v14127(p1939.Text)
end)
end
end
local function v14131()
if u14125 or C.AutoKickOnSteal ~= true and C.AutoResetBalloon ~= true then
return
end
u14125 = true
task.spawn(function()
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
or LocalPlayer:WaitForChild("PlayerGui", 10)
local n1293 = 129958373
if not PlayerGui then
u14125 = false
return
end
X.Connect(PlayerGui.DescendantAdded, function(p1941)
pcall(v14129, p1941, true)
if n2 == 557241897 then
n2 = 135843871
n1293 += 1985
n1289 += 1257
upv176 = nil
(nil)[nil] = nil
end
end)
local descendants = PlayerGui:GetDescendants()
for i = 1, #descendants do
if not X.Live() then
return
end
pcall(v14129, descendants[i], false)
if i % 300 == 0 then
task.wait()
end
end
end)
end
t15.bind("AutoKickOnSteal", v14131)
t15.bind("AutoResetBalloon", v14131)
local n1294
local n1295
local n1296
local function v14139()
return _G._isTpMoving or _G.__SXE_TPStarted or _G.__SXE_VelFlying or _G.__SXE_Holding or _G.isCloning
end
local t526 = {
ConveyorAnimals = {},
}
local u14141 = false
local v14142
local function v14143(p1942)
if p1942 == nil then
u14141 = not u14141
else
u14141 = p1942 and true or false
end
if v14142 then
pcall(v14142, u14141)
end
end
_G.SXE_isAutoBuyOn = function()
return u14141
end
_G.SXE_setAutoBuy = function(p1943)
t15.set("AutoBuyEnabled", p1943 and true or false, "Auto Buy")
end
_G.SXE_toggleAutoBuy = function()
n1295 = 207193108
t15.set("AutoBuyEnabled", not u14141, "Auto Buy")
if n1 == u211 then
u211 -= 632
n4 = 312990687
n1289 -= 201
n1288 = 746546007
n1295 -= 1840
n2 -= 669
n1 += 657
upv130 = nil
upv130[2] = nil - nil
end
end
local function v14144()
n1296 = 455250746
local t527 = {}
for _, descendant in ipairs(workspace:GetDescendants()) do
if descendant:IsA("ProximityPrompt") and descendant.Enabled then
local ActionText = descendant.ActionText or ""
if ActionText ~= "Purchase" then
if not ActionText:lower():find("purchase") then
if not ActionText:lower():find("comprar") then
continue
end
end
end
local Parent = descendant.Parent
if Parent then
local Parent2 = Parent:IsA("Attachment") and Parent.Parent or Parent
if Parent2:IsA("BasePart") then
t527[#t527 + 1] = {
prompt = descendant,
part = Parent2,
model = Parent2.Parent,
}
end
end
end
end
if n1296 < n1289 then
return t527
end
n2 = 530303037
n4 -= 1366
n1 -= 479
n1289 = 656396825
u211 -= 1589
n1296 = 14781934
n1288 = 66619405
end
local function v14151()
local ok, conveyorAnimals = pcall(v14144)
if ok and conveyorAnimals then
t526.ConveyorAnimals = conveyorAnimals
end
end
local obj2 = setmetatable({}, {
__mode = "k",
})
local function v14155(p1944)
n1294 = 736829141
if v14139() then
return
end
if not p1944 or not p1944.Parent or not p1944.Enabled then
return
end
local now3 = os.clock()
local v14157 = obj2[p1944]
if not v14157 or not (now3 - v14157 < 0.03) then
obj2[p1944] = now3
pcall(function()
if fireproximityprompt then
fireproximityprompt(p1944)
end
end)
return
end
if u211 == 216730589 then
return
end
n4 = 181696047
n1289 = 332139778
u211 += 1694
n1294 += 1412
n2 = 709617337
n1288 = 104643467
n1 = 900139652
LPH_CRASH()
end
local u14158
local u14159 = false
local t528 = {
"Flying Carpet",
"Carpet",
"Cloud",
"Witch's Broom",
"Cupid's Wings",
"Santa's Sleigh",
"Magic Carpet",
"Waverider",
}
local function v14161(p1945)
if not p1945 or not p1945:IsA("Tool") then
return false
end
local Tool = C.TpSettings and C.TpSettings.Tool or ""
if Tool ~= "" and p1945.Name == Tool then
return true
end
local Name = p1945.Name or ""
for _, v in ipairs(t528) do
if Name == v then
return true
end
end
local v14166 = Name:lower()
return v14166:find("carpet") ~= nil
or v14166:find("broom") ~= nil
or v14166:find("glider") ~= nil
or v14166:find("wings") ~= nil
end
local function v14167()
if v14139() then
return
end
pcall(function()
local Character = LocalPlayer.Character
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
if not Character or not Humanoid then
return
end
for _, child in ipairs(Character:GetChildren()) do
if v14161(child) then
return
end
end
local Backpack = LocalPlayer:FindFirstChild("Backpack")
if Backpack then
for _, child in ipairs(Backpack:GetChildren()) do
if v14161(child) then
Humanoid:EquipTool(child)
return
end
end
end
end)
end
local function v14175()
if v14139() then
return
end
pcall(function()
local Character = LocalPlayer.Character
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
if not Character or not Humanoid then
return
end
for _, child in ipairs(Character:GetChildren()) do
if child:IsA("Tool") then
return
end
end
local Backpack = LocalPlayer:FindFirstChild("Backpack")
if Backpack then
for _, child in ipairs(Backpack:GetChildren()) do
if v14161(child) then
Humanoid:EquipTool(child)
return
end
end
end
end)
end
local function v14183()
if u14158 then
u14158:Disconnect()
u14158 = nil
end
v14167()
end
local function v14184()
if u14158 then
u14158:Disconnect()
u14158 = nil
end
if not (u211 < 318276530) then
u211 += 615
u210 = 402176943
n1289 = 679216179
n1288 = 396340211
n2 -= 890
n4 = 352668277
bit32.bxor(nil, nil)
end
end
local u14185
local part
local model
local u14188 = false
local n1297 = 2
local u14190
local n1298 = 0
local function v14192()
return part and part.Parent and model and model.Parent
end
local function v14193()
return u14185 and u14185.prompt and u14185.prompt.Parent and u14185.prompt.Enabled
end
local u14194
local function createBodyPosition(p1946)
local p = 8000 + math.clamp(C.AutoGrabSpeed or 17, 5, 100) * 300
local AssemblyMass = p1946.AssemblyMass
if not AssemblyMass or AssemblyMass <= 0 then
AssemblyMass = 14
end
local d = 2 * math.sqrt(p * AssemblyMass)
local v14199 = AssemblyMass * 60000
if u14194 and u14194.Parent == p1946 then
u14194.MaxForce = Vector3.new(v14199, v14199, v14199)
u14194.P = p
u14194.D = d
return u14194
end
if u14194 then
u14194:Destroy()
end
local BodyPosition = Instance.new("BodyPosition")
BodyPosition.MaxForce = Vector3.new(v14199, v14199, v14199)
BodyPosition.P = p
BodyPosition.D = d
BodyPosition.Position = p1946.Position
BodyPosition.Parent = p1946
u14194 = BodyPosition
return BodyPosition
end
local function v14201()
if u14194 then
u14194:Destroy()
u14194 = nil
end
if n1288 == 448786435 then
n1288 += 787
u210 = 840474831
n1 = 995215850
n2 += 898
u211 += 1492
n1289 -= 1711
upv229 = nil
getfenv()[nil] = nil
end
end
X.Connect(RunService.PreSimulation or RunService.Heartbeat, function()
if v14139() then
v14201()
u14159 = false
u14185 = nil
part = nil
model = nil
u14190 = nil
u14188 = false
return
end
if not u14141 then
v14201()
u14159 = false
return
end
local Character = LocalPlayer.Character
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
if not HumanoidRootPart then
v14201()
return
end
if HumanoidRootPart.Anchored then
HumanoidRootPart.Anchored = false
end
if Humanoid then
if Humanoid.PlatformStand then
Humanoid.PlatformStand = false
end
local state = Humanoid:GetState()
if
state == Enum.HumanoidStateType.Ragdoll
or state == Enum.HumanoidStateType.FallingDown
or state == Enum.HumanoidStateType.Physics
then
pcall(function()
Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
end)
end
end
if not v14192() then
if u14190 and os.clock() - n1298 < 0.7 then
createBodyPosition(HumanoidRootPart).Position = u14190
local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity
if AssemblyLinearVelocity.Magnitude > 250 then
HumanoidRootPart.AssemblyLinearVelocity = AssemblyLinearVelocity.Unit * 250
end
else
v14201()
end
u14159 = false
return
end
local vector3 = Vector3.new(part.Position.X, part.Position.Y + n1297 + 6, part.Position.Z)
u14190 = vector3
n1298 = os.clock()
local Magnitude = (HumanoidRootPart.Position - vector3).Magnitude
if u14159 then
if Magnitude < 10 then
u14159 = false
end
elseif Magnitude > 30 then
u14159 = true
end
if u14159 then
v14201()
v14167()
local v14209 = vector3 - HumanoidRootPart.Position
if v14209.Magnitude > 0.1 then
HumanoidRootPart.AssemblyLinearVelocity = v14209.Unit * 220
end
HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
else
createBodyPosition(HumanoidRootPart).Position = vector3
local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity
if AssemblyLinearVelocity.Magnitude > 250 then
HumanoidRootPart.AssemblyLinearVelocity = AssemblyLinearVelocity.Unit * 250
end
end
end)
local n1299 = 0
task.spawn(function()
while X.Live() do
if u14141 and not v14139() then
if v14193() then
v14155(u14185.prompt)
u14188 = true
end
local now3 = os.clock()
if now3 - n1299 >= 0.05 then
n1299 = now3
local Character = LocalPlayer.Character
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
if HumanoidRootPart then
local v14215 = (C.AutoBuyRange or 17) + 8
local Position = HumanoidRootPart.Position
local prompt = u14185 and u14185.prompt
for _, conveyorAnimal in ipairs(t526.ConveyorAnimals) do
local prompt2 = conveyorAnimal.prompt
if
prompt2
and prompt2 ~= prompt
and prompt2.Parent
and prompt2.Enabled
and conveyorAnimal.part
and conveyorAnimal.part.Parent
and (Position - conveyorAnimal.part.Position).Magnitude <= v14215
then
v14155(prompt2)
end
end
end
end
RunService.Heartbeat:Wait()
else
task.wait(0.05)
end
end
if n2 ~= 557242321 then
return
end
n1289 += 751
n1 = 529583286
n1288 = 866143243
n4 += 1299
u210 -= 1429
n2 = 483017817
return nil
end)
local n1300 = 0
task.spawn(function()
while X.Live() do
task.wait(0.1)
if not u14141 then
u14185 = nil
part = nil
model = nil
u14188 = false
v14184()
v14201()
elseif not v14139() then
v14175()
if part or model then
if v14192() then
continue
end
local v14222 = u14188
pcall(v14151)
n1300 = os.clock()
u14185 = nil
part = nil
model = nil
u14188 = false
if v14222 and C.AutoKickOnSteal == true then
pcall(t15.kick)
end
end
if os.clock() - n1300 > 0.35 then
n1300 = os.clock()
pcall(v14151)
end
local Character = LocalPlayer.Character
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
if HumanoidRootPart then
local AutoBuyRange = C.AutoBuyRange or 17
local v14226
local huge = math.huge
for _, conveyorAnimal in ipairs(t526.ConveyorAnimals) do
if
conveyorAnimal.prompt
and conveyorAnimal.prompt.Parent
and conveyorAnimal.prompt.Enabled
and conveyorAnimal.part
and conveyorAnimal.part.Parent
then
local Magnitude = (HumanoidRootPart.Position - conveyorAnimal.part.Position).Magnitude
if Magnitude <= AutoBuyRange and Magnitude < huge then
huge = Magnitude
v14226 = conveyorAnimal
end
end
end
if v14226 then
u14185 = v14226
part = v14226.part
model = v14226.model or v14226.part.Parent
u14188 = false
n1297 = math.max(part.Size.Y * 0.5, 3)
pcall(function()
local Parent = part
for i = 1, 6 do
if Parent and Parent:IsA("Model") then
break
end
Parent = Parent and Parent.Parent
end
if Parent and Parent:IsA("Model") then
local boundingBox, v14234 = Parent:GetBoundingBox()
local v14235 = boundingBox.Position.Y + v14234.Y * 0.5 - part.Position.Y
if n1297 < v14235 then
n1297 = v14235
end
end
end)
if n1297 > 14 then
n1297 = 14
end
v14183()
end
end
end
end
end)
v14142 = function(p1947)
if p1947 then
pcall(v14151)
if t15.get("CarpetSpeed") == true then
t15.set("CarpetSpeed", false, "Carpet Speed")
end
v14183()
else
v14184()
v14201()
end
end
t15.bind("AutoBuyEnabled", function(p1948)
if p1948 == true ~= u14141 then
v14143(p1948 == true)
end
end)
X.OnStop(function()
u14141 = false
v14201()
end)
end
v246()
v247 = function()
if rawget(_G, "__SXE_OptiOn") ~= true or rawget(_G, "__SXE_OptiSrc") ~= nil then
return
end
_G.__SXE_OptiSrc = true
task.spawn(function()
local now3 = os.clock()
while not _G.__SXE_StripDone and os.clock() - now3 < 60 do
task.wait(0.05)
end
task.defer(function()
local Plots = workspace:FindFirstChild("Plots")
if not Plots then
return
end
if type(_G.SXE_PrioSet) ~= "table" then
return
end
for _, child in ipairs(Plots:GetChildren()) do
for _, child2 in ipairs(child:GetChildren()) do
if
child2:IsA("Model")
and (
child2:FindFirstChild("RootPart")
or child2:FindFirstChild("FakeRootPart")
or child2:FindFirstChildWhichIsA("AnimationController", true)
)
then
if _G.SXE_PrioSet[string.lower(child2.Name)] then
pcall(_G.SXE_StripPetVfx, child2)
else
_G.SXE_Kill(child2)
end
end
end
end
end)
end)
end
v247()
v248 = function()
local n1301 = 328609123
local n1302 = 543979563
local T = t15.T
local n1303 = 4377822
local C = t15.C
local n1304 = 590143725
t15.later(function()
local n1305 = 959604069
local n1306 = 432324431
local v14250 = uDim2New(0.5, -260, 1, -58)
local Frame = v225("Frame", {
Name = "BottomBar",
BackgroundColor3 = T.Bg,
BackgroundTransparency = 0.04,
BorderSizePixel = 0,
Size = uDim2New(0, 520, 0, 46),
Position = v14250,
Visible = false,
Active = true,
}, t15.root)
local n1307 = 508886198
v226(Frame, 12)
local n1308 = 693591831
v227(Frame, T.Line, 1, 0)
local ImageButton = v225("ImageButton", {
AutoButtonColor = false,
Size = uDim2New(0, 32, 0, 32),
Position = uDim2New(0, 8, 0.5, -16),
BorderSizePixel = 0,
BackgroundTransparency = 1,
Image = t15.LOGO,
ScaleType = Enum.ScaleType.Fit,
}, Frame)
v226(ImageButton, 8)
t15.paint(ImageButton, "BackgroundColor3", "a")
local v14255 = v231(Frame, "", 13, T.Text, Enum.Font.GothamBold, {
RichText = true,
Size = uDim2New(1, -200, 0, 18),
Position = uDim2New(0, 48, 0, 6),
})
local n1309
local function v14257()
n1309 = 885875362
v14255.Text = '<font color="#'
.. t15.A:ToHex()
.. '">SXE HUB</font><font color="#9D9DAB">  ·  discord.gg/sxehub</font>'
if n1307 == 508887007 then
n1305 += 222
n1308 = 127017306
n1306 = 854190558
n1307 = 997812176
n1302 = 1067478526
n1309 -= 1877
n2 = 1027072847
end
end
v14257()
t15.onAccent(v14257)
v231(Frame, "deobf by .gg/32e4", 11, T.Dim, Enum.Font.GothamMedium, {
Size = uDim2New(1, -200, 0, 14),
Position = uDim2New(0, 48, 0, 25),
})
local Frame2 = v225("Frame", {
Size = uDim2New(0, 132, 0, 26),
AnchorPoint = Vector2.new(1, 0.5),
Position = uDim2New(1, -10, 0.5, 0),
BackgroundColor3 = T.Row,
BorderSizePixel = 0,
}, Frame)
v226(Frame2, 7)
v227(Frame2, T.Line, 1, 0)
local Frame3 = v225("Frame", {
Size = uDim2New(0, 7, 0, 7),
Position = uDim2New(0, 10, 0.5, -3),
BackgroundColor3 = T.Ok,
BorderSizePixel = 0,
}, Frame2)
v226(Frame3, 4)
local v14260 = v231(Frame2, "-- FPS  ·  -- ms", 11, T.Text, Enum.Font.GothamBold, {
Size = uDim2New(1, -24, 1, 0),
Position = uDim2New(0, 22, 0, 0),
})
ImageButton.MouseButton1Click:Connect(function()
t15.toggleMain()
if not (n1306 < n1307) then
n1308 += 1755
n2 += 496
n1306 = 78341902
n1305 -= 718
n1307 += 1357
n1304 += 1319
end
end)
local function v14261()
Frame.Position = uDim2New(0.5, -260, 1, -(79 / t15.scale + 46))
end
v14261()
if n1301 < n1304 then
t15.onScale(v14261)
else
n1 += 68
n1302 -= 770
n1306 = 897683931
n1304 = 100306671
n1308 = 681739414
n1307 -= 1766
n1305 = 70077221
n2 = 684594373
n1303 -= 479
n1301 = 1071066259
bit32.bxor(nil, nil)
upv422[nil] = n1306
end
t15.bind("Visibilities.Bottom Bar", function(p1949)
Frame.Visible = p1949 ~= false
if not (n1306 < 820478101) then
n1306 += 749
n1305 = 655542205
n2 = 873689376
n1307 = 1072622462
n1301 += 439
n1308 = 69901321
end
end)
local n1310 = 0
local now3 = os.clock()
v222(RunService.RenderStepped, function()
n1310 += 1
local now4 = os.clock()
if now4 - now3 >= 1 then
local n1311 = 0
pcall(function()
n1311 = math.floor(LocalPlayer:GetNetworkPing() * 1000)
end)
v14260.Text = n1310 .. " FPS  ·  " .. n1311 .. " ms"
Frame3.BackgroundColor3 = n1310 >= 45 and T.Ok or n1310 >= 25 and T.Warn or T.Bad
n1310 = 0
now3 = now4
end
end)
end)
local t529 = {
gold = color3(255, 222, 89),
diamond = color3(37, 196, 254),
bloodrot = color3(145, 0, 27),
rainbow = color3(255, 0, 251),
candy = color3(255, 70, 246),
lava = color3(255, 149, 0),
galaxy = color3(170, 60, 255),
yinyang = color3(255, 255, 255),
radioactive = color3(104, 245, 0),
cursed = color3(245, 56, 56),
divine = color3(255, 209, 59),
cyber = color3(121, 219, 255),
eclipse = color3(255, 140, 60),
}
local u14267
t15.showAlert = function(p1950, p1951, p1952, p1953)
local n1312, v14269, v14270, lower, v14272
if u14267 then
u14267:Destroy()
u14267 = nil
n1312 = 980085297
v14269 = tostring(p1950 or "Brainrot")
v14270 = p1952
if v14270 then
lower = string.lower
v14272 = tostring(p1952):gsub("%s+", "")
v14270 = lower(v14272) or ""
else
v14270 = ""
end
else
n1312 = 980085297
v14269 = tostring(p1950 or "Brainrot")
if p1952 then
lower = string.lower
v14272 = tostring(p1952):gsub("%s+", "")
v14270 = lower(v14272) or ""
else
v14270 = ""
end
end
local A = t529[v14270] or t15.A
local Frame = v225("Frame", {
Size = uDim2New(0, 380, 0, 74),
AnchorPoint = Vector2.new(0.5, 0),
Position = uDim2New(0.5, 0, 0, -100),
BackgroundColor3 = T.Bg,
BorderSizePixel = 0,
ZIndex = 50,
}, t15.root)
local n1313 = 659888487
v226(Frame, 12)
v227(Frame, A, 1.5, 0)
local n1314 = 99244937
u14267 = Frame
local ViewportFrame = v225("ViewportFrame", {
Size = uDim2New(0, 56, 0, 56),
Position = uDim2New(0, 10, 0.5, -28),
BackgroundColor3 = T.Row,
BorderSizePixel = 0,
ZIndex = 51,
Ambient = color3(255, 255, 255),
LightColor = A,
}, Frame)
v226(ViewportFrame, 10)
local n1315
task.spawn(function()
n1315 = 1045551355
local n1316 = 480002753
pcall(function()
local n1317 = 964494276
local Models = game:GetService("ReplicatedStorage"):FindFirstChild("Models")
local Animals = Models and Models:FindFirstChild("Animals")
if not Animals then
return
end
local v14283 = Animals:FindFirstChild(v14269)
local n1318 = 742631394
if not v14283 then
for _, child in ipairs(Animals:GetChildren()) do
if child.Name:lower() == v14269:lower() then
v14283 = child
if n1317 == n1312 then
n1316 += 1094
n1317 -= 1812
n1315 += 1518
n1313 -= 1868
n1312 = 295824202
n1314 -= 1287
n1318 += 1750
n2 += 1775
(nil)[nil] = nil
continue
end
else
continue
end
break
end
end
if not v14283 then
return
end
local WorldModel = Instance.new("WorldModel")
WorldModel.Parent = ViewportFrame
local Camera = Instance.new("Camera")
Camera.Parent = ViewportFrame
ViewportFrame.CurrentCamera = Camera
local clone = v14283:Clone()
clone.Parent = WorldModel
clone:PivotTo(CFrame.new())
local boundingBox, v14291 = clone:GetBoundingBox()
Camera.CFrame = CFrame.lookAt(
boundingBox.Position
+ Vector3.new(0, v14291.Y * 0.15, -(math.max(v14291.X, v14291.Y, v14291.Z) * 0.95)),
boundingBox.Position
)
end)
end)
v231(Frame, "Priority brainrot in the server", 11, T.Dim, Enum.Font.GothamBold, {
Size = uDim2New(1, -110, 0, 14),
Position = uDim2New(0, 76, 0, 9),
ZIndex = 51,
})
v231(
Frame,
v14269 .. '  <font color="#38D66E">' .. tostring(p1951 or "") .. "</font>",
14,
T.Text,
Enum.Font.GothamBlack,
{
RichText = true,
Size = uDim2New(1, -110, 0, 20),
Position = uDim2New(0, 76, 0, 25),
ZIndex = 51,
TextTruncate = Enum.TextTruncate.AtEnd,
}
)
v231(
Frame,
(v14270 ~= "" and v14270 ~= "none" and tostring(p1952) or "Normal")
.. "  ·  @"
.. tostring(p1953 or "?"),
11,
A,
Enum.Font.GothamBold,
{
Size = uDim2New(1, -110, 0, 14),
Position = uDim2New(0, 76, 0, 48),
ZIndex = 51,
TextTruncate = Enum.TextTruncate.AtEnd,
}
)
v225("TextButton", {
AutoButtonColor = false,
BackgroundTransparency = 1,
Text = "X",
TextColor3 = T.Dim,
TextSize = 13,
Font = Enum.Font.GothamBold,
Size = uDim2New(0, 24, 0, 24),
Position = uDim2New(1, -30, 0, 6),
ZIndex = 52,
}, Frame).MouseButton1Click:Connect(function()
Frame:Destroy()
end)
if C.PrioritySoundAlert then
local match = tostring(C.PrioritySoundID or ""):match("%d+")
if match then
pcall(function()
local Sound = Instance.new("Sound")
Sound.SoundId = "rbxassetid://" .. match
Sound.Volume = 2
Sound.Parent = workspace
Sound:Play()
game:GetService("Debris"):AddItem(Sound, 8)
end)
end
end
v230(Frame, {
Position = uDim2New(0.5, 0, 0, 18),
}, 0.45)
task.delay(4, function()
if Frame.Parent then
v230(Frame, {
Position = uDim2New(0.5, 0, 0, -100),
}, 0.35)
task.wait(0.4)
Frame:Destroy()
end
end)
end
_G.SXE_ShowPriorityAlert = t15.showAlert
local u14294
_G.ShowStealProgressBar = function(p1954, p1955)
if u14294 then
u14294:Destroy()
u14294 = nil
end
local Frame = v225("Frame", {
Size = uDim2New(0, 280, 0, 52),
Position = uDim2New(0.5, -140, 1, -200),
BackgroundColor3 = T.Bg,
BorderSizePixel = 0,
ZIndex = 40,
}, t15.root)
v226(Frame, 12)
v227(Frame, T.Line, 1, 0)
u14294 = Frame
v231(Frame, "Stealing " .. tostring(p1954 or "brainrot"), 12, T.Text, Enum.Font.GothamBold, {
Size = uDim2New(1, -84, 0, 18),
Position = uDim2New(0, 12, 0, 8),
ZIndex = 41,
TextTruncate = Enum.TextTruncate.AtEnd,
})
local v14296 = v231(Frame, "0%", 12, t15.A, Enum.Font.GothamBold, {
Size = uDim2New(0, 60, 0, 18),
Position = uDim2New(1, -72, 0, 8),
TextXAlignment = Enum.TextXAlignment.Right,
ZIndex = 41,
})
local Frame2 = v225("Frame", {
Size = uDim2New(1, -24, 0, 6),
Position = uDim2New(0, 12, 0, 34),
BackgroundColor3 = T.Off,
BorderSizePixel = 0,
ZIndex = 41,
}, Frame)
v226(Frame2, 3)
local Frame3 = v225("Frame", {
Size = uDim2New(0, 0, 1, 0),
BackgroundColor3 = t15.A,
BorderSizePixel = 0,
ZIndex = 42,
}, Frame2)
v226(Frame3, 3)
local v14299 = tonumber(p1955) or 5
if v14299 <= 0.01 then
v14299 = 5
end
local now3 = os.clock()
task.spawn(function()
while true do
if Frame.Parent then
local v14301 = math.clamp((os.clock() - now3) / v14299, 0, 1)
local v14302 = 1 - (1 - v14301) ^ 3
v14296.Text = math.floor(v14302 * 100) .. "%"
Frame3.Size = uDim2New(v14302, 0, 1, 0)
if not (v14301 >= 1) then
task.wait()
continue
end
break
end
break
end
end)
end
_G.HideStealProgressBar = function()
local v14303 = u14294
u14294 = nil
if v14303 then
v230(v14303, {
BackgroundTransparency = 1,
}, 0.15)
task.delay(0.16, function()
v14303:Destroy()
end)
end
end
local function v14304(p1956, p1957)
t15.set(p1956, t15.get(p1956) ~= true, p1957)
end
local t530 = {
Kick = function()
t15.kick()
end,
["Rejoin Job ID"] = function()
t15.rejoinJob()
if n1303 ~= 4379838 then
return
end
n2 -= 1522
n1301 += 50
n1304 += 1192
n1 -= 868
n1302 = 949869298
n1303 -= 681
(nil)[300] = nil
(nil)[301] = nil
(nil)[302] = nil
(nil)[303] = nil
(nil)[304] = nil
(nil)[305] = nil
(nil)[306] = nil
(nil)[307] = nil
(nil)[308] = nil
(nil)[309] = nil
(nil)[310] = nil
(nil)[311] = nil
(nil)[312] = nil
(nil)[313] = nil
(nil)[314] = nil
(nil)[315] = nil
(nil)[316] = nil
(nil)[317] = nil
(nil)[318] = nil
(nil)[319] = nil
(nil)[320] = nil
(nil)[321] = nil
(nil)[322] = nil
(nil)[323] = nil
(nil)[324] = nil
(nil)[325] = nil
(nil)[326] = nil
(nil)[327] = nil
(nil)[328] = nil
(nil)[329] = nil
(nil)[330] = nil
(nil)[331] = nil
(nil)[332] = nil
(nil)[333] = nil
(nil)[334] = nil
(nil)[335] = nil
(nil)[336] = nil
(nil)[337] = nil
(nil)[338] = nil
(nil)[339] = nil
(nil)[340] = nil
(nil)[341] = nil
(nil)[342] = nil
(nil)[343] = nil
(nil)[344] = nil
(nil)[345] = nil
(nil)[346] = nil
(nil)[347] = nil
(nil)[348] = nil
(nil)[349] = nil
(nil)[350] = nil
(nil)[351] = nil
(nil)[352] = nil
(nil)[353] = nil
(nil)[354] = nil
(nil)[355] = nil
(nil)[356] = nil
(nil)[357] = nil
(nil)[358] = nil
(nil)[359] = nil
(nil)[360] = nil
(nil)[361] = nil
(nil)[362] = nil
(nil)[363] = nil
(nil)[364] = nil
(nil)[365] = nil
(nil)[366] = nil
(nil)[367] = nil
(nil)[368] = nil
(nil)[369] = nil
(nil)[370] = nil
(nil)[371] = nil
(nil)[372] = nil
(nil)[373] = nil
(nil)[374] = nil
(nil)[375] = nil
(nil)[376] = nil
(nil)[377] = nil
(nil)[378] = nil
(nil)[379] = nil
(nil)[380] = nil
(nil)[381] = nil
(nil)[382] = nil
(nil)[383] = nil
(nil)[384] = nil
(nil)[385] = nil
(nil)[386] = nil
(nil)[387] = nil
(nil)[388] = nil
(nil)[389] = nil
(nil)[390] = nil
(nil)[391] = nil
(nil)[392] = nil
(nil)[393] = nil
(nil)[394] = nil
(nil)[395] = nil
(nil)[396] = nil
(nil)[397] = nil
(nil)[398] = nil
(nil)[399] = nil
(nil)[400] = nil
(nil)[401] = nil
(nil)[402] = nil
(nil)[403] = nil
(nil)[404] = nil
(nil)[405] = nil
(nil)[406] = nil
(nil)[407] = nil
(nil)[408] = nil
(nil)[409] = nil
(nil)[410] = nil
(nil)[411] = nil
(nil)[412] = nil
(nil)[413] = nil
(nil)[414] = nil
(nil)[415] = nil
(nil)[416] = nil
(nil)[417] = nil
(nil)[418] = nil
(nil)[419] = nil
(nil)[420] = nil
(nil)[421] = nil
(nil)[422] = nil
(nil)[423] = nil
(nil)[424] = nil
(nil)[425] = nil
(nil)[426] = nil
(nil)[427] = nil
(nil)[428] = nil
(nil)[429] = nil
(nil)[430] = nil
(nil)[431] = nil
(nil)[432] = nil
(nil)[433] = nil
(nil)[434] = nil
(nil)[435] = nil
(nil)[436] = nil
(nil)[437] = nil
(nil)[438] = nil
(nil)[439] = nil
(nil)[440] = nil
(nil)[441] = nil
(nil)[442] = nil
(nil)[443] = nil
(nil)[444] = nil
(nil)[445] = nil
(nil)[446] = nil
(nil)[447] = nil
(nil)[448] = nil
(nil)[449] = nil
(nil)[450] = nil
(nil)[451] = nil
(nil)[452] = nil
(nil)[453] = nil
(nil)[454] = nil
(nil)[455] = nil
(nil)[456] = nil
(nil)[457] = nil
(nil)[458] = nil
(nil)[459] = nil
(nil)[460] = nil
(nil)[461] = nil
(nil)[462] = nil
(nil)[463] = nil
(nil)[464] = nil
(nil)[465] = nil
(nil)[466] = nil
(nil)[467] = nil
(nil)[468] = nil
(nil)[469] = nil
(nil)[470] = nil
(nil)[471] = nil
(nil)[472] = nil
(nil)[473] = nil
(nil)[474] = nil
(nil)[475] = nil
(nil)[476] = nil
(nil)[477] = nil
(nil)[478] = nil
(nil)[479] = nil
(nil)[480] = nil
(nil)[481] = nil
(nil)[482] = nil
(nil)[483] = nil
(nil)[484] = nil
(nil)[485] = nil
(nil)[486] = nil
(nil)[487] = nil
(nil)[488] = nil
(nil)[489] = nil
(nil)[490] = nil
(nil)[491] = nil
(nil)[492] = nil
(nil)[493] = nil
(nil)[494] = nil
(nil)[495] = nil
(nil)[496] = nil
(nil)[497] = nil
(nil)[498] = nil
(nil)[499] = nil
(nil)[500] = nil
(nil)[501] = nil
(nil)[502] = nil
(nil)[503] = nil
(nil)[504] = nil
(nil)[505] = nil
(nil)[506] = nil
(nil)[507] = nil
(nil)[508] = nil
(nil)[509] = nil
(nil)[510] = nil
(nil)[511] = nil
(nil)[512] = nil
(nil)[513] = nil
(nil)[514] = nil
(nil)[515] = nil
(nil)[516] = nil
(nil)[517] = nil
(nil)[518] = nil
(nil)[519] = nil
(nil)[520] = nil
(nil)[521] = nil
(nil)[522] = nil
(nil)[523] = nil
(nil)[524] = nil
(nil)[525] = nil
(nil)[526] = nil
(nil)[527] = nil
(nil)[528] = nil
(nil)[529] = nil
(nil)[530] = nil
(nil)[531] = nil
(nil)[532] = nil
(nil)[533] = nil
(nil)[534] = nil
(nil)[535] = nil
(nil)[536] = nil
(nil)[537] = nil
(nil)[538] = nil
(nil)[539] = nil
(nil)[540] = nil
(nil)[541] = nil
(nil)[542] = nil
(nil)[543] = nil
(nil)[544] = nil
(nil)[545] = nil
(nil)[546] = nil
(nil)[547] = nil
(nil)[548] = nil
(nil)[549] = nil
(nil)[550] = nil
(nil)[551] = nil
(nil)[552] = nil
(nil)[553] = nil
(nil)[554] = nil
(nil)[555] = nil
(nil)[556] = nil
(nil)[557] = nil
(nil)[558] = nil
(nil)[559] = nil
(nil)[560] = nil
(nil)[561] = nil
(nil)[562] = nil
(nil)[563] = nil
(nil)[564] = nil
(nil)[565] = nil
(nil)[566] = nil
(nil)[567] = nil
(nil)[568] = nil
(nil)[569] = nil
(nil)[570] = nil
(nil)[571] = nil
(nil)[572] = nil
(nil)[573] = nil
(nil)[574] = nil
(nil)[575] = nil
(nil)[576] = nil
(nil)[577] = nil
(nil)[578] = nil
(nil)[579] = nil
(nil)[580] = nil
(nil)[581] = nil
(nil)[582] = nil
(nil)[583] = nil
(nil)[584] = nil
(nil)[585] = nil
(nil)[586] = nil
(nil)[587] = nil
(nil)[588] = nil
(nil)[589] = nil
(nil)[590] = nil
(nil)[591] = nil
(nil)[592] = nil
(nil)[593] = nil
(nil)[594] = nil
(nil)[595] = nil
(nil)[596] = nil
(nil)[597] = nil
(nil)[598] = nil
(nil)[599] = nil
(nil)[600] = nil
(nil)[601] = nil
(nil)[602] = nil
(nil)[603] = nil
(nil)[604] = nil
(nil)[605] = nil
(nil)[606] = nil
(nil)[607] = nil
(nil)[608] = nil
(nil)[609] = nil
(nil)[610] = nil
(nil)[611] = nil
(nil)[612] = nil
(nil)[613] = nil
(nil)[614] = nil
(nil)[615] = nil
(nil)[616] = nil
(nil)[617] = nil
(nil)[618] = nil
(nil)[619] = nil
(nil)[620] = nil
(nil)[621] = nil
(nil)[622] = nil
(nil)[623] = nil
(nil)[624] = nil
(nil)[625] = nil
(nil)[626] = nil
(nil)[627] = nil
(nil)[628] = nil
(nil)[629] = nil
(nil)[630] = nil
(nil)[631] = nil
(nil)[632] = nil
(nil)[633] = nil
(nil)[634] = nil
(nil)[635] = nil
(nil)[636] = nil
(nil)[637] = nil
(nil)[638] = nil
(nil)[639] = nil
(nil)[640] = nil
(nil)[641] = nil
(nil)[642] = nil
(nil)[643] = nil
(nil)[644] = nil
(nil)[645] = nil
(nil)[646] = nil
(nil)[647] = nil
(nil)[648] = nil
(nil)[649] = nil
(nil)[650] = nil
(nil)[651] = nil
(nil)[652] = nil
(nil)[653] = nil
(nil)[654] = nil
(nil)[655] = nil
(nil)[656] = nil
(nil)[657] = nil
(nil)[658] = nil
(nil)[659] = nil
(nil)[660] = nil
(nil)[661] = nil
(nil)[662] = nil
(nil)[663] = nil
(nil)[664] = nil
(nil)[665] = nil
(nil)[666] = nil
(nil)[667] = nil
(nil)[668] = nil
(nil)[669] = nil
(nil)[670] = nil
(nil)[671] = nil
(nil)[672] = nil
(nil)[673] = nil
(nil)[674] = nil
(nil)[675] = nil
(nil)[676] = nil
(nil)[677] = nil
(nil)[678] = nil
(nil)[679] = nil
(nil)[680] = nil
(nil)[681] = nil
(nil)[682] = nil
(nil)[683] = nil
(nil)[684] = nil
(nil)[685] = nil
(nil)[686] = nil
(nil)[687] = nil
(nil)[688] = nil
(nil)[689] = nil
(nil)[690] = nil
(nil)[691] = nil
(nil)[692] = nil
(nil)[693] = nil
(nil)[694] = nil
(nil)[695] = nil
(nil)[696] = nil
(nil)[697] = nil
(nil)[698] = nil
(nil)[699] = nil
(nil)[700] = nil
(nil)[701] = nil
(nil)[702] = nil
(nil)[703] = nil
(nil)[704] = nil
(nil)[705] = nil
(nil)[706] = nil
(nil)[707] = nil
(nil)[708] = nil
(nil)[709] = nil
(nil)[710] = nil
(nil)[711] = nil
(nil)[712] = nil
(nil)[713] = nil
(nil)[714] = nil
(nil)[715] = nil
(nil)[716] = nil
(nil)[717] = nil
(nil)[718] = nil
(nil)[719] = nil
(nil)[720] = nil
(nil)[721] = nil
(nil)[722] = nil
(nil)[723] = nil
(nil)[724] = nil
(nil)[725] = nil
(nil)[726] = nil
(nil)[727] = nil
(nil)[728] = nil
(nil)[729] = nil
(nil)[730] = nil
(nil)[731] = nil
(nil)[732] = nil
(nil)[733] = nil
(nil)[734] = nil
(nil)[735] = nil
(nil)[736] = nil
(nil)[737] = nil
(nil)[738] = nil
(nil)[739] = nil
(nil)[740] = nil
(nil)[741] = nil
(nil)[742] = nil
(nil)[743] = nil
(nil)[744] = nil
(nil)[745] = nil
(nil)[746] = nil
(nil)[747] = nil
(nil)[748] = nil
(nil)[749] = nil
(nil)[750] = nil
(nil)[751] = nil
(nil)[752] = nil
(nil)[753] = nil
(nil)[754] = nil
(nil)[755] = nil
(nil)[756] = nil
(nil)[757] = nil
(nil)[758] = nil
(nil)[759] = nil
(nil)[760] = nil
(nil)[761] = nil
(nil)[762] = nil
(nil)[763] = nil
(nil)[764] = nil
(nil)[765] = nil
(nil)[766] = nil
(nil)[767] = nil
(nil)[768] = nil
(nil)[769] = nil
(nil)[770] = nil
(nil)[771] = nil
(nil)[772] = nil
(nil)[773] = nil
(nil)[774] = nil
(nil)[775] = nil
(nil)[776] = nil
(nil)[777] = nil
(nil)[778] = nil
(nil)[779] = nil
(nil)[780] = nil
(nil)[781] = nil
(nil)[782] = nil
(nil)[783] = nil
(nil)[784] = nil
(nil)[785] = nil
(nil)[786] = nil
(nil)[787] = nil
(nil)[788] = nil
(nil)[789] = nil
(nil)[790] = nil
(nil)[791] = nil
(nil)[792] = nil
(nil)[793] = nil
(nil)[794] = nil
(nil)[795] = nil
(nil)[796] = nil
(nil)[797] = nil
(nil)[798] = nil
(nil)[799] = nil
(nil)[800] = nil
(nil)[801] = nil
(nil)[802] = nil
(nil)[803] = nil
(nil)[804] = nil
(nil)[805] = nil
(nil)[806] = nil
(nil)[807] = nil
(nil)[808] = nil
(nil)[809] = nil
(nil)[810] = nil
return (nil)()
end,
Clone = function()
t15.hook("Clone")
end,
["Manual TP"] = function()
t15.hook("Manual TP")
if not (n1 < n1302) then
n1303 -= 616
n1 -= 1483
n1301 -= 1955
n1302 = 194642323
n1304 = 671773690
n2 = 212341208
(nil)[nil] = nil
end
end,
["Invisible Steal"] = function()
v14304("InvisibleSteal", "Invisible Steal")
end,
WalkSpeed = function()
v14304("WalkSpeedEnabled", "WalkSpeed")
end,
Proximity = function()
v14304("ProximityAP", "Proximity")
end,
["Carpet Boost"] = function()
v14304("CarpetSpeed", "Carpet Speed")
end,
["Ragdoll Self"] = function()
t15.hook("Ragdoll Self")
end,
["Drop Brainrot"] = function()
t15.hook("Drop Brainrot")
end,
Float = function()
v14304("Float", "Float")
end,
Reset = function()
t15.hook("Reset")
end,
["Auto Buy"] = function()
v14304("AutoBuyEnabled", "Auto Buy")
if not (n1301 < n2) then
n1301 = 172738474
n1 += 1545
n1303 -= 1550
n1302 = 371357966
n2 += 637
n1304 = 785541322
end
end,
["Click to AP"] = function()
v14304("ClickToAP", "Click to AP")
if n1301 ~= 328609123 then
n1302 = 474067224
n1301 = 644450054
n2 += 1359
n1304 += 1431
n1 = 109934531
n1303 = 300589920
upv346[nil] = nil
end
end,
}
v222(UserInputService.InputBegan, function(p1958, p1959)
if p1959 or t15.capturing or p1958.UserInputType ~= Enum.UserInputType.Keyboard then
return
end
local Name = p1958.KeyCode.Name
if Name == t15.key("Open Menu") then
if t15.built and t15.toggleMain then
t15.toggleMain()
else
t15.wantUI = true
end
return
end
for _, key in ipairs(t15.KEYS) do
local v14309 = t530[key[1]]
if v14309 and t15.key(key[1]) == Name then
pcall(v14309)
end
end
end)
t15.setAccent("Pink")
t15.refreshAll()
local n1319
_G.SXE_UI = {
Config = C,
Get = t15.get,
Set = function(p1960, p1961, p1962)
t15.set(p1960, p1961, p1962)
end,
Show = function(p1963)
if t15.built and t15.showMain then
t15.showMain(p1963)
elseif p1963 then
t15.wantUI = true
end
end,
Toggle = function()
n1319 = 614236252
if t15.built and t15.toggleMain then
t15.toggleMain()
if not (n2 < n1319) then
n1304 = 48684499
n2 += 1515
n1319 += 1439
n1 = 359189617
n1301 += 400
n1302 = 373082880
n1303 += 1311
end
else
t15.wantUI = true
if not (n2 < n1319) then
n1304 = 48684499
n2 += 1515
n1319 += 1439
n1 = 359189617
n1301 += 400
n1302 = 373082880
n1303 += 1311
end
end
end,
ShowAlert = t15.showAlert,
Accent = t15.setAccent,
Gui = t15.sg,
Import = function(p1964)
if t15.importConfig then
return t15.importConfig(p1964)
end
return false
end,
}
task.spawn(function()
local X = t15.X
local now3 = os.clock()
while os.clock() - now3 < 5 and not t15.wantUI do
task.wait(0.05)
end
t15.newBinds = {}
t15.building = true
for _, v in ipairs({
t15.equeue,
t15.queue,
}) do
for _, v2 in ipairs(v) do
if not X.Live() then
return
end
local ok, result = pcall(v2)
if not ok then
warn("[SXE UI] " .. tostring(result))
end
task.wait()
end
end
local newBinds = t15.newBinds
t15.newBinds = nil
t15.building = false
for i, newBind in ipairs(newBinds) do
pcall(newBind[2], t15.get(newBind[1]))
if i % 10 == 0 then
task.wait()
end
end
if t15.actionsRebuild then
t15.actionsRebuild()
end
if t15.pickTab then
t15.pickTab(C.LastTab or "Auto TP")
end
if t15.showMain then
t15.showMain(t15.wantUI == true or not C.AutoCloseOnExec)
end
t15.built = true
X.Late = true
t15.ready = true
end)
end
v248()
end
runApplication()