print("Remake By Xlu0 Anti Cheat Bypass By Prime")
print("Remake By Xlu0 Anti Cheat Bypass By Prime")
print("Remake By Xlu0 Anti Cheat Bypass By Prime")
print("Remake By Xlu0 Anti Cheat Bypass By Prime")
print("Remake By Xlu0 Anti Cheat Bypass By Prime")
print("Remake By Xlu0 Anti Cheat Bypass By Prime")
print("Remake By Xlu0 Anti Cheat Bypass By Prime")
print("Remake By Xlu0 Anti Cheat Bypass By Prime")

Players = game:GetService("Players")
UserInputService = game:GetService("UserInputService")
TweenService = game:GetService("TweenService")
RunService = game:GetService("RunService")
HttpService = game:GetService("HttpService")
Lighting = game:GetService("Lighting")
Workspace = game:GetService("Workspace")
Stats = game:GetService("Stats")
MaterialService = game:GetService("MaterialService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
SoundService = game:GetService("SoundService")
StarterGui = game:GetService("StarterGui")
CoreGui = game:GetService("CoreGui")

--Leaked By Xlu0 AndPrime--
--Leaked By Xlu0 AndPrime--
_syn = rawget((getgenv and getgenv()) or _G, "syn") or rawget(_G, "syn")

--Leaked By Xlu0 AndPrime--
if type(protectgui) ~= "function" and _syn and type(_syn.protect_gui) == "function" then
    protectgui = _syn.protect_gui
end

--Leaked By Xlu0 AndPrime--
if type(getcustomasset) ~= "function" then
    if type(getexecutorasset) == "function" then
        getcustomasset = getexecutorasset
    elseif type(getsynasset) == "function" then
        getcustomasset = getsynasset
    elseif _syn and type(_syn.getcustomasset) == "function" then
        getcustomasset = _syn.getcustomasset
    elseif _syn and type(_syn.getsynasset) == "function" then
        getcustomasset = _syn.getsynasset
    end
end

--Leaked By Xlu0 AndPrime--
if type(isfile) ~= "function" and _syn and type(_syn.isfile) == "function" then isfile = _syn.isfile end
if type(readfile) ~= "function" and _syn and type(_syn.readfile) == "function" then readfile = _syn.readfile end
if type(writefile) ~= "function" and _syn and type(_syn.writefile) == "function" then writefile = _syn.writefile end
if type(delfile) ~= "function" and _syn and type(_syn.delfile) == "function" then delfile = _syn.delfile end

--Leaked By Xlu0 AndPrime--
if type(getconnections) ~= "function" then
    if type(get_signal_cons) == "function" then
        getconnections = get_signal_cons
    elseif type(getconnects) == "function" then
        getconnections = getconnects
    elseif _syn and type(_syn.get_signal_cons) == "function" then
        getconnections = _syn.get_signal_cons
    end
end

--Leaked By Xlu0 AndPrime--
function _xluCompatGuiParent()
    if type(gethui) == "function" then
        local ok, parent = pcall(gethui)
        if ok and parent then return parent end
    end
    local okCore, core = pcall(function() return CoreGui end)
    if okCore and core then return core end
    return nil
end

LP = Players.LocalPlayer
PlayerGui = LP:WaitForChild("PlayerGui")
--Leaked By Xlu0 AndPrime--
function getUndetectedGuiParent()
    --Leaked By Xlu0 AndPrime--
    if type(gethui) == "function" then
        local ok, parent = pcall(gethui)
        if ok and parent then return parent end
    end
    --Leaked By Xlu0 AndPrime--
    if protectgui then
        return game:GetService("CoreGui")
    end
    --Leaked By Xlu0 AndPrime--
    local cg = game:GetService("CoreGui")
    if cg then return cg end
    --Leaked By Xlu0 AndPrime--
    return PlayerGui
end

function safeParentGui(gui)
    pcall(function()
        if type(gethui) == "function" then
            local ok, parent = pcall(gethui)
            if ok and parent then
                gui.Parent = parent
                return
            end
        end
        if protectgui then
            gui.Parent = game:GetService("CoreGui")
            pcall(function() protectgui(gui) end)
            return
        end
        gui.Parent = game:GetService("CoreGui")
    end)
    --Leaked By Xlu0 AndPrime--
    if not gui.Parent then
        pcall(function() gui.Parent = PlayerGui end)
    end
end



AdaptAutoMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
_G.AdaptIsMobile = AdaptAutoMobile
_G.AdaptDeviceMode = AdaptAutoMobile and "MOBILE" or "PC"

for _, name in ipairs({"AdaptDuelsAdaptReconstruct", "AdaptHubPolished", "CyberHub"}) do
old = PlayerGui:FindFirstChild(name)
if old then old:Destroy() end
end
NS = 59.5
CS = 28.8
LAGGER_SPEED = 29
LAGGER_CARRY_SPEED = 15
currentSpeedMode = "Normal"
speedBoosterEnabled = true
autoCarrySpeedEnabled = false
setAutoCarrySpeedVisual = nil
_G.AdaptAutoCarryWasCarrying = false
_G.AdaptAutoCarrySavedMode = nil
autoStealEnabled = false
selectedStealMode = "Auto Steal V3"
autoStealRadius = 63
_G.AdaptStealRadii = _G.AdaptStealRadii or {["Auto Steal V3"] = 63, Semi = 9}
_G.AdaptStealRadii["Auto Steal V3"] = tonumber(_G.AdaptStealRadii["Auto Steal V3"] or _G.AdaptStealRadii.Normal) or 63
autoStealRadiusBox = nil
selectedAimbotMode = "Normal"
AIMBOT_SPEED = 58
LAGGER_AIMBOT_SPEED = 40
_G.AdaptAntiBypassAimbotSpeed = _G.AdaptAntiBypassAimbotSpeed or 58
if _G.AdaptAntiBypassLaggerAimbotSpeed == nil or tonumber(_G.AdaptAntiBypassLaggerAimbotSpeed) == 58 then _G.AdaptAntiBypassLaggerAimbotSpeed = 40 end
autoSwingEnabled = false
mirrorTPDownEnabled = false
_G.AdaptNormalAimbotOn = _G.AdaptNormalAimbotOn or false
_G.AdaptAntiBypassAimbotOn = _G.AdaptAntiBypassAimbotOn or false
antiDesyncAutoSwingEnabled = false
_G.AdaptAntiDesyncAimbotOn = _G.AdaptAntiDesyncAimbotOn or false
ANTI_DESYNC_AIMBOT_SPEED = 58
batCounterEnabled = false
medCounterEnabled = false
antiKickEnabled = false
setSafeModeVisual = nil
autoResetOnMedEnabled = false
espEnabled = false
showTracerEnabled = false
ragdollCountdownEnabled = true
fpsBoostEnabled = false
antiLagVisualEnabled = false
nukeOptimiserEnabled = false
fovEnabled = false
fovValue = 70
noCamCollisionEnabled = false
_G.AdaptNoPlayerCollisionEnabled = _G.AdaptNoPlayerCollisionEnabled or false
customFontVisualEnabled = false
_G.AdaptCustomFontSelected = _G.AdaptCustomFontSelected or "None"
skyTheme = "Night"
setPlayerESPVisual = nil
setTracerESPVisual = nil
setRagdollCountdownVisual = nil
setFPSBoostVisual = nil
setAntiLagVisual = nil
setNukeOptimiserVisual = nil
setFOVVisual = nil
setNoCamCollisionVisual = nil
_G.AdaptSetNoPlayerCollisionVisual = _G.AdaptSetNoPlayerCollisionVisual or nil
setCustomFontVisual = nil
skyValueLabel = nil
autoLeftEnabled = false
autoRightEnabled = false
DEFAULT_SPEED_KEYBINDS = {
SpeedToggle = Enum.KeyCode.Q,
LaggerToggle = Enum.KeyCode.R,
DropBrainrot = Enum.KeyCode.X,
Aimbot = Enum.KeyCode.E,
AntiDesyncAimbot = Enum.KeyCode.V,
AutoLeft = Enum.KeyCode.Z,
AutoRight = Enum.KeyCode.C,
ToggleUI = Enum.KeyCode.LeftControl,
}
DEFAULT_TP_DOWN_KEYBIND = Enum.KeyCode.F
speedKeybinds = {
SpeedToggle = DEFAULT_SPEED_KEYBINDS.SpeedToggle,
LaggerToggle = DEFAULT_SPEED_KEYBINDS.LaggerToggle,
DropBrainrot = DEFAULT_SPEED_KEYBINDS.DropBrainrot,
Aimbot = DEFAULT_SPEED_KEYBINDS.Aimbot,
AntiDesyncAimbot = DEFAULT_SPEED_KEYBINDS.AntiDesyncAimbot,
AutoLeft = DEFAULT_SPEED_KEYBINDS.AutoLeft,
AutoRight = DEFAULT_SPEED_KEYBINDS.AutoRight,
ToggleUI = DEFAULT_SPEED_KEYBINDS.ToggleUI,
}
speedKeybindButtons = {}
listeningForSpeedKey = nil
autoTPEnabled = false
autoTPHeight = 20
autoTPConn = nil
autoTPLastRun = 0
autoTPClickDebounce = false
tpDownKeybind = Enum.KeyCode.F
tpDownKeybindButton = nil
listeningForTPDownKey = false
keybindListenStartedAt = 0
setAutoTPVisual = nil
function doAutoTPDown(force)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum2 = char:FindFirstChildOfClass("Humanoid")
    if not hum2 then return end
    if not force then
        if hum2.FloorMaterial ~= Enum.Material.Air then return end
        if not (hrp.Position.Y >= (tonumber(autoTPHeight) or 20)) then return end
    end
    local yaw = select(2, hrp.CFrame:ToEulerAnglesYXZ())
    hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z) * CFrame.Angles(0, yaw, 0)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    pcall(function() hrp.Velocity = Vector3.zero end)
    pcall(function() hrp.RotVelocity = Vector3.zero end)
end
local function _clearAutoTPConnection()
if autoTPConn then
pcall(function() autoTPConn:Disconnect() end)
pcall(function() task.cancel(autoTPConn) end)
autoTPConn = nil
end
end
local function startAutoTP()
autoTPEnabled = true
_clearAutoTPConnection()
autoTPLastRun = 0
autoTPConn = RunService.Heartbeat:Connect(function()
if not autoTPEnabled then
_clearAutoTPConnection()
return
end
local now = tick()
if now - autoTPLastRun < 0.1 then return end
autoTPLastRun = now
pcall(function() doAutoTPDown(false) end)
end)
if setAutoTPVisual then setAutoTPVisual(true) end
end
local function stopAutoTP()
autoTPEnabled = false
_clearAutoTPConnection()
if setAutoTPVisual then setAutoTPVisual(false) end
end
local function runTPFloor()
pcall(function() doAutoTPDown(true) end)
end
local function toggleAutoTP(on)
if on then
startAutoTP()
else
stopAutoTP()
end
do end
end
function _G.AdaptStopAutoTPForAction()
if autoTPEnabled then
stopAutoTP()
pcall(function() if setAutoTPVisual then setAutoTPVisual(false) end end)
do end
end
end
local dropBrainrotActive = false
local _adaptDropConns = {}

_G.AdaptDropMode = (_G.AdaptDropMode == "Jump Drop") and "Jump Drop" or "Stand Drop"

local _xDropLastInvoke = 0
local _xDropConn = nil
local function stopDropBrainrot()
    dropBrainrotActive = false
    if _xDropConn then
        pcall(function() _xDropConn:Disconnect() end)
        _xDropConn = nil
    end
    for _, t in ipairs(_adaptDropConns) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif typeof(t) == "RBXScriptConnection" then pcall(function() t:Disconnect() end) end
    end
    _adaptDropConns = {}
    local c = LP.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

local function runStandDrop()
    if dropBrainrotActive then return end
    local now = tick()
    if now - _xDropLastInvoke < 0.2 then return end
    _xDropLastInvoke = now
    if _G.AdaptStopAutoTPForAction then _G.AdaptStopAutoTPForAction() end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    dropBrainrotActive = true
    local startTime = tick()
    _xDropConn = RunService.Heartbeat:Connect(function()
        local currentChar = LP.Character
        local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
        if not currentChar or not currentRoot then
            stopDropBrainrot()
            return
        end
        if tick() - startTime >= (_G.AdaptDropAscendDuration or 0.2) then
            if _xDropConn then pcall(function() _xDropConn:Disconnect() end); _xDropConn = nil end
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
            dropBrainrotActive = false
            return
        end
        local v = currentRoot.AssemblyLinearVelocity
        local up = tonumber(_G.AdaptDropAscendSpeed) or 150
        pcall(function()
            currentRoot.AssemblyLinearVelocity = Vector3.new(v.X, up, v.Z)
        end)
    end)
    task.delay(1.0, function()
        if dropBrainrotActive then stopDropBrainrot() end
    end)
end

_G.AdaptJumpDropActive = false
_G.AdaptJumpDropAscendDuration = 0.2
_G.AdaptJumpDropAscendSpeed = 150
_G.AdaptDropAscendDuration = _G.AdaptDropAscendDuration or 0.2
_G.AdaptDropAscendSpeed    = _G.AdaptDropAscendSpeed    or 150

function _G.AdaptRunJumpDrop()
if _G.AdaptJumpDropActive then return end
if _G.AdaptStopAutoTPForAction then pcall(_G.AdaptStopAutoTPForAction) end

local char = LP.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
if not char or not root then return end

_G.AdaptJumpDropActive = true
local startTime = tick()

_G.AdaptJumpDropConn = RunService.Heartbeat:Connect(function()
local currentChar = LP.Character
local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")

if not currentChar or not currentRoot then
if _G.AdaptJumpDropConn then
pcall(function() _G.AdaptJumpDropConn:Disconnect() end)
_G.AdaptJumpDropConn = nil
end
_G.AdaptJumpDropActive = false
return
end

if tick() - startTime >= _G.AdaptJumpDropAscendDuration then
if _G.AdaptJumpDropConn then
pcall(function() _G.AdaptJumpDropConn:Disconnect() end)
_G.AdaptJumpDropConn = nil
end

local rayParams = RaycastParams.new()
rayParams.FilterDescendantsInstances = {currentChar}
rayParams.FilterType = Enum.RaycastFilterType.Exclude

local rayResult = workspace:Raycast(currentRoot.Position, Vector3.new(0, -2000, 0), rayParams)
if rayResult then
local hum = currentChar:FindFirstChildOfClass("Humanoid")
local offset = (hum and hum.HipHeight or 2) + (currentRoot.Size.Y / 2)
currentRoot.CFrame = CFrame.new(currentRoot.Position.X, rayResult.Position.Y + offset, currentRoot.Position.Z)
currentRoot.AssemblyLinearVelocity = Vector3.zero
currentRoot.AssemblyAngularVelocity = Vector3.zero
end

_G.AdaptJumpDropActive = false
return
end

local _jdCur = currentRoot.AssemblyLinearVelocity
currentRoot.AssemblyLinearVelocity = Vector3.new(
_jdCur.X,
_G.AdaptJumpDropAscendSpeed,
_jdCur.Z
)
end)
end

function runDrop()
if _G.AdaptDropMode == "Jump Drop" then
_G.AdaptRunJumpDrop()
else
runStandDrop()
end
end

function runDropBrainrot()
runDrop()
end

local infJumpEnabled = false
local antiRagdollEnabled = false
local antiRagdollConn = nil
_G.AdaptAntiRagdollMode = "Zombie Hub"

_G.AdaptAntiVoidEnabled = _G.AdaptAntiVoidEnabled == true
_G.AdaptAntiVoidConnection = _G.AdaptAntiVoidConnection or nil
_G.AdaptAntiVoidSafeCFrame = _G.AdaptAntiVoidSafeCFrame or nil

function _G.AdaptAntiVoidSaveSafe()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end
    if hum.FloorMaterial ~= Enum.Material.Air then
        _G.AdaptAntiVoidSafeCFrame = root.CFrame
    end
end

function _G.AdaptAntiVoidStop()
    if _G.AdaptAntiVoidConnection then
        pcall(function() _G.AdaptAntiVoidConnection:Disconnect() end)
        _G.AdaptAntiVoidConnection = nil
    end
end

function _G.AdaptAntiVoidSet(on)
    _G.AdaptAntiVoidEnabled = on == true
    _G.AdaptAntiVoidStop()
    if not _G.AdaptAntiVoidEnabled then return end

    _G.AdaptAntiVoidSaveSafe()

    _G.AdaptAntiVoidConnection = RunService.Heartbeat:Connect(function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not _G.AdaptAntiVoidEnabled or not hum or not root or hum.Health <= 0 then return end

        local voidY = Workspace.FallenPartsDestroyHeight + 30
        if hum.FloorMaterial ~= Enum.Material.Air and root.Position.Y > voidY + 12 then
            _G.AdaptAntiVoidSafeCFrame = root.CFrame
        elseif root.Position.Y <= voidY and _G.AdaptAntiVoidSafeCFrame then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.CFrame = _G.AdaptAntiVoidSafeCFrame + Vector3.new(0, 4, 0)
            hum.PlatformStand = false
            hum.Sit = false
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end
    end)
end
local unwalkEnabled = false
local unwalkSavedAnimate = nil
local hitHarderAnimEnabled = false
local hitHarderOriginalAnims = {}
local selectedAnimationPack = "OFF"

local AnimationPacks = {
["Zombie"] = {
idle = {{"rbxassetid://616158929", 1}, {"rbxassetid://616160636", 1}},
walk = "rbxassetid://616168032",
run = "rbxassetid://616163682",
jump = "rbxassetid://616161997",
fall = "rbxassetid://616157476",
climb = "rbxassetid://616156119",
swim = "rbxassetid://616165109",
swimidle = "rbxassetid://616166655",
},
["Ninja"] = {
idle = {{"rbxassetid://656117400", 1}, {"rbxassetid://656117400", 1}},
walk = "rbxassetid://656121766",
run = "rbxassetid://656118852",
jump = "rbxassetid://656117878",
fall = "rbxassetid://656115606",
climb = "rbxassetid://656114359",
},
["Knight"] = {
idle = {{"rbxassetid://657595757", 1}, {"rbxassetid://657595757", 1}},
walk = "rbxassetid://657552124",
run = "rbxassetid://657564596",
jump = "rbxassetid://658409194",
fall = "rbxassetid://657600338",
climb = "rbxassetid://658360781",
},
["Elder"] = {
idle = {{"rbxassetid://845397899", 1}, {"rbxassetid://845397899", 1}},
walk = "rbxassetid://845403856",
run = "rbxassetid://845386501",
jump = "rbxassetid://845398858",
fall = "rbxassetid://845397673",
climb = "rbxassetid://845392038",
},
["Levitate"] = {
idle = {{"rbxassetid://616006778", 1}, {"rbxassetid://616006778", 1}},
walk = "rbxassetid://616013216",
run = "rbxassetid://616013216",
jump = "rbxassetid://616008936",
fall = "rbxassetid://616005863",
climb = "rbxassetid://616003713",
},
["Astronaut"] = {
idle = {{"rbxassetid://891621366", 1}, {"rbxassetid://891621366", 1}},
walk = "rbxassetid://891636393",
run = "rbxassetid://891636393",
jump = "rbxassetid://891627522",
fall = "rbxassetid://891617961",
climb = "rbxassetid://891609353",
},
["Pirate"] = {
idle = {{"rbxassetid://750781874", 1}, {"rbxassetid://750781874", 1}},
walk = "rbxassetid://750785693",
run = "rbxassetid://750783738",
jump = "rbxassetid://750782230",
fall = "rbxassetid://750780242",
climb = "rbxassetid://750779899",
},
["Toy"] = {
idle = {{"rbxassetid://782841498", 1}, {"rbxassetid://782841498", 1}},
walk = "rbxassetid://782843345",
run = "rbxassetid://782842708",
jump = "rbxassetid://782847020",
fall = "rbxassetid://782846423",
climb = "rbxassetid://782843869",
},
["Vampire"] = {
idle = {{"rbxassetid://1083445855", 1}, {"rbxassetid://1083445855", 1}},
walk = "rbxassetid://1083473930",
run = "rbxassetid://1083462077",
jump = "rbxassetid://1083455352",
fall = "rbxassetid://1083443587",
climb = "rbxassetid://1083439238",
},
["Werewolf"] = {
idle = {{"rbxassetid://1083195517", 1}, {"rbxassetid://1083195517", 1}},
walk = "rbxassetid://1083178339",
run = "rbxassetid://1083216690",
jump = "rbxassetid://1083218792",
fall = "rbxassetid://1083189019",
climb = "rbxassetid://1083182000",
},
["Rthro"] = {
idle = {{"rbxassetid://2510196951", 1}, {"rbxassetid://2510196951", 1}},
walk = "rbxassetid://2510202577",
run = "rbxassetid://2510198475",
jump = "rbxassetid://2510197830",
fall = "rbxassetid://2510195892",
climb = "rbxassetid://2510192778",
},
["Stylish"] = {
idle = {{"rbxassetid://616136790", 1}, {"rbxassetid://616136790", 1}},
walk = "rbxassetid://616146177",
run = "rbxassetid://616140816",
jump = "rbxassetid://616139451",
fall = "rbxassetid://616134815",
climb = "rbxassetid://616133594",
},
}

local AnimationPackList = {"OFF","Zombie","Ninja","Knight","Elder","Levitate","Astronaut","Pirate","Toy","Vampire","Werewolf","Rthro","Stylish"}
local AnimationPackIndex = 1
local OriginalAnims = {}
local animationPackValueLabel = nil
local refreshAnimationPackRow = nil

_G.AdaptAnimationSystem = _G.AdaptAnimationSystem or {
    conn = nil,
    original = nil,
    activePack = "OFF",
}

function _G.AdaptAnimGetAnimate(char)
    char = char or LP.Character
    return char and char:FindFirstChild("Animate") or nil
end

function _G.AdaptAnimReadOriginal(char)
    if _G.AdaptAnimationSystem.original then return end
    local animate = _G.AdaptAnimGetAnimate(char)
    if not animate then return end

    local function g(obj)
        return obj and obj.AnimationId or nil
    end

    _G.AdaptAnimationSystem.original = {
        idle1 = g(animate.idle and animate.idle:FindFirstChild("Animation1")),
        idle2 = g(animate.idle and animate.idle:FindFirstChild("Animation2")),
        walk = g(animate.walk and animate.walk:FindFirstChild("WalkAnim")),
        run = g(animate.run and animate.run:FindFirstChild("RunAnim")),
        jump = g(animate.jump and animate.jump:FindFirstChild("JumpAnim")),
        fall = g(animate.fall and animate.fall:FindFirstChild("FallAnim")),
        climb = g(animate.climb and animate.climb:FindFirstChild("ClimbAnim")),
        swim = g(animate.swim and animate.swim:FindFirstChild("Swim")),
        swimidle = g(animate.swimidle and animate.swimidle:FindFirstChild("SwimIdle")),
    }
end

function _G.AdaptAnimGetPack(packName)
    return AnimationPacks[packName]
end

function _G.AdaptAnimApplyPack(char, packName)
    local animate = _G.AdaptAnimGetAnimate(char)
    local pack = _G.AdaptAnimGetPack(packName)
    if not animate or not pack then return false end

    local function s(obj, id)
        if obj and id then
            obj.AnimationId = tostring(id)
        end
    end

    s(animate.idle and animate.idle:FindFirstChild("Animation1"), pack.idle and pack.idle[1] and pack.idle[1][1])
    s(animate.idle and animate.idle:FindFirstChild("Animation2"), pack.idle and pack.idle[2] and pack.idle[2][1])
    s(animate.walk and animate.walk:FindFirstChild("WalkAnim"), pack.walk)
    s(animate.run and animate.run:FindFirstChild("RunAnim"), pack.run)
    s(animate.jump and animate.jump:FindFirstChild("JumpAnim"), pack.jump)
    s(animate.fall and animate.fall:FindFirstChild("FallAnim"), pack.fall)
    s(animate.climb and animate.climb:FindFirstChild("ClimbAnim"), pack.climb)
    s(animate.swim and animate.swim:FindFirstChild("Swim"), pack.swim)
    s(animate.swimidle and animate.swimidle:FindFirstChild("SwimIdle"), pack.swimidle)

    return true
end

function _G.AdaptAnimRestore(char)
    local animate = _G.AdaptAnimGetAnimate(char)
    local o = _G.AdaptAnimationSystem.original
    if not animate or not o then return end

    local function s(obj,id)
        if obj and id then obj.AnimationId = id end
    end

    s(animate.idle and animate.idle:FindFirstChild("Animation1"), o.idle1)
    s(animate.idle and animate.idle:FindFirstChild("Animation2"), o.idle2)
    s(animate.walk and animate.walk:FindFirstChild("WalkAnim"), o.walk)
    s(animate.run and animate.run:FindFirstChild("RunAnim"), o.run)
    s(animate.jump and animate.jump:FindFirstChild("JumpAnim"), o.jump)
    s(animate.fall and animate.fall:FindFirstChild("FallAnim"), o.fall)
    s(animate.climb and animate.climb:FindFirstChild("ClimbAnim"), o.climb)
    s(animate.swim and animate.swim:FindFirstChild("Swim"), o.swim)
    s(animate.swimidle and animate.swimidle:FindFirstChild("SwimIdle"), o.swimidle)
end

function _G.AdaptAnimStop()
    if _G.AdaptAnimationSystem.conn then
        pcall(function() _G.AdaptAnimationSystem.conn:Disconnect() end)
        _G.AdaptAnimationSystem.conn = nil
    end

    _G.AdaptAnimRestore(LP.Character)
    _G.AdaptAnimationSystem.activePack = "OFF"
end

function _G.AdaptAnimStart(packName)
    if packName == "OFF" then
        _G.AdaptAnimStop()
        return
    end

    if _G.AdaptAnimationSystem.conn then
        pcall(function() _G.AdaptAnimationSystem.conn:Disconnect() end)
        _G.AdaptAnimationSystem.conn = nil
    end

    local char = LP.Character
    if not char then return end

    local pack = _G.AdaptAnimGetPack(packName)
    if not pack then return end

    _G.AdaptAnimReadOriginal(char)
    _G.AdaptAnimationSystem.activePack = packName

    --Leaked By Xlu0 AndPrime--
    task.spawn(function()
        local list = {}
        for _, v in pairs(pack) do
            if type(v) == "string" then
                table.insert(list, v)
            elseif type(v) == "table" then
                for _, a in ipairs(v) do
                    if type(a) == "table" and a[1] then
                        table.insert(list, tostring(a[1]))
                    end
                end
            end
        end
        pcall(function()
            game:GetService("ContentProvider"):PreloadAsync(list)
        end)
    end)

    _G.AdaptAnimApplyPack(char, packName)

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
            pcall(function() track:Stop(0) end)
        end
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end

    --Leaked By Xlu0 AndPrime--
    _G.AdaptAnimationSystem.conn = RunService.Heartbeat:Connect(function()
        if selectedAnimationPack == "OFF" then return end
        local c = LP.Character
        if c then
            _G.AdaptAnimApplyPack(c, selectedAnimationPack)
        end
    end)
end

function syncAnimationPackIndex()
    local found = 1
    for i, name in ipairs(AnimationPackList) do
        if name == selectedAnimationPack then
            found = i
            break
        end
    end
    AnimationPackIndex = found
end

function applyAnimationPack(packName)
    selectedAnimationPack = packName or "OFF"
    syncAnimationPackIndex()

    if selectedAnimationPack == "OFF" then
        _G.AdaptAnimStop()
    else
        _G.AdaptAnimStart(selectedAnimationPack)
    end

    if refreshAnimationPackRow then
        pcall(refreshAnimationPackRow)
    end
end

--Leaked By Xlu0 AndPrime--
enableUnwalk = function()
    selectedAnimationPack = "OFF"
    _G.AdaptAnimStop()
end

disableUnwalk = function()
end

enableHitHarderAnim = function()
    applyAnimationPack("Zombie")
end

disableHitHarderAnim = function()
    applyAnimationPack("OFF")
end

resetAnimations = function()
    applyAnimationPack("OFF")
end

stopCurrentAnimations = function(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
        pcall(function() track:Stop(0) end)
    end
end

getAnimate = function(char)
    return _G.AdaptAnimGetAnimate(char)
end

setAnimId = function(obj,id)
    if obj and id then obj.AnimationId = tostring(id) end
end

reloadAnimate = function(animate)
    if not animate then return end
    pcall(function()
        animate.Disabled = true
        task.wait()
        animate.Disabled = false
    end)
end

backupAnimations = function(char)
    _G.AdaptAnimReadOriginal(char)
end

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    _G.AdaptAnimationSystem.original = nil
    if selectedAnimationPack and selectedAnimationPack ~= "OFF" then
        _G.AdaptAnimStart(selectedAnimationPack)
    end
end)

--Leaked By Xlu0 AndPrime--
local antiRagdollResetCooldown = 0

local function forceAntiRagdollReset()
    local char = LP.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end

    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then obj.Enabled = true end
            if obj:IsA("Constraint") then obj.Enabled = true end
        end

        if workspace.CurrentCamera then
            workspace.CurrentCamera.CameraSubject = hum
        end

        local playerScripts = LP:FindFirstChild("PlayerScripts")
        local playerModule = playerScripts and playerScripts:FindFirstChild("PlayerModule")
        if playerModule then
            local controlModuleObj = playerModule:FindFirstChild("ControlModule")
            if controlModuleObj then
                local ok, controls = pcall(require, controlModuleObj)
                if ok and controls and controls.Enable then
                    pcall(function() controls:Enable() end)
                end
            end
        end

        hum.AutoRotate = true
        hum.PlatformStand = false
        hum.Sit = false
    end)
end

local function startAntiRagdoll()
    if antiRagdollConn then return end
    antiRagdollEnabled = true
    antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health <= 0 then return end
        local state = hum:GetState()
        local ragdolled = (state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown)
        if not root then return end
        --Leaked By Xlu0 AndPrime--
        local endTime = LP:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then
            ragdolled = true
        end
        if ragdolled then
            local now = tick()
            if now - (antiRagdollResetCooldown or 0) > 0.15 then
                antiRagdollResetCooldown = now
                --Leaked By Xlu0 AndPrime--
                pcall(function()
                    LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
                end)
                --Leaked By Xlu0 AndPrime--
                for _, d in ipairs(char:GetDescendants()) do
                    if d:IsA("BallSocketConstraint") or
                       (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then
                        d:Destroy()
                    end
                end
                --Leaked By Xlu0 AndPrime--
                for _, obj in ipairs(char:GetDescendants()) do
                    if obj:IsA("Motor6D") and not obj.Enabled then
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
        end
    end)
end

local function stopAntiRagdoll()
    antiRagdollEnabled = false
    if antiRagdollConn then
        antiRagdollConn:Disconnect()
        antiRagdollConn = nil
    end
end

local function setAntiRagdoll(on)
    if on then
        startAntiRagdoll()
    else
        stopAntiRagdoll()
    end
end

_G.AdaptInfJumpMode = (_G.AdaptInfJumpMode == "Hold") and "Hold" or "Tap"

--Leaked By Xlu0 AndPrime--
local _xIJBoosting   = false
local _xIJLastBoost  = 0
local _xIJForce      = 25
local _xIJFrames     = 2
local _xIJCooldown   = 0.12
local _xJumpHeld     = false
local _xHoldIJConn   = nil

local function _xApplyInfJumpBoost(root)
    if not root or _xIJBoosting then return end
    local now = tick()
    if now - _xIJLastBoost < _xIJCooldown then return end
    _xIJLastBoost  = now
    _xIJBoosting   = true
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(0, math.huge, 0)
    bv.P        = 1250
    local cur   = root.AssemblyLinearVelocity
    bv.Velocity = Vector3.new(cur.X, _xIJForce, cur.Z)
    bv.Parent   = root
    local frames = 0
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if frames < _xIJFrames then
            frames = frames + 1
            if bv and bv.Parent then
                bv.Velocity = bv.Velocity + Vector3.new(0, 0.01, 0)
            end
        else
            if bv then pcall(function() bv:Destroy() end) end
            if conn then conn:Disconnect() end
            _xIJBoosting = false
        end
    end)
end

--Leaked By Xlu0 AndPrime--
task.spawn(function()
    local pg = LP:WaitForChild("PlayerGui", 10)
    if not pg then return end
    local function hookBtn(btn)
        if btn:IsA("GuiButton") and btn.Name == "JumpButton" and not btn:GetAttribute("XluIJHooked") then
            btn:SetAttribute("XluIJHooked", true)
            btn.MouseButton1Down:Connect(function() if infJumpEnabled then _xJumpHeld = true end end)
            btn.MouseButton1Up:Connect(function()  _xJumpHeld = false end)
            btn.MouseLeave:Connect(function()      _xJumpHeld = false end)
        end
    end
    for _, d in ipairs(pg:GetDescendants()) do hookBtn(d) end
    pg.DescendantAdded:Connect(hookBtn)
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and _G.AdaptInfJumpMode == "Tap" then
        _xJumpHeld = true
        task.delay(0.08, function() _xJumpHeld = false end)
    end
end)

UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if infJumpEnabled and inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == Enum.KeyCode.Space then
        _xJumpHeld = true
    end
end)

UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == Enum.KeyCode.Space then
        _xJumpHeld = false
    end
end)

--Leaked By Xlu0 AndPrime--
RunService.Heartbeat:Connect(function()
    if not infJumpEnabled or _G.AdaptInfJumpMode ~= "Tap" then return end
    if not _xJumpHeld then return end
    local char = LP.Character
    if not char then return end
    local hum  = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end
    _xApplyInfJumpBoost(root)
end)

--Leaked By Xlu0 AndPrime--
local function _xStartHoldIJ()
    if _xHoldIJConn then _xHoldIJConn:Disconnect() end
    _xHoldIJConn = RunService.Heartbeat:Connect(function()
        if not infJumpEnabled or _G.AdaptInfJumpMode ~= "Hold" then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum  = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local held = UserInputService:IsKeyDown(Enum.KeyCode.Space) or _xJumpHeld
        local vel  = root.AssemblyLinearVelocity
        if held and vel.Y < 35 then
            root.AssemblyLinearVelocity = Vector3.new(vel.X, 55, vel.Z)
        end
        vel = root.AssemblyLinearVelocity
        if vel.Y < -120 then
            root.AssemblyLinearVelocity = Vector3.new(vel.X, -120, vel.Z)
        end
    end)
end
_xStartHoldIJ()

setInfJumpInternal = function(on)
    infJumpEnabled = on and true or false
    if not infJumpEnabled then
        _xJumpHeld   = false
        _xIJBoosting = false
    end
end

_G.AdaptAntiResetEnabled = _G.AdaptAntiResetEnabled == true

function _G.AdaptApplyAntiReset()
    pcall(function()
        StarterGui:SetCore("ResetButtonCallback", false)
    end)
end

function _G.AdaptRestoreReset()
    pcall(function()
        StarterGui:SetCore("ResetButtonCallback", true)
    end)
end

function _G.AdaptSetAntiReset(on)
    _G.AdaptAntiResetEnabled = on == true

    if _G.AdaptAntiResetEnabled then
        --Leaked By Xlu0 AndPrime--
        task.spawn(function()
            for _ = 1, 12 do
                if not _G.AdaptAntiResetEnabled then return end
                _G.AdaptApplyAntiReset()
                task.wait(0.25)
            end
        end)
    else
        _G.AdaptRestoreReset()
    end
end


--Leaked By Xlu0 AndPrime--
_G.AdaptAntiDieHealthConn = _G.AdaptAntiDieHealthConn or nil
_G.AdaptAntiDieCharConn = _G.AdaptAntiDieCharConn or nil

function _G.AdaptHookAntiDieCharacter(char)
    if _G.AdaptAntiDieHealthConn then
        pcall(function() _G.AdaptAntiDieHealthConn:Disconnect() end)
        _G.AdaptAntiDieHealthConn = nil
    end

    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    _G.AdaptAntiDieHealthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not _G.AdaptAntiResetEnabled then return end
        if hum.Health <= 0 then
            pcall(function()
                hum.Health = 1
                hum.PlatformStand = false
                hum.Sit = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end)
        end
    end)
end

if _G.AdaptAntiDieCharConn then
    pcall(function() _G.AdaptAntiDieCharConn:Disconnect() end)
end
_G.AdaptAntiDieCharConn = LP.CharacterAdded:Connect(function(char)
    task.wait(0.2)
    _G.AdaptHookAntiDieCharacter(char)

    if _G.AdaptRestoreAntiDieAfterReset then
        _G.AdaptRestoreAntiDieAfterReset = false
        task.wait(0.35)
        _G.AdaptSetAntiReset(true)
        if _G.AdaptAntiResetVisual then
            pcall(function() _G.AdaptAntiResetVisual(true) end)
        end
        do end
    end
end)

if LP.Character then
    task.defer(function()
        _G.AdaptHookAntiDieCharacter(LP.Character)
    end)
end


_G.AdaptHeadlessEnabled = _G.AdaptHeadlessEnabled == true
_G.AdaptKorbloxEnabled = _G.AdaptKorbloxEnabled == true
_G.AdaptHeadlessMeshId = "rbxassetid://1095708"
_G.AdaptKorbloxMeshId = "rbxassetid://101851696"
_G.AdaptKorbloxTextureId = "rbxassetid://101851254"

function _G.AdaptApplyHeadless(char, enabled)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    if enabled then
        head.Transparency = 1
        head.CanCollide = false
        local face = head:FindFirstChild("face")
        if face then face:Destroy() end

        local old = head:FindFirstChild("AdaptHeadlessMesh")
        if old then old:Destroy() end

        local mesh = Instance.new("SpecialMesh")
        mesh.Name = "AdaptHeadlessMesh"
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = _G.AdaptHeadlessMeshId
        mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
        mesh.Parent = head
    else
        head.Transparency = 0
        head.CanCollide = true
        local old = head:FindFirstChild("AdaptHeadlessMesh")
        if old then old:Destroy() end
    end
end

function _G.AdaptApplyKorblox(char, enabled)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if hum.RigType == Enum.HumanoidRigType.R6 then
        local leg = char:FindFirstChild("Right Leg")
        if not leg then return end

        local old = leg:FindFirstChild("AdaptKorbloxMesh")
        if old then old:Destroy() end

        if enabled then
            leg.Color = Color3.fromRGB(64,64,64)
            local mesh = Instance.new("SpecialMesh")
            mesh.Name = "AdaptKorbloxMesh"
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = _G.AdaptKorbloxMeshId
            mesh.TextureId = _G.AdaptKorbloxTextureId
            mesh.Scale = Vector3.new(1,1,1)
            mesh.Parent = leg
        else
            leg.Color = Color3.fromRGB(255,255,255)
        end
    else
        local upper = char:FindFirstChild("RightUpperLeg")
        local lower = char:FindFirstChild("RightLowerLeg")
        local foot = char:FindFirstChild("RightFoot")
        if not upper then return end

        local oldLeg = char:FindFirstChild("AdaptKorbloxLeg")
        if oldLeg then oldLeg:Destroy() end

        if enabled then
            upper.Transparency = 1
            if lower then lower.Transparency = 1 end
            if foot then foot.Transparency = 1 end

            local kleg = Instance.new("Part")
            kleg.Name = "AdaptKorbloxLeg"
            kleg.Size = Vector3.new(1,2,1)
            kleg.Anchored = false
            kleg.CanCollide = false
            kleg.Massless = true
            kleg.Color = Color3.fromRGB(64,64,64)
            kleg.Parent = char

            local mesh = Instance.new("SpecialMesh")
            mesh.Name = "AdaptKorbloxMesh"
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = _G.AdaptKorbloxMeshId
            mesh.TextureId = _G.AdaptKorbloxTextureId
            mesh.Scale = Vector3.new(1,1,1)
            mesh.Parent = kleg

            local weld = Instance.new("Weld")
            weld.Name = "AdaptKorbloxWeld"
            weld.Part0 = upper
            weld.Part1 = kleg
            weld.C0 = CFrame.new(0,-0.8,0)
            weld.Parent = kleg
        else
            upper.Transparency = 0
            if lower then lower.Transparency = 0 end
            if foot then foot.Transparency = 0 end
        end
    end
end

function _G.AdaptApplyCharacterVisuals(char)
    char = char or LP.Character
    if not char then return end
    pcall(function() _G.AdaptApplyHeadless(char, _G.AdaptHeadlessEnabled) end)
    pcall(function() _G.AdaptApplyKorblox(char, _G.AdaptKorbloxEnabled) end)
end




_G.AdaptBodyLockEnabled = _G.AdaptBodyLockEnabled == true
_G.AdaptBodyLockRadius = tonumber(_G.AdaptBodyLockRadius) or 60
_G.AdaptBodyLockConn = _G.AdaptBodyLockConn or nil

function _G.AdaptGetNearestBodyLockTarget()
local character = LP.Character
local root = character and character:FindFirstChild("HumanoidRootPart")
if not root then return nil end

local nearest = nil
local shortest = math.huge

for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
local tr = plr.Character:FindFirstChild("HumanoidRootPart")
local hum = plr.Character:FindFirstChildOfClass("Humanoid")
if tr and hum and hum.Health > 0 then
local d = (tr.Position - root.Position).Magnitude
if d <= (_G.AdaptBodyLockRadius or 60) and d < shortest then
shortest = d
nearest = plr
end
end
end
end

return nearest
end

function _G.AdaptStartBodyLock()
if _G.AdaptBodyLockConn then return end
_G.AdaptBodyLockEnabled = true

_G.AdaptBodyLockConn = RunService.Heartbeat:Connect(function()
if not _G.AdaptBodyLockEnabled then return end

local character = LP.Character
local myRoot = character and character:FindFirstChild("HumanoidRootPart")
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if not myRoot or not humanoid or humanoid.Health <= 0 then return end

local target = _G.AdaptGetNearestBodyLockTarget()
if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
local targetPos = target.Character.HumanoidRootPart.Position
local myPos = myRoot.Position
local offset = Vector3.new(targetPos.X, myPos.Y, targetPos.Z) - myPos

if offset.Magnitude > 0.1 then
humanoid.AutoRotate = false
local lookDir = offset.Unit
local currentDir = myRoot.CFrame.LookVector
local cross = currentDir:Cross(lookDir)
local currentVel = myRoot.AssemblyAngularVelocity
myRoot.AssemblyAngularVelocity = Vector3.new(currentVel.X, cross.Y * 40, currentVel.Z)
end
else
humanoid.AutoRotate = true
end
end)
end

function _G.AdaptStopBodyLock()
_G.AdaptBodyLockEnabled = false

if _G.AdaptBodyLockConn then
pcall(function() _G.AdaptBodyLockConn:Disconnect() end)
_G.AdaptBodyLockConn = nil
end

local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
if hum then
hum.AutoRotate = true
end
end

function _G.AdaptSetBodyLock(on)
_G.AdaptBodyLockEnabled = on == true
if _G.AdaptBodyLockEnabled then
_G.AdaptStartBodyLock()
else
_G.AdaptStopBodyLock()
end

if _G.AdaptBodyLockVisual then
pcall(function() _G.AdaptBodyLockVisual(_G.AdaptBodyLockEnabled) end)
end
end

LP.CharacterAdded:Connect(function()
if _G.AdaptBodyLockEnabled then
task.wait(0.3)
_G.AdaptStopBodyLock()
_G.AdaptStartBodyLock()
end
end)

local currentBackground = 0
local aceGuiScaleValue = AdaptAutoMobile and 0.67 or 1.00
local aceProgressBarScaleValue = AdaptAutoMobile and 0.83 or 1.00
CONFIG_FILE = "AdaptDuels_MainGUI_Config_DefaultsV2.json"
KEYBINDS_CONFIG_FILE = "AdaptDuels_Keybinds_DefaultsV2.json"
_ace_isfile = isfile or (syn and syn.isfile) or function(path)
local ok, result = pcall(function() return readfile(path) end)
return ok and result ~= nil
end
_ace_readfile = readfile or (syn and syn.readfile)
_ace_writefile = writefile or (syn and syn.writefile)
canSaveConfig = (type(_ace_readfile) == "function" and type(_ace_writefile) == "function")

selectedIntroMusic = selectedIntroMusic or 1
_introEnabled = (_introEnabled ~= false)
setIntroVisual = nil
setIntroSongVisual = nil
INTRO_MUSIC_OPTIONS = INTRO_MUSIC_OPTIONS or {
{name="Song 1", url="https://files.catbox.moe/mzvrir.mp3", file="AdaptDuelsIntroSong_1.mp3"},
{name="Song 2", url="https://files.catbox.moe/2a7jyx.mp3", file="AdaptDuelsIntroSong_2.mp3"},
{name="Song 3", url="https://files.catbox.moe/rcgr9f.mp3", file="AdaptDuelsIntroSong_3.mp3"},
{name="Song 4", url="https://files.catbox.moe/iknfuh.mp3", file="AdaptDuelsIntroSong_4.mp3"},
{name="Song 5", url="https://files.catbox.moe/6eigoh.mp3", file="AdaptDuelsIntroSong_5.mp3"},
{name="Song 6", url="https://files.catbox.moe/dvjtjk.mp3", file="AdaptDuelsIntroSong_6.mp3"},
{name="Song 7", url="https://files.catbox.moe/iyw1cb.mp3", file="AdaptDuelsIntroSong_7.mp3"},
}
function getIntroSongName()
local opt = INTRO_MUSIC_OPTIONS[selectedIntroMusic]
return opt and opt.name or "No Songs Added"
end
introPreviewSound = nil
introPlaybackSound = nil
introPreviewToken = 0
introPlaybackToken = 0
introSongCache = introSongCache or {}
introSongDownloading = introSongDownloading or {}
function stopIntroPreview()
introPreviewToken = introPreviewToken + 1
if introPreviewSound then
pcall(function() introPreviewSound:Stop() end)
pcall(function() introPreviewSound:Destroy() end)
introPreviewSound = nil
end
end
function stopIntroPlayback()
introPlaybackToken = introPlaybackToken + 1
if introPlaybackSound then
pcall(function() introPlaybackSound:Stop() end)
pcall(function() introPlaybackSound:Destroy() end)
introPlaybackSound = nil
end
end
function _safeNotify(msg)
if showActionNotification then pcall(function() showActionNotification(msg) end) end
end
function cacheIntroSong(option, allowDownload)
if not option or not option.url or option.url == "" then return nil end
if not (writefile and getcustomasset) then return nil end
local fileName = option.file or ("AdaptDuelsIntroSong_" .. tostring(option.name or "song") .. ".mp3")
local function loadExisting()
if introSongCache[fileName] then return introSongCache[fileName] end
local hasFile = false
pcall(function() hasFile = isfile and isfile(fileName) end)
if hasFile then
local ok = pcall(function() introSongCache[fileName] = getcustomasset(fileName) end)
if ok and introSongCache[fileName] then return introSongCache[fileName] end
end
return nil
end
local cached = loadExisting()
if cached then return cached end
if allowDownload == false then return nil end
if introSongDownloading[fileName] then
local waitStart = tick()
while introSongDownloading[fileName] and tick() - waitStart < 12 do task.wait(0.05) end
cached = loadExisting()
if cached then return cached end
end
introSongDownloading[fileName] = true
local ok = pcall(function()
local data = game:HttpGet(option.url)
if data and #data > 0 then
writefile(fileName, data)
introSongCache[fileName] = getcustomasset(fileName)
end
end)
introSongDownloading[fileName] = nil
if ok and introSongCache[fileName] then return introSongCache[fileName] end
return loadExisting()
end
function preloadIntroSongs()

--Leaked By Xlu0 AndPrime--
--Leaked By Xlu0 AndPrime--
ADAPT_INTRO_MUSIC_OPTIONS = {
    {name="Song 1", file="AdaptIntroMusic_gm9wuu.mp3"},
    {name="Song 2", file="AdaptIntroMusic_s2epvz.mp3"},
    {name="Song 3", file="AdaptIntroMusic_w8vxqg.mp3"},
    {name="Song 4", file="AdaptIntroMusic_y02ovb.mp3"},
    {name="Harun be ging", file="Harun_be_ging.mp3"},
}

if not ADAPT_INTRO_MUSIC_OPTIONS[selectedIntroMusic] then
    selectedIntroMusic = 1
end

local function getAdaptIntroAssetLoader()
    if type(getcustomasset) == "function" then return getcustomasset end
    if type(getexecutorasset) == "function" then return getexecutorasset end
    if type(getsynasset) == "function" then return getsynasset end
    if syn and type(syn.getcustomasset) == "function" then return syn.getcustomasset end
    if syn and type(syn.getsynasset) == "function" then return syn.getsynasset end
    return nil
end

local function resolveAdaptIntroSong(index)
    local option = ADAPT_INTRO_MUSIC_OPTIONS[index]
    if not option then return nil end

    local loader = getAdaptIntroAssetLoader()
    if not loader then return nil end

    if type(isfile) == "function" then
        local okExists, exists = pcall(isfile, option.file)
        if okExists and not exists then return nil end
    end

    local ok, asset = pcall(loader, option.file)
    if ok and asset and tostring(asset) ~= "" then
        return asset
    end
    return nil
end

function getIntroSongName()
    local opt = ADAPT_INTRO_MUSIC_OPTIONS[selectedIntroMusic]
    return opt and opt.name or "Song 1"
end

--Leaked By Xlu0 AndPrime--
function stopIntroPreview()
    introPreviewToken = (introPreviewToken or 0) + 1
    if introPreviewSound then
        pcall(function() introPreviewSound:Stop() end)
        pcall(function() introPreviewSound:Destroy() end)
        introPreviewSound = nil
    end
end

function stopIntroPlayback()
    introPlaybackToken = (introPlaybackToken or 0) + 1
    if introPlaybackSound then
        pcall(function() introPlaybackSound:Stop() end)
        pcall(function() introPlaybackSound:Destroy() end)
        introPlaybackSound = nil
    end
end

function previewIntroMusic(index)
    stopIntroPreview()
    stopIntroPlayback()

    index = tonumber(index) or selectedIntroMusic or 1
    if not ADAPT_INTRO_MUSIC_OPTIONS[index] then index = 1 end

    local token = introPreviewToken
    task.spawn(function()
        local soundId = resolveAdaptIntroSong(index)
        if token ~= introPreviewToken then return end

        if not soundId then
            if showActionNotification then
                pcall(function() showActionNotification("INTRO MUSIC FILE NOT FOUND") end)
            end
            return
        end

        local sound = Instance.new("Sound")
        sound.Name = "AdaptIntroPreview_" .. tostring(index)
        sound.SoundId = soundId
        sound.Volume = 0.65
        sound.Looped = false
        sound.Parent = SoundService
        introPreviewSound = sound

        sound.TimePosition = 0
        pcall(function() sound:Play() end)

        task.delay(10, function()
            if token == introPreviewToken then
                stopIntroPreview()
            end
        end)
    end)
end

function playIntroMusic()
    stopIntroPreview()
    stopIntroPlayback()
    if not _introEnabled then return end

    local index = tonumber(selectedIntroMusic) or 1
    if not ADAPT_INTRO_MUSIC_OPTIONS[index] then index = 1 end

    local token = introPlaybackToken
    task.spawn(function()
        local soundId = resolveAdaptIntroSong(index)
        if token ~= introPlaybackToken or not _introEnabled then return end

        if not soundId then
            if showActionNotification then
                pcall(function() showActionNotification("INTRO MUSIC FILE NOT FOUND") end)
            end
            return
        end

        local sound = Instance.new("Sound")
        sound.Name = "AdaptIntroMusic_" .. tostring(index)
        sound.SoundId = soundId
        sound.Volume = 0.65
        sound.Looped = false
        sound.Parent = SoundService
        introPlaybackSound = sound

        sound.TimePosition = 0
        pcall(function() sound:Play() end)
    end)
end

task.spawn(function()
cacheIntroSong(INTRO_MUSIC_OPTIONS[selectedIntroMusic], true)
for _, option in ipairs(INTRO_MUSIC_OPTIONS) do
if option ~= INTRO_MUSIC_OPTIONS[selectedIntroMusic] then
cacheIntroSong(option, true)
task.wait(0.05)
end
end
end)
end
function makeIntroSoundFromId(soundId, name, parent)
if not soundId then return nil end
local sound = Instance.new("Sound")
sound.Name = name or "AdaptDuelsIntroMusic"
sound.Volume = 0.65
sound.Looped = false
sound.SoundId = soundId
sound.Parent = parent or SoundService
return sound
end
function createIntroSound(option, fileName, parent, allowDownload)
if not option then return nil end
local soundId = cacheIntroSong(option, allowDownload)
if not soundId then return nil end
return makeIntroSoundFromId(soundId, fileName, parent)
end
function previewIntroMusic(index)
stopIntroPreview()
stopIntroPlayback()
if not INTRO_MUSIC_OPTIONS[index] then _safeNotify("ADD SONG LINKS"); return end
local token = introPreviewToken
task.spawn(function()
local option = INTRO_MUSIC_OPTIONS[index]
local sound = createIntroSound(option, "AdaptDuelsIntroPreview_" .. tostring(token), SoundService, true)
if token ~= introPreviewToken then if sound then sound:Destroy() end; return end
introPreviewSound = sound
if not sound then _safeNotify("SONG LOADING..."); return end
sound.TimePosition = 0
pcall(function() sound:Play() end)
task.delay(15, function() if token == introPreviewToken then stopIntroPreview() end end)
end)
end
function playIntroMusic()
stopIntroPreview()
stopIntroPlayback()
if not _introEnabled then return end
local option = INTRO_MUSIC_OPTIONS[selectedIntroMusic]
if not option then return end
local token = introPlaybackToken
task.spawn(function()
local sound = createIntroSound(option, "AdaptDuelsIntroMusic_" .. tostring(token), SoundService, true)
if token ~= introPlaybackToken or not _introEnabled then if sound then pcall(function() sound:Destroy() end) end; return end
introPlaybackSound = sound
if not sound then _safeNotify("SONG FAILED"); return end
sound.TimePosition = 0
local loadStart = tick()
while sound and not sound.IsLoaded and tick() - loadStart < 10 do task.wait(0.05) end
pcall(function() sound:Play() end)
task.delay(15, function() if token == introPlaybackToken then stopIntroPlayback() end end)
end)
end
preloadIntroSongs()

savedConfig = {}
_G.AdaptGuiLocked = _G.AdaptGuiLocked == true
if _G.AdaptHideMobileButtons == nil then
_G.AdaptHideMobileButtons = not AdaptAutoMobile
else
_G.AdaptHideMobileButtons = _G.AdaptHideMobileButtons == true
_G.AdaptMobileButtonScale = tonumber(_G.AdaptMobileButtonScale) or 0.75
end
_G.AdaptMobileButtonScale = tonumber(_G.AdaptMobileButtonScale) or (AdaptAutoMobile and 0.90 or 1.00)
_G.AdaptMobileButtonPositions = _G.AdaptMobileButtonPositions or {}
_G.AdaptMobileButtonImage = _G.AdaptMobileButtonImage or ""
_G.AdaptMobileButtonShape = _G.AdaptMobileButtonShape or "ROUNDED"
_G.AdaptStealUIImage = _G.AdaptStealUIImage or ""
savedMainPositionTable = nil
savedMiniPositionTable = nil
function udim2ToTable(u)
return {xs = u.X.Scale, xo = u.X.Offset, ys = u.Y.Scale, yo = u.Y.Offset}
end
function tableToUDim2(t, fallback)
if type(t) == "table" then
return UDim2.new(tonumber(t.xs) or 0, tonumber(t.xo) or 0, tonumber(t.ys) or 0, tonumber(t.yo) or 0)
end
return fallback
end
function collectAdaptMobileButtonPositions()
local out = {}
for key, entry in pairs(_G.AdaptMobileButtonRefs or {}) do
local holder = entry and entry.holder
if holder then out[key] = udim2ToTable(holder.Position) end
end
if next(out) == nil and type(_G.AdaptMobileButtonPositions) == "table" then
return _G.AdaptMobileButtonPositions
end
_G.AdaptMobileButtonPositions = out
return out
end
function keyToString(key)
if not key then return "None" end
return tostring(key):gsub("Enum.KeyCode.", "")
end
function stringToKeyCode(value)
if type(value) ~= "string" or value == "" or value == "None" then return nil end
return Enum.KeyCode[value]
end
function keybindsToTable()
local out = {}
for keyId in pairs(DEFAULT_SPEED_KEYBINDS) do
out[keyId] = keyToString(speedKeybinds[keyId])
end
for keyId, key in pairs(speedKeybinds) do
out[keyId] = keyToString(key)
end
return out
end
function collectAdaptKeybindConfig()
return {
keybinds = keybindsToTable(),
tpDownKeybind = keyToString(tpDownKeybind),
}
end
function applySavedKeybinds(t)
if type(t) ~= "table" then return end
for keyId in pairs(speedKeybinds) do
if t[keyId] ~= nil then
speedKeybinds[keyId] = stringToKeyCode(t[keyId])
end
end
end
function applyDefaultAdaptKeybinds()
for keyId, key in pairs(DEFAULT_SPEED_KEYBINDS) do
speedKeybinds[keyId] = key
end
tpDownKeybind = DEFAULT_TP_DOWN_KEYBIND
end
function collectAdaptConfig()
return {
mainPosition = savedMainPositionTable,
keybinds = keybindsToTable(),
tpDownKeybind = keyToString(tpDownKeybind),
NS = NS,
CS = CS,
LAGGER_SPEED = LAGGER_SPEED,
LAGGER_CARRY_SPEED = LAGGER_CARRY_SPEED,
currentSpeedMode = currentSpeedMode,
dropMode = _G.AdaptDropMode,
autoCarrySpeedEnabled = autoCarrySpeedEnabled == true,
autoTPEnabled = autoTPEnabled,
autoTPHeight = autoTPHeight,
infJumpEnabled = infJumpEnabled,
infJumpMode = _G.AdaptInfJumpMode,
antiRagdollEnabled = antiRagdollEnabled,
antiRagdollMode = _G.AdaptAntiRagdollMode,
antiVoidEnabled = _G.AdaptAntiVoidEnabled == true,
antiResetEnabled = _G.AdaptAntiResetEnabled == true,
selectedAnimationPack = selectedAnimationPack,
selectedMoreAnimationBundle = _G.AdaptSelectedMoreAnimationBundle,
selectedStealMode = selectedStealMode,
autoStealEnabled = autoStealEnabled,
autoStealRadius = autoStealRadius,
aceStealRadii = _G.AdaptStealRadii,
selectedAimbotMode = selectedAimbotMode,
AIMBOT_SPEED = AIMBOT_SPEED,
LAGGER_AIMBOT_SPEED = LAGGER_AIMBOT_SPEED,
ANTI_BYPASS_AIMBOT_SPEED = _G.AdaptAntiBypassAimbotSpeed,
ANTI_BYPASS_LAGGER_AIMBOT_SPEED = _G.AdaptAntiBypassLaggerAimbotSpeed,
ANTI_DESYNC_AIMBOT_SPEED = ANTI_DESYNC_AIMBOT_SPEED,
autoSwingEnabled = autoSwingEnabled,
mirrorTPDownEnabled = mirrorTPDownEnabled,
normalAimbotEnabled = _G.AdaptNormalAimbotOn == true,
antiBypassAimbotEnabled = _G.AdaptAntiBypassAimbotOn == true,
antiDesyncAutoSwingEnabled = antiDesyncAutoSwingEnabled,
antiDesyncAimbotEnabled = _G.AdaptAntiDesyncAimbotOn == true,
batCounterEnabled = batCounterEnabled,
medCounterEnabled = medCounterEnabled,
safeMode = antiKickEnabled == true,
autoResetOnMedEnabled = autoResetOnMedEnabled,
espEnabled = espEnabled,
showTracerEnabled = showTracerEnabled,
ragdollCountdownEnabled = ragdollCountdownEnabled,
fpsBoostEnabled = fpsBoostEnabled,
antiLagVisualEnabled = antiLagVisualEnabled,
nukeOptimiserEnabled = nukeOptimiserEnabled,
fovEnabled = fovEnabled,
fovValue = fovValue,
noCamCollisionEnabled = noCamCollisionEnabled,
noPlayerCollisionEnabled = _G.AdaptNoPlayerCollisionEnabled,
customFontVisualEnabled = (_G.AdaptCustomFontSelected or "None") ~= "None",
customFontSelected = _G.AdaptCustomFontSelected or "None",
skyTheme = skyTheme,
autoLeftEnabled = autoLeftEnabled,
autoRightEnabled = autoRightEnabled,
currentBackground = currentBackground,
bodyLockEnabled = _G.AdaptBodyLockEnabled == true,
bodyLockRadius = tonumber(_G.AdaptBodyLockRadius) or 60,
mobileButtonScale = tonumber(_G.AdaptMobileButtonScale) or 0.75,
guiScaleValue = tonumber(_G.AdaptGuiScaleValue) or tonumber(adaptGuiScaleValue) or tonumber(aceGuiScaleValue) or 0.52,
stealUiScaleValue = tonumber(_G.AdaptProgressBarScaleValue) or tonumber(adaptProgressBarScaleValue) or tonumber(aceProgressBarScaleValue) or 0.83,
headlessEnabled = _G.AdaptHeadlessEnabled == true,
korbloxEnabled = _G.AdaptKorbloxEnabled == true,
currentThemeName = _G.AdaptThemeName,
aceGuiScaleValue = aceGuiScaleValue,
aceProgressBarScaleValue = aceProgressBarScaleValue,
introEnabled = _introEnabled == true,
selectedIntroMusic = selectedIntroMusic,
guiLocked = _G.AdaptGuiLocked == true,
hideMobileButtons = _G.AdaptHideMobileButtons == true,
aceMobileButtonScale = _G.AdaptMobileButtonScale,
mobileButtonPositions = collectAdaptMobileButtonPositions(),
mobileButtonImage = _G.AdaptMobileButtonImage or "",
mobileButtonShape = _G.AdaptMobileButtonShape or "ROUNDED",
stealUIImage = _G.AdaptStealUIImage or "",
autoStealV3Radius = tonumber((_G.AdaptStealRadii and _G.AdaptStealRadii["Auto Steal V3"]) or autoStealRadius) or 63,
aceStealRadii = {
    ["Auto Steal V3"] = tonumber((_G.AdaptStealRadii and _G.AdaptStealRadii["Auto Steal V3"]) or autoStealRadius) or 63,
    Semi = tonumber((_G.AdaptStealRadii and _G.AdaptStealRadii.Semi) or 9) or 9,
},
duelMode = _G.AdaptDuelMode or "half",
autoMoveSpeed = tonumber(_G.AdaptAutoMoveSpeed) or 60,
autoMoveCarrySpeed = tonumber(_G.AdaptAutoMoveCarrySpeed) or 30,
stretchValue = tonumber(_G.AdaptStretchValue) or 0.7,
stretchPreset = _G.AdaptStretchPreset or "Medium",
avatarChangerUserId = (_G.AdaptAvatarChangerCleared and 0) or ((_G.AdaptAvatarChangerState and _G.AdaptAvatarChangerState.lastUserId) or 0),
avatarChangerUsername = (_G.AdaptAvatarChangerCleared and "") or ((_G.AdaptAvatarChangerState and _G.AdaptAvatarChangerState.lastUsername) or ""),
}
end
function saveAdaptConfig()
if not canSaveConfig then return end
pcall(function()
_ace_writefile(CONFIG_FILE, HttpService:JSONEncode(collectAdaptConfig()))
_ace_writefile(KEYBINDS_CONFIG_FILE, HttpService:JSONEncode(collectAdaptKeybindConfig()))
end)
end
function loadAdaptConfig()
_G.AdaptManualSaveConfig = saveAdaptConfig
if _G.AdaptGuiScaleValue then
pcall(function()
if adaptGuiScaleValue ~= nil then adaptGuiScaleValue = tonumber(_G.AdaptGuiScaleValue) or adaptGuiScaleValue end
if aceGuiScaleValue ~= nil then aceGuiScaleValue = tonumber(_G.AdaptGuiScaleValue) or aceGuiScaleValue end
end)
end
if _G.AdaptProgressBarScaleValue then
pcall(function()
if adaptProgressBarScaleValue ~= nil then adaptProgressBarScaleValue = tonumber(_G.AdaptProgressBarScaleValue) or adaptProgressBarScaleValue end
if aceProgressBarScaleValue ~= nil then aceProgressBarScaleValue = tonumber(_G.AdaptProgressBarScaleValue) or aceProgressBarScaleValue end
end)
end
if not canSaveConfig or not _ace_isfile(CONFIG_FILE) then return end
local ok, data = pcall(function()
return HttpService:JSONDecode(_ace_readfile(CONFIG_FILE))
end)
if not ok or type(data) ~= "table" then return end
savedConfig = data
local keybindData = data
pcall(function()
if _ace_isfile(KEYBINDS_CONFIG_FILE) then
local kb = HttpService:JSONDecode(_ace_readfile(KEYBINDS_CONFIG_FILE))
if type(kb) == "table" then keybindData = kb end
end
end)
savedMainPositionTable = data.mainPosition
savedMiniPositionTable = nil
_G.AdaptGuiLocked = data.guiLocked == true
if data.hideMobileButtons ~= nil then
_G.AdaptHideMobileButtons = data.hideMobileButtons == true
elseif _G.AdaptHideMobileButtons == nil then
_G.AdaptHideMobileButtons = not AdaptAutoMobile
end
_G.AdaptMobileButtonScale = tonumber(data.mobileButtonScale) or (AdaptAutoMobile and 0.90 or 1.00)
_G.AdaptMobileButtonPositions = {}
_G.AdaptMobileButtonImage = tostring(data.mobileButtonImage or "")
_G.AdaptMobileButtonShape = tostring(data.mobileButtonShape or "ROUNDED"):upper()
if _G.AdaptMobileButtonShape ~= "CIRCLE" and _G.AdaptMobileButtonShape ~= "SQUARE" and _G.AdaptMobileButtonShape ~= "ROUNDED" then
_G.AdaptMobileButtonShape = "ROUNDED"
end
_G.AdaptStealUIImage = tostring(data.stealUIImage or "")
if data.autoStealV3Radius ~= nil then
    _G.AdaptStealRadii = _G.AdaptStealRadii or {}
    _G.AdaptStealRadii["Auto Steal V3"] = tonumber(data.autoStealV3Radius) or 63
    if selectedStealMode == "Auto Steal V3" then
        autoStealRadius = _G.AdaptStealRadii["Auto Steal V3"]
        if autoStealRadiusBox then
            autoStealRadiusBox.Text = tostring(autoStealRadius)
        end
    end
end

_G.AdaptDuelMode = (tostring(data.duelMode or "half") == "full") and "full" or "half"
_G.AdaptAutoMoveSpeed = tonumber(data.autoMoveSpeed) or _G.AdaptAutoMoveSpeed or 60
_G.AdaptAutoMoveCarrySpeed = tonumber(data.autoMoveCarrySpeed) or _G.AdaptAutoMoveCarrySpeed or 30
_G.AdaptStretchValue = tonumber(data.stretchValue) or _G.AdaptStretchValue or 0.7
_G.AdaptStretchPreset = tostring(data.stretchPreset or _G.AdaptStretchPreset or "Medium")
_G.AdaptSavedAvatarChangerUserId = tonumber(data.avatarChangerUserId)
if _G.AdaptSavedAvatarChangerUserId == 0 then _G.AdaptSavedAvatarChangerUserId = nil; _G.AdaptAvatarChangerCleared = true else _G.AdaptAvatarChangerCleared = false end
_G.AdaptSavedAvatarChangerUsername = tostring(data.avatarChangerUsername or "")
applySavedKeybinds(keybindData.keybinds)
if keybindData.tpDownKeybind ~= nil then
if tostring(keybindData.tpDownKeybind) == "None" then
tpDownKeybind = nil
else
tpDownKeybind = stringToKeyCode(keybindData.tpDownKeybind) or DEFAULT_TP_DOWN_KEYBIND
end
end
for keyId, defaultKey in pairs(DEFAULT_SPEED_KEYBINDS) do
local savedKeys = keybindData and keybindData.keybinds
if (not savedKeys or savedKeys[keyId] == nil) and speedKeybinds[keyId] == nil then
speedKeybinds[keyId] = defaultKey
end
end
NS = tonumber(data.NS) or NS
CS = tonumber(data.CS) or CS
LAGGER_SPEED = tonumber(data.LAGGER_SPEED) or LAGGER_SPEED
LAGGER_CARRY_SPEED = tonumber(data.LAGGER_CARRY_SPEED) or LAGGER_CARRY_SPEED
currentSpeedMode = data.currentSpeedMode or currentSpeedMode
_G.AdaptDropMode = (data.dropMode == "Jump Drop") and "Jump Drop" or "Stand Drop"
if currentSpeedMode ~= "Normal" and currentSpeedMode ~= "Carry" and currentSpeedMode ~= "Lagger" and currentSpeedMode ~= "Lagger Carry" then currentSpeedMode = "Normal" end
autoCarrySpeedEnabled = data.autoCarrySpeedEnabled == true
autoTPEnabled = data.autoTPEnabled == true
autoTPHeight = tonumber(data.autoTPHeight) or autoTPHeight
infJumpEnabled = data.infJumpEnabled == true
_G.AdaptInfJumpMode = (data.infJumpMode == "Hold") and "Hold" or "Tap"
antiRagdollEnabled = data.antiRagdollEnabled == true
_G.AdaptAntiRagdollMode = (data.antiRagdollMode == "V2") and "V2" or "V1"
_G.AdaptAntiVoidEnabled = data.antiVoidEnabled == true
_G.AdaptAntiResetEnabled = data.antiResetEnabled == true
selectedAnimationPack = data.selectedAnimationPack or selectedAnimationPack
_G.AdaptSelectedMoreAnimationBundle = data.selectedMoreAnimationBundle
selectedStealMode = data.selectedStealMode or selectedStealMode
if selectedStealMode == "Auto Steal V3" then selectedStealMode = "Auto Steal V3" end
if selectedStealMode ~= "Semi" then selectedStealMode = "Auto Steal V3" end
autoStealEnabled = data.autoStealEnabled == true
if type(data.aceStealRadii) == "table" then
_G.AdaptStealRadii["Auto Steal V3"] = tonumber(
    data.aceStealRadii["Auto Steal V3"]
    or data.aceStealRadii.Normal
    or data.autoStealV3Radius
) or _G.AdaptStealRadii["Auto Steal V3"] or 63
_G.AdaptStealRadii.Semi = tonumber(data.aceStealRadii.Semi) or _G.AdaptStealRadii.Semi or 9
end
autoStealRadius = tonumber(data.autoStealRadius) or autoStealRadius
_G.AdaptStealRadii = _G.AdaptStealRadii or {["Auto Steal V3"] = 63, Semi = 9}

if selectedStealMode == "Auto Steal V3" then
    autoStealRadius = tonumber(
        data.autoStealV3Radius
        or _G.AdaptStealRadii["Auto Steal V3"]
        or autoStealRadius
        or 63
    ) or 63
    _G.AdaptStealRadii["Auto Steal V3"] = autoStealRadius
else
    autoStealRadius = tonumber(_G.AdaptStealRadii.Semi) or 9
end
selectedAimbotMode = data.selectedAimbotMode or selectedAimbotMode
if selectedAimbotMode ~= "Anti Bypass" then selectedAimbotMode = "Normal" end
AIMBOT_SPEED = tonumber(data.AIMBOT_SPEED) or AIMBOT_SPEED
LAGGER_AIMBOT_SPEED = tonumber(data.LAGGER_AIMBOT_SPEED) or LAGGER_AIMBOT_SPEED
_G.AdaptAntiBypassAimbotSpeed = tonumber(data.ANTI_BYPASS_AIMBOT_SPEED) or _G.AdaptAntiBypassAimbotSpeed or 58
if data.ANTI_BYPASS_LAGGER_AIMBOT_SPEED == nil or tonumber(data.ANTI_BYPASS_LAGGER_AIMBOT_SPEED) == 58 then
_G.AdaptAntiBypassLaggerAimbotSpeed = 40
else
_G.AdaptAntiBypassLaggerAimbotSpeed = tonumber(data.ANTI_BYPASS_LAGGER_AIMBOT_SPEED) or 40
end
ANTI_DESYNC_AIMBOT_SPEED = tonumber(data.ANTI_DESYNC_AIMBOT_SPEED) or ANTI_DESYNC_AIMBOT_SPEED or 58
autoSwingEnabled = data.autoSwingEnabled == true
mirrorTPDownEnabled = data.mirrorTPDownEnabled == true
_G.AdaptNormalAimbotOn = data.normalAimbotEnabled == true
_G.AdaptAntiBypassAimbotOn = data.antiBypassAimbotEnabled == true
antiDesyncAutoSwingEnabled = data.antiDesyncAutoSwingEnabled == true
_G.AdaptAntiDesyncAimbotOn = data.antiDesyncAimbotEnabled == true
batCounterEnabled = data.batCounterEnabled == true
medCounterEnabled = data.medCounterEnabled == true
antiKickEnabled = data.safeMode == true
autoResetOnMedEnabled = data.autoResetOnMedEnabled == true
espEnabled = data.espEnabled == true
showTracerEnabled = false
ragdollCountdownEnabled = true
fpsBoostEnabled = data.fpsBoostEnabled == true
antiLagVisualEnabled = data.antiLagVisualEnabled == true
nukeOptimiserEnabled = data.nukeOptimiserEnabled == true
fovEnabled = data.fovEnabled == true
fovValue = tonumber(data.fovValue) or fovValue
noCamCollisionEnabled = data.noCamCollisionEnabled == true
_G.AdaptNoPlayerCollisionEnabled = data.noPlayerCollisionEnabled == true
_G.AdaptCustomFontSelected = (type(data.customFontSelected) == "string" and data.customFontSelected) or "None"
customFontVisualEnabled = _G.AdaptCustomFontSelected ~= "None"
skyTheme = (type(data.skyTheme) == "string" and data.skyTheme) or skyTheme
autoLeftEnabled = data.autoLeftEnabled == true
autoRightEnabled = data.autoRightEnabled == true
if data.introEnabled ~= nil then _introEnabled = data.introEnabled == true end
if data.selectedIntroMusic and ADAPT_INTRO_MUSIC_OPTIONS[data.selectedIntroMusic] then
selectedIntroMusic = data.selectedIntroMusic
else
selectedIntroMusic = 1
end
if autoLeftEnabled and autoRightEnabled then autoRightEnabled = false end
end
loadAdaptConfig()
local function syncAnimationPackIndex()
for i, name in ipairs(AnimationPackList) do
if name == selectedAnimationPack then
AnimationPackIndex = i
return
end
end
selectedAnimationPack = "OFF"
AnimationPackIndex = 1
end
local function applySavedAnimationPackToCharacter(char)
syncAnimationPackIndex()
if refreshAnimationPackRow then pcall(refreshAnimationPackRow) end
if not char then char = LP.Character end
if not char then return end
local animate = char:FindFirstChild("Animate") or char:WaitForChild("Animate", 6)
if not animate then return end
task.wait(0.2)
OriginalAnims = {}
unwalkSavedAnimate = nil
if selectedAnimationPack and selectedAnimationPack ~= "OFF" then
    pcall(function() applyAnimationPack(selectedAnimationPack) end)
elseif _G.AdaptSelectedMoreAnimationBundle and applyFullAnimationBundle then
    --Leaked By Xlu0 AndPrime--
    task.wait(0.15)
    pcall(function()
        applyFullAnimationBundle(_G.AdaptSelectedMoreAnimationBundle)
    end)
else
    pcall(function() resetAnimations() end)
end
end
syncAnimationPackIndex()
task.defer(function()
applySavedAnimationPackToCharacter(LP.Character)
end)
LP.CharacterAdded:Connect(function(char)
task.wait(0.65)
task.defer(function()
task.wait(0.2)
_G.AdaptApplyCharacterVisuals(char)
end)
if _G.AdaptAntiVoidEnabled then pcall(_G.AdaptAntiVoidSaveSafe) end
applySavedAnimationPackToCharacter(char)

--Leaked By Xlu0 AndPrime--
if _G.AdaptSelectedMoreAnimationBundle then
    task.delay(1.25, function()
        if char == LP.Character and char.Parent and applyFullAnimationBundle then
            pcall(function()
                applyFullAnimationBundle(_G.AdaptSelectedMoreAnimationBundle)
            end)
        end
    end)
end
end)
_G.AdaptAutoResetOnMed = _G.AdaptAutoResetOnMed or {}
_G.AdaptAutoResetOnMed.conns = _G.AdaptAutoResetOnMed.conns or {}
_G.AdaptAutoResetOnMed.enabled = autoResetOnMedEnabled == true
_G.AdaptAutoResetOnMed.medTriggered = false
_G.AdaptAutoResetOnMed.lastFire = _G.AdaptAutoResetOnMed.lastFire or 0
_G.AdaptAutoResetOnMed.cooldown = 2.25
_G.AdaptAutoResetOnMed.charAddedConn = _G.AdaptAutoResetOnMed.charAddedConn

function _G.AdaptAutoResetShouldFire(part)
local state = _G.AdaptAutoResetOnMed
if not state or not state.enabled then return false end
if state.medTriggered then return false end
if tick() - (state.lastFire or 0) < (state.cooldown or 2.25) then return false end
if not part or not part.Parent then return false end
if part:FindFirstAncestorOfClass("Tool") or part:FindFirstAncestorOfClass("Accessory") then
return false
end
return part.Anchored and part.Transparency == 1
end
function _G.AdaptAutoResetFireOnce(part)
if not _G.AdaptAutoResetShouldFire(part) then return end
local state = _G.AdaptAutoResetOnMed
state.medTriggered = true
state.lastFire = tick()
task.delay(2.3, function()
if state.enabled then
end
end)
end
function _G.AdaptAutoResetOnAnchorChanged(part)
return part:GetPropertyChangedSignal("Anchored"):Connect(function()
_G.AdaptAutoResetFireOnce(part)
end)
end
function _G.AdaptStopAutoResetOnMed()
local state = _G.AdaptAutoResetOnMed
if not state then return end
for _, conn in ipairs(state.conns or {}) do
pcall(function()
conn:Disconnect()
end)
end
state.conns = {}
state.medTriggered = false
end
function _G.AdaptStartAutoResetOnMed(char)
local state = _G.AdaptAutoResetOnMed
if not state then return end
_G.AdaptStopAutoResetOnMed()
state.medTriggered = false
char = char or LP.Character
if not char then return end
for _, part in ipairs(char:GetDescendants()) do
if part:IsA("BasePart") then
table.insert(state.conns, _G.AdaptAutoResetOnAnchorChanged(part))
_G.AdaptAutoResetFireOnce(part)
end
end
table.insert(state.conns, char.DescendantAdded:Connect(function(part)
if part:IsA("BasePart") then
table.insert(state.conns, _G.AdaptAutoResetOnAnchorChanged(part))
_G.AdaptAutoResetFireOnce(part)
end
end))
table.insert(state.conns, char.AncestryChanged:Connect(function(_, parent)
if not parent then
state.medTriggered = false
end
end))
end
function _G.AdaptEnableAutoResetOnMed()
autoResetOnMedEnabled = true
_G.AdaptAutoResetOnMed.enabled = true
_G.AdaptStartAutoResetOnMed(LP.Character)
end
function _G.AdaptDisableAutoResetOnMed()
autoResetOnMedEnabled = false
_G.AdaptAutoResetOnMed.enabled = false
_G.AdaptStopAutoResetOnMed()
end
function _G.AdaptSetAutoResetOnMed(state, noSave)
autoResetOnMedEnabled = state == true
if autoResetOnMedEnabled then
_G.AdaptEnableAutoResetOnMed()
else
_G.AdaptDisableAutoResetOnMed()
end
if setAutoResetOnMedVisual then
setAutoResetOnMedVisual(autoResetOnMedEnabled)
end
if not noSave and saveAdaptConfig then do end end
end
function enableAutoResetOnMed()
_G.AdaptSetAutoResetOnMed(true)
end
function disableAutoResetOnMed()
_G.AdaptSetAutoResetOnMed(false)
end
function toggleAutoResetOnMed(on)
_G.AdaptSetAutoResetOnMed(on == true)
end
if not _G.AdaptAutoResetOnMed.charAddedConn then
_G.AdaptAutoResetOnMed.charAddedConn = LP.CharacterAdded:Connect(function(char)
if _G.AdaptAutoResetOnMed and _G.AdaptAutoResetOnMed.enabled then
task.wait(0.25)
_G.AdaptStartAutoResetOnMed(char)
end
end)
end
_G.AdaptCounterState = _G.AdaptCounterState or {}
_G.AdaptCounterState.batConn = nil
_G.AdaptCounterState.batDebounce = false
_G.AdaptCounterState.medConns = _G.AdaptCounterState.medConns or {}
_G.AdaptCounterState.medDebounce = false
_G.AdaptCounterState.medLastUsed = _G.AdaptCounterState.medLastUsed or 0
_G.AdaptMedusaCooldown = 25
function _G.AdaptFindMedusa()
local c = LP.Character
if not c then return nil end
for _, t in ipairs(c:GetChildren()) do
if t:IsA("Tool") then
local n = t.Name:lower()
if n:find("medusa") or n:find("head") or n:find("stone") then return t end
end
end
local bp = LP:FindFirstChild("Backpack") or LP:FindFirstChildOfClass("Backpack")
if bp then
for _, t in ipairs(bp:GetChildren()) do
if t:IsA("Tool") then
local n = t.Name:lower()
if n:find("medusa") or n:find("head") or n:find("stone") then return t end
end
end
end
return nil
end
function _G.AdaptUseMedusaCounter()
if not medCounterEnabled then return end
if _G.AdaptCounterState.medDebounce then return end
if tick() - (_G.AdaptCounterState.medLastUsed or 0) < _G.AdaptMedusaCooldown then return end
local c = LP.Character
if not c then return end
_G.AdaptCounterState.medDebounce = true
local med = _G.AdaptFindMedusa()
if not med then
_G.AdaptCounterState.medDebounce = false
return
end
if med.Parent ~= c then
local hum = c:FindFirstChildOfClass("Humanoid")
if hum then pcall(function() hum:EquipTool(med) end) end
task.wait(0.05)
end
pcall(function() med:Activate() end)
_G.AdaptCounterState.medLastUsed = tick()
_G.AdaptCounterState.medDebounce = false
end
function _G.AdaptOnMedusaAnchorChanged(part)
return part:GetPropertyChangedSignal("Anchored"):Connect(function()
if medCounterEnabled and part.Anchored and part.Transparency == 1 then
_G.AdaptUseMedusaCounter()
end
end)
end
function _G.AdaptStartMedCounter(char)
_G.AdaptStopMedCounter()
char = char or LP.Character
if not char then return end
for _, part in ipairs(char:GetDescendants()) do
if part:IsA("BasePart") then
table.insert(_G.AdaptCounterState.medConns, _G.AdaptOnMedusaAnchorChanged(part))
end
end
table.insert(_G.AdaptCounterState.medConns, char.DescendantAdded:Connect(function(part)
if part:IsA("BasePart") then
table.insert(_G.AdaptCounterState.medConns, _G.AdaptOnMedusaAnchorChanged(part))
end
end))
end
function _G.AdaptStopMedCounter()
for _, c in pairs(_G.AdaptCounterState.medConns or {}) do
pcall(function() c:Disconnect() end)
end
_G.AdaptCounterState.medConns = {}
_G.AdaptCounterState.medDebounce = false
end
_G.AdaptBatCounterSlapList = {"Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap"}
function _G.AdaptFindBatForCounter()
local c = LP.Character
if not c then return nil end
local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
for _, name in ipairs(_G.AdaptBatCounterSlapList) do
local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
if t then return t end
end
for _, ch in ipairs(c:GetChildren()) do
if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
end
if bp then
for _, ch in ipairs(bp:GetChildren()) do
if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
end
end
return nil
end
function _G.AdaptSwingBatForCounter(bat, char)
if not bat or not char then return end
local hum = char:FindFirstChildOfClass("Humanoid")
if bat.Parent ~= char then
if hum then pcall(function() hum:EquipTool(bat) end) end
task.wait(0.05)
end
local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
if remote and remote:IsA("RemoteEvent") then
pcall(function() remote:FireServer() end)
task.wait(0.15)
pcall(function() remote:FireServer() end)
else
pcall(function() bat:Activate() end)
task.wait(0.15)
pcall(function() bat:Activate() end)
end
end
function _G.AdaptCounterIsRagdoll(hum)
if not hum then return false end
local st = hum:GetState()
return st == Enum.HumanoidStateType.Physics
or st == Enum.HumanoidStateType.Ragdoll
or st == Enum.HumanoidStateType.FallingDown
or hum.PlatformStand == true
end
function _G.AdaptStartBatCounter()
if _G.AdaptCounterState.batConn then return end
_G.AdaptCounterState.batDebounce = false
_G.AdaptCounterState.batConn = RunService.Heartbeat:Connect(function()
if not batCounterEnabled then return end
if _G.AdaptCounterState.batDebounce then return end
local char = LP.Character
if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid")
if not hum then return end
if _G.AdaptCounterIsRagdoll(hum) then
_G.AdaptCounterState.batDebounce = true
task.spawn(function()
local bat = _G.AdaptFindBatForCounter()
if bat then _G.AdaptSwingBatForCounter(bat, char) end
task.wait(0.5)
_G.AdaptCounterState.batDebounce = false
end)
end
end)
end
function _G.AdaptStopBatCounter()
if _G.AdaptCounterState.batConn then
_G.AdaptCounterState.batConn:Disconnect()
_G.AdaptCounterState.batConn = nil
end
_G.AdaptCounterState.batDebounce = false
end
startBatCounter = _G.AdaptStartBatCounter
stopBatCounter = _G.AdaptStopBatCounter
setupMedusaCounter = _G.AdaptStartMedCounter
stopMedusaCounter = _G.AdaptStopMedCounter
_G.AdaptNoPlayerCollisionState = _G.AdaptNoPlayerCollisionState or {connections = {}}
function _G.AdaptSetOtherPlayerCollision(state)
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
for _, part in ipairs(plr.Character:GetDescendants()) do
if part:IsA("BasePart") then
pcall(function() part.CanCollide = state end)
end
end
end
end
end
function enableNoPlayerCollision()
if _G.AdaptNoPlayerCollisionState.running then return end
_G.AdaptNoPlayerCollisionEnabled = true
_G.AdaptNoPlayerCollisionState.running = true
for _, conn in ipairs(_G.AdaptNoPlayerCollisionState.connections or {}) do
pcall(function() conn:Disconnect() end)
end
_G.AdaptNoPlayerCollisionState.connections = {}
_G.AdaptSetOtherPlayerCollision(false)
table.insert(_G.AdaptNoPlayerCollisionState.connections, LP.CharacterAdded:Connect(function()
task.wait(0.5)
if _G.AdaptNoPlayerCollisionEnabled then _G.AdaptSetOtherPlayerCollision(false) end
end))
table.insert(_G.AdaptNoPlayerCollisionState.connections, Players.PlayerAdded:Connect(function(plr)
local c = plr.CharacterAdded:Connect(function()
task.wait(0.5)
if _G.AdaptNoPlayerCollisionEnabled then _G.AdaptSetOtherPlayerCollision(false) end
end)
table.insert(_G.AdaptNoPlayerCollisionState.connections, c)
end))
local collisionScanElapsed = 0
table.insert(_G.AdaptNoPlayerCollisionState.connections, RunService.Heartbeat:Connect(function(dt)
if not _G.AdaptNoPlayerCollisionEnabled then return end
collisionScanElapsed = collisionScanElapsed + (dt or 0)
if collisionScanElapsed < 0.25 then return end
collisionScanElapsed = 0
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
for _, part in ipairs(plr.Character:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide == true then
pcall(function() part.CanCollide = false end)
end
end
end
end
end))
end
function disableNoPlayerCollision()
if not _G.AdaptNoPlayerCollisionState.running then
_G.AdaptNoPlayerCollisionEnabled = false
return
end
_G.AdaptNoPlayerCollisionEnabled = false
_G.AdaptNoPlayerCollisionState.running = false
for _, conn in ipairs(_G.AdaptNoPlayerCollisionState.connections or {}) do
pcall(function() conn:Disconnect() end)
end
_G.AdaptNoPlayerCollisionState.connections = {}
_G.AdaptSetOtherPlayerCollision(true)
end
function _G.AdaptSafeModeGetCountdownLabel()
local ok, label = pcall(function()
return LP.PlayerGui
and LP.PlayerGui:FindFirstChild("DuelsMachineTopFrame")
and LP.PlayerGui.DuelsMachineTopFrame:FindFirstChild("DuelsMachineTopFrame")
and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame:FindFirstChild("Timer")
and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame.Timer:FindFirstChild("Label")
end)
return (ok and label) or nil
end
function _G.AdaptSafeModeCountdownNumber(text)
local t = tostring(text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
if t == "GO" or t == "START" or t == "READY" then return true end
local n = tonumber(t)
return n ~= nil and n >= 0 and n <= 10
end
function _G.AdaptSafeModeInDuelCountdown()
local label = _G.AdaptSafeModeGetCountdownLabel()
return label and _G.AdaptSafeModeCountdownNumber(label.Text) or false
end
_G.AdaptSafeModeBlockedTools = {
bat=true, slap=true, sword=true, gun=true, pistol=true, rifle=true,
medusa=true, hammer=true, axe=true, knife=true, katana=true, blade=true, fist=true,
}
function _G.AdaptSafeModeIsCarryableTool(tool)
if not tool or not tool:IsA("Tool") then return false end
local name = tool.Name:lower()
for word in pairs(_G.AdaptSafeModeBlockedTools) do
if name:find(word, 1, true) then return false end
end
return true
end
function _G.AdaptSafeModeHoldingBrainrot()
local ok, val = pcall(function() return LP:GetAttribute("Stealing") end)
if ok and val == true then return true end
local ok2, val2 = pcall(function() return LP:GetAttribute("AntiKick") end)
if ok2 and val2 == true then return true end
local char = LP.Character
if not char then return false end
local ok3, val3 = pcall(function() return char:GetAttribute("Stealing") end)
if ok3 and val3 == true then return true end
if _G.AutoCarrySpeed and type(_G.AutoCarrySpeed.IsCarryingBrainrot) == "function" then
local okCarry, carrying = pcall(function() return _G.AutoCarrySpeed.IsCarryingBrainrot(char) end)
if okCarry and carrying then return true end
end
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
function _G.AdaptSafeModeIsLocked()
if not antiKickEnabled then return false end
return _G.AdaptSafeModeInDuelCountdown() or _G.AdaptSafeModeHoldingBrainrot()
end
function _G.AdaptSafeModeForceStop(reason)
local stopped = false
if _G.AdaptNormalAimbotOn and _G.AdaptStopNormalAimbot then _G.AdaptStopNormalAimbot(); stopped = true end
if _G.AdaptAntiBypassAimbotOn and _G.AdaptStopAntiBypassAimbot then _G.AdaptStopAntiBypassAimbot(false); stopped = true end
if _G.AdaptAntiDesyncAimbotOn and _G.AdaptStopAntiDesyncAimbot then _G.AdaptStopAntiDesyncAimbot(); stopped = true end
if autoLeftEnabled then
autoLeftEnabled = false
if _G.AdaptSetAutoLeftVisual then _G.AdaptSetAutoLeftVisual(false) end
if _G.AdaptStopAutoLeft then _G.AdaptStopAutoLeft() end
stopped = true
end
if autoRightEnabled then
autoRightEnabled = false
if _G.AdaptSetAutoRightVisual then _G.AdaptSetAutoRightVisual(false) end
if _G.AdaptStopAutoRight then _G.AdaptStopAutoRight() end
stopped = true
end
if stopped and showActionNotification then pcall(function() showActionNotification(reason or "SAFE MODE LOCK") end) end
end
function _G.AdaptSafeModeTryStart()
if _G.AdaptSafeModeIsLocked and _G.AdaptSafeModeIsLocked() then
_G.AdaptSafeModeForceStop("SAFE MODE LOCK")
return false
end
return true
end
_G.AdaptSafeModeMonitorStarted = _G.AdaptSafeModeMonitorStarted or false
if not _G.AdaptSafeModeMonitorStarted then
_G.AdaptSafeModeMonitorStarted = true
RunService.Heartbeat:Connect(function()
if antiKickEnabled and _G.AdaptSafeModeIsLocked and _G.AdaptSafeModeIsLocked() then
_G.AdaptSafeModeForceStop("SAFE MODE LOCK")
end
end)
end
LP.CharacterAdded:Connect(function(char)
task.wait(0.5)
if medCounterEnabled then _G.AdaptStartMedCounter(char) end
if batCounterEnabled then _G.AdaptStartBatCounter() end
end)
_G.AdaptNormalAimbot = _G.AdaptNormalAimbot or {conn = nil, target = nil, swingCooldown = false}
function _G.AdaptFindAimbotBat()
local char = LP.Character
if not char then return nil end
for _, tool in ipairs(char:GetChildren()) do
if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
return tool
end
end
local bp = LP:FindFirstChild("Backpack")
if bp then
for _, tool in ipairs(bp:GetChildren()) do
if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
return tool
end
end
end
return nil
end
function _G.AdaptGetClosestAimbotTarget()
local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
if not root then return nil end
local closest, minDist = nil, math.huge
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
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
function _G.AdaptGetNormalAimbotSpeed()
if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
return tonumber(LAGGER_AIMBOT_SPEED) or 40
end
return tonumber(AIMBOT_SPEED) or 58
end
function _G.AdaptGetAntiBypassAimbotSpeed()
if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
return tonumber(_G.AdaptAntiBypassLaggerAimbotSpeed) or 40
end
return tonumber(_G.AdaptAntiBypassAimbotSpeed) or 58
end
function _G.AdaptGetSelectedAimbotSpeedValues()
if selectedAimbotMode == "Anti Bypass" then
return tonumber(_G.AdaptAntiBypassAimbotSpeed) or 58, tonumber(_G.AdaptAntiBypassLaggerAimbotSpeed) or 40
end
return tonumber(AIMBOT_SPEED) or 58, tonumber(LAGGER_AIMBOT_SPEED) or 40
end
function _G.AdaptSetSelectedAimbotSpeedValues(normalValue, laggerValue)
if selectedAimbotMode == "Anti Bypass" then
if normalValue then _G.AdaptAntiBypassAimbotSpeed = normalValue end
if laggerValue then _G.AdaptAntiBypassLaggerAimbotSpeed = laggerValue end
else
if normalValue then AIMBOT_SPEED = normalValue end
if laggerValue then LAGGER_AIMBOT_SPEED = laggerValue end
end
end
function _G.AdaptRefreshAimbotSpeedBoxes()
local n, l = _G.AdaptGetSelectedAimbotSpeedValues()
if _G.AdaptAimbotSpeedBox then _G.AdaptAimbotSpeedBox.Text = tostring(n) end
if _G.AdaptLaggerAimbotSpeedBox then _G.AdaptLaggerAimbotSpeedBox.Text = tostring(l) end
end

_G.AdaptNormalAimbot = _G.AdaptNormalAimbot or {
    conn = nil,
    target = nil,
    lastScan = 0,
    attachment = nil,
    linearVelocity = nil,
}

local function _AdaptAimbotEnsureLinearVelocity(root)
    local S = _G.AdaptNormalAimbot

    if S.linearVelocity
        and S.linearVelocity.Parent
        and S.attachment
        and S.attachment.Parent == root then
        S.linearVelocity.Enabled = true
        return S.linearVelocity
    end

    if S.linearVelocity then
        pcall(function() S.linearVelocity:Destroy() end)
    end
    if S.attachment then
        pcall(function() S.attachment:Destroy() end)
    end

    local att = Instance.new("Attachment")
    att.Name = "AdaptAimbotAttachment"
    att.Parent = root

    local lv = Instance.new("LinearVelocity")
    lv.Name = "AdaptAimbotLinearVelocity"
    lv.Attachment0 = att
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.ForceLimitMode = Enum.ForceLimitMode.Magnitude
    lv.MaxForce = math.huge
    lv.VectorVelocity = Vector3.zero
    lv.Enabled = true
    lv.Parent = att

    S.attachment = att
    S.linearVelocity = lv
    return lv
end

local function _AdaptAimbotReleaseLinearVelocity()
    local S = _G.AdaptNormalAimbot
    if S.linearVelocity and S.linearVelocity.Parent then
        S.linearVelocity.VectorVelocity = Vector3.zero
        S.linearVelocity.Enabled = false
    end
end

function _G.AdaptStartNormalAimbot()
    if _G.AdaptSafeModeTryStart and not _G.AdaptSafeModeTryStart() then
        return false
    end

    if _G.AdaptStopAntiBypassAimbot then
        _G.AdaptStopAntiBypassAimbot(false)
    end
    _G.AdaptAntiBypassAimbotOn = false

    if _G.AdaptNormalAimbot.conn then
        pcall(function() _G.AdaptNormalAimbot.conn:Disconnect() end)
        _G.AdaptNormalAimbot.conn = nil
    end

    _G.AdaptNormalAimbotAutoTPWasEnabled = false
    if autoTPEnabled then
        _G.AdaptNormalAimbotAutoTPWasEnabled = true
        stopAutoTP()
        if setAutoTPVisual then setAutoTPVisual(false) end
    end

    _G.AdaptNormalAimbotOn = true
    _G.AdaptNormalAimbot.target = nil
    _G.AdaptNormalAimbot.lastScan = 0

    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate = false end

    _G.AdaptNormalAimbot.conn = RunService.Heartbeat:Connect(function()
        if not _G.AdaptNormalAimbotOn or selectedAimbotMode ~= "Normal" then
            return
        end

        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hum or not root or hum.Health <= 0 then
            return
        end

        --Leaked By Xlu0 AndPrime--
        if not char:FindFirstChildOfClass("Tool") then
            local bat = _G.AdaptFindAimbotBat()
            if bat then
                pcall(function() hum:EquipTool(bat) end)
            end
        end

        --Leaked By Xlu0 AndPrime--
        local now = tick()
        local target = _G.AdaptNormalAimbot.target

        if now - (_G.AdaptNormalAimbot.lastScan or 0) > 0.1
            or not target
            or not target.Parent then

            _G.AdaptNormalAimbot.lastScan = now
            local closest, minDist = nil, math.huge

            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                    local th = plr.Character:FindFirstChildOfClass("Humanoid")

                    if tRoot and th and th.Health > 0 then
                        local dist = (tRoot.Position - root.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            closest = tRoot
                        end
                    end
                end
            end

            target = closest
            _G.AdaptNormalAimbot.target = target
        end

        if not target then
            hum.AutoRotate = true
            root.AssemblyAngularVelocity = Vector3.zero
            _AdaptAimbotReleaseLinearVelocity()
            return
        end

        local targetHum = target.Parent and target.Parent:FindFirstChildOfClass("Humanoid")
        if not targetHum or targetHum.Health <= 0 then
            _G.AdaptNormalAimbot.target = nil
            _AdaptAimbotReleaseLinearVelocity()
            return
        end

        hum.AutoRotate = false

        --Leaked By Xlu0 AndPrime--
        local targetVel = target.AssemblyLinearVelocity
        local aimTargetPos =
            target.Position
            + (targetVel * math.clamp(targetVel.Magnitude / 130, 0.05, 0.15))
            + Vector3.new(0, 1, 0)

        local look = aimTargetPos - root.Position
        local flatLook = Vector3.new(look.X, 0, look.Z)

        --Leaked By Xlu0 AndPrime--
        if look.Magnitude > 0.01 and flatLook.Magnitude > 0.01 then
            local targetYaw = math.deg(math.atan2(-flatLook.X, -flatLook.Z))
            local yawDelta = (targetYaw - root.Orientation.Y + 180) % 360 - 180

            local targetPitch = math.deg(math.atan2(look.Y, flatLook.Magnitude))
            local pitchDelta = (targetPitch - root.Orientation.X + 180) % 360 - 180

            local yawRate = math.clamp(
                math.rad(yawDelta) * 285,
                -28,
                28
            )

            local pitchRate = math.clamp(
                math.rad(pitchDelta) * 285,
                -28,
                28
            )

            local yawRad = math.rad(root.Orientation.Y)
            local rightAxis = Vector3.new(
                math.cos(yawRad),
                0,
                -math.sin(yawRad)
            )

            root.AssemblyAngularVelocity =
                Vector3.new(0, yawRate, 0)
                + (rightAxis * pitchRate)
        else
            root.AssemblyAngularVelocity = Vector3.zero
        end

        --Leaked By Xlu0 AndPrime--
        local dir = look.Magnitude > 0.01 and look.Unit or Vector3.zero
        local standPos =
            aimTargetPos
            - (dir * -2.8)
            + Vector3.new(0, 4.75, 0)

        local moveDir = standPos - root.Position
        local hDir = Vector3.new(moveDir.X, 0, moveDir.Z)

        local selectedSpeed =
            (currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry")
            and (tonumber(LAGGER_AIMBOT_SPEED) or 40)
            or (tonumber(AIMBOT_SPEED) or 58)

        local hVel =
            hDir.Magnitude > 0.1
            and (hDir.Unit * selectedSpeed)
            or Vector3.zero

        local verticalSpeed = 52
        local vVel =
            math.abs(moveDir.Y) > 0.1
            and Vector3.new(
                0,
                math.sign(moveDir.Y) * verticalSpeed,
                0
            )
            or Vector3.new(0, -2, 0)

        --Leaked By Xlu0 AndPrime--
        local lv = _AdaptAimbotEnsureLinearVelocity(root)
        lv.VectorVelocity = hVel + vVel

        if hDir.Magnitude > 0.5 then
            hum:Move(hDir.Unit, false)
        end

        if autoSwingEnabled then
            local bat = char:FindFirstChild("Bat") or _G.AdaptFindAimbotBat()
            if bat and bat:IsA("Tool") then
                pcall(function() bat:Activate() end)
            end
        end
    end)

    if _G.AdaptRefreshAimbotVisual then
        _G.AdaptRefreshAimbotVisual()
    end

    return true
end

function _G.AdaptStopNormalAimbot()
    _G.AdaptNormalAimbotOn = false

    if _G.AdaptNormalAimbot and _G.AdaptNormalAimbot.conn then
        pcall(function() _G.AdaptNormalAimbot.conn:Disconnect() end)
        _G.AdaptNormalAimbot.conn = nil
    end

    if _G.AdaptNormalAimbot then
        _G.AdaptNormalAimbot.target = nil
        _G.AdaptNormalAimbot.lastScan = 0
    end

    _AdaptAimbotReleaseLinearVelocity()

    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if root then
        root.AssemblyAngularVelocity = Vector3.zero
    end

    if hum then
        hum.AutoRotate = true
    end

    if _G.AdaptNormalAimbotAutoTPWasEnabled then
        _G.AdaptNormalAimbotAutoTPWasEnabled = false
        autoTPEnabled = true
        if setAutoTPVisual then setAutoTPVisual(true) end
        startAutoTP()
    end

    if _G.AdaptRefreshAimbotVisual then
        _G.AdaptRefreshAimbotVisual()
    end
end

_G.AdaptAntiBypassAimbot = _G.AdaptAntiBypassAimbot or {conn = nil, swingCooldown = false, prevAutoRotate = nil}
_G.AdaptAntiBypassSettings = {
SPEED = 63,
VERT_SPEED = 52,
DISTANCE = -2.8,
HEIGHT = 4.75,
V_OFFSET = 1,
TURN_SPEED = 285,
MAX_TURN_RATE = 28,
AUTO_SWING = true,
}
_G.AdaptAntiBypassSlapList = _G.AdaptAntiBypassSlapList or {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
function _G.AdaptAntiBypassFindBat()
local char = LP.Character
if not char then return nil end
for _, tool in ipairs(char:GetChildren()) do
if tool:IsA("Tool") then
local name = tool.Name:lower()
if name:find("bat") or name:find("slap") then return tool end
end
end
local bp = LP:FindFirstChildOfClass("Backpack")
if bp then
for _, tool in ipairs(bp:GetChildren()) do
if tool:IsA("Tool") then
local name = tool.Name:lower()
if name:find("bat") or name:find("slap") then return tool end
end
end
end
return nil
end
function _G.AdaptAntiBypassEnsureBat()
local char = LP.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
if not char or not hum then return nil end
local equipped = char:FindFirstChildOfClass("Tool")
if equipped then return equipped end
local bat = _G.AdaptAntiBypassFindBat()
if bat then pcall(function() hum:EquipTool(bat) end) end
return bat
end
function _G.AdaptAntiBypassTrySwing()
if _G.AdaptAntiBypassAimbot.swingCooldown then return end
_G.AdaptAntiBypassAimbot.swingCooldown = true
pcall(function()
local bat = _G.AdaptAntiBypassEnsureBat()
if bat and bat:IsA("Tool") then bat:Activate() end
end)
task.delay(0.3, function()
if _G.AdaptAntiBypassAimbot then _G.AdaptAntiBypassAimbot.swingCooldown = false end
end)
end
function _G.AdaptAntiBypassGetClosest()
local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
if not root then return nil, math.huge end
local closest, minDist = nil, math.huge
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
local hum = plr.Character:FindFirstChildOfClass("Humanoid")
if tRoot and hum and hum.Health > 0 then
local dist = (tRoot.Position - root.Position).Magnitude
if dist < minDist then minDist, closest = dist, tRoot end
end
end
end
return closest, minDist
end
function _G.AdaptStartAntiBypassAimbot()
if _G.AdaptSafeModeTryStart and not _G.AdaptSafeModeTryStart() then return false end
if _G.AdaptStopAutoTPForAction then _G.AdaptStopAutoTPForAction() end
if _G.AdaptStopNormalAimbot then _G.AdaptStopNormalAimbot() end
_G.AdaptAntiBypassAimbotOn = true
selectedAimbotMode = "Anti Bypass"
if _G.AdaptAntiBypassAimbot.conn then _G.AdaptAntiBypassAimbot.conn:Disconnect() end
local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
if hum0 then
_G.AdaptAntiBypassAimbot.prevAutoRotate = hum0.AutoRotate
hum0.AutoRotate = false
end
_G.AdaptAntiBypassAimbot.conn = RunService.Heartbeat:Connect(function()
if not _G.AdaptAntiBypassAimbotOn or selectedAimbotMode ~= "Anti Bypass" then return end
local char = LP.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
local root = char and char:FindFirstChild("HumanoidRootPart")
if not char or not hum or not root or hum.Health <= 0 then return end
local S = _G.AdaptAntiBypassSettings
hum.AutoRotate = false
_G.AdaptAntiBypassEnsureBat()
local target, targetDist = _G.AdaptAntiBypassGetClosest()
if not target then
root.AssemblyAngularVelocity = Vector3.zero
return
end
local aimTargetPos = target.Position + Vector3.new(0, S.V_OFFSET, 0)
local look = aimTargetPos - root.Position
local flatLook = Vector3.new(look.X, 0, look.Z)
if flatLook.Magnitude > 0.01 then
local targetYaw = math.deg(math.atan2(-flatLook.X, -flatLook.Z))
local yawDelta = (targetYaw - root.Orientation.Y + 180) % 360 - 180
local yawRate = math.clamp(yawDelta * 8, -S.MAX_TURN_RATE, S.MAX_TURN_RATE)
root.AssemblyAngularVelocity = Vector3.new(0, yawRate, 0)
else
root.AssemblyAngularVelocity = Vector3.zero
end
if look.Magnitude > 0.01 then
local dir = look.Unit
local standPos = aimTargetPos - (dir * S.DISTANCE) + Vector3.new(0, S.HEIGHT, 0)
local moveDir = standPos - root.Position
local hDir = Vector3.new(moveDir.X, 0, moveDir.Z)
local hVel = hDir.Magnitude > 0.1 and hDir.Unit * S.SPEED or Vector3.zero
local vVel = Vector3.new(0, math.clamp(moveDir.Y * 3, -S.VERT_SPEED, S.VERT_SPEED), 0)
root.AssemblyLinearVelocity = hVel + vVel
if hDir.Magnitude > 0.5 then hum:Move(hDir.Unit, false) end
end
if S.AUTO_SWING and autoSwingEnabled and targetDist < 5 then _G.AdaptAntiBypassTrySwing() end
end)
if _G.AdaptRefreshAimbotVisual then _G.AdaptRefreshAimbotVisual() end
return true
end
function _G.AdaptStopAntiBypassAimbot(keepVisual)
_G.AdaptAntiBypassAimbotOn = false
if _G.AdaptAntiBypassAimbot and _G.AdaptAntiBypassAimbot.conn then
_G.AdaptAntiBypassAimbot.conn:Disconnect()
_G.AdaptAntiBypassAimbot.conn = nil
end
if _G.AdaptAntiBypassAimbot then _G.AdaptAntiBypassAimbot.swingCooldown = false end
local char = LP.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local hum = char and char:FindFirstChildOfClass("Humanoid")
if root then
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
end
if hum then
hum.AutoRotate = (_G.AdaptAntiBypassAimbot.prevAutoRotate == nil) and true or _G.AdaptAntiBypassAimbot.prevAutoRotate
end
_G.AdaptAntiBypassAimbot.prevAutoRotate = nil
if keepVisual ~= false and _G.AdaptRefreshAimbotVisual then _G.AdaptRefreshAimbotVisual() end
end
function _G.AdaptToggleSelectedAimbot()
if selectedAimbotMode == "Anti Bypass" then
if _G.AdaptAntiBypassAimbotOn then
if _G.AdaptStopAntiBypassAimbot then _G.AdaptStopAntiBypassAimbot() else _G.AdaptAntiBypassAimbotOn = false end
else
if _G.AdaptStopNormalAimbot then _G.AdaptStopNormalAimbot() end
if _G.AdaptStartAntiBypassAimbot then _G.AdaptStartAntiBypassAimbot() else _G.AdaptAntiBypassAimbotOn = true end
end
else
if _G.AdaptNormalAimbotOn then
_G.AdaptStopNormalAimbot()
else
if _G.AdaptStopAntiBypassAimbot then _G.AdaptStopAntiBypassAimbot(false) else _G.AdaptAntiBypassAimbotOn = false end
_G.AdaptStartNormalAimbot()
end
end
if _G.AdaptRefreshAimbotVisual then _G.AdaptRefreshAimbotVisual() end
do end
end
function _G.AdaptRefreshAimbotVisual()
if _G.AdaptAimbotSetVisual then
if selectedAimbotMode == "Anti Bypass" then
_G.AdaptAimbotSetVisual(_G.AdaptAntiBypassAimbotOn == true)
else
_G.AdaptAimbotSetVisual(_G.AdaptNormalAimbotOn == true)
end
end
end
_G.AdaptNormalAimbotStart = _G.AdaptStartNormalAimbot
_G.AdaptNormalAimbotStop = _G.AdaptStopNormalAimbot
_G.AdaptAntiBypassStart = _G.AdaptStartAntiBypassAimbot
_G.AdaptAntiBypassStop = _G.AdaptStopAntiBypassAimbot

local MIRROR_TP_DROP_THRESHOLD = 3
local MIRROR_TP_DOWN_Y = -7.00
local mirrorTPPreviousY = {}
local mirrorTPLastTeleport = 0

local function mirrorTPAimbotActive()
return (_G.AdaptNormalAimbotOn == true) or (_G.AdaptAntiBypassAimbotOn == true)
end

local function mirrorTPTeleportDown()
local character = LP.Character
local root = character and character:FindFirstChild("HumanoidRootPart")
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if not root or not humanoid or humanoid.Health <= 0 then return end

local now = tick()
if now - (mirrorTPLastTeleport or 0) < 0.08 then return end
mirrorTPLastTeleport = now

local _, yaw = root.CFrame:ToEulerAnglesYXZ()
local y = (MIRROR_TP_DOWN_Y or -7) + (math.random() * 0.6 - 0.3)
root.CFrame = CFrame.new(root.Position.X, y, root.Position.Z) * CFrame.Angles(0, yaw, 0)
root.AssemblyLinearVelocity = Vector3.new((math.random() - 0.5) * 0.4, 0, (math.random() - 0.5) * 0.4)
end

RunService.Heartbeat:Connect(function()
if not mirrorTPDownEnabled or not mirrorTPAimbotActive() then
if next(mirrorTPPreviousY) then
table.clear(mirrorTPPreviousY)
end
return
end

for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
local root = plr.Character:FindFirstChild("HumanoidRootPart")
if root then
local currentY = root.Position.Y
local previousY = mirrorTPPreviousY[plr.UserId]
if previousY and previousY - currentY >= (MIRROR_TP_DROP_THRESHOLD or 3) then
pcall(mirrorTPTeleportDown)
table.clear(mirrorTPPreviousY)
return
end
mirrorTPPreviousY[plr.UserId] = currentY
end
end
end
end)

function _G.AdaptSetMirrorTPDown(enabled)
mirrorTPDownEnabled = enabled == true
if not mirrorTPDownEnabled then
table.clear(mirrorTPPreviousY)
end
if _G.AdaptMirrorTPDownSetVisual then
_G.AdaptMirrorTPDownSetVisual(mirrorTPDownEnabled)
end
end

_G.AdaptAntiDesync = _G.AdaptAntiDesync or {
    conn = nil,
    hittingCooldown = false,
    h = nil,
    hrp = nil
}

local XLU0_TP_BAT_NAMES = {
    "Bat","Slap","Iron Slap","Gold Slap","Diamond Slap",
    "Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap",
    "Nuclear Slap","Galaxy Slap","Glitched Slap"
}

function _G.AdaptAntiDesyncGetBat()
    local char = LP.Character
    if not char then return nil end

    for _, name in ipairs(XLU0_TP_BAT_NAMES) do
        local tool = char:FindFirstChild(name)
        if tool and tool:IsA("Tool") then
            return tool
        end
    end

    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, name in ipairs(XLU0_TP_BAT_NAMES) do
            local tool = bp:FindFirstChild(name)
            if tool and tool:IsA("Tool") then
                tool.Parent = char
                return tool
            end
        end
    end

    return nil
end

function _G.AdaptAntiDesyncTrySwing()
    if _G.AdaptAntiDesync.hittingCooldown then return end
    _G.AdaptAntiDesync.hittingCooldown = true

    pcall(function()
        local bat = _G.AdaptAntiDesyncGetBat()
        if not bat then return end

        bat:Activate()
        local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
        if ev then ev:FireServer() end
    end)

    task.delay(0.08, function()
        if _G.AdaptAntiDesync then
            _G.AdaptAntiDesync.hittingCooldown = false
        end
    end)
end

function _G.AdaptAntiDesyncGetClosestPlayer()
    local hrp = _G.AdaptAntiDesync and _G.AdaptAntiDesync.hrp
    if not hrp then return nil end

    local closest, bestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist < bestDist then
                    bestDist = dist
                    closest = player
                end
            end
        end
    end

    return closest, bestDist
end

function _G.AdaptAntiDesyncSetupChar(char)
    task.wait(0.2)
    if not _G.AdaptAntiDesync then return end
    _G.AdaptAntiDesync.h = char and char:FindFirstChildOfClass("Humanoid") or nil
    _G.AdaptAntiDesync.hrp = char and char:FindFirstChild("HumanoidRootPart") or nil

    if _G.AdaptAntiDesyncAimbotOn and not _G.AdaptAntiDesync.conn then
        _G.AdaptStartAntiDesyncAimbot()
    end
end

LP.CharacterAdded:Connect(function(char)
    pcall(function() _G.AdaptAntiDesyncSetupChar(char) end)
end)

if LP.Character then
    task.spawn(function()
        pcall(function() _G.AdaptAntiDesyncSetupChar(LP.Character) end)
    end)
end

function _G.AdaptStartAntiDesyncAimbot()
    if _G.AdaptSafeModeTryStart and not _G.AdaptSafeModeTryStart() then
        return false
    end

    if _G.AdaptAntiDesync.conn then
        _G.AdaptAntiDesync.conn:Disconnect()
        _G.AdaptAntiDesync.conn = nil
    end

    _G.AdaptAntiDesyncAimbotOn = true

    local char = LP.Character
    if char then
        _G.AdaptAntiDesync.h = char:FindFirstChildOfClass("Humanoid")
        _G.AdaptAntiDesync.hrp = char:FindFirstChild("HumanoidRootPart")
    end

    _G.AdaptAntiDesync.conn = RunService.Heartbeat:Connect(function()
        if not _G.AdaptAntiDesyncAimbotOn then return end

        if not _G.AdaptAntiDesync.h or not _G.AdaptAntiDesync.hrp then
            local currentChar = LP.Character
            if not currentChar then return end
            _G.AdaptAntiDesync.h = currentChar:FindFirstChildOfClass("Humanoid")
            _G.AdaptAntiDesync.hrp = currentChar:FindFirstChild("HumanoidRootPart")
            if not _G.AdaptAntiDesync.h or not _G.AdaptAntiDesync.hrp then return end
        end

        local target = _G.AdaptAntiDesyncGetClosestPlayer()
        _aimbotTargetPlr = target
        _G.AdaptCurrentAimbotTarget = target
        _G.AdaptAntiDesyncBatTarget = target

        if not target or not target.Character then return end

        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        if not targetRoot then return end

        --Leaked By Xlu0 AndPrime--
        if sethiddenproperty then
            pcall(sethiddenproperty, _G.AdaptAntiDesync.hrp, "PhysicsRepRootPart", targetRoot)
        end

        --Leaked By Xlu0 AndPrime--
        local targetPos = targetRoot.Position + Vector3.new(0, 0.9, 0)
        if (_G.AdaptAntiDesync.hrp.Position - targetPos).Magnitude > 8 then
            _G.AdaptAntiDesync.hrp.CFrame = CFrame.new(targetPos)
        end

        --Leaked By Xlu0 AndPrime--
        local cam = workspace.CurrentCamera
        if cam then
            cam.CFrame = CFrame.new(cam.CFrame.Position, targetRoot.Position)
        end

        --Leaked By Xlu0 AndPrime--
        _G.AdaptAntiDesyncTrySwing()
    end)

    if _G.AdaptAntiDesyncSetVisual then
        _G.AdaptAntiDesyncSetVisual(true)
    end

    return true
end

function _G.AdaptStopAntiDesyncAimbot()
    _G.AdaptAntiDesyncAimbotOn = false

    if _G.AdaptAntiDesync and _G.AdaptAntiDesync.conn then
        _G.AdaptAntiDesync.conn:Disconnect()
        _G.AdaptAntiDesync.conn = nil
    end

    if _G.AdaptAntiDesync then
        _G.AdaptAntiDesync.hittingCooldown = false
    end

    _G.AdaptAntiDesyncBatTarget = nil
    if _G.AdaptCurrentAimbotTarget == _aimbotTargetPlr then
        _G.AdaptCurrentAimbotTarget = nil
    end
    _aimbotTargetPlr = nil

    if _G.AdaptAntiDesyncSetVisual then
        _G.AdaptAntiDesyncSetVisual(false)
    end
end

function _G.AdaptToggleAntiDesyncAimbot()
    if _G.AdaptAntiDesyncAimbotOn then
        _G.AdaptStopAntiDesyncAimbot()
    else
        _G.AdaptStartAntiDesyncAimbot()
    end
end

_G.__AdaptSetupNormalAutoSteal = function()
local getconnections_v3 = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)
_G.AdaptGalaxyV3 = _G.AdaptGalaxyV3 or {
conn=nil, active=false, progress=0, paused=false, pauseTime=nil,
startTime=nil, progressConn=nil, dataCache={}, enabled=false,
StealRadius=63, StealDuration=1.3, TriggerRadius=10
}
local GS = _G.AdaptGalaxyV3

local function getHRP()
local c=LP.Character
return c and c:FindFirstChild("HumanoidRootPart")
end

local function isMyPlot(plotName)
local plots=workspace:FindFirstChild("Plots")
if not plots then return false end
local plot=plots:FindFirstChild(plotName)
if not plot then return false end
local sign=plot:FindFirstChild("PlotSign")
if sign then
local yb=sign:FindFirstChild("YourBase")
if yb and yb:IsA("BillboardGui") then return yb.Enabled==true end
end
return false
end

local function findPrompt()
local hrp=getHRP()
if not hrp then return nil,nil end
local plots=workspace:FindFirstChild("Plots")
if not plots then return nil,nil end
local bestPrompt,bestDist,bestSpawn=nil,math.huge,nil

for _,plot in ipairs(plots:GetChildren()) do
if not plot:IsA("Model") then continue end
if isMyPlot(plot.Name) then continue end
local pods=plot:FindFirstChild("AnimalPodiums")
if not pods then continue end

for _,pod in ipairs(pods:GetChildren()) do
pcall(function()
local base=pod:FindFirstChild("Base")
local spawn=base and base:FindFirstChild("Spawn")
if not spawn then return end
local dist=(spawn.Position-hrp.Position).Magnitude
if dist>=bestDist or dist>GS.StealRadius then return end

local function tryPrompt(container)
for _,ch in ipairs(container:GetChildren()) do
if ch:IsA("ProximityPrompt") and ch.Enabled then
bestPrompt=ch
bestDist=dist
bestSpawn=spawn
return true
end
end
end

local att=spawn:FindFirstChild("PromptAttachment")
if not (att and tryPrompt(att)) then
for _,ch in ipairs(spawn:GetDescendants()) do
if ch:IsA("ProximityPrompt") and ch.Enabled then
bestPrompt=ch
bestDist=dist
bestSpawn=spawn
break
end
end
end
end)
end
end
return bestPrompt,bestSpawn
end

local function distToSpawn(spawnPart)
local hrp=getHRP()
if not hrp then return math.huge end
if not spawnPart or not spawnPart.Parent then
local _,ns=findPrompt()
return ns and (hrp.Position-ns.Position).Magnitude or math.huge
end
return (hrp.Position-spawnPart.Position).Magnitude
end

local function updateBar(p,state)
if _G.StealBar then
pcall(function()
_G.StealBar.SetProgress(p or 0)
if state then _G.StealBar.SetState(state) end
end)
end
end

local function execute(prompt,spawnPart)
if GS.active then return end

if not GS.dataCache[prompt] then
local data={hold={},trigger={},ready=true}
if getconnections_v3 then
pcall(function()
for _,c in ipairs(getconnections_v3(prompt.PromptButtonHoldBegan)) do
if c.Function then table.insert(data.hold,c.Function) end
end
for _,c in ipairs(getconnections_v3(prompt.Triggered)) do
if c.Function then table.insert(data.trigger,c.Function) end
end
end)
end
GS.dataCache[prompt]=data
end

local data=GS.dataCache[prompt]
if not data.ready then return end

data.ready=false
GS.active=true
GS.paused=false
GS.startTime=tick()-(GS.progress*GS.StealDuration)
local pauseArmed=true

if GS.progressConn then GS.progressConn:Disconnect() end
updateBar(GS.progress,"STEALING")

GS.progressConn=RunService.Heartbeat:Connect(function()
if not GS.active then
if GS.progressConn then GS.progressConn:Disconnect();GS.progressConn=nil end
return
end

if not GS.enabled or not autoStealEnabled or selectedStealMode~="Auto Steal V3" then
GS.active=false
GS.progress=0
GS.paused=false
data.ready=true
updateBar(0,autoStealEnabled and "READY" or "IDLE")
return
end

if GS.paused then
local dist=distToSpawn(spawnPart)
if dist<=GS.TriggerRadius then
GS.paused=false
GS.pauseTime=nil
GS.startTime=tick()-(0.8*GS.StealDuration)
else
if not GS.pauseTime then
GS.pauseTime=tick()
elseif tick()-GS.pauseTime>=1.3 then
GS.pauseTime=nil
GS.paused=false
GS.active=false
GS.progress=0
data.ready=true
pauseArmed=true
if GS.progressConn then GS.progressConn:Disconnect();GS.progressConn=nil end
updateBar(0,autoStealEnabled and "READY" or "IDLE")
return
end
GS.progress=0.8
updateBar(0.8,"STEALING")
return
end
end

local elapsed=tick()-GS.startTime
local prog=math.clamp(elapsed/GS.StealDuration,0,1)
GS.progress=prog

if pauseArmed and prog>=0.8 then
GS.paused=true
pauseArmed=false
GS.progress=0.8
updateBar(0.8,"STEALING")
return
end

updateBar(prog,"STEALING")

if prog>=1 then
GS.active=false
GS.progress=0
GS.paused=false
pauseArmed=true
if GS.progressConn then GS.progressConn:Disconnect();GS.progressConn=nil end

for _,fn in ipairs(data.trigger) do
task.spawn(function() pcall(fn) end)
end

data.ready=true
updateBar(0,autoStealEnabled and "READY" or "IDLE")
end
end)

for _,fn in ipairs(data.hold) do
task.spawn(function() pcall(fn) end)
end
end

_G.AdaptNormalAutoStealSetRadius=function(v)
GS.StealRadius=tonumber(v) or GS.StealRadius or 63
end

_G.AdaptNormalAutoStealStart=function()
if GS.conn then GS.conn:Disconnect();GS.conn=nil end
GS.enabled=true
GS.StealRadius=tonumber(autoStealRadius) or 63
GS.StealDuration=1.3
GS.TriggerRadius=10
GS.conn=RunService.Heartbeat:Connect(function()
if not GS.enabled or GS.active then return end
if not autoStealEnabled or selectedStealMode~="Auto Steal V3" then return end
local prompt,spawnPart=findPrompt()
if prompt then execute(prompt,spawnPart) end
end)
updateBar(0,"READY")
end

_G.AdaptNormalAutoStealStop=function()
GS.enabled=false
if GS.conn then GS.conn:Disconnect();GS.conn=nil end
if GS.progressConn then GS.progressConn:Disconnect();GS.progressConn=nil end
GS.active=false
GS.progress=0
GS.paused=false
GS.pauseTime=nil
GS.dataCache={}
updateBar(0,autoStealEnabled and "READY" or "IDLE")
end

_G.AdaptNormalAutoStealSync=function()
if autoStealEnabled and selectedStealMode=="Auto Steal V3" then
_G.AdaptNormalAutoStealStart()
else
_G.AdaptNormalAutoStealStop()
end
end
end
_G.__AdaptSetupNormalAutoSteal()
_G.__AdaptSetupSemiAutoSteal = function()
local A = _G.AdaptSemiSteal
if not A then
A = {
enabled = false,
conn = nil,
scanThread = nil,
syncReady = false,
plots = nil,
animalsData = {},
syncRemotes = nil,
plotSync = {caches = {}, connections = {}},
animals = {},
promptCache = {},
internalCache = {},
radius = 9,
primeRange = 80,
holdMin = 1.3,
holdMax = 2.6,
entryDelay = 0.3,
cooldown = 0.05,
state = {
active = false,
startTime = 0,
phase = "idle",
label = "",
lastResult = "",
lastResultTime = 0,
totalSteals = 0,
failedSteals = 0,
},
}
_G.AdaptSemiSteal = A
end
local function rootPart()
local char = LP.Character
return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
end
local function barSet(pct, status)
pct = math.clamp(pct or 0, 0, 1)
--Leaked By Xlu0 AndPrime--
--Leaked By Xlu0 AndPrime--
if _G.StealBar then
    _G.StealBar.SetProgress(pct)
    _G.StealBar.SetState(status or "STEALING")
end
end
local function barReset()
if _G.StealBar then
    _G.StealBar.SetProgress(0)
    _G.StealBar.SetState(autoStealEnabled and "READY" or "IDLE")
end
end
local function splitSyncPath(path)
if typeof(path) == "table" then return path end
local out = {}
for part in string.gmatch(tostring(path), "[^%.]+") do table.insert(out, tonumber(part) or part) end
return out
end
local function resolveSyncPath(path, root)
local current, parent, key = root, nil, nil
for _, part in ipairs(splitSyncPath(path)) do
parent, key = current, part
current = current and current[part] or nil
end
return current, parent, key
end
local function applyPlotSyncDiff(channelName, packet)
local cache = A.plotSync.caches[channelName]
if typeof(cache) ~= "table" then return end
local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
local current, parent, key = resolveSyncPath(path, cache)
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
local function attachPlotChannel(remote)
if not A.syncRemotes or A.plotSync.connections[remote] then return end
local channelName = tostring(remote.Name)
if not A.plots:FindFirstChild(channelName) then return end
if A.syncRemotes.requestData and A.plotSync.caches[channelName] == nil then
local ok, data = pcall(function() return A.syncRemotes.requestData:InvokeServer(channelName) end)
A.plotSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
elseif A.plotSync.caches[channelName] == nil then
A.plotSync.caches[channelName] = {}
end
A.plotSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
for _, packet in ipairs(queue) do applyPlotSyncDiff(channelName, packet) end
end)
end
local function ensureSync()
if A.syncReady then return true end
local ok = pcall(function()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
A.plots = workspace:WaitForChild("Plots")
local Packages = ReplicatedStorage:WaitForChild("Packages", 10)
local Datas = ReplicatedStorage:WaitForChild("Datas", 10)
if not Packages or not Datas then return end
A.animalsData = require(Datas:WaitForChild("Animals"))
local folder = Packages:WaitForChild("Synchronizer")
A.syncRemotes = {
channelFolder = folder:WaitForChild("Channel"),
routeRemote = folder:WaitForChild("CommunicationRoute"),
requestData = folder:FindFirstChild("RequestData"),
}
for _, child in ipairs(A.syncRemotes.channelFolder:GetChildren()) do
if child:IsA("RemoteEvent") then attachPlotChannel(child) end
end
A.syncRemotes.channelFolder.ChildAdded:Connect(function(child)
if child:IsA("RemoteEvent") then attachPlotChannel(child) end
end)
A.syncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
for _, actionData in ipairs(actions) do
local kind, channelName = actionData[1], tostring(actionData[2])
if A.plots:FindFirstChild(channelName) then
if kind == "ListenerAdded" then
local remote = A.syncRemotes.channelFolder:FindFirstChild(channelName)
if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote) end
elseif kind == "ListenerRemoved" then
for remote, conn in pairs(A.plotSync.connections) do
if tostring(remote.Name) == channelName then
conn:Disconnect()
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
return owner == LP.DisplayName or owner == LP.Name
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
local function scanAllPlots()
if not ensureSync() then return 0 end
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
local function buildStealCallbacks(prompt)
if A.internalCache[prompt] then return end
local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
local ok1, conns1 = false, nil
if getconnections then ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan) end
if ok1 and type(conns1) == "table" then
for _, conn in ipairs(conns1) do
if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end
end
end
local ok2, conns2 = false, nil
if getconnections then ok2, conns2 = pcall(getconnections, prompt.Triggered) end
if ok2 and type(conns2) == "table" then
for _, conn in ipairs(conns2) do
if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end
end
end
if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then A.internalCache[prompt] = data end
end
local function executeCandySemi(prompt, animalData)
if not prompt or not prompt.Parent or not animalData then return false end
buildStealCallbacks(prompt)
local data = A.internalCache[prompt]
if not data or not data.ready then return false end
data.ready = false
local label = animalData.name or "Animal"
A.state.active = true
A.state.startTime = tick()
A.state.phase = "holding"
A.state.label = label
task.spawn(function()
for _, fn in ipairs(data.holdCallbacks) do task.spawn(function() pcall(fn) end) end
local holdStart = A.state.startTime
while A.enabled and selectedStealMode == "Semi" and tick() - holdStart < (A.holdMin or 1.3) do
barSet((tick() - holdStart) / (A.holdMax or 2.6), "STEALING")
task.wait()
end
A.state.phase = "waitingRange"
local alreadyInRange = distToAnimal(animalData) <= (tonumber(A.radius) or 9)
local fired = false
while A.enabled and selectedStealMode == "Semi" do
local elapsed = tick() - A.state.startTime
if elapsed > (A.holdMax or 2.6) or not prompt.Parent then break end
barSet(elapsed / (A.holdMax or 2.6), "WAITING RANGE")
if distToAnimal(animalData) <= (tonumber(A.radius) or 9) then
if not alreadyInRange then task.wait(A.entryDelay or 0.3) end
if A.enabled and selectedStealMode == "Semi" then
for _, fn in ipairs(data.triggerCallbacks) do task.spawn(function() pcall(fn) end) end
pcall(function() if _G.AutoCarrySpeed and _G.AutoCarrySpeed.WatchPickup then _G.AutoCarrySpeed.WatchPickup(1.25) end end)
fired = true
end
break
end
task.wait()
end
if fired then
A.state.totalSteals = (A.state.totalSteals or 0) + 1
A.state.lastResult = "Stole " .. label
A.state.phase = "success"
barSet(1, "SUCCESS")
else
A.state.failedSteals = (A.state.failedSteals or 0) + 1
A.state.lastResult = "Missed window: " .. label
A.state.phase = "failed"
barSet(1, "FAILED")
end
A.state.active = false
A.state.lastResultTime = tick()
task.wait(A.cooldown or 0.05)
data.ready = true
task.delay(0.8, function()
if not A.state.active then barReset() end
end)
end)
return true
end
local function ensureScanThread()
if A.scanThread then return end
A.scanThread = task.spawn(function()
while _G.AdaptSemiSteal do
if A.enabled or selectedStealMode == "Semi" then pcall(scanAllPlots) end
task.wait(5)
end
end)
end
_G.AdaptSemiAutoStealSetRadius = function(v)
local n = tonumber(v)
if n then A.radius = n end
end
_G.AdaptSemiAutoStealStop = function()
A.enabled = false
if A.conn then A.conn:Disconnect(); A.conn = nil end
A.state.active = false
A.state.phase = "idle"
barReset()
end
_G.AdaptSemiAutoStealStart = function()
A.radius = tonumber(autoStealRadius) or A.radius or 9
A.enabled = true
if not ensureSync() then return end
ensureScanThread()
pcall(scanAllPlots)
if A.conn then A.conn:Disconnect(); A.conn = nil end
A.conn = RunService.Heartbeat:Connect(function()
if not A.enabled then return end
if selectedStealMode ~= "Semi" then _G.AdaptSemiAutoStealStop(); return end
if A.state.active then return end
local target = pickClosest()
if not target then return end
local prompt = A.promptCache[target.uid]
if not prompt or not prompt.Parent then prompt = findPromptForAnimal(target) end
if prompt then executeCandySemi(prompt, target) end
end)
end
_G.AdaptSemiAutoStealSync = function()
if selectedStealMode == "Semi" and autoStealEnabled then
_G.AdaptSemiAutoStealStart()
else
_G.AdaptSemiAutoStealStop()
end
end
end
_G.__AdaptSetupSemiAutoSteal()
_G.AdaptAutoStealSync = function()
if not autoStealEnabled then
if _G.AdaptNormalAutoStealStop then _G.AdaptNormalAutoStealStop() end
if _G.AdaptSemiAutoStealStop then _G.AdaptSemiAutoStealStop() end
return
end
if selectedStealMode == "Auto Steal V3" then
if _G.AdaptSemiAutoStealStop then _G.AdaptSemiAutoStealStop() end
if _G.AdaptNormalAutoStealSync then _G.AdaptNormalAutoStealSync() end
elseif selectedStealMode == "Semi" then
if _G.AdaptNormalAutoStealStop then _G.AdaptNormalAutoStealStop() end
if _G.AdaptSemiAutoStealSync then _G.AdaptSemiAutoStealSync() end
end
end
task.spawn(function()
while task.wait(30) do
do end
end
end)
local lastMoveDir = Vector3.new(0, 0, 0)
local function getCurrentSpeedValue()
if currentSpeedMode == "Carry" then
return CS
elseif currentSpeedMode == "Lagger" then
return LAGGER_SPEED
elseif currentSpeedMode == "Lagger Carry" then
return LAGGER_CARRY_SPEED
end
return NS
end
local refreshSpeedModeRows = nil
local function setSpeedMode(mode)
if mode ~= "Normal" and mode ~= "Carry" and mode ~= "Lagger" and mode ~= "Lagger Carry" then
mode = "Normal"
end
currentSpeedMode = mode
if refreshSpeedModeRows then
refreshSpeedModeRows()
end
do end
end
local function toggleCarryMode()
if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
setSpeedMode("Carry")
elseif currentSpeedMode == "Carry" then
setSpeedMode("Normal")
else
setSpeedMode("Carry")
end
end
local function toggleLaggerMode()
if currentSpeedMode ~= "Lagger" and currentSpeedMode ~= "Lagger Carry" then
setSpeedMode("Lagger Carry")
elseif currentSpeedMode == "Lagger Carry" then
setSpeedMode("Lagger")
else
setSpeedMode("Lagger Carry")
end
end
State = State or {}
State.normalSpeed = NS
State.carrySpeed = CS
State.laggerSpeed = LAGGER_SPEED
State.speedToggled = (currentSpeedMode == "Carry" or currentSpeedMode == "Lagger Carry")
State.laggerEnabled = (currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry")
toggleRefs = toggleRefs or {}
function setCarry(on)
if on then
setSpeedMode("Carry")
else
if currentSpeedMode == "Carry" or currentSpeedMode == "Lagger Carry" then
setSpeedMode("Normal")
end
end
State.speedToggled = on == true
end
function setLagger(on)
if on then
setSpeedMode("Lagger")
else
if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
setSpeedMode("Normal")
end
end
State.laggerEnabled = on == true
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
State = State or {}
State.normalSpeed = State.normalSpeed or 59
State.carrySpeed = State.carrySpeed or 30
State.laggerSpeed = State.laggerSpeed or 60
State.speedToggled = State.speedToggled or false
State.laggerEnabled = State.laggerEnabled or false
State._autoCarryFromSteal = State._autoCarryFromSteal or false
State._autoCarryGraceUntil = State._autoCarryGraceUntil or 0
State._waitingForCarryPickup = State._waitingForCarryPickup or false
State._carryPickupWatchUntil = State._carryPickupWatchUntil or 0
State._autoCarryReturnMode = State._autoCarryReturnMode or nil
toggleRefs = toggleRefs or {}
local function safeSaveConfig()
if type(saveConfig) == "function" then
task.spawn(saveConfig)
end
end
local function isCarryName(name)
local n = tostring(name or ""):lower()
return n:find("brainrot")
or n:find("animal")
or n:find("carry")
or n:find("grab")
or n:find("steal")
or n:find("hold")
end
local function isIgnoredCarryTool(name)
local n = tostring(name or ""):lower()
return n:find("bat")
or n:find("slap")
or n:find("medusa")
or n:find("head")
or n:find("stone")
end
local function isCarryingBrainrot(char)
if not char then return false end
for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
local v = char:FindFirstChild(name, true)
if v then
if v:IsA("BoolValue") and v.Value then
return true
end
if v:IsA("ObjectValue") and v.Value then
return true
end
if v:IsA("StringValue") and v.Value ~= "" then
return true
end
end
end
for _, child in ipairs(char:GetChildren()) do
if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
if child:FindFirstChildOfClass("Humanoid") and child:FindFirstChild("HumanoidRootPart") then
return true
end
if isCarryName(child.Name) then
return true
end
elseif child:IsA("Tool") and not isIgnoredCarryTool(child.Name) then
return true
end
end
return false
end
local function setCarrySpeedMode(on)
State.speedToggled = on
if toggleRefs.carryMode then
toggleRefs.carryMode(on)
end
if type(setCarry) == "function" then
setCarry(on)
end
end
local function setLaggerMode(on)
State.laggerEnabled = on
if toggleRefs.laggerMode then
toggleRefs.laggerMode(on)
end
if type(setLagger) == "function" then
setLagger(on)
end
end
local function enableCarrySpeedForSteal()
State._waitingForCarryPickup = false
State._carryPickupWatchUntil = 0
if not State._autoCarryFromSteal then
State._autoCarryReturnMode = currentSpeedMode
end
State._autoCarryFromSteal = true
State._autoCarryGraceUntil = tick() + 0.75
local wasLagger = (State._autoCarryReturnMode == "Lagger" or State._autoCarryReturnMode == "Lagger Carry"
or currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry")
if wasLagger then
State.laggerEnabled = true
State.speedToggled = true
if toggleRefs.laggerMode then toggleRefs.laggerMode(true) end
if toggleRefs.carryMode then toggleRefs.carryMode(true) end
setSpeedMode("Lagger Carry")
else
setLaggerMode(false)
setCarrySpeedMode(true)
end
safeSaveConfig()
end
local function disableAutoCarrySpeed()
if not State._autoCarryFromSteal and not State._waitingForCarryPickup then return end
local wasAutoApplied = State._autoCarryFromSteal == true
local returnMode = State._autoCarryReturnMode
State._autoCarryFromSteal = false
State._waitingForCarryPickup = false
State._autoCarryGraceUntil = 0
State._carryPickupWatchUntil = 0
State._autoCarryReturnMode = nil
if not wasAutoApplied then
return
end
if returnMode == "Lagger" or returnMode == "Lagger Carry" then
State.laggerEnabled = true
State.speedToggled = false
if toggleRefs.laggerMode then toggleRefs.laggerMode(true) end
if toggleRefs.carryMode then toggleRefs.carryMode(false) end
setSpeedMode("Lagger")
elseif returnMode == "Carry" then
State.laggerEnabled = false
State.speedToggled = true
if toggleRefs.laggerMode then toggleRefs.laggerMode(false) end
if toggleRefs.carryMode then toggleRefs.carryMode(true) end
setSpeedMode("Carry")
else
setLaggerMode(false)
setCarrySpeedMode(false)
end
safeSaveConfig()
end
local function startAutoCarryPickupWatch(seconds)
if autoCarrySpeedEnabled ~= true then return end
State._waitingForCarryPickup = true
State._carryPickupWatchUntil = tick() + (seconds or 1.25)
end
local _stealAttrWasActive = false
RunService.RenderStepped:Connect(function()
if autoCarrySpeedEnabled ~= true then
disableAutoCarrySpeed()
return
end
local char = LP.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
local root = char and char:FindFirstChild("HumanoidRootPart")
if not char or not hum or not root then
disableAutoCarrySpeed()
_stealAttrWasActive = false
return
end
local st = hum:GetState()
local gotHit = st == Enum.HumanoidStateType.Physics
or st == Enum.HumanoidStateType.Ragdoll
or st == Enum.HumanoidStateType.FallingDown
local stealingAttr = LP:GetAttribute("Stealing") == true
local carryingBrainrot = isCarryingBrainrot(char)
if stealingAttr and not _stealAttrWasActive then
_stealAttrWasActive = true
enableCarrySpeedForSteal()
elseif not stealingAttr then
_stealAttrWasActive = false
end
if State._waitingForCarryPickup then
if gotHit or tick() > (State._carryPickupWatchUntil or 0) then
State._waitingForCarryPickup = false
State._carryPickupWatchUntil = 0
elseif carryingBrainrot then
enableCarrySpeedForSteal()
end
end
if carryingBrainrot and not State._autoCarryFromSteal then
enableCarrySpeedForSteal()
end
if State._autoCarryFromSteal then
local graceDone = tick() > (State._autoCarryGraceUntil or 0)
if gotHit or (graceDone and not carryingBrainrot and not stealingAttr) then
disableAutoCarrySpeed()
end
end
end)
_G.AutoCarrySpeed = {
IsCarryingBrainrot = isCarryingBrainrot,
Enable = enableCarrySpeedForSteal,
Disable = disableAutoCarrySpeed,
WatchPickup = startAutoCarryPickupWatch,
}
_G.AdaptAutoPathState = _G.AdaptAutoPathState or {leftConn=nil,rightConn=nil,leftPhase=1,rightPhase=1}
_G.AdaptAutoPathPoints = _G.AdaptAutoPathPoints or {
L1=Vector3.new(-476.48,-6.28,92.73), L2=Vector3.new(-483.12,-4.95,94.80), LFace=Vector3.new(-482.25,-4.96,92.09),
R1=Vector3.new(-476.16,-6.52,25.62), R2=Vector3.new(-483.06,-5.03,25.48), RFace=Vector3.new(-482.06,-6.93,35.47),
}
function _G.AdaptAutoPathSpeed()
if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
return LAGGER_SPEED
end
return NS
end
function _G.AdaptStopAutoLeft()
local S=_G.AdaptAutoPathState
if S.leftConn then S.leftConn:Disconnect(); S.leftConn=nil end
S.leftPhase=1
local char=LP.Character
local hum=char and char:FindFirstChildOfClass("Humanoid")
local hrp=char and char:FindFirstChild("HumanoidRootPart")
if hum then hum:Move(Vector3.zero,false) end
if hrp then hrp.AssemblyLinearVelocity=Vector3.new(0,hrp.AssemblyLinearVelocity.Y,0) end
end
function _G.AdaptStopAutoRight()
local S=_G.AdaptAutoPathState
if S.rightConn then S.rightConn:Disconnect(); S.rightConn=nil end
S.rightPhase=1
local char=LP.Character
local hum=char and char:FindFirstChildOfClass("Humanoid")
local hrp=char and char:FindFirstChild("HumanoidRootPart")
if hum then hum:Move(Vector3.zero,false) end
if hrp then hrp.AssemblyLinearVelocity=Vector3.new(0,hrp.AssemblyLinearVelocity.Y,0) end
end
function _G.AdaptSetAutoLeft(on, skipSave)
if on and _G.AdaptSafeModeTryStart and not _G.AdaptSafeModeTryStart() then
autoLeftEnabled = false
if _G.AdaptSetAutoLeftVisual then _G.AdaptSetAutoLeftVisual(false) end
if not skipSave then do end end
return false
end
autoLeftEnabled = on and true or false
if _G.AdaptSetAutoLeftVisual then _G.AdaptSetAutoLeftVisual(autoLeftEnabled) end
if autoLeftEnabled then
autoRightEnabled=false
if _G.AdaptSetAutoRightVisual then _G.AdaptSetAutoRightVisual(false) end
if _G.AdaptStopAutoRight then _G.AdaptStopAutoRight() end
if _G.AdaptStartAutoLeft then _G.AdaptStartAutoLeft() end
else
if _G.AdaptStopAutoLeft then _G.AdaptStopAutoLeft() end
end
if not skipSave then do end end
end
function _G.AdaptSetAutoRight(on, skipSave)
if on and _G.AdaptSafeModeTryStart and not _G.AdaptSafeModeTryStart() then
autoRightEnabled = false
if _G.AdaptSetAutoRightVisual then _G.AdaptSetAutoRightVisual(false) end
if not skipSave then do end end
return false
end
autoRightEnabled = on and true or false
if _G.AdaptSetAutoRightVisual then _G.AdaptSetAutoRightVisual(autoRightEnabled) end
if autoRightEnabled then
autoLeftEnabled=false
if _G.AdaptSetAutoLeftVisual then _G.AdaptSetAutoLeftVisual(false) end
if _G.AdaptStopAutoLeft then _G.AdaptStopAutoLeft() end
if _G.AdaptStartAutoRight then _G.AdaptStartAutoRight() end
else
if _G.AdaptStopAutoRight then _G.AdaptStopAutoRight() end
end
if not skipSave then do end end
end

--Leaked By Xlu0 AndPrime--
_G.AdaptZombieMove = _G.AdaptZombieMove or {
    leftConn = nil,
    rightConn = nil,
    leftPhase = 1,
    rightPhase = 1,
    attachment = nil,
    linearVelocity = nil,
}

_G.AdaptAutoMoveSpeed = tonumber(_G.AdaptAutoMoveSpeed) or 60
_G.AdaptAutoMoveCarrySpeed = tonumber(_G.AdaptAutoMoveCarrySpeed) or 30
_G.AdaptDuelMode = (_G.AdaptDuelMode == "full") and "full" or "half"

_G.AdaptZombieMovePoints = _G.AdaptZombieMovePoints or {
    L1 = Vector3.new(-476.48, -6.28, 92.73),
    L2 = Vector3.new(-483.12, -4.95, 94.80),
    LFace = Vector3.new(-482.25, -4.96, 92.09),

    R1 = Vector3.new(-476.16, -6.52, 25.62),
    R2 = Vector3.new(-483.06, -5.03, 25.48),
    RFace = Vector3.new(-482.06, -6.93, 35.47),

    FullLeft = {
        Vector3.new(-474.0, -7.3, 90.2),
        Vector3.new(-484.9, -5.1, 97.2),
        Vector3.new(-473.6, -7.3, 93.5),
        Vector3.new(-473.0, -7.3, 27.6),
        Vector3.new(-487.2, -5.3, 20.9),
    },

    FullRight = {
        Vector3.new(-472.5, -7.3, 30.9),
        Vector3.new(-483.8, -5.4, 25.5),
        Vector3.new(-472.4, -7.3, 30.5),
        Vector3.new(-472.0, -7.3, 93.6),
        Vector3.new(-482.8, -5.4, 97.8),
    }
}

function _G.AdaptZombieEnsureLinearVelocity(hrp)
    local S = _G.AdaptZombieMove

    if S.linearVelocity and S.linearVelocity.Parent and S.attachment and S.attachment.Parent == hrp then
        return S.linearVelocity
    end

    if S.linearVelocity then
        pcall(function() S.linearVelocity:Destroy() end)
    end
    if S.attachment then
        pcall(function() S.attachment:Destroy() end)
    end

    local att = Instance.new("Attachment")
    att.Name = "AdaptZombieMoveAttachment"
    att.Parent = hrp

    local lv = Instance.new("LinearVelocity")
    lv.Name = "AdaptZombieMoveVelocity"
    lv.Attachment0 = att
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.ForceLimitMode = Enum.ForceLimitMode.PerAxis
    lv.MaxAxesForce = Vector3.new(math.huge, 0, math.huge)
    lv.VectorVelocity = Vector3.zero
    lv.Parent = att

    S.attachment = att
    S.linearVelocity = lv
    return lv
end

function _G.AdaptZombieStopVelocity()
    local S = _G.AdaptZombieMove
    if S.linearVelocity and S.linearVelocity.Parent then
        S.linearVelocity.VectorVelocity = Vector3.zero
        S.linearVelocity.MaxAxesForce = Vector3.zero
        S.linearVelocity.Enabled = false
    end
end

function _G.AdaptStopAutoLeft()
    local S = _G.AdaptZombieMove
    if S.leftConn then
        S.leftConn:Disconnect()
        S.leftConn = nil
    end
    S.leftPhase = 1

    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum:Move(Vector3.zero, false) end
    _G.AdaptZombieStopVelocity()

    if _G.AdaptSetAutoLeftVisual then
        pcall(function() _G.AdaptSetAutoLeftVisual(false) end)
    end
end

function _G.AdaptStopAutoRight()
    local S = _G.AdaptZombieMove
    if S.rightConn then
        S.rightConn:Disconnect()
        S.rightConn = nil
    end
    S.rightPhase = 1

    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum:Move(Vector3.zero, false) end
    _G.AdaptZombieStopVelocity()

    if _G.AdaptSetAutoRightVisual then
        pcall(function() _G.AdaptSetAutoRightVisual(false) end)
    end
end

function _G.AdaptZombieMoveIsFull()
    return (_G.AdaptDuelMode == "full")
        or (_G.AdaptDuelMode == "Full")
        or (typeof(State) == "table" and State.duelMode == "full")
end

function _G.AdaptStartAutoLeft()
    if autoRightEnabled then
        autoRightEnabled = false
        _G.AdaptStopAutoRight()
    end

    local S = _G.AdaptZombieMove
    if S.leftConn then S.leftConn:Disconnect() end
    S.leftPhase = 1

    S.leftConn = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        if dropBrainrotActive then return end

        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end

        local st = hum:GetState()
        if hum.PlatformStand
            or st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown then
            hum:Move(Vector3.zero, false)
            _G.AdaptZombieStopVelocity()
            return
        end

        local lv = _G.AdaptZombieEnsureLinearVelocity(hrp)
        lv.Enabled = true
        lv.MaxAxesForce = Vector3.new(math.huge, 0, math.huge)
        local P = _G.AdaptZombieMovePoints
        local spd = tonumber(_G.AdaptAutoMoveSpeed) or NS or 60

        if _G.AdaptZombieMoveIsFull() then
            local points = P.FullLeft
            if S.leftPhase > #points then
                _G.AdaptZombieStopVelocity()
                local prev = points[#points - 1] or points[#points]
                hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(prev.X, hrp.Position.Y, prev.Z))
                hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                hum:Move(Vector3.zero, false)
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                autoLeftEnabled = false
                if S.leftConn then S.leftConn:Disconnect(); S.leftConn = nil end
                S.leftPhase = 1
                if _G.AdaptSetAutoLeftVisual then _G.AdaptSetAutoLeftVisual(false) end
                return
            end

            local tgt = points[S.leftPhase]
            local flat = Vector3.new(tgt.X, hrp.Position.Y, tgt.Z)
            if (flat - hrp.Position).Magnitude < 1 then
                S.leftPhase += 1
                return
            end

            local dir = (flat - hrp.Position).Unit
            local fspd = (S.leftPhase <= 2)
                and (tonumber(_G.AdaptAutoMoveSpeed) or 60)
                or (tonumber(_G.AdaptAutoMoveCarrySpeed) or 30)

            lv.VectorVelocity = Vector3.new(dir.X * fspd, 0, dir.Z * fspd)
        else
            if S.leftPhase == 1 then
                local tgt = Vector3.new(P.L1.X, hrp.Position.Y, P.L1.Z)
                if (tgt - hrp.Position).Magnitude < 1 then
                    S.leftPhase = 2
                    return
                end

                local d = P.L1 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                lv.VectorVelocity = Vector3.new(mv.X * spd, 0, mv.Z * spd)
            else
                local tgt = Vector3.new(P.L2.X, hrp.Position.Y, P.L2.Z)
                if (tgt - hrp.Position).Magnitude < 1 then
                    hum:Move(Vector3.zero, false)
                    _G.AdaptZombieStopVelocity()
                    hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                    hum:Move(Vector3.zero, false)
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                    autoLeftEnabled = false
                    if S.leftConn then S.leftConn:Disconnect(); S.leftConn = nil end
                    S.leftPhase = 1
                    if _G.AdaptSetAutoLeftVisual then _G.AdaptSetAutoLeftVisual(false) end
                    if P.LFace and (P.LFace - hrp.Position).Magnitude > 0.01 then
                        hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(P.LFace.X, hrp.Position.Y, P.LFace.Z))
                    end
                    return
                end

                local d = P.L2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                lv.VectorVelocity = Vector3.new(mv.X * spd, 0, mv.Z * spd)
            end
        end
    end)
end

function _G.AdaptStartAutoRight()
    if autoLeftEnabled then
        autoLeftEnabled = false
        _G.AdaptStopAutoLeft()
    end

    local S = _G.AdaptZombieMove
    if S.rightConn then S.rightConn:Disconnect() end
    S.rightPhase = 1

    S.rightConn = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        if dropBrainrotActive then return end

        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end

        local st = hum:GetState()
        if hum.PlatformStand
            or st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown then
            hum:Move(Vector3.zero, false)
            _G.AdaptZombieStopVelocity()
            return
        end

        local lv = _G.AdaptZombieEnsureLinearVelocity(hrp)
        lv.Enabled = true
        lv.MaxAxesForce = Vector3.new(math.huge, 0, math.huge)
        local P = _G.AdaptZombieMovePoints
        local spd = tonumber(_G.AdaptAutoMoveSpeed) or NS or 60

        if _G.AdaptZombieMoveIsFull() then
            local points = P.FullRight
            if S.rightPhase > #points then
                _G.AdaptZombieStopVelocity()
                local prev = points[#points - 1] or points[#points]
                hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(prev.X, hrp.Position.Y, prev.Z))
                hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                hum:Move(Vector3.zero, false)
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                autoRightEnabled = false
                if S.rightConn then S.rightConn:Disconnect(); S.rightConn = nil end
                S.rightPhase = 1
                if _G.AdaptSetAutoRightVisual then _G.AdaptSetAutoRightVisual(false) end
                return
            end

            local tgt = points[S.rightPhase]
            local flat = Vector3.new(tgt.X, hrp.Position.Y, tgt.Z)
            if (flat - hrp.Position).Magnitude < 1 then
                S.rightPhase += 1
                return
            end

            local dir = (flat - hrp.Position).Unit
            local fspd = (S.rightPhase <= 2)
                and (tonumber(_G.AdaptAutoMoveSpeed) or 60)
                or (tonumber(_G.AdaptAutoMoveCarrySpeed) or 30)

            lv.VectorVelocity = Vector3.new(dir.X * fspd, 0, dir.Z * fspd)
        else
            if S.rightPhase == 1 then
                local tgt = Vector3.new(P.R1.X, hrp.Position.Y, P.R1.Z)
                if (tgt - hrp.Position).Magnitude < 1 then
                    S.rightPhase = 2
                    return
                end

                local d = P.R1 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                lv.VectorVelocity = Vector3.new(mv.X * spd, 0, mv.Z * spd)
            else
                local tgt = Vector3.new(P.R2.X, hrp.Position.Y, P.R2.Z)
                if (tgt - hrp.Position).Magnitude < 1 then
                    hum:Move(Vector3.zero, false)
                    _G.AdaptZombieStopVelocity()
                    hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                    hum:Move(Vector3.zero, false)
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                    autoRightEnabled = false
                    if S.rightConn then S.rightConn:Disconnect(); S.rightConn = nil end
                    S.rightPhase = 1
                    if _G.AdaptSetAutoRightVisual then _G.AdaptSetAutoRightVisual(false) end
                    if P.RFace and (P.RFace - hrp.Position).Magnitude > 0.01 then
                        hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(P.RFace.X, hrp.Position.Y, P.RFace.Z))
                    end
                    return
                end

                local d = P.R2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                lv.VectorVelocity = Vector3.new(mv.X * spd, 0, mv.Z * spd)
            end
        end
    end)
end

--Leaked By Xlu0 AndPrime--
function _G.AdaptSetAutoLeft(on, skipSave)
    autoLeftEnabled = on == true
    if autoLeftEnabled then
        autoRightEnabled = false
        _G.AdaptStopAutoRight()
        _G.AdaptStartAutoLeft()
    else
        _G.AdaptStopAutoLeft()
    end
    if _G.AdaptSetAutoLeftVisual then _G.AdaptSetAutoLeftVisual(autoLeftEnabled) end
end

function _G.AdaptSetAutoRight(on, skipSave)
    autoRightEnabled = on == true
    if autoRightEnabled then
        autoLeftEnabled = false
        _G.AdaptStopAutoLeft()
        _G.AdaptStartAutoRight()
    else
        _G.AdaptStopAutoRight()
    end
    if _G.AdaptSetAutoRightVisual then _G.AdaptSetAutoRightVisual(autoRightEnabled) end
end
--Leaked By Xlu0 AndPrime--

LP.CharacterAdded:Connect(function()
task.wait(0.5)
if autoLeftEnabled and _G.AdaptStartAutoLeft then _G.AdaptStartAutoLeft() end
if autoRightEnabled and _G.AdaptStartAutoRight then _G.AdaptStartAutoRight() end
end)
local overheadGui = nil
local overheadSpeedLabel = nil
local function setupOverheadInfo(char)
if overheadGui then
pcall(function() overheadGui:Destroy() end)
overheadGui = nil
overheadSpeedLabel = nil
end
if not char then return end
local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
if not head then return end
overheadGui = Instance.new("BillboardGui")
overheadGui.Name = "AdaptDuelsOverheadInfo"
overheadGui.Size = UDim2.new(0,190,0,54)
overheadGui.StudsOffset = Vector3.new(0, 2.35, 0)
overheadGui.AlwaysOnTop = true
overheadGui.LightInfluence = 0
overheadGui.Parent = head
ragdollCountdownLabel = Instance.new("TextLabel")
ragdollCountdownLabel.Name = "RagdollCountdown"
ragdollCountdownLabel.Size = UDim2.new(1, 0, 0, 16)
ragdollCountdownLabel.Position = UDim2.new(0,0,0,32)
ragdollCountdownLabel.BackgroundTransparency = 1
ragdollCountdownLabel.Text = ""
ragdollCountdownLabel.Visible = false
ragdollCountdownLabel.TextColor3 = Color3.fromRGB(255,255,255)
ragdollCountdownLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
ragdollCountdownLabel.TextStrokeTransparency = 0.08
ragdollCountdownLabel.Font = Enum.Font.GothamBlack
ragdollCountdownLabel.TextSize = 13
ragdollCountdownLabel.TextXAlignment = Enum.TextXAlignment.Center
ragdollCountdownLabel.ZIndex = 10
ragdollCountdownLabel.Visible = false
ragdollCountdownLabel.Parent = overheadGui
local discordLbl = Instance.new("TextLabel")
discordLbl.Name = "Discord"
discordLbl.Size = UDim2.new(1, 0, 0, 18)
discordLbl.Position = UDim2.new(0,0,0,0)
discordLbl.BackgroundTransparency = 1
discordLbl.Text = "discord.gg/adaptt"
discordLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
discordLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
discordLbl.TextStrokeTransparency = 0.08
discordLbl.Font = Enum.Font.GothamBlack
discordLbl.TextSize = 13
discordLbl.TextXAlignment = Enum.TextXAlignment.Center
discordLbl.ZIndex = 10
discordLbl.Parent = overheadGui
overheadSpeedLabel = Instance.new("TextLabel")
overheadSpeedLabel.Name = "Speed"
overheadSpeedLabel.Size = UDim2.new(1, 0, 0, 18)
overheadSpeedLabel.Position = UDim2.new(0,0,0,16)
overheadSpeedLabel.BackgroundTransparency = 1
overheadSpeedLabel.Text = "0 speed"
overheadSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
overheadSpeedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
overheadSpeedLabel.TextStrokeTransparency = 0.08
overheadSpeedLabel.Font = Enum.Font.GothamBlack
overheadSpeedLabel.TextSize = 13
overheadSpeedLabel.TextXAlignment = Enum.TextXAlignment.Center
overheadSpeedLabel.ZIndex = 10
overheadSpeedLabel.Parent = overheadGui
end
local ragdollCountdownConn = nil
local ragdollCountdownCharConn = nil
local ragdollCountdownEndTime = 0
local RAGDOLL_COUNTDOWN_SECONDS = 2.6
function stopRagdollCountdown()
if ragdollCountdownConn then ragdollCountdownConn:Disconnect(); ragdollCountdownConn = nil end
if ragdollCountdownCharConn then ragdollCountdownCharConn:Disconnect(); ragdollCountdownCharConn = nil end
if ragdollCountdownLabel then
ragdollCountdownLabel.Visible = false
ragdollCountdownLabel.Text = ""
end
end
function hookRagdollCountdown(char)
stopRagdollCountdown()
if not ragdollCountdownEnabled then return end
char = char or LP.Character
if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 4)
if not hum then return end
local function beginCountdown()
ragdollCountdownEndTime = tick() + RAGDOLL_COUNTDOWN_SECONDS
if ragdollCountdownLabel then
ragdollCountdownLabel.Visible = true
ragdollCountdownLabel.Text = string.format("GET UP: %.1fs", RAGDOLL_COUNTDOWN_SECONDS)
end
end
local function isRagdollStateForCountdown()
local st = hum:GetState()
return hum.PlatformStand
or st == Enum.HumanoidStateType.Physics
or st == Enum.HumanoidStateType.Ragdoll
or st == Enum.HumanoidStateType.FallingDown
end
ragdollCountdownCharConn = hum.StateChanged:Connect(function(_, newState)
if newState == Enum.HumanoidStateType.Physics
or newState == Enum.HumanoidStateType.Ragdoll
or newState == Enum.HumanoidStateType.FallingDown then
beginCountdown()
end
end)
ragdollCountdownConn = RunService.RenderStepped:Connect(function()
if not ragdollCountdownEnabled then stopRagdollCountdown(); return end
if not ragdollCountdownLabel or not ragdollCountdownLabel.Parent then return end
if isRagdollStateForCountdown() and ragdollCountdownEndTime < tick() then
beginCountdown()
end
local left = math.max(0, ragdollCountdownEndTime - tick())
if left > 0 and isRagdollStateForCountdown() then
ragdollCountdownLabel.Visible = true
ragdollCountdownLabel.Text = string.format("GET UP: %.1fs", left)
ragdollCountdownLabel.TextColor3 = Color3.fromRGB(255,255,255)
else
ragdollCountdownLabel.Visible = false
ragdollCountdownLabel.Text = ""
end
end)
end
if LP.Character then
task.spawn(function()
setupOverheadInfo(LP.Character)
task.wait(0.05)
if ragdollCountdownEnabled then hookRagdollCountdown(LP.Character) end
end)
end
LP.CharacterAdded:Connect(function(char)
task.wait(0.5)
setupOverheadInfo(char)
if ragdollCountdownEnabled then hookRagdollCountdown(char) end
end)
local function getHorizontalSpeedLinearVelocity(hrp)
local attachment = hrp:FindFirstChild("AdaptSpeedAttachment")
if not attachment then
attachment = Instance.new("Attachment")
attachment.Name = "AdaptSpeedAttachment"
attachment.Parent = hrp
end
local linearVelocity = hrp:FindFirstChild("AdaptHorizontalSpeed")
if not linearVelocity then
linearVelocity = Instance.new("LinearVelocity")
linearVelocity.Name = "AdaptHorizontalSpeed"
linearVelocity.Attachment0 = attachment
linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
linearVelocity.PrimaryTangentAxis = Vector3.new(1, 0, 0)
linearVelocity.SecondaryTangentAxis = Vector3.new(0, 0, 1)
linearVelocity.ForceLimitsEnabled = true
linearVelocity.MaxForce = 18000
linearVelocity.PlaneVelocity = Vector2.zero
linearVelocity.Parent = hrp
end
return linearVelocity
end
RunService.RenderStepped:Connect(function()
local char = LP.Character
if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid")
local hrp = char:FindFirstChild("HumanoidRootPart")
if not hum or not hrp then return end
local state = hum:GetState()
local spd = getCurrentSpeedValue()
--Leaked By Xlu0 AndPrime--
if not speedBoosterEnabled or spd <= 16 then return end
local speedVelocity = getHorizontalSpeedLinearVelocity(hrp)
if hum.PlatformStand
or state == Enum.HumanoidStateType.Physics
or state == Enum.HumanoidStateType.Ragdoll
or state == Enum.HumanoidStateType.FallingDown then
lastMoveDir = Vector3.new(0, 0, 0)
speedVelocity.PlaneVelocity = Vector2.zero
speedVelocity.Enabled = false
return
end
local aimbotActive = _G.AdaptNormalAimbotOn == true
or _G.AdaptAntiBypassAimbotOn == true
or _G.AdaptAntiDesyncAimbotOn == true
if autoLeftEnabled or autoRightEnabled then
speedVelocity.PlaneVelocity = Vector2.zero
speedVelocity.Enabled = false
elseif aimbotActive then
local aimVelocity = hrp.AssemblyLinearVelocity
speedVelocity.Enabled = true
speedVelocity.PlaneVelocity = Vector2.new(aimVelocity.X, aimVelocity.Z)
else
local md = hum.MoveDirection
if md.Magnitude > 0 then
lastMoveDir = md
speedVelocity.Enabled = true
speedVelocity.PlaneVelocity = Vector2.new(md.X * spd, md.Z * spd)
else
lastMoveDir = Vector3.new(0, 0, 0)
speedVelocity.PlaneVelocity = Vector2.zero
speedVelocity.Enabled = false
end
end
if overheadSpeedLabel then
local v = hrp.AssemblyLinearVelocity
local speedMag = Vector3.new(v.X, 0, v.Z).Magnitude
local rounded = math.floor(speedMag * 10 + 0.5) / 10
if math.abs(rounded - math.floor(rounded)) < 0.05 then
overheadSpeedLabel.Text = string.format("%d speed", math.floor(rounded + 0.5))
else
overheadSpeedLabel.Text = string.format("%.1f speed", rounded)
end
end
end)
local COLORS = {
bg = Color3.fromRGB(0, 0, 0),
row = Color3.fromRGB(6, 6, 9),
row2 = Color3.fromRGB(8, 8, 12),
stroke = Color3.fromRGB(90, 90, 105),
strokeSoft = Color3.fromRGB(60, 60, 72),
white = Color3.fromRGB(255, 255, 255),
textDim = Color3.fromRGB(180, 180, 190),
toggleBg = Color3.fromRGB(18, 18, 26),
knob = Color3.fromRGB(238, 238, 245),
}
function corner(parent, radius)
local c = Instance.new("UICorner")
c.CornerRadius = UDim.new(0, radius or 8)
c.Parent = parent
return c
end
function stroke(parent, color, thickness, transparency)
local s = Instance.new("UIStroke")
s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
s.Color = color or COLORS.stroke
s.Thickness = thickness or 1
s.Transparency = transparency or 0.35
s.Parent = parent
local g = Instance.new("UIGradient")
g.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(155, 160, 185)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
})
g.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.55),
NumberSequenceKeypoint.new(0.5, 0.1),
NumberSequenceKeypoint.new(1, 0.55),
})
g.Parent = s
return s
end
function tween(obj, props, time)
TweenService:Create(obj, TweenInfo.new(time or 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

function _G.AdaptAddMovingEdgeLight(btn)
if not btn or not btn:IsA("GuiButton") then return end
if btn.Name ~= "ArrowButton" then return end
if btn:FindFirstChild("AdaptMovingEdge") then return end

local edge = Instance.new("UIStroke")
edge.Name = "AdaptMovingEdge"
edge.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
edge.Color = Color3.fromRGB(255,255,255)
edge.Thickness = 1.35
edge.Transparency = 0.24
edge.LineJoinMode = Enum.LineJoinMode.Round
edge.Parent = btn

local grad = Instance.new("UIGradient")
grad.Name = "MovingLight"
grad.Rotation = 0
grad.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0.00, Color3.fromRGB(95,95,95)),
ColorSequenceKeypoint.new(0.38, Color3.fromRGB(125,125,125)),
ColorSequenceKeypoint.new(0.46, Color3.fromRGB(235,235,235)),
ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.54, Color3.fromRGB(235,235,235)),
ColorSequenceKeypoint.new(0.62, Color3.fromRGB(125,125,125)),
ColorSequenceKeypoint.new(1.00, Color3.fromRGB(95,95,95))
})
grad.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0.00, 0.90),
NumberSequenceKeypoint.new(0.37, 0.82),
NumberSequenceKeypoint.new(0.45, 0.28),
NumberSequenceKeypoint.new(0.50, 0.00),
NumberSequenceKeypoint.new(0.55, 0.28),
NumberSequenceKeypoint.new(0.63, 0.82),
NumberSequenceKeypoint.new(1.00, 0.90)
})
grad.Parent = edge

local info = TweenInfo.new(1.15, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false, 0)
pcall(function()
TweenService:Create(grad, info, {Rotation = 360}):Play()
end)
end

function _G.AdaptApplyMovingEdgeLights(root)
root = root or PlayerGui
if not root then return end

for _, obj in ipairs(root:GetDescendants()) do
if (obj:IsA("TextButton") or obj:IsA("ImageButton")) and obj.Name == "ArrowButton" then
pcall(function() _G.AdaptAddMovingEdgeLight(obj) end)
end
end

root.DescendantAdded:Connect(function(obj)
if (obj:IsA("TextButton") or obj:IsA("ImageButton")) and obj.Name == "ArrowButton" then
task.defer(function()
task.wait()
pcall(function() _G.AdaptAddMovingEdgeLight(obj) end)
end)
end
end)
end

function makeDraggable(frame)
local dragging = false
local dragStart
local startPos
local dragInput
frame.InputBegan:Connect(function(input)
if _G.AdaptGuiLocked == true then return end
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
dragStart = input.Position
startPos = frame.Position
input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then
dragging = false
end
end)
end
end)
frame.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
dragInput = input
end
end)
UserInputService.InputChanged:Connect(function(input)
if _G.AdaptGuiLocked == true then return end
if input == dragInput and dragging then
local delta = input.Position - dragStart
frame.Position = UDim2.new(
startPos.X.Scale,
startPos.X.Offset + delta.X,
startPos.Y.Scale,
startPos.Y.Offset + delta.Y
)
end
end)
end
local Gui = Instance.new("ScreenGui")
Gui.Name = "AdaptHubPolished"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.DisplayOrder = 999
safeParentGui(Gui)
local FULL_MAIN_SIZE = UDim2.new(0, 356, 0, 536)
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0, 0.5)
Main.Size = FULL_MAIN_SIZE
Main.Position = tableToUDim2(savedMainPositionTable, UDim2.new(0, 20, 0.5, 0))
savedMainPositionTable = udim2ToTable(Main.Position)
Main.BackgroundColor3 = COLORS.bg
Main.BorderSizePixel = 0
Main.Active = true
Main.ClipsDescendants = false
Main.Parent = Gui
corner(Main, 14)
stroke(Main, COLORS.stroke, 1.1, 0.35)
makeDraggable(Main)
Main:GetPropertyChangedSignal("Position"):Connect(function()
savedMainPositionTable = udim2ToTable(Main.Position)
end)
local MiniFrame = Instance.new("Frame")
MiniFrame.Name = "MiniFrame"
MiniFrame.AnchorPoint = Vector2.new(0, 0)
MiniFrame.Size = UDim2.new(0, 110, 0, 32)
local MINI_DEFAULT_POSITION = UDim2.new(0, 0, 0.48, -16)
MiniFrame.Position = MINI_DEFAULT_POSITION
savedMiniPositionTable = nil
MiniFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
MiniFrame.BackgroundTransparency = 0.08
MiniFrame.BorderSizePixel = 0
MiniFrame.Visible = false
MiniFrame.Active = true
MiniFrame.ZIndex = 20
MiniFrame.Parent = Gui
corner(MiniFrame, 16)
local MiniButton = Instance.new("TextButton")
MiniButton.Name = "MiniButton"
MiniButton.Size = UDim2.new(1, -4, 1, -4)
MiniButton.Position = UDim2.new(0, 2, 0, 2)
MiniButton.BackgroundTransparency = 1
MiniButton.Text = ""
MiniButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
MiniButton.TextStrokeTransparency = 1
MiniButton.TextSize = 11
MiniButton.Font = Enum.Font.GothamMedium
MiniButton.TextXAlignment = Enum.TextXAlignment.Center
MiniButton.AutoButtonColor = false
MiniButton.ZIndex = 24
MiniButton.Parent = MiniFrame

local AdaptMiniLogo = Instance.new("ImageLabel")
AdaptMiniLogo.Name = "AdaptMiniLogo"
AdaptMiniLogo.BackgroundTransparency = 1
AdaptMiniLogo.Size = UDim2.new(1, -12, 1, -8)
AdaptMiniLogo.Position = UDim2.new(0, 6, 0, 4)
AdaptMiniLogo.Image = "rbxassetid://92966351305582"
AdaptMiniLogo.ScaleType = Enum.ScaleType.Fit
AdaptMiniLogo.ZIndex = 23
AdaptMiniLogo.Active = false
AdaptMiniLogo.Parent = MiniButton

--Leaked By Xlu0 AndPrime--
local MiniShimmerText = Instance.new("TextLabel")
MiniShimmerText.Name = "MiniShimmerText"
MiniShimmerText.Size = UDim2.new(1, 0, 1, 0)
MiniShimmerText.Position = UDim2.new(0, 0, 0, 0)
MiniShimmerText.BackgroundTransparency = 1
MiniShimmerText.Text = ""
MiniShimmerText.TextColor3 = Color3.fromRGB(255,255,255)
MiniShimmerText.TextTransparency = 0
MiniShimmerText.TextStrokeTransparency = 1
MiniShimmerText.TextSize = 11
MiniShimmerText.Font = Enum.Font.GothamMedium
MiniShimmerText.TextXAlignment = Enum.TextXAlignment.Center
MiniShimmerText.Active = false
MiniShimmerText.Selectable = false
MiniShimmerText.ZIndex = 22
MiniShimmerText.Visible = false
MiniShimmerText.Parent = MiniFrame

--Leaked By Xlu0 AndPrime--
local MiniShimmerGradient = Instance.new("UIGradient")
MiniShimmerGradient.Rotation = 8
MiniShimmerGradient.Offset = Vector2.new(-1.45, 0)
MiniShimmerGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(0.44, Color3.fromRGB(235,235,235)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(0.56, Color3.fromRGB(235,235,235)),
    ColorSequenceKeypoint.new(0.65, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255,255,255))
})
MiniShimmerGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0.00, 1.00),
    NumberSequenceKeypoint.new(0.34, 1.00),
    NumberSequenceKeypoint.new(0.40, 0.88),
    NumberSequenceKeypoint.new(0.44, 0.55),
    NumberSequenceKeypoint.new(0.48, 0.16),
    NumberSequenceKeypoint.new(0.50, 0.00),
    NumberSequenceKeypoint.new(0.52, 0.16),
    NumberSequenceKeypoint.new(0.56, 0.55),
    NumberSequenceKeypoint.new(0.60, 0.88),
    NumberSequenceKeypoint.new(0.66, 1.00),
    NumberSequenceKeypoint.new(1.00, 1.00)
})
MiniShimmerGradient.Parent = MiniShimmerText

--Leaked By Xlu0 AndPrime--
local MiniGlowText = MiniShimmerText:Clone()
MiniGlowText.Name = "MiniGlowText"
MiniGlowText.TextTransparency = 0.42
MiniGlowText.TextStrokeTransparency = 1
MiniGlowText.ZIndex = 21
MiniGlowText.Visible = false
MiniGlowText.Parent = MiniFrame

local MiniGlowGradient = MiniShimmerGradient:Clone()
MiniGlowGradient.Parent = MiniGlowText

task.spawn(function()
    while false do
        MiniShimmerGradient.Offset = Vector2.new(-1.45, 0)
        MiniGlowGradient.Offset = Vector2.new(-1.45, 0)

        local t1 = TweenService:Create(
            MiniShimmerGradient,
            TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            {Offset = Vector2.new(1.45, 0)}
        )
        local t2 = TweenService:Create(
            MiniGlowGradient,
            TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            {Offset = Vector2.new(1.45, 0)}
        )

        t1:Play()
        t2:Play()
        t1.Completed:Wait()

        --Leaked By Xlu0 AndPrime--
        task.wait(1.1)
    end
end)

local MiniShade = Instance.new("Frame")
MiniShade.Name = "MiniShade"
MiniShade.Size = UDim2.new(1, -4, 1, -4)
MiniShade.Position = UDim2.new(0, 2, 0, 2)
MiniShade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniShade.BackgroundTransparency = 0.12
MiniShade.BorderSizePixel = 0
MiniShade.ZIndex = 20
MiniShade.Parent = MiniFrame
MiniButton.MouseEnter:Connect(function()
TweenService:Create(MiniFrame, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(20, 20, 24)}):Play()
end)
MiniButton.MouseLeave:Connect(function()
TweenService:Create(MiniFrame, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(14, 14, 18)}):Play()
end)
corner(MiniShade, 14)
local MiniAdaptStroke = Instance.new("UIStroke")
MiniAdaptStroke.Color = Color3.fromRGB(255,255,255)
MiniAdaptStroke.Thickness = 1
MiniAdaptStroke.Transparency = 0.45
MiniAdaptStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MiniAdaptStroke.Parent = MiniFrame
do
local miniDragging = false
local miniDragStart = nil
local miniStartPos = nil
local miniMoved = false
local miniHeldInput = nil
local DRAG_DEADZONE = 6
MiniButton.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
miniDragging = true
miniMoved = false
miniHeldInput = input
miniDragStart = input.Position
miniStartPos = MiniFrame.Position
end
end)
UserInputService.InputChanged:Connect(function(input)
if not miniDragging then return end
if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
if not miniDragStart or not miniStartPos then return end
local delta = input.Position - miniDragStart
if math.abs(delta.X) > DRAG_DEADZONE or math.abs(delta.Y) > DRAG_DEADZONE then
miniMoved = true
end
MiniFrame.Position = UDim2.new(
miniStartPos.X.Scale,
miniStartPos.X.Offset + delta.X,
miniStartPos.Y.Scale,
miniStartPos.Y.Offset + delta.Y
)
end)
UserInputService.InputEnded:Connect(function(input)
if input ~= miniHeldInput then return end
local wasDrag = miniMoved
miniDragging = false
miniHeldInput = nil
miniDragStart = nil
miniStartPos = nil
if wasDrag then
return
end
Main.Visible = true
MiniFrame.Visible = false
Main.Size = FULL_MAIN_SIZE
savedMainPositionTable = udim2ToTable(Main.Position)
end)
end
local BackgroundIDs = {
"90631990302263",
"109619268613730",
"88369503310562",
"80708025126373",
"102253425322931",
"90453834580322",
"135181794444219",
}

local ButtonImageIDs = {
"90631990302263",
"111941119745474",
"88369503310562",
"80708025126373",
"102253425322931",
"138739435956313",
"135181794444219",
}

_G.AdaptThemeColors = _G.AdaptThemeColors or {
PURPLE = Color3.fromRGB(207, 159, 255),
BLUE   = Color3.fromRGB(58, 128, 245),
RED    = Color3.fromRGB(232, 52, 68),
PINK   = Color3.fromRGB(255, 105, 180),
YELLOW = Color3.fromRGB(255, 214, 0),
GREY   = Color3.fromRGB(90, 90, 90),
WHITE  = Color3.fromRGB(255, 255, 255),
FOREST = Color3.fromRGB(46, 139, 87),
}

_G.AdaptThemeName = tostring(savedConfig.currentThemeName or _G.AdaptThemeName or "WHITE")
currentBackground = tonumber(savedConfig.currentBackground) or currentBackground
_G.AdaptBodyLockEnabled = savedConfig.bodyLockEnabled == true
_G.AdaptBodyLockRadius = tonumber(savedConfig.bodyLockRadius) or _G.AdaptBodyLockRadius or 60
if savedConfig.mobileButtonScale ~= nil then _G.AdaptMobileButtonScale = tonumber(savedConfig.mobileButtonScale) or _G.AdaptMobileButtonScale or 0.75 end
if savedConfig.guiScaleValue ~= nil then _G.AdaptGuiScaleValue = tonumber(savedConfig.guiScaleValue) or _G.AdaptGuiScaleValue end
if savedConfig.stealUiScaleValue ~= nil then _G.AdaptProgressBarScaleValue = tonumber(savedConfig.stealUiScaleValue) or _G.AdaptProgressBarScaleValue end
_G.AdaptHeadlessEnabled = savedConfig.headlessEnabled == true
_G.AdaptKorbloxEnabled = savedConfig.korbloxEnabled == true
local BgImage = Instance.new("ImageLabel")
BgImage.Name = "CustomBackground"
BgImage.BackgroundTransparency = 1
BgImage.ImageTransparency = 0
BgImage.ScaleType = Enum.ScaleType.Crop
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.Position = UDim2.new(0, 0, 0, 0)
BgImage.Visible = false
BgImage.ZIndex = 1
BgImage.Parent = Main
corner(BgImage, 14)
function applyBackground(index)
currentBackground = index or 0
if currentBackground == 0 then
Main.BackgroundColor3 = COLORS.bg
BgImage.Visible = false
do end
return "None"
end
local id = BackgroundIDs[currentBackground]
if id then
BgImage.Image = "rbxassetid://" .. id
local selectedTint = _G.AdaptThemeColors[_G.AdaptThemeName] or _G.AdaptThemeColors.WHITE
BgImage.ImageColor3 = selectedTint
if AdaptLogoAsset then AdaptLogoAsset.ImageColor3 = selectedTint end
BgImage.Visible = true
do end
return "Image " .. tostring(currentBackground)
end
currentBackground = 0
BgImage.Visible = false
do end
return "None"
end
applyBackground(currentBackground)
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -110, 0, 44)
Title.Position = UDim2.new(0, 55, 0, 24)
Title.Text = ""
Title.TextColor3 = COLORS.white
Title.TextStrokeTransparency = 1
Title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.GothamMedium
Title.TextSize = 38
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.ZIndex = 6
Title.Parent = Main
Title.Visible = false

local AdaptLogoAsset = Instance.new("ImageLabel")
AdaptLogoAsset.Name = "LogoAsset"
AdaptLogoAsset.ZIndex = 6
AdaptLogoAsset.Position = UDim2.new(0.5, -150, 0, -18)
AdaptLogoAsset.Size = UDim2.new(0, 300, 0, 150)
AdaptLogoAsset.BackgroundTransparency = 1
AdaptLogoAsset.Image = "rbxassetid://135088241492683"
AdaptLogoAsset.ScaleType = Enum.ScaleType.Fit
AdaptLogoAsset.Parent = Main
AdaptLogoAsset.ImageColor3 = _G.AdaptThemeColors[_G.AdaptThemeName] or _G.AdaptThemeColors.WHITE

--Leaked By Xlu0 AndPrime--
local TitleSweepText = Title:Clone()
TitleSweepText.Name = "TitleSweepText"
TitleSweepText.TextColor3 = Color3.fromRGB(0, 0, 0)
TitleSweepText.TextTransparency = 0
TitleSweepText.TextStrokeTransparency = 1
TitleSweepText.BackgroundTransparency = 1
TitleSweepText.ZIndex = Title.ZIndex + 1
TitleSweepText.Visible = false
TitleSweepText.Parent = Main

local SweepGradient = Instance.new("UIGradient")
SweepGradient.Rotation = 12
SweepGradient.Offset = Vector2.new(-1.25, 0)
SweepGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0.00, 1),
    NumberSequenceKeypoint.new(0.43, 1),
    NumberSequenceKeypoint.new(0.49, 0.55),
    NumberSequenceKeypoint.new(0.50, 0.00),
    NumberSequenceKeypoint.new(0.51, 0.55),
    NumberSequenceKeypoint.new(0.57, 1),
    NumberSequenceKeypoint.new(1.00, 1)
})
SweepGradient.Parent = TitleSweepText

task.spawn(function()
    while false do
        SweepGradient.Offset = Vector2.new(-1.25, 0)
        local sweepTween = TweenService:Create(
            SweepGradient,
            TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Offset = Vector2.new(1.25, 0)}
        )
        sweepTween:Play()
        sweepTween.Completed:Wait()
        task.wait(1.2)
    end
end)
local HeaderDivider = Instance.new("Frame")
HeaderDivider.Name = "HeaderDivider"
HeaderDivider.BackgroundColor3 = Color3.fromRGB(70, 70, 82)
HeaderDivider.BackgroundTransparency = 1
HeaderDivider.BorderSizePixel = 0
HeaderDivider.Size = UDim2.new(1, -34, 0, 1)
HeaderDivider.Position = UDim2.new(0, 17, 0, 96)
HeaderDivider.ZIndex = 6
HeaderDivider.Visible = false
HeaderDivider.Parent = Main
local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Close.BackgroundTransparency = 0.28
Close.Text = "-"
Close.TextColor3 = COLORS.white
Close.TextSize = 22
Close.Font = Enum.Font.GothamMedium
Close.Size = UDim2.new(0, 32, 0, 28)
Close.Position = UDim2.new(1, -42, 0, 14)
Close.AutoButtonColor = false
Close.ZIndex = 5
Close.Parent = Main
corner(Close, 8)
stroke(Close, COLORS.stroke, 1, 0.35)
--Leaked By Xlu0 AndPrime--
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 13, 0, 103)
Content.Size = UDim2.new(1, -26, 1, -153)
Content.ZIndex = 3
Content.Parent = Main
local Tabs = Instance.new("Frame")
Tabs.Name = "Tabs"
Tabs.BackgroundTransparency = 1
Tabs.Position = UDim2.new(0, 12, 1, -42)
Tabs.Size = UDim2.new(1, -24, 0, 34)
Tabs.ZIndex = 3
Tabs.Parent = Main

--Leaked By Xlu0 AndPrime--
--Leaked By Xlu0 AndPrime--
do
local IDLE_DELAY = 5
local FADE_TIME = 0.45
local idleToken = 0
local idleCollapsed = false
local savedTransparency = setmetatable({}, {__mode = "k"})
local activeTweens = setmetatable({}, {__mode = "k"})

local function rememberObject(obj)
    if savedTransparency[obj] then return end
    local data = {}
    if obj:IsA("GuiObject") then
        data.BackgroundTransparency = obj.BackgroundTransparency
    end
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        data.TextTransparency = obj.TextTransparency
        data.TextStrokeTransparency = obj.TextStrokeTransparency
    end
    if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
        data.ImageTransparency = obj.ImageTransparency
    end
    if obj:IsA("UIStroke") then
        data.Transparency = obj.Transparency
    end
    savedTransparency[obj] = data
end

local function tweenObject(obj, collapsed)
    rememberObject(obj)
    local base = savedTransparency[obj]
    if not base then return end

    if activeTweens[obj] then
        pcall(function() activeTweens[obj]:Cancel() end)
        activeTweens[obj] = nil
    end

    local goal = {}
    if base.BackgroundTransparency ~= nil then
        goal.BackgroundTransparency = collapsed and math.max(base.BackgroundTransparency, 0.78) or base.BackgroundTransparency
    end
    if base.TextTransparency ~= nil then
        goal.TextTransparency = collapsed and math.max(base.TextTransparency, 0.58) or base.TextTransparency
    end
    if base.TextStrokeTransparency ~= nil then
        goal.TextStrokeTransparency = collapsed and math.max(base.TextStrokeTransparency, 0.82) or base.TextStrokeTransparency
    end
    if base.ImageTransparency ~= nil then
        goal.ImageTransparency = collapsed and math.max(base.ImageTransparency, 0.68) or base.ImageTransparency
    end
    if base.Transparency ~= nil then
        goal.Transparency = collapsed and math.max(base.Transparency, 0.72) or base.Transparency
    end

    if next(goal) then
        local tw = TweenService:Create(
            obj,
            TweenInfo.new(FADE_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            goal
        )
        activeTweens[obj] = tw
        tw:Play()
    end
end

local restoreToken = 0

local function forceOriginalTransparency()
    for obj, base in pairs(savedTransparency) do
        if obj and obj.Parent and base then
            if activeTweens[obj] then
                pcall(function() activeTweens[obj]:Cancel() end)
                activeTweens[obj] = nil
            end
            pcall(function()
                if base.BackgroundTransparency ~= nil then obj.BackgroundTransparency = base.BackgroundTransparency end
                if base.TextTransparency ~= nil then obj.TextTransparency = base.TextTransparency end
                if base.TextStrokeTransparency ~= nil then obj.TextStrokeTransparency = base.TextStrokeTransparency end
                if base.ImageTransparency ~= nil then obj.ImageTransparency = base.ImageTransparency end
                if base.Transparency ~= nil then obj.Transparency = base.Transparency end
            end)
        end
    end
end

local function setMenuIdleCollapsed(state)
    local newState = state == true
    restoreToken += 1
    local myRestoreToken = restoreToken

    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    if newState and not idleCollapsed then
        savedTransparency = setmetatable({}, {__mode = "k"})
        for _, root in ipairs({Content, Tabs, Close, HeaderDivider}) do
            rememberObject(root)
            for _, obj in ipairs(root:GetDescendants()) do
                rememberObject(obj)
            end
        end
    end

    idleCollapsed = newState

    Content.Visible = true
    Tabs.Visible = true
    Close.Visible = true
    HeaderDivider.Visible = false

    for _, root in ipairs({Content, Tabs, Close, HeaderDivider}) do
        tweenObject(root, idleCollapsed)
        for _, obj in ipairs(root:GetDescendants()) do
            tweenObject(obj, idleCollapsed)
        end
    end

    if not newState then
        --Leaked By Xlu0 AndPrime--
        --Leaked By Xlu0 AndPrime--
        task.delay(FADE_TIME + 0.08, function()
            if myRestoreToken ~= restoreToken or idleCollapsed then return end
            --Leaked By Xlu0 AndPrime--
            --Leaked By Xlu0 AndPrime--
            local untilTime = tick() + 1.5
            repeat
                if myRestoreToken ~= restoreToken or idleCollapsed then return end
                forceOriginalTransparency()
                RunService.RenderStepped:Wait()
            until tick() >= untilTime
            forceOriginalTransparency()
            --Leaked By Xlu0 AndPrime--
        end)
    end
end

local function cancelIdleAndRestore()
    idleToken += 1
    if idleCollapsed then
        setMenuIdleCollapsed(false)
    elseif next(savedTransparency) then
        --Leaked By Xlu0 AndPrime--
        forceOriginalTransparency()
    end
end

local function scheduleIdleCollapse()
    --Leaked By Xlu0 AndPrime--
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then return end
    idleToken += 1
    local myToken = idleToken
    task.delay(IDLE_DELAY, function()
        if myToken ~= idleToken then return end
        if not Main or not Main.Parent or not Main.Visible then return end
        setMenuIdleCollapsed(true)
    end)
end

Main.MouseEnter:Connect(cancelIdleAndRestore)
Main.MouseLeave:Connect(scheduleIdleCollapse)

--Leaked By Xlu0 AndPrime--
--Leaked By Xlu0 AndPrime--
RunService.RenderStepped:Connect(function()
    if not Main or not Main.Parent or not Main.Visible then return end
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then return end
    local mousePos = UserInputService:GetMouseLocation()
    local pos = Main.AbsolutePosition
    local size = Main.AbsoluteSize
    local inside = mousePos.X >= pos.X and mousePos.X <= pos.X + size.X
        and mousePos.Y >= pos.Y and mousePos.Y <= pos.Y + size.Y
    if inside then
        if idleCollapsed then
            cancelIdleAndRestore()
        else
            --Leaked By Xlu0 AndPrime--
            --Leaked By Xlu0 AndPrime--
            for _, root in ipairs({Content, Tabs, Close, HeaderDivider}) do
                if root:IsA("TextLabel") or root:IsA("TextButton") or root:IsA("TextBox") then
                    root.TextTransparency = 0
                end
                for _, obj in ipairs(root:GetDescendants()) do
                    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                        if obj.Visible then
                            obj.TextTransparency = 0
                        end
                    end
                end
            end
        end
    end
end)

--Leaked By Xlu0 AndPrime--
Main.DescendantAdded:Connect(function(obj)
    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    if idleCollapsed then
        task.defer(function()
            if obj and obj.Parent then
                savedTransparency[obj] = nil
                tweenObject(obj, true)
            end
        end)
    end
end)

--Leaked By Xlu0 AndPrime--
task.defer(scheduleIdleCollapse)
end

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 6)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.Parent = Tabs
local pages = {}
local tabButtons = {}
local tabNames = {"MOVEMENT", "COMBAT", "KEYBINDS", "VISUALS", "MENU", "SETTINGS"}
local activeTab = "MOVEMENT"
function addPage(name)
local page = Instance.new("ScrollingFrame")
page.Name = name
page.BackgroundTransparency = 1
page.BorderSizePixel = 0
page.ScrollBarThickness = 0
page.ScrollBarImageTransparency = 1
page.CanvasSize = UDim2.new(0, 0, 0, 0)
page.AutomaticCanvasSize = Enum.AutomaticSize.Y
page.Size = UDim2.new(1, 0, 1, 0)
page.ZIndex = 3
page.Visible = false
page.Parent = Content
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 7)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = page
pages[name] = page
return page
end
function setTab(name)
activeTab = name
for pageName, page in pairs(pages) do
page.Visible = pageName == name
end
for tabName, btn in pairs(tabButtons) do
local on = tabName == name
btn.TextColor3 = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(190,187,202)
btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
btn.BackgroundTransparency = on and 0.78 or 1
local st = btn:FindFirstChildOfClass("UIStroke")
if st then
st.Color = Color3.fromRGB(255,255,255)
st.Thickness = 1.2
st.Transparency = on and 0.15 or 0.52
end
end
end
for _, name in ipairs(tabNames) do
addPage(name)
local btn = Instance.new("TextButton")
btn.Name = name
btn.Size = UDim2.new(0.166667, -5, 1, 0)
btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
btn.BackgroundTransparency = 1
btn.BorderSizePixel = 0
btn.Text = ({KEYBINDS="KBM", MENU="CTRL", VISUALS="VISUAL"})[name] or name
btn.LayoutOrder = ({MOVEMENT=1, COMBAT=2, KEYBINDS=3, MENU=4, VISUALS=5, SETTINGS=6})[name] or 99
btn.TextColor3 = Color3.fromRGB(190,187,202)
btn.TextStrokeColor3 = Color3.fromRGB(0,0,0)
btn.TextStrokeTransparency = 1
btn.TextSize = 11
btn.TextScaled = true
btn.TextWrapped = true
btn.Font = Enum.Font.GothamBlack
btn.AutoButtonColor = false
btn.ZIndex = 4
btn.Parent = Tabs
local tabTextConstraint = Instance.new("UITextSizeConstraint")
tabTextConstraint.MinTextSize = 6
tabTextConstraint.MaxTextSize = 12
tabTextConstraint.Parent = btn
corner(btn, 9)
stroke(btn, Color3.fromRGB(255,255,255), 1.2, 0.52)
tabButtons[name] = btn
local targetTabName = name
btn.MouseButton1Click:Connect(function()
setTab(targetTabName)
end)
end
function section(parent, text, order)
local label = Instance.new("TextLabel")
label.Name = text
label.BackgroundTransparency = 1
label.Text = text
label.TextColor3 = Color3.fromRGB(245, 245, 255)
label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
label.TextStrokeTransparency = 1
label.TextSize = 11
label.Font = Enum.Font.GothamBlack
label.TextXAlignment = Enum.TextXAlignment.Left
label.Size = UDim2.new(1, -6, 0, 15)
label.LayoutOrder = order
label.ZIndex = 8
label.Parent = parent
return label
end
function baseRow(parent, labelText, order)
local row = Instance.new("Frame")
row.Name = labelText
row.BackgroundColor3 = COLORS.row
row.BackgroundTransparency = 0.3
row.Size = UDim2.new(1, -4, 0, 34)
row.BorderSizePixel = 0
row.LayoutOrder = order
row.ZIndex = 4
row.Parent = parent
corner(row, 9)
stroke(row, COLORS.strokeSoft, 1.15, 0.38)
local label = Instance.new("TextLabel")
label.Name = "Label"
label.BackgroundTransparency = 1
label.Text = labelText
label.TextColor3 = Color3.fromRGB(245, 245, 255)
label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
label.TextStrokeTransparency = 1
label.TextSize = 12
label.Font = Enum.Font.GothamMedium
label.TextXAlignment = Enum.TextXAlignment.Left
label.Position = UDim2.new(0, 12, 0, 0)
label.Size = UDim2.new(1, -132, 1, 0)
label.ZIndex = 5
label.Parent = row
--Leaked By Xlu0 AndPrime--
return row
end
function textboxRow(parent, labelText, value, order)
local row = baseRow(parent, labelText, order)
local box = Instance.new("TextBox")
box.Name = "ValueBox"
box.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
box.BackgroundTransparency = 0.18
box.Text = tostring(value or "")
box.TextColor3 = COLORS.white
box.TextSize = 12
box.Font = Enum.Font.GothamMedium
box.ClearTextOnFocus = false
box.Size = UDim2.new(0, 58, 0, 24)
box.Position = UDim2.new(1, -68, 0.5, -12)
box.BorderSizePixel = 0
box.ZIndex = 6
box.Parent = row
corner(box, 7)
stroke(box, COLORS.strokeSoft, 1, 0.45)
return row, box
end
function toggleRow(parent, labelText, default, order)
local row = baseRow(parent, labelText, order)
local button = Instance.new("TextButton")
button.Name = "ToggleButton"
button.BackgroundTransparency = 1
button.Text = ""
button.Size = UDim2.new(1, 0, 1, 0)
button.Position = UDim2.new(0, 0, 0, 0)
button.AutoButtonColor = false
button.ZIndex = 7
button.Parent = row
local track = Instance.new("Frame")
track.Name = "Track"
track.BackgroundColor3 = Color3.fromRGB(255,255,255)
track.BackgroundTransparency = 0.2
track.Size = UDim2.new(0, 34, 0, 18)
track.Position = UDim2.new(1, -44, 0.5, -9)
track.BorderSizePixel = 0
track.ZIndex = 5
track.Parent = button
corner(track, 9)
stroke(track, COLORS.strokeSoft, 1, 0.45)
local knob = Instance.new("Frame")
knob.Name = "Knob"
knob.BackgroundColor3 = Color3.fromRGB(18,18,22)
knob.Size = UDim2.new(0, 13, 0, 13)
knob.Position = default and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
knob.BorderSizePixel = 0
knob.ZIndex = 6
knob.Parent = track
corner(knob, 999)
local shine = Instance.new("Frame")
shine.Name = "Shine"
shine.BackgroundColor3 = COLORS.white
shine.BackgroundTransparency = 0.72
shine.Size = UDim2.new(1, -4, 0, 4)
shine.Position = UDim2.new(0, 2, 0, 2)
shine.BorderSizePixel = 0
shine.ZIndex = 7
shine.Parent = knob
corner(shine, 4)
local state = default and true or false
local trackStroke = track:FindFirstChildOfClass("UIStroke")
local rowStroke = row:FindFirstChildOfClass("UIStroke")
local function setVisual(on)
state = on and true or false
tween(knob, {
Position = state and UDim2.new(1,-16,0.5,-6) or UDim2.new(0,3,0.5,-6),
BackgroundColor3 = Color3.fromRGB(18,18,22)
})
tween(track, {
--Leaked By Xlu0 AndPrime--
--Leaked By Xlu0 AndPrime--
BackgroundColor3 = Color3.fromRGB(255,255,255),
BackgroundTransparency = 0.2
})
if trackStroke then
tween(trackStroke, {
Color = Color3.fromRGB(255,255,255),
Transparency = 0.45,
Thickness = 1
})
end
if rowStroke then
rowStroke.Thickness = 1.15
end
row.BackgroundTransparency = 0.3
end
setVisual(state)
button.Activated:Connect(function()
end)
return row, setVisual
end
_G.AdaptSyncToggleVisuals = function()
pcall(function() if setAutoStealVisual then setAutoStealVisual(autoStealEnabled == true) end end)
pcall(function() if setInfJumpVisual then setInfJumpVisual(infJumpEnabled == true) end end)
pcall(function() if setAntiRagdollVisual then setAntiRagdollVisual(antiRagdollEnabled == true) end end)
pcall(function() if setAutoCarrySpeedVisual then setAutoCarrySpeedVisual(autoCarrySpeedEnabled == true) end end)
pcall(function() if setAutoTPVisual then setAutoTPVisual(autoTPEnabled == true) end end)
pcall(function() if setAutoResetOnMedVisual then setAutoResetOnMedVisual(autoResetOnMedEnabled == true) end end)
end
_G.AdaptActionToggleRow = function(parent, labelText, default, order)
local row = baseRow(parent, labelText, order)
local button = Instance.new("TextButton")
button.Name = "ToggleButton"
button.BackgroundTransparency = 1
button.Text = ""
button.Size = UDim2.new(1, 0, 1, 0)
button.Position = UDim2.new(0, 0, 0, 0)
button.AutoButtonColor = false
button.ZIndex = 7
button.Parent = row
local track = Instance.new("Frame")
track.Name = "Track"
track.BackgroundColor3 = Color3.fromRGB(255,255,255)
track.BackgroundTransparency = 0.2
track.Size = UDim2.new(0, 34, 0, 18)
track.Position = UDim2.new(1, -44, 0.5, -9)
track.BorderSizePixel = 0
track.ZIndex = 5
track.Parent = button
corner(track, 9)
stroke(track, COLORS.strokeSoft, 1, 0.45)
local knob = Instance.new("Frame")
knob.Name = "Knob"
knob.BackgroundColor3 = Color3.fromRGB(18,18,22)
knob.Size = UDim2.new(0, 13, 0, 13)
knob.Position = default and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
knob.BorderSizePixel = 0
knob.ZIndex = 6
knob.Parent = track
corner(knob, 999)
local shine = Instance.new("Frame")
shine.Name = "Shine"
shine.BackgroundColor3 = COLORS.white
shine.BackgroundTransparency = 0.72
shine.Size = UDim2.new(1, -4, 0, 4)
shine.Position = UDim2.new(0, 2, 0, 2)
shine.BorderSizePixel = 0
shine.ZIndex = 7
shine.Parent = knob
corner(shine, 4)
local trackStroke = track:FindFirstChildOfClass("UIStroke")
local rowStroke = row:FindFirstChildOfClass("UIStroke")
local function setVisual(on)
local state = on and true or false
tween(knob, {
Position = state and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
BackgroundColor3 = Color3.fromRGB(18,18,22)
})
tween(track, {
BackgroundTransparency = 0.2,
BackgroundColor3 = Color3.fromRGB(255,255,255)
})
if trackStroke then
tween(trackStroke, {
Color = Color3.fromRGB(255,255,255),
Transparency = 0.45,
Thickness = 1
})
end
if rowStroke then
tween(rowStroke, {
Color = state and Color3.fromRGB(245, 245, 255) or COLORS.strokeSoft,
Transparency = state and 0.12 or 0.38,
Thickness = state and 1.25 or 1.15
})
end
tween(row, {BackgroundTransparency = 0.3})
end
setVisual(default)
return row, setVisual, button
end
function dropdownRow(parent, labelText, value, order)
local row = baseRow(parent, labelText, order)
local select = Instance.new("TextButton")
select.Name = "Dropdown"
select.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
select.BackgroundTransparency = 0.18
select.Text = tostring(value or "None") .. "  ▼"
select.TextColor3 = COLORS.white
select.TextSize = 11
select.Font = Enum.Font.GothamMedium
select.Size = UDim2.new(0, 70, 0, 24)
select.Position = UDim2.new(1, -80, 0.5, -12)
select.BorderSizePixel = 0
select.ZIndex = 6
select.Parent = row
corner(select, 7)
stroke(select, COLORS.strokeSoft, 1, 0.45)
return row, select
end
function refreshAnimationPackRow()
local displayName = tostring(selectedAnimationPack or "OFF")

if animationPackValueLabel and animationPackValueLabel.Parent then
animationPackValueLabel.Text = displayName
end

--Leaked By Xlu0 AndPrime--
--Leaked By Xlu0 AndPrime--
--Leaked By Xlu0 AndPrime--
pcall(function()
    if pages and pages.VISUALS then
        for _, obj in ipairs(pages.VISUALS:GetDescendants()) do
            if obj:IsA("TextLabel") and obj.Name == "AnimationPackValue" then
                obj.Text = displayName
            end
        end
    end
end)
end
function animationPackRow(parent, order)
local row = baseRow(parent, "Animation Pack", order)
row.Size = UDim2.new(1,-4,0,52)
row.BackgroundTransparency = 1
local animRowStroke = row:FindFirstChildOfClass("UIStroke")
if animRowStroke then animRowStroke.Transparency = 1 end
local label = row:FindFirstChild("Label")
if label then
label.Text = "Animation Pack"
label.Position = UDim2.new(0,2,0,0)
label.Size = UDim2.new(1,0,0,16)
label.TextSize = 12
label.Font = Enum.Font.GothamBlack
end
local left = Instance.new("TextButton")
left.Name = "LeftArrow"
left.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
left.BackgroundTransparency = 0.18
left.Text = "<"
left.TextColor3 = COLORS.white
left.TextSize = 12
left.Font = Enum.Font.GothamMedium
left.Size = UDim2.new(0,44,0,25)
left.Position = UDim2.new(0,0,0,22)
left.BorderSizePixel = 0
left.ZIndex = 6
left.Parent = row
corner(left, 7)
stroke(left, COLORS.strokeSoft, 1, 0.45)
animationPackValueLabel = Instance.new("TextLabel")
animationPackValueLabel.Name = "AnimationPackValue"
animationPackValueLabel.BackgroundColor3 = Color3.fromRGB(8,8,12)
animationPackValueLabel.BackgroundTransparency = 0.18
animationPackValueLabel.BorderSizePixel = 0
animationPackValueLabel.Text = selectedAnimationPack
animationPackValueLabel.TextColor3 = COLORS.white
animationPackValueLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
animationPackValueLabel.TextStrokeTransparency = 1
animationPackValueLabel.TextSize = 11
animationPackValueLabel.Font = Enum.Font.GothamMedium
animationPackValueLabel.TextXAlignment = Enum.TextXAlignment.Center
animationPackValueLabel.Size = UDim2.new(1,-96,0,28)
animationPackValueLabel.Position = UDim2.new(0,48,0,22)
animationPackValueLabel.ZIndex = 6
animationPackValueLabel.Parent = row
corner(animationPackValueLabel,7)
stroke(animationPackValueLabel,COLORS.strokeSoft,1,0.45)

--Leaked By Xlu0 AndPrime--
local rowAnimationPackValueLabel = animationPackValueLabel

local more = Instance.new("TextButton")
more.Name = "MoreAnimations"
more.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
more.BackgroundTransparency = 0.18
more.Text = "MORE"
more.TextColor3 = COLORS.white
more.TextSize = 9
more.Font = Enum.Font.GothamMedium
more.Size = UDim2.new(0, 52, 0, 28)
more.Position = UDim2.new(0, 116, 0.5, -14)
more.BorderSizePixel = 0
more.ZIndex = 6
more.Parent = row
more.Visible = false
corner(more, 8)
stroke(more, COLORS.strokeSoft, 1, 0.45)

local function getPackThumb(packName)
    if packName == "OFF" then
        local ok, img = pcall(function()
            return Players:GetUserThumbnailAsync(
                LP.UserId,
                Enum.ThumbnailType.AvatarBust,
                Enum.ThumbnailSize.Size150x150
            )
        end)
        if ok then return img end
        return ""
    end
    if packName == "Unwalk" then
        return "rbxassetid://71408678974152"
    end
    local pack = AnimationPacks[packName]
    local idle = pack and pack.idle and pack.idle[1] and pack.idle[1][1]
    local id = idle and tostring(idle):match("(%d+)")
    if id then
        return "rbxthumb://type=Asset&id=" .. id .. "&w=150&h=150"
    end
    return ""
end



local function resolveBundleMappings(bundledItems)
    local mappings = {}
    if type(bundledItems) ~= "table" then return mappings end

    for _, assetIds in pairs(bundledItems) do
        if type(assetIds) == "table" then
            for _, assetId in pairs(assetIds) do
                local success, objects = pcall(function()
                    return game:GetObjects("rbxassetid://" .. tostring(assetId))
                end)
                if success and objects then
                    local function searchTree(parent, parentPath)
                        for _, child in pairs(parent:GetChildren()) do
                            if child:IsA("Animation") then
                                local animationPath = parentPath .. "." .. child.Name
                                local pathParts = animationPath:split(".")
                                table.insert(mappings, {
                                    category = pathParts[#pathParts - 1],
                                    name = pathParts[#pathParts],
                                    animationId = child.AnimationId
                                })
                            elseif #child:GetChildren() > 0 then
                                searchTree(child, parentPath .. "." .. child.Name)
                            end
                        end
                    end

                    for _, obj in pairs(objects) do
                        searchTree(obj, obj.Name)
                        pcall(function() obj:Destroy() end)
                    end
                end
            end
        end
    end
    return mappings
end

applyFullAnimationBundle = function(animationData)
    local char = LP.Character
    local animate = char and char:FindFirstChild("Animate")
    if not char or not animate then return end

    backupAnimations(char)
    if unwalkEnabled then
        disableUnwalk()
        animate = char:FindFirstChild("Animate") or char:WaitForChild("Animate", 2)
        if not animate then return end
    end

    local mappings = resolveBundleMappings(animationData.bundledItems)
    if #mappings == 0 then
        if showActionNotification then
            pcall(function() showActionNotification("ANIMATION DATA NOT FOUND") end)
        end
        return
    end

    stopCurrentAnimations(char)

    for _, m in ipairs(mappings) do
        local cat = tostring(m.category or ""):lower()
        local name = tostring(m.name or "")
        local folder = animate:FindFirstChild(cat)
        if folder then
            local target = folder:FindFirstChild(name)
            if not target then
                if cat == "walk" then target = folder:FindFirstChild("WalkAnim")
                elseif cat == "run" then target = folder:FindFirstChild("RunAnim")
                elseif cat == "jump" then target = folder:FindFirstChild("JumpAnim")
                elseif cat == "fall" then target = folder:FindFirstChild("FallAnim")
                elseif cat == "climb" then target = folder:FindFirstChild("ClimbAnim")
                elseif cat == "swim" then target = folder:FindFirstChild("Swim")
                elseif cat == "swimidle" then target = folder:FindFirstChild("SwimIdle")
                elseif cat == "idle" then
                    target = folder:FindFirstChild(name) or folder:FindFirstChild("Animation1")
                end
            end
            setAnimId(target, m.animationId)
        end
    end

    reloadAnimate(animate)

    _G.AdaptSelectedMoreAnimationBundle = {
        id = animationData.id,
        name = animationData.name,
        bundledItems = animationData.bundledItems
    }

    selectedAnimationPack = "OFF"
    syncAnimationPackIndex()
    if refreshAnimationPackRow then refreshAnimationPackRow() end
    if saveAdaptConfig then do end end

    if showActionNotification then
        pcall(function() showActionNotification("ANIMATION - " .. tostring(animationData.name or animationData.id)) end)
    end
end

local function openAnimationGallery()
    local existing = PlayerGui:FindFirstChild("AdaptAnimationGallery")
    if existing then existing:Destroy() end

    local sg = Instance.new("ScreenGui")
    sg.Name = "AdaptAnimationGallery"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 99999
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    safeParentGui(sg)

    local shade = Instance.new("TextButton")
    shade.Text = ""
    shade.AutoButtonColor = false
    shade.BackgroundColor3 = Color3.fromRGB(0,0,0)
    shade.BackgroundTransparency = 0.25
    shade.Size = UDim2.fromScale(1,1)
    shade.ZIndex = 1
    shade.Parent = sg

    local panel = Instance.new("Frame")
    panel.AnchorPoint = Vector2.new(0.5,0.5)
    panel.Position = UDim2.fromScale(0.5,0.5)
    panel.Size = UDim2.new(0, 540, 0, 480)
    panel.BackgroundColor3 = Color3.fromRGB(10,10,15)
    panel.BackgroundTransparency = 0.04
    panel.BorderSizePixel = 0
    panel.ZIndex = 2
    panel.Parent = sg
    corner(panel,16)
    stroke(panel,COLORS.strokeSoft,1.2,0.15)

    pcall(function()
        local selectedColor = (_G.AdaptThemeColors and _G.AdaptThemeColors[_G.AdaptThemeName])
            or Color3.fromRGB(255,255,255)

        panel.BackgroundColor3 = selectedColor:Lerp(Color3.fromRGB(8,8,12), 0.78)

        local exactImage = nil
        local exactColor = selectedColor
        local exactTransparency = 0

        --Leaked By Xlu0 AndPrime--
        if BgImage and BgImage.Parent and BgImage.Visible and BgImage.Image and BgImage.Image ~= "" then
            exactImage = BgImage.Image
            exactColor = BgImage.ImageColor3
            exactTransparency = BgImage.ImageTransparency
        elseif currentBackground and tonumber(currentBackground) and tonumber(currentBackground) > 0
            and BackgroundIDs and BackgroundIDs[tonumber(currentBackground)] then
            exactImage = "rbxassetid://" .. tostring(BackgroundIDs[tonumber(currentBackground)])
        end

        if exactImage and exactImage ~= "" then
            local image = Instance.new("ImageLabel")
            image.Name = "ThemeBackground"
            image.BackgroundTransparency = 1
            image.Size = UDim2.fromScale(1,1)
            image.Position = UDim2.fromScale(0,0)
            image.Image = exactImage
            image.ImageColor3 = exactColor
            image.ImageTransparency = exactTransparency
            image.ScaleType = Enum.ScaleType.Crop
            image.ZIndex = 2
            image.Parent = panel
            corner(image,16)

            local wash = Instance.new("Frame")
            wash.Name = "BackgroundWash"
            wash.BackgroundColor3 = Color3.fromRGB(0,0,0)
            wash.BackgroundTransparency = 0.52
            wash.BorderSizePixel = 0
            wash.Size = UDim2.fromScale(1,1)
            wash.ZIndex = 2
            wash.Parent = panel
            corner(wash,16)
        end
    end)

    if UserInputService.TouchEnabled then
        panel.Size = UDim2.new(0.95,0,0.80,0)
    end

    --Leaked By Xlu0 AndPrime--
    do
        local dragging = false
        local dragStart = nil
        local startPos = nil

        local function updateDrag(input)
            if not dragging or not dragStart or not startPos then return end
            local delta = input.Position - dragStart
            panel.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end

        panel.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = panel.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                updateDrag(input)
            end
        end)
    end

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Text = "ALL ANIMATION BUNDLES"
    title.TextColor3 = COLORS.white
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Position = UDim2.new(0,16,0,10)
    title.Size = UDim2.new(1,-60,0,28)
    title.ZIndex = 3
    title.Parent = panel

    local sub = Instance.new("TextLabel")
    sub.BackgroundTransparency = 1
    sub.Text = "Online + Offsale animation bundles"
    sub.TextColor3 = Color3.fromRGB(175,175,185)
    sub.Font = Enum.Font.GothamMedium
    sub.TextSize = 11
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Position = UDim2.new(0,16,0,34)
    sub.Size = UDim2.new(1,-60,0,20)
    sub.ZIndex = 3
    sub.Parent = panel

    local close = Instance.new("TextButton")
    close.Text = "X"
    close.Font = Enum.Font.GothamMedium
    close.TextSize = 12
    close.TextColor3 = COLORS.white
    close.BackgroundColor3 = Color3.fromRGB(18,18,24)
    close.BackgroundTransparency = 0.08
    close.Size = UDim2.fromOffset(32,32)
    close.Position = UDim2.new(1,-42,0,8)
    close.BorderSizePixel = 0
    close.ZIndex = 4
    close.Parent = panel
    corner(close,9)

    local searchBox = Instance.new("TextBox")
    searchBox.PlaceholderText = "Search bundle / ID..."
    searchBox.Text = ""
    searchBox.ClearTextOnFocus = false
    searchBox.Font = Enum.Font.GothamMedium
    searchBox.TextSize = 12
    searchBox.TextColor3 = COLORS.white
    searchBox.PlaceholderColor3 = Color3.fromRGB(135,135,145)
    searchBox.BackgroundColor3 = Color3.fromRGB(16,16,22)
    searchBox.BackgroundTransparency = 0.06
    searchBox.BorderSizePixel = 0
    searchBox.Position = UDim2.new(0,14,0,60)
    searchBox.Size = UDim2.new(1,-28,0,32)
    searchBox.ZIndex = 3
    searchBox.Parent = panel
    corner(searchBox,9)
    stroke(searchBox,COLORS.strokeSoft,1,0.5)

    local scroll = Instance.new("ScrollingFrame")
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.Position = UDim2.new(0,10,0,102)
    scroll.Size = UDim2.new(1,-20,1,-116)
    scroll.ScrollBarThickness = 4
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.ZIndex = 3
    scroll.Parent = panel

    local grid = Instance.new("UIGridLayout")
    grid.CellSize = UDim2.fromOffset(122,145)
    grid.CellPadding = UDim2.fromOffset(8,8)
    grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
    grid.SortOrder = Enum.SortOrder.LayoutOrder
    grid.Parent = scroll

    local status = Instance.new("TextLabel")
    status.BackgroundTransparency = 1
    status.Text = "Loading..."
    status.TextColor3 = Color3.fromRGB(160,160,170)
    status.Font = Enum.Font.GothamMedium
    status.TextSize = 10
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Position = UDim2.new(0,16,1,-27)
    status.Size = UDim2.new(1,-32,0,20)
    status.ZIndex = 4
    status.Parent = panel

    local allAnimations = {}

    local function clearCards()
        for _, child in ipairs(scroll:GetChildren()) do
            if child:IsA("GuiButton") then child:Destroy() end
        end
    end

    local function addCard(item, order)
        local card = Instance.new("TextButton")
        card.Text = ""
        card.AutoButtonColor = false
        card.BackgroundColor3 = Color3.fromRGB(16,16,22)
        card.BackgroundTransparency = 0.07
        card.BorderSizePixel = 0
        card.LayoutOrder = order
        card.ZIndex = 4
        card.Parent = scroll
        corner(card,11)
        stroke(card,COLORS.strokeSoft,1,0.55)

        local img = Instance.new("ImageLabel")
        img.BackgroundColor3 = Color3.fromRGB(7,7,11)
        img.BackgroundTransparency = 0.12
        img.BorderSizePixel = 0
        img.Image = "rbxthumb://type=BundleThumbnail&id=" .. tostring(item.id) .. "&w=150&h=150"
        img.ScaleType = Enum.ScaleType.Fit
        img.Position = UDim2.new(0,7,0,7)
        img.Size = UDim2.new(1,-14,0,92)
        img.ZIndex = 5
        img.Parent = card
        corner(img,8)

        local name = Instance.new("TextLabel")
        name.BackgroundTransparency = 1
        name.Text = tostring(item.name or ("Animation " .. tostring(item.id)))
        name.TextColor3 = COLORS.white
        name.Font = Enum.Font.GothamMedium
        name.TextSize = 10
        name.TextWrapped = true
        name.TextYAlignment = Enum.TextYAlignment.Top
        name.Position = UDim2.new(0,6,0,104)
        name.Size = UDim2.new(1,-12,0,32)
        name.ZIndex = 5
        name.Parent = card

        card.MouseButton1Click:Connect(function()
            applyFullAnimationBundle(item)
            if sg and sg.Parent then
                sg:Destroy()
            end
        end)
    end

    local function render()
        clearCards()
        local q = (searchBox.Text or ""):lower()
        local count = 0
        for _, item in ipairs(allAnimations) do
            local match = q == "" or tostring(item.id) == q or tostring(item.name or ""):lower():find(q,1,true)
            if match then
                count += 1
                addCard(item,count)
            end
        end
        status.Text = tostring(count) .. " animation bundles"
    end

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        task.defer(render)
    end)

    close.MouseButton1Click:Connect(function() sg:Destroy() end)
    --Leaked By Xlu0 AndPrime--

    task.spawn(function()
        local seen = {}
        local urls = {
            "https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/AnimationSniper.json",
            "https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/AnimationSniperoffsale.json"
        }

        for _, url in ipairs(urls) do
            local ok, body = pcall(function() return game:HttpGet(url) end)
            if ok and body and body ~= "" then
                local ok2, data = pcall(function() return HttpService:JSONDecode(body) end)
                if ok2 and data then
                    for _, item in pairs(data.data or {}) do
                        local id = tonumber(item.id)
                        if id and id > 0 and not seen[id] and item.bundledItems then
                            seen[id] = true
                            table.insert(allAnimations, {
                                id = id,
                                name = item.name or ("Animation_" .. tostring(id)),
                                bundledItems = item.bundledItems
                            })
                        end
                    end
                end
            end
        end

        table.sort(allAnimations,function(a,b)
            return tostring(a.name or ""):lower() < tostring(b.name or ""):lower()
        end)
        render()
    end)
end

more.MouseButton1Click:Connect(openAnimationGallery)

local right = Instance.new("TextButton")
right.Name = "RightArrow"
right.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
right.BackgroundTransparency = 0.18
right.Text = ">"
right.TextColor3 = COLORS.white
right.TextSize = 12
right.Font = Enum.Font.GothamMedium
right.Size = UDim2.new(0,44,0,25)
right.Position = UDim2.new(1,-44,0,22)
right.BorderSizePixel = 0
right.ZIndex = 6
right.Parent = row
corner(right, 7)
stroke(right, COLORS.strokeSoft, 1, 0.45)
local function setPackIndex(nextIndex)
if nextIndex < 1 then nextIndex = #AnimationPackList end
if nextIndex > #AnimationPackList then nextIndex = 1 end

AnimationPackIndex = nextIndex
local chosenPack = AnimationPackList[AnimationPackIndex] or "OFF"
_G.AdaptSelectedMoreAnimationBundle = nil

--Leaked By Xlu0 AndPrime--
selectedAnimationPack = chosenPack

--Leaked By Xlu0 AndPrime--
if rowAnimationPackValueLabel and rowAnimationPackValueLabel.Parent then
    rowAnimationPackValueLabel.Text = chosenPack
end
refreshAnimationPackRow()

--Leaked By Xlu0 AndPrime--
--Leaked By Xlu0 AndPrime--
applyAnimationPack(chosenPack)

--Leaked By Xlu0 AndPrime--
task.defer(function()
    if rowAnimationPackValueLabel and rowAnimationPackValueLabel.Parent then
        rowAnimationPackValueLabel.Text = chosenPack
    end
    if selectedAnimationPack == chosenPack then
        refreshAnimationPackRow()
    end
end)

if saveAdaptConfig then pcall(saveAdaptConfig) end
end
left.MouseButton1Click:Connect(function()
setPackIndex(AnimationPackIndex - 1)
end)
right.MouseButton1Click:Connect(function()
setPackIndex(AnimationPackIndex + 1)
end)
return row
end
function keyName(key)
if not key then return "None" end
local name = tostring(key):gsub("Enum.KeyCode.", "")
name = name:gsub("Button", "BTN ")
name = name:gsub("DPad", "DPad ")
return name
end
function refreshSpeedKeybindButton(keyId)
local btn = speedKeybindButtons[keyId]
if btn then
if listeningForSpeedKey == keyId then
btn.Text = "Press..."
else
btn.Text = keyName(speedKeybinds[keyId])
end
end
end
function refreshAllSpeedKeybinds()
for keyId in pairs(speedKeybindButtons) do
refreshSpeedKeybindButton(keyId)
end
end
function refreshTPDownKeybind()
if tpDownKeybindButton then
tpDownKeybindButton.Text = listeningForTPDownKey and "Press..." or keyName(tpDownKeybind)
end
end
function tpDownKeybindRow(parent, order)
local row = baseRow(parent, "TP Down", order)
local btn = Instance.new("TextButton")
btn.Name = "TPDownKeybindButton"
btn.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
btn.BackgroundTransparency = 0.18
btn.Text = keyName(tpDownKeybind)
btn.TextColor3 = COLORS.white
btn.TextSize = 11
btn.Font = Enum.Font.GothamMedium
btn.Size = UDim2.new(0, 56, 0, 24)
btn.Position = UDim2.new(1, -64, 0.5, -12)
btn.BorderSizePixel = 0
btn.ZIndex = 6
btn.AutoButtonColor = false
btn.Parent = row
corner(btn, 14)
stroke(btn, COLORS.strokeSoft, 1, 0.45)
local clearBtn = Instance.new("TextButton")
clearBtn.Name = "ClearKeybindButton"
clearBtn.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
clearBtn.BackgroundTransparency = 0.18
clearBtn.Text = "×"
clearBtn.TextColor3 = COLORS.white
clearBtn.TextSize = 14
clearBtn.Font = Enum.Font.GothamMedium
clearBtn.Size = UDim2.new(0, 22, 0, 24)
clearBtn.Position = UDim2.new(1, -90, 0.5, -12)
clearBtn.BorderSizePixel = 0
clearBtn.ZIndex = 6
clearBtn.AutoButtonColor = false
clearBtn.Parent = row
corner(clearBtn, 7)
stroke(clearBtn, COLORS.strokeSoft, 1, 0.45)
tpDownKeybindButton = btn
btn.Activated:Connect(function()
listeningForSpeedKey = nil
listeningForTPDownKey = true
keybindListenStartedAt = tick()
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
end)
clearBtn.Activated:Connect(function()
listeningForSpeedKey = nil
listeningForTPDownKey = false
tpDownKeybind = nil
if tpDownKeybindButton then tpDownKeybindButton.Text = "None" end
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
do end
end)
return row, btn
end
function speedKeybindRow(parent, labelText, keyId, order)
local row = baseRow(parent, labelText, order)
local btn = Instance.new("TextButton")
btn.Name = "KeybindButton"
btn.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
btn.BackgroundTransparency = 0.18
btn.Text = keyName(speedKeybinds[keyId])
btn.TextColor3 = COLORS.white
btn.TextSize = 11
btn.Font = Enum.Font.GothamMedium
btn.Size = UDim2.new(0, 56, 0, 24)
btn.Position = UDim2.new(1, -64, 0.5, -12)
btn.BorderSizePixel = 0
btn.ZIndex = 6
btn.AutoButtonColor = false
btn.Parent = row
corner(btn, 14)
stroke(btn, COLORS.strokeSoft, 1, 0.45)
local clearBtn = Instance.new("TextButton")
clearBtn.Name = "ClearKeybindButton"
clearBtn.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
clearBtn.BackgroundTransparency = 0.18
clearBtn.Text = "×"
clearBtn.TextColor3 = COLORS.white
clearBtn.TextSize = 14
clearBtn.Font = Enum.Font.GothamMedium
clearBtn.Size = UDim2.new(0, 22, 0, 24)
clearBtn.Position = UDim2.new(1, -90, 0.5, -12)
clearBtn.BorderSizePixel = 0
clearBtn.ZIndex = 6
clearBtn.AutoButtonColor = false
clearBtn.Parent = row
corner(clearBtn, 7)
stroke(clearBtn, COLORS.strokeSoft, 1, 0.45)
speedKeybindButtons[keyId] = btn
btn.Activated:Connect(function()
listeningForSpeedKey = keyId
listeningForTPDownKey = false
keybindListenStartedAt = tick()
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
end)
clearBtn.Activated:Connect(function()
listeningForSpeedKey = nil
listeningForTPDownKey = false
speedKeybinds[keyId] = nil
if speedKeybindButtons[keyId] then speedKeybindButtons[keyId].Text = "None" end
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
do end
end)
return row, btn
end
local normalModeValueLabel = nil
local laggerModeValueLabel = nil
local aimbotButtonLabel = nil
local aimbotSpeedLabel = nil
local laggerAimbotSpeedLabel = nil
local combatAimbotKeybindLabel = nil
function getAimbotModeDisplay()
if selectedAimbotMode == "Anti Bypass" or selectedAimbotMode == "Bypass" then
return "Anti Bypass"
end
return "Normal"
end
function refreshAimbotButtonLabel()
if aimbotButtonLabel then
aimbotButtonLabel.Text = getAimbotModeDisplay() .. " Aimbot"
end
end
function refreshAimbotModeLabels()
local modeName = getAimbotModeDisplay()
if aimbotSpeedLabel then
aimbotSpeedLabel.Text = modeName .. " Aimbot Speed"
end
if laggerAimbotSpeedLabel then
laggerAimbotSpeedLabel.Text = modeName .. " Lagger Aimbot Speed"
end
if combatAimbotKeybindLabel then
combatAimbotKeybindLabel.Text = modeName .. " Aimbot"
end
refreshAimbotButtonLabel()
end
refreshSpeedModeRows = function()
if normalModeValueLabel then
normalModeValueLabel.Text = (currentSpeedMode == "Carry") and "Carry" or "Normal"
end
if laggerModeValueLabel then
laggerModeValueLabel.Text = (currentSpeedMode == "Lagger Carry") and "Lagger Carry" or "Lagger"
end
end
function modeDisplayRow(parent, order, side)
local row = baseRow(parent, "Mode", order)
row.Size = UDim2.new(1, -4, 0, 34)
row.BackgroundTransparency = 0.3
local label = row:FindFirstChild("Label")
if label then
label.Text = "Mode"
label.TextSize = 11
label.Size = UDim2.new(1, -132, 1, 0)
label.Position = UDim2.new(0, 12, 0, 0)
label.TextColor3 = Color3.fromRGB(245, 245, 255)
end
local value = Instance.new("TextLabel")
value.Name = "ModeValue"
value.BackgroundTransparency = 1
value.Text = side == "Normal" and "Normal" or "Lagger"
value.TextColor3 = Color3.fromRGB(255, 255, 255)
value.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
value.TextStrokeTransparency = 1
value.TextSize = 12
value.Font = Enum.Font.GothamMedium
value.TextXAlignment = Enum.TextXAlignment.Right
value.Position = UDim2.new(1, -150, 0, 0)
value.Size = UDim2.new(0, 138, 1, 0)
value.ZIndex = 6
value.Parent = row
local click = Instance.new("TextButton")
click.Name = "ModeClick"
click.BackgroundTransparency = 1
click.Text = ""
click.Size = UDim2.new(1, 0, 1, 0)
click.Position = UDim2.new(0, 0, 0, 0)
click.AutoButtonColor = false
click.ZIndex = 8
click.Parent = row
if side == "Normal" then
normalModeValueLabel = value
click.MouseButton1Click:Connect(function()
setSpeedMode(currentSpeedMode == "Normal" and "Carry" or "Normal")
end)
else
laggerModeValueLabel = value
click.MouseButton1Click:Connect(function()
setSpeedMode(currentSpeedMode == "Lagger" and "Lagger Carry" or "Lagger")
end)
end
refreshSpeedModeRows()
return row, value
end
function aimbotModeButtonRow(parent, order)
local row, setVisual = toggleRow(parent, tostring(selectedAimbotMode) .. " Aimbot", false, order)
aimbotButtonLabel = row and row:FindFirstChild("Label")
_G.AdaptAimbotSetVisual = setVisual
refreshAimbotButtonLabel()
if _G.AdaptRefreshAimbotVisual then _G.AdaptRefreshAimbotVisual() end

local toggleBtn = row and row:FindFirstChild("ToggleButton")
if toggleBtn then
toggleBtn.Size = UDim2.new(0, 54, 1, 0)
toggleBtn.Position = UDim2.new(1, -54, 0, 0)
toggleBtn.Activated:Connect(function()
if _G.AdaptToggleSelectedAimbot then
_G.AdaptToggleSelectedAimbot()
end
end)
end

local arrow = Instance.new("TextButton")
arrow.Name = "ArrowButton"
arrow.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
arrow.BackgroundTransparency = 0.18
arrow.BorderSizePixel = 0
arrow.Text = "▼"
arrow.TextColor3 = COLORS.white
arrow.TextSize = 18
arrow.Font = Enum.Font.GothamBlack
arrow.AutoButtonColor = false
arrow.Size = UDim2.new(0, 38, 0, 26)
arrow.Position = UDim2.new(1, -100, 0.5, -13)
arrow.ZIndex = 20
arrow.Parent = row
corner(arrow, 7)
stroke(arrow, COLORS.strokeSoft, 1.2, 0.25)

return row, setVisual, arrow
end
_G.AdaptAimbotSelectorRow = function(parent, order)
local holder = Instance.new("Frame")
holder.Name = "Aimbot Mode"
holder.BackgroundColor3 = COLORS.row
holder.BackgroundTransparency = 0.28
holder.Size = UDim2.new(1, -4, 0, 42)
holder.BorderSizePixel = 0
holder.LayoutOrder = order
holder.ZIndex = 4
holder.ClipsDescendants = true
holder.Parent = parent
corner(holder, 9)
stroke(holder, COLORS.strokeSoft, 1.15, 0.38)
local slide = Instance.new("Frame")
slide.Name = "SelectedSlide"
slide.BackgroundColor3 = Color3.fromRGB(58, 58, 64)
slide.BackgroundTransparency = 0.08
slide.Size = UDim2.new(0.5, -3, 1, -8)
slide.Position = UDim2.new(0, 4, 0, 4)
slide.BorderSizePixel = 0
slide.ZIndex = 5
slide.Parent = holder
corner(slide, 9)
local slideStroke = Instance.new("UIStroke")
slideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
slideStroke.Color = Color3.fromRGB(235, 235, 245)
slideStroke.Thickness = 1
slideStroke.Transparency = 0.08
slideStroke.Parent = slide
local slideGradient = Instance.new("UIGradient")
slideGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 28)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(46, 46, 52)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 22)),
})
slideGradient.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.08),
NumberSequenceKeypoint.new(0.5, 0.02),
NumberSequenceKeypoint.new(1, 0.08),
})
slideGradient.Parent = slide
local normalText = Instance.new("TextLabel")
normalText.Name = "NormalText"
normalText.BackgroundTransparency = 1
normalText.Text = "NORMAL"
normalText.TextColor3 = COLORS.white
normalText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
normalText.TextStrokeTransparency = 1
normalText.TextSize = 11
normalText.Font = Enum.Font.GothamMedium
normalText.TextXAlignment = Enum.TextXAlignment.Center
normalText.Size = UDim2.new(0.5, 0, 1, 0)
normalText.Position = UDim2.new(0, 0, 0, 0)
normalText.ZIndex = 8
normalText.Parent = holder
local bypassText = Instance.new("TextLabel")
bypassText.Name = "BypassText"
bypassText.BackgroundTransparency = 1
bypassText.Text = "BYPASS"
bypassText.TextColor3 = COLORS.white
bypassText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
bypassText.TextStrokeTransparency = 1
bypassText.TextSize = 10
bypassText.Font = Enum.Font.GothamMedium
bypassText.TextXAlignment = Enum.TextXAlignment.Center
bypassText.Size = UDim2.new(0.5, 0, 1, 0)
bypassText.Position = UDim2.new(0.5, 0, 0, 0)
bypassText.ZIndex = 8
bypassText.Parent = holder
local normalClick = Instance.new("TextButton")
normalClick.Name = "NormalClick"
normalClick.BackgroundTransparency = 1
normalClick.Text = ""
normalClick.AutoButtonColor = false
normalClick.Size = UDim2.new(0.5, 0, 1, 0)
normalClick.Position = UDim2.new(0, 0, 0, 0)
normalClick.ZIndex = 10
normalClick.Parent = holder
local bypassClick = Instance.new("TextButton")
bypassClick.Name = "BypassClick"
bypassClick.BackgroundTransparency = 1
bypassClick.Text = ""
bypassClick.AutoButtonColor = false
bypassClick.Size = UDim2.new(0.5, 0, 1, 0)
bypassClick.Position = UDim2.new(0.5, 0, 0, 0)
bypassClick.ZIndex = 10
bypassClick.Parent = holder
local function setMode(mode)
if mode == "Bypass" then
mode = "Anti Bypass"
elseif mode ~= "Anti Bypass" then
mode = "Normal"
end
selectedAimbotMode = mode
refreshAimbotModeLabels()
if _G.AdaptRefreshAimbotSpeedBoxes then _G.AdaptRefreshAimbotSpeedBoxes() end
if _G.AdaptRefreshAimbotVisual then _G.AdaptRefreshAimbotVisual() end
do end
local onBypass = selectedAimbotMode == "Anti Bypass"
tween(slide, {
Position = onBypass and UDim2.new(0.5, -1, 0, 4) or UDim2.new(0, 4, 0, 4)
}, 0.18)
tween(normalText, {
TextTransparency = onBypass and 0.18 or 0,
TextStrokeTransparency = onBypass and 0.38 or 0.2
}, 0.14)
tween(bypassText, {
TextTransparency = onBypass and 0 or 0.18,
TextStrokeTransparency = onBypass and 0.2 or 0.38
}, 0.14)
end
normalClick.MouseButton1Click:Connect(function()
setMode("Normal")
end)
bypassClick.MouseButton1Click:Connect(function()
setMode("Anti Bypass")
end)
setMode(selectedAimbotMode)
return holder, setMode
end
function autoStealSelectorRow(parent, order)
local holder = Instance.new("Frame")
holder.Name = "Auto Steal Mode"
holder.BackgroundColor3 = COLORS.row
holder.BackgroundTransparency = 0.28
holder.Size = UDim2.new(1, -4, 0, 42)
holder.BorderSizePixel = 0
holder.LayoutOrder = order
holder.ZIndex = 4
holder.ClipsDescendants = true
holder.Parent = parent
corner(holder, 9)
stroke(holder, COLORS.strokeSoft, 1.15, 0.38)
local slide = Instance.new("Frame")
slide.Name = "SelectedSlide"
slide.BackgroundColor3 = Color3.fromRGB(58, 58, 64)
slide.BackgroundTransparency = 0.08
slide.Size = UDim2.new(0.5, -3, 1, -8)
slide.Position = UDim2.new(0, 4, 0, 4)
slide.BorderSizePixel = 0
slide.ZIndex = 5
slide.Parent = holder
corner(slide, 9)
local slideStroke = Instance.new("UIStroke")
slideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
slideStroke.Color = Color3.fromRGB(235, 235, 245)
slideStroke.Thickness = 1
slideStroke.Transparency = 0.08
slideStroke.Parent = slide
local slideGradient = Instance.new("UIGradient")
slideGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 28)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(46, 46, 52)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 22)),
})
slideGradient.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.08),
NumberSequenceKeypoint.new(0.5, 0.02),
NumberSequenceKeypoint.new(1, 0.08),
})
slideGradient.Parent = slide
local normalText = Instance.new("TextLabel")
normalText.Name = "NormalText"
normalText.BackgroundTransparency = 1
normalText.Text = "AUTO STEAL V3"
normalText.TextColor3 = COLORS.white
normalText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
normalText.TextStrokeTransparency = 1
normalText.TextSize = 11
normalText.Font = Enum.Font.GothamMedium
normalText.TextXAlignment = Enum.TextXAlignment.Center
normalText.Size = UDim2.new(0.5, 0, 1, 0)
normalText.Position = UDim2.new(0, 0, 0, 0)
normalText.ZIndex = 8
normalText.Parent = holder
local semiText = Instance.new("TextLabel")
semiText.Name = "SemiText"
semiText.BackgroundTransparency = 1
semiText.Text = "SEMI"
semiText.TextColor3 = COLORS.white
semiText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
semiText.TextStrokeTransparency = 1
semiText.TextSize = 11
semiText.Font = Enum.Font.GothamMedium
semiText.TextXAlignment = Enum.TextXAlignment.Center
semiText.Size = UDim2.new(0.5, 0, 1, 0)
semiText.Position = UDim2.new(0.5, 0, 0, 0)
semiText.ZIndex = 8
semiText.Parent = holder
local normalClick = Instance.new("TextButton")
normalClick.Name = "NormalClick"
normalClick.BackgroundTransparency = 1
normalClick.Text = ""
normalClick.AutoButtonColor = false
normalClick.Size = UDim2.new(0.5, 0, 1, 0)
normalClick.Position = UDim2.new(0, 0, 0, 0)
normalClick.ZIndex = 10
normalClick.Parent = holder
local semiClick = Instance.new("TextButton")
semiClick.Name = "SemiClick"
semiClick.BackgroundTransparency = 1
semiClick.Text = ""
semiClick.AutoButtonColor = false
semiClick.Size = UDim2.new(0.5, 0, 1, 0)
semiClick.Position = UDim2.new(0.5, 0, 0, 0)
semiClick.ZIndex = 10
semiClick.Parent = holder
local function setMode(mode)
if mode ~= "Semi" then
mode = "Auto Steal V3"
end
_G.AdaptStealRadii = _G.AdaptStealRadii or {Normal = 62, Semi = 9}
_G.AdaptStealRadii[selectedStealMode] = tonumber(autoStealRadius) or _G.AdaptStealRadii[selectedStealMode]
selectedStealMode = mode
autoStealRadius = _G.AdaptStealRadii[selectedStealMode] or ((selectedStealMode == "Semi") and 9 or 63)
if autoStealRadiusBox then
autoStealRadiusBox.Text = tostring(autoStealRadius)
end
do end
if _G.AdaptNormalAutoStealSetRadius then _G.AdaptNormalAutoStealSetRadius(_G.AdaptStealRadii.Normal or 62) end
if _G.AdaptSemiAutoStealSetRadius then _G.AdaptSemiAutoStealSetRadius(_G.AdaptStealRadii.Semi or 9) end
if _G.AdaptAutoStealSync then _G.AdaptAutoStealSync() end
local onSemi = selectedStealMode == "Semi"
tween(slide, {
Position = onSemi and UDim2.new(0.5, -1, 0, 4) or UDim2.new(0, 4, 0, 4)
}, 0.18)
tween(normalText, {
TextTransparency = onSemi and 0.18 or 0,
TextStrokeTransparency = onSemi and 0.38 or 0.2
}, 0.14)
tween(semiText, {
TextTransparency = onSemi and 0 or 0.18,
TextStrokeTransparency = onSemi and 0.2 or 0.38
}, 0.14)
end
normalClick.MouseButton1Click:Connect(function()
setMode("Auto Steal V3")
end)
semiClick.MouseButton1Click:Connect(function()
setMode("Semi")
end)
setMode(selectedStealMode)
return holder, setMode
end

function infiniteJumpSelectorRow(parent, order)
local holder = Instance.new("Frame")
holder.Name = "Infinite Jump Mode"
holder.BackgroundColor3 = COLORS.row
holder.BackgroundTransparency = 0.28
holder.Size = UDim2.new(1, -4, 0, 42)
holder.BorderSizePixel = 0
holder.LayoutOrder = order
holder.ZIndex = 4
holder.ClipsDescendants = true
holder.Parent = parent
corner(holder, 9)
stroke(holder, COLORS.strokeSoft, 1.15, 0.38)

local slide = Instance.new("Frame")
slide.Name = "SelectedSlide"
slide.BackgroundColor3 = Color3.fromRGB(58, 58, 64)
slide.BackgroundTransparency = 0.08
slide.Size = UDim2.new(0.5, -3, 1, -8)
slide.Position = UDim2.new(0, 4, 0, 4)
slide.BorderSizePixel = 0
slide.ZIndex = 5
slide.Parent = holder
corner(slide, 9)

local slideStroke = Instance.new("UIStroke")
slideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
slideStroke.Color = Color3.fromRGB(235, 235, 245)
slideStroke.Thickness = 1
slideStroke.Transparency = 0.08
slideStroke.Parent = slide

local slideGradient = Instance.new("UIGradient")
slideGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 28)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(46, 46, 52)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 22)),
})
slideGradient.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.08),
NumberSequenceKeypoint.new(0.5, 0.02),
NumberSequenceKeypoint.new(1, 0.08),
})
slideGradient.Parent = slide

local tapText = Instance.new("TextLabel")
tapText.Name = "TapText"
tapText.BackgroundTransparency = 1
tapText.Text = "TAP"
tapText.TextColor3 = COLORS.white
tapText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
tapText.TextStrokeTransparency = 1
tapText.TextSize = 11
tapText.Font = Enum.Font.GothamMedium
tapText.TextXAlignment = Enum.TextXAlignment.Center
tapText.Size = UDim2.new(0.5, 0, 1, 0)
tapText.Position = UDim2.new(0, 0, 0, 0)
tapText.ZIndex = 8
tapText.Parent = holder

local holdText = Instance.new("TextLabel")
holdText.Name = "HoldText"
holdText.BackgroundTransparency = 1
holdText.Text = "HOLD"
holdText.TextColor3 = COLORS.white
holdText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
holdText.TextStrokeTransparency = 1
holdText.TextSize = 11
holdText.Font = Enum.Font.GothamMedium
holdText.TextXAlignment = Enum.TextXAlignment.Center
holdText.Size = UDim2.new(0.5, 0, 1, 0)
holdText.Position = UDim2.new(0.5, 0, 0, 0)
holdText.ZIndex = 8
holdText.Parent = holder

local tapClick = Instance.new("TextButton")
tapClick.Name = "TapClick"
tapClick.BackgroundTransparency = 1
tapClick.Text = ""
tapClick.AutoButtonColor = false
tapClick.Size = UDim2.new(0.5, 0, 1, 0)
tapClick.Position = UDim2.new(0, 0, 0, 0)
tapClick.ZIndex = 10
tapClick.Parent = holder

local holdClick = Instance.new("TextButton")
holdClick.Name = "HoldClick"
holdClick.BackgroundTransparency = 1
holdClick.Text = ""
holdClick.AutoButtonColor = false
holdClick.Size = UDim2.new(0.5, 0, 1, 0)
holdClick.Position = UDim2.new(0.5, 0, 0, 0)
holdClick.ZIndex = 10
holdClick.Parent = holder

local function setMode(mode)
if mode ~= "Hold" then
mode = "Tap"
end
_G.AdaptInfJumpMode = mode
if _G.AdaptStopNormalInfJumpHoldState then
_G.AdaptStopNormalInfJumpHoldState()
end
do end

local onHold = _G.AdaptInfJumpMode == "Hold"
tween(slide, {
Position = onHold and UDim2.new(0.5, -1, 0, 4) or UDim2.new(0, 4, 0, 4)
}, 0.18)
tween(tapText, {
TextTransparency = onHold and 0.18 or 0,
TextStrokeTransparency = onHold and 0.38 or 0.2
}, 0.14)
tween(holdText, {
TextTransparency = onHold and 0 or 0.18,
TextStrokeTransparency = onHold and 0.2 or 0.38
}, 0.14)
end

tapClick.MouseButton1Click:Connect(function()
setMode("Tap")
end)

holdClick.MouseButton1Click:Connect(function()
setMode("Hold")
end)

setMode(_G.AdaptInfJumpMode)
return holder, setMode
end


function antiRagdollSelectorRow(parent, order)
local holder = Instance.new("Frame")
holder.Name = "Anti Ragdoll Mode"
holder.BackgroundColor3 = COLORS.row
holder.BackgroundTransparency = 0.28
holder.Size = UDim2.new(1, -4, 0, 42)
holder.BorderSizePixel = 0
holder.LayoutOrder = order
holder.ZIndex = 4
holder.ClipsDescendants = true
holder.Parent = parent
corner(holder, 9)
stroke(holder, COLORS.strokeSoft, 1.15, 0.38)

local slide = Instance.new("Frame")
slide.Name = "SelectedSlide"
slide.BackgroundColor3 = Color3.fromRGB(58,58,64)
slide.BackgroundTransparency = 0.08
slide.Size = UDim2.new(0.5, -3, 1, -8)
slide.Position = UDim2.new(0, 4, 0, 4)
slide.BorderSizePixel = 0
slide.ZIndex = 5
slide.Parent = holder
corner(slide, 9)

local slideStroke = Instance.new("UIStroke")
slideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
slideStroke.Color = Color3.fromRGB(235,235,245)
slideStroke.Thickness = 1
slideStroke.Transparency = 0.08
slideStroke.Parent = slide

local slideGradient = Instance.new("UIGradient")
slideGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(24,24,28)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(46,46,52)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(18,18,22)),
})
slideGradient.Parent = slide

local v1Text = Instance.new("TextLabel")
v1Text.BackgroundTransparency = 1
v1Text.Text = "ANTI RAGDOLL V1"
v1Text.TextColor3 = COLORS.white
v1Text.TextSize = 9
v1Text.Font = Enum.Font.GothamMedium
v1Text.Size = UDim2.new(0.5, 0, 1, 0)
v1Text.ZIndex = 8
v1Text.Parent = holder

local v2Text = Instance.new("TextLabel")
v2Text.BackgroundTransparency = 1
v2Text.Text = "ANTI RAGDOLL V2"
v2Text.TextColor3 = COLORS.white
v2Text.TextSize = 9
v2Text.Font = Enum.Font.GothamMedium
v2Text.Size = UDim2.new(0.5, 0, 1, 0)
v2Text.Position = UDim2.new(0.5, 0, 0, 0)
v2Text.ZIndex = 8
v2Text.Parent = holder

local v1Click = Instance.new("TextButton")
v1Click.BackgroundTransparency = 1
v1Click.Text = ""
v1Click.AutoButtonColor = false
v1Click.Size = UDim2.new(0.5, 0, 1, 0)
v1Click.ZIndex = 10
v1Click.Parent = holder

local v2Click = Instance.new("TextButton")
v2Click.BackgroundTransparency = 1
v2Click.Text = ""
v2Click.AutoButtonColor = false
v2Click.Size = UDim2.new(0.5, 0, 1, 0)
v2Click.Position = UDim2.new(0.5, 0, 0, 0)
v2Click.ZIndex = 10
v2Click.Parent = holder

local function setMode(mode)
_G.AdaptAntiRagdollMode = (mode == "V2") and "V2" or "V1"

local onV2 = _G.AdaptAntiRagdollMode == "V2"
tween(slide, {
Position = onV2 and UDim2.new(0.5, -1, 0, 4) or UDim2.new(0, 4, 0, 4)
}, 0.18)

tween(v1Text, {
TextTransparency = onV2 and 0.18 or 0,
TextStrokeTransparency = onV2 and 0.38 or 0.2
}, 0.14)

tween(v2Text, {
TextTransparency = onV2 and 0 or 0.18,
TextStrokeTransparency = onV2 and 0.2 or 0.38
}, 0.14)

if antiRagdollEnabled then
setAntiRagdoll(true)
end

do end
end

v1Click.MouseButton1Click:Connect(function()
setMode("V1")
end)

v2Click.MouseButton1Click:Connect(function()
setMode("V2")
end)

setMode(_G.AdaptAntiRagdollMode)
return holder, setMode
end


function dropModeSelectorRow(parent, order)
local holder = Instance.new("Frame")
holder.Name = "Drop Mode"
holder.BackgroundColor3 = COLORS.row
holder.BackgroundTransparency = 0.28
holder.Size = UDim2.new(1, -4, 0, 42)
holder.BorderSizePixel = 0
holder.LayoutOrder = order
holder.ZIndex = 4
holder.ClipsDescendants = true
holder.Parent = parent
corner(holder, 9)
stroke(holder, COLORS.strokeSoft, 1.15, 0.38)

local slide = Instance.new("Frame")
slide.Name = "SelectedSlide"
slide.BackgroundColor3 = Color3.fromRGB(58,58,64)
slide.BackgroundTransparency = 0.08
slide.Size = UDim2.new(0.5, -3, 1, -8)
slide.Position = UDim2.new(0, 4, 0, 4)
slide.BorderSizePixel = 0
slide.ZIndex = 5
slide.Parent = holder
corner(slide, 9)

local st = Instance.new("UIStroke")
st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
st.Color = Color3.fromRGB(235,235,245)
st.Thickness = 1
st.Transparency = 0.08
st.Parent = slide

local standText = Instance.new("TextLabel")
standText.BackgroundTransparency = 1
standText.Text = "STAND DROP"
standText.TextColor3 = COLORS.white
standText.TextSize = 10
standText.Font = Enum.Font.GothamMedium
standText.Size = UDim2.new(0.5,0,1,0)
standText.ZIndex = 8
standText.Parent = holder

local jumpText = Instance.new("TextLabel")
jumpText.BackgroundTransparency = 1
jumpText.Text = "JUMP DROP"
jumpText.TextColor3 = COLORS.white
jumpText.TextSize = 10
jumpText.Font = Enum.Font.GothamMedium
jumpText.Size = UDim2.new(0.5,0,1,0)
jumpText.Position = UDim2.new(0.5,0,0,0)
jumpText.ZIndex = 8
jumpText.Parent = holder

local standClick = Instance.new("TextButton")
standClick.BackgroundTransparency = 1
standClick.Text = ""
standClick.AutoButtonColor = false
standClick.Size = UDim2.new(0.5,0,1,0)
standClick.ZIndex = 10
standClick.Parent = holder

local jumpClick = Instance.new("TextButton")
jumpClick.BackgroundTransparency = 1
jumpClick.Text = ""
jumpClick.AutoButtonColor = false
jumpClick.Size = UDim2.new(0.5,0,1,0)
jumpClick.Position = UDim2.new(0.5,0,0,0)
jumpClick.ZIndex = 10
jumpClick.Parent = holder

local function setMode(mode)
_G.AdaptDropMode = (mode == "Jump Drop") and "Jump Drop" or "Stand Drop"
local jump = _G.AdaptDropMode == "Jump Drop"

tween(slide, {
Position = jump and UDim2.new(0.5,-1,0,4) or UDim2.new(0,4,0,4)
}, 0.18)

tween(standText, {TextTransparency = jump and 0.18 or 0}, 0.14)
tween(jumpText, {TextTransparency = jump and 0 or 0.18}, 0.14)

do end
end

standClick.MouseButton1Click:Connect(function() setMode("Stand Drop") end)
jumpClick.MouseButton1Click:Connect(function() setMode("Jump Drop") end)

setMode(_G.AdaptDropMode)
return holder, setMode
end

--Leaked By Xlu0 AndPrime--
--Leaked By Xlu0 AndPrime--
task.wait()
Movement = pages.MOVEMENT

section(Movement, "AUTO SPEED", -2)
_, setAutoCarrySpeedVisual = toggleRow(Movement, "Auto Carry Speed", autoCarrySpeedEnabled, -1)
do
local row = Movement:FindFirstChild("Auto Carry Speed")
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
autoCarrySpeedEnabled = not autoCarrySpeedEnabled
if autoCarrySpeedEnabled ~= true and _G.AutoCarrySpeed and _G.AutoCarrySpeed.Disable then
_G.AutoCarrySpeed.Disable()
end
if setAutoCarrySpeedVisual then setAutoCarrySpeedVisual(autoCarrySpeedEnabled == true) end
do end
end)
end
end
section(Movement, "NORMAL SPEED", 1)
_, normalSpeedBox = textboxRow(Movement, "Normal Speed", tostring(NS), 2)
normalSpeedBox.FocusLost:Connect(function()
local v = tonumber(normalSpeedBox.Text)
if v and v > 0 and v <= 250 then
NS = v
end
normalSpeedBox.Text = tostring(NS)
end)
_, carrySpeedBox = textboxRow(Movement, "Carry Speed", tostring(CS), 3)
carrySpeedBox.FocusLost:Connect(function()
local v = tonumber(carrySpeedBox.Text)
if v and v > 0 and v <= 250 then
CS = v
end
carrySpeedBox.Text = tostring(CS)
end)
modeDisplayRow(Movement, 4, "Normal")
section(Movement, "LAGGER SPEED", 5)
_, laggerSpeedBox = textboxRow(Movement, "Lagger Speed", tostring(LAGGER_SPEED), 6)
laggerSpeedBox.FocusLost:Connect(function()
local v = tonumber(laggerSpeedBox.Text)
if v and v > 0 and v <= 250 then
LAGGER_SPEED = v
end
laggerSpeedBox.Text = tostring(LAGGER_SPEED)
end)
_, laggerCarrySpeedBox = textboxRow(Movement, "Lagger Carry Speed", tostring(LAGGER_CARRY_SPEED), 7)
laggerCarrySpeedBox.FocusLost:Connect(function()
local v = tonumber(laggerCarrySpeedBox.Text)
if v and v > 0 and v <= 250 then
LAGGER_CARRY_SPEED = v
end
laggerCarrySpeedBox.Text = tostring(LAGGER_CARRY_SPEED)
end)
modeDisplayRow(Movement, 8, "Lagger")
section(Movement, "TELEPORT", 9)
autoTPRow = nil
autoTPRow, setAutoTPVisual = toggleRow(Movement, "Auto TP Down", autoTPEnabled, 10)
do
local autoTPButton = autoTPRow and autoTPRow:FindFirstChild("ToggleButton")
if autoTPButton then
autoTPButton.MouseButton1Click:Connect(function()
if autoTPClickDebounce then return end
autoTPClickDebounce = true
local nextState = not autoTPEnabled
toggleAutoTP(nextState)
task.delay(0.15, function()
autoTPClickDebounce = false
if setAutoTPVisual then setAutoTPVisual(autoTPEnabled) end
end)
end)
end
if autoTPEnabled then
startAutoTP()
else
stopAutoTP()
end
end
_, autoTPHeightBox = textboxRow(Movement, "Auto TP Height", tostring(autoTPHeight), 11)
autoTPHeightBox.FocusLost:Connect(function()
local v = tonumber(autoTPHeightBox.Text)
if v and v >= -500 and v <= 500 then
autoTPHeight = v
end
autoTPHeightBox.Text = tostring(autoTPHeight)
do end
end)
section(Movement, "JUMP", 15)
_, setInfJumpVisual = toggleRow(Movement, "Infinite Jump", infJumpEnabled, 16)

_G.AdaptInfJumpMainRow = Movement:FindFirstChild("Infinite Jump")
_G.AdaptInfJumpToggleBtn = _G.AdaptInfJumpMainRow and _G.AdaptInfJumpMainRow:FindFirstChild("ToggleButton")
if _G.AdaptInfJumpToggleBtn then
_G.AdaptInfJumpToggleBtn.Size = UDim2.new(0, 54, 1, 0)
_G.AdaptInfJumpToggleBtn.Position = UDim2.new(1, -54, 0, 0)
end

_G.AdaptInfJumpArrow = Instance.new("TextButton")
_G.AdaptInfJumpArrow.Name = "ArrowButton"
_G.AdaptInfJumpArrow.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
_G.AdaptInfJumpArrow.BackgroundTransparency = 0.18
_G.AdaptInfJumpArrow.BorderSizePixel = 0
_G.AdaptInfJumpArrow.Text = "▼"
_G.AdaptInfJumpArrow.TextColor3 = COLORS.white
_G.AdaptInfJumpArrow.TextSize = 18
_G.AdaptInfJumpArrow.Font = Enum.Font.GothamBlack
_G.AdaptInfJumpArrow.AutoButtonColor = false
_G.AdaptInfJumpArrow.Size = UDim2.new(0, 38, 0, 26)
_G.AdaptInfJumpArrow.Position = UDim2.new(1, -100, 0.5, -13)
_G.AdaptInfJumpArrow.ZIndex = 20
_G.AdaptInfJumpArrow.Parent = _G.AdaptInfJumpMainRow
corner(_G.AdaptInfJumpArrow, 7)
stroke(_G.AdaptInfJumpArrow, COLORS.strokeSoft, 1.2, 0.25)

_G.AdaptInfJumpSelector = infiniteJumpSelectorRow(Movement, 16.1)
_G.AdaptInfJumpSelector.Visible = false
_G.AdaptInfJumpSelector.Size = UDim2.new(1, -4, 0, 0)
_G.AdaptInfJumpExpanded = false

_G.AdaptInfJumpArrow.MouseButton1Click:Connect(function()
_G.AdaptInfJumpExpanded = not _G.AdaptInfJumpExpanded
if _G.AdaptInfJumpExpanded then
_G.AdaptInfJumpSelector.Visible = true
tween(_G.AdaptInfJumpSelector, {Size = UDim2.new(1, -4, 0, 42)}, 0.2)
tween(_G.AdaptInfJumpArrow, {Rotation = 180}, 0.15)
else
tween(_G.AdaptInfJumpArrow, {Rotation = 0}, 0.15)
tween(_G.AdaptInfJumpSelector, {Size = UDim2.new(1, -4, 0, 0)}, 0.2)
task.delay(0.2, function()
if not _G.AdaptInfJumpExpanded then
_G.AdaptInfJumpSelector.Visible = false
end
end)
end
end)

do
local row = Movement:FindFirstChild("Infinite Jump")
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
setInfJumpInternal(not infJumpEnabled)
if setInfJumpVisual then setInfJumpVisual(infJumpEnabled == true) end
do end
end)
end
end
_, setAntiRagdollVisual = toggleRow(Movement, "Anti Ragdoll", antiRagdollEnabled, 17)
do
    local row = Movement:FindFirstChild("Anti Ragdoll")
    local btn = row and row:FindFirstChild("ToggleButton")
    if btn then
        btn.Activated:Connect(function()
            setAntiRagdoll(not antiRagdollEnabled)
            if setAntiRagdollVisual then
                setAntiRagdollVisual(antiRagdollEnabled == true)
            end
        end)
    end
end

refreshSpeedModeRows()
task.wait()
Combat = pages.COMBAT
section(Combat, "AUTO STEAL", 1)

_aceRow, setAutoStealVisual = toggleRow(Combat, "Auto Steal", autoStealEnabled, 2)
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Size = UDim2.new(0, 54, 1, 0)
_aceBtn.Position = UDim2.new(1, -54, 0, 0)
_aceBtn.Activated:Connect(function()
autoStealEnabled = not autoStealEnabled
if setAutoStealVisual then
setAutoStealVisual(autoStealEnabled)
end
if _G.AdaptAutoStealSync then _G.AdaptAutoStealSync() end
do end
end)
end
end

_G.AdaptStealArrow = Instance.new("TextButton")
_G.AdaptStealArrow.Name = "ArrowButton"
_G.AdaptStealArrow.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
_G.AdaptStealArrow.BackgroundTransparency = 0.18
_G.AdaptStealArrow.BorderSizePixel = 0
_G.AdaptStealArrow.Text = "▼"
_G.AdaptStealArrow.TextColor3 = COLORS.white
_G.AdaptStealArrow.TextSize = 18
_G.AdaptStealArrow.Font = Enum.Font.GothamBlack
_G.AdaptStealArrow.AutoButtonColor = false
_G.AdaptStealArrow.Size = UDim2.new(0, 38, 0, 26)
_G.AdaptStealArrow.Position = UDim2.new(1, -100, 0.5, -13)
_G.AdaptStealArrow.ZIndex = 20
_G.AdaptStealArrow.Parent = _aceRow
corner(_G.AdaptStealArrow, 7)
stroke(_G.AdaptStealArrow, COLORS.strokeSoft, 1.2, 0.25)

_G.AdaptStealSelector = autoStealSelectorRow(Combat, 2.1)
_G.AdaptStealSelector.Visible = false
_G.AdaptStealSelector.Size = UDim2.new(1, -4, 0, 0)
_G.AdaptStealExpanded = false

_G.AdaptStealArrow.MouseButton1Click:Connect(function()
_G.AdaptStealExpanded = not _G.AdaptStealExpanded
if _G.AdaptStealExpanded then
_G.AdaptStealSelector.Visible = true
tween(_G.AdaptStealSelector, {Size = UDim2.new(1, -4, 0, 42)}, 0.2)
tween(_G.AdaptStealArrow, {Rotation = 180}, 0.15)
else
tween(_G.AdaptStealArrow, {Rotation = 0}, 0.15)
tween(_G.AdaptStealSelector, {Size = UDim2.new(1, -4, 0, 0)}, 0.2)
task.delay(0.2, function()
if not _G.AdaptStealExpanded then
_G.AdaptStealSelector.Visible = false
end
end)
end
end)

_, radiusBox = textboxRow(Combat, "Radius", tostring(autoStealRadius), 3)
autoStealRadiusBox = radiusBox
radiusBox.FocusLost:Connect(function()
local v = tonumber(radiusBox.Text)
if v and v > 0 and v <= 500 then
autoStealRadius = v
if selectedStealMode == "Auto Steal V3" then
    _G.AdaptStealRadii = _G.AdaptStealRadii or {}
    _G.AdaptStealRadii["Auto Steal V3"] = v
end
end
_G.AdaptStealRadii = _G.AdaptStealRadii or {Normal = 62, Semi = 9}
_G.AdaptStealRadii[selectedStealMode] = autoStealRadius
radiusBox.Text = tostring(autoStealRadius)
if _G.AdaptNormalAutoStealSetRadius then _G.AdaptNormalAutoStealSetRadius(_G.AdaptStealRadii.Normal or 62) end
if _G.AdaptSemiAutoStealSetRadius then _G.AdaptSemiAutoStealSetRadius(_G.AdaptStealRadii.Semi or 9) end
if _G.AdaptAutoStealSync then _G.AdaptAutoStealSync() end
if saveAdaptConfig then
    pcall(saveAdaptConfig)
end
do end
end)
local aimbotMainRow, _, aimbotArrow = aimbotModeButtonRow(Combat, 5)
local aimbotSelector = _G.AdaptAimbotSelectorRow(Combat, 5.1)
aimbotSelector.Visible = false
aimbotSelector.Size = UDim2.new(1, -4, 0, 0)

local aimbotExpanded = false
if aimbotArrow then
aimbotArrow.MouseButton1Click:Connect(function()
aimbotExpanded = not aimbotExpanded
if aimbotExpanded then
aimbotSelector.Visible = true
tween(aimbotSelector, {Size = UDim2.new(1, -4, 0, 42)}, 0.2)
tween(aimbotArrow, {Rotation = 180}, 0.15)
else
tween(aimbotArrow, {Rotation = 0}, 0.15)
tween(aimbotSelector, {Size = UDim2.new(1, -4, 0, 0)}, 0.2)
task.delay(0.2, function()
if not aimbotExpanded then
aimbotSelector.Visible = false
end
end)
end
end)
end

if _G.AdaptRefreshAimbotVisual then
_G.AdaptRefreshAimbotVisual()
end
_G.AdaptNormalAutoSwingRow, _G.AdaptNormalAutoSwingSetVisual, _G.AdaptNormalAutoSwingBtn = _G.AdaptActionToggleRow(Combat, "Auto Swing", autoSwingEnabled, 7)
do
if _G.AdaptNormalAutoSwingBtn then
_G.AdaptNormalAutoSwingBtn.MouseButton1Click:Connect(function()
if _G.AdaptAutoSwingClickBusy then return end
_G.AdaptAutoSwingClickBusy = true
autoSwingEnabled = not autoSwingEnabled
if _G.AdaptNormalAutoSwingSetVisual then _G.AdaptNormalAutoSwingSetVisual(autoSwingEnabled) end
do end
task.delay(0.12, function() _G.AdaptAutoSwingClickBusy = false end)
end)
end
end
_G.AdaptMirrorTPDownRow, _G.AdaptMirrorTPDownSetVisual, _G.AdaptMirrorTPDownBtn = _G.AdaptActionToggleRow(Combat, "Mirror TP Down (Recommended)", mirrorTPDownEnabled, 7.1)
local mirrorTPDownLabel = _G.AdaptMirrorTPDownRow and _G.AdaptMirrorTPDownRow:FindFirstChild("Label")
if mirrorTPDownLabel then mirrorTPDownLabel.TextSize = 10 end
if _G.AdaptMirrorTPDownBtn then
_G.AdaptMirrorTPDownBtn.MouseButton1Click:Connect(function()
if _G.AdaptMirrorTPDownClickBusy then return end
_G.AdaptMirrorTPDownClickBusy = true
_G.AdaptSetMirrorTPDown(not mirrorTPDownEnabled)
do end
task.delay(0.12, function() _G.AdaptMirrorTPDownClickBusy = false end)
end)
end
aimbotSpeedRow, aimbotSpeedBox = textboxRow(Combat, "Normal Aimbot Speed", tostring(AIMBOT_SPEED), 8)
_G.AdaptAimbotSpeedBox = aimbotSpeedBox
aimbotSpeedLabel = aimbotSpeedRow and aimbotSpeedRow:FindFirstChild("Label")
refreshAimbotModeLabels()
aimbotSpeedBox.FocusLost:Connect(function()
local v = tonumber(aimbotSpeedBox.Text)
if v and v > 0 and v <= 250 then
_G.AdaptSetSelectedAimbotSpeedValues(v, nil)
end
if _G.AdaptRefreshAimbotSpeedBoxes then _G.AdaptRefreshAimbotSpeedBoxes() else aimbotSpeedBox.Text = tostring(AIMBOT_SPEED) end
do end
end)
laggerAimbotSpeedRow, laggerAimbotSpeedBox = textboxRow(Combat, "Normal Lagger Aimbot Speed", tostring(LAGGER_AIMBOT_SPEED), 9)
_G.AdaptLaggerAimbotSpeedBox = laggerAimbotSpeedBox
laggerAimbotSpeedLabel = laggerAimbotSpeedRow and laggerAimbotSpeedRow:FindFirstChild("Label")
refreshAimbotModeLabels()
if _G.AdaptRefreshAimbotSpeedBoxes then _G.AdaptRefreshAimbotSpeedBoxes() end
laggerAimbotSpeedBox.FocusLost:Connect(function()
local v = tonumber(laggerAimbotSpeedBox.Text)
if v and v > 0 and v <= 250 then
_G.AdaptSetSelectedAimbotSpeedValues(nil, v)
end
if _G.AdaptRefreshAimbotSpeedBoxes then _G.AdaptRefreshAimbotSpeedBoxes() else laggerAimbotSpeedBox.Text = tostring(LAGGER_AIMBOT_SPEED) end
do end
end)

_, _G.AdaptBodyLockVisual = toggleRow(Combat, "Body Lock", _G.AdaptBodyLockEnabled, 6.5)

_G.AdaptBodyLockMainRow = Combat:FindFirstChild("Body Lock")
_G.AdaptBodyLockToggleBtn = _G.AdaptBodyLockMainRow and _G.AdaptBodyLockMainRow:FindFirstChild("ToggleButton")
if _G.AdaptBodyLockToggleBtn then
_G.AdaptBodyLockToggleBtn.Size = UDim2.new(0, 54, 1, 0)
_G.AdaptBodyLockToggleBtn.Position = UDim2.new(1, -54, 0, 0)
end

_G.AdaptBodyLockArrow = Instance.new("TextButton")
_G.AdaptBodyLockArrow.Name = "ArrowButton"
_G.AdaptBodyLockArrow.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
_G.AdaptBodyLockArrow.BackgroundTransparency = 0.18
_G.AdaptBodyLockArrow.BorderSizePixel = 0
_G.AdaptBodyLockArrow.Text = "▼"
_G.AdaptBodyLockArrow.TextColor3 = COLORS.white
_G.AdaptBodyLockArrow.TextSize = 18
_G.AdaptBodyLockArrow.Font = Enum.Font.GothamBlack
_G.AdaptBodyLockArrow.AutoButtonColor = false
_G.AdaptBodyLockArrow.Size = UDim2.new(0, 38, 0, 26)
_G.AdaptBodyLockArrow.Position = UDim2.new(1, -100, 0.5, -13)
_G.AdaptBodyLockArrow.ZIndex = 20
_G.AdaptBodyLockArrow.Parent = _G.AdaptBodyLockMainRow
corner(_G.AdaptBodyLockArrow, 7)
stroke(_G.AdaptBodyLockArrow, COLORS.strokeSoft, 1.2, 0.25)

_G.AdaptBodyLockSettings = baseRow(Combat, "", 6.6)
_G.AdaptBodyLockSettings.Visible = false
_G.AdaptBodyLockSettings.Size = UDim2.new(1, -4, 0, 0)
_G.AdaptBodyLockSettings.ClipsDescendants = true

_G.AdaptBodyLockRadiusLabel = Instance.new("TextLabel")
_G.AdaptBodyLockRadiusLabel.BackgroundTransparency = 1
_G.AdaptBodyLockRadiusLabel.Text = "RADIUS"
_G.AdaptBodyLockRadiusLabel.TextColor3 = COLORS.white
_G.AdaptBodyLockRadiusLabel.TextSize = 10
_G.AdaptBodyLockRadiusLabel.Font = Enum.Font.GothamMedium
_G.AdaptBodyLockRadiusLabel.TextXAlignment = Enum.TextXAlignment.Left
_G.AdaptBodyLockRadiusLabel.Size = UDim2.new(0.45, 0, 1, 0)
_G.AdaptBodyLockRadiusLabel.Position = UDim2.new(0, 12, 0, 0)
_G.AdaptBodyLockRadiusLabel.ZIndex = 7
_G.AdaptBodyLockRadiusLabel.Parent = _G.AdaptBodyLockSettings

_G.AdaptBodyLockRadiusBox = Instance.new("TextBox")
_G.AdaptBodyLockRadiusBox.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
_G.AdaptBodyLockRadiusBox.BackgroundTransparency = 0.18
_G.AdaptBodyLockRadiusBox.Text = tostring(_G.AdaptBodyLockRadius)
_G.AdaptBodyLockRadiusBox.TextColor3 = COLORS.white
_G.AdaptBodyLockRadiusBox.TextSize = 11
_G.AdaptBodyLockRadiusBox.Font = Enum.Font.GothamMedium
_G.AdaptBodyLockRadiusBox.ClearTextOnFocus = false
_G.AdaptBodyLockRadiusBox.Size = UDim2.new(0, 76, 0, 28)
_G.AdaptBodyLockRadiusBox.Position = UDim2.new(1, -88, 0.5, -14)
_G.AdaptBodyLockRadiusBox.BorderSizePixel = 0
_G.AdaptBodyLockRadiusBox.ZIndex = 7
_G.AdaptBodyLockRadiusBox.Parent = _G.AdaptBodyLockSettings
corner(_G.AdaptBodyLockRadiusBox, 7)
stroke(_G.AdaptBodyLockRadiusBox, COLORS.strokeSoft, 1, 0.35)

_G.AdaptBodyLockRadiusBox.FocusLost:Connect(function()
local n = tonumber(_G.AdaptBodyLockRadiusBox.Text)
if n then
_G.AdaptBodyLockRadius = math.clamp(n, 5, 200)
end
_G.AdaptBodyLockRadiusBox.Text = tostring(_G.AdaptBodyLockRadius)
end)

_G.AdaptBodyLockExpanded = false
_G.AdaptBodyLockArrow.MouseButton1Click:Connect(function()
_G.AdaptBodyLockExpanded = not _G.AdaptBodyLockExpanded

if _G.AdaptBodyLockExpanded then
_G.AdaptBodyLockArrow.Text = "▲"
_G.AdaptBodyLockSettings.Visible = true
tween(_G.AdaptBodyLockSettings, {Size = UDim2.new(1, -4, 0, 42)}, 0.2)
else
_G.AdaptBodyLockArrow.Text = "▼"
tween(_G.AdaptBodyLockSettings, {Size = UDim2.new(1, -4, 0, 0)}, 0.2)
task.delay(0.2, function()
if not _G.AdaptBodyLockExpanded and _G.AdaptBodyLockSettings then
_G.AdaptBodyLockSettings.Visible = false
end
end)
end
end)

_G.AdaptBodyLockButton = _G.AdaptBodyLockToggleBtn
if _G.AdaptBodyLockButton then
_G.AdaptBodyLockButton.Activated:Connect(function()
_G.AdaptSetBodyLock(not _G.AdaptBodyLockEnabled)
if _G.AdaptBodyLockVisual then
_G.AdaptBodyLockVisual(_G.AdaptBodyLockEnabled)
end
end)
end

task.defer(function()
task.wait(0.5)
if _G.AdaptBodyLockEnabled then
_G.AdaptStartBodyLock()
end
if _G.AdaptBodyLockVisual then
_G.AdaptBodyLockVisual(_G.AdaptBodyLockEnabled)
end
end)

section(Combat, "TP BAT", 10)
_G.AdaptAntiDesyncAutoSwingRow, _G.AdaptAntiDesyncAutoSwingSetVisual, _G.AdaptAntiDesyncAutoSwingBtn = _G.AdaptActionToggleRow(Combat, "Auto Swing", antiDesyncAutoSwingEnabled, 11)
do
if _G.AdaptAntiDesyncAutoSwingBtn then
_G.AdaptAntiDesyncAutoSwingBtn.MouseButton1Click:Connect(function()
if _G.AdaptAntiDesyncAutoSwingClickBusy then return end
_G.AdaptAntiDesyncAutoSwingClickBusy = true
antiDesyncAutoSwingEnabled = not antiDesyncAutoSwingEnabled
if _G.AdaptAntiDesyncAutoSwingSetVisual then _G.AdaptAntiDesyncAutoSwingSetVisual(antiDesyncAutoSwingEnabled) end
do end
task.delay(0.12, function() _G.AdaptAntiDesyncAutoSwingClickBusy = false end)
end)
end
end
_G.AdaptAntiDesyncSetVisual = function(_) end
section(Combat, "COUNTERS", 13)
_aceRow, setBatCounterVisual = _G.AdaptActionToggleRow(Combat, "Bat Counter", batCounterEnabled, 14)
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
batCounterEnabled = not batCounterEnabled
if setBatCounterVisual then
setBatCounterVisual(batCounterEnabled)
end
if batCounterEnabled then
if _G.AdaptStartBatCounter then _G.AdaptStartBatCounter() end
else
if _G.AdaptStopBatCounter then _G.AdaptStopBatCounter() end
end
do end
end)
end
end
_aceRow, setMedCounterVisual = _G.AdaptActionToggleRow(Combat, "Med Counter", medCounterEnabled, 15)
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
medCounterEnabled = not medCounterEnabled
if setMedCounterVisual then
setMedCounterVisual(medCounterEnabled)
end
if medCounterEnabled then
if _G.AdaptStartMedCounter then _G.AdaptStartMedCounter(LP.Character) end
else
if _G.AdaptStopMedCounter then _G.AdaptStopMedCounter() end
end
do end
end)
end
end
_aceRow, _G.AdaptSetNoPlayerCollisionVisual = _G.AdaptActionToggleRow(Combat, "No Player Collision", _G.AdaptNoPlayerCollisionEnabled, 16)
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
_G.AdaptNoPlayerCollisionEnabled = not _G.AdaptNoPlayerCollisionEnabled
if _G.AdaptSetNoPlayerCollisionVisual then _G.AdaptSetNoPlayerCollisionVisual(_G.AdaptNoPlayerCollisionEnabled) end
if _G.AdaptNoPlayerCollisionEnabled then
if enableNoPlayerCollision then enableNoPlayerCollision() end
else
if disableNoPlayerCollision then disableNoPlayerCollision() end
end
do end
end)
end
end
_aceRow, setSafeModeVisual = _G.AdaptActionToggleRow(Combat, "Safe Mode", antiKickEnabled, 17)
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
antiKickEnabled = not antiKickEnabled
if setSafeModeVisual then setSafeModeVisual(antiKickEnabled) end
if antiKickEnabled and _G.AdaptSafeModeForceStop then _G.AdaptSafeModeForceStop("SAFE MODE") end
do end
end)
end
end

_, _G.AdaptAntiResetVisual = toggleRow(Combat, "Anti Die", _G.AdaptAntiResetEnabled, 18)
_G.AdaptAntiResetRow = Combat:FindFirstChild("Anti Die")
_G.AdaptAntiResetButton = _G.AdaptAntiResetRow and _G.AdaptAntiResetRow:FindFirstChild("ToggleButton")
if _G.AdaptAntiResetButton then
_G.AdaptAntiResetButton.Activated:Connect(function()
_G.AdaptSetAntiReset(not _G.AdaptAntiResetEnabled)
if _G.AdaptAntiResetVisual then _G.AdaptAntiResetVisual(_G.AdaptAntiResetEnabled == true) end
do end
end)
end



_G.AdaptDropModeMainRow = baseRow(Combat, "Drop", 18.5)
do
local _dropLbl = _G.AdaptDropModeMainRow and _G.AdaptDropModeMainRow:FindFirstChild("Label")
if _dropLbl then
    _dropLbl.TextXAlignment = Enum.TextXAlignment.Center
    _dropLbl.AnchorPoint = Vector2.new(0.5, 0)
    _dropLbl.Position = UDim2.new(0.5, -14, 0, 0)
    _dropLbl.Size = UDim2.new(0, 64, 1, 0)
end
end

_G.AdaptDropAction = Instance.new("TextButton")
_G.AdaptDropAction.Name = "DropAction"
_G.AdaptDropAction.BackgroundTransparency = 1
_G.AdaptDropAction.Text = ""
_G.AdaptDropAction.AutoButtonColor = false
_G.AdaptDropAction.Size = UDim2.new(1, -50, 1, 0)
_G.AdaptDropAction.Position = UDim2.new(0, 0, 0, 0)
_G.AdaptDropAction.ZIndex = 15
_G.AdaptDropAction.Parent = _G.AdaptDropModeMainRow

_G.AdaptDropArrow = Instance.new("TextButton")
_G.AdaptDropArrow.Name = "ArrowButton"
_G.AdaptDropArrow.BackgroundColor3 = Color3.fromRGB(8,8,12)
_G.AdaptDropArrow.BackgroundTransparency = 0.18
_G.AdaptDropArrow.BorderSizePixel = 0
_G.AdaptDropArrow.Text = "▼"
_G.AdaptDropArrow.TextColor3 = COLORS.white
_G.AdaptDropArrow.TextSize = 18
_G.AdaptDropArrow.Font = Enum.Font.GothamBlack
_G.AdaptDropArrow.AutoButtonColor = false
_G.AdaptDropArrow.Size = UDim2.new(0,38,0,26)
_G.AdaptDropArrow.Position = UDim2.new(0.5, 24, 0.5, -13)
_G.AdaptDropArrow.ZIndex = 20
_G.AdaptDropArrow.Parent = _G.AdaptDropModeMainRow
corner(_G.AdaptDropArrow, 7)
stroke(_G.AdaptDropArrow, COLORS.strokeSoft, 1.2, 0.25)

_G.AdaptDropSelector = dropModeSelectorRow(Combat, 18.6)
_G.AdaptDropSelector.Visible = false
_G.AdaptDropSelector.Size = UDim2.new(1,-4,0,0)
_G.AdaptDropExpanded = false

_G.AdaptDropAction.MouseButton1Click:Connect(function()
pcall(runDrop)
end)

_G.AdaptDropArrow.MouseButton1Click:Connect(function()
--Leaked By Xlu0 AndPrime--
tween(_G.AdaptDropArrow, {
BackgroundTransparency = 0.02,
TextColor3 = Color3.fromRGB(255,255,255)
}, 0.08)

task.delay(0.09, function()
if _G.AdaptDropArrow then
tween(_G.AdaptDropArrow, {
BackgroundTransparency = 0.18
}, 0.12)
end
end)

_G.AdaptDropExpanded = not _G.AdaptDropExpanded

if _G.AdaptDropExpanded then
_G.AdaptDropArrow.Text = "▲"
_G.AdaptDropSelector.Visible = true
tween(_G.AdaptDropSelector, {Size = UDim2.new(1,-4,0,42)}, 0.2)
else
_G.AdaptDropArrow.Text = "▼"
tween(_G.AdaptDropSelector, {Size = UDim2.new(1,-4,0,0)}, 0.2)
task.delay(0.2, function()
if not _G.AdaptDropExpanded and _G.AdaptDropSelector then
_G.AdaptDropSelector.Visible = false
end
end)
end
end)


_, _G.AdaptAntiVoidVisual = toggleRow(Combat, "Anti Void", _G.AdaptAntiVoidEnabled, 19)
_G.AdaptAntiVoidRow = Combat:FindFirstChild("Anti Void")
_G.AdaptAntiVoidButton = _G.AdaptAntiVoidRow and _G.AdaptAntiVoidRow:FindFirstChild("ToggleButton")
if _G.AdaptAntiVoidButton then
_G.AdaptAntiVoidButton.Activated:Connect(function()
_G.AdaptAntiVoidSet(not _G.AdaptAntiVoidEnabled)
if _G.AdaptAntiVoidVisual then _G.AdaptAntiVoidVisual(_G.AdaptAntiVoidEnabled == true) end
do end
end)
end

_aceRow, setAutoResetOnMedVisual = toggleRow(Combat, "Auto Reset On Med Fling", autoResetOnMedEnabled, 18)
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
if _G.AdaptSetAutoResetOnMed then
_G.AdaptSetAutoResetOnMed(not autoResetOnMedEnabled)
else
autoResetOnMedEnabled = not autoResetOnMedEnabled
if setAutoResetOnMedVisual then setAutoResetOnMedVisual(autoResetOnMedEnabled) end
do end
end
end)
end
end

--Leaked By Xlu0 AndPrime--
section(Movement, "AUTO PLAY", 100)

do
    local duelModeRow = baseRow(Movement, "Duel Mode", 101)
    duelModeRow.Size = UDim2.new(1,-4,0,42)

    local lbl = duelModeRow:FindFirstChild("Label")
    if lbl then
        lbl.Text = "Duel Mode"
        lbl.Size = UDim2.new(0.35,0,1,0)
    end

    local halfBtn = Instance.new("TextButton")
    halfBtn.Name = "HalfButton"
    halfBtn.Size = UDim2.new(0,58,0,28)
    halfBtn.Position = UDim2.new(1,-134,0.5,-14)
    halfBtn.BackgroundTransparency = 1
    halfBtn.BorderSizePixel = 0
    halfBtn.Text = "HALF"
    halfBtn.Font = Enum.Font.GothamMedium
    halfBtn.TextSize = 10
    halfBtn.ZIndex = 20
    halfBtn.Parent = duelModeRow
    corner(halfBtn,6)
    stroke(halfBtn,COLORS.strokeSoft,1,0.45)

    local fullBtn = Instance.new("TextButton")
    fullBtn.Name = "FullButton"
    fullBtn.Size = UDim2.new(0,58,0,28)
    fullBtn.Position = UDim2.new(1,-70,0.5,-14)
    fullBtn.BackgroundTransparency = 1
    fullBtn.BorderSizePixel = 0
    fullBtn.Text = "FULL"
    fullBtn.Font = Enum.Font.GothamMedium
    fullBtn.TextSize = 10
    fullBtn.ZIndex = 20
    fullBtn.Parent = duelModeRow
    corner(fullBtn,6)
    stroke(fullBtn,COLORS.strokeSoft,1,0.45)

    local function refreshDuelBtns()
        halfBtn.TextColor3 = (_G.AdaptDuelMode == "half")
            and Color3.fromRGB(255,255,255)
            or Color3.fromRGB(140,140,140)

        fullBtn.TextColor3 = (_G.AdaptDuelMode == "full")
            and Color3.fromRGB(255,255,255)
            or Color3.fromRGB(140,140,140)

        if _G.AdaptAutoMoveCarrySpeedBox then
            local row = _G.AdaptAutoMoveCarrySpeedBox.Parent
            if row then
                row.Visible = (_G.AdaptDuelMode == "full")
            end
        end
    end

    _G.AdaptRefreshDuelModeButtons = refreshDuelBtns

    halfBtn.MouseButton1Click:Connect(function()
        _G.AdaptDuelMode = "half"
        refreshDuelBtns()
        if saveAdaptConfig then pcall(saveAdaptConfig) end
    end)

    fullBtn.MouseButton1Click:Connect(function()
        _G.AdaptDuelMode = "full"
        refreshDuelBtns()
        if saveAdaptConfig then pcall(saveAdaptConfig) end
    end)

    refreshDuelBtns()
end


task.wait()
MenuCustomize = pages.MENU

task.wait()
Keybinds = pages.KEYBINDS
section(Keybinds, "MOVEMENT KEYBINDS", 1)
speedKeybindRow(Keybinds, "Speed Key", "SpeedToggle", 2)
speedKeybindRow(Keybinds, "Lagger Mode Key", "LaggerToggle", 3)
tpDownKeybindRow(Keybinds, 4)
speedKeybindRow(Keybinds, "Drop Brainrot", "DropBrainrot", 5)
section(Keybinds, "COMBAT KEYBINDS", 6)
aimbotKeybindRow = speedKeybindRow(Keybinds, "Normal Aimbot", "Aimbot", 7)
combatAimbotKeybindLabel = aimbotKeybindRow and aimbotKeybindRow:FindFirstChild("Label")
refreshAimbotModeLabels()
speedKeybindRow(Keybinds, "TP BAT", "AntiDesyncAimbot", 8)
speedKeybindRow(Keybinds, "Auto Left", "AutoLeft", 9)
speedKeybindRow(Keybinds, "Auto Right", "AutoRight", 10)
do
THEME_ACCENT = THEME_ACCENT or Color3.fromRGB(230, 230, 230)
THEME_ACCENT_DIM = THEME_ACCENT_DIM or Color3.fromRGB(145, 145, 145)
PlayerESP = PlayerESP or {enabled=false, playerData={}, conns={}, discordText="discord.gg/gr7eqCS2a"}
BoxedESPOptions = BoxedESPOptions or {box=false, tracer=false}
BoxedESPData = BoxedESPData or {}
BoxedESPConn = BoxedESPConn or nil
stretchRezConn = stretchRezConn or nil
antiLagDescConn = antiLagDescConn or nil
noCamCollisionConn = noCamCollisionConn or nil
noCamCollisionParts = noCamCollisionParts or {}
_aceNukeConns = _aceNukeConns or {}
_aceNukeOn = _aceNukeOn or false
_aceCustomFontOrig = _aceCustomFontOrig or {}
_aceCustomFontConn = _aceCustomFontConn or nil
_aceCustomFont = _aceCustomFont or nil
function startPlayerESP()
if PlayerESP.enabled then return end
PlayerESP.enabled = true
function cleanup(plr)
local d=PlayerESP.playerData[plr]; if not d then return end
pcall(function() if d.highlight then d.highlight:Destroy() end end)
pcall(function() if d.billboard then d.billboard:Destroy() end end)
if d.conns then for _,c in ipairs(d.conns) do pcall(function() c:Disconnect() end) end end
PlayerESP.playerData[plr]=nil
end
function setup(plr,char)
if not PlayerESP.enabled or plr==LP then return end
cleanup(plr)
local hrp=char and (char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart",5))
local head=char and (char:FindFirstChild("Head") or char:WaitForChild("Head",5))
if not hrp or not head then return end
local hl=Instance.new("Highlight")
hl.Name="AdaptDuelsESP"; hl.Adornee=char; hl.FillColor=(_G.AdaptThemeColors and _G.AdaptThemeColors[_G.AdaptThemeName]) or THEME_ACCENT; hl.FillTransparency=0.72
hl.OutlineColor=(_G.AdaptThemeColors and _G.AdaptThemeColors[_G.AdaptThemeName]) or THEME_ACCENT; hl.OutlineTransparency=0; hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent=char
local bb=Instance.new("BillboardGui")
bb.Name="AdaptDuelsESPTag"; bb.Adornee=head; bb.Size=UDim2.new(0,170,0,42); bb.StudsOffset=Vector3.new(0,2.8,0); bb.AlwaysOnTop=true; bb.LightInfluence=0; bb.Parent=head
local box=Instance.new("Frame",bb); box.Size=UDim2.new(1,0,1,0); box.BackgroundTransparency=1; box.BorderSizePixel=0
Instance.new("UICorner",box).CornerRadius=UDim.new(0,9)
local n=Instance.new("TextLabel",box); n.Size=UDim2.new(1,-8,0,19); n.Position=UDim2.new(0,4,0,1); n.BackgroundTransparency=1; n.TextColor3=Color3.fromRGB(255,255,255); n.TextStrokeColor3=Color3.fromRGB(0,0,0); n.Font=Enum.Font.GothamBlack; n.TextSize=13; n.TextStrokeTransparency=0.08
local sub=Instance.new("TextLabel",box); sub.Size=UDim2.new(1,-8,0,17); sub.Position=UDim2.new(0,4,0,19); sub.BackgroundTransparency=1; sub.TextColor3=Color3.fromRGB(255,255,255); sub.TextStrokeColor3=Color3.fromRGB(0,0,0); sub.Font=Enum.Font.GothamBlack; sub.TextSize=11; sub.TextStrokeTransparency=0.08
local conn=RunService.Heartbeat:Connect(function()
if not PlayerESP.enabled or not hrp.Parent then return end
local v=hrp.AssemblyLinearVelocity or hrp.Velocity
n.Text=string.format("Speed: %.1f", Vector3.new(v.X,0,v.Z).Magnitude); sub.Text=plr.Name
end)
PlayerESP.playerData[plr]={highlight=hl,billboard=bb,conns={conn}}
end
for _,plr in ipairs(Players:GetPlayers()) do if plr~=LP then if plr.Character then setup(plr,plr.Character) end; table.insert(PlayerESP.conns, plr.CharacterAdded:Connect(function(c) task.defer(setup,plr,c) end)) end end
table.insert(PlayerESP.conns, Players.PlayerAdded:Connect(function(plr) if plr~=LP then table.insert(PlayerESP.conns, plr.CharacterAdded:Connect(function(c) task.defer(setup,plr,c) end)) end end))
table.insert(PlayerESP.conns, Players.PlayerRemoving:Connect(cleanup))
end
function stopPlayerESP()
PlayerESP.enabled=false
for _,c in ipairs(PlayerESP.conns or {}) do pcall(function() c:Disconnect() end) end
PlayerESP.conns={}
for plr,d in pairs(PlayerESP.playerData or {}) do pcall(function() if d.highlight then d.highlight:Destroy() end end); pcall(function() if d.billboard then d.billboard:Destroy() end end) end
PlayerESP.playerData={}
end
function _aceEspColor()
return THEME_ACCENT or Color3.fromRGB(230,230,230)
end
function _safeDrawing(kind, props)
if not Drawing or not Drawing.new then return nil end
local ok, obj = pcall(function() return Drawing.new(kind) end)
if not ok or not obj then return nil end
for k,v in pairs(props or {}) do pcall(function() obj[k]=v end) end
return obj
end
function _cleanupBoxedESPPlayer(player)
local data = BoxedESPData[player]
if not data then return end
for _,obj in pairs(data) do
pcall(function()
obj.Visible = false
if obj.Remove then obj:Remove() end
end)
end
BoxedESPData[player] = nil
end
function _cleanupBoxedESP()
for player,_ in pairs(BoxedESPData) do _cleanupBoxedESPPlayer(player) end
end
function _updateBoxedESP()
local cam = workspace.CurrentCamera
if not cam then return end
local anyOn = BoxedESPOptions.box or BoxedESPOptions.tracer
if not anyOn then
_cleanupBoxedESP()
return
end
for _,player in ipairs(Players:GetPlayers()) do
if player == LP then continue end
local char = player.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local head = char and char:FindFirstChild("Head")
if not root or not head then
_cleanupBoxedESPPlayer(player)
continue
end
local rootPos,onScreen = cam:WorldToViewportPoint(root.Position)
local headPos = cam:WorldToViewportPoint(head.Position + Vector3.new(0,0.55,0))
local data = BoxedESPData[player]
if not data then
data = {
box = _safeDrawing("Square",{Thickness=2,Filled=false,Transparency=1,Color=_aceEspColor()}),
tracer = _safeDrawing("Line",{Thickness=2,Transparency=1,Color=_aceEspColor()}),
}
BoxedESPData[player] = data
end
local color = _aceEspColor()
local height = math.abs(headPos.Y - rootPos.Y) * 2.15
if height < 20 or height ~= height then height = 65 end
local width = height / 2.15
local view = cam.ViewportSize
local centerX, centerY = view.X/2, view.Y/2
local targetX, targetY = rootPos.X, rootPos.Y + height/2
local targetVisible = onScreen and rootPos.Z > 0
if not targetVisible then
local dx = rootPos.X - centerX
local dy = rootPos.Y - centerY
if rootPos.Z <= 0 then
dx = -dx
dy = -dy
end
if math.abs(dx) < 1 and math.abs(dy) < 1 then
local rel = cam.CFrame:PointToObjectSpace(root.Position)
dx = rel.X
dy = -rel.Y
if rootPos.Z <= 0 then
dx = -dx
dy = -dy
end
end
local edgePad = 10
local scaleX = (dx ~= 0) and ((view.X/2 - edgePad) / math.abs(dx)) or math.huge
local scaleY = (dy ~= 0) and ((view.Y/2 - edgePad) / math.abs(dy)) or math.huge
local scale = math.min(scaleX, scaleY)
if scale == math.huge or scale ~= scale then scale = 1 end
targetX = math.clamp(centerX + dx * scale, edgePad, view.X - edgePad)
targetY = math.clamp(centerY + dy * scale, edgePad, view.Y - edgePad)
end
if data.box then
data.box.Color = color
data.box.Size = Vector2.new(width,height)
data.box.Position = Vector2.new(rootPos.X - width/2, rootPos.Y - height/2)
data.box.Visible = false
end
if data.tracer then
data.tracer.Color = color
local localChar = LP.Character
local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
local localHead = localChar and localChar:FindFirstChild("Head")
local fromX, fromY
if localRoot then
local localScreen = cam:WorldToViewportPoint(localRoot.Position)
fromX = localScreen.X
fromY = localScreen.Y + 15
end
if not fromX or not fromY then
fromX = cam.ViewportSize.X/2
fromY = cam.ViewportSize.Y - 88
end
data.tracer.From = Vector2.new(fromX, fromY)
data.tracer.To = Vector2.new(targetX, targetY)
data.tracer.Visible = BoxedESPOptions.tracer == true
end
end
end
function refreshBoxedESP()
local anyOn = BoxedESPOptions.box or BoxedESPOptions.tracer
if anyOn and not BoxedESPConn then
BoxedESPConn = RunService.RenderStepped:Connect(_updateBoxedESP)
elseif (not anyOn) and BoxedESPConn then
BoxedESPConn:Disconnect()
BoxedESPConn = nil
_cleanupBoxedESP()
end
end
Players.PlayerRemoving:Connect(_cleanupBoxedESPPlayer)
SKY_PRESETS_LIST = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}
SKY_PRESETS = {
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


local function _vC3(t)
    return Color3.fromRGB(t[1], t[2], t[3])
end

function _v4mpClearSky()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute("_AdaptDuelsSky") then
            pcall(function() child:Destroy() end)
        end
    end

    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:GetAttribute("_AdaptDuelsSky") then
                pcall(function() child:Destroy() end)
            end
        end
    end
end

function applyCustomSky(mode)
    _v4mpClearSky()

    local preset = SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
        Lighting.Ambient = Color3.fromRGB(127,127,127)
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        skyTheme = "Off"
        return
    end

    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
    Lighting.FogColor = Color3.fromRGB(200,200,200)
    Lighting.ColorShift_Top = Color3.fromRGB(0,0,0)
    Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
    Lighting.GlobalShadows = true

    Lighting.ClockTime = preset.clock or 14
    Lighting.Brightness = preset.brightness or 2

    if preset.outAmb then
        Lighting.OutdoorAmbient = _vC3(preset.outAmb)
    end

    if preset.ambient then
        Lighting.Ambient = _vC3(preset.ambient)
    end

    if preset.sky then
        local skyInst = Instance.new("Sky")
        skyInst:SetAttribute("_AdaptDuelsSky", true)

        if preset.sky.stars then skyInst.StarCount = preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId = "rbxasset://sky/moon.jpg" end

        skyInst.Parent = Lighting
    end

    if preset.atm then
        local atm = Instance.new("Atmosphere")
        atm:SetAttribute("_AdaptDuelsSky", true)
        atm.Density = preset.atm.dens or 0.3
        atm.Color = _vC3(preset.atm.color)
        atm.Decay = _vC3(preset.atm.decay)
        atm.Glare = preset.atm.glare or 1
        atm.Haze = preset.atm.haze or 1
        atm.Parent = Lighting
    end

    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if preset.clouds and terrain then
        local clouds = Instance.new("Clouds")
        clouds:SetAttribute("_AdaptDuelsSky", true)
        clouds.Cover = preset.clouds.cover or 0.5
        clouds.Density = preset.clouds.dens or 0.5
        clouds.Color = _vC3(preset.clouds.color)
        clouds.Parent = terrain
    end

    skyTheme = mode
end

_G.AdaptStretchValue = 0.70
_G.AdaptStretchPreset = "Medium"

_G.AdaptStretchPresets = {
    ["Light"] = 0.85,
    ["Medium"] = 0.70,
    ["Strong"] = 0.55,
    ["Extreme"] = 0.40,
}

function enableStretchRez()
    fpsBoostEnabled = true
    if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn=nil end

    stretchRezConn = RunService.RenderStepped:Connect(function()
        if not fpsBoostEnabled then
            if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn=nil end
            return
        end

        local cam = Workspace.CurrentCamera or workspace.CurrentCamera
        if cam then
            local sv = 0.70
            --Leaked By Xlu0 AndPrime--
            cam.CFrame = cam.CFrame * CFrame.new(
                0,0,0,
                1,0,0,
                0,sv,0,
                0,0,1
            )
        end
    end)
end

function disableStretchRez()
    fpsBoostEnabled = false
    if stretchRezConn then
        stretchRezConn:Disconnect()
        stretchRezConn = nil
    end
end

function _G.AdaptSetStretchPreset(name)
    local v = _G.AdaptStretchPresets[name]
    if not v then return end
    _G.AdaptStretchPreset = name
    _G.AdaptStretchValue = v
end

function enableCustomFov() fovEnabled=true; workspace.CurrentCamera.FieldOfView=fovValue; if customFovConn then customFovConn:Disconnect() end; customFovConn=RunService.RenderStepped:Connect(function() if not fovEnabled then customFovConn:Disconnect(); customFovConn=nil; return end; workspace.CurrentCamera.FieldOfView=fovValue end) end
function disableCustomFov() fovEnabled=false; if customFovConn then customFovConn:Disconnect(); customFovConn=nil end; workspace.CurrentCamera.FieldOfView=fpsBoostEnabled and 107 or 70 end
_G.AdaptZombieAntiLag = _G.AdaptZombieAntiLag or {
    conn=nil,
    active=false,
    defBrightness=nil,
    defFog=nil,
    defDiffuse=nil,
    defSpecular=nil,
}

function _applyAntiLagObj(obj)
    pcall(function()
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter")
            or obj:IsA("Trail")
            or obj:IsA("Beam")
            or obj:IsA("Fire")
            or obj:IsA("Smoke")
            or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
            for _,tr in ipairs(obj:GetPlayingAnimationTracks()) do
                pcall(function() tr:Stop(0) end)
            end
        end
    end)
end

function enableAntiLag()
    antiLagVisualEnabled = true
    local S = _G.AdaptZombieAntiLag
    S.active = true
    S.defBrightness = S.defBrightness or Lighting.Brightness
    S.defFog = S.defFog or Lighting.FogEnd
    S.defDiffuse = S.defDiffuse or Lighting.EnvironmentDiffuseScale
    S.defSpecular = S.defSpecular or Lighting.EnvironmentSpecularScale

    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0

    for _,e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect")
                or e:IsA("SunRaysEffect")
                or e:IsA("ColorCorrectionEffect")
                or e:IsA("BloomEffect")
                or e:IsA("DepthOfFieldEffect") then
                e.Enabled = false
            end
        end)
    end

    for _,obj in ipairs(workspace:GetDescendants()) do
        _applyAntiLagObj(obj)
    end

    if S.conn then S.conn:Disconnect() end
    S.conn = workspace.DescendantAdded:Connect(function(obj)
        if S.active then _applyAntiLagObj(obj) end
    end)
    antiLagDescConn = S.conn
end

function disableAntiLag()
    antiLagVisualEnabled = false
    local S = _G.AdaptZombieAntiLag
    S.active = false

    if S.conn then
        S.conn:Disconnect()
        S.conn = nil
    end
    antiLagDescConn = nil

    pcall(function()
        Lighting.GlobalShadows = true
        if S.defBrightness then Lighting.Brightness = S.defBrightness end
        if S.defFog then Lighting.FogEnd = S.defFog end
        if S.defDiffuse then Lighting.EnvironmentDiffuseScale = S.defDiffuse end
        if S.defSpecular then Lighting.EnvironmentSpecularScale = S.defSpecular end

        for _,e in pairs(Lighting:GetChildren()) do
            pcall(function()
                if e:IsA("BlurEffect")
                    or e:IsA("SunRaysEffect")
                    or e:IsA("ColorCorrectionEffect")
                    or e:IsA("BloomEffect")
                    or e:IsA("DepthOfFieldEffect") then
                    e.Enabled = true
                end
            end)
        end
    end)
end

function applyKTMOptimization()
    enableAntiLag()
end

function enableNukeOptimizer()
nukeOptimiserEnabled=true; _aceNukeOn=true; applyKTMOptimization(); applyCustomSky("Off")
for _,c in ipairs(_aceNukeConns) do pcall(function() c:Disconnect() end) end; _aceNukeConns={}
table.insert(_aceNukeConns, workspace.DescendantAdded:Connect(function(o) if nukeOptimiserEnabled then _applyAntiLagObj(o) end end))
task.spawn(function() while nukeOptimiserEnabled do pcall(function() setfpscap(240) end); task.wait(3) end end)
end
function disableNukeOptimizer() nukeOptimiserEnabled=false; _aceNukeOn=false; for _,c in ipairs(_aceNukeConns) do pcall(function() c:Disconnect() end) end; _aceNukeConns={} end
function enableNoCamCollision()
noCamCollisionEnabled=true; if noCamCollisionConn then noCamCollisionConn:Disconnect() end
noCamCollisionConn=RunService.RenderStepped:Connect(function()
if not noCamCollisionEnabled then return end
local cam=workspace.CurrentCamera; local char=LP.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart"); if not cam or not hrp then return end
local params=RaycastParams.new(); params.FilterType=Enum.RaycastFilterType.Exclude; params.FilterDescendantsInstances=workspace.CurrentCamera and workspace.CurrentCamera:FindFirstChild("_AdaptAvatarOverlay") and {char,workspace.CurrentCamera:FindFirstChild("_AdaptAvatarOverlay")} or {char}; params.IgnoreWater=true
local res=workspace:Raycast(cam.CFrame.Position,(hrp.Position+Vector3.new(0,1.5,0))-cam.CFrame.Position,params)
local hit={}
if res and res.Instance and res.Instance:IsA("BasePart") then hit[res.Instance]=true; if noCamCollisionParts[res.Instance]==nil then noCamCollisionParts[res.Instance]=res.Instance.LocalTransparencyModifier end; res.Instance.LocalTransparencyModifier=1 end
for part,orig in pairs(noCamCollisionParts) do if not hit[part] then pcall(function() if part and part.Parent then part.LocalTransparencyModifier=orig end end); noCamCollisionParts[part]=nil end end
end)
end
function disableNoCamCollision() noCamCollisionEnabled=false; if noCamCollisionConn then noCamCollisionConn:Disconnect(); noCamCollisionConn=nil end; for p,orig in pairs(noCamCollisionParts) do pcall(function() if p and p.Parent then p.LocalTransparencyModifier=orig end end) end; noCamCollisionParts={} end
function enableCustomFont() customFontVisualEnabled=false; if V then V.customFontEnabled=false end end
function disableCustomFont() customFontVisualEnabled=false; if V then V.customFontEnabled=false end end
end
V = V or {}
V.skyTheme = skyTheme or V.skyTheme or "Off"
V.nukeOptEnabled = nukeOptimiserEnabled == true
V.customFontEnabled = false
V.potatoGraphicsEnabled = V.potatoGraphicsEnabled or false
function enableNoCamCollision()
noCamCollisionEnabled = true
if noCamCollisionConn then noCamCollisionConn:Disconnect() end
noCamCollisionConn = RunService.RenderStepped:Connect(function()
if not noCamCollisionEnabled then
if noCamCollisionConn then noCamCollisionConn:Disconnect();noCamCollisionConn=nil end
return
end
local cam = workspace.CurrentCamera
local char = LP.Character
if not cam or not char then return end
local hrp = char:FindFirstChild("HumanoidRootPart")
if not hrp then return end
local camPos = cam.CFrame.Position
local charPos = hrp.Position + Vector3.new(0,1.5,0)
local toChar = charPos - camPos
if toChar.Magnitude < 0.3 then return end
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances = workspace.CurrentCamera and workspace.CurrentCamera:FindFirstChild("_AdaptAvatarOverlay") and {char, workspace.CurrentCamera:FindFirstChild("_AdaptAvatarOverlay")} or {char}
params.IgnoreWater = true
local hit = {}
local origin = camPos
local remaining = toChar
for _ = 1,12 do
if remaining.Magnitude < 0.2 then break end
local res = workspace:Raycast(origin,remaining,params)
if not res then break end
local part = res.Instance
if part and part:IsA("BasePart") and not part:IsDescendantOf(char) then
hit[part] = true
if noCamCollisionParts[part] == nil then noCamCollisionParts[part] = part.LocalTransparencyModifier end
part.LocalTransparencyModifier = 1
end
origin = res.Position + remaining.Unit * 0.02
remaining = charPos - origin
end
for part,orig in pairs(noCamCollisionParts) do
if not hit[part] then
pcall(function() if part and part.Parent then part.LocalTransparencyModifier = orig end end)
noCamCollisionParts[part] = nil
end
end
end)
end
function disableNoCamCollision()
noCamCollisionEnabled = false
if noCamCollisionConn then noCamCollisionConn:Disconnect();noCamCollisionConn=nil end
for part,orig in pairs(noCamCollisionParts) do
pcall(function() if part and part.Parent then part.LocalTransparencyModifier = orig end end)
end
noCamCollisionParts = {}
end
SKY_PRESETS_LIST = {"Off","Night","Aurora","Sunset","Galaxy","Tech","Sakura","Pink Night",
"Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse",
"Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}
SKY_PRESETS = {
["Off"] = {kind = "off"},
["Night"] = {clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
["Aurora"] = {clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
["Sunset"] = {clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
["Galaxy"] = {clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
["Tech"] = {clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
["Sakura"] = {clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
["Pink Night"] = {clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
["Blood Moon"] = {clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
["Emerald Dawn"] = {clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
["Volcanic"] = {clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
["Arctic"] = {clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
["Midnight Ocean"] = {clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
["Vaporwave"] = {clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.5,dens=0.55,color={200,150,255}}},
["Toxic"] = {clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
["Solar Eclipse"] = {clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
["Hellscape"] = {clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
["Heaven"] = {clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
["Storm"] = {clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
["Sunrise"] = {clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
["Deep Space"] = {clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
["Lavender Dream"] = {clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
["Inferno"] = {clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
["Mint Sky"] = {clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}
function _vC3(t) return Color3.fromRGB(t[1], t[2], t[3]) end
function _v4mpClearSky()
for _, v in ipairs(Lighting:GetChildren()) do
if v:GetAttribute("_AdaptDuelsSky") then pcall(function() v:Destroy() end) end
end
local terrain = workspace:FindFirstChildOfClass("Terrain")
if terrain then
for _, v in ipairs(terrain:GetChildren()) do
if v:GetAttribute("_AdaptDuelsSky") then pcall(function() v:Destroy() end) end
end
end
end
function applyCustomSky(mode)
_v4mpClearSky()
local preset = SKY_PRESETS[mode]
if not preset or preset.kind == "off" then
Lighting.FogEnd = 100000; Lighting.FogStart = 0
Lighting.FogColor = Color3.fromRGB(192,192,192)
Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = true
V.skyTheme = "Off"
return
end
Lighting.FogEnd = 100000; Lighting.FogStart = 0
Lighting.FogColor = Color3.fromRGB(200,200,200)
Lighting.GlobalShadows = true
Lighting.ClockTime = preset.clock or 14
Lighting.Brightness = preset.brightness or 2
if preset.outAmb then Lighting.OutdoorAmbient = _vC3(preset.outAmb) end
if preset.ambient then Lighting.Ambient = _vC3(preset.ambient) end
if preset.sky then
local sky = Instance.new("Sky")
sky:SetAttribute("_AdaptDuelsSky", true)
if preset.sky.stars then sky.StarCount = preset.sky.stars end
if preset.sky.moon then sky.MoonAngularSize = preset.sky.moon end
if preset.sky.sun then sky.SunAngularSize = preset.sky.sun end
if preset.sky.moonTex then sky.MoonTextureId = "rbxasset://sky/moon.jpg" end
sky.Parent = Lighting
end
if preset.atm then
local atm = Instance.new("Atmosphere")
atm:SetAttribute("_AdaptDuelsSky", true)
atm.Density = preset.atm.dens or 0.3
atm.Color = _vC3(preset.atm.color)
atm.Decay = _vC3(preset.atm.decay)
atm.Glare = preset.atm.glare or 1
atm.Haze = preset.atm.haze or 1
atm.Parent = Lighting
end
local terrain = workspace:FindFirstChildOfClass("Terrain")
if preset.clouds and terrain then
local clouds = Instance.new("Clouds")
clouds:SetAttribute("_AdaptDuelsSky", true)
clouds.Cover = preset.clouds.cover or 0.5
clouds.Density = preset.clouds.dens or 0.5
clouds.Color = _vC3(preset.clouds.color)
clouds.Parent = terrain
end
V.skyTheme = mode
end
function enableUltraMode()
V.ultraModeEnabled = true
applyKTMOptimization()
end
function disableUltraMode()
V.ultraModeEnabled = false
end
function enableRemoveAccessories()
V.removeAccessoriesEnabledSep = true
removeAccessoriesEnabled = true
removeAllAccessories()
if V.removeAccConn then V.removeAccConn:Disconnect() end
V.removeAccConn = Players.PlayerAdded:Connect(function(player)
player.CharacterAdded:Connect(function(char)
task.wait(0.5)
if V.removeAccessoriesEnabledSep or removeAccessoriesEnabled then
for _,obj in ipairs(char:GetDescendants()) do processAntiLagDescendant(obj) end
end
end)
end)
if antiLagDescConn then antiLagDescConn:Disconnect() end
antiLagDescConn = Workspace.DescendantAdded:Connect(function(obj)
if antiLagEnabled or V.ultraModeEnabled or removeAccessoriesEnabled or V.removeAccessoriesEnabledSep then
processAntiLagDescendant(obj)
end
end)
end
function disableRemoveAccessories()
V.removeAccessoriesEnabledSep = false
removeAccessoriesEnabled = false
if V.removeAccConn then V.removeAccConn:Disconnect(); V.removeAccConn = nil end
if not antiLagEnabled and not V.ultraModeEnabled and antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn = nil end
end
_nukeOptimizerOn = false
_nukeOptimizerConns = {}
_nukeOptimizerThreads = {}
function enableNukeOptimizer()
if _nukeOptimizerOn then return end
_nukeOptimizerOn = true
nukeOptimiserEnabled = true
V.nukeOptEnabled = true
local MaterialService = game:GetService("MaterialService")
local XMin, XMax = -560, -240
local ClothingClasses = {"Shirt","Pants","ShirtGraphic","Accessory","Hat","HairAccessory","FaceAccessory","NeckAccessory","ShoulderAccessory","FrontAccessory","BackAccessory","WaistAccessory"}
local BASE_NAMES = {"baseplate","spawnlocation","spawn location","spawn"}
function SafeDestroy(obj)
if obj and obj.Name == "Overhead" then return end
pcall(function() obj:Destroy() end)
end
function IsClothing(obj)
for _, className in ipairs(ClothingClasses) do
if obj:IsA(className) then return true end
end
return false
end
function IsCharacterPart(obj)
for _, plr in ipairs(Players:GetPlayers()) do
if plr.Character and obj:IsDescendantOf(plr.Character) then return true end
end
return false
end
function IsOutOfRange(obj)
if obj:IsA("BasePart") then
local x = obj.Position.X
return x < XMin or x > XMax
end
return false
end
function IsBase(obj)
if not obj:IsA("BasePart") then return false end
local nl = obj.Name:lower()
for _, n in ipairs(BASE_NAMES) do
if nl:find(n, 1, true) then return true end
end
return false
end
function IsInBase(obj)
local p = obj.Parent
while p and p ~= workspace do
if IsBase(p) then return true end
p = p.Parent
end
return false
end
function MakeTransparent(obj)
pcall(function()
if IsBase(obj) and not IsCharacterPart(obj) then
obj.Transparency = 1
obj.CastShadow = false
end
end)
end
function StripObject(obj)
pcall(function()
if obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("SpecialMesh") then
SafeDestroy(obj)
elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
pcall(function() obj.Enabled = false end)
SafeDestroy(obj)
elseif obj:IsA("SurfaceAppearance") then
SafeDestroy(obj)
elseif obj:IsA("BasePart") then
obj.CastShadow = false
obj.Material = Enum.Material.Plastic
obj.MaterialVariant = ""
obj.Reflectance = 0
end
end)
end
function CleanObject(obj)
pcall(function()
if obj:IsA("SurfaceAppearance") then
SafeDestroy(obj)
elseif obj:IsA("Decal") or obj:IsA("Texture") then
if not (obj.Name == "face" and obj.Parent and obj.Parent.Name == "Head") then SafeDestroy(obj) end
elseif obj:IsA("SpecialMesh") then
obj.TextureId = ""
elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
SafeDestroy(obj)
elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
SafeDestroy(obj)
elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Explosion") then
SafeDestroy(obj)
elseif obj:IsA("Animation") or obj:IsA("AnimationController") then
SafeDestroy(obj)
elseif obj:IsA("BasePart") then
obj.CastShadow = false
obj.Material = Enum.Material.Plastic
obj.MaterialVariant = ""
obj.Reflectance = 0
end
end)
end
function ApplyGreySky()
pcall(function()
for _, obj in ipairs(Lighting:GetChildren()) do
if obj:IsA("Sky") then obj:Destroy() end
end
local sky = Instance.new("Sky")
sky.SkyboxBk = ""; sky.SkyboxDn = ""; sky.SkyboxFt = ""
sky.SkyboxLf = ""; sky.SkyboxRt = ""; sky.SkyboxUp = ""
sky.CelestialBodiesShown = false
sky.Name = "_AdaptDuelsNukeSky"
sky.Parent = Lighting
end)
end
function OptimizeLighting()
pcall(function()
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.FogStart = 9e9
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0
Lighting.Brightness = 1.5
Lighting.Ambient = Color3.fromRGB(60,60,60)
for _, v in ipairs(Lighting:GetChildren()) do
if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Atmosphere") or v:IsA("Clouds") then
v:Destroy()
end
end
ApplyGreySky()
end)
end
function ApplyTerrain()
pcall(function()
local terrain = workspace:FindFirstChildOfClass("Terrain")
if terrain then
terrain.Decoration = false
terrain.WaterWaveSize = 0
terrain.WaterWaveSpeed = 0
terrain.WaterReflectance = 0
terrain.WaterTransparency = 1
end
end)
end
function OptimizeCharacter(char)
if not char then return end
task.spawn(function()
task.wait(0.3)
if not _nukeOptimizerOn then return end
for _, obj in ipairs(char:GetDescendants()) do
if IsClothing(obj) then SafeDestroy(obj) else CleanObject(obj) end
end
end)
end
pcall(function()
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
end)
pcall(function() if setfpscap then setfpscap(999) end end)
table.insert(_nukeOptimizerThreads, task.spawn(function()
if not game:IsLoaded() then game.Loaded:Wait() end
OptimizeLighting()
ApplyTerrain()
for _, obj in ipairs(workspace:GetDescendants()) do
if not _nukeOptimizerOn then return end
if IsBase(obj) then
MakeTransparent(obj)
elseif IsClothing(obj) then
SafeDestroy(obj)
elseif IsInBase(obj) then
elseif IsCharacterPart(obj) then
elseif IsOutOfRange(obj) then
SafeDestroy(obj)
else
CleanObject(obj)
StripObject(obj)
end
end
for _, obj in ipairs(workspace:GetDescendants()) do MakeTransparent(obj) end
end))
table.insert(_nukeOptimizerConns, workspace.DescendantAdded:Connect(function(obj)
if not _nukeOptimizerOn then return end
task.defer(function()
if not _nukeOptimizerOn then return end
if IsBase(obj) then MakeTransparent(obj); return end
if IsClothing(obj) then
SafeDestroy(obj)
elseif IsInBase(obj) then
elseif IsCharacterPart(obj) then
elseif IsOutOfRange(obj) then
SafeDestroy(obj)
else
CleanObject(obj)
StripObject(obj)
end
end)
end))
table.insert(_nukeOptimizerConns, Lighting.DescendantAdded:Connect(function(obj)
if not _nukeOptimizerOn then return end
if obj:IsA("Atmosphere") or obj:IsA("Clouds") or obj:IsA("PostEffect") then SafeDestroy(obj) end
end))
table.insert(_nukeOptimizerConns, MaterialService.DescendantAdded:Connect(function(obj)
if not _nukeOptimizerOn then return end
SafeDestroy(obj)
end))
for _, plr in ipairs(Players:GetPlayers()) do
OptimizeCharacter(plr.Character)
table.insert(_nukeOptimizerConns, plr.CharacterAdded:Connect(OptimizeCharacter))
end
table.insert(_nukeOptimizerConns, Players.PlayerAdded:Connect(function(plr)
table.insert(_nukeOptimizerConns, plr.CharacterAdded:Connect(OptimizeCharacter))
end))
table.insert(_nukeOptimizerThreads, task.spawn(function()
while _nukeOptimizerOn do
task.wait(15)
pcall(function() collectgarbage("collect") end)
end
end))
end
function disableNukeOptimizer()
_nukeOptimizerOn = false
nukeOptimiserEnabled = false
V.nukeOptEnabled = false
for _, c in ipairs(_nukeOptimizerConns) do pcall(function() c:Disconnect() end) end
_nukeOptimizerConns = {}
_nukeOptimizerThreads = {}
end
function enableCustomFont() customFontVisualEnabled=false; if V then V.customFontEnabled=false end end
function disableCustomFont() customFontVisualEnabled=false; if V then V.customFontEnabled=false end end
__ace_src_enableNoCamCollision = enableNoCamCollision
function enableNoCamCollision()
__ace_src_enableNoCamCollision()
noCamCollisionEnabled = true
end
__ace_src_disableNoCamCollision = disableNoCamCollision
function disableNoCamCollision()
__ace_src_disableNoCamCollision()
noCamCollisionEnabled = false
end

_G.AdaptInstallAvatarChanger = function()
    local XAC = {
        model = nil,
        renderConn = nil,
        fpConn = nil,
        hideConn = nil,
        hideEnforceConn = nil,
        motorPairs = {},
        fpHidden = {},
        hiddenParts = {},
        paused = false,
        lastUserId = nil,
        lastUsername = nil,
    }
    _G.AdaptAvatarChangerState = XAC

    local function getFolder()
        local cam = workspace.CurrentCamera
        if not cam then return nil end
        local folder = cam:FindFirstChild("_AdaptAvatarOverlay")
        if not folder then
            folder = Instance.new("Folder")
            folder.Name = "_AdaptAvatarOverlay"
            folder.Parent = cam
        end
        return folder
    end

    local function stopConn(name)
        local c = XAC[name]
        if c then pcall(function() c:Disconnect() end) end
        XAC[name] = nil
    end

    local function restoreReal()
        for inst, old in pairs(XAC.hiddenParts) do
            if inst and inst.Parent then
                pcall(function()
                    if inst:IsA("BasePart") then
                        inst.LocalTransparencyModifier = old
                    elseif inst:IsA("Decal") or inst:IsA("Texture") then
                        inst.Transparency = old
                    end
                end)
            end
        end
        table.clear(XAC.hiddenParts)
    end

    local function setRealHidden(on)
        stopConn("hideConn")
        stopConn("hideEnforceConn")
        restoreReal()
        if not on then return end

        local function hideOne(inst)
            if inst:IsA("BasePart") then
                if XAC.hiddenParts[inst] == nil then
                    XAC.hiddenParts[inst] = inst.LocalTransparencyModifier
                end
                inst.LocalTransparencyModifier = 1
            elseif inst:IsA("Decal") or inst:IsA("Texture") then
                if XAC.hiddenParts[inst] == nil then
                    XAC.hiddenParts[inst] = inst.Transparency
                end
                inst.Transparency = 1
            end
        end

        local char = LP.Character
        if not char then return end
        for _, inst in ipairs(char:GetDescendants()) do pcall(hideOne, inst) end

        XAC.hideConn = char.DescendantAdded:Connect(function(inst)
            task.defer(function()
                if inst and inst.Parent then pcall(hideOne, inst) end
            end)
        end)

        XAC.hideEnforceConn = RunService.RenderStepped:Connect(function()
            local c = LP.Character
            if not c or not XAC.model then return end
            for _, inst in ipairs(c:GetDescendants()) do pcall(hideOne, inst) end
        end)
    end

    local function restoreOverlay()
        for inst, old in pairs(XAC.fpHidden) do
            if inst and inst.Parent then
                pcall(function()
                    if inst:IsA("BasePart") then
                        inst.LocalTransparencyModifier = old
                    elseif inst:IsA("Decal") or inst:IsA("Texture") then
                        inst.Transparency = old
                    end
                end)
            end
        end
        table.clear(XAC.fpHidden)
    end

    local function hideOverlay()
        if not XAC.model then return end
        for _, inst in ipairs(XAC.model:GetDescendants()) do
            if inst:IsA("BasePart") then
                if XAC.fpHidden[inst] == nil then
                    XAC.fpHidden[inst] = inst.LocalTransparencyModifier
                end
                inst.LocalTransparencyModifier = 1
            elseif inst:IsA("Decal") or inst:IsA("Texture") then
                if XAC.fpHidden[inst] == nil then
                    XAC.fpHidden[inst] = inst.Transparency
                end
                inst.Transparency = 1
            end
        end
    end

    local function startFirstPerson()
        stopConn("fpConn")
        local hidden = false
        XAC.fpConn = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            local char = LP.Character
            local head = char and char:FindFirstChild("Head")
            if not XAC.model or not cam or not head then return end

            local d = (cam.CFrame.Position - head.Position).Magnitude
            local lockFP = LP.CameraMode == Enum.CameraMode.LockFirstPerson

            --Leaked By Xlu0 AndPrime--
            if hidden then
                if not lockFP and d > 1.15 then hidden = false end
            else
                if lockFP or d <= 0.95 then hidden = true end
            end

            if hidden then
                --Leaked By Xlu0 AndPrime--
                hideOverlay()
                for _, inst in ipairs(XAC.model:GetDescendants()) do
                    if inst:IsA("BasePart") then
                        inst.LocalTransparencyModifier = 1
                    elseif inst:IsA("Decal") or inst:IsA("Texture") then
                        inst.Transparency = 1
                    end
                end
            elseif next(XAC.fpHidden) ~= nil then
                restoreOverlay()
            end
        end)
    end

    local function destroyOverlay()
        stopConn("renderConn")
        stopConn("fpConn")
        restoreOverlay()
        if XAC.model then pcall(function() XAC.model:Destroy() end) end
        XAC.model = nil
        XAC.paused = false
    end

    local function prepare(model)
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("Script") or d:IsA("LocalScript") then
                d.Disabled = true
            elseif d:IsA("BasePart") then
                d.CanCollide = false
                d.CanTouch = false
                d.CanQuery = false
                d.Massless = true
            end
        end
        local hum = model:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = true
            hum.AutoRotate = false
            hum.Sit = true
            hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            hum.NameDisplayDistance = 0
            hum.HealthDisplayDistance = 0
        end
        return model
    end

    local function motorKey(m)
        return m.Name .. "|" ..
            ((m.Part0 and m.Part0.Name) or "nil") .. ">" ..
            ((m.Part1 and m.Part1.Name) or "nil")
    end

    local function buildPairs(srcChar, target)
        table.clear(XAC.motorPairs)
        local a, b = {}, {}
        for _, d in ipairs(srcChar:GetDescendants()) do
            if d:IsA("Motor6D") then a[motorKey(d)] = d end
        end
        for _, d in ipairs(target:GetDescendants()) do
            if d:IsA("Motor6D") then b[motorKey(d)] = d end
        end
        for k, src in pairs(a) do
            if b[k] then table.insert(XAC.motorPairs, {src = src, tgt = b[k]}) end
        end
    end

    local function startMirror()
        stopConn("renderConn")
        XAC.renderConn = RunService.RenderStepped:Connect(function()
            if XAC.paused or not XAC.model then return end
            for _, pair in ipairs(XAC.motorPairs) do
                if pair.src and pair.tgt and pair.src.Parent and pair.tgt.Parent then
                    pair.tgt.Transform = pair.src.Transform
                end
            end
        end)
    end

    local function resolve(value)
        value = tostring(value or ""):gsub("^%s+",""):gsub("%s+$","")
        if value == "" then return false, "ENTER USERNAME / USER ID" end
        local n = tonumber(value)
        if n then
            local uid = math.floor(n)
            local ok, name = pcall(function() return Players:GetNameFromUserIdAsync(uid) end)
            if not ok or not name then return false, "USER NOT FOUND" end
            return true, uid, name
        end
        local ok, uid = pcall(function() return Players:GetUserIdFromNameAsync(value) end)
        if not ok or not uid then return false, "USER NOT FOUND" end
        return true, uid, value
    end

    local function spawnAvatar(uid, username, status)
        status = status or function() end
        status("SPAWNING...")
        destroyOverlay()

        local ok, model = pcall(function()
            return Players:CreateHumanoidModelFromUserIdAsync(uid)
        end)
        if not ok or typeof(model) ~= "Instance" then
            status("FAILED")
            return
        end

        model = prepare(model)
        model.Name = "AdaptAvatarOverlay_" .. tostring(uid)

        local folder = getFolder()
        local char = LP.Character
        local myHRP = char and char:FindFirstChild("HumanoidRootPart")
        local oHRP = model:FindFirstChild("HumanoidRootPart")
        if not folder or not myHRP or not oHRP then
            model:Destroy()
            status("HRP NOT READY")
            return
        end

        model.Parent = folder
        model:PivotTo(myHRP.CFrame)

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = oHRP
        weld.Part1 = myHRP
        weld.Parent = oHRP

        XAC.model = model
        XAC.lastUserId = uid
        XAC.lastUsername = username
        _G.AdaptAvatarChangerCleared = false
        XAC.paused = false

        --Leaked By Xlu0 AndPrime--
        pcall(function()
            if _G.AdaptApplyHeadless then
                _G.AdaptApplyHeadless(model, _G.AdaptHeadlessEnabled == true)
            end
            if _G.AdaptApplyKorblox then
                _G.AdaptApplyKorblox(model, _G.AdaptKorbloxEnabled == true)
            end
        end)

        setRealHidden(true)
        buildPairs(char, model)
        startMirror()
        startFirstPerson()
        status("ACTIVE - " .. tostring(username))
    end

    _G.AdaptAvatarChangerSpawn = spawnAvatar
    _G.AdaptAvatarChangerRemove = function()
        destroyOverlay()
        setRealHidden(false)
        XAC.lastUserId = nil
        XAC.lastUsername = nil
        _G.AdaptAvatarChangerCleared = true
    end
    _G.AdaptAvatarChangerResolve = resolve

    _G.AdaptOpenAvatarChanger = function()
        local old = PlayerGui:FindFirstChild("AdaptAvatarChangerGallery")
        if old then old:Destroy() end

        local sg = Instance.new("ScreenGui")
        sg.Name = "AdaptAvatarChangerGallery"
        sg.IgnoreGuiInset = true
        sg.ResetOnSpawn = false
        sg.DisplayOrder = 99999
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        safeParentGui(sg)

        local shade = Instance.new("TextButton")
        shade.Text = ""
        shade.AutoButtonColor = false
        shade.BackgroundColor3 = Color3.fromRGB(0,0,0)
        shade.BackgroundTransparency = 0.25
        shade.Size = UDim2.fromScale(1,1)
        shade.ZIndex = 1
        shade.Parent = sg

        local panel = Instance.new("Frame")
        panel.AnchorPoint = Vector2.new(0.5,0.5)
        panel.Position = UDim2.fromScale(0.5,0.5)
        panel.Size = UDim2.new(0, 620, 0, 500)
        panel.BackgroundColor3 = Color3.fromRGB(10,10,15)
        panel.BackgroundTransparency = 0.04
        panel.BorderSizePixel = 0
        panel.ZIndex = 2
        panel.Parent = sg
        corner(panel,16)
        stroke(panel,COLORS.strokeSoft,1.2,0.15)

        pcall(function()
            local bg = Main and Main:FindFirstChild("CustomBackground")
            if bg and bg:IsA("ImageLabel") and bg.Visible and bg.Image ~= "" then
                local pbg = bg:Clone()
                pbg.Name = "PanelBackground"
                pbg.Size = UDim2.fromScale(1,1)
                pbg.Position = UDim2.fromScale(0,0)
                pbg.ZIndex = 2
                pbg.ImageTransparency = math.max(bg.ImageTransparency,0.18)
                pbg.Parent = panel
                corner(pbg,16)
            end
        end)

        local title = Instance.new("TextLabel")
        title.BackgroundTransparency = 1
        title.Text = "ADAPT AVATAR CHANGER (NOT WORKING)"
        title.TextColor3 = COLORS.white
        title.Font = Enum.Font.GothamMedium
        title.TextSize = 19
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Position = UDim2.new(0,18,0,10)
        title.Size = UDim2.new(1,-70,0,38)
        title.ZIndex = 4
        title.Parent = panel

        local close = Instance.new("TextButton")
        close.Text = "X"
        close.Font = Enum.Font.GothamMedium
        close.TextSize = 11
        close.TextColor3 = COLORS.white
        close.BackgroundColor3 = Color3.fromRGB(16,16,22)
        close.Size = UDim2.fromOffset(34,30)
        close.Position = UDim2.new(1,-46,0,14)
        close.ZIndex = 5
        close.Parent = panel
        corner(close,9)
        stroke(close,COLORS.strokeSoft,1,0.45)

        local input = Instance.new("TextBox")
        input.PlaceholderText = "SEARCH ANY ROBLOX USER..."
        input.ClearTextOnFocus = false
        input.Text = ""
        input.Font = Enum.Font.GothamMedium
        input.TextSize = 11
        input.TextColor3 = COLORS.white
        input.PlaceholderColor3 = Color3.fromRGB(140,140,150)
        input.BackgroundColor3 = Color3.fromRGB(16,16,22)
        input.BackgroundTransparency = 0.06
        input.Position = UDim2.new(0,18,0,58)
        input.Size = UDim2.new(1,-36,0,36)
        input.ZIndex = 4
        input.Parent = panel
        corner(input,9)
        stroke(input,COLORS.strokeSoft,1,0.5)

        local sectionLabel = Instance.new("TextLabel")
        sectionLabel.BackgroundTransparency = 1
        sectionLabel.Text = "FEATURED"
        sectionLabel.TextColor3 = COLORS.white
        sectionLabel.Font = Enum.Font.GothamMedium
        sectionLabel.TextSize = 10
        sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        sectionLabel.Position = UDim2.new(0,18,0,98)
        sectionLabel.Size = UDim2.new(1,-36,0,20)
        sectionLabel.ZIndex = 4
        sectionLabel.Parent = panel

        local status = Instance.new("TextLabel")
        status.BackgroundTransparency = 1
        status.Text = "LOADING FEATURED..."
        status.TextColor3 = Color3.fromRGB(180,180,190)
        status.Font = Enum.Font.GothamMedium
        status.TextSize = 9
        status.TextXAlignment = Enum.TextXAlignment.Left
        status.Position = UDim2.new(0,18,1,-28)
        status.Size = UDim2.new(1,-36,0,20)
        status.ZIndex = 4
        status.Parent = panel
        status.Size = UDim2.new(1,-190,0,20)

        --Leaked By Xlu0 AndPrime--
        local removeAvatarBtn = Instance.new("TextButton")
        removeAvatarBtn.Name = "RemoveAvatarButton"
        removeAvatarBtn.Text = "REMOVE AVATAR"
        removeAvatarBtn.Font = Enum.Font.GothamMedium
        removeAvatarBtn.TextSize = 9
        removeAvatarBtn.TextColor3 = Color3.fromRGB(255,255,255)
        removeAvatarBtn.BackgroundColor3 = Color3.fromRGB(170,35,35)
        removeAvatarBtn.BackgroundTransparency = 0
        removeAvatarBtn.BorderSizePixel = 0
        removeAvatarBtn.Position = UDim2.new(1,-168,1,-34)
        removeAvatarBtn.Size = UDim2.new(0,150,0,26)
        removeAvatarBtn.ZIndex = 6
        removeAvatarBtn.Parent = panel
        corner(removeAvatarBtn,8)
        stroke(removeAvatarBtn,Color3.fromRGB(235,75,75),1,0.15)

        removeAvatarBtn.MouseButton1Click:Connect(function()
            if _G.AdaptAvatarChangerRemove then
                pcall(_G.AdaptAvatarChangerRemove)
                status.Text = "AVATAR REMOVED"
            else
                status.Text = "REMOVE FAILED"
            end
        end)

        local scroll = Instance.new("ScrollingFrame")
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.Position = UDim2.new(0,12,0,122)
        scroll.Size = UDim2.new(1,-24,1,-160)
        scroll.ScrollBarThickness = 4
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.CanvasSize = UDim2.new(0,0,0,0)
        scroll.ZIndex = 4
        scroll.Parent = panel

        local grid = Instance.new("UIGridLayout")
        grid.CellSize = UDim2.fromOffset(132,160)
        grid.CellPadding = UDim2.fromOffset(10,10)
        grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
        grid.SortOrder = Enum.SortOrder.LayoutOrder
        grid.Parent = scroll

        local famousSeeds = {
            "Roblox","Builderman","KreekCraft","Flamingo","ItsFunneh",
            "DenisDaily","RussoTalks","MeganPlays","LeahAshe","Thinknoodles",
            "SharkBlox","InquisitorMaster","GamingWithKev","Sketch","Bandites",
            "TanqR","DVPlays","NightFoxx","iamSanna","Temprist",
            "MiniToon","asimo3089","badcc","NewFissy","Coeptus",
            "Wolfpaq","BelowNatural","callmehbob"
        }

        local featuredUsers = {}
        local searchResults = {}
        local searchToken = 0

        local function clearCards()
            for _, child in ipairs(scroll:GetChildren()) do
                if child:IsA("GuiButton") then child:Destroy() end
            end
        end

        local function addCard(userData, order)
            local card = Instance.new("TextButton")
            card.Text = ""
            card.AutoButtonColor = false
            card.BackgroundColor3 = Color3.fromRGB(16,16,22)
            card.BackgroundTransparency = 0.07
            card.BorderSizePixel = 0
            card.LayoutOrder = order
            card.ZIndex = 5
            card.Parent = scroll
            corner(card,11)
            stroke(card,COLORS.strokeSoft,1,0.55)

            local thumb = Instance.new("ImageLabel")
            thumb.BackgroundColor3 = Color3.fromRGB(10,10,14)
            thumb.BackgroundTransparency = 0.08
            thumb.BorderSizePixel = 0
            thumb.Position = UDim2.new(0,8,0,8)
            thumb.Size = UDim2.new(1,-16,0,108)
            thumb.ScaleType = Enum.ScaleType.Crop
            thumb.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(userData.id) .. "&w=150&h=150"
            thumb.ZIndex = 6
            thumb.Parent = card
            corner(thumb,9)

            if userData.hasVerifiedBadge == true then
                local verified = Instance.new("TextLabel")
                verified.BackgroundColor3 = Color3.fromRGB(255,255,255)
                verified.BackgroundTransparency = 0.08
                verified.Text = "✓"
                verified.TextColor3 = Color3.fromRGB(10,10,15)
                verified.Font = Enum.Font.GothamMedium
                verified.TextSize = 12
                verified.Size = UDim2.fromOffset(20,20)
                verified.Position = UDim2.new(1,-26,0,14)
                verified.ZIndex = 8
                verified.Parent = card
                corner(verified,999)
            end

            local display = Instance.new("TextLabel")
            display.BackgroundTransparency = 1
            display.Text = tostring(userData.displayName or userData.name)
            display.TextColor3 = COLORS.white
            display.Font = Enum.Font.GothamMedium
            display.TextSize = 9
            display.TextWrapped = true
            display.TextXAlignment = Enum.TextXAlignment.Center
            display.Position = UDim2.new(0,5,0,119)
            display.Size = UDim2.new(1,-10,0,17)
            display.ZIndex = 6
            display.Parent = card

            local username = Instance.new("TextLabel")
            username.BackgroundTransparency = 1
            username.Text = "@" .. tostring(userData.name)
            username.TextColor3 = Color3.fromRGB(160,160,175)
            username.Font = Enum.Font.GothamMedium
            username.TextSize = 9
            username.TextXAlignment = Enum.TextXAlignment.Center
            username.Position = UDim2.new(0,5,0,137)
            username.Size = UDim2.new(1,-10,0,15)
            username.ZIndex = 6
            username.Parent = card

            card.MouseButton1Click:Connect(function()
                spawnAvatar(userData.id, userData.name, function(v)
                    status.Text = tostring(v)
                end)
                task.defer(function()
                    if sg and sg.Parent then
                        sg:Destroy()
                    end
                end)
            end)
        end

        local function renderFeatured()
            clearCards()
            sectionLabel.Text = "FEATURED"
            local count = 0
            for _, u in ipairs(featuredUsers) do
                count += 1
                addCard(u, count)
            end
            status.Text = tostring(count) .. " FEATURED AVATARS"
        end

        local function renderSearch()
            clearCards()
            sectionLabel.Text = "SEARCH RESULTS"
            local count = 0
            for _, u in ipairs(searchResults) do
                count += 1
                addCard(u, count)
            end
            status.Text = tostring(count) .. " RESULTS"
        end

        local function searchAnyUser(query)
            query = tostring(query or ""):gsub("^%s+",""):gsub("%s+$","")
            searchToken += 1
            local myToken = searchToken

            if query == "" then
                searchResults = {}
                renderFeatured()
                return
            end

            status.Text = "SEARCHING..."
            sectionLabel.Text = "SEARCH RESULTS"

            task.spawn(function()
                local results = {}

                --Leaked By Xlu0 AndPrime--
                local okId, uid = pcall(function()
                    return Players:GetUserIdFromNameAsync(query)
                end)

                if myToken ~= searchToken then return end

                if okId and uid and uid > 0 then
                    local okInfo, body = pcall(function()
                        return game:HttpGet("https://users.roblox.com/v1/users/" .. tostring(uid))
                    end)
                    if okInfo and body and body ~= "" then
                        local okJson, data = pcall(function()
                            return HttpService:JSONDecode(body)
                        end)
                        if okJson and type(data) == "table" then
                            table.insert(results, {
                                id = tonumber(data.id) or uid,
                                name = tostring(data.name or query),
                                displayName = tostring(data.displayName or data.name or query),
                                hasVerifiedBadge = data.hasVerifiedBadge == true
                            })
                        end
                    end
                end

                --Leaked By Xlu0 AndPrime--
                local encoded = HttpService:UrlEncode(query)
                local okSearch, body = pcall(function()
                    return game:HttpGet(
                        "https://users.roblox.com/v1/users/search?keyword=" ..
                        encoded .. "&limit=20"
                    )
                end)

                if myToken ~= searchToken then return end

                if okSearch and body and body ~= "" then
                    local okJson, data = pcall(function()
                        return HttpService:JSONDecode(body)
                    end)
                    if okJson and type(data) == "table" and type(data.data) == "table" then
                        local seen = {}
                        for _, r in ipairs(results) do seen[r.id] = true end

                        for _, item in ipairs(data.data) do
                            local id = tonumber(item.id)
                            if id and not seen[id] then
                                seen[id] = true
                                table.insert(results, {
                                    id = id,
                                    name = tostring(item.name or id),
                                    displayName = tostring(item.displayName or item.name or id),
                                    hasVerifiedBadge = item.hasVerifiedBadge == true
                                })
                            end
                        end
                    end
                end

                if myToken ~= searchToken then return end
                searchResults = results
                renderSearch()
            end)
        end

        input:GetPropertyChangedSignal("Text"):Connect(function()
            local current = input.Text
            task.delay(0.18, function()
                if input.Text == current then
                    searchAnyUser(current)
                end
            end)
        end)

        close.MouseButton1Click:Connect(function()
            sg:Destroy()
        end)

        --Leaked By Xlu0 AndPrime--
        task.spawn(function()
            local pending = #famousSeeds
            local seen = {}

            if pending == 0 then
                status.Text = "NO FEATURED USERS"
                return
            end

            for _, seedName in ipairs(famousSeeds) do
                task.spawn(function()
                    local okId, uid = pcall(function()
                        return Players:GetUserIdFromNameAsync(seedName)
                    end)

                    if okId and uid and uid > 0 and not seen[uid] then
                        seen[uid] = true

                        local okInfo, body = pcall(function()
                            return game:HttpGet("https://users.roblox.com/v1/users/" .. tostring(uid))
                        end)

                        if okInfo and body and body ~= "" then
                            local okJson, data = pcall(function()
                                return HttpService:JSONDecode(body)
                            end)

                            if okJson and type(data) == "table" then
                                --Leaked By Xlu0 AndPrime--
                                table.insert(featuredUsers, {
                                    id = tonumber(data.id) or uid,
                                    name = tostring(data.name or seedName),
                                    displayName = tostring(data.displayName or data.name or seedName),
                                    hasVerifiedBadge = data.hasVerifiedBadge == true
                                })

                                table.sort(featuredUsers, function(a,b)
                                    return string.lower(a.displayName or a.name)
                                        < string.lower(b.displayName or b.name)
                                end)

                                if input.Text == "" and sg.Parent then
                                    renderFeatured()
                                end
                            end
                        end
                    end

                    pending -= 1
                    if pending <= 0 and input.Text == "" and sg.Parent then
                        renderFeatured()
                    end
                end)
            end
        end)
    end

    LP.CharacterAdded:Connect(function()
        task.wait(0.35)
        if XAC.lastUserId then
            local uid, name = XAC.lastUserId, XAC.lastUsername
            task.defer(function()
                spawnAvatar(uid,name or tostring(uid),function() end)
            end)
        end
    end)

    --Leaked By Xlu0 AndPrime--
    task.defer(function()
        task.wait(0.5)
        if XAC.lastUserId and LP.Character then
            spawnAvatar(XAC.lastUserId, XAC.lastUsername or tostring(XAC.lastUserId), function() end)
        end
    end)
end

_G.AdaptInstallAvatarChanger()
_G.AdaptInstallAvatarChanger = nil

--Leaked By Xlu0 AndPrime--
if _G.AdaptAvatarChangerState then
    _G.AdaptAvatarChangerState.lastUserId = _G.AdaptSavedAvatarChangerUserId
    _G.AdaptAvatarChangerState.lastUsername = (_G.AdaptSavedAvatarChangerUsername ~= "" and _G.AdaptSavedAvatarChangerUsername) or nil
end

--Leaked By Xlu0 AndPrime--
do
    local originalApplyHeadless = _G.AdaptApplyHeadless
    local originalApplyKorblox = _G.AdaptApplyKorblox
    local originalApplyCharacterVisuals = _G.AdaptApplyCharacterVisuals

    if originalApplyHeadless then
        _G.AdaptApplyHeadless = function(char, enabled)
            originalApplyHeadless(char, enabled)

            local state = _G.AdaptAvatarChangerState
            local overlay = state and state.model
            if overlay and overlay.Parent and overlay ~= char then
                pcall(function()
                    originalApplyHeadless(overlay, enabled)
                end)
            end
        end
    end

    if originalApplyKorblox then
        _G.AdaptApplyKorblox = function(char, enabled)
            originalApplyKorblox(char, enabled)

            local state = _G.AdaptAvatarChangerState
            local overlay = state and state.model
            if overlay and overlay.Parent and overlay ~= char then
                pcall(function()
                    originalApplyKorblox(overlay, enabled)
                end)
            end
        end
    end

    if originalApplyCharacterVisuals then
        _G.AdaptApplyCharacterVisuals = function(char)
            originalApplyCharacterVisuals(char)

            local state = _G.AdaptAvatarChangerState
            local overlay = state and state.model
            if overlay and overlay.Parent and overlay ~= char then
                pcall(function()
                    if originalApplyHeadless then
                        originalApplyHeadless(overlay, _G.AdaptHeadlessEnabled == true)
                    end
                    if originalApplyKorblox then
                        originalApplyKorblox(overlay, _G.AdaptKorbloxEnabled == true)
                    end
                end)
            end
        end
    end
end


function __AdaptDuelsSetupVisualsUI()
local Utility = pages.VISUALS
local skyThemes = SKY_PRESETS_LIST or {"Off", "Night", "Aurora", "Sunset", "Galaxy", "Tech", "Sakura"}
local skyIndex = 1
for i, name in ipairs(skyThemes) do if name == skyTheme then skyIndex = i break end end
function skyThemeSelectorRow(parent, order)
local row = Instance.new("Frame")
row.Name = "Sky Theme"
row.ZIndex = 4
row.Size = UDim2.new(1,-4,0,52)
row.BackgroundTransparency = 1
row.BorderSizePixel = 0
row.LayoutOrder = order
row.Parent = parent

local label = Instance.new("TextLabel")
label.Name = "Label"
label.ZIndex = 5
label.Position = UDim2.new(0,2,0,0)
label.Size = UDim2.new(1,0,0,16)
label.BackgroundTransparency = 1
label.Text = "Sky Theme"
label.TextColor3 = Color3.fromRGB(255,255,255)
label.TextSize = 12
label.Font = Enum.Font.GothamBlack
label.TextXAlignment = Enum.TextXAlignment.Left
label.Parent = row

local left = Instance.new("TextButton")
left.Name = "SkyLeft"
left.ZIndex = 6
left.Position = UDim2.new(0,0,0,22)
left.Size = UDim2.new(0,44,0,25)
left.BackgroundColor3 = Color3.fromRGB(8,8,12)
left.BackgroundTransparency = 0.18
left.BorderSizePixel = 0
left.Text = "<"
left.TextColor3 = Color3.fromRGB(255,255,255)
left.TextSize = 12
left.Font = Enum.Font.GothamMedium
left.AutoButtonColor = false
left.Parent = row
corner(left,7)
stroke(left,COLORS.strokeSoft,1,0.45)

local value = Instance.new("TextButton")
value.Name = "SkyValue"
value.ZIndex = 6
value.Position = UDim2.new(0,48,0,22)
value.Size = UDim2.new(1,-96,0,28)
value.BackgroundColor3 = Color3.fromRGB(8,8,12)
value.BackgroundTransparency = 0.18
value.BorderSizePixel = 0
value.Text = skyThemes[skyIndex]
value.TextColor3 = Color3.fromRGB(255,255,255)
value.TextSize = 12
value.Font = Enum.Font.GothamMedium
value.AutoButtonColor = false
value.Parent = row
corner(value,7)
stroke(value,COLORS.strokeSoft,1,0.45)
skyValueLabel = value

local right = Instance.new("TextButton")
right.Name = "SkyRight"
right.ZIndex = 6
right.Position = UDim2.new(1,-44,0,22)
right.Size = UDim2.new(0,44,0,25)
right.BackgroundColor3 = Color3.fromRGB(8,8,12)
right.BackgroundTransparency = 0.18
right.BorderSizePixel = 0
right.Text = ">"
right.TextColor3 = Color3.fromRGB(255,255,255)
right.TextSize = 12
right.Font = Enum.Font.GothamMedium
right.AutoButtonColor = false
right.Parent = row
corner(right,7)
stroke(right,COLORS.strokeSoft,1,0.45)

local function setSkyIndex(nextIndex)
if nextIndex < 1 then nextIndex = #skyThemes end
if nextIndex > #skyThemes then nextIndex = 1 end
skyIndex = nextIndex
skyTheme = skyThemes[skyIndex]
if applyCustomSky then applyCustomSky(skyTheme) end
if skyValueLabel then skyValueLabel.Text = skyTheme end
end

left.Activated:Connect(function() setSkyIndex(skyIndex - 1) end)
right.Activated:Connect(function() setSkyIndex(skyIndex + 1) end)
return row
end

section(Utility, "CHARACTER VISUALS", -3)

_, _G.AdaptHeadlessVisual = toggleRow(Utility, "Headless", _G.AdaptHeadlessEnabled, -2)
_G.AdaptHeadlessRow = Utility:FindFirstChild("Headless")
_G.AdaptHeadlessButton = _G.AdaptHeadlessRow and _G.AdaptHeadlessRow:FindFirstChild("ToggleButton")
if _G.AdaptHeadlessButton then
_G.AdaptHeadlessButton.Activated:Connect(function()
_G.AdaptHeadlessEnabled = not _G.AdaptHeadlessEnabled
_G.AdaptApplyHeadless(LP.Character, _G.AdaptHeadlessEnabled)
if _G.AdaptHeadlessVisual then _G.AdaptHeadlessVisual(_G.AdaptHeadlessEnabled) end
do end
end)
end

_, _G.AdaptKorbloxVisual = toggleRow(Utility, "Korblox", _G.AdaptKorbloxEnabled, -1)
_G.AdaptKorbloxRow = Utility:FindFirstChild("Korblox")
_G.AdaptKorbloxButton = _G.AdaptKorbloxRow and _G.AdaptKorbloxRow:FindFirstChild("ToggleButton")
if _G.AdaptKorbloxButton then
_G.AdaptKorbloxButton.Activated:Connect(function()
_G.AdaptKorbloxEnabled = not _G.AdaptKorbloxEnabled
_G.AdaptApplyKorblox(LP.Character, _G.AdaptKorbloxEnabled)
if _G.AdaptKorbloxVisual then _G.AdaptKorbloxVisual(_G.AdaptKorbloxEnabled) end
do end
end)
end

task.defer(function()
task.wait(0.8)
_G.AdaptApplyCharacterVisuals(LP.Character)
if _G.AdaptHeadlessVisual then _G.AdaptHeadlessVisual(_G.AdaptHeadlessEnabled) end
if _G.AdaptKorbloxVisual then _G.AdaptKorbloxVisual(_G.AdaptKorbloxEnabled) end
end)


section(Utility, "ESP", 1)
do
local espRow, setESPVisual = toggleRow(Utility, "ESP", espEnabled, 2)
setPlayerESPVisual = setESPVisual
_aceBtn = espRow and espRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
espEnabled = not espEnabled
if espEnabled then
if startPlayerESP then startPlayerESP() end
if BoxedESPOptions then BoxedESPOptions.box = false end
else
if stopPlayerESP then stopPlayerESP() end
if BoxedESPOptions then BoxedESPOptions.box = false end
end
if refreshBoxedESP then refreshBoxedESP() end
if setESPVisual then setESPVisual(espEnabled) end
do end
end)
end
end
section(Utility, "SKY THEME", 5)
skyThemeSelectorRow(Utility, 6)

--Leaked By Xlu0 AndPrime--
animationPackRow(Utility, 7)

section(Utility, "PERFORMANCE", 8)
do
local row, setVisual = toggleRow(Utility, "Stretch Rez", fpsBoostEnabled, 8)
setFPSBoostVisual = setVisual
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
fpsBoostEnabled = not fpsBoostEnabled
if fpsBoostEnabled then enableStretchRez() else disableStretchRez() end
if setVisual then setVisual(fpsBoostEnabled) end
do end
end)
end
end

do
local row, setVisual = toggleRow(Utility, "Anti Lag", antiLagVisualEnabled, 10)
setAntiLagVisual = setVisual
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
if antiLagVisualEnabled then disableAntiLag() else enableAntiLag() end
if setVisual then setVisual(antiLagVisualEnabled) end
do end
end)
end
end
do
local row, setVisual = _G.AdaptActionToggleRow(Utility, "Nuke Optimiser", nukeOptimiserEnabled, 11)
setNukeOptimiserVisual = setVisual
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
if nukeOptimiserEnabled then disableNukeOptimizer() else enableNukeOptimizer() end
if setVisual then setVisual(nukeOptimiserEnabled) end
do end
end)
end
end
section(Utility, "CAMERA", 12)
do
local row, setVisual = toggleRow(Utility, "FOV", fovEnabled, 13)
setFOVVisual = setVisual
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
if fovEnabled then disableCustomFov() else enableCustomFov() end
if setVisual then setVisual(fovEnabled) end
do end
end)
end
end
do
local _, box = textboxRow(Utility, "FOV Value", tostring(fovValue), 14)
box.FocusLost:Connect(function()
local v = tonumber(box.Text)
if v and v >= 30 and v <= 120 then
fovValue = v
if fovEnabled and workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = fovValue end
end
box.Text = tostring(fovValue)
do end
end)
end
do
local row, setVisual = toggleRow(Utility, "No Cam Collision", noCamCollisionEnabled, 15)
setNoCamCollisionVisual = setVisual
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
if noCamCollisionEnabled then disableNoCamCollision() else enableNoCamCollision() end
if setVisual then setVisual(noCamCollisionEnabled) end
do end
end)
end
end
end
task.wait()
__AdaptDuelsSetupVisualsUI()

function _G.AdaptRestoreFonts()
    if _G.AdaptFontAddedConn then
        pcall(function() _G.AdaptFontAddedConn:Disconnect() end)
        _G.AdaptFontAddedConn = nil
    end
    if _G.AdaptFontBackup then
        for obj, oldFont in pairs(_G.AdaptFontBackup) do
            pcall(function()
                if obj and obj.Parent then obj.Font = oldFont end
            end)
        end
    end
    _G.AdaptFontBackup = {}
end

function _G.AdaptFontEnum(name)
    if name == "Coding Font" then return Enum.Font.GothamMedium end
    if name == "Summer" then return Enum.Font.GothamMedium end
    if name == "Beachy" then return Enum.Font.GothamMedium end
    if name == "Scary" then return Enum.Font.GothamMedium end
    if name == "Bangers" then return Enum.Font.GothamMedium end
    return nil
end

function _G.AdaptApplyFontToObject(obj)
    if not obj then return end
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end
    if not _G.AdaptFontBackup then _G.AdaptFontBackup = {} end
    if _G.AdaptFontBackup[obj] == nil then
        pcall(function() _G.AdaptFontBackup[obj] = obj.Font end)
    end
    local f = _G.AdaptFontEnum(_G.AdaptCustomFontSelected or "None")
    if f then pcall(function() obj.Font = f end) end
end

function _G.AdaptApplyCustomFont(name)
    _G.AdaptRestoreFonts()
    _G.AdaptCustomFontSelected = name or "None"
    customFontVisualEnabled = _G.AdaptCustomFontSelected ~= "None"

    if customFontVisualEnabled then
        for _, obj in ipairs(PlayerGui:GetDescendants()) do
            _G.AdaptApplyFontToObject(obj)
        end
        _G.AdaptFontAddedConn = PlayerGui.DescendantAdded:Connect(function(obj)
            if (_G.AdaptCustomFontSelected or "None") ~= "None" then
                _G.AdaptApplyFontToObject(obj)
            end
        end)
    end

    pcall(function()
        if saveAdaptConfig then saveAdaptConfig() end
    end)
end

function _G.AdaptInstallFontRow()
    local targetPage = MenuCustomize or pages.MENU
    if not targetPage or not targetPage.Parent then return end
    local old = targetPage:FindFirstChild("Custom Font")
    if old then old:Destroy() end

    local row = Instance.new("Frame")
    row.Name = "Custom Font"
    row.BackgroundColor3 = COLORS.row
    row.BackgroundTransparency = 0.22
    row.Size = UDim2.new(1, -4, 0, 138)
    row.BorderSizePixel = 0
    row.LayoutOrder = 2
    row.ZIndex = 4
    row.Parent = targetPage
    corner(row,10)
    stroke(row,COLORS.strokeSoft,1.15,0.32)

    local title = Instance.new("TextLabel")
    title.Name = "Label"
    title.BackgroundTransparency = 1
    title.Text = "Custom Font"
    title.TextColor3 = COLORS.white
    title.TextSize = 11
    title.Font = Enum.Font.GothamMedium
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Position = UDim2.new(0,12,0,7)
    title.Size = UDim2.new(1,-24,0,20)
    title.ZIndex = 5
    title.Parent = row

    local names = {"None","Coding Font","Summer","Beachy","Scary","Bangers"}

    local function getPreviewFont(name)
        if name == "Coding Font" then return Enum.Font.GothamMedium end
        if name == "Summer" then return Enum.Font.GothamMedium end
        if name == "Beachy" then return Enum.Font.GothamMedium end
        if name == "Scary" then return Enum.Font.GothamMedium end
        if name == "Bangers" then return Enum.Font.GothamMedium end
        return Enum.Font.GothamMedium
    end

    local buttons = {}

    local function refreshSelected()
        for name, btn in pairs(buttons) do
            local selected = name == (_G.AdaptCustomFontSelected or "None")
            btn.BackgroundTransparency = selected and 0.03 or 0.18
            local st = btn:FindFirstChildOfClass("UIStroke")
            if st then
                st.Transparency = selected and 0.05 or 0.5
                st.Thickness = selected and 1.4 or 1
            end
        end
    end

    for i, name in ipairs(names) do
        local col = (i - 1) % 3
        local rowIndex = math.floor((i - 1) / 3)

        local btn = Instance.new("TextButton")
        btn.Name = "Font_" .. name
        btn.BackgroundColor3 = Color3.fromRGB(10,10,14)
        btn.BackgroundTransparency = 0.18
        btn.BorderSizePixel = 0
        btn.Text = "Abc"
        btn.TextColor3 = COLORS.white
        btn.TextSize = 18
        btn.Font = getPreviewFont(name)
        btn.AutoButtonColor = false
        btn.Size = UDim2.new(0, 92, 0, 42)
        btn.Position = UDim2.new(0, 12 + col * 98, 0, 34 + rowIndex * 48)
        btn.ZIndex = 6
        btn.Parent = row
        corner(btn,8)
        stroke(btn,COLORS.strokeSoft,1,0.5)

        local nameLabel = Instance.new("TextLabel")
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = name
        nameLabel.TextColor3 = COLORS.white
        nameLabel.TextTransparency = 0.22
        nameLabel.TextSize = 8
        nameLabel.Font = Enum.Font.GothamMedium
        nameLabel.Size = UDim2.new(1,0,0,12)
        nameLabel.Position = UDim2.new(0,0,1,-13)
        nameLabel.ZIndex = 7
        nameLabel.Parent = btn

        buttons[name] = btn

        btn.MouseButton1Click:Connect(function()
            pcall(function()
                _G.AdaptApplyCustomFont(name)
            end)
            refreshSelected()
        end)
    end

    refreshSelected()
end

Settings = pages.SETTINGS
--Leaked By Xlu0 AndPrime--
aceGuiScaleValue = AdaptAutoMobile and 0.67 or 1.00
aceGuiScaleValue = math.clamp(aceGuiScaleValue, 0.50, 1.50)
_G.AdaptGuiScaleValue = aceGuiScaleValue
aceProgressBarScaleValue = AdaptAutoMobile and 0.83 or 1.00
aceMainScale = Main:FindFirstChild("AdaptMainScale") or Instance.new("UIScale")
aceMainScale.Name = "AdaptMainScale"
aceMainScale.Scale = aceGuiScaleValue
aceMainScale.Parent = Main
local function applyAdaptProgressBarScale()
local sg = PlayerGui:FindFirstChild("StealBarGui")
local bar = sg and sg:FindFirstChild("StealBar")
if not bar then return end
local sc = bar:FindFirstChild("AdaptProgressBarScale") or Instance.new("UIScale")
sc.Name = "AdaptProgressBarScale"
sc.Scale = aceProgressBarScaleValue
sc.Parent = bar
end
_G.__AdaptDuelsSetupSettingsUI = function()
section(MenuCustomize, "MENU CUSTOMIZE", 1)
local bgRow = Instance.new("Frame")
bgRow.Name = "Background Image Picker"
bgRow.BackgroundColor3 = Color3.fromRGB(0,0,0)
bgRow.BackgroundTransparency = 0.3
bgRow.Size = UDim2.new(1,-4,0,52)
bgRow.BorderSizePixel = 0
bgRow.LayoutOrder = 2
bgRow.ZIndex = 4
bgRow.Parent = MenuCustomize
corner(bgRow,11)
stroke(bgRow,Color3.fromRGB(255,255,255),1.25,0.45)

local bgScroll = Instance.new("ScrollingFrame")
bgScroll.Name = "BgScroll"
bgScroll.ZIndex = 5
bgScroll.Size = UDim2.new(1,-56,1,0)
bgScroll.Position = UDim2.new(0.5,0,0,0)
bgScroll.AnchorPoint = Vector2.new(0.5,0)
bgScroll.BackgroundTransparency = 1
bgScroll.BorderSizePixel = 0
bgScroll.ScrollBarThickness = 0
bgScroll.ScrollBarImageTransparency = 1
bgScroll.ScrollingDirection = Enum.ScrollingDirection.X
bgScroll.CanvasSize = UDim2.new(0,0,0,0)
bgScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
bgScroll.Parent = bgRow

local bgList = Instance.new("UIListLayout")
bgList.FillDirection = Enum.FillDirection.Horizontal
bgList.Padding = UDim.new(0,4)
bgList.SortOrder = Enum.SortOrder.LayoutOrder
bgList.VerticalAlignment = Enum.VerticalAlignment.Center
bgList.Parent = bgScroll

local bgPadding = Instance.new("UIPadding")
bgPadding.PaddingLeft = UDim.new(0,4)
bgPadding.PaddingRight = UDim.new(0,4)
bgPadding.Parent = bgScroll

local bgButtons = {}

function updateBackgroundButtons()
for index,button in pairs(bgButtons) do
    local selected = index == currentBackground
    local st = button:FindFirstChildOfClass("UIStroke")
    if st then
        st.Color = selected and Color3.fromRGB(255,255,255) or Color3.fromRGB(80,80,90)
        st.Transparency = selected and 0 or 0.4
        st.Thickness = selected and 1.25 or 1
    end
    if button:IsA("ImageButton") then
        button.ImageTransparency = selected and 0 or 0.22
    end
end
end

function makeNoneButton(index, x, y)
local btn = Instance.new("ImageButton")
btn.Name = "BgThumbNone"
btn.ZIndex = 5
btn.LayoutOrder = 1
btn.Size = UDim2.new(0,42,0,34)
btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
btn.BorderSizePixel = 0
btn.Image = ""
btn.ImageTransparency = 0.22
btn.AutoButtonColor = false
btn.Parent = bgScroll
corner(btn,9)
stroke(btn,Color3.fromRGB(80,80,90),1,0.4)

local noneLabel = Instance.new("TextLabel")
noneLabel.Name = "NoneLabel"
noneLabel.ZIndex = 6
noneLabel.Size = UDim2.new(1,0,1,0)
noneLabel.BackgroundTransparency = 1
noneLabel.Text = "NONE"
noneLabel.TextColor3 = COLORS.white
noneLabel.TextSize = 9
noneLabel.Font = Enum.Font.GothamMedium
noneLabel.Parent = btn

bgButtons[index] = btn
btn.MouseButton1Click:Connect(function()
    applyBackground(index)
    updateBackgroundButtons()
end)
end

function makeImageButton(index, x, y)
local thumb = Instance.new("ImageButton")
thumb.Name = "BgThumb" .. tostring(index)
thumb.ZIndex = 5
thumb.LayoutOrder = index + 1
thumb.Size = UDim2.new(0,42,0,34)
thumb.BackgroundColor3 = Color3.fromRGB(0,0,0)
thumb.BorderSizePixel = 0
thumb.Image = "rbxassetid://" .. tostring(BackgroundIDs[index])
thumb.ImageTransparency = 0.22
thumb.ScaleType = Enum.ScaleType.Crop
thumb.AutoButtonColor = false
thumb.Parent = bgScroll
corner(thumb,9)
stroke(thumb,Color3.fromRGB(80,80,90),1,0.4)

bgButtons[index] = thumb
thumb.MouseButton1Click:Connect(function()
    applyBackground(index)
    updateBackgroundButtons()
end)
end

local bgLeft = Instance.new("TextButton")
bgLeft.Name = "BgArrowLeft"
bgLeft.ZIndex = 8
bgLeft.Position = UDim2.new(0,3,0.5,-17)
bgLeft.Size = UDim2.new(0,22,0,34)
bgLeft.BackgroundColor3 = Color3.fromRGB(18,18,23)
bgLeft.BackgroundTransparency = 0.05
bgLeft.BorderSizePixel = 0
bgLeft.Text = "<"
bgLeft.TextColor3 = COLORS.white
bgLeft.TextSize = 18
bgLeft.Font = Enum.Font.GothamMedium
bgLeft.AutoButtonColor = false
bgLeft.Parent = bgRow
corner(bgLeft,7)

local bgRight = Instance.new("TextButton")
bgRight.Name = "BgArrowRight"
bgRight.ZIndex = 8
bgRight.Position = UDim2.new(1,-25,0.5,-17)
bgRight.Size = UDim2.new(0,22,0,34)
bgRight.BackgroundColor3 = Color3.fromRGB(18,18,23)
bgRight.BackgroundTransparency = 0.05
bgRight.BorderSizePixel = 0
bgRight.Text = ">"
bgRight.TextColor3 = COLORS.white
bgRight.TextSize = 18
bgRight.Font = Enum.Font.GothamMedium
bgRight.AutoButtonColor = false
bgRight.Parent = bgRow
corner(bgRight,7)

bgLeft.MouseButton1Click:Connect(function()
    local pos = bgScroll.CanvasPosition
    TweenService:Create(bgScroll,TweenInfo.new(0.2),{
        CanvasPosition = Vector2.new(math.max(0,pos.X-50),0)
    }):Play()
end)

bgRight.MouseButton1Click:Connect(function()
    local pos = bgScroll.CanvasPosition
    TweenService:Create(bgScroll,TweenInfo.new(0.2),{
        CanvasPosition = Vector2.new(pos.X+50,0)
    }):Play()
end)

function stepperRow(parent, labelText, defaultValue, order, callback, minValue, maxValue)
local row = Instance.new("Frame")
row.Name = labelText
row.BackgroundColor3 = COLORS.row
row.BackgroundTransparency = 0.22
row.Size = UDim2.new(1, -4, 0, 42)
row.BorderSizePixel = 0
row.LayoutOrder = order
row.ZIndex = 4
row.Parent = parent
corner(row, 10)
stroke(row, COLORS.strokeSoft, 1.15, 0.32)
local label = Instance.new("TextLabel")
label.Name = "Label"
label.BackgroundTransparency = 1
label.Text = labelText
label.TextColor3 = Color3.fromRGB(245, 245, 255)
label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
label.TextStrokeTransparency = 1
label.TextSize = 11
label.Font = Enum.Font.GothamMedium
label.TextXAlignment = Enum.TextXAlignment.Left
label.Position = UDim2.new(0, 12, 0, 0)
label.Size = UDim2.new(1, -155, 1, 0)
label.ZIndex = 5
label.Parent = row
local value = defaultValue
local minus = Instance.new("TextButton")
minus.Name = "Minus"
minus.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
minus.BackgroundTransparency = 0.1
minus.BorderSizePixel = 0
minus.Text = "-"
minus.TextColor3 = Color3.fromRGB(245, 245, 255)
minus.TextSize = 14
minus.Font = Enum.Font.GothamMedium
minus.AutoButtonColor = false
minus.Size = UDim2.new(0, 28, 0, 26)
minus.Position = UDim2.new(1, -118, 0.5, -13)
minus.ZIndex = 6
minus.Parent = row
corner(minus, 7)
stroke(minus, COLORS.strokeSoft, 1, 0.5)
local valueBox = Instance.new("TextLabel")
valueBox.Name = "Value"
valueBox.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
valueBox.BackgroundTransparency = 0.05
valueBox.BorderSizePixel = 0
valueBox.Text = string.format("%.2f", value)
valueBox.TextColor3 = Color3.fromRGB(245, 245, 255)
valueBox.TextSize = 13
valueBox.Font = Enum.Font.GothamMedium
valueBox.TextXAlignment = Enum.TextXAlignment.Center
valueBox.Size = UDim2.new(0, 48, 0, 26)
valueBox.Position = UDim2.new(1, -84, 0.5, -13)
valueBox.ZIndex = 6
valueBox.Parent = row
corner(valueBox, 7)
stroke(valueBox, COLORS.strokeSoft, 1, 0.5)
local plus = Instance.new("TextButton")
plus.Name = "Plus"
plus.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
plus.BackgroundTransparency = 0.1
plus.BorderSizePixel = 0
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(245, 245, 255)
plus.TextSize = 14
plus.Font = Enum.Font.GothamMedium
plus.AutoButtonColor = false
plus.Size = UDim2.new(0, 28, 0, 26)
plus.Position = UDim2.new(1, -30, 0.5, -13)
plus.ZIndex = 6
plus.Parent = row
corner(plus, 7)
stroke(plus, COLORS.strokeSoft, 1, 0.5)
local function setValue(nextValue)
value = math.clamp(math.floor((nextValue * 100) + 0.5) / 100, minValue or 0.50, maxValue or 1.50)
valueBox.Text = string.format("%.2f", value)
if callback then callback(value) end
end
minus.MouseButton1Click:Connect(function()
setValue(value - 0.05)
end)
plus.MouseButton1Click:Connect(function()
setValue(value + 0.05)
end)
return row
end
makeNoneButton(0, 8, 8)
for index = 1, #BackgroundIDs do
local slot = index
local column = slot % 5
local rowIndex = math.floor(slot / 5)
makeImageButton(index, 8 + (column * 61), 8 + (rowIndex * 48))
end
updateBackgroundButtons()

--Leaked By Xlu0 AndPrime--
do
local colorRow = Instance.new("Frame")
colorRow.Name = "ColorThemePicker"
colorRow.BackgroundColor3 = COLORS.row
colorRow.BackgroundTransparency = 0.3
colorRow.BorderSizePixel = 0
colorRow.Size = UDim2.new(1, -4, 0, 34)
colorRow.LayoutOrder = 3
colorRow.ZIndex = 4
colorRow.Parent = MenuCustomize
corner(colorRow, 9)
stroke(colorRow, COLORS.strokeSoft, 1.15, 0.38)

local colorOrder = {"PURPLE","BLUE","RED","PINK","YELLOW","GREY","WHITE","FOREST"}
local activeButton

local function applyThemeColor()
local tint = _G.AdaptThemeColors[_G.AdaptThemeName] or _G.AdaptThemeColors.WHITE

--Leaked By Xlu0 AndPrime--
BgImage.ImageColor3 = tint
if AdaptLogoAsset then
AdaptLogoAsset.ImageColor3 = tint
end
if TitleSweepText then TitleSweepText.TextColor3 = tint end
if _G.AdaptIntroTitleSweep and _G.AdaptIntroTitleSweep.Parent then
_G.AdaptIntroTitleSweep.TextColor3 = tint
end

THEME_ACCENT = tint
THEME_ACCENT_DIM = Color3.new(tint.R * 0.62, tint.G * 0.62, tint.B * 0.62)

if PlayerESP and PlayerESP.playerData then
for _, data in pairs(PlayerESP.playerData) do
if data.highlight then
data.highlight.FillColor = tint
data.highlight.OutlineColor = tint
end
if data.billboard then
for _, obj in ipairs(data.billboard:GetDescendants()) do
if obj:IsA("TextLabel") then
obj.TextColor3 = tint
end
end
end
end
end

if BoxedESPData then
for _, data in pairs(BoxedESPData) do
if data.box then data.box.Color = tint end
if data.tracer then data.tracer.Color = tint end
end
end

if _G.AdaptApplyMobileButtonImage then
pcall(_G.AdaptApplyMobileButtonImage)
end

if _G.AdaptApplyStealUIImage then
pcall(_G.AdaptApplyStealUIImage)
end

do end
end

for i, colorName in ipairs(colorOrder) do
local btn = Instance.new("TextButton")
btn.Name = colorName
btn.Size = UDim2.new(0, 30, 0, 14)
btn.Position = UDim2.new(0, 8 + ((i - 1) * 36), 0.5, -7)
btn.BackgroundColor3 = _G.AdaptThemeColors[colorName]
btn.BorderSizePixel = 0
btn.Text = ""
btn.AutoButtonColor = false
btn.ZIndex = 6
btn.Parent = colorRow
corner(btn, 4)

local border = stroke(btn, COLORS.white, 1, 0.5)
if colorName == _G.AdaptThemeName then
activeButton = btn
border.Transparency = 0
border.Thickness = 2
end

btn.MouseButton1Click:Connect(function()
if activeButton then
local oldBorder = activeButton:FindFirstChildOfClass("UIStroke")
if oldBorder then
oldBorder.Transparency = 0.5
oldBorder.Thickness = 1
end
end

activeButton = btn
_G.AdaptThemeName = colorName

local newBorder = btn:FindFirstChildOfClass("UIStroke")
if newBorder then
newBorder.Transparency = 0
newBorder.Thickness = 2
end

applyThemeColor()
if _G.AdaptApplyMobileButtonImage then pcall(_G.AdaptApplyMobileButtonImage) end
end)
end
end

stepperRow(Settings, "GUI Scale", aceGuiScaleValue, 6, function(v)
aceGuiScaleValue = v
aceMainScale.Scale = v
do end
end)
section(MenuCustomize, "STEAL UI", 20)
stepperRow(MenuCustomize, "Progress Bar Size", aceProgressBarScaleValue, 7, function(v)
aceProgressBarScaleValue = v
applyAdaptProgressBarScale()
do end
end)
speedKeybindRow(Settings, "Toggle UI", "ToggleUI", 8)
section(Settings, "MOBILE BUTTONS", 4)
do
local row, setVisual = _G.AdaptActionToggleRow(Settings, "Lock GUI", _G.AdaptGuiLocked == true, 9)
setLockGuiVisual = setVisual
local btn = row and row:FindFirstChild("ToggleButton")
if btn then
btn.Activated:Connect(function()
_G.AdaptGuiLocked = not (_G.AdaptGuiLocked == true)
if setVisual then setVisual(_G.AdaptGuiLocked == true) end
if AdaptUpdateGuiLockVisual then AdaptUpdateGuiLockVisual() end
do end
end)
end
end
do
local row, setVisual = _G.AdaptActionToggleRow(Settings, "Hide Mobile Buttons", _G.AdaptHideMobileButtons == true, 10)
setHideMobileButtonsVisual = setVisual
local btn = row and row:FindFirstChild("ToggleButton")
if btn then
btn.Activated:Connect(function()
_G.AdaptHideMobileButtons = not (_G.AdaptHideMobileButtons == true)
if setVisual then setVisual(_G.AdaptHideMobileButtons == true) end
if _G.AdaptApplyMobileButtonsHidden then _G.AdaptApplyMobileButtonsHidden() end
do end
end)
end
end
stepperRow(Settings, "Mobile Buttons Size", tonumber(_G.AdaptMobileButtonScale) or 1.00, 11, function(v)
_G.AdaptMobileButtonScale = math.clamp(tonumber(v) or 0.35, 0.30, 1.35)
if _G.AdaptApplyMobileButtonSize then _G.AdaptApplyMobileButtonSize() end
do end
end, 0.30, 1.35)
do
local row = baseRow(Settings, "Mobile Button Shape", 12)
local shapeButton = Instance.new("TextButton")
shapeButton.Name = "MobileButtonShapeSelector"
shapeButton.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
shapeButton.BackgroundTransparency = 0.05
shapeButton.BorderSizePixel = 0
shapeButton.TextColor3 = Color3.fromRGB(245, 245, 255)
shapeButton.TextSize = 10
shapeButton.Font = Enum.Font.GothamMedium
shapeButton.AutoButtonColor = false
shapeButton.Size = UDim2.new(0, 112, 0, 27)
shapeButton.Position = UDim2.new(1, -122, 0.5, -13)
shapeButton.ZIndex = 7
shapeButton.Parent = row
corner(shapeButton, 7)
stroke(shapeButton, COLORS.strokeSoft, 1, 0.45)
local shapeOrder = {"CIRCLE", "ROUNDED", "SQUARE"}
local shapeDisplay = {CIRCLE = "CIRCLE", ROUNDED = "ROUNDED", SQUARE = "SQUARE"}
local function refreshShapeText()
shapeButton.Text = shapeDisplay[_G.AdaptMobileButtonShape] or "ROUNDED"
end
shapeButton.MouseButton1Click:Connect(function()
local currentIndex = 1
for i, shape in ipairs(shapeOrder) do
if shape == _G.AdaptMobileButtonShape then currentIndex = i break end
end
currentIndex = (currentIndex % #shapeOrder) + 1
_G.AdaptMobileButtonShape = shapeOrder[currentIndex]
refreshShapeText()
if _G.AdaptApplyMobileButtonShape then _G.AdaptApplyMobileButtonShape() end
do end
end)
refreshShapeText()
end
do
function createHorizontalImagePicker(parent, name, layoutOrder, selectedGetter, selectedSetter, assetIds)
assetIds = assetIds or BackgroundIDs

local pickerRow = Instance.new("Frame")
pickerRow.Name = name
pickerRow.ZIndex = 4
pickerRow.Size = UDim2.new(1,-4,0,52)
pickerRow.BackgroundColor3 = Color3.fromRGB(0,0,0)
pickerRow.BackgroundTransparency = 0.3
pickerRow.BorderSizePixel = 0
pickerRow.LayoutOrder = layoutOrder
pickerRow.Parent = parent
corner(pickerRow,11)
stroke(pickerRow,Color3.fromRGB(255,255,255),1.25,0.45)

local scroll = Instance.new("ScrollingFrame")
scroll.Name = "PickerScroll"
scroll.ZIndex = 5
scroll.Size = UDim2.new(1,-56,1,0)
scroll.Position = UDim2.new(0.5,0,0,0)
scroll.AnchorPoint = Vector2.new(0.5,0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 0
scroll.ScrollBarImageTransparency = 1
scroll.ScrollingDirection = Enum.ScrollingDirection.X
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.X
scroll.Parent = pickerRow

local list = Instance.new("UIListLayout")
list.FillDirection = Enum.FillDirection.Horizontal
list.Padding = UDim.new(0,4)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.VerticalAlignment = Enum.VerticalAlignment.Center
list.Parent = scroll

local pad = Instance.new("UIPadding")
pad.PaddingLeft = UDim.new(0,4)
pad.PaddingRight = UDim.new(0,4)
pad.Parent = scroll

local buttons = {}

local function selectedIndex()
    local current = tostring(selectedGetter() or "")
    local id = current:match("(%d+)")
    if not id then return 0 end
    for i,assetId in ipairs(assetIds) do
        if tostring(assetId) == tostring(id) then return i end
    end
    return 0
end

local function updateButtons()
    local selected = selectedIndex()
    for index,thumb in pairs(buttons) do
        local on = index == selected
        local st = thumb:FindFirstChildOfClass("UIStroke")
        if st then
            st.Color = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(80,80,90)
            st.Transparency = on and 0 or 0.4
            st.Thickness = on and 1.25 or 1
        end
        thumb.ImageTransparency = on and 0 or 0.22
    end
end

local function choose(index)
    selectedSetter(index == 0 and "" or ("rbxassetid://" .. tostring(assetIds[index])))
    updateButtons()
end

local function makeThumb(index,assetId)
    local thumb = Instance.new("ImageButton")
    thumb.Name = "Thumb" .. tostring(index)
    thumb.ZIndex = 5
    thumb.LayoutOrder = index + 1
    thumb.Size = UDim2.new(0,42,0,34)
    thumb.BackgroundColor3 = Color3.fromRGB(0,0,0)
    thumb.BorderSizePixel = 0
    thumb.Image = assetId and ("rbxassetid://" .. tostring(assetId)) or ""
    thumb.ImageTransparency = 0.22
    thumb.ScaleType = Enum.ScaleType.Crop
    thumb.AutoButtonColor = false
    thumb.Parent = scroll
    corner(thumb,9)
    stroke(thumb,Color3.fromRGB(80,80,90),1,0.4)

    if index == 0 then
        local none = Instance.new("TextLabel")
        none.Name = "NoneLabel"
        none.ZIndex = 6
        none.Size = UDim2.new(1,0,1,0)
        none.BackgroundTransparency = 1
        none.Text = "NONE"
        none.TextColor3 = COLORS.white
        none.TextSize = 9
        none.Font = Enum.Font.GothamMedium
        none.Parent = thumb
    end

    buttons[index] = thumb
    thumb.MouseButton1Click:Connect(function() choose(index) end)
end

makeThumb(0,nil)
for i,id in ipairs(assetIds) do
    makeThumb(i,id)
end

local left = Instance.new("TextButton")
left.ZIndex = 8
left.Position = UDim2.new(0,3,0.5,-17)
left.Size = UDim2.new(0,22,0,34)
left.BackgroundColor3 = Color3.fromRGB(18,18,23)
left.BackgroundTransparency = 0.05
left.BorderSizePixel = 0
left.Text = "<"
left.TextColor3 = COLORS.white
left.TextSize = 18
left.Font = Enum.Font.GothamMedium
left.AutoButtonColor = false
left.Parent = pickerRow
corner(left,7)

local right = Instance.new("TextButton")
right.ZIndex = 8
right.Position = UDim2.new(1,-25,0.5,-17)
right.Size = UDim2.new(0,22,0,34)
right.BackgroundColor3 = Color3.fromRGB(18,18,23)
right.BackgroundTransparency = 0.05
right.BorderSizePixel = 0
right.Text = ">"
right.TextColor3 = COLORS.white
right.TextSize = 18
right.Font = Enum.Font.GothamMedium
right.AutoButtonColor = false
right.Parent = pickerRow
corner(right,7)

left.MouseButton1Click:Connect(function()
    local pos = scroll.CanvasPosition
    TweenService:Create(scroll,TweenInfo.new(0.2),{
        CanvasPosition = Vector2.new(math.max(0,pos.X-50),0)
    }):Play()
end)

right.MouseButton1Click:Connect(function()
    local pos = scroll.CanvasPosition
    TweenService:Create(scroll,TweenInfo.new(0.2),{
        CanvasPosition = Vector2.new(pos.X+50,0)
    }):Play()
end)

updateButtons()
return pickerRow
end

section(Settings, "STEAL UI BACKGROUND IMAGE", 48)
createHorizontalImagePicker(MenuCustomize, "Steal UI Image", 49,
function()
return _G.AdaptStealUIImage
end,
function(value)
_G.AdaptStealUIImage = value
if _G.AdaptApplyStealUIImage then
_G.AdaptApplyStealUIImage()
end
do end
end)

do
local mobilePickerGap = Instance.new("Frame")
mobilePickerGap.Name = "MobilePickerGap"
mobilePickerGap.BackgroundTransparency = 1
mobilePickerGap.BorderSizePixel = 0
mobilePickerGap.Size = UDim2.new(1, 0, 0, 7)
mobilePickerGap.LayoutOrder = 13
mobilePickerGap.Parent = MenuCustomize
end

createHorizontalImagePicker(MenuCustomize, "Mobile Button Image Picker", 14,
function() return _G.AdaptMobileButtonImage end,
function(value)
_G.AdaptMobileButtonImage = value
if _G.AdaptApplyMobileButtonImage then _G.AdaptApplyMobileButtonImage() end
end,
ButtonImageIDs)

end

do
local row = baseRow(Settings, "Reset Mobile Buttons", 15)
local button = Instance.new("TextButton")
button.Name = "ResetMobileButtons"
button.BackgroundColor3 = Color3.fromRGB(232, 232, 238)
button.BackgroundTransparency = 0
button.BorderSizePixel = 0
button.Text = "RESET"
button.TextColor3 = Color3.fromRGB(0, 0, 0)
button.TextSize = 11
button.Font = Enum.Font.GothamMedium
button.AutoButtonColor = false
button.Size = UDim2.new(0, 78, 0, 26)
button.Position = UDim2.new(1, -88, 0.5, -13)
button.ZIndex = 7
button.Parent = row
corner(button, 8)
stroke(button, Color3.fromRGB(255, 255, 255), 1, 0.18)
button.Activated:Connect(function()
if _G.AdaptResetMobileButtons then
_G.AdaptResetMobileButtons()
else
_G.AdaptMobileButtonScale = AdaptAutoMobile and 0.90 or 1.00
_G.AdaptHideMobileButtons = false
if _G.AdaptApplyMobileButtonsHidden then _G.AdaptApplyMobileButtonsHidden() end
if _G.AdaptApplyMobileButtonSize then _G.AdaptApplyMobileButtonSize() end
do end
end
end)
end

section(Settings, "INTRO", 50)
do
local row, setVisual = toggleRow(Settings, "Intro", _introEnabled, 51)
setIntroVisual = setVisual
local btn = row and row:FindFirstChild("ToggleButton")
if btn then
btn.Activated:Connect(function()
_introEnabled = not _introEnabled
if not _introEnabled then stopIntroPlayback(); stopIntroPreview() end
if setIntroVisual then setIntroVisual(_introEnabled) end
do end
end)
end
if setIntroVisual then setIntroVisual(_introEnabled) end
end
do
local row = Instance.new("Frame")
row.Name = "Intro Song"
row.BackgroundColor3 = COLORS.row
row.BackgroundTransparency = 0.22
row.Size = UDim2.new(1, -4, 0, 42)
row.BorderSizePixel = 0
row.LayoutOrder = 52
row.ZIndex = 4
row.Parent = Settings
corner(row, 10)
stroke(row, COLORS.strokeSoft, 1.15, 0.32)

local label = Instance.new("TextLabel")
label.Name = "Label"
label.BackgroundTransparency = 1
label.Text = "Intro Song"
label.TextColor3 = Color3.fromRGB(245,245,255)
label.TextStrokeColor3 = Color3.fromRGB(0,0,0)
label.TextStrokeTransparency = 0.25
label.TextSize = 11
label.Font = Enum.Font.GothamMedium
label.TextXAlignment = Enum.TextXAlignment.Left
label.Position = UDim2.new(0, 12, 0, 0)
label.Size = UDim2.new(1, -145, 1, 0)
label.ZIndex = 5
label.Parent = row

local btn = Instance.new("TextButton")
btn.Name = "Intro Song Button"
btn.BackgroundColor3 = Color3.fromRGB(232,232,238)
btn.BackgroundTransparency = 0
btn.BorderSizePixel = 0
btn.Text = getIntroSongName()
btn.TextColor3 = Color3.fromRGB(0,0,0)
btn.TextSize = 12
btn.Font = Enum.Font.GothamBlack
btn.AutoButtonColor = false
btn.Size = UDim2.new(0, 118, 0, 28)
btn.Position = UDim2.new(1, -128, 0.5, -14)
btn.ZIndex = 6
btn.Parent = row
corner(btn, 8)
stroke(btn, Color3.fromRGB(255,255,255), 1, 0.15)

setIntroSongVisual = function()
    if btn and btn.Parent then
        btn.Text = getIntroSongName()
        btn.TextColor3 = Color3.fromRGB(0,0,0)
    end
end

btn.MouseButton1Click:Connect(function()
    selectedIntroMusic = (tonumber(selectedIntroMusic) or 1) + 1
    if selectedIntroMusic > #ADAPT_INTRO_MUSIC_OPTIONS then
        selectedIntroMusic = 1
    end

    if setIntroSongVisual then setIntroSongVisual() end
    previewIntroMusic(selectedIntroMusic)
    if saveAdaptConfig then pcall(saveAdaptConfig) end
end)
end

section(Settings, "SETTINGS", 999)
local resetHolder = Instance.new("Frame")
resetHolder.Name = "Reset All Settings Holder"
resetHolder.BackgroundTransparency = 1
resetHolder.BorderSizePixel = 0
resetHolder.Size = UDim2.new(1,-4,0,34)
resetHolder.LayoutOrder = 1000
resetHolder.ZIndex = 5
resetHolder.Parent = Settings
local resetBtn = Instance.new("TextButton")
resetBtn.Name = "Reset All Settings"
resetBtn.BackgroundColor3 = COLORS.row
resetBtn.BackgroundTransparency = 0.3
resetBtn.BorderSizePixel = 0
resetBtn.Text = "RESET ALL SETTINGS"
resetBtn.TextColor3 = COLORS.white
resetBtn.TextStrokeTransparency = 1
resetBtn.TextSize = 12
resetBtn.Font = Enum.Font.GothamMedium
resetBtn.AutoButtonColor = false
resetBtn.Size = UDim2.new(1,0,1,0)
resetBtn.Position = UDim2.new(0,0,0,0)
resetBtn.ZIndex = 6
resetBtn.Parent = resetHolder
corner(resetBtn,9)
local resetStroke = Instance.new("UIStroke")
resetStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
resetStroke.Color = Color3.fromRGB(255, 255, 255)
resetStroke.Thickness = 1
resetStroke.Transparency = 0.12
resetStroke.Parent = resetBtn
local resetDefaultBg = COLORS.row
local resetHoverBg = COLORS.row
local resetConfirmBg = COLORS.row
local resetDoneBg = COLORS.row
local resetDefaultText = COLORS.white
local resetConfirmText = COLORS.white
local resetDoneText = COLORS.white
local confirmState = false
local confirmTimer = nil
function setResetDefaultTheme()
confirmState = false
resetBtn.Text = "RESET ALL SETTINGS"
resetBtn.TextColor3 = resetDefaultText
tween(resetBtn, {BackgroundColor3 = resetDefaultBg}, 0.18)
tween(resetStroke, {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.12, Thickness = 1}, 0.18)
end
function setResetConfirmTheme()
resetBtn.Text = "CLICK AGAIN TO CONFIRM"
resetBtn.TextColor3 = resetConfirmText
tween(resetBtn, {BackgroundColor3 = resetConfirmBg}, 0.18)
tween(resetStroke, {Color = resetConfirmText, Transparency = 0.02, Thickness = 1.4}, 0.18)
end
function setResetDoneTheme()
resetBtn.Text = "DONE - REJOINING..."
resetBtn.TextColor3 = resetDoneText
tween(resetBtn, {BackgroundColor3 = resetDoneBg}, 0.18)
tween(resetStroke, {Color = resetDoneText, Transparency = 0.02, Thickness = 1.4}, 0.18)
end
resetBtn.Text = "RESET ALL SETTINGS"
resetBtn.MouseEnter:Connect(function()
if not confirmState then
tween(resetBtn, {BackgroundColor3 = resetHoverBg}, 0.12)
end
end)


--Leaked By Xlu0 AndPrime--
local saveHolder = Instance.new("Frame")
saveHolder.Name = "Save Config Holder"
saveHolder.BackgroundTransparency = 1
saveHolder.BorderSizePixel = 0
saveHolder.Size = UDim2.new(1,-4,0,34)
saveHolder.LayoutOrder = 1001
saveHolder.ZIndex = 5
saveHolder.Parent = Settings

local saveBtn = Instance.new("TextButton")
saveBtn.Name = "Save Config"
saveBtn.BackgroundColor3 = COLORS.row
saveBtn.BackgroundTransparency = 0.3
saveBtn.BorderSizePixel = 0
saveBtn.Text = "SAVE SETTINGS"
saveBtn.TextColor3 = resetDefaultText
saveBtn.TextStrokeTransparency = 1
saveBtn.TextSize = 12
saveBtn.Font = Enum.Font.GothamMedium
saveBtn.AutoButtonColor = false
saveBtn.Size = UDim2.new(1,0,1,0)
saveBtn.Position = UDim2.new(0,0,0,0)
saveBtn.ZIndex = 6
saveBtn.Parent = saveHolder
corner(saveBtn,9)

local saveStroke = Instance.new("UIStroke")
saveStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
saveStroke.Color = Color3.fromRGB(255, 255, 255)
saveStroke.Thickness = 1
saveStroke.Transparency = 0.12
saveStroke.Parent = saveBtn

saveBtn.MouseEnter:Connect(function()
tween(saveBtn, {BackgroundColor3 = COLORS.row}, 0.12)
end)

saveBtn.MouseLeave:Connect(function()
tween(saveBtn, {BackgroundColor3 = COLORS.row}, 0.12)
end)

saveBtn.MouseButton1Click:Connect(function()
if _G.AdaptManualSaveConfig then
local ok = pcall(_G.AdaptManualSaveConfig)
if ok then
saveBtn.Text = "SAVED"
saveBtn.TextColor3 = resetDoneText
tween(saveBtn, {BackgroundColor3 = resetDoneBg}, 0.18)
tween(saveStroke, {Color = resetDoneText, Transparency = 0.02, Thickness = 1.4}, 0.18)
task.delay(0.8, function()
if saveBtn and saveBtn.Parent then
saveBtn.Text = "SAVE SETTINGS"
saveBtn.TextColor3 = resetDefaultText
tween(saveBtn, {BackgroundColor3 = COLORS.row}, 0.18)
tween(saveStroke, {Color = Color3.fromRGB(255,255,255), Transparency = 0.12, Thickness = 1}, 0.18)
end
end)
else
saveBtn.Text = "SAVE FAILED"
task.delay(0.8, function()
if saveBtn and saveBtn.Parent then
saveBtn.Text = "SAVE SETTINGS"
saveBtn.TextColor3 = resetDefaultText
end
end)
end
end
end)

resetBtn.MouseLeave:Connect(function()
if not confirmState then
tween(resetBtn, {BackgroundColor3 = resetDefaultBg}, 0.12)
end
end)
resetBtn.MouseButton1Click:Connect(function()
if not confirmState then
confirmState = true
setResetConfirmTheme()
if confirmTimer then task.cancel(confirmTimer) end
confirmTimer = task.delay(3, function()
setResetDefaultTheme()
end)
return
end
if confirmTimer then
task.cancel(confirmTimer)
confirmTimer = nil
end
resetBtn.Text = "RESETTING..."
pcall(function()
local files = {
CONFIG_FILE,
KEYBINDS_CONFIG_FILE,
"AdaptDuels_MainGUI_Config.json",
"AdaptDuelsConfig.json",
"AdaptDuels_Settings.json",
"AdaptDuels_Keybinds.json",
"AdaptDuels_GUI.json",
}
for _, fname in ipairs(files) do
pcall(function()
if fname and isfile and isfile(fname) and delfile then
delfile(fname)
end
end)
end
end)
pcall(function()
aceGuiScaleValue = AdaptAutoMobile and 0.67 or 1.00
aceProgressBarScaleValue = AdaptAutoMobile and 0.83 or 1.00
NS = 59.5; CS = 28.8; LAGGER_SPEED = 29; LAGGER_CARRY_SPEED = 15
currentSpeedMode = "Normal"
autoCarrySpeedEnabled = false
autoTPHeight = 20
autoStealEnabled = false; selectedStealMode = "Auto Steal V3"; autoStealRadius = 63
_G.AdaptStealRadii = {Normal = 62, Semi = 9}
selectedAnimationPack = "OFF"; selectedAimbotMode = "Normal"
AIMBOT_SPEED = 58; LAGGER_AIMBOT_SPEED = 40
_G.AdaptAntiBypassAimbotSpeed = 58; _G.AdaptAntiBypassLaggerAimbotSpeed = 40; ANTI_DESYNC_AIMBOT_SPEED = 58
autoSwingEnabled = false; mirrorTPDownEnabled = false; antiDesyncAutoSwingEnabled = false
_G.AdaptNormalAimbotOn = false; _G.AdaptAntiBypassAimbotOn = false; _G.AdaptAntiDesyncAimbotOn = false
antiRagdollEnabled = false; infJumpEnabled = false; autoTPEnabled = false
batCounterEnabled = false; medCounterEnabled = false; antiKickEnabled = false; autoResetOnMedEnabled = false
espEnabled = false; showTracerEnabled = false; ragdollCountdownEnabled = false
fpsBoostEnabled = false; antiLagVisualEnabled = false; nukeOptimiserEnabled = false
fovEnabled = false; fovValue = 70; noCamCollisionEnabled = false; _G.AdaptNoPlayerCollisionEnabled = false
skyTheme = "Off"; currentBackground = 0
selectedIntroMusic = 1; _introEnabled = true
if setIntroVisual then setIntroVisual(_introEnabled) end
if setIntroSongVisual then setIntroSongVisual() end
stopIntroPlayback(); stopIntroPreview()
autoLeftEnabled = false; autoRightEnabled = false
_G.AdaptGuiLocked = false; _G.AdaptHideMobileButtons = false; _G.AdaptMobileButtonScale = AdaptAutoMobile and 0.90 or 1.00; _G.AdaptMobileButtonShape = "ROUNDED"
_G.AdaptMobileButtonImage = ""
_G.AdaptStealUIImage = ""
aceMainScale.Scale = aceGuiScaleValue
applyAdaptProgressBarScale()
applyBackground(0)
updateBackgroundButtons()
applyDefaultAdaptKeybinds()
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
if stopAutoTP then stopAutoTP() end
if stopAntiRagdoll then stopAntiRagdoll() end
if normalSpeedBox then normalSpeedBox.Text = tostring(NS) end
if carrySpeedBox then carrySpeedBox.Text = tostring(CS) end
if laggerSpeedBox then laggerSpeedBox.Text = tostring(LAGGER_SPEED) end
if laggerCarrySpeedBox then laggerCarrySpeedBox.Text = tostring(LAGGER_CARRY_SPEED) end
if autoTPHeightBox then autoTPHeightBox.Text = tostring(autoTPHeight) end
if radiusBox then radiusBox.Text = tostring(autoStealRadius) end
if _G.AdaptRefreshAimbotSpeedBoxes then _G.AdaptRefreshAimbotSpeedBoxes() end
if type(applyCustomSky) == "function" then applyCustomSky("Off") end
if skyValueLabel then skyValueLabel.Text = "Off" end
if _G.AdaptResetMobileButtons then _G.AdaptResetMobileButtons() end
pcall(function() if _G.AdaptApplyMobileButtonImage then _G.AdaptApplyMobileButtonImage() end end)
pcall(function() if _G.AdaptApplyStealUIImage then _G.AdaptApplyStealUIImage() end end)
if _G.AdaptDuelsApplySavedGameplayStates then _G.AdaptDuelsApplySavedGameplayStates() end
do end
end)
task.wait(0.35)
setResetDoneTheme()
task.wait(0.6)
pcall(function()
local TeleportService = game:GetService("TeleportService")
TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
end)
end)
end
task.wait()
_G.__AdaptDuelsSetupSettingsUI()
pcall(function() _G.AdaptInstallFontRow() end)
if (_G.AdaptCustomFontSelected or "None") ~= "None" then
    task.defer(function()
        task.wait(0.2)
        pcall(function() _G.AdaptApplyCustomFont(_G.AdaptCustomFontSelected) end)
    end)
end
if AdaptUpdateGuiLockVisual then AdaptUpdateGuiLockVisual() end
if _G.AdaptApplyMobileButtonsHidden then _G.AdaptApplyMobileButtonsHidden() end

task.defer(function()
task.wait(0.05)
pcall(function()
    local function hideAll(page)
        if not page then return end
        for _,o in ipairs(page:GetChildren()) do
            if not o:IsA("UIListLayout") and not o:IsA("UIPadding") then
                o.Visible = false
            end
        end
    end
    local function showObj(o, order, labelText)
        if not o then return end
        o.Visible = true
        if order then o.LayoutOrder = order end
        if labelText then
            if o:IsA("TextLabel") then o.Text = labelText end
            local lbl = o:FindFirstChild("Label")
            if lbl then lbl.Text = labelText end
        end
    end
    local function byName(page, name)
        return page and page:FindFirstChild(name)
    end
    local function showNamed(page, name, order, labelText)
        showObj(byName(page,name), order, labelText)
    end

    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    if _G.AdaptDropModeMainRow then
        _G.AdaptDropModeMainRow.Parent = Movement
        _G.AdaptDropModeMainRow.LayoutOrder = 10
    end
    if _G.AdaptDropSelector then
        _G.AdaptDropSelector.Parent = Movement
        _G.AdaptDropSelector.LayoutOrder = 10.1
    end

    if not byName(Movement,"DROP BRAINROT") then section(Movement,"DROP BRAINROT",9) end

    if not byName(Movement,"TP Down") then
        local r,setV = _G.AdaptActionToggleRow(Movement,"TP Down",false,12)
        local b = r and r:FindFirstChild("ToggleButton")
        if b then
            b.Activated:Connect(function()
                if runTPFloor then pcall(runTPFloor) end
                if setV then
                    setV(true)
                    task.delay(0.12,function() pcall(setV,false) end)
                end
            end)
        end
    end

    if not byName(Movement,"Unwalk") then
        local r,setV = toggleRow(Movement,"Unwalk",unwalkEnabled,18)
        local b = r and r:FindFirstChild("ToggleButton")
        if b then
            b.Activated:Connect(function()
                unwalkEnabled = not unwalkEnabled
                if unwalkEnabled then
                    if enableUnwalk then pcall(enableUnwalk) end
                else
                    if disableUnwalk then pcall(disableUnwalk) end
                end
                if setV then setV(unwalkEnabled) end
            end)
        end
    end

    hideAll(Movement)
    showNamed(Movement,"NORMAL SPEED",1,"SPEED CONFIGURATION")
    showNamed(Movement,"Normal Speed",2)
    showNamed(Movement,"Carry Speed",3)

    local modeCount = 0
    for _,o in ipairs(Movement:GetChildren()) do
        if o.Name == "Mode" then
            modeCount = modeCount + 1
            showObj(o, modeCount == 1 and 4 or 8)
        end
    end

    showNamed(Movement,"LAGGER SPEED",5,"LAGGER CONFIGURATION")
    showNamed(Movement,"Lagger Speed",6,"Lagger Normal Speed")
    showNamed(Movement,"Lagger Carry Speed",7)
    showNamed(Movement,"DROP BRAINROT",9)
    showNamed(Movement,"Drop",10)
    if _G.AdaptDropSelector then _G.AdaptDropSelector.Visible = _G.AdaptDropExpanded == true end
    showNamed(Movement,"TELEPORT",11,"TP DOWN")
    showNamed(Movement,"TP Down",12)
    showNamed(Movement,"Auto TP Down",13)
    showNamed(Movement,"Auto TP Height",14)
    showNamed(Movement,"JUMP",15)
    showNamed(Movement,"Infinite Jump",16)
    if _G.AdaptInfJumpSelector then _G.AdaptInfJumpSelector.LayoutOrder=16.1 end
    showNamed(Movement,"Anti Ragdoll",17)
    if _G.AdaptAntiRagdollSelector then
        _G.AdaptAntiRagdollSelector.Visible = false
        _G.AdaptAntiRagdollSelector.Size = UDim2.new(1,-4,0,0)
    end
    if _G.AdaptAntiRagdollArrow then
        _G.AdaptAntiRagdollArrow.Visible = false
    end
    showNamed(Movement,"Unwalk",18)

    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    if not byName(Combat,"SEMI Range") then
        local r,b = textboxRow(Combat,"SEMI Range",tostring((_G.AdaptStealRadii and _G.AdaptStealRadii.Semi) or 9),3)
        b.FocusLost:Connect(function()
            _G.AdaptStealRadii = _G.AdaptStealRadii or {}
            local n = tonumber(b.Text)
            if n then _G.AdaptStealRadii.Semi = math.clamp(n,1,500) end
            b.Text = tostring(_G.AdaptStealRadii.Semi or 9)
            if _G.AdaptSemiAutoStealSetRadius then
                pcall(_G.AdaptSemiAutoStealSetRadius,_G.AdaptStealRadii.Semi or 9)
            end
        end)
    end

    if not byName(Combat,"BAT AIMBOT") then section(Combat,"BAT AIMBOT",5) end
    if aimbotMainRow then
        aimbotMainRow.LayoutOrder = 6
        local l = aimbotMainRow:FindFirstChild("Label")
        if l then l.Text = "Bat Aimbot" end
    end
    if aimbotSpeedRow then
        aimbotSpeedRow.LayoutOrder = 7
        local l = aimbotSpeedRow:FindFirstChild("Label")
        if l then l.Text = "Auto Bat Speed" end
    end
    if _G.AdaptNormalAutoSwingRow then _G.AdaptNormalAutoSwingRow.LayoutOrder = 8 end
    if _G.AdaptMirrorTPDownRow then
        _G.AdaptMirrorTPDownRow.LayoutOrder = 9
        local l = _G.AdaptMirrorTPDownRow:FindFirstChild("Label")
        if l then l.Text = "Mirror TP" end
    end

    if not byName(Combat,"TP Bat") then
        local r,setV = _G.AdaptActionToggleRow(Combat,"TP Bat",_G.AdaptAntiDesyncAimbotOn==true,11)
        local b = r and r:FindFirstChild("ToggleButton")
        if b then
            b.Activated:Connect(function()
                if _G.AdaptToggleAntiDesyncAimbot then pcall(_G.AdaptToggleAntiDesyncAimbot) end
                if setV then setV(_G.AdaptAntiDesyncAimbotOn==true) end
            end)
        end
    end

    if not byName(Combat,"AUTO PATH") then section(Combat,"AUTO PATH",12) end
    if not byName(Combat,"Auto Left") then
        local r,setV = _G.AdaptActionToggleRow(Combat,"Auto Left",autoLeftEnabled,13)
        local b=r and r:FindFirstChild("ToggleButton")
        if b then b.Activated:Connect(function()
            if _G.AdaptSetAutoLeft then _G.AdaptSetAutoLeft(not autoLeftEnabled) end
            if setV then setV(autoLeftEnabled) end
        end) end
    end
    if not byName(Combat,"Auto Right") then
        local r,setV = _G.AdaptActionToggleRow(Combat,"Auto Right",autoRightEnabled,14)
        local b=r and r:FindFirstChild("ToggleButton")
        if b then b.Activated:Connect(function()
            if _G.AdaptSetAutoRight then _G.AdaptSetAutoRight(not autoRightEnabled) end
            if setV then setV(autoRightEnabled) end
        end) end
    end

    if not byName(Combat,"BODY LOCK") then section(Combat,"BODY LOCK",19) end

    hideAll(Combat)
    showNamed(Combat,"AUTO STEAL",1,"STEAL CONFIGURATION")
    showNamed(Combat,"Radius",2)
    showNamed(Combat,"SEMI Range",3)
    showNamed(Combat,"Auto Steal",4)
    if _G.AdaptStealSelector then _G.AdaptStealSelector.LayoutOrder=4.1 end

    showNamed(Combat,"BAT AIMBOT",5)
    showObj(aimbotMainRow,6)
    if aimbotSelector then aimbotSelector.LayoutOrder=6.1 end
    showObj(aimbotSpeedRow,7)
    showObj(_G.AdaptNormalAutoSwingRow,8)
    showObj(_G.AdaptMirrorTPDownRow,9)

    showNamed(Combat,"TP BAT",10)
    showNamed(Combat,"TP Bat",11)
    showNamed(Combat,"AUTO PATH",12)
    showNamed(Combat,"Auto Left",13)
    showNamed(Combat,"Auto Right",14)
    showNamed(Combat,"COUNTERS",15)
    showNamed(Combat,"Bat Counter",16)
    showNamed(Combat,"Med Counter",17,"Medusa Counter")
    showNamed(Combat,"Auto Reset On Med Fling",18,"Reset After Med")
    showNamed(Combat,"Auto Instant Reset",18.5,"Insta Reset On Death")
    showNamed(Combat,"BODY LOCK",19)
    showNamed(Combat,"Body Lock",20)
    if _G.AdaptBodyLockSettings then
        _G.AdaptBodyLockSettings.LayoutOrder=21
        local l=_G.AdaptBodyLockSettings:FindFirstChild("Label")
        if l then l.Text="Lock Radius" end
    end

    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    hideAll(Keybinds)
    showNamed(Keybinds,"MOVEMENT KEYBINDS",1)
    showNamed(Keybinds,"Speed Key",2)
    showNamed(Keybinds,"Lagger Mode Key",3)
    showNamed(Keybinds,"Drop Brainrot",4,"Drop Key")
    showNamed(Keybinds,"TP Down",5,"TP Down Key")
    showNamed(Keybinds,"COMBAT KEYBINDS",6)
    showNamed(Keybinds,"Normal Aimbot",7,"Bat Aimbot Key")
    showNamed(Keybinds,"TP BAT",8,"TP Bat Key")
    showNamed(Keybinds,"Auto Left",9,"Auto Left Key")
    showNamed(Keybinds,"Auto Right",10,"Auto Right Key")
    showNamed(Keybinds,"Instant Reset",11,"Insta Reset Key")

    if not byName(Keybinds,"INTERFACE KEYBINDS") then section(Keybinds,"INTERFACE KEYBINDS",12) end
    showNamed(Keybinds,"INTERFACE KEYBINDS",12)

    local uiToggleRow = byName(Settings,"Toggle UI")
    if uiToggleRow then
        uiToggleRow.Parent = Keybinds
        uiToggleRow.LayoutOrder = 13
        uiToggleRow.Visible = true
        local l=uiToggleRow:FindFirstChild("Label")
        if l then l.Text="UI Toggle Key" end
    end

    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    local bgPicker = byName(MenuCustomize,"Background Image Picker")
    local btnPicker = byName(MenuCustomize,"Mobile Button Image Picker")
    local colorPicker = byName(MenuCustomize,"ColorThemePicker")
    local barSize = byName(MenuCustomize,"Progress Bar Size")
    if bgPicker then bgPicker.Parent=Settings end
    if btnPicker then btnPicker.Parent=Settings end
    if colorPicker then colorPicker.Parent=Settings end
    if barSize then barSize.Parent=Settings end

    hideAll(MenuCustomize)

    local controllerBindButtons = {}
    local function ctrlBind(label, order)
        local r=baseRow(MenuCustomize,label,order)

        local b=Instance.new("TextButton")
        b.Name="ControllerKeybindButton"
        b.BackgroundColor3=Color3.fromRGB(8,8,12)
        b.BackgroundTransparency=0.18
        b.BorderSizePixel=0
        b.Text="NONE"
        b.TextColor3=COLORS.white
        b.TextSize=12
        b.Font=Enum.Font.GothamMedium
        b.AutoButtonColor=false
        b.Size=UDim2.new(0,56,0,22)
        b.Position=UDim2.new(1,-64,0.5,-11)
        b.ZIndex=8
        b.Parent=r
        corner(b,7)
        stroke(b,COLORS.strokeSoft,1,0.45)

        --Leaked By Xlu0 AndPrime--
        local clear=Instance.new("TextButton")
        clear.Name="ClearControllerKeybindButton"
        clear.BackgroundColor3=Color3.fromRGB(8,8,12)
        clear.BackgroundTransparency=0.08
        clear.BorderSizePixel=0
        clear.Text=""
        clear.AutoButtonColor=false
        clear.Size=UDim2.new(0,18,0,18)
        clear.Position=UDim2.new(1,-86,0.5,-9)
        clear.ZIndex=9
        clear.Parent=r
        corner(clear,999)
        stroke(clear,COLORS.strokeSoft,1,0.45)

        clear.MouseButton1Click:Connect(function()
            b.Text="NONE"
        end)

        table.insert(controllerBindButtons,b)
        return r,b
    end

    local resetCtrl=baseRow(MenuCustomize,"RESET ALL CONTROLLER",1)
    resetCtrl:FindFirstChild("Label").Text="RESET ALL CONTROLLER"
    local resetCtrlClick=Instance.new("TextButton")
    resetCtrlClick.Size=UDim2.new(1,0,1,0)
    resetCtrlClick.BackgroundTransparency=1
    resetCtrlClick.Text=""
    resetCtrlClick.ZIndex=20
    resetCtrlClick.Parent=resetCtrl
    resetCtrlClick.MouseButton1Click:Connect(function()
        for _,b in ipairs(controllerBindButtons) do b.Text="NONE" end
    end)

    section(MenuCustomize,"MOVEMENT CONTROLLER",2)
    ctrlBind("Speed Key",3); ctrlBind("Lagger Mode Key",4); ctrlBind("Drop Key",5); ctrlBind("TP Down Key",6)
    section(MenuCustomize,"COMBAT CONTROLLER",7)
    ctrlBind("Bat Aimbot Key",8); ctrlBind("TP Bat Key",9); ctrlBind("Auto Left Key",10); ctrlBind("Auto Right Key",11); ctrlBind("Insta Reset Key",12)
    section(MenuCustomize,"INTERFACE CONTROLLER",13)
    ctrlBind("UI Toggle Key",14)

    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    if not byName(Utility,"Animation Pack") then
        animationPackRow(Utility,7)
    end

    if not byName(Utility,"Show Tracer") then
        local r,setV=toggleRow(Utility,"Show Tracer",showTracerEnabled,3)
        local b=r and r:FindFirstChild("ToggleButton")
        if b then b.Activated:Connect(function()
            showTracerEnabled=not showTracerEnabled
            if BoxedESPOptions then BoxedESPOptions.tracer=showTracerEnabled end
            if refreshBoxedESP then pcall(refreshBoxedESP) end
            if setV then setV(showTracerEnabled) end
        end) end
        setTracerESPVisual=setV
    end

    if not byName(Utility,"Ragdoll Countdown") then
        local r,setV=toggleRow(Utility,"Ragdoll Countdown",ragdollCountdownEnabled,4)
        local b=r and r:FindFirstChild("ToggleButton")
        if b then b.Activated:Connect(function()
            ragdollCountdownEnabled=not ragdollCountdownEnabled
            if ragdollCountdownEnabled then pcall(hookRagdollCountdown,LP.Character) else pcall(stopRagdollCountdown) end
            if setV then setV(ragdollCountdownEnabled) end
        end) end
        setRagdollCountdownVisual=setV
    end

    if not byName(Utility,"Try Hard Animation") then
        local r,setV=toggleRow(Utility,"Try Hard Animation",hitHarderAnimEnabled,8)
        local b=r and r:FindFirstChild("ToggleButton")
        if b then b.Activated:Connect(function()
            hitHarderAnimEnabled=not hitHarderAnimEnabled
            if hitHarderAnimEnabled then pcall(enableHitHarderAnim) else pcall(disableHitHarderAnim) end
            if setV then setV(hitHarderAnimEnabled) end
        end) end
    end

    hideAll(Utility)
    showNamed(Utility,"ESP",1,"PLAYERS")
    --Leaked By Xlu0 AndPrime--
    for _,o in ipairs(Utility:GetChildren()) do
        if o.Name=="ESP" then o.Visible=true end
    end
    showNamed(Utility,"Show Tracer",3)
    showNamed(Utility,"Ragdoll Countdown",4)
    if not byName(Utility,"VISUAL") then section(Utility,"VISUAL",5) end
    showNamed(Utility,"VISUAL",5)
    showNamed(Utility,"Sky Theme",6,"Custom Sky")
    showNamed(Utility,"Animation Pack",7,"Anim Pack")
    showNamed(Utility,"Try Hard Animation",8)
    showNamed(Utility,"PERFORMANCE",9)
    showNamed(Utility,"Stretch Rez",10,"Stretch Res")
    showNamed(Utility,"Anti Lag",11,"Anti-Lag")
    showNamed(Utility,"FOV",12,"FOV Change")
    showNamed(Utility,"FOV Value",13)

    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    if not byName(Settings,"Circle Buttons") then
        local r,setV=_G.AdaptActionToggleRow(Settings,"Circle Buttons",_G.AdaptMobileButtonShape=="CIRCLE",2)
        local b=r and r:FindFirstChild("ToggleButton")
        if b then b.Activated:Connect(function()
            _G.AdaptMobileButtonShape=(_G.AdaptMobileButtonShape=="CIRCLE") and "ROUNDED" or "CIRCLE"
            if _G.AdaptApplyMobileButtonShape then _G.AdaptApplyMobileButtonShape() end
            if setV then setV(_G.AdaptMobileButtonShape=="CIRCLE") end
        end) end
    end

    if not byName(Settings,"Move Buttons") then
        local r,setV=_G.AdaptActionToggleRow(Settings,"Move Buttons",_G.AdaptGuiLocked~=true,5)
        local b=r and r:FindFirstChild("ToggleButton")
        if b then b.Activated:Connect(function()
            _G.AdaptGuiLocked=not (_G.AdaptGuiLocked==true)
            if setV then setV(_G.AdaptGuiLocked~=true) end
        end) end
    end

    if not byName(Settings,"Intro Song") then
        toggleRow(Settings,"Intro Song",false,8)
    end
    if not byName(Settings,"Background Color") then
        toggleRow(Settings,"Background Color",false,15)
    end

    hideAll(Settings)
    showNamed(Settings,"MOBILE BUTTONS",1)
    showNamed(Settings,"Circle Buttons",2)
    showNamed(Settings,"Hide Mobile Buttons",3,"Hide Mob Buttons")
    showNamed(Settings,"Mobile Buttons Size",4,"Button Size %")
    showNamed(Settings,"Move Buttons",5)
    showNamed(Settings,"Reset Mobile Buttons",6,"Reset Buttons")

    if not byName(Settings,"INTERFACE") then section(Settings,"INTERFACE",7) end
    showNamed(Settings,"INTERFACE",7)
    showNamed(Settings,"Intro Song",8)
    showNamed(Settings,"Intro",9)

    if not byName(Settings,"BACKGROUND") then section(Settings,"BACKGROUND",10) end
    showNamed(Settings,"BACKGROUND",10)
    if bgPicker then showObj(bgPicker,11) end

    if not byName(Settings,"BUTTONS IMAGE") then section(Settings,"BUTTONS IMAGE",12) end
    showNamed(Settings,"BUTTONS IMAGE",12)
    if btnPicker then showObj(btnPicker,13) end
    if colorPicker then showObj(colorPicker,14) end
    showNamed(Settings,"Background Color",15)

    if not byName(Settings,"UI SCALE") then section(Settings,"UI SCALE",16) end
    showNamed(Settings,"UI SCALE",16)
    showNamed(Settings,"GUI Scale",17,"UI Scale")
    if barSize then
        showObj(barSize,18,"Steal Bar Size")
    end
    showNamed(Settings,"Save Config Holder",19)
    showNamed(Settings,"Reset All Settings Holder",20)
end)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
local isControllerInput = tostring(input.UserInputType):find("Gamepad") ~= nil
if gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard and not listeningForSpeedKey and not listeningForTPDownKey then return end
if UserInputService:GetFocusedTextBox() then return end
if input.UserInputType ~= Enum.UserInputType.Keyboard and not isControllerInput then return end
if input.KeyCode == Enum.KeyCode.Unknown then return end
if speedKeybinds.ToggleUI and input.KeyCode == speedKeybinds.ToggleUI then
if Main.Visible then
Main.Visible = false
MiniFrame.Visible = true
else
Main.Visible = true
MiniFrame.Visible = false
Main.Size = FULL_MAIN_SIZE
end
do end
return
end
if listeningForSpeedKey then
if tick() - (keybindListenStartedAt or 0) < 0.18 then return end
local targetKey = listeningForSpeedKey
if input.KeyCode == Enum.KeyCode.Escape then
listeningForSpeedKey = nil
refreshAllSpeedKeybinds()
return
end
if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
speedKeybinds[targetKey] = nil
else
for otherKeyId, boundKey in pairs(speedKeybinds) do
if otherKeyId ~= targetKey and boundKey == input.KeyCode then
speedKeybinds[otherKeyId] = nil
end
end
if tpDownKeybind == input.KeyCode then
tpDownKeybind = nil
refreshTPDownKeybind()
end
speedKeybinds[targetKey] = input.KeyCode
end
listeningForSpeedKey = nil
refreshAllSpeedKeybinds()
do end
return
end
if listeningForTPDownKey then
if tick() - (keybindListenStartedAt or 0) < 0.18 then return end
if input.KeyCode == Enum.KeyCode.Escape then
listeningForTPDownKey = false
refreshTPDownKeybind()
return
end
if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
tpDownKeybind = nil
else
for keyId, boundKey in pairs(speedKeybinds) do
if boundKey == input.KeyCode then
speedKeybinds[keyId] = nil
end
end
tpDownKeybind = input.KeyCode
end
listeningForTPDownKey = false
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
do end
return
end
if speedKeybinds.SpeedToggle and input.KeyCode == speedKeybinds.SpeedToggle then
toggleCarryMode()
return
end
if speedKeybinds.LaggerToggle and input.KeyCode == speedKeybinds.LaggerToggle then
toggleLaggerMode()
return
end
if speedKeybinds.Aimbot and input.KeyCode == speedKeybinds.Aimbot then
if _G.AdaptSafeModeIsLocked and _G.AdaptSafeModeIsLocked() then
if _G.AdaptSafeModeForceStop then _G.AdaptSafeModeForceStop("SAFE MODE LOCK") end
return
end
if _G.AdaptToggleSelectedAimbot then
_G.AdaptToggleSelectedAimbot()
elseif selectedAimbotMode == "Anti Bypass" and _G.AdaptStartAntiBypassAimbot and _G.AdaptStopAntiBypassAimbot then
if _G.AdaptAntiBypassAimbotOn then _G.AdaptStopAntiBypassAimbot() else _G.AdaptStartAntiBypassAimbot() end
elseif _G.AdaptStartNormalAimbot and _G.AdaptStopNormalAimbot then
if _G.AdaptNormalAimbotOn then _G.AdaptStopNormalAimbot() else _G.AdaptStartNormalAimbot() end
end
if _G.AdaptRefreshAimbotVisual then _G.AdaptRefreshAimbotVisual() end
return
end
if speedKeybinds.AntiDesyncAimbot and input.KeyCode == speedKeybinds.AntiDesyncAimbot then
if _G.AdaptSafeModeIsLocked and _G.AdaptSafeModeIsLocked() then
if _G.AdaptSafeModeForceStop then _G.AdaptSafeModeForceStop("SAFE MODE LOCK") end
return
end
if _G.AdaptToggleAntiDesyncAimbot then
_G.AdaptToggleAntiDesyncAimbot()
elseif _G.AdaptStartAntiDesyncAimbot and _G.AdaptStopAntiDesyncAimbot then
if _G.AdaptAntiDesyncAimbotOn then _G.AdaptStopAntiDesyncAimbot() else _G.AdaptStartAntiDesyncAimbot() end
end
return
end
if speedKeybinds.DropBrainrot and input.KeyCode == speedKeybinds.DropBrainrot then
runDropBrainrot()
return
end
if speedKeybinds.AutoLeft and input.KeyCode == speedKeybinds.AutoLeft then
if _G.AdaptSetAutoLeft then _G.AdaptSetAutoLeft(not autoLeftEnabled) end
return
end
if speedKeybinds.AutoRight and input.KeyCode == speedKeybinds.AutoRight then
if _G.AdaptSetAutoRight then _G.AdaptSetAutoRight(not autoRightEnabled) end
return
end
if tpDownKeybind and input.KeyCode == tpDownKeybind then
runTPFloor()
return
end
end)
task.defer(function()
task.wait(0.15)
pcall(function()
for _, pageName in ipairs({"MOVEMENT","COMBAT"}) do
local page = pages[pageName]
if page then
for _, holder in ipairs(page:GetDescendants()) do
if holder:IsA("Frame") and holder:FindFirstChild("SelectedSlide") then
holder.Size = UDim2.new(1,-4,0,34)
holder.BackgroundColor3 = Color3.fromRGB(0,0,0)
holder.BackgroundTransparency = 0.3

local slide = holder:FindFirstChild("SelectedSlide")
if slide then
slide.Size = UDim2.new(0.5,-4,1,-8)
slide.BackgroundColor3 = Color3.fromRGB(255,255,255)
slide.BackgroundTransparency = 0.85
local s = slide:FindFirstChildOfClass("UIStroke")
if s then
s.Color = Color3.fromRGB(255,255,255)
s.Thickness = 1
s.Transparency = 0.2
end
end

for _, child in ipairs(holder:GetChildren()) do
if child:IsA("TextLabel") or child:IsA("TextButton") then
child.Font = Enum.Font.GothamMedium
child.TextSize = 12
end
end
end
end

for _, obj in ipairs(page:GetDescendants()) do
if obj:IsA("TextButton") and obj.Name == "ArrowButton" then
obj.Position = UDim2.new(1,-108,0.5,-13)
obj.Size = UDim2.new(0,38,0,26)
obj.BackgroundColor3 = Color3.fromRGB(8,8,12)
obj.BackgroundTransparency = 0.18
obj.Text = "▼"
obj.TextColor3 = Color3.fromRGB(255,255,255)
obj.TextSize = 22
obj.Font = Enum.Font.GothamBlack
local c = obj:FindFirstChildOfClass("UICorner")
if c then c.CornerRadius = UDim.new(0,7) end
end
end
end
end
end)
end)

setTab("MOVEMENT")
_G.__AdaptDuelsSetupStealBar = function()
local RunService   = game:GetService("RunService")
local UIS = UserInputService
local TS = TweenService
local Stats        = game:GetService("Stats")
local existingStealBar = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("StealBarGui")
if existingStealBar then existingStealBar:Destroy() end
local gui = Instance.new("ScreenGui")
gui.Name = "StealBarGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
safeParentGui(gui)
function drag(frame)
local dragging, dragStart, startPos = false, nil, nil
frame.InputBegan:Connect(function(input)
if _G.AdaptGuiLocked == true then return end
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

--Leaked By Xlu0 AndPrime--
local pbFrame = Instance.new("Frame", gui)
pbFrame.Name = "StealBar"
pbFrame.Size = UDim2.new(0, 324, 0, 56)
pbFrame.Position = UDim2.new(0.5, -162, 1, -70)
pbFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
pbFrame.BorderSizePixel = 0
pbFrame.Active = true
pbFrame.ClipsDescendants = true

--Leaked By Xlu0 AndPrime--
local stealWhiteGlow = Instance.new("Frame")
stealWhiteGlow.Name = "StealWhiteGlow"
stealWhiteGlow.Size = UDim2.new(1, 0, 1, 0)
stealWhiteGlow.Position = UDim2.new(0, 0, 0, 0)
stealWhiteGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
stealWhiteGlow.BackgroundTransparency = 1
stealWhiteGlow.BorderSizePixel = 0
stealWhiteGlow.ZIndex = 1
stealWhiteGlow.Parent = pbFrame
Instance.new("UICorner", stealWhiteGlow).CornerRadius = UDim.new(0, 15)

local stealWhiteGradient = Instance.new("UIGradient")
stealWhiteGradient.Rotation = 90
stealWhiteGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.55),
    NumberSequenceKeypoint.new(0.45, 0.15),
    NumberSequenceKeypoint.new(1, 0.65)
})
stealWhiteGradient.Parent = stealWhiteGlow

local stealBgImage = Instance.new("ImageLabel")
stealBgImage.Name = "StealUIBackground"
stealBgImage.BackgroundTransparency = 1
stealBgImage.Size = UDim2.new(1, 0, 1, 0)
stealBgImage.Position = UDim2.new(0, 0, 0, 0)
stealBgImage.ScaleType = Enum.ScaleType.Crop
stealBgImage.ImageTransparency = 0.28
stealBgImage.ZIndex = 0
stealBgImage.Parent = pbFrame
Instance.new("UICorner", stealBgImage).CornerRadius = UDim.new(0, 15)
local function normalizeStealUIImage(value)
value = tostring(value or "")
if value == "" then return "" end
if value:match("^rbxassetid://%d+$") then return value end
local id = value:match("(%d+)")
return id and ("rbxassetid://" .. id) or ""
end
function _G.AdaptApplyStealUIImage()
local image = normalizeStealUIImage(_G.AdaptStealUIImage)
stealBgImage.Image = image
stealBgImage.ImageColor3 = _G.AdaptThemeColors[_G.AdaptThemeName] or _G.AdaptThemeColors.WHITE
stealBgImage.Visible = image ~= ""
pbFrame.BackgroundTransparency = image ~= "" and 0.18 or 0
end
_G.AdaptApplyStealUIImage()
Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 15)
local pbSt = Instance.new("UIStroke", pbFrame)
pbSt.Color = Color3.fromRGB(55, 55, 55)
pbSt.Thickness = 1
drag(pbFrame)
local pbScale = Instance.new("UIScale")
pbScale.Name = "AdaptProgressBarScale"
pbScale.Scale = aceProgressBarScaleValue or 1
pbScale.Parent = pbFrame

--Leaked By Xlu0 AndPrime--
local stealLbl = Instance.new("TextLabel", pbFrame)
stealLbl.Size = UDim2.new(0, 70, 0, 20)
stealLbl.Position = UDim2.new(0, 10, 0, 4)
stealLbl.BackgroundTransparency = 1
stealLbl.Text = ""
stealLbl.Visible = false
stealLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
stealLbl.Font = Enum.Font.GothamBlack
stealLbl.TextSize = 12
stealLbl.TextXAlignment = Enum.TextXAlignment.Left

--Leaked By Xlu0 AndPrime--
local pingBarLbl = Instance.new("TextLabel", pbFrame)
pingBarLbl.Size = UDim2.new(0, 150, 0, 14)
pingBarLbl.Position = UDim2.new(0, 10, 0, 23)
pingBarLbl.BackgroundTransparency = 1
pingBarLbl.Text = "0 FPS | 0ms"
pingBarLbl.TextColor3 = Color3.fromRGB(100, 100, 100)
pingBarLbl.Font = Enum.Font.GothamBold
pingBarLbl.TextSize = 11
pingBarLbl.TextXAlignment = Enum.TextXAlignment.Left

local discordStealLbl = Instance.new("TextLabel", pbFrame)
discordStealLbl.Name = "Discord"
discordStealLbl.Size = UDim2.new(0, 140, 0, 14)
discordStealLbl.Position = UDim2.new(1, -150, 0, 23)
discordStealLbl.BackgroundTransparency = 1
discordStealLbl.Text = "discord.gg/adaptt"
discordStealLbl.TextColor3 = Color3.fromRGB(140, 140, 140)
discordStealLbl.Font = Enum.Font.GothamBold
discordStealLbl.TextSize = 10
discordStealLbl.TextXAlignment = Enum.TextXAlignment.Right

--Leaked By Xlu0 AndPrime--
local progressRadLbl = Instance.new("TextLabel", pbFrame)
progressRadLbl.Size = UDim2.new(0, 190, 0, 14)
progressRadLbl.Position = UDim2.new(1, -200, 0, 5)
progressRadLbl.BackgroundTransparency = 1
progressRadLbl.Text = string.format("Radius: %s", tostring(autoStealRadius))
progressRadLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
progressRadLbl.Font = Enum.Font.GothamBold
progressRadLbl.TextSize = 13
progressRadLbl.TextXAlignment = Enum.TextXAlignment.Right

--Leaked By Xlu0 AndPrime--
local pbg = Instance.new("Frame", pbFrame)
pbg.Size = UDim2.new(1, -18, 0, 12)
pbg.Position = UDim2.new(0, 9, 1, -17)
pbg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
pbg.BackgroundTransparency = 0.85
pbg.BorderSizePixel = 0
pbg.ClipsDescendants = true
Instance.new("UICorner", pbg).CornerRadius = UDim.new(1, 0)
local pbgStroke = Instance.new("UIStroke", pbg)
pbgStroke.Color = Color3.fromRGB(255, 255, 255)
pbgStroke.Transparency = 0.65
pbgStroke.Thickness = 1
local progressFill = Instance.new("Frame", pbg)
progressFill.Name = "Fill"
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
progressFill.BackgroundTransparency = 0.12
progressFill.BorderSizePixel = 0
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
local progressFillGrad = Instance.new("UIGradient", progressFill)
progressFillGrad.Rotation = 90
progressFillGrad.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.05),
NumberSequenceKeypoint.new(0.45, 0.35),
NumberSequenceKeypoint.new(1, 0.05),
})
local progressShine = Instance.new("Frame", progressFill)
progressShine.Size = UDim2.new(1, 0, 0, 3)
progressShine.Position = UDim2.new(0, 0, 0, 1)
progressShine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
progressShine.BackgroundTransparency = 0.35
progressShine.BorderSizePixel = 0
Instance.new("UICorner", progressShine).CornerRadius = UDim.new(1, 0)

--Leaked By Xlu0 AndPrime--
local progressPct = Instance.new("TextLabel", pbFrame)
progressPct.Size = UDim2.new(0, 64, 0, 18)
progressPct.Position = UDim2.new(0, 10, 0, 3)
progressPct.BackgroundTransparency = 1
progressPct.Text = "0%"
progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
progressPct.Font = Enum.Font.GothamBlack
progressPct.TextSize = 14
progressPct.TextXAlignment = Enum.TextXAlignment.Left

local barState = "IDLE"
function setBarState(state)
barState = state
if state == "STEALING" then
TS:Create(stealLbl, TweenInfo.new(0.18), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
TS:Create(pbSt, TweenInfo.new(0.22), {
    Color = Color3.fromRGB(255, 255, 255),
    Transparency = 0.05,
    Thickness = 1.6
}):Play()
TS:Create(stealWhiteGlow, TweenInfo.new(0.28, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0.72
}):Play()
TS:Create(progressRadLbl, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(230, 230, 230)}):Play()
TS:Create(progressPct, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
elseif state == "READY" then
TS:Create(stealLbl, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
TS:Create(pbSt, TweenInfo.new(0.25), {
    Color = Color3.fromRGB(90, 90, 90),
    Transparency = 0,
    Thickness = 1
}):Play()
TS:Create(stealWhiteGlow, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
TS:Create(progressRadLbl, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(120, 120, 120)}):Play()
else
TS:Create(stealLbl, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
TS:Create(pbSt, TweenInfo.new(0.25), {
    Color = Color3.fromRGB(55, 55, 55),
    Transparency = 0,
    Thickness = 1
}):Play()
TS:Create(stealWhiteGlow, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
TS:Create(progressRadLbl, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(100, 100, 100)}):Play()
TS:Create(progressPct, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end
end

task.spawn(function()
local lastFrame = tick()
local fpsSamples = {}
local fpsAvg = 60
RunService.RenderStepped:Connect(function()
local now = tick()
local dt = now - lastFrame
lastFrame = now
if dt > 0 then
table.insert(fpsSamples, 1 / dt)
if #fpsSamples > 30 then table.remove(fpsSamples, 1) end
local sum = 0
for _, v in ipairs(fpsSamples) do sum = sum + v end
fpsAvg = sum / #fpsSamples
end
end)
while pbFrame and pbFrame.Parent do
local ping = 0
pcall(function()
local stat = Stats.Network.ServerStatsItem["Data Ping"]
if stat then ping = tonumber(stat:GetValue()) or 0 end
end)
pingBarLbl.Text = string.format("%d FPS | %dms", math.floor(fpsAvg + 0.5), math.floor(ping + 0.5))
pingBarLbl.TextColor3 = Color3.fromRGB(255,255,255)
progressRadLbl.Text = string.format("Radius: %s", tostring(autoStealRadius))
task.wait(0.5)
end
end)

local StealBar = {}
function StealBar.SetProgress(p)
p = math.clamp(p, 0, 1)
progressFill.Size = UDim2.new(p, 0, 1, 0)
progressPct.Text = math.floor(p * 100 + 0.5) .. "%"

if barState == "STEALING" then
    --Leaked By Xlu0 AndPrime--
    stealWhiteGlow.BackgroundTransparency = 0.84 - (p * 0.26)
    progressFill.BackgroundTransparency = 0.18 - (p * 0.12)
    pbSt.Transparency = math.max(0.02, 0.18 - (p * 0.16))
end
end
function StealBar.Reset()
StealBar.SetProgress(0)
setBarState("IDLE")
end
function StealBar.SetState(state)
setBarState(state)
end
setBarState("IDLE")
_G.StealBar = StealBar
end
_G.__AdaptDuelsSetupStealBar()
if _G.AdaptAutoStealSync then task.defer(_G.AdaptAutoStealSync) end
_G.__AdaptDuelsSetupMinimizeToggle = function()
_G.__AdaptDuelsMinimized = false
Close.MouseButton1Click:Connect(function()
_G.__AdaptDuelsMinimized = not _G.__AdaptDuelsMinimized
if _G.__AdaptDuelsMinimized then
Main.Visible = false
MiniFrame.Visible = true
else
Main.Visible = true
MiniFrame.Visible = false
Main.Size = FULL_MAIN_SIZE
end
do end
end)
end
_G.__AdaptDuelsSetupMinimizeToggle()


_G.__AdaptDuelsRunIntro = function()
    local introGuiParent = Gui and Gui.Parent or PlayerGui
    local origSize = FULL_MAIN_SIZE or Main.Size
    local wasMinimizedBeforeIntro = (_G.__AdaptDuelsMinimized == true)

    if not _introEnabled then
        stopIntroPlayback()
        stopIntroPreview()
        Main.Size = origSize
        Main.Visible = not wasMinimizedBeforeIntro
        MiniFrame.Visible = wasMinimizedBeforeIntro
        return
    end

    playIntroMusic()
    Main.Visible = false
    MiniFrame.Visible = false

    task.spawn(function()
        local TweenService = game:GetService("TweenService")
        local RunService = game:GetService("RunService")

        local DARKER_BG = Color3.fromRGB(5,5,8)
        local TRAIL_COLOR = Color3.fromRGB(205,215,235)

        local function new(class, props)
            local inst = Instance.new(class)
            for k,v in pairs(props or {}) do
                if k ~= "Parent" then inst[k] = v end
            end
            if props and props.Parent then inst.Parent = props.Parent end
            return inst
        end

        local function introTween(obj, duration, props, style, dir)
            local t = TweenService:Create(
                obj,
                TweenInfo.new(duration, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
                props
            )
            t:Play()
            return t
        end

        local oldIntro = introGuiParent:FindFirstChild("AdaptChainIntro")
        if oldIntro then oldIntro:Destroy() end

        local introGui = new("ScreenGui", {
            Name = "AdaptChainIntro",
            IgnoreGuiInset = true,
            ResetOnSpawn = false,
            DisplayOrder = 1000,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            Parent = introGuiParent,
        })

        local intro = new("Frame", {
            Name = "AdaptIntro",
            ZIndex = 1000,
            Size = UDim2.new(1,0,1,0),
            BackgroundColor3 = DARKER_BG,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Parent = introGui,
        })

        --Leaked By Xlu0 AndPrime--
        local chainStage = new("Frame", {
            Name = "ChainSpearStage",
            ZIndex = 1000,
            AnchorPoint = Vector2.new(0.5,0.5),
            Position = UDim2.new(0.5,0,0.5,0),
            Size = UDim2.new(0.64,0,0.64,0),
            BackgroundTransparency = 1,
            Parent = intro,
        })
        new("UIAspectRatioConstraint",{Parent=chainStage})
        new("UISizeConstraint",{
            MinSize=Vector2.new(200,200),
            MaxSize=Vector2.new(280,280),
            Parent=chainStage
        })

        local rotorData = {
            {rot=-1094.822,trans=0.998},
            {rot=-1095.4,trans=0.998},
            {rot=-1095.978,trans=0.996},
            {rot=-1096.515,trans=0.995},
            {rot=-1097.052,trans=0.993},
            {rot=-1097.548,trans=0.991},
            {rot=-1098.004,trans=0.988},
            {rot=-1098.419,trans=0.985},
            {rot=-1098.794,trans=0.982},
            {rot=-1099.128,trans=0.978},
            {rot=-1099.421,trans=0.973},
        }

        for i,data in ipairs(rotorData) do
            local rotor = new("Frame", {
                Name="ChainSpearRotor"..i,
                ZIndex=1000,
                AnchorPoint=Vector2.new(0.5,0.5),
                Position=UDim2.new(0.5,0,0.5,0),
                Size=UDim2.new(1,0,1,0),
                BackgroundTransparency=1,
                Rotation=data.rot,
                Parent=chainStage,
            })

            new("ImageLabel", {
                Name="ChainSpearTrail"..i,
                ZIndex=1000,
                AnchorPoint=Vector2.new(0.73,0.02),
                Position=UDim2.new(0.5,0,0.5,0),
                Size=UDim2.new(0.553,0,0.829,0),
                BackgroundTransparency=1,
                Image="rbxassetid://118963313877514",
                ImageColor3=TRAIL_COLOR,
                ImageTransparency=data.trans,
                ScaleType=Enum.ScaleType.Fit,
                Parent=rotor,
            })
        end

        --Leaked By Xlu0 AndPrime--
        local introLogo = new("ImageLabel", {
            Name="IntroBanner",
            ZIndex=1002,
            AnchorPoint=Vector2.new(0.5,0.5),
            Position=UDim2.new(0.5,0,0.50,0),
            Size=UDim2.new(0.34,0,0,70),
            BackgroundTransparency=1,
            Image="rbxassetid://135088241492683",
            ImageTransparency=0,
            ScaleType=Enum.ScaleType.Fit,
            Parent=intro,
        })

        local tapAnywhere = new("TextLabel", {
            Name="TapAnywhere",
            ZIndex=1003,
            AnchorPoint=Vector2.new(0.5,0.5),
            Position=UDim2.new(0.5,0,0.50,48),
            Size=UDim2.new(0.7,0,0,20),
            BackgroundTransparency=1,
            Text="TAP ANYWHERE TO SKIP",
            TextColor3=Color3.fromRGB(255,255,255),
            TextStrokeColor3=Color3.fromRGB(0,0,0),
            TextStrokeTransparency=0.2,
            TextSize=11,
            Font=Enum.Font.GothamBlack,
            Parent=intro,
        })

        local discordInvite = new("TextLabel", {
            Name="DiscordInvite",
            ZIndex=1003,
            AnchorPoint=Vector2.new(0.5,0.5),
            Position=UDim2.new(0.5,0,0.50,68),
            Size=UDim2.new(0.7,0,0,18),
            BackgroundTransparency=1,
            Text="discord.gg/adaptt",
            TextColor3=Color3.fromRGB(255,255,255),
            TextStrokeColor3=Color3.fromRGB(0,0,0),
            TextStrokeTransparency=0.25,
            TextSize=10,
            Font=Enum.Font.GothamBlack,
            Parent=intro,
        })

        local tapCatcher = new("TextButton", {
            Name="TapCatcher",
            ZIndex=1004,
            Size=UDim2.new(1,0,1,0),
            BackgroundTransparency=1,
            Text="",
            AutoButtonColor=false,
            Parent=intro,
        })

        local skipped = false

        local function finishIntro()
            if skipped then return end
            skipped = true

            stopIntroPlayback()
            stopIntroPreview()

            introTween(intro,0.3,{BackgroundTransparency=1})

            for _,obj in ipairs(chainStage:GetDescendants()) do
                if obj:IsA("ImageLabel") then
                    introTween(obj,0.25,{ImageTransparency=1})
                end
            end

            introTween(introLogo,0.25,{ImageTransparency=1})
            introTween(tapAnywhere,0.25,{TextTransparency=1,TextStrokeTransparency=1})
            introTween(discordInvite,0.25,{TextTransparency=1,TextStrokeTransparency=1})

            task.delay(0.35,function()
                if introGui then introGui:Destroy() end
                Main.Size = origSize
                Main.Visible = not wasMinimizedBeforeIntro
                MiniFrame.Visible = wasMinimizedBeforeIntro
            end)
        end

        tapCatcher.MouseButton1Click:Connect(finishIntro)

        task.wait(0.15)
        if skipped then return end

        --Leaked By Xlu0 AndPrime--
        for i,rotor in ipairs(chainStage:GetChildren()) do
            if rotor:IsA("Frame") and rotor.Name:match("ChainSpearRotor") then
                local trail = rotor:FindFirstChildWhichIsA("ImageLabel")
                if trail then
                    task.delay((i-1)*0.035,function()
                        if skipped or not trail.Parent then return end
                        introTween(trail,0.45,{ImageTransparency=0.12})
                    end)
                end

                task.spawn(function()
                    local speed = 0.38 + (i*0.045)
                    while not skipped and rotor.Parent do
                        rotor.Rotation = rotor.Rotation + speed
                        RunService.Heartbeat:Wait()
                    end
                end)
            end
        end

        task.spawn(function()
            while not skipped and tapAnywhere.Parent do
                introTween(tapAnywhere,0.65,{TextTransparency=0.48})
                task.wait(0.65)
                if skipped then break end
                introTween(tapAnywhere,0.65,{TextTransparency=0})
                task.wait(0.65)
            end
        end)

        --Leaked By Xlu0 AndPrime--
        --Leaked By Xlu0 AndPrime--
        task.wait(12.0)
        if not skipped then finishIntro() end
    end)
end
_G.__AdaptDuelsRunIntro()

_G.AdaptDuelsForceSyncLoadedButtons = function()
pcall(function()
if setAutoTPVisual then setAutoTPVisual(autoTPEnabled) end
if autoTPEnabled then startAutoTP() else stopAutoTP() end
end)
pcall(function()
if setInfJumpVisual then setInfJumpVisual(infJumpEnabled) end
if setInfJumpInternal then setInfJumpInternal(infJumpEnabled) end
end)
pcall(function()
if setAntiRagdollVisual then setAntiRagdollVisual(antiRagdollEnabled) end
setAntiRagdoll(antiRagdollEnabled)
end)
pcall(function()
if _G.AdaptSetAutoLeft then _G.AdaptSetAutoLeft(autoLeftEnabled, true) end
if _G.AdaptSetAutoRight then _G.AdaptSetAutoRight(autoRightEnabled, true) end
end)
pcall(function()
if setAutoStealVisual then setAutoStealVisual(autoStealEnabled) end
if _G.AdaptAutoStealSync then _G.AdaptAutoStealSync() end
end)
pcall(function()
if _G.AdaptNormalAutoSwingSetVisual then _G.AdaptNormalAutoSwingSetVisual(autoSwingEnabled) end
if _G.AdaptMirrorTPDownSetVisual then _G.AdaptMirrorTPDownSetVisual(mirrorTPDownEnabled) end
if _G.AdaptAntiDesyncAutoSwingSetVisual then _G.AdaptAntiDesyncAutoSwingSetVisual(antiDesyncAutoSwingEnabled) end
if _G.AdaptAntiDesyncSetVisual then _G.AdaptAntiDesyncSetVisual(_G.AdaptAntiDesyncAimbotOn == true) end
if _G.AdaptAntiDesyncAimbotOn and _G.AdaptStartAntiDesyncAimbot then
_G.AdaptStartAntiDesyncAimbot()
elseif _G.AdaptStopAntiDesyncAimbot then
_G.AdaptStopAntiDesyncAimbot()
end
end)
pcall(function()
if selectedAimbotMode == "Anti Bypass" then
if _G.AdaptNormalAimbotStop then _G.AdaptNormalAimbotStop() end
if _G.AdaptAntiBypassAimbotOn and _G.AdaptAntiBypassStart then
_G.AdaptAntiBypassStart()
elseif _G.AdaptAntiBypassStop then
_G.AdaptAntiBypassStop()
end
else
if _G.AdaptAntiBypassStop then _G.AdaptAntiBypassStop() end
if _G.AdaptNormalAimbotOn and _G.AdaptNormalAimbotStart then
_G.AdaptNormalAimbotStart()
elseif _G.AdaptNormalAimbotStop then
_G.AdaptNormalAimbotStop()
end
end
if _G.AdaptRefreshAimbotVisual then _G.AdaptRefreshAimbotVisual() end
end)
pcall(function()
if setBatCounterVisual then setBatCounterVisual(batCounterEnabled) end
if setMedCounterVisual then setMedCounterVisual(medCounterEnabled) end
if setSafeModeVisual then setSafeModeVisual(antiKickEnabled) end
if batCounterEnabled then
if _G.AdaptStartBatCounter then _G.AdaptStartBatCounter() end
else
if _G.AdaptStopBatCounter then _G.AdaptStopBatCounter() end
end
if medCounterEnabled then
if _G.AdaptStartMedCounter then _G.AdaptStartMedCounter(LP.Character) end
else
if _G.AdaptStopMedCounter then _G.AdaptStopMedCounter() end
end
if _G.AdaptSetNoPlayerCollisionVisual then _G.AdaptSetNoPlayerCollisionVisual(_G.AdaptNoPlayerCollisionEnabled) end
if _G.AdaptNoPlayerCollisionEnabled then
if enableNoPlayerCollision then enableNoPlayerCollision() end
else
if disableNoPlayerCollision then disableNoPlayerCollision() end
end
if _G.AdaptSetAutoResetOnMed then
_G.AdaptSetAutoResetOnMed(autoResetOnMedEnabled, true)
else
if setAutoResetOnMedVisual then setAutoResetOnMedVisual(autoResetOnMedEnabled) end
end
end)
pcall(function()
if setPlayerESPVisual then setPlayerESPVisual(espEnabled) end
if espEnabled then if startPlayerESP then startPlayerESP() end; if BoxedESPOptions then BoxedESPOptions.box = false end else if stopPlayerESP then stopPlayerESP() end; if BoxedESPOptions then BoxedESPOptions.box = false end end
if setTracerESPVisual then setTracerESPVisual(showTracerEnabled) end
if BoxedESPOptions then BoxedESPOptions.tracer = false end
if refreshBoxedESP then refreshBoxedESP() end
if setRagdollCountdownVisual then setRagdollCountdownVisual(ragdollCountdownEnabled) end
if ragdollCountdownEnabled then hookRagdollCountdown(LP.Character) else stopRagdollCountdown() end
if setFPSBoostVisual then setFPSBoostVisual(fpsBoostEnabled) end
if fpsBoostEnabled then enableStretchRez() else disableStretchRez() end
if setAntiLagVisual then setAntiLagVisual(antiLagVisualEnabled) end
if antiLagVisualEnabled then enableAntiLag() else disableAntiLag() end
if setNukeOptimiserVisual then setNukeOptimiserVisual(nukeOptimiserEnabled) end
if nukeOptimiserEnabled then enableNukeOptimizer() else disableNukeOptimizer() end
if setFOVVisual then setFOVVisual(fovEnabled) end
if fovEnabled then enableCustomFov() else disableCustomFov() end
if setNoCamCollisionVisual then setNoCamCollisionVisual(noCamCollisionEnabled) end
if noCamCollisionEnabled then enableNoCamCollision() else disableNoCamCollision() end
if type(applyCustomSky) == "function" then
applyCustomSky((skyTheme and skyTheme ~= "") and skyTheme or "Off")
end
if skyValueLabel then skyValueLabel.Text = skyTheme or "Off" end
end)
do end
end
task.defer(function()
task.wait(0.35)
if type(applyCustomSky) == "function" then
pcall(function() applyCustomSky((skyTheme and skyTheme ~= "") and skyTheme or "Off") end)
end
if skyValueLabel then skyValueLabel.Text = skyTheme or "Off" end
end)
task.defer(_G.AdaptDuelsForceSyncLoadedButtons)
task.delay(1, function()
if _G.AdaptDuelsForceSyncLoadedButtons then _G.AdaptDuelsForceSyncLoadedButtons() end
end)
task.defer(function()
task.wait(0.2)
if _G.AdaptSyncToggleVisuals then _G.AdaptSyncToggleVisuals() end
end)
customFontVisualEnabled = false
if V then V.customFontEnabled = false end
function enableCustomFont() customFontVisualEnabled=false; if V then V.customFontEnabled=false end end
function disableCustomFont() customFontVisualEnabled=false; if V then V.customFontEnabled=false end end
_G.AdaptDuelsApplySavedGameplayStates = function()
pcall(function()
if setAutoTPVisual then setAutoTPVisual(autoTPEnabled == true) end
if autoTPEnabled then startAutoTP() else stopAutoTP() end
end)
pcall(function()
if setInfJumpVisual then setInfJumpVisual(infJumpEnabled == true) end
if setInfJumpInternal then setInfJumpInternal(infJumpEnabled == true) end
end)
pcall(function()
if setAntiRagdollVisual then setAntiRagdollVisual(antiRagdollEnabled == true) end
if setAntiRagdoll then setAntiRagdoll(antiRagdollEnabled == true) end
end)
pcall(function()
if _G.AdaptAntiVoidVisual then _G.AdaptAntiVoidVisual(_G.AdaptAntiVoidEnabled == true) end
_G.AdaptAntiVoidSet(_G.AdaptAntiVoidEnabled == true)
end)
pcall(function()
if _G.AdaptAntiResetVisual then _G.AdaptAntiResetVisual(_G.AdaptAntiResetEnabled == true) end
_G.AdaptSetAntiReset(_G.AdaptAntiResetEnabled == true)
end)
pcall(function()
if setAutoStealVisual then setAutoStealVisual(autoStealEnabled == true) end
if _G.AdaptAutoStealSync then _G.AdaptAutoStealSync() end
end)
pcall(function()
if setBatCounterVisual then setBatCounterVisual(batCounterEnabled == true) end
if batCounterEnabled and _G.AdaptStartBatCounter then _G.AdaptStartBatCounter() elseif _G.AdaptStopBatCounter then _G.AdaptStopBatCounter() end
end)
pcall(function()
if setMedCounterVisual then setMedCounterVisual(medCounterEnabled == true) end
if medCounterEnabled and _G.AdaptStartMedCounter then _G.AdaptStartMedCounter(LP.Character) elseif _G.AdaptStopMedCounter then _G.AdaptStopMedCounter() end
end)
pcall(function()
if _G.AdaptSetNoPlayerCollisionVisual then _G.AdaptSetNoPlayerCollisionVisual(_G.AdaptNoPlayerCollisionEnabled == true) end
if _G.AdaptNoPlayerCollisionEnabled then enableNoPlayerCollision() else disableNoPlayerCollision() end
end)
pcall(function()
if setSafeModeVisual then setSafeModeVisual(antiKickEnabled == true) end
end)
pcall(function()
if _G.AdaptSetAutoResetOnMed then _G.AdaptSetAutoResetOnMed(autoResetOnMedEnabled == true, true) end
end)
pcall(function()
if setPlayerESPVisual then setPlayerESPVisual(espEnabled == true) end
if espEnabled then if startPlayerESP then startPlayerESP() end else if stopPlayerESP then stopPlayerESP() end end
end)
pcall(function()
if setTracerESPVisual then setTracerESPVisual(showTracerEnabled == true) end
if BoxedESPOptions then BoxedESPOptions.tracer = showTracerEnabled == true end
if refreshBoxedESP then refreshBoxedESP() end
end)
pcall(function()
if setRagdollCountdownVisual then setRagdollCountdownVisual(ragdollCountdownEnabled == true) end
if ragdollCountdownEnabled then hookRagdollCountdown(LP.Character) else stopRagdollCountdown() end
end)
pcall(function()
if setFPSBoostVisual then setFPSBoostVisual(fpsBoostEnabled == true) end
if fpsBoostEnabled then enableStretchRez() else disableStretchRez() end
end)
pcall(function()
if setAntiLagVisual then setAntiLagVisual(antiLagVisualEnabled == true) end
if antiLagVisualEnabled then enableAntiLag() else disableAntiLag() end
end)
pcall(function()
if setNukeOptimiserVisual then setNukeOptimiserVisual(nukeOptimiserEnabled == true) end
if nukeOptimiserEnabled then enableNukeOptimizer() else disableNukeOptimizer() end
end)
pcall(function()
if setFOVVisual then setFOVVisual(fovEnabled == true) end
if fovEnabled then enableCustomFov() else disableCustomFov() end
end)
pcall(function()
if setNoCamCollisionVisual then setNoCamCollisionVisual(noCamCollisionEnabled == true) end
if noCamCollisionEnabled then enableNoCamCollision() else disableNoCamCollision() end
end)
pcall(function()
if type(applyCustomSky) == "function" then applyCustomSky((skyTheme and skyTheme ~= "") and skyTheme or "Off") end
if skyValueLabel then skyValueLabel.Text = skyTheme or "Off" end
end)
pcall(function()
if syncAnimationPackIndex then syncAnimationPackIndex() end
if refreshAnimationPackRow then refreshAnimationPackRow() end
if applySavedAnimationPackToCharacter then applySavedAnimationPackToCharacter(LP.Character) end
end)
end
task.defer(function()
task.wait(0.25)
if _G.AdaptDuelsApplySavedGameplayStates then _G.AdaptDuelsApplySavedGameplayStates() end
end)
task.delay(1.25, function()
if _G.AdaptDuelsApplySavedGameplayStates then _G.AdaptDuelsApplySavedGameplayStates() end
end)
task.delay(3, function()
if antiLagVisualEnabled and type(applyKTMOptimization) == "function" then pcall(applyKTMOptimization) end
if nukeOptimiserEnabled and type(applyKTMOptimization) == "function" then pcall(applyKTMOptimization) end
end)
_G.AdaptAutoTPRestoreWanted = _G.AdaptAutoTPRestoreWanted or false
_G.AdaptAutoTPRestoreBlockedUntil = _G.AdaptAutoTPRestoreBlockedUntil or 0
function aceAnyAimbotActive()
return (_G.AdaptNormalAimbotOn == true) or (_G.AdaptAntiBypassAimbotOn == true) or (_G.AdaptAntiDesyncAimbotOn == true) or (_G.AdaptAntiDesyncAimbotOn == true)
end
_G.AdaptStopAutoTPForAction = function()
if autoTPEnabled then
_G.AdaptAutoTPRestoreWanted = true
_G.AdaptAutoTPRestoreBlockedUntil = tick() + 0.35
stopAutoTP()
if setAutoTPVisual then setAutoTPVisual(false) end
end
end
function aceTryRestoreAutoTP()
if not _G.AdaptAutoTPRestoreWanted then return end
if tick() < (_G.AdaptAutoTPRestoreBlockedUntil or 0) then return end
if aceAnyAimbotActive() then return end
if dropBrainrotActive then return end
_G.AdaptAutoTPRestoreWanted = false
startAutoTP()
if setAutoTPVisual then setAutoTPVisual(true) end
do end
end
RunService.Heartbeat:Connect(aceTryRestoreAutoTP)
_G._oldAdaptStopNormalAimbot = _G.AdaptStopNormalAimbot
_G.AdaptStopNormalAimbot = function(...)
local r = {_G._oldAdaptStopNormalAimbot(...)}
_G.AdaptAutoTPRestoreBlockedUntil = tick() + 0.05
task.delay(0.08, aceTryRestoreAutoTP)
return unpack(r)
end
_G.AdaptNormalAimbotStop = _G.AdaptStopNormalAimbot
_G._oldAdaptStopAntiBypassAimbot = _G.AdaptStopAntiBypassAimbot
_G.AdaptStopAntiBypassAimbot = function(...)
local r = {_G._oldAdaptStopAntiBypassAimbot(...)}
_G.AdaptAutoTPRestoreBlockedUntil = tick() + 0.05
task.delay(0.08, aceTryRestoreAutoTP)
return unpack(r)
end
_G.AdaptAntiBypassStop = _G.AdaptStopAntiBypassAimbot
_G._oldAdaptStopAntiDesyncAimbot = _G.AdaptStopAntiDesyncAimbot
_G.AdaptStopAntiDesyncAimbot = function(...)
local r = {_G._oldAdaptStopAntiDesyncAimbot(...)}
_G.AdaptAutoTPRestoreBlockedUntil = tick() + 0.05
task.delay(0.08, aceTryRestoreAutoTP)
return unpack(r)
end
task.spawn(function()
local wasDropping = false
while task.wait(0.05) do
if dropBrainrotActive then
wasDropping = true
elseif wasDropping then
wasDropping = false
_G.AdaptAutoTPRestoreBlockedUntil = tick() + 0.05
task.delay(0.08, aceTryRestoreAutoTP)
end
end
end)
function aceRepairKeybinds()
for keyId, defaultKey in pairs(DEFAULT_SPEED_KEYBINDS) do
if speedKeybinds[keyId] == nil or speedKeybinds[keyId] == Enum.KeyCode.Unknown then
speedKeybinds[keyId] = defaultKey
end
end
--Leaked By Xlu0 AndPrime--
if speedKeybinds.AntiDesyncAimbot == nil then
speedKeybinds.AntiDesyncAimbot = Enum.KeyCode.V
end
if tpDownKeybind == Enum.KeyCode.Unknown then tpDownKeybind = DEFAULT_TP_DOWN_KEYBIND end
if refreshAllSpeedKeybinds then refreshAllSpeedKeybinds() end
if refreshTPDownKeybind then refreshTPDownKeybind() end
end
_G._oldSaveAdaptConfigStable = saveAdaptConfig
saveAdaptConfig = function()
aceRepairKeybinds()
return _G._oldSaveAdaptConfigStable()
end
aceRepairKeybinds()
task.defer(function()
task.wait(0.2)
aceRepairKeybinds()
do end
end)
task.defer(function()
task.wait(0.35)
local TS = game:GetService("TweenService")
for _, oldName in ipairs({"AdaptMobileButtons", "AdaptMobileButtons"}) do
local old = PlayerGui:FindFirstChild(oldName)
if old then old:Destroy() end
end
local mobileGui = Instance.new("ScreenGui")
mobileGui.Name = "AdaptMobileButtons"
mobileGui.ResetOnSpawn = false
mobileGui.IgnoreGuiInset = true
mobileGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
mobileGui.DisplayOrder = 1000
safeParentGui(mobileGui)
mobileGui.Enabled = not (_G.AdaptHideMobileButtons == true)
_G.AdaptMobileButtonRefs = {}
local mobileButtons = _G.AdaptMobileButtonRefs
function _G.AdaptApplyMobileButtonsHidden()
local shouldHide = (_G.AdaptHideMobileButtons == true)

local g = nil
pcall(function()
    g = PlayerGui:FindFirstChild("AdaptMobileButtons")
end)

if not g then
    pcall(function()
        local cg = game:GetService("CoreGui")
        g = cg and cg:FindFirstChild("AdaptMobileButtons")
    end)
end

if not g and gethui then
    pcall(function()
        local hui = gethui()
        g = hui and hui:FindFirstChild("AdaptMobileButtons")
    end)
end

if not g and mobileGui and mobileGui.Parent then
    g = mobileGui
end

if g then
    g.Enabled = not shouldHide
end

if setHideMobileButtonsVisual then
    pcall(setHideMobileButtonsVisual, shouldHide)
end
end
local function normalizeMobileImage(value)
value = tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
if value == "" then return "" end
local id = value:match("^(%d+)$")
if id then return "rbxassetid://" .. id end
local embedded = value:match("[?&]id=(%d+)") or value:match("/(%d+)[/%?]?")
if embedded then return "rbxassetid://" .. embedded end
return value
end
function _G.AdaptApplyMobileButtonImage()
local image = normalizeMobileImage(_G.AdaptMobileButtonImage)
for _, entry in pairs(mobileButtons) do
local btn = entry and entry.btn
local img = btn and btn:FindFirstChild("MobileBackgroundImage")
if img then
img.Image = image
img.ImageColor3 = _G.AdaptThemeColors[_G.AdaptThemeName] or _G.AdaptThemeColors.WHITE
img.Visible = image ~= ""
end
end
end
function _G.AdaptApplyMobileButtonShape()
local shape = tostring(_G.AdaptMobileButtonShape or "ROUNDED"):upper()
if shape ~= "CIRCLE" and shape ~= "SQUARE" and shape ~= "ROUNDED" then shape = "ROUNDED" end
_G.AdaptMobileButtonShape = shape
for key, entry in pairs(mobileButtons) do
local btn = entry and entry.btn
local holder = entry and entry.holder
if btn and holder then
local isSquare = shape == "SQUARE"
holder.Size = UDim2.new(0,58,0,58)
btn.Font = Enum.Font.GothamMedium
btn.TextSize = 10
local textOverlay = btn:FindFirstChild("MobileButtonText")
if textOverlay then
textOverlay.Font = btn.Font
textOverlay.TextSize = btn.TextSize
end
local radius = UDim.new(0,10)
if shape == "CIRCLE" then radius = UDim.new(1,0) end
if isSquare then radius = UDim.new(0,10) end
local c = btn:FindFirstChildOfClass("UICorner")
if c then c.CornerRadius = radius end
local img = btn:FindFirstChild("MobileBackgroundImage")
local ic = img and img:FindFirstChildOfClass("UICorner")
if ic then ic.CornerRadius = radius end
local glow = holder:FindFirstChild("Glow")
local gc = glow and glow:FindFirstChildOfClass("UICorner")
if gc then gc.CornerRadius = radius end
local dot = btn:FindFirstChild("Dot")
if isSquare then
if not dot then
 dot = Instance.new("Frame")
 dot.Name = "Dot"
 dot.Size = UDim2.new(0, 6, 0, 6)
 dot.Position = UDim2.new(1, -12, 0, 7)
 dot.BackgroundColor3 = Color3.fromRGB(80,80,95)
 dot.BorderSizePixel = 0
 dot.ZIndex = btn.ZIndex + 2
 dot.Parent = btn
 Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
end
dot.Visible = true
else
if dot then dot.Visible = false end
end
end
end
end
function _G.AdaptApplyMobileButtonSize()
_G.AdaptMobileButtonScale = math.clamp(tonumber(_G.AdaptMobileButtonScale) or 1.00, 0.30, 1.35)
for _, entry in pairs(mobileButtons) do
local holder = entry and entry.holder
if holder then
local sc = holder:FindFirstChild("MobileButtonScale") or Instance.new("UIScale")
sc.Name = "MobileButtonScale"
sc.Scale = _G.AdaptMobileButtonScale
sc.Parent = holder
end
end
pcall(function()
local gui = PlayerGui:FindFirstChild("AdaptDuelsAdaptReconstruct") or PlayerGui:FindFirstChild("AdaptHubPolished") or PlayerGui:FindFirstChild("CyberHub")
local root = gui or PlayerGui
for _, obj in ipairs(root:GetDescendants()) do
if obj.Name == "Mobile Buttons Size" then
local valueBox = obj:FindFirstChild("Value")
if valueBox and valueBox:IsA("TextLabel") then
valueBox.Text = string.format("%.2f", _G.AdaptMobileButtonScale)
end
end
end
end)
end
local function setActive(btn, state)
if not btn then return end
local pressed = btn:GetAttribute("AdaptMobilePressed") == true
state = (state == true) or pressed
local visualState = state and "on" or "off"
if btn:GetAttribute("AdaptMobileVisualState") == visualState then return end
btn:SetAttribute("AdaptMobileVisualState", visualState)
local holder = btn.Parent
local glow = holder and holder:FindFirstChild("Glow")
local st = btn:FindFirstChildOfClass("UIStroke")
local textOverlay = btn:FindFirstChild("MobileButtonText")
local noneBg = btn:FindFirstChild("ButtonNoneBackground")
local noneGrad = noneBg and noneBg:FindFirstChild("ButtonNoneGradient")
local dot = btn:FindFirstChild("Dot")
if noneGrad then noneGrad.Enabled = not state end
if noneBg then
TS:Create(noneBg,TweenInfo.new(0.18),{
BackgroundColor3 = state and Color3.fromRGB(220,220,220) or Color3.fromRGB(255,255,255)
}):Play()
end
if textOverlay then
TS:Create(textOverlay, TweenInfo.new(0.18), {
TextColor3 = state and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255),
}):Play()
end
if st then
TS:Create(st, TweenInfo.new(0.18), {
Color = Color3.fromRGB(255,255,255),
Thickness = 1.1,
Transparency = state and 0.35 or 0.55,
}):Play()
end
if dot and dot.Visible then
TS:Create(dot, TweenInfo.new(0.16), {
BackgroundColor3 = state and Color3.fromRGB(0,0,0) or Color3.fromRGB(80,80,95),
}):Play()
end
if glow then
glow.Visible = false
glow.BackgroundTransparency = 1
local gs = glow:FindFirstChildOfClass("UIStroke")
if gs then gs.Transparency = 1 end
end
end
local function pulse(btn)
if not btn then return end
btn:SetAttribute("AdaptMobilePressed", true)
setActive(btn, true)
task.delay(0.18, function()
if btn and btn.Parent then
btn:SetAttribute("AdaptMobilePressed", false)
setActive(btn, false)
end
end)
end
local function makeButton(key, label, pos, onPress, customSize)
local holder = Instance.new("Frame")
holder.Name = "MBH_" .. key
holder.Size = customSize or UDim2.new(0,58,0,58)
holder.Position = pos
holder.BackgroundTransparency = 1
holder.BorderSizePixel = 0
holder.ZIndex = 1000
holder.Active = true
holder.Parent = mobileGui
local glow = Instance.new("Frame", holder)
glow.Name = "Glow"
glow.Size = UDim2.new(1, 4, 1, 4)
glow.Position = UDim2.new(0, -2, 0, -2)
glow.BackgroundColor3 = Color3.fromRGB(255,255,255)
glow.BackgroundTransparency = 1
glow.BorderSizePixel = 0
glow.ZIndex = 1000
Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 13)
local glowStroke = Instance.new("UIStroke", glow)
glowStroke.Color = Color3.fromRGB(255,255,255)
glowStroke.Thickness = 0.8
glowStroke.Transparency = 1
glowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
local btn = Instance.new("TextButton", holder)
btn.Name = "MB_" .. key
btn.Size = UDim2.new(1, 0, 1, 0)
btn.Position = UDim2.new(0, 0, 0, 0)
btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
btn.BackgroundTransparency = 1
btn.BorderSizePixel = 0
btn.Text = label
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.Font = Enum.Font.GothamMedium
btn.TextSize = 11
btn.TextWrapped = true
btn.AutoButtonColor = false
btn.ZIndex = 1002
btn.Active = true
Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

local noneBg = Instance.new("ImageLabel", btn)
noneBg.Name = "ButtonNoneBackground"
noneBg.Size = UDim2.new(1,0,1,0)
noneBg.Position = UDim2.new(0,0,0,0)
noneBg.BackgroundColor3 = Color3.fromRGB(255,255,255)
noneBg.BorderSizePixel = 0
noneBg.ZIndex = btn.ZIndex
noneBg.Parent = btn
Instance.new("UICorner", noneBg).CornerRadius = UDim.new(0,10)

local noneGrad = Instance.new("UIGradient", noneBg)
noneGrad.Name = "ButtonNoneGradient"
noneGrad.Rotation = 25
noneGrad.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0,Color3.fromRGB(22,22,25)),
ColorSequenceKeypoint.new(0.18,Color3.fromRGB(2,2,3)),
ColorSequenceKeypoint.new(0.82,Color3.fromRGB(2,2,3)),
ColorSequenceKeypoint.new(1,Color3.fromRGB(22,22,25))
})

local bgImage = Instance.new("ImageLabel", btn)
bgImage.Name = "MobileBackgroundImage"
bgImage.BackgroundTransparency = 1
bgImage.BorderSizePixel = 0
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.Position = UDim2.new(0, 0, 0, 0)
bgImage.Image = normalizeMobileImage(_G.AdaptMobileButtonImage)
bgImage.ImageColor3 = _G.AdaptThemeColors[_G.AdaptThemeName] or _G.AdaptThemeColors.WHITE
bgImage.ImageTransparency = 0.18
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.Visible = bgImage.Image ~= ""
bgImage.ZIndex = btn.ZIndex
local bgCorner = Instance.new("UICorner", bgImage)
bgCorner.CornerRadius = UDim.new(0,10)
local textOverlay = Instance.new("TextLabel", btn)
textOverlay.Name = "MobileButtonText"
textOverlay.BackgroundTransparency = 1
textOverlay.Size = UDim2.new(1, -8, 1, -8)
textOverlay.Position = UDim2.new(0, 4, 0, 4)
textOverlay.Text = label
textOverlay.TextColor3 = Color3.fromRGB(255,255,255)
textOverlay.TextStrokeColor3 = Color3.fromRGB(0,0,0)
textOverlay.TextStrokeTransparency = 1
textOverlay.Font = Enum.Font.GothamBlack
textOverlay.TextSize = 11
textOverlay.TextWrapped = true
textOverlay.TextXAlignment = Enum.TextXAlignment.Center
textOverlay.TextYAlignment = Enum.TextYAlignment.Center
textOverlay.ZIndex = btn.ZIndex + 1
local mobileTextStroke = Instance.new("UIStroke", textOverlay)
mobileTextStroke.Thickness = 1.4
mobileTextStroke.Transparency = 0
btn.TextTransparency = 1
local stroke = Instance.new("UIStroke", btn)
stroke.Color = Color3.fromRGB(255,255,255)
stroke.Thickness = 1.1
stroke.Transparency = 0.55
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
local pressing, dragging = false, false
local pressPos, holderStart = nil, nil
btn.InputBegan:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
pressing = true
dragging = false
pressPos = i.Position
holderStart = holder.Position
btn:SetAttribute("AdaptMobilePressed", true)
setActive(btn, true)
pcall(function()
TS:Create(btn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
Position = UDim2.new(0, 0, 0, 4),
Size = UDim2.new(1, 0, 1, -4)
}):Play()
end)
end
end)
btn.InputEnded:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
if pressing and not dragging then pcall(onPress, btn) end
if dragging then do end end
pressing = false
dragging = false
btn:SetAttribute("AdaptMobilePressed", false)
pcall(function()
TS:Create(btn, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
Position = UDim2.new(0, 0, 0, 0),
Size = UDim2.new(1, 0, 1, 0)
}):Play()
end)
task.delay(0.08, function()
if btn and btn.Parent then
local keepOn = false
if key == "autoLeft" then keepOn = autoLeftEnabled == true
elseif key == "autoRight" then keepOn = autoRightEnabled == true
elseif key == "aimbot" then keepOn = (_G.AdaptNormalAimbotOn == true) or (_G.AdaptAntiBypassAimbotOn == true)
elseif key == "antiDesync" then keepOn = _G.AdaptAntiDesyncAimbotOn == true
elseif key == "carry" then keepOn = currentSpeedMode == "Carry"
elseif key == "laggerNormal" then keepOn = currentSpeedMode == "Lagger"
elseif key == "laggerCarry" then keepOn = currentSpeedMode == "Lagger Carry"
end
setActive(btn, keepOn)
end
end)
end
end)
UserInputService.InputChanged:Connect(function(i)
if _G.AdaptGuiLocked == true or not pressing then return end
if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
local delta = i.Position - pressPos
if not dragging and (math.abs(delta.X) > 6 or math.abs(delta.Y) > 6) then dragging = true end
if dragging then
holder.Position = UDim2.new(holderStart.X.Scale, holderStart.X.Offset + delta.X, holderStart.Y.Scale, holderStart.Y.Offset + delta.Y)
end
end)
mobileButtons[key] = {holder = holder, btn = btn, setActive = function(state) setActive(btn, state) end}
return btn
end

local AdaptResetCooldown = false
local AdaptResetThread = nil
local AdaptResetCharacter = nil
local AdaptResetSuccessful = false
local AdaptStopResetSequence = false
local AdaptCameraLocked = false
local AdaptLockedCameraCFrame = nil
local AdaptResetMaxDuration = 0.05

function _G.AdaptInstantReset()
if AdaptResetCooldown then return end
AdaptResetCooldown = true
AdaptResetSuccessful = false
AdaptStopResetSequence = false
AdaptCameraLocked = false

local character = LP.Character
if not character then
AdaptResetCooldown = false
return
end

local humanoid = character:FindFirstChildOfClass("Humanoid")
if not humanoid then
AdaptResetCooldown = false
return
end

local camera = workspace.CurrentCamera
if camera then
AdaptLockedCameraCFrame = camera.CFrame
AdaptCameraLocked = true
camera.CFrame = AdaptLockedCameraCFrame
end

AdaptResetCharacter = character
local isRespawning = false

AdaptResetThread = task.spawn(function()
local attempts = 0
local maxAttempts = 40
local originalHipHeight = humanoid.HipHeight

while character and character.Parent and humanoid and humanoid.Health > 0 and not isRespawning and not AdaptStopResetSequence do
if LP.Character ~= character then
isRespawning = true
break
end

pcall(function()
humanoid.HipHeight = 1e30
humanoid.AutoRotate = true

local rootPart = character:FindFirstChild("HumanoidRootPart")
if rootPart then
rootPart.CanCollide = false
end

for _, part in ipairs(character:GetChildren()) do
if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
part.CanCollide = false
end
end
end)

if not character or not character.Parent or not humanoid or humanoid.Health <= 0 or LP.Character ~= character then
AdaptResetSuccessful = true
break
end

attempts += 1
if attempts >= maxAttempts then break end
task.wait(AdaptResetMaxDuration)
end

if not AdaptResetSuccessful and character and character.Parent and humanoid and humanoid.Health > 0 and not isRespawning then
pcall(function()
humanoid.Health = 0
end)
task.wait(0.1)
if not character.Parent or humanoid.Health <= 0 then
AdaptResetSuccessful = true
end
end

if not AdaptResetSuccessful and character and character.Parent and humanoid then
pcall(function()
humanoid.HipHeight = originalHipHeight
local rootPart = character:FindFirstChild("HumanoidRootPart")
if rootPart then
rootPart.CanCollide = true
end
for _, part in ipairs(character:GetChildren()) do
if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
part.CanCollide = true
end
end
end)
end

AdaptCameraLocked = false
AdaptResetCooldown = false
AdaptResetThread = nil
AdaptResetCharacter = nil
AdaptStopResetSequence = false
end)
end

function _G.AdaptStopInstantReset()
AdaptStopResetSequence = true
if AdaptResetThread then
pcall(task.cancel, AdaptResetThread)
AdaptResetThread = nil
end
AdaptResetCooldown = false
AdaptResetCharacter = nil
AdaptCameraLocked = false
end

LP.CharacterAdded:Connect(function()
_G.AdaptStopInstantReset()
AdaptResetSuccessful = false
AdaptStopResetSequence = false
AdaptCameraLocked = false
end)

RunService.RenderStepped:Connect(function()
if AdaptCameraLocked and AdaptLockedCameraCFrame and workspace.CurrentCamera then
workspace.CurrentCamera.CFrame = AdaptLockedCameraCFrame
end
end)

local defaults = {
drop         = UDim2.new(1,-132,0.5,-161),
autoRight    = UDim2.new(1,-66, 0.5,-161),
aimbot       = UDim2.new(1,-132,0.5,-95),
autoLeft     = UDim2.new(1,-66, 0.5,-95),
tp           = UDim2.new(1,-132,0.5,-29),
laggerNormal = UDim2.new(1,-66, 0.5,-29),
antiDesync   = UDim2.new(1,-132,0.5,37),
carry        = UDim2.new(1,-66, 0.5,37),
instaReset   = UDim2.new(1,-132,0.5,103),
}

function _G.AdaptResetMobileButtons()
_G.AdaptMobileButtonScale = AdaptAutoMobile and 0.90 or 1.00
_G.AdaptMobileButtonImage = ""
_G.AdaptHideMobileButtons = false
_G.AdaptMobileButtonShape = "ROUNDED"
for key, defaultPos in pairs(defaults) do
local entry = mobileButtons[key]
local holder = entry and entry.holder
if holder then
holder.Position = defaultPos
end
end
_G.AdaptApplyMobileButtonSize()
_G.AdaptApplyMobileButtonsHidden()
_G.AdaptApplyMobileButtonShape()
_G.AdaptApplyMobileButtonImage()
_G.AdaptApplyMobileButtonShape()
do end
end

makeButton("drop", "DROP\nBRAINROT", defaults.drop, function(btn)
if runDropBrainrot then runDropBrainrot() elseif runDrop then runDrop() end
pulse(btn)
end)

local instantResetBtn = makeButton("instaReset", "INSTANT RESET", defaults.instaReset, function(btn)
if _G.AdaptInstantReset then
_G.AdaptInstantReset()
end
pulse(btn)
end, UDim2.new(0,124,0,58))

if instantResetBtn then
instantResetBtn.Name = "Instant Reset"
instantResetBtn.Visible = true
local instantHolder = instantResetBtn.Parent
if instantHolder then
instantHolder.Name = "Instant Reset Holder"
instantHolder.Visible = true
instantHolder.Size = UDim2.new(0,124,0,58)
instantHolder.Position = defaults.instaReset
instantHolder.ZIndex = 1000
end
end

makeButton("autoLeft", "AUTO LEFT", defaults.autoLeft, function()
if _G.AdaptSetAutoLeft then _G.AdaptSetAutoLeft(not autoLeftEnabled) end
end)

makeButton("aimbot", "BAT AIMBOT", defaults.aimbot, function(btn)
if _G.AdaptSafeModeIsLocked and _G.AdaptSafeModeIsLocked() then return end
selectedAimbotMode = "Normal"
if _G.AdaptToggleSelectedAimbot then _G.AdaptToggleSelectedAimbot() end
task.delay(0.03, function()
setActive(btn, _G.AdaptNormalAimbotOn == true)
end)
end)

makeButton("autoRight", "AUTO RIGHT", defaults.autoRight, function()
if _G.AdaptSetAutoRight then _G.AdaptSetAutoRight(not autoRightEnabled) end
end)

makeButton("laggerNormal", "LAGGER MODE", defaults.laggerNormal, function(btn)
if setSpeedMode then
if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
setSpeedMode("Normal")
else
setSpeedMode("Lagger")
end
end
task.delay(0.03,function()
setActive(btn,currentSpeedMode=="Lagger" or currentSpeedMode=="Lagger Carry")
end)
end)

makeButton("antiDesync", "TP BAT", defaults.antiDesync, function(btn)
if _G.AdaptSafeModeIsLocked and _G.AdaptSafeModeIsLocked() then return end
if _G.AdaptToggleAntiDesyncAimbot then
_G.AdaptToggleAntiDesyncAimbot()
end
task.delay(0.03, function()
setActive(btn, _G.AdaptAntiDesyncAimbotOn == true)
end)
end)

makeButton("tp", "TP DOWN", defaults.tp, function(btn)
if runTPFloor then runTPFloor() end
pulse(btn)
end)

makeButton("carry", "CARRY SPEED", defaults.carry, function()
if setSpeedMode then
setSpeedMode(currentSpeedMode == "Carry" and "Normal" or "Carry")
end
end)

task.defer(function()
task.wait(0.15)
local entry = mobileButtons and mobileButtons.instaReset
local holder = entry and entry.holder
if holder then
holder.Visible = true
holder.Size = UDim2.new(0,124,0,58)
holder.Position = defaults.instaReset
holder.ZIndex = 1000
end
local btn = entry and entry.btn
if btn then
btn.Visible = true
btn.Name = "Instant Reset"
end
end)



_G.AdaptApplyMobileButtonSize()
_G.AdaptApplyMobileButtonsHidden()

task.defer(function()
    task.wait(0.15)
    if mobileGui then
        mobileGui.Enabled = not (_G.AdaptHideMobileButtons == true)
    end
    pcall(_G.AdaptApplyMobileButtonsHidden)
end)

RunService.Heartbeat:Connect(function()
if mobileButtons.autoLeft then mobileButtons.autoLeft.setActive(autoLeftEnabled == true) end
if mobileButtons.autoRight then mobileButtons.autoRight.setActive(autoRightEnabled == true) end
if mobileButtons.aimbot then mobileButtons.aimbot.setActive(_G.AdaptNormalAimbotOn == true) end
if mobileButtons.antiDesync then mobileButtons.antiDesync.setActive(_G.AdaptAntiDesyncAimbotOn == true) end
if mobileButtons.carry then mobileButtons.carry.setActive(currentSpeedMode == "Carry") end
if mobileButtons.laggerNormal then mobileButtons.laggerNormal.setActive(currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry") end
end)
end)


task.defer(function()
task.wait(1)
pcall(function()
_G.AdaptApplyMovingEdgeLights(PlayerGui)
end)
end)

--Leaked By Xlu0 AndPrime--
pcall(function()
if hookfunction and newcclosure then
local _xKickRemote = nil
local _xOldFire
_xOldFire = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
if not _xKickRemote and typeof(self) == "Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3) == "RE/" then
_xKickRemote = self
end
return _xOldFire(self, ...)
end))
end
end)

print("Remake By Xlu0 Anti Cheat Bypass By Prime")
print("Remake By Xlu0 Anti Cheat Bypass By Prime")
print("Remake By Xlu0 Anti Cheat Bypass By Prime")
print("Remake By Xlu0 Anti Cheat Bypass By Prime")
print("Remake By Xlu0 Anti Cheat Bypass By Prime")
print("Remake By Xlu0 Anti Cheat Bypass By Prime")
print("Remake By Xlu0 Anti Cheat Bypass By Prime")
print("Remake By Xlu0 Anti Cheat Bypass By Prime")
print("Remake By Xlu0 Anti Cheat Bypass By Prime")
print("Remake By Xlu0 Anti Cheat Bypass By Prime")
print("Remake By Xlu0 Anti Cheat Bypass By Prime")
print("Remake By Xlu0 Anti Cheat Bypass By Prime")
