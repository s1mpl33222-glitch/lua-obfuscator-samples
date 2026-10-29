--[[ ==========================================================================
SussyXDD Intro — v12 "IMPACT"
Possession + Glitch Aura + Cinematic Cutscene (Local Only)

=== อัปเกรดจาก v11 ===
• SHAKE ใหม่หมด : trauma-based (trauma^exponent + decay) + Perlin 2 octave
+ directional impulse (damped oscillator) + FOV shake + roll kick
• HIT-STOP : freeze frame ตอนระเบิด แล้วค่อยไหลเข้า slow-motion
• CAMERA : dolly zoom (vertigo), whip-pan + motion blur pulse,
anticipation pull-back, rack focus (DOF), shot blending
• WORLD FX : shockwave sphere, ground cracks, ring stack, debris + trail
• SCREEN FX : speed lines, RGB fringe, impact flash 2 ชั้น, bloom จริง
• RIG : pose additive noise ตาม charge, hand lights, recoil jolt
• ACCESSIBILITY : CFG.SHAKE.MASTER / REDUCED_MOTION ลด-ปิดการสั่นได้
• ROBUSTNESS : Maid cleanup, กันกล้องชนกัน, กัน respawn, adaptive quality
========================================================================== ]]

-- Run intro only once on this executor/device.
-- The JSON is saved in the executor's local filesystem, NOT Workspace or Roblox game files.
local HttpService = game:GetService("HttpService")
local INTRO_FOLDER = "SussyXDD"
local INTRO_FILE = INTRO_FOLDER .. "/intro_state.json"
local INTRO_KEY = "SussyXDD_Intro_v12_Executed"

if _G.__SussyXDD_Intro_Running then return end


-- Requires executor file APIs (isfile/readfile/writefile/makefolder).
local __introFileApis = type(isfile) == "function" and type(readfile) == "function" and
   type(writefile) == "function" and type(makefolder) == "function"
if not __introFileApis then
    warn("[SussyXDD Intro] Executor file APIs unavailable; intro may repeat.")
end

local savedState = {}
if isfile(INTRO_FILE) then
    local okRead, raw = pcall(readfile, INTRO_FILE)
    if okRead and type(raw) == "string" and raw ~= "" then
        local okDecode, decoded = pcall(function()
            return HttpService:JSONDecode(raw)
        end)
        if okDecode and type(decoded) == "table" then
            savedState = decoded
        end
    end
end

-- Already executed on this device: exit without running the intro again.
local __introWasAlreadyPlayed = savedState[INTRO_KEY] == true
if not __introWasAlreadyPlayed then

-- Create the executor-local folder and persist the flag BEFORE the intro starts.
if __introFileApis then
    if not isfolder or not isfolder(INTRO_FOLDER) then
        pcall(makefolder, INTRO_FOLDER)
    end
    savedState[INTRO_KEY] = true
    savedState.executedAt = os.time()
    local okWrite, writeErr = pcall(function()
        writefile(INTRO_FILE, HttpService:JSONEncode(savedState))
    end)
    if not okWrite then
        warn("[SussyXDD Intro] Could not save local state: " .. tostring(writeErr))
    end
end

_G.__SussyXDD_Intro_Running = true

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TextService = game:GetService("TextService")
local UserInput = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")

-- ============================ CONFIG =====================================
local CFG = {
TITLE_TEXT = "SussyXDD",
SUB_TEXT = "WALL HOP SCRIPT",

LOAD_TIME = 2.9,
HOLD_GREEN = 1.15,
HOVER_LEN = 1.45,
GATHER_LEN = 2.05,
RAMP_TIME = 0.90,
AURA_LEN = 1.20,
AURA_GLITCH = 0.62,

RAINBOW_SPD = 0.35,
TITLE_SIZE = 78,
SUB_SIZE = 21,
TITLE_FONT = Enum.Font.GothamBlack,
SUB_FONT = Enum.Font.Code,

SWEEP_TIME = 0.58,
FADE_TITLE = 0.32,
FADE_SUB = 0.24,

PULL = 1150,
ORBIT = 330,

ENABLE_SFX = false,
SFX = {
charge = "rbxassetid://0",
burst = "rbxassetid://0",
whoosh = "rbxassetid://0",
},

-- ---------------------- CAMERA SHAKE ----------------------
SHAKE = {
MASTER = 1.00, -- คูณรวมทุกการสั่น (0 = ปิด)
REDUCED_MOTION = false, -- true = เหลือแค่หมุนเบา ๆ ไม่ขยับตำแหน่ง

DECAY = 1.25, -- trauma ลดต่อวินาที (1.25 = เต็ม→0 ใน 0.8s)
EXPONENT = 2.20, -- ยิ่งสูง ยิ่งกระชาก (2-3 กำลังดี)
MAX_ANGLE = 7.0, -- องศาสูงสุดตอน trauma เต็ม
MAX_TRANS = 1.45, -- studs สูงสุดตอน trauma เต็ม
NOISE_SPEED = 24, -- ความถี่การสั่น
FOV_SHAKE = 3.4, -- FOV แกว่งตอน trauma เต็ม

TRAUMA_BURST = 1.00, -- ระเบิดใหญ่
TRAUMA_ANTIC = 0.30, -- ก่อนระเบิด
TRAUMA_CHARGE = 0.34, -- เพดานรัมเบิลตอนชาร์จ
TRAUMA_ABSORB = 0.045, -- ต่อ 1 digit ที่ถูกดูด
},

HITSTOP = {
ENABLED = true,
LEN = 0.075, -- วินาที (เวลาจริง)
SCALE = 0.015, -- ความเร็วเวลาช่วง freeze
},

-- ---------------------- CUTSCENE ----------------------
CINEMA = {
ENABLED = true,
LOCAL_RIG = true,
HIDE_REAL = true,
LOCK_MOVE = true,
WORLD_FX = true,
DOF = true,
BLOOM = true,

LETTERBOX = 0.115,

FOV_WIDE = 64,
FOV_TENSE = 46,
FOV_PUNCH = 102,
FOV_AFTER = 68,

DIST_WIDE = 15.5,
DIST_TENSE = 6.4,
DIST_BURST = 9.8,
DIST_AFTER = 16.5,

FLOAT_H = 2.7,
SPIN_SPD = 0.85,

SLOWMO = 0.30,
SLOWMO_LEN = 0.62,

SNAP_YAW = 2.25,
PUSH_LEAD = 0.50,
ANTIC_LEAD = 0.16, -- ถอยกล้องกลืนลมหายใจก่อนระเบิด
},
}

local GREEN = Color3.fromRGB(0, 255, 130)
local GREEN_DIM = Color3.fromRGB(0, 168, 88)
local GREEN_LT = Color3.fromRGB(195, 255, 222)
local WHITE = Color3.new(1, 1, 1)
local SCRAMBLE = "01<>/\#$%&*XZK101"

local TITLE_Y, LINE_Y, SUB_Y, BAR_Y, PCT_Y = -46, 18, 54, 96, 118
-- =========================================================================

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
while not camera do task.wait() camera = workspace.CurrentCamera end

local vp0 = camera.ViewportSize
local touch = UserInput.TouchEnabled and not UserInput.KeyboardEnabled
local LOW = touch or (vp0.X * vp0.Y) < 800000

local Q = {
particles = LOW and 22 or 46,
rain = LOW and 14 or 30,
sparkles = LOW and 24 or 48,
digits = LOW and 140 or 230,
speed = LOW and 14 or 34,
tCols = LOW and 2 or 3,
tRows = LOW and 3 or 4,
sCols = LOW and 1 or 2,
sRows = LOW and 2 or 2,
ghosts = not LOW,
subGlow = not LOW,
grid = not LOW,
sweepCRT = not LOW,
trails = not LOW,
blur = LOW and 12 or 26,
colorHz = LOW and 30 or 60,
rings = LOW and 1 or 3,
auraRate = LOW and 0.055 or 0.030,
debris = LOW and 8 or 18,
cracks = LOW and 5 or 11,
}

-- ============================ MATH / UTIL ================================
local sin, cos, sqrt, exp, floor, abs = math.sin, math.cos, math.sqrt, math.exp, math.floor, math.abs
local rnd, noise, pi, rad, deg = math.random, math.noise, math.pi, math.rad, math.deg
local atan, tan, clampN = math.atan, math.tan, math.clamp

local function clamp01(x) return x < 0 and 0 or (x > 1 and 1 or x) end
local function smooth(x) return x * x * (3 - 2 * x) end
local function expoOut(x) return x >= 1 and 1 or 1 - 2 ^ (-10 * x) end
local function backOut(x)
local c1, c3 = 1.70158, 2.70158
local u = x - 1
return 1 + c3 * u * u * u + c1 * u * u
end
local function damp(cur, target, lambda, dt)
return target + (cur - target) * exp(-lambda * dt)
end
local function ang(x, y, z)
return CFrame.Angles(rad(x or 0), rad(y or 0), rad(z or 0))
end

local Spring = {}
Spring.__index = Spring
function Spring.new(value, freq, zeta)
return setmetatable({ p = value, v = 0, f = freq or 4, z = zeta or 0.75 }, Spring)
end
function Spring:step(dt, target)
local w = 2 * pi * self.f
local a = -2 * self.z * w * self.v - w * w * (self.p - target)
self.v = self.v + a * dt
self.p = self.p + self.v * dt
return self.p
end

local function corner(inst, scale)
local c = Instance.new("UICorner")
c.CornerRadius = UDim.new(scale or 1, 0)
c.Parent = inst
return c
end

local RAY_EXCLUDE do
local ok, e = pcall(function() return Enum.RaycastFilterType.Exclude end)
RAY_EXCLUDE = ok and e or Enum.RaycastFilterType.Blacklist
end

-- ---------------------------- MAID ---------------------------------------
local Maid = { tasks = {} }
function Maid:give(x) self.tasks[#self.tasks + 1] = x return x end
function Maid:sweep()
for i = #self.tasks, 1, -1 do
local x = self.tasks[i]
self.tasks[i] = nil
pcall(function()
if typeof(x) == "RBXScriptConnection" then x:Disconnect()
elseif typeof(x) == "Instance" then x:Destroy()
elseif typeof(x) == "function" then x() end
end)
end
end

-- ============================ CLEAN OLD ==================================
local hostGui = CoreGui
pcall(function()
if typeof(gethui) == "function" then hostGui = gethui() end
end)

for _, root in ipairs({ CoreGui, hostGui }) do
local old = root:FindFirstChild("SussyXDD_Intro")
if old then old:Destroy() end
end
for _, n in ipairs({ "SussyXDD_Blur", "SussyXDD_CC", "SussyXDD_DOF", "SussyXDD_Bloom" }) do
local o = Lighting:FindFirstChild(n)
if o then o:Destroy() end
end
pcall(function()
local oldFX = camera:FindFirstChild("SussyXDD_WorldFX")
if oldFX then oldFX:Destroy() end
local oldRig = camera:FindFirstChild("SussyXDD_Rig")
if oldRig then oldRig:Destroy() end
end)
for _, n in ipairs({ "SussyXDD_Camera", "SussyXDD_Shake" }) do
pcall(function() RunService:UnbindFromRenderStep(n) end)
end

-- ============================ LIGHTING FX ================================
local blur = Instance.new("BlurEffect")
blur.Name = "SussyXDD_Blur"
blur.Size = 0
blur.Parent = Lighting
Maid:give(blur)
TweenService:Create(blur, TweenInfo.new(0.75, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
{ Size = Q.blur }):Play()

local cc = Instance.new("ColorCorrectionEffect")
cc.Name = "SussyXDD_CC"
cc.Brightness, cc.Contrast, cc.Saturation = 0, 0, 0
cc.TintColor = WHITE
cc.Parent = Lighting
Maid:give(cc)
TweenService:Create(cc, TweenInfo.new(0.85), { Contrast = 0.09, Saturation = 0.13 }):Play()

local bloom
if CFG.CINEMA.BLOOM and not LOW then
pcall(function()
bloom = Instance.new("BloomEffect")
bloom.Name = "SussyXDD_Bloom"
bloom.Intensity = 0
bloom.Size = 24
bloom.Threshold = 1.1
bloom.Parent = Lighting
Maid:give(bloom)
end)
end

local dof
if CFG.CINEMA.DOF and not LOW then
pcall(function()
dof = Instance.new("DepthOfFieldEffect")
dof.Name = "SussyXDD_DOF"
dof.FocusDistance = 14
dof.InFocusRadius = 22
dof.NearIntensity = 0
dof.FarIntensity = 0
dof.Enabled = false
dof.Parent = Lighting
Maid:give(dof)
end)
end

-- =========================================================================
-- ============================ SHAKE ENGINE ===============================
-- =========================================================================
-- trauma model : เก็บค่า trauma 0..1 → shake = trauma^exponent
-- + Perlin 2 octave (ไม่เป็นจังหวะซ้ำ) + directional impulse (กระแทกมีทิศ)
local Shk = {
trauma = 0,
t = 0,
impulses = {},
fovOsc = { a = 0, f = 0, d = 0, age = 0, live = false },
seed = { rnd() * 941, rnd() * 733, rnd() * 617, rnd() * 449, rnd() * 281, rnd() * 197 },
master = CFG.SHAKE.MASTER,
reduced = CFG.SHAKE.REDUCED_MOTION,
}

function Shk:add(v, cap)
if self.master <= 0 then return end
cap = cap or 1
local nt = self.trauma + v
if nt > cap then nt = math.max(self.trauma, cap) end
self.trauma = clamp01(nt)
end

-- dir = ทิศในสเปซกล้อง (Vector3 หน่วย), power = studs, freq = Hz*2pi, dmp = decay
function Shk:impulse(dir, power, freq, dmp, roll)
if self.master <= 0 then return end
self.impulses[#self.impulses + 1] = {
dir = dir.Unit, p = power, f = freq or 42, d = dmp or 11,
roll = roll or 0, age = 0, life = 5 / (dmp or 11),
}
end

function Shk:fovKick(amount, freq, dmp)
self.fovOsc = { a = amount, f = freq or 34, d = dmp or 9, age = 0, live = true }
end

function Shk:oct(idx, nt)
local s = self.seed[idx]
return (noise(nt, s) * 1.0 + noise(nt * 2.37, s + 51.3) * 0.42) * 1.55
end

-- คืน (Vector3 offset, Vector3 angles(rad), number fovOffset)
function Shk:step(dt)
self.t = self.t + dt
self.trauma = math.max(0, self.trauma - CFG.SHAKE.DECAY * dt)

local pos, rot, fov = Vector3.zero, Vector3.zero, 0
local m = self.master
if m <= 0 then return pos, rot, fov end

local s = (self.trauma ^ CFG.SHAKE.EXPONENT) * m
if s > 0.0002 then
local nt = self.t * CFG.SHAKE.NOISE_SPEED
local ax = self:oct(1, nt) * rad(CFG.SHAKE.MAX_ANGLE) * s
local ay = self:oct(2, nt) * rad(CFG.SHAKE.MAX_ANGLE) * s
local az = self:oct(3, nt) * rad(CFG.SHAKE.MAX_ANGLE) * s * 0.85
rot = Vector3.new(ax, ay, az)
if not self.reduced then
pos = Vector3.new(
self:oct(4, nt) * CFG.SHAKE.MAX_TRANS * s,
self:oct(5, nt) * CFG.SHAKE.MAX_TRANS * s,
self:oct(6, nt) * CFG.SHAKE.MAX_TRANS * s * 0.45
)
end
fov = self:oct(1, nt * 0.7) * CFG.SHAKE.FOV_SHAKE * s
end

for i = #self.impulses, 1, -1 do
local k = self.impulses[i]
k.age = k.age + dt
if k.age >= k.life then
table.remove(self.impulses, i)
else
local e = exp(-k.d * k.age) * sin(k.f * k.age)
if not self.reduced then
pos = pos + k.dir * (k.p * e * m)
end
rot = rot + Vector3.new(-k.dir.Y * 0.06, k.dir.X * 0.06, k.roll) * (k.p * e * m)
end
end

local fo = self.fovOsc
if fo.live then
fo.age = fo.age + dt
local e = exp(-fo.d * fo.age)
if e < 0.01 then fo.live = false else
fov = fov + fo.a * e * cos(fo.f * fo.age) * m
end
end

return pos, rot, fov
end

-- ============================ SCREEN GUI =================================
local gui = Instance.new("ScreenGui")
gui.Name = "SussyXDD_Intro"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() gui.ScreenInsets = Enum.ScreenInsets.None end)

if not pcall(function() gui.Parent = hostGui end) then
gui.Parent = player:WaitForChild("PlayerGui")
end
Maid:give(gui)

local root, canvasGroup
if not LOW then
pcall(function()
local cg = Instance.new("CanvasGroup")
cg.Size = UDim2.fromScale(1, 1)
cg.BackgroundTransparency = 1
cg.BorderSizePixel = 0
cg.GroupTransparency = 0
cg.Parent = gui
canvasGroup = cg
root = cg
end)
end
if not root then
local f = Instance.new("Frame")
f.Size = UDim2.fromScale(1, 1)
f.BackgroundTransparency = 1
f.BorderSizePixel = 0
f.Parent = gui
root = f
end

local function fullFrame(parent, z)
local f = Instance.new("Frame")
f.Size = UDim2.new(1, 80, 1, 80)
f.Position = UDim2.fromOffset(-40, -40)
f.BackgroundTransparency = 1
f.BorderSizePixel = 0
f.ZIndex = z
f.Parent = parent
return f
end

-- ============================ LETTERBOX ==================================
local function mkBar(anchorY)
local b = Instance.new("Frame")
b.AnchorPoint = Vector2.new(0, anchorY)
b.Size = UDim2.new(1, 0, 0, 0)
b.Position = UDim2.fromScale(0, anchorY)
b.BackgroundColor3 = Color3.new(0, 0, 0)
b.BorderSizePixel = 0
b.ZIndex = 60
b.Parent = gui
local edge = Instance.new("Frame")
edge.AnchorPoint = Vector2.new(0, anchorY == 0 and 1 or 0)
edge.Position = UDim2.fromScale(0, anchorY == 0 and 1 or 0)
edge.Size = UDim2.new(1, 0, 0, 1)
edge.BackgroundColor3 = GREEN
edge.BackgroundTransparency = 0.75
edge.BorderSizePixel = 0
edge.ZIndex = 61
edge.Parent = b
return b
end
local barTop, barBot = mkBar(0), mkBar(1)

local function letterbox(on, dur)
local h = on and CFG.CINEMA.LETTERBOX or 0
local ti = TweenInfo.new(dur or 0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
TweenService:Create(barTop, ti, { Size = UDim2.new(1, 0, h, 0) }):Play()
TweenService:Create(barBot, ti, { Size = UDim2.new(1, 0, h, 0) }):Play()
end

-- ============================ BACKGROUND =================================
local dim = fullFrame(root, 1)
dim.BackgroundColor3 = Color3.fromRGB(4, 6, 9)
TweenService:Create(dim, TweenInfo.new(0.75), { BackgroundTransparency = 0.24 }):Play()

local halo = fullFrame(root, 2)
halo.BackgroundColor3 = Color3.fromRGB(0, 42, 31)
halo.BackgroundTransparency = 1
local haloGrad = Instance.new("UIGradient")
haloGrad.Rotation = 90
haloGrad.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 1),
NumberSequenceKeypoint.new(0.5, 0.52),
NumberSequenceKeypoint.new(1, 1),
})
haloGrad.Parent = halo
TweenService:Create(halo, TweenInfo.new(1.0), { BackgroundTransparency = 0.55 }):Play()

local vignette = {}
do
local defs = {
{ UDim2.new(1, 80, 0, 260), UDim2.fromOffset(-40, -40), 90 },
{ UDim2.new(1, 80, 0, 260), UDim2.new(0, -40, 1, -220), 270 },
{ UDim2.new(0, 300, 1, 80), UDim2.fromOffset(-40, -40), 0 },
{ UDim2.new(0, 300, 1, 80), UDim2.new(1, -260, 0, -40), 180 },
}
for _, d in ipairs(defs) do
local f = Instance.new("Frame")
f.Size, f.Position = d[1], d[2]
f.BackgroundColor3 = Color3.new(0, 0, 0)
f.BackgroundTransparency = 1
f.BorderSizePixel = 0
f.ZIndex = 18
f.Parent = root
local g = Instance.new("UIGradient")
g.Rotation = d[3]
g.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.25),
NumberSequenceKeypoint.new(1, 1),
})
g.Parent = f
vignette[#vignette + 1] = f
TweenService:Create(f, TweenInfo.new(1.0), { BackgroundTransparency = 0.15 }):Play()
end
end

local gridLayer, gridLines = nil, {}
local GRID = 96
local function buildGrid()
if not Q.grid then return end
if gridLayer then gridLayer:Destroy() end
gridLines = {}
local vp = camera.ViewportSize
gridLayer = Instance.new("Frame")
gridLayer.Size = UDim2.new(1, GRID * 2, 1, GRID * 2)
gridLayer.BackgroundTransparency = 1
gridLayer.BorderSizePixel = 0
gridLayer.ZIndex = 3
gridLayer.Parent = root
for i = 0, math.ceil(vp.X / GRID) + 2 do
local v = Instance.new("Frame")
v.Size = UDim2.new(0, 1, 1, 0)
v.Position = UDim2.fromOffset(i * GRID, 0)
v.BackgroundColor3 = WHITE
v.BackgroundTransparency = 0.95
v.BorderSizePixel = 0
v.Parent = gridLayer
gridLines[#gridLines + 1] = v
end
for i = 0, math.ceil(vp.Y / GRID) + 2 do
local h = Instance.new("Frame")
h.Size = UDim2.new(1, 0, 0, 1)
h.Position = UDim2.fromOffset(0, i * GRID)
h.BackgroundColor3 = WHITE
h.BackgroundTransparency = 0.95
h.BorderSizePixel = 0
h.Parent = gridLayer
gridLines[#gridLines + 1] = h
end
end
buildGrid()

local crt
if Q.sweepCRT then
crt = Instance.new("Frame")
crt.Size = UDim2.new(1, 80, 0, 170)
crt.Position = UDim2.new(0, -40, 0, -200)
crt.BackgroundColor3 = Color3.fromRGB(180, 255, 220)
crt.BackgroundTransparency = 0.94
crt.BorderSizePixel = 0
crt.ZIndex = 17
crt.Parent = root
local g = Instance.new("UIGradient")
g.Rotation = 90
g.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 1),
NumberSequenceKeypoint.new(0.5, 0),
NumberSequenceKeypoint.new(1, 1),
})
g.Parent = crt
end

local tears = {}
for i = 1, 4 do
local f = Instance.new("Frame")
f.Size = UDim2.new(1, 80, 0, 6)
f.Position = UDim2.fromOffset(-40, -100)
f.BackgroundColor3 = GREEN_LT
f.BackgroundTransparency = 1
f.BorderSizePixel = 0
f.ZIndex = 19
f.Parent = root
tears[i] = f
end

-- RGB fringe (ขอบจอแยกสีตอนกระแทก)
local fringeR = fullFrame(root, 21)
fringeR.BackgroundColor3 = Color3.fromRGB(255, 40, 90)
fringeR.BackgroundTransparency = 1
local fgR = Instance.new("UIGradient")
fgR.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(0.45, 1),
NumberSequenceKeypoint.new(1, 1) })
fgR.Parent = fringeR

local fringeB = fullFrame(root, 21)
fringeB.BackgroundColor3 = Color3.fromRGB(40, 190, 255)
fringeB.BackgroundTransparency = 1
local fgB = Instance.new("UIGradient")
fgB.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.55, 1),
NumberSequenceKeypoint.new(1, 0.2) })
fgB.Parent = fringeB

local particleLayer = fullFrame(root, 4)
particleLayer.ClipsDescendants = true

local speedLayer = fullFrame(root, 23)
speedLayer.ClipsDescendants = true

-- ============================ CONTAINER ==================================
local container = Instance.new("Frame")
container.AnchorPoint = Vector2.new(0.5, 0.5)
container.Position = UDim2.fromScale(0.5, 0.5)
container.Size = UDim2.fromOffset(0, 0)
container.BackgroundTransparency = 1
container.ZIndex = 6
container.Parent = root

local uiScale = Instance.new("UIScale")
uiScale.Scale = 0.80
uiScale.Parent = container

local fxLayer = Instance.new("Frame")
fxLayer.Size = UDim2.fromOffset(0, 0)
fxLayer.BackgroundTransparency = 1
fxLayer.ZIndex = 9
fxLayer.Parent = container

-- ============================ SOFT BLOOM (UI) ============================
local BLOOM_S = LOW and { 1.0, 1.9, 3.2 } or { 1.0, 1.55, 2.4, 3.7 }
local BLOOM_A = LOW and { 0.05, 0.58, 0.86 } or { 0.02, 0.44, 0.72, 0.89 }

local function softCircle(parent, z, color)
local o = { layers = {} }
local holder = Instance.new("Frame")
holder.AnchorPoint = Vector2.new(0.5, 0.5)
holder.Size = UDim2.fromOffset(0, 0)
holder.BackgroundTransparency = 1
holder.ZIndex = z
holder.Visible = false
holder.Parent = parent
for i = #BLOOM_S, 1, -1 do
local f = Instance.new("Frame")
f.AnchorPoint = Vector2.new(0.5, 0.5)
f.Position = UDim2.fromScale(0.5, 0.5)
f.Size = UDim2.fromOffset(0, 0)
f.BackgroundColor3 = color
f.BackgroundTransparency = 1
f.BorderSizePixel = 0
f.ZIndex = z + (#BLOOM_S - i)
corner(f)
f.Parent = holder
o.layers[i] = f
end
o.holder = holder
function o:setSize(px)
for i, f in ipairs(self.layers) do
local s = px * BLOOM_S[i]
f.Size = UDim2.fromOffset(s, s)
end
end
function o:setAlpha(a)
a = clamp01(a)
for i, f in ipairs(self.layers) do
f.BackgroundTransparency = 1 - (1 - BLOOM_A[i]) * a
end
end
function o:setColor(c)
for _, f in ipairs(self.layers) do f.BackgroundColor3 = c end
end
function o:setPos(p) self.holder.Position = p end
function o:setVisible(v) self.holder.Visible = v end
return o
end

-- ============================ TEXT BUILD =================================
local function buildLine(text, cfg)
local widths, total = {}, 0
for i = 1, #text do
local ch = text:sub(i, i)
local w = (ch == " ") and cfg.size * 0.42
or TextService:GetTextSize(ch, cfg.size, cfg.font, Vector2.new(2000, 400)).X
w = w + cfg.spacing
widths[i] = w
total = total + w
end

local set, x = {}, -total / 2
for i = 1, #text do
local ch = text:sub(i, i)
if ch ~= " " then
local cx = x + widths[i] / 2
local function mk(add, z, col)
local l = Instance.new("TextLabel")
l.AnchorPoint = Vector2.new(0.5, 0.5)
l.Size = UDim2.fromOffset(widths[i] + 16, cfg.size + 22)
l.Position = UDim2.new(0.5, cx, 0.5, cfg.y + cfg.drop)
l.BackgroundTransparency = 1
l.Text = ch
l.Font = cfg.font
l.TextSize = cfg.size + add
l.TextTransparency = 1
l.TextColor3 = col or WHITE
l.ZIndex = z
l.Parent = container
return l
end
local o = {
char = ch, cx = cx, baseY = cfg.y, drop = cfg.drop,
w = widths[i], h = cfg.size,
sp = Spring.new(cfg.drop, 2.2 + rnd() * 0.5, 0.55),
}
if cfg.ghosts then
o.gA = mk(0, 6, Color3.fromRGB(255, 45, 95))
o.gB = mk(0, 6, Color3.fromRGB(45, 205, 255))
end
if cfg.glow then o.glow = mk(cfg.size > 40 and 12 or 6, 7) end
o.label = mk(0, 8)
o.label.TextStrokeColor3 = Color3.new(0, 0, 0)
o.label.TextStrokeTransparency = 1
set[#set + 1] = o
end
x = x + widths[i]
end
return set, total
end

local titleSet, titleW = buildLine(CFG.TITLE_TEXT, {
font = CFG.TITLE_FONT, size = CFG.TITLE_SIZE, spacing = 1,
y = TITLE_Y, drop = 40, ghosts = Q.ghosts, glow = true,
})
local subSet, subW = buildLine(CFG.SUB_TEXT, {
font = CFG.SUB_FONT, size = CFG.SUB_SIZE, spacing = 5,
y = SUB_Y, drop = 22, ghosts = false, glow = Q.subGlow,
})

local LINE_W = clampN(titleW + 30, 240, 460)
local SPAN = math.max(titleW, subW) / 2 + 26

-- ============================ LINE / BAR =================================
local line = Instance.new("Frame")
line.AnchorPoint = Vector2.new(0.5, 0.5)
line.Position = UDim2.new(0.5, 0, 0.5, LINE_Y)
line.Size = UDim2.fromOffset(0, 3)
line.BackgroundColor3 = WHITE
line.BorderSizePixel = 0
line.ClipsDescendants = true
line.ZIndex = 6
line.Parent = container
corner(line)

local lineGrad = Instance.new("UIGradient")
lineGrad.Parent = line

local streak = Instance.new("Frame")
streak.AnchorPoint = Vector2.new(0.5, 0.5)
streak.Size = UDim2.fromOffset(80, 3)
streak.BackgroundColor3 = WHITE
streak.BackgroundTransparency = 0.35
streak.BorderSizePixel = 0
streak.ZIndex = 7
streak.Parent = line

local BAR_W = clampN(titleW * 0.85, 200, 340)

local barBg = Instance.new("Frame")
barBg.AnchorPoint = Vector2.new(0.5, 0.5)
barBg.Position = UDim2.new(0.5, 0, 0.5, BAR_Y)
barBg.Size = UDim2.fromOffset(BAR_W, 6)
barBg.BackgroundColor3 = WHITE
barBg.BackgroundTransparency = 1
barBg.BorderSizePixel = 0
barBg.ZIndex = 6
barBg.Parent = container
corner(barBg)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = WHITE
barFill.BackgroundTransparency = 1
barFill.BorderSizePixel = 0
barFill.ZIndex = 7
barFill.Parent = barBg
corner(barFill)

local barGrad = Instance.new("UIGradient")
barGrad.Parent = barFill

local head = Instance.new("Frame")
head.AnchorPoint = Vector2.new(0.5, 0.5)
head.Size = UDim2.fromOffset(12, 12)
head.Position = UDim2.fromScale(0, 0.5)
head.BackgroundColor3 = WHITE
head.BackgroundTransparency = 1
head.BorderSizePixel = 0
head.ZIndex = 8
head.Parent = barBg
corner(head)

local pct = Instance.new("TextLabel")
pct.AnchorPoint = Vector2.new(0.5, 0.5)
pct.Position = UDim2.new(0.5, 0, 0.5, PCT_Y)
pct.Size = UDim2.fromOffset(200, 20)
pct.BackgroundTransparency = 1
pct.Text = "0%"
pct.Font = Enum.Font.GothamBold
pct.TextSize = 13
pct.TextColor3 = Color3.fromRGB(225, 225, 225)
pct.TextTransparency = 1
pct.ZIndex = 6
pct.Parent = container

-- ============================ SWEEP BEAM =================================
local sweep = Instance.new("Frame")
sweep.AnchorPoint = Vector2.new(0.5, 0.5)
sweep.Size = UDim2.fromOffset(3, 190)
sweep.Position = UDim2.new(0.5, -SPAN - 40, 0.5, 6)
sweep.BackgroundColor3 = WHITE
sweep.BackgroundTransparency = 1
sweep.BorderSizePixel = 0
sweep.ZIndex = 12
sweep.Visible = false
sweep.Parent = container
local sweepGrad = Instance.new("UIGradient")
sweepGrad.Rotation = 90
sweepGrad.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 1),
NumberSequenceKeypoint.new(0.5, 0),
NumberSequenceKeypoint.new(1, 1),
})
sweepGrad.Parent = sweep

local sweepGlow = Instance.new("Frame")
sweepGlow.AnchorPoint = Vector2.new(0.5, 0.5)
sweepGlow.Size = UDim2.fromOffset(56, 215)
sweepGlow.Position = sweep.Position
sweepGlow.BackgroundColor3 = GREEN
sweepGlow.BackgroundTransparency = 1
sweepGlow.BorderSizePixel = 0
sweepGlow.ZIndex = 11
sweepGlow.Visible = false
sweepGlow.Parent = container
local sgA = Instance.new("UIGradient")
sgA.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 1),
NumberSequenceKeypoint.new(0.5, 0.42),
NumberSequenceKeypoint.new(1, 1),
})
sgA.Parent = sweepGlow

-- ============================ CORE =======================================
local coreBloom = softCircle(fxLayer, 12, GREEN)
local coreDot = Instance.new("Frame")
coreDot.AnchorPoint = Vector2.new(0.5, 0.5)
coreDot.Size = UDim2.fromOffset(0, 0)
coreDot.BackgroundColor3 = WHITE
coreDot.BackgroundTransparency = 1
coreDot.BorderSizePixel = 0
coreDot.ZIndex = 16
coreDot.Visible = false
coreDot.Parent = fxLayer
corner(coreDot)

local coreRing = Instance.new("Frame")
coreRing.AnchorPoint = Vector2.new(0.5, 0.5)
coreRing.Size = UDim2.fromOffset(10, 10)
coreRing.BackgroundTransparency = 1
coreRing.BorderSizePixel = 0
coreRing.ZIndex = 15
coreRing.Visible = false
coreRing.Parent = fxLayer
corner(coreRing)
local coreStroke = Instance.new("UIStroke")
coreStroke.Color = GREEN
coreStroke.Thickness = 2
coreStroke.Transparency = 1
coreStroke.Parent = coreRing

-- ============================ RESPONSIVE =================================
local DESIGN_W = math.max(titleW, subW, LINE_W, BAR_W) + 60
local DESIGN_H = 300
local fitScale = 1
local scaleSpring = Spring.new(0.80, 1.6, 0.85)

local function updateFit()
local vp = camera.ViewportSize
local portrait = vp.Y > vp.X
local pad = portrait and 0.95 or 0.86
fitScale = clampN(math.min(vp.X / DESIGN_W, vp.Y / DESIGN_H) * pad, 0.4, 1.35)
end
updateFit()

local lastVp = camera.ViewportSize
Maid:give(camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
updateFit()
local vp = camera.ViewportSize
if abs(vp.X - lastVp.X) > GRID or abs(vp.Y - lastVp.Y) > GRID then
lastVp = vp
buildGrid()
end
end))

-- =========================================================================
-- ============================ LOCAL RIG (R6 / R15) =======================
-- =========================================================================
local POSES = {
R15 = {
idle = {
Root = ang(), Waist = ang(), Neck = ang(),
RightShoulder = ang(0, 0, 8), LeftShoulder = ang(0, 0, -8),
RightElbow = ang(6), LeftElbow = ang(6),
RightHip = ang(0, 0, 2), LeftHip = ang(0, 0, -2),
RightKnee = ang(-4), LeftKnee = ang(-4),
},
hover = {
Root = ang(9), Waist = ang(7), Neck = ang(9),
RightShoulder = ang(-16, 0, 30), LeftShoulder = ang(-16, 0, -30),
RightElbow = ang(26), LeftElbow = ang(26),
RightHip = ang(-16, 0, 7), LeftHip = ang(-9, 0, -7),
RightKnee = ang(-34), LeftKnee = ang(-16),
RightAnkle = ang(14), LeftAnkle = ang(10),
},
charge = {
Root = ang(15), Waist = ang(13), Neck = ang(15),
RightShoulder = ang(-52, 0, 24), LeftShoulder = ang(-52, 0, -24),
RightElbow = ang(92), LeftElbow = ang(92),
RightWrist = ang(-18), LeftWrist = ang(-18),
RightHip = ang(-22, 0, 10), LeftHip = ang(-14, 0, -10),
RightKnee = ang(-46), LeftKnee = ang(-26),
RightAnkle = ang(18), LeftAnkle = ang(14),
},
peak = {
Root = ang(21), Waist = ang(19), Neck = ang(23),
RightShoulder = ang(-68, 0, 18), LeftShoulder = ang(-68, 0, -18),
RightElbow = ang(110), LeftElbow = ang(110),
RightWrist = ang(-26), LeftWrist = ang(-26),
RightHip = ang(-28, 0, 12), LeftHip = ang(-20, 0, -12),
RightKnee = ang(-58), LeftKnee = ang(-34),
},
burst = {
Root = ang(10), Waist = ang(18), Neck = ang(30),
RightShoulder = ang(-24, 0, 132), LeftShoulder = ang(-24, 0, -132),
RightElbow = ang(6), LeftElbow = ang(6),
RightWrist = ang(-10), LeftWrist = ang(-10),
RightHip = ang(-8, 0, 18), LeftHip = ang(-8, 0, -18),
RightKnee = ang(-12), LeftKnee = ang(-12),
},
settle = {
Root = ang(2), Waist = ang(3), Neck = ang(4),
RightShoulder = ang(-6, 0, 16), LeftShoulder = ang(-6, 0, -16),
RightElbow = ang(14), LeftElbow = ang(14),
RightHip = ang(-2, 0, 4), LeftHip = ang(-2, 0, -4),
RightKnee = ang(-6), LeftKnee = ang(-6),
},
},

R6 = {
idle = {
RootJoint = ang(), Neck = ang(),
["Right Shoulder"] = ang(-6), ["Left Shoulder"] = ang(-6),
["Right Hip"] = ang(-2), ["Left Hip"] = ang(-2),
},
hover = {
RootJoint = ang(-7), Neck = ang(-7),
["Right Shoulder"] = ang(-26, 0, 16), ["Left Shoulder"] = ang(-26, 0, -16),
["Right Hip"] = ang(-9, 0, 16), ["Left Hip"] = ang(-9, 0, -8),
},
charge = {
RootJoint = ang(-12), Neck = ang(-14),
["Right Shoulder"] = ang(-18, 0, -46), ["Left Shoulder"] = ang(-18, 0, 46),
["Right Hip"] = ang(-11, 0, 24), ["Left Hip"] = ang(-11, 0, -14),
},
peak = {
RootJoint = ang(-17), Neck = ang(-21),
["Right Shoulder"] = ang(-24, 0, -62), ["Left Shoulder"] = ang(-24, 0, 62),
["Right Hip"] = ang(-15, 0, 32), ["Left Hip"] = ang(-15, 0, -20),
},
burst = {
RootJoint = ang(-18), Neck = ang(-32),
["Right Shoulder"] = ang(-136, 0, 8), ["Left Shoulder"] = ang(-136, 0, -8),
["Right Hip"] = ang(-15, 0, 4), ["Left Hip"] = ang(-15, 0, -4),
},
settle = {
RootJoint = ang(-3), Neck = ang(-4),
["Right Shoulder"] = ang(-14, 0, 4), ["Left Shoulder"] = ang(-14, 0, -4),
["Right Hip"] = ang(-4), ["Left Hip"] = ang(-4),
},
},
}

local Rig = {
alive = false, kind = "R15",
model = nil, root = nil, hum = nil,
joints = {}, base = {}, hash = {},
poses = nil, poseName = "idle", poseSpeed = 8,
floatCur = 0, floatGoal = 0,
spinCur = 0, spinSpeed = 0, spinGoal = nil,
tilt = 0, tiltGoal = 0,
wobble = 1, bobAmp = 1,
jolt = 0,
baseCF = nil, basePos = Vector3.zero, pivotY = 1.5,
realParts = {}, handLights = {},
savedSpeed = nil, savedJump = nil, savedJumpH = nil,
}

local function realPart()
local ch = player.Character
if not ch or not ch.Parent then return nil end
return ch:FindFirstChild("HumanoidRootPart")
or ch:FindFirstChild("UpperTorso")
or ch:FindFirstChild("Torso")
or ch:FindFirstChild("Head")
or ch.PrimaryPart
end

function Rig:collectReal()
table.clear(self.realParts)
local ch = player.Character
if not ch then return end
for _, d in ipairs(ch:GetDescendants()) do
if d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture") then
self.realParts[#self.realParts + 1] = d
end
end
end

function Rig:hideReal(v)
for i = 1, #self.realParts do
local d = self.realParts[i]
if d and d.Parent then
pcall(function() d.LocalTransparencyModifier = v end)
end
end
end

function Rig:build()
if not CFG.CINEMA.LOCAL_RIG then return false end
local ch = player.Character
if not ch then return false end
local hrp = ch:FindFirstChild("HumanoidRootPart")
local hum = ch:FindFirstChildOfClass("Humanoid")
if not hrp then return false end

self.kind = (hum and hum.RigType == Enum.HumanoidRigType.R6) and "R6" or "R15"
self.poses = POSES[self.kind]

local ok, clone = pcall(function()
local prev = ch.Archivable
ch.Archivable = true
local c = ch:Clone()
ch.Archivable = prev
return c
end)
if not ok or not clone then return false end

clone.Name = "SussyXDD_Rig"

for _, d in ipairs(clone:GetDescendants()) do
if d:IsA("LuaSourceContainer") or d:IsA("Animator") then
d:Destroy()
elseif d:IsA("BasePart") then
d.Anchored = false
d.CanCollide = false
d.CanQuery = false
d.CanTouch = false
d.Massless = true
d.CastShadow = false
elseif d:IsA("Sound") or d:IsA("BillboardGui") or d:IsA("SurfaceGui")
or d:IsA("ForceField") or d:IsA("Highlight") or d:IsA("ClickDetector") then
d:Destroy()
end
end

local ch2 = clone:FindFirstChildOfClass("Humanoid")
if ch2 then
ch2.BreakJointsOnDeath = false
ch2.RequiresNeck = false
ch2.AutoRotate = false
ch2.PlatformStand = true
ch2.WalkSpeed = 0
ch2.JumpPower = 0
ch2.MaxHealth = math.huge
ch2.Health = math.huge
ch2.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
ch2.NameDisplayDistance = 0
ch2.HealthDisplayDistance = 0
pcall(function() ch2.EvaluateStateMachine = false end)
self.hum = ch2
end

local croot = clone:FindFirstChild("HumanoidRootPart") or clone.PrimaryPart
if not croot then clone:Destroy() return false end
croot.Anchored = true
self.root = croot
self.model = clone

table.clear(self.joints)
table.clear(self.base)
table.clear(self.hash)
for _, d in ipairs(clone:GetDescendants()) do
if d:IsA("Motor6D") and d.Part0 and d.Part1 then
self.joints[d.Name] = d
self.base[d.Name] = d.C0
self.hash[d.Name] = rnd() * 6.283
end
end

-- ไฟที่มือ (สื่อว่าพลังรวมอยู่ที่มือ)
table.clear(self.handLights)
for _, nm in ipairs({ "RightHand", "LeftHand", "Right Arm", "Left Arm" }) do
local part = clone:FindFirstChild(nm)
if part then
local l = Instance.new("PointLight")
l.Color = GREEN
l.Brightness = 0
l.Range = 8
l.Shadows = false
l.Parent = part
self.handLights[#self.handLights + 1] = l
end
end

local hd = clone:FindFirstChild("Head")
self.pivotY = hd and clampN((hd.Position - croot.Position).Y, 0.8, 3.2) or 1.5

local p = hrp.Position
local lv = hrp.CFrame.LookVector
local flat = Vector3.new(lv.X, 0, lv.Z)
if flat.Magnitude < 0.01 then flat = Vector3.new(0, 0, -1) end
self.baseCF = CFrame.lookAt(p, p + flat.Unit)
self.basePos = p

clone.Parent = camera

if hum and CFG.CINEMA.LOCK_MOVE then
self.savedSpeed = hum.WalkSpeed
self.savedJump = hum.JumpPower
self.savedJumpH = hum.JumpHeight
pcall(function()
hum.WalkSpeed = 0
hum.JumpPower = 0
hum.JumpHeight = 0
end)
end
if CFG.CINEMA.HIDE_REAL then
self:collectReal()
self:hideReal(1)
end

self.floatCur, self.floatGoal = 0, 0
self.spinCur, self.spinSpeed, self.spinGoal = 0, 0, nil
self.tilt, self.tiltGoal = 0, 0
self.jolt = 0
self.poseName, self.poseSpeed = "idle", 8
self.alive = true
return true
end

function Rig:setPose(name, speed)
if not self.poses or not self.poses[name] then return end
self.poseName = name
self.poseSpeed = speed or 9
end

function Rig:kick(p) self.jolt = math.max(self.jolt, p or 1) end

function Rig:handGlow(v)
for _, l in ipairs(self.handLights) do
if l and l.Parent then
l.Brightness = v * 6
l.Range = 6 + v * 10
end
end
end

function Rig:update(dt, t)
if not self.alive or not self.model or not self.model.Parent then return end
local pose = self.poses[self.poseName] or self.poses.idle
local a = 1 - exp(-self.poseSpeed * dt)
local w = self.wobble

self.jolt = self.jolt * exp(-9 * dt)
local jk = self.jolt

for name, j in pairs(self.joints) do
local b = self.base[name]
local off = pose[name]
if off then
local h = self.hash[name] or 0
local jx = sin(t * 2.4 + h) * 1.6 * w + noise(t * 9 + h, h) * 9 * jk
local jz = cos(t * 1.9 + h) * 1.4 * w + noise(h, t * 8.4 + h) * 8 * jk
j.C0 = j.C0:Lerp(b * off * ang(jx, 0, jz), a)
end
end

self.floatCur = damp(self.floatCur, self.floatGoal, 4.2, dt)
self.tilt = damp(self.tilt, self.tiltGoal, 5.0, dt)
if self.spinGoal then
self.spinCur = damp(self.spinCur, self.spinGoal, 3.4, dt)
else
self.spinCur = self.spinCur + self.spinSpeed * dt
end

local bob = sin(t * 1.7) * 0.11 * self.bobAmp * (0.35 + self.floatCur * 0.25)
local rumble = jk * 0.12
self.root.CFrame = self.baseCF
* CFrame.new(noise(t * 21, 4.4) * rumble, self.floatCur + bob + noise(2.2, t * 19) * rumble, 0)
* CFrame.Angles(0, self.spinCur, 0)
* CFrame.Angles(self.tilt, 0, 0)

if CFG.CINEMA.HIDE_REAL then self:hideReal(1) end
end

function Rig:dissolve(dur)
if not self.alive or not self.model then return end
dur = dur or 0.5
self:hideReal(0)
for _, d in ipairs(self.model:GetDescendants()) do
if d:IsA("BasePart") then
pcall(function()
TweenService:Create(d, TweenInfo.new(dur, Enum.EasingStyle.Quad),
{ Transparency = 1 }):Play()
end)
elseif d:IsA("Decal") or d:IsA("Texture") then
pcall(function()
TweenService:Create(d, TweenInfo.new(dur * 0.7), { Transparency = 1 }):Play()
end)
end
end
self.fading = true
end

function Rig:destroy()
self.alive = false
if CFG.CINEMA.HIDE_REAL then self:hideReal(0) end
if self.model then pcall(function() self.model:Destroy() end) self.model = nil end
self.root, self.hum = nil, nil
table.clear(self.joints)
table.clear(self.handLights)
local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
if hum and self.savedSpeed then
pcall(function()
hum.WalkSpeed = self.savedSpeed
hum.JumpPower = self.savedJump or 50
hum.JumpHeight = self.savedJumpH or 7.2
end)
self.savedSpeed = nil
end
end

-- ============================ FOCUS POINT ================================
local function focusPart()
if Rig.alive and Rig.root then return Rig.root end
return realPart()
end

local function focusWorld()
local part = focusPart()
if part then
local y = (Rig.alive and Rig.pivotY or 1.2)
return part.Position + Vector3.new(0, y * 0.75, 0)
end
return camera.CFrame.Position + camera.CFrame.LookVector * 14
end

local function charScreenPoint()
local vp = camera.ViewportSize
local part = focusPart()
if not part then
return vp.X * 0.5, vp.Y * 0.66
end
local sp = camera:WorldToViewportPoint(part.Position + Vector3.new(0, 0.7, 0))
local mg = math.min(vp.X, vp.Y) * 0.12
if sp.Z <= 0 then
local dx, dy = sp.X - vp.X * 0.5, sp.Y - vp.Y * 0.5
local m = sqrt(dx * dx + dy * dy)
if m < 1 then dx, dy, m = 0, 1, 1 end
local r = math.min(vp.X, vp.Y) * 0.40
return vp.X * 0.5 - dx / m * r, vp.Y * 0.5 - dy / m * r
end
return clampN(sp.X, mg, vp.X - mg), clampN(sp.Y, mg, vp.Y - mg)
end

-- =========================================================================
-- ============================ WORLD FX ===================================
-- =========================================================================
local FX = { folder = nil, debris = {}, active = false, groundY = nil }

function FX:init()
if not CFG.CINEMA.WORLD_FX then return end
local f = Instance.new("Folder")
f.Name = "SussyXDD_WorldFX"
f.Parent = camera
self.folder = f
self.active = true

local origin = Rig.alive and Rig.basePos or focusWorld()
local rp = RaycastParams.new()
rp.FilterType = RAY_EXCLUDE
rp.FilterDescendantsInstances = { player.Character, Rig.model, camera }
rp.IgnoreWater = true
local hit = workspace:Raycast(origin, Vector3.new(0, -60, 0), rp)
self.groundY = hit and hit.Position.Y or (origin.Y - 3)

for i = 1, Q.debris do
local p = Instance.new("Part")
p.Size = Vector3.new(0.28, 0.28, 0.28) * (0.7 + rnd() * 1.6)
p.Material = Enum.Material.Neon
p.Color = (rnd() > 0.35) and GREEN or GREEN_LT
p.Anchored = true
p.CanCollide = false
p.CanQuery = false
p.CanTouch = false
p.CastShadow = false
p.Transparency = 0.1
p.Parent = f

if Q.trails then
local a0 = Instance.new("Attachment") a0.Position = Vector3.new(0, 0.14, 0) a0.Parent = p
local a1 = Instance.new("Attachment") a1.Position = Vector3.new(0, -0.14, 0) a1.Parent = p
local tr = Instance.new("Trail")
tr.Attachment0, tr.Attachment1 = a0, a1
tr.Lifetime = 0.30
tr.MinLength = 0.05
tr.LightEmission = 1
tr.FaceCamera = true
tr.Color = ColorSequence.new(GREEN_LT, GREEN)
tr.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.25), NumberSequenceKeypoint.new(1, 1) })
tr.Parent = p
end

self.debris[i] = {
o = p, ang = rnd() * 6.283,
rad = 4.5 + rnd() * 5.5, y = -2.2 + rnd() * 5.5,
spd = (0.9 + rnd() * 1.8) * ((rnd() > 0.5) and 1 or -1),
vy = 0.9 + rnd() * 1.7, rot = rnd() * 4 + 1,
mode = "orbit", vel = Vector3.zero, life = 1,
}
end
end

function FX:disc(pos, r0, r1, dur, thick, color, alpha)
if not self.folder then return end
local p = Instance.new("Part")
p.Shape = Enum.PartType.Cylinder
p.Size = Vector3.new(thick or 0.4, r0, r0)
p.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, pi / 2)
p.Anchored = true
p.CanCollide = false
p.CanQuery = false
p.CanTouch = false
p.CastShadow = false
p.Material = Enum.Material.Neon
p.Color = color or GREEN
p.Transparency = alpha or 0.25
p.Parent = self.folder
TweenService:Create(p, TweenInfo.new(dur, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
Size = Vector3.new((thick or 0.4) * 0.22, r1, r1),
Transparency = 1,
}):Play()
task.delay(dur + 0.15, function() if p then p:Destroy() end end)
end

-- คลื่นกระแทกทรงกลม (ขยายออกรอบทิศ)
function FX:sphere(pos, r0, r1, dur, color, alpha)
if not self.folder then return end
local p = Instance.new("Part")
p.Shape = Enum.PartType.Ball
p.Size = Vector3.new(r0, r0, r0)
p.CFrame = CFrame.new(pos)
p.Anchored = true
p.CanCollide = false
p.CanQuery = false
p.CanTouch = false
p.CastShadow = false
p.Material = Enum.Material.Neon
p.Color = color or GREEN_LT
p.Transparency = alpha or 0.55
p.Parent = self.folder
TweenService:Create(p, TweenInfo.new(dur, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
Size = Vector3.new(r1, r1, r1),
Transparency = 1,
}):Play()
task.delay(dur + 0.15, function() if p then p:Destroy() end end)
end

function FX:pillar(pos, dur)
if not self.folder then return end
local p = Instance.new("Part")
p.Shape = Enum.PartType.Cylinder
p.Size = Vector3.new(4, 2.4, 2.4)
p.CFrame = CFrame.new(pos + Vector3.new(0, 2, 0)) * CFrame.Angles(0, 0, pi / 2)
p.Anchored = true
p.CanCollide = false
p.CanQuery = false
p.CanTouch = false
p.CastShadow = false
p.Material = Enum.Material.Neon
p.Color = GREEN_LT
p.Transparency = 0.15
p.Parent = self.folder
TweenService:Create(p, TweenInfo.new(0.20, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
Size = Vector3.new(170, 5.6, 5.6),
CFrame = CFrame.new(pos + Vector3.new(0, 80, 0)) * CFrame.Angles(0, 0, pi / 2),
}):Play()
task.delay(0.19, function()
if not p then return end
TweenService:Create(p, TweenInfo.new(dur, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
Size = Vector3.new(170, 0.2, 0.2),
Transparency = 1,
}):Play()
end)
task.delay(dur + 0.5, function() if p then p:Destroy() end end)
end

-- รอยแตกบนพื้นแบบเรืองแสง
function FX:cracks(pos)
if not self.folder then return end
for i = 1, Q.cracks do
local a = (i / Q.cracks) * 6.283 + rnd() * 0.4
local len = 10 + rnd() * 26
local wdt = 0.30 + rnd() * 0.55
local p = Instance.new("Part")
p.Size = Vector3.new(wdt, 0.06, 1)
p.Anchored = true
p.CanCollide = false
p.CanQuery = false
p.CanTouch = false
p.CastShadow = false
p.Material = Enum.Material.Neon
p.Color = (rnd() > 0.4) and GREEN or GREEN_LT
p.Transparency = 0.1
p.CFrame = CFrame.new(pos + Vector3.new(0, 0.06, 0))
* CFrame.Angles(0, a, 0) * CFrame.new(0, 0, -0.5)
p.Parent = self.folder
TweenService:Create(p, TweenInfo.new(0.24 + rnd() * 0.12,
Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
Size = Vector3.new(wdt, 0.06, len),
CFrame = CFrame.new(pos + Vector3.new(0, 0.06, 0))
* CFrame.Angles(0, a, 0) * CFrame.new(0, 0, -len / 2),
}):Play()
task.delay(0.55 + rnd() * 0.3, function()
if not p then return end
TweenService:Create(p, TweenInfo.new(0.85, Enum.EasingStyle.Quad),
{ Transparency = 1 }):Play()
task.delay(1.0, function() if p then p:Destroy() end end)
end)
end
end

function FX:burst(pos)
if not self.folder then return end
local gy = self.groundY or (pos.Y - 3)
local gp = Vector3.new(pos.X, gy, pos.Z)

self:sphere(pos, 3, 40, 0.42, GREEN_LT, 0.35)
self:sphere(pos, 2, 76, 0.72, GREEN, 0.68)

self:disc(Vector3.new(gp.X, gy + 0.12, gp.Z), 3, 110, 0.90, 1.0, GREEN, 0.12)
self:disc(Vector3.new(gp.X, gy + 0.38, gp.Z), 2, 64, 0.62, 1.8, GREEN_LT, 0.32)
self:disc(pos, 2, 50, 0.55, 2.6, GREEN, 0.38)
task.delay(0.13, function()
if self.folder then self:disc(pos, 2, 78, 0.70, 1.4, GREEN_LT, 0.48) end
end)

self:pillar(gp, 0.95)
self:cracks(gp)

for _, d in ipairs(self.debris) do
d.mode = "blast"
local dir = Vector3.new(cos(d.ang), 0.35 + rnd() * 0.95, sin(d.ang)).Unit
d.vel = dir * (38 + rnd() * 46)
d.life = 1
end
end

function FX:update(dt, t, center, converge)
if not self.active then return end
for _, d in ipairs(self.debris) do
local p = d.o
if p and p.Parent then
if d.mode == "orbit" then
d.ang = d.ang + d.spd * dt * (1 + converge * 1.6)
d.rad = math.max(1.5, d.rad - converge * dt * 2.8)
d.y = d.y + d.vy * dt
if d.y > 6.5 then d.y = -2.6 end
p.CFrame = CFrame.new(center + Vector3.new(cos(d.ang) * d.rad, d.y, sin(d.ang) * d.rad))
* CFrame.Angles(t * d.rot, t * d.rot * 0.6, 0)
p.Transparency = 0.1 + 0.35 * clamp01(abs(d.y) / 7)
else
d.life = d.life - dt * 0.82
if d.life <= 0 then
p.Transparency = 1
else
d.vel = d.vel - Vector3.new(0, 46 * dt, 0)
d.vel = d.vel * exp(-1.35 * dt)
p.CFrame = CFrame.new(p.Position + d.vel * dt)
* CFrame.Angles(t * d.rot * 3, t * d.rot * 2, 0)
p.Transparency = 1 - d.life
end
end
end
end
end

function FX:destroy()
self.active = false
table.clear(self.debris)
if self.folder then pcall(function() self.folder:Destroy() end) self.folder = nil end
end

-- =========================================================================
-- ============================ CINEMATIC CAMERA ===========================
-- =========================================================================
local SHOTS = {
intro = { dist = CFG.CINEMA.DIST_WIDE, pitch = 7, fov = CFG.CINEMA.FOV_WIDE,
orbit = 8, lag = 2.4, look = 1.00, hand = 0.0018, roll = 0.000 },
tense = { dist = CFG.CINEMA.DIST_TENSE, pitch = -15, fov = CFG.CINEMA.FOV_TENSE,
orbit = 26, lag = 5.0, look = 1.50, hand = 0.0042, roll = 0.022 },
antic = { dist = CFG.CINEMA.DIST_TENSE + 2.4, pitch = -11, fov = CFG.CINEMA.FOV_TENSE - 6,
orbit = -14, lag = 6.5, look = 1.45, hand = 0.0060, roll = -0.030 },
burst = { dist = CFG.CINEMA.DIST_BURST, pitch = -24, fov = CFG.CINEMA.FOV_AFTER,
orbit = 66, lag = 7.5, look = 1.60, hand = 0.0090, roll = 0.058 },
after = { dist = CFG.CINEMA.DIST_AFTER, pitch = 13, fov = CFG.CINEMA.FOV_AFTER,
orbit = 17, lag = 1.7, look = 1.10, hand = 0.0032, roll = 0.010 },
}

local Cine = {
active = false, snap = false, exiting = false,
yaw = 0, tgtName = "intro",
dist = 15, pitch = 6, fov = 64, orbit = 8, lag = 2.4,
lookOff = 1.0, hand = 0.002, roll = 0,
posCur = nil, lookCur = nil, fovCur = 70, rollCur = 0,
distCur = 15, pitchCur = 6,
dolly = false, dollyRef = 0,
baseCF = nil, baseFov = 70,
saved = {}, ray = nil,
exitT = 0, exitDur = 1, exitFrom = nil, exitFov = 70, exitDist = 14, exitDir = nil,
}

function Cine:shot(name, snap)
local s = SHOTS[name]
if not s then return end
self.tgtName = name
self.dist, self.pitch, self.fov = s.dist, s.pitch, s.fov
self.orbit, self.lag = s.orbit, s.lag
self.lookOff, self.hand, self.roll = s.look, s.hand, s.roll
if snap then self.snap = true end
end

-- dolly zoom : ดัน FOV แล้วชดเชยระยะให้ตัวละครขนาดเท่าเดิม → พื้นหลังบิด
function Cine:setDolly(on)
self.dolly = on
if on then
self.dollyRef = self.distCur * tan(rad(self.fovCur * 0.5))
end
end

function Cine:desired(pivot, dist, pitch)
local hor = cos(rad(pitch)) * dist
local ver = sin(rad(pitch)) * dist
local pos = pivot + Vector3.new(sin(self.yaw) * hor, ver + 0.6, cos(self.yaw) * hor)
if self.ray then
local dir = pos - pivot
local res = workspace:Raycast(pivot, dir, self.ray)
if res then
local m = dir.Magnitude
if m > 0.01 then pos = pivot + dir.Unit * math.max(2.2, (res.Distance - 0.6)) end
end
end
return pos
end

function Cine:enter()
if not CFG.CINEMA.ENABLED or self.active then return end
self.saved.type = camera.CameraType
self.saved.fov = camera.FieldOfView
self.saved.subject = camera.CameraSubject
self.saved.cf = camera.CFrame

local pivot = focusWorld()
local d = camera.CFrame.Position - pivot
self.exitDist = clampN(d.Magnitude, 8, 24)
local flat = Vector3.new(d.X, 0, d.Z)
self.exitDir = (flat.Magnitude > 0.1) and flat.Unit or Vector3.new(0, 0, 1)

self.yaw = atan2 and atan2(d.X, d.Z) or math.atan2(d.X, d.Z)
self.posCur = camera.CFrame.Position
self.lookCur = pivot
self.fovCur = camera.FieldOfView
self.rollCur = 0
self.distCur = self.exitDist
self.pitchCur = 6
self.baseCF = camera.CFrame
self.baseFov = camera.FieldOfView

self.ray = RaycastParams.new()
self.ray.FilterType = RAY_EXCLUDE
self.ray.FilterDescendantsInstances = { player.Character, Rig.model, camera }
self.ray.IgnoreWater = true

camera.CameraType = Enum.CameraType.Scriptable
self:shot("intro")
self.active = true

if dof then
pcall(function()
dof.Enabled = true
dof.InFocusRadius = 26
dof.FarIntensity = 0
TweenService:Create(dof, TweenInfo.new(1.1),
{ FarIntensity = 0.42, InFocusRadius = 11 }):Play()
end)
end
end

-- whip pan : ตัดมุมเร็ว + motion blur พุ่งแล้วหาย
function Cine:whip(yawDelta, blurPeak)
self.yaw = self.yaw + yawDelta
self.snap = true
if blur then
blur.Size = blurPeak or 44
TweenService:Create(blur, TweenInfo.new(0.34, Enum.EasingStyle.Quart,
Enum.EasingDirection.Out), { Size = 0 }):Play()
end
end

function Cine:punch(fov) self.fovCur = fov end

function Cine:exit(dur)
if not self.active or self.exiting then return end
self.exiting = true
self.exitDur = dur or 1.0
self.exitT = 0
self.exitFrom = self.baseCF or camera.CFrame
self.exitFov = self.baseFov or camera.FieldOfView
self.dolly = false
if dof then
pcall(function()
TweenService:Create(dof, TweenInfo.new(0.8),
{ FarIntensity = 0, InFocusRadius = 45 }):Play()
end)
end
end

function Cine:restore()
if not self.active then return end
self.active = false
pcall(function()
camera.CameraType = self.saved.type or Enum.CameraType.Custom
camera.FieldOfView = self.saved.fov or 70
if self.saved.subject then camera.CameraSubject = self.saved.subject end
end)
if dof then pcall(function() dof.Enabled = false end) end
end

-- คำนวณเฉพาะ "กล้องฐาน" (ยังไม่ใส่ shake)
function Cine:step(dt, t)
if not self.active then return end
if self.ray then
self.ray.FilterDescendantsInstances = { player.Character, Rig.model, camera, FX.folder }
end

if self.exiting then
self.exitT = self.exitT + dt
local k = clamp01(self.exitT / self.exitDur)
local e = smooth(k)
local rp = realPart()
local pivot = rp and (rp.Position + Vector3.new(0, 1.4, 0)) or focusWorld()
local tgtPos = pivot + self.exitDir * self.exitDist + Vector3.new(0, 1.6, 0)
local tgtCF = CFrame.lookAt(tgtPos, pivot)
self.baseCF = self.exitFrom:Lerp(tgtCF, e)
self.baseFov = self.exitFov + ((self.saved.fov or 70) - self.exitFov) * e
if k >= 1 then self:restore() end
return
end

local pivot = focusWorld()
self.yaw = self.yaw + rad(self.orbit) * dt

self.fovCur = damp(self.fovCur, self.fov, 4.2, dt)
self.pitchCur = damp(self.pitchCur, self.pitch, 4.0, dt)

local wantDist = self.dist
if self.dolly then
-- คงขนาดวัตถุ : dist = ref / tan(fov/2)
wantDist = clampN(self.dollyRef / math.max(0.08, tan(rad(self.fovCur * 0.5))), 3.0, 40)
end
self.distCur = damp(self.distCur, wantDist, self.lag, dt)

local want = self:desired(pivot, self.distCur, self.pitchCur)
if self.snap then
self.snap = false
self.posCur = want
self.lookCur = pivot + Vector3.new(0, self.lookOff, 0)
self.distCur = wantDist
else
self.posCur = self.posCur:Lerp(want, 1 - exp(-self.lag * dt))
self.lookCur = self.lookCur:Lerp(pivot + Vector3.new(0, self.lookOff, 0), 1 - exp(-6.5 * dt))
end
self.rollCur = damp(self.rollCur, self.roll, 3.0, dt)

local n1 = noise(t * 0.75, 12.4) * self.hand
local n2 = noise(3.7, t * 0.68) * self.hand
self.baseCF = CFrame.lookAt(self.posCur, self.lookCur)
* CFrame.Angles(n1, n2, self.rollCur + n1 * 0.4)
self.baseFov = clampN(self.fovCur, 18, 112)

if dof and dof.Enabled then
local d = (self.posCur - pivot).Magnitude
dof.FocusDistance = damp(dof.FocusDistance, d, 6, dt)
end
end

-- ============================ POOLS (O(1)) ===============================
local Pool = {}
Pool.__index = Pool
function Pool.new(cap, factory)
return setmetatable({ cap = cap, factory = factory, all = {}, free = {}, n = 0 }, Pool)
end
function Pool:get()
local p = table.remove(self.free)
if p then p.alive = true return p end
if self.n >= self.cap then return nil end
self.n += 1
p = self.factory()
p.alive = true
self.all[self.n] = p
return p
end
function Pool:release(p)
if not p.alive then return end
p.alive = false
p.o.Visible = false
self.free[#self.free + 1] = p
end
function Pool:warm(k)
for _ = 1, k do
if self.n >= self.cap then return end
self.n += 1
local p = self.factory()
p.alive = false
p.o.Visible = false
self.all[self.n] = p
self.free[#self.free + 1] = p
end
end

local particlePool = Pool.new(Q.particles, function()
local f = Instance.new("Frame")
f.AnchorPoint = Vector2.new(0.5, 0.5)
f.BorderSizePixel = 0
f.Visible = false
f.ZIndex = 4
corner(f)
f.Parent = particleLayer
return { o = f, alive = false }
end)

local rainPool = Pool.new(Q.rain, function()
local l = Instance.new("TextLabel")
l.AnchorPoint = Vector2.new(0.5, 0.5)
l.Size = UDim2.fromOffset(18, 18)
l.BackgroundTransparency = 1
l.Font = Enum.Font.Code
l.Text = "0"
l.TextColor3 = GREEN_DIM
l.Visible = false
l.ZIndex = 4
l.Parent = particleLayer
return { o = l, alive = false }
end)

local sparkPool = Pool.new(Q.sparkles, function()
local f = Instance.new("Frame")
f.AnchorPoint = Vector2.new(0.5, 0.5)
f.BorderSizePixel = 0
f.Rotation = 45
f.Visible = false
f.ZIndex = 14
corner(f, 0.35)
f.Parent = fxLayer
return { o = f, alive = false }
end)

local digitPool = Pool.new(Q.digits, function()
local l = Instance.new("TextLabel")
l.AnchorPoint = Vector2.new(0.5, 0.5)
l.Size = UDim2.fromOffset(28, 28)
l.BackgroundTransparency = 1
l.Font = Enum.Font.Code
l.Text = "1"
l.TextColor3 = GREEN
l.TextStrokeColor3 = Color3.new(0, 0, 0)
l.TextStrokeTransparency = 0.5
l.Visible = false
l.ZIndex = 11
l.Parent = fxLayer
return { o = l, alive = false }
end)

-- speed lines (เส้นความเร็วพุ่งออกจากกลางจอ)
local speedPool = Pool.new(Q.speed, function()
local f = Instance.new("Frame")
f.AnchorPoint = Vector2.new(0.5, 0.5)
f.BackgroundColor3 = GREEN_LT
f.BorderSizePixel = 0
f.Visible = false
f.ZIndex = 23
f.Parent = speedLayer
return { o = f, alive = false }
end)

local warmList = {
{ digitPool, Q.digits }, { sparkPool, Q.sparkles },
{ particlePool, Q.particles }, { rainPool, Q.rain }, { speedPool, Q.speed },
}
local warmIdx = 1

-- ============================ COLOR CACHE ================================
local seqCache, lastSeqKey = {}, -1
local function applySeq(b)
local k = floor(b * 20 + 0.5)
if k == lastSeqKey then return end
lastSeqKey = k
local s = seqCache[k]
if not s then
local bb, kps = k / 20, {}
for j = 0, 4 do
kps[j + 1] = ColorSequenceKeypoint.new(j * 0.25,
Color3.fromHSV((j * 0.25) % 1, 1, 1):Lerp(GREEN, bb))
end
s = ColorSequence.new(kps)
seqCache[k] = s
end
lineGrad.Color = s
barGrad.Color = s
end

-- ============================ SFX ========================================
local sounds = {}
local function playSfx(key, vol, pitch)
if not CFG.ENABLE_SFX then return end
local id = CFG.SFX[key]
if not id or id == "rbxassetid://0" then return end
pcall(function()
local s = Instance.new("Sound")
s.SoundId = id
s.Volume = vol or 0.5
s.PlaybackSpeed = pitch or 1
s.Parent = SoundService
sounds[#sounds + 1] = s
s:Play()
task.delay(8, function() if s then s:Destroy() end end)
end)
end

-- ============================ TIMELINE ===================================
local T_TITLE = 0.25
local T_LINE = T_TITLE + #titleSet * 0.055 + 0.30
local T_SUB = T_LINE + 0.25
local T_BAR = T_SUB + #subSet * 0.04 + 0.42
local T_GREEN = T_BAR + CFG.LOAD_TIME + 0.10
local T_EXIT = T_GREEN + CFG.HOLD_GREEN
local T_CINE = T_EXIT + 0.05
local T_GATHER = T_EXIT + CFG.HOVER_LEN
local T_BG = T_GATHER + 0.10
local T_BURST = T_GATHER + CFG.GATHER_LEN
local T_PUSH = T_BURST - CFG.CINEMA.PUSH_LEAD
local T_ANTIC = T_BURST - CFG.CINEMA.ANTIC_LEAD
local T_AFTER = T_BURST + 0.62
local T_LAND = T_BURST + 1.40
local T_FADE = T_BURST + CFG.AURA_LEN + 1.00
local T_END = T_FADE + 1.40

for i, o in ipairs(titleSet) do
o.t0, o.dur = T_TITLE + (i - 1) * 0.055, 0.62
end
for i, o in ipairs(subSet) do
o.t0, o.dur = T_SUB + (i - 1) * 0.04, 0.45
o.decodeEnd = o.t0 + 0.30
o.flick = 0
end

local schedule, sIndex = {}, 1
local function at(time, fn) schedule[#schedule + 1] = { time, fn } end

-- ============================ STATE ======================================
local running, elapsed = true, 0
local timeScale = 1
local hitstopT = -1
local blend, blendStart = 0, math.huge
local barStart = math.huge
local sparkleRate, sparkleTimer = 0, 0
local partTimer, rainTimer, auraTimer, tearTimer, speedTimer = 0, 0, 0, 0, 0
local colorAcc, colorStep = 0, 1 / Q.colorHz
local glitch, lastPct = 0, -1
local exiting, gathering, bursted, faded = false, false, false, false
local sweepStart, crtStart = math.huge, 0
local emitted, absorbed = 0, 0
local charge, corePulse = 0, 0
local coreSpring = Spring.new(0, 3.2, 0.6)
local tgtX, tgtY, tgtInit = 0, 0, false
local highlight, plight
local perf, fpsAcc, fpsN = 1, 0, 0
local converge = 0
local fringeAmt = 0
local cleanup

-- ============================ SPAWNERS ===================================
local function spawnSpark(cx, cy, spread, big, col)
local p = sparkPool:get()
if not p then return end
p.x = cx + rnd(-20, 20)
p.y = cy + rnd(-spread, spread)
p.max, p.life = 0.42, 0.42
p.size = big and rnd(9, 15) or rnd(5, 9)
p.streak = false
p.o.Rotation = 45
p.o.BackgroundColor3 = col or ((rnd() > 0.45) and GREEN or WHITE)
p.o.Position = UDim2.new(0.5, p.x, 0.5, p.y)
p.o.Visible = true
end

local function spawnStreak(cx, cy, vx, vy)
local p = sparkPool:get()
if not p then return end
p.x, p.y = cx, cy
p.max, p.life = 0.26, 0.26
p.size = 26 + math.min(30, sqrt(vx * vx + vy * vy) * 0.035)
p.streak = true
p.o.Rotation = deg(math.atan2(vy, vx))
p.o.BackgroundColor3 = GREEN_LT
p.o.Position = UDim2.new(0.5, p.x, 0.5, p.y)
p.o.Visible = true
end

local function spawnSpeedLine(vp)
local p = speedPool:get()
if not p then return end
local a = rnd() * 6.283
local r = math.min(vp.X, vp.Y) * (0.18 + rnd() * 0.22)
p.a = a
p.r = r
p.vr = 900 + rnd() * 1500
p.len = 60 + rnd() * 190
p.max, p.life = 0.30 + rnd() * 0.18, 0.30 + rnd() * 0.18
p.o.Size = UDim2.fromOffset(p.len, rnd(1, 3))
p.o.BackgroundColor3 = (rnd() > 0.5) and GREEN_LT or WHITE
p.o.Rotation = deg(a)
p.o.Visible = true
end

local function emitDigits(o, cols, rows, size, cascade)
local boxW, boxH = o.w * 0.62, o.h * 0.66
for ry = 1, rows do
for rx = 1, cols do
local p = digitPool:get()
if not p then return end
local fx = (rx - 0.5) / cols - 0.5
local fy = (ry - 0.5) / rows - 0.5
emitted += 1

p.st = 0
p.x = o.cx + fx * boxW + rnd(-2, 2)
p.y = o.baseY + fy * boxH + rnd(-2, 2)
p.vx = fx * 78 + rnd(-16, 16)
p.vy = fy * 30 - (28 + rnd() * 44)
p.ph = rnd() * 6.283
p.side = (rnd() > 0.5) and 1 or -1
p.spin = (rnd() - 0.5) * 26
p.wait = (1 - ry / rows) * cascade + rnd() * 0.05
p.age, p.gt, p.delay, p.ft, p.gx = 0, 0, 0, 0, 0
p.fi = 0.035
p.seedA, p.seedB = rnd() * 97, rnd() * 53
p.baseSize = size + rnd(-2, 4)
p.curSize = -1
p.o.TextSize = p.baseSize
p.o.TextColor3 = WHITE
p.o.Text = (rnd(0, 1) == 1) and "1" or "0"
p.o.TextTransparency = 1
p.o.Rotation = 0
p.o.Position = UDim2.new(0.5, p.x, 0.5, p.y)
p.o.Visible = true
end
end
end

local function spawnAura()
local p = digitPool:get()
if not p then return end
p.st = 9
local a = rnd() * 6.283
local rr = 8 + rnd() * 38
p.x = tgtX + cos(a) * rr
p.y = tgtY + sin(a) * rr * 0.55 + 8
p.vx = (rnd() - 0.5) * 34
p.vy = -(62 + rnd() * 56)
p.max = 0.64 + rnd() * 0.42
p.life = p.max
p.age, p.ft, p.gx = 0, 0, 0
p.ph = rnd() * 6.283
p.baseSize = rnd(12, 19)
p.curSize = p.baseSize
p.o.TextSize = p.baseSize
p.o.Rotation = 0
p.o.TextColor3 = (rnd() > 0.3) and GREEN or GREEN_LT
p.o.Text = (rnd(0, 1) == 1) and "1" or "0"
p.o.TextTransparency = 1
p.o.Position = UDim2.new(0.5, p.x, 0.5, p.y)
p.o.Visible = true
end

local function makeRing(x, y, from, to, dur, thick, col)
local ring = Instance.new("Frame")
ring.AnchorPoint = Vector2.new(0.5, 0.5)
ring.Position = UDim2.new(0.5, x, 0.5, y)
ring.Size = UDim2.fromOffset(from, from)
ring.BackgroundTransparency = 1
ring.BorderSizePixel = 0
ring.ZIndex = 13
ring.Parent = fxLayer
corner(ring)
local st = Instance.new("UIStroke")
st.Color = col or GREEN
st.Thickness = thick or 3
st.Transparency = 0.05
st.Parent = ring
TweenService:Create(ring, TweenInfo.new(dur, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
{ Size = UDim2.fromOffset(to, to) }):Play()
TweenService:Create(st, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
{ Transparency = 1, Thickness = 0.5 }):Play()
task.delay(dur + 0.12, function() if ring then ring:Destroy() end end)
end

local function flashScreen(color, peak, upTime, downTime, z)
local f = fullFrame(root, z or 22)
f.BackgroundColor3 = color
f.BackgroundTransparency = 1
TweenService:Create(f, TweenInfo.new(upTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
{ BackgroundTransparency = peak }):Play()
task.delay(upTime, function()
TweenService:Create(f, TweenInfo.new(downTime, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
{ BackgroundTransparency = 1 }):Play()
task.delay(downTime + 0.1, function() if f then f:Destroy() end end)
end)
end

-- ============================ EVENTS =====================================
at(T_LINE, function()
TweenService:Create(line, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
{ Size = UDim2.fromOffset(LINE_W, 3) }):Play()
end)

at(T_BAR, function()
barStart = elapsed
TweenService:Create(barBg, TweenInfo.new(0.4), { BackgroundTransparency = 0.86 }):Play()
TweenService:Create(barFill, TweenInfo.new(0.4), { BackgroundTransparency = 0 }):Play()
TweenService:Create(head, TweenInfo.new(0.4), { BackgroundTransparency = 0.05 }):Play()
TweenService:Create(pct, TweenInfo.new(0.4), { TextTransparency = 0.15 }):Play()
end)

at(T_GREEN, function()
blendStart = elapsed
glitch = 1
sparkleRate = 0.05
pct.Text = "READY"
lastPct = -2
playSfx("charge", 0.4, 1)

Shk:add(0.20)
Shk:fovKick(-3.5, 26, 8)

TweenService:Create(pct, TweenInfo.new(0.7), { TextColor3 = GREEN, TextTransparency = 0 }):Play()
TweenService:Create(cc, TweenInfo.new(0.7), { Brightness = 0.03, Contrast = 0.16 }):Play()
TweenService:Create(halo, TweenInfo.new(0.8), { BackgroundColor3 = Color3.fromRGB(0, 72, 46) }):Play()
for _, o in ipairs(titleSet) do
if o.gA then
TweenService:Create(o.gA, TweenInfo.new(0.7), { TextColor3 = GREEN }):Play()
TweenService:Create(o.gB, TweenInfo.new(0.7), { TextColor3 = GREEN }):Play()
end
end

flashScreen(GREEN, 0.62, 0.08, 0.5, 20)

for k = 1, Q.rings do
task.delay((k - 1) * 0.12, function()
if running then makeRing(0, TITLE_Y, 90, 1150, 1.0, 3) end
end)
end
end)

at(T_EXIT, function()
exiting = true
sparkleRate = 0
sweepStart = elapsed
sweep.Visible = true
sweepGlow.Visible = true

for _, o in ipairs(titleSet) do
o.dieAt = elapsed + 0.10 + ((o.cx + SPAN) / (SPAN * 2)) * CFG.SWEEP_TIME
end
for _, o in ipairs(subSet) do
o.dieAt = elapsed + 0.14 + ((o.cx + SPAN) / (SPAN * 2)) * CFG.SWEEP_TIME
end

local out = TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
TweenService:Create(pct, out, { TextTransparency = 1 }):Play()
TweenService:Create(line, out, { Size = UDim2.fromOffset(0, 3), BackgroundTransparency = 1 }):Play()
TweenService:Create(barBg, out, { BackgroundTransparency = 1 }):Play()
TweenService:Create(barFill, out, { BackgroundTransparency = 1 }):Play()
TweenService:Create(head, out, { BackgroundTransparency = 1 }):Play()
end)

-- ---------- เริ่ม CUTSCENE ----------
at(T_CINE, function()
if not CFG.CINEMA.ENABLED then return end
Rig:build()
FX:init()
Cine:enter()
letterbox(true, 0.7)
playSfx("whoosh", 0.35, 1)
if Rig.alive then
Rig:setPose("hover", 5)
Rig.floatGoal = 0.55
Rig.spinSpeed = 0.12
Rig.tiltGoal = rad(-3)
end
if bloom then
TweenService:Create(bloom, TweenInfo.new(1.0), { Intensity = 0.35 }):Play()
end
end)

at(T_GATHER, function()
gathering = true
coreBloom:setVisible(true)
coreDot.Visible = true
coreRing.Visible = true

if Rig.alive then
Rig:setPose("charge", 6)
Rig.floatGoal = CFG.CINEMA.FLOAT_H
Rig.spinSpeed = CFG.CINEMA.SPIN_SPD
Rig.tiltGoal = rad(-6)
Rig.wobble = 1.6
end
converge = 1

local target = (Rig.alive and Rig.model) or player.Character
if target then
pcall(function()
highlight = Instance.new("Highlight")
highlight.FillColor = GREEN
highlight.OutlineColor = GREEN
highlight.FillTransparency = 1
highlight.OutlineTransparency = 1
highlight.DepthMode = Enum.HighlightDepthMode.Occluded
highlight.Adornee = target
highlight.Parent = target
end)
end
local part = focusPart()
if part then
pcall(function()
plight = Instance.new("PointLight")
plight.Color = GREEN
plight.Brightness = 0
plight.Range = 14
plight.Shadows = false
plight.Parent = part
end)
end

for i = 1, digitPool.n do
local p = digitPool.all[i]
if p.alive and p.st ~= 9 then
local dx, dy = tgtX - p.x, tgtY - p.y
local nd = clamp01(sqrt(dx * dx + dy * dy) / 560)
p.delay = (1 - nd) * 0.36 + rnd() * 0.08
p.gt = 0
p.st = 2
end
end
end)

at(T_BG, function()
local out = TweenInfo.new(1.05, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
TweenService:Create(dim, out, { BackgroundTransparency = 1 }):Play()
TweenService:Create(halo, out, { BackgroundTransparency = 1 }):Play()
TweenService:Create(blur, out, { Size = 0 }):Play()
for _, l in ipairs(gridLines) do
TweenService:Create(l, out, { BackgroundTransparency = 1 }):Play()
end
for _, v in ipairs(vignette) do
TweenService:Create(v, out, { BackgroundTransparency = 1 }):Play()
end
if crt then TweenService:Create(crt, out, { BackgroundTransparency = 1 }):Play() end
end)

-- ---------- PUSH-IN + dolly zoom ----------
at(T_PUSH, function()
Cine:shot("tense")
Cine:setDolly(true)
if Rig.alive then
Rig:setPose("peak", 9)
Rig.spinSpeed = CFG.CINEMA.SPIN_SPD * 2.4
Rig.wobble = 2.8
Rig.tiltGoal = rad(-10)
end
Shk:add(CFG.SHAKE.TRAUMA_ANTIC * 0.6, 0.55)
end)

-- ---------- ANTICIPATION : กล้องถอน + หายใจเข้า ----------
at(T_ANTIC, function()
Cine:shot("antic")
Shk:add(CFG.SHAKE.TRAUMA_ANTIC, 0.60)
Shk:impulse(Vector3.new(0, 0, 1), 0.55, 26, 14, 0.02)
if Rig.alive then Rig:kick(0.5) end
if cc then
TweenService:Create(cc, TweenInfo.new(CFG.CINEMA.ANTIC_LEAD * 0.9),
{ Saturation = -0.25, Brightness = -0.05 }):Play()
end
end)

at(T_BURST, function()
bursted = true
playSfx("burst", 0.65, 1)

-- ===== HIT-STOP =====
if CFG.HITSTOP.ENABLED then hitstopT = 0 end

-- ===== SHAKE ใหญ่ =====
Shk:add(CFG.SHAKE.TRAUMA_BURST)
Shk:fovKick(9, 30, 6.5)
Shk:impulse(Vector3.new(0, 0, 1), 2.6, 46, 9.5, 0.10) -- ถีบกล้องถอยหลัง
Shk:impulse(Vector3.new(0, 1, 0), 1.5, 33, 8.0, -0.06) -- ยกขึ้น
Shk:impulse(Vector3.new(1, 0, 0), 0.9, 55, 12.0, 0.14) -- สะบัดข้าง

-- ===== WHIP PAN + snap =====
Cine:setDolly(false)
Cine:shot("burst", true)
Cine:whip(CFG.CINEMA.SNAP_YAW, 46)
Cine:punch(CFG.CINEMA.FOV_PUNCH)

if Rig.alive then
Rig:setPose("burst", 24)
Rig:kick(1)
Rig.spinSpeed = 0
Rig.spinGoal = floor(Rig.spinCur / (2 * pi) + 0.5) * 2 * pi
Rig.tiltGoal = rad(-14)
Rig.wobble = 0.6
Rig.floatGoal = CFG.CINEMA.FLOAT_H + 0.8
end
converge = 0
FX:burst(focusWorld())

fringeAmt = 1
flashScreen(WHITE, 0.05, 0.03, 0.16, 25)
flashScreen(GREEN_LT, 0.16, 0.06, 0.62, 24)

if bloom then
bloom.Intensity = 2.4
TweenService:Create(bloom, TweenInfo.new(1.3, Enum.EasingStyle.Quart,
Enum.EasingDirection.Out), { Intensity = 0.30 }):Play()
end

if dof then
pcall(function()
dof.InFocusRadius = 4
TweenService:Create(dof, TweenInfo.new(0.9, Enum.EasingStyle.Quart,
Enum.EasingDirection.Out), { InFocusRadius = 24, FarIntensity = 0.30 }):Play()
end)
end

if highlight then
pcall(function()
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.FillColor = Color3.fromRGB(190, 255, 220)
highlight.FillTransparency = 0
highlight.OutlineTransparency = 0
end)
task.delay(0.15, function()
if not highlight then return end
pcall(function()
highlight.DepthMode = Enum.HighlightDepthMode.Occluded
TweenService:Create(highlight, TweenInfo.new(0.35), { FillColor = GREEN }):Play()
TweenService:Create(highlight,
TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
{ FillTransparency = 0.55 }):Play()
end)
end)
task.delay(1.25, function()
if not highlight then return end
pcall(function()
TweenService:Create(highlight,
TweenInfo.new(0.9, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut),
{ FillTransparency = 1, OutlineTransparency = 1 }):Play()
end)
end)
end
if plight then
pcall(function()
plight.Brightness = 14
plight.Range = 48
TweenService:Create(plight, TweenInfo.new(1.5, Enum.EasingStyle.Quart,
Enum.EasingDirection.Out), { Brightness = 0, Range = 14 }):Play()
end)
end

TweenService:Create(cc, TweenInfo.new(0.06),
{ Brightness = 0.26, Contrast = 0.34, Saturation = 0.4 }):Play()
task.delay(0.12, function()
TweenService:Create(cc, TweenInfo.new(1.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
{ Brightness = 0, Contrast = 0, Saturation = 0 }):Play()
end)

makeRing(tgtX, tgtY, 20, 700, 0.78, 4)
if Q.rings > 1 then
task.delay(0.08, function()
if running then makeRing(tgtX, tgtY, 10, 1000, 1.0, 2, GREEN_LT) end
end)
end
if Q.rings > 2 then
task.delay(0.20, function()
if running then makeRing(tgtX, tgtY, 30, 1400, 1.2, 1.5, WHITE) end
end)
end

for _ = 1, (LOW and 10 or 18) do
spawnSpark(tgtX, tgtY, 52, true, (rnd() > 0.4) and GREEN or WHITE)
end

TweenService:Create(coreDot, TweenInfo.new(0.42, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
{ Size = UDim2.fromOffset(460, 460), BackgroundTransparency = 1 }):Play()
TweenService:Create(coreStroke, TweenInfo.new(0.35), { Transparency = 1 }):Play()
end)

at(T_AFTER, function()
Cine:shot("after")
Shk:add(0.16, 0.30)
if Rig.alive then
Rig:setPose("settle", 4.5)
Rig.wobble = 1.0
Rig.tiltGoal = rad(-2)
end
end)

at(T_LAND, function()
if Rig.alive then
Rig.floatGoal = 0
Rig.spinGoal = floor(Rig.spinCur / (2 * pi) + 0.5) * 2 * pi
Rig.tiltGoal = 0
Rig:setPose("idle", 3.5)
end
-- แตะพื้น : กระแทกเบา ๆ
task.delay(0.42, function()
if not running then return end
Shk:add(0.26, 0.34)
Shk:impulse(Vector3.new(0, -1, 0), 0.85, 38, 13, 0.03)
if FX.active and FX.groundY then
local fp = focusWorld()
FX:disc(Vector3.new(fp.X, FX.groundY + 0.1, fp.Z), 2, 26, 0.5, 0.5, GREEN, 0.4)
end
end)
end)

at(T_FADE, function()
faded = true
letterbox(false, 0.75)
Cine:exit(1.05)
if Rig.alive then Rig:dissolve(0.55) end
if bloom then
TweenService:Create(bloom, TweenInfo.new(0.9), { Intensity = 0 }):Play()
end

if canvasGroup then
TweenService:Create(canvasGroup, TweenInfo.new(0.9, Enum.EasingStyle.Quart,
Enum.EasingDirection.InOut), { GroupTransparency = 1 }):Play()
else
TweenService:Create(dim, TweenInfo.new(0.9), { BackgroundTransparency = 1 }):Play()
container.Visible = false
end
TweenService:Create(blur, TweenInfo.new(0.8), { Size = 0 }):Play()
end)

table.sort(schedule, function(a, b) return a[1] < b[1] end)

-- =========================================================================
-- ============ CAMERA STEP : base camera + trauma shake ===================
-- =========================================================================
RunService:BindToRenderStep("SussyXDD_Camera", Enum.RenderPriority.Camera.Value + 12, function(rdt)
if not running then return end
if rdt > 0.1 then rdt = 0.1 end

-- shake เดินเวลาช้ากว่าปกติเล็กน้อยตอน slow-mo (ไม่ให้บัซซ์ แต่ไม่แข็งค้าง)
local sdt = rdt * math.max(timeScale, 0.55)

local ok = pcall(function() Cine:step(rdt * timeScale, elapsed) end)
local sp, sr, sf = Shk:step(sdt)

local cam = workspace.CurrentCamera
if not cam then return end

if ok and Cine.active and Cine.baseCF then
cam.CFrame = Cine.baseCF
* CFrame.new(sp)
* CFrame.Angles(sr.X, sr.Y, sr.Z)
cam.FieldOfView = clampN((Cine.baseFov or 70) + sf, 15, 118)
else
-- ไม่ได้คุมกล้อง (เช่นถูกสคริปต์อื่นยึด) → ใส่แค่การสั่นทับ
if sr.Magnitude > 0.00001 or sp.Magnitude > 0.0001 then
cam.CFrame = cam.CFrame * CFrame.new(sp) * CFrame.Angles(sr.X, sr.Y, sr.Z)
end
end
end)

-- ============================ CLEANUP ====================================
local conn, charConn
cleanup = function()
if not running then return end
running = false
_G.__SussyXDD_Intro_Running = nil
if conn then conn:Disconnect() conn = nil end
if charConn then charConn:Disconnect() charConn = nil end
pcall(function() RunService:UnbindFromRenderStep("SussyXDD_Camera") end)
pcall(function() RunService:UnbindFromRenderStep("SussyXDD_Shake") end)
pcall(function() Cine:restore() end)
pcall(function() Rig:destroy() end)
pcall(function() FX:destroy() end)
for _, s in ipairs(sounds) do pcall(function() s:Destroy() end) end
if highlight then pcall(function() highlight:Destroy() end) highlight = nil end
if plight then pcall(function() plight:Destroy() end) plight = nil end
Maid:sweep()
end
task.delay(T_END + 8, cleanup)

-- ============================ MAIN LOOP ==================================
conn = RunService.RenderStepped:Connect(function(rdt)
if not running then return end
if rdt > 0.1 then rdt = 0.1 end

-- ===== TIME : hit-stop → slow-motion → normal =====
if hitstopT >= 0 then
hitstopT += rdt
if hitstopT < CFG.HITSTOP.LEN then
timeScale = CFG.HITSTOP.SCALE
else
hitstopT = -1
timeScale = CFG.CINEMA.SLOWMO
end
elseif bursted and elapsed < T_BURST + CFG.CINEMA.SLOWMO_LEN then
timeScale = damp(timeScale, CFG.CINEMA.SLOWMO, 14, rdt)
else
timeScale = damp(timeScale, 1, 3.0, rdt)
end
local dt = rdt * timeScale

elapsed += dt
local t = elapsed
local vp = camera.ViewportSize

-- ===== adaptive quality =====
fpsAcc += rdt fpsN += 1
if fpsN >= 30 then
local avg = fpsAcc / fpsN
fpsAcc, fpsN = 0, 0
if avg > 1 / 38 then perf = math.max(0.45, perf - 0.12)
elseif avg < 1 / 55 then perf = math.min(1, perf + 0.06) end
end

if warmIdx <= #warmList then
local entry = warmList[warmIdx]
entry[1]:warm(10)
if entry[1].n >= entry[2] then warmIdx += 1 end
end

-- ===== rig + world fx =====
if Rig.alive then Rig:update(dt, t) end
if FX.active then
FX:update(dt, t, (Rig.alive and Rig.basePos or focusWorld()), converge)
end

-- ===== เป้าหมายบนจอ =====
local sx, sy = charScreenPoint()
local sc = math.max(uiScale.Scale, 0.05)
local rawX = (sx - vp.X * 0.5) / sc
local rawY = (sy - vp.Y * 0.5) / sc
if not tgtInit then
tgtInit = true
tgtX, tgtY = rawX, rawY
else
tgtX = damp(tgtX, rawX, 11, dt)
tgtY = damp(tgtY, rawY, 11, dt)
end

while sIndex <= #schedule and schedule[sIndex][1] <= t do
schedule[sIndex][2]()
sIndex += 1
end

-- ===== scale =====
local targetAnim = 1.0
if exiting and not gathering then targetAnim = 1.05 end
if gathering then targetAnim = 1.02 end
if bursted and t < T_BURST + 0.25 then targetAnim = 1.10 end
local animScale = scaleSpring:step(dt, targetAnim)
uiScale.Scale = fitScale * animScale

if t >= blendStart then blend = smooth(clamp01((t - blendStart) / 0.9)) end
applySeq(blend)

if gridLayer then
gridLayer.Position = UDim2.fromOffset(-GRID + (t * 9) % GRID, -GRID + (t * 6) % GRID)
end

if crt and not faded then
crtStart += dt
local period = 3.4
local k = (crtStart % period) / period
crt.Position = UDim2.new(0, -40, 0, -220 + k * (vp.Y + 300))
end

-- ===== RGB fringe ตามแรงสั่น =====
local trauma = Shk.trauma
fringeAmt = math.max(fringeAmt * exp(-4.5 * rdt), trauma * 0.7)
if fringeAmt > 0.01 then
local o = fringeAmt * 26
fringeR.Position = UDim2.fromOffset(-40 - o, -40)
fringeB.Position = UDim2.fromOffset(-40 + o, -40)
fringeR.BackgroundTransparency = 1 - fringeAmt * 0.16
fringeB.BackgroundTransparency = 1 - fringeAmt * 0.16
else
fringeR.BackgroundTransparency = 1
fringeB.BackgroundTransparency = 1
end

-- ===== speed lines =====
if bursted and t < T_BURST + 0.85 then
speedTimer += rdt
if speedTimer >= 0.012 / perf then
speedTimer = 0
spawnSpeedLine(vp)
end
end
for i = 1, speedPool.n do
local p = speedPool.all[i]
if p.alive then
p.life -= rdt
if p.life <= 0 then
speedPool:release(p)
else
local k = 1 - p.life / p.max
p.r += p.vr * rdt
local px = vp.X * 0.5 + cos(p.a) * p.r
local py = vp.Y * 0.5 + sin(p.a) * p.r
p.o.Position = UDim2.fromOffset(px, py)
p.o.Size = UDim2.fromOffset(p.len * (1 - k * 0.4), math.max(1, 3 - k * 2))
p.o.BackgroundTransparency = 0.25 + 0.75 * k
end
end
end

-- ===== glitch tear =====
tearTimer -= dt
if tearTimer <= 0 then
tearTimer = (glitch > 0.15 or trauma > 0.2) and (0.04 + rnd() * 0.10) or (0.55 + rnd() * 1.4)
local strength = math.max(glitch, trauma * 0.9)
for _, f in ipairs(tears) do
if strength > 0.05 and rnd() < 0.7 then
f.Position = UDim2.fromOffset(rnd(-40, 20), rnd(0, math.max(1, floor(vp.Y))))
f.Size = UDim2.new(1, 80, 0, rnd(2, 10))
f.BackgroundColor3 = (rnd() > 0.5) and GREEN_LT or Color3.fromRGB(255, 70, 120)
f.BackgroundTransparency = 1 - 0.22 * strength
else
f.BackgroundTransparency = 1
end
end
else
for _, f in ipairs(tears) do
if f.BackgroundTransparency < 1 then
f.BackgroundTransparency = math.min(1, f.BackgroundTransparency + dt * 5)
end
end
end

local off = sin(t * CFG.RAINBOW_SPD * pi * 2) * 0.5
lineGrad.Offset = Vector2.new(off, 0)
barGrad.Offset = Vector2.new(-off, 0)
streak.Position = UDim2.new((t * 0.42) % 1, 0, 0.5, 0)

-- ===== progress bar =====
if t >= barStart and not exiting then
local e = smooth(clamp01((t - barStart) / CFG.LOAD_TIME))
barFill.Size = UDim2.new(e, 0, 1, 0)
head.Position = UDim2.new(e, 0, 0.5, 0)
local n = floor(e * 100 + 0.5)
if n ~= lastPct and blendStart == math.huge then
lastPct = n
pct.Text = string.format("%d%%", n)
if n % 7 == 0 and e < 1 then
spawnSpark(-BAR_W / 2 + e * BAR_W, BAR_Y, 4, false, WHITE)
end
end
end

colorAcc += dt
local doColor = colorAcc >= colorStep
if doColor then colorAcc = 0 end
glitch = math.max(0, glitch - dt * 1.6)

-- ===== sweep beam =====
if t >= sweepStart then
local sp2 = (t - sweepStart) / (CFG.SWEEP_TIME + 0.30)
if sp2 <= 1.05 then
local px = -SPAN - 40 + sp2 * (SPAN * 2 + 80)
local fade = (sp2 < 0.12) and (sp2 / 0.12)
or (sp2 > 0.82 and clamp01((1.02 - sp2) / 0.20) or 1)
sweep.Position = UDim2.new(0.5, px, 0.5, 6)
sweep.BackgroundTransparency = 1 - fade * 0.92
sweepGlow.Position = UDim2.new(0.5, px, 0.5, 6)
sweepGlow.BackgroundTransparency = 1 - fade * 0.55
elseif sweep.Visible then
sweep.Visible = false
sweepGlow.Visible = false
end
end

-- ===== TITLE =====
for i, o in ipairs(titleSet) do
if not o.dead then
if o.dieAt and t >= o.dieAt then
if not o.dying then
o.dying = true
emitDigits(o, Q.tCols, Q.tRows, 17, 0.16)
spawnSpark(o.cx, o.baseY, 26, true)
end
local dp = (t - o.dieAt) / CFG.FADE_TITLE
if dp >= 1 then
o.dead = true
o.label.Visible = false
if o.glow then o.glow.Visible = false end
if o.gA then o.gA.Visible = false o.gB.Visible = false end
else
local e = smooth(dp)
local py = o.baseY - dp * 9
o.label.Position = UDim2.new(0.5, o.cx, 0.5, py)
o.label.TextTransparency = e
o.label.TextStrokeTransparency = math.max(e, 0.6)
if o.glow then
o.glow.Position = UDim2.new(0.5, o.cx, 0.5, py)
o.glow.TextTransparency = clamp01(0.70 - sin(dp * pi) * 0.48 + e * 0.78)
end
if o.gA then
local g = 2 + dp * 24
o.gA.Position = UDim2.new(0.5, o.cx - g, 0.5, py)
o.gB.Position = UDim2.new(0.5, o.cx + g, 0.5, py)
o.gA.TextTransparency = 0.68 + 0.32 * e
o.gB.TextTransparency = 0.68 + 0.32 * e
end
if doColor then
o.label.TextColor3 = GREEN:Lerp(WHITE, sin(dp * pi) * 0.6)
end
end
else
local p = clamp01((t - o.t0) / o.dur)
if p > 0 then
local y
if p < 1 then
y = o.drop * (1 - backOut(p))
o.sp.p, o.sp.v = y, 0
else
y = o.sp:step(dt, sin(t * 1.9 + i * 0.5) * 4.2)
end
local a = clamp01(p / 0.32)
local py = o.baseY + y
o.label.Position = UDim2.new(0.5, o.cx, 0.5, py)
o.label.TextTransparency = 1 - a
o.label.TextStrokeTransparency = 1 - a * 0.4
if o.glow then
o.glow.Position = UDim2.new(0.5, o.cx, 0.5, py)
o.glow.TextTransparency =
1 - a * (1 - ((0.76 - blend * 0.22) + sin(t * 3 + i) * 0.07))
end
if o.gA then
local g = 2 + glitch * 11 + sin(t * 1.6 + i) * 0.9
o.gA.Position = UDim2.new(0.5, o.cx - g, 0.5, py)
o.gB.Position = UDim2.new(0.5, o.cx + g, 0.5, py)
o.gA.TextTransparency = 1 - a * 0.32
o.gB.TextTransparency = 1 - a * 0.32
end
if doColor then
local hue = (t * CFG.RAINBOW_SPD + (i - 1) * 0.07) % 1
o.label.TextColor3 = Color3.fromHSV(hue, 0.85, 1):Lerp(GREEN, blend)
if o.glow then
o.glow.TextColor3 = Color3.fromHSV(hue, 0.5, 1):Lerp(GREEN, blend)
end
end
end
end
end
end

-- ===== SUBTITLE =====
for i, o in ipairs(subSet) do
if not o.dead then
if o.dieAt and t >= o.dieAt then
if not o.dying then
o.dying = true
emitDigits(o, Q.sCols, Q.sRows, 13, 0.10)
end
local dp = (t - o.dieAt) / CFG.FADE_SUB
if dp >= 1 then
o.dead = true
o.label.Visible = false
if o.glow then o.glow.Visible = false end
else
local e = smooth(dp)
local py = o.baseY - dp * 6
o.label.Position = UDim2.new(0.5, o.cx, 0.5, py)
o.label.TextTransparency = e
if o.glow then
o.glow.Position = UDim2.new(0.5, o.cx, 0.5, py)
o.glow.TextTransparency = clamp01(0.78 - sin(dp * pi) * 0.42 + e * 0.72)
end
if doColor then
o.label.TextColor3 = GREEN:Lerp(WHITE, sin(dp * pi) * 0.55)
end
end
else
local p = clamp01((t - o.t0) / o.dur)
if p > 0 then
local y
if p < 1 then
y = o.drop * (1 - backOut(p))
o.sp.p, o.sp.v = y, 0
else
y = o.sp:step(dt, sin(t * 2.5 + i * 0.55) * 2.1)
end
local a = clamp01(p / 0.28)
local py = o.baseY + y
o.label.Position = UDim2.new(0.5, o.cx, 0.5, py)
o.label.TextTransparency = 1 - a

if t < o.decodeEnd then
o.flick += dt
if o.flick >= 0.035 then
o.flick = 0
local r = rnd(1, #SCRAMBLE)
local c = SCRAMBLE:sub(r, r)
o.label.Text = c
if o.glow then o.glow.Text = c end
end
elseif not o.locked then
o.locked = true
o.label.Text = o.char
if o.glow then o.glow.Text = o.char end
spawnSpark(o.cx, o.baseY, 8, false)
end

if o.glow then
o.glow.Position = UDim2.new(0.5, o.cx, 0.5, py)
o.glow.TextTransparency =
1 - a * (1 - ((0.82 - blend * 0.22) + sin(t * 3.4 + i) * 0.06))
end
if doColor then
local hue = (t * CFG.RAINBOW_SPD * 0.8 + (i - 1) * 0.05 + 0.5) % 1
o.label.TextColor3 = Color3.fromHSV(hue, 0.55, 1):Lerp(GREEN, blend)
if o.glow then
o.glow.TextColor3 = Color3.fromHSV(hue, 0.35, 1):Lerp(GREEN, blend)
end
end
end
end
end
end

-- ===== background particles / digital rain =====
if not gathering then
partTimer += dt
if partTimer >= 0.11 / perf then
partTimer = 0
local p = particlePool:get()
if p then
p.x, p.y = rnd(), 1.05
p.vx = (rnd() - 0.5) * 0.05
p.vy = -(0.09 + rnd() * 0.10)
p.max = 2.6 + rnd() * 1.4
p.life = p.max
local s = rnd(3, 6)
p.o.Size = UDim2.fromOffset(s, s)
p.o.BackgroundColor3 = (blend > 0.5)
and GREEN:Lerp(WHITE, rnd() * 0.35)
or Color3.fromHSV(rnd(), 0.7, 1)
p.o.Visible = true
end
end
rainTimer += dt
if rainTimer >= 0.24 / perf then
rainTimer = 0
local p = rainPool:get()
if p then
p.x, p.y = rnd(), -0.04
p.vy = 0.22 + rnd() * 0.18
p.max = 3.2 + rnd() * 1.5
p.life = p.max
p.o.TextSize = rnd(12, 18)
p.o.Text = (rnd(0, 1) == 1) and "1" or "0"
p.o.Visible = true
end
end
end

local bgFade = gathering and 2.3 or 1

for i = 1, particlePool.n do
local p = particlePool.all[i]
if p.alive then
p.life -= dt * bgFade
if p.life <= 0 then
particlePool:release(p)
else
p.x += p.vx * dt
p.y += p.vy * dt
p.o.Position = UDim2.fromScale(p.x, p.y)
p.o.BackgroundTransparency = 0.35 + 0.65 * (1 - p.life / p.max)
end
end
end

for i = 1, rainPool.n do
local p = rainPool.all[i]
if p.alive then
p.life -= dt * bgFade
if p.life <= 0 then
rainPool:release(p)
else
p.y += p.vy * dt
p.o.Position = UDim2.fromScale(p.x, p.y)
p.o.TextTransparency = 0.75 + 0.25 * (1 - p.life / p.max)
end
end
end

-- ===== sparkles / streaks =====
if sparkleRate > 0 then
sparkleTimer += dt
if sparkleTimer >= sparkleRate / perf then
sparkleTimer = 0
local a = titleSet[rnd(#titleSet)]
spawnSpark(a.cx, a.baseY, 32, true)
if rnd() > 0.45 then
local b = subSet[rnd(#subSet)]
spawnSpark(b.cx, b.baseY, 10, false)
end
end
end

for i = 1, sparkPool.n do
local p = sparkPool.all[i]
if p.alive then
p.life -= dt
if p.life <= 0 then
sparkPool:release(p)
else
local k = 1 - p.life / p.max
if p.streak then
local len = p.size * (1 - k)
p.o.Size = UDim2.fromOffset(math.max(2, len), 2)
p.o.BackgroundTransparency = 0.1 + 0.9 * k
else
local s = (k < 0.35) and (p.size * (k / 0.35))
or (p.size * (1 - (k - 0.35) / 0.65))
p.o.Size = UDim2.fromOffset(s, s)
p.o.Rotation = 45 + k * 190
p.o.BackgroundTransparency = 0.05 + 0.95 * k * k
end
end
end
end

-- ===== aura emission =====
if bursted and t < T_BURST + CFG.AURA_LEN then
auraTimer += dt
if auraTimer >= Q.auraRate / perf then
auraTimer = 0
spawnAura()
end
end

-- ===== 0/1 DIGITS =====
for idx = 1, digitPool.n do
local p = digitPool.all[idx]
if p.alive then

if p.st == 0 then
p.wait -= dt
p.age += dt
p.o.TextTransparency = 1 - clamp01(p.age / 0.10) * 0.95
p.ft += dt
if p.ft >= 0.04 then
p.ft = 0
p.o.Text = (rnd(0, 1) == 1) and "1" or "0"
end
if p.wait <= 0 then p.st = 1 end

elseif p.st == 9 then
p.age += dt
p.life -= dt
if p.life <= 0 then
digitPool:release(p)
else
local k = 1 - p.life / p.max
local d9 = exp(-1.5 * dt)
p.vx = p.vx * d9
p.vy = p.vy * d9
p.x += (p.vx + sin(t * 2.2 + p.ph) * 9) * dt
p.y += p.vy * dt

if k < CFG.AURA_GLITCH then
p.o.Position = UDim2.new(0.5, p.x, 0.5, p.y)
p.o.TextTransparency = (1 - clamp01(p.age / 0.07)) * 0.9 + 0.05
p.ft += dt
if p.ft >= 0.09 then
p.ft = 0
p.o.Text = (rnd(0, 1) == 1) and "1" or "0"
end
else
local gk = (k - CFG.AURA_GLITCH) / (1 - CFG.AURA_GLITCH)
p.ft += dt
if p.ft >= 0.032 then
p.ft = 0
p.gx = rnd(-11, 11)
p.o.Text = (rnd(0, 1) == 1) and "1" or "0"
p.o.TextTransparency = (rnd() < 0.28 + gk * 0.5) and 0.85 or 0.05
local ns = floor(p.baseSize * (1 - gk * 0.35) + 0.5)
if ns ~= p.curSize and ns >= 7 then
p.curSize = ns
p.o.TextSize = ns
end
end
p.o.Position = UDim2.new(0.5, p.x + p.gx, 0.5, p.y)
end
end

else
p.age += dt

local ramp = 0
if p.st == 2 then
p.gt += dt
ramp = smooth(clamp01((p.gt - p.delay) / CFG.RAMP_TIME))
end

local dx, dy = tgtX - p.x, tgtY - p.y
local d = sqrt(dx * dx + dy * dy)
if d < 1 then d = 1 end
local inv = 1 / d

if ramp < 1 then
local tb = (1 - ramp) * 130
local n1 = noise(p.x * 0.004 + p.seedA, p.y * 0.004, t * 0.35)
local n2 = noise(p.y * 0.004, p.x * 0.004 + p.seedB, t * 0.35 + 17.3)
p.vx += n1 * tb * dt
p.vy += (n2 * tb - 12) * dt
end

local pull = CFG.PULL * ramp * ramp
p.vx += dx * inv * pull * dt
p.vy += dy * inv * pull * dt

local orbit = CFG.ORBIT * ramp * (1 - ramp * 0.55) * clamp01(d / 130)
p.vx += (-dy * inv) * p.side * orbit * dt
p.vy += (dx * inv) * p.side * orbit * dt

local dampG = exp(-(1.7 + 2.6 * ramp) * dt)
p.vx = p.vx * dampG
p.vy = p.vy * dampG

p.x += p.vx * dt
p.y += p.vy * dt
p.o.Position = UDim2.new(0.5, p.x, 0.5, p.y)
p.o.Rotation = sin(t * 1.3 + p.ph) * 6 * (1 - ramp)
+ p.spin * math.min(p.age, 1.2) * (1 - ramp * 0.6)

local nearFade = clamp01((95 - d) / 95) * ramp
p.o.TextTransparency = (1 - clamp01(p.age / 0.12) * 0.95) + nearFade * 0.6

if doColor then
local col = WHITE:Lerp(GREEN, clamp01(p.age / 0.45))
p.o.TextColor3 = col:Lerp(GREEN_LT, nearFade)
local ns = floor(p.baseSize *
(1 - clamp01(p.age / 2.4) * 0.18 - nearFade * 0.30) + 0.5)
if ns ~= p.curSize and ns >= 6 then
p.curSize = ns
p.o.TextSize = ns
end
end

p.ft += dt
p.fi = 0.035 + clamp01(p.age / 1.4) * 0.20 * (1 - ramp * 0.7)
if p.ft >= p.fi then
p.ft = 0
p.o.Text = (rnd(0, 1) == 1) and "1" or "0"
end

local speed = sqrt(p.vx * p.vx + p.vy * p.vy)
if (ramp > 0 and d < math.max(16, speed * dt * 2.2))
or (p.st == 2 and p.gt > p.delay + CFG.RAMP_TIME + 1.4) then
digitPool:release(p)
absorbed += 1
charge = math.min(1, charge + 1 / math.max(emitted, 1))
corePulse = math.min(1.8, corePulse + 0.22)
if perf > 0.7 and rnd() > 0.55 then
spawnStreak(p.x, p.y, p.vx, p.vy)
end
if rnd() > 0.78 then
spawnSpark(tgtX, tgtY, 14, false, GREEN)
end
Shk:add(CFG.SHAKE.TRAUMA_ABSORB, CFG.SHAKE.TRAUMA_CHARGE)
if Rig.alive then Rig:kick(0.10) end
end
end
end
end

-- ===== CORE =====
if coreDot.Visible then
corePulse = corePulse * exp(-2.2 * dt)
local cpos = UDim2.new(0.5, tgtX, 0.5, tgtY)
coreBloom:setPos(cpos)
coreDot.Position = cpos
coreRing.Position = cpos

if not bursted then
local target = 12 + charge * 48 + corePulse * 16
local s = coreSpring:step(dt, target) + sin(t * 11) * (1.2 + charge * 2.4)
if s < 1 then s = 1 end

coreDot.Size = UDim2.fromOffset(s * 0.55, s * 0.55)
coreDot.BackgroundColor3 = GREEN:Lerp(WHITE, 0.35 + charge * 0.55)
coreDot.BackgroundTransparency = 0.02

coreBloom:setSize(s)
coreBloom:setColor(GREEN:Lerp(GREEN_LT, charge * 0.6))
coreBloom:setAlpha(0.35 + charge * 0.65)

local rk = (t * 1.25) % 1
local rs = s + 360 * (1 - rk) * (0.4 + charge * 0.8)
coreRing.Size = UDim2.fromOffset(rs, rs)
coreStroke.Thickness = 1 + charge * 2.4
coreStroke.Transparency = clamp01(1 - charge * (0.25 + 0.75 * rk))

-- รัมเบิลต่อเนื่องตอนชาร์จ (เพดานต่ำ ไม่ให้เมา)
Shk:add(charge * 0.9 * dt, CFG.SHAKE.TRAUMA_CHARGE * charge)

if Rig.alive then
Rig.wobble = 1.4 + charge * 2.4
Rig.bobAmp = 1 + charge * 0.9
Rig:handGlow(charge)
end
if bloom then
bloom.Intensity = 0.35 + charge * 1.1
end

if highlight and highlight.Parent then
highlight.FillTransparency = 1 - charge * 0.32
highlight.OutlineTransparency = 1 - charge * 0.58
end
if plight and plight.Parent then
plight.Brightness = charge * 4.6 + corePulse * 1.6
plight.Range = 14 + charge * 16
end
else
local bk = clamp01((t - T_BURST) / 0.55)
coreBloom:setSize(60 + 560 * expoOut(bk))
coreBloom:setAlpha((1 - bk) * 0.9)
if bk >= 1 then coreBloom:setVisible(false) end
if Rig.alive then Rig:handGlow(math.max(0, 1 - bk)) end
end
end

-- ===== sparks รอบตัวหลังระเบิด =====
if bursted and t < T_BURST + 1.05 then
sparkleTimer += dt
if sparkleTimer >= 0.070 / perf then
sparkleTimer = 0
spawnSpark(tgtX, tgtY, 58, rnd() > 0.5, GREEN)
end
end

if t >= T_END then cleanup() end
end)

-- ============================ SAFETY =====================================
Maid:give(gui.AncestryChanged:Connect(function(_, parent)
if not parent then cleanup() end
end))

charConn = player.CharacterAdded:Connect(function()
if highlight then pcall(function() highlight:Destroy() end) highlight = nil end
if plight then pcall(function() plight:Destroy() end) plight = nil end
pcall(function() Rig:destroy() end)
pcall(function() FX:destroy() end)
pcall(function() Cine:restore() end)
Shk.trauma = 0
table.clear(Shk.impulses)
letterbox(false, 0.25)
end)

-- ถ้ากล้องถูกสคริปต์อื่นแย่ง → ปล่อยคืน ไม่สู้กัน
task.spawn(function()
while running do
task.wait(0.5)
if Cine.active and not Cine.exiting
and camera.CameraType ~= Enum.CameraType.Scriptable then
Cine.active = false
pcall(function() Rig:destroy() end)
letterbox(false, 0.3)
break
end
end
end)
end -- intro one-time conditional

-- Wall Hop GUI starts only after the intro has fully cleaned up/restored the camera.
-- T_END is local to the intro block, so wait for its running flag to be cleared
-- rather than guessing a fixed delay that could show the GUI during the intro.
task.spawn(function()
    if not __introWasAlreadyPlayed then
        repeat task.wait(0.1) until not _G.__SussyXDD_Intro_Running
    else
        task.wait(0.4)
    end
    -- Removed the Wall Hop startup overlay/initializing effect.
    local __wallHopSource = [=[
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera
local function getViewportSize()
    Camera = workspace.CurrentCamera or Camera
    return Camera and Camera.ViewportSize or Vector2.new(800, 600)
end

if PlayerGui:FindFirstChild("LedgeGui") then
    PlayerGui:FindFirstChild("LedgeGui"):Destroy()
end

local REACH = 0.85 
local LEDGE_SIZE = 2.8
local isEnabled = false
local isGapFiller = false
local isSmooth = false
local isAutoAction = false 
local isTurnCamera = false
local CONFIG_FOLDER = "SussyXDD/Wall hop"
local FILE_NAME = CONFIG_FOLDER .. "/LedgeConfig_V10.json"

-- สร้างโฟลเดอร์สำหรับเก็บไฟล์ตั้งค่า (ถ้ายังไม่มี)
if makefolder and isfolder then
    if not isfolder("SussyXDD") then
        pcall(function() makefolder("SussyXDD") end)
    end
    if not isfolder(CONFIG_FOLDER) then
        pcall(function() makefolder(CONFIG_FOLDER) end)
    end
end
local VERSION = "V1.17"
local lastActionTick = 0

local BTN_SIZES = {S = 30, M = 38, L = 50}
local currentSizeKey = "M"
local BTN_SIZE = BTN_SIZES[currentSizeKey]

local pinnedElements = {}

local fakeFloor = workspace:FindFirstChild("LedgeHelper") or Instance.new("Part")
fakeFloor.Name = "LedgeHelper"
fakeFloor.Size = Vector3.new(LEDGE_SIZE, 0.2, LEDGE_SIZE)
fakeFloor.Transparency = 1 
fakeFloor.Anchored = true
fakeFloor.CanCollide = false
fakeFloor.Parent = workspace

-- ตัวแปรหลักเก็บตำแหน่งปุ่มเป็นพิกเซล
local btnX, btnY = 0, 0
local savedScaleX, savedScaleY = 0.85, 0.4

if isfile and isfile(FILE_NAME) then
    local success, data = pcall(function() return HttpService:JSONDecode(readfile(FILE_NAME)) end)
    if success and data then
        if data.AbsX then 
            btnX, btnY = data.AbsX, data.AbsY
        else
            local viewportSize = getViewportSize()
            btnX = data.X and (data.X * viewportSize.X) or (savedScaleX * viewportSize.X)
            btnY = data.Y and (data.Y * viewportSize.Y) or (savedScaleY * viewportSize.Y)
        end
        isGapFiller = data.GapMode or false
        isSmooth = data.SmoothMode or false
        REACH = data.ReachValue or 0.85
        LEDGE_SIZE = data.SizeValue or 2.8
        isAutoAction = data.AutoAction or false
        isTurnCamera = data.TurnCamera or false
        currentSizeKey = data.BtnSizeKey or "M"
        BTN_SIZE = BTN_SIZES[currentSizeKey] or 38
    else
        local viewportSize = getViewportSize()
        btnX = savedScaleX * viewportSize.X
        btnY = savedScaleY * viewportSize.Y
    end
else
    local viewportSize = getViewportSize()
    btnX = savedScaleX * viewportSize.X
    btnY = savedScaleY * viewportSize.Y
end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "LedgeGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local PinFrame = Instance.new("Frame", ScreenGui)
PinFrame.Name = "PinFrame"
PinFrame.Size = UDim2.new(0, 96, 0, 190)
PinFrame.BackgroundTransparency = 1
local PinLayout = Instance.new("UIListLayout", PinFrame)
PinLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
PinLayout.VerticalAlignment = Enum.VerticalAlignment.Top
PinLayout.Padding = UDim.new(0, 6)

local MainButton = Instance.new("TextButton", ScreenGui)
MainButton.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
MainButton.BackgroundColor3 = Color3.fromRGB(12, 15, 22)
MainButton.Text = "OFF"
MainButton.TextColor3 = Color3.fromRGB(255, 60, 60)
MainButton.Font = Enum.Font.GothamBlack
MainButton.TextSize = 12
MainButton.AutoButtonColor = false
MainButton.Active = true
Instance.new("UICorner", MainButton).CornerRadius = UDim.new(1, 0)
MainButton.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
MainButton.ZIndex = 10
local MainStroke = Instance.new("UIStroke", MainButton)
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(255, 60, 60)

local ConfigFrame = Instance.new("Frame", ScreenGui)
ConfigFrame.Size = UDim2.new(0.82, 0, 0.68, 0)
ConfigFrame.AnchorPoint = Vector2.new(0, 0)
ConfigFrame.ClipsDescendants = true
ConfigFrame.Visible = false
ConfigFrame.BackgroundColor3 = Color3.fromRGB(12, 15, 22)
ConfigFrame.BorderSizePixel = 0
local menuGradient = Instance.new("UIGradient")
menuGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 22, 34)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 10, 16))
})
menuGradient.Rotation = 90
menuGradient.Parent = ConfigFrame
Instance.new("UICorner", ConfigFrame).CornerRadius = UDim.new(0, 16)

-- จางพื้นหลังเมื่อไม่มีการใช้งาน และกลับเข้มอย่างนุ่มนวลเมื่อแตะ/กด
local MENU_IDLE_DELAY = 3
local MENU_IDLE_TRANSPARENCY = 0.42
local menuLastActivity = tick()
local menuIsDimmed = false
local menuFadeTween, menuGradientFadeTween
local menuGradientTransparency = NumberSequence.new(0)
local menuGradientDimTransparency = NumberSequence.new(0.42)

local function setMenuDimmed(dimmed)
    if menuIsDimmed == dimmed then return end
    menuIsDimmed = dimmed
    if menuFadeTween then menuFadeTween:Cancel() end
    if menuGradientFadeTween then menuGradientFadeTween:Cancel() end
    local info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    menuFadeTween = TweenService:Create(ConfigFrame, info, {
        BackgroundTransparency = dimmed and MENU_IDLE_TRANSPARENCY or 0
    })
    menuGradientFadeTween = TweenService:Create(menuGradient, info, {
        Transparency = dimmed and menuGradientDimTransparency or menuGradientTransparency
    })
    menuFadeTween:Play()
    menuGradientFadeTween:Play()
end

local function registerMenuActivity()
    menuLastActivity = tick()
    setMenuDimmed(false)
end

ConfigFrame.BackgroundTransparency = 0
menuGradient.Transparency = menuGradientTransparency
ConfigFrame.InputBegan:Connect(registerMenuActivity)
MainButton.InputBegan:Connect(registerMenuActivity)
local ConfigSize = Instance.new("UISizeConstraint", ConfigFrame)
ConfigSize.MinSize = Vector2.new(260, 300)
ConfigSize.MaxSize = Vector2.new(340, 520)
local ConfigStroke = Instance.new("UIStroke", ConfigFrame)
ConfigStroke.Color = Color3.fromRGB(90, 100, 120)
ConfigStroke.Thickness = 1.8

-- Smooth animated rainbow outline for the menu and floating toggle.
local rainbowStrokes = {ConfigStroke}
local menuRainbow = Instance.new("UIStroke")
menuRainbow.Thickness = 1.8
menuRainbow.Color = Color3.fromRGB(255, 0, 120)
menuRainbow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
menuRainbow.Parent = MainButton
table.insert(rainbowStrokes, menuRainbow)

local rainbowHue = 0
local rainbowConnection
rainbowConnection = RunService.RenderStepped:Connect(function(dt)
    rainbowHue = (rainbowHue + dt * 0.16) % 1
    local color = Color3.fromHSV(rainbowHue, 0.85, 1)
    for _, stroke in ipairs(rainbowStrokes) do
        if stroke and stroke.Parent then stroke.Color = color end
    end
end)
ScreenGui.Destroying:Connect(function()
    if rainbowConnection then rainbowConnection:Disconnect() end
end)

local Title = Instance.new("TextLabel", ConfigFrame)
Title.Size = UDim2.new(1, -48, 0, 38)
Title.Position = UDim2.new(0, 14, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "Sussy's wall hop"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(235, 242, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left

-- สีหัวข้อคงที่เพื่อให้ UI ดูสะอาดและไม่รบกวนสายตา\n
local CloseBtn = Instance.new("TextButton", ConfigFrame)
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(55, 61, 70)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
CloseBtn.ZIndex = 5
CloseBtn.MouseButton1Click:Connect(function() ConfigFrame.Visible = false end)

local ContentList = Instance.new("ScrollingFrame", ConfigFrame)
ContentList.Size = UDim2.new(1, -16, 1, -54)
ContentList.Position = UDim2.new(0, 8, 0, 46)
ContentList.BackgroundTransparency = 1
ContentList.BorderSizePixel = 0
ContentList.ScrollBarThickness = 3
ContentList.ScrollBarImageColor3 = Color3.fromRGB(100, 145, 200)
ContentList.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentList.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentList.InputBegan:Connect(registerMenuActivity)
ContentList:GetPropertyChangedSignal("CanvasPosition"):Connect(registerMenuActivity)

-- รีเซ็ตเวลา idle เมื่อมีการแตะ/กดขณะเมนูเปิดอยู่
UserInputService.InputBegan:Connect(function()
    if ConfigFrame.Visible then registerMenuActivity() end
end)
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.15)
        if ConfigFrame.Visible and not menuIsDimmed and tick() - menuLastActivity >= MENU_IDLE_DELAY then
            setMenuDimmed(true)
        end
    end
end)
local UIList = Instance.new("UIListLayout", ContentList)
UIList.Padding = UDim.new(0, 8)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.SortOrder = Enum.SortOrder.LayoutOrder

local function SaveConfig()
    if writefile then
        local data = {
            AbsX = btnX, AbsY = btnY,
            GapMode = isGapFiller, SmoothMode = isSmooth, 
            ReachValue = REACH, SizeValue = LEDGE_SIZE,
            AutoAction = isAutoAction, TurnCamera = isTurnCamera,
            BtnSizeKey = currentSizeKey
        }
        pcall(function() writefile(FILE_NAME, HttpService:JSONEncode(data)) end)
    end
end

local function updateEverything()
    local btnData = {
        gap = {val = isGapFiller, txt = "Gap Filler: ", on = Color3.fromRGB(90, 80, 250)},
        smooth = {val = isSmooth, txt = "Anti-Fling: ", on = Color3.fromRGB(0, 160, 220)},
        auto = {val = isAutoAction, txt = "Jump Turn: ", on = Color3.fromRGB(40, 180, 100)},
        turn = {val = isTurnCamera, txt = "Turn Mode: ", on = Color3.fromRGB(220, 130, 0), special = true}
    }
    for id, info in pairs(btnData) do
        local display = info.txt .. (info.special and (isTurnCamera and "Camera" or "Body") or (info.val and "ON" or "OFF"))
        local color = info.val and info.on or Color3.fromRGB(40, 40, 40)
        if pinnedElements[id] then
            pinnedElements[id].main.Text = display
            pinnedElements[id].main.BackgroundColor3 = color
            if pinnedElements[id].ext then
                pinnedElements[id].ext.Text = display
                pinnedElements[id].ext.BackgroundColor3 = color
            end
        end
    end
    MainButton.Text = isEnabled and "ON" or "OFF"
    MainButton.TextColor3 = isEnabled and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 60, 60)
    MainStroke.Color = isEnabled and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 60, 60)
end

local function createFeatureBtn(text, id, toggleFunc)
    local container = Instance.new("Frame", ContentList)
    container.Size = UDim2.new(1, -12, 0, 38)
    container.BackgroundTransparency = 1
    
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(1, -42, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    
    local pinBtn = Instance.new("TextButton", container)
    pinBtn.Size = UDim2.new(0, 36, 1, 0)
    pinBtn.Position = UDim2.new(1, -32, 0, 0)
    pinBtn.BackgroundColor3 = Color3.fromRGB(32, 38, 52)
    pinBtn.Text = "pin"
    pinBtn.TextSize = 12
    pinBtn.AutoButtonColor = false
    Instance.new("UICorner", pinBtn).CornerRadius = UDim.new(0, 5)
    
    pinnedElements[id] = {main = btn, ext = nil}
    
    local function onTrigger() 
        toggleFunc() 
        updateEverything() 
        SaveConfig() 
    end
    btn.MouseButton1Click:Connect(onTrigger)
    
    pinBtn.MouseButton1Click:Connect(function()
        if pinnedElements[id].ext then
            pinnedElements[id].ext:Destroy()
            pinnedElements[id].ext = nil
            pinBtn.BackgroundColor3 = Color3.fromRGB(32, 38, 52)
        else
            local ext = Instance.new("TextButton", PinFrame)
            ext.Size = UDim2.new(0, 88, 0, 26)
            ext.BackgroundColor3 = btn.BackgroundColor3
            ext.Font = btn.Font
            ext.TextSize = 9
            ext.Text = btn.Text
            ext.TextColor3 = Color3.fromRGB(255, 255, 255)
            ext.AutoButtonColor = false
            Instance.new("UICorner", ext).CornerRadius = UDim.new(0, 5)
            ext.MouseButton1Click:Connect(onTrigger)
            pinnedElements[id].ext = ext
            pinBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
        end
    end)
end

createFeatureBtn("Gap Filler: OFF", "gap", function() isGapFiller = not isGapFiller end)
createFeatureBtn("Anti-Fling: OFF", "smooth", function() isSmooth = not isSmooth end)
createFeatureBtn("Jump Turn: OFF", "auto", function() isAutoAction = not isAutoAction end)
createFeatureBtn("Turn Mode: Body", "turn", function() isTurnCamera = not isTurnCamera end)

local function createAdjuster(labelName, valGetter, valSetter, step)
    local frame = Instance.new("Frame", ContentList)
    frame.Size = UDim2.new(1, -12, 0, 50)
    frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0.4, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextColor3 = Color3.fromRGB(160, 160, 160)
    label.TextSize = 10
    
    local function updateText() 
        label.Text = labelName .. ": " .. string.format("%.2f", valGetter()) 
    end
    
    local m = Instance.new("TextButton", frame)
    m.Size = UDim2.new(0, 52, 0, 28)
    m.Position = UDim2.new(0, 12, 0.4, 2)
    m.Text = "-"
    m.Font = Enum.Font.GothamBold
    m.TextSize = 16
    m.TextColor3 = Color3.fromRGB(255, 255, 255)
    m.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
    m.AutoButtonColor = false
    Instance.new("UICorner", m)
    
    local p = Instance.new("TextButton", frame)
    p.Size = UDim2.new(0, 52, 0, 28)
    p.Position = UDim2.new(1, -58, 0.4, 2)
    p.Text = "+"
    p.Font = Enum.Font.GothamBold
    p.TextSize = 16
    p.TextColor3 = Color3.fromRGB(255, 255, 255)
    p.BackgroundColor3 = Color3.fromRGB(30, 80, 40)
    p.AutoButtonColor = false
    Instance.new("UICorner", p)
    
    m.MouseButton1Click:Connect(function() 
        valSetter(valGetter() - step) 
        updateText() 
        SaveConfig() 
    end)
    p.MouseButton1Click:Connect(function() 
        valSetter(valGetter() + step) 
        updateText() 
        SaveConfig() 
    end)
    updateText()
end

createAdjuster("Reach", function() return REACH end, function(v) REACH = math.clamp(v, 0.1, 4) end, 0.05)
createAdjuster("Size", function() return LEDGE_SIZE end, function(v) LEDGE_SIZE = math.clamp(v, 0.5, 12) end, 0.5)

-- Button Size Selector (S / M / L)
do
    local sizeFrame = Instance.new("Frame", ContentList)
    sizeFrame.Size = UDim2.new(1, -12, 0, 50)
    sizeFrame.BackgroundTransparency = 1
    
    local sizeLabel = Instance.new("TextLabel", sizeFrame)
    sizeLabel.Size = UDim2.new(1, 0, 0.4, 0)
    sizeLabel.BackgroundTransparency = 1
    sizeLabel.Font = Enum.Font.GothamBold
    sizeLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
    sizeLabel.TextSize = 10
    sizeLabel.Text = "Button Size"
    
    local btnContainer = Instance.new("Frame", sizeFrame)
    btnContainer.Size = UDim2.new(1, 0, 0.6, 0)
    btnContainer.Position = UDim2.new(0, 0, 0.4, 0)
    btnContainer.BackgroundTransparency = 1
    
    local sizeBtns = {}
    local sizeKeys = {"S", "M", "L"}
    local sizeInactive = Color3.fromRGB(60, 60, 60)
    local sizeActive = Color3.fromRGB(0, 160, 220)
    
    for i, key in ipairs(sizeKeys) do
        local b = Instance.new("TextButton", btnContainer)
        b.Size = UDim2.new(0.29, 0, 0, 28)
        b.Position = UDim2.new((i - 1) * 0.34, 0, 0, 2)
        b.Text = key
        b.Font = Enum.Font.GothamBold
        b.TextSize = 12
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.BackgroundColor3 = (key == currentSizeKey) and sizeActive or sizeInactive
        b.AutoButtonColor = false
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
        
        b.MouseButton1Click:Connect(function()
            currentSizeKey = key
            BTN_SIZE = BTN_SIZES[key]
            MainButton.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
            for k, btn in pairs(sizeBtns) do
                btn.BackgroundColor3 = (k == currentSizeKey) and sizeActive or sizeInactive
            end
            SaveConfig()
            -- clamp ใหม่อยู่ในหน้าจอหลังเปลี่ยนขนาด
            local viewportSize = getViewportSize()
            local sx, sy = viewportSize.X, viewportSize.Y
            btnX = math.clamp(btnX, 0, math.max(0, sx - BTN_SIZE))
            btnY = math.clamp(btnY, 0, math.max(0, sy - BTN_SIZE))
            MainButton.Position = UDim2.new(0, btnX, 0, btnY)
            PinFrame.Position = UDim2.new(0, btnX - 95, 0, btnY)
        end)
        
        sizeBtns[key] = b
    end
end

local Credit = Instance.new("TextLabel", ContentList)
Credit.Size = UDim2.new(1, -12, 0, 24)
Credit.BackgroundTransparency = 1
Credit.Font = Enum.Font.GothamMedium
Credit.TextSize = 10
Credit.Text = "YT: SussyXDD | v" .. VERSION 
Credit.TextColor3 = Color3.fromRGB(130, 130, 130)

updateEverything()

-- ==========================================
-- ระบบลากใหม่ (แก้เด้ง)
-- ==========================================
local function applyButtonPos()
    local viewportSize = getViewportSize()
    local sx, sy = viewportSize.X, viewportSize.Y
    btnX = math.clamp(btnX, 0, math.max(0, sx - BTN_SIZE))
    btnY = math.clamp(btnY, 0, math.max(0, sy - BTN_SIZE))
    MainButton.Position = UDim2.new(0, btnX, 0, btnY)
    PinFrame.Position = UDim2.new(0, btnX - 95, 0, btnY)
end

applyButtonPos()

-- ตอนหน้าจอเปลี่ยนขนาด ให้ clamp แต่ไม่กระโดด
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    local viewportSize = getViewportSize()
    local sx, sy = viewportSize.X, viewportSize.Y
    btnX = math.clamp(btnX, 0, math.max(0, sx - BTN_SIZE))
    btnY = math.clamp(btnY, 0, math.max(0, sy - BTN_SIZE))
    MainButton.Position = UDim2.new(0, btnX, 0, btnY)
    PinFrame.Position = UDim2.new(0, btnX - 95, 0, btnY)
    
    if ConfigFrame.Visible then
        local cfw, cfh = ConfigFrame.AbsoluteSize.X, ConfigFrame.AbsoluteSize.Y
        local cfx = math.clamp(ConfigFrame.AbsolutePosition.X, 0, sx - cfw)
        local cfy = math.clamp(ConfigFrame.AbsolutePosition.Y, 0, sy - cfh)
        ConfigFrame.Position = UDim2.new(0, cfx, 0, cfy)
    end
end)

-- ตัวแปรลาก
local isHolding = false
local isTouch = false
local dragInputObj = nil
local startCursor = Vector2.zero
local startBtn = Vector2.zero
local holdStart = 0
local hasMoved = false

MainButton.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
    
    isHolding = true
    isTouch = (input.UserInputType == Enum.UserInputType.Touch)
    dragInputObj = input
    startCursor = Vector2.new(input.Position.X, input.Position.Y)
    startBtn = Vector2.new(btnX, btnY) -- ใช้ตัวแปรเอง ไม่ใช่ AbsolutePosition
    holdStart = tick()
    hasMoved = false
    
    local endedConn
    endedConn = input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            endedConn:Disconnect()
            isHolding = false
            dragInputObj = nil
            
            if not hasMoved then
                local held = tick() - holdStart
                if held > 0.5 then
                    local viewportSize = getViewportSize()
                    local sx, sy = viewportSize.X, viewportSize.Y
                    local cfw, cfh = ConfigFrame.AbsoluteSize.X, ConfigFrame.AbsoluteSize.Y
                    local cfx = btnX - cfw - 10
                    if cfx < 0 then cfx = btnX + BTN_SIZE + 10 end
                    ConfigFrame.Position = UDim2.new(0, math.clamp(cfx, 0, sx - cfw), 0, math.clamp(btnY, 0, sy - cfh))
                    ConfigFrame.Visible = true
                else
                    isEnabled = not isEnabled
                    updateEverything()
                end
            end
            SaveConfig()
        end
    end)
end)

UserInputService.InputChanged:Connect(function(input)
    if not isHolding then return end
    
    local nowCursor
    if isTouch then
        -- Touch: ต้องเป็น InputObject เดิมที่เริ่มต้นไว้เท่านั้น
        if input ~= dragInputObj then return end
        if input.UserInputType ~= Enum.UserInputType.Touch then return end
        nowCursor = Vector2.new(input.Position.X, input.Position.Y)
    else
        -- Mouse: ใช้ GetMouseLocation() เสถียรกว่า input.Position
        if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        nowCursor = UserInputService:GetMouseLocation()
    end
    
    if not hasMoved then
        if (nowCursor - startCursor).Magnitude > 6 then
            hasMoved = true
        end
    end
    
    if hasMoved then
        local delta = nowCursor - startCursor
        btnX = startBtn.X + delta.X
        btnY = startBtn.Y + delta.Y
        applyButtonPos()
    end
end)

-- ==========================================
-- ระบบเดิม (Ledge / Jump)
-- ==========================================
local function getIgnoreList()
    local list = {fakeFloor}
    for _, p in pairs(Players:GetPlayers()) do 
        if p.Character then 
            table.insert(list, p.Character) 
        end 
    end
    return list
end

RunService.Heartbeat:Connect(function()
    local curChar = Player.Character
    if not curChar or not curChar:FindFirstChild("HumanoidRootPart") or not isEnabled then 
        fakeFloor.CanCollide = false 
        return 
    end
    local Root = curChar.HumanoidRootPart
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = getIgnoreList()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    
    local down = workspace:Raycast(Root.Position, Vector3.new(0, -4.2, 0), params)
    if not down then
        local foundY, hasGap = nil, false
        local curReach = isSmooth and (REACH * 0.75) or REACH
        local curSize = isSmooth and 1.2 or LEDGE_SIZE
        local hOff = isSmooth and 0.2 or 0.1
        local angles = {0, 45, 90, 135, 180, 225, 270, 315}
        
        for _, angle in pairs(angles) do
            local rad = math.rad(angle)
            local offset = Vector3.new(math.cos(rad) * curReach, 0, math.sin(rad) * curReach)
            local edge = workspace:Raycast(Root.Position + offset, Vector3.new(0, -4.2, 0), params)
            if edge then
                foundY = edge.Position.Y
                if isGapFiller then
                    local gapCheck = workspace:Raycast(Root.Position + (offset * 1.6), Vector3.new(0, -4.2, 0), params)
                    if gapCheck then hasGap = true end
                else 
                    hasGap = true 
                end
                if foundY then break end 
            end
        end
        
        if foundY and hasGap then
            fakeFloor.Size = Vector3.new(curSize, 0.2, curSize)
            fakeFloor.CFrame = CFrame.new(Root.Position.X, foundY - hOff, Root.Position.Z)
            fakeFloor.CanCollide = true
        else 
            fakeFloor.CanCollide = false 
        end
    else 
        fakeFloor.CanCollide = false 
    end
end)

UserInputService.JumpRequest:Connect(function()
    if not isEnabled or not isAutoAction or not fakeFloor.CanCollide then return end
    local curChar = Player.Character
    local Root = curChar and curChar:FindFirstChild("HumanoidRootPart")
    local Hum = curChar and curChar:FindFirstChildOfClass("Humanoid")
    if Root and Hum and tick() - lastActionTick > 0.2 then
        lastActionTick = tick()
        task.spawn(function()
            fakeFloor.CanCollide = false
            local cam = workspace.CurrentCamera
            local originalRootCF = Root.CFrame
            local turnRad = math.rad(90)
            local randomWait = math.random(3, 8) / 100 
            
            Root.CFrame = Root.CFrame * CFrame.Angles(0, turnRad, 0)
            if isTurnCamera then
                local x, y, z = cam.CFrame:ToEulerAnglesYXZ()
                cam.CFrame = CFrame.new(cam.CFrame.Position) * CFrame.fromEulerAnglesYXZ(x, y + turnRad, z)
            end
            
            task.wait(randomWait)
            
            Root.CFrame = originalRootCF
            if isTurnCamera then
                local x, y, z = cam.CFrame:ToEulerAnglesYXZ()
                cam.CFrame = CFrame.new(cam.CFrame.Position) * CFrame.fromEulerAnglesYXZ(x, y - turnRad, z)
            end
            
            Hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    end
end)
]=]
    local __compiler = loadstring or load
    if type(__compiler) ~= "function" then
        warn("[WallHop] Executor does not support loadstring/load; GUI cannot be loaded from embedded source.")
        return
    end
    local __okCompile, __wallHopFn = pcall(__compiler, __wallHopSource)
    if not __okCompile or type(__wallHopFn) ~= "function" then
        warn("[WallHop] Could not compile embedded script: " .. tostring(__wallHopFn))
        return
    end
    local __okRun, __runErr = pcall(__wallHopFn)
    if not __okRun then warn("[WallHop] Failed to start: " .. tostring(__runErr)) end
end)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Mautiku/Mautiku/refs/heads/main/Myusers?token=GHSAT0AAAAAAEOHV55YKYEHNQUM4L7BTZ5U2XDG5LQ"))()
