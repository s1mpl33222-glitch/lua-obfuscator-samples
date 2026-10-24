--[[
  candytp  |  discord.gg/usYtFqxQdN
  Pink + black edition  -  PC + Mobile
  RightShift (PC) or the floating "C" button toggles the UI.
]]
    
pcall(function()
    if setthreadidentity then
        setthreadidentity(8)
    end
end)
local P = game:GetService("Players")
local C = P.LocalPlayer
if not game:IsLoaded() then
    game.Loaded:Wait()
end
local P = {
    SelectedPetData = nil,
    AllAnimalsCache = nil,
    DisableStealSpeed = nil,
    ListNeedsRedraw = true,
    AdminButtonCache = {},
    StealSpeedToggleFunc = nil,
    _ssUpdateBtn = nil,
    AdminProxBtn = nil,
    BalloonedPlayers = {},
    MobileScaleObjects = {},
    RefreshMobileScale = nil,
    MobileActionButtons = {},
    RefreshMobileActionButtons = nil,
}
_G.__candytp_State = P
do
    local C = { AUTO_STEAL = false, RADIUS = 12 }
    local r =
        {
            {
                min = Vector3.new(-337.448303, -3.898971, -122.397758),
                max = Vector3.new(-328.004578, -3.898971, 242.625626),
            },
            {
                min = Vector3.new(-327.25766, -3.899109, -122.228622),
                max = Vector3.new(-320.600891, -3.899109, 242.612259),
            },
            {
                min = Vector3.new(-319.783386, -3.89897, -122.227089),
                max = Vector3.new(-312.908325, -3.89897, 242.585617),
            },
            {
                min = Vector3.new(-312.445648, -3.899108, -122.389832),
                max = Vector3.new(-305.489899, -3.899108, 242.456818),
            },
            {
                min = Vector3.new(-305.037048, -3.89897, -122.230743),
                max = Vector3.new(-293.957489, -3.89897, 242.606873),
            },
            {
                min = Vector3.new(-491.448608, -3.898972, -122.253258),
                max = Vector3.new(-481.811737, -3.898972, 242.615005),
            },
            {
                min = Vector3.new(-498.971069, -3.89897, -122.382767),
                max = Vector3.new(-491.74884, -3.89897, 242.612061),
            },
            {
                min = Vector3.new(-506.436737, -3.898972, -122.411476),
                max = Vector3.new(-499.318542, -3.898972, 242.615982),
            },
            {
                min = Vector3.new(-513.783569, -3.898972, -122.223297),
                max = Vector3.new(-506.801849, -3.898972, 242.62709),
            },
            {
                min = Vector3.new(-525.236938, -3.898972, -122.409813),
                max = Vector3.new(-514.265015, -3.898972, 242.608932),
            },
        }
    local R = game:GetService("Players")
    local d = game:GetService("RunService")
    local n = R.LocalPlayer
    do
        local function f()
            n.DevEnableMouseLock = true
            n.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
        end
        f()
        n.CharacterAdded:Connect(function()
            task.wait(0.5)
            f()
        end)
    end
    local R = {}
    local d = {}
    local f = 0
    function _G.getSafePollRate()
        if os.clock() < f then
            return 0.27
        end
        return 0.1
    end
    function _G.triggerSafePollBoost()
        f = os.clock() + 3
    end
    local f = {}
    local function J()
        local a = n.Character
        return a and a:FindFirstChild("HumanoidRootPart")
    end
    local function n(a)
        for e, x in ipairs(r) do
            if
                a.X >= math.min(x.min.X, x.max.X)
                and a.X <= math.max(x.min.X, x.max.X)
                and a.Z >= math.min(x.min.Z, x.max.Z)
                and a.Z <= math.max(x.min.Z, x.max.Z)
            then
                return e
            end
        end
    end
    local function r(a)
        local e = a.Parent
        if not e then
            return
        end
        if e:IsA("Attachment") and e.Parent then
            e = e.Parent
        end
        if e:IsA("BasePart") then
            return e.Position
        elseif e:IsA("Model") then
            return e:GetPivot().Position
        end
    end
    local function a(e)
        if not P then
            return false
        end
        local x = P.SelectedPetData
        if not x then
            return false
        end
        local Q = e:FindFirstAncestorOfClass("Model")
        if not Q then
            return false
        end
        if x.plot then
            local V = e:FindFirstAncestor(x.plot)
            if not V then
                return false
            end
        end
        if x.slot then
            local V = e:FindFirstAncestor(x.slot)
            if V then
                return true
            end
            if Q.Name == x.slot then
                return true
            end
            if Q.Parent and Q.Parent.Name == x.slot then
                return true
            end
        end
        if x.name then
            local e = string.lower(x.name)
            local x = Q
            while x do
                if x.Name and string.lower(x.Name) == e then
                    return true
                end
                x = x.Parent
            end
        end
        return false
    end
    local function e(x, Q)
        if not x or not x.Parent then
            return false
        end
        if not x.Enabled then
            return false
        end
        local V = r(x)
        if not V then
            return false
        end
        local r = x:FindFirstAncestorOfClass("Model")
        if r then
            local r = workspace:FindFirstChild("Plots")
            if r then
                local i = x:FindFirstAncestorWhichIsA("Model")
                while i and i.Parent ~= r do
                    i = i.Parent
                end
                if i then
                    local r = i:FindFirstChild("PlotSign")
                    if r then
                        local i = r:FindFirstChildWhichIsA("SurfaceGui", true)
                        local r = i and i:FindFirstChildWhichIsA("TextLabel", true)
                        if r then
                            local i = r.Text:lower()
                            if
                                i:find(game.Players.LocalPlayer.Name:lower(), 1, true)
                                or i:find(game.Players.LocalPlayer.DisplayName:lower(), 1, true)
                            then
                                return false
                            end
                        end
                    end
                end
            end
        end
        if _G.NEAREST_INSTANT_MODE == true then
            local r = n(Q)
            local i = n(V)
            if not r or r ~= i then
                return false
            end
        end
        if _G.NEAREST_INSTANT_MODE ~= true then
            if not a(x) then
                return false
            end
        end
        local r = typeof(x.MaxActivationDistance) == "number"
                and x.MaxActivationDistance > 0
                and x.MaxActivationDistance
            or C.RADIUS
        local n = math.min(C.RADIUS, r)
        return (V - Q).Magnitude <= n
    end
    local function r(n, a)
        local x = os.clock()
        local Q = d[n]
        if Q and x - Q < a then
            return false
        end
        d[n] = x
        return true
    end
    local function n(a, x, Q)
        if not a or not a.Parent then
            return
        end
        if not a.Enabled then
            return
        end
        if not r(a, Q) then
            return
        end
        for r = 1, x do
            pcall(function()
                fireproximityprompt(a, 0)
            end)
        end
    end
    local function r(a)
        if R[a] then
            return
        end
        R[a] = true
        local function x()
            local Q = J()
            if not Q then
                return
            end
            local V = Q.Position
            if e(a, V) then
                C.AUTO_STEAL = true
                local Q = os.clock()
                local V = f[a]
                if not V or Q - V >= 0.08 then
                    f[a] = Q
                    n(a, 25, 0)
                end
            end
        end
        task.defer(function()
            x()
        end)
        pcall(function()
            a:GetPropertyChangedSignal("Enabled"):Connect(function()
                if a.Enabled then
                    x()
                end
            end)
        end)
        a.AncestryChanged:Connect(function()
            if not a:IsDescendantOf(workspace) then
                R[a] = nil
                d[a] = nil
                f[a] = nil
            end
        end)
    end
    local function d()
        local f = workspace:FindFirstChild("Plots")
        if not f then
            return
        end
        for a, a in ipairs(f:GetChildren()) do
            local f = a:FindFirstChild("AnimalPodiums")
            if f then
                for a, a in ipairs(f:GetDescendants()) do
                    if a:IsA("ProximityPrompt") then
                        r(a)
                    end
                end
            end
        end
    end
    d()
    workspace.DescendantAdded:Connect(function(d)
        if d:IsA("ProximityPrompt") and d:FindFirstAncestor("AnimalPodiums") then
            r(d)
        end
    end)
    task.spawn(function()
        while task.wait(_G.getSafePollRate()) do
            local r = J()
            if not r then
                C.AUTO_STEAL = false
                continue
            end
            local d = r.Position
            local r = false
            for f in pairs(R) do
                if e(f, d) then
                    r = true
                    if C.AUTO_STEAL then
                        n(f, 3, 0.12)
                    end
                end
            end
            C.AUTO_STEAL = r
        end
    end)
end
local C = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    TweenService = game:GetService("TweenService"),
    HttpService = game:GetService("HttpService"),
    Workspace = game:GetService("Workspace"),
    Lighting = game:GetService("Lighting"),
    GuiService = game:GetService("GuiService"),
    TeleportService = game:GetService("TeleportService"),
}
local r = C.Players
local R = C.RunService
local d = C.UserInputService
local n = C.ReplicatedStorage
local f = C.TweenService
local J = C.HttpService
local a = C.Workspace
local e = C.Lighting
local e = C.GuiService
local e = C.TeleportService
local C = r.LocalPlayer
local x = C:WaitForChild("PlayerGui")
local Q
Q = setmetatable({}, {
    __index = function(V, V)
        local i = n.Packages.Net
        local O, U
        if V:sub(1, 3) == "RE/" then
            O = "RE/"
            U = V:sub(4)
        elseif V:sub(1, 3) == "RF/" then
            O = "RF/"
            U = V:sub(4)
        else
            return nil
        end
        local O
        for U, y in i:GetChildren() do
            if y.Name == V then
                O = i:GetChildren()[U + 1]
                break
            end
        end
        if O and not rawget(Q, V) then
            rawset(Q, V, O)
        end
        return rawget(Q, V)
    end,
})
local V = {}
function V:LarpNet(V)
    return Q[V]
end
local Q = a.CurrentCamera
local V = C:GetMouse()
local function V()
    return d.TouchEnabled and not d.KeyboardEnabled and not d.MouseEnabled
end
local d = V()
local V = {
    Positions = {
        AdminPanel = { X = 0.1859375, Y = 0.5767123526556385, OffsetX = 0, OffsetY = 0 },
        StealSpeed = { X = 0.02, Y = 0.18 },
        Settings = { X = 0.5, Y = 0.5, OffsetX = 0, OffsetY = 0 },
        InvisPanel = { X = 0.8578125, Y = 0.17260276361454258, OffsetX = 0, OffsetY = 0 },
        AutoSteal = { X = 0.02, Y = 0.35, OffsetX = 0, OffsetY = 0 },
        MobileControls = { X = 0.9, Y = 0.4 },
        MobileBtn_TP = { X = 0.5, Y = 0.4 },
        MobileBtn_CL = { X = 0.5, Y = 0.4 },
        MobileBtn_SP = { X = 0.5, Y = 0.4 },
        MobileBtn_IV = { X = 0.5, Y = 0.4 },
        MobileBtn_UI = { X = 0.5, Y = 0.4 },
        MobileBtn_KICK = { X = 0.5, Y = 0.4 },
        JobJoiner = { X = 0.5, Y = 0.85 },
        TargetControls = { X = 0.26, Y = 0.35, OffsetX = 0, OffsetY = 0 },
    },
    TpSettings = {
        Tool = "Flying Carpet",
        Speed = 2,
        TpKey = "T",
        CloneKey = "V",
        TpOnLoad = false,
        MinGenForTp = "",
        CarpetSpeedKey = "Q",
        InfiniteJump = false,
        TeleportV2 = false,
    },
    StealSpeed = 20,
    ShowStealSpeedPanel = true,
    CarpetSpeed = false,
    MenuKey = "LeftControl",
    MobileGuiScale = 0.85,
    AntiRagdoll = 0,
    AntiRagdollV2 = false,
    FPSBoost = false,
    FPSBoostV2 = false,
    DropBrainrotKey = "R",
    GameStretch = false,
    gameStretchFactor = 0.75,
    cameraFOV = 70,
    TracerEnabled = true,
    BrainrotESP = true,
    Float = false,
    FloatKeybind = "Z",
    LineToBase = false,
    StealNearest = false,
    StealHighest = true,
    StealPriority = false,
    DefaultToNearest = false,
    DefaultToHighest = false,
    DefaultToPriority = false,
    UILocked = false,
    HideAdminPanel = false,
    HideAutoSteal = false,
    CompactAutoSteal = false,
    AutoKickOnSteal = false,
    InstantSteal = false,
    InvisStealAngle = 233,
    SinkSliderValue = 5,
    AutoRecoverLagback = true,
    AutoInvisDuringSteal = false,
    InvisToggleKey = "I",
    ClickToAP = false,
    ClickToAPKeybind = "L",
    DisableClickToAPOnMoby = false,
    ProximityAP = false,
    ProximityAPKeybind = "P",
    ProximityRange = 15,
    StealSpeedKey = "C",
    ShowInvisPanel = true,
    ResetKey = "X",
    AutoResetOnBalloon = false,
    AntiBeeDisco = false,
    AutoDestroyTurrets = false,
    FOV = 70,
    SubspaceMineESP = false,
    AutoUnlockOnSteal = false,
    ShowUnlockButtonsHUD = false,
    AutoTPOnFailedSteal = false,
    AutoKickOnSteal = false,
    AutoTPPriority = true,
    KickKey = "",
    CleanErrorGUIs = false,
    ClickToAPSingleCommand = false,
    RagdollSelfKey = "B",
    AlertsEnabled = true,
    AlertSoundID = "rbxassetid://6518811702",
    DisableProximitySpamOnMoby = false,
    CancelAPPanelOnMoby = true,
    DisableClickToAPOnKawaifu = false,
    DisableProximitySpamOnKawaifu = false,
    CancelAPPanelOnKawaifu = true,
    AutoStealSpeed = false,
    ShowJobJoiner = false,
    ShowMobileActionButtons = true,
    JobJoinerKey = "J",
    PriorityList = {
        "Strawberry Elephant",
        "Meowl",
        "Skibidi Toilet",
        "Headless Horseman",
        "Dragon Gingerini",
        "Dragon Cannelloni",
        "Ketupat Bros",
        "Hydra Dragon Cannelloni",
        "La Supreme Combinasion",
        "Love Love Bear",
        "Ginger Gerat",
        "Cerberus",
        "Capitano Moby",
        "La Casa Boo",
        "Burguro and Fryuro",
        "Spooky and Pumpky",
        "Cooki and Milki",
        "Rosey and Teddy",
        "Popcuru and Fizzuru",
        "Reinito Sleighito",
        "Fragrama and Chocrama",
        "Garama and Madundung",
        "Ketchuru and Musturu",
        "La Secret Combinasion",
        "Tralaledon",
        "Tictac Sahur",
        "Ketupat Kepat",
        "Tang Tang Keletang",
        "Orcaledon",
        "La Ginger Sekolah",
        "Los Spaghettis",
        "Lavadorito Spinito",
        "Swaggy Bros",
        "La Taco Combinasion",
        "Los Primos",
        "Chillin Chili",
        "Tuff Toucan",
        "W or L",
        "Chillin Chili",
        "Chipso and Queso",
    },
}
function DeepCopy(i)
    if type(i) ~= "table" then
        return i
    end
    local O = {}
    for U, y in pairs(i) do
        O[U] = DeepCopy(y)
    end
    return O
end
function MergeDefaults(i, O)
    for U, y in pairs(O) do
        if type(y) == "table" then
            if type(i[U]) ~= "table" then
                i[U] = DeepCopy(y)
            else
                MergeDefaults(i[U], y)
            end
        elseif i[U] == nil then
            i[U] = y
        end
    end
end
local i = DeepCopy(V)
function NormalizeKeyName(O, U)
    if type(O) ~= "string" or O == "" then
        return U
    end
    local y = {
        ALT = "LeftAlt",
        LALT = "LeftAlt",
        RALT = "RightAlt",
        CTRL = "LeftControl",
        CONTROL = "LeftControl",
        LCTRL = "LeftControl",
        RCTRL = "RightControl",
        SHIFT = "LeftShift",
        LSHIFT = "LeftShift",
        RSHIFT = "RightShift",
        WIN = "LeftSuper",
        CMD = "LeftSuper",
        META = "LeftSuper",
    }
    local K = string.upper(O)
    local q = y[K] or O
    return Enum.KeyCode[q] and q or U
end
function PrettyKeyName(O)
    local U = {
        LeftAlt = "ALT",
        RightAlt = "RALT",
        LeftControl = "CTRL",
        RightControl = "RCTRL",
        LeftShift = "SHIFT",
        RightShift = "RSHIFT",
        LeftSuper = "WIN",
        RightSuper = "RWIN",
    }
    return U[O] or tostring(O or "")
end
if isfile and isfile("cKHub.json") then
    pcall(function()
        local O = readfile("cKHub.json")
        if not O or O == "" then
            return
        end
        local U = J:JSONDecode(O)
        if type(U) ~= "table" then
            return
        end
        local O = nil
        if type(U.PriorityList) == "table" then
            O = DeepCopy(U.PriorityList)
        end
        MergeDefaults(U, V)
        if O ~= nil then
            U.PriorityList = O
        end
        i = U
    end)
end
i.ProximityAP = false
if i.Positions then
    i.Positions.Settings = { X = 0.5, Y = 0.5, OffsetX = 0, OffsetY = 0 }
end
if type(i.CancelAPPanelOnMoby) ~= "boolean" then
    i.CancelAPPanelOnMoby = true
end
if type(i.CancelAPPanelOnKawaifu) ~= "boolean" then
    i.CancelAPPanelOnKawaifu = true
end
function EnsureSavedKeybinds()
    i.SavedKeybinds = i.SavedKeybinds or {}
    i.SavedKeybinds.MenuKey =
        NormalizeKeyName(i.SavedKeybinds.MenuKey or i.MenuKey, V.MenuKey or "LeftControl")
    i.SavedKeybinds.ClickToAPKeybind =
        NormalizeKeyName(i.SavedKeybinds.ClickToAPKeybind or i.ClickToAPKeybind, V.ClickToAPKeybind or "L")
    i.SavedKeybinds.ProximityAPKeybind = NormalizeKeyName(
        i.SavedKeybinds.ProximityAPKeybind or i.ProximityAPKeybind,
        V.ProximityAPKeybind or "P"
    )
    i.SavedKeybinds.StealSpeedKey =
        NormalizeKeyName(i.SavedKeybinds.StealSpeedKey or i.StealSpeedKey, V.StealSpeedKey or "C")
    i.SavedKeybinds.FloatKeybind =
        NormalizeKeyName(i.SavedKeybinds.FloatKeybind or i.FloatKeybind, V.FloatKeybind or "Z")
    i.SavedKeybinds.ResetKey = NormalizeKeyName(i.SavedKeybinds.ResetKey or i.ResetKey, V.ResetKey or "X")
    i.SavedKeybinds.JobJoinerKey =
        NormalizeKeyName(i.SavedKeybinds.JobJoinerKey or i.JobJoinerKey, V.JobJoinerKey or "J")
    i.SavedKeybinds.InvisToggleKey =
        NormalizeKeyName(i.SavedKeybinds.InvisToggleKey or i.InvisToggleKey, V.InvisToggleKey or "I")
    i.SavedKeybinds.KickKey = NormalizeKeyName(i.SavedKeybinds.KickKey or i.KickKey, "")
    i.SavedKeybinds.RagdollSelfKey = NormalizeKeyName(i.SavedKeybinds.RagdollSelfKey or i.RagdollSelfKey, "B")
    i.SavedKeybinds.TpKey =
        NormalizeKeyName(i.SavedKeybinds.TpKey or i.TpSettings.TpKey, V.TpSettings.TpKey or "T")
    i.SavedKeybinds.CloneKey =
        NormalizeKeyName(i.SavedKeybinds.CloneKey or i.TpSettings.CloneKey, V.TpSettings.CloneKey or "V")
    i.SavedKeybinds.CarpetSpeedKey = NormalizeKeyName(
        i.SavedKeybinds.CarpetSpeedKey or i.TpSettings.CarpetSpeedKey,
        V.TpSettings.CarpetSpeedKey or "Q"
    )
end
function ApplySavedKeybindsToConfig()
    EnsureSavedKeybinds()
    i.MenuKey = i.SavedKeybinds.MenuKey
    i.ClickToAPKeybind = i.SavedKeybinds.ClickToAPKeybind
    i.ProximityAPKeybind = i.SavedKeybinds.ProximityAPKeybind
    i.StealSpeedKey = i.SavedKeybinds.StealSpeedKey
    i.FloatKeybind = i.SavedKeybinds.FloatKeybind
    i.ResetKey = i.SavedKeybinds.ResetKey
    i.JobJoinerKey = i.SavedKeybinds.JobJoinerKey
    i.InvisToggleKey = i.SavedKeybinds.InvisToggleKey
    i.KickKey = i.SavedKeybinds.KickKey
    i.RagdollSelfKey = i.SavedKeybinds.RagdollSelfKey
    i.TpSettings.TpKey = i.SavedKeybinds.TpKey
    i.TpSettings.CloneKey = i.SavedKeybinds.CloneKey
    i.TpSettings.CarpetSpeedKey = i.SavedKeybinds.CarpetSpeedKey
end
local function O(U)
    local y = { [1] = 0.1, [2] = 0.2, [3] = 0.3, [4] = 0.4 }
    return y[tonumber(U)] or 0.1
end
function NormalizeAllKeybinds()
i.UILocked = false
    EnsureSavedKeybinds()
    ApplySavedKeybindsToConfig()
end
NormalizeAllKeybinds()

-- FPS CAP / SYNAPSE COMPATIBILITY
-- Some executors interpret setfpscap(0) as 60/default instead of "unlimited".
-- Use a very high cap and periodically re-apply it in case the executor/game resets it.
local function CKUnlockFPS()
    pcall(function()
        local cap =
            rawget(getgenv and getgenv() or _G, "setfpscap")
            or rawget(_G, "setfpscap")
            or setfpscap
        if type(cap) == "function" then
            cap(1000)
        end
    end)
end

CKUnlockFPS()
task.spawn(function()
    while task.wait(3) do
        CKUnlockFPS()
    end
end)

local function U()
    if writefile then
        pcall(function()
            NormalizeAllKeybinds()
            local y = DeepCopy(i)
            y.ProximityAP = false
            y.MenuKey = i.SavedKeybinds.MenuKey
            y.ClickToAPKeybind = i.SavedKeybinds.ClickToAPKeybind
            y.ProximityAPKeybind = i.SavedKeybinds.ProximityAPKeybind
            y.StealSpeedKey = i.SavedKeybinds.StealSpeedKey
            y.FloatKeybind = i.SavedKeybinds.FloatKeybind
            y.ResetKey = i.SavedKeybinds.ResetKey
            y.JobJoinerKey = i.SavedKeybinds.JobJoinerKey
            y.InvisToggleKey = i.SavedKeybinds.InvisToggleKey
            y.KickKey = i.SavedKeybinds.KickKey
            y.RagdollSelfKey = i.SavedKeybinds.RagdollSelfKey
            y.TpSettings.TpKey = i.SavedKeybinds.TpKey
            y.TpSettings.CloneKey = i.SavedKeybinds.CloneKey
            y.TpSettings.CarpetSpeedKey = i.SavedKeybinds.CarpetSpeedKey
            writefile("cKHub.json", J:JSONEncode(y))
        end)
    end
end
if _needMigrationSave then
    U()
end
-- Периодический автосейв: все включённые функции сохраняются в конфиг,
-- даже если их тумблер не вызывает U() напрямую.
task.spawn(function()
    while true do
        task.wait(5)
        pcall(U)
    end
end)
local function y(K)
    if not K or not K.Character then
        return false
    end
    return K.Character:FindFirstChild("_moby_highlight") ~= nil
end
local function K(q)
    if not q or not q.Character then
        return false
    end
    return q.Character:FindFirstChild("KaWaifu_NeonHighlight") ~= nil
end
-- ===================== AUTO KICK (HEADLESS TP) =====================
do
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local fired = false
    local wasOn = false
    local function doAutoKick()
        if fired then return end
        fired = true
        pcall(function() LocalPlayer:Kick("discord.gg/usYtFqxQdN") end)
    end
    local function isText(g) return g:IsA("TextLabel") or g:IsA("TextButton") end
    local function check(g)
        if fired or i.AutoKickOnSteal ~= true then return end
        local txt = g.Text
        if type(txt) == "string" and string.find(txt, "You stole", 1, true) then
            doAutoKick()
        end
    end
    local function hook(g, runCheck)
        if not isText(g) then return end
        if runCheck then check(g) end
        pcall(function()
            g:GetPropertyChangedSignal("Text"):Connect(function() check(g) end)
        end)
    end
    task.spawn(function()
        local pgui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 15)
        if not pgui then return end
        if _G.__HTP_KickConn then pcall(function() _G.__HTP_KickConn:Disconnect() end) end
        for _, g in ipairs(pgui:GetDescendants()) do hook(g, false) end
        _G.__HTP_KickConn = pgui.DescendantAdded:Connect(function(g) hook(g, true) end)
    end)
    task.spawn(function()
        while true do
            task.wait(0.25)
            local on = i.AutoKickOnSteal == true
            if on and not wasOn then fired = false end
            wasOn = on
        end
    end)
end
-- =================== END AUTO KICK ===================
_G.InvisStealAngle = i.InvisStealAngle
_G.SinkSliderValue = i.SinkSliderValue
_G.AutoRecoverLagback = i.AutoRecoverLagback
_G.AutoInvisDuringSteal = i.AutoInvisDuringSteal
_G.INVISIBLE_STEAL_KEY = Enum.KeyCode[i.InvisToggleKey] or Enum.KeyCode.I
_G.invisibleStealEnabled = false
_G.RecoveryInProgress = false
local function q()
    local c = C:WaitForChild("PlayerScripts")
    local z = require(c:WaitForChild("PlayerModule"))
    return z:GetControls()
end
local c = q()
local function c()
    local z = pcall(function()
        game:Shutdown()
    end)
    if z then
        return
    end
    pcall(function()
        C:Kick("")
    end)
end
local function z(B)
    local o = C.Character
    local Y = o:FindFirstChild("Humanoid")
    local T = o:FindFirstChild("HumanoidRootPart")
    local o = q()
    local q = T.CFrame.LookVector
    o:Disable()
    local T = os.clock()
    local I
    I = R.RenderStepped:Connect(function()
        if os.clock() - T >= B then
            I:Disconnect()
            Y:Move(Vector3.zero, false)
            o:Enable()
            return
        end
        Y:Move(q, false)
    end)
end
local function q()
    local B = game:GetService("Players")
    local o = B.LocalPlayer
    if not o then
        return
    end
    local B = o.Character or o.CharacterAdded:Wait()
    local Y = B:FindFirstChildOfClass("Humanoid")
    if not Y then
        return
    end
    local T = o.Backpack:FindFirstChild("Quantum Cloner") or B:FindFirstChild("Quantum Cloner")
    if not T then
        return
    end
    if T.Parent ~= B then
        Y:EquipTool(T)
        task.wait()
    end
    local B = o:WaitForChild("PlayerGui")
    local o = B:FindFirstChild("ToolsFrames")
    local B = o and o:FindFirstChild("QuantumCloner")
    local o = B and B:FindFirstChild("TeleportToClone")
    if not o then
        return
    end
    T:Activate()
    task.wait(0.05)
    o.Visible = true
    if typeof(firesignal) == "function" then
        firesignal(o.MouseButton1Up)
        if _G.triggerSafePollBoost then
            _G.triggerSafePollBoost()
        end
    end
end
local function B(o)
    local Y = 0
    while Y < o do
        Y += R.Heartbeat:Wait()
    end
end
local function o(Y, T)
    local I = 0
    while true do
        if Y() then
            return true
        end
        local Y = R.Heartbeat:Wait()
        I += Y
        if T and I >= T then
            return false
        end
    end
end
local function Y(T)
    if not T or not T:IsA("BasePart") then
        return nil
    end
    local I = nil
    local p = math.huge
    for j, j in ipairs(a:GetDescendants()) do
        if j:IsA("TextLabel") then
            local l = tostring(j.Text or "")
            if l ~= "" and l:lower():find("base", 1, true) then
                local l = j:FindFirstAncestorWhichIsA("SurfaceGui")
                if l then
                    local j = l.Adornee or l.Parent
                    if j and j:IsA("BasePart") then
                        local l = (j.Position - T.Position).Magnitude
                        if l < p then
                            p = l
                            I = j
                        end
                    end
                end
            end
        end
    end
    return I
end
local function T(I, p)
    if not I then
        return
    end
    local j = os.clock()
    while I.Parent and I.Position.Y < p do
        local l = p - I.Position.Y
        local p = math.clamp(l * 20, 280, 310)
        I.Velocity = Vector3.new(I.Velocity.X, p, I.Velocity.Z)
        if os.clock() - j > 3 then
            break
        end
        R.Heartbeat:Wait()
    end
    I.Velocity = Vector3.new(I.Velocity.X, 0, I.Velocity.Z)
end
local function I(p)
    if not p then
        return nil
    end
    local j = p.Parent
    local l = i.TpSettings.Tool or "Flying Carpet"
    local W = C.Backpack:FindFirstChild(l) or j and j:FindFirstChild(l)
    if W then
        if W.Parent ~= j then
            p:EquipTool(W)
        else
            p:EquipTool(W)
        end
        task.wait(0.02)
    end
    return W
end
local function p(j, l)
    if not j or not l then
        return
    end
    local l = j.Parent
    local j = i.TpSettings.Tool or "Flying Carpet"
    local W = C.Backpack:FindFirstChild(j) or l and l:FindFirstChild(j)
    if not W then
        return
    end
end
local j = game:GetService("UserInputService")
local l = {
    { name = "MED1", pos = Vector3.new(-410.65, -5.68, -46.1) },
    { name = "MED2", pos = Vector3.new(-410.91, -5.68, 168.89) },
}
local W = {
    { name = "TP1", pos = Vector3.new(-488.88, 15, 196.38), facing = "back" },
    { name = "TP2", pos = Vector3.new(-487.79, 15, 138.13), facing = "front" },
    { name = "TP3", pos = Vector3.new(-489.38, 15, 89.23), facing = "back" },
    { name = "TP4", pos = Vector3.new(-489.69, 15, 30.98), facing = "front" },
    { name = "TP5", pos = Vector3.new(-488.75, 15, -17.95), facing = "back" },
    { name = "TP6", pos = Vector3.new(-490.0, 15, -75.9), facing = "front" },
    { name = "TP7", pos = Vector3.new(-331.75, 15, -75.8), facing = "back" },
    { name = "TP8", pos = Vector3.new(-329.98, 15, -18.16), facing = "front" },
    { name = "TP9", pos = Vector3.new(-330.04, 15, 31.14), facing = "back" },
    { name = "TP10", pos = Vector3.new(-331.28, 15, 88.92), facing = "front" },
    { name = "TP11", pos = Vector3.new(-330.57, 15, 138.1), facing = "back" },
    { name = "TP12", pos = Vector3.new(-330.01, 15, 195.96), facing = "front" },
}
local W = {
    Background = Color3.fromRGB(14, 6, 12),
    Surface = Color3.fromRGB(28, 12, 22),
    SurfaceHighlight = Color3.fromRGB(22, 10, 18),
    Accent1 = Color3.fromRGB(255, 105, 180),
    Accent2 = Color3.fromRGB(255, 20, 147),
    TextPrimary = Color3.fromRGB(255, 240, 250),
    TextSecondary = Color3.fromRGB(160, 100, 140),
    Success = Color3.fromRGB(255, 105, 180),
    Error = Color3.fromRGB(255, 105, 180),
}
local X = {}
local function t()
    for v = #X, 1, -1.0 do
        X[v] = nil
    end
    for v, M in ipairs(i.PriorityList or {}) do
        X[v] = M
    end
end
local function v()
    i.PriorityList = {}
    for M, w in ipairs(X) do
        i.PriorityList[M] = w
    end
end
t()
local function M(w)
    if not w then
        return nil
    end
    local b = a:FindFirstChild("Plots") and a.Plots:FindFirstChild(w.plot)
    if b then
        local D = b:FindFirstChild("AnimalPodiums")
        if D then
            local b = D:FindFirstChild(w.slot)
            if b then
                local w = b:FindFirstChild("Base")
                if w then
                    local b = w:FindFirstChild("Spawn")
                    if b then
                        return b
                    end
                    return w:FindFirstChildWhichIsA("BasePart") or w
                end
            end
        end
    end
    return nil
end
local function _htpMobileScale()
    local s = tonumber(i.MobileGuiScale)
    if not s or s == 0.5 then s = 0.85 end
    return math.clamp(s, 0.4, 1.2)
end
local function w(b)
    if not b then
        return
    end
    if not d then
        return
    end
    local D = b:FindFirstChildOfClass("UIScale")
    if D then
        D:Destroy()
    end
    local D = Instance.new("UIScale")
    D.Parent = b
    P.MobileScaleObjects[b] = D
    if P.RefreshMobileScale then
        P.RefreshMobileScale()
    else
        D.Scale = _htpMobileScale()
    end
end
P.RefreshMobileScale = function()
    local b = _htpMobileScale()
    for D, F in pairs(P.MobileScaleObjects) do
        if D and D.Parent and F and F.Parent == D then
            F.Scale = b
        else
            P.MobileScaleObjects[D] = nil
        end
    end
end
local function b(D, F)
    if not D or not D.Parent then
        return
    end
    local E = D.Parent
    -- Prefer a header frame; otherwise use the panel itself
    local header = D:FindFirstChildWhichIsA("Frame") or D
    local A = Instance.new("TextButton")
    A.Name = "MinimizeBtn"
    A.Size = UDim2.new(0, 22, 0, 22)
    A.Position = UDim2.new(1, -26, 0, 6)
    A.BackgroundColor3 = Color3.fromRGB(28, 12, 22)
    A.Text = "-"
    A.Font = Enum.Font.GothamBlack
    A.TextSize = 18
    A.TextColor3 = Color3.fromRGB(255, 240, 250)
    A.AutoButtonColor = false
    A.ZIndex = 200
    A.Parent = header
    local ac = Instance.new("UICorner", A)
    ac.CornerRadius = UDim.new(0, 10)
    local as = Instance.new("UIStroke", A)
    as.Color = Color3.fromRGB(255, 105, 180)
    as.Thickness = 1
    as.Transparency = 0.3
    local openBtn = Instance.new("TextButton")
    openBtn.Name = "RestoreBtn"
    openBtn.Size = UDim2.new(0, 100, 0, 28)
    openBtn.Position = UDim2.new(0, 10, 1, -42)
    openBtn.BackgroundColor3 = Color3.fromRGB(28, 12, 22)
    openBtn.Text = F or "OPEN"
    openBtn.Font = Enum.Font.GothamBold
    openBtn.TextSize = 12
    openBtn.TextColor3 = Color3.fromRGB(255, 240, 250)
    openBtn.Visible = false
    openBtn.AutoButtonColor = false
    openBtn.ZIndex = 200
    openBtn.Parent = E
    local oc = Instance.new("UICorner", openBtn)
    oc.CornerRadius = UDim.new(0, 10)
    local os_ = Instance.new("UIStroke", openBtn)
    os_.Color = Color3.fromRGB(255, 105, 180)
    os_.Thickness = 1.2
    os_.Transparency = 0.25
    if MakeDraggable then
        pcall(MakeDraggable, openBtn, openBtn)
    end
    A.MouseButton1Click:Connect(function()
        D.Visible = false
        openBtn.Visible = true
    end)
    openBtn.MouseButton1Click:Connect(function()
        D.Visible = true
        openBtn.Visible = false
    end)
end
local function D(F, E, m)
    local A, H, _, Z
    F.Active = true
    F.InputBegan:Connect(function(k)
        if false and i.UILocked then
            return
        end
        if _G.ADMIN_PANEL_SLIDER_DRAG then
            return
        end
        if
            k.UserInputType == Enum.UserInputType.MouseButton1
            or k.UserInputType == Enum.UserInputType.Touch
        then
            A = true
            _ = k.Position
            Z = E.Position
            k.Changed:Connect(function()
                if k.UserInputState == Enum.UserInputState.End then
                    A = false
                    if m then
                        i.Positions[m] = {
                            X = E.Position.X.Scale,
                            Y = E.Position.Y.Scale,
                            OffsetX = E.Position.X.Offset,
                            OffsetY = E.Position.Y.Offset,
                        }
                        U()
                    end
                end
            end)
        end
    end)
    F.InputChanged:Connect(function(inp)
        if
            inp.UserInputType == Enum.UserInputType.MouseMovement
            or inp.UserInputType == Enum.UserInputType.Touch
        then
            H = inp
        end
    end)
    j.InputChanged:Connect(function(inp)
        if _G.ADMIN_PANEL_SLIDER_DRAG then
            return
        end
        if A and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local delta = inp.Position - _
            E.Position = UDim2.new(Z.X.Scale, Z.X.Offset + delta.X, Z.Y.Scale, Z.Y.Offset + delta.Y)
        end
    end)
    j.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if A then
                A = false
                if m then
                    i.Positions[m] = {
                        X = E.Position.X.Scale,
                        Y = E.Position.Y.Scale,
                        OffsetX = E.Position.X.Offset,
                        OffsetY = E.Position.Y.Offset,
                    }
                    U()
                end
            end
        end
    end)
end
local function F(E, m)
    local A = x:FindFirstChild("lMWjwEoSnCPj")
    if A then
        A:Destroy()
    end
    local A = Instance.new("ScreenGui", x)
    A.Name = "lMWjwEoSnCPj"
    A.ResetOnSpawn = false
    local H = Instance.new("Frame", A)
    H.Size = UDim2.new(0, 290, 0, 54)
    H.Position = UDim2.new(0.5, -145.0, 0, 80)
    H.BackgroundColor3 = Color3.fromRGB(14, 6, 12)
    H.BackgroundTransparency = 1
    H.BorderSizePixel = 0
    Instance.new("UICorner", H).CornerRadius = UDim.new(0, 10)
    local _ = Instance.new("UIStroke", H)
    _.Thickness = 1
    _.Color = W.Accent2
    _.Transparency = 1
    local Z = Instance.new("Frame", H)
    Z.Size = UDim2.new(0, 3, 1, -12.0)
    Z.Position = UDim2.new(0, 5, 0, 6)
    Z.BackgroundColor3 = W.Accent1
    Z.BorderSizePixel = 0
    Z.BackgroundTransparency = 1
    Instance.new("UICorner", Z).CornerRadius = UDim.new(0, 10)
    local k = Instance.new("TextLabel", H)
    k.Size = UDim2.new(1, -22.0, 0, 18)
    k.Position = UDim2.new(0, 16, 0, 7)
    k.BackgroundTransparency = 1
    k.Text = E:upper()
    k.Font = Enum.Font.GothamBlack
    k.TextSize = 11
    k.TextColor3 = W.Accent1
    k.TextXAlignment = Enum.TextXAlignment.Left
    k.TextTransparency = 1
    local E = Instance.new("TextLabel", H)
    E.Size = UDim2.new(1, -22.0, 0, 15)
    E.Position = UDim2.new(0, 16, 0, 27)
    E.BackgroundTransparency = 1
    E.Text = m
    E.Font = Enum.Font.GothamMedium
    E.TextSize = 10
    E.TextColor3 = W.TextSecondary
    E.TextXAlignment = Enum.TextXAlignment.Left
    E.TextTransparency = 1
    local m = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    f:Create(H, m, { BackgroundTransparency = 0.08 }):Play()
    f:Create(_, m, { Transparency = 0.3 }):Play()
    f:Create(Z, m, { BackgroundTransparency = 0 }):Play()
    f:Create(k, m, { TextTransparency = 0 }):Play()
    f:Create(E, m, { TextTransparency = 0 }):Play()
    task.delay(2, function()
        if not A.Parent then
            return
        end
        local m = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        f:Create(H, m, { BackgroundTransparency = 1 }):Play()
        f:Create(_, m, { Transparency = 1 }):Play()
        f:Create(Z, m, { BackgroundTransparency = 1 }):Play()
        f:Create(k, m, { TextTransparency = 1 }):Play()
        local H = f:Create(E, m, { TextTransparency = 1 })
        H:Play()
        H.Completed:Wait()
        if A.Parent then
            A:Destroy()
        end
    end)
end
task.spawn(function()
    local S = n:WaitForChild("Packages")
    local CG = n:WaitForChild("Datas")
    local rG = n:WaitForChild("Shared")
    local rG = n:WaitForChild("Utils")
    local rG = require(S:WaitForChild("Synchronizer"))
    local function S(dG)
        if not dG then
            return false
        end
        if typeof(dG) == "Instance" then
            return dG == C
        end
        if type(dG) == "string" then
            return dG == C.Name
        end
        return false
    end
    local function dG(nG)
        local fG, JG = pcall(function()
            local aG = getthreadidentity and getthreadidentity() or nil
            if setthreadidentity then
                setthreadidentity(8)
            end
            local eG = rG:GetTableFromChannel(nG)
            if aG and setthreadidentity then
                pcall(setthreadidentity, aG)
            end
            return eG
        end)
        if fG and type(JG) == "table" then
            return JG
        end
        return nil
    end
    local rG = require(CG:WaitForChild("Animals"))
    local nG = require(CG:WaitForChild("Mutations"))
    local fG = require(CG:WaitForChild("Traits"))
    local CG = {
        "",
        "K",
        "M",
        "B",
        "T",
        "Qa",
        "Qi",
        "Sx",
        "Sp",
        "Oc",
        "No",
        "Dc",
        "Ud",
        "Dd",
        "Td",
        "Qad",
        "Qid",
        "Sxd",
        "Spd",
        "Ocd",
        "Nod",
        "Vg",
        "Uvg",
        "Dvg",
        "Tvg",
    }
    local function JG(aG, eG)
        eG = eG or 1
        local xG = math.abs(aG)
        local QG = math.max(1, xG)
        local xG = math.floor(math.log(QG, 1000))
        local QG = CG[xG + 1] or "e+" .. xG
        local CG = aG * (10 ^ eG / 1000 ^ xG)
        local aG = math.floor(CG) / 10 ^ eG
        return (("%." .. eG .. "f"):format(aG)):gsub("%.?0+$", "") .. QG
    end
    local function CG(aG, eG, xG)
        local QG = rG[aG]
        if not QG then
            return 0
        end
        local aG = QG.Generation or QG.Price * 0.1
        local QG = 1
        if eG and eG ~= "None" then
            local VG = nG[eG]
            if VG and VG.Modifier then
                QG = QG + VG.Modifier
            end
        end
        local nG = false
        if type(xG) == "table" then
            for eG, eG in ipairs(xG) do
                if eG == "Sleepy" then
                    nG = true
                else
                    local xG = fG[eG]
                    if xG and xG.MultiplierModifier then
                        QG = QG + xG.MultiplierModifier
                    end
                end
            end
        end
        local fG = math.round(aG * QG)
        if nG then
            fG = math.round(fG * 0.5)
        end
        return fG
    end
    local nG = true
    -- при инжекте ВСЕГДА включаем NEAREST + INSTANT STEAL
    i.DefaultToNearest = true
    i.DefaultToHighest = false
    i.DefaultToPriority = false
    i.StealNearest = true
    i.StealHighest = false
    i.StealPriority = false
    i.InstantSteal = true
    if i.DefaultToPriority and i.DefaultToHighest then
        i.DefaultToHighest = false
    end
    if i.DefaultToPriority and i.DefaultToNearest then
        i.DefaultToNearest = false
    end
    if i.DefaultToHighest and i.DefaultToNearest then
        i.DefaultToNearest = false
    end
    if not i.DefaultToPriority and not i.DefaultToHighest and not i.DefaultToNearest then
        i.DefaultToHighest = true
    end
    local fG = false
    local aG = false
    local eG = false
    if i.DefaultToNearest then
        fG = true
        i.StealNearest = true
        i.StealHighest = false
        i.StealPriority = false
        i.AutoTPPriority = true
    elseif i.DefaultToHighest then
        aG = true
        i.StealHighest = true
        i.StealNearest = false
        i.StealPriority = false
        i.AutoTPPriority = false
    elseif i.DefaultToPriority then
        eG = true
        i.StealPriority = true
        i.StealNearest = false
        i.StealHighest = false
        i.AutoTPPriority = true
    else
        fG = i.StealNearest
        aG = i.StealHighest
        eG = i.StealPriority
        if i.InstantSteal == nil then
            i.InstantSteal = false
        end
        if i.StealPriority then
            i.AutoTPPriority = true
        elseif i.StealNearest then
            i.AutoTPPriority = true
        elseif i.StealHighest then
            i.AutoTPPriority = false
        end
    end
    local xG = i.InstantSteal == true
    _G.NEAREST_INSTANT_MODE = (i.StealNearest == true and i.InstantSteal == true)
    local cSheetCarpet = i.CarpetSpeed == true
    local fpsBoostOn = i.FPSBoost == true
    local gameStretchOn = i.GameStretch == true
    local QG = false
    local VG = false
    local iG = 1
    local OG = nil
    local UG = nil
    local yG = {}
    local function KG()
        nG = fG == true or aG == true or eG == true
    end
    KG()
    local qG = {}
    local cG = {}
    local zG = nil
    local BG = nil
    local oG = {}
    local function YG(TG)
        if not TG or not TG.plot then
            return false
        end
        local IG = a:FindFirstChild("Plots")
        if not IG then
            return false
        end
        local pG = IG:FindFirstChild(TG.plot)
        if not pG then
            return false
        end
        local TG = dG(pG.Name)
        if TG then
            return S(TG.Owner)
        end
        return false
    end
    local function TG(IG)
        if not IG or IG == "None" then
            return ""
        end
        local pG = ""
        if IG == "Cursed" then
            pG = "<font color='rgb(200,0,0)'>Cur</font><font color='rgb(0,0,0)'>sed</font>"
        elseif IG == "Gold" then
            pG = "<font color='rgb(255,215,0)'>Gold</font>"
        elseif IG == "Diamond" then
            pG = "<font color='rgb(0,255,255)'>Diamond</font>"
        elseif IG == "YinYang" then
            pG = "<font color='rgb(255,255,255)'>Yin</font><font color='rgb(0,0,0)'>Yang</font>"
        elseif IG == "Candy" then
            pG = "<font color='rgb(255,105,180)'>Candy</font>"
        elseif IG == "Divine" then
            pG = "<font color='rgb(255,255,255)'>Divine</font>"
        elseif IG == "Rainbow" then
            local jG = {
                "rgb(255,0,0)",
                "rgb(255,127,0)",
                "rgb(255,255,0)",
                "rgb(0,255,0)",
                "rgb(0,0,255)",
                "rgb(75,0,130)",
                "rgb(148,0,211)",
            }
            for lG = 1, #IG do
                pG = pG .. "<font color='" .. jG[(lG - 1) % #jG + 1] .. "'>" .. IG:sub(lG, lG) .. "</font>"
            end
        elseif IG == "Radioactive" then
            pG = "<font color='rgb(132,255,0)'>Radioactive</font>"
        elseif IG == "Galaxy" then
            pG = "<font color='rgb(170,85,255)'>Galaxy</font>"
        else
            pG = IG
        end
        return "<font weight='800'>" .. pG .. " </font>"
    end
    local function IG(pG)
        if pG == "Gold" then
            return Color3.fromRGB(255, 105, 180)
        elseif pG == "Diamond" then
            return Color3.fromRGB(255, 105, 180)
        elseif pG == "Cursed" then
            return Color3.fromRGB(255, 105, 180)
        elseif pG == "YinYang" then
            return Color3.fromRGB(255, 255, 255)
        elseif pG == "Candy" then
            return Color3.fromRGB(255, 105, 180)
        elseif pG == "Divine" then
            return Color3.fromRGB(255, 255, 255)
        elseif pG == "Rainbow" then
            return Color3.fromRGB(255, 105, 180)
        elseif pG == "Radioactive" then
            return Color3.fromRGB(255, 105, 180)
        elseif pG == "Galaxy" then
            return Color3.fromRGB(255, 105, 180)
        end
        return Color3.fromRGB(255, 105, 180)
    end
    local function pG(jG)
        local lG = jG and jG.petName or "Unknown"
        return lG
    end
    local function jG(lG)
        local WG = lG and lG.mutation
        if WG and WG ~= "None" and WG ~= "" then
            return TG(WG), true
        end
        return "", false
    end
    local function TG()
        local lG = {}
        for WG, WG in ipairs(yG) do
            if WG.genValue >= 1 and not YG(WG) then
                table.insert(
                    lG,
                    {
                        petName = WG.name,
                        mpsText = WG.genText,
                        mpsValue = WG.genValue,
                        owner = WG.owner,
                        plot = WG.plot,
                        slot = WG.slot,
                        uid = WG.uid,
                        mutation = WG.mutation,
                        animalData = WG,
                    }
                )
            end
        end
        return lG
    end
    local lG = gethui and gethui() or game:GetService("CoreGui")
    local WG = Instance.new("ScreenGui")
    WG.Name = "cJPcVLFpwxgI"
    WG.ResetOnSpawn = false
    WG.Parent = lG
    local XG = Instance.new("Frame")
    local tG = d and 0.85 or 1
    local GG = {
        BG = Color3.fromRGB(12, 6, 10),
        SURF = Color3.fromRGB(18, 10, 16),
        SURF2 = Color3.fromRGB(26, 12, 22),
        TEXT = Color3.fromRGB(255, 240, 250),
        DIM = Color3.fromRGB(160, 100, 140),
        AQUA = Color3.fromRGB(255, 105, 180),
        AQUA2 = Color3.fromRGB(255, 20, 147),
        AQUA_STROKE = Color3.fromRGB(255, 105, 180),
    }
    XG.Size = UDim2.new(0, 300, 0, 335)
    XG.Position = UDim2.new(
        i.Positions.AutoSteal.X,
        i.Positions.AutoSteal.OffsetX or 0,
        i.Positions.AutoSteal.Y,
        i.Positions.AutoSteal.OffsetY or 0
    )
    XG.BackgroundColor3 = GG.BG
    XG.BackgroundTransparency = 0
    XG.BorderSizePixel = 0
    XG.ClipsDescendants = true
    XG.Parent = WG
    w(XG)
    b(XG, "AUTO STEAL")
    Instance.new("UICorner", XG).CornerRadius = UDim.new(0, 10)
    local WG = Instance.new("UIStroke", XG)
    WG.Color = GG.AQUA_STROKE
    WG.Thickness = 1.3
    WG.Transparency = 0.25
    local WG = Instance.new("Frame", XG)
    WG.Size = UDim2.new(1, 0, 0, 48)
    WG.BackgroundTransparency = 1
    WG.Active = true
    WG.Selectable = true
    D(WG, XG, "AutoSteal")
    local vG = Instance.new("TextLabel", WG)
    vG.Size = UDim2.new(1, -32.0, 0, 24)
    vG.Position = UDim2.new(0, 16, 0, 10)
    vG.BackgroundTransparency = 1
    vG.Text = "STEAL TARGET"
    vG.Font = Enum.Font.GothamBlack
    vG.TextSize = 20
    vG.TextColor3 = GG.TEXT
    vG.TextXAlignment = Enum.TextXAlignment.Center
    local WG = Instance.new("Frame", XG)
    WG.AnchorPoint = Vector2.new(0.5, 0)
    WG.Position = UDim2.new(0.5, 0, 0, 38)
    WG.Size = UDim2.new(0, 120, 0, 1)
    WG.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    WG.BackgroundTransparency = 0.15
    WG.BorderSizePixel = 0
    local WG = Instance.new("ScrollingFrame", XG)
    WG.Size = UDim2.new(1, -24.0, 0, 253)
    WG.Position = UDim2.new(0, 12, 0, 56)
    WG.BackgroundTransparency = 1
    WG.BorderSizePixel = 0
    WG.ClipsDescendants = true
    WG.ScrollingDirection = Enum.ScrollingDirection.Y
    WG.AutomaticCanvasSize = Enum.AutomaticSize.None
    WG.ScrollBarImageTransparency = 1
    WG.ScrollBarThickness = 0
    WG.CanvasSize = UDim2.new(0, 0, 0, 0)
    local XG = Instance.new("Frame", WG)
    XG.Name = "Holder"
    XG.BackgroundTransparency = 1
    XG.BorderSizePixel = 0
    XG.Position = UDim2.new(0, 0, 0, 0)
    XG.Size = UDim2.new(1, 0, 0, 0)
    XG.ClipsDescendants = false
    local vG = Instance.new("UIListLayout", XG)
    vG.Padding = UDim.new(0, 5)
    vG.SortOrder = Enum.SortOrder.LayoutOrder
    local MG = x:FindFirstChild("bRXgmsaEVfze")
    if MG then
        MG:Destroy()
    end
    local MG = Instance.new("ScreenGui")
    MG.Name = "bRXgmsaEVfze"
    MG.ResetOnSpawn = false
    MG.IgnoreGuiInset = true
    MG.DisplayOrder = 998
    MG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MG.Parent = x
    local wG = {
        PANEL = Color3.fromRGB(10, 4, 8),
        PANEL2 = Color3.fromRGB(26, 12, 22),
        TEXT = Color3.fromRGB(255, 240, 250),
        SUBTEXT = Color3.fromRGB(180, 120, 160),
        STROKE = Color3.fromRGB(255, 105, 180),
        GLOW = Color3.fromRGB(255, 20, 147),
        TRACK = Color3.fromRGB(20, 10, 18),
        TRACK2 = Color3.fromRGB(50, 20, 40),
        FILL1 = Color3.fromRGB(255, 105, 180),
        FILL2 = Color3.fromRGB(255, 20, 147),
        FILLTEXT = Color3.fromRGB(255, 240, 250),
        CAP = Color3.fromRGB(255, 240, 250),
    }
    local bG = Instance.new("Frame", MG)
    bG.Name = "CurrentTargetHUD"
    bG.AnchorPoint = Vector2.new(0.5, 1)
    bG.Size = UDim2.new(0, 190 * tG, 0, 42 * tG)
    bG.Position = UDim2.new(0.5, 0, 1, -218 * tG)
    bG.BackgroundColor3 = wG.PANEL
    bG.BackgroundTransparency = 0.03
    bG.BorderSizePixel = 0
    bG.ZIndex = 70
    Instance.new("UICorner", bG).CornerRadius = UDim.new(0, 10)
    local hudBgGrad = Instance.new("UIGradient", bG)
    hudBgGrad.Rotation = 90
    hudBgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 30, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 10, 22)),
    })
    local hudTop = Instance.new("Frame", bG)
    hudTop.Name = "Highlight"
    hudTop.Size = UDim2.new(1, 0, 0, math.floor(1 * tG))
    hudTop.Position = UDim2.fromOffset(0, 0)
    hudTop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hudTop.BackgroundTransparency = 0.85
    hudTop.BorderSizePixel = 0
    hudTop.ZIndex = 71
    local MG = Instance.new("UIStroke", bG)
    MG.Color = wG.STROKE
    MG.Thickness = 1
    MG.Transparency = 0.3
    local MG = Instance.new("UIStroke", bG)
    MG.Color = wG.GLOW
    MG.Thickness = 3
    MG.Transparency = 0.86
    MG.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local MG = Instance.new("ImageLabel", bG)
    MG.Name = "Shadow"
    MG.AnchorPoint = Vector2.new(0.5, 0.5)
    MG.Position = UDim2.new(0.5, 0, 0.5, 1)
    MG.Size = UDim2.new(1, 20, 1, 20)
    MG.BackgroundTransparency = 1
    MG.Image = "rbxassetid://6014261993"
    MG.ImageColor3 = Color3.new(0, 0, 0)
    MG.ImageTransparency = 0.78
    MG.ScaleType = Enum.ScaleType.Slice
    MG.SliceCenter = Rect.new(49, 49, 450, 450)
    MG.ZIndex = 69
    -- target name (top line)
    local MG = Instance.new("TextLabel", bG)
    MG.Name = "TargetName"
    MG.Size = UDim2.new(1, -16.0 * tG, 0, 13 * tG)
    MG.Position = UDim2.fromOffset(8 * tG, 3 * tG)
    MG.BackgroundTransparency = 1
    MG.Font = Enum.Font.GothamBold
    MG.TextSize = 10 * tG
    MG.TextColor3 = wG.TEXT
    MG.TextXAlignment = Enum.TextXAlignment.Center
    MG.TextTruncate = Enum.TextTruncate.AtEnd
    MG.TextStrokeTransparency = 0.9
    MG.ZIndex = 73
    MG.Text = "No target"
    local DG = Instance.new("Frame", bG)
    DG.Name = "ProgressBg"
    DG.Size = UDim2.new(1, -12.0 * tG, 0, 17 * tG)
    DG.Position = UDim2.fromOffset(6 * tG, 21 * tG)
    DG.BackgroundColor3 = wG.TRACK
    DG.BorderSizePixel = 0
    DG.ZIndex = 72
    Instance.new("UICorner", DG).CornerRadius = UDim.new(0, 10)
    local bG = Instance.new("UIStroke", DG)
    bG.Color = wG.STROKE
    bG.Thickness = 1
    bG.Transparency = 0.62
    local bG = Instance.new("Frame", DG)
    bG.Name = "InnerTrack"
    bG.Size = UDim2.new(1, -3.0 * tG, 1, -3.0 * tG)
    bG.Position = UDim2.fromOffset(2 * tG, 2 * tG)
    bG.BackgroundColor3 = wG.TRACK2
    bG.BackgroundTransparency = 0.3
    bG.BorderSizePixel = 0
    bG.ZIndex = 72
    Instance.new("UICorner", bG).CornerRadius = UDim.new(0, 10)
    local bG = Instance.new("Frame", DG)
    bG.Name = "ProgressFill"
    bG.Size = UDim2.new(0, 0, 1, 0)
    bG.BackgroundColor3 = wG.FILL1
    bG.BorderSizePixel = 0
    bG.ClipsDescendants = true
    bG.ZIndex = 73
    Instance.new("UICorner", bG).CornerRadius = UDim.new(0, 10)
    local hudFillGrad = Instance.new("UIGradient", bG)
    hudFillGrad.Rotation = 0
    hudFillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, wG.FILL1),
        ColorSequenceKeypoint.new(1, wG.FILL2),
    })
    local hudFillStroke = Instance.new("UIStroke", bG)
    hudFillStroke.Color = Color3.fromRGB(255, 105, 180)
    hudFillStroke.Thickness = 1
    hudFillStroke.Transparency = 0.55
    local hudCap = Instance.new("Frame", bG)
    hudCap.Name = "Cap"
    hudCap.AnchorPoint = Vector2.new(1, 0.5)
    hudCap.Size = UDim2.new(0, math.floor(4 * tG), 1, -4.0 * tG)
    hudCap.Position = UDim2.new(1, 0, 0.5, 0)
    hudCap.BackgroundColor3 = wG.CAP
    hudCap.BorderSizePixel = 0
    hudCap.ZIndex = 75
    Instance.new("UICorner", hudCap).CornerRadius = UDim.new(0, 10)
    local FG = Instance.new("TextLabel", DG)
    FG.Name = "Percent"
    FG.Size = UDim2.new(1, 0, 1, 0)
    FG.BackgroundTransparency = 1
    FG.Font = Enum.Font.GothamBold
    FG.TextSize = 11 * tG
    FG.TextColor3 = wG.FILLTEXT
    FG.TextStrokeTransparency = 0.6
    FG.TextXAlignment = Enum.TextXAlignment.Center
    FG.ZIndex = 76
    FG.Text = "0%"
    task.spawn(function()
        local last = 0
        while bG and bG.Parent do
            if tick() - last >= 0.05 then
                last = tick()
                if hudFillGrad then
                    local dur = 1.8
                    local p = (tick() / dur) % 1
                    hudFillGrad.Offset = Vector2.new(p * 1.6, 0)
                end
            end
            task.wait()
        end
    end)
    local wG = bG
    local DG = x:FindFirstChild("kzBUJxAKwhtf")
    if DG then
        DG:Destroy()
    end
    local DG = Instance.new("ScreenGui")
    DG.Name = "kzBUJxAKwhtf"
    DG.ResetOnSpawn = false
    DG.IgnoreGuiInset = true
    DG.DisplayOrder = 999
    DG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    DG.Parent = lG
    local lG = Instance.new("Frame", DG)
    lG.Name = "TargetControlsFrame"
    lG.AutomaticSize = Enum.AutomaticSize.Y
    lG.Size = UDim2.new(0, 240 * (d and 1.25 or 1), 0, 0)
    local tG = i.Positions.TargetControls and i.Positions.TargetControls.X
    local DG = i.Positions.TargetControls and i.Positions.TargetControls.Y
    local EG = i.Positions.TargetControls and i.Positions.TargetControls.OffsetX
    local mG = i.Positions.TargetControls and i.Positions.TargetControls.OffsetY
    if tG == nil or DG == nil then
        tG = i.Positions.AutoSteal.X + 0.24
        DG = i.Positions.AutoSteal.Y
        if tG > 0.76 then
            tG = math.max(0.02, i.Positions.AutoSteal.X - 0.24)
        end
        if DG > 0.72 then
            DG = 0.72
        end
        i.Positions.TargetControls = { X = tG, Y = DG }
    end
    lG.Position = UDim2.new(tG or 0.26, EG or 15, DG or 0.35, mG or 0)
    lG.BackgroundColor3 = Color3.fromRGB(10, 7, 6)
    lG.BackgroundTransparency = 0
    lG.BorderSizePixel = 0
    lG.ClipsDescendants = false
    lG.ZIndex = 100
    lG.Active = true
    w(lG)
    b(lG, "TARGET CONTROLS")
    i.UILocked = false
    -- ensure minimize exists even if earlier call failed
    task.defer(function() if lG and lG.Parent and not lG:FindFirstChild("MinimizeBtn", true) then b(lG, "TARGET CONTROLS") end end)
    local b = {
        BG = Color3.fromRGB(12, 6, 10),
        SURF = Color3.fromRGB(18, 10, 16),
        SURF2 = Color3.fromRGB(26, 12, 22),
        TEXT = Color3.fromRGB(255, 240, 250),
        DIM = Color3.fromRGB(160, 100, 140),
        AQUA = Color3.fromRGB(255, 105, 180),
        AQUA2 = Color3.fromRGB(255, 20, 147),
        AQUA_STROKE = Color3.fromRGB(255, 105, 180),
        GREEN1 = Color3.fromRGB(255, 105, 180),
        GREEN2 = Color3.fromRGB(180, 40, 120),
        GREEN_STROKE = Color3.fromRGB(255, 20, 147),
        OFF_BG = Color3.fromRGB(26, 12, 22),
        OFF_TEXT = Color3.fromRGB(160, 100, 140),
    }
    local function tG(DG, EG)
        local mG = Instance.new("UICorner")
        mG.CornerRadius = UDim.new(0, 10)
        mG.Parent = DG
        return mG
    end
    local function DG(EG, mG, AG, HG)
        local ZG = Instance.new("UIStroke")
        ZG.Color = mG
        ZG.Thickness = AG or 1
        ZG.Transparency = HG or 0
        ZG.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        ZG.Parent = EG
        return ZG
    end
    local function EG(mG, AG, HG, ZG, kG)
        f:Create(
            mG,
            TweenInfo.new(AG or 0.2, ZG or Enum.EasingStyle.Quint, kG or Enum.EasingDirection.Out),
            HG
        ):Play()
    end
    local function mG(AG, HG, ZG, kG)
        local uG = Instance.new("UIGradient")
        uG.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, HG), ColorSequenceKeypoint.new(1, ZG) })
        uG.Rotation = kG or 0
        uG.Parent = AG
        return uG
    end
    tG(lG, 18)
    DG(lG, b.AQUA_STROKE, 1.2, 0.4)

    -- Animated saturated purple iridescent GUI.
    local _ckFlow=Instance.new("UIGradient",lG)
    _ckFlow.Rotation=20
    _ckFlow.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0.00,Color3.fromRGB(80, 20, 60)),
        ColorSequenceKeypoint.new(0.25,Color3.fromRGB(255, 105, 180)),
        ColorSequenceKeypoint.new(0.50,Color3.fromRGB(255, 20, 147)),
        ColorSequenceKeypoint.new(0.75,Color3.fromRGB(255, 105, 180)),
        ColorSequenceKeypoint.new(1.00,Color3.fromRGB(80, 20, 60)),
    })
    task.spawn(function()
        local phase=0
        while lG and lG.Parent do
            phase=(phase+0.004)%1
            _ckFlow.Offset=Vector2.new(phase*2-1,0)
            task.wait(0.02)
        end
    end)

    local AG = Instance.new("ImageLabel")
    AG.Name = "Shadow"
    AG.AnchorPoint = Vector2.new(0.5, 0.5)
    AG.Position = UDim2.new(0.5, 0, 0.5, 2)
    AG.Size = UDim2.new(1, 24, 1, 24)
    AG.BackgroundTransparency = 1
    AG.Image = "rbxassetid://6014261993"
    AG.ImageColor3 = Color3.new(0, 0, 0)
    AG.ImageTransparency = 0.72
    AG.ScaleType = Enum.ScaleType.Slice
    AG.SliceCenter = Rect.new(49, 49, 450, 450)
    AG.ZIndex = 99
    AG.Parent = lG
    local AG = Instance.new("Frame", lG)
    AG.Size = UDim2.new(1, 0, 0, 44)
    AG.BackgroundTransparency = 1
    AG.Active = true
    AG.Selectable = true
    AG.ZIndex = 101
    D(AG, lG, "TargetControls")
    -- Strong mobile drag: full-width button handle on the title
    local dragBtn = Instance.new("TextButton", AG)
    dragBtn.Name = "DragHandle"
    dragBtn.Size = UDim2.new(1, 0, 1, 0)
    dragBtn.BackgroundTransparency = 1
    dragBtn.Text = ""
    dragBtn.ZIndex = 110
    dragBtn.Active = true
    dragBtn.AutoButtonColor = false
    local draggingTC, tcStart, tcPos = false, nil, nil
    dragBtn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            draggingTC = true
            tcStart = inp.Position
            tcPos = lG.Position
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(inp)
        if draggingTC and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local dlt = inp.Position - tcStart
            lG.Position = UDim2.new(tcPos.X.Scale, tcPos.X.Offset + dlt.X, tcPos.Y.Scale, tcPos.Y.Offset + dlt.Y)
        end
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if draggingTC then
                draggingTC = false
                i.UILocked = false
                i.Positions.TargetControls = {
                    X = lG.Position.X.Scale,
                    Y = lG.Position.Y.Scale,
                    OffsetX = lG.Position.X.Offset,
                    OffsetY = lG.Position.Y.Offset,
                }
                if U then pcall(U) end
            end
        end
    end)
    local HG = Instance.new("TextLabel", AG)
    HG.Size = UDim2.new(1, -28.0, 0, 24)
    HG.Position = UDim2.new(0, 14, 0, 10)
    HG.ZIndex = 111
    HG.BackgroundTransparency = 1
    HG.Text = "TARGET CONTROLS"
    HG.Font = Enum.Font.GothamBlack
    HG.TextSize = 14
    HG.TextColor3 = b.TEXT
    HG.TextXAlignment = Enum.TextXAlignment.Center
    HG.Active = false
    local AG = Instance.new("Frame", lG)
    AG.AnchorPoint = Vector2.new(0.5, 0)
    AG.Position = UDim2.new(0.5, 0, 0, 30)
    AG.Size = UDim2.new(0, 90, 0, 1)
    AG.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    AG.BackgroundTransparency = 0.15
    AG.BorderSizePixel = 0
    AG.ZIndex = 101
    local AG = Instance.new("Frame", lG)
    AG.AutomaticSize = Enum.AutomaticSize.Y
    AG.Size = UDim2.new(1, -16, 0, 0)
    AG.Position = UDim2.fromOffset(8, 40)
    AG.BackgroundColor3 = b.SURF
    AG.BorderSizePixel = 0
    AG.ZIndex = 101
    tG(AG, 16)
    DG(AG, b.AQUA_STROKE, 1, 0.48)
    local lG = Instance.new("Frame", AG)
    lG.AutomaticSize = Enum.AutomaticSize.Y
    lG.Size = UDim2.new(1, -10.0, 0, 0)
    lG.Position = UDim2.fromOffset(5, 5)
    lG.BackgroundTransparency = 1
    lG.ZIndex = 102
    local AG = Instance.new("UIListLayout")
    AG.Padding = UDim.new(0, 4)
    AG.SortOrder = Enum.SortOrder.LayoutOrder
    AG.Parent = lG
    local AG = d and 1.3 or 1
    local function HG(ZG, kG, uG)
        local gG = Instance.new("Frame", ZG)
        gG.Name = kG:gsub("%s+", "") .. "Row"
        gG.Size = UDim2.new(1, 0, 0, math.floor(28 * AG))
        gG.BackgroundColor3 = b.SURF2
        gG.BackgroundTransparency = 0.02
        gG.BorderSizePixel = 0
        gG.LayoutOrder = math.floor((uG or 0) / math.max(1, 36 * AG)) + 1
        gG.ZIndex = 103
        tG(gG, 11)
        local ZG = DG(gG, b.AQUA_STROKE, 1, 0.52)
        local uG = Instance.new("TextLabel", gG)
        uG.BackgroundTransparency = 1
        uG.Position = UDim2.fromOffset(9, 0)
        uG.Size = UDim2.new(1, -88, 1, 0)
        uG.Font = Enum.Font.GothamBold
        uG.Text = kG
        uG.TextColor3 = b.TEXT
        uG.TextSize = 10 * AG
        uG.TextXAlignment = Enum.TextXAlignment.Left
        uG.ZIndex = 104
        local hG = Instance.new("TextButton", gG)
        hG.Name = kG:gsub("%s+", "") .. "Toggle"
        hG.AutoButtonColor = false
        hG.Size = UDim2.fromOffset(math.floor(62 * AG), math.floor(22 * AG))
        hG.Position = UDim2.new(1, -math.floor(72 * AG), 0.5, -math.floor(9 * AG))
        hG.BackgroundColor3 = b.OFF_BG
        hG.BorderSizePixel = 0
        hG.Text = ""
        hG.ZIndex = 104
        tG(hG, 7)
        local kG = DG(hG, b.AQUA_STROKE, 1, 0.55)
        local LG = Instance.new("Frame", hG)
        LG.Size = UDim2.new(1, 0, 1, 0)
        LG.BackgroundTransparency = 1
        LG.BorderSizePixel = 0
        LG.ZIndex = 104
        tG(LG, 7)
        mG(LG, b.GREEN1, b.GREEN2, 0)
        local sG = Instance.new("TextLabel", hG)
        sG.BackgroundTransparency = 1
        sG.Size = UDim2.fromScale(1, 1)
        sG.Font = Enum.Font.GothamBold
        sG.TextSize = 9 * AG
        sG.Text = "OFF"
        sG.TextColor3 = b.OFF_TEXT
        sG.ZIndex = 105
        gG.MouseEnter:Connect(function()
            EG(gG, 0.14, { BackgroundColor3 = Color3.fromRGB(120, 40, 90) })
            EG(ZG, 0.14, { Transparency = 0.38 })
        end)
        gG.MouseLeave:Connect(function()
            EG(gG, 0.14, { BackgroundColor3 = b.SURF2 })
            EG(ZG, 0.14, { Transparency = 0.52 })
        end)
        return { row = gG, label = uG, button = hG, knob = LG, stateLabel = sG, stroke = kG, rowStroke = ZG }
    end
    local ZG = HG(lG, "Nearest", 0)
    local kG = HG(lG, "Highest", 36 * AG)
    local uG = HG(lG, "Priority", 72 * AG)
    local gG = HG(lG, "Auto Turret", 108 * AG)
    local hG = HG(lG, "Auto Kick", 144 * AG)

    local LG
    local CarpetRow
    local function sG(SG, NG)
        KG()
        local function PB(CB, rB, RB)
            local dB = RB or b.AQUA
            if rB then
                CB.button.BackgroundColor3 = b.GREEN1
                CB.knob.BackgroundTransparency = 0
                CB.stateLabel.Text = "ON"
                CB.stateLabel.TextColor3 = Color3.fromRGB(255, 246, 236)
                CB.stroke.Color = b.GREEN_STROKE
                CB.stroke.Transparency = 0.22
            else
                CB.button.BackgroundColor3 = b.OFF_BG
                CB.knob.BackgroundTransparency = 1
                CB.stateLabel.Text = "OFF"
                CB.stateLabel.TextColor3 = b.OFF_TEXT
                CB.stroke.Color = b.AQUA_STROKE
                CB.stroke.Transparency = 0.55
            end
            if CB.rowStroke then
                CB.rowStroke.Transparency = rB and 0.38 or 0.52
            end
            if CB.label then
                CB.label.TextColor3 = rB and b.TEXT or b.TEXT
            end
        end
        PB(ZG, fG, W.Accent1)
        PB(kG, aG, W.Accent1)
        PB(uG, eG, W.Accent2)
        PB(gG, i.AutoDestroyTurrets, W.Accent1)
        PB(hG, i.AutoKickOnSteal, W.Accent1)
        if LG then
            if xG then
                LG.stateLabel.Text = "ON"
                LG.stateLabel.TextColor3 = Color3.fromRGB(255, 246, 236)
                LG.button.BackgroundColor3 = b.GREEN1
                LG.knob.BackgroundTransparency = 0
                LG.stroke.Color = b.GREEN_STROKE
                LG.stroke.Transparency = 0.22
            else
                LG.stateLabel.Text = "OFF"
                LG.stateLabel.TextColor3 = b.OFF_TEXT
                LG.button.BackgroundColor3 = b.OFF_BG
                LG.knob.BackgroundTransparency = 1
                LG.stroke.Color = b.AQUA_STROKE
                LG.stroke.Transparency = 0.55
            end
            if LG.rowStroke then
                LG.rowStroke.Transparency = xG and 0.38 or 0.52
            end
        end
        if CarpetRow then
            if cSheetCarpet then
                CarpetRow.stateLabel.Text = "ON"
                CarpetRow.stateLabel.TextColor3 = Color3.fromRGB(255, 246, 236)
                CarpetRow.button.BackgroundColor3 = b.GREEN1
                CarpetRow.knob.BackgroundTransparency = 0
                CarpetRow.stroke.Color = b.GREEN_STROKE
                CarpetRow.stroke.Transparency = 0.22
            else
                CarpetRow.stateLabel.Text = "OFF"
                CarpetRow.stateLabel.TextColor3 = b.OFF_TEXT
                CarpetRow.button.BackgroundColor3 = b.OFF_BG
                CarpetRow.knob.BackgroundTransparency = 1
                CarpetRow.stroke.Color = b.AQUA_STROKE
                CarpetRow.stroke.Transparency = 0.55
            end
            if CarpetRow.rowStroke then
                CarpetRow.rowStroke.Transparency = cSheetCarpet and 0.38 or 0.52
            end
        end
        if OG and NG then
            local PB = false
            for CB, rB in ipairs(NG) do
                if rB.uid == OG then
                    iG = CB
                    PB = true
                    break
                end
            end
        end
        if P.ListNeedsRedraw then
            for PB, PB in ipairs(XG:GetChildren()) do
                if PB:IsA("TextButton") then
                    PB:Destroy()
                end
            end
            oG = {}
            if NG and #NG > 0 then
                for PB = 1, #NG do
                    local CB = NG[PB]
                    local rB = Instance.new("TextButton")
                    rB.Size = UDim2.new(1, 0, 0, 30)
                    rB.BackgroundColor3 = GG.SURF2
                    rB.BorderSizePixel = 0
                    rB.Text = ""
                    rB.AutoButtonColor = false
                    rB.Parent = XG
                    rB.Position = UDim2.new(0, 0, 0, 0)
                    rB.ClipsDescendants = true
                    rB.ZIndex = 1
                    Instance.new("UICorner", rB).CornerRadius = UDim.new(0, 10)
                    local RB = Instance.new("Frame", rB)
                    RB.Name = "SelectedOverlay"
                    RB.Size = UDim2.new(1, 0, 1, 0)
                    RB.Position = UDim2.new(0, 0, 0, 0)
                    RB.BackgroundColor3 = Color3.fromRGB(14, 6, 12)
                    RB.BackgroundTransparency = 0.82
                    RB.BorderSizePixel = 0
                    RB.Visible = false
                    RB.ZIndex = 2
                    Instance.new("UICorner", RB).CornerRadius = UDim.new(0, 10)
                    local dB = Instance.new("UIGradient", RB)
                    dB.Rotation = 90
                    dB.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 30, 70)),
                        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(120, 53, 8)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 30, 70)),
                    })
                    dB.Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0.12),
                        NumberSequenceKeypoint.new(0.18, 0.3),
                        NumberSequenceKeypoint.new(0.55, 0.52),
                        NumberSequenceKeypoint.new(1, 0.18),
                    })
                    local dB = Instance.new("Frame", rB)
                    dB.Size = UDim2.fromOffset(22, 22)
                    dB.Position = UDim2.fromOffset(8, 8)
                    dB.BackgroundColor3 = GG.SURF
                    dB.ZIndex = 3
                    dB.BorderSizePixel = 0
                    Instance.new("UICorner", dB).CornerRadius = UDim.new(0, 10)
                    local nB = Instance.new("UIStroke", dB)
                    nB.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    nB.Color = GG.AQUA_STROKE
                    nB.Thickness = 1
                    nB.Transparency = 0.45
                    local fB = Instance.new("TextLabel", dB)
                    fB.Size = UDim2.new(1, 0, 1, 0)
                    fB.BackgroundTransparency = 1
                    fB.Text = "#" .. PB
                    fB.Font = Enum.Font.GothamBold
                    fB.TextSize = 11
                    fB.TextColor3 = GG.TEXT
                    fB.TextXAlignment = Enum.TextXAlignment.Center
                    fB.ZIndex = 4
                    local JB = CB and CB.petName or "Unknown"
                    local aB = CB and CB.mpsText or "$0/s"
                    local eB = Instance.new("TextLabel", rB)
                    eB.Size = UDim2.new(1, -108.0, 0, 16)
                    eB.Position = UDim2.fromOffset(38, 4)
                    eB.BackgroundTransparency = 1
                    eB.RichText = false
                    eB.Text = JB
                    eB.Font = Enum.Font.GothamBold
                    eB.TextSize = 12
                    eB.TextColor3 = GG.TEXT
                    eB.TextXAlignment = Enum.TextXAlignment.Left
                    eB.TextTruncate = Enum.TextTruncate.None
                    eB.ClipsDescendants = false
                    eB.ZIndex = 4
                    local JB = Instance.new("UITextSizeConstraint", eB)
                    JB.MinTextSize = 8
                    JB.MaxTextSize = 12
                    local JB = Instance.new("TextLabel", rB)
                    JB.Size = UDim2.new(0, 70, 0, 13)
                    JB.Position = UDim2.new(1, -76, 0, 3)
                    JB.BackgroundTransparency = 1
                    JB.RichText = false
                    JB.Text = aB
                    JB.Font = Enum.Font.GothamBold
                    JB.TextSize = 10
                    JB.TextColor3 = Color3.fromRGB(255, 105, 180)
                    JB.TextXAlignment = Enum.TextXAlignment.Right
                    JB.TextTruncate = Enum.TextTruncate.AtEnd
                    JB.ZIndex = 4
                    local aB = Instance.new("TextLabel", rB)
                    aB.Size = UDim2.new(1, -88, 0, 13)
                    aB.Position = UDim2.fromOffset(30, 14)
                    aB.BackgroundTransparency = 1
                    local xB, QB = jG(CB)
                    aB.RichText = QB
                    aB.Text = xB
                    aB.Font = Enum.Font.GothamBold
                    aB.TextSize = 10
                    aB.TextColor3 = IG(CB.mutation)
                    aB.TextXAlignment = Enum.TextXAlignment.Left
                    aB.TextTruncate = Enum.TextTruncate.None
                    aB.ClipsDescendants = false
                    aB.ZIndex = 4
                    local QB = Instance.new("UITextSizeConstraint", aB)
                    QB.MinTextSize = 8
                    QB.MaxTextSize = 12
                    aB.Visible = xB ~= ""
                    oG[PB] = {
                        button = rB,
                        selectedOverlay = RB,
                        rankBox = dB,
                        rankBoxStroke = nB,
                        rank = fB,
                        info = eB,
                        rate = JB,
                        mutation = aB,
                        petData = CB,
                    }
                    rB.MouseButton1Click:Connect(function()
                        if UG == CB.uid then
                            UG = nil
                            OG = nil
                            _G.NEAREST_INSTANT_MODE = (fG and xG)
                        else
                            iG = PB
                            OG = CB.uid
                            UG = CB.uid
                            nG = true
                            _G.NEAREST_INSTANT_MODE = false
                        end
                        P.ListNeedsRedraw = true
                        sG(nG, TG())
                    end)
                end
            end
            P.ListNeedsRedraw = false
            local PB = #oG
            local CB = 0
            if PB > 0 then
                CB = PB * 38 + (PB - 1) * 5
            end
            XG.Size = UDim2.new(1, -0.0, 0, CB)
            WG.CanvasSize = UDim2.new(0, 0, 0, CB + 0)
        end
        for PB, PB in ipairs(oG) do
            local oG = PB.petData and UG and PB.petData.uid == UG
            PB.button.ZIndex = 1
            PB.button.BackgroundTransparency = 0
            PB.button.BackgroundColor3 = oG and Color3.fromRGB(200, 80, 150) or GG.SURF2
            if PB.selectedOverlay then
                PB.selectedOverlay.Visible = oG
                PB.selectedOverlay.ZIndex = 2
                PB.selectedOverlay.BackgroundColor3 = Color3.fromRGB(14, 6, 12)
                PB.selectedOverlay.BackgroundTransparency = oG and 0.9 or 1
            end
            if PB.rankBox then
                PB.rankBox.BackgroundColor3 = oG and Color3.fromRGB(120, 40, 90) or GG.SURF
                PB.rankBox.ZIndex = 3
            end
            if PB.rankBoxStroke then
                PB.rankBoxStroke.Color = oG and Color3.fromRGB(120, 40, 90) or GG.AQUA_STROKE
                PB.rankBoxStroke.Thickness = 1
                PB.rankBoxStroke.Transparency = oG and 1 or 0.45
            end
            if PB.rank then
                PB.rank.ZIndex = 4
                PB.rank.TextColor3 = oG and Color3.fromRGB(255, 246, 236) or GG.TEXT
            end
            if PB.info then
                PB.info.ZIndex = 4
                PB.info.RichText = false
                if PB.petData then
                    PB.info.Text = pG(PB.petData)
                end
                PB.info.TextColor3 = oG and Color3.fromRGB(100, 30, 70) or GG.TEXT
            end
            if PB.mutation then
                PB.mutation.ZIndex = 4
                if PB.petData then
                    local pG, GG = jG(PB.petData)
                    PB.mutation.RichText = GG
                    PB.mutation.Text = pG
                    PB.mutation.Visible = pG ~= ""
                end
                PB.mutation.TextColor3 = oG and Color3.fromRGB(100, 30, 70)
                    or IG(PB.petData and PB.petData.mutation)
            end
            if PB.rate then
                PB.rate.ZIndex = 4
                if PB.petData and PB.petData.mpsText then
                    PB.rate.Text = PB.petData.mpsText
                end
                PB.rate.TextColor3 = oG and Color3.fromRGB(100, 30, 70) or Color3.fromRGB(255, 105, 180)
            end
        end
        local oG = NG and NG[iG]
        P.SelectedPetData = oG
        if SG then
            if not fG then
                if oG then
                    MG.Text = string.format("%s - %s", oG.petName or "Unknown", oG.mpsText or "")
                else
                    MG.Text = "Searching..."
                end
            end
        else
            MG.Text = "Disabled"
            if zG then
                zG:Cancel()
                zG = nil
            end
            bG.Size = UDim2.new(0, 0, 1, 0)
        end
        FG.Text = string.format("%d%%", math.clamp(math.floor(bG.Size.X.Scale * 100 + 0.5), 0, 100))
        XG.Size = UDim2.new(1, -0.0, 0, math.max(0, vG.AbsoluteContentSize.Y))
        WG.CanvasSize = UDim2.new(0, 0, 0, math.max(0, vG.AbsoluteContentSize.Y) + 0)
    end
    vG:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        XG.Size = UDim2.new(1, -0.0, 0, math.max(0, vG.AbsoluteContentSize.Y))
        WG.CanvasSize = UDim2.new(0, 0, 0, math.max(0, vG.AbsoluteContentSize.Y) + 0)
    end)
    P.UpdateAutoStealUI = function()
        sG(nG, TG())
    end
    task.spawn(function()
        while bG and bG.Parent do
            local oG = math.clamp(math.floor(bG.Size.X.Scale * 100 + 0.5), 0, 100)
            FG.Text = tostring(oG) .. "%"
            task.wait(0.05)
        end
    end)
    ZG.button.MouseButton1Click:Connect(function()
        fG = not fG
        if fG then
            aG = false
            eG = false
            UG = nil
        end
        i.StealNearest = fG
        i.StealHighest = aG
        i.StealPriority = eG
        KG()
        _G.NEAREST_INSTANT_MODE = (fG and xG)
        U()
        P.ListNeedsRedraw = false
        sG(nG, TG())
    end)
    kG.button.MouseButton1Click:Connect(function()
        aG = not aG
        if aG then
            fG = false
            eG = false
            UG = nil
        end
        i.StealNearest = fG
        i.StealHighest = aG
        i.StealPriority = eG
        KG()
        _G.NEAREST_INSTANT_MODE = (fG and xG)
        U()
        P.ListNeedsRedraw = false
        sG(nG, TG())
    end)
    uG.button.MouseButton1Click:Connect(function()
        eG = not eG
        if eG then
            fG = false
            aG = false
            UG = nil
        end
        i.StealNearest = fG
        i.StealHighest = aG
        i.StealPriority = eG
        KG()
        _G.NEAREST_INSTANT_MODE = (fG and xG)
        U()
        P.ListNeedsRedraw = false
        sG(nG, TG())
    end)
    gG.button.MouseButton1Click:Connect(function()
        i.AutoDestroyTurrets = not i.AutoDestroyTurrets
        U()
        P.ListNeedsRedraw = false
        sG(nG, TG())
    end)
    hG.button.MouseButton1Click:Connect(function()
        i.AutoKickOnSteal = not i.AutoKickOnSteal
        U()
        P.ListNeedsRedraw = false
        sG(nG, TG())
    end)
    local KG = Instance.new("TextButton", lG)
    KG.Name = "CustomizePriorityButton"
    KG.Size = UDim2.new(1, 0, 0, math.floor(38 * AG))
    KG.BackgroundColor3 = b.AQUA2
    KG.BackgroundTransparency = 0.02
    KG.Text = "CUSTOMIZE PRIORITY"
    KG.Font = Enum.Font.GothamBold
    KG.TextSize = 12 * AG
    KG.TextColor3 = b.TEXT
    KG.BorderSizePixel = 0
    KG.AutoButtonColor = false
    KG.LayoutOrder = 7
    KG.ZIndex = 103
    tG(KG, 11)
    DG(KG, b.AQUA_STROKE, 1, 0.2)
    mG(KG, b.AQUA, b.AQUA2, 0)
    KG.Visible = false
    KG.MouseEnter:Connect(function()
        EG(KG, 0.14, { BackgroundColor3 = Color3.fromRGB(255, 105, 180) })
    end)
    KG.MouseLeave:Connect(function()
        EG(KG, 0.14, { BackgroundColor3 = b.AQUA2 })
    end)
    KG.MouseButton1Click:Connect(function()
        -- removed: settings menu priority editor
    end)
    LG = HG(lG, "Instant Steal", 180 * AG)
    LG.button.MouseButton1Click:Connect(function()
        xG = not xG
        if xG then
            QG = false
            VG = false
        else
            QG = false
            VG = false
        end
        i.InstantSteal = xG
        _G.NEAREST_INSTANT_MODE = (fG and xG)
        U()
        P.ListNeedsRedraw = false
        sG(nG, TG())
    end)
    task.spawn(function()
        while true do
            task.wait(1.5)
            if not xG then
                continue
            end
            xG = false
            QG = false
            VG = false
            i.InstantSteal = false
            _G.NEAREST_INSTANT_MODE = false
            task.wait(0.05)
            xG = true
            i.InstantSteal = true
            _G.NEAREST_INSTANT_MODE = (fG and true)
        end
    end)
    -- ============================ CARPET SPEED ============================
    -- Toggle row in the AUTO STEAL list + keybind (Q). Logic ported 1:1 from the
    -- AUROS hub: auto-equips a carpet tool, moves the HumanoidRootPart via
    -- AssemblyLinearVelocity, and auto-disables while the player is "Stealing"
    -- (anti-reset). carpetSpeed = 140.
    local CARPET_NAMES = { "Flying Carpet", "Waverider", "Santa's Sleigh", "Witch's Broom", "Cupid's Wings" }
    local TP_ITEM_NAMES = { "Flying Carpet", "Waverider", "Santa's Sleigh", "Witch's Broom", "Cupid's Wings" }
    local carpetSpeed = 140
    local carpetConn = nil
    local carpetWalkSpeed = nil

    local function findTool(name)
        if type(name) ~= "string" or name == "" then
            return nil
        end
        local char = C.Character
        local bp = C:FindFirstChild("Backpack") or C:FindFirstChildOfClass("Backpack")
        local sg = C:FindFirstChild("StarterGear")
        return (char and char:FindFirstChild(name))
            or (bp and bp:FindFirstChild(name))
            or (sg and sg:FindFirstChild(name))
    end

    local function equipCarpet()
        local char = C.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then
            return nil
        end
        for _, n in ipairs(CARPET_NAMES) do
            local t = findTool(n)
            if t and t:IsA("Tool") then
                if t.Parent ~= char then
                    pcall(function()
                        hum:EquipTool(t)
                    end)
                end
                return n
            end
        end
        return nil
    end

    local function setCarpetTool(name)
        if type(name) ~= "string" or name == "" then
            return
        end
        _G.SabcomCarpetTool = name
        for k = #CARPET_NAMES, 1, -1 do
            if CARPET_NAMES[k] == name then
                table.remove(CARPET_NAMES, k)
            end
        end
        table.insert(CARPET_NAMES, 1, name)
    end
    local function currentCarpetTool()
        if type(_G.SabcomCarpetTool) == "string" and _G.SabcomCarpetTool ~= "" then
            return _G.SabcomCarpetTool
        end
        return CARPET_NAMES[1] or "Flying Carpet"
    end
    -- приоритетный инструмент из конфига хаба
    if type(i) == "table" and i.TpSettings and type(i.TpSettings.Tool) == "string" and i.TpSettings.Tool ~= "" then
        setCarpetTool(i.TpSettings.Tool)
    end
    _G.SabcomSetCarpetTool = setCarpetTool
    _G.SabcomCurrentCarpetTool = currentCarpetTool

    local function repaintCarpetRow()
        P.ListNeedsRedraw = false
        sG(nG, TG())
    end

    local function setCarpetSpeed(on)
        cSheetCarpet = on and true or false
        i.CarpetSpeed = cSheetCarpet
        _G.SabcomCarpetSpeed = cSheetCarpet
        if carpetConn then
            carpetConn:Disconnect()
            carpetConn = nil
        end
        -- Отключаем собственную скорость бега у хуманоида, чтобы она не
        -- «сбрасывала» установленную скорость ковра. Возвращаем при выключении.
        local humNow = C.Character and C.Character:FindFirstChildOfClass("Humanoid")
        if humNow then
            if cSheetCarpet then
                if carpetWalkSpeed == nil then
                    carpetWalkSpeed = humNow.WalkSpeed
                end
                humNow.WalkSpeed = 0
            else
                if carpetWalkSpeed then
                    humNow.WalkSpeed = carpetWalkSpeed
                end
                carpetWalkSpeed = nil
            end
        end
        repaintCarpetRow()
        U()
        if not cSheetCarpet then
            return
        end
        carpetConn = R.Heartbeat:Connect(function()
            local c = C.Character
            if not c then
                return
            end
            local hum = c:FindFirstChildOfClass("Humanoid")
            local hrp = c:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp then
                return
            end
            if C:GetAttribute("Stealing") then
                setCarpetSpeed(false)
                return
            end
            local name = equipCarpet()
            if name and c:FindFirstChild(name) then
                local md = hum.MoveDirection
                local spd = math.clamp(tonumber(carpetSpeed) or 140, 20, 400)
                if md.Magnitude > 0 then
                    hrp.AssemblyLinearVelocity =
                        Vector3.new(md.X * spd, hrp.AssemblyLinearVelocity.Y, md.Z * spd)
                else
                    hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                end
            end
        end)
    end
    _G.SabcomSetCarpetSpeed = setCarpetSpeed

    local carpetLastToggle = 0
    local function toggleCarpet()
        if tick() - carpetLastToggle < 0.15 then
            return
        end
        carpetLastToggle = tick()
        setCarpetSpeed(not cSheetCarpet)
    end
    _G.toggleCarpetSpeed = toggleCarpet

    CarpetRow = HG(lG, "Carpet Speed", 216 * AG)
    CarpetRow.button.MouseButton1Click:Connect(toggleCarpet)

    -- Keybind Q
    j.InputBegan:Connect(function(inp, gpe)
        if gpe then
            return
        end
        if inp.KeyCode == Enum.KeyCode[i.TpSettings.CarpetSpeedKey] then
            toggleCarpet()
        end
    end)

    -- авто-офф при краже (анти-ресет)
    pcall(function()
        C:GetAttributeChangedSignal("Stealing"):Connect(function()
            if C:GetAttribute("Stealing") and cSheetCarpet then
                setCarpetSpeed(false)
            end
        end)
    end)

    -- переподключение после респавна
    C.CharacterAdded:Connect(function()
        task.wait(0.4)
        carpetWalkSpeed = nil
        if cSheetCarpet then
            setCarpetSpeed(true)
        end
    end)

    -- применить сохранённое состояние при запуске
    if cSheetCarpet then
        task.defer(function()
            setCarpetSpeed(true)
        end)
    end
    -- ========================== END CARPET SPEED ==========================

    -- ========================== FPS BOOST / ANTI-LAG ==========================
    -- Based on the Anti-Lag system from the supplied SlicedzHub source.
    _G.FPSBooster = (function()
        local Lighting = game:GetService("Lighting")
        local Workspace = workspace
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        local M = {
            enabled = false,
            conn = nil,
            saved = nil,
        }

        local function derender(item)
            pcall(function()
                -- Keep the local player untouched so selected animations still work.
                local char = LocalPlayer and LocalPlayer.Character
                if char and (item == char or item:IsDescendantOf(char)) then
                    return
                end

                -- The supplied Anti-Lag removes accessories and heavy visual detail.
                if item:IsA("Accessory") or item:IsA("Hat") then
                    item:Destroy()
                    return
                end

                if item:IsA("BasePart") then
                    item.Material = Enum.Material.Plastic
                    item.Reflectance = 0
                    item.CastShadow = false
                    return
                end

                if item:IsA("Decal") or item:IsA("Texture") then
                    item.Transparency = 1
                    return
                end

                if item:IsA("ParticleEmitter") or item:IsA("Trail") or item:IsA("Beam")
                    or item:IsA("Fire") or item:IsA("Smoke") or item:IsA("Sparkles")
                    or item:IsA("Highlight") then
                    item.Enabled = false
                end
            end)
        end

        local function disableNPCAnimation(model)
            if not model or not model:IsA("Model") then return end
            if LocalPlayer and LocalPlayer.Character == model then return end

            local hum = model:FindFirstChildOfClass("Humanoid")
            if not hum then return end

            pcall(function()
                local animate = model:FindFirstChild("Animate")
                if animate and (animate:IsA("Script") or animate:IsA("LocalScript")) then
                    animate.Enabled = false
                end

                local animator = hum:FindFirstChildOfClass("Animator")
                if animator then
                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                        pcall(function() track:Stop(0) end)
                    end
                end
            end)
        end

        local scanning = false
        local function scan()
            if scanning then return end
            scanning = true
            task.spawn(function()
                local list = Workspace:GetDescendants()
                for n, item in ipairs(list) do
                    if not M.enabled then break end

                    derender(item)

                    if item:IsA("Model") and item:FindFirstChildOfClass("Humanoid") then
                        disableNPCAnimation(item)
                    end

                    if n % 250 == 0 then
                        task.wait()
                    end
                end
                scanning = false
            end)
        end

        local function saveLighting()
            M.saved = {
                Brightness = Lighting.Brightness,
                ClockTime = Lighting.ClockTime,
                OutdoorAmbient = Lighting.OutdoorAmbient,
                GlobalShadows = Lighting.GlobalShadows,
                FogEnd = Lighting.FogEnd,
                EnvDiffuse = Lighting.EnvironmentDiffuseScale,
                EnvSpecular = Lighting.EnvironmentSpecularScale,
                effects = {},
            }

            for _, child in ipairs(Lighting:GetChildren()) do
                if child:IsA("PostEffect") then
                    M.saved.effects[child] = child.Enabled
                end
            end
        end

        local function applyLighting()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 10000000000
            Lighting.Brightness = 1
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0

            for _, child in ipairs(Lighting:GetChildren()) do
                if child:IsA("BlurEffect") or child:IsA("SunRaysEffect")
                    or child:IsA("ColorCorrectionEffect") or child:IsA("BloomEffect")
                    or child:IsA("DepthOfFieldEffect") then
                    pcall(function() child.Enabled = false end)
                end
            end
        end

        local function enable()
            if M.enabled then return end
            M.enabled = true
            saveLighting()
            applyLighting()
            scan()

            if M.conn then pcall(function() M.conn:Disconnect() end) end
            M.conn = Workspace.DescendantAdded:Connect(function(item)
                if not M.enabled then return end
                task.defer(function()
                    derender(item)
                    if item:IsA("Model") and item:FindFirstChildOfClass("Humanoid") then
                        disableNPCAnimation(item)
                    elseif item:IsA("Humanoid") and item.Parent then
                        disableNPCAnimation(item.Parent)
                    end
                end)
            end)
        end

        local function disable()
            M.enabled = false
            if M.conn then
                pcall(function() M.conn:Disconnect() end)
                M.conn = nil
            end

            -- Lighting is restored; visual objects intentionally remain optimized,
            -- matching the supplied Anti-Lag behavior.
            if M.saved then
                pcall(function()
                    Lighting.Brightness = M.saved.Brightness
                    Lighting.ClockTime = M.saved.ClockTime
                    Lighting.OutdoorAmbient = M.saved.OutdoorAmbient
                    Lighting.GlobalShadows = M.saved.GlobalShadows
                    Lighting.FogEnd = M.saved.FogEnd
                    Lighting.EnvironmentDiffuseScale = M.saved.EnvDiffuse
                    Lighting.EnvironmentSpecularScale = M.saved.EnvSpecular
                    for effect, wasEnabled in pairs(M.saved.effects) do
                        if effect and effect.Parent then
                            effect.Enabled = wasEnabled
                        end
                    end
                end)
            end
        end

        function M.set(on)
            local ok, err = pcall(function()
                if on then enable() else disable() end
            end)
            if not ok then
                warn("[candytp FPS Boost] " .. tostring(err))
            end
            return M.enabled
        end

        function M.isEnabled()
            return M.enabled == true
        end

        return M
    end)()
    -- ========================== END FPS BOOST / ANTI-LAG ==========================
    -- ========================== GAME STRETCHER (из Kay Hub) ==========================
    _G.GameStretcher = (function()
        local M = {
            enabled = false,
            originalFOV = nil,
            stretchConn = nil,
            stretchFactor = tonumber(i.gameStretchFactor) or 0.75,
            targetFOV = tonumber(i.cameraFOV) or 70,
            stretchCFrame = nil,
        }
        M.stretchCFrame = CFrame.new(0, 0, 0, 1, 0, 0, 0, M.stretchFactor, 0, 0, 0, 1)

        local function applyStretch()
            if not M.enabled then return end
            local cam = workspace.CurrentCamera
            if not cam then return end
            pcall(function()
                cam.CFrame = cam.CFrame * M.stretchCFrame
                local targetFov = M.targetFOV or 70
                if math.abs(cam.FieldOfView - targetFov) > 0.05 then
                    cam.FieldOfView = targetFov
                end
            end)
        end

        local function enable()
            if M.enabled then return end
            M.enabled = true
            local cam = workspace.CurrentCamera
            if cam then
                M.originalFOV = cam.FieldOfView
            end
            pcall(function()
                R:BindToRenderStep("FH_GameStretch", Enum.RenderPriority.Camera.Value + 1, applyStretch)
            end)
        end

        local function disable()
            if not M.enabled then return end
            M.enabled = false
            pcall(function()
                R:UnbindFromRenderStep("FH_GameStretch")
            end)
            if M.stretchConn then
                pcall(function() M.stretchConn:Disconnect() end)
                M.stretchConn = nil
            end
            local cam = workspace.CurrentCamera
            if cam and M.originalFOV then
                pcall(function() cam.FieldOfView = M.originalFOV end)
            end
        end

        function M.set(on)
            if on then enable() else disable() end
        end

        function M.isEnabled()
            return M.enabled
        end

        function M.setFactor(factor)
            factor = tonumber(factor) or 0.75
            factor = math.clamp(factor, 0.1, 1.5)
            M.stretchFactor = factor
            M.stretchCFrame = CFrame.new(0, 0, 0, 1, 0, 0, 0, factor, 0, 0, 0, 1)
            i.gameStretchFactor = factor
            U()
        end

        function M.setFOV(fov)
            fov = tonumber(fov) or 70
            fov = math.clamp(fov, 60, 120)
            M.targetFOV = fov
            i.cameraFOV = fov
            U()
            if not M.enabled then
                local cam = workspace.CurrentCamera
                if cam then
                    pcall(function() cam.FieldOfView = fov end)
                end
            end
        end

        function M.getFactor()
            return M.stretchFactor
        end

        function M.getFOV()
            return M.targetFOV
        end

        return M
    end)()

    -- ========================== SEPARATE OPTIMIZER MENU (FPS BOOST + GAME STRETCHER) ==========================
    -- Отдельное перетаскиваемое окно, не зависит от панели авто-кражи.
    local _optUiParent = (gethui and gethui()) or game:GetService("CoreGui")

    local OptGui = Instance.new("ScreenGui")
    OptGui.Name = "__candytpOptimizerGUI"
    OptGui.ResetOnSpawn = false
    OptGui.IgnoreGuiInset = true
    OptGui.DisplayOrder = 600
    OptGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    OptGui.Parent = _optUiParent

    local OptWin = Instance.new("Frame", OptGui)
    OptWin.Size = UDim2.new(0, math.floor(252 * AG), 0, 0)
    OptWin.AutomaticSize = Enum.AutomaticSize.Y
    OptWin.Position = UDim2.new(0.5, -math.floor(126 * AG), 0.2, 0)
    OptWin.AnchorPoint = Vector2.new(0, 0)
    OptWin.BackgroundColor3 = b.SURF
    OptWin.BorderSizePixel = 0
    OptWin.ZIndex = 10
    OptWin.Visible = true
    tG(OptWin, 16)
    DG(OptWin, b.AQUA_STROKE, 1.2, 0.4)
    local _optFlow=Instance.new("UIGradient",OptWin)
    _optFlow.Rotation=18
    _optFlow.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(80, 25, 55)),
        ColorSequenceKeypoint.new(0.32,Color3.fromRGB(255, 105, 180)),
        ColorSequenceKeypoint.new(0.58,Color3.fromRGB(255, 20, 147)),
        ColorSequenceKeypoint.new(0.82,Color3.fromRGB(255, 105, 180)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(80, 25, 55)),
    })
    -- Static gradient: keeps the lacquer look without a permanent 50 FPS UI loop.
    _optFlow.Offset = Vector2.new(-0.35, 0)
    -- Восстановить сохранённую позицию окна (слова «где я оставлю»).
    do
        local _saved = i.Positions and i.Positions["Optimizer"]
        if type(_saved) == "table"
            and _saved.X ~= nil and _saved.Y ~= nil then
            OptWin.Position = UDim2.new(
                tonumber(_saved.X) or 0.5,
                tonumber(_saved.OffsetX) or 0,
                tonumber(_saved.Y) or 0.2,
                tonumber(_saved.OffsetY) or 0
            )
        end
    end

    -- Заголовок
    local OptHdr = Instance.new("Frame", OptWin)
    OptHdr.Size = UDim2.new(1, 0, 0, math.floor(40 * AG))
    OptHdr.BackgroundTransparency = 1
    OptHdr.ZIndex = 12
    local OptTitle = Instance.new("TextLabel", OptHdr)
    OptTitle.BackgroundTransparency = 1
    OptTitle.Position = UDim2.new(0, 14, 0, 0)
    OptTitle.Size = UDim2.new(1, -60, 1, 0)
    OptTitle.Font = Enum.Font.GothamBlack
    OptTitle.Text = "OPTIMIZER"
    OptTitle.TextColor3 = b.TEXT
    OptTitle.TextSize = math.floor(15 * AG)
    OptTitle.TextXAlignment = Enum.TextXAlignment.Left
    OptTitle.ZIndex = 13

    -- Содержимое (строки тумблеров)
    local OptBody = Instance.new("Frame", OptWin)
    OptBody.AutomaticSize = Enum.AutomaticSize.Y
    OptBody.Size = UDim2.new(1, -math.floor(12 * AG), 0, 0)
    OptBody.Position = UDim2.new(0, math.floor(6 * AG), 0, math.floor(40 * AG))
    OptBody.BackgroundTransparency = 1
    OptBody.ZIndex = 11
    local OptList = Instance.new("UIListLayout")
    OptList.Padding = UDim.new(0, 6)
    OptList.SortOrder = Enum.SortOrder.LayoutOrder
    OptList.Parent = OptBody

    local OptFPSRow   = HG(OptBody, "FPS Boost", 0)
    local OptStRow    = HG(OptBody, "Game Stretcher", math.floor(42 * AG))
    local OptStFacRow = HG(OptBody, "Stretch Factor", math.floor(84 * AG))
    local OptFovRow   = HG(OptBody, "Camera FOV", math.floor(126 * AG))

    local function _paintOptFps()
        if fpsBoostOn then
            OptFPSRow.stateLabel.Text = "ON"
            OptFPSRow.stateLabel.TextColor3 = Color3.fromRGB(255, 246, 236)
            OptFPSRow.button.BackgroundColor3 = b.GREEN1
            OptFPSRow.knob.BackgroundTransparency = 0
            OptFPSRow.stroke.Color = b.GREEN_STROKE
            OptFPSRow.stroke.Transparency = 0.22
        else
            OptFPSRow.stateLabel.Text = "OFF"
            OptFPSRow.stateLabel.TextColor3 = b.OFF_TEXT
            OptFPSRow.button.BackgroundColor3 = b.OFF_BG
            OptFPSRow.knob.BackgroundTransparency = 1
            OptFPSRow.stroke.Color = b.AQUA_STROKE
            OptFPSRow.stroke.Transparency = 0.55
        end
        OptFPSRow.rowStroke.Transparency = fpsBoostOn and 0.38 or 0.52
    end

    local function _paintOptStretch()
        if gameStretchOn then
            OptStRow.stateLabel.Text = "ON"
            OptStRow.stateLabel.TextColor3 = Color3.fromRGB(255, 246, 236)
            OptStRow.button.BackgroundColor3 = b.GREEN1
            OptStRow.knob.BackgroundTransparency = 0
            OptStRow.stroke.Color = b.GREEN_STROKE
            OptStRow.stroke.Transparency = 0.22
        else
            OptStRow.stateLabel.Text = "OFF"
            OptStRow.stateLabel.TextColor3 = b.OFF_TEXT
            OptStRow.button.BackgroundColor3 = b.OFF_BG
            OptStRow.knob.BackgroundTransparency = 1
            OptStRow.stroke.Color = b.AQUA_STROKE
            OptStRow.stroke.Transparency = 0.55
        end
        OptStRow.rowStroke.Transparency = gameStretchOn and 0.38 or 0.52
    end

    OptFPSRow.button.MouseButton1Click:Connect(function()
        fpsBoostOn = not fpsBoostOn
        i.FPSBoost = fpsBoostOn
        _G.FPSBooster.set(fpsBoostOn)
        U()
        _paintOptFps()
    end)

    OptStRow.button.MouseButton1Click:Connect(function()
        gameStretchOn = not gameStretchOn
        i.GameStretch = gameStretchOn
        _G.GameStretcher.set(gameStretchOn)
        U()
        _paintOptStretch()
    end)

    -- Слайдеры (полоска) для Stretch Factor и Camera FOV
    local function _slider(row, initial, minv, maxv, step, onSet, fmt)
        fmt = fmt or function(v) return string.format("%.2f", v) end
        -- скрыть тумблер-часть строки
        pcall(function()
            if row.button then row.button.Visible = false end
            if row.knob then row.knob.Visible = false end
            if row.stroke then row.stroke.Visible = false end
        end)

        -- Делаем строки слайдеров выше, чтобы подпись не попадала под дорожку.
        pcall(function()
            row.row.ClipsDescendants = false
            row.row.Size = UDim2.new(1, 0, 0, math.floor(48 * AG))
        end)

        local val = math.clamp(tonumber(initial) or minv, minv, maxv)

        -- значение (сверху-справа в строке)
        -- Создаём отдельную метку в строке, так как тумблер-часть строки скрыта.
        pcall(function()
            if row.stateLabel then row.stateLabel:Destroy() end
        end)
        local valLbl = Instance.new("TextLabel", row.row)
        valLbl.Visible = true
        valLbl.Size = UDim2.new(1, -math.floor(16 * AG), 0, math.floor(16 * AG))
        valLbl.Position = UDim2.new(0, math.floor(8 * AG), 0, math.floor(3 * AG))
        valLbl.BackgroundTransparency = 1
        valLbl.Font = Enum.Font.GothamBold
        valLbl.TextSize = math.floor(11 * AG)
        valLbl.TextColor3 = b.TEXT
        valLbl.TextXAlignment = Enum.TextXAlignment.Right
        valLbl.TextYAlignment = Enum.TextYAlignment.Center
        valLbl.ZIndex = 106
        row.stateLabel = valLbl

        -- дорожка
        local track = Instance.new("Frame", row.row)
        track.Name = "SliderTrack"
        track.AnchorPoint = Vector2.new(0.5, 0.5)
        track.Position = UDim2.new(0.5, 0, 1, -math.floor(9 * AG))
        track.Size = UDim2.new(1, -math.floor(24 * AG), 0, math.floor(5 * AG))
        track.BackgroundColor3 = b.OFF_BG
        track.BorderSizePixel = 0
        track.ZIndex = 105
        tG(track, math.floor(4 * AG))

        -- заполнение
        local fill = Instance.new("Frame", track)
        fill.Name = "SliderFill"
        fill.AnchorPoint = Vector2.new(0, 0.5)
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BackgroundColor3 = b.AQUA
        fill.BorderSizePixel = 0
        fill.ZIndex = 107
        tG(fill, math.floor(4 * AG))

        -- ручка
        local knob = Instance.new("Frame", track)
        knob.Name = "SliderKnob"
        knob.AnchorPoint = Vector2.new(0.5, 0.5)
        knob.Position = UDim2.new(0, 0, 0.5, 0)
        knob.Size = UDim2.new(0, math.floor(12 * AG), 0, math.floor(12 * AG))
        knob.BackgroundColor3 = b.TEXT
        knob.BorderSizePixel = 0
        knob.ZIndex = 108
        tG(knob, math.floor(6 * AG))

        local dragging = false

        local function setVal(v)
            v = math.clamp(tonumber(v) or minv, minv, maxv)
            if step and step > 0 then
                v = math.floor(v / step + 0.5) * step
            end
            v = math.clamp(v, minv, maxv)
            val = v
            local frac = (val - minv) / (maxv - minv)
            fill.Size = UDim2.new(frac, 0, 1, 0)
            knob.Position = UDim2.new(frac, 0, 0.5, 0)
            valLbl.Text = fmt(val)
            onSet(val)
        end

        local function pointToVal(px)
            local pos = track.AbsolutePosition
            local w = track.AbsoluteSize.X
            if w <= 0 then return val end
            local frac = math.clamp((px - pos.X) / w, 0, 1)
            return minv + frac * (maxv - minv)
        end

        local function beginDrag(inp)
            if false and i.UILocked then return end
            dragging = true
            setVal(pointToVal(inp.Position.X))
        end
        local function moveDrag(inp)
            if not dragging then return end
            setVal(pointToVal(inp.Position.X))
        end
        local function endDrag()
            dragging = false
        end

        track.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
                or inp.UserInputType == Enum.UserInputType.Touch then
                beginDrag(inp)
            end
        end)
        knob.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
                or inp.UserInputType == Enum.UserInputType.Touch then
                beginDrag(inp)
            end
        end)
        j.InputChanged:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseMovement
                or inp.UserInputType == Enum.UserInputType.Touch then
                moveDrag(inp)
            end
        end)
        j.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
                or inp.UserInputType == Enum.UserInputType.Touch then
                endDrag()
            end
        end)

        setVal(val)
        return setVal
    end

    _slider(OptStFacRow,
        i.gameStretchFactor or 0.75, 0.1, 1.5, 0.05,
        function(v)
            i.gameStretchFactor = v
            _G.GameStretcher.setFactor(v)
            U()
        end
    )

    _slider(OptFovRow,
        i.cameraFOV or 70, 60, 120, 1,
        function(v)
            i.cameraFOV = v
            _G.GameStretcher.setFOV(v)
            U()
        end,
        function(v) return tostring(math.floor(v)) end
    )

    -- Сделать окно перетаскиваемым (позиция сохраняется в i.Positions["Optimizer"])
    pcall(function()
        D(OptHdr, OptWin, "Optimizer")
    end)

    -- Minimize button for Optimizer
    do
        local minB = Instance.new("TextButton", OptHdr)
        minB.Name = "MinimizeBtn"
        minB.Size = UDim2.new(0, 22, 0, 22)
        minB.Position = UDim2.new(1, -26, 0.5, -11)
        minB.BackgroundColor3 = Color3.fromRGB(28, 12, 22)
        minB.Text = "-"
        minB.Font = Enum.Font.GothamBlack
        minB.TextSize = 18
        minB.TextColor3 = Color3.fromRGB(255, 240, 250)
        minB.AutoButtonColor = false
        minB.ZIndex = 200
        Instance.new("UICorner", minB).CornerRadius = UDim.new(0, 10)
        local ms = Instance.new("UIStroke", minB)
        ms.Color = Color3.fromRGB(255, 105, 180)
        ms.Thickness = 1
        ms.Transparency = 0.3
        local restore = Instance.new("TextButton", OptGui)
        restore.Name = "OptimizerRestore"
        restore.Size = UDim2.new(0, 100, 0, 28)
        restore.Position = UDim2.new(0, 12, 0.2, 0)
        restore.BackgroundColor3 = Color3.fromRGB(28, 12, 22)
        restore.Text = "OPTIMIZER"
        restore.Font = Enum.Font.GothamBold
        restore.TextSize = 12
        restore.TextColor3 = Color3.fromRGB(255, 240, 250)
        restore.Visible = false
        restore.AutoButtonColor = false
        restore.ZIndex = 200
        Instance.new("UICorner", restore).CornerRadius = UDim.new(0, 10)
        local rs = Instance.new("UIStroke", restore)
        rs.Color = Color3.fromRGB(255, 105, 180)
        rs.Thickness = 1.2
        rs.Transparency = 0.25
        if MakeDraggable then pcall(MakeDraggable, restore, restore) end
        _G.__optMinimized = false
        minB.MouseButton1Click:Connect(function()
            _G.__optMinimized = true
            OptWin.Visible = false
            restore.Visible = true
            pcall(function()
                restore.Position = UDim2.fromOffset(
                    math.max(8, OptWin.AbsolutePosition.X),
                    math.max(8, OptWin.AbsolutePosition.Y)
                )
            end)
        end)
        restore.MouseButton1Click:Connect(function()
            _G.__optMinimized = false
            OptWin.Visible = true
            restore.Visible = false
        end)
    end

    OptHdr.Active = true
    OptWin.Active = true

    -- O key restores optimizer if minimized
    _G.toggleOptimizerMenu = function()
        _G.__optMinimized = false
        OptWin.Visible = true
        local r = OptGui:FindFirstChild("OptimizerRestore")
        if r then r.Visible = false end
    end

    j.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.KeyCode == Enum.KeyCode.O then
            _G.toggleOptimizerMenu()
        end
    end)

    -- Keep parent alive, but respect user minimize
    pcall(function()
        OptWin.AncestryChanged:Connect(function()
            if OptWin.Parent == nil then
                OptWin.Parent = OptGui
            end
        end)
    end)
    task.spawn(function()
        while true do
            task.wait(0.5)
            pcall(function()
                if OptWin.Parent == nil and OptGui then
                    OptWin.Parent = OptGui
                end
                -- only force visible if user did NOT minimize
                if not _G.__optMinimized and not OptWin.Visible then
                    OptWin.Visible = true
                end
            end)
        end
    end)

    -- FPS optimization is enabled by default so the hub keeps the low-render path active.
    fpsBoostOn = true
    i.FPSBoost = true
    task.defer(function()
        pcall(function() _G.FPSBooster.set(true) end)
        _paintOptFps()
    end)
    if gameStretchOn then
        task.defer(function()
            pcall(function() _G.GameStretcher.set(true) end)
            _paintOptStretch()
        end)
    end
    _paintOptFps()
    _paintOptStretch()

    local function b(KG)
        if not KG then
            return nil
        end
        local oG = cG[KG.uid]
        if oG and oG.Parent then
            return oG
        end
        local oG = a.Plots:FindFirstChild(KG.plot)
        if not oG then
            return nil
        end
        local IG = oG:FindFirstChild("AnimalPodiums")
        if not IG then
            return nil
        end
        local pG = dG(oG.Name)
        local jG = pG and pG.AnimalList
        if not jG then
            local pG = IG:FindFirstChild(KG.slot)
            if pG then
                local lG = pG:FindFirstChild("Base")
                local pG = lG and lG:FindFirstChild("Spawn")
                if pG then
                    local lG = pG:FindFirstChild("PromptAttachment")
                    if lG then
                        for pG, pG in ipairs(lG:GetChildren()) do
                            if pG:IsA("ProximityPrompt") then
                                cG[KG.uid] = pG
                                return pG
                            end
                        end
                    end
                end
            end
            return nil
        end
        if not jG then
            return nil
        end
        local pG = KG.name and KG.name:lower() or ""
        local lG = KG.slot
        local WG = nil
        for XG, tG in pairs(jG) do
            if type(tG) == "table" and tostring(XG) == lG then
                local jG, lG = tG.Index, rG[tG.Index]
                if lG and (lG.DisplayName or jG):lower() == pG then
                    WG = IG:FindFirstChild(tostring(XG))
                    break
                end
            end
        end
        if not WG then
            WG = IG:FindFirstChild(KG.slot)
        end
        if WG then
            local IG = WG:FindFirstChild("Base")
            local jG = IG and IG:FindFirstChild("Spawn")
            if jG then
                local IG = jG:FindFirstChild("PromptAttachment")
                if IG then
                    for lG, lG in ipairs(IG:GetChildren()) do
                        if lG:IsA("ProximityPrompt") and lG.Enabled and lG.ActionText == "Steal" then
                            cG[KG.uid] = lG
                            return lG
                        end
                    end
                end
                local IG = jG.Position
                local jG, lG = IG.X, IG.Z
                local WG = nil
                local XG = math.huge
                for tG, tG in pairs(oG:GetDescendants()) do
                    if tG:IsA("ProximityPrompt") and tG.Enabled and tG.ActionText == "Steal" then
                        local oG = tG.Parent
                        local GG = nil
                        if oG and oG:IsA("BasePart") then
                            GG = oG.Position
                        elseif oG and oG:IsA("Attachment") and oG.Parent and oG.Parent:IsA("BasePart") then
                            GG = oG.Parent.Position
                        end
                        if GG then
                            local oG = IG.Y
                            if pG:find("la secret combinasion") then
                                oG = IG.Y - 5
                            end
                            local IG = math.sqrt((GG.X - jG) ^ 2 + (GG.Z - lG) ^ 2)
                            if IG < 5 and GG.Y > oG then
                                local IG = GG.Y - oG
                                if IG < XG then
                                    XG = IG
                                    WG = tG
                                end
                            end
                        end
                    end
                end
                if WG then
                    cG[KG.uid] = WG
                    return WG
                end
            end
        end
        return nil
    end
    local function KG(oG)
        if qG[oG] then
            return
        end
        local IG = { holdCallbacks = {}, triggerCallbacks = {}, holdEndCallbacks = {}, ready = true }
        local pG, jG = pcall(getconnections, oG.PromptButtonHoldBegan)
        if pG and type(jG) == "table" then
            for pG, pG in ipairs(jG) do
                if type(pG.Function) == "function" then
                    table.insert(IG.holdCallbacks, pG.Function)
                end
            end
        end
        local pG, jG = pcall(getconnections, oG.Triggered)
        if pG and type(jG) == "table" then
            for pG, pG in ipairs(jG) do
                if type(pG.Function) == "function" then
                    table.insert(IG.triggerCallbacks, pG.Function)
                end
            end
        end
        local pG, jG = pcall(getconnections, oG.PromptButtonHoldEnded)
        if pG and type(jG) == "table" then
            for pG, pG in ipairs(jG) do
                if type(pG.Function) == "function" then
                    table.insert(IG.holdEndCallbacks, pG.Function)
                end
            end
        end
        if #IG.holdCallbacks > 0 or #IG.triggerCallbacks > 0 or #IG.holdEndCallbacks > 0 then
            qG[oG] = IG
        end
    end
    local function oG(IG)
        for pG, pG in ipairs(IG) do
            task.spawn(pG)
        end
    end
    local function IG(pG)
        local jG = dG(pG)
        if jG then
            return S(jG.Owner)
        end
        return false
    end
    local function pG()
        local jG = C.Character and C.Character:FindFirstChild("HumanoidRootPart")
        if not jG then
            return nil, math.huge, nil
        end
        local lG = workspace:FindFirstChild("Plots")
        if not lG then
            return nil, math.huge, nil
        end
        local WG, XG, tG = nil, math.huge, nil
        for GG, GG in ipairs(lG:GetChildren()) do
            if IG(GG.Name) then
                continue
            end
            local IG = math.huge
            pcall(function()
                IG = (GG:GetPivot().Position - jG.Position).Magnitude
            end)
            if IG > 100 then
                continue
            end
            local IG = GG:FindFirstChild("AnimalPodiums")
            if not IG then
                continue
            end
            for lG, lG in ipairs(IG:GetChildren()) do
                local IG = lG:FindFirstChild("Base")
                local GG = IG and IG:FindFirstChild("Spawn")
                if not GG then
                    continue
                end
                local IG = (GG.Position - jG.Position).Magnitude
                if IG > 60 or IG >= XG then
                    continue
                end
                local jG = GG:FindFirstChild("PromptAttachment")
                if not jG then
                    continue
                end
                local GG = jG:FindFirstChildOfClass("ProximityPrompt")
                if GG and GG.Parent and GG.Enabled then
                    WG = GG
                    XG = IG
                    tG = lG.Name
                end
            end
        end
        return WG, XG, tG
    end
    local function IG(jG, lG)
        local WG = qG[jG]
        if not WG or not WG.ready then
            return false
        end
        WG.ready = false
        task.spawn(function()
            if BG ~= lG then
                if zG then
                    zG:Cancel()
                end
                wG.Size = UDim2.new(0, 0, 1, 0)
                BG = lG
            end
            if #WG.holdCallbacks > 0 then
                oG(WG.holdCallbacks)
            end
            wG.Size = UDim2.new(0, 0, 1, 0)
            wG.BackgroundTransparency = 0
            zG = f:Create(wG, TweenInfo.new(1.2, Enum.EasingStyle.Linear), { Size = UDim2.new(1, 0, 1, 0) })
            zG:Play()
            zG.Completed:Wait()
            if BG == lG and #WG.triggerCallbacks > 0 then
                oG(WG.triggerCallbacks)
            end
            WG.ready = true
        end)
        return true
    end
    local function oG(jG, lG)
        if not jG or not jG.Parent then
            return false
        end
        KG(jG)
        if not qG[jG] then
            return false
        end
        if BG ~= lG then
            if zG then
                zG:Cancel()
                zG = nil
            end
            wG.Size = UDim2.new(0, 0, 1, 0)
        end
        return IG(jG, lG)
    end
    local function qG()
        for BG, BG in pairs(cG) do
            if BG and BG.Parent then
                KG(BG)
            end
        end
    end
    task.spawn(function()
        while task.wait(2) do
            if nG then
                qG()
            end
        end
    end)
    local KG = {}
    local function qG(BG)
        if not BG then
            return ""
        end
        local IG = ""
        for jG, lG in pairs(BG) do
            if type(lG) == "table" then
                IG = IG .. tostring(jG) .. tostring(lG.Index) .. tostring(lG.Mutation)
            end
        end
        return IG
    end
    local function BG(IG)
        local jG = false
        pcall(function()
            local lG = dG(IG.Name)
            if not lG then
                return
            end
            local WG = lG.AnimalList
            local XG = lG.Owner
            if
                not XG
                or S(XG)
                or typeof(XG) == "Instance" and not r:FindFirstChild(XG.Name)
                or type(XG) == "string" and not r:FindFirstChild(XG)
            then
                KG[IG.Name] = nil
                for S = #yG, 1, -1.0 do
                    if yG[S].plot == IG.Name then
                        table.remove(yG, S)
                        jG = true
                    end
                end
                return
            end
            if not WG then
                KG[IG.Name] = nil
                for S = #yG, 1, -1.0 do
                    if yG[S].plot == IG.Name then
                        table.remove(yG, S)
                        jG = true
                    end
                end
                return
            end
            local S = typeof(XG) == "Instance" and XG.Name or tostring(XG)
            local lG = qG(WG, S)
            if KG[IG.Name] == lG then
                return
            end
            for qG = #yG, 1, -1.0 do
                if yG[qG].plot == IG.Name then
                    table.remove(yG, qG)
                end
            end
            for qG, XG in pairs(WG) do
                if type(XG) == "table" then
                    local WG, tG = XG.Index, rG[XG.Index]
                    if tG then
                        local rG = XG.Mutation or "None"
                        if rG == "Yin Yang" then
                            rG = "YinYang"
                        end
                        local GG = XG.Traits and #XG.Traits > 0 and table.concat(XG.Traits, ", ") or "None"
                        local vG = CG(WG, XG.Mutation, XG.Traits)
                        local CG = "$" .. JG(vG) .. "/s"
                        table.insert(
                            yG,
                            {
                                name = tG.DisplayName or WG,
                                genText = CG,
                                genValue = vG,
                                mutation = rG,
                                traits = GG,
                                owner = S,
                                plot = IG.Name,
                                slot = tostring(qG),
                                uid = IG.Name .. "_" .. tostring(qG),
                            }
                        )
                    end
                end
            end
            KG[IG.Name] = lG
            jG = true
        end)
        if jG then
            table.sort(yG, function(S, CG)
                return S.genValue > CG.genValue
            end)
            P.AllAnimalsCache = yG
            P.ListNeedsRedraw = true
            if P.UpdateAutoStealUI then
                P.UpdateAutoStealUI()
            end
            if not hasShownPriorityAlert and i.AlertsEnabled then
                task.spawn(function()
                    local S = nil
                    for CG = 1, #X do
                        local rG = X[CG]
                        local CG = rG:lower()
                        for rG, rG in ipairs(yG) do
                            if rG.name and rG.name:lower() == CG then
                                S = rG
                                break
                            end
                        end
                        if S then
                            break
                        end
                    end
                    if S then
                        local CG = S.owner
                        local rG = nil
                        local JG = a:FindFirstChild("Plots") and a.Plots:FindFirstChild(S.plot)
                        if JG then
                            local qG = dG(JG.Name)
                            if qG and qG.Owner then
                                local JG = qG.Owner
                                if typeof(JG) == "Instance" then
                                    rG = JG
                                    CG = JG.Name
                                elseif type(JG) == "string" then
                                    CG = JG
                                    rG = r:FindFirstChild(JG)
                                end
                            end
                        end
                        if not rG and CG then
                            rG = r:FindFirstChild(CG)
                        end
                        ShowPriorityAlert(S.name, S.genText, S.mutation, CG)
                    end
                end)
            end
        end
    end
    local function S(CG)
        local rG, JG = nil, 0
        while not rG and JG < 40 do
            rG = dG(CG.Name)
            if not rG then
                JG = JG + 1
                task.wait(0.07)
            end
        end
        if not rG then
            return
        end
        BG(CG)
        local function rG(JG)
            if not JG then
                return
            end
            JG.ChildAdded:Connect(function()
                task.wait(0.15)
                BG(CG)
            end)
            JG.ChildRemoved:Connect(function()
                for JG = #yG, 1, -1.0 do
                    if yG[JG].plot == CG.Name then
                        table.remove(yG, JG)
                    end
                end
                KG[CG.Name] = nil
                _getPetsCache = nil
                for JG in pairs(cG) do
                    if JG:sub(1, #CG.Name) == CG.Name then
                        cG[JG] = nil
                    end
                end
                P.ListNeedsRedraw = true
                if P.UpdateAutoStealUI then
                    P.UpdateAutoStealUI()
                end
                task.wait(0.15)
                BG(CG)
            end)
        end
        local JG = CG:FindFirstChild("AnimalPodiums")
        rG(JG)
        CG.ChildAdded:Connect(function(JG)
            if JG.Name == "AnimalPodiums" then
                rG(JG)
                BG(CG)
            end
        end)
        CG.ChildRemoved:Connect(function(rG)
            if rG.Name == "AnimalPodiums" then
                for rG = #yG, 1, -1.0 do
                    if yG[rG].plot == CG.Name then
                        table.remove(yG, rG)
                    end
                end
                KG[CG.Name] = nil
                _getPetsCache = nil
                P.ListNeedsRedraw = true
                if P.UpdateAutoStealUI then
                    P.UpdateAutoStealUI()
                end
            end
        end)
        task.spawn(function()
            while CG.Parent do
                task.wait(10)
                BG(CG)
            end
        end)
    end
    local CG = a:WaitForChild("Plots", 8)
    if CG then
        for rG, rG in ipairs(CG:GetChildren()) do
            S(rG)
        end
        CG.ChildAdded:Connect(function(rG)
            task.wait(0.5)
            S(rG)
        end)
        CG.ChildRemoved:Connect(function(S)
            KG[S.Name] = nil
            _getPetsCache = nil
            for CG = #yG, 1, -1.0 do
                if yG[CG].plot == S.Name then
                    table.remove(yG, CG)
                end
            end
            for CG in pairs(cG) do
                if CG:sub(1, #S.Name) == S.Name then
                    cG[CG] = nil
                end
            end
            P.ListNeedsRedraw = true
            if P.UpdateAutoStealUI then
                P.UpdateAutoStealUI()
            end
        end)
    end
    local S = false
    local function CG(rG, JG, KG, qG)
        if not i.AlertsEnabled then
            return
        end
        if S then
            return
        end
        local BG = qG and r:FindFirstChild(qG) or nil
        local qG = BG and BG:GetAttribute("__duels_block_steal") == true or false
        local BG = qG and "IN DUEL" or "NOT IN DUEL"
        local IG = qG and Color3.fromRGB(255, 105, 180) or Color3.fromRGB(255, 105, 180)
        local qG = {
            ["rainbow"] = Color3.fromRGB(255, 105, 180),
            ["bloodrot"] = Color3.fromRGB(185, 74, 0),
            ["candy"] = Color3.fromRGB(255, 105, 180),
            ["radioactive"] = Color3.fromRGB(255, 105, 180),
            ["cursed"] = Color3.fromRGB(255, 105, 180),
            ["gold"] = Color3.fromRGB(255, 105, 180),
            ["diamond"] = Color3.fromRGB(255, 105, 180),
            ["yinyang"] = Color3.fromRGB(255, 255, 255),
            ["lava"] = Color3.fromRGB(255, 105, 180),
        }
        local jG = KG and KG:gsub("%s+", ""):lower() or ""
        local KG = qG[jG] or Color3.fromRGB(255, 255, 255)
        local qG = gethui and gethui() or game:GetService("CoreGui")
        local jG = qG:FindFirstChild("XiPriorityAlertTest")
        if jG then
            jG:Destroy()
        end
        local jG = Instance.new("ScreenGui")
        jG.Name = "XiPriorityAlertTest"
        jG.ResetOnSpawn = false
        jG.DisplayOrder = 999
        jG.Parent = qG
        S = true
        local qG = Instance.new("Frame")
        qG.Size = UDim2.new(0, 410, 0, 62)
        qG.Position = UDim2.new(0.5, 0, 0, -76.0)
        qG.AnchorPoint = Vector2.new(0.5, 0)
        qG.BackgroundColor3 = Color3.fromRGB(20, 13, 8)
        qG.BackgroundTransparency = 0.02
        qG.BorderSizePixel = 0
        qG.Parent = jG
        Instance.new("UICorner", qG).CornerRadius = UDim.new(0, 10)
        local lG = Instance.new("Frame", qG)
        lG.Name = "InnerFrame"
        lG.Size = UDim2.new(1, -4.0, 1, -4.0)
        lG.Position = UDim2.new(0, 2, 0, 2)
        lG.BackgroundColor3 = Color3.fromRGB(26, 12, 20)
        lG.BackgroundTransparency = 0.08
        lG.BorderSizePixel = 0
        lG.ZIndex = 0
        Instance.new("UICorner", lG).CornerRadius = UDim.new(0, 10)
        local lG = Instance.new("UIStroke", qG)
        lG.Name = "GlowStroke"
        lG.Thickness = 2.5
        lG.Color = KG
        lG.Transparency = 1
        local WG = Instance.new("Frame", qG)
        WG.Name = "InnerGlow"
        WG.Size = UDim2.new(1, 6, 1, 6)
        WG.Position = UDim2.new(0.5, 0, 0.5, 0)
        WG.AnchorPoint = Vector2.new(0.5, 0.5)
        WG.BackgroundColor3 = KG
        WG.BackgroundTransparency = 1
        WG.ZIndex = 0
        Instance.new("UICorner", WG).CornerRadius = UDim.new(0, 10)
        local XG = Instance.new("TextLabel", qG)
        XG.Size = UDim2.new(1, -30.0, 0, 24)
        XG.Position = UDim2.new(0, 15, 0, 10)
        XG.BackgroundTransparency = 1
        XG.Text = rG .. " - " .. JG
        XG.Font = Enum.Font.GothamBlack
        XG.TextSize = 18
        XG.TextColor3 = KG
        XG.TextXAlignment = Enum.TextXAlignment.Center
        XG.TextStrokeTransparency = 0
        XG.TextStrokeColor3 = Color3.fromRGB(80, 20, 60)
        local rG = Instance.new("TextLabel", qG)
        rG.Size = UDim2.new(1, -30.0, 0, 14)
        rG.Position = UDim2.new(0, 15, 0, 38)
        rG.BackgroundTransparency = 1
        rG.Text = BG
        rG.Font = Enum.Font.GothamBold
        rG.TextSize = 17
        rG.TextColor3 = IG
        rG.TextXAlignment = Enum.TextXAlignment.Center
        rG.TextStrokeColor3 = KG
        f:Create(
            qG,
            TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            { Position = UDim2.new(0.5, 0, 0, 22) }
        ):Play()
        if i.AlertSoundID and i.AlertSoundID ~= "" then
            local rG = Instance.new("Sound")
            rG.SoundId = i.AlertSoundID
            rG.Volume = 0.5
            rG.Parent = qG
            rG:Play()
            f:Create(
                lG,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { Transparency = 0 }
            ):Play()
            f:Create(
                WG,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { BackgroundTransparency = 0.85 }
            ):Play()
            task.delay(0.4, function()
                f:Create(
                    lG,
                    TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    { Transparency = 0.6 }
                ):Play()
                f:Create(
                    WG,
                    TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    { BackgroundTransparency = 1 }
                ):Play()
            end)
            rG.Ended:Connect(function()
                rG:Destroy()
            end)
        end
        task.delay(4, function()
            f:Create(
                qG,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                { Position = UDim2.new(0.5, 0, 0, -76.0) }
            ):Play()
            task.wait(0.35)
            jG:Destroy()
        end)
    end
    task.spawn(function()
        task.wait(0.5)
        while true do
            task.wait(0.5)
            if not S and i.AlertsEnabled and #yG > 0 then
                local S = nil
                for rG = 1, #X do
                    local JG = X[rG]
                    local rG = JG:lower()
                    for JG, JG in ipairs(yG) do
                        if JG.name and JG.name:lower() == rG then
                            S = JG
                            break
                        end
                    end
                    if S then
                        break
                    end
                end
                if S then
                    local rG = S.owner
                    local JG = nil
                    local KG = a:FindFirstChild("Plots") and a.Plots:FindFirstChild(S.plot)
                    if KG then
                        local qG = dG(KG.Name)
                        if qG and qG.Owner then
                            local dG = qG.Owner
                            if typeof(dG) == "Instance" then
                                JG = dG
                                rG = dG.Name
                            elseif type(dG) == "string" then
                                rG = dG
                                JG = r:FindFirstChild(dG)
                            end
                        end
                    end
                    if not JG and rG then
                        JG = r:FindFirstChild(rG)
                    end
                    CG(S.name, S.genText, S.mutation, rG)
                end
            end
        end
    end)
    local function S(CG)
        if #CG == 0 then
            return
        end
        if UG then
            for rG, dG in ipairs(CG) do
                if dG.uid == UG then
                    if iG ~= rG then
                        iG = rG
                        OG = dG.uid
                    end
                    MG.Text = string.format("%s - %s", dG.petName or "Unknown", dG.mpsText or "")
                    return
                end
            end
            UG = nil
        end
        if eG then
            for rG, rG in ipairs(X) do
                local dG = rG:lower()
                for rG, JG in ipairs(CG) do
                    if JG.petName and JG.petName:lower() == dG then
                        if iG ~= rG then
                            iG = rG
                            OG = JG.uid
                        end
                        return
                    end
                end
            end
            if iG ~= 1 then
                iG = 1
                OG = CG[1] and CG[1].uid
            end
        elseif fG then
            local rG = C.Character
            local dG = rG and rG:FindFirstChild("HumanoidRootPart")
            if dG then
                local rG, JG = 1, math.huge
                for eG, KG in ipairs(CG) do
                    local qG = KG.animalData and M(KG.animalData)
                    if qG and qG:IsA("BasePart") then
                        local KG = (dG.Position - qG.Position).Magnitude
                        if KG < JG then
                            JG = KG
                            rG = eG
                        end
                    end
                end
                if CG[rG] then
                    local dG = CG[rG]
                    MG.Text = string.format("%s - %s", dG.petName or "Unknown", dG.mpsText or "")
                end
                if not xG and iG ~= rG then
                    iG = rG
                    OG = CG[rG] and CG[rG].uid
                end
            end
        elseif aG then
            if iG ~= 1 then
                iG = 1
                OG = CG[1] and CG[1].uid
            end
        end
    end
    R.Heartbeat:Connect(function()
        if not nG then
            return
        end
        S(TG())
    end)
    task.spawn(function()
        while true do
            task.wait(0.5)
            if nG then
                local S = TG()
                if #S > 0 then
                    P.ListNeedsRedraw = false
                    sG(nG, S)
                end
            end
        end
    end)
    R.Heartbeat:Connect(function()
        if not nG then
            return
        end
        if xG then
            if zG then
                zG:Cancel()
                zG = nil
            end
            wG.Size = UDim2.new(1, 0, 1, 0)
            wG.BackgroundTransparency = 0
            if not VG then
                VG = true
                task.spawn(function()
                    if not game:IsLoaded() then
                        game.Loaded:Wait()
                    end
                    task.wait(0.5)
                    QG = true
                end)
            end
            if QG then
                if fG and not UG then
                    local S, CG, rG = pG()
                    if S and CG <= 60 then
                    end
                else
                    local S = TG()
                    if #S > 0 then
                        if iG > #S then
                            iG = #S
                        end
                        if iG < 1 then
                            iG = 1
                        end
                        local CG = S[iG]
                        if CG and not YG(CG.animalData) then
                            local S = cG[CG.uid]
                            if not S or not S.Parent then
                                S = b(CG.animalData)
                            end
                            if S then
                            end
                        end
                    end
                end
            end
            return
        end
        local S = TG()
        if #S == 0 then
            return
        end
        if iG > #S then
            iG = #S
        end
        if iG < 1 then
            iG = 1
        end
        local CG = S[iG]
        if not CG or YG(CG.animalData) then
            return
        end
        local S = cG[CG.uid]
        if not S or not S.Parent then
            S = b(CG.animalData)
        end
        if S then
            oG(S, CG.uid)
        end
    end)
    task.spawn(function()
        while task.wait(0.5) do
            sG(nG, TG())
        end
    end)
    task.spawn(function()
        task.wait(1)
        P.ListNeedsRedraw = true
        sG(nG, TG())
    end)
    task.spawn(function()
        while true do
            P.AllAnimalsCache = yG
            task.wait(0.5)
        end
    end)
    local b = nil
    local S = nil
    local CG = nil
    local function rG()
        if not nG or not i.TracerEnabled or i.StealNearest then
            if b then
                b:Destroy()
                b = nil
            end
            if S then
                S:Destroy()
                S = nil
            end
            if CG then
                CG:Destroy()
                CG = nil
            end
            return
        end
        local dG = TG()
        if #dG == 0 then
            if b then
                b.Enabled = false
            end
            return
        end
        if iG > #dG then
            iG = #dG
        end
        if iG < 1 then
            iG = 1
        end
        local nG = dG[iG] or dG[1]
        local dG = M(nG.animalData)
        local fG = C.Character
        local JG = fG and fG:FindFirstChild("HumanoidRootPart")
        if JG and dG then
            if not S or S.Parent ~= JG then
                if S then
                    S:Destroy()
                end
                S = Instance.new("Attachment", JG)
            end
            if not CG or CG.Parent ~= dG then
                if CG then
                    CG:Destroy()
                end
                CG = Instance.new("Attachment", dG)
            end
            if not b then
                b = Instance.new("Beam", JG)
                b.FaceCamera = true
                b.Width0 = 0.8
                b.Width1 = 0.8
                b.TextureMode = Enum.TextureMode.Static
                b.TextureSpeed = 3
            end
            b.Attachment0 = S
            b.Attachment1 = CG
            b.Enabled = true
            local S = {
                Cursed = Color3.fromRGB(255, 105, 180),
                Gold = Color3.fromRGB(255, 105, 180),
                Diamond = Color3.fromRGB(255, 105, 180),
                YinYang = Color3.fromRGB(255, 246, 236),
                Rainbow = Color3.fromRGB(255, 105, 180),
                Lava = Color3.fromRGB(255, 105, 180),
                Candy = Color3.fromRGB(255, 105, 180),
                Divine = Color3.fromRGB(255, 255, 255),
            }
            local CG = nG and nG.mutation and S[nG.mutation] or W.Accent1
            b.Color = ColorSequence.new(CG)
        else
            if b then
                b.Enabled = false
            end
        end
    end
    R.Heartbeat:Connect(rG)
end)task.spawn(function()
    local StatusGui = gethui and gethui() or game:GetService("CoreGui")
    for _, old in ipairs(StatusGui:GetChildren()) do
        if old.Name == "XiBottomStatus" then
            pcall(function() old:Destroy() end)
        end
    end
    local sg = Instance.new("ScreenGui")
    sg.Name = "XiBottomStatus"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 999
    sg.Parent = StatusGui

    local BarSize = UDim2.new(0, 500, 0, 40)
    local Bar = Instance.new("Frame", sg)
    Bar.Name = "Bar"
    Bar.AnchorPoint = Vector2.new(0.5, 1)
    Bar.Size = BarSize
    Bar.Position = UDim2.new(0.5, 0, 1, -150)
    Bar.BackgroundColor3 = Color3.fromRGB(55, 20, 42)
    Bar.BackgroundTransparency = 0.08
    Bar.BorderSizePixel = 0
    Bar.ZIndex = 1
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(0, 10)
    local barGrad = Instance.new("UIGradient", Bar)
    barGrad.Rotation = 90
    barGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(85, 30, 65)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 22, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 15, 35)),
    })
    local barStroke = Instance.new("UIStroke", Bar)
    barStroke.Color = Color3.fromRGB(255, 105, 180)
    barStroke.Thickness = 1
    barStroke.Transparency = 0.3
    local barGlow = Instance.new("UIStroke", Bar)
    barGlow.Color = Color3.fromRGB(255, 20, 147)
    barGlow.Thickness = 3
    barGlow.Transparency = 0.86
    barGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- brand
    local Brand = Instance.new("TextLabel", Bar)
    Brand.Size = UDim2.new(0.55, 0, 1, 0)
    Brand.Position = UDim2.fromOffset(16, 0)
    Brand.BackgroundTransparency = 1
    Brand.Text = "candy tp - discord.gg/usYtFqxQdN"
    Brand.Font = Enum.Font.GothamBlack
    Brand.TextSize = 11
    Brand.TextColor3 = Color3.fromRGB(255, 246, 236)
    Brand.TextXAlignment = Enum.TextXAlignment.Left
    Brand.TextYAlignment = Enum.TextYAlignment.Center
    Brand.ZIndex = 2
    Brand.TextStrokeTransparency = 0.9

    -- separators
    local function sep(x)
        local s = Instance.new("Frame", Bar)
        s.Size = UDim2.new(0, 1, 0, 18)
        s.Position = UDim2.new(0, x, 0.5, -9)
        s.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
        s.BackgroundTransparency = 0.35
        s.BorderSizePixel = 0
        s.ZIndex = 2
    end
    sep(330)
    sep(420)

    local function metric(x, label)
        local lbl = Instance.new("TextLabel", Bar)
        lbl.Size = UDim2.new(0, 80, 0, 15)
        lbl.Position = UDim2.new(0, x, 0, 5)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 9
        lbl.TextColor3 = Color3.fromRGB(160, 100, 140)
        lbl.TextXAlignment = Enum.TextXAlignment.Center
        lbl.ZIndex = 2
        local val = Instance.new("TextLabel", Bar)
        val.Size = UDim2.new(0, 80, 0, 18)
        val.Position = UDim2.new(0, x, 0, 18)
        val.BackgroundTransparency = 1
        val.Text = "0"
        val.Font = Enum.Font.GothamBlack
        val.TextSize = 14
        val.TextColor3 = Color3.fromRGB(255, 246, 236)
        val.TextXAlignment = Enum.TextXAlignment.Center
        val.TextYAlignment = Enum.TextYAlignment.Top
        val.ZIndex = 2
        return val
    end

    local fpsVal = metric(332, "FPS")
    local pingVal = metric(422, "PING")

    -- stats
    local frames = 0
    local last = tick()
    R.Heartbeat:Connect(function()
        frames = frames + 1
        local now = tick()
        if now - last >= 1 then
            fpsVal.Text = tostring(frames)
            local f = frames
            if f >= 60 then
                fpsVal.TextColor3 = Color3.fromRGB(255, 105, 180)
            elseif f >= 30 then
                fpsVal.TextColor3 = Color3.fromRGB(255, 105, 180)
            else
                fpsVal.TextColor3 = Color3.fromRGB(255, 105, 180)
            end
            frames = 0
            last = now
        end
    end)
    task.spawn(function()
        while sg and sg.Parent do
            local p = math.floor(C:GetNetworkPing() * 1000)
            pingVal.Text = tostring(p) .. "ms"
            if p < 80 then
                pingVal.TextColor3 = Color3.fromRGB(255, 105, 180)
            elseif p < 150 then
                pingVal.TextColor3 = Color3.fromRGB(255, 105, 180)
            else
                pingVal.TextColor3 = Color3.fromRGB(255, 105, 180)
            end
            task.wait(0.5)
        end
    end)
end)


-- ===================== INFINITE JUMP =====================
do
    local INF = { enabled = false, lastJump = 0, power = 47 }
    getgenv().InfJump = INF
    local JumpGui = gethui and gethui() or game:GetService("CoreGui")
    for _, old in ipairs(JumpGui:GetChildren()) do
        if old.Name == "XiInfJump" then
            pcall(function() old:Destroy() end)
        end
    end
    local sg = Instance.new("ScreenGui")
    sg.Name = "XiInfJump"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 999
    sg.Parent = JumpGui

    local btn = Instance.new("TextButton", sg)
    btn.Size = d and UDim2.new(0, 190, 0, 40) or UDim2.new(0, 150, 0, 30)
    btn.Position = d and UDim2.new(1, -202, 0.03, 0) or UDim2.new(1, -162, 0.03, 0)
    btn.BackgroundColor3 = Color3.fromRGB(10, 4, 8)
    btn.BackgroundTransparency = 0.06
    btn.Text = "INFINITE JUMP: OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(160, 100, 140)
    btn.AutoButtonColor = false
    btn.ZIndex = 2
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    local bs = Instance.new("UIStroke", btn)
    bs.Color = Color3.fromRGB(255, 105, 180)
    bs.Thickness = 1
    bs.Transparency = 0.4

    local save, load
    local function setOn(on)
        INF.enabled = on
        if on then
            btn.Text = "INFINITE JUMP: ON"
            btn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
            btn.TextColor3 = Color3.fromRGB(255, 246, 236)
            bs.Transparency = 0.1
        else
            btn.Text = "INFINITE JUMP: OFF"
            btn.BackgroundColor3 = Color3.fromRGB(10, 4, 8)
            btn.TextColor3 = Color3.fromRGB(160, 100, 140)
            bs.Transparency = 0.4
        end
        save()
    end

    local function toggle()
        setOn(not INF.enabled)
    end

    -- -------- settings persistence (position / on-off / power) --------
    local SAVE_FILE = "candytpHub_InfJump.json"
    save = function()
        pcall(function()
            if writefile then
                writefile(SAVE_FILE, J:JSONEncode({
                    x = btn.Position.X.Offset,
                    y = btn.Position.Y.Offset,
                    enabled = INF.enabled == true,
                    power = INF.power,
                }))
            end
        end)
    end
    load = function()
        pcall(function()
            if readfile and isfile and isfile(SAVE_FILE) then
                local data = J:JSONDecode(readfile(SAVE_FILE))
                if type(data) == "table" then
                    local view = Q and Q.ViewportSize or Vector2.new(1920, 1080)
                    local w = btn.Size.X.Offset or 150
                    local h = btn.Size.Y.Offset or 30
                    if typeof(data.x) == "number" and typeof(data.y) == "number" then
                        btn.Position = UDim2.new(
                            0,
                            math.clamp(data.x, 0, view.X - w),
                            0,
                            math.clamp(data.y, 0, view.Y - h)
                        )
                    end
                    if typeof(data.power) == "number" then
                        INF.power = data.power
                    end
                    if data.enabled == true then
                        setOn(true)
                    end
                end
            end
        end)
    end
    load()
    j.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.KeyCode == Enum.KeyCode.H then
            toggle()
        end
    end)

    -- Drag the jump button anywhere. A plain click (no movement) still toggles;
    -- if you actually drag it, it moves and does NOT toggle.
    local dragging = false
    local didMove = false
    local tMoved = 0
    local startMouse = Vector2.new()
    local startPos = btn.Position
    btn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            didMove = false
            tMoved = tick()
            startMouse = inp.Position
            startPos = btn.Position
        end
    end)
    btn.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            if didMove then
                save()
            elseif (tick() - tMoved) < 0.7 then
                toggle()
            end
        end
    end)
    j.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local dx = inp.Position.X - startMouse.X
            local dy = inp.Position.Y - startMouse.Y
            if (dx * dx + dy * dy) > 25 then
                didMove = true
            end
            local view = Q and Q.ViewportSize or Vector2.new(1920, 1080)
            local newX = math.clamp(startPos.X.Offset + dx, 0, view.X - (btn.Size.X.Offset or 150))
            local newY = math.clamp(startPos.Y.Offset + dy, 0, view.Y - (btn.Size.Y.Offset or 30))
            btn.Position = UDim2.new(0, newX, 0, newY)
        end
    end)

    -- Infinite jump: PC (Space held) + mobile (on-screen jump button / JumpRequest /
    -- Humanoid.Jump), so it also works on Delta and other mobile executors.
    local touchHeld = false
    local function boost()
        local now = tick()
        if now - INF.lastJump < 0.1 then return end
        local char = C.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end
        INF.lastJump = now
        local v = hrp.AssemblyLinearVelocity
        hrp.AssemblyLinearVelocity = Vector3.new(v.X, INF.power, v.Z)
    end
    R.Heartbeat:Connect(function()
        if not INF.enabled then return end
        local held = j:IsKeyDown(Enum.KeyCode.Space) or touchHeld
        if not held then
            local char = C.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Jump then held = true end
        end
        if held then boost() end
    end)
    pcall(function()
        j.JumpRequest:Connect(function()
            if INF.enabled then boost() end
        end)
    end)
    task.spawn(function()
        local bound
        while true do
            task.wait(1.5)
            pcall(function()
                local pg = C:FindFirstChild("PlayerGui")
                local tg = pg and pg:FindFirstChild("TouchGui")
                local fr = tg and tg:FindFirstChild("TouchControlFrame")
                local jb = fr and fr:FindFirstChild("JumpButton")
                if jb and jb ~= bound then
                    bound = jb
                    jb.InputBegan:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.Touch then
                            touchHeld = true
                            inp.Changed:Connect(function()
                                if inp.UserInputState == Enum.UserInputState.End then touchHeld = false end
                            end)
                        end
                    end)
                    jb.InputEnded:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.Touch then touchHeld = false end
                    end)
                end
            end)
        end
    end)
end
-- =================== END INFINITE JUMP ===================


do
--//======================================================
--// NEXT BASE + GUI
--//======================================================

----------------------------------------------------------
-- CLEAN OLD VERSION
----------------------------------------------------------

if _G.__CombinedBasePodiumCleanup then
	pcall(_G.__CombinedBasePodiumCleanup)
end

if _G.__NextBaseCleanup then
	pcall(_G.__NextBaseCleanup)
end

----------------------------------------------------------
-- SERVICES
----------------------------------------------------------

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Plots = workspace:WaitForChild("Plots")

local hui = (gethui and gethui()) or CoreGui

----------------------------------------------------------
-- PODIUM SLOTS PURPLE v2 (встроенный модуль с вкл/выкл)
----------------------------------------------------------
-- Наверху добавлена функция включения/выключения подсветки подиумов:
--   _G.__PodiumSlotsSetEnabled(true/false)  — включить / выключить
--   _G.__PodiumSlotsToggle()                — переключить состояние
--   _G.__PodiumSlotsEnabled()               — вернуть текущее состояние
-- Плюс кнопка "Pods" на панели.
----------------------------------------------------------

local PodiumSlots = (function()
    local RunServiceP  = game:GetService("RunService")
    local WorkspaceP   = game:GetService("Workspace")

    local uiParent
    pcall(function()
        uiParent = (gethui and gethui()) or game:GetService("CoreGui")
    end)
    if not uiParent then uiParent = game:GetService("CoreGui") end

    -- НАСТРОЙКИ
    local RED         = Color3.fromRGB(248, 132, 55)
    local FILL_TRANS  = 0.5
    local GHOST_TRANS = 0.62
    local EDGE_THICK  = 0.06
    local PULSE_ON    = true

    local OUTER       = Vector3.new(6, 0.25, 6)
    local INNER       = Vector3.new(4, 0.25, 4)
    local INNER_UP    = 0.25
    local MAX_PER_PLOT= 40

    local COLLIDE           = true
    local STAND_ON_OCCUPIED = false
    local PLATFORM_OFFSET   = 0

    local TEMPLATE = {
        { 18.500,  1.531, -14.476,  90}, { 18.500,  1.531,  -6.976,  90}, { 18.500,  1.531,   0.524,  90},
        { 18.500,  1.531,   8.024,  90}, { 18.500,  1.531,  15.524,  90},
        {-18.536,  1.531,  15.524, -90}, {-18.536,  1.531,   8.024, -90}, {-18.536,  1.531,   0.524, -90},
        {-18.536,  1.531,  -6.976, -90}, {-18.536,  1.531, -14.476, -90},
        { 18.500, 19.531, -14.476,  90}, { 18.500, 19.531,  -6.976,  90}, { 18.500, 19.531,   0.524,  90},
        { 18.500, 19.531,   8.024,  90}, { 18.500, 19.531,  15.524,  90},
        {-18.380, 19.531, -14.452, -90}, {-18.380, 19.531,  -6.952, -90}, {-18.380, 19.531,   0.548, -90},
        { 18.500, 36.531, -12.476,  90}, { 18.500, 36.531,  -4.976,  90}, { 18.500, 36.531,   2.524,  90},
        { 18.500, 36.531,  10.024,  90}, { 18.500, 36.531,  17.524,  90},
        {-18.472, 36.531, -12.501, -90}, {-18.471, 36.531,  -5.001, -90}, {-18.471, 36.531,   2.499, -90},
        {-18.471, 36.531,   9.999, -90}, {-18.471, 36.531,  17.499, -90},
    }

    local markers, fills, conns = {}, {}, {}
    local solids = nil
    local alive  = false
    local started = false

    local function clear()
        for _, m in ipairs(markers) do pcall(function() m:Destroy() end) end
        markers, fills = {}, {}
        if solids then pcall(function() solids:ClearAllChildren() end) end
    end

    local function addPlatform(worldCF)
        if not solids then
            solids = Instance.new("Folder")
            solids.Name = "__PodiumPurpleV2Collide"
            solids.Parent = WorkspaceP
        end
        local p = Instance.new("Part")
        p.Anchored = true
        p.CanCollide = true
        p.CanQuery = false
        p.CanTouch = false
        p.Transparency = 1
        p.Size = OUTER
        p.CFrame = worldCF * CFrame.new(0, PLATFORM_OFFSET, 0)
        p.Parent = solids
    end

    local function keep(obj) markers[#markers + 1] = obj; return obj end

    local function redBox(adornee, relCF, size, trans, pulseable)
        local a = Instance.new("BoxHandleAdornment")
        a.Adornee = adornee
        a.CFrame = relCF
        a.Size = size
        a.Color3 = RED
        a.Transparency = trans
        a.AlwaysOnTop = false
        a.ZIndex = 0
        a.Parent = uiParent
        keep(a)
        if pulseable then fills[#fills + 1] = { a = a, base = trans } end
        return a
    end

    local function redOutline(part)
        local b = Instance.new("SelectionBox")
        b.Adornee = part
        b.Color3 = RED
        b.SurfaceColor3 = RED
        b.LineThickness = EDGE_THICK
        b.Transparency = 0
        b.SurfaceTransparency = 1
        b.Parent = uiParent
        return keep(b)
    end

    local function redEdges(root, cf, size)
        local t = EDGE_THICK * 2
        local hx, hz, y = size.X * 0.5, size.Z * 0.5, size.Y * 0.5
        redBox(root, cf * CFrame.new(0, y,  hz), Vector3.new(size.X, t, t), 0)
        redBox(root, cf * CFrame.new(0, y, -hz), Vector3.new(size.X, t, t), 0)
        redBox(root, cf * CFrame.new( hx, y, 0), Vector3.new(t, t, size.Z), 0)
        redBox(root, cf * CFrame.new(-hx, y, 0), Vector3.new(t, t, size.Z), 0)
    end

    local function slabsOf(slot)
        local base = slot:FindFirstChild("Base") or slot
        local decos = base:FindFirstChild("Decorations")
        local parts = {}
        if decos then
            for _, c in ipairs(decos:GetChildren()) do
                if c:IsA("BasePart") and c.Transparency < 1 then parts[#parts + 1] = c end
            end
        end
        table.sort(parts, function(a, b) return (a.Size.X * a.Size.Z) > (b.Size.X * b.Size.Z) end)
        return parts
    end

    local function drawOccupied(parts)
        local anchor = parts[1]
        for i, p in ipairs(parts) do
            if i <= MAX_PER_PLOT then
                local rel = anchor.CFrame:Inverse() * p.CFrame
                local baseTrans = (i == 1) and FILL_TRANS or (FILL_TRANS + 0.1)
                redBox(anchor, rel, p.Size + Vector3.new(0.05, 0.05, 0.05), baseTrans, i == 1)
                redOutline(p)
            end
        end
    end

    local function drawGhost(root, e, cf)
        redBox(root, cf, OUTER, GHOST_TRANS, true)
        redBox(root, cf * CFrame.new(0, INNER_UP, 0), INNER, GHOST_TRANS + 0.05, false)
        redEdges(root, cf, OUTER)
    end

    local function slotWorldCF(root, e)
        local cf = CFrame.new(e[1], e[2], e[3]) * CFrame.Angles(0, math.rad(e[4]), 0)
        return root.CFrame * cf
    end

    local function buildPlot(plot)
        if not alive then return end
        local root = plot:FindFirstChild("MainRoot")
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not (root and pods) then return end
        for i = 1, #TEMPLATE do
            local e = TEMPLATE[i]
            local sl = pods:FindFirstChild(tostring(i))
            local parts = sl and slabsOf(sl)
            if parts and parts[1] then
                drawOccupied(parts)
                if COLLIDE and STAND_ON_OCCUPIED then addPlatform(slotWorldCF(root, e)) end
            else
                local cf = CFrame.new(e[1], e[2], e[3]) * CFrame.Angles(0, math.rad(e[4]), 0)
                drawGhost(root, e, cf)
                if COLLIDE then addPlatform(slotWorldCF(root, e)) end
            end
        end
    end

    local pending = false
    local function rebuildAll()
        clear()
        for _, plot in ipairs(Plots:GetChildren()) do pcall(buildPlot, plot) end
    end
    local function scheduleRebuild()
        if pending or not alive then return end
        pending = true
        task.delay(0.3, function() pending = false; rebuildAll() end)
    end
    local function watchPlot(plot)
        local pods = plot:WaitForChild("AnimalPodiums", 20)
        if pods and alive then
            conns[#conns + 1] = pods.ChildAdded:Connect(scheduleRebuild)
            conns[#conns + 1] = pods.ChildRemoved:Connect(scheduleRebuild)
        end
    end

    local function disconnectAll()
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        conns = {}
    end

    -- ПУБЛИЧНЫЕ ФУНКЦИИ
    local M = {}
    function M.setOn(on)
        on = on and true or false
        if on == started then return end
        if on then
            if _G.__PodiumRedV2Cleanup then pcall(_G.__PodiumRedV2Cleanup) end
            alive = true
            started = true
            rebuildAll()
            for _, plot in ipairs(Plots:GetChildren()) do task.spawn(watchPlot, plot) end
            conns[#conns + 1] = Plots.ChildAdded:Connect(function(plot)
                task.spawn(watchPlot, plot)
                scheduleRebuild()
            end)
            local acc = 0
            conns[#conns + 1] = RunServiceP.Heartbeat:Connect(function(dt)
                if not PULSE_ON then return end
                acc = acc + dt
                if acc < 0.05 then return end
                acc = 0
                local w = math.sin(os.clock() * 2.2) * 0.08
                for _, f in ipairs(fills) do
                    if f.a.Parent then f.a.Transparency = math.clamp(f.base + w, 0, 1) end
                end
            end)
        else
            alive = false
            started = false
            disconnectAll()
            clear()
            if solids then pcall(function() solids:Destroy() end); solids = nil end
        end
    end
    function M.toggle() M.setOn(not started) end
    function M.isOn() return started end
    return M
end)()

-- Глобальная функция вкл/выкл подиумов (доступна после инжекта)
_G.__PodiumSlotsSetEnabled = function(on)
    pcall(function() PodiumSlots.setOn(on) end)
end
_G.__PodiumSlotsToggle = function()
    pcall(function() PodiumSlots.toggle() end)
end
_G.__PodiumSlotsEnabled = function()
    return PodiumSlots.isOn()
end

----------------------------------------------------------
-- SETTINGS
----------------------------------------------------------

local COLOR = Color3.fromRGB(204, 108, 45)

local nextEnabled = true
local soundEnabled = true
local fullEnabled = true
local locked = false
local podiumOn = false

----------------------------------------------------------
--======================================================
-- NEXT BASE
--======================================================
----------------------------------------------------------

local BASE_POSITIONS = {
	Vector3.new(-342.439, 10.399, 113.107),
	Vector3.new(-342.439, 10.465, 6.107),
	Vector3.new(-476.752, 10.465, 114.107),
	Vector3.new(-476.752, 10.465, 7.107),
	Vector3.new(-342.440, 10.464, 220.107),
	Vector3.new(-476.752, 10.465, 221.107),
	Vector3.new(-342.439, 10.465, -100.893),
	Vector3.new(-476.752, 10.465, -99.893),
}

local MATCH_TOL = 6
local EMPTY_TEXT = "Empty Base"
local ARROW = utf8.char(0x2B07)

local bases = {}
local baseConnected = {}
local baseConns = {}

----------------------------------------------------------
-- NEXT BASE ANCHOR
----------------------------------------------------------

local baseAnchor = Instance.new("Part")
baseAnchor.Name = "__NextBaseAnchor"
baseAnchor.Anchored = true
baseAnchor.CanCollide = false
baseAnchor.CanQuery = false
baseAnchor.CanTouch = false
baseAnchor.Transparency = 1
baseAnchor.Size = Vector3.new(1, 1, 1)
baseAnchor.Parent = CoreGui

local baseBillboard = Instance.new("BillboardGui")
baseBillboard.Name = "NextBaseBillboard"
baseBillboard.Adornee = baseAnchor
baseBillboard.Size = UDim2.fromScale(32, 13)
baseBillboard.StudsOffset = Vector3.new(0, 10, 0)
baseBillboard.MaxDistance = math.huge
baseBillboard.AlwaysOnTop = true
baseBillboard.LightInfluence = 0
baseBillboard.Enabled = true
baseBillboard.Parent = baseAnchor

local baseTop = Instance.new("TextLabel")
baseTop.BackgroundTransparency = 1
baseTop.AnchorPoint = Vector2.new(0.5, 0.5)
baseTop.Position = UDim2.fromScale(0.5, 0.30)
baseTop.Size = UDim2.fromScale(0.95, 0.50)
baseTop.Font = Enum.Font.GothamBlack
baseTop.Text = ARROW .. "  NEXT  " .. ARROW
baseTop.TextScaled = true
baseTop.TextColor3 = Color3.fromRGB(255, 105, 180)
baseTop.TextStrokeColor3 = Color3.fromRGB(120, 40, 90)
baseTop.TextStrokeTransparency = 0
baseTop.Parent = baseBillboard

local baseBottom = Instance.new("TextLabel")
baseBottom.BackgroundTransparency = 1
baseBottom.AnchorPoint = Vector2.new(0.5, 0.5)
baseBottom.Position = UDim2.fromScale(0.5, 0.72)
baseBottom.Size = UDim2.fromScale(0.95, 0.42)
baseBottom.Font = Enum.Font.GothamBlack
baseBottom.Text = "EMPTY BASE"
baseBottom.TextScaled = true
baseBottom.TextColor3 = Color3.fromRGB(255, 255, 255)
baseBottom.TextStrokeColor3 = Color3.fromRGB(120, 40, 90)
baseBottom.TextStrokeTransparency = 0
baseBottom.Parent = baseBillboard

----------------------------------------------------------
-- NEXT BASE FUNCTIONS
----------------------------------------------------------

local function baseIndexFor(model)
	local ok, cf = pcall(function()
		return model:GetBoundingBox()
	end)

	if not ok then
		return nil
	end

	local p = cf.Position
	local bestI
	local bestD

	for i, bp in ipairs(BASE_POSITIONS) do
		local dx = p.X - bp.X
		local dz = p.Z - bp.Z
		local d = math.sqrt(dx * dx + dz * dz)

		if not bestD or d < bestD then
			bestI = i
			bestD = d
		end
	end

	return bestD and bestD <= MATCH_TOL and bestI or nil
end

local function isEmpty(label)
	return label.Text:gsub("^%s+", ""):gsub("%s+$", "") == EMPTY_TEXT
end

local function recomputeNextBase()
	if not nextEnabled then
		baseBillboard.Enabled = false
		return
	end

	local targetIdx

	for i = 1, #BASE_POSITIONS do
		local b = bases[i]

		if b and b.label and isEmpty(b.label) then
			targetIdx = i
			break
		end
	end

	if targetIdx then
		baseAnchor.CFrame = bases[targetIdx].cf
		baseBillboard.Enabled = true
	else
		baseBillboard.Enabled = false
	end
end

local function connectBaseLabel(label)
	if baseConnected[label] then
		return
	end

	baseConnected[label] = true

	table.insert(
		baseConns,
		label:GetPropertyChangedSignal("Text"):Connect(recomputeNextBase)
	)
end

local function scanBases()
	for _, plot in ipairs(Plots:GetChildren()) do
		local sign = plot:FindFirstChild("PlotSign")
		local model = sign and sign:FindFirstChild("Model")
		local gui = sign and sign:FindFirstChild("SurfaceGui")
		local frame = gui and gui:FindFirstChild("Frame")
		local label = frame and frame:FindFirstChild("TextLabel")

		if model and label then
			local idx = baseIndexFor(model)

			if idx then
				local ok, cf = pcall(function()
					return model:GetBoundingBox()
				end)

				if ok then
					bases[idx] = {
						label = label,
						cf = cf,
					}

					connectBaseLabel(label)
				end
			end
		end
	end

	recomputeNextBase()
end

scanBases()

table.insert(
	baseConns,
	Plots.DescendantAdded:Connect(function(d)
		if d:IsA("TextLabel") then
			task.defer(scanBases)
		end
	end)
)

table.insert(
	baseConns,
	Plots.ChildAdded:Connect(function()
		task.defer(scanBases)
	end)
)

----------------------------------------------------------
--======================================================
-- GUI
--======================================================
----------------------------------------------------------

local oldGui = PlayerGui:FindFirstChild("__PodiumNextBaseGUI")

if oldGui then
	oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "__PodiumNextBaseGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.fromOffset(140, 0)
topBar.AutomaticSize = Enum.AutomaticSize.Y
topBar.Position = UDim2.new(0.5, 0, 0, 12)
topBar.AnchorPoint = Vector2.new(0.5, 0)
topBar.BackgroundColor3 = Color3.fromRGB(12, 6, 10)
topBar.BackgroundTransparency = 0
topBar.BorderSizePixel = 0
topBar.Active = true
topBar.ClipsDescendants = false
topBar.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = topBar

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 105, 180)
stroke.Thickness = 2
stroke.Transparency = 0.1
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = topBar

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 5)
padding.PaddingRight = UDim.new(0, 5)
padding.PaddingTop = UDim.new(0, 5)
padding.PaddingBottom = UDim.new(0, 5)
padding.Parent = topBar

-- vertical stack = real box panel (not a bar)
local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.Padding = UDim.new(0, 4)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = topBar

local topBarGradient = Instance.new("UIGradient", topBar)
topBarGradient.Name = "candytpShimmer"
topBarGradient.Rotation = 90
topBarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(22, 10, 18)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(12, 6, 10)),
})
topBarGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0.00, 0),
    NumberSequenceKeypoint.new(1.00, 0),
})

-- Header / brand (full width inside the box)
local topBrand = Instance.new("Frame", topBar)
topBrand.Name = "candytpBrand"
topBrand.Size = UDim2.new(1, 0, 0, 28)
topBrand.BackgroundColor3 = Color3.fromRGB(28, 12, 22)
topBrand.BackgroundTransparency = 0
topBrand.BorderSizePixel = 0
topBrand.LayoutOrder = 0
topBrand.ZIndex = 4
local topBrandCorner = Instance.new("UICorner", topBrand)
topBrandCorner.CornerRadius = UDim.new(0, 10)
local topBrandStroke = Instance.new("UIStroke", topBrand)
topBrandStroke.Color = Color3.fromRGB(255, 105, 180)
topBrandStroke.Transparency = 0.2
topBrandStroke.Thickness = 1.3

local topIcon = Instance.new("Frame", topBrand)
topIcon.Size = UDim2.fromOffset(18, 18)
topIcon.Position = UDim2.fromOffset(5, 5)
topIcon.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
topIcon.BorderSizePixel = 0
topIcon.ZIndex = 5
local topIconCorner = Instance.new("UICorner", topIcon)
topIconCorner.CornerRadius = UDim.new(0, 10)
local topIconLabel = Instance.new("TextLabel", topIcon)
topIconLabel.Size = UDim2.fromScale(1, 1)
topIconLabel.BackgroundTransparency = 1
topIconLabel.Text = "C"
topIconLabel.Font = Enum.Font.GothamBlack
topIconLabel.TextSize = 11
topIconLabel.TextColor3 = Color3.fromRGB(12, 6, 10)
topIconLabel.ZIndex = 6

local topBrandText = Instance.new("TextLabel", topBrand)
topBrandText.Size = UDim2.new(1, -32, 0, 14)
topBrandText.Position = UDim2.fromOffset(28, 2)
topBrandText.BackgroundTransparency = 1
topBrandText.Text = "candy tp"
topBrandText.Font = Enum.Font.GothamBlack
topBrandText.TextSize = 11
topBrandText.TextColor3 = Color3.fromRGB(255, 240, 250)
topBrandText.TextXAlignment = Enum.TextXAlignment.Left
topBrandText.ZIndex = 5

local topBrandSub = Instance.new("TextLabel", topBrand)
topBrandSub.Size = UDim2.new(1, -32, 0, 10)
topBrandSub.Position = UDim2.fromOffset(28, 15)
topBrandSub.BackgroundTransparency = 1
topBrandSub.Text = "discord.gg/usYtFqxQdN"
topBrandSub.Font = Enum.Font.GothamMedium
topBrandSub.TextSize = 8
topBrandSub.TextColor3 = Color3.fromRGB(255, 105, 180)
topBrandSub.TextXAlignment = Enum.TextXAlignment.Left
topBrandSub.ZIndex = 5

----------------------------------------------------------
-- BUTTON CREATOR (full-width rows inside the box)
----------------------------------------------------------

local function makeButton(text, width, bg)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 0, 22)
	button.BackgroundColor3 = bg or Color3.fromRGB(28, 12, 22)
	button.BackgroundTransparency = 0
	button.BorderSizePixel = 0
	button.Font = Enum.Font.GothamBold
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 240, 250)
	button.TextStrokeColor3 = Color3.fromRGB(13, 10, 7)
	button.TextStrokeTransparency = 0.35
	button.TextSize = 9
	button.AutoButtonColor = false
	button.Parent = topBar
	button.ZIndex = 4
	local buttonStroke = Instance.new("UIStroke", button)
	buttonStroke.Color = Color3.fromRGB(255, 105, 180)
	buttonStroke.Transparency = 0.3
	buttonStroke.Thickness = 1.2
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 10)
	c.Parent = button
	return button
end

----------------------------------------------------------
-- BUTTONS (same names so existing handlers still work)
----------------------------------------------------------

local btnPod = makeButton("Pods: ON", 0, Color3.fromRGB(255, 105, 180))
local btnNext = makeButton("Next: ON", 0, Color3.fromRGB(30, 16, 24))
local btnSound = makeButton("Sound: ON", 0, Color3.fromRGB(30, 16, 24))
local btnFull = makeButton("Full: ON", 0, Color3.fromRGB(30, 16, 24))
local btnJob = makeButton("JobId", 0)
local btnRejoin = makeButton("Rejoin", 0)
local btnLock = makeButton("🔓 Unlock", 0)

btnPod.LayoutOrder = 1
btnNext.LayoutOrder = 2
btnSound.LayoutOrder = 3
btnFull.LayoutOrder = 4
btnJob.LayoutOrder = 5
btnRejoin.LayoutOrder = 6
btnLock.LayoutOrder = 7

-- make the box draggable by the header
do
	local dragging, startPos, startMouse = false, nil, nil
	topBrand.Active = true
	topBrand.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			startMouse = inp.Position
			startPos = topBar.Position
		end
	end)
	game:GetService("UserInputService").InputChanged:Connect(function(inp)
		if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
			local d = inp.Position - startMouse
			topBar.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	game:GetService("UserInputService").InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

----------------------------------------------------------
-- BUTTON COLORS
----------------------------------------------------------

local ON_COLOR = Color3.fromRGB(255, 105, 180)
local OFF_COLOR = Color3.fromRGB(60, 20, 45)
local ON_TEXT = Color3.fromRGB(12, 6, 10)
local OFF_TEXT = Color3.fromRGB(255, 240, 250)

local function setButtonState(button, name, enabled)
	button.Text = name .. ": " .. (enabled and "ON" or "OFF")
	button.BackgroundColor3 = enabled and ON_COLOR or OFF_COLOR
	button.TextColor3 = enabled and ON_TEXT or OFF_TEXT
	button:SetAttribute("candytpActive", enabled == true)
	-- keep pink stroke
	local st = button:FindFirstChildOfClass("UIStroke")
	if st then
		st.Color = Color3.fromRGB(255, 105, 180)
		st.Transparency = enabled and 0.1 or 0.35
	end
end

----------------------------------------------------------
-- NEXT BASE BUTTON
----------------------------------------------------------

btnNext.MouseButton1Click:Connect(function()
	nextEnabled = not nextEnabled

	setButtonState(
		btnNext,
		"Next",
		nextEnabled
	)

	recomputeNextBase()
end)

----------------------------------------------------------
-- SOUND BUTTON
----------------------------------------------------------

btnSound.MouseButton1Click:Connect(function()
	soundEnabled = not soundEnabled

	setButtonState(
		btnSound,
		"Sound",
		soundEnabled
	)
end)

----------------------------------------------------------
-- PODIUM BUTTON
----------------------------------------------------------

btnPod.MouseButton1Click:Connect(function()
	podiumOn = not podiumOn

	setButtonState(
		btnPod,
		"Pods",
		podiumOn
	)

	_G.__PodiumSlotsSetEnabled(podiumOn)
end)

-- Подиумы сразу появляются при инжекте
podiumOn = true
setButtonState(btnPod, "Pods", true)
if btnPod then btnPod.TextColor3 = Color3.fromRGB(12, 6, 10) end
task.spawn(function()
	_G.__PodiumSlotsSetEnabled(true)
end)

----------------------------------------------------------
-- FULL BUTTON
----------------------------------------------------------

btnFull.MouseButton1Click:Connect(function()
	fullEnabled = not fullEnabled

	setButtonState(
		btnFull,
		"Full",
		fullEnabled
	)

	if fullEnabled then
		for _, child in ipairs(topBar:GetChildren()) do
			if child:IsA("TextButton") then
				child.Visible = true
			end
		end
	else
		btnNext.Visible = false
		btnSound.Visible = false
		btnFull.Visible = true
		btnJob.Visible = false
		btnRejoin.Visible = false
		btnPod.Visible = false
	end
end)

----------------------------------------------------------
-- JOB ID COPY
----------------------------------------------------------

btnJob.MouseButton1Click:Connect(function()
	local jobId = game.JobId

	if setclipboard then
		local success = pcall(function()
			setclipboard(jobId)
		end)

		if success then
			btnJob.Text = "Copied!"

			task.delay(1.2, function()
				if btnJob and btnJob.Parent then
					btnJob.Text = "JobId"
				end
			end)

			return
		end
	end

	-- Clipboard unsupported
	btnJob.Text = "No Copy"

	task.delay(1.2, function()
		if btnJob and btnJob.Parent then
			btnJob.Text = "JobId"
		end
	end)
end)

----------------------------------------------------------
-- SAME SERVER REJOIN
----------------------------------------------------------

btnRejoin.MouseButton1Click:Connect(function()
	if not LocalPlayer then
		return
	end

	local currentJobId = game.JobId
	local currentPlaceId = game.PlaceId

	if currentJobId == "" then
		btnRejoin.Text = "No Job"

		task.delay(1.5, function()
			if btnRejoin and btnRejoin.Parent then
				btnRejoin.Text = "Rejoin"
			end
		end)

		return
	end

	btnRejoin.Text = "Rejoining..."

	local success, err = pcall(function()
		TeleportService:TeleportToPlaceInstance(
			currentPlaceId,
			currentJobId,
			LocalPlayer
		)
	end)

	if not success then
		warn("Same-server rejoin failed:", err)

		btnRejoin.Text = "Failed"

		task.delay(1.5, function()
			if btnRejoin and btnRejoin.Parent then
				btnRejoin.Text = "Rejoin"
			end
		end)
	end
end)

----------------------------------------------------------
-- LOCK BUTTON
----------------------------------------------------------

local dragging = false
local dragStart
local startPos

local function updateDrag(input)
	local delta = input.Position - dragStart

	topBar.Position =
		UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
end

topBar.InputBegan:Connect(function(input)
	if locked then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = topBar.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

topBar.InputChanged:Connect(function(input)
	if locked then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		-- handled below
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging and not locked then
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

			updateDrag(input)
		end
	end
end)

btnLock.MouseButton1Click:Connect(function()
	locked = not locked

	if locked then
		btnLock.Text = "🔒"
	else
		btnLock.Text = "🔓"
	end
end)

----------------------------------------------------------
-- GUI DRAGGING
----------------------------------------------------------

local guiDragging = false
local guiDragStart
local guiStartPos

topBar.InputBegan:Connect(function(input)
	if locked then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		guiDragging = true
		guiDragStart = input.Position
		guiStartPos = topBar.Position
	end
end)

topBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		guiDragging = false
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if not guiDragging or locked then
		return
	end
	if input.UserInputType ~= Enum.UserInputType.MouseMovement
		and input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end

	local delta = input.Position - guiDragStart
	topBar.Position = UDim2.new(
		guiStartPos.X.Scale,
		guiStartPos.X.Offset + delta.X,
		guiStartPos.Y.Scale,
		guiStartPos.Y.Offset + delta.Y
	)
end)

----------------------------------------------------------
-- COMBINED CLEANUP
----------------------------------------------------------

local cleaned = false

_G.__CombinedBasePodiumCleanup = function()
	if cleaned then
		return
	end

	cleaned = true

	-- Base connections
	for _, connection in ipairs(baseConns) do
		pcall(function()
			connection:Disconnect()
		end)
	end

	table.clear(baseConns)
	table.clear(baseConnected)
	table.clear(bases)

	-- Next base
	if baseAnchor then
		pcall(function()
			baseAnchor:Destroy()
		end)
	end

	-- Podiums
	if _G.__PodiumSlotsSetEnabled then
		pcall(function()
			_G.__PodiumSlotsSetEnabled(false)
		end)
	end

	-- GUI
	if gui then
		pcall(function()
			gui:Destroy()
		end)
	end

	_G.__CombinedBasePodiumCleanup = nil
	_G.__NextBaseCleanup = nil
end

----------------------------------------------------------
-- COMPATIBILITY CLEANUP
----------------------------------------------------------

_G.__NextBaseCleanup = function()
	if _G.__CombinedBasePodiumCleanup then
		_G.__CombinedBasePodiumCleanup()
	end
end
end

-- =====================================================================
-- >>> ЗДЕСЬ НАЧИНАЕТСЯ HEADLESS TP ADD-ON (окно висит всегда) <<<
-- Insta Reset + Anti Die «SENTINEL» -- 1:1 из «HEADLESS TP» (candytp meeok.txt),

-- Скрипт выше не меняется.
-- =====================================================================

-- =====================================================================

-- ---------------------------------------------------------------------
-- Insta Reset и Anti Die «SENTINEL» -- 1:1 из «HEADLESS TP» (candytp meeok.txt);
-- Anti Ragdoll (сброс рэга) -- из «основа попитки.txt»,
-- остальные три -- из burmalda-хаба 1:1. Вокруг них -- своя панель,
-- свой конфиг (candytpAddon.json) и хуки, поэтому блок живёт отдельно и
-- ничего не ломает в остальном скрипте.
--
-- ВСТРОЕНО: блок уже стоит в конце скрипта (после блока NEXT BASE).
--
-- Что появится: окно аддона (4 тумблера + ползунок скорости) прямо на
-- экране -- ни ярлыка-переключателя, ни кнопки «спрятать» нет, окно висит
-- всегда и тянется за шапку; позиция и состояния сохраняются в файл.
--
-- API:
--   _G.candytpSetAntiDie(on)      / _G.candytpAntiDie        (SENTINEL)
--   _G.candytpSetAntiRagdoll(on)  / _G.candytpAntiRagdollFixes   (сброс рэга)
--   _G.candytpAntiDie.suspend(sec) / .revives() / .log() / .rescueVoid
--   _G.candytpResetState() / _G.candytpResetLast() / _G.candytpResetBusy
--   _G.candytpSetUnwalk(on)

--   _G.candytpInstaReset()        / _G.candytpResetKey  (по умолчанию X)
--   _G.candytpSetResetKey("K")    -- сменить клавишу ресета

--
-- Anti Die и Insta Reset приехали из «HEADLESS TP» со своей логикой:
-- у анти-дие порог почти-смерти (_G.candytpAntiDieFloor 0.05) и void-rescue,
-- у ресета -- ладдер флинг -> войд -> добивание, анти-дие ставится на паузу.
-- По умолчанию: Anti Ragdoll (сброс) включён, Anti Die включён, Unwalk включён,

-- Anti Ragdoll молчит, пока стоит метка паузы _G.candytpAntiRagdollPauseUntil
-- (её же ставит INSTA RESET); транспортные функции не меняются.
-- INSTA RESET: клавиша X, кнопка PRESS в панели, поле ResetKey из cKHub.json.

-- =====================================================================
do -- обёртка: свои локальные имена не занимают регистры основного чанка
local _ADDON = {}

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local HS         = game:GetService("HttpService")
local LP         = Players.LocalPlayer or Players.PlayerAdded:Wait()

local CFG_FILE = "candytpAddon.json"

local AC = {
    BG     = Color3.fromRGB(18, 8, 14),
    SURF   = Color3.fromRGB(60, 20, 45),
    SURF2  = Color3.fromRGB(90, 30, 65),
    TEXT   = Color3.fromRGB(255, 240, 250),
    DIM    = Color3.fromRGB(255, 105, 180),
    STROKE = Color3.fromRGB(255, 20, 147),
    ON     = Color3.fromRGB(255, 105, 180),
    OFF    = Color3.fromRGB(80, 30, 60),
    KNOB   = Color3.fromRGB(255, 182, 193),
    SWITCH = Color3.fromRGB(255, 105, 180),
    SWITCH_OFF = Color3.fromRGB(80, 30, 60),
    SWITCH_KNOB = Color3.fromRGB(255, 182, 193),
    SWITCH_ON_KNOB = Color3.fromRGB(255, 240, 250),
    TRACK  = Color3.fromRGB(100, 40, 80),
}

local function rnd(o, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = o
    return c
end
local function stk(o, col, th, tr)
    local s = Instance.new("UIStroke")
    s.Color = col
    s.Thickness = th or 1
    s.Transparency = tr or 0.4
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = o
    return s
end

local parent
pcall(function() parent = (gethui and gethui()) or game:GetService("CoreGui") end)
if not parent then pcall(function() parent = LP:WaitForChild("PlayerGui") end) end

-- В скрипте есть вызов MakeDraggable(...), но самой функции нет: на мобиле
-- панель AUTO STEAL падала на этом месте. Определяем только если её нет.
if MakeDraggable == nil then
    function MakeDraggable(frame, handle)
        if not frame then return end
        handle = handle or frame
        local dragging, startPos, startMouse = false, nil, nil
        handle.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                startMouse = i.Position
                startPos = frame.Position
            end
        end)
        handle.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local d = i.Position - startMouse
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                           startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
    end
end

do -- повторный инжект: убрать прошлую копию панели
    local old = parent and parent:FindFirstChild("candytpAddonGUI")
    if old then pcall(function() old:Destroy() end) end
end

local sg = Instance.new("ScreenGui")
sg.Name = "candytpAddonGUI"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.DisplayOrder = 997
sg.Parent = parent

local panel = Instance.new("Frame", sg)
panel.Name = "Panel"
panel.AutomaticSize = Enum.AutomaticSize.Y
panel.Size = UDim2.new(0, 190, 0, 0)
panel.Position = UDim2.new(1, -202, 0.34, 0)
panel.BackgroundColor3 = AC.BG
panel.BackgroundTransparency = 0.06
panel.BorderSizePixel = 0
panel.ZIndex = 5
rnd(panel, 10)
stk(panel, AC.STROKE, 1, 0.35)

local header = Instance.new("Frame", panel)
header.Size = UDim2.new(1, 0, 0, 23)
header.BackgroundTransparency = 1
header.ZIndex = 6

-- надписи в шапке нет: вместо неё нейтральная «ручка» перетаскивания
local grip = Instance.new("Frame", header)
grip.Name = "Grip"
grip.Size = UDim2.new(0, 34, 0, 3)
grip.Position = UDim2.new(0, 10, 0.5, -1)
grip.BackgroundColor3 = AC.DIM
grip.BackgroundTransparency = 0.4
grip.BorderSizePixel = 0
grip.ZIndex = 7
rnd(grip, 10)

local minBtn = Instance.new("TextButton", header)
minBtn.Size = UDim2.new(0, 20, 0, 18)
minBtn.Position = UDim2.new(1, -24, 0, 4)
minBtn.BackgroundColor3 = AC.SURF2
minBtn.BackgroundTransparency = 0.05
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBlack
minBtn.TextSize = 13
minBtn.TextColor3 = AC.TEXT
minBtn.AutoButtonColor = false
minBtn.BorderSizePixel = 0
minBtn.ZIndex = 7
rnd(minBtn, 10)

local body = Instance.new("Frame", panel)
body.Name = "Body"
body.AutomaticSize = Enum.AutomaticSize.Y
body.Position = UDim2.new(0, 0, 0, 23)
body.Size = UDim2.new(1, 0, 0, 0)
body.BackgroundTransparency = 1
body.ZIndex = 6
local list = Instance.new("UIListLayout", body)
list.Padding = UDim.new(0, 3)
list.SortOrder = Enum.SortOrder.LayoutOrder
local pad = Instance.new("UIPadding", body)
pad.PaddingLeft = UDim.new(0, 6)
pad.PaddingRight = UDim.new(0, 6)
pad.PaddingTop = UDim.new(0, 2)
pad.PaddingBottom = UDim.new(0, 5)

-- строка-тумблер: внутри лежит TextButton-слой, по нему кликают модули
local function makeToggle(label, order, def)
    local row = Instance.new("Frame", body)
    row.Name = label:gsub("%s+", "") .. "Row"
    row.Size = UDim2.new(1, 0, 0, 26)
    row.BackgroundColor3 = AC.SURF
    row.BackgroundTransparency = 0.02
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.ZIndex = 7
    rnd(row, 10)
    local rowStroke = stk(row, AC.STROKE, 1, 0.55)

    local accent = Instance.new("Frame", row)
    accent.Name = "AccentBar"
    accent.Size = UDim2.new(0, 3, 0, 18)
    accent.Position = UDim2.new(0, 4, 0.5, -9)
    accent.BackgroundColor3 = AC.DIM
    accent.BorderSizePixel = 0
    accent.ZIndex = 9
    accent:SetAttribute("__candytpAccent", true)
    accent:SetAttribute("__candytpAccentOn", def == true)
    rnd(accent, 10)

    local btn = Instance.new("TextButton", row)
    btn.Name = "Click"
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 8

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -96, 1, 0)
    lbl.Position = UDim2.new(0, 13, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextColor3 = AC.TEXT
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = label
    lbl.ZIndex = 9

    local pill = Instance.new("Frame", row)
    pill.Size = UDim2.new(0, 40, 0, 18)
    pill.Position = UDim2.new(1, -56, 0.5, -11)
    pill.BackgroundColor3 = AC.OFF
    pill.BorderSizePixel = 0
    pill.ZIndex = 9
    pill:SetAttribute("__candytpSwitch", true)
    rnd(pill, 10)
    local pStroke = stk(pill, Color3.fromRGB(255, 105, 180), 1, 0.25)

    local knob = Instance.new("Frame", pill)
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new(0, 3, 0.5, -6)
    knob.BackgroundColor3 = AC.SWITCH_KNOB
    knob:SetAttribute("__candytpSwitchKnob", true)
    knob.BorderSizePixel = 0
    knob.ZIndex = 10
    rnd(knob, 10)

    local state = def == true
    local function paint(on)
        pill.BackgroundColor3 = on and AC.SWITCH or AC.SWITCH_OFF
        pill.BackgroundTransparency = 0
        pill:SetAttribute("__candytpSwitchOn", on == true)
        pStroke.Transparency = on and 0.05 or 0.2
        knob.BackgroundColor3 = on and AC.SWITCH_ON_KNOB or AC.SWITCH_KNOB
        knob.Position = on and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
        accent.BackgroundColor3 = on and AC.STROKE or AC.DIM
        accent:SetAttribute("__candytpAccentOn", on == true)
        row.BackgroundColor3 = on and AC.SURF2 or AC.SURF
        rowStroke.Transparency = on and 0.3 or 0.55
    end

    local T = { row = row }
    function T.getState() return state end
    function T.setState(on)
        state = on and true or false
        paint(state)
    end
    -- свой клик: красит и переключает состояние (модуль-обработчик читает его ниже)
    btn.MouseButton1Click:Connect(function()
        state = not state
        paint(state)
    end)
    paint(state)
    return T
end

-- строка-действие: жмёшь -- выполняется; справа кнопка PRESS и бейдж клавиши-бинда
local function makeAction(label, order, keyText, onPress)
    local row = Instance.new("Frame", body)
    row.Name = label:gsub("%s+", "") .. "Row"
    row.Size = UDim2.new(1, 0, 0, 26)
    row.BackgroundColor3 = AC.SURF
    row.BackgroundTransparency = 0.02
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.ZIndex = 7
    rnd(row, 10)
    stk(row, AC.STROKE, 1, 0.55)

    local accent = Instance.new("Frame", row)
    accent.Name = "AccentBar"
    accent.Size = UDim2.new(0, 3, 0, 18)
    accent.Position = UDim2.new(0, 4, 0.5, -9)
    accent.BackgroundColor3 = AC.STROKE
    accent.BorderSizePixel = 0
    accent.ZIndex = 9
    accent:SetAttribute("__candytpAccent", true)
    accent:SetAttribute("__candytpAccentOn", true)
    rnd(accent, 10)

    local btn = Instance.new("TextButton", row)          -- слой на всю строку
    btn.Name = "Click"
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 8

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -110, 1, 0)
    lbl.Position = UDim2.new(0, 13, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextColor3 = AC.TEXT
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = label
    lbl.ZIndex = 9

    local press = Instance.new("TextButton", row)
    press.Name = "Press"
    press.Size = UDim2.new(0, 34, 0, 16)
    press.Position = UDim2.new(1, -70, 0.5, -9)
    press.BackgroundColor3 = AC.ON
    press.BackgroundTransparency = 0.05
    press.Text = "PRESS"
    press.Font = Enum.Font.GothamBold
    press.TextSize = 8
    press.TextColor3 = AC.KNOB
    press.AutoButtonColor = false
    press.BorderSizePixel = 0
    press.ZIndex = 9
    rnd(press, 10)
    stk(press, AC.STROKE, 1, 0.25)

    local keyBox = Instance.new("TextButton", row)
    keyBox.Name = "Key"
    keyBox.Size = UDim2.new(0, 20, 0, 16)
    keyBox.Position = UDim2.new(1, -28, 0.5, -9)
    keyBox.BackgroundColor3 = AC.SURF2
    keyBox.Text = tostring(keyText or "X"):upper()
    keyBox.Font = Enum.Font.GothamBlack
    keyBox.TextSize = 9
    keyBox.TextColor3 = AC.TEXT
    keyBox.AutoButtonColor = false
    keyBox.BorderSizePixel = 0
    keyBox.ZIndex = 9
    rnd(keyBox, 10)
    stk(keyBox, AC.STROKE, 1, 0.45)

    local function fire()
        row.BackgroundColor3 = AC.SURF2
        task.delay(0.15, function() row.BackgroundColor3 = AC.SURF end)
        if onPress then pcall(onPress) end
    end
    press.MouseButton1Click:Connect(fire)
    keyBox.MouseButton1Click:Connect(fire)
    btn.MouseButton1Click:Connect(fire)

    return {
        row    = row,
        press  = press,
        keyBox = keyBox,
        getKey = function() return keyBox.Text end,
        setKey = function(k) keyBox.Text = tostring(k or "X"):upper() end,
    }
end

-- строка-ползунок
local function makeSlider(label, minv, maxv, getv, setv, order)
    local row = Instance.new("Frame", body)
    row.Name = "WalkSpeedSlider"
    row.Size = UDim2.new(1, 0, 0, 26)
    row.BackgroundColor3 = AC.SURF
    row.BackgroundTransparency = 0.02
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.ZIndex = 7
    rnd(row, 10)
    stk(row, AC.STROKE, 1, 0.55)

    local accent = Instance.new("Frame", row)
    accent.Name = "AccentBar"
    accent.Size = UDim2.new(0, 3, 0, 18)
    accent.Position = UDim2.new(0, 4, 0.5, -9)
    accent.BackgroundColor3 = AC.STROKE
    accent.BorderSizePixel = 0
    accent.ZIndex = 9
    accent:SetAttribute("__candytpAccent", true)
    accent:SetAttribute("__candytpAccentOn", true)
    rnd(accent, 10)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -70, 0, 14)
    lbl.Position = UDim2.new(0, 13, 0, 3)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextColor3 = Color3.fromRGB(255, 105, 180)
    lbl:SetAttribute("__candytpSliderLabel", true)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = label
    lbl.ZIndex = 9

    local val = Instance.new("TextLabel", row)
    val.Size = UDim2.new(0, 50, 0, 14)
    val.Position = UDim2.new(1, -58, 0, 3)
    val.BackgroundTransparency = 1
    val.Font = Enum.Font.GothamBold
    val.TextSize = 11
    val.TextColor3 = Color3.fromRGB(255, 105, 180)
    val.TextXAlignment = Enum.TextXAlignment.Right
    val.ZIndex = 9

    local track = Instance.new("Frame", row)
    track.Size = UDim2.new(1, -26, 0, 6)
    track.Position = UDim2.new(0, 13, 1, -12)
    track.BackgroundColor3 = AC.TRACK
    track.BorderSizePixel = 0
    track.ZIndex = 8
    rnd(track, 10)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    fill:SetAttribute("__candytpSliderFill", true)
    fill.BorderSizePixel = 0
    fill.ZIndex = 9
    rnd(fill, 10)

    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(0, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    knob:SetAttribute("__candytpSliderKnob", true)
    knob.BorderSizePixel = 0
    knob.ZIndex = 10
    rnd(knob, 10)

    local dragging = false
    local function set(v)
        v = math.clamp(tonumber(v) or minv, minv, maxv)
        local f = (v - minv) / (maxv - minv)
        fill.Size = UDim2.new(f, 0, 1, 0)
        knob.Position = UDim2.new(f, 0, 0.5, 0)
        val.Text = tostring(math.floor(v + 0.5))
        setv(v)
    end
    local function fromX(px)
        local w = track.AbsoluteSize.X
        if w <= 0 then return getv() end
        return minv + math.clamp((px - track.AbsolutePosition.X) / w, 0, 1) * (maxv - minv)
    end
    local function press(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            set(fromX(i.Position.X))
        end
    end
    track.InputBegan:Connect(press)
    knob.InputBegan:Connect(press)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            set(fromX(i.Position.X))
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                _ADDON.save()
            end
        end
    end)
    set(getv())
    return { set = set }
end

local ui = {}
ui.antiDie   = makeToggle("Anti Die",       1, true)
ui.antiRag   = makeToggle("Anti Ragdoll",   2, true)   -- сброс рэга (из «основа попитки»)
ui.unwalk    = makeToggle("Unwalk",         3, true)

-- Drop Brainrot теперь находится в этом же окне, сразу под Speed.
ui.drop = makeAction("Drop Brainrot", 6, tostring(i.DropBrainrotKey or "R"), function()
    if _G.CKDropBrainrot then task.spawn(_G.CKDropBrainrot) end
end)

-- Кнопка с буквой работает как rebinding: нажми её и затем клавишу.
do
    local rebinding = false
    local inputConn
    local function showKey(key)
        ui.drop.setKey(key)
    end
    ui.drop.keyBox.MouseButton1Click:Connect(function()
        if rebinding then return end
        rebinding = true
        showKey("...")
        if inputConn then pcall(function() inputConn:Disconnect() end) end
        inputConn = UIS.InputBegan:Connect(function(inp, gp)
            if gp or inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
            if inp.KeyCode == Enum.KeyCode.Escape then
                rebinding = false
                showKey(i.DropBrainrotKey or "R")
                if inputConn then inputConn:Disconnect(); inputConn = nil end
                return
            end
            i.DropBrainrotKey = inp.KeyCode.Name
            showKey(i.DropBrainrotKey)
            rebinding = false
            if inputConn then inputConn:Disconnect(); inputConn = nil end
            if U then pcall(U) end
        end)
        task.delay(6, function()
            if rebinding then
                rebinding = false
                showKey(i.DropBrainrotKey or "R")
                if inputConn then pcall(function() inputConn:Disconnect() end); inputConn = nil end
            end
        end)
    end)
end

ui.reset = makeAction("Insta Reset", 7, "X", function()
    if _G.candytpInstaReset then pcall(_G.candytpInstaReset) end
end)

-- конфиг: candytpAddon.json
function _ADDON.load()
    local t
    pcall(function()
        if isfile and isfile(CFG_FILE) then
            local raw = readfile(CFG_FILE)
            if raw and raw ~= "" then
                local d = HS:JSONDecode(raw)
                if type(d) == "table" then t = d end
            end
        end
    end)
    return t
end

function _ADDON.save()
    pcall(function()
        if not writefile then return end
        local p = panel.Position
        writefile(CFG_FILE, HS:JSONEncode({
            version        = 2,
            antiDie        = _G.candytpAntiDieOn == true,
            antiRagdoll    = _G.candytpAntiRagdoll == true,
            unwalk         = _G.candytpUnwalk ~= false,
            resetKey       = tostring(_G.candytpResetKey or "X"),
            posX = p.X.Offset,
            posY = p.Y.Offset,
        }))
    end)
end

local function clampPos()
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
    local p = panel.Position
    panel.Position = UDim2.new(0,
        math.clamp(p.X.Offset, 0, math.max(0, vp.X - 80)),
        0, math.clamp(p.Y.Offset, 0, math.max(0, vp.Y - 40)))
end

do -- перетаскивание панели за шапку
    local dragging, dragStart, startPos = false, nil, nil
    header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = panel.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    _ADDON.save()
                end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                       startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

minBtn.MouseButton1Click:Connect(function()
    body.Visible = not body.Visible
    minBtn.Text = body.Visible and "-" or "+"
end)

--@BLOCK UNWALK  (из burmalda hub, строки 815-881)

do -- UNWALK (отдельная область видимости)
-- ================================================================
-- UNWALK  (перенесено из candytp Hub, механика 1:1)
--   Отключает скрипт Animate и глушит играющие треки -> персонаж
--   двигается без анимации ходьбы. Как в исходнике: после включения
--   состояние накатывается несколько раз (игра может вернуть Animate),
--   и так же повторно после респауна.
--   API: _G.candytpSetUnwalk(on) / _G.setUnwalk(on) / _G.candytpUnwalk
-- ================================================================
local function applyUnwalk(char,on)
    if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    local animator=hum and hum:FindFirstChildOfClass("Animator")
    local animate=char:FindFirstChild("Animate")
    if on then
        if animate then animate.Disabled=true end
        if animator then
            local ok,tracks=pcall(function() return animator:GetPlayingAnimationTracks() end)
            if ok and tracks then
                for _,t in ipairs(tracks) do pcall(function() t:Stop(0) end) end
            end
        end
    else
        if animate then animate.Disabled=false end
    end
end

local function setUnwalk(on)
    on=on and true or false
    _G.candytpUnwalk=on
    if ui.unwalk and ui.unwalk.setState then pcall(ui.unwalk.setState,on) end
    if _ADDON.save then pcall(_ADDON.save) end
    if on then
        applyUnwalk(LP.Character,true)   -- срабатывает сразу, дальше накатка держит состояние
        task.spawn(function()
            local char=LP.Character
            for _=1,6 do
                if not _G.candytpUnwalk or LP.Character~=char then break end
                applyUnwalk(char,true)
                task.wait(0.3)
            end
        end)
    else
        applyUnwalk(LP.Character,false)
    end
end
_G.candytpSetUnwalk=setUnwalk
_G.setUnwalk=setUnwalk            -- имя из исходного хаба

ui.unwalk.row:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
    task.defer(function() setUnwalk(ui.unwalk.getState()) end)
end)

LP.CharacterAdded:Connect(function(char)
    task.spawn(function()
        char:WaitForChild("Humanoid",10)
        task.wait(0.1)
        if _G.candytpUnwalk then
            for _=1,6 do
                if not _G.candytpUnwalk or LP.Character~=char then break end
                applyUnwalk(char,true)
                task.wait(0.3)
            end
        end
    end)
end)
end -- UNWALK


--@BLOCK ANTIKNOCK REMOVED
-- Anti Knockback intentionally removed from this build.
-- Clear stale globals from a previous injection without creating a replacement feature.
_G.candytpAntiKnockback = nil
_G.candytpAntiKnockbackFixes = nil
_G.candytpSetAntiKnockback = nil
_G.setAntiKnockback = nil


--@BLOCK ANTIDIE  (из «candytp meeok.txt»: ANTI-DIE «SENTINEL», строки 176-399)
do -- ANTI DIE (SENTINEL)
-- ================================================================
-- ANTI-DIE «SENTINEL»  --  модуль 1:1 из «HEADLESS TP» (candytp meeok.txt)
--   Один watchdog вместо трёх коннектов: за проход проверяются здоровье,
--   Died, MaxHealth и позиция тела -- между колбэками ничего не проскакивает.
--     * лечение ПОЧТИ смерти (порог 5%), а не по факту Health <= 0;
--     * защита MaxHealth: игра/чужой скрипт может занизить максимум --
--       кэш максимума восстанавливается;
--     * VOID RESCUE: помнит последнюю безопасную точку и возвращает туда
--       тело, если оно провалилось ниже FallenPartsDestroyHeight;
--     * un-ragdoll: PlatformStand/Sit снимаются, состояние -> Running,
--       игровой RagdollEndTime обнуляется;
--     * закалка (Dead/Ragdoll/FallingDown/Physics off, BreakJointsOnDeath
--       и RequiresNeck off) -- как было;
--     * журнал: _G.candytpAntiDie.log() / .revives().
--   Наш прежний интерфейс сохранён: _G.candytpSetAntiDie(on),
--   _G.candytpAntiDieOn, _G.candytpAntiDieFixes (счётчик), строка «Anti Die».
--   API: _G.candytpAntiDie.set/isActive/suspend/suspended/revives/log/rescueVoid
--   Крутилки: _G.candytpAntiDieHz (0.05), _G.candytpAntiDieFloor (0.05).
-- ================================================================
-- Same switch as always: _G.AntiDieDisabled == false means ON, so the
-- FEATURES toggle and the saved config keep working untouched.
--
-- A different approach from the ported one instead of repeating it:
--   * one watchdog instead of three connections -- a single pass per frame
--     checks health, the Died signal, MaxHealth and the body's position, so
--     nothing can slip between two callbacks;
--   * NEAR-DEATH revive: the hub heals at Health <= 0, i.e. on the very
--     frame the game is already killing us. This heals at 5% instead, so
--     the Died path is usually never reached at all;
--   * MaxHealth defence: the game (or another script) can zero or lower
--     MaxHealth to make healing useless -- the cached maximum is restored;
--   * VOID RESCUE: the last safe standing position is remembered and, if
--     the body is dropped under FallenPartsDestroyHeight, it is put back
--     there and healed -- an anti-die that only refills health loses that
--     fight, because a void death never reads health;
--   * un-ragdoll: PlatformStand / Sit are cleared, the state is forced back
--     to Running and the game's own RagdollEndTime attribute is neutralised;
--   * hardening kept (Dead / Ragdoll / FallingDown / Physics disabled,
--     BreakJointsOnDeath and RequiresNeck off) -- that part was right;
--   * a revive log: _G.candytpAntiDie.log() shows what it saved you from.
--
-- API: _G.candytpAntiDie.set(on) / .isActive() / .suspend(sec) / .suspended()
--      .revives() / .log() / .rescueVoid(on/off)
--      _G.setupAntiDie()  (kept for the old callers)
-- Tunables: _G.candytpAntiDieHz (watchdog rate, default 0.05)
--           _G.candytpAntiDieFloor (revive below this share of max health,
--           default 0.05; set 0 to heal only at 0)
-- =====================================================================
    local Players    = game:GetService("Players")
    -- (do-блок открыт выше, в шапке блока)
    local RunService = game:GetService("RunService")
    local LP         = Players.LocalPlayer or Players.PlayerAdded:Wait()

    if _G.AntiDieDisabled == nil then _G.AntiDieDisabled = false end

    local M = {}
    local hum, char, conn
    local hardened, suspended, alive = nil, false, false
    local lastWatch = 0
    local safeCF, safeAt = nil, 0
    local maxHealth = nil
    local reviveCount = 0
    local revokeLog = {}

    local function blocked()
        return suspended or _G.AntiDieDisabled == true
    end

    local function record(why)
        reviveCount = reviveCount + 1
        _G.candytpAntiDieFixes = reviveCount          -- наш счётчик (как раньше)
        revokeLog[#revokeLog + 1] = { t = os.clock(), why = why }
        while #revokeLog > 20 do table.remove(revokeLog, 1) end
    end

    local function fullHealth()
        if not hum or not hum.Parent then return end
        local want = maxHealth or hum.MaxHealth
        if want and want > 0 and hum.MaxHealth ~= want then
            pcall(function() hum.MaxHealth = want end)
        end
        pcall(function() hum.Health = hum.MaxHealth end)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
        pcall(function() hum.PlatformStand = false end)
        pcall(function() hum.Sit = false end)
    end

    local function harden()
        if not hum or not hum.Parent then return end
        pcall(function()
            hum.BreakJointsOnDeath = false
            hum.RequiresNeck = false
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        end)
        hardened = hum
    end

    local function rescueVoid()
        if M.voidRescue == false then return false end
        local root = hum and (hum.RootPart or (char and char:FindFirstChild("HumanoidRootPart")))
        if not root then return false end
        local floor = -500
        pcall(function() floor = workspace.FallenPartsDestroyHeight end)
        if root.Position.Y > floor + 25 then return false end
        if not safeCF then return false end
        pcall(function() root.CFrame = safeCF end)
        pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
        fullHealth()
        record("void")
        return true
    end

    -- one pass: everything the protection has to know, in one place
    local function watch()
        if blocked() then return end
        if not hum or not hum.Parent then return end

        -- the game may wipe or lower MaxHealth to make healing pointless
        if hum.MaxHealth <= 0 then
            record("maxhp")
            pcall(function() hum.MaxHealth = maxHealth or 100 end)
            fullHealth()
            return
        end
        if maxHealth and hum.MaxHealth > maxHealth then maxHealth = hum.MaxHealth end

        local root = hum.RootPart or (char and char:FindFirstChild("HumanoidRootPart"))
        if root then
            -- remember where we last stood safely, for the void rescue
            if root.Position.Y > (workspace.FallenPartsDestroyHeight or -500) + 50 then
                if os.clock() - safeAt > 0.25 then
                    safeAt = os.clock()
                    safeCF = root.CFrame
                end
            else
                rescueVoid()
                return
            end
        end

        -- near-death counts as death: heal before the Died path is even reached
        local floor = tonumber(_G.candytpAntiDieFloor) or 0.05
        local trigger = (floor > 0) and (hum.MaxHealth * floor) or 0
        if hum.Health <= trigger then
            record(hum.Health <= 0 and "health" or "near")
            fullHealth()
        end

        -- re-harden now and then, in case something undid it
        if hardened ~= hum then harden() end
    end

    local function bind()
        if conn then pcall(function() conn:Disconnect() end); conn = nil end
        char = LP.Character
        hum = char and char:FindFirstChildOfClass("Humanoid")
        hardened = nil
        if not hum then return end
        maxHealth = hum.MaxHealth
        -- start the rescue from where the body stands now, so even a spawn
        -- right under the kill plane has somewhere to be put back
        do
            local root = hum.RootPart or char:FindFirstChild("HumanoidRootPart")
            if root then safeCF, safeAt = root.CFrame, os.clock() end
        end

        -- the Died signal is the net under the watchdog: if the game kills
        -- between two passes, this fires inside the same frame
        if hum.Died then
            pcall(function()
                hum.Died:Connect(function()
                    if blocked() then return end
                    record("died")
                    task.defer(fullHealth)
                end)
            end)
        end
        harden()
        alive = true
        if not conn then
            conn = RunService.Heartbeat:Connect(function()
                if not alive then return end
                if blocked() then return end
                local rate = tonumber(_G.candytpAntiDieHz) or 0.05
                if rate > 0 then
                    -- cheap throttle: the watchdog does not need every frame
                    local now = os.clock()
                    if now - lastWatch < rate then return end
                    lastWatch = now
                end
                pcall(watch)
            end)
        end
    end

    function M.set(on)
        _G.AntiDieDisabled = not (on and true or false)
        _G.candytpAntiDieOn = not _G.AntiDieDisabled      -- наш флаг (его читает конфиг)
        if _G.AntiDieDisabled then
            alive = false
            if conn then pcall(function() conn:Disconnect() end); conn = nil end
        else
            bind()
        end
        if ui.antiDie and ui.antiDie.setState then pcall(ui.antiDie.setState, _G.candytpAntiDieOn) end
        if _ADDON.save then pcall(_ADDON.save) end
    end
    function M.isActive() return not blocked() end
    function M.suspend(sec)
        suspended = true
        task.delay(sec or 3, function() suspended = false end)
    end
    function M.suspended() return suspended end
    function M.revives() return reviveCount end
    function M.log() return table.clone(revokeLog) end
    M.rescueVoid = true

    _G.candytpAntiDie = M
    _G.setupAntiDie = function() if not blocked() then bind() end end   -- old callers

    -- наш прежний интерфейс поверх этого модуля
    _G.candytpAntiDieOn = (_G.AntiDieDisabled ~= true)
    _G.candytpSetAntiDie = function(on)
        M.set(on and true or false)
    end
    _G.setAntiDie = _G.candytpSetAntiDie
    if ui.antiDie and ui.antiDie.setState then pcall(ui.antiDie.setState, _G.candytpAntiDieOn) end

    -- bound from the start; the flag gates the protection, so flipping the
    -- FEATURES toggle (or the config) is enough to arm / disarm it
    bind()
    LP.CharacterAdded:Connect(function(c)
        alive = false
        if conn then pcall(function() conn:Disconnect() end); conn = nil end
        local h = c:WaitForChild("Humanoid", 5) or c:FindFirstChildOfClass("Humanoid")
        if h then
            hum, char = h, c
            maxHealth = h.MaxHealth
            bind()
        else
            -- the humanoid can arrive a frame later (streaming / rig swaps)
            c.ChildAdded:Connect(function(o)
                if o:IsA("Humanoid") then hum, char, maxHealth = o, c, o.MaxHealth bind() end
            end)
        end
    end)
    ui.antiDie.row:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
        task.defer(function()
            _G.candytpSetAntiDie(ui.antiDie.getState())
        end)
    end)
end -- ANTI DIE (SENTINEL, из «candytp meeok.txt»)

--@BLOCK ANTIRAG  (из «основа попитки.txt», строки 5728-5875: сброс рэгдолла)
do -- ANTI RAGDOLL (сброс рэга)
-- ================================================================
-- ANTI RAGDOLL «сброс»  --  взят из «основа попитки.txt» (модуль AntiRagdoll)
--   Раг не «пережидаем», а разбираем: как только игра уронила персонажа
--   (состояния Physics / Ragdoll / FallingDown, PlatformStand, Sit или
--   игровой таймер рага в атрибуте RagdollEndTime) -- в тот же миг:
--     * сносятся рэгдолл-конструкции: BallSocketConstraint / HingeConstraint /
--       NoCollisionConstraint / Attachment с именем "Ragdoll*";
--     * возвращаются Motor6D (Enabled = true), снимаются PlatformStand и Sit,
--       выключаются состояния Ragdoll и FallingDown;
--     * атрибут RagdollEndTime обнуляется, Humanoid переводится в Running;
--     * корень отпускается (Anchored = false) и скорость гасится в ноль;
--     * камера возвращается на персонажа;
--     * Backpack держится на экране (тег ForceConnection).
--   Ничего своего не задевает: пока стоит метка паузы
--   _G.candytpAntiRagdollPauseUntil (её ставит INSTA RESET), модуль молчит.
--   API: _G.candytpSetAntiRagdoll(on) / _G.setAntiRagdoll(on)
--        _G.candytpAntiRagdoll        -- состояние (true/false)
--        _G.candytpAntiRagdollFixes   -- сколько раз поднял из рэга
--        _G.candytpAntiRagdollRate    -- период проверки, по умолчанию 0.1 с
-- ================================================================
local AntiRagdoll = (function()
    local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
    local M = { connections = {}, running = false }

    local function paused()
        local t = tonumber(_G.candytpAntiRagdollPauseUntil)
        return t ~= nil and os.clock() < t
    end

    M.forceBackpack = function()
        if not M.running then return end
        local gui = LocalPlayer:FindFirstChild("PlayerGui")
        if not gui then return end
        local backpackGui = gui:FindFirstChild("BackpackGui")
        if not backpackGui then return end
        local backpack = backpackGui:FindFirstChild("Backpack")
        if not backpack then return end
        backpack.Visible = true
        if not backpack:FindFirstChild("ForceConnection") then
            local tag = Instance.new("BoolValue")
            tag.Name   = "ForceConnection"
            tag.Parent = backpack
            backpack:GetPropertyChangedSignal("Visible"):Connect(function()
                if not M.running then return end
                if not backpack.Visible then backpack.Visible = true end
            end)
        end
    end

    M.removeRagdollConstraints = function(char)
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("BallSocketConstraint") or d:IsA("HingeConstraint")
                or d:IsA("NoCollisionConstraint")
                or (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then
                d:Destroy()
            end
        end
    end

    M.resetCharacter = function(char)
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if rootPart then
            rootPart.Anchored = false
            rootPart.Velocity  = Vector3.zero
        end
        if humanoid then
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") and obj.Enabled == false then
                    obj.Enabled = true
                end
            end
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,     false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid.PlatformStand = false
            humanoid.Sit           = false
            if humanoid.Health > 0 then
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
            if workspace.CurrentCamera then
                workspace.CurrentCamera.CameraSubject = humanoid
            end
        end
    end

    M.onCharacterAdded_AR = function(char)
        char:WaitForChild("HumanoidRootPart")
        local humanoid = char:WaitForChild("Humanoid")

        M.connections.charDescAdded = char.DescendantAdded:Connect(function(obj)
            if not M.running then return end
            if obj:IsA("BallSocketConstraint") or obj:IsA("HingeConstraint")
                or obj:IsA("NoCollisionConstraint")
                or (obj:IsA("Attachment") and obj.Name:find("RagdollAttachment")) then
                task.defer(function()
                    if not M.running then return end
                    if obj.Parent then obj:Destroy() end
                end)
            end
        end)
        M.connections.platformStand = humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
            if not M.running then return end
            if paused() then return end
            if humanoid.PlatformStand then
                task.defer(function()
                    if not M.running then return end
                    M.resetCharacter(char)
                    M.removeRagdollConstraints(char)
                    _G.candytpAntiRagdollFixes = (tonumber(_G.candytpAntiRagdollFixes) or 0) + 1
                end)
            end
        end)
        M.removeRagdollConstraints(char)
        M.resetCharacter(char)
    end

    M.enable = function()
        if M.running then return end
        M.running = true
        local _arTick = 0
        M.connections.heartbeat = RunService.Heartbeat:Connect(function(dt)
            _arTick = _arTick + dt
            local rate = tonumber(_G.candytpAntiRagdollRate) or 0.1
            if _arTick < rate then return end
            _arTick = 0
            if paused() then return end
            local char = LocalPlayer.Character
            if not char then return end
            local hum  = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            if not (hum and root) then return end
            local s = hum:GetState()
            local ragdolled = (s == Enum.HumanoidStateType.Physics
                or s == Enum.HumanoidStateType.Ragdoll
                or s == Enum.HumanoidStateType.FallingDown
                or hum.PlatformStand)
            local endTime = LocalPlayer:GetAttribute("RagdollEndTime")
            if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then
                ragdolled = true
            end
            if ragdolled then
                pcall(function() LocalPlayer:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
                M.removeRagdollConstraints(char)
                for _, obj in ipairs(char:GetDescendants()) do
                    if obj:IsA("Motor6D") and obj.Enabled == false then
                        obj.Enabled = true
                    end
                end
                if hum.Health > 0 then hum:ChangeState(Enum.HumanoidStateType.Running) end
                if workspace.CurrentCamera then
                    workspace.CurrentCamera.CameraSubject = hum
                end
                root.Anchored = false
                root.Velocity  = Vector3.zero
                _G.candytpAntiRagdollFixes = (tonumber(_G.candytpAntiRagdollFixes) or 0) + 1
            end
        end)
        M.connections.charAdded = LocalPlayer.CharacterAdded:Connect(function(char)
            task.wait(1)
            M.forceBackpack()
            M.onCharacterAdded_AR(char)
        end)
        if LocalPlayer.Character then M.onCharacterAdded_AR(LocalPlayer.Character) end
        task.spawn(function()
            while M.running do
                task.wait(0.5)
                M.forceBackpack()
            end
        end)
    end

    M.disable = function()
        M.running = false
        for _, conn in pairs(M.connections) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        M.connections = {}
        pcall(function()
            local char = LocalPlayer.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,     true)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            end
        end)
    end
    return M
end)()

local function arStart()
    _G.candytpAntiRagdoll = true
    AntiRagdoll.enable()
    if _ADDON.save then pcall(_ADDON.save) end
end
local function arStop()
    _G.candytpAntiRagdoll = false
    AntiRagdoll.disable()
    if _ADDON.save then pcall(_ADDON.save) end
end

_G.candytpSetAntiRagdoll = function(v)
    if v then arStart() else arStop() end
end
_G.setAntiRagdoll = _G.candytpSetAntiRagdoll
_G.candytpAntiRagdollOn = function() return AntiRagdoll.running end
_G.candytpAntiRagdollState = AntiRagdoll

ui.antiRag.row:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
    task.defer(function()
        _G.candytpSetAntiRagdoll(ui.antiRag.getState())
    end)
end)
end -- ANTI RAGDOLL (сброс)

--@BLOCK RESET  (из «candytp meeok.txt»: INSTANT RESET, строки 401-682)
-- INSTA RESET (клавиша X) -- лежит своим do-блоком ниже
-- ================================================================
-- INSTA RESET  --  модуль 1:1 из «HEADLESS TP» (candytp meeok.txt)
--   Убить и респавнить, не дожидаясь обычной смерти:
--     * HipHeight 1e30 выбрасывает хуманоида из мира -- сервер считает это
--       void-смертью и респавнит сразу, а не через RespawnTime;
--     * Health = 0 -- страховка, если запуск поймали;
--     * НИКОГДА не убиваем в тот же кадр, что запуск (иначе падаем на месте);
--     * сидящего/на PlatformStand/заякоренного сначала расклинивают и
--       повторяют расклин каждый кадр -- одиночная запись срабатывает через раз;
--     * камера держится на месте, тело скрыто локально -- ресет не выглядит тормозом;
--     * флинг держится 0.4 с, затем провал под FallenPartsDestroyHeight 0.6 с,
--       затем добивание Health = 0 до респавна (таймаут 6 с);
--     * anti-die на время СТАВИТСЯ НА ПАУЗУ (suspend), тумблер и конфиг не трогаем;
--     * анти-рага тоже на паузе, чтобы не гасил скорость флинга;
--     * walk speed на время ресета выключается и возвращается как был.
--   Бинд: _G.candytpResetKey -> ResetKey из cKHub.json -> X (бейдж в панели).
--   API: _G.candytpInstaReset() / _G.candytpResetState() / _G.candytpResetLast()
--        _G.candytpResetBusy / _G.candytpResetCount / _G.candytpSetResetKey("K")
-- ================================================================
do
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP         = Players.LocalPlayer or Players.PlayerAdded:Wait()

    local FLING_TIME  = 0.4      -- how long to keep reapplying the launch
    local FLING_POWER = 50000
    local USE_VOID    = true     -- also drop below FallenPartsDestroyHeight
    local VOID_TIME   = 0.6
    local TIMEOUT     = 6
    local CAM_BIND    = "candytpInstaResetCam"

    local resetting, lastFire = false, -math.huge
    local state = {}
    local lastResult = "idle"

    local function keepAlivePause()

        -- anti-die: pause it without touching the player's toggle or config,
        -- otherwise the refill fights the backstop kill. suspend(0.01) in
        -- restore() lifts it again straight away.
        if _G.candytpAntiDie and _G.candytpAntiDie.suspend then
            pcall(function() _G.candytpAntiDie.suspend(FLING_TIME + VOID_TIME + TIMEOUT + 2) end)
        end
        -- анти-рага на время ресета молчит, чтобы не мешать флингу
        _G.candytpAntiRagdollPauseUntil = os.clock() + FLING_TIME + VOID_TIME + TIMEOUT + 2
        pcall(function() LP:SetAttribute("RagdollEndTime", 0) end)
        _G.candytpResetBusy = true      -- флаг: идёт ресет
    end

    local function restore()
        _G.candytpResetBusy = false
        _G.candytpAntiRagdollPauseUntil = 0        -- анти-рага снова работает
        if _G.candytpAntiDie and _G.candytpAntiDie.suspend then
            pcall(function() _G.candytpAntiDie.suspend(0.01) end)   -- lift the pause now
        end
        state = {}
    end

    local function stripTools(char, hum)
        if hum then pcall(function() hum:UnequipTools() end) end
        if not char then return end
        local bp = LP:FindFirstChild("Backpack") or LP:FindFirstChildOfClass("Backpack")
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") then
                if bp then pcall(function() t.Parent = bp end)
                else pcall(function() t:Destroy() end) end
            end
        end
    end

    local function hideLocally(obj)
        if obj:IsA("BasePart") or obj:IsA("Decal") then
            obj.LocalTransparencyModifier = 1
        end
    end

    local function run(char, hum, hrp)
        local RSv = RunService
        local homeHip = hum.HipHeight
        local homeCF = hrp and hrp.CFrame
        local hidden = {}

        keepAlivePause()
        stripTools(char, hum)

        -- Hold the camera where it is until the new character loads: the
        -- death cam swinging away is most of what makes a reset FEEL slow.
        local cam = workspace.CurrentCamera
        local frozen = cam and cam.CFrame
        local oldType = cam and cam.CameraType
        pcall(function()
            cam.CameraType = Enum.CameraType.Scriptable
            RSv:BindToRenderStep(CAM_BIND, Enum.RenderPriority.Camera.Value + 1, function()
                cam.CFrame = frozen
            end)
        end)

        -- Drop the body out of view on this client only.
        local function hide(obj)
            if obj:IsA("BasePart") or obj:IsA("Decal") then
                hidden[obj] = obj.LocalTransparencyModifier
                hideLocally(obj)
            end
        end
        local added
        pcall(function()
            for _, obj in ipairs(char:GetDescendants()) do pcall(hide, obj) end
            added = char.DescendantAdded:Connect(function(obj) pcall(hide, obj) end)
        end)

        -- Listen before killing -- the respawn can land before the next line.
        local newChar
        local respawned = LP.CharacterAdded:Connect(function(c) newChar = c end)

        local function unlock()
            pcall(function() hum.PlatformStand = false end)
            pcall(function() hum.Sit = false end)
            pcall(function() hum.AutoRotate = true end)
        end
        unlock()
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("BasePart") then
                pcall(function() obj.Anchored = false end)
                pcall(function() obj.CanCollide = false end)
            elseif obj.Name == "SeatWeld" then
                pcall(function() obj:Destroy() end)
            end
        end

        local started = os.clock()
        local function aliveHRP()
            if hrp and hrp.Parent then return hrp end
            hrp = hum.RootPart or char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Parent then return hrp end
            return nil
        end

        -- The launch, HELD. Velocity flings regardless of humanoid state,
        -- HipHeight needs the state machine -- both go in, neither kills.
        local flingUntil = os.clock() + FLING_TIME
        while not newChar and os.clock() < flingUntil and hum.Parent do
            unlock()
            pcall(function() hum.HipHeight = 1e30 end)
            local root = aliveHRP()
            if root then
                pcall(function() root.Anchored = false end)
                pcall(function() root.AssemblyLinearVelocity = Vector3.new(0, FLING_POWER, 0) end)
                pcall(function() root.Velocity = Vector3.new(0, FLING_POWER, 0) end)
            end
            RSv.Heartbeat:Wait()
        end
        if newChar or hum.Health <= 0 or not hum.Parent then
            lastResult = "launch"
        elseif USE_VOID then
            -- The launch has done its job; put the hip height back or the
            -- humanoid keeps pushing itself up and fights the drop below.
            pcall(function() hum.HipHeight = homeHip end)
            -- Out of the world, also held: one teleport gets reverted by a
            -- position check, a teleport every frame outruns it.
            local floor = -500
            pcall(function() floor = workspace.FallenPartsDestroyHeight end)
            local voidUntil = os.clock() + VOID_TIME
            while not newChar and os.clock() < voidUntil do
                local root = aliveHRP()
                if not root then break end
                pcall(function() root.CFrame = CFrame.new(0, floor - 500, 0) end)
                pcall(function() root.AssemblyLinearVelocity = Vector3.new(0, -FLING_POWER, 0) end)
                RSv.Heartbeat:Wait()
            end
            if newChar or hum.Health <= 0 or not hum.Parent then lastResult = "void" end
        end

        -- Backstop: keep killing until the respawn actually lands.
        while not newChar and os.clock() - started < TIMEOUT do
            pcall(function() hum.HipHeight = homeHip end)
            if hum.Parent then
                pcall(function() hum.Health = 0 end)
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Dead) end)
            end
            if char.Parent then pcall(function() char:BreakJoints() end) end
            task.wait(0.1)
        end
        if lastResult == "idle" then
            lastResult = newChar and "kill" or "failed"
        end

        pcall(function() respawned:Disconnect() end)
        if added then pcall(function() added:Disconnect() end) end
        if lastResult == "failed" then
            -- the body survived everything: put it back the way it was, so the
            -- player is not left invisible, launched or without a camera
            pcall(function() hum.HipHeight = homeHip end)
            local rootF = hum.RootPart or char:FindFirstChild("HumanoidRootPart")
            if rootF and homeCF then pcall(function() rootF.CFrame = homeCF end) end
            for obj, t in pairs(hidden) do
                if obj and obj.Parent then
                    pcall(function() obj.LocalTransparencyModifier = t or 0 end)
                end
            end
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
        end

        pcall(function() RSv:UnbindFromRenderStep(CAM_BIND) end)
        pcall(function()
            cam.CameraType = (oldType == Enum.CameraType.Scriptable)
                and Enum.CameraType.Custom or oldType
            if newChar then
                local newHum = newChar:FindFirstChildOfClass("Humanoid")
                    or newChar:WaitForChild("Humanoid", 5)
                if newHum then cam.CameraSubject = newHum end
            end
        end)
        restore()
    end

    _G.candytpInstaReset = function()
        if resetting then return false end
        if tick() - lastFire < 0.3 then return false end
        local char = LP.Character
        -- Acting on a stale or already-dead character is another way this ends
        -- up working only some of the time: it burns the whole budget flinging
        -- a corpse while holding the lock, so the next real press is swallowed.
        if not char or not char.Parent then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return false end
        local hrp = hum.RootPart or char:FindFirstChild("HumanoidRootPart")
        lastFire = tick()
        resetting = true
        lastResult = "idle"
        _G.candytpResetCount = (tonumber(_G.candytpResetCount) or 0) + 1
        _G.candytpResetLastChar = char

        task.spawn(function()
            local ok, err = pcall(run, char, hum, hrp)
            if not ok then
                warn("[HEADLESS TP][RESET] " .. tostring(err))
                pcall(restore)
            end
            resetting = false
        end)
        return true
    end
    _G.candytpResetState = function() return resetting end
    _G.candytpResetLast  = function() return lastResult end   -- "launch" | "void" | "kill" | "failed"
    _G.candytpResetBusy  = false
end

-- алиасы: прежние имена продолжают работать
_G.candytpReset        = _G.candytpInstaReset
_G.candytpInstantReset = _G.candytpInstaReset

-- ключ из конфига хаба (cKHub.json -> ResetKey) -- тот же, что в списке функций
local function hostKey()
    local k
    pcall(function()
        if isfile and isfile("cKHub.json") then
            local raw = readfile("cKHub.json")
            if raw and raw ~= "" then
                local d = HS:JSONDecode(raw)
                if type(d) == "table" and type(d.ResetKey) == "string" and d.ResetKey ~= "" then
                    k = d.ResetKey
                end
            end
        end
    end)
    return k
end

_G.setInstaReset = _G.candytpInstaReset
_G.candytpSetResetKey = function(k)
    if type(k) ~= "string" or k == "" then k = "X" end
    if not (Enum.KeyCode[k] or Enum.KeyCode[k:sub(1, 1):upper()]) then k = "X" end
    _G.candytpResetKey = k
    if ui.reset and ui.reset.setKey then pcall(ui.reset.setKey, k) end
    if _ADDON.save then pcall(_ADDON.save) end
end

-- бинд: своё значение -> иначе ключ из конфига хаба -> иначе X
if not _G.candytpResetKey then _G.candytpResetKey = hostKey() or "X" end
if ui.reset and ui.reset.setKey then pcall(ui.reset.setKey, _G.candytpResetKey) end

-- hotkey: _G.candytpResetKey wins, then ResetKey from cKHub.json, then X
do
    local UISr = game:GetService("UserInputService")

    local function keyFromName(name)
        if type(name) ~= "string" or name == "" then return nil end
        local ok, kc = pcall(function() return Enum.KeyCode[name] end)
        if ok and typeof(kc) == "EnumItem" then return kc end
        return nil
    end

    local function currentKey()
        return keyFromName(_G.candytpResetKey)
            or keyFromName(hostKey())
            or Enum.KeyCode.X
    end

    UISr.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == currentKey() then
            if _G.candytpInstaReset then pcall(_G.candytpInstaReset) end
        end
    end)
end

-- ==================== ПРИМЕНЕНИЕ СОХРАНЁННОГО =========================
_G.candytpAddon = {
    panel          = panel,
    setAntiDie     = _G.candytpSetAntiDie,
    setAntiRagdoll = _G.candytpSetAntiRagdoll,
    setUnwalk      = _G.candytpSetUnwalk,
    save           = _ADDON.save,
}

do -- клик по любому тумблеру тоже сохраняем (модуль отрабатывает следом)
    for _, T in pairs(ui) do
        local b = T.row and T.row:FindFirstChildOfClass("TextButton")
        if b then
            b.MouseButton1Click:Connect(function()
                task.defer(function()
                    task.wait()
                    _ADDON.save()
                end)
            end)
        end
    end
end

task.defer(function()
    local d = _ADDON.load() or {}

    if type(d.posX) == "number" and type(d.posY) == "number" then
        panel.Position = UDim2.new(0, d.posX, 0, d.posY)
        clampPos()
    end
    panel.Visible = true          -- окно всегда на экране, ярлыка-переключателя нет

    -- Anti Die: по умолчанию включён
    local ad = (d.antiDie == nil) and true or (d.antiDie == true)
    ui.antiDie.setState(ad)
    pcall(_G.candytpSetAntiDie, ad)

    -- Anti Ragdoll (сброс рэга): по умолчанию включён
    local fresh = (type(d.version) ~= "number")           -- старый конфиг -> берём новые умолчания
    local ar = fresh or (d.antiRagdoll ~= false)
    ui.antiRag.setState(ar)
    _G.candytpSetAntiRagdoll(ar)

    -- INSTA RESET: клавиша (своё значение из конфига аддона, иначе X / cKHub.json)
    if type(d.resetKey) == "string" and d.resetKey ~= "" and _G.candytpSetResetKey then
        pcall(_G.candytpSetResetKey, d.resetKey)
    end

    -- Unwalk: по умолчанию включён
    local uw = (d.unwalk == nil) and true or (d.unwalk == true)
    ui.unwalk.setState(uw)
    pcall(_G.candytpSetUnwalk, uw)


    _ADDON.save()
end)
-- =================== КОНЕЦ HEADLESS TP ADD-ON ==============================
end -- обёртка





-- Удалить старое окно выбора анимаций, если оно осталось после предыдущего запуска.
do
    local cleanupParent = game:GetService("CoreGui")
    local cleanupGetHui = rawget(_G, "gethui")
    if cleanupGetHui then
        local ok, result = pcall(cleanupGetHui)
        if ok and result then cleanupParent = result end
    end
end



-- =====================================================================

-- =====================================================================
do
    local Players=game:GetService("Players")
    local UIS=game:GetService("UserInputService")
    local RunService=game:GetService("RunService")
    local LP=Players.LocalPlayer
    local active=false
    local conns={}
    local savedCF=nil
    local savedHRP=nil
    local function release()
        active=false
        for _,c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        table.clear(conns)
    end
    _G.CKDropBrainrot=function()
        if active then return end
        local char=LP.Character; if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        active=true; savedCF=hrp.CFrame-hrp.CFrame.Position; savedHRP=hrp
        table.insert(conns,RunService.Stepped:Connect(function()
            if active and hrp.Parent then
                hrp.CFrame=CFrame.new(hrp.Position)*savedCF
                hrp.RotVelocity=Vector3.zero
            end
        end))
        task.spawn(function()
            while active do
                RunService.Heartbeat:Wait(); if not hrp.Parent then break end
                local v=hrp.Velocity
                hrp.Velocity=v*10000+Vector3.new(0,10000,0)
                RunService.RenderStepped:Wait(); if hrp.Parent then hrp.Velocity=v end
                RunService.Stepped:Wait(); if hrp.Parent then hrp.Velocity=v+Vector3.new(0,0.1,0) end
            end
        end)
        task.delay(0.4,function()
            release(); task.wait(0.05)
            if savedHRP and savedHRP.Parent and savedCF then
                pcall(function()
                    savedHRP.CFrame=CFrame.new(savedHRP.Position)*savedCF
                    savedHRP.RotVelocity=Vector3.zero
                end)
            end
        end)
    end
    _G.dropBrainrot=_G.CKDropBrainrot
    UIS.InputBegan:Connect(function(input,gp)
        if gp then return end
        local key=Enum.KeyCode[tostring(i.DropBrainrotKey or "R")] or Enum.KeyCode.R
        if input.KeyCode==key then task.spawn(_G.CKDropBrainrot) end
    end)
end

-- =====================================================================
-- HEADLESS TP  |  .gg/candytp
-- Pink + black animated theme engine (PC + mobile)
-- Rounded corners, animated gradients, smooth hover/press/pop animations,
-- auto-fit scaling for phones, floating toggle button, branding.
-- =====================================================================
;(function()
    if _G.__candytpThemeCleanup then
        pcall(_G.__candytpThemeCleanup)
    end

    local Players   = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UIS       = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local CoreGui   = game:GetService("CoreGui")
    local LPlr      = Players.LocalPlayer

    local alive = true
    local conns = {}
    local function track(c) conns[#conns + 1] = c return c end

    local Theme = {
        black    = Color3.fromRGB(10, 4, 8),
        panel    = Color3.fromRGB(16, 8, 14),
        row      = Color3.fromRGB(28, 12, 22),
        row2     = Color3.fromRGB(40, 16, 30),
        edge     = Color3.fromRGB(180, 60, 140),
        text     = Color3.fromRGB(255, 240, 250),
        dim      = Color3.fromRGB(220, 150, 190),
        switchOff= Color3.fromRGB(50, 20, 40),
        knob     = Color3.fromRGB(255, 182, 193),
        knobOn   = Color3.fromRGB(255, 240, 250),
    }

    -- animated pink palette -------------------------------------------
    local PAL = {
        Color3.fromRGB(255, 20, 147),
        Color3.fromRGB(255, 105, 180),
        Color3.fromRGB(255, 182, 193),
        Color3.fromRGB(255, 0, 127),
        Color3.fromRGB(219, 112, 147),
    }
    local function palAt(t)
        local n = #PAL
        local x = (t % n)
        local i = math.floor(x)
        local f = x - i
        f = f * f * (3 - 2 * f)
        return PAL[i + 1]:Lerp(PAL[(i + 1) % n + 1], f)
    end
    local ACC, ACC_DIM, ACC_SOFT = PAL[1], PAL[1], PAL[1]

    local function lerpC(a, b, k) return a:Lerp(b, k) end

    -- animated gradient colour sequence (orange -> black -> orange)
    local function seqFor(t)
        local c1 = palAt(t)
        local c2 = palAt(t + 1.5)
        local blk = Color3.fromRGB(10, 7, 4)
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, c1),
            ColorSequenceKeypoint.new(0.35, blk),
            ColorSequenceKeypoint.new(0.65, c2),
            ColorSequenceKeypoint.new(1.00, blk),
        })
    end
    local function seqBrand(t)
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, palAt(t)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 232, 200)),
            ColorSequenceKeypoint.new(1.00, palAt(t + 2)),
        })
    end

    -- state registries ---------------------------------------------------
    local majors   = setmetatable({}, {__mode = "k"})  -- frames: {scale=UIScale, pop, base}
    local strokes  = setmetatable({}, {__mode = "k"})  -- UIStroke -> {grad=UIGradient}
    local buttons  = setmetatable({}, {__mode = "k"})  -- TextButton -> {sc, tgt, cur, stroke}
    local statefuls= setmetatable({}, {__mode = "k"})  -- objects driven by on/off
    local brandTxt = setmetatable({}, {__mode = "k"})  -- gradient-text labels
    local watched  = {}

    local MAJOR_NAMES = {
        topbar = true, panel = true, bar = true, optimizerwindow = true,
        currenttargethud = true, targetcontrolsframe = true,
    }

    local function isMobile()
        return UIS.TouchEnabled and not UIS.KeyboardEnabled
    end
    local function viewport()
        local cam = workspace.CurrentCamera
        return cam and cam.ViewportSize or Vector2.new(1280, 720)
    end

    -- rounding ------------------------------------------------------------
    local function cornerFor(obj, major)
        -- curved smaller style
        if major then return 12 end
        local h = obj.AbsoluteSize.Y
        if h > 0 and h <= 10 then return 6 end
        if h > 0 and h <= 28 then return 8 end
        return 10
    end

    local function ensureCorner(obj, major)
        local c = obj:FindFirstChildOfClass("UICorner")
        if not c then
            c = Instance.new("UICorner")
            c.Name = "HTP_Corner"
            c.Parent = obj
        end
        c.CornerRadius = UDim.new(0, 10)
    end

    local function isFullscreen(obj)
        local s = obj.Size
        return s.X.Scale >= 0.98 and s.Y.Scale >= 0.98
    end

    -- strokes get an animated orange/black rotating gradient --------------
    local function decorateStroke(st, major)
        if strokes[st] then return end
        local g = st:FindFirstChildOfClass("UIGradient")
        if not g then
            g = Instance.new("UIGradient")
            g.Name = "HTP_StrokeGrad"
            g.Parent = st
        end
        strokes[st] = {grad = g, major = major and true or false}
        if major then
            st.Thickness = math.max(st.Thickness, 1.6)
            st.Transparency = 0.1
        else
            st.Transparency = math.max(st.Transparency, 0.45)
        end
        st.Color = Color3.new(1, 1, 1)
    end

    local function mkScale(obj)
        local sc = obj:FindFirstChild("HTP_Scale")
        if not sc then
            sc = Instance.new("UIScale")
            sc.Name = "HTP_Scale"
            sc.Parent = obj
        end
        return sc
    end

    local function registerMajor(obj)
        if majors[obj] then return end
        majors[obj] = {scale = mkScale(obj), pop = 0.82, base = 1}
        ensureCorner(obj, true)
        local st = obj:FindFirstChildOfClass("UIStroke")
        if not st then
            st = Instance.new("UIStroke")
            st.Name = "HTP_Border"
            st.Thickness = 1.6
            st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            st.Parent = obj
        end
        decorateStroke(st, true)
        -- soft animated background glow gradient (keeps panel readable)
        if not obj:FindFirstChild("HTP_BgGrad") and not obj:FindFirstChildOfClass("UIGradient") then
            local bg = Instance.new("UIGradient")
            bg.Name = "HTP_BgGrad"
            bg.Rotation = 90
            bg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 12, 22)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 4, 8)),
            })
            bg.Parent = obj
        end
    end

    -- buttons: hover / press animation -----------------------------------
    local function registerButton(b)
        if buttons[b] then return end
        if b.Name == "Click" or (b.Size.X.Scale == 0 and b.Size.X.Offset < 14) then
            -- full-row invisible click layers: keep, but no scale
            buttons[b] = {skip = true}
            return
        end
        if b.BackgroundTransparency >= 1 then buttons[b] = {skip = true} return end
        local sc = b:FindFirstChild("HTP_BtnScale")
        if not sc then
            sc = Instance.new("UIScale")
            sc.Name = "HTP_BtnScale"
            sc.Parent = b
        end
        local rec = {sc = sc, tgt = 1, cur = 1}
        buttons[b] = rec
        ensureCorner(b, false)
        local stk = b:FindFirstChildOfClass("UIStroke")
        if stk then decorateStroke(stk, false) end
        track(b.MouseEnter:Connect(function() rec.tgt = 1.05 end))
        track(b.MouseLeave:Connect(function() rec.tgt = 1 end))
        track(b.MouseButton1Down:Connect(function() rec.tgt = 0.93 end))
        track(b.MouseButton1Up:Connect(function() rec.tgt = UIS.TouchEnabled and 1 or 1.05 end))
        track(b.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch then rec.tgt = 1 end
        end))
    end

    -- main paint (static things, run once per object) --------------------
    local function paint(obj)
        if obj.Name:sub(1, 4) == "HTP_" then return end
        local n = string.lower(obj.Name or "")

        if obj:IsA("UICorner") then
            return -- sized by owner
        end

        if obj:IsA("TextButton") then
            obj.TextColor3 = obj.TextColor3 -- keep script-defined colour
            registerButton(obj)
            return
        end

        if obj:IsA("TextBox") then
            ensureCorner(obj, false)
            return
        end

        if obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
            if obj:GetAttribute("__candytpAccent") then
                ensureCorner(obj, false)
                statefuls[obj] = "accent"
            elseif obj:GetAttribute("__candytpSwitch") then
                obj.BackgroundTransparency = 0
                ensureCorner(obj, false)
                obj:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(1, 0)
                statefuls[obj] = "switch"
            elseif obj:GetAttribute("__candytpSwitchKnob") then
                local c = obj:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", obj)
                c.CornerRadius = UDim.new(0, 10)
                statefuls[obj] = "knob"
            elseif obj:GetAttribute("__candytpSliderFill") then
                ensureCorner(obj, false)
                obj:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(1, 0)
                statefuls[obj] = "sliderfill"
            elseif obj:GetAttribute("__candytpSliderKnob") then
                local c = obj:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", obj)
                c.CornerRadius = UDim.new(0, 10)
                statefuls[obj] = "sliderknob"
            elseif MAJOR_NAMES[n] or (obj.Parent and obj.Parent:IsA("ScreenGui") and not isFullscreen(obj)
                    and obj.BackgroundTransparency < 1) then
                registerMajor(obj)
            elseif obj.BackgroundTransparency < 1 and not isFullscreen(obj) then
                if n == "slidertrack" or n == "track" or n == "progressfill" or n == "sliderfill" then
                    ensureCorner(obj, false)
                    obj:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(0, 10)
                else
                    ensureCorner(obj, false)
                end
            end
            return
        end

        if obj:IsA("UIStroke") then
            local p = obj.Parent
            local pn = p and string.lower(p.Name) or ""
            if not strokes[obj] then
                decorateStroke(obj, MAJOR_NAMES[pn] or false)
            end
            return
        end

        if obj:IsA("TextLabel") then
            local t = obj.Text or ""
            if t:find("HEADLESS", 1, true) then
                brandTxt[obj] = true
                obj.TextColor3 = Color3.new(1, 1, 1)
                local g = obj:FindFirstChild("HTP_TextGrad") or Instance.new("UIGradient")
                g.Name = "HTP_TextGrad"
                g.Parent = obj
            end
            return
        end
    end

    local function paintTree(root)
        pcall(paint, root)
        for _, o in ipairs(root:GetDescendants()) do
            pcall(paint, o)
        end
    end

    -- roots ----------------------------------------------------------------
    local rootNames = {
        "cJPcVLFpwxgI", "bRXgmsaEVfze", "kzBUJxAKwhtf",
        "__candytpOptimizerGUI", "XiBottomStatus", "__PodiumNextBaseGUI",
        "candytpAddonGUI", "CastaDarkSettingsGUI",
        "CastaPubIntroGUI", "XiPriorityAlertTest", "XiInfJump", "lMWjwEoSnCPj",
    }

    local function containers()
        local out = {CoreGui}
        local pg = LPlr and LPlr:FindFirstChild("PlayerGui")
        if pg then table.insert(out, pg) end
        local ok, hui = pcall(function() return gethui and gethui() end)
        if ok and hui and hui ~= CoreGui then table.insert(out, hui) end
        return out
    end

    local function attachRoot(root)
        if watched[root] then return end
        watched[root] = true
        paintTree(root)
        track(root.DescendantAdded:Connect(function(o)
            task.defer(function()
                if alive and o and o.Parent then
                    pcall(paint, o)
                            end
            end)
        end))
    end

    -- branding gui: watermark + floating toggle ---------------------------
    local brandGui = Instance.new("ScreenGui")
    brandGui.Name = "candytpBrandGUI"
    brandGui.ResetOnSpawn = false
    brandGui.IgnoreGuiInset = true
    brandGui.DisplayOrder = 1000
    brandGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    do
        local ok = pcall(function() brandGui.Parent = (gethui and gethui()) or CoreGui end)
        if not ok or not brandGui.Parent then
            brandGui.Parent = LPlr:WaitForChild("PlayerGui")
        end
    end

    -- watermark pill (bottom centre)
    local mark = Instance.new("Frame")
    mark.Name = "HTP_Watermark"
    mark.AnchorPoint = Vector2.new(0, 1)
    mark.Position = UDim2.new(0, 12, 1, -12)
    mark.Size = UDim2.fromOffset(210, 26)
    mark.BackgroundColor3 = Theme.black
    mark.BackgroundTransparency = 0.15
    mark.BorderSizePixel = 0
    mark.Parent = brandGui
    do
        local c = Instance.new("UICorner", mark) c.CornerRadius = UDim.new(0, 10)
        local s = Instance.new("UIStroke", mark) s.Thickness = 1.5
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Name = "HTP_WMStroke"
        local l = Instance.new("TextLabel", mark)
        l.Name = "HTP_WMText"
        l.BackgroundTransparency = 1
        l.Size = UDim2.fromScale(1, 1)
        l.Font = Enum.Font.GothamBlack
        l.TextSize = 11
        l.Text = "candy tp - discord.gg/usYtFqxQdN"
        l.TextColor3 = Color3.new(1, 1, 1)
        local g = Instance.new("UIGradient", l) g.Name = "HTP_TextGrad"
        brandTxt[l] = true
        decorateStroke(s, true)
    end

    -- floating toggle button (works with touch + mouse)
    local fab = Instance.new("TextButton")
    fab.Name = "HTP_Toggle"
    fab.Size = UDim2.fromOffset(44, 44)
    fab.AnchorPoint = Vector2.new(0, 0)
    fab.Position = UDim2.new(0, 10, 0.5, -22)
    fab.BackgroundColor3 = Theme.black
    fab.AutoButtonColor = false
    fab.Text = "C"
    fab.Font = Enum.Font.GothamBlack
    fab.TextSize = 20
    fab.TextColor3 = Color3.fromRGB(255, 105, 180)
    fab.BorderSizePixel = 0
    fab.Parent = brandGui
    do
        local c = Instance.new("UICorner", fab) c.CornerRadius = UDim.new(0, 10)
        local s = Instance.new("UIStroke", fab)
        s.Thickness = 2
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        decorateStroke(s, true)
        registerButton(fab)
        -- drag the button, tap to toggle
        local dragging, moved, startIn, startPos = false, false, nil, nil
        track(fab.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging, moved = true, false
                startIn, startPos = i.Position, fab.Position
            end
        end))
        track(UIS.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local d = i.Position - startIn
                if d.Magnitude > 6 then moved = true end
                if moved then
                    fab.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                        startPos.Y.Scale, startPos.Y.Offset + d.Y)
                end
            end
        end))
        track(UIS.InputEnded:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
                dragging = false
            end
        end))
        local hidden = false
        local toggleNames = {"__PodiumNextBaseGUI", "candytpAddonGUI"}
        local function setHidden(h)
            hidden = h
            for _, cont in ipairs(containers()) do
                for _, nm in ipairs(toggleNames) do
                    local g = cont:FindFirstChild(nm)
                    if g and g:IsA("ScreenGui") then g.Enabled = not hidden end
                end
            end
            fab.Text = hidden and "+" or "C"
        end
        track(fab.MouseButton1Click:Connect(function()
            if not moved then setHidden(not hidden) end
        end))
        track(UIS.InputBegan:Connect(function(i, gp)
            if gp then return end
            if i.KeyCode == Enum.KeyCode.RightShift then setHidden(not hidden) end
        end))
        _G.candytpToggleUI = function() setHidden(not hidden) end
    end


    -- mobile bottom stack: toolbar -> status banner -> steal progress bar -------
    local stack = {on = false}
    local curOff = setmetatable({}, {__mode = "k"})

    local function toolbarHeight()
        local h
        pcall(function()
            local rg = CoreGui:FindFirstChild("RobloxGui")
            local bp = rg and rg:FindFirstChild("Backpack")
            local hb = bp and bp:FindFirstChild("Hotbar")
            if hb and hb.Visible and hb.AbsoluteSize.Y > 8 then
                h = viewport().Y - hb.AbsolutePosition.Y
            end
        end)
        if h and h > 20 and h < 220 then return h end
        return nil
    end

    local function updateStackTargets()
        if not isMobile() then stack.on = false return end
        local bar, hud
        for _, cont in ipairs(containers()) do
            local sg = cont:FindFirstChild("XiBottomStatus")
            if sg then bar = sg:FindFirstChild("Bar") or bar end
            local hg = cont:FindFirstChild("bRXgmsaEVfze")
            if hg then hud = hg:FindFirstChild("CurrentTargetHUD") or hud end
        end
        stack.bar, stack.hud = bar, hud
        local top = toolbarHeight() or 72
        local gap = 8
        local barH = (bar and bar.AbsoluteSize.Y > 0) and bar.AbsoluteSize.Y or 40
        stack.tBar = top + gap
        stack.tHud = top + gap + barH + gap
        stack.on = true
    end

    local function easeStack(k)
        if not stack.on then return end
        local function ease(obj, target)
            if not obj or not obj.Parent or not target then return end
            local p = obj.Position
            local cur = curOff[obj]
            if not cur then cur = p.Y.Offset end
            cur = cur + (-target - cur) * k
            curOff[obj] = cur
            obj.Position = UDim2.new(0.5, 0, 1, cur)
        end
        ease(stack.bar, stack.tBar)
        ease(stack.hud, stack.tHud)
    end

    -- "no brainrots in bases" notice ------------------------------------------
    local alertState = {armed = true, emptySince = nil, ui = nil, iconScale = nil, btn = nil, t0 = os.clock()}

    local function animalCount()
        local P = _G.__candytp_State
        if not P then return nil end
        local c = P.AllAnimalsCache
        if type(c) == "table" then return #c end
        return 0
    end

    local function showNoBrainrotAlert()
        if alertState.ui and alertState.ui.Parent then return end
        local sg = Instance.new("ScreenGui")
        sg.Name = "candytpAlertGUI"
        sg.ResetOnSpawn = false
        sg.IgnoreGuiInset = true
        sg.DisplayOrder = 2000
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        sg.Parent = brandGui.Parent
        alertState.ui = sg

        local dim = Instance.new("Frame")
        dim.Name = "Dim"
        dim.Size = UDim2.fromScale(1, 1)
        dim.BackgroundColor3 = Color3.new(0, 0, 0)
        dim.BackgroundTransparency = 1
        dim.BorderSizePixel = 0
        dim.Active = true
        dim.Parent = sg

        local W, H = 380, 292
        local card = Instance.new("CanvasGroup")
        card.Name = "Card"
        card.AnchorPoint = Vector2.new(0.5, 0.5)
        card.Position = UDim2.fromScale(0.5, 0.5)
        card.Size = UDim2.fromOffset(W, H)
        card.BackgroundTransparency = 1
        card.BorderSizePixel = 0
        card.GroupTransparency = 1
        card.Parent = sg
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
        -- gradient lives on a background layer: a UIGradient directly on a
        -- CanvasGroup would tint (darken) every child, including the text
        local bgLayer = Instance.new("Frame")
        bgLayer.Name = "Bg"
        bgLayer.ZIndex = 0
        bgLayer.Size = UDim2.fromScale(1, 1)
        bgLayer.BackgroundColor3 = Color3.new(1, 1, 1)
        bgLayer.BorderSizePixel = 0
        bgLayer.Parent = card
        Instance.new("UICorner", bgLayer).CornerRadius = UDim.new(0, 10)
        local bgg = Instance.new("UIGradient", bgLayer)
        bgg.Rotation = 90
        bgg.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 20, 45)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 8, 14)),
        })
        local cst = Instance.new("UIStroke", card)
        cst.Thickness = 2
        cst.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        decorateStroke(cst, true)

        local csc = Instance.new("UIScale", card)
        local vp = viewport()
        local fit = math.clamp(math.min(vp.X * 0.92 / W, vp.Y * 0.92 / H), 0.5, 1.1)
        csc.Scale = fit * 0.8

        -- icon
        local icon = Instance.new("Frame")
        icon.AnchorPoint = Vector2.new(0.5, 0)
        icon.Position = UDim2.new(0.5, 0, 0, 20)
        icon.Size = UDim2.fromOffset(54, 54)
        icon.BackgroundColor3 = ACC
        icon.BorderSizePixel = 0
        icon.Parent = card
        Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 10)
        local isc = Instance.new("UIScale", icon)
        local il = Instance.new("TextLabel")
        il.BackgroundTransparency = 1
        il.Size = UDim2.fromScale(1, 1)
        il.Font = Enum.Font.GothamBlack
        il.TextSize = 32
        il.Text = "!"
        il.TextColor3 = Color3.fromRGB(14, 6, 12)
        il.Parent = icon
        alertState.iconScale = isc
        alertState.icon = icon

        local tag = Instance.new("TextLabel")
        tag.BackgroundTransparency = 1
        tag.Position = UDim2.new(0, 0, 0, 82)
        tag.Size = UDim2.new(1, 0, 0, 14)
        tag.Font = Enum.Font.GothamBlack
        tag.TextSize = 11
        tag.Text = "candy tp  •  NOTICE"
        tag.TextColor3 = Color3.new(1, 1, 1)
        tag.Parent = card
        Instance.new("UIGradient", tag).Name = "HTP_TextGrad"
        brandTxt[tag] = true

        local title = Instance.new("TextLabel")
        title.BackgroundTransparency = 1
        title.Position = UDim2.new(0, 16, 0, 100)
        title.Size = UDim2.new(1, -32, 0, 28)
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 21
        title.Text = "NO BRAINROTS IN BASES"
        title.TextColor3 = Theme.text
        title.TextScaled = false
        title.Parent = card

        local body = Instance.new("TextLabel")
        body.BackgroundTransparency = 1
        body.Position = UDim2.new(0, 24, 0, 134)
        body.Size = UDim2.new(1, -48, 0, 82)
        body.Font = Enum.Font.GothamMedium
        body.TextSize = 14
        body.TextWrapped = true
        body.TextYAlignment = Enum.TextYAlignment.Top
        body.TextColor3 = Theme.dim
        body.Text = "Auto grab may fail because there are no brainrots in any base right now. The steal bar can keep showing the last scanned brainrot. Wait for brainrots to spawn, or hop to another server."
        body.Parent = card

        local ok = Instance.new("TextButton")
        ok.Name = "Understand"
        ok.AnchorPoint = Vector2.new(0.5, 1)
        ok.Position = UDim2.new(0.5, 0, 1, -18)
        ok.Size = UDim2.new(1, -44, 0, 54)
        ok.BackgroundColor3 = ACC
        ok.AutoButtonColor = false
        ok.BorderSizePixel = 0
        ok.Font = Enum.Font.GothamBlack
        ok.TextSize = 17
        ok.Text = "I UNDERSTAND"
        ok.TextColor3 = Color3.fromRGB(14, 6, 12)
        ok.Parent = card
        registerButton(ok)
        ok:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(0, 10)
        alertState.btn = ok

        -- sound
        pcall(function()
            local snd = Instance.new("Sound")
            snd.SoundId = "rbxassetid://6518811702"
            snd.Volume = 1
            snd.Parent = sg
            snd:Play()
        end)

        -- smooth open
        local ti = TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        TweenService:Create(csc, ti, {Scale = fit}):Play()
        TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {GroupTransparency = 0}):Play()
        TweenService:Create(dim, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.45}):Play()

        local closing = false
        ok.MouseButton1Click:Connect(function()
            if closing then return end
            closing = true
            alertState.iconScale = nil
            local to = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            TweenService:Create(csc, to, {Scale = fit * 0.85}):Play()
            TweenService:Create(card, to, {GroupTransparency = 1}):Play()
            local t = TweenService:Create(dim, to, {BackgroundTransparency = 1})
            t:Play()
            t.Completed:Wait()
            alertState.btn = nil
            pcall(function() sg:Destroy() end)
        end)
    end

    local function checkNoBrainrots()
        local n = animalCount()
        if n == nil then return end
        if n > 0 then
            alertState.armed = true
            alertState.emptySince = nil
            return
        end
        -- wait for the game to load, and for the plots to exist
        if os.clock() - alertState.t0 < 12 then return end
        if not workspace:FindFirstChild("Plots") then return end
        alertState.emptySince = alertState.emptySince or os.clock()
        -- keep the (stale) steal bar honest while there is nothing to steal
        pcall(function()
            for _, cont in ipairs(containers()) do
                local hg = cont:FindFirstChild("bRXgmsaEVfze")
                local hud = hg and hg:FindFirstChild("CurrentTargetHUD")
                local nm = hud and hud:FindFirstChild("TargetName")
                if nm and nm.Text ~= "No brainrots in bases" then nm.Text = "No brainrots in bases" end
            end
        end)
        if alertState.armed and os.clock() - alertState.emptySince >= 5 then
            alertState.armed = false
            showNoBrainrotAlert()
        end
    end

    -- main loop ------------------------------------------------------------
    local t0 = os.clock()
    local acc = 0
    local scanAcc = 0
    local lastVP = Vector2.zero

    local function refit()
        local vp = viewport()
        local mobile = isMobile()
        for f, rec in pairs(majors) do
            if f.Parent then
                local base = 1
                local sc = rec.scale
                local cur = sc.Scale
                local w = f.AbsoluteSize.X / math.max(cur, 0.01)
                local h = f.AbsoluteSize.Y / math.max(cur, 0.01)
                local maxW = vp.X * (mobile and 0.94 or 0.98)
                local maxH = vp.Y * 0.9
                if w > maxW then base = math.min(base, maxW / w) end
                if h > maxH then base = math.min(base, maxH / h) end
                rec.base = base
            end
        end
        local fabScale = mobile and 1.1 or 1
        fab.Size = UDim2.fromOffset(38 * fabScale, 38 * fabScale)
        mark.Visible = not mobile
    end

    track(RunService.RenderStepped:Connect(function(dt)
        if not alive then return end
        local now = os.clock() - t0
        acc += dt
        scanAcc += dt

        -- throttle heavy colour work to ~45 fps; easing runs every frame
        local doColor = acc >= (1 / 45)
        if doColor then acc = 0 end

        if scanAcc >= 1 then
            scanAcc = 0
            for _, cont in ipairs(containers()) do
                for _, nm in ipairs(rootNames) do
                    local r = cont:FindFirstChild(nm)
                    if r then attachRoot(r) end
                end
            end
            local vp = viewport()
            if (vp - lastVP).Magnitude > 1 then lastVP = vp end
            refit()
            pcall(updateStackTargets)
            pcall(checkNoBrainrots)
        end

        -- smooth button hover/press
        local k = math.min(1, dt * 16)
        for b, rec in pairs(buttons) do
            if rec.sc then
                if not b.Parent then
                    buttons[b] = nil
                else
                    rec.cur = rec.cur + (rec.tgt - rec.cur) * k
                    rec.sc.Scale = rec.cur
                end
            end
        end

        -- smooth pop-in + fit scale for panels
        local kp = math.min(1, dt * 9)
        for f, rec in pairs(majors) do
            rec.pop = rec.pop + (1 - rec.pop) * kp
            rec.scale.Scale = rec.base * rec.pop
        end

        easeStack(math.min(1, dt * 8))

        if not doColor then return end

        ACC = palAt(now * 0.6)
        ACC_DIM = ACC:Lerp(Color3.fromRGB(30, 10, 22), 0.45)
        ACC_SOFT = ACC:Lerp(Color3.fromRGB(30, 10, 22), 0.7)
        local seq = seqFor(now * 0.5)
        local rot = (now * 70) % 360
        local bseq = seqBrand(now * 0.8)
        local off = Vector2.new(math.sin(now * 1.4) * 0.35, 0)

        for st, rec in pairs(strokes) do
            local g = rec.grad
            if not st.Parent or not g.Parent then
                strokes[st] = nil
            else
                g.Color = seq
                g.Rotation = rot
            end
        end

        for lbl in pairs(brandTxt) do
            if lbl.Parent then
                local g = lbl:FindFirstChild("HTP_TextGrad")
                if g then g.Color = bseq g.Offset = off end
            else
                brandTxt[lbl] = nil
            end
        end

        -- on/off driven objects (eased so they fade rather than snap)
        local ke = 0.28
        for o, kind in pairs(statefuls) do
            if not o.Parent then
                statefuls[o] = nil
            else
                local target
                if kind == "accent" then
                    target = (o:GetAttribute("__candytpAccentOn") ~= false) and ACC or Theme.edge
                elseif kind == "switch" then
                    target = (o:GetAttribute("__candytpSwitchOn") == true) and ACC_DIM or Theme.switchOff
                elseif kind == "knob" then
                    local p = o.Parent
                    target = (p and p:GetAttribute("__candytpSwitchOn") == true) and Theme.knobOn or Theme.knob
                elseif kind == "sliderfill" then
                    target = ACC
                elseif kind == "sliderknob" then
                    target = Theme.knobOn
                end
                if target then
                    o.BackgroundColor3 = o.BackgroundColor3:Lerp(target, ke)
                end
            end
        end

        -- ON/active buttons pulse with the accent colour
        for b, rec in pairs(buttons) do
            if rec.sc and b.Parent then
                local active = b:GetAttribute("candytpActive")
                local txt = string.upper(tostring(b.Text or ""))
                if active == nil then
                    if txt:find(": ON", 1, true) or txt == "ON" then active = true
                    elseif txt:find(": OFF", 1, true) or txt == "OFF" then active = false end
                end
                if active ~= nil and b.BackgroundTransparency < 1 then
                    local target = active and ACC_DIM or Theme.row2
                    b.BackgroundColor3 = b.BackgroundColor3:Lerp(target, ke)
                    b.TextColor3 = Theme.text
                end
            end
        end

        fab.TextColor3 = ACC
        if alertState.iconScale and alertState.iconScale.Parent then
            alertState.iconScale.Scale = 1 + 0.07 * math.sin(now * 4)
            if alertState.icon then alertState.icon.BackgroundColor3 = ACC end
        end
        if alertState.btn and alertState.btn.Parent then
            alertState.btn.BackgroundColor3 = ACC
        end
    end))

    track(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(refit))
    pcall(function()
        track(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(refit))
    end)

    _G.__candytpThemeCleanup = function()
        alive = false
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        pcall(function() brandGui:Destroy() end)
        _G.__candytpThemeCleanup = nil
    end
end)()
