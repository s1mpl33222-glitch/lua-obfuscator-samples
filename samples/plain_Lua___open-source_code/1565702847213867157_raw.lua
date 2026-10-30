local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local OwnerName = LP.Name

local currentMode = "NONE"
local animDirection = "NONE"

local handGunState = 0
local hgStep = 1
local hgAnimStartTime = 0

-- ==========================================
-- PELARASAN ASAS
-- ==========================================
local FLOAT_HEIGHT       = 27
local SECOND_HAND_OFFSET = Vector3.new(22, 0, 0)
local THIRD_HAND_OFFSET  = Vector3.new(0, 0, -6)
local BACK_OFFSET        = Vector3.new(0, 0, -2.0)

-- ==========================================
-- ANIMASI TERAPUNG (idle bob - hanya masa ACTIVE)
-- ==========================================
local FLOAT_BOB_AMPLITUDE = 2.5
local FLOAT_BOB_SPEED     = 0.15

-- ==========================================
-- WALKING HAND ANIMATION (hanya masa ACTIVE)
-- ==========================================
local WALK_SPEED_THRESHOLD = 0.05
local WALK_LIFT            = 4
local WALK_FORWARD         = -3
local WALK_PITCH           = -25
local WALK_SWAY            = 0
local WALK_SWAY_SPEED      = 0.01
local WALK_SMOOTHNESS      = 2

local WALK_TIP_CURL_INDICES = {6, 9, 11}
local WALK_TIP_CURL_ANGLE   = -15

local isWalking    = false
local walkBlend    = 0
local walkSwayPhase = 0
local lastRootPos  = nil

local bobBlend     = 0
local bobPhase     = 0

-- ==========================================
-- WAVE MODE
-- ==========================================
local WAVE_SPEED     = 0.9
local WAVE_ROLL      = 28

-- ==========================================
-- WARNA
-- ==========================================
local HUE_MIN   = 0.25
local HUE_MAX   = 0.46
local SAT_MIN   = 0.55
local SAT_MAX   = 1.00
local VAL_MIN   = 0.55
local VAL_MAX   = 1.00
local COLOR_SPEED    = 0.40
local COLOR_WAVE     = 0.09
local GLINT_STRENGTH = 0.55

-- ==========================================
-- HAND GUN
-- ==========================================
local HG_POS_OFFSET = Vector3.new(0, 0, 4)
local HG_YAW        = 0
local HG_PITCH      = 0

-- ==========================================
-- FUCK FINGER
-- ==========================================
local FF_ADJUST_YAW      = 180
local FF_ADJUST_PITCH    = 0
local FF_ADJUST_ROLL     = 0
local FF_ADJUST_FORWARD  = 0

-- ==========================================
-- PROP 12
-- ==========================================
local PROP12_OFFSET    = Vector3.new(0, -2, 4)
local PROP12_HIDDEN_Y  = -100

-- ==========================================
-- SMASH
-- ==========================================
local SMASH_UP_HEIGHT    = 35
local SMASH_UP_FORWARD   = -12
local SMASH_DOWN_HEIGHT  = -4
local SMASH_DOWN_FORWARD = -16
local SMASH_SLAM_BOOST   = -10
local SMASH_DOWN_PITCH   = -90
local SMASH_UP_PITCH     = 0
local SMASH_WINDUP_DUR   = 0.45
local SMASH_SLAM_DUR     = 0.22
local SMASH_HOLD_DUR     = 0.90
local SMASH_RECOVER_DUR  = 0.45
local smashPhase         = 0
local smashStartTime     = 0

-- ==========================================
-- SPIN
-- ==========================================
local SPIN_SPEED = 90

-- ==========================================
-- TILT
-- ==========================================
local HAND_TILT_PITCH = 0
local HAND_TILT_YAW   = 0
local HAND_TILT_ROLL  = 0

-- ==========================================
-- SHOOT (TOGGLE)
-- ==========================================
local HIDE_PROP12      = true
local SHOOT_TILT_PITCH = -45
local SHOOT_TILT_DUR   = 0.25
local shootActive      = false
local shootAnimStart   = 0

-- ==========================================
-- PROPS LISTS
-- ==========================================
local propsList  = {}
local propsList2 = {}
local propsList3 = {}
local knownProps     = {}
local propStartPos   = {}
local orderLocked    = false
local lastRefreshTime  = tick()
local REFRESH_INTERVAL = 10
local NET_INTERVAL     = 1 / 30
local lastNetUpdate    = 0
local ANIM_DURATION    = 2.0
local animStartTime    = 0

local walkCurlSet = {}
for _, idx in ipairs(WALK_TIP_CURL_INDICES) do
    walkCurlSet[idx] = true
end

-- ==========================================
-- DATA CFRAME
-- ==========================================
local rawMain = {
    {pos = Vector3.new(-25.910, 45.412, 462.741) + BACK_OFFSET, rot = Vector3.new(87.855, 179.193, 0.060)},
    {pos = Vector3.new(-42.774, 45.092, 461.692) + BACK_OFFSET, rot = Vector3.new(0.906, -0.170, -39.150)},
    {pos = Vector3.new(-36.332, 39.849, 461.831) + BACK_OFFSET, rot = Vector3.new(0.906, -0.170, -39.150)},
    {pos = Vector3.new(-22.269, 66.631, 462.672) + BACK_OFFSET, rot = Vector3.new(-1.217, -179.151, -90.926)},
    {pos = Vector3.new(-26.473, 66.229, 462.760) + BACK_OFFSET, rot = Vector3.new(-1.252, 178.705, -90.878)},
    {pos = Vector3.new(-30.237, 65.783, 462.754) + BACK_OFFSET, rot = Vector3.new(-1.252, 178.705, -90.878)},
    {pos = Vector3.new(-18.371, 66.986, 462.658) + BACK_OFFSET, rot = Vector3.new(-1.252, 178.705, -90.878)},
    {pos = Vector3.new(-18.370, 58.563, 462.610) + BACK_OFFSET, rot = Vector3.new(-1.252, 178.705, -90.878)},
    {pos = Vector3.new(-22.282, 58.253, 462.644) + BACK_OFFSET, rot = Vector3.new(-1.252, 178.705, -90.878)},
    {pos = Vector3.new(-30.419, 57.614, 462.409) + BACK_OFFSET, rot = Vector3.new(-1.252, 178.705, -90.878)},
    {pos = Vector3.new(-26.363, 57.827, 462.751) + BACK_OFFSET, rot = Vector3.new(-1.252, 178.705, -90.878)}
}

local rawAnimA = {
    {pos = Vector3.new(-25.910, 45.412, 462.741) + BACK_OFFSET, rot = Vector3.new(87.855, 179.193, 0.060)},
    {pos = Vector3.new(-42.774, 45.092, 461.692) + BACK_OFFSET, rot = Vector3.new(0.904, -0.174, -39.150)},
    {pos = Vector3.new(-36.332, 39.849, 461.831) + BACK_OFFSET, rot = Vector3.new(0.896, -0.182, -39.150)},
    {pos = Vector3.new(-26.473, 66.229, 462.760) + BACK_OFFSET, rot = Vector3.new(-1.252, 178.705, -90.878)},
    {pos = Vector3.new(-29.777, 58.240, 456.182) + BACK_OFFSET, rot = Vector3.new(54.655, -6.568, 91.271)},
    {pos = Vector3.new(-30.340, 57.309, 460.554) + BACK_OFFSET, rot = Vector3.new(31.331, 173.458, -90.896)},
    {pos = Vector3.new(-26.363, 57.827, 462.751) + BACK_OFFSET, rot = Vector3.new(-1.252, 178.705, -90.878)},
    {pos = Vector3.new(-17.854, 54.359, 459.342) + BACK_OFFSET, rot = Vector3.new(74.444, -174.326, -82.524)},
    {pos = Vector3.new(-17.449, 52.933, 454.294) + BACK_OFFSET, rot = Vector3.new(40.255, -6.982, 90.965)},
    {pos = Vector3.new(-22.222, 57.309, 460.348) + BACK_OFFSET, rot = Vector3.new(31.331, 173.458, -90.896)},
    {pos = Vector3.new(-21.839, 58.240, 455.830) + BACK_OFFSET, rot = Vector3.new(54.655, -6.568, 91.271)}
}

local rawAnimB = {
    {pos = Vector3.new(-25.910, 45.412, 462.741) + BACK_OFFSET, rot = Vector3.new(87.855, 179.193, 0.060)},
    {pos = Vector3.new(-42.774, 45.092, 461.692) + BACK_OFFSET, rot = Vector3.new(0.904, -0.174, -39.150)},
    {pos = Vector3.new(-36.332, 39.849, 461.831) + BACK_OFFSET, rot = Vector3.new(0.896, -0.182, -39.150)},
    {pos = Vector3.new(-26.473, 66.229, 462.760) + BACK_OFFSET, rot = Vector3.new(-1.252, 178.705, -90.878)},
    {pos = Vector3.new(-29.749, 47.876, 457.528) + BACK_OFFSET, rot = Vector3.new(-29.663, -8.028, 90.852)},
    {pos = Vector3.new(-30.132, 51.934, 459.515) + BACK_OFFSET, rot = Vector3.new(70.896, -2.074, 96.715)},
    {pos = Vector3.new(-26.363, 57.827, 462.751) + BACK_OFFSET, rot = Vector3.new(-1.252, 178.705, -90.878)},
    {pos = Vector3.new(-18.499, 50.893, 459.874) + BACK_OFFSET, rot = Vector3.new(49.432, -2.077, 90.004)},
    {pos = Vector3.new(-18.970, 46.101, 458.634) + BACK_OFFSET, rot = Vector3.new(-33.729, -8.102, 90.897)},
    {pos = Vector3.new(-22.265, 51.834, 459.629) + BACK_OFFSET, rot = Vector3.new(69.822, -3.992, 92.221)},
    {pos = Vector3.new(-22.129, 47.401, 457.872) + BACK_OFFSET, rot = Vector3.new(-32.658, -8.075, 90.871)}
}

local rawGoodFinger = {
    {pos = Vector3.new(-25.910, 45.412, 462.741) + BACK_OFFSET, rot = Vector3.new(0.125, -88.343, 86.991)},
    {pos = Vector3.new(-33.587, 65.763, 463.133) + BACK_OFFSET, rot = Vector3.new(5.456, 1.057, -88.975)},
    {pos = Vector3.new(-20.229, 38.222, 458.651) + BACK_OFFSET, rot = Vector3.new(4.668, -51.342, -1.333)},
    {pos = Vector3.new(-25.087, 49.873, 458.686) + BACK_OFFSET, rot = Vector3.new(1.512, -136.999, -2.435)},
    {pos = Vector3.new(-19.797, 50.169, 459.119) + BACK_OFFSET, rot = Vector3.new(1.119, -59.211, 3.632)},
    {pos = Vector3.new(-33.480, 56.911, 462.956) + BACK_OFFSET, rot = Vector3.new(5.456, 1.057, -88.975)},
    {pos = Vector3.new(-25.804, 37.897, 459.171) + BACK_OFFSET, rot = Vector3.new(1.512, -136.999, -2.435)},
    {pos = Vector3.new(-19.824, 42.990, 458.752) + BACK_OFFSET, rot = Vector3.new(1.119, -59.211, 3.632)},
    {pos = Vector3.new(-25.038, 42.448, 458.704) + BACK_OFFSET, rot = Vector3.new(1.512, -136.999, -2.435)},
    {pos = Vector3.new(-24.997, 46.398, 458.630) + BACK_OFFSET, rot = Vector3.new(1.512, -136.999, -2.435)},
    {pos = Vector3.new(-19.875, 46.803, 458.861) + BACK_OFFSET, rot = Vector3.new(1.119, -59.211, 3.632)}
}

local rawHandGun1 = {
    {pos = Vector3.new(-25.910, 45.412, 462.741) + BACK_OFFSET, rot = Vector3.new(-1.365, -90.817, 87.854)},
    {pos = Vector3.new(-29.899, 64.628, 463.697) + BACK_OFFSET, rot = Vector3.new(-4.210, 178.311, -88.428)},
    {pos = Vector3.new(-13.699, 53.085, 462.863) + BACK_OFFSET, rot = Vector3.new(-3.038, 178.365, -179.363)},
    {pos = Vector3.new(-13.943, 40.668, 462.414) + BACK_OFFSET, rot = Vector3.new(-3.038, 178.365, -179.363)},
    {pos = Vector3.new(-5.829, 53.138, 462.884) + BACK_OFFSET, rot = Vector3.new(-3.038, 178.365, -179.363)},
    {pos = Vector3.new(-13.753, 45.068, 462.554) + BACK_OFFSET, rot = Vector3.new(-3.038, 178.365, -179.363)},
    {pos = Vector3.new(-13.729, 49.135, 462.844) + BACK_OFFSET, rot = Vector3.new(-3.038, 178.365, -179.363)},
    {pos = Vector3.new(-5.800, 40.668, 462.714) + BACK_OFFSET, rot = Vector3.new(-3.038, 178.365, -179.363)},
    {pos = Vector3.new(-5.619, 45.181, 462.977) + BACK_OFFSET, rot = Vector3.new(-3.038, 178.365, -179.363)},
    {pos = Vector3.new(-5.701, 48.983, 462.796) + BACK_OFFSET, rot = Vector3.new(-3.038, 178.365, -179.363)},
    {pos = Vector3.new(-30.126, 56.344, 462.999) + BACK_OFFSET, rot = Vector3.new(-4.210, 178.311, -88.428)}
}

local rawHandGun2 = {
    {pos = Vector3.new(-24.541, 42.114, 453.140) + BACK_OFFSET, rot = Vector3.new(-1.366, -88.738, 87.853)},
    {pos = Vector3.new(-23.376, 59.455, 453.149) + BACK_OFFSET, rot = Vector3.new(-4.450, -176.173, -62.737)},
    {pos = Vector3.new(-12.334, 49.787, 452.819) + BACK_OFFSET, rot = Vector3.new(-3.040, -179.557, -179.364)},
    {pos = Vector3.new(-16.157, 37.370, 447.514) + BACK_OFFSET, rot = Vector3.new(-1.598, -108.728, 177.339)},
    {pos = Vector3.new(-4.468, 49.840, 452.554) + BACK_OFFSET, rot = Vector3.new(-3.040, -179.557, -179.364)},
    {pos = Vector3.new(-16.063, 41.770, 447.492) + BACK_OFFSET, rot = Vector3.new(-1.340, -103.237, 177.197)},
    {pos = Vector3.new(-12.364, 45.837, 452.801) + BACK_OFFSET, rot = Vector3.new(-3.040, -179.557, -179.364)},
    {pos = Vector3.new(-15.379, 38.120, 440.029) + BACK_OFFSET, rot = Vector3.new(0.513, -68.168, 176.936)},
    {pos = Vector3.new(-18.122, 42.058, 440.589) + BACK_OFFSET, rot = Vector3.new(1.910, -39.770, 177.557)},
    {pos = Vector3.new(-4.343, 45.685, 452.462) + BACK_OFFSET, rot = Vector3.new(-3.040, -179.557, -179.364)},
    {pos = Vector3.new(-29.988, 53.521, 453.070) + BACK_OFFSET, rot = Vector3.new(2.804, -0.179, -121.144)}
}

local rawHandGun3 = {
    {pos = Vector3.new(-24.541, 42.114, 453.140) + BACK_OFFSET, rot = Vector3.new(-1.366, -88.738, 87.853)},
    {pos = Vector3.new(-22.124, 57.530, 453.424) + BACK_OFFSET, rot = Vector3.new(-0.667, -177.425, -39.278)},
    {pos = Vector3.new(-12.334, 49.787, 452.819) + BACK_OFFSET, rot = Vector3.new(-3.040, -179.557, -179.364)},
    {pos = Vector3.new(-19.033, 37.370, 447.864) + BACK_OFFSET, rot = Vector3.new(1.600, -46.750, 177.342)},
    {pos = Vector3.new(-4.468, 49.840, 452.554) + BACK_OFFSET, rot = Vector3.new(-3.040, -179.557, -179.364)},
    {pos = Vector3.new(-17.944, 41.770, 447.488) + BACK_OFFSET, rot = Vector3.new(0.722, -64.275, 176.982)},
    {pos = Vector3.new(-12.364, 45.837, 452.801) + BACK_OFFSET, rot = Vector3.new(-3.040, -179.557, -179.364)},
    {pos = Vector3.new(-25.290, 38.120, 446.610) + BACK_OFFSET, rot = Vector3.new(2.791, 38.545, -178.631)},
    {pos = Vector3.new(-23.396, 42.058, 446.002) + BACK_OFFSET, rot = Vector3.new(2.769, 38.849, -178.614)},
    {pos = Vector3.new(-4.343, 45.685, 452.462) + BACK_OFFSET, rot = Vector3.new(-3.040, -179.557, -179.364)},
    {pos = Vector3.new(-29.988, 53.521, 453.070) + BACK_OFFSET, rot = Vector3.new(1.900, 5.228, -121.053)}
}

local sumPos = Vector3.zero
for _, d in ipairs(rawMain) do sumPos = sumPos + d.pos end
local centerBase = sumPos / #rawMain

local function createOffsets(rawData, height)
    local offsets = {}
    local currentHeight = Vector3.new(0, height, 0)
    for i, d in ipairs(rawData) do
        local relPos = (d.pos - centerBase) + currentHeight
        local rotCF = CFrame.fromOrientation(math.rad(d.rot.X), math.rad(d.rot.Y), math.rad(d.rot.Z))
        offsets[i] = CFrame.new(relPos) * rotCF
    end
    return offsets
end

local offsets_Main  = createOffsets(rawMain,       FLOAT_HEIGHT)
local offsets_AnimA = createOffsets(rawAnimA,      FLOAT_HEIGHT)
local offsets_AnimB = createOffsets(rawAnimB,      FLOAT_HEIGHT)
local offsets_Good  = createOffsets(rawGoodFinger, FLOAT_HEIGHT)
local offsets_HG1   = createOffsets(rawHandGun1,   FLOAT_HEIGHT)
local offsets_HG2   = createOffsets(rawHandGun2,   FLOAT_HEIGHT)
local offsets_HG3   = createOffsets(rawHandGun3,   FLOAT_HEIGHT)

local function applyHGAdjust(offsets)
    local rot = CFrame.Angles(math.rad(HG_PITCH), math.rad(HG_YAW), 0)
    local pos = CFrame.new(HG_POS_OFFSET)
    local out = {}
    for i, cf in ipairs(offsets) do out[i] = pos * rot * cf end
    return out
end
offsets_HG1 = applyHGAdjust(offsets_HG1)
offsets_HG2 = applyHGAdjust(offsets_HG2)
offsets_HG3 = applyHGAdjust(offsets_HG3)

local function applyFFAdjust(offsets)
    local rot = CFrame.Angles(math.rad(FF_ADJUST_PITCH), math.rad(FF_ADJUST_YAW), math.rad(FF_ADJUST_ROLL))
    local pos = CFrame.new(0, 0, FF_ADJUST_FORWARD)
    local out = {}
    for i, cf in ipairs(offsets) do out[i] = pos * rot * cf end
    return out
end
offsets_AnimA = applyFFAdjust(offsets_AnimA)
offsets_AnimB = applyFFAdjust(offsets_AnimB)

local function transformOffsets(offsets, pitch, forward)
    local rot = CFrame.Angles(math.rad(pitch), 0, 0)
    local pos = CFrame.new(0, 0, forward)
    local out = {}
    for i, cf in ipairs(offsets) do out[i] = pos * rot * cf end
    return out
end
local offsets_SmashUp = transformOffsets(createOffsets(rawMain, SMASH_UP_HEIGHT), SMASH_UP_PITCH, SMASH_UP_FORWARD)
local offsets_SmashDown = transformOffsets(createOffsets(rawMain, SMASH_DOWN_HEIGHT), SMASH_DOWN_PITCH, SMASH_DOWN_FORWARD)

local function applyTilt(offsets, floatHeight)
    local center = CFrame.new(0, floatHeight, 0)
    local tiltCF = center * CFrame.Angles(math.rad(HAND_TILT_PITCH), math.rad(HAND_TILT_YAW), math.rad(HAND_TILT_ROLL)) * center:Inverse()
    local out = {}
    for i, cf in ipairs(offsets) do out[i] = tiltCF * cf end
    return out
end
offsets_Main      = applyTilt(offsets_Main,      FLOAT_HEIGHT)
offsets_AnimA     = applyTilt(offsets_AnimA,     FLOAT_HEIGHT)
offsets_AnimB     = applyTilt(offsets_AnimB,     FLOAT_HEIGHT)
offsets_Good      = applyTilt(offsets_Good,      FLOAT_HEIGHT)
offsets_HG1       = applyTilt(offsets_HG1,       FLOAT_HEIGHT)
offsets_HG2       = applyTilt(offsets_HG2,       FLOAT_HEIGHT)
offsets_HG3       = applyTilt(offsets_HG3,       FLOAT_HEIGHT)
offsets_SmashUp   = applyTilt(offsets_SmashUp,   SMASH_UP_HEIGHT)
offsets_SmashDown = applyTilt(offsets_SmashDown, SMASH_DOWN_HEIGHT)

-- ==========================================
-- GUI
-- ==========================================
local GREEN_DARK   = Color3.fromRGB(10, 30, 15)
local GREEN_MID    = Color3.fromRGB(20, 60, 30)
local GREEN_BRIGHT = Color3.fromRGB(80, 255, 120)
local GREEN_SOFT   = Color3.fromRGB(150, 220, 150)
local GREEN_ON     = Color3.fromRGB(120, 255, 150)
local GREEN_OFF    = Color3.fromRGB(255, 180, 180)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AllSeeingHand_Gui"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LP:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 210, 0, 418)
MainFrame.Position = UDim2.new(0.5, -105, 0.4, -209)
MainFrame.BackgroundColor3 = GREEN_DARK
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = GREEN_BRIGHT
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.4
MainStroke.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 20)
TitleLabel.Position = UDim2.new(0, 0, 0, 8)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "ALL SEEING HAND"
TitleLabel.TextColor3 = GREEN_BRIGHT
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 16
TitleLabel.Parent = MainFrame

local SubTitleLabel = Instance.new("TextLabel")
SubTitleLabel.Size = UDim2.new(1, 0, 0, 14)
SubTitleLabel.Position = UDim2.new(0, 0, 0, 26)
SubTitleLabel.BackgroundTransparency = 1
SubTitleLabel.Text = "Made By c00lful"
SubTitleLabel.TextColor3 = GREEN_SOFT
SubTitleLabel.Font = Enum.Font.SourceSansItalic
SubTitleLabel.TextSize = 11
SubTitleLabel.Parent = MainFrame

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 22, 0, 22)
MinimizeBtn.Position = UDim2.new(1, -28, 0, 6)
MinimizeBtn.BackgroundColor3 = GREEN_BRIGHT
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.TextSize = 16
MinimizeBtn.Parent = MainFrame
local MinBtnCorner = Instance.new("UICorner")
MinBtnCorner.CornerRadius = UDim.new(0, 6)
MinBtnCorner.Parent = MinimizeBtn

local MiniDCBtn = Instance.new("TextButton")
MiniDCBtn.Size = UDim2.new(0, 48, 0, 48)
MiniDCBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
MiniDCBtn.BackgroundColor3 = GREEN_DARK
MiniDCBtn.Text = "DC"
MiniDCBtn.TextColor3 = GREEN_BRIGHT
MiniDCBtn.Font = Enum.Font.SourceSansBold
MiniDCBtn.TextSize = 15
MiniDCBtn.Visible = false
MiniDCBtn.Active = true
MiniDCBtn.Parent = ScreenGui
local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(1, 0)
MiniCorner.Parent = MiniDCBtn
local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = GREEN_BRIGHT
MiniStroke.Thickness = 1.5
MiniStroke.Transparency = 0.3
MiniStroke.Parent = MiniDCBtn

local function makeBtn(text, y, parent)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 160, 0, 32)
    b.Position = UDim2.new(0.5, -80, 0, y)
    b.BackgroundColor3 = GREEN_MID
    b.Text = text
    b.TextColor3 = GREEN_BRIGHT
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 14
    b.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = b
    local s = Instance.new("UIStroke")
    s.Color = GREEN_BRIGHT
    s.Thickness = 1
    s.Transparency = 0.6
    s.Parent = b
    return b
end

local AktifBtn   = makeBtn("ACTIVE HAND",  50,  MainFrame)
local AnimBtn    = makeBtn("FUCK FINGER",  88,  MainFrame)
local GoodBtn    = makeBtn("GOOD FINGER",  126, MainFrame)
local WaveBtn    = makeBtn("WAVE",         164, MainFrame)
local HandGunBtn = makeBtn("HAND GUN",     202, MainFrame)
local SmashBtn   = makeBtn("SMASH",        240, MainFrame)
local SpinBtn    = makeBtn("SPIN",         278, MainFrame)
local ShootBtn   = makeBtn("SHOOT",        316, MainFrame)

local function enableDrag(frame)
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
enableDrag(MainFrame)
enableDrag(MiniDCBtn)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniDCBtn.Visible = true
end)
MiniDCBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MiniDCBtn.Visible = false
end)

-- ==========================================
-- PROPS REFRESH (with lock)
-- ==========================================
local function RefreshPropsList()
    local tc = workspace:FindFirstChild("WorkspaceCom") and workspace.WorkspaceCom:FindFirstChild("001_TrafficCones")
    if not tc then return end
    local n1 = (OwnerName == "terasiremik") and "Propterasiremik"  or ("Prop"  .. OwnerName)
    local n2 = (OwnerName == "terasiremik") and "Prop2terasiremik" or ("Prop2" .. OwnerName)
    local n3 = (OwnerName == "terasiremik") and "Prop3terasiremik" or ("Prop3" .. OwnerName)

    local function prune(list)
        for i = #list, 1, -1 do
            if not list[i] or not list[i].Parent then
                table.remove(list, i)
            end
        end
    end
    prune(propsList)
    prune(propsList2)
    prune(propsList3)

    for _, v in ipairs(tc:GetChildren()) do
        if not knownProps[v] then
            if v.Name == n1 or v.Name == n2 or v.Name == n3 then
                knownProps[v] = true
                local pos
                if v:IsA("BasePart") then pos = v.Position
                elseif v:IsA("Model") then pos = v:GetPivot().Position end
                propStartPos[v] = pos

                if     v.Name == n1 then table.insert(propsList,  v)
                elseif v.Name == n2 then table.insert(propsList2, v)
                elseif v.Name == n3 then table.insert(propsList3, v)
                end
            end
        end
    end

    if not orderLocked then
        local function sortFn(a, b)
            local pa, pb = propStartPos[a], propStartPos[b]
            if not pa or not pb then return false end
            if math.abs(pa.Y - pb.Y) > 0.5 then return pa.Y > pb.Y end
            if math.abs(pa.X - pb.X) > 0.5 then return pa.X < pb.X end
            return pa.Z < pb.Z
        end
        table.sort(propsList,  sortFn)
        table.sort(propsList2, sortFn)
        table.sort(propsList3, sortFn)
    end
end
RefreshPropsList()

task.delay(5, function()
    orderLocked = true
    print("[ALL SEEING HAND] Prop order auto-locked.")
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.L then
        orderLocked = true
        print("[ALL SEEING HAND] Prop order locked manually.")
    end
end)

-- ==========================================
-- BUTTONS
-- ==========================================
local function off(btn, text)
    btn.Text = text
    btn.BackgroundColor3 = GREEN_MID
    btn.TextColor3 = GREEN_BRIGHT
end
local function on(btn, text)
    btn.Text = text
    btn.BackgroundColor3 = GREEN_ON
    btn.TextColor3 = Color3.fromRGB(0, 40, 10)
end

local function resetAllButtons()
    off(AktifBtn,   "ACTIVE HAND")
    off(AnimBtn,    "FUCK FINGER")
    off(GoodBtn,    "GOOD FINGER")
    off(WaveBtn,    "WAVE")
    off(HandGunBtn, "HAND GUN")
    off(SmashBtn,   "SMASH")
    off(SpinBtn,    "SPIN")
    off(ShootBtn,   "SHOOT")
    handGunState = 0
    hgStep = 1
    smashPhase = 0
    shootActive = false
    shootAnimStart = 0
end

AktifBtn.MouseButton1Click:Connect(function()
    if currentMode == "ACTIVE" then
        currentMode = "NONE"; resetAllButtons()
    else
        resetAllButtons(); currentMode = "ACTIVE"
        on(AktifBtn, "ACTIVE HAND [ON]")
    end
    RefreshPropsList(); lastRefreshTime = tick()
end)

AnimBtn.MouseButton1Click:Connect(function()
    if currentMode ~= "GREEN_DOTS" then
        resetAllButtons(); currentMode = "GREEN_DOTS"; animDirection = "NONE"
    end
    if animDirection == "NONE" or animDirection == "REVERSE" or animDirection == "FINISHED_REVERSE" then
        animDirection = "FORWARD"; animStartTime = tick()
        on(AnimBtn, "FUCK FINGER")
    elseif animDirection == "FORWARD" then
        animDirection = "REVERSE"; animStartTime = tick()
        AnimBtn.BackgroundColor3 = GREEN_OFF
        AnimBtn.TextColor3 = Color3.fromRGB(80, 0, 0)
    elseif animDirection == "REVERSE" then
        currentMode = "NONE"; animDirection = "NONE"
        off(AnimBtn, "FUCK FINGER")
    end
    AnimBtn.Text = "FUCK FINGER"
    RefreshPropsList(); lastRefreshTime = tick()
end)

GoodBtn.MouseButton1Click:Connect(function()
    if currentMode ~= "GOOD_FINGER" then
        resetAllButtons(); currentMode = "GOOD_FINGER"; animDirection = "FORWARD"
        on(GoodBtn, "GOOD FINGER [ON]")
    else
        currentMode = "ACTIVE"; animDirection = "NONE"
        resetAllButtons()
        on(AktifBtn, "ACTIVE HAND [ON]")
    end
    RefreshPropsList(); lastRefreshTime = tick()
end)

WaveBtn.MouseButton1Click:Connect(function()
    if currentMode == "WAVE" then
        currentMode = "NONE"; resetAllButtons()
    else
        resetAllButtons(); currentMode = "WAVE"
        on(WaveBtn, "WAVE [ON]")
    end
    RefreshPropsList(); lastRefreshTime = tick()
end)

HandGunBtn.MouseButton1Click:Connect(function()
    if currentMode ~= "HAND_GUN" then
        resetAllButtons(); currentMode = "HAND_GUN"
        handGunState = 1; hgStep = 1; hgAnimStartTime = tick()
        on(HandGunBtn, "HAND GUN")
    else
        if handGunState == 1 then
            handGunState = 2; hgStep = 3; hgAnimStartTime = tick()
            HandGunBtn.BackgroundColor3 = GREEN_OFF
            HandGunBtn.TextColor3 = Color3.fromRGB(80, 0, 0)
        else
            handGunState = 1; hgStep = 1; hgAnimStartTime = tick()
            on(HandGunBtn, "HAND GUN")
        end
    end
    RefreshPropsList(); lastRefreshTime = tick()
end)

SmashBtn.MouseButton1Click:Connect(function()
    if currentMode == "SMASH" then
        currentMode = "NONE"; smashPhase = 0; resetAllButtons()
    else
        resetAllButtons(); currentMode = "SMASH"; smashPhase = 1; smashStartTime = tick()
        on(SmashBtn, "SMASH [ON]")
    end
    RefreshPropsList(); lastRefreshTime = tick()
end)

SpinBtn.MouseButton1Click:Connect(function()
    if currentMode == "SPIN" then
        currentMode = "NONE"; resetAllButtons()
    else
        resetAllButtons(); currentMode = "SPIN"
        on(SpinBtn, "SPIN [ON]")
    end
    RefreshPropsList(); lastRefreshTime = tick()
end)

ShootBtn.MouseButton1Click:Connect(function()
    if shootActive then
        shootActive = false
        off(ShootBtn, "SHOOT")
    else
        if currentMode == "NONE" then
            currentMode = "ACTIVE"
            on(AktifBtn, "ACTIVE HAND [ON]")
        end
        shootActive = true; shootAnimStart = tick()
        on(ShootBtn, "SHOOT [ON]")
    end
    RefreshPropsList()
end)

-- ==========================================
-- WARNA PROP
-- ==========================================
local function getPropColor(t, index)
    local phase = t * COLOR_SPEED + (index or 1) * COLOR_WAVE
    local wave1 = (math.sin(phase * math.pi * 2) + 1) * 0.5
    local wave2 = (math.cos(phase * math.pi * 2 * 0.63) + 1) * 0.5
    local wave3 = (math.sin(phase * math.pi * 2 * 1.47 + 1.7) + 1) * 0.5
    local hue = HUE_MIN + (HUE_MAX - HUE_MIN) * wave1
    local sat = SAT_MIN + (SAT_MAX - SAT_MIN) * wave2
    local val = VAL_MIN + (VAL_MAX - VAL_MIN) * (wave3 * 0.6 + wave1 * 0.4)
    local color = Color3.fromHSV(hue, sat, val)
    if wave1 > 0.93 then
        local shine = (wave1 - 0.93) / 0.07
        color = color:Lerp(Color3.new(1, 1, 1), shine * GLINT_STRENGTH)
    end
    return color
end

local function paintProp(prop, color)
    local colRemote = prop:FindFirstChild("ChangePropColor")
    if colRemote then
        pcall(function() colRemote:InvokeServer(color) end)
    else
        if prop:IsA("BasePart") then prop.Color = color
        elseif prop:IsA("Model") then
            for _, part in ipairs(prop:GetDescendants()) do
                if part:IsA("BasePart") then part.Color = color end
            end
        end
    end
end

local function setPropTransparency(prop, trans)
    if prop:IsA("BasePart") then
        prop.Transparency = trans
    elseif prop:IsA("Model") then
        for _, part in ipairs(prop:GetDescendants()) do
            if part:IsA("BasePart") then part.Transparency = trans end
        end
    end
end

-- ==========================================
-- APPLY HAND
-- ==========================================
local function applyHand(list, worldBase, sendNet, alphaGD, hgProg, hgAlph, handColorOffset)
    local shootTilt = CFrame.new()
    if shootActive then
        local elapsed = tick() - shootAnimStart
        local a = math.clamp(elapsed / SHOOT_TILT_DUR, 0, 1)
        a = a * a * (3 - 2 * a)
        local angle = math.rad(SHOOT_TILT_PITCH) * a
        local center = CFrame.new(0, FLOAT_HEIGHT, 0)
        shootTilt = center * CFrame.Angles(angle, 0, 0) * center:Inverse()
    end

    local bobOffset = math.sin(bobPhase) * FLOAT_BOB_AMPLITUDE * bobBlend

    local walkLift  = WALK_LIFT    * walkBlend
    local walkFwd   = WALK_FORWARD * walkBlend
    local walkSwayX = 0
    local walkPitch = 0
    if walkBlend > 0.01 then
        walkSwayX = math.sin(walkSwayPhase) * WALK_SWAY * walkBlend
        walkPitch = math.rad(WALK_PITCH * walkBlend)
    end

    local walkPosCF  = CFrame.new(walkSwayX, walkLift + bobOffset, walkFwd)
    local walkTiltCF = CFrame.new()
    if walkPitch ~= 0 then
        local center = CFrame.new(0, FLOAT_HEIGHT, 0)
        walkTiltCF = center * CFrame.Angles(walkPitch, 0, 0) * center:Inverse()
    end

    local tipCurlAngle = math.rad(WALK_TIP_CURL_ANGLE * walkBlend)
    local tipCurlCF = CFrame.Angles(tipCurlAngle, 0, 0)

    local waveRockCF = CFrame.new()
    if currentMode == "WAVE" then
        local rockAngle = math.sin(tick() * WAVE_SPEED * math.pi * 2) * WAVE_ROLL
        local center = CFrame.new(0, FLOAT_HEIGHT, 0)
        waveRockCF = center * CFrame.Angles(0, 0, math.rad(rockAngle)) * center:Inverse()
    end

    for i, prop in ipairs(list) do
        if prop and prop.Parent then
            local isProp12        = (i == 12)
            local hideUnderground = isProp12 and HIDE_PROP12 and not shootActive
            local prop12AtPalm    = isProp12 and shootActive

            local perPropColor
            if isProp12 then
                perPropColor = Color3.fromRGB(255, 255, 255)
            else
                perPropColor = getPropColor(tick(), i + (handColorOffset or 0))
            end
            if sendNet then
                task.spawn(function() paintProp(prop, perPropColor) end)
            end

            local slot = ((i - 1) % #offsets_Main) + 1
            if prop12AtPalm then slot = 1 end

            local currentOffset = nil
            local finalOffset   = nil

            if hideUnderground then
                finalOffset = CFrame.new(0, PROP12_HIDDEN_Y, 0)
                setPropTransparency(prop, 1)
            else
                if isProp12 then setPropTransparency(prop, 0) end

                if currentMode == "ACTIVE" then
                    currentOffset = offsets_Main[slot]
                elseif currentMode == "GOOD_FINGER" then
                    if animDirection == "FORWARD" then currentOffset = offsets_Good[slot]
                    else currentOffset = offsets_Main[slot] end
                elseif currentMode == "WAVE" then
                    currentOffset = waveRockCF * offsets_Main[slot]
                elseif currentMode == "GREEN_DOTS" then
                    if animDirection == "FORWARD" then
                        if offsets_AnimA[slot] and offsets_AnimB[slot] then
                            currentOffset = offsets_AnimA[slot]:Lerp(offsets_AnimB[slot], alphaGD)
                        end
                    elseif animDirection == "REVERSE" then
                        if offsets_AnimA[slot] and offsets_AnimB[slot] then
                            currentOffset = offsets_AnimB[slot]:Lerp(offsets_AnimA[slot], alphaGD)
                        end
                    elseif animDirection == "FINISHED_REVERSE" then
                        currentOffset = offsets_Main[slot]
                    end
                elseif currentMode == "HAND_GUN" then
                    if handGunState == 1 then
                        if hgStep == 1 then
                            if hgProg == 0 then currentOffset = offsets_HG1[slot]
                            else currentOffset = offsets_HG1[slot]:Lerp(offsets_HG2[slot], hgAlph) end
                        elseif hgStep == 2 then
                            currentOffset = offsets_HG2[slot]:Lerp(offsets_HG3[slot], hgAlph)
                        elseif hgStep == 3 then
                            currentOffset = offsets_HG3[slot]
                        end
                    elseif handGunState == 2 then
                        if hgStep == 3 then currentOffset = offsets_HG3[slot]:Lerp(offsets_HG2[slot], hgAlph)
                        elseif hgStep == 2 then currentOffset = offsets_HG2[slot]:Lerp(offsets_HG1[slot], hgAlph)
                        elseif hgStep == 1 then currentOffset = offsets_HG1[slot] end
                    end
                elseif currentMode == "SMASH" then
                    local elapsed = tick() - smashStartTime
                    local up   = offsets_SmashUp[slot]
                    local down = offsets_SmashDown[slot]
                    local base = offsets_Main[slot]
                    if smashPhase == 1 then
                        local a = math.clamp(elapsed / SMASH_WINDUP_DUR, 0, 1)
                        a = a * a * (3 - 2 * a)
                        currentOffset = base:Lerp(up, a)
                    elseif smashPhase == 2 then
                        local a = math.clamp(elapsed / SMASH_SLAM_DUR, 0, 1)
                        a = a * a
                        currentOffset = up:Lerp(down, a)
                    elseif smashPhase == 3 then
                        currentOffset = down
                    elseif smashPhase == 4 then
                        local a = math.clamp(elapsed / SMASH_RECOVER_DUR, 0, 1)
                        a = a * a * (3 - 2 * a)
                        currentOffset = down:Lerp(base, a)
                    else
                        currentOffset = base
                    end
                elseif currentMode == "SPIN" then
                    local spinAngle = (tick() * SPIN_SPEED) % 360
                    local spinRot = CFrame.Angles(0, math.rad(spinAngle), 0)
                    currentOffset = spinRot * offsets_Main[slot]
                end

                if currentOffset then
                    if walkBlend > 0.01 and walkCurlSet[slot] then
                        currentOffset = currentOffset * tipCurlCF
                    end

                    finalOffset = shootTilt * currentOffset
                    finalOffset = walkPosCF * walkTiltCF * finalOffset
                end
            end

            if finalOffset then
                local targetCF = worldBase * finalOffset

                if currentMode == "SMASH" then
                    local boostAmount = 0
                    if smashPhase == 2 then
                        local e = tick() - smashStartTime
                        boostAmount = math.clamp(e / SMASH_SLAM_DUR, 0, 1)
                    elseif smashPhase == 3 then
                        boostAmount = 1
                    elseif smashPhase == 4 then
                        local e = tick() - smashStartTime
                        local a = math.clamp(e / SMASH_RECOVER_DUR, 0, 1)
                        a = a * a * (3 - 2 * a)
                        boostAmount = 1 - a
                    end
                    if boostAmount > 0 then
                        targetCF = worldBase * CFrame.new(0, 0, SMASH_SLAM_BOOST * boostAmount) * finalOffset
                    end
                end

                if prop:IsA("Model") then prop:PivotTo(targetCF)
                elseif prop:IsA("BasePart") then prop.CFrame = targetCF end

                if sendNet then
                    task.spawn(function()
                        local cfRemote = prop:FindFirstChild("SetCurrentCFrame")
                        if cfRemote then pcall(function() cfRemote:InvokeServer(targetCF) end) end
                    end)
                end
            end
        end
    end
end

-- ==========================================
-- HEARTBEAT
-- ==========================================
RS.Heartbeat:Connect(function(dt)
    if currentMode == "NONE" then return end
    local t = tick()

    if t - lastRefreshTime >= REFRESH_INTERVAL then
        lastRefreshTime = t
        RefreshPropsList()
    end

    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local currentPos = root.Position
    local currentlyMoving = false
    if lastRootPos then
        local moveDelta = (currentPos - lastRootPos).Magnitude
        currentlyMoving = moveDelta > WALK_SPEED_THRESHOLD
    end
    lastRootPos = currentPos

    local targetBlend = (currentlyMoving and currentMode == "ACTIVE" and not shootActive) and 1 or 0
    if targetBlend == 0 then
        walkBlend = walkBlend + (0 - walkBlend) * math.clamp(dt * WALK_SMOOTHNESS * 8, 0, 1)
        if walkBlend < 0.01 then walkBlend = 0 end
    else
        walkBlend = walkBlend + (targetBlend - walkBlend) * math.clamp(dt * WALK_SMOOTHNESS, 0, 1)
    end

    if walkBlend > 0.01 then
        walkSwayPhase = walkSwayPhase + dt * WALK_SWAY_SPEED * math.pi * 2
    end

    local targetBob = (currentMode == "ACTIVE" and not shootActive) and 1 or 0
    if targetBob == 0 then
        bobBlend = bobBlend + (0 - bobBlend) * math.clamp(dt * 8, 0, 1)
        if bobBlend < 0.01 then bobBlend = 0 end
    else
        bobBlend = bobBlend + (targetBob - bobBlend) * math.clamp(dt * 3, 0, 1)
    end

    if bobBlend > 0.01 then
        bobPhase = bobPhase + dt * FLOAT_BOB_SPEED * math.pi * 2
    end

    local targetWorldBase = root.CFrame
    local canSendNetwork = (t - lastNetUpdate >= NET_INTERVAL)

    local rawProgress = 0
    local smoothAlpha = 0
    if currentMode == "GREEN_DOTS" and animDirection ~= "NONE" and animDirection ~= "FINISHED_REVERSE" then
        rawProgress = math.clamp((t - animStartTime) / ANIM_DURATION, 0, 1)
        smoothAlpha = rawProgress * rawProgress * (3 - 2 * rawProgress)
    end
    if currentMode == "GREEN_DOTS" and animDirection == "REVERSE" and rawProgress >= 1 then
        animDirection = "FINISHED_REVERSE"
        off(AnimBtn, "FUCK FINGER")
    end

    local hgProgress = 0
    local hgAlpha = 0
    if currentMode == "HAND_GUN" then
        hgProgress = math.clamp((t - hgAnimStartTime) / ANIM_DURATION, 0, 1)
        hgAlpha = hgProgress * hgProgress * (3 - 2 * hgProgress)
        if hgProgress >= 1 then
            if handGunState == 1 then
                if hgStep == 1 then hgStep = 2; hgAnimStartTime = t
                elseif hgStep == 2 then hgStep = 3; hgAnimStartTime = t end
            elseif handGunState == 2 then
                if hgStep == 3 then hgStep = 2; hgAnimStartTime = t
                elseif hgStep == 2 then hgStep = 1; hgAnimStartTime = t
                elseif hgStep == 1 then
                    currentMode = "ACTIVE"
                    on(AktifBtn, "ACTIVE HAND [ON]")
                    off(HandGunBtn, "HAND GUN")
                end
            end
        end
    end

    if currentMode == "SMASH" then
        local elapsed = t - smashStartTime
        if smashPhase == 1 then
            if elapsed >= SMASH_WINDUP_DUR then smashPhase = 2; smashStartTime = t end
        elseif smashPhase == 2 then
            if elapsed >= SMASH_SLAM_DUR then smashPhase = 3; smashStartTime = t end
        elseif smashPhase == 3 then
            if elapsed >= SMASH_HOLD_DUR then smashPhase = 4; smashStartTime = t end
        elseif smashPhase == 4 then
            if elapsed >= SMASH_RECOVER_DUR then
                currentMode = "ACTIVE"; smashPhase = 0
                off(SmashBtn, "SMASH")
                on(AktifBtn, "ACTIVE HAND [ON]")
            end
        end
    end

    applyHand(propsList,  targetWorldBase,                                   canSendNetwork, smoothAlpha, hgProgress, hgAlpha,  0)
    applyHand(propsList2, targetWorldBase * CFrame.new(SECOND_HAND_OFFSET),  canSendNetwork, smoothAlpha, hgProgress, hgAlpha, 40)
    applyHand(propsList3, targetWorldBase * CFrame.new(THIRD_HAND_OFFSET),   canSendNetwork, smoothAlpha, hgProgress, hgAlpha, 80)

    if canSendNetwork then lastNetUpdate = t end
end)